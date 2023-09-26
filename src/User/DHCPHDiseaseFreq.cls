/// 名称: 药品业务表 2用药频率维护
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2014-12-2
Class User.DHCPHDiseaseFreq Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PDF_RowId, SqlTableName = DHC_PHDiseaseFreq, StorageStrategy = SQLStorage ]
{

/// PDF_RowId  ^DHCPHDISFR
Property PDFInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PDF_Inst_Dr ];

Property PDFFreqDR As DHCPHExtFreq [ SqlColumnNumber = 3, SqlFieldName = PDF_Freq_DR ];

Property PDFExcludeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PDF_ExcludeFlag ];

/// PDF_AlertMsg  2016/10/13
Property PDFAlertMsg As %String [ SqlColumnNumber = 5, SqlFieldName = PDF_AlertMsg ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHDISFR(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDF_AlertMsg">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDF_ExcludeFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDF_Freq_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDF_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHDISFR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PRF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PDF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCPHDISFR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDF_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDF_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDiseaseFreqS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
