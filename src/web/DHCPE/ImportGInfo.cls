Import SQLUser

Class web.DHCPE.ImportGInfo Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 425;

Property JobID As %String(TRUNCATE = 1);

ClassMethod SetJobID(job As %String = "aaaa")
{
	s JobID=job
}

ClassMethod GetTeamStatus(GID)
{
  s sub=""
  s sub=$o(^DHCPEPreGADM(GID,"Team",0))
  q sub
}

ClassMethod GetRegNoByEmploy(EmployeeNo)
{
	q:EmployeeNo="" ""
	s ERegNo=""
	s PAPMIID=""
	f  s PAPMIID=$O(^PAPERi("EmplNo",EmployeeNo,PAPMIID)) q:PAPMIID=""  d
	.s ActiveFlag=$P(^PAPER(PAPMIID,"PAT",1),"^",6)
	.q:ActiveFlag="N"
	.s ERegNo=$P(^PAPER(PAPMIID,"PAT",1),"^",1)
	q ERegNo
}

ClassMethod GetRegNoByMedical(MedicalNo)
{
	q:MedicalNo="" ""
	s MedicalNo=$ZCVT(MedicalNo,"U")
	s MRegNo=""
	s PAPMIID=""
	f  s PAPMIID=$O(^PAPERi("Medicare1",MedicalNo,PAPMIID)) q:PAPMIID=""  d
	.s ActiveFlag=$P(^PAPER(PAPMIID,"PAT",1),"^",6)
	.q:ActiveFlag="N"
	.s MRegNo=$P(^PAPER(PAPMIID,"PAT",1),"^",1)
	q MRegNo
}

