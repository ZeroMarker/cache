Import SQLUser

/// 取电子病历诊断或临床诊断
/// by wuqk 2008-05-13
Class web.DHCWMRMedBaseDiagnose Extends (%Library.RegisteredObject, websys.Abstract) [ Not ProcedureBlock ]
{

Parameter BUILD = 103;

/// ------add by wuqk 2008-05-13------
/// 设置当前医院病案编目时取HIS诊断的数据来源
/// ^DHCWMRDiaSetting("DIA")
/// 0：取MR_Diagnos
/// 1：取电子病历版本1的首页诊断
/// 2：取电子病历版本2的首页诊断
/// 
/// ^DHCWMRDiaSetting("DIA",Index)
/// 电子病历诊断各个字段对应的元数据代码与取法,^分隔
/// 诊断描述^ICD代码
/// d ##Class(web.DHCWMRMedBaseDiagnose).SetDHCWMRDiaSetting()
ClassMethod SetDHCWMRDiaSetting()
{
	//共四个字段,以“^”分割
	//诊断名称^诊断代码(ICD10)^怀疑诊断类型^出院情况
	set ^DHCWMRDiaSetting("DIA")=2
	set HospCode=##class(web.DHCWMRMedBase01).GetDefaultHospCode()
	//安徽省立医院南区取EPR诊断信息 元数据代码
	if (HospCode="AnHui_SLYY_NQ") {
		set ^DHCWMRDiaSetting("DIA")=2
		set ^DHCWMRDiaSetting("DIA",1)="主要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0002#VTYPE:V^主要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0002#VTYPE:V^^出院情况主要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:O0024#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",2)="次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0003#VTYPE:V^次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0003#VTYPE:V^^出院情况次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:O0025#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",3)="次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0009#VTYPE:V^次要诊断2#TYPE:Simple#TID:2#TVER:0#SCODE:I0009#VTYPE:V^^出院情况次要诊断2#TYPE:Simple#TID:2#TVER:0#SCODE:O0026#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",4)="次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0010#VTYPE:V^次要诊断3#TYPE:Simple#TID:2#TVER:0#SCODE:I0010#VTYPE:V^^出院情况次要诊断3#TYPE:Simple#TID:2#TVER:0#SCODE:O0027#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",5)="次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0011#VTYPE:V^次要诊断4#TYPE:Simple#TID:2#TVER:0#SCODE:I0011#VTYPE:V^^出院情况次要诊断4#TYPE:Simple#TID:2#TVER:0#SCODE:O0028#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",6)="次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0012#VTYPE:V^次要诊断5#TYPE:Simple#TID:2#TVER:0#SCODE:I0012#VTYPE:V^^出院情况次要诊断5#TYPE:Simple#TID:2#TVER:0#SCODE:O0029#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",7)="次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0013#VTYPE:V^次要诊断6#TYPE:Simple#TID:2#TVER:0#SCODE:I0013#VTYPE:V^^出院情况次要诊断6#TYPE:Simple#TID:2#TVER:0#SCODE:O0030#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",8)="次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0036#VTYPE:^次要诊断7#TYPE:Simple#TID:2#TVER:0#SCODE:I0036#VTYPE:^^出院情况次要诊断7#TYPE:Simple#TID:2#TVER:0#SCODE:O0031#VTYPE:V"
	}
	//上海市东方医院取EPR诊断信息 元数据代码
	if (HospCode="ShangHai_DF") {
		set ^DHCWMRDiaSetting("DIA")=2
		set ^DHCWMRDiaSetting("DIA",1)="主要诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0057#VTYPE:V^主要诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0057#VTYPE:V^^出院情况#TYPE:Simple#TID:57#TVER:0#SCODE:O0042#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",2)="次要诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0056#VTYPE:V^次要诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0056#VTYPE:V^^出院情况#TYPE:Simple#TID:57#TVER:0#SCODE:O0043#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",3)="次要诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0055#VTYPE:V^次要诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0055#VTYPE:V^^出院情况#TYPE:Simple#TID:57#TVER:0#SCODE:O0044#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",4)="次要诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0054#VTYPE:V^次要诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0054#VTYPE:V^^出院情况#TYPE:Simple#TID:57#TVER:0#SCODE:O0045#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",5)="次要诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0053#VTYPE:V^次要诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0053#VTYPE:V^^出院情况#TYPE:Simple#TID:57#TVER:0#SCODE:O0046#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",6)="次要诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0052#VTYPE:V^次要诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0052#VTYPE:V^^出院情况6#TYPE:Simple#TID:57#TVER:0#SCODE:O0047#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",7)="次要诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0051#VTYPE:V^次要诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0051#VTYPE:V^^出院情况#TYPE:Simple#TID:57#TVER:0#SCODE:O0048#VTYPE:V"
		
		set ^DHCWMRDiaSetting("DIA",8)="病理诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0059#VTYPE:V^病理诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0059#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",9)="医院感染诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0060#VTYPE:V^医院感染诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0060#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",10)="损伤中毒诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0062#VTYPE:V^损伤中毒诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0062#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",11)="门急诊诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0035#VTYPE:V^门(急)诊诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0035#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",12)="入院诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0037#VTYPE:V^入院诊断#TYPE:Simple#TID:57#TVER:0#SCODE:I0037#VTYPE:V^^"
		;set ^DHCWMRDiaSetting("DIA",22)="入院诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0078#VTYPE:V^入院诊断2#TYPE:Simple#TID:1#TVER:0#SCODE:I0078#VTYPE:V^^"
}
	//长春吉大三院(中日联合医院)取EPR诊断信息 元数据代码
	if (HospCode="ChangChun_JDSY") {
		set ^DHCWMRDiaSetting("DIA")=2
		set ^DHCWMRDiaSetting("DIA",1)="主要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0002#VTYPE:V^主要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0002#VTYPE:V^怀疑诊断类型1#TYPE:Simple#TID:2#TVER:0#SCODE:O0095#VTYPE:V^主要诊断出院情况#TYPE:Simple#TID:2#TVER:0#SCODE:O0024#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",2)="其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0003#VTYPE:V^其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0003#VTYPE:V^怀疑诊断类型2#TYPE:Simple#TID:2#TVER:0#SCODE:O0096#VTYPE:V^其它诊断出院情况2#TYPE:Simple#TID:2#TVER:0#SCODE:O0025#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",3)="其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0009#VTYPE:V^其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0009#VTYPE:V^怀疑诊断类型3#TYPE:Simple#TID:2#TVER:0#SCODE:O0097#VTYPE:V^其它诊断出院情况3#TYPE:Simple#TID:2#TVER:0#SCODE:O0026#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",4)="其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0010#VTYPE:V^其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0010#VTYPE:V^怀疑诊断类型4#TYPE:Simple#TID:2#TVER:0#SCODE:O0106#VTYPE:V^其它诊断出院情况4#TYPE:Simple#TID:2#TVER:0#SCODE:O0027#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",5)="其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0011#VTYPE:V^其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0011#VTYPE:V^怀疑诊断类型5#TYPE:Simple#TID:2#TVER:0#SCODE:O0105#VTYPE:V^其它诊断出院情况5#TYPE:Simple#TID:2#TVER:0#SCODE:O0028#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",6)="其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0012#VTYPE:V^其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0012#VTYPE:V^怀疑诊断类型6#TYPE:Simple#TID:2#TVER:0#SCODE:O0104#VTYPE:V^其它诊断出院情况6#TYPE:Simple#TID:2#TVER:0#SCODE:O0029#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",7)="其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0013#VTYPE:V^其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0013#VTYPE:V^怀疑诊断类型7#TYPE:Simple#TID:2#TVER:0#SCODE:O0103#VTYPE:V^其它诊断出院情况7#TYPE:Simple#TID:2#TVER:0#SCODE:O0030#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",8)="其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0036#VTYPE:V^其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0036#VTYPE:V^怀疑诊断类型8#TYPE:Simple#TID:2#TVER:0#SCODE:O0098#VTYPE:V^其它诊断出院情况8#TYPE:Simple#TID:2#TVER:0#SCODE:O0031#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",9)="其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0109#VTYPE:V^其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0109#VTYPE:V^怀疑诊断类型9#TYPE:Simple#TID:2#TVER:0#SCODE:O0102#VTYPE:V^其它诊断出院情况9#TYPE:Simple#TID:2#TVER:0#SCODE:O0113#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",10)="其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0110#VTYPE:V^其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0110#VTYPE:V^怀疑诊断类型10#TYPE:Simple#TID:2#TVER:0#SCODE:O0101#VTYPE:V^其它诊断出院情况10#TYPE:Simple#TID:2#TVER:0#SCODE:O0112#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",11)="其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0108#VTYPE:V^其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0108#VTYPE:V^怀疑诊断类型11#TYPE:Simple#TID:2#TVER:0#SCODE:O0100#VTYPE:V^其它诊断出院情况11#TYPE:Simple#TID:2#TVER:0#SCODE:O0117#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",12)="其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0107#VTYPE:V^其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0107#VTYPE:V^怀疑诊断类型12#TYPE:Simple#TID:2#TVER:0#SCODE:O0099#VTYPE:V^其它诊断出院情况12#TYPE:Simple#TID:2#TVER:0#SCODE:O0111#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",13)="其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0037#VTYPE:V^其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0037#VTYPE:V^怀疑诊断类型13#TYPE:Simple#TID:2#TVER:0#SCODE:O0119#VTYPE:V^其它诊断出院情况13#TYPE:Simple#TID:2#TVER:0#SCODE:O0116#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",14)="其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0035#VTYPE:V^其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0035#VTYPE:V^怀疑诊断类型14#TYPE:Simple#TID:2#TVER:0#SCODE:O0127#VTYPE:V^其它诊断出院情况14#TYPE:Simple#TID:2#TVER:0#SCODE:O0032#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",15)="其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0090#VTYPE:V^其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0090#VTYPE:V^怀疑诊断类型15#TYPE:Simple#TID:2#TVER:0#SCODE:O0126#VTYPE:V^其它诊断出院情况15#TYPE:Simple#TID:2#TVER:0#SCODE:O0123#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",16)="其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0038#VTYPE:V^其它诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0038#VTYPE:V^怀疑诊断类型16#TYPE:Simple#TID:2#TVER:0#SCODE:O0125#VTYPE:V^其它诊断出院情况16#TYPE:Simple#TID:2#TVER:0#SCODE:O0124#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",17)="病理诊断#TYPE:Simple#TID:2#TVER:0#SCODE:S0094#VTYPE:V^病理诊断#TYPE:Simple#TID:2#TVER:0#SCODE:S0094#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",18)="感染诊断#TYPE:Simple#TID:2#TVER:0#SCODE:S0079#VTYPE:V^感染诊断#TYPE:Simple#TID:2#TVER:0#SCODE:S0079#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",19)="损伤中毒诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0034#VTYPE:V^损伤中毒诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0034#VTYPE:V^^"
		
		set ^DHCWMRDiaSetting("DIA",20)="门急诊诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0043#VTYPE:V^门急诊诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0043#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",21)="入院诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0078#VTYPE:V^入院诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0078#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",22)="入院诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0044#VTYPE:V^入院诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0044#VTYPE:V^^"
	}
	
	//潍坊市人民医院取EPR诊断信息 元数据代码
	if (HospCode="WeiFang_RMYY") {
		set ^DHCWMRDiaSetting("DIA",1)="门急诊诊断#TYPE:Simple#TID:141#TVER:0#SCODE:I0035#VTYPE:V^病案摘要.病案首页.一般情况.一般情况.门(急)诊诊断#TYPE:Simple#TID:141#TVER:0#SCODE:I0035#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",2)="入院诊断#TYPE:Simple#TID:141#TVER:0#SCODE:I0037#VTYPE:V^病案摘要.病案首页.一般情况.一般情况.入院诊断#TYPE:Simple#TID:141#TVER:0#SCODE:I0037#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",3)="主要诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0003#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.主要诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0003#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况主要诊断#TYPE:Simple#TID:142#TVER:0#SCODE:O0014#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",4)="其他诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0004#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.其他诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0004#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况其他诊断#TYPE:Simple#TID:142#TVER:0#SCODE:O0015#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",5)="其他诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0005#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.次要诊断1#TYPE:Simple#TID:142#TVER:0#SCODE:I0005#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况次要诊断1#TYPE:Simple#TID:142#TVER:0#SCODE:O0016#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",6)="其他诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0006#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.次要诊断2#TYPE:Simple#TID:142#TVER:0#SCODE:I0006#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况次要诊断2#TYPE:Simple#TID:142#TVER:0#SCODE:O0017#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",7)="其他诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0007#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.次要诊断3#TYPE:Simple#TID:142#TVER:0#SCODE:I0007#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况次要诊断3#TYPE:Simple#TID:142#TVER:0#SCODE:O0018#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",8)="其他诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0008#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.次要诊断4#TYPE:Simple#TID:142#TVER:0#SCODE:I0008#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况次要诊断4#TYPE:Simple#TID:142#TVER:0#SCODE:O0019#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",9)="其他诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0009#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.次要诊断5#TYPE:Simple#TID:142#TVER:0#SCODE:I0009#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况次要诊断5#TYPE:Simple#TID:142#TVER:0#SCODE:O0020#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",10)="院内感染诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0044#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.医院感染名称#TYPE:Simple#TID:142#TVER:0#SCODE:I0044#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况医院感染#TYPE:Simple#TID:142#TVER:0#SCODE:O0045#VTYPE:V"

		set ^DHCWMRDiaSetting("DIA",11)="病理诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0011#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.病理诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0011#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",12)="损伤中毒诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0012#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.损伤、中毒的外部因素#TYPE:Simple#TID:142#TVER:0#SCODE:I0012#VTYPE:V^^"
		
	}
	
	//中国医科大学附属第一医院 元数据代码
	if (HospCode="ShenYang_YDYFY") {
		set ^DHCWMRDiaSetting("DIA")=2
		
		set ^DHCWMRDiaSetting("DIA",1)="主要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0002#VTYPE:V^主要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0002#VTYPE:V^^主要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:O0024#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",2)="次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0003#VTYPE:V^次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0003#VTYPE:V^^次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:O0025#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",3)="次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0009#VTYPE:V^次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0009#VTYPE:V^^次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:O0026#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",4)="次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0010#VTYPE:V^次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0010#VTYPE:V^^次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:O0027#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",5)="次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0011#VTYPE:V^次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0011#VTYPE:V^^次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:O0028#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",6)="次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0012#VTYPE:V^次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0012#VTYPE:V^^次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:O0029#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",7)="次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0013#VTYPE:V^次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0013#VTYPE:V^^次要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:O0030#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",8)="并发症#TYPE:Simple#TID:2#TVER:0#SCODE:I0097#VTYPE:V^并发症#TYPE:Simple#TID:2#TVER:0#SCODE:I0097#VTYPE:V^^并发症#TYPE:Simple#TID:2#TVER:0#SCODE:O0100#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",9)="医院感染诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0038#VTYPE:V^医院感染诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0038#VTYPE:V^^医院感染诊断#TYPE:Simple#TID:2#TVER:0#SCODE:O0080#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",10)="病理诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0104#VTYPE:V^病理诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0104#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",11)="损伤中毒诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0034#VTYPE:V^损伤中毒诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0034#VTYPE:V^^"
		
		;set ^DHCWMRDiaSetting("DIA",12)="门急诊诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0043#VTYPE:V^门急诊诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0043#VTYPE:V^^"
		;set ^DHCWMRDiaSetting("DIA",13)="入院主诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0044#VTYPE:V^入院主诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0044#VTYPE:V^^"
		;set ^DHCWMRDiaSetting("DIA",14)="门急诊次要诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0092#VTYPE:V^门急诊次要诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0092#VTYPE:V^^"
		;set ^DHCWMRDiaSetting("DIA",15)="入院次要诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0091#VTYPE:V^入院次要诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0091#VTYPE:V^^"

	}
	
	/*
	//中医院取EPR诊断信息 元数据代码
	if (HospCode="BeiJing_ZYY") {
		set ^DHCWMRDiaSetting("DIA",1)="出院情况.中医主病#TYPE:Simple#TID:143#TVER:0#SCODE:I0002#VTYPE:V^出院情况.中医主病#TYPE:Simple#TID:143#TVER:0#SCODE:I0002#VTYPE:V^^出院情况.出院情况#TYPE:Simple#TID:143#TVER:0#SCODE:O0035#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",2)="出院情况.中医主证#TYPE:Simple#TID:143#TVER:0#SCODE:I0003#VTYPE:V^出院情况.中医主证#TYPE:Simple#TID:143#TVER:0#SCODE:I0003#VTYPE:V^^出院情况.出院情况2#TYPE:Simple#TID:143#TVER:0#SCODE:O0036#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",3)="出院情况.中医主证2#TYPE:Simple#TID:143#TVER:0#SCODE:I0004#VTYPE:V^出院情况.中医主证2#TYPE:Simple#TID:143#TVER:0#SCODE:I0004#VTYPE:V^^出院情况.出院情况3#TYPE:Simple#TID:143#TVER:0#SCODE:O0037#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",4)="出院情况.中医主证3#TYPE:Simple#TID:143#TVER:0#SCODE:I0005#VTYPE:V^出院情况.中医主证3#TYPE:Simple#TID:143#TVER:0#SCODE:I0005#VTYPE:V^^出院情况.出院情况4#TYPE:Simple#TID:143#TVER:0#SCODE:O0038#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",5)="出院情况.中医其他诊断#TYPE:Simple#TID:143#TVER:0#SCODE:I0006#VTYPE:V^出院情况.中医其他诊断#TYPE:Simple#TID:143#TVER:0#SCODE:I0006#VTYPE:V^^出院情况.出院情况5#TYPE:Simple#TID:143#TVER:0#SCODE:O0039#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",6)="出院情况.中医其他诊断2#TYPE:Simple#TID:143#TVER:0#SCODE:I0007#VTYPE:V^出院情况.中医其他诊断2#TYPE:Simple#TID:143#TVER:0#SCODE:I0007#VTYPE:V^^出院情况.出院情况6#TYPE:Simple#TID:143#TVER:0#SCODE:O0040#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",7)="出院情况.中医其他诊断3#TYPE:Simple#TID:143#TVER:0#SCODE:I0008#VTYPE:V^出院情况.中医其他诊断3#TYPE:Simple#TID:143#TVER:0#SCODE:I0008#VTYPE:V^^出院情况.出院情况7#TYPE:Simple#TID:143#TVER:0#SCODE:O0041#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",8)="出院情况.西医主要诊断#TYPE:Simple#TID:143#TVER:0#SCODE:I0009#VTYPE:V^出院情况.西医主要诊断#TYPE:Simple#TID:143#TVER:0#SCODE:I0009#VTYPE:V^^出院情况.出院情况8#TYPE:Simple#TID:143#TVER:0#SCODE:O0042#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",9)="出院情况.西医主要诊断2#TYPE:Simple#TID:143#TVER:0#SCODE:I0010#VTYPE:V^出院情况.西医主要诊断2#TYPE:Simple#TID:143#TVER:0#SCODE:I0010#VTYPE:V^^出院情况.出院情况9#TYPE:Simple#TID:143#TVER:0#SCODE:O0043#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",10)="出院情况.西医其他诊断#TYPE:Simple#TID:143#TVER:0#SCODE:I0011#VTYPE:V^出院情况.西医其他诊断#TYPE:Simple#TID:143#TVER:0#SCODE:I0011#VTYPE:V^^出院情况.出院情况10#TYPE:Simple#TID:143#TVER:0#SCODE:O0044#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",11)="出院情况.西医其他诊断2#TYPE:Simple#TID:143#TVER:0#SCODE:I0012#VTYPE:V^出院情况.西医其他诊断2#TYPE:Simple#TID:143#TVER:0#SCODE:I0012#VTYPE:V^^出院情况.出院情况11#TYPE:Simple#TID:143#TVER:0#SCODE:O0045#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",12)="出院情况.西医其他诊断3#TYPE:Simple#TID:143#TVER:0#SCODE:I0013#VTYPE:V^出院情况.西医其他诊断3#TYPE:Simple#TID:143#TVER:0#SCODE:I0013#VTYPE:V^^出院情况.出院情况12#TYPE:Simple#TID:143#TVER:0#SCODE:O0046#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",13)="出院情况.西医其他诊断4#TYPE:Simple#TID:143#TVER:0#SCODE:I0014#VTYPE:V^出院情况.西医其他诊断4#TYPE:Simple#TID:143#TVER:0#SCODE:I0014#VTYPE:V^^出院情况.出院情况13#TYPE:Simple#TID:143#TVER:0#SCODE:O0047#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",14)="出院情况.西医其他诊断5#TYPE:Simple#TID:143#TVER:0#SCODE:I0015#VTYPE:V^出院情况.西医其他诊断5#TYPE:Simple#TID:143#TVER:0#SCODE:I0015#VTYPE:V^^出院情况.出院情况14#TYPE:Simple#TID:143#TVER:0#SCODE:O0048#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",15)="出院情况.西医其他诊断6#TYPE:Simple#TID:143#TVER:0#SCODE:I0016#VTYPE:V^出院情况.西医其他诊断6#TYPE:Simple#TID:143#TVER:0#SCODE:I0016#VTYPE:V^^出院情况.出院情况15#TYPE:Simple#TID:143#TVER:0#SCODE:O0049#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",16)="出院情况.西医其他诊断7#TYPE:Simple#TID:143#TVER:0#SCODE:I0017#VTYPE:V^出院情况.西医其他诊断7#TYPE:Simple#TID:143#TVER:0#SCODE:I0017#VTYPE:V^^出院情况.出院情况16#TYPE:Simple#TID:143#TVER:0#SCODE:O0050#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",17)="出院情况.西医其他诊断8#TYPE:Simple#TID:143#TVER:0#SCODE:I0018#VTYPE:V^出院情况.西医其他诊断8#TYPE:Simple#TID:143#TVER:0#SCODE:I0018#VTYPE:V^^出院情况.出院情况17#TYPE:Simple#TID:143#TVER:0#SCODE:O0051#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",18)="出院情况.西医其他诊断9#TYPE:Simple#TID:143#TVER:0#SCODE:I0019#VTYPE:V^出院情况.西医其他诊断9#TYPE:Simple#TID:143#TVER:0#SCODE:I0019#VTYPE:V^^出院情况.出院情况18#TYPE:Simple#TID:143#TVER:0#SCODE:O0052#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",19)="出院情况.西医其他诊断10#TYPE:Simple#TID:143#TVER:0#SCODE:I0020#VTYPE:V^出院情况.西医其他诊断10#TYPE:Simple#TID:143#TVER:0#SCODE:I0020#VTYPE:V^^出院情况.出院情况19#TYPE:Simple#TID:143#TVER:0#SCODE:O0053#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",20)="出院情况.西医其他诊断11#TYPE:Simple#TID:143#TVER:0#SCODE:I0021#VTYPE:V^出院情况.西医其他诊断11#TYPE:Simple#TID:143#TVER:0#SCODE:I0021#VTYPE:V^^出院情况.出院情况20#TYPE:Simple#TID:143#TVER:0#SCODE:O0054#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",21)="出院情况.西医其他诊断12#TYPE:Simple#TID:143#TVER:0#SCODE:I0022#VTYPE:V^出院情况.西医其他诊断12#TYPE:Simple#TID:143#TVER:0#SCODE:I0022#VTYPE:V^^出院情况.出院情况21#TYPE:Simple#TID:143#TVER:0#SCODE:O0055#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",22)="出院情况.西医其他诊断13#TYPE:Simple#TID:143#TVER:0#SCODE:I0023#VTYPE:V^出院情况.西医其他诊断13#TYPE:Simple#TID:143#TVER:0#SCODE:I0023#VTYPE:V^^出院情况.出院情况22#TYPE:Simple#TID:143#TVER:0#SCODE:O0056#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",23)="出院情况.西医其他诊断14#TYPE:Simple#TID:143#TVER:0#SCODE:I0024#VTYPE:V^出院情况.西医其他诊断14#TYPE:Simple#TID:143#TVER:0#SCODE:I0024#VTYPE:V^^出院情况.出院情况23#TYPE:Simple#TID:143#TVER:0#SCODE:O0057#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",24)="出院情况.西医其他诊断15#TYPE:Simple#TID:143#TVER:0#SCODE:I0025#VTYPE:V^出院情况.西医其他诊断15#TYPE:Simple#TID:143#TVER:0#SCODE:I0025#VTYPE:V^^出院情况.出院情况24#TYPE:Simple#TID:143#TVER:0#SCODE:O0058#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",25)="出院情况.西医其他诊断16#TYPE:Simple#TID:143#TVER:0#SCODE:I0026#VTYPE:V^出院情况.西医其他诊断16#TYPE:Simple#TID:143#TVER:0#SCODE:I0026#VTYPE:V^^出院情况.出院情况25#TYPE:Simple#TID:143#TVER:0#SCODE:O0059#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",26)="出院情况.西医其他诊断17#TYPE:Simple#TID:143#TVER:0#SCODE:I0027#VTYPE:V^出院情况.西医其他诊断17#TYPE:Simple#TID:143#TVER:0#SCODE:I0027#VTYPE:V^^出院情况.出院情况26#TYPE:Simple#TID:143#TVER:0#SCODE:O0060#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",27)="出院情况.西医其他诊断18#TYPE:Simple#TID:143#TVER:0#SCODE:I0029#VTYPE:V^出院情况.西医其他诊断18#TYPE:Simple#TID:143#TVER:0#SCODE:I0029#VTYPE:V^^出院情况.出院情况27#TYPE:Simple#TID:143#TVER:0#SCODE:O0061#VTYPE:V"
		
		set ^DHCWMRDiaSetting("DIA",28)="出院情况.医院感染名称#TYPE:Simple#TID:143#TVER:0#SCODE:I0030#VTYPE:V^出院情况.医院感染名称#TYPE:Simple#TID:143#TVER:0#SCODE:I0030#VTYPE:V^^出院情况.出院情况28#TYPE:Simple#TID:143#TVER:0#SCODE:O0123#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",29)="出院情况.医院感染名称2#TYPE:Simple#TID:143#TVER:0#SCODE:I0031#VTYPE:V^出院情况.医院感染名称2#TYPE:Simple#TID:143#TVER:0#SCODE:I0031#VTYPE:V^^出院情况.出院情况29#TYPE:Simple#TID:143#TVER:0#SCODE:O0124#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",30)="出院情况.医院感染名称3#TYPE:Simple#TID:143#TVER:0#SCODE:I0032#VTYPE:V^出院情况.医院感染名称3#TYPE:Simple#TID:143#TVER:0#SCODE:I0032#VTYPE:V^^出院情况.出院情况30#TYPE:Simple#TID:143#TVER:0#SCODE:O0125#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",31)="出院情况.并发症名称#TYPE:Simple#TID:143#TVER:0#SCODE:I0033#VTYPE:V^出院情况.并发症名称#TYPE:Simple#TID:143#TVER:0#SCODE:I0033#VTYPE:V^^出院情况.出院情况31#TYPE:Simple#TID:143#TVER:0#SCODE:O0126#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",32)="出院情况.并发症名称2#TYPE:Simple#TID:143#TVER:0#SCODE:I0034#VTYPE:V^出院情况.并发症名称2#TYPE:Simple#TID:143#TVER:0#SCODE:I0034#VTYPE:V^^出院情况.出院情况32#TYPE:Simple#TID:143#TVER:0#SCODE:O0127#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",33)="出院情况.损伤中毒的外部因素#TYPE:Simple#TID:143#TVER:0#SCODE:I0087#VTYPE:V^出院情况.损伤中毒的外部因素#TYPE:Simple#TID:143#TVER:0#SCODE:I0087#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",34)="出院情况.损伤中毒的外部因素2#TYPE:Simple#TID:143#TVER:0#SCODE:I0088#VTYPE:V^出院情况.损伤中毒的外部因素2#TYPE:Simple#TID:143#TVER:0#SCODE:I0088#VTYPE:V^^"
		
		set ^DHCWMRDiaSetting("DIA",35)="一般情况.门急诊诊断:中医#TYPE:Simple#TID:182#TVER:0#SCODE:I0047#VTYPE:V^^^"
		set ^DHCWMRDiaSetting("DIA",36)="一般情况.门急诊诊断西医#TYPE:Simple#TID:183#TVER:0#SCODE:I0048#VTYPE:V^^^"
		set ^DHCWMRDiaSetting("DIA",37)="一般情况.入院诊断:中医#TYPE:Simple#TID:185#TVER:0#SCODE:I0050#VTYPE:V^^^"
		set ^DHCWMRDiaSetting("DIA",38)="一般情况.入院诊断西医#TYPE:Simple#TID:186#TVER:0#SCODE:I0051#VTYPE:V^^^"
	}
	
	//妇产医院取EPR诊断信息 元数据代码
	if (HospCode="BeiJing_FC") {
		set ^DHCWMRDiaSetting("DIA",1)="病案首页.病案首页.出院情况.出院情况.主要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0002#VTYPE:V^病案首页.病案首页.出院情况.出院情况.主要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0002#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑诊断类型1#TYPE:Simple#TID:2#TVER:0#SCODE:O0095#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况主要诊断#TYPE:Simple#TID:2#TVER:0#SCODE:O0024#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",2)="病案首页.病案首页.出院情况.出院情况.次要诊断2#TYPE:Simple#TID:2#TVER:0#SCODE:I0003#VTYPE:V^病案首页.病案首页.出院情况.出院情况.次要诊断2#TYPE:Simple#TID:2#TVER:0#SCODE:I0003#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑诊断类型2#TYPE:Simple#TID:2#TVER:0#SCODE:O0096#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况次要诊断2#TYPE:Simple#TID:2#TVER:0#SCODE:O0025#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",3)="病案首页.病案首页.出院情况.出院情况.次要诊断3#TYPE:Simple#TID:2#TVER:0#SCODE:I0009#VTYPE:V^病案首页.病案首页.出院情况.出院情况.次要诊断3#TYPE:Simple#TID:2#TVER:0#SCODE:I0009#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑诊断类型3#TYPE:Simple#TID:2#TVER:0#SCODE:O0097#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况次要诊断3#TYPE:Simple#TID:2#TVER:0#SCODE:O0026#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",4)="病案首页.病案首页.出院情况.出院情况.次要诊断4#TYPE:Simple#TID:2#TVER:0#SCODE:I0010#VTYPE:V^病案首页.病案首页.出院情况.出院情况.次要诊断4#TYPE:Simple#TID:2#TVER:0#SCODE:I0010#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑诊断类型4#TYPE:Simple#TID:2#TVER:0#SCODE:O0106#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况次要诊断4#TYPE:Simple#TID:2#TVER:0#SCODE:O0027#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",5)="病案首页.病案首页.出院情况.出院情况.次要诊断5#TYPE:Simple#TID:2#TVER:0#SCODE:I0011#VTYPE:V^病案首页.病案首页.出院情况.出院情况.次要诊断5#TYPE:Simple#TID:2#TVER:0#SCODE:I0011#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑诊断类型5#TYPE:Simple#TID:2#TVER:0#SCODE:O0105#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况次要诊断5#TYPE:Simple#TID:2#TVER:0#SCODE:O0028#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",6)="病案首页.病案首页.出院情况.出院情况.次要诊断6#TYPE:Simple#TID:2#TVER:0#SCODE:I0012#VTYPE:V^病案首页.病案首页.出院情况.出院情况.次要诊断6#TYPE:Simple#TID:2#TVER:0#SCODE:I0012#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑诊断类型6#TYPE:Simple#TID:2#TVER:0#SCODE:O0104#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况次要诊断6#TYPE:Simple#TID:2#TVER:0#SCODE:O0029#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",7)="病案首页.病案首页.出院情况.出院情况.次要诊断7#TYPE:Simple#TID:2#TVER:0#SCODE:I0013#VTYPE:V^病案首页.病案首页.出院情况.出院情况.次要诊断7#TYPE:Simple#TID:2#TVER:0#SCODE:I0013#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑诊断类型7#TYPE:Simple#TID:2#TVER:0#SCODE:O0103#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况次要诊断7#TYPE:Simple#TID:2#TVER:0#SCODE:O0030#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",8)="病案首页.病案首页.出院情况.出院情况.次要诊断8#TYPE:Simple#TID:2#TVER:0#SCODE:I0036#VTYPE:V^病案首页.病案首页.出院情况.出院情况.次要诊断8#TYPE:Simple#TID:2#TVER:0#SCODE:I0036#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑诊断类型8#TYPE:Simple#TID:2#TVER:0#SCODE:O0098#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况次要诊断8#TYPE:Simple#TID:2#TVER:0#SCODE:O0031#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",9)="病案首页.病案首页.出院情况.出院情况.次要诊断9#TYPE:Simple#TID:2#TVER:0#SCODE:I0109#VTYPE:V^病案首页.病案首页.出院情况.出院情况.次要诊断9#TYPE:Simple#TID:2#TVER:0#SCODE:I0109#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑诊断类型9#TYPE:Simple#TID:2#TVER:0#SCODE:O0102#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况次要诊断9#TYPE:Simple#TID:2#TVER:0#SCODE:O0113#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",10)="病案首页.病案首页.出院情况.出院情况.次要诊断10#TYPE:Simple#TID:2#TVER:0#SCODE:I0110#VTYPE:V^病案首页.病案首页.出院情况.出院情况.次要诊断10#TYPE:Simple#TID:2#TVER:0#SCODE:I0110#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑诊断类型10#TYPE:Simple#TID:2#TVER:0#SCODE:O0101#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况次要诊断10#TYPE:Simple#TID:2#TVER:0#SCODE:O0112#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",11)="病案首页.病案首页.出院情况.出院情况.次要诊断11#TYPE:Simple#TID:2#TVER:0#SCODE:I0108#VTYPE:V^病案首页.病案首页.出院情况.出院情况.次要诊断11#TYPE:Simple#TID:2#TVER:0#SCODE:I0108#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑诊断类型11#TYPE:Simple#TID:2#TVER:0#SCODE:O0100#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况次要诊断11#TYPE:Simple#TID:2#TVER:0#SCODE:O0117#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",12)="病案首页.病案首页.出院情况.出院情况.次要诊断12#TYPE:Simple#TID:2#TVER:0#SCODE:I0107#VTYPE:V^病案首页.病案首页.出院情况.出院情况.次要诊断12#TYPE:Simple#TID:2#TVER:0#SCODE:I0107#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑诊断类型12#TYPE:Simple#TID:2#TVER:0#SCODE:O0099#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况次要诊断12#TYPE:Simple#TID:2#TVER:0#SCODE:O0111#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",13)="病案首页.病案首页.出院情况.出院情况.次要诊断13#TYPE:Simple#TID:2#TVER:0#SCODE:I0037#VTYPE:V^病案首页.病案首页.出院情况.出院情况.次要诊断13#TYPE:Simple#TID:2#TVER:0#SCODE:I0037#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑诊断类型13#TYPE:Simple#TID:2#TVER:0#SCODE:O0119#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况次要诊断13#TYPE:Simple#TID:2#TVER:0#SCODE:O0116#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",14)="病案首页.病案首页.出院情况.出院情况.次要诊断14#TYPE:Simple#TID:2#TVER:0#SCODE:I0035#VTYPE:V^病案首页.病案首页.出院情况.出院情况.次要诊断14#TYPE:Simple#TID:2#TVER:0#SCODE:I0035#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑诊断类型14#TYPE:Simple#TID:2#TVER:0#SCODE:O0127#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况次要诊断14#TYPE:Simple#TID:2#TVER:0#SCODE:O0032#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",15)="病案首页.病案首页.出院情况.出院情况.次要诊断15#TYPE:Simple#TID:2#TVER:0#SCODE:I0090#VTYPE:V^病案首页.病案首页.出院情况.出院情况.次要诊断15#TYPE:Simple#TID:2#TVER:0#SCODE:I0090#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑诊断类型15#TYPE:Simple#TID:2#TVER:0#SCODE:O0126#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况次要诊断15#TYPE:Simple#TID:2#TVER:0#SCODE:O0123#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",16)="病案首页.病案首页.出院情况.出院情况.医院感染名称#TYPE:Simple#TID:2#TVER:0#SCODE:I0128#VTYPE:V^病案首页.病案首页.出院情况.出院情况.医院感染名称#TYPE:Simple#TID:2#TVER:0#SCODE:I0128#VTYPE:V^病案首页.病案首页.出院情况.出院情况.怀疑出院感染类型#TYPE:Simple#TID:2#TVER:0#SCODE:O0130#VTYPE:V^病案首页.病案首页.出院情况.出院情况.出院情况医院感染名称#TYPE:Simple#TID:2#TVER:0#SCODE:O0129#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",17)="病案首页.病案首页.出院情况.出院情况.病理诊断#TYPE:Simple#TID:2#TVER:0#SCODE:S0094#VTYPE:V^^^"
		set ^DHCWMRDiaSetting("DIA",18)="病案首页.病案首页.出院情况.出院情况.损伤、中毒的外部因素#TYPE:Simple#TID:2#TVER:0#SCODE:I0034#VTYPE:V^^^"
		set ^DHCWMRDiaSetting("DIA",19)="病案首页.病案首页.一般情况.一般情况.门(急)诊诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0043#VTYPE:V^^^"
		set ^DHCWMRDiaSetting("DIA",20)="病案首页.病案首页.一般情况.一般情况.入院诊断1#TYPE:Simple#TID:1#TVER:0#SCODE:I0044#VTYPE:V^^^"
		set ^DHCWMRDiaSetting("DIA",21)="病案首页.病案首页.一般情况.一般情况.入院诊断2#TYPE:Simple#TID:1#TVER:0#SCODE:I0078#VTYPE:V^^^"
	}
	//地坛医院取EPR诊断信息 元数据代码
	if (HospCode="BeiJing_DT") {
		set ^DHCWMRDiaSetting("DIA",1)="主要诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0057#VTYPE:V^主要诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0057#VTYPE:V^^出院情况#TYPE:Simple#TID:21#TVER:0#SCODE:O0042#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",2)="其他诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0056#VTYPE:V^其他诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0056#VTYPE:V^^出院情况#TYPE:Simple#TID:21#TVER:0#SCODE:O0043#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",3)="其他诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0055#VTYPE:V^其他诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0055#VTYPE:V^^出院情况#TYPE:Simple#TID:21#TVER:0#SCODE:O0044#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",4)="其他诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0054#VTYPE:V^其他诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0054#VTYPE:V^^出院情况#TYPE:Simple#TID:21#TVER:0#SCODE:O0045#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",5)="其他诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0053#VTYPE:V^其他诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0053#VTYPE:V^^出院情况#TYPE:Simple#TID:21#TVER:0#SCODE:O0046#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",6)="其他诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0052#VTYPE:V^其他诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0052#VTYPE:V^^出院情况#TYPE:Simple#TID:21#TVER:0#SCODE:O0047#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",7)="其他诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0051#VTYPE:V^其他诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0051#VTYPE:V^^出院情况#TYPE:Simple#TID:21#TVER:0#SCODE:O0048#VTYPE:V"
	
		set ^DHCWMRDiaSetting("DIA",17)="病理诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0059#VTYPE:V^病理诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0059#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",18)="医院感染名称#TYPE:Simple#TID:21#TVER:0#SCODE:I0060#VTYPE:V^医院感染名称#TYPE:Simple#TID:21#TVER:0#SCODE:I0060#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",19)="损伤中毒的外部因素#TYPE:Simple#TID:21#TVER:0#SCODE:I0062#VTYPE:V^损伤中毒的外部因素#TYPE:Simple#TID:21#TVER:0#SCODE:I0062#VTYPE:V^^"
		
		set ^DHCWMRDiaSetting("DIA",20)="门（急）诊诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0035#VTYPE:V^门（急）诊诊断#TYPE:Simple#TID:21#TVER:0#SCODE:I0035#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",21)="入院诊断^#TYPE:Simple#TID:21#TVER:0#SCODE:I0037#VTYPE:V^入院诊断^#TYPE:Simple#TID:21#TVER:0#SCODE:I0037#VTYPE:V^^"
		
	}
	*/
	//地坛医院取EPR诊断信息 元数据代码
	if (HospCode="BeiJing_DT") {
		set ^DHCWMRDiaSetting("DIA",1)="主要诊断#TYPE:Segment#TID:33#TVER:0#GCODE:G0190^主要诊断#TYPE:Simple#TID:33#TVER:0#SCODE:I0057#VTYPE:V^^出院情况#TYPE:Simple#TID:33#TVER:0#SCODE:O0042#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",2)="次要诊断#TYPE:Segment#TID:33#TVER:0#GCODE:G0191^次要诊断#TYPE:Simple#TID:33#TVER:0#SCODE:I0056#VTYPE:V^^出院情况#TYPE:Simple#TID:33#TVER:0#SCODE:O0043#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",3)="次要诊断#TYPE:Segment#TID:33#TVER:0#GCODE:G0192^次要诊断#TYPE:Simple#TID:33#TVER:0#SCODE:I0055#VTYPE:V^^出院情况#TYPE:Simple#TID:33#TVER:0#SCODE:O0044#VTYPE:V"
		
		set ^DHCWMRDiaSetting("DIA",17)="病理诊断#TYPE:Simple#TID:33#TVER:0#SCODE:S0063#VTYPE:V^病理诊断#TYPE:Simple#TID:33#TVER:0#SCODE:I0062#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",18)="首页出院情况.医院感染诊断#TYPE:Simple#TID:67#TVER:0#SCODE:S0079#VTYPE:V^^^"
		set ^DHCWMRDiaSetting("DIA",19)="损伤中毒的外部因素#TYPE:Simple#TID:33#TVER:0#SCODE:S0065#VTYPE:V^损伤中毒的外部因素#TYPE:Simple#TID:33#TVER:0#SCODE:I0060#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",20)="门急诊诊断#TYPE:Simple#TID:33#TVER:0#SCODE:I0035#VTYPE:V^门急诊诊断#TYPE:Simple#TID:33#TVER:0#SCODE:I0035#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",21)="入院诊断#TYPE:Simple#TID:33#TVER:0#SCODE:I0037#VTYPE:V^入院诊断#TYPE:Simple#TID:33#TVER:0#SCODE:I0037#VTYPE:V^^"
		
	}
	
	
	
	quit
}

