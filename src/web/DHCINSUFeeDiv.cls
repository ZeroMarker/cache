Import SQLUser

Class web.DHCINSUFeeDiv Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 262;

//w ##class(web.DHCINSUFeeDiv).GetFeeDivByBill("100","ZY-77","1", "1", "","N")

/// 上海医保本地计算费用主业务函数（住院用）
/// 入参：BillBR:       账单号
///      AdmReasonCode: Pac_AdmReason表的Code
///      PatRYLB:       人员类别(在职,退休)实时结算的病人才有
///      IpTimes:       住院次数
///      TotalStr:      分类汇总金额(总金额^交易费用总额^分类自负总额^医保外费用总额)
///      Flag:          Y：本地结算的    N：实时结算的预结算
/// 出参:标志位!起付段费用信息!起付段至封顶线费用信息!超封顶线费用信息!其他费用信息 (具体格式见M)
ClassMethod GetFeeDivByBill(BillDR, AdmReasonCode, PatRYLB, IpTimes, TotalStr, Flag) As %String
{
 n (BillDR, AdmReasonCode,PatRYLB,IpTimes,TotalStr,Flag)
 q:(BillDR="")!(AdmReasonCode="")!(PatRYLB="")!(IpTimes="") -100
 //       总费用 交易费用 分类 自费
 ;s TotalStr="10000^9000^900^100"
 s OutStr=""
 //s OutStr=$$GetCateDetails^DHCINSUFeeDivZH(BillBR, InsuType, PatType, IpTimes)
 //q:OutStr'>0 -1_"!"_"无费用"
 //取比例信息
 s ZFBLStr=$$GetInsuTotCateZFBLStr^DHCINSUFeeDivSH(AdmReasonCode,PatRYLB)
 i $p(ZFBLStr,"^",1)=-1 q ZFBLStr
 s QFXAndXEStr=$$GetNumQFXAndXE^DHCINSUFeeDivSH(AdmReasonCode,PatRYLB,IpTimes)
 i $p(QFXAndXEStr,"^",1)=-1 q QFXAndXEStr
 //起伏线^限额^统筹累计^救助累计^师职退休自负累计
 s LJStr=QFXAndXEStr_"^"_"0"_"^"_"0"_"^"_"120"
 s LJStr=..GetLJStr(BillDR,LJStr,Flag)
 ;w !,BillBR,"=",TotalStr,"=",LJStr,"=",ZFBLStr
 i ($p(ZFBLStr,"^",5)=1)!($p(ZFBLStr,"^",5)=2)   d 
 .s $p(TotalStr,"^",2)=$p(TotalStr,"^",2)+$p(TotalStr,"^",3)
 .s $p(TotalStr,"^",3)=0

 s OutStr=$$GetInsuTotFD^DHCINSUFeeDivSH(BillDR,TotalStr,LJStr,ZFBLStr,IpTimes)
 //w !,"OutStr=",OutStr
 i $p(ZFBLStr,"^",5)=2  d   //师职退休
 .s OutStr=..GetSZTX(OutStr, LJStr)
 i $p(ZFBLStr,"^",5)=3  d   //少儿基金与学保 (在统筹段信息中最后拼上一个少儿基金支付金额)
 .s OutStr=..GetSEJJYeXB(OutStr, LJStr)
 i $p(ZFBLStr,"^",5)=4  d   //少儿基金
 .s OutStr=..GetSEJJ(OutStr, LJStr)
 i OutStr<0 d
 .s GetAdmInfoByBill="-3!"_OutStr
 e           d
 .s GetAdmInfoByBill="1!"_OutStr
 q GetAdmInfoByBill
}

ClassMethod GetSZTX(OutStr, LJStr) As %String
{
  n (OutStr,LJStr)
 s TCFD=$p(OutStr,"!",2)   //师职退休
 s TCFD3=$p(TCFD,"^",3)
 s TCFDZF=240-$p(LJStr,"^",5)
 i TCFD3>TCFDZF   d
 .s TCFD3=TCFDZF
 s TCFD2=$p(TCFD,"^",1)-TCFD3
 s TCFD=$p(TCFD,"^",1)_"^"_TCFD2_"^"_TCFD3_"^"_$p(TCFD,"^",4)_"^"_$p(TCFD,"^",5)
 s $p(OutStr,"!",2)=TCFD   ////师职退休
 q OutStr
}

