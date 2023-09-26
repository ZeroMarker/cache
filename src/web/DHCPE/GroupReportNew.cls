Class web.DHCPE.GroupReportNew Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter Split1 = "#";

Parameter Split2 = "^";

// d ##class(web.DHCPE.GroupReportNew).GetGroupInfo(9,"","","","","")

ClassMethod GetGroupInfo(GroupID As %String = "", TeamID As %String = "", Department As %String = "", StartDate As %String = "", EndDate As %String = "", VIPLevel As %String = "", Sort As %String = "1", CTLocID As %String = "")
{
	s UserID=%session.Get("LOGON.USERID")
	//s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType",CTLocID)),"^",1)
	if Sort="" s Sort=1
	if Sort=1 d
	.k ^TempDHCPEGroupReport(UserID)
	i (GroupID'=""){
		s GroupBaseID=$P(^DHCPEGADM(GroupID),"^",1)
		s CrmGADM=$P(^DHCPEGADM(GroupID),"^",2)
		s StartDate=$P(^DHCPEPreGADM(CrmGADM),"^",2)
		s StartDate=$ZD(StartDate,3)
		s EndDate=$P(^DHCPEPreGADM(CrmGADM),"^",3)
		s EndDate=$ZD(EndDate,3)
		s GroupDesc=$P(^DHCPEGBI(GroupBaseID),"^",2)
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDesc",Sort)=GroupDesc
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","CoverGroupDesc",Sort)=GroupDesc
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","PreDate",Sort)=StartDate_"--"_EndDate
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","CoverPrintDate",Sort)=$ZD($H,3)
		s ^TempDHCPEGroupReport(UserID,"BaseInfo","GroupDescHello",Sort)=GroupDesc_"领导"
		s CurTeamID=""
		f  s CurTeamID=$O(^DHCPEIADM(0,"GADM",GroupID,CurTeamID)) q:CurTeamID=""  d
		.q:(TeamID'="")&&(CurTeamID'=TeamID)
		.s IADM=0
		.f  s IADM=$O(^DHCPEIADM(0,"GADM",GroupID,CurTeamID,IADM)) q:IADM=""  d
		..d GetOneIAdmInfo
		q:Sort'=1
		f  s GroupID=$O(^DHCPEGADM(0,"GBI",GroupBaseID,GroupID),-1) q:(+GroupID=0)||(Sort>2)  d
		.s Sort=Sort+1
		.d ..GetGroupInfo(GroupID,TeamID,Department,StartDate,EndDate,VIPLevel,Sort)
		
		
	}else{
		
	}
	
	q "OK"
GetOneIAdmInfo
	s Status=$P(^DHCPEIADM(IADM),"^",8)
	q:Status'="ARRIVED"
	s GSID=$O(^DHCPEGS(0,"IADM",IADM,0))
	q:GSID=""
	s AuditUser=$P(^DHCPEGS(GSID,1),"^",5)
	q:AuditUser=""
	s Postion=##class(web.DHCPE.PreCommon).GetPosition("IADM",IADM)
	q:(Department'="")&&(Postion'=Department)
	s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	s AgeSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(PAADM)
	s Age=$P(AgeSexStr,"^",1)
	s Sex=$P(AgeSexStr,"^",2)
	s AgeNum=..GetAgeRangeNum(Age)
	s SexNum=..GetSexNum(Sex)
	;第四个节点和word中的书签名称一致
	s ^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount"_SexNum,Sort)=+$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount"_SexNum,Sort))+1
	s ^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",Sort)=+$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",Sort))+1
	s ^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,SexNum)=+$G(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,SexNum))+1
	s ^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,3)=+$G(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,3))+1
	s GSDChildSub=0
	f  s GSDChildSub=$O(^DHCPEGS(GSID,"Diagnosis",GSDChildSub)) Q:(""=GSDChildSub)  d
	.s GSDStatus=$P($G(^DHCPEGS(GSID,"Diagnosis",GSDChildSub)),"^",11)
	.q:GSDStatus="2"
	.s EDID=$P($G(^DHCPEGS(GSID,"Diagnosis",GSDChildSub)),"^",1)
	.i DiagnosisType="N" d
	..s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",EDID,Sort,SexNum)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",EDID,Sort,SexNum))+1
	..s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",EDID,Sort,3)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",EDID,Sort,3))+1
	..s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",EDID,Sort,AgeNum,SexNum)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",EDID,Sort,AgeNum,SexNum))+1
	..s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",EDID,Sort,AgeNum,3)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",EDID,Sort,AgeNum,3))+1
	..s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",EDID,Sort,IADM)=""
	.e  d
	..s IDRRowID=0
	..f  s IDRRowID=$o(^DHCPEIDR(0,"EDDR",EDID,IDRRowID)) q:IDRRowID=""  d
	...s ILLnessID=$P(^DHCPEIDR(IDRRowID),"^",2)
	...q:$D(^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",ILLnessID,Sort,IADM))
	...s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLnessID,Sort,SexNum)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLnessID,Sort,SexNum))+1
	...s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLnessID,Sort,3)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLnessID,Sort,3))+1
	...s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLnessID,Sort,AgeNum,SexNum)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLnessID,Sort,AgeNum,SexNum))+1
	...s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLnessID,Sort,AgeNum,3)=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLnessID,Sort,AgeNum,3))+1
	...s ^TempDHCPEGroupReport(UserID,"ListInfo","ILLDetail",ILLnessID,Sort,IADM)=""
	q
}

