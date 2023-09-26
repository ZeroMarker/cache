Class CIS.AN.BL.CareProv Extends %RegisteredObject
{

ClassMethod SaveCareProv(jsonData As %DynamicObject, updateUserID As %String) As %String
{
	set $zt="Error"
  //set jsonData=##class(%DynamicObject).%FromJSON(jsonStr)
  set careProv=""
  if (##class(CF.AN.CareProvider).%ExistsId(jsonData.RowId))
  {
    set careProv=##class(CF.AN.CareProvider).%OpenId(jsonData.RowId)
  }
  else
  {
    set careProv=##class(CF.AN.CareProvider).%New()
  }
  set careProv.Code=jsonData.Code
  set careProv.FullName=jsonData.FullName
  set careProv.Alias=jsonData.Alias
  set careProv.MobileNo=jsonData.MobileNo
  set careProv.Dept=jsonData.Dept
  set careProv.Hospital=jsonData.Hospital
  set careProv.Active="Y"
  set activeDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(jsonData.ActiveDate,"")
  set:(activeDateH>0) careProv.ActiveDate=activeDateH
  set expireDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(jsonData.ExpireDate,"")
  set:(expireDateH>0) careProv.ExpireDate=expireDateH
  
  set sc=careProv.%Save()
  quit:($SYSTEM.Status.IsError(sc)) "E^"_$SYSTEM.Status.GetErrorText(sc)
  quit "S^"_careProv.%Id()
Error
  quit "E^"_$ze
}

ClassMethod DelCareProv(dataRowId As %String, updateUserID As %String) As %String
{
  set $zt="Error"
  set sc=##class(CF.AN.CareProvider).%DeleteId(dataRowId)
  quit:($SYSTEM.Status.IsError(sc)) "E^"_$SYSTEM.Status.GetErrorText(sc)
  quit "S^"
Error
  quit "E^"_$ze
}

}
