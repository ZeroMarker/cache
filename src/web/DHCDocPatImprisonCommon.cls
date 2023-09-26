/// creator:tanjishan
/// 2017-10-11
/// 医生站和狱政系统直连的通用方法
Class web.DHCDocPatImprisonCommon Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// PAPerson和狱政系统做关联
/// 未和狱政系统直连，内容可能还需要调整
/// 注册建卡的绑定犯罪编号功能
ClassMethod SetPatIMPRelation(PatientID As %String, ImprisonInfo As %String, UserID As %String) As %String
{
	;罪犯编号
	s IMPNumber=$P(ImprisonInfo,"^",1)
	;入监日期
	s InDate=$P(ImprisonInfo,"^",2)
	i $l(InDate,"-")=3 s InDate=$zdh(InDate,3)
	i $l(InDate,"/")=3 s InDate=$zdh(InDate,4)
	;入监时间
	s InTime=$P(ImprisonInfo,"^",3)
	i $l(InTime,":")>1 s InTime=$ZTH(InTime)
	;监区
	s EscortUnits=$P(ImprisonInfo,"^",4)
	;出监日期
	s OutDate=$P(ImprisonInfo,"^",5)
	i $l(OutDate,"-")=3 s OutDate=$zdh(OutDate,3)
	i $l(OutDate,"/")=3 s OutDate=$zdh(OutDate,4)
	;出监时间
	s OutTime=$P(ImprisonInfo,"^",6)
	i $l(InDate,"/")=3 s InDate=$zdh(InDate,4)
	s EscortUnitsDR=""
	&SQL(SELECT EU_Rowid into:EscortUnitsDR FROM SQLUser.DHC_CTEscortUnits WHERE EU_Desc=:EscortUnits)
	
	set object=##class(User.PAPersonImprison).%New(PatientID)
	set object.PAINumber=IMPNumber
	set object.PAIInDate=InDate
	set object.PAIInTime=InTime
	d object.PAIEscortUnitsSetObjectId(EscortUnits)
	set object.PAIOutDate=OutDate
	set object.PAIOutTime=InDate
	set object.PAICreatDate=+$H
	set object.PAICreatTime=$P($H,",",2)
	d object.PAICreatUserSetObjectId(UserID)
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		s ^tan("DocPatImprisonCommon",+$H,$ZT($P($H,",",2)))=PatientID_","_ImprisonInfo_","_UserID
		q sc
	}else{
		q 0
	}
}

ClassMethod GetEscortUnitsStr(LogonLoc As %String, Group As %String) As %String
{
	s LogonHOSPDr=$P(^CTLOC(LogonLoc),"^",22)
	s OutPutStr=""
	s Rowid=0
	for {
		s Rowid=$O(^DHCCTEU("EU",Rowid))
		q:(Rowid="")
		s HOSPDr=$P(^DHCCTEU("EU",Rowid),"^",8)
		continue:(HOSPDr'="")&&(HOSPDr'=LogonHOSPDr)
		s Alias=$P(^DHCCTEU("EU",Rowid),"^",3)
		s Desc=$P(^DHCCTEU("EU",Rowid),"^",2)
		if (OutPutStr=""){
			s OutPutStr=Rowid_$C(1)_Desc_"-"_Alias
		}else{
			s OutPutStr=OutPutStr_"^"_Rowid_$C(1)_Desc_"-"_Alias
		}
	}
	q OutPutStr
}

/// 根据罪犯编号获取病人基本信息(如果绑定了多条，找创建时间最近的那条)，
/// 挂号时根据编号获取病人信息
ClassMethod GetPatintInfoByIMPNumber(IMPNumber As %String) As %String
{
	q:(IMPNumber="") ""
	k PAICRelatAll
	s PatientID=0
	for {
		s PatientID=$O(^PAPERi("IMPNumber",PatientID))
		q:PatientID=""
		s PAIChildsub=0
		for {
			s PAIChildsub=$O(^PAPERi("IMPNumber",PatientID,PAIChildsub))
			q:PAIChildsub=""
			s CreatDate=$P(^PAPER(PatientID,"PAIC",PAIChildsub),"^",7)
			s CreatTime=$P(^PAPER(PatientID,"PAIC",PAIChildsub),"^",8)
			s PAICRelatAll(CreatDate,CreatTime)=PatientID_"||"_PAIChildsub
		}
	}
	if '$D(PAICRelatAll){
		q ""
	}
	s LastCreatDate=$O(PAICRelatAll(""),-1)
	s CreatTime=$O(PAICRelatAll(LastCreatDate,""),-1)
	s PAICRowID=PAICRelatAll(LastCreatDate,CreatTime)
	s PatientID=$P(PAICRowID,"||",1)
	s PAIChildsub=$P(PAICRowID,"||",2)
	
	s EscortUnits=$P(^PAPER(PatientID,"PAIC",PAIChildsub),"^",4)
	
	
	q PAICRowID_"^"_EscortUnits
}

