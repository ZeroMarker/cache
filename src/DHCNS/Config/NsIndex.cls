/// creator:lulin
/// createdate:2019-12-04
/// description:指标
Class DHCNS.Config.NsIndex Extends %Persistent
{

Relationship ChildSub As DHCNS.Config.NsIndexSub [ Cardinality = children, Inverse = Parref ];

/// 指标类别
Property IndexType As DHCNS.Config.NsTypeSet [ SqlColumnNumber = 2, SqlFieldName = IndexType ];

/// 指标描述
Property IndexDesc As %String [ SqlColumnNumber = 3, SqlFieldName = IndexDesc ];

/// 级别:H:院，L:科,W:病区
Property IndexLevel As %String [ SqlColumnNumber = 4, SqlFieldName = IndexLevel ];

/// 频率-D:日、W:周、M:月、Q:季、H:半年、Y:年【弃用】
Property Rate As %String [ SqlColumnNumber = 5, SqlFieldName = Rate ];

/// 单位T:‰，P：％
Property Unit As %String [ SqlColumnNumber = 6, SqlFieldName = Unit ];

/// 小数位数
Property Decimals As %String [ SqlColumnNumber = 7, SqlFieldName = Decimals ];

/// 指标趋势F:正向趋势,N:负向趋势
Property Trend As %String [ SqlColumnNumber = 8, SqlFieldName = Trend ];

/// 运算类型A:∑分子/∑分母
Property OperateType As %String [ SqlColumnNumber = 9, SqlFieldName = OperateType ];

/// 状态:Y启动，N:停用
Property Status As %String [ SqlColumnNumber = 10, SqlFieldName = Status ];

/// 说明
Property Remark As %String [ SqlColumnNumber = 11, SqlFieldName = Remark ];

/// 图标样式：L:折线图
Property IconStyle As %String [ SqlColumnNumber = 12, SqlFieldName = IconStyle ];

/// 关联评审
Property Review As list Of %String [ SqlColumnNumber = 13, SqlFieldName = Review ];

/// 分子名称
Property NumName As %String [ SqlColumnNumber = 14, SqlFieldName = NumName ];

/// 分母名称
Property DenName As %String [ SqlColumnNumber = 15, SqlFieldName = DenName ];

/// 阈值S:依据去年同期值调整标准值,L:依据上个月数值调整标准值,C:自定义"
Property ThreTshold As %String [ SqlColumnNumber = 16, SqlFieldName = ThreTshold ];

/// 参考标准值
Property Standard As %String [ SqlColumnNumber = 17, SqlFieldName = Standard ];

/// 目标S:依据去年同期,L:依据上月同期,C:自定义"
Property Target As %String [ SqlColumnNumber = 18, SqlFieldName = Target ];

/// 目标自定义值
Property TargetValue As %String [ SqlColumnNumber = 19, SqlFieldName = TargetValue ];

/// 上限S:依据目标值,C:自定义
Property IndexUpper As %String [ SqlColumnNumber = 20, SqlFieldName = IndexUpper ];

/// 上限自定义值
Property UpperValue As %String [ SqlColumnNumber = 21, SqlFieldName = UpperValue ];

/// 下限
Property IndexLower As %String [ SqlColumnNumber = 22, SqlFieldName = IndexLower ];

/// 下线自定义值
Property LowerValue As %String [ SqlColumnNumber = 23, SqlFieldName = LowerValue ];

/// 指标异常通知人员
Property ExcepTableData As list Of %String [ SqlColumnNumber = 24, SqlFieldName = ExcepTableData ];

/// 指标预警通知人员
Property WarnTableData As list Of %String [ SqlColumnNumber = 25, SqlFieldName = WarnTableData ];

/// 指标停用通知人员
Property StopTableData As list Of %String [ SqlColumnNumber = 26, SqlFieldName = StopTableData ];

/// 阶段性数据获取计算方式：A:期初/期末,S:和值【弃用】
Property DualType As %String [ SqlColumnNumber = 27, SqlFieldName = DualType ];

/// 分子额外数
Property NumOther As list Of %String [ SqlColumnNumber = 28, SqlFieldName = NumOther ];

/// 分母额外数
Property DenOther As list Of %String [ SqlColumnNumber = 29, SqlFieldName = DenOther ];

/// 全院过滤转入:Y启动，N/"":停用
Property TransStatus As %String [ SqlColumnNumber = 30, SqlFieldName = TransStatus ];

Index Status On Status;

Storage Default
{
<Data name="NsIndexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IndexType</Value>
</Value>
<Value name="3">
<Value>IndexDesc</Value>
</Value>
<Value name="4">
<Value>IndexLevel</Value>
</Value>
<Value name="5">
<Value>Rate</Value>
</Value>
<Value name="6">
<Value>Unit</Value>
</Value>
<Value name="7">
<Value>Decimals</Value>
</Value>
<Value name="8">
<Value>Trend</Value>
</Value>
<Value name="9">
<Value>OperateType</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>Remark</Value>
</Value>
<Value name="12">
<Value>IconStyle</Value>
</Value>
<Value name="13">
<Value>Review</Value>
</Value>
<Value name="14">
<Value>NumName</Value>
</Value>
<Value name="15">
<Value>DenName</Value>
</Value>
<Value name="16">
<Value>ThreTshold</Value>
</Value>
<Value name="17">
<Value>Standard</Value>
</Value>
<Value name="18">
<Value>Target</Value>
</Value>
<Value name="19">
<Value>TargetValue</Value>
</Value>
<Value name="20">
<Value>IndexUpper</Value>
</Value>
<Value name="21">
<Value>UpperValue</Value>
</Value>
<Value name="22">
<Value>IndexLower</Value>
</Value>
<Value name="23">
<Value>LowerValue</Value>
</Value>
<Value name="24">
<Value>ExcepTableData</Value>
</Value>
<Value name="25">
<Value>WarnTableData</Value>
</Value>
<Value name="26">
<Value>StopTableData</Value>
</Value>
<Value name="27">
<Value>DualType</Value>
</Value>
<Value name="28">
<Value>NumOther</Value>
</Value>
<Value name="29">
<Value>DenOther</Value>
</Value>
<Value name="30">
<Value>TransStatus</Value>
</Value>
</Data>
<DataLocation>^DHCNS.Config.NsIndexD</DataLocation>
<DefaultData>NsIndexDefaultData</DefaultData>
<IdLocation>^DHCNS.Config.NsIndexD</IdLocation>
<IndexLocation>^DHCNS.Config.NsIndexI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsIndexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
