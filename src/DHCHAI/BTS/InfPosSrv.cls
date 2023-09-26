/// 名称: DHCHAI.BTS.InfPosSrv
/// 描述: 感染部位业务处理
/// 编写者：zhoubo
/// 编写日期: 2017-05-04
Class DHCHAI.BTS.InfPosSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-05-04
/// Description:  查询感染诊断（部位）信息
/// Table：       DHCHAI.BT.InfPos
/// Input：       aPosFlg:  1:查询感染部位 其他:查询所有
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.InfPosSrv","QryInfPos","1")
Query QryInfPos(aPosFlg As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,DiagFlag:%String,GCode:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosExecute(ByRef qHandle As %Binary, aPosFlg As %String = "", aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Set:aPosFlg["#" aPosFlg=$p(aPosFlg,"#",2)
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode,xID))
			Quit:xID=""
			Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(xID)
			Continue:'$isobject(objInfPos)
			
			Set Code     = objInfPos.BTCode
			Set Desc     = objInfPos.BTDesc
			Set DiagFlag = objInfPos.BTDiagFlag
			Set GCode    = objInfPos.BTGCode
			Continue:(aPosFlg=1)&&($e(GCode,3,4)'="00")
			Set IsActive = objInfPos.BTIsActive
			Continue:(aAlias'="")&&('(Desc[aAlias))
			
			Set Data = $lb(xID,Code,Desc,DiagFlag,GCode,IsActive)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryInfPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosExecute ]
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
/// CreatDate：   2017-05-04
/// Description:  查询感染诊断（部位）信息 下拉框使用 按照Code排序
/// Table：       DHCHAI.BT.InfPos
/// Input：       aPosFlg:  1:查询感染部位 2:查询感染诊断 空:查询所有
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.InfPosSrv","QryInfPosToSelect","")
Query QryInfPosToSelect(aPosFlg As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,DiagFlag:%String,GCode:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosToSelectExecute(ByRef qHandle As %Binary, aPosFlg As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Set:aPosFlg["#" aPosFlg=$p(aPosFlg,"#",2)
    Kill ^TMP($zn,$j,"QryInfPosToSelect")
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode,xID))
			Quit:xID=""
			Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(xID)
			Continue:'$isobject(objInfPos)
			
			Set Code     = objInfPos.BTCode
			Set Desc     = objInfPos.BTDesc
			Set DiagFlag = objInfPos.BTDiagFlag
			Set GCode    = objInfPos.BTGCode
			Set:GCode="" GCode="9999"
			Set IsActive = objInfPos.BTIsActive
			Continue:IsActive'=1
			Continue:(aPosFlg=1)&(DiagFlag'=0)  //查询所有部位
			Continue:(aPosFlg=2)&(DiagFlag'=1)  //查询所有诊断
			Set ^TMP($zn,$j,"QryInfPosToSelect"," "_GCode,xID)=$lb(xID,Code,Desc,DiagFlag,GCode,IsActive)
		}
	}
	Set xGCode=""
	For {
		Set xGCode=$o(^TMP($zn,$j,"QryInfPosToSelect",xGCode))
		Quit:xGCode=""
		
		Set xID=0
		For {
			Set xID=$o(^TMP($zn,$j,"QryInfPosToSelect",xGCode,xID))
			Quit:xID=""
			Set Data=$g(^TMP($zn,$j,"QryInfPosToSelect",xGCode,xID))
			Set ^CacheTemp(repid,ind) = Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,"QryInfPosToSelect")
	Quit $$$OK
}

ClassMethod QryInfPosToSelectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosToSelectExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfPosToSelectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosToSelectExecute ]
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
/// CreatDate：   2021-10-22
/// Description:  获取感染诊断树
/// Table：       DHCHAI.BT.InfPos
/// Input：       
/// w ##class(DHCHAI.BTS.InfPosSrv).GetInfPosTree()
ClassMethod GetInfPosTree() As %String
{
	Set return="[]"
	
		
	Kill ^TMP($zn,$j,"GetInfPosTree")
	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode))
		Quit:xCode=""
		
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode,xID))
			Quit:xID=""
			Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(xID)
			Continue:'$isobject(objInfPos)
			
			Set Code     = objInfPos.BTCode
			Set Desc     = objInfPos.BTDesc
			Set DiagFlag = objInfPos.BTDiagFlag
			Set GCode    = objInfPos.BTGCode
			Set:GCode="" GCode="9999"
			Set IsActive = objInfPos.BTIsActive
			Continue:IsActive'=1
			Continue:(DiagFlag'=1)  //查询所有诊断
			//多语言翻译诊断描述
			Set Desc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",Desc,"DHCHAI.BT.InfPos")
			Set ^TMP($zn,$j,"GetInfPosTree"," "_GCode,xID)=$lb(xID,Code,Desc,DiagFlag,GCode,IsActive)
		}
	}
	
	Set treeJson="["
	Set PosJson=""
	Set xGCode=""
	For {
		Set xGCode=$o(^TMP($zn,$j,"GetInfPosTree",xGCode))
		Quit:xGCode=""
		
		Set xID=0
		For {
			Set xID=$o(^TMP($zn,$j,"GetInfPosTree",xGCode,xID))
			Quit:xID=""
			
			Set InfPosData=$g(^TMP($zn,$j,"GetInfPosTree",xGCode,xID))
			Set Code=$lg(InfPosData,2)
			Set Desc=$lg(InfPosData,3)
			
			Set PosJson=PosJson_"{"
			Set PosJson=PosJson_"""id"":"""_xID_""","
			Set PosJson=PosJson_"""text"":"""_Desc_""","
			Set PosJson=PosJson_"""state"":""open"","   //默认不展开
			Set PosJson=PosJson_"""children"":["
		   
			Set SubJson=""
			Set xSubID=""
			For {
				Set xSubID = $o(^DHCHAI.BT.InfPosI("EXT","IdxofParRef",xID,xSubID))
				Quit:xSubID=""
				Continue:$e($tr(xGCode," ",""),1,2)="99"    //过滤新生儿感染诊断
				
				Set objInfPosExt = ##class(DHCHAI.BT.InfPosExt).GetObjById(xID_"||"_xSubID)
				Continue:'$IsObject(objInfPosExt)
				Continue:'$IsObject(objInfPosExt.BTInfSubDr)
				Continue:objInfPosExt.BTInfSubDr.BTIsActive'=1
				Set InfSubID  =objInfPosExt.BTInfSubDr.%Id()
				Set SubCode     = objInfPosExt.BTInfSubDr.BTCode
				Set SubDesc     = objInfPosExt.BTInfSubDr.BTDesc
				
				Set SubJson=SubJson_"{"
		 		Set SubJson=SubJson_"""id"":"""_xID_"||"_InfSubID_""","
		 		Set SubJson=SubJson_"""text"":"""_SubDesc_""","
		 		Set SubJson=SubJson_"""state"":""open"","       //默认展开
		 		Set SubJson=SubJson_"""checked"":""true"""	     //默认复选框选中
		 		Set SubJson=SubJson_"},"
			}
			Set:SubJson'="" SubJson=$e(SubJson,1,$l(SubJson)-1)	//去掉最后一个逗号
			Set PosJson=PosJson_SubJson_"]"
			Set PosJson=PosJson_"},"
		}
	}
	Set:PosJson'="" PosJson=$e(PosJson,1,$l(PosJson)-1)	//去掉最后一个逗号
	Set treeJson=treeJson_PosJson_"]"

	Kill ^TMP($zn,$j,"GetInfPosTree")
	
 	Set return=treeJson
 	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-09-26
/// Description:  查询感染诊断子诊断
/// Table：       DHCHAI.BT.InfPos
/// Input：       aPosCode:  感染部位代码
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.InfPosSrv","QryInfPosByCode","07")
Query QryInfPosByCode(aPosCode As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,DiagFlag:%String,GCode:%String,IsActive:%String")
{
}

ClassMethod QryInfPosByCodeExecute(ByRef qHandle As %Binary, aPosCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
   	Quit:aPosCode="" $$$OK
   	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode,xID))
			Quit:xID=""
			Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(xID)
			Continue:'$isobject(objInfPos)
			
			Set Code     = objInfPos.BTCode
			Set Desc     = objInfPos.BTDesc
			Set DiagFlag = objInfPos.BTDiagFlag
			Set GCode    = objInfPos.BTGCode
			Continue:$e(GCode,1,2)'=aPosCode
			Continue:$e(GCode,3,4)="00"
			
			Set IsActive = objInfPos.BTIsActive
			//多语言处理
			Set Desc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",Desc,"DHCHAI.BT.InfPos")
			Set Data = $lb(xID,Code,Desc,DiagFlag,GCode,IsActive)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryInfPosByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosByCodeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfPosByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosByCodeExecute ]
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
/// CreatDate：   2017-05-04
/// Description:  导入感染诊断与分类对照
/// Table：       DHCHAI.BT.InfPosExt
/// Input：       感染诊断名称和感染诊断分类名称,"^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.BTS.InfPosSrv).ImportInfDiagMap("上呼吸道感染^非手术相关","^")
ClassMethod ImportInfDiagMap(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"
	
	Set InfPosDesc=$p(aInput,aSeparate,1)   //感染诊断名称
	Set InfSubDesc=$p(aInput,aSeparate,2)  //感染诊断分类（多个以“、”号分隔）
	Quit:((InfPosDesc="")||(InfSubDesc="")) return
	Set InfPosID=$o(^DHCHAI.BT.InfPosI("IdxofDesc",InfPosDesc,0))
	Quit:InfPosID="" return
	
	For i=1:1:$l(InfSubDesc,"、") {
		Set tmpSubDesc = $p(InfSubDesc,"、",i)
		Set InfSubID=$o(^DHCHAI.BT.InfSubI("IdxofDesc",tmpSubDesc,0))
		Continue:InfSubID=""
		Set ChildSubID=$o(^DHCHAI.BT.InfPosI("EXT","IdxofInfSubDr",InfSubID,InfPosID,0))
		Set InputStr=InfPosID                       //感染诊断ID
		Set InputStr=InputStr_aSeparate_ChildSubID   //分类对照表ChildSub
		Set InputStr=InputStr_aSeparate_InfSubID  //感染诊断分类ID
		Set return=##Class(DHCHAI.BT.InfPosExt).Update(InputStr, aSeparate)
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-05-04
/// Description:  取消感染诊断与分类关联
/// Table：       DHCHAI.BT.InfPosExt
/// Input：       感染诊断名称和感染诊断分类名称,"^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.BTS.InfPosSrv).CancelInfDiagMap("上呼吸道感染^非手术相关","^")
ClassMethod CancelInfDiagMap(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"
	
	Set InfPosDesc=$p(aInput,aSeparate,1)   //感染诊断名称
	Set InfSubDesc=$p(aInput,aSeparate,2)  //感染诊断分类（多个以“、”号分隔）
	Quit:((InfPosDesc="")||(InfSubDesc="")) return
	Set InfPosID=$o(^DHCHAI.BT.InfPosI("IdxofDesc",InfPosDesc,0))
	Quit:InfPosID="" return
	
	For i=1:1:$l(InfSubDesc,"、") {
		Set tmpSubDesc = $p(InfSubDesc,"、",i)
		Set InfSubID=$o(^DHCHAI.BT.InfSubI("IdxofDesc",tmpSubDesc,0))
		Continue:InfSubID=""
		Set ChildSubID=$o(^DHCHAI.BT.InfPosI("EXT","IdxofInfSubDr",InfSubID,InfPosID,0))
		Continue:ChildSubID=""
		Set PosExtID=InfPosID_"||"_ChildSubID   //分类对照表ID
		Set return=##Class(DHCHAI.BT.InfPosExt).DeleteById(PosExtID)
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-06-11
/// Description:  根据部位ID查询感染诊断
/// Table：       DHCHAI.BT.InfPos
/// Input：       aPosCode :  部位的Code
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.InfPosSrv","QryInfPos1","1")
Query QryInfPos1(aPosDr As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,DiagFlag:%String,GCode:%String,IsActive:%String")
{
}

ClassMethod QryInfPos1Execute(ByRef qHandle As %Binary, aPosDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set objPos = ##class(DHCHAI.BT.InfPos).GetObjById(aPosDr)
	Quit:'$isobject(objPos) $$$OK
	Set PosCode = objPos.BTCode
	Quit:$l(PosCode)'=2 $$$OK
 	Set xCode = PosCode
	For {
		Set xCode = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode))
		Quit:((xCode="")||($l(xCode)=2))
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode,xID))
			Quit:xID=""
			Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(xID)
			Continue:'$isobject(objInfPos)
			
			Set Code     = objInfPos.BTCode
			Set Desc     = objInfPos.BTDesc
			Set DiagFlag = objInfPos.BTDiagFlag
			Set GCode    = objInfPos.BTGCode
			Set:GCode="" GCode="9999"
			Set IsActive = objInfPos.BTIsActive
			Continue:IsActive'=1
			
			Set Data=$lb(xID,Code,Desc,DiagFlag,GCode,IsActive)
			Set ^CacheTemp(repid,ind) = Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryInfPos1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPos1Execute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfPos1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPos1Execute ]
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
/// CreatDate：   2018-06-11
/// Description:  根据诊断ID获取感染部位
/// Table：       DHCHAI.BT.InfPos
/// Input：       aInfPosDr :  感染诊断ID
/// w ##class(DHCHAI.BTS.InfPosSrv).GetPosByInfDr(2)
ClassMethod GetPosByInfDr(aInfPosDr As %String) As %String
{
	New (aInfPosDr)
	Set return=""
	Set objInfPos = ##class(DHCHAI.BT.InfPos).GetObjById(aInfPosDr)
	Quit:'$isobject(objInfPos) return
	Set InfPosCode = objInfPos.BTCode
	Quit:$l(InfPosCode)'=4 return
	Set PosCode = $e(InfPosCode,1,2)
	Set objPos = ##class(DHCHAI.BT.InfPos).GetObjByCode(PosCode)
	Quit:'$isobject(objPos) return
	
	Set PosDr   = objPos.%Id()
	Set PosDesc = objPos.BTDesc
	
	Set return = PosDr_"^"_PosDesc
	Quit return
}

}
