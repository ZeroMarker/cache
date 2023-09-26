Class User.DHCUploadAdmSheetsDict Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property AddDateTime As %String(TRUNCATE = 1);

Property DepCode As %String(TRUNCATE = 1);

Property DepName As %String(TRUNCATE = 1);

Property DoctorName As %String(TRUNCATE = 1);

Property OrderItems As User.DHCUploadAdmSheetsOrderItem;

Property Period As %String(TRUNCATE = 1);

Property SheetNo As %String(TRUNCATE = 1);

Property SheetType As %String(TRUNCATE = 1);

}
