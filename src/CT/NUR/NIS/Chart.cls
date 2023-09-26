/// Creator:      SongChao
/// CreateDate:   2019.6.
/// Description:  体温单等样式固定表格模板主表
Class CT.NUR.NIS.Chart Extends %Persistent [ SqlTableName = Chart, StorageStrategy = CacheStorage ]
{

Relationship ChildChartLoc As ChartLoc [ Cardinality = children, Inverse = LocParRef ];

Relationship ChildChartCurve As ChartCurve [ Cardinality = children, Inverse = CurveParRef ];

Relationship ChildCycleVal As ChartCycleVal [ Cardinality = children, Inverse = CycleValParRef ];

Relationship ChildChartEvent As ChartEvent [ Cardinality = children, Inverse = EventParRef ];

Relationship ChildChartDrop As ChartAfterDrop [ Cardinality = children, Inverse = DropParRef ];

Relationship ChildChartFever As ChartSuddenFever [ Cardinality = children, Inverse = FeverParRef ];

Relationship ChildChartRetest As ChartRetest [ Cardinality = children, Inverse = RetestParRef ];

Relationship ChildOverScale As ChartOverScale [ Cardinality = children, Inverse = OverScaleParRef ];

/// 模板名称
Property Name As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Name ];

/// 院区 
Property HospDR As User.CTHospital [ Required, SqlColumnNumber = 3, SqlFieldName = HospDR ];

/// 是否启用 
Property IsActive As %String(DISPLAYLIST = ",启用,未启用", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 4, SqlFieldName = IsActive ];

/// 启用日期
Property StartDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = StartDate ];

/// 截止日期
Property EndDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = EndDate ];

/// 表格外内容配置
Property PageConfig As %GlobalCharacterStream(LOCATION = "^CT.NUR.NIS.ChartS") [ SqlColumnNumber = 7, SqlFieldName = PageConfig ];

/// 表格内容配置
Property SheetConfig As %GlobalCharacterStream(LOCATION = "^CT.NUR.NIS.ChartS") [ SqlColumnNumber = 8, SqlFieldName = SheetConfig ];

/// 打印规则配置
Property PrintConfig As %GlobalCharacterStream(LOCATION = "^CT.NUR.NIS.ChartS") [ SqlColumnNumber = 9, SqlFieldName = PrintConfig ];

/// 文字内容配置
Property TextConfig As %GlobalCharacterStream(LOCATION = "^CT.NUR.NIS.ChartS") [ SqlColumnNumber = 10, SqlFieldName = TextConfig ];

/// 更新日期
Property UpdateDate As %Library.Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 11, SqlFieldName = UpdateDate ];

/// 更新时间
Property UpdateTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 12, SqlFieldName = UpdateTime ];

/// 心率指针
Property HeartBeatDr As User.MRCObservationItem [ SqlColumnNumber = 13, SqlFieldName = HeartBeatDr ];

/// 脉搏指针
Property PluseDr As User.MRCObservationItem [ SqlColumnNumber = 14, SqlFieldName = PluseDr ];

/// 脉搏短绌
Property MissBeat As %String(DISPLAYLIST = ",显示,不显示", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = MissBeat ];

/// 脉搏短绌样式
Property MissBeatStyleDr As ChartDict [ SqlColumnNumber = 16, SqlFieldName = MissBeatStyleDr ];

/// 新生儿
Property IfBaby As %String(DISPLAYLIST = ",是,否", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = IfBaby ];

/// 新生儿年龄判断
Property NewBabyAge As %String [ SqlColumnNumber = 18, SqlFieldName = NewBabyAge ];

/// 单据类型
Property ChartType As %String(DISPLAYLIST = ",体温单,疼痛单", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",T,P") [ SqlColumnNumber = 19, SqlFieldName = ChartType ];

/// 脉搏短绌颜色
Property MissBeatColor As %String [ SqlColumnNumber = 20, SqlFieldName = MissBeatColor ];

/// 脉搏短绌仅同一时间点的脉搏和心率相连
Property OnlySamePointHPConnect As %String(DISPLAYLIST = ",是,否", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = OnlySamePointHPConnect ];

Index HOSP On (IsActive, HospDR);

Index Baby On (IsActive, HospDR, IfBaby);

Index Type On (IsActive, HospDR, ChartType);

Storage CacheStorage
{
<Data name="ChartDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>HospDR</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
<Value name="5">
<Value>StartDate</Value>
</Value>
<Value name="6">
<Value>EndDate</Value>
</Value>
<Value name="7">
<Value>PageConfig</Value>
</Value>
<Value name="8">
<Value>SheetConfig</Value>
</Value>
<Value name="9">
<Value>PrintConfig</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
<Value name="11">
<Value>UpdateTime</Value>
</Value>
<Value name="12">
<Value>TextConfig</Value>
</Value>
<Value name="13">
<Value>HeartBeatDr</Value>
</Value>
<Value name="14">
<Value>PluseDr</Value>
</Value>
<Value name="15">
<Value>MissBeat</Value>
</Value>
<Value name="16">
<Value>MissBeatStyleDr</Value>
</Value>
<Value name="17">
<Value>IfBaby</Value>
</Value>
<Value name="18">
<Value>NewBabyAge</Value>
</Value>
<Value name="19">
<Value>ChartType</Value>
</Value>
<Value name="20">
<Value>MissBeatColor</Value>
</Value>
<Value name="21">
<Value>OnlySamePointHPConnect</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.NIS.ChartD</DataLocation>
<DefaultData>ChartDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.ChartD</IdLocation>
<IndexLocation>^CT.NUR.NIS.ChartI</IndexLocation>
<StreamLocation>^CT.NUR.NIS.ChartS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
