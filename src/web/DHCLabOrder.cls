Include webimport

IncludeGenerator webimport

Class web.DHCLabOrder Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod QueryOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryOrderListExecute(ByRef qHandle As %Binary, EpisodeID As %String, PatientID As %String, Search As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s EpisodeID=$g(EpisodeID),PatientID=$g(PatientID)
	s SearchCriteria=$g(Search)
	s FromDate=$p(SearchCriteria,"^",1)
	i $l(FromDate) s FromDate=$zdh(FromDate,4)
	s ToDate=$p(SearchCriteria,"^",2)
	i $l(ToDate) S ToDate=$zdh(ToDate,4)
	//科室
	s LocCode=$p(SearchCriteria,"^",3)
	s LocId=""
	i $l(LocCode) s LocId=$o(^CTLOC(0,"Code",LocCode,""),-1)
	//是否审核
	s AuthFlag=$p(SearchCriteria,"^",4)
	//i '$l(AuthFlag) s AuthFlag="N"
	//所有医嘱
	s AllTS=$p(SearchCriteria,"^",5)
	i '$l(AllTS) s AllTS="N"
	//就诊日期范围  1:三月 2:半年 3:一年 4:所有
	s AdmDateFlag=$p(SearchCriteria,"^",6)
	
	k ^TMP($zn,$j)
    s ^TMPEPIS=EpisodeID_","_PatientID_","_SearchCriteria
	i $l(EpisodeID) d GetOrderByEpisode(EpisodeID)
	i AllTS="Y",$l(PatientID) d
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
	
	k ^TMP("LABReport",PatientID)
	k ^TMP("LABReportIndex",PatientID)
	s num=0
	s labno="" f  s labno=$o(^TMP($zn,$j,"Merge",labno),-1) q:labno=""  d
	.s mi="" f  s mi=$o(^TMP($zn,$j,"Merge",labno,mi)) q:mi=""  d
	..s epis="" f  s epis=$o(^TMP($zn,$j,"Merge",labno,mi,epis)) q:epis=""  d
	...s date="" f  s date=$o(^TMP($zn,$j,"Merge",labno,mi,epis,date)) q:date=""  d
	....s Data=$g(^TMP($zn,$j,"Merge",labno,mi,epis,date))
	....d OutputRow
	....//上下报告查看记录
	....s OrderID=$li(Data,1)
	....s AuthDate=$li(Data,13)
	....i $l(AuthDate) s num=num+1,^TMP("LABReport",PatientID,OrderID)=num,^TMP("LABReportIndex",PatientID,num)=OrderID

	Set qHandle=$lb(0,repid,0)
	k TMP($zn,$j)
	Quit $$$OK
	
GetOrderByEpisode(EpisodeNo)
	s OrdId=""
	f {
		s OrdId=$o(^OEORD(0,"Adm",EpisodeNo,OrdId))
		q:OrdId=""
		s SubId=""
		f {
			s SubId=$o(^OEORD(OrdId,"I",SubId),-1)
			q:SubId=""
			s OrdRowId=OrdId_"||"_SubId
			s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
			s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
			s ItmMastDr=$p(OrdStr1,"^",2)
			i $l(ItmMastDr),..isLabTS(ItmMastDr){
				s OrdName=""
				i $l(ItmMastDr),$d(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)){
					s OrdName=$p(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1),"^",2)
				}
				//申请日期时间
				s ReqTime=$p(OrdStr1,"^",17)
				i $l(ReqTime) s ReqTime=$zt(ReqTime,2)
				s ReqDate=$p(OrdStr3,"^",7)
				//比较日期
				s flag="N"
				i $l(ReqDate){
					i $l(FromDate),ReqDate-FromDate<0 s flag="Y"
					i flag="N",$l(ToDate),ReqDate-ToDate>0 s flag="Y"
				}
				//比较科室
				//i flag="N",$l(
				i $l(ReqDate) s ReqDate=$zd(ReqDate,3)
				//检验号
				s LabEpisode=$p(OrdStr3,"^",20)
				//b 20
				//报告ID
				s LabTestSetRow=$p(OrdStr3,"^",35)
				s ReportStus="N"
				s (RecDate,RecTime,AuthDate,AuthTime,TransComm,TSResultAnomaly,TSMemo)=""
				s tmpEpis="ZNULL",tmpMi="ZNULL",tmpDate=""
				s ReportFlag="N"  //预报告
				//标本提示
				s TSMemo=##class(web.DHCLabResultStatus).checkTSMemo(OrdRowId,LabEpisode)
				i flag="N"{
					i $l(LabTestSetRow){
						//b 100
						s LabNo=$p(LabTestSetRow,"||",1)
						s TS=$p(LabTestSetRow,"||",2)
						s TSCnt=$p(LabTestSetRow,"||",3)
						i $l(LabNo),$l(TS),$l(TSCnt),$d(^TEPI(LabNo,1,TS,TSCnt)){
							i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)="A" s ReportStus="Y"
							//i ('$l(AuthFlag))!('((ReportStus="N")&(AuthFlag="Y")))
							s tmpEpis=$p(^TEPI(LabNo,1,TS,TSCnt),"\",12)  ///流水号
							i '$l($tr(tmpEpis," ")) s tmpEpis="ZNULL" 
							s tmpMi=$p(^TEPI(LabNo,1,TS,TSCnt),"\",27)  ///仪器代码
							i '$l($tr(tmpMi," ")) s tmpMi="ZNULL" 
							i AuthFlag="Y" {
								i ReportStus'="Y" s flag="Y"
							}
							i AuthFlag="N" {
								i ReportStus="Y" s flag="Y"
							}
							i flag="N"{
								//b 200
								//接收日期时间
								s RecDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",21)
								s tmpDate=RecDate
								i $l(RecDate) s RecDate=$zd(RecDate,3)
								s RecTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",22)
								i $l(RecTime) s RecTime=$zt(RecTime*60,2)
								//审核日期时间
								s AuthDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",4)
								i $l(AuthDate) s tmpDate=AuthDate,AuthDate=$zd(AuthDate,3)
								s AuthTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",5)
								i $l(AuthTime) s AuthTime=$zt(AuthTime*60,2)
								//是否有预报告
								i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)'="A",$p($g(^["LABDATA"]DHCPreReport(LabNo,TS,TSCnt,1)),"\",7)="A" s ReportFlag="Y"
								//危急提示
								s TransComm=##Class(web.DHCLabCommon).GetWarnComment(LabNo,TS,TSCnt)
								//结果异常标志
								s TSResultAnomaly=##class(web.DHCLabResultStatus).checkTSResultStatus(LabTestSetRow)

								s RtnValue=1
							}
						} else{
							i AuthFlag="Y" s flag="Y"
						}
					} else {
						i AuthFlag="Y" s flag="Y"
					}	
				}	
				i flag="N"{			
					//标本OE_OrdSpecimen
					s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
					s (SpecCode,SpecName)=""
					i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
					i $l(SpecCode),$d(^TTAB("SPEC",SpecCode)){
						s SpecName=$p(^TTAB("SPEC",SpecCode),"\",1)
					}
					//采集日期时间Collection
					s (SpecDate,SpecTime)=""
					s ret=##Class(web.DHCNurSpecerNo).GetspecCollDatetime(OrdRowId)
					i $l(ret){
						s SpecDate=$p(ret,"^",2)
						i $l(SpecDate) s SpecDate=$zd(SpecDate,3)
						s SpecTime=$p(ret,"^",3)
						i $l(SpecTime) s SpecTime=$zt(SpecTime,2)
					}
					//就诊日期
					s AdmDate=$p(^PAADM(EpisodeNo),"^",6)
					i $l(AdmDate) s AdmDate=$zd(AdmDate,3)
					s AdmLoc=$p(^CTLOC($p(^PAADM(EpisodeNo),"^",4)),"^",2)
					s AdmType=$p(^PAADM(EpisodeNo),"^",2)
					i AdmType="O" s AdmType="门诊"
					i AdmType="I" s AdmType="住院"
					i AdmType="E" s AdmType="急诊"
					i AdmType="H" s AdmType="体检"
					///合并报告显示
					i '$l(tmpDate) s tmpDate=AdmDate
					set Data=$lb(OrdRowId,OrdName,ReqDate,ReqTime,ReportStus,LabEpisode,LabTestSetRow,SpecName,SpecDate,SpecTime,RecDate,RecTime,AuthDate,AuthTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,EpisodeNo,AdmDate,AdmLoc,AdmType)
					s TS=$g(TS)
					i $l(TS),$d(^TTAB("TS",TS,"XM")) s tmpEpis=tmpEpis_TS   ///配血医嘱合并
					//医嘱状态合并
					s ItmStat=$p(^OEORD(OrdId,"I",SubId,1),"^",13)
					s tmpDate=ItmStat_tmpDate
					
					i $d(^TMP($zn,$j,"Merge",LabEpisode,tmpMi,tmpEpis,tmpDate)) {
						s Data=$g(^TMP($zn,$j,"Merge",LabEpisode,tmpMi,tmpEpis,tmpDate))
						s tmpOrdRowId=$lg(Data,1)
						s tmpOrdName=$lg(Data,2)
						s tmpLabTestSetRow=$lg(Data,7)
						s OrdRowId=tmpOrdRowId_","_OrdRowId
						s OrdName=tmpOrdName_"+"_OrdName
						i $l(tmpLabTestSetRow) s LabTestSetRow=tmpLabTestSetRow_","_LabTestSetRow
						set Data=$lb(OrdRowId,OrdName,ReqDate,ReqTime,ReportStus,LabEpisode,LabTestSetRow,SpecName,SpecDate,SpecTime,RecDate,RecTime,AuthDate,AuthTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,EpisodeNo,AdmDate,AdmLoc,AdmType)
					}
					s ^TMP($zn,$j,"Merge",LabEpisode,tmpMi,tmpEpis,tmpDate)=Data
					//s ^TMP($zn,$j,ReqDate,ReqTime,SubId)=Data
				}
				//d OutputRow
			}
		}
	}
	q
	
