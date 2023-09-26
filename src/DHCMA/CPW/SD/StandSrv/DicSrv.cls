/// 标准字典服务类
Class DHCMA.CPW.SD.StandSrv.DicSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod AddOtherMsg(aDicID As %String, aOtherMsg As %String) As %String
{
	New (aDicID,aOtherMsg)
	Set aOtherMsg=$tr(aOtherMsg,"，",",")
	Set Alias=$p(aOtherMsg,"^",1)
	Set Table=$p(aOtherMsg,"^",2)
	Set Field=$p(aOtherMsg,"^",3)
	Set Key=$p(aOtherMsg,"^",4)
	Set KeyFilter=$p(aOtherMsg,"^",5)
	If (Alias'="") {
		For AInd=1:1:$l(Alias,",") {
			Set xAlias=$P(Alias,",",AInd)
			Continue:xAlias=""
			Set xAliasStr="^"_aDicID_"^"_xAlias
			d ##class(DHCMA.CPW.SD.Stand.DicAlias).Update(xAliasStr)
		}
	}
	If (Table'="") {
		Set TableStr="^"_aDicID_"^"_Table_"^"_Field
		d ##class(DHCMA.CPW.SD.Stand.TableInfo).Update(TableStr)
	}
	If (Key'="")||(KeyFilter'="") {
		Set KeyStr="^"_aDicID_"^"_Key_"^"_KeyFilter
		d ##class(DHCMA.CPW.SD.Stand.KeyInfo).Update(KeyStr)
	}
	Quit 1
}

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SD.StandSrv.DicSrv","QryStandDic","45")
Query QryStandDic(aSourceID As %String) As %Query(ROWSPEC = "RowID,Code,Desc,Resume")
{
}

