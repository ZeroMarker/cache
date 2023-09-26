/// 医保医用耗材分类与代码
Class User.MATInsuCode Extends (%Persistent, User.Abstract) [ SqlRowIdName = MATIC_RowId, SqlTableName = MAT_InsuCode ]
{

/// 国家医保耗材编码
Property MATICInsuCode As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = MATIC_InsuCode ];

/// 一级分类(学科,品类)
Property MATICClass1 As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = MATIC_Class1 ];

/// 二级分类(用途,品目)
Property MATICClass2 As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = MATIC_Class2 ];

/// 三级分类(部位,功能,品种)
Property MATICClass3 As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = MATIC_Class3 ];

/// 医保通用名
Property MATICGenericName As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = MATIC_GenericName ];

/// 耗材材质
Property MATICQuality As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = MATIC_Quality ];

/// 规格(特征,参数)
Property MATICSpec As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 8, SqlFieldName = MATIC_Spec ];

/// 耗材生产企业
Property MATICManfName As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 9, SqlFieldName = MATIC_ManfName ];

/// 激活标记
Property MATICActiveFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 10, SqlFieldName = MATIC_ActiveFlag ];

/// 国家医保数据中的product_id (需要索引）
Property MATICProductId As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 11, SqlFieldName = MATIC_ProductId ];

Property MATICRegCardId As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 12, SqlFieldName = MATIC_RegCardId ];

Property MATICUomDesc As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 13, SqlFieldName = MATIC_UomDesc ];

/// 植入
Property MATICIMPFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = INPP_IMPFlag ];

/// 灭菌
Property MATICSterFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = INPP_SterFlag ];

/// 一次性标志
Property MATICTempFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = INPP_TempFlag ];

/// 代码前15位,计算字段
Property MATICCode15 As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 17, SqlComputeCode = { Set {MATIC_Code15} = $e({MATIC_InsuCode},1,15)}, SqlComputed, SqlComputeOnChange = MATICInsuCode, SqlFieldName = MATIC_Code15 ];

Index MATICInsuCode On MATICInsuCode As Exact;

Index Code15 On MATICCode15 As Exact;

Index MATICGenericName On MATICGenericName As Exact;

Index MATICProductId On MATICProductId As Exact;

Storage Default
{
<Data name="MATInsuCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATICInsuCode</Value>
</Value>
<Value name="3">
<Value>MATICClass1</Value>
</Value>
<Value name="4">
<Value>MATICClass2</Value>
</Value>
<Value name="5">
<Value>MATICClass3</Value>
</Value>
<Value name="6">
<Value>MATICGenericName</Value>
</Value>
<Value name="7">
<Value>MATICQuality</Value>
</Value>
<Value name="8">
<Value>MATICSpec</Value>
</Value>
<Value name="9">
<Value>MATICManfName</Value>
</Value>
<Value name="10">
<Value>MATICActiveFlag</Value>
</Value>
<Value name="11">
<Value>MATICProductId</Value>
</Value>
<Value name="12">
<Value>MATICRegCardId</Value>
</Value>
<Value name="13">
<Value>MATICUomDesc</Value>
</Value>
<Value name="14">
<Value>MATICIMPFlag</Value>
</Value>
<Value name="15">
<Value>MATICSterFlag</Value>
</Value>
<Value name="16">
<Value>MATICTempFlag</Value>
</Value>
<Value name="17">
<Value>MATICCode15</Value>
</Value>
</Data>
<DataLocation>^User.MATInsuCodeD</DataLocation>
<DefaultData>MATInsuCodeDefaultData</DefaultData>
<IdLocation>^User.MATInsuCodeD</IdLocation>
<IndexLocation>^User.MATInsuCodeI</IndexLocation>
<StreamLocation>^User.MATInsuCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
