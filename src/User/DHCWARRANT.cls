Class User.DHCWARRANT Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WARR_ROWID, SqlTableName = DHC_WARRANT, StorageStrategy = SQLStorage ]
{

/// PATIENT PAADM ROWID
Property WARRADMDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = WARR_ADM_DR ];

/// SS_USER ROWID
Property WARRUSERDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = WARR_USER_DR ];

/// WARRANT AMOUNT
Property WARRAMT As %Float [ SqlColumnNumber = 4, SqlFieldName = WARR_AMT ];

/// WARR_DATE
Property WARRDATE As %Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = WARR_DATE ];

/// WARR_LIMMIT_DATE
Property WARRLIMMITDATE As %Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = WARR_LIMMIT_DATE ];

/// WARR_STATUS
Property WARRSTATUS As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = WARR_STATUS ];

/// WARR_PAID_STATUS
Property WARRPAIDSTATUS As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = WARR_PAID_STATUS ];

/// WARR_Warrantor
Property WARRWarrantor As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = WARR_Warrantor ];

/// WARR_MEMO
Property WARRMEMO As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = WARR_MEMO ];

/// WARR_PAPMI_DR
Property WARRPAPMIDR As User.PAPatMas [ SqlColumnNumber = 11, SqlFieldName = WARR_PAPMI_DR ];

/// WARR_PatType
Property WARRPatType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = WARR_PatType ];

/// WARR_AuditFlag
Property WARRAuditFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = WARR_AuditFlag ];

/// WARR_AuditUSER_DR
Property WARRAuditUSERDR As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = WARR_AuditUSER_DR ];

/// WARR_AuditDate
Property WARRAuditDate As %Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = WARR_AuditDate ];

/// WARR_AuditTime
Property WARRAuditTime As %Time [ SqlColumnNumber = 16, SqlFieldName = WARR_AuditTime ];

/// WARR_Time
Property WARRTime As %Time [ SqlColumnNumber = 17, SqlFieldName = WARR_Time ];

/// 担保申请表的指针
Property WARRequestDR As User.DHCEmDocGuarantee [ SqlColumnNumber = 18, SqlFieldName = WARR_Request_DR ];

/// 担保物
Property WARRWarrantItem As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = WARR_WarrantItem ];

/// 医院
Property WARRHospDR As User.CTHospital [ SqlColumnNumber = 20, SqlFieldName = WARR_Hosp_DR ];

/// 担保原因
Property WARRReasonDR As User.DHCEmGuaReason [ SqlColumnNumber = 21, SqlFieldName = WARR_Reason_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCWARRANT)</SqlIdExpression>
<SQLMap name="dataMaster">
<Data name="WARR_ADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WARR_AMT">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WARR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="WARR_AuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WARR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="WARR_AuditUSER_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="WARR_DATE">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WARR_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="WARR_LIMMIT_DATE">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WARR_MEMO">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WARR_PAID_STATUS">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WARR_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WARR_PatType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WARR_ROWID">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WARR_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="WARR_Request_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="WARR_STATUS">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WARR_Time">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="WARR_USER_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WARR_WarrantItem">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="WARR_Warrantor">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCWARRANT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WARR_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{WARR_ROWID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="iIndexPAPMI">
<Global>^DHCWARRANT</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
<StartValue>0</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{WARR_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{WARR_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexAdm">
<Global>^DHCWARRANT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WARR_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
<StartValue>0</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{WARR_ADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{WARR_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDate">
<Global>^DHCWARRANT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WARR_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
<StartValue>0</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DATA"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{WARR_DATE}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{WARR_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWARRANTS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
