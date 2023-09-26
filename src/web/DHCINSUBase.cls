Import SQLUser

Class web.DHCINSUBase Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 180;

/// ;开始一个事务
ClassMethod DHCINSUExport()
{
     
  W ##CLASS(web.Util.UtilService).ExportMacforSVN("DHCINSU*.MAC","DHC-APP","c:\DHCINSU\Cache\M\")
  W ##CLASS(web.Util.UtilService).ExportMacforSVN("DHCINSU*.MAC","DHC-APP","c:\DHCINSU\Cache\M\")
  q
}

/// W ##CLASS(web.Util.UtilService).ExportMacforSVN
ClassMethod WriteStreamByFile(pathFileName As %String = "") As %FileCharacterStream
{
	s stream = ##class(%Stream.GlobalCharacter).%New()
	d stream.Write("sdafkajsdlfjaksdjfjasldfjq  rjsdfklajsdfjajsdfasjdfjaksdf")
	quit stream
}

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

ClassMethod GetPaPamasInfo(PapmiNo) As %String
{
	q:PapmiNo="" ""
    s outstr=""
    s PatmasID="0"
    q:$d(^PAPERi("PAPMI_PatNo",PapmiNo))=0 outstr
    s PatmasID=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PatmasID)) 
	s PaName=$p(^PAPER(PatmasID,"ALL"),"^",1)
	s PaSex=$p(^PAPER(PatmasID,"ALL"),"^",7)
	s PaSex=$p($g(^CT("SEX",PaSex)),"^",2)
	s Dob=$p(^PAPER(PatmasID,"ALL"),"^",6)
	s PaIdcard=$p(^PAPER(PatmasID,"ALL"),"^",20)
	s Age=..CalAge(Dob,$h)
	s outstr=PaName_"^"_PaSex_"^"_Age_"^"_PaIdcard
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
	//w $p(OutStr,"^",2),! //- DingSH 20220613 
	q OutStr
}

ClassMethod QueryDicData(Type, Code) As %String
{
	n (Type,Code)	
	s OutStr=$$QueryByCode^DHCINSUDicData(Type,Code)	
	s QueryDicData=OutStr
	q QueryDicData
}

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

/// w ##class(web.DHCINSUBase).GetCtPaymode("")
ClassMethod GetCtPaymode(SSUerDr) As %String
{
 s OutStr=""
 s RowId=0
 f  s RowId=$o(^CT("CTPM",RowId))   q:RowId=""  d
 .s CTPMStr=$g(^CT("CTPM",RowId))
 .s Code=$p(CTPMStr,"^",1)
 .s Desc=$p(CTPMStr,"^",2)
 .s NotUseFlag=$p(CTPMStr,"^",3)
 .s GrpCode=$p(CTPMStr,"^",4)
 .s DateFrom=$p(CTPMStr,"^",5)
 .s DateTo=$p(CTPMStr,"^",6)
 .s ChangeGiven=$p(CTPMStr,"^",7)
 .i OutStr=""  d
 ..s OutStr=RowId_"^"_Code_"^"_Desc_"^"_NotUseFlag_"^"_GrpCode_"^"_DateFrom_"^"_DateTo_"^"_ChangeGiven
 .e    d
 ..s OutStr=OutStr_"!"_RowId_"^"_Code_"^"_Desc_"^"_NotUseFlag_"^"_GrpCode_"^"_DateFrom_"^"_DateTo_"^"_ChangeGiven
 //s CTPayStr=##class(web.UDHCOPGSConfig).ReadGSPMListBroker1(GrpRowid)
 q OutStr
}

/*
/// 取支付方式
ClassMethod GetCTPayMode090719(SSUserID As %String) As %String
{
	n (SSUserID)
	s OutStr="^^"
	s CTPMRowId=0
	f  s CTPMRowId=$o(^CT("CTPM",CTPMRowId))  q:CTPMRowId=""   d 
	.s Code=$p($g(^CT("CTPM",CTPMRowId)),"^",1)
	.s Desc=$p($g(^CT("CTPM",CTPMRowId)),"^",2)
	.s OutStr=OutStr_"!"_CTPMRowId_"^"_Code_"^"_Desc
	s GetCTPayMode=OutStr
	q GetCTPayMode
}

/// 取支付方式
/// w ##class(web.INSUBase).GetCTPayMode("6076")
ClassMethod GetCTPayMode(SSUserID As %String) As %String
{
	n (SSUserID)
	s OutStr="^^"
	s GrpRowid=$p($g(^SSU("SSUSR",SSUserID)),"^",5)
	q:GrpRowid="" OutStr
    s CTPayStr=##class(web.UDHCOPGSConfig).ReadGSPMListBroker1(GrpRowid)
    i (CTPayStr'="100")&(CTPayStr'="")  d
	.s GetCTPayMode=OutStr_"!"_CTPayStr
	e    d
	.s GetCTPayMode=OutStr
	q GetCTPayMode
}
*/

