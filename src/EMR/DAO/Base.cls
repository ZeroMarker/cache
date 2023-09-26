/// 名称:	EMR.DAO.Base
/// 描述:	数据访问层对象的基类，提供分片表的DAO对象的公共方法
/// 编写者：yejian
/// 编写日期: 2022-7-6
/// 产品组：电子病历产品组
Class EMR.DAO.Base Extends %RegisteredObject
{

/// GlobalEMR(三版病历系统) 实例数据持久化类的包名
Parameter GlobalEMRPackageName = "EMR";

/// GlobalEMR(三版病历系统) 实例数据持久化类的索引数据根节点
Parameter GlobalEMRIndexLocation = "EMR";

/// 创世节点的数据节点ID
Parameter GenesisNode = "DB";

/// Desc:       创建实例
/// Creator:    yejian
/// CreateDate: 2022-7-6
/// Table：      
/// Input：     argEpisodeID 就诊号
/// Output:       
/// Return：    真实表的实例对象
/// Debug:      w ##Class(EMR.DAO.XXXX).doCreateInstance("1")
ClassMethod doCreateInstance(argEpisodeID As %String) As %String
{
    q:(argEpisodeID = "") ""
    
    try
    {   
        s ReturnValue = ""
        
        s TureClassName = ..GetTureClassName(argEpisodeID)
        s OrRefInstance = $CLASSMETHOD(TureClassName,"%New")
        
        s ReturnValue = OrRefInstance
    }
    catch excepiton 
    {
        throw excepiton
    }
    
    q ReturnValue
}

/// Desc:       获取真实表名
/// Creator:    yejian
/// CreateDate: 2022-7-6
/// Table：      
/// Input：     argEpisodeID 就诊号
/// Output:       
/// Return：    真实表表名
/// Debug:      w ##Class(EMR.DAO.XXXX).GetTureClassName("1")
ClassMethod GetTureClassName(argEpisodeID As %String) As %String
{
    q:(argEpisodeID = "") ""
    
    s ReturnValue  = ""
    s NodeID = ##Class(EMR.DAO.EpisodeIDShardingStrategy).TableStrategy(argEpisodeID)
   
    s ReturnValue = ..#GlobalEMRPackageName_"."_NodeID_"."_..FunctionName()
    
    q ReturnValue
}

/// Desc:       获取真实表的索引数据节点名称
/// Creator:    yejian
/// CreateDate: 2022-7-6
/// Table：      
/// Input：     argEpisodeID 就诊号
/// Output:       
/// Return：    真实表表的索引数据节点名称
/// Debug:       w ##Class(EMR.DAO.XXXX).GetTureIndexLocation("1")
ClassMethod GetTureIndexLocation(argEpisodeID As %String) As %String
{
    q:(argEpisodeID = "") ""
    try
    {
        s ReturnValue = ""
        
        s NodeID = ##Class(EMR.DAO.EpisodeIDShardingStrategy).TableStrategy(argEpisodeID)
        s ReturnValue = "^"_..#GlobalEMRIndexLocation_"."_NodeID_"."_..FunctionName()_"I"
        
    }
    catch excepiton 
    {
        throw excepiton
    }
    
    q ReturnValue
}

/// Desc:       获取真实表的实例
/// Creator:    yejian
/// CreateDate: 2022-7-6
/// Table：      
/// Input：     argEpisodeID 就诊号
/// 			argRowID 真实表的ID
/// Output:       
/// Return：    真实表的实例对象
/// Debug:       w ##Class(EMR.DAO.XXXX).doOpenByID("1","1")
ClassMethod doOpenByID(argEpisodeID As %String, argRowID As %String) As %String
{
    try
    {   
        s ReturnValue = ""
        
        s TureClassName = ..GetTureClassName(argEpisodeID)
        s OrRefInstance = $CLASSMETHOD(TureClassName,"%OpenId",argRowID)
        
        s ReturnValue = OrRefInstance
    }
    catch excepiton 
    {
        throw excepiton
    }
    
    q ReturnValue
}

/// Desc:       删除真实表的实例
/// Creator:    yejian
/// CreateDate: 2022-7-6
/// Table：      
/// Input：     argEpisodeID 就诊号
/// 			argRowID 真实表的ID
/// Output:       
/// Return：    status
/// Debug:       w ##Class(EMR.DAO.XXXX).doDeleteByID("1","1")
ClassMethod doDeleteByID(argEpisodeID As %String, argRowID As %String) As %String
{
    try
    {   
        s ReturnValue = ""
        
        s TureClassName = ..GetTureClassName(argEpisodeID)
        s status = $CLASSMETHOD(TureClassName,"%DeleteId",argRowID) 
    }
    catch excepiton 
    {
        throw excepiton
    }
    
    s ReturnValue = status
    q ReturnValue
}

/// Desc:       继承EMR.DAO.Base的子类编译时，自动生成获取Parameter “FunctionName”的值方法
/// Creator:    yejian
/// CreateDate: 2022-7-6
/// Table：      
/// Input：   
/// Output:       
/// Return：    继承EMR.DAO.Base的子类的Parameter “FunctionName”的值
/// Debug:       w ##Class(EMR.DAO.XXXX).FunctionName()
ClassMethod FunctionName() As %String [ CodeMode = objectgenerator ]
{
    Do %code.WriteLine(" s ReturnValue =""" _ $PARAMETER(%class.Name,"FunctionName") _ """")
    
    Do %code.WriteLine(" q ReturnValue")

    Quit $$$OK
}

}
