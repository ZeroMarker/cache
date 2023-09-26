Import SQlUser

Class web.DHCCRM.FUSubject Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 判断子问卷是不是已随访
ClassMethod GroupFlag(FUP)
{
    
    s adm=$p(^DHCCRMFUP(FUP),"^",1)
    s parbject=$p(^DHCCRMFUP(FUP),"^",2)
    s pid=0,followup="0",CRMDate=""
    f  s pid=$o(^DHCCRMFUP(0,"FUP_PAADM",adm,pid)) q:pid=""  d
    .s bject=$p(^DHCCRMFUP(pid),"^",2)
    .s parent=$p(^DHCCRMFUS(bject),"^",9)
    .q:(bject'=parbject)&&(parent="") //没有子主题的就是本主题
    .q:(parent'=parbject)&&(parent'="") //只看本主题的子主题
    .s qrrowid=$o(^DHCCRMQR(0,"QR_FUP_DR",pid,0))
    .i qrrowid'=""  d 
    ..s followup="1"
    q followup
}

ClassMethod DeleteFupById(FupNo)
{
    s SQLCODE=0
    q:$d(^DHCCRMQR(0,"QR_FUP_DR",FupNo)) 1
    q:..GroupFlag(FupNo) 1
    &sql(Delete DHC_CRM_FUPlan where FUP_RowId=:FupNo)
    q SQLCODE
}

ClassMethod SetLinkFlag(fupid, num, reason)
{
	s SQLCODE=0
	s reason=reason_"@"_$zdt($h,3)
    s UpdateUser=%session.Get("LOGON.USERID")
    &sql(update DHC_CRM_FUPlan (FUP_ContactNum,FUP_ContactDesc,FUP_UpdateUser_DR) values (:num,:reason,:UpdateUser) where FUP_RowId=:fupid)
	
	q SQLCODE
}

ClassMethod SetLinkInfo(fupid, info)
{
	s SQLCODE=0
	
	&sql(update DHC_CRM_FUPlan (FUP_ContactInfo) values (:info) where FUP_RowId=:fupid)
	
	q SQLCODE
}

ClassMethod GetLinkNum(FupNo)
{
	q:FupNo="" 0
	s ret=""
	s LinkNum=$p(^DHCCRMFUP(FupNo),"^",7)
	s LinkReason=$p(^DHCCRMFUP(FupNo),"^",9)
	q +LinkNum_"^"_LinkReason
}

ClassMethod SetDeadFlag(Flag, FupNo)
{
	s SQLCODE=0
	i Flag="1" d
	.&sql(update DHC_CRM_FUPlan set FUP_DeadFlag='Y' where FUP_RowId=:FupNo)
	e  d
	.&sql(update DHC_CRM_FUPlan set FUP_DeadFlag='N' where FUP_RowId=:FupNo)
	q SQLCODE
}

ClassMethod DetailIsChecked(SSID, RecordID, FUPRowId)
{
	n (SSID,RecordID,FUPRowId)
	
	s SID=+SSID
	s DID=$p(SSID,"||",2)
	s SSub=$p(SSID,"||",3)
	s Desc=$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",1)
	i RecordID="" q $p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",3)
	;i RecordID="" s valuestr=..GetOldResult(FUPRowId,SID_"||"_DID),value=$p(valuestr,"^",1)  //q $p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",3)
	e  d
	.s Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR",SID_"||"_DID,RecordID,0))
	.q:Sub="" 
	.s value=$p(^DHCCRMQR(RecordID,"Detail",Sub),"^",3)
	s value=$p(value,"@")
	s value="$"_value_"$"
	s Desc="$"_Desc_"$"
	q:$L(value,Desc)>1 "Y"
	
	q "N"
}

/// w ##class(web.DHCCRM.FUSubject).GetBeiZhu("1||5||1",5)
ClassMethod GetBeiZhu(SSID, RecordID)
{
	n (SSID,RecordID)
	s SID=+SSID
	s DID=$p(SSID,"||",2)
	s SSub=$p(SSID,"||",3)
	i RecordID="" q $p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",3)
	s Desc=$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",1)
	s Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR",SID_"||"_DID,RecordID,0))
	q:Sub="" $p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",3)
	s value=$p(^DHCCRMQR(RecordID,"Detail",Sub),"^",3)
	s Template=$p(^DHCCRMQR(RecordID,"Detail",Sub),"^",4)
	s value=$p(value,"@")
	s tmpstr=$p(value,Desc,1)
	s num=$l(tmpstr,"$")
	b
	q $p(Template,"$",num)
}

ClassMethod FUSave(saveInfo)
{
 
	n (saveInfo)
	s Job=$J
	k ^TempDHCCRM(Job,"FUSave")
	s mainInfo=$p(saveInfo,"$",1)
	s PlanID=$p(mainInfo,"^",2)
	s OldID=+mainInfo
	s saveInfo=$p(saveInfo,"$",2)
	if (saveInfo="")  q 0
	s InfoLength=$L(saveInfo,"&")
	s SQLCODE=0
	
	For i = 1:1:InfoLength 
	{
		s OneInfo=$p(saveInfo,"&",i)
		s DetailID=$p(OneInfo,"^",1)
		s DetailID=$p(DetailID,"||",1,2)
		s Result=$p(OneInfo,"^",2)
		s TemplateDesc=$p(OneInfo,"^",3)
		s Sort=$p(^DHCCRMFUS(+DetailID,"SD",$p(DetailID,"||",2)),"^",11)
		i Sort="" s Sort="99999999999"
		i $G(^TempDHCCRM(Job,"FUSave",Sort,DetailID,"Result"))="" d
		.s ^TempDHCCRM(Job,"FUSave",Sort,DetailID,"Result")=Result
		.s ^TempDHCCRM(Job,"FUSave",Sort,DetailID,"TemplateDesc")=TemplateDesc
		e  d
		.s ^TempDHCCRM(Job,"FUSave",Sort,DetailID,"Result")=$G(^TempDHCCRM(Job,"FUSave",Sort,DetailID,"Result"))_"$"_Result
		.s ^TempDHCCRM(Job,"FUSave",Sort,DetailID,"TemplateDesc")=$G(^TempDHCCRM(Job,"FUSave",Sort,DetailID,"TemplateDesc"))_"$"_TemplateDesc
	}
	i $p(mainInfo,"^",3)'=""  d
	.
	TSTART
	i OldID=0
	{
		s PLIST(2)=PlanID
		s PLIST(3)=$p(mainInfo,"^",3) //PAADM
		s PLIST(4)=$p(mainInfo,"^",4) //PAPMI
		s PLIST(5)="Hang"
		s PLIST(6)=+$H
		s PLIST(7)=$p($H,",",2)
		s PLIST(8)=$p(mainInfo,"^",5) //User
		s PLIST(9)=$p(mainInfo,"^",6) //Demo
		&SQL(Insert Into DHC_CRM_QRecord values :PLIST())
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"main"
		}
		s OldID=%ROWID
	}
	s Sort=0
	f  s Sort=$o(^TempDHCCRM(Job,"FUSave",Sort)) q:(Sort="")||(SQLCODE'=0)  d 
	.s DetailID=""
	.f  s DetailID=$o(^TempDHCCRM(Job,"FUSave",Sort,DetailID)) q:(DetailID="")||(SQLCODE'=0)  d
	..k PLIST
	..s PLIST(3)=+DetailID
	..s PLIST(4)=DetailID
	..s PLIST(5)=$G(^TempDHCCRM(Job,"FUSave",Sort,DetailID,"Result"))
	..s PLIST(6)=$G(^TempDHCCRM(Job,"FUSave",Sort,DetailID,"TemplateDesc"))
	..s PLIST(7)=+$H
	..s PLIST(8)=$p($h,",",2)
	..//s PLIST(9)=$p(mainInfo,"^",5)
	..s PLIST(10)=PlanID
	..s Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR",DetailID,OldID,0))
	..i Sub>0 d
	...s QRDRowID=OldID_"||"_Sub
	...&SQL(Update DHC_CRM_QRecordDetail values :PLIST() where QRD_RowId=:QRDRowID)
	..e  d
	...s PLIST(0)=OldID
	...&SQL(Insert Into DHC_CRM_QRecordDetail values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"Detail^"_OldID
	}
	TCOMMIT
	q OldID
}

/// w ##class(web.DHCCRM.FUSubject).GetOldResult()
ClassMethod GetOldResult(PlanID, ID)
{
	q:PlanID="" ""
	s PAADM=$p(^DHCCRMFUP(PlanID),"^",1)
	s Subject=$p(^DHCCRMFUP(PlanID),"^",2)
	
	s OldPlanID=$o(^DHCCRMFUP(0,"FUP_PAADMSubject_DR",PAADM,Subject,PlanID),-1)
	q:OldPlanID="" ""
	s QRId=$o(^DHCCRMQR(0,"QR_FUP_DR",OldPlanID,0))
	q:QRId="" ""
	s sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR",ID,QRId,0))
	s Value=$p(^DHCCRMQR(QRId,"Detail",sub),"^",3)
	s TValue=$p(^DHCCRMQR(QRId,"Detail",sub),"^",4)
	q Value_"^"_TValue
}

ClassMethod GetDetailBySubject(SID, RecordID As %String = "", PlanID As %String = "")
{
	//q "1&detail1&细项1&1&cm&填写1&Y^2&detail2&细项2&2&KG&填写2&N^3&detail3&细项3&2&mmhg&填写3&Y^4&detail4&细项4&4&mmhg&填写2&Y"

	n (SID,RecordID,PlanID)
	s rStr="",i=1,j=1
	q:SID="" rStr
	
	i RecordID="" d
	.s Sequence=0
	.f  s Sequence=$o(^DHCCRMFUS(0,"SD_Sequence",SID,Sequence)) q:Sequence=""  d
	..s DID=0
	..f  s DID=$o(^DHCCRMFUS(0,"SD_Sequence",SID,Sequence,DID)) q:DID=""  d
	...q:'$d(^DHCCRMFUS(SID,"SD",DID))
	...s Active=$p(^DHCCRMFUS(SID,"SD",DID),"^",7)
	...q:Active="N"
	...s BeginDate=$p(^DHCCRMFUS(SID,"SD",DID),"^",8)
	...q:(BeginDate'="")&&(BeginDate>+$H)
	...s EndDate=$p(^DHCCRMFUS(SID,"SD",DID),"^",9)
	...q:(EndDate'="")&&(EndDate<+$H)
	...s ID=SID_"||"_DID
	...s Code=$p(^DHCCRMFUS(SID,"SD",DID),"^",1)
	...s Desc=$p(^DHCCRMFUS(SID,"SD",DID),"^",2)
	...s Type=$p(^DHCCRMFUS(SID,"SD",DID),"^",3)
	...q:((Type="S")&&($o(^DHCCRMFUS(SID,"SD",DID,"SDS",0))=""))
	...s Unit=$p(^DHCCRMFUS(SID,"SD",DID),"^",4)
	...s Explain=$p(^DHCCRMFUS(SID,"SD",DID),"^",5)
	...s Sex=$p(^DHCCRMFUS(SID,"SD",DID),"^",6) //男M 女F 不限N
	...s Required=$p(^DHCCRMFUS(SID,"SD",DID),"^",10)
	...s ParentDr=$p(^DHCCRMFUS(SID,"SD",DID),"^",12)
	...s ElementNum=+$p(^DHCCRMFUS(SID,"SD",DID),"^",14)
	...s Hidden="N"
	...s:..ISRelated(Code,SID) Hidden="Y"
	...s PAADM=$p(^DHCCRMFUP(PlanID),"^",1)
	...s PAPMI=$p(^PAADM(PAADM),"^",1)
	...s SexDr=$p(^PAPER(PAPMI,"ALL"),"^",7)
	...s SexCode=$p(^CT("SEX",SexDr),"^",1) //男1 女2 
	...i SexCode="1" s SexCode="M"
	...i SexCode="2" s SexCode="F"
	...q:(Sex'="N")&&(Sex'=SexCode)
	...s ValueStr=..GetOldResult(PlanID,ID)
	...s Value=$p(ValueStr,"^",1)
	...s TValue=$p(ValueStr,"^",2)
	...s OneStr=ID_"&"_Code_"&"_Desc_"&"_Type_"&"_Unit_"&"_Explain_"&"_Required_"&"_Value_"&"_ElementNum_"&"_Hidden_"&"_TValue_"&"_ParentDr
	...i rStr="" d
	....s rStr=OneStr
	...e  d
	....s rStr=rStr_"^"_OneStr
	...s i=i+1
	e  d
	.s sub=0
	.s HandFlag=0
	.f  s sub=$o(^DHCCRMQR(0,"QRD_Subject_DR",SID,RecordID,sub)) q:sub=""  d
	..s HandFlag=1
	..s ID=$p(^DHCCRMQR(RecordID,"Detail",sub),"^",2)
	..s DID=$p(ID,"||",2)
	..q:'$d(^DHCCRMFUS(SID,"SD",DID))
	..s Code=$p(^DHCCRMFUS(SID,"SD",DID),"^",1)
	..s Desc=$p(^DHCCRMFUS(SID,"SD",DID),"^",2)
	..s Type=$p(^DHCCRMFUS(SID,"SD",DID),"^",3)
	..//q:((Type="S")&&($o(^DHCCRMFUS(SID,"SD",DID,"SDS",0))=""))
	..s Unit=$p(^DHCCRMFUS(SID,"SD",DID),"^",4)
	..s Explain=$p(^DHCCRMFUS(SID,"SD",DID),"^",5)
	..s Required=$p(^DHCCRMFUS(SID,"SD",DID),"^",10)
	..s ParentDr=$p(^DHCCRMFUS(SID,"SD",DID),"^",12)
	..s ElementNum=+$p(^DHCCRMFUS(SID,"SD",DID),"^",14)
	..s Value=$p(^DHCCRMQR(RecordID,"Detail",sub),"^",3)
	..s TValue=$p(^DHCCRMQR(RecordID,"Detail",sub),"^",4)
	..s OneStr=ID_"&"_Code_"&"_Desc_"&"_Type_"&"_Unit_"&"_Explain_"&"_Required_"&"_Value_"&"_ElementNum_"&"_"N"_"&"_TValue_"&"_ParentDr
	..i rStr="" d
	...s rStr=OneStr
	..e  d
	...s rStr=rStr_"^"_OneStr
	..s j=j+1
	.i HandFlag=0 d
	..s rStr=..GetDetailBySubject(SID,"")
	
	q rStr
}

/// w ##class(web.DHCCRM.FUSubject).ISRelated(1003,1)
ClassMethod ISRelated(Code, fus)
{
	s RelateFlag=0
	s fusd=0
	f  s fusd=$o(^DHCCRMFUS(fus,"SD",fusd)) q:fusd=""  d
	.s fusds=0
	.f  s fusds=$o(^DHCCRMFUS(fus,"SD",fusd,"SDS",fusds)) q:fusds=""  d
	..s fusdst=0
	..s DefaltC=$p(^DHCCRMFUS(fus,"SD",fusd,"SDS",fusds),"^",3)
	..f  s fusdst=$o(^DHCCRMFUS(fus,"SD",fusd,"SDS",fusds,"SDST",fusdst)) q:fusdst=""  d
	...s Relate=$p(^DHCCRMFUS(fus,"SD",fusd,"SDS",fusds,"SDST",fusdst),"^",1)
	...i (Relate=Code)&&(DefaltC="N")  s RelateFlag=1
	q RelateFlag
}

ClassMethod GetIPAndName() As %String
{
	Set IPAddress=$ZUTIL(67,15,$JOB)
	Set CompName=$ZUTIL(67,12,$JOB)
	//s IPAddress="10.10.141.107"
	Quit IPAddress_"^"_CompName
}

ClassMethod GetRecord(FUPlanID) As %String
{
 s RecordID=""
 s RecordID=$o(^DHCCRMQR(0,"QR_FUP_DR",FUPlanID,0))
 Q RecordID
}

//w ##class(web.DHCCRM.FUSubject).GetMRecord("","","","")

ClassMethod GetMRecord(Name, BDate, EDate, Type As %Library.String = "1", UserID)
{
   
	n (Name,BDate,EDate,Type,UserID)
	s jsonStr=""
	Set rset = ##class(%ResultSet).%New()
	Set rset.ClassName = "web.DHCCRM.FUSubject"
	Set rset.QueryName = "SearchPRecord"
	Do rset.Execute(BDate,EDate,Name,Type,UserID)
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="RowID^RegNo^Name^Date^Demo"
	s count=0
	While (rset.Next()) 
 {
	    s RowID=rset.Data("TRowID")
	    s Name=rset.Data("TName")
	    s Date=rset.Data("TDate")
	    s Demo=rset.Data("TDemo")
	    s RegNo=rset.Data("TRegNo")
	    s tmp=RowID_"^"_RegNo_"^"_Name_"^"_Date_"^"_Demo
	    d json.InsertRowData(tmp)
	    s count=count+1
 }
 d rset.Close()
	s jsonStr = json.getJsonData(jsonTitle,count)
 k json

	q jsonStr
}

ClassMethod GetPatientInfo(RegNo, Type As %Library.String = "")
{
	n (RegNo,Type)
	s ID=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	q:ID="" "^"_RegNo_"^^"
	s Name=$p($G(^PAPER(ID,"ALL")),"^",1)
	s CardID=$p($G(^PAPER(ID,"ALL")),"^",9)
	i Type'="" d
	.s PAADM=$o(^PAPERdr(ID,"ADM",Type,""),-1)
	e  d
	.s PAADM=""
	.s Type=""
	.f  s Type=$o(^PAPERdr(ID,"ADM",Type)) q:Type=""  d
	..s ADM=0
	..f  s ADM=$o(^PAPERdr(ID,"ADM",Type,ADM)) q:ADM=""  d
	..i ADM>+PAADM d
	...s PAADM=ADM
	q ID_"^"_RegNo_"^"_Name_"^"_CardID_"^"_PAADM
}

ClassMethod GetSelectByDetail(DetailID, RecordID As %String = "", FUPRowId As %String = "")
{
	//q "1&选择1^2&选择2^3&选择3"
	
	n (DetailID,RecordID,FUPRowId)
	s rStr=""
	q:DetailID="" ""
	s SID=+DetailID
	s DID=$p(DetailID,"||",2)
	s Sequence=0
	f  s Sequence=$o(^DHCCRMFUS(0,"SDS_Sequence",SID,DID,Sequence)) q:Sequence=""  d
	.s SSub=0
	.f  s SSub=$o(^DHCCRMFUS(0,"SDS_Sequence",SID,DID,Sequence,SSub)) q:SSub=""  d
	..s SSID=DetailID_"||"_SSub
	..s Desc=$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",1)
	..s Default=..DetailIsChecked(SSID,RecordID,FUPRowId)
	..s DVlaue=..GetBeiZhu(SSID,RecordID)
	..i DVlaue'="" s DVlaue=$p(DVlaue,"@",2)
	..s Unit=$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",2)
	..s AddDesc=$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",5)
	..s OneStr=SSID_"&"_Desc_"&"_Default_"&"_Unit_"&"_AddDesc_"&"_DVlaue
	..i rStr="" d
	...s rStr=OneStr
	..e  d
	...s rStr=rStr_"^"_OneStr
	q rStr
}

//w ##class(web.DHCCRM.FUSubject).GetSubjectByIP(3,1)

ClassMethod GetSubjectByIP(RecordID As %String = "", PlanID As %String = "")
{
	n (RecordID,PlanID)
	//q "1&zt1&主题1^2&zt2&主题2^3&zt3&主题3"
	s rStr=""
	i PlanID'=""
	{
		s fusname=$p($g(^DHCCRMFUS(PlanID)),"^",2)
		q PlanID_"&&"_fusname
		
	}
	i RecordID="" d
	.s IP=..GetIPAndName()
	.s IP=$p(IP,"^",1)
	.q:IP=""
	.s IPSID=0
	.f  s IPSID=$o(^DHCCRMIPS(0,"IPS_IP",IP,IPSID)) q:IPSID=""  d
	..s SubjectID=$p(^DHCCRMIPS(IPSID),"^",2)
	..s DateFlag=$p($g(^DHCCRMFUS(SubjectID)),"^",4)
	..s Flag=0
	..i DateFlag="Y" d
	...s BeginDate=$p(^DHCCRMFUS(SubjectID),"^",5)
	...s:(BeginDate'="")&&(BeginDate>+$H) Flag=1
	...s EndDate=$p(^DHCCRMFUS(SubjectID),"^",6)
	...s:(EndDate'="")&&(EndDate<+$H) Flag=1
	..q:Flag=1
	..s Desc=$p(^DHCCRMFUS(SubjectID),"^",2)
	..s Code=$p(^DHCCRMFUS(SubjectID),"^",1)
	..s OneStr=SubjectID_"&"_Code_"&"_Desc
	..i rStr="" d
	...s rStr=OneStr
	..e  d
	...s rStr=rStr_"^"_OneStr
	e  d
	.s sub=0
	.s Job=$j
	.k ^TempCRM(Job,"Subject")
	.f  s sub=$o(^DHCCRMQR(RecordID,"Detail",sub)) q:sub=""  d
	..s Subject=$p(^DHCCRMQR(RecordID,"Detail",sub),"^",1)
	..s ^TempCRM(Job,"Subject",Subject)=""
	.s Subject=""
	.f  s Subject=$o(^TempCRM(Job,"Subject",Subject)) q:Subject=""  d
	..s Desc=$p(^DHCCRMFUS(Subject),"^",2)
	..s Code=$p(^DHCCRMFUS(Subject),"^",1)
	..s OneStr=Subject_"&"_Code_"&"_Desc
	..i rStr="" d
	...s rStr=OneStr
	..e  d
	...s rStr=rStr_"^"_OneStr
	q rStr
}

ClassMethod SaveRecord(mainInfo)
{
	s Path=$G(^DHCCRM("Record","Path"))
	q:Path="" "-1^请先设置保存路径"
	s OldID=+mainInfo
	i OldID=0 d
	.s PLIST(2)=$p(mainInfo,"^",2) //PlanID
	.s PLIST(3)=$p(mainInfo,"^",3) //PAADM
	.s PLIST(4)=$p(mainInfo,"^",4) //PAPMI
	.s PLIST(5)="Hang"
	.s PLIST(6)=+$H
	.s PLIST(7)=$p($H,",",2)
	.s PLIST(8)=$p(mainInfo,"^",5) //User
	.s Path=Path_$ZD(+$H,3)_"/"
	.s PLIST(9)=$p(mainInfo,"^",6) //Demo
	.s PLIST(9)=Path
	.&SQL(Insert Into DHC_CRM_QRecord values :PLIST())
	e  d
	.s Date=$P(^DHCCRMQR(OldID),"^",5)
	.s Path=Path_$ZD(Date,3)_"/"
	.s PLIST(9)=Path
	.&SQL(Update DHC_CRM_QRecord values :PLIST() where QR_RowId=:OldID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^更新表错误"
	}
	s OldID=%ROWID
	q OldID_"^"_Path
}

/// ##class(web.DHCPE.Public.Setting).Replace("1")
ClassMethod Replace(Strings, Str, Rep) As %String
{
	
	q Strings
}

ClassMethod SearchPRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SearchPRecordExecute(ByRef qHandle As %Binary, BeginDate As %String = "", EndDate As %String = "", Name As %String = "", Type As %String = "1", UserID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1

	i BeginDate="" s BeginDate=+$H
	i EndDate="" s EndDate=+$H
	i Name'=""
	{
		d GetOneInfoDetail
	}
	else
	{
		s Date=BeginDate-1
		f  s Date=$O(^DHCCRMQR(0,"QR_UpdateDateTime",Date)) q:(Date="")||(Date>EndDate)  d
		.s time=0
		.f  s time=$O(^DHCCRMQR(0,"QR_UpdateDateTime",Date,time)) q:time=""  d
		..s RowID=0
		..f  s RowID=$O(^DHCCRMQR(0,"QR_UpdateDateTime",Date,time,RowID)) q:RowID=""  d
		...d GetOneInfoDetail
	}
	
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneInfoDetail
	s PAADM=$p($G(^DHCCRMQR(RowID)),"^",2)
	s PAPMIID=$p($G(^DHCCRMQR(RowID)),"^",3)
	i PAADM'="" d
	.s PAPMIID=$p(^PAADM(PAADM),"^",1)
	q:(Type="0")&&(PAADM="")   //满意调查记录退出
	q:(Type'="0")&&(PAADM'="")   //生成计划的记录退出
    i PAPMIID'="" d
	.s Name=$p($G(^PAPER(PAPMIID,"ALL")),"^",1)
	.s RegNo=$p(^PAPER(PAPMIID,"PAT",1),"^",1) //登记号
	s UpdateDate=$ZD(Date,3)
	s Demo=$p(^DHCCRMQR(RowID),"^",8)
	s Demo=..Replace(Demo,"\","\\")
	s User=$p(^DHCCRMQR(RowID),"^",7)
	q:(UserID'="")&&(UserID'=User)
	d FindBuildDetail
	q 	
FindBuildDetail      
	set Data=$lb(RowID,RegNo,Name,UpdateDate,Demo)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 q
}

ClassMethod SearchPRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPRecordExecute ]
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

Query SearchPRecord(BeginDate As %String = "", EndDate As %String = "", Name As %String = "", Type As %String = "1", UserID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRegNo:%String,TName:%String,TDate:%String,TDemo:%String")
{
}

Storage Default
{
<Data name="FUSubjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCRM.FUSubjectD</DataLocation>
<DefaultData>FUSubjectDefaultData</DefaultData>
<IdLocation>^web.DHCCRM.FUSubjectD</IdLocation>
<IndexLocation>^web.DHCCRM.FUSubjectI</IndexLocation>
<StreamLocation>^web.DHCCRM.FUSubjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
