Class User.DHCEQBenefitEquipList Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQBenefitEquipList, StorageStrategy = SQLStorage ]
{

/// BEL_EquipDR
Property BELEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = BEL_EquipDR ];

/// BEL_InitYear
Property BELInitYear As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BEL_InitYear ];

/// BEL_PreWorkLoad
Property BELPreWorkLoad As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BEL_PreWorkLoad ];

/// BEL_NewFunction
Property BELNewFunction As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BEL_NewFunction ];

/// BEL_SpecialService
Property BELSpecialService As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BEL_SpecialService ];

/// BEL_OtherSocial
Property BELOtherSocial As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BEL_OtherSocial ];

/// BEL_GraduateNum
Property BELGraduateNum As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BEL_GraduateNum ];

/// BEL_StaffNum
Property BELStaffNum As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BEL_StaffNum ];

/// BEL_OtherTasks
Property BELOtherTasks As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BEL_OtherTasks ];

/// BEL_Hold1
Property BELHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BEL_Hold1 ];

/// BEL_Hold2
Property BELHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = BEL_Hold2 ];

/// BEL_Hold3
Property BELHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = BEL_Hold3 ];

/// BEL_Hold4
Property BELHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = BEL_Hold4 ];

/// BEL_Hold5
Property BELHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = BEL_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQBenefitEquipList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BEL_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BEL_GraduateNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BEL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BEL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BEL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BEL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BEL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BEL_InitYear">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BEL_NewFunction">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BEL_OtherSocial">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BEL_OtherTasks">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BEL_PreWorkLoad">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BEL_SpecialService">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BEL_StaffNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEQBenefitEquipList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BEL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{BEL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQBenefitEquipList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BEL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BEL_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BEL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BEL_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQBenefitEquipListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
