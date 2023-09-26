Import SQLUser

/// Description:建立门诊药房公用class,提供各界面公用调取方法,
/// Creator:Liang Qiang
/// CreatDate:2011-01-11
Class web.DHCOutPhCommon Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTOUTPH";

/// Description:取患者体重
ClassMethod GetPatWeight(paadm) As %String
{
	Q:paadm="" ""
	Q:'$D(^PAADM(paadm)) ""
	S mradm=$P(^PAADM(paadm),"^",61)
	Q:mradm="" ""
	Q:'$D(^MR(mradm,"PRO",1)) ""
	S weight=$P(^MR(mradm,"PRO",1),"^",27)
	S:weight'="" weight=weight_"KG"
	Q weight
}

/// Description:取患者身高
ClassMethod GetPatHeight(paadm) As %String
{
	Q:paadm="" ""
	Q:'$D(^PAADM(paadm)) ""
	S mradm=$P(^PAADM(paadm),"^",61)
	Q:mradm="" ""
	Q:'$D(^MR(mradm,"PRO",1)) ""
	S Height=$P(^MR(mradm,"PRO",1),"^",20)
	S:Height'="" Height=Height_"CM"
	Q Height
}

/// Description:根据患者rowid取出年龄
ClassMethod GetAge(papmidr As %String, adm = "") As %String
{
	q "" //年龄为空，请调用计费组统一获取年龄方法 ////年龄统一调用接口wyx 2015-01-29
}

/// 转换门诊发药数量
/// 医嘱改造后建议:##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty/BQtyToPhaUomQty
ClassMethod getPackQty(inci, qty) As %String
{
	s result=""
	s buom=+$p(^INCI(inci,1),"^",10)  ; basic uom
	s puom=+$p(^INCI(inci,3),"^",6)  ; 
	i puom="" s puom=buom
	s buomdesc=$p(^CT("UOM",buom),"^",2)
	s puomdesc=$p(^CT("UOM",puom),"^",2)
	;
	s confac=##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)
    i qty#confac=0 d
    .s qty=qty/confac
    .s inciuom=puomdesc
    e  d
    .s inciuom=buomdesc
	q qty_"^"_inciuom
}

/// 检查要求皮试的医嘱,是否进行了皮试并且皮试为阴性 >=0  皮试正常,< 0 皮试不正常 
ClassMethod SkinTest(oeori As %String) As %String
{
	Q:oeori="" -1
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,5)) ""
	S SkinTestFlag=$P(^OEORD(ord,"I",itm,5),"^",2)
	S actiondr=$P(^OEORD(ord,"I",itm,11),"^",21)
	I SkinTestFlag'="Y" D
	.I actiondr=2 S result=10 //免试
	.e  I actiondr=3 S result=11 //续注
	.e  I actiondr=5 S result=12 //脱敏
	.e  S result=""
	E  D
	.S abnormal=$P(^OEORD(ord,"I",itm,11),"^",3)
	.S actiondr=$P(^OEORD(ord,"I",itm,11),"^",21)
	.I abnormal="N"  S result=1 
	.E  D
	..S result=-6 //未结果
	..i abnormal="Y" S result=-1  
	..e  i actiondr=1 S result=-5 //原液
	Q result
}

/// 取医嘱诊断
/// Type(GX-西药,GZ-中药,GC-草药)
/// w ##class(web.DHCOutPhCommon).GetMRDiagnosDesc(1385,",","")
ClassMethod GetMRDiagnosDesc(MRAdmRowid As %String, DelimStr As %String, Type As %String = "") As %String
{
 q:MRAdmRowid="" ""
 s MRAdmRowid=$p(^PAADM(MRAdmRowid),"^",61)
 q:MRAdmRowid="" ""
 s retval=""
 s i=0
 Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
 d obj.Execute(MRAdmRowid)
 For  Quit:'obj.Next()  Do
 .s Desc=obj.Data("MRDIAICDCodeDRDesc")
 .s Rowid=obj.Data("ID")
 .s CodeRowid=obj.Data("MRDIAICDCodeDR")
 .s MRDesc=obj.Data("MRDIADesc")
 .s ZYZDFlag=$p($g(^MRC("ID",+CodeRowid)),"^",15) //中医诊断标志
 .q:(Type="GC")&&(ZYZDFlag'="Y") ;取中医诊断,过滤非中医诊断
 .q:(Type="GX")&&(ZYZDFlag="Y")  ;取西医诊断,过滤中医诊断
 .if MRDesc'="" s MRDesc=$LIST(MRDesc,1)
 .i Desc="" s Desc=MRDesc
 .e  d
 ..i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
 .s i=i+1
 .s Desc=i_"."_Desc
 .if retval="" s retval=Desc
 .e  s retval=retval_DelimStr_Desc
 d obj.Close()
 q $ZCVT($g(retval),"O","JS")
}

/// 取医嘱开单科室
ClassMethod GetOrdDocLoc(oeori As %String) As %String
{
   s ord=+oeori
   s itm=$p(oeori,"||",2)
   s orddeptdr=$p(^OEORD(ord,"I",itm,1),"^",3)
   s ctloc=$p(^CTLOC(orddeptdr),"^",2)
   i $F(ctloc,"-") s ctloc=$p(ctloc,"-",2)
   q orddeptdr_"^"_ctloc
}

/// 取医嘱开单医生
ClassMethod GetOrdDoctor(oeori As %String) As %String
{
   s ord=+oeori
   s itm=$p(oeori,"||",2)
   s doctor=""
   s orddoctdr=$p($g(^OEORD(ord,"I",itm,1)),"^",11) ;医师
   i orddoctdr'="" s doctor=$p($g(^CTPCP(orddoctdr,1)),"^",2)
   q orddoctdr_"^"_doctor
}

/// 取医嘱开单日期
ClassMethod GetOrdDate(oeori As %String) As %String
{
   s ord=+oeori
   s itm=$p(oeori,"||",2)
   s orddate=$p(^OEORD(ord,"I",itm,3),"^",7)
   i orddate'="" s orddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(orddate)
   q orddate
}

/// 取医嘱备注
/// 草药备注:$p(^OEORD(ord,"I",itm,2),"^",8)
ClassMethod GetOrdRemark(oeori As %String) As %String
{
   s ord=+oeori
   s itm=$p(oeori,"||",2)
   q:'$d(^OEORD(ord,"I",itm)) ""
   s memo=""
   s num="0" f  s num=$o(^OEORD(ord,"I",itm,"DEP",num)) q:num=""  d
   .s memo=memo_$g(^OEORD(ord,"I",itm,"DEP",num))
   q memo
}

/// description: 就诊科室集合
/// w ##class(%ResultSet).RunQuery("web.DHCOutPhCommon","QueryDept","a")
Query QueryDept(input As %String) As websys.Query(ROWSPEC = "科室:%String,ID:%String")
{
}

ClassMethod QueryDeptExecute(ByRef QHandle As %Binary, input As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s input=$g(input)
	s input=$ZCVT(input,"U") 
	s ctloc=0
	f  s ctloc=$o(^CTLOC(ctloc)) q:ctloc=""  d
	.s ctlocdesc="",loctype=""
	.s ctlocdesc=$p(^CTLOC(ctloc),"^",2)
	.s ctlocdesc=$ZCVT(ctlocdesc,"U")
	.s ctlocconname=$zcvt($p(^CTLOC(ctloc),"^",43),"U")
	.q:(input'="")&&(ctlocdesc'[input)&&(ctlocconname'[input)
	.set Data=$lb(ctlocdesc,ctloc)
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 取科室医生集
Query QueryDoctor(depid) As %SQLQuery(CONTAINID = 1, ROWSPEC = "医生:%String,RowID:%String")
{
	SELECT RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR 
	FROM SQLUser.RB_RESOURCE
	WHERE (RES_CTLOC_DR = :depid
	and (res_schedulerequired <>'Y'))
}

/// 取管制分类
ClassMethod getPoisonByInci(inci) As %String
{
	q:inci="" ""
	s arcim=$p($g(^INCI(inci,1)),"^",3)
	q:arcim="" ""
	s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
	s phcdf=$p($g(^ARCIM(sub,ver,1)),"^",12) q:phcdf="" ""
	s phcd=+phcdf
	s poisondr=$p($g(^PHCD(phcd,1)),"^",4) q:poisondr="" ""
	s desc=$p($g(^PHCPO(poisondr)),"^",2)
	s code=$p($g(^PHCPO(poisondr)),"^",1)
	q poisondr_"^"_code_"^"_desc
}

/// 取患者年龄,年龄统一调用接口
ClassMethod GetPatientAgeDesc(PatientID As %String, adm = "") As %String
{
	q ##class(web.DHCSTKUTIL).GetAge(PatientID,adm)
}

/// 拼接年龄
ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
	if AgeYear>14 s AgeDesc=AgeYear_"岁"
	else  d
	.i AgeYear=0 s AgeYear=""
	.e  s AgeYear=AgeYear_"岁"
	.i AgeMonth=0 s AgeMonth=""
	.e  s AgeMonth=AgeMonth_"月"
	.i AgeDay=0 s AgeDay=""
	.e  s AgeDay=AgeDay_"天"
	.s AgeDesc=AgeYear_AgeMonth_AgeDay
	Q AgeDesc
}

/// Description:检查处方医嘱是否已停 0 没停，1 全已停
/// Creator:LiangQiang
/// CreatDate:2011-02-21
ClassMethod GetOrdXState(prescno, phl = "") As %String
{
     s xflag="D"
     s locdr=$p(^DHCPHLOC(phl),"^",1)   
     s retflag=0,ordnum=0,xnum=0
     s ord=""
     f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:ord=""  d
     .s itm=""
     .f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:itm=""  d
     ..s oeori=ord_"||"_itm
     ..s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
     ..q:prescno'=OEPrescNo
     ..s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
     ..q:locdr'=reclocdr
     ..s ordnum=ordnum+1
     ..s ordstatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)
     ..i ordstatus=xflag d
     ...s xnum=xnum+1
     i ($g(ordnum)'=0)&&($g(xnum)'=0) d
     .i ordnum=xnum d
     ..s retflag=1
     q retflag
}

/// Description:获取papmi
/// Creator:LiangQiang
/// CreatDate:2011-02-21
ClassMethod GetPapmiByPresc(prescno) As %String
{
	s tmpOrd=$o(^OEORD(0,"PrescNo",prescno,0))
	q:tmpOrd="" ""
	s admId=$p(^OEORD(tmpOrd),"^",1)
	q $p($g(^PAADM(+admId)),"^",1)
}

/// 取库存项价格,售价
ClassMethod GetItmPrice(INCITM As %String, STTDATE As %String, LOCDR = "") As %Currency
{
	s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(LOCDR)
	s HospDr=$p(HospString,"^",1)
	s sp=##Class(web.DHCSTPRICE).GetSp(INCITM,STTDATE,"",HospDr,"")	//zhouyg 20150113
	q sp
}

/// 1未付费  0已付费
/// Creator:LiangQiang
/// CreatDate:2011-02-21
ClassMethod GetOrdPayState(prescno, phl = "") As %String
{
     s flag="P"
     s retflag=0
     s ord=""
     f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:ord=""  d
     .s itm=""
     .f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:itm=""  d
     ..s oeori=ord_"||"_itm
     ..s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
     ..q:prescno'=OEPrescNo
     ..s ordstatus=$p(^OEORD(ord,"I",itm,3),"^",5)
     ..i ordstatus'=flag d
     ...s retflag=1
     q retflag
}

/// 取草药剂数
ClassMethod GetQueFactor(prescno, phl = "") As %String
{
	s que1Id=##class(web.DHCSTCOMMONORDER).PrescCYQueId(prescno)
	q:que1Id="" ""
	s duraId=$p($g(^PAQUE1(que1Id,"DHC")),"^",10)
	q $p($g(^PHCDU(+duraId)),"^",2)
}

/// 取发票中处方总金额
ClassMethod GetPriceByInv(phl, prt, prescno) As %String
{
	 s summoney=0
	 s ctlocdr=$p(^DHCPHLOC(phl),"^",1)
     s bci="0"
	 f  s bci=$o(^DHCBCI(0,"INV",prt,bci)) q:(bci="")!(bci="0")  d
	 .s patbill=""
	 .s patbill=+$p(^DHCBCI(bci),"^",2)
	 .s patbillsub="0"
	 .f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="0")  d
	 ..s orditm="",ord="",itm="",dispflag="",invprescno=""
	 ..q:$g(^DHCPB(patbill,"O",patbillsub))=""
	 ..s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	 ..s ord=$p(orditm,"||",1),itm=$p(orditm,"||",2)
	 ..s recplocdr=""
	 ..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	 ..q:recplocdr=""
	 ..q:recplocdr'=ctlocdr 
	 ..s invprescno=$p(^OEORD(ord,"I",itm,1),"^",14)
	 ..q:invprescno=""
	 ..q:invprescno'=prescno
	 ..s qty=0,money=0
	 ..s qty=+$p(^DHCPB(patbill,"O",patbillsub),"^",5)
	 ..s money=+$p(^DHCPB(patbill,"O",patbillsub),"^",8)
	 ..s summoney=summoney+money
	 q summoney
}

/// 取发票中医嘱单价与金额
/// Update: zhouyg 20160216 添加paidFlag返回值，判断此发票是否有次医嘱的收费,0-未收费，1-已经收费
ClassMethod GetBasPriceByInv(prt, oeori)
{
  s retprice=0
  s money=0
  s paidFlag=0	
  q:prt="" retprice_"^"_money_"^"_paidFlag
  s dbci="0"
  f  s dbci=$o(^DHCBCI(0,"INV",prt,dbci)) q:(dbci="0")!(dbci="")  d
  .s patbill=""
  .s patbill=+$p(^DHCBCI(dbci),"^",2)
  .s billsub="0"
  .f  s billsub=$o(^DHCPBi(0,"OEORI",oeori,patbill,billsub)) q:(billsub="0")!(billsub="")  d
  ..s basprice=0
  ..q:'$d(^DHCPB(patbill,"O",billsub))
  ..s basprice=$p(^DHCPB(patbill,"O",billsub),"^",7)
  ..s money=+$p(^DHCPB(patbill,"O",billsub),"^",8)
  ..s retprice=basprice
  ..s paidFlag=1
  q retprice_"^"_money_"^"_paidFlag
}

/// Description:取发票中打包子表的单价和金额
/// Creator:	hulihua
/// CreateDate:	2018-06-08
/// Table:      DHC_PatientBill、DHC_PatBillOrder、DHC_PatBillDetails
/// Input:		prt-发票ID, dspbatchid-打包子表ID
/// Output:		
/// Return：	retprice-单价、money-金额、paidFlag-判断此发票是否有次医嘱的收费(0-未收费，1-已经收费)
/// Debug:		w ##class(web.DHCOutPhCommon).GetDspBatPriceByInv("1||1")
ClassMethod GetDspBatPriceByInv(prt As %String, dspbatchid As %String) As %String
{
  s retprice=0
  s money=0
  s paidFlag=0	
  q:prt="" retprice_"^"_money_"^"_paidFlag
  s dbci=0
  f  s dbci=$o(^DHCBCI(0,"INV",prt,dbci)) q:(dbci="0")!(dbci="")  d
  .s patbill=""
  .s patbill=+$p(^DHCBCI(dbci),"^",2)
  .s billch=0
  .f  s billch=$o(^DHCPB(0,"DSPBDR",dspbatchid,patbill,billch)) q:billch=""  d
  ..s basprice=0
  ..q:'$d(^DHCPB(patbill,"O",billch))
  ..s billsub=0
  ..f  s billsub=$o(^DHCPB(0,"DSPBDR",dspbatchid,patbill,billch,billsub)) q:billsub=""  d
  ...s basprice=$p(^DHCPB(patbill,"O",billch,"D",billsub),"^",4)
  ...s money=+$p(^DHCPB(patbill,"O",billch,"D",billsub),"^",7)
  ...s retprice=basprice
  ...s paidFlag=1
  ..
  .
  q retprice_"^"_money_"^"_paidFlag
}

/// 获取库存项ID
/// 医嘱改造后,该方法不再合适
ClassMethod GetInciByOrditm(oeori)
{
	 s ord=$p(oeori,"||",1)
	 s itm=$p(oeori,"||",2)
	 s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	 s itmmastid=$p(itmmast,"||",1) 
	 s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,""))
	 q inci
}

