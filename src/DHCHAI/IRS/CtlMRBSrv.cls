/// 名称: DHCHAI.IRS.CtlMRBSrv
/// 描述: 耐药菌检测相关服务
/// 编写者：pylian
/// 编写日期: 2017-08-08
Class DHCHAI.IRS.CtlMRBSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2020-06-09
/// Description:  检出多耐菌向临床发送提醒消息
/// Table：       DHCHAI.IR.CRuleMRB
/// Input：       aEpisodeDr :就诊ID
///               aMRBTpDr   :多耐分类ID
///               aRepDate   :多耐报告日期
/// Return：      成功：返回消息ID，失败：返回空
/// w ##class(DHCHAI.IRS.CtlMRBSrv).SendMRBMsg("82",1,"2019-04-24")
ClassMethod SendMRBMsg(aEpisodeDr As %String, aMRBTpDr As %String, aRepDate As %String) As %String
{
	New (aEpisodeDr,aMRBTpDr,aRepDate)
	Set return=""
	Quit:((aEpisodeDr="")||(aMRBTpDr="")||(aRepDate="")) return
	Set:aRepDate["-" aRepDate=$zdh(aRepDate,3)
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set HisPaadm = $p(objEpisode.PAEpisodeIDx,"||",2)
	Quit:HisPaadm="" return
	Set objMRB=##class(DHCHAI.IR.CRuleMRB).GetObjById(aMRBTpDr)
	Quit:'$IsObject(objMRB) return
	Set MRBDesc=objMRB.BTDesc
	Set CSMsgDtlID=""
	//1:按照是否做隔离处理判断是否重复发送2:一次送检发送一次即可(默认为1)
	Set aMsgType = ##class(DHCHAI.BT.Config).GetValByCode("MRBSendMsgType","")
	Set:aMsgType="" aMsgType=1
	
	// 获取隔离医嘱列表,医嘱项ID列表
	Set ISOOEOrdList="",ISOOEARCIMList=""
	//多耐隔离医嘱是否唯一标识
	Set ISOOnlyFlag = ##class(DHCHAI.BT.Config).GetValByCode("IsolateOEOrdOnly","")	
	If (ISOOnlyFlag=1){ // 隔离医嘱唯一,只要下任何一个隔离医嘱都算隔离处理
		Set xBTSCode=""
		For {
			Set xBTSCode=$o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xBTSCode))
			Quit:xBTSCode=""
			
			Set xOrdDesc=""
			For {
				Set xOrdDesc=$o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xBTSCode,xOrdDesc))
				Quit:xOrdDesc=""
			
				Set xxID=""
				For {
					Set xxID=$o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xBTSCode,xOrdDesc,xxID))
					Quit:xxID=""
					
					Set objMastMap=##class(DHCHAI.DP.OEItmMastMap).GetObjById(xxID)
		 			Continue:'$IsObject(objMastMap)
						
					Set BTOrdDesc=objMastMap.BTOrdDesc
					Set OrdCatDesc=objMastMap.BTOrdCatDesc
					Set BTMapItemDr="",BTMapItemCode="",BTMapItemDesc=""
					Set BTMapCatDr="",BTMapCatCode="",BTMapCatDesc="",OETypeCode=""
					If $IsObject(objMastMap.BTMapItemDr) {
						Set BTMapItemDr=objMastMap.BTMapItemDr.%Id()
						Set BTMapItemCode=objMastMap.BTMapItemDr.BTCode
						Set BTMapItemDesc=objMastMap.BTMapItemDr.BTDesc					
						Set objMast=##class(DHCHAI.DP.OEItmMast).GetObjById(BTMapItemDr)
						If $IsObject(objMast.BTCatDr) {
							Set BTMapCatDr=objMast.BTCatDr.%Id()
							Set BTMapCatCode=objMast.BTCatDr.BTCode
							Set BTMapCatDesc=objMast.BTCatDr.BTDesc
							If $IsObject(objMast.BTCatDr.BTTypeDr){
								Set OETypeCode=objMast.BTCatDr.BTTypeDr.BTCode
							}
						}
					}
					Continue:(OETypeCode'="ISO") // 过滤非对照的隔离医嘱
					Set ISOOEOrdList = ISOOEOrdList_$lb(BTOrdDesc)
					// 获取医嘱项ID
					// ^ARCIM(0,"Desc",$$ALPHAUP({ARCIM_Desc}),{ARCIM_Subscript},{ARCIM_Version})
					If ($d(^ARCIM(0,"Desc",BTOrdDesc))){
						Set xItemSub=""
						For {
							Set xItemSub=$o(^ARCIM(0,"Desc",BTOrdDesc,xItemSub))   //update 20220905 处理多院区共库医院存在相同名称的隔离医嘱情况
							Quit:xItemSub=""
							
							Set xItemVer=""
							For {
								Set xItemVer=$o(^ARCIM(0,"Desc",BTOrdDesc,xItemSub,xItemVer))
								Quit:xItemVer=""
							  
								s ARCItemID=xItemSub_"||"_xItemVer
								Set ISOOEARCIMList = ISOOEARCIMList_$lb(ARCItemID)
							}
						}
					}
				}
			}
		}
	}		
	If (aMsgType=1){
		Set IsolateInfo=..CheckEpisISOAct(aEpisodeDr,aMRBTpDr,aRepDate)
		If (IsolateInfo=""){  // 未做隔离医嘱处理
			// 获取发送人ID
			Set ObjMed = ##class(DHCHAI.BT.SysUser).GetObjByUserCode("HIS01","med")
			Set MessageInfo = ..GetContentByKeys("多重耐药菌感染预防","多重耐药菌")
			Set Message = "该患者检出多耐菌："_MRBDesc_"。"_MessageInfo
			Set MsgCode=##class(DHCHAI.BT.Config).GetValByCode("MBRMsgCode")
			Set:MsgCode="" MsgCode="1079"
			Set otherInfoJson="{""linkParam"":""EpisodeDr="_aEpisodeDr_"&ResultID="_""_"""}"
			Set CSMsgDtlID = ##class(DHCHAI.IO.FromHisSrv).SendMsg(Message,MsgCode,$p(ObjMed.BTXCode,"||",2),HisPaadm,"",otherInfoJson)
			
			Set MessageStr = ""
			Set MessageStr = MessageStr_"^"_aEpisodeDr     // 就诊ID
			Set MessageStr = MessageStr_"^"_"3"            // 消息类型（1院感、2临床、3多耐）
			Set MessageStr = MessageStr_"^"_(+$h)          // 消息日期
			Set MessageStr = MessageStr_"^"_($p($h,",",2)) // 消息时间
			Set MessageStr = MessageStr_"^"_ObjMed.%Id()   // 发消息人
			Set MessageStr = MessageStr_"^"_""             // 消息科室
			Set MessageStr = MessageStr_"^"_Message        // 消息内容
			Set MessageStr = MessageStr_"^"_1              // 是否阅读
			Set MessageStr = MessageStr_"^"_(+$h)          // 阅读日期
			Set MessageStr = MessageStr_"^"_($p($h,",",2)) // 阅读时间
			Set MessageStr = MessageStr_"^"_ObjMed.%Id()   // 阅读者
			Set MessageStr = MessageStr_"^"_CSMsgDtlID     // HIS消息外部消息ID
			Set MsgID=##class(DHCHAI.IR.CCMessage).Update(MessageStr,"^")
		}
	}Else{
		// 发送一次即可,同种菌，之前发过消息就不在发送，7天为一个周期
		Set RepSendDay = ##class(DHCHAI.BT.Config).GetValByCode("MBRRepeatSendMsgDay")
		Set:RepSendDay="" RepSendDay=7   // 默认7天
		Set RepSendDay = +RepSendDay
		Set DischDate =objEpisode.PADischDate 
		Set StartDate="" ,EndDate=""
		Set StartDate=$s(aRepDate=+$h:aRepDate,1:aRepDate+1)  //检验出结果当天执行任务起始日期为当天，否则从第二天开始计算
		Set EndDate=$s(DischDate'="":DischDate,1:+$h)           //出院后再不重复发送消息
		For xDate=StartDate:1:EndDate { 
		    Set SendFlag=0	
			For xSendDate=xDate:-1:(xDate-RepSendDay) {  //周期内是否发送过消息
				Continue:'$d(^DHCHAI.IR.CCMessageI("IndexTypeDateTime",3,xSendDate))  //未发送消息
				Quit:(SendFlag=1)
				Set xTime = ""
				For {
					Set xTime = $o(^DHCHAI.IR.CCMessageI("IndexTypeDateTime",3,xSendDate,xTime))
					Quit:(xTime="")||(SendFlag=1)
				 	Set xID = ""
					For {
						Set xID = $o(^DHCHAI.IR.CCMessageI("IndexTypeDateTime",3,xSendDate,xTime,xID))
						Quit:(xID="")||(SendFlag=1)
						
						Set objMsg = ##class(DHCHAI.IR.CCMessage).GetObjById(xID)
						Continue:'$Isobject(objMsg)
						Continue:'$Isobject(objMsg.CSEpisodeDr)   
						Set EpisodeDr =objMsg.CSEpisodeDr.%Id()
						Continue:EpisodeDr'=aEpisodeDr    //update 20220124 过滤患者
						Set CSMessage = objMsg.CSMessage
						Set:CSMessage[MRBDesc SendFlag=1
					}
				}
			}
			Continue:SendFlag=1    //周期已发送过消息不再发送
			
			// 获取发送人ID
			Set ObjMed = ##class(DHCHAI.BT.SysUser).GetObjByUserCode("HIS01","med")
			Set MessageInfo = ..GetContentByKeys("多重耐药菌感染预防","多重耐药菌")
			Set Message = "该患者检出多耐菌："_MRBDesc_"。"_MessageInfo
			Set MsgCode=##class(DHCHAI.BT.Config).GetValByCode("MBRMsgCode")
			Set:MsgCode="" MsgCode="1079"
			Set otherInfoJson="{""linkParam"":""EpisodeDr="_aEpisodeDr_"&ResultID="_""_"""}"
			Set CSMsgDtlID = ##class(DHCHAI.IO.FromHisSrv).SendMsg(Message,MsgCode,$p(ObjMed.BTXCode,"||",2),HisPaadm,"",otherInfoJson)
						
			Set MessageStr = ""
			Set MessageStr = MessageStr_"^"_aEpisodeDr     // 就诊ID
			Set MessageStr = MessageStr_"^"_"3"            // 消息类型（1院感、2临床、3多耐）
			Set MessageStr = MessageStr_"^"_$s(xDate=+$h:+$h,1:xDate)          // 消息日期(应发消息日xDate，每日自动任务执行即任务当天)
			Set MessageStr = MessageStr_"^"_($p($h,",",2)) // 消息时间
			Set MessageStr = MessageStr_"^"_ObjMed.%Id()   // 发消息人
			Set MessageStr = MessageStr_"^"_""             // 消息科室
			Set MessageStr = MessageStr_"^"_Message        // 消息内容
			Set MessageStr = MessageStr_"^"_1              // 是否阅读
			Set MessageStr = MessageStr_"^"_(+$h)          // 阅读日期
			Set MessageStr = MessageStr_"^"_($p($h,",",2)) // 阅读时间
			Set MessageStr = MessageStr_"^"_ObjMed.%Id()   // 阅读者
			Set MessageStr = MessageStr_"^"_CSMsgDtlID     // HIS消息外部消息ID
			Set MsgID=##class(DHCHAI.IR.CCMessage).Update(MessageStr,"^")
			
		}

	}
	Quit CSMsgDtlID
}

/// Creator：     pylian
/// CreatDate：   2017-08-08
/// Description:  查询耐药菌监控结果
/// Table：       DHCHAI.IR.CCResult
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CtlMRBSrv","QryMRBResult","1|3|4","2","2022-08-01","2022-12-31","","","","","","2","1","1","","")
Query QryMRBResult(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aInfID As %String, aBactID As %String, aMRBID As %String, aWardID As %String = "", aIsUnRepeat As %String = "", aUnSpec As %String = "", aUnBact As %String = "", aStatus As %String = "", aIntputs As %String = "") As %Query(ROWSPEC = "ID:%String,AdmID:%String,EpisodeID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmBed:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,LocID:%String,LocCode:%String,LocDesc:%String,ActDate:%String,ActTime:%String,RepDate:%String,RepTime:%String,Specimen:%String,SpeID:%String,SpeCode:%String,SpeDesc:%String,Bacteria:%String,BacID:%String,BacCode:%String,BacDesc:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,ResultID:%String,LabRepID:%String,InfTypeID:%String,InfTypeCode:%String,InfTypeDesc:%String,INFMBRID:%String,ISOOrdDesc:%String,ISOSttDate:%String,ISOEndDate:%String,MRBID2:%String,MRBCode2:%String,MRBDesc2:%String,LabWardID:%String,LabWardCode:%String,LabWardDesc:%String,IsByHand:%String,RepID:%String,RepStatus:%String,RepUser:%String,UpdateDate:%String,UpdateTime:%String,UpdateLoc:%String,MRBOutLabType:%String,CurrAdmLoc:%String,CurrAdmBed:%String,ActDateTime,RepDateTime,ISOSttDateTime,ISOEndDateTime,Gap,PAAdmDoc") [ SqlProc ]
{
}

ClassMethod QryMRBResultExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aInfID As %String, aBactID As %String, aMRBID As %String, aWardID As %String = "", aIsUnRepeat As %String = "", aUnSpec As %String = "", aUnBact As %String = "", aStatus As %String = "", aIntputs As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aDateType="" $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set aPatName = $p(aIntputs,"^",1)
 	Set aPapmiNo = $p(aIntputs,"^",2)
 	Set aMrNo 	 = $p(aIntputs,"^",3)
 	
    //送检日期
    If aDateType=1{
	    Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID))
			Quit:xItemID=""
			
			Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
			Continue:'$IsObject(objItem)
			Set ItemCode=objItem.CCCode
			Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")
			
			Set xDate=aDateFrom-1  //fixbug:489631 不能查询到当天的数据
			For {
				Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate))
				Quit:xDate=""
				Quit:(xDate>aDateTo)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildMRBData
				}
			}
		}
		//增加外院携带的多耐信息 
		For xDate=aDateFrom:1:aDateTo {
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.OutLabReportI("IndexSubmissDate",xDate,xID))
				Quit:xID=""
				
				Do BuildOutMRBData
			}
		}
	} Else { //报告日期
		Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID))
			Quit:xItemID=""
			
			Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
			Continue:'$IsObject(objItem)
			Set ItemCode=objItem.CCCode //监控项目代码
			Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")  //检验-常规检验异常;检验-检出菌
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate))
				Quit:xDate=""
				Quit:(xDate>aDateTo)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildMRBData
				}
			}
		}
		//增加外院携带的多耐信息 
		For xDate=aDateFrom:1:aDateTo {
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.OutLabReportI("IndexLabAuthDate",xDate,xID))
				Quit:xID=""
				
				Do BuildOutMRBData
			}
		}
	}
	Quit $$$OK
