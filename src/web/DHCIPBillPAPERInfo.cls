/// Creator: chenxi
/// CreateDate: 2013-03-15
/// Description: 病人基本信息查找
Class web.DHCIPBillPAPERInfo Extends BILL.COM.Abstract
{

/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillPAPERInfo","CheckPatInfo", "0000000729","测试07","2","","1967-04-01","")
Query CheckPatInfo(PAPERNo As %String, PAPERName As %String, SexID As %String, PAPERID As %String, BirthDate As %String, InsuNo As %String, HospId As %String, LangId As %String = "") As websys.Query(ROWSPEC = "TPAPERNo:%String:登记号,TPAPERName:%String:患者姓名,TSex:%String:性别,TPAPERDob:%String:出生日期,TPAPERID:%String:身份证号,TAddress:%String:住址,TMrNo:%String:病案号,TCompany:%String:工作单位,TTelephone:%String:联系电话,TMobile:%String:手机号,TWorkTel:%String:工作电话,TForeignId:%String:联系人,TTForeignTel:%String:联系人电话,TInsuNo:%String:医保手册号")
{
}

ClassMethod CheckPatInfoExecute(ByRef qHandle As %Binary, PAPERNo As %String, PAPERName As %String, SexID As %String, PAPERID As %String, BirthDate As %String, InsuNo As %String, HospId As %String, LangId As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
   	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("CheckPatInfo")=$lb(PAPERNo, PAPERName, SexID, PAPERID, BirthDate, InsuNo, HospId, LangId)
 	
 	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	set BirthDate=##class(websys.Conversions).DateHtmlToLogical(BirthDate)
	
	kill PatIdAry
 	if (PAPERNo'="") {
		set PAPERNo=##class(web.UDHCJFBaseCommon).regnocon(PAPERNo)
		set PAPERDR=$o(^PAPERi("PAPMI_PatNo",PAPERNo,""),-1)
		if (PAPERDR'="") {
			set PatIdAry(PAPERDR)=""
		}
	}elseif (PAPERID'="") {
 		set PAPERID1=$$ALPHAUP^SSUTIL4(PAPERID)_"Z"
 		set PAPERDR=0
 		while($o(^PAPERi("PAPMI_ICPPBC",PAPERID1,PAPERDR))) {
	 		set PAPERDR=$o(^PAPERi("PAPMI_ICPPBC",PAPERID1,PAPERDR))
	 		set PatIdAry(PAPERDR)=""
	 	}
	}elseif (InsuNo'="") {
		set InsuNo=$$ALPHAUP^SSUTIL4(InsuNo)
		set PAPERDR=0
		while($o(^PAPERi("PAPER_HFundNo",InsuNo,PAPERDR))) {
			set PAPERDR=$o(^PAPERi("PAPER_HFundNo",InsuNo,PAPERDR))
			set PatIdAry(PAPERDR)=""
		}
	}elseif (PAPERName'="") {
		do ##class(BILL.COM.PAPatMas).GetPatientByName(PAPERName, .PatIdAry)
	}
 	
 	set PAPERDR=0
 	while($o(PatIdAry(PAPERDR))) {
	 	set PAPERDR=$o(PatIdAry(PAPERDR))
	 	do GetPatInfo(PAPERDR, SexID, BirthDate)
	}
	
	quit $$$OK
	
GetPatInfo(PAPERDR, SexID, BirthDate)
	set TPAPERNo=$p(^PAPER(PAPERDR,"PAT",1),"^",1)
	set TPAPERName=$p(^PAPER(PAPERDR,"ALL"),"^",1)
	set TInsuNo=$p(^PAPER(PAPERDR,"PAT",3),"^",12)
	set SexDR=$p($g(^PAPER(PAPERDR,"ALL")),"^",7)
	quit:((SexID'="")&&(SexDR'=SexID))       //判断性别
	set Sex=$s((+SexDR'=0):$p($g(^CT("SEX",SexDR)),"^",2),1:"")
	set Sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", Sex, LangId)
	set TPAPERID=$p(^PAPER(PAPERDR,"ALL"),"^",9)
	set PAPERDob=$p($g(^PAPER(PAPERDR,"ALL")),"^",6)
	quit:((BirthDate'="")&&(PAPERDob'=BirthDate))
	set PAPERDob=##class(websys.Conversions).DateLogicalToHtml(PAPERDob)
	set ForeignId=$p($g(^PAPER(PAPERDR,"PER",2)),"^",13)
	set MrNo=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PAPERDR, "I", HospId, "")
	set WorkTel=$p($g(^PAPER(PAPERDR,"PER",1)),"^",9)
	set Telephone=$p($g(^PAPER(PAPERDR,"PER",1)),"^",11)
	set Address=$g(^PAPER(PAPERDR,"PER","ADD",1))
	set Mobile=$p($g(^PAPER(PAPERDR,"PER",4)),"^",21)
	set Company=$p($g(^PAPER(PAPERDR,"PER",4)),"^",18)
	set ForeignTel=$p($g(^PAPER(PAPERDR,"ALL")),"^",4)
	do OutputPatInfo
	quit
OutputPatInfo
	set Data=$lb(TPAPERNo,TPAPERName,Sex,PAPERDob,TPAPERID,Address,MrNo,Company,Telephone,Mobile,WorkTel,ForeignId,ForeignTel,TInsuNo)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: chenxi
/// CreateDate: 2013-03-15
/// Description: 根据病人姓名、性别、出生日期、身份证判断系统只是否有此病人
ClassMethod CheckPatNum(PatInfo)
{
	quit:(PatInfo="") 0
	set PAPERName=$p(PatInfo,"^",1)
	set PAPERSexDr=$p(PatInfo,"^",2)
	set PAPERDob=$p(PatInfo,"^",3)
	set PAPERID=$p(PatInfo,"^",4)
	set Insuno=$p(PatInfo,"^",5)
	
	quit:((PAPERName="")&&(PAPERID="")) 0
	
	set PAPERName=$$ALPHAUP^SSUTIL4(PAPERName)
	if (PAPERID'="") {
		set PAPERID=$$ALPHAUP^SSUTIL4(PAPERID)
		set PAPERID=PAPERID_"Z"
	}
	
	if (Insuno'="") {
		set Insuno=$$ALPHAUP^SSUTIL4(Insuno)
	}
	if ($f(PAPERDob,"-")'=0) {
		set PAPERDob=$zdh(PAPERDob,3)
	}
	if ($f(PAPERDob,"/")'=0) {
		set PAPERDob=$zdh(PAPERDob,4)
	}
	set PAPERNum=0
	if (PAPERID'="")  do
	.set PAPERRowid=0
	.for  set PAPERRowid=$o(^PAPERi("PAPMI_ICPPBC",PAPERID,PAPERRowid))  quit:(PAPERRowid="")  do
	..set PAPERNum=$i(PAPERNum)
	else  do
	.if ((PAPERName'="")&&(PAPERDob'="")&&(PAPERSexDr'=""))  do
	..set PAPERRowid=0
	..for  set PAPERRowid=$o(^PAPERi("PAPER_PatName",PAPERName,PAPERRowid))  quit:(PAPERRowid="")  do
	...set OldPAPERSexDr=$p(^PAPER(PAPERRowid,"ALL"),"^",7)
	...set OldPAPERID=$p(^PAPER(PAPERRowid,"ALL"),"^",9)
	...set OldPAPERDob=$p(^PAPER(PAPERRowid,"ALL"),"^",6)
	...set OldInsuno=$p(^PAPER(PAPERRowid,"ALL"),"^",19)
	...quit:(PAPERSexDr'="")&&(OldPAPERSexDr'=PAPERSexDr)
	...quit:(PAPERDob'="")&&(OldPAPERDob'=PAPERDob)
	...//quit:(PAPERID'="")&&(PAPERID'=OldPAPERID)
	...quit:(Insuno'=OldInsuno)&&(Insuno'="")
	...set PAPERNum=$i(PAPERNum)
	
	quit PAPERNum
}

/// Creator: chenxi
/// CreateDate: 2013-03-15
/// Description: 根据病人姓名、性别、出生日期、身份证判断系统只是否有此病人
ClassMethod GetPatRegNo(InsuNo, PAPERID)
{
	quit:((InsuNo="")&&(PAPERID="")) "PatNull"
	if (InsuNo'="") {
		set InsuNo=$$ALPHAUP^SSUTIL4(InsuNo)
	}
	if (PAPERID'="") {
		set PAPERID=$$ALPHAUP^SSUTIL4(PAPERID)
	}
	set PAPERNo=""
	set PAPERRowid=""
	if (PAPERID'="") {
		set PAPERID1=PAPERID_"Z"
		set PAPERRowid=$o(^PAPERi("PAPMI_ICPPBC",PAPERID1,PAPERRowid),-1)
	}elseif (InsuNo'="") {
		set PAPERRowid=$o(^PAPERi("PAPER_YBCode",InsuNo,PAPERRowid),-1)
	}
	if (PAPERRowid'="") {
		set PAPERNo=$p(^PAPER(PAPERRowid,"PAT",1),"^",1)
		set PAPERNo=##class(web.UDHCJFBaseCommon).regnocon(PAPERNo)
	}
    quit PAPERNo
}

}
