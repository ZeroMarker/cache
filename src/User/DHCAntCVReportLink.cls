Class User.DHCAntCVReportLink Extends %Persistent [ SqlRowIdName = DPRL_RowID, SqlTableName = DHC_AntCVReportLink, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DPRLOrder [ IdKey, PrimaryKey, Unique ];

/// DHC_AntCVReport Parent Reference
Relationship DPRLParRef As User.DHCAntCVReport [ Cardinality = parent, Inverse = ChildDHCAntCVReportLink, Required, SqlFieldName = DPRL_ParRef ];

/// DPRL_Order
Property DPRLOrder As %Integer [ SqlColumnNumber = 2, SqlFieldName = DPRL_Order ];

/// DPRL_Type (1 医嘱  2 电子病历 3读记录 4护士通知医生 5接收确认 6医技科室撤销)
Property DPRLType As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DPRL_Type ];

/// DPRL_ObjID
Property DPRLObjID As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DPRL_ObjID ];

/// DPRL_UserID
Property DPRLUserID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DPRL_UserID ];

/// DPRL_Date
Property DPRLDate As %Date [ SqlColumnNumber = 6, SqlFieldName = DPRL_Date ];

/// DPRL_Time
Property DPRLTime As %Time [ SqlColumnNumber = 7, SqlFieldName = DPRL_Time ];

/// DPRL_OtherInfo
Property DPRLOtherInfo As %String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DPRL_OtherInfo ];

Property DPRLStatus As %String(DISPLAYLIST = ",Normal,Delete", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",N,D") [ SqlColumnNumber = 9, SqlFieldName = DPRL_Status ];

Property DPRLUpdateUserID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DPRL_UpdateUserID ];

Property DPRLUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = DPRL_UpdateDate ];

Property DPRLUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = DPRL_UpdateTime ];

Property DPRLLoc As %String [ SqlColumnNumber = 13, SqlFieldName = DPRL_Loc ];

Property DPRLUpdateLoc As %String [ SqlColumnNumber = 14, SqlFieldName = DPRL_UpdateLoc ];

Storage SQLStorage
{
<SQLMap name="IndexObjID">
<Global>^DHCAntCVReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_AntCVReport.DPRP_Type</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHC_AntCVReport.DPRP_LabNo</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>DHC_AntCVReport.DPRP_Order</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>DPRL_Order</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LKOBJID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DPRL_ObjID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DPRL_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_AntCVReport.DPRP_Type}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_AntCVReport.DPRP_LabNo}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHC_AntCVReport.DPRP_Order}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DPRL_Order}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCAntCVReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_AntCVReport.DPRP_Type</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_AntCVReport.DPRP_LabNo</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DHC_AntCVReport.DPRP_Order</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>DPRL_Order</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LKTYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_AntCVReport.DPRP_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AntCVReport.DPRP_LabNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_AntCVReport.DPRP_Order}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DPRL_Type}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DPRL_Order}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Map1">
<Data name="DPRL_Date">
<Delimiter>"\"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DPRL_Loc">
<Delimiter>"\"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DPRL_ObjID">
<Delimiter>"\"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DPRL_OtherInfo">
<Delimiter>"\"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DPRL_Status">
<Delimiter>"\"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DPRL_Time">
<Delimiter>"\"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DPRL_Type">
<Delimiter>"\"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DPRL_UpdateDate">
<Delimiter>"\"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DPRL_UpdateLoc">
<Delimiter>"\"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DPRL_UpdateTime">
<Delimiter>"\"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DPRL_UpdateUserID">
<Delimiter>"\"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DPRL_UserID">
<Delimiter>"\"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAntCVReport</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AntCVReport.DPRP_Type</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DHC_AntCVReport.DPRP_LabNo</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L3}</Expression>
<Field>DHC_AntCVReport.DPRP_Order</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L5}</Expression>
<Field>DPRL_Order</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AntCVReport.DPRP_Type}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_AntCVReport.DPRP_LabNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_AntCVReport.DPRP_Order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"LK"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DPRL_Order}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAntCVReportLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