// w ##class(web.DHCINSUBase).GetCTLoc(1)

ClassMethod GetCTLoc(DepID As %String) As %String
{
	n (DepID)
	q:DepID="" ""
	q $g(^CTLOC(DepID))
}

/// Creator: 郭宁
/// Description:校验用户工号和密码是否正确
/// Input:UserCode：操作员工号,PassWord:操作员密码
/// CreatDate:20150211
/// Output:0_"!"_UserRowid^UserCode^UserName :校验正确返回状态和操作员Dr。非0：校验不正确
/// Others: w ##class(web.DHCINSUBase).CheckUserCodeAndPassWord("insu1","med%(")
/// 移动到web.DHCINSUBase.cls中 20200514
ClassMethod CheckUserCodeAndPassWord(UserCode As %String = "", PassWord As %String = "") As %String
{
 n (UserCode,PassWord)
 s OutStr="-1"
 q:(UserCode="")!(PassWord="") OutStr_"!"_"用户名和密码不能空"
 s rtn=##class(web.SSUser).IsValidUser(UserCode,PassWord) //+DingSH 20220120
 s rtnCode=$P(rtn,"^",1)
 s rtnMsg=$P(rtn,"^",2)
 s rtnMsg=$case($zcvt(rtnMsg,"U"),$zcvt("UserNotFindErr","U"):"用户不存在"
                      ,$zcvt("UnActiveErr","U"):"未激活"
                      ,$zcvt("DateFromScopeErr","U"):"未到用户开启日"
                      ,$zcvt("DateToScopeErr","U"):"用户有效期已过"
                      ,$zcvt("PasswordErr","U"):"用户名或密码错误"
                      ,:rtnMsg)
 q:+rtnCode<=0 OutStr_"!"_rtnMsg
 i rtnCode>0 d
 .s UserRowid=rtnCode
 .s UserCode=$p(^SSU("SSUSR",UserRowid),"^",1)
 .s UserName=$p(^SSU("SSUSR",UserRowid),"^",2)
 s OutStr=0_"!"_UserRowid_"^"_UserCode_"^"_UserName
 q OutStr
 
 /*
 s UserRowid=""
 q:$d(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode)))=0 OutStr_"！"_"不存在该用户"
 s UserRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""),-1)
 s ActiveFlag=$p(^SSU("SSUSR",UserRowid),"^",19)
 s UserName=$p(^SSU("SSUSR",UserRowid),"^",2)
 q:ActiveFlag'="Y" OutStr_"！"_"该用户为无效用户"
 s EnPassWord=$$ENCR^SSUTIL2(PassWord)
 s tPassWord=$p(^SSU("SSUSR",UserRowid),"^",3)
 b ;00
 q "0!"_UserRowid_"^"_UserCode_"^"_UserName
 q:EnPassWord'=tPassWord OutStr_"！"_"密码错误"
 s OutStr=0_"!"_UserRowid_"^"_UserCode_"^"_UserName
 q OuqtStr*/
}

