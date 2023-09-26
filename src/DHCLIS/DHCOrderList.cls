Class DHCLIS.DHCOrderList Extends %RegisteredObject
{

Query QueryOrderList(EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "VisitNumberReportDR,OEOrdItemID,OrdItemName,ReqDateTime,ResultStatus,LabEpisode,LabTestSetRow,OrdSpecimen,SpecDateTime,RecDateTime,AuthDateTime,PreReport,WarnComm,TSResultAnomaly,TSMemo,AdmNo,AdmDate,AdmLoc,AdmType,ReadFlag,PrintFlag,StatusDesc,ReceiveNotes,MajorConclusion,HasMC,HasMid,HasBic,RepFlag,ManualState")
{
}

/// Creator：      liuzf
/// CreatDate：    
/// Description:： 根据就诊号或卡号(登记号)得到检验医嘱列表
/// Table：        
/// Input：        就诊号,病员号
/// Return：       函数返回值的说明
/// Others：  d ##Class(%ResultSet).RunQuery("DHCLIS.DHCOrderList","QueryOrderList","38","42","2019-03-27","2019-04-26","","0","","","4634","0","","","","Y","")     
ClassMethod QueryOrderListExecute(ByRef qHandle As %Binary, EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag, Sessions, Output RowCount As %String) As %Status
{
	//s ^TMP("QueryOrderList","0426")=$lb(EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag, Sessions)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^SZW("dd") = $lb(EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag, Sessions)
	s EpisodeID=$g(EpisodeID),PatientID=$g(PatientID)
	i $l(FromDate) s FromDate=$zdh(FromDate,3)
	i $l(ToDate) S ToDate=$zdh(ToDate,3)
	s UserId=$g(UserId)
	//科室
	s LocCode=$g(LocCode)
	i $l(LocCode) s LocId=$o(^CTLOC(0,"Code",LocCode,""),-1)
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
		
	k ^TMPLIS($zn,$i,$j)
	k ^TMPLIS($zn,repid,$j)
	i $l(EpisodeID) d GetOrderByEpisode(EpisodeID)

	i '$l(EpisodeID),$l(PatientID) d
	.s type="" f  s type=$o(^PAPERdr(PatientID,"ADM",type)) q:type=""  d
	..s ADMId="" f  s ADMId=$o(^PAPERdr(PatientID,"ADM",type,ADMId),-1) q:ADMId=""  d
	...s AdmLoc=$p(^PAADM(ADMId),"^",4)
	...s AdmDate=$p(^PAADM(ADMId),"^",6)
	...///日期范围
	...i AdmDateFlag="1",(+$H-AdmDate)>90 Q
	...i AdmDateFlag="2",(+$H-AdmDate)>182 Q
	...i AdmDateFlag="3",(+$H-AdmDate)>365 Q
	...i $l(LocCode),LocCode'=AdmLoc q
	...d GetOrderByEpisode(ADMId)
	
	s num=0
	s labno="" f  s labno=$o(^TMPLIS($zn,$i,$j,"LabNo",labno),-1) q:labno=""  d
	.s ItmStat="" f  s ItmStat=$o(^TMPLIS($zn,$i,$j,"LabNo",labno,ItmStat)) q:ItmStat=""  d
	..s WorkGroupMachineDR="" f  s WorkGroupMachineDR=$o(^TMPLIS($zn,$i,$j,"LabNo",labno,ItmStat,WorkGroupMachineDR)) q:WorkGroupMachineDR=""  d
	...//s (OutPutReportDR,OrdRowIds,OrdNames,ReqDateTime,ResultStatus,StatusDesc,LabEpisode,LabTestSetRow,SpecName,SpecDateTime,RecDateTime,AuthDateTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,EpisodeNo,AdmDate,AdmLoc,AdmType,ReadFlag,ReceiveNotes,MajorConclusion,PlacerNo)=""
	...s fVisitNumberReportDR="" f  s fVisitNumberReportDR=$o(^TMPLIS($zn,$i,$j,"LabNo",labno,ItmStat,WorkGroupMachineDR,fVisitNumberReportDR)) q:fVisitNumberReportDR=""  d
	....s VisitNumberReportDR=""
	....//同工作小组同标本报告是否拼接DR
	....s IsOutPutReportDRCombine=0
	....//是否有鉴定记录
	....s HasMC=0
	....s (OutPutReportDR,OrdRowIds,OrdNames,ReqDateTime,ResultStatus,StatusDesc,LabEpisode,LabTestSetRow,SpecName,SpecDateTime,RecDateTime,AuthDateTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,EpisodeNo,AdmDate,AdmLoc,AdmType,ReadFlag,ReceiveNotes,MajorConclusion,PlacerNo)=""
	....i fVisitNumberReportDR'="NULL" s VisitNumberReportDR = fVisitNumberReportDR
	....s OrdRowId="" f  s OrdRowId=$o(^TMPLIS($zn,$i,$j,"LabNo",labno,ItmStat,WorkGroupMachineDR,fVisitNumberReportDR,OrdRowId)) q:OrdRowId=""  d
	.....s OrdId=$p(OrdRowId,"||",1),SubId=$p(OrdRowId,"||",2)
	.....s stat=$p(^OEORD(OrdId,"I",SubId,1),"^",13)
	.....q:stat=4	//停止
	.....q:stat=2	//作废
	.....q:stat=12	//撤销
	.....s LabEpisode=labno
	.....//取状态描述
	.....s stdesc="" f  s stdesc=$o(^OEC("OSTAT",0,"Desc",stdesc)) q:stdesc=""  d
	......s curst="" f  s curst=$o(^OEC("OSTAT",0,"Desc",stdesc,curst)) q:curst=""  d
	.......i curst=stat s StatusDesc=stdesc
	.....//病人所属医院
	.....s Adm=$p(^OEORD(OrdId),"^",1),locCode="",HospID="",HospitalCode="",AdmLoc=""
	.....i $l(Adm),$d(^PAADM(Adm)) s locCode=$p(^PAADM(Adm),"^",4)
	.....i $l(locCode) s HospID=$p(^CTLOC(locCode),"^",22),AdmLoc=$p(^CTLOC(locCode),"^",2)
	.....i AdmLoc["-" s AdmLoc=$p(AdmLoc,"-",2)
	.....i $l(HospID) s HospitalCode=$p(^CT("HOSP",HospID),"^",1)
	.....//就诊日期
	.....s AdmDate=$p(^PAADM(Adm),"^",6)
	.....i $l(AdmDate) s AdmDate=$zd(AdmDate,3)
	.....s AdmType=$p(^PAADM(Adm),"^",2)
	.....i AdmType="O" s AdmType="门诊"
	.....i AdmType="I" s AdmType="住院"
	.....i AdmType="E" s AdmType="急诊"
	.....i AdmType="H" s AdmType="体检"
	.....s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
	.....s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
	.....s ItmMastDr=$p(OrdStr1,"^",2)
	.....s OrdName=$p($g(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)),"^",2)
	.....i $l(OrdRowIds) s OrdRowIds=OrdRowIds_","_OrdRowId
	.....e  s OrdRowIds=OrdRowId
	.....i $l(OrdNames) s OrdNames=OrdNames_"+"_OrdName
	.....e  s OrdNames=OrdName
	.....//申请日期时间
	.....s ReqDate=$p(OrdStr3,"^",7)
	.....s ReqTime=$p(OrdStr1,"^",17)
	.....s OGTTGroupReqDate=ReqDate
	.....i $l(ReqDate) s ReqDate=$zd(ReqDate,3)
	.....i $l(ReqTime) s ReqTime=$zt(ReqTime)
	.....s ReqDateTime=ReqDate_" "_ReqTime
	.....//s LabTestSetRow=$p(OrdStr3,"^",35)
	.....//s LabTestSetRow=$tr(LabTestSetRow,$c(0))
	.....s VisitNumberTestSetDR=""
	.....s ReportDR=+$o(^dbo.RPVisitNumberTestSetI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OrdRowId),""))
	.....i $l(ReportDR) s VisitNumberTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OrdRowId),ReportDR,""))
	.....s LabTestSetRow=VisitNumberTestSetDR	
	.....//标本类型
	.....s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
	.....s (SpecCode,SpecName)=""
	.....i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
	.....i $l(SpecCode) s SpecName=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(SpecCode,HospitalCode),$c(2),2)
	.....//采集日期时间Collection
	.....s (SpecDate,SpecTime)=""
	.....s retval=##Class(web.DHCNurSpecerNo).GetspecCollDatetime(OrdRowId)
	.....i $l(retval) d
	......s SpecDate=$p(retval,"^",2)
	......i $l(SpecDate) s SpecDate=$zd(SpecDate,3)
	......s SpecTime=$p(retval,"^",3)
	......i $l(SpecTime) s SpecTime=$zt(SpecTime)
	.....s SpecDateTime=SpecDate_" "_SpecTime
	.....//接收日期
	.....s VisitNumberDR=$g(^TMPLIS($zn,$i,$j,"LabNo",labno,ItmStat,WorkGroupMachineDR,fVisitNumberReportDR,OrdRowId))
	.....s TSMemo="",PrintFlag=""
	.....i $l(VisitNumberDR) d
	......s RecDate=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),66)
	......s RecTime=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),67)
	......i $l(RecTime) s RecTime=$zt(RecTime)
	......i $l(RecDate) s RecDateTime=$e(RecDate,1,4)_"-"_$e(RecDate,5,6)_"-"_$e(RecDate,7,8)_" "_RecTime
	......d OutPutOGGroupReport
	......///审核日期
	......i $l(fVisitNumberReportDR),(fVisitNumberReportDR'="NULL") d
	.......s checkReportDR=fVisitNumberReportDR
	.......i $l(OutPutReportDR),(IsOutPutReportDRCombine=0) s OutPutReportDR =OutPutReportDR_","_checkReportDR
	.......e  i IsOutPutReportDRCombine=0 s OutPutReportDR=checkReportDR
	.......s SplitStatus=$lg($g(^dbo.RPVisitNumberReportD(checkReportDR)),44)
	.......i SplitStatus="2" q
	.......s AuthDate=$lg($g(^dbo.RPVisitNumberReportD(fVisitNumberReportDR)),19)
	.......s AuthTime=$lg($g(^dbo.RPVisitNumberReportD(fVisitNumberReportDR)),20)
	.......i $l(AuthTime) s AuthTime=$zt(AuthTime)
	.......i $l(AuthDate) s AuthDateTime=$e(AuthDate,1,4)_"-"_$e(AuthDate,5,6)_"-"_$e(AuthDate,7,8)_" "_AuthTime
	.......//s TSMemo=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),40)  //MajorConclusion
	.......s MajorConclusion=""
	.......i $lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),22)=3 s MajorConclusion=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),40)   //(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)
	.......//i (ResultStatus=""),($lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),22)=3) s ResultStatus=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),22)   //(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)  报告状态
	....... s ResultStatus=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),22)
	.......s ReceiveNotes = $lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),70)
	.......s StatusDesc=$s(ResultStatus="1":"登记",ResultStatus="2":"初审",ResultStatus="3":"审核",ResultStatus="4":"复查",ResultStatus="5":"取消",ResultStatus="6":"作废",ResultStatus="10":"培养中",ResultStatus="11":"鉴定中",ResultStatus="12":"药敏中",1:"其他")
	.......//结果异常标志
	.......i (TSResultAnomaly="")||(TSResultAnomaly=0) s TSResultAnomaly=##class(DHCLIS.DHCCommon).checkTSResultStatus(VisitNumberReportDR)
	.......///打印标记
	.......i (PrintFlag="")||(PrintFlag="Y") s PrintFlag=##Class(DHCLIS.DHCOrderList).GetPrintFlag(VisitNumberReportDR,UserId)
	.......//是否有鉴定记录
	.......s HasMC=0
	.......i $d(^dbo.MCProcessRecordI("IndexMethodDR",VisitNumberReportDR)) d
	........s MethodDR="" f  s MethodDR=$o(^dbo.MCProcessRecordI("IndexMethodDR",VisitNumberReportDR,MethodDR)) q:MethodDR=""  d
	.........s DocView=$lg($g(^dbo.BTMCMethodD(MethodDR)),11)
	.........i DocView="1" s HasMC=1 q
	.......//阅读标记
	.......i $l(UserId),(ResultStatus=3) s ReadFlag=##Class(DHCLIS.DHCReportControl).ReportViewLog(VisitNumberReportDR,UserId,HospID)
	......//置拼接报告id成功标识
	......s IsOutPutReportDRCombine=1
	......///危机值提示
	......s TransComm=##Class(DHCLIS.DHCCommon).GetPanicMsg(VisitNumberDR)
	.....///获取医嘱状态信息
	.....s TSMemo=##Class(DHCLIS.DHCOrderList).checkTSMemo(OrdRowId,VisitNumberReportDR,VisitNumberDR)
	....q:stat=4	//停止
	....q:stat=2	//作废
	....q:stat=12	//撤销
	....i (fReadFlag=1),(ResultStatus'=3) q               ///未阅读
	....i (fReadFlag=1),(ResultStatus=3),(ReadFlag=1) q  ///未阅读
	....i (AuthFlag=1),(ResultStatus'=3) q   //是否出报告
	....i fPrintFlag="N",PrintFlag="Y" q
	....s IsInnerAuth="0"
	....i $l(VisitNumberReportDR),$d(^TMPLIS($zn,$i,$j,"OGTTGroupVisitNumber",VisitNumberReportDR)) q
	....i $l(VisitNumberReportDR),$d(^DHCLISReportPrint(VisitNumberReportDR)),$g(^DHCLISReportPrint(VisitNumberReportDR))="内审" s IsInnerAuth="1"
	....S ckSplitSatus=""
	....i $l(VisitNumberReportDR) s ckSplitSatus=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),44)
	....i ckSplitSatus="1" d
	.....s ckTCDR=$o(^dbo.RPReportSplitRecordI("IndexMaster",VisitNumberReportDR,""))
	.....s SplitReportDR=$o(^dbo.RPReportSplitRecordI("IndexMaster",VisitNumberReportDR,ckTCDR,""))
	.....I $lg($g(^dbo.RPVisitNumberReportD(SplitReportDR)),22)=3  s OutPutReportDR=OutPutReportDR_","_SplitReportDR //审核直接拼入报告主键可合并打印
	....//是否有中间报告
	....s HasMid="0"
 	....i $l(VisitNumberReportDR),$d(^dbo.RPVisitNumberRepMidI("IndexMidReport",VisitNumberReportDR)) d
 	.....s midOrderNo="" f  s midOrderNo=$o(^dbo.RPVisitNumberRepMidI("IndexMidReport",VisitNumberReportDR,midOrderNo)) q:midOrderNo=""  d
 	......s midRowID="" f  s midRowID=$o(^dbo.RPVisitNumberRepMidI("IndexMidReport",VisitNumberReportDR,midOrderNo,midRowID)) q:midRowID=""  d
 	.......s midStatus=$lg($g(^dbo.RPVisitNumberRepMidD(midRowID)),10)
 	.......i (midStatus="2")!(midStatus="3") s HasMid="1" q //检验预报告审核状态暂定为3
 	....s HasBic=0
 	....i $l(VisitNumberReportDR),$d(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR)) d
 	.....s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR,TestCodeDR)) q:TestCodeDR=""  d
 	......s ResultFormat=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),9)
 	......i ResultFormat="M" d
 	.......s RepResDR="" f  s RepResDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR,TestCodeDR,RepResDR)) q:RepResDR=""  d
 	........s Result=$lg($g(^dbo.RPVisitNumberReportResultD(RepResDR)),5)
 	........s ResultDR=$lg($g(^dbo.RPVisitNumberReportResultD(RepResDR)),4)
 	........s Positive=""
 	........i $l(ResultDR),$d(^dbo.BTOrganismD(ResultDR)) s Positive=$lg($g(^dbo.BTOrganismD(ResultDR)),16)
 	........i Positive="N" s Result=""
 	........i $l(Result) s HasBic=1
 	....s OrderFiled=ReqDate_ReqTime
 	....i '$l(OrderFiled) s ReqDate=999999999
 	....s RepFlag=..GetReportFlag(VisitNumberReportDR)
 	....//手工计费标识
 	....s ManualState=..GetManualState(VisitNumberDR)
 	....s ^TMPLIS($zn,repid,$j,"OutData",OrderFiled,OrdRowIds)=$lb(OutPutReportDR,OrdRowIds,OrdNames,ReqDateTime,ResultStatus,LabEpisode,LabTestSetRow,SpecName,SpecDateTime,RecDateTime,AuthDateTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,Adm,AdmDate,AdmLoc,AdmType,ReadFlag,PrintFlag,StatusDesc,ReceiveNotes,MajorConclusion,HasMC,HasMid,HasBic,RepFlag,ManualState)
	s OrderFiled="" f  s OrderFiled=$o(^TMPLIS($zn,repid,$j,"OutData",OrderFiled),-1) q:OrderFiled=""  d
	.s OrdRowIds="" f  s OrdRowIds=$o(^TMPLIS($zn,repid,$j,"OutData",OrderFiled,OrdRowIds)) q:OrdRowIds=""  d
	..s Data=^TMPLIS($zn,repid,$j,"OutData",OrderFiled,OrdRowIds)
	..d OutputRow
	
	Set qHandle=$lb(0,repid,0)
	k ^TMPLIS($zn,repid,$j)
	k ^TMPLIS($zn,$i,$j)
	Quit $$$OK
	
