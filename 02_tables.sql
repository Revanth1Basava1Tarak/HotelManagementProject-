CREATE TABLE rooms (
    room_id NUMBER PRIMARY KEY,
    room_type VARCHAR2(20),
    is_available CHAR(1) DEFAULT 'Y'
);
CREATE TABLE customers (
    cust_id NUMBER PRIMARY KEY,
    cust_name VARCHAR2(50),
    check_in DATE,
    check_out DATE,
    room_id NUMBER REFERENCES rooms(room_id)
);
CREATE TABLE billing (
    bill_id NUMBER PRIMARY KEY,
    cust_id NUMBER REFERENCES customers(cust_id),
    total_amount NUMBER,
    bill_date DATE DEFAULT SYSDATE
);
CREATE TABLE staff (
    staff_id NUMBER PRIMARY KEY,
    staff_name VARCHAR2(50),
    role VARCHAR2(30)
);
CREATE TABLE services (
    service_id NUMBER PRIMARY KEY,
    service_name VARCHAR2(50),
    service_rate NUMBER
);
CREATE TABLE service_orders (
    order_id NUMBER PRIMARY KEY,
    cust_id NUMBER REFERENCES customers(cust_id),
    service_id NUMBER REFERENCES services(service_id),
    order_date DATE DEFAULT SYSDATE
);