Class web.DHCLabResultEMR Extends %RegisteredObject
{

/// w ##Class(web.DHCLabResultEMR).getResultsByAdm("","",49334)
ClassMethod getResultsByAdm(itmjs As %Library.String = "", itmjsex As %Library.String = "", AmdID As %String) As %String
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMP($zn,$j,repid)
	s AmdID=$g(AmdID)
	s Ind=0
	s PatInfo="",TSRowIDLists=""
	s OrdId=""  f  s OrdId=$o(^OEORD(0,"Adm",AmdID,OrdId)) q:OrdId=""  d
	.s SubId=""	f  s SubId=$o(^OEORD(OrdId,"I",SubId)) q:SubId=""  d
	..s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
	..s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
	..s ReqDate=$p(OrdStr3,"^",7)
	..s ReqTime=$p(OrdStr1,"^",17)
	..//报告ID
	..s LabTestSetRow=$p(OrdStr3,"^",35)
	..s LabTestSetRow=$tr(LabTestSetRow,$c(0))
	..s LabEpisode=$p(OrdStr3,"^",20)
	..s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(LabEpisode),""))
	..i '$l(VisitNumberDR) q
	..i $l(LabTestSetRow) s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),5)
	..i '$l(WorkGroupMachineDR) q
	..s Order=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,""),-1)
	..i '$l(Order) q
	..s VisitNumberReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,Order,""))
	..i '$l(VisitNumberReportDR) q
	..i $lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),22)'=3 q
	..s ^TMP("HIS.DHCReportPrintEMR",$j,$i,"TSLIST",LabEpisode,VisitNumberReportDR)=""
    ..//标本信息
    ..s RPVisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDR))
    ..s PatName=""
    ..s SurName=$lg(RPVisitNumberData,13)
    ..s GivenName=$lg(RPVisitNumberData,14)
    ..i SurName=GivenName s PatName=SurName
    ..e  s PatName=SurName_GivenName
    ..s SpeciesDR=$lg(RPVisitNumberData,15),patSex=""
    ..i $l(SpeciesDR) s patSex=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),3)
    ..s Age=$lg(RPVisitNumberData,18)
    ..s AgeUnitDR=$lg(RPVisitNumberData,19),AgeUnit=""
    ..i $l(AgeUnitDR) s AgeUnit=$lg($g(^dbo.BTAgeUnitD(AgeUnitDR)),3)
    ..s patAge=Age_AgeUnit
    ..s LocationDR=$lg(RPVisitNumberData,22),PatLoc=""
    ..i $l(LocationDR) s PatLoc=$lg($g(^dbo.BTLocationD(LocationDR)),3)
    ..i PatLoc["-" s PatLoc=$p(PatLoc,"-",2)
	..s patBed=$lg(RPVisitNumberData,27)
	..s RegNo=$lg(RPVisitNumberData,3)
    ..s RecordNo=$lg(RPVisitNumberData,6)
	..s PatInfo=PatName_" "_patSex_" "_patAge_" "_PatLoc_" "_patBed_" "_RegNo_" "_RecordNo
	..i $d(^TMP($zn,$j,repid,VisitNumberReportDR)) q  ///报告已经存在
	..s ^TMP($zn,$j,repid,VisitNumberReportDR)=""
	..s TSRowIDLists=TSRowIDLists_"#"_VisitNumberReportDR
	..s Ind=Ind+1
	k ^TMP($zn,$j,repid)
	Quit Ind_"^"_PatInfo_"^"_TSRowIDLists
}

