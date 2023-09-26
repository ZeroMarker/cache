/// created by SongDeBo 2006/6/13
/// Description: 取CRM的假数据,在没有其它真实接口时,测试用.
/// test: d ##class(web.DHCPE.CRM.GatewayConstant).test()
Class web.DHCPE.CRM.GatewayConstant Extends IGateway [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

Property ReceiveLocId As %String(TRUNCATE = 1) [ InitialExpression = "796" ];

/// 获取用户信息
/// return: ...$C(1)patId^patName^Birthday^mobileNO^Address^corporator^CertCardNO^Gender^level
/// 				^Marital^Email^Zip^BloodType^Profession^Title^Race$C(1)...
/// param:
/// 		QueryType: paraValue的类型,“HISCARDID”，“MID”、“CERTID”, “MOBILE”, "PATNAME"
/// 		QueryValue: 具体的查询值
ClassMethod GetMemberByID(QueryType, QueryValue) As %String
{
	
	s strRet=""
	s strRet="00000100^robert1^1978-4-4^1234^BOB ST.^DHC^420111780501401^男^1"_"^未婚^robert@gmail.com^100000^O^financial^CEO^han"
	i QueryValue="00000053"  s strRet="00000053^李芳^1978-4-4^1234^BOB ST.^DHC^420111780501401^男^1" _"^已婚^LF@gmail.com^100000^A^financial^CEO^hui"
	i QueryValue="00000040"  s strRet="00000040^胡华明z^1978-4-4^1234^BOB ST.^DHC^420111780501402^男^1" _"^未婚^HHM@gmail.com^100000^B^financial^CEO^Man"
	i QueryValue="00000099"  s strRet="00000099^李宁^1978-4-4^1234^BOB ST.^DHC^420111780501403^女^1" _"^未婚^LL@gmail.com^200000^AB^financial^CEO^han"
	i QueryValue="00000297"  s strRet="00000297^朱洪^1978-4-4^1234^BOB ST.^DHC^420111780501403^女^1" _"^已婚^ZH@gmail.com^100000^O^financial^CEO^han"
	i QueryValue="00000054"  s strRet="00000054^霓雪^1978-4-4^1234^BOB ST.^DHC^420111780501403^女^1" _"^已婚^NX@gmail.com^100000^O^financial^CEO^han"
	q strRet
}

/// 获取用户体检登记记录
/// return: ***$C(1)RegID^PatCardId^PreRegDate^RecordDate^IsAsCharged^Status^CountAmount^DiscountAmount^FinalAmount^PatNAME$C(1)...
/// param:
/// 		QueryType: paraValue的类型,“HISCARDID”，“MID”、“CERTID”, “MOBILENO”,"REGID","PATNAME"
/// 		QueryValue: 具体的查询值
/// 		Flag:"ALL"-客人的所有记录;  "UNCOMPLETED"-客人未结束的体检预约记录，包括进行中和未开始的。
ClassMethod GetRegListByPatInf(QueryType, QueryValue, Flag) As %String
{
	s strRet=""
	i QueryType="REGID" {
		s strRet="1100^00000100^2006-4-18^2005-3-1^0^PREREG^1000^880^800^robert1" 
		if QueryValue="1101"  s strRet="1101^00000053^2006-4-18^2005-3-1^1^PREREG^1000^880^800^李芳z" 
		if QueryValue="1102"  s strRet="1102^00000040^2006-4-18^2005-3-1^1^MODIFIED^1000^880^800^胡华明z" 
		if QueryValue="1103"  s strRet="1103^00000078^2006-4-18^2005-3-1^1^REGISTERED^1000^880^800^赵艳敏" 
		if QueryValue="1112"  s strRet="1112^00000099^2006-4-18^2005-3-1^1^PREREG^1000^880^800^李宁" 
		if QueryValue="1113"  s strRet="1113^00000297^2006-4-18^2005-3-1^1^PREREG^1000^880^800^朱洪" 
		if QueryValue="1114"  s strRet="1114^00000054^2006-4-18^2005-3-1^1^PREREG^1000^880^800^霓雪" 
	}
	else {
		s strRet="1100^00000100^2006-4-18^2005-3-1^0^PREREG^1000^880^800^robert1" 
				_$C(1)_"1112^00000099^2006-4-18^2005-3-1^1^PREREG^1000^440^400^李宁z"
				_$C(1)_"1113^00000297^2006-4-18^2005-3-1^1^PREREG^1000^880^800^朱洪" 
				_$C(1)_"1114^00000054^2006-4-18^2005-3-1^1^PREREG^1000^440^400^霓雪"
				_$C(1)_"1115^00000104^2006-4-18^2005-3-1^0^MODIFIED^1000^880^800^张子仪" 
				_$C(1)_"1116^00000105^2006-4-18^2005-3-1^0^REGISTERED^1000^440^400^张学友"
				_$C(1)_"1117^00000106^2006-4-18^2005-3-1^0^PREREG^1000^880^800^张作霖" 
				_$C(1)_"1118^00000107^2006-4-18^2005-3-1^0^PREREG^1000^440^400^张友学"
	}
	q strRet
}

/// 获取个人体检项目明细
/// return: ***$C(1)ItemID^DepID^Quantity^crmOItemID$C(1)...
/// param:
/// 		RegId
ClassMethod GetExamItemsByRegId(RegId) As %String
{
	s strRet=""
	s strRet="1||1^796^1^100"_((+RegId)#10000)
	  _$C(1)_"2||1^796^1^101"_((+RegId)#10000) 
	  _$C(1)_"6||1^796^1^105"_((+RegId)#10000)
	  _$C(1)_"8||1^796^1^106"_((+RegId)#10000)
	  _$C(1)_"10||1^796^1^107"_((+RegId)#10000)
	  _$C(1)_"11||1^796^1^108"_((+RegId)#10000)
	  _$C(1)_"13||1^796^1^109"_((+RegId)#10000)
	  _$C(1)_"49||1^796^1^110"_((+RegId)#10000)
	  _$C(1)_"50||1^796^1^111"_((+RegId)#10000)
	  _$C(1)_"104||1^796^1^112"_((+RegId)#10000)
	  _$C(1)_"106||1^796^1^113"_((+RegId)#10000)
	q strRet
}

/// 获取团体的预约信息
/// return: ***$C(1)GroupID^GroupRegId^GroupName^PreRegDate^RecordDate^DiscountLevel^Status^CountAmount^DiscountAmount^FinalAmount$C(1)...
/// param:
/// 		QueryType: paraValue的类型,“GROUPID”，“GROUPNAME”、“GRPREGID”
/// 		QueryValue: 具体的查询值
/// 		Flag:"ALL"-客人的所有记录;  "UNCOMPLETED"-客人未结束的体检预约记录，包括进行中和未开始的。
ClassMethod GetGrpRegList(QueryType, QueryValue, Flag) As %String
{
	s strRet=""
	//s strRet="10^100^东华合创^2006-6-1^2006-4-18^2^PREREG^10000^8800^8000" 
	if QueryType="GRPREGID"{
		s strRet="10^100^东华合创^2006-4-18^2006-4-18^2^PREREG^3000^2800^2000"
	}
	else{
		s strRet="10^100^东华合创1^2006-4-18^2006-4-18^2^PREREG^3000^2100^2000"
			_$C(1)_"11^101^中国电信^2006-4-18^2006-4-18^2^PREREG^5000^4400^4000"
			_$C(1)_"12^102^联想集团^2006-4-18^2006-4-18^2^PREREG^5000^4400^4000"
			_$C(1)_"14^104^华为^2006-4-18^2006-4-18^2^MODIFIED^5000^4400^4000"
			_$C(1)_"14^103^百度^2006-4-18^2006-4-18^2^REGISTERED^5000^4400^4000"
	}
	q strRet
}

/// 获取团体的分组信息
/// return: ***$C(1)GroupRegId^SmallGroupId^SmallGroupName$C(1)...
/// param:
/// 		GroupId 
ClassMethod GetSmallGrpByGrpRegId(GRegId) As %String
{
	s strRet=""
	s strRet="100^1000^开发组" _ 
			$C(1)_"100^1001^QA组"  _ 
			$C(1)_"100^1002^领导组"  
	q strRet
}

/// 获取团体的个人信息
/// return: ***$C(1)GroupRegId^SmallGroupId^AdmId$C(1)...
/// param:
/// 		CertNo 
ClassMethod GetMemberListByGrpRegId(GroupRegId) As %String
{
	s strRet=""
	s strRet="100^1000^1101" _ 
			$C(1)_"100^1001^1102"  _ 
			$C(1)_"100^1002^1103"  
	q strRet
}

/// 体检过程变更通知, 由his通知CRM系统
/// return: “OK”  成功;  “ERROR: XXX” 失败
/// param:
/// 		RegType: RegId的类型，"PERSON"-个人　"GROUP"-团体 
/// 		RegId: 个人或团体的RegId(AdmId)
/// 		NewStatus: 新状态 %String ：PREREG-预挂号;REGISTERED-登记;ARRIVED-到达;CHARGED-收费;COMPLETED-完成(报告完成)
/// 		AddtionInfo: 附加信息.一般情况下为""
ClassMethod ExamStatusNotify(RegType, RegId, NewStatus, AddtionInfo) As %String
{
	q "OK"
}

/// 对一些标志性的值字符串，在His 同CRM之间的转换
/// param:
/// 		Is2CRM: 是否是从His到CRM, 1-是，　0－否
/// 		CodeType: 
/// 				"QTypeP"-查询个参数; "QTypeG"-查询团体参数;
/// 				"RegStatus"-挂号状态; "Gender"-性别; "Others"-其他
/// [Previously private]
ClassMethod CastCode(SourceCode, Is2CRM As %Integer, CodeType As %String = "") As %String
{
	s MyStr("HIS","QTypeP")="HISCARDID^MID^CERTID^MOBILE^PATNAME^REGID"
	s MyStr("CRM","QTypeP")="CardId^MID^CertId^Mobile^TrueName^RID"
	
	s MyStr("HIS","QTypeG")="GROUPID^GROUPNAME^GRPREGID"
	s MyStr("CRM","QTypeG")="GID^GroupName^RID"

	s MyStr("HIS","RegStatus")="PREREG^REGISTERED^ARRIVED^CHARGED^COMPLETED^MODIFIED"
	s MyStr("CRM","RegStatus")="PreReg^Registered^Arrived^Charged^Completed^Modified"
	
	s MyStr("HIS","Gender")="^男^女"
	s MyStr("CRM","Gender")="^M^F"
	
	s MyStr("HIS","Others")="PERSON^GROUP^ALL^UNCOMPLETED"
	s MyStr("CRM","Others")="Person^Group^All^Uncompleted"
	b
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
	W !,"<--TEST-->",##Class(web.DHCPE.CRM.GatewayConstant).GetRegListByPatInf("HISCARDID","101","ALL")
	W !,"<--TEST-->",##Class(web.DHCPE.CRM.GatewayConstant).GetMemberByID("HISCARDID","101")
	W !,"<--TEST-->",##Class(web.DHCPE.CRM.GatewayConstant).GetExamItemsByRegId("101")
	W !,"<--TEST-->",##Class(web.DHCPE.CRM.GatewayConstant).GetGrpRegList("GROUPNAME","FISHJUMPING")
	W !,"<--TEST-->",##Class(web.DHCPE.CRM.GatewayConstant).GetSmallGrpByGrpRegId("FISHJUMPING")
	W !,"<--TEST-->",##Class(web.DHCPE.CRM.GatewayConstant).GetMemberListByGrpRegId("FISHJUMPING")
	W !,"<--TEST-->",##Class(web.DHCPE.CRM.GatewayConstant).ExamStatusNotify("101","ARRIVED")
}

}
