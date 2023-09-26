/// 科室货位导入类
/// Creator:陈莹 
/// CreatDate:2020-11-09
/// 基础数据平台组
Class web.BDPExt.INCStkBinBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹 
/// CreatDate:2020-11-09
/// Description:数据导入 之 科室货位导入(药品)
/// User.INCStkBin,User.DHCIncItmLocBin
/// Other:w ##class(web.BDPExt.INCStkBinBLL).SaveEntity(Ceobj)
ClassMethod SaveEntity(Ceobj As web.BDPExt.INCStkBinEntity) As %String
{
	n (Ceobj,%session)
	s ImportResult=""

	s listobj={
		"LinkHospId":(Ceobj.LinkHospId),
		"locDesc":(Ceobj.locDesc),
		"inciCode":(Ceobj.inciCode),
		"inciDesc":(Ceobj.inciDesc),
		"binDesc":(Ceobj.binDesc)
	}
	Tstart
	try
	{
		s ret=##class(PHA.TOOLS.Import.StkBin).Save(listobj)  //成功：0，失败：-1^错误信息
	
	}
	catch myvar
	{
		s ret="-1^"_$ze
	}
	if (ret'>0)
	{
		tro
		q "科室货位导入失败："_msg 
	}
	
	Tcommit
	s JsonStr="{""LinkHospId"":"""_Ceobj.LinkHospId_""",""locDesc"":"""_Ceobj.locDesc_""",""inciCode"":"""_Ceobj.inciCode_""",""inciDesc"":"""_Ceobj.inciDesc_""",""binDesc"":"""_Ceobj.binDesc_"""}"
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_IncItmLocBin","User.DHCIncItmLocBin","科室货位导入",ret,Ceobj.locDesc_"-"_Ceobj.inciCode_"-"_Ceobj.binDesc,"A",JsonStr)
	q "{success:'true',id:'"_ret_"'}"
}

}