OutputRow
	//set Data=$lb(OrdRowId,OrdName,ReqDate,ReqTime,ReportStus,LabEpisode,LabTestSetRow,SpecName,SpecDate,SpecTime,RecDate,RecTime,AuthDate,AuthTime,ReportFlag,TransComm)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
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

/// Creator：      huhm
/// CreatDate：    20090514
/// Description:： 根据就诊号或卡号(登记号)得到检验医嘱列表
/// Table：        OE_Order,OE_OrdItem,OE_OrdSpecimen
/// Input：        就诊号
/// Output：       医嘱ID,医嘱名称,医嘱申请日期和时间,结果状态,检验号,
///                报告ID,标本,标本采集日期和时间,接收日期和时间
///                审核日期和时间,是否有预报告,危急提示,医嘱结果异常标志,医嘱备注,就诊号,就诊日期,就诊科室,就诊类型
///                OrdRowId,OrdName,ReqDate,ReqTime,ReportStus,LabEpisode,
///                LabTestSetRow,SpecName,SpecDate,SpecTime,RecDate,RecTime,
///                AuthDate,AuthTime,PreReport,WarnComm,TSResultAnomaly,TSMemo,AdmNo,AdmDate,AdmLoc,AdmType
/// Return：         函数返回值的说明
/// Others：        其它说明
Query QueryOrderList(EpisodeID As %String, PatientID As %String, Search As %String) As %Query(ROWSPEC = "OEOrdItemID:%String,OrdItemName:%String,OrdItemDate:%String,OrdItemTime:%String,ResultStatus:%String,LabEpisode:%String,LabTestSetRow:%String,OrdSpecimen:%String,SpecDate:%String,SpecTime:%String,RecDate:%String,RecTime:%String,AuthDate:%String,AuthTime:%String,PreReport:%String,WarnComm:%String,TSResultAnomaly:%String,TSMemo:%String,AdmNo:%String,AdmDate:%String,AdmLoc:%String,AdmType:%String")
{
}

