Import sqluser

Class web.DHCEMAdvPayass Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Descript:  取页面其他内容
/// w ##Class(web.DHCEMAdvPayass).GetLgContent("1058")
ClassMethod GetLgContent(LgLocID As %String, LgUserID As %String) As %String
{
	n (LgLocID,LgUserID,%session)
	s LocDesc=$p(^CTLOC(LgLocID),"^",2)        /// 科室
	S LocDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
	s User=""
	s:LgUserID'="" User=$p($g(^SSU("SSUSR",+LgUserID)),"^",2)        /// 科室
	S User=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",User)
    s ListData=LocDesc_"^"_User  
	s ListTitle="LocDesc^User"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Creator：      yangyongtao
/// CreatDate：    2019-03-16
/// Description：  科室下拉列表显示
/// Table：        CT_Loc
/// Return
/// d ##class(web.DHCEMAdvPayass).ListLoc("")
ClassMethod ListLoc(input)
{
	 n (input)
	 s:input'="" input=$zcvt(input,"U")
	 w "["
	 s phId=0,count=0
     f  s phId=$o(^CTLOC(phId)) q:phId=""  d
     .s Code=$P($g(^CTLOC(phId)),"^",1)
     .s Desc=$P($g(^CTLOC(phId)),"^",2)
     .s ContactName=$P($g(^CTLOC(phId)),"^",43)
	 .q:(input'="")&(Desc'[input)&(ContactName'[input)
	 .s:Desc["-" Desc=$p(Desc,"-",2)
	 .s count=count+1
	 .w $case(count,1:"",:",")
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",phId_"^"_Desc)
	w "]"
	q ""
}

/// Creator：      yangyongtao
/// CreatDate：    2019-03-16
/// Description：  病区下拉列表显示
/// Table：        Pac_ward
/// Return
/// d ##class(web.DHCEMAdvPayass).ListWard("")
ClassMethod ListWard(input)
{
	 n (input)
	 s:input'="" input=$zcvt(input,"U")
	 w "["
	 s phId=0,count=0
     f  s phId=$o(^PAWARD(phId)) q:phId=""  d
     .s Code=$P($g(^PAWARD(phId)),"^",1)
     .s Desc=$P($g(^PAWARD(phId)),"^",2)
     .s Flag=$P($g(^PAWARD(phId)),"^",6)
     .q:Flag="N"
	 .q:(input'="")&(Desc'[input)
	 .S:Desc["-" Desc=$p(Desc,"-",2)
	 .s count=count+1
	 .w $case(count,1:"",:",")
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",phId_"^"_Desc)
	w "]"
	q ""
	 q ""
}

/// Description:： 保存或者修改预交金评估记录
/// Creator：      yangyongtao
/// CreatDate：    2019-03-16
/// Table：        DHC_EmAdvPayAss
/// Others：       w ##class(web.DHCEMAdvPayass).saveAdvPayass("0","89943112^1058^333^612^67^612^1322^^^威尔而")
ClassMethod saveAdvPayass(payAssID, PayDataList)
{
	N (payAssID,PayDataList)
	S ret=0
	I payAssID=0 D
	.S ret=..Insert(PayDataList)
	E  D
	.S ret=..Update(payAssID,PayDataList)
	Q ret
}

/// Description:   添加预交金评估表
/// Creator：      yangyongtao
/// CreatDate：    2019-03-16
/// Table: 		   DHC_EmAdvPayAss
/// Input:  	   报告表数据
/// Return： 	   数据id
ClassMethod Insert(DataList As %String) As %String
{
	N (DataList)
	S adm=$p(DataList,"^",1)            //就诊ID
	S payCurward=$p(DataList,"^",2)     //当前病区
	S payobsDays=$p(DataList,"^",3)     //评估留观天数 
	s payobsWard=$p(DataList,"^",4)     //评估留观病区
	S advpayAmt=$p(DataList,"^",5)      //评估预交金
	S payLoc=$p(DataList,"^",6)         //评估科室
	S UserID=$p(DataList,"^",7)         //评估人
	S payAssDate=$p(DataList,"^",8)     //评估日期
	S:payAssDate'="" payAssDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(payAssDate)
	S:payAssDate="" payAssDate=+$h
	S payAssTime=$p(DataList,"^",9)     //评估时间
	S:payAssTime'="" payAssTime=$zth(payAssTime,1)
	S:payAssTime="" payAssTime=$p($h,",",2)		
	S payNote=$p(DataList,"^",10)        //备注
		
	&SQL(Insert Into DHC_EmAdvPayAss(EM_Adm_Dr,EM_Ward_Dr,EM_ObsDays,EM_ObsWard_Dr,
	 EM_AdvPayAmt,EM_Loc_Dr,EM_User_Dr,EM_Date,EM_Time,EM_Note) 
	  Values(:adm,:payCurward,:payobsDays,:payobsWard,:advpayAmt,
	   :payLoc,:UserID,:payAssDate,:payAssTime,:payNote
	))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description:   修改预交金评估表
/// Creator：      yangyongtao
/// CreatDate：    2019-03-16
/// Table: 		   DHC_EmAdvPayAss
/// Input:  	   报告表数据
/// Return： 	   数据id
ClassMethod Update(payAssID As %String, DataList As %String) As %String
{
	
	N (payAssID,DataList)
	S payCurward=$p(DataList,"^",2)     //当前病区
	S payobsDays=$p(DataList,"^",3)     //评估留观天数 
	s payobsWard=$p(DataList,"^",4)     //评估留观病区
	S advpayAmt=$p(DataList,"^",5)      //评估预交金
	S payLoc=$p(DataList,"^",6)         //评估科室
	S UserID=$p(DataList,"^",7)         //评估人
	S payAssDate=$p(DataList,"^",8)     //评估日期
	S payAssDate=$p(DataList,"^",8)     //评估日期
	S:payAssDate'="" payAssDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(payAssDate)
	S payAssTime=$p(DataList,"^",9)     //评估时间
	S:payAssTime'="" payAssTime=$zth(payAssTime,1)	
	S payNote=$p(DataList,"^",10)        //备注
	&SQL(Update DHC_EmAdvPayAss Set EM_Ward_Dr=:payCurward,EM_ObsDays=:payobsDays,EM_ObsWard_Dr=:payobsWard,EM_AdvPayAmt=:advpayAmt,
	   EM_Loc_Dr=:payLoc,EM_User_Dr=:UserID,EM_Date=:payAssDate,EM_Time=:payAssTime,EM_Note=:payNote Where EM_RowID=:payAssID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description:   查询预交金评估表
/// Creator：      yangyongtao
/// CreatDate：    2019-03-16
/// Table: 		   DHC_EmAdvPayAss
/// Others：       w ##class(web.DHCEMAdvPayass).ListAdvPayass("10","1","2019-03-16","2019-03-16","","","")
ClassMethod ListAdvPayass(rows As %String, page As %String, startDate As %String = "", endDate As %String = "", no As %String = "", lgUser = "", parAdm = "", lgHosp = "") As %String
{
	n (rows,page,no,startDate,endDate,lgUser,parAdm,lgHosp,%session)

	s end=page*rows
	s start=(page-1)*rows+1
	s titlestr="ID^regno^name^sex^age^amt^reqUser^reqDate^admLoc^adm"
	s count=0
	w "{""rows"":["
	s startDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(endDate)
	f date=startDate:1:endDate d
	.s id=""
	.f  s id=$o(^DHCEMADVPA(0,"AssDate",date,id)) q:id=""  d
	..s adm=$p(^DHCEMADVPA(id),"^",1)
	..q:(parAdm'="")&&(parAdm'=adm)
	..q:(lgHosp'="")&(##class(web.DHCEMCommonUtil).GetHospitalByAdm(adm)'=lgHosp) //hxy 2020-06-17 区分院区
	..S payCurward=$p(^DHCEMADVPA(id),"^",2)     //当前病区
	..S payobsDays=$p(^DHCEMADVPA(id),"^",3)     //评估留观天数 
	..s payobsWard=$p(^DHCEMADVPA(id),"^",4)     //评估留观病区
	..s:payobsWard'=0 payobsWard=$p(^CTLOC(+payobsWard),"^",2)
	..S advpayAmt=$p(^DHCEMADVPA(id),"^",5)      //评估预交金
	..S payLoc=$p(^DHCEMADVPA(id),"^",6)         //评估科室
	..s:payLoc'=0 payLoc=$p(^CTLOC(+payLoc),"^",2)
	..S User=""
	..S UserID=$p(^DHCEMADVPA(id),"^",7)         //评估人
	..S:UserID'="" User=$p(^SSU("SSUSR",UserID),"^",2)
	..S payAssDate=$p(^DHCEMADVPA(id),"^",8)     //评估日期
	..i payAssDate'="" s payAssDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(payAssDate)
	..S payAssTime=$p(^DHCEMADVPA(id),"^",9)     //评估时间	
	..I payAssTime'="" S payAssTime=$zt(payAssTime,2)	
	..S payNote=$p(^DHCEMADVPA(id),"^",10)        //备注

	..s regno="",admLoc="",name="",age="",sex=""
	..i adm'=0 d
	...s papmiId=+^PAADM(adm)
	...s name=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	...s regno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	...s age=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(adm) 
	...s ctlocId=+$p(^PAADM(adm),"^",4)
	...s:ctlocId'=0 admLoc=$p(^CTLOC(+ctlocId),"^",2)
	...s sexdr=$p(^PAPER(papmiId,"ALL"),"^",7)
   	...s sex=$p(^CT("SEX",sexdr),"^",2)
	..s sex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",sex)
	..S admLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",admLoc)
	..S User=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",User)
   	..q:($g(no)'="")&&(regno'=no)
	..s count = count+1
	..q:(count<start)||(count>end)
	..w $case(count,start:"",:",")
	..s tempstr=id_"^"_$g(regno)_"^"_$g(name)_"^"_$g(sex)_"^"_$g(age)_"^"_advpayAmt_"^"_User_"^"_payAssDate_" "_payAssTime_"^"_$g(admLoc)_"^"_adm
	..w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,tempstr)
    w "],""total"":"_count_"}"
	q ""
}

/// Creator：      yangyongtao
/// CreatDate：    2019-03-16
/// Description:： 查询急诊预交金申请信息
/// Table：        DHC_EmAdvPayAss 
/// Others：       w ##class(web.DHCEMAdvPayass).getInfoBYAss("3")
ClassMethod getInfoBYAss(pay As %String = "") As %String
{
	n (pay,%session)
	s titlestr="payobsDays^payobsWard^advpayAmt^payLoc^payAssDate^payAssTime^payNote^User",tempstr=""
	i +pay'=0 d
	.S payCurward=$p(^DHCEMADVPA(pay),"^",2)     //当前病区
	.S payobsDays=$p(^DHCEMADVPA(pay),"^",3)     //评估留观天数 
	.s payobsWard=$p(^DHCEMADVPA(pay),"^",4)     //评估留观病区
	.S advpayAmt=$p(^DHCEMADVPA(pay),"^",5)      //评估预交金
	.S payLoc=$p(^DHCEMADVPA(pay),"^",6)         //评估科室
	.S User=""
	.S UserID=$p(^DHCEMADVPA(pay),"^",7)         //评估人
	.S:UserID'="" User=$p(^SSU("SSUSR",UserID),"^",2)
	.S payAssDate=$p(^DHCEMADVPA(pay),"^",8)     //评估日期
	.i payAssDate'="" s payAssDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(payAssDate)
	.S payAssTime=$p(^DHCEMADVPA(pay),"^",9)     //评估时间	
	.I payAssTime'="" S payAssTime=$zt(payAssTime,2)	
	.S payNote=$p(^DHCEMADVPA(pay),"^",10)        //备注
	.S Enabled=$p(^DHCEMADVPA(pay),"^",11)        //是否可用
	.s User=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",User)
   	.s tempstr=payobsDays_"^"_payobsWard_"^"_advpayAmt_"^"_payLoc_"^"_payAssDate_"^"_payAssTime_"^"_payNote_"^"_User
   	w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,tempstr)
   	q ""
}

/// Creator：      yangyongtao
/// CreatDate：    2019-03-16
/// Description:： 查询急诊病人基本信息
/// Others：       w ##class(web.DHCEMAdvPayass).getInfoBYAdm("4463","2")
ClassMethod getInfoBYAdm(adm As %String = "", hosp As %String) As %String
{
	n (adm,hosp,%session)
	s titlestr="patno^name^sex^age^level^threenon^admtime^admway^diagnosis^WardId^LocationDr^TotalAmt^Charge^NotAmount^AllCharge^StayFlag",tempstr=""
	i +adm'=0 d
	.s diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(adm)
	.s WardId=$p($g(^PAADM(adm)),"^",70)
	.s:WardId'=0 LocationDr=$p($g(^PAWARD(+WardId)),"^",5)
	.s papmiId=+^PAADM(adm)
	.s patno=$p(^PAPER(papmiId,"PAT",1),"^",1)	   /// 病人登记号
	.s name=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s age=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(adm)
	.s sexdr=$p(^PAPER(papmiId,"ALL"),"^",7)
   	.s sex=$p(^CT("SEX",sexdr),"^",2)
   	.//s level=##Class(web.DHCEMPatCheckLevCom).GetPatLevByAdm(adm)
   	.s level=##class(web.DHCEMPatCheckLevCom).GetPatPriority(adm, "Y") /// 获取病人当前分级描述 bianshuai 2020-03-16
   	.s levId=+##Class(web.DHCEMPatCheckLevCom).GetPatLevIdByAdm(adm,papmiId,hosp)
   	.i levId'=0 d
   	..s admway=$p(^DHCEMPCL(levId),"^",16)
   	..s:admway'="" admway=$p(^DHCEMPADW(admway),"^",2)
	..s admway=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatAdmWay","PAWDesc","",admway)
   	..s admtime=##class(web.DHCEMCommonUtil).DateLogicalToHtml($p(^DHCEMPCL(levId),"^",4))
   	..s patType=+$p(^DHCEMPCL(levId),"^",40)
   	..i patType'=0 d
   	...s threenon=$p(^DHCEMPT(patType),"^",2)
   	...s threenon=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatType","PTDesc","",threenon)
   	.S TotalAmtStr= ##class(web.DHCBillInterface).IGetStayTotalAmt(adm)        //总费用
   	.S TotalAmt=$p(TotalAmtStr,"^",1)
   	.s Charge= ##class(web.DHCDocOrderCommon).GetCurrentDeposit(adm)           //押金余额
	.S NotAmountStr= "" ; ##class(web.DHCEPBillStayCons).GetNotStayBookAmount(adm) //未记账金额 
	.S NotAmount=$p(NotAmountStr,"^",4)
	.s AllCharge = ##class(web.DHCBillInterface).IGetStayDeposit(adm,"")
	.s StayRtn=##class(web.UDHCJFBaseCommon).GetPatAdmStayStat(adm)
	.s StayFlag=$p(StayRtn,"^",1)
	.s sex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",sex)
	.s tempstr=patno_"^"_name_"^"_sex_"^"_age_"^"_$g(level)_"^"_$g(threenon)_"^"_$g(admtime)_"^"_$g(admway)_"^"_$g(diagnosis)_"^"_$g(WardId)_"^"_$g(LocationDr)_"^"_$g(TotalAmt)_"^"_$g(Charge)_"^"_$g(NotAmount)
   	.s tempstr=tempstr_"^"_AllCharge_"^"_StayFlag
   	w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,tempstr)
   	q ""
}

/// Creator：      yangyongtao
/// CreatDate：    2019-03-16
/// Description:： 获取打印信息
/// Others：       w ##class(web.DHCEMAdvPayass).getPrintInfo("3")
ClassMethod getPrintInfo(pay As %String = "") As %String
{
	n (pay)
	S payCurward=$p(^DHCEMADVPA(pay),"^",2)     //当前病区
	s:payCurward'=0 payCurward=$p(^CTLOC(+payCurward),"^",2)
	S payobsDays=$p(^DHCEMADVPA(pay),"^",3)     //评估留观天数 
	s payobsWard=$p(^DHCEMADVPA(pay),"^",4)     //评估留观病区
	s:payobsWard'=0 payobsWard=$p(^PAWARD(+payobsWard),"^",2)
	S advpayAmt=$p(^DHCEMADVPA(pay),"^",5)      //评估预交金
	S payLoc=$p(^DHCEMADVPA(pay),"^",6)         //评估科室
	s:payLoc'=0 payLoc=$p(^CTLOC(+payLoc),"^",2)
	S User=""
	S UserID=$p(^DHCEMADVPA(pay),"^",7)         //评估人
	S:UserID'="" User=$p(^SSU("SSUSR",UserID),"^",2)
	S payAssDate=$p(^DHCEMADVPA(pay),"^",8)     //评估日期
	i payAssDate'="" s payAssDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(payAssDate)
	S payAssTime=$p(^DHCEMADVPA(pay),"^",9)     //评估时间	
	I payAssTime'="" S payAssTime=$zt(payAssTime,2)	
	S payNote=$p(^DHCEMADVPA(pay),"^",10)        //备注
	s adm=$p(^DHCEMADVPA(pay),"^",1)
	i adm>0 d
	.s papmiId=+^PAADM(adm)
	.s Name=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s Company=$p($g(^PAPER(papmiId,"PER",4)),"^",18)
	.s Phone=$p(^PAPER(papmiId,"PER",1),"^",11)
	.s diagnosis=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(adm)
	.s address=$g(^PAPER(papmiId,"PER","ADD",1))
	.s ctlocId=+$p(^PAADM(adm),"^",4)
	.s hopName=$p(^CTLOC(ctlocId),"^",22)
	.s hopName=$p(^CT("HOSP",hopName),"^",2)
   	w $g(Name)_"^"_$g(Company)_"^"_$g(Phone)_"^"_$g(diagnosis)_"^"_$g(address)_"^"_$g(hopName)_"^"_payCurward_"^"_payobsDays_"^"_payobsWard_"^"_advpayAmt_"^"_payLoc_"^"_User_"^"_payAssDate_" "_payAssTime_"^"_payNote
   	q ""
}

/// Creator：      yangyongtao
/// CreatDate：    2019-03-22
/// Description:： 删除
/// Table：        DHC_EmAdvPayAss
/// Others：       w ##class(web.DHCEMAdvPayass).DelPayAss("7")
ClassMethod DelPayAss(pay As %String, lgUser As %String)
{
	n (pay,lgUser)
	S UserID=$p(^DHCEMADVPA(pay),"^",7)         //评估人
	q:lgUser'=UserID "-1"
	&SQL(Delete From DHC_EmAdvPayAss Where EM_RowID=:pay)
	Q SQLCODE
}

/// 获取当前日期
/// w ##Class(web.DHCEMAdvPayass).GetCurrDate()
ClassMethod GetCurrDate()
{
	S CurDate=+$H
	s:CurDate'="" CurDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CurDate)
	S CurTime=$p($h,",",2)
    s:CurTime'="" CurTime=$zt(CurTime,2)
	q CurDate_" "_CurTime
}

/// 获取最后一次的预交金
/// w ##Class(web.DHCEMAdvPayass).GetPayByAdm("89944127")
ClassMethod GetPayByAdm(EpisodeID As %String = "")
{
	N (EpisodeID)
	Q:EpisodeID="" ""
	S payAmt=""
	S Pay=$o(^DHCEMADVPA(0,"AdmNo",EpisodeID,""),-1)
	Q:(Pay=0)||(Pay="") ""
	S advpayAmt=$p($g(^DHCEMADVPA(Pay)),"^",5)   //评估预交金
	S Enabled=$p($g(^DHCEMADVPA(Pay)),"^",11)        //是否可用
	Q:Enabled="N" ""
	I advpayAmt'="" S payAmt=advpayAmt
	q payAmt
}

/// 预交金不可用
/// w ##Class(web.DHCEMAdvPayass).UpdPayFlag("89944127")
ClassMethod UpdPayFlag(EpisodeID As %String = "")
{
	N (EpisodeID)
	//s ^DL("UpdPayFlag",EpisodeID)=EpisodeID
	Q:EpisodeID="" ""
	s Enabled="N"
	S Pay=$o(^DHCEMADVPA(0,"AdmNo",EpisodeID,""),-1)
	Q:(Pay=0)||(Pay="") ""
	&sql(update DHC_EmAdvPayAss set EM_Enabled=:Enabled where EM_RowID=:Pay)
	q SQLCODE
}

/// w ##Class(web.DHCEMAdvPayass).GetPrintData("171")
ClassMethod GetPrintData(ID)
{
	s AdmID=$p(^DHCEMADVPA(ID),"^",1)
	s HospID=##class(web.DHCEMCommonUtil).GetHospitalByAdm(AdmID)
	s HospName=$p(^CT("HOSP",HospID),"^",2)
	s AdvPayAmt=$p(^DHCEMADVPA(ID),"^",5)      //评估预交金
	s PayLocID=$p(^DHCEMADVPA(ID),"^",6)         //评估科室
	s PayLoc=""
	s:PayLocID'=0 PayLoc=$p(^CTLOC(+PayLocID),"^",2)
	S User=""
	S UserID=$p(^DHCEMADVPA(ID),"^",7)         //评估人
	S:UserID'="" User=$p(^SSU("SSUSR",UserID),"^",2)
	S PayAssDate=$p(^DHCEMADVPA(ID),"^",8)     //评估日期
	i PayAssDate'="" s PayAssDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PayAssDate)
	S PayAssTime=$p(^DHCEMADVPA(ID),"^",9)     //评估时间	
	I PayAssTime'="" S PayAssTime=$zt(PayAssTime,2)	
	S PayNote=$p(^DHCEMADVPA(ID),"^",10)        //备注
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	s CurDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CurDate)
	s CurTime=$zt(CurTime,2)
	
	s PatNo="",AdmLoc="",PatName="",PatAge="",PatSex="",PatDiag="",BillType=""
	i AdmID'=0 d
	.s PatientID=+^PAADM(AdmID)
	.s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	.s PatNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	.s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(AdmID) 
	.s AdmLocID=+$p(^PAADM(AdmID),"^",4)
	.s:AdmLocID'=0 AdmLoc=$p(^CTLOC(+AdmLocID),"^",2)
	.s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)
	.s PatSex=$p(^CT("SEX",SexID),"^",2)
	.s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(AdmID)
	.s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	.s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	
	s DataList=ID_"^"_$g(PatNo)_"^"_$g(PatName)_"^"_$g(PatSex)_"^"_$g(PatAge)_"^"_AdvPayAmt
	s DataList=DataList_"^"_User_"^"_PayAssDate_"^"_PayAssTime_"^"_$g(AdmLoc)_"^"_AdmID
	s DataList=DataList_"^"_CurDate_"^"_CurTime_"^"_HospName_"^"_PatDiag_"^"_BillType
	s TitleList="ID^PatNo^PatName^PatSex^PatAge^AdvPayAmt^User^PayAssDate^PayAssTime^AdmLoc"
	s TitleList=TitleList_"^AdmID^CurDate^CurTime^HospName^PatDiag^BillType"
	q DataList
	;w ##class(web.DHCAPPJsonCommon).getJsonData(TitleList,DataList)
	;q ""
}

}
