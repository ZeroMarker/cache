/// Creator   : wk
/// CreatDate : 2018-08-30
/// Desc      : 出入转任务配置
Class web.DHCWL.V1.MRIPDay.MRIPDayTask Extends %RegisteredObject
{

/// Creator   : wk
/// CreatDate : 2018-08-30
/// Desc      : 获取出入转任务配置
/// Other     : do ##class(web.DHCWL.V1.MRIPDay.MRIPDayTask).GetMripdayTaskCfg()
ClassMethod GetMripdayTaskCfg()
{
	s ID=""
	s ID=$O(^DHCWL.MRIPDayTask.BaseSetD(""),-1)
	if ($g(ID)=""){
		q "{depStopFlag:'Y',wardStopFlag:'Y',disDateType:'NURSE'}"
	}else{
		s depStopFlag=$li(^DHCWL.MRIPDayTask.BaseSetD(ID),3)
		s wardStopFlag=$li(^DHCWL.MRIPDayTask.BaseSetD(ID),4)
		s disDateType=$li(^DHCWL.MRIPDayTask.BaseSetD(ID),2)
		//取最后一条记录的值，输出对象(串)
		q "{depStopFlag:'"_depStopFlag_"',"_"wardStopFlag:'"_wardStopFlag_"',"_"disDateType:'"_disDateType_"'}"
	}
}

/// Creator   : wk
/// CreatDate : 2018-08-30
/// Desc      : 获取出入转任务配置
/// Other     : do ##class(web.DHCWL.V1.MRIPDay.MRIPDayTask).BaseSetSave()
ClassMethod BaseSetSave(paraValues)
{
	s locFlag=$p($g(paraValues),"-",1)
	s wardFlag=$p($g(paraValues),"-",2)
	s disDateChoose=$p($g(paraValues),"-",3)
	i locFlag="true" s depStopFlag="Y"
	e  s depStopFlag="N"
	i wardFlag="true" s wardStopFlag="Y"
	e  s wardStopFlag="N"
	i disDateChoose="true" s disDateType="DOC"
	e  s disDateType="NURSE"
	s creator=$g(%session.Data("LOGON.USERNAME"))
	
	s dim("depStopFlag")=$g(depStopFlag)
	s dim("wardStopFlag")=$g(wardStopFlag)
	s dim("disDateType")=$g(disDateType)
	s dim("creator")=$g(creator)

	s tip=##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).SaveBaseSetting(.dim)
	q tip
}

/// Creator   : wk
/// CreatDate : 2018-08-31
/// Desc      : 获取出院情况对应设置
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayTask","GetOutHosGrid")
Query GetOutHosGrid() As websys.Query(ROWSPEC = "ID:%String:ID,desc:%String:描述,descSet:%String:出院情况归组") [ SqlProc ]
{
}

ClassMethod GetOutHosGridExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    
    
    s disSetRowId=$o(^DHCWL.MRIPDayTask.DisCondD(""),-1)   ;最后一条记录
	i $g(disSetRowId)'="" {
		s zyrsStr=$li(^DHCWL.MRIPDayTask.DisCondD(disSetRowId),2)  ;治愈人数ID串
		s hzrsStr=$li(^DHCWL.MRIPDayTask.DisCondD(disSetRowId),3)  ;好转人数ID串
		s swrsStr=$li(^DHCWL.MRIPDayTask.DisCondD(disSetRowId),5)  ;死亡人数ID串
		s wyrsStr=$li(^DHCWL.MRIPDayTask.DisCondD(disSetRowId),4)  ;未愈人数ID串
		i $g(zyrsStr)'="" d SetArray(zyrsStr,"治愈人数")
		i $g(hzrsStr)'="" d SetArray(hzrsStr,"好转人数")
		i $g(swrsStr)'="" d SetArray(swrsStr,"死亡人数")
		i $g(wyrsStr)'="" d SetArray(wyrsStr,"未愈人数")
	}
	s num=1
	s rowid=""
	f  s rowid=$o(^PAC("DISCON",rowid)) Q:rowid=""  d
	.q:rowid=0
	.s disDesc=$p($g(^PAC("DISCON",rowid)),"^",2)
	.s arrs(num,"ID")=rowid
	.s arrs(num,"Desc")=disDesc
	.i $d(dim(rowid)) d
	..s arrs(num,"DescSet")=$g(dim(rowid))
	.e  d 
	..i $g(disSetRowId)="" s arrs(num,"DescSet")="请选择归组"    ;未设置过，提示归组
	..e  s arrs(num,"DescSet")="其他人数"   ;设置过，未保存的ID，归为“其他人数”
	.s ^CacheTemp(repid,ind)=$lb(arrs(num,"ID"),arrs(num,"Desc"),arrs(num,"DescSet"))
	.s ind=ind+1
	.s num=num+1
	Quit $$$OK
	
	
