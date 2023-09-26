/// 名称: DHCMed.NINFService.Rep.InfReportLab
/// 描述: 医院感染报告 病原学检验
/// 编写者：zhufei
/// 编写日期: 2011-06-21
Class DHCMed.NINFService.Rep.InfReportLab Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 病原学检验
/// Table：       DHCMed.NINF.Rep.InfReportLab
/// Input：       DHCMed.NINF.Rep.InfReportLab.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportLab).GetSubRec(1)
ClassMethod GetSubRec(aRepID As %String) As DHCMed.NINF.Rep.InfReportLab
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	
	Set SubID=0
	For {
		Set SubID=$o(^DHCMed.NINF("InfRep",aRepID,"Lab",SubID))
		Quit:SubID=""
		Set return=return_$c(1)_aRepID_"||"_SubID
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 病原学检验
/// Table：       DHCMed.NINF.Rep.InfReportLab
/// Input：       DHCMed.NINF.Rep.InfReportLab.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportLab).GetSubObj(1)
ClassMethod GetSubObj(aId As %String) As DHCMed.NINF.Rep.InfReportLab
{
	New (aId)
	Set return=""
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReportLab).GetObjById(aId)
	If $IsObject(obj) {
		Set return=obj
	} Else {
		Set obj=##Class(DHCMed.NINF.Rep.InfReportLab).%New()
		If obj'="" Do obj.%Close()
		set return=obj
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-25
/// Description:  取医院感染报告 病原学检验 病原学+药敏试验
///               主要处理"List"类型数据
/// Table：       DHCMed.NINF.Rep.InfReportLab
/// Input：       DHCMed.NINF.Rep.InfReportLab.ID
/// Return：      返回String
/// w ##class(DHCMed.NINFService.Rep.InfReportLab).GetFieldById("19||1","TestResults")
ClassMethod GetFieldById(aId As %String, aFieldName As %String) As %String
{
	New (aId,aFieldName)
	Set return=""
	Quit:(aId="")||(aFieldName="") return
	
	Set $ZT="GetFieldByIdErr"
	
	Set obj=##class(DHCMed.NINF.Rep.InfReportLab).GetObjById(aId)
	Quit:'$IsObject(obj) return
	
	If aFieldName="TestResults" {
		
		Set oeTestResults=""
		Set DataSource=obj.DataSource
		If DataSource["OEITEM:" {
			Set OEItemID=$p(DataSource,"OEITEM:",2)
			Set oeTestResults=..getTestResults(OEItemID)
		}
		
		Set listPathogeny=""
		For indPy=1:1:obj.TestResults.Count() {
			Set objPy=obj.TestResults.GetAt(indPy)
			Continue:'$IsObject(objPy)
			
			Set PathogenyID=objPy.PathogenyID
			Set PathogenyDesc=objPy.PathogenyDesc
			Continue:PathogenyDesc=""
			Set listPathogeny=listPathogeny_$lb(PathogenyDesc)
			Set DrugSenTest=""
			
			//检验报告中药敏试验结果
			Set listAntibiotics=""
			If oeTestResults'="" {
				For indOeTst=1:1:$l(oeTestResults,$c(1)) {
					Set oeTestResult=$p(oeTestResults,$c(1),indOeTst)
					Continue:oeTestResult=""
					Set oePathogenyID=$p(oeTestResult,$c(2),1)
					Set oePathogenyDesc=$p(oeTestResult,$c(2),2)
					Set oeDrugSenTest=$p(oeTestResult,$c(2),3)
					Continue:oePathogenyDesc=""
					Continue:oePathogenyDesc'=PathogenyDesc
					Continue:oeDrugSenTest=""
					
					For indOeAnti=1:1:$l(oeDrugSenTest,$c(3)) {
						Set oeDrugSenTestStr=$p(oeDrugSenTest,$c(3),indOeAnti)
						Continue:oeDrugSenTestStr=""
						Set oeAntibioticsID=$p(oeDrugSenTestStr,$c(4),1)
						Set oeAntibioticsDesc=$p(oeDrugSenTestStr,$c(4),2)
						Continue:oeAntibioticsDesc=""
						Set listAntibiotics=listAntibiotics_$lb(oeAntibioticsDesc)
						Set oeSenTestRst=$p(oeDrugSenTestStr,$c(4),3)
						Set oeSenTestRstDesc=$p(oeDrugSenTestStr,$c(4),4)
						Continue:oeSenTestRstDesc=""
						
						Set DrugSenTest=DrugSenTest_$c(3)_oeAntibioticsID_$c(4)_oeAntibioticsDesc_$c(4)_oeSenTestRst_$c(4)_oeSenTestRstDesc
					}
				}
			}
			//院感报告中药敏试验结果
			For indAnti=1:1:objPy.DrugSenTest.Count() {
				Set objAnti=objPy.DrugSenTest.GetAt(indAnti)
				Continue:'$IsObject(objAnti)
				Set AntibioticsID=objAnti.AntibioticsID
				Set AntibioticsDesc=objAnti.AntibioticsDesc
				Continue:AntibioticsDesc=""
				Continue:$listfind(listAntibiotics,AntibioticsDesc)>0
				Set SenTestRst="",SenTestRstDesc=""
				If $IsObject(objAnti.SenTestRst) {
					Set SenTestRst=objAnti.SenTestRst.%Id()
					Set SenTestRstDesc=objAnti.SenTestRst.Description
				}
				Set DrugSenTest=DrugSenTest_$c(3)_AntibioticsID_$c(4)_AntibioticsDesc_$c(4)_SenTestRst_$c(4)_SenTestRstDesc
			}
			
			Set:DrugSenTest'="" DrugSenTest=$e(DrugSenTest,2,$l(DrugSenTest))
			
			Set return=return_$c(1)_PathogenyID_$c(2)_PathogenyDesc_$c(2)_DrugSenTest
		}
		//院感报告中没有，检验报告中存在数据取值
		If oeTestResults'="" {
			For indOeTst=1:1:$l(oeTestResults,$c(1)) {
				Set oeTestResult=$p(oeTestResults,$c(1),indOeTst)
				Continue:oeTestResult=""
				Set oePathogenyID=$p(oeTestResult,$c(2),1)
				Set oePathogenyDesc=$p(oeTestResult,$c(2),2)
				Set oeDrugSenTest=$p(oeTestResult,$c(2),3)
				Continue:oePathogenyDesc=""
				Continue:$listfind(listPathogeny,oePathogenyDesc)>0  //报告中重复的数据不再重复取值
				Continue:oeDrugSenTest=""
				
				Set DrugSenTest=""
				For indOeAnti=1:1:$l(oeDrugSenTest,$c(3)) {
					Set oeDrugSenTestStr=$p(oeDrugSenTest,$c(3),indOeAnti)
					Continue:oeDrugSenTestStr=""
					Set oeAntibioticsID=$p(oeDrugSenTestStr,$c(4),1)
					Set oeAntibioticsDesc=$p(oeDrugSenTestStr,$c(4),2)
					Continue:oeAntibioticsDesc=""
					Set oeSenTestRst=$p(oeDrugSenTestStr,$c(4),3)
					Set oeSenTestRstDesc=$p(oeDrugSenTestStr,$c(4),4)
					Continue:oeSenTestRstDesc=""
					
					Set DrugSenTest=DrugSenTest_$c(3)_oeAntibioticsID_$c(4)_oeAntibioticsDesc_$c(4)_oeSenTestRst_$c(4)_oeSenTestRstDesc
				}
				Set:DrugSenTest'="" DrugSenTest=$e(DrugSenTest,2,$l(DrugSenTest))
				
				Set return=return_$c(1)_oePathogenyID_$c(2)_oePathogenyDesc_$c(2)_DrugSenTest
			}
		}
		Set:return'="" return=$e(return,2,$l(return))
	} Else {
		Set valExpress="Set return=obj."_aFieldName
		X valExpress
	}
	
	Quit return
	
GetFieldByIdErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  删除医院感染报告 病原学检验
/// Table：       DHCMed.NINF.Rep.InfReportLab
/// Input：       DHCMed.NINF.Rep.InfReport.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportLab).DelSubRec(1)
ClassMethod DelSubRec(aId As %String) As %String
{
	New (aId)
	Set return=##Class(DHCMed.NINF.Rep.InfReportLab).DeleteById(aId)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  保存医院感染报告 病原学检验
/// Table：       DHCMed.NINF.Rep.InfReportLab
/// Input：       
/// Return：      返回ID
/// w ##class(DHCMed.NINFService.Rep.InfReportLab).SaveSubRec("1"_$c(1,1,1)_"9734||1"_$c(1)_"全血细胞分析(18项以上指标)(血常规)(门/急)"_$c(1)_"5962"_$c(1,1)_"2013-01-08"_$c(1)_"5988"_$c(1)_"5992"_$c(1),$c(1)_","_$c(2)_","_$c(3)_","_$c(4)_","_$c(5))
ClassMethod SaveSubRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set $ZT="SaveSubRecErr"
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Set CHR3=$p(aSeparate,",",3)
	Set CHR4=$p(aSeparate,",",4)
	Set CHR5=$p(aSeparate,",",5)
	Quit:(CHR1="")||(CHR2="")||(CHR3="")||(CHR4="")||(CHR5="") return
	
	Set RepID=$p(aInput,CHR1,1)
	Quit:RepID="" return
	Quit:'$d(^DHCMed.NINF("InfRep",RepID)) return
	
	Set ArcimDesc=$p(aInput,CHR1,5)
	Quit:ArcimDesc="" return
	
	Set SubmissionDate=$p(aInput,CHR1,8)
	;Set:SubmissionDate["-" SubmissionDate=$zdh(SubmissionDate,3)
	Set:SubmissionDate'="" SubmissionDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(SubmissionDate)
	
	Set TestResults="",tmpTestRst=$p(aInput,CHR1,11)
	For indTestRst=1:1:$l(tmpTestRst,CHR2) {
		Set TestRstRec=$p(tmpTestRst,CHR2,indTestRst)
		Continue:TestRstRec=""
		
		Set DrugSenTest="",tmpSenTest=$p(TestRstRec,CHR3,3)
		For indSenTest=1:1:$l(tmpSenTest,CHR4) {
			Set SenTestRec=$p(tmpSenTest,CHR4,indSenTest)
			Continue:SenTestRec=""
			
			Set DrugSenTest=DrugSenTest_CHR4_SenTestRec
		}
		Set:DrugSenTest'="" DrugSenTest=$e(DrugSenTest,2,$l(DrugSenTest))
		Set $p(TestRstRec,CHR3,3)=DrugSenTest
		
		Set TestResults=TestResults_CHR2_TestRstRec
	}
	Set:TestResults'="" TestResults=$e(TestResults,2,$l(TestResults))
	
	Set $p(aInput,CHR1,8)=SubmissionDate
	Set $p(aInput,CHR1,11)=TestResults
	
	Set return=##Class(DHCMed.NINF.Rep.InfReportLab).Update(aInput,CHR1_","_CHR2_","_CHR3_","_CHR4_","_CHR5)
	Quit return
	
SaveSubRecErr
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  查询病原学检验信息
/// Table：       DHCMed.NINF.Rep.InfReportLab
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.InfReportLab","QrySubRec","","11754111","LIS")
Query QrySubRec(aReportID As %String, aEpisodeID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,ArcimID:%String,ArcimDesc:%String,SpecimenID:%String,SpecimenDesc:%String,InfectionPosID:%String,InfectionPosDesc:%String,SubmissionDate:%String,AssayMethodID:%String,AssayMethodDesc:%String,PathogenTestID:%String,PathogenTestDesc:%String,TestResultValues:%String,TestResultDescs:%String,DataSource:%String") [ SqlProc ]
{
}

ClassMethod QrySubRecExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aReportID="")&&(aEpisodeID="") $$$OK
	
	If aReportID'="" {
		Set xSubID=0
		For {
			Set xSubID=$o(^DHCMed.NINF("InfRep",aReportID,"Lab",xSubID))
			Quit:xSubID=""
			
			Set objSub=##class(DHCMed.NINF.Rep.InfReportLab).GetObjById(aReportID_"||"_xSubID)
			Continue:'$IsObject(objSub)
			
			Set (ArcimID,ArcimDesc,SpecimenID,SpecimenDesc,InfectionPosID,InfectionPosDesc,SubmissionDate)=""
			Set (AssayMethodID,AssayMethodDesc,PathogenTestID,PathogenTestDesc)=""
			Set (TestResultValues,TestResultDescs,DataSource)=""
			
			Set ArcimID=objSub.ArcimID
			Set ArcimDesc=objSub.ArcimDesc
			If $IsObject(objSub.Specimen) {
				Set SpecimenID=objSub.Specimen.%Id()
				Set SpecimenDesc=objSub.Specimen.Description
			}
			If $IsObject(objSub.InfectionPos) {
				Set InfectionPosID=objSub.InfectionPos.%Id()
				Set InfectionPosDesc=objSub.InfectionPos.IPDesc
			}
			Set SubmissionDate=objSub.SubmissionDate
			;Set:SubmissionDate'="" SubmissionDate=$zd(SubmissionDate,3)
			Set:SubmissionDate'="" SubmissionDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SubmissionDate)
			If $IsObject(objSub.AssayMethod) {
				Set AssayMethodID=objSub.AssayMethod.%Id()
				Set AssayMethodDesc=objSub.AssayMethod.Description
			}
			If $IsObject(objSub.PathogenTest) {
				Set PathogenTestID=objSub.PathogenTest.%Id()
				Set PathogenTestDesc=objSub.PathogenTest.Description
			}
			
			Set oeTestResults=""
			Set DataSource=objSub.DataSource
			If DataSource["OEITEM:" {
				Set OEItemID=$p(DataSource,"OEITEM:",2)
				Set oeTestResults=..getTestResults(OEItemID)
			}
			
			Set listPathogeny=""
			For indTestRst=1:1:objSub.TestResults.Count() {
				Set objTestRst=objSub.TestResults.GetAt(indTestRst)
				Continue:'$IsObject(objTestRst)
				Set PathogenyID=objTestRst.PathogenyID
				Set PathogenyDesc=objTestRst.PathogenyDesc
				Continue:PathogenyDesc=""
				Set listPathogeny=listPathogeny_$lb(PathogenyDesc)
				Set DrugSenTest=""
				
				Set listAntibiotics=""
				//检验报告中药敏试验结果
				If oeTestResults'="" {
					For indOeTst=1:1:$l(oeTestResults,$c(1)) {
						Set oeTestResult=$p(oeTestResults,$c(1),indOeTst)
						Continue:oeTestResult=""
						Set oePathogenyID=$p(oeTestResult,$c(2),1)
						Set oePathogenyDesc=$p(oeTestResult,$c(2),2)
						Set oeDrugSenTest=$p(oeTestResult,$c(2),3)
						Continue:oePathogenyDesc=""
						Continue:oePathogenyDesc'=PathogenyDesc
						Continue:oeDrugSenTest=""
						
						For indOeAnti=1:1:$l(oeDrugSenTest,$c(3)) {
							Set oeDrugSenTestStr=$p(oeDrugSenTest,$c(3),indOeAnti)
							Continue:oeDrugSenTestStr=""
							Set oeAntibioticsID=$p(oeDrugSenTestStr,$c(4),1)
							Set oeAntibioticsDesc=$p(oeDrugSenTestStr,$c(4),2)
							Continue:oeAntibioticsDesc=""
							Set listAntibiotics=listAntibiotics_$lb(oeAntibioticsDesc)
							Set oeSenTestRst=$p(oeDrugSenTestStr,$c(4),3)
							Set oeSenTestRstDesc=$p(oeDrugSenTestStr,$c(4),4)
							Continue:oeSenTestRstDesc=""
							
							Set DrugSenTest=DrugSenTest_$c(3)_oeAntibioticsID_$c(4)_oeAntibioticsDesc_$c(4)_oeSenTestRst_$c(4)_oeSenTestRstDesc
						}
					}
				}
				//院感报告中药敏试验结果
				For indSenTest=1:1:objTestRst.DrugSenTest.Count() {
					Set objSenTest=objTestRst.DrugSenTest.GetAt(indSenTest)
					Continue:'$IsObject(objSenTest)
					Set AntibioticsID=objSenTest.AntibioticsID
					Set AntibioticsDesc=objSenTest.AntibioticsDesc
					Continue:AntibioticsDesc=""
					Continue:$listfind(listAntibiotics,AntibioticsDesc)>0
					Set SenTestRstID="",SenTestRstDesc=""
					If $IsObject(objSenTest.SenTestRst) {
						Set SenTestRstID=objSenTest.SenTestRst.%Id()
						Set SenTestRstDesc=objSenTest.SenTestRst.Description
					}
					Set DrugSenTest=DrugSenTest_$c(3)_AntibioticsID_$c(4)_AntibioticsDesc_$c(4)_SenTestRstID_$c(4)_SenTestRstDesc
				}
				Set:DrugSenTest'="" DrugSenTest=$e(DrugSenTest,2,$l(DrugSenTest))
				
				Set TestResultValues=TestResultValues_$c(1)_PathogenyID_$c(2)_PathogenyDesc_$c(2)_DrugSenTest
				Set TestResultDescs=TestResultDescs_","_PathogenyDesc
			}
			//院感报告中没有，检验报告中存在数据取值
			If oeTestResults'="" {
				For indOeTst=1:1:$l(oeTestResults,$c(1)) {
					Set oeTestResult=$p(oeTestResults,$c(1),indOeTst)
					Continue:oeTestResult=""
					Set oePathogenyID=$p(oeTestResult,$c(2),1)
					Set oePathogenyDesc=$p(oeTestResult,$c(2),2)
					Set oeDrugSenTest=$p(oeTestResult,$c(2),3)
					Continue:oePathogenyDesc=""
					Continue:$listfind(listPathogeny,oePathogenyDesc)>0  //报告中重复的数据不再重复取值
					Continue:oeDrugSenTest=""
					
					Set DrugSenTest=""
					For indOeAnti=1:1:$l(oeDrugSenTest,$c(3)) {
						Set oeDrugSenTestStr=$p(oeDrugSenTest,$c(3),indOeAnti)
						Continue:oeDrugSenTestStr=""
						Set oeAntibioticsID=$p(oeDrugSenTestStr,$c(4),1)
						Set oeAntibioticsDesc=$p(oeDrugSenTestStr,$c(4),2)
						Continue:oeAntibioticsDesc=""
						Set oeSenTestRst=$p(oeDrugSenTestStr,$c(4),3)
						Set oeSenTestRstDesc=$p(oeDrugSenTestStr,$c(4),4)
						Continue:oeSenTestRstDesc=""
						
						Set DrugSenTest=DrugSenTest_$c(3)_oeAntibioticsID_$c(4)_oeAntibioticsDesc_$c(4)_oeSenTestRst_$c(4)_oeSenTestRstDesc
					}
					Set:DrugSenTest'="" DrugSenTest=$e(DrugSenTest,2,$l(DrugSenTest))
					
					Set TestResultValues=TestResultValues_$c(1)_oePathogenyID_$c(2)_oePathogenyDesc_$c(2)_DrugSenTest
					Set TestResultDescs=TestResultDescs_","_oePathogenyDesc
				}
			}
			Set:TestResultValues'="" TestResultValues=$e(TestResultValues,2,$l(TestResultValues))
			Set:TestResultDescs'="" TestResultDescs=$e(TestResultDescs,2,$l(TestResultDescs))
			
			Set Data=$lb(aReportID,xSubID)
			Set Data=Data_$lb(ArcimID,ArcimDesc,SpecimenID,SpecimenDesc,InfectionPosID,InfectionPosDesc,SubmissionDate)
			Set Data=Data_$lb(AssayMethodID,AssayMethodDesc,PathogenTestID,PathogenTestDesc)
			Set Data=Data_$lb(TestResultValues,TestResultDescs,DataSource)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} Else {
		Set LabOEItemType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfLabOEItemType","")
	 	
		//update by zf 20160308 数据池相关程序修改(检验)
	 	Set arrRec=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByAdm(aEpisodeID,"","",LabOEItemType,"","")
		Set TSRepCount=arrRec.Count()
		For indTSRep=1:1:TSRepCount {
			Set objTSReport=arrRec.GetAt(indTSRep)
			Continue:'$IsObject(objTSReport)
			Set TestSetRow=objTSReport.TestSetRow
			Continue:TestSetRow=""
			Set OEItemID=objTSReport.OEItemID
			Set ArcimCode=objTSReport.OEItemCode
			Set ArcimDesc=objTSReport.OEItemDesc
			Set tArcimCode=##Class(DHCMed.SSService.CommonCls).ALPHAUP(ArcimCode)
			Set ArcimID=$o(^ARCIM(0,"Code",tArcimCode,0))
			Set:ArcimID'="" ArcimID=ArcimID_"||"_1
			Set SpecimenCode=objTSReport.SpecimenCode
			Set SpecimenDesc=objTSReport.SpecimenDesc
			Set objTmp=##class(DHCMed.NINF.Srv.MKDicMapping).GetMappingData("InfDicSpecimen",SpecimenCode)
			If $IsObject(objTmp) {
				Set SpecimenDesc=objTmp.TargetDesc
			}
			Set SpecimenID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfSpecimen",SpecimenDesc)
			Set:SpecimenID="" SpecimenDesc="*"_SpecimenDesc
			Set SubmissionDate=objTSReport.SubmissionDate
			if SubmissionDate["-" {
				Set SubmissionDate=$zdh(SubmissionDate,3)
				Set SubmissionDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SubmissionDate)
			}
			
			Set (InfectionPosID,InfectionPosDesc,AssayMethodID,AssayMethodDesc)=""
			Set (PathogenTestID,PathogenTestDesc,TestResultValues,TestResultDescs)=""
			
			Set DataSource="OEITEM:"_OEItemID
			
			//检测方法（镜检、培养、血清学）
			Set AssayMethodDesc=objTSReport.AssayMethod
			Set AssayMethodID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfAssayMethod",AssayMethodDesc)
			Set:AssayMethodID="" AssayMethodDesc="*"_AssayMethodDesc
		
			Set TSResCount=objTSReport.TestData.Count()
			For indTSRes=1:1:TSResCount {
				Set objTSResult=objTSReport.TestData.GetAt(indTSRes)
				Continue:'$IsObject(objTSResult)
				
				Set DataFormat=objTSResult.DataFormat
				Continue:DataFormat'="V"
				Set Result=objTSResult.DataValue
				Continue:Result=""
				Set TestCode=objTSResult.TestCode
				Set Antibiotics=objTSResult.Antibiotics
				
				//细菌培养 阳性/阴性/无结果
				Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check0("LIS-PY",Result)
				If checkFlag'="" {
					Set PathogenTestDesc="阴性"
				} Else {
					Set PathogenTestDesc="阳性"
				}
				set DrugSenTestValues=""
				For indS=1:1:$l(Antibiotics,$c(1)) {
					Set tSen=$p(Antibiotics,$c(1),indS)
					Continue:tSen=""
					Set AntiCode=$p(tSen,$c(2),1)
					Set AntiDesc=$p(tSen,$c(2),2)
					Set SenTestCode=$p(tSen,$c(2),3)
					Set SenTestDesc=$p(tSen,$c(2),4)
					Continue:(AntiDesc="")||(SenTestDesc="")
					If SenTestDesc="" {
						Set objTmp=##class(DHCMed.NINF.Srv.MKDicMapping).GetMappingData("InfDicSenTestRst",SenTestCode)
						If $IsObject(objTmp) {
							Set SenTestDesc=objTmp.TargetDesc
						}
					}
					Set SenTestID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfSenTestRst",SenTestDesc)
					Set:SenTestID="" SenTestDesc="*"_SenTestDesc
					
					Set DrugSenTestValues=DrugSenTestValues_$c(3)_""_$c(4)_AntiDesc_$c(4)_SenTestID_$c(4)_SenTestDesc
				}
				Set:DrugSenTestValues'="" DrugSenTestValues=$e(DrugSenTestValues,2,$l(DrugSenTestValues))
				
				Set TestResultValues=TestResultValues_$c(1)_""_$c(2)_Result_$c(2)_DrugSenTestValues
				Set TestResultDescs=TestResultDescs_","_Result
			}
			Set:TestResultValues'="" TestResultValues=$e(TestResultValues,2,$l(TestResultValues))
			Set:TestResultDescs'="" TestResultDescs=$e(TestResultDescs,2,$l(TestResultDescs))
			
			If (TestResultDescs="")&&(PathogenTestDesc="") {
				Set PathogenTestDesc="无"
				//Set PathogenTestDesc="未回"
			}
			Set PathogenTestID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfPathogenTest",PathogenTestDesc)
			Set:PathogenTestID="" PathogenTestDesc="*"_PathogenTestDesc
			
			Set Data=$lb("","")
			Set Data=Data_$lb(ArcimID,ArcimDesc,SpecimenID,SpecimenDesc,InfectionPosID,InfectionPosDesc,SubmissionDate)
			Set Data=Data_$lb(AssayMethodID,AssayMethodDesc,PathogenTestID,PathogenTestDesc,TestResultValues,TestResultDescs,DataSource)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QrySubRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySubRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySubRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySubRecExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-08-10
/// Description:  检查是否病原学检验
/// Table：       
/// Input：       aEpisodeID  就诊号
/// Return：      return<=0:否  return>0:是
/// w ##class(DHCMed.NINFService.Rep.InfReportLab).IsCheckLab(21999302)
ClassMethod IsCheckLab(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0,Count=0
	Quit:aEpisodeID="" return
	
	Set rs=##Class(%ResultSet).%New("DHCMed.NINFService.Rep.InfReportLab:QrySubRec")
	Do rs.Execute("",aEpisodeID)
	While (rs.Next()){
		Set Count=Count+1
	}
	Do rs.Close()
	
	Set return=Count
	Quit return
}

/// 根据医嘱ID取值检验报告中的药敏结果
/// w ##class(DHCMed.NINFService.Rep.InfReportLab).getTestResults("14||6")
ClassMethod getTestResults(aOEItemID As %String) As %String
{
	New (aOEItemID)
	Set return=""
	Quit:aOEItemID="" return
	
	//update by zf 20160308 数据池相关程序修改(检验)
	Set TestSetRow=$p($g(^OEORD(+aOEItemID,"I",+$p(aOEItemID,"||",2),3)),"^",35) //检验结果ID
	Quit:TestSetRow="" return
	
	Set objTSReport=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByID(TestSetRow)
	Quit:'$IsObject(objTSReport) return
	Set TestSetRow=objTSReport.TestSetRow
	Quit:TestSetRow="" return
	
	Set TSResCount=objTSReport.TestData.Count()
	For indTSRes=1:1:TSResCount {
		Set objTSResult=objTSReport.TestData.GetAt(indTSRes)
		Continue:'$IsObject(objTSResult)
		
		Set DataFormat=objTSResult.DataFormat
		Continue:DataFormat'="V"
		Set Result=objTSResult.DataValue
		Continue:Result=""
		Set Antibiotics=objTSResult.Antibiotics
		
		Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check0("LIS-PY",Result)
		If checkFlag'="" {
			Continue  //非细菌培养结果
		}
		Set DrugSenTest=""
		For indS=1:1:$l(Antibiotics,$c(1)) {
			Set tSen=$p(Antibiotics,$c(1),indS)
			Continue:tSen=""
			Set AntiCode=$p(tSen,$c(2),1)
			Set AntiDesc=$p(tSen,$c(2),2)
			Set SenTestCode=$p(tSen,$c(2),3)
			Set SenTestDesc=$p(tSen,$c(2),4)
			Continue:(AntiDesc="")||(SenTestDesc="")
			Set SenTestID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfSenTestRst",SenTestDesc)
			
			Set DrugSenTest=DrugSenTest_$c(3)_AntiCode_$c(4)_AntiDesc_$c(4)_SenTestID_$c(4)_SenTestDesc
		}
		Set:DrugSenTest'="" DrugSenTest=$e(DrugSenTest,2,$l(DrugSenTest))
		
		Set return=return_$c(1)_""_$c(2)_Result_$c(2)_DrugSenTest
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

}
