/// ClassName:    DHCHAI.IO.ToEOLabSrv
/// Description:  环境卫生学职业暴露对接检验系统相关服务类
/// Creator：     zhoubo
/// CreatDate:    2021-08-31
Class DHCHAI.IO.ToEOLabSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2021-09-02
/// Description:  根据条码号获取院感检验标本信息（检验扫条码）
/// Table：       DHCHAI.DP.LabInfVisitNumber
/// Input：       aEpisodeID:就诊号
/// Return：      %String
/// w ##class(DHCHAI.IO.ToEOLabSrv).GetLabInfoByCode("O00001002")
ClassMethod GetLabInfoByCode(aBarCode As %String) As %String
{
	New (aBarCode)
	Set return=""
	Quit:(aBarCode="") return
	
	// 检验条码索引 唯一性
	Set LabVID = $o(^DHCHAI.DP.LabInfVisitNumberI("IndexLabEpisodeNo"," "_aBarCode,0))
	Set:LabVID="" LabVID=$o(^DHCHAI.DP.LabInfVisitNumberI("IndexLabEpisodeNo"," "_aBarCode,0))
	Set objLab = ##class(DHCHAI.DP.LabInfVisitNumber).GetObjById(LabVID)
	Quit:('$IsObject(objLab)) return
	Set LabEpisodeNo    = objLab.LabEpisodeNo    // 条码号
	Set SpecDesc        = objLab.LabSpecimen     // 标本(监测对象)
	Set LocCode         = objLab.LabLocDr.BTCode
	Set LocDesc         = objLab.LabLocDr.BTDesc // 送检科室
	Set TestSetCode     = ""                     // 医嘱外部代码
	Set objTSExtCode    = objLab.LabInfTSExtCodeDr
	If ($IsObject(objTSExtCode)){
		Set TestSetCode = objTSExtCode.BTExtCode
	}
	Quit:TestSetCode="" return
	Set RequestDate     = objLab.LabApplyDate    // 申请日期
	Set:RequestDate'="" RequestDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RequestDate)
	Set RequestTime     = objLab.LabApplyTime    // 申请时间
	Set:RequestTime'="" RequestTime=$zt(RequestTime)
	Set LabApplyUser    = objLab.LabApplyUser
	Set RequestUserCode = $p(LabApplyUser,"|",2) // 申请用户代码
	Set RequestUserName = $p(LabApplyUser,"|",3) // 申请用户名称
	Set CollectDate     = objLab.LabCollDate     // 采集日期
	Set:CollectDate'="" CollectDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollectDate)
	Set CollectTime     = objLab.LabCollTime     // 采集时间
	Set:CollectTime'="" CollectTime=$zt(CollectTime)
	Set LabCollUser = objLab.LabCollUser
	Set CollectUserCode = $p(LabApplyUser,"|",3) // 采集用户代码
	Set CollectUserName = $p(LabApplyUser,"|",3) // 采集用户名称
	
	Set return = LabEpisodeNo_"^"_SpecDesc_"^"_LocCode_"^"_LocDesc_"^"_TestSetCode_"^"_RequestDate_"^"_RequestTime
	Set return = return_"^"_RequestUserCode_"^"_RequestUserName_"^"_CollectDate_"^"_CollectTime_"^"_CollectUserCode_"^"_CollectUserName
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2021-09-02
/// Description:  根据日期同步环境卫生学和职业暴露检验信息
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// Return：      处理同步数量
/// w ##class(DHCHAI.IO.ToEOLabSrv).SyncYGLabReport("","2021-11-26","2022-09-08")
ClassMethod SyncYGLabReport(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:(aDateFrom="")||(aDateTo="") return
	Set $ZT="SyncYGLabReportErr"
	If (aDateFrom'["-"){
		Set aDateFrom=$zd(aDateFrom,3)
	}
	If (aDateTo'["-"){
		Set aDateTo=$zd(aDateTo,3)
	}
	Set aSCode ="LIS01"
	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	// 版本说明：
	// ""      ：从东华检验（BS版）直接获取检验报告信息
	// LISC1.0 ：从平台（文档）获取检验报告信息
	// LISC2.0 ：从平台（结构化）获取检验报告信息
	Set LabRepVer=##class(DHCHAI.BT.Config).GetValByCode("DPLabReportVer")
	
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
	
	If LabRepVer["LISC" {  // 从平台获取数据
		Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
		Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
		
		For xDate = (aDateFrom-3):1:aDateTo{		
			Set xTime = ""
			For {
				Set xTime = $o(^DHCHAI.DP.LabInfVisitNumberI("IndexRecDateTime"," "_aSCode,xDate,xTime))
				Quit:xTime=""
				Set xVisitNumberDr=""
				For {
					Set xVisitNumberDr=$o(^DHCHAI.DP.LabInfVisitNumberI("IndexRecDateTime"," "_aSCode,xDate,xTime,xVisitNumberDr))
					Quit:xVisitNumberDr=""
					
					Set VisitData=$g(^DHCHAI.DP.LabInfVisitNumberD(xVisitNumberDr))
					Continue:VisitData=""
					Set LabIsActive = $lg(VisitData,20)
					Continue:LabIsActive'=1
					Set LabEpisodeNo = $lg(VisitData,2)
					Set LabSpecimen  = $lg(VisitData,5)
					// 根据条码号获取报告ID串
					Set ReportIDs = ##class(web.DHCENS.STBLL.Method.PostReportInfo).QryLISRptIDByLabNo(LabEpisodeNo)
					
					Set rs=##Class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryTSInfo")
					Set sc=rs.Execute(ReportIDs)
				  	If $$$ISERR(sc) {
					  	Do $System.Status.DisplayError(sc)
					  	Continue
				  	}
				  	While (rs.Next()){
					    Do rowData.Clear()  //清空数组
						Do rowData.SetAt(rs.Data("ReportDR"),"ReportID")              // 检验报告ID
						Do rowData.SetAt(LabEpisodeNo,"VisitNumber")        // 条码号
						Do rowData.SetAt(LabSpecimen,"SpecCode")              // 标本代码
						Do rowData.SetAt(LabSpecimen,"SpecDesc")              // 标本
						Do rowData.SetAt(rs.Data("AppDeptCode"),"LocCode")                // 送检科室代码
						Do rowData.SetAt(rs.Data("AppDeptDesc"),"LocDesc")                // 送检科室
						Do rowData.SetAt(rs.Data("CollectionDate"),"CollDate")
						Do rowData.SetAt(rs.Data("CollectionTime"),"CollTime") 
						Do rowData.SetAt(rs.Data("CollectionUserCode"),"CollUserCode")
						Do rowData.SetAt(rs.Data("CollectionUserName"),"CollUserName")
						Do rowData.SetAt(rs.Data("ReceiveDate"),"RecDate")
						Do rowData.SetAt(rs.Data("ReceiveTime"),"RecTime")
						Do rowData.SetAt("","RecUserCode")
						Do rowData.SetAt("","RecUserName")
						Do rowData.SetAt(rs.Data("TestCodeCode"),"TestSetCode")        // 检验结果（医嘱表）
						Do rowData.SetAt("","TestSetName")        // 检验医嘱
						Do rowData.SetAt(rs.Data("ReportDR"),"OrderNo")                // 报告序号
						Do rowData.SetAt(rs.Data("RepStatus"),"RepStatus")          
						Do rowData.SetAt(rs.Data("AuthDate"),"EntryDate")            // 初审日期
						Do rowData.SetAt(rs.Data("AuthTime"),"EntryTime")
						Do rowData.SetAt(rs.Data("CheckUserCode"),"EntryUserCode")
						Do rowData.SetAt(rs.Data("CheckUserName"),"EntryUserName")
						Do rowData.SetAt(rs.Data("AuthDate"),"AuthDate")              // 审核日期
						Do rowData.SetAt(rs.Data("AuthTime"),"AuthTime")
						Do rowData.SetAt(rs.Data("CheckUserCode"),"AuthUserCode")      // 审核人代码
						Do rowData.SetAt(rs.Data("CheckUserName"),"AuthUserName")      // 审核人
						
						Set EHBarCode = LabEpisodeNo                      // 条码号
						Set VisitNumberID=##class(DHCHAI.DP.LabInfVisitNumber).GetObjByCode(EHBarCode)
						Continue:VisitNumberID=""
						Do rowData.SetAt(VisitNumberID,"VisitNumberID")               // 院感标本ID
						//保存检验报告
						Set ReportDr=..SaveVisitReport(rowData,aSCode)
						Continue:(+ReportDr)<1
						//保存检验结果
						Set LReportID = rowData.GetAt("ReportID")  //LIS报告ID
						If (LabRepVer="LISC1.0"){
							Set ResultDatas=##Class(DHCHAI.DI.DIO.EnsFromLis1Srv).GetRepResult(LReportID)
						} ElseIf (LabRepVer="LISC2.0"){
							Set ResultDatas=##Class(DHCHAI.DI.DIO.EnsFromLis2Srv).GetRepResult(LReportID)
						}
						For indRst=1:1:$listlength(ResultDatas) {
							Set ResultData=$listget(ResultDatas,indRst)
							Continue:ResultData=""
							
							Set ResultInfo=""
							Set $p(ResultInfo,"^",1)=ReportDr
							Set $p(ResultInfo,"^",2)=$p(ResultData,"^",2)   //TCCode
							Set $p(ResultInfo,"^",3)=$p(ResultData,"^",3)   //TCDesc
							Set $p(ResultInfo,"^",4)=$p(ResultData,"^",4)   //RstFormat
							Set $p(ResultInfo,"^",5)=$p(ResultData,"^",6)   //Result
							Set $p(ResultInfo,"^",6)=$p(ResultData,"^",6)   //TextRes
							Set $p(ResultInfo,"^",7)=$p(ResultData,"^",7)   //ResNoes
							Set $p(ResultInfo,"^",8)=$p(ResultData,"^",8)   //AbFlag
							Set $p(ResultInfo,"^",9)=$p(ResultData,"^",9)   //Unit
							Set $p(ResultInfo,"^",10)=$p(ResultData,"^",10) //RefRanges
							Set $p(ResultInfo,"^",11)=$p(ResultData,"^",11) //MDRResult
							
							Set ResultDr=..SaveVisitRepResult(ResultInfo,aSCode)
							Continue:(+ResultDr)<1
						}
						// 保存结果到环境卫生学结果表
						Set EHReportID=..SaveEHRepResult(ReportDr,EHBarCode)
					   
						//计数
						Set Count=Count+1
				    }
				}
			}
		}
	}Else {
		Set $NAMESPACE = "DHC-LISDATA"
		Set rs=##Class(%ResultSet).%New("Service.LIS.Report.DHCReportServiceYG:QryYGReportByLabNo")
	  	Set sc=rs.Execute("",aDateFrom,aDateTo,"","","","","","","","","","","","","")
	  	Set $NAMESPACE = "DHC-APP"
	  	If $$$ISERR(sc) {
		  	Do $System.Status.DisplayError(sc)
		  	Quit return
	  	}
	  	While (rs.Next()){
		  	Do rowData.Clear()  //清空数组
			Do rowData.SetAt(rs.Data("ReportID"),"ReportID")              // 检验报告ID
			Do rowData.SetAt(rs.Data("VisitNumber"),"VisitNumber")        // 条码号
			Do rowData.SetAt(rs.Data("SpecCode"),"SpecCode")              // 标本代码
			Do rowData.SetAt(rs.Data("SpecDesc"),"SpecDesc")              // 标本
			Do rowData.SetAt(rs.Data("LocCode"),"LocCode")                // 送检科室代码
			Do rowData.SetAt(rs.Data("LocDesc"),"LocDesc")                // 送检科室
			Do rowData.SetAt(rs.Data("CollDate"),"CollDate")
			Do rowData.SetAt(rs.Data("CollTime"),"CollTime") 
			Do rowData.SetAt(rs.Data("CollUserCode"),"CollUserCode")
			Do rowData.SetAt(rs.Data("CollUserName"),"CollUserName")
			Do rowData.SetAt(rs.Data("RecDate"),"RecDate")
			Do rowData.SetAt(rs.Data("RecTime"),"RecTime")
			Do rowData.SetAt(rs.Data("RecUserCode"),"RecUserCode")
			Do rowData.SetAt(rs.Data("RecUserName"),"RecUserName")
			Do rowData.SetAt(rs.Data("TestSetCode"),"TestSetCode")        // 检验结果（医嘱表）
			Do rowData.SetAt(rs.Data("TestSetName"),"TestSetName")        // 检验医嘱
			Do rowData.SetAt(rs.Data("OrderNo"),"OrderNo")                // 报告序号
			Do rowData.SetAt(rs.Data("RepStatus"),"RepStatus")          
			Do rowData.SetAt(rs.Data("EntryDate"),"EntryDate")            // 初审日期
			Do rowData.SetAt(rs.Data("EntryTime"),"EntryTime")
			Do rowData.SetAt(rs.Data("EntryUserCode"),"EntryUserCode")
			Do rowData.SetAt(rs.Data("EntryUserName"),"EntryUserName")
			Do rowData.SetAt(rs.Data("AuthDate"),"AuthDate")              // 审核日期
			Do rowData.SetAt(rs.Data("AuthTime"),"AuthTime")
			Do rowData.SetAt(rs.Data("AuthUserCode"),"AuthUserCode")      // 审核人代码
			Do rowData.SetAt(rs.Data("AuthUserName"),"AuthUserName")      // 审核人
			Set EHBarCode = rs.Data("VisitNumber")                        // 条码号
			Set VisitNumberID=##class(DHCHAI.DP.LabInfVisitNumber).GetObjByCode(EHBarCode)
			Continue:VisitNumberID=""
			Do rowData.SetAt(VisitNumberID,"VisitNumberID")               // 院感标本ID
			//保存检验报告
			Set ReportDr=..SaveVisitReport(rowData,aSCode)
			Continue:(+ReportDr)<1
			//保存检验结果
			Set LReportID = rowData.GetAt("ReportID")  //LIS报告ID
			Set ResultDatas=##Class(DHCHAI.DI.DIO.FromYGLisSrv).GetRepResult(LReportID)
			For indRst=1:1:$listlength(ResultDatas) {
				Set ResultData=$listget(ResultDatas,indRst)
				Continue:ResultData=""
				
				Set ResultInfo=""
				Set $p(ResultInfo,"^",1)=ReportDr
				Set $p(ResultInfo,"^",2)=$p(ResultData,"^",2)   //TCCode
				Set $p(ResultInfo,"^",3)=$p(ResultData,"^",3)   //TCDesc
				Set $p(ResultInfo,"^",4)=$p(ResultData,"^",4)   //RstFormat
				Set $p(ResultInfo,"^",5)=$p(ResultData,"^",6)   //Result
				Set $p(ResultInfo,"^",6)=$p(ResultData,"^",6)   //TextRes
				Set $p(ResultInfo,"^",7)=$p(ResultData,"^",7)   //ResNoes
				Set $p(ResultInfo,"^",8)=$p(ResultData,"^",8)   //AbFlag
				Set $p(ResultInfo,"^",9)=$p(ResultData,"^",9)   //Unit
				Set $p(ResultInfo,"^",10)=$p(ResultData,"^",10) //RefRanges
				Set $p(ResultInfo,"^",11)=$p(ResultData,"^",11) //MDRResult
				
				Set ResultDr=..SaveVisitRepResult(ResultInfo,aSCode)
				Continue:(+ResultDr)<1
			}
			// 保存结果到环境卫生学结果表
			Set EHReportID=..SaveEHRepResult(ReportDr,EHBarCode)
			//计数
			Set Count=Count+1
	    }
	}
	Set return=Count
	
	Quit return
SyncYGLabReportErr
	Set return="-999^"_$ZError
	Quit return
}

/// w ##class(DHCHAI.IO.ToEOLabSrv).SaveEHRepResult(1,"2021090900201")
ClassMethod SaveEHRepResult(aReportDr As %String, aEHBarCode As %String) As %String
{
	New (aReportDr,aEHBarCode)
	Set return=0
	Quit:(aReportDr="")||(aEHBarCode="") return
	Quit:aEHBarCode'["E" return
	Set $ZT="SaveEHRepResultErr"
	
	// 条码格式 2021090800201 解析条码获取报告信息
	Set RepApplayDate = +$e(aEHBarCode,$l(aEHBarCode)-10,$l(aEHBarCode)-5) // 报告顺序码   //条码变化修改
	Set RepOrderCode  = +$e(aEHBarCode,$l(aEHBarCode)-4,$l(aEHBarCode)-2)  // 报告顺序码
	Set SpecNumber    = +$e(aEHBarCode,$l(aEHBarCode)-1,$l(aEHBarCode))    // 标本顺序号
	Set RepApplayDate = $zdh("20"_RepApplayDate,8)
	Quit:RepApplayDate="" return
	Set EHRepID = $o(^DHCHAI.IR.EnviHyReportI("IdxApplyCode",RepApplayDate,RepOrderCode,""))
	Quit:EHRepID="" return
	Set objRep = ##class(DHCHAI.IR.EnviHyReport).GetObjById(EHRepID)
	Quit:'$IsObject(objRep) return
	Set objLabRep = ##class(DHCHAI.DP.LabInfVisitReport).GetObjById(aReportDr)
	Quit:'$IsObject(objLabRep) return
	Set RstTypeDesc="",Result="",BactDesc="",EHResume=""
	Set xRepRstID=""
	For {
		Set xRepRstID=$o(^DHCHAI.DP.LabInfVisitResultI("IndexLabReportDr",aReportDr,xRepRstID))
		Quit:xRepRstID=""			  
		Set objRepRst=##class(DHCHAI.DP.LabInfVisitResult).GetObjById(xRepRstID)
		Continue:'$IsObject(objRepRst)
		
		Set LabTestDesc  = objRepRst.LabTestDesc     // 检验项目名称
		Set LabTestCode  = objRepRst.LabTestCode     // 检验项目代码
		Set LabRstFormat = objRepRst.LabRstFormat    // 结果类型（数字:N、文本:T、列表:S、血型ABO:A、RH血型:R、细菌:M）
		Set LabResult    = objRepRst.LabResult       // 检测结果
		Set LabTextRes   = objRepRst.LabTextRes      // 定性结果
		Set LabResNoes   = objRepRst.LabResNoes      // 结果说明
		Set LabAbFlag    = objRepRst.LabAbFlag       // 异常提示
		Set LabRefRanges = objRepRst.LabRefRanges    // 参考范围
		//菌落数
		If (LabTestCode="EH0001"){
			Set RstTypeDesc ="菌落数"
			Set Result = LabResult
			Set:(+Result)="0" RstTypeDesc="未检出"
			If ((Result[">")||(Result["大于")){
				Set RstTypeDesc ="大于"
				Set:Result[">" Result =+$p(Result,">",2)
				Set:Result["大于" Result =+$p(Result,"大于",2)
			}
			If ((Result["<")||(Result["小于")){
				Set RstTypeDesc ="小于"
				Set:Result["<" Result =+$p(Result,"<",2)
				Set:Result["小于" Result =+$p(Result,"小于",2)
			}
		}
		//细菌
		If (LabTestCode="EH0002"){
			Set:LabResult'="" RstTypeDesc ="菌落数"
			Set BactDesc = LabResult
		}
		//检验结果
		If (LabTestCode="EH0003")&&(LabResult'=""){
			If (LabResult="阳性"){
				Set RstTypeDesc ="阳性"
			}ElseIf (LabResult="阴性"){
				Set RstTypeDesc ="阴性"
			}Else{
				Set RstTypeDesc ="阴性"
			}
		}
	}
	
	Set BactID=""
	Set objBact=##class(DHCHAI.DP.LabBacteria).GetObjByCodeDesc("",BactDesc)
	If $IsObject(objBact){
		Set BactID=objBact.%Id()
	}
	Set RstTypeID=""
	Set objRstType=##class(DHCHAI.BT.Dictionary).GetObjByDesc("EHRstType",RstTypeDesc)
	If $IsObject(objRstType){
		Set RstTypeID=objRstType.%Id()
	}
	Set InputStr = EHRepID_"^^"_Result_"^"_BactID_"^"_""_"^"_SpecNumber_"^"_RstTypeID
	Set flg = ##class(DHCHAI.IR.EnviHyRepResult).Update(InputStr,"^")
	If (+flg)>0 {
		//保存结果明细操作日志
		Set BarCode=+$e(aEHBarCode,2,$l(aEHBarCode))
		Set InputStr=EHRepID_"^"_""_"^"_""_"^"_4_"^"_BarCode_"^"_""_"^"_1
		Set flg=##Class(DHCHAI.IR.EnviHyReportLog).Update(InputStr,"^")	// 保存日志
		
		Set LabRegDate  = objLabRep.LabRegDate
		Set LabRegTime  = objLabRep.LabRegTime
		Set LabAuthDate = objLabRep.LabAuthDate
		Set LabAuthTime = objLabRep.LabAuthTime
		If (LabRegDate="")&&(LabAuthDate'=""){
			Set LabRegDate = LabAuthDate
			Set LabRegTime = LabAuthTime
		}
		Set LabRegUser   = objLabRep.LabRegUser  // 录入人（ID|Code|Desc）
		Set RepUserCode  = $p(LabRegUser,"|",2)
		Set RepUserDesc  = $p(LabRegUser,"|",3)
		Set RepUerID     = ##class(DHCHAI.BT.SysUser).GetIDByCode(RepUserCode)
		Set LabAuthUser  = objLabRep.LabAuthUser  // 审核人（ID|Code|Desc）
		Set AuthUserCode = $p(LabAuthUser,"|",2)
		Set AuthUserDesc = $p(LabAuthUser,"|",3)
		Set AuthUerID    = ##class(DHCHAI.BT.SysUser).GetIDByCode(AuthUserCode)
		
		//更新报告状态信息
		Set InputStr = EHRepID
		Set InputStr = InputStr_"^"_"4"
		Set InputStr = InputStr_"^"_""
		Set InputStr = InputStr_"^"_RepUerID
		Set InputStr = InputStr_"^"_LabRegDate
		Set InputStr = InputStr_"^"_LabRegTime
		Set flg = ##class(DHCHAI.IR.EnviHyReport).UpdateStatus(InputStr)
		// 保存审核信息
		If (LabAuthDate'=""){
			//保存结果明细操作日志
			Set BarCode=+$e(aEHBarCode,2,$l(aEHBarCode))
			Set InputStr=EHRepID_"^"_""_"^"_AuthUerID_"^"_5_"^"_BarCode_"^"_""_"^"_1
			Set flg=##Class(DHCHAI.IR.EnviHyReportLog).Update(InputStr,"^")	// 保存日志
			
			//更新报告状态信息
			Set InputStr = EHRepID
			Set InputStr = InputStr_"^"_"5"
			Set InputStr = InputStr_"^"_""
			Set InputStr = InputStr_"^"_AuthUerID
			Set InputStr = InputStr_"^"_LabAuthDate
			Set InputStr = InputStr_"^"_LabAuthTime
			Set flg = ##class(DHCHAI.IR.EnviHyReport).UpdateStatus(InputStr)
			
		}
	}
	
	Quit EHRepID
	
SaveEHRepResultErr
	Set return="-999^"_$ZError
	Quit return
}

ClassMethod SaveVisitReport(rd As %ArrayOfDataTypes, aSCode As %String) As %String
{
	New (rd,aSCode)
	Set return=0
	Quit:(rd="")||(aSCode="") return
	
	Set $ZT="SaveVisitReportErr"
	
	Set VisitNumberID = rd.GetAt("VisitNumberID")    // 检验标本ID
	Set ReportID      = rd.GetAt("ReportID")         // 检验报告ID
	Set VisitNumber   = rd.GetAt("VisitNumber")      // 条码号
	Set SpecCode      = rd.GetAt("SpecCode")         // 标本代码
	Set SpecDesc      = rd.GetAt("SpecDesc")         // 标本
	Set LocCode       = rd.GetAt("LocCode")          // 送检科室代码
	Set LocDesc       = rd.GetAt("LocDesc")          // 送检科室
	Set CollDate      = rd.GetAt("CollDate")
	Set CollTime      = rd.GetAt("CollTime")
	Set CollUserCode  = rd.GetAt("CollUserCode")
	Set CollUserName  = rd.GetAt("CollUserName")
	Set RecDate       = rd.GetAt("RecDate")
	Set RecTime       = rd.GetAt("RecTime")
	Set RecUserCode   = rd.GetAt("RecUserCode")
	Set RecUserName   = rd.GetAt("RecUserName")
	Set TestSetCode   = rd.GetAt("TestSetCode")       // 检验结果（医嘱表）
	Set TestSetName   = rd.GetAt("TestSetName")       // 检验医嘱
	Set OrderNo       = rd.GetAt("OrderNo")           // 报告序号
	Set RepStatus     = rd.GetAt("RepStatus")          
	Set EntryDate     = rd.GetAt("EntryDate")         // 初审日期
	Set EntryTime     = rd.GetAt("EntryTime")
	Set EntryUserCode = rd.GetAt("EntryUserCode")
	Set EntryUserName = rd.GetAt("EntryUserName")
	Set AuthDate      = rd.GetAt("AuthDate")          // 审核日期
	Set AuthTime      = rd.GetAt("AuthTime")
	Set AuthUserCode  = rd.GetAt("AuthUserCode")      // 审核人代码
	Set AuthUserName  = rd.GetAt("AuthUserName")      // 审核人
	
	Quit:(ReportID="")||(VisitNumberID="")||(VisitNumber="") return
	Quit:(AuthDate="")||(AuthTime="") return
	Set XCode=ReportID
	Set VisitReportDr=""
	Set objVisitReport = ##class(DHCHAI.DP.LabInfVisitReport).GetObjByXCode(aSCode,XCode)
	If $IsObject(objVisitReport){
		Set VisitReportDr=objVisitReport.%Id()
	}
	/// 检验外部码（检验医嘱/检验组套）
    /// Property LabInfTSExtCodeDr As DHCHAI.DP.LabInfTestSetExt;
    Set VisitTestSetDr = ""  
    
	Set InputStr = VisitReportDr
	Set InputStr = InputStr_"^"_VisitNumberID
	Set InputStr = InputStr_"^"_ReportID
	Set InputStr = InputStr_"^"_OrderNo
	Set InputStr = InputStr_"^"_RepStatus
	Set InputStr = InputStr_"^"_RecDate
	Set InputStr = InputStr_"^"_RecTime
	Set InputStr = InputStr_"^"_""_"|"_RecUserCode_"|"_RecUserName
	Set InputStr = InputStr_"^"_AuthDate
	Set InputStr = InputStr_"^"_AuthTime
	Set InputStr = InputStr_"^"_""_"|"_AuthUserCode_"|"_AuthUserName
	Set InputStr = InputStr_"^"_VisitTestSetDr
	Set InputStr = InputStr_"^"_aSCode
	Set InputStr = InputStr_"^"_ReportID  // 记录索引
	Set InputStr = InputStr_"^"_"1"
	Set InputStr = InputStr_"^"_+$h
	Set InputStr = InputStr_"^"_+$p($h,",",2)
	
	Set VisitReportDr = ##class(DHCHAI.DP.LabInfVisitReport).Update(InputStr,"^")
	If (+VisitReportDr)<0 {
		//记录错误日志
		Set ErrClass  = "DHCHAI.DP.LabInfVisitReport"
		Set ErrMethod = "Update"
		Set ErrArgStr = $lb(InputStr,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(VisitNumberID,ErrClass,ErrMethod,ErrArgStr)
	}
	Quit:(+VisitReportDr)<0 return
	Set return=VisitReportDr
	
	
	Quit return
	
SaveVisitReportErr
	Set return="-999^"_$ZError
	Quit return
}

ClassMethod SaveVisitRepResult(aInputStr As %String, aSCode As %String) As %String
{
	New (aInputStr,aSCode)
	Set return=0
	Quit:(aInputStr="")||(aSCode="") return
	
	Set $ZT="SaveVisitRepResultErr"
	
	Set ReportDr     = $p(aInputStr,"^",1)
	Set TCCode       = $p(aInputStr,"^",2)
	Set TCDesc       = $p(aInputStr,"^",3)
	Set RstFormat    = $p(aInputStr,"^",4)
	Set Result       = $p(aInputStr,"^",5)
	Set TextRes      = $p(aInputStr,"^",6)
	Set ResNoes      = $p(aInputStr,"^",7)
	Set AbFlag       = $p(aInputStr,"^",8)
	Set Unit         = $p(aInputStr,"^",9)
	Set RefRanges    = $p(aInputStr,"^",10)
	Set MDRResult    = $p(aInputStr,"^",11)
	Quit:(ReportDr="")||(TCCode="")||(TCDesc="") return
	Set:Result["阴性" Result="阴性"
	Set:Result["阳性" Result="阳性"
	Set VisitRepResultDr = $o(^DHCHAI.DP.LabInfVisitResultI("IndexLabTCCode",ReportDr,TCCode,0))
	Set objLabReport = ##class(DHCHAI.DP.LabInfVisitReport).GetObjById(ReportDr)
	Quit:'$isobject(objLabReport) return
	
	Set InputStr = VisitRepResultDr
	Set InputStr = InputStr_"^"_ReportDr
	Set InputStr = InputStr_"^"_TCDesc        //检验项目名称
	Set InputStr = InputStr_"^"_TCCode        //检验项目代码
	Set InputStr = InputStr_"^"_RstFormat	  //结果类型
	Set InputStr = InputStr_"^"_Result	      //检测结果
	Set InputStr = InputStr_"^"_TextRes	      //定性结果
	Set InputStr = InputStr_"^"_ResNoes	      //结果说明(备注)
	Set InputStr = InputStr_"^"_AbFlag	      //异常提示
	Set InputStr = InputStr_"^"_Unit	      //单位
	Set InputStr = InputStr_"^"_RefRanges	  //参考范围
	Set InputStr = InputStr_"^"_MDRResult	  //多耐结果
	
	Set VisitRepResultDr = ##class(DHCHAI.DP.LabInfVisitResult).Update(InputStr,"^")
	If (+VisitRepResultDr)<1 {
		//记录错误日志
		Set ErrClass  = "DHCHAI.DP.LabInfVisitResult"
		Set ErrMethod = "Update"
		Set ErrArgStr = $lb(InputStr,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(ReportDr,ErrClass,ErrMethod,ErrArgStr)
	}
	Quit:(+VisitRepResultDr)<1 return
	Set return=VisitRepResultDr
	
	Quit return
	
SaveVisitRepResultErr
	Set return="-999^"_$ZError
	Quit return
}

}