/// 获取科室和医生
/// w ##class(web.DHCOutPhCommon).GetOrdDoc("O180710000007","308")
ClassMethod GetOrdDoc(presc As %String, locdr) As %String
{
   s ord=""
   f  s ord=$o(^OEORD(0,"PrescNo",presc,ord)) q:ord=""  d
   .s itm=""
   .f  s itm=$o(^OEORD(0,"PrescNo",presc,ord,itm)) q:itm=""  d
   ..s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
   ..q:(locdr'=reclocdr)&(locdr'="")
   ..s orddeptdr=$p(^OEORD(ord,"I",itm,7),"^",2)  //开单科室
   ..s ctloc=$p(^CTLOC(orddeptdr),"^",2)
   ..i $F(ctloc,"-") s ctloc=$p(ctloc,"-",2)
   ..s orddate=+$p(^OEORD(ord,"I",itm,3),"^",7)
   ..i orddate'="" s orddate=$zd(orddate,3)
   ..s doctor=""
   ..s orddoctdr=$p($g(^OEORD(ord,"I",itm,7)),"^",1) ;医师    //add by qhj20180724
   ..i orddoctdr'=""  s doctor=$p($g(^SSU("SSUSR",orddoctdr)),"^",2)
   ..;s orddoctdr=$p($g(^OEORD(ord,"I",itm,1)),"^",11) ;医师     //这个节点体检医生的节点数据为空
   ..;i orddoctdr'="" s doctor=$p($g(^CTPCP(orddoctdr,1)),"^",2)
   ..s orddate=+$p(^OEORD(ord,"I",itm,3),"^",7)
   ..i orddate'="" s orddate=$zd(orddate,3)
   q $g(ctloc)_"^"_$g(doctor)_"^"_$g(orddate)_"^"_$g(orddoctdr)_"^"_$g(orddeptdr)
}

/// 获取所有医嘱备注
ClassMethod GetOrdRemarkByPrescNo(presc As %String, locdr = "") As %String
{
   s ret=""
   s ord=""
   f  s ord=$o(^OEORD(0,"PrescNo",presc,ord)) q:ord=""  d
   .s itm=""
   .f  s itm=$o(^OEORD(0,"PrescNo",presc,ord,itm)) q:itm=""  d 
   ..q:+itm=0
   ..q:(locdr'="")&&(locdr'=$p(^OEORD(ord,"I",itm,3),"^",6))
   ..s remark=..GetOrdRemark(ord_"||"_itm)
   ..i remark'="" d
   ...i ret'="" d
   ....s ret=ret_","_remark
   ...e  d
   ....s ret=remark
    
   q $g(ret)
}

/// 获取发票ID通过发票号
ClassMethod GetInvByPrescNo(inv) As %String
{
	q:inv="" ""
	s prt=$o(^DHCINVPRT(0,"INV",inv,""))
	q prt
}

/// 获取科室关联ID
ClassMethod GetPhlByCtloc(ctlocdr)
{
	 s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	 q phl
}

/// 根据卡号取登记号
ClassMethod GetPmiNoFrCardNo(cardno)
{
	i cardno="" q -1
	s cardrow="0",retpatno=""
	f  s cardrow=$o(^DHCCARDi("CF",0,"CardNo",cardno,cardrow)) q:(cardrow="")!(cardrow="0")  d
	.s cardstatus="",pmi=""
	.s cardstatus=$p(^DHCCARD("CF",cardrow),"^",10)
	.i cardstatus="" s cardstatus="N"
	.q:cardstatus'["N"
	.s pmi=+$p(^DHCCARD("CF",cardrow),"^",4)
	.s retpatno=$p(^PAPER(pmi,"PAT",1),"^",2)
	i retpatno="" q -1
	q retpatno
}

/// 获取用法集合  
Query GetInstDs(inputs As %String) As %SQLQuery(CONTAINID = 1)
{
     SELECT PHCIN_Desc1,PHCIN_RowId FROM PHC_Instruc
	 where (%ALPHAUP(PHCIN_Desc1) %STARTSWITH %ALPHAUP(:inputs))
}

/// w ##class(%ResultSet).RunQuery("web.DHCOutPhCommon","GetDrugDs",,"a")
Query GetDrugDs(input As %String) As websys.Query(ROWSPEC = "药品名称:%String,ID:%String")
{
}

