Import SQLUser

Class web.INSUBase Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 171;

/// ;开始一个事务
ClassMethod BeginTran()
{
     
  Tstart
  q
}

/// ;提交事务
ClassMethod Commit()
{
   TCommit
   q
}

/// ;事务回滚
ClassMethod RollBack()
{
   TRo
   q
}

/// 	    ;服务器时间
ClassMethod GetSysDate() As %String
{
   n
   s aa=$h
   s date=$Zd($h,3)
   s time=$Zt($P($h,",",2),1)
   q date_"^"_time
}

/// Zhan20140106
/// 根据就诊号取病人的所有账单号串
/// 返回格式:账单号^账单状态$账单号^账单状态
ClassMethod GetBillListByAdm(ADMDr As %String) As %String
{
 n (ADMDr)
 s Bill=""
 s StrBill=""
 q:ADMDr="" ""
 q:$d(^DHCPB(0,"ADM",ADMDr))=0 -100
 f  s Bill=$o(^DHCPB(0,"ADM",ADMDr,Bill)) q:Bill=""  d
 .q:$d(^DHCPB(Bill))=0
 .s PayedFlag=$p(^DHCPB(Bill),"^",16)
 .s:StrBill'="" StrBill=StrBill_"$"_Bill_"^"_PayedFlag
 .s:StrBill="" StrBill=Bill_"^"_PayedFlag
 q StrBill
}

/// 按照PatientNo查询
ClassMethod QueryPAPMI(PatientNo As %String) As %String
{
	n (PatientNo)
	s PatientNo=$ZCVT(PatientNo,"U")
	s PatId=""
	q:(PatientNo="") PatId
	q:($d(^PAPERi("PAPMI_PatNo",PatientNo))=0) PatId
	s PatId=$o(^PAPERi("PAPMI_PatNo",PatientNo,PatId))
	q PatId
}

/// 按照PatId查询就诊记录
ClassMethod QueryAdmByPatId(PatId As %String) As %String
{
	;^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	n (PatId)
	k CACHETEMP("INSUADM",$j)
	s i=0
	q:($d(^PAPERdr(PatId,"ADM","I"))=0) i-1
	s admRowid="0"
	f  s admRowid=$o(^PAPERdr(PatId,"ADM","I",admRowid)) q:admRowid=""  d
	.s CACHETEMP("INSUADM",$j,i)=$g(admRowid)
	.s i=i+1
	q i-1
}

/// 取就诊信息
ClassMethod GetAdmInfo(index As %String) As %String
{
	n (index)
	s outString=""
	s admRowid=$g(CACHETEMP("INSUADM",$j,index))
	s outString=admRowid
	;;;;;;
	q outString
}

ClassMethod Test(index As %String)
{
	q 100
}

/// 返回病人的就诊号
ClassMethod GetPaAdmNO(PapmiNo) As %String
{
     ;n (PapmiNo)   ///病人住院号
     q:PapmiNo="" ""
     s outstr=""
     s PatmasID="0"
     s PaadmRowID="0"
     q:$d(^PAPERi("PAPMI_PatNo",PapmiNo))=0 outstr
     s PatmasID=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PatmasID)) 
     f  s PaadmRowID=$o(^PAPERdr(PatmasID,"ADM","I",PaadmRowID)) q:PaadmRowID=""  d
     .s DepNameId=$P(^PAADM(PaadmRowID),"^",4)
     .s outstr=$p($g(^PAADM(PaadmRowID)),"^",81)_"!"_PaadmRowID_"!"_$p(^PAPER(PatmasID,"ALL"),"^",1)_"!"_$p(^CTLOC(DepNameId),"^",2)_"!"_$ZD($p(^PAADM(PaadmRowID),"^",6),3)_"^"_outstr
     s outstr=""_"^"_outstr
     q outstr
}

