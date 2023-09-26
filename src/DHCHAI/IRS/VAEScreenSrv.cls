/// 名称: DHCHAI.IRS.VAEScreenSrv
/// 描述: VAE筛查相关服务
/// 编写者: zhoubo
/// 编写日期: 2022-03-14
Class DHCHAI.IRS.VAEScreenSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-03-14
/// Description:  VAE筛查
/// Table：       DHCHAI.DP.PAAdm 、 DHCHAI.DP.VAEICUPeep
/// Input：       aEpisodeDr: 就诊DR
///               aDateFrom : 开始日期
///               aDateTo : 结束日期
/// Return：      返回String
/// w ##class(DHCHAI.IRS.VAEScreenSrv).GetScreenResult("112","2022-07-07","2022-08-23")
ClassMethod GetScreenResult(aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeDr,aDateFrom,aDateTo)
	Set return=0
	Quit:(aEpisodeDr="")||(aDateFrom="")||(aDateTo="") return
	
	Set $ZT="GetScreenResultErr"
	
	Set objEpi=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objEpi) return
	
	// VAP筛查
		Set flg =..Check(aEpisodeDr,aDateFrom,aDateTo,"VAP")
	If (flg<1){
		// IVAC筛查
		Set flg =..Check(aEpisodeDr,aDateFrom,aDateTo,"IVAC")
		If (flg<1){
			// VAC筛查
			Set flg =..Check(aEpisodeDr,aDateFrom,aDateTo,"VAC")
		}
	}
	
	Quit 1
	
GetScreenResultErr
	Quit "-999^"_$ZError
}

