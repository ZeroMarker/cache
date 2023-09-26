Class User.DHCJFOrderRefundAppConfig Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ORAC_Rowid, SqlTableName = DHC_JFOrderRefundAppConfig, StorageStrategy = SQLStorage ]
{

Property ORACArcicDR As %String [ SqlColumnNumber = 2, SqlFieldName = ORAC_Arcic_DR ];

Property ORACArcimDR As %String [ SqlColumnNumber = 3, SqlFieldName = ORAC_Arcim_DR ];

Property ORACStDate As %Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = ORAC_StDate ];

Property ORACEndDate As %Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = ORAC_EndDate ];

Property ORACDate As %Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = ORAC_Date ];

Property ORACTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 7, SqlFieldName = ORAC_Time ];

Property ORACUserDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = ORAC_User_DR ];

Property ORACUpDate As %Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = ORAC_UpDate ];

Property ORACUpTime As %Time [ SqlColumnNumber = 10, SqlFieldName = ORAC_UpTime ];

Property ORACUpUserDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = ORAC_UpUser_DR ];

Property ORACNote1 As %String [ SqlColumnNumber = 12, SqlFieldName = ORAC_Note1 ];

Property ORACNote2 As %String [ SqlColumnNumber = 13, SqlFieldName = ORAC_Note2 ];

Property ORACNote3 As %String [ SqlColumnNumber = 14, SqlFieldName = ORAC_Note3 ];

Property ORACFlag As %String [ SqlColumnNumber = 15, SqlFieldName = ORAC_Flag ];

Property ORACHospDR As User.CTHospital [ SqlColumnNumber = 16, SqlFieldName = ORAC_Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCJFOrderRefundAppConfig)</SqlIdExpression>
<SQLMap name="indexarcic">
<Global>^DHCJFOrderRefundAppConfig</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arcic"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORAC_Arcic_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORAC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexarcim">
<Global>^DHCJFOrderRefundAppConfig</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arcim"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORAC_Arcim_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORAC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexdate">
<Global>^DHCJFOrderRefundAppConfig</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORAC_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORAC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexuser">
<Global>^DHCJFOrderRefundAppConfig</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORAC_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORAC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="master">
<Data name="ORAC_Arcic_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ORAC_Arcim_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ORAC_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ORAC_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ORAC_Flag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ORAC_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ORAC_Note1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ORAC_Note2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ORAC_Note3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ORAC_StDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ORAC_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ORAC_UpDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ORAC_UpTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ORAC_UpUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ORAC_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCJFOrderRefundAppConfig</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ORAC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ORAC_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCJFOrderRefundAppConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