/// 返回病人的就诊信息
ClassMethod GetPaAdmInfo(PaadmRowID) As %String
{
	s outstr=""
	s RtnCode="0"        ;正常返回
	s RowCnt="0"         ;是否查询到数据
	s PaName="",AdmDate="",AdmTime="",DepName="",DepNameId="",PaSex=""
	s mCurrRowAdm=$g(^PAADM(PaadmRowID))
	if mCurrRowAdm'=""  do
	.s RowCnt="1"
	.s PaMasID=$P(mCurrRowAdm,"^",1)
	.s DepNameId=$P(mCurrRowAdm,"^",4)
	.s mCurrRowPaMas=$g(^PAPER(PaMasID,"ALL"))
	.s PaName=$p(mCurrRowPaMas,"^",1)
	.s PaSex=$p(mCurrRowPaMas,"^",7)
	.s PaSex=$p($g(^CT("SEX",PaSex)),"^",2)
	.s AdmDate=$ZD($p(mCurrRowAdm,"^",6),3)
	.s AdmTime=$ZTime($p(mCurrRowAdm,"^",7),2)
	.s mCurrRowCTLOC=$g(^CTLOC(DepNameId))
	.if mCurrRowCTLOC'=""  do
	..s DepName=$p(^CTLOC(DepNameId),"^",2)
	s outstr=RtnCode_"^"_RowCnt_"^"_PaName_"^"_AdmDate_"^"_AdmTime_"^"_DepName_"^"_PaSex
	q outstr
}

ClassMethod GetPaPamasInfo(PapmiNo As %String) As %String
{
	q:PapmiNo="" ""
    s outstr=""
    s PatmasID="0"
    //--------登记号补零，不用循环,詹明超 20120717---------------->
    s PapmiNo="0000000000"_PapmiNo
    s PapmiNo=$EXTRACT(PapmiNo,*-9,*)
    w PapmiNo,!
    //<--------------------------------------------------//
    q:$d(^PAPERi("PAPMI_PatNo",PapmiNo))=0 outstr
    s PatmasID=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PatmasID)) 
	s PaName=$p(^PAPER(PatmasID,"ALL"),"^",1)
	s PaSex=$p(^PAPER(PatmasID,"ALL"),"^",7)
	s PaSex=$p($g(^CT("SEX",PaSex)),"^",2)
	s Dob=$p(^PAPER(PatmasID,"ALL"),"^",6)
	s PatID=$p(^PAPER(PatmasID,"PAT",3),"^",6)
	s PaIdcard=$p(^PAPER(PatmasID,"ALL"),"^",20)
	s Age=..CalAge(Dob,$h)
	s outstr=PatmasID_"^"_PapmiNo_"^"_PaName_"^"_PaSex_"^"_Age_"^"_PaIdcard_"^"_PatID
	q outstr
}

/// 检查该就诊是否有费用
ClassMethod CheckBill(admRowid As %String, user As %String) As %String
{
	n (admRowid,user)
	;s err=##class(web.DHCJFBILL).BILL(admRowid,user)
	s err=##class(web.UDHCJFBILL).BILL(admRowid,user)	
	q:$d(^DHCPB(0,"ADM",admRowid))=0 0
	s id=$o(^DHCPB(0,"ADM",admRowid,""))	
	s s=$g(^DHCPB(id))	
	q:+$p(s,"^",8)>0 -1
	q 0
}

/// 计算年龄
ClassMethod CalAge(IBirth, IToday) As %String
{
	    ; pass in date of birth in internal format
        ;
        n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
        ;
        s IBirth=$g(IBirth),IToday=$g(IToday)
        ;hack of date of birth
        i IBirth>2980000 s IBirth=""
        i IBirth<0 s IBirth=""
        q:'$G(IBirth) ""
        ;
        s XBirth=$ZD(IBirth)
        s XToday=$ZD(IToday)
        s AgeMth=XToday-XBirth
        s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
        s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
        s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
        s AgeYear=CurrYear-BirthYear
        ;
        i AgeDay<0 d
        . s AgeMth=AgeMth-1
        . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
        . q:XToday'=2
        . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
        i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
        ;
        s $P(AgeYr,"|",12)=AgeYear
        q AgeYear
        ;s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
        ;q AgeYr_"|"_AgeMth_"|"_AgeDay
        ;q AgeYear
}

