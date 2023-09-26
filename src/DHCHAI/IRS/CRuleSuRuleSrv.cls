/// 名称: DHCHAI.IRS.CRuleSuRuleSrv
/// 描述: 疑似病例筛查规则相关服务
/// 编写者：pylian
/// 编写日期: 2022-03-22
Class DHCHAI.IRS.CRuleSuRuleSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pyllian
/// CreatDate：   2022-03-22
/// Description:  查询疑似筛查规则项目
/// Table：       DHCHAI.IR.CRuleInfSuItem
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCHAI.IRS.CRuleSuRuleSrv","QrySuItem")
Query QrySuItem(aItemCate As %String = "") As %Query(ROWSPEC = "ItemID:%String,ItemDesc:%String,ItemDesc2:%String,Category:%String,InputDicTab:%String,InputMaxTab:%String,InputMaxTab:%String,MaxTabDesc:%String,InputMinTab:%String,MinTabDesc:%String,InputDayTab:%String,DayTabDesc:%String,InputCntTab:%String,CntTabDesc:%String,InputNote:%String") [ SqlProc ]
{
}

ClassMethod QrySuItemExecute(ByRef qHandle As %Binary, aItemCate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
    Set xItemID = ""
	For {
		Set xItemID = $o(^DHCHAI.IR.CRuleInfSuItemD(xItemID))
		Quit:xItemID=""
		
		Set obj = ##class(DHCHAI.IR.CRuleInfSuItem).GetObjById(xItemID)
		Continue:'$Isobject(obj)
		
		Set ItemDesc    = obj.BTItemDesc   
		Set ItemDesc2   = obj.BTItemDesc2  
		Set Category    = obj.BTCategory  
		Continue:(aItemCate'="")&(aItemCate'=Category) 
		Set InputDicTab = obj.BTInputDicTab
		Set InputMaxTab = obj.BTInputMaxTab
		Set MaxTabDesc = $s(InputMaxTab="1":"是",1:"否")
		Set InputMinTab = obj.BTInputMinTab
		Set MinTabDesc = $s(InputMinTab="1":"是",1:"否")
		Set InputDayTab = obj.BTInputDayTab
		Set DayTabDesc = $s(InputDayTab="1":"是",1:"否")
		Set InputCntTab = obj.BTInputCntTab
		Set CntTabDesc = $s(InputCntTab="1":"是",1:"否")
		Set InputNote   = obj.BTInputNote  

		Set Data=$lb(xItemID,ItemDesc,ItemDesc2,Category,InputDicTab,InputMaxTab,InputMaxTab,MaxTabDesc,InputMinTab,MinTabDesc,InputDayTab,DayTabDesc,InputCntTab,CntTabDesc,InputNote)
					
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QrySuItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySuItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuItemExecute ]
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

/// Creator：     pyllian
/// CreatDate：   2022-05-11
/// Description:  查询疑似筛查规则项目分类
/// Table：       DHCHAI.IR.CRuleInfSuItem
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCHAI.IRS.CRuleSuRuleSrv","QrySuItemCate")
Query QrySuItemCate() As %Query(ROWSPEC = "ind:%String,Category:%String") [ SqlProc ]
{
}

ClassMethod QrySuItemCateExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
    Set xItemCate = ""
	For {
		Set xItemCate = $o(^DHCHAI.IR.CRuleInfSuItemI("IdxOfCategory",xItemCate))
		Quit:xItemCate=""

		Set Data=$lb(ind,xItemCate)
					
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QrySuItemCateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuItemCateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySuItemCateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuItemCateExecute ]
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

/// 获取值域字典名称
/// w ##class(DHCHAI.IRS.CRuleSuRuleSrv).GetDicTabDesc("特定标本检出菌")
ClassMethod GetDicTabDesc(aItemDesc As %String) As %String
{
	New (aItemDesc)
	Set return=""
	Quit:aItemDesc="" return
	
	Set ItemDesc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(aItemDesc) //去掉特殊字符
	Set ID=$o(^DHCHAI.IR.CRuleInfSuItemI("IdxOfItemDesc"," "_$zcvt(ItemDesc,"U"),0))
	Set obj = ##class(DHCHAI.IR.CRuleInfSuItem).GetObjById(ID)
	Quit:'$Isobject(obj) return
	Set InputDicTab = obj.BTInputDicTab
	Set return = InputDicTab
	
	Quit return
}

/// Creator：     pyllian
/// CreatDate：   2022-03-22
/// Description:  医院感染疑似筛查规则
/// Table：       DHCHAI.IR.CRuleInfSuRule
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCHAI.IRS.CRuleSuRuleSrv","QrySuRule")
Query QrySuRule(aIsActive As %String = "") As %Query(ROWSPEC = "RuleID:%String,ItmScreenID:%String,ItmScreenDesc:%String,InfPosID:%String,InfPosDesc:%String:%String,RuleNo:%String,RuleType:%String,RuleNote:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUserDesc:%String,Threshold:%String") [ SqlProc ]
{
}

ClassMethod QrySuRuleExecute(ByRef qHandle As %Binary, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
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
		
			Set ItmScreenID = obj.BTItmScreenDr.%Id()
			Set ItmScreenDesc = obj.BTItmScreenDr.CCDesc 	
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
			Set IsActDesc = $s(IsActive="1":"是",1:"否")
			
			Set ActDate	  = obj.BTActDate	   
			Set ActTime	  = obj.BTActTime	  
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set:ActTime'="" ActTime = $zt(ActTime,1)
			Set (ActUserCode,ActUserDesc) = ""
			If $IsObject(obj.BTActUserDr) {	   
				Set ActUserCode = obj.BTActUserDr.BTCode
				Set ActUserDesc = obj.BTActUserDr.BTDesc
		    }
		    Set Threshold = obj.BTThreshold
			
			Set Data=$lb(xRuleID,ItmScreenID,ItmScreenDesc,InfPosID,InfPosDesc,RuleNo,RuleType,RuleNote,IsActive,IsActDesc,ActDate,ActTime,ActUserCode,ActUserDesc,Threshold)
					
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
 	}
	Quit $$$OK
}