/// ------add by wuqk 2008-05-13------
/// 设置当前医院病案编目时取HIS手术的数据来源
/// ^DHCWMROperSetting("OPER")
/// 0：根据当前医院设置调用##class(web.DHCWMRMedBaseArcimCtl).GetOrdsOper()
///    分别从如下信息重取手术信息
///         取手术类医嘱信息
///         取手术申请单信息(安贞)
///         从手术麻醉系统取手术信息
/// 1：取电子病历版本1的手术情况
/// 2：取电子病历版本2的手术情况
/// 
/// ^DHCWMROperSetting("OPER",Index)
/// 电子病历手术信息各个字段对应的元数据代码与取法,$c(2)分隔
/// 字段描述：
/// opRowid   手术信息Rowid,为空
/// OPDesc1   手术名称
/// OPDate1   手术日期
/// status    手术状态
/// startDate 手术开始日期
/// startTime 手术开始时间
/// EndDate   手术结束日期
/// EndTime   手术结束时间
/// OPDoc1    术者
/// anaMethod1 麻醉方式
/// anaDoc1   麻醉医师
/// AssDoc11_$c(3)_AssDoc21  一助  二助
/// OPCode1   手术编码
/// d ##Class(web.DHCWMRMedBaseDiagnose).SetDHCWMROperSetting()
ClassMethod SetDHCWMROperSetting()
{
    
	set ^DHCWMROperSetting("OPER")=2
	
    s opRowid=""
    s status=""
    s startDate=""
    s startTime=""
    s EndDate=""
    s EndTime=""
    set HospCode=##class(web.DHCWMRMedBase01).GetDefaultHospCode()
	//哈尔滨一附院手术操作信息 元数据代码
	
		s ^DHCWMROperSetting("OPER")=2
		
		s OPRowid1 ="手术操作名称1#TYPE:Simple#TID:156#TVER:0#SCODE:I0017#VTYPE:V/1"
		s OPRowid2 ="手术操作名称2#TYPE:Simple#TID:156#TVER:0#SCODE:I0019#VTYPE:V/1"
		s OPRowid3 ="手术操作名称3#TYPE:Simple#TID:156#TVER:0#SCODE:I0020#VTYPE:V/1"
		s OPRowid4 ="手术操作名称4#TYPE:Simple#TID:156#TVER:0#SCODE:I0021#VTYPE:V/1"
		s OPRowid5 ="手术操作名称5#TYPE:Simple#TID:156#TVER:0#SCODE:I0022#VTYPE:V/1"
		s OPRowid6 ="手术操作名称5#TYPE:Simple#TID:156#TVER:0#SCODE:I0023#VTYPE:V/1"
		s OPRowid7 ="手术操作名称5#TYPE:Simple#TID:156#TVER:0#SCODE:I0024#VTYPE:V/1"
		s OPRowid8 ="手术操作名称5#TYPE:Simple#TID:156#TVER:0#SCODE:I0025#VTYPE:V/1"
		
	    s OPDesc1 ="手术操作名称1#TYPE:Simple#TID:156#TVER:0#SCODE:I0017#VTYPE:V/0"
		s OPDesc2 ="手术操作名称2#TYPE:Simple#TID:156#TVER:0#SCODE:I0019#VTYPE:V/0"
		s OPDesc3 ="手术操作名称3#TYPE:Simple#TID:156#TVER:0#SCODE:I0020#VTYPE:V/0"
		s OPDesc4 ="手术操作名称4#TYPE:Simple#TID:156#TVER:0#SCODE:I0021#VTYPE:V/0"
		s OPDesc5 ="手术操作名称5#TYPE:Simple#TID:156#TVER:0#SCODE:I0022#VTYPE:V/0"
		s OPDesc6 ="手术操作名称5#TYPE:Simple#TID:156#TVER:0#SCODE:I0023#VTYPE:V/0"
		s OPDesc7 ="手术操作名称5#TYPE:Simple#TID:156#TVER:0#SCODE:I0024#VTYPE:V/0"
		s OPDesc8 ="手术操作名称5#TYPE:Simple#TID:156#TVER:0#SCODE:I0025#VTYPE:V/0"
	
		s OPCode1=""  //"手术操作名称1#TYPE:Simple#TID:156#TVER:0#SCODE:I0022#VTYPE:V/1"
		s OPCode2=""  //"手术操作名称2#TYPE:Simple#TID:156#TVER:0#SCODE:I0023#VTYPE:V/1"
		s OPCode3=""  //"手术操作名称3#TYPE:Simple#TID:156#TVER:0#SCODE:I0024#VTYPE:V/1"
		s OPCode4=""  //"手术操作名称4#TYPE:Simple#TID:156#TVER:0#SCODE:I0025#VTYPE:V/1"
		s OPCode5=""  //"手术操作名称5#TYPE:Simple#TID:156#TVER:0#SCODE:I0101#VTYPE:V/1"
	    s OPCode6=""
	    s OPCode7=""
	    s OPCode8=""
	    
		s OPDate1="手术操作日期1#TYPE:Simple#TID:156#TVER:0#SCODE:D0001#VTYPE:V/1"
		s OPDate2="手术操作日期2#TYPE:Simple#TID:156#TVER:0#SCODE:D0002#VTYPE:V/1"
		s OPDate3="手术操作日期3#TYPE:Simple#TID:156#TVER:0#SCODE:D0003#VTYPE:V/1"
		s OPDate4="手术操作日期4#TYPE:Simple#TID:156#TVER:0#SCODE:D0004#VTYPE:V/1"
		s OPDate5="手术操作日期5#TYPE:Simple#TID:156#TVER:0#SCODE:D0005#VTYPE:V/1"
		s OPDate6="手术操作日期5#TYPE:Simple#TID:156#TVER:0#SCODE:D0006#VTYPE:V/1"
		s OPDate7="手术操作日期5#TYPE:Simple#TID:156#TVER:0#SCODE:D0007#VTYPE:V/1"
		s OPDate8="手术操作日期5#TYPE:Simple#TID:156#TVER:0#SCODE:D0008#VTYPE:V/1"
	
		s OPDoc1="术者1#TYPE:Simple#TID:156#TVER:0#SCODE:I0026#VTYPE:V/0"
		s OPDoc2="术者2#TYPE:Simple#TID:156#TVER:0#SCODE:I0027#VTYPE:V/0"
		s OPDoc3="术者3#TYPE:Simple#TID:156#TVER:0#SCODE:I0028#VTYPE:V/0"
		s OPDoc4="术者4#TYPE:Simple#TID:156#TVER:0#SCODE:I0029#VTYPE:V/0"
		s OPDoc5="术者5#TYPE:Simple#TID:156#TVER:0#SCODE:I0030#VTYPE:V/0"
	    s OPDoc6="术者6#TYPE:Simple#TID:156#TVER:0#SCODE:I0031#VTYPE:V/0"
	    s OPDoc7="术者7#TYPE:Simple#TID:156#TVER:0#SCODE:I0032#VTYPE:V/0"
	    s OPDoc8="术者8#TYPE:Simple#TID:156#TVER:0#SCODE:I0033#VTYPE:V/0"
	    
		s anaMethod1="麻醉方式1#TYPE:Simple#TID:156#TVER:0#SCODE:I0058#VTYPE:V/0"
		s anaMethod2="麻醉方式2#TYPE:Simple#TID:156#TVER:0#SCODE:I0059#VTYPE:V/0"
		s anaMethod3="麻醉方式3#TYPE:Simple#TID:156#TVER:0#SCODE:I0060#VTYPE:V/0"
		s anaMethod4="麻醉方式4#TYPE:Simple#TID:156#TVER:0#SCODE:I0061#VTYPE:V/0"
		s anaMethod5="麻醉方式5#TYPE:Simple#TID:156#TVER:0#SCODE:I0062#VTYPE:V/0"
		s anaMethod6="麻醉方式6#TYPE:Simple#TID:156#TVER:0#SCODE:I0063#VTYPE:V/0"
		s anaMethod7="麻醉方式7#TYPE:Simple#TID:156#TVER:0#SCODE:I0064#VTYPE:V/0"
		s anaMethod8="麻醉方式8#TYPE:Simple#TID:156#TVER:0#SCODE:I0065#VTYPE:V/0"
	
		s anaDoc1="麻醉医师1#TYPE:Simple#TID:156#TVER:0#SCODE:I0050#VTYPE:V/0"
		s anaDoc2="麻醉医师2#TYPE:Simple#TID:156#TVER:0#SCODE:I0057#VTYPE:V/0"
		s anaDoc3="麻醉医师3#TYPE:Simple#TID:156#TVER:0#SCODE:I0056#VTYPE:V/0"
		s anaDoc4="麻醉医师4#TYPE:Simple#TID:156#TVER:0#SCODE:I0055#VTYPE:V/0"
		s anaDoc5="麻醉医师5#TYPE:Simple#TID:156#TVER:0#SCODE:I0054#VTYPE:V/0"
		s anaDoc6="麻醉医师6#TYPE:Simple#TID:156#TVER:0#SCODE:I0053#VTYPE:V/0"
		s anaDoc7="麻醉医师7#TYPE:Simple#TID:156#TVER:0#SCODE:I0053#VTYPE:V/0"
		s anaDoc8="麻醉医师8#TYPE:Simple#TID:156#TVER:0#SCODE:I0051#VTYPE:V/0"
	
		s AssDoc11="Ⅰ助1#TYPE:Simple#TID:156#TVER:0#SCODE:I0034#VTYPE:V/0"
		s AssDoc12="Ⅰ助2#TYPE:Simple#TID:156#TVER:0#SCODE:I0049#VTYPE:V/0"
		s AssDoc13="Ⅰ助3#TYPE:Simple#TID:156#TVER:0#SCODE:I0048#VTYPE:V/0"
		s AssDoc14="Ⅰ助4#TYPE:Simple#TID:156#TVER:0#SCODE:I0047#VTYPE:V/0"
		s AssDoc15="Ⅰ助5#TYPE:Simple#TID:156#TVER:0#SCODE:I0046#VTYPE:V/0"
		s AssDoc16="Ⅰ助6#TYPE:Simple#TID:156#TVER:0#SCODE:I0045#VTYPE:V/0"
		s AssDoc17="Ⅰ助7#TYPE:Simple#TID:156#TVER:0#SCODE:I0044#VTYPE:V/0"
		s AssDoc18="Ⅰ助8#TYPE:Simple#TID:156#TVER:0#SCODE:I0043#VTYPE:V/0"
		
	
		s AssDoc21="Ⅱ助1#TYPE:Simple#TID:156#TVER:0#SCODE:I0042#VTYPE:V/0"
		s AssDoc22="Ⅱ助2#TYPE:Simple#TID:156#TVER:0#SCODE:I0041#VTYPE:V/0"
		s AssDoc23="Ⅱ助3#TYPE:Simple#TID:156#TVER:0#SCODE:I0040#VTYPE:V/0"
		s AssDoc24="Ⅱ助4#TYPE:Simple#TID:156#TVER:0#SCODE:I0039#VTYPE:V/0"
		s AssDoc25="Ⅱ助5#TYPE:Simple#TID:156#TVER:0#SCODE:I0038#VTYPE:V/0"
		s AssDoc26="Ⅱ助6#TYPE:Simple#TID:156#TVER:0#SCODE:I0037#VTYPE:V/0"
		s AssDoc27="Ⅱ助7#TYPE:Simple#TID:156#TVER:0#SCODE:I0036#VTYPE:V/0"
		s AssDoc28="Ⅱ助8#TYPE:Simple#TID:156#TVER:0#SCODE:I0035#VTYPE:V/0"
	
		s CutClose11="切口愈合等级11#TYPE:Simple#TID:156#TVER:0#SCODE:O0066#VTYPE:V/0"
		s CutClose12="切口愈合等级12#TYPE:Simple#TID:156#TVER:0#SCODE:O0073#VTYPE:V/0"
		s CutClose13="切口愈合等级13#TYPE:Simple#TID:156#TVER:0#SCODE:O0072#VTYPE:V/0"
		s CutClose14="切口愈合等级14#TYPE:Simple#TID:156#TVER:0#SCODE:O0071#VTYPE:V/0"
		s CutClose15="切口愈合等级15#TYPE:Simple#TID:156#TVER:0#SCODE:O0070#VTYPE:V/0"
		s CutClose16="切口愈合等级16#TYPE:Simple#TID:156#TVER:0#SCODE:O0069#VTYPE:V/0"
		s CutClose17="切口愈合等级17#TYPE:Simple#TID:156#TVER:0#SCODE:O0068#VTYPE:V/0"
		s CutClose18="切口愈合等级18#TYPE:Simple#TID:156#TVER:0#SCODE:O0067#VTYPE:V/0"
	
		s CutClose21="切口愈合等级21#TYPE:Simple#TID:156#TVER:0#SCODE:O0048#VTYPE:V/0"
		s CutClose22="切口愈合等级22#TYPE:Simple#TID:156#TVER:0#SCODE:O0046#VTYPE:V/0"
		s CutClose23="切口愈合等级23#TYPE:Simple#TID:156#TVER:0#SCODE:O0045#VTYPE:V/0"
		s CutClose24="切口愈合等级24#TYPE:Simple#TID:156#TVER:0#SCODE:O0044#VTYPE:V/0"
		s CutClose25="切口愈合等级25#TYPE:Simple#TID:156#TVER:0#SCODE:O0107#VTYPE:V/0"
		s CutClose26="切口愈合等级26#TYPE:Simple#TID:156#TVER:0#SCODE:O0107#VTYPE:V/0"
		s CutClose27="切口愈合等级27#TYPE:Simple#TID:156#TVER:0#SCODE:O0107#VTYPE:V/0"
		s CutClose28="切口愈合等级28#TYPE:Simple#TID:156#TVER:0#SCODE:O0107#VTYPE:V/0"
		
		s OperationRank1="手术等级21#TYPE:Simple#TID:156#TVER:0#SCODE:O0009#VTYPE:V/0"
		s OperationRank2="手术等级22#TYPE:Simple#TID:156#TVER:0#SCODE:O0010#VTYPE:V/0"
		s OperationRank3="手术等级23#TYPE:Simple#TID:156#TVER:0#SCODE:O0011#VTYPE:V/0"
		s OperationRank4="手术等级24#TYPE:Simple#TID:156#TVER:0#SCODE:O0012#VTYPE:V/0"
		s OperationRank5="手术等级25#TYPE:Simple#TID:156#TVER:0#SCODE:O0013#VTYPE:V/0"
		s OperationRank6="手术等级26#TYPE:Simple#TID:156#TVER:0#SCODE:O0014#VTYPE:V/0"
		s OperationRank7="手术等级27#TYPE:Simple#TID:156#TVER:0#SCODE:O0015#VTYPE:V/0"
		s OperationRank8="手术等级28#TYPE:Simple#TID:156#TVER:0#SCODE:O0016#VTYPE:V/0"
		
		s TMP1=OPRowid1_$c(2)_OPDesc1_$c(2)_OPDate1_$c(2)_status_$c(2)_OPDate1_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc1_$c(2)_anaMethod1_$c(2)_anaDoc1_$c(2)_AssDoc11_$c(3)_AssDoc21_$c(2)_OPCode1_$c(2)_CutClose11_$c(2)_CutClose21_$c(2)_OperationRank1
	    s TMP2=OPRowid2_$c(2)_OPDesc2_$c(2)_OPDate2_$c(2)_status_$c(2)_OPDate2_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc2_$c(2)_anaMethod2_$c(2)_anaDoc2_$c(2)_AssDoc12_$c(3)_AssDoc22_$c(2)_OPCode2_$c(2)_CutClose12_$c(2)_CutClose22_$c(2)_OperationRank2
	    s TMP3=OPRowid3_$c(2)_OPDesc3_$c(2)_OPDate3_$c(2)_status_$c(2)_OPDate3_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc3_$c(2)_anaMethod3_$c(2)_anaDoc3_$c(2)_AssDoc13_$c(3)_AssDoc23_$c(2)_OPCode3_$c(2)_CutClose13_$c(2)_CutClose23_$c(2)_OperationRank3
	    s TMP4=OPRowid4_$c(2)_OPDesc4_$c(2)_OPDate4_$c(2)_status_$c(2)_OPDate4_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc4_$c(2)_anaMethod4_$c(2)_anaDoc4_$c(2)_AssDoc14_$c(3)_AssDoc24_$c(2)_OPCode4_$c(2)_CutClose14_$c(2)_CutClose24_$c(2)_OperationRank4
	    s TMP5=OPRowid5_$c(2)_OPDesc5_$c(2)_OPDate5_$c(2)_status_$c(2)_OPDate5_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc5_$c(2)_anaMethod5_$c(2)_anaDoc5_$c(2)_AssDoc15_$c(3)_AssDoc25_$c(2)_OPCode5_$c(2)_CutClose15_$c(2)_CutClose25_$c(2)_OperationRank5
	    s TMP6=OPRowid6_$c(2)_OPDesc6_$c(2)_OPDate6_$c(2)_status_$c(2)_OPDate6_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc6_$c(2)_anaMethod6_$c(2)_anaDoc6_$c(2)_AssDoc16_$c(3)_AssDoc26_$c(2)_OPCode6_$c(2)_CutClose16_$c(2)_CutClose26_$c(2)_OperationRank6
	    s TMP7=OPRowid7_$c(2)_OPDesc7_$c(2)_OPDate7_$c(2)_status_$c(2)_OPDate7_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc7_$c(2)_anaMethod7_$c(2)_anaDoc7_$c(2)_AssDoc17_$c(3)_AssDoc27_$c(2)_OPCode7_$c(2)_CutClose17_$c(2)_CutClose27_$c(2)_OperationRank7
	    s TMP8=OPRowid8_$c(2)_OPDesc8_$c(2)_OPDate8_$c(2)_status_$c(2)_OPDate8_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc8_$c(2)_anaMethod8_$c(2)_anaDoc8_$c(2)_AssDoc18_$c(3)_AssDoc28_$c(2)_OPCode8_$c(2)_CutClose18_$c(2)_CutClose28_$c(2)_OperationRank8
	    b ;11
		set ^DHCWMROperSetting("OPER",1)=TMP1
		set ^DHCWMROperSetting("OPER",2)=TMP2
		set ^DHCWMROperSetting("OPER",3)=TMP3
		set ^DHCWMROperSetting("OPER",4)=TMP4
		set ^DHCWMROperSetting("OPER",5)=TMP5
		set ^DHCWMROperSetting("OPER",6)=TMP6
		set ^DHCWMROperSetting("OPER",7)=TMP7
		set ^DHCWMROperSetting("OPER",8)=TMP8

	
	
	quit
}