ClassMethod GetServerSetting(inst) As %String
{
	;q 100
	;s rSetting=""
	&sql(select LayoutManager into :rSetting from websys.Configuration)
	q rSetting
	
	;&sql(select pathtoreports into :reportPath from websys.configuration)
	;q reportPath
}

ClassMethod GetUserStr(UserId) As %String
{
	n (UserId)
	q:$d(^SSU("SSUSR",UserId))=0 -100
	s OutStr=$g(^SSU("SSUSR",UserId))	
	;w $p(OutStr,"^",2),!
	q OutStr
}

ClassMethod QueryDicData(Type, Code) As %String
{
	n (Type,Code)	
	s OutStr=$$QueryByCode^DHCINSUDicData(Type,Code)	
	s QueryDicData=OutStr
	q QueryDicData
}

/// w ##class(web.INSUBase).QueryDicDataByType("AAC004")
ClassMethod QueryDicDataByType(DicType) As %String
{
	n (DicType)	
	q:DicType="" ""
	s i=0,id=""
	s DicCode=""
	q:'$d(^DHCINDID("0","ITypeCode",DicType)) "" 
	s DicCode=$o(^DHCINDID("0","ITypeCode",DicType,DicCode))
	q:'$d(^DHCINDID("0","ITypeCode",DicType,DicCode)) ""
	s id=$o(^DHCINDID("0","ITypeCode",DicType,DicCode,id))
	s s=$g(^DHCINDID(id))
	s DicType=$p(s,"^",1)
	s DicCode=$p(s,"^",2)
	s DicDesc=$p(s,"^",3)
	s DicBill1=$p(s,"^",4)
	s DicBill2=$p(s,"^",5)
	s DicDemo=$p(s,"^",6) 
	s s=id_"^"_DicType_"^"_DicCode_"^"_DicDesc_"^"_DicDemo_"^"_DicBill1_"^"_DicBill2
	s OutStr=s	
	s QueryDicData=OutStr
	q QueryDicData
}

/// add liusf 2010 07 15 modefy by zhangdongliang 
/// 取系统日期和时间
/// w ##class(web.INSUBase).GetSysDateTime()
ClassMethod GetSysDateTime() As %String
{
	;;$ZDate,$ZDateTime,$ZDateH,$ZTime,$ZTimeH
	;s StrDate=$zd(+$h,1)	;03/14/2011
	;w StrDate,!
	;s StrDate=$zd(+$h,2)	;14 Mar 2011
	;w StrDate,!
	;s StrDate=$zd(+$h,3)	;2011-03-14
	;w StrDate,!
	;s StrDate=$zd(+$h,4)	;14/03/2011
	;w StrDate,!
	;s StrDate=$zd(+$h,5)	;Mar 14, 2011
	;w StrDate,!
	;s StrDate=$zd(+$h,6)	;Mar 14 2011
	;w StrDate,!
	;s StrDate=$zd(+$h,7)	;Mar 14 2011
	;w StrDate,!
	;s StrDate=$zd(+$h,8)	;20110314
	;w StrDate,!
	;s StrDate=$zd(+$h,9)	;March 14, 2011
	;w StrDate,!
	;s StrDate=$zd(+$h,10)	;1
	;w StrDate,!
	;s StrDate=$zd(+$h,11)	;Mon
	;w StrDate,!
	;s StrDate=$zd(+$h,12)	;Monday
	;w StrDate,!

	;s StrTime=$zt($p($h,",",2),1)		;10:54:12
	;w StrTime,!
	;s StrTime=$zt($p($h,",",2),2)		;10:54
	;w StrTime,!
	;s StrTime=$zt($p($h,",",2),3)		;10:54:33AM
	;w StrTime,!
	;s StrTime=$zt($p($h,",",2),4)		;10:54AM
	;w StrTime,!

	;s StrDateTime=$zdt($h,1)	;03/14/2011 10:56:15
	;w StrDateTime,!
	;s StrDateTime=$zdt($h,2)	;14 Mar 2011 10:57:26
	;w StrDateTime,!
	;s StrDateTime=$zdt($h,3)	;2011-03-14 10:57:39
	;w StrDateTime,!
	;s StrDateTime=$zdt($h,4)	;14/03/2011 10:57:47
	;w StrDateTime,!
	;下面的方式
	s StrDate=$tr($zd($p($h,",",1),3),"-","")
	s StrTime=$tr($zt($p($h,",",2),1),":","")		;变成数字形式
	s GetSysDateTime=StrDate_"^"_StrTime
	q GetSysDateTime
}

