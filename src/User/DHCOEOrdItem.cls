/// OE_OrdItem Extend
Class User.DHCOEOrdItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCORI_RowId, SqlTableName = DHC_OE_OrdItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 500000;

/// DHCORI_OEORI_Dr
Property DHCORIOEORIDr As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = DHCORI_OEORI_Dr ];

/// DHCORI_SkinTestCtcp_Dr
Property DHCORISkinTestCtcpDr As User.CTCareProv [ SqlColumnNumber = 3, SqlFieldName = DHCORI_SkinTestCtcp_Dr ];

/// DHCORI_SkinTestDate
Property DHCORISkinTestDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DHCORI_SkinTestDate ];

/// DHCORI_SkinTestTime
Property DHCORISkinTestTime As %Library.Time(SELECTIVITY = "25.0000%") [ SqlColumnNumber = 5, SqlFieldName = DHCORI_SkinTestTime ];

/// DHCORI_RefundAuditStatus
Property DHCORIRefundAuditStatus As %Library.String(DISPLAYLIST = ",Normal,Audit,Cancel", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,A,C") [ SqlColumnNumber = 6, SqlFieldName = DHCORI_RefundAuditStatus ];

/// DHCORI_RefundAuditUser_Dr
Property DHCORIRefundAuditUserDr As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DHCORI_RefundAuditUser_Dr ];

/// DHCORI_RefundAuditDate
Property DHCORIRefundAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = DHCORI_RefundAuditDate ];

/// DHCORI_RefundAuditTime
Property DHCORIRefundAuditTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = DHCORI_RefundAuditTime ];

/// DHCORI_RefundReason
Property DHCORIRefundReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DHCORI_RefundReason ];

/// DHCORI_RefAuditLoc_DR
Property DHCORIRefAuditLocDR As User.CTLoc [ SqlColumnNumber = 11, SqlFieldName = DHCORI_RefAuditLoc_DR ];

/// DHCORI_PAALG_Dr
Property DHCORIPAALGDr As User.PAAllergy [ SqlColumnNumber = 12, SqlFieldName = DHCORI_PAALG_Dr ];

/// DHCORI_DisconUser_Dr
Property DHCORIDisconUserDr As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = DHCORI_DisconUser_Dr ];

/// DHCORI_DisconDate
Property DHCORIDisconDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = DHCORI_DisconDate ];

/// DHCORI_DisconTime
Property DHCORIDisconTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = DHCORI_DisconTime ];

/// DHCORI_MedAuditUser_Dr
Property DHCORIMedAuditUserDr As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = DHCORI_MedAuditUser_Dr ];

/// DHCORI_MedAuditDate
Property DHCORIMedAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = DHCORI_MedAuditDate ];

/// DHCORI_MedAuditTime
Property DHCORIMedAuditTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = DHCORI_MedAuditTime ];

/// DHCORI_DispTimeList
Property DHCORIDispTimeList As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DHCORI_DispTimeList ];

/// DHCORI_Approved
Property DHCORIApproved As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = DHCORI_Approved ];

/// DHCORI_ApprovedUser_dr
Property DHCORIApprovedUserdr As User.SSUser [ SqlColumnNumber = 21, SqlFieldName = DHCORI_ApprovedUser_dr ];

/// DHCORI_ApprovedDate
Property DHCORIApprovedDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 22, SqlFieldName = DHCORI_ApprovedDate ];

/// DHCORI_ApprovedTime
Property DHCORIApprovedTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = DHCORI_ApprovedTime ];

/// DHCORI_SkinTestAuditCtcp_Dr
Property DHCORISkinTestAuditCtcpDr As User.CTCareProv [ SqlColumnNumber = 24, SqlFieldName = DHCORI_SkinTestAuditCtcp_Dr ];

/// DHCORI_SkinTestAuditDate
Property DHCORISkinTestAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = DHCORI_SkinTestAuditDate ];

/// DHCORI_SkinTestAuditTime
Property DHCORISkinTestAuditTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = DHCORI_SkinTestAuditTime ];

/// DHCLisReport link
Property DHCORILISReportDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = DHCORI_LISReport_DR ];

/// DHCORI_ConfirmFlag
Property DHCORIConfirmFlag As %Library.String(DISPLAYLIST = ",No,Yes,Reject", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,Y,R") [ SqlColumnNumber = 28, SqlFieldName = DHCORI_ConfirmFlag ];

/// DHCORI_ConfirmDate
Property DHCORIConfirmDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 29, SqlFieldName = DHCORI_ConfirmDate ];

/// DHCORI_ConfirmTime
Property DHCORIConfirmTime As %Library.Time [ SqlColumnNumber = 30, SqlFieldName = DHCORI_ConfirmTime ];

