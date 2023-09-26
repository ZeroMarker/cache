Class DHCMA.CPW.SDS.DicTypeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:  查询系统字典类型
/// Table：       DHCMA.CPW.SD.DicType
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.DicTypeSrv","QryDicType","1")
Query QryDicType(aEntityID As %String, aVersion As %String = "", aKey As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,EntityID:%String,EntityDesc:%String,BTIsActive:%String,VerID:%String,ItemID:%String")
{
}

ClassMethod QryDicTypeExecute(ByRef qHandle As %Binary, aEntityID As %String, aVersion As %String = "", aKey As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aEntityID="" $$$OK
 	Set xID=""
 	For{
	 	Set xID=$o(^DHCMA.CPW.SD.DicTypeD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.CPW.SD.DicType).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code     = obj.BTCode
	 	Set Desc     = obj.BTDesc
	 	continue:(aKey'="")&&(Code'[aKey)&&(Desc'[aKey)
	 	Continue:(aVersion'="")&&(aVersion'=obj.QCVersion.%Id())
	 	Continue:(aVersion="")&&(obj.BTQCDr.BTVersion.%Id()'=obj.QCVersion.%Id())
	 	Set EntityID="",EntityCode="",EntityDesc =""
	 	If $IsObject(obj.BTQCDr){
	    	Set EntityID   = obj.BTQCDr.%Id()
		 	Set EntityCode = obj.BTQCDr.BTCode
	    	Set EntityDesc = obj.BTQCDr.BTDesc
	 	}
	 	Continue:(aEntityID'="")&&(aEntityID'=EntityID)
	    Set IsActive=obj.IsActive
	    Set VerID=obj.QCVersion.%Id()
	    Set ItemID=obj.QCItemDr.%Id()
		Set Data=$lb(xID,Code,Desc,EntityID,EntityDesc,IsActive,VerID,ItemID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryDicTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDicTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicTypeExecute ]
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

/// w ##class(DHCMA.CPW.SDS.DicTypeSrv).ImportDicType(^tmpzgz21,$c(1))
ClassMethod ImportDicType(inputStr As %String, aSeparete = "^") As %String
{
	n (inputStr,aSeparete)
	Set ret=-1
	S ^tmpzgz21=inputStr
	Set TypeCode   	= $p(inputStr,aSeparete,4)
	Set TypeObj		= ##class(DHCMA.CPW.SD.QCEntity).GetObjByCode(TypeCode)
	Quit:'$IsObject(TypeObj) ret
	Set QCID		= TypeObj.%Id()
	Set $p(inputStr,aSeparete,4)=QCID
	
	//获取版本信息
	Set Version=$p(inputStr,aSeparete,6)
	Quit:Version="" ret
	Set VersionObj=##class(DHCMA.CPW.SD.QCEntityVersion).GetObjByCode(Version)
	Set VersionID=VersionObj.%Id()
	
	//根据值域代码，通过项目获取值域描述
	Set Code=$p(inputStr,aSeparete,2)
	Set ItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(VersionID,QCID,Code)
	Quit:'$IsObject(ItemObj) ret
	Set Desc=ItemObj.BTDesc
	Set $p(inputStr,aSeparete,3)=Desc
	//增加关联版本项目ID，版本
	Set $p(inputStr,aSeparete,7)=ItemObj.%Id()
	Set $p(inputStr,aSeparete,8)=VersionID
	Set ret=##class(DHCMA.CPW.SD.DicType).Update(inputStr,aSeparete)
	Quit ret
}

/// 把单病种基础字典类型和项目进行绑定，防止导入的上传版本字典代码与填报字典代码重复引起错误；
/// 将值域类型和老表单项目进行关联
/// w ##class(DHCMA.CPW.SDS.DicTypeSrv).LnkDicTypeToQCItem("1")
ClassMethod LnkDicTypeToQCItem(aVerID As %String = "1", aCode As %String = "") As %String
{
	new (aVerID,aCode)
	Quit:aVerID="" ""  ;需按照版本关联项目
	Set xID="",Count=0
 	For{
	 	Set xID=$o(^DHCMA.CPW.SD.DicTypeD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.CPW.SD.DicType).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code     = obj.BTCode
	 	Continue:(aCode'="")&&(aCode'=Code)
	 	Set Desc     		= obj.BTDesc
	 	Set VerID    		= obj.QCVersion.%Id()
	 	Continue:(aVerID'="")&&(aVerID'=VerID)
	 	Set QCEntityID    	= obj.BTQCDr.%Id()
	 	Set LnkItem	 		= obj.QCItemDr
	 	Continue:LnkItem'="" //已经关联项目的值域类型不再关联
		Set xSubID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",VerID," "_$zcvt(Code,"U"),QCEntityID,0))
		Continue:xSubID=""
		Set xRowID=QCEntityID_"||"_xSubID
		Set ObjItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(xRowID)
		Set obj.QCItemDr=ObjItem
		set sc=obj.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc) 
		   		Set return=-1
			}Else{
				Set return=obj.%Id()
				Set Count=Count+1
			}
		Do obj.%Close()
 	}
 	Quit "共关联字典类型与表单项目："_Count_"条"
}

/// 处理之前多个病种项目共用一个字典的情况
/// 例如：性别值域类型，旧表单公用一个值域字典，版本改造后一个项目用一个值域字典，
/// 需要将缺少的值域字典新增上，然后与项目绑定,现在只需要迁移"sex"
/// w ##class(DHCMA.CPW.SDS.DicTypeSrv).SynLostDicType("1","sex")
ClassMethod SynLostDicType(aVerID As %String = "", aCode As %String = "") As %String
{
	new (aVerID,aCode)
	Set xID="",Count=0,ret=""
 	For{
	 	Set xID=$o(^DHCMA.CPW.SD.DicTypeD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.CPW.SD.DicType).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code     = obj.BTCode
	 	Continue:(aCode'="")&&(aCode'=Code)
	 	Set Desc     		= obj.BTDesc
	 	Set VerID    		= obj.QCVersion.%Id()
	 	Continue:(aVerID'="")&&(aVerID'=VerID)
	 	Set QCEntityID    	= obj.BTQCDr.%Id()
	 	Set LnkItem	 		= obj.QCItemDr
		Set xParref=""
		TS
		For {
			Set xParref=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",VerID," "_$zcvt(Code,"U"),xParref))
			Quit:xParref=""
			Continue:xParref=QCEntityID //过滤值域属于的病种
			Set xSubID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",VerID," "_$zcvt(Code,"U"),xParref,0))
			Continue:xSubID=""
			Set xRowID=xParref_"||"_xSubID
			//过滤已经存在病种版本值域类型
			Continue:$d(^DHCMA.CPW.SD.DicTypeI("IdxofQCVerCode",xParref,VerID," "_$ZCVT(Code,"U")))
			//新建值域类型
			Set DicTypeStr="^"_Code_"^"_Desc_"^"_xParref_"^1^^"_xRowID_"^"_VerID
			Set NewDicTypeID=##class(DHCMA.CPW.SD.DicType).Update(DicTypeStr)
			If (NewDicTypeID<0) {
					 Tro
					 w "-1^字典类型同步失败",!
					 Quit
					}
			Set Count=Count+1
			//同步值域字典
			Set xCode="",DicTypeID=xID
			For {
		 		Set xCode=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",DicTypeID,xCode))
		 		Quit:xCode=""
			 	Set xDicID = ""
			 	For {
				   	Set xDicID	= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",DicTypeID,xCode,xDicID))
				   	Quit:xDicID=""
				 	Set objDic	= ##class(DHCMA.CPW.SD.Dictionary).GetObjById(xDicID)
				 	Continue:'$IsObject(obj)
				 	Set Code	 = objDic.BTCode
				 	Set Desc	 = objDic.BTDesc
				    Set IndNo    = objDic.BTIndNo
				 	Set IsActive = objDic.BTIsActive
				 	Set xDicStr="^"_Code_"^"_Desc_"^"_NewDicTypeID_"^"_IndNo_"^"_IsActive
				 	Set NewDicID=##class(DHCMA.CPW.SD.Dictionary).Update(xDicStr)
				 	If (NewDicID<0) {
					 w "-2^字典项目同步失败",!
					 Tro
					 Quit
					}
			 	}
			}	
		}
		TC
 	}
 	Quit Count
}

}
