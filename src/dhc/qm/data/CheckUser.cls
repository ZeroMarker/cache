Class dhc.qm.data.CheckUser Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CheckUser_rowid, SqlTableName = CheckUser ]
{

/// CheckUser_CheckDr
Property CheckUserCheckDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = CheckUser_CheckDr ];

/// CheckUser_active
Property CheckUserActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = CheckUser_active ];

Index CheckUserCheckDr On CheckUserCheckDr;

Storage Default
{
<Data name="CheckUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckUserCheckDr</Value>
</Value>
<Value name="3">
<Value>CheckUserActive</Value>
</Value>
</Data>
<DataLocation>^DHCCJXQMCheckUserD</DataLocation>
<DefaultData>CheckUserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXQMCheckUserD</IdLocation>
<IndexLocation>^DHCCJXQMCheckUserI</IndexLocation>
<StreamLocation>^DHCCJXQMCheckUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
