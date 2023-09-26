Class User.DHCEQCMaintItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MI_RowID, SqlTableName = DHC_EQCMaintItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MI_Code
Property MICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MI_Code ];

/// MI_Desc
Property MIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MI_Desc ];

/// MI_Remark
Property MIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MI_Remark ];

/// MI_InvalidFlag
Property MIInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = MI_InvalidFlag ];

/// MI_Type
Property MIType As %Library.String(DISPLAYLIST = ",保养,检查,维修", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",1,2,3") [ SqlColumnNumber = 6, SqlFieldName = MI_Type ];

/// MI_Caption
Property MICaption As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MI_Caption ];

/// MI_ItemCatDR
Property MIItemCatDR As User.DHCEQCMaintItemCat [ SqlColumnNumber = 8, SqlFieldName = MI_ItemCatDR ];

/// MI_Note
Property MINote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MI_Note ];

/// MI_DateType
Property MIDateType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MI_DateType ];

/// MI_DisplayType
Property MIDisplayType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MI_DisplayType ];

/// MI_Qualitative
Property MIQualitative As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MI_Qualitative ];

/// MI_SettingFlag
Property MISettingFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = MI_SettingFlag ];

/// MI_MultiChoiceFlag
Property MIMultiChoiceFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = MI_MultiChoiceFlag ];

/// MI_Hold4
Property MIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MI_Hold4 ];

/// MI_Hold5
Property MIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MI_Hold5 ];

/// MI_Hold6
Property MIHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = MI_Hold6 ];

/// MI_Hold7
Property MIHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = MI_Hold7 ];

/// MI_Hold8
Property MIHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = MI_Hold8 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCMaintItem",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MI_Caption">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MI_DateType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MI_DisplayType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MI_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MI_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MI_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MI_ItemCatDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MI_MultiChoiceFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MI_Note">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MI_Qualitative">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MI_SettingFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MI_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCMaintItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{MI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItemcatDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{MI_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCMaintItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ItemcatDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MI_ItemcatDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCMaintItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
