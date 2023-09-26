Class User.DHCPAPregDelivery Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DEL_RowID, SqlTableName = DHC_PA_PregDelivery, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (DELPregDr, DELChildsub) [ IdKey, PrimaryKey, Unique ];

/// DEL_Preg_Dr
Property DELPregDr As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DEL_Preg_Dr ];

/// DEL_Childsub
Property DELChildsub As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = DEL_Childsub ];

/// DEL_Stage2FundalHeight
Property DELStage2FundalHeight As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DEL_Stage2FundalHeight ];

/// DEL_Stage3FundalHeight
Property DELStage3FundalHeight As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DEL_Stage3FundalHeight ];

/// DEL_CollBloodLoss
Property DELCollBloodLoss As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DEL_CollBloodLoss ];

/// DEL_EstiBloodLoss
Property DELEstiBloodLoss As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = DEL_EstiBloodLoss ];

/// DEL_Del1HourPulse
Property DELDel1HourPulse As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DEL_Del1HourPulse ];

/// DEL_Del1HourBPDiastolic
Property DELDel1HourBPDiastolic As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DEL_Del1HourBPDiastolic ];

/// DEL_Del1HourBPSystolic
Property DELDel1HourBPSystolic As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DEL_Del1HourBPSystolic ];

/// DEL_Del1HourFundus
Property DELDel1HourFundus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DEL_Del1HourFundus ];

/// DEL_Del1HourBloodLoss
Property DELDel1HourBloodLoss As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DEL_Del1HourBloodLoss ];

/// DEL_Status
Property DELStatus As %Library.String(DISPLAYLIST = ",Labor,Delivery,Operation,Ward,Recovery,Monitor,Cancel,Newborn", MAXLEN = 9, SELECTIVITY = "11.1111%", TRUNCATE = 1, VALUELIST = ",L,D,O,W,R,M,C,N") [ SqlColumnNumber = 13, SqlFieldName = DEL_Status ];

/// DEL_LaborDate
Property DELLaborDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = DEL_LaborDate ];

/// DEL_LaborTime
Property DELLaborTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = DEL_LaborTime ];

/// DEL_Cervix
Property DELCervix As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DEL_Cervix ];

/// DEL_Note
Property DELNote As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DEL_Note ];

/// DEL_PuerperiumAttention
Property DELPuerperiumAttention As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DEL_PuerperiumAttention ];

/// DEL_Diagnose
Property DELDiagnose As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DEL_Diagnose ];

/// DEL_Suture
Property DELSuture As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = DEL_Suture ];

/// DEL_AnaestMethod
Property DELAnaestMethod As User.ORCAnaestMethod [ SqlColumnNumber = 21, SqlFieldName = DEL_AnaestMethod ];

/// DEL_SutureAncommonOrd_Dr
Property DELSutureAncommonOrdDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DEL_SutureAncommonOrd_Dr ];

/// DEL_AnaestMethod
Property DELDeliveryRoom As User.CTLoc [ SqlColumnNumber = 23, SqlFieldName = DEL_DeliveryRoom ];

/// 怀胎数
Property DELPregnancyNumber As %Library.String [ SqlColumnNumber = 24, SqlFieldName = DEL_PregnancyNumber ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DEL_AnaestMethod">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>18</Piece>
</Data>
<Data name="DEL_Cervix">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>13</Piece>
</Data>
<Data name="DEL_CollBloodLoss">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Data name="DEL_Del1HourBPDiastolic">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>6</Piece>
</Data>
<Data name="DEL_Del1HourBPSystolic">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>7</Piece>
</Data>
<Data name="DEL_Del1HourBloodLoss">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>9</Piece>
</Data>
<Data name="DEL_Del1HourFundus">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>8</Piece>
</Data>
<Data name="DEL_Del1HourPulse">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>5</Piece>
</Data>
<Data name="DEL_DeliveryRoom">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>20</Piece>
</Data>
<Data name="DEL_Diagnose">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>16</Piece>
</Data>
<Data name="DEL_EstiBloodLoss">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>4</Piece>
</Data>
<Data name="DEL_LaborDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>11</Piece>
</Data>
<Data name="DEL_LaborTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>12</Piece>
</Data>
<Data name="DEL_Note">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>14</Piece>
</Data>
<Data name="DEL_PregnancyNumber">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>21</Piece>
</Data>
<Data name="DEL_PuerperiumAttention">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>15</Piece>
</Data>
<Data name="DEL_Stage2FundalHeight">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Data name="DEL_Stage3FundalHeight">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="DEL_Status">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>10</Piece>
</Data>
<Data name="DEL_Suture">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>17</Piece>
</Data>
<Data name="DEL_SutureAncommonOrd_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>19</Piece>
</Data>
<Global>^PAPRG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DEL_Preg_Dr</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DEL_Preg_Dr}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DEL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDeliveryRoom">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DEL_Preg_Dr</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DEL_DeliveryRoom"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_DeliveryRoom}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DEL_Preg_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLaborDate">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DEL_Preg_Dr</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL_LaborDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEL_LaborDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DEL_Preg_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPAPregDeliveryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
