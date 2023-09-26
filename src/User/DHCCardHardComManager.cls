Class User.DHCCardHardComManager Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CCM_RowID, SqlTableName = DHC_CardHardComManager, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCCardHardDLLFunction As User.DHCCardHardDLLFunction [ Cardinality = children, Inverse = CDFCCMParRef ];

/// CCM_Code
Property CCMCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CCM_Code ];

/// CCM_Desc
Property CCMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CCM_Desc ];

/// CCM_ComGroup_DR
Property CCMComGroupDR As User.DHCCardHardComGroup [ SqlColumnNumber = 4, SqlFieldName = CCM_ComGroup_DR ];

/// CCM_CLASSID
Property CCMCLASSID As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CCM_CLASSID ];

/// CCM_OBJECTID
Property CCMOBJECTID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CCM_OBJECTID ];

/// CCM_Version
Property CCMVersion As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CCM_Version ];

/// CCM_CodeBase
Property CCMCodeBase As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CCM_CodeBase ];

/// CCM_EquipPort
Property CCMEquipPort As %Library.String(DISPLAYLIST = ",COM1,COM2,COM3,COM4,COM5,COM6", MAXLEN = 4, SELECTIVITY = "14.2857%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4,5") [ SqlColumnNumber = 9, SqlFieldName = CCM_EquipPort ];

/// CCM_JSFunctionName
Property CCMJSFunctionName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CCM_JSFunctionName ];

/// CCM_DLLFunctionName
Property CCMDLLFunctionName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CCM_DLLFunctionName ];

/// CCM_DLLInPara1
Property CCMDLLInPara1 As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CCM_DLLInPara1 ];

/// CCM_DLLInPara2
Property CCMDLLInPara2 As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CCM_DLLInPara2 ];

/// CCM_DLLInPara3
Property CCMDLLInPara3 As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CCM_DLLInPara3 ];

/// CCM_DateFrom
Property CCMDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = CCM_DateFrom ];

/// CCM_DateTo
Property CCMDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = CCM_DateTo ];

/// CCM_DLLType
Property CCMDLLType As %Library.String(DISPLAYLIST = ",COM Dll,Net Dll,Java COM,Local Service", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",CD,ND,JC,LS") [ SqlColumnNumber = 17, SqlFieldName = CCM_DLLType ];

/// CCM_Note2
Property CCMNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CCM_Note2 ];

/// CCM_Note3
Property CCMNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = CCM_Note3 ];

/// CCM_Note4
Property CCMNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = CCM_Note4 ];

/// CCM_Note5
Property CCMNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CCM_Note5 ];

/// 根据设备分组获取列表
Query SelectByHardGroupType(GrpType As %String, HardName As %String) As %SQLQuery(CONTAINID = 4)
{
SELECT CCM_Desc,CCM_Code,%ID,CCM_ComGroup_DR->CCG_Type FROM DHC_CardHardComManager
 WHERE (CCM_ComGroup_DR->CCG_Type = :GrpType AND CCM_Desc %STARTSWITH :HardName)
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCARDHARDCOM("MANAGER"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CCM_CLASSID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CCM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CCM_CodeBase">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CCM_ComGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CCM_DLLFunctionName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CCM_DLLInPara1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CCM_DLLInPara2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CCM_DLLInPara3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CCM_DLLType">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CCM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CCM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CCM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CCM_EquipPort">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CCM_JSFunctionName">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CCM_Note2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CCM_Note3">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CCM_Note4">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CCM_Note5">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CCM_OBJECTID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CCM_Version">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCCARDHARDCOM</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CCM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"MANAGER"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CCM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexComGroup">
<Global>^DHCCARDHARDCOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CCM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"MANAGER"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CG"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CCM_ComGroup_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CCM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCardHardComManagerS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
