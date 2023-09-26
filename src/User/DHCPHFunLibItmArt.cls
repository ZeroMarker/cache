Class User.DHCPHFunLibItmArt Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PH_RowID, SqlTableName = DHC_PHFunLibItmArt, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHFunLibItem Parent Reference PH_PHFLI_Parref
Relationship PHPHFLIParref As User.DHCPHFunLibItem [ Cardinality = parent, Inverse = ChildDHCPHFUNLIBITMART, Required, SqlFieldName = PH_PHFLI_Parref ];

/// PH_ChildSub
Property PHChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PH_ChildSub ];

/// PH_MonItmCode 
Property PHMonItmCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PH_MonItmCode ];

/// PH_MinVal 
Property PHMinVal As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PH_MinVal ];

/// PH_MaxVal 
Property PHMaxVal As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PH_MaxVal ];

/// PH_Sex
Property PHSex As User.CTSex [ SqlColumnNumber = 6, SqlFieldName = PH_Sex ];

/// PH_AGE_MinVal 
Property PHAGEMinVal As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PH_AGE_MinVal ];

/// PH_AGE_MaxVal 
Property PHAGEMaxVal As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PH_AGE_MaxVal ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PH_AGE_MaxVal">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PH_AGE_MinVal">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PH_MaxVal">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PH_MinVal">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PH_MonItmCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PH_Sex">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHFULITM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHFunLibItem.PHFLI_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PH_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHFunLibItem.PHFLI_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PH_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHFunLibItmArtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
