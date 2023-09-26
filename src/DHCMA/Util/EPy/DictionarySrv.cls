/// 名称: DHCMA.Util.EPy.DictionarySrv
/// 描述: HIS接口服务 基础字典
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.EPy.DictionarySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2019-01-17
/// Description:  根据ID同步基础字典信息
/// Table：       DHCMA.Util.EP.Dictionary
/// Input：		  aOID : DHCMA.Util.EP.Dictionary.OID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.DictionarySrv).SetDictionary()
ClassMethod SetDictionary(aTypeDr As %String, aOID As %String) As %String
{
	New (aTypeDr,aOID)
	Set return=0
	Quit:(aOID="") return
	
	Set objType=##class(DHCMA.Util.BT.DicType).GetObjById(aTypeDr)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	Set TypeCode=objType.BTCode
	
	Set objSYS=##class(DHCMA.Util.EPS.OIDService).GetSYSDr(aOID)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	Quit:SYSExCode'="localhost" return
	Set SYSOID=##class(DHCMA.Util.EPS.OIDService).GetSYSOID(aOID)
	Quit:SYSOID="" return
	
	If TypeCode="HISCTSex" {
		//性别
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTSexDic")
	} ElseIf TypeCode="HISCTNation" {
		//民族
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTNationDic")
	} ElseIf TypeCode="HISCTCountry" {
		//国籍
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTCountryDic")
	} ElseIf TypeCode="HISCTMarital" {
		//婚姻状况
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTMaritalDic")
	} ElseIf TypeCode="HISCTOccupation" {
		//职业
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTOccupationDic")
	} ElseIf TypeCode="HISCTSocialStatus" {
		//医疗付费方式
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTSocialStatusDic")
	}ElseIf TypeCode="HISCTRelation" {
		//关系
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTRelationDic")
	} ElseIf TypeCode="HISPACCardType" {
		//证件类型
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetPACCardTypeDic")
	} ElseIf TypeCode="HISCTEducation" {
		//学历
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTEducationDic")
	}		
  	Set sc=rs.Execute(SYSOID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")                // ID
		Set Code=rs.Data("Code")             // 代码
		Set Desc=rs.Data("Desc")             // 描述
		Set IsActive=rs.Data("IsActive")     // 是否有效
	    Set:OID'="" OID=OID_"!!"_SYSDr
		Continue:(OID="")||(Desc="")
		
		Set ID="",RangeID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.Dictionary).xGetByOID(TypeDr,OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set RangeID   = objTmp.BTRangeID
			Set ActUserID = objTmp.BTActUserID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=TypeDr
		Set $p(InputStr,"^",6)=RangeID
		Set $p(InputStr,"^",7)=IsActive
		Set $p(InputStr,"^",8)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.Dictionary).Update(InputStr,"^")
		Set return=+flg
		Quit
	}
	Quit return
}

/// Creator:	  zhufei
/// Description:  同步性别字典
/// Table：       DHCMA.Util.EP.Dictionary
/// Input：		  aTypeDr : DHCMA.Util.BT.DicType.ID
///               aSYSCode : DHCMA.Util.BT.SYSTEM.BTCode
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.DictionarySrv).GetHisDicList(1,"HISCTSex")
ClassMethod GetHisDicList(aSYSDr As %String, aTypeCode As %String) As %String
{
	New (aSYSDr,aTypeCode)
	Set return=0,Count=0
	
	Set objType=##class(DHCMA.Util.BT.DicType).GetObjByCode(aTypeCode)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	Set TypeCode=objType.BTCode
	
	Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjById(aSYSDr)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	Quit:SYSExCode'="localhost" return
	
	If TypeCode="HISCTSex" {
		//性别
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTSexDic")
	} ElseIf TypeCode="HISCTNation" {
		//民族
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTNationDic")
	} ElseIf TypeCode="HISCTCountry" {
		//国籍
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTCountryDic")
	} ElseIf TypeCode="HISCTMarital" {
		//婚姻状况
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTMaritalDic")
	} ElseIf TypeCode="HISCTOccupation" {
		//职业
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTOccupationDic")
	} ElseIf TypeCode="HISCTSocialStatus" {
		//医疗付费方式
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTSocialStatusDic")
	} ElseIf TypeCode="HISCTRelation" {
		//关系
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTRelationDic")
	} ElseIf TypeCode="HISPACCardType" {
		//证件类型
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetPACCardTypeDic")
	} ElseIf TypeCode="HISCTEducation" {
		//学历
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTEducationDic")
	}	
	
	Set sc=rs.Execute("")
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")                // ID
		Set Code=rs.Data("Code")             // 代码
		Set Desc=rs.Data("Desc")             // 描述
		Set IsActive=rs.Data("IsActive")     // 是否有效
	    Set:OID'="" OID=OID_"!!"_SYSDr
		Continue:(OID="")||(Desc="")
		
		Set ID="",RangeID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.Dictionary).xGetByOID(TypeDr,OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set RangeID   = objTmp.BTRangeID
			Set ActUserID = objTmp.BTActUserID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=TypeDr
		Set $p(InputStr,"^",6)=RangeID
		Set $p(InputStr,"^",7)=IsActive
		Set $p(InputStr,"^",8)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.Dictionary).Update(InputStr,"^")
		If (+flg)>0{
			Set Count=Count+1
		}
	}
	Quit Count
}

}
