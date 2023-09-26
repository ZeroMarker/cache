Class web.DHCPE.MainDiagnosisNew Extends %RegisteredObject
{

ClassMethod OutMain(PAADM, MainDoctorFlag, OnlyRead As %String = "N")
{
	if PAADM="" q ""
	s VIPLevel=##class(web.DHCPE.PreCommon).GetVIPLevel("PAADM",PAADM)
	s OrderID=$O(^OEORD(0,"Adm",PAADM,0))
	s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other"))
	q:OrderID="" ""
	s Job=$J
	k ^TempDHCPEResultDiagnosisNew(Job)
	k ^TempDHCPEResultDiagnosisNewRefuse(Job)
	k ^TempDHCPEResultDiagnosisNewAdvice(Job)
	s OrderSub=0
	f  s OrderSub=$O(^OEORD(OrderID,"I",OrderSub)) q:OrderSub=""  d
	.s Stat=$P(^OEORD(OrderID,"I",OrderSub,1),"^",13)
	.q:Stat="4" //删除
	.s SpecNo=$P($G(^OEORD(OrderID,"I",OrderSub,3)),"^",20)
	.s ArcimID=$P(^OEORD(OrderID,"I",OrderSub,1),"^",2)
	.s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
	.q:STID=""
	.q:STID=OtherStation
	.s STSort=$P(^DHCPEST(STID),"^",4)
	.i STSort="" s STSort="9999"
	.s STOSub=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,STID,0))
	.s OrderSort=$P(^DHCPEST(STID,"O",STOSub),"^",7)
	.s:OrderSort="" OrderSort="999999999"
	.s LocInfo=$G(^DHCPEStationOrder("Loc",ArcimID))
	.i LocInfo="" d
	..s LocID="999999999"
	..s LocSort="999999999"
	.e  d
	..s LocID=$P(LocInfo,"^",1)
	..s LocSort=$P($G(^DHCPEST(+LocID,"STLOC",$P(LocID,"||",2))),"^",2)
	..i LocSort="" s LocSort="999999999"
	.s OrderItemID=OrderID_"||"_OrderSub
	.i '$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OrderItemID)) d
	..s ^TempDHCPEResultDiagnosisNewRefuse(Job,STSort,STID,LocSort,LocID)=1
	
	.s Sort=$I(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocID))
	.s ^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocID,OrderSort,Sort)=OrderID_"||"_OrderSub_"^"_ArcimID
	
	s LocInfo=""
	s STSort=""
	f  s STSort=$O(^TempDHCPEResultDiagnosisNew(Job,STSort)) q:STSort=""  d
	.s STID=""
	.f  s STID=$O(^TempDHCPEResultDiagnosisNew(Job,STSort,STID)) q:STID=""  d
	..s LocSort=""
	..f  s LocSort=$O(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort)) q:LocSort=""  d
	...s LocID=""
	...f  s LocID=$O(^TempDHCPEResultDiagnosisNew(Job,STSort,STID,LocSort,LocID)) q:LocID=""  d
	....i $L(LocID,"||")>1 d
	.....s UseID=LocID
	.....s UseDesc=$P(^DHCPEST(+UseID,"STLOC",$P(UseID,"||",2)),"^",1)
	....e  d
	.....s UseID=STID
	.....s UseDesc=$P(^DHCPEST(UseID),"^",2)
	....i $G(^TempDHCPEResultDiagnosisNewRefuse(Job,STSort,STID,LocSort,LocID))="" d
	.....s UseDesc="<font color=red>"_UseDesc_"</font>"
	
	....i LocInfo=""  d
	.....s LocInfo="<a class='a1' style='FONT-SIZE:9pt;' href=# onclick=ShowOneResult(this) ondblclick=ShowLocResult(this) id='"_UseID_"'>"_UseDesc_"</a>"
	....e  d
	.....s LocInfo=LocInfo_"<br><br><a class='a1' style='FONT-SIZE:9pt;' href=# onclick=ShowOneResult(this) ondblclick=ShowLocResult(this) id='"_UseID_"'>"_UseDesc_"</a>"
	
	s GSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
	w:GSID="" "<font color=red>未初检</font>"
	q:GSID=""
	w "<TABLE id='NewDiagnosis' width=100% height=100% border=1 cellspacing='0' cellpadding='0' style='white-space:normal; word-break:break-all;'>"
	;w "<THEAD style='display:table-header-group'>"
	i OnlyRead'="Y"
	{
		w "<TR height=20 bgcolor='' style='white-space:normal; word-break:break-all;'><TD colspan=4 style='white-space:normal; word-break:break-all;'>"
		i GSID="" d
		.;w "<button style='width:8%' onclick='SumResult_click()' id="_PAADM_"^Auto>获取结果</button>"
		e  d
		.w "初检:"
		.s (AuditUser,AuditDate,MainUser,MainDate)=""
		.s AuditUser=$P(^DHCPEGS(GSID,1),"^",5)
		.i AuditUser'="" d
		..s AuditUser=$P(^SSU("SSUSR",AuditUser),"^",2)
		..s AuditDate=$P(^DHCPEGS(GSID,1),"^",6)
		..s:AuditDate'="" AuditDate=$ZD(AuditDate,3)
		.w "<input style='width:8%' value='"_AuditUser_"'>"
		.w "<input style='width:8%' value='"_AuditDate_"'>"
		.w "复检:"
		.s MainInfo=$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))
		.s MainUser=$P(MainInfo,"^",1)
		.s:MainUser'="" MainUser=$P(^SSU("SSUSR",MainUser),"^",2)
		.s MainDate=$P(MainInfo,"^",2)
		.s:MainDate'="" MainDate=$ZD(MainDate,3)
		.w "<input style='width:8%' value='"_MainUser_"'>"
		.w "<input style='width:8%' value='"_MainDate_"'>"
		.//复检
		.i (MainDoctorFlag="Y") d
		..i AuditUser="" d
		...w "<font color=red>未初检</font>"
		..e  d
		...i MainUser'="" d
		....w "<font color=red>已复检</font>"
		....w "<button style='width:6%' onclick='StationSCancelSub()' id="_PAADM_"^Cancel><B>取消复检</B></button>"
		...e  d
		....;未复检
		....;w "<button style='width:6%' onclick='SelectAdvice()' id="_PAADM_"^Select>全选建议</button>"
		....w "<button style='width:6%' onclick='Audit_click()' id="_PAADM_"^Save><B>复检提交</B></button>"
		....;w:VIPLevel'[("VIP") "<button style='width:6%' onclick='SaveAdvice(this)' id="_PAADM_"^Save>保存建议(P)</button>"
		....;w:VIPLevel[("VIP") "<button style='width:6%' onclick='SaveGSSDetail()' id="_PAADM_"^Save>保存建议(V)</button>"
		....w:VIPLevel'[("VIP") "<button style='width:6%' onclick='SaveAdvice(this)' id="_PAADM_"^SaveAP>保存建议(P)</button>"
		....w:VIPLevel[("VIP") "<button style='width:6%' onclick='SaveGSSDetail()' id="_PAADM_"^SaveAV>保存建议(V)</button>"
		.e  d
		..//初检
		..i MainUser'="" d
		...//已复检
		...w "<font color=red>已复检</font>"
		..e  d
		...//未复检
		...i AuditUser="" d
		....w "<button style='width:6%' onclick='SumResult_click()' id="_PAADM_"^Auto>重新总检</button>"
		....w "<button style='width:6%' onclick='Audit_click()' id="_PAADM_"^Save><B>初检提交</B></button>"
		....w "<button style='width:6%' onclick='Save_click()' id="_PAADM_"^SaveD>建议保存</button>"
		....w "<button style='width:6%' onclick='ShowUnite_click()' id="_PAADM_"^ShowUnite>建议合并</button>"
		...e  d
		....w "<button style='width:6%' onclick='StationSCancelSub()' id="_PAADM_"^Cancel><B>取消初检</B></button>"
		....w "<button style='width:6%' onclick='ShowResult_click()' id="_PAADM_"^Cancel>查看小结</button>"
		.w "<button style='width:6%' onclick='PreviewReport()' id="_PAADM_"^Report>报告预览</button>"
		.w "<button style='width:6%' onclick='GetContrastWithLast()' id="_PAADM_"^History>历史结果</button>"
		.w "<button style='width:6%' onclick='HighRiskReport()' id="_PAADM_"^HighRisk>高危</button>"
		.w "<button style='width:6%' onclick='ShowCheckResult()' id="_PAADM_"^CheckResult>检查报告<tton>"
		.w "<button style='width:6%' onclick='QMManager()' id="_PAADM_"^QM>质量上报</button>"
		
		w "</TD><TR>"
	}
	;w "<TR><TD><div style='overflow-y:auto;width:100%;height:100%'><TABLE height=100% width=100%>"
	i AuditUser=""
	{
		w "<font color=red size=16px>未初检</font>"
		q
	}
	/*
	i MainUser'=""
	{
		w "<TR width=100% height=100%><TD>"
		s lnk="../csp/dhcpeireport.normal.csp?PatientID="_PAADM_"&OnlyAdvice=Y"
		w "<iframe width=100% height=100% name='I1' src='"_lnk_"'>浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</iframe>"
		w "</TD></TR>"
		w "</TABLE>"
		q
	}
	*/
	w "<TR height=20 align='center' bgcolor=''><TD width=10%>科室</TD><TD width=70%>结果</TD><TD>科室建议</TD><TR>"
	//科室选择界面
	w "<TR height=100%>"
	w "<TD valign='top'><div style='overflow-y:auto;width:100%;height:100%'><Table height=100%><TR><TD>"_LocInfo_"</TD></TR></Table></DIV></TD>"
	w "<TD valign='top'>"
	//异常结果
	w "<TABLE border=1 cellspacing='0' cellpadding='0' height=20% width=100%>"
	w "<TR><TD id='ResultTD' valign='top'></TD></TR>"
	w "</TABLE>"
	//建议界面
	w "<TABLE border=1 cellspacing='0' cellpadding='0' height=80% width=100%>"
	w "<TR><TD ID='AdviceTD' valign='top'>"
	i MainUser'="" d
	.s lnk="../csp/dhcpeireport.normal.csp?PatientID="_PAADM_"&OnlyAdvice=Y"
	.w "<iframe width=100% height=100% name='I1' src='"_lnk_"'>浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</iframe>"
		
	.;d ##class(web.DHCPE.ResultDiagnosisNew).OutGSSDetail(GSID,0)
	e  d
	.i VIPLevel[("VIP") d
	..d ##class(web.DHCPE.ResultDiagnosisNew).OutGSSDetail(GSID,0)
	.e  d
	..d ##class(web.DHCPE.ResultDiagnosisNew).OutAdviceToHtml(GSID,"","Y","Y")
	.
	w "</TD></TR>"
	w "</TABLE>"
	//选择建议界面
	w "</TD>"
	w "<TD id='EDInfo' valign='top'></TD>"
	w "</TR>"
	k ^TempDHCPEResultDiagnosisNewOrder(Job)
	k ^TempDHCPEResultDiagnosisNew(Job)
	k ^TempDHCPEResultDiagnosisNewAdvice(Job)
	w "</TABLE>"
}

/// debug:w ##class(web.DHCPE.MainDiagnosisNew).GetResultByLocID()
ClassMethod GetResultByLocID(PAADM, LocID, DivFlag As %String = 1, MainFlag As %String = "Y")
{
	s Job=$j
	k ^TempOrderResultSort(Job)
	k ^TempOrderResultSortRisStudyNo(Job)
	k ^TempOrderResultSortLabNo(Job)
	s AdmLocID=$p($g(^PAADM(PAADM)),"^",4)
	//s LisMerge=$G(^DHCPESetting("DHCPE","LisReportMerge"))
	s LisMerge=$G(^DHCPESetting("DHCPE","LisReportMerge",AdmLocID))
	s RisMerge=$G(^DHCPESetting("DHCPE","RisReportMerge",AdmLocID))
	s HFlag=0
	s:$P(^PAADM(PAADM),"^",2)="H" HFlag=1

	s ResultFormat=##class(web.DHCPE.ResultNew).GetResultFormat(+LocID,AdmLocID)
	s retInfo=""
	s Order=$O(^OEORD(0,"Adm",PAADM,0))
	s OrderSub="0"
	f  s OrderSub=$O(^OEORD(Order,"I",OrderSub)) q:OrderSub=""  d
	.s OrderID=Order_"||"_OrderSub
	.s ArcimID=$P($g(^OEORD(+OrderID,"I",$P(OrderID,"||",2),1)),"^",2)
	.q:ArcimID=""
	.s Stat=$P($g(^OEORD(Order,"I",OrderSub,1)),"^",13)
	.q:Stat="4" //删除
	.s QFlag=0
    .s RisStudyNo=##class(web.DHCPE.HISUICommon).GetStudyNoByOEORI(OrderID)
    .i (RisStudyNo'="")&&(RisMerge="Y") d
    ..s:$D(^TempOrderResultSortRisStudyNo(Job,RisStudyNo)) QFlag=1
    ..s ^TempOrderResultSortRisStudyNo(Job,RisStudyNo)=""
    .q:QFlag=1 //检查合并结果显示
	.//检验项目是否按标本号合并显示 stsrt
	.s LabFlag=0
	.q:'$d(^OEORD(Order,"I",OrderSub,3))
	.s LabSpec=$P($g(^OEORD(Order,"I",OrderSub,3)),"^",20)
    .i (LabSpec'="")&&(LisMerge="Y") d
    ..s:$D(^TempOrderResultSortLabNo(Job,LabSpec)) LabFlag=1
	..s ^TempOrderResultSortLabNo(Job,LabSpec)=""
    .;q:LabFlag=1 //检验合并结果调用平台分开传
    .//检验项目是否按标本号合并显示 end
	.s CrmOrder=$O(^DHCPECRMO(0,"OEORI",OrderID,0))
	.q:(CrmOrder="")&&(HFlag=1)
	.s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimID,AdmLocID)
	.s STID=+StatOrderDR
	.;s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
	.s STName=""
	.i STID'="" s STName=$P($g(^DHCPEST(STID)),"^",2)
	.q:StatOrderDR=""
	.s STOrdCatSortID=$o(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",StatOrderDR,0))
    .s SOSID=""
    .i STOrdCatSortID'="" d
    ..s STOrdSortID=$o(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",StatOrderDR,STOrdCatSortID,0))
    ..s SOSID=STOrdCatSortID_"||"_STOrdSortID
    .q:(SOSID'="")&&(LocID'["||") 
    .;q:$d(^DHCPEStationOrder("Loc",ArcimID))&&(LocID'["||")
	.q:+LocID'=STID
	.i $L(LocID,"||")>1 d
	..;s LocInfo=$G(^DHCPEStationOrder("Loc",ArcimID))
	..;s CurLocID=$P(LocInfo,"^",1)
	..s CurLocID=""
	..i SOSID'="" s CurLocID=$lg($g(^CF.PE.StationOrdSortD(+SOSID)),2)    //站点分类ID
	..q:CurLocID=""
	..q:(CurLocID'=LocID)&&(CurLocID'="")
	..s Info=##class(web.DHCPE.ResultDiagnosisNew).GetOrderResult2(OrderID,Job)
	..q:Info=""
	..i retInfo="" d
	...s retInfo=Info
	..e  d
	...s retInfo=retInfo_$C(1)_Info
	.e  d
	..s Info=##class(web.DHCPE.ResultDiagnosisNew).GetOrderResult2(OrderID,Job)
	..q:Info=""
	..i retInfo="" d
	...s retInfo=Info
	..e  d
	...s retInfo=retInfo_$C(1)_Info
	;
	s Locsort="",retInfo=""
	f  s Locsort=$o(^TempOrderResultSort(Job,Locsort)) q:Locsort=""  d
	.s ItemSort=""
	.f  s ItemSort=$o(^TempOrderResultSort(Job,Locsort,ItemSort)) q:ItemSort=""  d
	..s oeoridr="" 
	..f  s oeoridr=$o(^TempOrderResultSort(Job,Locsort,ItemSort,oeoridr)) q:oeoridr=""  d
	...s ShowSort=""
	...f  s ShowSort=$o(^TempOrderResultSort(Job,Locsort,ItemSort,oeoridr,ShowSort)) q:ShowSort=""  d
	....s rltdr=""
	....f  s rltdr=$o(^TempOrderResultSort(Job,Locsort,ItemSort,oeoridr,ShowSort,rltdr)) q:rltdr=""  d
	.....s tmp01=$g(^TempOrderResultSort(Job,Locsort,ItemSort,oeoridr,ShowSort,rltdr))
	
	.....s LabFlag=0
	.....s tempOrder=$p($p(tmp01,$c(2),3),"^",1)
	.....s tempODID=$p($p(tmp01,$c(2),3),"^",2)
	.....s LabSpec=$P($g(^OEORD(+tempOrder,"I",$p(tempOrder,"||",2),3)),"^",20)
	.....i ((tempODID'="")&&(LabSpec'="")&&(LisMerge="Y")) d
    ......s:$D(^TempOrderResultSortLabNo(Job,LabSpec,tempODID)) LabFlag=1
	......s ^TempOrderResultSortLabNo(Job,LabSpec,tempODID)=""
	.....q:LabFlag=1
	
	.....i retInfo="" d
	......s retInfo=tmp01
	.....e  d
	......s retInfo=retInfo_$C(1)_tmp01

	
	i retInfo="" q "<TABLE><TR><TD>&nbsp;</TD></TR></TABLE>"
	s retInfo=..ShowArrowColor(retInfo)
	s ret=""
	s Length=$L(retInfo,$C(1))
	s:DivFlag=1 ret="<div style='overflow-y:auto;width:100%;height:100%;white-space:normal; word-break:break-all;'>"
	s ret=ret_"<TABLE width=100% height=100% style='white-space:normal; word-break:break-all;'>"
	if MainFlag="Y"
	{
	i ResultFormat'=3 d
	.f i=1:2:Length  d
	..s ret=ret_"<TR align='left' valign='top' style='white-space:normal; word-break:break-all;'>"
	..s ret=ret_"<TD width=50% style='white-space:normal; word-break:break-all;'>"
	..s OneInfo=$P(retInfo,$C(1),i)
	..q:OneInfo=""
	..s ret=ret_"<label onclick='detailClick(this);' style='cursor:hand;white-space:normal; word-break:break-all;' id='"_$P(OneInfo,$C(2),3)_"'><b>"_$P(OneInfo,$C(2),1)_"：</b></label>"_$P(OneInfo,$C(2),2)
	..s ret=ret_"</TD>"
	..s ret=ret_"<TD width=50% style='white-space:normal; word-break:break-all;'>"
	..s j=i+1
	..i j>Length  d
	...s ret=ret_"&nbsp;"
	..e  d
	...s OneInfo=$P(retInfo,$C(1),j)
	...s ret=ret_"<label onclick='detailClick(this);' style='cursor:hand;white-space:normal; word-break:break-all;' id='"_$P(OneInfo,$C(2),3)_"'><b>"_$P(OneInfo,$C(2),1)_"：</b></label>"_$P(OneInfo,$C(2),2)
	..s ret=ret_"</TD>"
	..s ret=ret_"</TR>"
	e  d
	.f i=1:1:Length  d
	..s ret=ret_"<TR align='left' valign='top' style='white-space:normal; word-break:break-all;'>"
	..s ret=ret_"<TD width=100% style='white-space:normal; word-break:break-all;'>"
	..s OneInfo=$P(retInfo,$C(1),i)
	..s ret=ret_"<label onclick='detailClick(this);' style='cursor:hand;style='white-space:normal; word-break:break-all;'' id='"_$P(OneInfo,$C(2),3)_"'><b>"_$P(OneInfo,$C(2),1)_"：</b></label>"_$P(OneInfo,$C(2),2)
	..s ret=ret_"</TD>"
	..s ret=ret_"</TR>"
	}
	else{
	f i=1:1:Length  d
	.s ret=ret_"<TR align='left' valign='top' style='white-space:normal; word-break:break-all;'>"
	.s ret=ret_"<TD width=99% style='white-space:normal; word-break:break-all;'>"
	.s OneInfo=$P(retInfo,$C(1),i)
	.s ret=ret_"<label onclick='detailClick(this);' style='cursor:hand;style='white-space:normal; word-break:break-all;'' id='"_$P(OneInfo,$C(2),3)_"'><b>"_$P(OneInfo,$C(2),1)_"：</b></label>"_$P(OneInfo,$C(2),2)
	.s ret=ret_"</TD>"
	.s ret=ret_"</TR>"
	}
	s:DivFlag=1 ret=ret_"</div>"
	s ret=ret_"</TABLE>"
	k ^TempOrderResultSortComment(Job)
	k ^TempOrderResultSort(Job)
	q ret
}

ClassMethod ShowArrowColor(ResultInfo)
{
	s ResultInfo=##class(web.DHCPE.Public.Setting).Replace(ResultInfo,"↑","<font color=red>↑</font>")
	s ResultInfo=##class(web.DHCPE.Public.Setting).Replace(ResultInfo,"↓","<font color=red>↓</font>")
	q ResultInfo
}

ClassMethod GetResultByLocIDOLD(PAADM, LocID, DivFlag As %String = 1)
{
	s ResultFormat=##class(web.DHCPE.ResultNew).GetResultFormat(+LocID)
	s retInfo=""
	s Order=$O(^OEORD(0,"Adm",PAADM,0))
	s OrderSub="0"
	f  s OrderSub=$O(^OEORD(Order,"I",OrderSub)) q:OrderSub=""  d
	.s OrderID=Order_"||"_OrderSub
	.s Stat=$P(^OEORD(Order,"I",OrderSub,1),"^",13)
	.q:Stat="4" //删除
	.s ArcimID=$P(^OEORD(+OrderID,"I",$P(OrderID,"||",2),1),"^",2)
	.s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
	.q:+LocID'=STID
	.i $L(LocID,"||")>1 d
	..s LocInfo=$G(^DHCPEStationOrder("Loc",ArcimID))
	..s CurLocID=$P(LocInfo,"^",1)
	..q:CurLocID'=LocID
	..s Info=##class(web.DHCPE.ResultDiagnosisNew).GetOrderResult(OrderID)
	..q:Info=""
	..i retInfo="" d
	...s retInfo=Info
	..e  d
	...s retInfo=retInfo_$C(1)_Info
	.e  d
	..s Info=##class(web.DHCPE.ResultDiagnosisNew).GetOrderResult(OrderID)
	..q:Info=""
	..i retInfo="" d
	...s retInfo=Info
	..e  d
	...s retInfo=retInfo_$C(1)_Info
	i retInfo="" q "<TABLE><TR><TD>&nbsp;</TD></TR></TABLE>"
	s ret=""
	s Length=$L(retInfo,$C(1))
	s:DivFlag=1 ret="<div style='overflow-y:auto;width:100%;height:100%'>"
	s ret=ret_"<TABLE width=100% height=100% style='white-space:normal; word-break:break-all;'>"
	i ResultFormat'=3 d
	.f i=1:2:Length  d
	..s ret=ret_"<TR align='left' valign='top' style='white-space:normal; word-break:break-all;'>"
	..s ret=ret_"<TD width=50% style='padding-top:10px;white-space:normal; word-break:break-all;'>"
	..s OneInfo=$P(retInfo,$C(1),i)
	..q:OneInfo=""
	..s ret=ret_"<label onclick='detailClick(this);' style='cursor:hand;white-space:normal; word-break:break-all;' id='"_$P(OneInfo,$C(2),3)_"'><b>"_$P(OneInfo,$C(2),1)_":</b></label>"_$P(OneInfo,$C(2),2)
	..s ret=ret_"</TD>"
	..s ret=ret_"<TD width=50% style='padding-top:10px;white-space:normal; word-break:break-all;'>"
	..s j=i+1
	..i j>Length  d
	...s ret=ret_"&nbsp;"
	..e  d
	...s OneInfo=$P(retInfo,$C(1),j)
	...s ret=ret_"<label onclick='detailClick(this);' style='cursor:hand;white-space:normal; word-break:break-all;' id='"_$P(OneInfo,$C(2),3)_"'><b>"_$P(OneInfo,$C(2),1)_":</b></label>"_$P(OneInfo,$C(2),2)
	..s ret=ret_"</TD>"
	..s ret=ret_"</TR>"
	e  d
	.f i=1:1:Length  d
	..s ret=ret_"<TR align='left' valign='top' style='white-space:normal; word-break:break-all;'>"
	..s ret=ret_"<TD width=100% style='padding-top:10px;white-space:normal; word-break:break-all;'>"
	..s OneInfo=$P(retInfo,$C(1),i)
	..s ret=ret_"<label onclick='detailClick(this);' style='cursor:hand;style='white-space:normal; word-break:break-all;'' id='"_$P(OneInfo,$C(2),3)_"'><b>"_$P(OneInfo,$C(2),1)_":</b></label>"_$P(OneInfo,$C(2),2)
	..s ret=ret_"</TD>"
	..s ret=ret_"</TR>"
	s:DivFlag=1 ret=ret_"</div>"
	s ret=ret_"</TABLE>"
	q ret
}

ClassMethod GetEDInfo(EDID, PAADM)
{
	s Advice=$p(^DHCPEED(EDID,"Detail"),"^",1)
	s Advice=##class(web.DHCPE.DHCPEExpertDiagnosis).GetKeyReplaceStr(PAADM,EDID)
	Set DisplayDesc="["_$p(^DHCPEED(EDID,1),"^",1)_"]"                              //Add 
	Set ResultInfo=##class(web.DHCPE.ReportGetInfor).GetAdviceResult(EDID,PAADM)
	i ResultInfo'="" s DisplayDesc=DisplayDesc_" "_ResultInfo
	q "、"_DisplayDesc_$c(13,10)_"       "_Advice
}

ClassMethod GetEDInfoByStation(LocID, IsAudit As %String = 1)
{
	s RetStr=""
	s Job=$J
	s loc=%session.Get("LOGON.CTLOCID")
	s loc=##class(web.DHCPE.DHCPECommon).GetEDloc()
	s EDRowId=""
	f  s EDRowId=$o(^DHCPEED(0,"EDLOC",loc,EDRowId)) q:EDRowId=""  d
	.s activeFlag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId))
	.q:activeFlag'="Y"
	.s HighRisk=$P(^DHCPEED(EDRowId,1),"^",8)
	.q:HighRisk="Y"
	.s CurStation=$P(^DHCPEED(EDRowId,1),"^",7)
	.q:(+LocID'="")&&(CurStation'=+LocID)
	.s CurLocID=$P(^DHCPEED(EDRowId,1),"^",10)
	.q:($L(LocID,"||")>1)&&(CurLocID'=LocID)
	.s:CurLocID="" CurLocID="999999999"
	.s Desc=$P(^DHCPEED(EDRowId,1),"^",1)
	.q:$D(^TempDHCPEDesc(Job,Desc))
	.s ^TempDHCPEDesc(Job,Desc)=""
	.s StationSort=$P($G(^DHCPEST(CurStation)),"^",4)
	.s:StationSort="" StationSort="99999999"
	.s EDSort=$p(^DHCPEED(EDRowId,1),"^",9)
	.s:EDSort="" EDSort="99999999"
	.s ^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc)=""
	k ^TempDHCPEDesc(Job)
	s StationSort=""
	s i=0
	s:IsAudit="1" RetStr=RetStr_"<div  style='overflow-y:auto;width:100%;height:75%'>"
	s RetStr=RetStr_"<Table id='EDTable' style='width:100%'>"
	s Sort=0
	f  s StationSort=$O(^TempDHCPE(Job,StationSort)) q:StationSort=""  d
	.s CurStation=""
	.f  s CurStation=$O(^TempDHCPE(Job,StationSort,CurStation)) q:CurStation=""  d
	..s CurLocID=""
	..f  s CurLocID=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID)) q:CurLocID=""  d
	...s EDSort=""
	...f  s EDSort=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort)) q:EDSort=""  d
	....s Desc=""
	....f  s Desc=$O(^TempDHCPE(Job,StationSort,CurStation,CurLocID,EDSort,Desc)) q:Desc=""  d
	.....s Sort=Sort+1
	.....s:i=0 RetStr=RetStr_"<TR width=100%>"
	.....s RetStr=RetStr_"<TD width=20%>"_Sort_"</TD><TD style='cursor:hand' onclick=EDClick() id='"_CurStation_"^"_Desc_"'>"_Desc_"</TD>"
	.....s i=i+1
	.....s:i=1 RetStr=RetStr_"<TR>"
	.....s:i=1 i=0
	s RetStr=RetStr_"</Table>"
	s:IsAudit="1" RetStr=RetStr_"</div>"
	k ^TempDHCPE(Job)
	q RetStr
}

