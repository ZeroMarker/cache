/// ************************************************************
/// * Class Name:	EPRservice.Quality.DataAccess.BOQualityPhaseStatus
/// * Description:	质控阶段状态服务类
/// * Author:		Candyxu
/// * Create Date:	2011-11-23
/// * Version:
/// ************************************************************/
Class EPRservice.Quality.DataAccess.BOQualityPhaseStatus Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityPhaseStatusInfo";

///  *****************************************************
///  功能：新建或修改质控阶段状态方法
///  *****************************************************
ClassMethod UpdataQualityPhaseStatus(APhaseStatus As EPRservice.entity.Quality.EQualityPhaseStatus) As %String [ WebMethod ]
{
	if ((APhaseStatus.ID=$c(0)) || (APhaseStatus.ID=""))
	{
	    s objMetaPhaseStatus=##class(EPRmeta.Quality.QualityPhaseStatus).%New()
	    q:(objMetaPhaseStatus = "") "0"
	    s flag = "0"
	}
	else
	{
		s objMetaPhaseStatus=##class(EPRmeta.Quality.QualityPhaseStatus).%OpenId(APhaseStatus.ID)
		s flag = "1"
	}
	
	s objMetaPhaseStatus.PhaseName = APhaseStatus.PhaseName
	s objMetaPhaseStatus.PhaseDesc = APhaseStatus.PhaseDesc
	s objMetaPhaseStatus.ColorID = APhaseStatus.ColorID
	s sc=objMetaPhaseStatus.%Save()
	if $system.Status.IsError(sc)
	{
		q "0"
	}
	else
	{
		s RowID = objMetaPhaseStatus.%Id()
		if flag = "0"
		{
	       d ..SaveSequence(RowID)
		}
		q RowID
	}
	d objMetaPhaseStatus.%Close()
}

/// 存储级别
ClassMethod SaveSequence(Aid As %String)
{
	s obj=##class(EPRmeta.Quality.QualityPhaseStatus).%OpenId(Aid)
	if $IsObject(obj)
	{
		s obj.Sequence=Aid
		d obj.%Save()
	}
	d obj.%Close()
}

/// 修改级别
ClassMethod ChangeSequence(Aid1 As %String, Aid2 As %String) [ WebMethod ]
{
	s obj1=##class(EPRmeta.Quality.QualityPhaseStatus).%OpenId(Aid1)
	s obj2=##class(EPRmeta.Quality.QualityPhaseStatus).%OpenId(Aid2)
	if ($IsObject(obj1) && $IsObject(obj2))
	{
		s Sequence = obj1.Sequence
		s obj1.Sequence=obj2.Sequence
		s obj2.Sequence=Sequence
		d obj1.%Save()
		d obj2.%Save()
	}
	d obj1.%Close()
	d obj2.%Close()
}

///  *****************************************************
///  功能：获得所有记录
///  *****************************************************
ClassMethod GetQualityPhaseStatus() As EPRservice.dataset.Quality.EQualityPhaseStatusDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.Quality.EQualityPhaseStatusDataset).%New()
	d result.SetArgs()
	q result
}

///  *****************************************************
///  功能：根据ID删除记录
///  入参：AId
///  *****************************************************
ClassMethod DeleteById(AId As %String) As %Boolean [ WebMethod ]
{
 	s obj = ##class(EPRmeta.Quality.QualityPhaseStatus).%OpenId(AId)
	q:(obj ="") 0 

 	if '(obj.%DeleteId(AId))
 	{
 		q 0
 	} 
 	q 1
}

}
