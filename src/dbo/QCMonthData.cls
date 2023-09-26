///     
Class dbo.QCMonthData Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_MonthData, StorageStrategy = Default ]
{

/// Foreign Key FKMonthDataLot created via DDL
ForeignKey FKMonthDataLot(MaterialLotDR) References dbo.BTQCMaterialLot(PKBTQCMATERIALLOT) [ SqlName = FK_MonthDataLot ];

/// Foreign Key FKMonthDataTestCode created via DDL
ForeignKey FKMonthDataTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_MonthDataTestCode ];

Index IndexMaster On (MaterialLotDR, TestCodeDR, LevelNo, Year, Month, RgLot) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKQCMONTHDATA On RowID [ PrimaryKey, SqlName = PK_QC_MONTHDATA, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MaterialLotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Year As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property Month As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property CurSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property CurMean As %Library.Float [ SqlColumnNumber = 9 ];

Property CurSD As %Library.Float [ SqlColumnNumber = 10 ];

Property AccSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property AccMean As %Library.Float [ SqlColumnNumber = 12 ];

Property AccSD As %Library.Float [ SqlColumnNumber = 13 ];

Property CurMax As %Library.Float [ SqlColumnNumber = 14 ];

Property CurMin As %Library.Float [ SqlColumnNumber = 15 ];

Property AccMax As %Library.Float [ SqlColumnNumber = 16 ];

Property AccMin As %Library.Float [ SqlColumnNumber = 17 ];

Property TestNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property LastPointMean As %Library.Float [ SqlColumnNumber = 19 ];

Property LastPointSD As %Library.Float [ SqlColumnNumber = 20 ];

Property LastPointNum As %Library.Float [ SqlColumnNumber = 21 ];

Property RemoveLossMean As %Library.Float [ SqlColumnNumber = 22 ];

Property RemoveLossSD As %Library.Float [ SqlColumnNumber = 23 ];

Property ExludeNum As %Library.Float [ SqlColumnNumber = 24 ];

Property LossNum As %Library.Float [ SqlColumnNumber = 25 ];

Property LossRate As %Library.Float [ SqlColumnNumber = 26 ];

Property DealRate As %Library.Float [ SqlColumnNumber = 27 ];

Property AccSumInControl As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

Property AccMeanInControl As %Library.Float [ SqlColumnNumber = 29 ];

Property AccSDInControl As %Library.Float [ SqlColumnNumber = 30 ];

Property AccSumBest As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

Property AccMeanBest As %Library.Float [ SqlColumnNumber = 32 ];

Property AccSDBest As %Library.Float [ SqlColumnNumber = 33 ];

Property RgLot As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 34 ];

Storage Default
{
<Data name="QCMonthDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialLotDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>LevelNo</Value>
</Value>
<Value name="5">
<Value>Year</Value>
</Value>
<Value name="6">
<Value>Month</Value>
</Value>
<Value name="7">
<Value>CurSum</Value>
</Value>
<Value name="8">
<Value>CurMean</Value>
</Value>
<Value name="9">
<Value>CurSD</Value>
</Value>
<Value name="10">
<Value>AccSum</Value>
</Value>
<Value name="11">
<Value>AccMean</Value>
</Value>
<Value name="12">
<Value>AccSD</Value>
</Value>
<Value name="13">
<Value>CurMax</Value>
</Value>
<Value name="14">
<Value>CurMin</Value>
</Value>
<Value name="15">
<Value>AccMax</Value>
</Value>
<Value name="16">
<Value>AccMin</Value>
</Value>
<Value name="17">
<Value>TestNum</Value>
</Value>
<Value name="18">
<Value>LastPointMean</Value>
</Value>
<Value name="19">
<Value>LastPointSD</Value>
</Value>
<Value name="20">
<Value>LastPointNum</Value>
</Value>
<Value name="21">
<Value>RemoveLossMean</Value>
</Value>
<Value name="22">
<Value>RemoveLossSD</Value>
</Value>
<Value name="23">
<Value>ExludeNum</Value>
</Value>
<Value name="24">
<Value>LossNum</Value>
</Value>
<Value name="25">
<Value>LossRate</Value>
</Value>
<Value name="26">
<Value>DealRate</Value>
</Value>
<Value name="27">
<Value>AccSumInControl</Value>
</Value>
<Value name="28">
<Value>AccMeanInControl</Value>
</Value>
<Value name="29">
<Value>AccSDInControl</Value>
</Value>
<Value name="30">
<Value>AccSumBest</Value>
</Value>
<Value name="31">
<Value>AccMeanBest</Value>
</Value>
<Value name="32">
<Value>AccSDBest</Value>
</Value>
<Value name="33">
<Value>RgLot</Value>
</Value>
</Data>
<DataLocation>^dbo.QCMonthDataD</DataLocation>
<DefaultData>QCMonthDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.QCMonthDataD</IdLocation>
<IndexLocation>^dbo.QCMonthDataI</IndexLocation>
<StreamLocation>^dbo.QCMonthDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
