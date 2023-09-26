/// 名称:标准版检验-工作组（导入用）
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2019-11-6
Class web.BDPExt.BTWorkGroupBLL Extends %RegisteredObject
{

ClassMethod SaveEntity(Ceobj As web.BDPExt.BTWorkGroupEntity) As %String
{
	s ImportResult=""
	///默认值
	s eobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.LAB.BTWorkGroup")
	Ts			
	
	s SaveResult=##class(web.DHCBL.LAB.BTWorkGroup).SaveEntity(eobj)  
	s RowId=##class(web.BDPExt.FunLib).GetResultRowId(SaveResult)		
	if (RowId="")
	{
		s ImportResult="工作组："_SaveResult			
	}
	if (ImportResult="")
	{
		Tc
		s Result="{success:'true',id:'"_RowId_"'}" 
	}
	else
	{
		Tro
		s Result=ImportResult
	}
	q Result
}

}