/// ##Class(web.DHCLabResultEMR).getData("","",31444)
ClassMethod getData(itmjs As %Library.String = "", itmjsex As %Library.String = "", VisitNumberReportDR As %String(MAXLEN=32767)) As %String
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMP($zn,$j,repid)

	S VisitNumberReportDR=$G(VisitNumberReportDR)
    s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),2)
	i '$l(VisitNumberDR) q ""
	s Ind=0
	//获取医嘱信息
    s TestSetDesc=""
    s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:TestSetDR=""  d
    .s VisNumTSDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR,""))
    .i '$l(VisNumTSDR) q
    .i $l(TestSetDesc) s TestSetDesc=TestSetDesc_"+"_$lg(^dbo.BTTestSetD(TestSetDR),3)
    .e  s TestSetDesc=$lg(^dbo.BTTestSetD(TestSetDR),3)

    //标本信息
    s RPVisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDR))
    s SpecimenDR=$lg(RPVisitNumberData,56),Specimen=""
    i $l(SpecimenDR) s Specimen=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	s Ind=Ind+1
	s ^TMP($zn,$j,repid,Ind)="2^"_TestSetDesc_"    "_Specimen
	//获取检验结果
	k ^TMP($zn,$j,repid,"Order")
	
	s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),4)
	s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR,TestCodeDR)) q:TestCodeDR=""  d 
 	.s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
 	.s TestCode=$lg(TestCodeData,2)
	.s TestCodeName=$lg(TestCodeData,3)
	.s TCSync=$lg(TestCodeData,7)
	.s ResultFormat=$LIST(TestCodeData,9) //结果格式(N数字,X文本,S列表,A血型ABO,R血型RH,M微生物)
 	.s ResultDR="" f  s ResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR,TestCodeDR,ResultDR)) q:ResultDR=""  d 
 	..s ResultData=$g(^dbo.RPVisitNumberReportResultD(ResultDR))
	..s Result=$lg(ResultData,5)
	..s Unit=$lg(ResultData,11) 
	..s AbFlag=$lg(ResultData,9)
	..s RefRanges=$lg(ResultData,12)
    ..//标志翻译
    ..i AbFlag="H" S AbFlag="↑"
    ..i AbFlag="L" S AbFlag="↓"
    ..i AbFlag="A" S AbFlag="*"	
	..s ResNoes=$lg(ResultData,8)
	..s MethodDR=$lg(ResultData,13)
	..s MethodName=""
	..s MethodCode=""
	..i $l(MethodDR) d
	...s MethodData=$g(^dbo.BTTestMethodD(MethodDR))
	...s MethodName=$lg(MethodData,3)
	...s MethodCode= $lg(MethodData,2)
 	..s Sequence=$lg(ResultData,18)
	..s (tcResultDsec2,tcResultDsec3,tcResultDsec4)=""
	..s (WGTCSequence,PrintOrder)=""
    ..s WorkGroupMachineTCDR=$o(^dbo.BTWorkGroupMachineTCI("IndexMaster",WorkGroupMachineDR,TestCodeDR,"")) 
    ..i $l(WorkGroupMachineTCDR) s WGTCSequence=$lg($g(^dbo.BTWorkGroupMachineTCD(WorkGroupMachineTCDR)),4)
	..i $l(WGTCSequence) s Sequence=WGTCSequence
	..s tcResultDsec2=$lg(ResultData,6)
	..s (CondRanges1,CondRanges2,CondRanges3,CondRanges4)=""
	..s Data=TestCodeDR_$c(2)_TestCodeName_$c(2)_TCSync_$c(2)_Result_$c(2)_AbFlag_$c(2)_Unit_$c(2)_RefRanges_$c(2)_MethodName_$c(2)_tcResultDsec2_$c(2)_tcResultDsec3_$c(2)_tcResultDsec4_$c(2)_CondRanges1_$c(2)_CondRanges2_$c(2)_CondRanges3_$c(2)_CondRanges4_$c(2)_MethodCode
	..i $d(^TMP($zn,$j,repid,"Order",Sequence)) s Sequence=TestCodeDR
	..s ^TMP($zn,$j,repid,"Order",Sequence)=Data
	..///抗生素结果
	..s AntSeq="" f  s AntSeq=$o(^dbo.RPVisitNumberReportResSenI("IndexSequence",ResultDR,AntSeq)) q:AntSeq=""  d
	...s senRowId=$o(^dbo.RPVisitNumberReportResSenI("IndexSequence",ResultDR,AntSeq,""))
	...s ReportResultSen=$g(^dbo.RPVisitNumberReportResSenD(senRowId))
	...s AntibioticsDR=$lg(ReportResultSen,3)
    ...s SenMethod=$lg(ReportResultSen,4)
	...s SenValue=$lg(ReportResultSen,5)
	...s SensitivityDR=$lg(ReportResultSen,6)
	...s AntibioticsName= $lg(^dbo.BTAntibioticsD(AntibioticsDR),3)
	...s SensitivityDR=$lg(ReportResultSen,6),SenCode="",Sensitivity=""
	...i $l(SensitivityDR) s Sensitivity=$lg(^dbo.BTSensitivityD(SensitivityDR),3),SenCode=$lg(^dbo.BTSensitivityD(SensitivityDR),2)
  	...i SenCode="S" s Sensitivity=Sensitivity_" *"
    ...s (temreport,AntClssName,CLSIR,CLSIS,BugsGroup,GPAntSeq)=""
    ...i SenMethod=1 d   //KB
    ....i $d(^TMP($zn,$j,repid,"Order",Sequence,"ANT",AntibioticsDR)) d
    .....s $p(^TMP($zn,$j,repid,"Order",Sequence,"ANT",AntibioticsDR),$c(2),3)=SenValue
    .....s $p(^TMP($zn,$j,repid,"Order",Sequence,"ANT",AntibioticsDR),$c(2),5)=Sensitivity
    ....e  s ^TMP($zn,$j,repid,"Order",Sequence,"ANT",AntibioticsDR)=AntibioticsDR_$c(2)_AntibioticsName_$c(2)_SenValue_$c(2)_""_$c(2)_Sensitivity_$c(2)_temreport_$c(2)_AntClssName_$c(2)_CLSIR_$c(2)_CLSIS
    ...i SenMethod=2 d   //MIC
    ....i $d(^TMP($zn,$j,repid,"Order",Sequence,"ANT",AntibioticsDR)) d
    .....s $p(^TMP($zn,$j,repid,"Order",Sequence,"ANT",AntibioticsDR),$c(2),4)=SenValue
    .....s $p(^TMP($zn,$j,repid,"Order",Sequence,"ANT",AntibioticsDR),$c(2),5)=Sensitivity
    ....e  s ^TMP($zn,$j,repid,"Order",Sequence,"ANT",AntibioticsDR)=AntibioticsDR_$c(2)_AntibioticsName_$c(2)_""_$c(2)_SenValue_$c(2)_Sensitivity_$c(2)_temreport_$c(2)_AntClssName_$c(2)_CLSIR_$c(2)_CLSIS
	
	//检验结果排序
	s ord="" f  s ord=$o(^TMP($zn,$j,repid,"Order",ord)) q:ord=""  d
	.s DataStr=$g(^TMP($zn,$j,repid,"Order",ord))
	.s tcDesc=$Piece(DataStr,$Char(2),2)
	.s tcSyn=$Piece(DataStr,$Char(2),3)
	.s tcResult=$Piece(DataStr,$Char(2),4)
	.s tcFlag=$Piece(DataStr,$Char(2),5)
	.s tcUnit=$Piece(DataStr,$Char(2),6)
	.s tcRanges=$Piece(DataStr,$Char(2),7)
	.s Ind=Ind+1
	.s ^TMP($zn,$j,repid,Ind)="3^"_tcDesc_"^"_tcSyn_"^"_tcResult_"^"_tcFlag_"^"_tcUnit_"^"_tcRanges
	.s ant="" f  s ant=$o(^TMP($zn,$j,repid,"Order",ord,"ANT",ant)) q:ant=""  d
	..s Ind=Ind+1
	..s antName=$p(^TMP($zn,$j,repid,"Order",ord,"ANT",ant),$c(2),2)
	..s mm=$p(^TMP($zn,$j,repid,"Order",ord,"ANT",ant),$c(2),3)
	..s mic=$p(^TMP($zn,$j,repid,"Order",ord,"ANT",ant),$c(2),4)
	..s senResDesc=$p(^TMP($zn,$j,repid,"Order",ord,"ANT",ant),$c(2),5)
	..s ^TMP($zn,$j,repid,Ind)="4^"_antName_"^"_senResDesc_"^"_mic_"^"_mm
	k ^TMP($zn,$j,repid,"Order")
	//获取检验审核信息
    s EntryDate=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),16)
    s EntryTime=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),17)
    s EntryUserDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),18),EntryUser="",EntryUserCode=""
    i $l(EntryUserDR) s EntryUser=$lg($g(^dbo.SYSUserD(EntryUserDR)),3),EntryUserCode=$lg($g(^dbo.SYSUserD(EntryUserDR)),2)
    s AuthDate=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),19)
    s AuthTime=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),20)
    s AuthUserDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),21),AuthUser="",AuthUserCode=""
    i $l(AuthUserDR) s AuthUser=$lg($g(^dbo.SYSUserD(AuthUserDR)),3),AuthUserCode=$lg($g(^dbo.SYSUserD(AuthUserDR)),2)
    s EntryDate=$e(EntryDate,1,4)_"-"_$e(EntryDate,5,6)_"-"_$e(EntryDate,7,8)
    s AuthDate=$e(AuthDate,1,4)_"-"_$e(AuthDate,5,6)_"-"_$e(AuthDate,7,8)
    s EntryTime=$zt(EntryTime,2),AuthTime=$zt(AuthTime,2) 
	
	s Ind=Ind+1
	s ^TMP($zn,$j,repid,Ind)="5^检验者:"_EntryUser_" "_EntryDate_" "_EntryTime_"  审核者:"_AuthUser_" "_AuthDate_" "_AuthTime
	s PatResults=""
	s Sep="" f  s Sep=$o(^TMP($zn,$j,repid,Sep)) q:Sep=""  d
	.i '$l(PatResults) s PatResults=$g(^TMP($zn,$j,repid,Sep))
	.e  s PatResults=PatResults_"@@"_$g(^TMP($zn,$j,repid,Sep))
	k ^TMP($zn,$j,repid)
	Quit Ind_"||"_PatResults
}

