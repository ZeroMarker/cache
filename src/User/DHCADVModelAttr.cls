Class User.DHCADVModelAttr Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_ADVModelAttr, StorageStrategy = NewStorage1 ]
{

Property model As User.DHCADVModel;

/// x:x轴
/// y:y轴
Property type As %String;

Property colum As %String;

Property seq As %Integer [ InitialExpression = 999 ];

/// column类型
/// 			dic:字典
///             dateRange:日期范围   
/// 		    User.DHCAdvMaster:dhc_advmaster)
Property columType As %String;

/// 显示名称
Property displayTitle As %String(MAXLEN = 20000);

/// 函数类
Property class As %String;

/// 函数名称
Property func As %String;

/// 过滤条件
Property filter As %String;

/// 显示比率
Property displayRate As %String [ InitialExpression = "n" ];

/// 日期系数
Property dateValue As %String [ InitialExpression = 1 ];

/// 度量类型 (count:计数|value:取值)
Property measureType As %String [ InitialExpression = "count" ];

/// 扩展方式  (value:按值扩展|dic:按字典扩展)
Property extendType As %String [ InitialExpression = "dic" ];

/// 父节点
Property parent As User.DHCADVModelAttr [ InitialExpression = 0 ];

/// 隐藏
Property hidden As %String [ InitialExpression = "n" ];

/// 显示合计列
Property displayTotal As %String [ InitialExpression = "n" ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCADVMODELATTR)</SqlIdExpression>
<SQLMap name="dataMaster">
<Data name="class">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="colum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="columType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="dateValue">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="displayRate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="displayTitle">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="displayTotal">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="extendType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="filter">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="func">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="hidden">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="measureType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="model">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="parent">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="seq">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVMODELATTR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{MA_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MA_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexColumnType">
<Global>^DHCADVMODELATTR</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ColumnType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{model}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{columType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{colum}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexModelType">
<Global>^DHCADVMODELATTR</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ModelType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{model}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{seq}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexParent">
<Global>^DHCADVMODELATTR</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeParent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{model}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{parent}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{seq}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{MA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MA_RowId</SqlRowIdName>
<StreamLocation>^User.DHCADVModelAttrS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// d ##class(User.DHCADVModelAttr).%BuildIndices($ListBuild("indexParent"))

}
