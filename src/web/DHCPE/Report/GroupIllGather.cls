/// zhouli
///  团体疾病汇总
/// 组件：DHCPEGroupIllGather
Class web.DHCPE.Report.GroupIllGather Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 224;

// d ##class(web.DHCPE.Report.GroupIllGather).GetIADM("9")

ClassMethod GetIADM(GADM)
{
	k ^DHCPETMP("IADMAdmDate")
	Q:GADM=""
	s str=""
	s GTeamDR=0
	f  s GTeamDR=$o(^DHCPEIADM(0,"GADM",GADM,GTeamDR))  q:GTeamDR=""  d
	.s IADMRowId=0
	.f  s IADMRowId=$o(^DHCPEIADM(0,"GADM",GADM,GTeamDR,IADMRowId))  q:IADMRowId=""  d
	..s IADMAdmDate=""
	..s IADMAdmDate=$p(^DHCPEIADM(IADMRowId),"^",5)
	..i ""'=IADMAdmDate  s IADMAdmDate=$ZD(IADMAdmDate,3)
	..s PreIADM=$p(^DHCPEIADM(IADMRowId),"^",4)
	..q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PreIADM,"Person")="0"
	..s PIBIDR=$P(^DHCPEPreIADM(PreIADM),"^",1)
	..s Position=$p(^DHCPEPreIBI(PIBIDR),"^",11)
	..i Position=""  s Position="无部门"
	..//没有检查或取消体检的人员退出
	..s GSRowId=0
	..s GSRowId=$o(^DHCPEGS(0,"IADM",IADMRowId,GSRowId))
	..q:GSRowId=""
	..s Flag=0
	..s ADMLoc=$p($g(^DHCPEPreIADM(PreIADM)),"^",26),PAADM=$p(^DHCPEIADM(IADMRowId),"^",1)
	..s MainDoctorGroup=$g(^DHCPESetting("DHCPE","MainDoctorGroup",ADMLoc))  //复检标志
	..q:((MainDoctorGroup="Y")&&('$d(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))))  // 复检判断
   	..s ^DHCPETMP("IADMAdmDate",Position,IADMAdmDate,IADMRowId)=IADMRowId
  
	s str=""
	s Position=0
	f  s Position=$o(^DHCPETMP("IADMAdmDate",Position))  q:Position=""   d
	.s IADMAdmDate=0
	.f  s IADMAdmDate=$o(^DHCPETMP("IADMAdmDate",Position,IADMAdmDate)) q:IADMAdmDate=""  d
	..s IADMRowId=0
	..f  s IADMRowId=$o(^DHCPETMP("IADMAdmDate",Position,IADMAdmDate,IADMRowId))  q:IADMRowId=""  d
	...s IADM=$G(^DHCPETMP("IADMAdmDate",Position,IADMAdmDate,IADMRowId))
	...i str="" s str=IADM
	...e   s str=str_"^"_IADM

    //w !,str
 	q str
}

// d ##class(web.DHCPE.Report.GroupIllGather).GetPatInfo("230")

ClassMethod GetPatInfo(IADMRowId)
{
   
  
    q:IADMRowId=""
    s str=""
    s PreIADM=""
    s IADMAdmDate=""
    s PIBIDR=""
    s conlusionStr=""
    s PGTID=""
    s PGTNAME=""
    s PreIADM=$p(^DHCPEIADM(IADMRowId),"^",4)
    s PGTID=$p(^DHCPEPreIADM(PreIADM),"^",3)
	s PGTNAME=$P(^DHCPEPreGADM(+PGTID,"Team",$p(PGTID,"||",2)),"^",1)
    s IADMAdmDate=$p(^DHCPEIADM(IADMRowId),"^",5)
    i ""'=IADMAdmDate  s IADMAdmDate=$ZD(IADMAdmDate,3)
    s PIBIDR=$P(^DHCPEPreIADM(PreIADM),"^",1)
	s Name=$p(^DHCPEPreIBI(PIBIDR),"^",2)
	s SexDR=$p(^DHCPEPreIBI(PIBIDR),"^",3)
	s SexDesc=$p(^CT("SEX",SexDR),"^",2)
	//s PAPMINo=$p(^DHCPEPreIBI(PIBIDR),"^",1)  //登记号
	s dob=$p(^DHCPEPreIBI(PIBIDR),"^",4)       //出生年月   
 	s Age=""
 	s:(""'=dob) Age=##class(web.DHCLCNUREXCUTE).CalAge(dob,+$h)
 	s Age=$P(Age,"Y")        //年龄
 	s Position=$p(^DHCPEPreIBI(PIBIDR),"^",11)
 	i Position=""  s Position="无部门"
 	s GSRowId=0
 	s Flag=0
 	f  s GSRowId=$o(^DHCPEGS(0,"IADM",IADMRowId,GSRowId))  q:GSRowId=""  d
 	.//s Flag=1
 	.
 	.s GSDChildSub=0
 	.f  s GSDChildSub=$o(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub))  q:GSDChildSub=""  d
 	..s GSDEDDR=0
 	..s GSDEDDR=$p(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub),"^",1) 
 	..s diagnoseconlusion=$p($g(^DHCPEED(GSDEDDR,1)),"^",1)
 	..//i diagnoseconlusion=""  s diagnoseconlusion="所做检查大致正常"
 	..i conlusionStr=""  s conlusionStr=diagnoseconlusion
 	..e  s conlusionStr=conlusionStr_";"_diagnoseconlusion
	//i (conlusionStr="")&&(GSRowId'="")  s conlusionStr="所做检查大致正常"
	//i (conlusionStr="")&(Flag=1)   s conlusionStr="所做检查大致正常"
	//i (conlusionStr="")&(GSRowId'="")  s conlusionStr="所做检查大致正常"
	//s ^DHCPETMP("IADMAdmDate",IADMAdmDate,IADMRowId)=IADMAdmDate_"^"_Name_"^"_SexDesc_"^"_Age_"^"_conlusionStr
    // q:Flag=0
    s str="^"_IADMAdmDate_"^"_Name_"^"_SexDesc_"^"_Age_"^"_conlusionStr_"^"_Position
	
  
  	q str
}

ClassMethod GetSpecialReportInfo(IADM)
{
	;web.DHCPE.ReportGetInfor
	s PAADM=$P($G(^DHCPEIADM(IADM)),"^",1)
	q:PAADM="" ""
	q ##class(web.DHCPE.ReportGetInfor).GetSpecialReportInfo(PAADM,"DHCPEXRayReport.xls")
}

}
