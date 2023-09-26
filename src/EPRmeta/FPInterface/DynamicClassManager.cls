Class EPRmeta.FPInterface.DynamicClassManager Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property ClassName As %String(MAXLEN = 128, TRUNCATE = 1);

/// the list item format is: "property name"_"^"_"property type"_"^"_"length"
Property ClassProperties As %List;

Property SQLOwner As %String(TRUNCATE = 1);

/// the global whose data is to be inserted into the dynamic class
/// the global's structure is -- UniqueId, AdmId, ColumnName
Property DataGlobal [ MultiDimensional ];

Property IndexName As %String(TRUNCATE = 1);

Property IndexGlobalName As %String(TRUNCATE = 1);

ClassMethod GetUniqueId() As %String
{
	q $i(^CacheTemp)
}

/// 删除指定的查询表中的数据
/// 返回值: "0"--fail "1"--succeed
Method ClearData() As %String
{
	///b "s"
	s ExistedTable=##class(%Dictionary.ClassDefinition).%OpenId(..ClassName)
	q:(ExistedTable="") 1
	k %ROWCOUNT
	s rs =##class(%Library.ResultSet).%New("%DynamicQuery:SQL")
	q:(rs="") "0"
	s ddl = "DELETE FROM "_..ClassName
	s PrepareResult=rs.Prepare(ddl)
	q:(PrepareResult'=1) "0"
	s ret = rs.Execute()
	d rs.Close()
	q:($g(%ROWCOUNT)'="") "1"
	q "0"
}

/// need repair -- repaired
/// return value: 1-succeed, 0-failed
Method DelGlobal() As %String
{
	///b "s"
	s aTable=##class(%Dictionary.CompiledClass).%OpenId(..ClassName)
	q:(aTable="") "1"
	s aStorage=aTable.Storages
	q:(aStorage="") "0"
	for i=1:1:aStorage.Count()
	{
		s aCompiledStorage=aStorage.GetAt(i)
		q:(aCompiledStorage="")
		s aDataLocation=aCompiledStorage.DataLocation
		q:(aDataLocation="")
		k @aDataLocation
		s aIndexLocation=aCompiledStorage.IndexLocation
		q:(aIndexLocation="")
		k @aIndexLocation
	}
	q "1"
}

/// need repair -- repaired
/// return value: 0-failed, 1-succeed
Method DelCompiledClass() As %String
{
	///b "s"
	;q:(($d(parClassName)=0)||(parClassName="")) "0"
	;s parClassName=parClassName
	s ExistedTable=##class(%Dictionary.ClassDefinition).%OpenId(..ClassName)
	if ExistedTable'="" {
	s status=$System.OBJ.Delete(..ClassName,"-d")
	q:(status=0) "0"
	q "1"}
	q "1"
}

/// 生成一个查询表
/// 返回值?1?成功?0?导出表未定义列?-1?失败
Method GenerateTable(argExportTable As ExportTable) As %String
{
	/// if parameter argExportTable is not null or empty, then generate class for it.
	/// Or generate class according to ..ClassProperties
	//b "s"
	if '(($d(argExportTable)=0)||(argExportTable="")) {
		s tmpList=""
		s tmp=argExportTable.TableColumns.Count()
		for i=1:1:argExportTable.TableColumns.Count() {
			s aCloumn=argExportTable.TableColumns.GetAt(i)
			s tmpList=tmpList_$lb(aCloumn.Name_"^"_aCloumn.DataType_"^"_aCloumn.Length)
		    //s tmpList=tmpList_$lb(aCloumn.Name_"^"_"String"_"^"_aCloumn.Length)
		}
		s ..ClassProperties=tmpList
	}
	
	;b "s"
	///取出要生成的表的定义
	s propertyCount=0
	s propertyCount=$ll(..ClassProperties)
	q:(propertyCount<1) "0"
	
	///动态生成类
	Set cdef = ##class(%Dictionary.ClassDefinition).%New(..ClassName)
	q:(cdef="") "-1"

	Set cdef.ClassType = "persistent"
	Set cdef.Super = "%Persistent"
	Set cdef.Owner= ..SQLOwner
	s columnInserted=0
	s columnName="",columnType="",columnLength=""
	
	// add properties
	for i=1:1:propertyCount
	{ 
	  s column=$lg(..ClassProperties,i)
	  s columnName=$p(column,"^",1)
	  s columnType=$p(column,"^",2)
	  s columnLength=$p(column,"^",3)
	  s columnName = $tr(columnName,"_","")
	  
	  q:(columnName="")||(columnType="")||(columnLength="")
		Set pdef = ##class(%Dictionary.PropertyDefinition).%New(columnName)
		
		;the statement below will generate a pdef with null name. you have to assign its name again
		;Set pdef = ##class(%Dictionary.PropertyDefinition).%New(columnName)
		q:(pdef="")
	
		d cdef.Properties.Insert(pdef)
		set pdef.Name=columnName
		Set pdef.Type="%"_columnType
		
		if columnType="String" {
			d pdef.Parameters.SetAt(columnLength,"MAXLEN")
			}
		elseif (columnType="Numeric" ||columnType="Integer"){
		d pdef.Parameters.SetAt("99999999","MAXVAL") 
		d pdef.Parameters.SetAt("-99999999","MINVAL")
			}
		}

	// save the class definition object
	b "s"
	s SaveStatus=cdef.%Save()
	q:(+SaveStatus=0) "-1"
	
	///编译类
	q $System.OBJ.Compile(..ClassName, "-d")
}

