/// Creator:bianshuai
/// CreateDate:2015-08-27
/// Descript:医嘱审核查询类
Class web.DHCSTPHCMMONITORQUERY Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

///  Creator: bian shuai
///  CreateDate: 2015-08-27
///  D ##Class(%ResultSet).RunQuery("web.DHCSTPHCMMONITORQUERY","QueryIPMonitor","2015-08-27","2015-08-27","1647","")
Query QueryIPMonitor(StartDate As %String, EndDate As %String, LocID As %String, Status As %String) As %Query(ROWSPEC = "TPatNo:%String,TPatName:%String,TBed:%String,TInciDesc:%String,TDosege:%String,TFreq:%String,TInstruce:%String,TTDosage:%String,TDoctor:%String,TOrderTime:%String,TAuditUser:%String,TAuditTime:%String,TRefReason:%String") [ SqlProc ]
{
}

ClassMethod QueryIPMonitorExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocID As %String, Status As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1

	i StartDate="" Quit $$$OK
	i EndDate="" Quit $$$OK
	i LocID="" Quit $$$OK
	i Status="" Quit $$$OK
	
	s result=..QueryIPMonitorAudit(StartDate,EndDate,LocID,Status)
	s cnt=$p(result,"^",1)
	s pid=$p(result,"^",2) 

    i cnt'>0 Quit $$$OK

	S index=""
	f  S index=$o(^TMP("DHCST","web.DHCSTPHCMMONITORQUERY","QueryIPMonitor",pid,index)) Q:index=""  D
	.S mdata=$g(^TMP("DHCST","web.DHCSTPHCMMONITORQUERY","QueryIPMonitor",pid,index))
	.//mdata列表 TPatNo、TPatName、TBed、TInciDesc、TDosege、TFreq、TInstruce、TTDosage、TDoctor、TOrderTime、TAduitUser、TAuditTime、TRefReason
	.//mdata列表 登记号、姓名、床号、药品名称、剂量、频次、用法、总剂量、医生、医嘱开单时间、药房审核人、药房审核时间、药房拒绝原因
    .S ListData=$LISTFROMSTRING(mdata,"^")   //converted into a Cache list
	.Set ^CacheTemp(repid,ind)=ListData	
	.Set ind=ind+1
	d ..killTmpGlobal(pid)
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryIPMonitorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OutPhReturnTotalExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryIPMonitorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryIPMonitorExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Descript:住院医嘱审核结果查询
ClassMethod QueryIPMonitorAudit(StartDate As %String, EndDate As %String, mLocID As %String, Status As %String) As %String
{
	n (StartDate,EndDate,mLocID,Status)
	s pid=..NewPid()
	d ..killTmpGlobal(pid)
	i StartDate="" Quit $$$OK
	i EndDate="" Quit $$$OK  
	S:StartDate["-" StartDate=$zdh(StartDate,3)
	S:EndDate["-" EndDate=$zdh(EndDate,3)
	
	s LocIdList=mLocID
	i mLocID="1647" s LocIdList="1647^1627"
	i mLocID="1136" s LocIdList="1136^1129"
	s Len=$L(LocIdList,"^")
	
	s num=0
	f dd=StartDate:1:EndDate d
	.f i=1:1:Len d
	..s LocID=$p(LocIdList,"^",i)
	..s monitroID=""
	..f  s monitroID=$o(^DHCPHORDM(0,"DateLoc",dd,LocID,monitroID)) q:monitroID=""  d
	...s userID=$p(^DHCPHORDM(monitroID),"^",1) 	//用户ID
	...s userName=$p(^SSU("SSUSR",userID),"^",2)    //姓名
	...s opDate=$p(^DHCPHORDM(monitroID),"^",3)     //日期
	...s:opDate'="" opDate=$zd(opDate,3)
	...s opTime=$p(^DHCPHORDM(monitroID),"^",4)     //时间
	...s:opTime'="" opTime=$zt(opTime,1)
	...s ret=$p(^DHCPHORDM(monitroID),"^",2)        //审核结果
	...s:ret="A" ret="N"
	...q:(Status'="Null")&(ret'=Status)
	...//s agreeFlag=$p(^DHCPHORDM(monitroID),"^",8)
	...s ch=""
	...f  s ch=$o(^DHCPHORDM(monitroID,"I",ch)) q:ch=""  d
	....s oeori=$p(^DHCPHORDM(monitroID,"I",ch),"^",2) //住院医嘱ID
	....q:..CheckLinkOrderConSpecLocID(oeori,mLocID)'="Y"
	....s ord=$p(oeori,"||",1)
	....s itm=$p(oeori,"||",2)
	....s AdmDr=$p(^OEORD(ord),"^",1)
	....s pmidr=+$p(^PAADM(AdmDr),"^",1)
    ....s patno=$p(^PAPER(pmidr,"PAT",1),"^",2)
    ....s patname=$p(^PAPER(pmidr,"ALL"),"^",1)
	....s priDr=+$p(^OEORD(ord,"I",itm,1),"^",8) 
    ....q:priDr=0 
    ....s priorty=$p(^OECPR(priDr),"^",1) //医嘱优先级代码
    ....s priorty=$p(^OECPR(priDr),"^",2) //医嘱优先级
    ....s StatDr=$p(^OEORD(ord,"I",itm,1),"^",13)
    ....s oeFDesc=$p(^OEC("OSTAT",StatDr),"^",2)  ///医嘱状态描述
	....s ArcItmId=$p(^OEORD(ord,"I",itm,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	....s ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
	....s inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	....q:inci=""  //医嘱名称
	....s inciDesc=$p(^INCI(inci,1),"^",2)            //药品名称
	....s dosage=$p(^OEORD(ord,"I",itm,2),"^",1)      //剂量
	....s dosuomID=+$p(^OEORD(ord,"I",itm,2),"^",3)
	....s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2)   //剂量单位
	....s freqdr=+$p($g(^OEORD(ord,"I",itm,2)),"^",4) //OEORI_PHFreq_DR
    ....s freq=$p($g(^PHCFR(freqdr)),"^",3)           //频率
    ....s instrudr=+$p(^OEORD(ord,"I",itm,2),"^",7)
    ....s instru=$p($g(^PHCIN(instrudr)),"^",2)       //用法
    ....s durId=+$p(^OEORD(ord,"I",itm,2),"^",6)
	....s duration=$p($g(^PHCDU(durId)),"^",3)        //用药疗程
	....s StartDate=$p(^OEORD(ord,"I",itm,1),"^",9)  //开始日期
	....s:StartDate'="" StartDate=$zd(StartDate,3)
	....s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(oeori)  //医生
	....s Bed=##Class(web.DHCSTPHCMCOMMON).getBed(AdmDr)
	....s moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(oeori) //主医嘱
	....s refreason=""
	....s reasondr=$p(^DHCPHORDM(monitroID,"I",ch),"^",3) //拒绝原因
	....i reasondr'="" s refreason=$p(^DHCPCREASON(reasondr),"^",2)
	....s num=num+1
	....s ListData=patno_"^"_patname_"^"_Bed_"^"_inciDesc_"^"_dosage_doseuom_"^"_freq_"^"_instru_"^"_duration_"^"_doctor_"^"_StartDate_"^"_userName_"^"_opDate_" "_opTime_"^"_refreason
	....s index=AdmDr_"^"_moeori_"^"_num
	....s ^TMP("DHCST","web.DHCSTPHCMMONITORQUERY","QueryIPMonitor",pid,index)=ListData
	q num_"^"_pid
}

/// Descript:查询所有药房科室
/// D ##Class(%ResultSet).RunQuery("web.DHCSTPHCMMONITORQUERY","QueryAllPHLoc","2")
Query QueryAllPHLoc(HospID As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryAllPHLocExecute(ByRef qHandle As %Binary, HospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1

	i HospID="" Quit $$$OK

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTLOC_ROWID as LocDr,CTLOC_DESC as LocDesc FROM CT_LOC"
	s sqlStr=sqlStr_" where CTLOC_Type='D' AND CTLOC_Desc LIKE '%药房%'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	While(result.Next())
	{	
		s LocDr = result.Data("LocDr")
		continue:(HospID'="")&(HospID'=$p(^CTLOC(LocDr),"^",22))
		s LocDesc = result.Data("LocDesc")
		continue:(LocDesc["停")||(LocDesc["工作量")
		continue:'..CheckStrIfExitVar(LocDr)
		s mdata=LocDr_"^"_LocDesc
	    S ListData=$LISTFROMSTRING(mdata,"^")   //converted into a Cache list
		Set ^CacheTemp(repid,ind)=ListData	
		Set ind=ind+1
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryAllPHLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllPHLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAllPHLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllPHLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Descript:检查字符串中是否存在对应的变量
ClassMethod CheckStrIfExitVar(varChar As %String) As %String
{
	N (varChar)
	S InStrArrList=$LISTFROMSTRING("898,1002,1136,1647,1957,1840",",")
 	q:$lv(InStrArrList)=0 "1"
    q:$lf(InStrArrList,varChar)=0 "0"
    q 1
}

/// Descript:检查关联医嘱是否有对应科室
ClassMethod CheckLinkOrderConSpecLocID(oeori As %String, mLocID As %String) As %String
{
	N (oeori,mLocID)
	Q:oeori="" ""
	S moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(oeori)
 	S ord=$p(moeori,"||",1) Q:ord="" ""
 	S chl=$p(moeori,"||",2) Q:chl="" ""
 	Q:'$d(^OEORD(ord,"I",chl,1)) ""
 	Q:'$d(^OEORD(ord,"I",chl,11)) ""
 	S recloc=$p(^OEORD(ord,"I",chl,3),"^",6)
 	Q:recloc=mLocID "Y"
 	S quitflag="N"
 	S chl=""
 	f  S chl=$o(^OEORDi(0,"OEORI",ord,moeori,chl)) Q:(chl="")||(quitflag="Y")  D
 	.S moeori=$p(^OEORD(ord,"I",chl,11),"^",39)
 	.S reclocdr=$p(^OEORD(ord,"I",chl,3),"^",6)
 	.i reclocdr=mLocID S quitflag="Y"
 	Q quitflag
}

/// Descript:K掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMMONITORQUERY","QueryIPMonitor",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMMONITORQUERY"))
}

}
