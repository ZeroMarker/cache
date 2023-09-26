Class User.DHCEQCComponent Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = C_RowID, SqlTableName = DHC_EQCComponent, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// C_Name
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = C_Name ];

/// C_Caption
Property CCaption As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = C_Caption ];

/// C_CaptionStyle
Property CCaptionStyle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = C_CaptionStyle ];

/// C_ClassName
Property CClassName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = C_ClassName ];

/// C_QueryName
Property CQueryName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = C_QueryName ];

/// C_Template
Property CTemplate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = C_Template ];

/// C_Specification
Property CSpecification As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = C_Specification ];

/// C_Remark
Property CRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = C_Remark ];

/// C_LastUpdateDate
Property CLastUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = C_LastUpdateDate ];

/// C_LastUpdateTime
Property CLastUpdateTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = C_LastUpdateTime ];

/// C_LastUpdateUserDR
Property CLastUpdateUserDR As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = C_LastUpdateUserDR ];

/// C_InvalidFlag
Property CInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = C_InvalidFlag ];

/// C_SysFlag
Property CSysFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = C_SysFlag ];

/// C_ValueItemDR
Property CValueItemDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = C_ValueItemDR ];

/// C_DescItemDR
Property CDescItemDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = C_DescItemDR ];

/// C_DefaultSize
Property CDefaultSize As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = C_DefaultSize ];

/// C_Hold5
Property CHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = C_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCComponent",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="C_Caption">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="C_CaptionStyle">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="C_ClassName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="C_DefaultSize">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="C_DescItemDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="C_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="C_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="C_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="C_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="C_LastUpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="C_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="C_QueryName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="C_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="C_Specification">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="C_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="C_Template">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="C_ValueItemDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>C_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCComponent"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{C_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>C_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCComponent"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{C_Name}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{C_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCComponentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
