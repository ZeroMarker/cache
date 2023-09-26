/// 科室站点项目扩展表（DHC_PE_StationOrderSet）
Class User.DHCPEStationOrderSet Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_StationOrderSet ]
{

Parameter ClassName = "User.DHCPEStationOrderSet";

/// 站点项目
Property SOSOrderDR As User.DHCPEStationOrder [ Required, SqlFieldName = SOS_OrderDR ];

/// 科室 指向CT_Loc
Property SOSLocDR As %String [ Required, SqlFieldName = SOS_LocDR ];

/// 就餐标志（餐前,餐后,不限）
Property SOSDiet As %String [ SqlFieldName = SOS_Diet ];

/// 报告格式（RF-NOR普通、RF-CAT多层、RF-LIS检验、RF-RIS检查、RF-EKG、RF-PIS）
Property SOSReportFormat As %String [ SqlFieldName = SOS_ReportFormat ];

/// 注意事项
Property SOSNotice As %String [ SqlFieldName = SOS_Notice ];

/// 自动回传结果
Property SOSAutoReturn As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SOS_AutoReturn ];

/// 顺序号
Property SOSSort As %Integer [ SqlFieldName = SOS_Sort ];

/// 性别 指向CT_Sex
Property SOSSexDR As %String [ SqlFieldName = SOS_SexDR ];

/// 婚姻 指向CT_Marital
Property SOSMarriedDR As %String [ SqlFieldName = SOS_MarriedDR ];

/// 年龄上限
Property SOSAgeMax As %Integer [ SqlFieldName = SOS_AgeMax ];

/// 年龄下限
Property SOSAgeMin As %Integer [ SqlFieldName = SOS_AgeMin ];

/// VIP等级
Property SOSVIPLevelDR As User.DHCPEVIPLevel [ SqlFieldName = SOS_VIPLevelDR ];

/// 基本信息条码
Property SOSBaseInfoBar As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SOS_BaseInfoBar ];

/// 允许重复
Property SOSAlowAddFlag As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SOS_AlowAddFlag ];

/// 病理标本类型 指向DHC_AppTestSpec
Property SOSPisCodeDR As %String [ SqlFieldName = SOS_PisCodeDR ];

/// 预约限额
Property SOSPreNum As %Integer [ SqlFieldName = SOS_PreNum ];

/// 模板名称
Property SOSTempName As %String [ SqlFieldName = SOS_TempName ];

/// 乙肝
Property SOSYGFlag As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SOS_YGFlag ];

/// 特殊检查
Property SOSSignItem As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SOS_SignItem ];

/// 禁用
Property SOSShowOrHide As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SOS_ShowOrHide ];

/// 继承
Property SOSExtend As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SOS_Extend ];

/// 是否有片子
Property SOSPhoto As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SOS_Photo ];

/// 是否打印（报告）
Property SOSIFReprotPrint As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SOS_IFReprotPrint ];

/// 条码数量
Property SOSBarPrintNum As %Integer [ SqlFieldName = SOS_BarPrintNum ];

/// 注意
Property SOSNoticeInfo As %String(MAXLEN = 200) [ SqlFieldName = SOS_NoticeInfo ];

/// 导诊单项目分类
Property SOSUsherItemCatDR As User.DHCPEUsherItemCat [ SqlFieldName = SOS_UsherItemCatDR ];

/// 导诊单上项目打印顺序
Property SOSUsherSort As %Integer [ SqlFieldName = SOS_UsherSort ];

/// 导诊单上项目是否打印
Property SOSUsherIsPrint As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SOS_UsherIsPrint ];

/// 导诊单上项目打印名称
Property SOSUsherPrtName As %String(MAXLEN = 100) [ SqlFieldName = SOS_UsherPrtName ];

/// 作废标记
Property SOSNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SOS_NoActive ];

/// 更新日期
Property SOSUpdateDate As %Date [ SqlFieldName = SOS_UpdateDate ];

/// 更新时间
Property SOSUpdateTime As %Time [ SqlFieldName = SOS_UpdateTime ];

/// 更新人 指向SS_User
Property SOSUpdateUserDR As %String [ SqlFieldName = SOS_UpdateUserDR ];

/// 费用类别 指向PAC_EpisodeSubType
Property SOSPatFeeTypeDR As User.PACEpisodeSubType [ SqlFieldName = SOS_PatFeeTypeDR ];

/// 不打折 
Property SOSNoDiscount As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SOS_NoDiscount ];

/// 剂量
Property SOSDoseQty As %Float [ SqlFieldName = SOS_DoseQty ];

