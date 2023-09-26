/// 名称 : DHCMed.CDService.DiagnosPosSrv
/// 描述 : 诊断部位(亚部位)字典服务类 用于肿瘤报卡
/// 编写者：pylian
/// 编写日期: 2019-02-20
Class DHCMed.CDService.DiagnosPosSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-02-20
/// Description:  查询诊断部位(亚部位)字典
/// Table：       DHCMed.CD.CRDiagnosPos
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.DiagnosPosSrv","QryDiagPos","")
Query QryDiagPos(aAlias As %String = "", aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,CRCode:%String,CRDesc:%String,PosFlag:%String,PosFlagDesc:%String,IsActive:%String,IsActDesc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryDiagPosExecute(ByRef qHandle As %Binary, aAlias As %String = "", aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCMed.CD.CRDiagnosPosI("IndexCode",xCode))
		Quit:xCode=""
		
		Set xID = ""
		For {
			Set xID = $o(^DHCMed.CD.CRDiagnosPosI("IndexCode",xCode,xID))
			Quit:xID=""
			
			Set objPos = ##class(DHCMed.CD.CRDiagnosPos).GetObjById(xID)
			Continue:'$Isobject(objPos)
			Set IsActive = objPos.CRIsActive
			Continue:(aIsActive'="")&&(IsActive'=aIsActive)
			Set IsActDesc =$s(IsActive=1:"是",1:"否")
			Set Code     = $ZCVT(objPos.CRCode,"U")
			Set Desc     = objPos.CRDesc
			Set Desc     = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.CD.CRPathology","CRDesc","",Desc)
			Continue:((aAlias'="")&&(Code'[aAlias)&&(Desc'[aAlias))
			Set PosFlag = objPos.CRPosFlag
			Set PosFlagDesc =$s(PosFlag=1:"是",1:"否")
		    Set Resume   = objPos.CRResume
			Set Data = $lb(xID,Code,Desc,PosFlag,PosFlagDesc,IsActive,IsActDesc,Resume)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryDiagPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiagPosExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDiagPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiagPosExecute ]
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
/// CreatDate：   2019-02-20
/// Description:  查询诊断部位(亚部位)字典(树形结构)
/// Table：       DHCMed.CD.CRDiagnosPos
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.DiagnosPosSrv","QryDiagPosTree")
Query QryDiagPosTree(aAlias As %String = "", aIsActive As %String = "") As %Query(ROWSPEC = "RowId:%String,RowDesc:%String,ID:%String,CRCode:%String,CRDesc:%String,PosFlag:%String,PosFlagDesc:%String,IsActive:%String,IsActDesc:%String,Resume:%String,_parentId:%String") [ SqlProc ]
{
}

ClassMethod QryDiagPosTreeExecute(ByRef qHandle As %Binary, aAlias As %String = "", aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set rowIdField=0
	Set xID = ""
	For {
		Set xID = $o(^DHCMed.CD.CRDiagnosPosI("IndexPosFlg",1,xID))
		Quit:xID=""
		
		Set objPos = ##class(DHCMed.CD.CRDiagnosPos).GetObjById(xID)
		Continue:'$Isobject(objPos)
		Set IsActive = objPos.CRIsActive
		Continue:(aIsActive'="")&&(IsActive'=aIsActive)
		Set IsActDesc =$s(IsActive=1:"是",1:"否")
		Set Code     = $ZCVT(objPos.CRCode,"U")
		Set Desc     = objPos.CRDesc
		Set PosFlag = objPos.CRPosFlag
		Set PosFlagDesc =$s(PosFlag=1:"是",1:"否")
	    Set Resume   = objPos.CRResume
	  
	    Set rowIdField=rowIdField+1,rowTreeField=Desc
		Set Data = $lb(rowIdField,rowTreeField,xID,Code,Desc,PosFlag,PosFlagDesc,IsActive,IsActDesc,Resume,"")
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	
		Set ParentId=rowIdField	
		Set xDr = ""
		For {
			Set xDr = $o(^DHCMed.CD.CRDiagnosPosI("IndexPosFlg",0,xDr))
			Quit:xDr=""
			
			Set obj = ##class(DHCMed.CD.CRDiagnosPos).GetObjById(xDr)
			Continue:'$Isobject(obj)
			Set PosIsActive = obj.CRIsActive
			Continue:(aIsActive'="")&&(PosIsActive'=aIsActive)
			Set PosIsActDesc =$s(PosIsActive=1:"是",1:"否")
			Set PosCode     = $ZCVT(obj.CRCode,"U")
			Continue:PosCode'[Code
			Set PosDesc     = obj.CRDesc
			Continue:((aAlias'="")&&(PosCode'[aAlias)&&(PosDesc'[aAlias))
			Set PosFlag = obj.CRPosFlag
			Set PosFlagDesc =$s(PosFlag=1:"是",1:"否")
		    Set PosResume   = obj.CRResume
		    
		    Set rowIdField=rowIdField+1,rowTreeField=PosDesc		
			Set Data = $lb(rowIdField,rowTreeField,xDr,PosCode,PosDesc,PosFlag,PosFlagDesc,PosIsActive,PosIsActDesc,PosResume,ParentId)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}	
	}
	Quit $$$OK
}

ClassMethod QryDiagPosTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiagPosTreeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDiagPosTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiagPosTreeExecute ]
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

}
