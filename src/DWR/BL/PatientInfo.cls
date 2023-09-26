Class DWR.BL.PatientInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##Class(DWR.BL.PatientInfo).GetDeptPatList(Param)
ClassMethod GetDeptPatList(Param As %String = "") As %String
{
	i Param="" s Param="<Request><userCode>030414</userCode><departmentId></departmentId></Request>"
    s Param=$TR(Param,$C(10))
    s retStr=""
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	i departmentId="" d
	.s departmentId=$P($G(^SSU("SSUSR",userId)),"^",4)
	.i departmentId'="" d
	..s deptTypeDr=$P($G(^CTLOC(departmentId)),"^",19)
	..//i deptTypeDr'=2 s departmentId=""
	..i $O(^PAC("ADMLOC",0,"AdmType","I",departmentId,""))="" s departmentId=""
	.s otherId=0
	.f  s otherId=$O(^SSU("SSUSR",userId,"OTHLL",otherId)) q:(otherId="")||(departmentId'="")  d
	..s departmentId=$P($G(^SSU("SSUSR",userId,"OTHLL",otherId)),"^",1)
	..s deptTypeDr=$P($G(^CTLOC(departmentId)),"^",19)
	..//i deptTypeDr'=2 s departmentId=""
	..i $O(^PAC("ADMLOC",0,"AdmType","I",departmentId,""))="" s departmentId=""
	q:$G(departmentId)="" "201^用户没有可登陆的科室!"
	s admDate=""
	f  s admDate=$O(^PAADMi("AdmTypeCurrLoc","I",departmentId,admDate)) q:(admDate="")  d
	.s admTime=""
	.f  s admTime=$O(^PAADMi("AdmTypeCurrLoc","I",departmentId,admDate,admTime)) q:(admTime="")  d
	..s admId=""
	..f  s admId=$O(^PAADMi("AdmTypeCurrLoc","I",departmentId,admDate,admTime,admId)) q:(admId="")  d
	...s bedId=$P($g(^PAADM(admId)),"^",73)
	...i bedId'="" s bedCode=$P($g(^PAWARD(+bedId,"BED",$P(bedId,"||",2))),"^",1)
	...e  s bedCode="空"
	...//q:bedCode="空"
	...s bedCode=bedCode_" "
	...q:$P($g(^PAADM(admId)),"^",75)
	...s wardId=$P($g(^PAADM(admId)),"^",70)
	...s mainDoctorId=$P($G(^PAADM(admId)),"^",9)
	...i mainDoctorId'="" d
	....s mainDoctorId=$O(^SSU("SSUSR",0,"CTPCP",mainDoctorId,"0"))
	...s isMainDoc=0
	...i mainDoctorId=userId s isMainDoc=1
	...s sameBedNo=+$O(DHCDWRTemp(userCode,wardId,isMainDoc,bedCode,""),-1)+1
	...s DHCDWRTemp(userCode,wardId,isMainDoc,bedCode,sameBedNo)=admId
	...s babyAdmId=""
	...f  s babyAdmId=$O(^PAADMi("Mother",admId,babyAdmId)) q:babyAdmId=""  d
	....s sameBedNo=+$O(DHCDWRTemp(userCode,wardId,isMainDoc,bedCode,""),-1)+1
	....s DHCDWRTemp(userCode,wardId,isMainDoc,bedCode,sameBedNo)=babyAdmId
	//取临时为本科的患者,主要用在其他科室的医生为本科室提供查房服务
	s admDate=""
	f  s admDate=$O(^PAADMi("TempLoc",admDate)) q:admDate=""  d
	.s admTime=""
	.f  s admTime=$O(^PAADMi("TempLoc",admDate,admTime)) q:admTime=""  d
	..s admId=""
	..f  s admId=$O(^PAADMi("TempLoc",admDate,admTime,admId)) q:admId=""  d
	...s bedId=$P($g(^PAADM(admId)),"^",73)
	...i bedId'="" s bedCode=$P($g(^PAWARD(+bedId,"BED",$P(bedId,"||",2))),"^",1)
	...e  s bedCode="空"
	...q:bedCode="空"
	...s bedCode=bedCode_" "
	...q:$P($g(^PAADM(admId)),"^",75)
	...s wardId=$P($g(^PAADM(admId)),"^",70)
	...s mainDoctorId=$P($G(^PAADM(admId)),"^",9)
	...i mainDoctorId'="" d
	....s mainDoctorId=$O(^SSU("SSUSR",0,"CTPCP",mainDoctorId,"0"))
	...s isMainDoc=0
	...i mainDoctorId=userId s isMainDoc=1
	...s sameBedNo=+$O(DHCDWRTemp(userCode,wardId,isMainDoc,bedCode,""),-1)+1
	...s DHCDWRTemp(userCode,wardId,isMainDoc,bedCode,sameBedNo)=admId
	...s babyAdmId=""
	...f  s babyAdmId=$O(^PAADMi("Mother",admId,babyAdmId)) q:babyAdmId=""  d
	....s sameBedNo=+$O(DHCDWRTemp(userCode,wardId,isMainDoc,bedCode,""),-1)+1
	....s DHCDWRTemp(userCode,wardId,isMainDoc,bedCode,sameBedNo)=babyAdmId
	////排序,先显示主管的患者,然后按照床位顺序排序,婴儿跟在母亲之后
	s wardId=""
	f  s wardId=$O(DHCDWRTemp(userCode,wardId)) q:wardId=""  d
	.s isMainDoc=""
	.f  s isMainDoc=$O(DHCDWRTemp(userCode,wardId,isMainDoc),-1) q:isMainDoc=""  d
	..s bedNode=""
	..f  s bedNode=$O(DHCDWRTemp(userCode,wardId,isMainDoc,bedNode)) q:bedNode=""  d
	...s sameBedNo=""
	...f  s sameBedNo=$O(DHCDWRTemp(userCode,wardId,isMainDoc,bedNode,sameBedNo)) q:sameBedNo=""  d
	....s admId=DHCDWRTemp(userCode,wardId,isMainDoc,bedNode,sameBedNo)
	....s visitStatus=$p($g(^PAADM(admId)),"^",20)
	....q:visitStatus'="A"    ///
	....s bedId=$P($g(^PAADM(admId)),"^",73)
	....i bedId'="" s bedCode=$P($g(^PAWARD(+bedId,"BED",$P(bedId,"||",2))),"^",1)
	....e  s bedCode="空"
	....s wardDr=$P($g(^PAADM(admId)),"^",70)
	....i wardDr'="" s wardDesc=$P($g(^PAWARD(wardDr)),"^",2)
	....e  s wardDesc=""
	....i $P(wardDesc,"-",2)'="" s wardDesc=$P(wardDesc,"-",2)
	....s patId=$P(^PAADM(admId),"^",1)
	....s patName=$P(^PAPER(patId,"ALL"),"^",1)
	....s patMedNo=$p($g(^PAPER(patId,"PAT",1)),"^",22)
	....s sex=$P(^PAPER(patId,"ALL"),"^",7)
	....s patSex=$P($g(^CT("SEX",sex)),"^",2)
	....s myObj=##class(DWR.MSG.PatientInfo).%New()
	....s myObj.admId=admId
	....s myObj.patMedNo=patMedNo
	....s myObj.wardDesc=wardDesc
	....s myObj.bedCode=bedCode
	....s myObj.patName=patName
	....s myObj.patSex=patSex
	....s myObj.patNote=""
	....s myObj.isMainDoc=isMainDoc
	....s ret=myObj.XMLExportToString(.Xml,"PatientInfo")
	....d myObj.%Close()
	....i ret=1 s retStr=retStr_Xml
	q retStr
}

/// w ##Class(DWR.BL.PatientInfo).GetPatInfo(Param)
ClassMethod GetPatInfo(Param As %String = "") As %String
{
	i Param="" s Param="<Request><userCode>030414</userCode><admId>426761</admId></Request>"
    s Param=$TR(Param,$C(10))
    s retStr=""
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "201^患者就诊Id不存在!"
	
	s patId=$P($G(^PAADM(admId)),"^",1)
	q:$G(patId)="" "201^患者就诊Id不存在!"
	s myObj=##class(DWR.MSG.PatientInfo).%New()
	s myPapmiObj=##Class(User.PAPatMas).%OpenId(patId)
	s myPaperObj=##Class(User.PAPerson).%OpenId(patId)
	s myAdmObj=##Class(User.PAAdm).%OpenId(admId)
	s myObj.admId=admId
	s myObj.patId=patId
	s myObj.patMedNo=myPapmiObj.PAPMIMedicare
	s myObj.patName=myPapmiObj.PAPMIName
	s myObj.patSexCode=myPaperObj.PAPERSexDR.CTSEXCode
	s myObj.patSex=myPaperObj.PAPERSexDR.CTSEXDesc
	s myObj.patAge=..CalAge(myPaperObj.PAPERDob,+$H)
	s patRegNo=..GetRegNobyEpisodeID(admId)
	s myObj.patRegNo=patRegNo
	s bloodType=..GetBloodType(patRegNo)
	i bloodType'="" s myObj.bloodType=bloodType
	e  s myObj.bloodType=myPaperObj.PAPERBloodTypeDR.BLDTDesc
	s occupation=myPaperObj.PAPEROccupationDR.CTOCCDesc
	i $P(occupation,"-",2)'="" s occupation=$P(occupation,"-",2)
	s myObj.occupation=occupation
	s myObj.marital=myPaperObj.PAPERMaritalDR.CTMARDesc
	s myObj.inDate=$ZDate(myAdmObj.PAADMAdmDate,3)
	s inDays=+$H-myAdmObj.PAADMAdmDate
	s myObj.inDays=inDays_"天"
	s myObj.bedCode=myAdmObj.PAADMCurrentBedDR.BEDCode
	s myObj.roomNo=myAdmObj.PAADMCurrentRoomDR.ROOMDesc
	s myObj.wardId=myAdmObj.PAADMCurrentWardDR.%Id()
	s wardDesc=myAdmObj.PAADMCurrentWardDR.WARDDesc
	i $P(wardDesc,"-",2)'="" s wardDesc=$P(wardDesc,"-",2)
	s myObj.wardDesc=wardDesc
	s myObj.departmentId=myAdmObj.PAADMDepCodeDR.%Id()
	s departmentName=myAdmObj.PAADMDepCodeDR.CTLOCDesc
	i $P(departmentName,"-",2)'="" s departmentName=$P(departmentName,"-",2)
	s myObj.departmentName=departmentName
	s doctorObj=myAdmObj.PAADMAdmDocCodeDR
	i ($IsObject(doctorObj))
	{
		s doctorId=doctorObj.%Id()
		i (doctorId'="") 
		{
			s myObj.mainDoctorId=$O(^SSU("SSUSR",0,"CTPCP",doctorId,"0"))
			s mainDoctor=$P($G(^CTPCP(doctorId,1)),"^",2)
			s myObj.mainDoctor=$P(mainDoctor,"-")
		}
	}
	s allergies=..GetPatientAllergies(patId)
	i allergies="" s allergies=$C(0)
	s myObj.allergies=allergies
	
	s condition=$char(0)
	s conditionNum="0"
	// 是否危重,需要配置危重医嘱项代码
	s img=##class(web.DHCSETIMAGE).IfOrddailyExist($get(admId),$get(^DHCDWRSET("ORD","Condition",1)))
	i (img="1")
	{
		s Condition="危重"
		s ConditionNum="1"
	}
	s img=##class(web.DHCSETIMAGE).IfOrddailyExist($get(admId),$get(^DHCDWRSET("ORD","Condition",2)))
	i (img="1")
	{
		set condition="病重"
		set conditionNum="2"
	}
	s myObj.condition=condition
	s myObj.conditionNum=conditionNum
	
	// 护理级别，需要配置护理级别医嘱项代码
	s careLevel=$char(0)
	s careLevelNum="0"
	s img1=##class(web.DHCSETIMAGE).IfOrddailyExist($get(admId),$get(^DHCDWRSET("ORD","CareLevel",1)))
	s img2=##class(web.DHCSETIMAGE).IfOrddailyExist($get(admId),$get(^DHCDWRSET("ORD","CareLevel",2)))
	s img3=##class(web.DHCSETIMAGE).IfOrddailyExist($get(admId),$get(^DHCDWRSET("ORD","CareLevel",3)))
	s img4=##class(web.DHCSETIMAGE).IfOrddailyExist($get(admId),$get(^DHCDWRSET("ORD","CareLevel",4)))
	if (img1="1")
	{
		s careLevel="一级护理"
		s careLevelNum="1"
	}
	if (img2="1")
	{
		s careLevel="二级护理"
		s careLevelNum="2"
	}
	if (img3="1")
	{
		s careLevel="三级护理"
		s careLevelNum="3"
	}
	if (img4="1")
	{
		s careLevel="特级护理"
		s careLevelNum="4"
	}
	s myObj.careLevel=careLevel
	s myObj.careLevelNum=careLevelNum
	s ret=myObj.XMLExportToString(.Xml,"PatientInfo")
	d myObj.%Close()
	i ret=1 s retStr=retStr_Xml
	q retStr
}

ClassMethod GetPatientAllergies(PatientID As %String = "") As %String
{
	set $ZT="GetPatientAllergiesET"
	set rtn=""
	if (PatientID="") quit rtn
	if ('$data(^PAPER(PatientID,"ALG"))) quit rtn
	set sid="0"
	while($order(^PAPER(PatientID,"ALG",sid))'="")
	{
		set sid=$order(^PAPER(PatientID,"ALG",sid))
		set PHCDM=$piece(^PAPER(PatientID,"ALG",sid),"^",27)
		if (PHCDM="") continue
		set AIGStatus=$piece(^PAPER(PatientID,"ALG",sid),"^",8)
		if (AIGStatus'="A") continue
		set DrugName=$piece($get(^PHCD(PHCDM,1)),"^",2)
		set AIGDate=$piece(^PAPER(PatientID,"ALG",sid),"^",10)
		set AIGDate=$ZDate(AIGDate,3)
		if (rtn="")
		{
			set rtn=DrugName_"["_AIGDate_"]"
		}
		else
		{
			set rtn=rtn_$char(10)_DrugName_"["_AIGDate_"]"
		}
		
	}
	quit rtn

GetPatientAllergiesET
	quit ""
}

/// 根据出生日计算年龄
ClassMethod CalAge(IBirth As %String, IToday As %String)
{
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	i AgeYear>0 q AgeYear_"岁"
	i AgeMth>0 q AgeMth_"月"
	i AgeDay>0 q AgeDay_"天"
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

ClassMethod GetBloodType(regNo As %String) As %String
{
  q:regNo="" ""
  s bldGpId=""
  i $d(^TDEB(regNo)) d
  .s bldGpId=$p($G(^TDEB(regNo)),"\",4)
  .i '$l(bldGpId) d
  ..s bldGpId=$p($g(^TDEB(regNo)),"\",10)
  s BG="",Rh=""
  i $l(bldGpId) d
  .s BG=$p(^TTAB("BB-BG",bldGpId),"\",2)_"型"
  .;i $p(^TTAB("BB-BG",bldGpId),"\",3)="P" s Rh="阳性(+)"
  .;i $p(^TTAB("BB-BG",bldGpId),"\",3)="N" s Rh="阴性(-)"
  s BGRh=BG_Rh
  q BGRh
}

ClassMethod GetRegNobyEpisodeID(EpisodeID)
{
 	q:$g(EpisodeID)="" ""
 	q:'$d(^PAADM(EpisodeID)) ""
 	s PaitentID=$p(^PAADM(EpisodeID),"^",1)
 	s admType=$p(^PAADM(EpisodeID),"^",2)
 	
 	q:$g(PaitentID)="" ""
 	q:'$D(^PAPER(PaitentID,"PAT",1)) ""
 	q:admType="I" $p(^PAPER(PaitentID,"PAT",1),"^",1)
 	q $p(^PAPER(PaitentID,"PAT",1),"^",2)
}

}
