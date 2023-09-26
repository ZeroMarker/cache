Class User.DHCRBResource Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = RES_RowId, SqlTableName = DHC_RBResource, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On RESRowId [ IdKey, PrimaryKey, Unique ];

/// RES_AddLoad
Property RESAddLoad As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = RES_AddLoad ];

/// RES_AppLoad
Property RESAppLoad As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = RES_AppLoad ];

/// RES_AppStartNum
Property RESAppStartNum As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = RES_AppStartNum ];

/// AS_ClinicGroup_DR
Property RESClinicGroupDR As User.RBCClinicGroup [ SqlColumnNumber = 3, SqlFieldName = RES_ClinicGroup_DR ];

/// RES_DiagnosCatStr
Property RESDiagnosCatStr As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = RES_DiagnosCatStr ];

/// RES_EPMarkFlag
Property RESEPMarkFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = RES_EPMarkFlag ];

/// Retire
Property RESFeeType As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = RES_FeeType ];

/// RES_Load
Property RESLoad As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = RES_Load ];

/// RES_ReAdmFeeFlag
Property RESReAdmFeeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = RES_ReAdmFeeFlag ];

/// RES RowID
Property RESRowId As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlFieldName = RES_RowId ];

/// RES_SessionType_DR
Property RESSessionTypeDR As User.RBCSessionType [ SqlColumnNumber = 2, SqlFieldName = RES_SessionType_DR ];

/// RES_ChildAge
Property RESChildAge As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = RES_ChildAge ];

/// RES_ShareGroup
Property RESShareGroup As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = RES_ShareGroup ];

/// RES_ShareInputItemCat
Property RESShareInputItemCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = RES_ShareInputItemCat ];

/// RESTimeRangeFlag
Property RESTimeRangeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = RES_TimeRangeFlag ];

/// RESTimeRangeLength
Property RESTimeRangeLength As %Integer [ SqlColumnNumber = 16, SqlFieldName = RES_TimeRangeLength ];

/// RESTimeRangeRegNum
Property RESTimeRangeRegNum As %Integer [ SqlColumnNumber = 17, SqlFieldName = RES_TimeRangeRegNum ];

/// RES_AllowGetSeqNoFlag
Property RESAllowGetSeqNoFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = RES_AllowGetSeqNoFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="RES_AddLoad">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>6</Piece>
</Data>
<Data name="RES_AllowGetSeqNoFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>18</Piece>
</Data>
<Data name="RES_AppLoad">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>4</Piece>
</Data>
<Data name="RES_AppStartNum">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>5</Piece>
</Data>
<Data name="RES_ChildAge">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>12</Piece>
</Data>
<Data name="RES_ClinicGroup_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="RES_DiagnosCatStr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>7</Piece>
</Data>
<Data name="RES_EPMarkFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>11</Piece>
</Data>
<Data name="RES_FeeType">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>10</Piece>
</Data>
<Data name="RES_Load">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Data name="RES_ReAdmFeeFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>9</Piece>
</Data>
<Data name="RES_SessionType_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Data name="RES_ShareGroup">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>13</Piece>
</Data>
<Data name="RES_ShareInputItemCat">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>14</Piece>
</Data>
<Data name="RES_TimeRangeFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>15</Piece>
</Data>
<Data name="RES_TimeRangeLength">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>16</Piece>
</Data>
<Data name="RES_TimeRangeRegNum">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>17</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RES_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RES_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RES_RowId</SqlRowIdName>
<StreamLocation>^User.DHCRBResourceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
