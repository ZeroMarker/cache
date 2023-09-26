/// 名称: DHCMA.Util.EPy.SSUserSrv
/// 描述: HIS接口服务 用户字典
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.EPy.SSUserSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2019-01-17
/// Description:  根据ID同步用户信息
/// Table：       DHCMA.Util.EP.SSUser
/// Input：		  aOID : DHCMA.Util.EP.SSUser.OID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.SSUserSrv).SetSSUser()
ClassMethod SetSSUser(aOID As %String = "") As %String
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
	
	Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetSSUserDic")
  	Set sc=rs.Execute(SYSOID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")                // ID
		Set Code=rs.Data("Code")             // 代码
		Set Desc=rs.Data("Desc")             // 描述
		Set Password=rs.Data("Password")     // 密码
		Set LocID=rs.Data("LocID")           // 科室ID
		Set CareProvID=rs.Data("CareProvID") // 医护人员ID
		Set IsActive=rs.Data("IsActive")     // 是否有效
	    Set:OID'="" OID=OID_"!!"_SYSDr
	    Set:LocID'="" LocID=LocID_"!!"_SYSDr
	    Set:CareProvID'="" CareProvID=CareProvID_"!!"_SYSDr
		Continue:(OID="")||(Desc="")
		
		Set ID="",RangeID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.SSUser).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID=objTmp.%Id()
			Set RangeID=objTmp.BTRangeID
			Set ActUserID=objTmp.BTActUserID
			Set:LocID="" LocID=objTmp.BTLocID
			Set:CareProvID="" CareProvID=objTmp.BTCareProvID
		}
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=Password
		Set $p(InputStr,"^",6)=LocID
		Set $p(InputStr,"^",7)=CareProvID
		Set $p(InputStr,"^",8)=RangeID
		Set $p(InputStr,"^",9)=IsActive
		Set $p(InputStr,"^",10)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.SSUser).Update(InputStr,"^")
		Set return=+flg
		Quit
	}
	Quit return
}

/// Creator:	  yankai
/// CreatDate：   2018-06-15
/// Description:  同步用户信息
/// Table：       DHCMA.Util.EP.SSUser
/// Input：		  aSYSDr : DHCMA.Util.BT.SYSTEM.ID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.SSUserSrv).SyncSSUser()
ClassMethod SyncSSUser(aSYSDr As %String) As %String
{
	New (aSYSDr)
	Set return=0,Count=0
	
	Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjById(aSYSDr)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	Quit:SYSExCode'="localhost" return
	
	Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetSSUserDic")
  	Set sc=rs.Execute("")
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")                // ID
		Set Code=rs.Data("Code")             // 代码
		Set Desc=rs.Data("Desc")             // 描述
		Set Password=rs.Data("Password")     // 密码
		Set LocID=rs.Data("LocID")           // 科室ID
		Set CareProvID=rs.Data("CareProvID") // 医护人员ID
		Set IsActive=rs.Data("IsActive")     // 是否有效
	    Set:OID'="" OID=OID_"!!"_SYSDr
	    Set:LocID'="" LocID=LocID_"!!"_SYSDr
	    Set:CareProvID'="" CareProvID=CareProvID_"!!"_SYSDr
		Continue:(OID="")||(Desc="")
		
		Set ID="",RangeID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.SSUser).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID=objTmp.%Id()
			Set RangeID=objTmp.BTRangeID
			Set ActUserID=objTmp.BTActUserID
			Set:LocID="" LocID=objTmp.BTLocID
			Set:CareProvID="" CareProvID=objTmp.BTCareProvID
		}
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=Password
		Set $p(InputStr,"^",6)=LocID
		Set $p(InputStr,"^",7)=CareProvID
		Set $p(InputStr,"^",8)=RangeID
		Set $p(InputStr,"^",9)=IsActive
		Set $p(InputStr,"^",10)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.SSUser).Update(InputStr,"^")
		If (+flg)>0{
			Set Count=Count+1
		}
	}
	Quit Count
}

}
