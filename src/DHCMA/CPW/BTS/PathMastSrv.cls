/// 名称: DHCMA.CPW.BTS.PathMastSrv
/// 描述: 临床路径字典 服务类
/// 编写者：liuzhenhe
/// 编写日期: 2018-08-28
Class DHCMA.CPW.BTS.PathMastSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-27
/// Description:  查询临床路径字典字典
/// Table：       DHCMA.CPW.BT.PathMast
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathMastSrv","QryPathMast","","2!!1")
Query QryPathMast(aKeyValue As %String = "", aHospID As %String = "", aPathAdmType As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String, BTTypeID:%String,BTTypeDesc:%String,BTEntityID:%String,BTEntityDesc:%String, BTPCEntityID :%String ,BTPCEntityDesc :%String,BTQCEntityID :%String,BTQCEntityDesc :%String,BTIsActive:%String,BTActDate:%Date,BTActTime:%Time,BTActUserID:%String,BTActUserDesc:%String,HospOIDList:%String,HospDescList:%String,BTAdmType:%String,PathComplID:%String,PathComplDesc:%String,IsOper:%String,IsOperDesc:%String,StaCategoryID:%String,StaCategoryDesc:%String,FormID:%String,FromVer:%String,IsAsCompl:%String,IsAsComplDesc:%String")
{
}

ClassMethod QryPathMastExecute(ByRef qHandle As %Binary, aKeyValue As %String = "", aHospID As %String = "", aPathAdmType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
 	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
 	Set xID=""
 	For {
	 	Set xID=$o(^DHCMA.CPW.BT.PathMastD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.CPW.BT.PathMast).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set Code      = obj.BTCode
	 	Set Desc      = obj.BTDesc
	 	Set TypeID="",TypeDesc=""
	 	If $IsObject(obj.BTTypeDr) {
		 	Set TypeID      = obj.BTTypeDr.%Id()
		 	Set TypeDesc    = obj.BTTypeDr.BTDesc
	 	}
	 	Set BTAdmType = obj.BTAdmType
	 	Continue:(aPathAdmType'="")&&(aPathAdmType'=BTAdmType)
	 	Continue:(aKeyValue'="")&&(Desc'[aKeyValue)&&(TypeDesc'[aKeyValue)
	 	
	 	Set EntityID="",EntityDesc=""
	 	If $IsObject(obj.BTEntityDr){
		 	Set EntityID    = obj.BTEntityDr.%Id()
		 	Set EntityDesc  = obj.BTEntityDr.BTDesc
	 	}
	 	//修改表结构，两个字段存ID。jpp 2020-05-22
	 	Set PCEntityID="",PCEntityDesc=""
	 	If (obj.BTPCEntityDr'=""){
		 	Set objPCEntity=##class(DHCMA.CPW.SD.PCEntity).GetObjById(+obj.BTPCEntityDr)
		 	If ($IsObject(objPCEntity)) {
				Set PCEntityID   = objPCEntity.%Id()	
		 		Set PCEntityDesc = objPCEntity.BTDesc
		 	}
	 	}
	 	Set QCEntityID="",QCEntityDesc=""
	 	If (obj.BTQCEntityDr'=""){
		 	Set objQCEntity=##class(DHCMA.CPW.SD.QCEntity).GetObjById(+obj.BTQCEntityDr)
		 	If ($IsObject(objQCEntity)) {
				Set QCEntityID   = objQCEntity.%Id() 	
		 		Set QCEntityDesc = objQCEntity.BTDesc
		 	}
	 	}
	 	Set PathComplID="",PathComplDesc=""
	 	If $IsObject(obj.BTPathComplDr){
			 Set PathComplID = obj.BTPathComplDr.%Id()
			 Set PathComplDesc = obj.BTPathComplDr.BTDesc
		 }
	 	
		Set IsActive  = obj.BTIsActive
	 	Set ActDate   = obj.BTActDate
	 	Set ActTime   = obj.BTActTime
	 	Set ActUserID = obj.BTActUserID
	 	
	 	Set IsActiveDesc=$s(IsActive=1:"是",1:"否")
	 	Set:ActDate'="" ActDate=$zd(ActDate,3)
	 	Set:ActTime'="" ActTime=$zt(ActTime,1)
	 	Set ActUserDesc    = "" 
	 	Set objUser    = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
	 	if ($IsObject(objUser)) {
	 		Set ActUserDesc= objUser.BTDesc
	 	}
	 	Set AdmType      = obj.BTAdmType
	 	Set IsOper	  = obj.BTIsOper
	 	Set IsOperDesc=$s(IsOper=1:"是",1:"否")
	 	Set (StaCategoryID,StaCategoryDesc)=""
	 	If $IsObject(obj.BTStaCategoryDr){
			Set StaCategoryID = obj.BTStaCategoryDr.%Id()
			Set StaCategoryDesc = obj.BTStaCategoryDr.BTDesc	
		}
	 	Set IsAsCompl = obj.BTIsAsCompl
	 	Set IsAsComplDesc = $s(IsAsCompl=1:"是",1:"否")
	 	
		//取可用表单信息（有发布取发布表单，无发布取最新未发布表单）
		Set strForm = ##class(DHCMA.CPW.BTS.PathFormSrv).GetFormByMast(xID)
		Set FormID = $p(strForm,"^",1)
		Set FromVer = $p(strForm,"^",2)

		//院区处理
	 	Set HospOIDList=""
	 	Set HospDescList=""	 	
	 	If (IsOpen="Y")&&(aHospID'=""){
		 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA_CPW_BT.PathMast",xID,aHospID)
		 	Continue:retFlg'="Y"
		}else{
			Set xHospID=""
			For {
				Set xHospID=$o(^DHCMA.CPW.BT.PathMastI("HOSP","IdxofHosp",xID,xHospID))
				Quit:xHospID=""
				
				Set xPathHpID=""
				For {
					Set xPathHpID=$o(^DHCMA.CPW.BT.PathMastI("HOSP","IdxofHosp",xID,xHospID,xPathHpID))
					Quit:xPathHpID=""
					
					Set objPathHp=##class(DHCMA.CPW.BT.PathHosp).GetObjById(xID_"||"_xPathHpID)
					Continue:'$IsObject(objPathHp)
					Set IsActive=objPathHp.BTIsActive
					Continue:'IsActive
					
					Set objHosp=##class(DHCMA.Util.EP.Hospital).GetObjByOID(xHospID)
					Continue:'$IsObject(objHosp)
					
					Set HospOIDList=HospOIDList_"^"_xHospID_"-"_xPathHpID
					Set HospDesc=objHosp.BTDesc
					Set HospDescList=HospDescList_","_HospDesc
				}
			}
			Set:HospOIDList'="" HospOIDList=$e(HospOIDList,2,$l(HospOIDList))
			Set:HospDescList'="" HospDescList=$e(HospDescList,2,$l(HospDescList))
			Continue:(HospOIDList'="")&&(aHospID'="")&&(HospOIDList'[aHospID)
		}
		
		Set:Desc'="" Desc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",Desc,LangID)
		Set:TypeDesc'="" TypeDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathType","BTDesc",TypeDesc,LangID)
		Set:EntityDesc'="" EntityDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathEntity","BTDesc",EntityDesc,LangID)
		Set:PCEntityDesc'="" PCEntityDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.SD.PCEntity","BTDesc",PCEntityDesc,LangID)
	 	Set:QCEntityDesc'="" QCEntityDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.SD.QCEntity","BTDesc",QCEntityDesc,LangID)
		Set:IsActiveDesc'="" IsActiveDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.pathmastedit.csp",IsActiveDesc,LangID)
		Set:ActUserDesc'="" ActUserDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("User.CTCareProv","CTPCPDesc",ActUserDesc,LangID)
		Set:PathComplDesc'="" PathComplDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathCompl","BTDesc",PathComplDesc,LangID)
		Set:IsOperDesc'="" IsOperDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.pathmastedit.csp",IsOperDesc,LangID)
		Set:StaCategoryDesc'="" StaCategoryDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",StaCategoryDesc,LangID)
		Set:IsAsComplDesc'="" IsAsComplDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.pathmastedit.csp",IsAsComplDesc,LangID)
		Set Data=$lb(xID,Code,Desc,TypeID,TypeDesc,EntityID,EntityDesc,PCEntityID,PCEntityDesc,QCEntityID,QCEntityDesc,IsActiveDesc,ActDate,ActTime,ActUserID,ActUserDesc,HospOIDList,HospDescList,AdmType,PathComplID,PathComplDesc,IsOper,IsOperDesc,StaCategoryID,StaCategoryDesc,FormID,FromVer,IsAsCompl,IsAsComplDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPathMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathMastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathMastExecute ]
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

/// Creator：     zqy
/// CreatDate：   2023-04-25
/// Description:  查询临床路径字典(报表统一调)
/// Table：       DHCMA.CPW.BT.PathMast
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathMastSrv","QryRepPathMast","","2!!1","","I","1")
Query QryRepPathMast(aKeyWord As %String = "", aHospID As %String = "", aIsQryCompl As %String = 0, aAdmType As %String = "", aIsActive As %String = "1") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTIsActive:%String,BTAdmType:%String,BTAdmTypeDesc:%String,PathComplID:%String,PathComplDesc:%String")
{
}

ClassMethod QryRepPathMastExecute(ByRef qHandle As %Binary, aKeyWord As %String = "", aHospID As %String = "", aIsQryCompl As %String = 0, aAdmType As %String = "", aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	Set xID=""
 	For {
	 	Set xID = $o(^DHCMA.CPW.BT.PathMastD(xID))
	 	Quit:xID=""

	 	Set obj = ##class(DHCMA.CPW.BT.PathMast).GetObjById(xID)
		Continue:'$IsObject(obj)
		//院区权限过滤
		Set flgChkHosp = ##class(DHCMA.CPW.BTS.PathFormSrv).CheckPathHospOID(xID,aHospID)
	 	Continue:'flgChkHosp
		
	 	Set Code = obj.BTCode
	 	Set Desc = obj.BTDesc
		Continue:(aKeyWord'="")&(Desc'[aKeyWord)
		Continue:(aIsActive'="")&&(aIsActive'=obj.BTIsActive)
	 	Set IsActiveDesc = $s(obj.BTIsActive=1:"是",1:"否")    
	 	Set AdmType 		= obj.BTAdmType
	 	Continue:(aAdmType'="")&&(aAdmType'[AdmType)
	 	Set AdmTypeDesc		= $s(AdmType="I":"住院",AdmType="O":"门诊",1:"")
		If aIsQryCompl=1{		//查询合并症路径，则只返回合并症路径
			Continue:obj.BTTypeDr.BTDesc'="合并症"
		}ElseIf aIsQryCompl=0{	//检查普通路径,则过滤合并症
			Continue:obj.BTTypeDr.BTDesc="合并症"
		}ElseIf aIsQryCompl = 2{
			// 折中处理合并症，如果合并症已有科室关联，则不返回；未被关联则返回
			If obj.BTTypeDr.BTDesc="合并症"{
				Set retChk = ##class(DHCMA.CPW.BTS.PathLocSrv).ChkIsLinkedByPath(xID)
				Continue:+retChk=1	
			}
		}
	 	
		Set Data=$lb(xID,Code,Desc,IsActiveDesc,AdmType,AdmTypeDesc,PathComplID,PathComplDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryRepPathMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepPathMastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepPathMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepPathMastExecute ]
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