ClassMethod GetSexNum(Sex)
{
	s Num=1
	s:Sex="F" Num=2
	q Num
}

ClassMethod GetSexDesc(Num)
{
	q:Num=1 "男性"
	q:Num=2 "女性"
	q:Num=3 "合计"
	q ""
}

ClassMethod GetAgeRangeNum(Age)
{
	s Age=+$G(Age)
    q:(Age<=20) 1
	q:(Age>=21)&(Age<31) 2
	q:(Age>=31)&(Age<41) 3
	q:(Age>=41)&(Age<51) 4
	q:(Age>=51)&(Age<61) 5
	q:(Age>=61)&(Age<71) 6
	q:(Age>70) 7
	q
}

ClassMethod GetAgeRangeDesc(Num)
{
	q:Num=1 "<=20"
	q:Num=2 "21-30"
	q:Num=3 "31-40"
	q:Num=4 "41-50"
	q:Num=5 "51-60"
	q:Num=6 "61-70"
	q:Num=7 ">70"
	q ""
}

// 被除数，除数

ClassMethod GetPercent(Dividend, Divisor)
{
	;w ##class(web.DHCPE.GroupReportNew).GetPercent(1,3)
	i +Divisor=0 q ""
	i +Dividend=0 q ""
	s Result=(100*Dividend)/Divisor
	q $j(Result,"",2)_"%"
}

ClassMethod GetILLDesc(ILLID, CTLocID As %String = "")
{
	//s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType",CTLocID)),"^",1)
	i DiagnosisType="N" d
	.s ILLDesc=$P(^DHCPEED(ILLID,1),"^",1)
	e  d
	.s ILLDesc=$P(^DHCPEILLS(ILLID),"^",2)
	q ILLDesc
}

// 得到基本信息，其中LabDesc和word中书签名称一致

ClassMethod GetBaseInfo()
{
	;w ##class(web.DHCPE.GroupReportNew).GetBaseInfo()
	s UserID=%session.Get("LOGON.USERID")
	s Sort=1
	s ret=""
	s LabDesc=""
	f  s LabDesc=$O(^TempDHCPEGroupReport(UserID,"BaseInfo",LabDesc)) q:LabDesc=""  d
	.s value=$G(^TempDHCPEGroupReport(UserID,"BaseInfo",LabDesc,Sort))
	.s OneInfo=LabDesc_..#Split1_value
	.i ret="" d
	..s ret=OneInfo
	.e  d
	..s ret=ret_..#Split2_OneInfo
	q ret
}

// 得到年龄段人数

ClassMethod GetSexAgeCount()
{
	;w ##class(web.DHCPE.GroupReportNew).GetSexAgeCount()
	s UserID=%session.Get("LOGON.USERID")
	s Sort=1
	s ret=""
	s Total=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",Sort))
	s MTotal=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount1",Sort))
	s FTotal=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount2",Sort))
	;^TempDHCPEGroupReport(UserID,Sort,"ListInfo","AgeSexPersonCount",AgeNum,3)
	s ret=""
	s AgeNum=""
	f  s AgeNum=$O(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum)) q:AgeNum=""  d
	.s AgeDesc=..GetAgeRangeDesc(AgeNum)
	.s MCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,1))
	.s MPercent=..GetPercent(MCount,MTotal)
	.s FCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,2))
	.s FPercent=..GetPercent(FCount,FTotal)
	.s Count=$G(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,3))
	.s Percent=..GetPercent(Count,Total)
	.s OneInfo=AgeDesc_..#Split1_MCount_..#Split1_MPercent_..#Split1_FCount_..#Split1_FPercent_..#Split1_Count_..#Split1_Percent
	.i ret="" d
	..s ret=OneInfo
	.e  d
	..s ret=ret_..#Split2_OneInfo
	q ret
}

// 得到疾病排行

