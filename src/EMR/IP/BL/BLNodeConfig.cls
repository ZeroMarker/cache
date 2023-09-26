/// 名称: 数据节点配置表的业务逻辑对象
/// 描述: 文档注册表的业务逻辑实现方法。业务逻辑通过数据访问层对象操纵持久化类。
/// 编写者： guozongtao
/// 编写日期: 2022-04-16
/// 产品组：EMR
Class EMR.IP.BL.BLNodeConfig Extends %RegisteredObject
{

/// Creator：    guozongtao 
/// CreatDate：  2022-04-15 
/// Description: 业务逻辑测试方法 
/// Table：      EMR.IP.Global.NodeConfig 
/// Input：      argNodeID 数据节点ID 
/// Output：      
/// Return：     %Id
/// Others： 
/// Debug:       w ##Class(EMR.IP.BL.BLECRecord).Test("DB2")
ClassMethod Test(argNodeID As %String) As %String
{
	s ret = ""
	
	s obj = ##class(EMR.IP.Global.NodeConfig).%New()
	s obj.DateFrom = +$h+2
	s obj.DateTo = +$h+365
	s obj.NodeID = argNodeID
	
	s sc  = obj.%Save()
	if ($$$ISOK(sc))
	{
		s ret = obj.%Id()
		d obj.%Close()
	}
	
	q ret
}

/// 
/// Creator：    guozongtao 
/// CreatDate：  2022-04-16 
/// Description: 根据系统当前时间，获取正在使用的数据节点ID。当取不到数据节点ID时，默认使用最后一个数据节点ID。
/// Table：      EMR.IP.Global.NodeConfig 
/// Input：       
/// Output：      
/// Return：     %Id
/// Others： 
/// Debug:       w ##Class(EMR.IP.BL.BLNodeConfig).GetCurrNodeID()
ClassMethod GetCurrNodeID() As %String
{
	s ReturnValue = ""
	
	s CurrDateTime = $h
	s CurrDate = $p(CurrDateTime,",",1)
	s CurrTime = $p(CurrDateTime,",",2)
	
	s RowID = ""
	for
	{
		s RowID = $o(^EMR.IP.Global.NodeConfigD(RowID))
		q:RowID=""

		s obj = ##class(EMR.IP.Global.NodeConfig).%OpenId(RowID)				
	    Continue:((CurrDate<obj.DateFrom)||(CurrDate>obj.DateTo))
		s ReturnValue = obj.NodeID
	}
	
     /// 根据系统当前时间,当取不到数据节点ID时，默认使用最后一个数据节点ID
	i ReturnValue = ""
	{
		s RowID = $o(^EMR.IP.Global.NodeConfigD(RowID),-1)
		s obj = ##class(EMR.IP.Global.NodeConfig).%OpenId(RowID)
		s ReturnValue = obj.NodeID
	}
	
	q ReturnValue
}

}
