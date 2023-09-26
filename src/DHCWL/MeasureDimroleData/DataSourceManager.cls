/// creator  	:wk
/// creatDate	:2017-04-05
/// Description	:该类用于数据源管理的类
Class DHCWL.MeasureDimroleData.DataSourceManager Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     获取数据库中的表信息
/// Input: 			searcheValue:搜索条件，可为空
/// Return:
/// Others:			d ##class(%ResultSet).RunQuery("DHCWL.MeasureDimroleData.DataSourceManager","GetTableInforQuery","")
Query GetTableInforQuery(packageName As %String, className As %String) As %Query(ROWSPEC = "cfgtableCode:%String,cfgtableName:%String") [ SqlProc ]
{
}

ClassMethod GetTableInforQueryExecute(ByRef qHandle As %Binary, packageName As %String, className As %String) As %Status
{
	n (qHandle,packageName,className)
	s repidC=$I(^CacheTemp)
	k ^CacheTemp(repidC)
	s qHandle=$lb(0,repidC,0)
 	s indC=1
 	if ((packageName="")||(className="")) q $$$OK
 	set rs=##class(%ResultSet).%New("web.Util.DHCJFClassGlobal:SelectClass")
	set sc=rs.Execute(packageName,className)  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	if rs.Next() {
		s ^CacheTemp(repidC,indC)=$lb(rs.GetData(1),rs.GetData(1))
		s indC=indC+1
	}
	while rs.%Next() {
		s ^CacheTemp(repidC,indC)=$lb(rs.GetData(1),rs.GetData(1))
		s indC=indC+1				
	}
	Quit $$$OK
}

ClassMethod GetTableInforQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTableInforQueryExecute ]
{
	n (qHandle)
	Set repidC=$LIST(qHandle,2)
 	Kill ^CacheTemp(repidC)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetTableInforQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTableInforQueryExecute ]
{
	n (qHandle,AtEnd,Row)
	Set AtEnd=$LIST(qHandle,1)
 	Set repidC=$LIST(qHandle,2)
 	Set indC=$LIST(qHandle,3)
 	Set indC=$o(^CacheTemp(repidC,indC))
 	If indC="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{				
 		Set Row=^CacheTemp(repidC,indC)
 	}
 	s qHandle=$lb(AtEnd,repidC,indC)
	Quit $$$OK
}

/// Creator:         wk
/// CreatDate:       2017-04-19
/// Description:     增加维护的数据源
/// Input: 			 数据源描述、数据源表名、数据源包名
/// Return:			 保存状态
/// Others:			d ##class(DHCWL.MeasureDimroleData.DataSourceManager).AddDSource()
ClassMethod AddDSource(dsDesc, packageName, tableName)
{
	n (dsDesc,packageName,tableName)
	s sc="ok"
	s flag=0
	if $d(^DHCWL.MeasureDimrole.DSourceI("DSTableName"," "_$zcvt(tableName,"U"))){
		s dsID=""
		for{
			s dsID=$o(^DHCWL.MeasureDimrole.DSourceI("DSTableName"," "_$zcvt(tableName,"U"),dsID))
			q:dsID=""
			s dspak=$lg(^DHCWL.MeasureDimrole.DSourceD(dsID),2)
			s voidFlag=$lg(^DHCWL.MeasureDimrole.DSourceD(dsID),5)
			if (dspak=packageName)&(voidFlag=""){
				s flag=1
			}
		}
	}
	q:flag=1 "相同的数据源不能同时维护"
	&sql(INSERT INTO DHCWL_MeasureDimrole.DSource(Ds_Desc,Ds_PackName,Ds_TableName) VALUES(:dsDesc,:packageName,:tableName))
	i SQLCODE=0{
		s sc="ok"
	}else{
		s sc="保存失败"
	}
	q sc
}

/// Creator:         wk
/// CreatDate:       2017-04-19
/// Description:     获取数据源表中的属性
/// Input: 			 数据源表名、数据源包名
/// Return:			 数据源表中的属性信息
/// d ##class(%ResultSet).RunQuery("DHCWL.MeasureDimroleData.DataSourceManager","SelectProperty","")
Query SelectProperty(packageName As %String, className As %String, masterIndexName As %String = "") As %Query(ROWSPEC = "sqlfieldName:%String,type:%String")
{
}