ClassMethod GetILLInfo()
{
	;w ##class(web.DHCPE.GroupReportNew).GetILLInfo()
	;^TempDHCPEGroupReport(1,"ListInfo","ILLSexCount"
	s UserID=%session.Get("LOGON.USERID")
	s Sort=1
	s TotalCount=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",Sort))
	s ILLID=""
	f  s ILLID=$O(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID)) q:ILLID=""  d
	.s OneTotal=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,Sort,3))
	.s ILLDesc=..GetILLDesc(ILLID)
	.s ^TempDHCPEGroupReport(UserID,"ILLSort",+OneTotal,ILLID)=ILLDesc
	s ret=""
	s Total="" 
	f  s Total=$O(^TempDHCPEGroupReport(UserID,"ILLSort",Total),-1) q:Total=""  d
	.s ILLID=""
	.f  s ILLID=$O(^TempDHCPEGroupReport(UserID,"ILLSort",Total,ILLID)) q:ILLID=""  d
	..s ILLDesc=$G(^TempDHCPEGroupReport(UserID,"ILLSort",Total,ILLID))
	..s Count=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,Sort,3))
	..s MCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,Sort,1))
	..s FCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,Sort,2))
	..s Percent=..GetPercent(Count,TotalCount)
	..s OneInfo=ILLDesc_..#Split1_Count_..#Split1_MCount_..#Split1_FCount_..#Split1_Percent
	..i ret="" d
	...s ret=OneInfo
	..e  d
	...s ret=ret_..#Split2_OneInfo
	q ret
}

// 得到以往三年的疾病信息

ClassMethod GetILLHistoryInfo()
{
	;w ##class(web.DHCPE.GroupReportNew).GetILLHistoryInfo()
	s UserID=%session.Get("LOGON.USERID")
	s TotalCount1=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",1))
	s TotalCount2=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",2))
	s TotalCount3=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",3))
	s ret=""
	s Total="" 
	f  s Total=$O(^TempDHCPEGroupReport(UserID,"ILLSort",Total),-1) q:Total=""  d
	.s ILLID=""
	.f  s ILLID=$O(^TempDHCPEGroupReport(UserID,"ILLSort",Total,ILLID)) q:ILLID=""  d
	..s ILLDesc=$G(^TempDHCPEGroupReport(UserID,"ILLSort",Total,ILLID))
	..s Count1=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,1,3))
	..s Count2=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,2,3))
	..s Count3=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLSexCount",ILLID,3,3))
	..s Percent1=..GetPercent(Count1,TotalCount1)
	..s Percent2=..GetPercent(Count2,TotalCount2)
	..s Percent3=..GetPercent(Count1,TotalCount3)
	..s OneInfo=ILLDesc_..#Split1_Count1_..#Split1_Percent1_..#Split1_Count2_..#Split1_Percent2_..#Split1_Count3_..#Split1_Percent3
	..i ret="" d
	...s ret=OneInfo
	..e  d
	...s ret=ret_..#Split2_OneInfo
	q ret
}

// 得到每个年龄段最多人数的疾病

ClassMethod GetILLAgeSexMax()
{
	;w ##class(web.DHCPE.GroupReportNew).GetILLAgeSexMax()
	;^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLnessID,Sort,AgeNum,SexNum)
	s Sort=1
	s UserID=%session.Get("LOGON.USERID")
	s ILLID=""
	f  s ILLID=$O(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID)) q:ILLID=""  d
	.s AgeNum=""
	.f  s AgeNum=$O(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum)) q:AgeNum=""  d
	..s SexNum=""
	..f  s SexNum=$O(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum,SexNum)) q:SexNum=""  d
	...s ILLCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum,SexNum))
	...s ^TempDHCPEGroupReport(UserID,"AgeSexILLMax",AgeNum,SexNum,ILLCount,ILLID)=""
	s ret=""
	s AgeNum=""
	f  s AgeNum=$O(^TempDHCPEGroupReport(UserID,"AgeSexILLMax",AgeNum)) q:AgeNum=""  d
	.;s ILLDesc=..GetILLDesc(ILLID)
	.s AgeDesc=..GetAgeRangeDesc(AgeNum)
	.s SexDesc=..GetSexDesc(1)
	.s ILLCount=""
	.s ILLCount=$O(^TempDHCPEGroupReport(UserID,"AgeSexILLMax",AgeNum,1,ILLCount),-1)
	.i ILLCount="" d
	..s ILLDesc=""
	..s Percent=""
	.e  d
	..s ILLID=""
	..s ILLID=$O(^TempDHCPEGroupReport(UserID,"AgeSexILLMax",AgeNum,1,ILLCount,""))
	..s ILLDesc=..GetILLDesc(ILLID)
	..s AgeCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,1))
	..s Percent=..GetPercent(ILLCount, AgeCount)
	.s OneInfo=AgeDesc_..#Split1_ILLDesc_..#Split1_ILLCount_..#Split1_Percent
	.s SexDesc=..GetSexDesc(2)
	.s ILLCount=""
	.s ILLCount=$O(^TempDHCPEGroupReport(UserID,"AgeSexILLMax",AgeNum,2,ILLCount),-1)
	.i ILLCount="" d
	..s ILLDesc=""
	..s Percent=""
	.e  d
	..s ILLID=""
	..s ILLID=$O(^TempDHCPEGroupReport(UserID,"AgeSexILLMax",AgeNum,2,ILLCount,""))
	..s ILLDesc=..GetILLDesc(ILLID)
	..s AgeCount=$G(^TempDHCPEGroupReport(UserID,"ListInfo","AgeSexPersonCount",Sort,AgeNum,2))
	..s Percent=..GetPercent(ILLCount, AgeCount)
	.s OneInfo=OneInfo_..#Split1_ILLDesc_..#Split1_ILLCount_..#Split1_Percent
	.i ret="" d
	..s ret=OneInfo
	.e  d
	..s ret=ret_..#Split2_OneInfo
	q ret
}

