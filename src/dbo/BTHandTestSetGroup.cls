Class dbo.BTHandTestSetGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_HandTestSetGroup, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = IndexCode, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = IndexSeqNum, Type = index ];

Index IndexWorkGroup On (HospitalDR, WorkGroupDR, Code) [ SqlName = IndexWorkGroup, Type = index ];

/// DDL Primary Key Specification
Index PKBTHandTestSetGroup On RowID [ PrimaryKey, SqlName = PK_BT_BTHandTestSetGroup, Type = index, Unique ];

/// Foreign Key FKHandTestSetGroupHosp created via DDL
ForeignKey FKHandTestSetGroupHosp(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_HandTestSetGroupHosp ];

/// Foreign Key FKHandTestSetGroupWG created via DDL
ForeignKey FKHandTestSetGroupWG(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_HandTestSetGroupWG ];

/// RowID
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 医院
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 序号
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTHandTestSetGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>WorkGroupDR</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTHandTestSetGroupD</DataLocation>
<DefaultData>BTHandTestSetGroupDefaultData</DefaultData>
<IdLocation>^dbo.BTHandTestSetGroupD</IdLocation>
<IndexLocation>^dbo.BTHandTestSetGroupI</IndexLocation>
<StreamLocation>^dbo.BTHandTestSetGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
