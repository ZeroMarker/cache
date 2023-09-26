Class BILL.CES.PO.DHCExportLog Extends %Persistent [ SqlRowIdName = EL_RowId, SqlTableName = DHC_ExportLog ]
{

Property ELTerminalNo As %Library.String(CAPTION = "终端号码(即机器码)") [ Required ];

Property ELCreateDate As %Date(CAPTION = "日志生成日期");

Property ELCreateTime As %Time(CAPTION = "日志生成时间");

/// 同步状态（B:同步中,S:同步成功,F:失败)
Property ELStatus As %Library.String(CAPTION = "同步状态") [ Required ];

Property ELEndDate As %Date(CAPTION = "结束日期");

Property ELEndTime As %Time(CAPTION = "结束时间");

Property ELMsg As %String(CAPTION = "备注信息", MAXLEN = 5000);

Index IDXTNoDate On (ELTerminalNo As Exact, ELCreateDate As Exact);

Index IDXTNo On ELTerminalNo As Exact;

Index IDXDate On ELCreateDate;

Storage Default
{
<Data name="DHCExportLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ELTerminalNo</Value>
</Value>
<Value name="3">
<Value>ELCreateDate</Value>
</Value>
<Value name="4">
<Value>ELCreateTime</Value>
</Value>
<Value name="5">
<Value>ELStatus</Value>
</Value>
<Value name="6">
<Value>ELEndDate</Value>
</Value>
<Value name="7">
<Value>ELEndTime</Value>
</Value>
<Value name="8">
<Value>ELMsg</Value>
</Value>
</Data>
<DataLocation>^BILL.CES.PO.DHCExportLogD</DataLocation>
<DefaultData>DHCExportLogDefaultData</DefaultData>
<IdLocation>^BILL.CES.PO.DHCExportLogD</IdLocation>
<IndexLocation>^BILL.CES.PO.DHCExportLogI</IndexLocation>
<StreamLocation>^BILL.CES.PO.DHCExportLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
