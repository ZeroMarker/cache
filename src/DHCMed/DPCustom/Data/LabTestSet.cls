/// 名称: DHCMed.DPCustom.Data.LabTestSet
/// 描述: 与检验报告相关的数据接口
/// 编写者：zhufei
/// 编写日期: 2014-02-15
Class DHCMed.DPCustom.Data.LabTestSet Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 记录ID（TestSetRow）
Property RecordID As %String(TRUNCATE = 1);

/// 医嘱ID
Property OEItemID As %String(TRUNCATE = 1);

/// 医嘱代码
Property OEItemCode As %String(TRUNCATE = 1);

/// 医嘱名称
Property OEItemDesc As %String(TRUNCATE = 1);

/// 检验号
Property TestSetRow As %String(TRUNCATE = 1);

/// 送检日期
Property SubmissionDate As %String(TRUNCATE = 1);

/// 送检时间
Property SubmissionTime As %String(TRUNCATE = 1);

/// 标本代码
Property SpecimenCode As %String(TRUNCATE = 1);

/// 标本名称
Property SpecimenDesc As %String(TRUNCATE = 1);

/// 检验结果
Property TestData As list Of DHCMed.DPCustom.Data.LabTestSetData;

/// 检验结果（大文本）
Property TestDemo As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 耐药菌标记(0/1)
Property IsRBugs As %String(TRUNCATE = 1);

/// ESBLs标记(0/1)
Property IsESBLs As %String(TRUNCATE = 1);

/// 检测方法（镜检、培养、血清学）
Property AssayMethod As %String(TRUNCATE = 1);

/// 录入日期
Property EntryDate As %String(TRUNCATE = 1);

/// 录入时间
Property EntryTime As %String(TRUNCATE = 1);

/// 录入人
Property EntryUser As %String(TRUNCATE = 1);

/// 录入人名称
Property EntryUserDesc As %String(TRUNCATE = 1);

/// 审核日期
Property CheckDate As %String(TRUNCATE = 1);

/// 审核时间
Property CheckTime As %String(TRUNCATE = 1);

/// 审核人
Property CheckUser As %String(TRUNCATE = 1);

/// 审核人名称
Property CheckUserDesc As %String(TRUNCATE = 1);

/// 记录日期
Property ActDate As %String(TRUNCATE = 1);

/// 记录时间
Property ActTime As %String(TRUNCATE = 1);

/// 记录人
Property ActUser As %String(TRUNCATE = 1);

/// 记录人名称
Property ActUserDesc As %String(TRUNCATE = 1);