ClassMethod SelectPropertyExecute(ByRef qHandle As %Binary, packageName As %String, className As %String, masterIndexName As %String) As %Status
{
	n (qHandle,packageName,className,masterIndexName)
	Set repid=$I(^CacheTemp)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
	i (packageName="")||(className="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s dsID=""
	for {
		s dsID=$o(^DHCWL.MeasureDimrole.DSourceI("DSPackTable"," "_$zcvt(packageName,"U")," "_$zcvt(className,"U"),dsID))
		q:dsID=""
		s voidFlag=$lg(^DHCWL.MeasureDimrole.DSourceD(dsID),5)
		continue:voidFlag="1"
		q:voidFlag=""
	}
	i dsID="" Quit $$$OK
	s classAllName=packageName_"."_className
	Set rsltSt = ##class(%ResultSet).%New("%Dictionary.PropertyDefinition:Summary")
	do rsltSt.Execute(classAllName)
	While(rsltSt.Next()) {
		s (propertyName,propertyNode,propertyDeli,propertyPiece,propertyType,propertyField,propertyColumn)=""
		set propertyName=rsltSt.Data("Name")
		set propertyId=classAllName_"||"_propertyName
		set propObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId,0)
		set propertyType=propObj.Type
		if ($l(propertyType,".")=1)&&($l(propertyType,"%")=1) s propertyType="User."_propertyType
		set propertyField=propObj.SqlFieldName
		if ($l(propertyType,"%")>1)  s propertyType=$p(propertyType,"%",2,$l(propertyType,"%"))
		s itemID="",voidFlag="",flag=0
		for {
			s itemID=$o(^DHCWL.MeasureDimrole.DSItemI("ItemDSDr",dsID," "_$zcvt(propertyField,"U"),itemID))
			q:itemID=""
			s voidFlag=$lg(^DHCWL.MeasureDimrole.DSItemD(itemID),8)
			continue:voidFlag="1"
			s:voidFlag="" flag=1
			//continue:$d(^DHCWL.MeasureDimrole.DSItemI("ItemDSDr",dsID," "_$zcvt(propertyField,"U")))	
		}
		continue:flag=1
		Set ^CacheTemp(repid,ind)=$lb(propertyField,propertyType)
 		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod SelectPropertyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPropertyExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectPropertyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPropertyExecute ]
{
	n (qHandle,Row,AtEnd) 
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
	 	Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     获取维护的数据源
/// Return:			 
/// Others:			d ##class(%ResultSet).RunQuery("DHCWL.MeasureDimroleData.DataSourceManager","GetDataSourceQuery","")
Query GetDataSourceQuery() As %Query(ROWSPEC = "ID:%String,dsPackage:%String,dsTable:%String,dsDesc:%String") [ SqlProc ]
{
}

ClassMethod GetDataSourceQueryExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle,packageName,className)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s dsID=""
 	for{
	 	s dsID=$o(^DHCWL.MeasureDimrole.DSourceD(dsID))
	 	q:dsID=""
	 	s dsPackName=$lg(^DHCWL.MeasureDimrole.DSourceD(dsID),2)
	 	s dsTableName=$lg(^DHCWL.MeasureDimrole.DSourceD(dsID),3)
	 	s dsDesc=$lg(^DHCWL.MeasureDimrole.DSourceD(dsID),4)
	 	s voidFlag=$lg(^DHCWL.MeasureDimrole.DSourceD(dsID),5)
	 	continue:voidFlag=1
	 	s ^CacheTemp(repid,ind)=$lb(dsID,dsPackName,dsTableName,dsDesc)
		s ind=ind+1	
 	}			
	Quit $$$OK
}

ClassMethod GetDataSourceQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataSourceQueryExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetDataSourceQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataSourceQueryExecute ]
{
	n (qHandle,AtEnd,Row)
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

/// Creator:         wk
/// CreatDate:       2017-04-19
/// Description:     增加维护的数据源条目
/// Input: 			 条目名称、条目描述、条目类型、条目数据类型、ID
/// Return:          增加状态
/// Others:			d ##class(DHCWL.MeasureDimroleData.DataSourceManager).AddDSourceItem("")
ClassMethod AddDSourceItem(strItemNames, strItemDescs, strItemTypes, strItemDataTypes, strValues, ID)
{
	n (strItemNames,strItemDescs,strItemTypes,strItemDataTypes,strValues,ID)
	s sc="ok"
	s flag=0
	s reflag=0
	s len=$l(strItemNames,",")
	for i=1:1:len {
		s flag=0
		s strItemName=$p(strItemNames,",",i)
		q:strItemName=""
		s strItemDesc=$p(strItemDescs,",",i)
		s strItemDataType=$p(strItemDataTypes,",",i)
		s strItemType=$p(strItemTypes,",",i)
		s strValue=$p(strValues,",",i)
		//continue:$d(^DHCWL.MeasureDimrole.DSItemI("ItemDSDr",ID," "_$zcvt(strItemName,"U")))
		s itemID=""
		for{
			s itemID=$o(^DHCWL.MeasureDimrole.DSItemI("ItemDSDr",ID," "_$zcvt(strItemName,"U"),itemID))
			q:itemID=""
			s voidFlag=$lg(^DHCWL.MeasureDimrole.DSItemD(itemID),8)
			if (voidFlag=""){
				s flag=1
				s reflag=1
				q
			}
		} 
		continue:flag=1
		&sql(INSERT INTO DHCWL_MeasureDimrole.DSItem(DsItem_Name,DsItem_Desc,DsItem_ItemType,DsItem_ItemDataType,DsItem_ItemDSDr,DsItem_ExpValue) VALUES(:strItemName,:strItemDesc,:strItemType,:strItemDataType,:ID,:strValue))
		i SQLCODE'=0{
			s flag=1
			q
		}
	}
	q:reflag=1 "增加成功,编码重复的信息已被过滤"
	q:flag=1 "增加失败"
	q sc
}

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     获取维护的数据源明细
/// Return:
/// Others:			d ##class(%ResultSet).RunQuery("DHCWL.MeasureDimroleData.DataSourceManager","GetDSItemQuery","")
Query GetDSItemQuery(tableName As %String = "", detail As %String = "") As %Query(ROWSPEC = "ID:%String,itemName:%String,itemDesc:%String,itemType:%String,dataType:%String,tableName:%String,packName:%String,expvalue:%String") [ SqlProc ]
{
}

