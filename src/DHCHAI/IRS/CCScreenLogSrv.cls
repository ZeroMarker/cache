/// 名称: DHCHAI.IRS.CCScreenLogSrv
/// 描述: 疑似病例筛查日志相关服务
/// 编写者：zhufei
/// 编写日期: 2017-03-20
Class DHCHAI.IRS.CCScreenLogSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-03-20
/// Description:  疑似病例筛查操作
/// Input：       EpisodeID ：就诊号
///               OperaCode : 操作代码（确诊、排除、消息）
///               OperaLog : 操作日志（消息类型^处置人^处置意见）
///               ResultIDs : 关联筛查记录（多值"^"分割）
/// Return:		  return>0:成功
/// Debug:		  w ##class(DHCHAI.IRS.CCScreenLogSrv).ScreenOpera()
ClassMethod ScreenOpera(aEpisodeID As %String, aOperaCode As %String, aOperaLog As %String, aResultIDs As %String = "") As %String
{
	New (aEpisodeID,aOperaCode,aOperaLog,aResultIDs)
	Set return=0
	Quit:(aEpisodeID="")||(aOperaCode="") return
	
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-06-18
/// Description:  获取患者是否今日处理
/// Table：       DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenLog
/// Input：       aEpisodeID:就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreenLogSrv).IsDealToday("90")
ClassMethod IsDealToday(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="") return
	
	Set IsToday =0
	Set xScreenID=""
   	For {
	   	Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",aEpisodeID,xScreenID))
	   	Quit:xScreenID=""
	 	Quit:IsToday=1
	
	   	Set xLogID = ""
	   	For {
	   		Set xLogID=$o(^DHCHAI.IR.CCScreeningD(xScreenID,"Log",xLogID),-1)
	   		Quit:xLogID=""
	   		
	   		Set xID =xScreenID_"||"_xLogID
	   		Set objLog=##class(DHCHAI.IR.CCScreenLog).GetObjById(xID)
			Continue:'$IsObject(objLog)
		
			Set ActDate=objLog.CSActDate
			Set IsToday =1
			Quit:ActDate=+$h
			Set IsToday =0
	   	}
   	}
   	Set return = IsToday
   	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-11-30
/// Description:  获取患者检出菌疑似项目
/// Table：       DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenLog
/// Input：       aEpisodeID:就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreenLogSrv).BacteriaItem("90")
ClassMethod BacteriaItem(aEpisodeID As %String, aBacteria As %String) As %String
{
	New (aEpisodeID,aBacteria)
	Set return=""
	Quit:(aEpisodeID="")||(aBacteria="") return

	kill arrSreenItem
	kill arrBacteria
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objEpisode) return
	Set AdmDate=objEpisode.PAAdmDate
	Set DischDate=objEpisode.PADischDate
	Set DateFrom=AdmDate
	Set DateTo=DischDate
	Set:DateTo="" DateTo=+$h 
	
	Set arrResult=##class(DHCHAI.IRC.CSResultSrv).GetSuRuleResult(aEpisodeID,AdmDate,DateTo)
	
 	Quit:arrResult.Count()<1 $$$OK
 	Set Count=arrResult.Count()
 	For indArr=1:1:Count {
		Set obj=arrResult.GetAt(indArr)
		Continue:'$IsObject(obj)
		Continue:'$IsObject(obj.CSItmScreenDr)
		Continue:obj.CSIsActive'=1 //增加是否有效标志
		
		Set ItmScreenID   = obj.CSItmScreenDr.%Id()
		//Continue:ItmScreenID'=2    //只为处理检出菌
		Set ItmScreen   = obj.CSItmScreenDr.CCDesc
		Continue:(ItmScreen'="检出致病菌")&(ItmScreen'="诊断血流感染")
		Set ItmScreenTxt  = $tr(obj.CSItmScreenTxt," ","")
		Continue:aBacteria'=ItmScreenTxt   //细菌名称过滤
		Set ResultNote    = obj.CSResultNote
      
		Set ResultDate    = obj.CSResultDate
		Set ResultCnt     = obj.CSResultCnt
		Set RstFromDate   = obj.CSRstFromDate
		Set InfSuPosID    = obj.CSInfSuPosDr    //疑似诊断（部位）
		Set Specimen      = obj.CSSpecimen      //(新增)标本名称（多值#分隔）
		Set MRBType       = obj.CSMRBType       //(新增)多耐分类名称（多值#分隔）
		Set InfSuRuleDr   = obj.CSInfSuRuleDr   //(新增)规则ID（多值#分隔)
		Set Details       = obj.CSDetails       //病毒支原体检测结果明细
	   
		Set objRule=##class(DHCHAI.IR.CRuleInfSuRule).GetObjById(InfSuRuleDr)
		Continue:'$IsObject(objRule)
		Set InfSuRuleNote = objRule.BTRuleNote
		
		Set arrSreenItem("BacteriaItem",InfSuRuleDr,ItmScreenTxt,indArr) = $lb(InfSuRuleDr,Specimen,MRBType,ItmScreenTxt,ResultDate,ResultNote,Details)
 	}
 
    Set xInfSuRuleID=""
 	For{
	 	Set xInfSuRuleID=$o(arrSreenItem("BacteriaItem",xInfSuRuleID))
	 	Quit:xInfSuRuleID=""
	 
	 	Set xItmScreenTxt=""	 	
	 	For{
	 		Set xItmScreenTxt=$o(arrSreenItem("BacteriaItem",xInfSuRuleID,xItmScreenTxt))
	 		Quit:xItmScreenTxt=""	
	 	  
		 	Set SpecimenList="",MRBTypeList="",DetailsList="",FromDate=""
		 	Set xindArr=""
		 	For{
		 		Set xindArr=$o(arrSreenItem("BacteriaItem",xInfSuRuleID,xItmScreenTxt,xindArr))
		 		Quit:xindArr=""
		 		
		 		Set SuRuleInfo = $g(arrSreenItem("BacteriaItem",xInfSuRuleID,xItmScreenTxt,xindArr))
		 	    Continue:SuRuleInfo=""
				Set InfSuRuleDr  = $lg(SuRuleInfo,1)
		 	    Set Specimen     = $lg(SuRuleInfo,2)
		 	    Set MRBType      = $lg(SuRuleInfo,3)
		 	    Set ItmScreenTxt = $lg(SuRuleInfo,4)
		 	    Set ResultDate   = $lg(SuRuleInfo,5)
		 	   	Set ResultNote   = $lg(SuRuleInfo,6)
		 	   	Set Details      = $lg(SuRuleInfo,7)
		 	  
		 	    Set:FromDate="" FromDate=ResultDate
		 	   	If ($listfind(SpecimenList,Specimen)<1) {
		 	   		Set SpecimenList=SpecimenList_$lb(Specimen)
		 	   	}
		 	   	If ($listfind(MRBTypeList,MRBType)<1) {
		 	   		Set MRBTypeList=MRBTypeList_$lb(MRBType)
		 	   	} 	   
		 	   	Set:Details'="" DetailsList=DetailsList_"#"_Details			   	
		 	}
		 	
		 	Set:DetailsList'="" DetailsList=$e(DetailsList,2,$l(DetailsList))
		 	Set Specimens=""
		   	For indSpe=1:1:$ll(SpecimenList)  {
			    Set Specimen=$lg(SpecimenList,indSpe)
			    Continue:Specimen=""
			    Set Specimens=Specimens_"#"_ Specimen	    
		    }
		    Set:Specimens'="" Specimens=$e(Specimens,2,$l(Specimens))
		    
		   	Set MRBTypes=""
		   	For indMRB=1:1:$ll(MRBTypeList)  {
			    Set MRBType=$lg(MRBTypeList,indMRB)
			    Continue:MRBType=""
			    Set MRBTypes=MRBTypes_"#"_ MRBType	    
		    }
		    Set:MRBTypes'="" MRBTypes=$e(MRBTypes,2,$l(MRBTypes))
		 				 			
		 	Set arrBacteria("Bacteria",xInfSuRuleID,xItmScreenTxt)= $lb(FromDate,Specimens,MRBTypes,DetailsList,ResultNote)
	 	}		
 	}
    
 	Set xInfSuRuleID="",DetailsList=""
 	For{
	 	Set xInfSuRuleID=$o(arrBacteria("Bacteria",xInfSuRuleID))
	 	Quit:xInfSuRuleID=""
	 	 	
	 	Set xBacteria=""
	 	For{
		 	Set xBacteria=$o(arrBacteria("Bacteria",xInfSuRuleID,xBacteria))
		 	Quit:xBacteria=""
		 	Set BacteriaInfo =$g(arrBacteria("Bacteria",xInfSuRuleID,xBacteria))
			Continue:BacteriaInfo=""
			
			Set FromDate=$lg(BacteriaInfo,1)
			Set Specimens=$lg(BacteriaInfo,2)
			Set MRBTypes=$lg(BacteriaInfo,3)
			Set Details=$lg(BacteriaInfo,4)
			Set ResultNote = $lg(BacteriaInfo,5)
		
			Set:Details'="" ResultNote=ResultNote_"#"_Details
			Set ItemTxt = ResultNote
			Set DetailsList=DetailsList_"#"_ItemTxt
	 	}
	  	
 	}
 	Set:DetailsList'="" DetailsList=$e(DetailsList,2,$l(DetailsList))	
   	Set return = DetailsList
   	
   	kill arrSreenItem
	kill arrBacteria

   	Quit return
}