/// 取版本1的元数据
ClassMethod GetEPRV1Element(paadm, eleCode, isGetCode)
{
	s ret=##class(DHC.EPR.FPInterface.ExportTable).GetItemDataValueV1ForStat(paadm,eleCode,isGetCode)
	q ret
}

/// 取版本2的元数据
ClassMethod GetEPRV2Element(paadm, eleCode, isGetCode)
{
	s ret=##class(EPRmeta.FPInterface.ExportTable).GetItemDataValueV2ForStat(paadm,eleCode,isGetCode)
	q ret
}

/// 取版本3的元数据
ClassMethod GetEPRV3Element(paadm, eleCode, isGetCode)
{
	Set:eleCode["#TYPE:" eleCode=$p(eleCode,"#TYPE:",2)
	s ret=##Class(EPRservice.BOScatterData).GetDataByGlossary(paadm,eleCode)
	q ret
}

/// 函数：GetEPRElement
/// 说明:根据电子病历版本号取元数据
/// 参数列表：
/// MrDiagnosVer：电子病历版本号
/// paadm       ：就诊
/// eleCode     ：元数据代码
/// isGetCode   ：1表示取该项的代码，0表示取描述
/// debug:w ##Class(web.DHCWMRMedBaseDiagnose).GetEPRElement(2,77089,"#TYPE:Segment#TID:33#TVER:0#GCODE:G0190",0) 
ClassMethod GetEPRElement(MrDiagnosVer, paadm, eleCode, isGetCode)
{
	n (MrDiagnosVer,paadm, eleCode, isGetCode)
	s ret=""
	s:MrDiagnosVer=1 ret=..GetEPRV1Element(paadm, eleCode, isGetCode)
	s:MrDiagnosVer=2 ret=..GetEPRV2Element(paadm, eleCode, isGetCode)
	s:MrDiagnosVer=3 ret=..GetEPRV3Element(paadm, eleCode,isGetCode)
	q ret
}

/// 构造电子病历诊断串
/// w ##class(web.DHCWMRMedBaseDiagnose).GetEPRDiagnose(387,2)
ClassMethod GetEPRDiagnose(Paadm, MrDiagnosVer)
{
	New (Paadm,MrDiagnosVer)
    Set ICDDR=""  ;$p(sDIA,"^",1)
    Set ICDDoctorDR=""  ;$p(sDIA,"^",4)
    Set ICDDate=""  ;$zd(+$p(sDIA,"^",7),3)
    Set ICDTime=""  ;$zt(+$p(sDIA,"^",8))
    Set ICDType=""  ;$g(^MR(+MRADM,"DIA",MRDIAChildsub,"TYP","1"))
    Set Paadmtype=$p($g(^PAADM(Paadm)),"^",2)
    Set CTloc=$p($g(^PAADM(Paadm)),"^",4)
    Set LocDesc=CTloc_"/"_$p(^CTLOC(+CTloc),"^",2)
    Set DiaStr=Paadm_$c(2)_Paadmtype_$c(2)_LocDesc_$c(2)_"MRDIA"_$c(2)_"ICDDR"_$c(2)_ICDDoctorDR_$c(2)_ICDType_$c(2)_ICDDate_$c(2)_ICDTime_$c(2)_""
    Set TMP="",Separate="^"
    
    If (MrDiagnosVer=2)||(MrDiagnosVer=1) {         //元数据取数据
        Set Index=""
        For {
	      Set Index=$o(^DHCWMRDiaSetting("DIA",Index))
	      Quit:Index=""
	      Set EleCode=$g(^DHCWMRDiaSetting("DIA",Index))
	      Continue:EleCode=""
	      Set DiaStr=..GetDiagnoseByEleCode(Paadm,EleCode,MrDiagnosVer,DiaStr,Separate,Index,"")
	      Set TMP=TMP_DiaStr_$c(1)
	    }
    }Else{                                          //通用术语集取数据
	    Set Separate="|"
	    Set DicOfDiaString=##Class(web.DHCWMRDictionaryCtl).GetDicByType("FPICDType")
		Set DiaCount=$l(DicOfDiaString,$c(2)) 
		For Index=1:1:DiaCount {
			Set EleCode=$p(DicOfDiaString,$c(2),Index)
			Set ICDTypeDesc=$p(EleCode,"#TYPE:",1)  //取诊断描述
			Set EleCode=$p(EleCode,"#TYPE:",2)
			Continue:EleCode=""
			Set Count=$l(EleCode,",")
			
			For Ind=1:1:Count {
				Set SEleCode=$p(EleCode,",",Ind)
				Continue:SEleCode=""
				Set IIndex=Index+Ind-1
			    Set DiaString=..GetDiagnoseByEleCode(Paadm,SEleCode,MrDiagnosVer,DiaStr,Separate,IIndex,ICDTypeDesc)
			    Continue:DiaString=""
			    Set TMP=TMP_DiaString_$c(1)
			}
		}
	}
	Quit TMP
}

/// Input:Paadm 就诊ID MrDiagnosVer=1或2 EleCode通过元数据取数据，MrDiagnosVer=3 EleCode通过通用术语集取数据
/// 描述：根据EleCode获取诊断信息
/// Debug:w ##Class().GetDiagnoseByEleCode(387,"主要诊断#TYPE:HDSD00.11.024|HDSD00.11.023||HDSD00.11.304",3,"","")
ClassMethod GetDiagnoseByEleCode(Paadm As %String, EleCode As %String, MrDiagnosVer As %String, RtnString As %String, Separate As %String, Index As %String, ICDTypeDesc As %String = "")
{
	New (Paadm,EleCode,MrDiagnosVer,RtnString,Separate,Index,ICDTypeDesc)
	Set tmpEleCode=EleCode
	Set MrDiagnosVer=MrDiagnosVer
	Set Rtn=""
	Set eleCode1=$p(tmpEleCode,Separate,1)
    Set eleCode2=$p(tmpEleCode,Separate,2)
    Set eleCode3=$p(tmpEleCode,Separate,3)
    Set eleCode4=$p(tmpEleCode,Separate,4)
    
    Set ICDDesc=..GetEPRElement(MrDiagnosVer,Paadm, eleCode1,0)
    Set ICDDesc=$tr(ICDDesc,"/","")
    Set ICDDesc=$tr(ICDDesc,"&nbsp;"," ")
    Quit:(ICDDesc="")!(ICDDesc="无") Rtn   ;先取诊断描述，如无诊断描述，退出
    Set ICDRowid=..GetEPRElement(MrDiagnosVer,Paadm, eleCode2,1)
    Set ICDRowid=$tr(ICDRowid,"/","")  ;部分医院存的是ICDCode，部分医院是ICDRowid
    If ICDRowid'="" {
       Set tmpICD=$g(^MRC("ID",ICDRowid))
       If $p(tmpICD,"^",2)=ICDDesc {
          Set ICDCode=$p(tmpICD,"^",4)
       } Else { 
          Set ICDCode=""
          Set:ICDDesc[$p(tmpICD,"^",2) ICDCode="*"_$p(tmpICD,"^",4)
          Set:((+ICDRowid)=0)||(ICDRowid[".") ICDCode="*"_ICDRowid
          Set ICDRowid=""
       } 
    } 
    Else {
          Set ICDRowid="",ICDCode=""
    }
    Set ICDDR=ICDRowid_"%%"_ICDCode_"%%"_ICDDesc
    Set:(ICDTypeDesc="")||(eleCode1["#TYPE:") ICDTypeDesc=$p(eleCode1,"#TYPE:",1)
    Set ICDType=Index_"/"_Index_"/"_ICDTypeDesc
    ;是否确诊 或 怀疑诊断类型
    Set ResumeTest=..GetEPRElement(MrDiagnosVer,Paadm, eleCode3,0)
    ;入院病情
    Set AdmCondition=..GetEPRElement(MrDiagnosVer,Paadm, eleCode4,0)
    Set $p(RtnString,$c(2),5)=ICDDR
    Set $p(RtnString,$c(2),7)=ICDType
    Set $p(RtnString,$c(2),10)=ResumeTest
    Set $p(RtnString,$c(2),11)=AdmCondition
    Quit RtnString
}

/// 根据设置取paadm的HIS诊断信息列表
/// w ##Class(web.DHCWMRMedBaseDiagnose).GetMrDiagnose(339)
ClassMethod GetMrDiagnose(paadm)
{
	n (paadm)
	Set ^Test=paadm
	s s=""
	q:paadm="" s
	;s MrDiagnosVer=+$g(^DHCWMRDiaSetting("DIA"))
	s MrDiagnosVer=##Class(web.DHCWMRDictionaryCtl).GetDataByTypeAndCode("FPCodingType","DiagnoseSetting")
	i MrDiagnosVer=0 d
	.s s=##class(web.DHCWMRBasePaadm).GetMrDiagnose(paadm)
	e  d
	.s s=..GetEPRDiagnose(paadm,MrDiagnosVer)
	q s
}

/// 构造电子病历手术信息串
/// w ##class(web.DHCWMRMedBaseDiagnose).GetEPROper(387,3)
ClassMethod GetEPROper(Paadm, MrOperVer)
{
	New (Paadm,MrOperVer)
	;Set ^CacheTemp("GetEPROper")=Paadm_","_MrOperVer
	Set Tmp=""
	If ((MrOperVer=1)||(MrOperVer=2)) {
		Set (TmpString,Index,TmpRow)="",ASeparate=$c(2),TwoSeparate=$c(3)
		For {
			Set Index=$o(^DHCWMROperSetting("OPER",Index))	
			Quit:Index=""
			Set TmpString=$g(^DHCWMROperSetting("OPER",Index))
			Continue:TmpString=""
			Set TmpRow=..GetOperationByEleCode(Paadm,TmpString,MrOperVer,ASeparate,TwoSeparate)
			Set Tmp=Tmp_TmpRow_$s(TmpRow="":"",1:$c(1))
		}
	} Else {
		Set DicStr=##Class(web.DHCWMRDictionaryCtl).GetDicByType("FPOpertionInfo")
		Set DicCount=$l(DicStr,$c(2))
		Set (TmpString,Index,TmpRow)="",ASeparate="|",TwoSeparate="%"
		For Index=1:1:DicCount {
			Set TmpString=""
			Set TmpString=$p(DicStr,$c(2),Index)
			Set:TmpString["#TYPE:" TmpString=$p(TmpString,"#TYPE:",2)
			Continue:TmpString=""
			Set TmpRow=..GetOperationByEleCode(Paadm,TmpString,MrOperVer,ASeparate,TwoSeparate)
			Set Tmp=Tmp_TmpRow_$s(TmpRow="":"",1:$c(1))
		}
	}
	Quit Tmp
}

/// 描述：根据TmpString取病案首页手术数据
/// Input:Paadm 就诊ID、TmpString取值字符串、 MrOperVer 版本、ASeparate TmpString字符串一级分割符、TwoSeparate TmpString字符串二级分割符
ClassMethod GetOperationByEleCode(Paadm As %String, TmpString As %String, MrOperVer As %String, ASeparate As %String, TwoSeparate As %String)
{
	New (Paadm,TmpString,MrOperVer,ASeparate,TwoSeparate)
	
	Set FieldCount=$l(TmpString,ASeparate),(Rtn,TmpRow,TmpField)=""
	For FieldIndex=1:1:FieldCount {
		;如果手术名称为空,退出,手术名称为第二个字段
		Quit:(FieldIndex=3)&&(TmpField="")
		
		Set TmpEleExp=$p(TmpString,ASeparate,FieldIndex)
		b:FieldIndex=FieldCount ;11
		Set TmpField=$$GetOPERField(Paadm,TmpEleExp,MrOperVer,TwoSeparate)
		Set TmpRow=TmpRow_TmpField_$c(2)
	}
	Set TmpRow=$e(TmpRow,1,$l(TmpRow)-1)
	Quit:((FieldIndex=3)&&(TmpField=""))||(TmpRow="")||(TmpRow=$c(2)) Rtn
	//手术Rowid,手术名称,手术编码
    Set OperRowid=$p(TmpRow,$c(2),1)
    Set OperCode=$p(TmpRow,$c(2),13)
    Set OperDesc=$p(TmpRow,$c(2),2)
    If (OperRowid'="") {
       Set TmpOper=$g(^ORC("OPER",OperRowid))
       If ($p(TmpOper,"^",2)=OperDesc) {
          Set OperCode=$p(TmpOper,"^",21)
          Set:OperCode="" OperRowid=""
       } Else {
          Set OperCode="*"_$p(TmpOper,"^",21)
          Set OperRowid=""
       }
    } Else {
         Set OperCode="*"_OperCode
    }
    Set OperDesc=$tr(OperDesc,"/","")
    Set OperDesc=$tr(OperDesc,"&nbsp;"," ")
    Quit:(OperDesc="")!(OperDesc="无") Rtn   ;先取诊断描述，如无诊断描述，退出
    Set $p(TmpRow,$c(2),1)=OperRowid
    Set $p(TmpRow,$c(2),2)=OperDesc
    Set $p(TmpRow,$c(2),13)=OperCode
    //手术日期
    Set OperDate=$p(TmpRow,$c(2),3)
    Set:OperDate'="" OperDate=$p(OperDate," ",1)
    Set:OperDate'="" OperDate=$zd($zdh(OperDate,3),3)
    Set $p(TmpRow,$c(2),3)=OperDate
    //手术开始日期
    Set OperDate1=$p(TmpRow,$c(2),5)
    Set:OperDate1'="" OperDate1=$p(OperDate1," ",1)
    Set:OperDate1'="" OperDate1=$zd($zdh(OperDate1,3),3)
    Set $p(TmpRow,$c(2),5)=OperDate1
    //术者
    Set OperDoc=$p(TmpRow,$c(2),9)
    Set OperDocCode=$$ALPHAUP^SSUTIL4($p(OperDoc,"/",2))
    If (OperDocCode'="") {
       Set OperDocRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",OperDocCode,0))
       Set:'$d(^SSU("SSUSR",OperDocRowid)) OperDocRowid=""
       Set SSUser=$g(^SSU("SSUSR",+OperDocRowid))
       If ($p(SSUser,"^",2)'=$p(OperDoc,"/",3)) {
          Set $p(OperDoc,"/",1)=""
          Set $p(OperDoc,"/",2)=""
       } Else {
          Set $p(OperDoc,"/",1)=OperDocRowid
       }
    }
    Set $p(TmpRow,$c(2),9)=OperDoc
    //麻醉医师
    Set AnaDoc=$p(TmpRow,$c(2),11)
    Set AnaDocCode=$$ALPHAUP^SSUTIL4($p(AnaDoc,"/",2))
    If (AnaDocCode'="") {
       Set AnaDocRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",AnaDocCode,0))
       Set:'$d(^SSU("SSUSR",AnaDocRowid)) AnaDocRowid=""
       Set SSUser=$g(^SSU("SSUSR",+AnaDocRowid))
       If ($p(SSUser,"^",2)'=$p(AnaDoc,"/",3)) {
          Set $p(AnaDoc,"/",1)=""
          Set $p(AnaDoc,"/",2)=""
       } Else {
          Set $p(AnaDoc,"/",1)=AnaDocRowid
       }
    }
    Set $p(TmpRow,$c(2),11)=AnaDoc
    //1助$C(3)2助
    Set AssDocs=$p(TmpRow,$c(2),12)
    For Ind=1:1:$l(AssDocs,$c(3)) {
        Set AssDoc=$p(AssDocs,$c(3),Ind)
        Set AssDocCode=$$ALPHAUP^SSUTIL4($p(AssDoc,"/",2))
        If (AssDocCode'="") {
           Set AssDocRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",AssDocCode,0))
           Set:'$d(^SSU("SSUSR",AssDocRowid)) AssDocRowid=""
           Set SSUser=$g(^SSU("SSUSR",+AssDocRowid))
           If ($p(SSUser,"^",2)'=$p(AssDoc,"/",3)) {
              Set $p(AssDoc,"/",1)=""
              Set $p(AssDoc,"/",2)=""
           } Else {
              Set $p(AssDoc,"/",1)=AssDocRowid
           }
         }
         Set $p(AssDocs,$c(3),Ind)=AssDoc
    }
    Set $p(TmpRow,$c(2),12)=AssDocs
    //切口愈合等级1
    Set CloseUp1=$p(TmpRow,$c(2),14)
    Set:CloseUp1["Ⅰ" CloseUp1=$tr(CloseUp1,"Ⅰ","I")
    Set:CloseUp1["Ⅱ" CloseUp1=$tr(CloseUp1,"Ⅱ","II")
    Set:CloseUp1["Ⅲ" CloseUp1=$tr(CloseUp1,"Ⅲ","III")
    Set $p(TmpRow,$c(2),14)=CloseUp1
    Set Rtn=TmpRow
    Quit Rtn
    
GetOPERField(Paadm,TmpEleExp,MrOperVer,TwoSeparate)
    New (Paadm,TmpEleExp,MrOperVer,TwoSeparate)
    Set TmpField=""
    Quit:TmpEleExp="" TmpField
    Set FieldLen=$l(TmpEleExp,TwoSeparate)     ;一个字段多数据，如：助手列表
    for IField=1:1:FieldLen {
        Set MyField=$p(TmpEleExp,TwoSeparate,IField)
        Set EleCode=$p(MyField,"/",1)
        Set EleTmpString=""
        Set IsCode=""
        For EleIndex=2:1:$l(MyField,"/") {  ;一个字段多值，如：术者
            Set IsCode=$p(MyField,"/",EleIndex)
            Set TmpCode=..GetEPRElement(MrOperVer,Paadm,EleCode,IsCode)
            ;Set TmpCode=$p($p(EleCode,"#",1),".",2)_"-"_Paadm_"-"_IsCode
            ;Set EleTmpString=EleTmpString_TmpCode_$s(EleTmpString="":"",1:"/")
            Set $p(EleTmpString,"/",EleIndex-1)=TmpCode
        }
        If ($l(MyField,"/")=1) {
	        Set EleTmpString=..GetEPRElement(MrOperVer,Paadm,EleCode,IsCode)
	    }
        Continue:EleTmpString=""
        Continue:EleTmpString="/"
        If (FieldLen>1) {
          Set TmpField=TmpField_EleTmpString_$c(3)
          Set $p(TmpField,$c(3),IField)=EleTmpString
        } Else {
	      Set TmpField=EleTmpString
	    }
    }
    Quit TmpField
}

/// 根据设置取paadm的HIS手术信息列表
/// w ##Class(web.DHCWMRMedBaseDiagnose).GetMrOper(387)
ClassMethod GetMrOper(paadm)
{
	n (paadm)
	s s=""
	q:paadm="" s
	;s MrOperVer=+$g(^DHCWMROperSetting("OPER"))
	s MrOperVer=##Class(web.DHCWMRDictionaryCtl).GetDataByTypeAndCode("FPCodingType","OperationSetting")
	i MrOperVer=0 d
	.s s=##class(web.DHCWMRMedBaseArcimCtl).GetOrdsOper(paadm)
	e  d
	.s s=..GetEPROper(paadm,MrOperVer)
	q s
}

}
