/// 名称:标准版检验-检验项目（导入用）
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-03-15
Class web.BDPExt.BTTestCodeBLL Extends %RegisteredObject
{

// ？

ClassMethod SaveEntity(Ceobj As web.BDPExt.BTTestCodeEntity) As %String
{
	s ImportResult=""
	///默认值
	s eobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.LAB.BTTestCode")
	Ts
	
	s SaveResult=##class(web.DHCBL.LAB.BTTestCode).SaveEntity(eobj)  
	s RowId=##class(web.BDPExt.FunLib).GetResultRowId(SaveResult)		
	if (RowId="")
	{
		s ImportResult="检验项目："_SaveResult			
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
