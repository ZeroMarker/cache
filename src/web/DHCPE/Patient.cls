/// Created by JDL  2007-4
Class web.DHCPE.Patient Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1;

//s specTarget="patCardId^patName^Gender^Birthday^mobileNO^^^^CertCardNO^^corporator^Address"

Property PatientName As %String(TRUNCATE = 1);

Property PatientNo As %String(TRUNCATE = 1);

Property PatientId As %String(TRUNCATE = 1);

Property Sex As %String(TRUNCATE = 1);

Property DOB As %String(TRUNCATE = 1);

Property MobilePhone As %String(TRUNCATE = 1);

Property IDNo As %String(TRUNCATE = 1);

Property Nation As %String(TRUNCATE = 1);

Property BloodType As %String(TRUNCATE = 1);

Property Marital As %String(TRUNCATE = 1);

Property Email As %String(TRUNCATE = 1);

Property Zip As %String(TRUNCATE = 1);

Property Profession As %String(TRUNCATE = 1);

Property Corporator As %String(TRUNCATE = 1);

Property PatientType As %String(TRUNCATE = 1);

Property Address As %String(TRUNCATE = 1);

}
