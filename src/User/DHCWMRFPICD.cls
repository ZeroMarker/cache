Class User.DHCWMRFPICD Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DHC_WMR_FPICD, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// FrontPageDr
Property FrontPageDr As User.DHCWMRFrontPage [ SqlColumnNumber = 2 ];

/// ICDDr
Property ICDDr As User.DHCWMRICDDx [ SqlColumnNumber = 3 ];

/// Result
Property Result As User.DHCWMRDictionary [ SqlColumnNumber = 4 ];

/// Operator
Property Operator As User.SSUser [ SqlColumnNumber = 5 ];

/// AssistantDr1
Property AssistantDr1 As User.SSUser [ SqlColumnNumber = 6 ];

/// AssistantDr2
Property AssistantDr2 As User.SSUser [ SqlColumnNumber = 7 ];

/// NarcosisType
Property NarcosisType As User.DHCWMRDictionary [ SqlColumnNumber = 8 ];

/// NarcosisDoctorDr
Property NarcosisDoctorDr As User.SSUser [ SqlColumnNumber = 9 ];

/// CloseUp
Property CloseUp As User.DHCWMRDictionary [ SqlColumnNumber = 10 ];

/// ItemTypeDr
Property ItemTypeDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

/// Pos
Property Pos As %Library.Float [ SqlColumnNumber = 12 ];

/// ResumeText
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

/// OperDate
Property OperDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14 ];

/// FPICDTypeDr
Property FPICDTypeDr As User.DHCWMRDictionary [ SqlColumnNumber = 15 ];

/// Source Type:Src Dic Type Table
Property SrcType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

/// Text1
Property Text1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

/// Text2
Property Text2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18 ];

/// Text3
Property Text3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19 ];

/// Text4
Property Text4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMRFPICD)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="AssistantDr1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AssistantDr2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CloseUp">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="FPICDTypeDr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="FrontPageDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICDDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ItemTypeDr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="NarcosisDoctorDr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NarcosisType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OperDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="Operator">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Pos">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="Result">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SrcType">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="Text1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="Text2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="Text3">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="Text4">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^DHCWMRFPICD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCodeDateTypeICD">
<Global>^DHCWMRFPICD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"CodeDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>##Class(web.DHCWMRFrontPageCtl).CodeDate({FrontPageDr})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ItemTypeDr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ICDDr}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFP">
<Global>^DHCWMRFPICD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{FrontPageDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexICDDr">
<Global>^DHCWMRFPICD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypeICDDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ItemTypeDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ICDDr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInDateTypeICD">
<Global>^DHCWMRFPICD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"InDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>##Class(web.DHCWMRFrontPageCtl).InDate({FrontPageDr})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ItemTypeDr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ICDDr}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutDateTypeICD">
<Global>^DHCWMRFPICD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OutDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>##Class(web.DHCWMRFrontPageCtl).OutDate({FrontPageDr})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ItemTypeDr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ICDDr}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRFPICDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