ClassMethod GetDSItemQueryExecute(ByRef qHandle As %Binary, tableID As %String, detail As %String) As %Status
{
	n (qHandle,tableID,detail)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s detail=$zcvt(detail,"U")
 	s dsItemID=""
 	for{
	 	s dsItemID=$o(^DHCWL.MeasureDimrole.DSItemD(dsItemID))
	 	q:dsItemID=""
	 	s code=$lg(^DHCWL.MeasureDimrole.DSItemD(dsItemID),2)
	 	s desc=$lg(^DHCWL.MeasureDimrole.DSItemD(dsItemID),3)
	 	s ItemType=$lg(^DHCWL.MeasureDimrole.DSItemD(dsItemID),4)
	 	s ItemDataType=$lg(^DHCWL.MeasureDimrole.DSItemD(dsItemID),5)
	 	s ItemDSDr=$lg(^DHCWL.MeasureDimrole.DSItemD(dsItemID),6)
	 	s expvalue=$lg(^DHCWL.MeasureDimrole.DSItemD(dsItemID),7)
	 	s voidFlag=$lg(^DHCWL.MeasureDimrole.DSItemD(dsItemID),8)
	 	continue:voidFlag=1
	 	continue:ItemDSDr'[tableID
	 	s packName=$lg(^DHCWL.MeasureDimrole.DSourceD(ItemDSDr),2)
	 	s tableName=$lg(^DHCWL.MeasureDimrole.DSourceD(ItemDSDr),3)
	 	s desc=$replace(desc,"'","")
	 	continue:($zcvt(code,"U")'[detail)&($zcvt(desc,"U")'[detail)&($zcvt(ItemType,"U")'[detail)&($zcvt(ItemDataType,"U")'[detail)&($zcvt(packName,"U")'[detail)&($zcvt(expvalue,"U")'[detail)
	 	s ^CacheTemp(repid,ind)=$lb(dsItemID,code,desc,ItemType,ItemDataType,packName,tableName,expvalue)
		s ind=ind+1	
 	}			
	Quit $$$OK
}

ClassMethod GetDSItemQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDSItemQueryExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetDSItemQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDSItemQueryExecute ]
{
	n (qHandle,AtEnd,Row)
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

/// Creator:         wk
/// CreatDate:       2017-04-19
/// Description:     修改维护的数据源明细
/// Input: 			 数据源ID和数据源描述
/// Return:			 修改状态
/// Others:			 d ##class(DHCWL.MeasureDimroleData.DataSourceManagerDHCWL.MeasureDimroleData.DataSourceManager).ModifyDSItem("")
ClassMethod ModifyDSItem(ID, desc)
{
	n (ID,desc)
	s sc="ok"
	s flag=0
	q:'$d(^DHCWL.MeasureDimrole.DSItemD(ID)) "修改的条目不存在"
	&sql(UPDATE DHCWL_MeasureDimrole.DSItem SET DsItem_Desc =:desc WHERE ID =:ID)
	i SQLCODE=0{
		s sc="ok"
	}else{
		s sc="保存失败"
	}
	q:flag=1 "增加失败"
	q sc
}

/// Creator:         wk
/// CreatDate:       2017-04-19
/// Description:     删除维护的数据源明细
/// Input: 			 数据源ID
/// Return:			 删除状态
/// Others:			d ##class(DHCWL.MeasureDimroleData.DataSourceManager).DeleteDSItem("")
ClassMethod DeleteDSItem(ID)
{
	n (ID)
	s sc="ok"
	q:'$d(^DHCWL.MeasureDimrole.DSItemD(ID)) "删除的条目不存在"
	//&sql(delete from DHCWL_MeasureDimrole.DSItem WHERE ID =:ID)
	&sql(UPDATE DHCWL_MeasureDimrole.DSItem SET DsItem_VoidFlag = 1  WHERE ID =:ID)
	i SQLCODE=0{
		s sc="ok"
	}else{
		s sc="保存失败"
	}
	q sc
}

}
