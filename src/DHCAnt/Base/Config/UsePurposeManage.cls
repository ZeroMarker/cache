/// CTOR: QP
/// DATE: 2019-07-26
/// DESC: 抗菌药物配置：抗菌药物使用目的管控
Class DHCAnt.Base.Config.UsePurposeManage Extends %Persistent [ StorageStrategy = SQLStorage ]
{

/// UPM_UseOBJDr 使用目的大类
Property UPMUseOBJDr As DHCAnt.Base.PurposeDataConfig [ SqlColumnNumber = 2, SqlFieldName = UPM_UseOBJDr ];

/// UPM_UseItemDr 使用目的子类
Property UPMUseItemDr As DHCAnt.Base.PurposeDataConfig [ SqlColumnNumber = 3, SqlFieldName = UPM_UseItemDr ];

/// UPM_UsePurposeDr 使用目的
Property UPMUsePurposeDr As DHCAnt.Base.PurposeDataConfig [ SqlColumnNumber = 4, SqlFieldName = UPM_UsePurposeDr ];

/// UPM_ArcimDr 
Property UPMArcimDr As User.ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = UPM_ArcimDr ];

/// UPM_ControlType 控制类型(A提示,F禁止,N不控制)
Property UPMControlType As %Library.String [ SqlColumnNumber = 6, SqlFieldName = UPM_ControlType ];

/// UPM_Active 1/0
Property UPMActive As %Library.String [ SqlColumnNumber = 7, SqlFieldName = UPM_Active ];

/// UPM_AddDate 添加日期
Property UPMAddDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = UPM_AddDate ];

/// UPM_AddTime 添加时间
Property UPMAddTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = UPM_AddTime ];

/// UPM_AddUser 添加人
Property UPMAddUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = UPM_AddUser ];

/// UPM_UpdateDate 修改日期
Property UPMUpdateDate As %Library.Date [ SqlColumnNumber = 11, SqlFieldName = UPM_UpdateDate ];

/// UPM_UpdateTime 修改时间
Property UPMUpdateTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = UPM_UpdateTime ];

/// UPM_UpdateUser 修改人
Property UPMUpdateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = UPM_UpdateUser ];

/// UPM_Level 所属层级
Property UPMLevel As %Library.String [ SqlColumnNumber = 14, SqlFieldName = UPM_Level ];

/// UPM_Hosp 所属院区
Property UPMHosp As %Library.String [ SqlColumnNumber = 15, SqlFieldName = UPM_Hosp ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.ANT("UsePurposeManage"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UPM_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UPM_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UPM_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UPM_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UPM_ArcimDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UPM_ControlType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UPM_Hosp">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="UPM_Level">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="UPM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="UPM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="UPM_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="UPM_UseItemDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UPM_UseOBJDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UPM_UsePurposeDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CF.ANT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>UPM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UsePurposeManage"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UPM_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAddDate">
<Global>^CF.ANT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UPM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UsePurposeManage"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AddDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPM_AddDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UPM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItemLevel">
<Condition>"ITEM"={UPM_Level}</Condition>
<ConditionFields>UPM_Level</ConditionFields>
<Global>^CF.ANT</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>UPM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UsePurposeManage"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ItemLevel"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPM_Hosp}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UPM_Level}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UPM_UseItemDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{UPM_ArcimDr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{UPM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOBJLevel">
<Condition>"OBJ"={UPM_Level}</Condition>
<ConditionFields>UPM_Level</ConditionFields>
<Global>^CF.ANT</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>UPM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UsePurposeManage"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OBJLevel"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPM_Hosp}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UPM_Level}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UPM_UseOBJDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{UPM_ArcimDr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{UPM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUPMArcimDr">
<Global>^CF.ANT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UPM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UsePurposeManage"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"UPMArcimDr"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPM_ArcimDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UPM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUPMItemDr">
<Global>^CF.ANT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UPM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UsePurposeManage"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"UPMItemDr"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPM_UseItemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UPM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUPMOBJDr">
<Global>^CF.ANT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UPM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UsePurposeManage"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"UPMOBJDr"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPM_UseOBJDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UPM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUPMUsePurposeDr">
<Global>^CF.ANT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UPM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UsePurposeManage"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"UPMUsePurposeDr"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPM_UsePurposeDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UPM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDate">
<Global>^CF.ANT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UPM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UsePurposeManage"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"UpdateDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPM_UpdateDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UPM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseDrAndArcimDr">
<Global>^CF.ANT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UPM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UsePurposeManage"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"UseDrAndArcimDr"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPM_UsePurposeDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UPM_ArcimDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UPM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseLevel">
<Condition>"USE"={UPM_Level}</Condition>
<ConditionFields>UPM_Level</ConditionFields>
<Global>^CF.ANT</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>UPM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UsePurposeManage"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"UseLevel"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPM_Hosp}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UPM_Level}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UPM_UsePurposeDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{UPM_ArcimDr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{UPM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>UPM_RowId</SqlRowIdName>
<StreamLocation>^DHCAnt.Bas2298.UsePurposeMA309S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
