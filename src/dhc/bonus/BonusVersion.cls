/// 东华奖金核算系统版本号
Class dhc.bonus.BonusVersion Extends %SerialObject
{

// w ##class(dhc.bonus.BonusVersion).BonusVersion()

ClassMethod BonusVersion() As %String
{
	/*
	--------------版本说明-----------
	1、BonusVersion6.0以前版本：
	  变更日期：2012-6
	  主要修改者：赵立国
	  版本主要实现：
	  	1、奖金核算核心功能的完善；
	  	2、业务流程的控制及梳理；
	  	3、数据采集接口动态配置；
	  	4、增加了人员科室权限控制
	  	5、增加了人员指标权限控制。
	  	6、增加了RBRVS管理模块。
	  使用项目：积水潭医院、北京中医院、粤北医院等
	 
	2、BonusVersion7.0版本：
		升级日期：2013-8
		主要修改者：赵立国
	    版本主要变更：
	  		1、数据采集接口功能完善；
	  		2、奖金核算方案公式中，增加了自定义函数功能；
	  		3、优化了奖金核算的核心类dhc.bonus.udata.uBonusSchemeCalculate的计算方法。
	  		4、增加了自定义制作数据Excel数据导入模板功能。
	  		5、增加了自定义制作查询统计报表功能。
	  		6、增加了奖金核算结账功能。
	  		7、增加奖金核算发放功能。
		使用项目：烟台中医医院、东营二院、管道局医院、淮南朝阳医院、
		
	3、BonusVersion8.0版本：
	   升级日期：2015-5
	   主要修改者：赵立国
	   增加内容：
		   	1、科室收入管理模块；
		   	2、科室支出管理模块；
		   	3、单项奖管理模块；
		   	4、DRGS管理模块模块。
	   
	   使用项目：昆明二院
	  
	3、BonusVersion8.1版本：
	  升级日期：2015-11
	  主要修改者：赵立国
	  修改内容：
	  	主要是完善了下列模块功能
		  1、科室收入管理模块；
		  2、科室支出管理模块；
		  3、单项奖管理模块；
		  4、增加取正数、取整数函数。
		  5、优化了##class(dhc.bonus.udata.uBonusSchemeCalculate).GetBonusTargetRate的算法，改sql为M
		  
	   	
	  使用项目：弋矶山医院  
	  
	  4、BonusVersion8.1.4版本：
	  升级日期：2016-05
	  主要修改者：刘小伟
	  修改内容：
	  	主要是完善了下列模块功能
		  1、科室收入管理模块；
		  2、科室支出管理模块；
		  3、单项奖管理模块；
		  4、增加取正数、取整数函数。
		  5、优化了##class(dhc.bonus.udata.uBonusSchemeCalculate).GetBonusTargetRate的算法，改sql为M
		  
	   	
	  使用项目：弋矶山医院  

	
	*/
	
	
	q "东华奖金核算系统 Version 8.1.4"
}

Storage Default
{
<StreamLocation>^dhc.bonus.BonusVersionS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
