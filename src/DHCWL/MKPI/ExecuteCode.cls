/// DHCWL_MKPI.MKPI_ExecuteCode    d ##class(DHCWL.MKPI.ExecuteCode).%BuildIndices()
Class DHCWL.MKPI.ExecuteCode Extends %Persistent [ ClassType = persistent, SqlTableName = MKPI_ExecuteCode ]
{

/// Creator by lhh@20130321
/// 执行代码类型，目前纳入的类型包括指标，维度，区间，任务等四个。
Property ExeCodeType As %String(DISPLAYLIST = ",指标代码,维度代码,区间任务代码,区间生成代码", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",KPI,DIM,TAS,SEC") [ Required, SqlColumnNumber = 2, SqlFieldName = ExeCode_Type ];

/// 执行代码填写语法，此字段要严格大小写和特殊字符的出现，不然会造成调用代码后执行错误。	 
Property ExeCodeWrite As %String(COLLATION = "Exact", MAXLEN = 150) [ Required, SqlColumnNumber = 3, SqlFieldName = ExcCode_Write ];

/// 执行代码调用举例，该字段作为方便使用者调试使用，可以将该值复制后直接在terminal下执行。
Property ExeCodeCall As %String(MAXLEN = 200) [ SqlColumnNumber = 4, SqlFieldName = ExcCode_Call ];

/// 执行代码版本号
Property ExeCodeVersion As %String [ SqlColumnNumber = 5, SqlFieldName = ExcCode_Version ];

/// 创建日期
Property ExcCodeCUDate As %Date [ SqlColumnNumber = 6, SqlFieldName = ExcCode_CUDate ];

/// 执行代码创建者
Property ExeCodeCreator As %String [ SqlColumnNumber = 7, SqlFieldName = ExcCode_Creator ];

/// 执行代码传送数据是否使用约定global
Property ExcCodeGlobalFlag As %String(MAXLEN = 2) [ SqlColumnNumber = 8, SqlFieldName = ExcCode_GlobalFlag ];

/// 执行代码适用范围
Property ExcCodeApplicable As %String(MAXLEN = 100) [ SqlColumnNumber = 9, SqlFieldName = ExcCode_Applicable ];

/// 执行代码功能描述及其说明
Property ExcCodeDescription As %String(MAXLEN = 100) [ SqlColumnNumber = 10, SqlFieldName = ExcCode_Description ];

/// 	执行代码子类型。指标有收入、工作量等子类型；任务有日、月、季、年等子类型等等。
Property ExcCodeSubType As %String [ SqlColumnNumber = 11, SqlFieldName = ExcCode_SubType ];

/// 	默认执行代码标志。某子类下如有多条执行代码数据，用来指定默认的执行代码的标志。
Property ExcCodeDefaultFlag As %String [ SqlColumnNumber = 12, SqlFieldName = ExcCode_DefaultFlag ];

Index ExcCodeTypeI On (ExeCodeType As AlphaUp, ExeCodeWrite);

Index TypeSubType On (ExeCodeType, ExcCodeSubType);

Storage Default
{
<Data name="ExecuteCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExeCodeType</Value>
</Value>
<Value name="3">
<Value>ExeCodeWrite</Value>
</Value>
<Value name="4">
<Value>ExeCodeCall</Value>
</Value>
<Value name="5">
<Value>ExeCodeVersion</Value>
</Value>
<Value name="6">
<Value>ExeCodeCreator</Value>
</Value>
<Value name="7">
<Value>ExcCodeGlobalFlag</Value>
</Value>
<Value name="8">
<Value>ExcCodeApplicable</Value>
</Value>
<Value name="9">
<Value>ExcCodeDescription</Value>
</Value>
<Value name="10">
<Value>ExcCodeCUDate</Value>
</Value>
<Value name="11">
<Value>ExcCodeSubType</Value>
</Value>
<Value name="12">
<Value>ExcCodeDefaultFlag</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.ExecuteCodeD</DataLocation>
<DefaultData>ExecuteCodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.ExecuteCodeD</IdLocation>
<IndexLocation>^DHCWL.MKPI.ExecuteCodeI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.ExecuteCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
