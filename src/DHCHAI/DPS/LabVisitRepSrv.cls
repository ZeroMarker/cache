/// 名称: DHCHAI.DPS.LabVisitRepSrv
/// 描述: 检验标本+报告相关服务
/// 编写者：liyi
/// 编写日期: 2017-08-11
Class DHCHAI.DPS.LabVisitRepSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-08-11
/// Description:  保存本院外送检验结果
/// Input：       aInputStr
/// Return:		  return>0:成功、return<1:失败 
/// w ##class(DHCHAI.DPS.LabVisitRepSrv).SaveOutLabReport("^1^1^468^4^278^8^2022-08-12^17","^")
ClassMethod SaveOutLabReport(aInputStr As %String, aSeparete As %String = "^")
{
	Set return = ""
	New (aInputStr,aSeparete)
	Quit:(aInputStr="") return
	
	Set ID          = $p(aInputStr,aSeparete,1)
	Set EpisodeDr   = $p(aInputStr,aSeparete,2)
	Set VisitNumID  = $p(aInputStr,aSeparete,3)
	Set BacteriaID  = $p(aInputStr,aSeparete,4)
	Set MRBTypeID1  = $p(aInputStr,aSeparete,5)
	Set BacteriaID2 = $p(aInputStr,aSeparete,6)
	Set MRBTypeID2  = $p(aInputStr,aSeparete,7)
	Set LabRepDate  = $p(aInputStr,aSeparete,8)
	Set TestSetMID  = $p(aInputStr,aSeparete,9)   // DHCHAI.DP.LabTestSetMap.ID
	
	Set objTSetMap = ##class(DHCHAI.DP.LabTestSetMap).GetObjById(TestSetMID)
	Quit:'$Isobject(objTSetMap) return
	Set BTTestSet = objTSetMap.BTTestSet   // 检验医嘱名称
	
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$Isobject(objPaadm) return
	
	Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(VisitNumID)
	Quit:'$IsObject(objVisitNumber) return
	
	Set LabEpisodeNo = objVisitNumber.LabEpisodeNo
	Quit:LabEpisodeNo="" return
	Set LabLocDr=""
	Set:$IsObject(objVisitNumber.LabLocDr) LabLocDr = objVisitNumber.LabLocDr.%Id()
	Set LabSpecimen = objVisitNumber.LabSpecimen
	Set CollDate  = objVisitNumber.LabCollDate
	Set CollTime  = objVisitNumber.LabCollTime
	Set RecDate   = objVisitNumber.LabRecDate
	Set RecTime   = objVisitNumber.LabRecTime
	Set RecUser   = objVisitNumber.LabRecUser
	Set:RecUser'="" RecUser=$p(RecUser,"|",3)
	
	Set aSCode       = "LIS01"                            // 子系统代码
	Set ReportID     = EpisodeDr_"||"_LabEpisodeNo        // 检验报告ID
	Set RepStatus    = "3"                                // 1登记，2初审，3审核，4复查检验报告状态
	Set RepOrder     = "1"                                // 检验报告序号
	Set XCode        = EpisodeDr_"||"_LabEpisodeNo_"||"_RepOrder  // 记录索引码
	Set TestSetRow   = ""     // 检验结果（医嘱表）
	Set RegDate      = LabRepDate
	Set RegTime      = "00:00:00"
	Set RegUserID    = ""
	Set RegUserCode  = ""
	Set RegUserName  = ""
	Set AuthDate     = LabRepDate
	Set AuthTime     = "00:00:00"
	Set AuthUserID   = ""
	Set AuthUserCode = ""
	Set AuthUserName = ""
	Set:AuthDate["-" AuthDate = $zdh(AuthDate,3)
	Set:AuthTime[":" AuthTime = $zth(AuthTime,1)
	
	Set VisitTestSetDr="",LabTestSetCode=""
	Set objVisitTestSet=##class(DHCHAI.DP.LabVisitTestSet).GetObjByDesc(VisitNumID,BTTestSet)
	If $IsObject(objVisitTestSet){
		Set VisitTestSetDr = objVisitTestSet.%Id()
		Set LabTestSetCode = objVisitTestSet.LabTestSetCode
	}
	Quit:VisitTestSetDr="" return  // 检验医嘱为空过滤
	Set:LabTestSetCode="" LabTestSetCode=BTTestSet
	Set VisitReportDr=""
	Set objVisitReport = ##class(DHCHAI.DP.LabVisitReport).GetObjByXCode(aSCode,XCode)
	If $IsObject(objVisitReport){
		Set VisitReportDr=objVisitReport.%Id()
	}
	// 保存检验报告
	Set InputStr = VisitReportDr
	Set InputStr = InputStr_"^"_VisitNumID
	Set InputStr = InputStr_"^"_ReportID
	Set InputStr = InputStr_"^"_RepOrder
	Set InputStr = InputStr_"^"_TestSetRow
	Set InputStr = InputStr_"^"_RepStatus
	Set InputStr = InputStr_"^"_RegDate
	Set InputStr = InputStr_"^"_RegTime
	Set InputStr = InputStr_"^"_RegUserID_"|"_RegUserCode_"|"_RegUserName
	Set InputStr = InputStr_"^"_AuthDate
	Set InputStr = InputStr_"^"_AuthTime
	Set InputStr = InputStr_"^"_AuthUserID_"|"_AuthUserCode_"|"_AuthUserName
	Set InputStr = InputStr_"^"_VisitTestSetDr
	Set InputStr = InputStr_"^"_aSCode
	Set InputStr = InputStr_"^"_XCode
	Set InputStr = InputStr_"^"_"1"     //是否有效
	Set InputStr = InputStr_"^"_+$h
	Set InputStr = InputStr_"^"_+$p($h,",",2)
	
	Set VisitReportDr = ##class(DHCHAI.DP.LabVisitReport).Update(InputStr,"^")
	Set return=+VisitReportDr
	If ((+VisitReportDr)>0){
		// 保存检验结果
		// 删除报告下面的结果表信息
		Set flg = ##class(DHCHAI.DP.LabVisitRepResult).CancelResult(VisitReportDr)
		//细菌1
		Set objBact = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaID)
		If ($Isobject(objBact)){
			Set BacDesc = objBact.BTBacDesc
			Set tMRBTypeID1="M1"
			Set:MRBTypeID1'="" tMRBTypeID1=MRBTypeID1
			Set tLabTestSetCode=LabTestSetCode_"||"_BacteriaID_"||"_tMRBTypeID1         // 检验项目代码
			Set VisitRepResultDr=""
			Set objVisitRepResult=##class(DHCHAI.DP.LabVisitRepResult).GetObjByTestCode(VisitReportDr,tLabTestSetCode)
			If $IsObject(objVisitRepResult){
				Set VisitRepResultDr=objVisitRepResult.%Id()
			}
			Set RstFormat="M"
			Set Result=BacDesc
			Set TextRes=BacDesc
			Set MDRResult=""
			
			Set InputStr = VisitRepResultDr
			Set InputStr = InputStr_"^"_VisitReportDr
			Set InputStr = InputStr_"^"_tLabTestSetCode //检验项目代码
			Set InputStr = InputStr_"^"_BTTestSet       //检验项目名称
			Set InputStr = InputStr_"^"_RstFormat	    //结果类型
			Set InputStr = InputStr_"^"_Result	        //检测结果
			Set InputStr = InputStr_"^"_TextRes	        //定性结果
			Set InputStr = InputStr_"^"_""	            //结果说明(备注)
			Set InputStr = InputStr_"^"_""	            //异常提示
			Set InputStr = InputStr_"^"_""	            //单位
			Set InputStr = InputStr_"^"_""	            //参考范围
			Set InputStr = InputStr_"^"_MDRResult	    //多耐结果
			Set InputStr = InputStr_"^"_""	            //细菌感染类型
			Set InputStr = InputStr_"^"_""	            //细菌感染类型添加方式
			
			Set VisitRepResultDr = ##class(DHCHAI.DP.LabVisitRepResult).Update(InputStr,"^")
			Set return=+VisitRepResultDr
			//保存多耐结果
			Set objMRB=##class(DHCHAI.IR.CRuleMRB).GetObjById(MRBTypeID1)
			If ($Isobject(objMRB)){
				Set ItmMastID=##class(DHCHAI.IRC.CtrlResultSrv).GetActItmMastID("LAB-Bacteria")
				Set KeyWord  = "检出菌"
				Set IsAbFlag = 1        //耐药菌
		
				Set obj=##class(DHCHAI.IRC.CtrlRecord).GetObj(EpisodeDr,ItmMastID)
				If ($IsObject(obj)){
					
					Set ObjectID        = ReportID_"&"_tLabTestSetCode   // 检验报告ID+检验项目Code
					Set obj.CCResult    = BacDesc     //细菌名称
					Set obj.CCTextRes   = ""           //定性结果
					Set obj.CCUnit      = ""           //单位
					Set obj.CCActLocDr  = LabLocDr     //送检科室
					Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
					Set CollTime=$s(CollTime'="":CollTime,1:RecTime)		//送检时间优先用采集时间
					Set:CollDate="" CollDate=AuthDate
					Set:CollTime="" CollTime=AuthTime
					Set obj.CCActDate   = CollDate     //接收标本日期
					Set obj.CCActTime   = CollTime     //接收标本时间
					Set obj.CCActUser   = RecUser      //接收标本人
					Set obj.CCRepDate   = AuthDate     //审核报告日期
					Set obj.CCRepTime   = AuthTime     //审核报告时间
					Set obj.CCRepUser   = AuthUserName //审核报告人
					Set obj.CCSCode     = "LIS01"      //子系统代码
					Set obj.CCObjectID  = ObjectID
					Set obj.CCParams    = "ResultID="_VisitRepResultDr
					
					Set obj.CCSpecimen  = LabSpecimen    //标本
					Set obj.CCBacteria  = BacDesc        //细菌
					Set obj.CCMRBTpDr   = MRBTypeID1     //多耐分类
					Set obj.CCKeyWord   = KeyWord        //关键词
					Set obj.CCIsAbFlag  = IsAbFlag       //结果异常
					Set obj.CCSummary   = BTTestSet_":"_BacDesc  //摘要信息
					Set obj.CCMRBTp2Dr  = ""             //多耐分类2
					Set flg=##class(DHCHAI.IRC.CtrlResultSrv).SaveResult(obj)
					Set return=+flg
				}
			}
		}
		//细菌2
		Set objBact = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaID2)
		If ($Isobject(objBact)){
			Set BacDesc = objBact.BTBacDesc
			Set tMRBTypeID2="M2"
			Set:MRBTypeID2'="" tMRBTypeID2=MRBTypeID2
			Set tLabTestSetCode=LabTestSetCode_"||"_BacteriaID2_"||"_MRBTypeID2         // 检验项目代码
			Set VisitRepResultDr=""
			Set objVisitRepResult=##class(DHCHAI.DP.LabVisitRepResult).GetObjByTestCode(VisitReportDr,tLabTestSetCode)
			If $IsObject(objVisitRepResult){
				Set VisitRepResultDr=objVisitRepResult.%Id()
			}
			Set RstFormat="M"
			Set Result=BacDesc
			Set TextRes=BacDesc
			Set MDRResult=""
			
			Set InputStr = VisitRepResultDr
			Set InputStr = InputStr_"^"_VisitReportDr
			Set InputStr = InputStr_"^"_tLabTestSetCode //检验项目代码
			Set InputStr = InputStr_"^"_BTTestSet       //检验项目名称
			Set InputStr = InputStr_"^"_RstFormat	    //结果类型
			Set InputStr = InputStr_"^"_Result	        //检测结果
			Set InputStr = InputStr_"^"_TextRes	        //定性结果
			Set InputStr = InputStr_"^"_""	            //结果说明(备注)
			Set InputStr = InputStr_"^"_""	            //异常提示
			Set InputStr = InputStr_"^"_""	            //单位
			Set InputStr = InputStr_"^"_""	            //参考范围
			Set InputStr = InputStr_"^"_MDRResult	    //多耐结果
			Set InputStr = InputStr_"^"_""	            //细菌感染类型
			Set InputStr = InputStr_"^"_""	            //细菌感染类型添加方式
			
			Set VisitRepResultDr2 = ##class(DHCHAI.DP.LabVisitRepResult).Update(InputStr,"^")
			Set return=+VisitRepResultDr2
			//保存多耐结果2
			Set objMRB=##class(DHCHAI.IR.CRuleMRB).GetObjById(MRBTypeID2)
			If ($Isobject(objMRB)){
				Set ItmMastID=##class(DHCHAI.IRC.CtrlResultSrv).GetActItmMastID("LAB-Bacteria")
				
				Set KeyWord  = "检出菌"
				Set IsAbFlag = 1        //耐药菌
		
				Set obj=##class(DHCHAI.IRC.CtrlRecord).GetObj(EpisodeDr,ItmMastID)
				If ($IsObject(obj)){
					Set ObjectID        = ReportID_"&"_tLabTestSetCode   // 检验报告ID+检验项目Code
					Set obj.CCResult    = BacDesc      //细菌名称
					Set obj.CCTextRes   = ""           //定性结果
					Set obj.CCUnit      = ""           //单位
					Set obj.CCActLocDr  = LabLocDr     //送检科室
					
					Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
					Set CollTime=$s(CollTime'="":CollTime,1:RecTime)		//送检时间优先用采集时间
					Set:CollDate="" CollDate=AuthDate
					Set:CollTime="" CollTime=AuthTime
					Set obj.CCActDate   = CollDate     //接收标本日期
					Set obj.CCActTime   = CollTime     //接收标本时间
					Set obj.CCActUser   = RecUser      //接收标本人
					Set obj.CCRepDate   = AuthDate     //审核报告日期
					Set obj.CCRepTime   = AuthTime     //审核报告时间
					Set obj.CCRepUser   = AuthUserName //审核报告人
					Set obj.CCSCode     = "LIS01"      //子系统代码
					Set obj.CCObjectID  = ObjectID
					Set obj.CCParams    = "ResultID="_VisitRepResultDr2
					
					Set obj.CCSpecimen  = LabSpecimen    //标本
					Set obj.CCBacteria  = BacDesc        //细菌
					Set obj.CCMRBTpDr   = MRBTypeID2     //多耐分类
					Set obj.CCKeyWord   = KeyWord        //关键词
					Set obj.CCIsAbFlag  = IsAbFlag       //结果异常
					Set obj.CCSummary   = BTTestSet_":"_BacDesc  //摘要信息
					Set obj.CCMRBTp2Dr  = ""             //多耐分类2
					
					Set flg=##class(DHCHAI.IRC.CtrlResultSrv).SaveResult(obj)
					Set return=+flg
				}
			}
		}
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-08-11
/// Description:  查询检验送检记录(检出菌、常规检验、PCT（降钙素原）、CRP（C反映蛋白）、G试验、M试验)
/// Table：       DHCHAI.DP.LabVisitNumber,DHCHAI.DP.LabVisitReport
/// Input：       就诊ID、采集开始日期、采集结束日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabVisitRepSrv","QryLabVisitNumber","112","","","","","")
Query QryLabVisitNumber(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aTestSetDr As %String = "", aCatCode As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "VisitNumberID:%String,EpisodeNo:%String,OrdTSDesc:%String,Specimen:%String,LocDesc:%String,CollDate:%String,VisitReportID:%String,AuthDate:%String,CollTime:%String,Anomalyflag:%String,MRBDesc:%String,VisitReportIDs:%String") [ SqlProc ]
{
}

ClassMethod QryLabVisitNumberExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aTestSetDr As %String = "", aCatCode As %String = "", aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//就诊号(入参)
	Quit:(aEpisodeID="") $$$OK
	//日期处理(入参)
	Set aDateFrom=$g(aDateFrom)
	Set aDateTo=$g(aDateTo)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
	Set aTestSetDr=$g(aTestSetDr)	//检验子类
	Set aCatCode=$g(aCatCode)		//检验大类
	Set ISAllCategory=##class(DHCHAI.BT.Config).GetValByCode("ISAllCategory")
		
	//循环标本表
	Set xVisitNumberDr=""
	For {
		Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeID,xVisitNumberDr))
		Quit:xVisitNumberDr=""
		
		Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xVisitNumberDr)
		Continue:'$isobject(objVisitNumber)
		Continue:objVisitNumber.LabIsActive'=1
		
		Set CollDate=objVisitNumber.LabCollDate		//采集日期
		Set CollTime=objVisitNumber.LabCollTime
		
		Set RecDate=objVisitNumber.LabRecDate		//接收日期
		Set RecTime=objVisitNumber.LabRecTime
		
		Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
		Set CollTime=$s(CollTime'="":CollTime,1:RecTime)
		//过滤日期	
		Continue:(aDateFrom'="")&(CollDate<aDateFrom)
		Continue:(aDateTo'="")&(CollDate>aDateTo)
		
		Set:CollDate'="" CollDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
		Set:CollTime'="" CollTime=$zt(CollTime,1)
		
		Set SCode	 	= objVisitNumber.LabSCode		//LIS01
		Set EpisodeNo 	= objVisitNumber.LabEpisodeNo	//检验号|标本号
		Set Specimen 	= objVisitNumber.LabSpecimen	//标本名称[血.....]
		//送检科室
		Set LocDesc 	= ""
		If $isobject(objVisitNumber.LabLocDr){
			Set LocDesc=objVisitNumber.LabLocDr.BTDesc
			Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			Set LocDesc2=objVisitNumber.LabLocDr.BTDesc2
			Set:LocDesc2'="" LocDesc=LocDesc2
		}
		// 循环检验医嘱表[检查送检记录是否是(检出菌、常规检验、PCT（降钙素原）、CRP（C反应蛋白）、G试验、M试验)]
		Set OrdListDesc=""	//检验医嘱名称
		Set xTestSetDesc="",checkFlg=0,IsCom=0
		For {
			Set xTestSetDesc=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
			Quit:xTestSetDesc=""
			Set OrdListDesc=OrdListDesc_"+"_xTestSetDesc
			
			Set xID =""
			For {
				Set xID=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc,xID))
				Quit:xID=""
				Set LabVisitTestData=$g(^DHCHAI.DP.LabVisitTestSetD(xID))
				Continue:LabVisitTestData=""
				Set ComSetCode =$lg(LabVisitTestData,7)		
				Set:ComSetCode'="" IsCom=1			//合管检验医嘱代码
			}
			If (ISAllCategory=0) {   //查询对照
				Continue:'$d(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc))		//排除未对照医嘱
				//对照后检验医嘱
				Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc,""))
				Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjById(TestSetMapID)
				Continue:'$isobject(objTestSetMap)
				Continue:'$isobject(objTestSetMap.BTMapItemDr)
				Continue:'$isobject(objTestSetMap.BTMapItemDr.BTCatDr)
				Set CatCode=objTestSetMap.BTMapItemDr.BTCatDr.BTCode
				Continue:(aCatCode'="")&&(aCatCode'=CatCode)
				Set TSMapItemDr=objTestSetMap.BTMapItemDr.%Id()
				Continue:(aTestSetDr'="")&&(TSMapItemDr'=aTestSetDr)
				Set checkFlg =1
			} Else { //查询所有
				If (aCatCode'="")||(aTestSetDr'="") {
					Continue:'$d(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc))		//排除未对照医嘱			
					//对照后检验医嘱
					Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc,""))
					Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjById(TestSetMapID)
					Continue:'$isobject(objTestSetMap)
					Continue:'$isobject(objTestSetMap.BTMapItemDr)
					Continue:'$isobject(objTestSetMap.BTMapItemDr.BTCatDr)
					Set CatCode=objTestSetMap.BTMapItemDr.BTCatDr.BTCode
					Continue:(aCatCode'="")&&(aCatCode'=CatCode)
					Set TSMapItemDr=objTestSetMap.BTMapItemDr.%Id()
					Continue:(aTestSetDr'="")&&(TSMapItemDr'=aTestSetDr)
					Set checkFlg =1
				}
			}
		}
		Set:IsCom'=1 OrdListDesc=""
		Set:OrdListDesc'="" OrdListDesc=$e(OrdListDesc,2,$l(OrdListDesc))
		//医嘱备注 20230424
		Set ReqNotes	 	= objVisitNumber.LabReqNotes
        
		Kill arrVisitReport
		//循环检验报告表
		Set xTestSetDr=""
		For {
			Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
			Quit:xTestSetDr=""
			
			//最新检验报告
			Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
			Set xVisitReportDr=0
			For {
				Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
				Quit:xVisitReportDr=""
				
				If (checkFlg=0) {  			//检查检验项目是否存在于检验结果中
					Set xTestCode=""
					For {
						Set xTestCode=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",xVisitReportDr,xTestCode))
						Quit:xTestCode=""
						Quit:checkFlg=1
						//循环检验项目对照表
						Set xMapItemDr=0
						For {
							Set xMapItemDr= $o(^DHCHAI.DP.LabTCMapI("IndexMapCodeDr",xTestCode,xMapItemDr))
							Quit:xMapItemDr=""
							
							Continue:(aTestSetDr'="")&&(xMapItemDr'=aTestSetDr)		//过滤检验子类[血常规,尿常规....]						
							Set objTSMapItem=##class(DHCHAI.DP.LabTestSet).GetObjById(xMapItemDr)	//标准医嘱
							Continue:'$isobject(objTSMapItem)
							Continue:'$isobject(objTSMapItem.BTCatDr)	
							Set CatCode=objTSMapItem.BTCatDr.BTCode
							Continue:(aCatCode'="")&&(aCatCode'=CatCode)	//过滤检验大类[细菌检测,常规,病毒]
							
							Set checkFlg=1
							Quit
						}
					}
				}
				Continue:(checkFlg=0)&((aCatCode'="")||(aTestSetDr'=""))
				Continue:(checkFlg=0)&(ISAllCategory=0)
				
				Set objVisitReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(xVisitReportDr)
				Continue:'$IsObject(objVisitReport)
				
				Set Status = objVisitReport.LabStatus
				//Continue:Status=6	//作废
				Set IsActive = objVisitReport.LabIsActive
				Continue:IsActive=0
								
				Set VisitReportID = objVisitReport.%Id()
				Set LabReportID = objVisitReport.LabReportID
				Set LabRepOrder = objVisitReport.LabRepOrder
				Set AuthDate=objVisitReport.LabAuthDate
				Set AuthTime=objVisitReport.LabAuthTime
				//Set:AuthDate'="" AuthDate=$zd(AuthDate,3)
				Set:AuthDate'="" AuthDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AuthDate)
				Set:AuthTime'="" AuthTime=$zt(AuthTime,1)
				
				Set objVisitTestSet=objVisitReport.LabTestSetDr
				Continue:'$IsObject(objVisitTestSet)
				Set TestSetDesc=objVisitTestSet.LabTestSetDesc
				Set OrdTsDesc=objVisitTestSet.LabOrdTSDesc
				Set:OrdListDesc'="" OrdTsDesc=OrdListDesc
				Set:ReqNotes'="" OrdTsDesc=OrdTsDesc_"("_ReqNotes_")"
				Set CollDateR=CollDate
				Set AuthDateR=AuthDate
				
				Set:CollTime'="" CollDateR=CollDate_" "_CollTime
				Set:AuthTime'="" AuthDateR=AuthDate_" "_AuthTime
				
				If $g(arrVisitReport(LabReportID))'="" {
					Set arrVisitReport(LabReportID)=$g(arrVisitReport(LabReportID))_","_VisitReportID
				} Else {
					Set arrVisitReport(LabReportID)=VisitReportID
				}
				
				Continue:(aAlias'="")&&(EpisodeNo'[aAlias)&&(OrdTsDesc'[aAlias)&&(Specimen'[aAlias)&&(LocDesc'[aAlias)
				Set AnomalyInfo=..Anomalyflag(aEpisodeID,VisitReportID)
				Set Anomalyflag=$p(AnomalyInfo,"^",1)
				Set MRBDesc=$p(AnomalyInfo,"^",2)
				//多语言	
				Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
				
				Set Data=$lb(xVisitNumberDr,EpisodeNo,OrdTsDesc,Specimen,LocDesc,CollDateR,VisitReportID,AuthDateR,CollTime,Anomalyflag,MRBDesc)

				Set arrVisitReport(LabReportID,LabRepOrder)=Data
			}
		}
		//处理一条医嘱对应多个外部码（检验医嘱）问题
		Set xLabReportID=""
		For {
			Set xLabReportID=$o(arrVisitReport(xLabReportID))
			Quit:xLabReportID=""
			
			Set xLabRepOrder=$o(arrVisitReport(xLabReportID,""),-1)
			Continue:xLabRepOrder=""
			Set Data=$g(arrVisitReport(xLabReportID,xLabRepOrder))
			Continue:Data=""
			Set LabReportIDs=$g(arrVisitReport(xLabReportID))
				
			Set ^CacheTemp(repid,ind)=Data_$lb(LabReportIDs)
			Set ind=ind+1
		}
		Kill arrVisitReport
	}
	Quit $$$OK
}