ClassMethod QryStandDicExecute(ByRef qHandle As %Binary, aSourceID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	For
 	{
	 	Set xRowID     = $o(^DHCMA.CPW.SD.Stand.DicI("IdxSource",aSourceID,xRowID))
	 	Quit:xRowID=""
	 	Set obj        = ##class(DHCMA.CPW.SD.Stand.Dic).GetObjById(xRowID)
	 	Set Code       = obj.DicCatCode
	 	Set Desc       = obj.DicCatDesc  
	 	Set Resume     = obj.Resume
		Set Data=$lb(xRowID,Code,Desc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryStandDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStandDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryStandDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStandDicExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SD.StandSrv.DicSrv","QryDicList","65")
Query QryDicList(aSourceID As %String, aDicID As %String = "") As %Query(ROWSPEC = "RowID,Code,Desc,Resume,Alias,ConnectInfo")
{
}

ClassMethod QryDicListExecute(ByRef qHandle As %Binary, aSourceID As %String, aDicID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	Quit:aSourceID="" $$$OK
 	If (aDicID'="") {
	 	For{
		 	Set xRowID	= $o(^DHCMA.CPW.SD.Stand.DicsubD(aDicID,xRowID))
		 	Quit:xRowID=""
		 	Set obj        = ##class(DHCMA.CPW.SD.Stand.Dicsub).GetObjById(aDicID_"||"_xRowID)
		 	Set Code       = obj.DicCode
		 	Set Desc       = obj.DicDesc  
		 	Set Resume     = obj.Resume
		 	Set Alias	   = $o(^DHCMA.CPW.SD.Stand.DicAliasI("IdxDicAlias",aDicID_"||"_xRowID,""),-1)
			//获取标准字典字项 维护内容情况
			Set ConnectInfo=..GetConnectInfo(aDicID_"||"_xRowID)
			Set Data=$lb(aDicID_"||"_xRowID,Code,Desc,Resume,Alias,ConnectInfo)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
	}else{
	 	For{
		 	Set xRowID     = $o(^DHCMA.CPW.SD.Stand.DicI("IdxSource",aSourceID,xRowID))
		 	Quit:xRowID=""
		 	Set obj        = ##class(DHCMA.CPW.SD.Stand.Dic).GetObjById(xRowID)
		 	Set Code       = obj.DicCatCode
		 	Set Desc       = obj.DicCatDesc  
		 	Set Resume     = obj.Resume
		 	Set Alias	   = $o(^DHCMA.CPW.SD.Stand.DicAliasI("IdxDicAlias",xRowID,""),-1)
		 	//获取标准字典字项 维护内容情况
		 	Set ConnectInfo=..GetConnectInfo(xRowID)
			Set Data=$lb(xRowID,Code,Desc,Resume,Alias,ConnectInfo)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}	
	}
	Quit $$$OK
}

ClassMethod QryDicListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDicListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicListExecute ]
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

/// 获取字典/字典字典绑定信息情况
ClassMethod GetConnectInfo(aDicID) As %String
{
	New (aDicID)
	Set return=""
	Quit:aDicID="" return
	Set (OrdFlg,labFlg,RisFlg,TableFlg,KeyFlg)=0
	//医嘱关联信息
	Set LinkOrder=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr(aDicID)
	Set:LinkOrder'="" OrdFlg=1
	//检验项目关联
	Set LinkCode=##class(DHCMA.CPW.SD.StandSrv.LabStandSrv).GetLinkCode(aDicID)
	Set:LinkCode'="" labFlg=1
	//检查项目关联
	
	//表字段关联
	Set TableInfo=##class(DHCMA.CPW.SD.Stand.TableInfo).GetTableStrByDic(aDicID)
	Set:TableInfo'="" TableFlg=1
	//关键字信息
	Set KeyInfo=##class(DHCMA.CPW.SD.Stand.KeyInfo).GetKeyStrByDic(aDicID)
	Set:KeyInfo'="" KeyFlg=1
	Set return=OrdFlg_"^"_labFlg_"^"_RisFlg_"^"_TableFlg_"^"_KeyFlg
	Quit return
}

/// 查询标准字典别名
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SD.StandSrv.DicSrv","QryDicAlias","125")
Query QryDicAlias(aDicID As %String) As %Query(ROWSPEC = "RowID,Alias")
{
}

ClassMethod QryDicAliasExecute(ByRef qHandle As %Binary, aDicID) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	Quit:aDicID="" $$$OK
 	Set xAlias=""
 	For{
	 	Set xAlias	= $o(^DHCMA.CPW.SD.Stand.DicAliasI("IdxDicAlias",aDicID,xAlias))
	 	Quit:xAlias=""
	 	Set xRowID  = $o(^DHCMA.CPW.SD.Stand.DicAliasI("IdxDicAlias",aDicID,xAlias,""),-1)
		Set Data=$lb(xRowID,xAlias)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryDicAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDicAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicAliasExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SD.StandSrv.DicSrv","QryAllDicList")
Query QryAllDicList() As %Query(ROWSPEC = "RowID,Code,Desc,Resume,Alias")
{
}

ClassMethod QryAllDicListExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	Set xSourceID=""
 	For {
 		Set xSourceID     = $o(^DHCMA.CPW.SD.Stand.DicI("IdxSource",xSourceID))
		Quit:xSourceID=""
		Set xSourceObj=##class(DHCMA.Util.BT.Dictionary).GetObjById(xSourceID)
		Set SourceDesc=xSourceObj.BTDesc
		w SourceDesc,!
	 	For {
		 	Set xRowID     = $o(^DHCMA.CPW.SD.Stand.DicI("IdxSource",xSourceID,xRowID))
		 	Quit:xRowID=""
		 	Set obj        = ##class(DHCMA.CPW.SD.Stand.Dic).GetObjById(xRowID)
		 	Set Code       = obj.DicCatCode
		 	Set Desc       = obj.DicCatDesc  
		 	Set Resume     = obj.Resume
		 	Set xAlias="",xDicAlias=""
		 	For{
			 	Set xAlias	= $o(^DHCMA.CPW.SD.Stand.DicAliasI("IdxDicAlias",xRowID,xAlias))
			 	Quit:xAlias=""
			 	Set xDicAlias=xDicAlias_","_xAlias
		 	}
		 	Set:xDicAlias'="" xDicAlias=$e(xDicAlias,2,$l(xDicAlias))
		 	Set keyInfo=##class(DHCMA.CPW.SD.Stand.KeyInfo).GetKeyStrByDic(xRowID)
			Set tableStr=##class(DHCMA.CPW.SD.Stand.TableInfo).GetTableStrByDic(xRowID)
		 	w "	"_Desc_"#"_xDicAlias_"#"_keyInfo_"#"_tableStr,!
		 	Set xSubID=""
		 	For{
			 	Set xSubID	= $o(^DHCMA.CPW.SD.Stand.DicsubD(xRowID,xSubID))
			 	Quit:xSubID=""
			 	Set obj        = ##class(DHCMA.CPW.SD.Stand.Dicsub).GetObjById(xRowID_"||"_xSubID)
			 	Set SubCode       = obj.DicCode
			 	Set SubDesc       = obj.DicDesc  
			 	Set SubResume     = obj.Resume
			 	Set xAlias="",xDicSubAlias=""
			 	For{
				 	Set xAlias	= $o(^DHCMA.CPW.SD.Stand.DicAliasI("IdxDicAlias",xRowID_"||"_xSubID,xAlias))
				 	Quit:xAlias=""
				 	Set xDicSubAlias=xDicSubAlias_","_xAlias
			 	}
			 	Set:xDicSubAlias'="" xDicSubAlias=$e(xDicSubAlias,2,$l(xDicSubAlias))
			 	Set keyInfo=##class(DHCMA.CPW.SD.Stand.KeyInfo).GetKeyStrByDic(xRowID_"||"_xSubID)
			 	Set tableStr=##class(DHCMA.CPW.SD.Stand.TableInfo).GetTableStrByDic(xRowID_"||"_xSubID)
			 	w "		"_SubDesc_"#"_xDicSubAlias_"#"_keyInfo_"#"_tableStr,!
	 		}
	 	}	
 	}
	Quit $$$OK
}

ClassMethod QryAllDicListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAllDicListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAllDicListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAllDicListExecute ]
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

/// d ##class(DHCMA.CPW.SD.StandSrv.DicSrv).ClearStandData()
ClassMethod ClearStandData() As %String
{
	k ^DHCMA.CPW.SD.Stand.DicD
	k ^DHCMA.CPW.SD.Stand.DicI
	k ^DHCMA.CPW.SD.Stand.DicsubD
	k ^DHCMA.CPW.SD.Stand.DicsubI
	k ^DHCMA.CPW.SD.Stand.DicAliasD
	k ^DHCMA.CPW.SD.Stand.DicAliasI
	k ^DHCMA.CPW.SD.Stand.KeyInfoD
	k ^DHCMA.CPW.SD.Stand.KeyInfoI
	k ^DHCMA.CPW.SD.Stand.OrderLinkD
	k ^DHCMA.CPW.SD.Stand.OrderLinkI
	k ^DHCMA.CPW.SD.Stand.TableInfoD
	k ^DHCMA.CPW.SD.Stand.TableInfoI
	k ^DHCMA.CPW.SD.Stand.TCLD
	k ^DHCMA.CPW.SD.Stand.TCLI
}

}
