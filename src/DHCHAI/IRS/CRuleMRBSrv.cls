/// 名称: DHCHAI.IRS.CRuleMRBSrv
/// 描述: 多耐分类筛查相关服务
/// 编写者：zhufei
/// 编写日期: 2017-05-05
Class DHCHAI.IRS.CRuleMRBSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-04-19
/// Description:  根据多耐菌-隔离医嘱
/// Table：       DHCHAI.IR.CRuleMRBOEOrd
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleMRBSrv","QryMRBOEOrdByMRBID","1")
Query QryMRBOEOrdByMRBID(aMRBID As %String) As %Query(ROWSPEC = "ID:%String,BTOrdID:%String,BTOrdDesc:%String,OrdCatDesc:%String,BTMapItemDesc:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryMRBOEOrdByMRBIDExecute(ByRef qHandle As %Binary, aMRBID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aMRBID="" $$$OK
	
	Set xSubID =""
    For {
		Set xSubID = $o(^DHCHAI.IR.CRuleMRBD(aMRBID,"OEORD",xSubID))
		Quit:xSubID="" 
	
		Set ID=aMRBID_"||"_xSubID
		Set obj = ##class(DHCHAI.IR.CRuleMRBOEOrd).GetObjById(ID)
		Continue:'$Isobject(obj)
		
		Set BTOrdID="",BTMapItemDesc="",OrdCatDesc="",BTOrdDesc=""	   
		If $IsObject(obj.BTIsoOEOrdDr) {
			Set BTOrdID    = obj.BTIsoOEOrdDr.%Id()
			Set BTOrdDesc  = obj.BTIsoOEOrdDr.BTOrdDesc
			Set OrdCatDesc  = obj.BTIsoOEOrdDr.BTOrdCatDesc
			If $IsObject(obj.BTIsoOEOrdDr.BTMapItemDr) {
				Set BTMapItemDr=obj.BTIsoOEOrdDr.BTMapItemDr.%Id()
				Set BTMapItemCode=obj.BTIsoOEOrdDr.BTMapItemDr.BTCode
				Set BTMapItemDesc=obj.BTIsoOEOrdDr.BTMapItemDr.BTDesc					
				Set objMast=##class(DHCHAI.DP.OEItmMast).GetObjById(BTMapItemDr)
				If $IsObject(objMast.BTCatDr) {
					Set BTMapCatDr=objMast.BTCatDr.%Id()
					Set BTMapCatCode=objMast.BTCatDr.BTCode
					Set BTMapCatDesc=objMast.BTCatDr.BTDesc
				}
			}
		}
		Continue:BTMapItemDesc=""  // 未对照的不显示
		Set ActDate		= obj.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)    	
		Set ActTime		= obj.BTActTime 
		Set:ActTime'="" ActTime=$zt(ActTime,1)  
		
		Set ActUserDr = obj.BTActUserDr    	
		Set ActUserID="",ActUser="",ActUserDesc=""
		If $IsObject(obj.BTActUserDr) {
			Set ActUserID   = obj.BTActUserDr.%Id()
			Set ActUser     = obj.BTActUserDr.BTDesc
		}
				
		Set Data = $lb(ID,BTOrdID,BTOrdDesc,OrdCatDesc,BTMapItemDesc,ActDate,ActTime,ActUserID,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }
	    
	Quit $$$OK
}

ClassMethod QryMRBOEOrdByMRBIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBOEOrdByMRBIDExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMRBOEOrdByMRBIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBOEOrdByMRBIDExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2017-05-05
/// Description:  根据检验结果筛查多耐分类
/// Table：       DHCHAI.IR.CRuleMRB*、DHCHAI.DP.LabVisitRepResult、DHCHAI.DP.LabVisitRepRstSen
/// Input：       obj : 检验结果
///               aMapRstFormat : 结果类型
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CRuleMRBSrv).CheckMRBRule()
ClassMethod CheckMRBRule(obj As DHCHAI.DP.LabVisitRepResult) As %String
{
	New (obj)
	Set return=""
	Quit:'$IsObject(obj) return
	
	Set ResultID=obj.%Id()
	Set Bacteria=obj.LabResult
	Quit:Bacteria="" return
	Quit:'$IsObject(obj.LabReportDr) return
	Quit:'$IsObject(obj.LabReportDr.LabVisitNumberDr) return
	Set ReportID=obj.LabReportDr.%Id()
	Set SCode=obj.LabReportDr.LabVisitNumberDr.LabSCode
	Quit:SCode="" return
	
	Set objBactMap=##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	Quit:'$IsObject(objBactMap) return
	Quit:'$IsObject(objBactMap.BTMapItemDr) return
	Set MapBactID=objBactMap.BTMapItemDr.%Id()
	Quit:MapBactID="" return
	Set FlgNum=0 // 同一种细菌满足两种多耐规则(大肠(ESBL\CRE)、肺克(ESBL\CRE))
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.IR.CRuleMRBD(xID))
		Quit:((xID="")||(FlgNum=2))
		
		Set objMRB=##class(DHCHAI.IR.CRuleMRB).GetObjById(xID)
		Continue:'$IsObject(objMRB)
		Continue:objMRB.BTIsActive'=1
		Set MRBCode=objMRB.BTCode
		Set MRBDesc=objMRB.BTDesc
		Set IsRuleCheck=objMRB.BTIsRuleCheck
		Set IsAntiCheck=objMRB.BTIsAntiCheck
		Set AnitCatCnt=objMRB.BTAnitCatCnt
		Set AnitCatCnt=+AnitCatCnt
		Set AnitCatCnt2=objMRB.BTAnitCatCnt2
		Set AnitCatCnt2=+AnitCatCnt2
		Set IsKeyCheck=objMRB.BTIsKeyCheck
		Set IsIRstCheck = objMRB.BTIsIRstCheck
		Set IsResKeyCheck = objMRB.BTIsResKeyCheck
		Continue:(IsRuleCheck'=1)&(IsKeyCheck'=1)
		
		//MRB作为多耐的特殊代码，不检查菌种类
		If (MRBCode'="MRB")&&(MRBCode'="N1" ) {
			//检查是否多耐菌
			Continue:'$d(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact2",xID,MapBactID))
		}
		
		Set IsMDR=0,IsPDR=0
		If IsRuleCheck=1 {
			If ((MRBCode["ESBLs")||(MRBCode["P5")) {
				Set xSenID=0
				For {
					Set xSenID=$o(^DHCHAI.DP.LabVisitRepRstSenI("IndexLabResultDr",ResultID,xSenID))
					Quit:xSenID=""
					
					Set objSen=##class(DHCHAI.DP.LabVisitRepRstSen).GetObjById(xSenID)
					Continue:'$IsObject(objSen)
					Set AntiDesc=objSen.LabAntDesc
					Continue:AntiDesc=""
					Set TestSen=objSen.LabSensitivity
					Set IsInt=objSen.LabIsInt
					Continue:IsInt=1      //add 2021-03-23  天然耐药不做检查
					Set MapTestSen=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABTestRstSen",TestSen)
					Continue:MapTestSen'="R"
					Set objAntiMap=##class(DHCHAI.DP.LabAntiMap).GetObjByAntDesc(SCode,AntiDesc)
					Continue:'$IsObject(objAntiMap)
					Continue:'$IsObject(objAntiMap.BTMapItemDr)
					Set MapAntiID=objAntiMap.BTMapItemDr.%Id()
					Set MapAntiDesc=objAntiMap.BTMapItemDr.BTAntDesc
					Continue:MapAntiDesc'["ESBLs"
					Set IsMDR=1
					Quit //检出ESBLs Quit
				}
			} Else {
				//检查抗生素分类
				Set AntCatList=""
				Set xSenID=0
				For {
					Set xSenID=$o(^DHCHAI.DP.LabVisitRepRstSenI("IndexLabResultDr",ResultID,xSenID))
					Quit:xSenID=""
					
					Set objSen=##class(DHCHAI.DP.LabVisitRepRstSen).GetObjById(xSenID)
					Continue:'$IsObject(objSen)
					Set AntiDesc=objSen.LabAntDesc
					Continue:AntiDesc=""
					Set TestSen=objSen.LabSensitivity
					Set IsInt=objSen.LabIsInt
					Continue:IsInt=1      //add 2021-03-23  天然耐药不做检查
					Set MapTestSen=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABTestRstSen",TestSen)
					//update 20230210 中介/非敏感纳入耐药范畴
					//Continue:MapTestSen'="R"
					Continue:(IsIRstCheck'=1)&(MapTestSen'="R")   //只计算耐药
					Continue:(IsIRstCheck=1)&((MapTestSen'="R")&(MapTestSen'="I"))   //耐药包括：中介、耐药或非敏感,非敏感暂时不加入
					
					Set objAntiMap=##class(DHCHAI.DP.LabAntiMap).GetObjByAntDesc(SCode,AntiDesc)
					Continue:'$IsObject(objAntiMap)
					Continue:'$IsObject(objAntiMap.BTMapItemDr)
					If IsAntiCheck=1 {
						Set MapAntiID=objAntiMap.BTMapItemDr.%Id()
						Set MapAntiDesc=objAntiMap.BTMapItemDr.BTAntDesc
						Continue:'$d(^DHCHAI.IR.CRuleMRBI("ANT","IndexAnti",MapAntiID,xID))
						Continue:$listfind(AntCatList,MapAntiDesc)>0
						Set AntCatList=AntCatList_$lb(MapAntiDesc)
					} Else {
						Continue:'$IsObject(objAntiMap.BTMapItemDr.BTAntCatDr)
						Set MapAntCatID=objAntiMap.BTMapItemDr.BTAntCatDr.%Id()
						Set MapAntCatDesc=objAntiMap.BTMapItemDr.BTAntCatDr.BTDesc
						Continue:'$d(^DHCHAI.IR.CRuleMRBI("ANT","IndexAntiCat",MapAntCatID,xID))
						Continue:$listfind(AntCatList,MapAntCatDesc)>0
						Set AntCatList=AntCatList_$lb(MapAntCatDesc)
					}
					If (AnitCatCnt>0)&($listlength(AntCatList)>=AnitCatCnt) {
						Set IsMDR=1
					}
					If (AnitCatCnt2>AnitCatCnt)&($listlength(AntCatList)>=AnitCatCnt2) {
						Set IsPDR=1
					}
					Quit:IsPDR=1 //泛耐Quit
					Quit:(IsMDR=1)&(AnitCatCnt2<=AnitCatCnt) //多耐Quit
				}
			}
		}
		If (IsMDR>0){
			Set return=return_"#"_xID_"^"_MRBDesc_"^"_IsMDR_"^"_IsPDR
			Set FlgNum=FlgNum+1
		}
		Continue:IsMDR>0
		
		If IsKeyCheck=1 {
			//update 20230210  关键词检查增加耐药机制关键词区分
			//不启用耐药机制监测多耐细菌	
			Set MDRResult=obj.LabMDRResult
			Set MDRRes = obj.LabTextRes  //定性结果
			Set LabResNoes = obj.LabResNoes // 检验结果备注
			Set TestNote=MDRResult_","_MDRRes_"^"_LabResNoes
			
			Continue:(IsResKeyCheck=1)&($p(MDRResult,",",1)'=1)    //启用耐药机制监测多耐菌,无多耐菌标记不统计
			Set TestNote=$p(MDRResult,",",2)
			
			If TestNote'="" {  //耐药机制阳性结果
				Set TestNote=$zcvt(TestNote,"U")
				Set xKeyID=0
				For {
					Set xKeyID=$o(^DHCHAI.IR.CRuleMRBD(xID,"KEYS",xKeyID))
					Quit:xKeyID=""
					Set objKey=##class(DHCHAI.IR.CRuleMRBKeys).GetObjById(xID_"||"_xKeyID)
					Continue:'$IsObject(objKey)
					Set Keyword=objKey.BTKeyWord
					Continue:Keyword=""
					Set Keyword=$zcvt(Keyword,"U")
					Continue:TestNote'[Keyword
					Set IsMDR=1
					Quit //满足多耐条件Quit
				}
			}Else { //只有多耐菌标记
			   
				Continue:((MRBDesc["肺炎克雷伯")||(MRBDesc["大肠埃希"))	 //肺炎克雷伯、大肠埃希无法定义到多耐种类 	
				Set xBactID=0  //细菌属于多耐分类中维护的细菌
				For {
					Set xBactID=$o(^DHCHAI.IR.CRuleMRBD(xID,"BACT",xBactID))
					Quit:xBactID=""
					Set objBact=##class(DHCHAI.IR.CRuleMRBBact).GetObjById(xID_"||"_xBactID)
					Continue:'$IsObject(objBact)
					Continue:'$IsObject(objBact.BTBactDr)
					Set BacDesc=objBact.BTBactDr.BTBacDesc
		
					Continue:BacDesc=""		
					Set BacDesc=$zcvt(BacDesc,"U")
					Continue:(Bacteria'[BacDesc)&&(BacDesc'[Bacteria)
					Set IsMDR=1
					Quit //满足多耐条件Quit
				}
			
			    If (FlgNum=0)&&(IsMDR=0)&&(MRBCode="N1") {  //细菌不属于多耐分类中维护的细菌
					Set IsMDR=1
				}
			}
		}
		
		If (IsMDR>0){
			Set return=return_"#"_xID_"^"_MRBDesc_"^"_IsMDR_"^"_IsPDR
			Set FlgNum=FlgNum+1
		}
	}
	Set:return["#" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-03-21
/// Description:  根据常规检验筛查多耐分类
/// Table：       DHCHAI.IR.CRuleMRB*、DHCHAI.DP.LabVisitRepResult、DHCHAI.IR.CRuleTestAb
/// Input：       obj : 检验结果
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CRuleMRBSrv).CheckMRBRule2()
ClassMethod CheckMRBRule2(obj As DHCHAI.DP.LabVisitRepResult, objRule As DHCHAI.IR.CRuleTestAb) As %String
{
	New (obj,objRule)
	Set return=""
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(objRule) return
	
	Set TestSet=objRule.BTTestSet
	Quit:TestSet'="细菌检测" return
	Set Bacteria=objRule.BTTestCode  //常规检测项做菌名
	Quit:Bacteria="" return
	Set LabMDRResult = +obj.LabMDRResult // 多耐标记
	//1:检验科那边勾选了多耐标记后，才进行院感多耐分类的判断;0:直接进行院感多耐分类的判断
	Set LabMDRResultFlag=##class(DHCHAI.BT.Config).GetValByCode("LabMDRResultFlag")
	If (LabMDRResultFlag=1){
		Quit:LabMDRResult'=1 return
	}
	Set ResultID=obj.%Id()
	Quit:'$IsObject(obj.LabReportDr) return
	Quit:'$IsObject(obj.LabReportDr.LabVisitNumberDr) return
	Set ReportID=obj.LabReportDr.%Id()
	Set SCode=obj.LabReportDr.LabVisitNumberDr.LabSCode
	Quit:SCode="" return
	
	Set objBactMap=##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	Quit:'$IsObject(objBactMap) return
	Quit:'$IsObject(objBactMap.BTMapItemDr) return
	Set MapBactID=objBactMap.BTMapItemDr.%Id()
	Quit:MapBactID="" return
	
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.IR.CRuleMRBD(xID))
		Quit:xID=""
		
		Set objMRB=##class(DHCHAI.IR.CRuleMRB).GetObjById(xID)
		Continue:'$IsObject(objMRB)
		Continue:objMRB.BTIsActive'=1
		Set MRBCode=objMRB.BTCode
		Set MRBDesc=objMRB.BTDesc
		Set IsRuleCheck=objMRB.BTIsRuleCheck
		Set IsKeyCheck=objMRB.BTIsKeyCheck
		Continue:(IsRuleCheck=1)||(IsKeyCheck=1)
		
		//检查是否多耐菌
		Continue:'$d(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact2",xID,MapBactID))
		
		Set return=xID_"^"_MRBDesc_"^"_0_"^"_0_"^"_Bacteria
		Quit
	}
	
	Quit return
}

/// Creator：     maxp
/// CreatDate：   2017-05-05
/// Description:  查询多耐菌列表
/// Table：       DHCHAI.IR.CRuleMRB
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CRuleMRBSrv","QryCRuleMRB")
Query QryCRuleMRB() As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTCatDr:%String,BTCatDesc:%String,BTIsActive:%String,BTActDate:%String,BTActTime:%String,BTActUserDr:%String,BTActUser:%String,IsRuleCheck:%String,IsAntiCheck:%String,AnitCatCnt:%String,AnitCatCnt2:%String,IsKeyCheck:%String,RuleNote:%String,IsIRstCheck:%String,IsResKeyCheck:%String") [ SqlProc ]
{
}

ClassMethod QryCRuleMRBExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set xCode=""
	For {
		Set xCode=$o(^DHCHAI.IR.CRuleMRBI("IndexCode",xCode))
		Quit:xCode=""
				
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.CRuleMRBI("IndexCode",xCode,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.CRuleMRB).GetObjById(xID)
	 		Continue:'$IsObject(obj)
	 		//Continue:obj.BTIsActive'=1 //过滤无效
	 		Set Code=obj.BTCode
	 		Set Desc=obj.BTDesc
	 		Set CatDr="",CatDesc=""
	 		If $IsObject(obj.BTCatDr){
		 		Set CatDr=obj.BTCatDr.%Id()
		 		Set CatDesc=obj.BTCatDr.BTDesc	
		 	}
			
			Set IsActive=obj.BTIsActive
			Set ActDate=obj.BTActDate
			Set:ActDate'="" ActDate=##class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime=obj.BTActTime
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			If $IsObject(obj.BTActUser) {
				Set ActUserDr=obj.BTActUser.%Id()
				Set ActUser=obj.BTActUser.BTDesc
			} Else {
				Set ActUserDr="",ActUser=""
			}
			Set IsRuleCheck = obj.BTIsRuleCheck
			Set IsAntiCheck = obj.BTIsAntiCheck
			Set AnitCatCnt  = obj.BTAnitCatCnt
			Set AnitCatCnt2 = obj.BTAnitCatCnt2
			Set IsKeyCheck  = obj.BTIsKeyCheck
			Set RuleNote    = obj.BTRuleNote
			Set IsIRstCheck   = obj.BTIsIRstCheck
			Set IsResKeyCheck = obj.BTIsResKeyCheck
			
			Set Data=$lb(xID,Code,Desc,CatDr,CatDesc,IsActive,ActDate,ActTime,ActUserDr,ActUser,IsRuleCheck,IsAntiCheck,AnitCatCnt,AnitCatCnt2,IsKeyCheck,RuleNote,IsIRstCheck,IsResKeyCheck)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCRuleMRBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCRuleMRBExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCRuleMRBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCRuleMRBExecute ]
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
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     maxp
/// CreatDate：   2017-05-24
/// Description:  根据多耐菌-细菌
/// Table：       DHCHAI.IR.CRuleMRBBact
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleMRBSrv","QryMRBBactByMRBID","1")
Query QryMRBBactByMRBID(aMRBID As %String) As %Query(ROWSPEC = "ID:%String,BactID:%String,BactCode:%String,BactDesc:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryMRBBactByMRBIDExecute(ByRef qHandle As %Binary, aMRBID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aMRBID="" $$$OK
	
	Set xSubID =""
    For {
		Set xSubID = $o(^DHCHAI.IR.CRuleMRBD(aMRBID,"BACT",xSubID))
		Quit:xSubID="" 
	
		Set ID=aMRBID_"||"_xSubID
		Set obj = ##class(DHCHAI.IR.CRuleMRBBact).GetObjById(ID)
		Continue:'$Isobject(obj)
		
		Set BactID="",BactCode="",BactDesc=""	   
		If $IsObject(obj.BTBactDr) {
			Set BactID    = obj.BTBactDr.%Id()
			Set BactCode  = obj.BTBactDr.BTBacCode
			Set BactDesc  = obj.BTBactDr.BTBacDesc
		}
		Set ActDate		= obj.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)    	
		Set ActTime		= obj.BTActTime 
		Set:ActTime'="" ActTime=$zt(ActTime,1)  
		
		Set ActUserDr = obj.BTActUserDr    	
		Set ActUserID="",ActUser="",ActUserDesc=""
		If $IsObject(obj.BTActUserDr) {
			Set ActUserID   = obj.BTActUserDr.%Id()
			Set ActUser     = obj.BTActUserDr.BTDesc
		}
				
		Set Data = $lb(ID,BactID,BactCode,BactDesc,ActDate,ActTime,ActUserID,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }
	    
	Quit $$$OK
}

ClassMethod QryMRBBactByMRBIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBBactByMRBIDExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMRBBactByMRBIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBBactByMRBIDExecute ]
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

/// Creator：     maxp
/// CreatDate：   2017-05-24
/// Description:  根据多耐菌-抗生素
/// Table：       DHCHAI.IR.CRuleMRBAnti
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleMRBSrv","QryMRBAntiByMRBID","1")
Query QryMRBAntiByMRBID(aMRBID As %String) As %Query(ROWSPEC = "ID:%String,AntiCatDr:%String,AntiCatCode:%String,AntiCatDesc:%String,AntiID:%String,AntiCode:%String,AntiDesc:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryMRBAntiByMRBIDExecute(ByRef qHandle As %Binary, aMRBID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aMRBID="" $$$OK
	
	Set xSubID =""
    For {
		Set xSubID = $o(^DHCHAI.IR.CRuleMRBD(aMRBID,"ANT",xSubID))
		Quit:xSubID="" 
	
		Set ID=aMRBID_"||"_xSubID
		Set obj = ##class(DHCHAI.IR.CRuleMRBAnti).GetObjById(ID)
		Continue:'$Isobject(obj)
			   
		//Set BTAntiCatDr	= obj.BTAntiCatDr
		Set (AntiCatDr,AntiCatCode,AntiCatDesc)=""
		If $IsObject(obj.BTAntiCatDr) {
			Set AntiCatDr	= obj.BTAntiCatDr.%Id()
			Set AntiCatCode	= obj.BTAntiCatDr.BTCode
			Set AntiCatDesc	= obj.BTAntiCatDr.BTDesc
		}
		Set (AntiDr,AntiCode,AntiDesc)=""
		If $IsObject(obj.BTAntiDr) {
			Set AntiDr	  = obj.BTAntiDr.%Id()
			Set AntiCode  = obj.BTAntiDr.BTAntCode
			Set AntiDesc  = obj.BTAntiDr.BTAntDesc
		}
		Set ActDate		= obj.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)    	
		Set ActTime		= obj.BTActTime 
		Set:ActTime'="" ActTime=$zt(ActTime,1)  
		
		Set ActUserDr = obj.BTActUserDr    	
		Set ActUserID="",ActUser="",ActUserDesc=""
		If $IsObject(obj.BTActUserDr) {
			Set ActUserID   = obj.BTActUserDr.%Id()
			Set ActUser     = obj.BTActUserDr.BTDesc
		}
				
		Set Data = $lb(ID,AntiCatDr,AntiCatCode,AntiCatDesc,AntiDr,AntiCode,AntiDesc,ActDate,ActTime,ActUserID,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }
	    
	Quit $$$OK
}

ClassMethod QryMRBAntiByMRBIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBAntiByMRBIDExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMRBAntiByMRBIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBAntiByMRBIDExecute ]
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

