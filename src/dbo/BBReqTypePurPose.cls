Class dbo.BBReqTypePurPose Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ReqTypePurPose, StorageStrategy = Default ]
{

/// Foreign Key FKBBRPPPurpose created via DDL
ForeignKey FKBBRTReqType(ReqTypeDR) References dbo.BBReqType(PKBBREQTYPE) [ SqlName = FK_BB_RT_ReqType ];

/// Foreign Key FKBBRPPPurpose created via DDL
ForeignKey FKBBRTPurpose(PurposeDR) References dbo.BBPurpose(PKBBPURPOSE) [ SqlName = FK_BB_RT_Purpose ];

Index IndexMaster On (ReqTypeDR, PurposeDR) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBBReqTypePurPose On RowID [ PrimaryKey, SqlName = PK_ReqType_PurPose, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReqTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PurposeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BBReqTypePurPoseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqTypeDR</Value>
</Value>
<Value name="3">
<Value>PurposeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBReqTypePurPoseD</DataLocation>
<DefaultData>BBReqTypePurPoseDefaultData</DefaultData>
<IdLocation>^dbo.BBReqTypePurPoseD</IdLocation>
<IndexLocation>^dbo.BBReqTypePurPoseI</IndexLocation>
<StreamLocation>^dbo.BBReqTypePurPoseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
