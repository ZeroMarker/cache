/// <H3>就诊基本信息查询</H3>
/// <H4>创建者:李阳</H4>
Class DHCMed.CCService.Feedback.EpisodeService Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// <H3>功能：自动业务处理的主函数，可以通过Cache的自动业务定期执行此函数来实现自动监控</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>PEpisodeID</B>：就诊ID，PAADM</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <LI>ARowID:%String</LI>
/// <LI>AMRADMRowId:%String</LI>
/// <LI>ADiaSubID:%String</LI>
/// <LI>ADiagnosTypeID:%String</LI>
/// <LI>ADiagnosType:%String:诊断类型</LI>
/// <LI>AICDID:%String</LI>
/// <LI>ADiagnosName:%String:诊断名称</LI>
/// <LI>ADemo:%String</LI>
/// <LI>AEvaluation:%String</LI>
/// <LI>AEvaluationDesc:%String:状态</LI>
/// <LI>AICDCode:%String:ICD</LI>
/// <LI>AEffects:%String</LI>
/// <LI>AEffectsDesc:%String:ICD转归</LI>
/// <LI>ALevel:%String:级别</LI>
/// <LI>ASquence:%String:顺序</LI>
/// <LI>AUserName:%String:医师</LI>
/// <LI>ADateTime:%String:诊断时间</LI>
Query GetMRDiagnosList(PEpisodeID As %String) As %Query(ROWSPEC = "ARowID:%String,AMRADMRowId:%String,ADiaSubID:%String,ADiagnosTypeID:%String,ADiagnosType:%String:诊断类型,AICDID:%String,ADiagnosName:%String:诊断名称,ADemo:%String,AEvaluation:%String,AEvaluationDesc:%String:状态,AICDCode:%String:ICD,AEffects:%String,AEffectsDesc:%String:ICD转归,ALevel:%String:级别,ASquence:%String:顺序,AUserName:%String:医师,ADateTime:%String:诊断时间")
{
}