/// w ##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByAdm("1031")
ClassMethod GetDataByAdm(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aCategory As %String = "", aTestCode As %String = "", aResultType As %String = "1") As %ListOfObjects
{
	New (aEpisodeID,aDateFrom,aDateTo,aCategory,aTestCode,aResultType)
	Set return=##class(%Library.ListOfObjects).%New()
	Quit:(aEpisodeID="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-LabReport","")
	Set DataType=+DataType
	
	If DataType=1 {
		//DataType=1
	} Else {
		//DataType=0 默认取值HIS检验项目结果，东华检验系统，一个检验条码对应一条数据
		//DataType=0 北京协和其他公司检验系统，数据接到HIS中，一个检验条码对应多条数据
		Set OEOrdType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-OEOrdType","")
		Set OEOrdType=+OEOrdType
		
		Set OrdID=$o(^OEORD(0,"Adm",aEpisodeID,0))
		Quit:OrdID="" return
		
		Set xArcimID=""
		For {
			Set xArcimID=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID))
			Quit:xArcimID=""
			
			Set objArcim=##Class(DHCMed.Base.Arcim).GetObjById(xArcimID)
		 	Continue:'$IsObject(objArcim)
		 	Set ArcimType=objArcim.ARCICOrderType
		 	Continue:ArcimType'="L"
		 	//w objArcim.ARCICDesc_"///"_objArcim.ORCATDesc,!
			//根据医嘱大类或医嘱子类过滤
			If aCategory'="" {
		 		Continue:(aCategory'[objArcim.ARCICDesc)&&(aCategory'[objArcim.ORCATDesc)
		 	}
		 	//w objArcim.ARCICDesc_"///"_objArcim.ORCATDesc,!
		 	
			Set xSttDate=0
			For {
				Set xSttDate=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID,xSttDate))
				Quit:xSttDate=""
				
				Set xSubID=0
				For {
					Set xSubID=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID,xSttDate,xSubID))
					Quit:xSubID=""
					
				 	Set OEItemID=OrdID_"||"_xSubID
				 	If OEOrdType=0 { //滚执行记录模式
						Continue:(##class(DHCMed.DPCustom.Data.OEOrdItem).IsValidOEItem7(OEItemID)=0)
					} ElseIf OEOrdType=1 {  //滚医嘱模式
					 	Continue:(##class(DHCMed.DPCustom.Data.OEOrdItem).IsValidOEItem(OEItemID)=0)
					} Else {
						Continue
					}
					
					//update by zf 20160308 数据池相关程序修改(检验)
					Set TestSetRow=$p($g(^OEORD(OrdID,"I",xSubID,3)),"^",35) //检验结果ID
					
					If TestSetRow="" {
						Set SubID=xSubID
						Set OEItemID=OrdID_"||"_SubID
						Set ArcimID=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",2)
						Set ArcimCode=$p($g(^ARCIM(+ArcimID,1,1)),"^",1)
						Set ArcimDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2)
						Set SpecimenCode="",SpecimenDesc=""
						/* update by zf 修改检验医嘱标本取值方法
						Set SpecDr=$o(^OEORD(OrdID,"I",SubID,"SPEC",""),-1)
						Set:SpecDr'="" SpecimenCode=$p(^OEORD(OrdID,"I",SubID,"SPEC",SpecDr),"^",1)
						If SpecimenDesc="" {
							Set SpecimenCode=$p($g(^OEORD(OrdID,"I",SubID,8)),"^",16)  //标本 OEORI_Lab1
							Set:SpecimenCode'="" SpecimenDesc=$p($g(^DHCSpS("SPS",SpecimenCode)),"^",2)
						}
						*/
						Set tSpecimenInfo=##class(DHCMed.SSIO.FromHisSrv).GetOrdSpecimen(OrdID_"||"_SubID)
						Set SpecDr=$p(tSpecimenInfo,"^",1)
						Set SpecimenCode=$p(tSpecimenInfo,"^",2)
						Set SpecimenDesc=$p(tSpecimenInfo,"^",3)
						
						
						Set OESttDate=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",9)   //医嘱开始日期
						Set OESttTime=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",10)  //医嘱开始时间
						Set:OESttDate'="" OESttDate=$zd(OESttDate,3)
						Set:OESttTime'="" OESttTime=$zt(OESttTime,1)
						Set OEDoctor=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",11)  //开医嘱医生
						Set:OEDoctor'="" OEDoctor=$p($g(^CTPCP(+OEDoctor,1)),"^",2)
						
						//检测方法
						If (ArcimDesc["培养")||(ArcimDesc["尿沉渣") {
							Set AssayMethod="培养"
						} ElseIf (ArcimDesc["GS")||(ArcimDesc["涂片")  {
							Set AssayMethod="镜检"
						} Else {
							Set AssayMethod=""
						}
						
						Set obj=##Class(DHCMed.DPCustom.Data.LabTestSet).%New()
						If obj'="" Do obj.%Close()
						
						Set obj.RecordID       = OEItemID
						Set obj.OEItemID       = OEItemID
						Set obj.OEItemCode     = ArcimCode
						Set obj.OEItemDesc     = ArcimDesc
						Set obj.SpecimenCode   = SpecimenCode
						Set obj.SpecimenDesc   = SpecimenDesc
						Set obj.SubmissionDate = OESttDate
						Set obj.SubmissionTime = OESttTime
						Set obj.AssayMethod    = AssayMethod
						Set obj.ActDate        = OESttDate
						Set obj.ActTime        = OESttTime
						Set obj.ActUser        = OEDoctor
						Set obj.ActUserDesc    = OEDoctor
						
						Set ActDate=obj.ActDate
						Continue:ActDate=""
						Set tmpDate=ActDate
						Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
						Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
						Continue:(aDateFrom'="")&&(tmpDate<aDateFrom)
						Continue:(aDateTo'="")&&(tmpDate>aDateTo)
						
						//Do $system.OBJ.Dump(obj)
				    	Do return.Insert(obj)
					} Else {
						Set TestSetNo=##class(DHCMed.DC.LIS.LabTestSet).GetTSNoByTSRow(TestSetRow)
						Continue:TestSetNo=""
						Set xOrderNo=0
						For {
							Set xOrderNo=$o(^DHCMed.DC.LIS.LabReportI("IndexTestSetNo",TestSetNo,xOrderNo))
							Quit:xOrderNo=""
							
							Set xReportID=0
							For {
								Set xReportID=$o(^DHCMed.DC.LIS.LabReportI("IndexTestSetNo",TestSetNo,xOrderNo,xReportID))
								Quit:xReportID=""
								
						 		//根据检验项目代码过滤
								Set obj=..GetObjById0(xReportID,aTestCode,TestSetRow)
						 		Continue:'$IsObject(obj)
			 					
								Set ActDate=obj.ActDate
								Continue:ActDate=""
								Set tmpDate=ActDate
								Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
								Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
								//w tmpDate_"^"_aDateFrom_"^"_aDateTo,!
								Continue:(aDateFrom'="")&&(tmpDate<aDateFrom)
								Continue:(aDateTo'="")&&(tmpDate>aDateTo)
								
								//Do $system.OBJ.Dump(obj)
						    	Do return.Insert(obj)
							}
						}
					}
				}
			}
		}
	}
	Do return.%Close()
	
	Quit return
}

/// w ##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByID("372644||A010||1")
ClassMethod GetDataByID(aRecordID As %String) As DHCMed.DPCustom.Data.LabTestSet
{
	New (aRecordID)
	Set return=""
	Quit:(aRecordID="") return
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-LabReport","")
	Set DataType=+DataType
	
	Set obj=""
	//update by zf 20160308 数据池相关程序修改(检验)
	If DataType=1 {
		//DataType=1
	} Else {
		//DataType=0 默认取值HIS检验项目结果，东华检验系统，一个检验条码对应一条数据
		//DataType=0 北京协和其他公司检验系统，数据接到HIS中，一个检验条码对应多条数据
		
		Set TestSetRow=aRecordID
		Set TestSetNo=##class(DHCMed.DC.LIS.LabTestSet).GetTSNoByTSRow(TestSetRow)
		Quit:TestSetNo="" return
		Set xOrderNo=0
		For {
			Set xOrderNo=$o(^DHCMed.DC.LIS.LabReportI("IndexTestSetNo",TestSetNo,xOrderNo))
			Quit:xOrderNo=""
			
			Set xReportID=0
			For {
				Set xReportID=$o(^DHCMed.DC.LIS.LabReportI("IndexTestSetNo",TestSetNo,xOrderNo,xReportID))
				Quit:xReportID=""
				
		 		//根据检验项目代码过滤
		 		Set obj=..GetObjById0(xReportID,"",TestSetRow)
		 		Continue:'$IsObject(obj)
	 			//Do $system.OBJ.Dump(obj)
			}
		}
	}
	Set return=obj
	
	Quit return
}

/// 通过HIS系统获取数据对象
/// w ##Class(DHCMed.DPCustom.Data.LabTestSet).GetObjById0("124588||B001||1")
ClassMethod GetObjById0(aReportID As %String, aTestCode As %String = "", aTestSetRow = "") As DHCMed.DPCustom.Data.LabTestSet
{
	New (aReportID,aTestCode,aTestSetRow)
	Set return=""
	Quit:aReportID="" return
	
	Set:aTestCode'="" aTestCode=$zcvt(aTestCode,"U")
	
	Set objReport=##class(DHCMed.DC.LIS.LabReport).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	Set IsActive=objReport.IsActive
	Quit:IsActive'=1 return
	Set TestSetNo=objReport.TestSetNo
	Set OrderNo=objReport.OrderNo
	Set LabRepID=objReport.ReportID
	Set SpecimenCode="",SpecimenDesc=""
	If $IsObject(objReport.SpecimenDR) {
		Set SpecimenCode=objReport.SpecimenDR.Code
		Set SpecimenDesc=objReport.SpecimenDR.CName
	}
	
	Set objTestSet=##class(DHCMed.DC.LIS.LabTestSet).GetObjByTSRow(aTestSetRow)
	Quit:'$IsObject(objTestSet) return
	Set TestSetRow=objTestSet.TestSetRow
	Set EpisodeNo=objTestSet.EpisodeNo
	
	Set OrdID=$o(^OEORD(0,"EpisNo",EpisodeNo,0))
	Quit:OrdID="" return //无对应医嘱记录
	
	Set xSubID="",SubID=""
	For {
		Set xSubID=$o(^OEORD(0,"EpisNo",EpisodeNo,OrdID,xSubID))
		Quit:xSubID=""
		Set xTestSetRow=$p($g(^OEORD(OrdID,"I",xSubID,3)),"^",35)
		Continue:xTestSetRow'=TestSetRow
		Set SubID=xSubID
	}
	Quit:SubID="" return //无对应医嘱记录
	
	Set OEItemID=OrdID_"||"_SubID
	Set ArcimID=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",2)
	Set ArcimCode=$p($g(^ARCIM(+ArcimID,1,1)),"^",1)
	Set ArcimDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2)
	If SpecimenDesc="" {
		/* update by zf 修改检验医嘱标本取值方法
		Set SpecDr=$o(^OEORD(OrdID,"I",SubID,"SPEC",""),-1)
		Set:SpecDr'="" SpecimenCode=$p(^OEORD(OrdID,"I",SubID,"SPEC",SpecDr),"^",1)
		If SpecimenDesc="" {
			Set SpecimenCode=$p($g(^OEORD(OrdID,"I",SubID,8)),"^",16)  //标本 OEORI_Lab1
			Set:SpecimenCode'="" SpecimenDesc=$p($g(^DHCSpS("SPS",SpecimenCode)),"^",2)
		}
		*/
		Set tSpecimenInfo=##class(DHCMed.SSIO.FromHisSrv).GetOrdSpecimen(OrdID_"||"_SubID)
		Set SpecDr=$p(tSpecimenInfo,"^",1)
		Set SpecimenCode=$p(tSpecimenInfo,"^",2)
		Set SpecimenDesc=$p(tSpecimenInfo,"^",3)
	}
	Set OESttDate=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",9)   //医嘱开始日期
	Set OESttTime=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",10)  //医嘱开始时间
	Set:OESttDate'="" OESttDate=$zd(OESttDate,3)
	Set:OESttTime'="" OESttTime=$zt(OESttTime,1)
	
	//检测方法
	If (ArcimDesc["培养")||(ArcimDesc["尿沉渣") {
		Set AssayMethod="培养"
	} ElseIf (ArcimDesc["GS")||(ArcimDesc["涂片")  {
		Set AssayMethod="镜检"
	} Else {
		Set AssayMethod=""
	}
	
	Set AuthDate=objReport.AuthDate
	Quit:AuthDate="" return  //无审核时间，即为未审核
	Set AuthTime=objReport.AuthTime
	Set:AuthDate'="" AuthDate=$zd(AuthDate,3)
	Set:AuthTime'="" AuthTime=$zt(AuthTime,1)
	Set AuthUser=objReport.AuthUser
	Set ReceiveDate=objReport.ReceiveDate   //接收标本日期
	Set ReceiveTime=objReport.ReceiveTime
	Set:ReceiveDate'="" ReceiveDate=$zd(ReceiveDate,3)
	Set:ReceiveTime'="" ReceiveTime=$zt(ReceiveTime,1)
	Set ReceiveUser=objReport.ReceiveUser
	
	//记录ID、记录日期、记录时间、记录人
	Set RecordID=TestSetRow       //检验结果ID
	Set ActDate=AuthDate         //审核日期
	Set ActTime=AuthTime         //审核时间
	Set ActUser=AuthUser         //审核人
	If ActDate="" {
		Set ActDate=ReceiveDate     //录入日期
		Set ActTime=ReceiveTime     //录入时间
		Set ActUser=ReceiveUser     //录入人
	}
	
	Set obj=##Class(DHCMed.DPCustom.Data.LabTestSet).%New()
	If obj'="" Do obj.%Close()
	
	Set obj.RecordID       = OEItemID
	Set obj.OEItemID       = OEItemID
	Set obj.OEItemCode     = ArcimCode
	Set obj.OEItemDesc     = ArcimDesc
	Set obj.SpecimenCode   = SpecimenCode
	Set obj.SpecimenDesc   = SpecimenDesc
	Set obj.TestSetRow     = TestSetRow
	Set obj.SubmissionDate = ReceiveDate
	Set obj.SubmissionTime = ReceiveTime
	Set obj.AssayMethod    = AssayMethod
	Set obj.EntryDate      = ReceiveDate
	Set obj.EntryTime      = ReceiveTime
	Set obj.EntryUser      = ReceiveUser
	Set obj.EntryUserDesc  = ReceiveUser
	Set obj.CheckDate      = AuthDate
	Set obj.CheckTime      = AuthTime
	Set obj.CheckUser      = AuthUser
	Set obj.CheckUserDesc  = AuthUser
	Set obj.ActDate        = ActDate
	Set obj.ActTime        = ActTime
	Set obj.ActUser        = ActUser
	Set obj.ActUserDesc    = ActUser
	
	Set TestDemo="",IsRBugs=0,IsESBLs=0
	Set xTestCode=""
	For {
		Set xTestCode=$o(^DHCMed.DC.LIS.LabResultI("IndexReportID",LabRepID,xTestCode))
		Quit:xTestCode=""
		
		Set objTestCode=##class(DHCMed.DC.LIS.BTTestCode).GetObjById(xTestCode)
		Continue:'$IsObject(objTestCode)
		Set TCCode=objTestCode.Code
		Set TCCode=$zcvt(TCCode,"U")
		Set TCSCode=objTestCode.SCode
		Set TCSCode=$zcvt(TCSCode,"U")
		If aTestCode'="" {
			Set ActTestCode=0
	 		For indTC=1:1:$l(aTestCode,",") {
		 		Set tmpTestCode=$p(aTestCode,",",indTC)
		 		Continue:tmpTestCode=""
		 		Continue:(TCSCode'=tmpTestCode)&&(TCCode'=tmpTestCode)  //同时判断代码和缩写码
				Set ActTestCode=1
	 		}
		}
		Continue:(aTestCode'="")&&(ActTestCode=0)	//不符合退出
		Set xResultID=""
		For {
			Set xResultID=$o(^DHCMed.DC.LIS.LabResultI("IndexReportID",LabRepID,xTestCode,xResultID))
			Quit:xResultID=""
			
			Set objTSResult=..GetTestData0(xResultID)
			Continue:'$IsObject(objTSResult)
			
			Set:objTSResult.IsRBugs=1 IsRBugs=1
			Set:objTSResult.IsESBLs=1 IsESBLs=1
			Set:objTSResult.DataText'="" TestDemo=TestDemo_" "_objTSResult.DataText
			Set:objTSResult.Comments'="" TestDemo=TestDemo_" "_objTSResult.Comments
			
			//Do $system.OBJ.Dump(objTSResult)
			Do obj.TestData.Insert(objTSResult)
		}
	}
	Quit:obj.TestData.Count()<1 return
	Set:TestDemo'="" TestDemo=$e(TestDemo,2,$l(TestDemo))
	
	Set obj.IsRBugs        = IsRBugs
	Set obj.IsESBLs        = IsESBLs
	Set obj.TestDemo       = TestDemo
	//Do $System.OBJ.Dump(obj)
	
	Set return=obj
	Quit return
}

/// 通过HIS系统获取数据对象
ClassMethod GetTestData0(aResultID As %String) As DHCMed.DPCustom.Data.LabTestSetData
{
	New (aResultID)
	Set return=""
	Quit:(aResultID="") return
	
	Set objResult=##class(DHCMed.DC.LIS.LabResult).GetObjById(aResultID)
	Quit:'$IsObject(objResult) return
	Quit:'$IsObject(objResult.TestCodeDR) return
	
	Set TestCode=objResult.TestCodeDR.Code
	Set ItemDesc=objResult.TestCodeDR.CName    //检验项目描述
	Set ItemResult=objResult.Result  //结果
	Set ItemTextRes=objResult.TextRes  //定性结果
	Set ItemUnit=objResult.Unit    //检验项目的单位
	Set AbnorFlag=objResult.AbFlag   //异常标记
	Set AbnorFlag=$tr(AbnorFlag,$c(28),"")
	Set ItemRangs=objResult.RefRanges   //参考范围
	Set Synonym=objResult.TestCodeDR.Synonym     //英文缩写
	Set DataFormat=objResult.ResultFormat  //输出数据类型
	Set:DataFormat="M" DataFormat="V" //V表示细菌结果
	Set Comments=objResult.MDRResult
	If Comments="" {
		Set Comments=objResult.ResNoes
	} Else {
		Set Comments=Comments_";"_objResult.ResNoes
	}
	
	Set IsESBLs=0,IsRBugs=0
	
	//检测“超广谱β-内酰胺酶（ESBLs）细菌”结果
	If ($zcvt(ItemDesc,"U")["ESBLS")||(ItemDesc["β-内酰胺酶")||(ItemDesc["β-Lac") {
		Set:(ItemResult["阳")&&(ItemResult["+") IsESBLs=1
	}
	If ($zcvt(Comments,"U")["ESBLS")||(Comments["β-内酰胺酶")||(Comments["β-Lac") {
		Set IsESBLs=1
	}
	If ($zcvt(ItemResult,"U")["ESBL(+)") {
		Set IsESBLs=1
	}
	
	Set Antibiotics=""
	//耐药菌监测+药敏试验结果
	Set Count=objResult.ChildSen
	For indS=1:1:Count {
		Set objSen=objResult.ChildSen.GetAt(indS)
		Continue:'$IsObject(objSen)
		Continue:'$IsObject(objSen.AntibioticsDR)
		
		Set AntiCode=objSen.AntibioticsDR.Code
		Set AntiName=objSen.AntibioticsDR.CName
		Continue:AntiName=""
		Set SenTestCode=objSen.SensitivityDR.Code
		Set SenTestDesc=objSen.SensitivityDR.CName
		
		If ($zcvt(AntiName,"U")["ESBLS")||(AntiName["β-内酰胺酶")||(AntiName["β-Lac") {
			Set:(SenTestDesc["阳")&&(SenTestDesc["+") IsESBLs=1
			Set:(SenTestDesc["阳")&&(SenTestDesc["+") IsRBugs=1  //产ESBLs阳性也表示耐药
			Continue
		} ElseIf ($zcvt(AntiName,"U")["ESBL(+)") {
			Set IsESBLs=1
			Set IsRBugs=1  //产ESBLs阳性也表示耐药
			Continue
		} Else {
			Set:SenTestCode="R" IsRBugs=1
		}
		
		Set tmpAntibiotic=AntiCode_$c(2)_AntiName_$c(2)_SenTestCode_$c(2)_SenTestDesc
		Set tmpAntibiotic=$tr(tmpAntibiotic,$c(28),"")
		Set tmpAntibiotic=$tr(tmpAntibiotic,$c(1),"")
		Set Antibiotics=Antibiotics_$c(1)_tmpAntibiotic
	}
	Set:Antibiotics'="" Antibiotics=$e(Antibiotics,2,$l(Antibiotics))
	
	Set TestData=TestCode
	Set TestData=TestData_$c(0)_ItemDesc
	Set TestData=TestData_$c(0)_DataFormat
	Set TestData=TestData_$c(0)_ItemResult   //结果
	Set TestData=TestData_$c(0)_ItemTextRes  //定性结果
	Set TestData=TestData_$c(0)_ItemUnit
	Set TestData=TestData_$c(0)_AbnorFlag
	Set TestData=TestData_$c(0)_ItemRangs
	Set TestData=TestData_$c(0)_Synonym
	Set TestData=TestData_$c(0)_Antibiotics  //$c(1) $c(2) 分割字符串
	Set TestData=TestData_$c(0)_IsRBugs
	Set TestData=TestData_$c(0)_IsESBLs
	Set TestData=TestData_$c(0)_Comments
	Set return=##class(DHCMed.DPCustom.Data.LabTestSetData).GetObj(TestData)
	Quit return
}

}
