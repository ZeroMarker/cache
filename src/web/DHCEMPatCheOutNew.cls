Class web.DHCEMPatCheOutNew Extends %Persistent [ ProcedureBlock ]
{

/// d ##class(web.DHCEMPatCheOutNew).OrderList("0","15","-1","12","","","","","","","","","","","","","")
/// d ##class(web.DHCEMPatCheOutNew).OrderList("0","15","154","125","","","","0","","","4","0","","","","Y")
ClassMethod OrderList(offset = 0, limit = 10, EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag, ArcimDr, ItemDr, Sessions, Output RowCount As %String) As %Status
{
 	S End = offset+limit
	S Start = offset+1
    S count=0
	S jsonObj=##class(web.DHCAPPJsonObject).%New()
	w "{""rows"":["
	s EpisodeID=$g(EpisodeID),PatientID=$g(PatientID)
	;i FromDate["-" s FromDate=$zdh(FromDate,3)
	;i FromDate["/" s FromDate=$zdh(FromDate,2)
	i FromDate'="" s FromDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(FromDate)
	i FromDate="" s FromDate=63915
	;i ToDate["-" s ToDate=$zdh(ToDate,3)
	;i ToDate["/" s ToDate=$zdh(ToDate,2)
	i ToDate'="" s ToDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(ToDate)
	i ToDate="" s ToDate=+$h
	s UserId=$g(UserId)
	//科室
	s LocCode=$g(LocCode)
	;i $l(LocCode) s LocId=$o(^CTLOC(0,"Code",LocCode,""),-1)
	//是否审核
	s AuthFlag=$g(AuthFlag)
	//所有医嘱
	s AllTS=$g(AllTS)
	i '$l(AllTS) s AllTS="N"
	//就诊日期范围  1:三月 2:半年 3:一年 4:所有
	s AdmDateFlag=$g(AdmDateFlag)
	///是否打印
	s fPrintFlag=$g(fPrintFlag)
	i fPrintFlag="N" s AuthFlag=1  ///
	///全部就诊
	i EpisodeID="-1" s EpisodeID=""	
	k ^TMP($zn,$i,$j)
	i $l(EpisodeID) d GetOrderByEpisode(EpisodeID,ArcimDr)

	i '$l(EpisodeID),$l(PatientID) d  //only
	.s type="" f  s type=$o(^PAPERdr(PatientID,"ADM",type)) q:type=""  d   //通过病人ID 取出病人就诊ID
	..s ADMId="" f  s ADMId=$o(^PAPERdr(PatientID,"ADM",type,ADMId),-1) q:ADMId=""  d
	...s AdmLoc=$p(^PAADM(ADMId),"^",4) //PAADM 就诊表  就诊科室
	...s AdmDate=$p(^PAADM(ADMId),"^",6)  //接诊日期
	...///日期范围
	...i AdmDateFlag="1",(+$H-AdmDate)>90 Q
	...i AdmDateFlag="2",(+$H-AdmDate)>182 Q
	...i AdmDateFlag="3",(+$H-AdmDate)>365 Q
	...i $l(LocCode),LocCode'=AdmLoc q
	...d GetOrderByEpisode(ADMId,ArcimDr)   //就诊表id
	
	s num=0
	s labno="" f  s labno=$o(^TMP($zn,$i,$j,labno),-1) q:labno=""  d   //?
	.s ItmStat="" f  s ItmStat=$o(^TMP($zn,$i,$j,labno,ItmStat)) q:ItmStat=""  d
	..s WorkGroupMachineDR="" f  s WorkGroupMachineDR=$o(^TMP($zn,$i,$j,labno,ItmStat,WorkGroupMachineDR)) q:WorkGroupMachineDR=""  d
	...s (OrdRowIds,OrdNames,ReqDateTime,ResultStatus,LabEpisode,LabTestSetRow,SpecName,SpecDateTime,RecDateTime,AuthDateTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,EpisodeNo,AdmDate,AdmLoc,AdmType,ReadFlag,MajorConclusion)=""
	...s OrdRowId="" f  s OrdRowId=$o(^TMP($zn,$i,$j,labno,ItmStat,WorkGroupMachineDR,OrdRowId)) q:OrdRowId=""  d
	....s OrdId=$p(OrdRowId,"||",1),SubId=$p(OrdRowId,"||",2)
	....//病人所属医院
	....s Adm=$p(^OEORD(OrdId),"^",1),locCode="",HospID="",HospitalCode="",AdmLoc=""
	....i $l(Adm),$d(^PAADM(Adm)) s locCode=$p(^PAADM(Adm),"^",4)
	....i $l(locCode) s HospID=$p(^CTLOC(locCode),"^",22),AdmLoc=$p(^CTLOC(locCode),"^",2)
	....i AdmLoc["-" s AdmLoc=$p(AdmLoc,"-",2)
	....i $l(HospID) s HospitalCode=$p(^CT("HOSP",HospID),"^",1)
	....//就诊日期
	....s AdmDate=$p(^PAADM(Adm),"^",6)
	....i $l(AdmDate) s AdmDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(AdmDate) //$zd(AdmDate,3)
	....s AdmType=$p(^PAADM(Adm),"^",2)
	....i AdmType="O" s AdmType="门诊"
	....i AdmType="I" s AdmType="住院"
	....i AdmType="E" s AdmType="急诊"
	....i AdmType="H" s AdmType="体检"
	....s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
	....s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
	....s ItmMastDr=$p(OrdStr1,"^",2)
	....s OrdName=$p($g(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)),"^",2)
	....q:(ArcimDr'="")&(ItmMastDr'=ArcimDr)
	....i $l(OrdRowIds) s OrdRowIds=OrdRowIds_","_OrdRowId
	....e  s OrdRowIds=OrdRowId
	....i $l(OrdNames) s OrdNames=OrdNames_"+"_OrdName
	....e  s OrdNames=OrdName
	....//申请日期时间
	....s ReqDate=$p(OrdStr3,"^",7)
	....s ReqTime=$p(OrdStr1,"^",17)
	....i $l(ReqDate) s ReqDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(ReqDate) //$zd(ReqDate,3)
	....i $l(ReqTime) s ReqTime=$zt(ReqTime)
	....s ReqDateTime=ReqDate_" "_ReqTime
	....s LabTestSetRow=$p(OrdStr3,"^",35)
	....s LabTestSetRow=$tr(LabTestSetRow,$c(0))
	....//标本类型
	....s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
	....s (SpecCode,SpecName)=""
	....i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
	....i $l(SpecCode) s SpecName=$p(##Class(web.DHCEMPatCheOutNew).GetSpecimen(SpecCode,HospitalCode),$c(2),2) 
	....//采集日期时间Collection
	....s (SpecDate,SpecTime)=""
	....s retval=##Class(web.DHCEMPatCheOutNew).GetspecCollDatetime(OrdRowId)  
	....i $l(retval) d
	.....s SpecDate=$p(retval,"^",2)
	.....i $l(SpecDate) s SpecDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(SpecDate) //$zd(SpecDate,3)
	.....s SpecTime=$p(retval,"^",3)
	.....i $l(SpecTime) s SpecTime=$zt(SpecTime)
	....s SpecDateTime=SpecDate_" "_SpecTime
	....//接收日期
	....s VisitNumberDR=$g(^TMP($zn,$i,$j,labno,ItmStat,WorkGroupMachineDR,OrdRowId))
	....s VisitNumberReportDR="",TSMemo="",PrintFlag=""
	....i $l(VisitNumberDR) d
	.....s RecDate=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),66)
	.....s RecTime=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),67)
	.....i $l(RecTime) s RecTime=$zt(RecTime)
	.....i $l(RecDate) s RecDateTime=$e(RecDate,1,4)_"-"_$e(RecDate,5,6)_"-"_$e(RecDate,7,8)_" "_RecTime
	.....///审核日期
	.....s Order=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,""))
	.....i $l(Order) d 
	......s VisitNumberReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,Order,""))
	......s AuthDate=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),19)
	......s AuthTime=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),20)
	......i $l(AuthTime) s AuthTime=$zt(AuthTime)
	......i $l(AuthDate) s AuthDateTime=$e(AuthDate,1,4)_"-"_$e(AuthDate,5,6)_"-"_$e(AuthDate,7,8)_" "_AuthTime
	......//s TSMemo=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),40)       //MajorConclusion
	......s MajorConclusion = $lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),40)
	......s ResultStatus=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),22)   //(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)
	......//结果异常标志
	......s TSResultAnomaly=##class(web.DHCEMPatCheOutNew).checkTSResultStatus(VisitNumberReportDR)   
	......///打印标记
	......s PrintFlag=##Class(web.DHCEMPatCheOutNew).GetPrintFlag(VisitNumberReportDR,UserId)  
	......//阅读标记
	......i $l(UserId),(ResultStatus=3) s ReadFlag=##Class(web.DHCEMPatCheOutNew).ReportViewLog(VisitNumberReportDR,UserId,HospID) 
	.....///危机值提示
	.....s TransComm=##Class(web.DHCEMPatCheOutNew).GetPanicMsg(VisitNumberDR)  //qiao
	....///获取医嘱状态信息
	....i '$l(TSMemo) s TSMemo=##Class(web.DHCEMPatCheOutNew).checkTSMemo(OrdRowId,VisitNumberReportDR,VisitNumberDR)   //qiao
	...i (fReadFlag=1),(ResultStatus'=3) q               ///未阅读
	...i (fReadFlag=1),(ResultStatus=3),(ReadFlag=1) q  ///未阅读
	...i (AuthFlag=1),(ResultStatus'=3) q   //是否出报告
	...i (ItemDr'=""),(ResultStatus'=3) q	//按照项目名称过滤
	...i fPrintFlag="N",PrintFlag="Y" q
	...s LabEpisode=labno
	...s HasItemFlag=##class(web.DHCEMPatCheOutNew).IsHasItem(VisitNumberReportDR,ItemDr)
	...q:(HasItemFlag="")&(VisitNumberReportDR'="")&(ItemDr'="")
	...s DataStr=count_"^"_VisitNumberReportDR_"^"_OrdRowIds_"^"_OrdNames_"^"_ReqDateTime_"^"_ResultStatus_"^"_LabEpisode_"^"_LabTestSetRow_"^"_SpecName_"^"_SpecDateTime_"^"_RecDateTime_"^"_AuthDateTime_"^"_ReportFlag_"^"_TransComm_"^"_TSResultAnomaly_"^"_TSMemo_"^"_Adm_"^"_AdmDate_"^"_AdmLoc_"^"_AdmType_"^"_ReadFlag_"^"_PrintFlag_"^"_MajorConclusion
	...d OutputRow
	W "],""total"":"_count_"}"
	k ^TMP($zn,$i,$j)
	k TMP($zn,$j)
	Q ""
	
	
OutputRow
	S title="ID^VisitNumberReportDR^OEOrdItemID^OrdItemName^ReqDateTime^ResultStatus^LabEpisode^LabTestSetRow^OrdSpecimen^SpecDateTime^RecDateTime^AuthDateTime^PreReport^WarnComm^TSResultAnomaly^TSMemo^AdmNo^AdmDate^AdmLoc^AdmType^ReadFlag^PrintFlag^MajorConclusion"
	S count=count+1      
	Q:count<Start
	Q:count>End
	W $case(count,Start:"",:",")
	W ##class(web.DHCAPPJsonCommon).getJsonData(title,DataStr)  
	quit
///	EpisodeNo就诊表的rowId
GetOrderByEpisode(EpisodeNo,ArcimDr)  
	s OrdId=""  f  s OrdId=$o(^OEORD(0,"Adm",EpisodeNo,OrdId)) q:OrdId=""  d   //OE_Order 医嘱主表
	.s SubId=""	f  s SubId=$o(^OEORD(OrdId,"I",SubId),-1) q:SubId=""  d        
	..s OrdRowId=OrdId_"||"_SubId
	..s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))  //详细的医嘱信息
	..s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
	..s ItmMastDr=$p(OrdStr1,"^",2)   //一个rowID
	..q:(ArcimDr'="")&(ItmMastDr'=ArcimDr)
	..i '$l(ItmMastDr) q	//为空终止	
	..i '##Class(web.DHCLabOrder).isLabTS(ItmMastDr) q  //检查医嘱项目是否是否检验医嘱，这里是检验结果查询
	..s OrdName=$p($g(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)),"^",2)  //医嘱项名字v1   ARCIM(ARCID,sub,1)
	..//比较申请日期,
	..s ReqDate=$p(OrdStr3,"^",7)     
	..i $l(ReqDate),$l(FromDate),ReqDate-FromDate<0 q
	..i $l(ReqDate),$l(ToDate),ReqDate-ToDate>0 q
	..//检验号,v2
	..s LabEpisode=$p(OrdStr3,"^",20) //OEORI_LabEpisodeNo 这个字段
	..i '$l(LabEpisode) q
	..//报告ID
	..s LabTestSetRow=$p(OrdStr3,"^",35)  //OEORI_LabTestSetRow
	..s LabTestSetRow=$tr(LabTestSetRow,$c(0)) //去掉$c(0)
	..s ItmStat=$p(OrdStr1,"^",13) 
	..i '$l(ItmStat) q
	..s WorkGroupMachineDR="NULL"
	..s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(LabEpisode),""))
	..i $l(LabTestSetRow) s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),5)
	..i '$l(WorkGroupMachineDR) s WorkGroupMachineDR="NULL"
	..s ^TMP($zn,$i,$j,LabEpisode,ItmStat,WorkGroupMachineDR,OrdRowId)=VisitNumberDR  //排序
	q
}

