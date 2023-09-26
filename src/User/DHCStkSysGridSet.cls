Class User.DHCStkSysGridSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GS_RowId, SqlTableName = DHC_StkSysGridSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On GSChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_StkSysApp Parent Reference
Relationship GSSSAParRef As User.DHCStkSysApp [ Cardinality = parent, Inverse = ChildDHCStkSysGridSet, Required, SqlFieldName = GS_SSA_ParRef ];

/// GS_ChildSub
Property GSChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = GS_ChildSub ];

/// GS_GridID
Property GSGridID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = GS_GridID ];

/// GS_SaveFor
Property GSSaveFor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = GS_SaveFor ];

/// GS_Key
Property GSKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = GS_Key ];

/// GS_Name
Property GSName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = GS_Name ];

/// GS_Header
Property GSHeader As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = GS_Header ];

/// GS_Width
Property GSWidth As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = GS_Width ];

/// GS_Alignment
Property GSAlignment As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = GS_Alignment ];

/// GS_Format
Property GSFormat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = GS_Format ];

/// GS_EditMask
Property GSEditMask As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = GS_EditMask ];

/// GS_ComboList
Property GSComboList As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = GS_ComboList ];

/// GS_DataType
Property GSDataType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = GS_DataType ];

/// GS_Hidden
Property GSHidden As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = GS_Hidden ];

/// GS_Modi
Property GSModi As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = GS_Modi ];

/// GS_Necessary
Property GSNecessary As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = GS_Necessary ];

/// GS_SysFlag
Property GSSysFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = GS_SysFlag ];

/// GS_Order
Property GSOrder As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = GS_Order ];

/// GS_SSL_DR
Property GSSSLDR As User.DHCStkSysLibrary [ SqlColumnNumber = 19, SqlFieldName = GS_SSL_DR ];

/// GS_Print
Property GSPrint As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = GS_Print ];

/// GS_SSP_DR
Property GSSSPDR As User.DHCStkSysPerview [ SqlColumnNumber = 21, SqlFieldName = GS_SSP_DR ];

/// GS_Reference
Property GSReference As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = GS_Reference ];

/// GS_CspName
Property GSCspName As %String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = GS_CspName ];

/// GS_Sortable
Property GSSortable As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = GS_Sortable ];

/// GS_EnterSort
Property GSEnterSort As %Library.Integer [ SqlColumnNumber = 25, SqlFieldName = GS_EnterSort ];

/// GS_IFCopy
Property GSIFCopy As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = GS_IFCopy ];

/// GS_IFExport
Property GSIFExport As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = GS_IFExport ];

/// GS_Frozen
Property GSFrozen As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = GS_Frozen ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="GS_Alignment">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GS_ComboList">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="GS_CspName">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="GS_DataType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="GS_EditMask">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GS_EnterSort">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="GS_Format">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GS_Frozen">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="GS_GridID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GS_Header">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GS_Hidden">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="GS_IFCopy">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="GS_IFExport">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="GS_Key">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GS_Modi">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="GS_Name">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GS_Necessary">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="GS_Order">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="GS_Print">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="GS_Reference">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="GS_SSL_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="GS_SSP_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="GS_SaveFor">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GS_Sortable">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="GS_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="GS_Width">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCSSA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>GS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"GS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GS_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGrid">
<Global>^DHCSSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>GS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"GRID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{GS_GridID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{GS_SaveFor}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{GS_Reference}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({GS_CspName})</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{GS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkSysGridSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
