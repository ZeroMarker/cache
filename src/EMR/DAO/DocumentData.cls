/// 名称:	EMR.DAO.DocumentData
/// 描述:	EMR.DB.DocumentData的数据访问对象层的对象
/// 编写者：yejian
/// 编写日期: 2022-7-21
/// 产品组：电子病历产品组
Class EMR.DAO.DocumentData Extends EMR.DAO.Base
{

/// 逻辑表名的功能名称(完整类名中，除了包名以外的，完整类名的其他部分)
/// 例如:EMRinstance.ECRecord ,FunctionName:ECRecord
///      EMRinstance.plugin.RefreshBindData, FunctionName:plugin.RefreshBindData
Parameter FunctionName = "DocumentData";

/// Desc:       获取对象
/// Creator:    yejian
/// CreateDate: 2022-7-6
/// Table：      
/// Input：     argRowID 对象ID
/// Output:       
/// Return：    返回对象
ClassMethod doOpenByID(argRowID As %String) As %String
{
	try
	{	
		s ReturnValue = ""
		
		s GlobalData = ##class(EMR.GB.GlobalData).%OpenId(argRowID)
		i (GlobalData = "")
		{
			s objDocument = $CLASSMETHOD("EMR.DB.DocumentData","%OpenId",argRowID)
		}
		else
		{
			s TureClassName = ..GetTureClassName(GlobalData.EpisodeID.%Id())
			s objDocument = $CLASSMETHOD(TureClassName,"%OpenId",argRowID)
		}
		
		s ReturnValue = objDocument
	}
	catch excepiton 
	{
		throw excepiton
	}
	
	q ReturnValue
}

}
