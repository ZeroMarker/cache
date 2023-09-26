/// 名称: web.DHCCPW.MRC.BaseLinkItemSrv
/// 描述: 临床路径关联项目字典相关
/// 编写者：zhufei
/// 编写日期: 2012-02-08
Class web.DHCCPW.MRC.BaseLinkItemSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  构造临床路径关联项目字典json串
/// Table：       DHCMed_CC.ItemDic
///               DHCMed_CC.ItemSubCat
///               DHCMed_CC.ItemCat
/// Input：       
/// Return：      返回树形结构json串
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseLinkItemSrv","BuildBaseLinkItemJson","-root-","")
Query BuildBaseLinkItemJson(argNodeID As %String, argOutFormat As %String) As %Query(ROWSPEC = "id:%String,text:%String,iconCls:%String,leaf:%String")
{
}

ClassMethod BuildBaseLinkItemJsonExecute(ByRef qHandle As %Binary, argNodeID As %String, argOutFormat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"BuildBaseLinkItemJson")
	
	Set Type=$p(argNodeID,"-",2)
	If Type="root" {
		Set CategID=0
		For {
			Set CategID=$o(^DHCMRC("BLIC",CategID))
			Quit:CategID=""
			Set objCateg=##class(User.DHCMRCBaseLinkItemCat).GetObjById(CategID)
			If $IsObject(objCateg){
				Set NodeID=CategID_"-Categ-"
				Set Desc=objCateg.BLICDesc
				Set Desc=$tr(Desc,"""","'")
				Set IconCls="icon-pro"
				Set Leaf="false"
				Set Data=""
				Set $li(Data,1)=$c(34)_NodeID_$c(34)
				Set $li(Data,2)=$c(34)_Desc_$c(34)
				Set $li(Data,3)=$c(34)_IconCls_$c(34)
				Set $li(Data,4)=Leaf
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		If ($o(^DHCMRC("BLIC",0))="")&&(argOutFormat=1) {
			Set NodeID="0-Categ-"
			Set Desc="请维护关联项目大类..."
			Set IconCls="icon-pro"
			Set Leaf="true"
			Set Data=""
			Set $li(Data,1)=$c(34)_NodeID_$c(34)
			Set $li(Data,2)=$c(34)_Desc_$c(34)
			Set $li(Data,3)=$c(34)_IconCls_$c(34)
			Set $li(Data,4)=Leaf
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}ElseIf Type="Categ" {
		Set CategID=$p(argNodeID,"-",1)
		Set tmp=$p(argNodeID,"-",3)
		Set SubCatCode=""
		For {
			Set SubCatCode=$o(^DHCMRCi("BLISC",0,"BLISCCodeIndex",CategID,SubCatCode))
			Quit:SubCatCode=""
			Set SubCatID=0
			For {
				Set SubCatID=$o(^DHCMRCi("BLISC",0,"BLISCCodeIndex",CategID,SubCatCode,SubCatID))
				Quit:SubCatID=""
				Set objSubCat=##class(User.DHCMRCBaseLinkItemSubCat).GetObjById(SubCatID)
				If $IsObject(objSubCat){
					Set NodeID=SubCatID_"-SubCat-"_CategID_"||"_tmp
					Set Desc=objSubCat.BLISCDesc
					Set Desc=$tr(Desc,"""","'")
					Set IconCls="icon-pro"
					Set Leaf="false"
					Set Data=""
					Set $li(Data,1)=$c(34)_NodeID_$c(34)
					Set $li(Data,2)=$c(34)_Desc_$c(34)
					Set $li(Data,3)=$c(34)_IconCls_$c(34)
					Set $li(Data,4)=Leaf
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
		
		If ($o(^DHCMRCi("BLISC",0,"BLISCCodeIndex",CategID,""))="")&&(argOutFormat=1) {
			Set NodeID="0-SubCat-"_CategID_"||"_tmp
			Set Desc="请维护监控项目子类..."
			Set IconCls="icon-pro"
			Set Leaf="true"
			Set Data=""
			Set $li(Data,1)=$c(34)_NodeID_$c(34)
			Set $li(Data,2)=$c(34)_Desc_$c(34)
			Set $li(Data,3)=$c(34)_IconCls_$c(34)
			Set $li(Data,4)=Leaf
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}ElseIf Type="SubCat" {
		Set SubCatID=$p(argNodeID,"-",1)
		Set tmp=$p(argNodeID,"-",3)
		Set ItemDicID=0
		For {
			Set ItemDicID=$o(^DHCMRCi("BLID",0,"BLIDSubCatDrIndex",SubCatID,ItemDicID))
			Quit:ItemDicID=""
			Set objItemDic=##class(User.DHCMRCBaseLinkItemDic).GetObjById(ItemDicID)
			If $IsObject(objItemDic){
				Set NodeID=ItemDicID_"-ItemDic-"_SubCatID_"||"_tmp
				Set Desc=objItemDic.BLIDDesc
				Set Desc=$tr(Desc,"""","'")
				Set IconCls="icon-menu"
				Set Leaf="true"
				Set Data=""
				Set $li(Data,1)=$c(34)_NodeID_$c(34)
				Set $li(Data,2)=$c(34)_Desc_$c(34)
				Set $li(Data,3)=$c(34)_IconCls_$c(34)
				Set $li(Data,4)=Leaf
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		If ($o(^DHCMRCi("BLID",0,"BLIDSubCatDrIndex",SubCatID,0))="")&&(argOutFormat=1) {
			Set NodeID="0-ItemDic-"_SubCatID_"||"_tmp
			Set Desc="请维护监控项目..."
			Set IconCls="icon-menu"
			Set Leaf="true"
			Set Data=""
			Set $li(Data,1)=$c(34)_NodeID_$c(34)
			Set $li(Data,2)=$c(34)_Desc_$c(34)
			Set $li(Data,3)=$c(34)_IconCls_$c(34)
			Set $li(Data,4)=Leaf
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(ZIndex,JIndex,"BuildBaseLinkItemJson")
	
	Quit $$$OK
}

ClassMethod BuildBaseLinkItemJsonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BuildBaseLinkItemJsonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod BuildBaseLinkItemJsonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BuildBaseLinkItemJsonExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  查询关联项目大类信息
/// Table：       User.DHCMRCBaseLinkItemCat
/// Input：       
/// d ##class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseLinkItemSrv","QryItemCat")
Query QryItemCat() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod QryItemCatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set CategID=0
	For {
		Set CategID=$o(^DHCMRC("BLIC",CategID))
		Quit:CategID=""
		Set objCateg=##class(User.DHCMRCBaseLinkItemCat).GetObjById(CategID)
		If $IsObject(objCateg){
			Set Code=objCateg.BLICCode
			Set Desc=objCateg.BLICDesc
			Set Data=$lb(CategID,Code,Desc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemCatExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  查询关联项目子类信息
/// Table：       User.DHCMRCBaseLinkItemSubCat
/// Input：       CategID:关联项目大类ID
/// d ##class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseLinkItemSrv","QryItemSubCat","1")
Query QryItemSubCat(argCategID As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod QryItemSubCatExecute(ByRef qHandle As %Binary, argCategID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:argCategID="" $$$OK
	Set SubCatCode=""
	For {
		Set SubCatCode=$o(^DHCMRCi("BLISC",0,"BLISCCodeIndex",argCategID,SubCatCode))
		Quit:SubCatCode=""
		Set SubCatID=0
		For {
			Set SubCatID=$o(^DHCMRCi("BLISC",0,"BLISCCodeIndex",argCategID,SubCatCode,SubCatID))
			Quit:SubCatID=""
			Set objSubCat=##class(User.DHCMRCBaseLinkItemSubCat).GetObjById(SubCatID)
			If $IsObject(objSubCat){
				Set Code=objSubCat.BLISCCode
				Set Desc=objSubCat.BLISCDesc
				Set Data=$lb(SubCatID,Code,Desc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryItemSubCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItemSubCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryItemSubCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemSubCatExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  通过关联项目代码、子分类查询关联项目信息
/// Table：       User.DHCMRCBaseLinkItemDic
/// Input：       IDCode : 监控项目代码 IDSubCatDr : 子分类
/// 
/// d ##class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseLinkItemSrv","QryItemDic","特殊检查及治疗","","1")
Query QryItemDic(argDesc As %String, argSubCatID As %String, argCategID As %String = "") As %Query(ROWSPEC = "rowid:%String,IDCode:%String,IDDesc:%String,IDSubCatDr:%String,IDExpression:%String,IDResume:%String")
{
}

ClassMethod QryItemDicExecute(ByRef qHandle As %Binary, argDesc As %String, argSubCatID As %String, argCategID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(argSubCatID="")&&(argCategID="") $$$OK
	Set SubCategID=0
	For {
		Set SubCategID=$o(^DHCMRCi("BLID",0,"BLIDSubCatDrIndex",SubCategID))
		Quit:SubCategID=""
		
		//关联项目大类过滤
		Continue:(argSubCatID'="")&&(SubCategID'=argSubCatID)
		//关联项目子类过滤
		Set objSubCateg=##class(User.DHCMRCBaseLinkItemSubCat).GetObjById(SubCategID)
		Continue:'$IsObject(objSubCateg)
		Set BLISCCatDr=""
		If $IsObject(objSubCateg.BLISCCatDr)
		{
			Set BLISCCatDr=objSubCateg.BLISCCatDr.%Id()
		}
		Continue:(argCategID'="")&&(BLISCCatDr'=argCategID)
		
		Set ItemDicID=0
		For {
			Set ItemDicID=$o(^DHCMRCi("BLID",0,"BLIDSubCatDrIndex",SubCategID,ItemDicID))
			Quit:ItemDicID=""
			Set objItemDic=##class(User.DHCMRCBaseLinkItemDic).GetObjById(ItemDicID)
			If $IsObject(objItemDic){
				Set IDCode=objItemDic.BLIDCode
				Set IDDesc=objItemDic.BLIDDesc
				Continue:(argDesc'="")&&(IDDesc'[argDesc)
				Set IDSubCatDr=""
				If $IsObject(objItemDic.BLIDSubCatDr)
				{
					Set IDSubCatDr=objItemDic.BLIDSubCatDr.%Id()
				}
				Set IDExpression=objItemDic.BLIDExpression
				Set IDResume=objItemDic.BLIDResume
				
				Set Data=$lb(ItemDicID,IDCode,IDDesc,IDSubCatDr,IDExpression,IDResume)
				Set ^CacheTemp(repid,ind)=Data
	    		Set ind=ind+1
			}
		}
	}
	
	
	Quit $$$OK
}

ClassMethod QryItemDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItemDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryItemDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemDicExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  构造电子病历模板目录json串
/// Table：       
/// Input：       
/// Return：      返回树形结构json串
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseLinkItemSrv","BuildEPRCategJson","0-root")
Query BuildEPRCategJson(argNodeID As %String) As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String,checked:%String,icon:%String,qtip:%String")
{
}

ClassMethod BuildEPRCategJsonExecute(ByRef qHandle As %Binary, argNodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set ZIndex=$zn,JIndex=$j,MethodStr="BuildEPRCategJson"
	Kill ^TMP(ZIndex,JIndex,MethodStr)
	
	Set flg=..GetTemplateCateogryInfo("0","1")
	
	Set ParCategID=+$p(argNodeID,"-",1)
	Set CategoryID=0
	For {
		Set CategoryID=$o(^TMP(ZIndex,JIndex,MethodStr,ParCategID,CategoryID))
		Quit:CategoryID=""
		
		Set CategoryList=$g(^TMP(ZIndex,JIndex,MethodStr,ParCategID,CategoryID))
		Set Desc=$list(CategoryList,3)
		If $o(^TMP(ZIndex,JIndex,MethodStr,CategoryID,0))'=""
		{
			Set Leaf="false"
		} Else {
			Set Leaf="true"
		}
		Set NodeID=$list(CategoryList,1)_"-CategoryID-"_Leaf
		
		Set Data=""
		Set $li(Data,1)=$c(34)_NodeID_$c(34)
		Set $li(Data,2)=$c(34)_Desc_$c(34)
		Set $li(Data,3)=Leaf
		Set $li(Data,4)="null"
		Set $li(Data,5)=$c(34)_"../images/websys/zreports.gif"_$c(34)
		Set $li(Data,6)=$c(34)_""_$c(34)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP(ZIndex,JIndex,MethodStr)
	
	Quit $$$OK
}

ClassMethod BuildEPRCategJsonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BuildEPRCategJsonExecute ]
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

ClassMethod BuildEPRCategJsonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BuildEPRCategJsonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTemplateCateogryInfo(aCategoryID As %String, aIsRecursive As %String) As %String
{
	New (aCategoryID,aIsRecursive,ZIndex,JIndex,MethodStr)
	Set return=0
	
	Set $ZT="GetTemplateCateogryInfoErr"
	
	Set rs=##Class(%ResultSet).%New("EPRservice.BIL.BIToWMR:GetTemplateCateogryInfo")
	Do rs.Execute(aCategoryID,aIsRecursive)
	Set columns = rs.GetColumnCount()
	While (rs.Next()) {
		Set CategoryID=rs.Data("CategoryID")
		Set ParentCategoryID=rs.Data("ParentCategoryID")
		Set CategoryName=rs.Data("CategoryName")
		Set CategoryType=rs.Data("CategoryType")
		Set ResChildCount=rs.Data("ResChildCount")
		Set ^TMP(ZIndex,JIndex,MethodStr,+ParentCategoryID,+CategoryID)=$lb(CategoryID,ParentCategoryID,CategoryName,CategoryType,ResChildCount)
	}
	Do rs.Close()
	
	Quit 1
	
GetTemplateCateogryInfoErr
	Quit 0
}

}
