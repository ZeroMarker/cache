Class web.DHCPE.Result Extends %Persistent
{

/// Creator：	  xy 
/// CreatDate：	  20230403
/// Description:  体检结果预览
/// Input:        PAADM(就诊ID)
/// dubug:d ##class(%ResultSet).RunQuery("web.DHCPE.Result","FindResult","1567")
Query FindResult(PAADM As %String = "") As websys.Query(ROWSPEC = "OrderItemID:%String,STDesc:%String,Result:%String,Advice:%String")
{
}

ClassMethod FindResultExecute(ByRef qHandle As %Binary, PAADM As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    
  	if (PAADM=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
  	}
  	s ADMLocID=$P($g(^PAADM(PAADM)),"^",4)
    s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other",ADMLocID))
    s MedicalStation=$G(^DHCPESetting("DHCPE","StationId_Medical",ADMLocID))
    s OtherStation="^"_OtherStation_"^"_MedicalStation_"^"
    
    d ##class(web.DHCPE.TransResult).TransMain(PAADM)
  	
  	s OrderID=$O(^OEORD(0,"Adm",PAADM,0))
    if (OrderID=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
  	}
  	
  	s Job=$J
  	k ^TempDHCPEResultView(Job)
    k ^TempDHCPEResultViewRefuse(Job)
    k ^TempDHCPEResultViewAdvice(Job)
    k ^TempDHCPEResultViewRisStudyNo(Job)
    
    s GSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
    
    s OrderSub=0
    f  s OrderSub=$O(^OEORD(OrderID,"I",OrderSub)) q:OrderSub=""  d
    .s ArcimID=$P($g(^OEORD(OrderID,"I",OrderSub,1)),"^",2)
    .q:ArcimID=""
    .s Stat=$P($g(^OEORD(OrderID,"I",OrderSub,1)),"^",13)
    .q:(Stat'="1")&(Stat'="6")
    .s SpecNo=$P($g(^OEORD(OrderID,"I",OrderSub,3)),"^",20)
    .s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimID,ADMLocID)
    .q:StatOrderID=""
    .s STID=+StatOrderID
    .q:OtherStation[("^"_STID_"^")
    .s StatSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_ADMLocID,STID,""))
    .q:StatSetID=""
    .
    .//顺序显示：站点顺序——站点分类顺序——项目顺序
    .//站点顺序
    .s STSort=""
    .s STSort=$lg($g(^CF.PE.StationSetD(StatSetID)),5)
    .i STSort="" s STSort="9999"
    .//项目顺序
    .s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_ADMLocID,StatOrderID,""))
    .s OrderSort=""
    .i StatOrdSetID'="" s OrderSort=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),8)
    .s:OrderSort="" OrderSort="999999999"
    .//站点分类顺序
    .s LocInfo="",SortID=""
    .s STOrdCatSortID=$o(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",StatOrderID,0))
    .i STOrdCatSortID'="" d
    ..s STOrdSortID=$o(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",StatOrderID,STOrdCatSortID,0))
    ..s SortID=STOrdCatSortID_"||"_STOrdSortID
    .i SortID'="" d
    ..s SOSLocPowerFlg = ##class(User.DHCPEStationOrderSort).GetLocShowDataFlag(SortID,ADMLocID)  //站点分类项目显示有效授权
    ..q:SOSLocPowerFlg'="Y"
    ..s LocInfo=$g(^CF.PE.StationOrdSortD($p(SortID,"||",1),"ORD",$p(SortID,"||",2)))
    .i LocInfo="" d
    ..s LocCatID="999999999"
    ..s LocSort="999999999"
    .e  d
    ..s LocCatID=$lg($g(^CF.PE.StationOrdSortD($p(SortID,"||",1))),2)
    ..s LocSort=$lg($g(^CF.PE.StationOrdSortD($p(SortID,"||",1))),3)
    ..i LocSort="" s LocSort="999999999"
    .
    .s OrderItemID=OrderID_"||"_OrderSub
    .s QFlag=0
    .s RARRowId=$o(^DHCPACRegInfoi("OEORI",OrderItemID,0))
    .i RARRowId'="" d
    ..s RisStudyNo=$p($g(^DHCPACRegInfo(RARRowId)),"^",2)
    ..s:$D(^TempDHCPEResultViewRisStudyNo(Job,RisStudyNo)) QFlag=1
    ..s ^TempDHCPEResultViewRisStudyNo(Job,RisStudyNo)=""
    .q:QFlag=1
    .s CrmOrder=$O(^DHCPECRMO(0,"OEORI",OrderItemID,0))
    .q:(CrmOrder="")&&(HFlag=1)
    .i '$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OrderItemID)) d
    ..s ^TempDHCPEResultViewRefuse(Job,STSort,STID,LocSort,LocCatID)=1
    .s ^TempDHCPEResultViewOrder(Job,STSort,STID,LocSort,LocCatID)=OrderID_"||"_OrderSub
    .s Sort=$I(^TempDHCPEResultView(Job,STSort,STID,LocSort,LocCatID))
    .s ^TempDHCPEResultView(Job,STSort,STID,LocSort,LocCatID,OrderSort,Sort)=OrderID_"||"_OrderSub_"^"_ArcimID
    k ^TempDHCPEResultViewRisStudyNo(Job)
  	
  	s STSort=""
    f  s STSort=$O(^TempDHCPEResultView(Job,STSort)) q:STSort=""  d
    .s STID=""
    .f  s STID=$O(^TempDHCPEResultView(Job,STSort,STID)) q:STID=""  d
    ..s SSID=##class(web.DHCPE.ResultEdit).GetSSId(PAADM, STID)
    ..s AuditFlag=0
    ..i SSID'="" d
    ...s Status=$P($g(^DHCPESS(SSID,1)),"^",7)
    ...q:Status="NA"
    ...s AuditFlag=1
    ..s LocSort=""
    ..f  s LocSort=$O(^TempDHCPEResultView(Job,STSort,STID,LocSort)) q:LocSort=""  d
    ...s LocID=""
    ...f  s LocID=$O(^TempDHCPEResultView(Job,STSort,STID,LocSort,LocID)) q:LocID=""  d
    ....;s OrderItemID=$G(^TempDHCPEResultViewOrder(Job,STSort,STID,LocSort,LocID))
    ....s RowsNum=$G(^TempDHCPEResultView(Job,STSort,STID,LocSort,LocID))
    ....s STDesc=$P(^DHCPEST(STID),"^",2)
    ....s STDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",STDesc,"STDesc","cls")  //翻译
    ....s LocFlag=0
    ....i $L(LocID,"||")>1 d
    .....q:'$D(^DHCPEST(+LocID,"STLOC",$P(LocID,"||",2)))
    .....s LocFlag=1
    .....s STDesc=$P($G(^DHCPEST(+LocID,"STLOC",$P(LocID,"||",2))),"^",1)
    ....i $G(^TempDHCPEResultViewRefuse(Job,STSort,STID,LocSort,LocID))="" d
    .....s RefuseEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcperesultview.hisui.csp","放弃")
    .....s STDesc=STDesc_"("_RefuseEng_")"
    ....s:AuditFlag="0" STDesc="<font color=red>"_STDesc_"</font>"
   
    ....s OrderNum=1
    ....s OrderSort=""
    ....f  s OrderSort=$O(^TempDHCPEResultView(Job,STSort,STID,LocSort,LocID,OrderSort)) q:OrderSort=""  d
    .....s Sort=""
    .....f  s Sort=$O(^TempDHCPEResultView(Job,STSort,STID,LocSort,LocID,OrderSort,Sort)) q:Sort=""  d
    ......s ItemInfo=$G(^TempDHCPEResultView(Job,STSort,STID,LocSort,LocID,OrderSort,Sort))
    ......s OrderItemID=$P(ItemInfo,"^",1)
    ......q:OrderNum>1
    ......s Item=$P(ItemInfo,"^",2)
    ......s ARCDesc=##class(web.DHCPE.ResultDiagnosisNew).GetOEItemDesc(OrderItemID)
    ......s:'$D(^DHCPERLT(0,"OEORI",OrderItemID)) ARCDesc="<font color=red>"_ARCDesc_"</font>"
    ......i $L(LocID,"||")>1 d
    .......s ResultLocID=LocID
    ......e  d
    .......s ResultLocID=STID
    ......s Result=##class(web.DHCPE.Result).GetResultByLocID(PAADM, ResultLocID,0,"N")
    ......s CurStation=STID
    ......s:LocFlag=1 CurStation=LocID
    ......i OrderNum=1 s Advice=##class(web.DHCPE.Result).GetAdviceInfoHISUI(GSID,CurStation,"",Job,"Y")
    ......s OrderNum=OrderNum+1
  	......d FindResultBuild
  	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
FindResultBuild 
	s ^CacheTemp(repid,ind)=$lb(OrderItemID,STDesc,Result,Advice)
	s ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Description: 获取站点建议
/// debug: d ##class(web.DHCPE.ResultDiagnosisNew).GetAdviceInfoHISUI()
ClassMethod GetAdviceInfoHISUI(GSID, StationID, MainDoctorFlag, Job, OnlyRead As %String = "N")
{

    q:GSID="" ""
    
    i '$D(^TempDHCPEResultViewAdvice(Job)) d
    .s Sort=0
    .f  s Sort=$o(^DHCPEGS(0,"GSDSort",GSID,Sort)) q:Sort=""  d
    ..s gSub=0
    ..f  s gSub=$o(^DHCPEGS(0,"GSDSort",GSID,Sort,gSub)) q:gSub=""  d
    ...;q:'$D(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",GSID_"||"_gSub))&&(MainDoctorFlag="Y")
    ...s Flag=0
    ...s:$D(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",GSID_"||"_gSub)) Flag=1
    ...s Status=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",11)
    ...q:Status'=0
    ...s EDID=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",1)
    ...q:EDID=""
    ...s EDDesc=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",9)
    ...s EDDesc=##class(web.DHCPE.ReportGetInfor).ReplaceXH(EDDesc)
    ...s DiagnoseConclusion=$p($g(^DHCPEED(EDID,"1")),"^",1)
    ...
    ...s CurSTID=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",13)
    ...s:(CurSTID="") CurSTID=$p($g(^DHCPEED(EDID,"1")),"^",7)
    ...s LocID=$p($g(^DHCPEED(EDID,"1")),"^",10) //站点分组ID
    ...i LocID'="" s CurSTID=LocID
    ...s CurSTLocID=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",14)
    ...i CurSTLocID'="" s CurSTID=CurSTLocID
    ...;w CurSTID_"CurSTID"
    ...q:(CurSTID="")
    ...
    ...s GSDRowId=GSID_"||"_gSub
    ...
    ...// 增加乙肝标志 add
    ...s YGFlag=$p($g(^DHCPEGS(GSID,"Diagnosis",gSub)),"^",12)
    ...// 增加乙肝标志 end
    ...
    ...i $d(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))'=0 d
    ....s DiagnoseConclusion=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId))
    ...
    ...// 修改乙肝标志 mod
    ...s ^TempDHCPEResultViewAdvice(Job,CurSTID,Sort,GSDRowId)=DiagnoseConclusion_"^"_EDDesc_"^"_Flag_"^"_GSDRowId_"^"_YGFlag
    ...// 修改乙肝标志 end
    
    s HadMainFlag=0
    s IADM=$P($G(^DHCPEGS(GSID,1)),"^",1)
    s AuditUser=$P($G(^DHCPEGS(GSID,1)),"^",5)
    i IADM="" d
    .s PAADM=$P($G(^DHCPEGS(GSID,1)),"^",8)
    e  d
    .s PAADM=$P($g(^DHCPEIADM(IADM)),"^",1)
    i PAADM'="" s LocID=$p($g(^PAADM(PAADM)),"^",4)
    s:$D(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM)) HadMainFlag=1
    s ret=""
    s i=1
    i (OnlyRead="Y")
    {
        ;只读
        s AuditUser="a"
        s HadMainFlag="1"
    }
    
    // 增加乙肝标志 add
    s YGItemFlag=##class(web.DHCPE.ResultDiagnosis).GetYGItemFlag(GSID,"GSID")
    // 增加乙肝标志 end
    
    ;w HadMainFlag_"^"_AuditUser,!
    s Sort=""
    
    s ret="<DIV id='addiagnosisdiv'><Table width=98% border=0 cellspacing='0' cellpadding='0' style='white-space:normal; word-break:break-all;'>"
    f  s Sort=$O(^TempDHCPEResultViewAdvice(Job,StationID,Sort)) q:Sort=""  d
    .s ID=""
    .f  s ID=$O(^TempDHCPEResultViewAdvice(Job,StationID,Sort,ID)) q:ID=""  d
    ..s Info=$G(^TempDHCPEResultViewAdvice(Job,StationID,Sort,ID))
    ..s Flag=$P(Info,"^",3)
    ..s CheckInfo=""
    ..i i=1 d
    ...q:HadMainFlag="1"
    ...q:(MainDoctorFlag="N")&&(AuditUser'="")
    ..s CheckInfo=CheckInfo_"<input class='hisui-checkbox' type='checkbox' name='MainFlag' id="_ID
    ..s:Flag="1" CheckInfo=CheckInfo_" checked"
    ..//初检权限或者已复检不允许修改复检标志
    ..s:(MainDoctorFlag'="Y")||(HadMainFlag="1") CheckInfo=CheckInfo_" disabled='disabled'"
    ..s CheckInfo=CheckInfo_">"
    ..s OneInfo="<TR style='white-space:normal; word-break:break-all;border:0;'>"
    ..
    ..// 增加乙肝标志 add
    ..i $P(Info,"^",5)="Y" d
    ...s YGImgsrc="../scripts_lib/hisui-0.1.0/dist/css/icons/virus.png"
    ...s YGTitle="乙肝建议"
    ...s YGID="YGFlag^"_ID
    ..e  d
    ...s YGImgsrc="../scripts_lib/hisui-0.1.0/dist/css/icons/stethoscope.png"
    ...s YGTitle="正常建议"
    ...s YGID="ZCFlag^"_ID
    ..// 增加乙肝标志 end
    ..
    ..i AuditUser'="" d
    ...s OneInfo="<TD width=30 style='white-space:normal; word-break:break-all;border:0;'>"_CheckInfo_"</TD>"
    ...i (MainDoctorFlag'="Y")||(HadMainFlag="1") d
    ....s OneInfo=OneInfo_"<TD width=45%  style='white-space:normal; word-break:break-all;border:0;'><B>"_##class(web.DHCPE.ResultDiagnosisNew).ReplaceKey($P(Info,"^",1),LocID)_"</B></TD>"
    ....s OneInfo=OneInfo_"<TD style='white-space:normal; word-break:break-all;border:0;'>"_$P(Info,"^",2)_"</TD>"
    ...e  d
    ....// 修改乙肝标志 mod
    ....i YGItemFlag="3" d
    .....s OneInfo=OneInfo_"<TD width=47 style='white-space:normal; word-break:break-all;border:0;'><button id='"_ID_"' name='DeleteButton' onclick='DeleteAdvice(this,1)' class='hisui-linkbutton' plain=true iconCls='icon-cancel'></button><a href='javascript:void(0);' onclick='SetYGFlag(this,1)' title='"_YGTitle_"' class='hisui-tooltip' data-options=""position:'top'"" name='YGFlag' id='"_YGID_"' style='padding-left:7px;'><img src='"_YGImgsrc_"' border=0/></a></TD>"
    .....s OneInfo=OneInfo_"<TD width=5% style='white-space:normal; word-break:break-all;border:0;'><button id='"_ID_"' name='SaveButton' onclick='SaveOneAdvice(this)' class='hisui-linkbutton' plain=true iconCls='icon-save-to'></button></TD>"
    .....s OneInfo=OneInfo_"<TD width=200 style='white-space:normal; word-break:break-all;border:0;'><textarea id='"_ID_"^JL' onpropertychange='setTareaAutoHeight(this)' style='width:100%; word-break:break-all;'>"_$P(Info,"^",1)_"</textarea></TD>"
    .....s OneInfo=OneInfo_"<TD width=2% style='white-space:normal; word-break:break-all;border:0;'>&nbsp;</TD>"
    .....s OneInfo=OneInfo_"<TD style='white-space:normal; word-break:break-all;border:0;'><textarea id='"_ID_"^JY' onpropertychange='setTareaAutoHeight(this)' style='width:100%;'>"_$P(Info,"^",2)_"</textarea></TD>"
    .....s OneInfo=OneInfo_"<TD width=5% style='display:none;white-space:normal; word-break:break-all;border:0;' id='"_ID_"^Sort'>"_Sort_"</TD>"
    ....e  d
    .....s OneInfo=OneInfo_"<TD width=30 style='white-space:normal; word-break:break-all;border:0;'><button id='"_ID_"' name='DeleteButton' onclick='DeleteAdvice(this,1)' class='hisui-linkbutton' plain=true iconCls='icon-cancel'></button></TD>"
    .....s OneInfo=OneInfo_"<TD width=5% style='white-space:normal; word-break:break-all;border:0;'><button id='"_ID_"' name='SaveButton' onclick='SaveOneAdvice(this)' class='hisui-linkbutton' plain=true iconCls='icon-save-to'></button></TD>"
    .....s OneInfo=OneInfo_"<TD width=200 style='white-space:normal; word-break:break-all;border:0;'><textarea id='"_ID_"^JL' onpropertychange='setTareaAutoHeight(this)' style='width:200; word-break:break-all;'>"_$P(Info,"^",1)_"</textarea></TD>"
    .....s OneInfo=OneInfo_"<TD width=2% style='white-space:normal; word-break:break-all;border:0;'>&nbsp;</TD>"
    .....s OneInfo=OneInfo_"<TD width=95% style='white-space:normal; word-break:break-all;border:0;'><textarea id='"_ID_"^JY' onpropertychange='setTareaAutoHeight(this)' style='width:100%;'>"_$P(Info,"^",2)_"</textarea></TD>"
    .....s OneInfo=OneInfo_"<TD  width=5% style='display:none;white-space:normal; word-break:break-all;border:0;' id='"_ID_"^Sort'>"_Sort_"</TD>"
    ....// 修改乙肝标志 end
    
    ..e  d
    ...// 修改乙肝标志 mod
    ...i YGItemFlag="3" d
    ....s OneInfo=OneInfo_"<TD width=47 style='white-space:normal; word-break:break-all;border:0;'><button id='"_ID_"' name='DeleteButton' onclick='DeleteAdvice(this,1)' class='hisui-linkbutton' plain=true iconCls='icon-cancel'></button><a href='javascript:void(0);' onclick='SetYGFlag(this,1)' title='"_YGTitle_"' class='hisui-tooltip' data-options=""position:'top'"" name='YGFlag' id='"_YGID_"' style='padding-left:7px;'><img src='"_YGImgsrc_"' border=0/></a></TD>"
    ....s OneInfo=OneInfo_"<TD width=5% style='white-space:normal; word-break:break-all;border:0;'><button id='"_ID_"' name='SaveButton' onclick='SaveOneAdvice(this)' class='hisui-linkbutton' plain=true iconCls='icon-save-to'></button></TD>"
    ....s OneInfo=OneInfo_"<TD width=200 style='white-space:normal; word-break:break-all;border:0;'><textarea id='"_ID_"^JL' onpropertychange='setTareaAutoHeight(this)' style='width:100%; word-break:break-all;'>"_$P(Info,"^",1)_"</textarea></TD>"
    ....s OneInfo=OneInfo_"<TD width=2% style='white-space:normal; word-break:break-all;border:0;'>&nbsp;</TD>"
    ....s OneInfo=OneInfo_"<TD style='white-space:normal; word-break:break-all;border:0;'><textarea id='"_ID_"^JY' onpropertychange='setTareaAutoHeight(this)' style='width:100%;'>"_$P(Info,"^",2)_"</textarea></TD>"
    ....s OneInfo=OneInfo_"<TD width=5% style='display:none;white-space:normal; word-break:break-all;border:0;' id='"_ID_"^Sort'>"_Sort_"</TD>"
    ...e  d
    ....s OneInfo=OneInfo_"<TD width=5% style='white-space:normal; word-break:break-all;border:0;'><button id='"_ID_"' name='DeleteButton' onclick='DeleteAdvice(this,1)' class='hisui-linkbutton' plain=true iconCls='icon-cancel'></button></TD>"
    ....s OneInfo=OneInfo_"<TD width=5% style='white-space:normal; word-break:break-all;border:0;'><button id='"_ID_"' name='SaveButton' onclick='SaveOneAdvice(this)' class='hisui-linkbutton' plain=true iconCls='icon-save-to'></button></TD>"
    ....s OneInfo=OneInfo_"<TD width=45% style='white-space:normal; word-break:break-all;border:0;'><textarea id='"_ID_"^JL' onpropertychange='setTareaAutoHeight(this)' style='width:100%; word-break:break-all;'>"_$P(Info,"^",1)_"</textarea></TD>"
    ....s OneInfo=OneInfo_"<TD width=2% style='white-space:normal; word-break:break-all;border:0;'>&nbsp;</TD>"
    ....s OneInfo=OneInfo_"<TD style='white-space:normal; word-break:break-all;border:0'><textarea id='"_ID_"^JY' onpropertychange='setTareaAutoHeight(this)' style='width:100%;'>"_$P(Info,"^",2)_"</textarea></TD>"
    
    ....s OneInfo=OneInfo_"<TD width=5% style='display:none;white-space:normal; word-break:break-all;border:0;' id='"_ID_"^Sort'>"_Sort_"</TD>"
    ...// 修改乙肝标志 end
    ..s OneInfo=OneInfo_"</TR>"
    ..s ret=ret_OneInfo
    ..s i=i+1
    s ret=ret_"</Table></DIV>"
    q ret
}

/// Description: 获取站点结果
/// debug:w ##class(web.DHCPE.Result).GetResultByLocID("534","2",0,"N")
ClassMethod GetResultByLocID(PAADM, LocID, DivFlag As %String = 1, MainFlag As %String = "Y")
{
	s ^tempdhcpe("GetResultByLocID",PAADM, LocID)=$lb(PAADM, LocID, DivFlag, MainFlag)
	s Job=$j
	k ^TempOrderResultSort(Job)
	k ^TempOrderResultSortRisStudyNo(Job)
	k ^TempOrderResultSortLabNo(Job)
	s AdmLocID=$p($g(^PAADM(PAADM)),"^",4)
	s LisMerge=$G(^DHCPESetting("DHCPE","LisReportMerge",AdmLocID))

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
	.s RARRowId=$o(^DHCPACRegInfoi("OEORI",OrderID,0))
	.i RARRowId'="" d
	..s RisStudyNo=$p($g(^DHCPACRegInfo(RARRowId)),"^",2)
	..s:$D(^TempOrderResultSortRisStudyNo(Job,RisStudyNo)) QFlag=1
	..s ^TempOrderResultSortRisStudyNo(Job,RisStudyNo)=""
	.q:QFlag=1 //检查合并结果调用平台分开传
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
	.....i retInfo="" d
	......s retInfo=tmp01
	.....e  d
	......s retInfo=retInfo_$C(1)_tmp01

	;b ;retInfo
	i retInfo="" q "<TABLE><TR><TD style='white-space:normal; word-break:break-all;border:0;'>&nbsp;</TD></TR></TABLE>"
	s retInfo=##class(web.DHCPE.MainDiagnosisNew).ShowArrowColor(retInfo)
	s ret=""
	s Length=$L(retInfo,$C(1))
	s:DivFlag=1 ret="<div style='overflow-y:auto;width:100%;height:100%;white-space:normal; word-break:break-all;'>"
	s ret=ret_"<TABLE width=100% height=100% style='white-space:normal; word-break:break-all;border:0;'>"
	if MainFlag="Y"
	{
	i ResultFormat'=3 d
	.f i=1:2:Length  d
	..s ret=ret_"<TR align='left' valign='top' style='white-space:normal; word-break:break-all;border:0;'>"
	..s ret=ret_"<TD width=50% style='white-space:normal; word-break:break-all;border:0;'>"
	..s OneInfo=$P(retInfo,$C(1),i)
	..q:OneInfo=""
	..s ret=ret_"<label onclick='detailClick(this);' style='cursor:hand;white-space:normal; word-break:break-all;' id='"_$P(OneInfo,$C(2),3)_"'><b>"_$P(OneInfo,$C(2),1)_"：</b></label>"_$P(OneInfo,$C(2),2)
	..s ret=ret_"</TD>"
	..s ret=ret_"<TD width=50% style='white-space:normal; word-break:break-all;border:0;'>"
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
	..s ret=ret_"<TR align='left' valign='top' style='white-space:normal; word-break:break-all;border:0;'>"
	..s ret=ret_"<TD width=100% style='white-space:normal; word-break:break-all;border:0;'>"
	..s OneInfo=$P(retInfo,$C(1),i)
	..s ret=ret_"<label onclick='detailClick(this);' style='cursor:hand;style='white-space:normal; word-break:break-all;'' id='"_$P(OneInfo,$C(2),3)_"'><b>"_$P(OneInfo,$C(2),1)_"：</b></label>"_$P(OneInfo,$C(2),2)
	..s ret=ret_"</TD>"
	..s ret=ret_"</TR>"
	}
	else{
	f i=1:1:Length  d
	.s ret=ret_"<TR align='left' valign='top' style='white-space:normal; word-break:break-all;border:0;'>"
	.s ret=ret_"<TD width=99% style='white-space:normal; word-break:break-all; border:0;'>"
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

Storage Default
{
<Data name="ResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.ResultD</DataLocation>
<DefaultData>ResultDefaultData</DefaultData>
<IdLocation>^web.DHCPE.ResultD</IdLocation>
<IndexLocation>^web.DHCPE.ResultI</IndexLocation>
<StreamLocation>^web.DHCPE.ResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
