Import SQLUser

/// 取电子病历诊断或临床诊断
/// by wuqk 2008-05-13
Class web.DHCMedBaseDiagnose Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 182;

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
/// d ##Class(web.DHCMedBaseDiagnose).SetDHCWMRDiaSetting()
ClassMethod SetDHCWMRDiaSetting()
{
	//共四个字段,以“^”分割
	//诊断名称^诊断代码(ICD10)^怀疑诊断类型^出院情况
	set ^DHCWMRDiaSetting("DIA")=2
	set HospCode=##class(web.DHCMedBase01).GetDefaultHospCode()
	
	//浙江衢州医院取EPR诊断信息 元数据代码
	if (HospCode="QiZhou_RM") {
		set ^DHCWMRDiaSetting("DIA")=2
		set ^DHCWMRDiaSetting("DIA",1)="主要诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0002#VTYPE:V^主要诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0002#VTYPE:V^怀疑诊断类型1#TYPE:Simple#TID:845#TVER:0#SCODE:O0095#VTYPE:V^出院情况主要诊断#TYPE:Simple#TID:845#TVER:0#SCODE:O0024#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",2)="其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0003#VTYPE:V^其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0003#VTYPE:V^怀疑诊断类型2#TYPE:Simple#TID:845#TVER:0#SCODE:O0096#VTYPE:V^出院情况次要诊断#TYPE:Simple#TID:845#TVER:0#SCODE:O0025#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",3)="其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0009#VTYPE:V^其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0009#VTYPE:V^怀疑诊断类型3#TYPE:Simple#TID:845#TVER:0#SCODE:O0097#VTYPE:V^出院情况次要诊断#TYPE:Simple#TID:845#TVER:0#SCODE:O0026#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",4)="其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0010#VTYPE:V^其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0010#VTYPE:V^怀疑诊断类型4#TYPE:Simple#TID:845#TVER:0#SCODE:O0106#VTYPE:V^出院情况次要诊断#TYPE:Simple#TID:845#TVER:0#SCODE:O0027#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",5)="其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0011#VTYPE:V^其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0011#VTYPE:V^怀疑诊断类型5#TYPE:Simple#TID:845#TVER:0#SCODE:O0105#VTYPE:V^出院情况次要诊断#TYPE:Simple#TID:845#TVER:0#SCODE:O0028#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",6)="其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0012#VTYPE:V^其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0012#VTYPE:V^怀疑诊断类型6#TYPE:Simple#TID:845#TVER:0#SCODE:O0104#VTYPE:V^出院情况次要诊断#TYPE:Simple#TID:845#TVER:0#SCODE:O0029#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",7)="其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0013#VTYPE:V^其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0013#VTYPE:V^怀疑诊断类型7#TYPE:Simple#TID:845#TVER:0#SCODE:O0103#VTYPE:V^出院情况次要诊断#TYPE:Simple#TID:845#TVER:0#SCODE:O0030#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",8)="其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0036#VTYPE:V^其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0036#VTYPE:V^怀疑诊断类型8#TYPE:Simple#TID:845#TVER:0#SCODE:O0098#VTYPE:V^出院情况次要诊断#TYPE:Simple#TID:845#TVER:0#SCODE:O0031#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",9)="其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0109#VTYPE:V^其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0109#VTYPE:V^怀疑诊断类型9#TYPE:Simple#TID:845#TVER:0#SCODE:O0102#VTYPE:V^出院情况次要诊断#TYPE:Simple#TID:845#TVER:0#SCODE:O0113#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",10)="其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0110#VTYPE:V^其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0110#VTYPE:V^怀疑诊断类型10#TYPE:Simple#TID:845#TVER:0#SCODE:O0101#VTYPE:V^出院情况次要诊断#TYPE:Simple#TID:845#TVER:0#SCODE:O0112#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",11)="其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0108#VTYPE:V^其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0108#VTYPE:V^怀疑诊断类型11#TYPE:Simple#TID:845#TVER:0#SCODE:O0100#VTYPE:V^出院情况次要诊断#TYPE:Simple#TID:845#TVER:0#SCODE:O0117#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",12)="其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0107#VTYPE:V^其他诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0107#VTYPE:V^怀疑诊断类型12#TYPE:Simple#TID:845#TVER:0#SCODE:O0099#VTYPE:V^出院情况次要诊断#TYPE:Simple#TID:845#TVER:0#SCODE:O0111#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",13)="病理诊断#TYPE:Simple#TID:845#TVER:0#SCODE:S0094#VTYPE:V^病理诊断#TYPE:Simple#TID:845#TVER:0#SCODE:S0094#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",14)="感染诊断#TYPE:Simple#TID:845#TVER:0#SCODE:S0079#VTYPE:V^感染诊断#TYPE:Simple#TID:845#TVER:0#SCODE:S0079#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",15)="损伤中毒诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0034#VTYPE:V^损伤中毒诊断#TYPE:Simple#TID:845#TVER:0#SCODE:I0034#VTYPE:V^^"
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
		set ^DHCWMRDiaSetting("DIA",1)="病案摘要.病案首页.出院情况.出院情况.主要诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0003#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.主要诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0003#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况主要诊断#TYPE:Simple#TID:142#TVER:0#SCODE:O0014#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",2)="病案摘要.病案首页.出院情况.出院情况.其他诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0004#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.其他诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0004#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况其他诊断#TYPE:Simple#TID:142#TVER:0#SCODE:O0015#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",3)="病案摘要.病案首页.出院情况.出院情况.次要诊断1#TYPE:Simple#TID:142#TVER:0#SCODE:I0005#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.次要诊断1#TYPE:Simple#TID:142#TVER:0#SCODE:I0005#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况次要诊断1#TYPE:Simple#TID:142#TVER:0#SCODE:O0016#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",4)="病案摘要.病案首页.出院情况.出院情况.次要诊断2#TYPE:Simple#TID:142#TVER:0#SCODE:I0006#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.次要诊断2#TYPE:Simple#TID:142#TVER:0#SCODE:I0006#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况次要诊断2#TYPE:Simple#TID:142#TVER:0#SCODE:O0017#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",5)="病案摘要.病案首页.出院情况.出院情况.次要诊断3#TYPE:Simple#TID:142#TVER:0#SCODE:I0007#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.次要诊断3#TYPE:Simple#TID:142#TVER:0#SCODE:I0007#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况次要诊断3#TYPE:Simple#TID:142#TVER:0#SCODE:O0018#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",6)="病案摘要.病案首页.出院情况.出院情况.次要诊断4#TYPE:Simple#TID:142#TVER:0#SCODE:I0008#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.次要诊断4#TYPE:Simple#TID:142#TVER:0#SCODE:I0008#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况次要诊断4#TYPE:Simple#TID:142#TVER:0#SCODE:O0019#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",7)="病案摘要.病案首页.出院情况.出院情况.次要诊断5#TYPE:Simple#TID:142#TVER:0#SCODE:I0009#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.次要诊断5#TYPE:Simple#TID:142#TVER:0#SCODE:I0009#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况次要诊断5#TYPE:Simple#TID:142#TVER:0#SCODE:O0020#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",8)="病案摘要.病案首页.出院情况.出院情况.医院感染名称#TYPE:Simple#TID:142#TVER:0#SCODE:I0044#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.医院感染名称#TYPE:Simple#TID:142#TVER:0#SCODE:I0044#VTYPE:V^^病案摘要.病案首页.出院情况.出院情况.出院情况医院感染#TYPE:Simple#TID:142#TVER:0#SCODE:O0045#VTYPE:V"

		set ^DHCWMRDiaSetting("DIA",9)="病案摘要.病案首页.出院情况.出院情况.病理诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0011#VTYPE:V^病案摘要.病案首页.出院情况.出院情况.病理诊断#TYPE:Simple#TID:142#TVER:0#SCODE:I0011#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",10)="病案摘要.病案首页.一般情况.一般情况.门(急)诊诊断#TYPE:Simple#TID:141#TVER:0#SCODE:I0035#VTYPE:V^病案摘要.病案首页.一般情况.一般情况.门(急)诊诊断#TYPE:Simple#TID:141#TVER:0#SCODE:I0035#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",11)="病案摘要.病案首页.一般情况.一般情况.入院诊断#TYPE:Simple#TID:141#TVER:0#SCODE:I0037#VTYPE:V^病案摘要.病案首页.一般情况.一般情况.入院诊断#TYPE:Simple#TID:141#TVER:0#SCODE:I0037#VTYPE:V^^"
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
		set ^DHCWMRDiaSetting("DIA",8)="院内感染诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0038#VTYPE:V^院内感染诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0038#VTYPE:V^^院内感染诊断#TYPE:Simple#TID:2#TVER:0#SCODE:O0080#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",9)="病理诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0104#VTYPE:V^病理诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0104#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",10)="损伤中毒诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0034#VTYPE:V^损伤中毒诊断#TYPE:Simple#TID:2#TVER:0#SCODE:I0034#VTYPE:V^^"
	
		set ^DHCWMRDiaSetting("DIA",11)="门急诊诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0043#VTYPE:V^门急诊诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0043#VTYPE:V^^"
		set ^DHCWMRDiaSetting("DIA",12)="入院诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0044#VTYPE:V^入院诊断#TYPE:Simple#TID:1#TVER:0#SCODE:I0044#VTYPE:V^^"
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
		set ^DHCWMRDiaSetting("DIA",1)="首页出院情况.主要诊断#TYPE:Simple#TID:67#TVER:0#SCODE:I0002#VTYPE:V^首页出院情况.主要诊断#TYPE:Simple#TID:67#TVER:0#SCODE:I0002#VTYPE:V^首页出院情况.怀疑诊断类型1#TYPE:Simple#TID:67#TVER:0#SCODE:O0095#VTYPE:V^首页出院情况.出院情况主要诊断#TYPE:Simple#TID:67#TVER:0#SCODE:O0024#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",2)="首页出院情况.次要诊断2#TYPE:Simple#TID:67#TVER:0#SCODE:I0003#VTYPE:V^首页出院情况.次要诊断2#TYPE:Simple#TID:67#TVER:0#SCODE:I0003#VTYPE:V^首页出院情况.怀疑诊断类型2#TYPE:Simple#TID:67#TVER:0#SCODE:O0096#VTYPE:V^首页出院情况.出院情况次要诊断2#TYPE:Simple#TID:67#TVER:0#SCODE:O0025#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",3)="首页出院情况.次要诊断3#TYPE:Simple#TID:67#TVER:0#SCODE:I0009#VTYPE:V^首页出院情况.次要诊断3#TYPE:Simple#TID:67#TVER:0#SCODE:I0009#VTYPE:V^首页出院情况.怀疑诊断类型3#TYPE:Simple#TID:67#TVER:0#SCODE:O0097#VTYPE:V^首页出院情况.出院情况次要诊断3#TYPE:Simple#TID:67#TVER:0#SCODE:O0026#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",4)="首页出院情况.次要诊断4#TYPE:Simple#TID:67#TVER:0#SCODE:I0010#VTYPE:V^首页出院情况.次要诊断4#TYPE:Simple#TID:67#TVER:0#SCODE:I0010#VTYPE:V^首页出院情况.怀疑诊断类型4#TYPE:Simple#TID:67#TVER:0#SCODE:O0106#VTYPE:V^首页出院情况.出院情况次要诊断4#TYPE:Simple#TID:67#TVER:0#SCODE:O0027#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",5)="首页出院情况.次要诊断5#TYPE:Simple#TID:67#TVER:0#SCODE:I0011#VTYPE:V^首页出院情况.次要诊断5#TYPE:Simple#TID:67#TVER:0#SCODE:I0011#VTYPE:V^首页出院情况.怀疑诊断类型5#TYPE:Simple#TID:67#TVER:0#SCODE:O0105#VTYPE:V^首页出院情况.出院情况次要诊断5#TYPE:Simple#TID:67#TVER:0#SCODE:O0028#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",6)="首页出院情况.次要诊断6#TYPE:Simple#TID:67#TVER:0#SCODE:I0012#VTYPE:V^首页出院情况.次要诊断6#TYPE:Simple#TID:67#TVER:0#SCODE:I0012#VTYPE:V^首页出院情况.怀疑诊断类型6#TYPE:Simple#TID:67#TVER:0#SCODE:O0104#VTYPE:V^首页出院情况.出院情况次要诊断6#TYPE:Simple#TID:67#TVER:0#SCODE:O0029#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",7)="首页出院情况.次要诊断7#TYPE:Simple#TID:67#TVER:0#SCODE:I0013#VTYPE:V^首页出院情况.次要诊断7#TYPE:Simple#TID:67#TVER:0#SCODE:I0013#VTYPE:V^首页出院情况.怀疑诊断类型7#TYPE:Simple#TID:67#TVER:0#SCODE:O0103#VTYPE:V^首页出院情况.出院情况次要诊断7#TYPE:Simple#TID:67#TVER:0#SCODE:O0030#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",8)="首页出院情况.次要诊断8#TYPE:Simple#TID:67#TVER:0#SCODE:I0036#VTYPE:V^首页出院情况.次要诊断8#TYPE:Simple#TID:67#TVER:0#SCODE:I0036#VTYPE:V^首页出院情况.怀疑诊断类型8#TYPE:Simple#TID:67#TVER:0#SCODE:O0098#VTYPE:V^首页出院情况.出院情况次要诊断8#TYPE:Simple#TID:67#TVER:0#SCODE:O0031#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",9)="首页出院情况.次要诊断9#TYPE:Simple#TID:67#TVER:0#SCODE:I0109#VTYPE:V^首页出院情况.次要诊断9#TYPE:Simple#TID:67#TVER:0#SCODE:I0109#VTYPE:V^首页出院情况.怀疑诊断类型9#TYPE:Simple#TID:67#TVER:0#SCODE:O0102#VTYPE:V^首页出院情况.出院情况次要诊断9#TYPE:Simple#TID:67#TVER:0#SCODE:O0113#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",10)="首页出院情况.次要诊断10#TYPE:Simple#TID:67#TVER:0#SCODE:I0110#VTYPE:V^首页出院情况.次要诊断10#TYPE:Simple#TID:67#TVER:0#SCODE:I0110#VTYPE:V^首页出院情况.怀疑诊断类型10#TYPE:Simple#TID:67#TVER:0#SCODE:O0101#VTYPE:V^首页出院情况.出院情况次要诊断10#TYPE:Simple#TID:67#TVER:0#SCODE:O0112#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",11)="首页出院情况.次要诊断11#TYPE:Simple#TID:67#TVER:0#SCODE:I0108#VTYPE:V^首页出院情况.次要诊断11#TYPE:Simple#TID:67#TVER:0#SCODE:I0108#VTYPE:V^首页出院情况.怀疑诊断类型11#TYPE:Simple#TID:67#TVER:0#SCODE:O0100#VTYPE:V^首页出院情况.出院情况次要诊断11#TYPE:Simple#TID:67#TVER:0#SCODE:O0117#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",12)="首页出院情况.次要诊断12#TYPE:Simple#TID:67#TVER:0#SCODE:I0107#VTYPE:V^首页出院情况.次要诊断12#TYPE:Simple#TID:67#TVER:0#SCODE:I0107#VTYPE:V^首页出院情况.怀疑诊断类型12#TYPE:Simple#TID:67#TVER:0#SCODE:O0099#VTYPE:V^首页出院情况.出院情况次要诊断12#TYPE:Simple#TID:67#TVER:0#SCODE:O0111#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",13)="首页出院情况.次要诊断13#TYPE:Simple#TID:67#TVER:0#SCODE:I0037#VTYPE:V^首页出院情况.次要诊断13#TYPE:Simple#TID:67#TVER:0#SCODE:I0037#VTYPE:V^首页出院情况.怀疑诊断类型13#TYPE:Simple#TID:67#TVER:0#SCODE:O0119#VTYPE:V^首页出院情况.出院情况次要诊断13#TYPE:Simple#TID:67#TVER:0#SCODE:O0116#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",14)="首页出院情况.次要诊断14#TYPE:Simple#TID:67#TVER:0#SCODE:I0035#VTYPE:V^首页出院情况.次要诊断14#TYPE:Simple#TID:67#TVER:0#SCODE:I0035#VTYPE:V^首页出院情况.怀疑诊断类型14#TYPE:Simple#TID:67#TVER:0#SCODE:O0127#VTYPE:V^首页出院情况.出院情况次要诊断14#TYPE:Simple#TID:67#TVER:0#SCODE:O0032#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",15)="首页出院情况.次要诊断15#TYPE:Simple#TID:67#TVER:0#SCODE:I0090#VTYPE:V^首页出院情况.次要诊断15#TYPE:Simple#TID:67#TVER:0#SCODE:I0090#VTYPE:V^首页出院情况.怀疑诊断类型15#TYPE:Simple#TID:67#TVER:0#SCODE:O0126#VTYPE:V^首页出院情况.出院情况次要诊断15#TYPE:Simple#TID:67#TVER:0#SCODE:O0123#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",16)="首页出院情况.次要诊断16#TYPE:Simple#TID:67#TVER:0#SCODE:I0038#VTYPE:V^首页出院情况.次要诊断16#TYPE:Simple#TID:67#TVER:0#SCODE:I0038#VTYPE:V^首页出院情况.怀疑诊断类型16#TYPE:Simple#TID:67#TVER:0#SCODE:O0125#VTYPE:V^首页出院情况.出院情况次要诊断16#TYPE:Simple#TID:67#TVER:0#SCODE:O0124#VTYPE:V"
		set ^DHCWMRDiaSetting("DIA",17)="首页出院情况.病理诊断#TYPE:Simple#TID:67#TVER:0#SCODE:S0094#VTYPE:V^^^"
		set ^DHCWMRDiaSetting("DIA",18)="首页出院情况.医院感染诊断#TYPE:Simple#TID:67#TVER:0#SCODE:S0079#VTYPE:V^^^"
		set ^DHCWMRDiaSetting("DIA",19)="首页出院情况.损伤、中毒的外部因素#TYPE:Simple#TID:67#TVER:0#SCODE:I0034#VTYPE:V^^^"
		set ^DHCWMRDiaSetting("DIA",20)="首页一般情况.门(急)诊诊断#TYPE:Simple#TID:66#TVER:0#SCODE:I0043#VTYPE:V^^^"
		set ^DHCWMRDiaSetting("DIA",21)="首页一般情况.入院诊断1#TYPE:Simple#TID:66#TVER:0#SCODE:I0044#VTYPE:V^^^"
		set ^DHCWMRDiaSetting("DIA",22)="首页一般情况.入院诊断2#TYPE:Simple#TID:66#TVER:0#SCODE:I0078#VTYPE:V^^^"
	}
	*/
	
	quit
}