/// 检查医嘱项目是否是否检验医嘱
ClassMethod isLabTS(ItemMast As %String) As %String
{
	s ItemMast=$g(ItemMast)
	s RtnValue="0"
	s ItmCat=$p(^ARCIM(+ItemMast,$p(ItemMast,"||",2),1),"^",10)
	i $l(ItmCat),$d(^ARC("IC",ItmCat)){
		i $p(^ARC("IC",ItmCat),"^",7)="L" s RtnValue="1"
	}
	Quit RtnValue
}

/// 得到报告基本信息
ClassMethod GetLabInfoBroker(TSID As %Library.String = "") As %String
{
  q:TSID="" ""
  s TestSetRow=$p(^OEORD(+TSID,"I",$p(TSID,"||",2),3),"^",35)
  q:TestSetRow="" ""
  s LabNo=$p(TestSetRow,"||",1)
  s TS=$p(TestSetRow,"||",2)
  s TSCNT=$p(TestSetRow,"||",3)
  s LabStr=$g(^TEPI(LabNo))
  //标本,病区,科室,医生,申请时间,采样时间,接收时间,报告时间，
  //s Species=##Class(web.DHCLabCommon).GetSpecies(LabNo)
  //标本
  s OrdSpecimen=""
  s SpecDr=$p(^TEPI(LabNo,1,TS,TSCNT),"\",46)
  i $l(SpecDr),$d(^TTAB("SPEC",SpecDr)) s OrdSpecimen=$p(^TTAB("SPEC",SpecDr),"\",1)
  //医生
  //s DocName=""
  //s DocC/ode=$p(^TEPI(LabNo),"\",13)
  //i DocCode'="",$d(^TTAB("DR",DocCode)) s DocName=$p(^TTAB("DR",DocCode),"\",1)
  s Doctor=##Class(web.DHCLabCommon).GetReqDoctor(TestSetRow) //TSID)
  //病区
  s WardName=""
  s WardDr=$p(^TEPI(LabNo),"\",20)
  i $l(WardDr),$d(^TTAB("RH",WardDr)) s WardName=$p(^TTAB("RH",WardDr),"\",1)
  //科室
  s LocName=""					   
  s LocCode=$p(^TEPI(LabNo),"\",36) 
  i LocCode'="",$d(^TTAB("USLOC",LocCode)) s LocName=$p($g(^TTAB("USLOC",LocCode)),"\",1)
  //申请日期
  s Reqdate=$p(^TEPI(LabNo),"\",12) 
  i $l(Reqdate) s Reqdate=$zd(Reqdate,3)
  //采样时间
  s CollDate=$p(^TEPI(LabNo,1,TS,TSCNT),"\",44)
  i CollDate'="" s CollDate=$zd(CollDate,3)
  s CollTime=$p(^TEPI(LabNo,1,TS,TSCNT),"\",45)
  i CollTime'="" s CollTime=$zt(CollTime,2)
  //接收时间
  s RecDate=$p(^TEPI(LabNo,1,TS,TSCNT),"\",21)
  i $l(RecDate) s RecDate=$zd(RecDate,3)
  s RecTime=$p(^TEPI(LabNo,1,TS,TSCNT),"\",22)
  i $l(RecTime) s RecTime=$zt(RecTime*60,2)
  //报告时间
  s AuthDate=$p(^TEPI(LabNo,1,TS,TSCNT),"\",21)
  i $l(AuthDate) s AuthDate=$zd(AuthDate,3)
  s AuthTime=$p(^TEPI(LabNo,1,TS,TSCNT),"\",22)
  i $l(AuthTime) s AuthTime=$zt(AuthTime*60,2)
  //医嘱名称
  s OrdName=""
  s OrdId=$p(TSID,"||",1) //$o(^OEORD(0,"EpisNo",LabNo,""))
  s SubId=$p(TSID,"||",2) //$o(^OEORDi(0,"LabTS",OrdId,TSID,""))
  s ItmMastDr=""
  i $l(OrdId){
	  //s OrdRowId=OrdId_"||"_SubId
	  s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
	  s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
	  s ItmMastDr=$p(OrdStr1,"^",2)
  }
  i $l(ItmMastDr){
	i $l(ItmMastDr),$d(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)){
	s OrdName=$p(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1),"^",2)
  }
  s retStr=OrdSpecimen_"^"_Doctor_"^"_WardName_"^"_LocName_"^"_Reqdate
  s retStr=retStr_"^"_CollDate_" "_CollTime_"^"_RecDate_" "_RecTime
  s retStr=retStr_"^"_AuthDate_" "_AuthTime_"^"_OrdName_"^"_LabNo_"^"_TestSetRow
  q retStr
  }
}

ClassMethod getAdmList(PatientID As %String) As %String
{
	s PatientID=$g(PatientID)
	i '$l(PatientID) q ""
	s RetList=""
	s type="" f  s type=$o(^PAPERdr(PatientID,"ADM",type)) q:type=""  d
	.s ADMId="" f  s ADMId=$o(^PAPERdr(PatientID,"ADM",type,ADMId),-1) q:ADMId=""  d
	..s AdmLoc=$p($g(^CTLOC($p(^PAADM(ADMId),"^",4))),"^",2)
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

ClassMethod GetAdmInfoByLabno(Labno As %String) As %String
{
	s Labno=$g(Labno)
	i '$l(Labno) q ""
	s AdmInfo=""
	i $d(^OEORD(0,"EpisNo",Labno)) d
	.s OrdItmId=$o(^OEORD(0,"EpisNo",Labno,""))
	.s CurAdm=$p(^OEORD(OrdItmId),"^",1)
	.s admloc=$p(^CTLOC($p(^PAADM(CurAdm),"^",4)),"^",2)
	.s admdate=$zd($p(^PAADM(CurAdm),"^",6),3)
	.s papmiId=+$g(^PAADM(CurAdm))
	.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	.s admtype=$p(^PAADM(CurAdm),"^",2)
	.i admtype="O" s admtype="门诊"
	.i admtype="I" s admtype="住院"
	.i admtype="E" s admtype="急诊"
	.i admtype="H" s admtype="体检"
	.s AdmInfo="就诊号："_CurAdm_"  就诊日期："_admdate_"  就诊科室："_admloc_"  就诊类型："_admtype
	q AdmInfo
}

ClassMethod GetRptListByOrdID(OrdRowIDs As %String, PatientID As %String) As %String
{
	s OrdRowIDs=$g(OrdRowIDs)
	s OrdId=$p(OrdRowIDs,"||",1)
	i '$l(OrdId) q "^^^"
	i '$l(PatientID) q "^^^"
	s nextReport="",preReport="",nextAdmRpt="",preAdmRpt=""
	///下一个报告
	s num=$g(^TMP("LABReport",PatientID,OrdRowIDs))
	i $l(num) d
	.s nextNum=$o(^TMP("LABReportIndex",PatientID,num))
	.i $l(nextNum) s nextReport=$g(^TMP("LABReportIndex",PatientID,nextNum))
	.//上一个报告
	.s preNum=$o(^TMP("LABReportIndex",PatientID,num),-1)
	.i $l(preNum) s preReport=$g(^TMP("LABReportIndex",PatientID,preNum))
	/*
	s MaxSub=+$p($p(OrdRowIDs,",",1),"||",2)
	s MinSub=+$p($p(OrdRowIDs,",",$l(OrdRowIDs,",")),"||",2)
	s Ordsub=MinSub
	i MaxSub>MinSub s Ordsub=MaxSub
	f  s Ordsub=$o(^OEORD(OrdId,"I",Ordsub)) q:(Ordsub="")!(nextReport'="")  d
	.s TestSetRow=$p($g(^OEORD(OrdId,"I",Ordsub,3)),"^",35)
 	.s LabNo=$p(TestSetRow,"||",1),TS=$p(TestSetRow,"||",2),TSCNT=$p(TestSetRow,"||",3)
 	.i $l(LabNo),$l(TS),$l(TSCNT),$d(^TEPI(LabNo,1,TS,TSCNT)) d
 	..i $p(^TEPI(LabNo,1,TS,TSCNT),"\",31)="A" s nextReport=OrdId_"||"_Ordsub
	i $l(nextReport) s nextReport=..GetMergeOrdRowID(nextReport)
	*/
	
	///上一个报告
	/*
	s Ordsub=MaxSub
	i MaxSub>MinSub s Ordsub=MinSub
	f  s Ordsub=$o(^OEORD(OrdId,"I",Ordsub),-1) q:(Ordsub="")!(preReport'="")  d
	.s TestSetRow=$p($g(^OEORD(OrdId,"I",Ordsub,3)),"^",35)
 	.s LabNo=$p(TestSetRow,"||",1),TS=$p(TestSetRow,"||",2),TSCNT=$p(TestSetRow,"||",3)
 	.i $l(LabNo),$l(TS),$l(TSCNT),$d(^TEPI(LabNo,1,TS,TSCNT)) d
 	..i $p(^TEPI(LabNo,1,TS,TSCNT),"\",31)="A" s preReport=OrdId_"||"_Ordsub
	i $l(preReport) s preReport=..GetMergeOrdRowID(preReport)
	*/

	///下一就诊报告
	s CurAdm=$p(^OEORD(+OrdRowIDs),"^",1)
	s papmiId=+$g(^PAADM(CurAdm))
	
	k AdmList
	s PatType="" f  s PatType=$o(^PAPERdr(papmiId,"ADM",PatType)) q:PatType=""  d
	.s Adm="" f  s Adm=$o(^PAPERdr(papmiId,"ADM",PatType,Adm)) q:Adm=""  d
	..s AdmList(Adm)=""
	
	s nextAdm=$o(AdmList(CurAdm))
	i $l(nextAdm) d
	.s OrdId="" f  s OrdId=$o(^OEORD(0,"Adm",nextAdm,OrdId)) q:(OrdId="")!(nextAdmRpt'="")  d
	..s Ordsub="" f  s Ordsub=$o(^OEORD(OrdId,"I",Ordsub),-1) q:(Ordsub="")!(nextAdmRpt'="")  d	
	...s TestSetRow=$p($g(^OEORD(OrdId,"I",Ordsub,3)),"^",35)
 	...s LabNo=$p(TestSetRow,"||",1),TS=$p(TestSetRow,"||",2),TSCNT=$p(TestSetRow,"||",3)
 	...i $l(LabNo),$l(TS),$l(TSCNT),$d(^TEPI(LabNo,1,TS,TSCNT)) d
 	....i $p(^TEPI(LabNo,1,TS,TSCNT),"\",31)="A" s nextAdmRpt=OrdId_"||"_Ordsub
	i $l(nextAdmRpt) s nextAdmRpt=..GetMergeOrdRowID(nextAdmRpt)
	///前一就诊报告
	s preAdm=$o(AdmList(CurAdm),-1)
	i $l(preAdm) d
	.s OrdId="" f  s OrdId=$o(^OEORD(0,"Adm",preAdm,OrdId)) q:(OrdId="")!(preAdmRpt'="")  d
	..s Ordsub="" f  s Ordsub=$o(^OEORD(OrdId,"I",Ordsub),-1) q:(Ordsub="")!(preAdmRpt'="")  d	
	...s TestSetRow=$p($g(^OEORD(OrdId,"I",Ordsub,3)),"^",35)
 	...s LabNo=$p(TestSetRow,"||",1),TS=$p(TestSetRow,"||",2),TSCNT=$p(TestSetRow,"||",3)
 	...i $l(LabNo),$l(TS),$l(TSCNT),$d(^TEPI(LabNo,1,TS,TSCNT)) d
 	....i $p(^TEPI(LabNo,1,TS,TSCNT),"\",31)="A" s preAdmRpt=OrdId_"||"_Ordsub
	i $l(preAdmRpt) s preAdmRpt=..GetMergeOrdRowID(preAdmRpt)
	
	q nextReport_"^"_preReport_"^"_nextAdmRpt_"^"_preAdmRpt
}

/// 取合并医嘱RowID
ClassMethod GetMergeOrdRowID(OrdRowID As %String) As %String
{
	s retOrdRowID=OrdRowID
	s LabTestSetRow=$p($g(^OEORD(+OrdRowID,"I",$p(OrdRowID,"||",2),3)),"^",35)
	s LabNo=$p(LabTestSetRow,"||",1)
	s TS=$p(LabTestSetRow,"||",2)
	s TSCnt=$p(LabTestSetRow,"||",3)

	s tmpEpis=$p(^TEPI(LabNo,1,TS,TSCnt),"\",12)  ///流水号
	s tmpMi=$p(^TEPI(LabNo,1,TS,TSCnt),"\",27)  ///仪器代码
	s tmpDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",21) ///接收日期
	i $d(^TTAB("TS",TS,"XM")) q retOrdRowID    ///配血医嘱合并
	
	s TS1="" f  s TS1=$o(^TEPI(LabNo,1,TS1)) q:TS1=""  d
	.i TS=TS1 q
	.s TSCnt1="" f  s TSCnt1=$o(^TEPI(LabNo,1,TS1,TSCnt1)) q:TSCnt1=""  d
	..i $p(^TEPI(LabNo,1,TS1,TSCnt1),"\",31)'="A" q
	..i $p(^TEPI(LabNo,1,TS1,TSCnt1),"\",12)'=tmpEpis q
	..i $p(^TEPI(LabNo,1,TS1,TSCnt1),"\",27)'=tmpMi q
	..i $p(^TEPI(LabNo,1,TS1,TSCnt1),"\",21)'=tmpDate q
	..i $d(^TTAB("TS",TS1,"XM")) q
	..s tmpTSRowID=LabNo_"||"_TS1_"||"_TSCnt1
	..s tmpSub=$o(^OEORDi(0,"LabTS",+OrdRowID,tmpTSRowID,""))
	..q:'$l(tmpSub)
	..s retOrdRowID=retOrdRowID_","_$p(OrdRowID,"||",1)_"||"_tmpSub
	q retOrdRowID
}

}