OutputRow
#;	///危机值提示
#;	s TransComm=##Class(DHCLIS.DHCCommon).GetPanicMsg(VisitNumberDR)
#;	///获取医嘱状态信息
#;	i '$l(TSMemo) s TSMemo=##Class(DHCLIS.DHCOrderList).checkTSMemo(OrdRowId,VisitNumberReportDR,VisitNumberDR)
#;	i (fReadFlag=1),(ResultStatus'=3) q               ///未阅读
#;	i (fReadFlag=1),(ResultStatus=3),(ReadFlag=1) q  ///未阅读
#;	i (AuthFlag=1),(ResultStatus'=3) q   //是否出报告
#;	i fPrintFlag="N",PrintFlag="Y" q
#;	s LabEpisode=labno
#;	//是否内部审核
#;	s IsInnerAuth="0"
#;	i $d(^DHCLISReportPrint(VisitNumberReportDR)),^DHCLISReportPrint(VisitNumberReportDR)="内审" s IsInnerAuth="1"
#;	s Data=$lb(IsInnerAuth,Order,VisitNumberReportDR,OrdRowIds,OrdNames,ReqDateTime,ResultStatus,LabEpisode,LabTestSetRow,SpecName,SpecDateTime,RecDateTime,AuthDateTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,Adm,AdmDate,AdmLoc,AdmType,ReadFlag,PrintFlag)
	
	s iLen=$LISTLENGTH(Data)
	f i=1:1:iLen d
	.i '$ld(Data,i) s $LI(Data,i)=""
	.s $LI(Data,i)=$tr($LI(Data,i),$c(0))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit	
	
