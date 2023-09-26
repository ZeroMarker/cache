/// 名称: DHCHAI.BTS.InfPosGistSrv
/// 描述: 诊断依据相关服务
/// 编写者：pylian
/// 编写日期: 2018-01-04
Class DHCHAI.BTS.InfPosGistSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2018-01-04
/// Description:  根据感染诊断查询诊断依据
/// Table：       DHCHAI.BT.InfPosGist
/// Input：       aInfPosID: 感染诊断ID  
/// Return： 
/// D ##class(%ResultSet).RunQuery("DHCHAI.BTS.InfPosGistSrv","QryGistByInfPos",2)
Query QryGistByInfPos(aInfPosID As %String) As %Query(ROWSPEC = "ID:%String,TypeDr:%String,TypeCode:%String,TypeDesc:%String,Code:%String,Desc:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryGistByInfPosExecute(ByRef qHandle As %Binary, aInfPosID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aInfPosID="" $$$OK
 	
 	Kill ^TMP($ZN,$J,"QryGistByInfPos")
 	Set xDesc =""
	For {
		Set xDesc = $o(^DHCHAI.BT.InfPosGistI("IdxofInfPosDr",aInfPosID,xDesc))
		Quit:xDesc=""
		
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.BT.InfPosGistI("IdxofInfPosDr",aInfPosID,xDesc,xID))
			Quit:xID=""
			
	 	    Set objGist = ##class(DHCHAI.BT.InfPosGist).GetObjById(xID)
			Continue:'$Isobject(objGist)
			Continue:'$IsObject(objGist.BTInfPosDr)
			Set InfPosGCode=objGist.BTInfPosDr.BTGCode
			
		 	Set (TypeDr,TypeCode,TypeDesc)=""
			If $IsObject(objGist.BTTypeDr) {
				Set TypeDr 	 = objGist.BTTypeDr.%Id()
				Set TypeCode = objGist.BTTypeDr.BTCode
				Set TypeDesc = objGist.BTTypeDr.BTDesc
			}
			Set Code    = objGist.BTCode
			Set Desc    = objGist.BTDesc
			Set ActDate = objGist.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime = objGist.BTActTime
		    Set:ActTime'="" ActTime=$zt(ActTime,1)
			Set ActUserCode="",ActUserDesc=""
			If $IsObject(objGist.BTActUserDr) {
				Set ActUserCode = objGist.BTActUserDr.BTCode
				Set ActUserDesc = objGist.BTActUserDr.BTDesc
			}
			Set Data=$lb(xID,TypeDr,TypeCode,TypeDesc,Code,Desc,ActDate,ActTime,ActUserCode,ActUserDesc)
			Set ^TMP($ZN,$J,"QryGistByInfPos"," "_InfPosGCode,Code,xID)=Data
		}
	}
	
	Set xGCode=""
	For {
		Set xGCode=$o(^TMP($ZN,$J,"QryGistByInfPos",xGCode))
		Quit:xGCode=""
		Set xCode=""
		For {
			Set xCode=$o(^TMP($ZN,$J,"QryGistByInfPos",xGCode,xCode))
			Quit:xCode=""
			Set xID=0
			For {
				Set xID=$o(^TMP($ZN,$J,"QryGistByInfPos",xGCode,xCode,xID))
				Quit:xID=""
				Set Data=$g(^TMP($ZN,$J,"QryGistByInfPos",xGCode,xCode,xID))
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
 	Kill ^TMP($ZN,$J,"QryGistByInfPos")
 	
	Quit $$$OK
}

ClassMethod QryGistByInfPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGistByInfPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGistByInfPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGistByInfPosExecute ]
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
/// CreatDate：   2018-01-04
/// Description:  查询诊断依据
/// Table：       DHCHAI.BT.InfPosGist
/// Input：       aInfPosID: 感染诊断ID        
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCHAI.BTS.InfPosGistSrv","QryInfPosGist","","2")
Query QryInfPosGist(aTypeCode As %String, aInfPosID As %String) As %Query(ROWSPEC = "ID:%String,InfPosID:%String,InfPos:%String,TypeDr:%String,TypeCode:%String,TypeDesc:%String,BTCode:%String,BTDesc:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosGistExecute(ByRef qHandle As %Binary, aTypeCode As %String, aInfPosID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Kill ^TMP($ZN,$J,"QryInfPosGist")
 	Set xInfPosID=""
	For {
		Set xInfPosID=$o(^DHCHAI.BT.InfPosGistI("IdxofInfPosDr",xInfPosID))
		Quit:xInfPosID=""
		
	 	Continue:(aInfPosID'="")&(aInfPosID'=xInfPosID)
	 	Set objPos = ##class(DHCHAI.BT.InfPos).GetObjById(xInfPosID)
		Continue:'$Isobject(objPos)
		Set InfPos = objPos.BTDesc
		
	 	Set xDesc=""
		For {
			Set xDesc=$o(^DHCHAI.BT.InfPosGistI("IdxofInfPosDr",xInfPosID,xDesc))
			Quit:xDesc=""
	 	 	
		 	Set xID=""
			For {
				Set xID=$o(^DHCHAI.BT.InfPosGistI("IdxofInfPosDr",xInfPosID,xDesc,xID))
				Quit:xID=""
				
		 	    Set objGist=##class(DHCHAI.BT.InfPosGist).GetObjById(xID)
				Continue:'$Isobject(objGist)
				Continue:'$IsObject(objGist.BTInfPosDr)
				Set InfPosGCode=objGist.BTInfPosDr.BTGCode
				
			 	Set (TypeDr,TypeCode,TypeDesc)=""
				If $IsObject(objGist.BTTypeDr) {
					Set TypeDr 	 = objGist.BTTypeDr.%Id()
					Set TypeCode = objGist.BTTypeDr.BTCode
					Set TypeDesc = objGist.BTTypeDr.BTDesc
				}
				Continue:(aTypeCode'="")&(aTypeCode'=TypeCode)
				
				Set Code    = objGist.BTCode
				Set Desc    = objGist.BTDesc
				Set ActDate = objGist.BTActDate
				Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
				Set ActTime = objGist.BTActTime
			    Set:ActTime'="" ActTime=$zt(ActTime,1)
				Set ActUserCode="",ActUserDesc=""
				If $IsObject(objGist.BTActUserDr) {
					Set ActUserCode = objGist.BTActUserDr.BTCode
					Set ActUserDesc = objGist.BTActUserDr.BTDesc
				}
				
				Set Data=$lb(xID,xInfPosID,InfPos,TypeDr,TypeCode,TypeDesc,Code,Desc,ActDate,ActTime,ActUserCode,ActUserDesc)
				Set ^TMP($ZN,$J,"QryInfPosGist"," "_InfPosGCode,Code,xID)=Data
			}
		}
	}
	
	Set xGCode=""
	For {
		Set xGCode=$o(^TMP($ZN,$J,"QryInfPosGist",xGCode))
		Quit:xGCode=""
		Set xCode=""
		For {
			Set xCode=$o(^TMP($ZN,$J,"QryInfPosGist",xGCode,xCode))
			Quit:xCode=""
			Set xID=0
			For {
				Set xID=$o(^TMP($ZN,$J,"QryInfPosGist",xGCode,xCode,xID))
				Quit:xID=""
				Set Data=$g(^TMP($ZN,$J,"QryInfPosGist",xGCode,xCode,xID))
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
 	Kill ^TMP($ZN,$J,"QryInfPosGist")
	
	Quit $$$OK
}

ClassMethod QryInfPosGistClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosGistExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPosGistFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosGistExecute ]
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
/// CreatDate：   2019-04-04
/// Description:  查询诊断依据（树形网格）
/// Table：       DHCHAI.BT.InfPosGist
/// Input：       aInfPosID: 感染诊断ID        
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCHAI.BTS.InfPosGistSrv","QryPosGistTree","","2")
Query QryPosGistTree(aTypeCode As %String, aInfPosID As %String) As %Query(ROWSPEC = "RowId:%String,RowDesc:%String,ID:%String,InfPosID:%String,InfPos:%String,TypeDr:%String,TypeCode:%String,TypeDesc:%String,BTCode:%String,BTDesc:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUserDesc:%String,_parentId:%String") [ SqlProc ]
{
}

ClassMethod QryPosGistTreeExecute(ByRef qHandle As %Binary, aTypeCode As %String, aInfPosID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 
 	Set rowIdField=0
 	Set xInfPosID=""
	For {
		Set xInfPosID=$o(^DHCHAI.BT.InfPosGistI("IdxofInfPosDr",xInfPosID))
		Quit:xInfPosID=""
		
	 	Continue:(aInfPosID'="")&(aInfPosID'=xInfPosID)
	 	Set objPos = ##class(DHCHAI.BT.InfPos).GetObjById(xInfPosID)
		Continue:'$Isobject(objPos)
		Set InfPos = objPos.BTDesc
		
		Set rowIdField=rowIdField+1,rowTreeField=InfPos
		Set Data = $lb(rowIdField,rowTreeField,"",xInfPosID,InfPos,"","","","","","","","","","")
	
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
		Set ParentId=rowIdField	
	 	Set xDesc=""
		For {
			Set xDesc=$o(^DHCHAI.BT.InfPosGistI("IdxofInfPosDr",xInfPosID,xDesc))
			Quit:xDesc=""
	 	 	
		 	Set xID=""
			For {
				Set xID=$o(^DHCHAI.BT.InfPosGistI("IdxofInfPosDr",xInfPosID,xDesc,xID))
				Quit:xID=""
				
		 	    Set objGist=##class(DHCHAI.BT.InfPosGist).GetObjById(xID)
				Continue:'$Isobject(objGist)
				Continue:'$IsObject(objGist.BTInfPosDr)
				Set InfPosGCode=objGist.BTInfPosDr.BTGCode
				
			 	Set (TypeDr,TypeCode,TypeDesc)=""
				If $IsObject(objGist.BTTypeDr) {
					Set TypeDr 	 = objGist.BTTypeDr.%Id()
					Set TypeCode = objGist.BTTypeDr.BTCode
					Set TypeDesc = objGist.BTTypeDr.BTDesc
				}
				Continue:(aTypeCode'="")&(aTypeCode'=TypeCode)
				
				Set Code    = objGist.BTCode
				Set Desc    = objGist.BTDesc
				Set ActDate = objGist.BTActDate
				Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
				Set ActTime = objGist.BTActTime
			    Set:ActTime'="" ActTime=$zt(ActTime,1)
				Set ActUserCode="",ActUserDesc=""
				If $IsObject(objGist.BTActUserDr) {
					Set ActUserCode = objGist.BTActUserDr.BTCode
					Set ActUserDesc = objGist.BTActUserDr.BTDesc
				}
				//多语言处理诊断依据描述和类型
				Set TypeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",TypeDesc,"DHCHAI.BT.Dictionary")
				Set Desc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",Desc,"DHCHAI.BT.InfPosGist")
				Set rowIdField=rowIdField+1,rowTreeField=Desc		
				Set Data = $lb(rowIdField,rowTreeField,xID,xInfPosID,InfPos,TypeDr,TypeCode,TypeDesc,Code,Desc,ActDate,ActTime,ActUserCode,ActUserDesc,ParentId)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryPosGistTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPosGistTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPosGistTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPosGistTreeExecute ]
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
/// CreatDate：   2018-01-05
/// Description:  导入感染诊断诊断依据
/// Table：       DHCHAI.BT.InfPosGist
/// Input：       诊断依据字符串,"^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.BTS.InfPosGistSrv).ImportInfPosGist("上呼吸道感染^临床诊断^1^炎症表现","^")
ClassMethod ImportInfPosGist(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"

	Set InfPos = $p(aInput,aSeparate,1)  //感染诊断名称
	Set Type   = $p(aInput,aSeparate,2)  //诊断依据类型
	Set Code   = $p(aInput,aSeparate,3)  //诊断依据代码
	Set Desc   = $p(aInput,aSeparate,4)  //诊断依据内容
	Quit:(InfPos="")||(Type="") return
	
	Set InfPosID=$o(^DHCHAI.BT.InfPosI("IdxofDesc",InfPos,0))
	Quit:InfPosID="" return
	
	Set TypeDr=""
	Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("DiagBasisType",Type)
	Set:$Isobject(objDic) TypeDr = objDic.%Id()
	
	Set InputStr=""                            //ID
	Set InputStr=InputStr_aSeparate_InfPosID   //感染诊断ID
	Set InputStr=InputStr_aSeparate_TypeDr     //诊断依据类型ID
	Set InputStr=InputStr_aSeparate_Code       //诊断依据代码
	Set InputStr=InputStr_aSeparate_Desc       //诊断依据内容
	
	Set return=##Class(DHCHAI.BT.InfPosGist).Update(InputStr,aSeparate)
	Quit return
}

}