// 按照顺序得到所有的疾病

ClassMethod GetAllILL(CTLocID As %String = "")
{
	;w ##class(web.DHCPE.GroupReportNew).GetAllILL()
	//s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType",CTLocID)),"^",1)
	s Job=$J
	k ^TempDHCPE(Job,"TempILL")
	i DiagnosisType="N" d
	.;s ILLDesc=$P(^DHCPEED(ILLID,1),"^",1)
	e  d
	.s ILLID=0
	.f  s ILLID=$O(^DHCPEILLS(ILLID)) q:ILLID=""  d
	..s Sort=$P(^DHCPEILLS(ILLID),"^",1)
	..s ^TempDHCPE(Job,"TempILL",Sort,ILLID)=""
	s ret=""
	s Sort=0
	f  s Sort=$O(^TempDHCPE(Job,"TempILL",Sort)) q:Sort=""  d
	.s ILLID=""
	.f  s ILLID=$O(^TempDHCPE(Job,"TempILL",Sort,ILLID)) q:ILLID=""  d
	..i ret="" d
	...s ret=ILLID
	..e  d
	...s ret=ret_"^"_ILLID
	k ^TempDHCPE(Job,"TempILL")
	q ret
}

// 获取每种疾病的信息

ClassMethod GetOneILLInfo(ILLID, CTLocID As %String = "")
{
	;^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLnessID,Sort,AgeNum,SexNum)
	q:ILLID="" ""
	s Sort=1
	s UserID=%session.Get("LOGON.USERID")
	s Total=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount3",Sort))
	s MTotal=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount1",Sort))
	s FTotal=$G(^TempDHCPEGroupReport(UserID,"BaseInfo","SexPersonCount2",Sort))
	//s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	s DiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType",CTLocID)),"^",1)
	s ILLSex="N"
	i DiagnosisType="N" d
	.s ILLSex=$P(^DHCPEED(ILLID,1),"^",1)
	e  d
	.s ILLSex=$P(^DHCPEILLS(ILLID),"^",9)
	s:ILLSex="" ILLSex="N"
	;i (ILLSex="F")||(ILLSex="M") s TotalFlag="Y"
	s ret=""
	s AgeNum=""
	f  s AgeNum=$O(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum)) q:AgeNum=""  d
	.s AgeDesc=..GetAgeRangeDesc(AgeNum)
	.s MOneTotal=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum,1))
	.s MPercent=..GetPercent(MOneTotal, MTotal)
	.s FOneTotal=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum,2))
	.s FPercent=..GetPercent(FOneTotal, FTotal)
	.s OneTotal=$G(^TempDHCPEGroupReport(UserID,"ListInfo","ILLAgeSexCount",ILLID,Sort,AgeNum,3))
	.s Percent=..GetPercent(OneTotal, Total)
	.i ILLSex="F" d
	..s OneInfo=AgeDesc_..#Split1_FOneTotal_..#Split1_FPercent
	.e  i ILLSex="M" d
	..s OneInfo=AgeDesc_..#Split1_MOneTotal_..#Split1_MPercent
	.e  d
	..s OneInfo=AgeDesc_..#Split1_MOneTotal_..#Split1_MPercent_..#Split1_FOneTotal_..#Split1_FPercent_..#Split1_OneTotal_..#Split1_Percent
	.i ret="" d
	..s ret=OneInfo
	.e  d
	..s ret=ret_..#Split2_OneInfo
	q ILLSex_..#Split2_ret
}

}
