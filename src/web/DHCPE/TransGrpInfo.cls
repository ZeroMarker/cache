/// Description: 将CRM中相关的体检登记信息传入His系统中，包括客户基本信息、体检登记信息和
/// 体检项目
Class web.DHCPE.TransGrpInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

Property crmGRegId As %String(TRUNCATE = 1);

Property crmGId As %String(TRUNCATE = 1);

Property userId As %String(TRUNCATE = 1);

Property locId As %String(TRUNCATE = 1);

Property objGBaseInfo As User.DHCPEGBaseInfo;

Property objGReg As User.DHCPEGADM;

Property crmStatus As %String(TRUNCATE = 1);

Property CRMGateway As web.DHCPE.CRM.IGateway;

/// Description: 主程序
/// Return: 正常：返回"", 错误：错误信息，　
Method mainEntrance(grpIdNew As %String, grpRegIdNew As %String, userId As %String, locId As %String) As %String
{
	s strErr=""
	s ..crmGRegId=grpRegIdNew
	s ..crmGId=grpIdNew
	s ..userId=userId
	s ..locId=locId
	s ..CRMGateway=##class(web.DHCPE.CRM.Factory).GetGateway()
	s ^temp("DHCPE","mainEntrance")=$lb(grpIdNew,grpRegIdNew,userId,locId)
	s strErr=..transGrp() 
	if strErr'=""  goto myError
	s strErr=..transReg()	 //插入表DHC_PE_GADM
	if strErr'=""  goto myError
	s strErr=..InsertReport()  //插入报告
	if strErr'=""  goto myError
	s strErr= ..transGTeam()  //插入分组
	if strErr'=""  goto myError 
	s strErr= ##class(web.DHCPE.TransGrpAsADM).Main(..objGReg.%Id(), ..userId, ..locId, ..userId) //(gAdmId , userId , regLocId ,regDocId )
	if strErr'=""  goto myError
	
	s strErr=..transAdms()	
	if strErr'=""  goto myError
	s strErr=..transRelats()	
	if strErr'=""  goto myError
	d ..NotifyCRM()
	
	q strErr
	
myError
	q strErr
}

// 插入表DHC_PE_GADM