SetArray(str,desc)
	s len=$l(str,",")
	f i=1:1:len d
	.s disId=$p(str,",",i)
	.s dim(disId)=desc
}

/// Creator   : wk
/// CreatDate : 2018-08-31
/// Desc      : 保存出院情况对应设置
/// Other     : do ##class(web.DHCWL.V1.MRIPDay.MRIPDayTask).SaveDisCondicionts
ClassMethod SaveDisCondicionts(str)
{
	s str=str
	s creator=$g(%session.Data("LOGON.USERNAME"))
	s dim("str")=$g(str)
	s dim("creator")=$g(creator)
	s tip=##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).SaveDisCondicions(.dim)
	q tip
}

/// Creator    : wk
/// CreatDate  : 2018-08-31
/// Desc       : 获取医嘱设置信息
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayTask","GetOrdSetting")
Query GetOrdSetting(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,desc:%String:描述,invalidTime:%String:作废时间,creator:%String:创建者") [ SqlProc ]
{
}

ClassMethod GetOrdSettingExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
	s rowid=""
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	f  s rowid=$o(^DHCWL.MRIPDayTask.OrdItmD(rowid)) Q:rowid=""  d
	.q:rowid=0
	.s ordCode=$li($g(^DHCWL.MRIPDayTask.OrdItmD(rowid)),2)
	.s ordDesc=$li($g(^DHCWL.MRIPDayTask.OrdItmD(rowid)),3)
	.s ordDiscardDate=$li($g(^DHCWL.MRIPDayTask.OrdItmD(rowid)),4)
	.s ordCreator=$li($g(^DHCWL.MRIPDayTask.OrdItmD(rowid)),5)
	.i $g(ordDiscardDate)'="" s AbolishDate=##class(websys.Conversions).DateLogicalToHtml(ordDiscardDate)
	.e  s AbolishDate=""
	.q:((filterValue'="")&&($zcvt(ordCode,"U") '[ filterValue)&&($zcvt(ordDesc,"U") '[ filterValue))
	.s ^CacheTemp(repid,ind)=$lb(rowid,ordCode,ordDesc,AbolishDate,ordCreator)
	.s ind=ind+1
 
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-31
/// Descc     : 获取统计项医嘱明细
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayTask","GetOrdDetailSetting")
Query GetOrdDetailSetting(mainId As %String) As websys.Query(ROWSPEC = "ID:%String:ID,rowID:%String:rowID,code:%String:编码,desc:%String:描述") [ SqlProc ]
{
}

ClassMethod GetOrdDetailSettingExecute(ByRef qHandle As %Binary, mainId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    q:mainId="" $$$OK
    s mainID=mainId
	i ('$d(^DHCWL.MRIPDayTask.OrdItmDetI("OrdItmDetOrdItmtDRIndex",mainID))){
		q $$$OK
	}else {
		s lastDate=$o(^DHCWL.MRIPDayTask.OrdItmDetI("OrdItmDetOrdItmtDRIndex",mainID,""),-1)
		s lastTime=$o(^DHCWL.MRIPDayTask.OrdItmDetI("OrdItmDetOrdItmtDRIndex",mainID,lastDate,""),-1)
		s rowID=0
		f  s rowID=$o(^DHCWL.MRIPDayTask.OrdItmDetI("OrdItmDetOrdItmtDRIndex",mainID,lastDate,lastTime,rowID)) q:rowID=""  d
		.s mARCItmID=$li($g(^DHCWL.MRIPDayTask.OrdItmDetD(rowID)),2) ;医嘱项ID
		.s par=$p(mARCItmID,"||",1)
		.s sub=$p(mARCItmID,"||",2)
		.s mARCCode=$p($g(^ARCIM(par,sub,1)),"^",1)
		.s mARCDesc=$p($g(^ARCIM(par,sub,1)),"^",2)
		.s ^CacheTemp(repid,ind)=$lb(rowID,mARCItmID,mARCCode,mARCDesc)
		.s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-31
/// Desc      : 保存统计项
/// Other     : do ##class(web.DHCWL.V1.MRIPDay.MRIPDayTask).SaveOrdInfoSet
ClassMethod SaveOrdInfoSet(code, desc, creator)
{
	s ordSetCode=code
	s ordSetDesc=desc
	s ordSetCreateUser=creator
	
	s dim("ordSetCode")=$g(ordSetCode)
	s dim("ordSetDesc")=$g(ordSetDesc)
	s dim("ordSetCreateUser")=$g(ordSetCreateUser)
	//^DHCWL.MRIPDayTask.OrdItmI("OrdItmCodeIndex",ordSetCode)
	
	s tempCode="",flag=""
	for {
		s tempCode=$o(^DHCWL.MRIPDayTask.OrdItmI("OrdItmCodeIndex",tempCode))
		q:tempCode=""
		if ($zcvt(tempCode,"U")=$zcvt(code,"U")){
			s flag=1
			q
		}
	}
	q:flag=1 "保存失败：该CODE已存在！"
	s tip=##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).SaveOrdSetting(.dim)
	
	q:tip="ok" "保存成功"
	q tip
}

/// Creator   : wk
/// CreatDate : 2018-08-31
/// Desc      : 作废统计项
/// Other     : do ##class(web.DHCWL.V1.MRIPDay.MRIPDayTask).UpdateOrdInfoSet
ClassMethod UpdateOrdInfoSet(updateID)
{
	q:updateID="" "获取作废记录失败"
	s tip=##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).SetDateOrdSetting(updateID)
	s:tip="ok" tip="更新成功"
	q tip
}

/// Creator    : wk
/// CreatDate  : 2018-08-31
/// Desc       : 获取所有医嘱项
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayTask","GetARCItms")
Query GetARCItms(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,desc:%String:描述") [ SqlProc ]
{
}

ClassMethod GetARCItmsExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    
    s:filterValue="" filterValue=$zcvt(filterValue,"U")
	s par=0
	f  s par=$o(^ARCIM(par)) Q:$g(par)=""  d
	.s sub=0 f  s sub=$o(^ARCIM(par,sub)) q:sub=""  d
	..s rowid=par_"||"_sub
	..s mARCCode=$p($g(^ARCIM(par,sub,1)),"^",1)
	..s mARCDesc=$p($g(^ARCIM(par,sub,1)),"^",2)
	..s ID=par_"||"_sub
	..s ARCItmCode=$g(mARCCode)
	..s ARCItmDesc=$g(mARCDesc)
	..q:(filterValue'="")&&(ARCItmCode '[ filterValue)&&(ARCItmDesc '[ filterValue)&&(ID '[ filterValue)
	..s ^CacheTemp(repid,ind)=$lb(ID,ARCItmCode,ARCItmDesc)
	..s ind=ind+1
    
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-08-31
/// Desc       : 插入出入转任务设置医嘱明细对应数据
/// Other      : do ##class(web.DHCWL.V1.MRIPDay.MRIPDayTask).SaveOrdDetailSetting
ClassMethod SaveOrdDetailSetting(str)
{
	s errorFlag=0
	s len=$l(str,"#")
	s date=+$h
	s time=$p($h,",",2)
	//医嘱项明细重复检查,如果重复给给出提示。
	f i=1:1:len d
	.s recStr=$p(str,"#",i)
	.s mainID=$P(recStr,"^",1)
	.s detailID=$P(recStr,"^",2)
	.q:errorFlag=1
	.i $d(data(mainID,detailID)) d
	..s errorFlag=2
	.e  s data(mainID,detailID)=""
	q:errorFlag=1 "保存失败！"
	q:errorFlag=2 "保存失败"_detailID_"重复"
	
	//如果没有重复，则正常保存
	f i=1:1:len d
	.s recStr=$p(str,"#",i)
	.s mainID=$P(recStr,"^",1)
	.s detailID=$P(recStr,"^",2)
	.;s desc=$p(recStr,"^",3)
	.&sql(INSERT INTO DHCWL_MRIPDayTask.OrdItmDet(OrdItmDet_OrdItmtDR,OrdItmDet_ARCItmMastDR,OrdItmDet_CreateDate,OrdItmDet_CreateTime) 
	VALUES(:mainID,:detailID,:date,:time))
	.i SQLCODE'=0 d
	..s errorFlag=1
	
	s result="保存失败！"
	i errorFlag=0  d  
	.s result="保存成功"
	q result
}

/// Creator     :	wk
/// CreatDate   :	2018-08-31
/// Description :	删除出入转任务设置医嘱明细对应数据
/// Other       :	w ##class(web.DHCWL.V1.MRIPDay.MRIPDayTask).DeleteOrdDetailSetting("1#1,2,3")
ClassMethod DeleteOrdDetailSetting(str) As %String
{
	s mainId=$p(str,"#",1)
	s rowIdStr=$p(str,"#",2)
	s date=+$h
	s result="删除失败！"
	s len=$l(rowIdStr,",")
	f i=1:1:len d
	.s rowId=$p(rowIdStr,",",i)
	.i '$d(^DHCWL.MRIPDayTask.OrdItmDetD(rowId)) s result="该统计项不存在！"
	.q:'$d(^DHCWL.MRIPDayTask.OrdItmDetD(rowId))
	.s lastDate=$li(^DHCWL.MRIPDayTask.OrdItmDetD(rowId),4)
	.i lastDate'=date s result="非当天加入，不可删除！"
	.q:lastDate'=date   //"非当天加入，不可删除！"
	.&sql(delete DHCWL_MRIPDayTask.OrdItmDet where OrdItmDet_RowID=:rowId)
	.i SQLCODE=0 d 
	..s result="ok"
	
	s:result="ok" result="删除成功"
	q result
}

}
