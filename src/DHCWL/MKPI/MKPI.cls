/// DHCWL_MKPI.DHCWLMKPI  d ##class(DHCWL.MKPI.MKPI).%BuildIndices()
Class DHCWL.MKPI.MKPI Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLMKPI ]
{

/// 代码
Property MKPICode As %String [ SqlColumnNumber = 2, SqlFieldName = MKPI_Code ];

/// 名称
Property MKPIName As %String [ SqlColumnNumber = 3, SqlFieldName = MKPI_Name ];

/// 描述
Property MKPIDesc As %String [ SqlColumnNumber = 4, SqlFieldName = MKPI_Desc ];

/// 用户
Property MKPIUser As %String [ SqlColumnNumber = 5, SqlFieldName = MKPI_User ];

/// 创建日期
Property MKPIUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = MKPI_UpdateDate ];

/// 执行代码
Property MKPIEXCode As %String(MAXLEN = 100) [ SqlColumnNumber = 7, SqlFieldName = MKPI_EXCode ];

/// 备注
Property MKPIRemark As %String(MAXLEN = 150) [ SqlColumnNumber = 8, SqlFieldName = MKPI_Remark ];

/// 分类
Property MKPICate As DHCWL.MKPI.MKPIFL [ SqlColumnNumber = 9, SqlFieldName = MKPI_Cate ];

/// 维度信息代码,关联DHCWL.MKPI.MKPIDimType
/// 3.0以后不再使用该属性
Property MKPITypeDr As DHCWL.MKPI.MKPIDimType [ SqlColumnNumber = 10, SqlFieldName = MKPI_TypeDr ];

/// 区间标志
Property MKPISectionFlag As DHCWL.MKPI.Section [ SqlColumnNumber = 11, SqlFieldName = MKPI_SectionFlag ];

/// 数据节点
Property MKPIDataNod As %String [ SqlColumnNumber = 12, SqlFieldName = MKPI_DataNod ];

/// 是否global指标数据
Property MKPIGlobalFlag As %String [ SqlColumnNumber = 13, SqlFieldName = MKPI_GlobalFlag ];

/// 取值类型
Property MKPIGetValueType As %String [ SqlColumnNumber = 14, SqlFieldName = MKPI_GetValueType ];

Index MKPICode On MKPICode As AlphaUp;

Index MKPIName On MKPIName As AlphaUp;

Index MKPICate On MKPICate;

Index MKPIValueType On MKPIGetValueType;

///      Index MKPICode On MKPICode [ Unique ];
ClassMethod InsertOrUpdateData(ByRef aryParam) As %String
{
	//n (aryParam)
	s MKPICode=aryParam("MKPICode")
	s alphaup=$SYSTEM.SQL.ALPHAUP(MKPICode)
	s ret=""
	if $d(^DHCWL.MKPI.MKPII("MKPICode",alphaup)) {
		s sql="update DHCWL_MKPI.DHCWLMKPI set MKPI_Name='"_aryParam("MKPIName")
		s sql=sql_"',MKPI_Desc='"_aryParam("MKPIDesc")_"',MKPI_User='"_aryParam("MKPIUser")
		s sql=sql_"',MKPI_UpdateDate='"_aryParam("MKPIUpdateDate")_"',MKPI_EXCode='"_aryParam("MKPIEXCode")
		s sql=sql_"',MKPI_Remark='"_aryParam("MKPIRemark")_"',MKPI_Cate='"_aryParam("MKPICate")
		s sql=sql_"',MKPI_SectionFlag='"_aryParam("MKPISectionFlag")_"',MKPI_DataNod='"_aryParam("MKPIDataNod")
		s sql=sql_"',MKPI_GlobalFlag='"_aryParam("MKPIGlobalFlag")_"',MKPI_GetValueType='"_aryParam("MKPIGetValueType")_"'"
		s sql=sql_" where MKPI_Code='"_aryParam("MKPICode")_"'"
		
		s rs=##class(%Library.ResultSet).%New()
		s st=rs.Prepare(sql) if ($$$ISERR(st)) goto InsertError
		s st=rs.Execute()  if ($$$ISERR(st)) goto InsertError
		s ret="success"
	}else{
		
		s sql="insert into DHCWL_MKPI.DHCWLMKPI (MKPI_Code,MKPI_Name,MKPI_Desc,MKPI_User,MKPI_UpdateDate,MKPI_EXCode,MKPI_Remark,MKPI_Cate,MKPI_SectionFlag,MKPI_DataNod,MKPI_GlobalFlag,MKPI_GetValueType) values ("
		s sql=sql_"'"_aryParam("MKPICode")_"','"_aryParam("MKPIName")
		s sql=sql_"','"_aryParam("MKPIDesc")_"','"_aryParam("MKPIUser")
		s sql=sql_"','"_aryParam("MKPIUpdateDate")_"','"_aryParam("MKPIEXCode")
		s sql=sql_"','"_aryParam("MKPIRemark")_"','"_aryParam("MKPICate")
		s sql=sql_"','"_aryParam("MKPISectionFlag")_"','"_aryParam("MKPIDataNod")
		s sql=sql_"','"_aryParam("MKPIGlobalFlag")_"','"_aryParam("MKPIGetValueType")_"')"		
		s rs=##class(%Library.ResultSet).%New()
		s st=rs.Prepare(sql) if ($$$ISERR(st)) goto InsertError
		s st=rs.Execute()  if ($$$ISERR(st)) goto InsertError
		s ret="success"
	}
	q ret
	
InsertError
	s ret=$System.Status.GetErrorText(st)
	q ret
}

Storage Default
{
<Data name="MKPIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKPICode</Value>
</Value>
<Value name="3">
<Value>MKPIDesc</Value>
</Value>
<Value name="4">
<Value>MKPIEXCode</Value>
</Value>
<Value name="5">
<Value>MKPIName</Value>
</Value>
<Value name="6">
<Value>MKPIRemark</Value>
</Value>
<Value name="7">
<Value>MKPIUpdateDate</Value>
</Value>
<Value name="8">
<Value>MKPIUser</Value>
</Value>
<Value name="9">
<Value>MKPICate</Value>
</Value>
<Value name="10">
<Value>MKPITypeDr</Value>
</Value>
<Value name="11">
<Value>MKPISectionFlag</Value>
</Value>
<Value name="12">
<Value>MKPIDataNod</Value>
</Value>
<Value name="13">
<Value>MKPIGlobalFlag</Value>
</Value>
<Value name="14">
<Value>MKPIGetValueType</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MKPID</DataLocation>
<DefaultData>MKPIDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.MKPID</IdLocation>
<IndexLocation>^DHCWL.MKPI.MKPII</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MKPIS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