ClassMethod getpath() As %String
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

/// Creator：      DingSH
/// CreatDate：    20200628
/// Description:： 清除医保字典对照数据      
/// Others：项目初期清理基础数据
/// w ##class(web.INSUBase).killBaseDicData()
ClassMethod killBaseDicData()
{
	
 s ConDicData="LocCodeCon^DosageCon^FeeTypeCon^UserCodeCon^AKC195Con^CourseCon^QrequencyCon" 
 s id = ""
 f{
	 s id=$O(^DHCINDID(0,"IType","DLLType",id))
	 q:id=""
	 s InsuType=$P(^DHCINDID(id),"^",2)
	 s Cnt=$l(ConDicData,"^")
	 f i = 1:1:Cnt
	 {
		 s dicType = $P(ConDicData,"^",i)_""_InsuType
		 &sql(delete from INSU_DicData where INDID_DicType =:dicType )
	 }
	
	 }
	 q 1
}

/// Creator：      ZhanMingChao
/// CreatDate：    20180402
/// Description:： 清除医保基础数据      
/// Others：项目初期清理基础数据
/// 			d ##class(web.INSUBase).killINSUBaseData()
ClassMethod killINSUBaseData() As %String
{
	//1、医保目录表
	k ^DHCINTIM
	s ^mdata("INSUTARITEMS")=1
	//2、医保目录对照表
	k ^DHCINTCT
	s ^mdata("INSUTARCONTRAST")=1
	//3、医保诊断表
	k ^DHCINDiagnos
	s ^mdata("INSUDIAGNOSIS")=1
	//4、医保诊断对照表
	k ^DHCINICT
	s ^mdata("INSUICDCONTRAST")=1
	//5、医保特殊项目对照表
	k ^DHCITCT
	s ^mdata("DHCINSUTARCONTAR")=1
	//6、本地人员名单表及子表
	k ^DHCINLOC
	s ^mdata("DHCINLEAD")=1
	
	//7、医保科室信息表
	k ^DHCINLCI
	s ^mdata("INSULOCINFO")=1
		
	//8、医保科室上传记录表
	k ^DHCINLCR
	s ^mdata("INSULOCREC")=1
	
	//9、医保医师信息表
	k ^DHCINCPI
	s ^mdata("INSUCAREPROVINFO")=1
		
	//10、医保医师上传记录表
	k ^DHCINCPR
	s ^mdata("INSUCAREPROVREC")=1
	
	//11、医保目录下载表
	&sql(delete from InsuTaritemsDL)
	
	//12、医保诊疗信息配置表
	&sql(delete from INSUUploadInfoCon)
	
	//13 医保字典对照信息
	d ..killBaseDicData()
	
	//14、医保控费基础表清数据
	s rtn= ##class(insuqc.service.ServicePort).ClearChronicData()


	//手术对照
	k ^User.INSUOPERContrastD
	k ^User.INSUOPERContrastI
	
	
	//User.InsuTaritemsDL 医保目录下载表
    k ^User.InsuTaritemsDLD
    k ^User.InsuTaritemsDLI
    
	//1301 西药中成药目录表 CT.INSU.MI.WMTCMPATLIST
	k ^T.INSU.MI.WMTCMPATLISTD
	k ^T.INSU.MI.WMTCMPATLISTI
	//1302 中药饮片目录表 CT.INSU.MI.TMDPLIST
	k ^CT.INSU.MI.TMDPLISTD
	k ^CT.INSU.MI.TMDPLISTI
	//1303 医疗机构制剂目录下载 CT.INSU.MI.MEDINSPREPLIST
	k ^CT.INSU.MI.MEDINSPREPLISTD
	k ^CT.INSU.MI.MEDINSPREPLISTI
	//1304 民族药品目录下载 CT.INSU.MI.NATYDRUGLIST
	k ^CT.INSU.MI.NATYDRUGLISTD
	k ^CT.INSU.MI.NATYDRUGLISTI
	//1305 医疗服务项目目录下载 CT.INSU.MI.MEDSERVITEMLIST
	k ^CT.INSU.MI.MEDSERVITEMLISTD
	k ^CT.INSU.MI.MEDSERVITEMLISTI
	//1306 医用耗材目录下载 CT.INSU.MI.MEDMCSLIST
	k ^CT.INSU.MI.MEDMCSLISTD
	k ^CT.INSU.MI.MEDMCSLISTI
    //1307 疾病与诊断目录下载 CT.INSU.MI.DISEDIAGLIST
    k ^CT.INSU.MI.DISEDIAGLISTD
	k ^CT.INSU.MI.DISEDIAGLISTI
    //1308 手术操作目录下载 CT.INSU.MI.OPRNOPRTLIST
    k ^CT.INSU.MI.OPRNOPRTLISTD
	k ^CT.INSU.MI.OPRNOPRTLISTI
    //1309 门诊慢特病病种目录 CT.INSU.MI.FIXMEDINSOTPCRDS
    k ^CT.INSU.MI.FIXMEDINSOTPCRDSD
	k ^CT.INSU.MI.FIXMEDINSOTPCRDSI
    //1310 按病种付费病种目录 CT.INSU.MI.DISESETLLIST
    k ^CT.INSU.MI.DISESETLLISTD
	k ^CT.INSU.MI.DISESETLLISTI
    //1311 日间手术治疗病种目录 CT.INSU.MI.DAYSRGTRTLIST
    k ^CT.INSU.MI.DAYSRGTRTLISTD
	k ^CT.INSU.MI.DAYSRGTRTLISTI
    //1312 医保目录信息查询 CT.INSU.MI.HIINFOLIST
    k ^CT.INSU.MI.HIINFOLISTD
	k ^CT.INSU.MI.HIINFOLISTI
    //1313	肿瘤形态学目录下载 CT.INSU.MI.TMORMPY 
    k ^T.INSU.MI.TMORMPYD
	k ^T.INSU.MI.TMORMPYI
    //1314	中医疾病目录下载 CT.INSU.MI.TCMDIAG
    k ^CT.INSU.MI.TCMDIAGD
	k ^CT.INSU.MI.TCMDIAGI
    //1315	中医证候目录下载 CT.INSU.MI.TCMSYMPTYPE 
    k ^CT.INSU.MI.TCMSYMPTYPED
	k ^CT.INSU.MI.TCMSYMPTYPEI
    //1316	医疗目录与医保目录匹配信息查询 CT.INSU.MI.MEDLISTHILISTMAP
    k ^CT.INSU.MI.MEDLISTHILISTMAPD
	k ^CT.INSU.MI.MEDLISTHILISTMAPI
    //1317	医药机构目录匹配信息表 CT.INSU.MI.MEDINSLISTMAP
    k ^CT.INSU.MI.MEDINSLISTMAPD
	k ^CT.INSU.MI.MEDINSLISTMAPI   
    //1318 医保目录限价信息查询 CT.INSU.MI.HILISTLMTPRIC
    k ^CT.INSU.MI.HILISTLMTPRICD
	k ^CT.INSU.MI.HILISTLMTPRICI 
   //1319	医保目录先自付比例信息下载 CT.INSU.MI.HILISTSELFPAYPROP 
    k ^CT.INSU.MI.HILISTSELFPAYPROPD
	k ^CT.INSU.MI.HILISTSELFPAYPROPI
    
   
	q "1"
}

