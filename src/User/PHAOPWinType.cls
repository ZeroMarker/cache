Class User.PHAOPWinType Extends (%Persistent, User.Abstract) [ SqlRowIdName = OPWTt_RowId, SqlTableName = PHAOP_WinType ]
{

/// 描述
Property OPWTCode As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = OPWT_Code ];

/// 代码
Property OPWTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = OPWT_Desc ];

/// 毒麻 标识
Property OPWTDMFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = OPWT_DMFlag ];

Storage Default
{
<Data name="PHAOPWinTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OPWTCode</Value>
</Value>
<Value name="3">
<Value>OPWTDesc</Value>
</Value>
<Value name="4">
<Value>OPWTDMFlag</Value>
</Value>
</Data>
<DataLocation>^CF.PHA.OP.WinType</DataLocation>
<DefaultData>PHAOPWinTypeDefaultData</DefaultData>
<IdLocation>^CF.PHA.OP.WinType</IdLocation>
<IndexLocation>^CF.PHA.OP.WinTypei</IndexLocation>
<StreamLocation>^User.PHAOPWinTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
