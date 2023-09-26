/// 名称:	EMR.DOC.BL.EMRActStatusCfg
/// 描述:	门诊病历 操作状态业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRActStatusCfg Extends EMR.DOC.COM.ActionBase
{

/// Desc:        由操作前状态和操作得到操作后状态
/// Creator:    yejian
/// CreateDate: 2022-4-13	
/// Input:       parPreStatus：操作前状态, parAction：执行的操作
/// OutPut:      操作后状态代码ID
/// Others:      usage: w ##class(EMR.DOC.BL.EMRActStatusCfg).GetPostStatus(" ","complete")--unfinished
ClassMethod GetPostStatus(parPreStatus As %String, parAction As %String) As %String
{
    k SQLCODE
	s status=""
	&sql(select PostStatus into :status from CF_EMR_DOC.EMRActStatusCfg
	     where (PreStatus->Code=:parPreStatus or PreStatus is null) and EMRAction->Code=:parAction)
	q status
}

}
