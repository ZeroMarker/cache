/// 名称:	EMR.DOC.BL.BindParameter
/// 描述:	通用文档管理模块 Document(Doc) 数据集查询参数业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.BindParameter Extends EMR.DOC.COM.ActionBase
{

/// Desc:       根据ID查询参数
/// Creator:    yejian
/// CreateDate:	2021-5-6
/// Input:      aQueryID  数据集ID
/// OutPut:     DataSet
/// Debug:      d ##class(%ResultSet).RunQuery("EMR.DOC.BL.BindParameter","SelectParameterByQueryID","1")
Query SelectParameterByQueryID(AQuetyID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,Description:%String,Code:%String,BindQuery:%String", SELECTMODE = "RUNTIME") [ SqlProc ]
{
 SELECT p.ID, p.Parameter->Name, p.Parameter->Description,p.Parameter->Code,BindQuery
 FROM  CF_EMR_DOC.BindParameter p
 Where BindQuery= :AQuetyID
 ORDER BY ID
}

}
