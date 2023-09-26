Class DHCEPRFS.BL.BLItemCorrelation Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:		获取指定归档项目关联的归档项目ID，
/// 			比如入院记录签字扫描项目 关联 入院记录通用、入院记录儿科等
/// Creator:	houjian 
/// Createdate:	2013-09-09
/// Input:		AType 关联类型
/// 			AMRItemID 归档项目ID,
/// OutPut:
/// Debug: 		w ##class(DHCEPRFS.BL.BLItemCorrelation).GetReleatedItemID("SCAN","15")
ClassMethod GetReleatedItemID(AType As %String, AMRItemID As %String) As %String
{
	q:(AType="")||(AMRItemID="") ""
	
	s ret = ""
	
	s releatedItem = ""
	for {
		s releatedItem = $O(^DHCEPRFS.META.ItemCorrelationI("IdxMain"," "_AType, " "_AMRItemID, releatedItem))
		q:(releatedItem="")
		
		s releatedID = $e(releatedItem,2,$L(releatedItem))
		continue:(releatedID="")
		
		if (ret = "")
		{	s ret = releatedID}
		else
		{	s ret = ret_"^"_releatedID}	
	}
	
	q ret
}

/// Desc:		打印时，若某项目的扫描件没有则打印生产件，
/// 			比如病理扫描项目 关联 病理生成，若病理扫描件没有则替换为病理生成件
/// Input:		AType 关联类型
/// 			AMRVerItemIDS 归档项目实例IDS(已存在的项目)
/// OutPut:
/// Debug: 		w ##class(DHCEPRFS.BL.BLItemCorrelation).ReplaceCorrelation("SCAN","15")
ClassMethod ReplaceCorrelation(AMRVersionID As %String, AMRItemID As %String) As %String
{
	//b "s"
	s ret = ""
	//一个项目只许关联一个
	s releatedItem = ""
	s releatedItem = $O(^DHCEPRFS.META.ItemCorrelationI("IdxMain"," PRINT", " "_AMRItemID, releatedItem))
	q:(releatedItem = "") ret
	//取此关联项目的AMRVerItemIDS
	s releatedItem = $tr(releatedItem," ","")
	s releatedMRVerItemID = ##class(DHCEPRFS.BL.BLMRVerItem).GetMRVerItemID(AMRVersionID,releatedItem)
	if (releatedMRVerItemID '= "")
	{
		//此MRVersion下此被关联项目存在
		s ret = releatedMRVerItemID
	}
	
	q ret
}

}