ClassMethod GetGSDiagnosis(PAADM)
{
	s IADMRowId=""
	s IADMRowId=$O(^DHCPEIADM(0,"PAADM",PAADM,IADMRowId))
	q:(""=IADMRowId) ""
	s gSSID=$o(^DHCPEGS(0,"IADM",IADMRowId,0))
	q:gSSID=""
	s ret=""
	s ret="<div  style='overflow-y:auto;width:100%;height:25%'>"
	s ret=ret_"<TABLE border=1 cellspacing='0' cellpadding='0' style='width:100%'><TR bgcolor=green><TD colspan=2>结论汇总</TD><TR>"
	s Rows=1
	s Sort=0
	f  s Sort=$o(^DHCPEGS(0,"GSDSort",gSSID,Sort)) q:Sort=""  d
 	.s gSub=0
 	.f  s gSub=$o(^DHCPEGS(0,"GSDSort",gSSID,Sort,gSub)) q:gSub=""  d
	..;q:'$D(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",gSSID_"||"_gSub))&&(MainDoctorFlag="Y")
	..s Status=$p(^DHCPEGS(gSSID,"Diagnosis",gSub),"^",11)
	..q:Status'="0"
	..s OneDC=""
	..s GSDRowId=gSSID_"||"_gSub
	..s DiagnoseConclusion=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))   //Add 20080728
	..s DCLength=$L(DiagnoseConclusion,"]")
	..f i=1:1:DCLength  d
	...s One=$P(DiagnoseConclusion,"]",i)
	...s One=$P(One,"[",2)
	...i OneDC="" d
	....s OneDC=One
	...e  d
	....s OneDC=OneDC_"<br>"_One
	..s ret=ret_"<TR><TD width=15>"_Rows_"</TD><TD>"_OneDC_"</TD></TR>"
	..s Rows=Rows+1
	s ret=ret_"</TABLE></div>"
	q ret
}

