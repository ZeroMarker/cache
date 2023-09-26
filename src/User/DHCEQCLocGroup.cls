Class User.DHCEQCLocGroup Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LG_RowID, SqlTableName = DHC_EQCLocGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// LG_Code
Property LGCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = LG_Code ];

/// LG_Desc
Property LGDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = LG_Desc ];

/// LG_Remark
Property LGRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LG_Remark ];

/// LG_UniqueFlag
Property LGUniqueFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = LG_UniqueFlag ];

/// LG_HiddenFlag
Property LGHiddenFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = LG_HiddenFlag ];

/// LG_ReadOnly
Property LGReadOnly As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = LG_ReadOnly ];

/// LG_InvalidFlag
Property LGInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = LG_InvalidFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCLocGroup",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LG_HiddenFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LG_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LG_ReadOnly">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LG_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LG_UniqueFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>LG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCLocGroup"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{LG_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCLocGroup"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{LG_Code}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{LG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCLocGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
