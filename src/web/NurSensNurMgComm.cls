/// creator:lulin
/// createdate:2019-11-21
/// description:敏感指标-护理管理数据获取方法
Class web.NurSensNurMgComm Extends %RegisteredObject
{

/// Creator:lulin
/// Description:保存护管相关数据接口。
/// Date:2020-01-07
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SetAutoDataTmp(date) As %String
{
	s $ZT="ERROR"
	k tmp
	s tmp=""
	s paramFlag=1
	s sysParamObj=##class(DHCNS.Config.NsSysParam).%New(1)
	s NurMgInter=sysParamObj.NurMgInter
	s stTime=sysParamObj.DayStTime
	s endTime=sysParamObj.DayEndTime
	s:stTime="" stTime=28800
	s:endTime="" endTime=64800
	if NurMgInter="E" { ;夜班时长统计为20点-次日八点。所以要统计前天。4点执行任务，昨天数据不正确
		s dateStr=$zd(date,3)
		d ##class(web.NurSensDHCNurMgComm).GetPersonInfo(dateStr,stTime,endTime,.tmp)
	}elseif  NurMgInter="V"{
		s date=date-1
		s dateStr=$zd(date,3)
		d ##class(web.NurSensDHCNurMgComm).GetPersonInfoVue(dateStr,stTime,endTime,.tmp)
	}elseif NurMgInter="W" {
		s date=date-1
		s dateStr=$zd(date,3)
		d ##class(web.NurSensDHCNurMgComm).GetPersonInfoVue4(dateStr,stTime,endTime,.tmp)
	}elseif NurMgInter="O"{
		s date=date-1
		s dateStr=$zd(date,3)
		d ##class(web.NurSensThirdInter).GetNurMgData(dateStr,.tmp,sysParamObj.NurMgOtherSever,sysParamObj.NurMgOtherPort,sysParamObj.NurMgOtherUrl)
	}
	s DataKey="" f  s DataKey=$O(tmp(DataKey)) q:DataKey=""  d
	.s parr=$g(tmp(DataKey))
	.q:parr=""
	.s parr=parr_"^DataKey|"_DataKey_"^DataDate|"_date
	.k tmpParr
	.s tmpParr=""
	.d ##class(web.NurSensUtilComm).SplitStr(parr,"^","|",.tmpParr)
	.s id=$O(^DHCNS.Config.NsAutoMgDataI("key",date," "_DataKey,""))
	.i id="" s obj=##class(DHCNS.Config.NsAutoMgData).%New()
	.e  s obj=##class(DHCNS.Config.NsAutoMgData).%OpenId(id)
	.s obj.UpdateDate=+$H
	.s p="" f  s p=$O(^oddCOM("DHCNS.Config.NsAutoMgData","a",p)) q:p=""  d
	..q:p["%"
	..q:p["ChildSub"
	..q:p["Parref"
	..i $D(tmpParr(p)) d
	...s $ZOBJPROPERTY(obj,p)=$tr(tmpParr(p),"__","||")
	.s sc=obj.%Save()
	q 1
ERROR
	q 0
}

/// Creator:lulin
/// Description:根据职称、职务、学历三种类型获取护管中其明细数据
/// Date:2019-12-26
/// Table:
/// Input:
/// Output：
/// Others:d ##class(%ResultSet).RunQuery("web.NurSensNurMgComm","FindOrderTable","E")
Query FindOrderTable(par As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindOrderTableExecute(ByRef qHandle As %Binary, par As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	i (par="")||((par'="E")&&(par'="P")&&(par'="D")) {
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	s tmp=""
	s paramFlag=1
	s sysParamObj=##class(DHCNS.Config.NsSysParam).%New(1)
	s paramFlag=$case(sysParamObj.NurMgInter,"E":1,"V":2,"W":3,"O":4,:1)
	i paramFlag=1 d ##class(web.NurSensDHCNurMgComm).GetCategroy(par,.tmp)
	e  i paramFlag=2 d ##class(web.NurSensDHCNurMgComm).GetCategroyVue(par,.tmp)
	e  i paramFlag=3 d ##class(web.NurSensDHCNurMgComm).GetCategroyVue4(par,.tmp)
	e  d ##class(web.NurSensThirdInter).GetCategroy(par,.tmp,sysParamObj.NurMgOtherSever,sysParamObj.NurMgOtherPort,sysParamObj.NurMgOtherUrl)
	s rw="" f  s rw=$O(tmp(rw)) q:rw=""  d
	.s desc=$g(tmp(rw))
	.s ret="rw|"_rw_"^desc|"_desc
	.do OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindOrderTableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrderTableExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOrderTableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrderTableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