/// Description:获取院区指针
///       Input:
///               ArgVal:参数值 
///              ArgType:参数类型 目前有[AdmDr, BillDr,INVPrtDr,PEPrtDr,JustThread]取值
///               参数类型取值解释
///               AdmDr:Pa_Adm.Rowid   ,  BillDr:DHC_PatientBill.Rowid
///               INVPrtDr:DHC_INVPRT.Rowd  , PEPrtDr:DHC_PE_INVPRT.Rowid
///               INDivDr:INSU_Divide.Rowd  , INAdmDr:INSU_AdmInfo.Rowid
///               JustThread:^DHCTMPACCColPRT("IP",{JustThread}) 进程号(发票集中打印)
///      Return：CTHOSPITAL.Rowid
///      DingSH  20200513
///      Others: 
///      w ##class(web.DHCINSUBase).GetHOSPID("8","AdmDr")
///      w ##class(web.DHCINSUBase).GetHOSPID("67","BillDr")
///      w ##class(web.DHCINSUBase).GetHOSPID("1345","INVPrtDr")
///      w ##class(web.DHCINSUBase).GetHOSPID("12","PEPrtDr")
///      w ##class(web.DHCINSUBase).GetHOSPID("317","InAdmDr")
///      w ##class(web.DHCINSUBase).GetHOSPID("111","InDivDr")
///      w ##class(web.DHCINSUBase).GetHOSPID("14","JustThread")
ClassMethod GetHOSPID(ArgVal As %String = "", ArgType As %String = "") As %String
{
	n (ArgVal,ArgType)
	
	s HospDr = ""
	
	s ArgType=$ZCVT(ArgType,"U")
	
	//1 进程号(发票集中打印)取院区
	i ArgType="JUSTTHREAD" d
	.s ArgVal=..GetACCColFirstPRTDr(ArgVal)
	.s ArgType="INVPRTDR"
	
	//2 帐单Dr取院区
	i (ArgType="BILLDR") d
	.s ArgVal =$P($g(^DHCPB(ArgVal)),"^",1)
	.s ArgType="ADMDR"
	
	//3 医保登记表Dr取院区
	i (ArgType="INADMDR") d
	.s AdmDr =$P($g(^DHCINADM(ArgVal)),"^",1)
	.s:AdmDr="" HospDr=$P($g(^DHCINADM(ArgVal)),"^",51) //+DingSH 20210309 8.4
	.s ArgType="ADMDR"
	.s ArgVal=AdmDr
	
	//4 医保结算表Dr取院区
	i (ArgType="INDIVDR") d
	.;s ArgVal =$P($g(^DHCINDIV(ArgVal)),"^",1)
	.s AdmDr =$P($g(^DHCINDIV(ArgVal)),"^",1)
	.s:AdmDr="" HospDr=$P($g(^DHCINDIV(ArgVal)),"^",71) //+HanZH 20220930
	.s ArgType="ADMDR"
	.s ArgVal=AdmDr
	
	//6 门诊发票表Dr取院区
	i (ArgType="INVPRTDR") d
	.s:+ArgVal>0 HospDr = $P($g(^DHCINVPRT(+ArgVal)),"^",39)
	.i +HospDr=0 d   //20211124
	..s ArgType="ADMDR"
	..s ArgVal=..GetAdmDrByPrtDr(+ArgVal)
	
	//5 就诊Dr取院区
	i (ArgType="ADMDR") d
	.s:ArgVal'="" HospDr = $P($g(^PAADM(ArgVal,2)),"^",85) ;//PAADMHospitalDR
	.i (HospDr ="")&&(ArgVal'="") d
	..s DepCodeDR = ""
	..s DepCodeDR = $P(^PAADM(ArgVal),"^",4)
	..s:DepCodeDR'="" HospDr=$P(^CTLOC(DepCodeDR),"^",22)

	//7 体检发票表Dr取院区
	i (ArgType="PEPRTDR") d
	.s:+ArgVal>0 HospDr =$P($g(^DHCPEINVPRT(+ArgVal)),"^",26)
	
    //8 外院发票Id
	i (ArgType="OUTINVDR") d
	.s:+ArgVal>0 HospDr =$lg($g(^BILL.OUTPAY.InvPrtD(+ArgVal)),25)
	q HospDr
}

/// Description:根据进程号(发票集中打印)获取首个发票表Rowid
///       Input:
///               JustThread: ^DHCTMPACCColPRT("GetTarArcimIP",{JustThread})
///      Return：PrtDr:DHCINVPRT.Rowid
///      DingSH  20200512
///      w ##class(web.DHCINSUBase).GetACCColFirstPRTDr("14")
ClassMethod GetACCColFirstPRTDr(JustThread) As %String [ Private ]
{
	s Flag="N",FirstInvPrtDr=""
	s AdmReasonId=""
	f  s AdmReasonId=$o(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId))     q:(AdmReasonId="")||(Flag="Y")    d
	.s myIdx=""
    .f  s myIdx=$o(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId,myIdx)) q:(myIdx="")||(Flag="Y")   d
    ..s tmpPrtRowID=""
    ..f  s tmpPrtRowID=$o(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId,myIdx,"PrtRowID",tmpPrtRowID)) q:(tmpPrtRowID="")||(Flag="Y")  d
    ...s Flag="Y"
    ...s FirstInvPrtDr=tmpPrtRowID
    q FirstInvPrtDr
}

