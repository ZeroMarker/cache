Class User.EnsSendDataInfo Extends (%Persistent, %XML.Adaptor) [ Inheritance = right, SqlTableName = Ens_SendData ]
{

/// 方法
Property interfaceMethodDr As User.EnsInterfaceMethod [ SqlColumnNumber = 2, SqlFieldName = interface_Method_Dr ];

/// 数据格式
Property ensDataFormat As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = ens_DataFormat ];

/// 状态(Yes：运行，No：停止)
Property ensDataStatus As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ens_DataStatus ];

///  数据同步频率
Property ensDataTaskFreq As %String(MAXLEN = 20) [ SqlColumnNumber = 5, SqlFieldName = ens_DataTaskFreq ];

///  数据同步星期
Property ensDataWeeks As %String(MAXLEN = 2) [ SqlColumnNumber = 6, SqlFieldName = ens_DataWeeks ];

///  数据同步日期
Property ensDataDays As %String(MAXLEN = 2) [ SqlColumnNumber = 7, SqlFieldName = ens_DataDays ];

///  数据同步时间点
Property ensDataTimes As %String(MAXLEN = 5) [ SqlColumnNumber = 8, SqlFieldName = ens_DataTimes ];

///  备注
Property ensDataNote As %String(MAXLEN = 1000) [ SqlColumnNumber = 9, SqlFieldName = ens_DataNote ];

Index InterfaceMethodDr On interfaceMethodDr [ Unique ];

Storage Default
{
<Data name="EnsSendDataInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>interfaceMethodDr</Value>
</Value>
<Value name="3">
<Value>ensDataFormat</Value>
</Value>
<Value name="4">
<Value>ensDataStatus</Value>
</Value>
<Value name="5">
<Value>ensDataTaskFreq</Value>
</Value>
<Value name="6">
<Value>ensDataWeeks</Value>
</Value>
<Value name="7">
<Value>ensDataDays</Value>
</Value>
<Value name="8">
<Value>ensDataTimes</Value>
</Value>
<Value name="9">
<Value>ensDataNote</Value>
</Value>
</Data>
<DataLocation>^User.EnsSendDataInfoD</DataLocation>
<DefaultData>EnsSendDataInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.EnsSendDataInfoD</IdLocation>
<IndexLocation>^User.EnsSendDataInfoI</IndexLocation>
<StreamLocation>^User.EnsSendDataInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