/// 获取药品名称集合  
ClassMethod GetDrugDsExecute(ByRef QHandle As %Binary, input As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	s stkgrptype="",stkgrpcode=""
	i input="" S QHandle=$lb(0,repid,0)	Quit $$$OK 
	s input=$g(input)
	s input=$ZCVT(input,"U") 
	k ^DHCTMPSAME($j)
	s num=0
	k ^DHCPHTMP($j,"Itmrowid"),^DHCPHTMP($j,"Itmcode"),^DHCPHTMP($j,"Itmdesc"),^DHCPHTMP($j,"ItmUO")
    s inca="0"
    f  s inca=$o(^INCALIAS(inca)) q:(inca="")!(inca="0")  d
     .s incatext=""
     .s incatext=$p(^INCALIAS(inca),"^",4)
     .s incatext=$ZCVT(incatext,"U")
     .q:incatext'[input
     .s inci=""
     .s inci=+$p(^INCALIAS(inca),"^",1)
     .q:'$d(^INCI(inci,1))
     .q:##class(web.DHCSTITMDESC).CatType(inci)'="G"
     .q:$d(^DHCTMPSAME($j,inci))
     .s ^DHCTMPSAME($j,inci)="ok"
	 .s num=num+1
	 .s ^DHCPHTMP($j,"Itmrowid",num)=inci
	 .s ^DHCPHTMP($j,"Itmcode",num)=$p(^INCI(inci,1),"^",1)
	 .s ^DHCPHTMP($j,"Itmdesc",num)=$p(^INCI(inci,1),"^",2)
	 .s uomdr=$p(^INCI(inci,1),"^",10)
	 .s ^DHCPHTMP($j,"ItmUO",num)="" i uomdr'="" s ^DHCPHTMP($j,"ItmUO",num)=$p($g(^CT("UOM",+uomdr)),"^",2)
     s ii=1
     s sysdate=""
     s sysdate=+$h+1
     s ii=1
     for ii=1:1:num 
     { 
      s itmrowid="",itmcode="",itmdesc=""
      s itmrowid=^DHCPHTMP($j,"Itmrowid",ii)
      s itmcode=^DHCPHTMP($j,"Itmcode",ii)
      s itmdesc=^DHCPHTMP($j,"Itmdesc",ii)
	  set Data=$lb(itmdesc,itmrowid)
	  Set ^CacheTemp(repid,ind)=Data
	  Set ind=ind+1
	 }
 	 Set QHandle=$lb(0,repid,0)
	 Quit $$$OK
}

/// Descriprtion:判断处方是否基数药
/// Input:prescno -处方号,
/// Output: 0 - 不符条件  , 1 - 符合条件
/// Creator:Liang Qiang
/// CreatDate:2012-07-30
ClassMethod ChkOrdBaseMed(prescno) As %String
{
	q:prescno="" 0
	s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	q:ord="" 0 
	s itm=$o(^OEORD(0,"PrescNo",prescno,ord,"")) 
	s arcitm=$p(^OEORD(ord,"I",itm,1),"^",2)                       	
	s recloc=+$p($g(^OEORD(ord,"I",itm,3)),"^",6)
	s instdr=$p($g(^OEORD(ord,"I",itm,2)),"^",7)
	s doclocdr=$p($g(^OEORD(ord,"I",itm,7)),"^",2) 
	s uselocdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",31) //使用科室
	s chkbase=##class(web.DHCOutPhAddBaseMed).ChkPhbmExist(arcitm,instdr,doclocdr,uselocdr)
	q chkbase
}

/// Descriprtion:根据处方号获取使用科室
/// Input:prescno -处方号,
/// Output:使用科室ID
/// Creator:Liang Qiang
/// CreatDate:2012-07-31
ClassMethod GetBaseOrdUseLocByPresc(prescno) As %String
{
    q:prescno="" ""
    s ord=$o(^OEORD(0,"PrescNo",prescno,"")) 
    q:ord="" ""
    q:##class(web.DHCOutPhCommon).ChkOrdBaseMed(prescno)=0 ""
	s itm=$o(^OEORD(0,"PrescNo",prescno,ord,"")) 
	s arcitm=$p($g(^OEORD(ord,"I",itm,1)),"^",2)                       	
	s recloc=+$p($g(^OEORD(ord,"I",itm,3)),"^",6)
	s instdr=$p($g(^OEORD(ord,"I",itm,2)),"^",7)
	//s doclocdr=$p(^OEORD(ord,"I",itm,7),"^",2) 
	s uselocdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",31) //使用科室 
	q uselocdr
}

/// 已开完的医嘱按使用科室判断是否基数药,如果按配置判断有可能变了,liangqiang
ClassMethod GetOrdUseLocByPresc(prescno) As %String
{
	q:prescno="" ""
	s ord=$o(^OEORD(0,"PrescNo",prescno,"")) 
    q:ord="" ""
    s itm=$o(^OEORD(0,"PrescNo",prescno,ord,"")) 
	s uselocdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",31) //使用科室 
	q uselocdr
}