/// 根据发票RowId获取就就诊表Dr
/// w ##class(web.DHCINSUBase).GetAdmDrByPrtDr(1798289)
/// DingSH 20211124 
ClassMethod GetAdmDrByPrtDr(PrtDr) As %String
{
	q:$g(PrtDr)="" ""
	q:+$d(^DHCBCI(0,"INV",PrtDr))=0 ""
	s DHCBCIRowid="",AdmDr=""
	s DHCBCIRowid=$O(^DHCBCI(0,"INV",PrtDr,DHCBCIRowid))
	i +DHCBCIRowid>0 d
	.s AdmDr=$P(^DHCBCI(DHCBCIRowid),"^",3)
	q AdmDr
}

/// Creator: tangzf
/// CreateDate: 2020-07-03
/// Descript: 查询医保数据生命周期 CF.INSU.MI.DataLog （查询修改的具体字段，必须传入表名）
/// Input:		StartDate : 	开始日期
/// 			EndDate : 	结束日期
/// 			ParamClassName : 	表名
/// 			UserCode : 	操作员ID
/// 			OptType : 	操作类型
/// 			HospId : 	院区 
/// 			ExpStr : 	字典类型||| 
/// 			KeyCode : 	关键字，根据原始数据列和新数据列 模糊检索关键字 +tanfb 2023/4/20
/// Output: 见下 query Data
/// Return: 
/// DeBug: 
/// d ##class(%ResultSet).RunQuery("web.DHCINSUBase","QueryINSUDataCycle","2023-04-22","2023-05-23","User.DHCINVPRTZYPayMode","","","2","","")
Query QueryINSUDataCycle(StartDate, EndDate, ParamClassName, UserCode, OptType, HospId, KeyCode, ExpStr) As websys.Query(ROWSPEC = "DataTableName,DataTableId, DataDicType, DataOptType, DataDate, DataTime, DataUser,DataStr,CompareInfo,NewDataStr,DicDesc") [ SqlProc ]
{
}

