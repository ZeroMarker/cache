/// 名称:DtPortal.OD.OD01ABigDeptAssert
/// 描述:大科室维护
/// 编写者：bmz
/// 编写日期: 2015-8-3
Class DtPortal.OD.OD01ABigDeptAssert Extends %RegisteredObject
{

/// 名称:DtPortal.OD.OD01ABigDeptAssert
/// CreatDate： 2014-08-03
/// Description: 查询所有门诊科室
/// Input：          
/// Return： 
/// 服务代码 OD01.03.01
/// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD01ABigDeptAssert","findODLoc",4)
Query findODLoc(hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "locDesc:%String,locCode:%String,locId:%String")
{
}

ClassMethod findODLocExecute(ByRef qHandle As %Binary, hospitalId As %String = "") As %Status
{
	//New (qHandle,userCode)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Set id=""
	For  s id=$o(^CTLOC(id)) q:id=""  d
	.set CTLOCHospitalDR=$P($G(^CTLOC(id)),"^",22)			//科室所属院区
	.q:((hospitalId'="")&&(hospitalId'=CTLOCHospitalDR))
	.set locType=##class(DtPortal.Common.PublicService).getDeptType(id)
	.q:locType'["O"
	.s locDesc=$p(^CTLOC(id),"^",2)
	.i $p(locDesc,"-",2)'="" s locDesc=$p(locDesc,"-",2)
	.s locCode=$p(^CTLOC(id),"^",1)
	.s locId=id
	.d ODLoc
	
	q $$$OK
	

  
ODLoc
    s Data=$lb(locDesc,locCode,locId)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
