/// CT.WS.BO.BODynamicConfigTable
/// 描述:配置表维护BO层
/// 编写者:yejian
/// 编写日期:2013-4-23
Class CT.WS.BO.BODynamicConfigTable Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "DynamicConfigTable";

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   根据类名得到类的属性,类名对大小写敏感
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称|类型|数据库字段名|是否必须|描述,
/// test: d ##class(CT.WS.BO.BODynamicConfigTable).GetClassProperties("CT.WS.SysOption")    
ClassMethod GetClassProperties(ClassName As %String, Spliter As %String) As %String [ WebMethod ]
{
	q ##class(CT.WS.BLL.BLDynamicConfigTable).GetClassProperties(ClassName, Spliter)
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   创建一个新对象，并将属性设置上
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔
/// Output：       
/// Return：        
/// test: d ##class(CT.WS.BO.BODynamicConfigTable).AddRecord("EPRmeta.SysOption", "Description=Description,OptionValue=OptionValue")    
ClassMethod AddRecord(ClassName As %String, Properties As %String) As %String [ WebMethod ]
{
	q ##class(CT.WS.BLL.BLDynamicConfigTable).AddRecord(ClassName, Properties)
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   修改对象
/// Table：        
/// Input：        ClassName：类名 ID:主键 Properties: 属性=Value, 逗号分隔
/// Output：       
/// Return：        
/// test: d ##class(CT.WS.BO.BODynamicConfigTable).UpdateRecord("EPRmeta.SysOption", "61", "Description=Description1,OptionValue=OptionValue1")    
ClassMethod UpdateRecord(ClassName As %String, ID As %String, Properties As %String) [ WebMethod ]
{
	d ##class(CT.WS.BLL.BLDynamicConfigTable).UpdateRecord(ClassName, ID, Properties)
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   修改对象
/// Table：        
/// Input：        ClassName：类名 ID:主键 Properties: 属性=Value, 逗号分隔
/// Output：       
/// Return：          
ClassMethod DelRecord(ClassName As %String, ID As %String) [ WebMethod ]
{
	d ##class(CT.WS.BLL.BLDynamicConfigTable).DelRecord(ClassName, ID)
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   取保存在配置表里面的字段名称
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: d ##class(CT.WS.BO.BODynamicConfigTable).GetDBConfigProperties("EPRmeta.SysOption")    
ClassMethod GetDBConfigProperties(ClassName As %String) As %String [ WebMethod ]
{
	q ##class(CT.WS.BLL.BLDynamicConfigTable).GetDBConfigProperties(ClassName)
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   删除配置表记录
/// Table：        
/// Input：        ID：RowId
/// Output：       
/// Return：        
/// test: d ##class(CT.WS.BO.BODynamicConfigTable).DelDBConfigRecord("EPRmeta.SysOption") 
ClassMethod DelDBConfigRecord(ClassName As %String) As %String [ WebMethod ]
{
	q ##class(CT.WS.BLL.BLDynamicConfigTable).DelDBConfigRecord(ClassName)
}

/// Creator：      dujinrong
/// CreatDate：    2013-12-30
/// Description:   删除配置表记录
/// Table：        
/// Input：        ID：RowId
/// Output：       
/// Return：        
/// test: d ##class(CT.WS.BO.BODynamicConfigTable).DelDBByIDConfigRecord("21") 
ClassMethod DelDBByIDConfigRecord(ID As %String) As %String [ WebMethod ]
{
	q ##class(CT.WS.BLL.BLDynamicConfigTable).DelDBByIDConfigRecord(ID)
}

/// Creator：      dujinrong
/// CreatDate：    2013-12-30
/// Description:   更新配置表记录
/// Table：        
/// Input：        ClassName：表名  Properties：勾选的属性
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: d ##class(CT.WS.BO.BODynamicConfigTable).DelDBByDVConfigRecord("EPRmeta.SysOption", "Description") 
ClassMethod DelDBByDVConfigRecord(TableName As %String, DefaultRow As %String, DefaultValue As %String) [ WebMethod ]
{
	q ##class(CT.WS.BLL.BLDynamicConfigTable).DelDBByDVConfigRecord(TableName, DefaultRow, DefaultValue)
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   更新配置表记录
/// Table：        
/// Input：        ClassName：表名  Properties：勾选的属性
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: d ##class(CT.WS.BO.BODynamicConfigTable).UpdateDBConfigRecord("EPRmeta.SysOption", "Description") 
ClassMethod UpdateDBConfigRecord(TableName As %String, ConfigName As %String, Properties As %String, IniValue As %String) [ WebMethod ]
{
	d ##class(CT.WS.BLL.BLDynamicConfigTable).UpdateDBConfigRecord(TableName, ConfigName, Properties, IniValue)
}

/// 返回查询，将所有字段合并成一个字段 
/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   查询     
/// Input：        TableName:传入所要查询的表名
///                Fields: 查询的字段，格式 Col1||分割符||Col2 ... 
/// Output：       EPRservice.dataset.QueryDynTableDataSet
/// Return：       
/// Others：       其它说明
ClassMethod QueryDynTable(TableName As %String, Fields As %String, Filter As %String, Spliter As %String, StartIndex As %String, PagingSize As %String) As EPRservice.dataset.QueryDynTableDataSet [ WebMethod ]
{
	q ##class(CT.WS.BLL.BLDynamicConfigTable).QueryDynTable(TableName, Fields, Filter, Spliter, StartIndex, PagingSize)
}

/// 查询CT.WS.DynamicConfigTable中所有的数据
/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   查询
/// Output：       CT.WS.dataset.DynamicConfigTableDataSet
/// Return：       
/// test: d ##class(CT.WS.BO.BODynamicConfigTable).GetConfigTable() 
ClassMethod GetConfigTable() As %String [ WebMethod ]
{
	Quit ##class(CT.WS.BLL.BLDynamicConfigTable).GetConfigTable()
}

/// 查询表名，配置代码表名下拉数据
/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   查询
/// Output：       CT.WS.dataset.DynamicConfigTableDataSet
/// Return：       
/// test: w ##class(CT.WS.BO.BODynamicConfigTable).GetConfigJson("") 
ClassMethod GetConfigJson(strTableName As %String, start As %String, idxLast As %String, quits As %String = "") As %String [ WebMethod ]
{
	s strdata = "datatable"
	if (strTableName'=""&&(strTableName '=$char(0)))
	{
		s strdata = "dataname"
	}
	s TotalRowCount = 0
	s ResulttableName=##Class(%ResultSet).%New("CT.WS.dao.DQueryDynTable:SelectAllbyTableName")
	d ResulttableName.Execute()
	s Result = ##Class(%ResultSet).%New("CT.WS.dao.DQueryDynTable:SelectAll")
	d Result.Execute()
	//构造json数据
	
 	s json = ""

 	if ((strTableName'="")&&(strTableName '=$char(0))){
	
 		while(Result.Next())
 		{
	 		s strTabname = $g(Result.Data("TableName"))
				if ((strTableName'="")&&(strTableName '=$char(0))){
				if (strTableName = strTabname)
				{
					if ((TotalRowCount<=idxLast)&(TotalRowCount>=start))
					{
						s RowNum=TotalRowCount+1
						s json = json_"{ID:'"_$g(Result.Data("ID"))_"',"
						s json = json_"RowNum:'"_RowNum_"',"
						s json = json_"Fields:'"_$g(Result.Data("Fields"))_"',"
						s json = json_"TableName:'"_$g(Result.Data("TableName"))_"',"
						s json = json_"ConfigName:'"_$g(Result.Data("ConfigName"))_"'},"
					}
				S TotalRowCount = TotalRowCount+1
				}
				
			}}
 		}else{
	
	 		while(ResulttableName.Next())
 			{
	 			if ((TotalRowCount<=idxLast)&(TotalRowCount>=start))
				{
					s RowNum=TotalRowCount+1
					s json = json_"{ID:'"_$g(ResulttableName.Data("ID"))_"',"
					s json = json_"RowNum:'"_RowNum_"',"
					s json = json_"TableName:'"_$g(ResulttableName.Data("TableName"))_"'},"
				}
		
	 			S TotalRowCount = TotalRowCount+1
	 		}
	 		
	  }
			
    s json = $e(json, 1, $l(json)-1)
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
    s jsons = "{quits:'"_quits_"',TotalCount:'"_TotalRowCount_"',"_strdata_":["_json_"]}"
    q jsons
}

/// 查询表名，配置代码表名下拉数据
/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   查询
/// Output：       CT.WS.dataset.DynamicConfigTableDataSet
/// Return：       
/// test: w ##class(CT.WS.BO.BODynamicConfigTable).GetAllConfigJson() 
ClassMethod GetAllConfigJson(start As %String, idxLast As %String) As %String [ WebMethod ]
{
	
	s strdata = "ConfigList"
	s inCount=0
	s TotalRowCount = 0
	s Result = ##Class(%ResultSet).%New("CT.WS.dao.DQueryDynTable:SelectAll")
	d Result.Execute()
	//构造json数据
 	s json = "["
 	while(Result.Next())
 	{
	 	if ((inCount<=idxLast)&(inCount>=start))
		{
			s json = json_"{ID:'"_$g(Result.Data("ID"))_"',"
			s json = json_"ConfigName:'"_$g(Result.Data("ConfigName"))_"'},"
			
		}
	S inCount = inCount+1
	}
    s json = $e(json, 1, $l(json)-1)
	s json = json_"]"
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
    s jsons = "{TotalCount:'"_inCount_"',"_strdata_":"_json_"}"
    q jsons
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   根据类名得到类的属性,类名对大小写敏感
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称|类型|数据库字段名|是否必须|描述,
/// test: d ##class(CT.WS.BO.BODynamicConfigTable).GetClassPropertiesJson("CT.WS.CustomDictionary","@@")    
ClassMethod GetClassPropertiesJson(strTableName As %String, Spliter As %String, DefautValue As %String = "") As %String [ WebMethod ]
{
   	s tableNamesID=""
   	s res=""
	s tableNamesID=$o(^CT.WS.DynamicConfE129I("IdxTableName"," "_$ZCVT(strTableName, "U"),tableNamesID))
	s obj=##class(CT.WS.DynamicConfigDefaultValue).%OpenId(tableNamesID)
	s tableNames=""
	if (obj'=""){
	S tableNames=obj.DefaultRow
	}
	
	s sql="select *from "_ strTableName
	Set rset = ##class(%ResultSet).%New()
	s res= rset.Prepare(sql)	
	
   	s inCount = 0
   	//获取最新字典维护数据
	s strData = ##class(CT.WS.BLL.BLDynamicConfigTable).GetClassProperties(strTableName, Spliter)
 	//构造json数据
 	s json = ""
 	s strvs = ""
    s strv = ""
    if (res=1){
 	if ((strData'="")&&(strData'=$char(0)))
 	{
	 	for inti = 1:1: $l(strData,",")
		{
			s strvs = $p(strData,",",inti)
			 
	 		s json = json_"{name:'"_$p(strvs,Spliter,1)_"',"
	 		s json = json_"Type:'"_$p(strvs,Spliter,2)_"',"
	 		s json = json_"DBName:'"_$p(strvs,Spliter,3)_"',"
	 		s json = json_"Require:'"_$p(strvs,Spliter,4)_"',"
	 		s json = json_"IniValue:'"_$p(strvs,Spliter,5)_" ',"
			s json = json_"Desc:'"_$p(strvs,Spliter,6)_" '},"
		s inCount = inCount+1
		}
	}}else{s res=0}
    s json = $e(json, 1, $l(json)-1)
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s jsons ="{defautvalue:'"_DefautValue_"',resultTable:'"_res_"',tableRow:'"_tableNames_"',results:"_inCount_",rows:["_json_"]}"
	q jsons
}

/// Creator：      dujinrong
/// CreatDate：    2013-5-9
/// Description:   根据类名得到类的属性(获取时间型和日期型),类名对大小写敏感
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称|类型|数据库字段名|是否必须|描述,
/// test: d ##class(CT.WS.BO.BODynamicConfigTable).GetClassPropertiesTime("CT.WS.CustomDictionary","@@")    
ClassMethod GetClassPropertiesTime(strTableName As %String, Spliter As %String) As %String [ WebMethod ]
{
   	
   	s inCount = 0
   	//获取最新字典维护数据
	s strData = ##class(CT.WS.BLL.BLDynamicConfigTable).GetClassProperties(strTableName, Spliter)
 	//构造json数据
 	s timestr = ""
 	s datestr=""
 	s strvs = ""
    s strv = ""
 	if ((strData'="")&&(strData'=$char(0)))
 	{
	 	for inti = 1:1: $l(strData,",")
		{
			s strvs = $p(strData,",",inti)
			 if ($p(strvs,Spliter,2)="%Library.Time"){
	 			s datestr =datestr_$p(strvs,Spliter,1)_","
	 	
			}
			
			if ($p(strvs,Spliter,2)="%Library.Date"){
				s timestr = timestr_$p(strvs,Spliter,1)_","
			}
		}
		
	}
	s jsons=timestr_"^^"_datestr
	q jsons
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   通过表名，配置名获取选中的字段
/// Table：        
/// Input：        strTableName：类名，strConfigName：配置名
/// Output：       
/// Return：       属性名称|类型|数据库字段名|是否必须|描述,
/// test: d ##class(CT.WS.BO.BODynamicConfigTable).GetClassFieldJson("CT.WS.CustomDictionary","家庭关系代码")    
ClassMethod GetClassFieldJson(strTableName As %String, strConfigName As %String) As %String [ WebMethod ]
{
   	
   	s strResult = ""
   	//获取最新字典维护数据
	s strResult = ##class(CT.WS.BLL.BLDynamicConfigTable).GetClassFieldJson(strTableName,strConfigName)

 	q strResult
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   取保存在配置表里面的字段名称
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: w ##class(CT.WS.BO.BODynamicConfigTable).GetJsonBySql("CT.WS.CustomDictionary","ID,CtmDictAlias,CtmDictCode,CtmDictComment,CtmDictDesc,CtmDictLink,CtmDictLinkCode,CtmDictOther,CtmDictRef"," ","0","25")
ClassMethod GetJsonBySql(TableName As %String, Fields As %String, Filter As %String, Index As %String, PageSize As %String) As %String [ WebMethod ]
{
	s Filters=$p(Filter,"AND ",2)
	s tableids=""
	s tableids=$o(^CT.WS.DynamicConfE129I("IdxTableName"," "_$ZCVT(TableName, "U"),tableids))
	s tableobj=##Class(CT.WS.DynamicConfigDefaultValue).%OpenId(tableids)
	s dateAndTimeStr= ##class(CT.WS.BO.BODynamicConfigTable).GetClassPropertiesTime(TableName,"@@")
	s datestr=$p(dateAndTimeStr,"^^",1)
	s timestr=$p(dateAndTimeStr,"^^",2)
	s cmdLetValue=""
	s count=$Length(Filter, "AND")
	f i=2:1:count {
		s keyValue = $Piece(Filter, " AND ", i)
		s property = $REPLACE($Piece(keyValue, "=", 1)," ","")
		s value    = $REPLACE($Piece(keyValue, "=", 2)," ","")
		s values=$p(value,"'",2)
		if (dateAndTimeStr[property){
			if (datestr[property){
				s values="'"_$zdh(values,3)_"'"
			}
			if (timestr[property){
				s values="'"_$zth(values,2)_"'"
			}
		}else{
				s values=value
		}
		if (tableobj.DefaultRow=property)
		{
		s cmdLetValue=cmdLetValue_" AND "_property_"="_values
		}	
		
		}
   	q:(TableName="") $$$OK
	q:(Fields="") $$$OK
	s ind=1
	s sql = "SELECT "_Fields_" FROM "_TableName_" WHERE ID >0 "
    if (Filter'="")
    {
	    s sql = sql_cmdLetValue
	}
   
    s sql = sql_" ORDER BY ID"
	s resultSet = ##class(%Library.ResultSet).%New()
    d resultSet.Prepare(sql)
    d resultSet.Execute()
    s count = 0
    S inCount=0
    s idxLast=PageSize+Index-1
    s json = ""
    s Fields="IDS,"_Fields
	while(resultSet.Next())
    {	
	    if ((inCount<=idxLast)&(inCount>=Index))
		{
      		s count=$Length(Fields, ",")
	  		f i=1:1:count 
	  		{
				s field = $Piece(Fields, ",", i)
				s reslutfield=$g(resultSet.Data(field))
				if (datestr[field){
					if (reslutfield'=0){
						s reslutfield=$zd(reslutfield,3)
						if (reslutfield="1840-12-31"){
							s reslutfield=" "
						}
						
					}
					if (reslutfield=0){
						s reslutfield=$zd(reslutfield,3)
						
					}
					}
					elseif (timestr[field){
					if (reslutfield'=0){
					s reslutfield=$zt(reslutfield,2)
					if (reslutfield="00:00"){
						s reslutfield=" "
						}
					}
					if (reslutfield=0){
					s reslutfield=$zt(reslutfield,2)}
					}
					
				if (field="IDS"){S reslutfield=inCount+1}
				if (i=1)
				{
					s json = json_"{"_field_":'"_reslutfield_"',"
				} 
				elseif(i = count)
				{
					s json = json_field_":'"_reslutfield_" '},"
				}
				else
				{
					s json = json_field_":'"_reslutfield_"',"
				}    
	  		}
      s ind = ind + 1 
      s count = count + 1  
      if (count = PageSize)
      {
	      Break
      }
    }
      S inCount=inCount+1
  }
    s json = $e(json, 1, $l(json)-1)
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s jsons ="{results:"_inCount_",rows:["_json_"]}"
	q jsons
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   取保存在配置表里面的字段名称
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: d ##class(CT.WS.BO.BODynamicConfigTable).GetClassFieldbyID("1")    
ClassMethod GetClassFieldbyID(strRowID As %String) As %String [ WebMethod ]
{
    q ##class(CT.WS.BLL.BLDynamicConfigTable).GetClassFieldbyID(strRowID)
}

}
