/// 名称: DHCMA.Util.BTS.DictionarySrv
/// 描述: 系统字典表方法
/// 编写者：刘贞贺   
/// 编写日期: 2018-08-30
Class DHCMA.Util.BTS.DictionarySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2018-09-21
/// Description:  判断是否重复 ：确定atype 判断code是否唯一，接着判断id是否唯一
/// Table：       DHCMA.Util.BT.Dictionary
/// Input:        aTypeDr,aCode,aID 
/// d ##class(DHCMA.Util.BTS.DictionarySrv).CheckPTCode(1,1)
ClassMethod CheckPTCode(aTypeDr As %String, aCode As %String, aID As %String = "") As %String
{
	New (aTypeDr,aCode,aID)
	Set return=""
	Quit:(aTypeDr="")||(aCode="") return
	
	//由atype、code 判断id是否唯一
	If ($d(^DHCMA.Util.BT.DictionaryI("IdxofTypeDrCode",aTypeDr," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^DHCMA.Util.BT.DictionaryI("IdxofTypeDrCode",aTypeDr," "_$zcvt(aCode,"U"),0))
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}
	
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-09-4
/// Description:  查询系统字典类型
/// Table：       DHCMA.Util.BT.DicType
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.Util.BTS.DictionarySrv","QryProDicType","CPW")
Query QryProDicType(aProCode As %String) As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTTypeID:%String,BTTypeDesc:%String")
{
}

ClassMethod QryProDicTypeExecute(ByRef qHandle As %Binary, aProCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=""
 	For{
	 	Set xID=$o(^DHCMA.Util.BT.DicTypeD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.Util.BT.DicType).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code     = obj.BTCode
	 	Set Desc     = obj.BTDesc
	 	Set ProductID="",ProductCode="",BTProductDesc =""
	 	If $IsObject(obj.BTProductDr){
	    	Set ProductID   = obj.BTProductDr.%Id()
		 	Set ProductCode = obj.BTProductDr.ProCode
	    	Set ProductDesc = obj.BTProductDr.ProDesc
	 	}
	 	Continue:(aProCode'="")&&(aProCode'=ProductCode)
	 	Continue:ProductCode="HIS"  //排除HIS字典类型
	    
		Set Data=$lb(xID,Code,Desc,ProductID,ProductDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryProDicTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryProDicTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryProDicTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryProDicTypeExecute ]
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

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-30
/// Description:  查询字典
/// Table：       DHCMA.Util.BT.Dictionary
/// D ##class(%ResultSet).RunQuery("DHCMA.Util.BTS.DictionarySrv","QryDictionary")
Query QryDictionary() As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,TypeDesc:%String,BTIndNo:%String,BTIsActive:%String,BTActDate:%String,BTActTime:%String,BTActUserDesc:%String")
{
}

ClassMethod QryDictionaryExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xID=""
 	For{
	 	Set xID          = $o(^DHCMA.Util.BT.DictionaryD(xID))
	 	Quit:xID=""
	 	Set obj          = ##class(DHCMA.Util.BT.Dictionary).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code         = obj.BTCode
	 	Set Desc         = obj.BTDesc
	    Set TypeDr     	 = obj.BTTypeDr
	    Set BIndNo       = obj.BTIndNo
	 	Set IsActive     = obj.BTIsActive
	 	Set ActDate      = obj.BTActDate
	 	Set ActTime      = obj.BTActTime 
	 	Set ActUserID    = obj.BTActUserID 
	 	
	 	Set (TypeID,TypeDesc)=""
	 	if ($IsObject(TypeDr)) {
		 	Set TypeID     = TypeDr.%Id()
		 	Set TypeDesc   = TypeDr.BTDesc
	 	}
	 	Set IsActive=$s(IsActive=1:"是",1:"否")
	 	Set:ActDate'="" ActDate=$zd(ActDate,3)
	 	Set:ActTime'="" ActTime=$zt(ActTime,1)
	 	Set ActUserDesc    = "" 
	 	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
	 	If ($IsObject(objUser)) {
	 		Set ActUserDesc= objUser.BTDesc
	 	}
		Set Data=$lb(xID,Code,Desc,TypeDesc,IndNo,IsActive,ActDate,ActTime,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryDictionaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDictionaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDictionaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDictionaryExecute ]
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

/// Creator：     liuzhenhe
/// CreatDate：   2018-09-09
/// Description:  根据类型ID取数据
/// Table：       DHCMA.Util.BT.DicType
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.Util.BTS.DictionarySrv","QryDictionaryByDicType","3")
Query QryDictionaryByDicType(aTypeDr As %String, aHospID As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,TypeDesc:%String,BTIndNo,BTIsActive:%String,BTActDate:%Date,BTActTime:%Time,BTActUserDesc:%String")
{
}

ClassMethod QryDictionaryByDicTypeExecute(ByRef qHandle As %Binary, aTypeDr As %String, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aTypeDr="" $$$OK
 	
 	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
 	Set xID=""
  	For
 	{
	 	Set xID      = $o(^DHCMA.Util.BT.DictionaryD(xID))
	 	Quit:xID=""
	 	
	 	Set obj      = ##class(DHCMA.Util.BT.Dictionary).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	If (IsOpen="Y")&&(aHospID'=""){
		 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA_Util_BT.Dictionary",xID,aHospID)
		 	Continue:retFlg'="Y"
		}
	 	
	 	Set Code     = obj.BTCode
	 	Set Desc     = obj.BTDesc
	 	Set TypeDesc="" , TypeID=""
	 	if (obj.BTTypeDr){
	    	Set TypeDesc = obj.BTTypeDr.BTDesc
	   		Set TypeID   = obj.BTTypeDr.%Id()
	 	}
	    Continue:aTypeDr'=TypeID
	    Set IndNo    = obj.BTIndNo
	 	Set IsActive = obj.BTIsActive
	 	Set ActDate  = obj.BTActDate
	 	Set ActTime  = obj.BTActTime  
	 	Set ActUserID= obj.BTActUserID  
	 	
	 	Set IsActive       = $s(IsActive=1:"是",1:"否")
	 	Set ActDate        = $ZD(ActDate,3)
	 	Set ActTime        = $ZT(ActTime,1) 
	 	Set ActUserDesc    = ""
	 	Set objUser    = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
	 	if ($IsObject(objUser)) {
	 		Set ActUserDesc= objUser.BTDesc
	 	}    
		Set Data=$lb(xID,Code,Desc,TypeDesc,IndNo,IsActive,ActDate,ActTime,ActUserDesc )
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryDictionaryByDicTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDictionaryByDicTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDictionaryByDicTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDictionaryByDicTypeExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2018-09-08
/// Description:  根据类型取字典
/// Table：       DHCMA.Util.BT.Dictionary
/// Input：       
/// output:   BTCode:%String,BTDesc:%String,BTIsActive:%String,BTIsActive:%Boolean,BTActDate:%Date,BTActTime:%Time,BTActUserID:%String
/// D ##class(%ResultSet).RunQuery("DHCMA.Util.BTS.DictionarySrv","QryDictByType","CPWDiagTYPE")
Query QryDictByType(aTypeCode As %String, aIsActive As %String = "1", aHospID As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTTypeDr:%String,BTIndNo,BTIsActive:%Boolean,BTActDate:%Date,BTActTime:%Time,BTActUserID:%String")
{
}

ClassMethod QryDictByTypeExecute(ByRef qHandle As %Binary, aTypeCode As %String, aIsActive As %String = "", aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
 	Quit:aTypeCode="" $$$OK
 	Set objType = ##class(DHCMA.Util.BT.DicType).GetObjByCode(aTypeCode)
 	Quit:'$Isobject(objType) $$$OK
 	Set TypeDr = objType.%Id()
 	
 	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
 	Set xCode = ""
 	For {
	 	Set xCode= $o(^DHCMA.Util.BT.DictionaryI("IdxofTypeDrCode",TypeDr,xCode))
	 	Quit:xCode=""
	 	
	 	Set RowID = ""
	 	For {
		   	Set RowID= $o(^DHCMA.Util.BT.DictionaryI("IdxofTypeDrCode",TypeDr,xCode,RowID))
		   	Quit:RowID=""
	 	
		 	Set BTObj= ##class(DHCMA.Util.BT.Dictionary).GetObjById(RowID)
		 	Continue:'$IsObject(BTObj)
		 	If (IsOpen="Y")&&(aHospID'=""){
			 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA_Util_BT.Dictionary",RowID,aHospID)
			 	Continue:retFlg'="Y"
			}
			Set ret= ##class(DHCMA.Util.BT.Config).GetValueByCode("CPWShowCPWTypeTab",aHospID)
		 	Set Code         = BTObj.BTCode
		 	Set Desc         = BTObj.BTDesc
		 	if (aTypeCode="CPWFormOrdType")&&(ret="I"){
				Continue:Desc["方剂"
			}
		    Set BTTypeDr     = BTObj.BTTypeDr.BTDesc
		    Set BTIndNo      = BTObj.BTIndNo
		 	Continue:(aIsActive'="")&&(BTObj.BTIsActive'=1)
		 	Set IsActiveDesc = $s(BTObj.BTIsActive=1:"是",1:"否")
		 	Set BTActDate        = $ZD(BTObj.BTActDate,3)
		 	Set BTActTime        = $Zt(BTObj.BTActTime)   
		 	Set BTActUserID      = BTObj.BTActUserID     
		 	Set:Desc'="" Desc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.Util.BT.Dictionary","BTDesc",Languages,Desc) 
			Set Data=$lb(RowID,Code,Desc,BTTypeDr,BTIndNo,IsActiveDesc,BTActDate,BTActTime,BTActUserID )
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	 	
 	}	
	Quit $$$OK
}

ClassMethod QryDictByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDictByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDictByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDictByTypeExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2019-02-12
/// Description:  根据类型取字典
/// Table：       DHCMA.Util.BT.Dictionary
/// w ##Class(DHCMA.Util.BTS.DictionarySrv).GetDicsByType("COPGender")
ClassMethod GetDicsByType(aTypeCode As %String, aActive As %String = "1") As %String
{
	New (aTypeCode,aActive)
	Set return=""
	
 	Quit:aTypeCode="" $$$OK
 	Set objType = ##class(DHCMA.Util.BT.DicType).GetObjByCode(aTypeCode)
 	Quit:'$Isobject(objType) $$$OK
 	Set TypeDr = objType.%Id()
 	
 	Set xCode = ""
 	For {
	 	Set xCode= $o(^DHCMA.Util.BT.DictionaryI("IdxofTypeDrCode",TypeDr,xCode))
	 	Quit:xCode=""
	 	
	 	Set RowID = ""
	 	For {
		   	Set RowID= $o(^DHCMA.Util.BT.DictionaryI("IdxofTypeDrCode",TypeDr,xCode,RowID))
		   	Quit:RowID=""
	 	
		 	Set BTObj= ##class(DHCMA.Util.BT.Dictionary).GetObjById(RowID)
		 	Continue:'$IsObject(BTObj)
		 	Set Code         = BTObj.BTCode
		 	Set Desc         = BTObj.BTDesc
		    Set BTTypeDr     = BTObj.BTTypeDr.BTDesc
		    Set BTIndNo      = BTObj.BTIndNo
		 	Set IsActiveDesc = $s(BTObj.BTIsActive=1:"是",1:"否")
		 	Set BTActDate        = $ZD(BTObj.BTActDate,3)
		 	Set BTActTime        = $Zt(BTObj.BTActTime)   
		 	Set BTActUserID      = BTObj.BTActUserID      
			
			Set return=return_RowID_$c(2)_Desc_$c(1)
		}
 	}
	Set:return'="" return=$e(return,1,$l(return)-1)
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2019-02-12
/// Description:  根据字典类型和字典Code取字典ID
/// Table：       DHCMA.Util.BT.Dictionary
/// w ##Class(DHCMA.Util.BTS.DictionarySrv).GetDicIDByCode("COPReportStatus",1)
ClassMethod GetDicIDByCode(aTypeCode As %String, aDicCode As %String) As %String
{
	New (aTypeCode,aDicCode)
	Set return=""
 	Quit:(aTypeCode="")||(aDicCode="") return
 	
 	Set objType = ##class(DHCMA.Util.BT.DicType).GetObjByCode(aTypeCode)
 	Quit:'$Isobject(objType) return
 	Set TypeID = objType.%Id()
 	Set DicID=$o(^DHCMA.Util.BT.DictionaryI("IdxofTypeDrCode",TypeID," "_$zcvt(aDicCode,"U"),""))
 	Quit DicID
}

ClassMethod ImportDicItem(inputStr As %String, aSeparete = "^") As %String
{
	n (inputStr,aSeparete)
	Set ret=-1
	Set TypeCode   	= $p(inputStr,aSeparete,4)
	Set TypeObj		= ##class(DHCMA.Util.BT.DicType).GetObjByCode(TypeCode)
	Quit:'$IsObject(TypeObj) ret
	Set TypeDr		= TypeObj.%Id()
	Set $p(inputStr,aSeparete,4)=TypeDr
	Set ret=##class(DHCMA.Util.BT.Dictionary).Update(inputStr)
	Quit ret
}

}
