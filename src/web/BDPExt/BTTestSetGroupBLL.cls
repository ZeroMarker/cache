/// 名称:标准版检验-合管组合套分组及关联（导入用）
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2020-1-21
Class web.BDPExt.BTTestSetGroupBLL Extends %RegisteredObject
{

ClassMethod SaveEntity(Ceobj As web.BDPExt.BTTestSetGroupEntity) As %String
{
	s ImportResult=""
	///默认值
	s eobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.LAB.BTTestSetGroup")
	s leobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.LAB.BTTestSetGroupLinks")
	Ts			
	s TSGroupRowId=##class(web.DHCBL.LAB.BTTestSetGroup).GetRowIdByCode(Ceobj.Code)
	if (TSGroupRowId'="") 
	{
		s leobj.RowID=""
		s leobj.TestSetGroupDR=TSGroupRowId
		s LinkSaveResult=##class(web.DHCBL.LAB.BTTestSetGroupLinks).SaveEntity(leobj) 
		s LinkRowId=##class(web.BDPExt.FunLib).GetResultRowId(LinkSaveResult)
		if (LinkRowId="")
		{
			s ImportResult="组合套分组关联："_LinkSaveResult			
		}
	}
	if (TSGroupRowId="")
	{
		s eobj.RowID=""
		s SaveResult=##class(web.DHCBL.LAB.BTTestSetGroup).SaveEntity(eobj)  
		s RowId=##class(web.BDPExt.FunLib).GetResultRowId(SaveResult)		
		if (RowId="")
		{
			s ImportResult="合管组合套分组："_SaveResult			
		}
	}
	 
	
	
	
	if (ImportResult="")
	{
		Tc
		s Result="{success:'true',id:'"_LinkRowId_"'}" 
	}
	else
	{
		Tro
		s Result=ImportResult
	}
	q Result
}

}
