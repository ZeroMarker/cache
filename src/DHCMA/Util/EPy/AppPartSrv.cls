/// 名称: DHCMA.Util.EPy.AppPartSrv
/// 描述: HIS接口服务 检查部位字典
/// 编写者：zhufei
/// 编写日期: 2020-03-06
Class DHCMA.Util.EPy.AppPartSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2020-03-06
/// Description:  根据ID同步检查部位信息
/// Table：       DHCMA.Util.EP.AppPart
/// Input：		  aOID : DHCMA.Util.EP.AppPart.OID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.AppPartSrv).SetAppPart("1!!1")
ClassMethod SetAppPart(aOID As %String = "") As %String
{
	New (aOID)
	Set return=0
	Quit:(aOID="") return
	
	Set objSYS=##class(DHCMA.Util.EPS.OIDService).GetSYSDr(aOID)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	Quit:SYSExCode'="localhost" return
	Set SYSOID=##class(DHCMA.Util.EPS.OIDService).GetSYSOID(aOID)
	Quit:SYSOID="" return
	
	Set RISReportVer=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSRISReportVer")
	If RISReportVer="RIS1.0" {
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncRisSrv:GetAppPartDic")
	} Else {
		Quit return
	}
  	Set sc=rs.Execute(SYSOID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")               // ID
		Set Code=rs.Data("Code")            // 代码
		Set Desc=rs.Data("Desc")            // 描述
		Set LastOID=rs.Data("LastID")       // 父节点（检查部位）
		Set IsActive=rs.Data("IsActive")    // 是否有效
		Set ArcStr=rs.Data("ArcStr")        // 检查医嘱（多值^分割）
	    Set:OID'="" OID=OID_"!!"_SYSDr
	    Set:LastOID'="" LastOID=LastOID_"!!"_SYSDr
		Continue:(OID="")||(Code="")||(Desc="")
		
		Set ID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.AppPart).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set ActUserID = objTmp.BTActUserID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=LastOID
		Set $p(InputStr,"^",6)=IsActive
		Set $p(InputStr,"^",7)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.AppPart).Update(InputStr,"^")
		If (+flg)>0 {
			Set PartDr=+flg,return=+flg
			For indArc=1:1:$l(ArcStr,"^") {
				Set ArcOID=$p(ArcStr,"^",indArc)_"!!"_SYSDr
				Set objArc=##class(DHCMA.Util.EP.OrdMast).xGetByOID(ArcOID)
				Continue:'$IsObject(objArc)
				Set ArcDr=objArc.%Id()
				Set flg1=##class(DHCMA.Util.EPx.AppArcLink).Update("^"_ArcDr_"^"_PartDr,"^")
			}
		}
		Quit
	}
	Quit return
}

/// Creator:	  zhufei
/// CreatDate：   2020-03-06
/// Description:  批量同步检查部位信息
/// Table：       DHCMA.Util.EP.AppPart
/// Input：		  aSYSDr : DHCMA.Util.BT.SYSTEM.ID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.AppPartSrv).SyncAppPart(1)
ClassMethod SyncAppPart(aSYSDr As %String) As %String
{
	New (aSYSDr)
	Set return=0,Count=0
	Quit:(aSYSDr="") return
	
	Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjById(aSYSDr)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	Quit:SYSExCode'="localhost" return
	
	Set RISReportVer=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSRISReportVer")
	If RISReportVer="RIS1.0" {
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncRisSrv:GetAppPartDic")
	} Else {
		Quit return
	}
  	Set sc=rs.Execute("")
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")               // ID
		Set Code=rs.Data("Code")            // 代码
		Set Desc=rs.Data("Desc")            // 描述
		Set LastOID=rs.Data("LastID")       // 父节点（检查部位）
		Set IsActive=rs.Data("IsActive")    // 是否有效
		Set ArcStr=rs.Data("ArcStr")        // 检查医嘱（多值^分割）
	    Set:OID'="" OID=OID_"!!"_SYSDr
	    Set:LastOID'="" LastOID=LastOID_"!!"_SYSDr
		Continue:(OID="")||(Code="")||(Desc="")
		
		Set ID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.AppPart).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set ActUserID = objTmp.BTActUserID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=LastOID
		Set $p(InputStr,"^",6)=IsActive
		Set $p(InputStr,"^",7)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.AppPart).Update(InputStr,"^")
		If (+flg)>0 {
			Set PartDr=+flg,Count=Count+1
			For indArc=1:1:$l(ArcStr,"^") {
				Set ArcOID=$p(ArcStr,"^",indArc)_"!!"_SYSDr
				Set objArc=##class(DHCMA.Util.EP.OrdMast).xGetByOID(ArcOID)
				Continue:'$IsObject(objArc)
				Set ArcDr=objArc.%Id()
				Set flg1=##class(DHCMA.Util.EPx.AppArcLink).Update("^"_ArcDr_"^"_PartDr,"^")
			}
		}
	}
	Quit Count
}

}
