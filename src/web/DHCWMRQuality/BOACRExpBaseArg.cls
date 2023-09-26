Import SQLUser

/// *****************************************************
/// CLASS说明:质控取数据固定参数设置
/// *****************************************************
Class web.DHCWMRQuality.BOACRExpBaseArg Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 40;

/// ********************************************************************
/// 说明  ：设置与ACR相关的参数   TypeCode(红细胞输血医嘱项):"01001"
/// 调试  ：w ##Class(web.DHCWMRQuality.BOACRExpBaseArg).SetDHCWMRACRArg(TypeCode)
/// ********************************************************************
ClassMethod SetDHCWMRACRArg(TypeCode)
{
	n (TypeCode)
	s HospCode=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetHospCode()
	q:HospCode="" "Error!HospCode is null."
	k:TypeCode="" ^DHCWMRACRArg(HospCode)
	k:TypeCode'="" ^DHCWMRACRArg(HospCode,TypeCode)
	
	//**********************************************************
	//设置医嘱项和有效医嘱状态参数
	//10^I^未激活||4^D^停止||1^V^核实||6^E^执行
	//**********************************************************
	i (TypeCode="")||(TypeCode="01001"){
		set ^DHCWMRACRArg(HospCode,"01001")="红细胞输血医嘱项"
		set ^DHCWMRACRArg(HospCode,"01001","01",0)=""           //有效状态
		set ^DHCWMRACRArg(HospCode,"01001","01",1)="1^V^核实"
		set ^DHCWMRACRArg(HospCode,"01001","01",2)="6^E^执行"
		set ^DHCWMRACRArg(HospCode,"01001","02",0)=""           //医嘱项
	    set ^DHCWMRACRArg(HospCode,"01001","02",1)="10031||1^洗涤红细胞(1U)"
	    set ^DHCWMRACRArg(HospCode,"01001","02",2)="10033||1^手工分红细胞悬液(1u)"
	    set ^DHCWMRACRArg(HospCode,"01001","02",3)="10039||1^Rh(D)阴性红细胞悬液(1u)"
	    set ^DHCWMRACRArg(HospCode,"01001","02",4)="10040||1^手工分红细胞悬液(小包装)"
	}
	
	i (TypeCode="")||(TypeCode="01002"){
		set ^DHCWMRACRArg(HospCode,"01002")="血小板输血医嘱项"
		set ^DHCWMRACRArg(HospCode,"01002","01",0)=""           //有效状态
		set ^DHCWMRACRArg(HospCode,"01002","01",1)="1^V^核实"
		set ^DHCWMRACRArg(HospCode,"01002","01",2)="6^E^执行"
		set ^DHCWMRACRArg(HospCode,"01002","02",0)=""           //医嘱项
	    set ^DHCWMRACRArg(HospCode,"01002","02",1)="10036||1^机采血小板"
	    set ^DHCWMRACRArg(HospCode,"01002","02",2)="10041||1^手工分浓缩血小板(小包装)"
	}
	
	i (TypeCode="")||(TypeCode="01003"){
		set ^DHCWMRACRArg(HospCode,"01003")="血浆输血医嘱项"
		set ^DHCWMRACRArg(HospCode,"01003","01",0)=""           //有效状态
		set ^DHCWMRACRArg(HospCode,"01003","01",1)="1^V^核实"
		set ^DHCWMRACRArg(HospCode,"01003","01",2)="6^E^执行"
		set ^DHCWMRACRArg(HospCode,"01003","02",0)=""           //医嘱项
	    set ^DHCWMRACRArg(HospCode,"01003","02",1)="10034||1^手工分冰冻血浆(100ml)"
	    set ^DHCWMRACRArg(HospCode,"01003","02",2)="10035||1^手工分冰冻血浆(200ml)"
	}
	
	i (TypeCode="")||(TypeCode="01004"){
		set ^DHCWMRACRArg(HospCode,"01004")="全血输血医嘱项"
		set ^DHCWMRACRArg(HospCode,"01004","01",0)=""           //有效状态
		set ^DHCWMRACRArg(HospCode,"01004","01",1)="1^V^核实"
		set ^DHCWMRACRArg(HospCode,"01004","01",2)="6^E^执行"
		set ^DHCWMRACRArg(HospCode,"01004","02",0)=""           //医嘱项
	}
	
	i (TypeCode="")||(TypeCode="01005"){
		set ^DHCWMRACRArg(HospCode,"01005")="其它输血医嘱项"
		set ^DHCWMRACRArg(HospCode,"01005","01",0)=""           //有效状态
		set ^DHCWMRACRArg(HospCode,"01005","01",1)="1^V^核实"
		set ^DHCWMRACRArg(HospCode,"01005","01",2)="6^E^执行"
		set ^DHCWMRACRArg(HospCode,"01005","02",0)=""           //医嘱项
	}
	
	i (TypeCode="")||(TypeCode="01006"){
		set ^DHCWMRACRArg(HospCode,"01006")="抢救医嘱项"
		set ^DHCWMRACRArg(HospCode,"01006","01",0)=""           //有效状态
		set ^DHCWMRACRArg(HospCode,"01006","01",1)="1^V^核实"
		set ^DHCWMRACRArg(HospCode,"01006","01",2)="6^E^执行"
		set ^DHCWMRACRArg(HospCode,"01006","02",0)=""           //医嘱项
		set ^DHCWMRACRArg(HospCode,"01006","02",1)="10488||1^特需抢救费(大)多科"
		set ^DHCWMRACRArg(HospCode,"01006","02",2)="10489||1^特需抢救费(中)两科"
		set ^DHCWMRACRArg(HospCode,"01006","02",3)="10490||1^特需抢救费(小)"
		set ^DHCWMRACRArg(HospCode,"01006","02",4)="9118||1^大抢救"
		set ^DHCWMRACRArg(HospCode,"01006","02",5)="9119||1^小抢救"
		set ^DHCWMRACRArg(HospCode,"01006","02",6)="9120||1^中抢救"
	}
	
	i (TypeCode="")||(TypeCode="01007"){
		set ^DHCWMRACRArg(HospCode,"01007")="会诊医嘱项"
		set ^DHCWMRACRArg(HospCode,"01007","01",0)=""           //有效状态 
		set ^DHCWMRACRArg(HospCode,"01007","01",1)="1^V^核实"
		set ^DHCWMRACRArg(HospCode,"01007","01",2)="6^E^执行"
		set ^DHCWMRACRArg(HospCode,"01007","02",0)=""           //医嘱项
	    set ^DHCWMRACRArg(HospCode,"01007","02",1)="9166||1^院际会诊(正主任医师)"
	    set ^DHCWMRACRArg(HospCode,"01007","02",2)="9167||1^院际会诊(副主任医师)"
	    set ^DHCWMRACRArg(HospCode,"01007","02",3)="9168||1^院际会诊(主治医师)"
	    set ^DHCWMRACRArg(HospCode,"01007","02",4)="9171||1^院内产科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",5)="9172||1^院内妇科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",6)="9173||1^院内儿科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",7)="9174||1^院内内一科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",8)="9175||1^院内内二科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",9)="9176||1^院内中西医结合一科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",10)="9177||1^院内感染一科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",11)="9178||1^院内内三科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",12)="9179||1^院内内四科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",13)="9180||1^院内中西医结合二科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",14)="9181||1^院内感染二科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",15)="9182||1^院内综合一科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",16)="9183||1^院内综合二科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",17)="9184||1^院内肿瘤科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",18)="9185||1^院内内五科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",19)="9186||1^院内外一科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",20)="9187||1^院内外二科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",21)="9188||1^院内危重症外科部会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",22)="9189||1^院内危重症内科部会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",23)="9190||1^院内血液透析室会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",24)="9191||1^院内手麻科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",25)="9192||1^院内眼科门诊会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",26)="9193||1^院内口腔科门诊会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",27)="9194||1^院内耳鼻喉科门诊会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",28)="9195||1^院内放射介入科会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",29)="9196||1^院内内镜室会诊"
	    set ^DHCWMRACRArg(HospCode,"01007","02",30)="9197||1^院内营养科会诊"
	}
	
	i (TypeCode="")||(TypeCode="01008"){
		set ^DHCWMRACRArg(HospCode,"01008")="术后医嘱项"
		set ^DHCWMRACRArg(HospCode,"01008","01",0)=""           //有效状态 
		set ^DHCWMRACRArg(HospCode,"01008","01",1)="6^E^执行"
		set ^DHCWMRACRArg(HospCode,"01008","02",0)=""           //医嘱项
	}
	
	/*i (TypeCode="")||(TypeCode="01009"){
		set ^DHCWMRACRArg(HospCode,"01009")="转科医嘱项"
		set ^DHCWMRACRArg(HospCode,"01009","01",0)=""           //有效状态 
		set ^DHCWMRACRArg(HospCode,"01009","01",1)="6^E^执行"
		set ^DHCWMRACRArg(HospCode,"01009","02",0)=""           //医嘱项
	}*/
	
	i (TypeCode="")||(TypeCode="01010"){
		set ^DHCWMRACRArg(HospCode,"01010")="穿刺医嘱项"
		set ^DHCWMRACRArg(HospCode,"01010","01",0)=""           //有效状态 
		set ^DHCWMRACRArg(HospCode,"01010","01",1)="1^V^核实"
		set ^DHCWMRACRArg(HospCode,"01010","01",2)="6^E^执行"
		set ^DHCWMRACRArg(HospCode,"01010","02",0)=""           //医嘱项
	    set ^DHCWMRACRArg(HospCode,"01010","02",1)="9051||1^经皮穿刺下腔静脉滤过器置入"
	    set ^DHCWMRACRArg(HospCode,"01010","02",2)="9069||1^扁桃体周脓肿穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",3)="9076||1^动脉穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",4)="9081||1^腹腔穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",5)="9094||1^关节穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",6)="9100||1^环甲膜穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",7)="9101||1^后穹窿或盆腔内穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",8)="9110||1^留置针穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",9)="9112||1^膀胱穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",10)="9128||1^骨穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",11)="9132||1^锁骨下静脉穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",12)="9136||1^体内泵穿刺注射(经泵化疗栓塞抗凝治疗)"
	    set ^DHCWMRACRArg(HospCode,"01010","02",13)="9144||1^心包穿刺\抽液"
	    set ^DHCWMRACRArg(HospCode,"01010","02",14)="9147||1^胸腔穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",15)="9153||1^一般穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",16)="9154||1^腰椎穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",17)="9233||1^腰椎穿刺(椎管内注药加收)"
	    set ^DHCWMRACRArg(HospCode,"01010","02",18)="9236||1^乳腺穿刺(针另收)"
	    set ^DHCWMRACRArg(HospCode,"01010","02",19)="9237||1^经皮穿刺骶神经根囊肿注射治疗"
	    set ^DHCWMRACRArg(HospCode,"01010","02",20)="9274||1^鼓膜穿刺术"
	    set ^DHCWMRACRArg(HospCode,"01010","02",21)="9283||1^上颌窦穿刺冲洗术"
	    set ^DHCWMRACRArg(HospCode,"01010","02",22)="9382||1^脓肿穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",23)="9407||1^前列腺穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",24)="9437||1^经皮穿刺肝肿物射频消融治疗420"
	    set ^DHCWMRACRArg(HospCode,"01010","02",25)="9448||1^经皮穿刺肝肿物射频消融治疗1400"
	    set ^DHCWMRACRArg(HospCode,"01010","02",26)="9450||1^经皮肝穿刺门静脉插管术"
	    set ^DHCWMRACRArg(HospCode,"01010","02",27)="9455||1^经皮甲状腺穿刺(针另收)"
	    set ^DHCWMRACRArg(HospCode,"01010","02",28)="10533||1^特需动脉穿刺(材料费另收)"
	    set ^DHCWMRACRArg(HospCode,"01010","02",29)="10534||1^特需腹部穿刺(材料费另收)"
	    set ^DHCWMRACRArg(HospCode,"01010","02",30)="10535||1^特需骨穿刺(材料费另收)"
	    set ^DHCWMRACRArg(HospCode,"01010","02",31)="10536||1^特需腰椎穿刺(材料费另收)"
	    set ^DHCWMRACRArg(HospCode,"01010","02",32)="10537||1^特需留置针穿刺(材料费另收)"
	    set ^DHCWMRACRArg(HospCode,"01010","02",33)="10564||1^膀胱穿刺造瘘"
	    set ^DHCWMRACRArg(HospCode,"01010","02",34)="12378||1^前房穿刺"
	    set ^DHCWMRACRArg(HospCode,"01010","02",35)="12467||1^经乳突脑脓肿切开或穿刺引流术"
	    set ^DHCWMRACRArg(HospCode,"01010","02",36)="12593||1^肢体肿瘤病灶穿刺活检术"
	    set ^DHCWMRACRArg(HospCode,"01010","02",37)="12594||1^骨盆部位肿瘤病灶穿刺活检术"
	    set ^DHCWMRACRArg(HospCode,"01010","02",38)="12596||1^脊柱及骶骨肿瘤病灶穿刺活检术"
	}
	
	i (TypeCode="")||(TypeCode="01011"){
		set ^DHCWMRACRArg(HospCode,"01011")="输血医嘱项"
		set ^DHCWMRACRArg(HospCode,"01011","01",0)=""           //有效状态
		set ^DHCWMRACRArg(HospCode,"01011","01",1)="1^V^核实"
		set ^DHCWMRACRArg(HospCode,"01011","01",2)="6^E^执行"
		set ^DHCWMRACRArg(HospCode,"01011","02",0)=""           //医嘱项
	    set ^DHCWMRACRArg(HospCode,"01011","02",1)="10030||1^术中自体血液回输(国产机)"
	    set ^DHCWMRACRArg(HospCode,"01011","02",2)="10031||1^洗涤红细胞(1U)"
	    set ^DHCWMRACRArg(HospCode,"01011","02",3)="10033||1^手工分红细胞悬液(1u)"
	    set ^DHCWMRACRArg(HospCode,"01011","02",4)="10034||1^手工分冰冻血浆(100ml)"
	    set ^DHCWMRACRArg(HospCode,"01011","02",5)="10035||1^手工分冰冻血浆(200ml)"
	    set ^DHCWMRACRArg(HospCode,"01011","02",6)="10036||1^机采血小板"
	    set ^DHCWMRACRArg(HospCode,"01011","02",7)="10037||1^储血费"
	    set ^DHCWMRACRArg(HospCode,"01011","02",8)="10039||1^Rh(D)阴性红细胞悬液(1u)"
	    set ^DHCWMRACRArg(HospCode,"01011","02",9)="10040||1^手工分红细胞悬液(小包装)"
	    set ^DHCWMRACRArg(HospCode,"01011","02",10)="10041||1^手工分浓缩血小板(小包装)"
	}
	
	//**********************************************************
	//设置取病人血型方法参数
	//**********************************************************
	i (TypeCode="")||(TypeCode="02001"){
		set ^DHCWMRACRArg(HospCode,"02001")="取病人血型方法"
		set ^DHCWMRACRArg(HospCode,"02001",1)="##class(web.DHCBL.LIS.ReceiveReport).GetLisReportInfo(EpisodeID,""3573"")"
	}
	
	//**********************************************************
	//设置取死亡病人体温单(死亡)时间类型参数
	//**********************************************************
	i (TypeCode="")||(TypeCode="03001"){
		set ^DHCWMRACRArg(HospCode,"03001")="取死亡病人体温单死亡时间"
		set ^DHCWMRACRArg(HospCode,"03001",1)="死亡^体温单取死亡时间类型参数"
	}
	
	//**********************************************************
	//设置抗菌药物对应医嘱大类或子类参数,HIS系统中还没分类,暂时放一下
	//**********************************************************
	i (TypeCode="")||(TypeCode="04001"){
		set ^DHCWMRACRArg(HospCode,"04001")="抗菌药物对应医嘱大类或子类"
	}
	
	//**********************************************************
	//设置可重复模板"标题"参数
	//**********************************************************
	i (TypeCode="")||(TypeCode="05001"){
		set ^DHCWMRACRArg(HospCode,"05001")="日常病程记录"
	    set ^DHCWMRACRArg(HospCode,"05001",1)="主治医师查房记录"
	    set ^DHCWMRACRArg(HospCode,"05001",2)="讲师查房记录"
	    set ^DHCWMRACRArg(HospCode,"05001",3)="教授查房记录"
	    set ^DHCWMRACRArg(HospCode,"05001",4)="副教授查房记录"
	    set ^DHCWMRACRArg(HospCode,"05001",5)="主任查房记录"
	    set ^DHCWMRACRArg(HospCode,"05001",6)="副主任查房记录"
	    set ^DHCWMRACRArg(HospCode,"05001",7)="主任医师查房记录"
	    set ^DHCWMRACRArg(HospCode,"05001",8)="副主任医师查房记录"
	    set ^DHCWMRACRArg(HospCode,"05001",9)="住院总医师查房记录"
	    set ^DHCWMRACRArg(HospCode,"05001",10)="与患者家属谈话记录"
	    set ^DHCWMRACRArg(HospCode,"05001",11)="会诊记录"
	    set ^DHCWMRACRArg(HospCode,"05001",12)="交班记录"
	    set ^DHCWMRACRArg(HospCode,"05001",13)="接班记录"
	    set ^DHCWMRACRArg(HospCode,"05001",14)="转科记录"
	    set ^DHCWMRACRArg(HospCode,"05001",15)="接收记录"
	    set ^DHCWMRACRArg(HospCode,"05001",16)="抢救记录"
	    set ^DHCWMRACRArg(HospCode,"05001",17)="阶段小结"
	    set ^DHCWMRACRArg(HospCode,"05001",18)="术后记录"
	    set ^DHCWMRACRArg(HospCode,"05001",19)="死亡讨论记录"
	    set ^DHCWMRACRArg(HospCode,"05001",20)="疑难病历讨论记录"
		set ^DHCWMRACRArg(HospCode,"05001",21)="出院当日病程记录"
		set ^DHCWMRACRArg(HospCode,"05001",22)="输血记录"
		set ^DHCWMRACRArg(HospCode,"05001",23)="穿刺记录"
		set ^DHCWMRACRArg(HospCode,"05001",24)="病程记录"
		set ^DHCWMRACRArg(HospCode,"05001",25)="首次查房记录"
	}
	
	i (TypeCode="")||(TypeCode="05002"){
		set ^DHCWMRACRArg(HospCode,"05002")="上级医师查房记录"
	    set ^DHCWMRACRArg(HospCode,"05002",1)="主治医师查房记录"
	    set ^DHCWMRACRArg(HospCode,"05002",2)="讲师查房记录"
	    set ^DHCWMRACRArg(HospCode,"05002",3)="教授查房记录"
	    set ^DHCWMRACRArg(HospCode,"05002",4)="副教授查房记录"
	    set ^DHCWMRACRArg(HospCode,"05002",5)="主任查房记录"
	    set ^DHCWMRACRArg(HospCode,"05002",6)="副主任查房记录"
	    set ^DHCWMRACRArg(HospCode,"05002",7)="主任医师查房记录"
	    set ^DHCWMRACRArg(HospCode,"05002",8)="副主任医师查房记录"
	    set ^DHCWMRACRArg(HospCode,"05002",9)="住院总医师查房记录"
	}
	
	i (TypeCode="")||(TypeCode="05003"){
		set ^DHCWMRACRArg(HospCode,"05003")="交班记录"
		set ^DHCWMRACRArg(HospCode,"05003",1)="交班记录"
	}
	
	i (TypeCode="")||(TypeCode="05004"){
		set ^DHCWMRACRArg(HospCode,"05004")="接班记录"
		set ^DHCWMRACRArg(HospCode,"05004",1)="接班记录"
	}
	
	i (TypeCode="")||(TypeCode="05005"){
		set ^DHCWMRACRArg(HospCode,"05005")="转科记录"
		set ^DHCWMRACRArg(HospCode,"05005",1)="转科记录"
	}
	
	i (TypeCode="")||(TypeCode="05006"){
		set ^DHCWMRACRArg(HospCode,"05006")="接收记录"
		set ^DHCWMRACRArg(HospCode,"05006",1)="接收记录"
	}
	
	i (TypeCode="")||(TypeCode="05007"){
		set ^DHCWMRACRArg(HospCode,"05007")="阶段小结"
		set ^DHCWMRACRArg(HospCode,"05007",1)="阶段小结"
	}
	
	i (TypeCode="")||(TypeCode="05008"){
		set ^DHCWMRACRArg(HospCode,"05008")="主任医师查房"
	    set ^DHCWMRACRArg(HospCode,"05008",1)="主任查房记录"
	    set ^DHCWMRACRArg(HospCode,"05008",2)="副主任查房记录"
	    set ^DHCWMRACRArg(HospCode,"05008",3)="主任医师查房记录"
	    set ^DHCWMRACRArg(HospCode,"05008",4)="副主任医师查房记录"
	    set ^DHCWMRACRArg(HospCode,"05008",5)="住院总医师查房记录"
	}
	
	i (TypeCode="")||(TypeCode="05009"){
		set ^DHCWMRACRArg(HospCode,"05009")="抢救记录"
		set ^DHCWMRACRArg(HospCode,"05009",1)="抢救记录"
	}
	
	i (TypeCode="")||(TypeCode="05010"){
		set ^DHCWMRACRArg(HospCode,"05010")="请会诊记录"
		set ^DHCWMRACRArg(HospCode,"05010",1)="请会诊记录"
	}
	
	i (TypeCode="")||(TypeCode="05011"){
		set ^DHCWMRACRArg(HospCode,"05011")="会诊记录"
		set ^DHCWMRACRArg(HospCode,"05011",1)="会诊记录"
	}
	
	i (TypeCode="")||(TypeCode="05012"){
		set ^DHCWMRACRArg(HospCode,"05012")="输血记录"
		set ^DHCWMRACRArg(HospCode,"05012",1)="输血记录"
	}
	
	i (TypeCode="")||(TypeCode="05013"){
		set ^DHCWMRACRArg(HospCode,"05013")="穿刺记录"
		set ^DHCWMRACRArg(HospCode,"05013",1)="穿刺记录"
	}
	
	i (TypeCode="")||(TypeCode="05014"){
		set ^DHCWMRACRArg(HospCode,"05014")="出院当日病程记录"
		set ^DHCWMRACRArg(HospCode,"05014",1)="出院当日病程记录"
	}
	
	i (TypeCode="")||(TypeCode="05015"){
		set ^DHCWMRACRArg(HospCode,"05015")="死亡讨论记录"
		set ^DHCWMRACRArg(HospCode,"05015",1)="死亡讨论记录"
	}
	
	i (TypeCode="")||(TypeCode="05016"){
		set ^DHCWMRACRArg(HospCode,"05016")="术后记录"
		set ^DHCWMRACRArg(HospCode,"05016",1)="术后记录"
	}
	
	//**********************************************************
	//add by zf 20090526  测试用参数设置
	i (TypeCode="99999"){
		set ^DHCWMRACRArg(HospCode,"99999")="日常病程记录"
		set ^DHCWMRACRArg(HospCode,"99999",1)="日常病程记录"
	}
	
	i (TypeCode="88888"){
		set ^DHCWMRACRArg(HospCode,"88888")="测试医嘱"
		set ^DHCWMRACRArg(HospCode,"88888","01",0)=""           //有效状态
		set ^DHCWMRACRArg(HospCode,"88888","01",2)="1^V^核实"
		set ^DHCWMRACRArg(HospCode,"88888","02",0)=""           //医嘱项
	    set ^DHCWMRACRArg(HospCode,"88888","02",1)="282||1^洗涤红细胞(u)^血库输血"
	    set ^DHCWMRACRArg(HospCode,"88888","02",2)="3458||1^红细胞悬液(u)^血库输血"
	    set ^DHCWMRACRArg(HospCode,"88888","02",3)="6056||1^Rh(-)红细胞(ml)^血库输血"
	    set ^DHCWMRACRArg(HospCode,"88888","02",4)="7268||1^压积红细胞(u)^血库输血"
	    set ^DHCWMRACRArg(HospCode,"88888","02",5)="7533||1^去白细胞红细胞悬液(u)^血库输血"
	    set ^DHCWMRACRArg(HospCode,"88888","02",6)="6061||1^辐照红细胞悬液(u)^血库输血"
	}
	//**********************************************************
	
	q 1
}