/// Creator：     maxp
/// CreatDate：   2017-05-24
/// Description:  根据多耐菌-关键字
/// Table：       DHCHAI.IR.CRuleMRBKeys
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleMRBSrv","QryMRBKeysByMRBID","1")
Query QryMRBKeysByMRBID(aMRBID As %String) As %Query(ROWSPEC = "ID:%String,KeyWord:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryMRBKeysByMRBIDExecute(ByRef qHandle As %Binary, aMRBID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aMRBID="" $$$OK
	
	Set xSubID =""
    For {
		Set xSubID = $o(^DHCHAI.IR.CRuleMRBD(aMRBID,"KEYS",xSubID))
		Quit:xSubID="" 
	
		Set ID=aMRBID_"||"_xSubID
		Set obj = ##class(DHCHAI.IR.CRuleMRBKeys).GetObjById(ID)
		Continue:'$Isobject(obj)
			   
		Set KeyWord	= obj.BTKeyWord 
		Set ActDate		= obj.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)    	
		Set ActTime		= obj.BTActTime 
		Set:ActTime'="" ActTime=$zt(ActTime,1)  
		
		Set ActUserDr = obj.BTActUserDr    	
		Set ActUserID="",ActUser="",ActUserDesc=""
		If $IsObject(obj.BTActUserDr) {
			Set ActUserID   = obj.BTActUserDr.%Id()
			Set ActUser     = obj.BTActUserDr.BTDesc
		}
				
		Set Data = $lb(ID,KeyWord,ActDate,ActTime,ActUserID,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }
	    
	Quit $$$OK
}

ClassMethod QryMRBKeysByMRBIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBKeysByMRBIDExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMRBKeysByMRBIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBKeysByMRBIDExecute ]
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
/// CreatDate：   2017-09-28
/// Description:  查询多耐菌列表(报表使用)
/// Table：       DHCHAI.IR.CRuleMRB
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CRuleMRBSrv","QryMRBSrv")
Query QryMRBSrv(aActive As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod QryMRBSrvExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
			
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.IR.CRuleMRBD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.IR.CRuleMRB).GetObjById(xID)
 		Continue:'$IsObject(obj)
 		Set Code=obj.BTCode
 		Continue:(Code="MRB")||(Code="N0")||(Code="N1")
 		Set Desc=obj.BTDesc
		
		Set IsActive=obj.BTIsActive
		Continue:(aActive'="")&&(IsActive'=aActive)
		Set Data=$lb(xID,Code,Desc,IsActive)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMRBSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBSrvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBSrvExecute ]
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
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 导入多耐字典
/// w ##class(DHCHAI.IRS.CRuleMRBSrv).ImportMRBDic("^M1^耐甲氧西林的金黄色葡萄球菌^1^MRSA")
ClassMethod ImportMRBDic(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=""
	Quit:aInputStr="" return
	
	Set CatCode=$p(aInputStr,"^",4)
	Set CatDr=""
	If CatCode'="" {
		Set objCat=##class(DHCHAI.BT.Dictionary).GetObjByCode("MRBCategory",CatCode)
		If $IsObject(objCat){
			Set CatDr=objCat.%Id()
		}
	}
	Set $p(aInputStr,"^",4)=CatDr
	
	Set Code=$p(aInputStr,"^",2)
	Quit:Code="" return
	Set MRBDr=$o(^DHCHAI.IR.CRuleMRBI("IndexCode",Code,0))
	If MRBDr'="" {
		Set objMRB=##class(DHCHAI.IR.CRuleMRB).GetObjById(MRBDr)
		If $IsObject(objMRB){
			Set $p(aInputStr,"^",1)=MRBDr
			Set $p(aInputStr,"^",6)=objMRB.BTIsRuleCheck
			Set $p(aInputStr,"^",7)=objMRB.BTIsAntiCheck
			Set $p(aInputStr,"^",8)=objMRB.BTAnitCatCnt
			Set $p(aInputStr,"^",9)=objMRB.BTAnitCatCnt2
			Set $p(aInputStr,"^",10)=objMRB.BTIsKeyCheck
			Set $p(aInputStr,"^",11)=objMRB.BTActDate
			Set $p(aInputStr,"^",12)=objMRB.BTActTime
			If $IsObject(objMRB.BTActUser){
				Set ActUserDr=objMRB.BTActUser.%Id()
			} Else {
				Set ActUserDr=""
			}
			Set $p(aInputStr,"^",13)=ActUserDr
			Set:(objMRB.BTRuleNote'="") $p(aInputStr,"^",14)=objMRB.BTRuleNote
			Set:(objMRB.BTIsIRstCheck'="") $p(aInputStr,"^",15)=objMRB.BTIsIRstCheck
			Set $p(aInputStr,"^",16)=objMRB.BTIsResKeyCheck
		}
	}
	Set return=##class(DHCHAI.IR.CRuleMRB).Update(aInputStr,"^")
	Quit return
}

