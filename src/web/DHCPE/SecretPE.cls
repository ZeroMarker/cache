Class web.DHCPE.SecretPE Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SetJobID(job As %String = "aaaa")
{
	s JobID=job
}

/// 检验个人信息是否符合条件
/// 增加是否导入过的判断 
/// InString TName^RegNo^Name^CardNo^Sex^Age^Birth^Married^MoveTel^Tel^Address^StartDate^EndDate^AsCharged^IReportSend^ChargedMode^AddItem^AddItemLimit^AddItemAmount^AddMedical^AddMedicalLimit^AddMedicalAmount
ClassMethod GetSecretInfo(InString, Type As %String = "Import", job As %String = "aaaa")
{
	k ^DHCPEImportSecretInfo("Import",job)
	s ^yl("GetGPersonInfo")=$lb(InString, Type, job)	
	s ErrInfo=""
	d ..SetJobID(job)
	s RowSort=$p(InString,"^",$L(InString,"^"))
	s PreIADM=$p(InString,"^",1)
	s PAADM=$p(InString,"^",2)
	s ADMDate=$p(InString,"^",3)
	s PatName=$p(InString,"^",4)
	s PatSex=$p(InString,"^",5)
	s PatAge=$p(InString,"^",6)
	s PatIDCard=$p(InString,"^",7)
	s PatTel=$p(InString,"^",8)
	s LisStr=$p(InString,"^",9)
	s LisStrLength=$l(LisStr,"$$")
	s IsErr=0
	f i=1:1:LisStrLength d
	.s OneLisStrInfo=$P(LisStr,"$$",i)
	.s OutOeOrdItem=$p(OneLisStrInfo,"&",3)
	.i ($d(^DHCPESecretPAADMi(0,"OutItem",OutOeOrdItem))) d
	..s IsErr=1
	..s ErrInfo=PatName_"的"_OutOeOrdItem_"医嘱已经导入过,请核实"
	q:(IsErr'=0) "-1^"_ErrInfo
	s Sort=+$G(^DHCPEImportSecretInfo("Import",JobID,"Sort"))
	s Sort=Sort+1
   
	s ^DHCPEImportSecretInfo("Import",JobID,"SecretInfo",Sort)=PreIADM_"^"_PAADM_"^"_ADMDate_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatIDCard_"^"_PatTel_"^"_LisStr_"^"_RowSort   ;RowSort一定放到所有的最后 
	
	
	
	s Time=$p($H,",",2)
	s ^DHCPEImportSecretInfo("Import",JobID,"Sort")=Sort
	q 0
}

/// 检验个人结果信息是否符合条件
/// 姓名	日期	院内就诊ID	院内医嘱ID	院外就诊ID	医嘱项ID	院外医嘱ID	检验结果串
/// InString TName^RegNo^Name^CardNo^Sex^Age^Birth^Married^MoveTel^Tel^Address^StartDate^EndDate^AsCharged^IReportSend^ChargedMode^AddItem^AddItemLimit^AddItemAmount^AddMedical^AddMedicalLimit^AddMedicalAmount
ClassMethod GetSecretInfoNew(InString, Type As %String = "Import", job As %String = "aaaa")
{
	k ^DHCPEImportSecretInfo("ImportRlt",job)
	s ^yl("GetGPersonInfo")=$lb(InString, Type, job)	
	s ErrInfo=""
	d ..SetJobID(job)
	s RowSort=$p(InString,"^",$L(InString,"^"))
	s Name=$p(InString,"^",1)
	s Date=$p(InString,"^",2)
	s PAADMIn=$p(InString,"^",3)
	s OEOrdItemIn=$p(InString,"^",4)
	s PAADMOut=$p(InString,"^",5)
	s ArcItem=$p(InString,"^",6)
	s OEOrdItemOut=$p(InString,"^",7)
	s LisResultStr=$p(InString,"^",8)
	
	s Sort=+$G(^DHCPEImportSecretInfo("ImportRlt",JobID,"Sort"))
	s Sort=Sort+1
   
	s ^DHCPEImportSecretInfo("ImportRlt",JobID,"SecretInfo",Sort)=Name_"^"_Date_"^"_PAADMIn_"^"_OEOrdItemIn_"^"_PAADMOut_"^"_ArcItem_"^"_OEOrdItemOut_"^"_LisResultStr   ;RowSort一定放到所有的最后 
	s Time=$p($H,",",2)
	s ^DHCPEImportSecretInfo("ImportRlt",JobID,"Sort")=Sort
	q 0
}

/// 导入数据库数据信息 w ##class(web.DHCPE.SecretPE).MainNew(977)
ClassMethod MainNew(job As %String = "aaaa")
{
	;TS
	s ^DHCPERecord("MainNew")=$lb(job)
	s newSecretPAADMId=""
	s SussNum=0
	d ..SetJobID(job)
	s Sort=""
	f  s Sort=$o(^DHCPEImportSecretInfo("ImportRlt",job,"SecretInfo",Sort)) q:Sort=""  d
	.s ImportInfo=$g(^DHCPEImportSecretInfo("ImportRlt",job,"SecretInfo",Sort))
	.b ;ImportInfo
	.s Name=$p(ImportInfo,"^",1)
	.s Date=$p(ImportInfo,"^",2)
	.s PAADMIn=$p(ImportInfo,"^",3)
	.//s OEOrdItemIn=$zdh(ADMDate,3)
	.s OEOrdItemIn=$p(ImportInfo,"^",4)
	.s PAADMOut=$p(ImportInfo,"^",5)
	.s ArcItem=$p(ImportInfo,"^",6)
	.s OEOrdItemOut=$p(ImportInfo,"^",7)
	.s LisResultStr=$p(ImportInfo,"^",8)
	.s RltLength=$l(LisResultStr,"$$")
	.for i=1:1:RltLength d
	..s OneRltData=$p(LisResultStr,"$$",i)
	..s ODDesc=$p(OneRltData,"&",29) // $p(^DHCPEST(+RLTODDR,"OD",$p(RLTODDR,"||",2)),"^",1)
	..s ODCode=$p(OneRltData,"&",30)  //$p(^DHCPEST(+RLTODDR,"OD",$p(RLTODDR,"||",2)),"^",11)
	..q:ODCode=""
	..s stationID=$O(^DHCPEST(0,"OD_Code",ODCode,0))
	..//b ; Code,Desc,Unit
    ..;b ;stationID
	..i stationID="" d
	...s ItemID=##class(web.DHCPE.OrderDetail).ImpOneLabDetailNew(ODCode,ODDesc,$p(OneRltData,"&",17),"")
	..e  d
	...s sub=$O(^DHCPEST(0,"OD_Code",ODCode,stationID,0))
	...s ItemID=stationID_"||"_sub
	..k PLIST
	..;b ;w ##class(web.DHCPE.SecretPE).MainNew(977)
	..s PLIST(2)=PAADMOut
	..s PLIST(3)=ArcItem
	..s PLIST(4)=ItemID
	..s PLIST(5)=$p(OneRltData,"&",4)
	..s PLIST(6)=$p(OneRltData,"&",5)
	..s PLIST(7)=$p(OneRltData,"&",6)
	..s PLIST(8)=$p(OneRltData,"&",7)
	..s PLIST(11)=OEOrdItemOut
	..s PLIST(13)=$p(OneRltData,"&",11)
	..s PLIST(14)=""
	..s PLIST(16)=$p(OneRltData,"&",14)
	..s PLIST(17)=$p(OneRltData,"&",15)
	..//s admId=$p($g(^OEORD(+ordItmId)),"^",1)
	..s RLTID=$O(^DHCPERLT(0,"ADMOD",PAADMOut,OEOrdItemOut,ItemID,0))
	
	
	..;b ;insert11111
	
	..//b ;2225
	..i RLTID="" d
	...&SQL(Insert into sqluser.DHC_PE_Result values:PLIST())
	..e  d
	...&SQL(update sqluser.DHC_PE_Result values :PLIST() where RLT_RowID=:RLTID)
	..i SQLCODE=0 d
	...s RLTRowId=%ROWID
	...s ^DHCPEDataEx("DHCPEResult",RLTRowId,"Ranges")=$p(OneRltData,"&",23)
	...s ^DHCPEDataEx("DHCPEResult",RLTRowId,"Unit") =$p(OneRltData,"&",24)
	...s ^DHCPEDataEx("DHCPEResult",RLTRowId,"AuditUser") =$p(OneRltData,"&",25)
	...s ^DHCPEDataEx("DHCPEResult",RLTRowId,"DoctorId") =$p(OneRltData,"&",26)
	...s ^DHCPEDataEx("DHCPEResult",RLTRowId,"HLFlag") =$p(OneRltData,"&",27)
	...s ^DHCPEDataEx("DHCPEResult",RLTRowId,"TextResult") =$p(OneRltData,"&",28)
	...s SussNum=SussNum+1	
	...&SQL(update sqluser.OE_ORDItem set OEORI_ItemStat_DR='6' where OEORI_RowID=:OEOrdItemOut)
    k ^DHCPEImportSecretInfo("ImportRlt",job)
    q 0_"^^^"_SussNum
	;TC
}

/// 导入数据库数据信息 w ##class(web.DHCPE.SecretPE).Main(977)
ClassMethod Main(job As %String = "aaaa")
{
	;TS
	s newSecretPAADMId=""
	s SussNum=0
	d ..SetJobID(job)
	s Sort=""
	f  s Sort=$o(^DHCPEImportSecretInfo("Import",job,"SecretInfo",Sort)) q:Sort=""  d
	.s ImportInfo=$g(^DHCPEImportSecretInfo("Import",job,"SecretInfo",Sort))
	.b ;ImportInfo
	.s PreIADM=$p(ImportInfo,"^",1)
	.q:($d(^DHCPESecretPAADM(0,"OutPreIADMDR",PreIADM)))
	.s PAADM=$p(ImportInfo,"^",2)
	.s ADMDate=$p(ImportInfo,"^",3)
	.s ADMDate1=$zdh(ADMDate,3)
	.s PatName=$p(ImportInfo,"^",4)
	.s PatSex=$p(ImportInfo,"^",5)
	.s PatSex=$o(^CT("SEX",0,"Desc",PatSex,0))
	.s PatAge=$p(ImportInfo,"^",6)
	.s PatAge1=$zdh(PatAge,3)
	.s PatIDCard=$p(ImportInfo,"^",7)
	.s PatIDCard=""
	.s PatTel=$p(ImportInfo,"^",8)
	.s LisStr=$p(ImportInfo,"^",9)
	.s RegNo=##class(web.DHCPE.PreIBaseInfo).GetRegNoByIDCard(PatIDCard)
	.i RegNo="" d
	..b ;BaseInfo
	..s BaseInfo="^^"_PatName_"^"_PatSex_"^"_PatAge1_"^1^"_PatTel_"^^"_PatTel_"^"_PatIDCard_"^^^^^^^^22^^"_ADMDate1_"^"_job_"^^^1^^"     //是VIP等级
	..s InsertHisBaseInfo=..UpdateHISPersonData("",BaseInfo)
	..s realRegno=$p(InsertHisBaseInfo,"^",2)
	
	..&SQL(Insert Into SQLUSER.DHC_PE_PreIBaseInfo(
	PIBI_PAPMINo,PIBI_Name,PIBI_Sex_DR,PIBI_DOB,PIBI_PatType_DR,PIBI_UpdateDate,PIBI_UpdateUser_DR,PIBI_MobilePhone,PIBI_IDCard) 
	Values (:realRegno,:PatName,:PatSex,:PatAge1,1,:ADMDate1,:job,:PatTel,:PatIDCard))
	..s IBaseInfoID=%ROWID
	.e  d
	..s IBaseInfoID=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,""))
	.s PreIADMInfo="^"_IBaseInfoID_"^^^"_ADMDate_"^"_ADMDate_"^^^PREREG^Y^N^N^^N^N^^IS^ID^1^^^^^^^^^1^0^^^^^^N^1^$$"
	.s:$d(%session) loc=%session.Get("LOGON.CTLOCID")
	.s:'$d(%session) loc=152   //改成科室id
	.s InsertPreIADM=##class(web.DHCPE.PreIADM).HISUISave("","",PreIADMInfo,job,loc)  //改成体检中心科室id
	.s PreIADMobj={}.%FromJSON(InsertPreIADM)
	.s PreIADMCode=$p((PreIADMobj.ret),"^",1)
	.//PreIADMCode  Code不是0回滚
	.s PreIADMID=$p((PreIADMobj.ret),"^",2)
	
	
	.&sql(insert into sqluser.DHC_PE_SecretPAADM(OutPreIADM,
	             OutPAADM, PatName, PatSex
				, PatAge, PatIDCard,PatTel,
				LisStr,InPreIADM,ADMDate
			)values(
				:PreIADM,:PAADM,:PatName,:PatSex,:PatAge1,
				:PatIDCard,:PatTel,:LisStr,:PreIADMID,:ADMDate1
			)
		)
	
	.s newSecretPAADMId=%ROWID
	.s LisStrLength=$l(LisStr,"$$")
	.f i=1:1:LisStrLength d
	..s OneLisStrInfo=$P(LisStr,"$$",i)
	..s ARCDesc=$p(OneLisStrInfo,"&",1)
	..s ARCCode=$p(OneLisStrInfo,"&",2)
	..q:$o(^ARCIM(0,"Code",ARCCode,""))=""
	..s ARCItemID=$o(^ARCIM(0,"Code",ARCCode,""))_"||1"

	..s OutOeOrdItem=$p(OneLisStrInfo,"&",3)
	..s OutLabNo=$p(OneLisStrInfo,"&",4)
	..s OutPreItemID=$p(OneLisStrInfo,"&",5)
	..s InsertItem=..InsertItem4Person(PreIADMID,ARCItemID,"","",job,"","PRE","")
	..s retVal=##class(web.DHCPE.PreIADM).UpdatePersonAuditAmount(PreIADMID)

	..&sql(insert into sqluser.DHC_PE_SecretItem(DHCPESecretParRef,
	             ItemDesc, ItemCode, OutOrdItemID
				, OutLabEpisodeNo,
				OutPreIOrdItemID,InPreIOrdItemID
			)values(
				:newSecretPAADMId,:ARCDesc,:ARCCode,:OutOeOrdItem,:OutLabNo,:OutPreItemID,:InsertItem
			
			)
		)
		
	.b ;开始登记	
	.s RegRet=##class(web.DHCPE.DHCPEIAdm).UpdateIADMInfo(PreIADMID,"2","",job) 
	.b ;登记完成
	.s ^yl("RegRet",PreIADMID)=RegRet	
	.d ##class(web.DHCPE.SecretPE).UpdateItemInfo(PreIADMID)
	.s IADM=$o(^DHCPEIADM(0,"CRMADM",PreIADMID,""))
	.d ##class(web.DHCPE.DHCPEIAdm).ArrivedUpdate(IADM,"ARRIVED")
	.s SussNum=SussNum+1	
    k ^DHCPEImportSecretInfo("Import",job)
    q 0_"^^^"_SussNum
	;TC
}

