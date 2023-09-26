Class DHCWL.CodeCfgData.CodeTypeItemQuery Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 取通过执行代码取每个类型下面所有项目
/// d ##class(%ResultSet).RunQuery("DHCWL.CodeCfgData.CodeTypeItemQuery","CodeTypeItemQuery","1","Code","")
Query CodeTypeItemQuery(typeId As %Text) As %Query(ROWSPEC = "ID:%String,ItemCode:%String,ItemDesc:%String") [ SqlProc ]
{
}

ClassMethod CodeTypeItemQueryoldExecute(ByRef qHandle As %Binary, typeId As %Text, searcheCond = "", searcheValue = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:typeId="" ""
	s count=0
	//s typeId=$list(^DHCWL.CodeCfg.GroupD(grpid),7)
	s count=##class(DHCWL.CodeCfg.Type).GetCfgTypeDataById(typeId)
 	f num=0:1:count-1  d  //3368    
	.s itemList=$g(^TEMPDHCWLCode($j,num))
	.s ID=$p(itemList,"^",1)
	.s ItemCode=$p(itemList,"^",2)
	.s ItemDesc=$p(itemList,"^",3)
	.i (searcheCond="Code")&(searcheValue'="") q:ItemCode'[searcheValue
	.i (searcheCond="Name")&(searcheValue'="") q:ItemDesc'[searcheValue
	.;q:ind>1000    //暂时只显示1000条
	.s ^CacheTemp(repid,ind)=$lb(ID,ItemCode,ItemDesc)
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod CodeTypeItemQueryExecute(ByRef qHandle As %Binary, typeId As %Text, searcheCond = "", searcheValue = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:typeId="" ""
	s count=0
	//s typeId=$list(^DHCWL.CodeCfg.GroupD(grpid),7)
	//s count=##class(DHCWL.CodeCfg.Type).GetCfgTypeDataById(typeId)
	s count=##class(DHCWL.CodeCfgData.CodeTypeItemQuery).QryDimValuesByDimType(typeId)
 	f num=0:1:count-1  d  //3368    
	.s itemList=$g(^TEMPDHCWLCode($j,num))
	.s ID=$p(itemList,"^",1)
	.s ItemCode=$p(itemList,"^",2)
	.s ItemDesc=$p(itemList,"^",3)
	.i (searcheCond="Code")&(searcheValue'="") q:ItemCode'[searcheValue
	.i (searcheCond="Name")&(searcheValue'="") q:ItemDesc'[searcheValue
	.;q:ind>1000    //暂时只显示1000条
	.s ^CacheTemp(repid,ind)=$lb(ID,ItemCode,ItemDesc)
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod CodeTypeItemQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CodeTypeItemQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod CodeTypeItemQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CodeTypeItemQueryExecute ]
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

// d ##class(%ResultSet).RunQuery("DHCWL.CodeCfgData.CodeTypeItemQuery","GetSubGrpItemQuery","92")

Query GetSubGrpItemQuery(subgrpId As %Text, filterValue As %String) As %Query(ROWSPEC = "ID:%String,dimID:%String,ItemDesc:%String,sortValue:%String,ItemCode:%String") [ SqlProc ]
{
}

ClassMethod GetSubGrpItemQueryExecute(ByRef qHandle As %Binary, subgrpId As %Text, filterValue As %String, searcheCond As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:subgrpId="" ""
	/*s subGrpItemList=""
	s subgrpItemId=0 f  s subgrpItemId=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId,subgrpItemId)) q:subgrpItemId=""  d
	.s id=0 f  s id=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId,subgrpItemId,id)) q:id=""  d
	..s count=count+1
	..s grpDr=$list(^DHCWL.CodeCfg.SubGroupItemD(id),4)
	..s typeDr=$list(^DHCWL.CodeCfg.GroupD(grpDr),7)
	..s itemDesc=$p(##class(DHCWL.CodeCfg.Type).GetValueDeseById(typeDr,subgrpItemId),"@")
	..s ^CacheTemp(repid,ind)=$lb(id,itemDesc)
	..s ind=ind+1*/
	//modify by wk~2017-11-13~改为以排序值顺序输出
	/*s subGrpItemList=""
	s subgrpItemId=0 f  s subgrpItemId=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId,subgrpItemId)) q:subgrpItemId=""  d
	.s id=0 f  s id=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId,subgrpItemId,id)) q:id=""  d
	..s grpDr=$list(^DHCWL.CodeCfg.SubGroupItemD(id),4)
	..s sort=$list(^DHCWL.CodeCfg.SubGroupItemD(id),7)
	..//s typeDr=$list(^DHCWL.CodeCfg.GroupD(grpDr),7)
	..s typeDr=$list(^DHCWL.CodeCfg.GroupD(grpDr),11)    //取维度ID
	..s subgrpDetailId=$list(^DHCWL.CodeCfg.SubGroupItemD(id),2)  //add by wk~2017-07-03~解决获取到的明细ID是大写的问题
	..s itemId=$tr(subgrpDetailId," ")
	..//s itemDesc=$p(##class(DHCWL.CodeCfg.Type).GetValueDeseById(typeDr,itemId),"@")
	..s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(typeDr,itemId)
	..q:itemDesc'[filterValue
	..;q:ind>1000 
	..s ^CacheTemp(repid,ind)=$lb(id,itemDesc,sort)
	..s ind=ind+1*/
	s flag=0
	if ('$d(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subgrpId)))&&($d(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId))) d
	.s sc=##class(DHCWL.CodeCfgData.FunctionModule).UpdateGrpItemSort(subgrpId)
	.s:sc'="ok" flag=1
	q:flag=1 $$$OK
	s subGrpItemList=""
	s subGrpItemSort="" f  s subGrpItemSort=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subgrpId,subGrpItemSort)) q:subGrpItemSort=""  d
	.s subgrpItemId=0 f  s subgrpItemId=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subgrpId,subGrpItemSort,subgrpItemId)) q:subgrpItemId=""  d
	..s id=0 f  s id=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subgrpId,subGrpItemSort,subgrpItemId,id)) q:id=""  d
	...s grpDr=$list(^DHCWL.CodeCfg.SubGroupItemD(id),4)
	...s sort=$lg(^DHCWL.CodeCfg.SubGroupItemD(id),7)
	...s itemCode=$lg(^DHCWL.CodeCfg.SubGroupItemD(id),6)
	...//s typeDr=$list(^DHCWL.CodeCfg.GroupD(grpDr),7)
	...s typeDr=$list(^DHCWL.CodeCfg.GroupD(grpDr),11)    //取维度ID
	...s subgrpDetailId=$list(^DHCWL.CodeCfg.SubGroupItemD(id),2)  //add by wk~2017-07-03~解决获取到的明细ID是大写的问题
	...s itemId=$tr(subgrpDetailId," ")
	...//s itemDesc=$p(##class(DHCWL.CodeCfg.Type).GetValueDeseById(typeDr,itemId),"@")
	...s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(typeDr,itemId)
	...;q:itemDesc'[filterValue
	...i (searcheCond="Code")&(filterValue'="") q:##class(DHCWL.CodeCfgData.CheckGrpItemQuery).FilterValue(itemCode,filterValue)=0
	...i (searcheCond="Name")&(filterValue'="") q:##class(DHCWL.CodeCfgData.CheckGrpItemQuery).FilterValue(itemDesc,filterValue)=0
	...;q:ind>1000 
	...s ^CacheTemp(repid,ind)=$lb(id,itemId,itemDesc,sort,itemCode)
	...s ind=ind+1
	
	Quit $$$OK
}

ClassMethod GetSubGrpItemQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSubGrpItemQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetSubGrpItemQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSubGrpItemQueryExecute ]
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

/// Creator：      	
/// CreatDate：    	2015-5-5
/// Description:： 	通过维度取数规则，得到维度属性值
/// Table：       	
/// Input：          dimType：
/// 						维度类型
/// Output：        count:执行代码返回记录数
/// 				
/// Return：         
/// Others：        
/// w ##class(DHCWL.CodeCfgData.CodeTypeItemQuery).QryDimValuesByDimType("CTLOC")
ClassMethod QryDimValuesByDimType(dimTypeID) As %Status
{
    n (dimTypeID)
    k ^TEMPDHCWL($j)
	K ^TEMPDHCWLCode($j)
	//得到维度类型的执行代码
	s typeExeCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimTypeID),9)
	q:$g(typeExeCode)="" 0
	s count=0
    s execCode="s count=$$"_typeExeCode_"()"
    x execCode
 	q count
}

}
