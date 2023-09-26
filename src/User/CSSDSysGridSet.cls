Class User.CSSDSysGridSet Extends (%Persistent, User.Abstract) [ SqlRowIdName = GS_RowId, SqlTableName = CSSD_SysGridSet ]
{

Parameter EXTENTSIZE = 250;

Property GSGridID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = GS_GridID ];

Property GSSaveFor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = GS_SaveFor ];

Property GSKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = GS_Key ];

Property GSName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = GS_Name ];

Property GSHeader As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = GS_Header ];

Property GSWidth As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = GS_Width ];

Property GSAlignment As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = GS_Alignment ];

Property GSFormat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = GS_Format ];

Property GSEditMask As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = GS_EditMask ];

Property GSComboList As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = GS_ComboList ];

Property GSDataType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = GS_DataType ];

Property GSHidden As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = GS_Hidden ];

Property GSModi As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = GS_Modi ];

Property GSNecessary As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = GS_Necessary ];

Property GSSysFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = GS_SysFlag ];

Property GSOrder As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = GS_Order ];

Property GSSSLDR As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 18, SqlFieldName = GS_SSL_DR ];

Property GSPrint As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = GS_Print ];

Property GSSSPDR As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 20, SqlFieldName = GS_SSP_DR ];

Property GSReference As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = GS_Reference ];

Property GSCspName As %String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = GS_CspName ];

Property GSSortable As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = GS_Sortable ];

Property GSEnterSort As %Library.Integer [ SqlColumnNumber = 24, SqlFieldName = GS_EnterSort ];

Property GSIFCopy As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = GS_IFCopy ];

Property GSIFExport As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = GS_IFExport ];

Property GSFrozen As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = GS_Frozen ];

Index IndexGrid On (GSGridID As Exact, GSSaveFor As Exact, GSReference As Exact, GSCspName As Exact);

Storage Default
{
<Data name="CSSDSysGridSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GSGridID</Value>
</Value>
<Value name="3">
<Value>GSSaveFor</Value>
</Value>
<Value name="4">
<Value>GSKey</Value>
</Value>
<Value name="5">
<Value>GSName</Value>
</Value>
<Value name="6">
<Value>GSHeader</Value>
</Value>
<Value name="7">
<Value>GSWidth</Value>
</Value>
<Value name="8">
<Value>GSAlignment</Value>
</Value>
<Value name="9">
<Value>GSFormat</Value>
</Value>
<Value name="10">
<Value>GSEditMask</Value>
</Value>
<Value name="11">
<Value>GSComboList</Value>
</Value>
<Value name="12">
<Value>GSDataType</Value>
</Value>
<Value name="13">
<Value>GSHidden</Value>
</Value>
<Value name="14">
<Value>GSModi</Value>
</Value>
<Value name="15">
<Value>GSNecessary</Value>
</Value>
<Value name="16">
<Value>GSSysFlag</Value>
</Value>
<Value name="17">
<Value>GSOrder</Value>
</Value>
<Value name="18">
<Value>GSSSLDR</Value>
</Value>
<Value name="19">
<Value>GSPrint</Value>
</Value>
<Value name="20">
<Value>GSSSPDR</Value>
</Value>
<Value name="21">
<Value>GSReference</Value>
</Value>
<Value name="22">
<Value>GSCspName</Value>
</Value>
<Value name="23">
<Value>GSSortable</Value>
</Value>
<Value name="24">
<Value>GSEnterSort</Value>
</Value>
<Value name="25">
<Value>GSIFCopy</Value>
</Value>
<Value name="26">
<Value>GSIFExport</Value>
</Value>
<Value name="27">
<Value>GSFrozen</Value>
</Value>
</Data>
<DataLocation>^User.CSSDSysGridSetD</DataLocation>
<DefaultData>CSSDSysGridSetDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.CSSDSysGridSetD</IdLocation>
<IndexLocation>^User.CSSDSysGridSetI</IndexLocation>
<SqlRowIdName>GS_RowId</SqlRowIdName>
<StreamLocation>^User.CSSDSysGridSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
