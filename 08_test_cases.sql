EXEC HMS_PKG.assign_room(1, 'DELUXE');
EXEC HMS_PKG.assign_room(2, 'STANDARD');
EXEC HMS_PKG.add_service_order(1, 1);
EXEC HMS_PKG.add_service_order(1, 2);
EXEC HMS_PKG.add_service_order(2, 3);
UPDATE customers SET check_out = SYSDATE + 2 WHERE cust_id = 1;
DECLARE
    v_bill NUMBER;
BEGIN
    v_bill := HMS_PKG.calculate_bill(1);
    DBMS_OUTPUT.PUT_LINE('Final Bill for Rahul: Rs. ' || v_bill);
END;
/
SELECT HMS_PKG.total_revenue FROM dual;
SELECT HMS_PKG.occupancy_rate FROM dual;
EXEC HMS_PKG.daily_revenue_report;
EXEC HMS_PKG.show_room_assignments;