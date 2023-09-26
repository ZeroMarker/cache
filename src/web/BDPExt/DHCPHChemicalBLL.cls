/// 名称:化学通用名导入方法
/// 编写者基础数据平台组-陈莹 
/// 编写日期: 2018-11-25 update2020-02-11
Class web.BDPExt.DHCPHChemicalBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹 
/// CreatDate: 2018-11-25
/// Description:数据导入 之 化学通用名
/// Table:DHC_PHChemical,PHC_Generic,DHC_PhcGeneric
/// Other:d ##class(web.BDPExt.DHCPHChemicalBLL).SaveEntity(Ceobj)
ClassMethod SaveEntity(Ceobj As web.BDPExt.DHCPHChemicalEntity) As %String
{
	n (Ceobj,%session)
	s ImportResult=""
	s:Ceobj.PHCGEDateFrom'="" Ceobj.PHCGEDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Ceobj.PHCGEDateFrom)
	s:Ceobj.PHCGEDateTo'="" Ceobj.PHCGEDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Ceobj.PHCGEDateTo)
		
	///字段名和值之间用上箭头"^" 拼接，然后它们之间再用"|"拼接。
	s liststr="PHCCCode^"_Ceobj.PHCCCode_"|PHCCDesc^"_Ceobj.PHCCDesc_"|PHCMCode^"_Ceobj.PHCMCode_"|PHCMDesc^"_Ceobj.PHCMDesc_"|PHCGECode^"_Ceobj.PHCGECode_"|PHCGEName^"_Ceobj.PHCGEName_"|DataAlias^"_Ceobj.DataAlias_"|PHCGEPHCFDr^"_Ceobj.PHCGEPHCFDr_"|PHCGEDateFrom^"_Ceobj.PHCGEDateFrom_"|PHCGEDateTo^"_Ceobj.PHCGEDateTo
	//s ^tmpcy("web.BDPExt.DHCPHChemicalBLL")=liststr
	Tstart
	///成功:药学分类Id^化学通用名Id^处方通用名Id   失败：$p(ret,"^",1)<0:失败,$p(ret,"^",2):失败信息
	///s ret= ##class(web.DHCST.Tools.InputDrugBasicLevelData).SaveChemGene(liststr)  //>0 - rowid,<0 - 失败
	s ret=##class(PHA.TOOLS.Import.PHCGeneric).Save(liststr)  //2020-01-07 调用药品组新接口
	s flag=$p(ret,"^",1)
	if (flag<0)
	{
		tro
		s msg=$p(ret,"^",2)
		q "保存失败:"_msg 
	}
	else
	{
		Tcommit
		s phccatid=$p(ret,"^",1)
		s chemid=$p(ret,"^",2)
		s phcgeid=$p(ret,"^",3)
		
		//保存处方通用名别名 2019-02-16
		if (Ceobj.DataAlias'="")
		{
			s aliasLen=$l(Ceobj.DataAlias,"/")
			for i=1:1:aliasLen
			{
				d ##class(web.DHCBL.BDP.BDPAlias).Insert("PHC_Generic",$p(Ceobj.DataAlias,"/",i),phcgeid)
			}
		}
		
		s JsonStr="{""PHCMCode"":"""_Ceobj.PHCMCode_""",""PHCMDesc"":"""_Ceobj.PHCMDesc_""",""PHCMPHCCDr"":"""_phccatid_"""}"     
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHChemical","User.DHCPHChemical","化学通用名",chemid,Ceobj.PHCMDesc,"A",JsonStr)
		s JsonStr="{""PHCGECode"":"""_Ceobj.PHCGECode_""",""PHCGEName"":"""_Ceobj.PHCGEName_"""}"     
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHC_Generic","User.PHCGeneric","药品处方通用名",phcgeid,Ceobj.PHCGEName,"A",JsonStr)
		s JsonStr="{""PHCGEPHCGEDR"":"""_phcgeid_""",""PHCGEPHCMDr"":"""_chemid_""",""PHCGEPHCFDr"":"""_Ceobj.PHCGEPHCFDr_"""}"     
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PhcGeneric","User.DHCPhcGeneric","通用名对照表",phcgeid,Ceobj.PHCMDesc_"-"_Ceobj.PHCGEName,"A",JsonStr)	
		q "{success:'true',id:'"_chemid_"'}"
	}
}

}
