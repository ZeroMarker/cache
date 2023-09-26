/// Created By SongDeBo 2006/6/13
/// Description: 访问东华自己CRM系统的入口
Class web.DHCPE.CRM.GatewayDHC Extends web.DHCPE.CRM.IGateway [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

/// 获取用户信息
/// return: ...$C(1)patId^patName^Birthday^mobileNO^Address^corporator^CertCardNO^Gender^level
/// 				^Marital^Email^Zip^BloodType^Profession^Title^Race$C(1)...
/// param:
/// 		QueryType: paraValue的类型,“HISCARDID”,“MID”、“CERTID”, “MOBILE”, "PATNAME"
/// 		QueryValue: 具体的查询值/// 
ClassMethod GetMemberByID(QueryType, QueryValue) As %String
{
	
	s ^lisatest("0905","GetMemberByID")=QueryType_"^"_QueryValue
	s strRet="",strAll=""
	i QueryType="HISCARDID"  s QueryValue=##class(web.DHCPE.DHCPECommon).RegNoMask(QueryValue)
	//s strRet="00000100^robert1^1978-4-4^1234^BOB ST.^DHC^420111780501401^男^1^M^01robert@163.com^100000^0^IT^Manager^Han" 
			//_"$C(1)..."
	
	s SourceSpec= "PAPMINo^Name^Sex_DR^DOB^PatType_DR^Tel1^Tel2^MobilePhone^IDCard^Vocation^Position^Company^Postalcode^Address^Nation^Email^Married_DR^Blood_DR^UpdateDate^UpdateUser_DR"
	s result=##class(web.DHCPE.PreIBaseInfo).QueryRST(QueryType, QueryValue)
	//For  Quit:'result.Next()  Do
	b //0724result
	For  Quit:'result.Next()  do  //0718-quit2
	.   s myId=result.Data("RowId")
	.   s myData=^DHCPEPreIBI(myId)
	.   ;GlobalSpec = "PAPMINo^Name^Sex_DR^DOB^PatType_DR^Tel1^Tel2^MobilePhone^IDCard^Vocation^Position^Company^Postalcode^Address^Nation^Email^Married_DR^Blood_DR^UpdateDate^UpdateUser_DR";
	.   //s targetSpec="_patId^Name^DOB^MobilePhone^Address^Company^IDCard^Sex_DR^^Married_DR^Email^Postalcode^Blood_DR^Vocation^Position^Nation"
	.   //
	.   //Modified by MLH0720
	.   s targetSpec="PAPMINo^Name^DOB^MobilePhone^Address^Company^IDCard^Sex_DR^^Married_DR^Email^Postalcode^Blood_DR^Vocation^Position^Nation"
	.   s myData=##Class(web.DHCPE.Public.Common).strReArrange(myData,SourceSpec,targetSpec,"^")
	.   //s myData=$$strReArrange^DHCPECommon(myData,SourceSpec,targetSpec,"^")
	.   b //0720
	.   s mySex="",myMarity="",myBloodType="", myBirthday=0
	.   s myPAPMINo=$p(myData,"^",1) //Add by MLH 0720
	.   s mySexId=$p(myData,"^",9)
	.   s myMarityId=$p(myData,"^",10)
	.   s myBirthday=$p(myData,"^",3)
	.   s myBloodTypeId=$p(myData,"^",13)
	.   i mySexId'=""  s mySex=$p($g(^CT("SEX",mySexId)),"^",1)
	.   i myMarityId'=""  s myMarity=$p($g(^CT("MAR",myMarityId)),"^",1)
	.   i myBirthday=""  s myBirthday=0
	.   s myBirthday=$zd(myBirthday,3)
	.   i myBloodTypeId'=""  s myBloodType=$p($g(^PAC("BLDT",myBloodTypeId)),"^",1)
	.   s $p(myData,"^",9)=mySex
	.   s $p(myData,"^",10)=myMarity
	.   s $p(myData,"^",3)=myBirthday
	.   s $p(myData,"^",13)= myBloodType
	.   //s $p(myData,"^",1)=myId
	.   s $p(myData,"^",1)=myPAPMINo  //Modified by MLH 0720
	.   
	.	i strAll'=""  s strAll=strAll_$C(1)
	.	s strAll=strAll_myData
	
	s retStr=strAll
	;s retStr=$tr(retStr,$C(1),$C(10))	
	//b //GetMemberByID 0719
	q retStr
}

/// 获取用户体检登记记录
/// return: ***$C(1)RegID^PatCardId^PreRegDate^RecordDate^IsAsCharged^Status^CountAmount^DiscountAmount^FinalAmount^PatNAME$C(1)...
/// param:
/// 		QueryType: paraValue的类型,“HISCARDID”，“MID”、“CERTID”, “MOBILE”,"REGID","PATNAME"
/// 		QueryValue: 具体的查询值
/// 		Flag:  "ALL"-客人的所有记录;  
/// 				"UNCOMPLETED"-客人未结束的体检预约记录，包括进行中和未开始的。及各状态。
/// 				Else: 其他具体的状态
/// s Ret=##class(web.DHCPE.CRM.GatewayDHC).GetRegListByPatInf("PATNAME","","UNCOMPLETED")
ClassMethod GetRegListByPatInfOld(QueryType, QueryValue, Flag = "ALL") As %String
{
	s strRet="", strAll=""
	//s strRet="1001^00000100^2006-3-20^2005-3-1^1^PREREG^1000^880^800^PatName1" _$C(1)_"101^00000101^2006-3-20^2005-3-1^1^PREREG^500^440^400^PatName"
	i QueryType="HISCARDID"  s QueryValue=##class(web.DHCPE.DHCPECommon).RegNoMask(QueryValue)
	s SourceSpec= "PIBI_DR^PGADM_DR^PGTeam_DR^PEDate^PETime^PEDeskClerk_DR^Status^AsCharged^AccountAmount^DiscountedAmount^FactAmount^AuditUser_DR^AuditDate^UpdateUser_DR^UpdateDate"
	s TargetSpec="_RegID^_PatCardId^PEDate^UpdateDate^AsCharged^Status^AccountAmount^DiscountedAmount^FactAmount^_PatNAME^PGADM_DR^PGTeam_DR"
	//s StatusList=$S(Flag="ALL":"^CHECKED^REGISTERED^COMPLETED^",Flag="UNCOMPLETED":"^CHECKED^REGISTERED",1:"")
	//s StatusList=$S(Flag="ALL":"^CHECKED^REGISTERED^COMPLETED^",Flag="UNCOMPLETED":"^CHECKED^UNCHECKED^REGISTERED",1:"",Flag="ARRIVED":)
	s StatusList=$S(Flag="ALL":"^CHECKED^NOCHECKED^REGISTERED^COMPLETED^PREREG",Flag="UNCOMPLETED":"^CHECKED^NOCHECKED^PREREG",1:"")
	i $g(StatusList)="" s StatusList=..CastCode(Flag, 1, "RegStatus")
	
	s i=0
	s ^lisatest("0313","GetRegListByPatInf")=QueryType_"^"_QueryValue
	s result=##class(web.DHCPE.CRM.GatewayDHC).QueryRST(QueryType, QueryValue)
	For  Quit:'result.Next()  Do //0718-quit1
	.   s myPatId=result.Data("RowId")
	.	s ^lisatest("0313","result","myPatId")=myPatId
	.   s myRegId="0"
	.   s myHisCardId=$p(^DHCPEPreIBI(myPatId),"^",1)
	.   s myPatName=$p(^DHCPEPreIBI(myPatId),"^",2)
	.   s i=i+100
	.   for  s myRegId=$o(^DHCPEPreIADM(0,"PIBI",myPatId,myRegId))  q:myRegId=""  d
	.   .   s myDataReg=^DHCPEPreIADM(myRegId)
	.   .   s GADM=$p(myDataReg,"^",2)   //mlh
	.   .   //q:$g(GADM)'=""   //mlh0305
	.   .   s myData=##Class(web.DHCPE.Public.Common).strReArrange(myDataReg,SourceSpec,TargetSpec,"^")
	.   .   //s myData=$$strReArrange^DHCPECommon(myDataReg,SourceSpec,TargetSpec,"^")
	.   .   s myCheckStatus=$p(myData,"^",18)  //mlh0313
	.   .   q:StatusList'[myCheckStatus	
	.   .   b //mlh0313 111
	.   .   //i myStatus="NOCHECKED" D  B //MLH0905
	.   .   s myRegStatus=$p(myData,"^",6)
	.   .   q:StatusList'[myRegStatus	
	.   .   s ^lisatest("0314","Statu",myPatId)=myCheckStatus_"^"_myRegStatus
	.   .   s ^lisatest("0314","myData",myPatId)=myData
	.   .   b //mlh0313 222
	.   .   s myAsCharged=$p(myData,"^",5)
	.   .   s myPEData=$p(myData,"^",3)
	.   .   s myUpdateDate=$p(myData,"^",4)
	.   .   //s myPGADMDR=$p(myData,"^",11)
	.   .   s myAsCharged=$s(myAsCharged="Y":1,myAsCharged="N":0,1:1)
	.   .   i myPEData="" s myPEData=0
	.   .   s myPEData=$zd(myPEData,3)
	.   .   i myUpdateDate="" s myUpdateDate=0
	.   .   s myUpdateDate=$zd(myUpdateDate,3)
	.   .   s $p(myData,"^",5)=myAsCharged
	.   .   s $p(myData,"^",3)=myPEData
	.   .   s $p(myData,"^",4)=myUpdateDate
	.   .   s $p(myData,"^",1)=myRegId
	.   .   s $p(myData,"^",2)=myHisCardId
	.   .   s $p(myData,"^",10)=myPatName
	.   .   s $p(myData,"^",11)=GADM
	.   .   b //mlh0313 333
	.	. 	i strAll'=""  s strAll=strAll_$C(1)
	.	.	s strAll=strAll_myData 
	.	.	s i=i+1
	
	//w "i="_i
	s strRet=strAll
	;s strRet=$tr(strRet,$C(1),$C(10))	
	s ^lisatest("0905","GetRegListByPatInf")=strRet
	//b  //0724//GetRegListByPatInf222222222222
	q strRet
}

/// 获取个人体检项目明细
/// DHC_PE_PreIOrdItem.{PIOI_ItmMast_DR}^$G(%session.Get("LOGON.CTLOCID"))^1^DHC_PE_PreIOrdItem.{PIOI_RowId}
/// return: ***$C(1)ItemID^DepID^Quantity^crmOItemID$C(1)...
/// param:
/// 		RegId
ClassMethod GetExamItemsByRegIdAZ(RegId) As %String
{
	s strRet=""
	s ReceiveLocId=%session.Get("LOGON.CTLOCID")
	
	s strAll=""
	s myChildId="0"
	for  s myChildId=$o(^DHCPEPreIADM(RegId,"ORDITEM",myChildId))  q:myChildId=""  d
	.	
	.q:$p($g(^DHCPEPreIADM(RegId,"ORDITEM",myChildId)),"^",16)'=1	//判断是否有效
	.q:$o(^DHCPECRMO(0,"CRMORI",RegId_"||"_myChildId,0))'=""
	.s myData=^DHCPEPreIADM(RegId,"ORDITEM",myChildId)
	.s myItemId=$p(myData,"^",1)
	.s myCRMOItemId=RegId_"||"_myChildId
	.s myItemDesc=$P(^ARCIM($P(myItemId,"||",1),$P(myItemId,"||",2),1),"^",2)
	.s LabItemCode="",Specimen="",SpecimenDesc=""
	.s LabItemCode=..GetLabCode(myItemId)
	.i LabItemCode'="" Do
	..//Modified by MLH 2008-01-21
	..s SPEC=$G(^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",myCRMOItemId))
	..s SpecimenDesc=$p(SPEC,"^",2)
	.q:((myItemDesc["TLA")&(SpecimenDesc="血"))
	.s myData=myItemId_"^"_ReceiveLocId_"^1^"_myCRMOItemId
	.i strAll'="" s strAll=strAll_$C(1)
	.s strAll=strAll_myData
	s strAll=strAll_$C(2)
	
	for  s myChildId=$o(^DHCPEPreIADM(RegId,"ORDITEM",myChildId))  q:myChildId=""  d
	.q:$p($g(^DHCPEPreIADM(RegId,"ORDITEM",myChildId)),"^",16)'=1	//判断是否有效
	.q:$o(^DHCPECRMO(0,"CRMORI",RegId_"||"_myChildId,0))'=""
	.s myData=^DHCPEPreIADM(RegId,"ORDITEM",myChildId)
	.s myItemId=$p(myData,"^",1)
	.s myCRMOItemId=RegId_"||"_myChildId
	.s myItemDesc=$P(^ARCIM($P(myItemId,"||",1),$P(myItemId,"||",2),1),"^",2)
	.s LabItemCode="",Specimen="",SpecimenDesc=""
	.s LabItemCode=..GetLabCode(myItemId)
	.i LabItemCode'="" Do
	..s SPEC=$G(^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",myCRMOItemId))
	..s SpecimenDesc=$p(SPEC,"^",2)
	.q:((myItemDesc'["TLA")||((myItemDesc["TLA")&(SpecimenDesc'="血")))
	.s myCRMOItemId=RegId_"||"_myChildId
	.s myData=myItemId_"^"_ReceiveLocId_"^1^"_myCRMOItemId
	.i strAll'="" s strAll=strAll_$C(1)
	.s strAll=strAll_myData
	s strRet=strAll
	
	q strRet
}

ClassMethod GetExamItemsByRegId(RegId) As %String
{
	s strRet=""
	s:$d(%session) ReceiveLocId=%session.Get("LOGON.CTLOCID")
	s:'$d(%session) ReceiveLocId=572
	//s ReceiveLocId=%session.Get("LOGON.CTLOCID")
	
	s strAll=""
	s myChildId="0"
	for  s myChildId=$o(^DHCPEPreIADM(RegId,"ORDITEM",myChildId))  q:myChildId=""  d
	.	
	.	q:$p($g(^DHCPEPreIADM(RegId,"ORDITEM",myChildId)),"^",16)'=1	//判断是否有效
	.	
	.	s myData=^DHCPEPreIADM(RegId,"ORDITEM",myChildId)
	.	s myItemId=$p(myData,"^",1)
	.	s myCRMOItemId=RegId_"||"_myChildId
	.	s myData=myItemId_"^"_ReceiveLocId_"^1^"_myCRMOItemId
	.	i strAll'="" s strAll=strAll_$C(1)
	.	s strAll=strAll_myData
	
	s strRet=strAll
	
	;s strRet=$tr(strRet,$C(1),$C(10))	
	q strRet
}

/// 获取团体的预约信息
/// return: ***$C(1)GroupID^GroupRegId^GroupName^PreRegDate^RecordDate^DiscountLevel^Status^CountAmount^DiscountAmount^FinalAmount$C(1)...
/// param:
/// 		QueryType: paraValue的类型,“GROUPID”，“GROUPNAME”、“GRPREGID”
/// 		QueryValue: 具体的查询值
/// 		Flag:"ALL"-客人的所有记录;  "UNCOMPLETED"-客人未结束的体检预约记录，包括进行中和未开始的，及各状态。
ClassMethod GetGrpRegListOld(QueryType, QueryValue, Flag) As %String
{
	s strRet="", strAll=""
	//s strRet="10^100^东华合创^^^2^PREREG^10000^8800^8000"
			//_$C(1)_"11^101^中国电信^2006-6-6^2006-3-18^2^PREREG^5000^4400^4000"
			//_$C(1)_"12^102^中国石油^2006-6-6^2006-3-18^2^PREREG^5000^4400^4000"
	s SourceSpec=""
	s TargetSpec=""
	s StatusList=$S(Flag="ALL":"^CHECKED^REGISTERED^COMPLETED^",Flag="UNCOMPLETED":"^CHECKED^REGISTERED",1:"")
	i $g(StatusList)="" s StatusList=..CastCode(Flag, 1, "RegStatus")
	
	s i=0
	s result=##class(web.DHCPE.PreGBaseInfo).QueryRST(QueryType, QueryValue)
	For  Quit:'result.Next()  Do
	.	s myGrpId=result.Data("RowId")
	.	s myGrpData=^DHCPEPreGBI(myGrpId)
	.	s myGrpName=$p(myGrpData,"^",2)
	.	s myRegId="0"
	.	f  s myRegId=$o(^DHCPEPreGADM(0,"PGBI",myGrpId,myRegId))  q:myRegId=""  d
	.	.  s myRegData=^DHCPEPreGADM(myRegId)
	.	.  s myStatus=$p(myRegData,"^",7)
	.	.  //b
	.	.  q:StatusList'[myStatus
	.	.  s myRecordDate=$p(myRegData,"^",14)
	.	.  s myPreRegDate=$p(myRegData,"^",3)
	.	.  s myCountAmount=$p(myRegData,"^",8)
	.	.  s myDiscountAmount=$p(myRegData,"^",9)
	.	.  s myFactAmount=$p(myRegData,"^",10)
	.	.  i myRecordDate=""  s myRecordDate=0
	.	.  i myPreRegDate=""  s myPreRegDate=0
	.	.  s myRecordDate=$zd(myRecordDate,3)
	.	.  s myPreRegDate=$zd(myPreRegDate,3)
	.	.  s myData=myGrpId_"^"_myRegId_"^"_myGrpName_"^"_myPreRegDate_"^"_myRecordDate_"^1^"_myStatus_"^"_myCountAmount_"^"_myDiscountAmount_"^"_myFactAmount
	.	.  i strAll'="" s strAll=strAll_$c(1)
	.	.  s strAll=strAll_myData
	
	s strRet=strAll
	
	;s strRet=$tr(strRet,$C(1),$C(10))	
	q strRet
}

/// 获取团体的分组信息
/// return: ***$C(1)GroupRegId^SmallGroupId^SmallGroupName$C(1)...
/// param:
/// 		GroupId 
ClassMethod GetSmallGrpByGrpRegId(GRegId) As %String
{
	s strRet="",strAll=""
	//s strRet="100^1000^开发组" _ 
	//		$C(1)_"100^1001^QA组"  _ 
	//		$C(1)_"100^1002^领导组"  
	
	s myChildId="0"
	for  s myChildId=$o(^DHCPEPreGADM(GRegId,"Team",myChildId))  q:myChildId=""  d
	.	s myDataOrg=^DHCPEPreGADM(GRegId,"Team",myChildId)
	.	s myData=GRegId_"^"_GRegId_"||"_myChildId_"^"_$p(myDataOrg,"^",1)
	.	i strAll'="" s strAll=strAll_$c(1)
	.	s strAll=strAll_myData
		
	s strRet=strAll

	;s strRet=$tr(strRet,$C(1),$C(10))
	q strRet
}

/// 获取团体的个人信息
/// return: ***$C(1)GroupRegId^SmallGroupId^AdmId$C(1)...
/// param:
/// 		CertNo 
ClassMethod GetMemberListByGrpRegId(GRegId) As %String
{
	s strRet="",strAll=""
	//s strRet="100^1000^1101" _ 
	//		$C(1)_"100^1001^1102"  _ 
	//		$C(1)_"100^1002^1103"  
		
	s myTeamId="0"
	for  s myTeamId=$o(^DHCPEPreGADM(GRegId,"Team",myTeamId))  q:myTeamId=""  d
	.	s myIAdmId="0"
	.	for  s myIAdmId=$o(^DHCPEPreIADM(0,"PGTeam",GRegId_"||"_myTeamId,myIAdmId))  q:myIAdmId=""  d
	.	.   s myData=GRegId_"^"_GRegId_"||"_myTeamId_"^"_myIAdmId
	.	.	i strAll'=""  d
	.	.	. //b //strAll 
	.	.	. s strAll=strAll_$c(1)
	.	.	s strAll=strAll_myData
		
	s strRet=strAll
	//b //0724GetMemberListByGrpRegId
	;s strRet=$tr(strRet,$C(1),$C(10))
	q strRet
}

// add by MLH 2008-05-07  

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
	s MyStr("HIS","RegStatus")="PREREG^REGISTERED^ARRIVED^CHARGED^COMPLETED^MODIFIED"
	s MyStr("CRM","RegStatus")="CHECKED^REGISTERED^REGISTERED^REGISTERED^COMPLETED^MODIFIED"

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

/// Description: 根据查询条件取PreIBAseInfo的ResultSet
/// Paremeter:
/// 		QueryType: “HISCARDID”/“CERTID”/ “MOBILE”/ "PATNAME"/"REGID"
/// 		QueryValue: 对就QueryType的值
/// Return: A %ResultSet object
ClassMethod QueryRST(QueryType, QueryValue) As %ResultSet
{
	//s ^lisatest("0313","QueryRST")=QueryType_"@"_QueryValue
	s sqlCondition=""
	b //QueryRST-222-0718
	if (QueryType="REGID"){
		s sqlStr="select distinct piadm_pibi_dr as RowId from dhc_pe_preiadm where piadm_rowid="_QueryValue
	}
	else {
		s sqlCondition=$select(
			QueryType="HISCARDID":" PIBI_PAPMINo='"_QueryValue_"'",
			QueryType="CERTID":" PIBI_IDCard='"_QueryValue_"'",
			QueryType="MOBILE":" PIBI_MobilePhone='"_QueryValue_"'",
			QueryType="PATNAME":" PIBI_Name like '"_QueryValue_"%'",
			1:"")
		q:sqlCondition="" "Error: Arguments is wrong, in "_$zn	
		s sqlStr="select PIBI_RowId as RowId from dhc_pe_preibaseinfo where "_sqlCondition
		b //QueryRST-333-0718
	}
	b //QueryRST-111-0718
	s retRST=##class(%ResultSet).%New()
	d retRST.Prepare(sqlStr)
	d retRST.Execute()
	b ////QueryRST-444-0718
	q retRST
}

ClassMethod test()
{
	W !,"<--TEST-->",##class(web.DHCPE.CRM.GatewayDHC).GetRegListByPatInf("HISCARDID","00000011","ALL")
	W !,"<--TEST-->",##class(web.DHCPE.CRM.GatewayDHC).GetMemberByID("HISCARDID","00000011")
	W !,"<--TEST-->",##class(web.DHCPE.CRM.GatewayDHC).GetExamItemsByRegId("101")
	W !,"<--TEST-->",##class(web.DHCPE.CRM.GatewayDHC).GetGrpRegList("GRPREGID","4","UNCOMPLETED")
	W !,"<--TEST-->",##class(web.DHCPE.CRM.GatewayDHC).GetSmallGrpByGrpRegId("15")
	W !,"<--TEST-->",##class(web.DHCPE.CRM.GatewayDHC).GetMemberListByGrpRegId("15")
	W !,"<--TEST-->",##class(web.DHCPE.CRM.GatewayDHC).ExamStatusNotify("PERSON","30","ARRIVED")
}

/// ******************************************************************
/// add by jdl
/// 从CRM中将团体登记信息转换到团体登记相关表中
/// 即生成DHC_PE_GBaseInfo，DHC_PE_GAdm，DHC_PE_Report，DHC_PE_GTEAM信息
/// QueryValue：输入DHC_PE_PregBaseInfo->PGBI_RowId
/// GBaseInfoId:输出DHC_PE_GBaseInfo->GBI_RowId
/// GAdmId:输出DHC_PE_GAdm->GADM_RowID
Method TransGInfoFromCRM(QueryValue, GBaseInfoId, GAdmId)
{
	s err=""
	
	if (QueryValue="") 
	{ s err= "没有传入团体预约号!"
		goto TransGInfoFromCRMErr}
	s preGBaseInfoId=$p($g(^DHCPEPreGADM(QueryValue)),"^",1)
	if (preGBaseInfoId="") 
	{ s err= "没有找到相应的团体客户基本信息!"
		goto TransGInfoFromCRMErr}
	
	s GBaseInfoId=$o(^DHCPEGBI(0,"CRMNo",preGBaseInfoId,""))
	if GBaseInfoId=""
	{
		/*
		&SQL(select PGBI_RowId,PGBI_Code,PGBI_Desc,PGBI_Address,PGBI_Postalcode,PGBI_Linkman1,PGBI_Bank,PGBI_Account,PGBI_Tel1,PGBI_Tel2,PGBI_Email,PGBI_Linkman2,PGBI_FAX,PGBI_PAPMINo,PGBI_CRM_DR into 
				:RowId,:Code,:Desc,:Address,:Postalcode,:Linkman1,:Bank,:Account,:Tel1,:Tel2,:Email,:Linkman2,:FAX,:PAPMINo,:CRMDR
			from SQLUser.DHC_PE_PregBaseInfo Where PGBI_RowId=:preGBaseInfoId)
		if SQLCODE 
		{ s err="没有找到团体预约基本信息!"
			goto TransGInfoFromCRMErr}
	
		&SQL(Insert Into SQLUser.DHC_PE_GBaseInfo
			(GBI_Code,GBI_Desc,GBI_Address,GBI_PostalCode,GBI_Linkman1,GBI_Bank,GBI_Account,GBI_Tel1,GBI_Tel2,GBI_Email,GBI_CRM)
			values(:Code,:Desc,:Address,:Postalcode,:Linkman1,:Bank,:Account,:Tel1,:Tel2,:Email,:preGBaseInfoId)
			)
		if SQLCODE 
		{ s err="生成团体客户基本信息失败!"_SQLCODE
			goto TransGInfoFromCRMErr}
		s GBaseInfoId=%ROWID
		*/
		s err="没有找到团体基本信息!"
		goto TransGInfoFromCRMErr
	}
	s AdmDate=+$h
	s AdmTime=+$p($h,",",2)
	s AsCharged=$p($g(^DHCPEPreGADM(QueryValue)),"^",7)
	s AddOrdItem=$p($g(^DHCPEPreGADM(QueryValue)),"^",8)
	s AddOrdItemLimit=$p($g(^DHCPEPreGADM(QueryValue)),"^",9)
	s AddOrdItemAmount=$p($g(^DHCPEPreGADM(QueryValue)),"^",10)
	s AddPhcItem=$p($g(^DHCPEPreGADM(QueryValue)),"^",11)
	s AddPhcItemLimit=$p($g(^DHCPEPreGADM(QueryValue)),"^",12)
	s AddPhcItemAmount=$p($g(^DHCPEPreGADM(QueryValue)),"^",13)
	s DisChargedMode=$p($g(^DHCPEPreGADM(QueryValue)),"^",16)
	s Remark=$p($g(^DHCPEPreGADM(QueryValue)),"^",18)

	//s DiscountLevel =1
	//s ContractNo=$p($g(^DHCPEPreGADM(QueryValue)),"^",6)
	//s AccountAmount =$p($g(^DHCPEPreGADM(QueryValue)),"^",8)
	//s DiscountedAmount =$p($g(^DHCPEPreGADM(QueryValue)),"^",9)
	//s FactAmount =$p($g(^DHCPEPreGADM(QueryValue)),"^",10)
	s GBIDR=GBaseInfoId
	s Status ="ARRIVED"
	s CRMGADM=QueryValue
	;b "before insert GAdm"
	&SQL(Insert Into SQLUser.DHC_PE_GAdm 
		(GADM_GBI_DR,GADM_AdmDate,GADM_AdmTime,GADM_CRMGADM,GADM_Status,GADM_AsCharged,GADM_AddOrdItem,GADM_AddOrdItemLimit,GADM_AddOrdItemAmount,GADM_AddPhcItem,GADM_AddPhcItemLimit,GADM_AddPhcItemAmount,GADM_DisChargedMode,GADM_Remark)
		values (:GBIDR,:AdmDate,:AdmTime,:CRMGADM,:Status,:AsCharged,:AddOrdItem,:AddOrdItemLimit,:AddOrdItemAmount,:AddPhcItem,:AddPhcItemLimit,:AddPhcItemAmount,:DisChargedMode,:Remark)
		)
	if SQLCODE 
	{ s err= "生成团体客户登记信息失败!"_SQLCODE
		goto TransGInfoFromCRMErr}
	s GAdmId=%ROWID
	;b "before insert report"
	&SQL(Insert Into sqluser.dhc_pe_report 
			(RPT_GADM_DR,RPT_Status)
		values(:GAdmId,'NA')
	)
	if SQLCODE
	{ s err="生成团体客户报告记录失败!"_SQLCODE
		goto TransGInfoFromCRMErr}
		
	//根据预约组信息生成登记组信息	
	&SQL(insert into SQLUSER.dhc_pe_GTEAM 
			(GT_ParRef, GT_Desc, GT_CRMTeam,GT_AddOrdItem,GT_AddOrdItemLimit,GT_AddOrdItemAmount,GT_AddPhcItem,GT_AddPhcItemLimit,GT_AddPhcItemAmount,GT_Sex,GT_UpperLimit,GT_LowerLimit,GT_Married)
		 select :GAdmId,PGT_Desc,PGT_RowId,PGT_AddOrdItem,PGT_AddOrdItemLimit,PGT_AddOrdItemAmount,PGT_AddPhcItem,PGT_AddPhcItemLimit,PGT_AddPhcItemAmount,PGT_Sex,PGT_UpperLimit,PGT_LowerLimit,PGT_Married
		  from SQLUSER.DHC_PE_PreGTeam
		   Where PGT_ParRef=:CRMGADM 
		   and PGT_RowId not in (Select GT_CRMTeam from SQLUSER.dhc_pe_GTEAM where GT_ParRef=:GAdmId) )
	if SQLCODE<0
	{ s err="生成团体分组登记信息失败!"_SQLCODE
		goto TransGInfoFromCRMErr}
	&SQL(Update sqluser.DHC_PE_PreAudit set PA_GIADM=:GAdmId Where PA_ADMType='G' and PA_CRMADM=:CRMGADM)
	if SQLCODE<0 
	{s err="更新预约审核记录失败"
		goto TransGInfoFromCRMErr}
	q err	
TransGInfoFromCRMErr
	q err
}

ClassMethod CancelGBaseInfo(QueryValue)
{
	s GAdmId=""
	s ret=""
	&SQL(Select GADM_RowID into :GAdmId from SQLUser.DHC_PE_GAdm Where GADM_CRMGADM=:QueryValue)
	if GAdmId="" q "not find PE_GAdm"
	
	&SQL(Delete from SQLUSER.dhc_pe_GTEAM  Where GT_ParRef=:GAdmId)	
	s ret="GTEAM Rows="_%ROWCOUNT
	&SQL(Delete from sqluser.dhc_pe_report Where RPT_GADM_DR=:GAdmId)
	s ret=ret_" ,Report Rows="_%ROWCOUNT
	&SQL(Delete from sqluser.DHC_PE_GAdm Where GADM_RowID=:GAdmId)
	s ret=ret_" ,GAdm Rows="_%ROWCOUNT
	&SQL(Update sqluser.DHC_PE_PreGADM set PGADM_Status='PREREG' Where PGADM_RowId=:QueryValue)
	s ret=ret_" ,PreGADM Rows="_%ROWCOUNT
	q ret
}

ClassMethod CancelIBaseInfo(QueryValue)
{
	s IAdmId=""
	s ret=""
	&SQL(Select IADM_RowID into :IAdmId from SQLUser.DHC_PE_IAdm Where IADM_CRMADM=:QueryValue)
	if IAdmId="" q "not find PE_IAdm"
	
	&SQL(Delete from sqluser.dhc_pe_report Where RPT_IADM_DR=:IAdmId)
	s ret=ret_" ,Report Rows="_%ROWCOUNT
	&SQL(Delete from sqluser.DHC_PE_CrmOrder Where crmo_iadm_dr=:IAdmId)
	s ret=ret_" ,CrmOrder Rows="_%ROWCOUNT
	&SQL(Delete from sqluser.DHC_PE_IAdm Where IADM_RowID=:IAdmId)
	s ret=ret_" ,IAdm Rows="_%ROWCOUNT
	&SQL(Update sqluser.DHC_PE_PreIADM set PIADM_Status='PREREGED' Where PIADM_RowId=:QueryValue)
	s ret=ret_" ,PreIADM Rows="_%ROWCOUNT

	q ret
}

/// ******************************************************************
/// Rewrite by jdl  
/// move from web.DHCPE.HandlerIAdm-->updateItemMatch
Method updateItemMatch(crmOItemID, hisOItemId, IAdmId)
{
	s rowId=""
	s (AddOrdItem,FactAmount,AsCharged,OrdEntDR,OrderSetsDR)=""
	//&SQL(select PIOI_AddOrdItem,PIOI_FactAmount,PIOI_AsCharged,PIOI_OrdEnt_DR,PIOI_OrdEnt_DR->PIOE_OrderSets_DR into :AddOrdItem,:FactAmount,:AsCharged,:OrdEntDR,:OrderSetsDR
	//	 FROM sqluser.DHC_PE_PreIOrdItem where PIOI_RowId=:crmOItemID)
	
	s AddOrdItem=$P(^DHCPEPreIADM(+crmOItemID,"ORDITEM",$P(crmOItemID,"||",2)),"^",5)
	s FactAmount=$P(^DHCPEPreIADM(+crmOItemID,"ORDITEM",$P(crmOItemID,"||",2)),"^",6)
	s AsCharged=$P(^DHCPEPreIADM(+crmOItemID,"ORDITEM",$P(crmOItemID,"||",2)),"^",9)
	s OrdEntDR=$P(^DHCPEPreIADM(+crmOItemID,"ORDITEM",$P(crmOItemID,"||",2)),"^",2)
	i OrdEntDR'="" d
	.s OrderSetsDR=$P(^DHCPEPreIADM(+OrdEntDR,"ORDENT",$P(OrdEntDR,"||",2)),"^",1)
	
	s BillStatus="NP"
	if AsCharged="Y"  d
	.s BillStatus="OC"
	s result= ##class(web.DHCPE.Cashier).CheckPayedCRMOrder(crmOItemID)
	if ((result="PP")||(result="P")) s BillStatus=result
	
	//&SQL(select crmo_rowid into :rowId FROM sqluser.dhc_pe_crmorder where crmo_crmori=:crmOItemID)
	s rowId=$O(^DHCPECRMO(0,"CRMORI",crmOItemID,0))
	if (rowId=""){
		&sql(insert into sqluser.dhc_pe_crmorder(crmo_crmori,crmo_oeori_dr,crmo_IADM_dr,CRMO_BillStatus,CRMO_AddOrdItem,CRMO_FactAmount)
		 values(:crmOItemID, :hisOItemId, :IAdmId,:BillStatus,:AddOrdItem,:FactAmount))
		//if (OrdEntDR'="")
		//{
			
		//}
	}
	else {
		 &sql(UPDATE sqluser.dhc_pe_crmorder set crmo_oeori_dr=:hisOItemId,CRMO_BillStatus=:BillStatus,
		 	CRMO_AddOrdItem=:AddOrdItem,CRMO_FactAmount=:FactAmount 
		 where crmo_rowid=:rowId) //and CRMO_BillStatus<>'P'
	}
	If ((BillStatus="OC")||(BillStatus="P")||(BillStatus="PP"))
	{
		&sql(update sqluser.OE_OrdItem set Oeori_Billed='P' where oeori_rowid=:hisOItemId)
	}
}

/// 根据个人体检登记号，生成医瞩套相关信息
/// w ##class(web.DHCPE.CRM.GatewayDHC).InsertOEEnt(iAdmId)
ClassMethod InsertOEEnt(iAdmId)
{
	s entId=""
	s errEnt=""
	if iAdmId="" q "IAdmId为空!"
	s crmAdmId=$p($g(^DHCPEIADM(iAdmId)),"^",4)
	s admId=$p($g(^DHCPEIADM(iAdmId)),"^",1)
	if admId="" q "admId为空!"
	s ordid=""
	s ordid=$o(^OEORD(0,"Adm",admId,ordid))
	q:ordid="" "ordid为空"

	s crmEnt=""
	s crmEntSub=0
	f  s crmEntSub=$o(^DHCPEPreIADM(crmAdmId,"ORDENT",crmEntSub))  q:((crmEntSub="")||(errEnt'=""))  d
	.
	.q:$p($g(^DHCPEPreIADM(crmAdmId,"ORDENT",crmEntSub)),"^",9)'=1	//判断是否有效
	.
	.s crmEnt=crmAdmId_"||"_crmEntSub
	.s ARCOS=$p($g(^DHCPEPreIADM(crmAdmId,"ORDENT",crmEntSub)),"^",1)
	.s crmOrdId=""
	.s i=0
	.f  s crmOrdId=$o(^DHCPEPreIADM(0,"OrdEnt",crmEnt,crmAdmId,crmOrdId))  q:((crmOrdId="")||(errEnt'=""))  d
	..
	..q:$p($g(^DHCPEPreIADM(crmAdmId,"ORDITEM",crmOrdId)),"^",16)'=1	//判断是否有效
	..
	..s i=i+1
	..s iOrditmId=$o(^DHCPECRMO(0,"CRMORI",crmAdmId_"||"_crmOrdId,""))
	..q:iOrditmId=""
	..s orditmId=$p($g(^DHCPECRMO(iOrditmId)),"^",1)
	..q:orditmId=""
	..s curEntId=$p($g(^OEORD(ordid,"I",$p(orditmId,"||",2),1)),"^",1)
	..s curArCos=$p($g(^OEORD(ordid,"I",$p(orditmId,"||",2),3)),"^",10)
	..i i=1  d
	...s entId=curEntId
	..i ((entId="")&&(i=1))  d
	...&SQL(Insert into SQLUser.OE_ordENT (OEORN_OEORD_ParRef,OEORN_OrdSets_DR) values (:ordid,:ARCOS))
	...i SQLCODE  s errEnt="生成医瞩套失败!"_SQLCODE
	...q:errEnt'=""
	...s entId=%ROWID
	..q:((errEnt'="")||(entId=""))
	..
	..//w "ordid:"_ordid_",orditmId:"_orditmId_",entId:"_entId,!
	..//q  
	..i ((entId'=curEntId)||(curArCos'=ARCOS)) d
	...&SQL(update SQLUser.oe_orditem set oeori_ordent_dr=:entId Where oeori_rowid=:orditmId)
	...//&SQL(update SQLUser.oe_orditem set oeori_ordent_dr=:entId,oeori_arcos_dr=:ARCOS Where oeori_rowid=:orditmId)
	...i SQLCODE  s errEnt="更新医瞩的医瞩套信息失败!"_SQLCODE
	q errEnt
}

/// 体检过程变更通知, 由his通知CRM系统
/// return: "0"  成功;  “ERROR: XXX” 失败
/// param:
/// 		RegType: RegId的类型，"PERSON"-个人　"GROUP"-团体 
/// 		RegId: 个人或团体的RegId(AdmId)
/// 		NewStatus: 新状态 %String ：PREREG-预挂号;REGISTERED-登记;ARRIVED-审批;CHARGED-收费;COMPLETED-完成(报告完成)
/// 		AddtionInfo: 附加信息.一般情况下为""
ClassMethod ExamStatusNotify(QueryType, QueryValue, NewStatus, AdditionInfo = "") As %String
{
	if (QueryType="PERSON")
	{	s admType="I"}
	elseif (QueryType="GROUP")
	{	s admType="G"}
	else
	{	q "ERROR: QueryType is not correct. "_$zn}
	
	//s passed=..CheckCanArrive(QueryValue,admType)
	//if passed'="0" q passed
	
	s oldStatus=""
	//s NewStatus="ARRIVED"
	If (NewStatus="ARRIVED")&(QueryType="PERSON") Do
	.Set Ret=..IADMDataEx(QueryValue)
	
	if QueryType="GROUP" {
		&sql(update SQLUSER.DHC_PE_PreGADM set PGADM_STATUS=:NewStatus where pgadm_rowid=:QueryValue)
		s GADMRowId=$o(^DHCPEGADM(0,"CRMGADM",QueryValue,""))
		&sql(update SQLUSER.DHC_PE_GADM set GADM_Status=:NewStatus where gadm_rowid=:GADMRowId)

	}else {
		&sql(update SQLUSER.dhc_pe_preiadm set piadm_status=:NewStatus where PIADM_RowId=:QueryValue)
	}

	s strRet=$s(((SQLCODE=0)||(SQLCODE=100)):"0",1:"ERROR: ExamStatusNotify failed when invoke webservice!")
	q strRet
}

/// 检测是否已经超过预约日期
/// admType:"I":个人Adm,"G":团体Adm
/// 返回值：-1：尚未到体检日期  0：正常在预约日期范围内  1：超过预约日期
ClassMethod CheckPEDate(crmAdm, admType, curDate)
{
	set ret=0
	if admType="I"
	{
		s preGAdmId=$p($g(^DHCPEPreIADM(crmAdm)),"^",2)		
		//if preGAdmId'="" s ret=..CheckPEDate(preGAdmId,"G",curDate)
		//if ret'=0 q ret
		s beginDate=$p($g(^DHCPEPreIADM(crmAdm)),"^",4)
		s endDate=$p($g(^DHCPEPreIADM(crmAdm)),"^",5)
		s delayDate=$p($g(^DHCPEPreIADM(crmAdm)),"^",19)		
	}
	else
	{
		s beginDate=$p($g(^DHCPEPreGADM(crmAdm)),"^",2)
		s endDate=$p($g(^DHCPEPreGADM(crmAdm)),"^",3)
		s delayDate=$p($g(^DHCPEPreGADM(crmAdm)),"^",17)		
	}
	s BookDate=$G(^DHCPESetting("DHCPE","BookDateLimit"))
	if BookDate="Yes"
	{
		if (curDate<beginDate)	q -1
		if ((curDate>endDate)&(+delayDate<curDate)) q 1
	}
	q 0
}

/// 检测是否符合登记到达的条件
/// 返回值：0：符合可以到达  其它：不符
/// admType:"I":个人Adm,"G":团体Adm
/// w ##class(web.DHCPE.CRM.GatewayDHC).CheckCanArrive("11625","G")
ClassMethod CheckCanArrive(crmAdm, admType)
{
	q 0
	s rows=0
	&SQL(Select count(*) into :rows from sqluser.DHC_PE_PreAudit
		 	Where PA_CRMADM=:crmAdm and PA_ADMType=:admType 
		 	and PA_AuditedStatus not in ('Audited','NoAudited'))
	//b // CheckCanArrive rows
	if rows>0 q "有未审核的体检内容"
	if admType="I" Do
	.s preGAdmId=$p($g(^DHCPEPreIADM(crmAdm)),"^",2)
	if $g(preGAdmId)'=""
	{
		q ..CheckCanArrive(preGAdmId,"G")
	}
	q 0
}

/// 获取团体的预约信息
/// return: ***$C(1)GroupID^GroupRegId^GroupName^PreRegDate^RecordDate^DiscountLevel^Status^CountAmount^DiscountAmount^FinalAmount$C(1)...
/// param:
/// 		QueryType: paraValue的类型,“GROUPID”，“GROUPNAME”、“GRPREGID”
/// 		QueryValue: 具体的查询值
/// 		Flag:"ALL"-客人的所有记录;  "UNCOMPLETED"-客人未结束的体检预约记录，包括进行中和未开始的，及各状态。
ClassMethod GetGrpRegList(QueryType, QueryValue, Flag) As %String
{
	s strAll=""
	s StatusList=..ParseStatus(Flag,"CRMAdm")
	
	s i=0
	if QueryType="GROUPID"
	{
		s preGAdmId=QueryValue
		d SetDataPreGInfo
		s strAll=myData
	}
	elseif QueryType="GROUPNAME"
	{
		s gName=QueryValue
		if QueryValue'=""  d
		.s gName=$o(^DHCPEPreGBI(0,"Desc",gName),-1)
		f  s gName=$o(^DHCPEPreGBI(0,"Desc",gName)) q:((gName'[QueryValue)||(gName=""))  d
		.s preGBaseInfoId=""
		.f  s preGBaseInfoId=$o(^DHCPEPreGBI(0,"Desc",gName,preGBaseInfoId)) q:preGBaseInfoId=""  d
		..s preGAdmId=""
		..f  s preGAdmId=$o(^DHCPEPreGADM(0,"PGBI",preGBaseInfoId,preGAdmId))  q:preGAdmId=""  d
		...d SetDataPreGInfo
		...i myData'=""  d
		....i strAll'="" s strAll=strAll_$c(1)
		....s strAll=strAll_myData
	}
	//q QueryType_"^"_QueryValue_"^"_Flag
	q strAll
	;s strRet=$tr(strRet,$C(1),$C(10))
	
SetDataPreGInfo
	s myData=""
	s preGData=$g(^DHCPEPreGADM(preGAdmId))
	q:preGData=""
	s myStatus=$p(preGData,"^",6)
	q:StatusList'[myStatus 
	s passed= ..CheckCanArrive(preGAdmId,"G")
	q:passed'=0	
	s preGBId=$p(preGData,"^",1)
	q:preGBId=""
	s myGrpName=$p($g(^DHCPEPreGBI(preGBId)),"^",2)
	s myBeginDate= $p(preGData,"^",2)
	i myBeginDate'="" s myBeginDate=$zd(myBeginDate,3)
	s myEndDate= $p(preGData,"^",3)
	i myEndDate'="" s myEndDate=$zd(myEndDate,3)
	s myUpdateDate=$p(preGData,"^",20)
	i myUpdateDate'="" s myUpdateDate=$zd(myUpdateDate,3)
	s myDelayDate=$p(preGData,"^",17)
	i myDelayDate'="" s myDelayDate=$zd(myDelayDate,3)
	s myData=preGBId_"^"_preGAdmId_"^"_myGrpName_"^"_myBeginDate_"^"_myUpdateDate_"^1^"_myStatus_"^"_myEndDate_"^"_myDelayDate
	q
	//myGrpId_"^"_myRegId_"^"_myGrpName_"^"_myPreRegDate_"^"_myRecordDate_"^1^"_myStatus_"^"_myCountAmount_"^"_myDiscountAmount_"^"_myFactAmount
}

/// 获取用户体检登记记录
/// return: ***$C(1)RegID^PatCardId^PreRegDate^RecordDate^IsAsCharged^Status^CountAmount^DiscountAmount^FinalAmount^PatNAME$C(1)...
/// param:
/// 		QueryType: paraValue的类型,“HISCARDID”，“MID”、“CERTID”, “MOBILE”,"REGID","PATNAME"
/// 		QueryValue: 具体的查询值
/// 		Flag:  "ALL"-客人的所有记录;  
/// 				"UNCOMPLETED"-客人未结束的体检预约记录，包括进行中和未开始的。及各状态。
/// 				Else: 其他具体的状态
/// w ##class(web.DHCPE.CRM.GatewayDHC).GetRegListByPatInf("PATNAME","","UNCOMPLETED","3740")
ClassMethod GetRegListByPatInf(QueryType, QueryValue, Flag = "ALL", job = "aaa") As %String
{
	s ^lisatest("0606","GetRegListByPatInf")=QueryType_"^"_QueryValue_"^"_Flag_"^"_job
	s strAll=""	
	s StatusList=..ParseStatus(Flag,"CRMAdm")
	i QueryType="REGID"	
	{
		s preIAdmId=QueryValue
		d SetDataPreIInfo
		q myData
	}
	i QueryType="HISCARDID"
	{	s indexName="PAPMINo"
		s QueryValue=##class(web.DHCPE.DHCPECommon).RegNoMask(QueryValue)
	}
	elseif QueryType="PATNAME"
	{	s indexName="Name"	}
	elseif QueryType="CERTID"
	{	s indexName="IDCard"	}
	else
	{	q "" }

	s indexValue=QueryValue
	if QueryValue'=""  d
	.s indexValue=$o(^DHCPEPreIBI(0,indexName,indexValue),-1)
	
	s PreIAdmIds=""
	s m=0
	k ^DHCPERegisterTempData(job)
	s Flag=0
	f  s indexValue=$o(^DHCPEPreIBI(0,indexName,indexValue)) q:((indexValue'[QueryValue)||(indexValue="")||(Flag=1))  d
	.s preIBaseInfoId=""
	.f  s preIBaseInfoId=$o(^DHCPEPreIBI(0,indexName,indexValue,preIBaseInfoId)) q:(preIBaseInfoId="")||(Flag=1)  d
	..s preIAdmId=""
	..f  s preIAdmId=$o(^DHCPEPreIADM(0,"PIBI",preIBaseInfoId,preIAdmId))  q:(preIAdmId="")||(Flag=1)  d
	...
	...///判断是否已经存在纪录   renzwang 0526
	...//q:##class(web.DHCPE.PreAudit).StringIsInStrs(PreIAdmIds,preIAdmId) //Modified by MLH1109速度慢
	...d SetDataPreIInfo
	q strAll		
SetDataPreIInfo	
	
	s myData=""
	s preIData=$g(^DHCPEPreIADM(preIAdmId))
	q:preIData=""
	s Status=$p(preIData,"^",8)
	q:(Status'="PREREGED")&&(Status'="REGISTERED")
	q:StatusList'[Status

	//s passed= ..CheckCanArrive(preIAdmId,"I")
	//q:passed'=0	
	s preIBId=$p(preIData,"^",1)
	q:preIBId="" 

	s PNo=$p($g(^DHCPEPreIBI(preIBId)),"^",1)
	s PName=$p($g(^DHCPEPreIBI(preIBId)),"^",2)
	s PSex=$p($g(^DHCPEPreIBI(preIBId)),"^",3)
	s PDOB=$p($g(^DHCPEPreIBI(preIBId)),"^",4)
	
	s PGADMDR=$p(preIData,"^",2)
	s PGTeamDR=$p(preIData,"^",3)
	s BookDateBegin=$p(preIData,"^",4)
	i BookDateBegin'="" s BookDateBegin=$zd(BookDateBegin,3)
	s BookDateEnd=$p(preIData,"^",5)
	i BookDateEnd'="" s BookDateEnd=$zd(BookDateEnd,3)
	s BookTime=$p(preIData,"^",6)
	s PEDeskClerkDR=$p(preIData,"^",7)
	//s Status=$p(preIData,"^",8)
	s AsCharged=$p(preIData,"^",9)
	s AddOrdItem=$p(preIData,"^",10)
	s AddOrdItemLimit=$p(preIData,"^",11)
	s AddOrdItemAmount=$p(preIData,"^",12)
	s AddPhcItem=$p(preIData,"^",13)
	s AddPhcItemLimit=$p(preIData,"^",14)
	s AddPhcItemAmount=$p(preIData,"^",15)
	s IReportSend=$p(preIData,"^",16)
	s DisChargedMode=$p(preIData,"^",17)
	s Vip=$p(preIData,"^",18)
	s DelayDate=$p(preIData,"^",19)
	i DelayDate'="" s DelayDate=$zd(DelayDate,3)
	s Remark=$p(preIData,"^",20)
	s UpdateUserDR=$p(preIData,"^",21)
	s UpdateDate=$p(preIData,"^",22)
	i UpdateDate'="" s UpdateDate=$zd(UpdateDate,3)
	s myData=preIAdmId_"^"_preIBId_"^"_PNo_"^"_PName_"^"_PSex_"^"_PDOB_"^"_PGADMDR_"^"_PGTeamDR_"^"_BookDateBegin_"^"_BookDateEnd_"^"_BookTime_"^"_PEDeskClerkDR_"^"_Status_"^"_AsCharged_"^"_AddOrdItem_"^"_AddOrdItemLimit_"^"_AddOrdItemAmount_"^"_AddPhcItem_"^"_AddPhcItemLimit_"^"_AddPhcItemAmount_"^"_IReportSend_"^"_DisChargedMode_"^"_Vip_"^"_DelayDate_"^"_Remark_"^"_UpdateUserDR_"^"_UpdateDate
	s ^DHCPERegisterTempData(job,preIAdmId)=myData
	q
}

/// 获取用户体检登记记录
/// return: ***$C(1)RegID^PatCardId^PreRegDate^RecordDate^IsAsCharged^Status^CountAmount^DiscountAmount^FinalAmount^PatNAME$C(1)...
/// param:
/// 		QueryType: paraValue的类型,“HISCARDID”，“MID”、“CERTID”, “MOBILE”,"REGID","PATNAME"
/// 		QueryValue: 具体的查询值
/// 		Flag:  "ALL"-客人的所有记录;  
/// 				"UNCOMPLETED"-客人未结束的体检预约记录，包括进行中和未开始的。及各状态。
/// 				Else: 其他具体的状态
/// w ##class(web.DHCPE.CRM.GatewayDHC).GetRegListByPatInf0606("HISCARDID","00000175","UNCOMPLETED","3424")
ClassMethod GetRegIADM(QueryType, QueryValue, Flag = "ALL", job = "aaa") As %String
{
	s ^lisatest("0606","GetRegListByPatInf")=QueryType_"^"_QueryValue_"^"_Flag_"^"_job
	s strAll=""	
	s StatusList=..ParseStatus(Flag,"CRMAdm")
	i QueryType="REGID"	
	{
		s preIAdmId=QueryValue
		d SetDataPreIInfo
		q myData
	}
	i QueryType="HISCARDID"
	{	s indexName="PAPMINo"
		s QueryValue=##class(web.DHCPE.DHCPECommon).RegNoMask(QueryValue)
	}
	elseif QueryType="PATNAME"
	{	s indexName="Name"	}
	elseif QueryType="CERTID"
	{	s indexName="IDCard"	}
	else
	{	q "" }

	s indexValue=QueryValue
	if QueryValue'=""  d
	.s indexValue=$o(^DHCPEPreIBI(0,indexName,indexValue),-1)
	
	s PreIAdmIds=""
	s m=0
	k ^DHCPERegisterTempData(job)
	
	If QueryType="HISCARDID" Do
	.b //060-1
	.Set PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",QueryValue,0))
	.q:PIBI=""
	.Set PIADM=0
	.For  Set PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM)) Quit:PIADM=""  Do
	..b //060-2
	..d SetDataPreIInfo
	
	If QueryType'="HISCARDID" Do
	.Set PIADM=0
	.For  Set PIADM=$o(^DHCPEPreIADM(0,"Status","PREREGED",PIADM))  Quit:PIADM=""  Do
	..d SetDataPreIInfo
	.For  Set PIADM=$o(^DHCPEPreIADM(0,"Status","REGISTERED",PIADM))  Quit:PIADM=""  Do
	..d SetDataPreIInfo

	q strAll		
SetDataPreIInfo	
	s myData=""
	Quit:PIADM=""
	s preIData=$g(^DHCPEPreIADM(PIADM))
	q:preIData=""
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM)    //Add by 090702
	q:LocFlag=1 
	s Status=$p(preIData,"^",8)
	q:(Status'="PREREGED")&&(Status'="REGISTERED")
	q:StatusList'[Status

	//s passed= ..CheckCanArrive(PIADM,"I")
	//q:passed'=0	
	s preIBId=$p(preIData,"^",1)
	q:preIBId="" 

	s PNo=$p($g(^DHCPEPreIBI(preIBId)),"^",1)
	s PName=$p($g(^DHCPEPreIBI(preIBId)),"^",2)
	s PSex=$p($g(^DHCPEPreIBI(preIBId)),"^",3)
	s PDOB=$p($g(^DHCPEPreIBI(preIBId)),"^",4)
	
	s PGADMDR=$p(preIData,"^",2)
	s PGTeamDR=$p(preIData,"^",3)
	s BookDateBegin=$p(preIData,"^",4)
	i BookDateBegin'="" s BookDateBegin=$zd(BookDateBegin,3)
	s BookDateEnd=$p(preIData,"^",5)
	i BookDateEnd'="" s BookDateEnd=$zd(BookDateEnd,3)
	s BookTime=$p(preIData,"^",6)
	s PEDeskClerkDR=$p(preIData,"^",7)
	//s Status=$p(preIData,"^",8)
	s AsCharged=$p(preIData,"^",9)
	s AddOrdItem=$p(preIData,"^",10)
	s AddOrdItemLimit=$p(preIData,"^",11)
	s AddOrdItemAmount=$p(preIData,"^",12)
	s AddPhcItem=$p(preIData,"^",13)
	s AddPhcItemLimit=$p(preIData,"^",14)
	s AddPhcItemAmount=$p(preIData,"^",15)
	s IReportSend=$p(preIData,"^",16)
	s DisChargedMode=$p(preIData,"^",17)
	s Vip=$p(preIData,"^",18)
	s DelayDate=$p(preIData,"^",19)
	i DelayDate'="" s DelayDate=$zd(DelayDate,3)
	s Remark=$p(preIData,"^",20)
	s UpdateUserDR=$p(preIData,"^",21)
	s UpdateDate=$p(preIData,"^",22)
	i UpdateDate'="" s UpdateDate=$zd(UpdateDate,3)
	s myData=PIADM_"^"_preIBId_"^"_PNo_"^"_PName_"^"_PSex_"^"_PDOB_"^"_PGADMDR_"^"_PGTeamDR_"^"_BookDateBegin_"^"_BookDateEnd_"^"_BookTime_"^"_PEDeskClerkDR_"^"_Status_"^"_AsCharged_"^"_AddOrdItem_"^"_AddOrdItemLimit_"^"_AddOrdItemAmount_"^"_AddPhcItem_"^"_AddPhcItemLimit_"^"_AddPhcItemAmount_"^"_IReportSend_"^"_DisChargedMode_"^"_Vip_"^"_DelayDate_"^"_Remark_"^"_UpdateUserDR_"^"_UpdateDate
	s ^DHCPERegisterTempData(job,PIADM)=myData
	q
}

ClassMethod ParseStatus(source, type)
{
	s result=""
	if (type="CRMAdm")  d
	.s result=$CASE(source,"ALL":"^PREREG^PREREGED^REGISTERED^ARRIVED","UNCOMPLETED":"^PREREG^PREREGED^REGISTERED",:"")
	q result
}

/// 获取用户信息
/// patientNo登记号
ClassMethod GetPatientInfoByNo(patientNo) As web.DHCPE.Patient
{
	s iBaseInfoId=$o(^DHCPEPreIBI(0,"PAPMINo",patientNo,""))	
	s patData=$g(^DHCPEPreIBI(iBaseInfoId))
	q:patData="" ""	
	
	s objPatient=##class(web.DHCPE.Patient).%New()
	s objPatient.PatientNo=$p(patData,"^",1)
	s objPatient.PatientName=$p(patData,"^",2)
	s objPatient.PatientId= $o(^PAPERi("PAPMI_PatNo",objPatient.PatientNo,"0"))	
	s objPatient.Sex=$p(patData,"^",3)
	s objPatient.DOB=$p(patData,"^",4)
	s objPatient.PatientType=$p(patData,"^",5)
	s objPatient.MobilePhone=$p(patData,"^",8)
	s objPatient.IDNo=$p(patData,"^",9)
	s objPatient.Nation=$p(patData,"^",15)
	s objPatient.BloodType=$p(patData,"^",18)
	s objPatient.Marital=$p(patData,"^",17)
	s objPatient.Email=$p(patData,"^",16)
	s objPatient.Address=$p(patData,"^",14)
	
	s objPatient.Zip=$p(patData,"^",13)
	s objPatient.Profession=$p(patData,"^",10)
	s objPatient.Corporator=$p(patData,"^",12)
	//	
	q objPatient
}

ClassMethod TestA(info)
{
	//w ..GetGrpRegList("GROUPNAME","","UNCOMPLETED")
	//w ..GetRegListByPatInf("PATNAME","","UNCOMPLETED")
	//w ..GetRegListByPatInf("REGID","99")
	i $p(info,"^",1)'="G" 
	{	w ..CancelIBaseInfo($p(info,"^",2))}
	else
	{	w ..CancelGBaseInfo($p(info,"^",2))}
}

/// w ##class(web.DHCPE.CRM.GatewayDHC).GetLabCode("10698||1")
ClassMethod GetLabCode(arcItemId, LocID As %String = "") As %String
{
	s TrakVerison=##class(web.DHCPE.Public.Setting).GetTrakVerison()

    s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
	s labItemCode=""
	//s labStationId=^DHCPESetting("DHCPE","StationId_Lab")
	s labStationId=^DHCPESetting("DHCPE","StationId_Lab",CTLOCID)

	////取检验医嘱的外部代码
	// 新版本
	i "TrakCare"=TrakVerison d
	.&sql(select Ext_code into :labItemCode from sqluser.arc_itemexternalcodes 
				where ext_parRef=:arcItemId)
	// 旧版本
	i "MedTrak"=TrakVerison d
	.// DHC_PE_StationOrder.{ STORD_ChildSub }
	.s STORDChildSub=""
	.s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",arcItemId, labStationId,STORDChildSub))
	.Q:(""=STORDChildSub)
	.// DHC_PE_StationOrder.{ STORD_ARCOS_DR }
	.s STORDARCOSDR=$P($G(^DHCPEST(labStationId, "O", STORDChildSub)),"^",3)
	.Q:(""=STORDARCOSDR)
	.// ARC_OrdSets.{ ARCOS_LabTrakTestSet }
	.s labItemCode=$P($G(^ARCOS(STORDARCOSDR)), "^", 11)
	q labItemCode
}

/// w ##class(web.DHCPE.CRM.GatewayDHC).GetSpecimen("T162")
ClassMethod GetSpecimen(labItemCode, LocID As %String = "") As %String
{
	s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
	//Set namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	Set namespaceLab=^DHCPESetting("NAMESPACE","LABDATA",LocID)

	Set SpecimenRowId=0,SepcimenDef=""
	For  Set SpecimenRowId=$O(^[namespaceLab]TTAB("TS",labItemCode,1,SpecimenRowId)) Quit:((SpecimenRowId="")||(SepcimenDef="Y"))  Do
	.Set SpecimenDesc=$p(^[namespaceLab]TTAB("SPEC",SpecimenRowId),"\",1)
	.Set SpecimenCode=SpecimenRowId
	.Set SepcimenDef=$p(^[namespaceLab]TTAB("TS",labItemCode,1,SpecimenRowId),"\",1)
	.//Set SpecimenCode=$p(^[namespaceLab]TTAB("SPEC",SpecimenCode),"\",1)
	Set RetVal=SpecimenCode_"^"_SpecimenDesc
	q RetVal
}

ClassMethod Test1()
{
	Set i=0,m=0,l=0
	for  Set i=i+1 Quit:((i=10)||(i=3))  Do
	.q:i=3
	.i i=5 s l="a"
	.s m=m+1
	w !,i_"^"_m_"^"_l
}

ClassMethod IADMDataEx(PIADM As %Library.String = "")
{
	Set ArrDate=$g(^DHCPEDataEx("DHCPEPreIADM","AdmDate","AdmTime",PIADM))
	If ArrDate="" Do
	.Set IADMDate=+$h
	.Set IADMTime=$p($h,",",2)
	.Set ^DHCPEDataEx("DHCPEPreIADM","AdmDate","AdmTime",PIADM)=IADMDate_"^"_IADMTime
	.Set ^DHCPEDataEx("DHCPEPreIADM",0,"AdmDateTime",IADMDate,IADMTime,PIADM)=""
	Quit 0
}

// w ##class(web.DHCPE.CRM.GatewayDHC).IsArrived(PAADM)

// 0  没到达

ClassMethod IsArrived(PAADM)
{
	q:PAADM="" 0
	s PIADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:PIADM="" 0
	s Status=$P(^DHCPEIADM(PIADM),"^",8)
	q:Status'="ARRIVED" 0
	q 1
}

// w ##class(web.DHCPE.CRM.GatewayDHC).GetGroupNameByOrdItem("2145")

// 参数修改为PAADM  2011-06-06

ClassMethod GetGroupNameByOrdItem(OEORDID)
{
	s $ZT="ERROR"
	q:OEORDID="" ""
	//s crmOrderID=$O(^DHCPECRMO(0,"OEORI",OEORDID,""))
	//q:crmOrderID="" ""
	s padm=$O(^DHCPEIADM(0,"PAADM",OEORDID,0))
	q:padm="" ""
	s crmADM=$P(^DHCPEIADM(padm),"^",4)
	//s crmADM=+crmOrderID
	q:crmADM="" ""
	s status=$P(^DHCPEPreIADM(crmADM),"^",8)
	i status="REGISTERED" d
	.d ##class(web.DHCPE.DHCPEIAdm).IAdmArrived(crmADM)
	s preGadm=$P(^DHCPEPreIADM(crmADM),"^",2)
	q:preGadm="" "个人体检"
	s gBaseInfoID=$P(^DHCPEPreGADM(preGadm),"^",1)
	s gDesc=$P(^DHCPEPreGBI(gBaseInfoID),"^",2)
	i $L(gDesc)>6 s gDesc=$E(gDesc,1,6)
	q gDesc
ERROR
	q ""
}

// w ##class(web.DHCPE.CRM.GatewayDHC).GetGroupNameByPAADM("107")

ClassMethod GetGroupNameByPAADM(PAADM)
{
	s $ZT="PAADMERROR"
	s padm=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:padm="" ""
	s crmADM=$P(^DHCPEIADM(padm),"^",4)
	//s crmADM=+crmOrderID
	q:crmADM="" ""
	s preGadm=$P(^DHCPEPreIADM(crmADM),"^",2)
	q:preGadm="" ""
	s gBaseInfoID=$P(^DHCPEPreGADM(preGadm),"^",1)
	s gDesc=$P(^DHCPEPreGBI(gBaseInfoID),"^",2)
	i $L(gDesc)>6 s gDesc=$E(gDesc,1,6)
	q gDesc
PAADMERROR
	q ""
}

// w ##class(web.DHCPE.CRM.GatewayDHC).GetHPResult("4040044","010012")

/// 根据PAADM和细项代码获取体检结果
ClassMethod GetHPResult(PAADM, ODCode)
{
	s $ZT="ResultErr"
	s STID="0"
	s STID=$O(^DHCPEST(0,"OD_Code",ODCode,STID))
	q:STID="" "-1^细项编码补存在"
	s ODSub="0"
	s ODSub=$O(^DHCPEST(0,"OD_Code",ODCode,STID,ODSub))
	s ODID=STID_"||"_ODSub
	s ResultID=$O(^DHCPERLT(0,"PAADM_OD",PAADM,ODID,0))
	q:ResultID="" "-2^体检结果不存在"
	s Result=$P(^DHCPERLT(ResultID),"^",4)
	q "0^"_Result
ResultErr
	q "-3^程序异常"
}

// 根据医嘱id，判断是否可以ris预约和登记

// 入参：OEOrdItemID  医嘱id   PreFlag为1是ris预约，0为ris登记

// 出参   1：可以操作   0：不可以操作

// s ret=##class(web.DHCPE.CRM.GatewayDHC).CanRegister("300||1")

ClassMethod CanRegister(OEOrdItemID, PreFlag As %String = "0")
{
	s $ZT="CanRegisterErr"
	q:OEOrdItemID="" 0
	s OEOrdID=+OEOrdItemID
	s PAADM=$P(^OEORD(OEOrdID),"^",1)
	s PayedFlag=$p($G(^OEORD(+OEOrdItemID,"I",$P(OEOrdItemID,"||",2),3)),"^",5)
	b ;PayedFlag
	q:PayedFlag'="P" 0  //未付费，不能预约、登记
	i PreFlag="0"{
		q ..IsArrived(PAADM)  //0，不能登记，1可以登记
	}else{
		q 1  //可以预约
	}
CanRegisterErr
	q 0
}

}
