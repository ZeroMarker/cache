Import sqluser

Class web.DHCEmPatChkRList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	查询已维护的出租物品 
/// W ##Class(web.DHCEmPatChkRList).GetRentList("2")
ClassMethod GetRentList(HospID As %String) As %String
{
	;s HospID=0 //hxy 2019-12-25 云his公有，不区分医院 //hxy 2020-05-25 注释 多院区私有
	s HospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmRentList",HospID) //hxy 2020-05-22 add 多院区
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RL_RowId,RL_Desc FROM DHC_EmRentList Where"
    s:+HospID'=0 sqlStr = sqlStr_"  RL_Hosp_Dr='"_HospID_"' And "
	s sqlStr = sqlStr_"  RL_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s ListTitle="id^text"
	s count = 0
	w "["
	While(result.Next())
	{
		s RLID = result.Data("RL_RowId")
		s RLDesc = result.Data("RL_Desc")
		s RLDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmRentList","RLDesc","",RLDesc) //hxy 2022-11-30
		s ListData=RLID_"^"_RLDesc
		s count = count+1
		I count=1 d
		.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	}
	w "]"
	q ""
}

/// Descript:	保存出租物品信息
/// w ##class(web.DHCEmPatChkRList).saveRentList("1^1^2017-02-22^20:04^DHC Pharmacy^1^^身份证^^^^^^^^")	
/// w ##class(web.DHCEmPatChkRList).saveRentList("^Y^3^4^5^6^7^8^9^10^^")
ClassMethod saveRentList(RentList As %String)
{
    s PCRRentDr=$p(RentList,"^",1)
    s PCRFlag=$p(RentList,"^",2)
    s Date=$p(RentList,"^",3)
    s PCRDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(Date) //hxy 2017-03-03 $zdh(Date,3)
    s Time=$p(RentList,"^",4)
    s PCRTime=$zth(Time,3)
    s PCROperator=$p(RentList,"^",5)
    s PCRRenter=$p(RentList,"^",6)
    s PCRRenterTel=$p(RentList,"^",7)
	s PCRCardType=$p(RentList,"^",8)
	s PCRCash=$p(RentList,"^",9)
	s PCRCashNo=$p(RentList,"^",10)
    s PCRGiveUser=$p(RentList,"^",11)
	s PCRGiveRelation=$p(RentList,"^",12)
	s rentid=$p(RentList,"^",13)
	s GiveDate=$p(RentList,"^",14)
	i GiveDate=""  s PCRGiveDate=""
	e  s PCRGiveDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(GiveDate) //$zdh(GiveDate,3)
	s GiveTime=$p(RentList,"^",15)
	i GiveTime=""  s GiveTime=""
	e  s PCRGiveTime=$zth(GiveTime,3)
	s PCRGiveOpUser=$p(RentList,"^",16)
	q:(PCRGiveDate'="")&&(PCRGiveDate<PCRDate) "-100"
	s LgHospID=$p(RentList,"^",17)
	
	s Err=0
	if (PCRGiveDate'="") {
		s:PCRGiveDate<PCRDate Err=-100
		s:(PCRGiveDate=PCRDate)&&(PCRGiveTime<PCRTime) Err=-100
	}
	
	q:Err'=0 Err
	if (rentid=""){
		&sql(insert into DHC_EmPatChkRList (PCR_Rent_Dr,PCR_Flag,PCR_Date,PCR_Time,PCR_Operator,PCR_Renter
			,PCR_RenterTel,PCR_CardType,PCR_Cash,PCR_CashNo,PCR_GiveUser,PCR_GiveRelation,PCR_GiveDate,PCR_GiveTime,PCR_GiveOpUser,
			PCR_Hosp_Dr)
			values(:PCRRentDr,:PCRFlag,:PCRDate,:PCRTime,:PCROperator,:PCRRenter,:PCRRenterTel,:PCRCardType,
			:PCRCash,:PCRCashNo,:PCRGiveUser,:PCRGiveRelation,:PCRGiveDate,:PCRGiveTime,:PCRGiveOpUser,:LgHospID))
        if (SQLCODE'=0){
	    	s Err=-1 
	    }
	}else{
		&sql(update DHC_EmPatChkRList set PCR_Rent_Dr=:PCRRentDr,PCR_Flag=:PCRFlag,PCR_Date=:PCRDate,
			PCR_Time= :PCRTime,PCR_Operator=:PCROperator,PCR_Renter=:PCRRenter,PCR_RenterTel=:PCRRenterTel,
			PCR_CardType=:PCRCardType,PCR_Cash=:PCRCash,PCR_CashNo=:PCRCashNo,PCR_GiveUser=:PCRGiveUser,
			PCR_GiveRelation=:PCRGiveRelation,PCR_GiveDate=:PCRGiveDate,PCR_GiveTime=:PCRGiveTime,
			PCR_GiveOpUser=:PCRGiveOpUser,PCR_Hosp_Dr=:LgHospID
			where PCR_RowId= :rentid)
	 	if (SQLCODE'=0){
		   s Err=-1
		}   
	}  
    q Err
}

/// Descript:	查询出租物品信息
/// w ##class(web.DHCEmPatChkRList).SearchRent("0","10","2017-02-22^16:00","2017-02-23^17:00","","")
ClassMethod SearchRent(offset = 0, limit = 10, StartDate As %String, EndDate As %String, Renter As %String, RentStatus As %String, Hosp As %String)
{
	 s fromDate=$p(StartDate,"^",1)
	 s StaTime=$p(StartDate,"^",2)
	 s toDate=$p(EndDate,"^",1)
	 s EndTime=$p(EndDate,"^",2)
     s End =offset+limit
     s Start = offset+1
     s count=0
     s repid=$i(^CacheTemp)    
     S jsonObj=##class(web.DHCAPPJsonObject).%New()
     w "{""rows"":["
     ;i fromDate["-" s fromDate=$zdh(fromDate,3)
   	 ;i fromDate["/" s fromDate=$zdh(fromDate,4)
   	 i fromDate'="" s fromDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(fromDate)  //hxy 2017-03-03
 	 i fromDate="" s fromDate=+$h
	 ;i toDate["-"  s toDate=$zdh(toDate,3)
	 ;i toDate["/"  s toDate=$zdh(toDate,4)
	 i toDate'="" s toDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(toDate)  //hxy
	 i toDate=""  s toDate=+$h
	 s today=+$h
	 s:StaTime'="" StaTime=$zth(StaTime,2)
	 s:EndTime'="" EndTime=$zth(EndTime,2)
 	 s num=0
 	 k ^TMP("web.DHCEmPatChkRList","SearchRent",repid,num)
 	 s res=0
     f Date=fromDate:1:toDate  d 
     .s rentTime=""
     .f  s rentTime=$o(^DHCEMPCRi(0,"rentDate",Date,rentTime))   Q:rentTime=""  D
     ..s rentRowId=""
     ..f  s rentRowId=$o(^DHCEMPCRi(0,"rentDate",Date,rentTime,rentRowId))  Q:rentRowId=""  D 
     ...q:(fromDate=Date)&(rentTime'="")&(StaTime'="")&(StaTime>rentTime) 
     ...q:(toDate=Date)&(rentTime'="")&(EndTime'="")&(EndTime<rentTime)
	 ...s PCRRentDr=$p(^DHCEMPCR(rentRowId),"^",1)
	 ...Q:'$D(^DHCEMRL(+PCRRentDr))
	 ...s PCRRentDesc=$p(^DHCEMRL(PCRRentDr),"^",2)
	 ...s RLHospDr=$p(^DHCEMPCR(rentRowId),"^",16)
	 ...q:RLHospDr'=Hosp
	 ...s PCRFlag=$p(^DHCEMPCR(rentRowId),"^",2)
	 ...q:(RentStatus'="")&&( RentStatus'= PCRFlag)
	 ...i PCRFlag=1   s PCRFlag="租"
	 ...i PCRFlag=2   s PCRFlag="还"
	 ...s Date=$p(^DHCEMPCR(rentRowId),"^",3)
	 ...s PCRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(Date) //hxy $zd(Date,3)
	 ...s Time=$p(^DHCEMPCR(rentRowId),"^",4)
	 ...s PCRTime=$zt(Time,2)
	 ...s PCROperator=$p(^DHCEMPCR(rentRowId),"^",5)
	 ...s PCRRenter=$p(^DHCEMPCR(rentRowId),"^",6)
	 ...q:(Renter'="")&&( PCRRenter'= Renter)
	 ...s PCRRenterTel=$p(^DHCEMPCR(rentRowId),"^",7)
	 ...s PCRCardType=$p(^DHCEMPCR(rentRowId),"^",8)
	 ...s PCRCash=$p(^DHCEMPCR(rentRowId),"^",9)
	 ...s PCRCashNo=$p(^DHCEMPCR(rentRowId),"^",10)
	 ...s PCRGiveUser=$p(^DHCEMPCR(rentRowId),"^",11)
	 ...s PCRGiveRelation=$p(^DHCEMPCR(rentRowId),"^",12)
     ...s GiveDate=$p(^DHCEMPCR(rentRowId),"^",13)
     ...i GiveDate="" s PCRGiveDate=""
     ...e  s PCRGiveDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(GiveDate) //hxy $zd(GiveDate,3)
     ...s GiveTime=$p(^DHCEMPCR(rentRowId),"^",14)
     ...i GiveTime="" s PCRGiveTime=""
     ...e  s PCRGiveTime=$zt(GiveTime,2) 
     ...s PCRGiveOpUser=$p(^DHCEMPCR(rentRowId),"^",15)
	 ...s num=num+1
	 ...s TempStr=num_"^"_PCRRentDesc_"^"_PCRFlag_"^"_PCRDate_"^"_PCRTime_"^"_PCROperator_"^"_PCRRenter_"^"_PCRRenterTel_"^"_PCRCardType_"^"_PCRCash_"^"_PCRCashNo_"^"_PCRGiveUser_"^"_PCRGiveRelation_"^"_rentRowId_"^"_PCRRentDr_"^"_PCRGiveDate_"^"_PCRGiveTime_"^"_PCRGiveOpUser
	 ...s ^TMP("web.DHCEmPatChkRList","SearchRent",repid,num)=TempStr 
	 ...S count=count+1
	 ...Q:count<Start
	 ...Q:count>End
	 ...W $case(count,Start:"",:",") 
     ...W ##class(web.DHCAPPJsonCommon).getJsonData("num^PCRRentDesc^PCRFlag^PCRDate^PCRTime^PCROperator^PCRRenter^PCRRenterTel^PCRCardType^PCRCash^PCRCashNo^PCRGiveUser^PCRGiveRelation^rentRowId^PCRRentDr^PCRGiveDate^PCRGiveTime^PCRGiveOpUser",TempStr)
     ..
     .
     w "],""total"":"_count_"}"
     q ""
}

/// Descript:	查询出租物品信息
/// w ##class(web.DHCEmPatChkRList).SearchRent("0","10","2017-02-22^16:00","2017-02-23^17:00","","")
ClassMethod JsonListSearchRent(page, rows, StartDate As %String, EndDate As %String, Renter As %String, RentStatus As %String, Hosp As %String)
{
	 n (page, rows,StartDate,EndDate,Renter,RentStatus, Hosp,%session)
	 s fromDate=$p(StartDate,"^",1)
	 s StaTime=$p(StartDate,"^",2)
	 s toDate=$p(EndDate,"^",1)
	 s EndTime=$p(EndDate,"^",2)
     s Start=page-1*rows+1
     s End=page*rows
     s count=0
     s repid=$i(^CacheTemp)    
     S jsonObj=##class(web.DHCAPPJsonObject).%New()
     w "{""rows"":["
   	 i fromDate'="" s fromDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(fromDate)  //hxy 2017-03-03
 	 i fromDate="" s fromDate=+$h
	 i toDate'="" s toDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(toDate)  //hxy
	 i toDate=""  s toDate=+$h
	 s today=+$h
	 s:StaTime'="" StaTime=$zth(StaTime,2)
	 s:EndTime'="" EndTime=$zth(EndTime,2)
 	 s num=0
 	 k ^TMP("web.DHCEmPatChkRList","SearchRent",repid,num)
 	 s res=0
     f Date=fromDate:1:toDate  d 
     .s rentTime=""
     .f  s rentTime=$o(^DHCEMPCRi(0,"rentDate",Date,rentTime))   Q:rentTime=""  D
     ..s rentRowId=""
     ..f  s rentRowId=$o(^DHCEMPCRi(0,"rentDate",Date,rentTime,rentRowId))  Q:rentRowId=""  D 
     ...q:(fromDate=Date)&(rentTime'="")&(StaTime'="")&(StaTime>rentTime) 
     ...q:(toDate=Date)&(rentTime'="")&(EndTime'="")&(EndTime<rentTime)
	 ...s PCRRentDr=$p(^DHCEMPCR(rentRowId),"^",1)
	 ...s PCRRentDesc=$p(^DHCEMRL(PCRRentDr),"^",2)
	 ...s RLHospDr=$p(^DHCEMPCR(rentRowId),"^",16)
	 ...q:RLHospDr'=Hosp
	 ...s PCRFlag=$p(^DHCEMPCR(rentRowId),"^",2)
	 ...q:(RentStatus'="")&&( RentStatus'= PCRFlag)
#;	 ...i PCRFlag=1   s PCRFlag="租"
#;	 ...i PCRFlag=2   s PCRFlag="还"
	 ...s Date=$p(^DHCEMPCR(rentRowId),"^",3)
	 ...s PCRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(Date) //hxy $zd(Date,3)
	 ...s Time=$p(^DHCEMPCR(rentRowId),"^",4)
	 ...s PCRTime=$zt(Time,2)
	 ...s PCROperator=$p(^DHCEMPCR(rentRowId),"^",5)
	 ...s PCRRenter=$p(^DHCEMPCR(rentRowId),"^",6)
	 ...q:(Renter'="")&&( PCRRenter'= Renter)
	 ...s PCRRenterTel=$p(^DHCEMPCR(rentRowId),"^",7)
	 ...s PCRCardType=$p(^DHCEMPCR(rentRowId),"^",8)
	 ...s PCRCardType=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patRentList.csp",PCRCardType) //hxy 2022-11-30
	 ...s PCRCash=$p(^DHCEMPCR(rentRowId),"^",9)
	 ...s PCRCashNo=$p(^DHCEMPCR(rentRowId),"^",10)
	 ...s PCRGiveUser=$p(^DHCEMPCR(rentRowId),"^",11)
	 ...s PCRGiveRelation=$p(^DHCEMPCR(rentRowId),"^",12)
     ...s GiveDate=$p(^DHCEMPCR(rentRowId),"^",13)
     ...i GiveDate="" s PCRGiveDate=""
     ...e  s PCRGiveDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(GiveDate) //hxy $zd(GiveDate,3)
     ...s GiveTime=$p(^DHCEMPCR(rentRowId),"^",14)
     ...i GiveTime="" s PCRGiveTime=""
     ...e  s PCRGiveTime=$zt(GiveTime,2) 
     ...s PCRGiveOpUser=$p(^DHCEMPCR(rentRowId),"^",15)
     ...s PCROperator=##class(web.DHCEMConsultCom).GetTransDesc("User.SSUser","SSUSRName","",PCROperator)
     ...s PCRGiveOpUser=##class(web.DHCEMConsultCom).GetTransDesc("User.SSUser","SSUSRName","",PCRGiveOpUser)
     ...s PCRRentDesc=##class(web.DHCEMConsultCom).GetTransDesc("User.DHCEmRentList","RLDesc","",PCRRentDesc)
	 ...s num=num+1
	 ...s TempStr=num_"^"_PCRRentDesc_"^"_PCRFlag_"^"_PCRDate_"^"_PCRTime_"^"_PCROperator_"^"_PCRRenter_"^"_PCRRenterTel_"^"_PCRCardType_"^"_PCRCash_"^"_PCRCashNo_"^"_PCRGiveUser_"^"_PCRGiveRelation_"^"_rentRowId_"^"_PCRRentDr_"^"_PCRGiveDate_"^"_PCRGiveTime_"^"_PCRGiveOpUser
	 ...s ^TMP("web.DHCEmPatChkRList","SearchRent",repid,num)=TempStr 
	 ...S count=count+1
	 ...Q:count<Start
	 ...Q:count>End
	 ...W $case(count,Start:"",:",") 
     ...W ##class(web.DHCAPPJsonCommon).getJsonData("num^PCRRentDesc^PCRFlag^PCRDate^PCRTime^PCROperator^PCRRenter^PCRRenterTel^PCRCardType^PCRCash^PCRCashNo^PCRGiveUser^PCRGiveRelation^rentRowId^PCRRentDr^PCRGiveDate^PCRGiveTime^PCRGiveOpUser",TempStr)
     ..
     .
     w "],""total"":"_count_"}"
     q ""
}

/// w ##class(web.DHCEmPatChkRList).GetParams(1)
ClassMethod GetParams(Params)
{
	n (Params,%session)
	s UserId =  $p(Params,"^",1)
	s DateFormat = ##class(web.DHCEMCommonUtil).DateFormat()
	s UserName = $p(^SSU("SSUSR",UserId),"^",2)
	s UserName=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",UserName)
	q DateFormat_"^"_UserName
}

}
