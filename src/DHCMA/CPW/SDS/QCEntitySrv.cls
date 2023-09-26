Class DHCMA.CPW.SDS.QCEntitySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     xuwenjie
/// CreatDate：   2018-08-28
/// Description:  查询质控病种信息
/// Table：       DHCMA.CPW.SD.QCEntity      
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCEntitySrv","QryQCEntity","")
Query QryQCEntity(aLocOID As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTAbbrev:%String,BTIsActive:%String,BTIndNo:%Integer,BTPubdate:%Date,BTOperKey:%String,BTURL:%String,BTLocation:%String,BTLocOID:%String,BTTotalFee:%String,BTInDays:%String,BTEntityCat:%String,CurVerID:%String")
{
}

ClassMethod QryQCEntityExecute(ByRef qHandle As %Binary, aLocOID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	For
 	{
	 	Set xRowID        = $o(^DHCMA.CPW.SD.QCEntityD(xRowID))
	 	Quit:xRowID=""
	 	Set objEntity        = ##class(DHCMA.CPW.SD.QCEntity).GetObjById(xRowID)
	 	Set Code             = objEntity.BTCode
	 	Set Desc             = objEntity.BTDesc  
	 	Set Abbrev           = objEntity.BTAbbrev
	 	Set IsActive         = objEntity.BTIsActive
	 	Set IsActive = $s(IsActive=1:"是",1:"否")
	 	Set IndNo            = objEntity.BTIndNo
	 	Set Pubdate          = objEntity.BTPubdate
	 	Set OperKey          = objEntity.BTOperKey
	 	Set BTURL            = objEntity.BTURL
	 	Set Location		 = objEntity.BTLocation
	 	Continue:(aLocOID'="")&&(Location'="")&&($listfind(Location,aLocOID)=0)
	 	Set BTLocation="",BTLocOID=""
	 	For idx=1:1:$ll(Location){
		 	Set LocOID=$list(Location,idx)
		 	Continue:LocOID=""
			Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(LocOID)
			Continue:'$IsObject(objLoc)
			Set LocDesc=objLoc.BTDesc
			Set BTLocOID=BTLocOID_","_LocOID
			Set BTLocation=BTLocation_","_LocDesc
		}
		Set:BTLocOID'="" BTLocOID=$e(BTLocOID,2,$l(BTLocOID))
		Set:BTLocation'="" BTLocation=$e(BTLocation,2,$l(BTLocation))
		//参考住院费用、住院日	
		Set BTTotalFee		= objEntity.BTTotalFee
		Set BTInDays		= objEntity.BTInDays



		Set BTEntityCat=""
		Set:$IsObject(objEntity.BTEntityCat) BTEntityCat= objEntity.BTEntityCat.%Id()
		Set CurVerID=""
		Set:$IsObject(objEntity.BTVersion) CurVerID=objEntity.BTVersion.%Id()
		Set Desc=##class(DHCMA.CPW.SD.QCEntity).GetTranByDesc("BTDesc",Desc)
		Set Data=$lb(xRowID,Code,Desc,Abbrev,IsActive,IndNo,Pubdate,OperKey,BTURL,BTLocation,BTLocOID,BTTotalFee,BTInDays,BTEntityCat,CurVerID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryQCEntityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCEntityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCEntityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCEntityExecute ]
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

/// s a=##class(DHCMA.CPW.SDS.QCEntitySrv).GetObjByDesc("急性心肌梗死")
ClassMethod GetObjByDesc(aAlias) As DHCMA.CPW.SD.QCEntity
{
	new (aAlias)
 	Set xRowID=0,return=""
 	For
 	{
	 	Set xRowID        = $o(^DHCMA.CPW.SD.QCEntityD(xRowID))
	 	Quit:(xRowID="")||(return'="")
	 	Set objEntity     = ##class(DHCMA.CPW.SD.QCEntity).GetObjById(xRowID)
	 	Set Code          = objEntity.BTCode
	 	Set Desc          = objEntity.BTDesc  
	 	Set:Desc[aAlias return=objEntity
 	}
 	Quit return
}

/// 清除业务数据
/// w ##class(DHCMA.CPW.SDS.QCEntitySrv).ClearWorkData()
ClassMethod ClearWorkData() As %String
{
	w "开始清除单病种业务数据...",!
	;"值域字典医嘱项对照"
	K ^DHCMA.CPW.SD.QCOptionMatchD
	K ^DHCMA.CPW.SD.QCOptionMatchI
	;标准抗菌药与HIS医嘱项对照
	K ^DHCMA.CPW.SDMatch.AntiItemMatchD
	K ^DHCMA.CPW.SDMatch.AntiItemMatchI
	;"入组记录，表单执行记录"
	K ^DHCMA.CPW.SD.QCMrListD
	K ^DHCMA.CPW.SD.QCMrListI
	K ^DHCMA.CPW.SD.QCItemExecI
	K ^DHCMA.CPW.SD.QCMrListStateI
	K ^DHCMA.CPW.SD.QCMrStateAliasI
	Quit "完毕"
}

/// 清除产品配置数据
/// w ##class(DHCMA.CPW.SDS.QCEntitySrv).ClearCodeData()
ClassMethod ClearCodeData() As %String
{
	w "开始清除单病种配置数据...",!
	
	;值域字典标准抗菌药对照
	K ^DHCMA.CPW.SD.QCOptionMatchAntiD
	K ^DHCMA.CPW.SD.QCOptionMatchAntiI	
	
	;病种项目值域字典
	K ^DHCMA.CPW.SD.DictionaryD
	K ^DHCMA.CPW.SD.DictionaryI
	K ^DHCMA.CPW.SD.DicTypeD
	K ^DHCMA.CPW.SD.DicTypeI
	;单病种表达式维护
	K ^DHCMA.CPW.SD.QCExpressD
	K ^DHCMA.CPW.SD.QCExpressI
	;单病种定义+病种项目+入组规则+指标配置
	K ^DHCMA.CPW.SD.QCEntityD
	K ^DHCMA.CPW.SD.QCEntityI
	K ^DHCMA.CPW.SD.QCEntityItemI
	K ^DHCMA.CPW.SD.QCEntityMatchRuleI
	K ^DHCMA.CPW.SD.QCIndexI
	;标准抗菌药物
	K ^DHCMA.CPW.SDMatch.AnticatD
	K ^DHCMA.CPW.SDMatch.AnticatI
	K ^DHCMA.CPW.SDMatch.AntiItemD
	K ^DHCMA.CPW.SDMatch.AntiItemI
	Quit "完毕"
}

}
