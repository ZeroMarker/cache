Import SQLUser

/// Description:配液状态执行：分签,贴签,排药,核对,配置,成品核查,打包,病区接收
/// Creator: Liang Qiang
/// CreatDate:2010-05-06
Class web.DHCSTPIVAPDA Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:配液状态执行  暂不用，留作参考
/// Creator: Liang Qiang
/// CreatDate:2010-05-06
/// Input:条码,执行代码,用户ID
/// Output:number
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
	Q:(oestcode'="V")&(oestcode'="E") -8_"^医嘱已停^"_Msg
	L +^PIVAPDA("PDA",barcode):30  E  Q -9_"^加锁失败^"_Msg
	S quitflag=0
	S ps=$O(^PIVAS(0,"NUMBER",cnumber,""))
 	I ps="" S quitflag=1
 	I quitflag'=0 L -^PIVAPDA("PDA",barcode)
 	Q:quitflag'=0 -10_"^状态配置错误^"_Msg
	S psdr=$P(^PIVA(pog),"^",6) /// pog的当前状态
	S pcnumber=$P(^PIVAS(psdr),"^",1)
	I pcnumber=cnumber S quitflag=2
	I quitflag'=0 L -^PIVAPDA("PDA",barcode)
	Q:pcnumber=cnumber -11_"^已执行^"_Msg
	I pcnumber'<70 S quitflag=3
	I quitflag'=0 L -^PIVAPDA("PDA",barcode)
	Q:quitflag'=0 -12_"^已计帐,不能执行^"_Msg
	S nextstr=##class(web.DHCSTPIVA).GetNextStat(psdr)
 	S nextnumber=$P(nextstr,"^",2)
 	I nextnumber'=cnumber S quitflag=4
 	I quitflag'=0 L -^PIVAPDA("PDA",barcode)
 	Q:quitflag'=0 -13_"^不应该进行此状态^"_Msg
 	S ret=..UpdPog(pog,ps,puser)	//1 处理 PIVA_OrdGrp系列表
 	I ret'=0 S quitflag=5
 	I quitflag'=0 TROLLBACK
 	I quitflag'=0 L -^PIVAPDA("PDA",barcode)
 	Q:quitflag'=0 -14_"^执行失败^"_Msg
 	L -^PIVAPDA("PDA",barcode)
 	I quitflag'=0 TROLLBACK
 	TCOMMIT
 	Q 0_"^执行成功^"_Msg
}

/// 暂不用，留作参考
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

/// 暂不用，留作参考
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

/// Description:配液状态执行,供PDA组使用,(最新整理)
/// Creator: Liang Qiang
/// CreatDate:2011-04-30
/// Input:条码,执行代码,用户ID
/// Output:返回消息
ClassMethod SaveCheckOK(barcode As %String, cnumber As %String, puser As %String) As %String
{
	N (barcode,cnumber,puser)
    S retval=##Class(web.DHCSTPIVAEXECUTE).SaveCheckOK(barcode,cnumber,puser)
    Q retval
}

/// Description:根据条码信息，查看执行状态
/// Creator: Peng Zhikun
/// CreatDate:2013-09-18
/// Input:条码，用户ID，执行代码
/// Output:返回消息
/// w ##Class(web.DHCSTPIVAPDA).ExePdaStatus("201309180001","578","61")
ClassMethod ExePdaStatus(Code As %String, Userid As %String, Num As %String) As %String
{
	;s ^tmp("ls")=Code_"^"_Userid_"^"_Num
	s locJson=##class(%ArrayOfDataTypes).%New()
	i Num'="" s Num=Num\10*10
	s Info=..SaveCheckOK(Code,Num,Userid)
	//0_"^执行成功^"_Msg
	s number=$p(Info,"^",1)
	s ErrorInfo=$p(Info,"^",2)
	s message=$p(Info,"^",3)
	
	d locJson.SetAt(number,"number")
	d locJson.SetAt(ErrorInfo,"ErrorInfo")
	d locJson.SetAt(message,"message")
	
	
	q ##class(Nur.JSON).Encode(locJson)
}

