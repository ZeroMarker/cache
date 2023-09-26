/// 名称:科室/部门/病区-科室多层分类（导入用）
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2020-4-10
Class web.BDPExt.BDPCTLOCCategoryBLL Extends %RegisteredObject
{

/// Creator：钟荣枫
/// CreatDate: 2020-4-10
/// Description：保存修科室多层分类的内容
/// Table：User.BDPCTLOCCategory
/// Input：web.BDPExt.BDPCTLOCCategoryEntity 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.BDPExt.BDPCTLOCCategoryBLL).SaveEntity()
ClassMethod SaveEntity(Ceobj As web.BDPExt.BDPCTLOCCategoryEntity) As %String
{
	s ImportResult=""
	s eobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.BDPCTLOCCategory")
	Ts	
	if (Ceobj.ParentCatDr'="")	//父菜单不为空
	{
		s eobj.ParentCatDr=$o(^User.BDPCTLOCCategoryI("UniqueCodeIndex"," "_$ZCONVERT(Ceobj.ParentCatDr,"U"),0))
	}		
	s SaveResult=##class(web.DHCBL.CT.BDPCTLOCCategory).SaveEntity(eobj)  
	s ID=##class(web.BDPExt.FunLib).GetResultRowId(SaveResult)		
	if (ID="")	//保存失败
	{
		s ImportResult="科室多层分类："_SaveResult			
	}
	if (ImportResult="")	//无报错
	{
		Tc
		s Result="{success:'true',id:'"_ID_"'}" 
	}
	else		//保存报错
	{
		Tro
		s Result=ImportResult
	}
	q Result
}

}
