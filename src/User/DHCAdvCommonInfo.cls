Class User.DHCAdvCommonInfo Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ADV_ComRowID, SqlTableName = DHC_AdvCommonInfo, StorageStrategy = NewStorage1 ]
{

/// ADV_ComType_Dr	报告类别
Property ADVComTypeDr As User.DHCMedAdrRepEvent [ SqlColumnNumber = 2, SqlFieldName = ADV_ComType_Dr ];

/// ADV_ComPointer	指针
Property ADVComPointer As %String [ SqlColumnNumber = 3, SqlFieldName = ADV_ComPointer ];

/// ADV_ComEventLevel	医疗安全事件类别
Property ADVComEventLevel As %String [ SqlColumnNumber = 4, SqlFieldName = ADV_ComEventLevel ];

/// ADV_ComInjuryLevel	损害轻重程度
Property ADVComInjuryLevel As %String [ SqlColumnNumber = 5, SqlFieldName = ADV_ComInjuryLevel ];

/// ADV_ComTimePer	发生时间段
Property ADVComTimePer As %String [ SqlColumnNumber = 6, SqlFieldName = ADV_ComTimePer ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCADVCOMI)</SqlIdExpression>
<SQLMap name="IndexTypePointer">
<Global>^DHCADVCOMI</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADV_ComRowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADV_ComType_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADV_ComPointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADV_ComRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ADV_ComEventLevel">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADV_ComInjuryLevel">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADV_ComPointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADV_ComTimePer">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADV_ComType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCADVCOMI</Global>
<Subscript name="1">
<Expression>{ADV_ComRowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvCommonInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
