/// 名称: DHCMed.CCService.Library.LabReport
/// 描述: 与检验结果相关的函数库
/// 编写者：zhufei
/// 编写日期: 2014-02-17
Class DHCMed.CCService.Library.LabReport Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Library.LabReport).Test()
ClassMethod Test()
{
	New
	Set %FromDate=$zdh("2016-04-25",3)
	Set %ToDate=+$h
	
	/*
	Set %EpisodeID=11233458
	Set %ExtraData=""
	Set %ErrorData=""
	
	Set return=..CheckIsBugs()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=342205
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckIsRB("金黄色葡萄球菌")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=342205
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckIsRB1("鲍曼不动杆菌")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=1031
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckIsMRB()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	*/
	
	Set %EpisodeID=1031
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckSubmisBugs()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	/*
	Set %EpisodeID=20389947
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckLabItem("检验||Z001|大于|10||||@淋巴细胞百分比")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=20389947
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckItemAbnor("检验||Z001|大于|10||||@淋巴细胞百分比")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	*/
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2014-02-17
/// Description:  检出微生物(包含细菌和真菌)
/// Table：       EP_VisitNumber,EP_VisitTestSet,EP_VisitTestSetData
/// Input：       
/// Return：      返回记录数  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.LabReport).CheckIsBugs()
ClassMethod CheckIsBugs(aBugAlias As %String = "") As %String
{
	New (aBugAlias,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set LabOECategory=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("CC-LabOECategory","")
	Quit:LabOECategory="" return
	
	Set $ZT="CheckIsBugsErr"
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,LabOECategory,"",1)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set DataCount=objRec.TestData.Count()
		For indData=1:1:DataCount {
			Set objData=objRec.TestData.GetAt(indData)
			Continue:'$IsObject(objData)
			Continue:objData.DataFormat'="V"
			
			If (aBugAlias'="") {
				Continue:(objData.DataValue'[aBugAlias)
			} Else {
				Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check0("LIS-PY",objData.DataValue)
				Continue:checkFlag'=""
			}
			
			Set Summary="【"_objRec.SpecimenDesc_"】"_objData.DataText_":"_objData.DataValue
			
			Set Count=Count+1
			Set TempData=""
			Set $p(TempData,$c(3),1)=Summary
			Set $p(TempData,$c(3),2)=objRec.ActDate
			Set $p(TempData,$c(3),3)=objRec.ActTime
			Set $p(TempData,$c(3),4)=objData.DataValue_"!!"_objData.DataText
			Set $p(TempData,$c(3),5)=objRec.RecordID_"||"_objData.TestCode
			Set $p(TempData,$c(3),6)=""_"/"_objRec.ActUser
			Set $p(TempData,$c(3),7)="PatientBanner=1&PatientID="_$p($g(^PAADM(+%EpisodeID)),"^",1)_"&TestSetRow="_objRec.TestSetRow_"&OrderID="_objRec.OEItemID
			Set $p(TempData,$c(3),8)=objRec.SubmissionDate
			Set $p(TempData,$c(3),9)=objRec.SubmissionTime
			Set $p(TempData,$c(3),10)="LAB"
			Set $p(TempData,$c(3),11)=""
			Set $p(TempData,$c(3),12)=""
			Set $p(TempData,$c(3),13)=""
			Set $p(TempData,$c(3),14)=""
			Set %ExtraData=%ExtraData_$lb(TempData)
		}
	}
	Set return=Count
	
	Quit return
	
CheckIsBugsErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-02-17
/// Description:  检出致病菌/检出耐药菌(包含细菌和真菌)
/// Table：       EP_VisitNumber,EP_VisitTestSet,EP_VisitTestSetData
/// Input：       
/// Return：      返回记录数  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.LabReport).CheckIsRB()
ClassMethod CheckIsRB(aBugAlias As %String = "") As %String
{
	New (aBugAlias,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set LabOECategory=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("CC-LabOECategory","")
	Quit:LabOECategory="" return
	
	Set $ZT="CheckIsRBErr"
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,LabOECategory,"",1)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set TestCodeList=""
		
		//通过药敏试验结果或ESBLs试验结果监测
		If (objRec.IsESBLs=1)||(objRec.IsRBugs=1) {
			Set DataCount=objRec.TestData.Count()
			For indData=1:1:DataCount {
				Set objData=objRec.TestData.GetAt(indData)
				Continue:'$IsObject(objData)
				
				//ESBLs阳性,检验报告下的菌都耐药
				//非ESBLs阳性,需要检查药敏试验（耐药）
				Continue:(objRec.IsESBLs'=1)&&(objData.IsRBugs'=1)
				
				Continue:$listfind(TestCodeList,objData.TestCode)>0
				Set TestCodeList=TestCodeList_$lb(objData.TestCode)
				Continue:objData.DataFormat'="V"
				If (aBugAlias'="") {
					Continue:(objData.DataValue'[aBugAlias)
				} Else {
					Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check0("LIS-PY",objData.DataValue)
					Continue:checkFlag'=""
				}
				
				Set RAntiList="",SAntiList=""
				Set AntiList=objData.Antibiotics
				For indAnti=1:1:$l(AntiList,$c(1)) {
					Set xAnti=$p(AntiList,$c(1),indAnti)
					Continue:xAnti=""
					
					Set AntiDesc=$p(xAnti,$c(2),2)
					Set SenFlag=$p(xAnti,$c(2),3)
					If SenFlag["R" {
						Set RAntiList=RAntiList_","_AntiDesc
					} Else {
						Set SAntiList=SAntiList_","_AntiDesc
					}
				}
				Set:RAntiList'="" RAntiList=$e(RAntiList,2,$l(RAntiList))
				Set:SAntiList'="" SAntiList=$e(SAntiList,2,$l(SAntiList))
				
				Set Summary="【"_objRec.SpecimenDesc_"】"_objData.DataValue
				Set:RAntiList'="" Summary=Summary_" (耐药:"_RAntiList_")"
				
				Set Count=Count+1
				Set TempData=""
				Set $p(TempData,$c(3),1)=Summary
				Set $p(TempData,$c(3),2)=objRec.ActDate
				Set $p(TempData,$c(3),3)=objRec.ActTime
				Set $p(TempData,$c(3),4)=objData.DataValue_"!!"_objData.DataText
				Set $p(TempData,$c(3),5)=objRec.RecordID_"||"_objData.TestCode
				Set $p(TempData,$c(3),6)=""_"/"_objRec.ActUser
				Set $p(TempData,$c(3),7)="PatientBanner=1&PatientID="_$p($g(^PAADM(+%EpisodeID)),"^",1)_"&TestSetRow="_objRec.TestSetRow_"&OrderID="_objRec.OEItemID
				Set $p(TempData,$c(3),8)=objRec.SubmissionDate
				Set $p(TempData,$c(3),9)=objRec.SubmissionTime
				Set $p(TempData,$c(3),10)="LAB"
				Set $p(TempData,$c(3),11)=""
				Set $p(TempData,$c(3),12)=""
				Set $p(TempData,$c(3),13)=""
				Set $p(TempData,$c(3),14)=""
				Set %ExtraData=%ExtraData_$lb(TempData)
			}
		}
	}
	Set return=Count
	
	Quit return
	
CheckIsRBErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-02-17
/// Description:  检出致病菌/检出耐药菌(包含细菌和真菌)
/// Table：       EP_VisitNumber,EP_VisitTestSet,EP_VisitTestSetData
/// Input：       
/// Return：      返回记录数  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.LabReport).CheckIsRB1()
ClassMethod CheckIsRB1(aBugAlias As %String = "") As %String
{
	New (aBugAlias,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set LabOECategory=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("CC-LabOECategory","")
	Quit:LabOECategory="" return
	
	Set $ZT="CheckIsRB1Err"
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,LabOECategory,"",1)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set ArcimDesc=objRec.OEItemDesc
		Continue:(ArcimDesc["支原体培养")||(ArcimDesc["衣原体培养")||(ArcimDesc["支原体检查")||(ArcimDesc["衣原体检查")
 	    
		Set TestCodeList=""
		
		//通过药敏试验结果或ESBLs试验结果监测
		If (objRec.IsESBLs=1)||(objRec.IsRBugs=1) {
			Set DataCount=objRec.TestData.Count()
			For indData=1:1:DataCount {
				Set objData=objRec.TestData.GetAt(indData)
				Continue:'$IsObject(objData)
				
				//ESBLs阳性,检验报告下的菌都耐药
				//非ESBLs阳性,需要检查药敏试验（耐药）
				Continue:(objRec.IsESBLs'=1)&&(objData.IsRBugs'=1)
				
				Continue:$listfind(TestCodeList,objData.TestCode)>0
				Set TestCodeList=TestCodeList_$lb(objData.TestCode)
				Continue:objData.DataFormat'="V"
				If (aBugAlias'="") {
					Continue:(objData.DataValue'[aBugAlias)
				} Else {
					Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check0("LIS-PY",objData.DataValue)
					Continue:checkFlag'=""
				}
				
				Set RAntiList="",SAntiList=""
				Set AntiList=objData.Antibiotics
				For indAnti=1:1:$l(AntiList,$c(1)) {
					Set xAnti=$p(AntiList,$c(1),indAnti)
					Continue:xAnti=""
					
					Set AntiDesc=$p(xAnti,$c(2),2)
					Set SenFlag=$p(xAnti,$c(2),3)
					If SenFlag["R" {
						Set RAntiList=RAntiList_","_AntiDesc
					} Else {
						Set SAntiList=SAntiList_","_AntiDesc
					}
				}
				Set:RAntiList'="" RAntiList=$e(RAntiList,2,$l(RAntiList))
				Set:SAntiList'="" SAntiList=$e(SAntiList,2,$l(SAntiList))
				
				Set Summary="【"_objRec.SpecimenDesc_"】"_objData.DataValue
				Set:RAntiList'="" Summary=Summary_" (耐药:"_RAntiList_")"
				
				Set Count=Count+1
				Set TempData=""
				Set $p(TempData,$c(3),1)=Summary
				Set $p(TempData,$c(3),2)=objRec.ActDate
				Set $p(TempData,$c(3),3)=objRec.ActTime
				Set $p(TempData,$c(3),4)=objData.DataValue_"!!"_objData.DataText
				Set $p(TempData,$c(3),5)=objRec.RecordID_"||"_objData.TestCode
				Set $p(TempData,$c(3),6)=""_"/"_objRec.ActUser
				Set $p(TempData,$c(3),7)="PatientBanner=1&PatientID="_$p($g(^PAADM(+%EpisodeID)),"^",1)_"&TestSetRow="_objRec.TestSetRow_"&OrderID="_objRec.OEItemID
				Set $p(TempData,$c(3),8)=objRec.SubmissionDate
				Set $p(TempData,$c(3),9)=objRec.SubmissionTime
				Set $p(TempData,$c(3),10)="LAB"
				Set $p(TempData,$c(3),11)=""
				Set $p(TempData,$c(3),12)=""
				Set $p(TempData,$c(3),13)=""
				Set $p(TempData,$c(3),14)=""
				Set %ExtraData=%ExtraData_$lb(TempData)
			}
		}
	}
	Set return=Count
	
	Quit return
	
CheckIsRB1Err
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-02-29
/// Description:  检出多重耐药菌
/// Table：       EP_VisitNumber,EP_VisitTestSet,EP_VisitTestSetData
/// Input：       
/// Return：      返回记录数  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.LabReport).CheckIsMRB()
ClassMethod CheckIsMRB(aMRBAlias As %String = "") As %String
{
	New (aMRBAlias,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set LabOECategory=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("CC-LabOECategory","")
	Quit:LabOECategory="" return
	
	Set $ZT="CheckIsMRBErr"
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,LabOECategory,"",1)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		Continue:(objRec.IsRBugs'=1)&&(objRec.IsESBLs'=1)  //耐药菌标志
		
		Set TestCodeList=""
		
		//通过药敏试验结果监测
		If (objRec.IsRBugs=1) {
			Set DataCount=objRec.TestData.Count()
			For indData=1:1:DataCount {
				Set objData=objRec.TestData.GetAt(indData)
				Continue:'$IsObject(objData)
				
				//重复数据过滤
				Continue:$listfind(TestCodeList,objData.TestCode)>0
				//耐药菌标志
				Continue:objData.IsRBugs'=1
				//细菌结果标志
				Continue:objData.DataFormat'="V"
				//细菌关键字过滤
				Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check0("LIS-PY",objData.DataValue)
				Continue:checkFlag'=""
				//多重耐药菌规则检测
				Set Pathogeny=objData.DataValue
				Set AntiList=""
				Set DrugSenTestStr=objData.Antibiotics
				For indAnti=1:1:$l(DrugSenTestStr,$c(1)) {
					Set xAnti=$p(DrugSenTestStr,$c(1),indAnti)
					Continue:xAnti=""
					Set AntiCode=$p(xAnti,$c(2),1)
					Continue:AntiCode=""
					Set AntiDesc=$p(xAnti,$c(2),2)
					Continue:AntiDesc=""
					Set SenFlag=$p(xAnti,$c(2),3)
					Continue:SenFlag'["R"
					Set AntiList=AntiList_$lb(AntiDesc)
				}
				
				Set MRBWords=##class(DHCMed.NINFService.Dic.MRBSrv).CheckIsMRB(Pathogeny,AntiList)
				Continue:MRBWords=""
				
				If (aMRBAlias'="") {
					Continue:(MRBWords'[aMRBAlias)
				}
				
				Set TestCodeList=TestCodeList_$lb(objData.TestCode)
				
				Set RAntiList="",SAntiList=""
				Set AntiList=objData.Antibiotics
				For indAnti=1:1:$l(AntiList,$c(1)) {
					Set xAnti=$p(AntiList,$c(1),indAnti)
					Continue:xAnti=""
					
					Set AntiDesc=$p(xAnti,$c(2),2)
					Set SenFlag=$p(xAnti,$c(2),3)
					If SenFlag["R" {
						Set RAntiList=RAntiList_","_AntiDesc
					} Else {
						Set SAntiList=SAntiList_","_AntiDesc
					}
				}
				
				Set:RAntiList'="" RAntiList=$e(RAntiList,2,$l(RAntiList))
				Set:SAntiList'="" SAntiList=$e(SAntiList,2,$l(SAntiList))
				
				Set Summary="【"_MRBWords_"】【"_objRec.SpecimenDesc_"】"_objData.DataValue
				Set:RAntiList'="" Summary=Summary_" (耐药:"_RAntiList_")"
				
				Set Count=Count+1
				Set TempData=""
				Set $p(TempData,$c(3),1)=Summary
				Set $p(TempData,$c(3),2)=objRec.ActDate
				Set $p(TempData,$c(3),3)=objRec.ActTime
				Set $p(TempData,$c(3),4)=objData.DataValue_"!!"_objData.DataText
				Set $p(TempData,$c(3),5)=objRec.RecordID_"||"_objData.TestCode
				Set $p(TempData,$c(3),6)=""_"/"_objRec.ActUser
				Set $p(TempData,$c(3),7)="PatientBanner=1&PatientID="_$p($g(^PAADM(+%EpisodeID)),"^",1)_"&TestSetRow="_objRec.TestSetRow_"&OrderID="_objRec.OEItemID
				Set $p(TempData,$c(3),8)=objRec.SubmissionDate
				Set $p(TempData,$c(3),9)=objRec.SubmissionTime
				Set $p(TempData,$c(3),10)="LAB"
				Set $p(TempData,$c(3),11)=""
				Set $p(TempData,$c(3),12)=""
				Set $p(TempData,$c(3),13)=""
				Set $p(TempData,$c(3),14)=""
				Set %ExtraData=%ExtraData_$lb(TempData)
			}
		}
	
		//通过ESBLs试验结果监测
		If (objRec.IsESBLs=1) {
			Set DataCount=objRec.TestData.Count()
			For indData=1:1:DataCount {
				Set objData=objRec.TestData.GetAt(indData)
				Continue:'$IsObject(objData)
				
				//重复数据过滤
				Continue:$listfind(TestCodeList,objData.TestCode)>0
				//细菌结果标志
				Continue:objData.DataFormat'="V"
				//细菌关键字过滤
				Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check0("LIS-PY",objData.DataValue)
				Continue:checkFlag'=""
				//ESBLs多耐规则检测
				Set MRBWords=""
				Set Pathogeny=objData.DataValue
				Set AntiList=""
				Set DrugSenTestStr=objData.Antibiotics
				For indAnti=1:1:$l(DrugSenTestStr,$c(1)) {
					Set xAnti=$p(DrugSenTestStr,$c(1),indAnti)
					Continue:xAnti=""
					Set AntiCode=$p(xAnti,$c(2),1)
					Continue:AntiCode=""
					Set AntiDesc=$p(xAnti,$c(2),1)
					Continue:AntiDesc=""
					Set SenFlag=$p(xAnti,$c(2),3)
					Continue:SenFlag'["R"
					Set AntiList=AntiList_$lb(AntiDesc)
				}
				
				//w Pathogeny_"////"_AntiList,!
				Set MRBWords=##class(DHCMed.NINFService.Dic.MRBSrv).CheckIsESBLs(Pathogeny,AntiList)
				Continue:MRBWords=""
				
				If (aMRBAlias'="") {
					Continue:(MRBWords'[aMRBAlias)
				}
				
				Set TestCodeList=TestCodeList_$lb(objData.TestCode)
				
				Set RAntiList="",SAntiList=""
				Set AntiList=objData.Antibiotics
				For indAnti=1:1:$l(AntiList,$c(1)) {
					Set xAnti=$p(AntiList,$c(1),indAnti)
					Continue:xAnti=""
					
					Set AntiDesc=$p(xAnti,$c(2),2)
					Set SenFlag=$p(xAnti,$c(2),3)
					If SenFlag["R" {
						Set RAntiList=RAntiList_","_AntiDesc
					} Else {
						Set SAntiList=SAntiList_","_AntiDesc
					}
				}
				Set:RAntiList'="" RAntiList=$e(RAntiList,2,$l(RAntiList))
				Set:SAntiList'="" SAntiList=$e(SAntiList,2,$l(SAntiList))
				
				Set Summary="【"_MRBWords_"】【"_objRec.SpecimenDesc_"】"_objData.DataText
				Set:RAntiList'="" Summary=Summary_" (耐药:"_RAntiList_")"
				
				Set Count=Count+1
				Set TempData=""
				Set $p(TempData,$c(3),1)=Summary
				Set $p(TempData,$c(3),2)=objRec.ActDate
				Set $p(TempData,$c(3),3)=objRec.ActTime
				Set $p(TempData,$c(3),4)=objData.DataValue_"!!"_objData.DataText
				Set $p(TempData,$c(3),5)=objRec.RecordID_"||"_objData.TestCode
				Set $p(TempData,$c(3),6)=""_"/"_objRec.ActUser
				Set $p(TempData,$c(3),7)="PatientBanner=1&PatientID="_$p($g(^PAADM(+%EpisodeID)),"^",1)_"&TestSetRow="_objRec.TestSetRow_"&OrderID="_objRec.OEItemID
				Set $p(TempData,$c(3),8)=objRec.SubmissionDate
				Set $p(TempData,$c(3),9)=objRec.SubmissionTime
				Set $p(TempData,$c(3),10)="LAB"
				Set $p(TempData,$c(3),11)=""
				Set $p(TempData,$c(3),12)=""
				Set $p(TempData,$c(3),13)=""
				Set $p(TempData,$c(3),14)=""
				Set %ExtraData=%ExtraData_$lb(TempData)
			}
		}
		
		//多重耐药/泛耐药菌
		Set MDRMRBWords=""
		Set MRBId=""
		For {
			Set MRBId=$o(^DHCMed.NINFD("MRB",MRBId))
			Quit:MRBId=""
			
			Set objMRB=##class(DHCMed.NINF.Dic.MRB).GetObjById(MRBId)
			Quit:'$IsObject(objMRB)
			Set MRBCode=objMRB.Code
			Set MRBDesc=objMRB.Description
			Continue:MRBDesc'="多重耐药/泛耐药菌"
			Set MDRMRBWords=MRBDesc
		}
		If MDRMRBWords'="" {
			Set DataCount=objRec.TestData.Count()
			For indData=1:1:DataCount {
				Set objData=objRec.TestData.GetAt(indData)
				Continue:'$IsObject(objData)
				
				//重复数据过滤
				Continue:$listfind(TestCodeList,objData.TestCode)>0
				//细菌结果标志
				Continue:objData.DataFormat'="V"
				//细菌关键字过滤
				Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check0("LIS-PY",objData.DataText)
				Continue:checkFlag'=""
				//ESBLs多耐规则检测
				Set MRBWords=""
				Set Pathogeny=objData.DataValue
				Set AntiList=""
				Set DrugSenTestStr=objData.Antibiotics
				For indAnti=1:1:$l(DrugSenTestStr,$c(1)) {
					Set xAnti=$p(DrugSenTestStr,$c(1),indAnti)
					Continue:xAnti=""
					Set AntiCode=$p(xAnti,$c(2),1)
					Continue:AntiCode=""
					Set SenFlag=$p(xAnti,$c(2),3)
					Continue:SenFlag'["R"
					Set AntiList=AntiList_$lb(AntiCode)
				}
				//w Pathogeny_"////"_AntiList,!
				Continue:$l(DrugSenTestStr,$c(1))'=$listlength(AntiList)
				Set MRBWords=MDRMRBWords
				
				If (aMRBAlias'="") {
					Continue:(MRBWords'[aMRBAlias)
				}
				
				Set TestCodeList=TestCodeList_$lb(objData.TestCode)
				
				Set RAntiList="",SAntiList=""
				Set AntiList=objData.Antibiotics
				For indAnti=1:1:$l(AntiList,$c(1)) {
					Set xAnti=$p(AntiList,$c(1),indAnti)
					Continue:xAnti=""
					
					Set AntiDesc=$p(xAnti,$c(2),2)
					Set SenFlag=$p(xAnti,$c(2),3)
					If SenFlag["R" {
						Set RAntiList=RAntiList_","_AntiDesc
					} Else {
						Set SAntiList=SAntiList_","_AntiDesc
					}
				}
				Set:RAntiList'="" RAntiList=$e(RAntiList,2,$l(RAntiList))
				Set:SAntiList'="" SAntiList=$e(SAntiList,2,$l(SAntiList))
				
				Set Summary="【"_MRBWords_"】【"_objRec.SpecimenDesc_"】"_objData.DataText
				Set:RAntiList'="" Summary=Summary_" (耐药:"_RAntiList_")"
				
				Set Count=Count+1
				Set TempData=""
				Set $p(TempData,$c(3),1)=Summary
				Set $p(TempData,$c(3),2)=objRec.ActDate
				Set $p(TempData,$c(3),3)=objRec.ActTime
				Set $p(TempData,$c(3),4)=objData.DataValue_"!!"_objData.DataText
				Set $p(TempData,$c(3),5)=objRec.RecordID_"||"_objData.TestCode
				Set $p(TempData,$c(3),6)=""_"/"_objRec.ActUser
				Set $p(TempData,$c(3),7)="PatientBanner=1&PatientID="_$p($g(^PAADM(+%EpisodeID)),"^",1)_"&TestSetRow="_objRec.TestSetRow_"&OrderID="_objRec.OEItemID
				Set $p(TempData,$c(3),8)=objRec.SubmissionDate
				Set $p(TempData,$c(3),9)=objRec.SubmissionTime
				Set $p(TempData,$c(3),10)="LAB"
				Set $p(TempData,$c(3),11)=""
				Set $p(TempData,$c(3),12)=""
				Set $p(TempData,$c(3),13)=""
				Set $p(TempData,$c(3),14)=""
				Set %ExtraData=%ExtraData_$lb(TempData)
			}
		}
		
		//根据常用短语检索多重耐药菌
		Set MRBWords=##Class(DHCMed.DP.Base.ActWards).Check1("LIS-MRB",objRec.TestDemo)
		If (MRBWords'="") {
			Set MRBWords=##Class(DHCMed.CCService.Lib.Common).GetListToString(MRBWords,",")
			If (aMRBAlias'="") {
				Continue:(MRBWords'[aMRBAlias)
			}
			
			Set DataCount=objRec.TestData.Count()
			For indData=1:1:DataCount {
				Set objData=objRec.TestData.GetAt(indData)
				Continue:'$IsObject(objData)
				
				//重复数据过滤
				Continue:$listfind(TestCodeList,objData.TestCode)>0
				//细菌结果标志
				Continue:objData.DataFormat'="V"
				//细菌关键字过滤
				Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check0("LIS-PY",objData.DataValue)
				Continue:checkFlag'=""
				
				Set TestCodeList=TestCodeList_$lb(objData.TestCode)
				
				Set RAntiList="",SAntiList=""
				Set AntiList=objData.Antibiotics
				For indAnti=1:1:$l(AntiList,$c(1)) {
					Set xAnti=$p(AntiList,$c(1),indAnti)
					Continue:xAnti=""
					
					Set AntiDesc=$p(xAnti,$c(2),2)
					Set SenFlag=$p(xAnti,$c(2),3)
					If SenFlag["R" {
						Set RAntiList=RAntiList_","_AntiDesc
					} Else {
						Set SAntiList=SAntiList_","_AntiDesc
					}
				}
				Set:RAntiList'="" RAntiList=$e(RAntiList,2,$l(RAntiList))
				Set:SAntiList'="" SAntiList=$e(SAntiList,2,$l(SAntiList))
				
				Set Summary="【"_MRBWords_"】【"_objRec.SpecimenDesc_"】"_objData.DataVale
				Set:RAntiList'="" Summary=Summary_" (耐药:"_RAntiList_")"
				
				Set Count=Count+1
				Set TempData=""
				Set $p(TempData,$c(3),1)=Summary
				Set $p(TempData,$c(3),2)=objRec.ActDate
				Set $p(TempData,$c(3),3)=objRec.ActTime
				Set $p(TempData,$c(3),4)=objData.DataValue_"!!"_objData.DataText
				Set $p(TempData,$c(3),5)=objRec.RecordID_"||"_objData.TestCode
				Set $p(TempData,$c(3),6)=""_"/"_objRec.ActUser
				Set $p(TempData,$c(3),7)="PatientBanner=1&PatientID="_$p($g(^PAADM(+%EpisodeID)),"^",1)_"&TestSetRow="_objRec.TestSetRow_"&OrderID="_objRec.OEItemID
				Set $p(TempData,$c(3),8)=objRec.SubmissionDate
				Set $p(TempData,$c(3),9)=objRec.SubmissionTime
				Set $p(TempData,$c(3),10)="LAB"
				Set $p(TempData,$c(3),11)=""
				Set $p(TempData,$c(3),12)=""
				Set $p(TempData,$c(3),13)=""
				Set $p(TempData,$c(3),14)=""
				Set %ExtraData=%ExtraData_$lb(TempData)
			}
		}
	}
	
	Set return=Count
	
	Quit return
	
CheckIsMRBErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-03-18
/// Description:  通过Lab表达式取检验监控结果
/// Table：       EP_VisitNumber,EP_VisitTestSet,EP_VisitTestSetData
/// Input：       LabExp : 检验项目检查表达式
/// Return：      返回检验项目数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.LabReport).CheckLabItem()
ClassMethod CheckLabItem(aLabExp As %String) As %String
{
	New (aLabExp,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Quit:aLabExp="" return
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckLabItemErr"
	
	Set LabExp2=$p(aLabExp,"||",2)
	Set LabExp3=$p(aLabExp,"||",3)
	Set TestCode=$p(LabExp2,"|",1)
	Set ComCode=$p(LabExp2,"|",2)
	Set ComValue=$p(LabExp2,"|",3)
	Set ComArcimDesc=$p(LabExp2,"|",4)
	Set ComSpecimenDesc=$p(LabExp2,"|",5)
	Quit:(TestCode="")||(ComCode="") return
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,"",TestCode,1)
	Set Num=arrRec.Count()
	
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set ArcimDesc=objRec.OEItemDesc
		Continue:(ArcimDesc'[ComArcimDesc)&(ComArcimDesc'="")
		Set SpecimenDesc=objRec.SpecimenDesc
		Continue:(SpecimenDesc'[ComSpecimenDesc)&(ComSpecimenDesc'="")
		
		Set DataCount=objRec.TestData.Count()
		For indData=1:1:DataCount {
			Set objData=objRec.TestData.GetAt(indData)
			Continue:'$IsObject(objData)
			
			Set ItemResult=objData.DataValue
			Continue:##class(DHCMed.CCService.Lib.LisReport).ComResult(ItemResult,ComCode,ComValue)=0
			
			Set Summary="【"_objRec.SpecimenDesc_"】"_objData.TestDesc_"："_objData.DataText_objData.ItemUnit
			Set:objData.ItemRangs'="" Summary=Summary_"("_objData.ItemRangs_")"
			Set:objData.AbnorFlag'="" Summary=Summary_" 【"_objData.AbnorFlag_"】"
			
			Set Count=Count+1
			Set TempData=""
			Set $p(TempData,$c(3),1)=Summary
			Set $p(TempData,$c(3),2)=objRec.ActDate
			Set $p(TempData,$c(3),3)=objRec.ActTime
			Set $p(TempData,$c(3),4)=objData.DataValue_"!!"_objData.DataText
			Set $p(TempData,$c(3),5)=objRec.RecordID_"||"_objData.TestCode
			Set $p(TempData,$c(3),6)=""_"/"_objRec.ActUser
			Set $p(TempData,$c(3),7)="PatientBanner=1&PatientID="_$p($g(^PAADM(+%EpisodeID)),"^",1)_"&TestSetRow="_objRec.TestSetRow_"&OrderID="_objRec.OEItemID
			Set $p(TempData,$c(3),8)=objRec.SubmissionDate
			Set $p(TempData,$c(3),9)=objRec.SubmissionTime
			Set $p(TempData,$c(3),10)="LAB"
			Set $p(TempData,$c(3),11)=""
			Set $p(TempData,$c(3),12)=""
			Set $p(TempData,$c(3),13)=""
			Set $p(TempData,$c(3),14)=""
			Set %ExtraData=%ExtraData_$lb(TempData)
		}
	}
	
	Set return=Count
	Quit return
	
CheckLabItemErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-03-20
/// Description:  通过Lab表达式取检验监控结果
/// Table：       EP_VisitNumber,EP_VisitTestSet,EP_VisitTestSetData
/// Input：       LabExp : 检验项目检查表达式
/// Return：      返回检验项目数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.LabReport).CheckItemAbnor()
ClassMethod CheckItemAbnor(aLabExp As %String) As %String
{
	New (aLabExp,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Quit:aLabExp="" return
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckItemAbnorErr"
	
	Set LabExp2=$p(aLabExp,"||",2)
	Set LabExp3=$p(aLabExp,"||",3)
	Set TestCode=$p(LabExp2,"|",1)
	Set ComCode=$p(LabExp2,"|",2)
	Set ComValue=$p(LabExp2,"|",3)
	Set ComArcimDesc=$p(LabExp2,"|",4)
	Set ComSpecimenDesc=$p(LabExp2,"|",5)
	Quit:(TestCode="")||(ComCode="") return
	Quit:ComCode'="异常标记" return
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,"",TestCode,1)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set ArcimDesc=objRec.OEItemDesc
		Continue:(ArcimDesc'[ComArcimDesc)&(ComArcimDesc'="")
		Set SpecimenDesc=objRec.SpecimenDesc
		Continue:(SpecimenDesc'[ComSpecimenDesc)&(ComSpecimenDesc'="")
		
		Set DataCount=objRec.TestData.Count()
		For indData=1:1:DataCount {
			Set objData=objRec.TestData.GetAt(indData)
			Continue:'$IsObject(objData)
			
			Set ItemResult=objData.DataValue
			Set AbnorFlag=objData.AbnorFlag
			Continue:AbnorFlag=""  //异常标记筛查(L、H)
			If (ComValue'="*")&&(ComValue'="") {
				Continue:ComValue'[AbnorFlag
				//w ComValue_"///"_AbnorFlag,!
			}
			
			Set Summary="【"_objRec.SpecimenDesc_"】"_objData.TestDesc_"："_objData.DataValue_objData.ItemUnit
			Set:objData.ItemRangs'="" Summary=Summary_"("_objData.ItemRangs_")"
			Set:objData.AbnorFlag'="" Summary=Summary_" 【"_objData.AbnorFlag_"】"
			
			Set Count=Count+1
			Set TempData=""
			Set $p(TempData,$c(3),1)=Summary
			Set $p(TempData,$c(3),2)=objRec.ActDate
			Set $p(TempData,$c(3),3)=objRec.ActTime
			Set $p(TempData,$c(3),4)=objData.DataValue_"!!"_objData.DataText
			Set $p(TempData,$c(3),5)=objRec.RecordID_"||"_objData.TestCode
			Set $p(TempData,$c(3),6)=""_"/"_objRec.ActUser
			Set $p(TempData,$c(3),7)="PatientBanner=1&PatientID="_$p($g(^PAADM(+%EpisodeID)),"^",1)_"&TestSetRow="_objRec.TestSetRow_"&OrderID="_objRec.OEItemID
			Set $p(TempData,$c(3),8)=objRec.SubmissionDate
			Set $p(TempData,$c(3),9)=objRec.SubmissionTime
			Set $p(TempData,$c(3),10)="LAB"
			Set $p(TempData,$c(3),11)=""
			Set $p(TempData,$c(3),12)=""
			Set $p(TempData,$c(3),13)=""
			Set $p(TempData,$c(3),14)=""
			Set %ExtraData=%ExtraData_$lb(TempData)
		}
	}
	
	Set return=Count
	Quit return
	
CheckItemAbnorErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-03-18
/// Description:  通过Lab表达式取检验监控结果
/// Table：       EP_VisitNumber,EP_VisitTestSet,EP_VisitTestSetData
/// Input：       LabExp : 检验项目检查表达式
/// Return：      返回检验项目数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.LabReport).CheckSubmisBugs()
ClassMethod CheckSubmisBugs() As %String
{
	New (%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set LabOECategory=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("CC-LabOECategory","")
	Quit:LabOECategory="" return
	
	Set $ZT="CheckSubmisBugsErr"
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.OEOrdItem).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,LabOECategory,"")
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
	 	Set ArcimType=objRec.Category
	 	Continue:ArcimType'="L"
	 	
		Set Summary=objRec.ItemDesc
		
		Set Count=Count+1
		Set TempData=""
		Set $p(TempData,$c(3),1)=Summary
		Set $p(TempData,$c(3),2)=objRec.ActDate
		Set $p(TempData,$c(3),3)=objRec.ActTime
		Set $p(TempData,$c(3),4)=objRec.ItemDesc
		Set $p(TempData,$c(3),5)=objRec.RecordID
		Set $p(TempData,$c(3),6)=objRec.ActUser_"/"_objRec.ActUserDesc
		Set $p(TempData,$c(3),7)=""
		Set $p(TempData,$c(3),8)=objRec.SttDate
		Set $p(TempData,$c(3),9)=objRec.SttTime
		Set $p(TempData,$c(3),10)="OE"
		Set $p(TempData,$c(3),11)=""
		Set $p(TempData,$c(3),12)=""
		Set $p(TempData,$c(3),13)=""
		Set $p(TempData,$c(3),14)=""
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	
	Set return=Count
	Quit return
	
CheckSubmisBugsErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

}