ClassMethod GetMRDiagnosListExecute(ByRef qHandle As %Binary, PEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(PEpisodeID)
 	Do objAdm.%Close()
    set MRADMRowId=objAdm.MrAdmID
    if MRADMRowId=""  Quit $$$OK
	set DiaSubID = "0" 
	for {
	   set DiaSubID=$o(^MR(MRADMRowId,"DIA",DiaSubID))
	   quit:(DiaSubID = "")
	   //诊断类型
	   set TypeID = $g(^MR(MRADMRowId,"DIA",DiaSubID,"TYP",1))
	   ;continue:(PTypeID '= TypeID)   
	   set TypeDesc = ""
	   if TypeID '=""  set TypeDesc = $p($g(^MRC("DTYP",TypeID)),"^",2)
	   //诊断
	   set ICDID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",1)
	   set ICDDesc = ""
	   set ICDCode = ""
	   if (ICDID '= "")&&(ICDID '= $c(0))
	   {
	       set ICDDesc = $p(^MRC("ID",ICDID),"^",2)
	       set ICDCode = $p(^MRC("ID",ICDID),"^",4)
	   }
	   //非ICD
	   set DemoDesc = ""
	   if (($d(^MR(MRADMRowId,"DIA",DiaSubID,"DES",1))'=0) && (ICDDesc = ""))
	   { 
	       set ICDDesc = $g(^MR(MRADMRowId,"DIA",DiaSubID,"DES",1))
	       set ICDCode = " "    //非ICD我们默认为99999，但是测试组认为默认为空合适
	   }
	   //级别
	   set Level = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",1)
	   if (Level = ""){set Level = 1}  else{ For i=1:1:(Level-1) {s ICDDesc = "   "_ICDDesc}}
	   //顺序
	   set Sequence = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",2)
	   
	   if $d(^MR(MRADMRowId,"DIA",DiaSubID,"EPR"))'=0
	   {
	      set EvaluationID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",3)
          set EffectsID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",4)
	   }
	   else 
	   {
		   set EvaluationID = ""
		   set EffectsID =""
	   }
	   //状态属性
       set EvaluationDesc =""
       if (EvaluationID '="") && (EvaluationID '="0") {set EvaluationDesc =$p($g(^MRC("DSTAT",EvaluationID)),"^",2)}
       //转归属性
       set EffectsDesc = ""
       if (EffectsID '= "") && (EffectsID '= "0") {set EffectsDesc = $Li($g(^DHCEPRM.CustomDictionaryD(EffectsID)),4)}
	   //日期时间
	   set Date = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",7)
	   //if Date '= "" set Date = $ZD(Date,3)
	   Set:Date'="" Date = ##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Date)
	   set Time = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",8)
	   if Time '="" set Time = $ZT(Time,3)
	   set DateTime = Date_" "_Time
	   //医生
	   set UserID =  $p(^MR(MRADMRowId,"DIA",DiaSubID),"^",12)
	   if UserID '="" set UserName = $p($g(^SSU("SSUSR",UserID)),"^",2)
	   
	   set RowID=MRADMRowId_"||"_DiaSubID
	   
	   set data = $lb(RowID,MRADMRowId,DiaSubID,TypeID,TypeDesc,ICDID,ICDDesc,DemoDesc,EvaluationID,EvaluationDesc,ICDCode,EffectsID,EffectsDesc,Level,Sequence,UserName,DateTime)
	   set ^CacheTemp(repid,ind)=data
	   set ind=ind+1  	 
	}
    
	Quit $$$OK
}

ClassMethod GetMRDiagnosListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRDiagnosListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRDiagnosListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRDiagnosListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// <H3>功能：按日期查询医嘱</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>EpisodeID</B>：就诊ID，PAADM</LI>
/// <LI><B>FromDate</B>监控开始日期，支持日期格式：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY</LI>
/// <LI><B>ToDate</B>监控结束日期，支持日期格式：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <LI>OrderItemID:%String</LI>
/// <LI>ArcimID:%String</LI>
/// <LI>OrderType:%String:医嘱类别</LI>
/// <LI>ArcimDesc:%String:医嘱名称</LI>
/// <LI>Number:%String:数量</LI>
/// <LI>Unit:%String:单位</LI>
/// <LI>OrderStatus:%String:状态</LI>
/// <LI>ExecDate:%String:执行日期</LI>
/// <LI>ExecTime:%String:执行时间</LI>
/// <H4>实例</H4>
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.EpisodeService","QueryOrderItemByDate",345,"2008-1-1","2012-12-31")
Query QueryOrderItemByDate(EpisodeID As %String, FromDate As %String, ToDate As %String) As %Query(ROWSPEC = "OrderItemID:%String,ArcimID:%String,OrderType:%String:医嘱类别,ArcimDesc:%String:医嘱名称,Number:%String:数量,Unit:%String:单位,OrderStatus:%String:状态,ExecDate:%String:执行日期,ExecTime:%String:执行时间")
{
}

ClassMethod QueryOrderItemByDateExecute(ByRef qHandle As %Binary, EpisodeID As %String, FromDate As %String, ToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	s OrderID="" f  s OrderID=$o(^OEORD(0,"Adm",EpisodeID,OrderID)) q:OrderID=""  d
	.f tmpDate=FromDate:1:ToDate  d
	..s childSub="" f  s childSub=$o(^OEORDi(0,"ItemDate",tmpDate,OrderID,childSub)) q:childSub=""  d
	...s OrderItemID=OrderID_"||"_childSub
	...s objOdrItm=##class(web.DHCCPW.Base.OrdItem).GetObjById(OrderItemID)
	...s ^CacheTemp(repid,ind)=$$BuildQueryOrderItemByDateExecute(objOdrItm)
	...s ind=ind+1
	Quit $$$OK
BuildQueryOrderItemByDateExecute(objItem)
	n (objItem)
	s execDate=$$GetExecDateTime(objItem.OEORIRowId)
	s data=$lb("")
	s $li(data,1)=objItem.OEORIRowId
	s $li(data,2)=objItem.OEORIItmMastDR // 医嘱项指针 ARC_ItmMast
	s $li(data,3)=objItem.OECPRDesc
	s $li(data,4)=objItem.ARCIMDesc
	s $li(data,5)=objItem.OEORIDoseQty
	s $li(data,6)=objItem.CTUOMDesc
	s $li(data,7)=objItem.OSTATDesc
	
	//******************************************************//
	// Modified By LiKai 2012-10-18
	// 解决时间线医嘱执行时间问题和取不了医嘱类型问题
	//s $li(data,8)=$zd(+$p(execDate,",",1),3)
	s $li(data,8)=execDate
	//******************************************************//
	
	q data
GetExecDateTime(OrderItemID)
	n (OrderItemID)
	s OrderID=$p(OrderItemID,"||",1)
	s itmChild=$p(OrderItemID,"||",2)
	
	/*
	s execChild="" f  s execChild=$o(^OEORD(OrderID,"I",itmChild,"X",execChild)) q:execChild=""  d
	.s execData=$g(^OEORD(OrderID,"I",itmChild,"X",execChild))	
	.s Date=$p(execData,"^",1)
	.s Time=$p(execData,"^",2)
	q $g(Date)_","_$g(Time)
	*/
	
	//******************************************************//
	// Modified By LiKai 2012-10-18
	// 解决时间线医嘱执行时间问题和取不了医嘱类型问题
	s execChild=0 f  s execChild=$o(^OEORD(OrderID,"I",itmChild,"ST",execChild)) q:execChild=""  d
	.s execData=$g(^OEORD(OrderID,"I",itmChild,"ST",execChild))
	.s aDate=$p(execData,"^",1)
	.Set:aDate'="" execDate=$zd(aDate,3)
	.s aTime=$p(execData,"^",2)
	.Set:aTime'="" execTime=$zt(aTime,3)
	q $g(execDate)_","_$g(execTime)
	//******************************************************//
}

ClassMethod QueryOrderItemByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderItemByDateExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QueryOrderItemByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderItemByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// <H3>功能：查询某此就诊的辅助检查列表</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>paadm</B>：就诊ID，PAADM</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <LI>OrderID:%String  医嘱ID</LI>
/// <LI>OrderName:%String 医嘱名称</LI>
/// <LI>StartDate:%String 开始日期</LI>
/// <LI>LabTestNo:%String 检验号</LI>
/// <LI>OrderStatus:%String 医嘱状态</LI>
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.EpisodeService","QueryLab",239062)
Query QueryLab(paadm As %String, OrderTypeList As %String = "", UserID As %String = "") As %Query(ROWSPEC = "OrderID:%String,OrderName:%String,StartDate:%String,LabTestNo:%String,OrderStatus:%String,LabEpisodeNo:%String,SpecimenDesc:%String,StartDateTime:%String,DocDesc:%String,Result:%String")
{
}

ClassMethod QueryLabExecute(ByRef qHandle As %Binary, paadm As %String, OrderTypeList As %String = "", UserID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	i OrderTypeList'="" d
	.s ^DHCMedLabQry("LAB",UserID)=OrderTypeList	//保存此次查询条件
	e  d
	.s:UserID'="" OrderTypeList=$g(^DHCMedLabQry("LAB",UserID))	//取最后一次查询条件
	
    s num=0,s=""
    q:'$d(^OEORD(0,"Adm",+paadm)) $$$OK   
    s oeord=$o(^OEORD(0,"Adm",+paadm,""))
    //  s aNum=$$BuildCurrDepArcim(paadm)
    s arcim="" f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim)) q:arcim=""  d
    .s ItmCat=+$p($g(^ARCIM(+arcim,"1",1)),"^",10)
    .s arcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
    .s Type=$p($g(^ARC("IC",+ItmCat)),"^",7)
    .;w:Type="L" !,"arcimDesc="_arcimDesc_"   Type="_Type
    .q:Type'="L"
    .q:(OrderTypeList'[("*"_ItmCat_"*"))&&(OrderTypeList'="")
    .s flag=""
    .s:$d(^CacheTemp($zn,$j,"ARCIM",arcim)) flag="1"
    .s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:ordDate=""  d
    ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:oeoriSub=""  d
    ...;q:$$CheckOrderStatus(oeord_"||"_oeoriSub)<0
    ...s ItemStatDR=$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",13)
    ...s OrderStatus=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",3)
    ...s OrderStatusDesc=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",2)
    ...s OrderStatusCode=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",1)
    ...q:(OrderStatusCode="D")!(OrderStatusCode="S")
    ...;w !,"    oeori="_oeord_"||"_oeoriSub_"  "_OrderStatus_"  "_OrderStatusDesc
    ...;w !,oeoriSub_"---"_OrderStatus
    ...;q:OrderStatus'="Y"
    ...;s arcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
    ...s sttDate=+$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",9)
    ...s sttTime=+$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",10)
    ...s labtestsetrow=$p($g(^OEORD(+oeord,"I",+oeoriSub,3)),"^",35)
    ...s LabEpisodeNo=$p($g(^OEORD(+oeord,"I",+oeoriSub,3)),"^",20)
    
    ...// add by liuyh 2013-3-14 取检验系统(LAB) 检验标本
	...s SpecCode="",SpecimenDesc="",Result=""
	...//update by zf 修改检验医嘱标本取值方法
	...//s SpecDr=$o(^OEORD(+oeord,"I",+oeoriSub,"SPEC",""),-1)
	...//s:SpecDr'="" SpecCode=$p(^OEORD(+oeord,"I",+oeoriSub,"SPEC",SpecDr),"^",1)
	...//s:SpecCode'="" SpecimenDesc=$p(^TTAB("SPEC",SpecCode),"\",1)
	...s tSpecimenInfo=##class(DHCMed.SSIO.FromHisSrv).GetOrdSpecimen(oeord_"||"_oeoriSub)
	...s SpecDr=$p(tSpecimenInfo,"^",1)
	...s SpecCode=$p(tSpecimenInfo,"^",2)
	...s SpecimenDesc=$p(tSpecimenInfo,"^",3)
	
	...s VisitNumber=$p(labtestsetrow,"||",1)
 	...s TestSet=$p(labtestsetrow,"||",2)
 	...s TestSetCount=$p(labtestsetrow,"||",3)
 	...s StartDateTime=""
 	...i (VisitNumber'="")&&(TestSet'="")&&(TestSetCount'="") d
 	....s StartDate=$p($g(^TEPI(VisitNumber,1,TestSet,TestSetCount)),"\",69)
	....s StartTime=$p($g(^TEPI(VisitNumber,1,TestSet,TestSetCount)),"\",70)
	....s:StartDate'="" StartDate=$zd(StartDate,3)
	....s:StartTime'="" StartTime=$zt(StartTime,2)
	....s StartDateTime=StartDate_" "_StartTime
	
	....s ItmCode=""
	....f  s ItmCode=$o(^TEPI(VisitNumber,1,TestSet,TestSetCount,"DATA",ItmCode)) q:ItmCode=""  d
	
	.....q:ItmCode=""
	.....s RstType=$p($g(^TTAB("TC",ItmCode)),"\",3)
	.....//Continue:RstType'="V"
	.....s Results=$p($g(^TEPI(VisitNumber,1,TestSet,TestSetCount,"DATA",ItmCode)),"\",1)
	.....s tmpResult=$P($g(^TTAB("BUG",Results)),"\",1)	//病原体
	.....i tmpResult'="" d
	......s Result=tmpResult
	
	
 	
 	...s OrdItemObj=##class(DHCMed.Base.OrdItem).GetObjById(+oeord_"||"_(+oeoriSub))
 	...s DocDesc=""
 	...s:$IsObject(OrdItemObj) DocDesc=OrdItemObj.DocDesc
    ...;w !," oeori="_oeord_"||"_oeoriSub_"    labtestsetrow="_labtestsetrow
    ...s oeori=oeord_"||"_oeoriSub
    ...;upate by lyh 2013-1-22
    ...q:(OrderStatusDesc["作废")||(OrderStatusDesc["撤销")
    ...q:(arcimDesc'["细菌")&&(arcimDesc'["药敏")&&(arcimDesc'["血常规")&&(arcimDesc'["胸腹水")&&(arcimDesc'["尿常规")&&(arcimDesc'["脑积液")
    ...s data=$lb("")
    ...s $li(data,1)=oeori
    ...s $li(data,2)=arcimDesc
    ...s $li(data,3)=$zd(sttDate,3)_" "_$zt(sttTime,2)
    ...s $li(data,4)=labtestsetrow
    ...s $li(data,5)=OrderStatusDesc
    ...s $li(data,6)=LabEpisodeNo
    ...s $li(data,7)=SpecimenDesc
    ...s $li(data,8)=StartDateTime
    ...s $li(data,9)=DocDesc
    ...s $li(data,10)=Result
    ...s ^CacheTemp(repid,ind)=data
    ...s ind=ind+1
    ...;s TMP=oeori_$c(2)_arcimDesc_$c(2)_$zd(sttDate,3)_$c(2)_flag_$c(2)_labtestsetrow_$c(2)_OrderStatusDesc
    ...;s s=s_TMP_$c(1)
    k ^CacheTemp($zn,$j,"ARCIM")
    q $$$OK
}

ClassMethod QueryLabClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLabExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryLabFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLabExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetInfectionSummary(EpisodeID As %String)
{
	n (EpisodeID)
	Quit "RowID^报告日期^报告时间^报告人^部位^诊断"
}

/// 通过EpisodeID查询医院感染报告
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.EpisodeService","QryInfReportByEpisodeID",82841)
Query QryInfReportByEpisodeID(EpisodeID As %String) As %Query(ROWSPEC = "ReportID:%String,Position:%String:感染部位,Diagnose:%String:感染诊断,RepCtloc:%String:报告科室,RepUser:%String:报告人,RepDate:%String:报告日期,RepTime:%String:报告时间,Specimen:%String:标本,Pathogeny:%String:病原体")
{
}

ClassMethod QryInfReportByEpisodeIDExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set arryReport=##class(DHCMed.NINF.Srv.InfReport).GetInfRepByAdm(EpisodeID)
	Set:$IsObject(arryReport)=0 arryReport=##class(%ListOfObjects).%New()	
	For i=1:1:arryReport.Count()
	{
		Set objRep=arryReport.GetAt(i)
		Continue:$IsObject(arryReport)=0
		//Continue:objRep.ReportStatus'=3 //审核状态
		Set data=$lb("")
		Set $li(data,1)=objRep.ReportID
		Set $li(data,2)=""
		Set $li(data,3)=""
		Set $li(data,4)=objRep.ReportLoc.Desc
		Set:$li(data,4)["-" $li(data,4)=$p($li(data,4),"-",2)
		Set $li(data,5)=""
		Set $li(data,6)=objRep.ReportDate
		Set $li(data,7)=objRep.ReportTime
		Set arryPos=objRep.GetInfPos(objRep.ReportID)
		For j=1:1:arryPos.Count()
		{
			Set objPos=arryPos.GetAt(j)
			Set:$li(data,2)'="" $li(data,2)=$li(data,2)_","
			Set $li(data,2)=$li(data,2)_objPos.InfPos.Desc
			Set:$li(data,3)'="" $li(data,3)=$li(data,3)_","
			Set $li(data,3)=$li(data,3)_objPos.InfDiag.Desc		
		}
		
		Set Specimen="",SpecimenList=""
		Set Pathogeny="",PathogenyList=""
		Set arryLab=objRep.GetLabResults(objRep.ReportID)
		For j=1:1:arryLab.Count()
		{
			Set objLab=arryLab.GetAt(j)
			Continue:'$IsObject(objLab)
			Continue:'$IsObject(objLab.Specimen)
			Set tmpSpecimen=objLab.Specimen.Desc
			If $listfind(SpecimenList,tmpSpecimen)<1 {
				Set Specimen=Specimen_","_tmpSpecimen
			}
			
			For indTest=1:1:objLab.TestResults.Count() {
				Set objPy=objLab.TestResults.GetAt(indTest)
				Continue:'$IsObject(objPy)
				Set tmpPathogeny=objPy.PathogenyDesc
				If $listfind(PathogenyList,tmpPathogeny)<1 {
					Set Pathogeny=Pathogeny_","_tmpPathogeny
				}
			}
		}
		Set:Specimen'="" Specimen=$e(Specimen,2,$l(Specimen))
		Set:Pathogeny'="" Pathogeny=$e(Pathogeny,2,$l(Pathogeny))
		Set $li(data,8)=Specimen
		Set $li(data,9)=Pathogeny
		
		Set ^CacheTemp(repid,ind)=data	
		Set ind=ind+1
		
	}
	Quit $$$OK
}

ClassMethod QryInfReportByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfReportByEpisodeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfReportByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfReportByEpisodeIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// <H4>获取就诊的总费用</H4>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>EpisodeID</B>：就诊ID，PAADM</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 一次就诊的总费用
ClassMethod GetTotalFee(EpisodeID As %String) As %String
{
	n (EpisodeID)
	Set $ZT="ErrorHander"
	Set return=##Class(web.UDHCJFBaseCommon).GetAdmCateFee(EpisodeID)		
	Set ret=0
	For i=1:1:$l(return,"&")
	{
		Set itm=$p(return,"&",i)
		Set ret=ret+$p(itm,"^",i)
	}
	Quit ret
ErrorHander
	Quit 0
}

/// 通过EpisodeID查询已报告的传染病报告
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.EpisodeService","QryEpdReportByEpisodeID",505)
Query QryEpdReportByEpisodeID(EpisodeID As %String) As %Query(ROWSPEC = "RowID:%String,PatientID:%String,RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:姓别,Age:%String:年龄,DiseaseICD:%String:ICD,DiseaseName:%String:疾病名称,ReportDep:%String:上报科室,RepPlace:%String:上报位置,RepUserCode:%String:上报人工号,RepUserName:%String:上报人姓名,RepDate:%String:上报日期,RepTime:%String:上报时间,Status:%String:状态,Paadm:%String,IsUpload:%String:是否上报CDC,StatusCode:%String,CheckUserCode:%String,CheckUserName:%String,CheckDate:%String,CheckTime:%String,RepKind:%String:传染病类别,RepRank:%String:传染病级别,FamName:%String,Occupation:%String,Company:%String,Address:%String,IDAddress:%String,TelPhone:%String,SickDate:%String,DiagDate:%String,DeathDate:%String,RepNo:%String,PersonalID:%String,DelReason:%String,DemoInfo:%String")
{
}

ClassMethod QryEpdReportByEpisodeIDExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set ReportID=""
	For {
		Set ReportID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",EpisodeID,ReportID))
		Quit:ReportID=""
		Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(ReportID)
		Do objRep.%Close()
		Set data=..BuildQryEpidemic(objRep)
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryEpdReportByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpdReportByEpisodeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEpdReportByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEpdReportByEpisodeIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BuildQryEpidemic(objRep) As %List
{
	New (objRep)
	Set return=""
	
	Set ReportID=objRep.%Id()                       //报告ID
	Set PatientID=objRep.MEPDPapmiDR                //PatientID
	Set EpisodeID=objRep.MEPDText1                  //EpisodeID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	If $IsObject(objPatient){
		Set PapmiNo=objPatient.PapmiNo              //登记号
		Set PatientName=objPatient.PatientName      //姓名
		Set PatientSex=objPatient.Sex               //性别
		Set PatientAge=""                           //年龄
		If (objPatient.Age>0) {
			Set PatientAge=PatientAge_objPatient.Age_"岁"
		} ElseIf (objPatient.AgeMonth>0) {
			Set PatientAge=PatientAge_objPatient.AgeMonth_"月"
		} ElseIf (objPatient.AgeDay>0) {
			Set PatientAge=PatientAge_objPatient.AgeDay_"天"
		}
		Set PersonalID=objPatient.PersonalID        //身份证号
	}
	If $IsObject(objRep.MEPDICDDR){
		Set RepICD=objRep.MEPDICDDR.MIFICD			//ICD
		Set RepDisease=objRep.MEPDICDDR.MIFDisease	//疾病名称
		Set RepKind=objRep.MEPDICDDR.MIFKind        //病例分类
		Set objRepKind=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",RepKind,"")
		If $IsObject(objRepKind){
			Set RepKind=objRepKind.Description
		}
		Set RepRank=objRep.MEPDICDDR.MIFRank        //传染病类别(甲、乙、丙)
		Set objRepRank=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicRank",RepRank,"")
		If $IsObject(objRepRank){
			Set RepRank=objRepRank.Description
		}
	}
	Set RepLoc=objRep.MEPDLocDR                     //报告科室
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLoc)
	If $IsObject(objRepLoc){
		Set RepLoc=objRepLoc.Descs
	}
	Set RepPlace=objRep.MEPDRepPlace                //上报位置
	Set objRepPlace=##class(DHCMed.SS.Dictionary).GetByTypeCode("REPPLACE",RepPlace,"")
	If $IsObject(objRepPlace){
		Set RepPlace=objRepPlace.Description
	}
	Set RepUser=objRep.MEPDRepUsrDR                 //报告人
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUser)
	If $IsObject(objRepUser){
		Set RepUserCode=objRepUser.Code
		Set RepUserName=objRepUser.Name
	}
	Set RepDate=objRep.MEPDRepDate                  //报告日期
	Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set RepTime=objRep.MEPDRepTime                  //报告时间
	Set:RepTime'="" RepTime=$zt(RepTime,2)
	Set RepStatus=objRep.MEPDStatus                 //报告状态
	Set objRepStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTSTATUS",RepStatus,"")
	If $IsObject(objRepStatus){
		Set RepStatusDesc=objRepStatus.Description
		Set RepStatusCode=objRepStatus.Code
	}
	Set RepIsUpload=$s(objRep.MEPDIsUpload="Y":"已上报",1:"未上报")  //是否上报CDC
	Set CheckDate=objRep.MEPDCheckDate              //审核日期
	Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
	Set CheckTime=objRep.MEPDCheckTime              //审核时间
	Set:CheckTime'="" CheckTime=$zt(CheckTime,2)
	Set CheckUser=objRep.MEPDCheckUsrDR                 //报告人
	Set objCheckUser=##class(DHCMed.Base.SSUser).GetObjById(CheckUser)
	If $IsObject(objCheckUser){
		Set CheckUserCode=objCheckUser.Code
		Set CheckUserName=objCheckUser.Name
	}
	Set FamName=objRep.MEPDFamName                  //家长姓名
	Set Occupation=objRep.MEPDOccupation            //职业
	Set objOccupation=##class(DHCMed.SS.Dictionary).GetByTypeCode("Career",Occupation,"")
	If $IsObject(objOccupation){
		Set Occupation=objOccupation.Description
	}
	Set Company=objRep.MEPDCompany                  //工作单位
	Set TelPhone=objRep.MEPDTelPhone                //联系电话
	Set Address=objRep.MEPDAddress                  //现住址
	Set IDAddress=objRep.MEPDIDAddress              //户籍地址
	Set SickDate=objRep.MEPDSickDate                //发病日期
	Set:SickDate'="" SickDate=$zd(SickDate,3)
	Set DiagDate=objRep.MEPDDiagDate                //诊断日期
	Set:DiagDate'="" DiagDate=$zd(DiagDate,3)
	Set DeathDate=objRep.MEPDDeathDate              //死亡日期
	Set:DeathDate'="" DeathDate=$zd(DeathDate,3)
	
	//通过计算得到卡片编号
	Set RepNo=objRep.MEPDText2
	
	//退卡原因或删除原因
	Set DelReason=objRep.MEPDDelReason
	Set:($g(RepStatusCode)'="9")&&($g(RepStatusCode)'["0") DelReason=""
	
	//备注
	Set DemoInfo=objRep.MEPDDemo
	
	Set return=return_$lb($g(ReportID))                 //报告ID
	Set return=return_$lb($g(PatientID))                //PatientID
	Set return=return_$lb($g(PapmiNo))                  //登记号
	Set return=return_$lb($g(PatientName))              //姓名
	Set return=return_$lb($g(PatientSex))               //性别
	Set return=return_$lb($g(PatientAge))               //年龄
	Set return=return_$lb($g(RepICD))                   //疾病ICD
	Set return=return_$lb($g(RepDisease))               //疾病名称
	Set return=return_$lb($g(RepLoc))                   //报告科室
	Set return=return_$lb($g(RepPlace))                 //上报位置
	Set return=return_$lb($g(RepUserCode))              //报告人工号
	Set return=return_$lb($g(RepUserName))              //报告人
	Set return=return_$lb($g(RepDate))                  //报告日期
	Set return=return_$lb($g(RepTime))                  //报告时间
	Set return=return_$lb($g(RepStatusDesc))            //报告状态
	Set return=return_$lb($g(EpisodeID))                //EpisodeID
	Set return=return_$lb($g(RepIsUpload))              //是否上报CDC
	Set return=return_$lb($g(RepStatusCode))            //报告状态代码
	
	Set return=return_$lb($g(CheckUserCode))            //审核人工号
	Set return=return_$lb($g(CheckUserName))            //审核人
	Set return=return_$lb($g(CheckDate))                //审核日期
	Set return=return_$lb($g(CheckTime))                //审核时间
	Set return=return_$lb($g(RepKind))                  //传染病类别
	Set return=return_$lb($g(RepRank))                  //传染病级别
	Set return=return_$lb($g(FamName))                  //家属姓名
	Set return=return_$lb($g(Occupation))               //职业
	Set return=return_$lb($g(Company))                  //工作单位
	Set return=return_$lb($g(Address))                  //现住址
	Set return=return_$lb($g(IDAddress))                //户籍地址
	Set return=return_$lb($g(TelPhone))                 //联系电话
	Set return=return_$lb($g(SickDate))                 //发病日期
	Set return=return_$lb($g(DiagDate))                 //诊断日期
	Set return=return_$lb($g(DeathDate))                //死亡日期
	Set return=return_$lb($g(RepNo))                    //卡片编号
	Set return=return_$lb($g(PersonalID))               //身份证号
	Set return=return_$lb($g(DelReason))                //退回或删除原因
	Set return=return_$lb($g(DemoInfo))                 //备注
	
	Quit return
}

}
