/// DHC Tariff Parameter
Class User.DHCTarPara Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TM_RowId, SqlTableName = DHC_TarPara, StorageStrategy = SQLStorage ]
{

/// Default Standard Price List
Property TMDefaultTariff As %Library.String(DISPLAYLIST = ",Price,AlterPrice1,AlterPrice2", MAXLEN = 11, SELECTIVITY = "25.0000%", VALUELIST = ",P0,P1,P2") [ SqlColumnNumber = 2, SqlFieldName = TM_DefaultTariff ];

/// Default Episode Sub Type
Property TMDefaultEpisodeType As User.PACEpisodeSubType [ SqlColumnNumber = 3, SqlFieldName = TM_DefaultEpisodeType ];

/// Default Insurance Type
Property TMDefaultInsType As User.PACAdmReason [ SqlColumnNumber = 4, SqlFieldName = TM_DefaultInsType ];

/// Discount Type
Property TMDiscountType As %Library.String(DISPLAYLIST = ",Patient,Item", MAXLEN = 7, SELECTIVITY = "33.3333%", VALUELIST = ",P,I") [ SqlColumnNumber = 5, SqlFieldName = TM_DiscountType ];

/// NewBorn link to Mother
Property TMNewBornToMother As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = TM_NewBornToMother ];

/// TM_LinkInstrPrior
Property TMLinkInstrPrior As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = TM_LinkInstrPrior ];

/// Regenerate Bill
Property TMReBillMode As %Library.String(DISPLAYLIST = ",All Order,Billed Item", MAXLEN = 11, SELECTIVITY = "33.3333%", VALUELIST = ",O,B") [ SqlColumnNumber = 8, SqlFieldName = TM_ReBillMode ];

/// Bill Mode
Property TMBillMode As %Library.String(DISPLAYLIST = ",All Order,Changed Order", MAXLEN = 13, SELECTIVITY = "33.3333%", VALUELIST = ",A,C") [ SqlColumnNumber = 9, SqlFieldName = TM_BillMode ];

/// Default Bill Condition
Property TMBillCondition As %Library.String(DISPLAYLIST = ",Order Entry or Discontinued,Order Executed,Nurse Executed,Result Return,Pharmacy Collected or Return,Specimen Collect,Deposit Remaining Sum", MAXLEN = 28, SELECTIVITY = "12.5000%", VALUELIST = ",OD,OE,NE,RR,CR,SC,RS") [ SqlColumnNumber = 10, SqlFieldName = TM_BillCondition ];

/// OutStanding Days
Property TMOutStandDays As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = TM_OutStandDays ];

/// Default Pay Mode
Property TMDefaultPayMode As User.CTPayMode [ SqlColumnNumber = 12, SqlFieldName = TM_DefaultPayMode ];

/// LabTrak Namespace
Property TMLabTrakNameSpace As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = TM_LabTrakNameSpace ];

/// Cashier Collect Time
Property TMCashierCloseTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = TM_CashierCloseTime ];

/// TM_AlertDeposit
Property TMAlertDeposit As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = TM_AlertDeposit ];

/// TM_AgeCalcMode 2023-04-12 年龄计算方式(1:按当前时间, 2:按就诊时间, 3:按分床时间(仅限住院))
Property TMAgeCalcMode As %Library.String(VALUELIST = ",1,2,3") [ SqlColumnNumber = 16, SqlFieldName = TM_AgeCalcMode ];

/// TM_Hosp_DR
Property TMHospDR As User.CTHospital [ SqlColumnNumber = 17, SqlFieldName = TM_Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCTarC("CF"))</SqlIdExpression>
<SQLMap name="DateMaster">
<Data name="TM_AgeCalcMode">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TM_AlertDeposit">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TM_BillCondition">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TM_BillMode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TM_CashierCloseTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TM_DefaultEpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TM_DefaultInsType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TM_DefaultPayMode">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TM_DefaultTariff">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TM_DiscountType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TM_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TM_LabTrakNameSpace">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TM_LinkInstrPrior">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TM_NewBornToMother">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TM_OutStandDays">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TM_ReBillMode">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCTarC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{TM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCTarParaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
