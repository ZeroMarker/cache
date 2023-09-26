/// 名称: DHCHAI.AMC.CSRuleExpISrv
/// 描述: 疑似病例筛查规则解析---抗感染治疗
/// 编写者：zhufei
/// 编写日期: 2019-06-11
Class DHCHAI.AMC.CSRuleExpISrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.AMC.CSRuleExpISrv).GetResult()
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
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," I",xRuleDr))
		Quit:xRuleDr=""
		
		Set objRule=##class(DHCHAI.IR.CRuleInfSuRule).GetObjById(xRuleDr)
		Continue:'$IsObject(objRule)
		Continue:objRule.BTIsActive'=1
		Continue:'$IsObject(objRule.BTItmScreenDr)
		Set ItmScreenDr=objRule.BTItmScreenDr.%Id()
		Set objScreen = ##class(DHCHAI.IR.CCItmScreen).GetObjById(ItmScreenDr)
		Continue:'$IsObject(objScreen)
		Set ItmScreenDesc=objScreen.CCDesc
		Set ItmScreenDesc2=objScreen.CCDesc2
		Set:ItmScreenDesc2'="" ItmScreenDesc=ItmScreenDesc2
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"启用抗菌药物")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"启用抗菌药物")=ArgStr
		}
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"抗菌药物等级升级")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"抗菌药物等级升级")=ArgStr
		}
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"抗菌药物使用升级")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"抗菌药物使用升级")=ArgStr
		}
		Continue:$o(arrRuleExp(xRuleDr,""))=""
		
		Set arrRuleExp(xRuleDr)=$lb(xRuleDr,ItmScreenDr,ItmScreenDesc)
	}
	Quit:$o(arrRuleExp(0))="" return
	
	//OE-AntiUse	医嘱-抗菌用药
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("OE-AntiUse")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	//抗菌用药结果
	Kill arrResult
	Set AdmDate=""
	Set xActDate=0
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aDateTo
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:'$IsObject(obj.CCKeyWordDr)
			Continue:obj.CCIsActive'=1
			Continue:obj.CCIsAbFlag'=1
			
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCActDate
			Set ActTime=obj.CCActTime
			Set RepDate=obj.CCRepDate
			Continue:ActDate=""
			
			//抗菌用药
			Set AntiDesc=obj.CCAntiDesc
			Continue:AntiDesc=""
			Set objMap=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc(SCode,AntiDesc)
			Continue:'$IsObject(objMap)
			Continue:'$IsObject(objMap.BTMapItemDr)
			Set AntiDesc=objMap.BTMapItemDr.BTName
			Continue:AntiDesc=""
			
			//抗菌用药等级
			Set AntiGrade=obj.CCAntiGrade
			Continue:AntiGrade=""
			Set objMap=##class(DHCHAI.DP.PhraseMap).GetObjByCode(SCode,"DrgPoison",AntiGrade)
			If $IsObject(objMap){
				Set AntiGrade=objMap.BTCode
			}
			If AntiGrade="KSS1" {
				Set AntiGrade=1
			} ElseIf AntiGrade="KSS2" {
				Set AntiGrade=2
			} ElseIf AntiGrade="KSS3" {
				Set AntiGrade=3
			} Else {
				Set AntiGrade=0
			}
			
			//入院日期
			Set AdmDate=obj.CCEpisodeDr.PAAdmDate
			Set Priority="临时医嘱",XDate=""
			Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(obj.CCObjectID)
			If $IsObject(objOrdItem){
				Set Priority=objOrdItem.OEPriority
				Set XDate=objOrdItem.OEXDate
				Set XTime=objOrdItem.OEXTime
			}
			If Priority["长期" {
				Set:XDate="" XDate=+$h
				For tActDate=ActDate:1:XDate {
					Set arrResult(tActDate,"RST",AntiGrade,AntiDesc,xID)=$lb(xID,AntiDesc,AntiGrade,ActDate,ActTime)
				}
			} Else {
				Set arrResult(ActDate,"RST",AntiGrade,AntiDesc,xID)=$lb(xID,AntiDesc,AntiGrade,ActDate,ActTime)
			}
			//判断是否入院48小时后项目
			Set flg=##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst(obj)
			Set arrResult(ActDate,"48H",+flg)=""
		}
	}
	Quit:$o(arrResult(0))="" return
	Quit:AdmDate="" return
	
	Set IsCheck48=##class(DHCHAI.BT.Config).GetValByCode("IRScreenIsCheck48")  //0：不计入，1：计入

	//感染规则判断及结果输出
	Set xRuleDr=0
	For {
		Set xRuleDr=$o(arrRuleExp(xRuleDr))
		Quit:xRuleDr=""
		
		Set tRuleInfo=$g(arrRuleExp(xRuleDr))
		Set ItmScreenDr=$lg(tRuleInfo,2)
		Set ItmScreenDesc=$lg(tRuleInfo,3)
		
		//启用抗菌药物、抗菌药物等级升级、抗菌药物使用升级
		Set AntiRuleType=$o(arrRuleExp(xRuleDr,""))
		Continue:AntiRuleType=""
		Set tRuleArgStr=$g(arrRuleExp(xRuleDr,AntiRuleType))
		Continue:tRuleArgStr=""
		Set AbDay=+$p(tRuleArgStr,"^",4)   //限定天数(启用抗菌药物天数设定)
		Set:AbDay<1 AbDay=3
		
		//术前日期
		Set OperPrevDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperPrevDateList(aEpisodeDr,1)
		//术后日期
		Set OperNextDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeDr,3)
	    //Set OperPrevDateList="",OperNextDateList=""
		Set AntiGrade=""
		Set AntiFirstTime=""
		Set AntiCnt=0
		Set xActDate=0
		For {
			Set xActDate=$o(arrResult(xActDate))
			Quit:xActDate=""
			Continue:xActDate<aDateFrom  
			Continue:xActDate>aDateTo
			//add 20200119 晚一天判断抗菌药物，解决术前一天预防用药问题 
		    Quit:(xActDate+1)>=+$h 
			
			Set IsI48Hour=$d(arrResult(xActDate,"48H",0))
			Continue:(IsCheck48=0)&&(IsI48Hour=1)  //检查是否入院48小时项目
			
			//术前n天排除
			Continue:(OperPrevDateList'="")&($listfind(OperPrevDateList,xActDate)>0)
			//术后n天排除
			Continue:(OperNextDateList'="")&($listfind(OperNextDateList,xActDate)>0)
			
			If AntiRuleType="启用抗菌药物" {
				Set:AntiFirstTime="" AntiFirstTime=xActDate
				Quit:xActDate<(AdmDate+AbDay)  //入院3天内使用抗菌用药，直接退出循环
				Quit:AntiFirstTime'=xActDate  //表示不是使用第1天
			} ElseIf AntiRuleType="抗菌药物等级升级" {
				Set AntiGrade2=$o(arrResult(xActDate,"RST",""),-1)
				Continue:AntiGrade2=""
				Continue:AntiGrade2<2
				Set AntiGrade1=0
				For indDay=1:1:AbDay {
					Set tAntiGrade=$o(arrResult(xActDate-indDay,"RST",""),-1)
					Continue:tAntiGrade=""
					Continue:tAntiGrade<=AntiGrade1
					Set AntiGrade1=tAntiGrade
				}
				Continue:AntiGrade1<1
				Continue:AntiGrade2<=AntiGrade1

			} ElseIf AntiRuleType="抗菌药物使用升级" {   //AbDay为3，当前日期为10号，用10日使用抗菌药物种类与7、8、9种类比较,都大于的情况下为使用升级
			    Continue:(xActDate)<(AdmDate+AbDay)
				Set AntiList1="",AntiList2=""
				Continue:AbDay<1
				//当前使用抗菌药物种类
				Set xAntiGrade=""
				For {
					Set xAntiGrade=$o(arrResult(xActDate,"RST",xAntiGrade))
					Quit:xAntiGrade=""
					Set xAntiDesc=""
					For {
						Set xAntiDesc=$o(arrResult(xActDate,"RST",xAntiGrade,xAntiDesc))
						Quit:xAntiDesc=""
						Continue:$listfind(AntiList2,xAntiDesc)>0
						Set AntiList2=AntiList2_$lb(xAntiDesc)
					}
				}
				Continue:$ll(AntiList2)<=1
					
				//3日前使用抗菌药物种类
				Set Count=0
				For indDay=1:1:AbDay { 
				    Set AntiList1=""  
					Set xAntiGrade=""
					For {
						Set xAntiGrade=$o(arrResult(xActDate-indDay,"RST",xAntiGrade))
						Quit:xAntiGrade=""
						Set xAntiDesc=""
						For {
							Set xAntiDesc=$o(arrResult(xActDate-indDay,"RST",xAntiGrade,xAntiDesc))
							Quit:xAntiDesc=""
							Continue:$listfind(AntiList1,xAntiDesc)>0
							Set AntiList1=AntiList1_$lb(xAntiDesc)
						}
					}
					Continue:$ll(AntiList1)<1
					Continue:$ll(AntiList2)<=$ll(AntiList1)
					Set Count=Count+1
				}
				Continue:Count<AbDay
			}
			
			//触发次数、触发日期、多耐结果
			Set InfSuPosDr=""       //推荐感染部位
			Set InfSuPosDr2=""  	//疑似感染部位
			Set ResultCnt=0
			Set ResultDate=xActDate
			Set xAntiGrade=""
			For {
				Set xAntiGrade=$o(arrResult(xActDate,"RST",xAntiGrade))
				Quit:xAntiGrade=""
				Set xAntiDesc=""
				For {
					Set xAntiDesc=$o(arrResult(xActDate,"RST",xAntiGrade,xAntiDesc))
					Quit:xAntiDesc=""
					
					Set xID=0
					For {
						Set xID=$o(arrResult(xActDate,"RST",xAntiGrade,xAntiDesc,xID))
						Quit:xID=""
						
						Set tResultInfo=$g(arrResult(xActDate,"RST",xAntiGrade,xAntiDesc,xID))
						Continue:tResultInfo=""
						Set ResultCnt=ResultCnt+1
					}
				}
			}
			Continue:ResultCnt<1
			
			//合并检查阳性症状或体征
			Set tSymptomInfo=##class(DHCHAI.AMC.CSResultSrv).CheckSymptom(aEpisodeDr,xActDate,InfSuPosDr,InfSuPosDr2,xRuleDr)
			Set SyResult=+$p(tSymptomInfo,"^",1)
			Set SyInfPosDr=$p(tSymptomInfo,"^",2)
			Continue:(SyInfPosDr="")&&(SyResult<1)  //未确认感染部位，又不满足组合条件
			Set SySuPosDr=$p(tSymptomInfo,"^",3)
			Set InfSuDate=$p(tSymptomInfo,"^",4)
			Set:InfSuDate="" InfSuDate=xActDate
			Set ObsAbDay=$p(tSymptomInfo,"^",5)
			Set EmrSuKey=$p(tSymptomInfo,"^",6)
			
			//疑似关键词
			Set InfSuKeys="抗菌用药"
			Set:ObsAbDay'="" InfSuKeys=InfSuKeys_"#"_"发热"
			Set:EmrSuKey'="" InfSuKeys=InfSuKeys_"#"_EmrSuKey
			
			//显示结果
			Set ResultNote=ItmScreenDesc
			
			Set ItmScreenTxt=""
			
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
			Set obj.CSInfSuRuleDr  = xRuleDr         //规则
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
