--Basic Queries 


--1.View all patients
SELECT * FROM patients;



--2.Count total patients
SELECT COUNT(*) FROM patients;



--3.Unique cities
SELECT DISTINCT city FROM patients;



--5.Total doctors
SELECT COUNT(*) FROM doctors;



--6. All Orthopedics
SELECT * FROM doctors WHERE specialization = 'Orthopedics';



--7. Total EMR visits
SELECT COUNT(*) FROM emr_visits;


--8. Visits after 2024
SELECT * FROM emr_visits WHERE visit_date > '2024-01-01';



--9. Highest bill amount
SELECT MAX(bill_amount) FROM emr_visits;




--10. Lowest bill amount
SELECT MIN(bill_amount) FROM emr_visits;




--11. Average bill amount
SELECT AVG(bill_amount) FROM emr_visits;




--12. Visits with bill > 4000
SELECT * FROM emr_visits WHERE bill_amount > 4000;





--13. Patients ordered by name
SELECT * FROM patients ORDER BY patient_name;





--14. Doctors ordered by specialization
SELECT * FROM doctors ORDER BY specialization;




--15. First 10 EMR records
SELECT * FROM emr_visits LIMIT 10;




--16. Patients with missing city
SELECT * FROM patients WHERE city IS NULL;




--17. Count visits per diagnosis
SELECT diagnosis, COUNT(*) FROM emr_visits GROUP BY diagnosis;




--19. Visits sorted by amount (desc)
SELECT * FROM emr_visits ORDER BY bill_amount DESC;




--20. Patients whose name starts with ‘A’
SELECT * FROM patients WHERE patient_name LIKE 'A%';




--INTERMEDIATE SQL (21–40)

--21. Patient + Visit details (JOIN)
SELECT p.patient_name, e.visit_date
FROM patients p
JOIN emr_visits e ON p.patient_id = e.patient_id;



--22. Doctor-wise visit count
SELECT d.doctor_name, COUNT(e.visit_id)
FROM doctors d
JOIN emr_visits e ON d.doctor_id = e.doctor_id
GROUP BY d.doctor_name;




--23. Patients with no visits
SELECT * FROM patients
WHERE patient_id NOT IN (
  SELECT patient_id FROM emr_visits
);




--24. Highest billed visit per patient
SELECT patient_id, MAX(bill_amount)
FROM emr_visits
GROUP BY patient_id;





--25. Average bill per diagnosis
SELECT diagnosis, AVG(bill_amount)
FROM emr_visits
GROUP BY diagnosis;




--26. Visits in a specific camp
SELECT * FROM emr_visits
WHERE camp_id = 101;




--27. City-wise patient count
SELECT city, COUNT(*)
FROM patients
GROUP BY city;




--28. Doctors who treated > 50 patients
SELECT doctor_id
FROM emr_visits
GROUP BY doctor_id
HAVING COUNT(*) > 50;




--29. Revenue per doctor
SELECT doctor_id, SUM(bill_amount)
FROM emr_visits
GROUP BY doctor_id;




--30. Most common diagnosis
SELECT diagnosis, COUNT(*) AS cnt
FROM emr_visits
GROUP BY diagnosis
ORDER BY cnt DESC
LIMIT 1;





--31. Monthly visit count
SELECT MONTH(visit_date), COUNT(*)
FROM emr_visits
GROUP BY MONTH(visit_date);





--32. Patients older than 60
SELECT * FROM patients
WHERE YEAR(CURDATE()) - YEAR(dob) > 60;




--33. Top 5 highest bills
SELECT * FROM emr_visits
ORDER BY bill_amount DESC
LIMIT 5;




--34. Patients with multiple visits
SELECT patient_id, COUNT(*)
FROM emr_visits
GROUP BY patient_id
HAVING COUNT(*) > 1;





--35. Diagnosis with revenue > 1L
SELECT diagnosis, SUM(bill_amount)
FROM emr_visits
GROUP BY diagnosis
HAVING SUM(bill_amount) > 100000;





--36. Doctors with no visits
SELECT * FROM doctors
WHERE doctor_id NOT IN (
  SELECT doctor_id FROM emr_visits
);





--37. Average bill per city
SELECT p.city, AVG(e.bill_amount)
FROM patients p
JOIN emr_visits e ON p.patient_id = e.patient_id
GROUP BY p.city;





--38. Latest visit per patient
SELECT patient_id, MAX(visit_date)
FROM emr_visits
GROUP BY patient_id;




--39. Count visits per camp
SELECT camp_id, COUNT(*)
FROM emr_visits
GROUP BY camp_id;




--40. Revenue per camp
SELECT camp_id, SUM(bill_amount)
FROM emr_visits
GROUP BY camp_id;




-- ADVANCED SQL (41–60)


--41. Rank doctors by revenue
SELECT doctor_id,
SUM(bill_amount),
RANK() OVER (ORDER BY SUM(bill_amount) DESC)
FROM emr_visits
GROUP BY doctor_id;



--42. Running total revenue
SELECT visit_date,
SUM(bill_amount) OVER (ORDER BY visit_date)
FROM emr_visits;





--43. Top diagnosis per doctor
SELECT doctor_id, diagnosis, COUNT(*)
FROM emr_visits
GROUP BY doctor_id, diagnosis;




--44. Patients visiting multiple doctors
SELECT patient_id
FROM emr_visits
GROUP BY patient_id
HAVING COUNT(DISTINCT doctor_id) > 1;






--45. Duplicate visit check
SELECT patient_id, visit_date, COUNT(*)
FROM emr_visits
GROUP BY patient_id, visit_date
HAVING COUNT(*) > 1;





--46. Percent contribution per diagnosis
SELECT diagnosis,
SUM(bill_amount) * 100 / (SELECT SUM(bill_amount) FROM emr_visits)
FROM emr_visits
GROUP BY diagnosis;




--47. Patients with above average bills
SELECT *
FROM emr_visits
WHERE bill_amount > (SELECT AVG(bill_amount) FROM emr_visits);





--48. Camp-wise top doctor
SELECT camp_id, doctor_id, SUM(bill_amount)
FROM emr_visits
GROUP BY camp_id, doctor_id;






--49. First visit date per patient
SELECT patient_id, MIN(visit_date)
FROM emr_visits
GROUP BY patient_id;






--50. View for patient summary
CREATE VIEW patient_summary AS
SELECT patient_id, COUNT(*) AS total_visits, SUM(bill_amount) AS total_bill
FROM emr_visits
GROUP BY patient_id;
