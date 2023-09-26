Class User.DHCEQCCounter Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CNT_RowID, SqlTableName = DHC_EQCCounter, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index CNTTypeDRUnqIdx1 On CNTTypeDR [ Unique ];

/// CNT_CounterNum
Property CNTCounterNum As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = CNT_CounterNum ];

/// CNT_Group
Property CNTGroup As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CNT_Group ];

/// CNT_GroupFlag
Property CNTGroupFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = CNT_GroupFlag ];

/// CNT_Hold1
Property CNTHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CNT_Hold1 ];

/// CNT_Hold2
Property CNTHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CNT_Hold2 ];

/// CNT_Hold3
Property CNTHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CNT_Hold3 ];

/// CNT_Length
Property CNTLength As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CNT_Length ];

/// CNT_Prefix
Property CNTPrefix As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CNT_Prefix ];

/// CNT_Suffix
Property CNTSuffix As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CNT_Suffix ];

/// CNT_TypeDR
Property CNTTypeDR As User.DHCEQCCounterType [ SqlColumnNumber = 3, SqlFieldName = CNT_TypeDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCCounter",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CNT_CounterNum">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CNT_Group">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CNT_GroupFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CNT_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CNT_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CNT_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CNT_Length">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CNT_Prefix">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CNT_Suffix">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CNT_TypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CNT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCCounter"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CNT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CNT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCCounter"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CNT_TypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CNT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCCounterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
