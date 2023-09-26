Class User.DHCEQOperateLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OL_RowID, SqlTableName = DHC_EQOperateLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OL_SourceType
Property OLSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = OL_SourceType ];

/// OL_SourceID
Property OLSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = OL_SourceID ];

/// OL_OperateFlag
Property OLOperateFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OL_OperateFlag ];

/// OL_Times
Property OLTimes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = OL_Times ];

/// OL_Date
Property OLDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = OL_Date ];

/// OL_Time
Property OLTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = OL_Time ];

/// OL_User
Property OLUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = OL_User ];

/// OL_Remark
Property OLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = OL_Remark ];

/// OL_OperateState
Property OLOperateState As %Library.String(DISPLAYLIST = ",保存,提交,审核,作废,审批,取消提交", MAXLEN = 2, SELECTIVITY = "14.2857%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4,5") [ SqlColumnNumber = 10, SqlFieldName = OL_OperateState ];

/// OL_AppendInfo
Property OLAppendInfo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = OL_AppendInfo ];

/// OL_Hold1
Property OLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = OL_Hold1 ];

/// OL_Hold2
Property OLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = OL_Hold2 ];

/// OL_Hold3
Property OLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = OL_Hold3 ];

/// OL_Hold4
Property OLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = OL_Hold4 ];

/// OL_Hold5
Property OLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = OL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQOperateLog("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OL_AppendInfo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OL_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OL_OperateFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OL_OperateState">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OL_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OL_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OL_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OL_Times">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OL_User">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQOperateLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexkSource">
<Global>^DHCEQOperateLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OL_OperateFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OL_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OL_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{OL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQOperateLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
