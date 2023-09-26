Import SQLUser

Class web.UDHCJFQFPATIENT Extends BILL.COM.Abstract
{

/// Description: 欠费患者查询
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFQFPATIENT","QryArrPatList","2021-12-27","2021-12-27","-1","A","","","","2")
Query QryArrPatList(stDate As %String, endDate As %String, arrearsFlag As %String, admStatus As %String, deptId As %String, wardId As %String, insTypeId As %String, sessionStr As %String) As websys.Query(ROWSPEC = "regNo:%String:登记号,mrNo:%String:病案号,patName:%String:患者姓名,sex:%String:性别,age:%String:年龄,IDNo:%String:身份证号,bedNo:%String:床号,mainDoctor:%String:主管医生,mainNurse:%String:主管护士,insType:%String:费别,dept:%String:科室,ward:%String:病区,admDate:%String:入院日期,admTime:%String:入院时间,dischDate:%String:出院日期,dischTime:%String:出院时间,amount:%Float:费用,deposit:%Float:押金,balance:%Float:余额,arrearsRate:%String: 欠费比率,admStatus:%String:就诊状态,homeAddress:%String:家庭住址,telNo:%String:联系电话,adm:%String:就诊ID,arrFlag:%String,arrUser:%String,arrDate:%String,arrTime:%String,foreignName:%String:联系人姓名,foreignPhone:%String:联系人电话") [ SqlProc ]
{
}

ClassMethod QryArrPatListExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, arrearsFlag As %String, admStatus As %String, deptId As %String, wardId As %String, insTypeId As %String, sessionStr As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
	set ^TMP("QryArrPatList")=$lb(stDate, endDate, arrearsFlag, admStatus, deptId, wardId, insTypeId, sessionStr)
	
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
 	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
 	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)

	set balanceSum=0, amountSum=0, depositSum=0
 	if (admStatus="A") {
	 	set adm=0
	 	while($o(^PAADMi("AdmTypeCurr","I",adm))) {
		 	set adm=$o(^PAADMi("AdmTypeCurr","I",adm))
		 	do GetPatList(adm)
		}
 	}
 	
	if (admStatus="D") {
		for date=stDate:1:endDate {
			set adm=0
			while($o(^PAADMi("DischDate",date,adm))) {
				set adm=$o(^PAADMi("DischDate",date,adm))
				set admType=$p(^PAADM(adm),"^",2)
				continue:(admType'="I")
				do GetPatList(adm)
			}
		}
	}
	
	do InitOutput
    set regNo=##class(websys.Translation).Get("", "合计", langId)
    set amount=$fn(amountSum,"",2)
    set deposit=$fn(depositSum,"",2)
    set balance=$fn(balanceSum,"",2)
 	do OutputArrPatList

	quit $$$OK
   
GetPatList(adm)
	set locDR=$p(^PAADM(adm),"^",4)
	quit:((deptId'="")&&(deptId'=locDR))
	set dept=$p(^CTLOC(locDR),"^",2)
	set dept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", dept, langId)
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(locDR)
	quit:(hospDR'=hospId)
	set billFlag=$p(^PAADM(adm),"^",45)
	quit:(billFlag="Y")
	set wardDR=$p(^PAADM(adm),"^",70)
	quit:((wardId'="")&&((","_wardId_",")'[(","_wardDR_",")))
	set ward=$s((+wardDR'=0):$p($g(^PAWARD(wardDR)),"^",2),1:"")
	set ward=##class(User.PACWard).GetTranByDesc("WARDDesc", ward, langId)
	set admReaDR=$p(^PAADM(adm,1),"^",7)
	quit:((insTypeId'="")&&(insTypeId'=admReaDR))
	set insType=$s((+admReaDR'=0):$p($g(^PAC("ADMREA",admReaDR)),"^",2),1:"")
	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, langId)
	set papmi=$p(^PAADM(adm),"^",1)
	set patName=$p(^PAPER(papmi,"ALL"),"^",1)
	set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
	//+gongxin 2023-04-19 增加 年龄和地址等字段
	set age=##class(web.DHCBillInterface).GetPapmiAge(papmi, adm)
	set foreignName=$p($g(^PAPER(papmi,"PER",2)),"^",13)     //联系人姓名
	set foreignPhone=$p($g(^PAPER(papmi,"ALL")),"^",4)       //联系人电话
	set homeTel=$p($g(^PAPER(papmi,"PER",1)),"^",11)      //联系电话
	set mobPhone=$p($g(^PAPER(papmi,"PER",4)),"^",21)     //手机号
	set telNo=$s((homeTel=""):mobPhone,1:homeTel_$s((mobPhone'=""):", "_mobPhone,1:""))	
	set homeAddress=$g(^PAPER(papmi,"PER","ADD",1))      //现住址
	set mainNurse=##class(Nur.NIS.Service.Base.BedConfig).GetBasicDataByCode(0, "mainNurse", adm)  //主管护士
    set mainDoctor=##class(Nur.NIS.Service.Base.BedConfig).GetBasicDataByCode(0, "mainDoctor", adm) //主管医生
	set IDNo=$p($g(^PAPER(papmi,"ALL")),"^",9)	 //身份证号
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
	set sexDR=$p(^PAPER(papmi,"ALL"),"^",7)
	set sex=$s((+sexDR'=0):$p($g(^CT("SEX",sexDR)),"^",2),1:"")
	set sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", sex, langId)
	set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(adm, langId)
	set status=$p(admInOutDateInfo,"^",4)
	set admDate=$p(admInOutDateInfo,"^",5)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set admTime=$p(admInOutDateInfo,"^",6)
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime)
	set dischDate=$p(admInOutDateInfo,"^",7)
	set dischDate=##class(websys.Conversions).DateLogicalToHtml(dischDate)
	set dischTime=$p(admInOutDateInfo,"^",8)
	set dischTime=##class(websys.Conversions).TimeLogicalToHtml(dischTime)
	set bed=##class(web.DHCBillCommon).GetPatBedCode(adm)
	set deposit=##class(web.UDHCJFBaseCommon).deposit(adm)
	set deposit=$fn(deposit,"",2)
    set amount=..getpatshare(adm)
	set amount=$fn(amount,"",2)
	quit:(+amount=0)
	set balance=deposit-amount
	set balance=$fn(balance,"",2)
	quit:((arrearsFlag=-1)&&(+balance>=0))
	quit:((arrearsFlag=1)&&(+balance<=0))
	quit:((arrearsFlag=0)&&(+balance'=0))
	set arrearsRate=$fn((balance/amount*100),"",2)_"%"   //+gongxin 2023-05-17 欠费比率
	set amountSum=$i(amountSum, amount)
    set depositSum=$i(depositSum, deposit)
	set balanceSum=$i(balanceSum, balance)
    set arrFlag="", arrUser="", arrDate="", arrTime=""
    set arrId=$o(^DHCJFUPAdmArrears(0,"Adm",adm,""),-1)
    if (arrId'="") {
	    set arrData=$g(^DHCJFUPAdmArrears(arrId))
	    set isArr=$p(arrData,"^",5)
	    set arrFlag=$case(isArr,1:##class(websys.Translation).Get("", "欠费", langId),:"")
	    set arrUserDR=$p(arrData,"^",4)
	    set arrUser=$s((+arrUserDR'=0):$p($g(^SSU("SSUSR",arrUserDR)),"^",2),1:"")
	    set arrUser=##class(User.SSUser).GetTranByDesc("SSUSRName", arrUser, langId)
	    set arrDate=$p(arrData,"^",2)
		set arrDate=##class(websys.Conversions).DateLogicalToHtml(arrDate)
	    set arrTime=$p(arrData,"^",3)
		set arrTime=##class(websys.Conversions).TimeLogicalToHtml(arrTime)
    }
	do OutputArrPatList
	quit
	
InitOutput
	set bed="", regNo="", patName="", sex="", age="", IDNo="", insType="", mrNo="", dept="", ward="" ,adm=""
 	set status="", admDate="", admTime="", dischDate="", dischTime="", arrFlag="", arrUser="", arrDate="", arrTime=""
 	set amount=0, deposit=0, balance=0, mainNurse="", mainDoctor="", arrearsRate="", foreignName="", foreignPhone=""
 	set IDNo="", telNo=""
	quit
	
OutputArrPatList
	set Data=$lb(regNo,mrNo,patName,sex,age,IDNo,bed,mainDoctor,mainNurse,insType,dept,ward,admDate,admTime,dischDate,dischTime,amount,deposit,balance,arrearsRate,status,homeAddress,telNo,adm,arrFlag,arrUser,arrDate,arrTime,foreignName,foreignPhone)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

ClassMethod getpatshare(adm)
{
	quit:(adm="") 0
	set sum=0
	set pb=0
	while($o(^DHCPB(0,"ADM",adm,pb))) {
		set pb=$o(^DHCPB(0,"ADM",adm,pb))
		set pbData=$g(^DHCPB(pb))
	    set payedflag=$p(pbData,"^",16)
	    continue:(payedflag="P")
		set patshare=$p(pbData,"^",12)
	    set sum=$i(sum, patshare)
	}
	quit $fn(sum,"",2)
}

ClassMethod UpAdmArrears(AdmArrearsinfro As %String)
{
	s AdmArrearsinfro=$g(AdmArrearsinfro)
	q:(AdmArrearsinfro="") ""
	s admdr=$p(AdmArrearsinfro,"^",1)
	s update=+$h
	s uptime=$p($h,",",2)
	s user=$p(AdmArrearsinfro,"^",2)
	s flag=$p(AdmArrearsinfro,"^",3)

	s ArrearsRowid=$o(^DHCJFUPAdmArrears(0,"Adm",admdr,""),-1)
	s Arrearsflag=""
	i (ArrearsRowid'="") {
		s Arrearsflag=$p(^DHCJFUPAdmArrears(ArrearsRowid),"^",5)
	}
	q:(flag=1)&&(Arrearsflag=1) 1
	q:(flag=0)&&(Arrearsflag=0) 2
	
	ts
	
	&SQL(
		INSERT INTO DHC_JFUPAdmArrears (
			UPAA_adm_dr, UPAA_date, UPAA_time, UPAA_user, UPAA_flag
		)
		VALUES (
			:admdr, :update, :uptime, :user, :flag
		)
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-04-15
/// Description: 查询病区
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillOtherLB","QryWard","","2")
Query QryWard(desc As %String, hospId As %String) As websys.Query(ROWSPEC = "id:%String,text:%String,contactName:%String") [ SqlProc ]
{
}

ClassMethod QryWardExecute(ByRef qHandle As %Binary, desc As %String, hospId As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set id=0
	while($o(^PAWARD(id))) {
		set id=$o(^PAWARD(id))
		set data=$g(^PAWARD(id))
		continue:(data="")
		set activeFlag=$p(data,"^",6)
		continue:(activeFlag'="Y")
		set locDR=$p(data,"^",5)
		continue:(+locDR=0)
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", locDR, hospId)
		continue:(showFlag="N")
		set locData=$g(^CTLOC(locDR))
		set wardFlag=$p(locData,"^",5)
		continue:(wardFlag'="Y")
		set locType=$p(locData,"^",13)
		continue:(locType'="W")
		continue:(##class(web.DHCOPAdmReg).CheckLocDesc(locDR, desc)'=1)
		set text=$p(locData,"^",2)
		set text=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", text)
		set contactName=$p(locData,"^",43)
		do OutputWard
	}
	
	quit $$$OK
    
OutputWard
	set Data=$lb(id,text,contactName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-11-18
/// Description: 查询费别
/// Table: PAC_AdmReason
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFQFPATIENT","QryAdmReason","2")
Query QryAdmReason(hospId As %String) As websys.Query(ROWSPEC = "id:%String,text:%String") [ SqlProc ]
{
}

ClassMethod QryAdmReasonExecute(ByRef qHandle As %Binary, hospId As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set today=+$h
	set id=0
	while($o(^PAC("ADMREA",id))) {
		set id=$o(^PAC("ADMREA",id))
		set data=$g(^PAC("ADMREA",id))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("PAC_AdmReason", id, hospId)
		continue:(showFlag="N")
		set dateFrom=$p(data,"^",3)
		set dateTo=$p(data,"^",4)
		continue:((dateFrom'="")&&(dateFrom>today))
		continue:((dateTo'="")&&(dateTo<today))
		set text=$p(data,"^",2)
		set text=##class(User.PACAdmReason).GetTranByDesc("READesc", text)
		set Data=$lb(id,text)
 		set ^CacheTemp(repid,ind)=Data
 		set ind=$i(ind)
	}
 	
	quit $$$OK
}

/// Description: 欠费患者查询
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFQFPATIENT","QryArrPatList","2021-12-27","2021-12-27","-1","A","","","","2")
Query QryArrPatListrpx(stDate As %String, endDate As %String, arrearsFlag As %String, admStatus As %String, deptId As %String, wardId As %String, insTypeId As %String, sessionStr As %String) As websys.Query(ROWSPEC = "regNo:%String:登记号,mrNo:%String:病案号,patName:%String:患者姓名,sex:%String:性别,bedNo:%String:床号,insType:%String:费别,dept:%String:科室,ward:%String:病区,admDate:%String:入院日期,admTime:%String:入院时间,dischDate:%String:出院日期,dischTime:%String:出院时间,amount:%Float:费用,deposit:%Float:押金,balance:%Float:余额,admStatus:%String:就诊状态,adm:%String:就诊ID,arrFlag:%String,arrUser:%String,arrDate:%String,arrTime:%String") [ SqlProc ]
{
}

ClassMethod QryArrPatListrpxExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, arrearsFlag As %String, admStatus As %String, deptId As %String, wardId As %String, insTypeId As %String, sessionStr As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
	set ^TMP("QryArrPatList")=$lb(stDate, endDate, arrearsFlag, admStatus, deptId, wardId, insTypeId, sessionStr)
	
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
 	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
 	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)

	set balanceSum=0, amountSum=0, depositSum=0
 	if (admStatus="A") {
	 	set adm=0
	 	while($o(^PAADMi("AdmTypeCurr","I",adm))) {
		 	set adm=$o(^PAADMi("AdmTypeCurr","I",adm))
		 	do GetPatListrpx(adm)
		}
 	}
 	
	if (admStatus="D") {
		for date=stDate:1:endDate {
			set adm=0
			while($o(^PAADMi("DischDate",date,adm))) {
				set adm=$o(^PAADMi("DischDate",date,adm))
				set admType=$p(^PAADM(adm),"^",2)
				continue:(admType'="I")
				do GetPatListrpx(adm)
			}
		}
	}

	quit $$$OK
   
GetPatListrpx(adm)
	set locDR=$p(^PAADM(adm),"^",4)
	quit:((deptId'="")&&(deptId'=locDR))
	set dept=$p(^CTLOC(locDR),"^",2)
	set dept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", dept, langId)
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(locDR)
	quit:(hospDR'=hospId)
	set billFlag=$p(^PAADM(adm),"^",45)
	quit:(billFlag="Y")
	set wardDR=$p(^PAADM(adm),"^",70)
	
	quit:((wardId'="")&&((","_wardId_",")'[(","_wardDR_",")))
	set ward=$s((+wardDR'=0):$p($g(^PAWARD(wardDR)),"^",2),1:"")
	set ward=##class(User.PACWard).GetTranByDesc("WARDDesc", ward, langId)
	set papmi=$p(^PAADM(adm),"^",1)
	set patName=$p(^PAPER(papmi,"ALL"),"^",1)
	set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
	set sexDR=$p(^PAPER(papmi,"ALL"),"^",7)
	set sex=$s((+sexDR'=0):$p($g(^CT("SEX",sexDR)),"^",2),1:"")
	set sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", sex, langId)
	set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(adm, langId)
	set status=$p(admInOutDateInfo,"^",4)
	set admDate=$p(admInOutDateInfo,"^",5)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set admTime=$p(admInOutDateInfo,"^",6)
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime)
	set dischDate=$p(admInOutDateInfo,"^",7)
	set dischDate=##class(websys.Conversions).DateLogicalToHtml(dischDate)
	set dischTime=$p(admInOutDateInfo,"^",8)
	set dischTime=##class(websys.Conversions).TimeLogicalToHtml(dischTime)
	set bed=##class(web.DHCBillCommon).GetPatBedCode(adm)
	set admReaDR=$p(^PAADM(adm,1),"^",7)
	quit:(insTypeId'="")&&(insTypeId'=admReaDR)
	set insType=$s((+admReaDR'=0):$p($g(^PAC("ADMREA",admReaDR)),"^",2),1:"")
	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, langId)
	set deposit=##class(web.UDHCJFBaseCommon).deposit(adm)
	set deposit=$fn(deposit,"",2)
    set amount=..getpatshare(adm)
	set amount=$fn(amount,"",2)
	quit:(+amount=0)
	set balance=deposit-amount
	set balance=$fn(balance,"",2)
	quit:((arrearsFlag=-1)&&(+balance>=0))
	quit:((arrearsFlag=1)&&(+balance<=0))
	quit:((arrearsFlag=0)&&(+balance'=0))
	set amountSum=$i(amountSum, amount)
    set depositSum=$i(depositSum, deposit)
	set balanceSum=$i(balanceSum, balance)
    set arrFlag="", arrUser="", arrDate="", arrTime=""
    set arrId=$o(^DHCJFUPAdmArrears(0,"Adm",adm,""),-1)
    if (arrId'="") {
	    set arrData=$g(^DHCJFUPAdmArrears(arrId))
	    set isArr=$p(arrData,"^",5)
	    set arrFlag=$case(isArr,1:##class(websys.Translation).Get("", "欠费", langId),:"")
	    set arrUserDR=$p(arrData,"^",4)
	    set arrUser=$s((+arrUserDR'=0):$p($g(^SSU("SSUSR",arrUserDR)),"^",2),1:"")
	    set arrUser=##class(User.SSUser).GetTranByDesc("SSUSRName", arrUser, langId)
	    set arrDate=$p(arrData,"^",2)
		set arrDate=##class(websys.Conversions).DateLogicalToHtml(arrDate)
	    set arrTime=$p(arrData,"^",3)
		set arrTime=##class(websys.Conversions).TimeLogicalToHtml(arrTime)
    }
	do OutputArrPatListrpx
	quit
	
OutputArrPatListrpx
	set Data=$lb(regNo,mrNo,patName,sex,bed,insType,dept,ward,admDate,admTime,dischDate,dischTime,amount,deposit,balance,status,adm,arrFlag,arrUser,arrDate,arrTime)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

}
