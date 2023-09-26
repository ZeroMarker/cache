Class CIS.AN.SRV.ServiceTest Extends %RegisteredObject
{

ClassMethod SendMediwayStandard() As %String
{
  set businessID=1,createUser=1,methodCode="HisStandard"
  set params="RI&&&1&&&demo"
  set returnValue = ##class(CIS.AN.SRV.InterfaceMessage).NewMessage(businessID,methodCode,createUser,params)
  w returnValue
}

}
