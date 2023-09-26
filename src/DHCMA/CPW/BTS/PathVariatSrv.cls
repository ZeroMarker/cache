/// 名称: DHCMA.CPW.BTS.PathVariatSrv
/// 描述: 变异原因 维护 服务类
/// 编写者：liuzhenhe
/// 编写日期: 2018-08-27
Class DHCMA.CPW.BTS.PathVariatSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-27
/// Description:  查询变异原因字典
/// Table：       DHCMA.CPW.BT.PathVariat
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathVariatSrv","QryPathVariat")
Query QryPathVariat(aHospID As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTCatID:%String,BTCatDesc:%String,BTTypeID:%String,BTTypeDesc:%String, BTIsExactly:%String,BTIsActive:%String,BTActDate:%String,BTActTime:%String,BTActUserID:%String,BTActUserDesc:%String,BTAdmType:%String,BTAdmTypeDesc:%String")
{
}

ClassMethod QryPathVariatExecute(ByRef qHandle As %Binary, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
 	Set xID=""
 	For {
	 	Set xID      = $o(^DHCMA.CPW.BT.PathVariatD(xID))
	 	Quit:xID=""
	 	
	 	Set obj         = ##class(DHCMA.CPW.BT.PathVariat).GetObjById(xID)
	 	continue:'$IsObject(obj)
	 	If (IsOpen="Y")&&(aHospID'=""){
		 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA_CPW_BT.PathVariat",xID,aHospID)
		 	Continue:retFlg'="Y"
		}
	 	
		Set AdmTypeDesc = ""
	 	Set Code        = obj.BTCode
	 	Set Desc        = obj.BTDesc
	 	Set CatDr       = obj.BTCatDr
	 	Set TypeDr      = obj.BTTypeDr
	 	Set IsExactly   = obj.BTIsExactly
	 	Set IsActive    = obj.BTIsActive
	 	Set ActDate     = obj.BTActDate
	 	Set ActTime     = obj.BTActTime 
	 	Set ActUserID   = obj.BTActUserID 
	 	Set AdmType     = obj.BTAdmType
	 	Set:AdmType="I" AdmTypeDesc = "住院"
	 	Set:AdmType="IO" AdmTypeDesc = "门诊+住院"
	 	Set:AdmType="O" AdmTypeDesc = "门诊"
	 	
	 	Set IsExactly   = $s(IsExactly = 1:"正",1:"负")
	 	Set IsActive    = $s(IsActive  = 1:"是",1:"否")
	 	Set:ActDate'="" ActDate=$ZD(ActDate,3)   
	 	Set:ActTime'="" ActTime=$ZT(ActTime,1) 
	 	Set CatID="",CatDesc=""
	 	If $IsObject(CatDr){
		Set CatID       = CatDr.%Id()	
	 	Set CatDesc     = CatDr.BTDesc
	 	}
	 	Set TypeID="",TypeDesc=""
	 	If $IsObject(TypeDr){
		Set TypeID      = TypeDr.%Id()	
	 	Set TypeDesc    = TypeDr.BTDesc
	 	}    
	 	Set ActUserDesc = "" 
	 	Set objUser     = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
	 	if ($IsObject(objUser)) {
	 		Set ActUserDesc= objUser.BTDesc
	 	}
	 	 
		Set Data=$lb(xID,Code,Desc,CatID,CatDesc,TypeID,TypeDesc,IsExactly,IsActive,ActDate,ActTime,ActUserID,ActUserDesc,AdmType,AdmTypeDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPathVariatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathVariatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathVariatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathVariatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-10-23
/// Description:  查询变异原因字典
/// Table：       DHCMA.CPW.BT.PathVariat
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathVariatSrv","QryVerByTypeCat","01","")
Query QryVerByTypeCat(aTypeCode As %String, aCatCode As %String, aAdmType As %String = "") As %Query(ROWSPEC = "ind:%String,TypeID:%String,TypeDesc:%String,CatID:%String,CatDesc:%String,VarID:%String,Code:%String,Desc:%String")
{
}

ClassMethod QryVerByTypeCatExecute(ByRef qHandle As %Binary, aTypeCode As %String, aCatCode As %String, aAdmType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aTypeCode="" $$$OK
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
	Set xTypeID=""
	For {
		Set xTypeID=$o(^DHCMA.CPW.BT.PathVariatI("IdxofTypeCat",xTypeID))
		Quit:xTypeID=""
		
		Set objType=##class(DHCMA.Util.BT.Dictionary).GetObjById(xTypeID)
		Continue:'$IsObject(objType)
		Continue:(aTypeCode'="")&&(objType.BTCode'=aTypeCode)
		Set TypeDesc=objType.BTDesc
		Set:TypeDesc'="" TypeDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",TypeDesc,LangID)
		
		Set xCatID=""
		For {
			Set xCatID=$o(^DHCMA.CPW.BT.PathVariatI("IdxofTypeCat",xTypeID,xCatID))
			Quit:xCatID=""
			
			Set objCat=##class(DHCMA.CPW.BT.PathVarCat).GetObjById(xCatID)
			Continue:'$IsObject(objCat)
			Continue:(aCatCode'="")&&(objCat.BTCode'=aCatCode)
			Set CatDesc=objCat.BTDesc
			Set:CatDesc'="" CatDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathVarCat","BTDesc",CatDesc,LangID)
			
			Set xVarID=""
		 	For {
		 		Set xVarID=$o(^DHCMA.CPW.BT.PathVariatI("IdxofTypeCat",xTypeID,xCatID,xVarID))
		 		Quit:xVarID=""
		 		
		 		Set obj=##class(DHCMA.CPW.BT.PathVariat).GetObjById(xVarID)
			 	Continue:'$IsObject(obj)
		 		Continue:'obj.BTIsActive
		 		Continue:(aAdmType'="")&&(obj.BTAdmType'[aAdmType)					//添加就诊类型，区分门诊、住院 add by yankai 2019-06-19
		 		Set Code= obj.BTCode
	 			Set Desc= obj.BTDesc
	 			Set:Desc'="" Desc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathVariat","BTDesc",Desc,LangID)
	 			
				Set Data=$lb(ind,xTypeID,TypeDesc,xCatID,CatDesc,xVarID,Code,Desc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
		 	}
		}
	}
	 	 
 	
	Quit $$$OK
}

ClassMethod QryVerByTypeCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVerByTypeCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVerByTypeCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVerByTypeCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
