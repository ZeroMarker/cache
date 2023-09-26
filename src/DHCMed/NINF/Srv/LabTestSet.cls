/// 名称: DHCMed.NINF.Srv.LabTestSet
/// 描述: 检验系统结果 对外接口
/// 编写者：zhufei
/// 编写日期: 2012-08-07
Class DHCMed.NINF.Srv.LabTestSet Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-10-31
/// Description:  根据就诊号取检验报告【检验信息】接口
/// Table：       
/// Input：       EpisodeID 就诊号
/// Return：      返回%List
/// w ##class(DHCMed.NINF.Srv.LabTestSet).GetLabResults(EpisodeID)
ClassMethod GetLabResults(aEpisodeID As %String) As %ListOfObjects
{
	New (aEpisodeID)
	Set return=##class(%ListOfObjects).%New()
	Quit:(aEpisodeID="") return
	
	Set LabOEItemType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfLabOEItemType","")
	
	//update by zf 20160308 数据池相关程序修改(检验)
 	Set arrRec=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByAdm(aEpisodeID,"","",LabOEItemType,"","")
	Set TSRepCount=arrRec.Count()
	For indTSRep=1:1:TSRepCount {
		Set objTSReport=arrRec.GetAt(indTSRep)
		Continue:'$IsObject(objTSReport)
		Set SubmissionDate=objTSReport.SubmissionDate
		Set SpecimenCode=objTSReport.SpecimenCode
		Set SpecimenDesc=objTSReport.SpecimenDesc
		Set TestSetRow=objTSReport.TestSetRow
		
		Set objXLab=##Class(DHCMed.NINF.Srv.InfReportLab).%New()
		If objXLab'="" Do objXLab.%Close()
		
	 	Set objXLab.Specimen=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(SpecimenCode_"^"_SpecimenDesc)  //标本
		Set objXLab.SubmissionDate=SubmissionDate        //送检日期
		
		If TestSetRow'="" {
			Set TSResCount=objRec.TestData.Count()
			For indTSRes=1:1:TSResCount {
				Set objTSResult=objRec.TestData.GetAt(indTSRes)
				Continue:'$IsObject(objTSResult)
				
				Set DataFormat=objTSResult.DataFormat
				Continue:DataFormat'="V"
				Set Result=objTSResult.DataText
				Continue:Result=""
				Set TestCode=objTSResult.TestCode
				Set Antibiotics=objTSResult.Antibiotics
				
				If (((Result["无")&&(Result["生长"))
					||((Result["未")&&(Result["出"))
					||((Result["未")&&(Result["生长"))
					||(Result["正常菌群"))
				{
					//无菌生长,未检出致病菌,未检查出菌,无细菌生长,无致病菌生长等
					Continue
				}
				
				Set objXLabPy=##Class(DHCMed.NINF.Srv.InfReportLabPy).%New()
				If objXLabPy'="" Do objXLabPy.%Close()
				Set objXLabPy.PathogenyID=""
				Set objXLabPy.PathogenyDesc=Result
				Set objXLabPy.PathogenyDesc1=""
				
				For indS=1:1:$l(Antibiotics,$c(1)) {
					Set tSen=$p(Antibiotics,$c(1),indS)
					Continue:tSen=""
					Set AntiCode=$p(Antibiotics,$c(2),1)
					Set AntiDesc=$p(Antibiotics,$c(2),2)
					Set SenTestCode=$p(Antibiotics,$c(2),3)
					Set SenTestDesc=$p(Antibiotics,$c(2),4)
					Continue:(AntiDesc="")||(SenTestDesc="")
					
					Set objXLabPyAnti=##Class(DHCMed.NINF.Srv.InfReportLabPyAnti).%New()
					Quit:'$IsObject(objXLabPyAnti)
					Set objXLabPyAnti.AntibioticsID=AntiCode
					Set objXLabPyAnti.AntibioticsDesc=AntiDesc
					Set objXLabPyAnti.AntibioticsDesc1=""
					Set objXLabPyAnti.SenTestRst=##class(DHCMed.NINF.Srv.Dictionary).GetDicObj(SenTestCode_"^"_SenTestDesc)
					If objXLabPyAnti'="" Do objXLabPyAnti.%Close()
					
					//Do $System.OBJ.Dump(objXLabPy)
					Do objXLabPy.DrugSenTest.Insert(objXLabPyAnti)
				}
				//Do $System.OBJ.Dump(objXLabPy)
				Do objXLab.TestResults.Insert(objXLabPy)
			}
		}
		//Do $System.OBJ.Dump(objXLab)
		Do return.Insert(objXLab)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-08-07
/// Description:  根据就诊号取【送检结果】接口
/// Table：       
/// Input:        EpisodeID 就诊号
/// do ##class(%ResultSet).RunQuery("DHCMed.NINF.Srv.LabTestSet","QryTestSetData","1")
Query QryTestSetData(aEpisodeID As %String) As %Query(ROWSPEC = "ArcimID:%String,ArcimDesc:%String,SpecimenID:%String,SpecimenDesc:%String,InfectionPosID:%String,InfectionPosDesc:%String,SubmissionDate:%String,AssayMethodID:%String,AssayMethodDesc:%String,PathogenTestID:%String,PathogenTestDesc:%String,TestResultValues:%String,TestResultDescs:%String")
{
}

ClassMethod QryTestSetDataExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="") $$$OK
	
	Set LabOEItemType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfLabOEItemType","")
	
	//update by zf 20160308 数据池相关程序修改(检验)
 	Set arrRec=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByAdm(aEpisodeID,"","",LabOEItemType,"","")
	Set TSRepCount=arrRec.Count()
	For indTSRep=1:1:TSRepCount {
		Set objTSReport=arrRec.GetAt(indTSRep)
		Continue:'$IsObject(objTSReport)
		Set TestSetRow=objTSReport.TestSetRow
		Continue:TestSetRow=""
		Set ArcimCode=objTSReport.OEItemCode
		Set ArcimDesc=objTSReport.OEItemDesc
		Set tArcimCode=##Class(DHCMed.SSService.CommonCls).ALPHAUP(ArcimCode)
		Set ArcimID=$o(^ARCIM(0,"Code",tArcimCode,0))
		Set:ArcimID'="" ArcimID=ArcimID_"||"_1
		Set SpecimenCode=objTSReport.SpecimenCode
		Set SpecimenDesc=objTSReport.SpecimenDesc
		Set SpecimenID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfSpecimen",SpecimenDesc)
		Set:SpecimenID="" SpecimenDesc="*"_SpecimenDesc
		Set SubmissionDate=objTSReport.SubmissionDate
		
		Set (InfectionPosID,InfectionPosDesc,AssayMethodID,AssayMethodDesc)=""
		Set (PathogenTestID,PathogenTestDesc,TestResultValues,TestResultDescs)=""
		
		//检测方法（镜检、培养、血清学）
		Set AssayMethodDesc=objTSReport.AssayMethod
		Set AssayMethodID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfAssayMethod",AssayMethodDesc)
		Set:AssayMethodID="" AssayMethodDesc="*"_AssayMethodDesc
		
		Set TSResCount=objRec.TestData.Count()
		For indTSRes=1:1:TSResCount {
			Set objTSResult=objRec.TestData.GetAt(indTSRes)
			Continue:'$IsObject(objTSResult)
			
			Set DataFormat=objTSResult.DataFormat
			Continue:DataFormat'="V"
			Set Result=objTSResult.DataText
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
			
			For indS=1:1:$l(Antibiotics,$c(1)) {
				Set tSen=$p(Antibiotics,$c(1),indS)
				Continue:tSen=""
				Set AntiCode=$p(Antibiotics,$c(2),1)
				Set AntiDesc=$p(Antibiotics,$c(2),2)
				Set SenTestCode=$p(Antibiotics,$c(2),3)
				Set SenTestDesc=$p(Antibiotics,$c(2),4)
				Continue:(AntiDesc="")||(SenTestDesc="")
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
		
		Set Data=$lb(ArcimID,ArcimDesc,SpecimenID,SpecimenDesc,InfectionPosID,InfectionPosDesc,SubmissionDate)
		Set Data=Data_$lb(AssayMethodID,AssayMethodDesc,PathogenTestID,PathogenTestDesc,TestResultValues,TestResultDescs)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryTestSetDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestSetDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTestSetDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestSetDataExecute ]
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
/// CreatDate：   2013-01-23
/// Description:  根据检验号取检验报告【检验信息】接口
/// Table：       
/// Input：       TestSetRow 检验号
/// Return：      返回%List
/// w ##class(DHCMed.NINF.Srv.LabTestSet).GetLabRstByTS("35||B003||1")
ClassMethod GetLabRstByTS(aTestSetRow As %String) As DHCMed.NINF.Srv.InfReportLab
{
	New (aTestSetRow)
	Set return=""
	Quit:(aTestSetRow="") return
	
	//update by zf 20160308 数据池相关程序修改(检验)
	Set objTSReport=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByID(aTestSetRow)
	Quit:'$IsObject(objTSReport) return
	Set TestSetRow=objTSReport.TestSetRow
	Quit:TestSetRow="" return
	Set ArcimCode=objTSReport.OEItemCode
	Set ArcimDesc=objTSReport.OEItemDesc
	Set SubmissionDate=objTSReport.SubmissionDate
	Set SpecimenCode=objTSReport.SpecimenCode
	Set SpecimenDesc=objTSReport.SpecimenDesc
	Set SpecimenID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfSpecimen",SpecimenDesc)
	
	//检测方法（镜检、培养、血清学）
	Set AssayMethodDesc=objTSReport.AssayMethod
	Set AssayMethodID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfAssayMethod",AssayMethodDesc)
	
	Set objXLab=##Class(DHCMed.NINF.Srv.InfReportLab).%New()
	If objXLab'="" Do objXLab.%Close()
	
 	Set objXLab.Specimen=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(SpecimenCode_"^"_SpecimenDesc)  //标本
	Set objXLab.SubmissionDate=SubmissionDate        //送检日期
	Set objXLab.AssayMethod=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(AssayMethodID_"^"_AssayMethodDesc)  //病原体检验结果
	
	Set (PathogenTestID,PathogenTestDesc)=""
	
	Set TSResCount=objTSReport.TestData.Count()
	For indTSRes=1:1:TSResCount {
		Set objTSResult=objTSReport.TestData.GetAt(indTSRes)
		Continue:'$IsObject(objTSResult)
		
		Set DataFormat=objTSResult.DataFormat
		Continue:DataFormat'="V"
		Set Result=objTSResult.DataText
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
		
		Set objXLabPy=##Class(DHCMed.NINF.Srv.InfReportLabPy).%New()
		If objXLabPy'="" Do objXLabPy.%Close()
		Set objXLabPy.PathogenyID=""
		Set objXLabPy.PathogenyDesc=Result
		Set objXLabPy.PathogenyDesc1=""
		
		For indS=1:1:$l(Antibiotics,$c(1)) {
			Set tSen=$p(Antibiotics,$c(1),indS)
			Continue:tSen=""
			Set AntiCode=$p(Antibiotics,$c(2),1)
			Set AntiDesc=$p(Antibiotics,$c(2),2)
			Set SenTestCode=$p(Antibiotics,$c(2),3)
			Set SenTestDesc=$p(Antibiotics,$c(2),4)
			Continue:(AntiDesc="")||(SenTestDesc="")
			Set SenTestID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfSenTestRst",SenTestDesc)
			
			Set objXLabPyAnti=##Class(DHCMed.NINF.Srv.InfReportLabPyAnti).%New()
			If objXLabPyAnti'="" Do objXLabPyAnti.%Close()
			Set objXLabPyAnti.AntibioticsID=AntiCode
			Set objXLabPyAnti.AntibioticsDesc=AntiDesc
			Set objXLabPyAnti.AntibioticsDesc1=""
			Set objXLabPyAnti.SenTestRst=##class(DHCMed.NINF.Srv.Dictionary).GetDicObj(SenTestID_"^"_SenTestDesc)
			
			//Do $System.OBJ.Dump(objXLabPy)
			Do objXLabPy.DrugSenTest.Insert(objXLabPyAnti)
		}
		//Do $System.OBJ.Dump(objXLabPy)
		Do objXLab.TestResults.Insert(objXLabPy)
	}
	
	If (PathogenTestDesc="") {
		Set PathogenTestDesc="无"
		//Set PathogenTestDesc="未回"
	}
	Set PathogenTestID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfPathogenTest",PathogenTestDesc)
	Set objXLab.PathogenTest=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(PathogenTestID_"^"_PathogenTestDesc)  //病原体检验结果
	
	//Do $System.OBJ.Dump(objXLab)
	Set return=objXLab
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-05-03
/// Description:  取【检验标本】接口
/// Table：       
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINF.Srv.LabTestSet","QrySpecimenDic","")
Query QrySpecimenDic(aAddItem As %String = "", aSSHospCode As %String) As %Query(ROWSPEC = "SpecCode:%String,SpecDesc:%String") [ SqlProc ]
{
}

ClassMethod QrySpecimenDicExecute(ByRef qHandle As %Binary, aAddItem As %String, aSSHospCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If aAddItem'="" {
		Set SpecCode=$p(aAddItem,"^",1)
		Set SpecDesc=$p(aAddItem,"^",2)
		Set ^CacheTemp(repid,ind)=$lb(SpecCode,SpecDesc)
		Set ind=ind+1
	}
	
	//update by zf 20160308 数据池相关程序修改(检验)
	Set xHospCode=""
	For {
		Set xHospCode=$o(^DHCMed.DC.LIS.BTSpecimenI("IndexCName",xHospCode))
		Quit:xHospCode=""
		Continue:'$d(^DHCMed.DC.BTHospitalI("IndexSCode",xHospCode," "_$zcvt(aSSHospCode,"U")))
		
		Set xDesc=""
		For {
			Set xDesc=$o(^DHCMed.DC.LIS.BTSpecimenI("IndexCName",xHospCode,xDesc))
			Quit:xDesc=""
			Set xID=0
			For {
				Set xID=$o(^DHCMed.DC.LIS.BTSpecimenI("IndexCName",xHospCode,xDesc,xID))
				Quit:xID=""
				Set obj=##class(DHCMed.DC.LIS.BTSpecimen).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:obj.Active'=1
				Set SpecCode=obj.Code
				Set SpecDesc=obj.CName
				Set Data=$lb(SpecCode,SpecDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QrySpecimenDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySpecimenDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySpecimenDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySpecimenDicExecute ]
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
/// CreatDate：   2013-05-03
/// Description:  取【检验细菌】接口
/// Table：       
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINF.Srv.LabTestSet","QryBugDic","")
Query QryBugDic(aAddItem As %String = "", aSSHospCode As %String) As %Query(ROWSPEC = "PyCode:%String,PyDesc:%String") [ SqlProc ]
{
}

ClassMethod QryBugDicExecute(ByRef qHandle As %Binary, aAddItem As %String, aSSHospCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If aAddItem'="" {
		Set SpecCode=$p(aAddItem,"^",1)
		Set SpecDesc=$p(aAddItem,"^",2)
		Set ^CacheTemp(repid,ind)=$lb(SpecCode,SpecDesc)
		Set ind=ind+1
	}
	
	//update by zf 20160308 数据池相关程序修改(检验)
	Set xHospCode=""
	For {
		Set xHospCode=$o(^DHCMed.DC.LIS.BTOrganismI("IndexCName",xHospCode))
		Quit:xHospCode=""
		Continue:'$d(^DHCMed.DC.BTHospitalI("IndexSCode",xHospCode," "_$zcvt(aSSHospCode,"U")))
		
		Set xDesc=""
		For {
			Set xDesc=$o(^DHCMed.DC.LIS.BTOrganismI("IndexCName",xHospCode,xDesc))
			Quit:xDesc=""
			Set xID=0
			For {
				Set xID=$o(^DHCMed.DC.LIS.BTOrganismI("IndexCName",xHospCode,xDesc,xID))
				Quit:xID=""
				Set obj=##class(DHCMed.DC.LIS.BTOrganism).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:obj.Active'=1
				Set BugCode=obj.Code
				Set BugDesc=obj.CName
				Set Data=$lb(BugCode,BugDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryBugDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBugDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBugDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBugDicExecute ]
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

Storage Default
{
<Data name="LabTestSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Srv.LabTestSetD</DataLocation>
<DefaultData>LabTestSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Srv.LabTestSetD</IdLocation>
<IndexLocation>^DHCMed.NINF.Srv.LabTestSetI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Srv.LabTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
