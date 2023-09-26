Class DHCWL.InsuStat.MZYBInfo Extends %RegisteredObject
{

/// 门诊发票id
Property FBId As %String;

/// 账单id
Property PBId As %String;

/// 结算标志Flag
Property Flag As %String;

/// 挂号科室ID
Property DeptId As %String;

/// 挂号科室
Property Dept As %String;

/// 医生ID
Property DoctorId As %String;

/// 医生
Property Doctor As %String;

/// 发票日期(交易日期)
Property PrtDate As %Date;

/// 险种类别
Property FundType As %String;

/// 险种类别名称
Property FundTypeDesc As %String;

/// 医疗类别
Property yllb As %String;

/// 医疗类别名称
Property yllbDesc As %String;

/// 医保号
Property InsuNo As %String;

/// 就诊id
Property AdmId As %String;

/// 病人登记号
Property PatNo As %String;

/// 身份证号
Property SfzH As %String;

/// 姓名
Property Name As %String;

/// 性别
Property Sex As %String;

/// 年龄
Property Age As %String;

/// 结算类型
Property Jslx As %String;

/// 单据流水号
Property djlsh As %String;

/// 门诊特病
Property sftsbz As %String;

/// 医保身份
Property InsuTypeId As %String;

/// 医保身份名称
Property InsuType As %String;

/// 分类总费用  
Property TotalFee As %Float;

/// 分类自付费用
Property PatFee As %Float;

/// 分类医保费用
Property InsuFee As %Float;

/// 总费用
Property PBFee As %Float;

/// 西药
Property XYFFee As %Float;

/// 中成药
Property ZYFFee As %Float;

/// 中草药
Property ZCYFee As %Float;

/// 化验
Property HYFee As %Float;

/// 放射
Property FSFee As %Float;

/// B超
Property BCFee As %Float;

/// CT
Property CTFee As %Float;

/// 核磁
Property HCFee As %Float;

/// 检查费
Property JCFee As %Float;

/// 治疗费
Property ZLFee As %Float;

/// 材料费
Property CLFee As %Float;

/// 手术费
Property SSFee As %Float;

/// 输氧费
Property SYFee As %Float;

/// 输血费
Property SXFee As %Float;

/// 正畸费
Property ZJFee As %Float;

/// 镶牙费
Property XYFee As %Float;

/// 司法鉴定
Property SFJDFee As %Float;

/// 其他
Property QTFee As %Float;

//d ##class(DHCWL.InsuStat.MZYBInfo).%New(5029597)

Method %OnNew(fbId As %String) As %Status
{
	s flstr="西药|中成药|中草药|化验|放射|B超|CT|核磁|检查费|治疗费|材料费|手术费|输氧费|输血费|正畸费|镶牙费|司法鉴定|其他"  
	s ..FBId=fbId
	s outStrInsu=..GetDivInfoByInvPrtDr(fbId)
	q:outStrInsu="" ""
	s ..AdmId=$p(outStrInsu,"^",1) ;就诊号
	s admId=$p(outStrInsu,"^",1) ;就诊号
	;q:admId="" ""
	s ..PrtDate=$p(outStrInsu,"^",2) ;交易日期
	s ..FundType=$p(outStrInsu,"^",5) ;险种类型代码
	s ..FundTypeDesc=$p(outStrInsu,"^",28)  ;险种类型名称
	s ..yllb=$p(outStrInsu,"^",6) ;医疗类别
	s ..yllbDesc=$p(outStrInsu,"^",27) ;医疗类别名称
	s ..InsuNo=$p(outStrInsu,"^",4) ;医保号
	s ..Jslx=$p(outStrInsu,"^",11) ;结算类型
	s ..djlsh=$p(outStrInsu,"^",24) ;急诊留观
	s ..sftsbz=$p(outStrInsu,"^",25) ;特病门诊
	s ..Flag=$p(outStrInsu,"^",29) ;结算状态
	s PBFee=$p(outStrInsu,"^",23) ;分类费用
	s Flag1=$p(outStrInsu,"^",29) ;结算状态
	s Jslx1=$p(outStrInsu,"^",11) ;结算类型
	i ((Flag1'="strike")) d
	.s ..TotalFee=$p(outStrInsu,"^",7) ;总费用
	.s InsuFee1=$p(outStrInsu,"^",8) ;医保支付费用
	.s InsuFee2=$p(outStrInsu,"^",10) ;账户支付费用
	.s ..InsuFee=InsuFee1+InsuFee2   ;医保支付费用总和
	.s ..PatFee=$p(outStrInsu,"^",9) ;个人自付费用
	.s ..XYFFee=$p(PBFee,"|",1) ;西药
    .s ..ZYFFee=$p(PBFee,"|",2) ;中成药
	.s ..ZCYFee=$p(PBFee,"|",3) ;中草药
	.s ..HYFee=$p(PBFee,"|",4) ;化验
	.s ..FSFee=$p(PBFee,"|",5) ;放射
	.s ..BCFee=$p(PBFee,"|",6) ;B超
	.s ..CTFee=$p(PBFee,"|",7) ;CT
	.s ..HCFee=$p(PBFee,"|",8) ;核磁
	.s ..JCFee=$p(outStrInsu,"^",26) ;检查费
	.s ..ZLFee=$p(PBFee,"|",10) ;治疗费
	.s ..CLFee=$p(PBFee,"|",11) ;材料费
	.s ..SSFee=$p(PBFee,"|",12) ;手术费
	.s ..SYFee=$p(PBFee,"|",13)  ;输氧费
	.s ..SXFee=$p(PBFee,"|",14) ;输血费
	.s ..ZJFee=$p(PBFee,"|",15) ;正畸费
	.s ..XYFee=$p(PBFee,"|",16) ;镶牙费
	.s ..SFJDFee=$p(PBFee,"|",17) ;司法鉴定
	.s ..QTFee=$p(PBFee,"|",18) ;其他
	i ((Flag1="strike"))  d
	.s ..TotalFee=$p(outStrInsu,"^",7) ;总费用
	.s InsuFee1=$p(outStrInsu,"^",8) ;医保支付费用
	.s InsuFee2=$p(outStrInsu,"^",10) ;账户支付费用
	.s ..InsuFee=InsuFee1+InsuFee2   ;医保支付费用总和
	.s ..PatFee=$p(outStrInsu,"^",9) ;个人自付费用
	.s ..XYFFee=$p(PBFee,"|",1)*(-1) ;西药
    .s ..ZYFFee=$p(PBFee,"|",2)*(-1) ;中成药
	.s ..ZCYFee=$p(PBFee,"|",3)*(-1) ;中草药
	.s ..HYFee=$p(PBFee,"|",4)*(-1) ;化验
	.s ..FSFee=$p(PBFee,"|",5)*(-1) ;放射
	.s ..BCFee=$p(PBFee,"|",6)*(-1) ;B超
	.s ..CTFee=$p(PBFee,"|",7)*(-1) ;CT
	.s ..HCFee=$p(PBFee,"|",8)*(-1) ;核磁
	.s ..JCFee=$p(outStrInsu,"^",26) ;检查费
	.s ..ZLFee=$p(PBFee,"|",10)*(-1) ;治疗费
	.s ..CLFee=$p(PBFee,"|",11)*(-1) ;材料费
	.s ..SSFee=$p(PBFee,"|",12)*(-1) ;手术费
	.s ..SYFee=$p(PBFee,"|",13)*(-1)  ;输氧费
	.s ..SXFee=$p(PBFee,"|",14)*(-1) ;输血费
	.s ..ZJFee=$p(PBFee,"|",15)*(-1) ;正畸费
	.s ..XYFee=$p(PBFee,"|",16)*(-1) ;镶牙费
	.s ..SFJDFee=$p(PBFee,"|",17)*(-1) ;司法鉴定
	.s ..QTFee=$p(PBFee,"|",18)*(-1) ;其他
	i admId'="" d
	.s admrea=$p(^PAADM(admId,1),"^",7)
	.s dep=$p(^PAADM(admId),"^",4)
	.i dep="" d
	..s dep="999999"
	..s deptsc="Null"
	.e  d
	..s deptsc=$$GetDepDesc^DHCWLCommon(dep)
	..s ..DeptId=dep ;科室ID
	..s ..Dept=deptsc ;科室
	.s papmi=$p(^PAADM(admId),"^",1)
	.s ..SfzH=$$GetPatId^DHCWLCommon(papmi) ;身份证号
	.s ..PatNo=$$GetPapmiNo^DHCWLCommon(papmi) ;登记号
	.s ..Name=$$GetPapmiName^DHCWLCommon(papmi) ;姓名
	.s ..Sex=$$GetSex^DHCWLCommon(papmi) ;性别
	.s ..InsuTypeId=admrea
	.s ..InsuType=$$GetReason^DHCWLCommon(admId)
	.s Brithday=$p(^PAPER(papmi,"ALL"),"^",6)  ;生日
	.s ..Age=##class(web.DHCDTHealthCommon).GetAgeDesc(Brithday,+$h)
    .s dischrdoc=$p(^PAADM(admId),"^",9)
    .i dischrdoc'=""  d 
    ..s ..DoctorId=dischrdoc
    ..s ..Doctor=$p(^CTPCP(dischrdoc,1),"^",2 )
    .e  d
    ..s ..DoctorId="999999"
    ..s ..Doctor="Null"
    i admId="" d
	.s admrea=""
  	.s dep="999999"
	.s deptsc="Null"
	.s ..DeptId=dep ;科室ID
	.s ..Dept=deptsc ;科室
	.s papmi=""
	.s ..SfzH="" ;身份证号
	.s ..PatNo="" ;登记号
	.s ..Name=$p(outStrInsu,"^",30)  ;姓名
	.s ..Sex=""
	.s ..InsuTypeId=""
	.s ..InsuType=""
	.s Brithday=""
	.s ..Age=""
    .s ..DoctorId="999999"
    .s ..Doctor="Null"
	q 1
}

/// lilizhi
/// 2013-08-12
/// 给统计组接口，根据发票rowid取医保分解信息  4623899 4626389 5098410
/// w ##class(web.DHCINSUPort).GetDivInfoByInvPrtDr(4883738)
/// input : InvPrtDr  dhc_invprt.rowid  
/// output: 结算日期^发票号^医保号^险种类型代码^医疗类别代码^总费用^基金支付^个人支付^账户支付^结算标志(普通门诊、急诊留观、门诊特病)^单病种差价^本年账户^历年账户^离休基金^而已基金^军转基金^个人支付
///         ^费用金额^医保内金额^医保外金额^本次起付线金额^个人自负2^门诊大额支付金额^/门诊大额自负金额^超大额自付金额^补充保险支付金额^军残补助保险金额 
///         ^西药|中成药|中草药|化验|放射|B超|CT|核磁|治疗费|检查费|材料费|手术费|输氧费|输血费|正畸费|镶牙费|司法鉴定|其他  
/// /w ##class(DHCWL.InsuStat.MZYBInfo).GetDivInfoByInvPrtDr(5100946)  ;门诊特病
/// /w ##class(DHCWL.InsuStat.MZYBInfo).GetDivInfoByInvPrtDr(4492773)  ;急诊留观
/// /w ##class(DHCWL.InsuStat.MZYBInfo).GetDivInfoByInvPrtDr(4896234)  ;普通门诊
/// /w ##class(DHCWL.InsuStat.MZYBInfo).GetDivInfoByInvPrtDr(4878596)  ;挂号退费
ClassMethod GetDivInfoByInvPrtDr(InvPrtDr As %String) As %String
{
	q:InvPrtDr="" ""
	s OutStr=""
	s office=1
	s yllb=""
	s PrtDate1=$p($g(^DHCINVPRT(InvPrtDr)),"^",5)
	s PrtTime1=$p($g(^DHCINVPRT(InvPrtDr)),"^",20)
	s PrtDate1=$zd(PrtDate1,3)
	s PrtTime1=$zt(PrtTime1,1)
	s PrtDate=PrtDate1_" "_PrtTime1 ;交易日期时间
	s PrtInv=$p($g(^DHCINVPRT(InvPrtDr)),"^",14)
	s FairType=$p($g(^DHCINVPRT(InvPrtDr)),"^",34)
	s InsuDivDr=$p($g(^DHCINVPRT(InvPrtDr)),"^",30)
	s PrtAccount=$p($g(^DHCINVPRT(InvPrtDr)),"^",1)
	i FairType="R" d
	.i PrtAccount<0 d
	..s InitInvDr=$p($g(^DHCINVPRT(InvPrtDr)),"^",13)
	..s InsuDivDr=$p($g(^DHCINVPRT(InitInvDr)),"^",30)
	..s office=-1
	.q:InsuDivDr=""
	.s Flag=$p($g(^DHCINADM(InsuDivDr)),"^",11)
	.q:(Flag="D")||(Flag="Card")
	.s AdmDr=$p($g(^DHCINADM(InsuDivDr)),"^",1)
	.;q:AdmDr=""
	.;s paadmType=$p($g(^PAADM(AdmDr)),"^",2)
	.;s mAdmTpeTB=$$GetTbAdm^DHCWLBuildKPIData0005(AdmDr) ;lxc 2013-9-17 屏蔽 挂号不区分特病、急观
	.;s mAdmTpeJG=$$GetJGAdm^DHCWLBuildKPIData0005(AdmDr) 
	.;i mAdmTpeTB=1 s jslx="门诊特病" 
	.;i mAdmTpeJG=1 s jslx="急诊留观"  
	.;i ((mAdmTpeTB=0) && (mAdmTpeJG=0)) s jslx="普通门诊" ;lxc 2013-9-17 屏蔽 挂号不区分特病、急观
	.s jslx="普通门诊"
	.s dbzcj=0
	.s djlsh=""
	.s sftsbz=""  
	.s bcbxf0=$p($g(^DHCINADM(InsuDivDr)),"^",26)* office //总费用
    .s jjzfe0=$p($g(^DHCINADM(InsuDivDr)),"^",28)* office //基金支付
	.s grzfe0=$p($g(^DHCINADM(InsuDivDr)),"^",27)* office  //个人支付
	.s zhzfe0=$p($g(^DHCINADM(InsuDivDr)),"^",29)* office  //账户支付
	.s mzfee=$p($g(^DHCINADM(InsuDivDr)),"^",30)* office  //费用金额
	.s mzfeein=$p($g(^DHCINADM(InsuDivDr)),"^",31)* office  //医保内金额
	.s mzfeeout=$p($g(^DHCINADM(InsuDivDr)),"^",32)* office  //医保外金额
	.s mzpayfirst=$p($g(^DHCINADM(InsuDivDr)),"^",33)* office  //本次起付线金额
	.s mzselfpay2=$p($g(^DHCINADM(InsuDivDr)),"^",34)* office  //个人自负2
	.s mzbigpay=$p($g(^DHCINADM(InsuDivDr)),"^",35)* office  //门诊大额支付金额
	.s mzbigselfpay=$p($g(^DHCINADM(InsuDivDr)),"^",36)* office  //门诊大额自负金额
	.s mzoutofbig=$p($g(^DHCINADM(InsuDivDr)),"^",37)* office  //超大额自付金额
	.s bcpay=$p($g(^DHCINADM(InsuDivDr)),"^",38)* office  //补充保险支付金额
	.s jcbz=$p($g(^DHCINADM(InsuDivDr)),"^",39)* office  //军残补助保险金额
	 
	.s medicatalog="0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|"_bcbxf0  //医保费用分类
	
	.s InsuNo=$p($g(^DHCINADM(InsuDivDr)),"^",18)  //医保号
	.s yllb=$p($g(^DHCINADM(InsuDivDr)),"^",4)    //医疗类别
	.s FundType=$p($g(^DHCINADM(InsuDivDr)),"^",18) //险种类型
	.s outstr1=##class(web.INSUDicDataCtl).QueryByCodeNB("AKC021", yllb)
	.s yllbDesc=$p(outstr1,"^",4)  //医疗人员类别名称
	.s outstr2=##class(web.INSUDicDataCtl).QueryByCodeNB("BAE059", FundType)
	.s FundTypeDesc=$p(outstr2,"^",4)   //险种类型名称
	.i AdmDr="" s Name=$p($g(^DHCINADM(InsuDivDr)),"^",6)
	.i AdmDr'="" s Name=""
	.s OutStr=AdmDr_"^"_PrtDate_"^"_PrtInv_"^"_InsuNo_"^"_FundType_"^"_yllb_"^"_bcbxf0_"^"_jjzfe0_"^"_grzfe0_"^"_zhzfe0_"^"_jslx_"^"_dbzcj
	.s OutStr=OutStr_"^"_mzfee_"^"_mzfeein_"^"_mzfeeout_"^"_mzpayfirst_"^"_mzselfpay2_"^"_mzbigpay_"^"_mzbigselfpay_"^"_mzoutofbig_"^"_bcpay_"^"_jcbz
	.s OutStr=OutStr_"^"_medicatalog_"^"_djlsh_"^"_sftsbz_"^"_$p(medicatalog,"|",9)_"^"_yllbDesc_"^"_FundTypeDesc_"^"_Flag_"^"_Name
	e  d
	.;s EmFlag=$p($g(^DHCINVPRT(InvPrtDr)),"^",41)      //EmFlag=Y 是急诊留观结算
	.;s DHCBCIDr=$o(^DHCBCI(0,"INV",InvPrtDr,""))
	.;s AdmDr=$p(^DHCBCI(DHCBCIDr),"^",3)
	.;s AdmreasonDr=$p(^PAADM(AdmDr,"1"),"^",7)
	.;s AdmSource=$p(^PAC("ADMREA",AdmreasonDr),"^",9)   //AdmSource=2 是门诊特病
	.;i ((AdmSource="2")||(EmFlag="Y"))&(PrtAccount<0) d
	.i (InsuDivDr="" &(PrtAccount<0))  d
	..s InitInvDr=$p($g(^DHCINVPRT(InvPrtDr)),"^",13)
	..s InsuDivDr=$p($g(^DHCINVPRT(InitInvDr)),"^",30)
	..s office=-1
	.q:InsuDivDr=""
	.s Flag=$p($g(^DHCINDIV(InsuDivDr)),"^",5)
	.q:Flag="divide"
	.s djlsh=$p($g(^DHCINDIV(InsuDivDr)),"^",8)
	.s sftsbz=$p($g(^DHCINDIV(InsuDivDr)),"^",25)
	.s jslx="普通门诊"
	.s dbzcj=0
	.i sftsbz="Y"  d
	..s jslx="门诊特病"
	..s dbzcj=$p($g(^DHCINDIV(InsuDivDr)),"^",43)
	.i (sftsbz'="Y")&&(djlsh="") d
	..s jslx="急诊留观"
	..s dbzcj=$p($g(^DHCINDIV(InsuDivDr)),"^",43)
	.s bcbxf0=$p($g(^DHCINDIV(InsuDivDr)),"^",7) * office   //总费用
	.s jjzfe0=$p($g(^DHCINDIV(InsuDivDr)),"^",19)* office   //基金支付
	.s grzfe0=$p($g(^DHCINDIV(InsuDivDr)),"^",15)* office   //个人支付
	.s zhzfe0=$p($g(^DHCINDIV(InsuDivDr)),"^",28)* office  //账户支付
	.s InsuNo=$p($g(^DHCINDIV(InsuDivDr)),"^",18)   //医保号
	.s InsuAdmDr=$p($g(^DHCINDIV(InsuDivDr)),"^",2)
	.;q:(jslx="普通门诊")&&(InsuAdmDr="")
	.s AdmDr=$p($g(^DHCINDIV(InsuDivDr)),"^",1)
	.q:AdmDr=""
	.//2013-9-18 lxc add 
	.s PrtInuFlag="Y"  
	.i ((jslx="门诊特病") ! (jslx="急诊留观"))  d
	..s PrtInuFlag="N"
	..s:FairType="F" PrtInuFlag="Y"
	.q:PrtInuFlag="N"
	.//2013-9-18 lxc add 
	.;s paadmType=$p($g(^PAADM(AdmDr)),"^",2)
	.;s:paadmType="O" yllb="11"                      
	.;s:paadmType="E" yllb="19"
	.i InsuAdmDr="" d
	..s yllb="",yllbDesc=""
	..s FundType="",FundTypeDesc=""
	.e     d
	..s yllb=$p($g(^DHCINADM(InsuAdmDr)),"^",4)    //医疗类别
	..s FundType=$p($g(^DHCINADM(InsuAdmDr)),"^",18) //险种类型
	..s outstr3=##class(web.INSUDicDataCtl).QueryByCodeNB("AKC021", yllb)
	..s yllbDesc=$p(outstr3,"^",4)  //医疗人员类别名称
	..s outstr4=##class(web.INSUDicDataCtl).QueryByCodeNB("BAE059", FundType)
	..s FundTypeDesc=$p(outstr4,"^",4)   //险种类型名称
	.i djlsh=""  d
	..s medicatalog=""
	.e       d
	..s medicatalog=$p($g(^DHCINDIV(InsuDivDr)),"^",45)  //费用分类      西药|中成药|中草药|化验|放射|B超|CT|核磁|治疗费|检查费|材料费|手术费|输氧费|输血费|正畸费|镶牙费|司法鉴定|其他  
	..s $p(medicatalog,"|",9)=bcbxf0-$p(medicatalog,"|",1)-$p(medicatalog,"|",2)-$p(medicatalog,"|",3)-$p(medicatalog,"|",4)-$p(medicatalog,"|",5)-$p(medicatalog,"|",6)-$p(medicatalog,"|",7)-$p(medicatalog,"|",8)-$p(medicatalog,"|",10)-$p(medicatalog,"|",11)-$p(medicatalog,"|",12)-$p(medicatalog,"|",13)-$p(medicatalog,"|",14)-$p(medicatalog,"|",15)-$p(medicatalog,"|",16)-$p(medicatalog,"|",17)-$p(medicatalog,"|",18)
	.i Flag="strike" d
	..s bestrikeDr=$p($g(^DHCINDIV(InsuDivDr)),"^",6)
	..s medicatalog=$p($g(^DHCINDIV(bestrikeDr)),"^",45)  //费用分类      西药|中成药|中草药|化验|放射|B超|CT|核磁|治疗费|检查费|材料费|手术费|输氧费|输血费|正畸费|镶牙费|司法鉴定|其他  
	..s $p(medicatalog,"|",9)=bcbxf0+$p(medicatalog,"|",1)+$p(medicatalog,"|",2)+$p(medicatalog,"|",3)+$p(medicatalog,"|",4)+$p(medicatalog,"|",5)+$p(medicatalog,"|",6)+$p(medicatalog,"|",7)+$p(medicatalog,"|",8)+$p(medicatalog,"|",10)+$p(medicatalog,"|",11)+$p(medicatalog,"|",12)+$p(medicatalog,"|",13)+$p(medicatalog,"|",14)+$p(medicatalog,"|",15)+$p(medicatalog,"|",16)+$p(medicatalog,"|",17)+$p(medicatalog,"|",18) 
	.s mzfee=$p($g(^DHCINDIV(InsuDivDr)),"^",31)* office  //费用金额
	.s mzfeein=$p($g(^DHCINDIV(InsuDivDr)),"^",32)* office  //医保内金额
	.s mzfeeout=$p($g(^DHCINDIV(InsuDivDr)),"^",33)* office  //医保外金额
	.s mzpayfirst=$p($g(^DHCINDIV(InsuDivDr)),"^",34)* office  //本次起付线金额
	.s mzselfpay2=$p($g(^DHCINDIV(InsuDivDr)),"^",35)* office  //个人自负2
	.s mzbigpay=$p($g(^DHCINDIV(InsuDivDr)),"^",36)* office  //门诊大额支付金额
	.s mzbigselfpay=$p($g(^DHCINDIV(InsuDivDr)),"^",37)* office  //门诊大额自负金额
	.s mzoutofbig=$p($g(^DHCINDIV(InsuDivDr)),"^",38)* office  //超大额自付金额
	.s bcpay=$p($g(^DHCINDIV(InsuDivDr)),"^",39)* office  //补充保险支付金额
	.s jcbz=$p($g(^DHCINDIV(InsuDivDr)),"^",40)* office  //军残补助保险金额 
	.s Name=""
	.s OutStr=AdmDr_"^"_PrtDate_"^"_PrtInv_"^"_InsuNo_"^"_FundType_"^"_yllb_"^"_bcbxf0_"^"_jjzfe0_"^"_grzfe0_"^"_zhzfe0_"^"_jslx_"^"_dbzcj
	.s OutStr=OutStr_"^"_mzfee_"^"_mzfeein_"^"_mzfeeout_"^"_mzpayfirst_"^"_mzselfpay2_"^"_mzbigpay_"^"_mzbigselfpay_"^"_mzoutofbig_"^"_bcpay_"^"_jcbz
	.s OutStr=OutStr_"^"_medicatalog_"^"_djlsh_"^"_sftsbz_"^"_$p(medicatalog,"|",9)_"^"_yllbDesc_"^"_FundTypeDesc_"^"_Flag_"^"_Name
 
	q OutStr
}

}