ClassMethod QueryINSUDataCycleExecute(ByRef qHandle As %Binary, StartDate, EndDate, ParamClassName, UserCode, OptType, HospId, KeyCode, ExpStr) As %Status
{
	set ^CacheTemp("GetINMSGInfo")=$LB(StartDate, EndDate, ParamClassName, UserCode, OptType, HospId, KeyCode, ExpStr)
	set repid1=$I(^CacheTemp)
	if $g(ind1)="" Set ind1=1
	set qHandle=$lb(0,repid1,0)
	q:$g(ParamClassName)="" $$$OK
	
	set DicType=$p(ExpStr,"|",1)
	set:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	set:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	
	set TranslateStr=##class(web.INSUDicDataCom).GetDicByCodeAndInd("INSUDataCycleConfig",ParamClassName,"7",HospId)
	set TableINSUTypeField=##class(web.INSUDicDataCom).GetDicByCodeAndInd("INSUDataCycleConfig",ParamClassName,"6",HospId) //表中代表医保类型的字段
	set TableFieldNameStr=##class(web.INSUDicDataCom).GetDicByCodeAndInd("INSUDataCycleConfig",ParamClassName,"5",HospId) // 表中各个字段的字段名称 如果建表时建了caption属性可无视该配置
	b //取配置
	//取表的相关信息,主索引,属性描述
	set TableArr="" //属性描述
	set DataMasterGlobal="" //主索引GLOBAL
	set RowidName="" //表的ROWID字段
	set DataINSUType="" //医保类型
	d GetTableInfo 
	for date=StartDate:1:EndDate  d
	.set RowId=""
	.for  set RowId=$o(^CF.INSU.MI.DataLogI("IndexOfTableAndDate",$zcvt(ParamClassName,"U"),date,RowId)) quit:RowId=""  d
	..set Data=^CF.INSU.MI.DataLogD(RowId)
	..set DataTableName=$lg(Data,2)
	..set DataTableId=$lg(Data,3)
	..set DataDicType=$lg(Data,4)
	..quit:(DicType'="")&&(DicType'=DataDicType)
	..quit:(OptType'="")&&(OptType'=$lg(Data,5))
	..q:$lg(Data,5)="SAVE"
	..set DataOptType=$case($lg(Data,5),"UPDATE":"更新","INSERT":"新增","DELETE":"删除",:$lg(Data,5))
	..set DataDate=$lg(Data,6)
	..set DataTime=$lg(Data,7)
	..set:DataDate'="" DataDate=##class(websys.Conversions).DateLogicalToHtml(DataDate)
	..set:DataTime'="" DataTime=##class(websys.Conversions).TimeLogicalToHtml(DataTime)
	..set DataUser=$lg(Data,8)
	..quit:(UserCode'="")&&(UserCode'=DataUser)
	..set DataStr=$lg(Data,9)
	..set NewDataStr=$lg(Data,10)
	..quit:(KeyCode'="")&&(DataStr'[KeyCode)&&(NewDataStr'[KeyCode)
	..set UserDesc=""
	..i DataUser'="" s UserDesc=$p($g(^SSU("SSUSR",DataUser)),"^",2)
	..set CompareInfo=""
	..s DataHospId=""
	..do ComparePersisObj
	..do GetDataHosp
	..quit:(HospId'="")&&(HospId'=DataHospId)&&(DataHospId'="")
	..// 添加汉字表名  ShangXuehao Start
	..set DicId=$o(^DHCINDID("0","ITypeCode","INSUDataCycleConfig",ParamClassName,0))
	..set DicDesc=""
	..if DicId'="" set DicDesc=$p($g(^DHCINDID(DicId)),"^",3)
	..// end
	..set StrLen=$l(CompareInfo)
	..set:StrLen>1 CompareInfo=$e(CompareInfo,1,StrLen-1)
    ..s data=$lb(DataTableName,DataTableId, DataDicType, DataOptType, DataDate, DataTime, UserDesc, DataStr, CompareInfo, NewDataStr, DicDesc)
    ..s ^CacheTemp(repid1,ind1)=data
    ..s ind1=ind1+1		
    
	Quit $$$OK	 
GetDataHosp
	set OldStr=$lg(Data,9) 
	set DataLength=$l(OldStr,"^")
	for i=2:1:DataLength  d //不对比ROWID从2开始
	.set OldVal=$p(OldStr,"^",i)
	.s:$p(TableArr(i-1),"^",2)="院区" DataHospId=OldVal
	quit
ComparePersisObj //对比数据 遍历主索引 通过^ ，将对比结果存入CompareInfo
	quit:$lg(Data,5)'="UPDATE" //只对比更新的数据
	// a->b(a)->c(b)-d(c) del
	set NewObjId=$lg(Data,3) 
	set OldStr=$lg(Data,9) // 当前修改记录修改前的数据
	set NewStr=$lg(Data,10) // 相对于当前修改历史的新数据

	

	set DataLength=$l(OldStr,"^")
	set NewDataLength=$l(NewStr,"^")
	set:(NewDataLength'=DataLength) NewStr=NewObjId_"^"_NewStr 	
	set NewStrINSUType=$p(NewStr,"^",DataINSUType+1) //rowid +1
	set OldStrINSUType=$p(OldStr,"^",DataINSUType+1)

	for i=2:1:DataLength  d //不对比ROWID从2开始
	.set OldVal=$p(OldStr,"^",i)
	.set NewVal=$p(NewStr,"^",i)
	.if NewVal'=OldVal  d
	..set Caption=$p(TableArr(i-1),"^",2)
	..set PropertyName=$p(TableArr(i-1),"^",1)
	..set PropertyType=$p(TableArr(i-1),"^",3)
	..set tableFieldName=$p(TableArr(i-1),"^",4)
	..do FormatterData
	..set CompareInfo="["_Caption_"]:"_OldVal_"->"_NewVal_"，"_CompareInfo
	quit
GetTableInfo //将表结构存到数组中
	new (ParamClassName,TableArr,DataMasterGlobal,RowidName,TableINSUTypeField,DataINSUType,TableFieldNameStr)
	s TmpTableName=^oddDEF(ParamClassName,"58")
	s TableInfo=##class(web.Util.DHCJFClassGlobal).GetTableInfo(TmpTableName)
	b //69
	s DataMasterGlobal=$p(TableInfo,"!",4)
	s PackageName=$p(TableInfo,"!",2)
	s className=$p(TableInfo,"!",3)
	
	s RowidName=##class(web.Util.DHCJFClassGlobal).GetUserRowid(PackageName,className)
	
	s StorageName=$O(^oddDEF(ParamClassName,"s",""))
	i StorageName="" Set StorageName="SQLStorage"
	
	s masterIndexName=##class("web.Util.DHCJFClassGlobal").getMasterIndexName(PackageName,className)
	s rsltSt = ##class(%ResultSet).%New("%Dictionary.PropertyDefinition:Summary")
	d rsltSt.Execute(ParamClassName)
	While(rsltSt.Next()) {
		s (propertyName,propertyNode,propertyDeli,propertyPiece,propertyType,propertyField,propertyColumn,tableFieldName)=""
		set propertyName=rsltSt.Data("Name")
		set propertyId=ParamClassName_"||"_propertyName
		set propObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId,0)
		set propertyType=propObj.Type
		if ($l(propertyType,".")=1)&&($l(propertyType,"%")=1) s propertyType="User."_propertyType
		set propertyField=propObj.SqlFieldName
		set propertyColumn=propObj.SqlColumnNumber
		set ssmddID=ParamClassName_"||"_StorageName_"||"_masterIndexName_"||"_propertyField
		set ssmdd=##class(%Dictionary.StorageSQLMapDataDefinition).%OpenId(ssmddID,0)
		if (ssmdd'="") {
			set propertyNode=ssmdd.Node
			set propertyDeli=ssmdd.Delimiter
			set propertyPiece=ssmdd.Piece
			set tableFieldName=ssmdd.Name
		}else{
			set tableFieldName=propertyField
			set propertyPiece=$g(^oddDEF(ParamClassName,"a",propertyName,43))-1 //+tanfb 2023-04-07 默认存储类
		}
		set Caption=propObj.Parameters.GetAt("CAPTION")
		set:TableINSUTypeField=tableFieldName DataINSUType=propertyPiece //^医保类型表中所在的^位置 为了转义医保字典数据
		;b:propertyPiece'="" // 属性^属性描述^数据类型^表字段名
		i Caption=""  d
		.set Caption=$p($p($p(TableFieldNameStr,propertyName,2),"=",2),"|",1) // 
		set:propertyPiece'="" TableArr(propertyPiece)=propertyName_"^"_Caption_"^"_propertyType_"^"_tableFieldName // 字段属性放入数组  只存有意义的数据分割（例如不存父子表中父表ID字段）
	}
	quit
FormatterData //格式化数据
	if PropertyType["Date"  d
	.set:NewVal'="" NewVal=##class(websys.Conversions).DateLogicalToHtml(NewVal)
	.set:OldVal'="" OldVal=##class(websys.Conversions).DateLogicalToHtml(OldVal)
	else  if PropertyType["Time" d
	.set:NewVal'="" NewVal=$zt(NewVal)
	.set:OldVal'="" OldVal=$zt(OldVal)
	else  if PropertyType["User."  d
	.set TmpTranslateField=$p($p($p(TranslateStr,PropertyType,2),"=",2),"|",1) // 
	.if NewVal'=""  d
	..set Newobj=$ZOBJCLASSMETHOD(PropertyType, "%OpenId", NewVal, 0)
	..set:($IsObject(Newobj))&&(TmpTranslateField'="") NewVal=$ZOBJPROPERTY(Newobj,TmpTranslateField)
	.if OldVal'=""  d
	..s Oldobj=$ZOBJCLASSMETHOD(PropertyType, "%OpenId", OldVal, 0)
	..set:($IsObject(Oldobj))&&(TmpTranslateField'="") OldVal=$ZOBJPROPERTY(Oldobj,TmpTranslateField)
	else  if (TranslateStr'="")&&(TranslateStr[tableFieldName)  d
	.set TmpDicType=$p($p($p(TranslateStr,tableFieldName,2),"=",2),"|",1) // INTIM_sfdlbm=Aka065|第二个
	.if $zcvt(TmpDicType,"U")="NUMBER" d // 数值型处理 解决.01 ->0.01
	..set NewVal=$fn(NewVal,"",2)
	..set OldVal=$fn(OldVal,"",2)
	.else  d
	..q:TableINSUTypeField=""
	..set NewVal=##class(web.INSUDicDataCom).GetDicByCodeAndInd(TmpDicType_OldStrINSUType,NewVal,"4",HospId)
	..set OldVal=##class(web.INSUDicDataCom).GetDicByCodeAndInd(TmpDicType_NewStrINSUType,OldVal,"4",HospId)
	//else  if 
	
	set:NewVal="" NewVal="空"
	set:OldVal="" OldVal="空"
	;b //endform
	quit
}

/// 根据医护人员Id贯标医师、护师、技师编码
/// w ##class(web.DHCINSUBase).GetStdInfoByCareProvDR("656",9)
ClassMethod GetStdInfoByCareProvDR(CareProvDR, HospDr As %String = "") As %String
{
 q:$g(CareProvDR)="" ""
 q:$d(^CTPCP(CareProvDR))=0 ""
 //s:+CareProvDR=2856 ^temp("hsjc1")=HospDr
  //$$ALPHAUP
 s SSUSRRowId="",SSUSRFreeText3=""
 s SSUSRRowId=$O(^SSU("SSUSR",0,"CTPCP",CareProvDR,""),-1)
 i +SSUSRRowId=0  d
 .s CPCode=$p(^CTPCP(CareProvDR,1),"^",1)
 .s SSUSRRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CPCode),""),-1)
 s StdInfo=..GetStdInfoByUserId(SSUSRRowId,HospDr)
 q StdInfo
}

/// 根据用户表Code贯标医师、护师、技师编码
/// w ##class(web.DHCINSUBase).GetStdInfoByUserCode("hsjc1")
ClassMethod GetStdInfoByUserCode(UserCode, HospDr As %String = "") As %String
{
 q:$g(UserCode)="" ""
 s SSUSRRowId="",SSUSRFreeText3=""
 s SSUSRRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""),-1)
 s StdInfo=..GetStdInfoByUserId(SSUSRRowId,HospDr)
 q StdInfo
}

/// 根据用户表Id贯标医师、护师、技师编码
/// w ##class(web.DHCINSUBase).GetStdInfoByUserId("")
/// 基础平台组 SSUSRFreeText3 用这个字段存贯标
/// 注意 某些项目可能此字段已经被占用 要修改
ClassMethod GetStdInfoByUserId(SSUSRRowId, HospDr As %String = "") As %String
{
 q:$g(SSUSRRowId)="" ""
 q:$d(^SSU("SSUSR",SSUSRRowId))=0 ""
 s drcodg="",SSUSRFreeText3="",SSUSRName3="",drname=""
 //s drcodg=$P(^SSU("SSUSR",SSUSRRowId),"^",124)        //SSUSRFreeText3 医师、护师、技师编码 基础平台组 SSUSRFreeText3 用这个字段存贯标 项目要具体分析改动
 //s drcodg=$P(^SSU("SSUSR",SSUSRRowId),"^",107)      //SSUSRName3 医师、护师、技师编码 九江中医 
 s drname=$P(^SSU("SSUSR",SSUSRRowId),"^",2)
 s drcodg=##class(web.DHCINSUPortUse).GetINSUCodeByUserId(SSUSRRowId) //DingSH 20220628 
 q drcodg_"^"_drname
 //如下放开提需求 
 s UserCode=$P(^SSU("SSUSR",SSUSRRowId),"^",1)
 s drname=$P(^SSU("SSUSR",SSUSRRowId),"^",2)
 s DicInfo= ##class(web.INSUDicDataCom).GetDicByCodeAndInd("dr_codgdfltCon00A",UserCode,0,HospDr) //DingSH 20211120
 i drcodg="" d
 .s drcodg=$P(DicInfo,"^",6)
 .s drname=$P(DicInfo,"^",7)
  q drcodg_"^"_drname
}

/// ##class(web.DHCINSUBase).TrigerTest()
ClassMethod TrigerTest()
{
}

}
