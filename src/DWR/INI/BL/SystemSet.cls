/// 初始化系统设置
Class DWR.INI.BL.SystemSet Extends %RegisteredObject
{

//  w ##Class(DWR.INI.BL.SystemSet).SetInitData()

/// 设置系统初始化数据
ClassMethod SetInitData()
{
	do ..SetThreeSTTime()			/// 设置三测单数据采集的时间点
	do ..SetThreeSTItem()			/// 设置三测单中的数据项目
	do ..SetOrdItemCode()			/// 设置护理级别和危重病情的医嘱项代码
	do ..SetOrdCatCodeHide()		/// 设置不显示医嘱的医嘱分类和医嘱子分类代码
	
	quit "ok"
}

/// 设置三测单数据采集的时间点
ClassMethod SetThreeSTTime()
{
	set ^DHCDWRSET("NUR","ThreeSTTime",1)="02:00"
	set ^DHCDWRSET("NUR","ThreeSTTime",2)="06:00"
	set ^DHCDWRSET("NUR","ThreeSTTime",3)="10:00"
	set ^DHCDWRSET("NUR","ThreeSTTime",4)="14:00"
	set ^DHCDWRSET("NUR","ThreeSTTime",5)="18:00"
	set ^DHCDWRSET("NUR","ThreeSTTime",6)="22:00"
	
	quit
}

/// 设置三测单中的数据项目
ClassMethod SetThreeSTItem()
{
	/// 设置项目代码
	set ^DHCDWRSET("NUR","ThreeSTItemCode",1)="体温"
	set ^DHCDWRSET("NUR","ThreeSTItemCode",2)="脉搏"
	set ^DHCDWRSET("NUR","ThreeSTItemCode",3)="呼吸"
	
	set ^DHCDWRSET("NUR","ThreeSTItemCode2",1)="收缩压/舒张压"
	set ^DHCDWRSET("NUR","ThreeSTItemCode2",2)="I"
	set ^DHCDWRSET("NUR","ThreeSTItemCode2",3)="O"
	set ^DHCDWRSET("NUR","ThreeSTItemCode2",4)="大便"
	set ^DHCDWRSET("NUR","ThreeSTItemCode2",5)="体重"
	set ^DHCDWRSET("NUR","ThreeSTItemCode2",6)="身高"
	
	/// 设置项目显示名称
	set ^DHCDWRSET("NUR","ThreeSTItem2",1)="血压(mmHg)"
	set ^DHCDWRSET("NUR","ThreeSTItem2",2)="入量(ml)"
	set ^DHCDWRSET("NUR","ThreeSTItem2",3)="出量(ml)"
	set ^DHCDWRSET("NUR","ThreeSTItem2",4)="大便(次/日)"
	set ^DHCDWRSET("NUR","ThreeSTItem2",5)="体重(kg)"
	set ^DHCDWRSET("NUR","ThreeSTItem2",6)="身高(cm)"
	
	quit
}

/// 设置护理级别和危重病情的医嘱项代码
ClassMethod SetOrdItemCode()
{
	/// 护理级别
	set ^DHCDWRSET("ORD","CareLevel",1)="HL0003"     // 一级护理
	set ^DHCDWRSET("ORD","CareLevel",2)="HL0004"     // 二级护理
	set ^DHCDWRSET("ORD","CareLevel",3)="HL0005"     // 三级护理
	set ^DHCDWRSET("ORD","CareLevel",4)="HL0006"     // 特级护理
	
	/// 病情危重
	set ^DHCDWRSET("ORD","Condition",1)="ZT0846"     // 病危
	set ^DHCDWRSET("ORD","Condition",2)="ZT0847"     // 病重
	
	quit
}

/// 设置不显示医嘱的医嘱分类和医嘱子分类代码
ClassMethod SetOrdCatCodeHide()
{
	/// 医嘱分类
	set ^DHCDWRSET("ORD","OrdCat","1")=""
	
	/// 医嘱子分类
	set ^DHCDWRSET("ORD","OrdSubCat","1")=""
	
	/// 设置不显示的检验项目的医嘱子分类代码
	set ^DHCDWRSET("ORD","LabOrdSubCat","ZT03")=""
	
	quit
}

}
