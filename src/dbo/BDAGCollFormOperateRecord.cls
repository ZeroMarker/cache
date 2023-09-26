///     
Class dbo.BDAGCollFormOperateRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AGCollFormOperateRecord, StorageStrategy = Default ]
{

/// Foreign Key FKAGCollFormOperateRecord created via DDL
ForeignKey FKAGCollFormOperateRecord(AGCollFormDR) References dbo.BDAGCollForm(PKBDAGCOLLFORM) [ SqlName = FK_AGCollFormOperateRecord ];

/// Foreign Key FKAGCollFormOperateRecordRejectType created via DDL
ForeignKey FKAGCollFormOperateRecordRejectType(RejectTypeDR) References dbo.BBRejectType(PKBBREJECTTYPE) [ SqlName = FK_AGCollFormOperateRecord_RejectType ];

/// Foreign Key FKAGCollFormOperateRecordUser created via DDL
ForeignKey FKAGCollFormOperateRecordUser(OperateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AGCollFormOperateRecord_User ];

Index IndexMaster On (AGCollFormDR, OperateDate, OperateTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexOperateDate On (OperateDate, OperateUserDR) [ SqlName = Index_OperateDate, Type = index ];

/// DDL Primary Key Specification
Index IndexRejectType On RowID [ PrimaryKey, SqlName = Index_RejectType, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AGCollFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property OperateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property OperateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property OperateType As %Library.SmallInt [ Required, SqlColumnNumber = 6 ];

Property OperateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property RejectTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BDAGCollFormOperateRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AGCollFormDR</Value>
</Value>
<Value name="3">
<Value>OperateDate</Value>
</Value>
<Value name="4">
<Value>OperateTime</Value>
</Value>
<Value name="5">
<Value>OperateType</Value>
</Value>
<Value name="6">
<Value>OperateUserDR</Value>
</Value>
<Value name="7">
<Value>WorkGroupDR</Value>
</Value>
<Value name="8">
<Value>RejectTypeDR</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAGCollFormOperateRecordD</DataLocation>
<DefaultData>BDAGCollFormOperateRecordDefaultData</DefaultData>
<IdLocation>^dbo.BDAGCollFormOperateRecordD</IdLocation>
<IndexLocation>^dbo.BDAGCollFormOperateRecordI</IndexLocation>
<StreamLocation>^dbo.BDAGCollFormOperateRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