GetOrderByEpisode(EpisodeNo)
	s OrdId=""  f  s OrdId=$o(^OEORD(0,"Adm",EpisodeNo,OrdId)) q:OrdId=""  d
	.s SubId=""	f  s SubId=$o(^OEORD(OrdId,"I",SubId),-1) q:SubId=""  d
	..s OrdRowId=OrdId_"||"_SubId
	..s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
	..s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
	..s ItmMastDr=$p(OrdStr1,"^",2)
	..i '$l(ItmMastDr) q
	..i '##Class(web.DHCLabOrder).isLabTS(ItmMastDr) q
	..s OrdName=$p($g(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)),"^",2)
	..//比较申请日期
	..s ReqDate=$p(OrdStr3,"^",7)
	..i $l(ReqDate),$l(FromDate),ReqDate-FromDate<0 q
	..i $l(ReqDate),$l(ToDate),ReqDate-ToDate>0 q
	..//检验号
	..s PlacerNo=$p(OrdStr3,"^",36)
	..s LabEpisode=$p(OrdStr3,"^",20) //优先取预制条码
	..i '$l(LabEpisode) q
	..//报告ID
	..//s LabTestSetRow=$p(OrdStr3,"^",35)
	..//s LabTestSetRow=$tr(LabTestSetRow,$c(0))
	..s VisitNumberTestSetDR=""
	..s ReportDR=+$o(^dbo.RPVisitNumberTestSetI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OrdRowId),""))
	..i $l(ReportDR) s VisitNumberTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OrdRowId),ReportDR,""))
	..s LabTestSetRow=VisitNumberTestSetDR
	..s ItmStat=$p(OrdStr1,"^",13)
	..i '$l(ItmStat) q
	..s WorkGroupMachineDR="NULL"
	..i ('$d(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(LabEpisode)))),($d(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(PlacerNo)))) s LabEpisode=PlacerNo
	..s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(LabEpisode),""))
	..i $l(LabTestSetRow) s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),5)
	..i '$l(WorkGroupMachineDR) s WorkGroupMachineDR="NULL"
	..//此处开始查询该组合套是否属于合报告处理
	..s TestSetDR="",IsGroupReport=0
	..s VisitnumberReportDR = ""
	..i ReportDR>0 s VisitnumberReportDR=ReportDR
	..i $l(LabTestSetRow) s TestSetDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),3)
	..i $l(TestSetDR),$d(^dbo.BTTestSetOGTTGroupLinksI("IndexSubTestSetOGTTGroup",TestSetDR)) d
	...s TestSetOGTTGroupDR=$o(^dbo.BTTestSetOGTTGroupLinksI("IndexSubTestSetOGTTGroup",TestSetDR,""))
    ...S ^TMPLIS($zn,$i,$j,"TestSetOGTTGroup",ReqDate,TestSetOGTTGroupDR,VisitNumberDR,WorkGroupMachineDR,TestSetDR)=$lb(LabEpisode,OrdRowId)
	..i '$l(WorkGroupMachineDR) s WorkGroupMachineDR="NULL"
	..i '$l(VisitnumberReportDR) s VisitnumberReportDR="NULL"
	..s ^TMPLIS($zn,$i,$j,"LabNo",LabEpisode,ItmStat,WorkGroupMachineDR,VisitnumberReportDR,OrdRowId)=VisitNumberDR
	q
	