/// Creator：     zhoubo
/// CreatDate：   2022-03-14
/// Description:  VAE规则筛查
/// Table：       DHCHAI.IR.VAERuleConfig,DHCHAI.DP.VAEICUPeep
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aDateFrom : 开始日期
///               aDateTo : 截止日期
///               aMonItemID : VAE项目
/// Return：      返回String
/// w ##class(DHCHAI.IRS.VAEScreenSrv).Check(aEpisodeDr,aSttDate,aEndDate,aMonItemID)
ClassMethod Check(aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String, aVAEType As %String) As %String
{
	new (aEpisodeDr,aDateFrom,aDateTo,aVAEType)
	Set return=0
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	
	Set $ZT="CheckErr"
	Set aMonItemID=..GetMonItemIDByCode(aVAEType)
	Quit:(aDateFrom="")||(aDateTo="")||(aMonItemID="")||(aEpisodeDr="") return
	
	Set VAELogic = ##class(DHCHAI.IR.VAERuleConfig).GetVAELogic(aMonItemID)
	
	If (VAELogic=""){  // 默认规则或的关系
		For xDate=aDateFrom:1:aDateTo{
			Do BuldResultData
			Continue:(VAEDate="")
			//获取触发项目
			Set VAEItemIDs=""
			Continue:(ArrResult.Count()<=0)
			
		 	Set Count = ArrResult.Count()
		 	For indArr =1:1:Count {
				Set ArrInfo = ArrResult.GetAt(indArr)
				Continue:ArrInfo=""
				Set SubItemDr=$p(ArrInfo,"^",1)
				Set SubItemCode=$p(ArrInfo,"^",2)
				Set VFlag=$p(ArrInfo,"^",3)
				
				If ((SubItemCode=1)||(SubItemCode=2)){  // VAE日期
					Set:VFlag=VAEDate VAEItemIDs=VAEItemIDs_"#"_SubItemDr
				}Else{
					Set:VFlag=1 VAEItemIDs=VAEItemIDs_"#"_SubItemDr
				}
		 	}
			Set:VAEItemIDs'="" VAEItemIDs=$e(VAEItemIDs,2,$l(VAEItemIDs))
			
			// 保存VAE筛查结果
			Set InputStr = ""
			Set InputStr = InputStr_"^"_aEpisodeDr			//就诊记录指针
			Set InputStr = InputStr_"^"_aMonItemID			//筛查项目
			Set InputStr = InputStr_"^"_VAEDate			    //VAE日期
			Set InputStr = InputStr_"^"_VAEItemIDs			//触发项目
			Set InputStr = InputStr_"^"_""			        //院感科确诊VAE日期
			Set InputStr = InputStr_"^"_""			        //院感科确诊VAE类型
			Set InputStr = InputStr_"^"_""			        //操作日期
			Set InputStr = InputStr_"^"_""			        //操作时间
			Set InputStr = InputStr_"^"_""			        //操作人
			Set InputStr = InputStr_"^"_+$h
			Set InputStr = InputStr_"^"_+$p($h,",",2)
		    Set InputStr = InputStr_"^"_"1"
		    Set InputStr = InputStr_"^"_""			        //处置状态
			Set InputStr = InputStr_"^"_""                  //排除原因
			Set RstDr = ##class(DHCHAI.IR.VAEResult).Update(InputStr,"^")
			If (+RstDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.IR.VAEResult"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(aEpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}Else{
				Set return=+RstDr
			}
			Kill Arresult
		}
		
	}Else{ //逻辑关系   VAELogic = (1或2)且(3或4)
		Set:VAELogic["或" VAELogic=$replace(VAELogic,"或","||")
		Set:VAELogic["且" VAELogic=$replace(VAELogic,"且","&&")
		// (1或2)且(3或4)   (1||1)&&(0||1)     
		For xDate=aDateFrom:1:aDateTo{
			Do BuldResultData
			//获取触发项目
			Continue:VAEDate=""
			Set VAEItemIDs=""
			Continue:(ArrResult.Count()<=0)
		 	Set Count = ArrResult.Count()
		 	For indArr =1:1:Count {
				Set ArrInfo = ArrResult.GetAt(indArr)
				Continue:ArrInfo=""
				Set SubItemDr=$p(ArrInfo,"^",1)
				Set SubItemCode=$p(ArrInfo,"^",2)
				Set VFlag=$p(ArrInfo,"^",3)
				If ((SubItemCode=1)||(SubItemCode=2)){  // VAE日期
					If (VFlag=VAEDate){
						Set VAEItemIDs=VAEItemIDs_"#"_SubItemDr
						Set VAELogic=$tr(VAELogic,SubItemCode,"T")
					}Else{
						Set VAELogic=$tr(VAELogic,SubItemCode,"F")
					}
				}Else{
					If (VFlag=1){
						Set VAEItemIDs=VAEItemIDs_"#"_SubItemDr
						Set VAELogic=$tr(VAELogic,SubItemCode,"T")
					}Else{
						Set VAELogic=$tr(VAELogic,SubItemCode,"F")
					}
				}
		 	}
		 	For indArr =1:1:8 {
				Set:VAELogic[indArr VAELogic=$tr(VAELogic,indArr,"0")
		 	}
		 	Set VAELogic=$tr(VAELogic,"T","1")
		 	Set VAELogic=$tr(VAELogic,"F","0")
			X "Set VAELogic="_VAELogic
			Continue:VAELogic'=1  // 不满足规则，退出
			
			Set:VAEItemIDs'="" VAEItemIDs=$e(VAEItemIDs,2,$l(VAEItemIDs))
			// 保存VAE筛查结果
			Set InputStr = ""
			Set InputStr = InputStr_"^"_aEpisodeDr			//就诊记录指针
			Set InputStr = InputStr_"^"_aMonItemID			//筛查项目
			Set InputStr = InputStr_"^"_VAEDate			    //VAE日期
			Set InputStr = InputStr_"^"_VAEItemIDs			//触发项目
			Set InputStr = InputStr_"^"_""			        //院感科确诊VAE日期
			Set InputStr = InputStr_"^"_""			        //院感科确诊VAE类型
			Set InputStr = InputStr_"^"_""			        //操作日期
			Set InputStr = InputStr_"^"_""			        //操作时间
			Set InputStr = InputStr_"^"_""			        //操作人
			Set InputStr = InputStr_"^"_+$h
			Set InputStr = InputStr_"^"_+$p($h,",",2)
		    Set InputStr = InputStr_"^"_"1"
		   	Set InputStr = InputStr_"^"_""			        //处置状态
			Set InputStr = InputStr_"^"_""                  //排除原因
			
			Set RstDr = ##class(DHCHAI.IR.VAEResult).Update(InputStr,"^")
			If (+RstDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.IR.VAEResult"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(aEpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}Else{
				Set return=+RstDr
			}
			Kill Arresult
		}
	}
	
	Kill Arresult
	Quit return
BuldResultData
	// 通过PEEP(呼吸末正压)、FiO2这两个指标确定VAE日期，以最早的为准
	// 因为后面的指标都必须围绕VAE日期去筛查
	Set ArrResult=##Class(%ArrayOfDataTypes).%New()
	Set VAEDate1="",VAEDate2=""
	Set xID=""
	For {
		Set xID=$o(^CT.MA.HAI.IR.VAERuleConfigI("IndexMonitItemDr",aMonItemID,xID))
		Quit:xID=""
		Set obj = ##class(DHCHAI.IR.VAERuleConfig).GetObjById(xID)
		Continue:'$Isobject(obj)
		Set VAEIsActive = +obj.VAEIsActive
		Continue:VAEIsActive'=1  //过滤无效的规则
		Set ObjSItem    = obj.VAESubItemDr
		Continue:'$isObject(ObjSItem)
		Set SubItemDr   = ObjSItem.%Id()
		Set VASItmCode  = ObjSItem.VASItmCode
		Set VASItmDesc  = ObjSItem.VASItmDesc
		Set VASResume   = ObjSItem.VASResume
		Continue:(VASItmCode'=1)&&(VASItmCode'=2)
		
		Set VAEArg1  = obj.VAEArg1
		Set VAEArg2  = obj.VAEArg2
		Set VAEArg3  = obj.VAEArg3
		// 通过这两个指标确定VAE日期，以最早的为准
		If (VASItmCode=1){  // PEEP(呼吸末正压)
			Set VAEDate1 = ##class(DHCHAI.IRS.VAEFunctionSrv).GetVAEPeep(aEpisodeDr,xDate,VAEArg1,VAEArg2,VAEArg3)
			If (VAEDate1'="" ){
				Set VAEDate1=$zdh(VAEDate1,3)
				Set ArrCnt=ArrResult.Count()
				Do ArrResult.SetAt(SubItemDr_"^"_VASItmCode_"^"_VAEDate1,ArrCnt+1)
			}
		}
		If (VASItmCode=2){  // FiO2(吸氧浓度) 
			Set VAEDate2 = ##class(DHCHAI.IRS.VAEFunctionSrv).GetVAEFio(aEpisodeDr,xDate,VAEArg1,VAEArg2,VAEArg3)
			If (VAEDate2'="" ){
				Set VAEDate2=$zdh(VAEDate2,3)
				Set ArrCnt=ArrResult.Count()
				Do ArrResult.SetAt(SubItemDr_"^"_VASItmCode_"^"_VAEDate2,ArrCnt+1)
			}
		}
	}
	Set VAEDate=VAEDate1
	If (VAEDate=""){
		Set VAEDate=VAEDate2	
	}Else{
		Set:((VAEDate2'="")&&(VAEDate>VAEDate2)) VAEDate=VAEDate2
	}
	Quit:VAEDate="" ""
		
	Set xID=""
	For {
		Set xID=$o(^CT.MA.HAI.IR.VAERuleConfigI("IndexMonitItemDr",aMonItemID,xID))
		Quit:xID=""
		Set obj = ##class(DHCHAI.IR.VAERuleConfig).GetObjById(xID)
		Continue:'$Isobject(obj)
		Set VAEIsActive = +obj.VAEIsActive
		Continue:VAEIsActive'=1  //过滤无效的规则
				
		Set ObjSItem    = obj.VAESubItemDr
		Continue:'$isObject(ObjSItem)
		Set SubItemDr   = ObjSItem.%Id()
		Set VASItmCode  = ObjSItem.VASItmCode
		Set VASItmDesc  = ObjSItem.VASItmDesc
		Set VASResume   = ObjSItem.VASResume
		Set VAEArg1  = obj.VAEArg1
		Set VAEArg2  = obj.VAEArg2
		Set VAEArg3  = obj.VAEArg3
		Set VAEArg4  = obj.VAEArg4
		Set VAEArg5  = obj.VAEArg5
		Continue:(VASItmCode=1)||(VASItmCode=2)
				
		If (VASItmCode=3){  // 发热 
			Set VFlag = ##class(DHCHAI.IRS.VAEFunctionSrv).GetFerverByDate(aEpisodeDr,VAEDate,VAEArg1,VAEArg2,VAEArg3,VAEArg4)
			If (VFlag=1){
				Set ArrCnt=ArrResult.Count()
				Do ArrResult.SetAt(SubItemDr_"^"_VASItmCode_"^"_VFlag,ArrCnt+1)
			}
		}
		If (VASItmCode=4){  // 持续发热  --- 暂时未启用 
			Set VFlag = ##class(DHCHAI.IRS.VAEFunctionSrv).GetContByDate(aEpisodeDr,VAEDate,VAEArg1)
			If (VFlag=1){
				Set ArrCnt=ArrResult.Count()
				Do ArrResult.SetAt(SubItemDr_"^"_VASItmCode_"^"_VFlag,ArrCnt+1)
			}
		}
		If (VASItmCode=5){  // 检出菌 
			Set VFlag = ##class(DHCHAI.IRS.VAEFunctionSrv).GetBactDate(aEpisodeDr,VAEDate,"2","2",VAEArg1,VAEArg2,VAEArg3)
			If (VFlag=1){
				Set ArrCnt=ArrResult.Count()
				Do ArrResult.SetAt(SubItemDr_"^"_VASItmCode_"^"_VFlag,ArrCnt+1)
			}
		}
		If (VASItmCode=6){  // 抗生素   --- 暂时未启用
			Set VFlag = ##class(DHCHAI.IRS.VAEFunctionSrv).GetAntiByDate(aEpisodeDr,VAEDate,VAEDate-4,VAEDate+4)
			If (VFlag=1){
				Set ArrCnt=ArrResult.Count()
				Do ArrResult.SetAt(SubItemDr_"^"_VASItmCode_"^"_VFlag,ArrCnt+1)
			}
		}
		If (VASItmCode=7){  // 持续使用抗生素
			Set VFlag = ##class(DHCHAI.IRS.VAEFunctionSrv).GetContAntiByDate(aEpisodeDr,VAEDate,VAEArg1,VAEArg2)
			If (VFlag=1){
				Set ArrCnt=ArrResult.Count()
				Do ArrResult.SetAt(SubItemDr_"^"_VASItmCode_"^"_VFlag,ArrCnt+1)
			}
		}
		If (VASItmCode=8){  // 白细胞计数
			Set VFlag = ##class(DHCHAI.IRS.VAEFunctionSrv).GetWBCDate(aEpisodeDr,VAEDate,"2","2",VAEArg1,VAEArg2,VAEArg3)
			If (VFlag=1){
				Set ArrCnt=ArrResult.Count()
				Do ArrResult.SetAt(SubItemDr_"^"_VASItmCode_"^"_VFlag,ArrCnt+1)
			}
		}
	}
	Quit 1	
CheckErr
	Quit "-999^"_$ZError
}

/// Creator：     zhoubo
/// CreatDate：   2022-03-14
/// Description:  根据代码获取VAE筛查规则ID
/// Table：       DHCHAI.IR.VAEMonitItem
/// Input：       aItmMastCode : 
/// Return：      DHCHAI.IR.VAEMonitItem.%Id()
/// w ##class(DHCHAI.IRS.VAEScreenSrv).GetMonItemIDByCode("VAC")
ClassMethod GetMonItemIDByCode(aVAECode As %String) As %String
{
	New (aVAECode)
	Set return=""
	Quit:aVAECode="" return
	Set objItem=##class(DHCHAI.IR.VAEMonitItem).GetObjByCode(aVAECode)
	Quit:'$IsObject(objItem) return
	Quit:objItem.VAIsActive'=1 return
	Set return=objItem.%Id()
	Quit return
}

}
