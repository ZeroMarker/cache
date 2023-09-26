Class User.DHCEQApproveList Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQApproveList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AL_Action
Property ALAction As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AL_Action ];

/// AL_ApproveDate
Property ALApproveDate As %Date [ SqlColumnNumber = 8, SqlFieldName = AL_ApproveDate ];

/// AL_ApproveRoleDR
Property ALApproveRoleDR As DHCEQCApproveRole [ SqlColumnNumber = 6, SqlFieldName = AL_ApproveRoleDR ];

/// AL_ApproveTime
Property ALApproveTime As %Time [ SqlColumnNumber = 9, SqlFieldName = AL_ApproveTime ];

/// AL_ApproveTypeDR
Property ALApproveTypeDR As DHCEQCApproveType [ SqlColumnNumber = 2, SqlFieldName = AL_ApproveTypeDR ];

/// AL_ApproveUserDR
Property ALApproveUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AL_ApproveUserDR ];

/// AL_FlowStep
Property ALFlowStep As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AL_FlowStep ];

/// AL_InvalidFlag
Property ALInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = AL_InvalidFlag ];

/// AL_OperateType
Property ALOperateType As %Library.String(DISPLAYLIST = ",同意,拒绝", MAXLEN = 2, SELECTIVITY = "50.0000%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 13, SqlFieldName = AL_OperateType ];

/// AL_Opinion
Property ALOpinion As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AL_Opinion ];

/// AL_Remark
Property ALRemark As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AL_Remark ];

/// AL_SourceID
Property ALSourceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AL_SourceID ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQApproveList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AL_Action">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AL_ApproveDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AL_ApproveRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AL_ApproveTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AL_ApproveTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AL_ApproveUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AL_FlowStep">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AL_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AL_OperateType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AL_Opinion">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AL_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQApproveList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApproveRole">
<Global>^DHCEQApproveList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ApproveRole"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AL_ApproveTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AL_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AL_ApproveRoleDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRole">
<Global>^DHCEQApproveList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Role"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AL_ApproveTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AL_ApproveRoleDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQApproveList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AL_ApproveTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AL_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStep">
<Global>^DHCEQApproveList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Step"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AL_ApproveTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AL_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AL_FlowStep}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>AL_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQApproveListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
