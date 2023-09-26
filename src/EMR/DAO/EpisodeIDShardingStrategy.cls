/// 名称:	EMR.DAO.EpisodeIDShardingStrategy
/// 描述:	数据访问层内置的数据分片策略对象
/// 编写者：yejian
/// 编写日期: 2022-7-6
/// 产品组：电子病历产品组
Class EMR.DAO.EpisodeIDShardingStrategy Extends %RegisteredObject
{

/// Desc:       获取数据节点名称。 例如：DB、DB1... ;如果就诊ID未注册到路由表，则取当前启用的数据节点ID进行存储，并把该就诊ID注册到路由表中
/// Creator:    yejian
/// CreateDate: 2022-7-6
/// Table：     EMR.GB.Router 
/// Input：     argEpisodeID 就诊号。以就诊号为分片策略，获取就诊号对应的分片数据节点ID 
/// Output:     
/// Return：    返回就诊号对应病历数据节点ID
/// Debug:      w ##Class(EMR.DAO.EpisodeIDShardingStrategy).TableStrategy("4")
ClassMethod TableStrategy(argEpisodeID As %String) As %String
{
    q:(argEpisodeID = "") ""
    
    //获取数据节点名称。 例如：DB2、DB3... 
    s NodeID = $o(^EMR.GB.RouterI("IdxEpisodeIDNodeID"," "_argEpisodeID,""))

    //如果就诊ID未注册到路由表，则取当前启用的数据节点ID进行存储，并把该就诊ID注册到路由表中
    i NodeID = ""  
    {
        s CurrNodeID = ##class(EMR.DAO.NodeConfig).GetCurrNodeID()
        
        s ret = ##Class(EMR.DAO.Router).AddEpisodeID(argEpisodeID,CurrNodeID)
        i ret '= "-1"
        {
            s OrRefRouter = ##Class(EMR.GB.Router).%OpenId(ret)
            s NodeID = $ZCVT(OrRefRouter.NodeID, "U")
            d OrRefRouter.%Close()
        }
    }
    
    q $tr(NodeID," ","")
}

/// Desc:       获取数据节点名称
/// Creator:    yejian
/// CreateDate: 2022-7-6
/// Table：     EMR.GB.GlobalData 
/// Input：     argGlobalID ： 全局InstanceID
/// Output:       
/// Return：    返回对应病历数据节点ID
/// Debug:       w ##Class(EMR.DAO.EpisodeIDShardingStrategy).TableStrategyByGlobalInstance("1")
ClassMethod TableStrategyByGlobalInst(argGlobalID) As %String
{
	q:(argGlobalID="") ""
    s obj = ##class(EMR.GB.GlobalData).%OpenId(argGlobalID)
    q:(obj = "") ""
    q obj.NodeID
}

}
