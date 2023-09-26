Class User.DHCEQUsedResourceItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = URI_RowID, SqlTableName = DHC_EQUsedResourceItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// URI_UsedResourceDR
Property URIUsedResourceDR As User.DHCEQUsedResource [ SqlColumnNumber = 2, SqlFieldName = URI_UsedResourceDR ];

/// URI_ResourceTypeDR
Property URIResourceTypeDR As User.DHCEQCResourceType [ SqlColumnNumber = 3, SqlFieldName = URI_ResourceTypeDR ];

/// URI_UsedFee
Property URIUsedFee As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = URI_UsedFee ];

/// URI_Remark
Property URIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = URI_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQUsedResourceItem("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="URI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="URI_ResourceTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="URI_UsedFee">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="URI_UsedResourceDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQUsedResourceItem</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>URI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{URI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQUsedResourceItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
