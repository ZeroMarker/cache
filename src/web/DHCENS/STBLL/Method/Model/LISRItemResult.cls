Class web.DHCENS.STBLL.Method.Model.LISRItemResult Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "LISRItemResult";

/// 化验项目代码
Property LISIRItemCode As %String(MAXLEN = 50);

/// 化验项目名称
Property LISIRItemDesc As %Library.String(MAXLEN = 100);

/// 结果 
Property LISIRResult As %Library.String(MAXLEN = 200);

/// 单位
Property LISIRUnit As %Library.String(MAXLEN = 50);

/// 定性结果
Property LISIRTextResult As %Library.String(MAXLEN = 200);

/// 扩展结果
Property LISIRExtraResult As %Library.String(MAXLEN = 40);

/// 结果说明
Property LISIRResultExplain As %Library.String(MAXLEN = 100);

/// 异常标志
Property LISIRAbnormalFlags As %String(MAXLEN = 5);

/// 参考范围
Property LISIRRanges As %Library.String(MAXLEN = 300);

/// 检测方法 
Property LISIRTestMethod As %Library.String(MAXLEN = 20);

/// 检测仪器
Property LISIRTestMachine As %Library.String(MAXLEN = 20);

/// 检测人代码
Property LISIRTestUserCode As %Library.String(MAXLEN = 50);

/// 检测人描述
Property LISIRTestUserDesc As %Library.String(MAXLEN = 100);

/// 显示序号
Property LISIRShowSeq As %Library.String(MAXLEN = 50);

/// 检测日期
Property LISIRTestDate As %Library.Date;

/// 检测时间
Property LISIRTestTime As %Library.Time(XMLTIMEZONE = "IGNORE");

/// 细菌计数 
Property LISIRCount As %Library.String(MAXLEN = 20);

/// 专家规则
Property LISIRExpertRule As %Library.String(MAXLEN = 1000);

/// 备注
Property LISIRRemark As %Library.String(MAXLEN = 1000);

/// 国际代码
Property LISIRInterCode As %Library.String(MAXLEN = 100);

/// 医嘱号
Property LISIROrderItemID As %Library.String(MAXLEN = 30);

/// 检测状态
Property LISIRAssayStatus As %String(MAXLEN = 10);

/// 复查次数
Property LISIRReAssayNum As %Library.String(MAXLEN = 30);

/// 结果类别 
Property LISIRResClass As %Library.String(MAXLEN = 10);

/// 细菌
Property LISIROrganism As %Library.String(MAXLEN = 30);

/// 复查号
Property LISIRReAssayNumber As %Library.String(MAXLEN = 10);

/// 是否多耐菌（1:true,0:false）
Property LISIRMultipleResistant As %Library.String(MAXLEN = 30);

/// 多耐菌群
Property LISIRMultipleResChild As %Library.String(MAXLEN = 50);

/// 结果说明
Property LISItemSenResultList As list Of web.DHCENS.STBLL.Method.Model.LISRItemSenResult(XMLNAME = "LISRItemSenResult", XMLPROJECTION = "ELEMENT");

/// 耐药信息
Property LISItemResRst As list Of web.DHCENS.STBLL.Method.Model.LISItemResRst(XMLNAME = "LISItemResRst", XMLPROJECTION = "ELEMENT");

}
