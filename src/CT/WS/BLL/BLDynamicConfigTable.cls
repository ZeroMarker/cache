/// CT.WS.BLL.BLDynamicConfigTable
/// 描述:配置表维护bl层
/// 编写者:yejian
/// 编写日期:2013-4-23
Class CT.WS.BLL.BLDynamicConfigTable Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   根据类名得到类的属性,类名对大小写敏感
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称|类型|数据库字段名|是否必须|描述,
/// test: d ##class(CT.WS.BLL.BLDynamicConfigTable).GetClassProperties("CT.WS.CustomDictionary","@@")    
ClassMethod GetClassProperties(ClassName As %String, Spliter As %String) As %String [ WebMethod ]
{
		s result = ""
		s ClassName=$REPLACE(ClassName,"_",".")
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

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   创建一个新对象，并将属性设置上
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔
/// Output：       
/// Return：        
/// test: d ##class(CT.WS.BLL.BLDynamicConfigTable).AddRecord("CT.WS.CustomDictionary", "ID=,CtmDictAlias=1111,CtmDictDesc=1111,EndDate=#*#$2013-05-30,EndTime=@##@00:00,StartDate=txtValueText5,StartTime=@##@")    
ClassMethod AddRecord(ClassName As %String, Properties As %String) As %String [ WebMethod ]
{
	s cmdCreateCls="objCompRegistered=##class("_ClassName_").%New()"
    s @cmdCreateCls

	s count=$Length(Properties, ",")
	f i=2:1:count {
		s keyValue = $Piece(Properties, ",", i)
		s property = $Piece(keyValue, "=", 1)
		s value    = $Piece(keyValue, "=", 2)
		
		if (value["#*#$"){
		if (value'="#*#$"){
			s value= $zdh($p(value,"#*#$",2),3)
		}else{
			s value=""
			}}
		if (value["@##@"){
			if (value'="@##@"){
			s value= $zth($p(value,"@##@",2),2)
		}else{
			s value=""}}
        continue:(property = "ID")
       	
		s cmdLetValue="objCompRegistered."_property_"="""_value_""""
		
		s @cmdLetValue 	     
	}
	s cmdSave="objCompRegistered.%Save()"
	d @cmdSave	
	s cmdID="objCompRegistered.%Id()"
	q @cmdID
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   修改对象
/// Table：        
/// Input：        ClassName：类名 ID:主键 Properties: 属性=Value, 逗号分隔
/// Output：       
/// Return：     
/// test: d ##class(CT.WS.BLL.BLDynamicConfigTable).UpdateRecord("CT.WS.CustomDictionary", "274", "CtmDictAlias=ww,CtmDictName=222222,EndTime=@##@03:00,CtmDictType=1111,EndDate=#*#$2013-05-13,CtmDictDesc=ww,CtmDictCode=ww,StartDate=#*#$2013-05-23,StartTime=@##@")    
ClassMethod UpdateRecord(ClassName As %String, ID As %String, Properties As %String) [ WebMethod ]
{
	s $zt = "OnCreateErrorHandler"
	TSTART
	s cmdCreateCls="objCompRegistered=##class("_ClassName_").%OpenId("""_ID_""")"
    s @cmdCreateCls
	s count=$Length(Properties, ",")
	f i=1:1:count 
	{
		s keyValue = $Piece(Properties, ",", i)
		s property = $Piece(keyValue, "=", 1)
		s value    = $Piece(keyValue, "=", 2)
		if (value["#*#$"){
			s a=$p(value,"#*#$",2)
			if (a="")
			{
				s value=""
			}else
			{
				s value= $zdh($p(value,"#*#$",2),3)
			}
		}
		if (value["@##@"){
			s a=$p(value,"@##@",2)
			if (a=""){
			s value=""	
				}else{
			s value= $zth(a,2)
				}
		}
		s cmdLetValue="objCompRegistered."_property_"="""_value_""""
		s @cmdLetValue	     
	}
	s cmdSave="objCompRegistered.%Save()"
	d @cmdSave	
	s cmdClose="objCompRegistered.%Close()"
	d @cmdClose
	TCOMMIT
OnCreateErrorHandler
	TROLLBACK
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   删除指定记录
/// Table：        
/// Input：        ClassName：类名 ID:主键 
/// Output：       
/// Return：        
/// test: d ##class(CT.WS.BLL.BLDynamicConfigTable).DelRecord("EPRmeta.SysOption", "70")
ClassMethod DelRecord(ClassName As %String, ID As %String) [ WebMethod ]
{
	q:ClassName=""
	q:ID=""         
	s cmdDel="##class("_ClassName_").%DeleteId("_ID_")"
	d @cmdDel
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   取保存在配置表里面的字段名称
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: d ##class(CT.WS.BLL.BLDynamicConfigTable).GetDBConfigProperties("EPRmeta.SysOption")    
ClassMethod GetDBConfigProperties(ClassName As %String) As %String [ WebMethod ]
{
	q:ClassName="" ""
	
	s Id=""
	s Id=$o(^DHCCTWS.DynamicConfigTableI("Idx"," "_$ZCVT(ClassName, "U"), Id))

    q:Id="" ""
    s objEntry = ##Class(CT.WS.DynamicConfigTable).%OpenId(Id)
    q:objEntry="" ""
    q objEntry.Fields
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   取保存在配置表里面的字段名称
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: d ##class(CT.WS.BLL.BLDynamicConfigTable).GetClassFieldJson("EPRmeta.SysOption","")    
ClassMethod GetClassFieldJson(strTableName As %String, strConfigName As %String) As %String [ WebMethod ]
{
	if ((strTableName = "")||(strConfigName = ""))
	{q ""}
	
	s Id=""
	s Id=$o(^DHCCTWS.DynamicConfigTableI("Idx"," "_$ZCVT(strTableName, "U")," "_$ZCVT(strConfigName, "U"), Id))

    q:Id="" ""
    s objEntry = ##Class(CT.WS.DynamicConfigTable).%OpenId(Id)
    q:objEntry="" ""
    q objEntry.Fields_"^^"_objEntry.IniValue
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   取保存在配置表里面的字段名称
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: d ##class(CT.WS.BLL.BLDynamicConfigTable)GetClassFieldbyID("1")    
ClassMethod GetClassFieldbyID(strRowID As %String) As %String [ WebMethod ]
{
	
	if (strRowID = "")
	{q ""}
    s objEntry = ##Class(CT.WS.DynamicConfigTable).%OpenId(strRowID)
    q:objEntry="" ""
    s tableids=""
    s tableids=$o(^CT.WS.DynamicConfE129I("IdxTableName"," "_$ZCVT(objEntry.TableName, "U"),tableids))
	s tableobj=##Class(CT.WS.DynamicConfigDefaultValue).%OpenId(tableids)
    q objEntry.TableName_"^^"_objEntry.ConfigName_"^^"_ objEntry.Fields_"^^"_objEntry.IniValue_"^^"_tableobj.DefaultRow
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   删除配置表记录
/// Table：        
/// Input：        ID：RowId
/// Output：       
/// Return：        
/// test: d ##class(CT.WS.BLL.BLDynamicConfigTable).DelDBConfigRecord("EPRmeta.SysOption") 
ClassMethod DelDBConfigRecord(ClassName As %String) As %String [ WebMethod ]
{
	q:ID=""
	&sql(delete from CT_WS.DynamicConfigTable where TableName = :ClassName)
	q SQLCODE
}

/// Creator：      DUJINRONG
/// CreatDate：    2013-12-30
/// Description:   删除配置表记录
/// Table：        
/// Input：        ID：RowId
/// Output：       
/// Return：        
/// test: d ##class(CT.WS.BLL.BLDynamicConfigTable).DelDBByIDConfigRecord(21) 
ClassMethod DelDBByIDConfigRecord(ID As %Integer) As %String [ WebMethod ]
{
	q:ID=""
	&sql(delete from CT_WS.DynamicConfigTable where ID = :ID)
	q SQLCODE
}

/// Creator：      DUJINRONG
/// CreatDate：    2013-12-30
/// Description:   删除配置表记录
/// Table：        
/// Input：        ID：RowId
/// Output：       
/// Return：        
/// test: d ##class(CT.WS.BLL.BLDynamicConfigTable).DelDBByDVConfigRecord("CT.WS.CustomDictionary","CtmDictType","") 
ClassMethod DelDBByDVConfigRecord(TableName As %String, DefaultRow As %String, DefaultValue As %String) As %String [ WebMethod ]
{
    s cmdDel=""
    s quits=0
    s sql="SELECT ID FROM "_TableName_" WHERE "_DefaultRow_" = '"_DefaultValue_"'"
	Set rset = ##class(%ResultSet).%New()
	d rset.Prepare(sql)
	Do rset.Execute()
	
	While (rset.Next(.sc))
     {
        If ($SYSTEM.Status.IsOK(sc))
            {
				s quits=1
				if (quits=1){
					q
					}
				
            }
            
     }

	q quits
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   更新配置表记录,不存在则新增记录
/// Table：        
/// Input：        ClassName：表名  Properties：勾选的属性
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: d ##class(CT.WS.BLL.BLDynamicConfigTable).UpdateDBConfigRecord("EPRmeta.SysOption", "Description") 
ClassMethod UpdateDBConfigRecord(TableName As %String, ConfigName As %String, Properties As %String, IniValue As %String) [ WebMethod ]
{

	s Id=""
	s Id=$o(^DHCCTWS.DynamicConfigTableI("Idx"," "_$ZCVT(TableName, "U")," "_$ZCVT(ConfigName, "U"), Id))   
	
	if (Id="")
	{
		s obj = ##Class(CT.WS.DynamicConfigTable).%New()
		s obj.TableName=TableName
		s obj.ConfigName=ConfigName
		s obj.Fields=Properties
		s obj.IniValue=IniValue
	}
	else
	{
		s obj = ##Class(CT.WS.DynamicConfigTable).%OpenId(Id)
		s obj.Fields=Properties
		s obj.IniValue=IniValue
	}
	
	d obj.%Save()
	d obj.%Close()
}

/// 返回查询，将所有字段合并成一个字段，以Spliter分割
/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   查询
/// Table：        
/// Input：        TableName:传入所要查询的表名
///                Fields: 查询的字段，格式 Col1||Spliter||Col2 ... 
/// Output：       CT.WS.dataset.QueryDynTableDataSet
/// Return：       
/// Others：       其它说明
/// d ##class(CT.WS.BLL.BLDynamicConfigTable).QueryDynTable("CT.WS.DynamicConfigTable","ID||','||TableName||','||Fields") 
ClassMethod QueryDynTable(TableName As %String, Fields As %String, Filter As %String, Spliter As %String, StartIndex As %String, PagingSize As %String) As CT.WS.dataset.QueryDynTableDataSet [ WebMethod ]
{
	Set ds=##class(CT.WS.dataset.QueryDynTableDataSet).%New()
	d ds.SetArgs(TableName, Fields, Filter, Spliter, StartIndex, PagingSize)
	Quit ds
}

/// 查询CT.WS.DynamicConfigTable中所有的数据
/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   查询
/// Table：        
/// Input：         
///                 
/// Output：       CT.WS.dataset.DynamicConfigTableDataSet
/// Return：       
/// Others：       其它说明
/// test: d ##class(CT.WS.BLL.BLDynamicConfigTable).GetConfigTable()
ClassMethod GetConfigTable() As CT.WS.dataset.DynamicConfigTableDataSet [ WebMethod ]
{
	Set ds=##class(CT.WS.dataset.DynamicConfigTableDataSet).%New()
	Quit ds
}

}
