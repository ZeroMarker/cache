Class DHCWL.BaseDataQuery.ServOfCSP Extends %RegisteredObject
{

Query GetAllTheme(args As %String) As %Query(ROWSPEC = "Name:%String,Descript:%String,ThemePath:%String")
{
}

ClassMethod GetAllThemeExecute(ByRef qHandle As %Binary, args As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s lstTheme= ##class(DHCWL.DM.T.ThemeBase).GetAll()
	s lstCnt=lstTheme.Count() 
	f pos=1:1:lstCnt {
		s Name=lstTheme.GetAt(pos).Name
		s Descript=lstTheme.GetAt(pos).Description
		s themePath=lstTheme.GetAt(pos).GetPath()
		s Data=$lb(Name,Descript,themePath)
		Do OutRow
	}	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetAllThemeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllThemeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAllThemeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllThemeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetThemeFields(args As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Descript:%String,ColType:%String,ItemType:%String,DimCode:%String,LinkDimType:%String")
{
}

ClassMethod GetThemeFieldsExecute(ByRef qHandle As %Binary, args As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s themePath=args

	s themeObj=##class(DHCWL.DM.T.ThemeBase).GetByPath(themePath)
	//维度数据
	s lstFields=themeObj.GetDims()
	s lstCnt=lstFields.Count()
	s ID=""
	f pos=1:1:lstCnt {
		
		
		s Code=lstFields.GetAt(pos).Code
		s Descript=lstFields.GetAt(pos).Name
		s ColType=lstFields.GetAt(pos).DataType
		if $ISOBJECT(ColType) s ColType=ColType.JDBCTypeCodeNum
		s DimCode=lstFields.GetAt(pos).GetLinkDim()
		if $ISOBJECT(DimCode) s DimCode=DimCode.GetPath()
		s LinkDimType=lstFields.GetAt(pos).CreateType
		if $ISOBJECT(LinkDimType) s LinkDimType=LinkDimType.GetPath()
		s ItemType="维度"
		s Data=$lb(ID,Code,Descript,ColType,ItemType,DimCode,LinkDimType)		
		
		Do OutRow
	}
	//度量数据
	s lstFields=themeObj.GetMetrics()
	s lstCnt=lstFields.Count()
	f pos=1:1:lstCnt {
		s Code=lstFields.GetAt(pos).Code
		s Descript=lstFields.GetAt(pos).Name
		s ColType=lstFields.GetAt(pos).DataType
		if $ISOBJECT(ColType) s ColType=ColType.JDBCTypeCodeNum
		s DimCode=""
		s ItemType="度量"
		s Data=$lb(ID,Code,Descript,ColType,ItemType,DimCode,"")
		Do OutRow
	}	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetThemeFieldsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetThemeFieldsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetThemeFieldsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetThemeFieldsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(DHCWL.BaseDataQuery.ServOfCSP).searchTreeNode(.inParam,outParam)
ClassMethod searchTreeNode(ByRef inParam, ByRef outParam) As %String
{
	s ret=""
	
	s searchV=inParam("searchV")
	s selNodeID=inParam("selNodeID")
	s qryObjName=inParam("qryObjName")
	k ^||DHCWLTEMP("searchTreeNode")


	//2、查找所有符合条件的节点
	s resInx=1

	s name=""
	f {
		s name=$o(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",qryObjName,name))
		q:name=""

		s itemID=$o(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",qryObjName,name,""))

		s ^||DHCWLTEMP("searchTreeNode","ITEMID",itemID)=""
		
		
	}
	
	s itemID=""
	f {
		s itemID=$o(^||DHCWLTEMP("searchTreeNode","ITEMID",itemID))
		q:itemID=""
		s itemObj=##class(DHCWL.BaseDataQuery.Item).%OpenId(itemID)
		s itemCode=itemObj.Name
		s itemDesc=itemObj.Descript
		s itemType=itemObj.Type
		s linkDimCode=itemObj.LinkDimCode
		s proCode=""
		if linkDimCode'="" {
			s dimBaseObj=##class(DHCWL.DM.T.DimBase).GetByPath(linkDimCode)
			s lstPro=dimBaseObj.GetProperties()
			s lstCnt=lstPro.Count()
			k aryPro
			f inx=1:1:lstCnt {
				s dimProObj=lstPro.GetAt(inx)
				s proCode=dimProObj.Code
				s proDesc=dimProObj.Description
				s proID=dimProObj.%Id()
				if proDesc[searchV {
					s aryPro(proID)=itemCode_"^"_proCode
				}
			}
			if $d(aryPro) {
				s proID=""
				f {
					s proID=$o(aryPro(proID))
					q:proID=""
					s itemCode=$p(aryPro(proID),"^",1)
					s proCode=$p(aryPro(proID),"^",2)
					s ^||DHCWLTEMP("searchTreeNode","节点编码",itemCode,proCode)=resInx
					s ^||DHCWLTEMP("searchTreeNode","节点序号",resInx)=itemCode_"^"_proCode
					s ^||DHCWLTEMP("searchTreeNode","节点类型",resInx)=itemType
					s resInx=resInx+1	
				}
			}
		}else{
			if itemDesc[searchV {
				s ^||DHCWLTEMP("searchTreeNode","节点编码",itemCode,"emptyPro")=resInx
				s ^||DHCWLTEMP("searchTreeNode","节点序号",resInx)=itemCode_"^emptyPro"
				s ^||DHCWLTEMP("searchTreeNode","节点类型",resInx)=itemType
				s resInx=resInx+1
			}
		}
		
		
	}
	
	s beginItemCode=""
	s beginProCode=""
	//3、返回查询结果：节点ID和路径
	if $d(^||DHCWLTEMP("searchTreeNode","节点编码")) {
		if selNodeID'="" {
			s beginItemCode=$p(selNodeID,"->",1)
			s beginProCode=$p(selNodeID,"->",2)
			if beginProCode="" s beginProCode="emptyPro"
		}
		s cursel=0
		if (beginItemCode="") {
			s cursel=0
		}else{
			if $d(^||DHCWLTEMP("searchTreeNode","节点编码",beginItemCode,beginProCode)) {
				s cursel=^||DHCWLTEMP("searchTreeNode","节点编码",beginItemCode,beginProCode)	
				if '$d(^||DHCWLTEMP("searchTreeNode","节点序号",cursel+1)) {
					s cursel=0
				}
			}
			
		}
		s cursel=cursel+1
		s selData=^||DHCWLTEMP("searchTreeNode","节点序号",cursel)
		s selType=^||DHCWLTEMP("searchTreeNode","节点类型",cursel)
		s nodeID=$p(selData,"^",1)
		s pro=$p(selData,"^",2)
		if selType="维度" s selType="dimChild"
		else  s selType="measureChild"
		s nodePath=selType
		if pro'="emptyPro" {
			s nodePath=nodePath_"/"_nodeID
			s nodeID=nodeID_"->"_pro
		}
		s outParam("nodeID")=nodeID
		s outParam("nodePath")=nodePath
	}

	q ret
}

}
