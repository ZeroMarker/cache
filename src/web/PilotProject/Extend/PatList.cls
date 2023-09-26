/// CTOR: QP
/// DATE: 2020-09-28
/// DESC: 临床药理受试者列表扩展类
Class web.PilotProject.Extend.PatList Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-28
/// DESC: 阶段修改
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.PatList).SaveStage(4,1)
ClassMethod SaveStage(PPPatid, StageDr)
{
	Q:PPPatid="" 0
	s Stage=$P($G(^DHCDocPPP(+PPPatid,$P(PPPatid,"||",2))),"^",18)
	if (Stage=StageDr) q "修改后的阶段与当前状态一致!"
	&SQL(
		UPDATE SQLUser.DHC_DocPilotProPat 
		SET PPP_Stage=:StageDr
		WHERE PPP_RowId=:PPPatid
	)
		
	I SQLCODE'=0 {
		B ;001
	}
	Q:SQLCODE'=0 "-102"
	
	Q 0
}

ClassMethod GetPatNextStage(PPPatid, PPRowId)
{
	s ^tmp("GetPatNextStage")=$LB(PPPatid, PPRowId)
	Q:PPPatid="" 0
	s NextFlag=""
	s NextStageDesc=""
	s NextStageDr=""
	s Stage=$P($G(^DHCDocPPP(+PPRowId,PPPatid)),"^",18)
	s id=""
	f  s id=$o(^CF.DOC.Pilot.OEStageI("Prj",PPRowId,id)) q:id=""  d
	
	.i NextFlag="Y" s NextStageDesc=$p(^CF.DOC.Pilot.OEStageD(id),"^",1),NextStageDr=id
	.i (Stage=id) s NextFlag="Y"
	.else  s NextFlag=""
	q NextStageDesc_"^"_NextStageDr_"^"_Stage
	&SQL(
		UPDATE SQLUser.DHC_DocPilotProPat 
		SET PPP_Stage=:StageDr
		WHERE PPP_RowId=:PPPatid
	)
		
	I SQLCODE'=0 {

	}
	Q:SQLCODE'=0 "-102"
	
	Q 0
}

}