/// Creator：      ZhanMingChao
/// CreatDate：    20180402
/// Description:： 清除医保业务数据      
/// Others：项目上线前清理医保业务数据
/// 			d ##class(web.INSUBase).killINSUBusinessData()
ClassMethod killINSUBusinessData() As %String
{
	//1、医保登记表
	k ^DHCINADM
	s ^mdata("INSUADMINFO")=1
	//2、医保结算表
	k ^DHCINDIV
	s ^mdata("INSUDIVIDE")=1
	//3、医保结算子表
	k ^DHCINDIS
	s ^mdata("INSUDIVIDESUB")=1
	//4、医保预结算表
	k ^DHCINDIVPre
	s ^mdata("INSUDIVIDEPRE")=1
	//5、医保结算明细分类
	k ^DHCINDISIC
	s ^mdata("INSUDIVIDESUBINSUCAT")=1
	//6、医保审报
	k ^INSUPRT
	s ^mdata("INSUREPORT")=1
	//7、转诊记录表
	k ^DHCINREFER
	s ^mdata("INSUREFERRALINFO")=1
	//8、医保对账表
	k ^DHCINBAL
	s ^mdata("INSUBALANCE")=1
	//9、医保对账记录表
	k ^DHCINBLL
	s ^mdata("INSUBLL")=1
	//10、医保医嘱审核表
	k ^DHCINAUD
	s ^mdata("INSUAUDIT")=1
	//11、医保错误日志表
	k ^DHCINMSG
	k ^DHCINMSGi
	s ^MDATA("^DHCINMSG")=1
	//12、医保月对账总表
	k ^DHCINSUBalanceMon
	s ^mdata("INSUBALANCEMON")=1
	//13、医保日对账表
	k ^DHCINSUBalanceDay
	s ^mdata("INSUBALANCEDAY")=1
	//14、医保结算流水表
	k ^DHCINSUMedicalSub
	s ^mdata("INSUMEDICALSUB")=1
	//15、医保中心结算流水表
	k ^DHCINSUCenterSub
	s ^mdata("INSUCENTERSUB")=1
	//16、医保对账差异明细表
	k ^DHCINSUBalanceUnusual
	s ^mdata("INSUBALANCEUNUSUAL")=1
	//17、医保业务交易记录表
	k ^DHCTransaction
	s ^MDATA("^DHCTransaction")=1
	//18、医保用户签到表
	k ^DHCINSUSSGN
	s ^mdata("INSUSSUSERSGN")=1
   //19、医保分类明细 +20211115 
    k ^DHCINDIVS
    k ^mdata("INSUDIVIDESUBCATE")
   //20、人员外伤备案登记 +20211115 
    k ^INSU.MI.TrumChkRegD
    k ^INSU.MI.TrumChkRegI
   //21、人员外定点案登记 +20211115 
    k ^INSU.MI.PsnFixRegD
    k ^INSU.MI.PsnFixRegI
	//INSU.MI.HisDivInfo 医保结算流水表 +20211115 
	 k ^INSU.MI.HisDivInfoD
	 k ^INSU.MI.HisDivInfoI
	//INSU.MI.DivSum  医保清算对账总表 +20211115 
	k ^INSU.MI.DivSumD
	k ^INSU.MI.DivSumI
	//INSU.MI.DivDet   医保清算申请流水表 +20211115 
	k ^INSU.MI.DivDetD
	k ^INSU.MI.DivDetI
	//INSU.MI.CenterDivInfo 医保中心结算流水表 +20211115 
	k ^INSU.MI.CenterDivInfoD
	k ^INSU.MI.CenterDivInfoI
	//INSU.MI.Unusual 医保对账差异明细表 +20211115 
	k ^INSU.MI.UnusualD
	k ^INSU.MI.UnusualI
	//INSU.MI.TrnsLog 交易日志交易表 +20211115 
	k ^INSU.MI.TrnsLogD
	k ^INSU.MI.TrnsLogI
	//INSU.MI.RevsTrnsLog 冲正交易日志表 +20211115 
	k ^INSU.MI.RevsTrnsLogD
	k ^INSU.MI.RevsTrnsLogI
	//INSU.MI.TrumChkReg 人员外伤备案表 +20211115 
	k ^INSU.MI.TrumChkRegD
	k ^INSU.MI.TrumChkRegI
	
	//User.INSUEprUl 病案上传信息主表 +20211115 
	k ^DHCINEUL
	k ^DHCINEULi
	s ^mdata("INSUEPRUL")=1
	//User.INSUDataUL 数据上传信息主表 +20211115 
	k ^DHCINDUL
	k ^DHCINDULi
	//User.INSUDataPortList 医保数据上传接口表 +20211115 
	k ^DHCINDPL 
	k ^DHCINDPLi
	
	//生命周期表 CF.INSU.MI.DataLog   20211125
    k ^CF.INSU.MI.DataLogD
    k ^CF.INSU.MI.DataLogI
	
	q "1"
}