///                           ********************************取电子病历数据***********************************
///                           手术记录单发生日期时间LIST    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatNormName,"","","","","")
///                           手术记录单数    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatNormName,"","","","","")
///                           日常病程记录发生日期LIST    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDate(EpisodeID,CatNormName,"","","","","05001")
///                           上级医师首次查房记录日期时间LIST    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatNormName,"","","","","05002")
///                           交班记录日期时间LIST    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatNormName,"","","","","05003")
///                           接班记录日期时间LIST    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatNormName,"","","","","05004")
///                           交班记录数    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatNormName,"","","","","05003")
///                           接班记录数    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatNormName,"","","","","05004")
///                           转科记录日期时间LIST    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatNormName,"","","","","05005")
///                           接收记录日期时间LIST    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatNormName,"","","","","05006")
///                           转科记录数    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatNormName,"","","","","05005")
///                           接收记录数    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatNormName,"","","","","05006")
///                           阶段小结日期时间LIST    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDate(EpisodeID,CatNormName,"","","","","05007")
///                           主任医师查房日期时间LIST    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDate(EpisodeID,CatNormName,"","","","","05008")
///                           抢救记录日期时间LIST    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatNormName,"","","","","05009")
///                           抢救记录数    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatNormName,"","","","","05009")
///                           请会诊记录日期时间LIST    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatNormName,"","","","","05010")
///                           会诊记录日期时间LIST    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatNormName,"","","","","05011")
///                           请会诊记录数    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatNormName,"","","","","05010")
///                           会诊记录数    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatNormName,"","","","","05011")
///                           输血记录数    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatNormName,"","","","","05012")
///                           穿刺记录数    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatNormName,"","","","","05013")
///                           出院当日记录日期时间LIST    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatNormName,"","","","","05014")
///                           死亡讨论记录数    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatNormName,"","","","","05015")
///                           术后记录日期时间LIST    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatNormName,"","","","","05016")
///                           抢救记录医师意见LIST    ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemElData(EpisodeID,CatNormName,ElNormName,"","","","","05009")
///                           
///                           ********************************取HIS系统数据***********************************
///                           是否危重患者    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).IsApogeeInPat(EpisodeID)
///                           取患者红细胞输血量    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetRBCTransfuse(EpisodeID)
///                           取患者血小板输血量    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetPlateletTransfuse(EpisodeID)
///                           取患者血浆输血量    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetPlasmaTransfuse(EpisodeID)
///                           取患者全血输血量    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetWholeBloodTransfuse(EpisodeID)
///                           取患者其它输血量    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOtherTransfuse(EpisodeID)
///                           取患者抢救次数    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetSaveTimes(EpisodeID)
///                           取患者输血医嘱次数    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetTransfuseTimes(EpisodeID)
///                           取患者穿刺医嘱次数    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetPunctureTimes(EpisodeID)
///                           取患者血型    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetBloodGroup(EpisodeID)
///                           判断就诊号是否最后一次就诊    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).IsLastAdm(EpisodeID,AdmType)
///                           清除字符串非法字符(清除字符串“A /B无”)   ##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(Val, CharSTR)
///                           计算时间差(精确到小时,"2009-05-24 10:10:10")    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(DateTime1,DateTime2)
///                           统一转换成时间格式("2009-05-01 10:10:10")    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).ChangeDateTime(DateTime)
///                           查询特定医嘱输血量    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOeordItemAmount(EpisodeID,TypeCode)
///                           查询医嘱数量    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOeordItemCount(EpisodeID,TypeCode)
///                           查询特定医嘱日期时间LIST    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOeordDateTime(EpisodeID,TypeCode)
///                           取患者死亡时间    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDeathDateTime(EpisodeID)
///                           取患者入院时间    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetRegDateTime(EpisodeID)
///                           取患者出院时间(医疗结算时间)    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischDateTime1(EpisodeID)
///                           取患者出院时间(最终结算时间)    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischDateTime2(EpisodeID)
///                           取患者出院时间    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischDateTime(EpisodeID)
///                           取病人已入院时间(单位:小时)    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetRegHour(EpisodeID)
///                           取病人入院和出院时间    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetInPatDateTime(EpisodeID)
///                           取病人已出院时间(单位:小时)    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischHour(EpisodeID)
///                           取患者转科次数    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetTransLocCount(EpisodeID)
///                           婚姻状态 返回代码描述    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetMaritalStatus(EpisodeID)
///                           是否已婚    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).IsMaritalStatus(EpisodeID)
///                           性别 返回代码描述    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetSex(EpisodeID)
///                           出生日期    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetBirthday(EpisodeID)
///                           年龄(单位:岁)    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetAge(EpisodeID)
///                           取当前医院代码    ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetHospCode()
///                           
///                           ********************************ACR检查方法***********************************
///                           说明: 病案首页{联系人姓名:患者家属等}与病案首页{关系:患者与联系人关系}一致性检查
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0001(EpisodeID,Element1,Element2,TemplateID)
///                           说明: 病案首页{数字单元:输血量,抢救次数,成功次数等}是否为数字
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0002(EpisodeID,Element,TemplateID)
///                           说明: 病案首页{模板单元:姓名等}不允许有空格
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0003(EpisodeID,Element,TemplateID)
///                           说明: 病案首页{婚姻状况}与病案首页{年龄}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0004(EpisodeID,Element1,Element2,TemplateID)
///                           说明: 病案首页{邮编} "邮编","无","不详"不允许共存
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0005(EpisodeID,Element,TemplateID)
///                           说明: 病案首页{日期单元:确诊日期,手术日期等}不允许超出入出院时间
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0006(EpisodeID,Element,TemplateID)
///                           说明: 病案首页{诊断单元:主要诊断,次要诊断,院感诊断等}与病案首页{疾病转归}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0007(EpisodeID,Element1,Element2,TemplateID)
///                           说明: 病案首页{疾病转归}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0008(EpisodeID,Element,TemplateID)
///                           说明: 病案首页{抢救次数}与病案首页{成功次数}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0009(EpisodeID,Element1,Element2,TemplateID)
///                           说明: 病案首页{符合情况:术前与术后,临床与病理等}与病案首页{疾病手术:手术名称1,病理诊断}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0010(EpisodeID,Element1,Element2,TemplateID)
///                           说明: 病案首页{疾病转归:主诊断疾病转归}与病案首页{尸检:尸检}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0011(EpisodeID,Element1,Element2,TemplateID)
///                           说明: 病案首页{是否随诊}与病案首页{随诊期限}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0012(EpisodeID,Element1,Element2,TemplateID)
///                           说明: 病案首页{手术信息S:手术名称1,手术日期,术者,1助等}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0013(EpisodeID,Element,TemplateID)
///                           说明: 患者未出院,不允许打印{病历内容:病案首页,出院记录,死亡记录等}
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0014(EpisodeID,Content,TemplateID)
///                           说明: 病案首页{死亡时间}与HIS{死亡时间}不一致
///                               : 死亡记录{死亡时间}与HIS{死亡时间}不一致
///                               : 24小时入院死亡记录{死亡时间}与HIS{死亡时间}不一致
///                           注释: 两时间格式"2009-05-23 16:02:00",精确到小时,两时间相同
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0015(EpisodeID,Element,TemplateID)
///                           说明: 病案首页{是否转科}与{转科科别}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0016(EpisodeID,Element1,Element2,TemplateID)
///                           说明: 病案首页{是否院内感染}与{感染诊断}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0017(EpisodeID,Element1,Element2,TemplateID)
///                           说明: 病案首页{血型}与HIS{血型}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0018(EpisodeID,Element,TemplateID)
///                           说明: 病案首页{抢救次数}与HIS{抢救次数}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0019(EpisodeID,Element,TemplateID)
///                           说明: 病案首页{红细胞输血量}与HIS{红细胞输血量}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0020(EpisodeID,Element,TemplateID)
///                           说明: 病案首页{血小板输血量}与HIS{血小板输血量}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0021(EpisodeID,Element,TemplateID)
///                           说明: 病案首页{血浆输血量}与HIS{血浆输血量}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0022(EpisodeID,Element,TemplateID)
///                           说明: 病案首页{全血输血量}与HIS{全血输血量}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0023(EpisodeID,Element,TemplateID)
///                           说明: 病案首页{其它输血量}与HIS{其它输血量}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0024(EpisodeID,Element,TemplateID)
///                           说明: 病案首页{是否法定传染病}与病案首页{传染病是否上报}不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0025(EpisodeID,Element1,Element2,TemplateID)
///                           说明: 病案首页{入院诊断}与{修正诊断}不一致
///                               : 入院诊断中有“待诊”，“待查”，“？”、修正诊断内容不能为空
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0026(EpisodeID,Element1,Element2,TemplateID)
///                           说明: 病案首页{修正诊断}与{修正诊断签名}不一致
///                               : 修正诊断非空修正诊断签名不能为空
///                               : 病案首页{修正诊断}与{修正诊断日期}不一致
///                               : 修正诊断非空修正诊断日期不能为空
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0027(EpisodeID,Element1,Element2,TemplateID)
///                           说明: 抢救记录{日期时间LIST}与HIS{死亡时间}
///                               : 死亡病人抢救记录未在抢救结束(死亡时间)后4小时内完成;
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0028(EpisodeID,CatName,TemplateID)
///                           说明: 交班记录后24小时内未完成接班记录
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0029(EpisodeID,CatName,TemplateID)
///                           说明: 转科记录后24小时内未完成接收记录
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0030(EpisodeID,CatName,TemplateID)
///                           说明: 请会诊记录后24小时未完成会诊记录
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0031(EpisodeID,CatName,TemplateID)
///                           说明: 缺少每天至少一次的病程记录
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0032(EpisodeID,CatName,TemplateID)
///                           说明: 入院48小时内无上级医师首次查房记录
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0033(EpisodeID,CatName,TemplateID)
///                           说明: 住院超过一月无阶段小结(2天宽限)
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0034(EpisodeID,CatName,TemplateID)
///                           说明: 危重症患者必须要有上级医师查房记录
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0035(EpisodeID,CatName,TemplateID)
///                           说明: 抢救记录无上级医师意见及参加抢救的医务人员姓名及专业技术职务
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0036(EpisodeID,CatName,TemplateID,InstanceID)
///                           说明: 死亡病人必须写死亡讨论记录
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0037(EpisodeID,CatName,TemplateID)
///                           说明: 交班病人接班记录数与接班记录数不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0038(EpisodeID,CatName,TemplateID)
///                           说明: 转科病人转科记录数与接收记录数不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0039(EpisodeID,CatName,TemplateID)
///                           说明: 会诊病人请会诊记录数与会诊记录数不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0040(EpisodeID,CatName,TemplateID)
///                           说明: 转科病人无转科记录;转科表转科次数<>转科记录次数
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0041(EpisodeID,CatName,TemplateID)
///                           说明: 抢救病人无抢救记录;抢救医嘱数<>抢救记录次数
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0042(EpisodeID,CatName,TemplateID)
///                           说明: 输血病人无输血记录;输血医嘱数<>输血记录次数
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0043(EpisodeID,CatName,TemplateID)
///                           说明: 穿刺病人无穿刺记录;穿刺医嘱数<>穿刺记录次数
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0044(EpisodeID,CatName,TemplateID)
///                           说明: 国籍与住家地址填写不一致
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0045(EpisodeID,Element1,Element2,TemplateID)
///                           说明: 住址医师进修医师实习医师研究生实习医师不能同时为空
///                           调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0046(EpisodeID,Element,TemplateID)

}