/// 根据病人ID获取病人监区信息
ClassMethod GetPatPAIInfo(PatientID As %String) As %String
{
	q:(PatientID="") ""
	s PAIChildsub=$O(^PAPER(PatientID,"PAIC",""),-1)
	q:(PAIChildsub="") ""
	s EscortUnits=$P(^PAPER(PatientID,"PAIC",PAIChildsub),"^",4)
	s PAICRowID=PatientID_"||"_PAIChildsub
	s PAIInfo=..GetPAIInfo(PAICRowID)
	q PAICRowID_"^"_PAIInfo
}

/// 根据病人扩展表获取病人监区信息
ClassMethod GetPAIInfo(PAICRowID As %String) As %String
{
	q:(PAICRowID="") ""
	s PatientID=+PAICRowID
	s PAIChildsub=$P(PAICRowID,"||",2)
	s Val=^PAPER(PatientID,"PAIC",PAIChildsub)
	s PAINumber=$P(Val,"^",1)
	s InDate=$P(Val,"^",2)
	s InTime=$P(Val,"^",3)
	s InDate=$S(InDate'="":$ZD(InDate,3),1:"")_" "_$S(InTime'="":$ZT(InTime,2),1:"")
	s EscortUnits=$P(Val,"^",4)
	s EscortUnitsDetails=..GetEscortUnitsDetails(EscortUnits)
	s OutDate=$P(Val,"^",5)
	s OutTime=$P(Val,"^",6)
	s OutDate=$S(OutDate'="":$ZD(OutDate,3),1:"")_" "_$S(OutTime'="":$ZT(OutTime,2),1:"")
	
	q PAINumber_"^"_InDate_"^"_EscortUnits_"^"_EscortUnitsDetails_"^"_OutDate
}

/// 获取监区明细
ClassMethod GetEscortUnitsDetails(EscortUnits As %String) As %String
{
	q:(EscortUnits="") ""
	//"01^测试1^a^0539-8888888^大老头^64557^^
	s Val=$G(^DHCCTEU("EU",EscortUnits))
	//名称
	s EUDesc=$P(Val,"^",2)
	//联系方式
	s EUContect=$P(Val,"^",4)
	// 负责人
	s EULeader=$P(Val,"^",5)
	
	q EUDesc_"$"_EUContect_"$"_EULeader
}

/// 根据病人就诊号获取病人监护信息
ClassMethod GetAdmPAIInfo(PAADMRowId As %String) As %String
{
	q:(PAADMRowId="") ""
	s ImprisonFlag=$P(^PAADM(PAADMRowId,"DHC"),"^",42)
	s EscortPerson=$P(^PAADM(PAADMRowId,"DHC"),"^",7)
	s EscortPersonTel=$P(^PAADM(PAADMRowId,"DHC"),"^",43)
	s EscortUnits=$P(^PAADM(PAADMRowId,"DHC"),"^",6)
	if (ImprisonFlag="N"){
		q ""
	}
	s PatientID=$P(^PAADM(PAADMRowId),"^",1)
	s EscortUnitsDetails=..GetEscortUnitsDetails(EscortUnits)
	s OutPutInfo="押送民警:"_EscortPerson
	s OutPutInfo=OutPutInfo_";押送民警电话:"_EscortPersonTel
	s OutPutInfo=OutPutInfo_";监区:"_$P(EUDesc,"$",1)
	s OutPutInfo=OutPutInfo_";监区联系电话:"_$P(EUDesc,"$",2)
	s OutPutInfo=OutPutInfo_";监区负责人:"_$P(EUDesc,"$",3)
	q OutPutInfo
}

}