BuildMRBData
	Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
	Quit:'$Isobject(objResult)
	Quit:objResult.CCIsActive'=1
	Set IsAbFlag=objResult.CCIsAbFlag   //异常标志
	Quit:IsAbFlag'=1 //过滤非耐药菌
	
	Set MRBID="",MRBCode="",MRBDesc=""
	If $IsObject(objResult.CCMRBTpDr) {   //多耐菌分类
		Set MRBID=objResult.CCMRBTpDr.%Id()
		Set MRBDesc = objResult.CCMRBTpDr.BTDesc
		Set MRBCode = objResult.CCMRBTpDr.BTCode
	}
	Quit:MRBDesc="" //过滤出多重耐药菌
	// 同一种菌满足两种多耐
	Set MRBID2="",MRBCode2="",MRBDesc2=""
	If $IsObject(objResult.CCMRBTp2Dr) {
		Set MRBID2=objResult.CCMRBTp2Dr.%Id()
		Set MRBDesc2 = objResult.CCMRBTp2Dr.BTDesc
		Set MRBCode2 = objResult.CCMRBTp2Dr.BTCode
	}
	Quit:(aMRBID'="")&&((aMRBID'=MRBID)&&(aMRBID'=MRBID2))
	
	Set AdmID  = objResult.CCEpisodeDr.%Id()
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(AdmID)
	Quit:'$Isobject(objAdm)
	
	//取多重耐药菌报告日期后的隔离医嘱名称和开始日期
	Set CCRepDate = objResult.CCRepDate
	Set (ISOOrdDesc,ISOSttDate,ISOSttTime,ISOEndDate,ISOEndTime)=""
	If (CCRepDate'=""){
		Set RSet=##Class(%ResultSet).%New("DHCHAI.DPS.OEOrdItemSrv:QryOEOrdItemISO")
	  	Set sc=RSet.Execute(AdmID)
	  	If $$$ISERR(sc) {
		  	Do $System.Status.DisplayError(sc)
		  	Quit
	  	}
		While (RSet.Next()){
			Set ISOOrdDesc = RSet.Data("OrdDesc")  // 隔离医嘱名称
			Set ISOSttDate = RSet.Data("SttDate")  // 医嘱开始日期
			Set ISOSttTime = RSet.Data("SttTime")  // 医嘱开始时间点
			If (RSet.Data("EndDate")=""){
				Set ISOEndDate = ""                		// 医嘱结束日期
				Set ISOEndTime = ""
				}
			else{
				Set ISOEndDate = RSet.Data("EndDate")   // 医嘱结束日期
				Set ISOEndTime = RSet.Data("EndTime")   // 医嘱结束时间点
				}
			Continue:ISOSttDate=""
			Set ISOSttDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ISOSttDate)
			Set ISOEndDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ISOEndDate)
			// CCRepDate 报告日期
			If (ISOSttDate>=CCRepDate){  // 隔离医嘱大于等于报告日期就算，不考虑时间
				Quit
			}
		}
	}
	Set:ISOSttDate'="" ISOSttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ISOSttDate)
	Set:ISOEndDate'="" ISOEndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ISOEndDate)
	Set EpisodeID = objAdm.PAEpisodeIDx
	Set PatientID = objAdm.PAPatientIDx
	Set PapmiNo   = objAdm.PAPapmiNo
	Set PAAdmDoc  = objAdm.PAAdmDoc
	Set:PAAdmDoc["|" PAAdmDoc=$p(PAAdmDoc,"|",3)
	Quit:(aPapmiNo'="")&(aPapmiNo'=PapmiNo)
	Set MrNo      = objAdm.PAMrNo
	Quit:(aMrNo'="")&(aMrNo'=MrNo)
	Set PatName   = objAdm.PAPatName
	Quit:(aPatName'="")&(PatName'[aPatName)
	Set Sex       = objAdm.PASex
	Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
	Set AdmDate   = objAdm.PAAdmDate
	Set AdmTime   = objAdm.PAAdmTime
	Set Age       =  objAdm.PAAge
	Set DischDate = objAdm.PADischDate
	Set DischTime = objAdm.PADischTime
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	// 当前科室,当前床号
	Set CurrDay=$p($h,",",1)
	Set CurrTime=$p($h,",",2)
	Set PatLocWardInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,CurrDay,CurrTime)
	Set CurrAdmLoc  = $p(PatLocWardInfo,"^",1) // 科室
	Set:CurrAdmLoc'="" CurrLocData=$g(^DHCHAI.BT.LocationD(CurrAdmLoc))
	If (CurrLocData'=""){
		Set CurrAdmLoc=$lg(CurrLocData,4)
		Set:CurrAdmLoc="" CurrAdmLoc=$lg(CurrLocData,3)
	}
	Set CurrAdmBed = $p(PatLocWardInfo,"^",4) // 床位
	
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set:DischTime'="" DischTime=$zt(DischTime,1)	
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objAdm.PAAdmBedDr){
		Set AdmBedDr=objAdm.PAAdmBedDr.%Id()
		Set AdmBed=objAdm.PAAdmBedDr.BTDesc
	}
	Set objAdmLoc = objAdm.PAAdmLocDr
	Set AdmLocID="", AdmLocDesc=""    //就诊科室
	If $Isobject(objAdmLoc) {
		Set AdmLocID = objAdmLoc.%Id()
		Set AdmLocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc2 = objAdmLoc.BTDesc2
		Set AdmLocDesc = $s(AdmLocDesc2'="":AdmLocDesc2,1:AdmLocDesc)
	}
	Set objAdmWard = objAdm.PAAdmWardDr
	Set AdmWardID="",AdmWardDesc=""   //就诊病区
	If $Isobject(objAdmWard) {
		Set AdmWardID  = objAdmWard.%Id()
		Set AdmWardDesc = objAdmWard.BTDesc
		Set AdmWardDesc2 = objAdmWard.BTDesc2
		Set AdmWardDesc = $s(AdmWardDesc2'="":AdmWardDesc2,1:AdmWardDesc)
		/*If $IsObject(objAdmWard.BTHospDr){
			Set HospID=objAdmWard.BTHospDr.%Id()			
			Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  	//医院过滤	
		}*/
	}
	Quit:(aLocID'="")&&((aLocID'=AdmWardID)&(aLocID'=AdmLocID))  //允许增加科室入参查询
   	//过滤院区-->aHospIDs(按送检/报告科室进行过滤院区)
	Set ActDate	=objResult.CCActDate	//送检日期		
	Set ActTime	=objResult.CCActTime	//送检时间
	Set RepDate =objResult.CCRepDate	//报告日期
	Set RepTime =objResult.CCRepTime	//报告时间
	If (aDateType=1){	//送检科室
		Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,ActDate,ActTime)
		Set ActLocID = $p(TransInfo,"^",1)
		Quit:ActLocID=""
		
		Set ActLocData  = $g(^DHCHAI.BT.LocationD(ActLocID))
		Set HospID = $li(ActLocData,8)
	}					
	else{				//报告科室
		Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,RepDate,RepTime)
		Set RepLocID = $p(TransInfo,"^",1)
		Quit:RepLocID=""
		
  		Set RepLocData  = $g(^DHCHAI.BT.LocationD(RepLocID))
		Set HospID = $li(RepLocData,8)
	}
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospID)<1) 	//医院过滤
   
	Set LocID="", LocCode="", LocDesc=""
	If $IsObject(objResult.CCActLocDr){
		Set LocID =  objResult.CCActLocDr.%Id()
		Set LocCode = objResult.CCActLocDr.BTCode
		Set LocDesc = objResult.CCActLocDr.BTDesc
		Set LocDesc2 = objResult.CCActLocDr.BTDesc2
		Set LocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	
	Set Result   = objResult.CCResult
	Set ActDate  = objResult.CCActDate
	Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set ActTime  = objResult.CCActTime
	Set:ActTime'="" ActTime=$zt(ActTime,1)
	Set RepDate  = objResult.CCRepDate
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set RepTime  = objResult.CCRepTime 
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	Set SCode    = objResult.CCSCode      //子系统代码
	Set Specimen = objResult.CCSpecimen   //原始标本名称
	Set SpeID="",SpeCode="",SpeDesc=""
	Set objSpe=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
	If $IsObject(objSpe) {
		If $IsObject(objSpe.BTMapItemDr){
			Set SpeID=objSpe.BTMapItemDr.%Id()
			Set SpeCode=objSpe.BTMapItemDr.BTSpecCode
			Set SpeDesc=objSpe.BTMapItemDr.BTSpecDesc
		}
	}
	Set Bacteria = objResult.CCBacteria   //原始细菌名称
	Quit:Bacteria=""
	Set BacID="",BacCode="",BacDesc=""
	Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	If $IsObject(objBactMap){
		Quit:objBactMap.BTIsActive'=1  //菌是否有效
		If $IsObject(objBactMap.BTMapItemDr){
			Set BacID=objBactMap.BTMapItemDr.%Id()
			Set BacCode=objBactMap.BTMapItemDr.BTBacCode
			Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
		}
	}
	Quit:BacID=""
	Quit:(aBactID'="")&&(BacID'=aBactID)
	
	//一份送检标本，检出多条菌，对应多条LabVisitRepResult和CCResult，但LabVisitReport唯一
	Set ResultID = $p(objResult.CCParams,"=",2)  //检验结果ID
	Set (LabRepID,LabWardID,LabWardCode,LabWardDesc,InfTypeCode,IsByHand) = ""
	Set objLabRes= ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResultID)
	If $IsObject(objLabRes) {
		Set LabRepID=objLabRes.LabReportDr.%Id()
		Set objLabRep=##class(DHCHAI.DP.LabVisitReport).GetObjById(LabRepID)
		If $IsObject(objLabRep.LabVisitNumberDr) {
			Set VisitNumberID=objLabRep.LabVisitNumberDr.%Id()
			Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(VisitNumberID)
			If $IsObject(objVisitNumber.LabWardDr) {
				Set LabWardID=objVisitNumber.LabWardDr.%Id()
				Set LabWardCode=objVisitNumber.LabWardDr.BTCode
				Set LabWardDesc=objVisitNumber.LabWardDr.BTDesc
				Set LabWardDesc2=objVisitNumber.LabWardDr.BTDesc2
				Set LabWardDesc = $s(LabWardDesc2'="":LabWardDesc2,1:LabWardDesc)
			}
		}
	    Set InfTypeCode = objLabRes.LabMakeInfType   //感染类型
	    Set IsByHand = objLabRes.LabIsByHand
	}	
	Quit:(aWardID'="")&&(LabWardID'=aWardID)&(aWardID'=LocID)  //允许增加科室入参查询
	Quit:LabWardID=""			
	Set INFMBRID=""
	Set objInf=##class(DHCHAI.IR.INFMBR).GetObjByRepBact(LabRepID,BacID)		     
	If $IsObject(objInf){
		Set INFMBRID =objInf.%Id()
	}
	Set InfTypeID="",InfTypeDesc=""
	Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfTypeCode)
    If $IsObject(objDic) {
	    Set InfTypeID 	= objDic.%Id()
	    Set InfTypeDesc = objDic.BTDesc		
	}
	Quit:(aInfID'="")&&((","_aInfID_",")'[(","_InfTypeID_","))

	//去重
	If (aIsUnRepeat=1) {
		Set IsFirst = ##Class(DHCHAI.IRS.CtlMRBSrv).IsFirstSend(AdmID,xID,aUnSpec,aUnBact)  //首次送检
   		Quit:(IsFirst'=1)
	}
	//评估状态
	Set RepID="",RepStatus="",StatusCode="",RepUser="",UpdateDate="",UpdateTime="",UpdateLoc=""  //多耐报告填写信息
	Set RepInfo =##Class(DHCHAI.IRS.INFMBRSrv).GetMBRRepID(AdmID,INFMBRID)
	If (RepInfo'=""){
		Set RepID      = $p(RepInfo,"^",1)
		Set UpdateDate = $p(RepInfo,"^",2)
		Set RepUser    = $p(RepInfo,"^",4)
		Set StatusCode = $p(RepInfo,"^",6)
		Set RepStatus  = $p(RepInfo,"^",7)
		Set UpdateTime = $p(RepInfo,"^",8)
		Set UpdateLoc  = $p(RepInfo,"^",10)
	}
	Quit:(aStatus'="")&&(((aStatus'=0)&&(aStatus'=StatusCode))||((aStatus=0)&&(StatusCode'="")))
	Set (ActDateTime,RepDateTime,ISOSttDateTime,ISOEndDateTime)=""
	Set:((ActDate'="")&(ActTime'="")) ActDateTime=ActDate_" "_ActTime
	Set:((RepDate'="")&(RepTime'="")) RepDateTime=RepDate_" "_RepTime
	Set:((ISOSttDate'="")&(ISOSttTime'="")) ISOSttDateTime=ISOSttDate_" "_ISOSttTime
	Set:((ISOEndDate'="")&(ISOEndTime'="")) ISOEndDateTime=ISOEndDate_" "_ISOEndTime
	Set (SttDateNum,RepDateNum,ISOSttTimeNum,RepTimeNum,SecondsGap,SecondsGapValue,DaysGap,DaysGapMore,HoursGap,HoursGapMore,MinutesGap,Gap)=""
	If (ISOSttDate'=""){
		Set SttDateNum = $zdh(ISOSttDate,3)
		Set RepDateNum = $zdh(RepDate,3)
		Set ISOSttTimeNum = $zth(ISOSttTime,3)
		Set RepTimeNum = $zth(RepTime,3)
		Set SecondsGap =((SttDateNum-RepDateNum)*24*3600)+(ISOSttTimeNum-RepTimeNum)
		Set:SecondsGap=0 Gap="无"
		Set SecondsGapValue=SecondsGap/(24*3600)
		
		Set:SecondsGapValue["." DaysGap=$p(SecondsGap/(24*3600),".",1)   //有小数
		Set:DaysGap="" DaysGap=0
		Set:SecondsGapValue'["." DaysGap=SecondsGapValue                 //无小数
		Set:DaysGap["-" DaysGap=$p($p(SecondsGap/(24*3600),".",1),"-",2) //去"-"号
		
		Set DaysGapMore=$p(SecondsGap/(24*3600),".",2)
		Set:DaysGapMore'="" HoursGap=$p((0_"."_DaysGapMore)*24,".",1)
		Set:DaysGapMore="" HoursGap=0
		
		Set HoursGapMore=$p(((0_"."_DaysGapMore)*24),".",2)
		Set:HoursGapMore'="" MinutesGap=$p((0_"."_HoursGapMore)*60,".",1)
		Set:HoursGapMore="" MinutesGap=0
		
		Set DateUnit1="天",DateUnit2="小时",DateUnit3="分钟",DateUnit4="前"
		Set DateUnit1 = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.patscreening.csp",DateUnit1)
		Set DateUnit2 = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.patscreening.csp",DateUnit2)
		Set DateUnit3 = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.patscreening.csp",DateUnit3)
		Set DateUnit4 = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.patscreening.csp",DateUnit4)
		
		Set:((SecondsGap>0)&(DaysGap>0)&(HoursGap=0)&(MinutesGap>0)) Gap=DaysGap_DateUnit1_MinutesGap_DateUnit3
		Set:((SecondsGap>0)&(DaysGap>0)&(HoursGap>0)&(MinutesGap=0)) Gap=DaysGap_DateUnit1_DateUnit2
		Set:((SecondsGap>0)&(DaysGap=0)&(HoursGap>0)&(MinutesGap>0)) Gap=HoursGap_DateUnit2_MinutesGap_DateUnit3
		Set:((SecondsGap>0)&(DaysGap=0)&(HoursGap=0)&(MinutesGap>0)) Gap=MinutesGap_DateUnit3
		Set:((SecondsGap>0)&(DaysGap=0)&(HoursGap>0)&(MinutesGap=0)) Gap=HoursGap_DateUnit2
		Set:((SecondsGap>0)&(DaysGap>0)&(HoursGap=0)&(MinutesGap=0)) Gap=DaysGap_DateUnit1
		Set:((SecondsGap>0)&(DaysGap>0)&(HoursGap>0)&(MinutesGap>0)) Gap=DaysGap_DateUnit1_HoursGap_DateUnit2_MinutesGap_DateUnit3
		
		Set:((SecondsGap<0)&(DaysGap>0)&(HoursGap>0)&(MinutesGap>0)) Gap=DateUnit4_DaysGap_DateUnit1_HoursGap_DateUnit2_MinutesGap_DateUnit3
		Set:((SecondsGap<0)&(DaysGap>0)&(HoursGap>0)&(MinutesGap=0)) Gap=DateUnit4_DaysGap_DateUnit1_HoursGap_DateUnit2
		Set:((SecondsGap<0)&(DaysGap=0)&(HoursGap>0)&(MinutesGap>0)) Gap=DateUnit4_HoursGap_DateUnit2_MinutesGap_DateUnit3
		Set:((SecondsGap<0)&(DaysGap>0)&(HoursGap=0)&(MinutesGap>0)) Gap=DateUnit4_DaysGap_DateUnit1_MinutesGap_DateUnit3
		Set:((SecondsGap<0)&(DaysGap=0)&(HoursGap=0)&(MinutesGap>0)) Gap=DateUnit4_MinutesGap_DateUnit3
		Set:((SecondsGap<0)&(DaysGap=0)&(HoursGap>0)&(MinutesGap=0)) Gap=DateUnit4_HoursGap_DateUnit2
		Set:((SecondsGap<0)&(DaysGap>0)&(HoursGap=0)&(MinutesGap=0)) Gap=DateUnit4_DaysGap_DateUnit1		
			
	}
	// 多语言处理
    Set PatName=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PatName,"User.SSUser")
    Set AdmLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmLocDesc,"User.CTLoc")
    Set AdmWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmWardDesc,"User.CTLoc")
    Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
    Set BacDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTBacDesc",BacDesc,"DHCHAI.DP.LabBacteria")       //细菌名称			
    Set SpeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",SpeDesc,"DHCHAI.DP.LabSpecimen")  
    Set MRBDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc,"DHCHAI.IR.CRuleMRB") 
    Set MRBDesc2=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc2,"DHCHAI.IR.CRuleMRB") 
    Set InfTypeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfTypeDesc,"DHCHAI.BT.Dictionary")
    Set LabWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LabWardDesc,"User.CTLoc")
   	Set ISOOrdDesc = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("ARCIMDesc",ISOOrdDesc,"User.ARCItmMast")
    Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")  //性别
	Set:Age["岁" Age=$Replace(Age,"岁",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","岁"))  //年龄
	Set:Age["月" Age=$Replace(Age,"月",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","月"))
	Set:Age["天" Age=$Replace(Age,"天",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","天"))
	Set RepStatus=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",RepStatus,"DHCHAI.BT.Dictionary")
	Set UpdateLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",UpdateLoc,"User.CTLoc")
	Set RepUser=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",RepUser,"User.SSUser")
	Set CurrAdmLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",CurrAdmLoc,"User.CTLoc")
	Set PAAdmDoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PAAdmDoc,"User.SSUser")
	Set CurrAdmBed=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",CurrAdmBed,"DHCHAI.BT.PACBed")
	Set AdmBed=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",AdmBed,"DHCHAI.BT.PACBed")
	
	Set Data = $lb(xID,AdmID,EpisodeID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime,LocID,LocCode,LocDesc,ActDate,ActTime,RepDate,RepTime,Specimen,SpeID,SpeCode,SpeDesc,Bacteria,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,ResultID,LabRepID,InfTypeID,InfTypeCode,InfTypeDesc,INFMBRID,ISOOrdDesc,ISOSttDate,ISOEndDate,MRBID2,MRBCode2,MRBDesc2,LabWardID,LabWardCode,LabWardDesc,IsByHand)
	Set Data = Data_$lb(RepID,RepStatus,RepUser,UpdateDate,UpdateTime,UpdateLoc,"")
	Set Data=Data_$lb(CurrAdmLoc,CurrAdmBed)
	Set Data=Data_$lb(ActDateTime,RepDateTime,ISOSttDateTime,ISOEndDateTime,Gap,PAAdmDoc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit 1
BuildOutMRBData
	Set objOut=##class(DHCHAI.IR.OutLabReport).GetObjById(xID)
	Quit:'$IsObject(objOut)
	Set LabIsActive = +objOut.LabIsActive
	Quit:(LabIsActive'=1)
	
	Set objAdm = objOut.LabEpisodeDr
	Quit:'$IsObject(objAdm)
	Set AdmID  = objAdm.%Id()
	Set IsAbFlag=1   //异常标志
	Set PAAdmDoc  = objAdm.PAAdmDoc
	Set:PAAdmDoc["|" PAAdmDoc=$p(PAAdmDoc,"|",3)
	//取多重耐药菌报告日期后的隔离医嘱名称和开始日期
	Set CCRepDate = objOut.LabAuthDate
	Set (ISOOrdDesc,ISOSttDate,ISOSttTime,ISOEndDate,ISOEndTime)=""
	If (CCRepDate'=""){
		Set RSet=##Class(%ResultSet).%New("DHCHAI.DPS.OEOrdItemSrv:QryOEOrdItemISO")
	  	Set sc=RSet.Execute(AdmID)
	  	If $$$ISERR(sc) {
		  	Do $System.Status.DisplayError(sc)
		  	Quit
	  	}
		While (RSet.Next()){
			Set ISOOrdDesc = RSet.Data("OrdDesc")  // 隔离医嘱名称
			Set ISOSttDate = RSet.Data("SttDate")  // 医嘱开始日期
			Set ISOSttTime = RSet.Data("SttTime")  // 医嘱开始时间点
			Continue:(ISOSttDate="")||(ISOSttTime="")
			If (RSet.Data("EndDate")=""){
				Set ISOEndDate = ""                		// 医嘱结束日期
				Set ISOEndTime = ""
				}
			else{
				Set ISOEndDate = RSet.Data("EndDate")   // 医嘱结束日期
				Set ISOEndDate = RSet.Data("EndTime")   // 医嘱结束时间点
				}
			Set ISOSttDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ISOSttDate)
			Set ISOEndDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ISOEndDate)
			// CCRepDate 报告日期
			If (ISOSttDate>=CCRepDate){  // 隔离医嘱大于等于报告日期就算，不考虑时间
				Quit
			}
		}
	}
	Set:ISOSttDate'="" ISOSttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ISOSttDate)
	Set:ISOEndDate'="" ISOEndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ISOEndDate)
	Set EpisodeID = objAdm.PAEpisodeIDx
	Set PatientID = objAdm.PAPatientIDx
	Set PapmiNo   = objAdm.PAPapmiNo
	Set MrNo      = objAdm.PAMrNo
	Set PatName   = objAdm.PAPatName
	Set Sex       = objAdm.PASex
	Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
	Set AdmDate   = objAdm.PAAdmDate
	Set AdmTime   = objAdm.PAAdmTime
	Set Age       =  objAdm.PAAge
	Set DischDate = objAdm.PADischDate
	Set DischTime = objAdm.PADischTime
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set:DischTime'="" DischTime=$zt(DischTime,1)	
	// 当前科室,当前床号
	Set CurrDay=$p($h,",",1)
	Set CurrTime=$p($h,",",2)
	Set PatLocWardInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,CurrDay,CurrTime)
	Set CurrAdmLoc  = $p(PatLocWardInfo,"^",1) // 科室
	Set:CurrAdmLoc'="" CurrLocData=$g(^DHCHAI.BT.LocationD(CurrAdmLoc))
	If (CurrLocData'=""){
		Set CurrAdmLoc=$lg(CurrLocData,4)
		Set:CurrAdmLoc="" CurrAdmLoc=$lg(CurrLocData,3)
	}
	Set CurrAdmBed = $p(PatLocWardInfo,"^",4) // 床位
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objAdm.PAAdmBedDr){
		Set AdmBedDr=objAdm.PAAdmBedDr.%Id()
		Set AdmBed=objAdm.PAAdmBedDr.BTDesc
	}
	Set objAdmLoc = objAdm.PAAdmLocDr
	Set AdmLocID="", AdmLocDesc=""    //就诊科室
	If $Isobject(objAdmLoc) {
		Set AdmLocID = objAdmLoc.%Id()
		Set AdmLocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc2 = objAdmLoc.BTDesc2
		Set AdmLocDesc = $s(AdmLocDesc2'="":AdmLocDesc2,1:AdmLocDesc)
	}
	Set objAdmWard = objAdm.PAAdmWardDr
	Set AdmWardID="",AdmWardDesc=""   //就诊病区
	If $Isobject(objAdmWard) {
		Set AdmWardID  = objAdmWard.%Id()
		Set AdmWardDesc = objAdmWard.BTDesc
		Set AdmWardDesc2 = objAdmWard.BTDesc2
		Set AdmWardDesc = $s(AdmWardDesc2'="":AdmWardDesc2,1:AdmWardDesc)
		If $IsObject(objAdmWard.BTHospDr){
			Set HospID=objAdmWard.BTHospDr.%Id()			
			Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  	//医院过滤	
		}
	}
	Quit:(aLocID'="")&&((aLocID'=AdmWardID)&(aLocID'=AdmLocID))  //允许增加科室入参查询
   
	Set ActDate  = objOut.SubmissDate
	Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set ActTime  = "1"
	Set:ActTime'="" ActTime=$zt(ActTime,1)
	Set RepDate  = objOut.LabAuthDate
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set RepTime  = "1"
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	
	Set BTTestSet="",BTTestSetID=""
	Set ObjTestSet = objOut.TestSetDr
	If ($IsObject(ObjTestSet)){
		Set BTTestSetID = ObjTestSet.%Id()
		Set BTTestSet   = ObjTestSet.BTTestSet
	}
	Set SpeID="",SpeCode="",SpeDesc=""
	Set ObjSpec = objOut.SpecimenDr
	If ($IsObject(ObjSpec)){
		Set SpeID   = ObjSpec.%Id()
		Set SpeCode = ObjSpec.BTSpecCode
		Set SpeDesc = ObjSpec.BTSpecDesc
	}
	Set Specimen = SpeDesc
	Set MRBOutLabType="外院携带"
	Set MRBOutLabTypeID = ##class(DHCHAI.BT.Dictionary).GetIDByDesc("MRBOutLabType",MRBOutLabType)
	
	Set BacID="",BacCode="",BacDesc=""
	Set ObjBacteria = objOut.BacteriaDr
	If ($IsObject(ObjBacteria)){
		Set BacID   = ObjBacteria.%Id()
		Set BacCode = ObjBacteria.BTBacCode
		Set BacDesc = ObjBacteria.BTBacDesc
	}
	Set LocID="", LocCode="", LocDesc=""
	If $IsObject(objOut.LabLocDr){
		Set LocID =  objOut.LabLocDr.%Id()
		Set LocCode = objOut.LabLocDr.BTCode
		Set LocDesc = objOut.LabLocDr.BTDesc
		Set LocDesc2 = objOut.LabLocDr.BTDesc2
		Set LocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	For xIndi=1:1:2{
		If (xIndi=1){
			//输出第一种菌信息
			If (BacID'=""){
				Set Bacteria = ""
				Set xBactMapID = ""
				For {
					Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
					Quit:xBactMapID="" 
						
					Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
					Continue:'$Isobject(objMap)
					Set Bacteria = objMap.BTBacteria
				}
				Continue:Bacteria=""
				Continue:(aBactID'="")&&(BacID'=aBactID)
				Set Result = Bacteria
				
				Set MRBID="",MRBCode="",MRBDesc=""
				Set ObjRuleMRB = objOut.RuleMRBDr
				If ($IsObject(ObjRuleMRB)){
					Set MRBID   = ObjRuleMRB.%Id()
					Set MRBDesc = ObjRuleMRB.BTDesc
					Set MRBCode = ObjRuleMRB.BTCode
				}
				Continue:MRBDesc="" //过滤出多重耐药菌
				Continue:(aMRBID'="")&&(aMRBID'=MRBID)
				
				// 同一种菌满足两种多耐
				Set MRBID2="",MRBCode2="",MRBDesc2=""
				
				Set ResultID = ""  //检验结果ID
				Set (LabRepID,LabWardID,LabWardCode,LabWardDesc,InfTypeCode,IsByHand) = ""	
				If $IsObject(objOut.LabWardDr){
					Set LabWardID =  objOut.LabWardDr.%Id()
					Set LabWardCode = objOut.LabWardDr.BTCode
					Set LabWardDesc = objOut.LabWardDr.BTDesc
					Set LabWardDesc2 = objOut.LabWardDr.BTDesc2
					Set LabWardDesc = $s(LabWardDesc2'="":LabWardDesc2,1:LabWardDesc)
				}
				Continue:LabWardID=""
				Continue:(aWardID'="")&&(LabWardID'=aWardID)&(aWardID'=LocID)  //允许增加科室入参查询
				Set LabRepID = xID_"||"_BacID
				Set INFMBRID=""
				Set objInf=##class(DHCHAI.IR.INFMBR).GetObjByOutRepBact(xID,BacID)		     
				If $IsObject(objInf){
					Set INFMBRID =objInf.%Id()
				}
				Set InfTypeCode = objOut.LabMakeInfType   //感染类型
				Set InfTypeID="",InfTypeDesc=""
				Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfTypeCode)
			    If $IsObject(objDic) {
				    Set InfTypeID 	= objDic.%Id()
				    Set InfTypeDesc = objDic.BTDesc		
				}
				Continue:(aInfID'="")&&((","_aInfID_",")'[(","_InfTypeID_","))
				
				//评估状态
				Set RepID="",RepStatus="",StatusCode="",RepUser="",UpdateDate="",UpdateTime="",UpdateLoc=""  //多耐报告填写信息
				Set RepInfo =##Class(DHCHAI.IRS.INFMBRSrv).GetMBRRepID(AdmID,INFMBRID)
				If (RepInfo'=""){
					Set RepID      = $p(RepInfo,"^",1)
					Set UpdateDate = $p(RepInfo,"^",2)
					Set RepUser    = $p(RepInfo,"^",4)
					Set StatusCode = $p(RepInfo,"^",6)
					Set RepStatus  = $p(RepInfo,"^",7)
					Set UpdateTime = $p(RepInfo,"^",8)
					Set UpdateLoc  = $p(RepInfo,"^",10)
				}
				Continue:(aStatus'="")&&(((aStatus'=0)&&(aStatus'=StatusCode))||((aStatus=0)&&(StatusCode'="")))
				
				Set (ActDateTime,RepDateTime,ISOSttDateTime,ISOEndDateTime)=""
				Set:((ActDate'="")&(ActTime'="")) ActDateTime=ActDate_" "_ActTime
				Set:((RepDate'="")&(RepTime'="")) RepDateTime=RepDate_" "_RepTime
				Set:((ISOSttDate'="")&(ISOSttTime'="")) ISOSttDateTime=ISOSttDate_" "_ISOSttTime
				Set:((ISOEndDate'="")&(ISOEndTime'="")) ISOEndDateTime=ISOEndDate_" "_ISOEndTime
				Set (SttDateNum,RepDateNum,ISOSttTimeNum,RepTimeNum,SecondsGap,SecondsGapValue,DaysGap,DaysGapMore,HoursGap,HoursGapMore,MinutesGap,Gap)=""
				If (ISOSttDate'=""){
					Set SttDateNum = $zdh(ISOSttDate,3)
					Set RepDateNum = $zdh(RepDate,3)
					Set ISOSttTimeNum = $zth(ISOSttTime,3)
					Set RepTimeNum = $zth(RepTime,3)
					Set SecondsGap =((SttDateNum-RepDateNum)*24*3600)+(ISOSttTimeNum-RepTimeNum)
					Set:SecondsGap=0 Gap="无"
					Set SecondsGapValue=SecondsGap/(24*3600)
					
					Set:SecondsGapValue["." DaysGap=$p(SecondsGap/(24*3600),".",1)   //有小数
					Set:DaysGap="" DaysGap=0
					Set:SecondsGapValue'["." DaysGap=SecondsGapValue                 //无小数
					Set:DaysGap["-" DaysGap=$p($p(SecondsGap/(24*3600),".",1),"-",2) //去"-"号
					
					Set DaysGapMore=$p(SecondsGap/(24*3600),".",2)
					Set:DaysGapMore'="" HoursGap=$p((0_"."_DaysGapMore)*24,".",1)
					Set:DaysGapMore="" HoursGap=0
					
					Set HoursGapMore=$p(((0_"."_DaysGapMore)*24),".",2)
					Set:HoursGapMore'="" MinutesGap=$p((0_"."_HoursGapMore)*60,".",1)
					Set:HoursGapMore="" MinutesGap=0
			
					Set DateUnit1="天",DateUnit2="小时",DateUnit3="分钟",DateUnit4="前"
					Set DateUnit1 = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.patscreening.csp",DateUnit1)
					Set DateUnit2 = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.patscreening.csp",DateUnit2)
					Set DateUnit3 = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.patscreening.csp",DateUnit3)
					Set DateUnit4 = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.patscreening.csp",DateUnit4)
		
					Set:((SecondsGap>0)&(DaysGap>0)&(HoursGap=0)&(MinutesGap>0)) Gap=DaysGap_DateUnit1_MinutesGap_DateUnit3
					Set:((SecondsGap>0)&(DaysGap>0)&(HoursGap>0)&(MinutesGap=0)) Gap=DaysGap_DateUnit1_DateUnit2
					Set:((SecondsGap>0)&(DaysGap=0)&(HoursGap>0)&(MinutesGap>0)) Gap=HoursGap_DateUnit2_MinutesGap_DateUnit3
					Set:((SecondsGap>0)&(DaysGap=0)&(HoursGap=0)&(MinutesGap>0)) Gap=MinutesGap_DateUnit3
					Set:((SecondsGap>0)&(DaysGap=0)&(HoursGap>0)&(MinutesGap=0)) Gap=HoursGap_DateUnit2
					Set:((SecondsGap>0)&(DaysGap>0)&(HoursGap=0)&(MinutesGap=0)) Gap=DaysGap_DateUnit1
					Set:((SecondsGap>0)&(DaysGap>0)&(HoursGap>0)&(MinutesGap>0)) Gap=DaysGap_DateUnit1_HoursGap_DateUnit2_MinutesGap_DateUnit3
			
					Set:((SecondsGap<0)&(DaysGap>0)&(HoursGap>0)&(MinutesGap>0)) Gap=DateUnit4_DaysGap_DateUnit1_HoursGap_DateUnit2_MinutesGap_DateUnit3
					Set:((SecondsGap<0)&(DaysGap>0)&(HoursGap>0)&(MinutesGap=0)) Gap=DateUnit4_DaysGap_DateUnit1_HoursGap_DateUnit2
					Set:((SecondsGap<0)&(DaysGap=0)&(HoursGap>0)&(MinutesGap>0)) Gap=DateUnit4_HoursGap_DateUnit2_MinutesGap_DateUnit3
					Set:((SecondsGap<0)&(DaysGap>0)&(HoursGap=0)&(MinutesGap>0)) Gap=DateUnit4_DaysGap_DateUnit1_MinutesGap_DateUnit3
					Set:((SecondsGap<0)&(DaysGap=0)&(HoursGap=0)&(MinutesGap>0)) Gap=DateUnit4_MinutesGap_DateUnit3
					Set:((SecondsGap<0)&(DaysGap=0)&(HoursGap>0)&(MinutesGap=0)) Gap=DateUnit4_HoursGap_DateUnit2
					Set:((SecondsGap<0)&(DaysGap>0)&(HoursGap=0)&(MinutesGap=0)) Gap=DateUnit4_DaysGap_DateUnit1		
						
				}
				// 多语言处理
			    Set PatName=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PatName,"User.SSUser")
			    Set AdmLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmLocDesc,"User.CTLoc")
			    Set AdmWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmWardDesc,"User.CTLoc")
			    Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
			    Set BacDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTBacDesc",BacDesc,"DHCHAI.DP.LabBacteria")       //细菌名称			
			    Set SpeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",SpeDesc,"DHCHAI.DP.LabSpecimen")  
			    Set MRBDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc,"DHCHAI.IR.CRuleMRB") 
			    Set MRBDesc2=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc2,"DHCHAI.IR.CRuleMRB") 
			    Set InfTypeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfTypeDesc,"DHCHAI.BT.Dictionary")
			    Set LabWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LabWardDesc,"User.CTLoc")
			   	Set ISOOrdDesc = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("ARCIMDesc",ISOOrdDesc,"User.ARCItmMast")
			    Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")  //性别
				Set:Age["岁" Age=$Replace(Age,"岁",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","岁"))  //年龄
				Set:Age["月" Age=$Replace(Age,"月",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","月"))
				Set:Age["天" Age=$Replace(Age,"天",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","天"))
				Set RepStatus=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",RepStatus,"DHCHAI.BT.Dictionary")
				Set UpdateLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",UpdateLoc,"User.CTLoc")
				Set RepUser=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",RepUser,"User.SSUser")
				Set CurrAdmLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",CurrAdmLoc,"User.CTLoc")
				Set PAAdmDoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PAAdmDoc,"User.SSUser")
				Set CurrAdmBed=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",CurrAdmBed,"DHCHAI.BT.PACBed")
				Set AdmBed=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",AdmBed,"DHCHAI.BT.PACBed")
				Set MRBOutLabType=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBOutLabType,"DHCHAI.BT.Dictionary")
				
				Set Data = $lb(xID,AdmID,EpisodeID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime,LocID,LocCode,LocDesc,ActDate,ActTime,RepDate,RepTime,Specimen,SpeID,SpeCode,SpeDesc,Bacteria,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,ResultID,LabRepID,InfTypeID,InfTypeCode,InfTypeDesc,INFMBRID,ISOOrdDesc,ISOSttDate,ISOEndDate,MRBID2,MRBCode2,MRBDesc2,LabWardID,LabWardCode,LabWardDesc,IsByHand)
				Set Data = Data_$lb(RepID,RepStatus,RepUser,UpdateDate,UpdateTime,UpdateLoc,MRBOutLabType)
				Set Data=Data_$lb(CurrAdmLoc,CurrAdmBed)
				Set Data=Data_$lb(ActDateTime,RepDateTime,ISOSttDateTime,ISOEndDateTime,Gap,PAAdmDoc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}Else{
			// 输出第二种菌相关信息
			Set BacID="",BacCode="",BacDesc=""
			Set ObjBacteria = objOut.BacteriaDr2
			If ($IsObject(ObjBacteria)){
				Set BacID   = ObjBacteria.%Id()
				Set BacCode = ObjBacteria.BTBacCode
				Set BacDesc = ObjBacteria.BTBacDesc
			}
			Continue:BacID=""
			Set Bacteria = ""
			Set xBactMapID = ""
			For {
				Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
				Quit:xBactMapID="" 
					
				Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
				Continue:'$Isobject(objMap)
				Set Bacteria = objMap.BTBacteria
			}
			Continue:Bacteria=""
			Continue:(aBactID'="")&&(BacID'=aBactID)
			Set Result = Bacteria
			
			Set MRBID="",MRBCode="",MRBDesc=""
			Set ObjRuleMRB = objOut.RuleMRBDr2
			If ($IsObject(ObjRuleMRB)){
				Set MRBID   = ObjRuleMRB.%Id()
				Set MRBDesc = ObjRuleMRB.BTDesc
				Set MRBCode = ObjRuleMRB.BTCode
			}
			Continue:MRBDesc="" //过滤出多重耐药菌
			Continue:(aMRBID'="")&&(aMRBID'=MRBID)
			Set ResultID = ""  //检验结果ID
			Set (LabRepID,LabWardID,LabWardCode,LabWardDesc,InfTypeCode,IsByHand) = ""	
			If $IsObject(objOut.LabWardDr){
				Set LabWardID =  objOut.LabWardDr.%Id()
				Set LabWardCode = objOut.LabWardDr.BTCode
				Set LabWardDesc = objOut.LabWardDr.BTDesc
				Set LabWardDesc2 = objOut.LabWardDr.BTDesc2
				Set LabWardDesc = $s(LabWardDesc2'="":LabWardDesc2,1:LabWardDesc)
			}
			Continue:LabWardID=""
			Continue:(aWardID'="")&&(LabWardID'=aWardID)&(aWardID'=LocID)  //允许增加科室入参查询
			Set LabRepID = xID_"||"_BacID
			Set INFMBRID=""
			Set objInf=##class(DHCHAI.IR.INFMBR).GetObjByOutRepBact(xID,BacID)		     
			If $IsObject(objInf){
				Set INFMBRID =objInf.%Id()
			}
			Set InfTypeCode = objOut.LabMakeInfType   //感染类型
			Set InfTypeID="",InfTypeDesc=""
			Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfTypeCode)
		    If $IsObject(objDic) {
			    Set InfTypeID 	= objDic.%Id()
			    Set InfTypeDesc = objDic.BTDesc		
			}
			Continue:(aInfID'="")&&((","_aInfID_",")'[(","_InfTypeID_","))
			//评估状态
			Set RepID="",RepStatus="",StatusCode="",RepUser="",UpdateDate="",UpdateTime="",UpdateLoc=""  //多耐报告填写信息
			Set RepInfo =##Class(DHCHAI.IRS.INFMBRSrv).GetMBRRepID(AdmID,INFMBRID)
			If (RepInfo'=""){
				Set RepID      = $p(RepInfo,"^",1)
				Set UpdateDate = $p(RepInfo,"^",2)
				Set RepUser    = $p(RepInfo,"^",4)
				Set StatusCode = $p(RepInfo,"^",6)
				Set RepStatus  = $p(RepInfo,"^",7)
				Set UpdateTime = $p(RepInfo,"^",8)
				Set UpdateLoc  = $p(RepInfo,"^",10)
			}
			Continue:(aStatus'="")&&(((aStatus'=0)&&(aStatus'=StatusCode))||((aStatus=0)&&(StatusCode'="")))
			Set (ActDateTime,RepDateTime,ISOSttDateTime,ISOEndDateTime)=""
			Set:((ActDate'="")&(ActTime'="")) ActDateTime=ActDate_" "_ActTime
			Set:((RepDate'="")&(RepTime'="")) RepDateTime=RepDate_" "_RepTime
			Set:((ISOSttDate'="")&(ISOSttTime'="")) ISOSttDateTime=ISOSttDate_" "_ISOSttTime
			Set:((ISOEndDate'="")&(ISOEndTime'="")) ISOEndDateTime=ISOEndDate_" "_ISOEndTime
			Set (SttDateNum,RepDateNum,ISOSttTimeNum,RepTimeNum,SecondsGap,SecondsGapValue,DaysGap,DaysGapMore,HoursGap,HoursGapMore,MinutesGap,Gap)=""
			If (ISOSttDate'=""){
				Set SttDateNum = $zdh(ISOSttDate,3)
				Set RepDateNum = $zdh(RepDate,3)
				Set ISOSttTimeNum = $zth(ISOSttTime,3)
				Set RepTimeNum = $zth(RepTime,3)
				Set SecondsGap =((SttDateNum-RepDateNum)*24*3600)+(ISOSttTimeNum-RepTimeNum)
				Set:SecondsGap=0 Gap="无"
				Set SecondsGapValue=SecondsGap/(24*3600)
				
				Set:SecondsGapValue["." DaysGap=$p(SecondsGap/(24*3600),".",1)   //有小数
				Set:DaysGap="" DaysGap=0
				Set:SecondsGapValue'["." DaysGap=SecondsGapValue                 //无小数
				Set:DaysGap["-" DaysGap=$p($p(SecondsGap/(24*3600),".",1),"-",2) //去"-"号
				
				Set DaysGapMore=$p(SecondsGap/(24*3600),".",2)
				Set:DaysGapMore'="" HoursGap=$p((0_"."_DaysGapMore)*24,".",1)
				Set:DaysGapMore="" HoursGap=0
				
				Set HoursGapMore=$p(((0_"."_DaysGapMore)*24),".",2)
				Set:HoursGapMore'="" MinutesGap=$p((0_"."_HoursGapMore)*60,".",1)
				Set:HoursGapMore="" MinutesGap=0
			
				Set DateUnit1="天",DateUnit2="小时",DateUnit3="分钟",DateUnit4="前"
				Set DateUnit1 = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.patscreening.csp",DateUnit1)
				Set DateUnit2 = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.patscreening.csp",DateUnit2)
				Set DateUnit3 = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.patscreening.csp",DateUnit3)
				Set DateUnit4 = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.patscreening.csp",DateUnit4)
		
				Set:((SecondsGap>0)&(DaysGap>0)&(HoursGap=0)&(MinutesGap>0)) Gap=DaysGap_DateUnit1_MinutesGap_DateUnit3
				Set:((SecondsGap>0)&(DaysGap>0)&(HoursGap>0)&(MinutesGap=0)) Gap=DaysGap_DateUnit1_DateUnit2
				Set:((SecondsGap>0)&(DaysGap=0)&(HoursGap>0)&(MinutesGap>0)) Gap=HoursGap_DateUnit2_MinutesGap_DateUnit3
				Set:((SecondsGap>0)&(DaysGap=0)&(HoursGap=0)&(MinutesGap>0)) Gap=MinutesGap_DateUnit3
				Set:((SecondsGap>0)&(DaysGap=0)&(HoursGap>0)&(MinutesGap=0)) Gap=HoursGap_DateUnit2
				Set:((SecondsGap>0)&(DaysGap>0)&(HoursGap=0)&(MinutesGap=0)) Gap=DaysGap_DateUnit1
				Set:((SecondsGap>0)&(DaysGap>0)&(HoursGap>0)&(MinutesGap>0)) Gap=DaysGap_DateUnit1_HoursGap_DateUnit2_MinutesGap_DateUnit3
			
				Set:((SecondsGap<0)&(DaysGap>0)&(HoursGap>0)&(MinutesGap>0)) Gap=DateUnit4_DaysGap_DateUnit1_HoursGap_DateUnit2_MinutesGap_DateUnit3
				Set:((SecondsGap<0)&(DaysGap>0)&(HoursGap>0)&(MinutesGap=0)) Gap=DateUnit4_DaysGap_DateUnit1_HoursGap_DateUnit2
				Set:((SecondsGap<0)&(DaysGap=0)&(HoursGap>0)&(MinutesGap>0)) Gap=DateUnit4_HoursGap_DateUnit2_MinutesGap_DateUnit3
				Set:((SecondsGap<0)&(DaysGap>0)&(HoursGap=0)&(MinutesGap>0)) Gap=DateUnit4_DaysGap_DateUnit1_MinutesGap_DateUnit3
				Set:((SecondsGap<0)&(DaysGap=0)&(HoursGap=0)&(MinutesGap>0)) Gap=DateUnit4_MinutesGap_DateUnit3
				Set:((SecondsGap<0)&(DaysGap=0)&(HoursGap>0)&(MinutesGap=0)) Gap=DateUnit4_HoursGap_DateUnit2
				Set:((SecondsGap<0)&(DaysGap>0)&(HoursGap=0)&(MinutesGap=0)) Gap=DateUnit4_DaysGap_DateUnit1		
						
			}
			
			// 多语言处理
		    Set PatName=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PatName,"User.SSUser")
		    Set AdmLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmLocDesc,"User.CTLoc")
		    Set AdmWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmWardDesc,"User.CTLoc")
		    Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
		    Set BacDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTBacDesc",BacDesc,"DHCHAI.DP.LabBacteria")       //细菌名称			
		    Set SpeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",SpeDesc,"DHCHAI.DP.LabSpecimen")  
		    Set MRBDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc,"DHCHAI.IR.CRuleMRB") 
		    Set MRBDesc2=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc2,"DHCHAI.IR.CRuleMRB") 
		    Set InfTypeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfTypeDesc,"DHCHAI.BT.Dictionary")
		    Set LabWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LabWardDesc,"User.CTLoc")
		   	Set ISOOrdDesc = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("ARCIMDesc",ISOOrdDesc,"User.ARCItmMast")
		    Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")  //性别
			Set:Age["岁" Age=$Replace(Age,"岁",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","岁"))  //年龄
			Set:Age["月" Age=$Replace(Age,"月",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","月"))
			Set:Age["天" Age=$Replace(Age,"天",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","天"))
			Set RepStatus=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",RepStatus,"DHCHAI.BT.Dictionary")
			Set UpdateLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",UpdateLoc,"User.CTLoc")
			Set RepUser=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",RepUser,"User.SSUser")
			Set CurrAdmLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",CurrAdmLoc,"User.CTLoc")
			Set PAAdmDoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PAAdmDoc,"User.SSUser")
			Set CurrAdmBed=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",CurrAdmBed,"DHCHAI.BT.PACBed")
			Set AdmBed=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",AdmBed,"DHCHAI.BT.PACBed")
			Set MRBOutLabType=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBOutLabType,"DHCHAI.BT.Dictionary")
				
			Set Data = $lb(xID,AdmID,EpisodeID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime,LocID,LocCode,LocDesc,ActDate,ActTime,RepDate,RepTime,Specimen,SpeID,SpeCode,SpeDesc,Bacteria,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,ResultID,LabRepID,InfTypeID,InfTypeCode,InfTypeDesc,INFMBRID,ISOOrdDesc,ISOSttDate,ISOEndDate,MRBID2,MRBCode2,MRBDesc2,LabWardID,LabWardCode,LabWardDesc,IsByHand)
			Set Data = Data_$lb(RepID,RepStatus,RepUser,UpdateDate,UpdateTime,UpdateLoc,MRBOutLabType)
			Set Data=Data_$lb(CurrAdmLoc,CurrAdmBed)
			Set Data=Data_$lb(ActDateTime,RepDateTime,ISOSttDateTime,ISOEndDateTime,Gap,PAAdmDoc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	
		}
	}
	Quit 1
}

ClassMethod QryMRBResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBResultExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMRBResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBResultExecute ]
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

/// Creator：     pylian
/// CreatDate：   2022-06-21
/// Description:  查询耐药菌监控结果
/// Table：       DHCHAI.IR.CCResult
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CtlMRBSrv","StaMRBResult","1|3|4","2","2020-08-01","2022-08-23")
Query StaMRBResult(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String = "") As %Query(ROWSPEC = "DataIndex:%String,DataDesc:%String,MRBNum:%String,MRBRatio:%String") [ SqlProc ]
{
}

ClassMethod StaMRBResultExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aDateType="" $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
   
    Set IndexName="IndexItemActDate"   //送检日期
    Set:aDateType=2 IndexName="IndexItemRepDate"   //报告日期
    Set IndexName2="IndexSubmissDate"   //送检日期
    Set:aDateType=2 IndexName2="IndexLabAuthDate"   //报告日期 
    Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"StaMRBResult")
	
    Set xItemID=""
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI(IndexName,xItemID))
		Quit:xItemID=""
		
		Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Set ItemCode=objItem.CCCode
		Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")
		
		
		Set xDate=aDateFrom-1  //fixbug:489631 不能查询到当天的数据
		For {
			Set xDate=$o(^DHCHAI.IR.CCResultI(IndexName,xItemID,xDate))
			Quit:xDate=""
			Quit:(xDate>aDateTo)
			
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI(IndexName,xItemID,xDate,xID))
				Quit:xID=""
					
				Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$Isobject(objResult)
				Continue:'$Isobject(objResult.CCEpisodeDr)
				Continue:objResult.CCIsActive'=1
				Set IsAbFlag=objResult.CCIsAbFlag   //异常标志
				Continue:IsAbFlag'=1 //过滤非耐药菌
				Continue:'$IsObject(objResult.CCMRBTpDr)   //多耐菌分类

				Set SCode    = objResult.CCSCode      //子系统代码
				Set Bacteria = objResult.CCBacteria   //原始细菌名称
				Continue:Bacteria=""
				Set BacID=""
				Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
				Continue:'$IsObject(objBactMap)
				Continue:objBactMap.BTIsActive'=1  //菌是否有效
				If $IsObject(objBactMap.BTMapItemDr){
					Set BacID=objBactMap.BTMapItemDr.%Id()
				}
				Continue:BacID=""
				
				Set AdmID  = objResult.CCEpisodeDr.%Id()	
				//一份送检标本，检出多条菌，对应多条LabVisitRepResult和CCResult，但LabVisitReport唯一
				Set LabResID = $p(objResult.CCParams,"=",2)  //检验结果ID
				Set LabRepID = "",LabWardID="",LabLocID=""
				Set objLabRes= ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(LabResID)
				If $IsObject(objLabRes) {
					Set LabRepID=objLabRes.LabReportDr.%Id()
					Set objLabRep=##class(DHCHAI.DP.LabVisitReport).GetObjById(LabRepID)
					If $IsObject(objLabRep.LabVisitNumberDr) {
						Set VisitNumberID=objLabRep.LabVisitNumberDr.%Id()
						Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(VisitNumberID)
						If $IsObject(objVisitNumber.LabLocDr) {	
							Set LabLocID=objVisitNumber.LabLocDr.%Id()
						}
						If $IsObject(objVisitNumber.LabWardDr) {	
							Set LabWardID=objVisitNumber.LabWardDr.%Id()
						}
					}
				}
				Continue:LabWardID=""
				Continue:(aLocID'="")&(aLocID'=LabLocID)&(aLocID'=LabWardID)	
				Set MRBRepID=""
				Set objInfMBR=##class(DHCHAI.IR.INFMBR).GetObjByRepBact(LabRepID,BacID)
				If $IsObject(objInfMBR) {
					Set MRBRepID=objInfMBR.%Id()
				}
				//评估状态
				Set RepStatus="",StatusCode=""
				Set RepInfo =##Class(DHCHAI.IRS.INFMBRSrv).GetMBRRepID(AdmID,MRBRepID)
				If (RepInfo'=""){
					Set:RepInfo'="" RepStatus = $p(RepInfo,"^",7)
					Set:RepInfo'="" StatusCode = $p(RepInfo,"^",6)
				}
			    Set:StatusCode="" StatusCode=0
				Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","LocStat","MRBNum","合计"))
				Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","LocStat","MRBNum",LabWardID))
				
				Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","BacStat","MRBNum","合计"))
				Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","BacStat","MRBNum",BacID))
				
				Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","StatusStat","MRBNum","合计"))
				Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","StatusStat","MRBNum",StatusCode))
				
			}
		}
	}
	
	//增加外院携带的多耐信息
	For xDate=aDateFrom:1:aDateTo {
		Set xOutID=""
		For {
			Set xOutID=$o(^DHCHAI.IR.OutLabReportI(IndexName2,xDate,xOutID))
			
			Quit:xOutID=""
			Set objOut=##class(DHCHAI.IR.OutLabReport).GetObjById(xOutID)
			Continue:'$IsObject(objOut)
			Set LabIsActive = +objOut.LabIsActive
			Continue:(LabIsActive'=1)
			Set objAdm = objOut.LabEpisodeDr
			Continue:'$IsObject(objAdm)
			Set AdmID  = objAdm.%Id()
			Set BacID="",BacCode="",BacDesc=""
			Set ObjBacteria = objOut.BacteriaDr
			If ($IsObject(ObjBacteria)){
				Set BacID   = ObjBacteria.%Id()
				Set BacCode = ObjBacteria.BTBacCode
				Set BacDesc = ObjBacteria.BTBacDesc
			}
			Set (LabLocID,LabLocCode,LabLocDesc) = ""	
			If $IsObject(objOut.LabLocDr){
				Set LabLocID =  objOut.LabLocDr.%Id()
				Set LabLocCode = objOut.LabLocDr.BTCode
				Set LabLocDesc = objOut.LabLocDr.BTDesc
				Set LabLocDesc2 = objOut.LabLocDr.BTDesc2
				Set LabLocDesc = $s(LabLocDesc2'="":LabLocDesc2,1:LabLocDesc)
			}
			Set (LabWardID,LabWardCode,LabWardDesc) = ""	
			If $IsObject(objOut.LabWardDr){
				Set LabWardID =  objOut.LabWardDr.%Id()
				Set LabWardCode = objOut.LabWardDr.BTCode
				Set LabWardDesc = objOut.LabWardDr.BTDesc
				Set LabWardDesc2 = objOut.LabWardDr.BTDesc2
				Set LabWardDesc = $s(LabWardDesc2'="":LabWardDesc2,1:LabWardDesc)
			}
			Continue:(LabWardID="")
			Continue:(aLocID'="")&(aLocID'=LabLocID)&(aLocID'=LabWardID)
			If (BacID'=""){
				Set ObjRuleMRB = objOut.RuleMRBDr
				If ($IsObject(ObjRuleMRB)){
					Set Bacteria=""
					Set xBactMapID = ""
					For {
						Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
						Quit:xBactMapID="" 
							
						Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
						Continue:'$Isobject(objMap)
						Set Bacteria = objMap.BTBacteria
					}
					If (Bacteria'=""){
						Set LabRepID = xOutID_"||"_BacID
						Set MRBRepID=""
						Set objInfMBR=##class(DHCHAI.IR.INFMBR).GetObjByOutRepBact(xOutID,BacID)
						If $IsObject(objInfMBR) {
							Set MRBRepID=objInfMBR.%Id()
						}
						//评估状态
						Set RepStatus="",StatusCode=""
						Set RepInfo =##Class(DHCHAI.IRS.INFMBRSrv).GetMBRRepID(AdmID,MRBRepID)
						If (RepInfo'=""){
							Set:RepInfo'="" RepStatus = $p(RepInfo,"^",7)
							Set:RepInfo'="" StatusCode = $p(RepInfo,"^",6)
						}
					    Set:StatusCode="" StatusCode=0
						Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","LocStat","MRBNum","合计"))
						Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","LocStat","MRBNum",LabWardID))
						Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","BacStat","MRBNum","合计"))
						Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","BacStat","MRBNum",BacID))
						
						Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","StatusStat","MRBNum","合计"))
						Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","StatusStat","MRBNum",StatusCode))
					}
				}
			}	
				
			// 输出第二种菌相关信息
			Set BacID="",BacCode="",BacDesc=""
			Set ObjBacteria = objOut.BacteriaDr2
			If ($IsObject(ObjBacteria)){
				Set BacID   = ObjBacteria.%Id()
				Set BacCode = ObjBacteria.BTBacCode
				Set BacDesc = ObjBacteria.BTBacDesc
			}
			If (BacID'=""){
				Set ObjRuleMRB = objOut.RuleMRBDr2
				If ($IsObject(ObjRuleMRB)){
					Set Bacteria=""
					Set xBactMapID = ""
					For {
						Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
						Quit:xBactMapID="" 
							
						Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
						Continue:'$Isobject(objMap)
						Set Bacteria = objMap.BTBacteria
					}
					If (Bacteria'=""){
						Set LabRepID = xOutID_"||"_BacID
						Set MRBRepID=""
						Set objInfMBR=##class(DHCHAI.IR.INFMBR).GetObjByOutRepBact(xOutID,BacID)
						If $IsObject(objInfMBR) {
							Set MRBRepID=objInfMBR.%Id()
						}
						//评估状态
						Set RepStatus="",StatusCode=""
						Set RepInfo =##Class(DHCHAI.IRS.INFMBRSrv).GetMBRRepID(AdmID,MRBRepID)
						If (RepInfo'=""){
							Set:RepInfo'="" RepStatus = $p(RepInfo,"^",7)
							Set:RepInfo'="" StatusCode = $p(RepInfo,"^",6)
						}
					    Set:StatusCode="" StatusCode=0
						Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","LocStat","MRBNum","合计"))
						Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","LocStat","MRBNum",LabWardID))
						
						Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","BacStat","MRBNum","合计"))
						Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","BacStat","MRBNum",BacID))
						
						Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","StatusStat","MRBNum","合计"))
						Set num=$i(^TMP(ZIndex,JIndex,"StaMRBResult","StatusStat","MRBNum",StatusCode))
					}
				}
			}
		}
	}
	//显示科室汇总信息
	Set MRBCount=+$g(^TMP(ZIndex,JIndex,"StaMRBResult","LocStat","MRBNum","合计"))
	Set xLocID="",Count=0
	For {
		Set xLocID=$o(^TMP(ZIndex,JIndex,"StaMRBResult","LocStat","MRBNum",xLocID))
		Quit:xLocID=""
		
		Set MRBNum=+$g(^TMP(ZIndex,JIndex,"StaMRBResult","LocStat","MRBNum",xLocID))
		If xLocID="合计" {
			Set LocDesc="合计"
			Set MRBRatio=""
		} Else {
			Set LocDesc=$lg($g(^DHCHAI.BT.LocationD(xLocID)),3)
			Set LocDesc2 = $lg($g(^DHCHAI.BT.LocationD(xLocID)),4)
			Set LocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
			If MRBCount>0 {
				Set MRBRatio=$fn((MRBNum/MRBCount)*100,"",2)_"%"
			} Else {
				Set MRBRatio="0.00%"
			}
		}
		Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
		Set:LocDesc="合计" LocDesc=##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.mrb.ctlresult.csp","合计")
		Set Count=Count+1
		Set Data=$lb("LocStat-"_xLocID,LocDesc,MRBNum,MRBRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	If Count>0 {
		Set ^CacheTemp(repid,ind)=$lb("LocStat-Null","","","")
		Set ind=ind+1
	}
	
	//显示细菌信息
	Set MRBCount=+$g(^TMP(ZIndex,JIndex,"StaMRBResult","BacStat","MRBNum","合计"))
	Set xBacID="",Count=0
	For {
		Set xBacID=$o(^TMP(ZIndex,JIndex,"StaMRBResult","BacStat","MRBNum",xBacID))
		Quit:xBacID=""
		
		Set MRBNum=+$g(^TMP(ZIndex,JIndex,"StaMRBResult","BacStat","MRBNum",xBacID))
		If xBacID="合计" {
			Set BacDesc="合计"
			Set MRBRatio=""
		} Else {
			Set BacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(xBacID)),3)
			Set:BacDesc="" BacDesc="其他"
			If MRBCount>0 {
				Set MRBRatio=$fn((MRBNum/MRBCount)*100,"",2)_"%"
			} Else {
				Set MRBRatio="0.00%"
			}
		}
		
		//多语言
		Set BacDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTBacDesc",BacDesc,"DHCHAI.DP.LabBacteria")
		Set:BacDesc="合计" BacDesc=##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.mrb.ctlresult.csp","合计")
		Set:BacDesc="其他" BacDesc=##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.mrb.ctlresult.csp","其他")
		Set Count=Count+1
		Set Data=$lb("BacStat-"_xBacID,BacDesc,MRBNum,MRBRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	If Count>0 {
		Set ^CacheTemp(repid,ind)=$lb("BacStat-Null","","","")
		Set ind=ind+1
	}
	
	//调查状态汇总
	Set MRBCount=+$g(^TMP(ZIndex,JIndex,"StaMRBResult","StatusStat","MRBNum","合计"))
	Set xStatus="",Count=0
	For {
		Set xStatus=$o(^TMP(ZIndex,JIndex,"StaMRBResult","StatusStat","MRBNum",xStatus))
		Quit:xStatus=""
		
		Set MRBNum=+$g(^TMP(ZIndex,JIndex,"StaMRBResult","StatusStat","MRBNum",xStatus))
		If xStatus="合计" {
			Set Status="合计"
			Set MRBRatio=""
		} Else {
			Set:xStatus=0 Status="未评估"
			If (xStatus'=0) {
				Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("InfReportStatus",xStatus)
				Continue:'$IsObject(objDic)
				Set Status = objDic.BTDesc
			}else {
				Set Status="未评估"
			}
			If MRBCount>0 {
				Set MRBRatio=$fn((MRBNum/MRBCount)*100,"",2)_"%"
			} Else {
				Set MRBRatio="0.00%"
			}
		}
		Set Status=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",Status,"DHCHAI.BT.Dictionary") 
		Set:Status="合计" Status=##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.mrb.ctlresult.csp","合计")
		Set:Status="未评估" Status=##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.mrb.ctlresult.csp","未评估")
		Set Count=Count+1
		Set Data=$lb("StatusStat-"_xStatus,Status,MRBNum,MRBRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP(ZIndex,JIndex,"StaMRBResult")
	
	Quit $$$OK
}

ClassMethod StaMRBResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaMRBResultExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaMRBResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaMRBResultExecute ]
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
/// CreatDate：   2019-04-22
/// Description:  根据就诊号查询耐药菌监控结果
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CtlMRBSrv","QryMRBByEpsodeDr","110")
Query QryMRBByEpsodeDr(aEpisodeDr As %String) As %Query(ROWSPEC = "ResultID:%String,AdmID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmBed:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,LocID:%String,LocCode:%String,LocDesc:%String,ActDate:%String,ActTime:%String,RepDate:%String,RepTime:%String,Specimen:%String,SpeID:%String,SpeCode:%String,SpeDesc:%String,Bacteria:%String,BacID:%String,BacCode:%String,BacDesc:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,MRBID2:%String,MRBCode2:%String,MRBDesc2:%String,PAAdmDoc:%String,MRBActFlag:%String,IsolateInfo:%String,LabResID:%String,LabRepID:%String,MRBRepID:%String,InfTypeID:%String,InfTypeCode:%String,InfTypeDesc:%String,MRBOutLabType:%String") [ SqlProc ]
{
}

ClassMethod QryMRBByEpsodeDrExecute(ByRef qHandle As %Binary, aEpisodeDr As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
    Set EpisodeDr = aEpisodeDr
    Quit:EpisodeDr="" $$$OK
    
    // 获取隔离医嘱列表,医嘱项ID列表
	Set ISOOEOrdList="",ISOOEARCIMList=""
	//多耐隔离医嘱是否唯一标识
	Set ISOOnlyFlag = ##class(DHCHAI.BT.Config).GetValByCode("IsolateOEOrdOnly","")	
	If (ISOOnlyFlag=1){ // 隔离医嘱唯一,只要下任何一个隔离医嘱都算隔离处理
		Set xBTSCode=""
		For {
			Set xBTSCode=$o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xBTSCode))
			Quit:xBTSCode=""
			
			Set xOrdDesc=""
			For {
				Set xOrdDesc=$o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xBTSCode,xOrdDesc))
				Quit:xOrdDesc=""
			
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xBTSCode,xOrdDesc,xID))
					Quit:xID=""
					
					Set objMastMap=##class(DHCHAI.DP.OEItmMastMap).GetObjById(xID)
		 			Continue:'$IsObject(objMastMap)
						
					Set BTOrdDesc=objMastMap.BTOrdDesc
					Set OrdCatDesc=objMastMap.BTOrdCatDesc
					Set BTMapItemDr="",BTMapItemCode="",BTMapItemDesc=""
					Set BTMapCatDr="",BTMapCatCode="",BTMapCatDesc="",OETypeCode=""
					If $IsObject(objMastMap.BTMapItemDr) {
						Set BTMapItemDr=objMastMap.BTMapItemDr.%Id()
						Set BTMapItemCode=objMastMap.BTMapItemDr.BTCode
						Set BTMapItemDesc=objMastMap.BTMapItemDr.BTDesc					
						Set objMast=##class(DHCHAI.DP.OEItmMast).GetObjById(BTMapItemDr)
						If $IsObject(objMast.BTCatDr) {
							Set BTMapCatDr=objMast.BTCatDr.%Id()
							Set BTMapCatCode=objMast.BTCatDr.BTCode
							Set BTMapCatDesc=objMast.BTCatDr.BTDesc
							If $IsObject(objMast.BTCatDr.BTTypeDr){
								Set OETypeCode=objMast.BTCatDr.BTTypeDr.BTCode
							}
						}
					}
					Continue:(OETypeCode'="ISO") // 过滤非对照的隔离医嘱
					Set ISOOEOrdList = ISOOEOrdList_$lb(BTOrdDesc)
					// 获取医嘱项ID
					// ^ARCIM(0,"Desc",$$ALPHAUP({ARCIM_Desc}),{ARCIM_Subscript},{ARCIM_Version})
					If ($d(^ARCIM(0,"Desc",BTOrdDesc))){
						Set xItemSub=""
						For {
							Set xItemSub=$o(^ARCIM(0,"Desc",BTOrdDesc,xItemSub))   //update 20220905 处理多院区共库医院存在相同名称的隔离医嘱情况
							Quit:xItemSub=""
							
							Set xItemVer=""
							For {
								Set xItemVer=$o(^ARCIM(0,"Desc",BTOrdDesc,xItemSub,xItemVer))
								Quit:xItemVer=""
							  
								s ARCItemID=xItemSub_"||"_xItemVer
								Set ISOOEARCIMList = ISOOEARCIMList_$lb(ARCItemID)
							}
						}
					}

				}
			}
		}
	}
		
    Set xItem=""
	For {
		Set xItem=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",EpisodeDr,xItem))
		Quit:xItem=""
		Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItem)
		Continue:'$IsObject(objItem)
		Set ItemCode=objItem.CCCode
		Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")
		Set xDate=""
		For {
			Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",EpisodeDr,xItem,xDate))
			Quit:xDate=""
			Set xResultID=""
			For {
				Set xResultID=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",EpisodeDr,xItem,xDate,xResultID))
				Quit:xResultID=""
				
				Do BuildMRBInfoData
			}
		}
	}
	//增加外院携带的多耐信息 
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.IR.OutLabReportI("IndexEpisodeDr",aEpisodeDr,xID))
		Quit:xID=""
		
		Set objOut=##class(DHCHAI.IR.OutLabReport).GetObjById(xID)
		Continue:'$IsObject(objOut)
		Set LabIsActive = +objOut.LabIsActive
		Continue:(LabIsActive'=1)
		
		Set objAdm = objOut.LabEpisodeDr
		Continue:'$IsObject(objAdm)
		Set AdmID  = objAdm.%Id()
		Set IsAbFlag=1   //异常标志
		Set EpisodeID = objAdm.PAEpisodeIDx
		Set PatientID = objAdm.PAPatientIDx
		Set PapmiNo   = objAdm.PAPapmiNo
		Set MrNo      = objAdm.PAMrNo
		Set PatName   = objAdm.PAPatName
		Set Sex       = objAdm.PASex
		Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
		Set AdmDate   = objAdm.PAAdmDate
		Set AdmTime   = objAdm.PAAdmTime
		Set Age       =  objAdm.PAAge
		Set DischDate = objAdm.PADischDate
		Set DischTime = objAdm.PADischTime
		Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
		Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
		Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
		Set:DischTime'="" DischTime=$zt(DischTime,1)	
		Set (AdmBedDr,AdmBed)=""
		If $IsObject(objAdm.PAAdmBedDr){
			Set AdmBedDr=objAdm.PAAdmBedDr.%Id()
			Set AdmBed=objAdm.PAAdmBedDr.BTDesc
		}
		Set objAdmLoc = objAdm.PAAdmLocDr
		Set AdmLocID="", AdmLocDesc=""    //就诊科室
		If $Isobject(objAdmLoc) {
			Set AdmLocID = objAdmLoc.%Id()
			Set AdmLocDesc = objAdmLoc.BTDesc
			Set AdmLocDesc2 = objAdmLoc.BTDesc2
			Set AdmLocDesc = $s(AdmLocDesc2'="":AdmLocDesc2,1:AdmLocDesc)
		}
		Set objAdmWard = objAdm.PAAdmWardDr
		Set AdmWardID="",AdmWardDesc=""   //就诊病区
		If $Isobject(objAdmWard) {
			Set AdmWardID  = objAdmWard.%Id()
			Set AdmWardDesc = objAdmWard.BTDesc
			Set AdmWardDesc2 = objAdmWard.BTDesc2
			Set AdmWardDesc = $s(AdmWardDesc2'="":AdmWardDesc2,1:AdmWardDesc)
		}
		
		Set ActDate  = objOut.SubmissDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime  = "1"
		Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set RepDate  = objOut.LabAuthDate
		Continue:RepDate=""
		Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		Set RepTime  = "1"
		Set:RepTime'="" RepTime=$zt(RepTime,1)
		Set PAAdmDoc  = objAdm.PAAdmDoc
		Set:PAAdmDoc["|" PAAdmDoc=$p(PAAdmDoc,"|",3)
		Set BTTestSet="",BTTestSetID=""
		Set ObjTestSet = objOut.TestSetDr
		If ($IsObject(ObjTestSet)){
			Set BTTestSetID = ObjTestSet.%Id()
			Set BTTestSet   = ObjTestSet.BTTestSet
		}
		Set SpeID="",SpeCode="",SpeDesc=""
		Set ObjSpec = objOut.SpecimenDr
		If ($IsObject(ObjSpec)){
			Set SpeID   = ObjSpec.%Id()
			Set SpeCode = ObjSpec.BTSpecCode
			Set SpeDesc = ObjSpec.BTSpecDesc
		}
		Set Specimen = SpeDesc
		Set MRBOutLabType="外院携带"
		Set MRBOutLabTypeID = ##class(DHCHAI.BT.Dictionary).GetIDByDesc("MRBOutLabType",MRBOutLabType)
		
		Set BacID="",BacCode="",BacDesc=""
		Set ObjBacteria = objOut.BacteriaDr
		If ($IsObject(ObjBacteria)){
			Set BacID   = ObjBacteria.%Id()
			Set BacCode = ObjBacteria.BTBacCode
			Set BacDesc = ObjBacteria.BTBacDesc
		}
		Set LocID="", LocCode="", LocDesc=""
		If $IsObject(objOut.LabLocDr){
			Set LocID =  objOut.LabLocDr.%Id()
			Set LocCode = objOut.LabLocDr.BTCode
			Set LocDesc = objOut.LabLocDr.BTDesc
			Set LocDesc2 = objOut.LabLocDr.BTDesc2
			Set LocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
		}
		For xIndi=1:1:2{
			If (xIndi=1){
				//输出第一种菌信息
				If (BacID'=""){
					Set Bacteria = ""
					Set xBactMapID = ""
					For {
						Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
						Quit:xBactMapID="" 
							
						Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
						Continue:'$Isobject(objMap)
						Set Bacteria = objMap.BTBacteria
					}
					If (Bacteria'=""){
						Set MRBID="",MRBCode="",MRBDesc=""
						Set ObjRuleMRB = objOut.RuleMRBDr
						If ($IsObject(ObjRuleMRB)){
							Set MRBID   = ObjRuleMRB.%Id()
							Set MRBDesc = ObjRuleMRB.BTDesc
							Set MRBCode = ObjRuleMRB.BTCode
						}
						Continue:MRBDesc="" //过滤出多重耐药菌
						// 根据多耐分类+就诊+报告日期判断是否已做隔离处理
						// 如果报告日期大于等于隔离医嘱结束日期，则未做隔离处理，为后面再次检出的多耐
						Set MRBActFlag=""
						Set IsolateInfo=..CheckEpisISOAct(aEpisodeDr,MRBID,objOut.LabAuthDate)
						Set:IsolateInfo'="" MRBActFlag=##class(websys.Translation).Get("dhcma.hai.ir.mbrlistinfo.csp","已做隔离处理")
			
						// 同一种菌满足两种多耐
						Set MRBID2="",MRBCode2="",MRBDesc2=""
						
						Set ResultID = ""  //检验结果ID
						Set (LabRepID,LabWardID,LabWardCode,LabWardDesc,InfTypeCode,IsByHand) = ""	
						If $IsObject(objOut.LabWardDr){
							Set LabWardID =  objOut.LabWardDr.%Id()
							Set LabWardCode = objOut.LabWardDr.BTCode
							Set LabWardDesc = objOut.LabWardDr.BTDesc
							Set LabWardDesc2 = objOut.LabWardDr.BTDesc2
							Set LabWardDesc = $s(LabWardDesc2'="":LabWardDesc2,1:LabWardDesc)
						}
						Set LabResID = ""
						Set LabRepID = xID_"||"_BacID
						Set INFMBRID=""
						Set objInf=##class(DHCHAI.IR.INFMBR).GetObjByOutRepBact(xID,BacID)		     
						If $IsObject(objInf){
							Set INFMBRID =objInf.%Id()
						}
						Set InfTypeCode = objOut.LabMakeInfType   //感染类型
						Set InfTypeID="",InfTypeDesc=""
						Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfTypeCode)
					    If $IsObject(objDic) {
						    Set InfTypeID 	= objDic.%Id()
						    Set InfTypeDesc = objDic.BTDesc		
						}
						Set (MRBID2,MRBCode2,MRBDesc2)=""
						//多语言
						Set:InfTypeDesc'="" InfTypeDesc=##class(websys.Translation).Get("dhcma.hai.ir.mrb.ctlreport.csp",InfTypeDesc)
						Set AdmLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmLocDesc,"User.CTLoc")
						Set AdmWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmWardDesc,"User.CTLoc")
						Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
						Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")
						Set:Age["岁" Age=$Replace(Age,"岁",##class(websys.Translation).Get("Bill.Com.Age","岁"))
						Set SpeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",SpeDesc,"DHCHAI.DP.LabSpecimen")
						Set Data = $lb(xID,AdmID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime,LocID,LocCode,LocDesc,ActDate,ActTime,RepDate,RepTime,Specimen,SpeID,SpeCode,SpeDesc,Bacteria,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,MRBID2,MRBCode2,MRBDesc2,PAAdmDoc,MRBActFlag,IsolateInfo,LabResID,LabRepID,INFMBRID,InfTypeID,InfTypeCode,InfTypeDesc,MRBOutLabType)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}Else{
				// 输出第二种菌相关信息
				Set BacID="",BacCode="",BacDesc=""
				Set ObjBacteria = objOut.BacteriaDr2
				If ($IsObject(ObjBacteria)){
					Set BacID   = ObjBacteria.%Id()
					Set BacCode = ObjBacteria.BTBacCode
					Set BacDesc = ObjBacteria.BTBacDesc
				}
				If (BacID'=""){
					Set Bacteria = ""
					Set xBactMapID = ""
					For {
						Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
						Quit:xBactMapID="" 
							
						Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
						Continue:'$Isobject(objMap)
						Set Bacteria = objMap.BTBacteria
					}
					Continue:Bacteria=""
					Set MRBID="",MRBCode="",MRBDesc=""
					Set ObjRuleMRB = objOut.RuleMRBDr2
					If ($IsObject(ObjRuleMRB)){
						Set MRBID   = ObjRuleMRB.%Id()
						Set MRBDesc = ObjRuleMRB.BTDesc
						Set MRBCode = ObjRuleMRB.BTCode
					}
					Continue:MRBDesc="" //过滤出多重耐药菌
					// 根据多耐分类+就诊+报告日期判断是否已做隔离处理
					// 如果报告日期大于等于隔离医嘱结束日期，则未做隔离处理，为后面再次检出的多耐
					Set MRBActFlag=""
					Set IsolateInfo=..CheckEpisISOAct(aEpisodeDr,MRBID,objOut.LabAuthDate)
					Set:IsolateInfo'="" MRBActFlag=##class(websys.Translation).Get("dhcma.hai.ir.mbrlistinfo.csp","已做隔离处理")
		
					// 同一种菌满足两种多耐
					Set MRBID2="",MRBCode2="",MRBDesc2=""
					
					Set ResultID = ""  //检验结果ID
					Set (LabRepID,LabWardID,LabWardCode,LabWardDesc,InfTypeCode,IsByHand) = ""	
					If $IsObject(objOut.LabWardDr){
						Set LabWardID =  objOut.LabWardDr.%Id()
						Set LabWardCode = objOut.LabWardDr.BTCode
						Set LabWardDesc = objOut.LabWardDr.BTDesc
						Set LabWardDesc2 = objOut.LabWardDr.BTDesc2
						Set LabWardDesc = $s(LabWardDesc2'="":LabWardDesc2,1:LabWardDesc)
					}
					Set LabResID = ""
					Set LabRepID = xID_"||"_BacID
					Set INFMBRID=""
					Set objInf=##class(DHCHAI.IR.INFMBR).GetObjByOutRepBact(xID,BacID)		     
					If $IsObject(objInf){
						Set INFMBRID =objInf.%Id()
					}
					Set InfTypeCode = objOut.LabMakeInfType   //感染类型
					Set InfTypeID="",InfTypeDesc=""
					Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfTypeCode)
				    If $IsObject(objDic) {
					    Set InfTypeID 	= objDic.%Id()
					    Set InfTypeDesc = objDic.BTDesc		
					}
					Set (MRBID2,MRBCode2,MRBDesc2)=""
					//多语言
					Set:InfTypeDesc'="" InfTypeDesc=##class(websys.Translation).Get("dhcma.hai.ir.mrb.ctlreport.csp",InfTypeDesc)
					Set AdmLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmLocDesc,"User.CTLoc")
					Set AdmWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmWardDesc,"User.CTLoc")
					Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
					Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")
					Set:Age["岁" Age=$Replace(Age,"岁",##class(websys.Translation).Get("Bill.Com.Age","岁"))
					Set SpeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",SpeDesc,"DHCHAI.DP.LabSpecimen")
					Set Data = $lb(xID,AdmID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime,LocID,LocCode,LocDesc,ActDate,ActTime,RepDate,RepTime,Specimen,SpeID,SpeCode,SpeDesc,Bacteria,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,MRBID2,MRBCode2,MRBDesc2,PAAdmDoc,MRBActFlag,IsolateInfo,LabResID,LabRepID,INFMBRID,InfTypeID,InfTypeCode,InfTypeDesc,MRBOutLabType)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}	
			}
		}
	}
	Quit $$$OK
BuildMRBInfoData
	Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
	Quit:'$Isobject(objResult)
	Quit:objResult.CCIsActive'=1
	Set IsAbFlag=objResult.CCIsAbFlag
	Quit:IsAbFlag'=1 //过滤非耐药菌
	
	Set MRBID="",MRBCode="",MRBDesc=""
	If $IsObject(objResult.CCMRBTpDr) {
		
		Set MRBID=objResult.CCMRBTpDr.%Id()
		Set MRBDesc = objResult.CCMRBTpDr.BTDesc
		Set MRBCode = objResult.CCMRBTpDr.BTCode
	}
	// 根据多耐分类+就诊+报告日期判断是否已做隔离处理
	// 如果报告日期大于等于隔离医嘱结束日期，则未做隔离处理，为后面再次检出的多耐
	Set MRBActFlag=""
	Set RepDate = objResult.CCRepDate
	Quit:RepDate="" // 报告日期为空退出
	Set IsolateInfo=..CheckEpisISOAct(EpisodeDr,MRBID,RepDate)
	Set:IsolateInfo'="" MRBActFlag=##class(websys.Translation).Get("dhcma.hai.ir.mbrlistinfo.csp","已做隔离处理")
	Quit:MRBDesc="" //过滤出多重耐药菌
	// 同一种菌满足两种多耐
	Set MRBID2="",MRBCode2="",MRBDesc2=""
	If $IsObject(objResult.CCMRBTp2Dr) {
		
		Set MRBID2=objResult.CCMRBTp2Dr.%Id()
		Set MRBDesc2 = objResult.CCMRBTp2Dr.BTDesc
		Set MRBCode2 = objResult.CCMRBTp2Dr.BTCode
	}
	Set AdmID  = objResult.CCEpisodeDr.%Id()
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(AdmID)
	Quit:'$Isobject(objAdm)
	Set EpisodeID = objAdm.PAEpisodeIDx
	Set PatientID = objAdm.PAPatientIDx
	Set PapmiNo   = objAdm.PAPapmiNo
	Set MrNo      = objAdm.PAMrNo
	Set PatName   = objAdm.PAPatName
	Set Sex       = objAdm.PASex
	Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
	Set AdmDate   = objAdm.PAAdmDate
	Set AdmTime   = objAdm.PAAdmTime
	Set Age       =  objAdm.PAAge
	Set PAAdmDoc  = objAdm.PAAdmDoc
	Set:PAAdmDoc["|" PAAdmDoc=$p(PAAdmDoc,"|",3)
			
	Set DischDate = objAdm.PADischDate
	Set DischTime = objAdm.PADischTime
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set:DischTime'="" DischTime=$zt(DischTime,1)	
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objAdm.PAAdmBedDr){
		Set AdmBedDr=objAdm.PAAdmBedDr.%Id()
		Set AdmBed=objAdm.PAAdmBedDr.BTDesc
	}
	Set objAdmLoc = objAdm.PAAdmLocDr
	Set AdmLocID="", AdmLocDesc=""    //就诊科室
	If $Isobject(objAdmLoc) {
		Set AdmLocID = objAdmLoc.%Id()
		Set AdmLocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc2 = objAdmLoc.BTDesc2
		Set AdmLocDesc = $s(AdmLocDesc2'="":AdmLocDesc2,1:AdmLocDesc)
	}
	Set objAdmWard = objAdm.PAAdmWardDr
	Set AdmWardID="",AdmWardDesc=""   //就诊病区
	If $Isobject(objAdmWard) {
		Set AdmWardID  = objAdmWard.%Id()
		Set AdmWardDesc = objAdmWard.BTDesc
		Set AdmWardDesc2 = objAdmWard.BTDesc2
		Set AdmWardDesc = $s(AdmWardDesc2'="":AdmWardDesc2,1:AdmWardDesc)
		If $IsObject(objAdmWard.BTHospDr){
			Set HospID=objAdmWard.BTHospDr.%Id()
		}
	}
	Set LocID="", LocCode="", LocDesc=""
	If $IsObject(objResult.CCActLocDr){
		Set LocID =  objResult.CCActLocDr.%Id()
		Set LocCode = objResult.CCActLocDr.BTCode
		Set LocDesc = objResult.CCActLocDr.BTDesc
		Set LocDesc2 = objResult.CCActLocDr.BTDesc2
		Set LocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	
	Set Result   = objResult.CCResult
	Set ActDate  = objResult.CCActDate  // 送检日期
	Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set ActTime  = objResult.CCActTime
	Set:ActTime'="" ActTime=$zt(ActTime,1)
	Set RepDate  = objResult.CCRepDate
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set RepTime  = objResult.CCRepTime 
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	Set SCode    = objResult.CCSCode      //子系统代码
	Set Specimen = objResult.CCSpecimen   //原始标本名称
	Set SpeID="",SpeCode="",SpeDesc=""
	Set objSpe=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
	If $IsObject(objSpe) {
		If $IsObject(objSpe.BTMapItemDr){
			Set SpeID=objSpe.BTMapItemDr.%Id()
			Set SpeCode=objSpe.BTMapItemDr.BTSpecCode
			Set SpeDesc=objSpe.BTMapItemDr.BTSpecDesc
		}
	}
	Set Bacteria = objResult.CCBacteria   //原始细菌名称
	Quit:Bacteria=""
	Set BacID="",BacCode="",BacDesc=""
	Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	If $IsObject(objBactMap){
		Quit:objBactMap.BTIsActive'=1  //菌是否有效
		If $IsObject(objBactMap.BTMapItemDr){
			Set BacID=objBactMap.BTMapItemDr.%Id()
			Set BacCode=objBactMap.BTMapItemDr.BTBacCode
			Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
		}
	}
	//一份送检标本，检出多条菌，对应多条LabVisitRepResult和CCResult，但LabVisitReport唯一
	Set LabResID = $p(objResult.CCParams,"=",2)  //检验结果ID
	Set (LabRepID,InfTypeCode,IsByHand) = ""
	Set objLabRes= ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(LabResID)
	If $IsObject(objLabRes) {
		Set LabRepID=objLabRes.LabReportDr.%Id()
		Set InfTypeCode = objLabRes.LabMakeInfType   //感染类型
	    Set IsByHand = objLabRes.LabIsByHand
	}
	Set MRBRepID=""
	Set objInfMBR=##class(DHCHAI.IR.INFMBR).GetObjByRepBact(LabRepID,BacID)
	If $IsObject(objInfMBR) {
		Set MRBRepID=objInfMBR.%Id()
	}
	Set InfTypeID="",InfTypeDesc=""
	Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfTypeCode)
    If $IsObject(objDic) {
	    Set InfTypeID 	= objDic.%Id()
	    Set InfTypeDesc = objDic.BTDesc		
	}	
	//多语言
	Set:InfTypeDesc'="" InfTypeDesc=##class(websys.Translation).Get("dhcma.hai.ir.mrb.ctlreport.csp",InfTypeDesc)
	Set AdmLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmLocDesc,"User.CTLoc")
	Set AdmWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmWardDesc,"User.CTLoc")
	Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
	Set BacDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTBacDesc",BacDesc,"DHCHAI.DP.LabBacteria")
	Set SpeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",SpeDesc,"DHCHAI.DP.LabSpecimen")
	Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")
	Set:Age["岁" Age=$Replace(Age,"岁",##class(websys.Translation).Get("Bill.Com.Age","岁"))
	Set SpeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",SpeDesc,"DHCHAI.DP.LabSpecimen")
	
	Set Data = $lb(xResultID,AdmID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime,LocID,LocCode,LocDesc,ActDate,ActTime,RepDate,RepTime,Specimen,SpeID,SpeCode,SpeDesc,Bacteria,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,MRBID2,MRBCode2,MRBDesc2,PAAdmDoc,MRBActFlag,IsolateInfo,LabResID,LabRepID,MRBRepID,InfTypeID,InfTypeCode,InfTypeDesc,"")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryMRBByEpsodeDrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBByEpsodeDrExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMRBByEpsodeDrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBByEpsodeDrExecute ]
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
/// CreatDate：   2018-09-28
/// Description:  根据就诊号查询耐药菌监控结果
/// Table：       DHCHAI.IR.CCResult
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CtlMRBSrv","QryCheckByDate","11122")
Query QryCheckByDate(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ResultID:%String,AdmID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmBed:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,LocID:%String,LocCode:%String,LocDesc:%String,ActDate:%String,ActTime:%String,RepDate:%String,RepTime:%String,Specimen:%String,SpeID:%String,SpeCode:%String,SpeDesc:%String,Bacteria:%String,BacID:%String,BacCode:%String,BacDesc:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,MRBID2:%String,MRBCode2:%String,MRBDesc2:%String,PAAdmDoc:%String,ActStatusID:%String,ActStatusCode:%String,ActStatusDesc:%String,ActMBRDate:%String,ActMBRTime:%String,ActUserDesc:%String,BactType:%String,CanReson:%String,CheckOpion:%String") [ SqlProc ]
{
}

ClassMethod QryCheckByDateExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
  	
	Set RstList=""
	For xDate=aDateFrom:1:aDateTo {
	    Set xShilID=""
		For {
			Set xShilID=$o(^DHCHAI.IR.INFMRBShieldI("IndexUpdateDate",xDate,xShilID))
			Quit:xShilID=""
			Set objShil=##class(DHCHAI.IR.INFMRBShield).GetObjById(xShilID)
			Continue:'$IsObject(objShil)
			Continue:'$IsObject(objShil.StatusDr)
			Set xResultID = objShil.ResultDr
			// 监控结果已经处理的不在处理
			Continue:($lf(RstList,xResultID)>0)
			Set RstList=RstList_$lb(xResultID)
			
			Do BuildCheckData
		}
	}
	Quit $$$OK
BuildCheckData
	Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
	Quit:'$Isobject(objResult)
	Quit:objResult.CCIsActive'=1
	Set IsAbFlag=objResult.CCIsAbFlag
	Quit:IsAbFlag'=1 //过滤非耐药菌
	
	Set MRBID="",MRBCode="",MRBDesc=""
	If $IsObject(objResult.CCMRBTpDr) {
		
		Set MRBID=objResult.CCMRBTpDr.%Id()
		Set MRBDesc = objResult.CCMRBTpDr.BTDesc
		Set MRBCode = objResult.CCMRBTpDr.BTCode
	}
	Quit:MRBDesc="" //过滤出多重耐药菌
	// 同一种菌满足两种多耐
	Set MRBID2="",MRBCode2="",MRBDesc2=""
	If $IsObject(objResult.CCMRBTp2Dr) {
		
		Set MRBID2=objResult.CCMRBTp2Dr.%Id()
		Set MRBDesc2 = objResult.CCMRBTp2Dr.BTDesc
		Set MRBCode2 = objResult.CCMRBTp2Dr.BTCode
	}
	Set AdmID  = objResult.CCEpisodeDr.%Id()
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(AdmID)
	Quit:'$Isobject(objAdm)
	Set EpisodeID = objAdm.PAEpisodeIDx
	Set PatientID = objAdm.PAPatientIDx
	Set PapmiNo   = objAdm.PAPapmiNo
	Set MrNo      = objAdm.PAMrNo
	Set PatName   = objAdm.PAPatName
	Set Sex       = objAdm.PASex
	Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
	Set AdmDate   = objAdm.PAAdmDate
	Set AdmTime   = objAdm.PAAdmTime
	Set Age       =  objAdm.PAAge
	Set PAAdmDoc  = objAdm.PAAdmDoc
	Set:PAAdmDoc["|" PAAdmDoc=$p(PAAdmDoc,"|",3)
			
	Set DischDate = objAdm.PADischDate
	Set DischTime = objAdm.PADischTime
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set:DischTime'="" DischTime=$zt(DischTime,1)	
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objAdm.PAAdmBedDr){
		Set AdmBedDr=objAdm.PAAdmBedDr.%Id()
		Set AdmBed=objAdm.PAAdmBedDr.BTDesc
	}
	Set objAdmLoc = objAdm.PAAdmLocDr
	Set AdmLocID="", AdmLocDesc=""    //就诊科室
	If $Isobject(objAdmLoc) {
		Set AdmLocID = objAdmLoc.%Id()
		Set AdmLocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc2 = objAdmLoc.BTDesc2
		Set AdmLocDesc = $s(AdmLocDesc2'="":AdmLocDesc2,1:AdmLocDesc)
	}
	Set objAdmWard = objAdm.PAAdmWardDr
	Set AdmWardID="",AdmWardDesc=""   //就诊病区
	If $Isobject(objAdmWard) {
		Set AdmWardID  = objAdmWard.%Id()
		Set AdmWardDesc = objAdmWard.BTDesc
		Set AdmWardDesc2 = objAdmWard.BTDesc2
		Set AdmWardDesc = $s(AdmWardDesc2'="":AdmWardDesc2,1:AdmWardDesc)
		If $IsObject(objAdmWard.BTHospDr){
			Set HospID=objAdmWard.BTHospDr.%Id()			
			Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  	//医院过滤	
		}
	}
	Set LocID="", LocCode="", LocDesc=""
	If $IsObject(objResult.CCActLocDr){
		Set LocID =  objResult.CCActLocDr.%Id()
		Set LocCode = objResult.CCActLocDr.BTCode
		Set LocDesc = objResult.CCActLocDr.BTDesc
		Set LocDesc2 = objResult.CCActLocDr.BTDesc2
		Set LocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	
	Set Result   = objResult.CCResult
	Set ActDate  = objResult.CCActDate  // 送检日期
	Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set ActTime  = objResult.CCActTime
	Set:ActTime'="" ActTime=$zt(ActTime,1)
	Set RepDate  = objResult.CCRepDate
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set RepTime  = objResult.CCRepTime 
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	Set SCode    = objResult.CCSCode      //子系统代码
	Set Specimen = objResult.CCSpecimen   //原始标本名称
	Set SpeID="",SpeCode="",SpeDesc=""
	Set objSpe=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
	If $IsObject(objSpe) {
		If $IsObject(objSpe.BTMapItemDr){
			Set SpeID=objSpe.BTMapItemDr.%Id()
			Set SpeCode=objSpe.BTMapItemDr.BTSpecCode
			Set SpeDesc=objSpe.BTMapItemDr.BTSpecDesc
		}
	}
	Set Bacteria = objResult.CCBacteria   //原始细菌名称
	Quit:Bacteria=""
	Set BacID="",BacCode="",BacDesc=""
	Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	If $IsObject(objBactMap){
		Quit:objBactMap.BTIsActive'=1  //菌是否有效
		If $IsObject(objBactMap.BTMapItemDr){
			Set BacID=objBactMap.BTMapItemDr.%Id()
			Set BacCode=objBactMap.BTMapItemDr.BTBacCode
			Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
		}
	}
	// 多耐处置信息
	Set (ActStatusID,ActStatusCode,ActStatusDesc,ActMBRDate,ActMBRTime,ActUserDesc,BactType,CanReson,CheckOpion)=""
 	Set xShilID=""
	For {
		Set xShilID=$o(^DHCHAI.IR.INFMRBShieldI("IndexResultDr",xResultID,xShilID),-1)
		Quit:xShilID=""
		Set objShil = ##class(DHCHAI.IR.INFMRBShield).GetObjById(xShilID)
		Continue:'$Isobject(objShil)
		Continue:'$Isobject(objShil.StatusDr)
		
		Set:ActStatusID="" ActStatusID=objShil.StatusDr.%Id()
		Set:ActStatusCode="" ActStatusCode=objShil.StatusDr.BTCode
		Set:ActStatusDesc="" ActStatusDesc=objShil.StatusDr.BTDesc
		
		Set:CanReson="" CanReson=objShil.CancelReson
		Set:CheckOpion="" CheckOpion=objShil.NoCheckReson
		If (BactType=""){
			If $IsObject(objShil.BactTypDr){
				Set BacID=objShil.BactTypDr.%Id()
				Set BacCode=objShil.BactTypDr.BTCode
				Set BactType=objShil.BactTypDr.BTDesc
			}
		}
		If (ActMBRDate=""){
			Set ActMBRDate=objShil.UpdateDate
			Set ActMBRTime=objShil.UpdateTime
			Set:ActMBRDate'="" ActMBRDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActMBRDate)
			Set:ActMBRTime'="" ActMBRTime=$zt(ActMBRTime,1)
			If $IsObject(objShil.UpdateUserDr){
				Set ActUserID=objShil.UpdateUserDr.%Id()
				Set ActUserCode=objShil.UpdateUserDr.BTCode
				Set ActUserDesc=objShil.UpdateUserDr.BTDesc
			}
		}
	}
 	
	Set Data = $lb(xResultID,AdmID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime,LocID,LocCode,LocDesc,ActDate,ActTime,RepDate,RepTime,Specimen,SpeID,SpeCode,SpeDesc,Bacteria,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,MRBID2,MRBCode2,MRBDesc2,PAAdmDoc,ActStatusID,ActStatusCode,ActStatusDesc,ActMBRDate,ActMBRTime,ActUserDesc,BactType,CanReson,CheckOpion)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit 1
}

ClassMethod QryCheckByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCheckByDateExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCheckByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCheckByDateExecute ]
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
/// CreatDate：   2019-04-23
/// Description:  根据就诊号+多耐分类ID+多耐报告日期判断是否已做隔离处理
///               如果报告日期大于等于隔离医嘱结束日期，则未做隔离处理，为后面再次检出的多耐
/// Table：       DHCHAI.IR.CRuleMRB,DHCHAI.IR.CRuleMRBOEOrd,DHCHAI.DP.OEOrdItem
/// Input：       aEpisodeDr
///               aMRBID
/// Return：      "":未做隔离处理  不为空:返回隔离医嘱信息
/// w ##class(DHCHAI.IRS.CtlMRBSrv).CheckEpisISOAct("82",1,"2019-04-24")
ClassMethod CheckEpisISOAct(aEpisodeDr As %String, aMRBID As %String, aRepDate As %String) As %String
{
	New (aEpisodeDr,aMRBID,aRepDate,ISOOnlyFlag,ISOOEOrdList,ISOOEARCIMList,%session)
	Set return=""
	Quit:((aEpisodeDr="")||(aMRBID="")) return
	Set:aRepDate["-" aRepDate=$zdh(aRepDate,3)
	//多耐隔离医嘱是否唯一标识
	If (ISOOnlyFlag'=1){ // 隔离医嘱唯一,只要下任何一个隔离医嘱都算隔离处理
		// 获取隔离医嘱列表
		Set ISOOEOrdList="",ISOOEARCIMList=""
		Set xSubID =""
	    For {
			Set xSubID = $o(^DHCHAI.IR.CRuleMRBD(aMRBID,"OEORD",xSubID))
			Quit:xSubID=""
		
			Set ID=aMRBID_"||"_xSubID
			Set OEOrdData=$g(^DHCHAI.IR.CRuleMRBD(aMRBID,"OEORD",xSubID))
			Continue:OEOrdData=""
			Set BTMapItemDesc="",OrdCatDesc="",BTOrdDesc=""
			Set BTOrdID = $lg(OEOrdData,2)
			If (BTOrdID'=""){
				Set IsoOEOrdData = $g(^DHCHAI.DP.OEItmMastMapD(BTOrdID))
				Continue:IsoOEOrdData=""
				Set BTOrdDesc    = $lg(IsoOEOrdData,2)
				Continue:BTOrdDesc=""
				Set OrdCatDesc   = $lg(IsoOEOrdData,11) 
				Set BTMapItemDr  = $lg(IsoOEOrdData,3) 
				If (BTMapItemDr'=""){
					Set MapItemData = $g(^DHCHAI.DP.OEItmMastD(BTMapItemDr))
					If (MapItemData'=""){
						Set BTMapItemCode = $lg(MapItemData,2) 
						Set BTMapItemDesc = $lg(MapItemData,3) 
						Set BTMapCatDr    = $lg(MapItemData,4)
						If (BTMapCatDr'=""){
							Set MapItemCatData = $g(^DHCHAI.DP.OEItmCatD(BTMapCatDr))
							If (MapItemCatData'=""){
								Set BTMapCatCode = $lg(MapItemCatData,2) 
								Set BTMapCatDesc = $lg(MapItemCatData,3) 
							}
						}
					}  
				}
			}
			Continue:(BTMapItemDesc="")  // 未对照的无效
			Set ISOOEOrdList = ISOOEOrdList_$lb(BTOrdDesc)
			// 获取医嘱项ID
			// ^ARCIM(0,"Desc",$$ALPHAUP({ARCIM_Desc}),{ARCIM_Subscript},{ARCIM_Version})
			If ($d(^ARCIM(0,"Desc",BTOrdDesc))){
				Set xItemSub=""
				For {
					Set xItemSub=$o(^ARCIM(0,"Desc",BTOrdDesc,xItemSub))   //update 20220905 处理多院区共库医院存在相同名称的隔离医嘱情况
					Quit:xItemSub=""
					
					Set xItemVer=""
					For {
						Set xItemVer=$o(^ARCIM(0,"Desc",BTOrdDesc,xItemSub,xItemVer))
						Quit:xItemVer=""
					  
						s ARCItemID=xItemSub_"||"_xItemVer
						Set ISOOEARCIMList = ISOOEARCIMList_$lb(ARCItemID)
					}
				}
			}
	    }
	}
    Set ISOInfo=""
    // 通HIS医嘱判断是否下隔离医嘱
    Set PaadmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeDr))
	Quit:PaadmData="" return
	Set EpisodeIDx = $lg(PaadmData,2)
	Set Paadm=$p(EpisodeIDx,"||",2)    //HIS就诊ID
    Set OrdID=$o(^OEORD(0,"Adm",Paadm,""))
	Quit:OrdID="" return
	
	For xxi=1:1:$ll(ISOOEARCIMList){
		Set ARCItemID=$LG(ISOOEARCIMList,xxi)
		Continue:ARCItemID=""
		Set xOrdDate=0
		For {
			Set xOrdDate=$o(^OEORDi(0,"ARCIM",+OrdID,ARCItemID,xOrdDate))
			Quit:xOrdDate=""
			Set xSubID=0
			For {
				Set xSubID=$o(^OEORDi(0,"ARCIM",+OrdID,ARCItemID,xOrdDate,xSubID))
				Quit:xSubID=""
				Set OEItemID=OrdID_"||"_xSubID
				//医嘱类型（长期、临时）
				Set PriorityDr=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",8)
				Set PriorityDesc=$p($g(^OECPR(+PriorityDr)),"^",2)
				//医嘱状态（核实、执行、...）
				Set OrdStatusDr=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",13)
				Set OrdStatusCode=$p($g(^OEC("OSTAT",+OrdStatusDr)),"^",1)
				Set OrdStatusDesc=$p($g(^OEC("OSTAT",+OrdStatusDr)),"^",2)
				//S1长期（滚执行记录）、S2长期（滚医嘱）、N临时
				Set MapPriority=##class(DHCHAI.DP.PhraseMap).GetMapValue("HIS01","OEPriority",PriorityDesc)
				Continue:MapPriority=""
				//执行E、停止D、作废U
				Set MapStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("HIS01","OEOrdStatus",OrdStatusDesc)
				Continue:MapStatus=""
				Set FillerNo="" // ???
				Set IsActive=1
				If MapPriority="S1" {
					Set:MapStatus="U" IsActive=0
				} ElseIf MapPriority="S2" {
					If FillerNo="" {  //主医嘱
						Set:MapStatus="U" IsActive=0
						//Set:MapStatus="D" IsActive=0  //主医嘱停止无效
					} Else {
						//Set IsActive=0 //非主医嘱，全部无效
					}
				} ElseIf MapPriority="N" {
					Set:MapStatus="U" IsActive=0
					//Set:MapStatus="D" IsActive=0  //临时医嘱停止，医嘱无效
				} ElseIf MapPriority="OUT"{		// 出院带药
					Set:MapStatus="U" IsActive=0
					//Set:MapStatus="D" IsActive=0  //出院带药停止，医嘱无效
				}
				Continue:IsActive=0
				Set ArcimCode=$p($g(^ARCIM(+ARCItemID,+$p(ARCItemID,"||",2),1)),"^",1)		//医嘱项代码
				Set ArcimDesc=$p($g(^ARCIM(+ARCItemID,+$p(ARCItemID,"||",2),1)),"^",2)		//医嘱项名称
				//多语言处理
				Set ArcimDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("ARCIMDesc",ArcimDesc,"User.ARCItmMast")
				Set SttDate=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",9) 			//医嘱开始日期（OEORI_SttDate）
				Set SttTime=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",10)			//医嘱开始时间（OEORI_SttTime）
				//查找滚医嘱方式下的主医嘱
				Set OID=$p($g(^OEORD(OrdID,"I",xSubID,9)),"^",12)
				Set OID=$p(OID,"!!",1)
				If (OID'="") {
					Set OrdID2=$p(OID,"||",1)
					Set SubID2=$p(OID,"||",2)
					Set SttDate=$p($g(^OEORD(OrdID2,"I",SubID2,3)),"^",7)       //医嘱开始日期
					Set SttTime=$p($g(^OEORD(OrdID2,"I",SubID2,3)),"^",15)      //医嘱开始时间
				}
				Set tmpSttDate = SttDate
				Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
				Set:SttTime'="" SttTime=$zt(SttTime,2)
				Set EndDate=$p($g(^OEORD(OrdID,"I",xSubID,3)),"^",34)             //停医嘱日期
				Set EndTime=$p($g(^OEORD(OrdID,"I",xSubID,2)),"^",15)		      //停医嘱时间
				// 如果报告日期大于隔离医嘱结束日期，则未做隔离处理，为后面再次检出的多耐
				If (MapPriority="N"){  // 临时医嘱，第二天图标消失  bug:1278040
					Set EndDate=tmpSttDate+1
				}
				Set tmpEndDate=EndDate
				Set:tmpEndDate="" tmpEndDate=+$h
				Continue:aRepDate>tmpEndDate
				Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
				Set:EndTime'="" EndTime=$zt(EndTime,2)
				
				Set ISOInfo=ISOInfo_"^"_ArcimDesc_"|"_SttDate_"~"_EndDate
			}
		}
	}
	
    /*  通过数据池判断是否下隔离医嘱
    Set ISOInfo=""
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeDr,xSCode))
		Quit:xSCode=""
		For xi=1:1:$ll(ISOOEOrdList){
			Set OEDesc=$LG(ISOOEOrdList,xi)
			Continue:OEDesc=""
			Set xxDate=""
			For {
				Set xxDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeDr,xSCode,OEDesc,xxDate))
				Quit:xxDate=""
				Set xOEID=0
				For {
					Set xOEID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeDr,xSCode,OEDesc,xxDate,xOEID))
					Quit:xOEID=""
				
					Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xOEID)
					Continue:'$IsObject(objOrdItem)
					Continue:objOrdItem.OEIsActive=0	// 无效医嘱
					Set SCode   = objOrdItem.OESCode
					Set OrdType = objOrdItem.OEOrdType
					Continue:OrdType="R" //过滤掉药品医嘱
					Set OrdDesc = objOrdItem.OEOrdDesc
					
					Set Priority= objOrdItem.OEPriority
					Set OrdDate = objOrdItem.OEOrdDate
					Set:OrdDate'="" OrdDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OrdDate)
					Set OrdTime = objOrdItem.OEOrdTime
					Set:OrdTime'="" OrdTime=$zt(OrdTime,2)
					Set SttDate = objOrdItem.OESttDate
					Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
					Set SttTime = objOrdItem.OESttTime
					Set:SttTime'="" SttTime=$zt(SttTime,2)
					Set EndDate	= objOrdItem.OEXDate
					// 如果报告日期大于等于隔离医嘱结束日期，则未做隔离处理，为后面再次检出的多耐
					Set tmpEndDate=EndDate
					Set:tmpEndDate="" tmpEndDate=+$h
					Continue:aRepDate>tmpEndDate
					Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
					Set EndTime	= objOrdItem.OEXTime
					Set:EndTime'="" EndTime=$zt(EndTime,2)
					If $IsObject(objOrdItem.OEOrdLocDr) {
						Set OrdLocDesc=objOrdItem.OEOrdLocDr.BTDesc
					} Else {
						Set OrdLocDesc=objOrdItem.OEOrdLoc  //ID|Code|Desc
						Set:$p(OrdLocDesc,"|",3)'="" OrdLocDesc=$p(OrdLocDesc,"|",3)
					}
					Set OrdDocDesc=objOrdItem.OEDoctor  //ID|Code|Desc
					Set:$p(OrdDocDesc,"|",3)'="" OrdDocDesc=$p(OrdDocDesc,"|",3)
					Set ISOInfo=ISOInfo_"^"_OrdDesc_"|"_SttDate_"~"_EndDate
				}
			}
		}
	}
	*/
	Set:ISOInfo'="" ISOInfo=$e(ISOInfo,2,$l(ISOInfo))
	Set return=ISOInfo
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2019-04-28
/// Description:  根据关键词+预案类型获取消息内容
/// Table：       DHCHAI.IR.CCResult
/// Input：       aPlanType : 预案类型名称
/// Input：       aKeys : 关键词
/// Return:       %String
/// w ##class("DHCHAI.IRS.CtlMRBSrv").GetContentByKeys("多重耐药菌感染预防","多重耐药菌")
ClassMethod GetContentByKeys(aPlanType As %String, aKeys As %String) As %String
{
	New (aPlanType,aKeys)
	Set return=""
	Quit:(aPlanType="")||(aKeys="") return
	Set PlanTypeDr=##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("PlanType",aPlanType,"1")
	Quit:(PlanTypeDr="") return
	Set MessageInfo=""
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.IR.PlanManageI("IndexPlanTypeDr",PlanTypeDr,xID))
		Quit:xID=""
		Set obj=##class(DHCHAI.IR.PlanManage).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.IRIsActive'=1
		Set IRKeys = obj.IRKeys
		Continue:IRKeys'[aKeys
		Set IRContent = obj.IRContent
		Set MessageInfo = MessageInfo_"。"_IRContent
	}
	Set:MessageInfo'="" MessageInfo=$e(MessageInfo,2,$l(MessageInfo))
	Set return = MessageInfo
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2019-04-23
/// Description:  结合多耐唯一标示获取隔离医嘱
/// Table：       DHCHAI.DP.OEItmMastMap
/// Input：       
/// Return:       隔离医嘱
/// w ##class("DHCHAI.IRS.CtlMRBSrv").GetISOOEOrd()
ClassMethod GetISOOEOrd() As %String
{
	Set return=""
	Set ISOOEOrdDesc=""
	//多耐隔离医嘱是否唯一标识
	Set ISOOnlyFlag = ##class(DHCHAI.BT.Config).GetValByCode("IsolateOEOrdOnly","")	
	If (ISOOnlyFlag'=1){ // 隔离医嘱唯一,只要下任何一个隔离医嘱都算隔离处理
		Set xBTSCode=""
		For {
			Set xBTSCode=$o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xBTSCode))
			Quit:xBTSCode=""
			
			Set xOrdDesc=""
			For {
				Set xOrdDesc=$o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xBTSCode,xOrdDesc))
				Quit:xOrdDesc=""
			
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xBTSCode,xOrdDesc,xID))
					Quit:xID=""
					Set MastMapData=$g(^DHCHAI.DP.OEItmMastMapD(xID))
					Continue:MastMapData=""
					Set BTOrdDesc   = $lg(MastMapData,2)
					Set OrdCatDesc  = $lg(MastMapData,11)
					Set BTMapItemDr = $lg(MastMapData,3)
					Continue:BTMapItemDr="" 
					Set ItmMastData = $g(^DHCHAI.DP.OEItmMastD(BTMapItemDr))
					Continue:ItmMastData=""
					Set BTMapItemCode = $lg(ItmMastData,2)
					Set BTMapItemDesc = $lg(ItmMastData,3)
					Set BTMapCatDr    = $lg(ItmMastData,4) 
					Continue:BTMapCatDr="" 
					Set ItmCatData = $g(^DHCHAI.DP.OEItmCatD(BTMapCatDr))
					Continue:ItmCatData=""
					Set BTMapCatCode = $lg(ItmCatData,2) 
					Set BTMapCatDesc = $lg(ItmCatData,3) 
					Set BTTypeDr     = $lg(ItmCatData,4) 
					Continue:BTTypeDr="" 
					Set ItmCatTypeData = $g(^DHCHAI.DP.OEItmTypeD(BTTypeDr))
					Continue:ItmCatTypeData=""
					Set OETypeCode=$lg(ItmCatTypeData,2) 
					/*
					Set objMastMap=##class(DHCHAI.DP.OEItmMastMap).GetObjById(xID)
		 			Continue:'$IsObject(objMastMap)
						
					Set BTOrdDesc=objMastMap.BTOrdDesc
					Set OrdCatDesc=objMastMap.BTOrdCatDesc
					Set BTMapItemDr="",BTMapItemCode="",BTMapItemDesc=""
					Set BTMapCatDr="",BTMapCatCode="",BTMapCatDesc="",OETypeCode=""
					If $IsObject(objMastMap.BTMapItemDr) {
						Set BTMapItemDr=objMastMap.BTMapItemDr.%Id()
						Set BTMapItemCode=objMastMap.BTMapItemDr.BTCode
						Set BTMapItemDesc=objMastMap.BTMapItemDr.BTDesc					
						Set objMast=##class(DHCHAI.DP.OEItmMast).GetObjById(BTMapItemDr)
						If $IsObject(objMast.BTCatDr) {
							Set BTMapCatDr=objMast.BTCatDr.%Id()
							Set BTMapCatCode=objMast.BTCatDr.BTCode
							Set BTMapCatDesc=objMast.BTCatDr.BTDesc
							If $IsObject(objMast.BTCatDr.BTTypeDr){
								Set OETypeCode=objMast.BTCatDr.BTTypeDr.BTCode
							}
						}
					}*/
					Continue:(OETypeCode'="ISO") // 过滤非对照的隔离医嘱
					Set ISOOEOrdDesc = BTOrdDesc
				}
			}
		}
	}
	Quit ISOOEOrdDesc
}

/// Creator：     zhoubo
/// CreatDate：   2022-09-06
/// Description:  根据就诊号获取最近一次停隔离医嘱的时间，以及最近一次开隔离医嘱时间
/// Input：       aEpisodeDr
/// Return：      返回隔离医嘱信息
/// w ##class(DHCHAI.IRS.CtlMRBSrv).GetEpisStopISODate("612")
ClassMethod GetEpisStopISODate(aEpisodeDr As %String) As %String
{
	New (aEpisodeDr)
	Set return=""
	Quit:(aEpisodeDr="") return
	Set ISOOEARCIMList=""
	Set xBTSCode=""
	For {
		Set xBTSCode=$o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xBTSCode))
		Quit:xBTSCode=""
		
		Set xOrdDesc=""
		For {
			Set xOrdDesc=$o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xBTSCode,xOrdDesc))
			Quit:xOrdDesc=""
		
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xBTSCode,xOrdDesc,xID))
				Quit:xID=""
				Set MastMapData=$g(^DHCHAI.DP.OEItmMastMapD(xID))
				Continue:MastMapData=""
				Set BTOrdDesc   = $lg(MastMapData,2)
				Set OrdCatDesc  = $lg(MastMapData,11)
				Set BTMapItemDr = $lg(MastMapData,3)
				Continue:BTMapItemDr="" 
				Set ItmMastData = $g(^DHCHAI.DP.OEItmMastD(BTMapItemDr))
				Continue:ItmMastData=""
				Set BTMapItemCode = $lg(ItmMastData,2)
				Set BTMapItemDesc = $lg(ItmMastData,3)
				Set BTMapCatDr    = $lg(ItmMastData,4) 
				Continue:BTMapCatDr="" 
				Set ItmCatData = $g(^DHCHAI.DP.OEItmCatD(BTMapCatDr))
				Continue:ItmCatData=""
				Set BTMapCatCode = $lg(ItmCatData,2) 
				Set BTMapCatDesc = $lg(ItmCatData,3) 
				Set BTTypeDr     = $lg(ItmCatData,4) 
				Continue:BTTypeDr="" 
				Set ItmCatTypeData = $g(^DHCHAI.DP.OEItmTypeD(BTTypeDr))
				Continue:ItmCatTypeData=""
				Set OETypeCode=$lg(ItmCatTypeData,2) 
				/*
				Set objMastMap=##class(DHCHAI.DP.OEItmMastMap).GetObjById(xID)
	 			Continue:'$IsObject(objMastMap)
					
				Set BTOrdDesc=objMastMap.BTOrdDesc
				Set OrdCatDesc=objMastMap.BTOrdCatDesc
				Set BTMapItemDr="",BTMapItemCode="",BTMapItemDesc=""
				Set BTMapCatDr="",BTMapCatCode="",BTMapCatDesc="",OETypeCode=""
				If $IsObject(objMastMap.BTMapItemDr) {
					Set BTMapItemDr=objMastMap.BTMapItemDr.%Id()
					Set BTMapItemCode=objMastMap.BTMapItemDr.BTCode
					Set BTMapItemDesc=objMastMap.BTMapItemDr.BTDesc					
					Set objMast=##class(DHCHAI.DP.OEItmMast).GetObjById(BTMapItemDr)
					If $IsObject(objMast.BTCatDr) {
						Set BTMapCatDr=objMast.BTCatDr.%Id()
						Set BTMapCatCode=objMast.BTCatDr.BTCode
						Set BTMapCatDesc=objMast.BTCatDr.BTDesc
						If $IsObject(objMast.BTCatDr.BTTypeDr){
							Set OETypeCode=objMast.BTCatDr.BTTypeDr.BTCode
						}
					}
				}*/
				Continue:(OETypeCode'="ISO") // 过滤非对照的隔离医嘱
				// 获取医嘱项ID
				// ^ARCIM(0,"Desc",$$ALPHAUP({ARCIM_Desc}),{ARCIM_Subscript},{ARCIM_Version})
				If ($d(^ARCIM(0,"Desc",BTOrdDesc))){
					Set xItemSub=""
					For {
						Set xItemSub=$o(^ARCIM(0,"Desc",BTOrdDesc,xItemSub))   //update 20220905 处理多院区共库医院存在相同名称的隔离医嘱情况
						Quit:xItemSub=""
						
						Set xItemVer=""
						For {
							Set xItemVer=$o(^ARCIM(0,"Desc",BTOrdDesc,xItemSub,xItemVer))
							Quit:xItemVer=""
						  
							s ARCItemID=xItemSub_"||"_xItemVer
							Set ISOOEARCIMList = ISOOEARCIMList_$lb(ARCItemID)
						}
					}
				}
			}
		}
	}
	
    Set ISOEndInfo="",ISOStartInfo=""
    // 通HIS医嘱判断是否下隔离医嘱
    Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objPaadm) return
	Set EpisodeIDx = objPaadm.PAEpisodeIDx
	Set Paadm=$p(EpisodeIDx,"||",2)    //HIS就诊ID
    Set OrdID=$o(^OEORD(0,"Adm",Paadm,""))
	Quit:OrdID="" return
	For xxi=1:1:$ll(ISOOEARCIMList){
		Set ARCItemID=$LG(ISOOEARCIMList,xxi)
		Continue:ARCItemID=""
		Set xOrdDate=0
		For {
			Set xOrdDate=$o(^OEORDi(0,"ARCIM",+OrdID,ARCItemID,xOrdDate))
			Quit:xOrdDate=""
			Set xSubID=0
			For {
				Set xSubID=$o(^OEORDi(0,"ARCIM",+OrdID,ARCItemID,xOrdDate,xSubID))
				Quit:xSubID=""
				Set OEItemID=OrdID_"||"_xSubID
				//医嘱类型（长期、临时）
				Set PriorityDr=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",8)
				Set PriorityDesc=$p($g(^OECPR(+PriorityDr)),"^",2)
				//医嘱状态（核实、执行、...）
				Set OrdStatusDr=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",13)
				Set OrdStatusCode=$p($g(^OEC("OSTAT",+OrdStatusDr)),"^",1)
				Set OrdStatusDesc=$p($g(^OEC("OSTAT",+OrdStatusDr)),"^",2)
				//S1长期（滚执行记录）、S2长期（滚医嘱）、N临时
				Set MapPriority=##class(DHCHAI.DP.PhraseMap).GetMapValue("HIS01","OEPriority",PriorityDesc)
				Continue:MapPriority=""
				//执行E、停止D、作废U
				Set MapStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("HIS01","OEOrdStatus",OrdStatusDesc)
				Continue:MapStatus=""
				Set FillerNo="" // ???
				Set IsActive=1
				If MapPriority="S1" {
					Set:MapStatus="U" IsActive=0
				} ElseIf MapPriority="S2" {
					If FillerNo="" {  //主医嘱
						Set:MapStatus="U" IsActive=0
						//Set:MapStatus="D" IsActive=0  //主医嘱停止无效
					} Else {
						//Set IsActive=0 //非主医嘱，全部无效
					}
				} ElseIf MapPriority="N" {
					Set:MapStatus="U" IsActive=0
					//Set:MapStatus="D" IsActive=0  //临时医嘱停止，医嘱无效
				} ElseIf MapPriority="OUT"{		// 出院带药
					Set:MapStatus="U" IsActive=0
					//Set:MapStatus="D" IsActive=0  //出院带药停止，医嘱无效
				}
				Continue:IsActive=0
				Set ArcimCode=$p($g(^ARCIM(+ARCItemID,+$p(ARCItemID,"||",2),1)),"^",1)		//医嘱项代码
				Set ArcimDesc=$p($g(^ARCIM(+ARCItemID,+$p(ARCItemID,"||",2),1)),"^",2)		//医嘱项名称
				
				Set SttDate=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",9) 			//医嘱开始日期（OEORI_SttDate）
				Set SttTime=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",10)			//医嘱开始时间（OEORI_SttTime）
				//查找滚医嘱方式下的主医嘱
				Set OID=$p($g(^OEORD(OrdID,"I",xSubID,9)),"^",12)
				Set OID=$p(OID,"!!",1)
				If (OID'="") {
					Set OrdID2=$p(OID,"||",1)
					Set SubID2=$p(OID,"||",2)
					Set SttDate=$p($g(^OEORD(OrdID2,"I",SubID2,3)),"^",7)       //医嘱开始日期
					Set SttTime=$p($g(^OEORD(OrdID2,"I",SubID2,3)),"^",15)      //医嘱开始时间
				}
				Set tmpSttDate = SttDate
				Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
				Set:SttTime'="" SttTime=$zt(SttTime,2)
				Set EndDate=$p($g(^OEORD(OrdID,"I",xSubID,3)),"^",34)             //停医嘱日期
				Set EndTime=$p($g(^OEORD(OrdID,"I",xSubID,2)),"^",15)		      //停医嘱时间
				Set ISOStartInfo=OEItemID_"^"_ArcimDesc_"^"_SttDate_"^"_SttTime
				Continue:EndDate=""
				If (MapPriority="N"){  // 临时医嘱，第二天图标消失  bug:1278040
					//Set EndDate=tmpSttDate+1
				}
				Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
				Set:EndTime'="" EndTime=$zt(EndTime,2)
				
				Set ISOEndInfo=OEItemID_"^"_ArcimDesc_"^"_SttDate_"^"_SttTime_"^"_EndDate_"^"_EndTime
			}
		}
	}
	Set return=ISOEndInfo_"#"_ISOStartInfo
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2019-04-23
/// Description:  判断患者是否检出多重耐药菌，医生站图标调用
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeID：HIS就诊ID
/// Return:       "":不需要提示  不等于空:该患者有检出多重耐药菌 
/// w ##class("DHCHAI.IRS.CtlMRBSrv").CheckMrbByEpisodeID("291")
ClassMethod CheckMrbByEpisodeID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	Set EpisodeDr = ##class(DHCHAI.CUS.ToClinReport).GetEpisodeDr(aEpisodeID,"0")
	Quit:EpisodeDr="" return
	
	// 获取隔离医嘱列表,医嘱项ID列表
	Set ISOOEOrdList="",ISOOEARCIMList=""
	//多耐隔离医嘱是否唯一标识
	Set ISOOnlyFlag = ##class(DHCHAI.BT.Config).GetValByCode("IsolateOEOrdOnly","")	
	If (ISOOnlyFlag=1){ // 隔离医嘱唯一,只要下任何一个隔离医嘱都算隔离处理
		Set xItemDr=""
		For {
			Set xItemDr=$o(^DHCHAI.DP.OEItmMastMapI("IndexMapItemDr",xItemDr))
			Quit:xItemDr=""
		
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.DP.OEItmMastMapI("IndexMapItemDr",xItemDr,xID))
				Quit:xID=""
				Set MastMapData=$g(^DHCHAI.DP.OEItmMastMapD(xID))
				Continue:MastMapData=""
				Set BTOrdDesc   = $lg(MastMapData,2)
				Set OrdCatDesc  = $lg(MastMapData,11)
				Set BTMapItemDr = $lg(MastMapData,3)
				Continue:BTMapItemDr="" 
				Set ItmMastData = $g(^DHCHAI.DP.OEItmMastD(BTMapItemDr))
				Continue:ItmMastData=""
				Set BTMapItemCode = $lg(ItmMastData,2)
				Set BTMapItemDesc = $lg(ItmMastData,3)
				Set BTMapCatDr    = $lg(ItmMastData,4) 
				Continue:BTMapCatDr="" 
				Set ItmCatData = $g(^DHCHAI.DP.OEItmCatD(BTMapCatDr))
				Continue:ItmCatData=""
				Set BTMapCatCode = $lg(ItmCatData,2) 
				Set BTMapCatDesc = $lg(ItmCatData,3) 
				Set BTTypeDr     = $lg(ItmCatData,4) 
				Continue:BTTypeDr="" 
				Set ItmCatTypeData = $g(^DHCHAI.DP.OEItmTypeD(BTTypeDr))
				Continue:ItmCatTypeData=""
				Set OETypeCode=$lg(ItmCatTypeData,2)
				
				Continue:(OETypeCode'="ISO") // 过滤非对照的隔离医嘱
				Set ISOOEOrdList = ISOOEOrdList_$lb(BTOrdDesc)
				// 获取医嘱项ID
				// ^ARCIM(0,"Desc",$$ALPHAUP({ARCIM_Desc}),{ARCIM_Subscript},{ARCIM_Version})
				If ($d(^ARCIM(0,"Desc",BTOrdDesc))){
					Set xItemSub=""
					For {
						Set xItemSub=$o(^ARCIM(0,"Desc",BTOrdDesc,xItemSub))   //update 20220905 处理多院区共库医院存在相同名称的隔离医嘱情况
						Quit:xItemSub=""
						
						Set xItemVer=""
						For {
							Set xItemVer=$o(^ARCIM(0,"Desc",BTOrdDesc,xItemSub,xItemVer))
							Quit:xItemVer=""
						  
							s ARCItemID=xItemSub_"||"_xItemVer
							Set ISOOEARCIMList = ISOOEARCIMList_$lb(ARCItemID)
						}
					}
				}
			}
		}
	}
	Set MRBInfo=""
	Set xItem=""
	For {
		Set xItem=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",EpisodeDr,xItem))
		Quit:xItem=""
		Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItem)
		Continue:'$IsObject(objItem)
		Set ItemCode=objItem.CCCode
		Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")
		Set xDate=""
		For {
			Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",EpisodeDr,xItem,xDate))
			Quit:xDate=""
			Set xResultID=""
			For {
				Set xResultID=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",EpisodeDr,xItem,xDate,xResultID))
				Quit:xResultID=""
				
				Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
				Continue:'$Isobject(objResult)
				Continue:objResult.CCIsActive'=1
				Set IsAbFlag=objResult.CCIsAbFlag
				Continue:IsAbFlag'=1 //过滤非耐药菌
	
				Set MRBID="",MRBCode="",MRBDesc=""
				If $IsObject(objResult.CCMRBTpDr) {
					Set MRBID=objResult.CCMRBTpDr.%Id()
					Set MRBDesc = objResult.CCMRBTpDr.BTDesc
					Set MRBCode = objResult.CCMRBTpDr.BTCode
				}
				Continue:MRBDesc="" //过滤出多重耐药菌
				Set AdmID  = objResult.CCEpisodeDr.%Id()
				Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(AdmID)
				Continue:'$Isobject(objAdm)
				Set Bacteria = objResult.CCBacteria   //原始细菌名称
				Continue:Bacteria=""
				//多重耐药菌报告日期后的隔离医嘱名称和开始日期
				Set CCRepDate = objResult.CCRepDate
				Continue:CCRepDate=""
				Set IsolateInfo=..CheckEpisISOAct(EpisodeDr,MRBID,CCRepDate)
				If (IsolateInfo=""){  // 未做隔离医嘱处理
					If (MRBInfo=""){
						Set MRBInfo="该患者检出多重耐药菌:"_MRBDesc_",请尽快开立隔离医嘱并做好隔离防护措施。"
					}Else{
						Set MRBInfo=MRBInfo_"^"_MRBDesc
					}
				}
			}
		}
	}
	// 增加检验外部录入的多耐结果
	Set xOutID=""
	For {
		Set xOutID=$o(^DHCHAI.IR.OutLabReportI("IndexEpisodeDr",EpisodeDr,xOutID))
		Quit:xOutID=""
		
		Set objOut = ##class(DHCHAI.IR.OutLabReport).GetObjById(xOutID)
		Continue:'$Isobject(objOut)
		Set LabIsActive = +objOut.LabIsActive
		Continue:(LabIsActive'=1)
		Set IsAbFlag=1   //异常标志
		
		Set ActDate  = objOut.SubmissDate   //送检日期
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime  = "1"
		Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set RepDate  = objOut.LabAuthDate   //报告日期
		Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		Set RepTime  = "1"
		Set:RepTime'="" RepTime=$zt(RepTime,1)
		//细菌1
		Set BacID="",BacCode="",BacDesc=""
		Set ObjBacteria = objOut.BacteriaDr
		If ($IsObject(ObjBacteria)){
			Set BacID   = ObjBacteria.%Id()
			Set BacCode = ObjBacteria.BTBacCode
			Set BacDesc = ObjBacteria.BTBacDesc
		}
		For xIndi=1:1:2{
			If (xIndi=1){
				//输出第一种菌信息
				If (BacID'=""){
					Set Bacteria = ""
					Set xBactMapID = ""
					For {
						Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
						Quit:xBactMapID="" 
							
						Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
						Continue:'$Isobject(objMap)
						Set Bacteria = objMap.BTBacteria
					}
					Continue:Bacteria=""
					Set Result = Bacteria
					
					Set MRBID="",MRBCode="",MRBDesc=""
					Set ObjRuleMRB = objOut.RuleMRBDr
					If ($IsObject(ObjRuleMRB)){
						Set MRBID   = ObjRuleMRB.%Id()
						Set MRBDesc = ObjRuleMRB.BTDesc
						Set MRBCode = ObjRuleMRB.BTCode
					}
					Continue:MRBDesc="" //过滤出多重耐药菌
					//多重耐药菌报告日期后的隔离医嘱名称和开始日期
					Continue:RepDate=""
					Set IsolateInfo=..CheckEpisISOAct(EpisodeDr,MRBID,RepDate)
					If (IsolateInfo=""){  // 未做隔离医嘱处理
						If (MRBInfo=""){
							Set MRBInfo="该患者检出多重耐药菌:"_MRBDesc_",请尽快开立隔离医嘱并做好隔离防护措施。"
						}Else{
							Set MRBInfo=MRBInfo_"^"_MRBDesc
						}
					}
				}
			}Else{
				// 输出第二种菌相关信息
				Set BacID="",BacCode="",BacDesc=""
				Set ObjBacteria = objOut.BacteriaDr2
				If ($IsObject(ObjBacteria)){
					Set BacID   = ObjBacteria.%Id()
					Set BacCode = ObjBacteria.BTBacCode
					Set BacDesc = ObjBacteria.BTBacDesc
				}
				Continue:BacID=""
				Set Bacteria = ""
				Set xBactMapID = ""
				For {
					Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
					Quit:xBactMapID="" 
						
					Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
					Continue:'$Isobject(objMap)
					Set Bacteria = objMap.BTBacteria
				}
				Continue:Bacteria=""
				
				Set MRBID="",MRBCode="",MRBDesc=""
				Set ObjRuleMRB = objOut.RuleMRBDr2
				If ($IsObject(ObjRuleMRB)){
					Set MRBID   = ObjRuleMRB.%Id()
					Set MRBDesc = ObjRuleMRB.BTDesc
					Set MRBCode = ObjRuleMRB.BTCode
				}
				Continue:MRBDesc="" //过滤出多重耐药菌
				//多重耐药菌报告日期后的隔离医嘱名称和开始日期
				Continue:RepDate=""
				Set IsolateInfo=..CheckEpisISOAct(EpisodeDr,MRBID,RepDate)
				If (IsolateInfo=""){  // 未做隔离医嘱处理
					If (MRBInfo=""){
						Set MRBInfo="该患者检出多重耐药菌:"_MRBDesc_",请尽快开立隔离医嘱并做好隔离防护措施。"
					}Else{
						Set MRBInfo=MRBInfo_"^"_MRBDesc
					}
				}
			}
		}
	}
	Set:MRBInfo'="" return=MRBInfo
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2019-04-23
/// Description:  判断患者检出多耐下了隔离医嘱，医生站图标调用
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeID：HIS就诊ID
/// Return:       "":不需要提示  不等于空:该患者已做隔离处理 
/// w ##class("DHCHAI.IRS.CtlMRBSrv").CheckMrbByEpisodeID1("291")
ClassMethod CheckMrbByEpisodeID1(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	Set EpisodeDr = ##class(DHCHAI.CUS.ToClinReport).GetEpisodeDr(aEpisodeID,"0")
	Quit:EpisodeDr="" return
	Set IsCheckMRB=0   // 是否有检出多耐菌
	// 获取隔离医嘱列表,医嘱项ID列表
	Set ISOOEOrdList="",ISOOEARCIMList=""
	//多耐隔离医嘱是否唯一标识
	Set ISOOnlyFlag = ##class(DHCHAI.BT.Config).GetValByCode("IsolateOEOrdOnly","")	
	If (ISOOnlyFlag=1){ // 隔离医嘱唯一,只要下任何一个隔离医嘱都算隔离处理 
		Set xItemDr=""
		For {
			Set xItemDr=$o(^DHCHAI.DP.OEItmMastMapI("IndexMapItemDr",xItemDr))
			Quit:xItemDr=""
		
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.DP.OEItmMastMapI("IndexMapItemDr",xItemDr,xID))
				Quit:xID=""
				Set MastMapData=$g(^DHCHAI.DP.OEItmMastMapD(xID))
				Continue:MastMapData=""
				Set BTOrdDesc   = $lg(MastMapData,2)
				Set OrdCatDesc  = $lg(MastMapData,11)
				Set BTMapItemDr = $lg(MastMapData,3)
				Continue:BTMapItemDr="" 
				Set ItmMastData = $g(^DHCHAI.DP.OEItmMastD(BTMapItemDr))
				Continue:ItmMastData=""
				Set BTMapItemCode = $lg(ItmMastData,2)
				Set BTMapItemDesc = $lg(ItmMastData,3)
				Set BTMapCatDr    = $lg(ItmMastData,4) 
				Continue:BTMapCatDr="" 
				Set ItmCatData = $g(^DHCHAI.DP.OEItmCatD(BTMapCatDr))
				Continue:ItmCatData=""
				Set BTMapCatCode = $lg(ItmCatData,2) 
				Set BTMapCatDesc = $lg(ItmCatData,3) 
				Set BTTypeDr     = $lg(ItmCatData,4) 
				Continue:BTTypeDr="" 
				Set ItmCatTypeData = $g(^DHCHAI.DP.OEItmTypeD(BTTypeDr))
				Continue:ItmCatTypeData=""
				Set OETypeCode=$lg(ItmCatTypeData,2)
				
				Continue:(OETypeCode'="ISO") // 过滤非对照的隔离医嘱
				Set ISOOEOrdList = ISOOEOrdList_$lb(BTOrdDesc)
				// 获取医嘱项ID
				// ^ARCIM(0,"Desc",$$ALPHAUP({ARCIM_Desc}),{ARCIM_Subscript},{ARCIM_Version})
				If ($d(^ARCIM(0,"Desc",BTOrdDesc))){
					Set xItemSub=""
					For {
						Set xItemSub=$o(^ARCIM(0,"Desc",BTOrdDesc,xItemSub))   //update 20220905 处理多院区共库医院存在相同名称的隔离医嘱情况
						Quit:xItemSub=""
						
						Set xItemVer=""
						For {
							Set xItemVer=$o(^ARCIM(0,"Desc",BTOrdDesc,xItemSub,xItemVer))
							Quit:xItemVer=""
						  
							s ARCItemID=xItemSub_"||"_xItemVer
							Set ISOOEARCIMList = ISOOEARCIMList_$lb(ARCItemID)
						}
					}
				}
			}
		}
	}
	
	Set FlgISOOrdDesc=""
	Set xItem=""
	For {
		Set xItem=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",EpisodeDr,xItem))
		Quit:xItem=""
		Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItem)
		Continue:'$IsObject(objItem)
		Set ItemCode=objItem.CCCode
		Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")
		Set xDate=""
		For {
			Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",EpisodeDr,xItem,xDate))
			Quit:xDate=""
			Set xResultID=""
			For {
				Set xResultID=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",EpisodeDr,xItem,xDate,xResultID))
				Quit:xResultID=""
				
				Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
				Continue:'$Isobject(objResult)
				Continue:objResult.CCIsActive'=1
				Set IsAbFlag=objResult.CCIsAbFlag
				Continue:IsAbFlag'=1 //过滤非耐药菌
	
				Set MRBID="",MRBCode="",MRBDesc=""
				If $IsObject(objResult.CCMRBTpDr) {
					Set MRBID=objResult.CCMRBTpDr.%Id()
					Set MRBDesc = objResult.CCMRBTpDr.BTDesc
					Set MRBCode = objResult.CCMRBTpDr.BTCode
				}
				Continue:MRBDesc="" //过滤出多重耐药菌
				
				Set AdmID  = objResult.CCEpisodeDr.%Id()
				Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(AdmID)
				Continue:'$Isobject(objAdm)
				Set Bacteria = objResult.CCBacteria   //原始细菌名称
				Continue:Bacteria=""
				Set IsCheckMRB=1
				//多重耐药菌报告日期后的隔离医嘱名称和开始日期
				Set CCRepDate = objResult.CCRepDate
				Continue:CCRepDate=""
				
				Set IsolateInfo=..CheckEpisISOAct(EpisodeDr,MRBID,CCRepDate)
				If (IsolateInfo'=""){  // 已做隔离医嘱处理
					Set tmpFlgISOOrdDesc=$p(IsolateInfo,"^",$l(IsolateInfo,"^"))
					Set ISOEndDate = $p(tmpFlgISOOrdDesc,"~",2)
					Set:ISOEndDate["-" ISOEndDate=$zdh(ISOEndDate,3)
					Continue:(ISOEndDate'="")&&(ISOEndDate<=(+$h)) // 隔离结束不需要提示
					Continue:ISOEndDate'="" // 隔离结束不需要提示
					Set FlgISOOrdDesc=tmpFlgISOOrdDesc
				}
			}
		}
	}
	// 增加检验外部录入的多耐结果
	Set xOutID=""
	For {
		Set xOutID=$o(^DHCHAI.IR.OutLabReportI("IndexEpisodeDr",EpisodeDr,xOutID))
		Quit:xOutID=""
		
		Set objOut = ##class(DHCHAI.IR.OutLabReport).GetObjById(xOutID)
		Continue:'$Isobject(objOut)
		Set LabIsActive = +objOut.LabIsActive
		Continue:(LabIsActive'=1)
		Set IsAbFlag=1   //异常标志
		
		Set ActDate  = objOut.SubmissDate   //送检日期
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime  = "1"
		Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set RepDate  = objOut.LabAuthDate   //报告日期
		Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		Set RepTime  = "1"
		Set:RepTime'="" RepTime=$zt(RepTime,1)
		//细菌1
		Set BacID="",BacCode="",BacDesc=""
		Set ObjBacteria = objOut.BacteriaDr
		If ($IsObject(ObjBacteria)){
			Set BacID   = ObjBacteria.%Id()
			Set BacCode = ObjBacteria.BTBacCode
			Set BacDesc = ObjBacteria.BTBacDesc
		}
		For xIndi=1:1:2{
			If (xIndi=1){
				//输出第一种菌信息
				If (BacID'=""){
					Set Bacteria = ""
					Set xBactMapID = ""
					For {
						Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
						Quit:xBactMapID="" 
							
						Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
						Continue:'$Isobject(objMap)
						Set Bacteria = objMap.BTBacteria
					}
					Continue:Bacteria=""
					Set Result = Bacteria
					
					Set MRBID="",MRBCode="",MRBDesc=""
					Set ObjRuleMRB = objOut.RuleMRBDr
					If ($IsObject(ObjRuleMRB)){
						Set MRBID   = ObjRuleMRB.%Id()
						Set MRBDesc = ObjRuleMRB.BTDesc
						Set MRBCode = ObjRuleMRB.BTCode
					}
					Continue:MRBDesc="" //过滤出多重耐药菌
					//多重耐药菌报告日期后的隔离医嘱名称和开始日期
					Continue:RepDate=""
					Set IsCheckMRB=1
					Set IsolateInfo=..CheckEpisISOAct(EpisodeDr,MRBID,RepDate)
					If (IsolateInfo'=""){  // 已做隔离医嘱处理
						Set tmpFlgISOOrdDesc=$p(IsolateInfo,"^",$l(IsolateInfo,"^"))
						Set ISOEndDate = $p(tmpFlgISOOrdDesc,"~",2)
						Set:ISOEndDate["-" ISOEndDate=$zdh(ISOEndDate,3)
						Continue:(ISOEndDate'="")&&(ISOEndDate<=(+$h)) // 隔离结束不需要提示
						Continue:ISOEndDate'="" // 隔离结束不需要提示
						Set FlgISOOrdDesc=tmpFlgISOOrdDesc
					}
				}
			}Else{
				// 输出第二种菌相关信息
				Set BacID="",BacCode="",BacDesc=""
				Set ObjBacteria = objOut.BacteriaDr2
				If ($IsObject(ObjBacteria)){
					Set BacID   = ObjBacteria.%Id()
					Set BacCode = ObjBacteria.BTBacCode
					Set BacDesc = ObjBacteria.BTBacDesc
				}
				Continue:BacID=""
				Set Bacteria = ""
				Set xBactMapID = ""
				For {
					Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
					Quit:xBactMapID="" 
						
					Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
					Continue:'$Isobject(objMap)
					Set Bacteria = objMap.BTBacteria
				}
				Continue:Bacteria=""
				
				Set MRBID="",MRBCode="",MRBDesc=""
				Set ObjRuleMRB = objOut.RuleMRBDr2
				If ($IsObject(ObjRuleMRB)){
					Set MRBID   = ObjRuleMRB.%Id()
					Set MRBDesc = ObjRuleMRB.BTDesc
					Set MRBCode = ObjRuleMRB.BTCode
				}
				Continue:MRBDesc="" //过滤出多重耐药菌
				//多重耐药菌报告日期后的隔离医嘱名称和开始日期
				Continue:RepDate=""
				Set IsCheckMRB=1
				Set IsolateInfo=..CheckEpisISOAct(EpisodeDr,MRBID,RepDate)
				If (IsolateInfo'=""){  // 已做隔离医嘱处理
					Set tmpFlgISOOrdDesc=$p(IsolateInfo,"^",$l(IsolateInfo,"^"))
					Set ISOEndDate = $p(tmpFlgISOOrdDesc,"~",2)
					Set:ISOEndDate["-" ISOEndDate=$zdh(ISOEndDate,3)
					Continue:(ISOEndDate'="")&&(ISOEndDate<=(+$h)) // 隔离结束不需要提示
					Set FlgISOOrdDesc=tmpFlgISOOrdDesc
				}
			}
		}
	}
	If (FlgISOOrdDesc'=""){
		Set return="该患者已做隔离处理："_FlgISOOrdDesc_",请做好隔离防护措施。"
	}
	
	// 获取上一次转科日期和停隔离医嘱日期，最近一次入科时间与最近一次停隔离医嘱时间比较，
	// 停隔离医嘱时间比转科时间小12H
	// 患者发生转科，停隔离医嘱时间和转科时间间隔N小时，多耐图标继续点亮。默认12H
	If ((IsCheckMRB=1)&&(FlgISOOrdDesc="")){
		//若患者转科后多耐图标继续点亮，在N小时内如果医生还未下隔离医嘱，图标自动取消。	
		Set TransMRBHourInfo = ##class(DHCHAI.BT.Config).GetValByCode("MRBTransMRBIcon","")
		Set TransMRBHour     = +$p(TransMRBHourInfo,"-",1)
		Set CancelMRBHour    = +$p(TransMRBHourInfo,"-",2)
		Set:TransMRBHour=0 TransMRBHour=12
		Set:CancelMRBHour=0 CancelMRBHour=48
		Set CurrLocInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetCurrLocInfo(EpisodeDr,"E")
		Set TransDate   = $p(CurrLocInfo,"^",3)
		Set PATransTime = $p(CurrLocInfo,"^",4)
		Set ISODateInfo = ##class(DHCHAI.IRS.CtlMRBSrv).GetEpisStopISODate(EpisodeDr)
		Set ISODateInfo = $p(ISODateInfo,"#",1)
		Set ISOStarInfo = $p(ISODateInfo,"#",2)
		If (ISODateInfo'=""){
			Set SttDate = $p(ISODateInfo,"^",3)
			Set SttTime = $p(ISODateInfo,"^",4)
			Set EndDate = $p(ISODateInfo,"^",5)
			Set EndTime = $p(ISODateInfo,"^",6)
			//最近一次开隔离医嘱时间
			Set FSttDate = $p(ISOStarInfo,"^",3)
			Set FSttTime = $p(ISOStarInfo,"^",4)
			
			If ((SttDate<TransDate)||((SttDate=TransDate)&&(SttTime<PATransTime))){
				Set Hour = ##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime(EndDate,EndTime,TransDate,PATransTime)
				If ((Hour>0)&&(Hour<TransMRBHour)){
					// 12H 内符合点亮规则
					Set return = "该患者转科有携带多重耐药菌！请做隔离处理！"
				}
				If ((FSttDate>TransDate)||((FSttDate=TransDate)&&(FSttTime>PATransTime))){
					Set StartHour = ##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime(TransDate,PATransTime,FSttDate,FSttTime)
					If (StartHour>CancelMRBHour){
						// 48H内未下隔离医嘱，不在提醒
						Set return = ""
					}
				}Else{
					//开隔离医嘱小于转科日期，需与当前时间比较
					Set FSttDate = +$h
					Set FSttTime = $p($h,",",2)
					If ((FSttDate>TransDate)||((FSttDate=TransDate)&&(FSttTime>PATransTime))){
						Set StartHour = ##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime(TransDate,PATransTime,FSttDate,FSttTime)
						If (StartHour>CancelMRBHour){
							// 48H内未下隔离医嘱，不在提醒
							Set return = ""
						}
					}
				}
			}
		}
	}
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-08-08
/// Description:  查询耐药菌药敏结果
/// Table：       DHCHAI.DP.LabVisitRepResult、 DHCHAI.DP.LabVisitRepResultSen
/// Input：       aResultID:检验结果ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CtlMRBSrv","QryResultSen","972")
Query QryResultSen(aResultID As %String) As %Query(ROWSPEC = "ID:%String,AntCode:%String,AntDesc:%String,Sensitivity:%String,IsInt:%String") [ SqlProc ]
{
}

ClassMethod QryResultSenExecute(ByRef qHandle As %Binary, aResultID As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aResultID="") $$$OK

	Set xSenID = ""
	For {
    	Set xSenID =$o(^DHCHAI.DP.LabVisitRepRstSenI("IndexLabResultDr",aResultID,xSenID))
    	Quit:xSenID=""
		
		Set objSen = ##class(DHCHAI.DP.LabVisitRepRstSen).GetObjById(xSenID)
		Continue:'$isobject(objSen)
	    
		Set AntCode      = objSen.LabAntCode
		Set AntDesc      = objSen.LabAntDesc
		Set Sensitivity  = objSen.LabSensitivity
		Set IsInt        = objSen.LabIsInt
        //多语言处理
        Set Sensitivity =##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",Sensitivity,"DHCHAI.BT.Dictionary")
    	Set AntDesc =##Class(DHCHAI.Abstract).HAIGetTranByDesc("ARCIMDesc",AntDesc,"User.ARCItmMast")
    	
		Set Data = $lb(xSenID,AntCode,AntDesc,Sensitivity,IsInt)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
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

/// Creator：     mayanpeng
/// CreatDate：   2017-12-10
/// Description:  查询耐药菌监控结果,合并相同病原体
/// Table：       DHCHAI.IR.CCResult
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CtlMRBSrv","QryMRBMonitor","1|2|3","1","2019-01-01","2020-12-01","","","","")
Query QryMRBMonitor(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aInfID As %String, aBactID As %String, aMRBID As %String, aWardID As %String = "", aRepTypeID As %String = "") As %Query(ROWSPEC = "ID:%String,AdmID:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmBed:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,LocID:%String,LocCode:%String,LocDesc:%String,LabWardID:%String,LabWardCode:%String,LabWardDesc:%String,SpecBact:%String,MRBDesc:%String,Detil:%String") [ SqlProc ]
{
}

ClassMethod QryMRBMonitorExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aInfID As %String, aBactID As %String, aMRBID As %String, aWardID As %String = "", aRepTypeID As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aDateType="" $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set aRepTypeCode=""
    If (aRepTypeID'=""){
    	Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(aRepTypeID)
		Set:'$Isobject(objDic) aRepTypeCode = objDic.BTCode
    }
    Set ZIndex=$zn,JIndex=$j,NIndex="MRBMonitor"
    Kill ^TMP(ZIndex,JIndex,NIndex)
    //送检日期
    If aDateType=1{
	     If ((aRepTypeCode=3)||(aRepTypeCode="")){
		    Set xItemID=0
		    For {
				Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID))
				Quit:xItemID=""
				
				Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
				Continue:'$IsObject(objItem)
				Set ItemCode=objItem.CCCode
				Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")
				
			    Set xDate=aDateFrom-1
			    For {
					Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate))
					Quit:xDate=""
					Quit:(xDate>aDateTo)
					
					Set xID=""
					For {
						Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
						Quit:xID=""
						
						Do BuildMRBMonData
					}
				}
		    }
	     }
	     //增加外院携带的多耐信息 
		For xDate=aDateFrom:1:aDateTo {
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.OutLabReportI("IndexSubmissDate",xDate,xID))
				Quit:xID=""
				
				Do BuildOutMRB3Data
			}
		}
	}  Else { //报告日期
		If ((aRepTypeCode=3)||(aRepTypeCode="")){
			Set xItemID=""
			For {
				Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID))
				Quit:xItemID=""
				
				Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
				Continue:'$IsObject(objItem)
				Set ItemCode=objItem.CCCode
				Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")
				
				Set xDate=aDateFrom-1
			    For {
					Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate))
					Quit:xDate=""
					Quit:(xDate>aDateTo)
					
					Set xID=""
					For {
						Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate,xID))
						Quit:xID=""
						
						Do BuildMRBMonData
					}
			    }
			}
		}
		//增加外院携带的多耐信息 
		For xDate=aDateFrom:1:aDateTo {
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.OutLabReportI("IndexLabAuthDate",xDate,xID))
				Quit:xID=""
				
				Do BuildOutMRB3Data
			}
		}		
	} 
	
	Set PAAdmID=0
	For {
		Set PAAdmID=$o(^TMP(ZIndex,JIndex,NIndex,"SpecBact",PAAdmID))
		Quit:PAAdmID=""
		
		Set SpecBact=$g(^TMP(ZIndex,JIndex,NIndex,"SpecBact",PAAdmID))
		Continue:SpecBact=""
		Set SpecBact=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(SpecBact,",")
		
		Set MRBDesc=$g(^TMP(ZIndex,JIndex,NIndex,"MRBDesc",PAAdmID))
		Set:MRBDesc'="" MRBDesc=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(MRBDesc,",")
		
		Set Data=$g(^TMP(ZIndex,JIndex,NIndex,"BaseInfo",PAAdmID))_$lb(SpecBact,MRBDesc,Detil)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit $$$OK
	
BuildMRBMonData
	Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
	Quit:'$Isobject(objResult)
	Quit:objResult.CCIsActive'=1
	Set IsAbFlag=objResult.CCIsAbFlag
	Quit:IsAbFlag'=1             //过滤非耐药菌
	
	Set MRBID="",MRBCode="",MRBDesc=""
	If $IsObject(objResult.CCMRBTpDr) {
		Set MRBID=objResult.CCMRBTpDr.%Id()
		Set MRBDesc = objResult.CCMRBTpDr.BTDesc
		Set MRBCode = objResult.CCMRBTpDr.BTCode
	}
	Quit:MRBDesc="" //过滤出多重耐药菌
	// 同一种菌满足两种多耐
	Set MRBID2="",MRBCode2="",MRBDesc2=""
	If $IsObject(objResult.CCMRBTp2Dr) {
		
		Set MRBID2=objResult.CCMRBTp2Dr.%Id()
		Set MRBDesc2 = objResult.CCMRBTp2Dr.BTDesc
		Set MRBCode2 = objResult.CCMRBTp2Dr.BTCode
	}
	Quit:(aMRBID'="")&&((aMRBID'=MRBID)&&(aMRBID'=MRBID2))
	
	Set AdmID  = objResult.CCEpisodeDr.%Id()
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(AdmID)
	Quit:'$Isobject(objAdm)
	Set EpisodeID = objAdm.PAEpisodeIDx
	Set PatientID = objAdm.PAPatientIDx
	Set PapmiNo   = objAdm.PAPapmiNo
	Set MrNo      = objAdm.PAMrNo
	Set PatName   = objAdm.PAPatName
	Set Sex       = objAdm.PASex
	Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
	Set AdmDate   = objAdm.PAAdmDate
	Set AdmTime   = objAdm.PAAdmTime
	Set Age       =  objAdm.PAAge
	Set DischDate = objAdm.PADischDate
	Set DischTime = objAdm.PADischTime
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set:DischTime'="" DischTime=$zt(DischTime,1)	
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objAdm.PAAdmBedDr){
		Set AdmBedDr=objAdm.PAAdmBedDr.%Id()
		Set AdmBed=objAdm.PAAdmBedDr.BTDesc
	}
	Set objAdmLoc = objAdm.PAAdmLocDr
	Set AdmLocID="", AdmLocDesc=""    //就诊科室
	If $Isobject(objAdmLoc) {
		Set AdmLocID = objAdmLoc.%Id()
		Set AdmLocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc2 = objAdmLoc.BTDesc2
		Set AdmLocDesc = $s(AdmLocDesc2'="":AdmLocDesc2,1:AdmLocDesc)
	}
	Set objAdmWard = objAdm.PAAdmWardDr
	Set AdmWardID="",AdmWardDesc=""   //就诊病区
	If $Isobject(objAdmWard) {
		Set AdmWardID  = objAdmWard.%Id()
		Set AdmWardDesc = objAdmWard.BTDesc
		Set AdmWardDesc2 = objAdmWard.BTDesc2
		Set AdmWardDesc = $s(AdmWardDesc2'="":AdmWardDesc2,1:AdmWardDesc)
		/*If $IsObject(objAdmWard.BTHospDr){
			Set HospID=objAdmWard.BTHospDr.%Id()			
			Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  	//医院过滤	
		}*/
	}
	Quit:(aLocID'="")&&(aLocID'=AdmWardID)
   	//过滤院区-->aHospIDs(按送检/报告科室进行过滤院区)
	Set ActDate	=objResult.CCActDate	//送检日期		
	Set ActTime	=objResult.CCActTime	//送检时间
	Set RepDate =objResult.CCRepDate	//报告日期
	Set RepTime =objResult.CCRepTime	//报告时间
	If (aDateType=1){	//送检科室
		Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,ActDate,ActTime)
		Set ActLocID = $p(TransInfo,"^",1)
		Quit:ActLocID=""
		
		Set ActLocData  = $g(^DHCHAI.BT.LocationD(ActLocID))
		Set HospID = $li(ActLocData,8)
	}					
	else{				//报告科室
		Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,RepDate,RepTime)
		Set RepLocID = $p(TransInfo,"^",1)
		Quit:RepLocID=""
		
  		Set RepLocData  = $g(^DHCHAI.BT.LocationD(RepLocID))
		Set HospID = $li(RepLocData,8)
	}
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospID)<1) 	//医院过滤
   
	Set LocID="", LocCode="", LocDesc=""
	If $IsObject(objResult.CCActLocDr){
		Set LocID =  objResult.CCActLocDr.%Id()
		Set LocCode = objResult.CCActLocDr.BTCode
		Set LocDesc = objResult.CCActLocDr.BTDesc
		Set LocDesc2 = objResult.CCActLocDr.BTDesc2
		Set LocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	
	Set Result   = objResult.CCResult
	Set ActDate  = objResult.CCActDate
	Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set ActTime  = objResult.CCActTime
	Set:ActTime'="" ActTime=$zt(ActTime,1)
	Set RepDate  = objResult.CCRepDate
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set RepTime  = objResult.CCRepTime 
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	Set SCode    = objResult.CCSCode      //子系统代码
	Set Specimen = objResult.CCSpecimen   //原始标本名称
	Set SpeID="",SpeCode="",SpeDesc=""
	Set objSpe=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
	If $IsObject(objSpe) {
		If $IsObject(objSpe.BTMapItemDr){
			Set SpeID=objSpe.BTMapItemDr.%Id()
			Set SpeCode=objSpe.BTMapItemDr.BTSpecCode
			Set SpeDesc=objSpe.BTMapItemDr.BTSpecDesc
		}
	}
	Set Bacteria = objResult.CCBacteria   //原始细菌名称
	Quit:Bacteria=""
	Set BacID="",BacCode="",BacDesc=""
	Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	If $IsObject(objBactMap){
		Quit:objBactMap.BTIsActive'=1  //菌是否有效
		If $IsObject(objBactMap.BTMapItemDr){
			Set BacID=objBactMap.BTMapItemDr.%Id()
			Set BacCode=objBactMap.BTMapItemDr.BTBacCode
			Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
		}
	}
	Quit:(aBactID'="")&&(BacID'=aBactID)

	//一份送检标本，检出多条菌，对应多条LabVisitRepResult和CCResult，但LabVisitReport唯一
	Set ResultID = $p(objResult.CCParams,"=",2)  //检验结果ID
	Set (LabRepID,LabWardID,LabWardCode,LabWardDesc,InfTypeCode) = ""
	Set objLabRes= ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResultID)
	If $IsObject(objLabRes) {
		Set InfTypeCode = objLabRes.LabMakeInfType
		Set LabRepID=objLabRes.LabReportDr.%Id()
		Set objLabRep=##class(DHCHAI.DP.LabVisitReport).GetObjById(LabRepID)
		If $IsObject(objLabRep.LabVisitNumberDr) {
			Set VisitNumberID=objLabRep.LabVisitNumberDr.%Id()
			Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(VisitNumberID)
			If $IsObject(objVisitNumber.LabWardDr) {
				Set LabWardID=objVisitNumber.LabWardDr.%Id()
				Set LabWardCode=objVisitNumber.LabWardDr.BTCode
				Set LabWardDesc=objVisitNumber.LabWardDr.BTDesc
				Set LabWardDesc2=objVisitNumber.LabWardDr.BTDesc2
				Set LabWardTypeDr=objVisitNumber.LabWardDr.BTTypeDr
				Set LabWardDesc = $s(LabWardDesc2'="":LabWardDesc2,1:LabWardDesc)
			}
		}
	}	
	Quit:(aWardID'="")&&(LabWardID'=aWardID)
	Set INFMBRID=""
	Set objInf=##class(DHCHAI.IR.INFMBR).GetObjByRepBact(LabRepID,BacID)		     
	If $IsObject(objInf){
		Set INFMBRID =objInf.%Id()		
	}
	Set InfTypeID="",InfTypeDesc=""
	Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfTypeCode)
    If $IsObject(objDic) {
	    Set InfTypeID 	= objDic.%Id()
	    Set InfTypeDesc = objDic.BTDesc		
	}
	Quit:(aInfID'="")&&(InfTypeID'=aInfID)
	Set Detil = "明细"
	
	
	//多语言处理
 	Set Detil = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.mrb.ctlmonitor.csp",Detil)
    Set AdmLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmLocDesc,"User.CTLoc")
    Set AdmWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmWardDesc,"User.CTLoc")
    Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
    Set Bacteria=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTBacDesc",Bacteria,"DHCHAI.DP.LabBacteria")       //细菌名称			
    Set Specimen=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",Specimen,"DHCHAI.DP.LabSpecimen")  
    Set MRBDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc,"DHCHAI.IR.CRuleMRB") 
    Set MRBDesc2=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc2,"DHCHAI.IR.CRuleMRB") 
    Set LabWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LabWardDesc,"User.CTLoc")
    Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")  //性别
	Set:Age["岁" Age=$Replace(Age,"岁",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","岁"))  //年龄
	Set:Age["月" Age=$Replace(Age,"月",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","月"))
	Set:Age["天" Age=$Replace(Age,"天",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","天"))
	
	Set:'$d(^TMP(ZIndex,JIndex,NIndex,"SpecBact",AdmID)) ^TMP(ZIndex,JIndex,NIndex,"SpecBact",AdmID)=""
	Set ^TMP(ZIndex,JIndex,NIndex,"SpecBact",AdmID)=$g(^TMP(ZIndex,JIndex,NIndex,"SpecBact",AdmID))_","_Specimen_" -> "_Bacteria
	Set:MRBDesc'="" ^TMP(ZIndex,JIndex,NIndex,"MRBDesc",AdmID)=$g(^TMP(ZIndex,JIndex,NIndex,"MRBDesc",AdmID))_","_MRBDesc_","_MRBDesc2
	Set ^TMP(ZIndex,JIndex,NIndex,"BaseInfo",AdmID)=$lb(xID,AdmID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime,LocID,LocCode,LocDesc,LabWardID,LabWardCode,LabWardDesc)
	Quit 1
BuildOutMRB3Data
	Set objOut=##class(DHCHAI.IR.OutLabReport).GetObjById(xID)
	Quit:'$IsObject(objOut)
	Set LabIsActive = +objOut.LabIsActive
	Quit:(LabIsActive'=1)
	Set objAdm = objOut.LabEpisodeDr
	Quit:'$IsObject(objAdm)
	Set AdmID  = objAdm.%Id()
	Set IsAbFlag=1   //异常标志
	
	Set EpisodeID = objAdm.PAEpisodeIDx
	Set PatientID = objAdm.PAPatientIDx
	Set PapmiNo   = objAdm.PAPapmiNo
	Set MrNo      = objAdm.PAMrNo
	Set PatName   = objAdm.PAPatName
	Set Sex       = objAdm.PASex
	Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
	Set AdmDate   = objAdm.PAAdmDate
	Set AdmTime   = objAdm.PAAdmTime
	Set Age       =  objAdm.PAAge
	Set DischDate = objAdm.PADischDate
	Set DischTime = objAdm.PADischTime
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set:DischTime'="" DischTime=$zt(DischTime,1)	
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objAdm.PAAdmBedDr){
		Set AdmBedDr=objAdm.PAAdmBedDr.%Id()
		Set AdmBed=objAdm.PAAdmBedDr.BTDesc
	}
	Set objAdmLoc = objAdm.PAAdmLocDr
	Set AdmLocID="", AdmLocDesc=""    //就诊科室
	If $Isobject(objAdmLoc) {
		Set AdmLocID = objAdmLoc.%Id()
		Set AdmLocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc2 = objAdmLoc.BTDesc2
		Set AdmLocDesc = $s(AdmLocDesc2'="":AdmLocDesc2,1:AdmLocDesc)
	}
	Set objAdmWard = objAdm.PAAdmWardDr
	Set AdmWardID="",AdmWardDesc=""   //就诊病区
	If $Isobject(objAdmWard) {
		Set AdmWardID  = objAdmWard.%Id()
		Set AdmWardDesc = objAdmWard.BTDesc
		Set AdmWardDesc2 = objAdmWard.BTDesc2
		Set AdmWardDesc = $s(AdmWardDesc2'="":AdmWardDesc2,1:AdmWardDesc)
		If $IsObject(objAdmWard.BTHospDr){
			Set HospID=objAdmWard.BTHospDr.%Id()			
			Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  	//医院过滤	
		}
	}
	Quit:(aLocID'="")&&((aLocID'=AdmWardID)&(aLocID'=AdmLocID))  //允许增加科室入参查询
	Set ActDate  = objOut.SubmissDate
	Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set ActTime  = "1"
	Set:ActTime'="" ActTime=$zt(ActTime,1)
	Set RepDate  = objOut.LabAuthDate
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set RepTime  = "1"
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	
	Set BTTestSet="",BTTestSetID=""
	Set ObjTestSet = objOut.TestSetDr
	If ($IsObject(ObjTestSet)){
		Set BTTestSetID = ObjTestSet.%Id()
		Set BTTestSet   = ObjTestSet.BTTestSet
	}
	Set SpeID="",SpeCode="",SpeDesc=""
	Set ObjSpec = objOut.SpecimenDr
	If ($IsObject(ObjSpec)){
		Set SpeID   = ObjSpec.%Id()
		Set SpeCode = ObjSpec.BTSpecCode
		Set SpeDesc = ObjSpec.BTSpecDesc
	}
	Set Specimen = SpeDesc
	Set MRBOutLabType="外院携带"
	Set MRBOutLabTypeID = ##class(DHCHAI.BT.Dictionary).GetIDByDesc("MRBOutLabType",MRBOutLabType)
	Quit:(aRepTypeID'="")&&(MRBOutLabTypeID'=aRepTypeID)
	Set BacID="",BacCode="",BacDesc=""
	Set ObjBacteria = objOut.BacteriaDr
	If ($IsObject(ObjBacteria)){
		Set BacID   = ObjBacteria.%Id()
		Set BacCode = ObjBacteria.BTBacCode
		Set BacDesc = ObjBacteria.BTBacDesc
	}
	Set LocID="", LocCode="", LocDesc=""
	If $IsObject(objOut.LabLocDr){
		Set LocID =  objOut.LabLocDr.%Id()
		Set LocCode = objOut.LabLocDr.BTCode
		Set LocDesc = objOut.LabLocDr.BTDesc
		Set LocDesc2 = objOut.LabLocDr.BTDesc2
		Set LocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	
	For xIndi=1:1:2{
		If (xIndi=1){
			//输出第一种菌信息
			If (BacID'=""){
				Set Bacteria = ""
				Set xBactMapID = ""
				For {
					Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
					Quit:xBactMapID="" 
						
					Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
					Continue:'$Isobject(objMap)
					Set Bacteria = objMap.BTBacteria
				}
				Continue:Bacteria=""
				Continue:(aBactID'="")&&(BacID'=aBactID)
				Set Result = Bacteria
				
				Set MRBID="",MRBCode="",MRBDesc=""
				Set ObjRuleMRB = objOut.RuleMRBDr
				If ($IsObject(ObjRuleMRB)){
					Set MRBID   = ObjRuleMRB.%Id()
					Set MRBDesc = ObjRuleMRB.BTDesc
					Set MRBCode = ObjRuleMRB.BTCode
				}
				Continue:MRBDesc="" //过滤出多重耐药菌
				Continue:(aMRBID'="")&&(aMRBID'=MRBID)
				// 同一种菌满足两种多耐
				Set MRBID2="",MRBCode2="",MRBDesc2=""
				
				Set ResultID = ""  //检验结果ID
				Set (LabRepID,LabWardID,LabWardCode,LabWardDesc,InfTypeCode,IsByHand) = ""	
				If $IsObject(objOut.LabWardDr){
					Set LabWardID =  objOut.LabWardDr.%Id()
					Set LabWardCode = objOut.LabWardDr.BTCode
					Set LabWardDesc = objOut.LabWardDr.BTDesc
					Set LabWardDesc2 = objOut.LabWardDr.BTDesc2
					Set LabWardDesc = $s(LabWardDesc2'="":LabWardDesc2,1:LabWardDesc)
				}
				Continue:LabWardID=""
				Continue:(aWardID'="")&&(LabWardID'=aWardID)
				
				Set LabRepID = xID_"||"_BacID
				Set INFMBRID=""
				Set objInf=##class(DHCHAI.IR.INFMBR).GetObjByOutRepBact(xID,BacID)		     
				If $IsObject(objInf){
					Set INFMBRID =objInf.%Id()
				}
				Set InfTypeCode = objOut.LabMakeInfType   //感染类型
				Set InfTypeID="",InfTypeDesc=""
				Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfTypeCode)
			    If $IsObject(objDic) {
				    Set InfTypeID 	= objDic.%Id()
				    Set InfTypeDesc = objDic.BTDesc		
				}
				Continue:(aInfID'="")&&((","_aInfID_",")'[(","_InfTypeID_","))
				Set Detil = "明细"
				Set MRBDesc2=""
				//多语言处理
			 	Set Detil = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.mrb.ctlmonitor.csp",Detil)
			    Set AdmLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmLocDesc,"User.CTLoc")
			    Set AdmWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmWardDesc,"User.CTLoc")
			    Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
			    Set Bacteria=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTBacDesc",Bacteria,"DHCHAI.DP.LabBacteria")       //细菌名称			
			    Set Specimen=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",Specimen,"DHCHAI.DP.LabSpecimen")  
			    Set MRBDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc,"DHCHAI.IR.CRuleMRB") 
			    Set MRBDesc2=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc2,"DHCHAI.IR.CRuleMRB") 
			    Set LabWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LabWardDesc,"User.CTLoc")
			    Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")  //性别
				Set:Age["岁" Age=$Replace(Age,"岁",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","岁"))  //年龄
				Set:Age["月" Age=$Replace(Age,"月",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","月"))
				Set:Age["天" Age=$Replace(Age,"天",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","天"))
				
				Set:'$d(^TMP(ZIndex,JIndex,NIndex,"SpecBact",AdmID)) ^TMP(ZIndex,JIndex,NIndex,"SpecBact",AdmID)=""
				Set ^TMP(ZIndex,JIndex,NIndex,"SpecBact",AdmID)=$g(^TMP(ZIndex,JIndex,NIndex,"SpecBact",AdmID))_","_Specimen_" -> "_Bacteria
				Set:MRBDesc'="" ^TMP(ZIndex,JIndex,NIndex,"MRBDesc",AdmID)=$g(^TMP(ZIndex,JIndex,NIndex,"MRBDesc",AdmID))_","_MRBDesc_","_MRBDesc2
				Set ^TMP(ZIndex,JIndex,NIndex,"BaseInfo",AdmID)=$lb(xID,AdmID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime,LocID,LocCode,LocDesc,LabWardID,LabWardCode,LabWardDesc)
			}
		}Else{
			// 输出第二种菌相关信息
			Set BacID="",BacCode="",BacDesc=""
			Set ObjBacteria = objOut.BacteriaDr2
			If ($IsObject(ObjBacteria)){
				Set BacID   = ObjBacteria.%Id()
				Set BacCode = ObjBacteria.BTBacCode
				Set BacDesc = ObjBacteria.BTBacDesc
			}
			Continue:BacID=""
			Set Bacteria = ""
			Set xBactMapID = ""
			For {
				Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
				Quit:xBactMapID="" 
					
				Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
				Continue:'$Isobject(objMap)
				Set Bacteria = objMap.BTBacteria
			}
			Continue:Bacteria=""
			Continue:(aBactID'="")&&(BacID'=aBactID)
			Set Result = Bacteria
			
			Set MRBID="",MRBCode="",MRBDesc=""
			Set ObjRuleMRB = objOut.RuleMRBDr2
			If ($IsObject(ObjRuleMRB)){
				Set MRBID   = ObjRuleMRB.%Id()
				Set MRBDesc = ObjRuleMRB.BTDesc
				Set MRBCode = ObjRuleMRB.BTCode
			}
			Continue:MRBDesc="" //过滤出多重耐药菌
			Continue:(aMRBID'="")&&(aMRBID'=MRBID)
			Set ResultID = ""  //检验结果ID
			Set (LabRepID,LabWardID,LabWardCode,LabWardDesc,InfTypeCode,IsByHand) = ""	
			If $IsObject(objOut.LabWardDr){
				Set LabWardID =  objOut.LabWardDr.%Id()
				Set LabWardCode = objOut.LabWardDr.BTCode
				Set LabWardDesc = objOut.LabWardDr.BTDesc
				Set LabWardDesc2 = objOut.LabWardDr.BTDesc2
				Set LabWardDesc = $s(LabWardDesc2'="":LabWardDesc2,1:LabWardDesc)
			}
			Continue:LabWardID=""
			Continue:(aWardID'="")&&(LabWardID'=aWardID)
			Set LabRepID = xID_"||"_BacID
			Set INFMBRID=""
			Set objInf=##class(DHCHAI.IR.INFMBR).GetObjByOutRepBact(xID,BacID)		     
			If $IsObject(objInf){
				Set INFMBRID =objInf.%Id()
			}
			Set InfTypeCode = objOut.LabMakeInfType   //感染类型
			Set InfTypeID="",InfTypeDesc=""
			Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfTypeCode)
		    If $IsObject(objDic) {
			    Set InfTypeID 	= objDic.%Id()
			    Set InfTypeDesc = objDic.BTDesc		
			}
			Continue:(aInfID'="")&&((","_aInfID_",")'[(","_InfTypeID_","))
			Set Detil = "明细"
			Set MRBDesc2=""
			//多语言处理
		 	Set Detil = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.mrb.ctlmonitor.csp",Detil)
		    Set AdmLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmLocDesc,"User.CTLoc")
		    Set AdmWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmWardDesc,"User.CTLoc")
		    Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
		    Set Bacteria=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTBacDesc",Bacteria,"DHCHAI.DP.LabBacteria")       //细菌名称			
		    Set Specimen=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",Specimen,"DHCHAI.DP.LabSpecimen")  
		    Set MRBDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc,"DHCHAI.IR.CRuleMRB") 
		    Set MRBDesc2=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc2,"DHCHAI.IR.CRuleMRB") 
		    Set LabWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LabWardDesc,"User.CTLoc")
		    Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")  //性别
			Set:Age["岁" Age=$Replace(Age,"岁",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","岁"))  //年龄
			Set:Age["月" Age=$Replace(Age,"月",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","月"))
			Set:Age["天" Age=$Replace(Age,"天",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","天"))
			
			Set:'$d(^TMP(ZIndex,JIndex,NIndex,"SpecBact",AdmID)) ^TMP(ZIndex,JIndex,NIndex,"SpecBact",AdmID)=""
			Set ^TMP(ZIndex,JIndex,NIndex,"SpecBact",AdmID)=$g(^TMP(ZIndex,JIndex,NIndex,"SpecBact",AdmID))_","_Specimen_" -> "_Bacteria
			Set:MRBDesc'="" ^TMP(ZIndex,JIndex,NIndex,"MRBDesc",AdmID)=$g(^TMP(ZIndex,JIndex,NIndex,"MRBDesc",AdmID))_","_MRBDesc_","_MRBDesc2
			Set ^TMP(ZIndex,JIndex,NIndex,"BaseInfo",AdmID)=$lb(xID,AdmID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime,LocID,LocCode,LocDesc,LabWardID,LabWardCode,LabWardDesc)
		}
	}
	Quit 1
}

ClassMethod QryMRBMonitorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBMonitorExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMRBMonitorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBMonitorExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2018-01-23
/// Description:  查询病原体明细
/// Table：       DHCHAI.IR.CCResult
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CtlMRBSrv","QryBactDetail","1","1","2022-08-01","2022-08-31")
Query QryBactDetail(aEpisodeID As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ID:%String,Result:%String,Specimen:%String,Bacteria:%String,ResultID:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,ActDate:%String,ActTime:%String,RepDate:%String,RepTime:%String,ActLocID:%String,ActLocDesc:%String,ActUser:%String,MRBID2:%String,MRBCode2:%String,MRBDesc2:%String") [ SqlProc ]
{
}

ClassMethod QryBactDetailExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="")||(aDateType="") $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set ItemIDs=""
    Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-Bacteria")
    If $IsObject(objItmMast){
	    Set ItemIDs=ItemIDs_$lb(objItmMast.%Id())
	}
	Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-TestAb")
    If $IsObject(objItmMast){
	    Set ItemIDs=ItemIDs_$lb(objItmMast.%Id())
	}
    Quit:ItemIDs="" $$$OK
    
    If aDateType=1{
	    For Index=1:1:$ListLength(ItemIDs){
		    Set xItemID=$List(ItemIDs,Index)
		   	Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xDate))
				Quit:xDate=""
				Quit:(xDate>aDateTo)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildBactDetail
				}
			}
		}
	
		//增加外院携带的多耐信息 
		For xDate=aDateFrom:1:aDateTo {
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.OutLabReportI("IndexSubmissDate",xDate,xID))
				Quit:xID=""
				
				Do BuildOutMRB4Data
			}
		}
	} Else { //报告日期
		For Index=1:1:$ListLength(ItemIDs){
		    Set xItemID=$List(ItemIDs,Index)
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",aEpisodeID,xItemID,xDate))
				Quit:xDate=""
				Quit:(xDate>aDateTo)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",aEpisodeID,xItemID,xDate,xID))
					Quit:xID=""
					
					Do BuildBactDetail
				}
			}
		}
		//增加外院携带的多耐信息 
		For xDate=aDateFrom:1:aDateTo {
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.OutLabReportI("IndexLabAuthDate",xDate,xID))
				Quit:xID=""
				
				Do BuildOutMRB4Data
			}
		}
	}
	Quit $$$OK
BuildBactDetail
	Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
	Quit:'$Isobject(objResult)
	Quit:objResult.CCIsActive'=1
	Set IsAbFlag=objResult.CCIsAbFlag
	Quit:IsAbFlag'=1             //过滤非耐药菌
	Set MRBID="",MRBCode="",MRBDesc=""
	If $IsObject(objResult.CCMRBTpDr) {
		Set MRBID=objResult.CCMRBTpDr.%Id()
		Set MRBDesc = objResult.CCMRBTpDr.BTDesc
		Set MRBCode = objResult.CCMRBTpDr.BTCode
	}
	Quit:MRBDesc="" //过滤出多重耐药菌
	Set MRBID2="",MRBCode2="",MRBDesc2=""
	If $IsObject(objResult.CCMRBTp2Dr) {
		Set MRBID2=objResult.CCMRBTp2Dr.%Id()
		Set MRBDesc2 = objResult.CCMRBTp2Dr.BTDesc
		Set MRBCode2 = objResult.CCMRBTp2Dr.BTCode
	}
	Set Result   = objResult.CCResult
	Set Specimen = objResult.CCSpecimen   //原始标本名称
	Set Bacteria = objResult.CCBacteria   //原始细菌名称
	Set ActDate  = objResult.CCActDate
	Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set ActTime  = objResult.CCActTime
	Set:ActTime'="" ActTime=$zt(ActTime,1)
	Set RepDate  = objResult.CCRepDate
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set RepTime  = objResult.CCRepTime 
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	Set ResultID = $p(objResult.CCParams,"=",2)  //检验结果ID
	Set (ActLocID,ActLocDesc)=""
	If $IsObject(objResult.CCActLocDr){
		Set ActLocID = objResult.CCActLocDr.%Id()
		Set ActLocDesc = objResult.CCActLocDr.BTDesc2
		Set:ActLocDesc="" ActLocDesc=objResult.CCActLocDr.BTDesc
	}
	Set ActUser=objResult.CCActUser
	
	Set Data = $lb(ind,Result,Specimen,Bacteria,ResultID,MRBID,MRBCode,MRBDesc,ActDate,ActTime,RepDate,RepTime,ActLocID,ActLocDesc,ActUser,MRBID2,MRBCode2,MRBDesc2)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit 1
BuildOutMRB4Data
	Set objOut=##class(DHCHAI.IR.OutLabReport).GetObjById(xID)
	Quit:'$IsObject(objOut)
	Set LabIsActive = +objOut.LabIsActive
	Quit:(LabIsActive'=1)
	
	Set objAdm = objOut.LabEpisodeDr
	Quit:'$IsObject(objAdm)
	Set AdmID  = objAdm.%Id()
	Set IsAbFlag=1   //异常标志
	Quit:aEpisodeID'=AdmID
	Set EpisodeID = objAdm.PAEpisodeIDx
	Set PatientID = objAdm.PAPatientIDx
	Set PapmiNo   = objAdm.PAPapmiNo
	Set MrNo      = objAdm.PAMrNo
	Set PatName   = objAdm.PAPatName
	Set Sex       = objAdm.PASex
	Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
	Set AdmDate   = objAdm.PAAdmDate
	Set AdmTime   = objAdm.PAAdmTime
	Set Age       =  objAdm.PAAge
	Set DischDate = objAdm.PADischDate
	Set DischTime = objAdm.PADischTime
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set:DischTime'="" DischTime=$zt(DischTime,1)	
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objAdm.PAAdmBedDr){
		Set AdmBedDr=objAdm.PAAdmBedDr.%Id()
		Set AdmBed=objAdm.PAAdmBedDr.BTDesc
	}
	
	Set objAdmLoc = objAdm.PAAdmLocDr
	Set AdmLocID="", AdmLocDesc=""    //就诊科室
	If $Isobject(objAdmLoc) {
		Set AdmLocID = objAdmLoc.%Id()
		Set AdmLocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc2 = objAdmLoc.BTDesc2
		Set AdmLocDesc = $s(AdmLocDesc2'="":AdmLocDesc2,1:AdmLocDesc)
	}
	Set objAdmWard = objAdm.PAAdmWardDr
	Set AdmWardID="",AdmWardDesc=""   //就诊病区
	If $Isobject(objAdmWard) {
		Set AdmWardID  = objAdmWard.%Id()
		Set AdmWardDesc = objAdmWard.BTDesc
		Set AdmWardDesc2 = objAdmWard.BTDesc2
		Set AdmWardDesc = $s(AdmWardDesc2'="":AdmWardDesc2,1:AdmWardDesc)
	}
	
	Set ActDate  = objOut.SubmissDate
	Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set ActTime  = "1"
	Set:ActTime'="" ActTime=$zt(ActTime,1)
	Set RepDate  = objOut.LabAuthDate
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set RepTime  = "1"
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	
	Set BTTestSet="",BTTestSetID=""
	Set ObjTestSet = objOut.TestSetDr
	If ($IsObject(ObjTestSet)){
		Set BTTestSetID = ObjTestSet.%Id()
		Set BTTestSet   = ObjTestSet.BTTestSet
	}
	Set SpeID="",SpeCode="",SpeDesc=""
	Set ObjSpec = objOut.SpecimenDr
	If ($IsObject(ObjSpec)){
		Set SpeID   = ObjSpec.%Id()
		Set SpeCode = ObjSpec.BTSpecCode
		Set SpeDesc = ObjSpec.BTSpecDesc
	}
	Set Specimen = SpeDesc
	Set MRBOutLabType="外院携带"
	Set MRBOutLabTypeID = ##class(DHCHAI.BT.Dictionary).GetIDByDesc("MRBOutLabType",MRBOutLabType)
	
	Set BacID="",BacCode="",BacDesc=""
	Set ObjBacteria = objOut.BacteriaDr
	If ($IsObject(ObjBacteria)){
		Set BacID   = ObjBacteria.%Id()
		Set BacCode = ObjBacteria.BTBacCode
		Set BacDesc = ObjBacteria.BTBacDesc
	}
	Set LocID="", LocCode="", LocDesc=""
	If $IsObject(objOut.LabLocDr){
		Set LocID =  objOut.LabLocDr.%Id()
		Set LocCode = objOut.LabLocDr.BTCode
		Set LocDesc = objOut.LabLocDr.BTDesc
		Set LocDesc2 = objOut.LabLocDr.BTDesc2
		Set LocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	
	For xIndi=1:1:2{
		If (xIndi=1){
			//输出第一种菌信息
			If (BacID'=""){
				Set Bacteria = ""
				Set xBactMapID = ""
				For {
					Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
					Quit:xBactMapID="" 
						
					Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
					Continue:'$Isobject(objMap)
					Set Bacteria = objMap.BTBacteria
				}
				Continue:Bacteria=""
				Set Result = Bacteria
				
				Set MRBID="",MRBCode="",MRBDesc=""
				Set ObjRuleMRB = objOut.RuleMRBDr
				If ($IsObject(ObjRuleMRB)){
					Set MRBID   = ObjRuleMRB.%Id()
					Set MRBDesc = ObjRuleMRB.BTDesc
					Set MRBCode = ObjRuleMRB.BTCode
				}
				Continue:MRBDesc="" //过滤出多重耐药菌
				
				// 同一种菌满足两种多耐
				Set MRBID2="",MRBCode2="",MRBDesc2=""
				
				Set ResultID = ""  //检验结果ID
				Set (LabRepID,LabWardID,LabWardCode,LabWardDesc,InfTypeCode,IsByHand) = ""	
				If $IsObject(objOut.LabWardDr){
					Set LabWardID =  objOut.LabWardDr.%Id()
					Set LabWardCode = objOut.LabWardDr.BTCode
					Set LabWardDesc = objOut.LabWardDr.BTDesc
					Set LabWardDesc2 = objOut.LabWardDr.BTDesc2
					Set LabWardDesc = $s(LabWardDesc2'="":LabWardDesc2,1:LabWardDesc)
				}
				Continue:LabWardID=""
				Set LabRepID = xID_"||"_BacID
				Set INFMBRID=""
				Set objInf=##class(DHCHAI.IR.INFMBR).GetObjByOutRepBact(xID,BacID)		     
				If $IsObject(objInf){
					Set INFMBRID =objInf.%Id()
				}
				Set InfTypeCode = objOut.LabMakeInfType   //感染类型
				Set InfTypeID="",InfTypeDesc=""
				Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfTypeCode)
			    If $IsObject(objDic) {
				    Set InfTypeID 	= objDic.%Id()
				    Set InfTypeDesc = objDic.BTDesc		
				}
				Set Data = $lb(ind,Result,Specimen,Bacteria,ResultID,MRBID,MRBCode,MRBDesc,ActDate,ActTime,RepDate,RepTime,LabWardID,LabWardDesc,"","","","")
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}Else{
			// 输出第二种菌相关信息
			Set BacID="",BacCode="",BacDesc=""
			Set ObjBacteria = objOut.BacteriaDr2
			If ($IsObject(ObjBacteria)){
				Set BacID   = ObjBacteria.%Id()
				Set BacCode = ObjBacteria.BTBacCode
				Set BacDesc = ObjBacteria.BTBacDesc
			}
			Continue:BacID=""
			Set Bacteria = ""
			Set xBactMapID = ""
			For {
				Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
				Quit:xBactMapID="" 
					
				Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
				Continue:'$Isobject(objMap)
				Set Bacteria = objMap.BTBacteria
			}
			Continue:Bacteria=""
			Set Result = Bacteria
			
			Set MRBID="",MRBCode="",MRBDesc=""
			Set ObjRuleMRB = objOut.RuleMRBDr2
			If ($IsObject(ObjRuleMRB)){
				Set MRBID   = ObjRuleMRB.%Id()
				Set MRBDesc = ObjRuleMRB.BTDesc
				Set MRBCode = ObjRuleMRB.BTCode
			}
			Continue:MRBDesc="" //过滤出多重耐药菌
			Set ResultID = ""  //检验结果ID
			Set (LabRepID,LabWardID,LabWardCode,LabWardDesc,InfTypeCode,IsByHand) = ""	
			If $IsObject(objOut.LabWardDr){
				Set LabWardID =  objOut.LabWardDr.%Id()
				Set LabWardCode = objOut.LabWardDr.BTCode
				Set LabWardDesc = objOut.LabWardDr.BTDesc
				Set LabWardDesc2 = objOut.LabWardDr.BTDesc2
				Set LabWardDesc = $s(LabWardDesc2'="":LabWardDesc2,1:LabWardDesc)
			}
			Continue:LabWardID=""
			Set LabRepID = xID_"||"_BacID
			Set INFMBRID=""
			Set objInf=##class(DHCHAI.IR.INFMBR).GetObjByOutRepBact(xID,BacID)		     
			If $IsObject(objInf){
				Set INFMBRID =objInf.%Id()
			}
			Set InfTypeCode = objOut.LabMakeInfType   //感染类型
			Set InfTypeID="",InfTypeDesc=""
			Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfTypeCode)
		    If $IsObject(objDic) {
			    Set InfTypeID 	= objDic.%Id()
			    Set InfTypeDesc = objDic.BTDesc		
			}
			
			Set Data = $lb(ind,Result,Specimen,Bacteria,ResultID,MRBID,MRBCode,MRBDesc,ActDate,ActTime,RepDate,RepTime,LabWardID,LabWardDesc,"","","","")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	
		}
	}
	Quit 1
}

ClassMethod QryBactDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBactDetailExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBactDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBactDetailExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2018-01-17
/// Description:  查询病原体结果(包含敏感)
/// Table：       DHCHAI.IR.CCResult
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CtlMRBSrv","QryBactResult","1","1","2022-08-31","2022-08-31","","","","","","")
Query QryBactResult(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aInfID As %String, aBactID As %String, aMRBID As %String, aSpecID As %String, aWardID As %String = "", aRepTypeID As %String = "") As %Query(ROWSPEC = "ID:%String,AdmID:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmBed:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,LocID:%String,LocCode:%String,LocDesc:%String,ActDate:%String,ActTime:%String,RepDate:%String,RepTime:%String,Specimen:%String,SpeID:%String,SpeCode:%String,SpeDesc:%String,Bacteria:%String,BacID:%String,BacCode:%String,BacDesc:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,ResultID:%String,LabRepID:%String,InfTypeID:%String,InfTypeCode:%String,InfTypeDesc:%String,INFMBRID:%String,MRBID2:%String,MRBCode2:%String,MRBDesc2:%String,LabWardID:%String,LabWardCode:%String,LabWardDesc:%String,DrugSen:%String,MRBOutLabType:%String") [ SqlProc ]
{
}

ClassMethod QryBactResultExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aInfID As %String, aBactID As %String, aMRBID As %String, aSpecID As %String, aWardID As %String = "", aRepTypeID As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aDateType="" $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set aRepTypeCode=""
    If (aRepTypeID'=""){
    	Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(aRepTypeID)
		Set:'$Isobject(objDic) aRepTypeCode = objDic.BTCode
    }
    //送检日期
    If aDateType=1{
	    If ((aRepTypeCode=3)||(aRepTypeCode="")){
		    Set xItemID=""
			For {
				Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID))
				Quit:xItemID=""
				
				Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
				Continue:'$IsObject(objItem)
				Set ItemCode=objItem.CCCode
				Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")
				
				Set xDate=aDateFrom-1  //fixbug:489631 不能查询到当天的数据
				For {
					Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate))
					Quit:xDate=""
					Quit:(xDate>aDateTo)
					
					Set xID=""
					For {
						Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemActDate",xItemID,xDate,xID))
						Quit:xID=""
						
						Do BuildBactData
					}
				}
			}
	    }
		//增加外院携带的多耐信息 
		For xDate=aDateFrom:1:aDateTo {
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.OutLabReportI("IndexSubmissDate",xDate,xID))
				Quit:xID=""
				
				Do BuildOutMRB2Data
			}
		}
	} Else { //报告日期
		If ((aRepTypeCode=3)||(aRepTypeCode="")){
			Set xItemID=""
			For {
				Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID))
				Quit:xItemID=""
				
				Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
				Continue:'$IsObject(objItem)
				Set ItemCode=objItem.CCCode
				Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")
				
				Set xDate=aDateFrom-1
				For {
					Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate))
					Quit:xDate=""
					Quit:(xDate>aDateTo)
					
					Set xID=""
					For {
						Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemRepDate",xItemID,xDate,xID))
						Quit:xID=""
						
						Do BuildBactData
					}
				}
			}
		}
		//增加外院携带的多耐信息 
		For xDate=aDateFrom:1:aDateTo {
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.OutLabReportI("IndexLabAuthDate",xDate,xID))
				Quit:xID=""
				
				Do BuildOutMRB2Data
			}
		}
	}
	Quit $$$OK