/// w ##class(web.DHCEMPatCheOutNew).QryTSInfo("0","15","51")
ClassMethod QryTSInfo(offset = 0, limit = 10, ReportDR, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	;s ^joe(2)=offset_"^"_limit_"^"_ReportDR
	S End = offset+limit
	S Start = offset+1
    S count=0
	S jsonObj=##class(web.DHCAPPJsonObject).%New()
	w "{""rows"":["
	
	set ReportDR=$g(ReportDR),Sessions=$g(Sessions)
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
	//Set repid=$i(^CacheTemp)
	s RowCount=0
	//i '$l(ReportDR) {
	//	Set qHandle=$lb(0,repid,0)
	//	Quit $$$OK
	//}
	i '$l(ReportDR) q ""
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),2)
	//i '$l(VisitNumberDR) {//没有数据
	//	Set qHandle=$lb(0,repid,0)
	//	Quit $$$OK
	//}
	i '$l(VisitNumberDR) q ""
	k ^TMP($zn,$i,$j)
	s TransmitDate=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),3)
	s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),4)
	s AssayNo=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),6)
	s RPVisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDR))
	s RegNo=$lg(RPVisitNumberData,3)
	s AdmNo=$lg(RPVisitNumberData,5)
	s SpeciesDR=$lg(RPVisitNumberData,15)
	s Age=$lg(RPVisitNumberData,18)
	s LocDR=$lg(RPVisitNumberData,22)
	s SpecimenDR=$lg(RPVisitNumberData,56)
	s AuthDate=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),19)
	s AuthTime=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),20)
	s ReAuthDate=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),23)
	s ReAuthTime=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),24)
	//如果有重审时间，审核时间为重审时间，用于前次结果查询
	i $l($g(ReAuthDate)) s AuthDate = ReAuthDate
	i $l($g(ReAuthTime)) s AuthTime = ReAuthTime
	s Status=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),22)
	s CondDR=$lg(RPVisitNumberData,35),mi="",PatType=""
	
	s TestCodeDRs = ##Class(web.DHCEMPatCheOutNew).GetTestCodeDRsByReportDR(ReportDR)   //qiao
	i $l(TestCodeDRs) {
		s TLength = $l(TestCodeDRs,",")
		for i=1:1:TLength {
			s TestCodeDR = $p(TestCodeDRs,",",i)
			s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
			s TestCodeName = $lg(TestCodeData,3)
			s Synonym = $lg(TestCodeData,7) //缩写
			s Units = $lg(TestCodeData,8) //单位
			s $LIST(TestCodeData,1)=TestCodeDR
			s ResultFormat=$LIST(TestCodeData,9) //结果格式(N数字,X文本,S列表,A血型ABO,R血型RH,M微生物)
			s ReportResult=##Class(LIS.WS.BLL.DHCRPVisitNumberReport).GetReportResult(ReportDR,TestCodeDR)
			s ResClass =  $lg(ReportResult,10) //结果类别(0普通,1危急)
			s Result = $lg(ReportResult,5)
			s ExtraRes = $lg(ReportResult,6)
			//结果描述，细菌名称
	        //i ResultFormat="M",$l(Result) d  s Result=$lg(^dbo.BTOrganismD(Result),3)

			s AbFlag = $lg(ReportResult,9) //异常提示
			s RefRanges = $lg(ReportResult,12) //参考范围
			s ClinicalSignifyS = $lg(TestCodeData,20) //临床意义
			s (ValueLow,ValueHigh,PanicLow,PanicHigh,UnacceptLow,UnacceptHigh)=""

			//获取前一次结果
			s PreResultList=##Class(LIS.WS.BLL.DHCRPVisitNumberReport).GetPreResult(RegNo,TestCodeDR,AuthDate,AuthTime)  
			s PreResult=$p(PreResultList,"^",1),PreAbFlag=$p(PreResultList,"^",2),PreResultDR=$p(PreResultList,"^",3)
			;w Synonym_"$"_Result_"$"_PreResult,!
			continue:Result="" //(Result="")&(PreResult="") //hxy 2017-02-23 过滤本次结果没有的项目
			s PreResultList=$lb(PreResult,PreAbFlag,PreResultDR)
			s TCSequence=$li(ReportResult,18)
	  		s (WGTCSequence,PrintOrder)=""
    		s WorkGroupMachineTCDR=$o(^dbo.BTWorkGroupMachineTCI("IndexMaster",WorkGroupMachineDR,TestCodeDR,"")) 
    		i $l(WorkGroupMachineTCDR) s WGTCSequence=$lg($g(^dbo.BTWorkGroupMachineTCD(WorkGroupMachineTCDR)),4)
			i $l(WGTCSequence) s TCSequence=WGTCSequence
			s Data=$lb(TestCodeDR,Synonym,TestCodeName,Units,ResultFormat,ResClass,Result,ExtraRes,AbFlag,RefRanges,ClinicalSignifyS)_PreResultList
			i $l(TCSequence),$d(^TMP($zn,$i,$j,"DATA",TCSequence)) s TCSequence=TestCodeDR
			i '$l(TCSequence) s TCSequence=TestCodeDR
			i $d(^TMP($zn,$i,$j,"DATA",TCSequence)) s TCSequence=TCSequence+999
			s ^TMP($zn,$i,$j,"DATA",TCSequence)=Data
		}
	 	s TCSequence="" f  s TCSequence=$o(^TMP($zn,$i,$j,"DATA",TCSequence)) q:TCSequence=""  d
	 	.s Data=$g(^TMP($zn,$i,$j,"DATA",TCSequence))
 		.d OutPut
		
	}
	
 	W "],""total"":"_count_"}"
 	k ^TMP($zn,$i,$j)
	k TMP($zn,$j)
	Q ""
