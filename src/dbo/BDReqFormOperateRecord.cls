///     
Class dbo.BDReqFormOperateRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReqFormOperateRecord, StorageStrategy = Default ]
{

/// Foreign Key FKBDRFOROperateUser created via DDL
ForeignKey FKBDRFOROperateUser(OperateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_RFOR_OperateUser ];

/// Foreign Key FKBDRFORRejectType created via DDL
ForeignKey FKBDRFORRejectType(RejectTypeDR) References dbo.BBRejectType(PKBBREJECTTYPE) [ SqlName = FK_BD_RFOR_RejectType ];

/// Foreign Key FKBDRFORReqForm created via DDL
ForeignKey FKBDRFORReqForm(ReqtFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_RFOR_ReqForm ];

/// Foreign Key FKBDRFORWorkGroup created via DDL
ForeignKey FKBDRFORWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_RFOR_WorkGroup ];

Index IndexOperateDate On OperateDate [ SqlName = Index_OperateDate, Type = index ];

Index IndexOperateType On OperateType [ SqlName = Index_OperateType, Type = index ];

Index IndexOperateUser On OperateUserDR [ SqlName = Index_OperateUser, Type = index ];

Index IndexReqForm On ReqtFormDR [ SqlName = Index_ReqForm, Type = index ];

Index IndexWorkGroupDR On WorkGroupDR [ SqlName = Index_WorkGroupDR, Type = index ];

/// DDL Primary Key Specification
Index PKBDREQFORMOPERATERECORD On RowID [ PrimaryKey, SqlName = PK_BD_REQFORMOPERATERECORD, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReqtFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property OperateType As %Library.SmallInt [ Required, SqlColumnNumber = 4 ];

Property RejectTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property OperateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property OperateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property OperateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BDReqFormOperateRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqtFormDR</Value>
</Value>
<Value name="3">
<Value>OperateType</Value>
</Value>
<Value name="4">
<Value>RejectTypeDR</Value>
</Value>
<Value name="5">
<Value>OperateDate</Value>
</Value>
<Value name="6">
<Value>OperateTime</Value>
</Value>
<Value name="7">
<Value>OperateUserDR</Value>
</Value>
<Value name="8">
<Value>WorkGroupDR</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReqFormOperateRecordD</DataLocation>
<DefaultData>BDReqFormOperateRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDReqFormOperateRecordD</IdLocation>
<IndexLocation>^dbo.BDReqFormOperateRecordI</IndexLocation>
<StreamLocation>^dbo.BDReqFormOperateRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
