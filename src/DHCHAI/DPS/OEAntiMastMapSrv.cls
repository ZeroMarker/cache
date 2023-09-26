/// 名称: DHCHAI.DPS.OEAntiMastMapSrv
/// 描述: 医嘱-抗菌药物对照相关服务
/// 编写者：maxiangping
/// 编写日期: 2017-05-05
Class DHCHAI.DPS.OEAntiMastMapSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     maxp
/// CreatDate：   2017-05-05
/// Description:  查询列表
/// Table：       DHCHAI.DP.OEAntiMastMap
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.OEAntiMastMapSrv","QryOEAntiMastMap")
Query QryOEAntiMastMap(aFlg As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,BTAnitDesc:%String,BTMapItemDr:%String,BTMapItemCode:%String,BTMapItemDesc:%String,BTMapCatDr:%String,BTMapCatCode:%String,BTMapCatDesc:%String,BTMapNote:%String,BTSCode:%String,BTIsActive:%String,BTActDate:%String,BTActTime:%String,BTActUserDr:%String,BTActUser:%String,HospGroup:%String,PHCGeneric:%String,PHChemical:%String") [ SqlProc ]
{
}

ClassMethod QryOEAntiMastMapExecute(ByRef qHandle As %Binary, aFlg As %String = "", aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xBTSCode=""
	For {
		Set xBTSCode=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",xBTSCode))
		Quit:xBTSCode=""
		
		Set xItemAnit=""
		For {
			Set xItemAnit=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",xBTSCode,xItemAnit))
			Quit:xItemAnit=""
		
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",xBTSCode,xItemAnit,xID))
				Quit:xID=""
	 	
	 			Set obj=##class(DHCHAI.DP.OEAntiMastMap).GetObjById(xID)
				Continue:'$IsObject(obj)
				
				Set BTAnitDesc=obj.BTAnitDesc
				Set BTMapItemDr="",BTMapItemCode="",BTMapItemDesc=""
				Set BTMapCatDr="",BTMapCatCode="",BTMapCatDesc=""
				Continue:(aAlias'="")&&('(BTAnitDesc[aAlias))
				If $IsObject(obj.BTMapItemDr) {
					Set BTMapItemDr=obj.BTMapItemDr.%Id()
					Set BTMapItemCode=obj.BTMapItemDr.BTCode
					Set BTMapItemDesc=obj.BTMapItemDr.BTName
				    Set objMast=##class(DHCHAI.DP.OEAntiMast).GetObjById(BTMapItemDr)
					Continue:'$Isobject(objMast)
					If $IsObject(objMast.BTCatDr) {
						Set BTMapCatDr=objMast.BTCatDr.%Id()
						Set BTMapCatCode=objMast.BTCatDr.BTCode
						Set BTMapCatDesc=objMast.BTCatDr.BTDesc
					} 
					
				}
				Continue:(aFlg=0)&&(BTMapItemDr'="")
				Continue:(aFlg=1)&&(BTMapItemDr="")
				Set BTMapNote=obj.BTMapNote
				Set BTSCode=obj.BTSCode
				Set HospGroup=""
				Set objSystem=##class(DHCHAI.BT.SystemMap).GetObjByCode(BTSCode)
				If $IsObject(objSystem) {
					Set HospGroup=objSystem.BTHospDr.BTGroupDr.BTDesc
				}
				Set IsActive=obj.BTIsActive
				Continue:(aFlg=0)&&(IsActive'=1) //未对照不显示无效项目
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
			
				Set PHCGeneric = obj.BTGeneric  
				Set PHChemical = obj.BTChemical 
				//多语言处理
				Set BTAnitDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("ARCIMDesc",BTAnitDesc,"User.ARCItmMast")
				Set Data=$lb(xID,BTAnitDesc,BTMapItemDr,BTMapItemCode,BTMapItemDesc,BTMapCatDr,BTMapCatCode,BTMapCatDesc,BTMapNote,BTSCode,IsActive,ActDate,ActTime,ActUserDr,ActUser,HospGroup,PHCGeneric,PHChemical)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryOEAntiMastMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOEAntiMastMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOEAntiMastMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOEAntiMastMapExecute ]
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
/// CreatDate：   2017-08-06
/// Description:  更新抗菌药物对照
/// Table：       DHCHAI.DP.OEAntiMastMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DPS.OEAntiMastMapSrv).UpdateMap("1","1","9")
ClassMethod UpdateMap(ID As %String, MastID As %String, UserID As %String) As %String
{
	New (ID,MastID,UserID)
	Set return=0
	Quit:(ID="")||(MastID="") return
	
	Set objMapItem = ##class(DHCHAI.DP.OEAntiMast).GetObjById(MastID)
	Set objUser = ##class(DHCHAI.BT.SysUser).GetObjById(UserID)
	
	Set obj=##class(DHCHAI.DP.OEAntiMastMap).%OpenId(ID)
	Quit:'$IsObject(obj) return
	Set obj.BTMapItemDr	= objMapItem
	Set obj.BTActUser = objUser
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
		Do $system.OBJ.DisplayError(sc)
		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-08-06
/// Description:  自动匹配对照规则
/// Table：       DHCHAI.DP.DataMapRule,DHCHAI.DP.OEAntiMast,DHCHAI.DP.OEAntiMastMap
/// Input：		  aCatID：匹配规则表DHCHAI.DP.DataMapRule.ID
/// Return：      正常：处理数据条数
/// w ##Class(DHCHAI.DPS.OEAntiMastMapSrv).SynMapRule("抗菌药物医嘱")
ClassMethod SynMapRule(aCatDesc As %String) As %String
{
	New (aCatDesc)
	Set return=""
	Quit:(aCatDesc="") return
	
	Set aCatID=""
	Set objDic  = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("MapRule",aCatDesc)
	If $Isobject(objDic) {
		Set aCatID = objDic.%Id()
	}
	Quit:(aCatID="") return
	
	Set Count=0	
    Set xSCode =""
    For {
	    Set xSCode=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",xSCode))
	    Quit:xSCode=""
	    
	    Set xAnitDesc=""
	    For {  
			Set xAnitDesc=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",xSCode,xAnitDesc))
		    Quit:xAnitDesc=""
		   
		    Set xMapID=""
		    For {  
				Set xMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",xSCode,xAnitDesc,xMapID))
			    Quit:xMapID=""
				
				Set objMap=##class(DHCHAI.DP.OEAntiMastMap).GetObjById(xMapID)
				Continue:'$Isobject(objMap)
				Set MapNote  = objMap.BTMapNote
				Continue:objMap.BTMapItemDr'=""  //已经存在不再同步匹配
				Set SCode    = objMap.BTSCode
				Set IsActive = objMap.BTIsActive
				Set AnitDesc = objMap.BTAnitDesc
				Continue:AnitDesc=""
				Set PHCGeneric = objMap.BTGeneric  //药品通用名 add by zf 20171128
				Set PHChemical = objMap.BTChemical //药品化学名 add by zf 20171128
				
				Set MastID = $o(^DHCHAI.DP.OEAntiMastI("IndexName",AnitDesc,0))  //名称一样可直接匹配
				If (MastID=""){
			     	Set Desc=""
					Set MapRuleID=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatID,0,AnitDesc,0))  //匹配
					//根据药品通用名匹配 add by zf 20171128
					If (MapRuleID="")&(PHCGeneric'="") {
						Set MapRuleID=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatID,0,PHCGeneric,0))  //匹配
					}
					//根据药品化学名匹配 add by zf 20171128
					If (MapRuleID="")&(PHChemical'="") {
						Set MapRuleID=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatID,0,PHChemical,0))  //匹配
					}
					If MapRuleID'="" {
						Set objRule=##class(DHCHAI.DP.DataMapRule).GetObjById(MapRuleID)
						Continue:'$Isobject(objRule)
						Set Desc=objRule.BTDesc
					} Else  {
						
						Set xMapDesc=""   // 包含（排除）规则
						Set tmpMapDesc=""
						For {
							Set xMapDesc = $o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatID,1,xMapDesc))
							Quit:xMapDesc=""
						    
		   				    If (PHCGeneric'="") {
							 	If (PHCGeneric'[xMapDesc) {
									Continue:(AnitDesc'[xMapDesc)	
							 	}
							 }Else {
								 Continue:(AnitDesc'[xMapDesc)
							 }
							Set tmpMapDesc=tmpMapDesc_$lb(xMapDesc)  //组合包含所有的语句
						}
						Continue:tmpMapDesc=""
						
						Set tKeyword="",Flag=0,ret=0
						If $ll(tmpMapDesc)>1 {
						
							If (PHCGeneric'="") {
								For indP=1:1:$l(PHCGeneric) {
									For indLg=($l(PHCGeneric)-indP):-1:0 {
										Set tKeyword=$e(PHCGeneric,indP,indP+indLg)
										Continue:tKeyword=""
										
										Set tMapDesc=""
										For indLLg=1:1:$ll(tmpMapDesc) {
											Set tMapDesc=$listget(tmpMapDesc,indLLg)
											Continue:tMapDesc=""
											Continue:tKeyword'=tMapDesc   //最大相等										
											Set xMapDesc=tMapDesc
										    Set ret=1							   
										    Quit
										}
										Quit:ret=1
									}
									Quit:ret=1
									
								}					
							}
							If (xMapDesc=""){
								For indK=1:1:$l(AnitDesc) {
									For indLn=($l(AnitDesc)-indK):-1:0 {
										Set tKeyword=$e(AnitDesc,indK,indK+indLn)
										Continue:tKeyword=""
										Set tMapDesc=""
										For indLL=1:1:$ll(tmpMapDesc) {
											Set tMapDesc=$listget(tmpMapDesc,indLL)
											Continue:tMapDesc=""
											Continue:tKeyword'=tMapDesc   //最大相等
											Set xMapDesc=tMapDesc
										    Set Flag=1
										    Quit
										}
										Quit:Flag=1
									}
									Quit:Flag=1
								}
						    }
						   
						} Else {
							Set xMapDesc=$listget(tmpMapDesc)
						}
					   
						Set MapRuleID=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatID,1,xMapDesc,0))
						Set objRule=##class(DHCHAI.DP.DataMapRule).GetObjById(MapRuleID)
						Continue:'$Isobject(objRule)
						Set tDesc=objRule.BTDesc
						Set xExID="",Flg=0 
						For {
							Set xExID=$o(^DHCHAI.DP.DataMapRuleI("IndexDesc",tDesc,xExID))
							Quit:xExID=""
							
							Set objExRule = ##class(DHCHAI.DP.DataMapRule).GetObjById(xExID)
							Continue:'$Isobject(objExRule)
							Set Type =	objExRule.BTType
							Continue:Type'=2
							Set ExMapDesc = objExRule.BTMapDesc
							Continue:AnitDesc'[ExMapDesc
							Set Flg=1
							Quit
						}
						Continue:Flg>0
						Set Desc=tDesc
					}
					Continue:Desc=""
					Set MastID = $o(^DHCHAI.DP.OEAntiMastI("IndexName",Desc,0))
					Continue:MastID=""
				}
				
				Set InputStr=xMapID
				Set InputStr=InputStr_"^"_AnitDesc
				Set InputStr=InputStr_"^"_PHCGeneric  //药品通用名 add by zf 20171128
				Set InputStr=InputStr_"^"_PHChemical  //药品化学名 add by zf 20171128
				Set InputStr=InputStr_"^"_MastID
				Set InputStr=InputStr_"^"_MapNote
				Set InputStr=InputStr_"^"_SCode
				Set InputStr=InputStr_"^"_(+IsActive)
				
		        Set flg=##class(DHCHAI.DP.OEAntiMastMap).Update(InputStr,"^")
		        
		        If flg>0{
					Set Count=Count+1
				}
		    }
	    }
    }
	Quit Count
}

/// Creator：     chenjb
/// CreatDate：   2017-01-17
/// Description:  更新抗菌药物分类对照
/// Table：       DHCHAI.DP.OEAntiMastMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DPS.OEAntiMastMapSrv).UpdateActive("32^备注^0^^^")
ClassMethod UpdateActive(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID			= $p(InStr,aSeparete,1)	
	Set MapNote		= $p(InStr,aSeparete,2)
	Set IsActive	= +$p(InStr,aSeparete,3)
	Set ActDate		= $p(InStr,aSeparete,4)
	Set ActTime		= $p(InStr,aSeparete,5)
	Set ActUser		= $p(InStr,aSeparete,6)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(ID="")||(IsActive="") return
	Set obj=##class(DHCHAI.DP.OEAntiMastMap).%OpenId(ID)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUser)
	Quit:'$IsObject(obj) return	
	
	Set obj.BTMapNote	= MapNote
	Set obj.BTIsActive	= IsActive
	Set obj.BTActDate	= ActDate
	Set obj.BTActTime	= ActTime
	Set obj.BTActUser	= objActUser

	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

}
