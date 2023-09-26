Class DHCBILL.SelfPay.Entity.PrintInvoice.Res.Invoice Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Invoice";

Property Index As %String(TRUNCATE = 1);

Property PrtDate As %String(TRUNCATE = 1);

Property PrtTime As %String(TRUNCATE = 1);

Property FairType As %String(TRUNCATE = 1);

Property AdmReason As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property PatName As %String(TRUNCATE = 1);

Property AdmDept As %String(TRUNCATE = 1);

Property Amt As %String(TRUNCATE = 1);

Property AmtDX As %String(TRUNCATE = 1);

Property User As %String(TRUNCATE = 1);

Property UserCode As %String(TRUNCATE = 1);

Property InvNo As %String(TRUNCATE = 1);

Property CateDetail As %String(TRUNCATE = 1);

Property ItemDetail As %String(TRUNCATE = 1);

Property DoctorName As %String(TRUNCATE = 1);

Property SessionType As %String(TRUNCATE = 1);

Property TimeRange As %String(TRUNCATE = 1);

Property SeqNo As %String(TRUNCATE = 1);

Property RoomNo As %String(TRUNCATE = 1);

Property RoomFloor As %String(TRUNCATE = 1);

Property RegFee As %String(TRUNCATE = 1);

Property AppFee As %String(TRUNCATE = 1);

Property OtherFee As %String(TRUNCATE = 1);

Property ClinicGroupCode As %String(TRUNCATE = 1);

Property BoroughDesc As %String(TRUNCATE = 1);

Property PrnRegFee As %String(TRUNCATE = 1);

Property PrnCheckFee As %String(TRUNCATE = 1);

Property PrnReCheckFee As %String(TRUNCATE = 1);

Property PrnMRFee As %String(TRUNCATE = 1);

Property PrnCardFee As %String(TRUNCATE = 1);

Property AdmDate As %String(TRUNCATE = 1);

Property RegDate As %String(TRUNCATE = 1);

Property BatcheNo As %String(TRUNCATE = 1);

Property EBatcheNo As %String(TRUNCATE = 1);

Property EInvNo As %String(TRUNCATE = 1);

Property InsuDiv As %String(TRUNCATE = 1);

Property AdmSource As %String(TRUNCATE = 1);

Property AdmReasonID As %String(TRUNCATE = 1);

Property BusinessNo As %String(TRUNCATE = 1);

Property IdentityNo As %String(TRUNCATE = 1);

Property InsuTradeNo As %String(TRUNCATE = 1);

Property SexDesc As %String(TRUNCATE = 1);

Property CardNo As %String(TRUNCATE = 1);

Property myPatPaySum As %String(TRUNCATE = 1);

Property PayMode As %String(TRUNCATE = 1);

}
