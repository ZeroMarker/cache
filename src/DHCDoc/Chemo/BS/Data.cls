/// CTOR: QP
/// DATE: 2020-07-13
/// DESC: 化疗本地化参数
Class DHCDoc.Chemo.BS.Data Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-07-13
/// DESC: 初始化本地化参数
/// NOTE: ^CF.DOC.Chemo.Local("BD","YJKLoc",InHosp)
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Data).Init()
ClassMethod Init()
{
	//初始化标志
	s ^CF.DOC.Chemo.Local("Init")="1"
	
	//1、本地化配置
	//审核科室(科室审核)
	s ^CF.DOC.Chemo.Local("BD","AuditLoc")="9,100,112"
	
	//审核医生(科室审核)
	s ^CF.DOC.Chemo.Local("BD","AuditDoc")="12215,12239,12240"
	
	//药剂科8 
	s ^CF.DOC.Chemo.Local("BD","YJKLoc")="19,38,68,156"
	s ^CF.DOC.Chemo.Local("BD","YJKLoc",2)="19,38,68"
	s ^CF.DOC.Chemo.Local("BD","YJKLoc",3)="19,38,68,156"
	
	//药剂科有审核权限的医生UserID
	s ^CF.DOC.Chemo.Local("BD","YJKDoc")="12211,12212,12224,12225,12226,12227,12228,12229,12253"
	s ^CF.DOC.Chemo.Local("BD","YJKDoc",2)="12211,12212,12224,12225,12226,12227,12228,12229,12253"
	s ^CF.DOC.Chemo.Local("BD","YJKDoc",3)="12211,12212,12224,12225,12226,12227,12228,12229,12253"
	
	//PRN普通 医嘱套ID(ARC_OrdSets)
	s ^CF.DOC.Chemo.Local("BD","PRNCOM-ARCOS")="6"
	//PRN过敏 医嘱套ID(ARC_OrdSets)
	s ^CF.DOC.Chemo.Local("BD","PRNGM-ARCOS")="10"
	//化疗前药 医嘱套ID(ARC_OrdSets)
	s ^CF.DOC.Chemo.Local("BD","PRE-ARCOS")="4"
	//化疗后医嘱 医嘱套ID(ARC_OrdSets)
	s ^CF.DOC.Chemo.Local("BD","POST-ARCOS")="12"
	//其他医嘱 医嘱套ID(ARC_OrdSets)
	s ^CF.DOC.Chemo.Local("BD","OTHER-ARCOS")="12"
	//PRN医嘱 医嘱套ID(ARC_OrdSets)
	s ^CF.DOC.Chemo.Local("BD","PRNS-ARCOS")="12"
	//出院带药医嘱 医嘱套ID(ARC_OrdSets)
	s ^CF.DOC.Chemo.Local("BD","OUT-ARCOS")="12"
	
	//频次
	s ^CF.DOC.Chemo.Local("BD","Freq-Once")="14"
	s ^CF.DOC.Chemo.Local("BD","Freq-Qd")="18"
	s ^CF.DOC.Chemo.Local("BD","Prior-Long")="5"
	s ^CF.DOC.Chemo.Local("BD","Prior-Short")="3"
	
	//2、系统配置
	//化疗方案审核消息提示代码
	//化疗方案科室审核
	s ^CF.DOC.Chemo.Local("OS","AppAudit")="1191"
	//化疗方案药剂科审核
	s ^CF.DOC.Chemo.Local("OS","Audit")="1192"
	//化疗方案审核结果
	s ^CF.DOC.Chemo.Local("OS","AuditResult")="1193"
	
	//3、页面数据
	//化疗拒绝原因
	s ^CF.DOC.Chemo.Local("PAGE","ChemoRefuse",1)="方案不符合要求（剂量、频次、天数、用法不正确）"
	s ^CF.DOC.Chemo.Local("PAGE","ChemoRefuse",2)="与适应症不符"
	s ^CF.DOC.Chemo.Local("PAGE","ChemoRefuse",3)="有明显的禁忌症"
	s ^CF.DOC.Chemo.Local("PAGE","ChemoRefuse",4)="达到累积剂量（终身剂量）"
	s ^CF.DOC.Chemo.Local("PAGE","ChemoRefuse",5)="无病理结果"
	s ^CF.DOC.Chemo.Local("PAGE","ChemoRefuse",6)="其他（人工填写）"
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-07-13
/// DESC: 初始化本地化参数
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Data).DoInit()
ClassMethod DoInit()
{
	i '$d(^CF.DOC.Chemo.Local("Init")) {
		d ..Init()
	} else {
		d ..Init()
	}
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-07-20
/// DESC: 获取本地化参数
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Data).GetData("BD","PRN-ARCOS")
ClassMethod GetData(Type, Code, InHosp = "")
{
	Q:(Type="")||(Code="") ""
	Q:'$d(^CF.DOC.Chemo.Local(Type,Code)) ""
	i InHosp="" {
		Q $g(^CF.DOC.Chemo.Local(Type,Code))
	} else {
		Q $g(^CF.DOC.Chemo.Local(Type,Code,InHosp))
	}
}

}
