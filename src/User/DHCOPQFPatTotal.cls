Class User.DHCOPQFPatTotal Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = QF_RowId, SqlTableName = DHC_OPQFPatTotal, StorageStrategy = SQLStorage ]
{

/// QF_Adm
Property QFAdm As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = QF_Adm ];

/// QF_Adm
Property QFPapmiDr As User.PAPatMas [ SqlColumnNumber = 3, SqlFieldName = QF_Papmi_Dr ];

/// QF_Date
Property QFDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 4, SqlFieldName = QF_Date ];

/// QF_Time
Property QFTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 5, SqlFieldName = QF_Time ];

/// QF_Amount
Property QFAmount As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = QF_Amount ];

/// QF_Flag
Property QFFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = QF_Flag ];

/// QF_AddUser
Property QFAddUser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = QF_AddUser ];

/// QF_Status
Property QFStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = QF_Status ];

/// QF_Prt_dr
Property QFPrtdr As User.DHCINVPRT [ SqlColumnNumber = 10, SqlFieldName = QF_Prt_dr ];

/// QF_Pb_dr
Property QFPbdr As User.DHCPatientBill [ SqlColumnNumber = 11, SqlFieldName = QF_Pb_dr ];

/// QF_Comment
Property QFComment As %Library.String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = QF_Comment ];

/// QF_Hosp_DR
Property QFHospDR As User.CTHospital [ SqlColumnNumber = 13, SqlFieldName = QF_Hosp_DR ];

/// QF_Remain2
Property QFRemain2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = QF_Remain2 ];

/// QF_InitDR
Property QFInitDR As User.DHCOPQFPatTotal [ SqlColumnNumber = 15, SqlFieldName = QF_InitDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="QFAddUser">
<AverageFieldSize>5.67</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="QFAdm">
<AverageFieldSize>5.85</AverageFieldSize>
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="QFAmount">
<AverageFieldSize>6.3</AverageFieldSize>
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="QFComment">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="QFDate">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="QFFlag">
<AverageFieldSize>6.93</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="QFHospDR">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="QFInitDR">
<AverageFieldSize>2.81</AverageFieldSize>
<OutlierSelectivity>.518519:</OutlierSelectivity>
<Selectivity>3.7037%</Selectivity>
</Property>
<Property name="QFPapmiDr">
<AverageFieldSize>4.48</AverageFieldSize>
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="QFPbdr">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="QFPrtdr">
<AverageFieldSize>5.85</AverageFieldSize>
<Selectivity>4.1667%</Selectivity>
</Property>
<Property name="QFRemain2">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="QFStatus">
<AverageFieldSize>3</AverageFieldSize>
<OutlierSelectivity>.962963:"N"</OutlierSelectivity>
<Selectivity>3.7037%</Selectivity>
</Property>
<Property name="QFTime">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>3.7037%</Selectivity>
</Property>
<SqlIdExpression>$i(^DHCOPQFPatInfo)</SqlIdExpression>
<SQLMap name="DataMaster">
<BlockCount>-4</BlockCount>
<Data name="QF_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="QF_Adm">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QF_Amount">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="QF_Comment">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="QF_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="QF_Flag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="QF_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="QF_InitDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="QF_Papmi_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QF_Pb_dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="QF_Prt_dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="QF_Remain2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="QF_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="QF_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCOPQFPatInfo</Global>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{QF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexPapmi">
<BlockCount>-4</BlockCount>
<Global>^DHCOPQFPatInfo</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Papmi"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QF_Papmi_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QF_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexadm">
<BlockCount>-4</BlockCount>
<Global>^DHCOPQFPatInfo</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QF_Adm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexdate">
<BlockCount>-4</BlockCount>
<Global>^DHCOPQFPatInfo</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QF_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexdatepapmi">
<BlockCount>-4</BlockCount>
<Global>^DHCOPQFPatInfo</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DatePapmi"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QF_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QF_Papmi_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexlinkto">
<BlockCount>-4</BlockCount>
<Global>^DHCOPQFPatInfo</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
<StartValue>0</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LinkTo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{QF_InitDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexpbl">
<Global>^DHCOPQFPatInfo</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARPBL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QF_Pb_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexprt">
<BlockCount>-4</BlockCount>
<Global>^DHCOPQFPatInfo</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InvPrt"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QF_Prt_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOPQFPatInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
