Class User.DHCEQChangeInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CI_RowID, SqlTableName = DHC_EQChangeInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CI_ApproveListDR
Property CIApproveListDR As User.DHCEQApproveList [ SqlColumnNumber = 13, SqlFieldName = CI_ApproveListDR ];

/// CI_AuditDate
Property CIAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = CI_AuditDate ];

/// CI_AuditTime
Property CIAuditTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = CI_AuditTime ];

/// CI_AuditUser
Property CIAuditUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = CI_AuditUser ];

/// CI_ChangeDate
Property CIChangeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = CI_ChangeDate ];

/// CI_ChangeTypeDR
Property CIChangeTypeDR As User.DHCEQCChangeType [ SqlColumnNumber = 4, SqlFieldName = CI_ChangeTypeDR ];

/// CI_EquipDR
Property CIEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = CI_EquipDR ];

/// CI_FromOther
Property CIFromOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CI_FromOther ];

/// CI_FromStatus
Property CIFromStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CI_FromStatus ];

/// CI_GroupDR
Property CIGroupDR As User.DHCEQGroup [ SqlColumnNumber = 3, SqlFieldName = CI_GroupDR ];

/// CI_InvalidFlag
Property CIInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = CI_InvalidFlag ];

/// CI_Reason
Property CIReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CI_Reason ];

/// CI_Remark
Property CIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CI_Remark ];

/// CI_SourceID
Property CISourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CI_SourceID ];

/// CI_SourceType
Property CISourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CI_SourceType ];

/// CI_Status
Property CIStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 8, SqlFieldName = CI_Status ];

/// CI_SubmitDate
Property CISubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = CI_SubmitDate ];

/// CI_SubmitTime
Property CISubmitTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = CI_SubmitTime ];

/// CI_SubmitUser
Property CISubmitUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = CI_SubmitUser ];

/// CI_ToOther
Property CIToOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CI_ToOther ];

/// CI_ToStatus
Property CIToStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CI_ToStatus ];

/// CI_UpdateDate
Property CIUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = CI_UpdateDate ];

/// CI_UpdateTime
Property CIUpdateTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = CI_UpdateTime ];

/// CI_UpdateUser
Property CIUpdateUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CI_UpdateUser ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQChangeInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CI_ApproveListDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CI_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CI_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CI_AuditUser">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CI_ChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CI_ChangeTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CI_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CI_FromOther">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CI_FromStatus">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CI_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CI_Reason">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CI_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CI_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CI_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CI_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CI_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CI_SubmitUser">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CI_ToOther">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CI_ToStatus">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CI_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^DHCEQChangeInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexChangeType">
<Global>^DHCEQChangeInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>CI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EquipChangeType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CI_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CI_ChangeTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>+{CI_SourceType}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>+{CI_SourceID}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{CI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQChangeInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