/// 剂量单位
Property SOSDoseUOMDR As User.CTUOM [ SqlFieldName = SOS_DoseUOMDR ];

/// 频次
Property SOSFreqDR As User.PHCFreq [ SqlFieldName = SOS_FreqDR ];

/// 用法
Property SOSInstrucDR As User.PHCInstruc [ SqlFieldName = SOS_InstrucDR ];

/// 疗程
Property SOSDuratDR As User.PHCDuration [ SqlFieldName = SOS_DuratDR ];

/// 检查合并打印
Property SOSPrintType As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SOS_PrintType ];

/// 检查目的
Property SOSPurpose As %String(MAXLEN = 200) [ SqlFieldName = SOS_Purpose ];

/// 网络预约
Property SOSNetPreFlag As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SOS_NetPreFlag ];

/// 科室+站点项目 索引
Index IdxOfLocOrder On (SOSLocDR, SOSOrderDR);

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SOSOrderDR</Value>
</Value>
<Value name="3">
<Value>SOSLocDR</Value>
</Value>
<Value name="4">
<Value>SOSDiet</Value>
</Value>
<Value name="5">
<Value>SOSReportFormat</Value>
</Value>
<Value name="6">
<Value>SOSNotice</Value>
</Value>
<Value name="7">
<Value>SOSAutoReturn</Value>
</Value>
<Value name="8">
<Value>SOSSort</Value>
</Value>
<Value name="9">
<Value>SOSSexDR</Value>
</Value>
<Value name="10">
<Value>SOSMarriedDR</Value>
</Value>
<Value name="11">
<Value>SOSAgeMax</Value>
</Value>
<Value name="12">
<Value>SOSAgeMin</Value>
</Value>
<Value name="13">
<Value>SOSVIPLevelDR</Value>
</Value>
<Value name="14">
<Value>SOSBaseInfoBar</Value>
</Value>
<Value name="15">
<Value>SOSAlowAddFlag</Value>
</Value>
<Value name="16">
<Value>SOSPisCodeDR</Value>
</Value>
<Value name="17">
<Value>SOSPreNum</Value>
</Value>
<Value name="18">
<Value>SOSTempName</Value>
</Value>
<Value name="19">
<Value>SOSYGFlag</Value>
</Value>
<Value name="20">
<Value>SOSSignItem</Value>
</Value>
<Value name="21">
<Value>SOSShowOrHide</Value>
</Value>
<Value name="22">
<Value>SOSExtend</Value>
</Value>
<Value name="23">
<Value>SOSPhoto</Value>
</Value>
<Value name="24">
<Value>SOSIFReprotPrint</Value>
</Value>
<Value name="25">
<Value>SOSBarPrintNum</Value>
</Value>
<Value name="26">
<Value>SOSNoticeInfo</Value>
</Value>
<Value name="27">
<Value>SOSUsherItemCatDR</Value>
</Value>
<Value name="28">
<Value>SOSUsherSort</Value>
</Value>
<Value name="29">
<Value>SOSUsherIsPrint</Value>
</Value>
<Value name="30">
<Value>SOSUsherPrtName</Value>
</Value>
<Value name="31">
<Value>SOSNoActive</Value>
</Value>
<Value name="32">
<Value>SOSUpdateDate</Value>
</Value>
<Value name="33">
<Value>SOSUpdateTime</Value>
</Value>
<Value name="34">
<Value>SOSUpdateUserDR</Value>
</Value>
<Value name="35">
<Value>SOSPatFeeTypeDR</Value>
</Value>
<Value name="36">
<Value>SOSNoDiscount</Value>
</Value>
<Value name="37">
<Value>SOSDoseQty</Value>
</Value>
<Value name="38">
<Value>SOSDoseUOMDR</Value>
</Value>
<Value name="39">
<Value>SOSFreqDR</Value>
</Value>
<Value name="40">
<Value>SOSInstrucDR</Value>
</Value>
<Value name="41">
<Value>SOSDuratDR</Value>
</Value>
<Value name="42">
<Value>SOSPrintType</Value>
</Value>
<Value name="43">
<Value>SOSPurpose</Value>
</Value>
<Value name="44">
<Value>SOSNetPreFlag</Value>
</Value>
</Data>
<DataLocation>^CF.PE.StationOrderSetD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.StationOrderSetD</IdLocation>
<IndexLocation>^CF.PE.StationOrderSetI</IndexLocation>
<StreamLocation>^User.DHCPEStationOrderSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