ClassMethod GetSEJJYeXB(OutStr, LJStr) As %String
{
 n (OutStr,LJStr)
 s TCFD=$p(OutStr,"!",2)   //
 s TmpPH=25
 s TCFD3=$p(TCFD,"^",3)-25
 s TCFD2=$p(TCFD,"^",2)+25
 s TCFD6=TCFD3
 s TCFD3=0
 s TCFD=$p(TCFD,"^",1)_"^"_TCFD2_"^"_TCFD3_"^"_$p(TCFD,"^",4)_"^"_$p(TCFD,"^",5)_"^"_TCFD6
 s $p(OutStr,"!",2)=TCFD   ////
 q OutStr
}

ClassMethod GetSEJJ(OutStr, LJStr) As %String
{
 n (OutStr,LJStr)
 s TCFD=$p(OutStr,"!",2)   //
 s TCFD2=$p(TCFD,"^",2)
 s TCFD3=$p(TCFD,"^",3)
 s TCFD6=TCFD2
 s TCFD2=0
 s TCFD=$p(TCFD,"^",1)_"^"_TCFD2_"^"_TCFD3_"^"_$p(TCFD,"^",4)_"^"_$p(TCFD,"^",5)_"^"_TCFD6
 s $p(OutStr,"!",2)=TCFD   ////
 q OutStr
}

//取病人的累计信息

ClassMethod GetLJStr(BillDR, LJStr, Flag) As %String
{
 n (BillDR,LJStr,Flag)
 w 
 i Flag="N"  d
 .s AdmDr=$$GetAdmByBill^DHCINSUPatInfo(BillDR)
 .q:AdmDr="-100" 
 .w !,"AdmDr=",AdmDr
 .s AdmInfoStr=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(AdmDr)
 .i $p(AdmInfoStr,"!",1)=1   d
 ..s AdmInfo=$p(AdmInfoStr,"!",2)
 ..s QFX=$p(AdmInfo,"^",32)
 ..s TCLJ=$p(AdmInfo,"^",50)
 ..//s 起伏线^限额^统筹累计^救助累计^师职退休自负累计
 ..s $p(LJStr,"^",1)=QFX
 ..s $p(LJStr,"^",3)=TCLJ
 s GetLJStr=LJStr
 q GetLJStr
}

ClassMethod GetTCFDBL(InsuType, PatType, IpTimes) As %String
{
 n (InsuType, PatType, IpTimes)
 q:(InsuType="")!(PatType="")!(IpTimes="") -100
 s OutStr=""
 s OutStr=$$GetInsuTotCateBL^DHCINSUFeeDivZH(InsuType, PatType)
 i OutStr<0 d
 .s GetTCFDBL="-1!"_OutStr
 e           d
 .s GetTCFDBL="1!"_OutStr
 q GetTCFDBL
}

/// 上海医保本地计算费用主业务函数(门诊用)
/// 入参：门诊发票表Rowid
///      Pac_AdmReason表的Code
///      人员类别(在职,退休)实时结算的病人才有
///      住院次数
///      分类汇总金额(总费用^交易费用总额^分类^医保外费用总额)
/// 出参:标志位!起付段费用信息!起付段至封顶线费用信息!超封顶线费用信息!其他费用信息 (具体格式见M)
/// w ##class(web.DHCINSUFeeDiv).GetFeeDivByINVDr("177278","MZ-23","1", "1","457.97^400^60^57.97")
ClassMethod GetFeeDivByINVDr(INVPrtDr, AdmReasonCode, PatRYLB, IpTimes, TotalStr) As %String
{
 n (INVPrtDr, AdmReasonCode,PatRYLB,IpTimes,TotalStr)
 q:(INVPrtDr="")!(AdmReasonCode="")!(PatRYLB="")!(IpTimes="") -100
 //       总费用 医保内费用 分类 自费
 //s TotalStr="2100^1000^900^100"
 s OutStr=""
 //s OutStr=$$GetCateDetails^DHCINSUFeeDivZH(BillBR, InsuType, PatType, IpTimes)
 //q:OutStr'>0 -1_"!"_"无费用"
 //取比例信息
 s ZFBLStr=$$GetInsuTotCateZFBLStr^DHCINSUFeeDivSH(AdmReasonCode,PatRYLB)
 b	;1
 i $p(ZFBLStr,"^",1)=-1 q ZFBLStr
 s QFXAndXEStr=$$GetNumQFXAndXE^DHCINSUFeeDivSH(AdmReasonCode,PatRYLB,IpTimes)
 b	;2
 i $p(QFXAndXEStr,"^",1)=-1 q QFXAndXEStr
 s LJStr=QFXAndXEStr_"^"_"0"_"^"_"0"
 ;w !,BillBR,"=",TotalStr,"=",LJStr,"=",ZFBLStr
 i $p(ZFBLStr,"^",5)=1   d 
 .s $p(TotalStr,"^",2)=$p(TotalStr,"^",2)+$p(TotalStr,"^",3)
 .s $p(TotalStr,"^",3)=0
 b	;3
 s OutStr=$$GetInsuTotFD^DHCINSUFeeDivSHOP(INVPrtDr,TotalStr,LJStr,ZFBLStr)
 b	;4
 i OutStr<0 d
 .s GetAdmInfoByBill="-3!"_OutStr
 e           d
 .s GetAdmInfoByBill="1!"_OutStr
 q GetAdmInfoByBill
}

