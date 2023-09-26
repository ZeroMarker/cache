Class DHCEPRFS.BL.BLConfigMetaTable Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Description:   根据类名得到类的属性,类名对大小写敏感
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称|类型|数据库字段名|是否必须|描述,
/// test: w ##class(DHCEPRFS.BL.BLConfigMetaTable).GetClassProperties("EPRmeta.SysOption")    
ClassMethod GetClassProperties(ClassName As %String) As %String
{
		s result = ""
		s obj=##Class(%Dictionary.CompiledClass).%OpenId(ClassName)
		if obj=""
		{
		    q ""
		}		
		s cnt=obj.Properties.Count()
		f i=1:1:cnt 
		{
			s pdef=obj.Properties.GetAt(i) 
		    s PropertyName=pdef.Name
		    s item = ""
		    i (PropertyName'="%Concurrency") && (PropertyName'="%IsInSave") && (pdef.Private'=1)		
		    {
		        s isRequired = "否"
		        if (pdef.Required = 1) 
		        {
			        s isRequired = "是"
			    }
		        //s item = pdef.Name_Spliter_pdef.Type_Spliter_pdef.SqlFieldName_Spliter_isRequired_Spliter_Spliter_pdef.Description	 
	            s item = "{""name"":"""_..FilterIlleaglChar(pdef.Name)_""",""pType"":"""_pdef.Type_""",""SqlFieldName"":"""_pdef.SqlFieldName_""",""isRequired"":"""_isRequired_""",""defaultValue"":"""",""desc"":"""_..FilterIlleaglChar(pdef.Description)_"""}"
	            if (result '= "")
	            {
		           s result = result_","_item
	            }
	            else 
	            {
	               s result = item 
	            }
		    }
		}

		s result = "{""TableName"":"""_obj.SqlSchemaName_"."_obj.SqlTableName_""",""Properties"":["_result_"]}"
        d obj.%Close()
		q result
}

/// Description:   创建一个新对象，并将属性设置上
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔
/// Output：       
/// Return：        
/// test: d ##class(DHCEPRFS.BL.BLConfigMetaTable).AddRecord("EPRmeta.SysOption", "Description=testDescription,OptionValue=testOptionValue")    
ClassMethod AddRecord(ClassName As %String, Properties As %String) As %String
{
	s cmdCreateCls="objCompRegistered=##class("_ClassName_").%New()"
    s @cmdCreateCls

	s count=$Length(Properties, ",")
	f i=1:1:count 
	{
		s keyValue = $Piece(Properties, ",", i)
		s property = $Piece(keyValue, "=", 1)
		s value    = $Piece(keyValue, "=", 2)
		
        continue:(property = "ID")
        //对日期、时间类型的字段进行格式转换
        s type = ##class(DHCEPRFS.BL.BLMetaLifeCycle).GetPropertyType(ClassName,property)
        if ((type = "%Library.Date") && (value '= ""))
        {
	        s value = $zdh(value,3)
        }
        elseif ((type = "%Library.Time") && (value '= ""))
        {
	        s value = $zth(value)
        }
       	
		s cmdLetValue="objCompRegistered."_property_"="""_value_""""
		s @cmdLetValue 	     
	}
	s cmdSave="objCompRegistered.%Save()"
	d @cmdSave	
	s cmdID="objCompRegistered.%Id()"
	q @cmdID
	//s cmdClose="objCompRegistered.%Close()"
	//d @cmdClose
	//q ID
}

/// Description:   修改对象
/// Table：        
/// Input：        ClassName：类名 ID:主键 Properties: 属性=Value, 逗号分隔
/// Output：       
/// Return：        
/// test: d ##class(DHCEPRFS.BL.BLConfigMetaTable).UpdateRecord("EPRmeta.SysOption", "70", "Description=Description1,OptionValue=OptionValue1")    
ClassMethod UpdateRecord(ClassName As %String, ID As %String, Properties As %String)
{
	s cmdCreateCls="objCompRegistered=##class("_ClassName_").%OpenId("""_ID_""")"
    s @cmdCreateCls

	s count=$Length(Properties, ",")
	f i=1:1:count 
	{
		s keyValue = $Piece(Properties, ",", i)
		s property = $Piece(keyValue, "=", 1)
		s value    = $Piece(keyValue, "=", 2)
		s cmdLetValue="objCompRegistered."_property_"="""_value_""""
		s @cmdLetValue	     
	}
	s cmdSave="objCompRegistered.%Save()"
	d @cmdSave	
	s cmdClose="objCompRegistered.%Close()"
	d @cmdClose
}

/// Description:   删除指定记录
/// Input：        ClassName：类名 ID:主键         
/// test: d ##class(DHCEPRFS.BL.BLConfigMetaTable).DelRecord("EPRmeta.SysOption", "70")
ClassMethod DelRecord(ClassName As %String, ID As %String)
{
	q:ClassName=""
	q:ID=""         
	s cmdDel="##class("_ClassName_").%DeleteId("_ID_")"
	d @cmdDel
	
	///w $ZOBJCLASSMETHOD(ClassName,"%DeleteId",ID)
}

/// Description:   取保存在配置表里面的字段名称
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: d ##class(DHCEPRFS.BL.BLConfigMetaTable).GetDBConfigProperties("EPRmeta.SysOption")    
ClassMethod GetDBConfigProperties(ClassName As %String) As %String
{
	q:ClassName="" ""
	
	s Id=""
	s Id=$o(^DHCEPRFS.META.ConfigMetaTableI("Idx"," "_$ZCVT(ClassName, "U"), Id))

    q:Id="" ""
    s objEntry = ##Class(DHCEPRFS.META.ConfigMetaTable).%OpenId(Id)
    q:objEntry="" ""
    q objEntry.Fields
}

/// Description:   删除配置表记录
/// Table：        
/// Input：        ID：RowId
/// Output：       
/// Return：        
/// test: d ##class(DHCEPRFS.BL.BLConfigMetaTable).DelDBConfigRecord("EPRmeta.SysOption") 
ClassMethod DelDBConfigRecord(ClassName As %String) As %String
{
	q:ID=""
	&sql(delete from DHCEPRFS_META.ConfigMetaTable where ClassName = :ClassName)
	q SQLCODE
}

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   更新配置表记录,不存在则新增记录
/// Table：        
/// Input：        ClassName：表名  Properties：勾选的属性
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: d ##class(DHCEPRFS.BL.BLConfigMetaTable).UpdateDBConfigRecord("EPRmeta.SysOption", "Description") 
ClassMethod UpdateDBConfigRecord(TableName As %String, ClassName As %String, ConfigName As %String, Properties As %String, IniValue As %String)
{
	q:TableName=""

	s Id=""
	s Id=$o(^DHCEPRFS.META.ConfigMetaTableI("Idx"," "_$ZCVT(TableName, "U")," "_$ZCVT(ConfigName, "U"), Id))   
	
	if (Id="")
	{
		s obj = ##Class(DHCEPRFS.META.ConfigMetaTable).%New()
		s obj.ClassName=ClassName
		s obj.TableName=TableName
		s obj.ConfigName=ConfigName
		s obj.Fields=Properties
		s obj.IniValue=IniValue
	}
	else
	{
		s obj = ##Class(DHCEPRFS.META.ConfigMetaTable).%OpenId(Id)
		s obj.Fields=Properties
		s obj.IniValue=IniValue
	}
	
	d obj.%Save()
	//s ^CacheTemp("Fields")=obj.Fields
	d obj.%Close()
}

/// Description:   查询
/// Return：       
/// w ##class(DHCEPRFS.BL.BLConfigMetaTable).QueryDynTable("DHCEPRFS_META.MRItem","ID,Code,Type,TypeParams","","0","300") 
ClassMethod QueryDynTable(TableName As %String, Fields As %String, Filter As %String, StartIndex As %String, PagingSize As %String) As %XML.DataSet
{
	s EndIndex = + StartIndex + PagingSize
	s sql = "SELECT "_Fields_" FROM "_TableName_" WHERE ID > "_StartIndex_" AND ID <= "_EndIndex
    if (Filter'="") && ($C(0)'=Filter)
    {
	    s sql = sql_Filter
	} 
    s sql = sql_" ORDER BY ID"
	 
 	s dataset = ##Class(%XML.DataSet).%New("%DynamicQuery:SQL")
	s status=dataset.Prepare(sql)
 
	if $$$ISERR(status) { q "" }
    q dataset
}

/// Description:   查询所有的数据
/// test: w ##class(DHCEPRFS.BL.BLConfigMetaTable).GetConfigMetaTable()
ClassMethod GetConfigMetaTable() As %XML.DataSet
{
 	s dataset = ##Class(%XML.DataSet).%New("%DynamicQuery:SQL")
	s sql = "SELECT ID,ClassName,TableName,ConfigName,Fields,IniValue FROM DHCEPRFS_META.ConfigMetaTable ORDER BY ID"
	s status=dataset.Prepare(sql)
	if $$$ISERR(status) { q "" }
    q dataset
}

//do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLConfigMetaTable","GetConfigMetaTableGB")

Query GetConfigMetaTableGB() As %Query(ROWSPEC = "ID:%String,ClassName:%String,TableName:%String,ConfigName:%String,Fields:%String,IniValue:%String")
{
}

ClassMethod GetConfigMetaTableGBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConfigMetaTableGBExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetConfigMetaTableGBExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
	s ConfigMetaTableID=""
	for {
		s ConfigMetaTableID=$o(^DHCEPRFS.META.ConfigMetaTableD(ConfigMetaTableID))
		q:(ConfigMetaTableID="")
		
		s obj=##class(DHCEPRFS.META.ConfigMetaTable).%OpenId(ConfigMetaTableID)
		s ^CacheTemp(repid,ind) = $lb(obj.%Id(),obj.ClassName,obj.TableName,obj.ConfigName,obj.Fields,obj.IniValue)
		s ind = ind + 1
	}
	q $$$OK
}

ClassMethod GetConfigMetaTableGBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConfigMetaTableGBExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod FilterIlleaglChar(txt As %String) As %String
{
	s txt = $tr(txt,$c(10),"")
	s txt = $tr(txt,$c(13),"")
	s txt = $tr(txt,"""","\""")
	q txt
}

}
