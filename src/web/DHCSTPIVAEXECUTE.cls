Import SQLUser

/// Description:配液状态执行：分签,贴签,排药,核对,配置,成品核查,打包,病区接收,也供PDA使用
/// Creator: Liang Qiang
/// CreatDate:2010-05-06
Class web.DHCSTPIVAEXECUTE Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:配液状态执行
/// Creator: Liang Qiang
/// CreatDate:2010-05-06  
/// Modified:2011-04-30 
/// Input:条码,执行代码,用户ID
/// Output:number
/// others:因pda也用此类,可能获取不到sesssion,故参数全部前台传进
ClassMethod SaveCheckOK(barcode As %String, cnumber As %String, puser As %String, logonctloc As %String = "") As %String
{
 	N (barcode,cnumber,puser,logonctloc)
	Q:$l(barcode,"-")'=4 -1_"^标签错误"
	Q:barcode="" -2_"^标签错误"
	Q:cnumber="" -3_"^标签错误"
	Q:puser="" -4_"^标签错误"
	s logonhospid=$s(logonctloc'="":$p($g(^CTLOC(logonctloc)),"^",22),1:"")
	//s locid=%session.Data("LOGON.CTLOCID")
	s pstype="I"
	//S PID=..NewPid()
	S ord=$p(barcode,"-",1)
	S itm=$p(barcode,"-",2)
	s exe=$p(barcode,"-",3)
	S grpno=$p(barcode,"-",4)
	S orditm=ord_"||"_itm
	s ordexe=ord_"||"_itm_"||"_exe
	S Msg=""
	//S moeori=##class(web.DHCSTPIVA).GetMainOeori(orditm)
	//S pog=##class(web.DHCSTPIVAPRINTLABEL).GetOrdGrpID(moeori,grpno)
	s DspId=$o(^DHCOEDISQTY(0,"OEORE",ordexe,""))
	q:DspId="" -31_"^标签错误"
	S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
	q:mdodis="" -32_"^标签错误"
	s moeori=$p(^DHCOEDISQTY(mdodis),"^",1)
	s moeore=$p(^DHCOEDISQTY(mdodis),"^",3)
	s pog=$o(^PIVA(0,"OEGRP",mdodis,grpno,""))
	Q:pog="" -5_"^无此标签"
	Q:'$d(^PIVA(pog)) -6_"^无此标签"
	S phac=$P(^PIVA(pog),"^",10)
 	Q:phac="" -7_"^取标签信息错误"
 	//Q:cnumber="60" -100_"^暂不开放"
 	S psdr=$P(^PIVA(pog),"^",6) /// pog的当前状态
	S pcnumber=$P(^PIVAS(psdr),"^",1)
	S pcnumName=$P(^PIVAS(psdr),"^",2)
 	s locid=$P(^PIVA(pog),"^",7)
  	s HospID=$s(locid'="":$p($g(^CTLOC(locid)),"^",22),1:"")
  	q:(logonhospid'="")&&(HospID'="")&&(logonhospid'=HospID) -14_"^该标签所在院区不为本次登录的院区" ; yunhaibao20170122,按院区过滤
 	S warddr=$P(^DHCPHAC(phac),"^",4)
 	S ward=""
 	I warddr'="" D
	.S:$D(^PAWARD(warddr)) ward=$P(^PAWARD(warddr),"^",2)
	S batno=$P(^PIVA(pog),"^",3)
	S batno=batno_"批"
 	//S oestate=##class(web.DHCSTPIVA).GetOeState(moeori)
 	//S oestcode=$P(oestate,"^",1)
	S patstr=##class(web.DHCSTPIVA).GetOeInfoByMoeori(moeori)	/// 病人信息 bed_"^"_paname_"^"_ipno_"^"_age_"^"_sex
	S bed=$p(patstr,"^",1)
	S paname=$p(patstr,"^",2)
	S ipno=$p(patstr,"^",3)
	I $F(ward,"-") S ward=$P(ward,"-",2)
	S Msg=ward_"^"_batno_"^"_bed_"^"_ipno_"^"_paname_"^"_pcnumName_"^"_pog
	//S moedisp=$P(^PIVA(pog),"^",1)
	//S OrdExeRowid=$p(^DHCOEDISQTY(moedisp),"^",3)

	L +^PIVA(pog):30  E  Q -9_"^加锁失败"
	S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(moeore)
	//I (oestcode'="V")&(oestcode'="E") L -^PIVA(pog)
	//Q:(oestcode'="V")&(oestcode'="E") -8_"^医嘱已停"_"^"_Msg
	I ChkOrdState'=1 L -^PIVA(pog)
	q:ChkOrdState'=1 -8_"^执行记录已停"_"^"_Msg
	
	S quitflag=0
	S spestat=$P(^PIVA(pog),"^",8)
 	I spestat'="N" S quitflag=-9
 	I quitflag'=0 L -^PIVA(pog)
	Q:quitflag'=0 -9_"^已拒绝配液"_"^"_Msg
	S ps=##class(web.DHCSTPIVA).GetPivaStateId(locid,"I",cnumber)
 	I ps="" S quitflag=1
 	I quitflag'=0 L -^PIVA(pog)
 	Q:quitflag'=0 -10_"^状态配置错误"_"^"_Msg
	//S psdr=$P(^PIVA(pog),"^",6) /// pog的当前状态
	//S pcnumber=$P(^PIVAS(psdr),"^",1)
	//S pcnumName=$P(^PIVAS(psdr),"^",2)
	I pcnumber=cnumber S quitflag=2
	I quitflag'=0 L -^PIVA(pog)
	Q:quitflag'=0 -11_"^已执行过"_"^"_Msg
	I (pcnumber'<60)&(cnumber<60) S quitflag=3
	I quitflag'=0 L -^PIVA(pog)
	Q:quitflag'=0 -12_"^已计帐,不能执行"_"^"_Msg
	S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr,locid,pstype)
 	S nextnumber=$P(nextstr,"^",2)
 	I nextnumber'=cnumber S quitflag=4
 	I quitflag'=0 L -^PIVA(pog)
 	Q:quitflag'=0 -13_"^不能执行此状态,当前状态"_pcnumName_"^"_Msg
 	//K ^TMP("PIVA","PHACI",pog)	//华西库存接口保存发药子表ID
 	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
 	TSTART
 	S ret=##class(web.DHCSTPIVARECHECK).UpdPog(pog,ps,puser)	//1 处理 PIVA_OrdGrp系列表
 	I ret'=0 S quitflag=5
 	I quitflag'=0 D Rollback
 	Q:quitflag'=0 -14_"^更新配液状态失败"_"^"_Msg
 	///配置状态时处理库存
 	I cnumber=60 D
 	.S sub=0,err=0
 	.F  S sub=$O(^PIVA(pog,"I",sub)) Q:(sub="")!(sub=0)!(quitflag'=0)  D
 	..S dsp=$P(^PIVA(pog,"I",sub),"^",1)
 	..I dsp="" S quitflag=1
 	..Q:dsp=""
 	..I '$D(^DHCOEDISQTY(dsp)) S quitflag=2
 	..Q:'$D(^DHCOEDISQTY(dsp))
 	..s oeori=$P(^DHCOEDISQTY(dsp),"^",1)
 	..I oeori="" S quitflag=3
	..Q:oeori=""
	..S pri=##class(web.DHCSTPIVA).GetOePriority(oeori)
	..S pricode=$P(pri,"^",2)
	..S pricode=$ZCVT(pricode,"U")
	..//Q:(pricode="OM")!(pricode="OMST")
	..Q:##class(web.DHCSTCOMMONSRV).ChkOrdPriority(oeori)=0
	..//S oestate=##class(web.DHCSTPIVA).GetOeState(oeori)
	..//S oestcode=$P(oestate,"^",1)
	..//I (oestcode'="V")&(oestcode'="E") S quitflag=4
 	..//Q:(oestcode'="V")&(oestcode'="E")	/// 去掉停止的医嘱
 	..//S err=##class(web.DHCSTPIVARECHECK).Dispensing(phac,dsp,puser) //2 处理发药及库存系列表
 	..i RuleFlag=3 d
 	...S err=##class(web.DHCSTPCHCOLLS).DispensingByBatch(phac,dsp,oeori)
 	..e  d
 	...S err=##class(web.DHCSTPCHCOLLS).Dispensing(phac,dsp,oeori) //2 处理发药及库存系列表
 	..I err="" S quitflag=5
 	..I err>0 S quitflag=5
 	..I err=9 S quitflag=6
 	..I err=4 S quitflag=7
 	..I err=100 S quitflag=100
 	..I err=10  S quitflag=10
 	.//S ret=##class(web.DHCSTPIVARECHECK).InsOrder(pog,puser,PID)	/// 插入注射器医嘱
 	.I ret'=0  S quitflag=8
 	S incidesc=$G(^tmp("DHCSTPIVANOQTY"))
 	//S phaciStr=$G(^TMP("PIVA","PHACI",pog))
 	//K ^TMP("PIVA","PHACI",pog)
 	I quitflag'=0 D Rollback
 	Q:quitflag=1 -15_"^配液没有医嘱数据:"_pog_"||"_sub_"^"_Msg	
 	Q:quitflag=2 -16_"^医嘱数据不存在:"_dsp_"^"_Msg
 	Q:quitflag=3 -17_"^医嘱数据问题:"_dsp_"^"_Msg
 	Q:quitflag=4 -18_"^医嘱已经停止:"_oeori_"^"_Msg
	Q:quitflag=5 -19_"^发药失败"_"^"_Msg
	Q:quitflag=6 -20_"^库存不足:"_incidesc_"^"_Msg
	Q:quitflag=7 -21_"^库存处理失败"_"^"_Msg
	Q:quitflag=8 -24_"^插入收费医嘱失败"_pog_"^"_Msg
	Q:quitflag=100 -22_"^已记帐"_"^"_Msg
	Q:quitflag=10 -23_"^已出院"_"^"_Msg
	Q:quitflag'=0 -99_"^其它"_"^"_Msg
 	TCOMMIT
 	L -^PIVA(pog)
 	//S Ret=##Class(web.DHCSTPIVARECHECK).SendHX(phaciStr,moeori_"||"_grpno)
 	Q 0_"^执行成功"_"^"_Msg
 	
Rollback
 	TROLLBACK
 	L -^PIVA(pog)
 	Q
}

/// 暂不用,留作参考
ClassMethod SaveCheckOKOLD(barcode As %String, cnumber As %String, puser As %String) As %String
{
	N (barcode,cnumber,puser)
	Q:$l(barcode,"-")'=3 -1_"^标签错误"
	Q:barcode="" -2_"^标签错误"
	Q:cnumber="" -3_"^标签错误"
	Q:puser="" -4_"^标签错误"
	S ord=$p(barcode,"-",1)
	S itm=$p(barcode,"-",2)
	S grpno=$p(barcode,"-",3)
	S orditm=ord_"||"_itm
	S Msg=""
	s pog=$o(^PIVA(0,"OEGRP",orditm,grpno,""))
	Q:pog="" -5_"^无此标签"
	Q:'$d(^PIVA(pog)) -6_"^无此标签"
	S phac=$P(^PIVA(pog),"^",10)
 	Q:phac="" -7_"^取标签信息错误"
 	S warddr=$P(^DHCPHAC(phac),"^",4)
 	Q:cnumber="70" -100_"^暂不开放"
	TSTART
 	S ward=""
 	I warddr'="" D
	.S:$D(^PAWARD(warddr)) ward=$P(^PAWARD(warddr),"^",2)
	S batno=$P(^PIVA(pog),"^",3)
	S batno=batno_"批"
	S moeori=##class(web.DHCSTPIVA).GetMainOeori(orditm)
 	S oestate=##class(web.DHCSTPIVA).GetOeState(moeori)
 	S oestcode=$P(oestate,"^",1)
	S patstr=##class(web.DHCSTPIVA).GetOeInfoByMoeori(moeori)	/// 病人信息 bed_"^"_paname_"^"_ipno_"^"_age_"^"_sex
	S bed=$p(patstr,"^",1)
	S paname=$p(patstr,"^",2)
	S ipno=$p(patstr,"^",3)
	I $F(ward,"-") S ward=$P(ward,"-",2)
	S Msg=ward_"^"_batno_"^"_bed_"^"_ipno_"^"_paname
	Q:(oestcode'="V")&(oestcode'="E") -8_"^医嘱已停"
	L +^PIVAPDA("PDA",barcode):30  E  Q -9_"^加锁失败"
	S quitflag=0
	S ps=$O(^PIVAS(0,"NUMBER",cnumber,""))
 	I ps="" S quitflag=1
 	I quitflag'=0 L -^PIVAPDA("PDA",barcode)
 	Q:quitflag'=0 -10_"^状态配置错误"
	S psdr=$P(^PIVA(pog),"^",6) /// pog的当前状态
	S pcnumber=$P(^PIVAS(psdr),"^",1)
	I pcnumber=cnumber S quitflag=2
	I quitflag'=0 L -^PIVAPDA("PDA",barcode)
	Q:pcnumber=cnumber -11_"^已执行"
	I (pcnumber'<70)&(cnumber<70) S quitflag=3
	I quitflag'=0 L -^PIVAPDA("PDA",barcode)
	Q:quitflag'=0 -12_"^已计帐,不能执行"
	S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr)
 	S nextnumber=$P(nextstr,"^",2)
 	I nextnumber'=cnumber S quitflag=4
 	I quitflag'=0 L -^PIVAPDA("PDA",barcode)
 	Q:quitflag'=0 -13_"^不应该进行此状态"
 	S ret=..UpdPog(pog,ps,puser)	//1 处理 PIVA_OrdGrp系列表
 	I ret'=0 S quitflag=5
 	I quitflag'=0 TROLLBACK
 	I quitflag'=0 L -^PIVAPDA("PDA",barcode)
 	Q:quitflag'=0 -14_"^执行失败"
 	L -^PIVAPDA("PDA",barcode)
 	I quitflag'=0 TROLLBACK
 	TCOMMIT
 	Q 0_"^执行成功"
}

/// 暂不用,留作参考
ClassMethod UpdPog(pog As %String, ps As %String, puser As %String) As %String
{
	N (pog,ps,puser)
	K PLIST
	&SQL(Select * Into :PLIST() From PIVA_OrdGrp Where pog_rowid=:pog)
	S PLIST(7)=ps
	&SQL(Update PIVA_OrdGrp Values :PLIST() Where pog_rowid=:pog)
	Q:SQLCODE -1
	S ret=..InsOrdGrpState(pog,puser,ps)
	Q ret
}

/// 暂不用,留作参考
ClassMethod InsOrdGrpState(parref As %String, user As %String, ps As %String) As %String
{
	N (parref,user,ps)
	Q:parref="" -1
	Q:user="" -2
	Q:ps="" -3
	K PLIST
	S PLIST(0)=parref
	S PLIST(2)=$O(^PIVA(parref,"S",""),-1)+1
	S PLIST(3)=ps
	S PLIST(4)=user
	S PLIST(5)=+$H
	S PLIST(6)=$P($H,",",2)
	&SQL(Insert Into PIVA_OrdGrpState Values :PLIST())
	Q SQLCODE
}

/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAEXECUTE","GetItemsByBar","18-1-2-1")
ClassMethod GetItemsByBarExecute(ByRef qHandle As %Binary, tBarcode) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//2-217-1
	Q:tBarcode="" $$$OK
	Q:$l(tBarcode,"-")'=4 $$$OK
    S ord=$p(tBarcode,"-",1)
	S itm=$p(tBarcode,"-",2)
	s exe=$p(tBarcode,"-",3)
	S grpno=$p(tBarcode,"-",4)
	q:grpno="" $$$OK
	S orditm=ord_"||"_itm
	s ordexe=ord_"||"_itm_"||"_exe
	s DspId=$o(^DHCOEDISQTY(0,"OEORE",ordexe,""))
	q:DspId="" $$$OK
	S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
	q:mdodis="" $$$OK
	s mmoeori=$p(^DHCOEDISQTY(mdodis),"^",1)
	s moeore=$p(^DHCOEDISQTY(mdodis),"^",3)
	s pog=$o(^PIVA(0,"OEGRP",mdodis,grpno,""))
	Q:pog="" $$$OK
	Q:'$d(^PIVA(pog)) $$$OK
	S phac=$P(^PIVA(pog),"^",10)
	S moeori=$P(^PIVA(pog),"^",1)
	S pno=""
	S ward=""
	I $D(^DHCPHAC(phac)) D
	.S prtno=$P(^DHCPHAC(phac),"^",14)	/// 打印单号
	.S ward=$P(^DHCPHAC(phac),"^",4)	/// 病区
	.I ward'="" D
	..S:$D(^PAWARD(ward)) ward=$P(^PAWARD(ward),"^",2)
	S instruc=##class(web.DHCSTPIVA).GetInstruc(mmoeori)	/// 用法
	S patstr=##class(web.DHCSTPIVA).GetOeInfoByMoeori(mmoeori)	/// 病人信息 bed_"^"_paname_"^"_ipno_"^"_age_"^"_sex
	S doctor=##class(web.DHCSTPIVA).GetDoctor(mmoeori)	/// 医生
	S batno=$P(^PIVA(pog),"^",3)
	S odate=$P(^PIVA(pog),"^",4)
	S:odate'="" odate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(odate,"PIVA")
	S otime=$P(^PIVA(pog),"^",5)
	S:otime'="" otime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(otime,"PIVA")
	S dt=odate_" "_otime
	S bed=$p(patstr,"^",1)
	S patname=$p(patstr,"^",2)
	S patno=$p(patstr,"^",3)
	s paadm=$p(^OEORD(+ord),"^",1)
	S papmi=$p(^PAADM(paadm),"^",1)
	s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
	s EncryptLevel="",PatLevel=""
	i EncryptFlag=1 d
	.s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,"")
    .s EncryptLevel=$p(EncryptLevelInfo,"^",1)
	.s PatLevel=$p(EncryptLevelInfo,"^",2)
	S freq=##class(web.DHCSTPIVA).GetFreq(mmoeori)	/// 频率
	S freq=$P(freq,"^",2)
	S pogsub=""
	F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	.S dsp=$P(^PIVA(pog,"I",pogsub),"^",1)
	.Q:'$D(^DHCOEDISQTY(dsp))
	.S oeori=$P(^DHCOEDISQTY(dsp),"^",1) Q:oeori=""
	.S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	.S inci=$P(incitm,"^",1)
 	.S incidesc=$P(incitm,"^",3)
	.S spec=##class(web.DHCSTCOMINC).GetSpec(inci)
	.S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)
	.S dosageml=##class(web.DHCSTPIVA).GetDosageML(oeori)
	.i dosageml'="" s dosage=dosageml
	.i $f(ward,"-") s ward=$p(ward,"-",2)
	.d OutPutRow

	Quit $$$OK
	
OutPutRow
	set Data=$lb(incidesc,dosage,instruc,freq,EncryptLevel,PatLevel)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
}

ClassMethod GetItemsByBarFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemsByBarExecute ]
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

