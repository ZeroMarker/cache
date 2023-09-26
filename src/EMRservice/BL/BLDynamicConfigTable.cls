Class EMRservice.BL.BLDynamicConfigTable Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Description:   根据类名得到类的属性,类名对大小写敏感
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称|类型|数据库字段名|是否必须|描述,
/// test: w ##class(EMRservice.BL.BLDynamicConfigTable).GetClassProperties("EPRmeta.SysOption")    
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
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔 &&
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord("EMRmeta_FrequentText.Chapter", "CTLocID=251@@Name=主诉@@Sequence=1")    
ClassMethod AddRecord(ClassName As %String, Properties As %String) As %String
{
	s split = "@@"
	s cmdCreateCls="objCompRegistered=##class("_ClassName_").%New()"
    s @cmdCreateCls

	s count=$Length(Properties, split)
	f i=1:1:count 
	{
		s keyValue = $Piece(Properties, split, i)
		s property = $Piece(keyValue, "=", 1)
		//s value    = $Piece(keyValue, "&&", 2)
		s value    =$E(keyValue,$f(keyValue,"="),$l(keyValue))
		
        continue:(property = "ID")
       	
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
/// Input：        ClassName：类名 ID:主键 Properties: 属性=Value, 逗号分隔d ##class(EMRservice.BL.BLDynamicConfigTable).UpdateRecord("EMRmeta.DynamicConfigTable", "7", "@ClassName=EMRmeta.FrequentText.Chapter@@ConfigName=常用文本_章节@@Fields=CTLocID,Name,Sequence@@IniValue=@@TableName=EMRmeta_FrequentText.Chapter")
/// Output：       
/// Return：        
/// test:   d ##Class(EMRservice.BL.BLDynamicConfigTable).UpdateRecord("EMRmeta.OPHisTools", "88", "Background=#7B8AEB@@ColSpan=1@@Link=@@Name=infectionRpt@@Position=16@@Text=传染病上报@@Visible=Y")
ClassMethod UpdateRecord(ClassName As %String, ID As %String, Properties As %String)
{
  
	s split = "@@"
	s cmdCreateCls="objCompRegistered=##class("_ClassName_").%OpenId("""_ID_""")"
    s @cmdCreateCls
	
	s count=$Length(Properties, split)
	w count,!
	f i=1:1:count 
	{
		s keyValue = $Piece(Properties, split, i)
		s property = $Piece(keyValue, "=", 1)
		//s value    = $Piece(keyValue, "&&", 2)	
		s value    =$E(keyValue,$f(keyValue,"="),$l(keyValue))
		
		s cmdLetValue="objCompRegistered."_property_"="""_value_""""
		b
		s @cmdLetValue	     
	}
	s cmdSave="objCompRegistered.%Save()"
	d @cmdSave	
	s cmdClose="objCompRegistered.%Close()"
	d @cmdClose
}

/// Description:   删除指定记录
/// Input：        ClassName：类名 ID:主键         
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).DelRecord("EPRmeta.SysOption", "70")
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
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).GetDBConfigProperties("EPRmeta.SysOption")    
ClassMethod GetDBConfigProperties(ClassName As %String) As %String
{
	q:ClassName="" ""
	
	s Id=""
	s Id=$o(^DHCEMRM.DynamicConfigTableI("Idx"," "_$ZCVT(ClassName, "U"), Id))

    q:Id="" ""
    s objEntry = ##Class(EMRmeta.DynamicConfigTable).%OpenId(Id)
    q:objEntry="" ""
    q objEntry.Fields
}

/// Description:   删除配置表记录
/// Table：        
/// Input：        ID：RowId
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).DelDBConfigRecord("EPRmeta.SysOption") 
ClassMethod DelDBConfigRecord(ClassName As %String) As %String
{
	q:ID=""
	&sql(delete from EMRmeta.DynamicConfigTable where ClassName = :ClassName)
	q SQLCODE
}

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   更新配置表记录,不存在则新增记录
/// Table：        
/// Input：        ClassName：表名  Properties：勾选的属性
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).UpdateDBConfigRecord("EPRmeta.SysOption", "Description") 
ClassMethod UpdateDBConfigRecord(TableName As %String, ClassName As %String, ConfigName As %String, Properties As %String, IniValue As %String)
{
	q:TableName=""

	s Id=""
	s Id=$o(^DHCEMRM.DynamicConfigTableI("Idx"," "_$ZCVT(TableName, "U")," "_$ZCVT(ConfigName, "U"), Id))   
	
	if (Id="")
	{
		s obj = ##Class(EMRmeta.DynamicConfigTable).%New()
		s obj.ClassName=ClassName
		s obj.TableName=TableName
		s obj.ConfigName=ConfigName
		s obj.Fields=Properties
		s obj.IniValue=IniValue
	}
	else
	{
		s obj = ##Class(EMRmeta.DynamicConfigTable).%OpenId(Id)
		s obj.Fields=Properties
		s obj.IniValue=IniValue
	}
	
	d obj.%Save()
	//s ^CacheTemp("Fields")=obj.Fields
	d obj.%Close()
}

/// Description:   查询
/// Return：       
/// w ##class(EMRservice.BL.BLDynamicConfigTable).QueryDynTable("EMRmeta.SysOption","ID,Code,Type,TypeParams","","0","300") 
ClassMethod QueryDynTable(TableName As %String, Fields As %String, Filter As %String, StartIndex As %String, PagingSize As %String) As %XML.DataSet
{
	s EndIndex = + StartIndex + PagingSize
	s sql = "SELECT "_Fields_" FROM "_TableName_" WHERE ID > "_StartIndex_" AND ID <= "_EndIndex
    if (Filter'="") && ($C(0)'=Filter)
    {
	    s sql = sql_Filter
	} 
    s sql = sql_" ORDER BY ID"
	s ^CacheTemp("sql")=sql	 
 	s dataset = ##Class(%XML.DataSet).%New("%DynamicQuery:SQL")
	s status=dataset.Prepare(sql)
 
	if $$$ISERR(status) { q "" }
    q dataset
}

/// Description:   查询所有的数据
/// test: w ##class(EMRservice.BL.BLDynamicConfigTable).GetConfigMetaTable()
ClassMethod GetConfigMetaTable() As %XML.DataSet
{
 	s dataset = ##Class(%XML.DataSet).%New("%DynamicQuery:SQL")
	s sql = "SELECT ID,ClassName,TableName,ConfigName,Fields,IniValue FROM EMRmeta.DynamicConfigTable ORDER BY ID"
	s status=dataset.Prepare(sql)
	if $$$ISERR(status) { q "" }
    q dataset
}

ClassMethod FilterIlleaglChar(txt As %String) As %String
{
	s txt = $tr(txt,$c(10),"")
	s txt = $tr(txt,$c(13),"")
	s txt = $tr(txt,"""","\""")
	q txt
}

}
