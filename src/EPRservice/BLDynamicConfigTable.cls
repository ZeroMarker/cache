Class EPRservice.BLDynamicConfigTable Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   根据类名得到类的属性,类名对大小写敏感
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称|类型|数据库字段名|是否必须|描述,
/// test: d ##class(EPRservice.BLDynamicConfigTable).GetClassProperties("EPRmeta.SysOption")    
ClassMethod GetClassProperties(ClassName As %String, Spliter As %String) As %String
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
		    i (PropertyName'="%Concurrency" & PropertyName'="%IsInSave" & pdef.Private'=1)		
		    {
		        s isRequired = "否"
		        if (pdef.Required = 1) 
		        {
			        s isRequired = "是"
			    }
		        s item = pdef.Name_Spliter_pdef.Type_Spliter_pdef.SqlFieldName_Spliter_isRequired_Spliter_Spliter_pdef.Description	 
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
        d obj.%Close()
		q result
}

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   创建一个新对象，并将属性设置上
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔
/// Output：       
/// Return：        
/// test: d ##class(EPRservice.BLDynamicConfigTable).AddRecord("EPRmeta.SysOption", "Description=testDescription,OptionValue=testOptionValue")    
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

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   修改对象
/// Table：        
/// Input：        ClassName：类名 ID:主键 Properties: 属性=Value, 逗号分隔
/// Output：       
/// Return：        
/// test: d ##class(EPRservice.BLDynamicConfigTable).UpdateRecord("EPRmeta.SysOption", "70", "Description=Description1,OptionValue=OptionValue1")    
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

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   删除指定记录
/// Table：        
/// Input：        ClassName：类名 ID:主键 
/// Output：       
/// Return：        
/// test: d ##class(EPRservice.BLDynamicConfigTable).DelRecord("EPRmeta.SysOption", "70")
ClassMethod DelRecord(ClassName As %String, ID As %String)
{
	q:ClassName=""
	q:ID=""         
	s cmdDel="##class("_ClassName_").%DeleteId("_ID_")"
	d @cmdDel
	
	///w $ZOBJCLASSMETHOD(ClassName,"%DeleteId",ID)
}

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   取保存在配置表里面的字段名称
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: d ##class(EPRservice.BLDynamicConfigTable).GetDBConfigProperties("EPRmeta.SysOption")    
ClassMethod GetDBConfigProperties(ClassName As %String) As %String
{
	q:ClassName="" ""
	
	s Id=""
	s Id=$o(^DHCEPRM.DynamicConfigTableI("Idx"," "_$ZCVT(ClassName, "U"), Id))

    q:Id="" ""
    s objEntry = ##Class(EPRmeta.DynamicConfigTable).%OpenId(Id)
    q:objEntry="" ""
    q objEntry.Fields
}

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   删除配置表记录
/// Table：        
/// Input：        ID：RowId
/// Output：       
/// Return：        
/// test: d ##class(EPRservice.BLDynamicConfigTable).DelDBConfigRecord("EPRmeta.SysOption") 
ClassMethod DelDBConfigRecord(ClassName As %String) As %String
{
	q:ID=""
	&sql(delete from EPRMeta.DynamicConfigTable where TableName = :ClassName)
	q SQLCODE
}

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   更新配置表记录,不存在则新增记录
/// Table：        
/// Input：        ClassName：表名  Properties：勾选的属性
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: d ##class(EPRservice.BLDynamicConfigTable).UpdateDBConfigRecord("EPRmeta.SysOption", "Description") 
ClassMethod UpdateDBConfigRecord(TableName As %String, ConfigName As %String, Properties As %String, IniValue As %String)
{
	q:TableName=""

	s Id=""
	s Id=$o(^DHCEPRM.DynamicConfigTableI("Idx"," "_$ZCVT(TableName, "U")," "_$ZCVT(ConfigName, "U"), Id))   
	
	if (Id="")
	{
		s obj = ##Class(EPRmeta.DynamicConfigTable).%New()
		s obj.TableName=TableName
		s obj.ConfigName=ConfigName
		s obj.Fields=Properties
		s obj.IniValue=IniValue
	}
	else
	{
		s obj = ##Class(EPRmeta.DynamicConfigTable).%OpenId(Id)
		s obj.Fields=Properties
		s obj.IniValue=IniValue
	}
	
	d obj.%Save()
	//s ^CacheTemp("Fields")=obj.Fields
	d obj.%Close()
}

/// 返回查询，将所有字段合并成一个字段，以Spliter分割
/// Creator：      LingChen
/// CreatDate：    2011-01-26
/// Description:   查询
/// Table：        
/// Input：        TableName:传入所要查询的表名
///                Fields: 查询的字段，格式 Col1||Spliter||Col2 ... 
/// Output：       EPRservice.dataset.QueryDynTableDataSet
/// Return：       
/// Others：       其它说明
/// d ##class(EPRservice.BLDynamicConfigTable).QueryDynTable("EPRmeta.DynamicConfigTable","ID||','||TableName||','||Fields") 
ClassMethod QueryDynTable(TableName As %String, Fields As %String, Filter As %String, Spliter As %String, StartIndex As %String, PagingSize As %String) As EPRservice.dataset.QueryDynTableDataSet
{
	Set ds=##class(EPRservice.dataset.QueryDynTableDataSet).%New()
	d ds.SetArgs(TableName, Fields, Filter, Spliter, StartIndex, PagingSize)
	//s ^CacheTemp("aaa")=TableName_"^"_Fields_"^"_Filter_"^"_Spliter_"^"_StartIndex_"^"_PagingSize
	Quit ds
}

/// 查询EPRmeta.DynamicConfigTable中所有的数据
/// Creator：      LingChen
/// CreatDate：    2011-01-26
/// Description:   查询
/// Table：        
/// Input：         
///                 
/// Output：       EPRservice.dataset.DynamicConfigTableDataSet
/// Return：       
/// Others：       其它说明
/// test: d ##class(EPRservice.BLDynamicConfigTable).GetConfigTable()
ClassMethod GetConfigTable() As EPRservice.dataset.DynamicConfigTableDataSet
{
	Set ds=##class(EPRservice.dataset.DynamicConfigTableDataSet).%New()
	Quit ds
}

}
