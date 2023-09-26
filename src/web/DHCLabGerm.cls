/// 名称:  web.DHCLabGerm
/// 描述:  为抗菌药物系统提供访问的接口
/// 编写者：huhm
/// 编写日期: 2012-09-29
Class web.DHCLabGerm Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      huhm 
/// CreateDate：   2011-09-29
/// Description:： 根据病人的就诊记录得到病人的药敏结果 接口
/// Table：        EP_VisitNumber,EP_VisitTestSetData,EP_VisitTestSetDataAntibiotics
/// Input：        就诊ID号
/// Output：       无 
/// Return：       药敏记录rowid^序号^报告日期^样本号^^编码^细菌名[中文]^耐药机制^细菌名英文名^抗生素名^备注        
///                多个药敏记录格式     单个药敏记录！单个药敏记录！单个药敏记录
/// Others：       不支持MEDTRAK版本库
ClassMethod GetAllSenResbyEpisIDOLD(EpisodeID) As %String
{
	new (EpisodeID)
 	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set LabData=Config.LabDataNamespace	
	///P5最后一个是675,P8最后一个是682\
	Set Version="64"
	If '$d(^[LabData]AUDIT(675)) Set Version="63"
	Kill ^TMPRESULT($J)
	Set AdmNo=$p(^PAADM(EpisodeID),"^",81)
	Set Papmi=$p(^PAADM(EpisodeID),"^",1)
	Set RegNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
	//^TDEBi("0000142424","DATE",61377,909,119634)
	/*i '$d(^TIND(5,EpisodeID)) d
	.s dt="" f  s dt=$o(^TDEBi(RegNo,"DATE",dt)) q:dt=""  d
	..s tt="" f  s tt=$o(^TDEBi(RegNo,"DATE",dt,tt)) q:tt=""  d
	...s labno="" f  s labno=$o(^TDEBi(RegNo,"DATE",dt,tt,labno)) q:labno=""  d
	....Set Err=..AddAdmIndex(labno,Version)*/
	
	s dt="" f  s dt=$o(^TDEBi(RegNo,"DATE",dt)) q:dt=""  d
	.s tt="" f  s tt=$o(^TDEBi(RegNo,"DATE",dt,tt)) q:tt=""  d
	..s labno="" f  s labno=$o(^TDEBi(RegNo,"DATE",dt,tt,labno)) q:labno=""  d
	...q:$d(^TIND(5,EpisodeID,AdmNo,labno))
	...Set Err=..AddAdmIndex(labno,Version)
	
	....//w !,labno,":",Err	  
    //.If Version="63",'$d(^TIND(5,AdmId,Labno)) q
    If Version="64" Quit ..GetSenResult64(EpisodeID,AdmNo)
    q ""
}

/// Creator：      zhanglianzhu
/// CreateDate：   2016-02-26
/// Description:： 根据病人的就诊记录得到病人的药敏结果 接口
/// Table：        EP_VisitNumber,EP_VisitTestSetData,EP_VisitTestSetDataAntibiotics
/// Input：        就诊ID号
/// Output：       无 
/// Return：       药敏记录rowid^序号^报告日期^样本号^^编码^细菌名[中文]^耐药机制^细菌名英文名^抗生素名^备注        
///                多个药敏记录格式     单个药敏记录！单个药敏记录！单个药敏记录
/// Others：       不支持MEDTRAK版本库  w ##Class(web.DHCLabGerm).GetAllSenResbyEpisID(578)
ClassMethod GetAllSenResbyEpisID(EpisodeID) As %String
{
	new (EpisodeID)
	Set AdmNo=$p(^PAADM(EpisodeID),"^",81)
    
    Set RetSrt=..GetSenResult(EpisodeID)
    q RetSrt
}

