/// 记录危机值报告所属就诊及科室变化记录
Class User.DHCAntCVReportAdmLog Extends %Persistent [ SqlRowIdName = DPRAL_RowID, SqlTableName = DHC_AntCVReportAdmLog, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DPRALOrder [ IdKey, PrimaryKey, Unique ];

Relationship DPRALParRef As User.DHCAntCVReport [ Cardinality = parent, Inverse = ChildDHCAntCVReportAdmLog, SqlFieldName = DPRAL_ParRef ];

/// DPRAL_Order
Property DPRALOrder As %Integer [ SqlColumnNumber = 2, SqlFieldName = DPRAL_Order ];

/// 类型 转科 转诊
Property DPRALType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DPRAL_Type ];

/// 原状态
Property DPRALSrcProcess As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DPRAL_SrcProcess ];

/// 原就诊
Property DPRALSrcAdm As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DPRAL_SrcAdm ];

/// 原科室
Property DPRALSrcLoc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DPRAL_SrcLoc ];

/// 原病区
Property DPRALSrcWard As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DPRAL_SrcWard ];

/// 新就诊
Property DPRALDestAdm As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DPRAL_DestAdm ];

/// 新科室
Property DPRALDestLoc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DPRAL_DestLoc ];

/// 新病区
Property DPRALDestWard As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DPRAL_DestWard ];

/// 操作人
Property DPRALUserID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DPRAL_UserID ];

/// 操作日期
Property DPRALDate As %Date [ SqlColumnNumber = 12, SqlFieldName = DPRAL_Date ];

/// 操作时间
Property DPRALTime As %Time [ SqlColumnNumber = 13, SqlFieldName = DPRAL_Time ];

Storage SQLStorage
{
<SQLMap name="Map1">
<Data name="DPRAL_Date">
<Delimiter>"\"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DPRAL_DestAdm">
<Delimiter>"\"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DPRAL_DestLoc">
<Delimiter>"\"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DPRAL_DestWard">
<Delimiter>"\"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DPRAL_SrcAdm">
<Delimiter>"\"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DPRAL_SrcLoc">
<Delimiter>"\"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DPRAL_SrcProcess">
<Delimiter>"\"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DPRAL_SrcWard">
<Delimiter>"\"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DPRAL_Time">
<Delimiter>"\"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DPRAL_Type">
<Delimiter>"\"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DPRAL_UserID">
<Delimiter>"\"</Delimiter>
<Piece>9</Piece>
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
<Field>DPRAL_Order</Field>
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
<Expression>"AdmLog"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DPRAL_Order}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAntCVReportAdmLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
