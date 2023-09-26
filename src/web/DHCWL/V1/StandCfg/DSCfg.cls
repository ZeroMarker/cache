/// Creator   : wk
/// CreatDate : 2018-10-12
/// Desc      : 数据源维护
Class web.DHCWL.V1.StandCfg.DSCfg Extends %RegisteredObject
{

/// Creator   : wk
/// CreatDate : 2018-10-12
/// Desc      : 数据源数据获取
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.StandCfg.DSCfg","GetDS","")
Query GetDS() As websys.Query(ROWSPEC = "ID:%String,dsPackage:%String,dsTable:%String,dsDesc:%String") [ SqlProc ]
{
}

ClassMethod GetDSExecute(ByRef qHandle As %Binary) As %Status
{
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

/// Creator   : wk
/// CreatDate : 2018-10-12
/// Desc      : 获取表名
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.StandCfg.DSCfg","GetTableList","")
Query GetTableList(packageName As %String, className As %String) As websys.Query(ROWSPEC = "sort:%String,tableName:%String") [ SqlProc ]
{
}

ClassMethod GetTableListExecute(ByRef qHandle As %Binary, packageName As %String, className As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:packageName="" $$$OK
 	k PLIST
 	s sog=$System.OBJ.GetPackageList(.PLIST,packageName,"")
 	q:('sog) $$$OK
 	s:className'="" className=$zcvt(className,"U")
 	s name=""
 	s count=0
 	for {
	 	s name=$o(PLIST(name))
	 	q:name=""
	 	s allName=$p(name,packageName_".",2)
	 	continue:((className'="")&&($zcvt(allName,"U") '[ className))
	 	q:count>10
	 	s count=count+1
	 	s ^CacheTemp(repid,ind)=$lb(count,allName)
	 	s ind=ind+1
 	}
 	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-10-12
/// Desc      : 保存数据源
/// Other     : do ##class(web.DHCWL.V1.StandCfg.DSCfg).AddDataSource()
ClassMethod AddDataSource(dsDesc, packageName, tableName)
{
	if (dsDesc="")||(packageName="")||(tableName=""){
		w "{success:true,tip:'填写信息都不能为空'}"
		q	
	}
	s sc=##class(DHCWL.MeasureDimroleData.DataSourceManager).AddDSource(dsDesc,packageName,tableName)
	q:sc="ok" "保存成功"
	q sc
}

/// Creator   : wk
/// CreatDate : 2018-10-12
/// Desc      : 更新数据源‘
/// Other     : do ##Class(web.DHCWL.V1.StandCfg.DSCfg).UpdateDS()
ClassMethod UpdateDS(ID, desc)
{
	if (ID="")||(desc=""){
		q "修改信息不能为空"
	}
	&sql(UPDATE DHCWL_MeasureDimrole.DSource SET Ds_Desc =:desc WHERE ID = :ID )
	if (SQLCODE'=0){
		q "更新失败"_SQLCODE
	}
	q "更新成功"
}

/// Creator    : wk
/// CreatDate  : 2018-10-12
/// Desc       : 获取已维护的统计项
/// Other      : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.StandCfg.DSCfg","GetDSItem","")
Query GetDSItem(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,name:%String:名称,desc:%String:描述,type:%String:类型,dsDesc:%String:数据源描述,exeCode:%String:执行代码") [ SqlProc ]
{
}

ClassMethod GetDSItemExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	s sql="SELECT ID,DsItem_Name,DsItem_Desc,DsItem_ItemType,DsItem_ItemDSDr,DsItem_ExpValue FROM DHCWL_MeasureDimrole.DSItem WHERE DsItem_VoidFlag IS NULL order by DsItem_ItemDSDr"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s name=rs.Data("DsItem_Name")
		s desc=rs.Data("DsItem_Desc")
		s type=rs.Data("DsItem_ItemType")
		s dsID=rs.Data("DsItem_ItemDSDr")
		s dsDesc=$lg(^DHCWL.MeasureDimrole.DSourceD(dsID),4)
		s exeCode=rs.Data("DsItem_ExpValue")
		continue:((filterValue'="")&&($zcvt(name,"U") '[ filterValue)&&($zcvt(desc,"U") '[ filterValue)&&($zcvt(type,"U") '[ filterValue)&&($zcvt(dsDesc,"U") '[ filterValue)&&($zcvt(exeCode,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(ID,name,desc,type,dsDesc,exeCode)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator     : wk
/// CreatDate   : 2018-10-15
/// Desc        : 获取数据源列表
/// Other       : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.StandCfg.DSCfg","GetDSList","")
Query GetDSList(filterValue As %String = "") As websys.Query(ROWSPEC = "dsID:%String:ID,dsDesc:%String:数据源描述") [ SqlProc ]
{
}

ClassMethod GetDSListExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s sql="SELECT ID,Ds_Desc FROM DHCWL_MeasureDimrole.DSource WHERE Ds_VoidFlag IS NULL"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s desc=rs.Data("Ds_Desc")
		s ^CacheTemp(repid,ind)=$lb(ID,desc)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-10-15
/// Desc       : 获取数据源字段
/// Other      : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.StandCfg.DSCfg","GetDSProperty","")
Query GetDSProperty(dsID As %String) As websys.Query(ROWSPEC = "fieldName:%String,type:%String") [ SqlProc ]
{
}

ClassMethod GetDSPropertyExecute(ByRef qHandle As %Binary, dsID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:dsID="" $$$OK	
	s voidFlag=$lg(^DHCWL.MeasureDimrole.DSourceD(dsID),5)
	q:voidFlag="1" $$$OK
	s packageName=$lg(^DHCWL.MeasureDimrole.DSourceD(dsID),2)
	s className=$lg(^DHCWL.MeasureDimrole.DSourceD(dsID),3)
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
		}
		continue:flag=1
		s:($p(propertyType,".",1)="Library") propertyType=$p(propertyType,".",2)
		Set ^CacheTemp(repid,ind)=$lb(propertyField,propertyType)
 		Set ind=ind+1
	}
	Quit $$$OK
}

///  Creator   : wk
///  CreatDate : 2018-10-15
///  Desc      : 新增统计项
///  Other     : do ##class(web.DHCWL.V1.StandCfg.DSCfg).AddDSItem()
ClassMethod AddDSItem(names, descs, types, exes, dsID)
{
	s strItemName=names
	s strItemDesc=descs
	s strItemType=types
	s strItemDataType=""
	s strValue=exes
	s dsID=dsID
	if (strItemName="")||(strItemDesc="")||(strItemType="")||(dsID=""){
		q "请确认信息填写完整之后再进行操作"
	}
	s sc=##class(DHCWL.MeasureDimroleData.DataSourceManager).AddDSourceItem(strItemName,strItemDesc,strItemType,strItemDataType,strValue,dsID)
	q sc
}

/// Creator   : wk
/// CreatDate : 2018-10-16
/// Desc      : 修改统计项
/// Other     : do ##class(web.DHCWL.V1.StandCfg.DSCfg).ModifyDSItem()
ClassMethod ModifyDSItem(ID, desc)
{
	q:(ID="")||(desc="") "信息获取失败"
	s sc=##class(DHCWL.MeasureDimroleData.DataSourceManager).ModifyDSItem(ID,desc)
	q:sc="ok" "修改成功"
	q sc
}

/// Creator   : wk
/// CreatDate : 2018-10-16
/// Desc      : 删除统计项
/// Other     : do ##class(web.DHCWL.V1.StandCfg.DSCfg).DeleteDSItem()
ClassMethod DeleteDSItem(ID)
{
	q:'$d(^DHCWL.MeasureDimrole.DSItemD(ID)) "删除的条目不存在"
	&sql(delete from DHCWL_MeasureDimrole.DSItem where ID=:ID)
	if (SQLCODE'=0){
		q "删除失败"_SQLCODE
	}
	q "删除成功"
}

}
