Class EPRservice.Query.ExportTables Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Index idxName On TableName [ Unique ];

Property ClearData As %String(TRUNCATE = 1);

Property Columns As list Of EPRservice.Query.ExportTableColumns;

Property Description As %String(TRUNCATE = 1);

Property ExportHistory As %String(MAXLEN = 20000, TRUNCATE = 1);

Property TableName As %String(TRUNCATE = 1) [ Required ];

Property TableNamespace As %String(TRUNCATE = 1);

/// 删除指定的查询表中的数据
/// 返回值: "0"--fail "1"--succeed
ClassMethod ClearData(parTableName As %String) As %String
{
	s ExistedTable=##class(%Dictionary.ClassDefinition).%OpenId("EPRservice.Query."_parTableName)
	q:(ExistedTable="") 1
	k %ROWCOUNT
 s rs =##class(%Library.ResultSet).%New("%DynamicQuery:SQL")
 q:(rs="") "0"
 s ddl = "DELETE FROM EPRservice_Query." _ parTableName
 s PrepareResult=rs.Prepare(ddl)
 q:(PrepareResult'=1) "0"
 s ret = rs.Execute()
 d rs.Close()
 q:($g(%ROWCOUNT)'="") "1"
 q "0"
	/*
	*/
}

/// need repair -- repaired
ClassMethod DelClassGlobal(parClassName As %String) As %String
{
	s aTable=##class(%Dictionary.CompiledClass).%OpenId("EPRservice.Query."_parClassName)
	q:(aTable="") 1
	s aStorage=aTable.Storages
	q:(aStorage="") 0
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
	q 1
}

/// need repair -- repaired
ClassMethod DelCompiledClass(parClassName As %String) As %String
{
	q:(($d(parClassName)=0)||(parClassName="")) 0
	s parClassName="EPRservice.Query."_parClassName
	s ExistedTable=##class(%Dictionary.ClassDefinition).%OpenId(parClassName)
	if ExistedTable'="" {
	s status=$System.OBJ.Delete(parClassName,"-d")
	q:(status=0) "-1"
	q "1"}
	q 1
}

/// 删除一个查询表定义
/// 返回值?1-成功?0-参数不对?不存在该表定义?不存在该表?-1?失败
/// need repair
ClassMethod Delete(argId As %String) As %String
{
	q:(($d(argId)=0)||(argId="")) 0
	if ##class(EPRservice.Query.ExportTables).%ExistsId(argId) {
		;s aTable=##class(EPRservice.Query.ExportTables).%OpenId(argId)
		;s TableName="EPRservice.Query."_aTable.TableName
		s sc=##class(EPRservice.Query.ExportTables).%DeleteId(argId)}
	else {q "0"}
	q:(sc=0) "-1"
	;s result=##class(EPRservice.Query.ExportTables).DelExportTable(TableName)
	;q:(result=0) "-1"
	q 1
}

/// 生成一个查询表
/// 返回值?1?成功?0?导出表未定义列?-1?失败
ClassMethod GenerateTable(argTableName As %String, argTableNamespace As %String) As %String
{
	b "s"
	q:(($d(argTableName)=0)||(argTableName="")) "-1" ///argTableName can't be null or empty string
	if (($d(argTableNamespace)=0)||(argTableNamespace="")) {s argTableNamespace=$zu(5)} ///default namespace is current namespace
	;b "s"
	/*//如果表已存在?删除该表及其中的数据?再新建表
	s ExistedTable=##class(%Dictionary.ClassDefinition).%OpenId(FullTableName)
	s DelResult=0
	if (ExistedTable'="") {
		s ClearResult=##class(EPRservice.Query.ExportTables).Delete(argTableName)
		q:(ClearResult<0) "-1"
		s DelResult=##class(EPRservice.Query.ExportTables).Delete(ExistedTable)
		q:(DelResult=0) "-1"}*/
	
	///取出要生成的表的定义
	s FullTableName="EPRservice.Query."_argTableName
	s aTable=##class(EPRservice.Query.ExportTables).GetTableByName(argTableName)
	q:(aTable="") "-1"
	q:(aTable.Columns.Count()<1) "0"
	
	///动态生成类
	Set cdef = ##class(%Dictionary.ClassDefinition).%New(FullTableName)
	q:(cdef="") "-1"

 Set cdef.ClassType = "persistent"
 Set cdef.Super = "%Persistent"
 Set cdef.Owner= "lz"
	
 // add propertys
 for i=1:1:aTable.Columns.Count()
 {
	  ;b "s"
	  s ColumnName=argTableName_":"_aTable.Columns.GetAt(i).Name
	  ;w ColumnName,!
 Set pdef = ##class(%Dictionary.PropertyDefinition).%New(ColumnName)
		q:(pdef="")

 d cdef.Properties.Insert(pdef)
 Set pdef.Type="%String"
 set ColLength=aTable.Columns.GetAt(i).Length
 if $g(ColLength)="" {s ColLength="50"}
 ;w "MAXLEN="_ColLength,!
 d pdef.Parameters.SetAt(ColLength,"MAXLEN")
	}
	;b
 // save the class definition object
 s SaveStatus=cdef.%Save()
 ;w SaveStatus,!
 q:(+SaveStatus=0) "-1"

 ///编译类

 q $System.OBJ.Compile(FullTableName, "-d")
}

/// "-1" error, "-100" no history
ClassMethod GetExportHistory(parExportTable As %String) As %String
{
	B "S"
	q:(($d(parExportTable)=0)||(parExportTable="")) "-1"
	s ExistedHistory="-100"
	k SQLCODE
	&sql(select ExportHistory into :ExistedHistory from EPRservice_Query.ExportTables
			 where TableName=:parExportTable)
	q:((SQLCODE'=0)&&(SQLCODE'=100)) "-1"
	q:(ExistedHistory="") "-100"
	q ExistedHistory
}

/// 取得ExportTables类的实例
ClassMethod GetTableByName(argTableName As %String) As EPRservice.Query.ExportTables
{
	q:(($d(argTableName)=0)||(argTableName="")) ""
	s id=""
	
	k SQLCODE
	&sql(select id into :id from EPRservice_Query.ExportTables where TableName=:argTableName)
	q:(SQLCODE'=0) ""
	q:(id="") ""
	
	s aTable=##class(EPRservice.Query.ExportTables).%OpenId(id)
	q aTable
}

/// 向指定的查询表中导入数据
ClassMethod ImportData(parTableName As %String, parImportUniqueId As %String) As %Status
{
	q:(($d(parTableName)=0)||(parTableName="")) 0
	s AdmId=0
	for  set AdmId=$o(^CacheTempEPRResult(parImportUniqueId,AdmId)) q:(AdmId="")  d
	.s ColumnName=""
	.s aCmd="aTable=##class(EPRservice.Query."_parTableName_").%New()"
	.s @aCmd
	.;s aCmd="(aTable="""")"
	.;q:@aCmd
	.for  set ColumnName=$o(^CacheTempEPRResult(parImportUniqueId,AdmId,ColumnName)) q:(ColumnName="")  d
	..s aCmd="aTable."_ColumnName_"="""_^CacheTempEPRResult(parImportUniqueId,AdmId,ColumnName)_""""
	..s @aCmd
	.s aCmd="aTable.%Save()"
	.d @aCmd ;aTable.%Save()
	q 1
}

/// 列定义格式?
/// Name^DataType^ItemCode^Description^Length||Name^DataType^ItemCode^Description^Length
/// argColumns can't exceed 32767 characters
/// 向ExportTables表中增加一个查询表的定义
ClassMethod Insert(argExportTable As ExportTables) As %String
{
	q:(argExportTable="") 0
	
	s aColumn="",aColumns="",aTable=""
	s aTable=##class(EPRservice.Query.ExportTables).%New()
	q:(aTable="") 0
	
	s aTable.TableName=argExportTable.TableName
	s aTable.TableNamespace=argExportTable.TableNamespace
	s aTable.ClearData=argExportTable.ClearData
	s aTable.Description=argExportTable.Description
	s aTable.Columns=argExportTable.Columns
	
	for i=1:1:aTable.Columns.Count()
	{
		s aColumn=aTable.Columns.GetAt(i)
		if ((aColumn.Length="")||(aColumn.Length=$c(0)))
		{s aColumn.Length="50"
		 d aTable.Columns.SetAt(aColumn,i)
		 }
	}
	
	s x=aTable.%Save()
	q:(x=1) aTable.%Id()
	q 0
}

/// 返回值: "0"--失败, "1"--成功
ClassMethod SetExportHistory(parExportTable As %String, parHistory As %String) As %String
{
	q:(($d(parExportTable)=0)||(parExportTable="")) "0"
	q:(($d(parHistory)=0)||(parHistory="")) "0"
	
	s ExistedHistory=""
	k SQLCODE
	&sql(select ExportHistory into :ExistedHistory from EPRservice_Query.ExportTables
			 where TableName=:parExportTable)
	q:((SQLCODE'=0)&&(SQLCODE'=100)) "0"
	
	//Clear History data if there have been 16 export history items
	if ($l(ExistedHistory,$c(10)_$c(13))-1)'<16
	{	
		k SQLCODE
		&sql(update EPRservice_Query.ExportTables set ExportHistory=""
				 where TableName=:parExportTable)
		q:((SQLCODE'=0)&&(SQLCODE'=100)) "0"
		s ExistedHistory=""
	}
	
	S NewHistory=ExistedHistory_parHistory_$c(10)_$c(13)
	k SQLCODE
	&sql(update EPRservice_Query.ExportTables set ExportHistory=:NewHistory where TableName=:parExportTable)
	q:((SQLCODE'=0)&&(SQLCODE'=100)) "0"
	q "1"
}

/// 更新一个查询表定义
ClassMethod Update(argId As %String, argTableName As %String, argTableNamespace As %String = "", argClearDara As %String, argDesc As %String, argColumns As %String) As %Status
{
	q:(($d(argId)=0)||(argId="")) 0
	q:(($d(argTableName)=0)||(argTableName="")) 0 ///argTableName can't be null or empty string
	q:(($d(argColumns)=0)||(argColumns="")||($l(argColumns,"^")=1)) 0 ///argColumns can't be null or empty string or without "^"
	if (($d(argTableNamespace)=0)||(argTableNamespace="")) {s argTableNamespace=$zu(5)} ///default namespace is current namespace
	if (($d(argClearDara)=0)||(argClearDara="")) {s argClearDara="1"} ///default ClearData is 1, clear existed data
	
	s aColumn="",aColumns="",aTable=""
	s aTable=##class(EPRservice.Query.ExportTables).%OpenId(argId)
	q:(aTable="") 0
	for i=1:1:($l(argColumns,"||")) {
		;b "s"
		s aColumnString=$p(argColumns,"||",i)
		s aColumn=##class(EPRservice.Query.ExportTableColumns).%New()
		q:(aColumn="")
		s aColumn.Name=$p(aColumnString,"^",1)
		s aColumn.DataType=$p(aColumnString,"^",2)
		s aColumn.ItemCode=$p(aColumnString,"^",3)
		s aColumn.Description=$p(aColumnString,"^",4)
		s ColLength=$p(aColumnString,"^",5)
		if ColLength="" {s ColLength="50"}
		s aColumn.Length=ColLength
		d aTable.Columns.Insert(aColumn)
	}
	q:(aTable.Columns.Count()=0) 0
	s aTable.TableName=argTableName
	s aTable.TableNamespace=argTableNamespace
	s aTable.ClearData=argClearDara
	s aTable.Description = argDesc
	s x=aTable.%Save()
	q x
}

ClassMethod test() As %String
{
	;k ^EPRservi.ExportTablesD,^EPRservi.ExportTablesI
	s a="paytype^string^一般情况.医疗付款方式#TYPE:Simple#TID:129#TVER:0#SCODE:O0013#VTYPE:V^^100||"
	s a=a_"intimes^string^一般情况.住院次数#TYPE:Simple#TID:129#TVER:0#SCODE:N0046#VTYPE:V^^||"
	s a=a_"baid^string^一般情况.病案号#TYPE:Simple#TID:129#TVER:0#SCODE:S0018#VTYPE:V^^||"
	s a=a_"birth^string^一般情况.出  生#TYPE:Simple#TID:129#TVER:0#SCODE:D0056#VTYPE:V^^||"
	s a=a_"occupation^string^一般情况.职  业#TYPE:Simple#TID:129#TVER:0#SCODE:I0010#VTYPE:V^^||"
	s a=a_"maindiag^string^出院情况.主要诊断#TYPE:Simple#TID:125#TVER:0#SCODE:I0002#VTYPE:V^^||"
	s a=a_"diag8^string^出院情况.诊断8#TYPE:Simple#TID:125#TVER:0#SCODE:I0036#VTYPE:V^^||"
	s a=a_"sszdwbys^string^出院情况.损伤?中毒的外部因素?#TYPE:Simple#TID:125#TVER:0#SCODE:I0034#VTYPE:V^^||"
	s a=a_"icd108^string^出院情况.ICD?10-08#TYPE:Simple#TID:125#TVER:0#SCODE:I0042#VTYPE:V^^||"
	s a=a_"dissituation9^string^出院情况.出院情况09#TYPE:Simple#TID:125#TVER:0#SCODE:O0032#VTYPE:V^^||"
	s a=a_"ywgm^string^出院情况.药物过敏#TYPE:Segment#TID:125#TVER:0#GCODE:G0043^^||"
	s a=a_"disdate^string^出院情况.日期?#TYPE:Simple#TID:125#TVER:0#SCODE:D0077#VTYPE:V^^||"
	s a=a_"opercode3^string^手术情况.手术操作编码3#TYPE:Simple#TID:126#TVER:0#SCODE:I0012#VTYPE:V^^||"
	s a=a_"operdate3^string^手术情况.手术操作日期3#TYPE:Segment#TID:126#TVER:0#GCODE:G0016^^||"
	s a=a_"opername4^string^手术情况.手术操作名称4#TYPE:Simple#TID:126#TVER:0#SCODE:I0025#VTYPE:V^^||"
	s a=a_"opertime^string^手术情况.时间#TYPE:Segment#TID:126#TVER:0#GCODE:G0067^^||"
	s a=a_"bloodfee^string^费用情况.输血费#TYPE:Simple#TID:127#TVER:0#SCODE:S0024#VTYPE:V^^||"
	s a=a_"sz^string^其它情况.随诊#TYPE:Simple#TID:128#TVER:0#SCODE:O0003#VTYPE:V^^||"
	s a=a_"bloodreaction^string^其它情况.输血反应?#TYPE:Simple#TID:128#TVER:0#SCODE:O0012#VTYPE:V^^||"
	s a=a_"wholeblood^string^其它情况.4.全血#TYPE:Simple#TID:128#TVER:0#SCODE:N0017#VTYPE:V^^"
	s b=##class(EPRservice.Query.ExportTables).Insert("test","","0","",a)
	q b
}

ClassMethod test1(argTableName As %String, argTableNamespace As %String) As %Status
{
}

ClassMethod test2() As %String
{
	k ^EPRservi.ExportTablesD,^EPRservi.ExportTablesI
	s a=##class(EPRservice.Query.ExportTables).%New()
	q:(a="") ""
	s a.TableName="NewTest"
	s a.TableNamespace=""
	s a.ClearData="1"
	s a.Description="insert a class instance2"
	
	s b=##class(EPRservice.Query.ExportTableColumns).%New()
	s b.Name="paytype"
	s b.DataType=""
	s b.Length="100"
	s b.Description="string paytype"
	s b.ItemCode="一般情况.医疗付款方式#TYPE:Simple#TID:129#TVER:0#SCODE:O0013#VTYPE:V"
	d a.Columns.Insert(b)
	
	s c=##class(EPRservice.Query.ExportTableColumns).%New()
	s c.Name="intimes"
	s c.DataType=""
	;s c.Length="10"
	s c.Description="string intimes"
	s c.ItemCode="一般情况.住院次数#TYPE:Simple#TID:129#TVER:0#SCODE:N0046#VTYPE:V"
	d a.Columns.Insert(c)

	q ##class(EPRservice.Query.ExportTables).Insert(a)
}

Query GetAllTables() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,TableName FROM EPRservice_Query.ExportTables
 ORDER BY TableName
}

Storage Default
{
<Data name="ExportTablesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClearData</Value>
</Value>
<Value name="3">
<Value>Columns</Value>
</Value>
<Value name="4">
<Value>TableName</Value>
</Value>
<Value name="5">
<Value>TableNamespace</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>ExportHistory</Value>
</Value>
</Data>
<DataLocation>^EPRservi.ExportTablesD</DataLocation>
<DefaultData>ExportTablesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRservi.ExportTablesD</IdLocation>
<IndexLocation>^EPRservi.ExportTablesI</IndexLocation>
<StreamLocation>^EPRservi.ExportTablesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
