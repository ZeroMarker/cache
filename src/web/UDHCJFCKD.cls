Class web.UDHCJFCKD Extends BILL.COM.Abstract
{

/// Description: 欠费患者查询
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFCKD","QryPatientList","21","","","","")
Query QryPatientList(wardId As %String, balance As %String, episodeId As %String, insTypeId As %String, selAdmStr As %Text = "", langId As %String = "") As websys.Query(ROWSPEC = "TRegNo:%String:登记号,TMrNo:%String:病案号,TPatName:%String:患者姓名,TSex:%String:性别,TAge:%String:年龄,TDept:%String:科室,TWard:%String:病区,TRoom:%String:病房,TBedCode:%String:床号,TDeposit:%Float:押金,TTotalAmt:%Float:未结算费用,TPatShareAmt:%Float:自付金额,TBalAmt:%Float:余额,TWarrantAmt:%Float:担保金额,TAdmReason:%String:费别,TAdmDatTime:%String:入院时间,TMrDiagnos:%String:诊断,TAdm:%String:就诊ID,TEncryptLevel:%String:密级,TPatLevel:%String:级别") [ SqlProc ]
{
}

ClassMethod QryPatientListExecute(ByRef qHandle As %Binary, wardId As %String, balance As %String, episodeId As %String, insTypeId As %String, selAdmStr As %Text = "", langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("QryPatientList")=$lb(wardId, balance, episodeId, insTypeId, selAdmStr, langId)
	if ((+wardId=0)&&(+episodeId=0))  quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	if (+episodeId'=0) {
		do GetAdmInfo(episodeId, balance)
		quit $$$OK
	}
	
	do GetWardPat(wardId, balance)
	
	quit $$$OK
	
GetWardPat(wardId, balance)
	set job=$j
	kill ^||TMP(job)
	//2021-02-27 ZhYW 按床号排序
	do ##class(web.DHCIPBillDailyDtlList).BuildSeqAry(wardId, .seqAry)
	
	set roomId=0
	while($o(^PAADMi("CurrWard",wardId,roomId))) {
		set roomId=$o(^PAADMi("CurrWard",wardId,roomId))
		set adm=0
		while($o(^PAADMi("CurrWard",wardId,roomId,adm))) {
			set adm=$o(^PAADMi("CurrWard",wardId,roomId,adm))
			continue:((selAdmStr'="")&&(("^"_selAdmStr_"^")'[("^"_adm_"^")))	//2018-07-02 Suhuide 根据就诊过滤，主要实现打印催款单时使用
			set visitStatus=$p(^PAADM(adm),"^",20)   //病人状态
			continue:(visitStatus'="A")
			set admReaDR=$p(^PAADM(adm,1),"^",7)
			continue:((+insTypeId'=0)&&(admReaDR'=insTypeId))
			set bedDR=##class(BILL.IP.COM.Method).GetTransBedId(adm)
			continue:(bedDR="")
			set seqIdx=$g(seqAry(bedDR))
			set ^||TMP(job,seqIdx,adm)=""
		}
	}
	
	set idx=""
	while($o(^||TMP(job,idx))) {
		set idx=$o(^||TMP(job,idx))
		set adm=0
		while($o(^||TMP(job,idx,adm))) {
			set adm=$o(^||TMP(job,idx,adm))
			do GetAdmInfo(adm, balance)
		}
	}
	
	kill ^||TMP(job)
	
	quit

GetAdmInfo(adm, balance)
	set admType=$p(^PAADM(adm),"^",2)
	quit:(admType'="I")
	//set rtn=##class(web.UDHCJFBILL).BILLN(adm, 1)
	set admDateInfo=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(adm)
	set admDatTime=$p(admDateInfo,"^",1)
	set admReaDR=$p(^PAADM(adm,1),"^",7)
	set admReason=$s((+admReaDR'=0):$p(^PAC("ADMREA",admReaDR),"^",2), 1:"")
	set admReason=##class(User.PACAdmReason).GetTranByDesc("READesc", admReason, langId)
	set deptDR=$p(^PAADM(adm),"^",4)
    set dept=$s((+deptDR'=0):$p($g(^CTLOC(deptDR)),"^",2), 1:"")
    set dept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", dept, langId)
    set wardDR=$p(^PAADM(adm),"^",70)
	set ward=$s((+wardDR'=0):$p($g(^PAWARD(wardDR)),"^",2), 1:"")
	set ward=##class(User.PACWard).GetTranByDesc("WARDDesc", ward, langId)
    set roomDR=$p(^PAADM(adm),"^",69)
    set room=$s((+roomDR'=0):$p($g(^PAROOM(roomDR)),"^",2), 1:"")
    set room=##class(User.PACRoom).GetTranByDesc("ROOMDesc", room, langId)
	set bedCode=##class(web.DHCBillCommon).GetPatBedCode(adm)
	set papmi=$p(^PAADM(adm),"^",1)
	set patName=$p(^PAPER(papmi,"ALL"),"^",1)
	set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    set patEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
    set encryptLevel=$p(patEncryptLevel,"^",1)
    set patLevel=$p(patEncryptLevel,"^",2)
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
	set age=##class(web.DHCBillInterface).GetPapmiAge(papmi, adm)
	set sexDR=$p(^PAPER(papmi,"ALL"),"^",7)
	set sex=$s((+sexDR'=0):$p(^CT("SEX",sexDR),"^",2), 1:"")
	set sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", sex, langId)
	set warrantAmt=##class(web.UDHCJFZYDB).GetWarrAmt(adm)
	set warrantAmt=$fn(warrantAmt,"",2)
	set patFeeInfo=##class(web.UDHCJFCKD).getPatFeeInfo(adm)
	set totalAmt=$p(patFeeInfo,"^",1)
	quit:(+totalAmt=0)
	set patShareAmt=$p(patFeeInfo,"^",2)
	set deposit=##class(web.UDHCJFBaseCommon).deposit(adm)
	set deposit=$fn(deposit,"",2)
	set balAmt=deposit+warrantAmt-patShareAmt
	set balAmt=$fn(balAmt,"",2)
	quit:(+balAmt>+balance)
   	set diagDesc=##class(DHCDoc.Interface.Inside.ServiceDiag).GetAdmDiagDesc(adm)   //诊断
	do OutputPatient
	
	quit
	
OutputPatient
	set Data=$lb(regNo,mrNo,patName,sex,age,dept,ward,room,bedCode,deposit,totalAmt,patShareAmt,balAmt,warrantAmt,admReason,admDatTime,diagDesc,adm,encryptLevel,patLevel)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Description: 根据就诊取患者未结算押金总额
/// Modify: ZhYW 2022-12-30 改为调用公共类中的方法
/// Debug: w ##class(web.UDHCJFCKD).deposit(2802)
ClassMethod deposit(adm As %String) As %String
{
	quit ##class(web.UDHCJFBaseCommon).deposit(adm)
}

/// Creator: hujunbin
/// CreatDate: 2015-02-09
/// Description: 取病人费用
ClassMethod getPatFeeInfo(adm As %String) As %String
{
	set totalSum=0, patShareSum=0, discSum=0, payorSum=0
	set pb=0
	while($o(^DHCPB(0,"ADM",adm,pb))) {
		set pb=$o(^DHCPB(0,"ADM",adm,pb))
		set pbData=$g(^DHCPB(pb))
		set payedFlag=$p(pbData,"^",16)
		set isCloseAcount=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(pb)
		continue:((payedFlag="P")&&(isCloseAcount'="Y"))
		set pbTotalAmt=$p(pbData,"^",8)
		set pbDiscAmt=$p(pbData,"^",9)
		set pbPayorAmt=$p(pbData,"^",11)
		set pbPatAmt=$p(pbData,"^",12)
		set totalSum=$i(totalSum, pbTotalAmt)
		set patShareSum=$i(patShareSum, pbPatAmt)
		set discSum=$i(discSum, pbDiscAmt)
		set payorSum=$i(payorSum, pbPayorAmt)
	}
	
	quit $fn(totalSum,"",2)_"^"_$fn(patShareSum,"",2)_"^"_$fn(discSum,"",2)_"^"_$fn(payorSum,"",2)
}

/// Debug: w ##class(web.UDHCJFCKD).totalamount(2802)
ClassMethod totalamount(adm) As %String
{
	set totalSum=0
	set pb=0
	for  set pb=$o(^DHCPB(0,"ADM",adm,pb))  quit:(pb="")  do
	.set pbData=$g(^DHCPB(pb))
	.set payedFlag=$p(pbData,"^",16)
	.set isCloseAcount=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(pb)
	.quit:((payedFlag="P")&&(isCloseAcount'="Y"))
	.set pbTotalAmt=$p(pbData,"^",8)
	.set totalSum=$i(totalSum, pbTotalAmt)
	
	quit $fn(totalSum,"",2)
}

}
