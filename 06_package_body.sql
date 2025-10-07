CREATE OR REPLACE PACKAGE BODY HMS_PKG AS
CREATE OR REPLACE PACKAGE BODY HMS_PKG AS

    -- Custom exceptions
    e_no_room_available EXCEPTION;
    e_customer_not_found EXCEPTION;
    e_service_not_found EXCEPTION;

    ------------------------------------------------------------------------
    -- Procedure: Assign Room
    ------------------------------------------------------------------------
    PROCEDURE assign_room(p_cust_id NUMBER, p_room_type VARCHAR2) AS
        v_room_id rooms.room_id%TYPE;
        v_dummy NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_dummy FROM customers WHERE cust_id = p_cust_id;
        IF v_dummy = 0 THEN
            RAISE e_customer_not_found;
        END IF;

        SELECT room_id INTO v_room_id
        FROM rooms
        WHERE room_type = p_room_type AND is_available = 'Y'
        FETCH FIRST 1 ROWS ONLY;

        UPDATE rooms SET is_available = 'N' WHERE room_id = v_room_id;
        UPDATE customers SET room_id = v_room_id WHERE cust_id = p_cust_id;

        DBMS_OUTPUT.PUT_LINE('Room ' || v_room_id || ' assigned to customer ' || p_cust_id);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No available room of type ' || p_room_type);
        WHEN e_customer_not_found THEN
            DBMS_OUTPUT.PUT_LINE('Customer ID ' || p_cust_id || ' not found!');
    END assign_room;

    ------------------------------------------------------------------------
    -- Function: Calculate Bill
    ------------------------------------------------------------------------
    FUNCTION calculate_bill(p_cust_id NUMBER) RETURN NUMBER IS
        v_checkin DATE;
        v_checkout DATE;
        v_days NUMBER;
        v_room_id NUMBER;
        v_rate NUMBER := 0;
        v_room_total NUMBER;
        v_service_total NUMBER := 0;
        v_total NUMBER;
    BEGIN
        SELECT check_in, check_out, room_id
        INTO v_checkin, v_checkout, v_room_id
        FROM customers
        WHERE cust_id = p_cust_id;

        v_days := NVL(v_checkout - v_checkin, 1);

        SELECT CASE room_type
                  WHEN 'DELUXE' THEN 3000
                  WHEN 'STANDARD' THEN 2000
                  ELSE 1500
               END
        INTO v_rate
        FROM rooms
        WHERE room_id = v_room_id;

        v_room_total := v_days * v_rate;

        SELECT NVL(SUM(s.service_rate),0)
        INTO v_service_total
        FROM service_orders o
        JOIN services s ON o.service_id = s.service_id
        WHERE o.cust_id = p_cust_id;

        v_total := v_room_total + v_service_total;

        INSERT INTO billing(bill_id, cust_id, total_amount)
        VALUES (billing_seq.NEXTVAL, p_cust_id, v_total);

        RETURN v_total;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Customer ID ' || p_cust_id || ' not found!');
            RETURN 0;
    END calculate_bill;

    ------------------------------------------------------------------------
    -- Procedure: Add Service Order
    ------------------------------------------------------------------------
    PROCEDURE add_service_order(p_cust_id NUMBER, p_service_id NUMBER) AS
        v_dummy NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_dummy FROM customers WHERE cust_id = p_cust_id;
        IF v_dummy = 0 THEN
            RAISE e_customer_not_found;
        END IF;

        SELECT COUNT(*) INTO v_dummy FROM services WHERE service_id = p_service_id;
        IF v_dummy = 0 THEN
            RAISE e_service_not_found;
        END IF;

        INSERT INTO service_orders(order_id, cust_id, service_id)
        VALUES (order_seq.NEXTVAL, p_cust_id, p_service_id);

        DBMS_OUTPUT.PUT_LINE(' Service ' || p_service_id || ' added for customer ' || p_cust_id);

    EXCEPTION
        WHEN e_customer_not_found THEN
            DBMS_OUTPUT.PUT_LINE(' Error: Customer does not exist!');
        WHEN e_service_not_found THEN
            DBMS_OUTPUT.PUT_LINE(' Error: Service does not exist!');
    END add_service_order;

    ------------------------------------------------------------------------
    -- Function: Total Revenue (All Bills)
    ------------------------------------------------------------------------
    FUNCTION total_revenue RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT NVL(SUM(total_amount),0) INTO v_total FROM billing;
        RETURN v_total;
    END total_revenue;

    ------------------------------------------------------------------------
    -- Function: Occupancy Rate (Percent rooms occupied)
    ------------------------------------------------------------------------
    FUNCTION occupancy_rate RETURN NUMBER IS
        v_total_rooms NUMBER;
        v_occupied NUMBER;
        v_rate NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total_rooms FROM rooms;
        SELECT COUNT(*) INTO v_occupied FROM rooms WHERE is_available = 'N';
        v_rate := (v_occupied / v_total_rooms) * 100;
        RETURN v_rate;
    END occupancy_rate;

    ------------------------------------------------------------------------
    -- Procedure: Daily Revenue Report
    ------------------------------------------------------------------------
    PROCEDURE daily_revenue_report IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(' DAILY REVENUE REPORT');
        DBMS_OUTPUT.PUT_LINE('----------------------------');
        FOR rec IN (
            SELECT TRUNC(bill_date) AS bill_day, SUM(total_amount) AS day_total
            FROM billing
            GROUP BY TRUNC(bill_date)
            ORDER BY bill_day
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(rec.bill_day || ' : Rs. ' || rec.day_total);
        END LOOP;
    END daily_revenue_report;

    ------------------------------------------------------------------------
    -- Procedure: Show Current Room Assignments (Cursor)
    ------------------------------------------------------------------------
    PROCEDURE show_room_assignments IS
        CURSOR room_cur IS
            SELECT c.cust_name, r.room_id, r.room_type
            FROM customers c
            JOIN rooms r ON c.room_id = r.room_id
            WHERE r.is_available = 'N';
        v_rec room_cur%ROWTYPE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE(' CURRENT ROOM ASSIGNMENTS');
        DBMS_OUTPUT.PUT_LINE('--------------------------------');
        OPEN room_cur;
        LOOP
            FETCH room_cur INTO v_rec;
            EXIT WHEN room_cur%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Customer: ' || v_rec.cust_name || 
                                 ' | Room ID: ' || v_rec.room_id ||
                                 ' | Type: ' || v_rec.room_type);
        END LOOP;
        CLOSE room_cur;
    END show_room_assignments;

END HMS_PKG;
/
END HMS_PKG;
/