/// Creator：      DingSH
/// CreatDate：    20211115 
/// Description:： 清除医保配置数据      
/// Others：项目上线前清医保配置数据
/// 			d ##class(web.INSUBase).KillINSUCfgData()
ClassMethod KillINSUCfgData() As %String
{
	
	q "1"  //勿动暂时不用清除 20211115 
	
	//接口注册表 CF.INSU.MI.Abbreviations
    k ^CF.INSU.MI.AbbreviationsD
    k ^CF.INSU.MI.AbbreviationsI
    
    //接口类方法维护 CF.INSU.MI.ClassMethod
    k ^CF.INSU.MI.ClassMethodD
    k ^CF.INSU.MI.ClassMethodI
    
    //接口类方法参数维护 CF.INSU.MI.ClassMethodArgs 
    k ^CF.INSU.MI.ClassMethodArgsD
    k ^CF.INSU.MI.ClassMethodArgsI
    //数据日志表 CF.INSU.MI.DataLog   
    k ^CF.INSU.MI.DataLogD
    k ^CF.INSU.MI.DataLogI
    
    //数据元字典表 CF.INSU.MI.PortArgsDic
    k ^CF.INSU.MI.PortArgsDicD
    k ^CF.INSU.MI.PortArgsDicI
    //国家医保平台接口公共参数配置 CF.INSU.MI.PortCommon
    k ^CF.INSU.MI.PortCommonD
    k ^CF.INSU.MI.PortCommonI
    //国家医保平台接口清单参数表 CF.INSU.MI.PortFunArgsList
    k ^CF.INSU.MI.PortFunArgsListD
    k ^CF.INSU.MI.PortFunArgsListI
    //接口清单维护 CF.INSU.MI.PortFunList
    k ^CF.INSU.MI.PortFunListD
    k ^CF.INSU.MI.PortFunListI
    //国家医保接口入参配置表 CF.INSU.MI.PortInArgs
    k ^CF.INSU.MI.PortInArgsD
    k ^CF.INSU.MI.PortInArgsI
    //国家医保平台接口配置表 CF.INSU.MI.PortList
    k ^CF.INSU.MI.PortListD
    k ^CF.INSU.MI.PortListI
    //国家医保接口参数节点配置表 CF.INSU.MI.PortNode
    k ^CF.INSU.MI.PortNodeD
    k ^CF.INSU.MI.PortNodeI
    //国家医保平台接口根节点配置 CF.INSU.MI.PortRoot 
    k ^CF.INSU.MI.PortRootD
    k ^CF.INSU.MI.PortRootI
}

}
