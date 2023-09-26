///     
Class dbo.BDTakeRecordComponents Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TakeRecordComponents, StorageStrategy = Default ]
{

/// Foreign Key FKBDTRComComponents created via DDL
ForeignKey FKBDTRComComponents(BloodComponentsDR) References dbo.BBBloodComponents(PKBBBLOODCOMPONENTS) [ SqlName = FK_BD_TRCom_Components ];

/// Foreign Key FKBDTRComTakeRecord created via DDL
ForeignKey FKBDTRComTakeRecord(TakeRecordDR) References dbo.BDTakeRecord(PKBDTAKERECORD) [ SqlName = FK_BD_TRCom_TakeRecord ];

/// Foreign Key FKBDRFPBloodGroup created via DDL
ForeignKey FKBDTAKPBloodGroup(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_TRCom_BloodGroup ];

Index IndexMaster On (TakeRecordDR, BloodComponentsDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDTAKERECORDCOMPONENTS On RowID [ PrimaryKey, SqlName = PK_BD_TAKERECORDCOMPONENTS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TakeRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property BloodComponentsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Volume As %Library.Float [ Required, SqlColumnNumber = 5 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property Units As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BDTakeRecordComponentsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TakeRecordDR</Value>
</Value>
<Value name="3">
<Value>BloodComponentsDR</Value>
</Value>
<Value name="4">
<Value>Volume</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
<Value name="6">
<Value>Units</Value>
</Value>
<Value name="7">
<Value>BloodGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDTakeRecordComponentsD</DataLocation>
<DefaultData>BDTakeRecordComponentsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDTakeRecordComponentsD</IdLocation>
<IndexLocation>^dbo.BDTakeRecordComponentsI</IndexLocation>
<StreamLocation>^dbo.BDTakeRecordComponentsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
