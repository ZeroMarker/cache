/// 名称: DHCHAI.DPS.DataMapRuleSrv
/// 描述: 匹配对照规则相关服务
/// 编写者：pylian
/// 编写日期: 2017-08-03
Class DHCHAI.DPS.DataMapRuleSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-08-03
/// Description:  查询匹配对照规则
/// Table：       DHCHAI.DP.DataMapRule
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.DataMapRuleSrv","QryMapRule")
Query QryMapRule() As %Query(ROWSPEC = "ID:%String,CatID:%String,CatCode:%String,CatDesc:%String,Desc:%String,MapDesc:%String,Type:%String,TypeDesc:%String") [ SqlProc ]
{
}

ClassMethod QryMapRuleExecute(ByRef qHandle As %Binary) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.DataMapRuleD(xID))
		Quit:xID=""
	  
		Set objRule = ##class(DHCHAI.DP.DataMapRule).GetObjById(xID)
		Continue:'$Isobject(objRule)
			
		Set CatID="",CatCode="",CatDesc=""
		If $IsObject(objRule.BTCatDr){
			Set CatID   = objRule.BTCatDr.%Id()
			Set CatCode = objRule.BTCatDr.BTCode
			Set CatDesc = objRule.BTCatDr.BTDesc
		}
		Set Desc     = objRule.BTDesc 
	    Set MapDesc  = objRule.BTMapDesc 
	    Set Type     = objRule.BTType
	    Set TypeDesc = $s(Type=0:"匹配",Type=1:"包含",Type=2:"排除")
	    
		Set Data = $lb(xID,CatID,CatCode,CatDesc,Desc,MapDesc,Type,TypeDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryMapRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapRuleExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMapRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapRuleExecute ]
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
/// CreatDate：   2017-08-03
/// Description:  根据分类查询匹配对照规则
/// Table：       DHCHAI.DP.DataMapRule
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.DataMapRuleSrv","QryRulebByCat","")
Query QryRulebByCat(aCatID As %String, aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,CatID:%String,CatCode:%String,CatDesc:%String,Desc:%String,MapDesc:%String,Type:%String,TypeDesc:%String") [ SqlProc ]
{
}

ClassMethod QryRulebByCatExecute(ByRef qHandle As %Binary, aCatID As %String, aAlias As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Quit:(aCatID="") $$$OK
    
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.DataMapRuleI("IndexCat",aCatID,xID))
		Quit:xID=""
	  
		Set objRule = ##class(DHCHAI.DP.DataMapRule).GetObjById(xID)
		Continue:'$Isobject(objRule)
			
		Set objCat = ##class(DHCHAI.BT.Dictionary).GetObjById(aCatID)
		Continue:'$Isobject(objCat)
		Set CatCode = objCat.BTCode
		Set CatDesc = objCat.BTDesc
		
		Set Desc    = objRule.BTDesc 
	    Set MapDesc = objRule.BTMapDesc 
	    Continue:(aAlias'="")&&('(Desc[aAlias))&&('(MapDesc[aAlias))
	    Set Type    = objRule.BTType
	    Set TypeDesc = $s(Type=0:"匹配",Type=1:"包含",Type=2:"排除")
	    
		Set Data = $lb(xID,aCatID,CatCode,CatDesc,Desc,MapDesc,Type,TypeDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryRulebByCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRulebByCatExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRulebByCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRulebByCatExecute ]
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
/// CreatDate：   2017-11-19
/// Description:  导入数据标准对照知识库
/// w ##Class(DHCHAI.DPS.DataMapRuleSrv).ImportMapKeys("RMEInfKeyMap^感染^感染;炎")
ClassMethod ImportMapKeys(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set CatCode   = $p(aInputStr,"^",1)
	Set MapDesc   = $p(aInputStr,"^",2)
	Set MapWords  = $p(aInputStr,"^",3)
	Set Type      = +$p(aInputStr,"^",4)
	Quit:(CatCode="")||(MapDesc="")||(MapWords="") return
	
	Set objCat=##class(DHCHAI.BT.Dictionary).GetObjByCode("MapRule",CatCode)
	Quit:'$IsObject(objCat) return
	Set CatDr=objCat.%Id()
	Set MapDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(MapDesc)  //去掉特殊字符
	
	Set Count=0
	For indMW=1:1:$l(MapWords,";"){
		Set tWord=$p(MapWords,";",indMW)
		Continue:tWord=""
		
		Set ID=$o(^DHCHAI.DP.DataMapRuleI("IndexCatDescUnique",CatDr," "_$zcvt(MapDesc,"U")," "_$zcvt(tWord,"U"),0))
		Set InputStr=ID_"^"_CatDr_"^"_MapDesc_"^"_tWord_"^"_Type
		Set flg=##class(DHCHAI.DP.DataMapRule).Update(InputStr)
		If (+flg)>0 {
			Set Count=Count+1
		}
	}
	Set return=Count
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-11-26
/// Description:  导入数据标化规则
/// w ##Class(DHCHAI.DPS.DataMapRuleSrv).ImportMapRules("Ⅰ类^OROperDx^Ⅰ^1")
ClassMethod ImportMapRules(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set MapDesc   = $p(aInputStr,"^",1)
	Set CatCode   = $p(aInputStr,"^",2)
	Set MapWord   = $p(aInputStr,"^",3)
	Set Type      = +$p(aInputStr,"^",4)
	Quit:(CatCode="")||(MapDesc="")||(MapWord="")||(Type="") return
	
	Set objCat=##class(DHCHAI.BT.Dictionary).GetObjByCode("MapRule",CatCode)
	Quit:'$IsObject(objCat) return
	Set CatDr=objCat.%Id()
	Set MapDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(MapDesc)  //去掉特殊字符
	
	Set ID=$o(^DHCHAI.DP.DataMapRuleI("IndexCatDescUnique",CatDr," "_$zcvt(MapDesc,"U")," "_$zcvt(MapWord,"U"),0))
	Set InputStr=ID_"^"_CatDr_"^"_MapDesc_"^"_MapWord_"^"_Type
	Set flg=##class(DHCHAI.DP.DataMapRule).Update(InputStr)
	Set return=flg
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-08-06
/// Description:  通过对照规则取标准名称
/// Table：       DHCHAI.DP.DataMapRule
/// Input：       aCatDr   ：类型Dr
///               aMapDesc : 对照名称
/// w ##Class(DHCHAI.DPS.DataMapRuleSrv).GetRuleByMapDesc("120","腹腔脓液")
ClassMethod GetRuleByMapDesc(aCatDr As %String, aMapDesc As %String, aFlag As %String = "1") As %String
{
	New (aCatDr,aMapDesc,aFlag)
	Set return=""
	Quit:(aCatDr="")||(aMapDesc="") return
	
	Set aMapDesc=$tr(aMapDesc," ","")
	Quit:aMapDesc="" return
	Kill arrDataMapRule
	
	Set aMapDesc=$zcvt(aMapDesc,"U")
	
	//匹配
	Set xRuleDr=0
	For {
		Set xRuleDr=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatDr,0,$zcvt(aMapDesc,"U"),xRuleDr))
		Quit:xRuleDr=""
		Set objRule=##class(DHCHAI.DP.DataMapRule).GetObjById(xRuleDr)
		Continue:'$IsObject(objRule)
		Set BTDesc=objRule.BTDesc
		Set MapDesc=objRule.BTMapDesc
		Set arrDataMapRule("Map",BTDesc,MapDesc)=""
	}
	
	//包含
	Set xMapDesc=""
	For {
		Set xMapDesc=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatDr,1,xMapDesc))
		Quit:xMapDesc=""
		Continue:$zcvt(aMapDesc,"U")'[$zcvt(xMapDesc,"U")
		
		Set xRuleDr=0
		For {
			Set xRuleDr=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatDr,1,xMapDesc,xRuleDr))
			Quit:xRuleDr=""
			
			Set objRule=##class(DHCHAI.DP.DataMapRule).GetObjById(xRuleDr)
			Continue:'$IsObject(objRule)
			Set BTDesc=objRule.BTDesc
			Set MapDesc=objRule.BTMapDesc
			
			//排除
			Set IsDelFlag=0
			Set xDelDesc=""
			For {
				Set xDelDesc=$o(^DHCHAI.DP.DataMapRuleI("IndexCatDescMapDesc",aCatDr,2,BTDesc,xDelDesc))
				Quit:xDelDesc=""
				Continue:$zcvt(aMapDesc,"U")'[$zcvt(xDelDesc,"U")
				Set IsDelFlag=1
				Quit
			}
			Continue:IsDelFlag>0
			
			Set arrDataMapRule("Map",BTDesc,MapDesc)=""
		}
	}
	
	//去重
	If aFlag>0 {
		Set xDesc=""
		For {
			Set xDesc=$o(arrDataMapRule("Map",xDesc))
			Quit:xDesc=""
			
			Set IsActive=0
			Set xMapDesc=""
			For {
				Set xMapDesc=$o(arrDataMapRule("Map",xDesc,xMapDesc))
				Quit:xMapDesc=""
				Continue:+$g(arrDataMapRule("Map",xDesc,xMapDesc))<0
				
				Set yDesc=""
				For {
					Set yDesc=$o(arrDataMapRule("Map",yDesc))
					Quit:yDesc=""
					Continue:yDesc=xDesc
					
					Set yMapDesc=""
					For {
						Set yMapDesc=$o(arrDataMapRule("Map",yDesc,yMapDesc))
						Quit:yMapDesc=""
						Continue:+$g(arrDataMapRule("Map",yDesc,yMapDesc))<0
						
						If yMapDesc[xMapDesc {
							Set arrDataMapRule("Map",xDesc,xMapDesc)=-1
						} ElseIf xMapDesc[yMapDesc {
							Set arrDataMapRule("Map",yDesc,yMapDesc)=-1
						}
					}
				}
				Continue:+$g(arrDataMapRule("Map",xDesc,xMapDesc))<0
				Set IsActive=1
			}
			Continue:IsActive<1
			Set return=return_"^"_xDesc
		}
	}
	//zw arrDataMapRule
	Kill arrDataMapRule
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

}
