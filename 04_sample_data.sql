-- room data
INSERT INTO rooms VALUES(room_seq.NEXTVAL, 'DELUXE', 'Y');
INSERT INTO rooms VALUES(room_seq.NEXTVAL, 'STANDARD', 'Y');
INSERT INTO rooms VALUES(room_seq.NEXTVAL, 'ECONOMY', 'Y');
--customer data
INSERT INTO customers VALUES(customer_seq.NEXTVAL, 'Rahul Sharma', SYSDATE, NULL, NULL);
INSERT INTO customers VALUES(customer_seq.NEXTVAL, 'Priya Verma', SYSDATE, NULL, NULL);

--staff data
INSERT INTO staff VALUES(staff_seq.NEXTVAL, 'Amit Singh', 'Receptionist');
INSERT INTO staff VALUES(staff_seq.NEXTVAL, 'Neha Gupta', 'Housekeeping');
INSERT INTO staff VALUES(staff_seq.NEXTVAL, 'Ravi Kumar', 'Chef');

--service data
INSERT INTO services VALUES(service_seq.NEXTVAL, 'Food Order', 500);
INSERT INTO services VALUES(service_seq.NEXTVAL, 'Laundry', 300);
INSERT INTO services VALUES(service_seq.NEXTVAL, 'Spa', 1000);
COMMIT;