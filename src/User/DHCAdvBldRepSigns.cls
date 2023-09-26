Class User.DHCAdvBldRepSigns Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BLDS_RowID, SqlTableName = DHC_AdvBldRepSigns, StorageStrategy = NewStorage1 ]
{

/// 报告表id
Property BLDSRepDr As User.DHCAdvBloodReport [ SqlColumnNumber = 2, SqlFieldName = BLDS_Rep_Dr ];

/// 记录类别
Property BLDSRecType As %String [ SqlColumnNumber = 3, SqlFieldName = BLDS_RecType ];

/// 体温
Property BLDSTemp As %String [ SqlColumnNumber = 4, SqlFieldName = BLDS_Temp ];

/// 血压
Property BLDSBloodPress As %String [ SqlColumnNumber = 5, SqlFieldName = BLDS_BloodPress ];

/// 脉博
Property BLDSSphygmus As %String [ SqlColumnNumber = 6, SqlFieldName = BLDS_Sphygmus ];

/// 呼吸次数
Property BLDSBreathes As %String [ SqlColumnNumber = 7, SqlFieldName = BLDS_Breathes ];

/// 备注
Property BLDSRemark As %String [ SqlColumnNumber = 8, SqlFieldName = BLDS_Remark ];

/// 报告类型id
Property BLDSReptype As User.DHCMedAdrRepEvent [ SqlColumnNumber = 9, SqlFieldName = BLDS_Reptype ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCADVBLDSI)</SqlIdExpression>
<SQLMap name="IndexRepTypeDrRec">
<Global>^DHCADVBLDSI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BLDS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepTypeDrRec"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BLDS_Reptype}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLDS_Rep_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BLDS_RecType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BLDS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="BLDS_BloodPress">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BLDS_Breathes">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BLDS_RecType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BLDS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BLDS_Rep_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BLDS_Reptype">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BLDS_Sphygmus">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BLDS_Temp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCADVBLDSI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BLDS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BLDS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvBldRepSignsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