/// 武汉公费算法(门诊)
/// 2011-08-31
/// 入参：INVPrtDr:       发票Rowid
///      AdmReaRowid： Pac_AdmReason表的rowid
///      InsuType:      医保类型
/// 出参:标志位!总金额^医院负担^单位负担^个人负担
/// w ##class(web.DHCINSUFeeDiv).GetFeeDivByINVPrtWH("193791","37","320530002","WHB6")
ClassMethod GetFeeDivByINVPrtWH(INVPrtDr, AdmReaRowid, InsuNo, InsuType) As %String
{
 n (INVPrtDr,InsuType,InsuNo,AdmReaRowid)
 q:(INVPrtDr="")!(AdmReaRowid="")!(InsuType="") -100
 ;s ^HH(00)=INVPrtDr_"^"_AdmReaRowid_"^"_InsuNo_"^"_InsuType
 s StrBill=""
 s DHCBCIDr=""
 s lsh=$p($h,",",1)_$p($h,",",2)
 ;s lsh="6233943316",InsuType="SDA"
 s GetFeeDivByINVPrt="-3"
 f  s DHCBCIDr=$o(^DHCBCI(0,"INV",INVPrtDr,DHCBCIDr)) q:(DHCBCIDr="")  d
 .s mCurrRowDHCBillConINV=$g(^DHCBCI(DHCBCIDr))
 .s BillDR=$p(mCurrRowDHCBillConINV,"^",2)
 .;w BillDR_"!"_lsh,!
 .s BillInfo=$$GetBillInfoByBillDr^DHCINSUFacade(BillDR,InsuType,"")  ;获取明细存入DIvideSub
 .s InsuPID=$p(BillInfo,"|",2)
 .s PBTotal=$p(BillInfo,"|",3)
 .;s AdmReasonCode=$p(^PAC("ADMREA",AdmReaRowid),"^",1)
 .;s AdmReason=AdmReaRowid_AdmReasonCode
 .s FeeStr=$$GetTempFeeByBillMZ^DHCINSUDivWH(BillDR,AdmReaRowid,InsuType,lsh) ;获取DivideSub信息计算比例金额
 .q:FeeStr="0" 
 .i StrBill="" s StrBill=BillDR
 .e  s StrBill=StrBill_"^"_BillDR
 
 w StrBill_"^"_AdmReaRowid_"^"_lsh_"^"_InsuNo
 b
 s FeeStr=$$SetDivideSubInsuCatMZ^DHCINSUDivWH(StrBill,AdmReaRowid,lsh,InsuNo) ;分别计算存入INSU_DivideSubInsuCat
 s Feeflag=$p(FeeStr,"|",1)
 s TotalFund=$p($p(FeeStr,"|",2),"^",1)
 s Limit=$p($p(FeeStr,"|",2),"^",2)
 q:Feeflag<"0" -1
 s OutStr=$$SetDivideInfoMZ^DHCINSUDivWH(lsh) ;计算结果并返回
 i OutStr<0  d
 .s GetFeeDivByINVPrt="-3|"_OutStr_"|"_TotalFund_"|"_lsh_"|"_Limit
 e  d
 .s GetFeeDivByINVPrt="1|"_OutStr_"|"_TotalFund_"|"_lsh_"|"_Limit
 q GetFeeDivByINVPrt
}

