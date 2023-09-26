/// Created by SongDeBo 2006/6/13
/// Description: 访问英智医院CRM系统的入口
Class web.DHCPE.CRM.GatewayYZ Extends web.DHCPE.CRM.IGateway [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

/// 获取用户信息
/// return: ...$C(1)patId^patName^Birthday^mobileNO^Address^corporator^CertCardNO^Gender^level
/// 				^Marital^Email^Zip^BloodType^Profession^Title^Race$C(1)...
/// param:
/// 		QueryType: paraValue的类型,“HISCARDID”，“MID”、“CERTID”, “MOBILE”, "PATNAME"
/// 		QueryValue: 具体的查询值
ClassMethod GetMemberByID(QueryType, QueryValue) As %String
{
	s strRet=""
	//s ^Bob("Temp",$zn)=QueryType_"^"_QueryValue
	i QueryType="HISCARDID"  s QueryValue=##class(web.DHCPE.DHCPECommon).RegNoMask(QueryValue)
	//s strRet="00000100^robert1^1978-4-4^1234^BOB ST.^DHC^420111780501401^男^1" 
			//_"$C(1)00000101^孙少平^1978-4-1^1234^BOB ST.^DHC^420111780501403^女^2"
	s port=##Class(web.DHCPE.CRMYZ.SoCRMWSDLPort).%New()
	//GetMember(QueryPair As web.DHCPE.CRM.QueryPair) As web.DHCPE.CRM.MemberInfos [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:socrm.com", Web]
	s param=##Class(web.DHCPE.CRMYZ.QueryPair).%New()
	s param.QueryType=..CastCode(QueryType,1,"QTypeP")
	s param.QueryValue=QueryValue
	s param.QueryValue=$ZCVT(param.QueryValue,"O","UTF8")
	s objMembers=port.GetMember(param)
	s strMembers=""
	for i=1:1:objMembers.Count() {
		s objMember=objMembers.GetAt(i)
		s hisSex=(..CastCode(objMember.Sex,0,"Gender"))
		S hisMarital=(..CastCode(objMember.Marry,0,"Marital"))
		s strMember=objMember.CardId_"^"_objMember.Truename
				_"^"_$p(objMember.Birthday," ",1)_"^"_objMember.Mobile
				_"^"_objMember.Addr_"^"_objMember.CorpTitle
				_"^"_objMember.CertId_"^"_hisSex
				_"^"_objMember.Rank
		s strMember=strMember
				_"^"_hisMarital_"^"_objMember.Email
				_"^"_objMember.Zip_"^"_objMember.Blood
				_"^"_objMember.Vocation_"^"_objMember.CorpTitle_"^"_objMember.Race
		i i'=1  s strMembers=strMembers_$C(1)
		b
		s strMembers=strMembers_strMember
	}
	s retStr=strMembers
	;s retStr=$tr(retStr,$C(1),$C(10))	
	q retStr
}

/// 获取用户体检登记记录
/// return: ***$C(1)RegID^PatCardId^PreRegDate^RecordDate^IsAsCharged^Status^CountAmount^DiscountAmount^FinalAmount^PatNAME$C(1)...
/// param:
/// 		QueryType: paraValue的类型,“HISCARDID”，“MID”、“CERTID”, “MOBILE”,"REGID","PATNAME"
/// 		QueryValue: 具体的查询值
/// 		Flag:"ALL"-客人的所有记录;  "UNCOMPLETED"-客人未结束的体检预约记录，包括进行中和未开始的。及各状态。
ClassMethod GetRegListByPatInf(QueryType, QueryValue, Flag As %String = "ALL") As %String
{
	s strRet=""
	//s strRet="1001^00000100^2006-3-20^2005-3-1^1^PREREG^1000^880^800^PatName1" _$C(1)_"101^00000101^2006-3-20^2005-3-1^1^PREREG^500^440^400^PatName"
	
	i QueryType="HISCARDID"  s QueryValue=##class(web.DHCPE.DHCPECommon).RegNoMask(QueryValue)
	s port=##Class(web.DHCPE.CRMYZ.SoCRMWSDLPort).%New()
	//GetReg(QueryPair As web.DHCPE.CRM.QueryPair) As web.DHCPE.CRM.RegInfos [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:intecheye.socrm.com", WebMethod ]
	s param=##Class(web.DHCPE.CRMYZ.QueryPair).%New()
	s param.QueryType=..CastCode(QueryType,1,"QTypeP")
	s param.QueryValue=QueryValue
	s param.QueryValue=$ZCVT(param.QueryValue,"O","UTF8")

	s param.Flag1=..CastCode(Flag,1,"Others")
	s strRegs=""
	s objRegs=port.GetReg(param)
	for i=1:1:objRegs.Count() {
		s objReg=objRegs.GetAt(i)
		s strReg=objReg.RID_"^"_objReg.CardId_"^"_$p(objReg.RegDate," ",1)
				_"^"_$p(objReg.RecordDate," ",1)_"^"_objReg.AsCharged_"^"_(..CastCode(objReg.Status,0,"RegStatus"))
				_"^"_objReg.PriceCount_"^"_objReg.PriceDiscount_"^"_objReg.PriceFinish
				_"^"_objReg.Truename
		i i'=1  s strRegs=strRegs_$C(1)
		s strRegs=strRegs_strReg 
	}
	s strRet=strRegs
	
	;s strRet=$tr(strRet,$C(1),$C(10))	
	q strRet
}

/// 获取个人体检项目明细
/// return: ***$C(1)ItemID^DepID^Quantity^crmOItemID$C(1)...
/// param:
/// 		RegId
ClassMethod GetExamItemsByRegId(RegId) As %String
{
	s strRet=""
	//s strRet="5||1^220^1^100"_((+RegId)#10)_$C(1)_"6||1^220^1^101"_((+RegId)#10) 
		//_$C(1)_"7||1^220^1^102"_((+RegId)#10)_$C(1)_"8||1^220^1^103"_((+RegId)#10)
		//_$C(1)_"9||1^220^1^104"_((+RegId)#10) 
	s ReceiveLocId=%session.Get("LOGON.CTLOCID")
	s port=##Class(web.DHCPE.CRMYZ.SoCRMWSDLPort).%New()
	// GetRegItem(QueryPair As web.DHCPE.CRM.QueryPair) As web.DHCPE.CRM.RegItems [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:intecheye.socrm.com", WebMethod ]
	s param=##Class(web.DHCPE.CRMYZ.QueryPair).%New()
	s param.QueryType="RID"
	s param.QueryValue=RegId
	s param.QueryValue=$ZCVT(param.QueryValue,"O","UTF8")
	s strItemIds=""
	s objItemIds=port.GetRegItem(param)
	for i=1:1:objItemIds.Count() {
		s objItemId=objItemIds.GetAt(i)
		s ReceiveLocId=##class(web.modFunction).GetRecLoc($p(objItemId.ItemId,"||",1))
		s ReceiveLocId=$p(ReceiveLocId,"^",1)
		i ReceiveLocId=""  s ReceiveLocId=%session.Get("LOGON.CTLOCID")
		s strItemId=objItemId.ItemId_"^"_ReceiveLocId_"^1^"_objItemId.IID
		i i'=1 s strItemIds=strItemIds_$C(1)
		s strItemIds=strItemIds_strItemId
	}
	s strRet=strItemIds
	
	;s strRet=$tr(strRet,$C(1),$C(10))	
	q strRet
}

/// 获取团体的预约信息
/// return: ***$C(1)GroupID^GroupRegId^GroupName^PreRegDate^RecordDate^DiscountLevel^Status^CountAmount^DiscountAmount^FinalAmount$C(1)...
/// param:
/// 		QueryType: paraValue的类型,“GROUPID”，“GROUPNAME”、“GRPREGID”
/// 		QueryValue: 具体的查询值
/// 		Flag:"ALL"-客人的所有记录;  "UNCOMPLETED"-客人未结束的体检预约记录，包括进行中和未开始的，及各状态。
ClassMethod GetGrpRegList(QueryType, QueryValue, Flag As %String) As %String
{
	s strRet=""
	//s strRet="10^100^东华合创^^^2^PREREG^10000^8800^8000"
			//_$C(1)_"11^101^中国电信^2006-6-6^2006-3-18^2^PREREG^5000^4400^4000"
			//_$C(1)_"12^102^中国石油^2006-6-6^2006-3-18^2^PREREG^5000^4400^4000"
	
	s port=##Class(web.DHCPE.CRMYZ.SoCRMWSDLPort).%New()
	//Method GetGroupReg(QueryPair As web.DHCPE.CRM.QueryPair) As web.DHCPE.CRM.GroupRegInfos [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:intecheye.socrm.com", WebMethod 
	s param=##Class(web.DHCPE.CRMYZ.QueryPair).%New()
	s param.QueryType=..CastCode(QueryType,1,"QTypeG")
	s param.QueryValue=QueryValue
	s param.QueryValue=$ZCVT(param.QueryValue,"O","UTF8")
	s param.Flag1=..CastCode(Flag,1,"Others")
	s strGRegs=""
	s objGRegs=port.GetCorpReg(param)
	for i=1:1:objGRegs.Count() {
		s objGReg=objGRegs.GetAt(i)
		s strGReg=objGReg.CID_"^"_objGReg.RID_"^"_objGReg.CorpName
				_"^"_$p(objGReg.RegDate," ",1)_"^"_$p(objGReg.RecordDate," ",1)_"^"_1
				_"^"_(..CastCode(objGReg.Status,0,"RegStatus"))_"^"_objGReg.PriceCount_"^"_objGReg.PriceDiscount
				_"^"_objGReg.PriceFinish
		i i'=1 s strGRegs=strGRegs_$c(1)
		s strGRegs=strGRegs_strGReg
	}
	s strRet=strGRegs
	
	;s strRet=$tr(strRet,$C(1),$C(10))	
	q strRet
}

/// 获取团体的分组信息
/// return: ***$C(1)GroupRegId^SmallGroupId^SmallGroupName$C(1)...
/// param:
/// 		GroupId 
ClassMethod GetSmallGrpByGrpRegId(GRegId) As %String
{
	s strRet=""
	//s strRet="100^1000^开发组" _ 
	//		$C(1)_"100^1001^QA组"  _ 
	//		$C(1)_"100^1002^领导组"  
	
	s port=##Class(web.DHCPE.CRMYZ.SoCRMWSDLPort).%New()
	//Method GetGroupRegMember(QueryPair As web.DHCPE.CRM.QueryPair) As web.DHCPE.CRM.SmallGroupRegs [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:intecheye.socrm.com", WebMethod ]
	s param=##Class(web.DHCPE.CRMYZ.QueryPair).%New()
	s param.QueryType="RID"
	s param.QueryValue=GRegId
	s param.QueryValue=$ZCVT(param.QueryValue,"O","UTF8")
	s strSGrps=""
	s objSGrps=port.GetCorpRegMember(param)
	for i=1:1:objSGrps.Count() {
		s objSGrp=objSGrps.GetAt(i)
		s strSGrp=GRegId_"^"_objSGrp.DID_"^"_objSGrp.DepartName
		i i'=1 s strSGrps=strSGrps_$c(1)
		s strSGrps=strSGrps_strSGrp
	}
	s strRet=strSGrps

	;s strRet=$tr(strRet,$C(1),$C(10))	
	q strRet
}

/// 获取团体的个人信息
/// return: ***$C(1)GroupRegId^SmallGroupId^AdmId$C(1)...
/// param:
/// 		CertNo 
ClassMethod GetMemberListByGrpRegId(GroupRegId) As %String
{
	s strRet=""
	//s strRet="100^1000^1101" _ 
	//		$C(1)_"100^1001^1102"  _ 
	//		$C(1)_"100^1002^1103"  
	
	s port=##Class(web.DHCPE.CRMYZ.SoCRMWSDLPort).%New()
	//Method GetGroupRegMember(QueryPair As web.DHCPE.CRM.QueryPair) As web.DHCPE.CRM.SmallGroupRegs [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:intecheye.socrm.com", WebMethod ]
	s param=##Class(web.DHCPE.CRMYZ.QueryPair).%New()
	s param.QueryType="RID"
	s param.QueryValue=GroupRegId
	s param.QueryValue=$ZCVT(param.QueryValue,"O","UTF8")
	s strRegs=""
	s objSGrps=port.GetCorpRegMember(param)
	for i=1:1:objSGrps.Count() {
		s objSGrp=objSGrps.GetAt(i)
		s objRegs=objSGrp.RegInfos
		for j=1:1:objRegs.Count() {
			s objReg=objRegs.GetAt(j)
			s strReg=GroupRegId_"^"_objSGrp.DID_"^"_objReg.RID
			i strRegs'="" s strRegs=strRegs_$c(1)
			s strRegs=strRegs_strReg
		}
	}
	s strRet=strRegs
	
	s strRet=$tr(strRet,$C(1),$C(10))	
	q strRet
}

/// 体检过程变更通知, 由his通知CRM系统
/// return: “OK”  成功;  “ERROR: XXX” 失败
/// param:
/// 		RegType: RegId的类型，"PERSON"-个人　"GROUP"-团体 
/// 		RegId: 个人或团体的RegId(AdmId)
/// 		NewStatus: 新状态 %String ：PREREG-预挂号;REGISTERED-登记;ARRIVED-审批;CHARGED-收费;COMPLETED-完成(报告完成)
/// 		AddtionInfo: 附加信息.一般情况下为""
ClassMethod ExamStatusNotify(QueryType, QueryValue, NewStatus, AdditionInfo = "") As %String
{
	s port=##Class(web.DHCPE.CRMYZ.SoCRMWSDLPort).%New()
	//Method ChangeRegStatus(QueryPair As web.DHCPE.CRM.QueryPair) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:intecheye.socrm.com", WebMethod ]
	s param=##Class(web.DHCPE.CRMYZ.QueryPair).%New()
	s param.QueryType=..CastCode(QueryType, 1, "Others")
	s param.QueryValue=QueryValue
	s param.QueryValue=$ZCVT(param.QueryValue,"O","UTF8")
	s param.Flag1=..CastCode(NewStatus,1,"RegStatus")
	s param.Flag2=AdditionInfo
	s strRet=port.ChangeRegStatus(param)
	
	s strRet="OK"
	i strRet=""  s strRet="ERROR: ExamStatusNotify failed when invoke webservice!"
	q strRet
}

/// 对一些标志性的值字符串，在His 同CRM之间的转换
/// param:
/// 		Is2CRM: 是否是从His到CRM, 1-是，　0－否
/// 		CodeType: 
/// 				"QTypeP"-查询个参数; "QTypeG"-查询团体参数;
/// 				"RegStatus"-挂号状态; "Gender"-性别; "Others"-其他
/// test: w ##Class(web.DHCPE.GatewayCRM).CastCode("HISCARDID",1,"QTypeP")
/// [Previously private]
ClassMethod CastCode(SourceCode, Is2CRM As %Integer, CodeType = "") As %String
{
	s MyStr("HIS","QTypeP")="HISCARDID^MID^CERTID^MOBILE^PATNAME^REGID"
	s MyStr("CRM","QTypeP")="CardId^MID^CertId^Mobile^Truename^RID"
	
	s MyStr("HIS","QTypeG")="GROUPID^GROUPNAME^GRPREGID"
	s MyStr("CRM","QTypeG")="CID^CoprName^RID"
	
	s MyStr("HIS","RegStatus")="PREREG^REGISTERED^ARRIVED^CHARGED^COMPLETED^MODIFIED"
	s MyStr("CRM","RegStatus")="PreReg^Registered^Arrived^Charged^Completed^Modified"
	
	s MyStr("HIS","Gender")="^男^女"
	s MyStr("CRM","Gender")="^M^F"
	
	s MyStr("HIS","Marital")="^已婚^未婚^离异"
	s MyStr("CRM","Marital")="^M^U^D"
	
	s MyStr("HIS","Others")="PERSON^GROUP^ALL^UNCOMPLETED"
	s MyStr("CRM","Others")="RID^RID^All^Uncompleted"
	i (Is2CRM=1) {
		s SourceStr=MyStr("HIS",CodeType)
		s DestStr=MyStr("CRM",CodeType)
	}
	else{
		s SourceStr=MyStr("CRM",CodeType)		
		s DestStr=MyStr("HIS",CodeType)
	}
	s DestCode=##Class(web.DHCPE.Public.Common).strGetMatchVal(SourceStr,DestStr,SourceCode)
	//s DestCode=$$strGetMatchVal^DHCPECommon(SourceStr,DestStr,SourceCode)
	
	q DestCode
}

ClassMethod test()
{
	W !,"<--TEST-->",##class(web.DHCPE.CRM.GatewayYZ).GetRegListByPatInf("PATNAME","%","ALL")
	W !,"<--TEST-->",##class(web.DHCPE.CRM.GatewayYZ).GetMemberByID("HISCARDID","11111111")
	W !,"<--TEST-->",##class(web.DHCPE.CRM.GatewayYZ).GetExamItemsByRegId("101")
	W !,"<--TEST-->",##class(web.DHCPE.CRM.GatewayYZ).GetGrpRegList("GROUPNAME","FISHJUMPING")
	W !,"<--TEST-->",##class(web.DHCPE.CRM.GatewayYZ).GetSmallGrpByGrpRegId("FISHJUMPING")
	W !,"<--TEST-->",##class(web.DHCPE.CRM.GatewayYZ).GetMemberListByGrpRegId("FISHJUMPING")
	W !,"<--TEST-->",##class(web.DHCPE.CRM.GatewayYZ).ExamStatusNotify("PERSON","101","ARRIVED")
}

}