/// 导入多耐字典-细菌
/// w ##class(DHCHAI.IRS.CRuleMRBSrv).ImportMRBBact("P2^凝固酶阴性葡萄球菌")
ClassMethod ImportMRBBact(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=""
	Quit:aInputStr="" return
	
	Set MRBCode=$p(aInputStr,"^",1)
	Quit:MRBCode="" return
	Set MRBDr=$o(^DHCHAI.IR.CRuleMRBI("IndexCode",MRBCode,0))
	Quit:MRBDr="" return
	
	Set Bact=$p(aInputStr,"^",2)
	Quit:Bact="" return
	Set BactDr = $o(^DHCHAI.DP.LabBacteriaI("IndexDesc",Bact,0))
	Quit:BactDr="" return
	
	Set ChildSub=$o(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",BactDr,MRBDr,0))
    Set InputStr=""
    Set $p(InputStr,"^",1)=MRBDr
    Set $p(InputStr,"^",2)=ChildSub
    Set $p(InputStr,"^",3)=BactDr
   
	Set return=##class(DHCHAI.IR.CRuleMRBBact).Update(InputStr,"^")
	Quit return
}

/// 导入多耐字典-抗生素
/// w ##class(DHCHAI.IRS.CRuleMRBSrv).ImportMRBAnt("M4^头孢类.第四代头孢菌素")
ClassMethod ImportMRBAnt(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=""
	Quit:aInputStr="" return
	
	Set MRBCode=$p(aInputStr,"^",1)
	Quit:MRBCode="" return
	Set MRBDr=$o(^DHCHAI.IR.CRuleMRBI("IndexCode",MRBCode,0))
	Quit:MRBDr="" return
	
	Set AntCat=$p(aInputStr,"^",2)
	Quit:AntCat="" return
	
	Set AntCatDr = $o(^DHCHAI.DP.LabAntiCatI("IndexDesc",AntCat,0))
	Quit:AntCatDr="" return
	
	Set AntDesc=$p(aInputStr,"^",3)
	Set AntDr=""
	Set:AntDesc'="" AntDr = $o(^DHCHAI.DP.LabAntibioticI("IndexDesc",AntDesc,0))
	Set ChildSub=$o(^DHCHAI.IR.CRuleMRBI("ANT","IndexAntiCat",AntCatDr,MRBDr,0))
	If (ChildSub'="")&&(AntDr'=""){
		Set xChildSub=$o(^DHCHAI.IR.CRuleMRBI("ANT","IndexAnti",AntDr,MRBDr,0))
		Set ChildSub=xChildSub
	}

    Set InputStr=""
    Set $p(InputStr,"^",1)=MRBDr
    Set $p(InputStr,"^",2)=ChildSub
    Set $p(InputStr,"^",3)=AntCatDr
    Set $p(InputStr,"^",4)=AntDr
  
	Set return=##class(DHCHAI.IR.CRuleMRBAnti).Update(InputStr,"^")
	Quit return
}

}
