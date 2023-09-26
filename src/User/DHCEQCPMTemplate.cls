Class User.DHCEQCPMTemplate Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PMT_RowID, SqlTableName = DHC_EQCPMTemplate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PMT_Type
Property PMTType As %Library.String(DISPLAYLIST = ",保养,检查,维修", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2,3") [ SqlColumnNumber = 2, SqlFieldName = PMT_Type ];

/// PMT_Name
Property PMTName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PMT_Name ];

/// PMT_Caption
Property PMTCaption As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PMT_Caption ];

/// PMT_Note
Property PMTNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PMT_Note ];

//Property PMTPreState As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PMT_PreState ];

//Property PMTState As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PMT_State ];

/// PMT_Remark
Property PMTRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PMT_Remark ];

/// PMT_FromDate
Property PMTFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PMT_FromDate ];

/// PMT_ToDate
Property PMTToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PMT_ToDate ];

/// PMT_Hold1
Property PMTHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PMT_Hold1 ];

/// PMT_Hold2
Property PMTHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PMT_Hold2 ];

/// PMT_Hold3
Property PMTHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PMT_Hold3 ];

/// PMT_InvalidFlag
Property PMTInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PMT_InvalidFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCPMTemplate",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PMT_Caption">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PMT_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PMT_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PMT_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PMT_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PMT_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PMT_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PMT_Note">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PMT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PMT_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PMT_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PMT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCPMTemplate"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{PMT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCPMTemplateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