ClassMethod getResultsByAdmOLD(itmjs As %Library.String = "", itmjsex As %Library.String = "", AmdID As %String) As %String
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LABDATA=Config.LabDataNamespace
	If '$Length(LABDATA) Set LABDATA="LABDATA"
	k ^TMP($zn,$j,repid)
	s Ind=0
	s PatInfo="",TSRowIDLists=""
	s OrdId="" f  s OrdId=$o(^OEORD(0,"Adm",AmdID,OrdId)) q:OrdId=""  d
	.s SubId="" f  s SubId=$o(^OEORD(OrdId,"I",SubId)) q:SubId=""  d
	..//病案号
	..s papmiId=+$g(^PAADM(AmdID))
	..s safetyNetCardNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(AmdID)
	..s safetyNetCardNo="病案号:"_safetyNetCardNo
	..s OrdRowId=OrdId_"||"_SubId
	..s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
	..s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
	..s ItemStat=$p(OrdStr1,"^",13)
	..q:ItemStat=4  //医嘱停止
	..s ItmMastDr=$p(OrdStr1,"^",2)
	..i ItmMastDr="" q
	..s LabTestSetRow=$p(OrdStr3,"^",35)
	..i LabTestSetRow="" q  //报告ID
	..s isLabTS=##Class(web.DHCLabOrder).isLabTS(ItmMastDr)
	..q:isLabTS="0"  
	..s LabNo=$p(LabTestSetRow,"||",1)
	..s TS=$p(LabTestSetRow,"||",2)
	..s TSCnt=$p(LabTestSetRow,"||",3)
	..q:'$l(LabNo)
	..q:'$l(TS)
	..q:'$l(TSCnt)
	..i '$d(^TEPI(LabNo,1,TS,TSCnt)) q
	..i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)'="A" q
	..//获取病人信息
	..s patName="姓名:"_##Class(web.DHCLabCommon).GetPatName(LabNo)
	..S patSex="性别:"_##Class(web.DHCLabCommon).GetSpecies(LabNo)
	..s patAge="年龄:"_##Class(web.DHCLabCommon).GetPatAge(LabTestSetRow,OrdRowId)
	..s LocCode=$p(^TEPI(LabNo),"\",36)
	..s PatLoc="" 
	..i LocCode'="",$d(^TTAB("USLOC",LocCode)) s PatLoc=$p($g(^TTAB("USLOC",LocCode)),"\",1)
	..i PatLoc["-" s PatLoc=$p(PatLoc,"-",2)
	..s PatLoc="科别:"_PatLoc
	..s patBed="床号:"_$p($g(^TEPI(LabNo,0)),"\",29)
	..s debtor="登记号:"_$p(^TEPI(LabNo),"\",18)
	..s PatInfo=patName_" "_patSex_" "_patAge_" "_PatLoc_" "_patBed_" "_debtor_" "_safetyNetCardNo
	..s TSRowIDLists=LabTestSetRow_"#"_TSRowIDLists
	..s Ind=Ind+1
	Quit Ind_"^"_PatInfo_"^"_TSRowIDLists
}

ClassMethod getDataOLD(itmjs As %Library.String = "", itmjsex As %Library.String = "", LabTestSetRow As %String) As %String
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LABDATA=Config.LabDataNamespace
	If '$Length(LABDATA) Set LABDATA="LABDATA"
	k ^TMP($zn,$j,repid)
	s Ind=0
	s LabNo=$p(LabTestSetRow,"||",1)
	s TS=$p(LabTestSetRow,"||",2)
	s TSCnt=$p(LabTestSetRow,"||",3)
	i '$l(LabNo) q ""
	i '$l(TS) q ""
	i '$d(^TEPI(LabNo,1,TS,TSCnt)) q ""
	//获取医嘱信息
	s tsName=$p($g(^TTAB("TS",TS)),"\",1)
	s SpecCode=$p(^TEPI(LabNo,1,TS,TSCnt),"\",46) ;标本类型
	s Specimen=""
 	If $l(SpecCode),$d(^TTAB("SPEC",SpecCode)) s Specimen=$p(^TTAB("SPEC",SpecCode),"\",1)
	s Ind=Ind+1
	s ^TMP($zn,$j,repid,Ind)="2^"_tsName_"        "_Specimen
	//获取检验结果
	k ^TMP($zn,$j,repid,"Order")
	S tc="" f  s tc=$Order(^TEPI(LabNo,1,TS,TSCnt,"DATA",tc))	Q:tc=""  d
	.s resStr=$p(^TEPI(LabNo,1,TS,TSCnt,"DATA",tc),"\",1)
	.s RecDate=$P(^TEPI(LabNo,1,TS,TSCnt),"\",21)
	.s temres=##Class(web.DHCLabTestCode).GetTestCodeResult(LabNo,tc,resStr,RecDate)
	.i '$d(^TTAB("TC",tc,1,TS)) q
	.s Order1=$p(^TTAB("TC",tc,1,TS),"\",1)
	.s LayOrder=$p(^TTAB("TC",tc,1,TS),"\",2)
	.s Order=$p(^TTAB("TS",TS,LayOrder,Order1),"\",15)
	.s ^TMP($zn,$j,repid,"Order",Order)=temres
	.//获取细菌结果
	.s ant="" f  s ant=$o(^TEPI(LabNo,1,TS,TSCnt,"DATA",tc,"ANT",ant)) q:ant=""  d
	..s temStr=$g(^TEPI(LabNo,1,TS,TSCnt,"DATA",tc,"ANT",ant))
	..s antName=""
	..i $d(^TTAB("ANT",ant)) s antName=$p(^TTAB("ANT",ant),"\",1)
	..s senResDr=$p(temStr,"\",1)
	..s senResDesc=""
	..i $l(senResDr),$d(^TTAB("SENS",senResDr)) s senResDesc=$p(^TTAB("SENS",senResDr),"\",1)
	..s report=$p(temStr,"\",2)
	..s mic=$p(temStr,"\",3)
	..s mm=$p(temStr,"\",4)
	..i $e(mic,1)="." s mic="0"_mic
	..i $e(mm,1)="." s mm="0"_mm
	..s ^TMP($zn,$j,repid,"Order",Order,"ANT",ant)=antName_"^"_senResDesc_"^"_mic_"^"_mm
	//检验结果排序
	s ord="" f  s ord=$o(^TMP($zn,$j,repid,"Order",ord)) q:ord=""  d
	.s DataStr=$g(^TMP($zn,$j,repid,"Order",ord))
	.s tcDesc=$Piece(DataStr,$Char(2),2)
	.s tcSyn=$Piece(DataStr,$Char(2),7)
	.s tcResult=$Piece(DataStr,$Char(2),3)
	.s tcUnit=$Piece(DataStr,$Char(2),4)
	.s tcFlag=$Piece(DataStr,$Char(2),5)
	.s tcRanges=$Piece(DataStr,$Char(2),6)
	.s Ind=Ind+1
	.s ^TMP($zn,$j,repid,Ind)="3^"_tcDesc_"^"_tcSyn_"^"_tcResult_"^"_tcFlag_"^"_tcUnit_"^"_tcRanges
	.s ant="" f  s ant=$o(^TMP($zn,$j,repid,"Order",ord,"ANT",ant)) q:ant=""  d
	..s Ind=Ind+1
	..s ^TMP($zn,$j,repid,Ind)="4^"_$g(^TMP($zn,$j,repid,"Order",ord,"ANT",ant))
	k ^TMP($zn,$j,repid,"Order")
	//获取检验审核信息
	s AuthUser=$p(^TEPI(LabNo,1,TS,TSCnt),"\",6)
 	i $l(AuthUser),$d(^[LABDATA]SSU("SSUSR",1,AuthUser)) s AuthUser=$p(^[LABDATA]SSU("SSUSR",1,AuthUser),"^",2) 
   	s AuthDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",4)
    s AuthTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",5)
	i $l(AuthDate) s AuthDate=$zd(AuthDate,3)
    i $l(AuthTime) s AuthTime=$zt(AuthTime*60,2)
    s EntDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",1)
    s EntTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",2)
    s EntUser=$p(^TEPI(LabNo,1,TS,TSCnt),"\",3)
 	i $l(EntUser),$d(^[LABDATA]SSU("SSUSR",1,EntUser)) s EntUser=$p(^[LABDATA]SSU("SSUSR",1,EntUser),"^",2) 
	i $l(EntDate) s EntDate=$zd(EntDate,3)
    i $l(EntTime) s EntTime=$zt(EntTime*60,2)
	s Ind=Ind+1
	s ^TMP($zn,$j,repid,Ind)="5^检验者:"_EntUser_" "_EntDate_" "_EntTime_"  审核者:"_AuthUser_" "_AuthDate_" "_AuthTime
	s PatResults=""
	s Sep="" f  s Sep=$o(^TMP($zn,$j,repid,Sep)) q:Sep=""  d
	.i '$l(PatResults) s PatResults=$g(^TMP($zn,$j,repid,Sep))
	.e  s PatResults=PatResults_"@@"_$g(^TMP($zn,$j,repid,Sep))
	k ^TMP($zn,$j,repid)
	Quit Ind_"||"_PatResults
}

}