Query GetItemsByBar(tBarcode) As %Query(ROWSPEC = "tbDesc:%String,tbDosage:%String,tbInst:%String,tbFreq:%String,TEncryptLevel:%String,TPatLevel:%String")
{
}

ClassMethod GetItemsByBarClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemsByBarExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCSTPIVAEXECUTE).GetRecordByBar("18-1-2-1")
ClassMethod GetRecordByBar(barcode As %String) As %String
{
	N (barcode)
	Q:barcode="" ""
	Q:$l(barcode,"-")'=4 ""
	S ord=$p(barcode,"-",1)
	S itm=$p(barcode,"-",2)
	s exe=$p(barcode,"-",3)
	S grpno=$p(barcode,"-",4)
	q:grpno="" ""
	S orditm=ord_"||"_itm
	S orditm=ord_"||"_itm
	s ordexe=ord_"||"_itm_"||"_exe
	s DspId=$o(^DHCOEDISQTY(0,"OEORE",ordexe,""))
	q:DspId="" ""
	S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
	q:mdodis="" ""
	s mmoeori=$p(^DHCOEDISQTY(mdodis),"^",1)
	s moeore=$p(^DHCOEDISQTY(mdodis),"^",3)
	s pog=$o(^PIVA(0,"OEGRP",mdodis,grpno,""))
	Q:pog="" ""
	Q:'$d(^PIVA(pog)) ""
	S phac=$P(^PIVA(pog),"^",10)
	S moeori=$P(^PIVA(pog),"^",1)
	S pno=""
	S ward=""
	I $D(^DHCPHAC(phac)) D
	.S prtno=$P(^DHCPHAC(phac),"^",14)	/// 打印单号
	.S printdate=$P(^DHCPHAC(phac),"^",7)
	.s printtime=$P(^DHCPHAC(phac),"^",8)
	.S ward=$P(^DHCPHAC(phac),"^",4)	/// 病区
	.I ward'="" D
	..S:$D(^PAWARD(ward)) ward=$P(^PAWARD(ward),"^",2)
	i $f(ward,"-") S ward=$p(ward,"-",2)
	S patstr=##class(web.DHCSTPIVA).GetOeInfoByMoeori(mmoeori)	/// 病人信息 bed_"^"_paname_"^"_ipno_"^"_age_"^"_sex
	S bed=$p(patstr,"^",1)  //床号
	S patname=$p(patstr,"^",2) //姓名
	S patno=$p(patstr,"^",3)  //登记号
	S batno=$P(^PIVA(pog),"^",3) //批号
	S odate=$P(^PIVA(pog),"^",4)
	S:odate'="" odate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(odate,"PIVA")
	S otime=$P(^PIVA(pog),"^",5)
	S:otime'="" otime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(otime,"PIVA")
	S pri=##class(web.DHCSTPIVA).GetOePriority(mmoeori)	/// 优先级
	s prcode=$P(pri,"^",2)	
	S pri=$P(pri,"^",3) //优先级
	s pydt=printdate	
	I (prcode="S") s pydt=printdate+1 
	s:printtime'="" printtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(printtime,"PIVA")
	S:printdate'="" printdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(printdate,"PIVA")_" "_printtime
	S:pydt'="" pydt=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(pydt,"PIVA")
	S printdt=printdate_" "_otime  //打签时间
	S pydt=pydt_" "_otime  //配液时间
	Q ward_"^"_bed_"^"_patname_" "_patno_"^"_batno_"^"_pri_"^"_printdate_"^"_pydt
}

/// 2011年5月20日   
/// 任晓娜
/// 增加计算病区已经打签，但是还未扫描的配液数量
/// 入参：界面传入的用户选择的病区
/// 返回值：还剩下多少未扫描
ClassMethod GetRecordNum(wardDesc As %String) As %String
{
	N (wardDesc)
	Q:wardDesc="" ""
    s wardDR="" 
    s pog=0
    s num=0
    
    //将传入的中文病区名字--》PAC_WARD的Rowid
    s ward=""
    s ward=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(wardDesc),ward))
    f  s pog=$o(^PIVA(pog)) q:pog=""  d
    .s phac=$p(^PIVA(pog),"^",10)  //发药主表RowID
    .I $D(^DHCPHAC(phac)) D
    ..s wardDR=$p(^DHCPHAC(phac),"^",4) /// 病区
    ..Q:(ward'="")&(ward'=wardDR)
    ..s stateDR=$p(^PIVA(pog),"^",6)  //PIVA_State表RowID
    ..Q:'$d(^PIVAS(stateDR))
    ..s state=$p(^PIVAS(stateDR),"^",1)  //取得当前状态
    ..Q:(state'="")&(state'="10")
    ..s num=num+1
	q num
}

}
