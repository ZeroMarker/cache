/// 库存项属性表
Class User.INCItmProp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, SqlTableName = INC_ItmProp, StorageStrategy = CacheSQLStorage ]
{

Index RowIDBasedIDKeyIndex On PropChildSub [ IdKey, PrimaryKey, Unique ];

Index CodeIndex On (PropParRef, PropCode) [ Unique ];

Relationship PropParRef As User.INCItm [ Cardinality = parent, Inverse = ChildINCItmProp, Required, SqlFieldName = Prop_ParRef ];

Property PropChildSub As %Numeric(SCALE = 0) [ InitialExpression = {..GetInitID($g(initvalue))}, Required, SqlColumnNumber = 2, SqlFieldName = Prop_ChildSub ];

/// 代码
Property PropCode As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Prop_Code ];

/// 名称
Property PropDesc As %String [ SqlColumnNumber = 4, SqlFieldName = Prop_Desc ];

/// 值
Property PropValue As %String [ SqlColumnNumber = 5, SqlFieldName = Prop_Value ];

/// 生效起始日期
Property PropStartDate As %String [ SqlColumnNumber = 6, SqlFieldName = Prop_StartDate ];

/// 截止日期
Property PropEndDate As %String [ SqlColumnNumber = 7, SqlFieldName = Prop_EndDate ];

/// 备注
Property PropRemark As %String [ SqlColumnNumber = 8, SqlFieldName = Prop_Remark ];

ClassMethod GetInitID(initvalue)
{
	if (initvalue = ""){
		s initvalue = $g(%d(0))
	}
	q:(initvalue = "") "没有父指向"
	l +^INCItmProp(initvalue):5  e  q "INCItmProp.RowID加锁生成ID失败"
 	q $o(^INCI(initvalue, "Prop", ""), -1) + 1
}

Trigger TAfterInsert [ Event = INSERT, Order = 1, Time = AFTER ]
{
	if ($d(%d(0))){
		l -^INCItmProp(%d(0))
	}
}

/// 删除历史产生的无用数据
ClassMethod ClearDirty() [ CodeMode = objectgenerator ]
{
	s inci = 0
	for {
		s inci = $o(^INCI(inci)) q:(inci = "")
		s max = +$o(^INCI(inci, "Prop", ""), -1)
		if (max = 0){
			k ^INCI(inci, "Prop")
		}
	}
}

Storage CacheSQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="Prop_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Prop_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Prop_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Prop_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Prop_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Prop_Value">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^INCI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>Prop_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INC_Itm.INCI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Prop"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{Prop_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPropCode">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>Prop_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PropCode"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{Prop_Code}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{Prop_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Prop_RowId</SqlRowIdName>
<StreamLocation>^User.INCItmPropS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
