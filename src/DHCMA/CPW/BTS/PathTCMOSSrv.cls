/// 名称: DHCMA.CPW.BTS.PathTCMOSSrv
/// 描述: 路径中药方剂协定处方对照服务类
/// 编写者：zhufei
/// 编写日期: 2019-07-18
Class DHCMA.CPW.BTS.PathTCMOSSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2019-07-18
/// Description:  新增中药方剂与协定处方对照关系
/// Table：       DHCMA.CPW.BT.PathTCMOS
/// Input：       aInputStr : 保存信息
/// Return：      返回String
/// zw ##class(DHCMA.CPW.BTS.PathTCMOSSrv).AddTCMOS("2^2742,2750^9!!1")
ClassMethod AddTCMOS(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set PathTCMDr = $p(aInputStr,aSeparete,1)
	Set ARCOSIDs  = $p(aInputStr,aSeparete,2)
	Set ActUserID = $p(aInputStr,aSeparete,3)
	Quit:(PathTCMDr="")||(ARCOSIDs="") return
	
	Set IsError=0
	For indARCOS=1:1:$l(ARCOSIDs,",") {
		Set tARCOSID=$p(ARCOSIDs,",",indARCOS)
		Continue:tARCOSID=""
		
		Set ID=$o(^DHCMA.CPW.BT.PathTCMOSI("IdxPathTCMOS",PathTCMDr," "_$zcvt(tARCOSID,"U"),0))
		Set InputStr=ID_"^"_PathTCMDr_"^"_tARCOSID_"^"_1_"^"_""_"^"_""_"^"_ActUserID
		Set flg=##class(DHCMA.CPW.BT.PathTCMOS).Update(InputStr)
		If (+flg)<1 {
			Set IsError=1
			Quit
		}
	}
	Quit:IsError>0 return
	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-07-18
/// Description:  删除中药方剂与协定处方对照关系
/// Table：       DHCMA.CPW.BT.PathTCMOS
/// Input：       aInputStr : 保存信息
/// Return：      返回String
/// zw ##class(DHCMA.CPW.BTS.PathTCMOSSrv).DeleteTCMOS("2","9!!1")
ClassMethod DeleteTCMOS(aIDs As %String, aActUserID As %String) As %String
{
	New (aIDs,aActUserID)
	Set return=0
	Quit:aIDs="" return
	
	Set IsError=0
	For indID=1:1:$l(aIDs,",") {
		Set tID=$p(aIDs,",",indID)
		Continue:tID=""
		
		Set objPathTCM=##class(DHCMA.CPW.BT.PathTCMOS).GetObjById(tID)
		Continue:'$IsObject(objPathTCM)
		Continue:objPathTCM.TOIsActive'=1
		Continue:'$IsObject(objPathTCM.TOTCMDr)
		Set PathTCMDr=objPathTCM.TOTCMDr.%Id()
		Set ARCOSID=objPathTCM.TOARCOSID
		
		Set InputStr=tID_"^"_PathTCMDr_"^"_ARCOSID_"^"_0_"^"_""_"^"_""_"^"_aActUserID
		Set flg=##class(DHCMA.CPW.BT.PathTCMOS).Update(InputStr)
		If (+flg)<1 {
			Set IsError=1
			Quit
		}
	}
	Quit:IsError>0 return
	
	Set return=1
	Quit return
}

}