ClassMethod QrySuRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuRuleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySuRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuRuleExecute ]
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

/// Creator：     pyllian
/// CreatDate：   2022-03-22
/// Description:  医院感染疑似筛查规则表达式
/// Table：       DHCHAI.IR.CRuleInfSuRuleExp
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCHAI.IRS.CRuleSuRuleSrv","QrySuRuleExp","41")
Query QrySuRuleExp(aRuleID As %String) As %Query(ROWSPEC = "ID:%String,RuleID:%String,ChildSubID:%String,ItemDesc:%String,InputDicSet:%String,InputMaxSet:%String,InputMinSet:%String,InputDaySet:%String,InputCntSet:%String,InputNote:%String,Weight:%String,InputSttDay:%String") [ SqlProc ]
{
}

ClassMethod QrySuRuleExpExecute(ByRef qHandle As %Binary, aRuleID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:aRuleID="" $$$OK
	
    Set xChildSub = ""
	For {
		Set xChildSub = $o(^DHCHAI.IR.CRuleInfSuRuleD(aRuleID,"EXP",xChildSub))
		Quit:xChildSub=""
		
		Set RuleExpID = aRuleID_"||"_xChildSub

		Set obj = ##class(DHCHAI.IR.CRuleInfSuRuleExp).GetObjById(RuleExpID)
		Continue:'$Isobject(obj)
		
		Set ItemDesc    = obj.BTItemDesc   
		Set InputDicSet = obj.BTInputDicSet
		Set InputMaxSet = obj.BTInputMaxSet
		Set InputMinSet = obj.BTInputMinSet
		Set InputDaySet = obj.BTInputDaySet
		Set InputCntSet = obj.BTInputCntSet
		Set InputNote   = obj.BTInputNote  
		Set Weight      = obj.BTWeight 
		Set SttDay      = obj.BTInputSttDay

		Set Data=$lb(RuleExpID,aRuleID,xChildSub,ItemDesc,InputDicSet,InputMaxSet,InputMinSet,InputDaySet,InputCntSet,InputNote,Weight,SttDay)				
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
 	}
	Quit $$$OK
}

ClassMethod QrySuRuleExpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuRuleExpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySuRuleExpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuRuleExpExecute ]
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

/// 导入疑似筛查规则项目
/// w ##class(DHCHAI.IRS.CRuleSuRuleSrv).ImportSuItem("1^症状或体征(体温+病程)^^症状或体征^^是^是^是^是^")
ClassMethod ImportSuItem(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=""
	Quit:aInputStr="" return
	
	Set InputMaxTab = $p(aInputStr,"^",6)
	Set InputMinTab = $p(aInputStr,"^",7)
	Set InputDayTab = $p(aInputStr,"^",8)
	Set InputCntTab = $p(aInputStr,"^",9)
	
	Set InputMaxTab=$s(InputMaxTab="是":1,1:"")
	Set InputMinTab=$s(InputMinTab="是":1,1:"")
	Set InputDayTab=$s(InputDayTab="是":1,1:"")
	Set InputCntTab=$s(InputCntTab="是":1,1:"")
	
	Set $p(aInputStr,"^",6) = InputMaxTab 
	Set $p(aInputStr,"^",7) = InputMinTab 
	Set $p(aInputStr,"^",8) = InputDayTab 
	Set $p(aInputStr,"^",9) = InputCntTab 
   
	Set return=##class(DHCHAI.IR.CRuleInfSuItem).Update(aInputStr,"^")
	Quit return
}

