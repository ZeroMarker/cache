Class User.DHCAdvRepFile Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = FILE_RowID, SqlTableName = DHC_AdvRepFile, StorageStrategy = SQLStorage ]
{

/// FILE_RepDr	报告id
Property FILERepDr As User.DHCAdvMaster [ SqlColumnNumber = 2, SqlFieldName = FILE_RepDr ];

/// FILE_RepType	报告类型
Property FILERepType As %String [ SqlColumnNumber = 3, SqlFieldName = FILE_RepType ];

/// FILE_IfFile	是否归档 归档待复核 01 / 归档 02 / 撤销归档11 / 撤销复核 12
Property FILEIfFile As %Library.String [ SqlColumnNumber = 4, SqlFieldName = FILE_IfFile ];

/// FILE_AuditUser	审核人
Property FILEAuditUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = FILE_AuditUser ];

/// FILE_Checker	复核人
Property FILEChecker As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = FILE_Checker ];

/// FILE_Date	归档日期
Property FILEDate As %Date [ SqlColumnNumber = 7, SqlFieldName = FILE_Date ];

/// FILE_Time	归档时间
Property FILETime As %Time [ SqlColumnNumber = 8, SqlFieldName = FILE_Time ];

/// FILE_RevFileuser	撤销操作人
Property FILERevFileuser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = FILE_RevFileuser ];

/// FILE_RevDate	撤销日期
Property FILERevDate As %Date [ SqlColumnNumber = 10, SqlFieldName = FILE_RevDate ];

/// FILE_RevTime	撤销时间
Property FILERevTime As %Time [ SqlColumnNumber = 11, SqlFieldName = FILE_RevTime ];

/// FILE_Cat_Dr	报告归档分类
Property FILECatDr As User.DHCAdvMedRepCat [ SqlColumnNumber = 12, SqlFieldName = FILE_Cat_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVFILE)</SqlIdExpression>
<SQLMap name="MasterData">
<Data name="FILE_AuditUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FILE_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="FILE_Checker">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FILE_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FILE_IfFile">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FILE_RepDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FILE_RepType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FILE_RevDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="FILE_RevFileuser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FILE_RevTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="FILE_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCADVFILE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FILE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{FILE_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="RepDrTypeIndex">
<Global>^DHCADVFILE</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>FILE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepDrType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FILE_RepDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FILE_RepType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{FILE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvRepFileS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
