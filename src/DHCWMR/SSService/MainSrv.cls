/// 名称: DHCWMR.SSService.MainSrv
/// 描述: 病案相关服务
/// 编写者：zhufei
/// 编写日期: 2014-12-30
Class DHCWMR.SSService.MainSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据病案号取就诊号列表
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       MrNo : 病案号
///               MrTypeID : 病案类型
/// Return：      返回String
/// w ##class(DHCWMR.SSService.MainSrv).GetEpisodeIDsByMrNo(7,"900022")
ClassMethod GetEpisodeIDsByMrNo(aMrTypeID As %String, aMrNo As %String) As %List
{
	New (aMrTypeID,aMrNo)
	Set return=""
	Quit:(aMrTypeID="")||(aMrNo="") return
	
	Set xMainID=0
	For {
		Set xMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_aMrNo,1,xMainID))
		Quit:xMainID=""
		
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",xMainID,xVolID))
			Quit:xVolID=""
			
			Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
			Continue:'$IsObject(objVol)
			Continue:objVol.SVIsActive'=1
			Continue:'$IsObject(objVol.SVMainDr)
			Continue:objVol.SVMainDr.SMIsActive'=1
			
			For indAdm=1:1:objVol.ChildPaadm.Count() {
				Set objPaadm=objVol.ChildPaadm.GetAt(indAdm)
				Continue:'$IsObject(objPaadm)
				Set EpisodeID=objPaadm.VPEpisodeID
				Continue:EpisodeID=""
				Set return=return_$lb(EpisodeID)
			}
		}
	}
	
	Quit return
}

}