/// DHCORI_ConfirmUser
Property DHCORIConfirmUser As User.SSUser [ SqlColumnNumber = 31, SqlFieldName = DHCORI_ConfirmUser ];

/// DHCORI_WardID
Property DHCORIWardID As User.PACWard [ SqlColumnNumber = 32, SqlFieldName = DHCORI_WardID ];

/// DHCORI_Paadm_dr
Property DHCORIPaadmdr As User.PAAdm [ SqlColumnNumber = 33, SqlFieldName = DHCORI_Paadm_dr ];

/// DHCORI_DoctorConfirmFlag
Property DHCORIDoctorConfirmFlag As %Library.String [ SqlColumnNumber = 34, SqlFieldName = DHCORI_DoctorConfirmFlag ];

/// DHCORI_DoctorConfirmDate
Property DHCORIDoctorConfirmDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 35, SqlFieldName = DHCORI_DoctorConfirmDate ];

/// DHCORI_DoctorConfirmTime
Property DHCORIDoctorConfirmTime As %Library.Time [ SqlColumnNumber = 36, SqlFieldName = DHCORI_DoctorConfirmTime ];

/// DHCORI_DoctorConfirmUser_Dr
Property DHCORIDoctorConfirmUserDr As User.SSUser [ SqlColumnNumber = 37, SqlFieldName = DHCORI_DoctorConfirmUser_Dr ];

/// DHCORI_ApprovedPercent
Property DHCORIApprovedPercent As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = DHCORI_ApprovedPercent ];

/// DHCORI_ApprovedLimit
Property DHCORIApprovedLimit As %Library.Float [ SqlColumnNumber = 39, SqlFieldName = DHCORI_ApprovedLimit ];

/// DHCORI_ApprovedFlag
Property DHCORIApprovedFlag As %Library.String [ SqlColumnNumber = 40, SqlFieldName = DHCORI_ApprovedFlag ];

/// DHCORI_WardID
Property DHCORIApproveType As %Library.String [ SqlColumnNumber = 41, SqlFieldName = DHCORI_ApproveType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCORDItem(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="DHCORI_ApproveType">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>8</Piece>
</Data>
<Data name="DHCORI_Approved">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>1</Piece>
</Data>
<Data name="DHCORI_ApprovedDate">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>3</Piece>
</Data>
<Data name="DHCORI_ApprovedFlag">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>7</Piece>
</Data>
<Data name="DHCORI_ApprovedLimit">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>6</Piece>
</Data>
<Data name="DHCORI_ApprovedPercent">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>5</Piece>
</Data>
<Data name="DHCORI_ApprovedTime">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>4</Piece>
</Data>
<Data name="DHCORI_ApprovedUser_dr">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>2</Piece>
</Data>
<Data name="DHCORI_ConfirmDate">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>2</Piece>
</Data>
<Data name="DHCORI_ConfirmFlag">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>1</Piece>
</Data>
<Data name="DHCORI_ConfirmTime">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>3</Piece>
</Data>
<Data name="DHCORI_ConfirmUser">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>4</Piece>
</Data>
<Data name="DHCORI_DisconDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCORI_DisconTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCORI_DisconUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCORI_DispTimeList">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCORI_DoctorConfirmDate">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>2</Piece>
</Data>
<Data name="DHCORI_DoctorConfirmFlag">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>1</Piece>
</Data>
<Data name="DHCORI_DoctorConfirmTime">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>3</Piece>
</Data>
<Data name="DHCORI_DoctorConfirmUser_Dr">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>4</Piece>
</Data>
<Data name="DHCORI_LISReport_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCORI_MedAuditDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCORI_MedAuditTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCORI_MedAuditUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCORI_OEORI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCORI_PAALG_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCORI_Paadm_dr">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>6</Piece>
</Data>
<Data name="DHCORI_RefAuditLoc_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="DHCORI_RefundAuditDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="DHCORI_RefundAuditStatus">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="DHCORI_RefundAuditTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="DHCORI_RefundAuditUser_Dr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="DHCORI_RefundReason">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="DHCORI_SkinTestAuditCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCORI_SkinTestAuditDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCORI_SkinTestAuditTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCORI_SkinTestCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCORI_SkinTestDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCORI_SkinTestTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCORI_WardID">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>5</Piece>
</Data>
<Global>^DHCORDItem</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCORI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHCORI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexConfirm">
<Global>^DHCORDItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHCORI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ConfirmFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCORI_ConfirmFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCORI_WardID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCORI_Paadm_dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCORI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOeOrdItem">
<Global>^DHCORDItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCORI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCORI_OEORI_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCORI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOEOrdItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