/// 取留观室集合 
/// Table:CT_LOC,PAC_WardRoom     "EM" 类型 且  medtark 右键 "房间分配" 有值
/// Creator:Liang Qiang
/// CreateDate:2012-07-31
ClassMethod GetLgAreaDs() As %String
{
	s ret=""
	s ctloctype="EM"
	s ctlocdr=""
	f  s ctlocdr=$o(^CTLOC(0,"LocType",ctloctype,ctlocdr)) q:ctlocdr=""  d
	.s datefrom=$p(^CTLOC(ctlocdr),"^",24)
	.q:datefrom=""
	.q:(datefrom'="")&(datefrom>+$h)
	.s dateto=$p(^CTLOC(ctlocdr),"^",25)
	.q:(dateto'="")&(dateto'>+$h)
	.s warddr=$o(^PAWARD(0,"WARD_LocationDR",ctlocdr,""))
	.q:warddr=""
	.s flag=0
	.s roomsub=0 
	.f  s roomsub=$o(^PAWARD(warddr,"ROOM",roomsub)) q:(roomsub=0)||(roomsub="")  d
	..s roomdr=$p(^PAWARD(warddr,"ROOM",roomsub),"^",1)
	..q:roomdr=""
	..s flag=1
	.q:flag=0
	.s ctlocdesc=$p(^CTLOC(ctlocdr),"^",2)
	.i $F(ctlocdesc,"-") s ctlocdesc=$p(ctlocdesc,"-",2)
	.s str=ctlocdr_$C(1)_ctlocdesc
	.i ret="" d
	..s ret=str
	.e  d
	..s ret=ret_"^"_str
	.
	q ret
}

/// 根据ADM获取病人姓名,登记号,就诊日期等
ClassMethod GetPNameRegNo(Adm As %String = "") As %String
{
	q:Adm="" ""
	q:'$d(^PAADM(Adm)) ""
	s papmidr=$p(^PAADM(Adm),"^",1)
	&sql(select papmi_no,papmi_name into :pname,:Regno from SQLUser.PA_PatMas where papmi_rowid=:papmidr)
    s padmdate=$p(^PAADM(Adm),"^",6)  
    s padmdate=$ZD(padmdate,4)
    s curdate=$ZD($H,3)
	q pname_"^"_Regno_"^"_padmdate_"^"_curdate
}

/// 判断该处方是否留观  
/// return: 0 非  1 是
ClassMethod ChkLGFlagByPrescNo(prescno) As %String
{
	q:prescno="" 0
	s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	q:ord="" 0 
	s itm=$o(^OEORD(0,"PrescNo",prescno,ord,"")) 
    q:ord="" 0                   	
    s lgflag=$p($g(^OEORD(+ord,"I",itm,"DHC")),"^",17)
    q:lgflag="" 0
	q 1
}

/// 取药房科室发药机标志
ClassMethod GetPhaLocMacFlag(phl) As %String
{
	q:phl="" ""
    s dispmachine=$p($g(^DHCPHLOC(phl)),"^",15)  //发药机
	q dispmachine
}

/// 取药房科室发送数据标志
ClassMethod GetPhaLocSendDataFlag(phl) As %String
{
	q:phl="" ""
	s senddataflag=$p($g(^DHCPHLOC(phl)),"^",12)  //发送数据
	q senddataflag
}

/// 判断医嘱是否有退药申请
/// Input:医嘱ID
/// Output: 1 有申请单  非 1 无申请单 (供医生站调用)
/// w ##Class(web.DHCOutPhCommon).GetReqExistFlag(orditem)
ClassMethod GetReqExistFlag(orditem) As %String
{
	s ret=0
	s ord=$p(orditem,"||",1)
	s itm=$p(orditem,"||",2)
	q:ord="" ""
	q:itm="" ""
	q:'$d(^OEORD(ord,"I",itm)) ""
	s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
	q:prescno="" ""
	s phd=""
	f  s phd=$o(^DHCPHDISPi("PRESCNO",prescno,phd)) q:phd=""  d
	.s sub=""
	.f  s sub=$o(^DHCPHDI(phd,"PHDI",sub)) q:sub=""  d
	..s oeori=$p(^DHCPHDI(phd,"PHDI",sub),"^",5)
	..q:oeori'=orditem
	..s phditm=phd_"||"_sub
	..q:'$D(^DHCPHREQi(phditm,"PHDI"))
	..s ret=1
	q ret
}

/// 留观室Query
Query QueryGetLgArea() As websys.Query(ROWSPEC = "Tctlocdesc:%String,Tctlocdr:%String") [ SqlProc ]
{
}

ClassMethod QueryGetLgAreaExecute(ByRef QHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s str=..GetLgAreaDs()
	s cnt=$l(str,"^")
	f i=1:1:cnt d
	.s ctlocstr=$p(str,"^",i)
	.s ctlocdr=$p(ctlocstr,$c(1),1)
	.s ctlocdesc=$p(ctlocstr,$c(1),2)
	.s Data=$lb(ctlocdesc,ctlocdr)
 	.s ^CacheTemp(repid,ind)=Data	
 	.s ind=ind+1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 旋转药柜接口发送标志
ClassMethod GetPhaLocRotateCabinetFlag(phl) As %String
{
	q:phl="" ""
	s rotateflag=$p($g(^GLobDHCPHLOC(phl)),"^",8)
	q rotateflag
}

/// 门诊药房业务过程是否需要考虑判断接收科室
/// 考虑范围：支配科室发药，常规业务发药
/// 不考虑范围：混合药房发药
/// 1 考虑 0不考虑;此处根据项目实际情况配置
ClassMethod GetChkRecLocFlag()
{
	
	 //Q 0
	 Q 1
}

/// description:本医院下的所在药房科室
ClassMethod GetPatPhlStr()
{
	s phl="",phlStr=""
	f  s phl=$o(^DHCPHLOC(phl)) q:phl=""  d 
	.s cyflag=$p(^DHCPHLOC(phl),"^",6)
	.q:cyflag=1 //草药除外
	.i phlStr="" d
	..s phlStr=phl
	.e  d
	..s phlStr=phlStr_"^"_phl
	q phlStr
}

/// 获取处方收费日期
/// 门诊药房以处方为准,根据发票取数据的尽量不使用
ClassMethod GetOrdPayDate(prt As %String) As %String
{
	q:prt="" ""
	s phar=""
	f  s phar=$o(^DHCPHARi("PRT",prt,phar)) q:phar=""  d
	.s phardate=$p(^DHCPHARW(phar),"^",2)
	.i phardate'="" d
	..s phardate=$zd(phardate,3)
	.s phartime=$p(^DHCPHARW(phar),"^",5)
	.i phartime'="" d
	..s phartime=$zt(phartime,1)
	..s phartime=$p(phartime,":",1,2)
	q $g(phardate)_" "_$g(phartime)
}

/// Description:得到处方类型(医保,自费)-费别
/// Creator:Liang Qiang
/// CreatDate:2011-08-31
/// w ##class(web.DHCOutPhCommon).GetPrescType("I18071808805")
ClassMethod GetPrescType(prescno)
{
	q ..GetPrescFeeType(prescno)
}

/// Description:得到处方打印类型(毒麻,精神一类,精神二类)
/// Creator:Liang Qiang
/// CreatDate:2011-08-31
ClassMethod GetPrescPrtTitle(presc)
{
	s prescord="",prescitm="",retval=""
	s prescord=$o(^OEORD(0,"PrescNo",presc,""))
	i prescord="" q ""
	s prescitm=$o(^OEORD(0,"PrescNo",presc,prescord,""))
	s prescitmmast=""
    s prescitmmast=$p(^OEORD(prescord,"I",prescitm,1),"^",2)
    s prescdrgform="",prescdrgmast=""
    s prescdrgform=$p(^ARCIM($p(prescitmmast,"||",1),$p(prescitmmast,"||",2),1),"^",12)
    s prescdrgmast=$p(prescdrgform,"||",1)
    s prescpoisondr=""
    i prescdrgmast'=0 s prescpoisondr=+$p(^PHCD(prescdrgmast,1),"^",4)
    i prescpoisondr'="" s poisondesc=$p(^PHCPO(prescpoisondr),"^",2)
    s prescitmcat="",oeccat="",oecatdesc=""
    s prescitmcat=$p(^ARCIM($p(prescitmmast,"||",1),$p(prescitmmast,"||",2),1),"^",10)
	s oeccat=$p(^ARC("IC",prescitmcat),"^",8)
	s oecatdesc=$p(^OEC("ORCAT",oeccat),"^",2)
	s poisonflag=0
	s poisonflag=..CheckPoison(poisondesc)
	i poisonflag=1 s retval=poisondesc
	e  s retval=""
	q retval
}

ClassMethod CheckPoison(poisondesc)
{
	 i poisondesc="" q 0
	 i poisondesc["毒" q 1
	 i poisondesc["麻" q 1
	 i poisondesc["精" q 1
	 q 0
}

/// Description:本医院下的所在药房科室,仅草药
ClassMethod GetPatCyPhlStr()
{
   s phl="",phlStr=""
   f  s phl=$o(^DHCPHLOC(phl)) q:phl=""  d 
   .s cyflag=$p(^DHCPHLOC(phl),"^",6)
   .q:cyflag'=1
   .i phlStr="" d
   ..s phlStr=phl
   .e  d
   ..s phlStr=phlStr_"^"_phl
   q phlStr
}

/// 取主医嘱Rowid
ClassMethod GetMainOeori(oeori As %String) As %String
{
	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	Q:'$D(^OEORD(ord,"I",chl,11)) ""
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	Q:loeori'="" loeori
 	Q oeori
}

/// 检查是否关联医嘱
/// return: 1 -是 ，0- 否
ClassMethod ChkOrdGL(moeori)
{
	s mord=+moeori
	s m=0
	s lchl=""
	f  s lchl=$O(^OEORDi(0,"OEORI",mord,moeori,lchl)) q:(lchl="")||(m>1)  d
	.s m=m+1
	i m>1 q 1
	q m
}

/// Description:根据处方号判断是否计费审核描述(协和接口)
ClassMethod GetPrescBillAuditDesc(PrescNo As %String) As %String
{
	//s ret=..GetPrescBillAuditFlag(PrescNo)
	//q:ret=0 ""
	//q:ret=1 "[ 职工保健未审核 ]"
	q ""
}

/// Creator:Liang Qiang
/// CreatDate:2011-08-31
/// Description:根据处方号判断是否计费审核(协和接口)
/// Input: 处方号
/// Output:
/// Return: 0:未审核,1:已审核
/// Other:
ClassMethod GetPrescBillAuditFlag(PrescNo As %String) As %String
{
	s PrescTypeCode=""
    s ord=$o(^OEORD(0,"PrescNo",PrescNo,"")) 
    s itm=$o(^OEORD(0,"PrescNo",PrescNo,ord,"") ) 
    s preason=$p(^OEORD(ord,"I",itm,11),"^",18)
    s dhcprescrow=$o(^DHCPAQPT(0,"PrescNo",PrescNo,""))
    i dhcprescrow'=""  d
    .s psonrow="",pson="",psoncode=""
    .s psonrow=+$p(^DHCPAQPT(dhcprescrow),"^",2)
    .s pson=$p(^DHCPAADMPrescType(psonrow),"^",2)
    .s PrescTypeCode=pson
    e  d
    .s PrescTypeCode=preason
    q:PrescTypeCode="" ""
    s ret=##class(web.DHCBillInterface).ICheckZGBJFlagByAdmRea(PrescTypeCode,"")
    q:ret'="Y" ""
	s chkflag=0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",PrescNo,ord)) q:(ord="")||(chkflag=1)  d
	.s itm=""
	.f  s itm=$o(^OEORD(0,"PrescNo",PrescNo,ord,itm)) q:(itm="")||(chkflag=1)  d
	..s orditm=ord_"||"_itm
	..s ret=##class(web.DHCBillInterface).ICheckOrdItmAuditStatus(orditm,"")
	..i ret="Y" s chkflag=1
	q chkflag
}

/// Description:查找发药ID
/// Creator:	zhouyg
/// CreatDate:	2013-03-08
/// Input：		处方号,发票ID(DHC_InvPrt),dhc_phloc的ID
/// Output:		发药主ID
ClassMethod GetPhdRowID(prescno, prt, phl = "") As %String
{
	s RetPhdID=""
	s phdisp=""
	f  s phdisp=$o(^DHCPHDISPi("PRESCNO",prescno,phdisp)) q:(phdisp="")!(RetPhdID'="")  d
	.s phdphl=$p(^DHCPHDISP(phdisp,1),"^",1)
	.q:(phl'=phdphl)&(phl'="")
	.s phprt=$p(^DHCPHDISP(phdisp),"^",2)
	.q:(phprt'=prt)&(prt'="")
	.s RetPhdID=phdisp
	q RetPhdID
}

/// 获取处方的接收科室
ClassMethod GetPrescRecLoc(prescno)
{
	q:prescno="" ""
	s tmpOrd=$o(^OEORD(0,"PrescNo",prescno,""))
	q:tmpOrd="" ""
	s tmpOrdItm=$o(^OEORD(0,"PrescNo",prescno,tmpOrd,""))
	q:tmpOrdItm="" ""
	s recLocId=$p(^OEORD(tmpOrd,"I",tmpOrdItm,3),"^",6)
	q:recLocId="" ""
	s recLocDesc=$p(^CTLOC(recLocId),"^",2)
	q recLocDesc_"^"_recLocId
}

/// Description:从科室获取phl
ClassMethod GetPhlFrmLoc(ctlocdr)
{
	q:ctlocdr="" ""
	s phl=$o(^DHCPHLOCi("LOC",ctlocdr,""))
	q phl
}

/// Description:获取药房人员ID
ClassMethod GetPhPerson(ssusr)
{
	q:ssusr="" ""
	s php=$o(^DHCPHPERi("USR",ssusr,""))
	q php
}

/// 获取某欠药单上的处方金额
ClassMethod GetOweListMoney(phow)
{
	s total=0
	s sub=""
	f  s sub=$o(^DHCPHOW(phow,"I",sub)) q:sub=""  d
	.s qty=$p(^DHCPHOW(phow,"I",sub),"^",2)
	.s price=$p(^DHCPHOW(phow,"I",sub),"^",3)
	.s pmount=qty*price
	.s pmount=$fn(pmount,"",2)
	.s total=total+pmount
	q total
}

/// w ##class(web.DHCOutPhCommon).GetSkinTestFlag("")
/// Description:取三大项中的皮试标志
/// Input:医嘱项rowid
/// Return:Y / N
ClassMethod GetSkinTestFlag(ArcItmId) As %String
{
	q:ArcItmId="" "N"
	s incId=$o(^INCI(0,"ARCIM_DR",+ArcItmId,""))
	q:incId="" "N"
	s itmAdd=$o(^DHCITMINFO(0,"INCI",incId,""))
	q:itmAdd="" "N"
	q $p($g(^DHCITMINFO(itmAdd)),"^",35)
}

/// Description:检查处方是否急诊留观等先发药后收费的处方已经配药了
/// Creator:	zhouyg
/// CreatDate:	2013-07-11
/// Input：		处方号，科室(dhc_phloc)
/// Output:		0 未配 1 已配
ClassMethod CheckToBillPy(prescno, phl = "") As %String
{
	q:prescno="" 0
	s ctlocID="",retflag=0
	i phl'="" d
	.s ctlocID=$p(^DHCPHLOC(phl),"^",1)   
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:(ord="")!(retflag=1)  d
	.s ordsub=""
	.f  s ordsub=$o(^OEORD(0,"PrescNo",prescno,ord,ordsub)) q:(ordsub="")!(retflag=1)  d
	..s reclocID=$p(^OEORD(ord,"I",ordsub,3),"^",6)
	..q:(ctlocID'="")&(ctlocID'=reclocID)
	..s EmLGflag=$p($g(^OEORD(ord,"I",ordsub,"DHC")),"^",17)
	..s ReadyToBill=$p($g(^OEORD(ord,"I",ordsub,12)),"^",26)
	..q:(EmLGflag'="1")&(ReadyToBill'="Y")	//不是急诊留观，也不是可以先发药后收费的就诊情况
	..s phdisp=""
	..f  s phdisp=$o(^DHCPHDISPi("PRESCNO",prescno,phdisp)) q:(phdisp="")!(retflag=1)  d
	...s phdphl=$p(^DHCPHDISP(phdisp,1),"^",1)
	...q:(phl'=phdphl)&(phl'="")
	...s retflag=1
	q retflag
}

/// Description:根据处方号取是否需要审核
/// Creator:	LiangQiang
/// CreatDate:	2014-02-11
/// Input：		处方号
/// Output:		0 不需 1 需要
ClassMethod GetOrdAuditFlagByPresc(prescno) As %String
{
	q:prescno="" 0
	s ord=$o(^OEORD(0,"PrescNo",prescno,"")) 
    q:ord="" 0
    s itm=$o(^OEORD(0,"PrescNo",prescno,ord,"")) 
    q:itm="" 0
	s ordItmId=ord_"||"_itm
    s dspId=$o(^DHCOEDISQTY(0,"OEORI",ordItmId,""))
	q:dspId="" ""
	s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
	s needAuditFlag=0
	s uselocdr=$p(^DHCOEDISQTY(dspId),"^",25) //使用科室 
	i uselocdr'=""  d
	.s hospId=$p(^CTLOC(reclocdr),"^",22)
	.s Param=""_"^"_reclocdr_"^"_""_"^"_$g(hospId)
	.s propVal= ##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTCOMMON","BaseMedNeedPhaAudit",Param)
	.i propVal="Y" s needAuditFlag=1
	e  d
	.s phl=$o(^DHCPHLOCi("LOC",reclocdr,""))
	.q:phl=""
	.s auditflag=$p(^DHCPHLOC(phl),"^",7)
	.i auditflag="Y" s needAuditFlag=1
	q needAuditFlag
}

/// Description:根据处方号取审核结果是否通过
/// Creator:	LiangQiang
/// CreatDate:	2014-02-11
/// Input：		处方号
/// Output:	　　"Y" 通过, "N" 未通过
/// w ##class(web.DHCOutPhCommon).GetOrdAuditResultByPresc("O16060100002")
ClassMethod GetOrdAuditResultByPresc(prescno) As %String
{
	q:prescno="" "N"
	q:prescno["H" "Y" // 体检病人默认不需审核
	q:##class(PHA.OP.COM.Method).IsCESFlagByPrescNo(prescno)="Y" "Y" // 系统恢复不需审核
	q:..GetOrdAuditFlagByPresc(prescno)'="1" "Y"
	// 1拒绝  2申诉  3通过  0未审 4 拒绝接受
	s result=##class(web.DHCSTCNTSCOMMON).CheckPrescNoStatus(prescno,"OA")
	q:result=0 ""
	q:result=1 "N"
	q:result=3 "Y"
	q:result=2 "S"
	q:result=4 "N"
	q "Y"
}

/// Description:根据处方号取发药拒绝结果
/// Creator:	LiangQiang
/// CreatDate:	2014-12-22
/// Input：		处方号
/// Output:	　　"" 未拒, "N" 已拒, "S" 申诉
ClassMethod GetOrdRefResultByPresc(prescno) As %String
{
	s result=##class(web.DHCSTCNTSCOMMON).CheckPrescNoStatus(prescno,"OR")
	q:result=0 ""
	q:result=1 "N"
	q:result=2 "S"
	q:result=4 "A"
	q "Y"
}

/// Description:根据科室取大通开关配置
/// Creator:	LiangQiang
/// CreatDate:	2014-12-22
/// Input：		科室
/// Output:	　　Y/N
ClassMethod GetDaTongConfig(locdr) As %String
{
	q:locdr="" ""
	s str=^DHCDocConfig("DTAdmDep")
	i str[locdr q "Y"
	q "N"
}

/// Description:取医嘱串
/// Creator:	LiangQiang
ClassMethod GetOrdStrByOrd(prescno) As %String
{
	s ret=""
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:(ord="")  d
	.s ordsub=""
	.f  s ordsub=$o(^OEORD(0,"PrescNo",prescno,ord,ordsub)) q:(ordsub="")  d
	..s oeori=ord_"||"_ordsub
	..s reclocID=$p(^OEORD(ord,"I",ordsub,3),"^",6)
	..s ordstatus=$p(^OEORD(ord,"I",ordsub,3),"^",5)
	..s EmLGflag=$p($g(^OEORD(ord,"I",ordsub,"DHC")),"^",17)
	..s ReadyToBill=$p($g(^OEORD(ord,"I",ordsub,12)),"^",26)
	..q:(EmLGflag'="1")&(ReadyToBill'="Y")&(ordstatus'="P")	//不是急诊留观，也不是可以先发药后收费的就诊情况"
	..s ordstatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1) 
	..q:((ordstatus'="V")&(ordstatus'="E"))&((EmLGflag="1")||(ReadyToBill="Y"))
	..i ret="" d
	...s ret=oeori
	..e  d
	...s ret=ret_"^"_oeori
	q:ret
}

/// Description:取发药子表ID
/// Creator:	zhouyg
/// CreatDate:	2015-01-14
/// Input：		处方号、发票ID、dhc_phloc,医嘱ID(OE_Orditem)
/// Output:		发药子ID
ClassMethod GetPhdItmIDByPrt(prescno, prt, phl, Oeori) As %String
{
	q:prescno="" ""
	q:Oeori="" ""
	s PhdID=..GetPhdRowID(prescno, prt, phl)
	q:PhdID="" ""
	s PhdItmID=""
	s phdsub=""
	s phdsub=$o(^DHCPHDI(0,"OEORI",Oeori,PhdID,phdsub))
	q:(phdsub="") ""
	s PhdItmID=PhdID_"||"_phdsub
	q PhdItmID
}

/// Description:根据医嘱和发药主表ID取发药子表ID
/// Creator:	zhouyg
/// CreatDate:	2015-01-14
/// Input：		发药主表ID,医嘱ID(OE_Orditem)
/// Output:		发药子ID
ClassMethod GetPhdItmID(PhdID, Oeori) As %String
{
	q:PhdID="" ""
	q:Oeori="" ""
	s PhdItmID=""
	s phdsub=""
	s phdsub=$o(^DHCPHDI(0,"OEORI",Oeori,PhdID,phdsub))
	q:(phdsub="") ""
	s PhdItmID=PhdID_"||"_phdsub
	q PhdItmID
}

/// Description:根据发药子表ID取售价
/// Creator:	zhouyg
/// CreatDate:	2015-01-14
/// Input：		发药子表ID
/// Output:		售价
ClassMethod GetPhdItmSp(PhdItmID) As %String
{
	q:PhdItmID="" 0
	s PhdID=$p(PhdItmID,"||",1)
	s phdsub=$p(PhdItmID,"||",2)
	s phlbsub=""
	s phlbsub=$o(^DHCPHDI(PhdID,"PHDI",phdsub,"INCLB",phlbsub))
	q:phlbsub="" ""
	s sp=$p(^DHCPHDI(PhdID,"PHDI",phdsub,"INCLB",phlbsub),"^",7)
	q sp
}

/// Description:根据处方号获取医生申诉信息
/// Creator:	yunhaibao
/// CreatDate:	2016-03-28
/// Input：		处方号
/// Output:	　　申诉内容
ClassMethod GetOrdAppealReasonByPresc(prescno) As %String
{
	s ret=##class(web.DHCSTCNTSCOMMON).GetOrdAppealReasonByPresc(prescno,"OR")
	q ret
}

/// creator:yunhaibao
/// createdate:20160425
/// description:根据科室id获取门诊药房配置id
/// w ##class(web.DHCOutPhCommon).GetPhLocByCtLoc(1111)
ClassMethod GetPhLocByCtLoc(ctloc)
{
	q:ctloc="" ""
	q $o(^DHCPHLOCi("LOC",ctloc,""))
}

/// Descript:	取门诊药房相关的参数配置属性
/// Creator:    hulihua
/// CreateDate: 2016-07-06
/// Table:
/// Input:		安全组id,科室id,用户id
/// Output:     
/// Return：	皮试发药标志^审核发药模式^默认计算工作量的时间段^分窗口工作量计算方法
ClassMethod GetParamProp(GroupId As %String = "", LocId As %String, UserId As %String = "") As %Library.String
{
   
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCOutPhCommon).%GetParameter("AppName")
    s NeedSkinTest=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"SKINTESTFLAG",Param) 	//是否调用药品不良反应报告！
    s AuditDispMode=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"AuditDispMode",Param) 			//需要调用的原因ID！
    s DefuWorkLoadTime=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefaultWorkLoadTime",Param)
    s WorkLoadWay=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"WorkLoadWay",Param)
    s Data1=NeedSkinTest_"^"_AuditDispMode_"^"_DefuWorkLoadTime_"^"_WorkLoadWay
    q Data1
}

/// creator:	yunhaibao
/// createdate: 2016-11-16
/// description:根据发药表id获取发药单状态
ClassMethod GetPhdStatus(PhdRowid As %String, PrescNo As %String = "") As %Library.String
{
	s PhdStatus=""
	i PhdRowid="" d
	.s ssresult=..GetOrdRefResultByPresc(PrescNo)
	.s:ssresult="S" PhdStatus="申诉(拒绝发药)"
	.s:ssresult="N" PhdStatus="拒绝发药"
	.s:ssresult="A" PhdStatus="接受(拒绝发药)"
	e  d
	.q:'$d(^DHCPHDISP(PhdRowid)) 
    .i $p(^DHCPHDISP(PhdRowid,1),"^",9)>0 s PhdStatus="已打印 "
    .i $p(^DHCPHDISP(PhdRowid,1),"^",6)>0 s PhdStatus="已配药"
    .i $p(^DHCPHDISP(PhdRowid),"^",4)>0 s PhdStatus="已发药"
    .i $p(^DHCPHDISP(PhdRowid,2),"^",2)>0 s PhdStatus="欠药发药"
    q PhdStatus
}

/// creator:	yunhaibao
/// createdate: 2016-12-22
/// description:根据医嘱id判断费用是否已经门诊转住院
/// input:      医嘱id
/// output:	   1:已转住院
/// others:	   w ##class(web.DHCOutPhCommon).PrtOPToIP("1982||3")
ClassMethod PrtOPToIP(Oeori)
{
	s admId=+$p(^OEORD(+Oeori),"^",1)
	q:'$d(^PAADM(admId)) ""
	q:$d(^DHCOPIPADMCON("OPADMORDER","OPAdm",admId,Oeori)) 1
	q 0
}

/// creator:	yunhaibao
/// createdate: 2017-02-10
/// description:根据医嘱id获取批次价模式首个批次id
/// input:      医嘱id
/// output:	    DHC_OEDispBatch
/// others:	    w ##class(web.DHCOutPhCommon).PrtOPToIP("1982||3")
/// 医嘱结构改造,计费组按打包字表记录,首个批次id已无意义
ClassMethod GetFirstInclbByOe(oeori)
{
	s dspid=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	q:(dspid="") ""
	q:'$D(^DHCOEDISQTY(dspid)) ""
	s dspbatid=$o(^DHCOEDISQTY(dspid,"I","0"))
	q:dspbatid="" ""
	s firstinclb=$p(^DHCOEDISQTY(dspid,"I",dspbatid),"^",1)
	q firstinclb
}

/// Descript:	获取门诊药房处方格式
/// Creator:    yunhaibao
/// CreateDate: 2018-03-08
/// w ##class(web.DHCOutPhCommon).GetPrescFmtProp("",100,"")
ClassMethod GetPrescFmtProp(GroupId As %String = "", LocId As %String, UserId As %String = "") As %Library.String
{
  
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCOutPhCommon).%GetParameter("AppName")
    s HERBAppName = "HERB.PC"
    s PrescXY=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"PrescXYFormat",Param) 
    s PrescCY=##class(web.DHCST.Common.AppCommon).GetAppPropValue(HERBAppName,"PrescCYFormat",Param)
    s AppName="DHCSTORDDISP"
    s PrescInCY=##class(web.DHCST.Common.AppCommon).GetAppPropValue(HERBAppName,"PrescInCYFormat",Param) 		
    i PrescXY="" s PrescXY="DHCOutPhPrescXY"
    i PrescCY="" s PrescCY="DHCOutPhPrescCY"
    i PrescInCY="" s PrescInCY="DHCInPhPrescCYVer"
    q PrescXY_"^"_PrescCY_"^"_PrescInCY
}

/// Description:按照处方号获取该处方的处方类型
/// Creator: 	hulihua
/// CreateDate: 2014-09-18
/// Table:      CT_Antibiotics,DHC_Antibiotics
/// Input:		presc-处方号
/// Output:
/// Return：	普通、急诊、儿科、麻醉、毒性、精一、精二    
/// Others:
/// w ##class(web.DHCOutPhCommon).GetPrescTitle("E210128000043")
ClassMethod GetPrescTitle(presc)
{
	q ##class(PHA.OP.COM.Method).GetPrescTitle(presc)
}

/// Descript:	获取门诊药房配药打印方式,1-配药单,2/其他-处方
/// Creator:    yunhaibao
/// CreateDate: 2018-03-08
/// w ##class(web.DHCOutPhCommon).GetPYPrintProp("",100,"")
ClassMethod GetPYPrintProp(GroupId As %String = "", LocId As %String, UserId As %String = "") As %Library.String
{
 
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCOutPhCommon).%GetParameter("AppName")
    s PYPrintType=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"PYPrintType",Param) 
    q PYPrintType
}

