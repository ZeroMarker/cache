Class User.DHCAppRepPart Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AR_RowID, SqlTableName = DHC_AppRepPart, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ARChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppRepArc Parent Reference AR_ParRef_Dr
Relationship ARParRefDr As User.DHCAppRepArc [ Cardinality = parent, Inverse = ChildDHCAPPREPPART, Required, SqlFieldName = AR_ParRef_Dr ];

/// AR_ChildSub
Property ARChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AR_ChildSub ];

/// 子部位  AR_Part_Dr 
Property ARPartDr As User.DHCAppPart [ SqlColumnNumber = 3, SqlFieldName = AR_Part_Dr ];

/// 执行状态  AR_ExeStatus 
Property ARExeStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AR_ExeStatus ];

/// 停止日期  AR_XDate
Property ARXDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = AR_XDate ];

/// 停止时间  AR_XTime
Property ARXTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = AR_XTime ];

/// 停止人  AR_XUser
Property ARXUser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = AR_XUser ];

/// 退费申请表状态  AR_RefReqFlag
Property ARRefReqFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AR_RefReqFlag ];

/// 执行记录ID  AR_OrdExec_Dr
Property AROrdExecDr As User.OEOrdExecExt [ SqlColumnNumber = 9, SqlFieldName = AR_OrdExec_Dr ];

/// 备注  AR_Remark 
Property ARRemark As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AR_Remark ];

/// 附加医嘱信息 医嘱项id|||数量|||是否手工绑定&医嘱项id|||数量|||是否手工绑定&。。。。
Property ARAppendOrderStr As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AR_AppendOrderStr ];

/// 附加医嘱 医嘱id&医嘱id..
Property ARAppendOEOrderStr As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AR_AppendOEOrderStr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AR_AppendOEOrderStr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AR_AppendOrderStr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AR_ExeStatus">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AR_OrdExec_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AR_Part_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AR_RefReqFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AR_XDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AR_XTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AR_XUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCAPREP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AppReport.AR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_AppRepArc.AR_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>AR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppReport.AR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_AppRepArc.AR_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"PA"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPart">
<Global>^DHCAPREP</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_AppReport.AR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_AppRepArc.AR_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>AR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Part"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_Part_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AppReport.AR_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_AppRepArc.AR_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppRepPartS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
