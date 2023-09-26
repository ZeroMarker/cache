/// ************************************************************
/// * Class Name:	EPRservice.Quality.DataAccess.BOQualityPhaseModify
/// * Description:	质控阶段维护服务类
/// * Author:		Candyxu
/// * Create Date:	2011-11-23
/// * Version:
/// ************************************************************/
Class EPRservice.Quality.DataAccess.BOQualityPhaseModify Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityPhaseModifyInfo";

///  *****************************************************
///  功能：获得所有记录
///  *****************************************************
ClassMethod GetQualityPhaseByEntryID(PEntryID As %String) As EPRservice.dataset.Quality.EQualityPhaseModifyDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.Quality.EQualityPhaseModifyDataset).%New()
	d result.SetArgs(PEntryID)
	q result
}

///  *****************************************************
///  功能：新建或修改质控阶段状态方法
///  *****************************************************
ClassMethod UpdataQualityPhaseModify(APhaseModify As EPRservice.entity.Quality.EQualityPhasesModify) As %String [ WebMethod ]
{
	if ((APhaseModify.ID=$c(0)) || (APhaseModify.ID=""))
	{
	    s objMetaPhase=##class(EPRmeta.Quality.QualityPhasesModify).%New()
	    q:(objMetaPhase = "") "0"
	}
	else
	{
		s objMetaPhase=##class(EPRmeta.Quality.QualityPhasesModify).%OpenId(APhaseModify.ID)
	}
	
	s objMetaPhase.QualityEntryDR = APhaseModify.QualityEntryDR
	s objMetaPhase.QualityPhaseStatusDR = APhaseModify.QualityPhaseStatusDR
	s objMetaPhase.QualityQueryDR = APhaseModify.QualityQueryDR
	s objMetaPhase.PhaseDemo =APhaseModify.PhaseDemo
	//s objMetaPhase.Sequence = APhaseModify.Sequence
	s sc=objMetaPhase.%Save()
	if $system.Status.IsError(sc)
	{
		q "0"
	}
	else
	{
		q objMetaPhase.%Id()
	}
	d objMetaPhase.%Close()
}

///  *****************************************************
///  功能：根据ID删除记录
///  入参：AId
///  *****************************************************
ClassMethod DeleteById(AId As %String) As %Boolean [ WebMethod ]
{
 	s obj = ##class(EPRmeta.Quality.QualityPhasesModify).%OpenId(AId)
	q:(obj ="") 0 

 	if '(obj.%DeleteId(AId))
 	{
 		q 0
 	} 
 	q 1
}

/// Creator:Candyxu
/// Date:   2011-11-24 
/// Desc:   判断质控条目属于那个阶段
/// Input:  AEpisodeID 患者就诊号
///         AEntryID 质控项目ID
/// Debug:  do ##Class(EPRservice.Quality.DataAccess.BOQualityPhaseModify).GetQualityPhase("8706","31584")
ClassMethod GetQualityPhase(AEpisodeID As %String, AEntryID As %String) As %String
{
 	s Result=""
	s RowID=""
	for {
		s RowID = $o(^DHCEPRM.QualityPhasesModifyI("idxQualityEntryDR",AEntryID,RowID))
		q:(RowID = "")
		s QueryID = $list(^DHCEPRM.QualityPhasesModifyD(RowID),4)
        s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(AEpisodeID,QueryID)
        Continue:(flag '= "1")
	    s PhaseID = $list(^DHCEPRM.QualityPhasesModifyD(RowID),3)    // 阶段ID
	    s PhaseName = $list(^DHCEPRM.QualityPhaseStatusD(PhaseID),2) //阶段名称
	    s PhaseColor = $list(^DHCEPRM.QualityPhaseStatusD(PhaseID),4) //阶段颜色
	    s Result = PhaseID_"^"_PhaseName_"^"_PhaseColor
     }
 	q Result
}

}
