Class User.DHCEQInventory Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = I_RowID, SqlTableName = DHC_EQInventory, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index IInventoryNoUnqIdx1 On IInventoryNo [ Unique ];

/// I_CompleteDate
Property ICompleteDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = I_CompleteDate ];

/// I_Completer
Property ICompleter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = I_Completer ];

/// I_Date
Property IDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = I_Date ];

/// I_EquipTypeIDs
Property IEquipTypeIDs As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = I_EquipTypeIDs ];

/// I_ExpectDate
Property IExpectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = I_ExpectDate ];

/// I_FreezeDate
Property IFreezeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = I_FreezeDate ];

/// I_FreezeTime
Property IFreezeTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = I_FreezeTime ];

/// I_FreezeUser
Property IFreezeUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = I_FreezeUser ];

/// I_Hold10
Property IHold10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = I_Hold10 ];

/// I_Hold6
Property IHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = I_Hold6 ];

/// I_Hold7
Property IHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = I_Hold7 ];

/// I_Hold8
Property IHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = I_Hold8 ];

/// I_Hold9
Property IHold9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = I_Hold9 ];

/// I_HospitalDR
Property IHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = I_HospitalDR ];

/// I_InventoryNo
Property IInventoryNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = I_InventoryNo ];

/// I_LocIncludeFlag
Property ILocIncludeFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = I_LocIncludeFlag ];

/// I_ManageLocDR
Property IManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = I_ManageLocDR ];

/// I_OriginDR
Property IOriginDR As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = I_OriginDR ];

/// I_Remark
Property IRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = I_Remark ];

/// I_SelfFlag
Property ISelfFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = I_SelfFlag ];

/// I_StatCatDR
Property IStatCatDR As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = I_StatCatDR ];

/// I_Status
Property IStatus As %Library.String(DISPLAYLIST = ",新增,提交,实盘", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 11, SqlFieldName = I_Status ];

/// I_StoreLocDR
Property IStoreLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = I_StoreLocDR ];

/// I_Time
Property ITime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = I_Time ];

/// I_UseLocDR
Property IUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = I_UseLocDR ];

/// I_UserDR
Property IUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = I_UserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQInventory("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="I_CompleteDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="I_Completer">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="I_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="I_EquipTypeIDs">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="I_ExpectDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="I_FreezeDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="I_FreezeTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="I_FreezeUser">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="I_Hold10">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="I_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="I_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="I_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="I_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="I_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="I_InventoryNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="I_LocIncludeFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="I_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="I_OriginDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="I_Remark">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="I_SelfFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="I_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="I_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="I_StoreLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="I_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="I_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="I_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEQInventory</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>I_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{I_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCEQInventory</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>I_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{I_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{I_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInventoryNo">
<Global>^DHCEQInventory</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>I_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"InventoryNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{I_InventoryNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{I_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInventoryPlan">
<Global>^DHCEQInventory</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>I_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InventoryPlan"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{I_Hold6}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{I_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreLoc">
<Global>^DHCEQInventory</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>I_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"StoreLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{I_StoreLocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{I_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseLocDR">
<Global>^DHCEQInventory</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>I_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UseLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{I_UseLocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{I_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQInventoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
