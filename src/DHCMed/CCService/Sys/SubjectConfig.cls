/// 名称: DHCMed.CCService.Sys.SubjectConfig
/// 描述: 主题配置的常用操作
/// 编写者：liuyh
/// 编写日期: 2013-02-25
Class DHCMed.CCService.Sys.SubjectConfig Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2013-02-25
/// Description:  查询主题配置
/// Table：       DHCMed.CC.SubjectConfig       
/// D ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.SubjectConfig","QrySubjectConfig","","")
Query QrySubjectConfig(aIsActive As %String = "", aSubjectCode As %String) As %Query(ROWSPEC = "RowId:%String,Code:%String,Desc:%String,IsActive:%String,IsActiveDesc:%String,Resume:%String,SubjectCode:%String,SubjectDesc:%String")
{
}

ClassMethod QrySubjectConfigExecute(ByRef qHandle As %Binary, aIsActive As %String = "", aSubjectCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set rowid=""
 	For {
	 	Set rowid=$o(^DHCMed.CC.SubjectConfigD(rowid))
	 	Quit:rowid=""
	 	
		Set obj=##class(DHCMed.CC.SubjectConfig).GetObjById(rowid)
		Continue:'$IsObject(obj)
		Set SubjectCode=obj.SubjectCode
		
		Continue:(aSubjectCode'="")&&(aSubjectCode'=SubjectCode)
		Set SubjectDesc=""
		If SubjectCode'="" {
			Set objSubject=##Class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
			Set SubjectDesc=objSubject.Title
		}
		Set IPCode=obj.Code
		Set IPDesc=obj.Description
		Set IPActive=obj.IsActive
		Continue:(aIsActive'="")&&(IPActive'=aIsActive)
		Set IPActiveDesc=$s(IPActive=1:"是",1:"否")
		Set IPResume=obj.ResumeText
		 	
		Set Data=$lb(rowid,IPCode,IPDesc,IPActive,IPActiveDesc,IPResume,SubjectCode,SubjectDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QrySubjectConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySubjectConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySubjectConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySubjectConfigExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2013-02-25
/// Description:  查询监控项目子类
/// Table：       DHCMed.CC.ItemSubCat     
/// D ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.SubjectConfig","QrySubCatByConfig","2","Y")
Query QrySubCatByConfig(aConfigID As %String, aIsViewAll As %String) As %Query(ROWSPEC = "MapID:%String,IPRowID:%String,IPCode:%String,IPDesc:%String,IDRowID:%String,IDCode:%String,IDDesc:%String,IsChecked:%String")
{
}

ClassMethod QrySubCatByConfigExecute(ByRef qHandle As %Binary, aConfigID As %String, aIsViewAll As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aConfigID="" $$$OK
 	
 	If aIsViewAll="Y" {
		 Set xID=0
		 For {
			 Set xID=$o(^DHCMed.CC("ISubCat",xID))
			 Quit:xID=""
			 	
			 Set (MapID,IPRowID,IPCode,IPDesc,IDRowID,IDCode,IDDesc)=""
			 Set MapID=$o(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",aConfigID,xID,0))
			 If MapID'="" {
				 Set objMap=##class(DHCMed.CC.MapSubjectSubCat).GetObjById(MapID)
				 Continue:'$IsObject(objMap)
				 Continue:'$IsObject(objMap.MPSubjectConfigDr)
				 Set IPRowID=objMap.MPSubjectConfigDr.%Id()
				 Set IPCode=objMap.MPSubjectConfigDr.Code
				 Set IPDesc=objMap.MPSubjectConfigDr.Description
				 Set IPActive=objMap.MPSubjectConfigDr.IsActive
				 Set:IPActive'=1 IPDesc="*"_IPDesc
				 Continue:'$IsObject(objMap.MPItemSubCatDr)
				 Set IDRowID=objMap.MPItemSubCatDr.%Id()
				 Set IDCode=objMap.MPItemSubCatDr.ISCCode
				 Set IDDesc=objMap.MPItemSubCatDr.ISCDesc
				 Set IsChecked=1
			} Else {
				Set obj=##class(DHCMed.CC.ItemSubCat).GetObjById(xID)
				Continue:'$IsObject(obj)
				Set IDRowID=obj.%Id()
				Set IDCode=obj.ISCCode
				Set IDDesc=obj.ISCDesc
				Set IsChecked=0
			}
			Set SubjectCode=$$GetSubjectCodeBySubCatID(IDRowID)
			Continue:SubjectCode'="INTCC"	
			Set Data=$lb(MapID,IPRowID,IPCode,IPDesc,IDRowID,IDCode,IDDesc,IsChecked)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} Else {
	 	Set MapID=0
	 	For {
		 	Set MapID=$o(^DHCMed.CC.MapSubjectSubCatI("IndexConfig",aConfigID,MapID))
		 	Quit:MapID=""
		 	Set objMap=##class(DHCMed.CC.MapSubjectSubCat).GetObjById(MapID)
		 	Continue:'$IsObject(objMap)
		 	Continue:'$IsObject(objMap.MPSubjectConfigDr)
		 	Set IPRowID=objMap.MPSubjectConfigDr.%Id()
		 	Set IPCode=objMap.MPSubjectConfigDr.Code
		 	Set IPDesc=objMap.MPSubjectConfigDr.Description
		 	Set IPActive=objMap.MPSubjectConfigDr.IsActive
		 	Set:IPActive'=1 IPDesc="*"_IPDesc
		 	Continue:'$IsObject(objMap.MPItemSubCatDr)
		 	Set IDRowID=objMap.MPItemSubCatDr.%Id()
		 	Set IDCode=objMap.MPItemSubCatDr.ISCCode
		 	Set IDDesc=objMap.MPItemSubCatDr.ISCDesc

		 	Set IsChecked=1
		 	
		 	Set SubjectCode=$$GetSubjectCodeBySubCatID(IDRowID)
			Continue:SubjectCode'="INTCC"	
		 	Set Data=$lb(MapID,IPRowID,IPCode,IPDesc,IDRowID,IDCode,IDDesc,IsChecked)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
 	}
	
	Quit $$$OK

GetSubjectCodeBySubCatID(SubCatID)
	Set return=""
	Quit:SubCatID="" return
	Set sObj=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
	Quit:'$IsObject(sObj) return
	
	Set ISCCatDr=sObj.ISCCatDr
	Quit:ISCCatDr="" return
	
	Set iObj=##class(DHCMed.CC.ItemCat).GetObjById(ISCCatDr)
	Quit:'$IsObject(iObj) return
	Set SubjectDr=iObj.SubjectDr
	
	Quit:SubjectDr="" return
	
	Set SubObj=##class(DHCMed.CC.Subject).GetObjById(SubjectDr)
	Quit:'$IsObject(SubObj) return
	
	Set return=SubObj.Code
	
	Quit return
}

ClassMethod QrySubCatByConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySubCatByConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySubCatByConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySubCatByConfigExecute ]
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

ClassMethod BuildSubjectAppJson(argSubjectCode As %String, SubjectConfigID As %String) As %List
{
	New (argSubjectCode,SubjectConfigID)
	Set Json=""
	Set $ZT="BuildSubjectAppJsonErr"
	
	Quit:(argSubjectCode="")||(SubjectConfigID="") ""
	Set argSubjectID=$o(^DHCMed.CCi("Subject",0,"CodeIndex"," "_$zcvt(argSubjectCode,"U"),0))
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"BuildSubjectAppJson")
	
	Set SubjectID=0
	For {
		Set SubjectID=$o(^DHCMed.CC("Subject",SubjectID))
		Quit:SubjectID=""
		Continue:argSubjectID'=SubjectID
		Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
		Continue:'$IsObject(objSubject)
		Set SubActive=objSubject.IsActive
		Continue:SubActive'=1     //1有效,0无效
		Set ^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID)=""
		Set IsActive=""
		For {
			Set IsActive=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",SubjectID,IsActive))
			Quit:IsActive=""
			Continue:IsActive'=1  //1有效,0无效
			Set ItemID=0
			For {
				Set ItemID=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",SubjectID,IsActive,ItemID))
				Quit:ItemID=""
				Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
				Continue:'$IsObject(objItem)
				Set ItemDicDR=objItem.ItemDic
				Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicDR)
				Continue:'$IsObject(objItemDic)
				Set ItemSubCatDR=objItemDic.IDSubCatDr
				Set objItemSubcat=##class(DHCMed.CC.ItemSubCat).GetObjById(ItemSubCatDR)
				Continue:'$IsObject(objItemSubcat)
				Set ItemCatDR=objItemSubcat.ISCCatDr
				Set objCat=##class(DHCMed.CC.ItemCat).GetObjById(ItemCatDR)
				Continue:'$IsObject(objCat)
				//Set LocDr=objCat.LocDr
				
				Set ^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,ItemCatDR,ItemSubCatDR,ItemDicDR,ItemID)=""
				//w "ItemCatDR="_ItemCatDR_",ItemSubCatDR="_ItemSubCatDR_",ItemDicDR="_ItemDicDR,!
			}
		}
	}
	
	Set SubjectID=0
	For {
		Set SubjectID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID))
		Quit:SubjectID=""
		Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
		Continue:'$IsObject(objSubject)
		
		Write:Json'="" Json
		Set JsonItem="[{"_"""id"":"""_SubjectID_"-S-"",""text"":"""_$tr(objSubject.Title,"""","'")
		Set JsonItem=JsonItem_""",""iconCls"":""icon-pro"",""expanded"":true,"
		
	
		//Set JsonItem=JsonItem_"""checked"":false,"
	
		Set JsonLocItem=JsonItem_"""children"":["
		Write JsonLocItem  //输出JsonLoc1
			
		Set CategID=0,JsonA=""
		For {
			Set CategID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,CategID))
			Quit:CategID=""
			Set objCateg=##class(DHCMed.CC.ItemCat).GetObjById(CategID)
			Continue:'$IsObject(objCateg)
				
			Set SubCatID=0
			For {
				Set SubCatID=$o(^TMP(ZIndex,JIndex,"BuildSubjectAppJson",SubjectID,CategID,SubCatID))
				Quit:SubCatID=""
				Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
				Continue:'$IsObject(objSubCat)
					
				Write:JsonA'="" JsonA
				Set JsonAItem="{"_"""id"":"""_SubjectID_"||"_CategID_"||"_SubCatID_""",""text"":"""_$tr(objCateg.ICDesc,"""","'")_"  "_$tr(objSubCat.ISCDesc,"""","'")_""","
				Set JsonAItem=JsonAItem_"""expanded"":true,"
				If $d(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",SubjectConfigID,SubCatID)) {
					Set JsonAItem=JsonAItem_"""checked"":true,"
				}Else{
					Set JsonAItem=JsonAItem_"""checked"":false,"
				}
				Set JsonAItem=JsonAItem_"""iconCls"":""icon-pro"","
				Set JsonAItem=JsonAItem_"""children"":["
				Write JsonAItem  //输出JsonA1
				
				Write "]}"  //输出JsonA2
				Set JsonA=","
			}
		}
		Write "]}]"  //输出Json2
		Set Json=","
	}
	
	Kill ^TMP(ZIndex,JIndex,"BuildSubjectAppJson")
	Write:Json="" "[]"  //输出Json
	Quit 1
	
BuildSubjectAppJsonErr
	Write "Error:"_$ZERROR,!
	Quit 0
}

/// 根据主题配置代码获取监控主题ID
/// 入参数 DHCMed.CC.SubjectConfig.Code
/// w ##class(DHCMed.CCService.Sys.SubjectConfig).GetSubjectIDByConfigCode("INTCCS")
ClassMethod GetSubjectIDByConfigCode(aConfigCode As %String) As %String
{
	New (aConfigCode)
	Set return=""
	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(aConfigCode)
	Quit:'$IsObject(objConfig) return
	Set SubjectCode=objConfig.SubjectCode
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) return
	Set return=objSubject.%Id()
	
	Quit return
}

/// 通过主题配置代码取对应监控项目
/// w ##Class(DHCMed.CCService.Sys.SubjectConfig).GetCtrlItemsByConfigCode("INTCCS")
ClassMethod GetCtrlItemsByConfigCode(ConfigCode As %String)
{
	New (ConfigCode)
	Set return=""
	Quit:ConfigCode="" return
	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(ConfigCode)
	Quit:'$IsObject(objConfig) return
	Set SubjectCode=objConfig.SubjectCode
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) return
	Set SubjectID=objSubject.%Id()
	
	Set objArry=##Class(DHCMed.CCService.Lib.Common).GetSubjectDisplayConfig(SubjectCode,ConfigCode)
	For ind=1:1:objArry.Count() {
		Set objSubCat=objArry.GetAt(ind)
		Continue:'$IsObject(objSubCat)
		
		Set SubCatID=objSubCat.%Id()
		Set objCat=##class(DHCMed.CC.ItemCat).GetObjById(objSubCat.ISCCatDr)
		Continue:'$IsObject(objCat)
		
		Set ItemDicID=""
		For {
			Set ItemDicID=$o(^DHCMed.CCi("ItemDic",0,"IDSubCatDrIndex",SubCatID,ItemDicID))
			Quit:ItemDicID=""
			
			Set SubjectItemID=$o(^DHCMed.CCi("SItem",0,"IndexItemDic",SubjectID,ItemDicID,""))
			Continue:SubjectItemID=""
			Set return=return_"/"_SubjectItemID
		}
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

/// 通过主题配置代码取对应监控项目
/// w ##Class(DHCMed.CCService.Sys.SubjectConfig).GetCtrlSubCatsByConfigCode("INTCCS")
ClassMethod GetCtrlSubCatsByConfigCode(ConfigCode As %String)
{
	New (ConfigCode)
	Set return=""
	Quit:ConfigCode="" return
	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(ConfigCode)
	Quit:'$IsObject(objConfig) return
	Set SubjectCode=objConfig.SubjectCode
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) return
	Set SubjectID=objSubject.%Id()
	
	Set SubCatList=""
	Set objArry=##Class(DHCMed.CCService.Lib.Common).GetSubjectDisplayConfig(SubjectCode,ConfigCode)
	For ind=1:1:objArry.Count() {
		Set objSubCat=objArry.GetAt(ind)
		Continue:'$IsObject(objSubCat)
		
		Set SubCatID=objSubCat.%Id()
		Set objCat=##class(DHCMed.CC.ItemCat).GetObjById(objSubCat.ISCCatDr)
		Continue:'$IsObject(objCat)
		Continue:$listfind(SubCatList,SubCatID)>0
		
		Set SubCatList=SubCatList_$lb(SubCatID)
		Set return=return_"/"_SubCatID
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

}