/// 检验个人信息是否符合条件
/// InString TName^RegNo^Name^CardNo^Sex^Age^Birth^Married^MoveTel^Tel^Address^StartDate^EndDate^AsCharged^IReportSend^ChargedMode^AddItem^AddItemLimit^AddItemAmount^AddMedical^AddMedicalLimit^AddMedicalAmount
/// w ##class(web.DHCPE.ImportGInfo).GetGPersonInfo("82","^0000001035^邹博丹^130729199209209771^男^30^20/09/1992^^^^^^^^^^^^^^^^^^^^^^^^^^^^^1","Check",18853,"飞新集团","0")
ClassMethod GetGPersonInfo(GID, InString, Type As %String = "Import", job As %String = "aaaa", GDesc, AllowCF As %String = "")
{
	new GenModel
	s $zt="GetErr"
	s ErrInfo=""
	d ..SetJobID(job)

	s LocID=$P($g(^DHCPEPreGADM(GID)),"^",23)
	 

	s RowSort=$p(InString,"^",$L(InString,"^"))
	s TName=$p(InString,"^",1)

	s CardNoJZ=$p(InString,"^",29)   //就诊卡号
	s RegNo=$p(InString,"^",2)
	s GenModel=##class(web.DHCPE.Public.Setting).GetPAPMINoGenModel()
	s:(GenModel'="NoGen")&&(RegNo="") ErrInfo=..IsVaild("登记号不能为空"_$c(10),Type)
	
	s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo,LocID)
	
	//根据工号和病案号找ID号
	
	s EmployeeNo=$p(InString,"^",31)
	s InMedicare=$p(InString,"^",32)
	s MRegNo=..GetRegNoByMedical(InMedicare)
	s:(InMedicare'="")&&(MRegNo="") ErrInfo=ErrInfo_..IsVaild("病案号对应的登记号不存在:"_InMedicare_$c(10),Type)
	/*
	i MRegNo="" d
	s ERegNo=..GetRegNoByEmploy(EmployeeNo)
	q:(EmployeeNo'="")&&(ERegNo="") ..IsVaild("工号对应的登记号不存在:"_EmployeeNo,Type)
	q:(MRegNo'=ERegNo)&&(ERegNo'="")&&(MRegNo'="") ..IsVaild("工号登记号:"_ERegNo_"和病案号对应的登记号:"_MRegNo_"不一致",Type)
	s:ERegNo'="" MRegNo=ERegNo
	*/
	s:(RegNo'=MRegNo)&&(MRegNo'="")&&(RegNo'="") ErrInfo=ErrInfo_..IsVaild("病案号对应的ID:"_MRegNo_"和所给登记号:"_RegNo_"不一致"_$c(10),Type)
	i MRegNo'="" s RegNo=MRegNo
	
	i RegNo'=""
	{
		s PAPID=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
		s:PAPID="" ErrInfo=ErrInfo_..IsVaild("登记号不正确:"_RegNo_$c(10),Type)
		s OldEmpNo=$P($g(^PAPER(PAPID,"EMP")),"^",5)
		i (+OldEmpNo'=+EmployeeNo)&&(EmployeeNo'="")&&(OldEmpNo'=""){
			;s ERegNo=..GetRegNoByEmploy(EmployeeNo)
			;q:(ERegNo'="")&&(ERegNo'=RegNo) ..IsVaild("工号ID:"_ERegNo_"和病案号ID"_RegNo_"不一致:"_$c(10),Type)
			s ErrInfo=ErrInfo_..IsVaild(PAPID_"所给工号:"_EmployeeNo_"和原工号不一致:"_OldEmpNo_$c(10),Type)
		}
		
	}
	//根据工号和病案号找ID号End
	//工种和接害工龄  
	s WorkTypeID="", EndangerWorkAge="" ,WorkType="" 
	s WorkTypeID=$p(InString,"^",34)
	i WorkTypeID'="" s WorkType=$o(^User.DHCPEWorkTypeI("WTDescIndex",""_WorkTypeID,0))  //按名称检索
	s EndangerWorkAge=$p(InString,"^",35) 

	
	s Name=$p(InString,"^",3)
	i Name="" s ErrInfo=ErrInfo_..IsVaild("姓名不能为空"_$c(10),Type)
	
	
	s RegNoFlag=..CheckRegNo(.RegNo,.CardNoJZ,.LocID)
	s:RegNoFlag'=1 ErrInfo=ErrInfo_..IsVaild("无效的个人登记号:"_RegNoFlag_$c(10),Type)
	
	s NameFlag=##class(web.DHCPE.ImportGInfo).CheckName(RegNo,Name,LocID)
	s:NameFlag=1 ErrInfo=ErrInfo_..IsVaild("登记号"_RegNo_"对应的名字,和现有名字不符"_$c(10),Type)
	s Sex=$p(InString,"^",5)
	s Sex=..GetSexId(Sex)
	i Sex="" s ErrInfo=ErrInfo_..IsVaild("性别设置不正确"_$c(10),Type)
	
	s SexFlag=##class(web.DHCPE.ImportGInfo).CheckSex(RegNo,Sex,LocID)
	s:SexFlag=1 ErrInfo=ErrInfo_..IsVaild("登记号"_RegNo_"对应的性别,和现有性别不符"_$c(10),Type)
	
	
	s CardNo=$p(InString,"^",4)  //身份证
	s CardNo=##class(web.DHCPE.Public.Setting).Replace(CardNo," ","")
	s CardNo=##class(web.DHCPE.Public.Setting).Replace(CardNo,"'","")
	s CardNo=##class(web.DHCPE.Public.Setting).Replace(CardNo,$C(10),"")
	s CardNo=##class(web.DHCPE.Public.Setting).Replace(CardNo,$C(13),"")

	s exitName=0 
	s exitSex=0
	s CardNoIndex=$ZCVT(CardNo,"U")
	S:$L(CardNoIndex)'=$L(CardNo) ErrInfo=ErrInfo_..IsVaild("身份证号"_CardNo_"有异常字符"_$C(10),Type)
	s Flag=..CheckRegNoByCardId(CardNoIndex,RegNo,Type)
	s IDRegFlag=Flag
	
	i (RegNo="")&&(+Flag>0)  d
	.s RegNo=$p(Flag,"^",$l(Flag,"^"))
	.s papmirowid=""
	.s papmirowid=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
    .s name=$p(^PAPER(papmirowid,"ALL"),"^",1)
    .s sexid=$p(^PAPER(papmirowid,"ALL"),"^",7)
    .s sex=$p(^CT("SEX",sexid),"^",2)
    .s Sexname=$p(^CT("SEX",Sex),"^",2)
    .i name'=Name s exitName=1
    .i sexid'=Sex   s exitSex=1
    
    i exitName=1 s ErrInfo=ErrInfo_..IsVaild("系统中已存在身份证号为:"_CardNo_"的病人,姓名为:"_name_",与所导姓名"_Name_"不相符"_$c(10),Type)
	i exitSex=1  s ErrInfo=ErrInfo_..IsVaild("系统中已存在身份证号为:"_CardNo_"的病人,姓名为:"_name_",性别为:"_sex_"与所导性别"_Sexname_"不相符"_$c(10),Type)
	//验证有相同人员给与提示
	s CheckFlag=1                                             //add by zhouli start
	if CardNoIndex'=""  d
	 .i '$d(^DHCPEImportGInfo("CheckCardId",JobID,CardNoIndex))   s ^DHCPEImportGInfo("CheckCardId",JobID,CardNoIndex)=Name
	 .else  s CheckFlag=0
	i CheckFlag=0  s ErrInfo=ErrInfo_..IsVaild("身份证相同的人在导入模板里已存在"_$c(10),Type)    //add by zhouli end
	e  d
	.q:RegNo=""
	.s PIBI=$O(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	.q:PIBI=""
	.s ExistFlag=##class(web.DHCPE.PreIADM).GroupIsExistIADM(PIBI,GID)
	.i ExistFlag=1 d
	..s:AllowCF'="1" ErrInfo=ErrInfo_..IsVaild("登记号相同的人在团体里已存在"_$c(10),Type)

	
	s Age=$p(InString,"^",6)
	s Birth=$p(InString,"^",7)
	i (Birth="")&&(Age="")&&(RegNo'="")  d
	.s ReturnStr=..CheckBodAndAgeByRegNo(RegNo,LocID)
	.s Birth=$p(ReturnStr,"^",1)
	.s Age=$p(ReturnStr,"^",2)
	i (Birth="")&&(Age="") s ErrInfo=ErrInfo_..IsVaild("年龄或者生日必须设置一个"_$c(10),Type)
	i Birth="" d
	.s Year=$ZD($H,3)
	.s ReduceYear=(+Year)-Age
	.s $p(Year,"-",1)=ReduceYear
	.s $p(Year,"-",3)="01"
	.s Birth=Year
	//i Birth'="" s Birth=$ZDH(Birth,3)
	i Birth'="" s Birth=##class(websys.Conversions).DateHtmlToLogical(Birth)
	
	
	i Type="Check"
	{   
		s Flag=..CheckRegNoInGroupByName(Name,Sex,Age,Type,JobID,GDesc)
		;i Flag'=0 s ErrInfo=ErrInfo_..IsVaild("团体中姓名、性别、年龄相同的登记号还存在,登记号为"_Flag_$c(10),Type)
	}
    
	i Type="Check"
	{
		s Flag=..CheckRegNoByDobName(Birth,Name,RegNo,Sex,Type)
		;i +Flag>0 s ErrInfo=ErrInfo_..IsVaild("姓名生日性别相同的卡号还存在,卡号为"_Flag_$c(10),Type)
	}

	s Married=$p(InString,"^",8)
	s Married=..GetMarried(Married)
	//i Married="" q ..IsVaild("婚否设置不正确",Type)
	
	//根据条件得到分组ID
	s TeamId=..GetTIDByInfo(TName,Birth,Sex,Married,GID)
	
	i TeamId="" s ErrInfo=ErrInfo_..IsVaild("没有找到正确的分组"_$c(10),Type)
	s Sort=+$G(^DHCPEImportGInfo("ImportG",JobID,"Sort"))
	s Sort=Sort+1
	s TInfo="^^^"_$G(^DHCPEPreGADM(+TeamId,"Team",$p(TeamId,"||",2))) //增加^^^是为了和原来的统一
	//i $p(TInfo,"^",4)'=TName q ..IsVaild("分组名称不正确",Type)
	i (TName'="")&&($p(TInfo,"^",4)'=TName) s ErrInfo=ErrInfo_"分组名称不正确"
	s MoveTel=$p(InString,"^",9)
	s Tel=$p(InString,"^",10)
	
	/*
	s Position=$p(InString,"^",26)
	s TempSort=$O(^DHCPEWRZ(Name,""),-1)
	s TempSort=+TempSort+1
	s ^DHCPEWRZ(Name,TempSort)=Birth_"^"_Sex_"^"_Position_"^"_Tel_"^"_TeamId
	s ^DHCPEWRZ=+$G(^DHCPEWRZ)+1
	*/
	
	
	s Address=$p(InString,"^",26) ;11  部门和联系地址互换
	
	s StartDate=$p(InString,"^",12)
	i StartDate'="" d
	.s StartDate=$ZDH(StartDate,3)
	e  d
	.;s StartDate=$p(TInfo,"^",5)
	.s StartDate=+$h
	
	s EndDate=$p(InString,"^",13)
	i EndDate'="" d
	.s EndDate=$ZDH(EndDate,3)
	e  d
	.;s EndDate=$p(TInfo,"^",6)
	.s EndDate=+$h
	
	s GInfo="^"_$G(^DHCPEPreGADM(GID)) //增加^是为了和原来的统一
	
	s IReportSend=$p(InString,"^",15)
	i IReportSend="统取" d
	.s IReportSend="GS"
	e  i IReportSend="自取" d
	.s IReportSend="IS"
	e  d
	.s IReportSend=$p(GInfo,"^",16)
	
	s ChargedMode=$p(InString,"^",16)
	i ChargedMode="统结" d
	.s ChargedMode="GD"
	e  i ChargedMode="自结" d
	.s ChargedMode="ID"
	e  d
	.s ChargedMode=$p(TInfo,"^",22)
	.s:ChargedMode="" ChargedMode=$p(GInfo,"^",17)
	
	s AsCharged=$p(InString,"^",14)
	i AsCharged="是" d
	.s AsCharged="Y"
	e  i AsCharged="否" d
	.s AsCharged="N"
	e  d
	.s AsCharged=$p(GInfo,"^",8)
	.i ChargedMode="ID" s AsCharged="N"
	
	s AddItem=$p(InString,"^",17)
	i AddItem="是" d
	.s AddItem="Y"
	e  i AddItem="否" d
	.s AddItem="N"
	e  d
	.s AddItem=$p(TInfo,"^",9)
	
	s AddItemLimit=$p(InString,"^",18)
	i AddItem="N" d
	.s AddItemLimit="N"
	e  d
	.i AddItemLimit="是" d
	..s AddItemLimit="Y"
	.e  i AddItemLimit="否" d
	..s AddItemLimit="N"
	.e  d
	..s AddItemLimit=$p(TInfo,"^",10)
	
	s AddItemAmount=$p(InString,"^",19)
	i AddItemLimit="N" d
	.s AddItemAmount=""
	e  d
	.i AddItemAmount="" d
	..s AddItemAmount=$p(TInfo,"^",11)
	
	s AddMedical=$p(InString,"^",20)
	i AddMedical="是" d
	.s AddMedical="Y"
	e  i AddMedical="否" d
	.s AddMedical="N"
	e  d
	.s AddMedical=$p(TInfo,"^",12)
	
	s AddMedicalLimit=$p(InString,"^",21)
	i AddMedical="N" d
	.s AddMedicalLimit="N"
	e  d
	.i AddMedicalLimit="是" d
	..s AddMedicalLimit="Y"
	.e  i AddMedicalLimit="否" d
	..s AddMedicalLimit="N"
	.e  d
	..s AddMedicalLimit=$p(TInfo,"^",13)
	
	s AddMedicalAmount=$p(InString,"^",22)
	i AddMedicalLimit="N" d
	.s AddMedicalAmount=""
	e  d
	.i AddMedicalAmount="" d
	..s AddMedicalAmount=$p(TInfo,"^",14)
	//s CheckInfo=..IsValidGTeamIADM(Sex,Birth,Married,TInfo)
	//q:CheckInfo'="" ..IsVaild(CheckInfo,Type)
	s Company=$p(InString,"^",23)
	s Nation=$p(InString,"^",24)
	s NewCard=$p(InString,"^",25)
	i NewCard="是"
	{
		i GenModel="NoGen"
		{
			i +RegNo'=0 s ErrInfo=ErrInfo_..IsVaild("新发卡设置不正确"_$c(10),Type)
		}
		else
		{
			i GenModel="FreeCreate"
			{
				s PAPID=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
				i PAPID'="" s ErrInfo=ErrInfo_..IsVaild("新发卡设置不正确"_$c(10),Type)
			}
			else
			{
				i PAName'="未用" s ErrInfo=ErrInfo_..IsVaild("新发卡设置不正确"_$c(10),Type)
			}
		}
		
	}
	s User=%session.Get("LOGON.USERID")
	s Date=+$H
	s Position=$p(InString,"^",11)  ;26
	i Position="" d
	.s Depart="无部门"
	e  d
	.s Depart=Position
	s PatType=$p(InString,"^",27)
	s PatType=..GetPatTypeId(PatType)
	
	i PatType="" d
	.;s PatType=$G(^DHCPESetting("DHCPE","DefPatientType"))
	.s PatType=$G(^DHCPESetting("DHCPE","DefPatientType",LocID))
	.s PatType=+PatType
	
	s HCADesc=$p(InString,"^",28)
	s HCADR=..GetHCADR(HCADesc)
	s DepLoc=%session.Get("LOGON.CTLOCID")                     //add 2009-07-02
	s VIPDesc=""
	s VIPDesc=$p(InString,"^",30)
	s VIPLevel=""
	
	i VIPDesc'="" d
	.s VIPID=0,VIP=0
	.f  s VIPID=$o(^DHCPEVIPLevel("VIP",VIPID)) q:(VIPID="")||(VIP=1)  d
	..s Desc=$p(^DHCPEVIPLevel("VIP",VIPID),"^",2)
	..i Desc=VIPDesc d
	...s VIPLevel=VIPID
	...s VIP=1
	e  d
	.e  s VIPLevel=$g(^DHCPECBVIPLevel("PGT",TeamId))
	
	s Post=$p(InString,"^",33)
	;i (+IDRegFlag>0)&&(Type'="Import")  s ErrInfo=ErrInfo_..IsVaild("身份证相同的登记号还存在,登记号为&"_IDRegFlag,Type)
	q:ErrInfo'="" ..IsVaild(ErrInfo,Type)
	s ^DHCPEImportGInfo("ImportG",JobID,"GTeam",TeamId,"IBaseInfo",Depart,Sort)="^"_RegNo_"^"_Name_"^"_Sex_"^"_Birth_"^"_PatType_"^"_Tel_"^^"_MoveTel_"^"_CardNo_"^^"_Position_"^"_Company_"^^"_Address_"^"_Nation_"^^"_Married_"^^"_Date_"^"_User_"^"_HCADR_"^"_CardNoJZ_"^"_VIPLevel_"^"_EmployeeNo_"^"_RowSort   ;RowSort一定放到所有的最后 
	s Time=$p($H,",",2)
	s ^DHCPEImportGInfo("ImportG",JobID,"GTeam",TeamId,"IADM",Depart,Sort)="^^^^"_StartDate_"^"_EndDate_"^"_Time_"^^"_"PREREG^"_AsCharged_"^"_AddItem_"^"_AddItemLimit_"^"_AddItemAmount_"^"_AddMedical_"^"_AddMedicalLimit_"^"_AddMedicalAmount_"^"_IReportSend_"^"_ChargedMode_"^"_VIPLevel_"^^^"_User_"^"_Date_"^"_Time_"^^"_Post_"^"_DepLoc_"^"_WorkType_"^"_EndangerWorkAge
	s ^DHCPEImportGInfo("ImportG",JobID,"Sort")=Sort
	q 0
GetErr
	//TROLLBACK
	//q $ZERROR
	//q $g(TName)_"^"_$g(Birth)_"^"_$g(Sex)_"^"_$g(Married)_"^"_$g(GID)_"^错误:"_$G(Name)_$ZERROR
	I ErrInfo'="" q "错误:"_$G(Name)_" "_ErrInfo
	E  q $g(TName)_"^"_$g(Birth)_"^"_$g(Sex)_"^"_$g(Married)_"^"_$g(GID)_"^错误:"_$G(Name)_$ZERROR
}

/// 根据身份证判断是否已经有卡存在1有 0没有
/// w ##class(web.DHCPE.ImportGInfo).CheckRegNoByCardId("110104195701050078","","Import")
ClassMethod CheckRegNoByCardId(CardNoIndex, RegNo, Type As %String = "Import")
{
	new (CardNoIndex, RegNo, Type)
	s PAPMIId=0
	s bFlag=0
	s Flag=0
	s rRegNo=""
	i CardNoIndex="" q bFlag
	s curRegNo=..GetRegNoByIDCard(CardNoIndex)
	
	q:curRegNo="" "0"
	q:(Type="Import")&&(RegNo=curRegNo) "0"
	q curRegNo
}

/// 判断信息不符合的时候退出
ClassMethod IsVaild(String, Type As %String = "Import")
{
	//i Type="Import" d ..KillImportGlobal(JobID)
	//k ^DHCPEImportGInfo("ImportG",JobID)
	q String
}

/// 根据婚否描述得到婚否ID
ClassMethod GetMarried(Married)
{
	i Married="" q ""
	s Married=$o(^CT("MAR",0,"Desc",Married,0))
	q Married
}

/// 根据性别描述得到性别ID
ClassMethod GetSexId(Sex)
{
	i Sex="" q ""
	s Sex=$o(^CT("SEX",0,"Desc",Sex,0))
	q Sex
}

/// 根据分类描述得到分类信息
/// w ##class(web.DHCPE.ImportGInfo).GetPatTypeId("医保")
ClassMethod GetPatTypeId(PatType)
{
	i PatType="" q ""
	s PatType=$o(^CT("SS",0,"Desc",PatType,0))
	q PatType
}

/// 得到健康区域的Id
ClassMethod GetHCADR(HCADesc)
{
	i HCADesc="" q ""
	s HCADesc=$ZCVT(HCADesc,"U")
	s HCADR=$o(^CT("HCA",0,"Desc",HCADesc,0))
	q HCADR
}

/// 导入数据库数据信息 w ##class(web.DHCPE.ImportGInfo).Main(4,5888)
ClassMethod Main(GID, job As %String = "aaaa", CTLocID As %String = "")
{
	k PreGADMList,PreGBaseInfoList
	d ..SetJobID(job)
	;k ^DHCPEImportGInfo("ImportGErr",GID,JobID)
	s SQLCODE=0
	s ErrRows=""
	s SussNum=0
	//TSTART
	s tsub=0
	f  s tsub=$O(^DHCPEPreGADM(GID,"Team",tsub)) q:(tsub="")||(SQLCODE'=0)  d
	.s TeamID=GID_"||"_tsub
	.s Depart=""
	.f  s Depart=$O(^DHCPEImportGInfo("ImportG",JobID,"GTeam",TeamID,"IBaseInfo",Depart)) q:(Depart="")||(SQLCODE'=0)  d
	..s sort=0
	..f  s sort=$O(^DHCPEImportGInfo("ImportG",JobID,"GTeam",TeamID,"IBaseInfo",Depart,sort)) q:(sort="")||(SQLCODE'=0)  d
	...TSTART
	...s SQLCODE=..ImportIADM(GID,TeamID,Depart_"^"_sort,"TeamID",CTLocID)
	...TCOMMIT:SQLCODE=0
	...//q:SQLCODE'=0
	...TROLLBACK:SQLCODE'=0
	...s:SQLCODE=0 SussNum=SussNum+1
	...q:SQLCODE=0
	...s Info=$G(^DHCPEImportGInfo("ImportG",JobID,"GTeam",TeamID,"IBaseInfo",Depart,sort))
	...s RowSort=$P(Info,"^",$L(Info,"^"))
	...i ErrRows="" d
	....s ErrRows=RowSort
	...e  d
	....s ErrRows=ErrRows_"^"_RowSort
	...s ^DHCPEImportGInfo("ImportGErr",GID,JobID,RowSort)=Info
	
	//d ##class(web.DHCPE.GAdmRecordManager).Insert(GID,"P","Import","","")
	d ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(GID)
	//TCOMMIT
	d ..KillImportGlobal(JobID)
	q SQLCODE_"^"_GID_"^"_"错误数据请查看sheet1"_"^"_SussNum
}

/// 导入个人信息  
/// Type不为空的时候就是根据分组Id导入
ClassMethod ImportIADM(PreGADMID, TeamID, RegNo, Type As %String = "", CTLocID As %String = "")
{
	k IBaseInfoLIST,IADMLIST
	s Depart=$P(RegNo,"^",1)
	s RegNo=$P(RegNo,"^",2)
	s IBaseInfo=$G(^DHCPEImportGInfo("ImportG",JobID,"GTeam",TeamID,"IBaseInfo",Depart,RegNo))
	s IBaseInfo=##class(web.DHCPE.Public.Setting).Replace(IBaseInfo," ","")
	s RealRegNo=$P(IBaseInfo,"^",2)
	s IBaseInfoID=""
	i RealRegNo'="" d
	.s IBaseInfoID=$o(^DHCPEPreIBI(0,"PAPMINo",RealRegNo,""))
	
	s SQLCODE=..UpdateHISPersonData(.RealRegNo,IBaseInfo,CTLocID)
	q:SQLCODE'=0 SQLCODE
	s $P(IBaseInfo,"^",2)=RealRegNo
	s i=$L(IBaseInfo,"^")-4
	f j=1:1:i
	{
		s IBaseInfoLIST(j)=$P(IBaseInfo,"^",j)
	}
	k IBaseInfoLIST(1)
	s OldInfo=##class(web.DHCPE.ModifyRecord).GetInfo(IBaseInfoID,"IBaseInfo")
	i IBaseInfoID="" d
	.&SQL(Insert Into SQLUSER.DHC_PE_PreIBaseInfo Values :IBaseInfoLIST())
	.;s ^DHCPECBVIPLevel("PIBI",IBaseInfoLIST(2))=$P(IBaseInfo,"^",24)
	e  d
	.i (IBaseInfoLIST(9)="")&&($p($g(^DHCPEPreIBI(IBaseInfoID)),"^",8)'="") d
	..s IBaseInfoLIST(9)=$p($g(^DHCPEPreIBI(IBaseInfoID)),"^",8)
	.&SQL(Update SQLUSER.DHC_PE_PreIBaseInfo Values :IBaseInfoLIST() 
		where PIBI_RowId = :IBaseInfoID)
	q:SQLCODE'=0 SQLCODE
	s IBaseInfoID=%ROWID
	s IADMInfo=$G(^DHCPEImportGInfo("ImportG",JobID,"GTeam",TeamID,"IADM",Depart,RegNo))
	s NewInfo=##class(web.DHCPE.ModifyRecord).GetInfo(IBaseInfoID,"IBaseInfo")
	d ##class(web.DHCPE.ModifyRecord).Save(IBaseInfoID,"IBaseInfo",OldInfo,NewInfo, %session.Get("LOGON.USERID"))
	s i=$L(IADMInfo,"^")
	f j=1:1:i-2
	{
		s IADMLIST(j)=$P(IADMInfo,"^",j)
	}
	
	s WorkType=$p(IADMInfo,"^",(i-1))
	s EndangerWorkAge=$p(IADMInfo,"^",i)

	k IADMLIST(1)
	s IADMLIST(2)=IBaseInfoID
	s IADMLIST(3)=PreGADMID
	s IADMLIST(4)=TeamID
	S IADMLIST(8)=$p($G(^DHCPEPreGADM(+TeamID,"Team",$P(TeamID,"||",2))),"^",5)
	q:(IADMLIST(4)="") -101
	s:IADMLIST(27)="" IADMLIST(27)=%session.Get("LOGON.CTLOCID")
	s IADMLIST(29)="N"
	s NewHPNo=##class(web.DHCPE.PreIADMEx).GetNewHPNo(IADMLIST(29), IADMLIST(19), IADMLIST(3), IADMLIST(27))
	s IADMLIST(28)=NewHPNo
	
	s RoomPlace=$G(^DHCPEDataEx("DHCPEPreGTeam","RoomPlace",TeamID))
	//s IADMLIST(8)=RoomPlace
	
	&SQL(
			Insert Into SQLUSER.DHC_PE_PreIADM Values :IADMLIST()
		)
	q:SQLCODE'=0 SQLCODE
	s IADMID=%ROWID
	s TFeeType=$G(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",TeamID))
	s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",IADMID)=TFeeType
	s ^DHCPEDataEx("DHCPEPreIADM","Position",IADMID)=$P(IBaseInfo,"^",12)
	s Endanger=$g(^DHCPEDataEx("DHCPEPreGADM","TeamEndanger",TeamID))
    s OMEType=$g(^DHCPEDataEx("DHCPEPreGADM","OMEType",TeamID))
    s Str=##class(web.DHCPE.OccupationalDisease).SaveOccu2(IADMID,Endanger,OMEType,WorkType,EndangerWorkAge)

    s ^DHCPEDataEx("DHCPEPreIADM","RoomPlace",IADMID)=RoomPlace
    
	i IADMLIST(4)'=""
	{
		s ^DHCPEDataEx("DHCPEPreIADM","GTEAM",IADMLIST(4))=+$G(^DHCPEDataEx("DHCPEPreIADM","GTEAM",IADMLIST(4)))+1
		s ^DHCPEDataEx("DHCPEPreIADM","GTEAM","IADM",IADMID)=$G(^DHCPEDataEx("DHCPEPreIADM","GTEAM",IADMLIST(4)))
	}
	s SQLCODE=##class(web.DHCPE.PreIADM).InsertPreAudit(IADMID,1)
	q:SQLCODE'=0 SQLCODE
	d ##class(web.DHCPE.AdmRecordManager).Insert(IADMID,"P","PREInsert","","")
	i Type'=""
	{
		s SQLCODE=##Class(web.DHCPE.PreItemList).IInsOrd4NewPat(TeamID, IADMID, %session.Get("LOGON.USERID"),"0")
		i ""=SQLCODE s SQLCODE=0
	}
	q SQLCODE
}

/// 更新his里的病人信息
ClassMethod UpdateHISPersonData(RegNo, IBaseInfo, CTLocID As %String = "")
{
	k PLIST
	s i=$L(IBaseInfo,"^")-4
	s CardNo=$p(IBaseInfo,"^",i+1)
	f j=1:1:i
	{
		s PLIST(j)=$P(IBaseInfo,"^",j)
	}
	s EmployeeNo=$p(IBaseInfo,"^",i+3)
	s HCADR=PLIST(i)
	k PLIST(i)
	s info=""
	i ""=$G(PLIST(5)) d
	.s Age=""
	e  d
	.s Age=##class(web.DHCLCNUREXCUTE).CalAge(PLIST(5),+$h)
	
	i ("0"'=Age)&&(""'=Age) d
	.s AgeDay=+$P($P(Age," ",3),"D",1)
	.s value=AgeDay
	e  d
	.s AgeDay=""
	.s value=""
	s info=info_""_value	// 1	AgeDay		paper_ageday
	
	i ("0"'=Age)&&(""'=Age) d
	.s AgeMoth=+$P($P(Age," ",2),"M",1)
	.s value=AgeMoth
	e  d
	.s AgeMoth=""
	.s value=""
	s info=info_"^"_value	// 2	AgeMoth		paper_agemth
	
	i ("0"'=Age)&&(""'=Age) d
	.s AgeYear=+$P($P(Age," ",1),"Y",1)
	.s value=AgeYear
	e  d
	.s AgeYear=""
	.s value=""
	s info=info_"^"_value	// 3	AgeYear		paper_ageyr
	
	s value=""
	s info=info_"^"_value	// 4	国家			paper_langprim_dr
	
	s value=$G(PLIST(5))
	s info=info_"^"_value	// 5	出生日期		paper_dob
	
	s value=$G(PLIST(3))
	s info=info_"^"_value	// 6	姓名			paper_name
	
	s value=$G(PLIST(4))
	s info=info_"^"_value	// 7	性别			paper_sex_dr
	
	s value="|||||||||||"_AgeYear_"|"_AgeMoth_"|"_AgeDay
	s info=info_"^"_value	// 8				paper_age
	
	s value=$G(PLIST(21))
	s info=info_"^"_value	// 9				paper_userupdate
	
	s value=""
	s info=info_"^"_value	// 10	国家			paper_country_dr
	
	s value=""
	s info=info_"^"_value	// 11	省			paper_ct_province_dr
	
	s value=""
	s info=info_"^"_value	// 12	城市			paper_citycode_dr
	
	s value=""
	s info=info_"^"_value	// 13	语言			paper_langprim_dr
	
	s value=$G(PLIST(16))
	//s value=""
	s info=info_"^"_value	// 14	民族			paper_nation_dr
	
	s value=""
	s info=info_"^"_value	// 15				
	
	s value=""
	s info=info_"^"_value	// 16	宗教			paper_religion_dr
	
	s value=$G(PLIST(18))
	s info=info_"^"_value	// 17	婚姻			paper_marital_dr
	
	s value=""
	s info=info_"^"_value	// 18	学历			paper_education_dr
	
	s value=$G(PLIST(6))
	s info=info_"^"_value	// 19	患者类型		paper_socialstatus_dr
	
	i ""=$G(PLIST(19)) d
	.s value=""
	e  d
	.s value=$p($G(^PAC("BLDT",PLIST(19))),"^",2)
	.
	s info=info_"^"_value	// 20	血型			paper_foreignid
	
	s value=$G(PLIST(14))
	s info=info_"^"_value	// 21	邮编			paper_zip_dr
	
	s value=$G(PLIST(7))
	s info=info_"^"_value	// 22	电话			paper_telh
	
	s value=$G(PLIST(8))
	s info=info_"^"_value	// 23	单位电话		paper_telo
	
	s value=$G(PLIST(15))
	s info=info_"^"_value	// 24	地址			paper_secondphone
	
	s value=$G(PLIST(13))
	s info=info_"^"_value	// 25	工作单位		PAPER_NokAddress2
	
	s value=$G(PLIST(10))
	s info=info_"^"_value	// 26	身份证		paper_id
	
	s value=""
	s info=info_"^"_value	// 27	人名助记符	paper_name2		
	
	s value=""
	s info=info_"^"_value	// 28				PAPER_EmplType_DR
	
	s value=""
	s info=info_"^"_value	// 29				PAPER_EmployeeNo
	s value=""
	s info=info_"^"_value	// 30				PAPER_HCP_DR
	s value=HCADR
	s info=info_"^"_value	// 31				PAPER_CT_HCA_DR
	s info=info_"^"_$P(IBaseInfo,"^",23)  //就诊卡号
	i (RegNo'="")
	{
		
		s rowid=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
		//已存在
		i rowid'=""	d
		.s Oldcid=$p($G(^PAPER(rowid,"ALL")),"^",9)
		.i $p(info,"^",26)="" s $p(info,"^",26)=Oldcid
		.s OldHCADR=$p($g(^PAPER(rowid,"PER",4)),"^",3)
		.i $p(info,"^",31)="" s $p(info,"^",31)=OldHCADR
		.s OldHCPDR=$p($g(^PAPER(rowid,"PER",4)),"^",17)
		.i $p(info,"^",30)="" s $p(info,"^",30)=OldHCPDR
		.s OldEmployeeNo=$P($G(^PAPER(rowid,"EMP")),"^",5)
		.i OldEmployeeNo="" d
		..s $P(^PAPER(rowid,"EMP"),"^",5)=EmployeeNo
		..s:EmployeeNo'="" ^PAPERi("EmplNo",EmployeeNo,rowid)=""
		.s SQLCODE=0
		.//s SQLCODE=##class(web.DHCPE.PreIBIUpdate).upperson1(info,rowid)
		e  d
		.//不存在
		.;s CardtypeDR=$p($g(^DHCPESetting("DHCPE","DefPatientType")),"^",5)
		.s CardtypeDR=$p($g(^DHCPESetting("DHCPE","DefPatientType",CTLocID)),"^",5)
		.s SQLCODE=##class(web.DHCPE.PreIBIUpdate).Insertperson(info,CardtypeDR,$G(PLIST(11)))
	}
	else  //NoGen
	{
		;s CardtypeDR=$p($g(^DHCPESetting("DHCPE","DefPatientType")),"^",5)
		s CardtypeDR=$p($g(^DHCPESetting("DHCPE","DefPatientType",CTLocID)),"^",5)
		s SQLCODE=##class(web.DHCPE.PreIBIUpdate).Insertperson(info,CardtypeDR,$G(PLIST(11)))
		//s PARowID=$G(%ROWID)
		//i PARowID'="" s RegNo=$p(^PAPER(PARowID,"PAT",1),"^",1)
		s RegNo=P5
	}
	i SQLCODE'=0 s SQLCODE=SQLCODE_"^"_RegNo_"^"_CardNo
	q SQLCODE
}

/// 导入数据时出错，退出使用
ClassMethod GotoErr(Str)
{
	TROLLBACK
	d ..KillImportGlobal(JobID)
	//k ^DHCPEImportGInfo("ImportG",JobID)
	q Str_"^"
}

ClassMethod KillImportGlobal(job)
{
	k ^DHCPEImportGInfo("ImportG",job)
	k ^DHCPEImportGInfo("CheckCardId")      //add by zhouli 
	q 0
}

/// 检查登记号是否正确  Return  1:正确  0:错误
/// d ##class(web.DHCPE.ImportGInfo).CheckRegNo("00000000","000000111111111")
ClassMethod CheckRegNo(RegNo, CardNo As %String = "", CTLocID As %String = "")
{
	
	//s CardRelate=$G(^DHCPESetting("DHCPE","CardRelate"))
	s CardRelate=$G(^DHCPESetting("DHCPE","CardRelate",CTLocID))
	s GenModel=##class(web.DHCPE.Public.Setting).GetPAPMINoGenModel()
	if GenModel="NoGen"
	{
		i CardRelate="Yes"
		{
			i (CardNo'="")&&(+RegNo'=0)
			{
				s CurRegNo=##class(web.DHCPE.PreIBIUpdate).GetRelate(CardNo, "C",CTLocID)
				s CurRegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(CurRegNo,CTLocID)
				q:(RegNo'=CurRegNo) "卡号与登记号不一致"
				q 1
			}
			//elseif (CardNo="")&&(+RegNo=0)
			//{
			//	q "卡号与登记号必须填一个"
			//}
			elseif (CardNo'="")
			{
				s CurRegNo=##class(web.DHCPE.PreIBIUpdate).GetRelate(CardNo, "C",CTLocID)
				i CurRegNo'=""
				{   i RegNo'="0000000000" 
				 {
					s PAPID=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
					s oldName=$P(^PAPER(PAPID,"ALL"),"^",1)
					i oldName'=Name q "卡号已经使用,并且与原姓名不一致"_CardNo
				}
					s RegNo=CurRegNo
				}
				
				q 1
			}
			elseif (+RegNo'=0)&&(CardNo'="")
			{
				s CurCardNo=##class(web.DHCPE.PreIBIUpdate).GetRelate(RegNo, "R",CTLocID)
				i CurCardNo'="" s CardNo=CurCardNo
				i CurCardNo="" q "登记号对应的卡号不存在"
				q 1	
			}
		}
		q:+RegNo=0 1
		s PAPID=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
		q:PAPID'="" 1
		q 0
	}
	if GenModel="FreeCreate"
	{
		q:+RegNo=0 0
		q 1
	}
	//Gen
	s PAPID=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	i PAPID="" q 0
	/*i $G(^DHCPESetting("DHCPE","HospitalCode"))="FX"
	{
		s Str=$E(RegNo,8,8)
		q:Str="4" 0
		s Str=$E(RegNo,7,7)
		q:Str="4" 0
		s Str=$E(RegNo,6,6)
		q:Str="4" 0
	}*/
	q 1
}

ClassMethod GetRegNoByIDCard(IDCard)
{
	n (IDCard)
	q:IDCard="" ""
	s HadFlag=0
	s AllRegNo=""
	s IDCard=$ZCVT(IDCard,"U")
	s PatientID=""
	f  s PatientID=$O(^PAPERi("DVA",IDCard,PatientID),-1) q:PatientID=""  d
	.s ActiveFlag=$P(^PAPER(PatientID,"PAT",1),"^",6)
	.q:ActiveFlag="N"
	.s RegNo=$P(^PAPER(PatientID,"PAT",1),"^",1)
	.i AllRegNo="" s AllRegNo=RegNo
	.e  s AllRegNo=AllRegNo_"^"_RegNo
	q:AllRegNo'="" AllRegNo
	s ChangeIDCard=""
	i $L(IDCard)=15 d
	.s ChangeIDCard=..ID15to18(IDCard)
	e  i $L(IDCard)=18 d
	.s ChangeIDCard=..ID18to15(IDCard)
	q:ChangeIDCard="" AllRegNo
	s PatientID=""
	f  s PatientID=$O(^PAPERi("DVA",ChangeIDCard,PatientID),-1) q:PatientID=""  d
	.s ActiveFlag=$P(^PAPER(PatientID,"PAT",1),"^",6)
	.q:ActiveFlag="N"
	.s RegNo=$P(^PAPER(PatientID,"PAT",1),"^",1)
	.i AllRegNo="" s AllRegNo=RegNo
	.e  s AllRegNo=AllRegNo_"^"_RegNo
	q AllRegNo
}

ClassMethod ID15to18(IDCardNo15 As %String = "") As %String
{

	if $length(IDCardNo15)'=15 quit IDCardNo15
	set IDCardNo17=$extract(IDCardNo15,1,6)_"19"_$extract(IDCardNo15,7,15)

	set W(1)=1,W(2)=2,W(3)=4,W(4)=8,W(5)=5,W(6)=10,W(7)=9,W(8)=7,W(9)=3,W(10)=6
	set W(11)=1,W(12)=2,W(13)=4,W(14)=8,W(15)=5,W(16)=10,W(17)=9,W(18)=7
	set Y(0)="1",Y(1)="0",Y(2)="X",Y(3)="9",Y(4)="8",Y(5)="7",Y(6)="6",Y(7)="5",Y(8)="4",Y(9)="3",Y(10)="2"

	set snum=0
	for i=18:-1:2
	{
		set snum=snum+($extract(IDCardNo17,19-i,19-i)*W(i))
	}

	set ynum=snum#11

	set IDCardNo18=IDCardNo17_Y(ynum)
	quit IDCardNo18
}

/// 身份证号18位转15位
ClassMethod ID18to15(IDCardNo18 As %String = "") As %String
{
	if $length(IDCardNo18)'=18 quit IDCardNo18
	set IDCardNo15=$extract(IDCardNo18,1,6)_$extract(IDCardNo18,9,17)

	quit IDCardNo15
}

// w ##class(web.DHCPE.ImportGInfo).CheckName("","黄")

/// 根据姓名生日判断是否已经存在登记号
ClassMethod CheckRegNoByDobName(Dob, Name, RegNo, curSex, Type As %String = "Import")
{
   
	new Flag,bFlag,rRegNo,PAPMIId
	s PAPMIId=0
	s bFlag=0
	s Flag=0
	s rRegNo=""
	//i CardNoIndex="" q bFlag
	f  s PAPMIId=$o(^PAPERi("DOB",Dob,Name,PAPMIId)) q:(PAPMIId="")  d
	.s curRegNo=$P(^PAPER(PAPMIId,"PAT",1),"^",1)
	.s PatSexID=$P(^PAPER(PAPMIId,"ALL"),"^",7)
	.s ActiveFlag=$P(^PAPER(PAPMIId,"PAT",1),"^",6)
	.q:ActiveFlag="N"
	.Q:(curSex'="")&&(curSex'=PatSexID)
	.i +RegNo=0 d
	..s bFlag=1
	..s rRegNo=rRegNo_"^"_curRegNo
	.e  d
	..i curRegNo=RegNo d
	...i Type="Import" s Flag=1
	...
	..e  d
	...s bFlag=1
	...s rRegNo=rRegNo_"^"_curRegNo
	i Flag=1 q 0
	i bFlag=1 q $p(rRegNo,"^",2,$l(rRegNo,"^"))
	q 0
}

// w ##class(web.DHCPE.ImportGInfo).CheckName(1,"黄")

ClassMethod CheckName(RegNo, OldName, LocID)
{
	n (RegNo,OldName,LocID)
	s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo,LocID)
	q:+RegNo=0 0
	s PAPID=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	q:PAPID="" 0
	s Name=$p($G(^PAPER(PAPID,"ALL")),"^",1)
	q:(Name'=OldName)&&(Name'="未用") 1
	q 0
}

ClassMethod CheckSex(RegNo, OldSex, LocID)
{
	n (RegNo,OldSex,LocID)
	s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo,LocID)
	q:+RegNo=0 0
	s PAPID=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	q:PAPID="" 0
	s CurSex=$p($G(^PAPER(PAPID,"ALL")),"^",7)
	q:(CurSex'=OldSex) 1
	q 0
}

/// debug: w ##class(web.DHCPE.ImportGInfo).GetTIDByInfo("","46495",2,2,4)
ClassMethod GetTIDByInfo(TName, Birth, Sex, Married, GID)
{
	s tid=""
	s ret=""
	s tsub=0
	f  s tsub=$O(^DHCPEPreGADM(GID,"Team",tsub)) q:(tsub="")||(tid'="")  d
	.s TCurData=$G(^DHCPEPreGADM(GID,"Team",tsub))
	.s ret=""
	.i TName'="" d
	..s curName=$p(TCurData,"^",1)
	..i curName=TName d
	...
	...//性别判断 start
	...s PGTSex = $p(TCurData,"^",12)
	...i '((""=PGTSex)||("N"=PGTSex)||("No"=PGTSex)) d
	....//	PIBI_Sex_DR	性别
	....s PIBISexDR=Sex
	....i (""=PIBISexDR) s ret="No Valid Sex"
	....//CT_Sex	CTSEX_Desc
	....s PIBISexDRName=$p($G(^CT("SEX",PIBISexDR)),"^",2)
	....i ((("Female"=PGTSex)||("F"=PGTSex))&(PIBISexDRName'["女")) s ret="Sex Err"
	....i ((("Male"=PGTSex)||("M"=PGTSex))&(PIBISexDRName'["男")) s ret="Sex Err "
	...Q:(""'=ret)	
	...//性别判断 end
	...
	...//年龄判断 start
	...s PGTUpperLimit = $p(TCurData,"^",13)
	...s PGTLowerLimit = $p(TCurData,"^",14)
	...s PIBIDOB=Birth
	...i (""'=PIBIDOB) d
 	....s PIBIDOB=##class(web.DHCLCNUREXCUTE).CalAge(PIBIDOB,+$h)
 	....s PIBIDOB=+$P(PIBIDOB,"Y",1)
	...i (""'=PGTLowerLimit)&(""'=PIBIDOB)&(+PIBIDOB<+PGTLowerLimit) s ret="LowerLimit Err"
	...i (""'=PGTUpperLimit)&(""'=PIBIDOB)&(+PIBIDOB>+PGTUpperLimit) s ret="UpperLimit Err"
	...Q:(""'=ret)
	...//年龄判断 end
	...
	...//婚姻判断 start
	...s PGTMarried = $p(TCurData,"^",15)
	...i '((""=PGTMarried)||("N"=PGTMarried)||("No"=PGTMarried)) d
	....s PIBIMarriedDR=Married
	....i ""=PIBIMarriedDR s ret="No Valid Married "
	....s PIBIMarriedDRName=$p($G(^CT("MAR",PIBIMarriedDR)),"^",2)
	....i ((("Unmarried"=PGTMarried)||("UM"=PGTMarried))&(PIBIMarriedDRName'["未婚")) s ret="Married Err"
	....i ((("Married"=PGTMarried)||("M"=PGTMarried))&(PIBIMarriedDRName'["已婚")) s ret="Married Err"
	...Q:(""'=ret)
	...//婚姻判断 end
	...
	...s tid=GID_"||"_tsub
	.e  d
	..s PGTSex = $p(TCurData,"^",12)
	..i '((""=PGTSex)||("N"=PGTSex)||("No"=PGTSex)) d
	...//	PIBI_Sex_DR	性别
	...s PIBISexDR=Sex
	...i (""=PIBISexDR) s ret="No Valid Sex"
	...//CT_Sex	CTSEX_Desc
	...s PIBISexDRName=$p($G(^CT("SEX",PIBISexDR)),"^",2)
	...i ((("Female"=PGTSex)||("F"=PGTSex))&(PIBISexDRName'["女")) s ret="Sex Err"
	...i ((("Male"=PGTSex)||("M"=PGTSex))&(PIBISexDRName'["男")) s ret="Sex Err "
	..Q:(""'=ret)	
	
	..// 3 PGT_UpperLimit	年龄上限
	..s PGTUpperLimit = $p(TCurData,"^",13)
	..// 4 PGT_LowerLimit	年龄下限
	..s PGTLowerLimit = $p(TCurData,"^",14)
	..//	PIBI_DOB	生日
	..s PIBIDOB=Birth
	..i (""'=PIBIDOB) d
 	...s PIBIDOB=##class(web.DHCLCNUREXCUTE).CalAge(PIBIDOB,+$h)
 	...s PIBIDOB=+$P(PIBIDOB,"Y",1)
	..i (""'=PGTLowerLimit)&(""'=PIBIDOB)&(+PIBIDOB<+PGTLowerLimit) s ret="LowerLimit Err"
	..i (""'=PGTUpperLimit)&(""'=PIBIDOB)&(+PIBIDOB>+PGTUpperLimit) s ret="UpperLimit Err"
	..Q:(""'=ret)
	
	..// 5 PGT_Married	婚姻状况
	..s PGTMarried = $p(TCurData,"^",15)
	..i '((""=PGTMarried)||("N"=PGTMarried)||("No"=PGTMarried)) d
	...//	PIBI_Married	婚姻状况
	...s PIBIMarriedDR=Married
	...i ""=PIBIMarriedDR s ret="No Valid Married "
	...//CT_Marital	CTMAR_Desc
	...s PIBIMarriedDRName=$p($G(^CT("MAR",PIBIMarriedDR)),"^",2)
	...i ((("Unmarried"=PGTMarried)||("UM"=PGTMarried))&(PIBIMarriedDRName'["未婚")) s ret="Married Err"
	...i ((("Married"=PGTMarried)||("M"=PGTMarried))&(PIBIMarriedDRName'["已婚")) s ret="Married Err"
	..Q:(""'=ret)
	..s tid=GID_"||"_tsub
	i tid'["||"  s tid=""
	q tid
}

// w ##class(web.DHCPE.ImportGInfo).CheckRegNoInGroupByName("体检测试4","10","23","","3092","东华公司")

ClassMethod CheckRegNoInGroupByName(Name, Sex, Age, Type As %String = "Import", Job, GDesc)
{
	n (Name, Sex, Age, Type,Job, GDesc)
	S ExistFlag=0
    s PGADMRowIdStr=""
	s PGBIRowId=0
	f  s PGBIRowId=$o(^DHCPEPreGBI(0,"Desc",GDesc,PGBIRowId))  q:PGBIRowId=""  d
	.s PGADMRowId=0
	.f  s PGADMRowId=$o(^DHCPEPreGADM(0,"PGBI",PGBIRowId,PGADMRowId))  q:PGADMRowId=""  d
	..i PGADMRowIdStr=""   s PGADMRowIdStr=PGADMRowId
	..else  s PGADMRowIdStr=PGADMRowIdStr_"^"_PGADMRowId

	s PIBIRowId=0,RegNoStr=""
    f  s PIBIRowId=$o(^DHCPEPreIBI(0,"Name",Name,PIBIRowId))  q:PIBIRowId=""  d
    .s RegNo=$p(^DHCPEPreIBI(PIBIRowId),"^",1)
    .s PatSex=$p(^DHCPEPreIBI(PIBIRowId),"^",3)
    .s PatBOD=$p(^DHCPEPreIBI(PIBIRowId),"^",4)
    .s PatAge=##class(web.DHCLCNUREXCUTE).CalAge(PatBOD,+$h)
	.s PatAge=$P(PatAge,"Y",1)
	.Q:(Sex'="")&&(Sex'=PatSex)
	.Q:(Age'="")&&(Age'=PatAge)
	.s IADMRowId=0
	.f  s IADMRowId=$o(^DHCPEPreIADM(0,"PIBI",PIBIRowId,IADMRowId))  q:IADMRowId=""  d
	..s PGADM=$P(^DHCPEPreIADM(IADMRowId),"^",2)
	..q:PGADM=""
	..s PGBID=$p(^DHCPEPreGADM(PGADM),"^",1)
	..q:PGBID=""
	..S PGDesc=$p(^DHCPEPreGBI(PGBID),"^",2)
	..q:GDesc'=PGDesc
	..S ExistFlag=1
	..i RegNoStr=""  s RegNoStr=RegNo
	..else  d
	...i ("^"_RegNoStr_"^")'[("^"_RegNo_"^") s RegNoStr=RegNoStr_"^"_RegNo
 i ExistFlag=0 q 0
 i ExistFlag=1  q RegNoStr
}

ClassMethod CheckBodAndAgeByRegNo(PatRegNo, LocID)
{
	s Bod="",Age=""
	s PatRegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(PatRegNo,LocID)
	q:+PatRegNo=0 "^"
	s PAPID=$o(^PAPERi("PAPMI_PatNo",PatRegNo,""))
	q:PAPID="" "^"
	s Bod=$p($G(^PAPER(PAPID,"ALL")),"^",6)
    s Age=##class(web.DHCLCNUREXCUTE).CalAge(Bod,+$h)
	s Age=$P(Age,"Y",1)
	i Bod'=""  s Bod=$ZD(Bod,3)
	q Bod_"^"_Age
}

ClassMethod GetImportErr(GID, Job, Sort)
{
	q $G(^DHCPEImportGInfo("ImportGErr",GID,Job,Sort))
}

}