/// Creator：     pylian
/// CreatDate：   2023-01-17
/// Description:  获取患者病程阳性症状体征疑似项目
/// Table：       DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenLog
/// Input：       aEpisodeID:就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreenLogSrv).BacteriaItem("90")
ClassMethod SymptomItem(aEpisodeID As %String, aScreenTxt As %String) As %String
{
	New (aEpisodeID,aScreenTxt)
	Set return=""
	Quit:(aEpisodeID="")||(aScreenTxt="") return

	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objEpisode) return
	Set AdmDate=objEpisode.PAAdmDate
	Set DischDate=objEpisode.PADischDate
	Set DateFrom=AdmDate
	Set DateTo=DischDate
	Set:DateTo="" DateTo=+$h 
	Set ResultNote=""
	Set arrResult=##class(DHCHAI.IRC.CSResultSrv).GetSuRuleResult(aEpisodeID,AdmDate,DateTo)
 	Quit:arrResult.Count()<1 $$$OK
 	Set Count=arrResult.Count()
 	For indArr=1:1:Count {
		Set obj=arrResult.GetAt(indArr)
		Continue:'$IsObject(obj)
		Continue:'$IsObject(obj.CSItmScreenDr)
		Continue:obj.CSIsActive'=1 //增加是否有效标志
		Set ItmScreen   = obj.CSItmScreenDr.CCDesc
		Continue:(ItmScreen'="病程阳性症状或体征")
		Set ItmScreenTxt  = $tr(obj.CSItmScreenTxt," ","")
		Continue:aScreenTxt'=ItmScreenTxt   
		Set ResultNote    = obj.CSResultNote
 	}
   	Set return = ResultNote
   	
   	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-11-23
/// Description:  疑似筛查操作明细
/// Table：       DHCHAI.IR.CCScreening/DHCHAI.IR.CCScreenLog
/// Input：       aEpisodeID : 就诊号
/// 				  aScreenID :疑似筛查记录
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreenLogSrv","QrySrceenDtlLog","11")
Query QrySrceenDtlLog(aEpisodeID As %String, aScreenID As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,ScreenID:%String,ItmScreenID:%String,ItmScreen:%String,ItmScreenTxt:%String,Status:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUserDesc:%String,Opinion:%String,OpinionTxt:%String,Details:%String,ActType:%String") [ SqlProc ]
{
}

ClassMethod QrySrceenDtlLogExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aScreenID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aEpisodeID="" $$$OK
 
	Set xScreenID = ""
	For {
		Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",aEpisodeID,xScreenID))
		Quit:xScreenID=""
	    Continue:(aScreenID'="")&&(xScreenID'=aScreenID)
	    
		Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
		Continue:'$IsObject(objScreen)
		Continue:'$IsObject(objScreen.CSItmScreenDr)
		Set ItmScreenID=objScreen.CSItmScreenDr.%Id()
		Set ItmScreen=objScreen.CSItmScreenDr.CCDesc
		Set ItmScreen2=objScreen.CSItmScreenDr.CCDesc2
		Set:ItmScreen2'="" ItmScreen=ItmScreen2
       
		Set ItmScreenTxt=objScreen.CSItmScreenTxt
		Set Details=""
		If ((ItmScreen="检出致病菌")||(ItmScreen="诊断血流感染"))&(ItmScreenTxt'=""){
			Set Details=..BacteriaItem(aEpisodeID,ItmScreenTxt)
	    }
	    If (ItmScreen="病程阳性症状或体征")&(ItmScreenTxt'=""){
		    Set ItmScreen=..SymptomItem(aEpisodeID,ItmScreenTxt)
	    }
		
	    Set xLogID = ""  //操作日志
	   	For {
	   		Set xLogID=$o(^DHCHAI.IR.CCScreeningD(xScreenID,"Log",xLogID))
	   		Quit:xLogID=""
	   		
	   		Set xID =xScreenID_"||"_xLogID	   		
	   		Set objLog=##class(DHCHAI.IR.CCScreenLog).GetObjById(xID)
			Continue:'$IsObject(objLog)
			Set Status = objLog.CSStatus
			Set Status =$s(Status=2:"排除",Status=1:"确诊",1:"待处理")
			Set ActDate = objLog.CSActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime   = objLog.CSActTime
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			Set (ActUserID,ActUserCode,ActUserDesc)=""
			If $IsObject(objLog.CSActUserDr) {
				Set ActUserID = objLog.CSActUserDr.%Id()
				Set ActUserCode = objLog.CSActUserDr.BTCode
				Set ActUserDesc = objLog.CSActUserDr.BTDesc
			}
			
			Set Opinion=""
			If $IsObject(objLog.CSOpinionDr) {
				Set Opinion = objLog.CSOpinionDr.BTDesc
				//多语言改造 排除原因
				Set Opinion=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",Opinion,"DHCHAI.BT.Dictionary")
			}
			Set OpinionTxt = objLog.CSOpinion
			Set:OpinionTxt'="" Opinion=Opinion_"("_OpinionTxt_")"
			
			Set ActType=""
			Set ActType = objLog.CSActType
			Set ActType=$s(ActType=1:"临床",ActType=2:"院感科",1:"")
			//多语言改造
			Set ActType=##class(websys.Translation).Get("dhcma.hai.ir.patscreening.csp",ActType)
			Set Status=##class(websys.Translation).Get("dhcma.hai.ir.patscreening.csp",Status)
			Set Data=$lb(aEpisodeID,xScreenID,ItmScreenID,ItmScreen,ItmScreenTxt,Status,ActDate,ActTime,ActUserCode,ActUserDesc,Opinion,OpinionTxt,Details,ActType)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
	   	}
	 }
	Quit $$$OK
}

ClassMethod QrySrceenDtlLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySrceenDtlLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySrceenDtlLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySrceenDtlLogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2022-06-07
/// Description:  统计疑似筛查规则确诊排除比例
/// Table：       DHCHAI.IR.CCScreening/DHCHAI.IR.CCScreenDtl
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo :结束日期
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreenLogSrv","QrySuRuleOpr","2022-01-01","2022-06-10")
Query QrySuRuleOpr(aDateFrom As %String, aDateTo As %String, aIsActive As %String = 1) As %Query(ROWSPEC = "RuleID:%String,RuleNo:%String,RuleType:%String,RuleNote:%String,ItmScreenDr:%String,ItmScreen:%String,InfPosID:%String,InfPosDesc:%String,DiagNum:%String,ExcNum:%String,DiaRatio:%String") [ SqlProc ]
{
}

ClassMethod QrySuRuleOprExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aIsActive As %String = 1) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
	Kill ^TMP($zn,$j,"ItmScreenStatus")
	Kill ^TMP($zn,$j,"ItmScreenDtl")
	
	For xActDate =aDateFrom:1:aDateTo {						
		Set xActTime = ""
		For {
			Set xActTime = $o(^DHCHAI.IR.CCScreeningI("Dtl","IndexActDateTime",xActDate,xActTime))
			Quit:xActTime=""
	
			Set xScreenID = ""
			For {
				Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexActDateTime",xActDate,xActTime,xScreenID))
				Quit:xScreenID=""
				
				Set ScreenData=$g(^DHCHAI.IR.CCScreeningD(xScreenID))
			   	Continue:ScreenData=""
			   	Set EpisodeID=$lg(ScreenData,2)		   	
			   	Set ItmScreenID=$lg(ScreenData,3)
			   	Set ItmScreenData=$g(^DHCHAI.IR.CCItmScreenD(+ItmScreenID))
			   	Set ItmScreen =$lg(ItmScreenData,3)
			   	Set ItmScreenTxt=$lg(ScreenData,4)	
			    Set:ItmScreenTxt="" ItmScreenTxt=" "
			    If (ItmScreen="病程阳性症状或体征")&(ItmScreenTxt'=""){
		    		Set ResultNote=..SymptomItem(EpisodeID,ItmScreenTxt)
	    		}
			    
			    //检出菌对应多条疑似规则需特殊处理
			    Set ResultNote=""
			    Set:(ItmScreen="检出致病菌")||(ItmScreen="诊断血流感染") ResultNote=##class(DHCHAI.IRS.CCScreenLogSrv).BacteriaItem(EpisodeID,ItmScreenTxt)
				Set xDtlID = ""
			   	For {
			   		Set xDtlID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexActDateTime",xActDate,xActTime,xScreenID,xDtlID))
			   		Quit:xDtlID=""
			   		
			   		Set ScreenDtlData=$g(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xDtlID))
			   		Continue:ScreenDtlData=""		   		
			   		Set Status = $lg(ScreenDtlData,2)
			   			   		
			   		Set ^TMP($zn,$j,"ItmScreenDtl",ItmScreenID,ItmScreenTxt,Status,xScreenID,xDtlID)=ResultNote		   		
			   	}
			}
		}
	}
    
	Set xRuleNo = ""
	For {
		Set xRuleNo = $o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleNo",xRuleNo))
		Quit:xRuleNo=""
		
		Set xRuleID = ""
		For {
			Set xRuleID = $o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleNo",xRuleNo,xRuleID))
			Quit:xRuleID=""
		
			Set obj = ##class(DHCHAI.IR.CRuleInfSuRule).GetObjById(xRuleID)
			Continue:'$Isobject(obj)
			Continue:'$Isobject(obj.BTItmScreenDr)
		
			Set ItmScreenDr = obj.BTItmScreenDr.%Id()
			Set ItmScreen = obj.BTItmScreenDr.CCDesc 
			Set ItmScreen2 = obj.BTItmScreenDr.CCDesc2 	
			Set:ItmScreen2'="" ItmScreen=ItmScreen2
			Set (InfPosID,InfPosDesc) = ""
			If $IsObject(obj.BTSuPosDr) {	
				Set InfPosID =  obj.BTSuPosDr.%Id()  
				Set InfPosDesc = obj.BTSuPosDr.BTDiagnos
		    }
		    Set RuleNo 	  = obj.BTRuleNo	
			Set RuleType  = obj.BTRuleType 	
			Set RuleNote  = obj.BTRuleNote 	
			Set IsActive  = obj.BTIsActive 
			Continue:(aIsActive'="")&(aIsActive'=IsActive)		
			
			Set xItmScreenTxt=""
			For{
				Set xItmScreenTxt =$o(^TMP($zn,$j,"ItmScreenDtl",ItmScreenDr,xItmScreenTxt))
				Quit:xItmScreenTxt=""
				Continue:(xItmScreenTxt'="")&(InfPosID'=xItmScreenTxt)&(ItmScreen["权重")
				
				Set xStatus=""
				For{
					Set xStatus =$o(^TMP($zn,$j,"ItmScreenDtl",ItmScreenDr,xItmScreenTxt,xStatus))
					Quit:xStatus=""
					
					Set xScrID=""
					For{
						Set xScrID =$o(^TMP($zn,$j,"ItmScreenDtl",ItmScreenDr,xItmScreenTxt,xStatus,xScrID))
						Quit:xScrID=""
						
						Set ResultNote=""
						Set xScrDtlID=""
						For{
							Set xScrDtlID =$o(^TMP($zn,$j,"ItmScreenDtl",ItmScreenDr,xItmScreenTxt,xStatus,xScrID,xScrDtlID))
							Quit:xScrDtlID=""
							
							//检出菌对应多条疑似规则需特殊处理
							If (ItmScreen="检出致病菌")||(ItmScreen="诊断血流感染") {
								Set:RuleNote["培养出同种菌" RuleNote="重复检出同种菌"
								Set ResultNote =$g(^TMP($zn,$j,"ItmScreenDtl",ItmScreenDr,xItmScreenTxt,xStatus,xScrID,xScrDtlID))
								Continue:((ResultNote'[RuleNote)&&(ResultNote'["痰培养连续两次检出相同菌"))
								Continue:((ResultNote["痰培养连续两次检出相同菌")&&(RuleNote'="重复检出同种菌"))
							}
							Set num=$i(^TMP($zn,$j,"ItmScreenStatus",xRuleID,ItmScreenDr,xStatus))
						}
					}
				}	
			}			
			
			
			Set (DiagNum,ExcNum)=0
			Set DiagNum=+$g(^TMP($zn,$j,"ItmScreenStatus",xRuleID,ItmScreenDr,1))
			Set ExcNum=+$g(^TMP($zn,$j,"ItmScreenStatus",xRuleID,ItmScreenDr,2))
			    
			Set DiaRatio="0.00%"
			Set:(DiagNum+ExcNum)>0 DiaRatio=$fn((DiagNum/(DiagNum+ExcNum))*100,"",2)_"%" 	//确诊占比
				
			Set Data=$lb(xRuleID,RuleNo,RuleType,RuleNote,ItmScreenDr,ItmScreen,InfPosID,InfPosDesc,DiagNum,ExcNum,DiaRatio)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
	   	}
	 }
	 Kill ^TMP($zn,$j,"ItmScreenStatus")
	 Kill ^TMP($zn,$j,"ItmScreenDtl")	
	 Quit $$$OK
}

ClassMethod QrySuRuleOprClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuRuleOprExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySuRuleOprFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuRuleOprExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2022-06-08
/// Description:  统计疑似筛查规则确诊排除明细
/// Table：       DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl、DHCHAI.IR.CCScreenLog
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo :结束日期
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreenLogSrv","QrySuRuleOprDtl","2020-01-01","2022-06-10","1","1")
Query QrySuRuleOprDtl(aDateFrom As %String, aDateTo As %String, aRuleID As %String, aStatus As %String) As %Query(ROWSPEC = "RuleNo:%String,RuleType:%String,RuleNote:%String,ItmScreenID:%String,ItmScreen:%String,InfPosID:%String,InfPosDesc:%String,ScreeningID:%String,ScreenDtlID:%String,Status:%String,InfPosDesc:%String,ActDateTime:%String,ActUserCode:%String,ActUserDesc:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,DischDateTime:%String,DischLocDesc") [ SqlProc ]
{
}

ClassMethod QrySuRuleOprDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aRuleID As %String, aStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Quit:(aRuleID="") $$$OK
 	
	Set obj = ##class(DHCHAI.IR.CRuleInfSuRule).GetObjById(aRuleID)
	Quit:'$Isobject(obj) $$$OK
	Quit:'$Isobject(obj.BTItmScreenDr) $$$OK

	Set ItmScreenDr = obj.BTItmScreenDr.%Id()
	Set ItmScreen = obj.BTItmScreenDr.CCDesc 
	Set ItmScreen2 = obj.BTItmScreenDr.CCDesc2 	
	Set:ItmScreen2'="" ItmScreen=ItmScreen2
	Set (InfPosID,InfPosDesc) = ""
	If $IsObject(obj.BTSuPosDr) {	
		Set InfPosID =  obj.BTSuPosDr.%Id()  
		Set InfPosDesc = obj.BTSuPosDr.BTDiagnos
    }
    Set RuleNo 	  = obj.BTRuleNo	
	Set RuleType  = obj.BTRuleType 	
	Set RuleNote  = obj.BTRuleNote 	
	Set IsActive  = obj.BTIsActive 

	For xActDate =aDateFrom:1:aDateTo {						
		Set xActTime = ""
		For {
			Set xActTime = $o(^DHCHAI.IR.CCScreeningI("Dtl","IndexActDateTime",xActDate,xActTime))
			Quit:xActTime=""
	
			Set xScreenID = ""
			For {
				Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexActDateTime",xActDate,xActTime,xScreenID))
				Quit:xScreenID=""
				
				Set ScreenData=$g(^DHCHAI.IR.CCScreeningD(xScreenID))
			   	Continue:ScreenData=""
			   	Set EpisodeID=$lg(ScreenData,2)		   	
			   	Set ItmScreenID=$lg(ScreenData,3)
			   	Continue:ItmScreenDr'=ItmScreenID
			   	Set ItmScreenTxt=$lg(ScreenData,4)	
			    Set:ItmScreenTxt="" ItmScreenTxt=" "
			    
			    Set PatData=..BuildPaadmData(EpisodeID)
				Continue:PatData=""
	

			    //检出菌对应多条疑似规则需特殊处理
			    Set ResultNote="",RuleDetails=RuleNote
			    Set:(ItmScreen="检出致病菌")||(ItmScreen="诊断血流感染") ResultNote=##class(DHCHAI.IRS.CCScreenLogSrv).BacteriaItem(EpisodeID,ItmScreenTxt)
				If (ItmScreen="病程阳性症状或体征")&(ItmScreenTxt'=""){
		    		Set RuleDetails=..SymptomItem(EpisodeID,ItmScreenTxt)
	    		}
				Set xDtlID = ""
			   	For {
			   		Set xDtlID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexActDateTime",xActDate,xActTime,xScreenID,xDtlID))
			   		Quit:xDtlID=""
			   		
			   		Set ScreenDtlData=$g(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xDtlID))
			   		Continue:ScreenDtlData=""		   		
			   		Set Status = $lg(ScreenDtlData,2)
			   		Continue:(aStatus'="")&&(aStatus'=Status)
			   		Set Status =$s(Status=2:"排除",Status=1:"确诊",1:"待处理")
			  			   		 		
					//检出菌对应多条疑似规则需特殊处理
					If (ItmScreen="检出致病菌")||(ItmScreen="诊断血流感染") {
						Set:RuleNote["培养出同种菌" RuleNote="重复检出同种菌"
						Continue:((ResultNote'[RuleNote)&&(ResultNote'["痰培养连续两次检出相同菌"))
						Continue:((ResultNote["痰培养连续两次检出相同菌")&&(RuleNote'="重复检出同种菌"))
						Set RuleDetails = ResultNote
					}
					
					Set DiagnosDr=$lg(ScreenDtlData,4)
					Set DiagnosData=$g(^DHCHAI.IR.INFDiagnosD(+DiagnosDr))
				    Set InfPosDr=$lg(DiagnosData,3)
				    Set InfPosData=$g(^DHCHAI.BT.InfPosD(+InfPosDr))
				    Set InfPosDesc=$lg(InfPosData,3)
				   	Set InfSubDr=$lg(DiagnosData,4)
				    Set InfSubData=$g(^DHCHAI.BT.InfSubD(+InfSubDr))
				    Set InfSubDesc=$lg(InfSubData,3)
					Set InfPosDesc=$s(InfSubDesc'="":InfPosDesc_"-"_InfSubDesc,1:InfPosDesc)
				
					Set ActDate=xActDate
					Set ActTime=xActTime
					Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
					Set:ActTime'="" ActTime=$zt(ActTime,1)
					Set ActDateTime=ActDate_" "_ActTime
					Set (ActUserCode,ActUserDesc)=""
			   		Set ActUserDr	= $lg(ScreenDtlData,7)
			   		Set UserData=$g(^DHCHAI.BT.SysUserD(+ActUserDr))
			   		Set ActUserCode=$lg(UserData,2)
			   		Set ActUserDesc=$lg(UserData,3)
			   		
					Set Data=$lb(RuleNo,RuleType,RuleDetails,ItmScreenDr,ItmScreen,InfPosID,InfPosDesc,xScreenID,xDtlID,Status,InfPosDesc,ActDateTime,ActUserCode,ActUserDesc)_PatData
					Set ^CacheTemp(repid,ind)=Data
 					Set ind=ind+1
				}
			}
		}	
	}			
	

	Quit $$$OK
}

ClassMethod QrySuRuleOprDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuRuleOprDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySuRuleOprDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuRuleOprDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BuildPaadmData(aEpisodeID) As %String
{
	new (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:PAAdmData="" return
	
	Set EpisodeIDx = $li(PAAdmData,2)
	Set SCode = $p(EpisodeIDx,"||",1)
	Set PatientIDx = $li(PAAdmData,3)
	Set PapmiNo = $li(PAAdmData,4)
	Set MrNo = $li(PAAdmData,5)
	Set PatName = $li(PAAdmData,6)
	Set Sex = $li(PAAdmData,7)
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Age = $li(PAAdmData,37)
	Set AdmType = $li(PAAdmData,18)
	
	Set VisitStatus = $li(PAAdmData,19)
	Set VisitStatus = $s(VisitStatus="A":"在院",VisitStatus="D":"出院",VisitStatus="C":"退院",VisitStatus="P":"预住院",VisitStatus="U":"作废",1:"")
	Set AdmDate = $li(PAAdmData,20)
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = $li(PAAdmData,21)
	Set:AdmTime'="" AdmTime=$zt(AdmTime)

	Set AdmLocDr = $li(PAAdmData,22)
	Set AdmLocDesc=""
	Set LocData = $g(^DHCHAI.BT.LocationD(+AdmLocDr))
	If LocData'="" {
		Set LocDesc2 = $li(LocData,4)
		Set LocDesc  = $li(LocData,3)
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	
	Set DischDate = $li(PAAdmData,26)
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = $li(PAAdmData,27)
	Set:DischTime'="" DischTime=$zt(DischTime)
    
    Set DischLocDr = $li(PAAdmData,28)
    Set LocData=""
    If (DischLocDr'="") {
    	Set LocData = $g(^DHCHAI.BT.LocationD(DischLocDr))
    }
	Set DischLocDesc=""
	If LocData'="" {
		Set LocDesc2 = $li(LocData,4)
		Set LocDesc  = $li(LocData,3)
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	
	Set AdmDateTime=AdmDate_" "_AdmTime
	Set DischDateTime=DischDate_" "_DischTime
		
	Set return = $lb(aEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,VisitStatus,AdmDateTime,AdmLocDesc,DischDateTime,DischLocDesc)
	Quit return
}

}