ClassMethod DeleteDivInsuCatByLSH(JYLSH) As %String
{
	s Out="-1"
	i $d(^DHCINDISIC("0","JYLSH",JYLSH))'=0  d  ;先删除该账单计算数据，再从新插入
	.s INDISICDr=""
	.f  s INDISICDr=$o(^DHCINDISIC("0","JYLSH",JYLSH,INDISICDr))  q:INDISICDr=""  d
	..s Flag=$$DeleteDivideSubInsuCat^DHCINSUDivideSubInsuCat(INDISICDr)
	..i Flag=0  s Out="0"
	..e  s Out="-1"
	q Out
}

/// 2011-09-15 WH 分解窗口显示明细及比例信息
/// 入参：INVPrtDr:  发票Rowid(门诊)   BillDr: 账单号(住院)
/// 出参:标志位!项目代码^项目名称^总金额^数量^自付比例^医院负担^单位负担^个人负担^医保等级^是否符合此次结算慢性病要求
/// w ##class(web.DHCINSUFeeDiv).GetDivSubByINVPrt("823","")
ClassMethod GetDivSubByINVPrt(INVPrtDr, BillDr) As %String
{
 n (INVPrtDr,BillDr)
 q:(INVPrtDr="")&&(BillDr="") -100
 s OutStr=""
 i INVPrtDr'="" d  ;门诊
 .s DHCBCIDr=""
 .f  s DHCBCIDr=$o(^DHCBCI(0,"INV",INVPrtDr,DHCBCIDr)) q:(DHCBCIDr="")  d
 ..s mCurrRowDHCBillConINV=$g(^DHCBCI(DHCBCIDr))
 ..s BillDR=$p(mCurrRowDHCBillConINV,"^",2)
 ..s INDISRowid=""
 ..f  s INDISRowid=$o(^DHCINDIS("0","PBDr",BillDR,INDISRowid))  q:INDISRowid=""  d
 ...s INDISInfo=$g(^DHCINDIS(INDISRowid))
 ...s TarRowid=$p(INDISInfo,"^",3) 
 ...s TarCode=$p(^DHCTARI(TarRowid),"^",1)
 ...s TarDesc=$p(^DHCTARI(TarRowid),"^",2)
 ...s Amount=$p(INDISInfo,"^",13) 
 ...s Qty=$p(INDISInfo,"^",11) 
 ...s UnitPrice=$p(INDISInfo,"^",12) 
 ...s Scale=$p(INDISInfo,"^",15)
 ...s XMLB=$p(INDISInfo,"^",10)
 ...s Demo1=$p(INDISInfo,"^",26)
 ...s ZFBL=Scale*0.01
 ...s Self=Amount*ZFBL
 ...s Fund=Amount-Self
 ...i OutStr="" s OutStr=TarCode_"^"_TarDesc_"^"_Amount_"^"_Qty_"^"_Scale_"^"_Fund_"^"_Self_"^"_XMLB_"^"_Demo1
 ...e  s OutStr=OutStr_"|"_TarCode_"^"_TarDesc_"^"_Amount_"^"_Qty_"^"_Scale_"^"_Fund_"^"_Self_"^"_XMLB_"^"_Demo1
 e  d
 .s INDISRowid=""
 .f  s INDISRowid=$o(^DHCINDIS("0","PBDr",BillDr,INDISRowid))  q:INDISRowid=""  d
 ..s INDISInfo=$g(^DHCINDIS(INDISRowid))
 ..s TarRowid=$p(INDISInfo,"^",3) 
 ..s TarCode=$p(^DHCTARI(TarRowid),"^",1)
 ..s TarDesc=$p(^DHCTARI(TarRowid),"^",2)
 ..s Amount=$p(INDISInfo,"^",13) 
 ..s Qty=$p(INDISInfo,"^",11) 
 ..s UnitPrice=$p(INDISInfo,"^",12) 
 ..s Scale=$p(INDISInfo,"^",15)
 ..s XMLB=$p(INDISInfo,"^",10)
 ..s Demo1=$p(INDISInfo,"^",26)
 ..s ZFBL=Scale*0.01
 ..s Self=Amount*ZFBL
 ..s Fund=Amount-Self
 ..i OutStr="" s OutStr=TarCode_"^"_TarDesc_"^"_Amount_"^"_Qty_"^"_Scale_"^"_Fund_"^"_Self_"^"_XMLB_"^"_Demo1
 ..e  s OutStr=OutStr_"|"_TarCode_"^"_TarDesc_"^"_Amount_"^"_Qty_"^"_Scale_"^"_Fund_"^"_Self_"^"_XMLB_"^"_Demo1
 q OutStr
}

}
