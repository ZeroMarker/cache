/// 治疗评定量表
Class User.DHCDocCureAssScale Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCAS_RowID, SqlTableName = DHC_DocCureAssScale ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCDocCureAssScaleForm As User.DHCDocCureAssScaleForm [ Cardinality = children, Inverse = DCASFParRefDr ];

Relationship ChildDHCDocCureAssScaleSet As User.DHCDocCureAssScaleSet [ Cardinality = children, Inverse = DCASSParRefDr ];

/// DCAS_Code  代码
Property DCASCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DCAS_Code ];

/// DCAS_Desc  描述
Property DCASDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DCAS_Desc ];

/// DCAS_Html  表单Html
Property DCASHtml As %Library.String(COLLATION = "Exact", MAXLEN = 99999, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DCAS_Html ];

/// DCAS_LockFlag  加锁标志
Property DCASLockFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DCAS_LockFlag ];

/// DCAS_Hosp_Dr  医院
Property DCASHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = DCAS_Hosp_Dr ];

/// DCAS_Cat_Dr  评定分类
Property DCASCatDr As %Library.String [ SqlColumnNumber = 7, SqlFieldName = DCAS_Cat_Dr ];

/// DCAS_Html  表单Html流
Property DCASHtmlStream As %Stream.GlobalCharacter [ SqlColumnNumber = 8, SqlFieldName = DCAS_HtmlStream ];

Index DCASCodeIndex On DCASCode;

Index DCASDescIndex On DCASDesc;

Index DCASCatIndex On DCASCatDr;

Index DCASHospCodeIndex On (DCASHospDr, DCASCode);

Index DCASHospDescIndex On (DCASHospDr, DCASDesc);

Storage Default
{
<Data name="DHCDocCureAssScaleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DCASCode</Value>
</Value>
<Value name="3">
<Value>DCASDesc</Value>
</Value>
<Value name="4">
<Value>DCASHtml</Value>
</Value>
<Value name="5">
<Value>DCASLockFlag</Value>
</Value>
<Value name="6">
<Value>DCASHospDr</Value>
</Value>
<Value name="7">
<Value>DCASCatDr</Value>
</Value>
<Value name="8">
<Value>DCASHtmlStream</Value>
</Value>
<Value name="9">
<Value>DCASHtmlStream1</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocCureAssScaleD</DataLocation>
<DefaultData>DHCDocCureAssScaleDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdFunction>sequence</IdFunction>
<IdLocation>^User.DHCDocCureAssScaleD</IdLocation>
<IndexLocation>^User.DHCDocCureAssScaleI</IndexLocation>
<StreamLocation>^User.DHCDocCureAssScaleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
