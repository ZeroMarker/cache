/// creator:lulin
/// createdate:2020-02-14
/// description:系统自动获取不良事件数据表
Class DHCNS.Config.NsAutoAdv Extends %Persistent
{

/// 发生类型：管道滑脱、压疮、跌倒
Property AdvType As %String [ SqlColumnNumber = 2, SqlFieldName = AdvType ];

/// 发生日期：
Property HappenDate As %String [ SqlColumnNumber = 3, SqlFieldName = HappenDate ];

/// 发生时间
Property HappenTime As %String [ SqlColumnNumber = 4, SqlFieldName = HappenTime ];

/// 上报日期
Property ReportDate As %Date [ SqlColumnNumber = 5, SqlFieldName = ReportDate ];

/// 上报时间
Property ReportTime As %Time [ SqlColumnNumber = 6, SqlFieldName = ReportTime ];

/// 填写日期
Property EditDate As %String [ SqlColumnNumber = 7, SqlFieldName = EditDate ];

/// 填写时间
Property EditTime As %String [ SqlColumnNumber = 8, SqlFieldName = EditTime ];

/// 唯一编码
Property DataId As %String [ SqlColumnNumber = 9, SqlFieldName = DataId ];

/// 状态EXT:V:未上报，V2:已退回，S1:已上报，S2:评价中，A:已审核，C:作废
/// 新产品组:"未接收":未接收,1:接收,2:驳回,3:撤销,4:审核,5:归档,6:撤销归档,C:作废
Property DataStatus As %String [ SqlColumnNumber = 10, SqlFieldName = DataStatus ];

/// 发生病人就诊号
Property EpisodeId As %String [ SqlColumnNumber = 11, SqlFieldName = EpisodeId ];

/// 发生病人病案号
Property PaRecord As %String [ SqlColumnNumber = 12, SqlFieldName = PaRecord ];

/// 发生病人姓名
Property PaName As %String [ SqlColumnNumber = 13, SqlFieldName = PaName ];

/// 发生病人性别
Property PaSex As %String [ SqlColumnNumber = 14, SqlFieldName = PaSex ];

/// 病人所在病区，根据病人病案号，取PAADM获取最好，此项此处不再使用【注销】
Property PaWard As %String [ SqlColumnNumber = 15, SqlFieldName = PaWard ];

/// 当事人姓名
Property ReprtorName As %String [ SqlColumnNumber = 16, SqlFieldName = ReprtorName ];

/// 当事人参加年限
Property ReprtorYear As %String [ SqlColumnNumber = 17, SqlFieldName = ReprtorYear ];

/// 当事人职称
Property ReprtorTitle As %String [ SqlColumnNumber = 18, SqlFieldName = ReprtorTitle ];

/// 伤害程度
Property Degree As %String(MAXLEN = 2000) [ SqlColumnNumber = 19, SqlFieldName = Degree ];

/// 压疮级别
Property UlcerLevel As %String [ SqlColumnNumber = 20, SqlFieldName = UlcerLevel ];

/// 压疮部位
Property UlcerPosition As %String [ SqlColumnNumber = 21, SqlFieldName = UlcerPosition ];

/// 压疮部位数
Property UlcerPNum As %String [ SqlColumnNumber = 22, SqlFieldName = UlcerPNum ];

/// 明细备注
Property Remark As %String [ SqlColumnNumber = 23, SqlFieldName = Remark ];

/// 上报科室名称
Property ReportLocDesc As %String [ SqlColumnNumber = 24, SqlFieldName = ReportLocDesc ];

/// 上报病区名称
Property ReportWardDesc As %String [ SqlColumnNumber = 25, SqlFieldName = ReportWardDesc ];

/// 非计划拔管类型，多个逗号间隔
Property AdvGlideType As %String [ SqlColumnNumber = 26, SqlFieldName = AdvGlideType ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 27, SqlFieldName = UpdateDate ];

/// 上报科室ctlocId【新产品组用的ctlocid】
Property ReportLocId As %String [ SqlColumnNumber = 28, SqlFieldName = ReportLocId ];

/// 压疮来源情况
Property UlcerPart As %String [ SqlColumnNumber = 29, SqlFieldName = UlcerPart ];

Index Index On DataId;

Index DateType On (ReportDate, AdvType);

Index TypeDate On (AdvType, ReportDate);

Storage Default
{
<Data name="NsAutoAdvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdvType</Value>
</Value>
<Value name="3">
<Value>HappenDate</Value>
</Value>
<Value name="4">
<Value>HappenTime</Value>
</Value>
<Value name="5">
<Value>ReportDate</Value>
</Value>
<Value name="6">
<Value>ReportTime</Value>
</Value>
<Value name="7">
<Value>EditDate</Value>
</Value>
<Value name="8">
<Value>EditTime</Value>
</Value>
<Value name="9">
<Value>DataId</Value>
</Value>
<Value name="10">
<Value>DataStatus</Value>
</Value>
<Value name="11">
<Value>EpisodeId</Value>
</Value>
<Value name="12">
<Value>PaRecord</Value>
</Value>
<Value name="13">
<Value>PaName</Value>
</Value>
<Value name="14">
<Value>PaSex</Value>
</Value>
<Value name="15">
<Value>PaWard</Value>
</Value>
<Value name="16">
<Value>ReprtorName</Value>
</Value>
<Value name="17">
<Value>ReprtorYear</Value>
</Value>
<Value name="18">
<Value>ReprtorTitle</Value>
</Value>
<Value name="19">
<Value>Degree</Value>
</Value>
<Value name="20">
<Value>UlcerLevel</Value>
</Value>
<Value name="21">
<Value>UlcerPosition</Value>
</Value>
<Value name="22">
<Value>UlcerPNum</Value>
</Value>
<Value name="23">
<Value>Remark</Value>
</Value>
<Value name="24">
<Value>ReportLocDesc</Value>
</Value>
<Value name="25">
<Value>ReportWardDesc</Value>
</Value>
<Value name="26">
<Value>AdvGlideType</Value>
</Value>
<Value name="27">
<Value>UpdateDate</Value>
</Value>
<Value name="28">
<Value>ReportLocId</Value>
</Value>
<Value name="29">
<Value>UlcerPart</Value>
</Value>
</Data>
<DataLocation>^DHCNS.Config.NsAutoAdvD</DataLocation>
<DefaultData>NsAutoAdvDefaultData</DefaultData>
<IdLocation>^DHCNS.Config.NsAutoAdvD</IdLocation>
<IndexLocation>^DHCNS.Config.NsAutoAdvI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsAutoAdvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
