Class User.DHCPHMonitorRecLabel Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlRowIdName = PHMRL_RowID, SqlTableName = DHC_PHMonitorRecLabel, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PHMRLChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PHMRLParRefDr As User.DHCPHMonitorRecord [ Cardinality = parent, Inverse = ChildDHCPHMonitorRecLabel, Required, SqlFieldName = PHMRL_ParRef_Dr ];

Property PHMRLChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHMRL_ChildSub ];

/// PHMRL_Label_Dr	目录id
Property PHMRLLabelDr As %String [ SqlColumnNumber = 3, SqlFieldName = PHMRL_Label_Dr ];

/// PHMRL_ErrFlag	错误标志
Property PHMRLErrFlag As %String [ SqlColumnNumber = 4, SqlFieldName = PHMRL_ErrFlag ];

/// PHMRL_ErrMsg	错误原因
Property PHMRLErrMsg As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = PHMRL_ErrMsg ];

/// PHMRL_TrueMsg	正确原因
Property PHMRLTrueMsg As %Library.String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = PHMRL_TrueMsg ];

/// PHMR_LinkOeor_Dr 关联医嘱id
Property PHMRLinkOeorDr As User.OEOrdItem [ SqlColumnNumber = 7, SqlFieldName = PHMR_LinkOeor_Dr ];

/// PHMRL_LinkOeSeqNo 关联医嘱序号
Property PHMRLLinkOeSeqNo As %String [ SqlColumnNumber = 8, SqlFieldName = PHMRL_LinkOeSeqNo ];

/// PHMRL_LinkArci 关联医嘱的医嘱项id
Property PHMRLLinkArci As User.ARCItmMast [ SqlColumnNumber = 9, SqlFieldName = PHMRL_LinkArci ];

/// PHMRL_LabelLevel 管理级别
Property PHMRLLabelLevel As %String [ SqlColumnNumber = 10, SqlFieldName = PHMRL_LabelLevel ];

Storage SQLStorage
{
<SQLMap name="Mapster">
<Data name="PHMRL_ErrFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMRL_ErrMsg">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMRL_LabelLevel">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHMRL_Label_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMRL_LinkArci">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHMRL_LinkOeSeqNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHMRL_TrueMsg">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHMR_LinkOeor_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHMREC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHMonitorRecord.PHMR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHMRL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHMonitorRecord.PHMR_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Label"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMRL_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMonitorRecLabelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