/// 导入疑似筛查规则
/// w ##class(DHCHAI.IRS.CRuleSuRuleSrv).ImportSuRule("1^20190621001^检出致病菌^^A^无菌部位标本检出菌^是^^^")
ClassMethod ImportSuRule(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=""
	Quit:aInputStr="" return
	
	Set ItmScreen = $p(aInputStr,"^",3)
	Set SuPos     = $p(aInputStr,"^",4)
	
	Quit:ItmScreen="" return
	Set ItmScreenDr=$o(^DHCHAI.IR.CCItmScreenI("IdxofDesc",ItmScreen,0))
	Quit:ItmScreenDr="" return
	Set SuPosDr=""
	Set:SuPos'="" SuPosDr=$o(^DHCHAI.BT.InfSuPosI("IdxofBTDiagnos",SuPos,0))
	Set IsActive = $p(aInputStr,"^",7)
	Set IsActive = $s(IsActive="是":1,1:"")
	Set Threshold = $p(aInputStr,"^",8)
	Set $p(aInputStr,"^",3)  = ItmScreenDr
	Set $p(aInputStr,"^",4)  = SuPosDr
	Set $p(aInputStr,"^",7)  = IsActive 
	Set $p(aInputStr,"^",11) = Threshold
	Set return=##class(DHCHAI.IR.CRuleInfSuRule).Update(aInputStr,"^")
	Quit return
}

/// 导入疑似筛查规则表达式
/// w ##class(DHCHAI.IRS.CRuleSuRuleSrv).ImportSuRuleExp("20220510001^病程症状或体征(+)^^^^^^入院2天内病程包含上呼吸道感染,咽炎,扁桃体炎,鼻炎,鼻窦炎,咽狭炎,鼻旁窦炎,喉炎^-2^2")
ClassMethod ImportSuRuleExp(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=""
	Quit:aInputStr="" return
	
	Set RuleNo   = $p(aInputStr,"^",1)
	Set ItemDesc = $p(aInputStr,"^",2)
	Set Parref=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleNo"," "_RuleNo,0))
	Quit:Parref="" return	
	Quit:'$d(^DHCHAI.IR.CRuleInfSuItemI("IdxOfItemDesc"," "_$zcvt(ItemDesc,"U"))) return
   
	Set xSub=""
	Set xSubID=""
	For {		
		Set xSubID=$o(^DHCHAI.IR.CRuleInfSuRuleI("EXP","IdxOfItemDesc",Parref," "_$zcvt(ItemDesc,"U"),xSubID))
		Quit:xSubID=""
	
	    Set objExp= ##class(DHCHAI.IR.CRuleInfSuRuleExp).GetObjById(Parref_"||"_xSubID)
		Continue:'$Isobject(objExp)
		Set InputNote = objExp.BTInputNote
		Set InputDicSet= objExp.BTInputDicSet	
		Continue:(InputNote'=$p(aInputStr,"^",8))||(InputDicSet '=$p(aInputStr,"^",3))    //判断备注项目、值域字典是否一样，一样则认为是覆盖更新，否则为新增
		Set xSub = xSubID
    }
	Set InputDicSet = $p(aInputStr,"^",3)
	Set InputMaxSet = $p(aInputStr,"^",4)
	Set InputMinSet = $p(aInputStr,"^",5)
	Set InputDaySet = $p(aInputStr,"^",6)
	Set InputCntSet = $p(aInputStr,"^",7)
	Set InputNote 	= $p(aInputStr,"^",8)
	Set Weight      = $p(aInputStr,"^",9)
	Set InputSttDay = $p(aInputStr,"^",10)

	Set InputStr=Parref_"^"_xSub_"^"_ItemDesc_"^"_InputDicSet_"^"_InputMaxSet_"^"_InputMinSet_"^"_InputDaySet_"^"_InputCntSet_"^"_InputNote_"^"_Weight_"^"_InputSttDay
	Set return=##class(DHCHAI.IR.CRuleInfSuRuleExp).Update(InputStr,"^")
	
	Quit return
}

}
