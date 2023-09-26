Class dbo.BDReqAssessOperateRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReqAssessOperateRecord ]
{

/// Foreign Key FKBDRFOROperateUser created via DDL
ForeignKey FKBDRAOROperateUser(OperateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_RAOR_OperateUser ];

/// Foreign Key FKBDRFORRejectType created via DDL
ForeignKey FKBDRAORRejectType(RejectTypeDR) References dbo.BBRejectType(PKBBREJECTTYPE) [ SqlName = FK_BD_RAOR_RejectType ];

/// Foreign Key FKBDRFORReqForm created via DDL
ForeignKey FKBDRAORReqAssess(ReqAssessDR) References dbo.BDReqAssess(PKBDREQASSESS) [ SqlName = FK_BD_RAOR_ReqAssess ];

/// Foreign Key FKBDRFORWorkGroup created via DDL
ForeignKey FKBDRAORWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_RAOR_WorkGroup ];

Index IndexOperateDate On OperateDate [ SqlName = Index_OperateDate, Type = index ];

Index IndexReqAssess On ReqAssessDR [ SqlName = Index_ReqAssess, Type = index ];

/// DDL Primary Key Specification
Index PKBDREQASSESSOPERATERECORD On RowID [ PrimaryKey, SqlName = PK_BD_REQASSESSOPERATERECORD, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReqAssessDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property OperateType As %Library.SmallInt [ Required, SqlColumnNumber = 4 ];

Property RejectTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property OperateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property OperateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property OperateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BDReqAssessOperateRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqAssessDR</Value>
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
<DataLocation>^dbo.BDReqAssessOperateRecordD</DataLocation>
<DefaultData>BDReqAssessOperateRecordDefaultData</DefaultData>
<IdLocation>^dbo.BDReqAssessOperateRecordD</IdLocation>
<IndexLocation>^dbo.BDReqAssessOperateRecordI</IndexLocation>
<StreamLocation>^dbo.BDReqAssessOperateRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
