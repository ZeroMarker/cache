Class EMRservice.BL.BLEMRActStatusCfg Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:     Candy
/// CreateDate:  2014-3-19	
/// Desc:        由操作前状态和操作得到操作后状态
/// Input:       parPreStatus：操作前状态, parAction：执行的操作
/// Return:      操作后状态代码
/// Others:      usage: w ##class(EMRservice.BL.BLEMRActStatusCfg).GetPostStatus(" ","complete")--unfinished
ClassMethod GetPostStatus(parPreStatus As %String, parAction As %String) As %String
{
    k SQLCODE
	s status=""
	&sql(select PostStatus into :status from EMRmeta.EMRActStatusCfg
	     where (PreStatus=:parPreStatus or PreStatus is null) and EMRAction=:parAction)
	q status
}

}
