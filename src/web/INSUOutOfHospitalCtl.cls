Class web.INSUOutOfHospitalCtl Extends (%RegisteredObject, %XML.Adaptor)
{

/// Modify : tangzf
/// ModifyDate : 2019-09-03
/// Descript: 查询患者院外垫付信息 查询条件优先级:流水号 ->身份证   时间条件一直生效.
/// Input:	
/// 		StartDate : 开始日期
/// 		EndDate : 结束日期
/// 		Zstr12 : 就诊类别 OP/IP
/// 		djlsh0 : User.INSUDivide.djlsh0 流水号
/// 		id0000 : User.INSUDivide.id0000 身份证号
/// 		Zstr04 : 医保类型
/// Output: User.INSUDivide 表数据
/// Return: 
/// DeBug: d ##Class(%ResultSet).RunQuery("web.INSUOutOfHospitalCtl","QryOutOfHospital","64246","64246","","","")
Query QryOutOfHospital(StartDate As %String, EndDate As %String, Zstr12 As %String, djlsh0 As %String, id0000 As %String, Zstr04 As %String = "", HospDr) As %Query(ROWSPEC = "TRowID:%String,TAdmDr:%String,TAdmInfoDr:%String,TDHCpblDr:%String,TDhcInvPrtDr:%String,TFlag:%String,TINSUDivideDr:%String,Tbcbxf0:%String,Tdjlsh0:%String,Tbckbc:%String,Tbqbm00:%String,Tbrnl00:%String,Tcardno:%String,Tcfms0:%String,Tcrbcts:%String,Tgrzfe0:%String,TiDate:%String,TiTime:%String,Tid0000:%String,Tjjzfe0:%String,Tptbcts:%String,TsUserDr:%String,Tsfrq00:%String,Tsfrxm0:%String,Tsfsj00:%String,Tsftsbz:%String,Tbie00:%String,Txming0:%String,Tzhzfe0:%String,Tzyksmc:%String,Tzylsh0:%String,TInsuPay1:%String,TInsuPay2:%String,TInsuPay3:%String,TInsuPay4:%String,TInsuPay5:%String,TZstr01:%String,TZstr02:%String,TZstr03:%String,TZstr04:%String,TZstr05:%String,TZstr06:%String,TZstr07:%String,TZstr08:%String,TZstr09:%String,TZstr10:%String,TInsuPay6:%String,TInsuPay7:%String,TInsuPay8:%String,TInsuPay9:%String,TInsuPay10:%String,TZstr11:%String,TZstr12:%String,TZstr13:%String,TZstr14:%String,TZstr15:%String,TZstr16:%String,TZstr17:%String,TZstr18:%String,TZstr19:%String,TZstr20:%String,TZstr21:%String,TZstr22:%String,TZstr23:%String,TZstr24:%String,TZstr25:%String,TZstr26:%String,TZstr27:%String,TZstr28:%String,TZstr29:%String,TZstr30:%String,TZstr31:%String,Flag,Sex,AdmType,States,PatType,MedType,InsuType")
{
}

ClassMethod QryOutOfHospitalExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Zstr12 As %String, djlsh0 As %String, id0000 As %String, Zstr04 As %String = "", HospDr) As %Status
{
	set ^CacheTemp("QryOutOfHospital")=$lb(StartDate , EndDate , Zstr12 , djlsh0, id0000,Zstr04,HospDr)
	set:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	set:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	Set repid=$I(^CacheTemp)
	set ind=1
	s qHandle=$lb(0,repid,0)

    i djlsh0'="" d
    .s DivDr=""
    .f  s DivDr=$o(^DHCINDIV("0","Djlsh0",djlsh0,DivDr)) q:DivDr=""  d
	..s DivInfo=$g(^DHCINDIV(DivDr))
    ..d BuildOutOfHospitalInfo
    else  i id0000'="" d
    .s DivDr=""
    .f  s DivDr=$o(^DHCINDIV("0","ID0000",id0000,DivDr)) q:DivDr=""  d
    ..d BuildOutOfHospitalInfo
    else  i ((StartDate'="")&&(EndDate'="")) d
	.f CurDate=StartDate:1:EndDate d
	..s DivDr=""
	..f  s DivDr=$o(^DHCINDIV("0","IDate",CurDate,DivDr)) q:DivDr=""  d
    ...d BuildOutOfHospitalInfo
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildOutOfHospitalInfo  
	s DivInfo=$g(^DHCINDIV(DivDr))
	quit:HospDr'=$p(DivInfo,"^",71) 
	q:DivInfo=""
	s Zstr01=$p(DivInfo,"^",36)                              ;类型标志 R 挂号,F 收费,W 院外报销
	q:Zstr01'="W" 
	s TZstr12=$p(DivInfo,"^",52)                             ;就诊类型(Zstr12)OP门诊 IP住院
	q:((Zstr12'="")&&(TZstr12'=Zstr12))
	s TRowID=DivDr
	s TFlag=$p(DivInfo,"^",5)                                ;结算状态 I:正常结算,B:被作废,S:作废
	s ratio=1
	s:TFlag="S" ratio=-1
	s TFlag=$case(TFlag,"I":"正常结算","B":"被作废","S":"作废","D":"预结算",:TFlag) // tangzf 2019-9-3+
	;s $p(DivInfo,"^",5)=TFlag

	
	s iDate=$p(DivInfo,"^",16)
	quit:(StartDate'="")&&(StartDate>iDate) // tangzf 2019-9-3
	quit:(EndDate'="")&&(EndDate<iDate)
	set INSUAdmInfDr=$p(DivInfo,"^",2) 
	set TmpINSUType=$p(DivInfo,"^",39)
	quit:(Zstr04'="")&&(Zstr04'=TmpINSUType)
	s iDate=##class(websys.Conversions).DateLogicalToHtml(iDate) ;操作日期使用系统配制方法
	s $p(DivInfo,"^",16)=iDate
	
	s $p(DivInfo,"^",7)=$fn($p(DivInfo,"^",7)*ratio,"",2)              ;总费用
	s $p(DivInfo,"^",15)=$fn($p(DivInfo,"^",15)*ratio,"",2)            ;个人自付费用
	s $p(DivInfo,"^",19)=$fn($p(DivInfo,"^",19)*ratio ,"",2)            ;垫付费用
	s TsUserDr=$p(DivInfo,"^",21)                            ;录入人id
	s:TsUserDr'="" TsUserDr=$p($g(^SSU("SSUSR",TsUserDr)),"^",2)          ;录入人姓名
	s $p(DivInfo,"^",21)=TsUserDr
	s Tsftsbz=$p(DivInfo,"^",25)                             ;医疗类别(sftsbz)
	s Tbie00=$p(DivInfo,"^",26)                              ;性别
	s Tbie00=$case(Tbie00,"1":"男","2":"女",:Tbie00) 
	;s $p(DivInfo,"^",26)=Tbie00
	s TZstr04=$p(DivInfo,"^",39)                             ;医保类型(Zstr04)
	q:TZstr04'=Zstr04                                          //+DingSH 20200825 按照医保类型过滤
	s TZstr10=$p(DivInfo,"^",45)                             ;待遇类别(Zstr10)
	s TZstr12=$case(TZstr12,"OP":"门诊","IP":"住院",:TZstr12) 
	;s $p(DivInfo,"^",52)=TZstr12
	s TZstr13=$p(DivInfo,"^",53)                             ;地区(Zstr13)
	s TZstr13Desc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("admdvs"_TZstr04,TZstr13,4,HospDr)  //YAB003
	s:TZstr13Desc'="" TZstr13=TZstr13Desc
	;s $p(DivInfo,"^",53)=TZstr13
	s TZstr10Desc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("psn_type"_TZstr04,TZstr10,4,HospDr)  //AKC021
	s:TZstr10Desc'="" TZstr10=TZstr10Desc
	;s $p(DivInfo,"^",45)=TZstr10
	s TsftsbzDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("med_type"_TZstr04,Tsftsbz,4,HospDr)  //AKA130
	s:TsftsbzDesc'="" Tsftsbz=TsftsbzDesc
	;s $p(DivInfo,"^",25)=Tsftsbz
	s TZstr04=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DLLType",TZstr04,4,HospDr) 
	;s $p(DivInfo,"^",39)=TZstr04  
	set Data=$lb(TRowID,$p(DivInfo,"^",1),$p(DivInfo,"^",2),$p(DivInfo,"^",3),$p(DivInfo,"^",4),TFlag,$p(DivInfo,"^",6),
	$p(DivInfo,"^",7),$p(DivInfo,"^",8),$p(DivInfo,"^",9),$p(DivInfo,"^",10),$p(DivInfo,"^",11),$p(DivInfo,"^",12),$p(DivInfo,"^",13),
	$p(DivInfo,"^",14),$p(DivInfo,"^",15),$p(DivInfo,"^",16),$p(DivInfo,"^",17),$p(DivInfo,"^",18),$p(DivInfo,"^",19),$p(DivInfo,"^",20),
	$p(DivInfo,"^",21),$p(DivInfo,"^",22),$p(DivInfo,"^",23),$p(DivInfo,"^",24),Tsftsbz,Tbie00,$p(DivInfo,"^",27),
	$p(DivInfo,"^",28),$p(DivInfo,"^",29),$p(DivInfo,"^",30),$p(DivInfo,"^",31),$p(DivInfo,"^",32),$p(DivInfo,"^",33),$p(DivInfo,"^",34),
	$p(DivInfo,"^",35),$p(DivInfo,"^",36),$p(DivInfo,"^",37),$p(DivInfo,"^",38),TZstr04,$p(DivInfo,"^",40),$p(DivInfo,"^",41),
	$p(DivInfo,"^",42),$p(DivInfo,"^",43),$p(DivInfo,"^",44),TZstr10,$p(DivInfo,"^",46),$p(DivInfo,"^",47),$p(DivInfo,"^",48),
	$p(DivInfo,"^",49),$p(DivInfo,"^",50),$p(DivInfo,"^",51),TZstr12,TZstr13,$p(DivInfo,"^",54),$p(DivInfo,"^",55),
	$p(DivInfo,"^",56),$p(DivInfo,"^",57),$p(DivInfo,"^",58),$p(DivInfo,"^",59),$p(DivInfo,"^",60),$p(DivInfo,"^",61),$p(DivInfo,"^",62),
	$p(DivInfo,"^",63),$p(DivInfo,"^",64),$p(DivInfo,"^",65),$p(DivInfo,"^",66),$p(DivInfo,"^",67),$p(DivInfo,"^",68),$p(DivInfo,"^",69),
	$p(DivInfo,"^",70),$p(DivInfo,"^",71),
	$p(DivInfo,"^",5),$p(DivInfo,"^",26),$p(DivInfo,"^",52),$p(DivInfo,"^",53),$p(DivInfo,"^",45),$p(DivInfo,"^",25),$p(DivInfo,"^",39)) // 状态,性别,就诊类型, 统筹区,人员类别,医疗类别,医保类型     tangzf 2019-12-9 +
 	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QryOutOfHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutOfHospitalExecute ]
{

	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)

	Quit $$$OK
}

ClassMethod QryOutOfHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutOfHospitalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// creater:kongjian
/// date:2016-11-17
/// in:保存格式串
/// out:成功标志 >0:成功 <0:失败
/// return:Divide表的rowid
/// desc:保存由界面传进来的院外报销的信息
/// 拼串格式:Divide表的rowid(保存时传空,作废时必传)^预留1^预留2^预留3^预留4^结算状态(正常:I,被作废:B,作废:S)^被冲销rowid^总费用^单据号^预留5^预留6^预留7^预留8^预留9^预留10^个人自付^预留11^预留12^身份证号^垫付金额^预留13^用户ID^预留14^预留15^预留16^预留17^预留18^姓名^预留19^预留20^门诊/住院流水号^预留21^预留22^预留23^预留24^预留25^预留26^预留27^预留28^预留29^预留30^预留31^预留32^预留33^预留34^待遇类别^预留35^预留36^预留37^预留38^预留39^医疗类别^就诊类型^地区^预留40^预留41^转诊医院^预留42^预留43^预留44^预留45^预留46^预留47^预留48^预留49^预留50^预留51^预留52^预留53^预留54^预留55^预留56
/// w ##class(web.INSUOutOfHospitalCtl).SaveDivideInfo("IP^11^341222199301255550^许朋^21^2000^500^1500.00^340100^安徽省立医院^1^123456^10086^^I")
ClassMethod SaveDivideInfo(InStr As %String) As %String
{
	q:InStr="" -1
	q:$l(InStr,"^")<70 -2
	
    s Djlsh0=$p(InStr,"^",9)               ;单据号
    q:Djlsh0="" -3
    s ExistFlag=0                          ;校验医保系统结算号是否存在标志 0:不存在,1:存在,2:存在且结算标志为I
    s:$d(^DHCINDIV("0","Djlsh0",Djlsh0)) ExistFlag=1
    i ExistFlag=1 d
    .s DivDr=""
	.f  s DivDr=$o(^DHCINDIV("0","Djlsh0",Djlsh0,DivDr)) q:DivDr=""  d ;取该 医保系统结算号 的divide表的rowid
	..s DivInfo=$g(^DHCINDIV(DivDr))
	..q:DivInfo=""
	..s DivFlag=$p(DivInfo,"^",5)          ;结算标志 I:正常结算,B:被作废,S:作废
	..s:DivFlag="I" ExistFlag="2"
	q:ExistFlag="2" -4                     ;若divide表中存在该医保系统结算号且结算标志为I则退出不保存
	s $p(InStr,"^",13)=$p(InStr,"^",19)    ;INPAYcardno暂存身份证号
    s $p(InStr,"^",32)=$p(InStr,"^",20)    ;INPAYInsuPay1暂存垫付金额
    
    s RowID=##class(web.DHCINSUDivideCtl).InsertDivInfo(InStr)
    q RowID
}

/// creater:kongjian
/// date:2016-11-18
/// in:更新格式串
/// out:成功标志 >0:成功 <0:失败
/// return:Divide表的rowid
/// desc:冲销保存的院外报销信息，状态改成B，再插一条S
/// 拼串格式:用户ID^单据号^Divide表的Rowid(作废必传)^结算状态(正常:I,被作废:B,作废:S)
/// w ##class(web.INSUOutOfHospitalCtl).StrikeDivideInfo("3^235^881^S")
ClassMethod StrikeDivideInfo(InStr As %String) As %String
{
	q:InStr="" -1
	q:$l(InStr,"^")<4 -2
	
    s Divdr=$p(InStr,"^",3)
    q:Divdr="" -3
    s DivInfo=$g(^DHCINDIV(Divdr))
    q:DivInfo="" -4
    s $p(DivInfo,"^",5)=$p(InStr,"^",4)   ;结算状态
    s $p(DivInfo,"^",6)=$p(InStr,"^",3)   ;被作废Rowid
    s $p(DivInfo,"^",21)=$p(InStr,"^",1)  ;操作员
    q:$p(InStr,"^",2)'=$p(DivInfo,"^",8) -5
    s DivInfo="^"_DivInfo                 ;Rowid
    
    s RowID=##class(web.DHCINSUDivideCtl).StrikeDivide(DivInfo)
    q RowID
}

/*
/// creater:kongjian
/// date:2016-11-18
/// in:更新格式串
/// out:成功标志 >0:成功 <0:失败
/// return:拼好的Divide表每个字段的数据串以^分割
/// desc:将Divide表中的字段以^为分割符拼起来
/// 拼串格式:就诊类型^类别^身份证号^姓名^身份^总费用^垫付金额^个人自付^地区^转诊医院^用户ID^门诊/住院流水号^单据号^DivideRowid(保存传空,作废必传)^结算状态(正常:I,被作废:B,作废:S)
/// w ##class(web.INSUOutOfHospitalCtl).ObjDivideToString("")
ClassMethod ObjDivideToString(InStr As %String) As %String
{
	s Rowid=""
    s AdmDr=""
    s AdmInfoDr=""
    s DHCpblDr=""
    s DhcInvPrtDr=""
    s Flag=$p(InStr,"^",15) ;结算状态(正常:I,被作废:B,作废:S)
    s INSUDivideDr=$p(InStr,"^",14) ;DivideRowid(保存传空,作废必传)
    s bcbxf0=$p(InStr,"^",6) ;总费用
    s djlsh0=$p(InStr,"^",13) ;单据号
    s bckbcs=""
    s bqbm00=""
    s brnl00=""
    s cardno=$p(InStr,"^",3) ;身份证号
    s cfxms0=""
    s crbcts=""
    s grzfe0=$p(InStr,"^",8) ;个人自付
    s iDate=""
    s iTime=""
    s id0000=$p(InStr,"^",3) ;身份证号
    s jjzfe0=$p(InStr,"^",7) ;垫付金额
    s ptbcts=""
    s sUserDr=$p(InStr,"^",11) ;录入人
    s sfrq00=""
    s sfrxm0=""
    s sfsj00=""
    s sftsbz=""
    s xbie00=""
    s xming0=$p(InStr,"^",4) ;姓名
    s zhzfe0=0.00
    s zyksmc=""
    s zylsh0=$p(InStr,"^",12) ;门诊/住院流水号
    s InsuPay1=$p(InStr,"^",7) ;垫付金额
    s InsuPay2=0.00
    s InsuPay3=0.00
    s InsuPay4=0.00
    s InsuPay5=0.00

    s Zstr01="W"
    s Zstr02="F"
    s Zstr03="JNB"
    s Zstr04=""
    s Zstr05=""
    s Zstr06=""
    s Zstr07=""
    s Zstr08=""
    s Zstr09=""
    s Zstr10=$p(InStr,"^",2) ;待遇类别
    s InsuPay6=0.00
    s InsuPay7=0.00
    s InsuPay8=0.00
    s InsuPay9=0.00
    s InsuPay10=0.00
    s Zstr11=$p(InStr,"^",5) ;医疗类别
    s Zstr12=$p(InStr,"^",1) ;就诊类型
    s Zstr13=$p(InStr,"^",9) ;地区
    s Zstr14=""
    s Zstr15=""
    s Zstr16=$p(InStr,"^",10) ;转诊医院
    s Zstr17=""
    s Zstr18=""
    s Zstr19=""
    s Zstr20=""
    s Zstr21=""
    s Zstr22=""
    s Zstr23=""
    s Zstr24=""
    s Zstr25=""
    s Zstr26=""
    s Zstr27=""
    s Zstr28=""
    s Zstr29=""
    s Zstr30=""
    s Zstr31=""
    
    s DivObjToStr=Rowid_"^"_AdmDr_"^"_AdmInfoDr_"^"_DHCpblDr_"^"_DhcInvPrtDr
    s DivObjToStr=DivObjToStr_"^"_Flag _"^"_INSUDivideDr_"^"_bcbxf0_"^"_djlsh0_"^"_bckbcs
    s DivObjToStr=DivObjToStr_"^"_bqbm00_"^"_brnl00_"^"_cardno_"^"_cfxms0_"^"_crbcts
    s DivObjToStr=DivObjToStr_"^"_ grzfe0_"^"_iDate _"^"_iTime_"^"_id0000_"^"_jjzfe0
    s DivObjToStr=DivObjToStr_"^"_ptbcts_"^"_sUserDr_"^"_sfrq00_"^"_sfrxm0_"^"_sfsj00
    s DivObjToStr=DivObjToStr_"^"_sftsbz_"^"_xbie00_"^"_xming0_"^"_zhzfe0_"^"_zyksmc
    s DivObjToStr=DivObjToStr_"^"_zylsh0_"^"_InsuPay1_"^"_InsuPay2_"^"_InsuPay3_"^"_InsuPay4
    s DivObjToStr=DivObjToStr_"^"_InsuPay5_"^"_Zstr01_"^"_Zstr02_"^"_Zstr03_"^"_Zstr04
    s DivObjToStr=DivObjToStr_"^"_Zstr05_"^"_Zstr06_"^"_Zstr07_"^"_Zstr08_"^"_Zstr09
    s DivObjToStr=DivObjToStr_"^"_Zstr10_"^"_InsuPay6_"^"_InsuPay7_"^"_InsuPay8_"^"_InsuPay9
    s DivObjToStr=DivObjToStr_"^"_InsuPay10_"^"_Zstr11_"^"_Zstr12_"^"_Zstr13_"^"_Zstr14
    s DivObjToStr=DivObjToStr_"^"_Zstr15_"^"_Zstr16_"^"_Zstr17_"^"_Zstr18_"^"_Zstr19
    s DivObjToStr=DivObjToStr_"^"_Zstr20_"^"_Zstr21_"^"_Zstr22_"^"_Zstr23_"^"_Zstr24
    s DivObjToStr=DivObjToStr_"^"_Zstr25_"^"_Zstr26_"^"_Zstr27_"^"_Zstr28_"^"_Zstr29
    s DivObjToStr=DivObjToStr_"^"_Zstr30_"^"_Zstr31

	q DivObjToStr
}
*/
/// Modify : tangzf
/// ModifyDate : 2019-09-03
/// Descript:根据日期操作员生成流水号
/// Input:	
/// 		Zstr12 : 就诊类别 OP/IP
/// 		User : 操作员
/// Output: 
/// Return: 流水号
/// DeBug: w ##class(web.INSUOutOfHospitalCtl).Buildzylsh0ByDateUser()
ClassMethod Buildzylsh0ByDateUser(Zstr12, User) As %String
{
	quit:(Zstr12="")||(User)="" ""
	set CurDate=$tr($zd(+$h,3),"-","")
	set CurTime=$tr($zt($p($h,",",2)),":","")
	set rtn=Zstr12_CurDate_CurTime_User
	quit rtn
}

/// Modify : tangzf
/// ModifyDate : 2019-09-03
/// Descript:保存divide信息
/// Input:	
/// 		Input : insudivide  xml 串
/// Output: 
/// Return: 0 : 成功，-100 : 失败
/// DeBug: w ##class(web.INSUOutOfHospitalCtl).Buildzylsh0ByDateUser()
ClassMethod SaveDivInfo(Input)
{
	s InputStr=$tr(Input," ","")
	s InputStr=$tr(Input,$C(0),"")
	s ^CacheTemp("SaveLocalInfo")=Input
	set tmpObj=##class(User.INSUDivide).%New()
	set tmpObj=##class(web.INSUCacheXML).Deserialize(.tmpObj,"root",InputStr)
	s Djlsh0=tmpObj.INPAYdjlsh0               ;单据号
    q:Djlsh0="" -3_"^"_"单据号不能为空"
    s ExistFlag=0                          ;校验医保系统结算号是否存在标志 0:不存在,1:存在,2:存在且结算标志为I
    ;s:$d(^DHCINDIV("0","Djlsh0",Djlsh0)) ExistFlag=1
    ;i ExistFlag=1 d
    s DivDr=""
	f  s DivDr=$o(^DHCINDIV("0","Djlsh0",Djlsh0,DivDr)) q:DivDr=""  d ;取该 医保系统结算号 的divide表的rowid
	.s DivInfo=$g(^DHCINDIV(DivDr))
	.q:tmpObj.INPAYHospDr'=$p(DivInfo,"^",71) 
	.q:DivInfo=""
	.s DivFlag=$p(DivInfo,"^",5)          ;结算标志 I:正常结算,B:被作废,S:作废
	.s:DivFlag="I" ExistFlag="2"
	q:ExistFlag="2" -4_"^"_"系统中已经存在此医保系统结算号:"_Djlsh0_",请查证后再录入"                     ;若divide表中存在该医保系统结算号且结算标志为I则退出不保存
	s tmpObj.INPAYZstr01="W"   
	s tmpObj.INPAYiDate=$p($h,",",1) //$p(InStr,"^",17) //操作日期      
	s tmpObj.INPAYiTime=$p($h,",",2) //$p(InStr,"^",18) //操作时间 
	s err=tmpObj.%Save()
    if $$$ISERR(err){
		Quit "-100^"_$SYSTEM.Status.GetErrorText(err)
	}else{
		Quit "0"
	}
}

}