ClassMethod SetSort(GSID, QFlag As %String = 0)
{
	q:($G(^DHCPEDataEx("SaveSortInfo",GSID))=1)&&(QFlag=1) 0
	
	s PAAdmRowid=$p($g(^DHCPEGS(GSID,1)),"^",8)
    s ADMLocID=$P($g(^PAADM(PAAdmRowid)),"^",4)
    
	s Job=$J
	k ^TempDHCPEAdviceSort(Job,"EDSort")
	s STSort=""
	
	s GSSub=0
	f  s GSSub=$O(^DHCPEGS(GSID,"Diagnosis",GSSub)) q:GSSub=""  d
	.s EDID=$P($g(^DHCPEGS(GSID,"Diagnosis",GSSub)),"^",1)
	.s STID=$P($g(^DHCPEED(EDID,1)),"^",7)      //站点ID
	.i STID="" d
	..s STSort="999999999"
	.e  d
	..;s STSort=$P($g(^DHCPEST(STID)),"^",4)
	..s STSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_ADMLocID,STID,"")) //站点详情ID
    ..s STSort=$lg($g(^CF.PE.StationSetD(STSetID)),5)      
	.i STSort="" s STSort="999999999"
	.s STLocID=$P($g(^DHCPEED(EDID,1)),"^",10)  //站点详情ID
	.i STLocID=""  d
	..s STLocSort="999999999"
	.e  d
	..;s STLocSort=$P($g(^DHCPEST(+STLocID,"STLOC",$P(STLocID,"||",2))),"^",2)
	..s STLocSortID=$O(^CF.PE.StationOrdSortI("IdxOfOrdCatDR",STLocID,"")) //站点分类顺序ID
	..s STLocSort=$lg($g(^CF.PE.StationOrdSortD(STLocSortID)),3)
	..i STLocSort="" s STLocSort="999999999"
	.s EDCRID=$O(^DHCPEEDCR(0,"EDDR",EDID,0))
	.i EDCRID="" d
	..s EDCSort="999999999"
	.e  d
	..s EDCID=$P($g(^DHCPEEDCR(EDCRID)),"^",2)
	..i EDCID="" d
	...s EDCSort="999999999"
	..e  d
	...s EDCSort=$P($g(^DHCPEEDC(EDCID)),"^",1)
	...i EDCSort="" s EDCSort="999999999"
	.s ^TempDHCPEAdviceSort(Job,"EDSort",EDCSort,STSort,STLocSort,GSSub)=""
	s Sort=0
	s SQLCODE=0
	s EDCSort=""
	f  s EDCSort=$O(^TempDHCPEAdviceSort(Job,"EDSort",EDCSort)) q:(EDCSort="")||(SQLCODE'="0")  d
	.s STSort=""
	.f  s STSort=$O(^TempDHCPEAdviceSort(Job,"EDSort",EDCSort,STSort)) q:(STSort="")||(SQLCODE'="0")  d
	..s STLocSort=""
	..f  s STLocSort=$O(^TempDHCPEAdviceSort(Job,"EDSort",EDCSort,STSort,STLocSort)) q:(STLocSort="")||(SQLCODE'="0")  d
	...s GSSub=0
	...f  s GSSub=$O(^TempDHCPEAdviceSort(Job,"EDSort",EDCSort,STSort,STLocSort,GSSub)) q:(GSSub="")||(SQLCODE'="0")  d
	....s Sort=Sort+1
	....s GSSID=GSID_"||"_GSSub
	....&SQL(Update Sqluser.DHC_PE_GSDiagnosis set GSD_Sort=:Sort where GSD_RowID=:GSSID)
	i SQLCODE=0 d
	.s ^DHCPEGS(GSID,"SortFlag")="Y"
	q SQLCODE
}

}
