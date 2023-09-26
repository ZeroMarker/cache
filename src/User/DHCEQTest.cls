Class User.DHCEQTest Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Parameter EXTENTSIZE = 250;

/// LT_Code
Property LTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = LT_Code ];

/// LT_Desc
Property LTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = LT_Desc ];

/// LT_Remark
Property LTRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LT_Remark ];

/// LT_InvalidFlag
Property LTInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = LT_InvalidFlag ];

Storage Default
{
<Data name="DHCEQTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LTCode</Value>
</Value>
<Value name="3">
<Value>LTDesc</Value>
</Value>
<Value name="4">
<Value>LTInvalidFlag</Value>
</Value>
<Value name="5">
<Value>LTRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCEQTestD</DataLocation>
<DefaultData>DHCEQTestDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.DHCEQTestD</IdLocation>
<IndexLocation>^User.DHCEQTestI</IndexLocation>
<StreamLocation>^User.DHCEQTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
