Class web.DHCPE.test Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// d ##class(web.DHCPE.test).SetNotes()

ClassMethod SetNotes()
{
	;s ^OEORD(1,"I",1,"DEP",0)=1
	;s ^OEORD(1,"I",1,"DEP",1)="ddddd"
	;q
	k PLIST
	s aa=$LB("aaaa","bbbb")
	;s aa="cccc"
	&SQL(update sqluser.OE_OrdItem set OEORI_DepProcNotes=:aa where OEORI_RowID='1||1')
}

ClassMethod OutHtmlToWeb()
{
	w "<TABLE width='760'><TBODY><TR><TD>标本&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <TABLE width='100%'><TBODY><TR><TD>"
	w "<input id='TResult1' name='TResult1' type='checkbox'>"

	w "<label id='cTResult1' >满意</label>"
	w "</TD><TD>"
	w "<input id='TResult3' name='TResult3' type='checkbox'>"

	w "<label id='cTResult3'  Style='WIDTH: 127px; HEIGHT: 22px'>有颈管细胞或化生细胞</label>"
	w "</TD><TD>"
	w "<input id='TResult4' name='TResult4' type='checkbox'>"

	w "<label id='cTResult4'  Style='WIDTH: 126px; HEIGHT: 22px'>无颈管细胞或化生细胞</label>"
	w "</TD><TD></TD></TR><TR><TD>"
	w "<input id='TResult2' name='TResult2' type='checkbox'>"

	w "<label id='cTResult2' >需重取样</label>"
	w "</TD><TD>"
	w "<input id='TResult5' name='TResult5' type='checkbox'>"

	w "<label id='cTResult5'  Style='WIDTH: 125px; HEIGHT: 22px'>鳞状细胞<8000个</label>"
	w "</TD><TD>"
	w "<input id='TResult6' name='TResult6' type='checkbox'>"

	w "<label id='cTResult6'  Style='WIDTH: 127px; HEIGHT: 22px'>不清晰细胞>75%</label>"
	w "</TD><TD></TD></TR></TBODY></TABLE><TABLE width='100%'><TBODY><TR><TD>"
	w "<input id='TResult7' name='TResult7' type='checkbox'>"

	w "<label id='cTResult7'  Style='WIDTH: 187px; HEIGHT: 22px'>未见上皮内病变细胞或恶性细胞</label>"
	w "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </TD><TD>"
	w "<input id='TResult8' name='TResult8' type='checkbox'>"

	w "<label id='cTResult8'  Style='WIDTH: 227px; HEIGHT: 22px'>病原体(霉菌 滴虫 疱疹病毒 菌群转变)</label>"
	w "</TD><TD></TD><TD></TD></TR><TR></TR><TR><TD></TD><TD>"
	w "<input id='TResult9' name='TResult9' type='checkbox'>"

	w "<label id='cTResult9'  Style='WIDTH: 76px; HEIGHT: 22px'>炎症反应</label>"
	w "&nbsp;&nbsp;&nbsp; &nbsp;"
	w "<input id='TResult40' name='TResult40' type='checkbox'>"

	w "<label id='cTResult40' >轻</label>"
	w "&nbsp;&nbsp; "
	w "<input id='TResult41' name='TResult41' type='checkbox'>"

	w "<label id='cTResult41' >中</label>"
	w "&nbsp; "
	w "<input id='TResult42' name='TResult42' type='checkbox'>"

	w "<label id='cTResult42' >重</label>"
	w "</TD><TD></TD><TD></TD></TR><TR><TD></TD><TD>"
	w "<input id='TResult10' name='TResult10' type='checkbox'>"

	w "<label id='cTResult10'  Style='WIDTH: 70px; HEIGHT: 22px'>萎缩</label>"
	w "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; "
	w "<input id='TResult11' name='TResult11' type='checkbox'>"

	w "<label id='cTResult11'  Style='WIDTH: 70px; HEIGHT: 22px'>IUD反应</label>"
	w "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;"
	w "<input id='TResult12' name='TResult12' style='WIDTH: 19px; HEIGHT: 22px' type='checkbox'>"

	w "<label id='cTResult12'  Style='WIDTH: 70px; HEIGHT: 22px'>宫内膜细胞</label>"
	w "</TD><TD></TD><TD></TD></TR></TBODY></TABLE><TABLE width='100%'><TBODY><TR><TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 鳞状上皮细胞异常&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 腺上皮细胞异常&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD><TD></TD><TD></TD></TR><TR><TD><TABLE width='100%'><TBODY><TR><TD>"
	w "<input id='TResult13' name='TResult13' type='checkbox'>"

	w "<label id='cTResult13' >非典型鳞状细胞</label>"
	w "</TD><TD>"
	w "<input id='TResult14' name='TResult14' type='checkbox'>"

	w "<label id='cTResult14' >不能明确意义</label>"
	w "</TD><TD></TD><TD></TD></TR><TR><TD></TD><TD>"
	w "<input id='TResult15' name='TResult15' type='checkbox'>"

	w "<label id='cTResult15' >不除外上皮内高度病变</label>"
	w "</TD><TD></TD><TD></TD></TR><TR><TD></TD><TD></TD><TD></TD><TD></TD></TR></TBODY></TABLE></TD><TD><TABLE width='100%'><TBODY><TR><TD>"
	w "<input id='TResult16' name='TResult16' type='checkbox'>"

	w "<label id='cTResult16' >非典型腺细胞(无具体指定)</label>"
	w "</TD><TD>"
	w "<input id='TResult17' name='TResult17' type='checkbox'>"

	w "<label id='cTResult17' >宫颈管</label>"
	w "</TD><TD></TD><TD></TD></TR><TR><TD></TD><TD>"
	w "<input id='TResult18' name='TResult18' type='checkbox'>"

	w "<label id='cTResult18' >宫内膜</label>"
	w "</TD><TD></TD><TD></TD></TR><TR><TD></TD><TD>"
	w "<input id='TResult19' name='TResult19' type='checkbox'>"

	w "<label id='cTResult19' >难确定来源</label>"
	w "</TD><TD></TD><TD></TD></TR></TBODY></TABLE></TD><TD></TD><TD></TD></TR><TR><TD><TABLE width='100%'><TBODY><TR><TD>"
	w "<input id='TResult20' name='TResult20' type='checkbox'>"

	w "<label id='cTResult20' >鳞状上皮内低度病变</label>"
	w "</TD><TD></TD><TD></TD><TD></TD></TR><TR><TD>"
	w "<input id='TResult21' name='TResult21' type='checkbox'>"

	w "<label id='cTResult21' >鳞状上皮内高度病变</label>"
	w "</TD><TD></TD><TD></TD><TD></TD></TR></TBODY></TABLE></TD><TD><TABLE width='100%'><TBODY><TR><TD>"
	w "<input id='TResult22' name='TResult22' type='checkbox'>"

	w "<label id='cTResult22' >非典型腺细胞（倾向瘤变）</label>"
	w "</TD><TD>"
	w "<input id='TResult23' name='TResult23' type='checkbox'>"

	w "<label id='cTResult17' >宫颈管</label>"
	w "</TD><TD></TD><TD></TD></TR><TR><TD></TD><TD>"
	w "<input id='TResult24' name='TResult24' type='checkbox'>"

	w "<label id='cTResult24' >难确定来源</label>"
	w "</TD><TD></TD><TD></TD></TR></TBODY></TABLE></TD><TD></TD><TD></TD></TR></TBODY></TABLE><TABLE width='100%'><TBODY><TR><TD>"
	w "<input id='TResult25' name='TResult25' type='checkbox'>"

	w "<label id='cTResult25' >鳞状细胞癌</label>"
	w "</TD><TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;</TD><TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	w "<input id='TResult26' name='TResult26' type='checkbox'>"

	w "<label id='cTResult26' >腺癌</label>"
	w "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "
	w "<input id='TResult27' name='TResult27' type='checkbox'>"

	w "<label id='cTResult27' >宫颈管</label>"
	w "</TD><TD></TD></TR><TR><TD></TD><TD>&nbsp;</TD><TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	w "<input id='TResult28' name='TResult28' type='checkbox'>"

	w "<label id='cTResult28' >宫内膜</label>"
	w "</TD><TD></TD></TR><TR><TD></TD><TD></TD><TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "
	w "<input id='TResult29' name='TResult29' type='checkbox'>"

	w "<label id='cTResult29' >子宫以外</label>"
	w "</TD><TD></TD></TR><TR><TD></TD><TD></TD><TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "
	w "<input id='TResult30' name='TResult30' type='checkbox'>"

	w "<label id='cTResult30' >不能确定来源</label>"
	w "</TD><TD></TD></TR><TR><TD></TD><TD></TD><TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	w "<input id='TResult32' name='TResult32' type='checkbox'>"

	w "<label id='cTResult32' >其他恶性肿瘤</label>"
	w "&nbsp;"
	w "<input id='TDiagnosi2' name='TDiagnosi2' style='WIDTH: 135px; HEIGHT: 21px' value=''>"
	w "</TD><TD></TD></TR></TBODY></TABLE>"
	w "<label id='cTDiagnosi1'  Style='WIDTH: 71px; HEIGHT: 42px'>报告意见</label>"

	w "<textarea id='TDiagnosi1' name='TDiagnosi1' onkeydown='TDiagnosi1_keydownhandler('yWShoK5fgp9IV7LS7Kns7WrjkDAiBFQoAclFd_mrMJRBM$AJPNJLkvWnoWeI8thP');' style='WIDTH: 671px; HEIGHT: 40px'></textarea>"
	w "</TD><TD></TD><TD></TD><TD></TD></TR><TR><TD>"
	w "<input id='TResult39' name='TResult39' type='checkbox'>"

	w "<label id='cTResult39' >建议阴道活检</label>"
	w "</TD><TD></TD><TD></TD><TD></TD></TR></TBODY></TABLE></TD><TD></TD><TD></TD><TD></TD></TR><TR><TD></TD><TD></TD><TD></TD><TD></TD></TR></TBODY></TABLE>"
}