/// 更新his里的病人信息
ClassMethod UpdateHISPersonData(RegNo, IBaseInfo)
{
	s ^yl("UpdateHISPersonData")=$lb(RegNo, IBaseInfo)
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
		.s CardtypeDR=$p($g(^DHCPESetting("DHCPE","DefPatientType")),"^",5)
		.s SQLCODE=##class(web.DHCPE.PreIBIUpdate).Insertperson(info,CardtypeDR,$G(PLIST(11)))
	}
	else  //NoGen
	{
		s CardtypeDR=$p($g(^DHCPESetting("DHCPE","DefPatientType")),"^",5)
		b ;12
		s SQLCODE=##class(web.DHCPE.PreIBIUpdate).Insertperson(info,CardtypeDR,$G(PLIST(11)))
		//s PARowID=$G(%ROWID)
		//i PARowID'="" s RegNo=$p(^PAPER(PARowID,"PAT",1),"^",1)
		s RegNo=P5
	}
	b ;
	i SQLCODE=0 s SQLCODE=SQLCODE_"^"_RegNo_"^"_CardNo
	q SQLCODE
}

ClassMethod GetImportErr(Job, Sort)
{
	q $G(^DHCPEImportSecretInfo("ImportGErr",Job,Sort))
}

ClassMethod InsertItem4Person(AdmId As %Library.String = "", ArcItemIds As %Library.String = "", OrdEntId As %Library.String = "", GrpOrdItemIds As %Library.String = "", UpdateUserId As %Library.String = "", outNewIds As %Library.String = "", PreOrAdd As %Library.String = "", BreakOrdSetDR As %String = "") [ Private ]
{
	
	s ^tempdhcpe("0403","PreItemList","InsertItem4Person")=AdmId_","""_ArcItemIds_""","""_OrdEntId_""","""_GrpOrdItemIds_""","_UpdateUserId_","_outNewIds_","_PreOrAdd
	s retVal=""
	Q:(""=ArcItemIds) retVal
	
	Set PIADMStatus=$p($g(^DHCPEPreIADM(AdmId)),"^",8)
	Quit:(PIADMStatus)="CANCELPE" ""

	s GrpOrdItemIds=$g(GrpOrdItemIds)
	s newId=""		// 新预约项目记录的ID
	s outNewIds=""	// 返回值 成功插入项目记录的列表	
	
	s AsCharged=$p(^DHCPEPreIADM(AdmId),"^",9) 

	i $l(ArcItemIds,"^")=1{
		s itemPrice=$p(ArcItemIds,"&",2)
		s RoundType=$p(ArcItemIds,"&",3)
		s RoundRemark=$p(ArcItemIds,"&",4)
		s arcItemId=$p(ArcItemIds,"&",1)
		S PIBISexDR=""
		s PIADMPIBIDR=$p($g(^DHCPEPreIADM(AdmId)),"^",1)
		i PIADMPIBIDR'=""  d
		.S PIBISexDR=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",3)
		s SetInfo=$G(^DHCPESetting("DHCPE","DefPatientType"))
		s Sex=$G(^DHCPEDataEx("DHCPEStationOrder","Sex",arcItemId))
 		q:(PIBISexDR =$P(SetInfo,"^",3))&&( Sex=$P(SetInfo,"^",4)) "体检者性别与医嘱性别不一致"   //
		q:(PIBISexDR =$P(SetInfo,"^",4))&&( Sex=$P(SetInfo,"^",3)) "体检者性别与医嘱性别不一致"   //
	}

	f iLLoop=1:1:$l(ArcItemIds,"^") d
	.s arcItemInfo=$p(ArcItemIds,"^",iLLoop)
	.Q:(""=arcItemInfo)
	.s itemPrice=$p(arcItemInfo,"&",2)
	.s arcItemId=$p(arcItemInfo,"&",1)
	.// 如果是团体成员，获取相应的团体分组预约项目记录的ID
	.s GrpOrdItemId=$p(GrpOrdItemIds,"^",iLLoop)
	.s UpdateDate=+$H
	.s UpdateTime=$p($H,",",2)
	.s ItemFeeType=""
	
	.i GrpOrdItemId="" d
	..s RecLoc=##class(web.DHCPE.PreItemList).GetRecLoc(1,arcItemId)
	..s SPECDR=##class(web.DHCPE.PreItemList).GetDefaultSpecName(arcItemId,"1")
	..s:$d(%session) loc=%session.Get("LOGON.CTLOCID")
	..s:'$d(%session) loc=152   //改成科室id
	..i $G(^DHCPEDataEx("DHCPEStationOrder","SpecialItem",arcItemId,loc))'="" d
	...s ItemFeeType=$G(^DHCPEDataEx("DHCPEStationOrder","SpecialItem",arcItemId,loc))
	..s AccountAmount=+##class(web.DHCPE.PreItemList).GetOrderPrice(arcItemId_"&O",AdmId,"",ItemFeeType) 
	..;s AccountAmount=..GetOrderPrice(arcItemId_"&O",AdmId,"0",ItemFeeType)  //Add By WRZ 2008-11-13
	..s GTFactAmount=0
	..s Qty=1
	.e  d
	..s RecLoc=##class(web.DHCPE.PreItemList).GetRecLoc(2,GrpOrdItemId)
	..s SPECDR=##class(web.DHCPE.PreItemList).GetDefaultSpecName(GrpOrdItemId,"2")
	..s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",AdmId))
	..s GTADMFeeType=$G(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",$p(GrpOrdItemId,"||",1,2)))
	..i ADMFeeType=GTADMFeeType  d
	...s AccountAmount=$p($g(^DHCPEPreGADM(+GrpOrdItemId,"Team",$p(GrpOrdItemId,"||",2),"ORDITEM",$p(GrpOrdItemId,"||",3))),"^",11) //Add By  2011-07-13
	...s GTFactAmount=$p($g(^DHCPEPreGADM(+GrpOrdItemId,"Team",$p(GrpOrdItemId,"||",2),"ORDITEM",$p(GrpOrdItemId,"||",3))),"^",4) //Add By 2011-07-13
	..else   d
	...s AccountAmount=+##class(web.DHCPE.PreItemList).GetOrderPrice(arcItemId_"&O",AdmId,"",ADMFeeType)  
	...s GTFactAmount=0
	..s Qty=$G(^DHCPEDataEx("DHCPEPreGTOrdItem","Qty",GrpOrdItemId))
	..i +Qty=0 s Qty=1
	.i +itemPrice'=0  do
	..s AccountAmount=itemPrice  //原来协议调整费都是0
	.//else  do          //Modified By WRZ 2008-11-13
	.//.s AccountAmount=..GetOrderPrice(arcItemId)
	.&sql(insert into sqluser.dhc_pe_preIOrdItem(PIOI_ParRef,
	             PIOI_GTOI_DR, PIOI_ItmMast_DR, PIOI_OrdEnt_DR
				, PIOI_UpdateUser_DR, PIOI_UpdateDate,PIOI_UpdateTime,
				PIOI_Type,PIOI_AsCharged,PIOI_AccountAmount,PIOI_ItemStat,PIOI_ItemRecLoc_DR
			)values(
				:AdmId,:GrpOrdItemId,:arcItemId,:OrdEntId,:UpdateUserId,
				:UpdateDate,:UpdateTime,:PreOrAdd,:AsCharged,:AccountAmount,'1',:RecLoc
			)
		)
	.S:('(("0"=SQLCODE)||("-119"=SQLCODE))) SQLCODE=SQLCODE_"AdmId:"_AdmId_"GrpOrdItemId,:"_GrpOrdItemId_"arcItemId,:"_arcItemId_"OrdEntId,:"_OrdEntId_"UpdateUserId,:"_UpdateUserId_"UpdateDate,:"_UpdateDate_"UpdateTime,:"_UpdateTime_"PreOrAdd,:"_PreOrAdd_"AsCharged,:"_AsCharged_"AccountAmount,:"_AccountAmount_"RecLoc:"_RecLoc
	.Q:('(("0"=SQLCODE)||("-119"=SQLCODE)))
	.s OldInfo=$G(^DHCPEItemSort("Sort","Item",arcItemId))
	.k:OldInfo'="" ^DHCPEItemSort("Item",$P(OldInfo,"^",1),$P(OldInfo,"^",2))
	.s ItemSort=$I(^DHCPEItemSort("Sort","Item",arcItemId,"Sort"))
	.s ItemSub=$I(^DHCPEItemSort("Item",ItemSort))
	.s ^DHCPEItemSort("Item",ItemSort,ItemSub)=arcItemId
	.s ^DHCPEItemSort("Sort","Item",arcItemId)=ItemSort_"^"_ItemSub
	.s newId=%ROWID
	.s ^DHCPEDataEx("DHCPEPreIOrdItem","BreakOrdSetDR",newId)=$g(BreakOrdSetDR)
	.s ^DHCPEDataEx("DHCPEPreIOrdItem","Qty",newId)=Qty
	.s ^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",newId)=SPECDR
	.//对项目设置体检费别
	.s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",AdmId))
	.i GrpOrdItemId'=""  d
	..s TADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",GrpOrdItemId)) //add by 20110902
	..S ADMFeeType=TADMFeeType
	.i ItemFeeType'="" s ADMFeeType=ItemFeeType  
	.i BreakOrdSetDR'="" d
	..s:('$d(^DHCPEDataEx("DHCPEPreIADM","PreOrdSetOneSet",AdmId,BreakOrdSetDR))) ^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",AdmId)=$G(^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",AdmId))_"^"_ArcItemSetId
	..// 记录套餐
	..s ^DHCPEDataEx("DHCPEPreIADM","PreOrdSetOneSet",AdmId,BreakOrdSetDR)=0
	.s outNewIds=outNewIds_"^"_newId
	.//分组里插入新人员，取分组项目医保设置更新人员
	.i (GrpOrdItemId'="")&&($d(^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",GrpOrdItemId)))  s ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",newId)=$h_"^"_%session.Get("LOGON.USERID")
	.///得到审核表
	.i OrdEntId="" d
	..s PARet=##class(web.DHCPE.PreItemList).GetPAList(AdmId,PreOrAdd,"I",arcItemInfo,"",ADMFeeType)
	..//b //e
	..Q:PARet=""
	..//b //f
	..s Inserted=0
	..f PALoop=1:1:$l(PARet,$C(1)) d
	...s PAStr=$p(PARet,$C(1),PALoop)
	...s PADR=$p(PAStr,"^",1)
	...s FactAmount=$p(PAStr,"^",5)
	...i GTFactAmount'=0 s FactAmount=GTFactAmount  //Add By WRZ 2008-11-13
	...i +itemPrice'=0 s FactAmount=itemPrice  //原来协议调整费都是0
	...;额外加项不视同收费
	...s PAType=$P(^DHCPEPreA(PADR),"^",1)
	...i PAType="I" d
	....s gid=$p($g(^DHCPEPreIADM(AdmId)),"^",2)
	....i gid'="" d
	.....s NewAsCharged="N"
	.....s:$G(^DHCPEPreIADM(AdmId,"IFeeAsCharged"))'="" NewAsCharged=$G(^DHCPEPreIADM(AdmId,"IFeeAsCharged"))
	.....s ^tempdhcpe("IFeeAsCharged")=NewAsCharged
	.....s $P(^DHCPEPreIADM(AdmId,"ORDITEM",$p(newId,"||",2)),"^",9)=NewAsCharged
	...&sql(insert into sqluser.DHC_PE_PreIOrdItemFee(
				PIOIF_ParRef,PIOIF_FactAmount,PIOIF_PAudit_DR,
				PIOIF_UpdateUser_DR,PIOIF_UpdateDate,PIOIF_UpdateTime
			)values(
				:newId,:FactAmount,:PADR,:UpdateUserId,:UpdateDate,
				:UpdateTime
			)
		)
	...///如果是增加协议调整费自动确认加项
	...i +itemPrice'=0 d 
	....d ##class(web.DHCPE.TransAdmInfo).ConfirmAddOrdItem(AdmId,%session.Get("LOGON.USERID"))
    ....s ^DHCPEDataEx("InsertRoundFee",+newId,$P(newId,"||",2))=RoundType_"^"_RoundRemark_"^"_itemPrice_"^"_%session.Get("LOGON.USERID")_"^"_$H
    ...//b //2
	Q:('(("0"=SQLCODE)||("-119"=SQLCODE))) "Error: insert dhc_pe_preIOrdItem error , sqlcodemlh="_SQLCODE
	// 整理数据,去除空白预约ID
	i ($l(outNewIds,"^")>0) s outNewIds=$e(outNewIds,2,$l(outNewIds))
	s retVal=newId
	q retVal
}

/// 导入数据库数据信息 w ##class(web.DHCPE.SecretPE).UpdateItemInfo(5432)
ClassMethod UpdateItemInfo(InPreIADM)
{
	s SecretID=$o(^DHCPESecretPAADM(0,"InPreIADMDr",InPreIADM,""))
	q:SecretID="" ""
	s DHCPESecretChildSub=""
	f  s DHCPESecretChildSub=$o(^DHCPESecretPAADM(SecretID,"S",DHCPESecretChildSub)) q:DHCPESecretChildSub=""  d
	.s SecretItemID=SecretID_"||"_DHCPESecretChildSub
	.s InPreIOrdItemID=$p(^DHCPESecretPAADM(SecretID,"S",DHCPESecretChildSub),"^",8)
	.s CRMOrder=$o(^DHCPECRMO(0,"CRMORI",InPreIOrdItemID,""))
	.q:CRMOrder=""
	.s InOEOrdItem=$p(^DHCPECRMO(CRMOrder),"^",1)
	.S InOEORILabEpisodeNo=$p($g(^OEORD(+InOEOrdItem,"I",$p(InOEOrdItem,"||",2),3)),"^",20)
	.s OutLabEpisodeNo=$p(^DHCPESecretPAADM(SecretID,"S",DHCPESecretChildSub),"^",5)
	
	
	.&SQL(update sqluser.DHC_PE_SecretItem set InOrdItemID=:InOEOrdItem,InLabEpisodeNo=:InOEORILabEpisodeNo where ID=:SecretItemID) 
	.&SQL(update sqluser.OE_OrdItem set OEORI_LabEpisodeNo=:OutLabEpisodeNo where OEORI_RowId=:InOEOrdItem)
	q ""
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.SecretPE","ExportDailyPersonLisInfo","2022-08-01","2022-08-10")
Query ExportDailyPersonLisInfo(PEBeginDate As %String, PEEndDate As %String) As %Query(ROWSPEC = "PreIADM:%String,PAADM:%String,PatName:%String,PatSex:%String,PatAge:%String,PatIDCard:%String,PatTel:%String,LisStr:%String,IADMDate:%String")
{
}

ClassMethod ExportDailyPersonLisInfoExecute(ByRef qHandle As %Binary, PEBeginDate As %String, PEEndDate As %String) As %Status
{
	
	s ^yl("ExportDailyPersonLisInfo")=PEBeginDate_"^"_PEEndDate
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if ((""=PEBeginDate)&(""=PEEndDate)){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s CurUserID=%session.Get("LOGON.USERID") 
 	;s CurUserID=1
 	k ^DHCPETMPExport("ExportDailyPersonLisInfo",CurUserID)
 	i PEBeginDate'="" s PEBeginDate=##class(websys.Conversions).DateHtmlToLogical(PEBeginDate)
 	i PEEndDate'=""   s PEEndDate=##class(websys.Conversions).DateHtmlToLogical(PEEndDate)
 	s AdmDate=PEBeginDate-1
	f  s AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate)) q:(AdmDate="")||(AdmDate>PEEndDate)  d
	.s Time=""
	.f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,Time)) q:(Time="")  d
	..s IADM=0
	..f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,Time,IADM)) q:(IADM="")  d
    ...s IADMStatus=$p($g(^DHCPEIADM(IADM)),"^",8)
    ...q:IADMStatus'="ARRIVED"
    ...s PreIADM=$p(^DHCPEIADM(IADM),"^",4)
    ...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreIADM)         //Add by 090702
  	...q:LocFlag=1  
    ...s IADMDate=$p(^DHCPEIADM(IADM),"^",5)
    ...s IADMDate=$zd(IADMDate,3)
    
    ...s PAADM=$p(^DHCPEIADM(IADM),"^",1)
    ...s PreIBaseId=$p($g(^DHCPEPreIADM(PreIADM)),"^",1)
    ...q:PreIBaseId=""
    ...s PatName=$p(^DHCPEPreIBI(PreIBaseId),"^",2)
    ...s PatSex=$p(^DHCPEPreIBI(PreIBaseId),"^",3)
    ...i PatSex'="" s PatSex=$P(^CT("SEX",PatSex),"^",2)
    ...s:PatSex'="" PatSex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",PatSex,"CTSEXDesc","cls")
    ...s PatAge=$p(^DHCPEPreIBI(PreIBaseId),"^",4)
    ...s PatAge=$zd(PatAge,3)
    ...
    ...
    ...s PatIDCard="" //$p(^DHCPEPreIBI(PreIBaseId),"^",9)
    ...
    ...s PIBIPAPMINo=$p(^DHCPEPreIBI(PreIBaseId),"^",1)
    ...s PaPatID=$o(^PAPERi("PAPMI_PatNo",PIBIPAPMINo,0))
    ...s PACCardDesc=""
    ...S PACCardTypeDR=$P($G(^PAPER(PaPatID,"PAT",3)),"^",7)
	...I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
	...i PACCardDesc["身份证" s PatIDCard=$P($G(^PAPER(PaPatID,"PAT",3)),"^",6)
    ...
 	...s PatTel=$p(^DHCPEPreIBI(PreIBaseId),"^",8)
 	...s LisStr=""
 	...s OEOrder=$o(^OEORD(0,"Adm",PAADM,""))
	...s OEORIChildsub=0
    ...f  s OEORIChildsub=$o(^OEORD(OEOrder,"I",OEORIChildsub)) q:OEORIChildsub=""  d
    ....s OEORIItemStatDR=$p($g(^OEORD(OEOrder,"I",OEORIChildsub,1)),"^",13)
    ....q:(OEORIItemStatDR=4)||(OEORIItemStatDR="")
    ....s OEORIItmMastDR=$p($g(^OEORD(OEOrder,"I",OEORIChildsub,1)),"^",2)
    ....s STID=$o(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,""))
    ....;q:STID'="7"  //过滤非检验医嘱
    ....s LabSpecNo=$p($g(^OEORD(OEOrder,"I",OEORIChildsub,3)),"^",20)
    ....;q:LabSpecNo=""
 	....s ARCIMDesc=$p(^ARCIM($p(OEORIItmMastDR,"||",1),$p(OEORIItmMastDR,"||",2),1),"^",2)
	....s:ARCIMDesc'="" ARCIMDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ARCIMDesc,"ARCIMDesc","cls")
 	....s ARCIMCode=$p(^ARCIM($p(OEORIItmMastDR,"||",1),$p(OEORIItmMastDR,"||",2),1),"^",1)
 	....s OEOrdItemID=OEOrder_"||"_OEORIChildsub
 	
 	....s CRMOrder=$o(^DHCPECRMO(0,"OEORI",OEOrdItemID,""))
 	....q:CRMOrder=""
 	....s PreIOrdItemID=$p(^DHCPECRMO(CRMOrder),"^",2)
 	
 	....s LisInfo=ARCIMDesc_"&"_ARCIMCode_"&"_OEOrdItemID_"&"_LabSpecNo_"&"_PreIOrdItemID
 	....i LisStr="" d
 	.....s LisStr=LisInfo
 	....e  d
 	.....s LisStr=LisStr_"$$"_LisInfo
 	...q:LisStr=""
	...do OutputLisInfo	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputLisInfo
    ;^DHCPETMPExport("ExportDailyPersonLisInfo"
    
    s ^DHCPETMPExport("ExportDailyPersonLisInfo",CurUserID,ind)=PreIADM_"^"_PAADM_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatIDCard_"^"_PatTel_"^"_LisStr_"^"_IADMDate
	set Data=$lb(PreIADM,PAADM,PatName,PatSex,PatAge,PatIDCard,PatTel,LisStr,IADMDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ExportDailyPersonLisInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ExportDailyPersonLisInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {			
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ExportDailyPersonLisInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ExportDailyPersonLisInfoFetch ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetRowNum(QueryName As %String = "ExportDailyPersonLisInfo") As %Status
{
	s CurUserID=%session.Get("LOGON.USERID")
	s StrNum=""
	s num=0
	f  s num=$o(^DHCPETMPExport(QueryName,CurUserID,num))  q:num=""  d
	.i StrNum=""  s StrNum=num
	.else  s StrNum=StrNum_"^"_num
	q StrNum
}

ClassMethod ExportStationWorkInfo(Num As %Library.String = "", QueryName As %String = "ExportDailyPersonLisInfo") As %Status
{
	q:Num="" ""
	s UserID=%session.Get("LOGON.USERID")
 	s Data=$G(^DHCPETMPExport(QueryName,UserID,Num))
 	s OeOrdItemIDIn=$p(Data,"^",4)
 	/// 更新导出状态
 	if (OeOrdItemIDIn'=""){
	 	&SQL(update sqluser.DHC_PE_SecretItem set ExportStatus='Y' where InOrdItemID=:OeOrdItemIDIn)
	 	}
	Q Data
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.SecretPE","ExportDailyPersonLisResult","2022-08-17","2022-08-21")
Query ExportDailyPersonLisResult(PEBeginDate As %String, PEEndDate As %String, NameIn As %String = "") As %Query(ROWSPEC = "PatName:%String,SecretDate:%String,InPAADM:%String,InOrdItemID:%String,OutPAADM:%String,ARCItemID:%String,OutOrdItemID:%String,LisResultStr:%String")
{
}

ClassMethod ExportDailyPersonLisResultExecute(ByRef qHandle As %Binary, PEBeginDate As %String, PEEndDate As %String, NameIn As %String = "") As %Status
{
	
	s ^yl("ExportDailyPersonLisResult")=PEBeginDate_"^"_PEEndDate_"^"_NameIn
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if ((""=PEBeginDate)&(""=PEEndDate)){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s CurUserID=%session.Get("LOGON.USERID") 
 	//s CurUserID=1
 	k ^DHCPETMPExport("ExportDailyPersonLisResult",CurUserID)
 	i PEBeginDate'="" s PEBeginDate=##class(websys.Conversions).DateHtmlToLogical(PEBeginDate)
 	i PEEndDate'=""   s PEEndDate=##class(websys.Conversions).DateHtmlToLogical(PEEndDate)
 	//b // 0
 	s AdmDate=PEBeginDate-1
	f  s AdmDate=$O(^DHCPESecretPAADM(0,"ADMDate",AdmDate)) q:(AdmDate="")||(AdmDate>PEEndDate)  d
	.s SecretID=""
	.//b //
	.f  s SecretID=$O(^DHCPESecretPAADM(0,"ADMDate",AdmDate,SecretID)) q:(SecretID="")  d
	..s InPreIADM=$p(^DHCPESecretPAADM(SecretID),"^",9)
	..s InIADMID=$o(^DHCPEIADM(0,"CRMADM",InPreIADM,""))
	..s InPAADM=$p(^DHCPEIADM(InIADMID),"^",1) //院内就诊id
	..s OutPreIADM=$p(^DHCPESecretPAADM(SecretID),"^",1)
	..s OutPAADM=$p(^DHCPESecretPAADM(SecretID),"^",2) //院外就诊id  RLT_ADM_DR
	..;^DHCPESecretPAADM({DHC_PE_SecretPAADM.RowID},"S",{DHCPESecretChildSub})
	
	..s PatName=$p(^DHCPESecretPAADM(SecretID),"^",3)
	..q:(NameIn'="")&&(NameIn'=PatName)
	..s SecretDate=$p(^DHCPESecretPAADM(SecretID),"^",11)
	..s SecretDate=$zd(SecretDate,3)
	
	..s DHCPESecretChildSub=""
	..f  s DHCPESecretChildSub=$o(^DHCPESecretPAADM(SecretID,"S",DHCPESecretChildSub)) q:DHCPESecretChildSub=""  d
	...s InOrdItemID=$p(^DHCPESecretPAADM(SecretID,"S",DHCPESecretChildSub),"^",4)  //院内医嘱id
	...s ARCItemID=$p(^OEORD(+InOrdItemID,"I",$p(InOrdItemID,"||",2),1),"^",2)   //医嘱项id   RLT_ARCIM_DR 
	...s OutOrdItemID=$p(^DHCPESecretPAADM(SecretID,"S",DHCPESecretChildSub),"^",3) //院外医嘱id    RLT_OEORI_DR
	...;^DHCPERLT(0,"OEORI",{RLT_OEORI_DR},{RLT_RowId})
	
	...s LisResultStr=""
	...s RLTRowId=""
	...f  s RLTRowId=$o(^DHCPERLT(0,"OEORI",InOrdItemID,RLTRowId)) q:RLTRowId=""  d
	....s RLTODDR=$p(^DHCPERLT(RLTRowId),"^",3)  //细项id  RLT_OD_DR
	....s LabResult=$p(^DHCPERLT(RLTRowId),"^",4) //检验结果 RLT_Result
	....s:LabResult'="" LabResult=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEResult",LabResult,"RLTResult","cls")
	....s DoctorID=$p(^DHCPERLT(RLTRowId),"^",5)   //RLT_User_DR   RLT_RecordUser_DR
	....s RLTUpdateDate=$p(^DHCPERLT(RLTRowId),"^",6) //RLT_UpdateDate
	....s RLTNormal=$p(^DHCPERLT(RLTRowId),"^",7) //RLT_Normal
	....s RLTUpdateTime=$p(^DHCPERLT(RLTRowId),"^",11)  //RLT_UpdateTime
	....s OldResultData=$Replace(^DHCPERLT(RLTRowId),"^","&")
	....s Range=$g(^DHCPEDataEx("DHCPEResult",RLTRowId,"Ranges"))
	....s Unit=$g(^DHCPEDataEx("DHCPEResult",RLTRowId,"Unit"))
	....s AuditUser=$g(^DHCPEDataEx("DHCPEResult",RLTRowId,"AuditUser"))
	....s DoctorIdName=$g(^DHCPEDataEx("DHCPEResult",RLTRowId,"DoctorId"))
	....s HLFlag=$g(^DHCPEDataEx("DHCPEResult",RLTRowId,"HLFlag"))
	....s TextResult=$g(^DHCPEDataEx("DHCPEResult",RLTRowId,"TextResult"))
	....s:TextResult'="" TextResult=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("DHCPEExportDailyPersonLisResult.csp",TextResult)
	....s ODDesc=$p(^DHCPEST(+RLTODDR,"OD",$p(RLTODDR,"||",2)),"^",1)
	....s:ODDesc'="" ODDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEOrderDetail",ODDesc,"ODDesc","cls")
	....s ODCode=$p(^DHCPEST(+RLTODDR,"OD",$p(RLTODDR,"||",2)),"^",11)
	....//s LisResultInfo=RLTODDR_"&"_LabResult_"&"_DoctorID_"&"_RLTUpdateDate_"&"_RLTNormal_"&"_RLTUpdateTime_"&"_Range_"&"_Unit_"&"_AuditUser_"&"_DoctorIdName_"&"_HLFlag_"&"_TextResult_"&"_ODDesc_"&"_ODCode
	....//               15个  8.5 22个
	....s LisResultInfo=OldResultData_"&"_Range_"&"_Unit_"&"_AuditUser_"&"_DoctorIdName_"&"_HLFlag_"&"_TextResult_"&"_ODDesc_"&"_ODCode
	....i LisResultStr="" d
	.....s LisResultStr=LisResultInfo
	....e  d
	.....s LisResultStr=LisResultStr_"$$"_LisResultInfo
	...q:(LisResultStr="")
	...i LisResultStr="" s LisResultStr="未出结果"
	...s:LisResultStr'="" LisResultStr=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("DHCPEExportDailyPersonLisResult.csp",LisResultStr)
	...s PIOITranDateTime=$g(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",InOrdItemID))

	...do OutputLisResult	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputLisResult
    ;^DHCPETMPExport("ExportDailyPersonLisInfo"
    
    s ^DHCPETMPExport("ExportDailyPersonLisResult",CurUserID,ind)=PatName_"^"_SecretDate_"^"_InPAADM_"^"_InOrdItemID_"^"_OutPAADM_"^"_ARCItemID_"^"_OutOrdItemID_"^"_LisResultStr
	set Data=$lb(PatName,SecretDate,InPAADM,InOrdItemID,OutPAADM,ARCItemID,OutOrdItemID,LisResultStr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ExportDailyPersonLisResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ExportDailyPersonLisResultExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {			
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ExportDailyPersonLisResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ExportDailyPersonLisResultFetch ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="SecretPEDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.SecretPED</DataLocation>
<DefaultData>SecretPEDefaultData</DefaultData>
<IdLocation>^web.DHCPE.SecretPED</IdLocation>
<IndexLocation>^web.DHCPE.SecretPEI</IndexLocation>
<StreamLocation>^web.DHCPE.SecretPES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
