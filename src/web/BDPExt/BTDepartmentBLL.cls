/// 名称:标准版检验-检验科室（导入用）
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2020-1-21
Class web.BDPExt.BTDepartmentBLL Extends %RegisteredObject
{

ClassMethod SaveEntity(Ceobj As web.BDPExt.BTDepartmentEntity) As %String
{
	s ImportResult=""
	///默认值
	s eobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.LAB.BTDepartment")
	Ts			
	
	s SaveResult=##class(web.DHCBL.LAB.BTDepartment).SaveEntity(eobj)  
	s RowId=##class(web.BDPExt.FunLib).GetResultRowId(SaveResult)		
	if (RowId="")
	{
		s ImportResult="检验科室："_SaveResult			
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
