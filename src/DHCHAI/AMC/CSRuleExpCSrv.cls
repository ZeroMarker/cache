/// 名称: DHCHAI.AMC.CSRuleExpCSrv
/// 描述: 疑似病例筛查规则解析---血培养检出菌
/// 编写者：zhufei
/// 编写日期: 2019-06-11
Class DHCHAI.AMC.CSRuleExpCSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.AMC.CSRuleExpCSrv).GetResult()
ClassMethod GetResult(aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String, ByRef %ArrayResult As %ArrayOfDataTypes) As %String
{
	New (aEpisodeDr,aDateFrom,aDateTo,%ArrayResult)
	Set return=0
	Quit:(aEpisodeDr="")||(aDateFrom="")||(aDateTo="") return
	Quit:'$IsObject(%ArrayResult) return
	
	//规则表达式
	Kill arrRuleExp
	Set xRuleDr=0
	For {
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," C",xRuleDr))
		Quit:xRuleDr=""
		
		Set objRule=##class(DHCHAI.IR.CRuleInfSuRule).GetObjById(xRuleDr)
		Continue:'$IsObject(objRule)
		Continue:objRule.BTIsActive'=1
		Continue:'$IsObject(objRule.BTItmScreenDr)
		Set ItmScreenDr=objRule.BTItmScreenDr.%Id()
		Set ItmScreenDesc=objRule.BTItmScreenDr.CCDesc
		Set ItmScreenDesc2=objRule.BTItmScreenDr.CCDesc2
		Set:ItmScreenDesc2'="" ItmScreenDesc=ItmScreenDesc2
		Set RuleNote = objRule.BTRuleNote
		Set arrRuleExp(xRuleDr)=$lb(xRuleDr,ItmScreenDr,RuleNote)
	}
	//感染规则筛查参数
	Set RuleDr=$o(arrRuleExp(0))
	Quit:RuleDr="" return
	Set tRuleInfo=$g(arrRuleExp(RuleDr))
	Set ItmScreenDr=$lg(tRuleInfo,2)
	Set ItmScreenDesc=$lg(tRuleInfo,3)
	
	//血流感染疑似诊断
	Set SuPosDr=$o(^DHCHAI.BT.InfSuPosI("IdxofBTDiagnos","血流感染",0))
	Quit:SuPosDr="" return
	Set objSuPos=##class(DHCHAI.BT.InfSuPos).GetObjById(SuPosDr)
	Quit:'$IsObject(objSuPos) return
	Set SuPosDesc=objSuPos.BTDiagnos
	//常见皮肤污染菌筛查参数
	Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(RuleDr,"常见皮肤污染菌")
	Quit:ArgStr="" return
	Set AbCnt=+$p(ArgStr,"^",5)   //限定次数
	Set:AbCnt<1 AbCnt=2
	Set AbDay=+$p(ArgStr,"^",4)   //限定天数
	Set:AbDay<1 AbDay=7
	
	//LAB-Bacteria	检验-检出菌
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-Bacteria")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	//检出菌结果
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
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:obj.CCIsActive'=1
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCActDate
			Set ActTime=obj.CCActTime
			Set RepDate=obj.CCRepDate
			Continue:ActDate=""
			Continue:ActDate<(aDateFrom-AbDay)
			Continue:ActDate>(aDateTo+AbDay)
			
			//细菌
			Set Bacteria=obj.CCBacteria
			Continue:Bacteria=""
			Set objBactMap=##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
			If $IsObject(objBactMap){
				Continue:objBactMap.BTIsActive'=1
				If $IsObject(objBactMap.BTMapItemDr){
					Set Bacteria=objBactMap.BTMapItemDr.BTBacDesc
				}
			}
			Continue:Bacteria=""
			Set Bacteria=$tr(Bacteria,",","，")
			//标本
			Set Specimen=obj.CCSpecimen
			Continue:Specimen=""
			Continue:Specimen'["血"   //只要血培养
			Set objSpecMap=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
			Continue:'$IsObject(objSpecMap)
			Continue:objSpecMap.BTIsActive'=1
			Continue:'$IsObject(objSpecMap.BTMapItemDr)
			Continue:objSpecMap.BTMapItemDr.BTIsActive'=1
			Set Specimen=objSpecMap.BTMapItemDr.BTSpecDesc
			
			//多耐
			Set MRBTypeID="",MRBTypeDesc=""
			If $IsObject(obj.CCMRBTpDr) {
				Set MRBTypeID=obj.CCMRBTpDr.%Id()
				Set MRBTypeDesc=obj.CCMRBTpDr.BTDesc
			}
			
			//入院日期
			Set AdmDate=obj.CCEpisodeDr.PAAdmDate
			
			Set arrResult(Bacteria,"RST",ActDate,xID)=$lb(xID,Specimen,Bacteria,ActDate,ActTime,MRBTypeID,MRBTypeDesc)
			
			//判断是否入院48小时后项目
			Set flg=##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst(obj)
			Set arrResult(Bacteria,"48H",ActDate,+flg)=""
		}
	}
	Quit:$o(arrResult(0))="" return
	Quit:AdmDate="" return
	
	Set IsCheck48=##class(DHCHAI.BT.Config).GetValByCode("IRScreenIsCheck48")  //0：不计入，1：计入

	//感染规则判断及结果输出
	Set xBacteria=""
	For {
		Set xBacteria=$o(arrResult(xBacteria))
		Quit:xBacteria=""
		
		Set InfSuPosDr=""       //推荐感染部位
		Set InfSuPosDr2=SuPosDr	//疑似感染部位
		
		//检查部位定值菌、致病菌，获取感染部位及疑似部位
		//血流感染借用定值菌维护常见皮肤污染菌
		Set tSuPosInfo=##class(DHCHAI.AMC.CSResultSrv).CheckPosBact(InfSuPosDr2,xBacteria)
		Set InfSuPosDr=$p(tSuPosInfo,"^",1)    //致病菌->推荐感染部位
		Set InfSuPosDr2=$p(tSuPosInfo,"^",2)   //检出菌->疑似感染部位
		Set InfSuPosDr3=$p(tSuPosInfo,"^",3)   //定值菌->排除感染部位
		
		Set xActDate=0
		For {
			Set xActDate=$o(arrResult(xBacteria,"RST",xActDate))
			Quit:xActDate=""
			Continue:xActDate<aDateFrom
			Continue:xActDate>aDateTo
			
			Set IsI48Hour=$d(arrResult(xBacteria,"48H",xActDate,0))
			//Continue:(IsCheck48=0)&&(IsI48Hour=1)  //检查是否入院48小时项目
			
			If InfSuPosDr3'="" {
				//常见皮肤污染菌，必须两次检出同种菌才有效
				Set ActSpecList="",IsInfFlag=0
				Set yActDate=xActDate-1
				For {
					Set yActDate=$o(arrResult(xBacteria,"RST",yActDate))
					Quit:yActDate=""
					Quit:yActDate>(xActDate+AbDay)
					Quit:IsInfFlag>0
					
					Set xID=0
					For {
						Set xID=$o(arrResult(xBacteria,"RST",yActDate,xID))
						Quit:xID=""
						Quit:IsInfFlag>0
						
						Set tResultInfo=$g(arrResult(xBacteria,"RST",xActDate,xID))
						Set Specimen=$lg(tResultInfo,2)
						Set tActTime=$lg(tResultInfo,5)
						Continue:$listfind(ActSpecList,Specimen_"/"_yActDate_"/"_tActTime)>0
						Set ActSpecList=ActSpecList_$lb(Specimen_"/"_yActDate_"/"_tActTime)
						Continue:$ll(ActSpecList)<AbCnt
						Set IsInfFlag=1
					}
				}
				Continue:IsInfFlag<1
				Set InfSuPosDr=InfSuPosDr3
			} Else {
				//血培养检出非常见皮肤污染菌，同无菌部位标本检出菌
			}
			
			//合并检查阳性症状或体征
			Set tSymptomInfo=##class(DHCHAI.AMC.CSResultSrv).CheckSymptom(aEpisodeDr,xActDate,InfSuPosDr,InfSuPosDr2,RuleDr)
			Set SyResult=+$p(tSymptomInfo,"^",1)
			Set SyInfPosDr=$p(tSymptomInfo,"^",2)
			//Continue:(SyInfPosDr="")&&(SyResult<1)  //未确认感染部位，又不满足组合条件
			Set SySuPosDr=$p(tSymptomInfo,"^",3)
			Set InfSuDate=$p(tSymptomInfo,"^",4)
			Set:InfSuDate="" InfSuDate=xActDate
			Set ObsAbDay=$p(tSymptomInfo,"^",5)
			Set EmrSuKey=$p(tSymptomInfo,"^",6)
			
			//触发次数、触发日期、多耐结果
			Set ResultCnt=0
			Set ResultDate=xActDate
			Set Specimens=""
			Set MRBTypes=""
			Set xID=0
			For {
				Set xID=$o(arrResult(xBacteria,"RST",xActDate,xID))
				Quit:xID=""
				
				Set tResultInfo=$g(arrResult(xBacteria,"RST",xActDate,xID))
				Set Specimen=$lg(tResultInfo,2)
				Set MRBTypeID=$lg(tResultInfo,6)
				Set MRBTypeDesc=$lg(tResultInfo,7)
				
				Set ResultCnt=ResultCnt+1
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
			}
			Continue:ResultCnt<1
			
			//标本
			Set SpecimenStr=##class(DHCHAI.Utils.CommonSrv).ListToString(Specimens,"#")
			
			//多耐
			Set MRBTypeStr=##class(DHCHAI.Utils.CommonSrv).ListToString(MRBTypes,"#")
			
			//疑似关键词
			Set InfSuKeys=SpecimenStr
			Set:ObsAbDay'="" InfSuKeys=InfSuKeys_"#"_"发热"
			Set:EmrSuKey'="" InfSuKeys=InfSuKeys_"#"_EmrSuKey
			
			//显示结果
			Set ResultNote=ItmScreenDesc_" ("_xBacteria_")"
			Set:SpecimenStr'="" ResultNote=ResultNote_" ("_$tr(SpecimenStr,"#","、")_")"
			Set:MRBTypeStr'="" ResultNote=ResultNote_" (多耐)"
			
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

}
