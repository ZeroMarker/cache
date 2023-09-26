Class User.DHCCertType Extends (%Persistent, User.Abstract) [ SqlRowIdName = CT_RowId, SqlTableName = DHC_CertType ]
{

/// 证件类型分组(Vendor:供应商，Manf:生产厂家)
Property CTType As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CT_Type ];

/// 类型编码
Property CTCode As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CT_Code ];

/// 类型全称
Property CTFullName As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = CT_FullName ];

/// 类型简称
Property CTShortName As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CT_ShortName ];

/// 类型序号
Property CTNum As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = CT_Num ];

/// 是否展示
Property CTShowFlag As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = CT_ShowFlag ];

/// 报警天数
Property CTWarnDays As %Library.Integer [ SqlColumnNumber = 8, SqlFieldName = CT_WarnDays ];

/// 入库控制天数
Property CTControlInDays As %Library.Integer [ SqlColumnNumber = 9, SqlFieldName = CT_ControlInDays ];

/// 出库控制天数
Property CTControlOutDays As %Library.Integer [ SqlColumnNumber = 10, SqlFieldName = CT_ControlOutDays ];

/// 临床使用控制天数
Property CTControlUseDays As %Library.Integer [ SqlColumnNumber = 11, SqlFieldName = CT_ControlUseDays ];

Index Type On CTType As Exact;

Index TypeCode On (CTType As Exact, CTCode As Exact);

Index TypeNum On (CTType As Exact, CTNum As Exact);

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CTType</Value>
</Value>
<Value name="3">
<Value>CTCode</Value>
</Value>
<Value name="4">
<Value>CTFullName</Value>
</Value>
<Value name="5">
<Value>CTShortName</Value>
</Value>
<Value name="6">
<Value>CTNum</Value>
</Value>
<Value name="7">
<Value>CTShowFlag</Value>
</Value>
<Value name="8">
<Value>CTWarnDays</Value>
</Value>
<Value name="9">
<Value>CTControlInDays</Value>
</Value>
<Value name="10">
<Value>CTControlOutDays</Value>
</Value>
<Value name="11">
<Value>CTControlUseDays</Value>
</Value>
</Data>
<DataLocation>^User.DHCCertTypeD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^User.DHCCertTypeD</IdLocation>
<IndexLocation>^User.DHCCertTypeI</IndexLocation>
<StreamLocation>^User.DHCCertTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
