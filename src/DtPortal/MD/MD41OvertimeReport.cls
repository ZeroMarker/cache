/// 检查检验超时报告
Class DtPortal.MD.MD41OvertimeReport Extends %RegisteredObject
{

/// 描述: 查询各个类型超时报告数量
/// 编写者：bmz
/// 编写日期:2020-12-23
/// 服务序号:MD41.01.01
/// arcimStr-医嘱项ID  sysType-系统类型   overtime-超时时间（分钟）
/// w ##class(DtPortal.MD.MD41OvertimeReport).MD410101("","","")
ClassMethod MD410101(arcimStr As %String, sysType As %String, overtime As %String, hospitalId As %String) As DtPortal.OutPut
{
	Set ret = ##class(DtPortal.OutPut).%New()
	set status=1,data="",errMSG=""
	try{
		
		set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
		d jsonObj.Put("num",0)
		Set status = 1
		Set errMSG = ""
		Set data = "["_jsonObj.Json()_"]"
		g MD410101
	}catch{
		Set status = -1
		Set errMSG = $ZE
		Set data = ""
		g MD410101
	}
	
MD410101
	Set ret.status = status
	Set ret.errMSG = errMSG
	Set ret.data = data
	Quit ret
}

/// 描述: 查询各个类型超时报告数据明细
/// 编写者：bmz
/// 编写日期:2020-12-23
/// 服务序号:MD41.01.01
/// arcimStr-医嘱项ID  sysType-系统类型   overtime-超时时间（分钟）
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD41OvertimeReport","MD410102","","","","")
Query MD410102(arcimStr As %String, sysType As %String, overtime As %String, hospitalId As %String) As DtPortal.Query(ROWSPEC = "name,docName,itmeID,arcimId,isUrgent,appLoc,receiveLoc,itemStrDate,overtimelength,admID") [ SqlProc ]
{
}

ClassMethod MD410102Execute(ByRef qHandle As %Binary, arcimStr As %String, sysType As %String, overtime As %String, hospitalId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	s (name,docName,itmeID,arcimId,isUrgent,appLoc,receiveLoc,itemStrDate,overtimelength,admID)=""
	
	
	d outPutMD410102
	
	q $$$OK
outPutMD410102
    s Data=$lb(name,docName,itmeID,arcimId,isUrgent,appLoc,receiveLoc,itemStrDate,overtimelength,admID)
    
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
