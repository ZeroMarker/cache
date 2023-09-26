/// 名称: DHCHAI.IRS.ICULogDtlSrv
/// 描述: 目标性监测ICU相关服务
/// 编写者：chenjb
/// 编写日期: 2017-07-06
Class DHCHAI.IRS.ICULogDtlSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2017-05-27
/// Description:  
/// Table：       ICULogDtl
/// Input：       aEpisodeID : 科室
///               ILDate : 调查日期
/// Return：      返回%String  三管数量及其他 ^^
/// w ##class(DHCHAI.IRS.ICULogDtlSrv).GetICULogDtlCnt("27","2017-08-13")
ClassMethod GetICULogDtlCnt(ILLocDr As %String, ILDate As %String) As %String
{
	New (ILLocDr,ILDate)
	Set return = ""
	Quit:(ILLocDr="")||(ILDate="") return
	
	Set:ILDate["-" ILDate=$zdh(ILDate,3)
	
	Set (PICCCnt,VAPCnt,UCCnt,Type1)=0
	Set xID =""
	For {
		Set xID=$o(^DHCHAI.IR.ICULogDtlI("IndexLocDate",ILLocDr,ILDate,xID))
		Quit:xID=""
		
		Set objDtl = ##class(DHCHAI.IR.ICULogDtl).GetObjById(xID)
		Continue:'$Isobject(objDtl)
		
		Set:objDtl.ILIsPICC=1 PICCCnt=PICCCnt+1
		Set:objDtl.ILIsVAP=1 VAPCnt=VAPCnt+1
		Set:objDtl.ILIsUC=1 UCCnt=UCCnt+1	
		Set:objDtl.ILIsType1 Type1=Type1+1
	}
	Set return=PICCCnt_"^"_VAPCnt_"^"_UCCnt_"^"_Type1
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-05-27
/// Description:  
/// Table：       ICULogDtl
/// Input：       aEpisodeID : 科室
///               ILDate : 调查日期
/// Return：      返回%String  三管数量及其他 ^^
/// w ##class(DHCHAI.IRS.ICULogDtlSrv).GetCntByPaAdm("27","2017-08-13","")
ClassMethod GetCntByPaAdm(ILLocDr As %String, ILDate As %String, Paadm As %String) As %String
{
	New (ILLocDr,ILDate,Paadm)
	Set return = "0^0^0^0^0^0^0"
	Quit:(ILLocDr="")||(ILDate="")||(Paadm="") return
	
	Set:ILDate["-" ILDate=$zdh(ILDate,3)
	
	Set (PICCCnt,VAPCnt,UCCnt,IsOper,ILIsCVC,ILIsCRRT,ILIsPORT)=0
	Set xID =""
	For {
		Set xID=$o(^DHCHAI.IR.ICULogDtlI("IndexILEpisodeDr",ILLocDr,ILDate,Paadm,xID))
		Quit:xID=""
		
		Set objDtl = ##class(DHCHAI.IR.ICULogDtl).GetObjById(xID)
		Continue:'$Isobject(objDtl)
		
		Set:objDtl.ILIsPICC=1 PICCCnt=PICCCnt+1
		Set:objDtl.ILIsVAP=1 VAPCnt=VAPCnt+1
		Set:objDtl.ILIsUC=1 UCCnt=UCCnt+1	
		Set:objDtl.ILIsOper=1 IsOper=IsOper+1
		Set:objDtl.ILIsCVC=1 ILIsCVC=ILIsCVC+1
		Set:objDtl.ILIsCRRT=1 ILIsCRRT=ILIsCRRT+1
		Set:objDtl.ILIsPORT=1 ILIsPORT=ILIsPORT+1
	}
	Set return=PICCCnt_"^"_VAPCnt_"^"_UCCnt_"^"_IsOper_"^"_ILIsCVC_"^"_ILIsCRRT_"^"_ILIsPORT
	Quit return
}

}
