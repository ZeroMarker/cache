Class web.DHCIPBillWorkLoad Extends %Library.RegisteredObject
{

/// do ##class(%ResultSet).RunQuery("web.DHCIPBillWorkLoad","GetWorkStat","","2020-05-14","2020-05-14","00:00:00","23:59:59","")
Query GetWorkStat(UserRowId As %String, StDate As %String, EndDate As %String, StartTime As %String, EndTime As %String, DateFlag As %String, HOSPID) As websys.Query(ROWSPEC = "TUserCode:%String,TUserName:%String,admNorNum:%Integer,admYBNum:%Integer,CancelNorNum:%Integer,CancelYBNum:%Integer,OutNorNum:%Integer,OutYBNum:%Integer,TDepositNum:%Integer,TDepositAmt:%Float,DepositNum:%Integer,DepositAmt:%Float,InvYBNum:%Integer,InvYBAmt:%Float,InvNorNum:%Integer,InvNorAmt:%Float") [ SqlProc ]
{
}

ClassMethod GetWorkStatExecute(ByRef qHandle As %Binary, UserRowId As %String, StDate As %String, EndDate As %String, StartTime As %String, EndTime As %String, DateFlag As %String, HOSPID) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	if ((StDate="")||(EndDate=""))  quit $$$OK
	if (StDate["-") set StDate=$zdh(StDate,3)
	if (StDate["/") set StDate=$zdh(StDate,4)
	if (EndDate["-") set EndDate=$zdh(EndDate,3)
	if (EndDate["/") set EndDate=$zdh(EndDate,4)
	set StartTime=##class(websys.Conversions).TimeHtmlToLogical(StartTime)
	set EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime)
	
	kill ^||TMP($j)
	
	for date=StDate:1:EndDate do
	.do ..GetPatNum(UserRowId, date, StDate, EndDate, StartTime, EndTime, DateFlag, HOSPID)      //统计入出院人数
	.do ..GetDeposit(UserRowId, date, StDate, EndDate, StartTime, EndTime, DateFlag, HOSPID)     //统计预交金收退
	.do ..GetPrtInv(UserRowId, date, StDate, EndDate, StartTime, EndTime, DateFlag, HOSPID)      //统计发票收退

	set UserDR=""
	for  set UserDR=$o(^||TMP($j,UserDR)) quit:(UserDR="")  do
	.set rtn=##class(web.UDHCJFBaseCommon).CheckISCashierBytype(UserDR, "I", 3)    //非收费员不显示 
	.quit:(rtn=1)
	.set userCode=$p($g(^SSU("SSUSR",UserDR)),"^",1)	//SSUSR_Name
	.set userName=$p($g(^SSU("SSUSR",UserDR)),"^",2)	//SSUSR_Name
	.set admYBNum=+$g(^||TMP($j,UserDR,"PatNum","Y","A"))          //医保入院人数
	.set admNorNum=+$g(^||TMP($j,UserDR,"PatNum","N","A"))         //普通入院人数
	.set CancelYBNum=+$g(^||TMP($j,UserDR,"PatNum","Y","C"))       //医保退院人数
	.set CancelYBNum=+$g(^||TMP($j,UserDR,"PatNum","N","C"))        //普通退院人数
	.set OutYBNum=+$g(^||TMP($j,UserDR,"PatNum","Y","D"))           //医保出院人数（护士办理出院）
	.set OutNorNum=+$g(^||TMP($j,UserDR,"PatNum","N","D"))          //普通出院人数（护士办理出院）
	.set DepositNum=+$g(^||TMP($j,UserDR,"DepNum","N"))         //收押金张数
	.set DepositAmt=+$g(^||TMP($j,UserDR,"DepSum","N"))         //收押金张数
	.set TDepositNum=+$g(^||TMP($j,UserDR,"DepNum","R"))        //退押金笔数    
	.set TDepositAmt=+$g(^||TMP($j,UserDR,"DepSum","R"))        //退押金笔数 
	.set InvNorNum=+$g(^||TMP($j,UserDR,"InvNum","N"))         //普通收款笔数   
	.set InvNorAmt=+$g(^||TMP($j,UserDR,"InvSum","N"))         //普通收款金额  
	.set InvYBNum=+$g(^||TMP($j,UserDR,"InvNum","Y"))          //医保收款笔数
	.set InvYBAmt=+$g(^||TMP($j,UserDR,"InvSum","Y"))          //医保收款金额
	.set data=$lb(userCode,userName,admNorNum,admYBNum,CancelNorNum,CancelYBNum,OutNorNum,OutYBNum,TDepositNum,TDepositAmt,DepositNum,DepositAmt,InvYBNum,InvYBAmt,InvNorNum,InvNorAmt)                           
	.set ^CacheTemp(repid,ind)=data
	.set ind=ind+1
	
	kill ^||TMP($j)
	quit $$$OK
}

/// 将入出退院病人存入global
ClassMethod GetPatNum(userId As %String, date As %String, stDate As %String, endDate As %String, stTime As %String, endTime As %String, dateFlag As %String, hospId As %String) As %String
{
	set adm=0
	for  set adm=$o(^PAADMi("PAADM_AdmDate",date,adm)) quit:(adm="")  do
	.set type=$p(^PAADM(adm),"^",2)
	.quit:(type'="I")
	.set visitStatus=$p(^PAADM(adm),"^",20)
	.set prtUser=$p(^PAADM(adm),"^",43)
	.quit:((prtUser'=userId)&&(userId'=""))
	.set admDate=$p(^PAADM(adm),"^",6)
	.set admTime=$p(^PAADM(adm),"^",7)
	.quit:(admDate=stDate)&&(admTime<stTime)&&(stTime'="")
	.quit:(admDate=endDate)&&(admTime>endTime)&&(endTime'="")
	.set admReaDR=$p(^PAADM(adm,1),"^",7)
	.set nationalCode=$p(^PAC("ADMREA",admReaDR),"^",5)
	.set isInsu=$s((+nationalCode>0):"Y",1:"N")
	.set deptDR=$p(^PAADM(adm),"^",4)
	.set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(deptDR)
	.quit:(hospId'=admHospDR)
	.set ^||TMP($j,prtUser,"PatNum",isInsu,visitStatus)=+$g(^||TMP($j,prtUser,"PatNum",isInsu,visitStatus))+1   //不同费别入出退人数

	quit 0
}

/// 收退废押金存入global
ClassMethod GetDeposit(userId As %String, date As %String, stDate As %String, endDate As %String, stTime As %String, endTime As %String, dateFlag As %String, hospId As %String) As %String
{
	if (dateFlag="Y")  do
	.//结账日
	.set jkrowid=0
	.for  set jkrowid=$o(^DHCJFUSERJK(0,"date",date,jkrowid)) quit:(jkrowid="")  do
	..set prtrowid=0
	..for  set prtrowid=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkrowid,prtrowid)) quit:(prtrowid="")   do
	...set depData=$g(^DHCSFPRINTDETAIL(prtrowid))
	...quit:(depData="")
	...set handinDate=$p(depData,"^",21)
	...set handinTime=$p(depData,"^",22)
	...quit:(handinDate=stDate)&&(handinTime<stTime)&&(stTime'="")
	...quit:(handinDate=endDate)&&(handinTime>endTime)&&(endTime'="")
	...do BuildDepList
	else  do
	.//自然日
	.set prtrowid=0
	.for  set prtrowid=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,prtrowid))  quit:(prtrowid="")  do
	..set depData=$g(^DHCSFPRINTDETAIL(prtrowid))
	..quit:(depData="")
	..set prtDate=$p(depData,"^",2)
	..set prtTime=$p(depData,"^",3)
	..quit:(prtDate=stDate)&&(prtTime<stTime)&&(stTime'="")
	..quit:(prtDate=endDate)&&(prtTime>endTime)&&(endTime'="")
	..do BuildDepList
	
	quit 0
	
BuildDepList
	set prtHospDR=$p(depData,"^",44)
	quit:(hospId'=prtHospDR)
	set prtUser=$p(depData,"^",14)
	quit:((prtUser'=userId)&&(userId'=""))
	set prtStatus=$p(depData,"^",8)
	set payAmt=$p(depData,"^",6)
	set initDepDR=$p(depData,"^",43)
	if (+payAmt>0) do
	.set ^||TMP($j,prtUser,"DepNum","N")=+$g(^||TMP($j,prtUser,"DepNum","N"))+1
	.set ^||TMP($j,prtUser,"DepSum","N")=+$g(^||TMP($j,prtUser,"DepSum","N"))+payAmt
	else  do
	.set ^||TMP($j,prtUser,"DepNum","R")=+$g(^||TMP($j,prtUser,"DepNum","R"))+1     
	.set ^||TMP($j,prtUser,"DepSum","R")=+$g(^||TMP($j,prtUser,"DepSum","R"))+payAmt
	quit
}

/// 将发票的收退存入global
ClassMethod GetPrtInv(userId As %String, date As %String, stDate As %String, endDate As %String, stTime As %String, endTime As %String, dateFlag As %String, hospId As %String) As %String
{
	if (dateFlag="Y")  do
	.//结账日
	.set jkrowid=0
	.for  set jkrowid=$o(^DHCJFUSERJK(0,"date",date,jkrowid)) quit:(jkrowid="")  do
	..set prtrowid=0
	..for  set prtrowid=$o(^DHCINVPRTZY(0,"JK",jkrowid,prtrowid)) quit:(prtrowid="")  do
	...set invData=$g(^DHCINVPRTZY(prtrowid))
	...quit:(invData="")
	...set handinDate=$p(invData,"^",15)
	...set handinTime=$p(invData,"^",16)
	...quit:(handinDate=stDate)&&(handinTime<stTime)&&(stTime'="")
	...quit:(handinDate=endDate)&&(handinTime>endTime)&&(endTime'="")
	...do BuildInvList
	else  do
	.//自然日
	.set prtrowid=0
	.for  set prtrowid=$o(^DHCINVPRTZY(0,"DATE",date,prtrowid)) quit:(prtrowid="")  do
	..set invData=$g(^DHCINVPRTZY(prtrowid))
	..quit:(invData="")
	..set prtDate=$p(invData,"^",2)
	..set prtTime=$p(invData,"^",3)
	..quit:(prtDate=stDate)&&(prtTime<stTime)&&(stTime'="")
	..quit:(prtDate=endDate)&&(prtTime>endTime)&&(endTime'="")
	..do BuildInvList
	
	quit 0
BuildInvList
	set prtHospDR=$p(invData,"^",35)
	quit:(hospId'=prtHospDR)
	set prtUser=$p(invData,"^",7)
	quit:((prtUser'=userId)&&(userId'=""))
	set acount=$p(invData,"^",6)
	set prtFlag=$p(invData,"^",8)
	set admReaDR=$p(invData,"^",9)
	set initInvDR=$p(invData,"^",13)
	set nationalCode=$p(^PAC("ADMREA",admReaDR),"^",5)
	set isInsu=$s((+nationalCode>0):"Y",1:"N")
	set ^||TMP($j,prtUser,"InvNum",isInsu)=+$g(^||TMP($j,prtUser,"InvNum",isInsu))+1
	set ^||TMP($j,prtUser,"InvSum",isInsu)=+$g(^||TMP($j,prtUser,"InvSum",isInsu))+acount
	quit
}

/// 取住院收费员
/// do ##class(%ResultSet).RunQuery("web.DHCIPWorkLoad","FindUserOP","2")
Query FindUserIP(HOSPID As %String) As websys.Query(ROWSPEC = "UserName:%String,UserId:%String") [ SqlProc ]
{
}

ClassMethod FindUserIPExecute(ByRef qHandle As %Binary, HOSPID As %String) As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
    set rowid=$o(^DHCJFRcptGroupSet(0,"Type","I",3,""))
    if (rowid="") quit $$$OK
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_RcptGroupUser", HOSPID)
	set sub=0
	for  set sub=$o(^DHCJFRcptGroupSet(rowid,"Sub",sub)) quit:(sub="")  do
	.set subData=$g(^DHCJFRcptGroupSet(rowid,"Sub",sub))
	.quit:(subData="")
	.set hospId=$p(subData,"^",5)
	.quit:(defHospId'=hospId)
	.set userDR=$p(subData,"^",4)
 	.quit:'$d(^SSU("SSUSR",userDR))
	.set usrName=$p($g(^SSU("SSUSR",userDR)),"^",2)
 	.do OutputUserIP
	
	quit $$$OK
OutputUserIP
	set Data=$lb(usrName,userDR)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

}
