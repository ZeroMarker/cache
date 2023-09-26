/// Class Name:web.DHCOPBillActManage
/// Description:临时凭证查询界面
/// Creator:ZHL
/// CreatDate:2010-07-01
Class web.DHCOPBillActManage Extends %Persistent
{

/// w ##class(web.DHCOPBillActManage).GetOPReportCatDetailByDate(61964,61965)
ClassMethod GetOPReportCatDetailByDate(StDate, EndDate, CredNo) As %String
{
   /// creat by zhl 2010.06.22
    ////按时间统计 结算过的 门诊分类费用
	s Job=$i(^TMP("DHCOPBill","ReportCatDetail"))
	s:CredNo="" CredNo="DHCOPB001"
	k ^TMP("DHCOPBill","ReportCatDetail",Job)
	s ReturnData=""
	f Date=StDate:1:EndDate   d
	.s RepDr="0"
	.f  s RepDr=$o(^DHCOPInsFootI(0,"Date",Date,RepDr))	  q:RepDr=""    d
	..s vouchid=$g(^DHCOPInsFoot(RepDr,"Acct",CredNo))
       ..s:vouchid'="" ^TMP("DHCOPBill","ReportCatDetail",Job,"DateVouch",Date)=vouchid
       ..s Repsub="0"
	..f  s Repsub=$o(^DHCOPInsFoot(RepDr,"C",Repsub))   q:Repsub=""   d
	...s Cat=$p(^DHCOPInsFoot(RepDr,"C",Repsub),"^",1)
	...q:Cat=""
	...s CatAmt=$p(^DHCOPInsFoot(RepDr,"C",Repsub),"^",2)
	...s ^TMP("DHCOPBill","ReportCatDetail",Job,"Date",Date,Cat)=$g(^TMP("DHCOPBill","ReportCatDetail",Job,"Date",Date,Cat))+CatAmt
    ...s ^TMP("DHCOPBill","ReportCatDetail",Job,"HZ",Cat)=$g(^TMP("DHCOPBill","ReportCatDetail",Job,"HZ",Cat))+CatAmt
    ...s ^TMP("DHCOPBill","ReportCatDetail",Job,"HZ")=$g(^TMP("DHCOPBill","ReportCatDetail",Job,"HZ"))+CatAmt
    ...s ^TMP("DHCOPBill","ReportCatDetail",Job,"Date",Date)=$g(^TMP("DHCOPBill","ReportCatDetail",Job,"Date",Date))+CatAmt


    i $d(^TMP("DHCOPBill","ReportCatDetail",Job))  d
    .s Cat="0"
    .f  s Cat=$o(^DHCTarC("TIC",Cat))  q:Cat=""  d
    ..s CatDes=$p(^DHCTarC("TIC",Cat),"^",2)
    ..i ReturnData=""  s ReturnData="日期^收入合计^"_CatDes
    ..e  s ReturnData=ReturnData_"^"_CatDes
    .s ReturnData=ReturnData_"^临时凭证号^凭证编号"
    .s RepDate=""
    .f  s RepDate=$o(^TMP("DHCOPBill","ReportCatDetail",Job,"Date",RepDate))  q:RepDate=""   d
    ..s Date=$zd(RepDate,4)
    ..s ReturnData=ReturnData_$c(2)_Date_"^"_$fn($g(^TMP("DHCOPBill","ReportCatDetail",Job,"Date",RepDate)),"",2)
    ..s Cat="0"
    ..f  s Cat=$o(^DHCTarC("TIC",Cat))   q:Cat=""   d
    ...s CatAmt=$g(^TMP("DHCOPBill","ReportCatDetail",Job,"Date",RepDate,Cat))
    ...s ReturnData=ReturnData_"^"_CatAmt
    ..s ReturnData=ReturnData_"^"_$g(^TMP("DHCOPBill","ReportCatDetail",Job,"DateVouch",RepDate))_"^"
    .s ReturnData=ReturnData_$c(2)_"合计^"_$fn($g(^TMP("DHCOPBill","ReportCatDetail",Job,"HZ")),"",2)
    .s Cat="0"
    .f  s Cat=$o(^DHCTarC("TIC",Cat))  q:Cat=""   d
    ..s ReturnData=ReturnData_"^"_$fn($g(^TMP("DHCOPBill","ReportCatDetail",Job,"HZ",Cat)),"",2)
    .s ReturnData=ReturnData_"^^"
    k ^TMP("DHCOPBill","ReportCatDetail",Job)
    
    q ReturnData
}

ClassMethod OPReportCatDetailByUser(Date) As %String
{
   /// creat by zhl 2010.06.22
    /// 对一天的结算数据  按操作员  统计 门诊分类费用 
    
	s Job=$i(^TMP("DHCOPBill","UserReportCatDetail"))
	k ^TMP("DHCOPBill","UserReportCatDetail",Job)
	s ReturnData=""

	s RepDr="0"
	f  s RepDr=$o(^DHCOPInsFootI(0,"Date",Date,RepDr))	  q:RepDr=""    d
	.s RepUsr=$p(^DHCOPInsFoot(RepDr),"^",8)
	.s Repsub="0"
	.f  s Repsub=$o(^DHCOPInsFoot(RepDr,"C",Repsub))   q:Repsub=""   d
	..s Cat=$p(^DHCOPInsFoot(RepDr,"C",Repsub),"^",1)
	..q:Cat=""
	..s CatAmt=$p(^DHCOPInsFoot(RepDr,"C",Repsub),"^",2)
	..s ^TMP("DHCOPBill","UserReportCatDetail",Job,"User",RepUsr,Cat)=$g(^TMP("DHCOPBill","UserReportCatDetail",Job,"User",RepUsr,Cat))+CatAmt
    ..s ^TMP("DHCOPBill","UserReportCatDetail",Job,"HZ",Cat)=$g(^TMP("DHCOPBill","UserReportCatDetail",Job,"HZ",Cat))+CatAmt
    ..s ^TMP("DHCOPBill","UserReportCatDetail",Job,"HZ")=$g(^TMP("DHCOPBill","UserReportCatDetail",Job,"HZ"))+CatAmt
    ..s ^TMP("DHCOPBill","UserReportCatDetail",Job,"User",RepUsr)=$g(^TMP("DHCOPBill","UserReportCatDetail",Job,"User",RepUsr))+CatAmt


    i $d(^TMP("DHCOPBill","UserReportCatDetail",Job))  d
    .s Cat="0"
    .f  s Cat=$o(^DHCTarC("TIC",Cat))  q:Cat=""  d
    ..s CatDes=$p(^DHCTarC("TIC",Cat),"^",2)
    ..i ReturnData=""  s ReturnData="操作员^收入合计^"_CatDes
    ..e  s ReturnData=ReturnData_"^"_CatDes
    .s RepUsr=""
    .f  s RepUsr=$o(^TMP("DHCOPBill","UserReportCatDetail",Job,"User",RepUsr))  q:RepUsr=""   d
    ..s UserN=$p(^SSU("SSUSR",RepUsr),"^",2)
    ..s ReturnData=ReturnData_$c(2)_UserN_"^"_$fn($g(^TMP("DHCOPBill","UserReportCatDetail",Job,"User",RepUsr)),"",2)
    ..s Cat="0"
    ..f  s Cat=$o(^DHCTarC("TIC",Cat))   q:Cat=""   d
    ...s CatAmt=$g(^TMP("DHCOPBill","UserReportCatDetail",Job,"User",RepUsr,Cat))
    ...s ReturnData=ReturnData_"^"_CatAmt
    .s ReturnData=ReturnData_$c(2)_"合计^"_$fn($g(^TMP("DHCOPBill","UserReportCatDetail",Job,"HZ")),"",2)
    .s Cat="0"
    .f  s Cat=$o(^DHCTarC("TIC",Cat))  q:Cat=""   d
    ..s ReturnData=ReturnData_"^"_$fn($g(^TMP("DHCOPBill","UserReportCatDetail",Job,"HZ",Cat)),"",2)
    
    k ^TMP("DHCOPBill","UserReportCatDetail",Job)
    
    q ReturnData
}

/// w ##class(web.DHCOPBillActManage).OPReportCatDetailByLoc(61964,61965)
ClassMethod OPReportCatDetailByLoc(StDate, EndDate) As %String
{
   /// creat by zhl 2010.06.22
    /// 对一段时间的结算数据  按就诊科室统计 的门诊分类费用 
    ///需要修改 门诊结算程序  添加门诊发票分类费用   本地库已修改

	s Job=$i(^TMP("DHCOPBill","LocReportCatDetail"))

	k ^TMP("DHCOPBill","LocReportCatDetail",Job)

	s ReturnData=""
	
	f Date=StDate:1:EndDate   d
	.s RepDr="0"
	.f  s RepDr=$o(^DHCOPInsFootI(0,"Date",Date,RepDr))	  q:RepDr=""    d
    ..s InvDr="0"
    ..f  s InvDr=$o(^DHCINVPRT(0,"Report",RepDr,InvDr))   q:InvDr=""    d
    ...s sub="0"
    ...f  s sub=$o(^DHCINVPRT(InvDr,"C",sub))   q:sub=""    d
    ....s cat=$p($g(^DHCINVPRT(InvDr,"C",sub)),"^",2)
    ....s catamt=$p($g(^DHCINVPRT(InvDr,"C",sub)),"^",1)
    ....s InvBill=$p($g(^DHCINVPRT(InvDr,"C",sub)),"^",4)
    ....q:(+InvBill=0)||('$d(^DHCPB(InvBill)))
    ....s Adm=$p(^DHCPB(InvBill),"^",1)
    ....s AdmLoc=$p(^PAADM(Adm),"^",4)
    ....s ^TMP("DHCOPBill","LocReportCatDetail",Job,"Loc",AdmLoc,cat)=$g(^TMP("DHCOPBill","LocReportCatDetail",Job,"Loc",AdmLoc,cat))+catamt
    ....s ^TMP("DHCOPBill","LocReportCatDetail",Job,"HZ",cat)=$g(^TMP("DHCOPBill","LocReportCatDetail",Job,"HZ",cat))+catamt
    ....s ^TMP("DHCOPBill","LocReportCatDetail",Job,"Loc",AdmLoc)=$g(^TMP("DHCOPBill","LocReportCatDetail",Job,"Loc",AdmLoc))+catamt
    ....s ^TMP("DHCOPBill","LocReportCatDetail",Job,"HZ")=$g(^TMP("DHCOPBill","LocReportCatDetail",Job,"HZ"))+catamt

    i $d(^TMP("DHCOPBill","LocReportCatDetail",Job))   d
    .s Cat="0"
    .f  s Cat=$o(^DHCTarC("TIC",Cat))   q:Cat=""   d
    ..s CatDes=$p(^DHCTarC("TIC",Cat),"^",2)
    ..i ReturnData=""  s ReturnData="科室代码^科室名称^收入合计^"_CatDes
    ..e  s ReturnData=ReturnData_"^"_CatDes
    .s Loc=""
    .f  s Loc=$o(^TMP("DHCOPBill","LocReportCatDetail",Job,"Loc",Loc))   q:Loc=""    d
    ..s LocDes=$p(^CTLOC(Loc),"^",2)
    ..s LocCode=$p(^CTLOC(Loc),"^",1)
    ..s AllFee=$fn(+$g(^TMP("DHCOPBill","LocReportCatDetail",Job,"Loc",Loc)),"",2)
    ..s ReturnData=ReturnData_$c(2)_LocCode_"^"_LocDes_"^"_AllFee
    ..s Cat="0"
    ..f  s Cat=$o(^DHCTarC("TIC",Cat))   q:Cat=""   d
    ...s CatFee=$fn(+$g(^TMP("DHCOPBill","LocReportCatDetail",Job,"Loc",Loc,Cat)),"",2)
    ...s ReturnData=ReturnData_"^"_CatFee 
    .s FeeSum=$fn(+$g(^TMP("DHCOPBill","LocReportCatDetail",Job,"HZ")),"",2)
    .s ReturnData=ReturnData_$c(2)_"^合计^"_FeeSum
    .s Cat="0"
    .f  s Cat=$o(^DHCTarC("TIC",Cat))   q:Cat=""   d
    ..s CatFee=$fn(+$g(^TMP("DHCOPBill","LocReportCatDetail",Job,"HZ",Cat)),"",2)
    ..s ReturnData=ReturnData_"^"_CatFee
    
    k ^TMP("DHCOPBill","LocReportCatDetail",Job)
    
    q ReturnData
}

/// w ##class(web.DHCOPBillActManage).OPIncomeByDate(61964,61965,"DHCOPB002")
ClassMethod OPIncomeByDate(StDate, EndDate, CredNo) As %String
{
   /// creat by zhl 2010.06.22
    ///统计一段时间的门诊收入

	s Job=$i(^TMP("DHCOPBill","OPIncomeByDate"))
	k ^TMP("DHCOPBill","OPIncomeByDate",Job)
    q:CredNo="" ""
	s ReturnData=""
	
	f Date=StDate:1:EndDate   d
	.s RepDr="0"
	.f  s RepDr=$o(^DHCOPInsFootI(0,"Date",Date,RepDr))	  q:RepDr=""    d
    ..s vouch=$g(^DHCOPInsFoot(RepDr,"Acct",CredNo))
    ..s:vouch'="" ^TMP("DHCOPBill","OPIncomeByDate",Job,"InvDatevouch",Date)=vouch
    ..i $d(^DHCOPInsFoot(RepDr,"P"))   d
    ...s paysub="0"
    ...f  s paysub=$o(^DHCOPInsFoot(RepDr,"P",paysub))   q:paysub=""    d
    ....s paym=$p($g(^DHCOPInsFoot(RepDr,"P",paysub)),"^",2)
    ....s payamt=$p($g(^DHCOPInsFoot(RepDr,"P",paysub)),"^",1)
    ....s ^TMP("DHCOPBill","OPIncomeByDate",Job,"InvDate",Date,paym)=$g(^TMP("DHCOPBill","OPIncomeByDate",Job,"InvDate",Date,paym))+payamt
    ....s ^TMP("DHCOPBill","OPIncomeByDate",Job,"InvDate",Date)=$g(^TMP("DHCOPBill","OPIncomeByDate",Job,"InvDate",Date))+payamt
    ....s ^TMP("DHCOPBill","OPIncomeByDate",Job,"Inv",paym)=$g(^TMP("DHCOPBill","OPIncomeByDate",Job,"Inv",paym))+payamt
    ....s ^TMP("DHCOPBill","OPIncomeByDate",Job,"Inv")=$g(^TMP("DHCOPBill","OPIncomeByDate",Job,"Inv"))+payamt
    ..e     d
    ...s inv=""
    ...f  s inv=$o(^DHCINVPRT(0,"Report",RepDr,inv))  q:inv=""   d
    ....s paysub="0"
    ....f  s paysub=$o(^DHCINVPRT(inv,"P",paysub))   q:paysub=""    d
    .....s paym=$p(^DHCINVPRT(inv,"P",paysub),"^",1)
    .....s payamt=$p(^DHCINVPRT(inv,"P",paysub),"^",3)
    .....s ^TMP("DHCOPBill","OPIncomeByDate",Job,"InvDate",Date,paym)=$g(^TMP("DHCOPBill","OPIncomeByDate",Job,"InvDate",Date,paym))+payamt
    .....s ^TMP("DHCOPBill","OPIncomeByDate",Job,"InvDate",Date)=$g(^TMP("DHCOPBill","OPIncomeByDate",Job,"InvDate",Date))+payamt
    .....s ^TMP("DHCOPBill","OPIncomeByDate",Job,"Inv",paym)=$g(^TMP("DHCOPBill","OPIncomeByDate",Job,"Inv",paym))+payamt
    .....s ^TMP("DHCOPBill","OPIncomeByDate",Job,"Inv")=$g(^TMP("DHCOPBill","OPIncomeByDate",Job,"Inv"))+payamt
    .s accpdf="0"
    .f  s accpdf=$o(^DHCACDi("AccPDFL",0,"FootDT",Date,accpdf))   q:accpdf=""    d
    ..s AccM="0"
    ..f  s AccM=$o(^DHCACDi("AccM",0,"PDFootDR",accpdf,AccM))   q:AccM=""   d
    ...s AccPD="0"
    ...f  s AccPD=$o(^DHCACDi("AccM",0,"PDFootDR",accpdf,AccM,"AccPD",AccPD))   q:AccPD=""   d
    ....s GetAmt=$p(^DHCACD("AccM",AccM,"AccPD",AccPD),"^",2)
    ....s:GetAmt>0 ^TMP("DHCOPBill","OPIncomeByDate",Job,"DeptDate",Date,"Get")=$g(^TMP("DHCOPBill","OPIncomeByDate",Job,"DeptDate",Date,"Get"))+GetAmt
    ....s:GetAmt<0 ^TMP("DHCOPBill","OPIncomeByDate",Job,"DeptDate",Date,"Ref")=$g(^TMP("DHCOPBill","OPIncomeByDate",Job,"DeptDate",Date,"Ref"))+GetAmt
    ....s:GetAmt>0 ^TMP("DHCOPBill","OPIncomeByDate",Job,"Dept","Get")=$g(^TMP("DHCOPBill","OPIncomeByDate",Job,"Dept","Get"))+GetAmt
    ....s:GetAmt<0 ^TMP("DHCOPBill","OPIncomeByDate",Job,"Dept","Ref")=$g(^TMP("DHCOPBill","OPIncomeByDate",Job,"Dept","Ref"))+GetAmt


    i $d(^TMP("DHCOPBill","OPIncomeByDate",Job))  d
    .s paysub="0"
    .f  s paysub=$o(^CT("CTPM",paysub))    q:paysub=""   d
    ..q:'$d(^CT("CTPM",paysub))
    ..s paydes=$p(^CT("CTPM",paysub),"^",2)
    ..i ReturnData=""  s ReturnData="日期^病人类型^收入合计^"_paydes
    ..e   s ReturnData=ReturnData_"^"_paydes
    .s ReturnData=ReturnData_"^收预交金^退预交金^临时凭证编号^凭证号"
    .s Date=""
    .f  s Date=$o(^TMP("DHCOPBill","OPIncomeByDate",Job,"InvDate",Date))   q:Date=""   d
    ..s paysub="0"
    ..s n=0
    ..f  s paysub=$o(^CT("CTPM",paysub))    q:paysub=""   d
    ...q:'$d(^CT("CTPM",paysub))
    ...s n=n+1
    ...i n=1  s ReturnData=ReturnData_$c(2)_$zd(Date,3)_"^所有^"_$fn($g(^TMP("DHCOPBill","OPIncomeByDate",Job,"InvDate",Date)),"",2)_"^"_$fn($g(^TMP("DHCOPBill","OPIncomeByDate",Job,"InvDate",Date,paysub)),"",2)
    ...e   s ReturnData=ReturnData_"^"_ $fn($g(^TMP("DHCOPBill","OPIncomeByDate",Job,"InvDate",Date,paysub)),"",2)
    ..s ReturnData=ReturnData_"^"_$fn($g(^TMP("DHCOPBill","OPIncomeByDate",Job,"DeptDate",Date,"Get")),"",2) 
    ..s ReturnData=ReturnData_"^"_$fn($g(^TMP("DHCOPBill","OPIncomeByDate",Job,"DeptDate",Date,"Ref")),"",2)
    ..s ReturnData=ReturnData_"^"_$g(^TMP("DHCOPBill","OPIncomeByDate",Job,"InvDatevouch",Date))_"^"
    .s paysub="0"
    .s n=0
    .f  s paysub=$o(^CT("CTPM",paysub))    q:paysub=""   d
    ..q:'$d(^CT("CTPM",paysub))
    ..s n=n+1
    ..i n=1   s ReturnData=ReturnData_$c(2)_"合计^^"_$fn($g(^TMP("DHCOPBill","OPIncomeByDate",Job,"Inv")),"",2)_"^"_$fn($g(^TMP("DHCOPBill","OPIncomeByDate",Job,"Inv",paysub)),"",2)
    ..e  s ReturnData=ReturnData_"^"_$fn($g(^TMP("DHCOPBill","OPIncomeByDate",Job,"Inv",paysub)),"",2)
    .s ReturnData=ReturnData_"^"_$fn($g(^TMP("DHCOPBill","OPIncomeByDate",Job,"Dept","Get")),"",2)
    .s ReturnData=ReturnData_"^"_$fn($g(^TMP("DHCOPBill","OPIncomeByDate",Job,"Dept","Ref")),"",2)
    .s ReturnData=ReturnData_"^^"      
    k ^TMP("DHCOPBill","OPIncomeByDate",Job)
    
    q ReturnData
}

/// w ##class(web.DHCOPBillActManage).OPIncomeByAdmreason(61965)
ClassMethod OPIncomeByAdmreason(Date) As %String
{
 /// creat by zhl 2010.06.22
	///按病人费别 统计一天的的门诊收入
	
	s Job=$i(^TMP("DHCOPBill","OPIncomeByAdmreason"))
	k ^TMP("DHCOPBill","OPIncomeByAdmreason",Job)
	
	s ReturnData=""
	
	
	s RepDr="0"
	f  s RepDr=$o(^DHCOPInsFootI(0,"Date",Date,RepDr)) q:RepDr=""  d
	.s InvDr="0"
	.f  s InvDr=$o(^DHCINVPRT(0,"Report",RepDr,InvDr)) q:InvDr=""  d
	..s reason=$p(^DHCINVPRT(InvDr),"^",9)
	..s paysub="0"
	..f  s paysub=$o(^DHCINVPRT(InvDr,"P",paysub)) q:paysub=""  d
	...s paym=$p(^DHCINVPRT(InvDr,"P",paysub),"^",1)
	...s payamt=$p(^DHCINVPRT(InvDr,"P",paysub),"^",3)
	...s ^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Invreason",reason,paym)=$g(^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Invreason",reason,paym))+payamt
	...s ^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Invreason",reason)=$g(^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Invreason",reason))+payamt
	
	s AccF="0"
	f  s AccF=$o(^DHCACD("AccPDFL",0,"FootDT",Date,AccF)) q:AccF=""  d
	.s AccM="0"
	.f  s AccM=$o(^DHCACDi("AccM",0,"PDFootDR",AccF,AccM)) q:AccM=""  d
	..s AccPD="0"
	..f  s AccPD=$o(^DHCACDi("AccM",0,"PDFootDR",AccF,AccM,"AccPD",AccPD)) q:AccPD=""  d
	...s payamt=$p(^DHCACD("AccM",AccM,"AccPD",AccPD),"^",2)
	...s:payamt>0 ^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Deptreason","Get")=$g(^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Deptreason","Get"))+payamt
	...s:payamt<0 ^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Deptreason","Ref")=$g(^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Deptreason","Ref"))+payamt
	
	
	i $d(^TMP("DHCOPBill","OPIncomeByAdmreason",Job)) d
	.s reason="",num=0
	.f  s reason=$o(^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Invreason",reason)) q:reason=""  d
	..s reades=$p($g(^PAC("ADMREA",reason)),"^",2)
	..s paysub="0"
	..s n=0
	..s num=num+1
	..f  s paysub=$o(^CT("CTPM",paysub)) q:paysub=""  d
	...q:'$d(^CT("CTPM",paysub))
	...s n=n+1
	...i n=1 d
	....i ReturnData="" s ReturnData=reades_"^"_$fn($g(^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Invreason",reason)),"",2)_"^"_$fn($g(^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Invreason",reason,paysub)),"",2)
	....e  s ReturnData=ReturnData_$c(2)_reades_"^"_$fn($g(^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Invreason",reason)),"",2)_"^"_$fn($g(^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Invreason",reason,paysub)),"",2)
	...e  s ReturnData=ReturnData_"^"_ $fn($g(^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Invreason",reason,paysub)),"",2)
	..i num=1 s ReturnData=ReturnData_"^"_$fn($g(^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Deptreason","Get")),"",2)_"^"_$fn($g(^TMP("DHCOPBill","OPIncomeByAdmreason",Job,"Deptreason","Ref")),"",2)
	..e  s ReturnData=ReturnData_"^^"
	
	k ^TMP("DHCOPBill","OPIncomeByAdmreason",Job)
	
	q ReturnData
}

//日期^收入合计^床位费^西药费^中成药^中草药^检查费^治疗费^放射费^手术费^化验费^输血费^输氧费^护理费

//^诊疗费^B超^材料费^婴儿费^麻醉费^取暖费^陪床费^伙食费^空调费^其它费23/03/2009^13842.53^420.00^0.00^

//1572.75^0.00^592.00^82.00^160.00^0.00^7668.00^360.00^0.00^384.00^70.00^850.00^1619.48^56.00^0.00^0.00

//^0.00^0.00^0.00^8.3025/03/2009^22753.75^1050.00^0.00^524.25^0.00^740.00^410.00^400.00^1456.00^10817.50^

//1800.00^0.00^930.00^210.00^1525.00^2821.00^70.00^0.00^0.00^0.00^0.00^0.00^0.0010/06/2009^152859.43^7140.00

//^0.00^16776.00^0.00^5032.00^951.00^2720.00^4076.80^73927.00^7920.00^0.00^4482.00^959.00^11210.00^16155.53^

//476.00^0.00^810.00^0.00^0.00^0.00^224.1002/04/2010^29201.24^420.00^0.00^1048.50^0.00^2072.00^0.00^160.00^0.00

//^23880.00^0.00^0.00^453.00^70.00^120.00^809.74^168.00^0.00^0.00^0.00^0.00^0.00^0.00^合计^218656.95^9030.00^0.00

//^19921.50^0.00^8436.00^1443.00^3440.00^5532.80^116292.50^10080.00^0.00^6249.00^1309.00^13705.00^21405.75^770.00

//^0.00^810.00^0.00^0.00^0.00^232.40

/// w ##class(web.DHCOPBillActManage).IPReportCatDetailByDate(61191,61824)
ClassMethod IPReportCatDetailByDate(StDate, EndDate, CredNo) As %String
{
     /// creat by zhl 2010.06.23
    /// 对一段时间的结算数据  按日期统计 的住院分类费用 

	s Job=$i(^TMP("DHCIPBill","ReportCatDetail"))
	k ^TMP("DHCIPBill","ReportCatDetail",Job)
    
    s ReturnData=""
    q:CredNo="" ""
    f Date=StDate:1:EndDate   d
    .s RepDr="0"
    .f  s RepDr=$o(^DHCJFUSERJK(0,"date",Date,RepDr))    q:RepDr=""    d
    ..s vouch=$g(^DHCJFUSERJK(RepDr,"Acct",CredNo))
    ..s:vouch'="" ^TMP("DHCIPBill","ReportCatDetail",Job,"Datevouch",Date)=vouch
    ..s InvDr="0"
    ..f  s InvDr=$o(^DHCINVPRTZY(0,"JK",RepDr,InvDr))   q:InvDr=""   d
    ...s InvBill=$p(^DHCINVPRTZY(InvDr),"^",5)
    ...s catsub="0"
    ...f  s catsub=$o(^DHCJFPATIPSUBCATFEE(0,"DHCPB",InvBill,catsub))    q:catsub=""    d
    ....s SubCat=$p(^DHCJFPATIPSUBCATFEE(catsub),"^",2)
    ....s CatFee=$p(^DHCJFPATIPSUBCATFEE(catsub),"^",3)
    ....s Cat=$p(^DHCTarC("IC",SubCat),"^",3)
    ....s ^TMP("DHCIPBill","ReportCatDetail",Job,"Date",Date,Cat)=$g(^TMP("DHCIPBill","ReportCatDetail",Job,"Date",Date,Cat))+CatFee
    ....s ^TMP("DHCIPBill","ReportCatDetail",Job,"Date",Date)=$g(^TMP("DHCIPBill","ReportCatDetail",Job,"Date",Date))+CatFee
    ....s ^TMP("DHCIPBill","ReportCatDetail",Job,"Hz",Cat)=$g(^TMP("DHCIPBill","ReportCatDetail",Job,"Hz",Cat))+CatFee
    ....s ^TMP("DHCIPBill","ReportCatDetail",Job,"Hz")=$g(^TMP("DHCIPBill","ReportCatDetail",Job,"Hz"))+CatFee
    
    i $d(^TMP("DHCIPBill","ReportCatDetail",Job))   d
    .s Cat="0"
    .f  s Cat=$o(^DHCTarC("TIC",Cat))   q:Cat=""   d
    ..s CatDes=$p(^DHCTarC("TIC",Cat),"^",2)
    ..i ReturnData=""  s ReturnData="日期^收入合计^"_CatDes
    ..e  s ReturnData=ReturnData_"^"_CatDes
    .s ReturnData=ReturnData_"^临时凭证号^凭证编号"
    .s RepDate=""
    .f  s RepDate=$o(^TMP("DHCIPBill","ReportCatDetail",Job,"Date",RepDate))   q:RepDate=""    d
    ..s Date=$zd(RepDate,4)
    ..s AllFee=$fn(+$g(^TMP("DHCIPBill","ReportCatDetail",Job,"Date",RepDate)),"",2)
    ..s ReturnData=ReturnData_$c(2)_Date_"^"_AllFee
    ..s Cat="0"
    ..f  s Cat=$o(^DHCTarC("TIC",Cat))   q:Cat=""   d
    ...s CatFee=$fn(+$g(^TMP("DHCIPBill","ReportCatDetail",Job,"Date",RepDate,Cat)),"",2)
    ...s ReturnData=ReturnData_"^"_CatFee
    ..s ReturnData=ReturnData_"^"_$g(^TMP("DHCIPBill","ReportCatDetail",Job,"Datevouch",RepDate))_"^"
    .s FeeSum=$fn(+$g(^TMP("DHCIPBill","ReportCatDetail",Job,"Hz")),"",2)
    .s ReturnData=ReturnData_$c(2)_"合计^"_FeeSum
    .s Cat="0"
    .f  s Cat=$o(^DHCTarC("TIC",Cat))   q:Cat=""   d
    ..s CatFee=$fn(+$g(^TMP("DHCIPBill","ReportCatDetail",Job,"Hz",Cat)),"",2)
    ..s ReturnData=ReturnData_"^"_CatFee
    .s ReturnData=ReturnData_"^^"
    k ^TMP("DHCIPBill","ReportCatDetail",Job)
    
    q ReturnData
}

ClassMethod IPReportCatDetailByUser(Date) As %String
{
     /// creat by zhl 2010.06.23
    /// 对一天的结算数据  按操作员统计 的住院分类费用 

	s Job=$i(^TMP("DHCIPBill","UserReportCatDetail"))
	k ^TMP("DHCIPBill","UserReportCatDetail",Job)
    s:Date="" Date=+$h
    
    s ReturnData=""
    
    s RepDr="0"
    f  s RepDr=$o(^DHCJFUSERJK(0,"date",Date,RepDr))    q:RepDr=""    d
    .s InvDr="0"
    .f  s InvDr=$o(^DHCINVPRTZY(0,"JK",RepDr,InvDr))   q:InvDr=""   d
    ..s InvBill=$p(^DHCINVPRTZY(InvDr),"^",5)
    ..s Usr=$p(^DHCINVPRTZY(InvDr),"^",7)
    ..s catsub=""
    ..f  s catsub=$o(^DHCJFPATIPSUBCATFEE(0,"DHCPB",InvBill,catsub))    q:catsub=""    d
    ...s SubCat=$p(^DHCJFPATIPSUBCATFEE(catsub),"^",2)
    ...s CatFee=$p(^DHCJFPATIPSUBCATFEE(catsub),"^",3)
    ...s Cat=$p(^DHCTarC("IC",SubCat),"^",3)
    ...s ^TMP("DHCIPBill","UserReportCatDetail",Job,"User",Usr,Cat)=$g(^TMP("DHCIPBill","UserReportCatDetail",Job,"User",Usr,Cat))+CatFee
    ...s ^TMP("DHCIPBill","UserReportCatDetail",Job,"User",Usr)=$g(^TMP("DHCIPBill","UserReportCatDetail",Job,"User",Usr))+CatFee
    ...s ^TMP("DHCIPBill","UserReportCatDetail",Job,"Hz",Cat)=$g(^TMP("DHCIPBill","UserReportCatDetail",Job,"Hz",Cat))+CatFee
    ...s ^TMP("DHCIPBill","UserReportCatDetail",Job,"Hz")=$g(^TMP("DHCIPBill","UserReportCatDetail",Job,"Hz"))+CatFee
    
    i $d(^TMP("DHCIPBill","UserReportCatDetail",Job))   d
    .s Cat="0"
    .f  s Cat=$o(^DHCTarC("TIC",Cat))   q:Cat=""   d
    ..s CatDes=$p(^DHCTarC("TIC",Cat),"^",2)
    ..i ReturnData=""  s ReturnData="操作员^收入合计^"_CatDes
    ..e  s ReturnData=ReturnData_"^"_CatDes
    .s Usr=""
    .f  s Usr=$o(^TMP("DHCIPBill","UserReportCatDetail",Job,"User",Usr))   q:Usr=""    d
    ..s UsrN=$p(^SSU("SSUSR",Usr),"^",2)
    ..s AllFee=$fn(+$g(^TMP("DHCIPBill","UserReportCatDetail",Job,"User",Usr)),"",2)
    ..s ReturnData=ReturnData_$c(2)_UsrN_"^"_AllFee
    ..s Cat="0"
    ..f  s Cat=$o(^DHCTarC("TIC",Cat))   q:Cat=""   d
    ...s CatFee=$fn(+$g(^TMP("DHCIPBill","UserReportCatDetail",Job,"User",Usr,Cat)),"",2)
    ...s ReturnData=ReturnData_"^"_CatFee
    .s FeeSum=$fn(+$g(^TMP("DHCIPBill","UserReportCatDetail",Job,"Hz")),"",2)
    .s ReturnData=ReturnData_$c(2)_"合计^"_FeeSum
    .s Cat="0"
    .f  s Cat=$o(^DHCTarC("TIC",Cat))   q:Cat=""   d
    ..s CatFee=$fn(+$g(^TMP("DHCIPBill","UserReportCatDetail",Job,"Hz",Cat)),"",2)
    ..s ReturnData=ReturnData_"^"_CatFee

    k ^TMP("DHCIPBill","UserReportCatDetail",Job)
    
    q ReturnData
}

ClassMethod IPReportCatDetailByLoc(StDate, EndDate) As %String
{
     /// creat by zhl 2010.06.23
    /// 对一段时间的结算数据  按科室统计 的住院分类费用 

	s Job=$i(^TMP("DHCIPBill","LocReportCatDetail"))
	k ^TMP("DHCIPBill","LocReportCatDetail",Job)
    
    s ReturnData=""
    
    f Date=StDate:1:EndDate   d
    .s RepDr="0"
    .f  s RepDr=$o(^DHCJFUSERJK(0,"date",Date,RepDr))    q:RepDr=""    d
    ..s InvDr="0"
    ..f  s InvDr=$o(^DHCINVPRTZY(0,"JK",RepDr,InvDr))   q:InvDr=""   d
    ...s InvBill=$p(^DHCINVPRTZY(InvDr),"^",5)
    ...s Adm=$p(^DHCINVPRTZY(InvDr),"^",4)
    ...s AdmLoc=$p(^PAADM(Adm),"^",4)
    ...s catsub="0"
    ...f  s catsub=$o(^DHCJFPATIPSUBCATFEE(0,"DHCPB",InvBill,catsub))    q:catsub=""    d
    ....s SubCat=$p(^DHCJFPATIPSUBCATFEE(catsub),"^",2)
    ....s CatFee=$p(^DHCJFPATIPSUBCATFEE(catsub),"^",3)
    ....s Cat=$p(^DHCTarC("IC",SubCat),"^",3)
    ....s ^TMP("DHCIPBill","LocReportCatDetail",Job,"Loc",AdmLoc,Cat)=$g(^TMP("DHCIPBill","LocReportCatDetail",Job,"Loc",AdmLoc,Cat))+CatFee
    ....s ^TMP("DHCIPBill","LocReportCatDetail",Job,"Loc",AdmLoc)=$g(^TMP("DHCIPBill","LocReportCatDetail",Job,"Loc",AdmLoc))+CatFee
    ....s ^TMP("DHCIPBill","LocReportCatDetail",Job,"Hz",Cat)=$g(^TMP("DHCIPBill","LocReportCatDetail",Job,"Hz",Cat))+CatFee
    ....s ^TMP("DHCIPBill","LocReportCatDetail",Job,"Hz")=$g(^TMP("DHCIPBill","LocReportCatDetail",Job,"Hz"))+CatFee
    
    i $d(^TMP("DHCIPBill","LocReportCatDetail",Job))   d
    .s Cat="0"
    .f  s Cat=$o(^DHCTarC("TIC",Cat))   q:Cat=""   d
    ..s CatDes=$p(^DHCTarC("TIC",Cat),"^",2)
    ..i ReturnData=""  s ReturnData="科室代码^科室名称^收入合计^"_CatDes
    ..e  s ReturnData=ReturnData_"^"_CatDes
    .s Loc=""
    .f  s Loc=$o(^TMP("DHCIPBill","LocReportCatDetail",Job,"Loc",Loc))   q:Loc=""    d
    ..s LocDes=$p(^CTLOC(Loc),"^",2)
    ..s LocCode=$p(^CTLOC(Loc),"^",1)
    ..s AllFee=$fn(+$g(^TMP("DHCIPBill","LocReportCatDetail",Job,"Loc",Loc)),"",2)
    ..s ReturnData=ReturnData_$c(2)_LocCode_"^"_LocDes_"^"_AllFee
    ..s Cat="0"
    ..f  s Cat=$o(^DHCTarC("TIC",Cat))   q:Cat=""   d
    ...s CatFee=$fn(+$g(^TMP("DHCIPBill","LocReportCatDetail",Job,"Loc",Loc,Cat)),"",2)
    ...s ReturnData=ReturnData_"^"_CatFee
    .s FeeSum=$fn(+$g(^TMP("DHCIPBill","LocReportCatDetail",Job,"Hz")),"",2)
    .s ReturnData=ReturnData_$c(2)_"^合计^"_FeeSum
    .s Cat="0"
    .f  s Cat=$o(^DHCTarC("TIC",Cat))   q:Cat=""   d
    ..s CatFee=$fn(+$g(^TMP("DHCIPBill","LocReportCatDetail",Job,"Hz",Cat)),"",2)
    ..s ReturnData=ReturnData_"^"_CatFee

    k ^TMP("DHCIPBill","LocReportCatDetail",Job)
    
    q ReturnData
}

/// w ##class(web.DHCOPBillActManage).IPIncomeByDate(61191,61824)
ClassMethod IPIncomeByDate(StDate, EndDate, CredNo) As %String
{
   /// creat by zhl 2010.06.22
    ///统计一段时间的住院收入
    s ^TMP("Test")=StDate_","_EndDate_","_CredNo
	s Job=$i(^TMP("DHCOPBill","IPIncomeByDate"))
	k ^TMP("DHCOPBill","IPIncomeByDate",Job)
    q:CredNo="" ""
	s ReturnData=""
	
	f Date=StDate:1:EndDate   d
	.s Handdr="0"
	.f  s Handdr=$o(^DHCJFUSERJK(0,"date",Date,Handdr))	  q:Handdr=""    d
    ..s vouch=$g(^DHCJFUSERJK(Handdr,"Acct",CredNo))
    ..s:vouch'="" ^TMP("DHCOPBill","IPIncomeByDate",Job,"InvDatevouch",Date)=vouch 
    ..s InvDr="0"
    ..f  s InvDr=$o(^DHCINVPRTZY(0,"JK",Handdr,InvDr))   q:InvDr=""    d
    ...s arrcp=$p(^DHCINVPRTZY(InvDr),"^",17)
    ...i +arrcp=0   d
    ....s invpb=$p(^DHCINVPRTZY(InvDr),"^",5)
    ....q:+invpb=0
    ....s arrcp=$o(^ARRCP("ARPBL",+invpb,""),-1)
    ...s paysub="0"
    ...f  s paysub=$o(^ARRCP(+arrcp,"PAYM",paysub))   q:paysub=""   d
    ....s payamt=$p(^ARRCP(+arrcp,"PAYM",paysub),"^",3)
    ....s paym=$p(^ARRCP(+arrcp,"PAYM",paysub),"^",1)
    ....s ^TMP("DHCOPBill","IPIncomeByDate",Job,"InvDate",Date,paym)=$g(^TMP("DHCOPBill","IPIncomeByDate",Job,"InvDate",Date,paym))+payamt
    ....s ^TMP("DHCOPBill","IPIncomeByDate",Job,"InvDate",Date)=$g(^TMP("DHCOPBill","IPIncomeByDate",Job,"InvDate",Date))+payamt
    ....s ^TMP("DHCOPBill","IPIncomeByDate",Job,"Inv",paym)=$g(^TMP("DHCOPBill","IPIncomeByDate",Job,"Inv",paym))+payamt
    ....s ^TMP("DHCOPBill","IPIncomeByDate",Job,"Inv")=$g(^TMP("DHCOPBill","IPIncomeByDate",Job,"Inv"))+payamt
    ..s dept="0"
    ..f  s dept=$o(^DHCSFPRINTDETAIL(0,"JKDR",Handdr,dept))   q:dept=""    d
    ...s paym=$p(^DHCSFPRINTDETAIL(dept),"^",9)
    ...s payamt=$p(^DHCSFPRINTDETAIL(dept),"^",6)
    ...s:payamt>0 ^TMP("DHCOPBill","IPIncomeByDate",Job,"DeptDate",Date,"Get")=$g(^TMP("DHCOPBill","IPIncomeByDate",Job,"DeptDate",Date,"Get"))+payamt
    ...s:payamt<0 ^TMP("DHCOPBill","IPIncomeByDate",Job,"DeptDate",Date,"Ref")=$g(^TMP("DHCOPBill","IPIncomeByDate",Job,"DeptDate",Date,"Ref"))+payamt
    ...s:payamt>0 ^TMP("DHCOPBill","IPIncomeByDate",Job,"Dept","Get")=$g(^TMP("DHCOPBill","IPIncomeByDate",Job,"Dept","Get"))+payamt
    ...s:payamt<0 ^TMP("DHCOPBill","IPIncomeByDate",Job,"Dept","Ref")=$g(^TMP("DHCOPBill","IPIncomeByDate",Job,"Dept","Ref"))+payamt

    b
    i $d(^TMP("DHCOPBill","IPIncomeByDate",Job))  d
    .s paysub="0"
    .f  s paysub=$o(^CT("CTPM",paysub))    q:paysub=""   d
    ..q:'$d(^CT("CTPM",paysub))
    ..s paydes=$p(^CT("CTPM",paysub),"^",2)
    ..i ReturnData=""  s ReturnData="日期^病人类型^收入合计^"_paydes
    ..e   s ReturnData=ReturnData_"^"_paydes
    .s ReturnData=ReturnData_"^收预交金^退预交金^临时凭证编号^凭证号"
    .s Date=""
    .f  s Date=$o(^TMP("DHCOPBill","IPIncomeByDate",Job,"InvDate",Date))   q:Date=""   d
    ..s paysub="0"
    ..s n=0
    ..f  s paysub=$o(^CT("CTPM",paysub))    q:paysub=""   d
    ...q:'$d(^CT("CTPM",paysub))
    ...s n=n+1
    ...i n=1  s ReturnData=ReturnData_$c(2)_$zd(Date,3)_"^所有^"_$fn($g(^TMP("DHCOPBill","IPIncomeByDate",Job,"InvDate",Date)),"",2)_"^"_$fn($g(^TMP("DHCOPBill","IPIncomeByDate",Job,"InvDate",Date,paysub)),"",2)
    ...e   s ReturnData=ReturnData_"^"_ $fn($g(^TMP("DHCOPBill","IPIncomeByDate",Job,"InvDate",Date,paysub)),"",2)
    ..s ReturnData=ReturnData_"^"_$fn($g(^TMP("DHCOPBill","IPIncomeByDate",Job,"DeptDate",Date,"Get")),"",2) 
    ..s ReturnData=ReturnData_"^"_$fn($g(^TMP("DHCOPBill","IPIncomeByDate",Job,"DeptDate",Date,"Ref")),"",2)
    ..s ReturnData=ReturnData_"^"_$g(^TMP("DHCOPBill","IPIncomeByDate",Job,"InvDatevouch",Date))_"^"
    .s paysub="0"
    .s n=0
    .f  s paysub=$o(^CT("CTPM",paysub))    q:paysub=""   d
    ..q:'$d(^CT("CTPM",paysub))
    ..s n=n+1
    ..i n=1   s ReturnData=ReturnData_$c(2)_"合计^^"_$fn($g(^TMP("DHCOPBill","IPIncomeByDate",Job,"Inv")),"",2)_"^"_$fn($g(^TMP("DHCOPBill","IPIncomeByDate",Job,"Inv",paysub)),"",2)
    ..e  s ReturnData=ReturnData_"^"_$fn($g(^TMP("DHCOPBill","IPIncomeByDate",Job,"Inv",paysub)),"",2)
    .s ReturnData=ReturnData_"^"_$fn($g(^TMP("DHCOPBill","IPIncomeByDate",Job,"Dept","Get")),"",2)
    .s ReturnData=ReturnData_"^"_$fn($g(^TMP("DHCOPBill","IPIncomeByDate",Job,"Dept","Ref")),"",2)
    .s ReturnData=ReturnData_"^^"      
    k ^TMP("DHCOPBill","IPIncomeByDate",Job)
    
    q ReturnData
}

ClassMethod IPIncomeByAdmreason(Date) As %String
{
   /// creat by zhl 2010.06.22
    ///按病人费别 统计一天的的住院收入

	s Job=$i(^TMP("DHCOPBill","IPIncomeByAdmreason"))
	k ^TMP("DHCOPBill","IPIncomeByAdmreason",Job)

	s ReturnData=""
	
	
	s Handdr="0"
	f  s Handdr=$o(^DHCJFUSERJK(0,"date",Date,Handdr))	  q:Handdr=""    d
    .s InvDr="0"
    .f  s InvDr=$o(^DHCINVPRTZY(0,"JK",Handdr,InvDr))   q:InvDr=""    d
    ..s arrcp=$p(^DHCINVPRTZY(InvDr),"^",17)
    ..s adm=$p(^DHCINVPRTZY(InvDr),"^",4)
    ..s reason=$p($g(^PAADM(adm,1)),"^",7)
    ..s paysub="0"
    ..f  s paysub=$o(^ARRCP(+arrcp,"PAYM",paysub))   q:paysub=""   d
    ...s payamt=$p(^ARRCP(+arrcp,"PAYM",paysub),"^",3)
    ...s paym=$p(^ARRCP(+arrcp,"PAYM",paysub),"^",1)
    ...s ^TMP("DHCOPBill","IPIncomeByAdmreason",Job,"Invreason",reason,paym)=$g(^TMP("DHCOPBill","IPIncomeByAdmreason",Job,"Invreason",reason,paym))+payamt
    ...s ^TMP("DHCOPBill","IPIncomeByAdmreason",Job,"Invreason",reason)=$g(^TMP("DHCOPBill","IPIncomeByAdmreason",Job,"Invreason",reason))+payamt
    .s dept="0"
    .f  s dept=$o(^DHCSFPRINTDETAIL(0,"JKDR",Handdr,dept))   q:dept=""    d
    ..s paym=$p(^DHCSFPRINTDETAIL(dept),"^",9)
    ..s payamt=$p(^DHCSFPRINTDETAIL(dept),"^",6)
    ..s adm=$p(^DHCSFPRINTDETAIL(dept),"^",4)
    ..s reason=$p($g(^PAADM(adm,1)),"^",7)
    ..s:payamt>0 ^TMP("DHCOPBill","IPIncomeByAdmreason",Job,"Deptreason",reason,"Get")=$g(^TMP("DHCOPBill","IPIncomeByAdmreason",Job,"Deptreason",reason,"Get"))+payamt
    ..s:payamt<0 ^TMP("DHCOPBill","IPIncomeByAdmreason",Job,"Deptreason",reason,"Ref")=$g(^TMP("DHCOPBill","IPIncomeByAdmreason",Job,"Deptreason",reason,"Ref"))+payamt
  

    i $d(^TMP("DHCOPBill","IPIncomeByAdmreason",Job))  d
    .s reason=""
    .f  s reason=$o(^TMP("DHCOPBill","IPIncomeByAdmreason",Job,"Invreason",reason))   q:reason=""   d
    ..s reades=$p($g(^PAC("ADMREA",reason)),"^",2)
    ..s paysub="0"
    ..s n=0
    ..f  s paysub=$o(^CT("CTPM",paysub))    q:paysub=""   d
    ...q:'$d(^CT("CTPM",paysub))
    ...s n=n+1
    ...i n=1  s ReturnData=ReturnData_$c(2)_"^"_reades_"^"_$fn($g(^TMP("DHCOPBill","IPIncomeByAdmreason",Job,"Invreason",reason)),"",2)_"^"_$fn($g(^TMP("DHCOPBill","IPIncomeByAdmreason",Job,"Invreason",reason,paysub)),"",2)
    ...e   s ReturnData=ReturnData_"^"_ $fn($g(^TMP("DHCOPBill","IPIncomeByAdmreason",Job,"Invreason",reason,paysub)),"",2)
    ..s ReturnData=ReturnData_"^"_$fn($g(^TMP("DHCOPBill","IPIncomeByAdmreason",Job,"Deptreason",reason,"Get")),"",2) 
    ..s ReturnData=ReturnData_"^"_$fn($g(^TMP("DHCOPBill","IPIncomeByAdmreason",Job,"Deptreason",reason,"Ref")),"",2)
              
    k ^TMP("DHCOPBill","OPIncomeByAdmreason",Job)
    
    q ReturnData
}

Storage Default
{
<Data name="DHCOPBillActManageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCOPBillActManageD</DataLocation>
<DefaultData>DHCOPBillActManageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCOPBillActManageD</IdLocation>
<IndexLocation>^web.DHCOPBillActManageI</IndexLocation>
<StreamLocation>^web.DHCOPBillActManageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