/// Description:根据条码信息，显示用户
/// Creator: Peng Zhikun
/// CreatDate:2013-09-18
/// Input:条码
/// Output:信息
/// w ##Class(web.DHCSTPIVAPDA).GetBarcodeInfo("201309170008")
ClassMethod GetBarcodeInfo(Code As %String) As %String
{
	;s ^tmp("rrr")=Code
	s json=##class(%ArrayOfDataTypes).%New()
	s patJson=##class(%ListOfDataTypes).%New()
	s patJson2=##class(%ListOfDataTypes).%New()
	
	s barcode=Code
	s patChildJson=##class(%ArrayOfDataTypes).%New()
	
	s ord=$p(Code,"-",1)
	s chl=$p(Code,"-",2)
	s exe=$p(Code,"-",3)
	s oeore=ord_"||"_chl_"||"_exe
	s dsp=$o(^DHCOEDISQTY(0,"OEORE",oeore,""))
	s tmpgrpno=$o(^PIVA(0,"OEGRP",dsp,""))
	
	s pog=$o(^PIVA(0,"OEGRP",dsp,tmpgrpno,""))
	
	//s pog=$o(^PIVA(0,"BARCODE",barcode,""))
	
    //s pog="125773"
	i pog="" d
	.//s itmdesc=""
	.//s dosqty=""
	.//d patChildJson.SetAt(itmdesc,"itmdesc")
	.//d patChildJson.SetAt(dosqty,"dosqty")
	.//d patJson.Insert(patChildJson)
	.//s batno=""
	.s paname=""
	.//s ipno=""
	.//d json.SetAt(batno,"batno")
	.d json.SetAt(paname,"paname")
	.//d json.SetAt(ipno,"ipno")
	.//d json.SetAt($g(patJson),"drug")
    q:pog="" ##class(Nur.JSON).Encode(json)
		
	s moeori=ord_"||"_chl  //$p(^PIVA(pog),"^",1)
	// 病人信息patstr： bed_"^"_paname_"^"_ipno_"^"_age_"^"_sex
	S patstr=##class(web.DHCSTPIVA).GetOeInfoByMoeori(moeori)
	S bed=$p(patstr,"^",1)       ///病床号
	s bed=" "_bed
	s paname=$p(patstr,"^",2)   //病人姓名
	S ipno=$p(patstr,"^",3)     //登记号
	
	Q:pog="" -5_"^无此标签"
	Q:'$d(^PIVA(pog)) -6_"^无此标签"
	S phac=$P(^PIVA(pog),"^",10)
 	Q:phac="" -7_"^取标签信息错误"
 	
	S pogsub=""
	F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	.S dodis=$P(^PIVA(pog,"I",pogsub),"^",1)
	.Q:dodis=""
	.Q:'$D(^DHCOEDISQTY(dodis))
 	.S oeori=$p(^DHCOEDISQTY(dodis),"^",1)
 	.S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	.S inci=$P(incitm,"^",1)
 	.S itmdesc=$P(incitm,"^",3)  //药品
 	.S ord=$p(oeori,"||",1)
	.S itm=$p(oeori,"||",2)
	.S dosqty=$P(^OEORD(ord,"I",itm,2),"^",1)  //剂量
	.S DosUnit=$p(^OEORD(ord,"I",itm,2),"^",3) //单位
	.S BuomDesc=$P($G(^CT("UOM",DosUnit)),"^",2)
	.s dosqty=dosqty_BuomDesc
	
	.s patChildJson=##class(%ArrayOfDataTypes).%New()
	.d patChildJson.SetAt(itmdesc,"itmdesc")
	.d patChildJson.SetAt(dosqty,"dosqty")
	.
	.d patJson.Insert(patChildJson)
	
	S PogsSub="0"
 	F  S PogsSub=$O(^PIVA(pog,"S",PogsSub)) Q:PogsSub=""  D
 	.S psID=$P(^PIVA(pog,"S",PogsSub),"^",2)
 	.S (psName,psNumber)=""
 	.I psID'="" D
 	..S psName=$P($G(^PIVAS(psID)),"^",2)          ///状态
 	..S psNumber=$P($G(^PIVAS(psID)),"^",1)
 	.S psUser=$P(^PIVA(pog,"S",PogsSub),"^",3)    ///执行人
 	.I psUser'="" S psUser=$P($G(^SSU("SSUSR",psUser)),"^",2)
 	.S psDate=$P(^PIVA(pog,"S",PogsSub),"^",4)
 	.I psDate'="" S psDate=$ZD(psDate,3)
 	.S psTime=$P(^PIVA(pog,"S",PogsSub),"^",5)
 	.I psTime'="" S psTime=$ZT(psTime,1)
 	.S psDT=psDate_" "_psTime        ///执行时间
 	.s patChildJson2=##class(%ArrayOfDataTypes).%New()
 	.d patChildJson2.SetAt(psName,"psName")
 	.d patChildJson2.SetAt(psUser,"psUser")
 	.d patChildJson2.SetAt(psDT,"psDT")
 	.d patJson2.Insert(patChildJson2)
 	
	
 	
 	S warddr=$P(^DHCPHAC(phac),"^",4)
 	S ward=""
 	I warddr'="" D
	.S:$D(^PAWARD(warddr)) ward=$P(^PAWARD(warddr),"^",2)  ///病区
	S batno=$P(^PIVA(pog),"^",3)
	S batno=batno_"批"          ///批号
	s ipno=ipno_" "
	
	s patChildJson=##class(%ArrayOfDataTypes).%New()
	s ordstatus=""
	s medino=""
	d json.SetAt(batno,"batno")
	d json.SetAt(paname,"paname")
	d json.SetAt(ipno,"ipno")
	d json.SetAt(ward,"ward")
	d json.SetAt(bed,"bed")
	d json.SetAt(medino,"medino")
	d json.SetAt(ordstatus,"ordstatus")
	d json.SetAt($g(patJson),"drug")
	d json.SetAt($g(patJson2),"psInfo")	
	
	q ##class(Nur.JSON).Encode(json)
}

}
