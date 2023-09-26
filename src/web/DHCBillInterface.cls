Import SQLUser

/// Creator: Lid
/// CreatDate: 2011-08-17
/// Description: 计费组对外接口
Class web.DHCBillInterface Extends BILL.COM.Abstract
{

/// Creator: Lid
/// CreatDate: 2011-08-17
/// Modify: ZhYW 2018-12-13
/// Description: 根据医嘱Rowid判断该医嘱是否退过费--仅供门诊调用
/// Input: oeitm:医嘱Rowid
/// Return: status:医嘱退费状态 (0:没有退费,1:部分退费,2:全部退费,其他:异常)
/// Debug: w ##class(web.DHCBillInterface).IOrdItmInvStatusByOeoriDR("3927||4")
ClassMethod IOrdItmInvStatusByOeoriDR(oeitm As %String) As %String
{
	quit:($l(oeitm,"||")'=2) -1
	
	//获取第一条结算账单
	set firPBRowId=""
	set pb=0
	for  set pb=$o(^DHCPBi(0,"OEORI",oeitm,pb))  quit:((pb="")||(firPBRowId'=""))  do
	.set pbData=$g(^DHCPB(pb))
	.quit:(pbData="")
	.set payedFlag=$p(pbData,"^",16)
	.quit:(payedFlag'="P")
	.set firPBRowId=pb
	quit:(firPBRowId="") 0

	//获取最后一条结算账单
	set pboRowId=""
	set pb=""
	for  set pb=$o(^DHCPBi(0,"OEORI",oeitm,pb),-1)  quit:((pb="")||(pboRowId'=""))  do
	.set pbData=$g(^DHCPB(pb))
	.quit:(pbData="")
	.set payedFlag=$p(pbData,"^",16)
	.quit:(payedFlag'="P")
	.set pbo=$o(^DHCPBi(0,"OEORI",oeitm,pb,""),-1)
	.set pboRowId=pb_"||"_pbo
	quit:(pboRowId="") 0
	quit:(firPBRowId=$p(pboRowId,"||",1)) 0

	set pboData=$g(^DHCPB(+pboRowId,"O",$p(pboRowId,"||",2)))
	set billQty=+$p(pboData,"^",5)
	set refundQty=+$p(pboData,"^",6)
	set qty=billQty+refundQty
	set status=$s((qty>0):1,1:2)

	quit status
}

/// Creator: Lid
/// CreatDate: 2011-10-08
/// Description: 根据发票号获取发票的支付方式(协和医院,给医保组的接口,主要用于实现医保病人的多种支付方式)
/// Input: PrtRowIdStr:发票表RowID(DHC_InvPrt)串,以"^"分割
/// 	   ExpStr:扩展串(格式:"^^^^^^^")
/// Return:	发票1_$c(2)_发票2_$c(2)_...
/// 			单张发票格式:发票表Rowid_$c(1)_支付方式RowID_"^"_支付方式名称_"^"_支付方式金额_$c(1)_支付方式RowID_"^"_支付方式名称_"^"_支付方式金额_$c(1)_...
/// 			(注:如果指定的发票不存在返回空)
/// Debug: w ##class(web.DHCBillInterface).IGetPrtInvPayMode("179896^179897^","^^^^^")
ClassMethod IGetPrtInvPayMode(PrtRowIdStr As %String, ExpStr As %String) As %String
{
	set rtn=""
	set InvCount=$l(PrtRowIdStr,"^")
	for i=1:1:InvCount d
	.set PrtRowID=+$p(PrtRowIdStr,"^",i)
	.quit:((PrtRowID=0) || ('$d(^DHCINVPRT(PrtRowID))))
	.set SingInv=PrtRowID
	.set IPM=0
	.for  set IPM=$o(^DHCINVPRT(PrtRowID,"P",IPM)) quit:(IPM="")  do
	..set tmp=$g(^DHCINVPRT(PrtRowID,"P",IPM))
	..set PayMDR=$p(tmp,"^",1)
	..set PayMDesc=$p(^CT("CTPM",PayMDR),"^",2)
	..set PayMAmt=+$p(tmp,"^",3)
	..quit:(+PayMAmt=0)    //Lou 2011-10-11
	..set SingInv=SingInv_$c(1)_PayMDR_"^"_PayMDesc_"^"_PayMAmt
	.set rtn=$s((rtn=""):SingInv,1:(rtn_$c(2)_SingInv))
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2015-02-27
/// Description: 根据Adm/账单号查询病人费用分类(大类/子类)
/// Input:	Adm:PA_Adm.RowId, Bill:DHC_PatientId.RowId
/// 		ItmFlag: OC:门诊子分类,	TOC:门诊大类(默认)
/// 				 IC:住院子分类,	TIC:住院大类
/// 				 AC:会计子分类,	TAC:会计大类
/// 				 MC:病案首页子分类,	TMC:病案首页大类 (注意：病案首页分类需根据医院具体情况取)
/// 				 MCNew:新病案首页子分类, TMCNew:新病案首页大类
/// 		ExpStr:扩展字符串
/// Return:	分类Rowid^分类Code^分类名称^分类金额！分类Rowid^分类Code^分类名称^分类金额!....
/// Other:	Adm优先级高于Bill
/// Debug:	w ##class(web.DHCBillInterface).IGetTarItemCate("","7630","TIC","^^^^") 
ClassMethod IGetTarItemCate(Adm As %String, Bill As %String, ItmFlag As %String, ExpStr As %String = "")
{
	s rtn=""
	q:((+Adm=0)&&(+Bill=0)) rtn
	
	k ItmCateAry
	s:(ItmFlag="") ItmFlag="TOC"
	
	i (Adm'="") d
	.s PBDR=0
	.f  s PBDR=$o(^DHCPB(0,"ADM",Adm,PBDR)) q:(PBDR="")  d
	..d GetTarItemCateByBill(PBDR)
	e  i (Bill'="") d
	.d GetTarItemCateByBill(Bill)
	
	s ItmCateDR=""
	f  s ItmCateDR=$o(ItmCateAry(ItmCateDR)) q:(ItmCateDR="")  d
	.s ItmCateAmt=ItmCateAry(ItmCateDR)
	.q:(+ItmCateAmt=0)
	.s ItmCateAmt=$fn(ItmCateAmt,"",2)
	.s ItmCateCode=$p(^DHCTarC(ItmFlag,ItmCateDR),"^",1)
	.s ItmCateDesc=$p(^DHCTarC(ItmFlag,ItmCateDR),"^",2)
	.s tmp=ItmCateDR_"^"_ItmCateCode_"^"_ItmCateDesc_"^"_ItmCateAmt
	.s rtn=$s((rtn=""):tmp,1:(rtn_"!"_tmp))
	
	k ItmCateAry
	
	q rtn
	
GetTarItemCateByBill(PBRowID)
	s PBO=0
	f  s PBO=$o(^DHCPB(PBRowID,"O",PBO)) q:(PBO="")  d
	.s PBD=0
	.f  s PBD=$o(^DHCPB(PBRowID,"O",PBO,"D",PBD)) q:(PBD="")  d
	..s PBDData=$g(^DHCPB(PBRowID,"O",PBO,"D",PBD))
	..s Amt=$p(PBDData,"^",7)
	..s TarItmDR=$p(PBDData,"^",3)
	..//病案首页子类
	..i (ItmFlag="MC") d
	...s ItmCateSub=$p(^DHCTARI(TarItmDR),"^",6)
	...s ItmCateAry(ItmCateSub)=+$g(ItmCateAry(ItmCateSub))+Amt
	..//病案首页大类
	..i (ItmFlag="TMC") d
	...s ItmCateSub=$p(^DHCTARI(TarItmDR),"^",6)
	...s ItmCate=$p(^DHCTarC("MC",ItmCateSub),"^",3)
	...s ItmCateAry(ItmCate)=+$g(ItmCateAry(ItmCate))+Amt
	..//住院分类
	..i (ItmFlag="IC") d
	...s ItmCateSub=$p(^DHCTARI(TarItmDR),"^",14)
	...s ItmCateAry(ItmCateSub)=+$g(ItmCateAry(ItmCateSub))+Amt
	..i (ItmFlag="TIC") d
	...s ItmCateSub=$p(^DHCTARI(TarItmDR),"^",14)
	...s ItmCate=$p(^DHCTarC("IC",ItmCateSub),"^",3)
	...s ItmCateAry(ItmCate)=+$g(ItmCateAry(ItmCate))+Amt
	..//门诊分类
	..i (ItmFlag="OC") d
	...s ItmCateSub=$p(^DHCTARI(TarItmDR),"^",15)
	...s ItmCateAry(ItmCateSub)=+$g(ItmCateAry(ItmCateSub))+Amt
	..i (ItmFlag="TOC") d
	...s ItmCateSub=$p(^DHCTARI(TarItmDR),"^",15)
	...s ItmCate=$p(^DHCTarC("OC",ItmCateSub),"^",3)
	...s ItmCateAry(ItmCate)=+$g(ItmCateAry(ItmCate))+Amt
	..//会计分类
	..i (ItmFlag="AC") d
	...s ItmCateSub=$p(^DHCTARI(TarItmDR),"^",5)
	...s ItmCateAry(ItmCateSub)=+$g(ItmCateAry(ItmCateSub))+Amt
	..i (ItmFlag="TAC") d
	...s ItmCateSub=$p(^DHCTARI(TarItmDR),"^",5)
	...s ItmCate=$p(^DHCTarC("AC",ItmCateSub),"^",3)
	...s ItmCateAry(ItmCate)=+$g(ItmCateAry(ItmCate))+Amt
	..//新病案首页类
	..i (ItmFlag="TMCNew") d
	...s ItmCateSub=$p(^DHCTARI(TarItmDR),"^",30)
	...s ItmCate=$p(^DHCTarC("MCNew",ItmCateSub),"^",3)
	...s ItmCateAry(ItmCate)=+$g(ItmCateAry(ItmCate))+Amt
	..i (ItmFlag="MCNew") d
	...s ItmCateSub=$p(^DHCTARI(TarItmDR),"^",30)
	...s:(ItmCateSub'="") ItmCateAry(ItmCateSub)=+$g(ItmCateAry(ItmCateSub))+Amt
	
	q 0
}

/// Creator: Lid
/// CreatDate: 2012-06-13
/// Description: 根据医嘱Rowid获取该医嘱第一次交费日期,时间
/// Input: OEORI:医嘱Rowid
/// Return: 日期(Cache格式)^时间(Cache格式)^日期(格式:2012-01-22)^时间(格式:09:09:33)
/// Debug: w ##class(web.DHCBillInterface).IOrdItmPrtDate("5368||5")
ClassMethod IOrdItmPrtDate(OEORI As %String, ExpStr As %String = "")
{
	set rtn=""
	quit:(+OEORI=0) rtn
	quit:'$d(^DHCPBi(0,"OEORI",OEORI)) rtn
	set PBORowID=$o(^DHCPBi(0,"OEORI",OEORI,0))	 //取医嘱所在的第一条账单RowID
	quit:(+PBORowID=0) rtn
	quit:'$d(^DHCBCI(0,"Bill",PBORowID)) rtn
	set BCIRowID=$o(^DHCBCI(0,"Bill",PBORowID,0))
	set PrtRowID=$p(^DHCBCI(BCIRowID),"^",1)
	quit:(+PrtRowID=0) rtn
	quit:'$d(^DHCINVPRT(PrtRowID)) rtn
	set PrtDate=$p(^DHCINVPRT(PrtRowID),"^",5)
	set PrtTime=$p(^DHCINVPRT(PrtRowID),"^",20)
	set PrtDateDisplay=##class(websys.Conversions).DateLogicalToHtml(PrtDate)
	set PrtTimeDisplay=##class(websys.Conversions).TimeLogicalToHtml(PrtTime)
	set rtn=PrtDate_"^"_PrtTime_"^"_PrtDateDisplay_"^"_PrtTimeDisplay
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2019-09-03
/// Description: 获取患者门诊账户余额
/// Input: patientId:PA_PatMas.RowId, hospId:CT_Hospital.RowId
/// Return: 门诊账户余额
/// Debug: w ##class(web.DHCBillInterface).IGetAccMDeposit(2349)
ClassMethod IGetAccMDeposit(patientId As %String, hospId As %String = "") As %String
{
	set accMLeft=0
	quit:(+patientId=0) accMLeft
	set patientNo=$p($g(^PAPER(patientId,"PAT",1)),"^",2)
	set accInfo=##class(web.UDHCAccManageCLS7).GetAccInfoByPAPMI(patientNo, "", hospId)
	set accMLeft=$p(accInfo,"^",3)
	quit accMLeft
}

/// Creator: Lid
/// CreatDate: 2012-07-24
/// Description: 获取留观病人押金
/// Input: EpisodeID:就诊ID, ExpStr:扩展串(暂传空)
/// Return: 留观押金金额
/// Debug: w ##class(web.DHCBillInterface).IGetStayDeposit("310865", "")
ClassMethod IGetStayDeposit(EpisodeID, ExpStr As %String = "")
{
	set AccData=##class(web.DHCOPBillEPManageCLS).getCurrAcountID(EpisodeID)
	set AccLeft=$p(AccData,"^",3)
	quit $fn(AccLeft,"",2)
}

/// Creator: Lid
/// CreatDate: 2012-08-16
/// Description: 获取留观病人余额
/// Input: EpisodeID:就诊ID, ExpStr:扩展串(暂传空)
/// Return: 押金余额=留观押金金额-病人总费用
/// Debug: w ##class(web.DHCBillInterface).IGetStayBalance("7516","")
ClassMethod IGetStayBalance(EpisodeID, ExpStr As %String = "")
{
	set AccData=##class(web.DHCOPBillEPManageCLS).getCurrAcountID(EpisodeID)
	set AccLeft=$p(AccData,"^",3)
	set StayFeeInfo=##class(web.DHCOPBillStayCharge).GetStayTotalAmt(EpisodeID, "", "^^^^")
	set TotalAmt=+$p(StayFeeInfo,"^",1)
	set Balance=AccLeft-TotalAmt
	quit $fn(Balance,"",2)
}

/// Creator: Lid
/// CreatDate: 2012-08-16
/// Description: 获取留观病人总费用
/// Input: EpisodeID:就诊ID, BillNO:账单号(如果不知道可以传空), ExpStr:扩展串(暂传空)
/// Return: 总费用^折扣金额^记账金额^自付金额
/// Debug: w ##class(web.DHCBillInterface).IGetStayTotalAmt("7516","")
ClassMethod IGetStayTotalAmt(EpisodeID As %String, BillNO As %String = "", ExpStr As %String = "")
{
	set StayFeeInfo=##class(web.DHCOPBillStayCharge).GetStayTotalAmt(EpisodeID, BillNO, "^^^^")
	quit StayFeeInfo
}

/// Creator: Lid
/// CreatDate: 2012-08-22
/// Descripion: 根据医嘱Rowid获取医嘱退费数量
/// Input: OEORIDR:医嘱Rowid, ExpStr:扩展串(没有值传空或不传)
/// Return: 总退费数量^申请退费数量^实际退费数量
/// Debug: w ##class(web.DHCBillInterface).GetPartRefundQty("8486||2","")
ClassMethod GetPartRefundQty(OEORIDR As %String, ExpStr As %String = "") As %String
{
	quit:(OEORIDR="") "0^0^0"
	set rtn=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORIDR, ExpStr)
	set RefundQty1=$p(rtn,"^",1)	 //总退费数量
	set RefundQty2=$p(rtn,"^",2)	 //已申请退费数量
	set RefundQty3=$p(rtn,"^",3)	 //已实际退费数量
	quit RefundQty1_"^"_RefundQty2_"^"_RefundQty3
}

/// Creator: Lid
/// CreatDate: 2012-11-15
/// Description: 获取已结束留观患者的财务结算标识
/// Input: PatientID:PA_PatMas.RowId, HospID:CT_Hospital.RowId, ExpStr:扩张参数
/// Return:	N:有未作财务结算的就诊记录, Y:无
/// Debug: w ##class(web.DHCBillInterface).IGetBillFlag(5551961, 2, "")
ClassMethod IGetBillFlag(PatientID As %String, HospID As %String, ExpStr As %String = "")
{
	quit ##class(web.DHCOPBillStayCharge).GetBillFlag(PatientID, HospID, ExpStr)
}

/// Creator: Lid
/// CreatDate: 2013-03-07
/// Description: 获取指定科研项目的花费金额
/// Input: PilotDR:科研项目指针, EpisodeID:就诊记录指针, ExpStr:扩展信息
/// Return: 科研记账金额
/// Debug: w ##class(web.DHCBillInterface).IGetPilotFee("","273043","^^^^^")
ClassMethod IGetPilotFee(PilotDR As %String, EpisodeID As %String, ExpStr As %String)
{
	set FeeSum=0
	quit:(+EpisodeID=0) 0
	set AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	if (AdmType="I") {
		set PB=0
		while ($o(^DHCPB(0,"ADM",EpisodeID,PB))) {
			set PB=$o(^DHCPB(0,"ADM",EpisodeID,PB))
			do GetPliotPBOSum
		}
		//+2022-01-13 ZhYW 增加以"科研记账"支付方式结算的临床药理费用
		if (+PilotDR=0) {
			set PrtInvDR=0
			while ($o(^DHCINVPRTZY(0,"ADM",EpisodeID,PrtInvDR))) {
				set PrtInvDR=$o(^DHCINVPRTZY(0,"ADM",EpisodeID,PrtInvDR))
				set PaymSub=0
				while ($o(^DHCINVPRTZY(PrtInvDR,"P",PaymSub))) {
					set PaymSub=$o(^DHCINVPRTZY(PrtInvDR,"P",PaymSub))
					set PaymSubData=$g(^DHCINVPRTZY(PrtInvDR,"P",PaymSub))
					continue:(PaymSubData="")
					set PaymDR=$p(PaymSubData,"^",1)
					continue:(+PaymDR=0)
					set PaymCode=$p($g(^CT("CTPM",PaymDR)),"^",1)
					continue:(PaymCode'=##class(web.DHCBillPilot).#PilotPayMode)
					set PaymAmt=$p(PaymSubData,"^",3)
					set FeeSum=FeeSum+PaymAmt
				}
			}
		}
	}ElseIf(" O E "[(" "_AdmType_" ")) {
		set BCIDR=0
		while($o(^DHCBCI(0,"ADM",EpisodeID,BCIDR))) {
			set BCIDR=$o(^DHCBCI(0,"ADM",EpisodeID,BCIDR))
			set BCIData=$g(^DHCBCI(BCIDR))
			set PrtInvDR=$p(BCIData,"^",1)
			set PB=$p(BCIData,"^",2)
			do GetPliotPBOSum
			//+2022-01-13 ZhYW 增加以"科研记账"支付方式结算的临床药理费用
			if (+PilotDR=0) {
				set PaymSub=0
				while ($o(^DHCINVPRT(PrtInvDR,"P",PaymSub))) {
					set PaymSub=$o(^DHCINVPRT(PrtInvDR,"P",PaymSub))
					set PaymSubData=$g(^DHCINVPRT(PrtInvDR,"P",PaymSub))
					continue:(PaymSubData="")
					set PaymDR=$p(PaymSubData,"^",1)
					continue:(+PaymDR=0)
					set PaymCode=$p($g(^CT("CTPM",PaymDR)),"^",1)
					continue:(PaymCode'=##class(web.DHCBillPilot).#PilotPayMode)
					set PaymAmt=$p(PaymSubData,"^",3)
					set FeeSum=FeeSum+PaymAmt
				}
			}
		}
	}
	
	quit FeeSum
GetPliotPBOSum
	set PBO=0
	while($o(^DHCPB(PB,"O",PBO))) {
		set PBO=$o(^DHCPB(PB,"O",PBO))
		set PBOData=$g(^DHCPB(PB,"O",PBO))
		continue:(PBOData="")
		set OEORI=$p(PBOData,"^",4)
		continue:'$d(^OEORD($p(OEORI,"||",1),"I",$p(OEORI,"||",2)))
		set OrdPliotDR=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"DHC")),"^",10)  //存科研项目的指针
		continue:((PilotDR'="")&&(OrdPliotDR'=PilotDR))
		set TalAmount=+$p(PBOData,"^",8)
		set DiscAmount=+$p(PBOData,"^",9)
		set PayorShare=+$p(PBOData,"^",10)
		set PatientShare=+$p(PBOData,"^",11)
		set FeeSum=FeeSum+PayorShare
	}
	quit
}

/// Creator: Lid
/// CreatDate: 2014-08-15
/// Description: 根据就诊号取病人的担保信息
/// Input: episodeID: 就诊号,  admType: 就诊类型(O:门诊，I:住院，E:急诊)
/// Return: 是否有担保(Y:有，N:无)^担保金额
/// Debug: w ##class(web.DHCBillInterface).IGetWarramt("27", "I")
ClassMethod IGetWarramt(episodeID As %String, admType As %String) As %String
{
	set warrAmt=0
	set warrantFlag="N"
	quit:(+episodeID=0) warrantFlag_"^"_0
	
	if (admType="I") {
		set wdr=0
		while($o(^DHCWARRANT(0,"ADM",episodeID,wdr))) {
			set wdr=$o(^DHCWARRANT(0,"ADM",episodeID,wdr))
			set warrData=$g(^DHCWARRANT(wdr))
			continue:(warrData="")
			set status=$p(warrData,"^",8)
			continue:(status'="Y")
			set ltd=$p(warrData,"^",4)      //担保结束日期
			continue:((ltd<+$h)&&(ltd'=""))
			set stDate=$p(warrData,"^",3)   //担保开始日期
			set time=$p(warrData,"^",17)
			continue:((stDate'="")&&(stDate>+$h))
			set value=(+$h-stDate)*24*3600+($p($h,",",2)-time)
			set limitStr=##class(web.UDHCJFZYDB).GetLimitWarrantByAdm(episodeID)
			set flag=$p(limitStr,"^",1)
			set limitTime=$p(limitStr,"^",3)*3600
			continue:((value>limitTime)&&(flag="Y"))
			set warrantFlag="Y"
			set amt=$p(warrData,"^",2)
			set warrAmt=warrAmt+amt
		}
	}else {
		set warrAmt=##class(web.DHCOPBillWarrant).GetWarrAmt(episodeID)
		if (+warrAmt>0) {
			set warrantFlag="Y"
		}
		//取"欠费"结算总额，已经补交的不计算
		set oweSum=0
	    set oweDR=0
	    while($o(^DHCOPQFPatInfo(0,"Adm",episodeID,oweDR))) {
		    set oweDR=$o(^DHCOPQFPatInfo(0,"Adm",episodeID,oweDR))
		  	set oweData=$g(^DHCOPQFPatInfo(oweDR))
	 		continue:(oweData="")
	 		set flag=$p(oweData,"^",7)
	  		continue:(flag="Restore")
	 		set status=$p(oweData,"^",8)
	 		continue:(status'="N")
	  		continue:($d(^DHCOPQFPatInfo(0,"LinkTo",oweDR)))
	 		set oweAmt=$p(oweData,"^",2)
	  		set oweSum=oweSum+oweAmt
		}
	   	
	    set warrAmt=warrAmt-oweSum	  //门诊最终的担保金额需减去"欠费"结算金额
	    set:(+warrAmt<0) warrAmt=0
	}
	set rtn=warrantFlag_"^"_warrAmt
	
	quit rtn
}

/// Creator: wangjian
/// CreatDate: 2014-08-17
/// Description: 根据就诊费别返回医保标志
/// Input: Adm:PA_Adm.RowId
/// Debug: w ##class(web.DHCBillInterface).GetAdmSourceByAdm(693)
ClassMethod GetAdmSourceByAdm(EpisodeID As %String)
{
	set AdmReaDR=$p(^PAADM(EpisodeID,1),"^",7)
	set AdmSource=+$s((+AdmReaDR'=0):$p($g(^PAC("ADMREA",AdmReaDR)),"^",9),1:0)
	quit AdmSource
}

/// Creator: hujunbin
/// CreatDate: 2015-01-08
/// Description: 根据病人ID和就诊ID获取患者年龄
/// Input:	Papmi: PA_PatMas.Papmi_RowId
/// 		Adm: PA_Adm.PAADM_RowId
///         HospId: CT_Hospital.HOSP_RowId(传入就诊时可不传)
/// 		ParamAdmDate: 取年龄日期，可不传(如果传入用这个减去出生日期)
/// 		ParamAdmTime: 取年龄时间，可不传(如果传入用这个减去出生时间)
/// 		ParamAdmDate，ParamAdmTime: 如果不为空则以此日期和时间计算年龄
///         CusDispPat: 自定义格式(Y:年, YM:年月, YMD:年月天, MD:月天, M:月, D:天, YD:年天)
///         AgeOnly: 0:只显示年龄, 1:显示年龄及年月日时分秒
/// Return:	年龄显示字符串
/// Debug: w ##class(web.DHCBillInterface).GetPapmiAge("691","1705","","","","D")
ClassMethod GetPapmiAge(Papmi As %String, Adm As %String = "", HospId As %String = "", ParamAdmDate As %String = "", ParamAdmTime As %String = "", CusDispPat As %String = "", AgeOnly As %String = 0, LangId As %String = "") As %String
{
	set ^TMP("GetPapmiAge")=$lb(Papmi, Adm, HospId, ParamAdmDate, ParamAdmTime, CusDispPat, AgeOnly)
	
	if (LangId="")&&($d(%session)) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	quit:((Papmi="")||('$d(^PAPER(Papmi)))) "ParamErr"
	
	if ((+HospId=0)&&(+Adm'=0)) {
		set HospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
	}
	quit:(+HospId=0) "HospitalNull"
	
	set admDate=+$h
	set admTime=$p($h,",",2)

	//取住院患者年龄配置:1:按当前时间 2:按就诊时间 3:按分床时间(仅限住院)  2023-04-12 LUANZH
	set calcMode=##class(web.UDHCJFAgeConfig).GetAgeConfig(HospId)
	if (+Adm'=0) {
		set admType=$p($g(^PAADM(Adm)),"^",2)
		if (" 2 3 "[(" "_calcMode_" ")) {
			//+2022-01-10 ZhYW 按就诊日期或按分床时间算年龄时，如果是婴儿，需按当前时间算，否则婴儿年龄是0
			set mumAdmDR=$p($g(^PAADM(Adm)),"^",75)
			if (mumAdmDR="") {
				set admDate=$p($g(^PAADM(Adm)),"^",6)
				set admTime=$p($g(^PAADM(Adm)),"^",7)
				//按分床时间
				if ((admType="I")&&(calcMode=3)) {
					set assignedBedDateInfo=##class(web.DHCDischargeHistory).GetAdminDateTime(Adm)
					set assignedBedDate=$p(assignedBedDateInfo,"^",1)
					set assignedBedTime=$p(assignedBedDateInfo,"^",2)
					if (assignedBedDate'="") {
						set admDate=assignedBedDate
						set admTime=assignedBedTime
					}
				}
			}
		}
	}
	
	set birthDate=##class(web.UDHCJFCOMMON).GetPatBirthDate(Papmi)
	quit:(birthDate="") ##class(websys.Translation).Get("Bill.Com.Age", "未知", LangId)
	set birthTime=##class(web.UDHCJFCOMMON).GetPatBirthTime(Papmi)
	//+2018-06-06 ZhYW 患者死亡时按死亡时间计算
	set isDead=$p($g(^PAPER(Papmi,"ALL")),"^",12)        //PA_PatMas.PAPMI_Deceased 死亡状态
	if (isDead="Y") {
		set deadDate=$p($g(^PAPER(Papmi,"ALL")),"^",13)    //PA_PatMas.PAPMI_Deceased_Date 死亡日期
		set deadTime=$p($g(^PAPER(Papmi,"ALL")),"^",8)     //PA_PatMas.PAPMI_DeceasedTime 死亡时间
		set admDate=deadDate
		set admTime=deadTime
	}
	//如果传入了日期和时间, 则按传入的日期时间取年龄
	if (ParamAdmDate'="") {
		set ParamAdmDate=##class(websys.Conversions).DateHtmlToLogical(ParamAdmDate)
		set ParamAdmTime=##class(websys.Conversions).TimeHtmlToLogical(ParamAdmTime, 1)
		set admDate=ParamAdmDate
		set admTime=ParamAdmTime
	}
	set rtnValue=##class(web.UDHCJFCOMMON).DispPatAge(birthDate, admDate, birthTime, admTime, HospId, "Y", "", CusDispPat)
	quit:(AgeOnly=1) rtnValue    //返回年龄及年月日时分秒
	set ageStr=$p(rtnValue,"||",1)
	quit ageStr
}

/// Creator: Lid
/// CreatDate: 2015-01-28
/// Description: 保存新生儿年龄，给其他组的接口
/// Input:	patientId:新生儿id，birthDate:新生儿出生日期，birthTime:出生时间
/// Return:	0:成功，<>0:失败
/// Debug:	w ##class(web.DHCBillInterface).ISaveNewBabyDob("1","63247","25201")
ClassMethod ISaveNewBabyDob(patientId As %String, birthDate As %String, birthTime As %String) As %String
{
	quit ##class(web.UDHCJFCOMMON).SaveNewBabyDob(patientId, birthDate, birthTime)
}

/// Creator: wangjian
/// CreatDate: 2015-01-14
/// Description: 根据住院证id 判断住院证有效性,返回值不为空均为异常
///      异常说明:IPBookErr:不是当天的住院证, Admission:病人正在住院, OnceAdmission:病人曾住院
/// Input: IPBook:DHCDocIPBooking.RowId
/// Return: 
/// Debug: w ##class(web.DHCBillInterface).IIsIPBook(4)
ClassMethod IIsIPBook(IPBook As %String) As %String
{
	quit:(+IPBook=0) ""
	
	//当前日期的前后几天的住院证允许办理住院（包括当天）
	set IPBookData=$g(^DHCDocIPBK(IPBook))
	set admFrom=$p(IPBookData,"^",2)
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(admFrom)
	set jsonStr=##class(web.DHCBillCommon).GetIPParamConfig(hospDR)
	set jsonObj=##class(ext.util.JsonObject).FromJSON(jsonStr)
	set DateRangeFrom=jsonObj.GetValue("IPBookValidFromDate")
	set DateRangeTo=jsonObj.GetValue("IPBookValidToDate")
	
	set visDate=$p(IPBookData,"^",10)
	set stateDR=$p(IPBookData,"^",8)
	set activeFlag=$p(IPBookData,"^",9)
	set visFlag=$s((+stateDR'=0):$p($g(^DHCDocIPBDIC(stateDR)),"^",1),1:"")
	
    quit:(visFlag="Admission") "Admission^"
    quit:(visFlag="OnceAdmission") "OnceAdmission^"
    
    quit:(visDate'="")&&(+DateRangeTo'=0)&&(visDate>(+$h+DateRangeTo)) "IPBookErr^"
    quit:(visDate'="")&&(+DateRangeFrom'=0)&&(visDate<(+$h-DateRangeFrom)) "IPBookErr^"
    quit:(visDate'="")&&(+DateRangeFrom=0)&&(visDate<+$h) "IPBookErr^"
    quit:(visDate'="")&&(+DateRangeTo=0)&&(visDate>+$h) "IPBookErr^"
    quit:(visDate'="")&&(visDate'=+$h)&&(DateRangeFrom=0)&&(DateRangeTo=0) "IPBookErr"  
    quit:(activeFlag'="Y") "NotActive^"
    
	quit ""
}

/// Creator: hujunbin
/// CreatDate: 2015-02-09
/// Description: 统一封装接口，对门急诊、住院、急诊留观取押金余额、费用、押金-费用
/// Input:	就诊ID, 扩展串
/// Return:	押金余额^押金-自付费用^总费用^自付费用
/// Debug: 	w ##class(web.DHCBillInterface).IGetDepAndBalnace(1628)
ClassMethod IGetDepAndBalnace(EpisodeID As %String, ExpStr As %String = "") As %String
{
	set deposit=0, amount=0, balance=0, patShare=0
	set cardType=""
	quit:(+EpisodeID=0) deposit_"^"_balance_"^"_amount_"^"_patShare
	
	//判断是否是急诊流观病人
	set stayFlag=##class(web.DHCBillInterface).IGetStayStatusByEpisodeID(EpisodeID)
	if (+stayFlag>0) {  //急诊留观
		set accData=##class(web.DHCOPBillEPManageCLS).getCurrAcountID(EpisodeID)
		set deposit=+$p(accData,"^",3)
		set stayFeeInfo=##class(web.DHCOPBillStayCharge).GetStayTotalAmt(EpisodeID, "", "^^^^")
		set amount=+$p(stayFeeInfo,"^",1)
		set patShare=+$p(stayFeeInfo,"^",4)
	}else {
		set admType=$p($g(^PAADM(EpisodeID)),"^",2)
		if (admType="I") { //住院
			set deposit=##class(web.UDHCJFBaseCommon).deposit(EpisodeID)
			set feeInfo=##class(web.UDHCJFCKD).getPatFeeInfo(EpisodeID)
			set amount=+$p(feeInfo,"^",1)
			set patShare=+$p(feeInfo,"^",2)
		}else {
			//门急诊
			set patFeeInfo=##class(web.DHCBillInterface).IGetpatFeeInfo(EpisodeID, 1)
			set amount=$p(patFeeInfo,"^",1)
			set patShare=$p(patFeeInfo,"^",4)
			set papmiDR=$p($g(^PAADM(EpisodeID)),"^",1)
			set hospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(EpisodeID)
			set cardRefFlag=0
			set cardref=""
			while($o(^DHCCARDi("CF",0,"PAPMIDR",papmiDR,cardref),-1)) {
				set cardref=$o(^DHCCARDi("CF",0,"PAPMIDR",papmiDR,cardref),-1)
				set cardData=$g(^DHCCARD("CF",cardref))
				set myCardActF=$p(cardData,"^",10)
				set myCardType=$p(cardData,"^",16)
				set cardType=myCardType
				continue:(myCardActF'="N")
				set cardRefFlag=1
				quit
			}
			if (cardRefFlag=1) && ($d(^DHCACDi("AccM",0,"PAPMI",papmiDR))) {
				set deposit=..IGetAccMDeposit(papmiDR, hospId)
			}
		}
	}
    set balance=deposit-patShare
    if (cardType=1) set balance=0   //条形码不显示余额 没有押金
	
	quit deposit_"^"_balance_"^"_amount_"^"_patShare
}

/// Creator: wangjian
/// CreateDate: 2012-09-11
/// Description: 根据门诊阈值的就诊记录判断病人是否有未结医嘱
/// Modify: ZhYW 2018-05-29
/// Input: regNo:登记号,  admStr:adm串, expStr:登录科室Id
/// Return: >=0:有未结医嘱  0:无未结医嘱
/// Debug: w ##class(web.DHCBillInterface).GetnotPayOrderByRegno("0000000115", "1664", "2)
ClassMethod GetnotPayOrderByRegno(regNo As %String, admStr As %String = "", expStr As %String = "") As %String
{
	set ctLocId=$p(expStr,"^",1)
	set hospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(ctLocId)
	
	if ((admStr="")&&(regNo'="")) do
    .set papmi=$o(^PAPERi("PAPMI_PatNo",regNo,""),-1)
	.set admStr=##class(web.DHCOPCashierIF).GetToDayAdmStr(papmi, "^^"_ctLocId_"^"_hospId)

	set rtn=0

	for i=$l(admStr,"^"):-1:1  do
	.set adm=$p(admStr,"^",i)
	.quit:(+adm=0)
	.set RCDRowID=$p($g(^PAADM(adm,"DHC")),"^",25)
	.set ord=0
	.for  set ord=$o(^OEORD(0,"Adm",adm,ord)) quit:(ord="")  do
	..set itm=0
	..for  set itm=$o(^OEORD(ord,"I",itm)) quit:(itm="")  do
	...set oeitm=ord_"||"_itm
	...quit:'$d(^OEORD(ord,"I",itm,1))
	...set myPriorFlag=##class(web.UDHCOEORDOP1).ReadOECPriorityFlag(oeitm)
	...quit:(+myPriorFlag=1)   //自备药品退出
	...set billed=$p($g(^OEORD(ord,"I",itm,3)),"^",5)
	...quit:(" P I ")[(" "_billed_" ")
	...set itmStatDR=$p(^OEORD(ord,"I",itm,1),"^",13)
	...set statCode=$s((itmStatDR'=""):$p($g(^OEC("OSTAT",itmStatDR)),"^",1),1:"")
	...quit:(" V E ")'[(" "_statCode_" ")
	...set arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
	...set ordPrice=$p($g(^OEORD(ord,"I",itm,3)),"^",25)
	...set sttDate=+$h
	...set insTypeDR=$p($g(^OEORD(ord,"I",itm,11)),"^",18)
	...if (insTypeDR="") set insTypeDR=##class(web.DHCBillCons).ReadDefInsType(hospId)
	...set oeore=""
	...set regLoc=""
	...set itmPriceExpStr=RCDRowID_"^"_oeitm_"^"_oeore_"^"_adm_"^"_regLoc_"^"_""
	...set billPrice=##class(web.UDHCJFPRICE).GetOrderPrice("", insTypeDR, arcim, sttDate, "", "", "", ordPrice, hospId, itmPriceExpStr)
	...set price=$p(billPrice,"^",1)
	...quit:(+price=0)                   //过滤价格为0的项目
	...set rtn=$i(rtn)
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2015-08-19
/// Description: 根据adm获取急诊留观收费模式
/// Input: EpisodeID: PA_Adm.RowId
/// Return: 留观状态(1:留观出院, 2:正在留观, -1:非留观)
/// 		注：为了兼容现有程序，按普通收费模式收费时，留观状态返回-1.
/// Debug: w ##class(web.DHCBillInterface).IGetStayStatusByEpisodeID(950)
ClassMethod IGetStayStatusByEpisodeID(EpisodeID As %String) As %String
{
	set rtn=-1
	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(EpisodeID)
	set chargeMode=##class(web.DHCBillInterface).IGetStayPayMode(admHospDR)
	quit:(+chargeMode'=1) rtn
	set rtn=##class(web.UDHCJFBaseCommon).GetObsPatYetDisHosp(EpisodeID)
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2015-12-24
/// Description: 获取急诊留观收费模式
/// Input: hospId:CT_Hospital.RowId
/// Return: 0:普通收费模式, 1:押金收费模式
/// Debug: w ##class(web.DHCBillInterface).IGetStayPayMode(2)
ClassMethod IGetStayPayMode(hospId As %String) As %String
{
	set cfgId=##class(web.DHCOPConfig).GetSOPFCfgId(hospId)
	set chargeMode=+$s((+cfgId'=0):$p($g(^DHCSOPFCON(cfgId)),"^",44),1:0)
	quit chargeMode
}

/// Creator: yyx
/// CreatDate: 2015-11-19
/// Description: 取打印导诊单的标记
/// Input: hospId: CT_Hospital.RowId
/// Return: "F": 收费处打印, "D": 医生站打印, 空:都不打印
/// Debug: w ##class(web.DHCBillInterface).IGetPrtGuideFlag(2)
ClassMethod IGetPrtGuideFlag(hospId As %String) As %String
{
	set cfgId=##class(web.DHCOPConfig).GetSOPFCfgId(hospId)
	set prtGuideFlag=$s((+cfgId'=0):$p(^DHCSOPFCON(cfgId),"^",43),1:"")
	quit prtGuideFlag
}

/// Description: 获取住院患者的就诊状态
/// Debug: w ##class(web.DHCBillInterface)GetAdmLastStatus()
ClassMethod GetAdmLastStatus(EpisodeID As %String) As %String
{
	quit ##class(web.UDHCJFPAY).GetAdmLastStatus(EpisodeID)
}

/// Creator: Lid
/// CreatDate: 2016-01-21
/// Description: 调用医生站接口生成处方号
/// Input: episodeIDStr：就诊串, userId:用户id
/// Return: 
/// Debug: do ##class(web.DHCBillInterface).SetPresno("1069^1068^1067^",1)
ClassMethod SetPresno(episodeIDStr As %String, userId As %String)
{
	set $zt="ERROR"
	
	set len=$l(episodeIDStr,"^")
	for i=1:1:len {
		set episodeID=$p(episodeIDStr,"^",i)
		continue:(+episodeID=0)
		do ##class(DHCDoc.Interface.Inside.ServiceOrd).GenPresno(episodeID, userId)
	}
	quit 0
	
ERROR
 	quit ..AppException()
}

/// Creator: xiongwang
/// CreatDate:2016-04-22
/// Description: 根据就诊号,账单用户,返回病人总费用,已缴费用,未缴费用
/// Input: PAADMRowid:就诊号
///         UserId:账单用户id
/// Return: TotalAmount：总费用，PayedAmount：已缴费用，NotPayedAmount：未缴费用
/// Debug: w ##class(web.DHCBillInterface).IGetpatFeeInfo(551,1)
ClassMethod IGetpatFeeInfo(PAADMRowid As %String, UserId As %String) As %String
{
	q:(PAADMRowid="") ""
	q:(UserId="") ""
	s Rtn=##class(web.UDHCJFBILL).BILLN(PAADMRowid, UserId)
	s Ord=$o(^OEORD(0,"Adm",PAADMRowid,""))
	q:(Ord="") ""
	s TotalAmount=0, PayedAmount=0, NotPayedAmount=0, PatientShareAmt=0
	s Itm=0
	f  s Itm=$o(^OEORD(Ord,"I",Itm)) q:(Itm="")  d
	.s OEORI=Ord_"||"_Itm
	.s statDR=$p($g(^OEORD(Ord,"I",Itm,1)),"^",13)
	.s statCode=$s((statDR'=""):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
	.//q:(" V E "'[(" "_statCode_" "))
	.s billed=$p($g(^OEORD(Ord,"I",Itm,3)),"^",5)
	.s OrdCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(OEORI, 1)   //医嘱类型
	.s PB=0
	.f  s PB=$o(^DHCPBi(0,"OEORI",OEORI,PB)) q:(PB="")  d
	..s DspQty=0
	..i (OrdCateType="R") d
	...s DspQty=..GetPHQty(OEORI)
	..q:(OrdCateType="R")&&((statCode'="V")&&(statCode'="E"))
	..q:(OrdCateType="R")&&((statCode'="V")&&(statCode'="E"))&&(+DspQty=0)
	..s PBO=0
	..f  s PBO=$o(^DHCPBi(0,"OEORI",OEORI,PB,PBO)) q:(PBO="")  d
	...s PBOData=$g(^DHCPB(PB,"O",PBO))
	...s Amount=+$p(PBOData,"^",8)
	...s PBPatientShare=+$p(PBOData,"^",11)
	...s PatientShareAmt=PatientShareAmt+PBPatientShare
	...s TotalAmount=TotalAmount+Amount
	...i (billed="P") d
	....s PayedAmount=PayedAmount+Amount
	...e  d
	....s NotPayedAmount=NotPayedAmount+Amount
	
	q TotalAmount_"^"_PayedAmount_"^"_NotPayedAmount_"^"_PatientShareAmt
}

/// Debug: w ##class(web.DHCBillInterface).GetPHQty() 
ClassMethod GetPHQty(OEORI As %String) As %String
{
	set Qty=0
	
	set dsp=0
	for  set dsp=$o(^DHCOEDISQTY(0,"OEORI",OEORI,dsp)) quit:(dsp="")  do
	.set disp=$g(^DHCOEDISQTY(dsp))
	.quit:(disp="")
	.set dspStatus=$p(disp,"^",7)
	.set dspQty=+$p(disp,"^",11)
	.if (dspStatus="C") set Qty=Qty+dspQty
	.if (dspStatus="R") set Qty=Qty-dspQty
	
	quit Qty
}

/// Creator: Lid
/// CreatDate: 2017-03-09
/// Description: 提供给护士站判断能否召回
/// Input: episodeId: PA_Adm.RowId
/// Return: Y:不能召回, N:能召回
/// Debug: w ##class(web.DHCBillInterface).IGetCodingFlag(78763)
ClassMethod IGetCodingFlag(episodeId As %String) As %String
{
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(episodeId)
	set confirmFlag=##class(web.DHCBillCommon).GetIPParamConfig(hospDR, "ConfirmPatFee")
	quit:(confirmFlag'="Y") "N"	 //配置不需要审核时，直接召回

	set rtn="Y", flag="N"
	set bill=0
	for  set bill=$o(^DHCPB(0,"ADM",episodeId,bill)) quit:((bill="")||(flag="Y"))  do
	.set pbFlag=$p(^DHCPB(bill),"^",16)
	.quit:(pbFlag'="B")
	.set flag=##class(web.UDHCJFBillDetailOrder).GetCodingFlag(episodeId, bill)

	if (flag="Y") set rtn="Y"
	else  set rtn="N"
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2017-06-16
/// Description: 更新挂号表发票关联
/// Input: prtRowId：发票rowid
/// Return: 0:成功(发票不包含挂号费诊察费不用更新或包含同时更新成功); 非0:包含挂号费诊察费但是更新不成功	
/// Debug: w ##class(web.DHCBillInterface).IUpdateRegistionFeeInv(18867910)
ClassMethod IUpdateRegistionFeeInv(prtRowId As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0

	set hospDR=$p($g(^DHCINVPRT(prtRowId)),"^",39)
	
	ts
	
	set billConInvDR=0
	while($o(^DHCBCI(0,"INV",prtRowId,billConInvDR))) {
		set billConInvDR=$o(^DHCBCI(0,"INV",prtRowId,billConInvDR))
		set conInvData=$g(^DHCBCI(billConInvDR))
		set pb=$p(conInvData,"^",2)
		set adm=$p(conInvData,"^",3)
		set regOrdList=""
		set pbo=0
		while($o(^DHCPB(pb,"O",pbo))) {
			set pbo=$o(^DHCPB(pb,"O",pbo))
			set pboData=$g(^DHCPB(pb,"O",pbo))
			continue:(pboData="")
			set arcim=$p(pboData,"^",3)
			set oeitm=$p(pboData,"^",4)
			//调用医生站接口判断是否是挂号医嘱
			set billSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(arcim, hospDR)
			continue:(billSubType="NotRegFee")
			set regOrdList=$s((regOrdList=""):oeitm,1:(regOrdList_"^"_oeitm))
		}
		continue:(regOrdList="")
		//调用医生站接口，更新挂号表发票关联
		set rtn=##class(web.DHCOPAdmReg).UpdateRegistionFeeInv(adm, prtRowId, regOrdList)
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2017-08-07
/// Description: 根据就诊号和执行记录判断是否有封账账单
/// Input: episodeID: PA_Adm.RowId
///        ordExec: OE_OrdExec.OEORE_RowId 传入执行记录时, 判断该执行记录所在账单是否封账
///                       				   传空时, 判断该就诊下是否有封账账单
/// Return: "N"未封账, "Y":封账
/// Debug: w ##class(web.DHCBillInterface).ICheckIsCloseAcount(609, "578||1||1")
ClassMethod ICheckIsCloseAcount(episodeID As %String, ordExec As %String) As %String
{
	set adm=episodeID
	set closeAcountFlag="N"
	quit:((+adm=0)&&(ordExec="")) closeAcountFlag
	
	if ($l(ordExec,"||")=3) do
	.set bill=0
	.for  set bill=$o(^DHCPB(0,"OEEXC",ordExec,bill)) quit:((bill="")||(closeAcountFlag="Y"))  do
	..set data=$g(^DHCPB(bill))
	..quit:(data="")
	..set myCloseAcountFlag=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(bill)
	..if (myCloseAcountFlag="Y") do
	...set closeAcountFlag="Y"
	else  do
	.set bill=0
	.for  set bill=$o(^DHCPB(0,"ADM",adm,bill))  quit:((bill="")||(closeAcountFlag="Y"))  do
	..set data=$g(^DHCPB(bill))
	..quit:(data="")
	..set myCloseAcountFlag=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(bill)
	..if (myCloseAcountFlag="Y") do
	...set closeAcountFlag="Y"
	
	quit closeAcountFlag
}

/// Creator: ZhYW
/// CreatDate: 2017-08-07
/// Description: 提供给护士站办理出院结算时的费用核查结果
///              返回每个"^"分割的数量不为0时,即表示有问题数据存在
/// Input: episodeID:PA_Adm.RowID(必传), billId:DHC_PatientBill.RowID(可以为空), expStr:扩展参数(暂时为空)
/// Return: 
/// Debug: w ##class(web.DHCBillInterface).IAdmSettlementCheck(66, "", "")
ClassMethod IAdmSettlementCheck(episodeId As %String, billId As %String, expStr As %String = "") As %String
{
	set rtn=0
	quit:(+episodeId=0) rtn
	set rtnValue=##class(web.DHCIPBillCheckAdmCost).AdmSettlementCheck(episodeId, billId)
	set rtn=$p(rtnValue,$c(2),1)
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2017-08-14
/// Description: 判断主医嘱跟关联医嘱是否在同一账单(只考虑未结算账单)
/// Input: ordItm:OE_OrdItem.OEORI_RowId, mOrdItm:OE_OrdItem.OEORI_RowId
///        ordItm:需要停止的医嘱(不能为空)
///        mOrdItm:主医嘱(需要停止的医嘱为主医嘱时, mOrdItm可为空)
///                
/// Return: splitFlag: "Y":被拆分到不同账单, "N":在同一账单
/// Debug: w ##class(web.DHCBillInterface).ICheckBillIsSplit("75||199")
ClassMethod ICheckBillIsSplit(ordItm As %String, mOrdItm As %String = "") As %String
{
	set splitFlag="N"
	quit:(($l(ordItm,"||")'=2)||($l(mOrdItm,"||")'=2)) splitFlag
	quit:(ordItm=mOrdItm) splitFlag
	
	set billStr=$$GetBillNOByOEORI(ordItm)
	set mBillNOStr=$$GetBillNOByOEORI(mOrdItm) 
	
	quit:((billStr="")||(mBillNOStr="")) splitFlag
	
	set count=$l(billStr,"^")
	for i=1:1:count quit:(splitFlag="Y")  do
	.set bill=$p(billStr,"^",i)
	.quit:(+bill=0)
	.if (("^"_mBillNOStr_"^")'[("^"_bill_"^")) do
	..set splitFlag="Y"
	
	quit splitFlag

GetBillNOByOEORI(ordItm)
	set rtn=""
	set bill=0
	for  set bill=$o(^DHCPBi(0,"OEORI",ordItm,bill))  quit:(bill="")  do
	.set data=$g(^DHCPB(bill))
	.quit:(data="")
	.set payedFlag=$p(data,"^",16)
	.set closeAcountFlag=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(bill)
	.quit:((payedFlag="P")&&(closeAcountFlag'="Y"))  //未封账已结算的过滤
	.set rtn=rtn_"^"_bill
	
	quit rtn
}

/// Creator: wangjian
/// CreatDate: 2017-08-02
/// Description: 根据Adm/账单号查询病案分类(大类/子类)
/// Input:	EpisodeID: 就诊号
/// 		Bill: 账单号
/// 	    ItemType: Null(空):两个分类都要 N:新病案分类(38) O:旧病案分类(24) 
/// 		ExpStr: 扩展字符串
/// Return:	总金额_"^"_自付金额_$c(3)_新分类费用信息_$c(3)_旧分类费用信息
/// 				新分类费用信息=分类1_$c(2)_分类2_$c(2)_分类3…
/// 								分类=分类Code^分类名称^分类金额@子分类Code1^子分类名称1^子分类金额1!子分类Code2^子分类名称2^子分类金额2!子分类Code3^子分类名称3^子分类金额3…
/// 				旧分类费用信息=分类1_$c(2)_分类2_$c(2)_分类3…
/// 								分类=分类Code^分类名称^分类金额@子分类Code1^子分类名称1^子分类金额1!子分类Code2^子分类名称2^子分类金额2!子分类Code3^子分类名称3^子分类金额3…
/// Debug:	w ##class(web.DHCBillInterface).IGetTarMRCateFee("","7630","","") 
ClassMethod IGetTarMRCateFee(EpisodeID As %String, Bill As %String, ItemType As %String, ExpStr As %String = "") As %String
{
	q:((+EpisodeID=0)&&(+Bill=0)) ""
	
	s MCInfoStr="", NewMCInfoStr=""
	s TotalAmt=0, PatShare=0
	
	s Adm=$s((+Bill'=0):$p($g(^DHCPB(Bill)),"^",1),1:EpisodeID)
	s HospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)

	//初始化数组
	s ItmCatSub=0
	f  s ItmCatSub=$o(^DHCTarC("MCNew",ItmCatSub)) q:(ItmCatSub="")  d
	.s showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarMCCateNew", ItmCatSub, HospId)
	.q:(showFlag="N")
	.s ItmCat=$p(^DHCTarC("MCNew",ItmCatSub),"^",3)
	.s ItmCateAry("MCNew",ItmCat,ItmCatSub)=0
	
	s ItmCatSub=0
	f  s ItmCatSub=$o(^DHCTarC("MC",ItmCatSub)) q:(ItmCatSub="")  d
	.s showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarMRCate", ItmCatSub, HospId)
	.q:(showFlag="N")
	.s ItmCat=$p(^DHCTarC("MC",ItmCatSub),"^",3)
	.s ItmCateAry("MC",ItmCat,ItmCatSub)=0
	
	i (+Bill'=0) d
	.d MRCateByBill(Bill)
	e  d
	.s PBDR=0
	.f  s PBDR=$o(^DHCPB(0,"ADM",EpisodeID,PBDR)) q:(PBDR="")  d
	..d MRCateByBill(PBDR)
	
	//计算后输出
	s myCate=""
	f  s myCate=$o(ItmCateAry("MCNew",myCate)) q:(myCate="")  d
	.s myCateSub="", myCateFee=0, myCateStr=""
	.f  s myCateSub=$o(ItmCateAry("MCNew",myCate,myCateSub)) q:(myCateSub="")  d
	..s myCateSubCode=$p(^DHCTarC("MCNew",myCateSub),"^",1)
	..s myCateSubDesc=$p(^DHCTarC("MCNew",myCateSub),"^",2)
	..s myCateSubFee=ItmCateAry("MCNew",myCate,myCateSub)
	..i (myCateStr="")  s myCateStr=myCateSubCode_"^"_myCateSubDesc_"^"_$fn(myCateSubFee,"",2)
	..e  s myCateStr=myCateStr_"!"_myCateSubCode_"^"_myCateSubDesc_"^"_$fn(myCateSubFee,"",2)
	..s myCateFee=myCateFee+myCateSubFee
	.s myCateCode=$p(^DHCTarC("TMCNew",myCate),"^",1)
	.s myCateDesc=$p(^DHCTarC("TMCNew",myCate),"^",2)
	.s myCateStr=myCateCode_"^"_myCateDesc_"^"_$fn(myCateFee,"",2)_"@"_myCateStr
	.i (NewMCInfoStr="") s NewMCInfoStr=myCateStr
	.e  s NewMCInfoStr=NewMCInfoStr_$c(2)_myCateStr
	
	s myCate="" 
	f  s myCate=$o(ItmCateAry("MC",myCate)) q:(myCate="")  d
	.s myCateSub="",myCateFee=0,myCateStr=""
	.f  s myCateSub=$o(ItmCateAry("MC",myCate,myCateSub)) q:(myCateSub="")  d
	..s myCateSubCode=$p(^DHCTarC("MC",myCateSub),"^",1)
	..s myCateSubDesc=$p(^DHCTarC("MC",myCateSub),"^",2)
	..s myCateSubFee=ItmCateAry("MC",myCate,myCateSub)
	..i (myCateStr="")  s myCateStr=myCateSubCode_"^"_myCateSubDesc_"^"_$fn(myCateSubFee,"",2)
	..e  s myCateStr=myCateStr_"!"_myCateSubCode_"^"_myCateSubDesc_"^"_$fn(myCateSubFee,"",2)
	..s myCateFee=myCateFee+myCateSubFee
	.s myCateCode=$p(^DHCTarC("TMC",myCate),"^",1)
	.s myCateDesc=$p(^DHCTarC("TMC",myCate),"^",2)
	.s myCateStr=myCateCode_"^"_myCateDesc_"^"_$fn(myCateFee,"",2)_"@"_myCateStr
	.i (MCInfoStr="") s MCInfoStr=myCateStr
	.e  s MCInfoStr=MCInfoStr_$c(2)_myCateStr
	
	q TotalAmt_"^"_PatShare_$c(3)_NewMCInfoStr_$c(3)_MCInfoStr
	
MRCateByBill(PBRowID)
	s PBO=0
	f  s PBO=$o(^DHCPB(PBRowID,"O",PBO)) q:(PBO="")  d
	.s PBD=0
	.f  s PBD=$o(^DHCPB(PBRowID,"O",PBO,"D",PBD)) q:(PBD="")  d
	..s PBDData=$g(^DHCPB(PBRowID,"O",PBO,"D",PBD))
	..q:(PBDData="")
	..s Amt=$p(PBDData,"^",7)
	..s TotalAmt=TotalAmt+Amt
	..s Share=$p(PBDData,"^",10)
	..s PatShare=PatShare+Share
	..s TarItmDR=$p(PBDData,"^",3)
	..i (ItemType'="N") d
	...s ItmCateSub=$p(^DHCTARI(TarItmDR),"^",6)      ;病案首页子类
	...s ItmCate=$p(^DHCTarC("MC",ItmCateSub),"^",3)  ;病案首页大类
	...s ItmCateAry("MC",ItmCate,ItmCateSub)=+$g(ItmCateAry("MC",ItmCate,ItmCateSub))+Amt
	..i (ItemType'="O") d
	...s ItmCateSub=$p(^DHCTARI(TarItmDR),"^",30)        ;新病案首页子类
	...s ItmCate=$p(^DHCTarC("MCNew",ItmCateSub),"^",3)  ;新病案首页大类
	...s ItmCateAry("MCNew",ItmCate,ItmCateSub)=+$g(ItmCateAry("MCNew",ItmCate,ItmCateSub))+Amt
	
	q
}

/// Creator: ZhYW
/// CreatDate: 2017-06-23
/// Description: 根据医嘱RowID获取结算记录RowID
/// Input: oeitm: OE_OrdItem.RowID, expStr: 扩展串(暂时传空)
/// Return: 
/// Debug: w ##class(web.DHCBillInterface).IGetOPPrtRowIDByOrdItm("2141||2")
ClassMethod IGetOPPrtRowIDByOrdItm(oeitm As %String, expStr As %String = "") As %String
{
	set prtRowId=""
	quit:(oeitm="") prtRowId
	set pb=""
	while($o(^DHCPBi(0,"OEORI",oeitm,pb),-1)&&(prtRowId="")) {
		set pb=$o(^DHCPBi(0,"OEORI",oeitm,pb),-1)
		set billConInvDR=$o(^DHCBCI(0,"Bill",pb,0))
		continue:(billConInvDR="")
		set invDR=$p($g(^DHCBCI(billConInvDR)),"^",1)
		set invFlag=$p($g(^DHCINVPRT(invDR)),"^",8)
		continue:(invFlag'="N")
		set prtRowId=invDR
	}
	quit prtRowId
}

/// Creator: ZhYW
/// CreatDate: 2017-06-20
/// Description: 提供给其他产品组调用的非药品医嘱部分退费接口
/// Input: ApplyRefundData:医嘱RowID_"^"_数量_"!"_医嘱RowID_"^"_数量, RefUser:操作员, ExpStr:DHC_INVPRT.RowID
/// Return: rtn: = 0成功, <>0失败
/// Debug: w ##class(web.DHCBillInterface).ISaveApplyRefundQty("77446||6^15", 530, 140128)
ClassMethod ISaveApplyRefundQty(ApplyRefundData As %String, RefUser As %String, ExpStr As %String) As %String
{
	set $p(ExpStr,"^",2)="Y"
	quit ##class(web.DHCOPBillOERefundQty).InertApplyRefundQty(ApplyRefundData, RefUser, ExpStr)
}

/// Creator: ZhYW
/// CreatDate: 2017-08-20
/// Description: 提供给其他产品组调用的非药品医嘱部分退费数量查询接口
/// Input: OrdItmDR:OE_OrdItem.RowID, ExpStr:DHC_INVPRT.RowID
/// Return: rtn: 总退费数量^申请退费数量^实际退费数量
/// Debug: w ##class(web.DHCBillInterface).IGetApplyRefundQty("77442||14", "140126")
ClassMethod IGetApplyRefundQty(OrdItmDR As %String, ExpStr As %String = "") As %String
{
	if (##class(web.UDHCPRTOEAuthCommon).CheckOrderIsRefAudit(OrdItmDR, "")="N") {
		quit "^^"
	}
	quit ##class(web.DHCOPBillOERefundQty).GetApplyRefundQty(OrdItmDR, ExpStr)
}

/// Creator: ZhYW
/// CreatDate: 2017-08-28
/// Description: 提供给其他产品组调用的取住院病人入院时间、住院天数、出院时间方法
/// Input: EpisodeID:PA_Adm.RowID
/// Return: rtn: 入院日期_"^"_入院时间_"^"_住院天数_"^"_出院日期_"^"_出院时间
/// Debug: w ##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID("")
ClassMethod IGetAdmInOutDatebyEpisodeID(EpisodeID As %String) As %String
{
	quit ##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(EpisodeID)
}

/// Creator: Lid
/// CreatDate: 2017-08-30
/// Description: 提供给其他产品组调用的取医嘱或执行记录的计费状态
/// Input: oeitm:医嘱RowID或执行记录RowID，注：门诊要传OE_OrdItem.RowId，住院要传OE_OrdExec.RowId
/// Return: 账单状态^账单状态描述
/// 		TB^未计费(未收费)，B^已计费(未收费)，P^已收费，I^需退费，R^已退费，-1^入参错误，-10^程序异常
/// Debug: w ##class(web.DHCBillInterface).IGetOrdItmBilled("93||3")
ClassMethod IGetOrdItmBilled(oeitm As %String, langId As %String = "") As %String
{
	set $zt="ERROR"
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set len=$l(oeitm,"||")
	if (len=3) {
		set billed=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",$p(oeitm,"||",3)),"^",6)	
	}elseif (len=2) {
		set billed=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3),"^",5)
	}else {
		set billed=-1
	}
	
	set status=$case(billed, "TB":"未计费", "B":"已计费", "P":"已收费", "I":"需退费", "R":"已退费", -1:"入参错误", :"状态未知")
	
	if (len=2) {
		if (" TB B I "[(" "_billed_" ")) set status="未收费"
		//+2023-04-03 ZhYW 增加"预结算"状态
		if (##class(web.DHCOPBillChargExcepiton).CheckTPFlagByOEORIDR(oeitm)) {
			set status="预结算"
		}else {
			//查找最后一次的收费记录
			set prtRowId=##class(BILL.Interface.Inside.Method).GetLastPrtIDByOrd(oeitm, "")
			if ((+prtRowId'=0)&&$d(^DHCINVPRT(0,"InitInvDR",prtRowId))) {
				set status="已退费"
			}
		}
	}
	set status=##class(websys.Translation).Get("", status, langId)
	
	quit billed_"^"_status
	
ERROR
	quit -10_"^程序异常:"_$ze
}

/// Creator: ZhYW
/// CreatDate: 2018-01-27
/// Description: 判断医嘱是否已做退费审核(提供给其他产品组调用)
/// Input: oeitm:OE_OrdItem.RowID
///         expStr:扩展串（若多部位申请单需要按部位判断是否已审核，需要传按"^"分隔的DHC_AppRepTarItm.RowId串）
/// Return: "Y":已审核, "N":未审核
/// Debug: w ##class(web.DHCBillInterface).ICheckOrderIsRefAudit("766||4")
ClassMethod ICheckOrderIsRefAudit(oeitm As %String, expStr As %String = "") As %String
{
	quit ##class(web.UDHCPRTOEAuthCommon).CheckOrderIsRefAudit(oeitm, expStr)
}

/// Creator: ZhYW
/// CreatDate: 2018-03-29
/// Description: 门诊预交金充值接口
/// Input: accM:DHC_AccManager.RowId, amt:金额(单位为元), userId:SS_User.RowId, 
///        paymId:CT_PayMode.RowId, hospId:CT_Hospital.RowId
/// Return: rtn (err^accLeft: err=0成功,<>0失败; accLeft:账户余额)
/// Debug: w ##class(web.DHCBillInterface).IAddAccDeposit(36317, 100, 7, 1, 2)
ClassMethod IAddAccDeposit(accM As %String, amt As %String, userId As %String, paymId As %String, hospId As %String) As %String
{
	set $zt="ERROR"
		
	if (+amt<0) {
		set preType="R"
		set amt=$zabs(amt)
	}else {
		set preType="P"
	}
	set backReason=""
	set password=""
	set bankCardType=""
	set chequeNo=""
	set bank=""
	set company=""
	set payAccNo=""
	set chequeDate=""
	set remark=""
	
	set preInfo=amt_"^"_userId_"^"_backReason_"^"_password_"^"_preType_"^"_remark_"^"_hospId
	
	set payMInfo=paymId_"^"_bank_"^"_chequeNo_"^"_bankCardType_"^"_company_"^"_chequeDate
	set payMInfo=payMInfo_"^"_payAccNo_"^"_amt
	
	set rtnValue=##class(web.UDHCAccAddDeposit).NewDeposit(accM, preInfo, payMInfo)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue
	set accLeft=$p(^DHCACD("AccM",accM),"^",8)
	set accLeft=$fn(accLeft,"",2)

	quit rtn_"^"_accLeft
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2018-03-30
/// Description: 判断账单是否被封账
/// Input: bill:DHC_PatientBill.RowId
/// Return: "N"未封账, "Y":封账
/// Debug: w ##class(web.DHCBillInterface).ICheckBillIsClosed(609)
ClassMethod ICheckBillIsClosed(bill As %String) As %String
{
	quit ##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(bill)
}

/// Creator: ZhYW
/// CreatDate: 2018-04-09
/// Description: 提供给其他产品组调用的门诊重新账单接口
/// Input: bill: DHC_PatientBill.RowId(原账单Id), ordItemStr:OEOrdItem.RowId串,多个医嘱Id以"^"分隔
///        userId:SS_User.RowId, sFlag:收费/退费标识(=0收费，=1退费)
/// Return: rtn:(err^newBill: err=0成功,<>0失败; newBill:新账单Id)
/// Debug: w ##class(web.DHCBillInterface).IReBill(26546, "^501||2", 639, 0)
ClassMethod IReBill(bill As %String, ordItemStr As %String, userId As %String, sFlag As %String) As %String
{
	set $zt="ERROR"
	set rtn=0
	set pbDateFrom=$p($g(^DHCPB(bill)),"^",6)   //PB_DateFrom
	set pbDateTo=$p($g(^DHCPB(bill)),"^",7)     //PB_DateTo
	if ((pbDateFrom="")||(pbDateTo="")) {
		quit 1_"^"_bill
	}
	
	set iDatestr=pbDateFrom_"^"_pbDateTo

	set pboStr=""
	set count=$l(ordItemStr,"^")
	for i=1:1:count {
		set ordItem=$p(ordItemStr,"^",i)
		continue:(ordItem="")
		set pbo=$p(^OEORD(+ordItem,"I",$p(ordItem,"||",2),1),"^",16)		//OEORI_ARPBLItem_DR
		set pboStr=pboStr_pbo_"^"
	}
	set insTypeDR=$p($g(^DHCPB(bill)),"^",4)

	set rtn=##class(web.UDHCJFIntBill).RINBILL(bill, iDatestr, pboStr, userId, insTypeDR, sFlag)
	
	quit rtn
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW 
/// CreatDate: 2018-05-31
/// Description: 更新医嘱的计费状态
/// Input: oeori:OE_OrdItem.RowId, billed:计费状态("TB", "B", "P", "I", "R")
/// Return: =0:成功, <>0:失败
/// Debug: w ##class(web.DHCBillInterface).IUpdateOeoriBilled("11||22", "P")
ClassMethod IUpdateOeoriBilled(oeori As %String, billed As %String) As %String
{
	quit ##class(web.DHCOPCashier1).UpdateOeoriBilled(oeori, billed)
}

/// Creator: ZhYW
/// CreatDate: 2018-07-13
/// Description: 保存急诊担保信息
/// Input: warrInfo: 担保Id_"&"_就诊Id_"&"_开始日期_"&"_结束日期_"&"_担保人Id_"&"_担保金额_"&"_担保状态(有效:"Y"; 无效:"N")
///     _"&"_"备注"_"&"_操作员Id_"&"_患者类型(门急诊:"E"; 住院:"I")_"&"_申请Id_"&"_担保物_"&"_医院Id_"&"_担保原因Id
/// Return: rtn:"errCode^errMsg" (errCode: =0成功, <>0失败)
/// Debug: w ##class(web.DHCBillInterface).ISaveWarrant("")
ClassMethod ISaveWarrant(warrInfo As %String) As %String
{
	quit ##class(web.DHCOPBillWarrant).SaveWarrant(warrInfo)
}

/// Creator: Lid
/// CreatDate: 2016-11-23
/// Description: 判断一个处方是否做过部分退费
/// Input:	prtRowId:原发票Rowid, newPrtRowId:部分退费重收新发票Rowid, prescNo:处方号
/// Return:  0:处方没有变化或此发票上未找到指定的处方.
/// 		 1:处方发生了变化
/// Debug: w ##class(web.DHCBillInterface).IIsPartialRefund(11,12,"3333333")
ClassMethod IIsPartialRefund(prtRowId As %String, newPrtRowId As %String, prescNo As %String)
{
	set tmp=..IGetPrescFee(prtRowId, prescNo)
	set amt1=$p(tmp,"^",1)
	set tmp=..IGetPrescFee(newPrtRowId, prescNo)
	set amt2=$p(tmp,"^",1)
	set rtn=0
	if (+amt1'=+amt2) {
		set rtn=1
	}
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2016-11-23
/// Description: 获取门诊发票上的处方金额
/// Input: prtRowId:发票Rowid
///        prescNo:处方号(未空时，返回发票上所有处方的金额，按处方返)
/// Return:	金额^处方号!金额^处方号!...			
/// Debug: w ##class(web.DHCBillInterface).IGetPrescFee(18864812,"")
ClassMethod IGetPrescFee(prtRowId As %String, prescNo As %String = "")
{
	set job=$j
	kill DHCPLIST("PrescAmt",job)
	set billConInvDR=0
	for  set billConInvDR=$o(^DHCBCI(0,"INV",prtRowId,billConInvDR))  quit:(billConInvDR="")  do
	.set pb=$p($g(^DHCBCI(billConInvDR)),"^",2)
	.set pbo=0
	.for  set pbo=$o(^DHCPB(pb,"O",pbo))  quit:(pbo="")  do
	..set pboData=$g(^DHCPB(pb,"O",pbo))
	..quit:(pboData="")
	..set oeitm=$p(pboData,"^",4)
	..set myPrescNo=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",14)
	..quit:(myPrescNo="")     //过滤处方号非空的记录
	..quit:(prescNo'="")&&(prescNo'=myPrescNo)
	..set myAmt=+$p(^DHCPB(pb,"O",pbo),"^",8)	//PBO_ToTalAmount
	..set DHCPLIST("PrescAmt",job,myPrescNo)=$g(DHCPLIST("PrescAmt",job,myPrescNo))+myAmt
	
	set str=""
	set no=""
	for  set no=$o(DHCPLIST("PrescAmt",job,no)) quit:(no="")  do
	.set prescFee=+$g(DHCPLIST("PrescAmt",job,no))
	.set tmp=prescFee_"^"_no
	.set str=$s((str=""):tmp,1:(str_"!"_tmp))
	
	quit str
}

/// Creator: Lid
/// CreatDate: 2018-11-22
/// Description: 根据执行记录rowid获取执行记录的账单数据--仅供住院调用
/// Input: 获取执行记录的账单金额金额，数量，单位
/// Return: 医嘱金额^单价^数量^单位^单价
/// Debug: w ##class(web.DHCBillInterface).IGetOrdEexcBillPrice("145||63||1")
ClassMethod IGetOrdEexcBillPrice(oeore As %String) As %String
{
	set amt=0, qty=0, uom=""
	set pboRowId=$p(^OEORD(+oeore,"I",$p(oeore,"||",2),"X",$p(oeore,"||",3),"BILL"),"^",2)
	quit:(pboRowId="") amt_"^"_qty_"^"_uom
	set pboData=$g(^DHCPB(+pboRowId,"O",$p(pboRowId,"||",2)))
	quit:(pboData="") amt_"^"_qty_"^"_uom
	
	set amt=$p(pboData,"^",8)
	set discAmt=$p(pboData,"^",9)
	set payorAmt=$p(pboData,"^",10)
	set shareAmt=$p(pboData,"^",11)
	
	set price=$p(pboData,"^",7)
	set discPrice=$p(pboData,"^",17)
	set payorPrice=$p(pboData,"^",18)
	set sharePrice=$p(pboData,"^",19)
	
	set billQty=+$p(pboData,"^",5)
	set billRefQty=+$p(pboData,"^",6)
	set qty=billQty+billRefQty
	set arcim=$p($g(^OEORD(+oeore,"I",$p(oeore,"||",2),1)),"^",2)
	
	set uom=##class(web.DHCBillCommon).GetBaseUom(arcim, $p(oeore,"||",1,2))
	
	quit amt_"^"_qty_"^"_uom_"^"_price
}

/// Creator: ZhYW
/// CreatDate: 2019-01-15
/// Description: 获取门诊医嘱收费信息接口
/// Input: oeitm: OE_OrdItem.RowId
/// Return: 收费日期^收费时间^收费人^收费数量单位
/// Debug: w ##class(web.DHCBillInterface).IGetOrdItmPayInfo("196||11")
ClassMethod IGetOrdItmPayInfo(oeitm As %String) As %String
{
	quit:($l(oeitm,"||")'=2) ""
	
	set pbRowId=""   //第一次结算账单
	set billQty=0    //第一次收费数量
	set pb=0
	for  set pb=$o(^DHCPBi(0,"OEORI",oeitm,pb))  quit:((pb="")||(+pbRowId'=0))  do
	.set pbData=$g(^DHCPB(pb))
	.quit:(pbData="")
	.set payedFlag=$p(pbData,"^",16)
	.quit:(payedFlag'="P")
	.set pbRowId=pb
	.set pbo=0
	.for  set pbo=$o(^DHCPBi(0,"OEORI",oeitm,pb,pbo))  quit:(pbo="")  do
	..set pboData=$g(^DHCPB(pb,"O",pbo))
	..quit:(pboData="")
	..set pboBillQty=$p(pboData,"^",5)
	..set pboRefQty=$p(pboData,"^",6)
	..set billQty=$i(billQty,(pboBillQty+pboRefQty))

	quit:(+billQty=0) ""
	
	set pbUpDate=$p(^DHCPB(pbRowId),"^",19)
	set pbUpTime=$p(^DHCPB(pbRowId),"^",20)
	set pbUpUserDR=$p(^DHCPB(pbRowId),"^",21)
	set pbUpDate=##class(websys.Conversions).DateLogicalToHtml(pbUpDate)
	set pbUpTime=##class(websys.Conversions).TimeLogicalToHtml(pbUpTime, 1)
	set pbUpUserName=$s((+pbUpUserDR'=0):$p($g(^SSU("SSUSR",pbUpUserDR)),"^",2),1:"")
	set arcim=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)
	set conFac=##class(web.DHCBillCommon).GetUomConvFactor(arcim, oeitm)
	set packUOM=##class(web.DHCBillCommon).GetPackUom(arcim, oeitm)
	set billQty=billQty/conFac
	
	quit pbUpDate_"^"_pbUpTime_"^"_pbUpUserName_"^"_billQty_packUOM
}

/// Creator: ZhYW
/// CreatDate: 2019-01-15
/// Description: 获取门诊医嘱退费信息接口
/// Input: oeitm: OE_OrdItem.RowId
/// Return: 退费日期^退费时间^退费人^退费数量单位
/// Debug: w ##class(web.DHCBillInterface).IGetOrdItmRefInfo("196||11")
ClassMethod IGetOrdItmRefInfo(oeitm As %String) As %String
{
	quit:($l(oeitm,"||")'=2) ""
	
	set pbRowId=""   //最后一条结算账单
	set billQty=0    //第一次收费数量
	set qtySum=0     //总的计费数量
	set pbNum=0
	set pb=0
	for  set pb=$o(^DHCPBi(0,"OEORI",oeitm,pb))  quit:(pb="")  do
	.set pbData=$g(^DHCPB(pb))
	.quit:(pbData="")
	.set payedFlag=$p(pbData,"^",16)
	.quit:(payedFlag'="P")
	.set pbNum=$i(pbNum)
	.set pbRowId=pb
	.set pbo=0
	.for  set pbo=$o(^DHCPBi(0,"OEORI",oeitm,pb,pbo))  quit:(pbo="")  do
	..set pboData=$g(^DHCPB(pb,"O",pbo))
	..quit:(pboData="")
	..set pboBillQty=$p(pboData,"^",5)
	..set pboRefQty=$p(pboData,"^",6)
	..if (pbNum=1) do
	...set billQty=$i(billQty,(pboBillQty+pboRefQty))
	..set qtySum=$i(qtySum,(pboBillQty+pboRefQty))
	
	set refQty=billQty-qtySum
	quit:(+refQty'>0) ""
	
	set pbUpDate=$p(^DHCPB(pbRowId),"^",19)
	set pbUpTime=$p(^DHCPB(pbRowId),"^",20)
	set pbUpUserDR=$p(^DHCPB(pbRowId),"^",21)
	set pbUpDate=##class(websys.Conversions).DateLogicalToHtml(pbUpDate)
	set pbUpTime=##class(websys.Conversions).TimeLogicalToHtml(pbUpTime, 1)
	set pbUpUserName=$s((+pbUpUserDR'=0):$p($g(^SSU("SSUSR",pbUpUserDR)),"^",2),1:"")
	set arcim=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)
	set conFac=##class(web.DHCBillCommon).GetUomConvFactor(arcim, oeitm)
	set packUOM=##class(web.DHCBillCommon).GetPackUom(arcim, oeitm)
	set refQty=refQty/conFac
	
	quit pbUpDate_"^"_pbUpTime_"^"_pbUpUserName_"^"_refQty_packUOM
}

/// Creator: zhl
/// CreatDate: 2018-07-23
/// Description: 门诊临床科研医生站结算接口
/// Input: episodeIdStr: PA_Adm.RowId串
/// Return: 0:结算成功，非0：结算失败
/// Debug: w ##class(web.DHCBillInterface).IsPilotOPChargeForOrder("3156")
ClassMethod IsPilotOPChargeForOrder(episodeIdStr As %String) As %String
{
	quit ##class(web.DHCBillPilot).OPChargeForOrder(episodeIdStr)
}

/// Creator: zhl
/// CreatDate: 2018-07-23
/// Description: 门诊临床科研医生站退费接口
/// Input: oeitmStr: OE_OrdItem.RowId串
/// Return: 0:退费成功，非0：退费失败   rtn_"@"_未退费医嘱串_"@"_已退费医嘱串
/// Debug: w ##class(web.DHCBillInterface).IsPilotOPRefundForOrder("10974691||6")
ClassMethod IsPilotOPRefundForOrder(oeitmStr As %String) As %String
{
	quit ##class(web.DHCBillPilot).OPRefundForOrder(oeitmStr)
}

/// Creator: ZhYW
/// CreatDate: 2019-01-28
/// Description: 急诊留观押金充值接口
/// Input: accM:DHC_EPManager.RowId, amt:金额(单位为元), userId:SS_User.RowId, 
///        paymId:CT_PayMode.RowId, hospId:CT_Hospital.RowId
/// Return: rtn (err^accLeft: err=0成功,<>0失败; accLeft:账户余额)
/// Debug: w ##class(web.DHCBillInterface).IEPMAddDeposit(762, 100, 7, 1, 2)
ClassMethod IEPMAddDeposit(accM As %String, amt As %String, userId As %String, paymId As %String, hospId As %String) As %String
{
	set $zt="ERROR"
		
	quit:((+accM=0)||('$d(^DHCEPM("EPM",accM)))) "-1^ACCERR"
	quit:((+hospId=0)||('$d(^CT("HOSP",hospId)))) "-2^HOSPERR"
	
	set adm=$p(^DHCEPM("EPM",accM),"^",2)
	set papmi=$p(^DHCEPM("EPM",accM),"^",3)
	set regNo=$p(^DHCEPM("EPM",accM),"^",4)
	set cardNo=$p(^DHCEPM("EPM",accM),"^",5)
	set str1=adm_"^"_papmi_"^"_regNo_"^"_cardNo_"^"_userId
	set bankCardTypeId=""
	set cardChequeNo=""
	set bankId=""
	set company=""
	set chequeDate=""
	set remark=""
	if (+amt<0) {
		set preType="R"
		set amt=0-amt
	}else {
		set preType="P"
	}
	set str2="^"_amt_"^"_userId_"^^^"_paymId_"^"_bankCardTypeId_"^"_cardChequeNo_"^"_bankId_"^"_company_"^"_chequeDate_"^"_remark
	set str2=str2_"^"_preType_"^"_hospId
	set str3=""
	set str4="Y"
	set myRtn=##class(web.DHCOPBillEPAddDeposit).NewDeposit(str1, str2, str3, str4)
	if (($l(myRtn,"^")=1)&&($p(myRtn,"^",1)'=0)) {
		set rtn=-3_"^"_$p(myRtn,"^",1)
	}else {
		set rtn=$p(myRtn,"^",1)_"^"_$p(myRtn,"^",4)
	}

	quit rtn
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2019-01-30
/// Description: 给其他产品组提供按自然日查询门诊退费信息查询接口
/// Input: stDate:开始日期, endDate:结束日期
/// Output:  
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillInterface","IFindOPBillRefInfo","26/12/2018","26/12/2018")
Query IFindOPBillRefInfo(stDate As %String, endDate As %String) As websys.Query(ROWSPEC = "PatientId:%String,RefAmt:%String")
{
}

ClassMethod IFindOPBillRefInfoExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1

 	if ((stDate="")||(endDate="")) quit $$$OK
 	
 	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
 	kill ^||TMP($j)

 	for date=stDate:1:endDate do
 	.set prtRowId=0
 	.for  set prtRowId=$o(^DHCINVPRT(0,"Date",date,prtRowId)) quit:(prtRowId="")  do
 	..set prtInfo=$g(^DHCINVPRT(prtRowId))
 	..quit:(prtInfo="")
 	..set acount=$p(prtInfo,"^",1)
 	..set prtFlag=$p(prtInfo,"^",8)
 	..set initInvDR=$p(prtInfo,"^",13)
 	..set papmi=$p(prtInfo,"^",15)
 	..set oldInvDR=$p(prtInfo,"^",29)
	..if (+oldInvDR'=0) do
	...//部分退
	...set oldPrtInfo=$g(^DHCINVPRT(oldInvDR))
	...quit:(oldPrtInfo="")
	...set oldAcount=$p(oldPrtInfo,"^",1)   //原发票金额
	...set refAcount=acount-oldAcount       //退费金额
	...quit:(+refAcount=0)                  //过滤作废重打记录
	...set ^||TMP($j,papmi)=$g(^||TMP($j,papmi))+refAcount
 	..else  if (+initInvDR'=0)&&('$d(^DHCINVPRT(0,"OldINV",initInvDR))) do
	...//全退
	...set refAcount=acount                //退费金额
	...set ^||TMP($j,papmi)=$g(^||TMP($j,papmi))+refAcount
	
	set papmi=0
	for  set papmi=$o(^||TMP($j,papmi))  quit:(papmi="")  do
	.set refAmt=$g(^||TMP($j,papmi))
	.quit:(+refAmt=0)
	.set refAmt=$fn(refAmt,"",2)
	.set data=$lb(papmi,refAmt)
	.set ^CacheTemp(repid,ind)=data
	.set ind=ind+1
	
	kill ^||TMP($j)
	
 	quit $$$OK
}

/// Creator: ZhYW
/// CreatDate: 2019-07-23
/// Description: 判断医嘱是否是急诊转入住院的医嘱
/// Input: oeitm: OE_OrdItem.RowId
/// Return: 0:否, 1:是
/// Debug: w ##class(web.DHCBillInterface).IOrdIsOPToIPByOEORI()
ClassMethod IOrdIsOPToIPByOEORI(oeitm As %String) As %String
{
	quit ##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(oeitm)
}

/// Creator: ZhYW
/// CreatDate: 2019-07-23
/// Description: 判断是否有急诊转入住院的就诊(通过住院就诊判断)
/// Input: episodeId: PA_Adm.RowId(住院)
/// Return: 1:是, 0:否
/// Debug: w ##class(web.DHCBillInterface).ICheckOrdIsOPToIP()
ClassMethod IHasOPToIPOrdByIPAdm(episodeId As %String) As %String
{
	quit ##class(web.DHCOPBillEmergTrans2IP).HasOPToIPOrdByIPAdm(episodeId)
}

/// Creator: ZhYW
/// CreatDate: 2019-07-23
/// Description: 判断医嘱是否转入该住院就诊
/// Input: episodeId: PA_Adm.RowId(住院), oeitm: OE_OrdItem.RowId
/// Return: 1:是, 0:否
/// Debug: w ##class(web.DHCBillInterface).IOrdIsOPToIPByIPAdm("", "")
ClassMethod IOrdIsOPToIPByIPAdm(episodeId As %String, oeitm As %String) As %String
{
	quit ##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByIPAdm(episodeId, oeitm)
}

/// Creator: ZhYW
/// CreatDate: 2019-11-25
/// Description: 获取住院业务参数配置
/// Input: hospId: CT_Hospital.RowId
///        flag: 标识字段(OutPhBillCondition:出院带药是否按计费点计费)
/// Return: 
/// Debug: w ##class(web.DHCBillInterface).IGetIPParamConfig("2", "OutPhBillCondition")
ClassMethod IGetIPParamConfig(hospId As %String, flag As %String) As %String
{
	quit ##class(web.DHCBillCommon).GetIPParamConfig(hospId, flag)
}

/// Creator: ZhYW
/// CreatDate: 2020-02-04
/// Description: 给其他产品组提供查询医嘱对应收费项金额信息
/// Input: oeitm:OE_OrdItem.RowId
/// Output: 费用子类、收费项目名称、数量、单价、金额
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillInterface","IFindTarItmInfo","249||20")
Query IFindTarItmInfo(oeitm As %String) As websys.Query(ROWSPEC = "SubCateDesc:%String,ItmDesc:%String,Qty:%Float,Price:%Float,Amt:%Float")
{
}

ClassMethod IFindTarItmInfoExecute(ByRef qHandle As %Binary, oeitm As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1

 	if (oeitm="") quit $$$OK
 	
 	kill itmAry
 	
	set pb=0
	for  set pb=$o(^DHCPBi(0,"OEORI",oeitm,pb)) quit:(pb="")  do
	.set pbo=0
	.for  set pbo=$o(^DHCPBi(0,"OEORI",oeitm,pb,pbo)) quit:(pbo="")  do
 	..set pbd=0
 	..for  set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd)) quit:(pbd="")  do
 	...set pbdInfo=$g(^DHCPB(pb,"O",pbo,"D",pbd))
	...quit:(pbdInfo="")
 	...set tarItm=$p(pbdInfo,"^",3)
 	...set price=$p(pbdInfo,"^",4)         //PBD_UnitPrice
	...set price=$fn(price,"",4)           //单价保留四位有效数字
    ...set qty=$p(pbdInfo,"^",5)
    ...set qty=$fn(qty,"N")
    ...set amt=$p(pbdInfo,"^",7)           //PBD_TotalAmount
    ...quit:(+amt=0)
	...set $p(itmAry(tarItm,price),"^",1)=$p($g(itmAry(tarItm,price)),"^",1)+qty   //数量
    ...set $p(itmAry(tarItm,price),"^",2)=$p($g(itmAry(tarItm,price)),"^",2)+amt   //金额
    
    set myItm=0
    for  set myItm=$o(itmAry(myItm)) quit:(myItm="")  do
	.set itmDesc=$p(^DHCTARI(myItm),"^",2)
    .set subCateDR=$p(^DHCTARI(myItm),"^",14)
    .set subCateDesc=$p(^DHCTarC("IC",subCateDR),"^",2)          //收费项目住院大类
    .set myPrice=""
    .for  set myPrice=$o(itmAry(myItm,myPrice)) quit:(myPrice="")  do
    ..set tmpInfo=$g(itmAry(myItm,myPrice))
    ..set price=$fn(myPrice,"",4)
    ..set qty=$p(tmpInfo,"^",1)
    ..set amt=$p(tmpInfo,"^",2)
    ..set amt=$fn(amt,"",2)
    ..set data=$lb(subCateDesc,itmDesc,qty,price,amt)
	..set ^CacheTemp(repid,ind)=data
	..set ind=ind+1
	
	quit $$$OK
}

/// Creator: ZhYW
/// CreatDate: 2020-02-10
/// Description: 根据标本和开单科室取医生站使用的接收科室
/// Input: SpecCode:标本代码, LocId:开单科室RowId, HospId: 医院Id
/// Return: RecLocDR:接收科室RowId
/// Debug: w ##class(web.DHCBillInterface).IGetHDDCRecLoc("SP001",1,2)
ClassMethod IGetHDDCRecLoc(SpecCode As %String, LocId As %String, HospId As %String) As %String
{
	quit ##class(web.DHCOPBillHDDC).GetHDDCRecLoc(SpecCode, LocId, HospId)
}

/// Creator: wangjian
/// CreatDate: 2020-04-02
/// Description: 根据医嘱明细ID获取计费信息
/// Input: OEORIRowID
/// Return: TarInfoStr
///    TarInfoStr=收费项目代码1^名称1^价格1^数量1^单价1^申请日期1^账单时间1^账单日期1^账单时间1^执行日期1^执行时间1$c(2)收费项目代码2^名称2^价格2^数量2^单价2^申请日期2^账单时间2^账单日期2^账单时间2^执行日期2^执行时间2$c(2)……
/// Debug: w ##class(web.DHCBillInterface).IGetTarInfoByOEORI("137||7")
ClassMethod IGetTarInfoByOEORI(OEORIRowID As %String) As %String
{
	
	set TarInfoStr=""
	
	quit:(OEORIRowID'["||") TarInfoStr
	quit:(+OEORIRowID=0) TarInfoStr
	
	set ExeDate=""
	set ExeTime=""
	set ExecSub=$o(^OEORD(+OEORIRowID,"I",$p(OEORIRowID,"||",2),"X","0"))
	if (ExecSub'="") do
	.set ExeDate=$p($g(^OEORD(+OEORIRowID,"I",$p(OEORIRowID,"||",2),"ST",ExecSub)),"^",1)
	.set ExeTime=$p($g(^OEORD(+OEORIRowID,"I",$p(OEORIRowID,"||",2),"ST",ExecSub)),"^",2)
	
	set Ind=0 ;计数器
	
	set PB=0
	for  set PB=$o(^DHCPBi(0,"OEORI",OEORIRowID,PB)) quit:((PB="")||(Ind>0))  do
	.set PBRefundFlag=$p(^DHCPB(PB),"^",17)
	.quit:(PBRefundFlag="R")  ;负的退出
	.set PBO=0
	.for  set PBO=$o(^DHCPBi(0,"OEORI",OEORIRowID,PB,PBO)) quit:(PBO="")  do
	..quit:$d(^DHCPB(PB,"O",PBO))=10
	..set BillOrdQty=$p(^DHCPB(PB,"O",PBO),"^",5)+$p(^DHCPB(PB,"O",PBO),"^",6)
	..quit:(+BillOrdQty=0)   ;退费的退出
	..set AppOrdDate=$p(^DHCPB(PB,"O",PBO),"^",12) ;sttDate
	..set AppOrdTime=$p(^DHCPB(PB,"O",PBO),"^",13) ;sttTime
	..set PBD=0
	..for  set PBD=$o(^DHCPB(PB,"O",PBO,"D",PBD)) quit:(PBD="")  do
	...set TarItmDR=$p(^DHCPB(PB,"O",PBO,"D",PBD),"^",3)
	...set TarItmCode=$p(^DHCTARI(TarItmDR),"^",1)
	...set TaritmDesc=$p(^DHCTARI(TarItmDR),"^",2)
	...set Price=$p(^DHCPB(PB,"O",PBO,"D",PBD),"^",4)
	...set Qty=$p(^DHCPB(PB,"O",PBO,"D",PBD),"^",5)
	...set Amount=$p(^DHCPB(PB,"O",PBO,"D",PBD),"^",7)
	...set BillDate=$p(^DHCPB(PB,"O",PBO,"D",PBD),"^",11)
	...set BillTime=$p(^DHCPB(PB,"O",PBO,"D",PBD),"^",12)
	...set Ind=Ind+1
	...set TarInfo=TarItmCode_"^"_TaritmDesc_"^"_Amount_"^"_Qty_"^"_Price_"^"_AppOrdDate_"^"_AppOrdTime_"^"_BillDate_"^"_BillTime_"^"_ExeDate_"^"_ExeTime
	...if (TarInfoStr="")  set TarInfoStr=TarInfo
	...else  set TarInfoStr=TarInfoStr_$c(2)_TarInfo
	
	quit TarInfoStr
}

/// Creator: ZhYW
/// CreatDate: 2020-06-11
/// Description: 判断医嘱是否是按指定金额拆分账单自定义价格医嘱
/// Input: arcim:ARC_ItmMast.RowId, hospId:CT_Hospital.RowId
/// Return: 1: 是，0:否
/// Debug: w ##class(web.DHCBillInterface).IJudgeArcIsorNot("250||1", 2)
ClassMethod IJudgeArcIsorNot(arcim As %String, hospId As %String) As %String
{
	quit ##class(web.UDHCJFIntBill).JudgeArcIsorNot(arcim, hospId)
}

/// Creator: ZhYW
/// CreatDate: 2020-10-16
/// Description: 取检查、治疗医嘱审核模式
/// Input: hospId: CT_Hospital.RowId
/// Return: 0:先撤销执行再审核, 1:先审核再撤销执行
/// Debug: w ##class(web.DHCBillInterface).IGetTreatItmReqMode(2)
ClassMethod IGetTreatItmReqMode(hospId As %String) As %String
{
	set cfgInfo=##class(web.DHCOPConfig).ReadOPSPConfig(hospId)
	set appFlag=$p(cfgInfo,"^",15)
	set treatItmReqMode=$p(cfgInfo,"^",50)
	quit +$s((+appFlag'=0):treatItmReqMode,1:0)    //不需审核时，需要按"先撤销执行再审核"
}

}