ClassMethod QryLabVisitNumberClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabVisitNumberExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabVisitNumberFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabVisitNumberExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liyi
/// CreatDate：   2017-08-11
/// Description:  查询检验报告结果
/// Table：       DHCHAI.DP.LabVisitRepResult
/// Input：       aVisitRepID：检验报告ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabVisitRepSrv","QryVisitRepResult","40603")
Query QryVisitRepResult(aVisitRepID As %String) As %Query(ROWSPEC = "ResultID:%String,TestDesc:%String,TestCode:%String,RstFormat:%String,Result:%String,TextRes:%String,ResNoes:%String,AbFlag:%String,Unit:%String,RefRanges:%String,MDRResult:%String") [ SqlProc ]
{
}

ClassMethod QryVisitRepResultExecute(ByRef qHandle As %Binary, aVisitRepID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:(aVisitRepID="") $$$OK
	
	Set xResultID=""
	For {
		Set xResultID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",aVisitRepID,xResultID))
		Quit:xResultID=""
		
		Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xResultID)
		Continue:'$isobject(objResult)
		
		Set TestDesc 	= objResult.LabTestDesc
		Set TestCode 	= objResult.LabTestCode
		Set RstFormat 	= objResult.LabRstFormat
		Set Result 		= objResult.LabResult
		Set TextRes 	= objResult.LabTextRes
		Set ResNoes 	= objResult.LabResNoes
		Set AbFlag 		= objResult.LabAbFlag
		Set Unit 		= objResult.LabUnit
		Set RefRanges 	= objResult.LabRefRanges
		Set MDRResult 	= objResult.LabMDRResult
	
		Set Data = $lb(xResultID,TestDesc,TestCode,RstFormat,Result,TextRes,ResNoes,AbFlag,Unit,RefRanges,MDRResult)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryVisitRepResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVisitRepResultExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryVisitRepResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVisitRepResultExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liyi
/// CreatDate：   2017-08-14
/// Description:  查询检验报告药敏结果
/// Table：       DHCHAI.DP.LabVisitRepRstSen
/// Input：       aRepResultID：检验报告ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabVisitRepSrv","QryResultSen","4995")
Query QryResultSen(aResultID As %String) As %Query(ROWSPEC = "SenID:%String,BacteriaID:%String,Bacteria:%String,AntID:%String,AntCode:%String,AntDesc:%String,SensitivityID:%String,Sensitivity:%String,IsInt:%String") [ SqlProc ]
{
}

ClassMethod QryResultSenExecute(ByRef qHandle As %Binary, aResultID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aResultID="") $$$OK
	
	Set xAntDesc=""
	For {
		Set xAntDesc = $o(^DHCHAI.DP.LabVisitRepRstSenI("IndexResultDrAntDesc",aResultID,xAntDesc))
		Quit:xAntDesc=""
		
		Set xSenID = ""
		For {
			Set xSenID = $o(^DHCHAI.DP.LabVisitRepRstSenI("IndexResultDrAntDesc",aResultID,xAntDesc,xSenID))
			Quit:xSenID=""
		
			Set objRstSen = ##class(DHCHAI.DP.LabVisitRepRstSen).GetObjById(xSenID)
			Continue:'$isobject(objRstSen)
			Set objResult = objRstSen.LabResultDr
			Continue:'$isobject(objResult)
			Continue:'$isobject(objResult.LabReportDr)
			
			Set SCode = objResult.LabReportDr.LabSCode
			
			Set AntCode 	= objRstSen.LabAntCode
			Set AntDesc 	= objRstSen.LabAntDesc
			Set objAntiMap = ##class(DHCHAI.DP.LabAntiMap).GetObjByAntDesc(SCode,AntDesc)
			Set AntID = ""
			If $isobject(objAntiMap){
				if objAntiMap.BTIsActive=1{
					if $isobject(objAntiMap.BTMapItemDr){
						Set AntID = objAntiMap.BTMapItemDr.%Id()
						Set AntDesc = objAntiMap.BTMapItemDr.BTAntDesc
						Set AntCode = objAntiMap.BTMapItemDr.BTAntCode
					}
				}
			}
			Set Sensitivity = objRstSen.LabSensitivity
			Set SensitivityID = ""
			Set SenPhraseMap = ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"LABTestRstSen",Sensitivity)
			If SenPhraseMap'=""{
				Set SensitivityID = $p(SenPhraseMap,"^",1)
				Set Sensitivity = $p(SenPhraseMap,"^",3)
			}
			// 细菌
			Set Bacteria   = objResult.LabResult
			Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
			
			Set BacteriaID=""
			If $isobject(objBactMap){
				if objBactMap.BTIsActive=1{
					if $isobject(objBactMap.BTMapItemDr){
						Set BacteriaID = objBactMap.BTMapItemDr.%Id()
						Set Bacteria = objBactMap.BTMapItemDr.BTBacDesc
					}
				}
			}
			Set IsInt    	= objRstSen.LabIsInt
			
			Set Data = $lb(xSenID,BacteriaID,Bacteria,AntID,AntCode,AntDesc,SensitivityID,Sensitivity,IsInt)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryResultSenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryResultSenExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryResultSenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryResultSenExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liyi
/// CreatDate：   2017-09-23
/// Description:  根据检验报告ID查询药敏结果
/// Table：       
/// Input：       aReportID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabVisitRepSrv","QryResultSenByRep","44522")
Query QryResultSenByRep(aReportID As %String) As %Query(ROWSPEC = "ReportID:%String,ReusltID:%String,SenID:%String,BacteriaID:%String,Bacteria:%String,AntID:%String,AntCode:%String,AntDesc:%String,SensitivityID:%String,Sensitivity:%String,IsInt:%String")
{
}

ClassMethod QryResultSenByRepExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aReportID="") $$$OK
	Set objRep = ##class(DHCHAI.DP.LabVisitReport).GetReportByID(aReportID)
	Quit:'$IsObject(objRep) $$$OK

	Set SCode = objRep.LabSCode
	Set xReportID = objRep.%Id()
	Set xReusltID = ""
	For {
		Set xReusltID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xReportID,xReusltID))
		Quit:xReusltID=""
		
		Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xReusltID)
		Continue:'$IsObject(objResult)
		
		// 细菌
		Set Bacteria   = objResult.LabResult
		Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
		Continue:'$isobject(objBactMap)
		Continue:objBactMap.BTIsActive=0
		Continue:'$isobject(objBactMap.BTMapItemDr)
		Set BacteriaID = objBactMap.BTMapItemDr.%Id()
		Set Bacteria = objBactMap.BTMapItemDr.BTBacDesc
		
		Set xAntDesc=""
		For {
			Set xAntDesc = $o(^DHCHAI.DP.LabVisitRepRstSenI("IndexResultDrAntDesc",xReusltID,xAntDesc))
			Quit:xAntDesc=""
			
			Set xSenID = ""
			For {
				Set xSenID = $o(^DHCHAI.DP.LabVisitRepRstSenI("IndexResultDrAntDesc",xReusltID,xAntDesc,xSenID))
				Quit:xSenID=""
			
				Set objRstSen = ##class(DHCHAI.DP.LabVisitRepRstSen).GetObjById(xSenID)
				Continue:'$isobject(objRstSen)
				Set IsInt    	= objRstSen.LabIsInt
				Set AntCode 	= objRstSen.LabAntCode
				Set AntDesc 	= objRstSen.LabAntDesc
				Set objAntiMap = ##class(DHCHAI.DP.LabAntiMap).GetObjByAntDesc(SCode,AntDesc)
			
				Continue:'$isobject(objAntiMap)
				Continue:objAntiMap.BTIsActive=0
				Continue:'$isobject(objAntiMap.BTMapItemDr)
				Set AntID = objAntiMap.BTMapItemDr.%Id()
				Set AntDesc = objAntiMap.BTMapItemDr.BTAntDesc
				Set AntCode = objAntiMap.BTMapItemDr.BTAntCode
				
				Set Sensitivity = objRstSen.LabSensitivity
				Set SenPhraseMap = ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"LABTestRstSen",Sensitivity)
				Continue:SenPhraseMap=""
				
				Set SensitivityID = $p(SenPhraseMap,"^",1)
				Set Sensitivity = $p(SenPhraseMap,"^",3)
				
				Set Data = $lb(aReportID,xReusltID,xSenID,BacteriaID,Bacteria,AntID,AntCode,AntDesc,SensitivityID,Sensitivity,IsInt)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}

	Quit $$$OK
}