/// Descript:	处方费别
/// Creator:    yunhaibao
/// CreateDate: 2017-03-23
/// w ##class(web.DHCOutPhCommon).GetPrescFeeType("O17032000002")
ClassMethod GetPrescFeeType(prescno)
{
   s ord=$o(^OEORD(0,"PrescNo",prescno,"")) 
   s itm=$o(^OEORD(0,"PrescNo",prescno,ord,"") ) 
   s preason=$p(^OEORD(ord,"I",itm,11),"^",18)
   q:+preason=0 ""
   q $p($g(^PAC("ADMREA",preason)),"^",2)
}

/// Description:获取处方属于草药\西药
/// Creator:	yunhaibao
/// CreatDate:	2017-07-28
/// Return:		明细同一种则属于一类,否则为空
/// GZ(中成),GC(草药),GX(西药)
/// w ##class(web.DHCOutPhCommon).GetPrescSCGSet("O170706000001")
ClassMethod GetPrescSCGSet(prescNo)
{
	s ordId="",ordItmId="",retVal="",tmpVal=""
	s ordId=$o(^OEORD(0,"PrescNo",prescNo,""))
	q:ordId="" ""
	s ordItmId=""
	f  s ordItmId=$o(^OEORD(0,"PrescNo",prescNo,ordId,ordItmId)) q:ordItmId=""  d
    .s arcItmId=$p(^OEORD(ordId,"I",ordItmId,1),"^",2)
    .q:+arcItmId=""
    .s arcCatId=$p($g(^ARCIM(+arcItmId,$p(arcItmId,"||",2),1)),"^",10)
    .q:+arcCatId=0
    .s arcCatType=$p($g(^ARC("IC",+arcCatId)),"^",7)
    .q:arcCatType'="R"
    .s incId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
    .q:incId=""
    .s incscDr=$p(^INCI(incId,2),"^",2)
    .q:+incscDr=0
    .s scgDr=$o(^DHCSCG("STKCAT",incscDr,""))
	.q:+scgDr=0
	.s scgSet=$p(^DHCSCG(scgDr),"^",5)
	.i scgSet="" s scgSet="Mix"
	.i tmpVal="" s retVal=scgSet
	.e  i (tmpVal'=scgSet) s retVal=""
	.s tmpVal=scgSet
	i retVal="Mix" s retVal=""
	Q retVal
}

/// creator:	yunhaibao
/// createdate: 2018-05-10
/// description:获取门诊处方审核合理用药厂商和再次审核时需要先取消
/// w ##class(web.DHCOutPhCommon).GetPassProp("",100,"")
ClassMethod GetPassProp(GroupId As %String = "", LocId As %String, UserId As %String = "") As %Library.String
{
   
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCOutPhCommon).%GetParameter("AppName")
    s Pass=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"PASS",Param) 
    s RePassNeedCancle=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RePassNeedCancle",Param) 
    q Pass_"^"_RePassNeedCancle
}

