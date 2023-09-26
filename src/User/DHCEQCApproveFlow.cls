Class User.DHCEQCApproveFlow Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AF_RowID, SqlTableName = DHC_EQCApproveFlow, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AF_ActionDR
Property AFActionDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AF_ActionDR ];

/// AF_ApproveRoleDR
Property AFApproveRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 3, SqlFieldName = AF_ApproveRoleDR ];

/// AF_ApproveSetDR
Property AFApproveSetDR As User.DHCEQCApproveSet [ SqlColumnNumber = 2, SqlFieldName = AF_ApproveSetDR ];

/// AF_CanRepeatFlag
Property AFCanRepeatFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = AF_CanRepeatFlag ];

/// AF_CancelFlag
Property AFCancelFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = AF_CancelFlag ];

/// AF_CancelToFlowDR
Property AFCancelToFlowDR As User.DHCEQCApproveFlow [ SqlColumnNumber = 7, SqlFieldName = AF_CancelToFlowDR ];

/// AF_CancelToType
Property AFCancelToType As %Library.String(DISPLAYLIST = ",默认下一步,指定步骤,人为操作指定步骤,根据条件流转步骤", MAXLEN = 5, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 14, SqlFieldName = AF_CancelToType ];

/// AF_GotoType
Property AFGotoType As %Library.String(DISPLAYLIST = ",默认下一步,指定步骤,人为操作指定步骤,根据条件流转步骤", MAXLEN = 5, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 12, SqlFieldName = AF_GotoType ];

/// AF_Hold1
Property AFHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AF_Hold1 ];

/// AF_Hold2
Property AFHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AF_Hold2 ];

/// AF_Hold3
Property AFHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AF_Hold3 ];

/// AF_LastFlag
Property AFLastFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AF_LastFlag ];

/// AF_LocDR
Property AFLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AF_LocDR ];

/// AF_NextToFlowDR
Property AFNextToFlowDR As User.DHCEQCApproveFlow [ SqlColumnNumber = 13, SqlFieldName = AF_NextToFlowDR ];

/// AF_QXType
Property AFQXType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AF_QXType ];

/// AF_Step
Property AFStep As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AF_Step ];

/// AF_UnMustFlag
Property AFUnMustFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = AF_UnMustFlag ];

/// AF_Hold4
Property AFHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AF_Hold4 ];

/// AF_ComponentSetID
Property AFComponentSetID As User.DHCEQCComponentSet [ SqlColumnNumber = 20, SqlFieldName = AF_ComponentSetID ];

/// AF_HospLimit 院区限制0:不限 1:本院及医院组总院 2.本院 3.医院组总院
Property AFHospLimit As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AF_HospLimit ];

/// AF_DefaultOpinion
Property AFDefaultOpinion As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = AF_DefaultOpinion ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCApproveFlow",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AF_ActionDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AF_ApproveRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AF_ApproveSetDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AF_CanRepeatFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AF_CancelFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AF_CancelToFlowDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AF_CancelToType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AF_ComponentSetID">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AF_DefaultOpinion">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AF_GotoType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AF_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AF_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AF_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AF_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AF_HospLimit">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AF_LastFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AF_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AF_NextToFlowDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AF_QXType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AF_Step">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AF_UnMustFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCApproveFlow"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAction">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCApproveFlow"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Action"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AF_ApproveSetDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AF_ActionDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApproveRole">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCApproveFlow"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ApproveRole"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AF_ApproveSetDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AF_ApproveRoleDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApproveSet">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCApproveFlow"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ApproveSet"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AF_ApproveSetDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApproveStep">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCApproveFlow"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ApproveStep"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AF_ApproveSetDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AF_Step}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCApproveFlowS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
