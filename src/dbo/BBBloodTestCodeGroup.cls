Class dbo.BBBloodTestCodeGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BloodTestCodeGroup, StorageStrategy = Default ]
{

/// Foreign Key FKBBAgreeTestItemHospital created via DDL
ForeignKey FKBBBloodTestCodeGroupHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_BloodTestCodeGroupHospital ];

/// Foreign Key FKBBAgreeTestItemItem created via DDL
ForeignKey FKBBTestCodeGroupTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BB_TestCodeGroupTestCode ];

/// Foreign Key FKBBAgreeTestItemItem created via DDL
ForeignKey FKBBTestCodeGroupParentTestCode(ParentTestDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BB_TestCodeGroupParentTestCode ];

Index IndexMaster On (HospitalDR, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBBAGREETESTITEM On RowID [ PrimaryKey, SqlName = PK_BB_AGREETESTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ParentTestDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBBloodTestCodeGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospitalDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>ParentTestDR</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBloodTestCodeGroupD</DataLocation>
<DefaultData>BBBloodTestCodeGroupDefaultData</DefaultData>
<IdLocation>^dbo.BBBloodTestCodeGroupD</IdLocation>
<IndexLocation>^dbo.BBBloodTestCodeGroupI</IndexLocation>
<StreamLocation>^dbo.BBBloodTestCodeGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
