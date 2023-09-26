/// 名称: DHCHAI.IRC.CSRuleExpZSrv
/// 描述: 疑似病例筛查规则解析---血流感染CLABSI
/// 编写者：zhoubo
/// 编写日期: 2023-04-20
Class DHCHAI.IRC.CSRuleExpZSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.IRC.CSRuleExpZSrv).GetResult()
ClassMethod GetResult(aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String, ByRef %ArrayResult As %ArrayOfDataTypes) As %String
{
	New (aEpisodeDr,aDateFrom,aDateTo,%ArrayResult)
	Set return=0
	Quit:(aEpisodeDr="")||(aDateFrom="")||(aDateTo="") return
	Quit:'$IsObject(%ArrayResult) return
	// 前置条件：留置中央血管导管>2天:置管第三天到拔管后一天期间血培养阳性
	// 满足：标准一：1，至少一次血培养检出病原体（非常见的皮肤共生菌） 2，与其他部位感染无关
	// 标准二：1,2次及2次以上血培养检出常见皮肤共生菌 2患者至少有一种症状：发热、寒颤、低血压、呼吸暂停、心跳过缓 3，与其他部位感染无关
	// 上述症状发生在首次采集阳性的前后三天
	//规则表达式
	Kill arrRuleExp
	Set xRuleDr=0
	For {
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," Z",xRuleDr))
		Quit:xRuleDr=""
		Set RuleData=$g(^DHCHAI.IR.CRuleInfSuRuleD(xRuleDr))
		Continue:RuleData=""
		Continue:$lg(RuleData,7)'=1
		
		Set ItmScreenDr = $lg(RuleData,3)
		continue:ItmScreenDr=""
		Set ItmScreenData=$g(^DHCHAI.IR.CCItmScreenD(ItmScreenDr))
		Continue:ItmScreenData=""
		Set ItmScreenDesc=$lg(ItmScreenData,2)
		Set ItmScreenDesc2=$lg(ItmScreenData,3)
		Set:ItmScreenDesc2'="" ItmScreenDesc=ItmScreenDesc2
		Set RuleNote = $lg(RuleData,6)
		Set arrRuleExp(xRuleDr)=$lb(xRuleDr,ItmScreenDr,RuleNote)
	}
	//感染规则筛查参数
	Set RuleDr=$o(arrRuleExp(0))
	Quit:RuleDr="" return
	Set tRuleInfo=$g(arrRuleExp(RuleDr))
	Set ItmScreenDr=$lg(tRuleInfo,2)
	Set ItmScreenDesc=$lg(tRuleInfo,3)
	
	//LAB-Bacteria	检验-检出菌
	Set ItemDr=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","LAB-Bacteria",0))
	Quit:ItemDr="" return
	// 检出菌结果
	Kill arrResult
	Set AdmDate=""
	Set xBacteria=""
	For {
		Set xBacteria=$o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",aEpisodeDr,ItemDr,xBacteria))
		Quit:xBacteria=""
		Continue:$l(xBacteria)<2 //表示菌为空
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",aEpisodeDr,ItemDr,xBacteria,xID))
			Quit:xID=""
			
			Set RstData=$g(^DHCHAI.IR.CCResultD(xID))
			Continue:RstData=""
			Continue:$lg(RstData,14)'=1
			Set SCode=$lg(RstData,17)
			Set ActDate=$lg(RstData,8)
			Set ActTime=$lg(RstData,9)
			Set RepDate=$lg(RstData,11)
			Continue:ActDate=""
			Continue:ActDate<aDateFrom
			Continue:ActDate>aDateTo
			
			//判断日期是否在置管第三天到拔管后一天期间
			Set CheckFlag=..CheckDate(aEpisodeDr,ActDate)
			Continue:CheckFlag'=1
			//标本
			Set Specimen=$lg(RstData,22)
			Continue:Specimen=""
			Continue:Specimen'["血"
			Set Specimen=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Specimen)  //去掉特殊字符
			Set SpecMapDr=$o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",SCode,Specimen,0))
			Continue:SpecMapDr=""
			Set SpecMapData=$g(^DHCHAI.DP.LabSpecMapD(SpecMapDr))
			Continue:SpecMapData=""
			Set MapItemDr = $lg(SpecMapData,3)
			Continue:MapItemDr=""
			Set MapItemData=$g(^DHCHAI.DP.LabSpecimenD(MapItemDr))
			Continue:MapItemData=""
			Set Specimen = $lg(MapItemData,3)
			//细菌
			Set Bacteria=$lg(RstData,23)
			Continue:((Bacteria["微生物实验室")||(Bacteria["无菌生长")||(Bacteria["无真菌生长")||(Bacteria["样本")||(Bacteria["混丛")||(Bacteria["病人已出院")||(Bacteria["G-杆菌生长"))
			Continue:Bacteria=""
			Set IsSkinBact = "" //是否常见皮肤共生菌
			Set Bacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Bacteria)  //去掉特殊字符
			Set BacteriaDr=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",SCode,Bacteria,""))
			Continue:BacteriaDr=""
			Set BactMapData=$g(^DHCHAI.DP.LabBactMapD(BacteriaDr))
			Continue:BactMapData=""
			Set MapBacItemDr = $lg(BactMapData,3)
			Continue:MapBacItemDr=""
			Set BacteriaData=$g(^DHCHAI.DP.LabBacteriaD(MapBacItemDr))
			Continue:BacteriaData=""
			Set Bacteria = $lg(BacteriaData,3)
			Set IsSkinBact = $lg(BacteriaData,12)
			Continue:Bacteria=""
			Set Bacteria=$tr(Bacteria,",","，")
			Set tOtherPosBacts=""  // tOtherPosBacts=""：说明：与其他部位无关定义：获取本次血培养送检阳性的送检日期前14天至后三天内其它部位未检出与血培养同种的菌
			Set OStartDate=ActDate-14
			Set OEndDate=ActDate+3
			Set tOtherPosBacts = ..GetLabByEpisDate(aEpisodeDr,OStartDate,OEndDate,"0",Bacteria)
			Continue:tOtherPosBacts'=""  //送检日期之前14天至后三天内其它部位检出血培养同种菌
			//多耐
			Set MRBTypeID="",MRBTypeDesc=""
			Set arrResult(Bacteria,"RST",ActDate,xID)=$lb(xID,Specimen,Bacteria,ActDate,ActTime,MRBTypeID,MRBTypeDesc,IsSkinBact)
		}
	}
	Quit:$o(arrResult(0))="" return
	//感染规则判断及结果输出
	Set xBacteria=""
	For {
		Set xBacteria=$o(arrResult(xBacteria))
		Quit:xBacteria=""
		
		Set xActDate=0
		For {
			Set xActDate=$o(arrResult(xBacteria,"RST",xActDate))
			Quit:xActDate=""
			Continue:xActDate<aDateFrom
			Continue:xActDate>aDateTo
			
			//触发次数、触发日期、多耐结果
			Set InfSuPosDr=""       //推荐感染部位$lb()
			Set InfSuPosDr2=""  	//疑似感染部位$lb()
			Set ResultCnt=0
			Set SkinBactCnt=0 //皮肤共生菌细菌数
			Set BactCnt =0    //非皮肤共生菌细菌数
			Set ResultDate=xActDate
			Set Specimens=""
			Set MRBTypes=""
			Set xID=""
			For {
				Set xID=$o(arrResult(xBacteria,"RST",xActDate,xID))
				Quit:xID=""
				
				Set tResultInfo = $g(arrResult(xBacteria,"RST",xActDate,xID))
				Set MRBTypeID   = $lg(tResultInfo,6)
				Set MRBTypeDesc = $lg(tResultInfo,7)
				Set Specimen    = $lg(tResultInfo,2)   // add 20190822
				Set IsSkinBact  = $lg(tResultInfo,8)   // 常见的皮肤共生菌
				If MRBTypeDesc'="" {
					If $listfind(MRBTypes,MRBTypeDesc)<1 {
						Set MRBTypes=MRBTypes_$lb(MRBTypeDesc)
					}
				}
			
				If Specimen'="" {
					If $listfind(Specimens,Specimen)<1 {
						Set Specimens=Specimens_$lb(Specimen)
					}
				}
				//查找标本对应疑似感染部位
				Set InfPosList=""
				Set tSuPoss=##class(DHCHAI.IRC.CSResultSrv).GetPosBySpec(Specimen)
				If tSuPoss'="" {
					For indP=1:1:$ll(tSuPoss){
						Set tSuPosDr=$lg(tSuPoss,indP)
						Continue:tSuPosDr=""
			            
						//推荐诊断、入院诊断一致不计为感染 
						Set objSuPos=##class(DHCHAI.BT.InfSuPos).GetObjById(tSuPosDr)
						Continue:'$IsObject(objSuPos)
						Continue:'$IsObject(objSuPos.BTInfPosDr)
						Set InfPosCode=objSuPos.BTInfPosDr.BTCode
						Set DiagFlag=objSuPos.BTInfPosDr.BTDiagFlag
						Set InfPosID = objSuPos.BTInfPosDr.%Id()
						Set InfPos = objSuPos.BTInfPosDr.BTDesc
						Continue:InfPos'["血流感染"
						If (DiagFlag=1)&&(InfPos'="新生儿感染") {
							Set Code = $e(InfPosCode,1,2)
							Set objInf = ##class(DHCHAI.BT.InfPos).GetObjByCode(Code)
							Continue:'$IsObject(objInf)
							Set InfPosID = objInf.%Id()
							Set InfPos = objInf.BTDesc
						}
						Continue:$listfind(InfSuPosDr2,tSuPosDr)>0
						Set InfSuPosDr2=InfSuPosDr2_$lb(tSuPosDr)
					}
				}
				Continue:(tSuPoss'="")&&(InfSuPosDr2="")
				Set:IsSkinBact=1 SkinBactCnt=SkinBactCnt+1
				Set:IsSkinBact'=1 BactCnt=BactCnt+1
				Set ResultCnt=ResultCnt+1
			}
			Continue:ResultCnt<1
			Set InfSuPosDr2=##class(DHCHAI.Utils.CommonSrv).ListToString(InfSuPosDr2,"#")
			// 满足：标准一：1，大于等于1瓶的血培养出病原体（非常见的皮肤共生菌） 2，与其他部位感染无关
			// 标准二：1,大于等于2瓶血养养出匹配的常见皮肤共生菌 2患者至少有一种症状：发热、寒颤、低血压、呼吸暂停、心跳过缓 3，与其他部位感染无关
			//1：标准一  0001866468
			Set (SyResult,SyInfPosDr,SySuPosDr,InfSuDate,ObsAbDay,EmrSuKey)=""
			If (BactCnt>=1){
				
			}
			If (SkinBactCnt>=2){
				//合并检查阳性症状或体征
				Set tSymptomInfo=##class(DHCHAI.IRC.CSResultSrv).CheckSymptom(aEpisodeDr,xActDate,InfSuPosDr,InfSuPosDr2,RuleDr)
				Set SyResult=+$p(tSymptomInfo,"^",1)
				Set SyInfPosDr=$p(tSymptomInfo,"^",2)
				//Continue:(SyInfPosDr="")&&(SyResult<1)  //未确认感染部位，又不满足组合条件
				Set SySuPosDr=$p(tSymptomInfo,"^",3)
				Set InfSuDate=$p(tSymptomInfo,"^",4)
				Set ObsAbDay=$p(tSymptomInfo,"^",5)
				Set EmrSuKey=$p(tSymptomInfo,"^",6)
			}
			Continue:(BactCnt<1)&&(SkinBactCnt<2)
			Set:InfSuDate="" InfSuDate=xActDate
			
			//标本
			Set SpecimenStr=##class(DHCHAI.Utils.CommonSrv).ListToString(Specimens,"#")
			
			//多耐
			Set MRBTypeStr=##class(DHCHAI.Utils.CommonSrv).ListToString(MRBTypes,"#")
			
			//疑似关键词
			Set InfSuKeys=SpecimenStr
			Set:ObsAbDay'="" InfSuKeys=InfSuKeys_"#"_"发热"
			Set:EmrSuKey'="" InfSuKeys=InfSuKeys_"#"_EmrSuKey
			
			//显示结果
			Set ResultNote=ItmScreenDesc_"("_xBacteria_")"
			Set:SpecimenStr'="" ResultNote=ResultNote_"("_$tr(SpecimenStr,"#","、")_")"
			Set:MRBTypeStr'="" ResultNote=ResultNote_"(多耐)"
			
			Set ItmScreenTxt=xBacteria
			
			//如果确诊，以确诊感染部位为准；如果未确诊，以疑似感染部位为准
			Set:InfSuPosDr="" InfSuPosDr=InfSuPosDr2
			Set obj=##class(DHCHAI.IRC.CSRecord).GetObj(ItmScreenDr)
			Continue:'$IsObject(obj)
			Set obj.CSItmScreenTxt = ItmScreenTxt    //附加项目描述
			Set obj.CSResultNote   = ResultNote      //显示结果
			Set obj.CSResultDate   = ResultDate      //结果日期
			Set obj.CSResultCnt    = ResultCnt       //结果数量
			Set obj.CSInfSuKeys    = InfSuKeys       //疑似关键词
			Set obj.CSInfSuPosDr   = InfSuPosDr      //推荐感染部位
			Set obj.CSInfSuDate    = InfSuDate       //推荐感染日期
			Set obj.CSInfSuRuleDr  = RuleDr          //规则(多值#分隔)
			Set obj.CSSpecimen     = SpecimenStr     //标本(多值#分隔)
			Set obj.CSMRBType      = MRBTypeStr      //多耐(多值#分隔)
			Set obj.CSRstStatus    = 1               //结果状态(0触发疑似指标、1触发组合条件)
			
			Set ArrCnt=%ArrayResult.Count()
			Do %ArrayResult.SetAt(obj,ArrCnt+1)
		}
	}
	Kill arrResult
	Kill arrRuleExp
	
	Set return=%ArrayResult.Count()
	Quit return
}

/// 判断患者在该日期是否进行中心静脉插管
/// w ##class(DHCHAI.IRC.CSRuleExpZSrv).CheckDate("930418","2023-02-10")
ClassMethod CheckDate(aEpisodeDr As %String, aDate As %String) As %String
{
	New (aEpisodeDr,aDate)
	Set return = ""
	Quit:(aEpisodeDr="")||(aDate="") return
	
	Set:aDate["-" aDate=$zdh(aDate,3)
	Quit:(aEpisodeDr="")||(aDate="") return
	
	Set xOrdItemDesc = "" 
	For {
		Set xOrdItemDesc = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeDr,"HIS01",xOrdItemDesc))
		Quit:(xOrdItemDesc="")||(return=1)
		Set xUpdateDate =""
		For {
		Set xUpdateDate = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeDr,"HIS01",xOrdItemDesc,xUpdateDate))
			Quit:(xUpdateDate="")||(return=1)
			Set xOrdItemID ="" 
			For {
				Set xOrdItemID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeDr,"HIS01",xOrdItemDesc,xUpdateDate,xOrdItemID))
				Quit:(xOrdItemID="")||(return=1)
				Set OEOrdData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
				Continue:OEOrdData=""
				Set IsActive=$lg(OEOrdData,25)
				Continue:IsActive'=1
				//取的临床医嘱名称
				Set xMastMapID = $o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc","HIS01",xOrdItemDesc,""))	
				Continue:xMastMapID=""
				Set OEMapData=$g(^DHCHAI.DP.OEItmMastMapD(xMastMapID))
				Continue:OEMapData=""
				Set BTOEMapItemDr = $lg(OEMapData,3)
				Continue:BTOEMapItemDr=""
				Set OEMapItemData=$g(^DHCHAI.DP.OEItmMastD(BTOEMapItemDr))
				Continue:OEMapItemData=""
				Set BTOECatDr = $lg(OEMapItemData,4)
				Continue:BTOECatDr=""
				Set BTOECatData = $g(^DHCHAI.DP.OEItmCatD(BTOECatDr))
				Continue:BTOECatData=""
				Set BTCode = $lg(BTOECatData,2)
				Continue:(BTCode'["PICC")
				
				Set OeItemDesc =$lg(OEOrdData,4)
				Set EndDt=""
				Continue:$lg(OEOrdData,15)=""
				Set DtStart=$lg(OEOrdData,15)
				Set:DtStart'="" DtStart=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DtStart)
				Set DtEnd=+$h
				If ($lg(OEOrdData,17)'="")
				{
					Set DtEnd=$lg(OEOrdData,17)
					Set:DtEnd'="" DtEnd=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DtEnd)
				}
				Continue:aDate>(DtEnd+1)
				Continue:aDate<(DtStart+2)
				Set return =1
			}
		}
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2023-04-20
/// Description:  查询患者一段期间的送检情况
/// aBloodSpecFlg : 1：血标本   0：其它部位
/// aBloodBacts :血培养阳性细菌
/// w ##Class(DHCHAI.IRC.CSRuleExpZSrv).GetLabByEpisDate(889190,"2023-01-05","2023-01-05",1)
ClassMethod GetLabByEpisDate(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aBloodSpecFlg As %String = "0", aBloodBacts As %String = "") As %String
{
	New (aEpisodeID,aDateFrom,aDateTo,aBloodSpecFlg,aBloodBacts)
	Set return=""
	Quit:(aEpisodeID="")||(aDateFrom="")||(aDateTo="") return
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) return
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") return
 	Set Bacterias="",LabCollDates=""
 	Set BactCnt=0
	For xxDate=aDateFrom:1:aDateTo {
		Set xLabNumID=""
		For {
			Set xLabNumID=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDrCollDate",aEpisodeID," LIS01",xxDate,xLabNumID))
			Quit:xLabNumID=""
		    Set LabNumData = $g(^DHCHAI.DP.LabVisitNumberD(xLabNumID))
		    Continue:LabNumData=""
		    Set LabIsActive = $lg(LabNumData,18)
		  	Continue:LabIsActive'=1  
		  	
			Set LabCollDate  = $lg(LabNumData,8)      //采集日期
			Set LabCollTime  = $lg(LabNumData,9)      //采集时间
	
			Set LabRecDate=$lg(LabNumData,11)		//接收日期
			Set LabRecTime=$lg(LabNumData,12)
	
			Set LabCollDate=$s(LabCollDate'="":LabCollDate,1:LabRecDate)		//送检日期优先用采集日期
			Set LabCollTime=$s(LabCollTime'="":LabCollTime,1:LabRecTime)
			Set:LabCollDate'="" LabCollDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(LabCollDate)
			//标本过滤
			Set LabSpecimen = $lg(LabNumData,6)
			If (aBloodSpecFlg=1){
				Continue:LabSpecimen'["血"
			}Else{
				Continue:LabSpecimen["血"
			}
			Set xxTestSetDr=""
			For {
				Set xxTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xLabNumID,xxTestSetDr))
				Quit:xxTestSetDr=""
				
				//最新检验报告
				Set xxOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xLabNumID,xxTestSetDr,""),-1)
				
				Set xxReportDr=0
				For {
					Set xxReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xLabNumID,xxTestSetDr,xxOrder,xxReportDr))
					Quit:xxReportDr=""
					
					Set LabReportData = $g(^DHCHAI.DP.LabVisitReportD(xxReportDr))
		    		Continue:LabReportData=""
		    		Set LabIsActive = $lg(LabReportData,18)
					Continue:LabIsActive=0
					
					Set TestSetID=$lg(LabReportData,13)
					Continue:TestSetID=""
					Set TestSetData = $g(^DHCHAI.DP.LabVisitTestSetD(TestSetID))
					Continue:TestSetData=""
					Set TestSetDesc=$lg(TestSetData,3)
					Continue:TestSetDesc=""
					Set TestSetDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSetDesc)  //去掉特殊字符
					Continue:TestSetDesc=""
					Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet","LIS01",TestSetDesc,0))
					Continue:TestSetMapID=""
					Set TestMapData=$g(^DHCHAI.DP.LabTestSetMapD(TestSetMapID))
					Continue:TestMapData=""
					Continue:$lg(TestMapData,7)=0 
					Set BTMapItemDr=$lg(TestMapData,4)
					Continue:BTMapItemDr=""
					Set BTMapItemData=$g(^DHCHAI.DP.LabTestSetD(BTMapItemDr))
					Continue:BTMapItemData=""
					Continue:$lg(BTMapItemData,5)=0 
					Set BTCatDr = $lg(BTMapItemData,4)
					Continue:BTCatDr=""
					Set BTCatData = $g(^DHCHAI.DP.LabTestSetCatD(BTCatDr))
					Continue:BTCatData=""
					Set BTCatDesc = $lg(BTCatData,3)
					Continue:(BTCatDesc'="微生物送检")&&(TestSetDesc'["细菌涂片")
					Set xxRepRstDr=""
					For {
						Set xxRepRstDr=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xxReportDr,xxRepRstDr))
						Quit:(xxRepRstDr="")
						Set RepRstData=$g(^DHCHAI.DP.LabVisitRepResultD(xxRepRstDr))
						Continue:RepRstData=""
						
						Set Bacteria = $lg(RepRstData,6)
						Continue:Bacteria=""
						Continue:Bacteria["报阳"
						Continue:(Bacteria["无细菌生长")
						Continue:(Bacteria["体外药敏显示")
						Continue:(Bacteria["微生物实验室")
						Set aBacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Bacteria)  //去掉特殊字符
						Continue:aBacteria=""
						Set BactMapID=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria","LIS01",Bacteria,""))
						If (BactMapID'=""){
							Set BactMapData = $g(^DHCHAI.DP.LabBactMapD(BactMapID))
							continue:($lg(BactMapData,7)'=1)
							Set BTBactMapItemDr = $lg(BactMapData,3)
							If (BTBactMapItemDr'=""){
								Set BactMapItemData = $g(^DHCHAI.DP.LabBacteriaD(BTBactMapItemDr)) 
								Set:BactMapItemData'="" Bacteria=$lg(BactMapItemData,3)
							}
						}
						Set BactCnt=BactCnt+1
						If (aBloodSpecFlg=1){
							Set:LabCollDates'[$lg(LabNumData,8) LabCollDates=LabCollDates_","_$lg(LabNumData,8)
							If ((BactCnt#2)=0){
								Set Bacterias = Bacterias_","_Bacteria_"("_LabCollDate_")<br>"
							}Else{
								Set Bacterias = Bacterias_","_Bacteria_"("_LabCollDate_")"
							}
						}Else{
							Continue:(aBloodBacts'="")&&(aBloodBacts'[Bacteria)
							Set:LabCollDates'[$lg(LabNumData,8) LabCollDates=LabCollDates_","_$lg(LabNumData,8)
							If ((BactCnt#2)=0){
								Set Bacterias = Bacterias_","_Bacteria_"("_LabSpecimen_":"_LabCollDate_")<br>"
							}Else{
								Set Bacterias = Bacterias_","_Bacteria_"("_LabSpecimen_":"_LabCollDate_")"
							}
							
						}
						
					}
				}
			}
		}
	}
	Set:Bacterias'="" Bacterias=$e(Bacterias,2,$l(Bacterias))
	Set:LabCollDates'="" LabCollDates=$e(LabCollDates,2,$l(LabCollDates))
	Set:Bacterias'="" return=Bacterias_"|"_LabCollDates
	Quit return
}

}
