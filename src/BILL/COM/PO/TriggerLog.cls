/// 名称: BILL.COM.PO.TriggerLog.cls
/// 描述: 持久类表数据更新日志表
/// 编写者: ZhYW
/// 编写日期: 2022-03-24
/// 产品组：计费医保组
Class BILL.COM.PO.TriggerLog Extends (%Persistent, User.Abstract)
{

Property TableName As %Library.String(CAPTION = "表名") [ SqlColumnNumber = 2 ];

Property TableID As %Library.String(CAPTION = "表ID") [ SqlColumnNumber = 3 ];

Property PropValue As %Library.String(CAPTION = "字段值") [ SqlColumnNumber = 4 ];

Property CreatUserDR As User.SSUser(CAPTION = "创建人") [ SqlColumnNumber = 5 ];

Property CreatDate As %Library.Date(CAPTION = "创建日期", FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 6 ];

Property CreatTime As %Library.Time(CAPTION = "创建时间") [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 7 ];

Property OperDesc As %Library.String(CAPTION = "操作描述", MAXLEN = "") [ SqlColumnNumber = 8 ];

Property Remark As %Library.String(CAPTION = "备注", MAXLEN = "") [ SqlColumnNumber = 9 ];

Index IdxTBName On TableName As Exact [ Data = TableID ];

/// Creator: ZhYW
/// CreatDate: 2021-05-17
/// Description: 插入持久类表数据更新日志表
/// Return: =0:更新成功, <>0:更新失败
/// Debug: w ##class(BILL.COM.PO.TriggerLog).Save()
ClassMethod Save(jsonStr As %String) As %String
{
	set json={}.%FromJSON(jsonStr)
		
	&SQL(
		INSERT INTO BILL_COM_PO.TriggerLog (
			TableName, TableID, PropValue, CreatUserDR, OperDesc,
			Remark
		)
		VALUES (
			:json.TableName, :json.TableID, :json.PropValue, :json.UserDR, :json.OperDesc,
			:json.Remark
		)
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	quit rtn
}

Storage Default
{
<Data name="TriggerLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableName</Value>
</Value>
<Value name="3">
<Value>TableID</Value>
</Value>
<Value name="4">
<Value>PropValue</Value>
</Value>
<Value name="5">
<Value>CreatUserDR</Value>
</Value>
<Value name="6">
<Value>CreatDate</Value>
</Value>
<Value name="7">
<Value>CreatTime</Value>
</Value>
<Value name="8">
<Value>OperDesc</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^BILL.COM.PO.TriggerLogD</DataLocation>
<DefaultData>TriggerLogDefaultData</DefaultData>
<ExtentSize>5</ExtentSize>
<IdLocation>^BILL.COM.PO.TriggerLogD</IdLocation>
<IndexLocation>^BILL.COM.PO.TriggerLogI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="CreatDate">
<AverageFieldSize>5</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CreatTime">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CreatUserDR">
<AverageFieldSize>2.2</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="OperDesc">
<AverageFieldSize>14</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PropValue">
<AverageFieldSize>2.6</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="Remark">
<AverageFieldSize>2.6</AverageFieldSize>
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="TableID">
<AverageFieldSize>4</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="TableName">
<AverageFieldSize>20</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IdxTBName">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^BILL.COM.PO.TriggerLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
