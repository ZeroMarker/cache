/// 名称: DHCWMR.MRCustom.ImportDataByJSSZY
/// 描述: 导入江苏省中医编目数据接口服务
/// 编写者：zhufei
/// 编写日期: 2015-09-17
Class DHCWMR.MRCustom.ImportDataByJSSZY Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-09-17
/// Description:  导入江苏省中医编目数据接口服务
/// Table：       
/// Input：       aInput ：编目记录="..."
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.MRCustom.ImportDataByJSSZY).Service()
ClassMethod Service(aInput As %String) As %String
{
	New (aInput)
	Set return=0
	Quit:(aInput="") return
	
	
	
	Quit return
}

}
