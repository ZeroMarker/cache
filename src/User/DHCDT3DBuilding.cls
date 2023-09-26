Class User.DHCDT3DBuilding Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = B_RowID, SqlTableName = DHC_DT3DBuilding, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// B_Code
Property BCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = B_Code ];

/// B_Name
Property BName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = B_Name ];

/// B_Description
Property BDescription As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = B_Description ];

/// B_3DBuildID
Property B3DBuildID As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = B_3DBuildID ];

/// B_BuildingExID
Property BBuildingExID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = B_BuildingExID ];

/// B_BuildingArea
Property BBuildingArea As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = B_BuildingArea ];

/// B_UtilizationArea
Property BUtilizationArea As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = B_UtilizationArea ];

/// B_SubArea
Property BSubArea As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = B_SubArea ];

/// B_Place
Property BPlace As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = B_Place ];

/// B_OwnerCertificate
Property BOwnerCertificate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = B_OwnerCertificate ];

/// B_CertificateNo
Property BCertificateNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = B_CertificateNo ];

/// B_CertificateDate
Property BCertificateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = B_CertificateDate ];

/// B_FloorNum
Property BFloorNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = B_FloorNum ];

/// B_UnderFloorNum
Property BUnderFloorNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = B_UnderFloorNum ];

/// B_UseState
Property BUseState As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = B_UseState ];

/// B_FunctionCat
Property BFunctionCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = B_FunctionCat ];

/// B_FunctionSub
Property BFunctionSub As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = B_FunctionSub ];

/// B_OwnerKind
Property BOwnerKind As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = B_OwnerKind ];

/// B_ActiveFlag
Property BActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = B_ActiveFlag ];

/// B_Remark
Property BRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = B_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDT3DBuildUnit("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="B_3DBuildID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="B_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="B_BuildingArea">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="B_BuildingExID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="B_CertificateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="B_CertificateNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="B_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="B_Description">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="B_FloorNum">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="B_FunctionCat">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="B_FunctionSub">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="B_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="B_OwnerCertificate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="B_OwnerKind">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="B_Place">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="B_Remark">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="B_SubArea">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="B_UnderFloorNum">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="B_UseState">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="B_UtilizationArea">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCDT3DBuilding</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{B_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Index3DBuildID">
<Global>^DHCDT3DBuilding</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuildID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_3DBuildID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDT3DBuildUnitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
