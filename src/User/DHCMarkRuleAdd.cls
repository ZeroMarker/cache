Class User.DHCMarkRuleAdd Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MRA_RowID, SqlTableName = DHC_MarkRuleAdd, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MRAChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MarkRule Parent Reference
Relationship MRAMRParref As User.DHCMarkRule [ Cardinality = parent, Inverse = ChildDHCMarkRuleAdd, Required, SqlFieldName = MRA_MR_Parref ];

/// MRA_ChildSub
Property MRAChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = MRA_ChildSub ];

/// MRA_Code
Property MRACode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MRA_Code ];

/// MRA_Desc
Property MRADesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MRA_Desc ];

/// MRA_MinRp
Property MRAMinRp As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = MRA_MinRp ];

/// MRA_MaxRp
Property MRAMaxRp As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = MRA_MaxRp ];

/// MRA_Margin
Property MRAMargin As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = MRA_Margin ];

/// MRA_Remark
Property MRARemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MRA_Remark ];

/// MRA_UseFlag
Property MRAUseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = MRA_UseFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="MRA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRA_Margin">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRA_MaxRp">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRA_MinRp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MRA_UseFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCINMRA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MarkRule.MR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MRA_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MarkRule.MR_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRA_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMarkRuleAddS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