Method transGrp() As %String
{
	s crmGRegStr=..CRMGateway.GetGrpRegList("GRPREGID",..crmGRegId,"UNCOMPLETED")
	q:(crmGRegStr="") "ERROR: Can not get the group register info!"

	/// return: ***$C(1)GroupID^GroupRegId^GroupName^PreRegDate^RecordDate^DiscountLevel^Status^CountAmount^DiscountAmount^FinalAmount$C(1)...
	s ..objGBaseInfo=##class(HandlerGroup).getAGrpByCRMId(..crmGId)
	s ..crmStatus=$p(crmGRegStr,"^",7)
	//b //0724crmStatus
	if ((..crmStatus="PREREG")||(..crmStatus="MODIFIED")||(..crmStatus="CHECKED")||(..objGBaseInfo.%Id()="")){
		s ..objGBaseInfo.GBIDesc =$p(crmGRegStr,"^",3)
		s retStatus=..objGBaseInfo.%Save()
		b:($$$ISOK(retStatus)'=1)
		q:($$$ISOK(retStatus)'=1) "ERROR: An Error occurs when objGBaseInfo.%Save()"
	} 
	q ""
}

Method transReg() As %String
{
	s crmGRegStr=..CRMGateway.GetGrpRegList("GRPREGID",..crmGRegId,"UNCOMPLETED")
	q:(crmGRegStr="") "ERROR: Can not get the group register info!"
	
	s ..objGReg=##class(HandlerGroup).getGRegByCRMId(..crmGRegId)
	//b //"--set objGReg--"
	s ..crmStatus=$p(crmGRegStr,"^",7)
	if ((..crmStatus="PREREG")||(..crmStatus="MODIFIED")||(..crmStatus="CHECKED")||(..objGReg.%Id()="")){		
		s ..objGReg.GADMAdmDate=+$h
		s ..objGReg.GADMAdmTime=+$p($h,",",2)
		s ..objGReg.GADMDiscountLevel =$p(crmGRegStr,"^",5)
		s ..objGReg.GADMAccountAmount =+$p(crmGRegStr,"^",8)
		s ..objGReg.GADMDiscountedAmount =+$p(crmGRegStr,"^",9)
		s ..objGReg.GADMFactAmount =+$p(crmGRegStr,"^",10)
		s ..objGReg.GADMGBIDR=..objGBaseInfo
		s ..objGReg.GADMStatus ="REGISTERED"
		s retStatus=..objGReg.%Save()
		q:($$$ISOK(retStatus)'=1) "ERROR: An Error occurs when ..objGReg.%Save()"
	}
	//b ;"..objGReg.%Save()"
	q ""
}

/// ------插一条报告状态记录-----------
Method InsertReport()
{
	s myReport=##Class(web.DHCPE.HandlerIAdm).GetReport("GADMID",..objGReg.%Id())
	if (myReport.%Id()=""){
		s myReport.RPTStatus="NA"
		s myReport.RPTGADMDR=..objGReg
		s retStatus=myReport.%Save()
		b:($$$ISOK(retStatus)'=1)
		q:($$$ISOK(retStatus)'=1) "ERROR: An Error occurs in the TransGrpInfo.InsertReport()"
	}
	q ""
}

Method transGTeam() As %String
{
	s retStr=""
	s hisGRegId=..objGReg.%Id()
	if ((..crmStatus="PREREG")||(..crmStatus="CHECKED")||(..crmStatus="MODIFIED")){
		&sql(delete from SQLUSER.DHC_PE_GTeam WHERE GT_ParRef=:hisGRegId)
		s strTeams=..CRMGateway.GetSmallGrpByGrpRegId(..crmGRegId)
		q:(strTeams="") ""
		s teamInd=1
		while(teamInd<=$l(strTeams,$C(1))){
			s aTeam=$p(strTeams,$C(1),teamInd)
			s grpId=..objGReg.%Id()
			s crmTeamId=$p(aTeam,"^",2)
			s tName=$p(aTeam,"^",3)
			&SQL(insert into SQLUSER.dhc_pe_GTEAM (GT_ParRef, GT_Desc, GT_CRMTeam)
					values(:grpId,:tName,:crmTeamId))
			i (SQLCODE'=0)  s retStr=retStr_"ERROR: SQLError in transGTeam, grpId="_grpId _$c(13)_$c(10)
			s teamInd=teamInd+1
		}
	}
	q retStr
}

/// 传送团体所有成员的体检项目
/// 插入表DHC_PE_IADM
Method transAdms() As %String
{
	s retStr=""
	s strAdms=..CRMGateway.GetMemberListByGrpRegId(..crmGRegId) //得到按分组里的人员
	q:(strAdms="") "ERROR:NO MEMBER IS FOUND IN THIS GROUP!"
	s admInd=1
	while(admInd<=$l(strAdms,$C(1))){
		
		s crmAdmInfo=$p(strAdms,$C(1),admInd)
		s myObj=##Class(TransAdmInfo).%New()
		s ret=myObj.main($p(crmAdmInfo,"^",3), ..userId)
		if (ret'=""){
			s retStr=retStr_", crmAdmId="_ret
		}
		s admInd=admInd+1
	}
	q retStr
}

/// 传送成员与组之间关系
Method transRelats()
{
	s retStr=""
	s strAdms=..CRMGateway.GetMemberListByGrpRegId(..crmGRegId)
	/// return: ...$C(1)GroupRegId^SmallGroupId^AdmId$C(1)...
	q:(strAdms="") "ERROR:NO MEMBER IS FOUND IN THIS GROUP!"
	s admInd=1
	while(admInd<=$l(strAdms,$C(1))){
		s crmAdmInfo=$p(strAdms,$C(1),admInd)
		s crmAdmId=$p(crmAdmInfo,"^",3)
		s crmGrpId=$p(crmAdmInfo,"^",1)
		s crmGTeamId=$p(crmAdmInfo,"^",2)
		s hisAdmId="", hisGrpId="",hisGTeamId=""
		&sql(select GT_RowId into :hisGTeamId from SQLUSER.DHC_PE_GTEAM WHERE GT_CRMTeam=:crmGTeamId)
		&sql(select GADM_RowId into :hisGrpId from SQLUSER.DHC_PE_GADM WHERE GADM_CRMGADM=:crmGrpId)
		&sql(update sqluser.dhc_pe_iadm set IADM_GADM_DR=:hisGrpId, IADM_GTeam_DR=:hisGTeamId WHERE IADM_CRMADM=:crmAdmId)
		b:(SQLCODE'=0)
		i (SQLCODE'=0)  s retStr=retStr_"ERROR:SQLError in update dhc_pe_iadm, crmAdmId="_crmAdmId_$c(13)_$c(10) 
		s admInd=admInd+1
	}
	q ""
}

Method NotifyCRM()
{
	s ret=..CRMGateway.ExamStatusNotify("GROUP",..crmGRegId, "REGISTERED","")
	q ret
}

ClassMethod main(grpIdNew As %String, grpRegIdNew As %String, userId As %String, locId As %String) As %String
{
	s obj=##class(TransGrpInfo).%New()
	s retStr=obj.mainEntrance( grpIdNew, grpRegIdNew, userId, locId)
	q retStr
}

/// ******************************************************************
ClassMethod mainNew(grpIdNew As %String, grpRegIdNew As %String, userId As %String, locId As %String, TFlag As %String = 1) As %String
{
	/*s result=##class(web.DHCPE.CRM.Gateway).CheckPEDate(grpIdNew,"G",+$h)
	if result'=0
	{
		if result=-1 q "还没有到预约日期!"
		q "预约已经过期!"
	}
	s result=##class(web.DHCPE.CRM.Gateway).CheckCanArrive(grpIdNew,"G")
	if result'=0  q result
	*/
	set objcrm=##class(web.DHCPE.CRM.Factory).GetGateway()
	set (GBaseInfoId,GAdmId,result)=""
	TStart:TFlag=1
	;b "before TransGInfoFromCRM"
	set result=objcrm.TransGInfoFromCRM(grpIdNew,.GBaseInfoId,.GAdmId)
	if ((result'="")||(+GAdmId<1))
	{
		TRollBack:TFlag=1
		q result
	}
	//set result=##class(web.DHCPE.CRM.Gateway).ExamStatusNotify("GROUP", grpIdNew, "ARRIVED")
	set result=##class(web.DHCPE.CRM.Gateway).ExamStatusNotify("GROUP", grpIdNew, "REGISTERED")
	if (result'=0)
	{
		TRollBack:TFlag=1
		q result
		}
	TCommit:TFlag=1
	
	s patid=##class(web.DHCPE.TransGrpAsADM).InsertPatMasNew(GBaseInfoId)
	if (+patid<1) 
	{ s result= patid
		goto mainNewErr}
	
	//s delegateAdmId=##class(web.DHCPE.TransGrpAsADM).InsertGAdmNew(GAdmId,patid,locId,userId,userId)
	s docId=$G(^DHCPESetting("DHCPE","PhyExamDrId",locId))
	s:userId'="" IDOCID=$p($G(^SSU("SSUSR",userId)),"^",14)
	i IDOCID'="" d
	.s docId=IDOCID
	s delegateAdmId=##class(web.DHCPE.TransGrpAsADM).InsertGAdmNew(GAdmId,patid,locId,docId,userId)
	
	if (+delegateAdmId<1) 
	{ s result= delegateAdmId
		goto mainNewErr}	
	/*
	set FactAmount=$p($g(^DHCPEGADM(GAdmId)),"^",11)
	set FactAmount=+FactAmount
	s result= ##class(web.DHCPE.TransGrpAsADM).InsertOEItemNew(delegateAdmId,FactAmount,locId,userId,userId)
	if (result'="") goto mainNewErr	
	*/
		
	q ""
mainNewErr
	q result
}

}