/// creator: 	yunhaibao 
/// createdate: 2017-09-12
/// description:根据发药孙表获取已退数量
/// w ##class(web.DHCOutPhCommon).GetRetedQtyByPhdLb("16||1||1")
ClassMethod GetRetedQtyByPhdLb(phdLbRowId As %String)
{
	s retedQty=0
	q:phdLbRowId="" retedQty
	s phdId=+phdLbRowId
	s phdSubId=+$p(phdLbRowId,"||",2)
	s phdLbId=+$p(phdLbRowId,"||",3)
	q:(phdId=0)||(phdSubId=0)||(phdLbId=0) retedQty
	s phrId=""
	f  s phrId=$o(^DHCPHRTIi("PHDICDR",phdLbRowId,phrId)) q:phrId=""  d
	.q:+phrId=0
	.s phrItmId=""
	.f  s phrItmId=$o(^DHCPHRTIi("PHDICDR",phdLbRowId,phrId,phrItmId)) q:phrItmId=""  d
	..q:+phrItmId=0
	..s phrItmData=^DHCPHRTI(phrId,"RTI",phrItmId)
	..s phrPhdLbRowId=$p(phrItmData,"^",11)
	..q:phrPhdLbRowId'=phdLbRowId
	..s phrQty=$p(phrItmData,"^",3)
	..s retedQty=retedQty+phrQty
	q retedQty
}

/// Descript:	根据门诊发药孙表取已申请未退的数量
/// Creater:	hulihua
/// CreateDate:	2018-08-15
/// Input:		门诊发药孙表ID
/// Return：	数量
/// w ##class(web.DHCOutPhCommon).GetHasReqQty(29||1||1)
ClassMethod GetHasReqQty(phdsubid)
{
	s inci=+$p(^DHCPHDI(+phdsubid,"PHDI",$p(phdsubid,"||",2),"INCLB",$p(phdsubid,"||",3)),"^",3)
	q:inci="" 0
  	s phuomid=+$p(^INCI(inci,1),"^",12)
	s basuom=+$p(^INCI(inci,1),"^",10)
	s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(phuomid,basuom)
	s req="",sumqty=0
	f  s req=$o(^DHCPHREQi("PHDSUB",phdsubid,req)) q:req=""  d
	.s zfflag=$p(^DHCPHREQ(req),"^",1)
	.q:zfflag="1"
	.s retflag=$p(^DHCPHREQ(req),"^",11)
	.q:(retflag'="0")&(retflag'="")
	.s newprt=+$p(^DHCPHREQ(req),"^",5)
  	.q:newprt=0
  	.s prtflag=$p($g(^DHCINVPRT(newprt)),"^",8)
  	.q:(($g(prtflag)="A")!($g(prtflag)="S"))
	.s reqi=0
	.f  s reqi=$o(^DHCPHREQi("PHDSUB",phdsubid,req,reqi))  q:reqi=""  d
	..s reqty=$p(^DHCPHREQ(req,"I",reqi),"^",4)
	..s retQty=$p(^DHCPHREQ(req,"I",reqi),"^",5)
	..s reqty=confac*(reqty-retQty)
	..s sumqty=sumqty+reqty
	.
	q sumqty
}