BuildBactData
	Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
	Quit:'$Isobject(objResult)
	Quit:objResult.CCIsActive'=1
	Set IsAbFlag=objResult.CCIsAbFlag
	//Quit:IsAbFlag'=1             //过滤非耐药菌
	
	Set MRBID="",MRBCode="",MRBDesc=""
	If $IsObject(objResult.CCMRBTpDr) {
		Set MRBID=objResult.CCMRBTpDr.%Id()
		Set MRBDesc = objResult.CCMRBTpDr.BTDesc
		Set MRBCode = objResult.CCMRBTpDr.BTCode
	}
	// 同一种菌满足两种多耐
	Set MRBID2="",MRBCode2="",MRBDesc2=""
	If $IsObject(objResult.CCMRBTp2Dr) {
		
		Set MRBID2=objResult.CCMRBTp2Dr.%Id()
		Set MRBDesc2 = objResult.CCMRBTp2Dr.BTDesc
		Set MRBCode2 = objResult.CCMRBTp2Dr.BTCode
	}
	Quit:(aMRBID'="")&&((aMRBID'=MRBID)&&(aMRBID'=MRBID2))
	
	Set AdmID  = objResult.CCEpisodeDr.%Id()
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(AdmID)
	Quit:'$Isobject(objAdm)
	Set EpisodeID = objAdm.PAEpisodeIDx
	Set PatientID = objAdm.PAPatientIDx
	Set PapmiNo   = objAdm.PAPapmiNo
	Set MrNo      = objAdm.PAMrNo
	Set PatName   = objAdm.PAPatName
	Set Sex       = objAdm.PASex
	Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
	Set AdmDate   = objAdm.PAAdmDate
	Set AdmTime   = objAdm.PAAdmTime
	Set Age       =  objAdm.PAAge
	Set DischDate = objAdm.PADischDate
	Set DischTime = objAdm.PADischTime
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set:DischTime'="" DischTime=$zt(DischTime,1)	
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objAdm.PAAdmBedDr){
		Set AdmBedDr=objAdm.PAAdmBedDr.%Id()
		Set AdmBed=objAdm.PAAdmBedDr.BTDesc
	}
	Set objAdmLoc = objAdm.PAAdmLocDr
	Set AdmLocID="", AdmLocDesc=""    //就诊科室
	If $Isobject(objAdmLoc) {
		Set AdmLocID = objAdmLoc.%Id()
		Set AdmLocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc2 = objAdmLoc.BTDesc2
		Set AdmLocDesc = $s(AdmLocDesc2'="":AdmLocDesc2,1:AdmLocDesc)
	}
	Set objAdmWard = objAdm.PAAdmWardDr
	Set AdmWardID="",AdmWardDesc=""   //就诊病区
	If $Isobject(objAdmWard) {
		Set AdmWardID  = objAdmWard.%Id()
		Set AdmWardDesc = objAdmWard.BTDesc
		Set AdmWardDesc2 = objAdmWard.BTDesc2
		Set AdmWardDesc = $s(AdmWardDesc2'="":AdmWardDesc2,1:AdmWardDesc)
		/*If $IsObject(objAdmWard.BTHospDr){
			Set HospID=objAdmWard.BTHospDr.%Id()			
			Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  	//医院过滤	
		}*/
	}
	Quit:(aLocID'="")&&(aLocID'=AdmWardID)
   	
   	//过滤院区-->aHospIDs(按送检/报告科室进行过滤院区)
	Set ActDate	=objResult.CCActDate	//送检日期		
	Set ActTime	=objResult.CCActTime	//送检时间
	Set RepDate =objResult.CCRepDate	//报告日期
	Set RepTime =objResult.CCRepTime	//报告时间
	If (aDateType=1){	//送检科室
		Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,ActDate,ActTime)
		Set ActLocID = $p(TransInfo,"^",1)
		Quit:ActLocID=""
		
		Set ActLocData  = $g(^DHCHAI.BT.LocationD(ActLocID))
		Set HospID = $li(ActLocData,8)
	}					
	else{				//报告科室
		Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,RepDate,RepTime)
		Set RepLocID = $p(TransInfo,"^",1)
		Quit:RepLocID=""
		
  		Set RepLocData  = $g(^DHCHAI.BT.LocationD(RepLocID))
		Set HospID = $li(RepLocData,8)
	}
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospID)<1) 	//医院过滤
   	
	Set LocID="", LocCode="", LocDesc=""
	If $IsObject(objResult.CCActLocDr){
		Set LocID =  objResult.CCActLocDr.%Id()
		Set LocCode = objResult.CCActLocDr.BTCode
		Set LocDesc = objResult.CCActLocDr.BTDesc
		Set LocDesc2 = objResult.CCActLocDr.BTDesc2
		Set LocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	
	Set Result   = objResult.CCResult
	Set ActDate  = objResult.CCActDate
	Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set ActTime  = objResult.CCActTime
	Set:ActTime'="" ActTime=$zt(ActTime,1)
	Set RepDate  = objResult.CCRepDate
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set RepTime  = objResult.CCRepTime 
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	Set SCode    = objResult.CCSCode      //子系统代码
	Set Specimen = objResult.CCSpecimen   //原始标本名称
	Set SpeID="",SpeCode="",SpeDesc=""
	Set objSpe=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
	If $IsObject(objSpe) {
		If $IsObject(objSpe.BTMapItemDr){
			Set SpeID=objSpe.BTMapItemDr.%Id()
			Set SpeCode=objSpe.BTMapItemDr.BTSpecCode
			Set SpeDesc=objSpe.BTMapItemDr.BTSpecDesc
		}
	}
	Quit:(aSpecID'="")&&(SpeID'=aSpecID)
	
	Set Bacteria = objResult.CCBacteria   //原始细菌名称
	Quit:Bacteria=""
	
	Set BacID="",BacCode="",BacDesc=""
	Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	If $IsObject(objBactMap){
		Quit:objBactMap.BTIsActive'=1  //菌是否有效
		If $IsObject(objBactMap.BTMapItemDr){
			Set BacID=objBactMap.BTMapItemDr.%Id()
			Set BacCode=objBactMap.BTMapItemDr.BTBacCode
			Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
		}
	}
	Quit:(aBactID'="")&&(BacID'=aBactID)
	
	//一份送检标本，检出多条菌，对应多条LabVisitRepResult和CCResult，但LabVisitReport唯一
	Set ResultID = $p(objResult.CCParams,"=",2)  //检验结果ID
	Set (LabRepID,LabWardID,LabWardCode,LabWardDesc,InfTypeCode) = ""
	Set objLabRes= ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResultID)
	If $IsObject(objLabRes) {
		Set InfTypeCode = objLabRes.LabMakeInfType
		Set LabRepID=objLabRes.LabReportDr.%Id()
		Set objLabRep=##class(DHCHAI.DP.LabVisitReport).GetObjById(LabRepID)
		If $IsObject(objLabRep.LabVisitNumberDr) {
			Set VisitNumberID=objLabRep.LabVisitNumberDr.%Id()
			Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(VisitNumberID)
			If $IsObject(objVisitNumber.LabWardDr) {
				Set LabWardID=objVisitNumber.LabWardDr.%Id()
				Set LabWardCode=objVisitNumber.LabWardDr.BTCode
				Set LabWardDesc=objVisitNumber.LabWardDr.BTDesc
				Set LabWardDesc2=objVisitNumber.LabWardDr.BTDesc2
				Set LabWardTypeDr=objVisitNumber.LabWardDr.BTTypeDr
				Set LabWardDesc = $s(LabWardDesc2'="":LabWardDesc2,1:LabWardDesc)
				
			}
		}
	}
	Quit:(aWardID'="")&&(LabWardID'=aWardID)			
	Set INFMBRID=""
	Set objInf=##class(DHCHAI.IR.INFMBR).GetObjByRepBact(LabRepID,BacID)		     
	If $IsObject(objInf){
		Set INFMBRID =objInf.%Id()
	}
	Set InfTypeID="",InfTypeDesc=""
	Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfTypeCode)
    If $IsObject(objDic) {
	    Set InfTypeID 	= objDic.%Id()
	    Set InfTypeDesc = objDic.BTDesc		
	}
	Quit:(aInfID'="")&&(InfTypeID'=aInfID)
 	Set DrugSen="药敏结果"
 	//多语言处理
 	Set DrugSen = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.mrb.ctlbactresult.csp",DrugSen)
    Set AdmLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmLocDesc,"User.CTLoc")
    Set AdmWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmWardDesc,"User.CTLoc")
    Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
    Set BacDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTBacDesc",BacDesc,"DHCHAI.DP.LabBacteria")       //细菌名称			
    Set SpeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",SpeDesc,"DHCHAI.DP.LabSpecimen")  
    Set MRBDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc,"DHCHAI.IR.CRuleMRB") 
    Set MRBDesc2=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc2,"DHCHAI.IR.CRuleMRB") 
    Set InfTypeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfTypeDesc,"DHCHAI.BT.Dictionary")
    Set LabWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LabWardDesc,"User.CTLoc")
    Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")  //性别
	Set:Age["岁" Age=$Replace(Age,"岁",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","岁"))  //年龄
	Set:Age["月" Age=$Replace(Age,"月",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","月"))
	Set:Age["天" Age=$Replace(Age,"天",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","天"))
	Set AdmBed=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",AdmBed,"DHCHAI.BT.PACBed")
	Set MRBOutLabType = "本院检出"
	Set MRBOutLabType=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBOutLabType,"DHCHAI.BT.Dictionary")
	
	Set Data = $lb(xID,AdmID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime,LocID,LocCode,LocDesc,ActDate,ActTime,RepDate,RepTime,Specimen,SpeID,SpeCode,SpeDesc,Bacteria,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,ResultID,LabRepID,InfTypeID,InfTypeCode,InfTypeDesc,INFMBRID,MRBID2,MRBCode2,MRBDesc2,LabWardID,LabWardCode,LabWardDesc,DrugSen,MRBOutLabType)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit 1
BuildOutMRB2Data
	Set objOut=##class(DHCHAI.IR.OutLabReport).GetObjById(xID)
	Quit:'$IsObject(objOut)
	Set LabIsActive = +objOut.LabIsActive
	Quit:(LabIsActive'=1)
	Set objAdm = objOut.LabEpisodeDr
	Quit:'$IsObject(objAdm)
	Set AdmID  = objAdm.%Id()
	Set IsAbFlag=1   //异常标志
	
	Set EpisodeID = objAdm.PAEpisodeIDx
	Set PatientID = objAdm.PAPatientIDx
	Set PapmiNo   = objAdm.PAPapmiNo
	Set MrNo      = objAdm.PAMrNo
	Set PatName   = objAdm.PAPatName
	Set Sex       = objAdm.PASex
	Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
	Set AdmDate   = objAdm.PAAdmDate
	Set AdmTime   = objAdm.PAAdmTime
	Set Age       =  objAdm.PAAge
	Set DischDate = objAdm.PADischDate
	Set DischTime = objAdm.PADischTime
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set:DischTime'="" DischTime=$zt(DischTime,1)	
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objAdm.PAAdmBedDr){
		Set AdmBedDr=objAdm.PAAdmBedDr.%Id()
		Set AdmBed=objAdm.PAAdmBedDr.BTDesc
	}
	Set objAdmLoc = objAdm.PAAdmLocDr
	Set AdmLocID="", AdmLocDesc=""    //就诊科室
	If $Isobject(objAdmLoc) {
		Set AdmLocID = objAdmLoc.%Id()
		Set AdmLocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc2 = objAdmLoc.BTDesc2
		Set AdmLocDesc = $s(AdmLocDesc2'="":AdmLocDesc2,1:AdmLocDesc)
	}
	Set objAdmWard = objAdm.PAAdmWardDr
	Set AdmWardID="",AdmWardDesc=""   //就诊病区
	If $Isobject(objAdmWard) {
		Set AdmWardID  = objAdmWard.%Id()
		Set AdmWardDesc = objAdmWard.BTDesc
		Set AdmWardDesc2 = objAdmWard.BTDesc2
		Set AdmWardDesc = $s(AdmWardDesc2'="":AdmWardDesc2,1:AdmWardDesc)
		If $IsObject(objAdmWard.BTHospDr){
			Set HospID=objAdmWard.BTHospDr.%Id()			
			Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  	//医院过滤	
		}
	}
	Quit:(aLocID'="")&&((aLocID'=AdmWardID)&(aLocID'=AdmLocID))  //允许增加科室入参查询
	Set ActDate  = objOut.SubmissDate
	Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set ActTime  = "1"
	Set:ActTime'="" ActTime=$zt(ActTime,1)
	Set RepDate  = objOut.LabAuthDate
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set RepTime  = "1"
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	
	Set BTTestSet="",BTTestSetID=""
	Set ObjTestSet = objOut.TestSetDr
	If ($IsObject(ObjTestSet)){
		Set BTTestSetID = ObjTestSet.%Id()
		Set BTTestSet   = ObjTestSet.BTTestSet
	}
	Set SpeID="",SpeCode="",SpeDesc=""
	Set ObjSpec = objOut.SpecimenDr
	If ($IsObject(ObjSpec)){
		Set SpeID   = ObjSpec.%Id()
		Set SpeCode = ObjSpec.BTSpecCode
		Set SpeDesc = ObjSpec.BTSpecDesc
	}
	Quit:(aSpecID'="")&&(SpeID'=aSpecID)
	Set Specimen = SpeDesc
	Set MRBOutLabType="外院携带"
	Set MRBOutLabTypeID = ##class(DHCHAI.BT.Dictionary).GetIDByDesc("MRBOutLabType",MRBOutLabType)
	Quit:(aRepTypeID'="")&&(MRBOutLabTypeID'=aRepTypeID)
	Set BacID="",BacCode="",BacDesc=""
	Set ObjBacteria = objOut.BacteriaDr
	If ($IsObject(ObjBacteria)){
		Set BacID   = ObjBacteria.%Id()
		Set BacCode = ObjBacteria.BTBacCode
		Set BacDesc = ObjBacteria.BTBacDesc
	}
	Set LocID="", LocCode="", LocDesc=""
	If $IsObject(objOut.LabLocDr){
		Set LocID =  objOut.LabLocDr.%Id()
		Set LocCode = objOut.LabLocDr.BTCode
		Set LocDesc = objOut.LabLocDr.BTDesc
		Set LocDesc2 = objOut.LabLocDr.BTDesc2
		Set LocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	
	For xIndi=1:1:2{
		If (xIndi=1){
			//输出第一种菌信息
			If (BacID'=""){
				Set Bacteria = ""
				Set xBactMapID = ""
				For {
					Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
					Quit:xBactMapID="" 
						
					Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
					Continue:'$Isobject(objMap)
					Set Bacteria = objMap.BTBacteria
				}
				Continue:Bacteria=""
				Continue:(aBactID'="")&&(BacID'=aBactID)
				Set Result = Bacteria
				
				Set MRBID="",MRBCode="",MRBDesc=""
				Set ObjRuleMRB = objOut.RuleMRBDr
				If ($IsObject(ObjRuleMRB)){
					Set MRBID   = ObjRuleMRB.%Id()
					Set MRBDesc = ObjRuleMRB.BTDesc
					Set MRBCode = ObjRuleMRB.BTCode
				}
				//Continue:MRBDesc="" //过滤出多重耐药菌
				Continue:(aMRBID'="")&&(aMRBID'=MRBID)
				// 同一种菌满足两种多耐
				Set MRBID2="",MRBCode2="",MRBDesc2=""
				
				Set ResultID = ""  //检验结果ID
				Set (LabRepID,LabWardID,LabWardCode,LabWardDesc,InfTypeCode,IsByHand) = ""	
				If $IsObject(objOut.LabWardDr){
					Set LabWardID =  objOut.LabWardDr.%Id()
					Set LabWardCode = objOut.LabWardDr.BTCode
					Set LabWardDesc = objOut.LabWardDr.BTDesc
					Set LabWardDesc2 = objOut.LabWardDr.BTDesc2
					Set LabWardDesc = $s(LabWardDesc2'="":LabWardDesc2,1:LabWardDesc)
				}
				Continue:LabWardID=""
				Continue:(aWardID'="")&&(LabWardID'=aWardID)
				
				Set LabRepID = xID_"||"_BacID
				Set INFMBRID=""
				Set objInf=##class(DHCHAI.IR.INFMBR).GetObjByOutRepBact(xID,BacID)		     
				If $IsObject(objInf){
					Set INFMBRID =objInf.%Id()
				}
				Set InfTypeCode = objOut.LabMakeInfType   //感染类型
				Set InfTypeID="",InfTypeDesc=""
				Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfTypeCode)
			    If $IsObject(objDic) {
				    Set InfTypeID 	= objDic.%Id()
				    Set InfTypeDesc = objDic.BTDesc		
				}
				Continue:(aInfID'="")&&((","_aInfID_",")'[(","_InfTypeID_","))
				Set DrugSen="药敏结果"
				
				Set Data = $lb(xID,AdmID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime,LocID,LocCode,LocDesc,ActDate,ActTime,RepDate,RepTime,Specimen,SpeID,SpeCode,SpeDesc,Bacteria,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,ResultID,LabRepID,InfTypeID,InfTypeCode,InfTypeDesc,INFMBRID,MRBID2,MRBCode2,MRBDesc2,LabWardID,LabWardCode,LabWardDesc,DrugSen,MRBOutLabType)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}Else{
			// 输出第二种菌相关信息
			Set BacID="",BacCode="",BacDesc=""
			Set ObjBacteria = objOut.BacteriaDr2
			If ($IsObject(ObjBacteria)){
				Set BacID   = ObjBacteria.%Id()
				Set BacCode = ObjBacteria.BTBacCode
				Set BacDesc = ObjBacteria.BTBacDesc
			}
			Continue:BacID=""
			Set Bacteria = ""
			Set xBactMapID = ""
			For {
				Set xBactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexMapItemDr",BacID,xBactMapID))
				Quit:xBactMapID="" 
					
				Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xBactMapID)
				Continue:'$Isobject(objMap)
				Set Bacteria = objMap.BTBacteria
			}
			Continue:Bacteria=""
			Continue:(aBactID'="")&&(BacID'=aBactID)
			Set Result = Bacteria
			
			Set MRBID="",MRBCode="",MRBDesc=""
			Set ObjRuleMRB = objOut.RuleMRBDr2
			If ($IsObject(ObjRuleMRB)){
				Set MRBID   = ObjRuleMRB.%Id()
				Set MRBDesc = ObjRuleMRB.BTDesc
				Set MRBCode = ObjRuleMRB.BTCode
			}
			//Continue:MRBDesc="" //过滤出多重耐药菌
			Continue:(aMRBID'="")&&(aMRBID'=MRBID)
			Set ResultID = ""  //检验结果ID
			Set (LabRepID,LabWardID,LabWardCode,LabWardDesc,InfTypeCode,IsByHand) = ""	
			If $IsObject(objOut.LabWardDr){
				Set LabWardID =  objOut.LabWardDr.%Id()
				Set LabWardCode = objOut.LabWardDr.BTCode
				Set LabWardDesc = objOut.LabWardDr.BTDesc
				Set LabWardDesc2 = objOut.LabWardDr.BTDesc2
				Set LabWardDesc = $s(LabWardDesc2'="":LabWardDesc2,1:LabWardDesc)
			}
			Continue:LabWardID=""
			Continue:(aWardID'="")&&(LabWardID'=aWardID)
			Set LabRepID = xID_"||"_BacID
			Set INFMBRID=""
			Set objInf=##class(DHCHAI.IR.INFMBR).GetObjByOutRepBact(xID,BacID)		     
			If $IsObject(objInf){
				Set INFMBRID =objInf.%Id()
			}
			Set InfTypeCode = objOut.LabMakeInfType   //感染类型
			Set InfTypeID="",InfTypeDesc=""
			Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfTypeCode)
		    If $IsObject(objDic) {
			    Set InfTypeID 	= objDic.%Id()
			    Set InfTypeDesc = objDic.BTDesc		
			}
			Continue:(aInfID'="")&&((","_aInfID_",")'[(","_InfTypeID_","))
			Set DrugSen="药敏结果"
			
			Set Data = $lb(xID,AdmID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime,LocID,LocCode,LocDesc,ActDate,ActTime,RepDate,RepTime,Specimen,SpeID,SpeCode,SpeDesc,Bacteria,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,ResultID,LabRepID,InfTypeID,InfTypeCode,InfTypeDesc,INFMBRID,MRBID2,MRBCode2,MRBDesc2,LabWardID,LabWardCode,LabWardDesc,DrugSen,MRBOutLabType)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit 1
}

ClassMethod QryBactResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBactResultExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBactResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBactResultExecute ]
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
/// CreatDate：   2018-03-01
/// Description:  发送多耐信息到临床
/// Table：       DHCHAI.IR.CCMessage
/// Input：       各属性列表 ^分隔
/// 1 EpisodeDr 2 CSMsgType 3 SendUserID 4 Msg 
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IRS.CtlMRBSrv).SendHISMRBMsg("123^MBRMsgCode^23^检出多重耐药","")
ClassMethod SendHISMRBMsg(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set EpisodeDr    = $p(aInputStr,aSeparete,1)
	Set MsgType      = $p(aInputStr,aSeparete,2)
	Set SendUserDr   = $p(aInputStr,aSeparete,3)
	Set Msg          = $p(aInputStr,aSeparete,4)
	Set ResultID     = $p(aInputStr,aSeparete,5)
	Quit:(EpisodeDr="")||(MsgType="")||(SendUserDr="")||(Msg="") return
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objEpisode) -1 
	
	Set MsgCode=##class(DHCHAI.BT.Config).GetValByCode(MsgType)
	Quit:MsgCode="" -2

	Set objUser=##class(DHCHAI.BT.SysUser).GetObjById(SendUserDr)
	Quit:'$IsObject(objUser) -3
	
	Set EpisodeID = $p(objEpisode.PAEpisodeIDx,"||",2)  //his下id
	//获取SOP干预消息 add by zhoubo 2019-04-28
	Set MessageInfo = ##class("DHCHAI.IRS.CtlMRBSrv").GetContentByKeys("多重耐药菌感染预防","多重耐药菌")
	Set Message = "患者检出多耐菌："_$p($p(Msg,",",1),":",2)_"。"_MessageInfo
	Set otherInfoJson="{""linkParam"":""EpisodeDr="_EpisodeDr_"&ResultID="_ResultID_"""}"
	Set return = ##class(DHCHAI.IO.FromHisSrv).SendMsg(Message,MsgCode,$p(objUser.BTXCode,"||",2),EpisodeID,"",otherInfoJson)
	// 多耐发送的消息存储到消息表里面
	Set ID = ""
	Set CSEpisodeDr  = EpisodeDr
	Set CSMsgType    = "3"           // 1院感、2临床、3多耐
	Set CSMsgDate    = ""              // 日期
	Set CSMsgTime    = ""              // 时间
	Set CSMsgUserDr  = SendUserDr
	Set CSMsgLocDr   = ""
	Set CSMessage    = Message
	Set CSIsRead     = "0"
	Set CSReadDate   = ""
	Set CSReadTime   = ""
	Set CSReadUserDr = SendUserDr
	Set InputStr = ID
	Set InputStr = InputStr_"^"_CSEpisodeDr
	Set InputStr = InputStr_"^"_CSMsgType
	Set InputStr = InputStr_"^"_CSMsgDate
	Set InputStr = InputStr_"^"_CSMsgTime
	Set InputStr = InputStr_"^"_CSMsgUserDr
	Set InputStr = InputStr_"^"_CSMsgLocDr
	Set InputStr = InputStr_"^"_CSMessage
	Set InputStr = InputStr_"^"_CSIsRead
	Set InputStr = InputStr_"^"_CSReadDate
	Set InputStr = InputStr_"^"_CSReadTime
	Set InputStr = InputStr_"^"_CSReadUserDr
	Set flg = ##class(DHCHAI.IR.CCMessage).Update(InputStr,"^")	
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-04-01
/// Description:  判断患者有无多重耐药菌结果
/// Table：       DHCHAI.IR.CCResult
/// Input：       
/// Return：      返回ID
/// w ##Class(DHCHAI.IRS.CtlMRBSrv).IsExistMRB("1")
ClassMethod IsExistMRB(aEpisodeDr As %String) As %String
{
	New (aEpisodeDr)
	Set return=0
	Quit:(aEpisodeDr="") return

    Set IsExist =0 
	Set xItemID=""
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",aEpisodeDr,xItemID))
		Quit:xItemID=""
		Quit:IsExist=1
		
		Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Set ItemCode=objItem.CCCode
		Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")
		
		Set xBacteria=""
		For {
			Set xBacteria=$o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",aEpisodeDr,xItemID,xBacteria))
			Quit:xBacteria=""
			Quit:IsExist=1
			
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",aEpisodeDr,xItemID,xBacteria,xID))
				Quit:xID=""
				
				Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$Isobject(objResult)
				Continue:'$Isobject(objResult.CCMRBTpDr)
				Continue:objResult.CCIsActive'=1
				Set IsAbFlag=objResult.CCIsAbFlag   //异常标志
				Continue:IsAbFlag'=1 
                Set IsExist =1
                Quit
			}
		}
	}
	//添加外院携带多耐菌
	If (IsExist'=1){
		Set LabRepID=$o(^DHCHAI.IR.OutLabReportI("IndexEpisodeDr",aEpisodeDr,""))
		Set:LabRepID>0 IsExist=1
	}
	Set return =IsExist
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-04-01
/// Description:  判断监控记录是否首次送检检出多耐(具体菌)
/// Table：       DHCHAI.IR.CCResult
/// Input：       
/// Return：      返回ID
/// w ##Class(DHCHAI.IRS.CtlMRBSrv).IsFirstSend("737","9572","1","2")
ClassMethod IsFirstSend(aEpisodeDr As %String, aResultID As %String, aUnSpec As %String = "", aUnBact As %String = "") As %String
{
	New (aEpisodeDr,aResultID,aUnSpec,aUnBact)
	Set return=0
	Quit:(aEpisodeDr="")||(aResultID="") return
    
    Kill arrResult
    Set objRes = ##class(DHCHAI.IR.CCResult).GetObjById(aResultID)
	Quit:'$Isobject(objRes) return
	Quit:'$Isobject(objRes.CCMRBTpDr) return
	Quit:objRes.CCIsActive'=1 return
	Quit:objRes.CCIsAbFlag'=1 return
	Set ActDate = objRes.CCActDate
	Set ActTime = objRes.CCActTime
	Set MRBTpDr = objRes.CCMRBTpDr.%Id()   //多耐类型
	Set MRBTpDr2=""
	If $Isobject(objRes.CCMRBTp2Dr) {
		Set MRBTpDr2 = objRes.CCMRBTp2Dr.%Id()   //多耐类型
	}
	Set Bacteria = objRes.CCBacteria
	Set Specimen = objRes.CCSpecimen
   
	Set xItemID=""
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID))
		Quit:xItemID=""
		
		Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Set ItemCode=objItem.CCCode
		Continue:(ItemCode'="LAB-Bacteria")&(ItemCode'="LAB-TestAb")
		Set xActDate=0
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate))
			Quit:xActDate=""
			Quit:xActDate>ActDate
			
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate,xID))
				Quit:xID=""
				
				Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$Isobject(objResult)
				Continue:'$Isobject(objResult.CCMRBTpDr)
				Continue:objResult.CCIsActive'=1
				Set IsAbFlag=objResult.CCIsAbFlag   //异常标志
				Continue:IsAbFlag'=1 
		        
		        Set BactDesc = objResult.CCBacteria
				Set SpecDesc = objResult.CCSpecimen
		        Continue:(aUnSpec=2)&&(Specimen'=SpecDesc)    //同种标本（除本条记录外）
				Continue:(aUnBact=2)&&(Bacteria'=BactDesc)    //同种细菌（除本条记录外）
				Set SendTime = objResult.CCActTime
				Set arrResult(xActDate,SendTime,xID)="" 

			}
		}
	}

    Set IsIsFirst =""
	Set xActDate=""
	For {
		Set xActDate=$o(arrResult(xActDate))
		Quit:xActDate=""
		Quit:IsIsFirst'=""
		
		Set xActTime=""
		For {
			Set xActTime=$o(arrResult(xActDate,xActTime))   //同一日送检分先后顺序
			Quit:xActTime=""
			Quit:IsIsFirst'=""
			
			Set xResultID=""
			For {
				Set xResultID=$o(arrResult(xActDate,xActTime,xResultID))
				Quit:xResultID=""
				Quit:IsIsFirst'=""
				
				Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
				Continue:'$Isobject(objResult)
				Continue:'$Isobject(objResult.CCMRBTpDr)
				Set MRBTypeDr=objResult.CCMRBTpDr.%Id()
				Set MRBTypeDr2=""
				If $Isobject(objResult.CCMRBTp2Dr) {
					Set MRBTypeDr2 = objResult.CCMRBTp2Dr.%Id()   //多耐类型
				}
				
				If (aResultID=xResultID) {        //送检日期索引查找到的记录与当前记录一致，检出多耐细菌是首次检出
					Set IsIsFirst =1      
				}Else {                     //查找到的记录与当前记录不一致					
		            If (aUnBact=1) {  //按多耐判断
						If (ActDate=xActDate){  //同一天的送检，检出多耐一样				
							If (MRBTpDr=MRBTypeDr)||(MRBTpDr=MRBTypeDr2) {
								Set:ActTime>xActTime IsIsFirst =0 
								Set:ActTime<=xActTime IsIsFirst =1   
							}ElseIf ((MRBTpDr2=MRBTypeDr)||((MRBTpDr2'="")&&(MRBTpDr2=MRBTypeDr2))) {
								Set:ActTime>xActTime IsIsFirst =0 
								Set:ActTime<=xActTime IsIsFirst =1   
							}Else {
								Continue
							}
						}Else {     //非同一天的送检，检出多耐一样
							If (MRBTpDr=MRBTypeDr)||(MRBTpDr=MRBTypeDr2) { //多耐类型一样，送检记录检出多耐不是首次检出
								Set IsIsFirst =0   
							}ElseIf ((MRBTpDr2=MRBTypeDr)||((MRBTpDr2'="")&&(MRBTpDr2=MRBTypeDr2))) {
								Set IsIsFirst =0   
							}Else {   //送检记录检出多耐与查询到的多耐类型不一致
								Continue
							}
						}
		            }Else {   //按细菌判断
			            If (ActDate=xActDate){  //同一天的送检，检出多耐细菌一样				
							Set:ActTime>xActTime IsIsFirst =0 
							Set:ActTime<=xActTime IsIsFirst =1   
						}Else {   
							Set IsIsFirst =0 
						}	
		            }			
				}	
			}
		}
	}
		
	Set return =IsIsFirst
	
	Kill arrResult
	Quit return
}

}