ClassMethod QryResultSenByRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryResultSenByRepExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryResultSenByRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryResultSenByRepExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2018-01-09
/// Description:  查询各检验项目的历史数据
/// Table：       DHCHAI.DP.LabVisitNumber,DHCHAI.DP.LabVisitReport
/// Input：       aEpisodeID:就诊ID
///               aLabItemDesc:检验项目名称
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabVisitRepSrv","QryLabHisData","5913","粪便常规＋潜血(急诊)","","")
Query QryLabHisData(aEpisodeID As %String, aLabItemDesc As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Query(ROWSPEC = "ResultID:%String,VisitReportID:%String,EpisodeNo:%String,CollDate:%String,TestDesc:%String,TestCode:%String,RstFormat:%String,Result:%String,TextRes:%String,ResNoes:%String,AbFlag:%String,Unit:%String,RefRanges:%String,MDRResult:%String") [ SqlProc ]
{
}

ClassMethod QryLabHisDataExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aLabItemDesc As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set aTestSetDr=$g(aTestSetDr)
	Set aDateFrom=$g(aDateFrom)
	Set aDateTo=$g(aDateTo)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)

	Quit:(aEpisodeID="")||(aLabItemDesc="") $$$OK
	Set:aLabItemDesc["＋" aLabItemDesc=$tr(aLabItemDesc,"＋"," ")
	Set:aLabItemDesc["+" aLabItemDesc=$tr(aLabItemDesc,"+"," ")
	Set xVisitNumberDr=""
	For {
		Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeID,xVisitNumberDr))
		Quit:xVisitNumberDr=""
		
		Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xVisitNumberDr)
		Continue:'$isobject(objVisitNumber)
		Continue:objVisitNumber.LabIsActive'=1
		
		Set CollDate=objVisitNumber.LabCollDate		//采集日期
		Set CollTime=objVisitNumber.LabCollTime
		
		Set RecDate=objVisitNumber.LabRecDate		//接收日期
		Set RecTime=objVisitNumber.LabRecTime
		
		Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
		Set CollTime=$s(CollTime'="":CollTime,1:RecTime)
		
		
		Continue:(aDateFrom'="")&(CollDate<aDateFrom)
		Continue:(aDateTo'="")&(CollDate>aDateTo)
		//Set:CollDate'="" CollDate=$zd(CollDate,3)
		Set:CollDate'="" CollDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
		Set:CollTime'="" CollTime=$zt(CollTime,1)
		
		Set SCode	 	= objVisitNumber.LabSCode
		Set EpisodeNo 	= objVisitNumber.LabEpisodeNo
		Set Specimen 	= objVisitNumber.LabSpecimen
		Set LocDesc 	= ""
		If $isobject(objVisitNumber.LabLocDr){
			Set LocDesc=objVisitNumber.LabLocDr.BTDesc
			Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			Set LocDesc2=objVisitNumber.LabLocDr.BTDesc2
			Set:LocDesc2'="" LocDesc=LocDesc2
		}
		Set OrdListDesc=""  //检验医嘱名称
		// 检查送检记录是否是（检出菌、常规检验、PCT（降钙素原）、CRP（C反映蛋白）、G试验、M试验）
		Set xTestSetDesc = "",checkFlg=0,IsCom=0
		For {
			Set xTestSetDesc = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
			Quit:xTestSetDesc=""
			
			Set xID =""
			For {
				Set xID=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc,xID))
				Quit:xID=""
				Set LabVisitTestData=$g(^DHCHAI.DP.LabVisitTestSetD(xID))
				Continue:LabVisitTestData=""
				Set ComSetCode =$lg(LabVisitTestData,7)
				Set:ComSetCode'="" IsCom=1
			}
			
			Continue:'$d(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc))
			Set TestSetMapID = $o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc,""))
			Set objTestSetMap = ##class(DHCHAI.DP.LabTestSetMap).GetObjById(TestSetMapID)
			Continue:'$isobject(objTestSetMap)
			Continue:'$isobject(objTestSetMap.BTMapItemDr)
			Set checkFlg =1
		}
		Set:IsCom'=1 OrdListDesc=""
		Set:OrdListDesc'="" OrdListDesc=$e(OrdListDesc,2,$l(OrdListDesc))
	
		Continue:checkFlg=0
		
		Set xTestSetDr=""
		For {
			Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
			Quit:xTestSetDr=""
			
			//最新检验报告
			Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
			Set xVisitReportDr=0
			For {
				Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
				Quit:xVisitReportDr=""
				
				Set objVisitReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(xVisitReportDr)
				Continue:'$IsObject(objVisitReport)
				
				Set Status = objVisitReport.LabStatus
				//Continue:Status=6	//作废
				Set IsActive = objVisitReport.LabIsActive
				Continue:IsActive=0
				
				Set VisitReportID = objVisitReport.%Id()
				Set AuthDate=objVisitReport.LabAuthDate
				Set AuthTime=objVisitReport.LabAuthTime
				Set:AuthDate'="" AuthDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AuthDate)
				Set:AuthTime'="" AuthTime=$zt(AuthTime,1)

				Set objVisitTestSet=objVisitReport.LabTestSetDr
				Continue:'$IsObject(objVisitTestSet)
				Set TestSetDesc=objVisitTestSet.LabTestSetDesc
				Set OrdTsDesc=objVisitTestSet.LabOrdTSDesc
				//Set OrdTsDesc = TestSetDesc	//update by jiangpengpeng 2018-04-11 bug582798
				Set:OrdTsDesc["＋" OrdTsDesc=$tr(OrdTsDesc,"＋"," ")
				Set:OrdTsDesc["+" OrdTsDesc=$tr(OrdTsDesc,"+"," ")
				Set:OrdListDesc'="" OrdTsDesc=OrdListDesc
				Continue:(aLabItemDesc'="")&(aLabItemDesc'=OrdTsDesc)
				
				Set xResultID="" 
				For {
					Set xResultID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",VisitReportID,xResultID))
					Quit:xResultID=""
					
					Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xResultID)
					Continue:'$isobject(objResult)
					
					Set TestDesc 	= objResult.LabTestDesc
					Set TestCode 	= objResult.LabTestCode
					Set RstFormat 	= objResult.LabRstFormat
					Set Result 		= objResult.LabResult
					Set TextRes 	= objResult.LabTextRes
					Set ResNoes 	= objResult.LabResNoes
					Set AbFlag 		= objResult.LabAbFlag
					Set Unit 		= objResult.LabUnit
					Set RefRanges 	= objResult.LabRefRanges
					Set MDRResult 	= objResult.LabMDRResult
					
					Set Data = $lb(xResultID,VisitReportID,EpisodeNo,CollDate,TestDesc,TestCode,RstFormat,Result,TextRes,ResNoes,AbFlag,Unit,RefRanges,MDRResult)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryLabHisDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabHisDataExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabHisDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabHisDataExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     chenjb
/// CreatDate：   2018-04-11
/// Description:  查询检验送检记录(检出菌的药敏情况)
/// Table：       DHCHAI.DP.LabVisitNumber,DHCHAI.DP.LabVisitReport
/// Input：       接收开始日期、接收结束日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabVisitRepSrv","QryLabBacteriaSens","2017-08-01","2017-08-30","","")
Query QryLabBacteriaSens(aDateFrom As %String = "", aDateTo As %String = "", aBacType As %String = "", aBacteria As %String = "") As %Query(ROWSPEC = "xVisitNumberDr:%String,EpisodeNo:%String,OrdTsDesc:%String,Specimen:%String,LocDesc:%String,CollDateR:%String,VisitReportID:%String,LabReportID:%String,AuthDateR:%String,CollTime,xReusltID:%String,xSenID:%String,Bacteria:%String,BactType:%String,BacteriaMapID:%String,BacteriaMapDesc:%String,AntCode:%String,AntDesc:%String,AntMapID:%String,AntMapCode:%String,AntMapDesc:%String,Sensitivity:%String,SensMapID:%String,SensMapDesc") [ SqlProc ]
{
}

ClassMethod QryLabBacteriaSensExecute(ByRef qHandle As %Binary, aDateFrom As %String = "", aDateTo As %String = "", aBacType As %String = "", aBacteria As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aBacType=$g(aBacType)
	Set aBacteria=$g(aBacteria)
	Set aDateFrom=$g(aDateFrom)
	Set aDateTo=$g(aDateTo)
	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	//IndexRecDateTime 接收索引
	Set SCode="LIS01"
	
	For xDate = aDateFrom:1:aDateTo{
		Set xTime = ""
		For {
			Set xTime = $o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime"," "_SCode,xDate,xTime))
			Quit:xTime=""
			Set xVisitNumberDr=""
			For {
				Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime"," "_SCode,xDate,xTime,xVisitNumberDr))
				Quit:xVisitNumberDr=""
				
				Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xVisitNumberDr)
				Continue:'$isobject(objVisitNumber)
				Continue:objVisitNumber.LabIsActive'=1
				
				Set CollDate=objVisitNumber.LabCollDate		//采集日期
				Set CollTime=objVisitNumber.LabCollTime
				
				Set RecDate=objVisitNumber.LabRecDate		//接收日期
				Set RecTime=objVisitNumber.LabRecTime
				
				Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
				Set CollTime=$s(CollTime'="":CollTime,1:RecTime)
				
				//Set:CollDate'="" CollDate=$zd(CollDate,3)
				Set:CollDate'="" CollDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
				Set:CollTime'="" CollTime=$zt(CollTime,1)
				
				Set SCode	 	= objVisitNumber.LabSCode
				Set EpisodeNo 	= objVisitNumber.LabEpisodeNo
				Set Specimen 	= objVisitNumber.LabSpecimen
				Set LocDesc 	= ""
				If $isobject(objVisitNumber.LabLocDr){
					Set LocDesc=objVisitNumber.LabLocDr.BTDesc
					Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
					Set LocDesc2=objVisitNumber.LabLocDr.BTDesc2
					Set:LocDesc2'="" LocDesc=LocDesc2
				}
				
				// 检查送检记录是否是（检出菌 不是常规检验、PCT（降钙素原）、CRP（C反映蛋白）、G试验、M试验）
				Set xTestSetDesc="",checkFlg=0
				For {
					Set xTestSetDesc=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
					Quit:xTestSetDesc=""
					
					Continue:'$d(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc))
					Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc,""))
					Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjById(TestSetMapID)
					Continue:'$isobject(objTestSetMap)
					Continue:'$isobject(objTestSetMap.BTMapItemDr)
					Set:objTestSetMap.BTMapItemDr.BTTestSet["细菌检测" checkFlg =1
					Quit:checkFlg=1
				}
				Continue:checkFlg=0				
				
				Set xTestSetDr=""
				For {
					Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
					Quit:xTestSetDr=""
					
					//最新检验报告
					Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
					
					Set xVisitReportDr=0
					For {
						Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
						Quit:xVisitReportDr=""
						
						Set objVisitReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(xVisitReportDr)
						Continue:'$IsObject(objVisitReport)
						
						Set Status = objVisitReport.LabStatus
						//Continue:Status=6	//作废
						Set IsActive = objVisitReport.LabIsActive
						Continue:IsActive=0						
						Set VisitReportID = objVisitReport.%Id()
						Set LabReportID = objVisitReport.LabReportID
						Set LabRepOrder = objVisitReport.LabRepOrder
						Set AuthDate=objVisitReport.LabAuthDate
						Set AuthTime=objVisitReport.LabAuthTime
						//Set:AuthDate'="" AuthDate=$zd(AuthDate,3)
						Set:AuthDate'="" AuthDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AuthDate)
						Set:AuthTime'="" AuthTime=$zt(AuthTime,1)
						
						Set objVisitTestSet=objVisitReport.LabTestSetDr
						Continue:'$IsObject(objVisitTestSet)
						
						Set TestSetDesc=objVisitTestSet.LabTestSetDesc
						Set OrdTsDesc=objVisitTestSet.LabOrdTSDesc
						//Set OrdTsDesc = TestSetDesc
						
						Set CollDateR=CollDate
						Set AuthDateR=AuthDate
						
						Set:CollTime'="" CollDateR=CollDate_" "_CollTime
						Set:AuthTime'="" AuthDateR=AuthDate_" "_AuthTime
						//药敏信息检索
						Set xReportID=xVisitReportDr
						Set xReusltID = ""
						For {
							Set xReusltID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xReportID,xReusltID))
							Quit:xReusltID=""
							
							Set (Bacteria,BactType,BacteriaMapID,BacteriaMapDesc)=""
							Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xReusltID)
							Continue:'$IsObject(objResult)
							
							// 细菌
							Set Bacteria   = objResult.LabResult
							Continue:Bacteria=""
							Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
							//BactType 预留接口判断革兰氏阴性、阳性菌分类判定
							if ($isobject(objBactMap))
							{
								if (objBactMap.BTIsActive=1)
								{
									Set:$Isobject(objBactMap.BTMapItemDr) BacteriaMapID=objBactMap.BTMapItemDr.%Id()
									Set:$Isobject(objBactMap.BTMapItemDr) BacteriaMapDesc = objBactMap.BTMapItemDr.BTBacDesc
								}
							}
							//描述没有对照标准的用临床
							Set:BacteriaMapDesc="" BacteriaMapDesc =Bacteria
							Set xAntDesc=""
							For {
								Set xAntDesc = $o(^DHCHAI.DP.LabVisitRepRstSenI("IndexResultDrAntDesc",xReusltID,xAntDesc))
								Quit:xAntDesc=""
								
								Set xSenID = ""
								For {
									Set xSenID = $o(^DHCHAI.DP.LabVisitRepRstSenI("IndexResultDrAntDesc",xReusltID,xAntDesc,xSenID))
									Quit:xSenID=""
									
									Set objRstSen = ##class(DHCHAI.DP.LabVisitRepRstSen).GetObjById(xSenID)
									Continue:'$isobject(objRstSen)
									Set (AntCode,AntDesc,AntMapID,AntMapCode,AntMapDesc,Sensitivity,SensMapID,SensMapDesc)=""
									Set AntCode 	= objRstSen.LabAntCode
									Set AntDesc 	= objRstSen.LabAntDesc
									Set objAntiMap = ##class(DHCHAI.DP.LabAntiMap).GetObjByAntDesc(SCode,AntDesc)

									if ($isobject(objAntiMap)&objAntiMap.BTIsActive=1&$isobject(objAntiMap.BTMapItemDr))
									{
										Set AntMapID = objAntiMap.BTMapItemDr.%Id()
										Set AntMapCode = objAntiMap.BTMapItemDr.BTAntDesc
										Set AntMapDesc = objAntiMap.BTMapItemDr.BTAntCode
									}
									Set:AntMapDesc="" AntMapDesc = AntDesc
									Set Sensitivity = objRstSen.LabSensitivity
									Set SenPhraseMap = ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"LABTestRstSen",Sensitivity)
													
									Set:SenPhraseMap'="" SensMapID = $p(SenPhraseMap,"^",1)
									Set:SenPhraseMap'="" SensMapDesc = $p(SenPhraseMap,"^",3)
									
									Set:SensMapDesc="" SensMapDesc = Sensitivity
									Set Data=$lb(xVisitNumberDr,EpisodeNo,OrdTsDesc,Specimen,LocDesc,CollDateR,VisitReportID,LabReportID,AuthDateR,CollTime)
									Set Data = Data_$lb(xReusltID,xSenID,Bacteria,BactType,BacteriaMapID,BacteriaMapDesc,AntCode,AntDesc,AntMapID,AntMapCode,AntMapDesc,Sensitivity,SensMapID,SensMapDesc)
									Set ^CacheTemp(repid,ind)=Data
									Set ind=ind+1
											
								}
							}
						}
					}
				}				
			}
		}
	}
		
	Quit $$$OK
}

