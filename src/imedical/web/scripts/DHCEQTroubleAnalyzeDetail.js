function BodyLoadHandler()
{
	KeyUp("FaultCase^FaultReason^DealMethod");
	Muilt_LookUp("FaultCase^FaultReason^DealMethod");
}
function GetFaultCase(value)
{
	GetLookUpID('FaultCaseDR',value);	
}
function GetFaultReason(value)
{
	GetLookUpID('FaultReasonDR',value);	
}
function GetFaultDealMethod(value)
{
	GetLookUpID('DealMethodDR',value);	
}
document.body.onload=BodyLoadHandler;