OutPut
	set ColFields="TestCodeDR,Synonym,TestCodeName,Units,ResultFormat,ResClass,Result,ExtraRes,AbFlag,RefRanges,ClinicalSignifyS,PreResult,PreAbFlag,PreResultDR"
 	Set data=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set dataStr = $lg(data,1)_"@"_$lg(data,2)_"@"_$lg(data,3)_"@"_$lg(data,4)_"@"_$lg(data,5)_"@"_$lg(data,6)_"@"_$lg(data,7)_"@"_$lg(data,8)_"@"_$lg(data,9)_"@"_$lg(data,10)_"@"_$lg(data,11)_"@"_$lg(data,12)_"@"_$lg(data,13)_"@"_$lg(data,14)
 	Set title = "TestCodeDR@Synonym@TestCodeName@Units@ResultFormat@ResClass@Result@ExtraRes@AbFlag@RefRanges@ClinicalSignifyS@PreResult@PreAbFlag@PreResultDR"
 	S count=count+1      
	Q:count<Start
	Q:count>End
	W $case(count,Start:"",:",")
	W ##class(web.DHCAPPJsonCommon).getJsonData(title,dataStr,"@")  
	Quit
}

/// Creator：      
/// CreatDate：    
/// Description:   标本历史结果查询
/// Table：        RP_VisitNumberReportResult
/// Input：        VisitNumberReportDR:标本报告RowID
/// Output：       AssayDate:检测日期，AssayTime:检测时间，TestCodeName:检验项目名称，Result:结果，AbFlag:异常提示
/// w ##Class(web.DHCEMPatCheOutNew).GetHistoryResultMTHD("346","44,0","","","","","","","","","","","","","65^2^^8^1")
ClassMethod GetHistoryResultMTHD(VisitNumberReportDR, TestCodeDR, SttDate, EndDate, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{

	s AuthDate = ""
	s AuthTime = ""
	s retJson = ""
	s dataHead = ""
	s TestCodeDRs = TestCodeDR
	set ReportDR=$g(VisitNumberReportDR)
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
	s total=0
	i '$l(TestCodeDR) {
		s TestCodeDRs = ##Class(web.DHCEMPatCheOutNew).GetTestCodeDRsByReportDR(ReportDR)
	}
	
	k ^TMP($zn,$j)
	s TLength = $l(TestCodeDRs,",")
	for i=1:1:TLength {
		s TestCodeDR = $p(TestCodeDRs,",",i)
		q:TestCodeDR=""
		s TestCodeName = $lg(^dbo.BTTestCodeD(TestCodeDR),3)
		s Units = $lg(^dbo.BTTestCodeD(TestCodeDR),8)
		s ResultFormat = $lg(^dbo.BTTestCodeD(TestCodeDR),9)
		s oneData = ""
		s ColID = 0
	
		s VisitNumberDR=$lg(^dbo.RPVisitNumberReportD(VisitNumberReportDR),2)
		s RegNo=$lg(^dbo.RPVisitNumberD(VisitNumberDR),3)		
		for {
			s AuthDate = $o(^dbo.RPVisitNumberReportResultI("IndexPatientItem"," "_RegNo,TestCodeDR,AuthDate),-1)
			q:AuthDate=""
			for {
				s AuthTime = $o(^dbo.RPVisitNumberReportResultI("IndexPatientItem"," "_RegNo,TestCodeDR,AuthDate,AuthTime),-1)
				q:AuthTime=""
				s ColID = ColID+1
				s VisitNumberReportResultDR = $o(^dbo.RPVisitNumberReportResultI("IndexPatientItem"," "_RegNo,TestCodeDR,AuthDate,AuthTime,""))
				s VisitNumberReportDR = $lg(^dbo.RPVisitNumberReportResultD(VisitNumberReportResultDR),2)
				s ReportAuthDate = $lg(^dbo.RPVisitNumberReportD(VisitNumberReportDR),19)
				s ReportAuthTime = $lg(^dbo.RPVisitNumberReportD(VisitNumberReportDR),20)
				s Status = $lg(^dbo.RPVisitNumberReportD(VisitNumberReportDR),22)
				if Status'="3" continue
		    	s Result = $lg(^dbo.RPVisitNumberReportResultD(VisitNumberReportResultDR),5)
		    	s AbFlag = $lg(^dbo.RPVisitNumberReportResultD(VisitNumberReportResultDR),9)
		    	s RefRanges = $lg(^dbo.RPVisitNumberReportResultD(VisitNumberReportResultDR),12)
		    	i TestCodeName = "备注" continue
		    	s ^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime,TestCodeDR)=Result_"^"_AbFlag_"^"_RefRanges
			}
		}
	}
	s ColID=0
	s (ReportAuthTime,ReportAuthDate,dataHead) = ""
	i $l($g(EndDate)) s ReportAuthDate = $o(^TMP($zn,$j,"DATA",EndDate))
	i $l($g(SttDate)) s SttDate = $o(^TMP($zn,$j,"DATA",SttDate),-1)
	for i=1:1:TLength {
		s TestCodeDR = $p(TestCodeDRs,",",i)
		q:TestCodeDR=""
		s Units = $lg(^dbo.BTTestCodeD(TestCodeDR),8)
		s ResultFormat = $lg(^dbo.BTTestCodeD(TestCodeDR),9)
		i '$l(dataHead) {
			for {
				s ReportAuthDate = $o(^TMP($zn,$j,"DATA",ReportAuthDate),-1)
				q:ReportAuthDate=$g(SttDate)
				for {
					s ReportAuthTime = $o(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime),-1)
					q:ReportAuthTime=""
					s ColID = ColID + 1
					s RefRanges = $p($g(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime,TestCodeDR)),"^",3)
					s dataHead = dataHead_"""Col"_ColID_""":"_""""_ReportAuthDate_" "_$zt(ReportAuthTime)_""",""AbFlag"_ColID_""":"_"""AbFlag"_ColID_""",""RefRanges"_ColID_""":""RefRanges"_ColID_""","
				}
			}
		}
		s TestCodeName = $lg(^dbo.BTTestCodeD(TestCodeDR),3)
		i TestCodeName = "备注" continue
		s oneData = ""
		s ColID = 0
		s ReportAuthDate=""
		for {
			s ReportAuthDate = $o(^TMP($zn,$j,"DATA",ReportAuthDate),-1)
			q:ReportAuthDate=""
			for {
				s ReportAuthTime = $o(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime),-1)
				q:ReportAuthTime=""
				s ColID = ColID + 1
				s AuthDate1 = $o(^TMP($zn,$j,"DATA",ReportAuthDate),-1)
				s AuthTime1 = $o(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime),-1)
				s Result = ""
				s AbFlag = ""
				i $l($g(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime,TestCodeDR))) d
				.s Result = $p(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime,TestCodeDR),"^",1)
				.s AbFlag = $p(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime,TestCodeDR),"^",2)
				.s RefRanges = $p(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime,TestCodeDR),"^",3)
				s oneData = oneData_"""Col"_ColID_""":"_""""_Result_""",""AbFlag"_ColID_""":"""_AbFlag_""",""RefRanges"_ColID_""":"""_RefRanges_""","
			}
		}
		
		s oneData = $e(oneData,1,$l(oneData)-1)
		s retJson = $s($l(oneData):retJson_"{""TestCodeName"":"""_TestCodeName_""",""Units"":"""_Units_""",""ResultFormat"":"""_ResultFormat_""","_oneData_"},",1:retJson_"{""TestCodeName"":"""_TestCodeName_"""},")
	}
	s dataHead = $e(dataHead,1,$l(dataHead)-1)
	s retJson = $e(retJson,1,$l(retJson)-1)
	s dataHead = $s($l(dataHead):"[{""TestCodeName"":""项目名称"","_dataHead_"}]",1:"[{""TestCodeName"":""项目名称""}]")
	k ^TMP($zn,$j)
	s retJson = "{""dataHead"":"_dataHead_",""rows"":["_retJson_"]}"
	q retJson
}

// 根据报告id取项目的id串

ClassMethod GetTestCodeDRsByReportDR(ReportDR)
{
	s TestCodeDRs=""
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),2)
	s WorkGroupMachineDR = $lg($g(^dbo.RPVisitNumberReportD(ReportDR)),4)
	s WorkGroupDR = $lg(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR),4)
	i '$l(WorkGroupDR) q ""
	s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:TestSetDR=""  d
	.s VisNumTSDR = $o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR,""))
	.s tWorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisNumTSDR)),5)
	.i tWorkGroupMachineDR'=WorkGroupMachineDR q
	.s TestCodeDR="" f  s TestCodeDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",TestSetDR,WorkGroupDR,TestCodeDR)) q:TestCodeDR=""  d
	..i $l($g(TestCodeDRs)) d
	...s TestCodeDRs = TestCodeDRs_","_TestCodeDR
	..else  d
	...s TestCodeDRs = TestCodeDR
	q TestCodeDRs
}

/// Creator：QQA      
/// CreatDate： 2016-11-10   
/// Description:   
/// Table：        
/// Input：       
/// w ##Class(web.DHCEMPatCheOutNew).getAdmListByAdm("2016-10-10","2016-10-10",530)
ClassMethod getAdmListByAdm(StartDate, EndDate, PaAdm) As %String
{
	q:PaAdm="" "[]"
	s patDr=$p(^PAADM(PaAdm),"^",1)
	q:patDr=""
	d ##Class(web.DHCEMPatCheOutNew).getAdmList(StartDate,EndDate,patDr)
	q ""
}

/// ##class(web.DHCEMPatCheOutNew).getAdmList(1)
/// 获取就诊信息
/// 通过病人ID
/// w ##class(web.DHCEMPatCheOutNew).getAdmList("2016-01-02","2016-02-03",190)
ClassMethod getAdmList(StartDate, EndDate, PatientID, search) As %String
{
	s PatientID=$g(PatientID)
	i '$l(PatientID) q ""
	w "["
	s count=0
	s type="" f  s type=$o(^PAPERdr(PatientID,"ADM",type)) q:type=""  d
	.s ADMId="" f  s ADMId=$o(^PAPERdr(PatientID,"ADM",type,ADMId),-1) q:ADMId=""  d
	..s RetList=""
	..s AdmLoc=$p($g(^CTLOC($p(^PAADM(ADMId),"^",4))),"^",2)
	..s AdmLocCode = $p($g(^CTLOC($p(^PAADM(ADMId),"^",4))),"^",43)
	..s AdmLocDesc = AdmLocCode_AdmLoc
	..q:(search'="")&(AdmLocDesc'[$ZCVT(search,"U"))
	..i AdmLoc["-" s AdmLoc=$p(AdmLoc,"-",2)
	..s AdmDate=$p(^PAADM(ADMId),"^",6) 
	..i StartDate["-" s StartDate=$zdh(StartDate,3)
	..i EndDate["-" s EndDate=$zdh(EndDate,3)
	..q:(StartDate'="")&(AdmDate<StartDate)
	..q:(EndDate'="")&(AdmDate>EndDate)
	..i $l(AdmDate) s AdmDate=$zd(AdmDate,3) ;##class(web.DHCEMCommonUtil).DateLogicalToHtml(AdmDate)
	..s Admtype=$p(^PAADM(ADMId),"^",2)
	..;q:Admtype'="E"
	..i Admtype="O" s Admtype="门诊"
	..i Admtype="I" s Admtype="住院"
	..i Admtype="E" s Admtype="急诊"
	..i Admtype="H" s Admtype="体检"
	..s RetList=ADMId_"^"_Admtype_","_AdmLoc_","_AdmDate
	..s count=count+1
	..i count=1 d
	...w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",RetList)
	..e  d
	...w ","
	...w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",RetList)
	w "]"
	q ""
}

/// w ##class(web.DHCEMPatCheOutNew).GetPatIdByNo("0000000001")
/// 获取病人的ID
/// 通过病人No
ClassMethod GetPatIdByNo(RegNo)
{
	Q:RegNo="" ""
	b ;err
	S PaMasID=""
	S PaMasID=$o(^PAPERi("PAPMI_PatNo",RegNo,PaMasID),-1)
	//^PAPERi("00000567")
	b ;ID
	Q:PaMasID="" ""
	Q PaMasID
}

/// w ##class(web.DHCEMPatCheOutNew).GetPatIdByNo("")
/// 通过病人的就诊号取病人的ID
ClassMethod GetPatIdByEpisodeID(EpisodeID)
{
	Q:EpisodeID=""
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	Q papmiId
}

/// 通过代码获取标本信息	
/// w ##Class(web.DHCEMPatCheOutNew).GetSpecimen("SP52","BJDTYY")
ClassMethod GetSpecimen(SpecCode, HospitalCode) As %String
{
	s SpecCode=$g(SpecCode),HospitalCode=$g(HospitalCode)
	s SpecCode=##Class(LIS.Util.Common).IndexData(SpecCode)
	
	i '$l(SpecCode) q ""
	i '$d(^DHCLISBSVersion(1)) quit SpecCode_$c(2)_$p($G(^TTAB("SPEC",SpecCode)),"\",1)
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",HospitalCode,""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q ""
	s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode,""))
	i '$l(SpecimenDR) q ""
	s SpecimenDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	q SpecimenDR_$c(2)_SpecimenDesc
}

// 取采血时间

// oeoriId：医嘱id或执行记录id

ClassMethod GetspecCollDatetime(oeoriId As %String)
{
	 q:oeoriId="" ""
	 s (ret,specCollUser,specCollDate,specCollTime)=""
	 s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2),oeoreSub=$p(oeoriId,"||",3)
	 i oeoreSub'="" d                            //7.0
	 .s specCollUser=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",10)
	 .s specCollDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",11)
	 .s specCollTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",12)
	 e  d
	 .s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
	 .q:oeoreSub=""
	 .s specCollUser=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",10)
	 .s specCollDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",11)
	 .s specCollTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",12)
	 s:(specCollUser'="")&(specCollDate'="")&(specCollTime'="") ret=specCollUser_"^"_specCollDate_"^"_specCollTime
	 i ret="" d                ////6.9
	 .s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0)) 
	 .q:oeoreSub=""
	 .s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeordId_"||"_oeoriSub_"||"_oeoreSub,0))
     .q:dhcoreId=""
     .&sql(select DHCORE_SpecCollUser,DHCORE_SpecCollDate,DHCORE_SpecCollTime into :specCollUser,:specCollDate,:specCollTime from SQLUSER.DHC_OE_OrdExec  where DHCORE_RowId=:dhcoreId)
	 .s:(specCollUser'="")&(specCollDate'="")&(specCollTime'="") ret=specCollUser_"^"_specCollDate_"^"_specCollTime
	 
	q ret
}

/// CreatDate:    20100408
/// Description:  判断医嘱结果状态是否异常
/// Table:        
/// Input:        检验RowID
/// Output:       
/// Return:       0：无异常结果；1：有异常结果
/// Others:   
ClassMethod checkTSResultStatus(VisitNumberReportDR As %String) As %String
{
  s VisitNumberReportDR=$g(VisitNumberReportDR)
  s TSAbFlag=0
  i '$l(VisitNumberReportDR) q TSAbFlag
  
  s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR,TestCodeDR)) q:TestCodeDR=""  d
  .s VisitNumberReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR,TestCodeDR,""))
  .s Result = $lg(^dbo.RPVisitNumberReportResultD(VisitNumberReportResultDR),5)
  .s AbFlag = $lg(^dbo.RPVisitNumberReportResultD(VisitNumberReportResultDR),9)
  .i TSAbFlag=0,AbFlag="L" s TSAbFlag=1
  .i TSAbFlag=0,AbFlag="H" s TSAbFlag=1
  .i TSAbFlag=0,AbFlag="A" s TSAbFlag=1
  .i TSAbFlag<2,AbFlag="PL" s TSAbFlag=2 ///危机值
  .i TSAbFlag<2,AbFlag="PH" s TSAbFlag=2 
  .i TSAbFlag<2,AbFlag="S" s TSAbFlag=2 
  .i TSAbFlag<3,AbFlag="UL" s TSAbFlag=3  ///荒诞值
  .i TSAbFlag<3,AbFlag="UH" s TSAbFlag=3  ///荒诞值
  q TSAbFlag
}

/// 获取打印标记
ClassMethod GetPrintFlag(ReportDR, UserID) As %String
{
	i '$l(UserID) q "N"
	i '$l(ReportDR) q "N"
	s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
	i '$l(UserCode) q "N"
	
	s UserDR=$o(^dbo.SYSUserI("IndexCode",##Class(LIS.Util.Common).IndexData(UserCode),""))
	i '$l(UserDR) q "N"
	i $d(^dbo.RPVisitNumberReportPrintI("IndexModuleID",ReportDR," DOCTOR",UserDR)) q "Y"
	q "N"
}

/// 获取报告危机值提示
ClassMethod GetPanicMsg(VisitNumberDR) As %String
{
	i '$l(VisitNumberDR) q ""
	s AddDate=$o(^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitNumberDR,""),-1)
	i '$l(AddDate) q ""
	s AddTime=$o(^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitNumberDR,AddDate,""),-1)
	i '$l(AddTime) q ""
	s VisitNumberPanicReportDR=$o(^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitNumberDR,AddDate,AddTime,""))
	i '$l(VisitNumberPanicReportDR) q ""
	s retVal=$lg($g(^dbo.RPVisitNumberPanicReportD(VisitNumberPanicReportDR)),13)
	q retVal
}

/// 0已读 
ClassMethod ReportViewLog(VisitNumberReportDR As %String, UserId As %String, HospID As %String) As %String
{
	s UserId=$g(UserId),VisitNumberReportDR=$g(VisitNumberReportDR),HospID=$g(HospID),OrderID=$g(OrderID)
	s RetValue=100
	i '$l(VisitNumberReportDR) q 100
	i '$l(UserId) q 100
	S userCode=$P($G(^SSU("SSUSR",UserId)),"^",1)
	S userName=$P($G(^SSU("SSUSR",UserId)),"^",2)
	i '$l(userCode) q 100
	i $l(HospID) s HospCode=$p($g(^CT("HOSP",HospID)),"^",1)
	s DoctorDR=##Class(DHCLIS.DHCCommon).GetDoctorDR(userCode, userName, HospCode)
	i '$l(DoctorDR) q 100
	i $d(^dbo.RPVisitNumberReportReadI("IndexReadDoctor",VisitNumberReportDR,DoctorDR)) s RetValue=1 
	q RetValue
}

/// Creator:      liuzf
/// CreatDate:    20110328
/// Description:  获取标本拒收信息和标本取消信息
/// Table:        
/// Input:        医嘱RowID,labno
/// Output:       
/// Return:       标本拒收信息和标本取消信息
/// Others:   
ClassMethod checkTSMemo(OrdRowID As %String, ReportDR As %String, VisitNumberDR As %String) As %String
{
	s ReportDR=$g(ReportDR),OrdRowID=$g(OrdRowID)
	s ret=""
	s OrderId=$p(OrdRowID,"||",1)
	s childsub=$p(OrdRowID,"||",2)
	s ItmStat=$p($g(^OEORD(OrderId,"I",childsub,1)),"^",13)
	i ItmStat=4 q "【停止】"
	i ItmStat=2 q "【作废】"
	i ItmStat=12 q "【撤销】"
	i $l(VisitNumberDR) 
	{
		s RecordDR=$o(^dbo.RPVisitNumberRecordI("IndexMaster",VisitNumberDR,""),-1)
		i $l(RecordDR)
		{
			s OperateTypeDR=$lg($g(^dbo.RPVisitNumberRecordD(RecordDR)),7)
			i $l(OperateTypeDR) s ret="拒收"
		}
	}
	i '$l(ReportDR) q ""
 	s Status=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),22)   //(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)
	s ret=$s(Status="1":"登记",Status="2":"初审",Status="3":"审核",Status="4":"复查",Status="5":"取消审核",Status="6":"作废",1:"")
	i $l(ret) s ret="【"_ret_"】"
	q ret
}

/// Creator:      QQA
/// CreatDate:    2016-11-09
/// Description:  
/// Table:        
/// Input:        
/// Output:       
/// Return:       
/// Others:  
/// w ##class(web.DHCEMPatCheOutNew).getCheckName("1","CT") 
ClassMethod getCheckName(hosp As %String, search As %String) As %String
{
	
	S count=0
	s code=""
	s:$a($e(search),1)<65 code="1"
	s:$a($e(search),1)>122 code="1"
	w "["
	S ARCIMId="0"
	F  S ARCIMId=$O(^ARCIM(ARCIMId)) Q:ARCIMId=""  D
	.S ARCIMSub =""
	.F  S ARCIMSub=$O(^ARCIM(ARCIMId,ARCIMSub)) Q:ARCIMSub=""  D
	..q:$d(^ARCIM(ARCIMId,ARCIMSub,1))=0
	..S ItmCat=$p(^ARCIM(ARCIMId,ARCIMSub,1),"^",10)  //医嘱项表 主表是ARC
	..q:ItmCat=""
	..;q:$p(^ARC("IC",ItmCat),"^",7)'="L"              //L为检验医嘱
	..q:$p(^ARC("IC",ItmCat),"^",8)'="4"               //3 为医嘱大类中检查医嘱
	..S ARCIMDesc=$p($g(^ARCIM(ARCIMId,ARCIMSub,1)),"^",2)
	..S ARCIMRowID=ARCIMId_"||"_ARCIMSub
	..S ALIASId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowID,""),-1)
	..q:ALIASId=""
	..S ARCIMPy = $p(^ARC("ALIAS",ALIASId),"^",6)
	..b ;err1
	..q:(search'="")&($$ALPHAUP^SSUTIL4(ARCIMPy)'[$$ALPHAUP^SSUTIL4(search))&(code="")
	..q:(search'="")&($$ALPHAUP^SSUTIL4(ARCIMDesc)'[$$ALPHAUP^SSUTIL4(search))&(code="1")
	..b ;err2
	..S ARCIMRowId= ARCIMId_"||"_ARCIMSub
	..S count=count+1
	..I count=1 D
	...w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",ARCIMRowId_"^"_ARCIMDesc) 
	..E  D
	...w ","
	...w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",ARCIMRowId_"^"_ARCIMDesc) 
	w "]"
	q ""
}

/// Creator:      QQA
/// CreatDate:    2016-12-07
/// Description:  
/// Table:        
/// Input:        
/// Output:       
/// Return:       
/// Others:  
/// w ##class(web.DHCEMPatCheOutNew).getExamineName("1","bd") 
ClassMethod getExamineName(hosp As %String, search As %String) As %String
{
	
	S count=0
	s code=""
	s:$a($e(search),1)<65 code="1"
	s:$a($e(search),1)>122 code="1"
	w "["
	S ARCIMId="0"
	F  S ARCIMId=$O(^ARCIM(ARCIMId)) Q:ARCIMId=""  D
	.S ARCIMSub =""
	.F  S ARCIMSub=$O(^ARCIM(ARCIMId,ARCIMSub)) Q:ARCIMSub=""  D
	..q:$d(^ARCIM(ARCIMId,ARCIMSub,1))=0
	..S ItmCat=$p(^ARCIM(ARCIMId,ARCIMSub,1),"^",10)  //医嘱项表 主表是ARC
	..q:ItmCat=""
	..;q:$p(^ARC("IC",ItmCat),"^",7)'="X"              //X为检查医嘱
	..q:$p(^ARC("IC",ItmCat),"^",8)'="3"              //改为取医嘱大类
	..S ARCIMDesc=$p($g(^ARCIM(ARCIMId,ARCIMSub,1)),"^",2)
	..S ARCIMRowID=ARCIMId_"||"_ARCIMSub
	..S ALIASId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowID,""),-1)
	..q:ALIASId=""
	..S ARCIMPy = $p(^ARC("ALIAS",ALIASId),"^",6)
	..q:(search'="")&($$ALPHAUP^SSUTIL4(ARCIMPy)'[$$ALPHAUP^SSUTIL4(search))&(code="")
	..q:(search'="")&($$ALPHAUP^SSUTIL4(ARCIMDesc)'[$$ALPHAUP^SSUTIL4(search))&(code="1")
	..S ARCIMRowId= ARCIMId_"||"_ARCIMSub
	..S count=count+1
	..I count=1 D
	...w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",ARCIMRowId_"^"_ARCIMDesc) 
	..E  D
	...w ","
	...w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",ARCIMRowId_"^"_ARCIMDesc) 
	w "]"
	q ""
}

/// Creator:      QQA
/// CreatDate:    2016-11-09
/// Description:  获取检验的项目名称
/// Table:        
/// Input:        
/// Output:       
/// Return:       标本拒收信息和标本取消信息
/// Others:  
/// w ##class(web.DHCEMPatCheOutNew).getItemName() 
ClassMethod getItemName(hosp As %String, search As %String) As %String
{
	
	S count=0
	w "["
	s TestCodeId=""
	f  s TestCodeId=$o(^dbo.BTTestCodeD(TestCodeId))  q:TestCodeId=""  d
	.s TestCodeName =$lg(^dbo.BTTestCodeD(TestCodeId),3)
	.q:(search'="")&(TestCodeName'[search)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",TestCodeId_"^"_TestCodeName) 
	.e  d
	..w ","
	..w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",TestCodeId_"^"_TestCodeName) 
	w "]"
	q ""
}

/// Creator:      QQA
/// CreatDate:    2016-11-09
/// Description:  按照检验的项目过滤检验
/// Table:        
/// Input:        
/// Output:       
/// Return:       
/// Others:  
/// w ##class(web.DHCEMPatCheOutNew).IsHasItem("50","1") 
/// 
ClassMethod IsHasItem(ReportDR As %String, ItemDr As %String) As %String
{
	
	s rs=""
	q:ReportDR="" rs
	s ItemArr = ##Class(web.DHCEMPatCheOutNew).GetTestCodeDRsByReportDR(ReportDR)
	for i=1:1:$l(ItemArr,","){
		s TestItemDr = $p(ItemArr,",",i)
		s:TestItemDr=ItemDr rs=1 
		q:rs=1
	}
	q rs
}

/// Creator:      QQA
/// CreatDate:    2017-02-23
/// Description:  获取检查项目的类型
/// Table:        
/// Input:        
/// Output:       
/// Return:       
/// Others:  
/// w ##class(web.DHCEMPatCheOutNew).ListInspectSort() 
ClassMethod ListInspectSort() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT AC_RowID ,AC_CatDesc FROM DHC_AppArcCat"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("AC_RowID")
		s Desc = result.Data("AC_CatDesc")
		Continue:Desc=""
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	}
	w "]"
	q ""
}

/// Creator:      QQA
/// CreatDate:    2017-02-23
/// Description:  获取检查项目分类
/// Table:        ^DHCAPARCCA 
/// Input:        医嘱项ID     
/// Return:       项目分类
/// Others:  
/// w ##class(web.DHCEMPatCheOutNew).GetSortByArci("2||1") 
ClassMethod GetSortByArci(arcimid As %String) As %String
{
	q:arcimid=""
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	q:+itmmastid=0
	q:+itmmastver=0
	s itemCatID=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)   ///医嘱子类
	q:+itemCatID=0
	s itmArcCatID="",itmArcCatStr=""
	f  s itmArcCatID=$o(^DHCAPARCCA(0,"O",itemCatID,itmArcCatID)) q:itmArcCatID=""  d
	.Q:+itmArcCatID=0
	.s itmArcCatCode=$p($g(^DHCAPARCCA(itmArcCatID)),"^",1)  	/// 检查分类代码
	.s itmArcCatDesc=$p($g(^DHCAPARCCA(itmArcCatID)),"^",2)  	/// 检查分类描述
	.i itmArcCatStr'="" d
	..s itmArcCatStr=itmArcCatStr_"!"_itmArcCatID_"^"_itmArcCatCode_"^"_itmArcCatDesc
	.i itmArcCatStr="" d
	..s itmArcCatStr=itmArcCatID_"^"_itmArcCatCode_"^"_itmArcCatDesc
	Q itmArcCatStr
}

Storage Default
{
<Data name="DHCEMPatCheOutNewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMPatCheOutNewD</DataLocation>
<DefaultData>DHCEMPatCheOutNewDefaultData</DefaultData>
<IdLocation>^web.DHCEMPatCheOutNewD</IdLocation>
<IndexLocation>^web.DHCEMPatCheOutNewI</IndexLocation>
<StreamLocation>^web.DHCEMPatCheOutNewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
