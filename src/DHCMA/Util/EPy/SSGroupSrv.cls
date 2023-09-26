/// 名称: DHCMA.Util.EPy.SSGroupSrv
/// 描述: HIS接口服务 安全组字典
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.EPy.SSGroupSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2019-01-17
/// Description:  根据ID同步安全组信息
/// Table：       DHCMA.Util.EP.SSGroup
/// Input：		  aOID : DHCMA.Util.EP.SSGroup.OID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.SSGroupSrv).SetSSGroup()
ClassMethod SetSSGroup(aOID As %String = "") As %String
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
	
	Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetSSGroupDic")
  	Set sc=rs.Execute(SYSOID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")                // ID
		Set Desc=rs.Data("Desc")             // 描述
		Set IsActive=rs.Data("IsActive")     // 是否有效
	    Set:OID'="" OID=OID_"!!"_SYSDr
		Continue:(OID="")||(Desc="")
		
		Set ID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.SSGroup).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID=objTmp.%Id()
			Set ActUserID=objTmp.BTActUserID
		}
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Desc
		Set $p(InputStr,"^",4)=IsActive
		Set $p(InputStr,"^",5)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.SSGroup).Update(InputStr,"^")
		Set return=+flg
		Quit
	}
	Quit return
}

/// Creator:	  zhufei
/// CreatDate：   2018-06-15
/// Description:  同步安全组信息
/// Table：       DHCMA.Util.EP.SSGroup
/// Input：		  aSYSDr : DHCMA.Util.BT.SYSTEM.ID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.SSGroupSrv).SyncSSGroup()
ClassMethod SyncSSGroup(aSYSDr As %String) As %String
{
	New (aSYSDr)
	Set return=0,Count=0
	
	Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjById(aSYSDr)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	Quit:SYSExCode'="localhost" return
	
	Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetSSGroupDic")
  	Set sc=rs.Execute("")
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")                // ID
		Set Desc=rs.Data("Desc")             // 描述
		Set IsActive=rs.Data("IsActive")     // 是否有效
	    Set:OID'="" OID=OID_"!!"_SYSDr
		Continue:(OID="")||(Desc="")
		
		Set ID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.SSGroup).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID=objTmp.%Id()
			Set ActUserID=objTmp.BTActUserID
		}
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Desc
		Set $p(InputStr,"^",4)=IsActive
		Set $p(InputStr,"^",5)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.SSGroup).Update(InputStr,"^")
		If (+flg)>0{
			Set Count=Count+1
		}
	}
	Quit Count
}

}
