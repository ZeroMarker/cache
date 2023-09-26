Class User.DHCADVModel Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_ADVModel, StorageStrategy = NewStorage1 ]
{

Property Code As %String;

Property Name As %String;

Property FormName As User.DHCAdvFormName;

Property FilterClass As %String;

Property FilterFunc As %String;

/// 报表类型,子报表|(sub)/主报表()
Property Type As %String;

/// 子报表
Property SubModel As User.DHCADVModel;

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCADVMODEL)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCADVMODEL</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{M_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="dataMaster">
<Data name="Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FilterClass">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FilterFunc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FormName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SubModel">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCADVMODEL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{M_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{M_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>M_RowId</SqlRowIdName>
<StreamLocation>^User.DHCADVModelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Index IndexCode On Code [ Unique ];

Index IndexName On Name [ Unique ];

// d ##class(User.DHCADVModel).%BuildIndices($ListBuild("IndexCode"))

}
