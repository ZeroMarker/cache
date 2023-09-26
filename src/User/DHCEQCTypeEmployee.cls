Class User.DHCEQCTypeEmployee Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TE_RowID, SqlTableName = DHC_EQCTypeEmployee, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TE_EmployeeTypeDR
Property TEEmployeeTypeDR As User.DHCEQCEmployeeType [ SqlColumnNumber = 2, SqlFieldName = TE_EmployeeTypeDR ];

/// TE_EmployeeDR
Property TEEmployeeDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = TE_EmployeeDR ];

/// TE_InvalidFlag
Property TEInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = TE_InvalidFlag ];

/// TE_Remark
Property TERemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = TE_Remark ];

/// TE_EquipTypeDR
Property TEEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 6, SqlFieldName = TE_EquipTypeDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCTypeEmployee",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TE_EmployeeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TE_EmployeeTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TE_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TE_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TE_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCTypeEmployee"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{TE_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEmployeeType">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCTypeEmployee"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EmployeeType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TE_EmployeeTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipType">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCTypeEmployee"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EquipType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TE_EmployeeTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TE_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCTypeEmployeeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