/// Description:取草药处方的代煎费用
/// Creator:	hulihua
/// CreateDate:	2018-09-06
/// Table:      OE_OrdItem
/// Input:		prescno-处方号,Flag-是否检查煎药费已收（1-检查只收费的，2-检查申请状态）
/// Output:	    
/// Return：	空-无煎药费，非空-煎药费    
/// Others:     
/// Debug:		w ##class(web.DHCOutPhCommon).GetDecoctFee("O181227000005")
ClassMethod GetDecoctFee(PrescNo As %String, Flag As %String = "") As %String
{
	q:PrescNo="" ""
	s ord=$o(^OEORD(0,"PrescNo",PrescNo,""))
	q:ord="" ""
	q:'$d(^OEORDi(0,"OEORI",ord)) ""
	s chl=$o(^OEORD(0,"PrescNo",PrescNo,ord,""))
	q:chl="" "" 
	s Moeori=..GetMainOeori(ord_"||"_chl)
	q:Moeori="" ""
	s JyArcimStr=..GetPreFeeArcimStr(PrescNo)
	q:JyArcimStr="" ""
	s ifPharReqFlag=""
	s cookFeeStr="",arcimdr="",sub="" 
	f  s sub=$o(^OEORDi(0,"OEORI",ord,Moeori,sub),-1) q:(sub="")||(ifPharReqFlag'="")  d
	.s arcimdr=$p(^OEORD(ord,"I",sub,1),"^",2)
	.q:arcimdr=""
	.q:##class(web.DHCST.Common.UtilCommon).FindInList(JyArcimStr,arcimdr,",")=0
	.s oeoriStatCode=$p(##class(web.DHCSTPIVA).GetOeState(ord_"||"_sub),"^",1)
	.q:(oeoriStatCode'="V")&&(oeoriStatCode'="E") // 已停的不算
	.s OeoriBill=$p($g(^OEORD(ord,"I",sub,3)),"^",5)
	.q:(Flag="1")&&(OeoriBill'="P")
	.q:(Flag="2")&&(OeoriBill="P")
	.s arcsub=$p(arcimdr,"||",2)
	.s arcdesc=$p($g(^ARCIM(+arcimdr,arcsub,1)),"^",2)
	.i Flag="1" d
	..s ArpblItemDr=$p(^OEORD(ord,"I",sub,1),"^",16)
	..q:(ArpblItemDr="")||('$d(^DHCPB(+ArpblItemDr,"O",$p(ArpblItemDr,"||",2)))) 
	..s amount=+$p(^DHCPB(+ArpblItemDr,"O",$p(ArpblItemDr,"||",2)),"^",8)
	..s:(amount<1)&&($p(amount,".",1)="") amount=0_amount 
	..s cookFee=arcdesc_":"_amount_"元" 
	..s cookFeeStr=$s(cookFeeStr="":cookFee,1:cookFeeStr_"<br/>"_cookFee)
	.e  d
	..s cookFeeStr="煎药已申请"
	..s ifPharReqFlag=1
	.
	q cookFeeStr
}

/// Description:根据处方号获取草药处方的代煎费医嘱项ID以及附加费医嘱项ID串
/// Creator:	hulihua
/// CreateDate:	2018-12-26
/// Table:      PA_Que1
/// Input:		prescno-处方号
/// Output:	    
/// Return：	医嘱项ID串  
/// Others:     
/// Debug:		w ##class(web.DHCOutPhCommon).GetPreFeeArcimStr("O18090300102")
/// Modefied: 	psc 医生站修改了取煎药费的方式
ClassMethod GetPreFeeArcimStr(PrescNo As %String) As %String
{
	q:PrescNo="" ""
	S queId=$o(^PAQUE1(0,"PrescNo",PrescNo,""),-1)
	Q:queId="" ""
	Q:'$d(^PAQUE1(queId,"DHC")) ""
	S prescTypeCode=$P(^PAQUE1(queId,"DHC"),"^",15)
	q:prescTypeCode="" ""
	s PrescTypeChargeChargeStr=""
	s subrowid=""
    for {
	    s subrowid=$O(^DHCDocConfig("CookMode",prescTypeCode,"Arc",subrowid))
	    q:subrowid=""
	    s RowID=subrowid
	    s ArcimID=$P(^DHCDocConfig("CookMode",prescTypeCode,"Arc",subrowid),"^",1)
	    ;s Number=$P(^DHCDocConfig("CookMode",prescTypeCode,"Arc",subrowid),"^",2)
	    s OrderItem=ArcimID	//_"^"_Number
		i PrescTypeChargeChargeStr="" s PrescTypeChargeChargeStr=OrderItem
		e  s PrescTypeChargeChargeStr=PrescTypeChargeChargeStr_","_OrderItem
	   }
	q PrescTypeChargeChargeStr
	/*
	Q:PrescNo="" ""
	S queId=$o(^PAQUE1(0,"PrescNo",PrescNo,""),-1)
	Q:queId="" ""
	Q:'$d(^PAQUE1(queId,"DHC")) ""
	S prescTypeCode=$P(^PAQUE1(queId,"DHC"),"^",26)
	Q:prescTypeCode="" ""
	//代煎费医嘱项ID
	S presCookFeeItem=$G(^DHCDocConfig(prescTypeCode,"CNMedCookModeFeeItem"))
	//附加费医嘱项ID
	S presAppendItem=$G(^DHCDocConfig(prescTypeCode,"CNMedAppendItem"))
	Q:(presCookFeeItem="")&&(presAppendItem="") ""
	S PreFeeArcimStr=presCookFeeItem_","_presAppendItem
	Q PreFeeArcimStr
	*/
}

/// Creator		zzd
/// CreatDate	2018-03-26
/// Description	根据医嘱id获取对应的收费记录
/// Input		医嘱id
/// Output		
/// w ##class(web.DHCOutPhCommon).GetBasePriceByOe("1086||4","10821||1")
ClassMethod GetBasePriceByOe(Oeori, DspBat = "")
{
	s (retprice,money,paidFlag)=0
	q:Oeori="" retprice_"^"_money_"^"_paidFlag
	s Flag=0
	s PbRowid=""
	f  s PbRowid=$o(^DHCPBi(0,"OEORI",Oeori,PbRowid),-1) q:(PbRowid="")||(Flag=1)  d
	.s Pbo=""   
	.f  s Pbo=$o(^DHCPBi(0,"OEORI",Oeori,PbRowid,Pbo),-1) q:(Pbo="")||(Flag=1)  d
	..s basprice=0
	..q:'$d(^DHCPB(PbRowid,"O",Pbo))
	..s pbd=""
	..i DspBat'="" d
	...s pbd=$o(^DHCPB(0,"DSPBDR",DspBat,PbRowid,Pbo,pbd))  
	...q:pbd=""  
	...s basprice=$p(^DHCPB(PbRowid,"O",Pbo,"D",pbd),"^",4)
	...q:+$p(^DHCPB(PbRowid,"O",Pbo,"D",pbd),"^",7)<0
  	...s money=+$p(^DHCPB(PbRowid,"O",Pbo,"D",pbd),"^",7)
  	...s retprice=basprice
	...s paidFlag=1
	...s Flag=1
	..i pbd=""  d
	...s basprice=$p(^DHCPB(PbRowid,"O",Pbo),"^",7)
	...q:+$p(^DHCPB(PbRowid,"O",Pbo),"^",8)<0
	...s money=+$p(^DHCPB(PbRowid,"O",Pbo),"^",8)
	...s retprice=basprice
	...s paidFlag=1
	...s Flag=1
	q retprice_"^"_money_"^"_paidFlag
}

/// 
/// Creator		zzd
/// CreatDate	2018-03-26
/// Description	根据处方取发票中处方总金额
/// Input		门诊科室id(dhc_phloc),处方号
/// OutPut		处方金额
/// Other		w ##class(web.DHCOutPhCommon).GetPriceByPrescNo(28,"O180327000211")
ClassMethod GetPriceByPrescNo(Phl, PrescNo) As %String
{
	s Sunmoney=0
	s RecLocdr=$p(^DHCPHLOC(Phl),"^",1)
	s Ord=$o(^OEORD(0,"PrescNo",PrescNo,""))
	q:Ord="" ""
	s Itm=""
	f  s Itm=$o(^OEORD(0,"PrescNo",PrescNo,Ord,Itm)) q:Itm=""  d
	.s Arc=$p(^OEORD(Ord,"I",Itm,1),"^",2)
	.s ArcCatId=$p($g(^ARCIM(+Arc,$p(Arc,"||",2),1)),"^",10)
    .q:+ArcCatId=0
    .s ArcCatType=$p($g(^ARC("IC",+ArcCatId)),"^",7)
    .q:ArcCatType'="R"
    .s DispLoc=+$p(^OEORD(Ord,"I",Itm,3),"^",6)
	.q:DispLoc=0
	.q:RecLocdr'=DispLoc 
    .s BillFlag=$p(^OEORD(Ord,"I",Itm,3),"^",5) 
    .q:BillFlag'="P"
    .s OrdItm=Ord_"||"_Itm
	.s RetStr=..GetBasePriceByOe(OrdItm)
	.s Money=$p(RetStr,"^",2)
	.s Sunmoney=Sunmoney+Money
	q Sunmoney
}

/// Creator		zzd
/// CreatDate	2018.5.14
/// Description	根据医嘱id获取最后的发票id
/// Input		医嘱id,是否估计发票是否有效标志
/// OutPut		DHC_InvPrt表id
/// EXec		w ##class(web.DHCOutPhCommon).GetLastInvByOE("8||3")
/// 
ClassMethod GetLastInvByOE(OrdItm, dispflag = "")
{
	q:OrdItm="" invprt
	s prt=""
	s Flag=0

	s PbRowid=""
	f  s PbRowid=$o(^DHCPBi(0,"OEORI",OrdItm,PbRowid),-1) q:(PbRowid="")||(Flag=1)  d
	.s pbci=$o(^DHCBCI(0,"Bill",PbRowid,""),-1)
	.q:pbci=""
	.s invprt=$p(^DHCBCI(pbci),"^")
	.q:'$d(^DHCINVPRT(invprt))
	.s invflag=$p(^DHCINVPRT(invprt),"^",8)
	.q:(invflag'="N")&&(dispflag="")
	.s prt=invprt
	.s Flag=1
	.
	q prt
}

/// 处方的缴费时间
/// w ##class(web.DHCOutPhCommon).GetHandTime("O180112000001")
ClassMethod GetHandTime(prescno)
{
	q:prescno="" "0^^^"
	s handdate=""
	s handtime=""
	i $d(^DHCPHARi("PRESCNO",prescno)) d
	.s phar=$o(^DHCPHARi("PRESCNO",prescno,""),-1)
	.s handdate=$p(^DHCPHARW(phar),"^",2)
	.s handtime=$p(^DHCPHARW(phar),"^",5)
	
	s fyflag=""
	i $d(^DHCPHDISPi("PRESCNO",prescno)) d
	.s phd=$o(^DHCPHDISPi("PRESCNO",prescno,""),-1) 
	.s fyflag=$p(^DHCPHDISP(phd),"^",4)
	
	// 如果phd不为空   这是已发药，为空就是未发，那就需要判断处方缴费状态
	s handflag=0,prtstr="",prtcodestr=""
	s ord=""
	s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  
	
	q:(ord="") "0^^^"
	s patadm=$p(^OEORD(ord),"^",1)
	s itm=""
	f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:(itm="")||(handflag'=0)  d
	.s billed=$p(^OEORD(ord,"I",itm,3),"^",5)
	.q:billed'="P"
	.s handflag=1
	.s orditm=ord_"||"_itm
	.s prt=##class(web.DHCOutPhCommon).GetLastInvByOE(orditm)
	.q:prt=""
	.i prtstr="" s prtstr=prt
	.e  s prtstr=prtstr_","_prt
	.s prtcode=$p(^DHCINVPRT(prt),"^",14)
	.i prtcode=""  d
	..s API=$p(^DHCINVPRT(prt),"^",4)
	..q:API="" 
	..s prtcode=$p(^DHCINVPRTAP(API),"^",6)
	.i prtcode'="" d
	..i prtcodestr="" s prtcodestr=prtcode
	..e  s prtcodestr=prtcodestr_","_prtcode
	
	i fyflag="1" s handflag=1
	i handflag'=0  d
	.i handdate'="" s handdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(handdate)
	.i handtime'="" s handtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(handtime)
	e  d
	.s handtime=""
	.s handdate=""
	q handflag_"^"_handdate_"^"_handtime_"^"_prtstr_"^"_prtcodestr
}

/// Creator		zzd
/// CreatDate	2018.10.14
/// Description	根据处方号取是否需要审核
/// Input：		门诊药房id(dhc_phloc)
/// Output:		0 不需 1 需要
ClassMethod GetNeedOrdAuditFlag(phl) As %String
{
	q:phl="" 0
	s auditflag=$p($g(^DHCPHLOC(phl)),"^",7)
	q:auditflag="Y" 1
	q 0
}

/// w ##class(web.DHCOutPhCommon).GetDspBatPrice("23||3","28||1")
ClassMethod GetDspBatPrice(orditm, dspbat)
{
	s retprice=0
  	s money=0
  	s paidFlag=0	
  	q:orditm="" retprice_"^"_money_"^"_paidFlag
  	s PbRowid=0
	f  s PbRowid=$o(^DHCPBi(0,"OEORI",orditm,PbRowid),-1) q:(PbRowid="")||(Flag=1)  d
	.s Pbo=""   
	.f  s Pbo=$o(^DHCPBi(0,"OEORI",orditm,PbRowid,Pbo),-1) q:(Pbo="")||(Flag=1)  d
	..s basprice=0
	..q:'$d(^DHCPB(PbRowid,"O",Pbo))
	..s pbd=""
	..i dspbat'="" d
	...s pbd=$o(^DHCPB(0,"DSPBDR",dspbat,PbRowid,Pbo,pbd))
	...q:pbd=""  
	...s basprice=$p(^DHCPB(PbRowid,"O",Pbo,"D",pbd),"^",4)
  	...s money=+$p(^DHCPB(PbRowid,"O",Pbo,"D",pbd),"^",7)
  	...s retprice=basprice
	...s paidFlag=1
	...s Flag=1
	..i pbd=""  d
	...s basprice=$p(^DHCPB(PbRowid,"O",Pbo),"^",7)
	...s money=+$p(^DHCPB(PbRowid,"O",Pbo),"^",8)
	...s retprice=basprice
	...s paidFlag=1
	...s Flag=1
	q retprice_"^"_money_"^"_paidFlag
}

/// Creator		zzd
/// Creatdate	2018-10-25
/// Description	根据医嘱id获取价格
/// Input		医嘱id,打包表子表id
/// Output		金额
/// Other		w ##class(web.DHCOutPhCommon).GetOrdItmMoney("667||1","5133||1")
ClassMethod GetOrdItmMoney(OrdItm, DspBat = "")
{
	q:OrdItm="" 0
	s ord=+OrdItm
	s itm=$p(OrdItm,"||",2)
	s recloc=$p(^OEORD(ord,"I",itm,3),"^",6)
	s hospdr=$P(^CTLOC(recloc),"^",22)
	s BillFlag=$p(^OEORD(ord,"I",itm,3),"^",5)
	s ordprice=0
	s amt=0
	s dsp=$o(^DHCOEDISQTY(0,"OEORI",OrdItm,""))
	q:dsp="" ordprice_"^"_amt
	s admId=$p(^OEORD(ord),"^",1)
	s admType=$p(^PAADM(admId),"^",2)
	s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
	i dspdate="" s dspdate=+$h
	i $d(^DHCOEDISQTY(dsp,"I")) d
	.i DspBat=""  d
	..s dspSub=0
	..f  s dspSub=$o(^DHCOEDISQTY(dsp,"I",dspSub)) q:dspSub=""  d
	...s dspInci=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",5) 
	...s dspInclb=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",1) 
	...s Buom=$p(^INCI(dspInci,1),"^",10)
	...s qty=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",2)
	...i dspInclb="" s dspInclb=dspInci
	...s dspbatid=dsp_"||"_dspSub
	...i (BillFlag="P")&&(admType'="H") d
	....s RetStr=##class(web.DHCOutPhCommon).GetBasePriceByOe(OrdItm,dspbatid)
	....s ordprice=$p(RetStr,"^",1)
	....s Money=$p(RetStr,"^",2)
	...e  d
	....s ordprice=##class(web.DHCSTPRICE).GetSp(dspInclb,+dspdate,Buom,hospdr,"","")	//批次价调价后发药按调价后价格
	....s Money=qty*ordprice
	...s amt=amt+Money
	.e  d
	..i (BillFlag="P")&&(admType'="H") d  
	...s RetStr=##class(web.DHCOutPhCommon).GetBasePriceByOe(OrdItm,DspBat)
	...s ordprice=$p(RetStr,"^",1)
	...s Money=$p(RetStr,"^",2)
	...s amt=amt+Money
	..e  d
	...s dspInci=$p(^DHCOEDISQTY(+DspBat,"I",$p(DspBat,"||",2)),"^",5) 
	...s dspInclb=$p(^DHCOEDISQTY(+DspBat,"I",$p(DspBat,"||",2)),"^",1) 
	...i dspInclb="" s dspInclb=dspInci
	...s Buom=$p(^INCI(dspInci,1),"^",10)
	...s qty=$p(^DHCOEDISQTY(+DspBat,"I",$p(DspBat,"||",2)),"^",2)
	...s ordprice=##class(web.DHCSTPRICE).GetSp(dspInclb,+dspdate,Buom,hospdr,"","")	//批次价调价后发药按调价后价格
	...s Money=qty*ordprice
	...s amt=amt+Money
	q ordprice_"^"_amt
}

/// Creator		zzd
/// Creatdate	2018-10-26
/// Description	根据医嘱项获取药学项单位
/// Input		医嘱项
/// Output		药学项单位
ClassMethod GetPhcDrgUom(arcitm)
{
	q:arcitm="" ""
	s phcdf=$p($g(^ARCIM(+arcitm,$p(arcitm,"||",2),1)),"^",12) 
	s (Uom,UomDesc)=""
  	i +phcdf'=0  d
  	.s Uom=$p($g(^PHCD(+phcdf,$p(phcdf,"||",2),2)),"^",4) 
  	.i Uom'="" s UomDesc=$p(^CT("UOM",Uom),"^",2)
  	q Uom_"^"_UomDesc
}

/// Creator		zzd
/// Creatdate	2018-10-26
/// Description	根据医嘱项获取库存项是否唯一
/// Input		医嘱项
/// Output		库存项唯一
/// todo： 这么取不好吧，yunhaibao
ClassMethod GetIncFlagByArc(arcitm)
{
	q:arcitm="" ""
	s num=0
	s inci=""
	f  s inci=$o(^INCI(0,"ARCIM_DR",+arcitm,inci)) q:(inci="")||(num>1)  d
	.q:+inci=0
	.s num=num+1
	q num
}

/// description: 急诊留观是否已结算出院
/// return:		 1(已出院结算)
/// ##class(web.DHCOutPhCommon).GetAdmStatus(admId)
ClassMethod GetAdmStatus(AdmId)
{
	q:AdmId="" ""
	q:'$d(^PAADM(AdmId)) ""
	q:$p($g(^PAADM(AdmId)),"^",20)="D" 1
	q 0
}

/// description: 获取处方金额(处方金额,非发药单,不含退药)
/// input:		 PrescNo(处方号)
/// reutrn:		 售价金额^进价金额
/// w ##class(web.DHCOutPhCommon).GetPrescAmt("O181126000004")
ClassMethod GetPrescAmt(PrescNo)
{
	s spAmtTotal=0
	s (hospId,admType)=""
	s ordId=0
	f  s ordId=$o(^OEORD(0,"PrescNo",PrescNo,ordId)) q:ordId=""  d
	.s admId=$p(^OEORD(ordId),"^",1)
	.s admType=$p(^PAADM(admId),"^",2)
	.s ordItm=0
	.f  s ordItm=$o(^OEORD(0,"PrescNo",PrescNo,ordId,ordItm)) q:ordItm=""  d
	..s oeori=ordId_"||"_ordItm
	..s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	..q:dspId=""
	..s dispStatus=$p(^DHCOEDISQTY(dspId),"^",7)
	..s arcItmId=$p(^OEORD(ordId,"I",ordItm,1),"^",2)
	..s arcCatId=$p($g(^ARCIM(+arcItmId,$p(arcItmId,"||",2),1)),"^",10)
    ..q:+arcCatId=0
    ..s arcCatType=$p($g(^ARC("IC",+arcCatId)),"^",7)
    ..// 过滤-非药品
    ..q:arcCatType'="R"
	..s billFlag=$p(^OEORD(ordId,"I",ordItm,3),"^",5) 
	..// 过滤-自备
	..q:##class(web.DHCSTCOMMONORDER).OeoriPriority(oeori)["OM"
	..// 过滤-未交费已停
	..s oeStatCode=$p(^OEC("OSTAT",$p($g(^OEORD(ordId,"I",ordItm,1)),"^",13)),"^",1)
	..q:(dispStatus="TC")&&(billFlag'="P")&(oeStatCode'="V")&(oeStatCode'="E")   
    ..s recLocId=$p(^OEORD(ordId,"I",ordItm,3),"^",6)
    ..s hospId=$p(^CTLOC(recLocId),"^",22) 
	..s dspDate=$p(^DHCOEDISQTY(dspId),"^",8)
	..s paidFlag=##class(PHA.OP.COM.Method).ChkOeoriPayFlag(oeori)
	..i dspDate="" s dspDate=+$h
	..s dspId="" 
	..f  s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,dspId)) q:dspId=""  d
	...s dspStatus=$p(^DHCOEDISQTY(dspId),"^",7)
	...q:dspStatus="R"
	...s dspSub=0
	...f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	....s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
	....s dspSubId=dspId_"||"_dspSub
	....s incId=$p(dspSubData,"^",5) 
	....s inclb=$p(dspSubData,"^",1) 
	....s qty=$p(dspSubData,"^",2)
	....i (paidFlag=1) d
	.....s spStr=##class(web.DHCOutPhCommon).GetBasePriceByOe(oeori,dspSubId)
	.....s spAmt=$p(spStr,"^",2)
	....e  d
	.....i inclb'="" s getSpInclb=inclb
	.....e  s getSpInclb=incId
	.....s sp=##class(web.DHCSTPRICE).GetSp(getSpInclb,+dspDate,"",hospId,"","")	//批次价调价后发药按调价后价格
	.....s spAmt=qty*sp
	.....s perv="^^^^"_hospId_"^DHC"
	.....s spAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(spAmt,perv,"FmtSA",1)
	....s spAmtTotal=spAmtTotal+spAmt
	q spAmtTotal
}

/// description: 获取处方已退药金额
/// w ##class(web.DHCOutPhCommon).GetPrescRetAmt("O181206000024")
ClassMethod GetPrescRetAmt(PrescNo)
{
	q:PrescNo="" ""
	s spAmtTotal=0
	s ordId=0
	f  s ordId=$o(^OEORD(0,"PrescNo",PrescNo,ordId)) q:ordId=""  d
	.s admId=$p(^OEORD(ordId),"^",1)
	.s admType=$p(^PAADM(admId),"^",2)
	.s ordItm=0
	.f  s ordItm=$o(^OEORD(0,"PrescNo",PrescNo,ordId,ordItm)) q:ordItm=""  d
	..s oeori=ordId_"||"_ordItm
	..s recLocId=$p($g(^OEORD(ordId,"I",ordItm,3)),"^",6)
	..q:recLocId=""
	..s hospId=$p(^CTLOC(recLocId),"^",22)
	..s perv="^^^^"_hospId_"^DHC"
	..s dspId=""
	..f  s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,dspId),-1) q:dspId=""  d
	...s dspData=^DHCOEDISQTY(dspId)
	...s dspStatus=$p(^DHCOEDISQTY(dspId),"^",7)
	...q:dspStatus'="R"
	...s dspSub=0
	...f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	....s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
	....s qty=$p(dspSubData,"^",2)
	....s sp=$p(dspSubData,"^",4)
	....s spAmt=qty*sp
	....s spAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(spAmt,perv,"FmtSA",1)
	....s spAmtTotal=spAmtTotal+spAmt
	q spAmtTotal
}

}
