Class User.DHCMRDiagnosICD Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCMRDiaICD_Rowid, SqlTableName = DHC_MRDiagnosICD, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCMRDiaICD_ICDDR
Property DHCMRDiaICDICDDR As User.MRCICDDx [ SqlColumnNumber = 3, SqlFieldName = DHCMRDiaICD_ICDDR ];

/// DHCMRDiaICD_ListIndex
Property DHCMRDiaICDListIndex As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DHCMRDiaICD_ListIndex ];

/// DHCMRDiaICD_ListNum
Property DHCMRDiaICDListNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DHCMRDiaICD_ListNum ];

/// DHCMRDiaICD_MASTERDR
Property DHCMRDiaICDMASTERDR As User.DHCMRDiagnosMaster [ SqlColumnNumber = 2, SqlFieldName = DHCMRDiaICD_MASTERDR ];

/// DHCMRDiaICD_Desc
Property DHCMRDiaICDDesc As %String [ SqlColumnNumber = 6, SqlFieldName = DHCMRDiaICD_Desc ];

/// 因为证型有多个，也有可能存在非标准证型，每个证型以$C(2)分割
Property DHCMRDiaICDSyndromeICDInfo As %String [ SqlColumnNumber = 7, SqlFieldName = DHCMRDiaICD_SyndromeICDInfo ];

/// ICD诊断备注
Property DHCMRDiaICDNotes As %String [ SqlColumnNumber = 8, SqlFieldName = DHCMRDiaICD_Notes ];

/// 结构化诊断中心词ID
Property DHCMRDiaICDSDSTermDR As %String [ SqlColumnNumber = 9, SqlFieldName = DHCMRDiaICD_SDSTermDR ];

/// I勾选属性内容对应的ID串
Property DHCMRDiaICDSDSDisplayIDStr As %String [ SqlColumnNumber = 10, SqlFieldName = DHCMRDiaICD_SDSDisplayIDStr ];

/// 诊断类型
Property DHCMRDiaICDType As %Integer [ SqlColumnNumber = 11, SqlFieldName = DHCMRDiaICD_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDIAICD)</SqlIdExpression>
<SQLMap name="DHCMRDIAMASTERINDEX">
<Global>^DHCDIAICD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCMRDiaICD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"MASTER"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCMRDiaICD_MASTERDR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCMRDiaICD_ListNum}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCMRDiaICD_ListIndex}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHCMRDiaICD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DHCMRDiagnosICDDATA">
<Data name="DHCMRDiaICD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCMRDiaICD_ICDDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCMRDiaICD_ListIndex">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCMRDiaICD_ListNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCMRDiaICD_MASTERDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCMRDiaICD_Notes">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCMRDiaICD_Rowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCMRDiaICD_SDSDisplayIDStr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCMRDiaICD_SDSTermDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCMRDiaICD_SyndromeICDInfo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCMRDiaICD_Type">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCDIAICD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCMRDiaICD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCMRDiaICD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMRDiagnosICDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