ClassMethod QryLabBacteriaSensClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabBacteriaSensExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabBacteriaSensFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabBacteriaSensExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     ShenC
/// CreatDate：   2021-11-01
/// Description:  根据检验报告ID判断是否异常[走监控结果表]
/// Table：       DHCHAI.IR.CCResult
/// Input：       aVisitRepID：院感系统报告ID
/// Return：      返回String
/// w ##class(DHCHAI.DPS.LabVisitRepSrv).Anomalyflag("2619","99412")
ClassMethod Anomalyflag(aPaadm As %String, aVisitRepID As %String) As %String
{
	New (aPaadm,aVisitRepID)
	Set return=""
	Quit:(aPaadm="")||(aVisitRepID="") return

	Set Anomalyflag=0
	Set MRBDesc=""
	//循环检验结果表
	Set xResultID=""
	For {
		Set xResultID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",aVisitRepID,xResultID))
		Quit:xResultID=""
		Quit:Anomalyflag=1
		
		//循环监控结果表
		Set xCCResult=""
		For{
			Set xCCResult=$o(^DHCHAI.IR.CCResultI("IndexEpisodeDr",aPaadm,xCCResult))
			Quit:xCCResult=""
			Quit:Anomalyflag=1
			
			Set ResultData=$g(^DHCHAI.IR.CCResultD(xCCResult))
			Continue:ResultData=""
			Set ItemDr=$lg(ResultData,3)
			Continue:ItemDr=""
			Set ItmMastData=$g(^DHCHAI.IR.CCItmMastD(ItemDr))
			Continue:ItmMastData=""
			Set ItemCode=$lg(ItmMastData,2)
			Continue:(ItemCode'="LAB-Bacteria")&&(ItemCode'="LAB-TestAb")		//检出菌
			Set Params=$lg(ResultData,19)
			Set ResultID = $p(Params,"=",2)  // 检验结果ID
			Continue:ResultID'=xResultID
			Set MRBTpDr=$lg(ResultData,24)   //多耐标志
			Set MRBInfo=""
			Set:MRBTpDr'="" MRBInfo=$g(^DHCHAI.IR.CRuleMRBD(MRBTpDr))
			Set:MRBInfo'="" MRBDesc=$lg(MRBInfo,3)
			Set Anomalyflag=1
		}
	}
	Set return=Anomalyflag_"^"_MRBDesc
	Quit return
}

}
