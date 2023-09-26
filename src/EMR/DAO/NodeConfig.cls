/// 名称:	EMR.DAO.NodeConfig
/// 描述:	数据节点配置表的业务逻辑对象
/// 编写者：yejian
/// 编写日期: 2022-7-6
/// 产品组：电子病历产品组
Class EMR.DAO.NodeConfig Extends %RegisteredObject
{

/// Desc:       根据系统当前时间，获取正在使用的数据节点ID。当取不到数据节点ID时，默认使用最后一个数据节点ID
/// Creator:    yejian
/// CreateDate: 2022-7-6
/// Table：     CF.EMR.DOC.NodeConfig 
/// Input：     
/// Output:     
/// Return：    节点ID
/// Debug:       w ##Class(EMR.DAO.NodeConfig).GetCurrNodeID()
ClassMethod GetCurrNodeID() As %String
{
	s ReturnValue = ""
	
	s CurrDateTime = $h
	s CurrDate = $p(CurrDateTime,",",1)
	s CurrTime = $p(CurrDateTime,",",2)
	
	s RowID = ""
	for
	{
		s RowID = $o(^CF.EMR.DOC.NodeConfigD(RowID))
		q:RowID=""

		s obj = ##class(CF.EMR.DOC.NodeConfig).%OpenId(RowID)				
	    Continue:((CurrDate<obj.DateFrom)||(CurrDate>obj.DateTo))
		s ReturnValue = obj.NodeID
	}
	
     /// 根据系统当前时间,当取不到数据节点ID时，默认使用最后一个数据节点ID
	i ReturnValue = ""
	{
		s RowID = $o(^CF.EMR.DOC.NodeConfigD(RowID),-1)
		s obj = ##class(CF.EMR.DOC.NodeConfig).%OpenId(RowID)
		s ReturnValue = obj.NodeID
	}
	
	q ReturnValue
}

}