/// 向指定的查询表中插入数据
Method InsertData(parUniqueId As %String, parAdmId As %String) As %Status
{
	q:(($d(parUniqueId)=0)||(parUniqueId="")||($d(parAdmId)=0)||(parAdmId="")) 0
	s ColumnName=""
	s aCmd="aTable=##class("_..ClassName_").%New()"
	s @aCmd
	for  set ColumnName=$o(..DataGlobal(parUniqueId,parAdmId,ColumnName)) q:(ColumnName="")  d
	.s aCmd="aTable."_$tr(ColumnName,"_","")_"="""_..DataGlobal(parUniqueId,parAdmId,ColumnName)_""""
	.s @aCmd
	s aCmd="aTable.%Save()"
	d @aCmd ;aTable.%Save()

	q 1
}

/// 向指定的查询表中更新数据
Method UpdateData(parUniqueId As %String, parAdmId As %String, parRowID As %String) As %Status
{
	q:(($d(parUniqueId)=0)||(parUniqueId="")||($d(parAdmId)=0)||(parAdmId="")) 0
	q:(($d(parRowID)=0)||(parRowID="")) 0
	s ColumnName=""
	s aCmd="aTable=##class("_..ClassName_").%OpenId("_parRowID_")"
	s @aCmd
	for  set ColumnName=$o(..DataGlobal(parUniqueId,parAdmId,ColumnName)) q:(ColumnName="")  d
	.s aCmd="aTable."_$tr(ColumnName,"_","")_"="""_..DataGlobal(parUniqueId,parAdmId,ColumnName)_""""
	.s @aCmd
	s aCmd="aTable.%Save()"
	d @aCmd ;aTable.%Save()

	q 1
}

/// 检测要接受导出数据的数据库表是否存在
/// 1:存在    0：不存在
ClassMethod CheckTableExistByName(parTableName As %String) As %Boolean
{
	quit:$d(parTableName)=0||parTableName="" 0
	quit ##class(%Dictionary.ClassDefinition).%OpenId(parTableName)
}

/// add on 2007-12-10 , by houjian@dhcc.com.cn
/// 删除数据库表数据及其定义 
Method DeleteExportedTable() As %Boolean
{
	///b "s"
	quit:$d(..ClassName)=0||..ClassName="" 0
	s isExist = ##class(%Dictionary.ClassDefinition).%OpenId(..ClassName)
	quit:'isExist 1
	
	s isDelGlobal= ..DelGlobal()
	///s isClearData= ..ClearData()
	s isDelClass= ..DelCompiledClass()
	
	if isDelGlobal && isDelClass {
		quit 1
	}
	else{
		quit 0
	}
}

/// w ##class(DHC.EPR.FPInterface.DynamicClassManager).DelProperty("DHC.EPR.FPInterface.NewClass1","p2")
/// 删除属性(类名,属性名)
/// 返回:>0成功(2表示没有找到指定的属性),<0失败
ClassMethod DelProperty(className As %String, colName As %String) As %String
{
	q:(($d(className)=0)||(className="")||($d(colName)=0)||(colName="")) "-1"
	s ExistedTable=##class(%Dictionary.ClassDefinition).%OpenId(className)
	q:(ExistedTable="") "-1"
	
	s colName = $tr(colName,"_","")
	s isSaved="0"
	for i=1:1:ExistedTable.Properties.Count() 
	{
		s ExistedProperty=ExistedTable.Properties.GetAt(i)
		if ExistedProperty.Name = colName
		{
			s isSaved="1"
			d ExistedTable.Properties.RemoveAt(i)
			q
		}
	}
	
	if isSaved="1"
	{
		s SaveStatus=ExistedTable.%Save()
		q:(+SaveStatus=0) "-2"
		q $System.OBJ.Compile(className, "-d")
	}
	
	q "2"
}

/// w ##class(DHC.EPR.FPInterface.DynamicClassManager).GreateIndex("DHC.EPR.FPInterface.exptable1","indexaa","xm")
/// 创建索引(类名,索引名,索引所用的属性--以逗号分隔)
/// 返回:>0成功,<0失败
ClassMethod GreateIndex(className As %String, indexName As %String, indexCol As %String) As %String
{
	q:(($d(className)=0)||(className="")||($d(indexName)=0)||(indexName="")||($d(indexCol)=0)||(indexCol=""))
	s ExistedTable=##class(%Dictionary.ClassDefinition).%OpenId(className)
	q:(ExistedTable="") "-1"
	
	Set objIndex = ##class(%Dictionary.IndexDefinition).%New()
	
	s indexCol = $tr(indexCol,"_","")
	s objIndex.Properties = indexCol //逗号作为分割符
	s objIndex.Name = indexName
	s insertResult=ExistedTable.Indices.Insert(objIndex)
	q:(+insertResult=0) "-2"
	
	s SaveStatus=ExistedTable.%Save()
	q:(+SaveStatus=0) "-3"
	q $System.OBJ.Compile(className, "-d")
}

/// w ##class(DHC.EPR.FPInterface.DynamicClassManager).DelIndex("DHC.EPR.FPInterface.exptable1","indexaa","0")
/// 删除索引(类名,索引名,是否删除整个索引的Global--1:删除整个Global 其他:只删除相应索引的Global分支)
/// 返回:>0成功(2表示没有找到指定的索引),<0失败
ClassMethod DelIndex(className As %String, indexName As %String, isDelWholeGlobal As %String) As %String
{
	q:(($d(className)=0)||(className="")||($d(indexName)=0)||(indexName="")) "-1"
	s ExistedTable=##class(%Dictionary.ClassDefinition).%OpenId(className)
	q:(ExistedTable="") "-1"
	
	s aStorage=ExistedTable.Storages
	q:(aStorage="") "-2"
	for i=1:1:aStorage.Count()
	{
		s aCompiledStorage=aStorage.GetAt(i)
		q:(aCompiledStorage="")
		s aIndexLocation=aCompiledStorage.IndexLocation //这里没有处理多个Global的情况,认为一个Class的所有索引只使用了一个Global
		q:(aIndexLocation="")
		if isDelWholeGlobal="1"
		{
			s aIndexLocation = aIndexLocation //删除整个索引的Global
		}
		else
		{
			s aIndexLocation = aIndexLocation_"("_$c(34)_indexName_$c(34)_")" //只删除相应索引的Global分支
		}
		k @aIndexLocation
	}
	
	s isSaved="0"
	for i=1:1:ExistedTable.Indices.Count() 
	{
		s ExistedIndex=ExistedTable.Indices.GetAt(i)
		if ExistedIndex.Name = indexName
		{
			s isSaved="1"
			d ExistedTable.Indices.RemoveAt(i)
			q
		}
	}
	
	if isSaved="1"
	{
		s SaveStatus=ExistedTable.%Save()
		q:(+SaveStatus=0) "-3"
		q $System.OBJ.Compile(className, "-d")
	}
	
	q "2"
}

/// 取得对应索引的信息(索引名--如果为空,则取其中的第一个)
/// 返回：对应索引所使用的属性(逗号分隔),空表示没找到索引
/// 
/// 注：只取其中的一个索引
Method GetIndexInfo(indexName As %String) As %String
{
	if ($d(indexName)=0)
	{s indexName=""}
	s ExistedTable=##class(%Dictionary.ClassDefinition).%OpenId(..ClassName)
	q:(ExistedTable="") ""
	
	s aStorage=ExistedTable.Storages
	q:(aStorage="") ""
	for i=1:1:aStorage.Count()
	{
		s aCompiledStorage=aStorage.GetAt(i)
		q:(aCompiledStorage="")
		s aIndexLocation=aCompiledStorage.IndexLocation //这里没有处理多个Global的情况,认为一个Class的所有索引只使用了一个Global
		q:(aIndexLocation="")
		if ..IndexGlobalName="" 
		{s ..IndexGlobalName=aIndexLocation}
	}
	
	s resultStr=""
	for i=1:1:ExistedTable.Indices.Count() 
	{
		q:(resultStr'="")
		
		s ExistedIndex=ExistedTable.Indices.GetAt(i)
		if ((ExistedIndex.Name = indexName) && (indexName'=""))
		{
			s ..IndexName = ExistedIndex.Name
			s resultStr = ExistedIndex.Properties
		}
		elseif indexName="" //如果为空,则取其中的第一个
		{
			s ..IndexName = ExistedIndex.Name
			s resultStr = ExistedIndex.Properties

		}
	}
		
	q resultStr
}

/// 根据索引的Global判断数据是否存在(索引的数值,以 ^ 分隔)
/// 返回：非空--存在,空--不存在
/// 
/// 注：在调用该方法前,务必先调用GetIndexInfo
Method CheckExistDataByIndexG(argIndexData As %String) As %String
{
	q:(($d(argIndexData)=0)||(argIndexData="")) ""
	q:((..IndexGlobalName="")||(..IndexName="")) ""
	
	s argIndexData = $zcvt(argIndexData,"U")
	s indexData = ""
	for i=1:1:$l(argIndexData,"^")
	{
		s indexData=indexData_","_$c(34)_" "_$p(argIndexData,"^",i)_$c(34)
	}
	
	s indexLocation = ..IndexGlobalName_"("_$c(34)_..IndexName_$c(34)
	s indexLocation = indexLocation_indexData
	s indexLocation = "Rowid = $o("_indexLocation_","_$c(34)_$c(34)_"))"
	s @indexLocation
	s resultStr="Rowid"
	q @resultStr
}

/// ********************以下为测试代码*********************************
/// w ##class(DHC.EPR.FPInterface.DynamicClassManager).TestDeleteExportedTable()
ClassMethod TestDeleteExportedTable() As %Boolean
{
	///b "s"
	s dynClsMgr = ##class(DHC.EPR.FPInterface.DynamicClassManager).%New()
	s dynClsMgr.ClassName = "DHC.EPR.FPInterface.ExportedTables.basy"
	s isDelete = dynClsMgr.DeleteExportedTable()
	
	quit isDelete
}

Storage Default
{
<Data name="DynamicClassManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClassName</Value>
</Value>
<Value name="3">
<Value>ClassProperties</Value>
</Value>
<Value name="4">
<Value>IndexGlobalName</Value>
</Value>
<Value name="5">
<Value>IndexName</Value>
</Value>
<Value name="6">
<Value>SQLOwner</Value>
</Value>
</Data>
<DataLocation>^EPRmeta.FPI6E3.DynamicClass776D</DataLocation>
<DefaultData>DynamicClassManagerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRmeta.FPI6E3.DynamicClass776D</IdLocation>
<IndexLocation>^EPRmeta.FPI6E3.DynamicClass776I</IndexLocation>
<StreamLocation>^EPRmeta.FPI6E3.DynamicClass776S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
