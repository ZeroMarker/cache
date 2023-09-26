/// 名称: DHCMed.DCEns.LIS.TSResultByV2
/// 描述: 检验数据输入服务类（东华检验V2.0）
/// 编写者：zhufei
/// 编写日期: 2016-03-29
Class DHCMed.DCEns.LIS.TSResultByV2 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// *********************************************************************************
/// 以下内容为：同步检验结果数据方法
/// *********************************************************************************
/// Creator：     jiangpengpeng
/// CreatDate：   2016-03-25
/// Description:  根据起止日期同步检验报告数据
/// Table：       DHCMed.DC.LIS.LabReport
/// Input：       FromDate:开始日期
///               ToDate:结束日期
///               HospCode:医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
/// Return：      OK
/// w ##class(DHCMed.DCEns.LIS.TSResultByV2).SyncRepByDate("2015-01-01","2016-05-16","LIS01")
ClassMethod SyncRepByDate(aFromDate As %String, aToDate As %String, aHospCode As %String, aInitFlag As %String = "0") As %String
{
	New (aFromDate,aToDate,aHospCode,aInitFlag)
	Set return="0^入参错误",Count=0
	Quit:(aFromDate="")||(aToDate="")||(aHospCode="") return
	
	Set return="-1^医院缩写码维护错误"
	Set flg=##class(DHCMed.DC.BTHospital).GetIDBySCode(aHospCode)
	Quit:flg="" return
	
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set tFromDate=$zd(+aFromDate,3)
	Set tFromDate=$tr(tFromDate,"-","")
	Set tToDate=$zd(+aToDate,3)
	Set tToDate=$tr(tToDate,"-","")
	
	If aInitFlag=1 {
		//检验报告数据
		Kill ^DHCMed.DC.LIS.LabReportD
		Kill ^DHCMed.DC.LIS.LabReportI
		//检验结果数据
		Kill ^DHCMed.DC.LIS.LabResultD
		Kill ^DHCMed.DC.LIS.LabResultI
	}
	
	/*
	Set xDate=tFromDate-1
	For {
		Set xDate=$o(^dbo.OTMsgStockI("IndexReceiveDate",xDate))
		Quit:xDate=""
		Quit:xDate>tToDate
		
		Set xMsgType=""
		For {
			Set xMsgType=$o(^dbo.OTMsgStockI("IndexReceiveDate",xDate,xMsgType))
			Quit:xMsgType=""
			
			Set tmpMsgType=$p(xMsgType," ",2)
			//只保存"审核"和"复审"状态的报告，其他过滤
			//Continue:(tmpMsgType'="HISAUTHORISE")&&(tmpMsgType'="HISREAUTHORISE")
			
			Set xID=""
			For {
				Set xID=$o(^dbo.OTMsgStockI("IndexReceiveDate",xDate,xMsgType,xID))
				Quit:xID=""

				Set Count=Count+1
				W:(Count#100)=0 "已处理 "_Count_" 条数据!",!
				
				Set tmpInfo=$g(^dbo.OTMsgStockD(xID))
				Continue:tmpInfo=""
				Set ReportID=$Lg(tmpInfo,17)  //检验报告ID
				Set flg=..SaveReport(ReportID,aHospCode)
				If (+flg)<0 {
					Write "错误提示：ReportID="_ReportID_",return="_flg,!
				}
				
				Set flg=..SaveResult(ReportID,aHospCode)
				If (+flg)<0 {
					Write "错误提示：ReportID="_ReportID_",return="_flg,!
				}
			}
		}
	}
	*/
	
	Set xWorkMachineID=""
	For {
		Set xWorkMachineID=$o(^dbo.RPVisitNumberReportI("IndexAuthDate",xWorkMachineID))
		Quit:xWorkMachineID=""
		
		Set xDate=tFromDate-1
		For {
			Set xDate=$o(^dbo.RPVisitNumberReportI("IndexAuthDate",xWorkMachineID,xDate))
			Quit:xDate=""
			Quit:xDate>tToDate
			
			Set xID=""
			For {
				Set xID=$o(^dbo.RPVisitNumberReportI("IndexAuthDate",xWorkMachineID,xDate,xID))
				Quit:xID=""
				
				Set Count=Count+1
				W:(Count#100)=0 "已处理 "_Count_" 条数据!",!
				
				Set ReportID=xID  //检验报告ID
				Set flg=..SaveTestSet(ReportID,aHospCode)
				If (+flg)<0 {
					Write "错误提示：ReportID="_ReportID_",return="_flg,!
				}
				
				Set flg=..SaveReport(ReportID,aHospCode)
				If (+flg)<0 {
					Write "错误提示：ReportID="_ReportID_",return="_flg,!
				}
				
				Set flg=..SaveResult(ReportID,aHospCode)
				If (+flg)<0 {
					Write "错误提示：ReportID="_ReportID_",return="_flg,!
				}
			}
		}
	}
	Quit "OK"
}

/// Creator：     zhufei
/// CreatDate：   2016-05-17
/// Description:  根据检验报告ID保存检验医嘱数据
/// Table：       DHCMed.DC.LIS.LabTestSet
/// Input：       aReportID
/// Return：      
/// w ##class(DHCMed.DCEns.LIS.TSResultByV2).SaveTestSet(481,"LIS01")
ClassMethod SaveTestSet(aReportID As %String, aHospCode As %String) As %String
{
	New (aReportID,aHospCode)
	Set return=0
	Quit:(aReportID="")||(aHospCode="") return
	
	Set error=""
	Set ReportData=$g(^dbo.RPVisitNumberReportD(aReportID))
	Quit:ReportData="" return
	Set VisitNumberDR=$lg(ReportData,2)
	Set WGMachineDR=$lg(ReportData,4)
	Set VisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDR))
	Quit:VisitNumberData="" return
	Set EpisodeNo=$lg(VisitNumberData,2)
	Set TestSetNo=VisitNumberDR_"||"_WGMachineDR
	
	Set xTSDR=""
	For {
		Set xTSDR=$o(^dbo.RPVisitNumberTestSetI("IndexWGMachineDR",VisitNumberDR,WGMachineDR,xTSDR))
		Quit:xTSDR=""
		
		Set xID=0
		For {
			Set xID=$o(^dbo.RPVisitNumberTestSetI("IndexWGMachineDR",VisitNumberDR,WGMachineDR,xTSDR,xID))
			Quit:xID=""
			
			Set TestSetRow=xID
			Set TestSetData=$g(^dbo.RPVisitNumberTestSetD(xID))
			Continue:TestSetData=""
			Set TestSetDR=$lg(TestSetData,3)
			Continue:TestSetDR=""
			Set tTestSetInfo=$g(^dbo.BTTestSetD(TestSetDR))
			Continue:tTestSetInfo=""
			Set TSCode=$Lg(tTestSetInfo,2)
			Set TSCName=$Lg(tTestSetInfo,3)
			Set TestSetDR=##class(DHCMed.DC.LIS.BTTestSet).GetIDByCodeDesc(TSCode,TSCName,aHospCode)
			
			Set InputStr=EpisodeNo
			Set InputStr=InputStr_"^"_TestSetRow
			Set InputStr=InputStr_"^"_TestSetNo
			Set InputStr=InputStr_"^"_TestSetDR
			Set InputStr=InputStr_"^"_""  //SpecimenDR
			Set InputStr=InputStr_"^"_""  //LocationDR
			Set InputStr=InputStr_"^"_""  //CollectDate
			Set InputStr=InputStr_"^"_""  //CollectTime
			Set InputStr=InputStr_"^"_""  //CollectUser
			Set InputStr=InputStr_"^"_""  //ReceiveDate
			Set InputStr=InputStr_"^"_""  //ReceiveTime
			Set InputStr=InputStr_"^"_""  //ReceiveUser
			Set InputStr=InputStr_"^"_1   //IsActive
			Set flg=##class(DHCMed.DC.LIS.LabTestSet).Update(InputStr)
			If (+flg)<1 {
				Set error="-1.1^检验医嘱保存错误!return="_flg_",InputStr="_InputStr
				Quit
			}
		}
	}
	Quit:error'="" error
	
	Set return=1
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2016-03-17
/// Description:  根据检验报告ID保存报告数据
/// Table：       DHCMed.DC.LIS.LabReport
/// Input：       aReportID
/// Return：      
/// w ##class(DHCMed.DCEns.LIS.TSResultByV2).SaveReport(481,"LIS01")
ClassMethod SaveReport(aReportID As %String, aHospCode As %String) As %String
{
	New (aReportID,aHospCode)
	Set return=0
	Quit:(aReportID="")||(aHospCode="") return
	
	Set error=""
	Set RepInfo=##class(LISService.Business.LISReport).GetReportInfo(aReportID,"")
	If RepInfo="" {
		Set error="0^无检验报告"
		Quit error
	}
	
	Set ReportData=$g(^dbo.RPVisitNumberReportD(aReportID))
	Quit:ReportData="" return
	Set VisitNumberDR=$lg(ReportData,2)
	Set WGMachineDR=$lg(ReportData,4)
	Set OrderNo=$lg(ReportData,5)
	
	Set TestSetNo       = VisitNumberDR_"||"_WGMachineDR
	Set OrderNo         = OrderNo
	Set ReportID        = aReportID
	Set TSName          = $p(RepInfo,"^",6)
	Set Specimen        = $p(RepInfo,"^",7)
	Set SpecimenDR      = ##class(DHCMed.DC.LIS.BTSpecimen).GetIDByCodeDesc("",Specimen,aHospCode)
	Set LocDesc         = $p(RepInfo,"^",10)
	Set LocationDR      = ##class(DHCMed.DC.BTLoc).GetIDByCodeDesc("",LocDesc,aHospCode)
	Set CollectDateTime = $p(RepInfo,"^",12)
	Set CollectDate     = $p(CollectDateTime," ",1)
	Set CollectTime     = $p(CollectDateTime," ",2)
	Set CollectUser     = ""
	Set ReceiveDateTime = $p(RepInfo,"^",14)
	Set ReceiveDate     = $p(ReceiveDateTime," ",1)
	Set ReceiveTime     = $p(ReceiveDateTime," ",2)
	Set ReceiveUser     = $p(RepInfo,"^",13)
	Set AuthDateTime    = $p(RepInfo,"^",18)
	Set AuthDate        = $p(AuthDateTime," ",1)
	Set AuthTime        = $p(AuthDateTime," ",2)
	Set AuthUser        = $p(RepInfo,"^",17)
	
	Set InputStr=TestSetNo
	Set InputStr=InputStr_"^"_OrderNo
	Set InputStr=InputStr_"^"_ReportID
	Set InputStr=InputStr_"^"_TSName
	Set InputStr=InputStr_"^"_SpecimenDR
	Set InputStr=InputStr_"^"_LocationDR
	Set InputStr=InputStr_"^"_CollectDate
	Set InputStr=InputStr_"^"_CollectTime
	Set InputStr=InputStr_"^"_CollectUser
	Set InputStr=InputStr_"^"_ReceiveDate
	Set InputStr=InputStr_"^"_ReceiveTime
	Set InputStr=InputStr_"^"_ReceiveUser
	Set InputStr=InputStr_"^"_AuthDate
	Set InputStr=InputStr_"^"_AuthTime
	Set InputStr=InputStr_"^"_AuthUser
	Set InputStr=InputStr_"^"_1
	Set flg=##class(DHCMed.DC.LIS.LabReport).Update(InputStr)
	If (+flg)<1 {
		Set error="-1.1^检验报告保存错误!return="_flg_",InputStr="_InputStr
		Quit error
	} Else {
		Set ReportID=flg
	}
	Quit:error'="" error
	
	Set return=ReportID
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2016-03-25
/// Description:  根据检验报告ID保存检验结果数据
/// Table：       DHCMed.DC.LIS.LabReport
/// Input：       aRepID
/// Return：      
/// w ##class(DHCMed.DCEns.LIS.TSResultByV2).SaveResult(481,"LIS01")
ClassMethod SaveResult(aReportID As %String, aHospCode As %String) As %String
{
	New (aReportID,aHospCode)
	Set return=0
	Quit:(aReportID="")||(aHospCode="") return
	
	Set error=""
	Set ResultFlag=0  //检验结果标志
	Set result=##class(%ResultSet).%New("LISService.Business.ReportResult:QryTestSetResult")
	Set sc=result.Execute(aReportID)
 	While (result.Next(.sc)) // go to the next row of the result set
    {
		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
        {
	        Set ResultFlag=1  //检验结果标志
	        
			Set TestCode    = result.Data("TestCode")
			Continue:TestCode=""
			Set TestName    = result.Data("TestName")
			Set TestSync    = result.Data("TestSync")
			Set Result      = result.Data("Result")
			Set Unit        = result.Data("Unit")
			Set TextRes     = Result_" "_Unit
			Set AbFlag      = result.Data("ResFlag")
			Set RefRanges   = result.Data("Ranges")
			Set objTC=##class(DHCMed.DC.LIS.BTTestCode).GetObjByCode(TestCode,aHospCode)
			If $IsObject(objTC){
				Set ResultFormat=objTC.ResultFormat
				Set:ResultFormat="M" ResultFormat="V"
			}
			Set ResNoes     = ""
			Set MDRResult   = ""
			Set ESBLsResult = ""
			Set SenResultID = result.Data("SenResultId")
			If SenResultID'=""{
				Set MDRResult=$lg($g(^dbo.RPVisitNumberReportResultD(+SenResultID)),27)
				Set ResultFormat="V"	
			}
			Set TestCodeDR=##class(DHCMed.DC.LIS.BTTestCode).GetIDByCodeDesc(TestCode,TestName,aHospCode)
			If TestCodeDR="" {
				Set error="-2.1^错误提示:无检验项目!"
				Quit
			}
			
			Set InputStr=aReportID
			Set InputStr=InputStr_$c(1)_TestCodeDR
			Set InputStr=InputStr_$c(1)_ResultFormat
			Set InputStr=InputStr_$c(1)_Result
			Set InputStr=InputStr_$c(1)_TextRes
			Set InputStr=InputStr_$c(1)_ResNoes
			Set InputStr=InputStr_$c(1)_AbFlag
			Set InputStr=InputStr_$c(1)_Unit
			Set InputStr=InputStr_$c(1)_RefRanges
			Set InputStr=InputStr_$c(1)_MDRResult
			Set InputStr=InputStr_$c(1)_ESBLsResult
			Set flg=##class(DHCMed.DC.LIS.LabResult).Update(InputStr,$c(1))
			If (+flg)<1 {
				Set error="-2.2^错误提示:检验结果保存错误!return="_flg_",InputStr="_InputStr
				Quit
			} Else {
				Set ResultID=flg
				
				Set flg=##class(DHCMed.DC.LIS.LabResultSen).InitByRef(ResultID)
				If (+flg)<1 {
					Set error="-2.3^错误提示:药敏结果初始化错误!ResultID="_ResultID
					Quit
				}
				
				Continue:SenResultID=""  //无药敏结果
				
				Set SenResultFlag=0  //药敏结果标志
				Set resultsen=##class(%ResultSet).%New("LISService.Business.ReportResult:QryTestSetResultSen")
				Set scsen=resultsen.Execute(SenResultID)
				While (resultsen.Next(.scsen)) // go to the next row of the result set
				{
					If ($SYSTEM.Status.IsOK(scsen)) // check if this succeeded without errors
					{
						Set SenResultFlag=1  //药敏结果标志
						
	    				Set WCode     = resultsen.Data("WCode")
	    				Set AntCode   = resultsen.Data("AntCode")
	    				Set AntName   = resultsen.Data("AntName")
	    				Set SenCode   = resultsen.Data("SenCode")
	    				Set SenName   = resultsen.Data("SenName")
	    				Set SenMethod = resultsen.Data("SenMethod")
	    				Set SenValue  = resultsen.Data("SenValue")
	    				
	    				Set AntibioticsDR=##class(DHCMed.DC.LIS.BTAntibiotics).GetIDByCodeDesc(AntCode,AntName,aHospCode)
		    			If AntibioticsDR="" {
		    				Set error="-2.4^错误提示:无抗生素字典!"
							Quit
		    			}
	    				
	    				Set SensitivityDR=##class(DHCMed.DC.LIS.BTSensitivity).GetIDByCodeDesc(SenCode,SenName)
	    				
				    	Set InputStr=ResultID         //Parref
				    	Set InputStr=InputStr_"^"_""  //ChildSub
				    	Set InputStr=InputStr_"^"_AntibioticsDR
				    	Set InputStr=InputStr_"^"_SensitivityDR
						Set flg=##class(DHCMed.DC.LIS.LabResultSen).Update(InputStr)
						If (+flg)<1 {
							Set error="-2.5^错误提示:药敏结果保存错误!return="_flg_",InputStr="_InputStr
							Quit
						}
					}
				}
				Quit:error'=""
			}
     	}
	}
	Quit:error'="" error
	
	If ResultFlag<1 {
		Set error="0^无检验结果"
		Quit error
	}
	
	Set return=aReportID
	Quit return
}

