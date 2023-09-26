Import SQLUser

/// 创建时间		：2008.02.27
/// 创建人		：xuwm
/// 存在系统		：体检系统
/// 主要功能		: 更改检查结果模板顺序使用后删除此类
/// 
Class web.DHCPE.Report.UpdateTemplateSet Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 121;

/// d ##class(web.DHCPE.Report.UpdateTemplateSet).UpdateTemplateSet()
ClassMethod UpdateTemplateSet()
{
	s TextValID=""
	f  s TextValID=$o(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",TextValID))  q:TextValID=""  d 
    .s num=0
    .f  s num=$o(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",TextValID,num))  q:num=""  d 
    ..s TValue=$g(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",TextValID,num))
    ..s V1=$P(TValue,";",1)
    ..s V2=$P(TValue,";",2)
    ..s V3=$P(TValue,";",3)
    ..Q:(V3'["诊断意见")
    ..s TValue=V3_";"_V2_";"_V1
    ..s ^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",TextValID,num)=TValue
	Q 0
}

}
