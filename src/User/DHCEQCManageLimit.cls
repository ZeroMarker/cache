Class User.DHCEQCManageLimit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ML_RowID, SqlTableName = DHC_EQCManageLimit, StorageStrategy = SQLStorage ]
{

/// ML_EquipCatFlag
Property MLEquipCatFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ML_EquipCatFlag ];

/// ML_EquipFlag
Property MLEquipFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = ML_EquipFlag ];

/// ML_EquipTypeFlag
Property MLEquipTypeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ML_EquipTypeFlag ];

/// ML_GroupDR
Property MLGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ML_GroupDR ];

/// ML_ItemFlag
Property MLItemFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = ML_ItemFlag ];

/// ML_LocFlag
Property MLLocFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ML_LocFlag ];

/// ML_RoleDR
Property MLRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 4, SqlFieldName = ML_RoleDR ];

/// ML_StatCatFlag
Property MLStatCatFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ML_StatCatFlag ];

/// ML_UserDR
Property MLUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ML_UserDR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCManageLimit",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ML_EquipCatFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ML_EquipFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ML_EquipTypeFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ML_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ML_ItemFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ML_LocFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ML_RoleDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ML_StatCatFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ML_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ML_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCManageLimit"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ML_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ML_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCManageLimit"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{ML_UserDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{ML_GroupDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>+{ML_RoleDR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ML_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCManageLimitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