/// *********************************************************************************
/// 以下内容为：同步检验基础数据方法
/// *********************************************************************************
/// Creator：     jiangpengpeng
/// CreatDate：   2016-03-15
/// Description:  检验基础数据同步
/// Table：       dbo.BT*、DHCMed.DC.LIS.*
/// Input：       HospCode ：医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
/// Return：      OK
/// w ##class(DHCMed.DCEns.LIS.TSResultByV2).ProcBaseData("LIS01")
ClassMethod ProcBaseData(aHospCode As %String, aInitFlag As %String = "0") As %String
{
	New (aHospCode,aInitFlag)
	Set return="0^入参为空"
	Quit:aHospCode="" return
	
	Set return="-1^医院缩写码维护错误"
	Set flg=##class(DHCMed.DC.BTHospital).GetIDBySCode(aHospCode)
	Quit:flg="" return
	
	//处理【系统字典】科室dbo.BTLocation
	If aInitFlag=1 {
		Kill ^DHCMed.DC.BTLocD
		Kill ^DHCMed.DC.BTLocI
	}
	Set flg=..ChangeLoc(aHospCode)
	
	//处理【系统字典】医生dbo.BTDoctor
	If aInitFlag=1 {
		Kill ^DHCMed.DC.BTDoctorD
		Kill ^DHCMed.DC.BTDoctorI
	}
	Set flg=..ChangeDoctor(aHospCode)
	
	//处理【基础字典】血型dbo.BTABOBG
	If aInitFlag=1 {
		Kill ^DHCMed.DC.LIS.BTABOBGD
		Kill ^DHCMed.DC.LIS.BTABOBGI
	}
	Set flg=..ChangeBTABOBG(aHospCode)
	
	//处理【基础字典】抗生素dbo.BTAntibiotics
	If aInitFlag=1 {
		Kill ^DHCMed.DC.LIS.BTAntibioticsD
		Kill ^DHCMed.DC.LIS.BTAntibioticsI
	}
	Set flg=..ChangeBTAntibiotics(aHospCode)
	
	//处理【基础字典】细菌dbo.BTOrganism
	If aInitFlag=1 {
		Kill ^DHCMed.DC.LIS.BTOrganismD
		Kill ^DHCMed.DC.LIS.BTOrganismI
	}
	Set flg=..ChangeBTOrganism(aHospCode)
	
	//处理【基础字典】药敏结果dbo.BTSensitivity
	If aInitFlag=1 {
		Kill ^DHCMed.DC.LIS.BTSensitivityD
		Kill ^DHCMed.DC.LIS.BTSensitivityI
	}
	Set flg=..ChangeBTSensitivity(aHospCode)
	
	//处理【基础字典】标本dbo.BTSpecimen
	If aInitFlag=1 {
		Kill ^DHCMed.DC.LIS.BTSpecimenD
		Kill ^DHCMed.DC.LIS.BTSpecimenI
	}
	Set flg=..ChangeBTSpecimen(aHospCode)
	
	//处理【基础字典】检测组套/检验医嘱dbo.BTTestSet
	If aInitFlag=1 {
		Kill ^DHCMed.DC.LIS.BTTestSetD
		Kill ^DHCMed.DC.LIS.BTTestSetI
	}
	Set flg=..ChangeBTTestSet(aHospCode)
	
	//处理【基础字典】检测项目dbo.BTTestCode
	If aInitFlag=1 {
		Kill ^DHCMed.DC.LIS.BTTestCodeD
		Kill ^DHCMed.DC.LIS.BTTestCodeI
	}
	Set flg=..ChangeBTTestCode(aHospCode)
	
	//处理【基础字典】检测项目标准意见dbo.BTTestCodeComments
	If aInitFlag=1 {
		Kill ^DHCMed.DC.LIS.BTTestCodeSCD
		Kill ^DHCMed.DC.LIS.BTTestCodeSCI
	}
	Set flg=..ChangeBTTestCodeSC(aHospCode)
	
	//处理【基础字典】工作组dbo.BTWorkGroup
	If aInitFlag=1 {
		Kill ^DHCMed.DC.LIS.BTWorkGroupD
		Kill ^DHCMed.DC.LIS.BTWorkGroupI
	}
	Set flg=..ChangeBTWorkGroup(aHospCode)
	
	Quit "OK"
}