ClassMethod InsertBIllOrder()
{
	//d ##class(web.DHCPE.test).InsertBIllOrder()
	TSTART
	s Date=63383
	f  s Date=$O(^DHCPEINVPRT(0,"DATE",Date)) q:Date=""  d
	.s PrtID=0
	.f  s PrtID=$O(^DHCPEINVPRT(0,"DATE",Date,PrtID)) q:PrtID=""  d
	..s PBID=$P(^DHCPEINVPRT(PrtID),"^",3)
	..s Time=$P(^DHCPEINVPRT(PrtID),"^",12)
	..s Amt=$P(^DHCPEINVPRT(PrtID),"^",7)
	..s PBOrderSub=$O(^DHCPB(PBID,"O",0))
	..q:PBOrderSub'=""
	..s AdmID=$P(^DHCPEINVPRT(PrtID),"^",2)
	..s OrdID=$O(^OEORD(0,"Adm",AdmID,0))
	..s ItemSub=""
	..s SttDate=0
	..f  s SttDate=$O(^OEORDi(0,"ARCIM",OrdID,"23449||1",SttDate)) q:(SttDate="")||(ItemSub'="")  d
	...s Sub=0
	...f  s Sub=$O(^OEORDi(0,"ARCIM",OrdID,"23449||1",SttDate,Sub)) q:(Sub="")||(ItemSub'="")  d
	....s Stat=$P(^OEORD(OrdID,"I",Sub,1),"^",13)
	....q:Stat="4"
	....s CAmt=$P(^OEORD(OrdID,"I",Sub,2),"^",13)
	....i CAmt=$zabs(Amt) d
	.....s ItemSub=Sub
	..q:ItemSub=""
	..k PLIST
	..s PLIST(0)=PBID
	..s PLIST(3)="23449||1"
	..s PLIST(4)=OrdID_"||"_ItemSub
	..s PLIST(5)=$zabs(Amt)
	..i Amt<0 d
	...s PLIST(6)=-1
	..e  d
	...s PLIST(6)=1
	..s PLIST(7)=0
	..s PLIST(8)=Amt
	..s PLIST(9)=0
	..s PLIST(10)=0
	..s PLIST(11)=Amt
	..s PLIST(12)=Date
	..s PLIST(13)=Time
	..s PLIST(16)="P"
	..i Amt<0 d
	...s PLIST(16)="B"
	..i $D(^DHCPEINVPRT(0,"REF",PrtID))
	...s PLIST(16)="B"
	..s PLIST(17)=0
	..s PLIST(18)=0
	..s PLIST(18)=$zabs(Amt)
	..&sql(insert into Sqluser.DHC_PatBillOrder values :PLIST())
	..w AdmID_"^"_OrdID_"||"_ItemSub_"^"_PBID_"^"_SQLCODE,!
	TCOMMIT
}

// d ##class(web.DHCPE.test).CheckGroupNoItem(1580)

ClassMethod CheckGroupNoItem(PreGID)
{
	s PreIID=0
	f  s PreIID=$O(^DHCPEPreIADM(0,"PGADM",PreGID,PreIID)) q:PreIID=""  d
	.s Status=$P(^DHCPEPreIADM(PreIID),"^",8)
	.q:Status="CANCELPE"
	.q:Status="ARRIVED"
	.s BaseID=$P(^DHCPEPreIADM(PreIID),"^",1)
	.s RegNo=$P(^DHCPEPreIBI(BaseID),"^",1)
	.s TeamID=$P(^DHCPEPreIADM(PreIID),"^",3)
	.s TeamSub=$P(TeamID,"||",2)
	.s TItemSub=0
	.f  s TItemSub=$O(^DHCPEPreGADM(PreGID,"Team",TeamSub,"ORDITEM",TItemSub)) q:TItemSub=""  d
	..s ItemStatus=$P(^DHCPEPreGADM(PreGID,"Team",TeamSub,"ORDITEM",TItemSub),"^",13)
	..q:ItemStatus'="1"
	..s GTItemID=PreGID_"||"_TeamSub_"||"_TItemSub
	..i '$D(^DHCPEPreIADM(0,"GTOI",GTItemID,PreIID)) d
	
	...s ItemMastID=$P(^DHCPEPreGADM(PreGID,"Team",TeamSub,"ORDITEM",TItemSub),"^",1)
	...w $P(^ARCIM(+ItemMastID,1,1),"^",3)_"^"_ItemMastID_"^"_PreIID_"^"_RegNo_"^"_GTItemID_"^"_TeamID,!
	...;d ##class(web.DHCPE.PreItemList).IInsertItem(PreIID,"PERSON","PRE",ItemMastID,"",1)
	q
	s TeamSub=0
	f  s TeamSub=$O(^DHCPEPreGADM(PreGID,"Team",TeamSub)) q:TeamSub=""  d
	.s TeamID=PreGID_"||"_TeamSub
	.d ##class(web.DHCPE.TransAdmInfo).ConfirmAddOrdItemGT(TeamID,1)
}

ClassMethod UpdateData2()
{
	;w ##class(web.DHCPE.test).UpdateData2()
	TSTART
	s SQLCODE=0
	s id=""
	f  s id=$O(^wrzTestData(id)) q:(id="")||(SQLCODE'=0)  d
	.s data=$G(^wrzTestData(id))
	.s baseid=$O(^DHCPEPreIBI(0,"PAPMINo",id,0))
	.s preid=0
	.f  s preid=$O(^DHCPEPreIADM(0,"PIBI",baseid,preid)) q:(preid="")||(SQLCODE'=0)  d
	..s gid=$P(^DHCPEPreIADM(preid),"^",2)
	..q:gid'=$P(data,"^",2)
	..s deleitem=$P(data,"^",3)
	..s teamid=$P(data,"^",1)
	..s newGid=+teamid
	..s Gid=$O(^DHCPEGADM(0,"CRMGADM",newGid,0))
	..&SQL(update Sqluser.DHC_PE_PreIADM set PIADM_PGADM_DR=:newGid,PIADM_PGTeam_DR=:teamid where PIADM_RowID=:preid)
	..q:SQLCODE'=0
	..d ##class(web.DHCPE.TransAdmInfo).CheckGAdmCreated(preid)
	..i deleitem="1" d
	...d ##class(web.DHCPE.PreItemList).IDeleteItem(preid,"PERSON","",preid_"||1","0")
	
	TROLLBACK:SQLCODE'=0
	q:SQLCODE'=0 SQLCODE
	TCOMMIT
	q SQLCODE
}

ClassMethod TestQian()
{
	;w ##class(web.DHCPE.test).TestQian()
	s Job="wrz"
	s PatType="ALL"
	s Num=0
	s StDate=+$H-10
	s EndDate=+$H
	For Date=StDate:1:EndDate Do
	.;dhc_pe_invprt
    .Set prtrowid="0" 
	.For  Set prtrowid=$o(^DHCPEINVPRT(0,"DATE",Date,prtrowid)) Quit:prtrowid=""  Do
	..Quit:prtrowid<4517
	..Set s=$G(^DHCPEINVPRT(prtrowid))
	..Set invno=$p(s,"^",1)
	..Set initinv=$p(s,"^",9)
	..i initinv'="" d
	...s invno=$P($G(^DHCPEINVPRT(initinv)),"^",1)
	..q:invno[("DHC")
	..Set InvType="OH"
    ..;Set myUploadFlag=..CheckUpladFlag(prtrowid,InvType)
    ..;Quit:myUploadFlag=1
	..Set Num=Num+1
    ..Set ^InvoicdeUploadWRZ("InvUpload",Job,PatType,Num)=prtrowid_"^"_InvType
    q Num
	
	;w ##class(web.DHCPE.test).TestQian()
	/*
	k ^ypp
	s PIOIRowid=0
	f  s PIOIRowid=$o(^DHCPEOEITEM(13871,"OEITEM",PIOIRowid)) q:PIOIRowid=""  d
	.s itmsub=0 
	.f  s itmsub=$o(^DHCPEOEITEM(13871,"OEITEM",PIOIRowid,"TARITEM",itmsub)) q:itmsub=""  d
	..s price=+$p($g(^DHCPEOEITEM(13871,"OEITEM",PIOIRowid,"TARITEM",itmsub)),"^",4)
 	..s DailyQty=+$p($g(^DHCPEOEITEM(13871,"OEITEM",PIOIRowid,"TARITEM",itmsub)),"^",3)
 	..s uprice=+$p($g(^DHCPEOEITEM(13871,"OEITEM",PIOIRowid,"TARITEM",itmsub)),"^",2)
 	..s TaritemDR=$p($g(^DHCPEOEITEM(13871,"OEITEM",PIOIRowid,"TARITEM",itmsub)),"^",1)
 	..s PIOIFee=0
 	..f  s PIOIFee=$o(^DHCPEPreIADM(+PIOIRowid,"ORDITEM",$p(PIOIRowid,"||",2),"FEE",PIOIFee)) q:PIOIFee=""  d
 	...s PreAudit=$p(^DHCPEPreIADM(+PIOIRowid,"ORDITEM",$p(PIOIRowid,"||",2),"FEE",PIOIFee),"^",5)
 	...s ^ypp(PreAudit)=+$g(^ypp(PreAudit))+uprice

	q 0
	*/
	//&SQL(Insert Into SQLUSer.dhc_pe_papbrelate (papb_pa_dr,papb_pb_dr,papb_pbtype,PAPB_UpdateUser_DR,PAPB_UpdateDate,PAPB_UpdateTime,PA_DiscountedAmount,PA_SaleAmount,PA_FactAmount,PA_AuditedStatus,PA_AuditUser_DR,PA_AuditDate,PA_AuditTime,PA_ChargedStatus,PA_CancelUser_DR,PA_CancelDate,PA_CancelTime,PA_Remark,PA_PrivilegeMode,PA_Type,PA_Status) select PA_ADMType,PA_CRMADM,PA_GIADM,PA_ContractNo,PA_Rebate,PA_AccountAmount,PA_DiscountedAmount,PA_SaleAmount,PA_FactAmount,PA_AuditedStatus,PA_AuditUser_DR,PA_AuditDate,PA_AuditTime,PA_ChargedStatus,PA_CancelUser_DR,PA_CancelDate,PA_CancelTime,PA_Remark,PA_PrivilegeMode,PA_Type,'U' from SQLUSer.DHC_PE_PreAudit Where PA_RowId="150771")
	&SQL(Insert Into SQLUSer.dhc_pe_papbrelate (papb_pa_dr,papb_pb_dr,papb_pbtype,PAPB_UpdateUser_DR,PAPB_UpdateDate,PAPB_UpdateTime) select papb_pa_dr,papb_pb_dr,papb_pbtype,PAPB_UpdateUser_DR,PAPB_UpdateDate,PAPB_UpdateTime from SQLUSer.dhc_pe_papbrelate Where PAPB_RowId="14207")
	q 0
}

ClassMethod Change(TestResult)
{
	;w ##class(web.DHCPE.test).Change(TestResult)
	s TestResult=##class(web.DHCPE.Public.Setting).Replace(TestResult,157,"163")
	s TestResult=##class(web.DHCPE.Public.Setting).Replace(TestResult,53,"71")
	s TestResult=##class(web.DHCPE.Public.Setting).Replace(TestResult,21.50,"26.7")
	s TestResult=##class(web.DHCPE.Public.Setting).Replace(TestResult,68,"95")
	s TestResult=##class(web.DHCPE.Public.Setting).Replace(TestResult,"体重正常","体重超重")
	q TestResult
}

ClassMethod TestNameSpace(SpaceName)
{
	;w ##class(web.DHCPE.test).TestNameSpace("a")
	q ##class(%SYS.Namespace).Exists(SpaceName)

	s $ZT="SpaceErr"
	zn SpaceName
	q 1
SpaceErr
	q 0
}

ClassMethod GetLabResultArrowNew(ResultID)
{
	;w ##class(web.DHCPE.test).GetLabResultArrowNew(55616)
	s EpisodeID=$P($G(^DHCPERLT(ResultID)),"^",1)
	s LocID=$P($G(^PAADM(EpisodeID)),"^",4)

	s Arrow="1"
	i $D(^DHCPEDataEx("DHCPEResult",ResultID,"HLFlag")) d
	.s Info=$G(^DHCPEDataEx("DHCPEResult",ResultID,"HLFlag"))
	.s:Info="H" Arrow="2"
	.s:Info="L" Arrow="0"
	e  d
	.s NormalFlag=$P($G(^DHCPERLT(ResultID)),"^",7)
	.q:NormalFlag="1"
	.s ODID=$P($G(^DHCPERLT(ResultID)),"^",3)
	.;i +ODID=$G(^DHCPESetting("DHCPE","StationId_Lab")) d
	.i +ODID=$G(^DHCPESetting("DHCPE","StationId_Lab",LocID)) d
	..s NormalResult=$G(^DHCPEDataEx("DHCPEResult",ResultID,"Ranges"))
	.e  d
	..s EpisodeID=$P($G(^DHCPERLT(ResultID)),"^",1)
	..s myStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
	..s myAge=$p(myStr,"^",1)
	..s mySex=$p(myStr,"^",2)
	..s NormalResult=##class(web.DHCPE.ResultEdit).GetNormal(ODID,mySex,myAge)
	.s ResultValue=$P($G(^DHCPERLT(ResultID)),"^",4)
	.s Arrow=##class(web.DHCPE.TransResult).GetLabResultArrow(NormalResult, ResultValue)
	q Arrow
}

ClassMethod UPdateAP()
{
	;d ##class(web.DHCPE.test).UPdateAP()
	
	s ID=0
	f  s ID=$O(^User.DHCPEGSSumD(ID)) q:ID=""  d
	.s Info=$G(^User.DHCPEGSSumS(ID,1))
	.q:(Info'["(<")&&(Info'["(>")
	.s obj=##class(User.DHCPEGSSum).%OpenId(ID)
	.s PIADM=obj.GSSParref.GSIADMDR.IADMCRMADM.PIADMPIBIDR.PIBIPAPMINo
	.w ID_"^"_PIADM,!
	q
	
	s k=0
	s ID=0
	f  s ID=$O(^User.DHCPEGSSumS(ID)) q:ID=""  d
	.s Info=$G(^User.DHCPEGSSumS(ID,1))
	.q:ID=90
	.q:ID=250
	.q:(Info'["(<")&&(Info'["(>")
	.s obj=##class(User.DHCPEGSSum).%OpenId(ID)
	.s PIADM=obj.GSSParref.GSIADMDR.IADMCRMADM.PIADMPIBIDR.PIBIPAPMINo
	.w ID_"^"_PIADM,!
	q
	
	.s Length=$L(Info,$C(13,10))
	.s Flag=0
	.f i=1:1:Length d
	..s OneInfo=$P(Info,$C(13,10),i)
	..q:OneInfo["(+)"
	..i OneInfo["(>" d
	...i OneInfo[("↑") d
	....;s One=##class(web.DHCPE.Public.Setting).Replace(OneInfo,"↑"_$c(13),"↓"_$c(13))
	....;s $P(Info,$C(13),i)=One
	....s Flag=1
	..i OneInfo["(<" d
	...i OneInfo[("↓") d
	....;w OneInfo,!
	....;s One=##class(web.DHCPE.Public.Setting).Replace(OneInfo,"↓"_$c(13),"↑"_$c(13))
	....;s $P(Info,$C(13),i)=One
	....;w One,!
	....s Flag=1
	.q:Flag=0
	.s obj=##class(User.DHCPEGSSum).%OpenId(ID)
	.s PIADM=obj.GSSParref.GSIADMDR.IADMCRMADM.PIADMPIBIDR.PIBIPAPMINo
	.w ID_"^"_PIADM,!
	.;s Iobj=##class(User.DHCPEPreIADM).%OpenId(PIADM)
	.;w Iobj.PIADMPIBIDR.PIBIPAPMINo,!
	q
	.w ID,!
	.s obj=##class(User.DHCPEGSSum).%OpenId(ID)
	.s Stream=##class(%Stream.GlobalCharacter).%New()
	.d Stream.Write(Info)
	.s obj.GSSDetail=Stream
	.s sc=obj.%Save()
	.If ($System.Status.IsError(sc)) d	
	..w "-1^"_$System.Status.GetErrorText(sc),!
	
	q
	//^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId)
	s ID=0
	f  s ID=$O(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",ID)) q:ID=""  d
	.s Info=$G(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",ID))
	.s OldInfo=Info
	.s Length=$L(Info,$C(13,10))
	.s Flag=0
	.f i=1:1:Length d
	..s OneInfo=$P(Info,$C(13,10),i)
	..q:OneInfo["(+)"
	..i OneInfo["(>" d
	...i OneInfo["↑" d
	....s j=$L(OneInfo)
	....s One=$E(OneInfo,1,j-1)_" ↓"
	....s $P(Info,$C(13),i)=One
	....s Flag=1
	..i OneInfo["(<" d
	...i OneInfo["↓" d
	....s j=$L(OneInfo)
	....s One=$E(OneInfo,1,j-1)_" ↑"
	....s $P(Info,$C(13,10),i)=One
	....s Flag=1
	.q:Flag=0
	.w "OldInfo:"_OldInfo,!
	.w "NewInfo:"_Info,!
	.s ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",ID)=Info
}

ClassMethod UpdateData()
{
	;d ##class(web.DHCPE.test).UpdateData()
	s SQLCODE=0
	TSTART
	&SQL(update SQLUSer.DHC_PE_StationSummarize set SS_IADM_DR='68929' where SS_IADM_DR='68936')
	W:SQLCODE'=0 "更新SS错误"
	TROLLBACK:SQLCODE'=0
	q:SQLCODE'=0
	s ODID=$O(^OEORD(0,"Adm",6008031,0))
	w "ODID:"_ODID,!
	s OEID=""
	f  s OEID=$O(^DHCPERLT(0,"ADMOD",6008436,OEID)) q:OEID=""  d
	.s ArcimID=$P(^OEORD(+OEID,"I",$P(OEID,"||",2),1),"^",2)
	.w "ArcimID:"_OEID_"^"_ArcimID,!
	.s stt=$O(^OEORDi(0,"ARCIM",ODID,ArcimID,""))
	.i stt="" w "stt is Null:"_OEID,!
	.q:stt=""
	.s ODSub=$O(^OEORDi(0,"ARCIM",ODID,ArcimID,stt,0))
	.s NewOEID=ODID_"||"_ODSub
	.w "NewOEID:"_NewOEID,!
	.s ^TempDHCPEUpdate(NewOEID)=OEID
	.&SQL(Update SQLUSer.DHC_PE_Result set RLT_ADM_DR='6008031',RLT_OEORI_DR=:NewOEID where RLT_OEORI_DR=:OEID)
	.w:SQLCODE'=0 "更新Result错误"
	.q:SQLCODE
	.&SQL(Update SQLUser.OE_OrdItem set OEORI_ItemStat_DR='1' where OEORI_RowID=:OEID)
	.w:SQLCODE'=0 "更新Old OrdItem错误"
	.q:SQLCODE
	.&SQL(Update SQLUser.OE_OrdItem set OEORI_ItemStat_DR='6' where OEORI_RowID=:NewOEID)
	.w:SQLCODE'=0 "更新New OrdItem错误"
	TROLLBACK:SQLCODE'=0
	q:SQLCODE'=0
	TCOMMIT
}

// d ##class(web.DHCPE.test).GetNoRelateItem()

ClassMethod GetNoRelateItem()
{
	;6
	;s PIADM=PIADM_"^"_LocCode
	s ResultStream=##class(DHCENS.CheckHeal.BS.CheckHealService).GetZBTJRisResult("WPAAAM103^1610007")
	q:ResultStream="" ""
	/*流转为字符串
	s StreamLen=ResultStream.SizeGet()
    d ResultStream.Rewind()
	s XML = ResultStream.Read(StreamLen)
	s Obj=##class(DHCENS.CheckHeal.Msg.TJRisReportList).%New()
	*/
	//流直接转换为对象
	b ;10
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(ResultStream)
	d reader.Correlate("TJRisReportList","DHCENS.CheckHeal.Msg.TJRisReportList")
	s obj=##class(DHCENS.CheckHeal.Msg.TJRisReportList).%New()
	s ResultCode="",ResultContent="",ResultInfo=""
	b ;11
	While reader.Next(.obj,.sc) {
		b ;12
		set Count=obj.TJRisReports.Count()
		q:Count=0
		b ;13
		set ResultCode=obj.ResultCode
		q:ResultCode'=0
		set ResultContent=obj.ResultContent
		;for i=1:1:Count
		;{
			set TJRisReport=##class(DHCENS.CheckHeal.Msg.TJRisReport).%New()
			set TJRisReport=obj.TJRisReports.GetAt(Count)
			b ;TJRisReport.ExamSee_";诊断意见:"_TJRisReport.Diagnose
			s ResultInfo="临床诊断:"_""_";检查所见:"_TJRisReport.ExamSee_";诊断意见:"_TJRisReport.Diagnose
			q:ResultInfo="临床诊断:;检查所见:;诊断意见:"
			w ResultInfo
			s:TJRisReport.Auditor'="" TJRisReport.Auditor=$O(^SSU("SSUSR",0,"SSUSR_Name",TJRisReport.Auditor,0))
			b ;TJRisReport.Auditor
			
			s:TJRisReport.Writer'="" TJRisReport.Writer=$O(^SSU("SSUSR",0,"SSUSR_Name",TJRisReport.Writer,0))
			b ;TJRisReport.Writer
			
			s TJRisReport.AuditorDate=##class(web.DHCPE.Public.Setting).Replace(TJRisReport.AuditorDate,".","-")
			s:TJRisReport.AuditorDate'="" TJRisReport.AuditorDate=$ZDH(TJRisReport.AuditorDate,3)
			s:TJRisReport.AuditorTime'="" TJRisReport.AuditorTime=$ZTH(TJRisReport.AuditorTime)
			s TJRisReport.WriteRepotDate=##class(web.DHCPE.Public.Setting).Replace(TJRisReport.WriteRepotDate,".","-")
			s:TJRisReport.WriteRepotDate'="" TJRisReport.WriteRepotDate=$ZDH(TJRisReport.WriteRepotDate,3)
		}
}

// d ##class(web.DHCPE.test).Test()

ClassMethod GetPropValueById(clsName As %String, Id As %String) As %Status
{
	n (clsName,Id)
	s isExists=$zobjclassmethod(clsName,"%ExistsId",Id)
	q:isExists=0 0
	s obj=$zobjclassmethod(clsName,"%OpenId",Id)
	s propNumber=..GetAllPropertiesByCls(clsName,.propStr)
	q:propNumber=0
	f num=1:1:propNumber
	{
		s propName=$p(propStr,"^^",num)
		s Value=$ZOBJPROPERTY(obj,propName)
		;s ^DHCPEComponent()
	}
	q
	
	s len=pInput.SizeGet()
    d pInput.Rewind()
	s input = pInput.Read(len)
}

// d ##class(web.DHCPE.test).GenAdmGeneralRecomm(2466,71)

ClassMethod GenAdmGeneralRecomm(EpisodeID As %String, GSRowId As %String) As %String
{
	q:$g(EpisodeID)="" ""
	s UserId=1 //%session.Get("LOGON.USERID")
	s IAdm=$O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
	q:IAdm="" 0
	k ^DHCPEGenED("GetSummarize",EpisodeID)
	s loc=238 //%session.Get("LOGON.CTLOCID")
	s risStationStr="^"_$G(^DHCPESetting("DHCPE","StationId_Ris"))_"^"
	s ageSexStr=##class(web.DHCPE.ResultEdit).GetAgeSex(EpisodeID)
	s sexStr=$P(ageSexStr,"^",2)
	s EDRowId=0
	
	f  s EDRowId=$o(^DHCPEED(0,"EDLOC",loc,EDRowId)) q:EDRowId=""  d
	.q:$D(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId))
	.s activeFlag=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowId))
	.q:activeFlag'="Y"
	.s EDCRowId=0
	.f  s EDCRowId=$o(^DHCPEED(EDRowId,"EDC",EDCRowId)) q:EDCRowId=""  d 
	..s orderDetailStandardID=$P(^DHCPEED(EDRowId,"EDC",EDCRowId),"^",1)
	
	..s Normal=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",6)
	..q:Normal="Y"
	..s risFlag=0
	
	..s:risStationStr[("^"_+orderDetailStandardID_"^") risFlag=1
	..d GetAllSummarize
	
	s SQLCODE=0
	i $O(^DHCPEGS(GSRowId,"Diagnosis",0))'="" d
	.//&sql(delete from DHC_PE_GSDiagnosis where GSD_ParRef=:GSRowId and GSD_GenType='S')
	.i SQLCODE=100 s SQLCODE=0
	s EDRowId=0
	s UpdateDate=+$H
	s UpdateTime=$p($H,",",2) 
	f  s EDRowId=$o(^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)) q:EDRowId=""  d
	.q:^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)=0
	.s Advice=$p(^DHCPEED(EDRowId,"Detail"),"^",1)
	.
	.s DisplayDesc=$p(^DHCPEED(EDRowId,"1"),"^",1)
	/*
	.&sql(insert into DHC_PE_GSDiagnosis(GSD_ParRef,GSD_ED_DR,
	       GSD_UpdateUser_DR,GSD_UpdateDate,GSD_UpdateTime,GSD_GenType,GSD_Advice,GSD_Sort)
	       values(:GSRowId,:EDRowId,:UserId,:UpdateDate,:UpdateTime,'S',:Advice,'1'))
	.i SQLCODE=0 d
	..s GSDRowId=%ROWID
	..s ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSDRowId)=DisplayDesc  //Add 20080728
	..i $g(DisplayDesc)="" s DisplayDesc="空"
	..s ^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",DisplayDesc,GSDRowId)=$h   //Add 20080728
	*/
	k ^DHCPEGenED("GetSummarize",EpisodeID)
	q SQLCODE

GetAllSummarize
	//orderDetailStandardID
	//EDRowId
	s orderDetailID=$P(orderDetailStandardID,"||",1,2)
	q:orderDetailID=""
	s ItemType=$P($g(^DHCPEST(+orderDetailID,"OD",$P(orderDetailID,"||",2))),"^",2)
	s curSex=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",1)
	
	//s curSex=$P($g(^DHCPEST(+orderDetailID,"OD",$P(orderDetailID,"||",2))),"^",9)
	q:(curSex'="N")&&(curSex'=sexStr)
	i EDCRowId>1 w EDCRowId_"^"_orderDetailStandardID_"^"_curSex_"^"_sexStr,!
	
	If ItemType="N" Do CheckNumResult
	If ItemType="C" Do CheckNumResult
	If ItemType="T" Do CheckTextResult
	If ItemType="S" Do CheckTextResult
	q
	
CheckNumResult
	s Min=+$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",4)
	s Max=+$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",5)
	s rltID=0
	f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID,rltID)) q:rltID=""  d
	.s rltValue=$P($g(^DHCPERLT(rltID)),"^",4)
	.q:+rltValue<Min
	.q:+rltValue>Max
	.s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)="1"
	q
CheckTextResult
	s standardText=$P(^DHCPEST(+orderDetailStandardID,"OD",$P(orderDetailStandardID,"||",2),"ODS",$P(orderDetailStandardID,"||",3)),"^",2)
	s rltID=0
	f  s rltID=$O(^DHCPERLT(0,"PAADM_OD",EpisodeID,orderDetailID,rltID)) q:rltID=""  d
	.s rltValue=$P($g(^DHCPERLT(rltID)),"^",4)
	.q:(rltValue'=standardText)&&(risFlag=0)
	.q:(rltValue'[standardText)&&(risFlag=1)
	.s ^DHCPEGenED("GetSummarize",EpisodeID,EDRowId)="1"
	q
}

ClassMethod GetAllPropertiesByCls(clsName As %String, ByRef ret As %String) As %Numeric
{
	n (clsName,ret)
	s ret=""
	q:##class(%Library.ClassDefinition).%ExistsId(clsName)=0 0
	;s clsDef=##class(%Library.ClassDefinition).%OpenId(clsName)
	s clsDef=##class(%Library.CompiledClass).%OpenId(clsName)
	 
	s retNumber=0 
	s clsProList=clsDef.Properties
	f Num=1:1:clsProList.Count()
	{
		s clsPro=clsProList.GetAt(Num)
		s proName=clsPro.Name
		;s sqlNumber=clsPro.SqlColumnNumber
		continue:clsPro.Name["%"
		s i=$l(proName,"@")
		continue:i>1
		;continue:clsPro.Cardinality'=""
		continue:clsPro.Private=1
		;q:proSqlNumber=""
		;s items(proSqlNumber)=proName
		i ret="" s ret=proName
		e  s ret=ret_"^^"_proName
		s retNumber=retNumber+1
	}
	q retNumber
}

ClassMethod Test2(ID)
{
	s obj=##class(websys.ComponentItems).%OpenId(ID)
	w obj.ParRef,!
	
	d obj.%Close()
	q 0
	
	/*
	If $$$ISERR(sc) {
     Do $System.Status.DisplayError(sc)
 	}
 */
}

ClassMethod SaveItem() As %Status
{
	s obj=##class(User.DHCPEGADM).%New()
	s obj.GADMCRMGADM="123"
	w 1111,!
	s saveFlag=obj.%Save()
	w 2222,!
	i saveFlag=1 d
	.s subObj=##class(User.DHCPEGTeam).%New()
	.w 44444,!
	.s subObj.GTParRef=obj
	.w 33333,!
	.w subObj.%Save(),!
	w obj.%Id()
	q
}

ClassMethod Test()
{
	;d ##class(web.DHCPE.test).Test()
	s i=63956
	s PreIADM=""
	f  s PreIADM=$O(^DHCPEPreIADM(PreIADM)) q:PreIADM=""  d  ;101548,"ORDITEM"
	.s ISub=""
	.f  s ISub=$O(^DHCPEPreIADM(PreIADM,"ORDITEM",ISub)) q:ISub=""  d
	..s ItemID=$P($G(^DHCPEPreIADM(PreIADM,"ORDITEM",ISub)),"^",1)
	..i ItemID="" d
	...k ^DHCPEPreIADM(PreIADM,"ORDITEM",ISub)
	...s i=i+1
	
	w i,!
	q
	k ^TempDHCPE
	s No=""
	f  s No=$O(^PAPERi("PAPMI_PatNo",No)) q:No=""  d
	.s Ex=$E(No,1,2)
	.q:$D(^TempDHCPE(Ex))
	.s ^TempDHCPE(Ex)=""
	s Ex=""
	f  s Ex=$O(^TempDHCPE(Ex)) q:Ex=""  d
	.w Ex,!
	
	q 
	w "aaaaaaaaa"
	q
	s obj=##class(websys.Component).%OpenId("53718")
	s aa=obj.AddDefaultsEdit()
	w aa,!
	q
	s itemName="test"
	s childObj=##class(websys.ComponentItems).%New("50763")
}

// d ##class(web.DHCPE.test).GetTest("00000078")

ClassMethod GetTest(RegNo)
{
 	s String=""
	s PIBIRowId=0
	f  s PIBIRowId=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,PIBIRowId)) q:(PIBIRowId="")  d
	.s PIADMRowId="",i=0,HealthExamName="",ReqDate="",ArrivedDate="",ArrivedDate="",ReporStatus="0"
	.s PatientID="", Name="",Sex="",BirthDay="",PatientType="",Telephone="",CardNo=""
	.f  s PIADMRowId=$o(^DHCPEPreIADM(0,"PIBI",PIBIRowId,PIADMRowId),-1) q:(PIADMRowId="")||(i>0)  d
	..s PIADMStatus=$p(^DHCPEPreIADM(PIADMRowId),"^",8)
	..q:(PIADMStatus'="ARRIVED")&&(PIADMStatus'="REGISTERED") //未登记或未到达退出
	..s i=i+1
	..s HealthExamName=##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(PIADMRowId) //得到医嘱套
	..s HealthExamType=""                               //医嘱套类型
	..s ReqDate=$p(^DHCPEPreIADM(PIADMRowId),"^",22)    
	..s BookDateBeg=$p(^DHCPEPreIADM(PIADMRowId),"^",4) 
	..s BookDateEnd=$p(^DHCPEPreIADM(PIADMRowId),"^",5) 
	..s ArrivedDate=$p(^DHCPEPreIADM(PIADMRowId),"^",22) 		
	..i ReqDate'=""  s ReqDate=$ZD(ReqDate,3)    			 //登记日期 为2011-10-12格式
	..i BookDateBeg'="" s BookDateBeg=$ZD(BookDateBeg,3) 	//预约开始日期 为2011-10-12格式
	..i BookDateEnd'="" s BookDateEnd=$ZD(BookDateEnd,3) 	//预约结束日期  为2011-10-12格式
	..i ArrivedDate'="" s ArrivedDate=$ZD(ArrivedDate,3)	//到达日期 为2011-10-12格式
	..s ScheduleDate=BookDateBeg_"-"_BookDateEnd         //预约体检日期
	..s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADMRowId,0)) 
	..q:IADM=""
	..s RPRowID=$O(^DHCPERPT(0,"IADM",IADM,0))
	..q:RPRowID=""
	..s RPTStatus=$p(^DHCPERPT(RPRowID),"^",2)
	..i RPTStatus="NA"  s ReporStatus=0				//报告未出
	..i (RPTStatus="P")||(RPTStatus="A")  s ReporStatus=1  //报告已出
	..i RPTStatus="S" s ReporStatus=2				//报告已发送
	..s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	..q:PAADM=""
	..s ADMNo=$p(^PAADM(PAADM),"^",81) 				//体检号
	..s PatientID=$p(^PAADM(PAADM),"^",1) 			//患者的ID
	..s Name=$p(^DHCPEPreIBI(PIBIRowId),"^",2 )		//姓名
	..s SexID=$p(^DHCPEPreIBI(PIBIRowId),"^",3 )		
	..i SexID'=""  s Sex=$p($G(^CT("SEX",SexID)),"^",2)	//性别 
	..s PatDOB=$p(^DHCPEPreIBI(PIBIRowId),"^",4 )	  
	..i PatDOB'=""  S BirthDay=$ZD(PatDOB,3)			//出生日期，格式为：1982-10-22
	..s PatTypeDR =	$p(^DHCPEPreIBI(PIBIRowId),"^",5 )	
	..i PatTypeDR'="" s PatientType=$p(^CT("SS",PatTypeDR),"^",2) //病人类型 取自 CT_SocialStatus表
	..s Telephone=$p(^DHCPEPreIBI(PIBIRowId),"^",8)				//移动电话
	..s CardNo=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,0))		//卡号
	..s ChildSub=0
	..f  s ChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",ChildSub)) 	q:ChildSub=""  d
	...s PIOIARCDR=$P(^DHCPEPreIADM(PIADMRowId,"ORDITEM",ChildSub),"^",1)
	...s ItmMastDesc="",ORCATDesc="",ItemCatDesc=""
	...i PIOIARCDR'="" d
	....s Subscript=$p(PIOIARCDR,"||",1)
	....s Version=$p(PIOIARCDR,"||",2)
	....s ItmMastDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2) 	//医嘱名称
	....s ARCItemCat=$p($g(^ARCIM(Subscript,Version,1)),"^",10)
	....i ARCItemCat'=""  d
	.....s ItemCatDesc=$p(^ARC("IC",ARCItemCat),"^" ,2)				//医嘱子类
	.....s OrdCatDR=$p(^ARC("IC",ARCItemCat),"^" ,8) 
	.....i OrdCatDR'="" s ORCATDesc=$p(^OEC("ORCAT",OrdCatDR),"^",2)  //医嘱大类
	...s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",PIADMRowId_"||"_ChildSub,0))
	...s OEORIID="",ItemStatDR="",ExamStatus="0"
	...i CRMORowId'=""  s OEORIID=$P(^DHCPECRMO(CRMORowId),"^",1)
	...i OEORIID'=""  s ItemStatDR=$p(^OEORD($p(OEORIID,"||",1),"I",$p(OEORIID,"||",2),1),"^",13) 
	...i ItemStatDR="1" s ExamStatus="0"		//医嘱执行状态
	...i ItemStatDR="6" s ExamStatus="1"
	...i ItemStatDR="4" s ExamStatus="2"
	...s Str=ADMNo_"^"_HealthExamName_"^"_HealthExamType_"^"_ReqDate_"^"_ScheduleDate_"^"_ArrivedDate_"^"_ReporStatus_"^"_PatientID_"^"_Name_"^"_Sex_"^"_BirthDay_"^"_PatientType_"^"_Telephone_"^"_CardNo_"^"_ORCATDesc_"^"_ItemCatDesc_"^"_ItmMastDesc_"^"_ExamStatus
	...i String=""  s String=Str
	...else  s String=String_"@"_Str
 q String
}

// d ##class(web.DHCPE.test).TestBit()

ClassMethod TestBit()
{
	s a=""
	s $Bit(a,1000)=9
	w $Bit(a,1000),!
	w $bitcount(a),!
	w a,!
}

ClassMethod TestGlobalCharacter()
{
	;d ##class(web.DHCPE.Test).TestGlobalCharacter()
	;%Stream.GlobalCharacter
	s aa=##class(%Stream.GlobalCharacter).%New()
	d aa.Write("aaaaaaaaaaa")
	s len=aa.SizeGet()
    d aa.Rewind()
	s input = aa.Read(len)
	w input
}

// d ##class(web.DHCPE.test).CustomTest(rs.GetDataByName("ST_Code"),rs.GetDataByName("ST_RowId"),"市")

ClassMethod CustomTest(ElementID, DefaultValue, Type)
{
	if Type="Y"{
		Write "<input id='"_ElementID_"' name='"_ElementID_"' "
		Write " style='WIDTH: 100px; HEIGHT: 24px' value='"_DefaultValue_"'>"
		Quit
	}else{
		Write "<select id='"_ElementID_"' name='"_ElementID_"' size=1 style='WIDTH: 180px; HEIGHT: 24px'>"
		Write "<option  value=''></option>" //输出一个空的选择项
		Set SexID=0
		For  Set SexID=$O(^CT("SEX",SexID)) Quit:SexID=""  Do
		.Set SexDesc=$P(^CT("SEX",SexID),"^",2)
		.If SexID=DefaultValue Write "<option value="_SexID_" selected>"_SexDesc_"</option>"
		.Else  Write "<option value="_SexID_">"_SexDesc_"</option>"
		Write "</select>"
		Quit
	}
}

ClassMethod TestOK()
{
	;d ##class(web.DHCPE.test).TestOK()
	w $$$OK
}

ClassMethod WorkLoadTest(sday, eday)
{
	/*
	//d ##class(web.DHCPE.test).WorkLoadTest("2011-12-28","2011-12-28")
	;HPToData(sday,eday)   ;取体检费用   yx
                      ;通过DHC_PE_INVPRT 表中 找到 帐单 的ROWID ,DHC_PE_PAPBRelate找到DHC_PE_PreAudit  ID
                      ;通过DHC_PE_PreAudit  ID在DHC_PE_PreIOrdItemFee和DHC_PE_PreIOrdEntFee取各项费用
                      ;DHC_PE_PreIOrdItem  取医嘱项
                      ;存在问题?团体检查可能病人没到达就打发票?导致在DHC_PE_CRMOrder表中取不到医嘱和接收科室
 k (sday,eday)
 s sday=$zdh(sday,3)
 s eday=$zdh(eday,3)
 f day=sday:1:eday d
 .s rprowid=0 f  s rprowid=$o(^DHCPEUSERREPORT(0,"DATE",day,rprowid)) q:rprowid=""  d         ;DHC_PE_USERREPORT
 ..s prtid=0 f  s prtid=$o(^DHCPEINVPRT(0,"REPORT",rprowid,prtid)) q:prtid=""  d
 ...w !,prtid
 ...;s prtid=0 f  s prtid=$o(^DHCPEINVPRT(0,"DATE",day,prtid)) q:prtid=""  d
 ...q:$d(^DHCWorkLoad(0,"invprtid1",prtid))
 ...b ;prtid
 ...s prtrpflag=$p(^DHCPEINVPRT(prtid),"^",8)      ;发票状态Normal正常strike作废
 ...s prtinvdate=$p(^DHCPEINVPRT(prtid),"^",15)      ;打发票日期
 ...s prtinvtime=$p(^DHCPEINVPRT(prtid),"^",16)      ;打发票时间
 ...;q:prtrpflag'="N"
 ...;s piadmid=$p(^DHCPEIADM(iadmdr),"^",4)
 ...;s admStatus=$p(^DHCPEIADM(iadmdr),"^",8)     
 ...;q:admStatus'="ARRIVED"      ;退出状态不为到达的  到达之后PAADM表中有数据
 ...s PaadmId=$p(^DHCPEINVPRT(prtid),"^",2)   ;PAADM rowid
 ...///q:PaadmId'="6240611"    ;"256656"      ;"261868"
 ...s Papmidr=$p(^PAADM(PaadmId),"^",1)
 ...s admtype=$p(^PAADM(PaadmId),"^",2)   ;病人类型
 ...;w !,admtype
 ...q:admtype'="H"
 ...s Patdepdr=$p(^PAADM(PaadmId),"^",4)   ;病人科室
 ...s pbrowid=$p(^DHCPEINVPRT(prtid),"^",3)    ;帐单ID
 ...s papbrowid=0 f  s papbrowid=$o(^DHCPEPAPBR(0,"PBDR",pbrowid,papbrowid)) q:papbrowid=""  d     ;DHC_PE_PAPBRelate
 ....s papbpaid=$p(^DHCPEPAPBR(papbrowid),"^",1)       ;审核表DHC_PE_PreAudit ID
 ....s mlh=$p(^DHCPB(pbrowid),"^",8)
 ....;W !,"pbrowid"_pbrowid_"papbpaid"_papbpaid_"MLH:"_mlh
 ....d InsHPOrdItemFeeDate
 ....d InsHPOrdEntFeeDate
 q
 
InsHPOrdItemFeeDate     ;体检个人项目数据?不包含套餐数据   DHC_PE_PreIOrdItemFee_
 s piadmid=0 f  s piadmid=$o(^DHCPEPreIADM(0,"PAORDITEM",papbpaid,piadmid)) q:piadmid=""  d
 .s PIOISub=0 f  s PIOISub=$o(^DHCPEPreIADM(0,"PAORDITEM",papbpaid,piadmid,PIOISub)) q:PIOISub=""  d
 ..s PIOIRowid=piadmid_"||"_PIOISub
 ..s CRMOID=0
 ..i $d(^DHCPECRMO(0,"CRMORI",PIOIRowid)) d
 ...s CRMOID=$o(^DHCPECRMO(0,"CRMORI",PIOIRowid,CRMOID))
 ...s OEORIDR=$P(^DHCPECRMO(CRMOID),"^",1)   ;DHC_PE_CRMOrder 记录DHC_PE_PreIOrdItem中对应的医嘱OEORITEM
 ...;q:$p(^DHCPECRMO(CRMOID),"^",4)'="P"  ;退出未付项目
 ...s ordrowid=$p(OEORIDR,"||",1)
 ...s ordsubrowid=$p(OEORIDR,"||",2)
 ...s OrdDepdr=$p(^OEORD(ordrowid,"I",ordsubrowid,1),"^",3)   ;医嘱科室
 ...s RecDepdr=$p(^OEORD(ordrowid,"I",ordsubrowid,3),"^",6)    ;接收科室
 ...s RecDocdr=$P($G(^OEORD(ordrowid,"I",ordsubrowid,6)),"^",9)   ;执行医生
 ...s OrdDocdr=$P($G(^OEORD(ordrowid,"I",ordsubrowid,1)),"^",11)  ;下医嘱医生
 ..e  d
 ...s OEORIDR="",OrdDepdr="",RecDepdr="",RecDocdr="",OrdDocdr=""
 ..s OEORIBilled="P"
 ..s ItmMastDr=$p(^DHCPEPreIADM(piadmid,"ORDITEM",PIOISub),"^",1)     ;医嘱项  DHC_PE_PreIOrdItem
 ..q:ItmMastDr["&"
 ..s type=$p(^DHCPEPreIADM(piadmid,"ORDITEM",PIOISub),"^",16)
 ..//q:$p(^DHCPEPreIADM(piadmid,"ORDITEM",PIOISub),"^",16)'="1"    ;核实状态  //MLH
 ..//Add By MLH
 ..s PIOIStat=$p(^DHCPEPreIADM(piadmid,"ORDITEM",PIOISub),"^",16)
 ..s NoFee=0
 ..i PIOIStat'=1 d
 ...s XDate=$p($g(^DHCPEDataEx("DHCPEPreIOrdItem","XDate","XTime",PIOIRowid)),"^",1)
 ...s XTime=$p($g(^DHCPEDataEx("DHCPEPreIOrdItem","XDate","XTime",PIOIRowid)),"^",2)
 ...i (XDate<prtinvdate)!((XDate=prtinvdate)&(XTime<prtinvtime)) s NoFee=1
 ..//b    //1111
 ..q:NoFee=1   //未收费退出
 ..///b  //222
 ..s ARCIMRowid=$P(ItmMastDr,"||",1)
 ..s ARCIMSub=$P(ItmMastDr,"||",2)
 ..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)
 ..s ItemCatDESC=$P($G(^ARC("IC",ItemCatDR)),"^",2)
 ..s BillSubDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",9)
 ..s BillGrpRowid=$P(BillSubDR,"||",1)
 ..s BillGrpSub=$P(BillSubDR,"||",2)
 ..s reportdr=$p(^DHCPEINVPRT(prtid),"^",13)     ;DHC_PE_USERREPORT  id 更新结算日期用
 ..;q:$p(^DHCPECRMO(CRMOID),"^",4)'="P"  ;退出未付项目
 ..s PIOIFSub=0 f  s PIOIFSub=$o(^DHCPEPreIADM(0,"PAORDITEM",papbpaid,piadmid,PIOISub,PIOIFSub)) q:PIOIFSub=""  d
 ...;q:$d(^DHCWorkLoad(0,"PIORDITEM",piadmid_"||"_PIOISub_"||"_PIOIFSub))   ;判断数据是否已插入过
 ...s price=$p(^DHCPEPreIADM(piadmid,"ORDITEM",PIOISub,"FEE",PIOIFSub),"^",2)
 ...s DailyQty=1 
 ...i prtrpflag'="N" d
 ....s price=0-$g(price)
 ....s DailyQty=-1
 ...b ;all
 ...q
 ...;w !,"piadmid"_piadmid_"||"_PIOISub_"||"_PIOIFSub_" price="_price_" type="_type
 ...;i piadmid="1558" W !,"pbrowid"_pbrowid_"papbpaid"_papbpaid_" OEORIDR "_OEORIDR_" price="_price
 ...&sql(insert into DHC_WorkLoad(WorkLoad_PAADM_DR,WorkLoad_PAPMI_DR,WorkLoad_Type,
 WorkLoad_RecDep_DR,WorkLoad_PatDep_DR,WorkLoad_ResDep_DR,WorkLoad_RecDoc_DR,WorkLoad_ResDoc_DR,
 WorkLoad_OEORI_DR,WorkLoad_OrdStatus,WorkLoad_ItemOrd_DR,WorkLoad_BillGrp_DR,WorkLoad_BillSub_DR,WorkLoad_ItemCat_DR,WorkLoad_ARPBL_DR,
 WorkLoad_TotalPrice,workload_quantity,WorkLoad_ReceiptO_DR,WorkLoad_FlagDate) 
 values (:PaadmId,:Papmidr,:admtype,:RecDepdr,:Patdepdr,:OrdDepdr,:RecDocdr,:OrdDocdr,
 :OEORIDR,:OEORIBilled,:ItmMastDr,:BillGrpRowid,:BillSubDR,:ItemCatDR,:pbrowid,
 :price,:DailyQty,:prtid,:day))
 ...b ;Item:SQLCODE,!
 ...i SQLCODE=0 d
 ....s WLRowid=+$g(%ROWID)
 ....s ^DHCWorkLoad(0,"invprtid1",prtid)=WLRowid
 ....;s ^DHCWorkLoad(0,"PIORDITEM",piadmid_"||"_PIOISub_"||"_PIOIFSub)=WLRowid
 q
 
InsHPOrdEntFeeDate     ;体检套餐数据
 s prepiadmid=0 f  s prepiadmid=$o(^DHCPEPreIADM(0,"PAORDENT",papbpaid,prepiadmid)) q:prepiadmid=""  d
 .;w !," pbrowid"_pbrowid_" papbpaid"_papbpaid_" MLH:"_mlh_" prepiadmid"_prepiadmid
 .s PIOESub=0 f  s PIOESub=$o(^DHCPEPreIADM(0,"PAORDENT",papbpaid,prepiadmid,PIOESub)) q:PIOESub=""  d
 ..s PIOIEntRowid=prepiadmid_"||"_PIOESub
 ..;w !,PIOIEntRowid
 ..//Add By MLH
 ..s PIOEStat=$p(^DHCPEPreIADM(prepiadmid,"ORDENT",PIOESub),"^",9)
 ..s NoFee=0
 ..i PIOEStat'=1 d
 ...s XDate=$p($g(^DHCPEDataEx("DHCPEPreIOrdEnt","XDate","XTime",PIOIEntRowid)),"^",1)
 ...s XTime=$p($g(^DHCPEDataEx("DHCPEPreIOrdEnt","XDate","XTime",PIOIEntRowid)),"^",2)
 ...i (XDate<prtinvdate)!((XDate=prtinvdate)&(XTime<prtinvtime)) s NoFee=1
 ..q:NoFee=1   //未收费退出
 ../////////////
 ..s PIOISub=0 f  s PIOISub=$o(^DHCPEPreIADM(0,"OrdEnt",PIOIEntRowid,prepiadmid,PIOISub)) q:PIOISub=""  d
 ...s PIOIRowid=prepiadmid_"||"_PIOISub     ;DHC_PE_PreIOrdItem   ID
 ...s CRMOID=0
 ...;i '$d(^DHCPECRMO(0,"CRMORI",PIOIRowid)) w !,"PIOIRowid"_PIOIRowid
 ...i $d(^DHCPECRMO(0,"CRMORI",PIOIRowid)) d
 ....s CRMOID=$o(^DHCPECRMO(0,"CRMORI",PIOIRowid,CRMOID))
 ....s OEORIDR=$P(^DHCPECRMO(CRMOID),"^",1)   ;DHC_PE_CRMOrder 记录DHC_PE_PreIOrdItem中对应的医嘱OEORITEM
 ....;q:$p(^DHCPECRMO(CRMOID),"^",4)'="P"  ;退出未付项目
 ....s ordrowid=$p(OEORIDR,"||",1)
 ....s ordsubrowid=$p(OEORIDR,"||",2)
 ....s OrdDepdr=$p(^OEORD(ordrowid,"I",ordsubrowid,1),"^",3)   ;医嘱科室
 ....s RecDepdr=$p(^OEORD(ordrowid,"I",ordsubrowid,3),"^",6)    ;接收科室
 ....s RecDocdr=$P($G(^OEORD(ordrowid,"I",ordsubrowid,6)),"^",9)   ;执行医生
 ....s OrdDocdr=$P($G(^OEORD(ordrowid,"I",ordsubrowid,1)),"^",11)  ;下医嘱医生
 ...e  d
 ....s OEORIDR="",OrdDepdr="",RecDepdr="",RecDocdr="",OrdDocdr=""
 ...s OEORIBilled="P"
 ...s ItmMastDr=$p(^DHCPEPreIADM(prepiadmid,"ORDITEM",PIOISub),"^",1)     ;医嘱项  DHC_PE_PreIOrdItem
 ...q:ItmMastDr["&"        ;错误代码
 ...s type=$p(^DHCPEPreIADM(prepiadmid,"ORDITEM",PIOISub),"^",16)
 ...w !,"prepiadmid"_prepiadmid_"PIOISub"_PIOISub_"papbpaid"_papbpaid_"type="_type
 ...//q:$p(^DHCPEPreIADM(prepiadmid,"ORDITEM",PIOISub),"^",16)'="1"    ;核实状态   //MLH
 ...s ARCIMRowid=$P(ItmMastDr,"||",1)
 ...s ARCIMSub=$P(ItmMastDr,"||",2)
 ...s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)
 ...s ItemCatDESC=$P($G(^ARC("IC",ItemCatDR)),"^",2)
 ...s BillSubDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",9)
 ...s BillGrpRowid=$P(BillSubDR,"||",1)
 ...s BillGrpSub=$P(BillSubDR,"||",2)
 ...s reportdr=$p(^DHCPEINVPRT(prtid),"^",13)     ;DHC_PE_USERREPORT  id 更新结算日期用
 ...;q:$p(^DHCPECRMO(CRMOID),"^",4)'="P"  ;退出未付项目
 ...;w !,PIOIEntRowid
 ...
 ...s PIOIFSub=0 f  s PIOIFSub=$o(^DHCPEPreIADM(0,"PAORDENT",papbpaid,prepiadmid,PIOESub,PIOIFSub)) q:PIOIFSub=""  d
 ....;q:$d(^DHCWorkLoad(0,"PIPAORDENT",piadmid_"||"_PIOISub_"||"_PIOIFSub))   ;判断数据是否已插入过
 ....zn "websrc"
 ....d ##class(web.DHCPE.OrdSetsPrice).SplitOrdSetPrice(PIOIEntRowid)
 ....zn "meddata"
 ....s price=$g(^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",PIOIEntRowid,PIOIRowid))      ;暂从临时GLOBAL里取 实收费用
 ....;s ^lisatest("0703","PRICE",PIOIRowid)=PIOIRowid_"^"_price
 ....;w !"PIOIRowid"_PIOIRowid_"  PIOIEntRowid "_PIOIEntRowid_
 ....s DailyQty=1 
 ....i prtrpflag'="N" d
 .....s price=0-$g(price)
 .....s DailyQty=-1
 ....s price=0-(0-$g(price))
 ....b ;all
 ....q
 ....;;i type=4 w !,"PIOIEntRowid "_PIOIEntRowid_" PIOIRowid "_PIOIRowid_" price="_price_" type="_type
 ....&sql(insert into DHC_WorkLoad(WorkLoad_PAADM_DR,WorkLoad_PAPMI_DR,WorkLoad_Type,
 WorkLoad_RecDep_DR,WorkLoad_PatDep_DR,WorkLoad_ResDep_DR,WorkLoad_RecDoc_DR,WorkLoad_ResDoc_DR,
 WorkLoad_OEORI_DR,WorkLoad_OrdStatus,WorkLoad_ItemOrd_DR,WorkLoad_BillGrp_DR,WorkLoad_BillSub_DR,WorkLoad_ItemCat_DR,WorkLoad_ARPBL_DR,
 WorkLoad_TotalPrice,workload_quantity,WorkLoad_ReceiptO_DR,WorkLoad_FlagDate) 
 values (:PaadmId,:Papmidr,:admtype,:RecDepdr,:Patdepdr,:OrdDepdr,:RecDocdr,:OrdDocdr,
 :OEORIDR,:OEORIBilled,:ItmMastDr,:BillGrpRowid,:BillSubDR,:ItemCatDR,:pbrowid,
 :price,:DailyQty,:prtid,:day))
 ....b ;Ent:SQLCODE,!
 ....i SQLCODE=0 d
 .....s WLRowid=+$g(%ROWID)
 .....s ^DHCWorkLoad(0,"invprtid1",prtid)=WLRowid
 .....;s ^DHCWorkLoad(0,"PIPAORDENT",piadmid_"||"_PIOISub_"||"_PIOIFSub)=WLRowid
 ....e  d
 .....W !,"SQLCODE"_SQLCODE
 q*/
}

// d ##class(web.DHCPE.test).ExportTTAB("/tem/DHCPETTAB.txt")

ClassMethod ExportTTAB(fileName)
{
	s f=##class(%File).%New(fileName)
	d f.Open("WSN")
	s i=0
	s ID=""
	f  s ID=$O(^TTAB("TC",ID)) q:ID=""  d
	.s Info=$G(^TTAB("TC",ID))
	.s Desc=$P(Info,"\",1)
	.s OneSt=ID_$c(9)_Desc
 	.d f.WriteLine(OneSt)
 	d f.Close()
}

// d ##class(web.DHCPE.test).AAAAAAAAA()

ClassMethod AAAAAAAAA()
{
	s EDRowId=2528
	s BBSub=0
	f  s BBSub=$O(^DHCPEED(EDRowId,"EDBB",BBSub)) q:BBSub=""   d
	.s BBEDID=$P(^DHCPEED(EDRowId,"EDBB",BBSub),"^",1)
	.w BBEDID,!
}

// d ##class(web.DHCPE.test).ExportResult()

ClassMethod ExportResult()
{
	s rltid=0
	w "姓名^性别^年龄^体检日期^检查项目^细项名称^结果",!
	f  s rltid=$O(^DHCPERLT(rltid)) q:rltid=""  d
	.q:"LabSpecNo"=rltid
	.s PAADM=$P(^DHCPERLT(rltid),"^",1)
	.q:PAADM=""
	.s ArcimID=$P(^DHCPERLT(rltid),"^",2)
	.q:ArcimID=""
	.s ODID=$P(^DHCPERLT(rltid),"^",3)
	.q:ODID=""
	.s rlt=$P(^DHCPERLT(rltid),"^",4)
	.q:rlt=""
	.s papmiid=$P(^PAADM(PAADM),"^",1)
	.s AdmDate=$P(^PAADM(PAADM),"^",6)
	.s AdmDate=$ZD(AdmDate,3)
	.s Name=$P(^PAPER(papmiid,"ALL"),"^",1)
	.s Dob=$P(^PAPER(papmiid,"ALL"),"^",6)
	.s Age=+##class(web.DHCLCNUREXCUTE).CalAge(Dob,+$H)
	.s Sex=$P(^PAPER(papmiid,"ALL"),"^",7)
	.s:Sex'="" Sex=$P(^CT("SEX",Sex),"^",2)
	.s ArcimDesc=$P(^ARCIM(+ArcimID,1,1),"^",2)
	.s ODDesc=$P($G(^DHCPEST(+ODID,"OD",$P(ODID,"||",2))),"^",1)
	.q:ODDesc=""
	.w Name_"^"_Sex_"^"_Age_"^"_AdmDate_"^"_ArcimDesc_"^"_ODDesc_"^"_rlt,!
}

// d ##class(web.DHCPE.test).UpdateRecLoc()

ClassMethod UpdateRecLoc()
{
	s PID=0
	s i=0
	TSTART
	s SQLCODE=0
	f  s PID=$O(^DHCPEPreIADM(0,"ItmMast","33059||1",PID)) q:(PID="")||(SQLCODE'=0)  d
	.s PSub=0
	.f  s PSub=$O(^DHCPEPreIADM(0,"ItmMast","33059||1",PID,PSub)) q:(PSub="")||(SQLCODE'=0)  d
	..s Stat=$P(^DHCPEPreIADM(PID,"ORDITEM",PSub),"^",16)
	..q:Stat'="1"
	..s RecLoc=$P(^DHCPEPreIADM(PID,"ORDITEM",PSub),"^",17)
	..q:RecLoc="616"
	..s Status=$P(^DHCPEPreIADM(PID),"^",8)
	..s PreItemID=PID_"||"_PSub
	..s CRMOrder=$O(^DHCPECRMO(0,"CRMORI",PreItemID,0))
	..s OEOrdItemID=""
	..i CRMOrder'="" d
	...s OEOrdItemID=$P(^DHCPECRMO(CRMOrder),"^",1)
	..&SQL(Update Sqluser.DHC_PE_PreIOrdItem set PIOI_ItemRecLoc_DR='616' where PIOI_RowID=:PreItemID)
	..q:SQLCODE'=0
	..i OEOrdItemID'="" d
	...&SQL(Update Sqluser.OE_OrdItem set OEORI_RecDep_DR='616' where OEORI_RowID=:OEOrdItemID)
	...q:SQLCODE'=0
	..;w PID,!
	..i Status="ARRIVED" d
	...s LocID=$P(^DHCPEPreIADM(PID),"^",26)
	...s BaseID=$P(^DHCPEPreIADM(PID),"^",1)
	...s RegNo=$P(^DHCPEPreIBI(BaseID),"^",1)
	...w LocID_"^"_RegNo,!
	TROLLBACK:SQLCODE'=0
	TCOMMIT:SQLCODE=0
	w SQLCODE
}

ClassMethod GetGTotalFee(PGADM)
{
	s TAmt=0
	s AID=0
	f  s AID=$O(^DHCPEPreA(0,"CRMADM","G",PGADM,AID)) q:AID=""  d
	.s Flag=$p($g(^DHCPEPreA(AID)),"^",21)
	.q:Flag="NU"
	.s OneAmt=$p(^DHCPEPreA(AID),"^",9)
	.s TAmt=TAmt+OneAmt
	q TAmt
}

}
