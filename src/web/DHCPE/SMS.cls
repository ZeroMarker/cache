Import SQLUser

/// 创建时间		：2007.04.12
/// 创建人			：xuwm
/// 存在系统		：体检系统
/// 关联数据		: 
/// 索引			: 
/// 主要功能		：短信系统
/// 主要功能		：
/// 最后修改时间	：
/// 最后修改人		：
/// 文件状态		: 未完成
/// 
Class web.DHCPE.SMS Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 27;

ClassMethod GetSMSMessage(SMSType As %String)
{
	
	s Message=""
	i "ReportComplete"=SMSType  d
	.s Message="尊敬的"_$G(^TMPReport("PatInfo","PatName"))
	.i ($G(^TMPReport("PatInfo","PatSex"))["男") d
	..s Message=Message_"先生"
	.
	.i ($G(^TMPReport("PatInfo","PatSex"))["女") d
	..s Message=Message_"女士"
	.
	.s Message=Message_"您的报告已完成请及时领取"_$C(13)_$C(10)
	.s Message=Message_$P($G(^DHCPESetting("DHCPE","ReportTitle")),"-",2)
	.
	
	Q Message
}

}