OutPutOGGroupReport
	s TestSetDR="",VisitNumberReportDRStr="",thisLabNoStr="",thisOrderNames="",thisIsReport=1,thisOrderRowIDStr="",thisTSResultAnomaly=0,OGTTGroupReadFlag="1",OGTTGroupPrintFlag="N"
	i $l(LabTestSetRow) s TestSetDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),3)
	i $l(TestSetDR),$d(^dbo.BTTestSetOGTTGroupLinksI("IndexSubTestSetOGTTGroup",TestSetDR)) d
	.s TestSetOGTTGroupDR=$o(^dbo.BTTestSetOGTTGroupLinksI("IndexSubTestSetOGTTGroup",TestSetDR,""))
	.i $d(^TMPLIS($zn,$i,$j,"TestSetOGTTGroup",OGTTGroupReqDate,TestSetOGTTGroupDR)) d
	..S TestSetOGTTGroupVisitNumberDR="" f  s TestSetOGTTGroupVisitNumberDR=$o(^TMPLIS($zn,$i,$j,"TestSetOGTTGroup",OGTTGroupReqDate,TestSetOGTTGroupDR,TestSetOGTTGroupVisitNumberDR)) q:TestSetOGTTGroupVisitNumberDR=""  d
	...s TestSetOGTTGroupWorkGroupMachineDR="" f  s TestSetOGTTGroupWorkGroupMachineDR=$o(^TMPLIS($zn,$i,$j,"TestSetOGTTGroup",OGTTGroupReqDate,TestSetOGTTGroupDR,TestSetOGTTGroupVisitNumberDR,TestSetOGTTGroupWorkGroupMachineDR)) q:TestSetOGTTGroupWorkGroupMachineDR=""  d
	....s thisIsReport=0,VisitNumberReportDRStr=""
	....s tOrder="" f  s tOrder=$o(^dbo.RPVisitNumberReportI("IndexReportID",TestSetOGTTGroupVisitNumberDR,TestSetOGTTGroupWorkGroupMachineDR,tOrder)) q:tOrder=""  d
	.....s OGTTGroupVisitNumberReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",TestSetOGTTGroupVisitNumberDR,TestSetOGTTGroupWorkGroupMachineDR,tOrder,""))
	.....s ResultStatus=$lg($g(^dbo.RPVisitNumberReportD(OGTTGroupVisitNumberReportDR)),22) 
	.....S CKTSDR="",CKFlag=0
	.....F  s CKTSDR=$O(^dbo.RPVisitNumberTestSetI("IndexReportID",CKTSDR)) q:CKTSDR=""  d
	......i $d(^dbo.BTTestSetOGTTGroupLinksI("IndexSubTestSetOGTTGroup",CKTSDR)) s CKFlag=1
	.....i CKFlag=0 q //去除不在合报告规则内的报告主键
	.....i ResultStatus'=3 s thisIsReport=0 q
	.....e  s thisIsReport=1
	.....//s LabNoStr = $s($l(LabNoStr):LabNoStr_"+"_$lg($g(^TMPLIS($zn,$i,$j,"TestSetOGTTGroup",OGTTGroupReqDate,TestSetOGTTGroupDR,TestSetOGTTGroupVisitNumberDR,TestSetOGTTGroupWorkGroupMachineDR,TestSetDR)),1),1:$lg($g(^TMPLIS($zn,$i,$j,"TestSetOGTTGroup",OGTTGroupReqDate,TestSetOGTTGroupDR,TestSetOGTTGroupVisitNumberDR,TestSetOGTTGroupWorkGroupMachineDR,TestSetDR)),1))
	.....i $d(^TMPLIS($zn,$i,$j,"OGTTGroupVisitNumber",OGTTGroupVisitNumberReportDR)) q
	.....s TSResultAnomaly=##class(DHCLIS.DHCCommon).checkTSResultStatus(OGTTGroupVisitNumberReportDR)
	.....i TSResultAnomaly>thisTSResultAnomaly s thisTSResultAnomaly=TSResultAnomaly
	.....s VisitNumberReportDRStr=$s($l(VisitNumberReportDRStr):VisitNumberReportDRStr_","_OGTTGroupVisitNumberReportDR,1:OGTTGroupVisitNumberReportDR)
	.....//记录已经合并到报告的标本
	.....s ^TMPLIS($zn,$i,$j,"OGTTGroupVisitNumber",OGTTGroupVisitNumberReportDR)=""
	....i thisIsReport=0 q
	....s TmpAuthDate=$lg($g(^dbo.RPVisitNumberReportD(OGTTGroupVisitNumberReportDR)),19)
	....s TmpAuthTime=$lg($g(^dbo.RPVisitNumberReportD(OGTTGroupVisitNumberReportDR)),20)
	....b 
	....i $l(TmpAuthTime) s TmpAuthTime=$zt(TmpAuthTime)
	....i $l(TmpAuthDate) s AuthDateTime=$e(TmpAuthDate,1,4)_"-"_$e(TmpAuthDate,5,6)_"-"_$e(TmpAuthDate,7,8)_" "_TmpAuthTime
	....b ;2
	....s TestSetOGTTGroupTestSetDR="" f  s TestSetOGTTGroupTestSetDR=$o(^TMPLIS($zn,$i,$j,"TestSetOGTTGroup",OGTTGroupReqDate,TestSetOGTTGroupDR,TestSetOGTTGroupVisitNumberDR,TestSetOGTTGroupWorkGroupMachineDR,TestSetOGTTGroupTestSetDR)) q:TestSetOGTTGroupTestSetDR=""  d
	.....s thisItmMastDr = $lg(^TMPLIS($zn,$i,$j,"TestSetOGTTGroup",OGTTGroupReqDate,TestSetOGTTGroupDR,TestSetOGTTGroupVisitNumberDR,TestSetOGTTGroupWorkGroupMachineDR,TestSetOGTTGroupTestSetDR),2)
	.....s thisOrderRowIDStr = $s($l(thisOrderRowIDStr):thisOrderRowIDStr_","_thisItmMastDr,1:thisItmMastDr)
	.....s thisLabNo = $lg(^TMPLIS($zn,$i,$j,"TestSetOGTTGroup",OGTTGroupReqDate,TestSetOGTTGroupDR,TestSetOGTTGroupVisitNumberDR,TestSetOGTTGroupWorkGroupMachineDR,TestSetOGTTGroupTestSetDR),1)
	.....s thisLabNoStr = $s($l(thisLabNoStr):thisLabNoStr_","_thisLabNo,1:thisLabNo) 
	.....s arcimID = $p($g(^OEORD($p(thisItmMastDr,"||",1),"I",$p(thisItmMastDr,"||",2),1)),"^",2)
	.....s thisOrderName= $p($g(^ARCIM(+arcimID,$p(arcimID,"||",2),1)),"^",2)
	.....s thisOrderNames = $s($l(thisOrderNames):thisOrderNames_"+"_thisOrderName,1:thisOrderName)
	.....///打印标记
	.....s PrintFlag=##Class(DHCLIS.DHCOrderList).GetPrintFlag(OGTTGroupVisitNumberReportDR,UserId)
	.....i PrintFlag="Y" s OGTTGroupPrintFlag="Y"
	.....//阅读标记
	.....i $l(UserId) s ReadFlag=##Class(DHCLIS.DHCReportControl).ReportViewLog(OGTTGroupVisitNumberReportDR,UserId,HospID)
	.....i ReadFlag'=1 s OGTTGroupReadFlag=0
	.//////处理医嘱的testset的问题
	.i '$l(VisitNumberReportDRStr) q
	.///只有一条记录的时候不需要显示合报告的情况
	.i $l(VisitNumberReportDRStr,",")<2 k ^TMPLIS($zn,$i,$j,"OGTTGroupVisitNumber",VisitNumberReportDRStr) q
	.s StatusDesc="审核"
	.i (fReadFlag=1),(ResultStatus'=3) q               ///未阅读
	.i (fReadFlag=1),(ResultStatus=3),(OGTTGroupReadFlag=1) q  ///未阅读
	.i (AuthFlag=1),(ResultStatus'=3) q   //是否出报告
	.i fPrintFlag="N",PrintFlag="Y" q
	.b //r
	.s Data=$lb(VisitNumberReportDRStr,thisOrderRowIDStr,thisOrderNames,ReqDateTime,3,thisLabNoStr,LabTestSetRow,SpecName,SpecDateTime,RecDateTime,AuthDateTime,ReportFlag,TransComm,thisTSResultAnomaly,TSMemo,Adm,AdmDate,AdmLoc,AdmType,OGTTGroupReadFlag,OGTTGroupPrintFlag,StatusDesc,ReceiveNotes,MajorConclusion)
	.d OutputRow
	q
}

ClassMethod QueryOrderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QueryOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取打印标记
ClassMethod GetPrintFlag(ReportDR, UserID) As %String
{
	i '$l(UserID) q "N"
	i '$l(ReportDR) q "N"
	s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
	s UserCode = $zcvt(UserCode,"U")
	i '$l(UserCode) q "N"
	s UserDR=$o(^dbo.SYSUserI("IndexCode",##Class(LIS.Util.Common).IndexData(UserCode),""))
	i '$l(UserDR),$d(^dbo.RPVisitNumberReportPrintI("IndexModuleID",ReportDR,##Class(LIS.Util.Common).IndexData("DOCTOR"))) q "Y" 
	i '$l(UserDR) q "N"
	i $d(^dbo.RPVisitNumberReportPrintI("IndexModuleID",ReportDR,##Class(LIS.Util.Common).IndexData("DOCTOR"),UserDR)) q "Y"
	q "N"
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
		s OperateDate=$o(^dbo.RPVisitNumberRecordI("IndexMaster",VisitNumberDR,""),-1),OperateTime=""
		i $l(OperateDate) s OperateTime = $o(^dbo.RPVisitNumberRecordI("IndexMaster",VisitNumberDR,OperateDate,""),-1)
		i $l(OperateDate),$l(OperateTime)
		{
			s RecordDR = $o(^dbo.RPVisitNumberRecordI("IndexMaster",VisitNumberDR,OperateDate,OperateTime,""),-1)
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

/// ##class(DHCLIS.DHCOrderList).getAdmList(1)
/// 获取就诊信息
ClassMethod getAdmList(PatientID, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14) As %String
{
	s PatientID=$g(PatientID)
	i '$l(PatientID) q ""
	s RetList=""
	s type="" f  s type=$o(^PAPERdr(PatientID,"ADM",type)) q:type=""  d
	.s ADMId="" f  s ADMId=$o(^PAPERdr(PatientID,"ADM",type,ADMId),-1) q:ADMId=""  d
	..s AdmLoc=$p($g(^CTLOC($p(^PAADM(ADMId),"^",4))),"^",2)
	..i AdmLoc["-" s AdmLoc=$p(AdmLoc,"-",2)
	..s AdmDate=$p(^PAADM(ADMId),"^",6)
	..i $l(AdmDate) s AdmDate=$zd(AdmDate,3)
	..s Admtype=$p(^PAADM(ADMId),"^",2)
	..i Admtype="O" s Admtype="门诊"
	..i Admtype="I" s Admtype="住院"
	..i Admtype="E" s Admtype="急诊"
	..i Admtype="H" s Admtype="体检"
	..s RetList=RetList_"^"_ADMId_","_Admtype_","_AdmLoc_","_AdmDate
	q RetList
}

/// 获取报告打印数据库连接
/// w ##Class(DHCLIS.DHCOrderList).GetConnectString()
ClassMethod GetConnectString(ID) As %String
{
	s ID=$g(ID)
	s ConnectString=""
	i $l(ID)>1 d
	.s ParamCode=" "_$zcvt("IPWebserviceMapHIS","U")
    .i $d(^dbo.SYSParameterI("IndexCode",ParamCode))  d 
    ..s ParamType="" f  s ParamType=$o(^dbo.SYSParameterI("IndexCode",ParamCode,ParamType)) q:ParamType=""  d
    ...s ParamTypeID="" f  s ParamTypeID=$o(^dbo.SYSParameterI("IndexCode",ParamCode,ParamType,ParamTypeID)) q:ParamTypeID=""  d
    ....s SYSParameterDR="" f  s SYSParameterDR=$o(^dbo.SYSParameterI("IndexCode",ParamCode,ParamType,ParamTypeID,SYSParameterDR)) q:SYSParameterDR=""  d
    .....s IP=$Lg($g(^dbo.SYSParameterD(SYSParameterDR)),5)
    .....s Webservice=$Lg($g(^dbo.SYSParameterD(SYSParameterDR)),6)
    .....i IP=ID s ConnectString=Webservice
    s ConnectStringEntry=""
	//写了检验的IP，直接返回
	s ParamCode=" "_$zcvt("IPWebserviceMapHISENTRY","U")
	i $d(^dbo.SYSParameterI("IndexCode",ParamCode)) d
	.s ParaType="" f  s ParaType=$o(^dbo.SYSParameterI("IndexCode",ParamCode,ParaType)) q:ParaType=""  d
	..s ParaTypeCode="" f  s ParaTypeCode=$o(^dbo.SYSParameterI("IndexCode",ParamCode,ParaType,ParaTypeCode)) q:ParaTypeCode=""  d
	...s RowID=$o(^dbo.SYSParameterI("IndexCode",ParamCode,ParaType,ParaTypeCode,""))
	...s obj=##class(dbo.SYSParameter).%OpenId(RowID)
	...s IP=obj.ParaValue
    ...s Webservice=obj.ParaList
    ...i IP=ID s ConnectStringEntry=Webservice
    i $l(ConnectString) q ConnectString_"$LIS.SP$"_ConnectStringEntry
    
	s ConnectString=""
	//写了检验的IP，直接返回
	i $d(^dbo.SYSParameterI("IndexCode",$c(32)_"LISIPINFO")) d
	.s ParaType="" f  s ParaType=$o(^dbo.SYSParameterI("IndexCode",$c(32)_"LISIPINFO",ParaType)) q:ParaType=""  d
	..s ParaTypeCode="" f  s ParaTypeCode=$o(^dbo.SYSParameterI("IndexCode",$c(32)_"LISIPINFO",ParaType,ParaTypeCode)) q:ParaTypeCode=""  d
	...s RowID=$o(^dbo.SYSParameterI("IndexCode",$c(32)_"LISIPINFO",ParaType,ParaTypeCode,""))
	...s obj=##class(dbo.SYSParameter).%OpenId(RowID)
	...i $l(obj.ParaList) s ConnectString=obj.ParaList
	
	s ConnectStringEntry=""
	//写了检验的IP，直接返回
	i $d(^dbo.SYSParameterI("IndexCode",$c(32)_"LISIPINFOENTRY")) d
	.s ParaType="" f  s ParaType=$o(^dbo.SYSParameterI("IndexCode",$c(32)_"LISIPINFOENTRY",ParaType)) q:ParaType=""  d
	..s ParaTypeCode="" f  s ParaTypeCode=$o(^dbo.SYSParameterI("IndexCode",$c(32)_"LISIPINFOENTRY",ParaType,ParaTypeCode)) q:ParaTypeCode=""  d
	...s RowID=$o(^dbo.SYSParameterI("IndexCode",$c(32)_"LISIPINFOENTRY",ParaType,ParaTypeCode,""))
	...s obj=##class(dbo.SYSParameter).%OpenId(RowID)
	...i $l(obj.ParaList) s ConnectStringEntry=obj.ParaList
	
 	q ConnectString_"$LIS.SP$"_ConnectStringEntry
}

/// 获取动态地址  w ##Class(DHCLIS.DHCOrderList).getDllWebIP()
ClassMethod getDllWebIP() As %String
{
	s WebIP=""
	//写了检验的IP，直接返回
	i $d(^dbo.SYSParameterI("IndexCode",$c(32)_"LISIPINFO")) d
	.s ParaType="" f  s ParaType=$o(^dbo.SYSParameterI("IndexCode",$c(32)_"LISIPINFO",ParaType)) q:ParaType=""  d
	..s ParaTypeCode="" f  s ParaTypeCode=$o(^dbo.SYSParameterI("IndexCode",$c(32)_"LISIPINFO",ParaType,ParaTypeCode)) q:ParaTypeCode=""  d
	...s RowID=$o(^dbo.SYSParameterI("IndexCode",$c(32)_"LISIPINFO",ParaType,ParaTypeCode,""))
	...s obj=##class(dbo.SYSParameter).%OpenId(RowID)
	...i $l(obj.ParaValue) s WebIP=obj.ParaValue
	i $l(WebIP) q WebIP
	
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S WebIP=Config.WebServer
	q WebIP
}

/// 获取打印标记
ClassMethod GetTSTemplateMTHD(TSRowID, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14) As %String
{
	s TSRowID=46312
    S TestSetDR=$lg($g(^dbo.RPVisitNumberTestSetD(TSRowID)),3) 
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(TSRowID)),2) 
	s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(TSRowID)),5)
	s orderno=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,""))
	s VisitNumberReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,orderno,""))
	s ReportTextDR=$O(^dbo.RPVisitNumberReportTextI("IndexMaster",VisitNumberReportDR,##Class(LIS.Util.Common).IndexData("P"),""))
	;s ReportTextDR=2
	s ReportText=""
	s obj=##Class(dbo.RPVisitNumberReportText).%OpenId(ReportTextDR)
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.CopyFrom(obj.ReportText)
	while('stream.AtEnd){ 
	  s ReadLineStr = $zcvt(stream.ReadLine(),"I","UTF8")
	  s ReportText =ReportText_ReadLineStr 
	
	}
	Q ReportText
}

// 获得报告标记，返回空或者PrintPreview或者pdf全路径

// w ##Class(DHCLIS.DHCOrderList).GetReportFlag(14187842)

ClassMethod GetReportFlag(ReportDR) As %String
{
	s ReportDR=$g(ReportDR)
	i '$l(ReportDR) q ""
	i ReportDR["," q ""
	s ret=""
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),2)
	s AdmNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),5)
	i '$l(AdmNo) s AdmNo="-1"
	s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),4)
	i $d(^dbo.RPVisitNumberTestSetI("IndexWGMachineDR",VisitNumberDR,WorkGroupMachineDR)) d
	.s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexWGMachineDR",VisitNumberDR,WorkGroupMachineDR,TestSetDR)) q:TestSetDR=""  d
	..s ReportShowType=$lg($g(^dbo.BTTestSetD(TestSetDR)),28)
	..i ReportShowType="1" d
	...set ret="http://"_..getDllWebIP()_"/iMedicalLIS/facade/ui/frmLisReportPrintView.aspx?ReportDR="_ReportDR
	..i ReportShowType="2" d
	...i $l(AdmNo),$d(^["DHC-LISDATA"]LISRepPDF(AdmNo,ReportDR)) d
	....s FilePath=^["DHC-LISDATA"]LISRepPDF(AdmNo,ReportDR)
	....i FilePath["ftp://" s ret=FilePath q
	....s FTPPath=""
	....s RowId=$o(^dbo.SYSParameterI("IndexCode"," "_$zcvt("LABReportPDFFTP","U")," SYS"," DHCC",""))
	....i $l(RowId) s FTPPath=$lg($g(^dbo.SYSParameterD(RowId)),5)
	....i '$l(RowId) d
	.....s objPara=##class(dbo.SYSParameter).%New()
	.....s objPara.Code="LABReportPDFFTP"
	.....s objPara.Description="生成报告PDF的FTP根路径"
	.....s objPara.ParaType="SYS"
	.....s objPara.ParaTypeCode="DHCC"
	.....s objPara.ParaValue=""
	.....s objPara.ParaList="生成报告PDF的FTP根路径"
	.....s objPara.Sequence=1
	.....s ret=objPara.%Save()
	....s FileDate=$p(FilePath,"\",$l(FilePath,"\")-1)
	....s FileName=$p(FilePath,"\",$l(FilePath,"\"))
	....s FilePath=FileDate_"/"_FileName
	....s ret=FTPPath_FilePath
	q ret
}

/// $.ajax({
/// 		url:'jquery.easyui.dhclabclassjson.csp',
/// 		data:{
/// 			ClassName:"DHCLIS.DHCOrderList",
/// 			QueryName:"SetTSPrintFlagMTHD",
/// 			FunModul:"MTHD",
/// 			P0:reportDRs,
/// 			P1:UserParam,
/// 			P2:paramList
/// 		},
/// 		type:"get",
/// 		success:function(data) {			
/// 	 })
/// 保存打印日志
/// w ##Class(DHCLIS.DHCOrderList).SetTSPrintFlagMTHD("213904","1415^1","DOCTOR")
ClassMethod SetTSPrintFlagMTHD(TSRowIDs As %String(MAXLEN=32767), UserID As %String, param As %String, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
  s $NAMESPACE="DHC-LISDATA"	
  s ret= ##Class(HIS.DHCReportPrint).SetTSPrintFlagMTHD(TSRowIDs,UserID,param)
  s $NAMESPACE="DHC-APP"	
  q ret
}

/// 得到手工计费的状态
/// w ##class(DHCLIS.DHCOrderList).GetManualState(331)
/// 返回多个@分割的后面格式串：标本主键^医嘱名称^医嘱数量^价格^操作人^操作日期^操作时间^是否收费
ClassMethod GetManualState(VisitNumberDR)
{
	s SelfCheckFee="1"
	s RowId=$o(^dbo.SYSParameterI("IndexCode"," SELFCHECKFEE"," SYS"," DHCC",""))
	i $l(RowId) s SelfCheckFee=$lg($g(^dbo.SYSParameterD(RowId)),5)
	e  d
	.s objPara=##class(dbo.SYSParameter).%New()
	.s objPara.Code="SelfCheckFee"
	.s objPara.Description="自助打印是否检测手工计费完成状态"
	.s objPara.ParaType="SYS"
	.s objPara.ParaTypeCode="DHCC"
	.s objPara.ParaValue="1"
	.s objPara.ParaList="1：检测费用状态，0：否"
	.s objPara.Sequence=1
	.s ret=objPara.%Save()
	//不检测计费
	i (SelfCheckFee'="1") q ""
	s VisitNumberDR=$g(VisitNumberDR)
	i '$l(VisitNumberDR) q ""
	s AdmTypeDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),4),AdmTypeCode=""
    i $l(AdmTypeDR) d
    .s AdmTypeCode=$lg($g(^dbo.BTAdmissionTypeD(AdmTypeDR)),2)
	s ret=""
	Set repid=$I(^CacheTemp)
	k ^TMPLIS($zn,repid,$j)
	s OrdItem="" f  s OrdItem=$o(^dbo.RPVisitNumberManualAccountI("IndexOrdItem",VisitNumberDR,OrdItem)) q:OrdItem=""  d
	.s OperateTypeDR="" f  s OperateTypeDR=$o(^dbo.RPVisitNumberManualAccountI("IndexOrdItem",VisitNumberDR,OrdItem,OperateTypeDR)) q:OperateTypeDR=""  d
	..s VNMDR="" f  s VNMDR=$o(^dbo.RPVisitNumberManualAccountI("IndexOrdItem",VisitNumberDR,OrdItem,OperateTypeDR,VNMDR)) q:VNMDR=""  d
	...s Quantity=$lg($g(^dbo.RPVisitNumberManualAccountD(VNMDR)),7)
	...s Price=$lg($g(^dbo.RPVisitNumberManualAccountD(VNMDR)),8)
	...s OperateDate=$lg($g(^dbo.RPVisitNumberManualAccountD(VNMDR)),3)
	...i $l(OperateDate) s OperateDate=##Class(LIS.Util.Common).FormatDate(OperateDate)
	...s OperateTime=$lg($g(^dbo.RPVisitNumberManualAccountD(VNMDR)),4)
	...i $l(OperateTime) s OperateTime=##Class(LIS.Util.Common).FormatTime(OperateTime)
	...s OperateUserDR=$lg($g(^dbo.RPVisitNumberManualAccountD(VNMDR)),5)
	...s OperateUser=""
	...i $l(OperateUserDR) s OperateUser=$lg($g(^dbo.SYSUserD(OperateUserDR)),3)
	...i '$d(^TMPLIS($zn,repid,$j,"Data",OrdItem)) s ^TMPLIS($zn,repid,$j,"Data",OrdItem)=0
	...i '$d(^TMPLIS($zn,repid,$j,"Quantity",OrdItem)) s ^TMPLIS($zn,repid,$j,"Quantity",OrdItem)=0
	...i '$d(^TMPLIS($zn,repid,$j,"Price",OrdItem)) s ^TMPLIS($zn,repid,$j,"Price",OrdItem)=Price
	...i '$d(^TMPLIS($zn,repid,$j,"OperateDate",OrdItem)) s ^TMPLIS($zn,repid,$j,"OperateDate",OrdItem)=OperateDate
	...i '$d(^TMPLIS($zn,repid,$j,"OperateTime",OrdItem)) s ^TMPLIS($zn,repid,$j,"OperateTime",OrdItem)=OperateTime
	...i '$d(^TMPLIS($zn,repid,$j,"OperateUser",OrdItem)) s ^TMPLIS($zn,repid,$j,"OperateUser",OrdItem)=OperateUser
	...i '$d(^TMPLIS($zn,repid,$j,"OrderitemDR",OrdItem)) s ^TMPLIS($zn,repid,$j,"OrderitemDR",OrdItem)=$lg($g(^dbo.RPVisitNumberManualAccountD(VNMDR)),6)
	...s ^TMPLIS($zn,repid,$j,"Data",OrdItem)=^TMPLIS($zn,repid,$j,"Data",OrdItem)+Quantity
	...s ^TMPLIS($zn,repid,$j,"Quantity",OrdItem)=^TMPLIS($zn,repid,$j,"Quantity",OrdItem)+Quantity
	s OrdItem="" f  s OrdItem=$o(^TMPLIS($zn,repid,$j,"Data",OrdItem)) q:OrdItem=""  d
	.s ordItmRowId=$TR(OrdItem," ")
	.s OrdId=$p(ordItmRowId,"||",1)
    .s OrdSubId=$p(ordItmRowId,"||",2)
    .s Biled=""
    .s temBiled=""
    .i $l(OrdId),$l(OrdSubId),$d(^OEORD(OrdId,"I",OrdSubId,3)) s temBiled=$p(^OEORD(OrdId,"I",OrdSubId,3),"^",5)
    .//已经收费的退出
    .i (temBiled="P")||((AdmTypeCode="I")&&(temBiled="TB")) q
    .e   s Biled="0" 
    .//没有数量退出
    .i ^TMPLIS($zn,repid,$j,"Data",OrdItem)="0" q
	.s arcim=^TMPLIS($zn,repid,$j,"OrderitemDR",OrdItem)
	.s Subscript=$p(arcim,"||",1)
	.s Version=$p(arcim,"||",2)
	.Q:('$L(Subscript))||('$L(Version))
	.s itmdesc=$p($G(^ARCIM(Subscript,Version,1)),"^",2) //his医嘱描述
	.i '$l(ret) s ret=ret_VisitNumberDR_"^"_itmdesc_"^"_^TMPLIS($zn,repid,$j,"Quantity",OrdItem)_"^"_^TMPLIS($zn,repid,$j,"Price",OrdItem)_"^"_^TMPLIS($zn,repid,$j,"OperateUser",OrdItem)_"^"_^TMPLIS($zn,repid,$j,"OperateDate",OrdItem)_"^"_^TMPLIS($zn,repid,$j,"OperateTime",OrdItem)_"^"_Biled
	.e  s ret=ret_"@"_VisitNumberDR_"^"_itmdesc_"^"_^TMPLIS($zn,repid,$j,"Quantity",OrdItem)_"^"_^TMPLIS($zn,repid,$j,"Price",OrdItem)_"^"_^TMPLIS($zn,repid,$j,"OperateUser",OrdItem)_"^"_^TMPLIS($zn,repid,$j,"OperateDate",OrdItem)_"^"_^TMPLIS($zn,repid,$j,"OperateTime",OrdItem)_"^"_Biled
	k ^TMPLIS($zn,repid,$j)
	q ret
}

/// w ##Class(DHCLIS.DHCOrderList).GetMsgViewUrl("3833914||20")
ClassMethod GetMsgViewUrl(OrderIDs, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14) As %String
{
	s OrdID=+$P(OrderIDs,"||",1)
 	s SubID=+$P(OrderIDs,"||",2)
 	s OEItemID=OrdID_"||"_SubID
 	s arcimDr=$p(^OEORD(OrdID,"I",SubID,1),"^",2)
 	i '$l(arcimDr) q ""
	s TestSetCode=##class(DHCLIS.DHCCommon).GetTSExtCode(arcimDr)
 	s SpecimenCode=$$GetOELabSpecimen(OEItemID)
	s url="./dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_LABBrowser&GenCode="_TestSetCode_"&PointerCode="_SpecimenCode
	//s url="http://192.168.31.131/dthealth/web/csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_LABBrowser&GenCode=S0024&PointerCode=SP44"
	q url
GetOELabSpecimen(Par)
	Quit:$g(Par)="" ""
	Set OERid=+Par
	Set OESubrid=$P(Par,"||",2)
	Set OESpecRid=$O(^OEORD(OERid,"I",OESubrid,"SPEC",0))
	Q:OESpecRid="" "" 
	Set specimen=""
	Set specimen=$p(^OEORD(OERid,"I",OESubrid,"SPEC",OESpecRid),"^",1)
	Set Container=$p(^OEORD(OERid,"I",OESubrid,"SPEC",OESpecRid),"^",11)
	Set Convolumn=$p(^OEORD(OERid,"I",OESubrid,"SPEC",OESpecRid),"^",12)	
	Quit specimen
}

ClassMethod GetTCMsgViewUrl(ReportResultDR, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14) As %String
{
	i $l(ReportResultDR) q ""
	s ReportResultData=$g(^dbo.RPVisitNumberReportResultD(ReportResultDR))
	s TestCodeDR=$lg(ReportResultData,3)
	s Result=$lg(ReportResultData,5)
	s ExtraRes=$lg(ReportResultData,6)

	s TestCode=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),2)
	s TestCodeName=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),3)

	s url="./dhc.bdp.kb.dhclabbrowserforlab.csp?GenCode="_TestCode_"&PointerCode="_Result
	q url
}

}