/// ------add by wuqk 2008-05-13------
/// 设置当前医院病案编目时取HIS手术的数据来源
/// ^DHCWMROperSetting("OPER")
/// 0：根据当前医院设置调用##class(web.DHCMedBaseArcimCtl).GetOrdsOper()
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
/// d ##Class(web.DHCMedBaseDiagnose).SetDHCWMROperSetting()
ClassMethod SetDHCWMROperSetting()
{
    
	set ^DHCWMROperSetting("OPER")=2
	
    s opRowid=""
    s status=""
    s startDate=""
    s startTime=""
    s EndDate=""
    s EndTime=""
    set HospCode=##class(web.DHCMedBase01).GetDefaultHospCode()
    
	//浙江衢州医院EPR手术操作信息 元数据代码
    if (HospCode="BeiJing_DT") {
		s OPRowid1 ="手术操作名称1#TYPE:Simple#TID:846#TVER:0#SCODE:I0022#VTYPE:V/1"
		s OPRowid2 ="手术操作名称2#TYPE:Simple#TID:846#TVER:0#SCODE:I0023#VTYPE:V/1"
		s OPRowid3 ="手术操作名称3#TYPE:Simple#TID:846#TVER:0#SCODE:I0024#VTYPE:V/1"
		s OPRowid4 ="手术操作名称4#TYPE:Simple#TID:846#TVER:0#SCODE:I0025#VTYPE:V/1"
		s OPRowid5 ="手术操作名称5#TYPE:Simple#TID:846#TVER:0#SCODE:I0093#VTYPE:VV/1"
		
		s OPDesc1 ="手术操作名称1#TYPE:Simple#TID:846#TVER:0#SCODE:I0022#VTYPE:V/0"
		s OPDesc2 ="手术操作名称2#TYPE:Simple#TID:846#TVER:0#SCODE:I0023#VTYPE:V/0"
		s OPDesc3 ="手术操作名称3#TYPE:Simple#TID:846#TVER:0#SCODE:I0024#VTYPE:V/0"
		s OPDesc4 ="手术操作名称4#TYPE:Simple#TID:846#TVER:0#SCODE:I0025#VTYPE:V/0"
		s OPDesc5 ="手术操作名称5#TYPE:Simple#TID:846#TVER:0#SCODE:I0093#VTYPE:V/0"
		
		s OPCode1 =""
		s OPCode2 =""
		s OPCode3 =""
		s OPCode4 =""
		s OPCode5 =""
		
		s OPDate1="手术操作日期1#TYPE:Simple#TID:846#TVER:0#SCODE:D0141#VTYPE:V/1"
		s OPDate2="手术操作日期2#TYPE:Simple#TID:846#TVER:0#SCODE:D0142#VTYPE:V/1"
		s OPDate3="手术操作日期3#TYPE:Simple#TID:846#TVER:0#SCODE:D0143#VTYPE:V/1"
		s OPDate4="手术操作日期4#TYPE:Simple#TID:846#TVER:0#SCODE:D0145#VTYPE:V/1"
		s OPDate5="手术操作日期5#TYPE:Simple#TID:846#TVER:0#SCODE:D0149#VTYPE:V/1"
		
		s OPDoc1="术者1#TYPE:Simple#TID:846#TVER:0#SCODE:I0026#VTYPE:V//1/0"
		s OPDoc2="术者2#TYPE:Simple#TID:846#TVER:0#SCODE:I0027#VTYPE:V//1/0"
		s OPDoc3="术者3#TYPE:Simple#TID:846#TVER:0#SCODE:I0028#VTYPE:V//1/0"
		s OPDoc4="术者4#TYPE:Simple#TID:846#TVER:0#SCODE:I0029#VTYPE:V//1/0"
		s OPDoc5="术者5#TYPE:Simple#TID:846#TVER:0#SCODE:I0098#VTYPE:V//1/0"
		
		s anaMethod1="麻醉方式1#TYPE:Simple#TID:846#TVER:0#SCODE:I0153#VTYPE:V/0"
		s anaMethod2="麻醉方式2#TYPE:Simple#TID:846#TVER:0#SCODE:I0154#VTYPE:V/0"
		s anaMethod3="麻醉方式3#TYPE:Simple#TID:846#TVER:0#SCODE:I0155#VTYPE:V/0"
		s anaMethod4="麻醉方式4#TYPE:Simple#TID:846#TVER:0#SCODE:I0156#VTYPE:V/0"
		s anaMethod5="麻醉方式5#TYPE:Simple#TID:846#TVER:0#SCODE:I0157#VTYPE:V/0"
		
		s anaDoc1="麻醉医师1#TYPE:Simple#TID:846#TVER:0#SCODE:I0051#VTYPE:V//1/0"
		s anaDoc2="麻醉医师2#TYPE:Simple#TID:846#TVER:0#SCODE:I0050#VTYPE:V//1/0"
		s anaDoc3="麻醉医师3#TYPE:Simple#TID:846#TVER:0#SCODE:I0052#VTYPE:V//1/0"
		s anaDoc4="麻醉医师4#TYPE:Simple#TID:846#TVER:0#SCODE:I0053#VTYPE:V//1/0"
		s anaDoc5="麻醉医师5#TYPE:Simple#TID:846#TVER:0#SCODE:I00134#VTYPE:V//1/0"
		
		s AssDoc11="1助1#TYPE:Simple#TID:846#TVER:0#SCODE:I0030#VTYPE:V//1/0"
		s AssDoc12="1助2#TYPE:Simple#TID:846#TVER:0#SCODE:I0031#VTYPE:V//1/0"
		s AssDoc13="1助3#TYPE:Simple#TID:846#TVER:0#SCODE:I0032#VTYPE:V//1/0"
		s AssDoc14="1助4#TYPE:Simple#TID:846#TVER:0#SCODE:I0033#VTYPE:V//1/0"
		s AssDoc15="1助5#TYPE:Simple#TID:846#TVER:0#SCODE:I00104#VTYPE:V//1/0"
		
		s AssDoc21="2助1#TYPE:Simple#TID:846#TVER:0#SCODE:I0034#VTYPE:V//1/0"
		s AssDoc22="2助2#TYPE:Simple#TID:846#TVER:0#SCODE:I0035#VTYPE:V//1/0"
		s AssDoc23="2助3#TYPE:Simple#TID:846#TVER:0#SCODE:I0037#VTYPE:V//1/0"
		s AssDoc24="2助4#TYPE:Simple#TID:846#TVER:0#SCODE:I0036#VTYPE:V//1/0"
		s AssDoc25="2助5#TYPE:Simple#TID:846#TVER:0#SCODE:I00110#VTYPE:V//1/0"
		
		s CutClose11="切口愈合等级11#TYPE:Simple#TID:846#TVER:0#SCODE:O0042#VTYPE:V//1/0"
		s CutClose12="切口愈合等级12#TYPE:Simple#TID:846#TVER:0#SCODE:O0047#VTYPE:V//1/0"
		s CutClose13="切口愈合等级13#TYPE:Simple#TID:846#TVER:0#SCODE:O0043#VTYPE:V//1/0"
		s CutClose14="切口愈合等级14#TYPE:Simple#TID:846#TVER:0#SCODE:O0049#VTYPE:V//1/0"
		s CutClose15="切口愈合等级15#TYPE:Simple#TID:846#TVER:0#SCODE:O00122#VTYPE:V//1/0"
		
		s CutClose21="切口愈合等级21#TYPE:Simple#TID:846#TVER:0#SCODE:O0048#VTYPE:V//1/0"
		s CutClose22="切口愈合等级22#TYPE:Simple#TID:846#TVER:0#SCODE:O0046#VTYPE:V//1/0"
		s CutClose23="切口愈合等级23#TYPE:Simple#TID:846#TVER:0#SCODE:O0045#VTYPE:V//1/0"
		s CutClose24="切口愈合等级24#TYPE:Simple#TID:846#TVER:0#SCODE:O0044#VTYPE:V//1/0"
		s CutClose25="切口愈合等级25#TYPE:Simple#TID:846#TVER:0#SCODE:O00128#VTYPE:V//1/0"
		
		s TMP1=OPRowid1_$c(2)_OPDesc1_$c(2)_OPDate1_$c(2)_status_$c(2)_OPDate1_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc1_$c(2)_anaMethod1_$c(2)_anaDoc1_$c(2)_AssDoc11_$c(3)_AssDoc21_$c(2)_OPCode1_$c(2)_CutClose11_$c(2)_CutClose21
	    s TMP2=OPRowid2_$c(2)_OPDesc2_$c(2)_OPDate2_$c(2)_status_$c(2)_OPDate2_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc2_$c(2)_anaMethod2_$c(2)_anaDoc2_$c(2)_AssDoc12_$c(3)_AssDoc22_$c(2)_OPCode2_$c(2)_CutClose12_$c(2)_CutClose22
	    s TMP3=OPRowid3_$c(2)_OPDesc3_$c(2)_OPDate3_$c(2)_status_$c(2)_OPDate3_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc3_$c(2)_anaMethod3_$c(2)_anaDoc3_$c(2)_AssDoc13_$c(3)_AssDoc23_$c(2)_OPCode3_$c(2)_CutClose13_$c(2)_CutClose23
	    s TMP4=OPRowid4_$c(2)_OPDesc4_$c(2)_OPDate4_$c(2)_status_$c(2)_OPDate4_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc4_$c(2)_anaMethod4_$c(2)_anaDoc4_$c(2)_AssDoc14_$c(3)_AssDoc24_$c(2)_OPCode4_$c(2)_CutClose14_$c(2)_CutClose24
	    s TMP5=OPRowid5_$c(2)_OPDesc5_$c(2)_OPDate5_$c(2)_status_$c(2)_OPDate5_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc5_$c(2)_anaMethod5_$c(2)_anaDoc5_$c(2)_AssDoc15_$c(3)_AssDoc25_$c(2)_OPCode5_$c(2)_CutClose15_$c(2)_CutClose25
	    
		set ^DHCWMROperSetting("OPER",1)=TMP1
		set ^DHCWMROperSetting("OPER",2)=TMP2
		set ^DHCWMROperSetting("OPER",3)=TMP3
		set ^DHCWMROperSetting("OPER",4)=TMP4
		set ^DHCWMROperSetting("OPER",5)=TMP5
	}
    
	//长春吉大三院(中日联合医院)EPR手术操作信息 元数据代码
    if (HospCode="ChangChun_JDSY") {
		s OPRowid1 ="手术操作名称1#TYPE:Simple#TID:3#TVER:0#SCODE:I0022#VTYPE:V/1"
		s OPRowid2 ="手术操作名称2#TYPE:Simple#TID:3#TVER:0#SCODE:I0023#VTYPE:V/1"
		s OPRowid3 ="手术操作名称3#TYPE:Simple#TID:3#TVER:0#SCODE:I0024#VTYPE:V/1"
		s OPRowid4 ="手术操作名称4#TYPE:Simple#TID:3#TVER:0#SCODE:I0025#VTYPE:V/1"
		s OPRowid5 ="手术操作名称5#TYPE:Simple#TID:3#TVER:0#SCODE:I0093#VTYPE:V/1"
		
		s OPDesc1 ="手术操作名称1#TYPE:Simple#TID:3#TVER:0#SCODE:I0022#VTYPE:V/0"
		s OPDesc2 ="手术操作名称2#TYPE:Simple#TID:3#TVER:0#SCODE:I0023#VTYPE:V/0"
		s OPDesc3 ="手术操作名称3#TYPE:Simple#TID:3#TVER:0#SCODE:I0024#VTYPE:V/0"
		s OPDesc4 ="手术操作名称4#TYPE:Simple#TID:3#TVER:0#SCODE:I0025#VTYPE:V/0"
		s OPDesc5 ="手术操作名称5#TYPE:Simple#TID:3#TVER:0#SCODE:I0093#VTYPE:V/0"
		
		s OPCode1 =""
		s OPCode2 =""
		s OPCode3 =""
		s OPCode4 =""
		s OPCode5 =""
		
		s OPDate1="手术操作日期1#TYPE:Simple#TID:3#TVER:0#SCODE:D0141#VTYPE:V/1"
		s OPDate2="手术操作日期2#TYPE:Simple#TID:3#TVER:0#SCODE:D0142#VTYPE:V/1"
		s OPDate3="手术操作日期3#TYPE:Simple#TID:3#TVER:0#SCODE:D0143#VTYPE:V/1"
		s OPDate4="手术操作日期4#TYPE:Simple#TID:3#TVER:0#SCODE:D0145#VTYPE:V/1"
		s OPDate5="手术操作日期5#TYPE:Simple#TID:3#TVER:0#SCODE:D0149#VTYPE:V/1"
		
		s OPDoc1="术者1#TYPE:Simple#TID:3#TVER:0#SCODE:I0026#VTYPE:V//1/0"
		s OPDoc2="术者2#TYPE:Simple#TID:3#TVER:0#SCODE:I0027#VTYPE:V//1/0"
		s OPDoc3="术者3#TYPE:Simple#TID:3#TVER:0#SCODE:I0028#VTYPE:V//1/0"
		s OPDoc4="术者4#TYPE:Simple#TID:3#TVER:0#SCODE:I0029#VTYPE:V//1/0"
		s OPDoc5="术者5#TYPE:Simple#TID:3#TVER:0#SCODE:I0098#VTYPE:V//1/0"
		
		s anaMethod1="麻醉方式1#TYPE:Simple#TID:3#TVER:0#SCODE:I0153#VTYPE:V/0"
		s anaMethod2="麻醉方式2#TYPE:Simple#TID:3#TVER:0#SCODE:I0154#VTYPE:V/0"
		s anaMethod3="麻醉方式3#TYPE:Simple#TID:3#TVER:0#SCODE:I0155#VTYPE:V/0"
		s anaMethod4="麻醉方式4#TYPE:Simple#TID:3#TVER:0#SCODE:I0156#VTYPE:V/0"
		s anaMethod5="麻醉方式5#TYPE:Simple#TID:3#TVER:0#SCODE:I0157#VTYPE:V/0"
		
		s anaDoc1="麻醉医师1#TYPE:Simple#TID:3#TVER:0#SCODE:I0051#VTYPE:V//1/0"
		s anaDoc2="麻醉医师2#TYPE:Simple#TID:3#TVER:0#SCODE:I0050#VTYPE:V//1/0"
		s anaDoc3="麻醉医师3#TYPE:Simple#TID:3#TVER:0#SCODE:I0052#VTYPE:V//1/0"
		s anaDoc4="麻醉医师4#TYPE:Simple#TID:3#TVER:0#SCODE:I0053#VTYPE:V//1/0"
		s anaDoc5="麻醉医师5#TYPE:Simple#TID:3#TVER:0#SCODE:I0134#VTYPE:V//1/0"
		
		s AssDoc11="1助1#TYPE:Simple#TID:3#TVER:0#SCODE:I0030#VTYPE:V//1/0"
		s AssDoc12="1助2#TYPE:Simple#TID:3#TVER:0#SCODE:I0031#VTYPE:V//1/0"
		s AssDoc13="1助3#TYPE:Simple#TID:3#TVER:0#SCODE:I0032#VTYPE:V//1/0"
		s AssDoc14="1助4#TYPE:Simple#TID:3#TVER:0#SCODE:I0033#VTYPE:V//1/0"
		s AssDoc15="1助5#TYPE:Simple#TID:3#TVER:0#SCODE:I0104#VTYPE:V//1/0"
		
		s AssDoc21="2助1#TYPE:Simple#TID:3#TVER:0#SCODE:I0034#VTYPE:V//1/0"
		s AssDoc22="2助2#TYPE:Simple#TID:3#TVER:0#SCODE:I0035#VTYPE:V//1/0"
		s AssDoc23="2助3#TYPE:Simple#TID:3#TVER:0#SCODE:I0037#VTYPE:V//1/0"
		s AssDoc24="2助4#TYPE:Simple#TID:3#TVER:0#SCODE:I0036#VTYPE:V//1/0"
		s AssDoc25="2助5#TYPE:Simple#TID:3#TVER:0#SCODE:I0110#VTYPE:V//1/0"

		s CutClose11="切口愈合等级11#TYPE:Simple#TID:3#TVER:0#SCODE:O0042#VTYPE:V/0"
		s CutClose12="切口愈合等级12#TYPE:Simple#TID:3#TVER:0#SCODE:O0047#VTYPE:V/0"
		s CutClose13="切口愈合等级13#TYPE:Simple#TID:3#TVER:0#SCODE:O0043#VTYPE:V/0"
		s CutClose14="切口愈合等级14#TYPE:Simple#TID:3#TVER:0#SCODE:O0049#VTYPE:V/0"
		s CutClose15="切口愈合等级15#TYPE:Simple#TID:3#TVER:0#SCODE:O0122#VTYPE:V/0"
		
		s CutClose21="切口愈合等级21#TYPE:Simple#TID:3#TVER:0#SCODE:O0048#VTYPE:V/0"
		s CutClose22="切口愈合等级22#TYPE:Simple#TID:3#TVER:0#SCODE:O0046#VTYPE:V/0"
		s CutClose23="切口愈合等级23#TYPE:Simple#TID:3#TVER:0#SCODE:O0045#VTYPE:V/0"
		s CutClose24="切口愈合等级24#TYPE:Simple#TID:3#TVER:0#SCODE:O0044#VTYPE:V/0"
		s CutClose25="切口愈合等级25#TYPE:Simple#TID:3#TVER:0#SCODE:O0128#VTYPE:V/0"
		
		s TMP1=OPRowid1_$c(2)_OPDesc1_$c(2)_OPDate1_$c(2)_status_$c(2)_OPDate1_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc1_$c(2)_anaMethod1_$c(2)_anaDoc1_$c(2)_AssDoc11_$c(3)_AssDoc21_$c(2)_OPCode1_$c(2)_CutClose11_$c(2)_CutClose21
	    s TMP2=OPRowid2_$c(2)_OPDesc2_$c(2)_OPDate2_$c(2)_status_$c(2)_OPDate2_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc2_$c(2)_anaMethod2_$c(2)_anaDoc2_$c(2)_AssDoc12_$c(3)_AssDoc22_$c(2)_OPCode2_$c(2)_CutClose12_$c(2)_CutClose22
	    s TMP3=OPRowid3_$c(2)_OPDesc3_$c(2)_OPDate3_$c(2)_status_$c(2)_OPDate3_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc3_$c(2)_anaMethod3_$c(2)_anaDoc3_$c(2)_AssDoc13_$c(3)_AssDoc23_$c(2)_OPCode3_$c(2)_CutClose13_$c(2)_CutClose23
	    s TMP4=OPRowid4_$c(2)_OPDesc4_$c(2)_OPDate4_$c(2)_status_$c(2)_OPDate4_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc4_$c(2)_anaMethod4_$c(2)_anaDoc4_$c(2)_AssDoc14_$c(3)_AssDoc24_$c(2)_OPCode4_$c(2)_CutClose14_$c(2)_CutClose24
	    s TMP5=OPRowid5_$c(2)_OPDesc5_$c(2)_OPDate5_$c(2)_status_$c(2)_OPDate5_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc5_$c(2)_anaMethod5_$c(2)_anaDoc5_$c(2)_AssDoc15_$c(3)_AssDoc25_$c(2)_OPCode5_$c(2)_CutClose15_$c(2)_CutClose25
	    
		set ^DHCWMROperSetting("OPER",1)=TMP1
		set ^DHCWMROperSetting("OPER",2)=TMP2
		set ^DHCWMROperSetting("OPER",3)=TMP3
		set ^DHCWMROperSetting("OPER",4)=TMP4
		set ^DHCWMROperSetting("OPER",5)=TMP5
	}
    
    //潍坊市人民医院取EPR手术操作信息 元数据代码
	if (HospCode="WeiFang_RMYY") {
	    s OPDesc1 ="病案摘要.病案首页.手术情况.手术情况.手术、操作编码1#TYPE:Simple#TID:143#TVER:0#SCODE:I0003#VTYPE:V/0"
	    s OPDesc2 ="病案摘要.病案首页.手术情况.手术情况.手术、操作编码2#TYPE:Simple#TID:143#TVER:0#SCODE:I0004#VTYPE:V/0"
	    s OPDesc3 ="病案摘要.病案首页.手术情况.手术情况.手术、操作编码3#TYPE:Simple#TID:143#TVER:0#SCODE:I0005#VTYPE:V/0"
		
	    s OPCode1="病案摘要.病案首页.手术情况.手术情况.手术、操作编码1#TYPE:Simple#TID:143#TVER:0#SCODE:I0003#VTYPE:V/1"
	    s OPCode2="病案摘要.病案首页.手术情况.手术情况.手术、操作编码2#TYPE:Simple#TID:143#TVER:0#SCODE:I0004#VTYPE:V/1"
	    s OPCode3="病案摘要.病案首页.手术情况.手术情况.手术、操作编码3#TYPE:Simple#TID:143#TVER:0#SCODE:I0005#VTYPE:V/1"
	    
	    s OPDate1="病案摘要.病案首页.手术情况.手术情况.手术操作日期1#TYPE:Simple#TID:143#TVER:0#SCODE:D0006#VTYPE:V/1"
	    s OPDate2="病案摘要.病案首页.手术情况.手术情况.手术操作日期2#TYPE:Simple#TID:143#TVER:0#SCODE:D0007#VTYPE:V/1"
	    s OPDate3="病案摘要.病案首页.手术情况.手术情况.手术操作日期3#TYPE:Simple#TID:143#TVER:0#SCODE:D0008#VTYPE:V/1"
	    
	    s OPDoc1="病案摘要.病案首页.手术情况.手术情况.术者1#TYPE:Simple#TID:143#TVER:0#SCODE:I0009#VTYPE:V//1/0"
	    s OPDoc2="病案摘要.病案首页.手术情况.手术情况.术者2#TYPE:Simple#TID:143#TVER:0#SCODE:I0010#VTYPE:V//1/0"
	    s OPDoc3="病案摘要.病案首页.手术情况.手术情况.术者3#TYPE:Simple#TID:143#TVER:0#SCODE:I0011#VTYPE:V//1/0"
	    
	    s anaMethod1="病案摘要.病案首页.手术情况.手术情况.麻醉方式1#TYPE:Simple#TID:143#TVER:0#SCODE:O0022#VTYPE:V/0"
	    s anaMethod2="病案摘要.病案首页.手术情况.手术情况.麻醉方式2#TYPE:Simple#TID:143#TVER:0#SCODE:O0023#VTYPE:V/0"
	    s anaMethod3="病案摘要.病案首页.手术情况.手术情况.麻醉方式3#TYPE:Simple#TID:143#TVER:0#SCODE:O0021#VTYPE:V/0"
	    
	    s anaDoc1="病案摘要.病案首页.手术情况.手术情况.麻醉医师1#TYPE:Simple#TID:143#TVER:0#SCODE:I0018#VTYPE:V//1/0"
	    s anaDoc2="病案摘要.病案首页.手术情况.手术情况.麻醉医师2#TYPE:Simple#TID:143#TVER:0#SCODE:I0019#VTYPE:V//1/0"
	    s anaDoc3="病案摘要.病案首页.手术情况.手术情况.麻醉医师3#TYPE:Simple#TID:143#TVER:0#SCODE:I0020#VTYPE:V//1/0"
	    
	    s AssDoc11="病案摘要.病案首页.手术情况.手术情况.Ⅰ助1#TYPE:Simple#TID:143#TVER:0#SCODE:I0012#VTYPE:V//1/0"
	    s AssDoc12="病案摘要.病案首页.手术情况.手术情况.Ⅰ助2#TYPE:Simple#TID:143#TVER:0#SCODE:I0013#VTYPE:V//1/0"
	    s AssDoc13="病案摘要.病案首页.手术情况.手术情况.Ⅰ助3#TYPE:Simple#TID:143#TVER:0#SCODE:I0014#VTYPE:V//1/0"
		
	    s AssDoc21="病案摘要.病案首页.手术情况.手术情况.Ⅱ助1#TYPE:Simple#TID:143#TVER:0#SCODE:I0015#VTYPE:V//1/0"
	    s AssDoc22="病案摘要.病案首页.手术情况.手术情况.Ⅱ助2#TYPE:Simple#TID:143#TVER:0#SCODE:I0016#VTYPE:V//1/0"
	    s AssDoc23="病案摘要.病案首页.手术情况.手术情况.Ⅱ助3#TYPE:Simple#TID:143#TVER:0#SCODE:I0017#VTYPE:V//1/0"
	    
	    s CutClose11="病案摘要.病案首页.手术情况.手术情况.切口愈合等级11#TYPE:Simple#TID:143#TVER:0#SCODE:O0024#VTYPE:V/0"
	    s CutClose12="病案摘要.病案首页.手术情况.手术情况.切口愈合等级12#TYPE:Simple#TID:143#TVER:0#SCODE:O0025#VTYPE:V/0"
	    s CutClose13="病案摘要.病案首页.手术情况.手术情况.切口愈合等级13#TYPE:Simple#TID:143#TVER:0#SCODE:O0026#VTYPE:V/0"
	    
	    s CutClose21="病案摘要.病案首页.手术情况.手术情况.切口愈合等级21#TYPE:Simple#TID:143#TVER:0#SCODE:O0027#VTYPE:V/0"
	    s CutClose22="病案摘要.病案首页.手术情况.手术情况.切口愈合等级22#TYPE:Simple#TID:143#TVER:0#SCODE:O0028#VTYPE:V/0"
	    s CutClose23="病案摘要.病案首页.手术情况.手术情况.切口愈合等级23#TYPE:Simple#TID:143#TVER:0#SCODE:O0029#VTYPE:V/0"
	    
	    s TMP1=opRowid_$c(2)_OPDesc1_$c(2)_OPDate1_$c(2)_status_$c(2)_OPDate1_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc1_$c(2)_anaMethod1_$c(2)_anaDoc1_$c(2)_AssDoc11_$c(3)_AssDoc21_$c(2)_OPCode1_$c(2)_CutClose11_$c(2)_CutClose21
	    s TMP2=opRowid_$c(2)_OPDesc2_$c(2)_OPDate2_$c(2)_status_$c(2)_OPDate2_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc2_$c(2)_anaMethod2_$c(2)_anaDoc2_$c(2)_AssDoc12_$c(3)_AssDoc22_$c(2)_OPCode2_$c(2)_CutClose12_$c(2)_CutClose22
	    s TMP3=opRowid_$c(2)_OPDesc3_$c(2)_OPDate3_$c(2)_status_$c(2)_OPDate3_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc3_$c(2)_anaMethod3_$c(2)_anaDoc3_$c(2)_AssDoc13_$c(3)_AssDoc23_$c(2)_OPCode3_$c(2)_CutClose13_$c(2)_CutClose23
	    
		set ^DHCWMROperSetting("OPER",1)=TMP1
		set ^DHCWMROperSetting("OPER",2)=TMP2
		set ^DHCWMROperSetting("OPER",3)=TMP3

	}
	
    //中国医科大学附属第一医院 取EPR手术操作信息 元数据代码
	if (HospCode="ShenYang_YDYFY") {
		s ^DHCWMROperSetting("OPER")=2
	    s OPDesc1 ="病案首页.病案首页.手术情况.手术情况.手术操作名称1#TYPE:Simple#TID:3#TVER:0#SCODE:I0022#VTYPE:V/0"
		s OPDesc2 ="病案首页.病案首页.手术情况.手术情况.手术操作名称2#TYPE:Simple#TID:3#TVER:0#SCODE:I0023#VTYPE:V/0"
		s OPDesc3 ="病案首页.病案首页.手术情况.手术情况.手术操作名称3#TYPE:Simple#TID:3#TVER:0#SCODE:I0024#VTYPE:V/0"
		s OPDesc4 ="病案首页.病案首页.手术情况.手术情况.手术操作名称4#TYPE:Simple#TID:3#TVER:0#SCODE:I0025#VTYPE:V/0"
		s OPDesc5 ="病案首页.病案首页.手术情况.手术情况.手术操作名称5#TYPE:Simple#TID:3#TVER:0#SCODE:I0101#VTYPE:V/0"
	
		s OPCode1="病案首页.病案首页.手术情况.手术情况.手术操作名称1#TYPE:Simple#TID:3#TVER:0#SCODE:I0022#VTYPE:V/1"
		s OPCode2="病案首页.病案首页.手术情况.手术情况.手术操作名称2#TYPE:Simple#TID:3#TVER:0#SCODE:I0023#VTYPE:V/1"
		s OPCode3="病案首页.病案首页.手术情况.手术情况.手术操作名称3#TYPE:Simple#TID:3#TVER:0#SCODE:I0024#VTYPE:V/1"
		s OPCode4="病案首页.病案首页.手术情况.手术情况.手术操作名称4#TYPE:Simple#TID:3#TVER:0#SCODE:I0025#VTYPE:V/1"
		s OPCode5="病案首页.病案首页.手术情况.手术情况.手术操作名称5#TYPE:Simple#TID:3#TVER:0#SCODE:I0101#VTYPE:V/1"
	
		s OPDate1="病案首页.病案首页.手术情况.手术情况.手术操作日期1#TYPE:Simple#TID:3#TVER:0#SCODE:D0095#VTYPE:V/1"
		s OPDate2="病案首页.病案首页.手术情况.手术情况.手术操作日期2#TYPE:Simple#TID:3#TVER:0#SCODE:D0096#VTYPE:V/1"
		s OPDate3="病案首页.病案首页.手术情况.手术情况.手术操作日期3#TYPE:Simple#TID:3#TVER:0#SCODE:D0097#VTYPE:V/1"
		s OPDate4="病案首页.病案首页.手术情况.手术情况.手术操作日期4#TYPE:Simple#TID:3#TVER:0#SCODE:D0094#VTYPE:V/1"
		s OPDate5="病案首页.病案首页.手术情况.手术情况.手术操作日期5#TYPE:Simple#TID:3#TVER:0#SCODE:D0100#VTYPE:V/1"
	
		s OPDoc1="病案首页.病案首页.手术情况.手术情况.术者1#TYPE:Simple#TID:3#TVER:0#SCODE:I0026#VTYPE:V//1/0"
		s OPDoc2="病案首页.病案首页.手术情况.手术情况.术者2#TYPE:Simple#TID:3#TVER:0#SCODE:I0027#VTYPE:V//1/0"
		s OPDoc3="病案首页.病案首页.手术情况.手术情况.术者3#TYPE:Simple#TID:3#TVER:0#SCODE:I0028#VTYPE:V//1/0"
		s OPDoc4="病案首页.病案首页.手术情况.手术情况.术者4#TYPE:Simple#TID:3#TVER:0#SCODE:I0029#VTYPE:V//1/0"
		s OPDoc5="病案首页.病案首页.手术情况.手术情况.术者5#TYPE:Simple#TID:3#TVER:0#SCODE:I0102#VTYPE:V//1/0"
	
		s anaMethod1="病案首页.病案首页.手术情况.手术情况.麻醉方式1#TYPE:Simple#TID:3#TVER:0#SCODE:O0077#VTYPE:V/0"
		s anaMethod2="病案首页.病案首页.手术情况.手术情况.麻醉方式2#TYPE:Simple#TID:3#TVER:0#SCODE:O0079#VTYPE:V/0"
		s anaMethod3="病案首页.病案首页.手术情况.手术情况.麻醉方式3#TYPE:Simple#TID:3#TVER:0#SCODE:O0081#VTYPE:V/0"
		s anaMethod4="病案首页.病案首页.手术情况.手术情况.麻醉方式4#TYPE:Simple#TID:3#TVER:0#SCODE:O0078#VTYPE:V/0"
		s anaMethod5="病案首页.病案首页.手术情况.手术情况.麻醉方式5#TYPE:Simple#TID:3#TVER:0#SCODE:O0105#VTYPE:V/0"
	
		s anaDoc1="病案首页.病案首页.手术情况.手术情况.麻醉医师1#TYPE:Simple#TID:3#TVER:0#SCODE:I0051#VTYPE:V//1/0"
		s anaDoc2="病案首页.病案首页.手术情况.手术情况.麻醉医师2#TYPE:Simple#TID:3#TVER:0#SCODE:I0050#VTYPE:V//1/0"
		s anaDoc3="病案首页.病案首页.手术情况.手术情况.麻醉医师3#TYPE:Simple#TID:3#TVER:0#SCODE:I0052#VTYPE:V//1/0"
		s anaDoc4="病案首页.病案首页.手术情况.手术情况.麻醉医师4#TYPE:Simple#TID:3#TVER:0#SCODE:I0053#VTYPE:V//1/0"
		s anaDoc5="病案首页.病案首页.手术情况.手术情况.麻醉医师5#TYPE:Simple#TID:3#TVER:0#SCODE:I0108#VTYPE:V//1/0"
	
		s AssDoc11="病案首页.病案首页.手术情况.手术情况.Ⅰ助1#TYPE:Simple#TID:3#TVER:0#SCODE:I0030#VTYPE:V//1/0"
		s AssDoc12="病案首页.病案首页.手术情况.手术情况.Ⅰ助2#TYPE:Simple#TID:3#TVER:0#SCODE:I0031#VTYPE:V//1/0"
		s AssDoc13="病案首页.病案首页.手术情况.手术情况.Ⅰ助3#TYPE:Simple#TID:3#TVER:0#SCODE:I0032#VTYPE:V//1/0"
		s AssDoc14="病案首页.病案首页.手术情况.手术情况.Ⅰ助4#TYPE:Simple#TID:3#TVER:0#SCODE:I0033#VTYPE:V//1/0"
		s AssDoc15="病案首页.病案首页.手术情况.手术情况.Ⅰ助5#TYPE:Simple#TID:3#TVER:0#SCODE:I0103#VTYPE:V//1/0"
	
		s AssDoc21="病案首页.病案首页.手术情况.手术情况.Ⅱ助1#TYPE:Simple#TID:3#TVER:0#SCODE:I0034#VTYPE:V//1/0"
		s AssDoc22="病案首页.病案首页.手术情况.手术情况.Ⅱ助2#TYPE:Simple#TID:3#TVER:0#SCODE:I0035#VTYPE:V//1/0"
		s AssDoc23="病案首页.病案首页.手术情况.手术情况.Ⅱ助3#TYPE:Simple#TID:3#TVER:0#SCODE:I0037#VTYPE:V//1/0"
		s AssDoc24="病案首页.病案首页.手术情况.手术情况.Ⅱ助4#TYPE:Simple#TID:3#TVER:0#SCODE:I0036#VTYPE:V//1/0"
		s AssDoc25="病案首页.病案首页.手术情况.手术情况.Ⅱ助5#TYPE:Simple#TID:3#TVER:0#SCODE:I0104#VTYPE:V//1/0"
	
		s CutClose11="病案首页.病案首页.手术情况.手术情况.切口愈合等级11#TYPE:Simple#TID:3#TVER:0#SCODE:O0042#VTYPE:V/0"
		s CutClose12="病案首页.病案首页.手术情况.手术情况.切口愈合等级12#TYPE:Simple#TID:3#TVER:0#SCODE:O0047#VTYPE:V/0"
		s CutClose13="病案首页.病案首页.手术情况.手术情况.切口愈合等级13#TYPE:Simple#TID:3#TVER:0#SCODE:O0043#VTYPE:V/0"
		s CutClose14="病案首页.病案首页.手术情况.手术情况.切口愈合等级14#TYPE:Simple#TID:3#TVER:0#SCODE:O0049#VTYPE:V/0"
		s CutClose15="病案首页.病案首页.手术情况.手术情况.切口愈合等级15#TYPE:Simple#TID:3#TVER:0#SCODE:O0106#VTYPE:V/0"
	
		s CutClose21="病案首页.病案首页.手术情况.手术情况.切口愈合等级21#TYPE:Simple#TID:3#TVER:0#SCODE:O0048#VTYPE:V/0"
		s CutClose22="病案首页.病案首页.手术情况.手术情况.切口愈合等级22#TYPE:Simple#TID:3#TVER:0#SCODE:O0046#VTYPE:V/0"
		s CutClose23="病案首页.病案首页.手术情况.手术情况.切口愈合等级23#TYPE:Simple#TID:3#TVER:0#SCODE:O0045#VTYPE:V/0"
		s CutClose24="病案首页.病案首页.手术情况.手术情况.切口愈合等级24#TYPE:Simple#TID:3#TVER:0#SCODE:O0044#VTYPE:V/0"
		s CutClose25="病案首页.病案首页.手术情况.手术情况.切口愈合等级25#TYPE:Simple#TID:3#TVER:0#SCODE:O0107#VTYPE:V/0"
		
		s TMP1=opRowid_$c(2)_OPDesc1_$c(2)_OPDate1_$c(2)_status_$c(2)_OPDate1_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc1_$c(2)_anaMethod1_$c(2)_anaDoc1_$c(2)_AssDoc11_$c(3)_AssDoc21_$c(2)_OPCode1_$c(2)_CutClose11_$c(2)_CutClose21
	    s TMP2=opRowid_$c(2)_OPDesc2_$c(2)_OPDate2_$c(2)_status_$c(2)_OPDate2_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc2_$c(2)_anaMethod2_$c(2)_anaDoc2_$c(2)_AssDoc12_$c(3)_AssDoc22_$c(2)_OPCode2_$c(2)_CutClose12_$c(2)_CutClose22
	    s TMP3=opRowid_$c(2)_OPDesc3_$c(2)_OPDate3_$c(2)_status_$c(2)_OPDate3_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc3_$c(2)_anaMethod3_$c(2)_anaDoc3_$c(2)_AssDoc13_$c(3)_AssDoc23_$c(2)_OPCode3_$c(2)_CutClose13_$c(2)_CutClose23
	    s TMP4=opRowid_$c(2)_OPDesc4_$c(2)_OPDate4_$c(2)_status_$c(2)_OPDate4_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc4_$c(2)_anaMethod4_$c(2)_anaDoc4_$c(2)_AssDoc14_$c(3)_AssDoc24_$c(2)_OPCode4_$c(2)_CutClose14_$c(2)_CutClose24
	    s TMP5=opRowid_$c(2)_OPDesc5_$c(2)_OPDate5_$c(2)_status_$c(2)_OPDate5_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc5_$c(2)_anaMethod5_$c(2)_anaDoc5_$c(2)_AssDoc15_$c(3)_AssDoc25_$c(2)_OPCode5_$c(2)_CutClose15_$c(2)_CutClose25
	    
		set ^DHCWMROperSetting("OPER",1)=TMP1
		set ^DHCWMROperSetting("OPER",2)=TMP2
		set ^DHCWMROperSetting("OPER",3)=TMP3
		set ^DHCWMROperSetting("OPER",4)=TMP4
		set ^DHCWMROperSetting("OPER",5)=TMP5
	}
	
	/*
    //中医院取EPR手术操作信息 元数据代码
    if (HospCode="BeiJing_ZYY") {
	    s OPDesc1 ="手术情况.手术操作名称1#TYPE:Simple#TID:141#TVER:0#SCODE:I0022#VTYPE:V/0"
		s OPDesc2 ="手术情况.手术操作名称2#TYPE:Simple#TID:141#TVER:0#SCODE:I0023#VTYPE:V/0"
		s OPDesc3 ="手术情况.手术操作名称3#TYPE:Simple#TID:141#TVER:0#SCODE:I0024#VTYPE:V/0"
		s OPDesc4 ="手术情况.手术操作名称4#TYPE:Simple#TID:141#TVER:0#SCODE:I0025#VTYPE:V/0"
		s OPDesc5 ="手术情况.手术操作名称5#TYPE:Simple#TID:141#TVER:0#SCODE:I0093#VTYPE:V/0"
		s OPDesc6 ="手术情况.手术操作名称6#TYPE:Simple#TID:141#TVER:0#SCODE:I0094#VTYPE:V/0"
		s OPDesc7 ="手术情况.手术操作名称7#TYPE:Simple#TID:141#TVER:0#SCODE:I0095#VTYPE:V/0"
		s OPDesc8 ="手术情况.手术操作名称8#TYPE:Simple#TID:141#TVER:0#SCODE:I0097#VTYPE:V/0"
		s OPDesc9 ="手术情况.手术操作名称9#TYPE:Simple#TID:141#TVER:0#SCODE:I0096#VTYPE:V/0"
		s OPDesc10 ="手术情况.手术操作名称10#TYPE:Simple#TID:141#TVER:0#SCODE:I0092#VTYPE:V/0"
	
		s OPCode1="手术情况.手术操作名称1#TYPE:Simple#TID:141#TVER:0#SCODE:I0022#VTYPE:V/1"
		s OPCode2="手术情况.手术操作名称2#TYPE:Simple#TID:141#TVER:0#SCODE:I0023#VTYPE:V/1"
		s OPCode3="手术情况.手术操作名称3#TYPE:Simple#TID:141#TVER:0#SCODE:I0024#VTYPE:V/1"
		s OPCode4="手术情况.手术操作名称4#TYPE:Simple#TID:141#TVER:0#SCODE:I0025#VTYPE:V/1"
		s OPCode5="手术情况.手术操作名称5#TYPE:Simple#TID:141#TVER:0#SCODE:I0093#VTYPE:V/1"
		s OPCode6="手术情况.手术操作名称6#TYPE:Simple#TID:141#TVER:0#SCODE:I0094#VTYPE:V/1"
		s OPCode7="手术情况.手术操作名称7#TYPE:Simple#TID:141#TVER:0#SCODE:I0095#VTYPE:V/1"
		s OPCode8="手术情况.手术操作名称8#TYPE:Simple#TID:141#TVER:0#SCODE:I0097#VTYPE:V/1"
		s OPCode9="手术情况.手术操作名称9#TYPE:Simple#TID:141#TVER:0#SCODE:I0096#VTYPE:V/1"
		s OPCode10="手术情况.手术操作名称10#TYPE:Simple#TID:141#TVER:0#SCODE:I0092#VTYPE:V/1"
		
		s OPDate1="手术情况.手术操作日期1#TYPE:Simple#TID:141#TVER:0#SCODE:D0141#VTYPE:V/1"
		s OPDate2="手术情况.手术操作日期2#TYPE:Simple#TID:141#TVER:0#SCODE:D0142#VTYPE:V/1"
		s OPDate3="手术情况.手术操作日期3#TYPE:Simple#TID:141#TVER:0#SCODE:D0143#VTYPE:V/1"
		s OPDate4="手术情况.手术操作日期4#TYPE:Simple#TID:141#TVER:0#SCODE:D0145#VTYPE:V/1"
		s OPDate5="手术情况.手术操作日期5#TYPE:Simple#TID:141#TVER:0#SCODE:D0149#VTYPE:V/1"
		s OPDate6="手术情况.手术操作日期6#TYPE:Simple#TID:141#TVER:0#SCODE:D0150#VTYPE:V/1"
		s OPDate7="手术情况.手术操作日期7#TYPE:Simple#TID:141#TVER:0#SCODE:D0148#VTYPE:V/1"
		s OPDate8="手术情况.手术操作日期8#TYPE:Simple#TID:141#TVER:0#SCODE:D0147#VTYPE:V/1"
		s OPDate9="手术情况.手术操作日期9#TYPE:Simple#TID:141#TVER:0#SCODE:D0146#VTYPE:V/1"
		s OPDate10="手术情况.手术操作日期10#TYPE:Simple#TID:141#TVER:0#SCODE:D0144#VTYPE:V/1"
	
		
		s OPDoc1="手术情况.术者1#TYPE:Simple#TID:141#TVER:0#SCODE:I0026#VTYPE:V//1/0"
		s OPDoc2="手术情况.术者2#TYPE:Simple#TID:141#TVER:0#SCODE:I0027#VTYPE:V//1/0"
		s OPDoc3="手术情况.术者3#TYPE:Simple#TID:141#TVER:0#SCODE:I0028#VTYPE:V//1/0"
		s OPDoc4="手术情况.术者4#TYPE:Simple#TID:141#TVER:0#SCODE:I0029#VTYPE:V//1/0"
		s OPDoc5="手术情况.术者5#TYPE:Simple#TID:141#TVER:0#SCODE:I0098#VTYPE:V//1/0"
		s OPDoc6="手术情况.术者6#TYPE:Simple#TID:141#TVER:0#SCODE:I0101#VTYPE:V//1/0"
		s OPDoc7="手术情况.术者7#TYPE:Simple#TID:141#TVER:0#SCODE:I0102#VTYPE:V//1/0"
		s OPDoc8="手术情况.术者8#TYPE:Simple#TID:141#TVER:0#SCODE:I0103#VTYPE:V//1/0"
		s OPDoc9="手术情况.术者9#TYPE:Simple#TID:141#TVER:0#SCODE:I0100#VTYPE:V//1/0"
		s OPDoc10="手术情况.术者10#TYPE:Simple#TID:141#TVER:0#SCODE:I0099#VTYPE:V//1/0"
	
		
		s anaMethod1="手术情况.麻醉方式1#TYPE:Simple#TID:141#TVER:0#SCODE:I0153#VTYPE:V/0"
		s anaMethod2="手术情况.麻醉方式2#TYPE:Simple#TID:141#TVER:0#SCODE:I0154#VTYPE:V/0"
		s anaMethod3="手术情况.麻醉方式3#TYPE:Simple#TID:141#TVER:0#SCODE:I0155#VTYPE:V/0"
		s anaMethod4="手术情况.麻醉方式4#TYPE:Simple#TID:141#TVER:0#SCODE:I0156#VTYPE:V/0"
		s anaMethod5="手术情况.麻醉方式5#TYPE:Simple#TID:141#TVER:0#SCODE:I0157#VTYPE:V/0"
		s anaMethod6="手术情况.麻醉方式6#TYPE:Simple#TID:141#TVER:0#SCODE:I0161#VTYPE:V/0"
		s anaMethod7="手术情况.麻醉方式7#TYPE:Simple#TID:141#TVER:0#SCODE:I0162#VTYPE:V/0"
		s anaMethod8="手术情况.麻醉方式8#TYPE:Simple#TID:141#TVER:0#SCODE:I0163#VTYPE:V/0"
		s anaMethod9="手术情况.麻醉方式9#TYPE:Simple#TID:141#TVER:0#SCODE:I0158#VTYPE:V/0"
		s anaMethod10="手术情况.麻醉方式10#TYPE:Simple#TID:141#TVER:0#SCODE:I0160#VTYPE:V/0"
	
		
		s anaDoc1="手术情况.麻醉医师1#TYPE:Simple#TID:141#TVER:0#SCODE:I0051#VTYPE:V//1/0"
		s anaDoc2="手术情况.麻醉医师2#TYPE:Simple#TID:141#TVER:0#SCODE:I0050#VTYPE:V//1/0"
		s anaDoc3="手术情况.麻醉医师3#TYPE:Simple#TID:141#TVER:0#SCODE:I0052#VTYPE:V//1/0"
		s anaDoc4="手术情况.麻醉医师4#TYPE:Simple#TID:141#TVER:0#SCODE:I0053#VTYPE:V//1/0"
		s anaDoc5="手术情况.麻醉医师5#TYPE:Simple#TID:141#TVER:0#SCODE:I0134#VTYPE:V//1/0"
		s anaDoc6="手术情况.麻醉医师6#TYPE:Simple#TID:141#TVER:0#SCODE:I0136#VTYPE:V//1/0"
		s anaDoc7="手术情况.麻醉医师7#TYPE:Simple#TID:141#TVER:0#SCODE:I0137#VTYPE:V//1/0"
		s anaDoc8="手术情况.麻醉医师8#TYPE:Simple#TID:141#TVER:0#SCODE:I0139#VTYPE:V//1/0"
		s anaDoc9="手术情况.麻醉医师9#TYPE:Simple#TID:141#TVER:0#SCODE:I0138#VTYPE:V//1/0"
		s anaDoc10="手术情况.麻醉医师10#TYPE:Simple#TID:141#TVER:0#SCODE:I0135#VTYPE:V//1/0"
	
		
		s AssDoc11="手术情况.1助1#TYPE:Simple#TID:141#TVER:0#SCODE:I0030#VTYPE:V//1/0"
		s AssDoc12="手术情况.1助2#TYPE:Simple#TID:141#TVER:0#SCODE:I0031#VTYPE:V//1/0"
		s AssDoc13="手术情况.1助3#TYPE:Simple#TID:141#TVER:0#SCODE:I0032#VTYPE:V//1/0"
		s AssDoc14="手术情况.1助4#TYPE:Simple#TID:141#TVER:0#SCODE:I0033#VTYPE:V//1/0"
		s AssDoc15="手术情况.1助5#TYPE:Simple#TID:141#TVER:0#SCODE:I0104#VTYPE:V//1/0"
		s AssDoc16="手术情况.1助6#TYPE:Simple#TID:141#TVER:0#SCODE:I0105#VTYPE:V//1/0"
		s AssDoc17="手术情况.1助7#TYPE:Simple#TID:141#TVER:0#SCODE:I0109#VTYPE:V//1/0"
		s AssDoc18="手术情况.1助8#TYPE:Simple#TID:141#TVER:0#SCODE:I0108#VTYPE:V//1/0"
		s AssDoc19="手术情况.1助9#TYPE:Simple#TID:141#TVER:0#SCODE:I0106#VTYPE:V//1/0"
		s AssDoc110="手术情况.1助10#TYPE:Simple#TID:141#TVER:0#SCODE:I0107#VTYPE:V//1/0"
	
		
		s AssDoc21="手术情况.2助1#TYPE:Simple#TID:141#TVER:0#SCODE:I0034#VTYPE:V//1/0"
		s AssDoc22="手术情况.2助2#TYPE:Simple#TID:141#TVER:0#SCODE:I0035#VTYPE:V//1/0"
		s AssDoc23="手术情况.2助3#TYPE:Simple#TID:141#TVER:0#SCODE:I0037#VTYPE:V//1/0"
		s AssDoc24="手术情况.2助4#TYPE:Simple#TID:141#TVER:0#SCODE:I0036#VTYPE:V//1/0"
		s AssDoc25="手术情况.2助5#TYPE:Simple#TID:141#TVER:0#SCODE:I0110#VTYPE:V//1/0"
		s AssDoc26="手术情况.2助6#TYPE:Simple#TID:141#TVER:0#SCODE:I0112#VTYPE:V//1/0"
		s AssDoc27="手术情况.2助7#TYPE:Simple#TID:141#TVER:0#SCODE:I0115#VTYPE:V//1/0"
		s AssDoc28="手术情况.2助8#TYPE:Simple#TID:141#TVER:0#SCODE:I0114#VTYPE:V//1/0"
		s AssDoc29="手术情况.2助9#TYPE:Simple#TID:141#TVER:0#SCODE:I0113#VTYPE:V//1/0"
		s AssDoc210="手术情况.2助10#TYPE:Simple#TID:141#TVER:0#SCODE:I0111#VTYPE:V//1/0"
	
	
		s CutClose11="手术情况.切口愈合等级11#TYPE:Simple#TID:141#TVER:0#SCODE:O0042#VTYPE:V/0"
		s CutClose12="手术情况.切口愈合等级12#TYPE:Simple#TID:141#TVER:0#SCODE:O0047#VTYPE:V/0"
		s CutClose13="手术情况.切口愈合等级13#TYPE:Simple#TID:141#TVER:0#SCODE:O0043#VTYPE:V/0"
		s CutClose14="手术情况.切口愈合等级14#TYPE:Simple#TID:141#TVER:0#SCODE:O0049#VTYPE:V/0"
		s CutClose15="手术情况.切口愈合等级15#TYPE:Simple#TID:141#TVER:0#SCODE:O0122#VTYPE:V/0"
		s CutClose16="手术情况.切口愈合等级16#TYPE:Simple#TID:141#TVER:0#SCODE:O0125#VTYPE:V/0"
		s CutClose17="手术情况.切口愈合等级17#TYPE:Simple#TID:141#TVER:0#SCODE:O0124#VTYPE:V/0"
		s CutClose18="手术情况.切口愈合等级18#TYPE:Simple#TID:141#TVER:0#SCODE:O0126#VTYPE:V/0"
		s CutClose19="手术情况.切口愈合等级19#TYPE:Simple#TID:141#TVER:0#SCODE:O0127#VTYPE:V/0"
		s CutClose110="手术情况.切口愈合等级20#TYPE:Simple#TID:141#TVER:0#SCODE:O0123#VTYPE:V/0"
		
		s CutClose21="手术情况.切口愈合等级21#TYPE:Simple#TID:141#TVER:0#SCODE:O0048#VTYPE:V/0"
		s CutClose22="手术情况.切口愈合等级22#TYPE:Simple#TID:141#TVER:0#SCODE:O0046#VTYPE:V/0"
		s CutClose23="手术情况.切口愈合等级23#TYPE:Simple#TID:141#TVER:0#SCODE:O0045#VTYPE:V/0"
		s CutClose24="手术情况.切口愈合等级24#TYPE:Simple#TID:141#TVER:0#SCODE:O0044#VTYPE:V/0"
		s CutClose25="手术情况.切口愈合等级25#TYPE:Simple#TID:141#TVER:0#SCODE:O0128#VTYPE:V/0"
		s CutClose26="手术情况.切口愈合等级26#TYPE:Simple#TID:141#TVER:0#SCODE:O0130#VTYPE:V/0"
		s CutClose27="手术情况.切口愈合等级27#TYPE:Simple#TID:141#TVER:0#SCODE:O0131#VTYPE:V/0"
		s CutClose28="手术情况.切口愈合等级28#TYPE:Simple#TID:141#TVER:0#SCODE:O0133#VTYPE:V/0"
		s CutClose29="手术情况.切口愈合等级29#TYPE:Simple#TID:141#TVER:0#SCODE:O0132#VTYPE:V/0"
		s CutClose210="手术情况.切口愈合等级30#TYPE:Simple#TID:141#TVER:0#SCODE:O0129#VTYPE:V/0"
	
		s TMP1=opRowid_$c(2)_OPDesc1_$c(2)_OPDate1_$c(2)_status_$c(2)_OPDate1_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc1_$c(2)_anaMethod1_$c(2)_anaDoc1_$c(2)_AssDoc11_$c(3)_AssDoc21_$c(2)_OPCode1_$c(2)_CutClose11_$c(2)_CutClose21
	    s TMP2=opRowid_$c(2)_OPDesc2_$c(2)_OPDate2_$c(2)_status_$c(2)_OPDate2_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc2_$c(2)_anaMethod2_$c(2)_anaDoc2_$c(2)_AssDoc12_$c(3)_AssDoc22_$c(2)_OPCode2_$c(2)_CutClose12_$c(2)_CutClose22
	    s TMP3=opRowid_$c(2)_OPDesc3_$c(2)_OPDate3_$c(2)_status_$c(2)_OPDate3_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc3_$c(2)_anaMethod3_$c(2)_anaDoc3_$c(2)_AssDoc13_$c(3)_AssDoc23_$c(2)_OPCode3_$c(2)_CutClose13_$c(2)_CutClose23
	    s TMP4=opRowid_$c(2)_OPDesc4_$c(2)_OPDate4_$c(2)_status_$c(2)_OPDate4_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc4_$c(2)_anaMethod4_$c(2)_anaDoc4_$c(2)_AssDoc14_$c(3)_AssDoc24_$c(2)_OPCode4_$c(2)_CutClose14_$c(2)_CutClose24
	    s TMP5=opRowid_$c(2)_OPDesc5_$c(2)_OPDate5_$c(2)_status_$c(2)_OPDate5_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc5_$c(2)_anaMethod5_$c(2)_anaDoc5_$c(2)_AssDoc15_$c(3)_AssDoc25_$c(2)_OPCode5_$c(2)_CutClose15_$c(2)_CutClose25
	    ;s TMP6=opRowid_$c(2)_OPDesc6_$c(2)_OPDate6_$c(2)_status_$c(2)_OPDate6_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc6_$c(2)_anaMethod6_$c(2)_anaDoc6_$c(2)_AssDoc16_$c(3)_AssDoc26_$c(2)_OPCode6_$c(2)_CutClose16_$c(2)_CutClose26
	    ;s TMP7=opRowid_$c(2)_OPDesc7_$c(2)_OPDate7_$c(2)_status_$c(2)_OPDate7_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc7_$c(2)_anaMethod7_$c(2)_anaDoc7_$c(2)_AssDoc17_$c(3)_AssDoc27_$c(2)_OPCode7_$c(2)_CutClose17_$c(2)_CutClose27
	    ;s TMP8=opRowid_$c(2)_OPDesc8_$c(2)_OPDate8_$c(2)_status_$c(2)_OPDate8_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc8_$c(2)_anaMethod8_$c(2)_anaDoc8_$c(2)_AssDoc18_$c(3)_AssDoc28_$c(2)_OPCode8_$c(2)_CutClose18_$c(2)_CutClose28
	    ;s TMP9=opRowid_$c(2)_OPDesc9_$c(2)_OPDate9_$c(2)_status_$c(2)_OPDate9_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc9_$c(2)_anaMethod9_$c(2)_anaDoc9_$c(2)_AssDoc19_$c(3)_AssDoc29_$c(2)_OPCode9_$c(2)_CutClose19_$c(2)_CutClose29
	    ;s TMP10=opRowid_$c(2)_OPDesc10_$c(2)_OPDate10_$c(2)_status_$c(2)_OPDate10_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc10_$c(2)_anaMethod10_$c(2)_anaDoc10_$c(2)_AssDoc110_$c(3)_AssDoc210_$c(2)_OPCode10_$c(2)_CutClose110_$c(2)_CutClose210
	    
		set ^DHCWMROperSetting("OPER",1)=TMP1
		set ^DHCWMROperSetting("OPER",2)=TMP2
		set ^DHCWMROperSetting("OPER",3)=TMP3
		set ^DHCWMROperSetting("OPER",4)=TMP4
		set ^DHCWMROperSetting("OPER",5)=TMP5
		;set ^DHCWMROperSetting("OPER",6)=TMP6
		;set ^DHCWMROperSetting("OPER",7)=TMP7
		;set ^DHCWMROperSetting("OPER",8)=TMP8
		;set ^DHCWMROperSetting("OPER",9)=TMP9
		;set ^DHCWMROperSetting("OPER",10)=TMP10
    }
	
    //妇产医院取EPR手术操作信息 元数据代码
    if (HospCode="BeiJing_FC") {
	    s OPDesc1 ="病案首页.病案首页.手术情况.手术情况.手术操作名称1#TYPE:Simple#TID:3#TVER:0#SCODE:I0022#VTYPE:V/0"
	    s OPDesc2 ="病案首页.病案首页.手术情况.手术情况.手术操作名称2#TYPE:Simple#TID:3#TVER:0#SCODE:I0023#VTYPE:V/0"
	    s OPDesc3 ="病案首页.病案首页.手术情况.手术情况.手术操作名称3#TYPE:Simple#TID:3#TVER:0#SCODE:I0024#VTYPE:V/0"
	    s OPDesc4 ="病案首页.病案首页.手术情况.手术情况.手术操作名称4#TYPE:Simple#TID:3#TVER:0#SCODE:I0025#VTYPE:V/0"
	    s OPDesc5 ="病案首页.病案首页.手术情况.手术情况.手术操作名称5#TYPE:Simple#TID:3#TVER:0#SCODE:I0093#VTYPE:V/0"
	    s OPDesc6 ="病案首页.病案首页.手术情况.手术情况.手术操作名称6#TYPE:Simple#TID:3#TVER:0#SCODE:I0094#VTYPE:V/0"
	    s OPDesc7 ="病案首页.病案首页.手术情况.手术情况.手术操作名称7#TYPE:Simple#TID:3#TVER:0#SCODE:I0095#VTYPE:V/0"
	    s OPDesc8 ="病案首页.病案首页.手术情况.手术情况.手术操作名称8#TYPE:Simple#TID:3#TVER:0#SCODE:I0097#VTYPE:V/0"
	    s OPDesc9 ="病案首页.病案首页.手术情况.手术情况.手术操作名称9#TYPE:Simple#TID:3#TVER:0#SCODE:I0096#VTYPE:V/0"
	    s OPDesc10 ="病案首页.病案首页.手术情况.手术情况.手术操作名称10#TYPE:Simple#TID:3#TVER:0#SCODE:I0092#VTYPE:V/0"
	    s OPDesc11 ="病案首页.病案首页.手术情况.手术情况.手术操作名称11#TYPE:Simple#TID:3#TVER:0#SCODE:I0158#VTYPE:V/0"
	    s OPDesc12 ="病案首页.病案首页.手术情况.手术情况.手术操作名称12#TYPE:Simple#TID:3#TVER:0#SCODE:I0159#VTYPE:V/0"
	    s OPDesc13 ="病案首页.病案首页.手术情况.手术情况.手术操作名称13#TYPE:Simple#TID:3#TVER:0#SCODE:I0160#VTYPE:V/0"
	    s OPDesc14 ="病案首页.病案首页.手术情况.手术情况.手术操作名称14#TYPE:Simple#TID:3#TVER:0#SCODE:I0161#VTYPE:V/0"
	    s OPDesc15 ="病案首页.病案首页.手术情况.手术情况.手术操作名称15#TYPE:Simple#TID:3#TVER:0#SCODE:I0162#VTYPE:V/0"
		
	    s OPCode1="病案首页.病案首页.手术情况.手术情况.手术操作名称1#TYPE:Simple#TID:3#TVER:0#SCODE:I0022#VTYPE:V/1"
	    s OPCode2="病案首页.病案首页.手术情况.手术情况.手术操作名称2#TYPE:Simple#TID:3#TVER:0#SCODE:I0023#VTYPE:V/1"
	    s OPCode3="病案首页.病案首页.手术情况.手术情况.手术操作名称3#TYPE:Simple#TID:3#TVER:0#SCODE:I0024#VTYPE:V/1"
	    s OPCode4="病案首页.病案首页.手术情况.手术情况.手术操作名称4#TYPE:Simple#TID:3#TVER:0#SCODE:I0025#VTYPE:V/1"
	    s OPCode5="病案首页.病案首页.手术情况.手术情况.手术操作名称5#TYPE:Simple#TID:3#TVER:0#SCODE:I0093#VTYPE:V/1"
	    s OPCode6="病案首页.病案首页.手术情况.手术情况.手术操作名称6#TYPE:Simple#TID:3#TVER:0#SCODE:I0094#VTYPE:V/1"
	    s OPCode7="病案首页.病案首页.手术情况.手术情况.手术操作名称7#TYPE:Simple#TID:3#TVER:0#SCODE:I0095#VTYPE:V/1"
	    s OPCode8="病案首页.病案首页.手术情况.手术情况.手术操作名称8#TYPE:Simple#TID:3#TVER:0#SCODE:I0097#VTYPE:V/1"
	    s OPCode9="病案首页.病案首页.手术情况.手术情况.手术操作名称9#TYPE:Simple#TID:3#TVER:0#SCODE:I0096#VTYPE:V/1"
	    s OPCode10="病案首页.病案首页.手术情况.手术情况.手术操作名称10#TYPE:Simple#TID:3#TVER:0#SCODE:I0092#VTYPE:V/1"
	    s OPCode11="病案首页.病案首页.手术情况.手术情况.手术操作名称11#TYPE:Simple#TID:3#TVER:0#SCODE:I0158#VTYPE:V/1"
	    s OPCode12="病案首页.病案首页.手术情况.手术情况.手术操作名称12#TYPE:Simple#TID:3#TVER:0#SCODE:I0159#VTYPE:V/1"
	    s OPCode13="病案首页.病案首页.手术情况.手术情况.手术操作名称13#TYPE:Simple#TID:3#TVER:0#SCODE:I0160#VTYPE:V/1"
	    s OPCode14="病案首页.病案首页.手术情况.手术情况.手术操作名称14#TYPE:Simple#TID:3#TVER:0#SCODE:I0161#VTYPE:V/1"
	    s OPCode15="病案首页.病案首页.手术情况.手术情况.手术操作名称15#TYPE:Simple#TID:3#TVER:0#SCODE:I0162#VTYPE:V/1"
	    
	    s OPDate1="病案首页.病案首页.手术情况.手术情况.手术操作日期1#TYPE:Simple#TID:3#TVER:0#SCODE:D0141#VTYPE:V/1"
	    s OPDate2="病案首页.病案首页.手术情况.手术情况.手术操作日期2#TYPE:Simple#TID:3#TVER:0#SCODE:D0142#VTYPE:V/1"
	    s OPDate3="病案首页.病案首页.手术情况.手术情况.手术操作日期3#TYPE:Simple#TID:3#TVER:0#SCODE:D0143#VTYPE:V/1"
	    s OPDate4="病案首页.病案首页.手术情况.手术情况.手术操作日期4#TYPE:Simple#TID:3#TVER:0#SCODE:D0145#VTYPE:V/1"
	    s OPDate5="病案首页.病案首页.手术情况.手术情况.手术操作日期5#TYPE:Simple#TID:3#TVER:0#SCODE:D0149#VTYPE:V/1"
	    s OPDate6="病案首页.病案首页.手术情况.手术情况.手术操作日期6#TYPE:Simple#TID:3#TVER:0#SCODE:D0150#VTYPE:V/1"
	    s OPDate7="病案首页.病案首页.手术情况.手术情况.手术操作日期7#TYPE:Simple#TID:3#TVER:0#SCODE:D0148#VTYPE:V/1"
	    s OPDate8="病案首页.病案首页.手术情况.手术情况.手术操作日期8#TYPE:Simple#TID:3#TVER:0#SCODE:D0147#VTYPE:V/1"
	    s OPDate9="病案首页.病案首页.手术情况.手术情况.手术操作日期9#TYPE:Simple#TID:3#TVER:0#SCODE:D0146#VTYPE:V/1"
	    s OPDate10="病案首页.病案首页.手术情况.手术情况.手术操作日期10#TYPE:Simple#TID:3#TVER:0#SCODE:D0144#VTYPE:V/1"
	    s OPDate11="病案首页.病案首页.手术情况.手术情况.手术操作日期11#TYPE:Simple#TID:3#TVER:0#SCODE:D0163#VTYPE:V/1"
	    s OPDate12="病案首页.病案首页.手术情况.手术情况.手术操作日期12#TYPE:Simple#TID:3#TVER:0#SCODE:D0164#VTYPE:V/1"
	    s OPDate13="病案首页.病案首页.手术情况.手术情况.手术操作日期13#TYPE:Simple#TID:3#TVER:0#SCODE:D0165#VTYPE:V/1"
	    s OPDate14="病案首页.病案首页.手术情况.手术情况.手术操作日期14#TYPE:Simple#TID:3#TVER:0#SCODE:D0166#VTYPE:V/1"
	    s OPDate15="病案首页.病案首页.手术情况.手术情况.手术操作日期15#TYPE:Simple#TID:3#TVER:0#SCODE:D0167#VTYPE:V/1"
	    
	    s OPDoc1="病案首页.病案首页.手术情况.手术情况.术者1#TYPE:Simple#TID:3#TVER:0#SCODE:I0026#VTYPE:V//1/0"
	    s OPDoc2="病案首页.病案首页.手术情况.手术情况.术者2#TYPE:Simple#TID:3#TVER:0#SCODE:I0027#VTYPE:V//1/0"
	    s OPDoc3="病案首页.病案首页.手术情况.手术情况.术者3#TYPE:Simple#TID:3#TVER:0#SCODE:I0028#VTYPE:V//1/0"
	    s OPDoc4="病案首页.病案首页.手术情况.手术情况.术者4#TYPE:Simple#TID:3#TVER:0#SCODE:I0029#VTYPE:V//1/0"
	    s OPDoc5="病案首页.病案首页.手术情况.手术情况.术者5#TYPE:Simple#TID:3#TVER:0#SCODE:I0098#VTYPE:V//1/0"
	    s OPDoc6="病案首页.病案首页.手术情况.手术情况.术者6#TYPE:Simple#TID:3#TVER:0#SCODE:I0101#VTYPE:V//1/0"
	    s OPDoc7="病案首页.病案首页.手术情况.手术情况.术者7#TYPE:Simple#TID:3#TVER:0#SCODE:I0102#VTYPE:V//1/0"
	    s OPDoc8="病案首页.病案首页.手术情况.手术情况.术者8#TYPE:Simple#TID:3#TVER:0#SCODE:I0103#VTYPE:V//1/0"
	    s OPDoc9="病案首页.病案首页.手术情况.手术情况.术者9#TYPE:Simple#TID:3#TVER:0#SCODE:I0100#VTYPE:V//1/0"
	    s OPDoc10="病案首页.病案首页.手术情况.手术情况.术者10#TYPE:Simple#TID:3#TVER:0#SCODE:I0099#VTYPE:V//1/0"
	    s OPDoc11="病案首页.病案首页.手术情况.手术情况.术者11#TYPE:Simple#TID:3#TVER:0#SCODE:I0168#VTYPE:V//1/0"
	    s OPDoc12="病案首页.病案首页.手术情况.手术情况.术者12#TYPE:Simple#TID:3#TVER:0#SCODE:I0169#VTYPE:V//1/0"
	    s OPDoc13="病案首页.病案首页.手术情况.手术情况.术者13#TYPE:Simple#TID:3#TVER:0#SCODE:I0170#VTYPE:V//1/0"
	    s OPDoc14="病案首页.病案首页.手术情况.手术情况.术者14#TYPE:Simple#TID:3#TVER:0#SCODE:I0171#VTYPE:V//1/0"
	    s OPDoc15="病案首页.病案首页.手术情况.手术情况.术者15#TYPE:Simple#TID:3#TVER:0#SCODE:I0172#VTYPE:V//1/0"
	    
	    s anaMethod1="病案首页.病案首页.手术情况.手术情况.麻醉方式1#TYPE:Simple#TID:3#TVER:0#SCODE:I0153#VTYPE:V/0"
	    s anaMethod2="病案首页.病案首页.手术情况.手术情况.麻醉方式2#TYPE:Simple#TID:3#TVER:0#SCODE:I0154#VTYPE:V/0"
	    s anaMethod3="病案首页.病案首页.手术情况.手术情况.麻醉方式3#TYPE:Simple#TID:3#TVER:0#SCODE:I0155#VTYPE:V/0"
	    s anaMethod4="病案首页.病案首页.手术情况.手术情况.麻醉方式4#TYPE:Simple#TID:3#TVER:0#SCODE:I0156#VTYPE:V/0"
	    s anaMethod5="病案首页.病案首页.手术情况.手术情况.麻醉方式5#TYPE:Simple#TID:3#TVER:0#SCODE:I0157#VTYPE:V/0"
	    s anaMethod6="病案首页.病案首页.手术情况.手术情况.麻醉方式6#TYPE:Simple#TID:3#TVER:0#SCODE:I0183#VTYPE:V/0"
	    s anaMethod7="病案首页.病案首页.手术情况.手术情况.麻醉方式7#TYPE:Simple#TID:3#TVER:0#SCODE:I0191#VTYPE:V/0"
	    s anaMethod8="病案首页.病案首页.手术情况.手术情况.麻醉方式8#TYPE:Simple#TID:3#TVER:0#SCODE:I0192#VTYPE:V/0"
	    s anaMethod9="病案首页.病案首页.手术情况.手术情况.麻醉方式9#TYPE:Simple#TID:3#TVER:0#SCODE:I0189#VTYPE:V/0"
	    s anaMethod10="病案首页.病案首页.手术情况.手术情况.麻醉方式10#TYPE:Simple#TID:3#TVER:0#SCODE:I0190#VTYPE:V/0"
	    s anaMethod11="病案首页.病案首页.手术情况.手术情况.麻醉方式11#TYPE:Simple#TID:3#TVER:0#SCODE:I0188#VTYPE:V/0"
	    s anaMethod12="病案首页.病案首页.手术情况.手术情况.麻醉方式12#TYPE:Simple#TID:3#TVER:0#SCODE:I0184#VTYPE:V/0"
	    s anaMethod13="病案首页.病案首页.手术情况.手术情况.麻醉方式13#TYPE:Simple#TID:3#TVER:0#SCODE:I0185#VTYPE:V/0"
	    s anaMethod14="病案首页.病案首页.手术情况.手术情况.麻醉方式14#TYPE:Simple#TID:3#TVER:0#SCODE:I0186#VTYPE:V/0"
	    s anaMethod15="病案首页.病案首页.手术情况.手术情况.麻醉方式15#TYPE:Simple#TID:3#TVER:0#SCODE:I0187#VTYPE:V/0"
	    
	    s anaDoc1="病案首页.病案首页.手术情况.手术情况.麻醉医师1#TYPE:Simple#TID:3#TVER:0#SCODE:I0051#VTYPE:V//1/0"
	    s anaDoc2="病案首页.病案首页.手术情况.手术情况.麻醉医师2#TYPE:Simple#TID:3#TVER:0#SCODE:I0050#VTYPE:V//1/0"
	    s anaDoc3="病案首页.病案首页.手术情况.手术情况.麻醉医师3#TYPE:Simple#TID:3#TVER:0#SCODE:I0052#VTYPE:V//1/0"
	    s anaDoc4="病案首页.病案首页.手术情况.手术情况.麻醉医师4#TYPE:Simple#TID:3#TVER:0#SCODE:I0053#VTYPE:V//1/0"
	    s anaDoc5="病案首页.病案首页.手术情况.手术情况.麻醉医师5#TYPE:Simple#TID:3#TVER:0#SCODE:I0134#VTYPE:V//1/0"
	    s anaDoc6="病案首页.病案首页.手术情况.手术情况.麻醉医师6#TYPE:Simple#TID:3#TVER:0#SCODE:I0136#VTYPE:V//1/0"
	    s anaDoc7="病案首页.病案首页.手术情况.手术情况.麻醉医师7#TYPE:Simple#TID:3#TVER:0#SCODE:I0137#VTYPE:V//1/0"
	    s anaDoc8="病案首页.病案首页.手术情况.手术情况.麻醉医师8#TYPE:Simple#TID:3#TVER:0#SCODE:I0139#VTYPE:V//1/0"
	    s anaDoc9="病案首页.病案首页.手术情况.手术情况.麻醉医师9#TYPE:Simple#TID:3#TVER:0#SCODE:I0138#VTYPE:V//1/0"
	    s anaDoc10="病案首页.病案首页.手术情况.手术情况.麻醉医师10#TYPE:Simple#TID:3#TVER:0#SCODE:I0135#VTYPE:V//1/0"
	    s anaDoc11="病案首页.病案首页.手术情况.手术情况.麻醉医师11#TYPE:Simple#TID:3#TVER:0#SCODE:I0206#VTYPE:V//1/0"
	    s anaDoc12="病案首页.病案首页.手术情况.手术情况.麻醉医师12#TYPE:Simple#TID:3#TVER:0#SCODE:I0205#VTYPE:V//1/0"
	    s anaDoc13="病案首页.病案首页.手术情况.手术情况.麻醉医师13#TYPE:Simple#TID:3#TVER:0#SCODE:I0204#VTYPE:V//1/0"
	    s anaDoc14="病案首页.病案首页.手术情况.手术情况.麻醉医师14#TYPE:Simple#TID:3#TVER:0#SCODE:I0203#VTYPE:V//1/0"
	    s anaDoc15="病案首页.病案首页.手术情况.手术情况.麻醉医师15#TYPE:Simple#TID:3#TVER:0#SCODE:I0207#VTYPE:V//1/0"
	    
	    s AssDoc11="病案首页.病案首页.手术情况.手术情况.Ⅰ助1#TYPE:Simple#TID:3#TVER:0#SCODE:I0030#VTYPE:V//1/0"
	    s AssDoc12="病案首页.病案首页.手术情况.手术情况.Ⅰ助2#TYPE:Simple#TID:3#TVER:0#SCODE:I0031#VTYPE:V//1/0"
	    s AssDoc13="病案首页.病案首页.手术情况.手术情况.Ⅰ助3#TYPE:Simple#TID:3#TVER:0#SCODE:I0032#VTYPE:V//1/0"
	    s AssDoc14="病案首页.病案首页.手术情况.手术情况.Ⅰ助4#TYPE:Simple#TID:3#TVER:0#SCODE:I0033#VTYPE:V//1/0"
	    s AssDoc15="病案首页.病案首页.手术情况.手术情况.Ⅰ助5#TYPE:Simple#TID:3#TVER:0#SCODE:I0104#VTYPE:V//1/0"
	    s AssDoc16="病案首页.病案首页.手术情况.手术情况.Ⅰ助6#TYPE:Simple#TID:3#TVER:0#SCODE:I0105#VTYPE:V//1/0"
	    s AssDoc17="病案首页.病案首页.手术情况.手术情况.Ⅰ助7#TYPE:Simple#TID:3#TVER:0#SCODE:I0109#VTYPE:V//1/0"
	    s AssDoc18="病案首页.病案首页.手术情况.手术情况.Ⅰ助8#TYPE:Simple#TID:3#TVER:0#SCODE:I0108#VTYPE:V//1/0"
	    s AssDoc19="病案首页.病案首页.手术情况.手术情况.Ⅰ助9#TYPE:Simple#TID:3#TVER:0#SCODE:I0106#VTYPE:V//1/0"
	    s AssDoc110="病案首页.病案首页.手术情况.手术情况.Ⅰ助10#TYPE:Simple#TID:3#TVER:0#SCODE:I0107#VTYPE:V//1/0"
	    s AssDoc111="病案首页.病案首页.手术情况.手术情况.Ⅰ助11#TYPE:Simple#TID:3#TVER:0#SCODE:I0173#VTYPE:V//1/0"
	    s AssDoc112="病案首页.病案首页.手术情况.手术情况.Ⅰ助12#TYPE:Simple#TID:3#TVER:0#SCODE:I0174#VTYPE:V//1/0"
	    s AssDoc113="病案首页.病案首页.手术情况.手术情况.Ⅰ助13#TYPE:Simple#TID:3#TVER:0#SCODE:I0175#VTYPE:V//1/0"
	    s AssDoc114="病案首页.病案首页.手术情况.手术情况.Ⅰ助14#TYPE:Simple#TID:3#TVER:0#SCODE:I0176#VTYPE:V//1/0"
	    s AssDoc115="病案首页.病案首页.手术情况.手术情况.Ⅰ助15#TYPE:Simple#TID:3#TVER:0#SCODE:I0177#VTYPE:V//1/0"
		
	    s AssDoc21="病案首页.病案首页.手术情况.手术情况.Ⅱ助1#TYPE:Simple#TID:3#TVER:0#SCODE:I0034#VTYPE:V//1/0"
	    s AssDoc22="病案首页.病案首页.手术情况.手术情况.Ⅱ助2#TYPE:Simple#TID:3#TVER:0#SCODE:I0035#VTYPE:V//1/0"
	    s AssDoc23="病案首页.病案首页.手术情况.手术情况.Ⅱ助3#TYPE:Simple#TID:3#TVER:0#SCODE:I0037#VTYPE:V//1/0"
	    s AssDoc24="病案首页.病案首页.手术情况.手术情况.Ⅱ助4#TYPE:Simple#TID:3#TVER:0#SCODE:I0036#VTYPE:V//1/0"
	    s AssDoc25="病案首页.病案首页.手术情况.手术情况.Ⅱ助5#TYPE:Simple#TID:3#TVER:0#SCODE:I0110#VTYPE:V//1/0"
	    s AssDoc26="病案首页.病案首页.手术情况.手术情况.Ⅱ助6#TYPE:Simple#TID:3#TVER:0#SCODE:I0112#VTYPE:V//1/0"
	    s AssDoc27="病案首页.病案首页.手术情况.手术情况.Ⅱ助7#TYPE:Simple#TID:3#TVER:0#SCODE:I0115#VTYPE:V//1/0"
	    s AssDoc28="病案首页.病案首页.手术情况.手术情况.Ⅱ助8#TYPE:Simple#TID:3#TVER:0#SCODE:I0114#VTYPE:V//1/0"
	    s AssDoc29="病案首页.病案首页.手术情况.手术情况.Ⅱ助9#TYPE:Simple#TID:3#TVER:0#SCODE:I0113#VTYPE:V//1/0"
	    s AssDoc210="病案首页.病案首页.手术情况.手术情况.Ⅱ助10#TYPE:Simple#TID:3#TVER:0#SCODE:I0111#VTYPE:V//1/0"
	    s AssDoc211="病案首页.病案首页.手术情况.手术情况.Ⅱ助11#TYPE:Simple#TID:3#TVER:0#SCODE:I0178#VTYPE:V//1/0"
	    s AssDoc212="病案首页.病案首页.手术情况.手术情况.Ⅱ助12#TYPE:Simple#TID:3#TVER:0#SCODE:I0179#VTYPE:V//1/0"
	    s AssDoc213="病案首页.病案首页.手术情况.手术情况.Ⅱ助13#TYPE:Simple#TID:3#TVER:0#SCODE:I0180#VTYPE:V//1/0"
	    s AssDoc214="病案首页.病案首页.手术情况.手术情况.Ⅱ助14#TYPE:Simple#TID:3#TVER:0#SCODE:I0181#VTYPE:V//1/0"
	    s AssDoc215="病案首页.病案首页.手术情况.手术情况.Ⅱ助15#TYPE:Simple#TID:3#TVER:0#SCODE:I0182#VTYPE:V//1/0"
	    
	    s CutClose11="病案首页.病案首页.手术情况.手术情况.切口愈合等级11#TYPE:Simple#TID:3#TVER:0#SCODE:O0042#VTYPE:V/0"
	    s CutClose12="病案首页.病案首页.手术情况.手术情况.切口愈合等级12#TYPE:Simple#TID:3#TVER:0#SCODE:O0047#VTYPE:V/0"
	    s CutClose13="病案首页.病案首页.手术情况.手术情况.切口愈合等级13#TYPE:Simple#TID:3#TVER:0#SCODE:O0043#VTYPE:V/0"
	    s CutClose14="病案首页.病案首页.手术情况.手术情况.切口愈合等级14#TYPE:Simple#TID:3#TVER:0#SCODE:O0049#VTYPE:V/0"
	    s CutClose15="病案首页.病案首页.手术情况.手术情况.切口愈合等级15#TYPE:Simple#TID:3#TVER:0#SCODE:O0122#VTYPE:V/0"
	    s CutClose16="病案首页.病案首页.手术情况.手术情况.切口愈合等级16#TYPE:Simple#TID:3#TVER:0#SCODE:O0125#VTYPE:V/0"
	    s CutClose17="病案首页.病案首页.手术情况.手术情况.切口愈合等级17#TYPE:Simple#TID:3#TVER:0#SCODE:O0124#VTYPE:V/0"
	    s CutClose18="病案首页.病案首页.手术情况.手术情况.切口愈合等级18#TYPE:Simple#TID:3#TVER:0#SCODE:O0126#VTYPE:V/0"
	    s CutClose19="病案首页.病案首页.手术情况.手术情况.切口愈合等级19#TYPE:Simple#TID:3#TVER:0#SCODE:O0127#VTYPE:V/0"
	    s CutClose110="病案首页.病案首页.手术情况.手术情况.切口愈合等级110#TYPE:Simple#TID:3#TVER:0#SCODE:O0123#VTYPE:V/0"
	    s CutClose111="病案首页.病案首页.手术情况.手术情况.切口愈合等级111#TYPE:Simple#TID:3#TVER:0#SCODE:O0197#VTYPE:V/0"
	    s CutClose112="病案首页.病案首页.手术情况.手术情况.切口愈合等级112#TYPE:Simple#TID:3#TVER:0#SCODE:O0196#VTYPE:V/0"
	    s CutClose113="病案首页.病案首页.手术情况.手术情况.切口愈合等级113#TYPE:Simple#TID:3#TVER:0#SCODE:O0195#VTYPE:V/0"
	    s CutClose114="病案首页.病案首页.手术情况.手术情况.切口愈合等级114#TYPE:Simple#TID:3#TVER:0#SCODE:O0194#VTYPE:V/0"
	    s CutClose115="病案首页.病案首页.手术情况.手术情况.切口愈合等级115#TYPE:Simple#TID:3#TVER:0#SCODE:O0193#VTYPE:V/0"
	    
	    s CutClose21="病案首页.病案首页.手术情况.手术情况.切口愈合等级21#TYPE:Simple#TID:3#TVER:0#SCODE:O0048#VTYPE:V/0"
	    s CutClose22="病案首页.病案首页.手术情况.手术情况.切口愈合等级22#TYPE:Simple#TID:3#TVER:0#SCODE:O0046#VTYPE:V/0"
	    s CutClose23="病案首页.病案首页.手术情况.手术情况.切口愈合等级23#TYPE:Simple#TID:3#TVER:0#SCODE:O0045#VTYPE:V/0"
	    s CutClose24="病案首页.病案首页.手术情况.手术情况.切口愈合等级24#TYPE:Simple#TID:3#TVER:0#SCODE:O0044#VTYPE:V/0"
	    s CutClose25="病案首页.病案首页.手术情况.手术情况.切口愈合等级25#TYPE:Simple#TID:3#TVER:0#SCODE:O0128#VTYPE:V/0"
	    s CutClose26="病案首页.病案首页.手术情况.手术情况.切口愈合等级26#TYPE:Simple#TID:3#TVER:0#SCODE:O0130#VTYPE:V/0"
	    s CutClose27="病案首页.病案首页.手术情况.手术情况.切口愈合等级27#TYPE:Simple#TID:3#TVER:0#SCODE:O0131#VTYPE:V/0"
	    s CutClose28="病案首页.病案首页.手术情况.手术情况.切口愈合等级28#TYPE:Simple#TID:3#TVER:0#SCODE:O0133#VTYPE:V/0"
	    s CutClose29="病案首页.病案首页.手术情况.手术情况.切口愈合等级29#TYPE:Simple#TID:3#TVER:0#SCODE:O0132#VTYPE:V/0"
	    s CutClose210="病案首页.病案首页.手术情况.手术情况.切口愈合等级210#TYPE:Simple#TID:3#TVER:0#SCODE:O0129#VTYPE:V/0"
	    s CutClose211="病案首页.病案首页.手术情况.手术情况.切口愈合等级211#TYPE:Simple#TID:3#TVER:0#SCODE:O0202#VTYPE:V/0"
	    s CutClose212="病案首页.病案首页.手术情况.手术情况.切口愈合等级212#TYPE:Simple#TID:3#TVER:0#SCODE:O0201#VTYPE:V/0"
	    s CutClose213="病案首页.病案首页.手术情况.手术情况.切口愈合等级213#TYPE:Simple#TID:3#TVER:0#SCODE:O0200#VTYPE:V/0"
	    s CutClose214="病案首页.病案首页.手术情况.手术情况.切口愈合等级214#TYPE:Simple#TID:3#TVER:0#SCODE:O0199#VTYPE:V/0"
	    s CutClose215="病案首页.病案首页.手术情况.手术情况.切口愈合等级215#TYPE:Simple#TID:3#TVER:0#SCODE:O0198#VTYPE:V/0"
	    
	    s TMP1=opRowid_$c(2)_OPDesc1_$c(2)_OPDate1_$c(2)_status_$c(2)_OPDate1_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc1_$c(2)_anaMethod1_$c(2)_anaDoc1_$c(2)_AssDoc11_$c(3)_AssDoc21_$c(2)_OPCode1_$c(2)_CutClose11_$c(2)_CutClose21
	    s TMP2=opRowid_$c(2)_OPDesc2_$c(2)_OPDate2_$c(2)_status_$c(2)_OPDate2_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc2_$c(2)_anaMethod2_$c(2)_anaDoc2_$c(2)_AssDoc12_$c(3)_AssDoc22_$c(2)_OPCode2_$c(2)_CutClose12_$c(2)_CutClose22
	    s TMP3=opRowid_$c(2)_OPDesc3_$c(2)_OPDate3_$c(2)_status_$c(2)_OPDate3_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc3_$c(2)_anaMethod3_$c(2)_anaDoc3_$c(2)_AssDoc13_$c(3)_AssDoc23_$c(2)_OPCode3_$c(2)_CutClose13_$c(2)_CutClose23
	    s TMP4=opRowid_$c(2)_OPDesc4_$c(2)_OPDate4_$c(2)_status_$c(2)_OPDate4_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc4_$c(2)_anaMethod4_$c(2)_anaDoc4_$c(2)_AssDoc14_$c(3)_AssDoc24_$c(2)_OPCode4_$c(2)_CutClose14_$c(2)_CutClose24
	    s TMP5=opRowid_$c(2)_OPDesc5_$c(2)_OPDate5_$c(2)_status_$c(2)_OPDate5_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc5_$c(2)_anaMethod5_$c(2)_anaDoc5_$c(2)_AssDoc15_$c(3)_AssDoc25_$c(2)_OPCode5_$c(2)_CutClose15_$c(2)_CutClose25
	    s TMP6=opRowid_$c(2)_OPDesc6_$c(2)_OPDate6_$c(2)_status_$c(2)_OPDate6_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc6_$c(2)_anaMethod6_$c(2)_anaDoc6_$c(2)_AssDoc16_$c(3)_AssDoc26_$c(2)_OPCode6_$c(2)_CutClose16_$c(2)_CutClose26
	    s TMP7=opRowid_$c(2)_OPDesc7_$c(2)_OPDate7_$c(2)_status_$c(2)_OPDate7_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc7_$c(2)_anaMethod7_$c(2)_anaDoc7_$c(2)_AssDoc17_$c(3)_AssDoc27_$c(2)_OPCode7_$c(2)_CutClose17_$c(2)_CutClose27
	    s TMP8=opRowid_$c(2)_OPDesc8_$c(2)_OPDate8_$c(2)_status_$c(2)_OPDate8_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc8_$c(2)_anaMethod8_$c(2)_anaDoc8_$c(2)_AssDoc18_$c(3)_AssDoc28_$c(2)_OPCode8_$c(2)_CutClose18_$c(2)_CutClose28
	    s TMP9=opRowid_$c(2)_OPDesc9_$c(2)_OPDate9_$c(2)_status_$c(2)_OPDate9_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc9_$c(2)_anaMethod9_$c(2)_anaDoc9_$c(2)_AssDoc19_$c(3)_AssDoc29_$c(2)_OPCode9_$c(2)_CutClose19_$c(2)_CutClose29
	    s TMP10=opRowid_$c(2)_OPDesc10_$c(2)_OPDate10_$c(2)_status_$c(2)_OPDate10_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc10_$c(2)_anaMethod10_$c(2)_anaDoc10_$c(2)_AssDoc110_$c(3)_AssDoc210_$c(2)_OPCode10_$c(2)_CutClose110_$c(2)_CutClose210
		s TMP11=opRowid_$c(2)_OPDesc11_$c(2)_OPDate11_$c(2)_status_$c(2)_OPDate11_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc11_$c(2)_anaMethod11_$c(2)_anaDoc11_$c(2)_AssDoc111_$c(3)_AssDoc211_$c(2)_OPCode11_$c(2)_CutClose111_$c(2)_CutClose211
	    s TMP12=opRowid_$c(2)_OPDesc12_$c(2)_OPDate12_$c(2)_status_$c(2)_OPDate12_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc12_$c(2)_anaMethod12_$c(2)_anaDoc12_$c(2)_AssDoc112_$c(3)_AssDoc212_$c(2)_OPCode12_$c(2)_CutClose112_$c(2)_CutClose212
	    s TMP13=opRowid_$c(2)_OPDesc13_$c(2)_OPDate13_$c(2)_status_$c(2)_OPDate13_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc13_$c(2)_anaMethod13_$c(2)_anaDoc13_$c(2)_AssDoc113_$c(3)_AssDoc213_$c(2)_OPCode13_$c(2)_CutClose113_$c(2)_CutClose213
	    s TMP14=opRowid_$c(2)_OPDesc14_$c(2)_OPDate14_$c(2)_status_$c(2)_OPDate14_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc14_$c(2)_anaMethod14_$c(2)_anaDoc14_$c(2)_AssDoc114_$c(3)_AssDoc214_$c(2)_OPCode14_$c(2)_CutClose114_$c(2)_CutClose214
	    s TMP15=opRowid_$c(2)_OPDesc15_$c(2)_OPDate15_$c(2)_status_$c(2)_OPDate15_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc15_$c(2)_anaMethod15_$c(2)_anaDoc15_$c(2)_AssDoc115_$c(3)_AssDoc215_$c(2)_OPCode15_$c(2)_CutClose115_$c(2)_CutClose215
	    
		set ^DHCWMROperSetting("OPER",1)=TMP1
		set ^DHCWMROperSetting("OPER",2)=TMP2
		set ^DHCWMROperSetting("OPER",3)=TMP3
		set ^DHCWMROperSetting("OPER",4)=TMP4
		set ^DHCWMROperSetting("OPER",5)=TMP5
		set ^DHCWMROperSetting("OPER",6)=TMP6
		set ^DHCWMROperSetting("OPER",7)=TMP7
		set ^DHCWMROperSetting("OPER",8)=TMP8
		set ^DHCWMROperSetting("OPER",9)=TMP9
		set ^DHCWMROperSetting("OPER",10)=TMP10
		set ^DHCWMROperSetting("OPER",11)=TMP11
		set ^DHCWMROperSetting("OPER",12)=TMP12
		set ^DHCWMROperSetting("OPER",13)=TMP13
		set ^DHCWMROperSetting("OPER",14)=TMP14
		set ^DHCWMROperSetting("OPER",15)=TMP15
    }
    
    //地坛医院取EPR手术操作信息 元数据代码
    if (HospCode="BeiJing_DT") {
	    s OPDesc1="首页手术情况.手术操作名称1#TYPE:Simple#TID:68#TVER:0#SCODE:I0022#VTYPE:V/0"
	    s OPDesc2="首页手术情况.手术操作名称2#TYPE:Simple#TID:68#TVER:0#SCODE:I0023#VTYPE:V/0"
	    s OPDesc3="首页手术情况.手术操作名称3#TYPE:Simple#TID:68#TVER:0#SCODE:I0024#VTYPE:V/0"
	    s OPDesc4="首页手术情况.手术操作名称4#TYPE:Simple#TID:68#TVER:0#SCODE:I0025#VTYPE:V/0"
	    s OPDesc5="首页手术情况.手术操作名称5#TYPE:Simple#TID:68#TVER:0#SCODE:I0093#VTYPE:V/0"
	    s OPDesc6="首页手术情况.手术操作名称1#TYPE:Simple#TID:69#TVER:0#SCODE:I0022#VTYPE:V/0"
	    s OPDesc7="首页手术情况.手术操作名称2#TYPE:Simple#TID:69#TVER:0#SCODE:I0023#VTYPE:V/0"
	    s OPDesc8="首页手术情况.手术操作名称3#TYPE:Simple#TID:69#TVER:0#SCODE:I0024#VTYPE:V/0"
	    s OPDesc9="首页手术情况.手术操作名称4#TYPE:Simple#TID:69#TVER:0#SCODE:I0025#VTYPE:V/0"
	    s OPDesc10="首页手术情况.手术操作名称5#TYPE:Simple#TID:69#TVER:0#SCODE:I0093#VTYPE:V/0"
	    
	    s OPCode1="首页手术情况.手术操作名称1#TYPE:Simple#TID:68#TVER:0#SCODE:I0022#VTYPE:V/1"
	    s OPCode2="首页手术情况.手术操作名称2#TYPE:Simple#TID:68#TVER:0#SCODE:I0023#VTYPE:V/1"
	    s OPCode3="首页手术情况.手术操作名称3#TYPE:Simple#TID:68#TVER:0#SCODE:I0024#VTYPE:V/1"
	    s OPCode4="首页手术情况.手术操作名称4#TYPE:Simple#TID:68#TVER:0#SCODE:I0025#VTYPE:V/1"
	    s OPCode5="首页手术情况.手术操作名称5#TYPE:Simple#TID:68#TVER:0#SCODE:I0093#VTYPE:V/1"
	    s OPCode6="首页手术情况.手术操作名称1#TYPE:Simple#TID:69#TVER:0#SCODE:I0022#VTYPE:V/1"
	    s OPCode7="首页手术情况.手术操作名称2#TYPE:Simple#TID:69#TVER:0#SCODE:I0023#VTYPE:V/1"
	    s OPCode8="首页手术情况.手术操作名称3#TYPE:Simple#TID:69#TVER:0#SCODE:I0024#VTYPE:V/1"
	    s OPCode9="首页手术情况.手术操作名称4#TYPE:Simple#TID:69#TVER:0#SCODE:I0025#VTYPE:V/1"
	    s OPCode10="首页手术情况.手术操作名称5#TYPE:Simple#TID:69#TVER:0#SCODE:I0093#VTYPE:V/1"
	    
	    s OPDate1="首页手术情况.手术操作日期1#TYPE:Simple#TID:68#TVER:0#SCODE:D0141#VTYPE:V/1"
	    s OPDate2="首页手术情况.手术操作日期2#TYPE:Simple#TID:68#TVER:0#SCODE:D0142#VTYPE:V/1"
	    s OPDate3="首页手术情况.手术操作日期3#TYPE:Simple#TID:68#TVER:0#SCODE:D0143#VTYPE:V/1"
	    s OPDate4="首页手术情况.手术操作日期4#TYPE:Simple#TID:68#TVER:0#SCODE:D0145#VTYPE:V/1"
	    s OPDate5="首页手术情况.手术操作日期5#TYPE:Simple#TID:68#TVER:0#SCODE:D0149#VTYPE:V/1"
	    s OPDate6="首页手术情况.手术操作日期1#TYPE:Simple#TID:69#TVER:0#SCODE:D0141#VTYPE:V/1"
	    s OPDate7="首页手术情况.手术操作日期2#TYPE:Simple#TID:69#TVER:0#SCODE:D0142#VTYPE:V/1"
	    s OPDate8="首页手术情况.手术操作日期3#TYPE:Simple#TID:69#TVER:0#SCODE:D0143#VTYPE:V/1"
	    s OPDate9="首页手术情况.手术操作日期4#TYPE:Simple#TID:69#TVER:0#SCODE:D0145#VTYPE:V/1"
	    s OPDate10="首页手术情况.手术操作日期5#TYPE:Simple#TID:69#TVER:0#SCODE:D0149#VTYPE:V/1"
	    
	    s OPDoc1="首页手术情况.术者1#TYPE:Simple#TID:68#TVER:0#SCODE:I0026#VTYPE:V//1/0"
	    s OPDoc2="首页手术情况.术者2#TYPE:Simple#TID:68#TVER:0#SCODE:I0027#VTYPE:V//1/0"
	    s OPDoc3="首页手术情况.术者3#TYPE:Simple#TID:68#TVER:0#SCODE:I0028#VTYPE:V//1/0"
	    s OPDoc4="首页手术情况.术者4#TYPE:Simple#TID:68#TVER:0#SCODE:I0029#VTYPE:V//1/0"
	    s OPDoc5="首页手术情况.术者5#TYPE:Simple#TID:68#TVER:0#SCODE:I0098#VTYPE:V//1/0"
	    s OPDoc6="首页手术情况.术者1#TYPE:Simple#TID:69#TVER:0#SCODE:I0026#VTYPE:V//1/0"
	    s OPDoc7="首页手术情况.术者2#TYPE:Simple#TID:69#TVER:0#SCODE:I0027#VTYPE:V//1/0"
	    s OPDoc8="首页手术情况.术者3#TYPE:Simple#TID:69#TVER:0#SCODE:I0028#VTYPE:V//1/0"
	    s OPDoc9="首页手术情况.术者4#TYPE:Simple#TID:69#TVER:0#SCODE:I0029#VTYPE:V//1/0"
	    s OPDoc10="首页手术情况.术者5#TYPE:Simple#TID:69#TVER:0#SCODE:I0098#VTYPE:V//1/0"
	    
	    s anaMethod1="首页手术情况.麻醉方式1#TYPE:Simple#TID:68#TVER:0#SCODE:I0153#VTYPE:V/0"
	    s anaMethod2="首页手术情况.麻醉方式2#TYPE:Simple#TID:68#TVER:0#SCODE:I0154#VTYPE:V/0"
	    s anaMethod3="首页手术情况.麻醉方式3#TYPE:Simple#TID:68#TVER:0#SCODE:I0155#VTYPE:V/0"
	    s anaMethod4="首页手术情况.麻醉方式4#TYPE:Simple#TID:68#TVER:0#SCODE:I0156#VTYPE:V/0"
	    s anaMethod5="首页手术情况.麻醉方式5#TYPE:Simple#TID:68#TVER:0#SCODE:I0157#VTYPE:V/0"
	    s anaMethod6="首页手术情况.麻醉方式1#TYPE:Simple#TID:69#TVER:0#SCODE:I0153#VTYPE:V/0"
	    s anaMethod7="首页手术情况.麻醉方式2#TYPE:Simple#TID:69#TVER:0#SCODE:I0154#VTYPE:V/0"
	    s anaMethod8="首页手术情况.麻醉方式3#TYPE:Simple#TID:69#TVER:0#SCODE:I0155#VTYPE:V/0"
	    s anaMethod9="首页手术情况.麻醉方式4#TYPE:Simple#TID:69#TVER:0#SCODE:I0156#VTYPE:V/0"
	    s anaMethod10="首页手术情况.麻醉方式5#TYPE:Simple#TID:69#TVER:0#SCODE:I0157#VTYPE:V/0"
	    
	    s anaDoc1="首页手术情况.麻醉医师1#TYPE:Simple#TID:68#TVER:0#SCODE:I0051#VTYPE:V//1/0"
	    s anaDoc2="首页手术情况.麻醉医师2#TYPE:Simple#TID:68#TVER:0#SCODE:I0050#VTYPE:V//1/0"
	    s anaDoc3="首页手术情况.麻醉医师3#TYPE:Simple#TID:68#TVER:0#SCODE:I0052#VTYPE:V//1/0"
	    s anaDoc4="首页手术情况.麻醉医师4#TYPE:Simple#TID:68#TVER:0#SCODE:I0053#VTYPE:V//1/0"
	    s anaDoc5="首页手术情况.麻醉医师5#TYPE:Simple#TID:68#TVER:0#SCODE:I0134#VTYPE:V//1/0"
	    s anaDoc6="首页手术情况.麻醉医师1#TYPE:Simple#TID:69#TVER:0#SCODE:I0051#VTYPE:V//1/0"
	    s anaDoc7="首页手术情况.麻醉医师2#TYPE:Simple#TID:69#TVER:0#SCODE:I0050#VTYPE:V//1/0"
	    s anaDoc8="首页手术情况.麻醉医师3#TYPE:Simple#TID:69#TVER:0#SCODE:I0052#VTYPE:V//1/0"
	    s anaDoc9="首页手术情况.麻醉医师4#TYPE:Simple#TID:69#TVER:0#SCODE:I0053#VTYPE:V//1/0"
	    s anaDoc10="首页手术情况.麻醉医师5#TYPE:Simple#TID:69#TVER:0#SCODE:I0134#VTYPE:V//1/0"
	    
	    s AssDoc11="首页手术情况.Ⅰ助1#TYPE:Simple#TID:68#TVER:0#SCODE:I0030#VTYPE:V//1/0"
	    s AssDoc12="首页手术情况.Ⅰ助2#TYPE:Simple#TID:68#TVER:0#SCODE:I0031#VTYPE:V//1/0"
	    s AssDoc13="首页手术情况.Ⅰ助3#TYPE:Simple#TID:68#TVER:0#SCODE:I0032#VTYPE:V//1/0"
	    s AssDoc14="首页手术情况.Ⅰ助4#TYPE:Simple#TID:68#TVER:0#SCODE:I0033#VTYPE:V//1/0"
	    s AssDoc15="首页手术情况.Ⅰ助5#TYPE:Simple#TID:68#TVER:0#SCODE:I0104#VTYPE:V//1/0"
	    s AssDoc16="首页手术情况.Ⅰ助1#TYPE:Simple#TID:69#TVER:0#SCODE:I0030#VTYPE:V//1/0"
	    s AssDoc17="首页手术情况.Ⅰ助2#TYPE:Simple#TID:69#TVER:0#SCODE:I0031#VTYPE:V//1/0"
	    s AssDoc18="首页手术情况.Ⅰ助3#TYPE:Simple#TID:69#TVER:0#SCODE:I0032#VTYPE:V//1/0"
	    s AssDoc19="首页手术情况.Ⅰ助4#TYPE:Simple#TID:69#TVER:0#SCODE:I0033#VTYPE:V//1/0"
	    s AssDoc110="首页手术情况.Ⅰ助5#TYPE:Simple#TID:69#TVER:0#SCODE:I0104#VTYPE:V//1/0"
		
	    s AssDoc21="首页手术情况.Ⅱ助1#TYPE:Simple#TID:68#TVER:0#SCODE:I0034#VTYPE:V//1/0"
	    s AssDoc22="首页手术情况.Ⅱ助2#TYPE:Simple#TID:68#TVER:0#SCODE:I0035#VTYPE:V//1/0"
	    s AssDoc23="首页手术情况.Ⅱ助3#TYPE:Simple#TID:68#TVER:0#SCODE:I0037#VTYPE:V//1/0"
	    s AssDoc24="首页手术情况.Ⅱ助4#TYPE:Simple#TID:68#TVER:0#SCODE:I0036#VTYPE:V//1/0"
	    s AssDoc25="首页手术情况.Ⅱ助5#TYPE:Simple#TID:68#TVER:0#SCODE:I0110#VTYPE:V//1/0"
	    s AssDoc26="首页手术情况.Ⅱ助1#TYPE:Simple#TID:69#TVER:0#SCODE:I0034#VTYPE:V//1/0"
	    s AssDoc27="首页手术情况.Ⅱ助2#TYPE:Simple#TID:69#TVER:0#SCODE:I0035#VTYPE:V//1/0"
	    s AssDoc28="首页手术情况.Ⅱ助3#TYPE:Simple#TID:69#TVER:0#SCODE:I0037#VTYPE:V//1/0"
	    s AssDoc29="首页手术情况.Ⅱ助4#TYPE:Simple#TID:69#TVER:0#SCODE:I0036#VTYPE:V//1/0"
	    s AssDoc210="首页手术情况.Ⅱ助5#TYPE:Simple#TID:69#TVER:0#SCODE:I0110#VTYPE:V//1/0"
	    
	    //add by zf 2008-09-23 切口类型
	    s CutClose11="首页手术情况.切口愈合等级11#TYPE:Simple#TID:68#TVER:0#SCODE:O0042#VTYPE:V/0"
	    s CutClose12="首页手术情况.切口愈合等级12#TYPE:Simple#TID:68#TVER:0#SCODE:O0047#VTYPE:V/0"
	    s CutClose13="首页手术情况.切口愈合等级13#TYPE:Simple#TID:68#TVER:0#SCODE:O0043#VTYPE:V/0"
	    s CutClose14="首页手术情况.切口愈合等级14#TYPE:Simple#TID:68#TVER:0#SCODE:O0049#VTYPE:V/0"
	    s CutClose15="首页手术情况.切口愈合等级15#TYPE:Simple#TID:68#TVER:0#SCODE:O0122#VTYPE:V/0"
	    s CutClose16=""
	    s CutClose17=""
	    s CutClose18=""
	    s CutClose19=""
	    s CutClose110=""
	    
	    //add by zf 2008-09-23 愈合情况
	    s CutClose21="首页手术情况.切口愈合等级21#TYPE:Simple#TID:68#TVER:0#SCODE:O0048#VTYPE:V/0"
	    s CutClose22="首页手术情况.切口愈合等级22#TYPE:Simple#TID:68#TVER:0#SCODE:O0046#VTYPE:V/0"
	    s CutClose23="首页手术情况.切口愈合等级23#TYPE:Simple#TID:68#TVER:0#SCODE:O0045#VTYPE:V/0"
	    s CutClose24="首页手术情况.切口愈合等级24#TYPE:Simple#TID:68#TVER:0#SCODE:O0044#VTYPE:V/0"
	    s CutClose25="首页手术情况.切口愈合等级25#TYPE:Simple#TID:68#TVER:0#SCODE:O0128#VTYPE:V/0"
	    s CutClose26=""
	    s CutClose27=""
	    s CutClose28=""
	    s CutClose29=""
	    s CutClose210=""
		
	    s TMP1=opRowid_$c(2)_OPDesc1_$c(2)_OPDate1_$c(2)_status_$c(2)_OPDate1_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc1_$c(2)_anaMethod1_$c(2)_anaDoc1_$c(2)_AssDoc11_$c(3)_AssDoc21_$c(2)_OPCode1_$c(2)_CutClose11_$c(2)_CutClose21
	    s TMP2=opRowid_$c(2)_OPDesc2_$c(2)_OPDate2_$c(2)_status_$c(2)_OPDate2_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc2_$c(2)_anaMethod2_$c(2)_anaDoc2_$c(2)_AssDoc12_$c(3)_AssDoc22_$c(2)_OPCode2_$c(2)_CutClose12_$c(2)_CutClose22
	    s TMP3=opRowid_$c(2)_OPDesc3_$c(2)_OPDate3_$c(2)_status_$c(2)_OPDate3_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc3_$c(2)_anaMethod3_$c(2)_anaDoc3_$c(2)_AssDoc13_$c(3)_AssDoc23_$c(2)_OPCode3_$c(2)_CutClose13_$c(2)_CutClose23
	    s TMP4=opRowid_$c(2)_OPDesc4_$c(2)_OPDate4_$c(2)_status_$c(2)_OPDate4_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc4_$c(2)_anaMethod4_$c(2)_anaDoc4_$c(2)_AssDoc14_$c(3)_AssDoc24_$c(2)_OPCode4_$c(2)_CutClose14_$c(2)_CutClose24
	    s TMP5=opRowid_$c(2)_OPDesc5_$c(2)_OPDate5_$c(2)_status_$c(2)_OPDate5_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc5_$c(2)_anaMethod5_$c(2)_anaDoc5_$c(2)_AssDoc15_$c(3)_AssDoc25_$c(2)_OPCode5_$c(2)_CutClose15_$c(2)_CutClose25
	    s TMP6=opRowid_$c(2)_OPDesc6_$c(2)_OPDate6_$c(2)_status_$c(2)_OPDate6_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc6_$c(2)_anaMethod6_$c(2)_anaDoc6_$c(2)_AssDoc16_$c(3)_AssDoc26_$c(2)_OPCode6_$c(2)_CutClose16_$c(2)_CutClose26
	    s TMP7=opRowid_$c(2)_OPDesc7_$c(2)_OPDate7_$c(2)_status_$c(2)_OPDate7_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc7_$c(2)_anaMethod7_$c(2)_anaDoc7_$c(2)_AssDoc17_$c(3)_AssDoc27_$c(2)_OPCode7_$c(2)_CutClose17_$c(2)_CutClose27
	    s TMP8=opRowid_$c(2)_OPDesc8_$c(2)_OPDate8_$c(2)_status_$c(2)_OPDate8_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc8_$c(2)_anaMethod8_$c(2)_anaDoc8_$c(2)_AssDoc18_$c(3)_AssDoc28_$c(2)_OPCode8_$c(2)_CutClose18_$c(2)_CutClose28
	    s TMP9=opRowid_$c(2)_OPDesc9_$c(2)_OPDate9_$c(2)_status_$c(2)_OPDate9_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc9_$c(2)_anaMethod9_$c(2)_anaDoc9_$c(2)_AssDoc19_$c(3)_AssDoc29_$c(2)_OPCode9_$c(2)_CutClose19_$c(2)_CutClose29
	    s TMP10=opRowid_$c(2)_OPDesc10_$c(2)_OPDate10_$c(2)_status_$c(2)_OPDate10_$c(2)_startTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OPDoc10_$c(2)_anaMethod10_$c(2)_anaDoc10_$c(2)_AssDoc110_$c(3)_AssDoc210_$c(2)_OPCode10_$c(2)_CutClose110_$c(2)_CutClose210
		
		set ^DHCWMROperSetting("OPER",1)=TMP1
		set ^DHCWMROperSetting("OPER",2)=TMP2
		set ^DHCWMROperSetting("OPER",3)=TMP3
		set ^DHCWMROperSetting("OPER",4)=TMP4
		set ^DHCWMROperSetting("OPER",5)=TMP5
		set ^DHCWMROperSetting("OPER",6)=TMP6
		set ^DHCWMROperSetting("OPER",7)=TMP7
		set ^DHCWMROperSetting("OPER",8)=TMP8
		set ^DHCWMROperSetting("OPER",9)=TMP9
		set ^DHCWMROperSetting("OPER",10)=TMP10
    }
    */
	
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

/// 函数：GetEPRElement
/// 说明:根据电子病历版本号取元数据
/// 参数列表：
/// MrDiagnosVer：电子病历版本号
/// paadm       ：就诊
/// eleCode     ：元数据代码
/// isGetCode   ：1表示取该项的代码，0表示取描述
ClassMethod GetEPRElement(MrDiagnosVer, paadm, eleCode, isGetCode)
{
	n (MrDiagnosVer,paadm, eleCode, isGetCode)
	s ret=""
	s:MrDiagnosVer=1 ret=..GetEPRV1Element(paadm, eleCode, isGetCode)
	s:MrDiagnosVer=2 ret=..GetEPRV2Element(paadm, eleCode, isGetCode)
	q ret
}

/// 构造电子病历诊断串
/// w ##class(web.DHCMedBaseDiagnose).GetEPRDiagnose(paadm, MrDiagnosVer)
ClassMethod GetEPRDiagnose(paadm, MrDiagnosVer)
{
	n (paadm,MrDiagnosVer)
    s ICDDR=""  ;$p(sDIA,"^",1)
    s ICDDoctorDR=""  ;$p(sDIA,"^",4)
    s ICDDate=""  ;$zd(+$p(sDIA,"^",7),3)
    s ICDTime=""  ;$zt(+$p(sDIA,"^",8))
    s ICDType=""  ;$g(^MR(+MRADM,"DIA",MRDIAChildsub,"TYP","1"))
    s paadmtype=$p($g(^PAADM(paadm)),"^",2)
    s ctloc=$p($g(^PAADM(paadm)),"^",4)
    s LocDesc=ctloc_"/"_$p(^CTLOC(+ctloc),"^",2)
    s s=paadm_$c(2)_paadmtype_$c(2)_LocDesc_$c(2)_"MRDIA"_$c(2)_"ICDDR"_$c(2)_ICDDoctorDR_$c(2)_ICDType_$c(2)_ICDDate_$c(2)_ICDTime_$c(2)_""
    s tmp=""
    s index=""
    f  s index=$o(^DHCWMRDiaSetting("DIA",index)) q:index=""  d
    .s tmpEleCode=$g(^DHCWMRDiaSetting("DIA",index))
    .q:tmpEleCode=""
    .s eleCode1=$p(tmpEleCode,"^",1)
    .s eleCode2=$p(tmpEleCode,"^",2)
    .s eleCode3=$p(tmpEleCode,"^",3)
    .s eleCode4=$p(tmpEleCode,"^",4)
    .s ICDDesc=..GetEPRElement(MrDiagnosVer,paadm, eleCode1,0)
    .s ICDDesc=$tr(ICDDesc,"/","")
    .s ICDDesc=$tr(ICDDesc,"&nbsp;"," ")
    .q:(ICDDesc="")!(ICDDesc="无")    ;先取诊断描述，如无诊断描述，退出
    .s ICDRowid=..GetEPRElement(MrDiagnosVer,paadm, eleCode2,1)
    .s ICDRowid=$tr(ICDRowid,"/","")  ;部分医院存的是ICDCode，部分医院是ICDRowid
    .i ICDRowid'="" d
    ..s tmpICD=$g(^MRC("ID",ICDRowid))
    ..i $p(tmpICD,"^",2)=ICDDesc d
    ...s ICDCode=$p(tmpICD,"^",4)
    ..e  d
    ...s ICDCode=""
    ...s:ICDDesc[$p(tmpICD,"^",2) ICDCode="*"_$p(tmpICD,"^",4)
    ...s:((+ICDRowid)=0)||(ICDRowid[".") ICDCode="*"_ICDRowid
    ...s ICDRowid=""
    .e  d
    ..s ICDRowid="",ICDCode=""
    .s ICDDR=ICDRowid_"/"_ICDCode_"/"_ICDDesc
    .s ICDTypeDesc=$p(eleCode1,"#TYPE:",1)
    .s ICDType=index_"/"_index_"/"_ICDTypeDesc
    .;是否确诊 或 怀疑诊断类型
    .s ResumeTest=..GetEPRElement(MrDiagnosVer,paadm, eleCode3,0)
    .;出院情况
    .s DischargeState=..GetEPRElement(MrDiagnosVer,paadm, eleCode4,0)
    .s $p(s,$c(2),5)=ICDDR
    .s $p(s,$c(2),7)=ICDType
    .s $p(s,$c(2),10)=ResumeTest
    .s $p(s,$c(2),11)=DischargeState
    .;w $tr(s,$c(2),"|"),!
    .s tmp=tmp_s_$c(1)
     
    q tmp
}

/// 根据设置取paadm的HIS诊断信息列表
ClassMethod GetMrDiagnose(paadm)
{
	n (paadm)
	s s=""
	q:paadm="" s
	s MrDiagnosVer=+$g(^DHCWMRDiaSetting("DIA"))
	i MrDiagnosVer=0 d
	.s s=##class(web.DHCWMRBasePaadm).GetMrDiagnose(paadm)
	e  d
	.s s=..GetEPRDiagnose(paadm,MrDiagnosVer)
	q s
}

/// 构造电子病历手术信息串
/// w ##class(web.DHCMedBaseDiagnose).GetEPROper(paadm, MrOperVer)
ClassMethod GetEPROper(paadm, MrOperVer)
{
	n (paadm,MrOperVer)
	s tmp=""
	s index=""
    f  s index=$o(^DHCWMROperSetting("OPER",index)) q:index=""  d
    .s tmpString=$g(^DHCWMROperSetting("OPER",index))
    .q:tmpString=""
    .s tmpRow=""
    .;如果手术名称为空,退出,手术名称为第二个字段
    .f fieldIndex=1:1:15 q:(fieldIndex=3)&&(tmpField="")  d
    ..s tmpEleExp=$p(tmpString,$c(2),fieldIndex)
    ..s tmpField=$$GetOPERField(paadm,tmpEleExp,MrOperVer)
    ..;s tmpRow=tmpRow_tmpField_$s(tmpRow="":"",1:$c(2))
    ..s tmpRow=tmpRow_tmpField_$c(2)
    .s tmpRow=$e(tmpRow,1,$l(tmpRow)-1)
    .q:(fieldIndex=3)&&(tmpField="")
    .q:tmpRow=""
    .q:tmpRow=$c(2)
    .//***********************************************
    .//手术Rowid,手术名称,手术编码
    .s OperRowid=$p(tmpRow,$c(2),1)
    .s OperCode=$p(tmpRow,$c(2),13)
    .s OperDesc=$p(tmpRow,$c(2),2)
    .i OperRowid'="" d
    ..s tmpOper=$g(^ORC("OPER",OperRowid))
    ..i $p(tmpOper,"^",2)=OperDesc d
    ...s OperCode=$p(tmpOper,"^",21)
    ...s:OperCode="" OperRowid=""
    ..e  d
    ...s OperCode="*"_$p(tmpOper,"^",21)
    ...s OperRowid=""
    .e  d
    ..s OperCode="*"_OperCode
    .s $p(tmpRow,$c(2),1)=OperRowid
    .s $p(tmpRow,$c(2),2)=OperDesc
    .s $p(tmpRow,$c(2),13)=OperCode
    .//手术日期
    .s OperDate=$p(tmpRow,$c(2),3)
    .s:OperDate'="" OperDate=$p(OperDate," ",1)
    .s:OperDate'="" OperDate=$zd($zdh(OperDate,3),3)
    .s $p(tmpRow,$c(2),3)=OperDate
    .//手术开始日期
    .s OperDate1=$p(tmpRow,$c(2),5)
    .s:OperDate1'="" OperDate1=$p(OperDate1," ",1)
    .s:OperDate1'="" OperDate1=$zd($zdh(OperDate1,3),3)
    .s $p(tmpRow,$c(2),5)=OperDate1
    .//术者
    .s OperDoc=$p(tmpRow,$c(2),9)
    .s OperDocCode=$$ALPHAUP^SSUTIL4($p(OperDoc,"/",2))
    .i OperDocCode'="" d
    ..s OperDocRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",OperDocCode,0))
    ..s:'$d(^SSU("SSUSR",OperDocRowid)) OperDocRowid=""
    ..s SSUser=$g(^SSU("SSUSR",+OperDocRowid))
    ..i $p(SSUser,"^",2)'=$p(OperDoc,"/",3) d
    ...s $p(OperDoc,"/",1)=""
    ...s $p(OperDoc,"/",2)=""
    ..e  d
    ...s $p(OperDoc,"/",1)=OperDocRowid
    .s $p(tmpRow,$c(2),9)=OperDoc
    .//麻醉医师
    .s AnaDoc=$p(tmpRow,$c(2),11)
    .s AnaDocCode=$$ALPHAUP^SSUTIL4($p(AnaDoc,"/",2))
    .i AnaDocCode'="" d
    ..s AnaDocRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",AnaDocCode,0))
    ..s:'$d(^SSU("SSUSR",AnaDocRowid)) AnaDocRowid=""
    ..s SSUser=$g(^SSU("SSUSR",+AnaDocRowid))
    ..i $p(SSUser,"^",2)'=$p(AnaDoc,"/",3) d
    ...s $p(AnaDoc,"/",1)=""
    ...s $p(AnaDoc,"/",2)=""
    ..e  d
    ...s $p(AnaDoc,"/",1)=AnaDocRowid
    .s $p(tmpRow,$c(2),11)=AnaDoc
    .//1助$C(3)2助
    .s AssDocs=$p(tmpRow,$c(2),12)
    .f Ind=1:1:$l(AssDocs,$c(3)) d
    ..s AssDoc=$p(AssDocs,$c(3),Ind)
    ..s AssDocCode=$$ALPHAUP^SSUTIL4($p(AssDoc,"/",2))
    ..i AssDocCode'="" d
    ...s AssDocRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",AssDocCode,0))
    ...s:'$d(^SSU("SSUSR",AssDocRowid)) AssDocRowid=""
    ...s SSUser=$g(^SSU("SSUSR",+AssDocRowid))
    ...i $p(SSUser,"^",2)'=$p(AssDoc,"/",3) d
    ....s $p(AssDoc,"/",1)=""
    ....s $p(AssDoc,"/",2)=""
    ...e  d
    ....s $p(AssDoc,"/",1)=AssDocRowid
    ..s $p(AssDocs,$c(3),Ind)=AssDoc
    .s $p(tmpRow,$c(2),12)=AssDocs
    .//切口愈合等级1
    .s CloseUp1=$p(tmpRow,$c(2),14)
    .s:CloseUp1["Ⅰ" CloseUp1="I"
    .s:CloseUp1["Ⅱ" CloseUp1="II"
    .s:CloseUp1["Ⅲ" CloseUp1="III"
    .s $p(tmpRow,$c(2),14)=CloseUp1
    .//***********************************************
    .s tmp=tmp_tmpRow_$s(tmpRow="":"",1:$c(1))
    q tmp
GetOPERField(paadm,tmpEleExp,MrOperVer)
    n (paadm,tmpEleExp,MrOperVer)
    s tmpField=""
    q:tmpEleExp="" tmpField
    s FieldLen=$l(tmpEleExp,$c(3))     ;一个字段多数据，如：助手列表
    f iField=1:1:FieldLen d
    .s MyField=$p(tmpEleExp,$c(3),iField)
    .s EleCode=$p(MyField,"/",1)
    .s eleTmpString=""
    .f EleIndex=2:1:$l(MyField,"/") d   ;一个字段多值，如：术者
    ..s IsCode=$p(MyField,"/",EleIndex)
    ..s tmpCode=..GetEPRElement(MrOperVer,paadm,EleCode,IsCode)
    ..;s tmpCode=$p($p(EleCode,"#",1),".",2)_"-"_paadm_"-"_IsCode
    ..;s eleTmpString=eleTmpString_tmpCode_$s(eleTmpString="":"",1:"/")
    ..s $p(eleTmpString,"/",EleIndex-1)=tmpCode
    .q:eleTmpString=""
    .q:eleTmpString="/"
    .;s tmpField=tmpField_eleTmpString_$c(3)
    .s $p(tmpField,$c(3),iField)=eleTmpString
    q tmpField
}

/// 根据设置取paadm的HIS手术信息列表
/// w ##Class(web.DHCMedBaseDiagnose).GetMrOper(17)
ClassMethod GetMrOper(paadm)
{
	n (paadm)
	s s=""
	q:paadm="" s
	s MrOperVer=+$g(^DHCWMROperSetting("OPER"))
	i MrOperVer=0 d
	.s s=##class(web.DHCMedBaseArcimCtl).GetOrdsOper(paadm)
	e  d
	.s s=..GetEPROper(paadm,MrOperVer)
	q s
}

}