ClassMethod ChangeLoc(aHospCode As %String)
{
	Set Count=0
	Set xID=""
	For {
		Set xID=$o(^dbo.BTLocationD(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^dbo.BTLocationD(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		set Code     = $Lg(tmpInfo,2)
		set CName    = $Lg(tmpInfo,3)
		continue:CName=""
		set LocType  = $Lg(tmpInfo,9)
		set Remark   = ""
		set XCode    = xID
		set Active 	 = $Lg(tmpInfo,11)
		Set HospCode = aHospCode
		Set InStr=Code_"^"_CName_"^"_HospCode_"^"_LocType_"^"_Remark_"^"_XCode_"^"_Active
		Set flg=##class(DHCMed.DC.BTLoc).Update(InStr,"^")
		If (flg<1) {
			Write "科室：flg="_flg_","_InStr,!
		}
	}
	Quit Count
}

ClassMethod ChangeDoctor(aHospCode As %String)
{
	Set Count=0
	Set xID=""
	For {
		Set xID=$o(^dbo.BTDoctorD(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^dbo.BTDoctorD(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		set Code     = $Lg(tmpInfo,2)
		set CName    = $Lg(tmpInfo,3)
		continue:CName=""
		set Remark   = ""
		set XCode    = xID
		set Active 	 = $Lg(tmpInfo,9)
		Set HospCode = aHospCode
		Set InStr=Code_"^"_CName_"^"_HospCode_"^"_""_"^"_Remark_"^"_XCode_"^"_Active
		Set flg=##class(DHCMed.DC.BTDoctor).Update(InStr,"^")
		If (flg<1) {
			Write "医生：flg="_flg_","_InStr,!
		}
	}
	Quit Count
}

ClassMethod ChangeBTABOBG(aHospCode As %String)
{
	Set Count=0
	Set xID=""
	For {
		Set xID=$o(^dbo.BTABOBGD(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^dbo.BTABOBGD(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		set Code     = $Lg(tmpInfo,2)
		set CName    = $Lg(tmpInfo,3)
		continue:CName=""
		set ABO      = $Lg(tmpInfo,4)
		set XCode    = xID
		set Active 	 = 1
		
		Set InStr=Code_$C(1)_CName_$C(1)_ABO_$C(1)_XCode_$C(1)_Active
		Set flg=##class(DHCMed.DC.LIS.BTABOBG).Update(InStr,$C(1))
		If (flg<1) {
			Write "血型：flg="_flg_","_InStr,!
		}
	}
	Quit Count
}

ClassMethod ChangeBTAntibiotics(aHospCode As %String)
{
	Set Count=0
	Set xID=""
	For {
		Set xID=$o(^dbo.BTAntibioticsD(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^dbo.BTAntibioticsD(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		set Code     = $Lg(tmpInfo,2)
		set CName    = $Lg(tmpInfo,3)
		continue:CName=""
		set HospCode = aHospCode
		set EName    = $Lg(tmpInfo,4)
		set SName    = $Lg(tmpInfo,5)
		set WCode    = $Lg(tmpInfo,6)
		set XCode    = xID
		set Active 	 = 1
		
		Set InStr=Code_$C(1)_CName_$C(1)_HospCode_$C(1)_EName_$C(1)_SName_$C(1)_WCode_$C(1)_XCode_$C(1)_Active
		Set flg=##class(DHCMed.DC.LIS.BTAntibiotics).Update(InStr,$C(1))
		If (flg<1) {
			Write "抗生素：flg="_flg_","_InStr,!
		}
	}
	Quit Count
}

ClassMethod ChangeBTOrganism(aHospCode As %String)
{
	Set Count=0
	Set xID=""
	For {
		Set xID=$o(^dbo.BTOrganismD(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^dbo.BTOrganismD(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		set Code     = $Lg(tmpInfo,2)
		set CName    = $Lg(tmpInfo,3)
		continue:CName=""
		set HospCode = aHospCode
		set EName    = $Lg(tmpInfo,4)
		set SName    = $Lg(tmpInfo,5)
		set WCode    = $Lg(tmpInfo,6)
		set XCode    = xID
		set Active 	 = 1
		
		Set InStr=Code_$C(1)_CName_$C(1)_HospCode_$C(1)_EName_$C(1)_SName_$C(1)_WCode_$C(1)_XCode_$C(1)_Active
		Set flg=##class(DHCMed.DC.LIS.BTOrganism).Update(InStr,$C(1))
		If (flg<1) {
			Write "细菌：flg="_flg_","_InStr,!
		}
	}
	Quit Count
}

ClassMethod ChangeBTSensitivity(aHospCode As %String)
{
	Set Count=0
	Set xID=""
	For {
		Set xID=$o(^dbo.BTSensitivityD(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^dbo.BTSensitivityD(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		set Code       = $Lg(tmpInfo,2)
		set CName      = $Lg(tmpInfo,3)
		continue:CName=""
		set ResultType = $Lg(tmpInfo,4)
		set XCode      = xID
		set Active 	   = 1
		
		Set InStr=Code_$C(1)_CName_$C(1)_ResultType_$C(1)_XCode_$C(1)_Active
		Set flg=##class(DHCMed.DC.LIS.BTSensitivity).Update(InStr,$C(1))
		If (flg<1) {
			Write "药敏结果：flg="_flg_","_InStr,!
		}
	}
	Quit Count
}

ClassMethod ChangeBTSpecimen(aHospCode As %String)
{
	Set Count=0
	Set xID=""
	For {
		Set xID=$o(^dbo.BTSpecimenD(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^dbo.BTSpecimenD(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		set Code     = $Lg(tmpInfo,2)
		set CName    = $Lg(tmpInfo,3)
		continue:CName=""
		set HospCode = aHospCode
		set EName    = $Lg(tmpInfo,5)
		set WCode    = $Lg(tmpInfo,8)
		set XCode    = xID
		set Active 	 = 1
		
		Set InStr=Code_$C(1)_CName_$C(1)_HospCode_$C(1)_EName_$C(1)_WCode_$C(1)_XCode_$C(1)_Active
		Set flg=##class(DHCMed.DC.LIS.BTSpecimen).Update(InStr,$C(1))
		If (flg<1) {
			Write "标本：flg="_flg_","_InStr,!
		}
	}
	Quit Count
}

ClassMethod ChangeBTTestCode(aHospCode As %String)
{
	Set Count=0
	Set xID=""
	For {
		Set xID=$o(^dbo.BTTestCodeD(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^dbo.BTTestCodeD(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		set Code     	 = $Lg(tmpInfo,2)
		set CName    	 = $Lg(tmpInfo,3)
		continue:CName=""
		set HospCode 	 = aHospCode
		set LName        = $Lg(tmpInfo,5)
		set EName        = $Lg(tmpInfo,6)
		set Synonym      = $Lg(tmpInfo,7)
		set Units        = $Lg(tmpInfo,8)
		set ResultFormat = $Lg(tmpInfo,9)
		set Precision    = $Lg(tmpInfo,10)
		set SCode        = $Lg(tmpInfo,14)
		set xTestSetDR   = $Lg(tmpInfo,22)
		set TestSetID=$o(^DHCMed.DC.LIS.BTTestSetI("IndexXCode"," "_$zcvt(aHospCode,"U")," "_$zcvt(xTestSetDR,"U"),0))
		Set TestSetDR    =TestSetID
		set XCode    	 = xID
		set Active 		 = 1
		
		Set InStr=Code_$C(1)_CName_$C(1)_HospCode_$C(1)_LName_$C(1)_EName_$C(1)_Synonym_$C(1)_Units_$C(1)_ResultFormat_$C(1)_Precision_$C(1)_SCode_$C(1)_TestSetDR_$C(1)_XCode_$C(1)_Active
		Set flg=##class(DHCMed.DC.LIS.BTTestCode).Update(InStr,$C(1))
		If (flg<1) {
			Write "检测项目：flg="_flg_","_InStr,!
		}
	}
	Quit Count
}

ClassMethod ChangeBTTestCodeSC(aHospCode As %String)
{
	Set Count=0
	Set xID=""
	For {
		Set xID=$o(^dbo.BTTestCodeCommentsD(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^dbo.BTTestCodeCommentsD(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		Set xTestCodeDR = $Lg(tmpInfo,2)
		Set TestCodeDR=$o(^DHCMed.DC.LIS.BTTestCodeI("IndexXCode"," "_$zcvt(aHospCode,"U")," "_$zcvt(xTestCodeDR,"U"),0))
		set Code       = $Lg(tmpInfo,3)
		set CName      = $Lg(tmpInfo,4)
		continue:CName=""
		set AbFlag     = $Lg(tmpInfo,5)
		set XCode      = xID
		set Active 	   = 1
		
		Set InStr=TestCodeDR_$C(1)_Code_$C(1)_CName_$C(1)_AbFlag_$C(1)_XCode_$C(1)_Active
		Set flg=##class(DHCMed.DC.LIS.BTTestCodeSC).Update(InStr,$C(1))
		If (flg<1) {
			Write "检测项目标准意见：flg="_flg_","_InStr,!
		}
	}
	Quit Count
}

ClassMethod ChangeBTTestSet(aHospCode As %String)
{
	Set Count=0
	Set xID=""
	For {
		Set xID=$o(^dbo.BTTestSetD(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^dbo.BTTestSetD(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		set Code        = $Lg(tmpInfo,2)
		set CName       = $Lg(tmpInfo,3)
		continue:CName=""
		set HospCode    = aHospCode
		set EName     	= $Lg(tmpInfo,5)
		set Description = $Lg(tmpInfo,6)
		set xSpecimenDR = $Lg(tmpInfo,10)
		Set SpecimenID=$o(^DHCMed.DC.LIS.BTSpecimenI("IndexXCode"," "_$zcvt(aHospCode,"U")," "_$zcvt(xSpecimenDR,"U"),0))
		Set SpecimenDR=SpecimenID
		set XCode       = xID
		set Active 	    = 1
		
		Set InStr=Code_$C(1)_CName_$C(1)_HospCode_$C(1)_EName_$C(1)_Description_$C(1)_SpecimenDR_$C(1)_XCode_$C(1)_Active
		Set flg=##class(DHCMed.DC.LIS.BTTestSet).Update(InStr,$C(1))
		If (flg<1) {
			Write "组套/医嘱：flg="_flg_","_InStr,!
		}
	}
	Quit Count
}

ClassMethod ChangeBTWorkGroup(aHospCode As %String)
{
	Set Count=0
	Set xID=""
	For {
		Set xID=$o(^dbo.BTWorkGroupD(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^dbo.BTWorkGroupD(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		
		set Code        = $Lg(tmpInfo,2)
		set CName       = $Lg(tmpInfo,3)
		continue:CName=""
		set HospCode    = aHospCode
		set xDepartmentDR = $Lg(tmpInfo,4)
		Set DepartmentID=$o(^DHCMed.DC.BTLocI("IndexXCode"," "_$zcvt(aHospCode,"U")," "_$zcvt(xDepartmentDR,"U"),0))
		Set DepartmentDR=DepartmentID
		set XCode       = xID
		set Active 	    = 1
		
		Set InStr=Code_$C(1)_CName_$C(1)_HospCode_$C(1)_DepartmentDR_$C(1)_XCode_$C(1)_Active
		Set flg=##class(DHCMed.DC.LIS.BTWorkGroup).Update(InStr,$C(1))
		If (flg<1) {
			Write "工作组：flg="_flg_","_InStr,!
		}
	}
	Quit Count
}

}
