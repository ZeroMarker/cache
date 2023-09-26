Class DHCEPRFS.BI.BIToST Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	加入PDF生成队列接口,药品入库，药品入库明细，药品出库，药品发药，材料入库，材料入库，材料入库明细，材料出库
/// Input:	AParameter - 打印时需要的参数集合，以^分隔多个参数，1069&2015-08-01^I^2238
/// Return：ID - 记入队列的ID， 空 - 加入队列失败
/// I 药品入库 
/// IM 材料入库 
/// O 药品出库 
/// OM材料出库 
/// D 药品发药 
/// IDe 药品入库明细 
/// IMDe材料入库明细
/// Debug:	w ##Class(DHCEPRFS.BI.BIToST).DHCStkMonFDToPDF("1069&2015-08-01^I^2238")
ClassMethod DHCStkMonFDToPDF(AParameter As %String) As %String
{
	s AParameter = $tr(AParameter,"&","_")
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateDHCStkMonFD()
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC","","50",schemeType,"S","","ST",AParameter)
	q ret
}

}
