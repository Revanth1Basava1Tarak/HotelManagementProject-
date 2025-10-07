CREATE OR REPLACE PACKAGE HMS_PKG AS
    PROCEDURE assign_room(p_cust_id NUMBER, p_room_type VARCHAR2);
    FUNCTION calculate_bill(p_cust_id NUMBER) RETURN NUMBER;
    PROCEDURE add_service_order(p_cust_id NUMBER, p_service_id NUMBER);
    FUNCTION total_revenue RETURN NUMBER;
    FUNCTION occupancy_rate RETURN NUMBER;
    PROCEDURE daily_revenue_report;
    PROCEDURE show_room_assignments;
END HMS_PKG;
/