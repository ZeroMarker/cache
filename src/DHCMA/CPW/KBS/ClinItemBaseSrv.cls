Class DHCMA.CPW.KBS.ClinItemBaseSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zqy
/// CreatDate：   2022-6-27
/// Description:  查询诊疗项目库
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.KBS.ClinItemBaseSrv","QryCIBase")
Query QryCIBase(aKeyValue As %String = "") As %Query(ROWSPEC = "BTID:%String,BTDesc:%String,BTIsActive:%String,BTEMRCode:%String")
{
}

ClassMethod QryCIBaseExecute(ByRef qHandle As %Binary, aKeyValue As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xID=""
 	For {
	 	Set xID      = $o(^CT.MA.CPW.KB.ClinItemBaseD(xID))
	 	Quit:xID=""
	 	Set obj         = ##class(DHCMA.CPW.KB.ClinItemBase).GetObjById(xID)
	 	continue:'$IsObject(obj)
	 	Set Desc          = obj.CIDesc
	 	Continue:(aKeyValue'="")&&(Desc'[aKeyValue)
	 	Set IsActive      = obj.CIIsActive
	 	Set IsActive=$s(IsActive>0:"是",IsActive<=0:"否",1:"")
	 	Set EMRCode       = obj.CIEMRCode
		Set Data=$lb(xID,Desc,IsActive,EMRCode)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryCIBaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCIBaseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCIBaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCIBaseExecute ]
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
/// CreatDate：   2022-6-27
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.KBS.ClinItemBaseSrv","QryEMRCodeTree","","EMR020101,EMR020102,EMR050101,EMR020104,HDSD00.02.066","1","住院号")
Query QryEMRCodeTree(aEmrCode As %String = "", aCodeStr As %String = "", type As %String = "", aKey As %String = "") As %Query(ROWSPEC = "id:%String,text:%String,iconCls:%String,checked:%String,state:%String,attributes:%String,BTGlossaryID:%String,BTStructType:%String,BTEMRCode:%String,BTIsActive:%String")
{
}

ClassMethod QryEMRCodeTreeExecute(ByRef qHandle As %Binary, aEmrCode As %String = "", aCodeStr As %String = "", type As %String = "", aKey As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set ^tmpzqyui=$lb(aEmrCode,aCodeStr,type,aKey)
 	if (aKey'=""){
	 	Set Array=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("EMRservice.InterfaceService.ClinicalPathwayInterface","SelectEMRSData","")
		For Index=1:1:Array.Count() {
			Set Info=Array.GetAt(Index)
			Set ID=Info.GetAt("ID")
			Set Code=Info.GetAt("Code")		//EMR01
			Set Desc=Info.GetAt("Name")		//手术记录
			Set StructType=Info.GetAt("StructType")		//Document
			Continue:StructType'="Document"
			Continue:(aKey'="")&&(Desc'[aKey)
			Set Data=$lb(ID,Desc,"",checked,"closed","","","",Code,IsActive)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		Set Array=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("EMRservice.InterfaceService.ClinicalPathwayInterface","SelectEMRSData","")
		For Index=1:1:Array.Count() {
			Set IsActive=0
			Set Info=Array.GetAt(Index)
			Set ID=Info.GetAt("ID")
			Set Code=Info.GetAt("Code")		//EMR01
			Set StructType=Info.GetAt("StructType")		//Document
			Continue:StructType'="Document"
			Set Desc=Info.GetAt("Name")	
			Set HDSDArray=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("EMRservice.InterfaceService.ClinicalPathwayInterface","SelectGlossaryByCode",Code,"")
			For HDSDIndex=1:1:HDSDArray.Count() {
				Set HDSDInfo=HDSDArray.GetAt(HDSDIndex)
				Set ID=HDSDInfo.GetAt("ID")
				Set InternalID=HDSDInfo.GetAt("InternalID")	//HDSD
				Set Name=HDSDInfo.GetAt("Name")		//住院号
				Continue:(aKey'="")&&(Name'[aKey)
				Set:((","_aCodeStr_",")[(","_InternalID_",")) IsActive=1,checked="true"
				Set Data=$lb(ID,Name,"",checked,"open","","","",InternalID,IsActive)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}elseif (aEmrCode=""){
	 	//父节点
	 	Set Array=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("EMRservice.InterfaceService.ClinicalPathwayInterface","SelectEMRSData","")
		For Index=1:1:Array.Count() {
			Set Info=Array.GetAt(Index)
			Set ID=Info.GetAt("ID")
			Set Code=Info.GetAt("Code")		//EMR01
			if (aCodeStr["HDSD"){
				Set Str=..GetEmrCode(aCodeStr)
				Set aCodeStr=$p(Str,"^",1,2)
				Set aCodeStr=$tr(Str,"^",",")
			}
			Continue:(aCodeStr'="")&&(type=0)&&((aCodeStr'="")&&((","_aCodeStr_",")'[(","_Code_",")))
			Set StructType=Info.GetAt("StructType")		//Document
			Continue:StructType'="Document"
			Set Desc=Info.GetAt("Name")		//手术记录
			Set GlossaryID=Info.GetAt("GlossaryInternalID")		//术语集
			Set ParentID=Info.GetAt("ParentID")	
			Set checked="true",state="closed"
			//Set:((type=0)&&(aCodeStr'="")) state="open"
			Set Data=$lb(ID,Desc,"",checked,state,"",GlossaryID,StructType,Code,"0")	
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}else{
		//术语集
		Set IsActive=0
		Set HDSDArray=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("EMRservice.InterfaceService.ClinicalPathwayInterface","SelectGlossaryByCode",aEmrCode,"")
		For HDSDIndex=1:1:HDSDArray.Count() {
			Set IsActive=0
			Set HDSDInfo=HDSDArray.GetAt(HDSDIndex)
			Set ID=HDSDInfo.GetAt("ID")
			Set InternalID=HDSDInfo.GetAt("InternalID")	//HDSD
			Set Name=HDSDInfo.GetAt("Name")		//住院号
			Continue:(aCodeStr'="")&&(type=0)&&((","_aCodeStr_",")'[(","_InternalID_","))		//只加载已维护的
			Set:((","_aCodeStr_",")[(","_InternalID_",")) IsActive=1
			Set:type=0 state="open"
			Set Data=$lb(ID,Name,"",checked,state,"","","",InternalID,IsActive)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}	
	}
	if (ind=1){
		Set Data=$lb("-1","此术语集下没有数据","","","","","","","","0")
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	
	Quit $$$OK
}

ClassMethod QryEMRCodeTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEMRCodeTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEMRCodeTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEMRCodeTreeExecute ]
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
/// CreatDate：   2022-07-6
/// Description:  将术语集转化为EMR
/// w ##class(DHCMA.CPW.KBS.ClinItemBaseSrv).GetEmrCode("EMR100003,EMR100011,EMR100010,HDSD00.02.425")
ClassMethod GetEmrCode(aCode As %String) As %String
{
	New (aCode)
	//父节点
	Set aCode=$tr(aCode,"，",",")
	Set len =$l(aCode,","),CodeStr="",EmrHDCodeStr="",HDSDCodeStr=""
	for index=1:1:len{
		Set Code=$p(aCode,",",index)
		Continue:Code=""
		if (Code["HDSD"){
			Set EmrCode=..GetEmrCodeByHD(Code)
			//术语集的EMRCode
			if (EmrHDCodeStr=""){
				Set EmrHDCodeStr=EmrCode
			}else{
				Set:(","_EmrHDCodeStr_",")'[(","_EmrCode_",") EmrHDCodeStr=EmrHDCodeStr_","_EmrCode
			}
			//术语集拼串
			if (HDSDCodeStr=""){
				Set HDSDCodeStr=Code
			}else{
				Set:(","_HDSDCodeStr_",")'[(","_Code_",") HDSDCodeStr=HDSDCodeStr_","_Code
			}
		}else{
			if (CodeStr=""){
				Set CodeStr=Code
			}else{
				Set:(","_CodeStr_",")'[(","_Code_",") CodeStr=CodeStr_","_Code
			}
		}
	}
	Quit:((CodeStr="")&&(EmrHDCodeStr="")&&(HDSDCodeStr="")) ""
	Quit CodeStr_"^"_EmrHDCodeStr_"^"_HDSDCodeStr
}

/// Creator：     zqy
/// CreatDate：   2022-07-6
/// Description:  将术语集转化为EMR
/// w ##class(DHCMA.CPW.KBS.ClinItemBaseSrv).GetEmrCodeByHD("HDSD00.14.140")
ClassMethod GetEmrCodeByHD(aCode As %String) As %String
{
	New (aCode)
	Set return=0
	Set aCode=$p(aCode,".",1,2)
	Set Array=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("EMRservice.InterfaceService.ClinicalPathwayInterface","SelectEMRSData","")
	For Index=1:1:Array.Count() {
		Set Info=Array.GetAt(Index)
		Set StructType=Info.GetAt("StructType")		//Document
		Continue:StructType'="Document"
		Set ID=Info.GetAt("ID")
		Set GlossaryID=Info.GetAt("GlossaryInternalID")		//术语集
		Set GlossaryID=$p(GlossaryID,".",1,2)
		Continue:aCode'=GlossaryID  
		if (return=0){
			Set return=Info.GetAt("Code")	
		}else{
			Set:(","_return_",")'[(","_Info.GetAt("Code")_",") return=return_","_Info.GetAt("Code")
		}
	}
	Quit return
}

}