ClassMethod GetSenResult64(AdmId, AdmNo) As %String
{
	n (AdmId,AdmNo)
	s RetStr=""
	s num=1
	;s epis="" f  s epis=$o(^TIND(5,AdmId,AdmNo,epis)) q:epis=""  d
	s ordrowid=$o(^OEORD(0,"Adm",AdmId,""))
	q:ordrowid="" RetStr
	s episid=""  f  s episid=$o(^OEORDi(0,"LabTS",ordrowid,episid))  q:episid=""  d
	.s epis=$p(episid,"||",1)
	.s ts="" f  s ts=$o(^TEPI(epis,1,ts)) q:ts=""  d
	..s cnt="" f  s cnt=$o(^TEPI(epis,1,ts,cnt)) q:cnt=""  d
	...s AuthDate=$p(^TEPI(epis,1,ts,cnt),"\",4)
	...i $l(AuthDate) s AuthDate=$zd(AuthDate,3)
	...s tc=""  f  s tc=$o(^TEPI(epis,1,ts,cnt,"DATA",tc)) q:tc=""  d
	....i $p(^TTAB("TC",tc),"\",3)'="V" q
	....s OrgCode=$p(^TEPI(epis,1,ts,cnt,"DATA",tc),"\",1)
	....s (OrgName,OrgEName)=""
	....i $l(OrgCode),$d(^TTAB("BUG",OrgCode)) d
	.....s OrgName=$p(^TTAB("BUG",OrgCode),"\",1)
	.....s OrgEName=$p(^TTAB("BUG",OrgCode),"\",3)
	....i '$l(OrgName) q
	....s ant="" f  s ant=$o(^TEPI(epis,1,ts,cnt,"DATA",tc,"ANT",ant)) q:ant=""  d
	.....s SenDr=$p(^TEPI(epis,1,ts,cnt,"DATA",tc,"ANT",ant),"\",1)
	.....s SenDesc=""
	.....i $l(SenDr),$d(^TTAB("SENS",SenDr)) s SenDesc=$p(^TTAB("SENS",SenDr),"\",1)
	.....i '$l(SenDesc) q
	.....s AntDesc=$p(^TTAB("ANT",ant),"\",1) q:AntDesc=""
	.....s AntWhonet=$p($g(^["LABDATA"]DHCANTIBIOTICS(ant)),"\",3)
	.....//
	.....s TSName=""
	.....i $d(^TTAB("TS",ts)) s TSName=$p(^TTAB("TS",ts),"\",1)  //项目
	.....s SPName=""
	.....s SPCode=$p(^TEPI(epis,1,ts,cnt),"\",46)
	.....i $l(SPCode),$d(^TTAB("SPEC",SPCode)) s SPName=$p(^TTAB("SPEC",SPCode),"\",1) //标本
	.....s RecDate=$p(^TEPI(epis,1,ts,cnt),"\",21)
	.....i $l(RecDate) s RecDate=$zd(RecDate,3) //送检日期
	.....//
	.....//药敏记录rowid^序号^报告日期^样本号^^编码^细菌名[中文]^耐药机制^细菌名英文名^抗生素名^备注
	.....s list=epis_"||"_ts_"||"_cnt_"||"_tc_"||"_ant_"||"_SenDr_"^"_num_"^"_AuthDate_"^"_epis_"^^"_OrgCode_"^"_OrgName_"^"_SenDesc_"^"_OrgEName_"^"_AntDesc_"^^"_AntWhonet_"^"_TSName_"^"_SPName_"^"_RecDate
	.....s RetStr=RetStr_list_"!"
	.....s num=num+1
	s RetStr=$p(RetStr,"!",1,$l(RetStr,"!")-1)
	q RetStr
}

ClassMethod GetSenResult(AdmId) As %String
{
	n (AdmId,AdmNo)
	s RetStr=""
	s num=1
	q:AdmNo="" RetStr
	
	s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexAdmItem",##Class(LIS.Util.Common).IndexData(AdmId),TestCodeDR)) q:(TestCodeDR="")  d
    .s TestCodeName=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),3)
    .s ResultFormat=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),9)
    .i ResultFormat'="M" q   ///只查询微生物项目类型
    .s AuthDate="" f  s AuthDate=$o(^dbo.RPVisitNumberReportResultI("IndexAdmItem",##Class(LIS.Util.Common).IndexData(AdmId),TestCodeDR,AuthDate)) q:(AuthDate="")  d
    ..s AuthTime="" f  s AuthTime=$o(^dbo.RPVisitNumberReportResultI("IndexAdmItem",##Class(LIS.Util.Common).IndexData(AdmId),TestCodeDR,AuthDate,AuthTime)) q:AuthTime=""  d
    ...s ReportResultDR="" f  s ReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexAdmItem",##Class(LIS.Util.Common).IndexData(AdmId),TestCodeDR,AuthDate,AuthTime,ReportResultDR)) q:ReportResultDR=""  d
	....s VisitNumberReportDR=$lg($g(^dbo.RPVisitNumberReportResultD(ReportResultDR)),2)
	....s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),2)
    ....s RPVisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDR))
    ....s ResultStatus=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),22)   //(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)
    ....i ResultStatus'=3 Quit
	....s TestSetDesc=""
	....s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:TestSetDR=""  d
	.....i $l(TestSetDesc) s TestSetDesc=TestSetDesc_"+"_$lg(^dbo.BTTestSetD(TestSetDR),3)
	.....e  s TestSetDesc=$lg(^dbo.BTTestSetD(TestSetDR),3)
    ....s Labno = $lg(RPVisitNumberData,2)
    ....s ReceiveDate = $lg(RPVisitNumberData,66)
    ....s ReceiveTime = $lg(RPVisitNumberData,67)
    ....s SpecimenDR=$lg(RPVisitNumberData,56),SpecimenDesc=""
    ....i $l(SpecimenDR) s SpecimenDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
    ....s ReportData=$g(^dbo.RPVisitNumberReportD(VisitNumberReportDR))
    ....s OrganismDR=$lg($g(^dbo.RPVisitNumberReportResultD(ReportResultDR)),4)
    ....i '$l(OrganismDR) q
    ....s OrganismData=$g(^dbo.BTOrganismD(OrganismDR))
    ....s OrganismName=$lg(OrganismData,3)
    ....s OrganismEName=$lg(OrganismData,4)
	....s num=0
    ....s AntibioticsDR="" f  s AntibioticsDR=$o(^dbo.RPVisitNumberReportResSenI("IndexAntibiocs",ReportResultDR, AntibioticsDR)) q:AntibioticsDR=""  d
    .....s SenDR="" f  s SenDR=$o(^dbo.RPVisitNumberReportResSenI("IndexAntibiocs",ReportResultDR, AntibioticsDR,SenDR)) q:SenDR=""  d
    ......s SensitivityDR=$lg($g(^dbo.RPVisitNumberReportResSenD(SenDR)),6)
    ......i '$l(SensitivityDR) q
    ......s SensitivityData=$g(^dbo.BTSensitivityD(SensitivityDR))
    ......s SensitivityCode=$lg(SensitivityData,2)
    ......s SensitivityName=$lg(SensitivityData,3)
    ......s AntibioticsData=$g(^dbo.BTAntibioticsD(AntibioticsDR))
    ......s AntibioticsCode=$lg(AntibioticsData,2)
    ......s AntibioticsName=$lg(AntibioticsData,3)
    ......s WCode=$lg(AntibioticsData,6)
    ......s num=num+1
	......//药敏记录rowid^序号^报告日期^样本号^^编码^细菌名[中文]^耐药机制^细菌名英文名^抗生素名^备注
	......s list=VisitNumberReportDR_"||"_TestCodeDR_"||"_AntibioticsDR_"||"_SensitivityDR_"^"_num_"^"_AuthDate_"^"_Labno_"^^"_AntibioticsCode_"^"_OrganismName_"^"_SensitivityName_"^"_OrganismEName_"^"_AntibioticsName_"^^"_WCode_"^"_TestSetDesc_"^"_SpecimenDesc_"^"_ReceiveDate
	......s RetStr=RetStr_list_"!"
	......s num=num+1
	s RetStr=$p(RetStr,"!",1,$l(RetStr,"!")-1)
	q RetStr
}

/// Creator：      liuyg
/// CreatDate：    20200721
/// Description：  通过就诊号返回信息
/// Input：        AdmId：就诊号
/// Output：       药敏记录rowid^序号^报告日期^样本号^^编码^细菌名[中文]^耐药机制^细菌名英文名^抗生素名^备注
/// d ##Class(%ResultSet).RunQuery("web.DHCLabGerm","QryAntResByAdm","40744594","","","","","","","","","","","","-1","-1","113^1^0^13^1")
Query QryAntResByAdm(AdmId, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "VisitNumberReportDR,TestCodeDR,AntibioticsDR,SensitivityDR,num,AuthDate,Labno,AntibioticsCode,OrganismName,SensitivityName,OrganismEName,AntibioticsName,WCode,TestSetDesc,SpecimenDesc,ReceiveDate")
{
}

ClassMethod QryAntResByAdmExecute(ByRef qHandle As %Binary, AdmId, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	
	s AdmId=$g(AdmId)
	s repid=$i(^CacheTemp)
 	s ind=1
	k ^TMPLIS($zn,repid,$j)
	 
	s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexAdmItem",##Class(LIS.Util.Common).IndexData(AdmId),TestCodeDR)) q:(TestCodeDR="")  d
    .s TestCodeName=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),3)
    .s ResultFormat=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),9)
    .i ResultFormat'="M" q   ///只查询微生物项目类型
    .s AuthDate="" f  s AuthDate=$o(^dbo.RPVisitNumberReportResultI("IndexAdmItem",##Class(LIS.Util.Common).IndexData(AdmId),TestCodeDR,AuthDate)) q:(AuthDate="")  d
    ..s AuthTime="" f  s AuthTime=$o(^dbo.RPVisitNumberReportResultI("IndexAdmItem",##Class(LIS.Util.Common).IndexData(AdmId),TestCodeDR,AuthDate,AuthTime)) q:AuthTime=""  d
    ...s ReportResultDR="" f  s ReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexAdmItem",##Class(LIS.Util.Common).IndexData(AdmId),TestCodeDR,AuthDate,AuthTime,ReportResultDR)) q:ReportResultDR=""  d
	....s VisitNumberReportDR=$lg($g(^dbo.RPVisitNumberReportResultD(ReportResultDR)),2)
	....s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),2)
    ....s RPVisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDR))
    ....s ResultStatus=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),22)   //(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)
    ....i ResultStatus'=3 Quit
	....s TestSetDesc=""
	....s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:TestSetDR=""  d
	.....i $l(TestSetDesc) s TestSetDesc=TestSetDesc_"+"_$lg(^dbo.BTTestSetD(TestSetDR),3)
	.....e  s TestSetDesc=$lg(^dbo.BTTestSetD(TestSetDR),3)
    ....s Labno = $lg(RPVisitNumberData,2)
    ....s ReceiveDate = $lg(RPVisitNumberData,66)
    ....s ReceiveTime = $lg(RPVisitNumberData,67)
    ....s SpecimenDR=$lg(RPVisitNumberData,56),SpecimenDesc=""
    ....i $l(SpecimenDR) s SpecimenDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
    ....s ReportData=$g(^dbo.RPVisitNumberReportD(VisitNumberReportDR))
    ....s OrganismDR=$lg($g(^dbo.RPVisitNumberReportResultD(ReportResultDR)),4)
    ....i '$l(OrganismDR) q
    ....s OrganismData=$g(^dbo.BTOrganismD(OrganismDR))
    ....s OrganismName=$lg(OrganismData,3)
    ....s OrganismEName=$lg(OrganismData,4)
	....s num=0
    ....s AntibioticsDR="" f  s AntibioticsDR=$o(^dbo.RPVisitNumberReportResSenI("IndexAntibiocs",ReportResultDR, AntibioticsDR)) q:AntibioticsDR=""  d
    .....s SenDR="" f  s SenDR=$o(^dbo.RPVisitNumberReportResSenI("IndexAntibiocs",ReportResultDR, AntibioticsDR,SenDR)) q:SenDR=""  d
    ......s SensitivityDR=$lg($g(^dbo.RPVisitNumberReportResSenD(SenDR)),6)
    ......i '$l(SensitivityDR) q
    ......s SensitivityData=$g(^dbo.BTSensitivityD(SensitivityDR))
    ......s SensitivityCode=$lg(SensitivityData,2)
    ......s SensitivityName=$lg(SensitivityData,3)
    ......s AntibioticsData=$g(^dbo.BTAntibioticsD(AntibioticsDR))
    ......s AntibioticsCode=$lg(AntibioticsData,2)
    ......s AntibioticsName=$lg(AntibioticsData,3)
    ......s WCode=$lg(AntibioticsData,6)
    ......s num=num+1
	......//药敏记录rowid^序号^报告日期^样本号^^编码^细菌名[中文]^耐药机制^细菌名英文名^抗生素名^备注
	......//s list=VisitNumberReportDR_"||"_TestCodeDR_"||"_AntibioticsDR_"||"_SensitivityDR_"^"_num_"^"_AuthDate_"^"_Labno_"^^"_AntibioticsCode_"^"_OrganismName_"^"_SensitivityName_"^"_OrganismEName_"^"_AntibioticsName_"^^"_WCode_"^"_TestSetDesc_"^"_SpecimenDesc_"^"_ReceiveDate
	......s Data=$lb(VisitNumberReportDR,TestCodeDR,AntibioticsDR,SensitivityDR,num,AuthDate,Labno,AntibioticsCode,OrganismName,SensitivityName,OrganismEName,AntibioticsName,WCode,TestSetDesc,SpecimenDesc,ReceiveDate)
	......d Output
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
Output	
	Set ColFields="VisitNumberReportDR,TestCodeDR,AntibioticsDR,SensitivityDR,num,AuthDate,Labno,AntibioticsCode,OrganismName,SensitivityName,OrganismEName,AntibioticsName,WCode,TestSetDesc,SpecimenDesc,ReceiveDate"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryAntResByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntResByAdmExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAntResByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntResByAdmExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      huhm 
/// CreateDate：   2012-4-13
/// Description:： 根据就诊号,化验项目,申请日期查询对照码结果
/// Table：         EP_VisitTestSetData
/// Input：         就诊号,化验项目对照码,申请开始日期,申请结束日期
/// Output：        结果类型(0:未申请,1:未出结果,2:结果列表),项目代码,项目名称,缩写,结果,异常标志,单位,范围值,结果说明,检测方法,危急值标志(W:危急值)
/// Return：无        
/// Others：无  
ClassMethod AddAdmIndex(labno As %String, ver As %String) As %String
{
	n (labno,ver)
	s labno=$g(labno),ver=$g(ver)
	i ver="63" q 0
	i '$l(labno) q 100
	i '$d(^TEPI(labno)) q 100
    s AdmStr=$p(^TEPI(labno),"\",37)
    s Num1=$p(AdmStr,",",1),Num2=$p(AdmStr,",",2)
    i $l(Num1),$l(Num2) q 0
	s OrdId=$o(^OEORD(0,"EpisNo",labno,""))
	i '$l(OrdId) q 100
	s AdmDr=$p(^OEORD(OrdId),"^",1)
	i '$l(AdmDr) q 100
	s AdmNo=$p($g(^PAADM(AdmDr)),"^",81)
	i '$l(AdmNo) q 100
	s AdmStr=AdmNo_","_AdmDr
	///&sql(update lab.EP_VisitNumber Set EPVIS_Hospital_EpisodeUR_Number=:AdmStr where EPVIS_RowId=:labno)
	q SQLCODE
}

}
