/// 名称:	EMR.DAO.Router
/// 描述:	数据路由分片策略对象
/// 编写者：yejian
/// 编写日期: 2022-7-6
/// 产品组：电子病历产品组
Class EMR.DAO.Router Extends %RegisteredObject
{

/// Desc:       增加数据路由信息
/// Creator:    yejian
/// CreateDate: 2022-7-6
/// Table：     EMR.GB.Router 
/// Input：     argEpisodeID 就诊号
/// 			argNodeID 数据节点ID
/// Output:     
/// Return：    路由ID
/// Debug:      w ##Class(EMR.DAO.Router).AddEpisodeID("1","DB2")
ClassMethod AddEpisodeID(argEpisodeID As %String, argNodeID As %String) As %String
{
	s ret = "-1"
	
	s objRouter = ##class(EMR.GB.Router).%New()
	
	s CreateDateTime = $h
	s objRouter.CreateDate = $p(CreateDateTime,",",1)
	s objRouter.CreateTime = $p(CreateDateTime,",",2)
	s objRouter.EpisodeID = argEpisodeID
	s objRouter.NodeID = argNodeID
	
	s sc  = objRouter.%Save()
	
	if ($$$ISOK(sc))
	{
		s ret = objRouter.%Id()
	}
	else
	{
		s ret="-1"	
	}
	d objRouter.%Close()
	
	q ret
}

}
