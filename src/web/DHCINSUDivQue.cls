Import sqluser

/// 用于医保病人费用信息动态查询，医保病人日报，月报查询
/// 入参
/// 1：医保号，
/// 2: 登记号
/// 3：结算用户，
/// 4：医保类型
/// 5: 特病标志
/// 6: 人员类别
/// 7: 开始时间
/// 8: 结束时间
/// InsuNo   RegNo   User   InsuType   TBBZ   RYLB   stadate   enddate  
/// Write by liusf 2006 09 beijing
Class web.DHCINSUDivQue Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 242;

/// Creator：      	杨建章
/// CreatDate：    	2010-02-08
/// Description： 	查询发生日期的<交易记录库>信息
/// Table：       	insu_divide,insu_adminfo,pa_adm
/// Input：          CurrDate   发生日期
/// Return：        
/// Others：		w ##class(web.DHCINSUDivQue).SetUpDetailsA("2010-02-09")
ClassMethod SetUpDetailsA(CurrDate As %String) As %String
{
	n (CurrDate)
	k ^CacheTemp("INSUUpDetailA",$j)
	s OutStr="-1"
	q:CurrDate="" OutStr
	s CurrDate=$zdh(CurrDate,3)
	s HospCode="42501633100"				;医疗机构代码	11	
	s i=1
	s DivDr=""
	f  s DivDr=$o(^DHCINDIV("0","IDate",CurrDate,DivDr)) q:DivDr=""  d
	.s djlsh="",CardNo="",DepCode="",DepDesc="",DivFlag="",ZYTS=0,JYFYZE=0,DNZHZF=0,LNZHZF=0,ZFDXJ=0,QFDXJ=0,QFDZH=0
	.s TCDXJ=0,TCDZH=0,TC=0,FJDXJ=0,FJDZH=0,FJD=0,StrikeFlag=""
	.s SYBZ="",INVNO="",StartDate="",ZHBZ="",PatType="",DivTime="",YBFW=0,FYB=0,SeriNo=""
	.s ZYH="",InDiagCode="",InDiagDesc="",OutDiagCode="",OutDiagDesc="",PBDateTo="",CYBZ="",JZBZ=""
	.s DivInfo=$g(^DHCINDIV(DivDr))
	.s djlsh=$p(DivInfo,"^",8)			;中心交易流水号	16	交易确认应答返回的流水号
	.q:djlsh=""						;单据流水号为空表示此数据位本地结算数据
	.s AdmDr=$p(DivInfo,"^",1)
	.s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) //+ DingSH 20200619
	.s AdmNo=$p($g(^PAADM(AdmDr)),"^",81)
	.s AdmInfoDr=$p(DivInfo,"^",2)
	.s InsuAdmInfo=$g(^DHCINADM(AdmInfoDr))
	.s SYBZ=$p(InsuAdmInfo,"^",40)				;适用医保办法标志
	.s SeriNo=$p(InsuAdmInfo,"^",10)
	.s Flag=$p(DivInfo,"^",5)				//结算状态，I：正常、B：被冲销、S冲销记录，D中间状态
	.q:Flag="D"	
	.i Flag="S"  d
	..s StrikeFlag=2
	.e  s StrikeFlag=1
	.s PBDr=+$p(DivInfo,"^",3)			;账单号
	.s InvPrtDr=+$p(DivInfo,"^",4)
	.s RefDiv=$p(DivInfo,"^",6)			//被冲销
	.s TotalAmount=+$p(DivInfo,"^",7)		//总费用
	.s Zhzfe=$p(DivInfo,"^",28)			//账户支付
	.s Jjzfe=$p(DivInfo,"^",19)			//统筹支付，基金支付
	.s SelfPay=+$p(DivInfo,"^",15)			//现金支付
	.s InsuId=$p(DivInfo,"^",18)			//医保号，个人编号
	.s JYFYZE=+$p(DivInfo,"^",51)		;交易费用总额	10	数字格式H
	.s DNZHZF=+$p(DivInfo,"^",56)			;当年帐户支付数：门急诊	10	数字格式H
	.s LNZHZF=+$p(DivInfo,"^",57)		;历年帐户支付数：门急诊 除镇保外	10	数字格式H
	.s QFX=+$p(DivInfo,"^",61)	;起付段现金支付数/自负段现金支付数(门)
	.s QFDZH=+$p(DivInfo,"^",58)		;起付段帐户支付数：住院、急观，除镇保外	10	数字格式H
	.s TCDXJ=+$p(DivInfo,"^",62)		;统筹段现金支付数：住院、急观、家床、大病、个保门急诊 、（居民医保、医疗互助帮困对象） 三类参保人员门急诊	10	数字格式H
	.s TCDZH=+$p(DivInfo,"^",59)		;统筹段帐户支付数：住院、急观、家床、大病，除镇保外	10	数字格式H
	.s TC=+$p(DivInfo,"^",31)			;统筹支付数：住院、急观、家床、大病、个保门急诊、（居民医保、医疗互助帮困对象） 三类参保人员门急诊	10	数字格式H
	.s FJDXJ=+$p(DivInfo,"^",63)		;附加段现金支付数：除个保外	10	数字格式H
	.s FJDZH=+$p(DivInfo,"^",60)		;附加段帐户支付数：除门急诊、个保外，除镇保外	10	数字格式H
	.s FJD=+$p(DivInfo,"^",32)			;地方附加支付数：除个保外，除镇保外	10	数字格式H
	.s YBFW=+$p(DivInfo,"^",52)			;医保结算范围费用总额	10	数字格式H
	.s FYB=+$p(DivInfo,"^",53)			;非医保结算范围个人自费	10	数字格式H	
	.s AdmDeptDr=+$p($g(^PAADM(AdmDr)),"^",4)
	.s AdmDepCode=$p($g(^CTLOC(AdmDeptDr)),"^",1)  
	.s DepStr=$$QueryByCode^DHCINSUDicData("Dep",AdmDepCode,HospDr)
	.s DepCode=$p(DepStr,"^",6)			;科室代码
	.s DepDesc=$p(DepStr,"^",7)			;科室名称
	.s CardNo=$p(DivInfo,"^",18)		;社保卡（医保卡）卡号	10	
	.s ZHBZ=$p(InsuAdmInfo,"^",43)		;帐户标志	16	
	.
	.s PatType=$p(InsuAdmInfo,"^",4)	;病人类型	1	0：一般病人  1：工伤  2：职业病5:造血干细胞移植治疗
	.s AdmType=$p(InsuAdmInfo,"^",14)	;01：门诊挂号 02：急诊挂号 03:大病挂号，10：家床建床 20：急观入观 30：入院登记 40:干部保健急观入院  50干部保健入院登记
	.s DisCode=$p(InsuAdmInfo,"^",45)		;大病编码
	.s DivType=+$p(DivInfo,"^",11) 		;0挂号或登记，其他结算
	.s tmpCYBZ=+$p(DivInfo,"^",52)			;出院标志，0标志出院结算 1表示在院结算
	.i tmpCYBZ=0            d 
	..s CYBZ=1
	.e                   d
	..s CYBZ=2
	.;b
	.i AdmType="01"  d
	..s ZFDXJ=QFX
	..i DivType=0   d
	...s DivFlag="110"			;110=门诊挂号
	...s ZYTS=1
	...;s INVNO=..GetRegInvNo(AdmDr)
	..i DivType'=0  d
	...s DivFlag="120"			;120=门诊结算
	...s ZYTS=0
	.e  i AdmType="02"   d
	..s ZFDXJ=QFX
	..i DivType=0 d
	...s DivFlag="210"			;210=急诊挂号
	...s ZYTS=1
	...;s INVNO=..GetRegInvNo(AdmDr)
	..i DivType'=0 d
	...s DivFlag="220"			;220= 急诊结算
	...s ZYTS=0
	.e  i AdmType="03"   d
	..s ZFDXJ=QFX
	..	;门诊大病前2位： 31=大病挂号  32=大病结算； 后1位，大病编码
	..i DivType=0 d
	...s DivFlag="31"_DisCode
	...s ZYTS=1
	...;s INVNO=..GetRegInvNo(AdmDr)
	..i DivType'=0 d
	...s DivFlag="32"_DisCode
	...s ZYTS=0
	.e  i AdmType="10"  d
	..s ZFDXJ=QFX
	..s:(DivType=0) DivFlag="410"			;410=家床结算 
	..s ZYTS=0
	.e  i (AdmType="20")||(AdmType="40")  d
	..s QFDXJ=QFX
	..s DivFlag="510"			;510=急观结算
	..s JZBZ=2
	.e  i (AdmType="30")||(AdmType="50")  d
	..s QFDXJ=QFX
	..s DivFlag="610"			;610=住院结算
	..s JZBZ=1
	..s ZYH=AdmNo
	..s InDiag=$$GetInDiag^DHCINSUPatInfo(AdmDr)
	..s InDiagCode=$p(InDiag,"^",3)
	..s InDiagDesc=$p(InDiag,"^",4)
	..s OutDiag=$$GetOutDiag^DHCINSUPatInfo(AdmDr)
	..s OutDiagCode=$p(OutDiag,"^",3)
	..s OutDiagDesc=$p(OutDiag,"^",4)
	..s PBDateTo=$p($g(^DHCPB(PBDr)),"^",7)
	..s PBDateTo=$zd(+PBDateTo,3)
	..
	.i InvPrtDr>0  d
	..s INVNO=$p($g(^DHCINVPRT(InvPrtDr)),"^",14)	;门诊发票号
	..s StartDate=$zd($p(InsuAdmInfo,"^",12),8)
	.e             d
	..s InvPrtDr=$o(^DHCINVPRTZY(0,"AR",PBDr,""))
	..i InvPrtDr="" s INVNO=""  
	..e  s INVNO=$p($g(^DHCINVPRTZY(InvPrtDr)),"^",1)	;住院发票号
	..s StartDate=$zd($p($g(^DHCPB(PBDr)),"^",6),8)
	.
	.s DivTime=$p(DivInfo,"^",17)
	.s DivTime=$zd(CurrDate,8)_"/"_$tr($zt(DivTime),":")_"/"		;中心交易的时间
	.;w !,"DivDr=",DivDr,",InvPrtDr=",INVNO
	.s TmpStr=djlsh_"^"_HospCode_"^"_CardNo_"^"_ZHBZ_"^"_PatType_"^"_ZYTS_"^"_DivTime_"^"_DivFlag_"^"_JYFYZE_"^"_DNZHZF_"^"_LNZHZF_"^"_ZFDXJ
	.s TmpStr=TmpStr_"^"_QFDXJ_"^"_QFDZH_"^"_TCDXJ_"^"_TCDZH_"^"_TC_"^"_FJDXJ_"^"_FJDZH_"^"_FJD_"^"_YBFW_"^"_FYB_"^"_SYBZ_"^"_INVNO_"^"_StrikeFlag_"^"_StartDate
	.s TmpStr=TmpStr_"!"_DepCode_"!"_DepDesc_"!"_SeriNo_"!"_AdmNo_"!"_InDiagCode_"!"_InDiagDesc_"!"_OutDiagCode_"!"_OutDiagDesc_"!"_PBDateTo_"!"_JZBZ_"!"_CYBZ
	.s ^CacheTemp("INSUUpDetailA",$j,i)=TmpStr
	.s i=i+1
	q i-1_"^"_$j
}

ClassMethod GetUpDetailsATmp(JustId As %String, Index As %String) As %String
{
	s OutStr=^CacheTemp("INSUUpDetailA",JustId,Index)
	q OutStr
}

ClassMethod GetRegInvNo(AdmDr As %String) As %String
{
	n (AdmDr)
	s InvNo=""
	//s Admi=" "_Adm
	//s I=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))   ;20230303 注释掉 his 9.0 开始改造
	s RegFeeRowId=$O(^User.DHCRegistrationFeeI("ADM",AdmDr,""))
	//s InvoiceId=$List(^User.DHCRegistrationFeeD(RegFeeRowId),11) ;;20230303 注释掉 取错位置了
	s InvoiceId=$List(^User.DHCRegistrationFeeD(RegFeeRowId),20)
	s InvNo=$p(^DHCINVPRT(InvoiceId),"^",14)
	q InvNo
}

/// 住院病人住院号查询患者该次结算明细
/// D ##class(%ResultSet).RunQuery("web.DHCINSUDivQue","GetDivideSubByAdm","176","","","白及","")
/// D ##class(%ResultSet).RunQuery("web.DHCINSUDivQue","GetDivideSubByAdm","","","21","","")
Query GetDivideSubByAdm(admDr As %String, QchrgitmLv00A As %String, BillDr As %String, InsuKey = "", TarItemKey = "") As %Query(ROWSPEC = "ind:%String,INPAYdjlsh0:%String,INPAYiDate:%String,Center:%String,INPAYzyksmc:%String,INPAYxming0:%String,Medicare:%String,digDesc:%String,INSUCode:%String,InsuDesc:%String,TarItmCode:%String,TarItmDesc:%String,Qty:%Integer,Price:%Float,Scale:%Float,Amount:%Float,Demo1:%Float,Demo3:%Float,Self:%Float,Demo2:%Float,YBFL:%String,pblDr:%String") [ SqlProc ]
{
}

ClassMethod GetDivideSubByAdmExecute(ByRef qHandle As %Binary, admDr As %String, QchrgitmLv00A As %String, BillDr As %String, InsuKey = "", TarItemKey = "") As %Status
{
	
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	Set qHandle=$lb(0,repid,0)
	
	tro
	set INPAYRowid=""
	set ^TMP("GetChargeInfoByAdmExecute")=$LB(admDr,QchrgitmLv00A,BillDr,InsuKey,TarItemKey)
	s IDesc=$$ALPHAUP^SSUTIL4(InsuKey)
	s TarDesc=$$ALPHAUP^SSUTIL4(TarItemKey)
	
	//q:(admDr="")&&(BillDr="")  
	s Flag = 0
	i BillDr'="" d
	.for  set INPAYRowid=$o(^DHCINDIV("0","DHCPB",BillDr,INPAYRowid)) quit:INPAYRowid=""  do
    ..set INPAYFlag=$p(^DHCINDIV(INPAYRowid),"^",5) 
    ..quit:INPAYFlag'="I"
	..set INPAYdjlsh0=$p(^DHCINDIV(INPAYRowid),"^",8) ///结算id
	..set INPAYiDate=$zd($p(^DHCINDIV(INPAYRowid),"^",16),3) ///结算日期
	..set INPAYzyksmc=$p(^DHCINDIV(INPAYRowid),"^",29) ///科室名称
	..set INPAYxming0=$p(^DHCINDIV(INPAYRowid),"^",27) ///姓名
	..s adm=$p(^DHCINDIV(INPAYRowid),"^",1)
	..set papmi=$p(^PAADM(adm),"^",1)
	..s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(admDr)
	..set Medicare=##class(web.DHCINSUPortUse).IGetMrNoByPatientID(papmi,"I",HospDr,"") //住院号
	..b
	..set AdmInfoDr=$p(^DHCINDIV(INPAYRowid),"^",2) 
	..s pblDr=$p(^DHCINDIV(INPAYRowid),"^",3)
	..set digDesc=$s((+AdmInfoDr'=0):$p($g(^DHCINADM(AdmInfoDr)),"^",27),1:"")
	..set INADMCenter=$s((+AdmInfoDr'=0):$p($g(^DHCINADM(AdmInfoDr)),"^",8),1:"")
	..set Center=##class(web.INSUDicDataCom).GetAdmdvsByCode(INADMCenter)
	..set DivSubDr="0"
    ..for  set DivSubDr=$o(^DHCINDIS("0","DivideDr",INPAYRowid,DivSubDr)) quit:DivSubDr=""  do
	...//set INSUCode=$p(^DHCINDIS(DivSubDr),"^",8)
	...set InsuDesc=$p(^DHCINDIS(DivSubDr),"^",9)
	
	...set TarItmDr=$p(^DHCINDIS(DivSubDr),"^",3)
	...set IntctRowid=$o(^DHCINTCT("0","DHCTID",TarItmDr,""),-1)
	...set INSUCode=$p(^DHCINTCT(IntctRowid),"^",5)
	...set TarItmCode=$s((+TarItmDr'=0):$p($g(^DHCTARI(TarItmDr)),"^",1),1:"")
	...set TarItmDesc=$s((+TarItmDr'=0):$p($g(^DHCTARI(TarItmDr)),"^",2),1:"") ///收费名称
	...set Qty=$p(^DHCINDIS(DivSubDr),"^",11)
	...set Price=$fn($p(^DHCINDIS(DivSubDr),"^",11),"",2)
	...set Scale=$p(^DHCINDIS(DivSubDr),"^",15)
	...set Amount=$fn($p(^DHCINDIS(DivSubDr),"^",13),"",2)
	...set Demo1=$fn($p(^DHCINDIS(DivSubDr),"^",26),"",2)
	...set Demo3=$fn($p(^DHCINDIS(DivSubDr),"^",28),"",2)
	...set Self=$fn($p(^DHCINDIS(DivSubDr),"^",17),"",2)
	...set Demo2=$fn($p(^DHCINDIS(DivSubDr),"^",27),"",2)
	...set INSUXMLB=$p(^DHCINDIS(DivSubDr),"^",10)
	...set chrgitmLv00A=""
	...set:INSUXMLB="01" chrgitmLv00A="甲类"
	...set:INSUXMLB="02" chrgitmLv00A="乙类"
	...set:INSUXMLB="03" chrgitmLv00A="丙类"
	...q:(QchrgitmLv00A'="全部")&(QchrgitmLv00A'="")&(QchrgitmLv00A'=chrgitmLv00A)
	...s HZPYInsuDesc=##class(web.DHCINSUPort).GetCNCODE(InsuDesc,3,"")

	...q:($$ALPHAUP^SSUTIL4(InsuDesc)'[IDesc)&&(HZPYInsuDesc'[IDesc)&&(HZPYInsuDesc'[InsuKey)&&(InsuDesc'[InsuKey)
	...s HZPYTarItmDesc=##class(web.DHCINSUPort).GetCNCODE(TarItmDesc,3,"")
	...q:($$ALPHAUP^SSUTIL4(TarItmDesc)'[TarDesc)&&(HZPYTarItmDesc'[TarDesc)&&(HZPYTarItmDesc'[TarItemKey)&&(TarItmDesc'[TarItemKey)
	...q:(BillDr'="")&(pblDr'=BillDr)
	...do GetChargeInfoByAdm	
	.s Flag=1

	i (admDr'="") && (Flag=0 ) d	
	.for  set INPAYRowid=$o(^DHCINDIV("0","Paadm",admDr,INPAYRowid)) quit:INPAYRowid=""  do
    ..set INPAYFlag=$p(^DHCINDIV(INPAYRowid),"^",5) 
    ..//quit:INPAYFlag'="I"
	..set INPAYdjlsh0=$p(^DHCINDIV(INPAYRowid),"^",8) ///结算id
	..set INPAYiDate=$zd($p(^DHCINDIV(INPAYRowid),"^",16),3) ///结算日期
	..set INPAYzyksmc=$p(^DHCINDIV(INPAYRowid),"^",29) ///科室名称
	..set INPAYxming0=$p(^DHCINDIV(INPAYRowid),"^",27) ///姓名
	..set papmi=$p(^PAADM(admDr),"^",1)
	..s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(admDr)
	..set Medicare=##class(web.DHCINSUPortUse).IGetMrNoByPatientID(papmi,"I",HospDr,"") //住院号
	..set AdmInfoDr=$p(^DHCINDIV(INPAYRowid),"^",2) 
	..s pblDr=$p(^DHCINDIV(INPAYRowid),"^",3)
	..set digDesc=$s((+AdmInfoDr'=0):$p($g(^DHCINADM(AdmInfoDr)),"^",27),1:"")
	..set INADMCenter=$s((+AdmInfoDr'=0):$p($g(^DHCINADM(AdmInfoDr)),"^",8),1:"")
	..set Center=##class(web.INSUDicDataCom).GetAdmdvsByCode(INADMCenter)
	..set DivSubDr="0"

 	
    ..for  set DivSubDr=$o(^DHCINDIS("0","DivideDr",INPAYRowid,DivSubDr)) quit:DivSubDr=""  do
    
	...//set INSUCode=$p(^DHCINDIS(DivSubDr),"^",8)
	...set InsuDesc=$p(^DHCINDIS(DivSubDr),"^",9)
	...set TarItmDr=$p(^DHCINDIS(DivSubDr),"^",3)
	...set IntctRowid=$o(^DHCINTCT("0","DHCTID",TarItmDr,""),-1)
	...set INSUCode=$p(^DHCINTCT(IntctRowid),"^",5)
	...set TarItmCode=$s((+TarItmDr'=0):$p($g(^DHCTARI(TarItmDr)),"^",1),1:"")
	...set TarItmDesc=$s((+TarItmDr'=0):$p($g(^DHCTARI(TarItmDr)),"^",2),1:"") ///收费名称
	...set Qty=$p(^DHCINDIS(DivSubDr),"^",11)
	...set Price=$fn($p(^DHCINDIS(DivSubDr),"^",11),"",2)
	...set Scale=$p(^DHCINDIS(DivSubDr),"^",15)
	...set Amount=$fn($p(^DHCINDIS(DivSubDr),"^",13),"",2)
	...set Demo1=$fn($p(^DHCINDIS(DivSubDr),"^",26),"",2)
	...set Demo3=$fn($p(^DHCINDIS(DivSubDr),"^",28),"",2)
	...set Self=$fn($p(^DHCINDIS(DivSubDr),"^",17),"",2)
	...set Demo2=$fn($p(^DHCINDIS(DivSubDr),"^",27),"",2)
	...set INSUXMLB=$p(^DHCINDIS(DivSubDr),"^",10)
	...set chrgitmLv00A=""
	...set:INSUXMLB="01" chrgitmLv00A="甲类"
	...set:INSUXMLB="02" chrgitmLv00A="乙类"
	...set:INSUXMLB="03" chrgitmLv00A="丙类"
	...q:(QchrgitmLv00A'="全部")&(QchrgitmLv00A'="")&(QchrgitmLv00A'=chrgitmLv00A)
	...s HZPYInsuDesc=##class(web.DHCINSUPort).GetCNCODE(InsuDesc,3,"")
	
	...q:($$ALPHAUP^SSUTIL4(InsuDesc)'[IDesc)&&(HZPYInsuDesc'[IDesc)&&(HZPYInsuDesc'[InsuKey)&&(InsuDesc'[InsuKey)
	...s HZPYTarItmDesc=##class(web.DHCINSUPort).GetCNCODE(TarItmDesc,3,"")
	...q:($$ALPHAUP^SSUTIL4(TarItmDesc)'[TarDesc)&&(HZPYTarItmDesc'[TarDesc)&&(HZPYTarItmDesc'[TarItemKey)&&(TarItmDesc'[TarItemKey)
	...q:(BillDr'="")&(pblDr'=BillDr)
	...do GetChargeInfoByAdm
 	

	
	
  	Set qHandle=$lb(0,repid,0)
  	Quit $$$OK
GetChargeInfoByAdm
	set Data=$lb(ind,INPAYdjlsh0,INPAYiDate,Center,INPAYzyksmc,INPAYxming0,Medicare,digDesc,INSUCode,InsuDesc,TarItmCode,TarItmDesc,Qty,Price,Scale,Amount,Demo1,Demo3,Self,Demo2,chrgitmLv00A,pblDr)
				
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDivideSubByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDivideSubByAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDivideSubByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDivideSubByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// Creator：      	杨建章
/// CreatDate：    	2010-02-08
/// Description： 	查询发生日期的<交易记录库>信息
/// Table：       	insu_divide,insu_adminfo,pa_adm
/// Input：          CurrDate   发生日期
/// Return：        
/// w ##class(web.DHCINSUDivQue).SetUpDetailsC("2010-02-09")
ClassMethod SetUpDetailsC(CurrDate As %String) As %String
{
	n (CurrDate,JustId)
	s OutStr="-1"
	k ^CacheTemp("INSUUpDetailC",$j)
	q:CurrDate="" OutStr
	s CurrDate=$zdh(CurrDate,3)
	s j=0,k=0,l=0
	s DivDr=""
	f  s DivDr=$o(^DHCINDIV("0","IDate",CurrDate,DivDr)) q:DivDr=""  d
	.s DivInfo=$g(^DHCINDIV(DivDr))
	.s djlsh=$p(DivInfo,"^",8)			;中心交易流水号
	.q:djlsh=""						;单据流水号为空表示此数据位本地结算数据
	.s AdmDr=$p(DivInfo,"^",1)
	.s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) //+ DingSH 20200619
	.s AdmInfoDr=$p(DivInfo,"^",2)
	.s InsuAdmInfo=$g(^DHCINADM(AdmInfoDr))
	.s Flag=$p(DivInfo,"^",5)				//结算状态，I：正常、B：被冲销、S冲销记录，D中间状态
	.q:Flag="D"	
	.i Flag="S"  d
	..s StrikeFlag=2
	.e  s StrikeFlag=1
	.s SYBZ=$p(InsuAdmInfo,"^",40)				;适用医保办法标志
	.s DivType=+$p(DivInfo,"^",11) 		;0挂号或登记，其他结算	
	.q:DivType=0						;排除挂号信息
	.s AdmType=$p(InsuAdmInfo,"^",14)	;01：门诊挂号 02：急诊挂号 03:大病挂号，10：家床建床 20：急观入观 30：入院登记 40:干部保健急观入院  50干部保健入院登记
	.q:(AdmType=20)||(AdmType=30)||(AdmType=40)||(AdmType=50)	;门，急诊，家床
	.s InvPrtDr=+$p(DivInfo,"^",4)
	.s CardNo=$p(DivInfo,"^",18)		;社保卡（医保卡）卡号
	.s AdmDeptDr=$p($g(^PAADM(AdmDr)),"^",4)
	.s AdmDepCode=$p($g(^CTLOC(AdmDeptDr)),"^",1)  
	.s DepStr=$$QueryByCode^DHCINSUDicData("Dep",AdmDepCode,HospDr)
	.s DepCode=$p(DepStr,"^",6)			;科室代码
	.s DepDesc=$p(DepStr,"^",7)			;科室名称
	.s DivTime=$p(DivInfo,"^",17)
	.s DivTime=$zd(CurrDate,8)_"/"_$zt(DivTime)_"/"		;中心交易的时间
	.s DisCode=$p(InsuAdmInfo,"^",45)		;大病编码
	.s DivType=+$p(DivInfo,"^",11) 		;0挂号或登记，其他结算
	.i AdmType="01"  d
	..s DivFlag="120"			;120=门诊结算
	.e  i AdmType="02"   d
	..s DivFlag="220"			;220= 急诊结算
	.e  i AdmType="03"   d
	..	;门诊大病前2位： 31=大病挂号  32=大病结算； 后1位，大病编码
	..s DivFlag="32"_DisCode
	.e  i AdmType="10"  d
	..s:(DivType=0) DivFlag="410"			;410=家床结算 
	.s strBillDr=$$GetBillDrByPRTINVDRSwitch^DHCINSUFacade(InvPrtDr)
	.s BillNum=$p(strBillDr,"^",2)
	.f k=1:1:BillNum d
	..s PBDr=$p($p(strBillDr,"^",1),"!",k)
	..q:PBDr=""
	..d ..GetBillInfo(PBDr,"TOC")
	..s l=0
	..f  s l=$o(^CacheTemp("UpDetailCE",$j,PBDr,l)) q:l=""  d
	...s j=j+1
	...s tmpStr=^CacheTemp("UpDetailCE",$j,PBDr,l)
	...s ^CacheTemp("INSUUpDetailC",$j,j)=djlsh_"^"_CardNo_"^"_DepCode_"^"_DepDesc_"^"_tmpStr_"^"_DivTime_"^"_SYBZ_"^"_DivFlag_"^"_StrikeFlag
	...s l=l+1
	q j
}

ClassMethod GetUpDetailsCTmp(JustId As %String, Index As %String) As %String
{
	s OutStr=^CacheTemp("INSUUpDetailC",JustId,Index)
	q OutStr
}

/// Creator：      	杨建章
/// CreatDate：    	2010-02-08
/// Description： 	查询发生日期的<交易记录库>信息
/// Table：       	insu_divide,insu_adminfo,pa_adm
/// Input：          CurrDate   发生日期
/// Return：        
/// w ##class(web.DHCINSUDivQue).SetUpDetailsE("2010-02-09")
ClassMethod SetUpDetailsE(CurrDate As %String) As %String
{
	n (CurrDate,JustId)
	s OutStr="-1"
	k ^CacheTemp("INSUUpDetailE",$j)
	q:CurrDate="" OutStr
	s CurrDate=$zdh(CurrDate,3)
	s j=0,k=0,l=0
	s DivDr=""   ;,DivFlag=""
	f  s DivDr=$o(^DHCINDIV("0","IDate",CurrDate,DivDr)) q:DivDr=""  d
	.s DivInfo=$g(^DHCINDIV(DivDr))
	.s djlsh=$p(DivInfo,"^",8)			;中心交易流水号
	.q:djlsh=""						;单据流水号为空表示此数据位本地结算数据
	.s AdmDr=$p(DivInfo,"^",1)
	.s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) //+ DingSH 20200619
	.s AdmInfoDr=$p(DivInfo,"^",2)
	.s InsuAdmInfo=$g(^DHCINADM(AdmInfoDr))
	.s Flag=$p(DivInfo,"^",5)				//结算状态，I：正常、B：被冲销、S冲销记录，D中间状态
	.q:Flag="D"	
	.i Flag="S"  d
	..s StrikeFlag=2
	.e  s StrikeFlag=1
	.s SYBZ=$p(InsuAdmInfo,"^",40)				;适用医保办法标志
	.s DivType=+$p(DivInfo,"^",11) 		;0挂号或登记，其他结算	
	.q:DivType=0						;排除挂号信息
	.s AdmType=$p(InsuAdmInfo,"^",14)	;01：门诊挂号 02：急诊挂号 03:大病挂号，10：家床建床 20：急观入观 30：入院登记 40:干部保健急观入院  50干部保健入院登记
	.q:((AdmType'=20)&(AdmType'=30)&(AdmType'=40)&(AdmType'=50))		;门，急诊，家床
	.s InvPrtDr=+$p(DivInfo,"^",4)
	.s CardNo=$p(DivInfo,"^",18)		;社保卡（医保卡）卡号
	.s AdmDeptDr=$p($g(^PAADM(AdmDr)),"^",4)
	.s AdmDepCode=$p($g(^CTLOC(AdmDeptDr)),"^",1)  
	.s DepStr=$$QueryByCode^DHCINSUDicData("Dep",AdmDepCode,HospDr)
	.s DepCode=$p(DepStr,"^",6)			;科室代码
	.s DepDesc=$p(DepStr,"^",7)			;科室名称
	.s DivTime=$p(DivInfo,"^",17)
	.s DivTime=$zd(CurrDate,8)_"/"_$zt(DivTime)_"/"		;中心交易的时间
	.s DisCode=$p(InsuAdmInfo,"^",45)		;大病编码
	.s DivType=+$p(DivInfo,"^",11) 		;0挂号或登记，其他结算
	.w !,"AdmType=",AdmType
	.i (AdmType="20")||(AdmType="40")  d
	..s:(DivType'=0) DivFlag="510"			;510=急观结算
	.e  i (AdmType="30")||(AdmType="50")  d
	..s:(DivType'=0) DivFlag="610"			;610=住院结算
	.s PBDr=$p(DivInfo,"^",3)			;账单号
	.q:PBDr=""
	.d ..GetBillInfo(PBDr,"TIC")
	.s l=0
	.f  s l=$o(^CacheTemp("UpDetailCE",$j,PBDr,l)) q:l=""  d
	..s j=j+1
	..s tmpStr=^CacheTemp("UpDetailCE",$j,PBDr,l)
	..s ^CacheTemp("INSUUpDetailE",$j,j)=djlsh_"^"_CardNo_"^"_DepCode_"^"_DepDesc_"^"_tmpStr_"^"_DivTime_"^"_SYBZ_"^"_DivFlag_"^"_StrikeFlag
	..s l=l+1
	q j
}

ClassMethod GetUpDetailsETmp(JustId As %String, Index As %String) As %String
{
	s OutStr=^CacheTemp("INSUUpDetailE",JustId,Index)
	q OutStr
}

/// w ##class(web.DHCINSUDivQue).GetBillInfo(199162,"TOC")
ClassMethod GetBillInfo(PBDr As %String, CateType As %String) As %String
{
	n (PBDr,CateType)
	q:PBDr="" ""
	k ^CacheTemp("UpDetailCE",$j)
	k ^CacheTemp("PreScNo",$j)
	s i=0,n=1,INDISDr=0
	s AdmDr =$P(^DHCPB(+PBDr),"^",1)
	s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) //+ DingSH 20200619
	f  s INDISDr=$o(^DHCINDIS("0","PBDr",PBDr,INDISDr)) q:INDISDr=""  d
	.s DoctorCode="",DoctorName="",Cate="",InsuCode="",InsuDesc="",Uom=0,UnitPrice=0,Qty=0,TotalAmount=0,FundAmount=0,YBAmount=0,YBFlag=""
	.s INDISStr=$g(^DHCINDIS(INDISDr))
	.s OEORDRowid=$p(INDISStr,"^",5)
	.s PreScNo=+$p($g(^OEORD(+OEORDRowid,"I",$p(OEORDRowid,"||",2),1)),"^",14)		//处方号
	.s DoctDr=$p($g(^OEORD(+OEORDRowid,"I",$p(OEORDRowid,"||",2),1)),"^",11)		//是否为这个字段？？
	.i DoctDr=""    d
	..s DoctorCode="ZZZZZZ"				;;医生工号:目前没有医嘱医生的以字母Z补齐六位
	.e              d
	..s DoctorCode=$p($g(^CTPCP(DoctDr,3)),"^",11)			;医生工号???????
	..s DoctorName=$p($g(^CTPCP(DoctDr,1)),"^",2)			;医生姓名
	.s InsuItmDr=$p(INDISStr,"^",4)
	.s AdmDr=$p($g(^DHCPB(PBDr)),"^",1)
	.s Cate=$p(INDISStr,"^",14)
	.i CateType="TOC"   d
	..s CateStr=$$QueryByCode^DHCINSUDicData("CateTypeOP",Cate,HospDr)
	..s Cate=$p(CateStr,"^",6)
	.e                  d
	..s CateStr=$$QueryByCode^DHCINSUDicData("CateTypeIP",Cate,HospDr)
	..s Cate=$p(CateStr,"^",6)
	.i InsuItmDr=""			d
	..s InsuCode="ZZZZZZZZZZZZZZZ"
	.e                      d
	..s InsuCode=$p(INDISStr,"^",8)					;明细项目编码
	..s InsuDesc=$p(INDISStr,"^",9)					;明细项目名称
	..s Uom=$p($g(^DHCINTIM(InsuItmDr)),"^",10)		;明细项目单位
	.s UnitPrice=+$p(INDISStr,"^",12)					;明细项目单价	11	数字格式I
	.s Qty=+$p(INDISStr,"^",11)							;明细项目数量	9	数字格式K
	.s TotalAmount=+$p(INDISStr,"^",13)				;;明细项目金额	11	数字格式I
	.s FundAmount=+$p(INDISStr,"^",16)					;;明细项目交易费用金额	11	数字格式I
	.s YBFlag=$p(INDISStr,"^",24)						;报销标志
	.s YBAmount=+$p(INDISStr,"^",26)					;;明细项目医保结算范围金额	11	数字格式I
	.s ^CacheTemp("UpDetailCE",$j,PBDr,i)=DoctorCode_"^"_DoctorName_"^"_Cate_"^"_InsuCode_"^"_InsuDesc_"^"_Uom_"^"_UnitPrice_"^"_Qty_"^"_TotalAmount_"^"_FundAmount_"^"_YBAmount_"^"_YBFlag
	.q:CateType="TIC"
	.i $g(^CacheTemp("PreScNo",$j,PreScNo))=""   d
	..s ^CacheTemp("PreScNo",$j,PreScNo)=n
	..s n=n+1
	..s $p(^CacheTemp("UpDetailCE",$j,PBDr,i),"^",2)=$p(^CacheTemp("UpDetailCE",$j,PBDr,i),"^",2)_"^"_n
	.e                                          d
	..s $p(^CacheTemp("UpDetailCE",$j,PBDr,i),"^",2)=$p(^CacheTemp("UpDetailCE",$j,PBDr,i),"^",2)_"^"_n
	.s i=i+1
}

/// Creator：      	杨建章
/// CreatDate：    	2010-03-08
/// Description： 	
/// Table：       	insu_divide,insu_adminfo,pa_adm
/// Input：          CurrDate   发生日期
/// Return：        
ClassMethod GetGBOPRegInfo(CurrDate As %String) As %String
{
	n (CurrDate)
	s OutStr="-1"
	q:(CurrDate)="" OutStr
	s CurrDate=$zdh(CurrDate,3)
	s DivDr=""
	
	

	f  s DivDr=$o(^DHCINDIV("0","IDate",CurrDate,DivDr)) q:DivDr=""  d
	.s djlsh=$p(DivInfo,"^",8)			;中心交易流水号	16	交易确认应答返回的流水号
	.q:djlsh=""						;单据流水号为空表示此数据位本地结算数据
	.s Zstr01=$p(DivInfo,"^",1)		;挂号还是收费的分解标识
	.q:(Zstr01="F")
	.s AdmDr=$p(DivInfo,"^",1)
	.s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) //+ DingSH 20200619
	.s AdmNo=$p($g(^PAADM(AdmDr)),"^",81)
	.s AdmInfoDr=$p(DivInfo,"^",2)
	.s InsuAdmInfo=$g(^DHCINADM(AdmInfoDr))
	.s SYBZ=$p(InsuAdmInfo,"^",40)				;适用医保办法标志
	.s SeriNo=$p(InsuAdmInfo,"^",10)
	.s Flag=$p(DivInfo,"^",5)				//结算状态，I：正常、B：被冲销、S冲销记录，D中间状态
	.q:Flag="D"	
	
	;门急诊流水号
	;保健号
	;社保卡号
	;门急诊号
	;就诊时间
	;门急诊标识
	;科室名称
	;挂号费
	;诊疗费
	;医保基金支付
	;干保统筹金支付
	;特殊医疗费用
	;个人现金支付
	;费用性质
	;付费性质
	;个人现金支付比例
	;大病项目
	;医生姓名
	;转诊标志
	;门诊诊断
	;退款标志
	;结算流水号

	.i Flag="S"  d
	..s StrikeFlag=2
	.e  s StrikeFlag=1
	.s PBDr=+$p(DivInfo,"^",3)			;账单号
	.s InvPrtDr=+$p(DivInfo,"^",4)
	.s RefDiv=$p(DivInfo,"^",6)			//被冲销
	.s TotalAmount=+$p(DivInfo,"^",7)		//总费用
	.s Zhzfe=$p(DivInfo,"^",28)			//账户支付
	.s Jjzfe=$p(DivInfo,"^",19)			//统筹支付，基金支付
	.s SelfPay=+$p(DivInfo,"^",15)			//现金支付
	.s InsuId=$p(DivInfo,"^",18)			//医保号，个人编号
	.s JYFYZE=+$p(DivInfo,"^",51)		;交易费用总额	10	数字格式H
	.s DNZHZF=+$p(DivInfo,"^",56)			;当年帐户支付数：门急诊	10	数字格式H
	.s LNZHZF=+$p(DivInfo,"^",57)		;历年帐户支付数：门急诊 除镇保外	10	数字格式H
	.s QFX=+$p(DivInfo,"^",61)	;起付段现金支付数/自负段现金支付数(门)
	.s QFDZH=+$p(DivInfo,"^",58)		;起付段帐户支付数：住院、急观，除镇保外	10	数字格式H
	.s TCDXJ=+$p(DivInfo,"^",62)		;统筹段现金支付数：住院、急观、家床、大病、个保门急诊 、（居民医保、医疗互助帮困对象） 三类参保人员门急诊	10	数字格式H
	.s TCDZH=+$p(DivInfo,"^",59)		;统筹段帐户支付数：住院、急观、家床、大病，除镇保外	10	数字格式H
	.s TC=+$p(DivInfo,"^",31)			;统筹支付数：住院、急观、家床、大病、个保门急诊、（居民医保、医疗互助帮困对象） 三类参保人员门急诊	10	数字格式H
	.s FJDXJ=+$p(DivInfo,"^",63)		;附加段现金支付数：除个保外	10	数字格式H
	.s FJDZH=+$p(DivInfo,"^",60)		;附加段帐户支付数：除门急诊、个保外，除镇保外	10	数字格式H
	.s FJD=+$p(DivInfo,"^",32)			;地方附加支付数：除个保外，除镇保外	10	数字格式H
	.s YBFW=+$p(DivInfo,"^",52)			;医保结算范围费用总额	10	数字格式H
	.s FYB=+$p(DivInfo,"^",53)			;非医保结算范围个人自费	10	数字格式H	
	.s AdmDeptDr=+$p($g(^PAADM(AdmDr)),"^",4)
	.s AdmDepCode=$p($g(^CTLOC(AdmDeptDr)),"^",1)  
	.s DepStr=$$QueryByCode^DHCINSUDicData("Dep",AdmDepCode,HospDr)
	.s DepCode=$p(DepStr,"^",6)			;科室代码
	.s DepDesc=$p(DepStr,"^",7)			;科室名称
	.s CardNo=$p(DivInfo,"^",18)		;社保卡（医保卡）卡号	10	
	.s ZHBZ=$p(InsuAdmInfo,"^",43)		;帐户标志	16	
	.
	.s PatType=$p(InsuAdmInfo,"^",4)	;病人类型	1	0：一般病人  1：工伤  2：职业病5:造血干细胞移植治疗
	.s AdmType=$p(InsuAdmInfo,"^",14)	;01：门诊挂号 02：急诊挂号 03:大病挂号，10：家床建床 20：急观入观 30：入院登记 40:干部保健急观入院  50干部保健入院登记
	.s DisCode=$p(InsuAdmInfo,"^",45)		;大病编码
	.s DivType=+$p(DivInfo,"^",11) 		;0挂号或登记，其他结算
	.s tmpCYBZ=+$p(DivInfo,"^",52)			;出院标志，0标志出院结算 1表示在院结算
	.i tmpCYBZ=0            d 
	..s CYBZ=1
	.e                   d
	..s CYBZ=2
	.;b
	.i AdmType="01"  d
	..s ZFDXJ=QFX
	..i DivType=0   d
	...s DivFlag="110"			;110=门诊挂号
	...s ZYTS=1
	...;s INVNO=..GetRegInvNo(AdmDr)
	..i DivType'=0  d
	...s DivFlag="120"			;120=门诊结算
	...s ZYTS=0
	.e  i AdmType="02"   d
	..s ZFDXJ=QFX
	..i DivType=0 d
	...s DivFlag="210"			;210=急诊挂号
	...s ZYTS=1
	...;s INVNO=..GetRegInvNo(AdmDr)
	..i DivType'=0 d
	...s DivFlag="220"			;220= 急诊结算
	...s ZYTS=0
	.e  i AdmType="03"   d
	..s ZFDXJ=QFX
	..	;门诊大病前2位： 31=大病挂号  32=大病结算； 后1位，大病编码
	..i DivType=0 d
	...s DivFlag="31"_DisCode
	...s ZYTS=1
	...;s INVNO=..GetRegInvNo(AdmDr)
	..i DivType'=0 d
	...s DivFlag="32"_DisCode
	...s ZYTS=0
	.e  i AdmType="10"  d
	..s ZFDXJ=QFX
	..s:(DivType=0) DivFlag="410"			;410=家床结算 
	..s ZYTS=0
	.e  i (AdmType="20")||(AdmType="40")  d
	..s QFDXJ=QFX
	..s DivFlag="510"			;510=急观结算
	..s JZBZ=2
	.e  i (AdmType="30")||(AdmType="50")  d
	..s QFDXJ=QFX
	..s DivFlag="610"			;610=住院结算
	..s JZBZ=1
	..s ZYH=AdmNo
	..s InDiag=$$GetInDiag^DHCINSUPatInfo(AdmDr)
	..s InDiagCode=$p(InDiag,"^",3)
	..s InDiagDesc=$p(InDiag,"^",4)
	..s OutDiag=$$GetOutDiag^DHCINSUPatInfo(AdmDr)
	..s OutDiagCode=$p(OutDiag,"^",3)
	..s OutDiagDesc=$p(OutDiag,"^",4)
	..s PBDateTo=$p($g(^DHCPB(PBDr)),"^",7)
	..s PBDateTo=$zd(+PBDateTo,3)
	..
	.i InvPrtDr>0  d
	..s INVNO=$p($g(^DHCINVPRT(InvPrtDr)),"^",14)	;门诊发票号
	..s StartDate=$zd($p(InsuAdmInfo,"^",12),8)
	.e             d
	..s InvPrtDr=$o(^DHCINVPRTZY(0,"AR",PBDr,""))
	..i InvPrtDr="" s INVNO=""  
	..e  s INVNO=$p($g(^DHCINVPRTZY(InvPrtDr)),"^",1)	;住院发票号
	..s StartDate=$zd($p($g(^DHCPB(PBDr)),"^",6),8)
	.
	.s DivTime=$p(DivInfo,"^",17)
	.s DivTime=$zd(CurrDate,8)_"/"_$tr($zt(DivTime),":")_"/"		;中心交易的时间
	.;w !,"DivDr=",DivDr,",InvPrtDr=",INVNO
	.s TmpStr=djlsh_"^"_HospCode_"^"_CardNo_"^"_ZHBZ_"^"_PatType_"^"_ZYTS_"^"_DivTime_"^"_DivFlag_"^"_JYFYZE_"^"_DNZHZF_"^"_LNZHZF_"^"_ZFDXJ
	.s TmpStr=TmpStr_"^"_QFDXJ_"^"_QFDZH_"^"_TCDXJ_"^"_TCDZH_"^"_TC_"^"_FJDXJ_"^"_FJDZH_"^"_FJD_"^"_YBFW_"^"_FYB_"^"_SYBZ_"^"_INVNO_"^"_StrikeFlag_"^"_StartDate
	.s TmpStr=TmpStr_"!"_DepCode_"!"_DepDesc_"!"_SeriNo_"!"_AdmNo_"!"_InDiagCode_"!"_InDiagDesc_"!"_OutDiagCode_"!"_OutDiagDesc_"!"_PBDateTo_"!"_JZBZ_"!"_CYBZ
	.s ^CacheTemp("INSUUpDetailA",$j,i)=TmpStr
	.s i=i+1
	q i-1_"^"_$j
}

/// Creator：      	张东亮
/// CreatDate：    	2009-09-21
/// Description： 	按月份和科室输出医保费用信息
/// Table：       	
/// Input：          
/// 		StartDate：	查询开始时间
/// 		EndDate：	查询结束时间
/// 		Type：		医保类别（A作废，S无效，I有效）,
/// 		CtLoc:		科室名称
/// 		MedType：	医疗类别例如普通住院
/// 		PatType1：	病人类型
/// 		IsGwy1：	公务员标志
/// 		IsBjdx1：	保健对象标志
/// 		
/// Output：
/// 			CtLocDesc：	科室名称
/// 			Times：		就诊人次
/// 			TotalAmount：总计费用
/// 			Zhzfe：		账户支付
/// 			Jjzfe：		统筹支付
/// 			SelfPay：	现金支付
/// 			Grzfe：		个人支付
/// 			InsuPay1：	救助金支出
/// 			InsuPay2：	公务员补助
/// 			InsuPay3：	保健对象补贴
/// 			InsuPay4：	离休统筹
/// 			InsuPay5：	医院负担
/// 			InsuPay6：	工伤基金
/// 			InsuPay7：	生育基金
/// 			AvgTotal：	均次费用		         
/// 		
/// Return：         null
/// Others：		d ##class(%ResultSet).RunQuery("web.DHCINSUDivQue","QueryGROPDivDesInfo","62367","62377")
Query QueryGROPDivDesInfo(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "Ti,TPatName,TINPAYiDateTime,TReINPAYiDateTime,TDjlsh,TINADMInsuId,TTotalAmount,TSelfPay,TZhzfe,TTC,TINPAYptbctsDesc,TJob")
{
}

ClassMethod QueryGROPDivDesInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)

 	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

ReportBy
    ;s ind=1
    set Data=$lb(i,PatName,INPAYiDateTime,ReINPAYiDateTime,Djlsh,INADMInsuId,TotalAmount,SelfPay,Zhzfe,TC,INPAYptbctsDesc,$j)
 	Set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	q
}

ClassMethod QueryGROPDivDesInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGROPDivDesInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryGROPDivDesInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGROPDivDesInfoExecute ]
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

/// d ##class(%ResultSet).RunQuery("web.DHCINSUDivQue","QGROPDivResInfo","62367","62377")
Query QGROPDivResInfo(StartDate As %String, EndDate As %String, HospDr As %String) As %Query(ROWSPEC = "Ti,TPatName,TINPAYiDateTime,TReINPAYiDateTime,TDjlsh,TINADMInsuId,TTotalAmount,TSelfPay,TZhzfe,TTC,TptbctsDesc,TJob")
{
}

ClassMethod QGROPDivResInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	
 	s rnt=1
 	;s StartDate="62367"
 	;s EndDate="62377"
 	s iDate=StartDate-1
 	s i=0
 	
 	k ^TMPINSUDiv("Div")
 	
 	f  s iDate=$o(^DHCINDIV("0","IDate",iDate)) q:(iDate="")!(iDate>EndDate)  d
	.s DivDr=""
	.f  s DivDr=$o(^DHCINDIV("0","IDate",iDate,DivDr)) q:DivDr=""  d
	..;w iDate_"^"_DivDr,!
	..s tHospDr = $P(^DHCINDIV(DivDr),"^",71) //+ DingSH 20200619
	..q:(HospDr'="")&&(tHospDr'=HospDr)
	..d GetDivDetails(DivDr)
	..q:rnt=1
	..d OutputRow 
	
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRow
	set Data=$lb(i,PatName,INPAYiDateTime,ReINPAYiDateTime,Djlsh,INADMInsuId,TotalAmount,SelfPay,Zhzfe,TC,INPAYptbctsDesc,$j)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	
	
GetDivDetails(DivDr)
	s rnt=1
	s INPAYptbctsDesc="否"
	s Dw=""
	s DivInfo=$g(^DHCINDIV(DivDr))
	s Flag=$p(DivInfo,"^",5)
	q:Flag'="S"										// 取消结算标志
	s INPAYptbcts=$p(DivInfo,"^",20)				//隔日退费标志
	q:(INPAYptbcts'="1")
	//以下是找寻隔日冲销时的数据
	s ReINPAYiDate=$zd($p(DivInfo,"^",16),3)					//操作日期	取消结算日期
	s ReINPAYiTime=$zt($p(DivInfo,"^",17),1)					//操作时间	取消结算时间
	s RefDiv=$p(DivInfo,"^",6)
	s DivInfo=$g(^DHCINDIV(RefDiv))

	//以下是对应的被冲销的信息
	s AdmDr=$p(DivInfo,"^",1) 
	s PaPmiId=$p($p($g(^PAADM(AdmDr)),"^",1),$c(1))
   	s RegNo=$p($g(^PAPER(PaPmiId,"PAT",1)),"^",1)
   	s PatName=$p(^PAPER(PaPmiId,"ALL"),"^",1) 		//HIS姓名
    s AdmInfoDr=$p(DivInfo,"^",2)
	s InsuAdmInfo=$g(^DHCINADM(AdmInfoDr))	
	s INADMInsuId=$p(InsuAdmInfo,"^",2)				//医保号  大学生身份证号当做医保号							
	s TotalAmount=+$p(DivInfo,"^",7)				//总费用
	s Djlsh=$p(DivInfo,"^",8)						//单据流水号
	s SelfPay=+$p(DivInfo,"^",15)				    //个人现金支付额
	S INPAYiDate=$zd($p(DivInfo,"^",16),3)					//操作日期	结算日期
	S INPAYiTime=$zt($p(DivInfo,"^",17),1)					//操作时间	结算时间
	;s InsuId=$p(DivInfo,"^",18)					//医保号
	s Jjzfe=$p(DivInfo,"^",19)						//医保内费用
	s PatInsuName=$p(DivInfo,"^",27)				//医保卡姓名
	s Zhzfe=$p(DivInfo,"^",28)						//帐户支付额
	s INPAYZstr02=$p(DivInfo,"^",37)				//（门诊/住院）IP/OP    
	s InsuType=$p(InsuAdmInfo,"^",18)				
	//q:(InsuType'="WHA")
	s INADMXString16=$p(InsuAdmInfo,"^",45)	
	q:(INADMXString16'="OP")
	
	s TC= Jjzfe-Zhzfe								//统筹支付，医保支付-账户支付
	s INPAYiDateTime=INPAYiDate_" "_INPAYiTime				//结算日期时间
	s ReINPAYiDateTime=ReINPAYiDate_" "_ReINPAYiTime		//取消结算日期时间
	
	;2011-03-14
	s TmpDate=+$p(ReINPAYiDate,"-",2)-(+$p(INPAYiDate,"-",2))>0 
	i TmpDate>0  d
	.s INPAYptbctsDesc="跨月"
	

	s i=i+1  
	; 序号  his姓名     结算日期时间       取消结算日期时      结算流水号    医保号         总金额          现金支付  账户支付  统筹       是否跨月
	;w !,i_"^"_PatName_"^"_INPAYiDateTime_"^"_ReINPAYiDateTime_"^"_Djlsh_"^"_INADMInsuId_"^"_TotalAmount_"^"_SelfPay_"^"_Zhzfe_"^"_TC_"^"_INPAYptbctsDesc_"^"_$j	
	s ^TMPINSUDiv("Div",$j,i)=i_"^"_PatName_"^"_INPAYiDateTime_"^"_ReINPAYiDateTime_"^"_Djlsh_"^"_INADMInsuId_"^"_TotalAmount_"^"_SelfPay_"^"_Zhzfe_"^"_TC_"^"_INPAYptbctsDesc_"^"_$j	
 	s rnt=0
 	q
}

ClassMethod QGROPDivResInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QGROPDivResInfoExecute ]
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

ClassMethod QGROPDivResInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QGROPDivResInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryDivideForExClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDivideForExExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCINSUDivQue","QueryDivideForEx","2020-10-14","2020-10-14","","","","","","I","","ZZB",2)
ClassMethod QueryDivideForExExecute(ByRef qHandle As %Binary, StartDate As %Library.Date, EndDate As %Library.Date, RegNO As %String, PrtNO As %String, PrtInv As %String, TradeNO As %String, InsuNO As %String, HisType As %String, BillDr As %String, InsuDllType As %String, HospDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	;s ^hxc(123)=StartDate_"&"_EndDate_"&"_RegNO_"&"_TradeNO_"&"_InsuDllType
	s:(HospDr="")&&(%session'="") HospDr=%session.Data("LOGON.HOSPID")
	s ^CacheTemp("QueryDivideForEx")=StartDate_"&"_EndDate_"&"_RegNO_"&"_PrtNO_"&"_PrtInv_"&"_TradeNO_"&"_InsuNO_"&"_HisType_"&"_BillDr_"&"_InsuDllType_"&"_HospDr
	s snodeind=$i(^Temp("AdmInfoEX"))
	set:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	set:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	;k ^Temp("AdmInfoEX")
	s ^Temp("AdmInfoEX",snodeind)="登记Rowid^登记流水号^医保卡号^费别id"
	s ^Temp("AdmInfoEXtmp",snodeind)=""
	;b ;00
	s ind=1
	s DivDr=""
	s DivDDr=""
	s num1=0,num2=0
	s PaadmDr=""
	s DivIdate=""
	s PaadmType=""
	s RegDr=""
	s PrtDr=""
	s (TName,THisType,TAdmReason,TBillNO,TRegNO,TPrtNO,TPatType,TPaadm,TDivDr,TDivFlag,TDHCJFFlag,Tbcbxf0,Tdjlsh0,Tidate,Tgrzf0,Tzhzfe0,Tzylsh0,Tpay1,Tpay2,Tpay3,Tpay4,Tpay5,Tpay6,Tpay7,Tpay8,Tpay9,Tpay10,tHospDr)=""
	i TradeNO'=""  d    ;先行判断交易流水号,不为空时，其他条件不考虑
	.f  s DivDr=$o(^DHCINDIV("0","Djlsh0",TradeNO,DivDr)) q:DivDr=""  d
	..s tHospDr = $P(^DHCINDIV(DivDr),"^",71) ;//+ DingSH 20200619 
	..q:(HospDr'="")&&(tHospDr'=HospDr)
	..d GetInfo(DivDr)
	..d BuildInfoDiv
	
	i PrtNO'="" d   ;判断发票的rowid 
	.;s TDHCJFFlag=$p($g(^DHCINVPRT(PrtNO)),"^",8)   ;计费组发票状态：Normal,Abort,Strike,ToPaid
	.f  s DivDr=$o(^DHCINDIV("0","DHCInvPrt",PrtNO,DivDr)) q:DivDr=""  d
	..s tHospDr = $P(^DHCINDIV(DivDr),"^",71) ;//+ DingSH 20200619 
	..q:(HospDr'="")&&(tHospDr'=HospDr)
	..d GetInfo(DivDr)
	..d BuildInfoDiv
	
	i (PrtNO="")&&(PrtInv'="") d 
	.f  s PrtDr=$o(^DHCINVPRT("0","INV",PrtInv,PrtDr)) q:PrtDr=""  d
	..f  s DivDr=$o(^DHCINDIV("0","DHCInvPrt",PrtDr,DivDr)) q:DivDr=""  d
	..s tHospDr = $P(^DHCINDIV(DivDr),"^",71) ;//+ DingSH 20200619 
	..q:(HospDr'="")&&(tHospDr'=HospDr)
	...d GetInfo(DivDr)
	...d BuildInfoDiv
	
	i BillDr'="" d   ;判断发票的rowid 
	.;s TDHCJFFlag=$p($g(^DHCINVPRT(PrtNO)),"^",8)   ;计费组发票状态：Normal,Abort,Strike,ToPaid
	.f  s DivDr=$o(^DHCINDIV("0","DHCPB",BillDr,DivDr)) q:DivDr=""  d
	..s tHospDr = $P(^DHCINDIV(DivDr),"^",71) ;//+ DingSH 20200619 
	..q:(HospDr'="")&&(tHospDr'=HospDr)
	..d GetInfo(DivDr)
	..d BuildInfoDiv
	
	i InsuNO'="" d 
	.f  s DivDr=$o(^DHCINDIV("0","ID0000",InsuNO,DivDr)) q:DivDr=""  d
	..s tHospDr = $P(^DHCINDIV(DivDr),"^",71) ;//+ DingSH 20200619 
	..q:(HospDr'="")&&(tHospDr'=HospDr)
	..d GetInfo(DivDr)
	..d BuildInfoDiv
	
	i (PrtNO="")&&(PrtInv="")&&(TradeNO="")&&(InsuNO="")&&(RegNO'="")  d
	.f  s RegDr=$o(^PAPERi("PAPMI_PatNo",RegNO,RegDr)) q:RegDr=""  d
	..f  s PaadmType=$o(^PAPERdr(RegDr,"ADM",PaadmType)) q:PaadmType=""  d
	...f  s PaadmDr=$o(^PAPERdr(RegDr,"ADM",PaadmType,PaadmDr))  q:PaadmDr=""  d
	....f  s DivDr=$o(^DHCINDIV("0","Paadm",PaadmDr,DivDr))  q:DivDr=""  d
	.....s tHospDr = $P(^DHCINDIV(DivDr),"^",71) ;//+ DingSH 20200619 
	.....q:(HospDr'="")&&(tHospDr'=HospDr)
	.....s DivIdate=$p(^DHCINDIV(DivDr),"^",16)
	.....q:DivIdate>EndDate
	.....q:DivIdate<StartDate
	.....d GetInfo(DivDr)
	.....d BuildInfoDiv	
	
	
	i (PrtNO="")&&(PrtInv="")&&(PrtInv="")&&(TradeNO="")&(RegNO="")&&(InsuNO="")  d
	.f num1=StartDate:1:EndDate d
	..f  s DivDr=$o(^DHCINDIV("0","IDate",num1,DivDr)) q:DivDr=""  d
	...s tHospDr = $P(^DHCINDIV(DivDr),"^",71) ;//+ DingSH 20200619 
	...q:(HospDr'="")&&(tHospDr'=HospDr)
	...s TPrtNO=$p(^DHCINDIV(DivDr),"^",4)
	...s TBillNO=$p(^DHCINDIV(DivDr),"^",3) 
	...s TDivFlag=$p(^DHCINDIV(DivDr),"^",5)
	...s Id0000=$p(^DHCINDIV(DivDr),"^",18)
	...s Tbcbxf0=$p(^DHCINDIV(DivDr),"^",7)
	...;q:TDivFlag'="I"

	...d GetInfo(DivDr)
	...d BuildInfoDiv
	
	...;i (TPrtNO="")&&(TBillNO="") d        ;正常结算记录中，无帐单id，帐单id,视为异常数据
	....;d GetInfo(DivDr)
	....;d BuildInfoDiv
	...;e  d   ;当存在不为空时，找到此记录，看His是否存在
	....;i TPrtNO'="" d
	.....;i $d(^DHCINVPRT(TPrtNO))="" d
	......;d GetInfo(DivDr)
	......;d BuildInfoDiv
	....;e  d
	.....;i $d(^DHCPB(TBillNO))="" d
	......;d GetInfo(DivDr)
	......;d BuildInfoDiv
	//w !,"<script type='text/javascript'>var repidsub="_snodeind_"</script>"  tangzf 2019-5-19 HISUI 不能正常加载
	;s liststr=""
	;s:$d(^Temp("AdmInfoEX",snodeind)) liststr=^Temp("AdmInfoEX",snodeind)
	;s rtnval="GetAdmInfoList('"_$ZCVT(liststr,"O","JS")_"');"
	;&javascript<#(rtnval)#>
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildInfoDiv  
	//s Zstr01=$p(^DHCINDIV(DivDr),"^",36)
	//q:Zstr01="W" ;院外垫付不显示 //tangzf 2019-9-10 +
	s DivType=$p(^DHCINDIV(DivDr),"^",36) ;R:挂号 F:收费 H：体检 +DingSH 20201019
	q:DivType="W"

	q:((TDHCJFFlag="P")||(TDHCJFFlag="N"))&&(TDivFlag="I")
	q:($p(AdmInfo,"^",18)'=InsuDllType)&(InsuDllType'="")
	;i HisType'="I" q:THisType="住院"
	;i HisType="I" q:THisType'="住院"
	q:HisType=""
	q:(HisType="O")&&(THisType="住院") ;tangzf 2019-7-2 门诊 只查询门急诊数据
	q:(PaadmType="I")&(HisType'="I")
	q:(THisType'="住院")&(HisType="I")
	;q:(TDivFlag="S")
	//^DHCPEINVPRT(0,"REF",{PRT_REFINV_DR},{PRT_ROWID})

	
	;门诊	
	;q:(TDHCJFFlag="N")&&(TDivFlag="I")  ;门诊正常 
	q:(TDHCJFFlag="A")&&(TDivFlag="B")	;冲红，作废
	q:(TDHCJFFlag="S")&&(TDivFlag="B")
	q:((TPrtNO="")&&(HisType'="I"))&&(TDivFlag="D")
	q:(TDHCJFFlag'="N")&&(TDHCJFFlag'="P")&&((TDivFlag="B")||(TDivFlag="S"))
	q:((TBillNO="")&&(HisType="I"))&&(TDivFlag="D")
	;q:(TDHCJFFlag="P")&&(TDivFlag="I")  ;住院正常
	q:(TDHCJFFlag="B")&&(TDivFlag="D")	;住院预结
	q:(TDHCJFFlag="R")&&(TDivFlag="S")	;住院取消结算
	;q:(TDHCJFFlag="N")&&(TDivFlag="")
	q:(TDHCJFFlag'="N")&&(TDHCJFFlag'="P")&&(TDivFlag'="I")
    q:(PBRefundFlag="B")&&((TDivFlag="B")||(TDivFlag="S")) //+DingSH 20201022
	b ;002
	s:TDivFlag="I" TDivFlag="正常"
	s:TDivFlag="B" TDivFlag="红冲"
	s:TDivFlag="D" TDivFlag="结算未确认"
	s:TDivFlag="S" TDivFlag="取消结算"
	s TPatType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKC021"_$p(AdmInfo,"^",18),TPatType,4,tHospDr)

	s:TDHCJFFlag="N" TDHCJFFlag="正常"
	s:TDHCJFFlag="A" TDHCJFFlag="取消"
	s:TDHCJFFlag="S" TDHCJFFlag="红冲"
	s:TDHCJFFlag="TP" TDHCJFFlag="待确认"
    s:(HisType="I")&&(TDHCJFFlag="B") TDHCJFFlag="未结算"
	s:(TDHCJFFlag="B") TDHCJFFlag="被冲"

	s:TDHCJFFlag="P" TDHCJFFlag="结算"
 	set Data=$lb(TName,THisType,TRegNO,TPrtNO,TPatType,TPaadm,TDivDr,TDivFlag,$fn(Tbcbxf0,"",2),Tdjlsh0,Tidate,$fn(Tgrzf0,"",2),$fn(Tzhzfe0,"",2),Tzylsh0,$fn(Tpay1,"",2),$fn(Tpay2,"",2),$fn(Tpay3,"",2),$fn(Tpay4,"",2),$fn(Tpay5,"",2),$fn(Tpay6,"",2),$fn(Tpay7,"",2),$fn(Tpay8,"",2),$fn(Tpay9,"",2),$fn(Tpay10,"",2),TDHCJFFlag,TBillNO,TAdmReason,snodeind)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
GetInfo(DivDr)
	;s TPrtNo=$p(^DHCINDIV(DivDr),"^",4)
	s TPaadm=$p(^DHCINDIV(DivDr),"^",1)
	s AdmInfo=""
	
	s TDivDr=DivDr
	s TDivFlag=$p(^DHCINDIV(DivDr),"^",5)
	s AdmInfoDr=$p(^DHCINDIV(DivDr),"^",2)
	
	s:AdmInfoDr="" TPatType=""       ;医保端的人员类别 pattype
	s:AdmInfoDr'="" TPatType=$p($g(^DHCINADM(AdmInfoDr)),"^",4)  ;
	s TPrtNO=$p(^DHCINDIV(DivDr),"^",4)
	s DivType=$p(^DHCINDIV(DivDr),"^",36) ;R:挂号 F:收费 H：体检
	s DivMod=$p(^DHCINDIV(DivDr),"^",38) ;Add DingSH 20180808 结算模式 01：现金结算、02：集中打印、31：微信、32：支付宝、20：自助机、10：本地算法
	i DivType="H" d
	.s TDHCJFFlag = $P($G(^DHCPEINVPRT(TPrtNO)),"^",8) //+DingSH 20201019 体检
	.s PERowid=""
	.s PERowid=$O(^DHCPEINVPRT(0,"REF",TPrtNO,""))
	.i +PERowid>0 d
	..s TDHCJFFlag=$P($G(^DHCPEINVPRT(PERowid)),"^",8)  //20201116 体检 只有N和A,作废和红冲时原纪录状态不改变只插入作废状态负记录
	e  d
	.s:TPrtNO'="" TDHCJFFlag=$p($g(^DHCINVPRT(TPrtNO)),"^",8)   ;计费组发票状态：Normal,Abort,Strike,ToPaid
	.s:TPrtNO'="" TAdmReason=$p($g(^DHCINVPRT(TPrtNO)),"^",9)	;admreasonDr
	.i ((DivMod="02")&&(TDivFlag'="I")&&(TPrtNO'="")) d ;Add DingSH 20180808 
	..s AccPayINVDr=$p($g(^DHCINVPRT(TPrtNO)),"^",4)
	..s OldAccPayINVDr="" 
	..s:+AccPayINVDr>0 OldAccPayINVDr=+$p($g(^DHCINVPRTAP(AccPayINVDr)),"^",22)
	..i +OldAccPayINVDr>0 d
	...s TDHCJFFlag=$P($g(^DHCINVPRTAP(OldAccPayINVDr)),"^",2)
	...s TAdmReason=$p($g(^DHCINVPRT(TPrtNO)),"^",31)
	...s TInsDivDr=$p($g(^DHCINVPRT(TPrtNO)),"^",19)
	
	s TBillNO=$p(^DHCINDIV(DivDr),"^",3) 
	//s:TBillNO'="" TDHCJFFlag=$p($g(^DHCPB(TBillNO)),"^",16)       ;Bill,Paid
	//s:TBillNO'="" TAdmReason=$p($g(^DHCPB(TBillNO)),"^",4)
	s PBRefundFlag=""
	i TBillNO'="" d
	.s TDHCJFFlag=$p($g(^DHCPB(TBillNO)),"^",16)       ;Bill,Paid
	.s TAdmReason=$p($g(^DHCPB(TBillNO)),"^",4)
	.s PBRefundFlag=$p($g(^DHCPB(TBillNO)),"^",17) //+ DingSH 20201022
	.s tmpDivDr="",tmpDivFlag=""
	.i TDivFlag'="I" f  s tmpDivDr=$o(^DHCINDIV("0","DHCPB",TBillNO,tmpDivDr),-1) q:(tmpDivDr="")||(tmpDivFlag="I")  d
	..s tmpDivFlag=$P(^DHCINDIV(tmpDivDr),"^",5)
	.s:tmpDivFlag="I" PBRefundFlag =$case(TDivFlag,"B":"B","S":"B",:PBRefundFlag)
	s:(+TAdmReason=0)&&(TPaadm'="") TAdmReason=$p(^PAADM(TPaadm,1),"^",7)
	q:((TDHCJFFlag="P")||(TDHCJFFlag="N"))&&(TDivFlag="I")
	q:(PBRefundFlag="B")&&((TDivFlag="B")||(TDivFlag="S")) //+DingSH 20201022
	d GetAdmInfo(AdmInfoDr)
	s Tbcbxf0=$p(^DHCINDIV(DivDr),"^",7)
	s Tdjlsh0=$p(^DHCINDIV(DivDr),"^",8)
	;s Tidate=$zd($p(^DHCINDIV(DivDr),"^",16),8)_" "_$zt($p(^DHCINDIV(DivDr),"^",17),1)
	s Tidate=##class(websys.Conversions).DateLogicalToHtml($p(^DHCINDIV(DivDr),"^",16))_" "_##class(websys.Conversions).TimeLogicalToHtml($p(^DHCINDIV(DivDr),"^",17))
	s Tgrzf0=$p(^DHCINDIV(DivDr),"^",15)
	s Tzhzfe0=$p(^DHCINDIV(DivDr),"^",28)
	s Tzylsh0=$p(^DHCINDIV(DivDr),"^",30)
	s Tpay1=$p(^DHCINDIV(DivDr),"^",31)
	s Tpay2=$p(^DHCINDIV(DivDr),"^",32)
	s Tpay3=$p(^DHCINDIV(DivDr),"^",33)
	s Tpay4=$p(^DHCINDIV(DivDr),"^",34)
	s Tpay5=$p(^DHCINDIV(DivDr),"^",35)
	s Tpay6=$p(^DHCINDIV(DivDr),"^",46)
	s Tpay7=$p(^DHCINDIV(DivDr),"^",47)
	s Tpay8=$p(^DHCINDIV(DivDr),"^",48)
	s Tpay9=$p(^DHCINDIV(DivDr),"^",49)
	s Tpay10=$p(^DHCINDIV(DivDr),"^",50)
	q:TPaadm=""
	;i TPaadm'=""  d
	s paadmType=$p(^PAADM(TPaadm),"^",2)
	s:paadmType="I" THisType="住院"
	s:paadmType="O" THisType="门诊"
	s:paadmType="E" THisType="急诊"
	s:paadmType="H" THisType="体检" //+DingSH 20201019
	s papmiDr=$p(^PAADM(TPaadm),"^",1)
	s TName=$p(^PAPER(papmiDr,"ALL"),"^",1)
	s:paadmType="I" TRegNO=$p(^PAPER(papmiDr,"PAT",1),"^",1)
	s:paadmType'="I" TRegNO=$p(^PAPER(papmiDr,"PAT",1),"^",2)
	q
GetAdmInfo(AdmInfoDr)
	q:AdmInfoDr=""
	s AdmInfo=$g(^DHCINADM(AdmInfoDr))   ;AdmseriNo      cardno
	s OutPutString=AdmInfoDr_"^"_$p(AdmInfo,"^",10)_"^"_$p(AdmInfo,"^",3)_"^"_TAdmReason
	s PaadmDr=$p(AdmInfo,"^",1)
	i (PaadmDr="")&&($p(AdmInfo,"^",11)="A")  d
	.i $d(^Temp("AdmInfoEXtmp",snodeind,AdmInfoDr))=0  d
	..s ^Temp("AdmInfoEXtmp",snodeind,AdmInfoDr)=OutPutString
	..s ^Temp("AdmInfoEX",snodeind)=$g(^Temp("AdmInfoEX",snodeind))_"!"_OutPutString
	q
}

ClassMethod GetAdmInfoEx(subindex) As %String
{
	q:+subindex=0 ""
	q $g(^Temp("AdmInfoEX",subindex))
}

ClassMethod QueryDivideForExFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDivideForExExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// by  huangxianchang   2014.8.25
/// 说明：查询病人所的有结算纪录：优先考虑结算流水号;开始时间、结束时间，只有参数是登记号的时，才会被使用。
/// 入参：StartDate:开始日期
/// 		EndDate:结束日期
///     RegNO:登记号
///     PrtNO:发票rowid
///     BIllNO:账单rowid
/// 	TradeNO:结算流水号
/// 出参：
Query QueryDivideForEx(StartDate As %Library.Date, EndDate As %Library.Date, RegNO As %String, PrtNO As %String, PrtInv As %String, TradeNO As %String, InsuNO As %String, HisType As %String, BillDr As %String, InsuDllType As %String, HospDr As %String) As %Query(ROWSPEC = "TName:%String,THisType:%String,TRegNO:%String,TPrtNO:%String,TPatType:%String,TPaadm:%String,TDivDr:%String,TDivFlag:%String,Tbcbxf0:%String,Tdjlsh0:%String,Tidate:%String,Tgrzf0:%String,Tzhzfe0:%String,Tzylsh0:%String,Tpay1:%String,Tpay2:%String,Tpay3:%String,Tpay4:%String,Tpay5:%String,Tpay6:%String,Tpay7:%String,Tpay8:%String,Tpay9:%String,Tpay10:%String,TDHCJFFlag:%String,TBillNO:%String,TAdmReason:%String,snodeind:%String")
{
}

/// 获取计费结算状态
ClassMethod GetHisDivideFlag(InsuDivDr) As %String
{
	s TPrtNO=$p(^DHCINDIV(InsuDivDr),"^",4)
	s TDHCJFFlag=""
	s:TPrtNO'="" TDHCJFFlag=$p($g(^DHCINVPRT(TPrtNO)),"^",8)   ;计费组发票状态：Normal,Abort,Strike,ToPaid
	s:TPrtNO'="" TAdmReason=$p($g(^DHCINVPRT(TPrtNO)),"^",9)	;admreasonDr
	s TBillNO=$p(^DHCINDIV(InsuDivDr),"^",3) 
	s:TBillNO'="" TDHCJFFlag=$p($g(^DHCPB(TBillNO)),"^",16)       ;Bill,Paid
	s:TBillNO'="" TAdmReason=$p($g(^DHCPB(TBillNO)),"^",4)	
	q TDHCJFFlag
}

/// Description:：   	按账单号查出INSU_divideSub表信息    		
/// Input：           	PBRowId：账单号,DisFlag:上传标识,TarCode:医院收费项目编码,TarDesc:医院收费项目描述,InsuTarCode:医保收费项目编码,InsuTarDesc:医保收费项目描述
/// Output：          	DivideDr:INSUDivide的指针,ArcimDr:医嘱项指针,TarItmDr:收费项目指针,INSUItmDr:对应的医保项目指针,OEORIDr:对应的OE_OrdItem的指针,PBDr对应的DHC_Patientbill的指针,PBDDr:对应的DHC_PatBillDetails指针,INSUCode:医保编码,INSUDesc:医保名称,INSUXMLB:医保等级,Qty:数量,Price:价格,Amount:金额,TarCate:项目住院分类,Scale:自付比例,Fund:统筹支付,Self:个人自付部分,Flag:上传标志,Sequence1:明细序号1,Sequence2:明细序号2,Date:上传日期,Time:上传时间,UserDr:操作员Dr,INSUFlag:是否医保标志,INSUMaxPrice:医保限价,Demo1:预留字串1,Demo2:预留字串2,Demo3:预留字串3,Demo4:预留字串4,Demo5:预留字串5,TARICode:收费项目编码,TARIDesc:收费项目名称
/// d ##class(%ResultSet).RunQuery("web.DHCINSUDivQue","findDivideSubByPBRowId","账单rowid","","","","","")
Query findDivideSubByPBRowId(PBRowId As %String, DisFlag As %String = "", TarCode As %String = "", TarDesc As %String = "", InsuTarCode As %String = "", InsuTarDesc As %String = "", InsuXMFLQry As %String = "") As %Query(ROWSPEC = "Ind:%String,INDISRowid:%String,DivideDr:%String,ArcimDr:%String,TarItmDr:%String,INSUItmDr:%String,OEORIDr:%String,PBDr:%String,PBDDr:%String,INSUCode:%String,INSUDesc:%String,INSUXMLB:%String,Qty:%String,Price:%String,Amount:%String,TarCate:%String,Scale:%String,Fund:%String,Self:%String,Flag:%String,Sequence1:%String,Sequence2:%String,Date:%String,Time:%String,UserDr:%String,INSUFlag:%String,INSUMaxPrice:%String,Demo1:%String,Demo2:%String,Demo3:%String,Demo4:%String,Demo5:%String,TARICode:%String,TARIDesc:%String,INDISExecDr:%String,INDISUpQty:%String,INDISReQty:%String,INDISInsuRetSeqNo:%String,INDISPlusLinkNeg:%String,INDISInsuPrice:%String,INDISInsuQty:%String,INDISInsuAmount:%String,INDISInsuRetStr:%String")
{
}

ClassMethod findDivideSubByPBRowIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod findDivideSubByPBRowIdExecute(ByRef qHandle As %Binary, PBRowId As %String, DisFlag As %String = "", TarCode As %String = "", TarDesc As %String = "", InsuTarCode As %String = "", InsuTarDesc As %String = "", InsuXMFLQry As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set Ind=1
	Set qHandle=$lb(0,repid,0)
 	q:PBRowId="" $$$OK
 	set INDISRowid=""
 	s AdmDr=$P($g(^DHCPB(PBRowId)),"^",1)
    s tHospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
 	For  Set INDISRowid = $O(^DHCINDIS("0","PBDr",PBRowId,INDISRowid)) Quit:INDISRowid=""  do
	.set DivideSubinfo = $g(^DHCINDIS(INDISRowid)) 
 	.set DivideDr = $p(DivideSubinfo,"^",1) //INSUDivide的指针
 	.set ArcimDr = $p(DivideSubinfo,"^",2) //医嘱项指针
 	.set TarItmDr = $p(DivideSubinfo,"^",3) //收费项目指针
 	.set DHCTarIteminfo =^DHCTARI(TarItmDr)
 	.set TARICode = $p(DHCTarIteminfo,"^",1) //收费项目编码
 	.q:(TarCode'="")&&(TarCode'=TARICode)
 	.set TARIDesc = $p(DHCTarIteminfo,"^",2) //收费项目名称
    .q:(TarDesc'="")&&(TARIDesc'[TarDesc)
 	.set INSUItmDr = $p(DivideSubinfo,"^",4) //对应的医保项目指针
 	.set OEORIDr = $p(DivideSubinfo,"^",5) //对应的OE_OrdItem的指针
 	.set PBDr = $p(DivideSubinfo,"^",6) //对应的DHC_Patientbill的指针
 	.s AdmDr="",InsuType="",INADMRowid=""
 	.s:PBDr'="" AdmDr=$P($g(^DHCPB(PBRowId)),"^",1)
 	.s:AdmDr'="" INADMRowid=$O(^DHCINADM("0","ADM",AdmDr,""),-1) 
 	.s:INADMRowid'="" InsuType=$P(^DHCINADM(INADMRowid),"^",18)
 	.set PBDDr = $p(DivideSubinfo,"^",7) //对应的DHC_PatBillDetails指针,
 	.set INSUCode = $p(DivideSubinfo,"^",8) //医保编码
 	.q:(InsuTarCode'="")&&(InsuTarCode'=INSUCode)
 	.set INSUDesc = $p(DivideSubinfo,"^",9) //医保名称
 	.q:(InsuTarDesc'="")&&(INSUDesc'[InsuTarDesc)
 	.set INSUXMLB = $p(DivideSubinfo,"^",10) //医保等级
 	.set tmpXmdj=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKA065"_InsuType,INSUXMLB,4,tHospDr)
 	.set:tmpXmdj'="" INSUXMLB=tmpXmdj
 	.set:tmpXmdj'="" INSUXMLB=tmpXmdj
 	.q:(InsuXMFLQry="2")&(INSUXMLB'="丙类")
 	.set Qty =$p(DivideSubinfo,"^",11)  //数量 
 	.s:((+Qty>0)&&(+Qty<1)) Qty="0"_Qty
 	.s:((+Qty>-1)&&(+Qty<0)) Qty="-0"_(0-Qty)
 	.set Price = $p(DivideSubinfo,"^",12)  //价格
 	.s:((+Price>0)&&(+Price<1)) Price="0"_Price
 	.set Amount = $p(DivideSubinfo,"^",13) //金额
 	.s:((+Amount>0)&&(+Amount<1)) Amount="0"_Amount
 	.s:((+Amount>-1)&&(+Amount<0)) Amount="-0"_(0-Amount)
 	.set TarCate = $p(DivideSubinfo,"^",14) //项目住院分类,
 	.s TarCDesc=""
 	.//s:TarCate'="" TarCDesc=$P($g(^DHCTarC("CC",TarCate)),"^",2)
 	.s:TarCate'="" TarCDesc=$P($g(^DHCTarC("TOC",TarCate)),"^",2) //表中存的是 DHC_TarOC Rowid
    .s:TarCDesc'="" TarCate=TarCDesc
 	.set Scale = $p(DivideSubinfo,"^",15) //自付比例,
 	.s:((+Scale>0)&&(+Scale<1)) Scale="0"_Scale
 	.s:INSUItmDr="" Scale=""
 	.set Fund = $p(DivideSubinfo,"^",16) //统筹支付
 	.set Self = $p(DivideSubinfo,"^",17) //个人自付部分
 	.set Flag = $p(DivideSubinfo,"^",18) //上传标志,
 	.q:(DisFlag'="")&&(DisFlag'=Flag)
 	.s Flag=$case(Flag,"I":"I:未上传","N":"N:已上传","S":"S:作废","":"其他")
 	.set Sequence1 = $p(DivideSubinfo,"^",19) //明细序号1,
 	.set Sequence2 = $p(DivideSubinfo,"^",20) //明细序号2,
 	.set Date = $p(DivideSubinfo,"^",21) //上传日期,
 	.;set Date = $zd(Date,3)
 	.s Date=##class(websys.Conversions).DateLogicalToHtml(Date) ;DingSH 20180402
 	.set Time = $p(DivideSubinfo,"^",22) //上传时间,
 	.;set Time = $zt(Time)
	.s Time=##class(websys.Conversions).TimeLogicalToHtml(Time) ;DingSH 20180402
 	.set UserDr = $p(DivideSubinfo,"^",23) //操作员Dr,
 	.s UserDesc=""
 	.s:UserDr'="" UserDesc=$p($g(^SSU("SSUSR",UserDr)),"^",2)
 	.s:UserDesc'="" UserDr=UserDesc
 	.;2018-05-15 修改  zyx  医保标志和医保限价显示  st
 	.i ($p(DivideSubinfo,"^",24)="")&&(INSUItmDr'="") set INSUFlag=$p($g(^DHCINTIM(INSUItmDr)),"^",25) //是否医保标志
 	.e  s INSUFlag=$p(DivideSubinfo,"^",24)
 	.i ($p(DivideSubinfo,"^",25)="")&&(INSUItmDr'="") set INSUMaxPrice=$p($g(^DHCINTIM(INSUItmDr)),"^",17) //医保限价,
 	.e  s INSUMaxPrice=$p(DivideSubinfo,"^",25)
 	.;2018-05-15 修改  zyx  医保标志和医保限价显示  end
 	.set Demo1 = $p(DivideSubinfo,"^",26) //预留字串1,
 	.set Demo2 = $p(DivideSubinfo,"^",27) //预留字串2
 	.set Demo3 = $p(DivideSubinfo,"^",28) //预留字串3,   超限价自付金额
 	.q:(InsuXMFLQry="4")&(+$g(Demo3)=0)
 	.set Demo4 = $p(DivideSubinfo,"^",29) //预留字串4,
 	.set Demo5 = $p(DivideSubinfo,"^",30) //预留字串5,  超出治疗方案的金额
 	.q:(InsuXMFLQry="3")&(+$g(Demo5)=0)
 	.;INDISExecDr,INDISUpQty,INDISReQty,INDISInsuRetSeqNo,INDISPlusLinkNeg,INDISInsuPrice,INDISInsuQty,INDISInsuAmount,INDISInsuRetStr
 	.set INDISExecDr = $p(DivideSubinfo,"^",31) //执行记录DR
 	.set INDISUpQty = $p(DivideSubinfo,"^",32) //实际上传数量（医保
 	.set INDISReQty = $p(DivideSubinfo,"^",33) //退费数量
 	.set INDISInsuRetSeqNo = $p(DivideSubinfo,"^",34) //医保中心返回交易流水号
 	.set INDISPlusLinkNeg= $p(DivideSubinfo,"^",35) //正记录dr$数量！正记录dr$数量
 	.set INDISInsuPrice = $p(DivideSubinfo,"^",36) //单价（医保）
 	.set INDISInsuQty = $p(DivideSubinfo,"^",37) //数量（医保）
 	.set INDISInsuAmount = $p(DivideSubinfo,"^",38) //金额（医保）
 	.set INDISInsuRetStr= $p(DivideSubinfo,"^",35) //医保返回所有字段
 	.do build12
 	Quit $$$OK
build12	
	Set data = $lb(ind,INDISRowid,DivideDr,ArcimDr,TarItmDr,INSUItmDr,OEORIDr,PBDr,PBDDr,INSUCode,INSUDesc,INSUXMLB,Qty,Price,Amount,TarCate,Scale,Fund,Self,Flag,Sequence1,Sequence2,Date,Time,UserDr,INSUFlag,INSUMaxPrice,Demo1,Demo2,Demo3,Demo4,Demo5,TARICode,TARIDesc,INDISExecDr,INDISUpQty,INDISReQty,INDISInsuRetSeqNo,INDISPlusLinkNeg,INDISInsuPrice,INDISInsuQty,INDISInsuAmount,INDISInsuRetStr)
 	Set ^CacheTemp(repid,Ind) = data
 	Set Ind = Ind +1
}

ClassMethod findDivideSubByPBRowIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc：通过病人登记号PAPMINo获取门诊发票表dhc_invprt相关字段
/// input:病人登记号PAPMINo
/// output:dhc_invprt表某些字段数据
/// creator:zyx
/// create date:2018-03-26
/// others：查某病人发票数据时，输入登记号可自动补零
/// d ##class(%ResultSet).RunQuery("web.DHCINSUDivQue","findOPDivideSubByPAPMINo","2018-05-02","2018-05-02","")
Query findOPDivideSubByPAPMINo(StDate As %String, EndDate As %String, PAPMINo As %String = "", HospId) As %Query(ROWSPEC = "Ind,PrtRowid:%String,PAPMINO:%String,PAPMIName:%String,PrtAcount:%String,InvNo:%String,PRTdate:%String,InvFlag:%String,PAADMDr:%String,PRTInsDivDR:%String,HISUser:%String") [ SqlProc ]
{
}

ClassMethod findOPDivideSubByPAPMINoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findOPDivideSubByPAPMINoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod findOPDivideSubByPAPMINoExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, PAPMINo As %String = "", HospId) As %Status
{
	Set repid=$I(^CacheTemp)
	Set Ind=1
	Set qHandle=$lb(0,repid,0)
	q:StDate="" $$$OK
    q:EndDate="" $$$OK

 	s:StDate'="" StDate=##class(websys.Conversions).DateHtmlToLogical(StDate) 
 	s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
 	s ^TMPzyx("findOPDivideSubByPAPMINoExecute")=$lb(StDate,EndDate,PAPMINo,HospId)
 	f PRTDate=StDate:1:EndDate d          
	.s PrtRowid=""
	.f  s PrtRowid=$o(^DHCINVPRT(0,"Date",PRTDate,PrtRowid)) q:PrtRowid=""  d
	..s DHCInvInfo=$g(^DHCINVPRT(PrtRowid))
	..quit:HospId'=$p(DHCInvInfo,"^",39)
	..s PrtPapmiDr=$p(DHCInvInfo,"^",15)    
	..s PAPMIName=$p($g(^PAPER(PrtPapmiDr,"ALL")),"^",1)
	..s PAPMINO=$p($g(^PAPER(PrtPapmiDr,"PAT",1)),"^",2)
	..q:(PAPMINo'="")&&(PAPMINo'=PAPMINO)
	..s PAADMDr=$o(^PAPERdr(PrtPapmiDr,"ADM","O",""),-1)
	..s PRTACCPINVDR=$p(DHCInvInfo,"^",4)
	..s:PRTACCPINVDR'="" ACCPINVDRInfo=$g(^DHCINVPRTAP(PRTACCPINVDR))
	..i ($p(DHCInvInfo,"^",14)="")&&(PRTACCPINVDR'="")&&($p(ACCPINVDRInfo,"^",19)'="") d   //科室卡消费，集中打印发票调医保打印发票
	...s InvNo=$p($g(^DHCINVPRTAP(PRTACCPINVDR)),"^",6)
	...s PRTInsDivDR=$p($g(^DHCINVPRTAP(PRTACCPINVDR)),"^",19)
	..e  i ($p(DHCInvInfo,"^",14)="")&&(PRTACCPINVDR'="")&&($p(ACCPINVDRInfo,"^",19)="") d //门诊收费调医保接口结算，集中打印发票打印发票
	...s InvNo=$p($g(^DHCINVPRTAP(PRTACCPINVDR)),"^",6)
	...s PRTInsDivDR=$p(DHCInvInfo,"^",30)
	..e  d       																		   //门诊收费调医保接口直接打印发票
	...s InvNo=$p(DHCInvInfo,"^",14)
	...s PRTInsDivDR=$p(DHCInvInfo,"^",30)
	..s InvFlag=$p(DHCInvInfo,"^",8)
	..q:InvFlag'="N"
	..s InvFlag=$case(InvFlag,"N":"正常","B":"B-被作废","S":"S-作废","TP":"其他")
	..s PRTdate=$p(DHCInvInfo,"^",5)
	..s PRTdate=##class(websys.Conversions).DateLogicalToHtml(PRTdate) ;DingSH 20180402 
	..;s PRTdate=$zd(PRTdate,3)
	..s PrtAcount=$p(DHCInvInfo,"^",1) 
	..s:((+PrtAcount>0)&&(+PrtAcount<1)) PrtAcount="0"_PrtAcount
	..q:PRTInsDivDR=""
	..;b
	..s UserDr=$p(DHCInvInfo,"^",21)
	..s HISUser=$p($g(^SSU("SSUSR",UserDr)),"^",2)
 	..do build2
 	Quit $$$OK
build2	
	Set data = $lb(Ind,PrtRowid,PAPMINO,PAPMIName,PrtAcount,InvNo,PRTdate,InvFlag,PAADMDr,PRTInsDivDR,HISUser)
 	Set ^CacheTemp(repid,Ind) = data
 	Set Ind = Ind +1
}

ClassMethod findOPDivideSubByPAPMINoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findOPDivideSubByPAPMINoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc：通过门诊的发票rowid获取医保dividesub表明细数据
/// input:PRTRowid(发票表rowid)
/// output:insu_dividesub表各字段数据
/// creator:zyx
/// create date:2018-03-26
/// others:无
/// debugger:d ##class(%ResultSet).RunQuery("web.DHCINSUDivQue","findDivideSubByPrtId","206670")
Query findDivideSubByPrtId(PRTRowid As %String) As %Query(ROWSPEC = "Ind:%String,INDISRowid:%String,DivideDr:%String,ArcimDr:%String,TarItmDr:%String,INSUItmDr:%String,OEORIDr:%String,PBDr:%String,PBDDr:%String,INSUCode:%String,INSUDesc:%String,INSUXMLB:%String,Qty:%String,Price:%String,Amount:%String,TarCate:%String,Scale:%String,Fund:%String,Self:%String,Flag:%String,Sequence1:%String,Sequence2:%String,Date:%String,Time:%String,UserDr:%String,INSUFlag:%String,INSUMaxPrice:%String,Demo1:%String,Demo2:%String,Demo3:%String,Demo4:%String,Demo5:%String,TARICode:%String,TARIDesc:%String,INDISExecDr:%String,INDISUpQty:%String,INDISReQty:%String,INDISInsuRetSeqNo:%String,INDISPlusLinkNeg:%String,INDISInsuPrice:%String,INDISInsuQty:%String,INDISInsuAmount:%String,INDISInsuRetStr:%String")
{
}

ClassMethod findDivideSubByPrtIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findDivideSubByPrtIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod findDivideSubByPrtIdExecute(ByRef qHandle As %Binary, PRTRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind = 1
 	Set qHandle = $lb(0,repid,0)
 	q:PRTRowid="" $$$OK
 	set DHCBCIRowid=""   
 	For  Set DHCBCIRowid = $O(^DHCBCI(0,"INV",PRTRowid,DHCBCIRowid)) Quit:DHCBCIRowid=""  do  //账单连接发票表dhc_billconinv
	.s PBDr=$p($g(^DHCBCI(DHCBCIRowid)),"^",2)    //账单号
	.set INDISRowid=""
 	.For  Set INDISRowid = $O(^DHCINDIS("0","PBDr",PBDr,INDISRowid)) Quit:INDISRowid=""  do
	..set DivideSubinfo = $g(^DHCINDIS(INDISRowid)) 
 	..set DivideDr = $p(DivideSubinfo,"^",1)    //INSUDivide的指针
 	..set ArcimDr = $p(DivideSubinfo,"^",2)    //医嘱项指针
 	..set TarItmDr = $p(DivideSubinfo,"^",3)   //收费项目指针
 	..set DHCTarIteminfo =$g(^DHCTARI(TarItmDr))
 	..set TARICode = $p(DHCTarIteminfo,"^",1) //收费项目编码
 	..set TARIDesc = $p(DHCTarIteminfo,"^",2) //收费项目名称
 	..set INSUItmDr = $p(DivideSubinfo,"^",4) //对应的医保项目指针
 	..set OEORIDr = $p(DivideSubinfo,"^",5)  //对应的OE_OrdItem的指针
 	..set PBDr = $p(DivideSubinfo,"^",6)    //对应的DHC_Patientbill的指针
 	..s AdmDr="",InsuType="",INADMRowid=""
 	..s:PBDr'="" AdmDr=$P($g(^DHCPB(PBDr)),"^",1)
 	..s:AdmDr'="" INADMRowid=$O(^DHCINADM("0","ADM",AdmDr,""),-1) 
 	..s:INADMRowid'="" InsuType=$P(^DHCINADM(INADMRowid),"^",18)
 	..set PBDDr= $p(DivideSubinfo,"^",7)     //对应的DHC_PatBillDetails指针,
 	..set INSUCode =$case($p(DivideSubinfo,"^",8),"":"未对照",:$p(DivideSubinfo,"^",8)) //医保编码
 	..set INSUDesc =$p(DivideSubinfo,"^",9) //医保名称
 	..set INSUXMLB = $p(DivideSubinfo,"^",10) //医保等级
 	..set tmpXmdj=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKA065"_InsuType,INSUXMLB,4,$p(^DHCINVPRT(PRTRowid),"^",39))
 	..set:tmpXmdj'="" INSUXMLB=tmpXmdj
 	..set Qty = $p(DivideSubinfo,"^",11)     //数量 
 	..s:((+Qty>0)&&(+Qty<1)) Qty="0"_Qty
 	..s:((+Qty>-1)&&(+Qty<0)) Qty="-0"_(0-Qty)
 	..set Price = $p(DivideSubinfo,"^",12)  //价格
 	..s:((+Price>0)&&(+Price<1)) Price="0"_Price
 	..set Amount = $p(DivideSubinfo,"^",13) //金额
 	..s:((+Amount>0)&&(+Amount<1)) Amount="0"_Amount
 	..s:((+Amount>-1)&&(+Amount<0)) Amount="-0"_(0-Amount)
 	..set TarCate = $p(DivideSubinfo,"^",14) //项目门诊大类,
 	..s TarCDesc=""
 	..s:TarCate'="" TarCDesc=$P($g(^DHCTarC("TOC",TarCate)),"^",2)
    ..s:TarCDesc'="" TarCate=TarCDesc
 	..set Scale = $p(DivideSubinfo,"^",15) //自付比例,
 	..s:((+Scale>0)&&(+Scale<1)) Scale="0"_Scale
 	..s:INSUItmDr="" Scale=""
 	..set Fund = $p(DivideSubinfo,"^",16) //统筹支付
 	..set Self = $p(DivideSubinfo,"^",17) //个人自付部分
 	..set Flag = $p(DivideSubinfo,"^",18) //上传标志,
 	..set Flag=$case(Flag,"I":"未上传","N":"已上传",:"其他")
 	..set Sequence1 = $p(DivideSubinfo,"^",19) //明细序号1,
 	..set Sequence2 = $p(DivideSubinfo,"^",20) //明细序号2,
 	..set Date = $p(DivideSubinfo,"^",21) //上传日期,
 	..;set Date = $zd(Date,3)
 	..s Date=##class(websys.Conversions).DateLogicalToHtml(Date) ;DingSH 20180402
 	..set Time = $p(DivideSubinfo,"^",22) //上传时间,
 	..;set Time = $zt(Time)
 	..s Time=##class(websys.Conversions).TimeLogicalToHtml(Time) ;DingSH 20180402
 	..set UserDr = $p(DivideSubinfo,"^",23) //操作员Dr,
 	..s UserDesc=""
 	..s:UserDr'="" UserDesc=$p($g(^SSU("SSUSR",UserDr)),"^",2)
 	..s:UserDesc'="" UserDr=UserDesc
 	..;2018-05-15 修改  zyx  医保标志和医保限价显示  st
 	..i ($p(DivideSubinfo,"^",24)="")&&(INSUItmDr'="") set INSUFlag=$p($g(^DHCINTIM(INSUItmDr)),"^",25)   //是否医保标志
 	..e  set INSUFlag=$p(DivideSubinfo,"^",24)
 	..i ($p(DivideSubinfo,"^",25)="")&&(INSUItmDr'="") set INSUMaxPrice=$p($g(^DHCINTIM(INSUItmDr)),"^",17) //医保限价,
 	..e  s INSUMaxPrice=$p(DivideSubinfo,"^",25)
 	..;2018-05-15 修改  zyx  医保标志和医保限价显示  end
 	..set Demo1 = $p(DivideSubinfo,"^",26) //预留字串1,
 	..set Demo2 = $p(DivideSubinfo,"^",27) //预留字串2
 	..set Demo3 = $p(DivideSubinfo,"^",28) //预留字串3,
 	..set Demo4 = $p(DivideSubinfo,"^",29) //预留字串4,
 	..set Demo5 = $p(DivideSubinfo,"^",30) //预留字串5,
 	..set INDISExecDr = $p(DivideSubinfo,"^",31) //执行记录DR
 	..set INDISUpQty = $p(DivideSubinfo,"^",32) //实际上传数量（医保
 	..set INDISReQty = $p(DivideSubinfo,"^",33) //退费数量
 	..set INDISInsuRetSeqNo = $p(DivideSubinfo,"^",34) //医保中心返回交易流水号
 	..set INDISPlusLinkNeg= $p(DivideSubinfo,"^",35) //正记录dr$数量！正记录dr$数量
 	..set INDISInsuPrice = $p(DivideSubinfo,"^",36) //单价（医保）
 	..set INDISInsuQty = $p(DivideSubinfo,"^",37) //数量（医保）
 	..set INDISInsuAmount = $p(DivideSubinfo,"^",38) //金额（医保）
 	..set INDISInsuRetStr= $p(DivideSubinfo,"^",35) //医保返回所有字段
 	..do findDivideSubByPrtId
 	Quit $$$OK
findDivideSubByPrtId
	Set data = $lb(ind,INDISRowid,DivideDr,ArcimDr,TarItmDr,INSUItmDr,OEORIDr,PBDr,PBDDr,INSUCode,INSUDesc,INSUXMLB,Qty,Price,Amount,TarCate,Scale,Fund,Self,Flag,Sequence1,Sequence2,Date,Time,UserDr,INSUFlag,INSUMaxPrice,Demo1,Demo2,Demo3,Demo4,Demo5,TARICode,TARIDesc,INDISExecDr,INDISUpQty,INDISReQty,INDISInsuRetSeqNo,INDISPlusLinkNeg,INDISInsuPrice,INDISInsuQty,INDISInsuAmount,INDISInsuRetStr)
 	Set ^CacheTemp(repid,ind) = data
 	Set ind = ind +1
}

ClassMethod findDivideSubByPrtIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findDivideSubByPrtIdExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 20190305 yangsx
/// 根据登记号查询住院就诊相关信息
Query searchAdm(RegNO As %String, HospDr As %String) As websys.Query(ROWSPEC = "TadmId:%String,TadmDate:%String,TadmLoc:%String,TadmWard:%String,TdisDate:%String,PBRowID:%String")
{
}

/// do ##class(%ResultSet).RunQuery("web.DHCINSUDivQue","searchAdm","0000028344")
ClassMethod searchAdmExecute(ByRef qHandle As %Binary, RegNO As %String, HospDr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	Set ind=1
 	;s ^temp("web.DHCINSUDivQue","searchAdm")=RegNO_","_HospDr
 	set papmi=$o(^PAPERi("PAPMI_PatNo",RegNO,""))
    If ((+papmi=0)||('$d(^PAPER(papmi)))) Set qHandle=$lb(0,repid,0) Quit $$$OK
    If (('$d(^PAPERdr(papmi)))||('$d(^PAPERdr(papmi,"ADM","I")))) Set qHandle=$lb(0,repid,0) Quit $$$OK
    Set admId=""
    For {
   		Set admId=$o(^PAPERdr(papmi,"ADM","I",admId),-1) Quit:admId=""
   		Continue:'$d(^PAADM(admId))
   		Do initAdmData
   		s tHospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(admId) //+ DingSH 20200616
   		Continue:(tHospDr'=HospDr)&&(HospDr'="")
   		Set TadmId=admId
   		Set admStatus=$p(^PAADM(admId),"^",20)
   		Continue:admStatus="C"
   		Set admDate=$p(^PAADM(admId),"^",6)
   		Set admTime=$p(^PAADM(admId),"^",7)
   		Set admLoc=$p(^PAADM(admId),"^",4)
   		Set admWard=$p(^PAADM(admId),"^",70)
   		Set admStatus=$p(^PAADM(admId),"^",20)
   		Set disDate=$p(^PAADM(admId),"^",17)
   		Set disTime=$p(^PAADM(admId),"^",18)
   		If admDate'="" {
	   		Set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)	
   		}
   		If (admTime'="") {
	   		Set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime,1)	
   		}
   		If admLoc'="" {
	   		If $d(^CTLOC(admLoc)) {
		   		Set TadmLoc=$p(^CTLOC(admLoc),"^",2)
		   		i TadmLoc["-" Set TadmLoc=$p(TadmLoc,"-",2)
	   		}
   		}
   		If admWard'="" {
	   		If $d(^PAWARD(admWard)) {
		   		Set TadmWard=$p(^PAWARD(admWard),"^",2)
		   		i TadmWard["-" Set TadmWard=$p(TadmWard,"-",2)
	   		}	
   		}
   		If disDate'="" {
	   		Set disDate=##class(websys.Conversions).DateLogicalToHtml(disDate)	
   		}
   		If (disTime'="") {
	   		Set disTime=##class(websys.Conversions).TimeLogicalToHtml(disTime,1)	
   		}
   		
   		Set TadmDate=admDate_" "_admTime
   		Set TdisDate=disDate_" "_disTime
   		
   		s PBRowID="" 
   		f  s PBRowID=$o(^DHCPB(0,"ADM",TadmId,PBRowID)) q:PBRowID=""  d
   		.q:'$d(^DHCPB(PBRowID))
   		.s PBInfo=$g(^DHCPB(PBRowID))
   		.s PBPayedFlag=$p(PBInfo,"^",16)
   		.q:PBPayedFlag'="P"
   		.s PBRefundFlag=$p(PBInfo,"^",17)
   		.q:PBRefundFlag'=""
   		.Do OutputAdmList
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
initAdmData
	Set (TadmId,TadmDate,TadmLoc,TadmWard,TdisDate,PBRowID)=""
	Quit  
OutputAdmList
	Set Data=$lb(TadmId,TadmDate,TadmLoc,TadmWard,TdisDate,PBRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 说明：获取医保结算单数据。
/// /  2019-09-03 DingSH 
/// 入参：
///     BillDr:账单表rowid
///     PrtDr:门诊发票rowid或门诊发票rowid串(!分割)或体检发票Rowid;不推荐此字段,而门诊推荐用InDivDr字段
/// 	InDivDr:医保结算表Rowid
///     AdmDr:就诊表rowid
/// 出参：
/// d ##class(%ResultSet).RunQuery("web.DHCINSUDivQue","QueryInsuJSD","282055","","","")
Query QueryInsuJSD(BillDr As %String = "", PrtDr As %String = "", InDivDr As %String = "", AdmDr As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "TInd,AAdmDr:%String,InsuId:%String,ACardNo:%String,PatType:%String,CardStatus:%String,Company:%String,States:%String,Center:%String,Account:%String,AdmSeriNo:%String,ActiveFlag:%String,AdmDate:%String,AdmTime:%String,AdmType:%String,DeptDesc:%String,InsuUser:%String,IpTimes:%String,InsuType:%String,AdmCancelNo:%String,OutDate:%String,OutTime:%String,OutUser:%String,UserDr:%String,FunDate:%String,FunTime:%String,XString1:%String,XString2:%String,XString3:%String,XString4:%String,XFloat1:%String,XFloat2:%String,XFloat3:%String,XFloat4:%String,XString5:%String,XString6:%String,XString7:%String,XString8:%String,XString9:%String,XString10:%String,XString11:%String,XString12:%String,XString13:%String,XString14:%String,XString15:%String,XString16:%String,XString17:%String,XString18:%String,XString19:%String,XString20:%String,InsuAdmInfoDr:%String,DAdmDr:%String,DAdmInfoDr:%String,DHCpblDr:%String,DhcInvPrtDr:%String,Flag:%String,INSUDivideDr:%String,bcbxf0:%String,djlsh0:%String,bckbcs:%String,bqbm00:%String,brnl00:%String,cardno:%String,cfms0:%String,crbcts:%String,grzfe0:%String,iDate:%String,iTime:%String,id0000:%String,jjzfe0:%String,ptbcts:%String,sUserDr:%String,sfrq00:%String,sfrm0:%String,sfsj00:%String,sftsbz:%String,bie00:%String,ming0:%String,zhzfe0:%String,zyksmc:%String,zylsh0:%String,InsuPay1:%String,InsuPay2:%String,InsuPay3:%String,InsuPay4:%String,InsuPay5:%String,Zstr01:%String,Zstr02:%String,Zstr03:%String,Zstr04:%String,Zstr05:%String,Zstr06:%String,Zstr07:%String,Zstr08:%String,Zstr09:%String,Zstr10:%String,InsuPay6:%String,InsuPay7:%String,InsuPay8:%String,InsuPay9:%String,InsuPay10:%String,Zstr11:%String,Zstr12:%String,Zstr13:%String,Zstr14:%String,Zstr15:%String,Zstr16:%String,Zstr17:%String,Zstr18:%String,Zstr19:%String,Zstr20:%String,Zstr21:%String,Zstr22:%String,Zstr23:%String,Zstr24:%String,Zstr25:%String,Zstr26:%String,Zstr27:%String,Zstr28:%String,Zstr29:%String,Zstr30:%String,PAPMINo:%String,PAPMIName:%String,PAPMISex:%String,PAPMIAge:%String,IPDays:%String,DiagCBDiagCode:%String,DiagCBDiagDesc:%String,DiagRYDiagCode:%String,DiagRYDiagDesc:%String,DiagMZDiagCode:%String,DiagMZDiagDesc:%String,DiagCYDiagCode:%String,DiagCYDiagDesc:%String,ZlFee:%Float,JCFee:%Float,SsFee:%Float,GhFee:%Float,HlFee:%Float,CwFee:%Float,ZCFee:%Float,HyFee:%Float,SxFee:%Float,ClFee:%Float,ZCaoYFee:%Float,ZCheFee:%Float,XyFee:%Float,YBZLFee:%Float,QTFee:%Float,PAPMIDob:%String,Tel:%String,BedID:%String,Medicare:%String,ZlFee1:%Float,JCFee1:%Float,SsFee1:%Float,GhFee1:%Float,HlFee1:%Float,CwFee1:%Float,ZCFee1:%Float,HyFee1:%Float,SxFee1:%Float,ClFee1:%Float,ZCaoYFee1:%Float,ZCheFee1:%Float,XyFee1:%Float,YBZLFee1:%Float,QTFee1:%Float,ZlFee2:%Float,JCFee2:%Float,SsFee2:%Float,GhFee2:%Float,HlFee2:%Float,CwFee2:%Float,ZCFee2:%Float,HyFee2:%Float,SxFee2:%Float,ClFee2:%Float,ZCaoYFee2:%Float,ZCheFee2:%Float,XyFee2:%Float,YBZLFee2:%Float,QTFee2:%Float,GwyBZ,Grsflb,InsuHospCode,InsuHospDesc,hoscategry") [ SqlProc ]
{
}

ClassMethod QueryInsuJSDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInsuJSDExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryInsuJSDExecute(ByRef qHandle As %Binary, BillDr As %String = "", PrtDr As %String = "", InDivDr As %String = "", AdmDr As %String = "", ExpStr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QueryInsuJSD=1
	Set qHandle=$lb(0,repid,0)
	s ^Temp(1)=BillDr_","_PrtDr_","_InDivDr_","_AdmDr
 	q:(BillDr="")&&(PrtDr="")&&(InDivDr="")&&(AdmDr="") $$$OK
 	set tInDivDr=""
    if (BillDr'="")
    {
	    s tInDivDr =$O(^DHCINDIV(0,"DHCPB",BillDr,""),-1)
	    q:tInDivDr="" $$$OK
	 }
	 
	 if (PrtDr'="")
    {
	    s tInDivDr =$O(^DHCINDIV(0,"DHCInvPrt",PrtDr,""),-1)
	    q:tInDivDr="" $$$OK
	 }
	 
	 if (InDivDr'="")
    {
	    s tInDivDr =InDivDr
	    q:$d(^DHCINDIV(tInDivDr))=0 $$$OK
	 }
	 
	 if (AdmDr'="")
    {
	    s tInDivDr =$O(^DHCINDIV(0,"Paadm",AdmDr,""),-1)
	    q:tInDivDr="" $$$OK
	 }
	 
	s ObjInDiv=##class(User.INSUDivide).%OpenId(tInDivDr)
	if (ObjInDiv)
	{
	  do BuildInDiv
	}
	else
	{
		q $$$OK
		
	 }
	 ;Papmi信息
	 s PAPMIDR=$p(^PAADM(AAdmDr),"^",1)
	 s PAPMINo=$p(^PAPER(PAPMIDR,"PAT",1),"^",1)                      ;登记号
	 s PAPMIName=$p(^PAPER(PAPMIDR,"ALL"),"^",1)                      ;HIS建卡姓名             
	 s PaSexDr=$p(^PAPER(PAPMIDR,"ALL"),"^",7)    
     s PAPMISex=$p(^CT("SEX",PaSexDr),"^",2)                          ;性别
	 s PAPMIAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMIDR,AAdmDr) ;年龄
     s PAPMIDob=$p(^PAPER(PAPMIDR,"ALL"),"^",6)                       ;出生日期
     ;Paadm信息
     s OutDateInfo=##class(web.DHCINSUPortUse).GetDischargeDateTime(AAdmDr,"^"_InsuType)
     s:$P(OutDateInfo,"^",1)'="" OutDate=$zd($P(OutDateInfo,"^",1),3)
     s:$P(OutDateInfo,"^",2)'="" OutTime=$zt($P(OutDateInfo,"^",2))
     s:OutDate="" OutDate=AdmDate
     s:OutTime="" OutTime=AdmTime
     s IPDays=$zdh(OutDate,3)-$zdh(AdmDate,3)
     s:+IPDays=0 IPDays=1
    
     s PatAllDiags=##class(web.DHCINSUPortUse).GetPatAllDiagsByADM(AAdmDr,"")
    
     s DiagCBDiagCode="",DiagCBDiagDesc="" ;初步诊断
     s DiagRYDiagCode="",DiagRYDiagDesc="" ;入院诊断
     s DiagMZDiagCode="",DiagMZDiagDesc="" ;门诊诊断
     s DiagCYDiagCode="",DiagCYDiagDesc="" ;出院诊断
    
     s Cnt=$l(PatAllDiags,"$")
     f i=1:1:Cnt
     {
	     s DiagInfo=$P(PatAllDiags,"$",i)
	     s ZDType=$P(DiagInfo,"^",6)
	     i (ZDType="初步诊断")&&(DiagCBDiagCode="")
	     {
		     s DiagCBDiagCode=$P(DiagInfo,"^",3)
		     s DiagCBDiagDesc=$P(DiagInfo,"^",4)
		 }
		 i (ZDType="入院诊断")&&(DiagRYDiagCode="")
	     {
		     s DiagRYDiagCode=$P(DiagInfo,"^",3)
		     s DiagRYDiagDesc=$P(DiagInfo,"^",4)
		 }
		 i (ZDType="门诊诊断")&&(DiagMZDiagCode="")
	     {
		     s DiagMZDiagCode=$P(DiagInfo,"^",3)
		     s DiagMZDiagDesc=$P(DiagInfo,"^",4)
		 }
		  i (ZDType="出院诊断")&&(DiagCYDiagCode="")
	     {
		     s DiagCYDiagCode=$P(DiagInfo,"^",3)
		     s DiagCYDiagDesc=$P(DiagInfo,"^",4)
		 }
	     //w i ,!
	  }
    
     s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AAdmDr) //+ DingSH 20200526
	 s InsuHospCode=##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty00A","InsuHospCode",4,HospDr)
	 s InsuHospDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty00A","InsuHospName",4,HospDr)
	 s hoscategry="三级"
	 s HisAdmType=""
     s:+AAdmDr>0 HisAdmType=$p(^PAADM(AAdmDr),"^",2)
     //i (AdmType1="I")&&(Zstr07="") d
     //.s Zstr07=Zstr09
     //门诊结算单 诊断处理 ,门慢特单病种诊断显示成病种
	 i HisAdmType'="I"  d
	 .i XString2'="" d
	 ..s DiagRYDiagDesc=  XString2
	 .i XString4'="" d
	 ..s DiagCYDiagDesc=  XString4
	 .i DiagCYDiagDesc="" d
	 ..s DiagCYDiagDesc =DiagRYDiagDesc 

	 do BuildJSD
    
 	
 	Quit $$$OK
 	
 	
BuildInDiv
 s (DAdmDr,AdmInfoDr,DHCpblDr,DhcInvPrtDr,Flag,INSUDivideDr,djlsh0,bckbcs,bqbm00,brnl00,cardno,cfms0,crbcts,iDate,iTime,id0000,ptbcts,sUserDr,sfrq00,sfrm0,sfsj00,sftsbz,bie00,ming0,zyksmc,zylsh0,Zstr01,Zstr02,Zstr03,Zstr04,Zstr05,Zstr06,Zstr07,Zstr08,Zstr09,Zstr10,Zstr11,Zstr12,Zstr13,Zstr14,Zstr15,Zstr16,Zstr17,Zstr18,Zstr19,Zstr20,Zstr21,Zstr22,Zstr23,Zstr24,Zstr25,Zstr26,Zstr27,Zstr28,Zstr29,Zstr30)=""
 s (bcbxf0,grzfe0,jjzfe0,zhzfe0,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,InsuPay6,InsuPay7,InsuPay8,InsuPay9,InsuPay10)=0
 s DAdmDr=ObjInDiv.INPAYAdmDrGetObjectId()
 s AdmInfoDr=ObjInDiv.INPAYAdmInfoDrGetObjectId()
 if (AdmInfoDr'="")
 {
	 do BuidInAdm
 }
 s DHCpblDr=ObjInDiv.INPAYDHCpblDrGetObjectId()
 s DhcInvPrtDr=ObjInDiv.INPAYDhcInvPrtDr
 s Flag=ObjInDiv.INPAYFlag
 s INSUDivideDr=ObjInDiv.INPAYINSUDivideDrGetObjectId()
 s bcbxf0=ObjInDiv.INPAYbcbxf0
 s djlsh0=ObjInDiv.INPAYdjlsh0
 s bckbcs=ObjInDiv.INPAYbckbcs
 s bqbm00=ObjInDiv.INPAYbqbm00
 s brnl00=ObjInDiv.INPAYbrnl00
 s cardno=ObjInDiv.INPAYcardno
 s cfms0=ObjInDiv.INPAYcfxms0
 s crbcts=ObjInDiv.INPAYcrbcts
 s grzfe0=ObjInDiv.INPAYgrzfe0
 s iDate=ObjInDiv.INPAYiDate
 s:iDate'="" iDate=$zd(iDate,3)
 s iTime=ObjInDiv.INPAYiTime
 s:iTime'="" iTime=$zt(iTime)
 s id0000=ObjInDiv.INPAYid0000
 s jjzfe0=ObjInDiv.INPAYjjzfe0
 s ptbcts=ObjInDiv.INPAYptbcts
 s sUserDr=ObjInDiv.INPAYsUserDr
 s sfrq00=ObjInDiv.INPAYsfrq00
 s sfrm0=ObjInDiv.INPAYsfrxm0
 s sfsj00=ObjInDiv.INPAYsfsj00
 s sftsbz=ObjInDiv.INPAYsftsbz
 s bie00=ObjInDiv.INPAYxbie00
 s ming0=ObjInDiv.INPAYxming0
 s zhzfe0=ObjInDiv.INPAYzhzfe0
 s zyksmc=ObjInDiv.INPAYzyksmc
 s zylsh0=ObjInDiv.INPAYzylsh0
 s InsuPay1=ObjInDiv.INPAYInsuPay1
 s InsuPay2=ObjInDiv.INPAYInsuPay2
 s InsuPay3=ObjInDiv.INPAYInsuPay3
 s InsuPay4=ObjInDiv.INPAYInsuPay4
 s InsuPay5=ObjInDiv.INPAYInsuPay5
 s Zstr01=ObjInDiv.INPAYZstr01
 s Zstr02=ObjInDiv.INPAYZstr02
 s Zstr03=ObjInDiv.INPAYZstr03
 s Zstr04=ObjInDiv.INPAYZstr04
 s Zstr05=ObjInDiv.INPAYZstr05
 s Zstr06=ObjInDiv.INPAYZstr06
 s Zstr07=ObjInDiv.INPAYZstr07
 s Zstr08=ObjInDiv.INPAYZstr08
 s Zstr09=ObjInDiv.INPAYZstr09
 s Zstr10=ObjInDiv.INPAYZstr10
 s InsuPay6=ObjInDiv.INPAYInsuPay6
 s InsuPay7=ObjInDiv.INPAYInsuPay7
 s InsuPay8=ObjInDiv.INPAYInsuPay8
 s InsuPay9=ObjInDiv.INPAYInsuPay9
 s InsuPay10=ObjInDiv.INPAYInsuPay10
 s Zstr11=ObjInDiv.INPAYZstr11
 s Zstr12=ObjInDiv.INPAYZstr12
 s Zstr13=ObjInDiv.INPAYZstr13
 s Zstr14=ObjInDiv.INPAYZstr14
 s Zstr15=ObjInDiv.INPAYZstr15
 s Zstr16=ObjInDiv.INPAYZstr16
 s Zstr17=ObjInDiv.INPAYZstr17
 s Zstr18=ObjInDiv.INPAYZstr18
 s Zstr19=ObjInDiv.INPAYZstr19
 s Zstr20=ObjInDiv.INPAYZstr20
 s Zstr21=ObjInDiv.INPAYZstr21
 s Zstr22=ObjInDiv.INPAYZstr22
 s Zstr23=ObjInDiv.INPAYZstr23
 s Zstr24=ObjInDiv.INPAYZstr24
 s Zstr25=ObjInDiv.INPAYZstr25
 s Zstr26=ObjInDiv.INPAYZstr26
 s Zstr27=ObjInDiv.INPAYZstr27
 s Zstr28=ObjInDiv.INPAYZstr28
 s Zstr29=ObjInDiv.INPAYZstr29
 s Zstr30=ObjInDiv.INPAYZstr30
 do ObjInDiv.%Close()
 s tmpjob=..GetinsuCateFeeExt(tInDivDr,DhcInvPrtDr,DHCpblDr,"",States)
	 	s (ZlFee,JCFee,SsFee,GhFee,HlFee,CwFee,ZCFee,HyFee,SxFee,ClFee,ZCaoYFee,ZCheFee,XyFee,YBZLFee,QTFee)=0
		s (ZlFee1,JCFee1,SsFee1,GhFee1,HlFee1,CwFee1,ZCFee1,HyFee1,SxFee1,ClFee1,ZCaoYFee1,ZCheFee1,XyFee1,YBZLFee1,QTFee1)=0
		s (ZlFee2,JCFee2,SsFee2,GhFee2,HlFee2,CwFee2,ZCFee2,HyFee2,SxFee2,ClFee2,ZCaoYFee2,ZCheFee2,XyFee2,YBZLFee2,QTFee2)=0
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"01")) CwFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"01"))			//床位费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"02")) ZCFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"02"))	//诊察费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"03")) JCFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"03"))	//检查费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"04")) HyFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"04"))	//化验费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"05")) ZlFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"05"))	//治疗费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"06")) SsFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"06"))	//手术费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"07")) HlFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"07"))	//护理费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"08")) ClFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"08"))	//卫生材料费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"09")) XyFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"09"))	//西药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"10")) ZCaoYFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"10"))	//中草药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"11")) ZCheFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"11"))	//中成药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"12")) YBZLFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"12"))	//一般诊疗费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"13")) GhFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"13"))	//挂号费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"14")) QTFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"14"))	//其他费
	
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"01","ZF")) CwFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"01","ZF"))			//床位费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"02","ZF")) ZCFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"02","ZF"))	//诊察费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"03","ZF")) JCFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"03","ZF"))	//检查费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"04","ZF")) HyFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"04","ZF"))	//化验费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"05","ZF")) ZlFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"05","ZF"))	//治疗费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"06","ZF")) SsFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"06","ZF"))	//手术费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"07","ZF")) HlFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"07","ZF"))	//护理费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"08","ZF")) ClFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"08","ZF"))	//卫生材料费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"09","ZF")) XyFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"09","ZF"))	//西药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"10","ZF")) ZCaoYFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"10","ZF"))	//中草药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"11","ZF")) ZCheFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"11","ZF"))	//中成药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"12","ZF")) YBZLFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"12","ZF"))	//一般诊疗费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"14","ZF")) QTFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"14","ZF"))	//其他费
	
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"01","BFZF")) CwFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"01","BFZF"))			//床位费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"02","BFZF")) ZCFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"02","BFZF"))	//诊察费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"03","BFZF")) JCFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"03","BFZF"))	//检查费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"04","BFZF")) HyFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"04","BFZF"))	//化验费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"05","BFZF")) ZlFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"05","BFZF"))	//治疗费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"06","BFZF")) SsFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"06","BFZF"))	//手术费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"07","BFZF")) HlFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"07","BFZF"))	//护理费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"08","BFZF")) ClFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"08","BFZF"))	//卫生材料费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"09","BFZF")) XyFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"09","BFZF"))	//西药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"10","BFZF")) ZCaoYFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"10","BFZF"))	//药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"11","BFZF")) ZCheFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"11","BFZF"))	//中成药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"12","BFZF")) YBZLFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"12","BFZF"))	//一般诊疗费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"13","BFZF")) GhFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"13","BFZF"))	//挂号费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"14","BFZF")) QTFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"14","BFZF"))	//其他费
 q 
 
BuidInAdm 	
 s (AAdmDr,InsuId,CardNo,PatType,CardStatus,Company,States,Center,Account,AdmSeriNo,ActiveFlag,AdmDate,AdmTime,AdmType,DeptDesc,InsuUser,IpTimes,InsuType,AdmCancelNo,OutDate,OutTime,OutUser,UserDr,FunDate,FunTime,XString1,XString2,XString3,XString4,XFloat1,XFloat2,XFloat3,XFloat4,XString5,XString6,XString7,XString8,XString9,XString10,XString11,XString12,XString13,XString14,XString15,XString16,XString17,XString18,XString19,XString20,InsuAdmInfoDr)=""

 s ObjInAdm=##class(User.INSUAdmInfo).%OpenId(AdmInfoDr)	
 if (ObjInAdm)
 {
	 
	 s AAdmDr=ObjInAdm.INADMAdmDrGetObjectId()
	 s InsuId=ObjInAdm.INADMInsuId
	 s ACardNo=ObjInAdm.INADMCardNo
	 s PatType=ObjInAdm.INADMPatType
	 s CardStatus=ObjInAdm.INADMCardStatus
	 s Company=ObjInAdm.INADMCompany
	 s States=ObjInAdm.INADMStates
	 s Center=ObjInAdm.INADMCenter
	 s Account=ObjInAdm.INADMAccount
	 s AdmSeriNo=ObjInAdm.INADMAdmSeriNo
	 s ActiveFlag=ObjInAdm.INADMActiveFlag
	 s AdmDate=ObjInAdm.INADMAdmDate
	 s:AdmDate'="" AdmDate=$zd(AdmDate,3)
	 s AdmTime=ObjInAdm.INADMAdmTime
	 s:AdmTime'="" AdmTime=$zt(AdmTime)
	 s AdmType=ObjInAdm.INADMAdmType
	 s DeptDesc=ObjInAdm.INADMDeptDesc
	 s InsuUser=ObjInAdm.INADMInsuUser
	 s IpTimes=ObjInAdm.INADMIpTimes
	 s InsuType=ObjInAdm.INADMInsuType
	 s AdmCancelNo=ObjInAdm.INADMAdmCancelNo
	 s OutDate=ObjInAdm.INADMOutDate
	 s OutTime=ObjInAdm.INADMOutTime
	 s OutUser=ObjInAdm.INADMOutUser
	 s UserDr=ObjInAdm.INADMUserDrGetObjectId()
	 s FunDate=ObjInAdm.INADMFunDate
	 s:FunDate'="" FunDate=$zd(FunDate,3)
	 s FunTime=ObjInAdm.INADMFunTime
	 s:FunTime'="" FunTime=$zt(FunTime)
	 s XString1=ObjInAdm.INADMXString1
	 s XString2=ObjInAdm.INADMXString2
	 s XString3=ObjInAdm.INADMXString3
	 s XString4=ObjInAdm.INADMXString4
	 s XFloat1=ObjInAdm.INADMXFloat1
	 s XFloat2=ObjInAdm.INADMXFloat2
	 s XFloat3=ObjInAdm.INADMXFloat3
	 s XFloat4=ObjInAdm.INADMXFloat4
	 s XString5=ObjInAdm.INADMXString5
	 s XString6=ObjInAdm.INADMXString6
	 s XString7=ObjInAdm.INADMXString7
	 s XString8=ObjInAdm.INADMXString8
	 s XString9=ObjInAdm.INADMXString9
	 s XString10=ObjInAdm.INADMXString10
	 s XString11=ObjInAdm.INADMXString11
	 s XString12=ObjInAdm.INADMXString12
	 s XString13=ObjInAdm.INADMXString13
	 s XString14=ObjInAdm.INADMXString14
	 s XString15=ObjInAdm.INADMXString15
	 s XString16=ObjInAdm.INADMXString16
	 s XString17=ObjInAdm.INADMXString17
	 s XString18=ObjInAdm.INADMXString18
	 s XString19=ObjInAdm.INADMXString19
	 s XString20=ObjInAdm.INADMXString20
	 s InsuAdmInfoDr=ObjInAdm.INADMInsuAdmInfoDrGetObjectId()
	 do ObjInAdm.%Close()
	 ;st-数据字典描述
	 s tHospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AAdmDr)
	 s tmpInsuPatTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKC021"_InsuType,PatType,4,tHospDr)
	 s tmpInsuAdmTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKA130"_InsuType,AdmType,4,tHospDr)
	 s:tmpInsuPatTypeDesc'="" PatType=tmpInsuPatTypeDesc
	 s:tmpInsuAdmTypeDesc'="" AdmType=tmpInsuAdmTypeDesc
	 
	 s tmpXString7=##class(web.INSUDicDataCom).GetDicByCodeAndInd("insutype"_InsuType,XString7,4,tHospDr)
	 s:(tmpXString7'="") XString7=tmpXString7
	 
	 //s tmpStateDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("YAB003"_InsuType,States,4,tHospDr)
	// s:tmpStateDesc'="" States=tmpStateDesc
	 s tmpCenterDesc=..GetCenterDesc(Center,InsuType,tHospDr) //DingSH 20211103
	 s:tmpCenterDesc'="" Center=tmpCenterDesc
	 ;注意,医保类型要放到最后编程描述
	 s tmpInsuTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DLLType",InsuType,4,tHospDr)
	 s:tmpInsuTypeDesc'="" InsuType=tmpInsuTypeDesc
	 ;ed-数据字典描述
	 
	 
 }
 else{
	 q $$$OK
	 }
 
 q	
 
BuildJSD	
	Set data = $lb(QueryInsuJSD,AAdmDr,InsuId,ACardNo,PatType,CardStatus,Company,States,Center,Account,AdmSeriNo,ActiveFlag,AdmDate,AdmTime,AdmType,DeptDesc,InsuUser,IpTimes,InsuType,AdmCancelNo,OutDate,OutTime,OutUser,UserDr,FunDate,FunTime,XString1,XString2,XString3,XString4,XFloat1,XFloat2,XFloat3,XFloat4,XString5,XString6,XString7,XString8,XString9,XString10,XString11,XString12,XString13,XString14,XString15,XString16,XString17,XString18,XString19,XString20,InsuAdmInfoDr,DAdmDr,AdmInfoDr,DHCpblDr,DhcInvPrtDr,Flag,INSUDivideDr,bcbxf0,djlsh0,bckbcs,bqbm00,brnl00,cardno,cfms0,crbcts,grzfe0,iDate,iTime,id0000,jjzfe0,ptbcts,sUserDr,sfrq00,sfrm0,sfsj00,sftsbz,bie00,ming0,zhzfe0,zyksmc,zylsh0,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,Zstr01,Zstr02,Zstr03,Zstr04,Zstr05,Zstr06,Zstr07,Zstr08,Zstr09,Zstr10,InsuPay6,InsuPay7,InsuPay8,InsuPay9,InsuPay10,Zstr11,Zstr12,Zstr13,Zstr14,Zstr15,Zstr16,Zstr17,Zstr18,Zstr19,Zstr20,Zstr21,Zstr22,Zstr23,Zstr24,Zstr25,Zstr26,Zstr27,Zstr28,Zstr29,Zstr30,PAPMINo,PAPMIName,PAPMISex,PAPMIAge,IPDays,DiagCBDiagCode,DiagCBDiagDesc,DiagRYDiagCode,DiagRYDiagDesc,DiagMZDiagCode,DiagMZDiagDesc,DiagCYDiagCode,DiagCYDiagDesc)
 	Set ^CacheTemp(repid,ind) = data
 	b  ;
 	Set ind = ind +1
 	q
}

ClassMethod QueryInsuJSDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInsuJSDExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:ZhanMingChao
/// Description:获取医保分类金额
/// InvDr:发票号
/// bill:账单号
/// FeeType:分类,暂时没用，默认取的是医保的分类
/// w ##class(web.DHCINSUDivQue).GetinsuCateFee("","","7787363","")
ClassMethod GetinsuCateFeeExt(tInDivDr, InvDr, bill, FeeType, DQ)
{
    n (tInDivDr,InvDr,bill,FeeType,DQ)
    s catejob=+InvDr_"-"_(+bill)_"-"_$j
    s str="-1"
    k:$d(^TMP("INSUBILL","InsuCateFee",catejob)) ^TMP("INSUBILL","InsuCateFee",catejob)
    s ^TMP("INSUBILL","InsuCateFee",catejob)=0
    
    if (+bill'=0){
	    //b //住院数据
        d GetInsuCateExt        
    }elseif(+InvDr'=0){
	    //门诊数据
	    s BillConInvRowid=""
	    f  s BillConInvRowid=$o(^DHCBCI(0,"INV",InvDr,BillConInvRowid)) q:BillConInvRowid=""  d
	    .s ConStr=$g(^DHCBCI(BillConInvRowid))
	    .s bill=$p(ConStr,"^",2)
	    .q:bill=""
	    .d GetInsuCateExt
    }else{
	    //d getHisCate
    }
    
    ;B ;D
    q str
   
GetInsuCateExt

    	s str=catejob
		s disrowid=0      //   insu_dividesub
        i ($d(^DHCINDIS("0","DivideDr",tInDivDr))'=0)  d
        .f  s disrowid=$o(^DHCINDIS("0","DivideDr",tInDivDr,disrowid))  q:disrowid=""   d
        ..d DivSubCate
        e   d
        .i (+bill'=0)&&($d(^DHCINDIS("0","PBDr",bill))'=0) d
        ..f  s disrowid=$o(^DHCINDIS("0","PBDr",bill,disrowid))  q:disrowid=""   d
        ...d DivSubCate
        q 
        
DivSubCate       
        //b ;123
        s disStr=^DHCINDIS(disrowid)
        s tmpInsucateFee=$p(disStr,"^",13)   //总金额
        s InsucateCode=$p(disStr,"^",29)     //医保分类
        s:InsucateCode="" InsucateCode="14"
       	s preself=$p(disStr,"^",17)          //部分项目自付
       	s fulownamt=$p(disStr,"^",26)+$p(disStr,"^",28)        //自费
       
        //B ;InsucateCode
		i InsucateCode'="" d
		.i $d(^TMP("INSUBILL","InsuCateFee",catejob,InsucateCode))=0  d
		..s ^TMP("INSUBILL","InsuCateFee",catejob,InsucateCode)=tmpInsucateFee
		..s ^TMP("INSUBILL","InsuCateFee",catejob,InsucateCode,"ZF")=fulownamt
		..s ^TMP("INSUBILL","InsuCateFee",catejob,InsucateCode,"BFZF")=preself
		..//b ;ds
		.e  d
        ..s ^TMP("INSUBILL","InsuCateFee",catejob,InsucateCode)=+(^TMP("INSUBILL","InsuCateFee",catejob,InsucateCode))+tmpInsucateFee
		..s ^TMP("INSUBILL","InsuCateFee",catejob,InsucateCode,"ZF")=+(^TMP("INSUBILL","InsuCateFee",catejob,InsucateCode,"ZF"))+fulownamt
		..s ^TMP("INSUBILL","InsuCateFee",catejob,InsucateCode,"BFZF")=+(^TMP("INSUBILL","InsuCateFee",catejob,InsucateCode,"BFZF"))+preself
		..//b ;sda
		q 
		;b ;212
}

/// 4101-5  iteminfo  收费项目信息 （计费医保组）
/// 入参:BillDr 住院账单表rowid，PrtDr 门诊发票表rowid，InDivDr 医保结算表rowid，AdmDr 就诊rowid，(四选一)  ？？
/// 	 ExpStr 扩展参数 暂空
/// 出参:MedChrgitm:医疗收费项目类别,AmtSum:金额,ClaaSumfeeSum:甲类费用合计,ClabAmtSum:乙类费用合计,FulamtOwnpayAmtSum:全自费金额合计,OthAmtSum:其他金额合计
/// 出参:
/// MedChrgitm:医疗收费项目类别,
/// AmtSum:金额,
/// ClaaSumfeeSum:甲类费用合计,
/// ClabAmtSum:乙类费用合计,
/// FulamtOwnpayAmtSum:全自费金额合计,
/// OthAmtSum:其他金额合计
/// 注意事项：要是核实是  收费项目明细 还是按收费项目分类汇总  liusf  2021 03 28
/// (PrtDr="")&&(BillDr="")&&(InDivDr="")&&(AdmDr="")    这个四个参数哪里来的  liusf
/// 负责人：交付中心、计费医保共同完成     ；根据当地医保程序修改
Query GetPatFeeItemInfo(BillDr As %String = "", PrtDr As %String = "", InDivDr As %String = "", AdmDr As %String = "", ExpStr As %String = "") As websys.Query(ROWSPEC = "MedChrgitm:%String,MedChrgitmDesc:%String,AmtSum:%Float,ClaaSumfeeSum,ClabAmtSum,FulamtOwnpayAmtSum,OthAmtSum,SetlId,MdtrtId,JsdId,INDISDemo2:%Float,INDISSelf:%Float,INDISDemo1:%Float,INDISDemo3:%Float") [ SqlProc ]
{
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSUDivQue","GetPatFeeItemInfo","2127118","","","","")
/// 
ClassMethod GetPatFeeItemInfoExecute(ByRef qHandle As %Binary, BillDr As %String = "", PrtDr As %String = "", InDivDr As %String = "", AdmDr As %String = "", ExpStr As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)  
    ;s ^TMPZMC("GetPatFeeItemInfo")=BillDr_","_PrtDr_","_InDivDr
    s HisDesc="",HisCode="",UnitPrice="",Quality="",Amount=""
    q:(PrtDr="")&&(BillDr="")&&(InDivDr="")&&(AdmDr="") $$$OK
	q:(PrtDr'="")&&($d(^DHCINVPRT(PrtDr))=0) $$$OK
	q:(BillDr'="")&&($d(^DHCPB(BillDr))=0) $$$OK
	if BillDr'="" {
		q:$d(^DHCINDIV("0","DHCPB",BillDr))=0 $$$OK
		s InsuDivDr=$o(^DHCINDIV("0","DHCPB",BillDr,""),-1)
	}
	if PrtDr'="" {
		q:$d(^DHCINDIV("0","DHCInvPrt",PrtDr))=0 $$$OK
		s InsuDivDr=$o(^DHCINDIV("0","DHCInvPrt",PrtDr,""),-1)
	}
	if InDivDr'="" {
		q:$d(^DHCINDIV(InDivDr))=0 $$$OK
		s InsuDivDr=InDivDr
	}
	if AdmDr'="" {
		q:$d(^DHCINDIV("0","Paadm",AdmDr))=0 $$$OK
		s InsuDivDr=$o(^DHCINDIV("0","Paadm",AdmDr,""),-1)
	}
	q:InsuDivDr="" $$$OK
	k Sort("InsuIteminfo",InsuDivDr)
	s InsuDivInfo=$g(^DHCINDIV(InsuDivDr))
	s SetlId=$p(InsuDivInfo,"^",8)
	;s SetlId=$p(InsuDivInfo,"^",69)
	s MdtrtId=$p(InsuDivInfo,"^",30)
	s JsdId=$p($g(^DHCINDIV(InsuDivDr)),"^",67)   //医保结算单流水号 每个项目不一样需要修改
    s tAdmDr = $p(InsuDivInfo,"^",2)
    s HospDr= $p(InsuDivInfo,"^",71)
    s:HospDr="" HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(tAdmDr) //+ DingSH 20200526
	s INDISRowid=""
	f  s INDISRowid=$o(^DHCINDIS("0","DivideDr",InsuDivDr,INDISRowid)) q:INDISRowid=""  d
	.s INDISInfo=$g(^DHCINDIS(INDISRowid))
	.s INDISFlag=$p(INDISInfo,"^",18)
	.q:INDISFlag'="N"  ;JINS 20221128  只去明细状态为N的数据
	.s INSUItmDr=$p(INDISInfo,"^",4)	;
	.s TarItmDr=$p(INDISInfo,"^",3)
	.s INDISINSUXMLB=$p(INDISInfo,"^",10)
	.s INDISQty=+$p(INDISInfo,"^",11)
	.s INDISPrice=$p(INDISInfo,"^",12)
	.s INDISAmount=+$p(INDISInfo,"^",13)
	.s INDISTarCate=$p(INDISInfo,"^",14)
	.s INDISScale=$p(INDISInfo,"^",15)	;自付比例
	.s INDISFund=$p(INDISInfo,"^",16)
	.s INDISSelf=+$p(INDISInfo,"^",17)	;先行自付
	.s INDISDemo1=+$p(INDISInfo,"^",26)	;全自费
	.s INDISDemo2=+$p(INDISInfo,"^",27)	;符合范围
	.s INDISDemo3=+$p(INDISInfo,"^",28)	;超限
	.s TARISubCateDr=$P(^DHCTARI(TarItmDr),"^",4)
	.s TARISubCate=$P(^DHCTarC("SC",TARISubCateDr),"^",1)
	.s INDISDemo4=$p(INDISInfo,"^",29)	;医疗收费项目   ;根据当地当地程序修改
	.;s INDISDemo4 = ##class(web.INSUDicDataCom).GetDicByCodeAndInd("medchrgitmtypeCon00A",TARISubCate,6)
	.s:INDISDemo4="" INDISDemo4="14"	;14其他费
	
	.s (ClaaSumfee,ClabAmt,FulamtOwnpayAmt,OthAmt)=0
	.i INDISINSUXMLB="01"||INDISINSUXMLB="甲类" d
	..s ClaaSumfee=INDISAmount	; 甲类费用        ;3 28  每个地方要修改
	.e  i INDISINSUXMLB="02"||INDISINSUXMLB="乙类" d
	..s ClabAmt=INDISAmount	    ; 乙类费用        ;3 28  每个地方要修改
	.e   d
	..s OthAmt=INDISAmount                        ;3 28  每个地方要修改
	.i $d(Sort("InsuIteminfo",InsuDivDr,INDISDemo4))=0 d
	..s Sort("InsuIteminfo",InsuDivDr,INDISDemo4)=INDISDemo4_"^"_INDISAmount_"^"_ClaaSumfee_"^"_ClabAmt_"^"_FulamtOwnpayAmt_"^"_OthAmt_"^"_INDISDemo2_"^"_INDISSelf_"^"_INDISDemo1_"^"_INDISDemo3
	.e  d
	..s $p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",2)=+$p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",2)+INDISAmount
	..s $p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",3)=+$p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",3)+ClaaSumfee
	..s $p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",4)=+$p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",4)+ClabAmt
	..s $p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",5)=+$p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",5)+FulamtOwnpayAmt
	..s $p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",6)=+$p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",6)+OthAmt
	..s $p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",7)=+$p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",7)+INDISDemo2
	..s $p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",8)=+$p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",8)+INDISSelf
	..s $p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",9)=+$p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",9)+INDISDemo1
	..s $p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",10)=+$p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",10)+INDISDemo3
	
	s MedChrgitm=""
	f  s MedChrgitm=$o(Sort("InsuIteminfo",InsuDivDr,MedChrgitm)) q:MedChrgitm=""  d
	.s AmtSum=$p(Sort("InsuIteminfo",InsuDivDr,MedChrgitm),"^",2)
	.s ClaaSumfeeSum=$p(Sort("InsuIteminfo",InsuDivDr,MedChrgitm),"^",3)
	.s ClabAmtSum=$p(Sort("InsuIteminfo",InsuDivDr,MedChrgitm),"^",4)
	.s FulamtOwnpayAmtSum=$p(Sort("InsuIteminfo",InsuDivDr,MedChrgitm),"^",5)
	.s OthAmtSum=$p(Sort("InsuIteminfo",InsuDivDr,MedChrgitm),"^",6)
	.s INDISDemo2=$p(Sort("InsuIteminfo",InsuDivDr,MedChrgitm),"^",7)
	.s INDISSelf=$p(Sort("InsuIteminfo",InsuDivDr,MedChrgitm),"^",8)
	.s INDISDemo1=$p(Sort("InsuIteminfo",InsuDivDr,MedChrgitm),"^",9)
	.s INDISDemo3=$p(Sort("InsuIteminfo",InsuDivDr,MedChrgitm),"^",10)
	.s MedChrgitmDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("med_chrgitm_type00A",MedChrgitm,4,HospDr)
    .d InsuIteminfoBuild
    Quit $$$OK
    
InsuIteminfoBuild
    set Data=$lb(MedChrgitm,MedChrgitmDesc,AmtSum,ClaaSumfeeSum,ClabAmtSum,FulamtOwnpayAmtSum,OthAmtSum,SetlId,MdtrtId,JsdId,INDISDemo2,INDISSelf,INDISDemo1,INDISDemo3)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// 根据统筹区代码获取省市县（区）字典描述
/// w ##class(web.DHCINSUDivQue).GetCenterDesc("360102","00A","2")
/// 例如 江西省南昌市东湖区 
/// DingSH 2021103
ClassMethod GetCenterDesc(Center, InsuType, HospDr)
{
	
	 s rtn=""
	 s PCCode="", PCDesc="",CCCode="",CCDesc=""
	 s PCCode=$e(Center,1,2)_"0000"
	 s CCCode=$e(Center,1,4)_"00"
	 s PCDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("YAB003"_InsuType,PCCode,4,HospDr)
	 i PCDesc="" d
	 .s PCDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("admdvs"_InsuType,PCCode,4,HospDr)
	 s CCDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("YAB003"_InsuType,CCCode,4,HospDr)
	 i CCDesc="" d
	 .s CCDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("admdvs"_InsuType,CCCode,4,HospDr)
	 s tmpCenterDesc=""
	 s tmpCenterDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("YAB003"_InsuType,Center,4,HospDr)
	 i tmpCenterDesc="" d
	 .;s tmpCenterDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("insuplc_admdvs"_InsuType,Center,4,HospDr)
	 .s tmpCenterDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("admdvs"_InsuType,Center,4,HospDr)	
	 s rtn=PCDesc
	 i CCCode=Center d
	 .s rtn=rtn_CCDesc
	 e   d
	 .s rtn=rtn_CCDesc_tmpCenterDesc
	 q rtn
}

/// 说明：获取医保结算单数据。
/// /  2019-09-03 DingSH 
/// 入参：
///     BillDr:账单表rowid
///     PrtDr:门诊发票rowid或门诊发票rowid串(!分割)或体检发票Rowid;不推荐此字段,而门诊推荐用InDivDr字段
/// 	InDivDr:医保结算表Rowid
///     AdmDr:就诊表rowid
/// 出参：
/// d ##class(%ResultSet).RunQuery("web.DHCINSUDivQue","QueryInsuJSD","","","289617","","")
/// d ##class(%ResultSet).RunQuery("web.DHCINSUDivQue","QueryInsuJSDNew","","871227","","","")
Query QueryInsuJSDNew(BillDr As %String = "", PrtDr As %String = "", InDivDr As %String = "", AdmDr As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "TInd,AAdmDr:%String,InsuId:%String,ACardNo:%String,PatType:%String,CardStatus:%String,Company:%String,States:%String,Center:%String,Account:%String,AdmSeriNo:%String,ActiveFlag:%String,AdmDate:%String,AdmTime:%String,AdmType:%String,DeptDesc:%String,InsuUser:%String,IpTimes:%String,InsuType:%String,AdmCancelNo:%String,OutDate:%String,OutTime:%String,OutUser:%String,UserDr:%String,FunDate:%String,FunTime:%String,XString1:%String,XString2:%String,XString3:%String,XString4:%String,XFloat1:%String,XFloat2:%String,XFloat3:%String,XFloat4:%String,XString5:%String,XString6:%String,XString7:%String,XString8:%String,XString9:%String,XString10:%String,XString11:%String,XString12:%String,XString13:%String,XString14:%String,XString15:%String,XString16:%String,XString17:%String,XString18:%String,XString19:%String,XString20:%String,InsuAdmInfoDr:%String,DAdmDr:%String,DAdmInfoDr:%String,DHCpblDr:%String,DhcInvPrtDr:%String,Flag:%String,INSUDivideDr:%String,bcbxf0:%Float,djlsh0:%String,bckbcs:%String,bqbm00:%String,brnl00:%String,cardno:%String,cfms0:%String,crbcts:%String,grzfe0:%Float,iDate:%String,iTime:%String,id0000:%String,jjzfe0:%Float,ptbcts:%String,sUserDr:%String,sfrq00:%String,sfrm0:%String,sfsj00:%String,sftsbz:%String,bie00:%String,ming0:%String,zhzfe0:%Float,zyksmc:%String,zylsh0:%String,InsuPay1:%Float,InsuPay2:%Float,InsuPay3:%Float,InsuPay4:%Float,InsuPay5:%Float,Zstr01:%String,Zstr02:%String,Zstr03:%String,Zstr04:%String,Zstr05:%String,Zstr06:%String,Zstr07:%String,Zstr08:%String,Zstr09:%String,Zstr10:%String,InsuPay6:%Float,InsuPay7:%Float,InsuPay8:%Float,InsuPay9:%Float,InsuPay10:%Float,Zstr11:%String,Zstr12:%String,Zstr13:%String,Zstr14:%String,Zstr15:%String,Zstr16:%String,Zstr17:%String,Zstr18:%String,Zstr19:%String,Zstr20:%String,Zstr21:%String,Zstr22:%String,Zstr23:%String,Zstr24:%String,Zstr25:%String,Zstr26:%String,Zstr27:%String,Zstr28:%String,Zstr29:%String,Zstr30:%String,PAPMINo:%String,PAPMIName:%String,PAPMISex:%String,PAPMIAge:%String,IPDays:%String,DiagCBDiagCode:%String,DiagCBDiagDesc:%String,DiagRYDiagCode:%String,DiagRYDiagDesc:%String,DiagMZDiagCode:%String,DiagMZDiagDesc:%String,DiagCYDiagCode:%String,DiagCYDiagDesc:%String,ZlFee:%Float,JCFee:%Float,SsFee:%Float,GhFee:%Float,HlFee:%Float,CwFee:%Float,ZCFee:%Float,HyFee:%Float,SxFee:%Float,ClFee:%Float,ZCaoYFee:%Float,ZCheFee:%Float,XyFee:%Float,YBZLFee:%Float,QTFee:%Float,PAPMIDob:%String,Tel:%String,BedID:%String,Medicare:%String,ZlFee1:%Float,JCFee1:%Float,SsFee1:%Float,GhFee1:%Float,HlFee1:%Float,CwFee1:%Float,ZCFee1:%Float,HyFee1:%Float,SxFee1:%Float,ClFee1:%Float,ZCaoYFee1:%Float,ZCheFee1:%Float,XyFee1:%Float,YBZLFee1:%Float,QTFee1:%Float,ZlFee2:%Float,JCFee2:%Float,SsFee2:%Float,GhFee2:%Float,HlFee2:%Float,CwFee2:%Float,ZCFee2:%Float,HyFee2:%Float,SxFee2:%Float,ClFee2:%Float,ZCaoYFee2:%Float,ZCheFee2:%Float,XyFee2:%Float,YBZLFee2:%Float,QTFee2:%Float,GwyBZ,Grsflb,InsuHospCode,InsuHospDesc,yljzbz") [ SqlProc ]
{
}

ClassMethod QueryInsuJSDNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInsuJSDNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryInsuJSDNewExecute(ByRef qHandle As %Binary, BillDr As %String = "", PrtDr As %String = "", InDivDr As %String = "", AdmDr As %String = "", ExpStr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//s ^Temp(1)=BillDr_","_PrtDr_","_InDivDr_","_AdmDr
	s (AAdmDr,InsuId,ACardNo,PatType,CardStatus,Company,States,Center,Account,AdmSeriNo,ActiveFlag,AdmDate,AdmTime,AdmType,DeptDesc,InsuUser,IpTimes,InsuType,AdmCancelNo,OutDate,OutTime,OutUser,UserDr,FunDate,FunTime,XString1,XString2,XString3,XString4,XFloat1,XFloat2,XFloat3,XFloat4,XString5,XString6,XString7,XString8,XString9,XString10,XString11,XString12,XString13,XString14,XString15,XString16,XString17,XString18,XString19,XString20,InsuAdmInfoDr,DAdmDr,AdmInfoDr,DHCpblDr,DhcInvPrtDr,Flag,INSUDivideDr,bcbxf0,djlsh0,bckbcs,bqbm00,brnl00,cardno,cfms0,crbcts,grzfe0,iDate,iTime,id0000,jjzfe0,ptbcts,sUserDr,sfrq00,sfrm0,sfsj00,sftsbz,bie00,ming0,zhzfe0,zyksmc,zylsh0,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,Zstr01,Zstr02,Zstr03,Zstr04,Zstr05,Zstr06,Zstr07,Zstr08,Zstr09,Zstr10)=""
	s (InsuPay6,InsuPay7,InsuPay8,InsuPay9,InsuPay10,Zstr11,Zstr12,Zstr13,Zstr14,Zstr15,Zstr16,Zstr17,Zstr18,Zstr19,Zstr20,Zstr21,Zstr22,Zstr23,Zstr24,Zstr25,Zstr26,Zstr27,Zstr28,Zstr29,Zstr30,PAPMINo,PAPMIName,PAPMISex,PAPMIAge,IPDays,DiagCBDiagCode,DiagCBDiagDesc,DiagRYDiagCode,DiagRYDiagDesc,DiagMZDiagCode,DiagMZDiagDesc,DiagCYDiagCode,DiagCYDiagDesc,ZlFee,JCFee,SsFee,GhFee,HlFee,CwFee,ZCFee,HyFee,SxFee,ClFee,ZCaoYFee,ZCheFee,XyFee,YBZLFee,QTFee)=""
	s (PAPMIDob)=""
 	q:(BillDr="")&&(PrtDr="")&&(InDivDr="")&&(AdmDr="") $$$OK
 	set tInDivDr=""
    if (BillDr'="")
    {
	    s tInDivDr =$O(^DHCINDIV(0,"DHCPB",BillDr,""),-1)
	    q:tInDivDr="" $$$OK
	 }
	 
	 if (PrtDr'="")
    {
	    s tInDivDr =$O(^DHCINDIV(0,"DHCInvPrt",PrtDr,""),-1)
	    q:tInDivDr="" $$$OK
	 }
	 
	 if (InDivDr'="")
    {
	    s tInDivDr =InDivDr
	    q:$d(^DHCINDIV(tInDivDr))=0 $$$OK
	 }
	 
	 if (AdmDr'="")
    {
	    s tInDivDr =$O(^DHCINDIV(0,"Paadm",AdmDr,""),-1)
	    q:tInDivDr="" $$$OK
	 }
	 
	s ObjInDiv=##class(User.INSUDivide).%OpenId(tInDivDr)
	if (ObjInDiv)
	{
	  do BuildInDivNew
	}
	else
	{
		q $$$OK
		
	 }
	;Papmi信息
	s PAPMIDR=$p(^PAADM(AAdmDr),"^",1)
	s PAPMINo=$p(^PAPER(PAPMIDR,"PAT",1),"^",1)                      ;登记号
	s PAPMIName=$p(^PAPER(PAPMIDR,"ALL"),"^",1)                      ;HIS建卡姓名             
	s PaSexDr=$p(^PAPER(PAPMIDR,"ALL"),"^",7)    
	s PAPMISex=$p(^CT("SEX",PaSexDr),"^",2)                          ;性别
	s PAPMIAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMIDR,AAdmDr) ;年龄
	s PAPMIDob=$p(^PAPER(PAPMIDR,"ALL"),"^",6)                       ;出生日期
	s:PAPMIDob'="" PAPMIDob=$zd(PAPMIDob,3)
	s:PAPMIDob'="" PAPMIDob=$e(PAPMIDob,1,7)
	s Tel=$p(^PAPER(PAPMIDR,"PER",1),"^",11)   //电话
	s:Tel'="" Tel=$e(Tel,1,3)_"******"_$e(Tel,10,11) //电话脱敏
	s WardID=$p(^PAADM(AAdmDr),"^",70)
	s BedID=$p(^PAADM(AAdmDr),"^",73) //床位
	i (BedID="")!(WardID="") d
	.s BedID=""
	e       d
	.i ('$d(^PAWARD(WardID,"BED",$p(BedID,"||",2))))  d
	..s BedID=""
	.e        d
	..s BedID= $p(^PAWARD(WardID,"BED",$p(BedID,"||",2)),"^",1)_"床"
    i BedID="" d	
    .set BedID=##class(web.DHCBillCommon).GetPatBedCode(AAdmDr)
	.set:(BedID'="") BedID=BedID_"床"
    
	s Medicare=""
	s PaAdmType=$p(^PAADM(AAdmDr),"^",2) // 门诊（O）、急诊（E）、住院（I）
	s Medicare=##class(web.DHCWMRService).IGetMrNoByPatientID(PAPMIDR)
    s:Medicare="" Medicare=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(AAdmDr,PaAdmType, "") 
     //b ;Paadm信息
     s OutDateInfo=##class(web.DHCINSUPortUse).GetDischargeDateTime(AAdmDr)
     //b ;dddd
     s:$P(OutDateInfo,"^",1)'="" OutDate=$zd($P(OutDateInfo,"^",1),3)
     s:$P(OutDateInfo,"^",2)'="" OutTime=$zt($P(OutDateInfo,"^",2))
     s:OutDate="" OutDate=AdmDate
     s:OutTime="" OutTime=AdmTime
     s IPDays=$zdh(OutDate,3)-$zdh(AdmDate,3)
     s:+IPDays=0 IPDays=1
    
     s PatAllDiags=##class(web.DHCINSUPortUse).GetPatAllDiagsByADM(AAdmDr,"")
    
     s DiagCBDiagCode="",DiagCBDiagDesc="" ;初步诊断
     s DiagRYDiagCode="",DiagRYDiagDesc="" ;入院诊断
     s DiagMZDiagCode="",DiagMZDiagDesc="" ;门诊诊断
     s DiagCYDiagCode="",DiagCYDiagDesc="" ;出院诊断
    
    
     s Cnt=$l(PatAllDiags,"$")
     f i=1:1:Cnt
     {
	     s DiagInfo=$P(PatAllDiags,"$",i)
	     s ZDType=$P(DiagInfo,"^",6)
	     s MainDiagFlag=$P(DiagInfo,"^",13)
	     i (ZDType="初步诊断")&&(DiagCBDiagCode="")&&(MainDiagFlag="Y")
	     {
		     s DiagCBDiagCode=$P(DiagInfo,"^",3)
		     s DiagCBDiagDesc=$P(DiagInfo,"^",4)
		 }
		 i (ZDType="入院诊断")&&(DiagRYDiagCode="")&&(MainDiagFlag="Y")
	     {
		     s DiagRYDiagCode=$P(DiagInfo,"^",3)
		     s DiagRYDiagDesc=$P(DiagInfo,"^",4)
		 }
		 i (ZDType="门诊诊断")&&(DiagMZDiagCode="")&&(MainDiagFlag="Y")
	     {
		     s DiagMZDiagCode=$P(DiagInfo,"^",3)
		     s DiagMZDiagDesc=$P(DiagInfo,"^",4)
		 }
		  i (ZDType="出院诊断")&&(DiagCYDiagCode="")&&(MainDiagFlag="Y")
	     {
		     s DiagCYDiagCode=$P(DiagInfo,"^",3)
		     s DiagCYDiagDesc=$P(DiagInfo,"^",4)
		 }

	  }
	 s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AAdmDr) //+ DingSH 20200526
	 s InsuHospCode=##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty00A","InsuHospCode",4,HospDr)
	 s InsuHospDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty00A","InsuHospName",4,HospDr)
	 s HisAdmType=""
     s:+AAdmDr>0 HisAdmType=$p(^PAADM(AAdmDr),"^",2)
     //i (AdmType1="I")&&(Zstr07="") d
     //.s Zstr07=Zstr09
     //门诊结算单 诊断处理 ,门慢特单病种诊断显示成病种
	 i HisAdmType'="I"  d
	 .i XString2'="" d
	 ..s DiagRYDiagDesc=  XString2
	 .i XString4'="" d
	 ..s DiagCYDiagDesc=  XString4
	 .i DiagCYDiagDesc="" d
	 ..s DiagCYDiagDesc =DiagRYDiagDesc 

	do BuildJSDNew
    
 	
 	Quit $$$OK
 	
 	
BuildInDivNew
	s (DAdmDr,AdmInfoDr,DHCpblDr,DhcInvPrtDr,Flag,INSUDivideDr,djlsh0,bckbcs,bqbm00,brnl00,cardno,cfms0,crbcts,iDate,iTime,id0000,ptbcts,sUserDr,sfrq00,sfrm0,sfsj00,sftsbz,bie00,ming0,zyksmc,zylsh0,Zstr01,Zstr02,Zstr03,Zstr04,Zstr05,Zstr06,Zstr07,Zstr08,Zstr09,Zstr10,Zstr11,Zstr12,Zstr13,Zstr14,Zstr15,Zstr16,Zstr17,Zstr18,Zstr19,Zstr20,Zstr21,Zstr22,Zstr23,Zstr24,Zstr25,Zstr26,Zstr27,Zstr28,Zstr29,Zstr30,GwyBZ)=""
	s (bcbxf0,grzfe0,jjzfe0,zhzfe0,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,InsuPay6,InsuPay7,InsuPay8,InsuPay9,InsuPay10)=0
	s DAdmDr=ObjInDiv.INPAYAdmDrGetObjectId()
	s AdmInfoDr=ObjInDiv.INPAYAdmInfoDrGetObjectId()
	if (AdmInfoDr'="")
	{
	 do BuidInAdmNew
	}
	s DHCpblDr=ObjInDiv.INPAYDHCpblDrGetObjectId()
	//s DhcInvPrtDr=ObjInDiv.INPAYDhcInvPrtDrGetObjectId() //？？部分项目 User.INSUDivide.DhcInvPrtDr 非指针形式要注意
	s DhcInvPrtDr=ObjInDiv.INPAYDhcInvPrtDr
	s Flag=ObjInDiv.INPAYFlag
	q:Flag'="I"
	s INSUDivideDr=ObjInDiv.INPAYINSUDivideDrGetObjectId()
	s bcbxf0=ObjInDiv.INPAYbcbxf0
	s djlsh0=ObjInDiv.INPAYdjlsh0
	s bckbcs=ObjInDiv.INPAYbckbcs
	s bqbm00=ObjInDiv.INPAYbqbm00
	s brnl00=ObjInDiv.INPAYbrnl00
	s cardno=ObjInDiv.INPAYcardno
	s cfms0=ObjInDiv.INPAYcfxms0
	s crbcts=ObjInDiv.INPAYcrbcts
	s grzfe0=ObjInDiv.INPAYgrzfe0
	s iDate=ObjInDiv.INPAYiDate
	s:iDate'="" iDate=$zd(iDate,3)
	s iTime=ObjInDiv.INPAYiTime
	s:iTime'="" iTime=$zt(iTime)
	s id0000=ObjInDiv.INPAYid0000
	s jjzfe0=ObjInDiv.INPAYjjzfe0
	s ptbcts=ObjInDiv.INPAYptbcts
	s sUserDr=ObjInDiv.INPAYsUserDr
	s sfrq00=ObjInDiv.INPAYsfrq00
	s sfrm0=ObjInDiv.INPAYsfrxm0
	s sfsj00=ObjInDiv.INPAYsfsj00
	s sftsbz=ObjInDiv.INPAYsftsbz
	s bie00=ObjInDiv.INPAYxbie00
	s ming0=ObjInDiv.INPAYxming0
	s zhzfe0=ObjInDiv.INPAYzhzfe0
	s zyksmc=ObjInDiv.INPAYzyksmc
	s zylsh0=ObjInDiv.INPAYzylsh0
	s InsuPay1=ObjInDiv.INPAYInsuPay1
	s InsuPay2=ObjInDiv.INPAYInsuPay2
	s InsuPay3=ObjInDiv.INPAYInsuPay3
	s InsuPay4=ObjInDiv.INPAYInsuPay4
	s InsuPay5=ObjInDiv.INPAYInsuPay5
	s Zstr01=ObjInDiv.INPAYZstr01
	s Zstr02=ObjInDiv.INPAYZstr02
	s Zstr03=ObjInDiv.INPAYZstr03
	s Zstr04=ObjInDiv.INPAYZstr04
	s Zstr05=ObjInDiv.INPAYZstr05
	s Zstr06=ObjInDiv.INPAYZstr06
	s Zstr07=ObjInDiv.INPAYZstr07
	s Zstr08=ObjInDiv.INPAYZstr08
	s Zstr09=ObjInDiv.INPAYZstr09
	s Zstr10=ObjInDiv.INPAYZstr10
	s InsuPay6=ObjInDiv.INPAYInsuPay6
	s InsuPay7=ObjInDiv.INPAYInsuPay7
	s InsuPay8=ObjInDiv.INPAYInsuPay8
	s InsuPay9=ObjInDiv.INPAYInsuPay9
	s InsuPay10=ObjInDiv.INPAYInsuPay10
	s Zstr11=ObjInDiv.INPAYZstr11
	s Zstr12=ObjInDiv.INPAYZstr12
	s Zstr13=ObjInDiv.INPAYZstr13
	s Zstr14=ObjInDiv.INPAYZstr14
	s Zstr15=ObjInDiv.INPAYZstr15
	s Zstr16=ObjInDiv.INPAYZstr16
	s Zstr17=ObjInDiv.INPAYZstr17
	s Zstr18=ObjInDiv.INPAYZstr18
	s GwyBZ=$p(Zstr18,"|",3)
	i GwyBZ="1" d
	.s GwyBZ="是"
	e  d
	.s GwyBZ="否"
	s Zstr19=ObjInDiv.INPAYZstr19
	s Zstr20=ObjInDiv.INPAYZstr20
	s Zstr21=ObjInDiv.INPAYZstr21
	s Zstr22=ObjInDiv.INPAYZstr22
	s Zstr23=ObjInDiv.INPAYZstr23
	s Zstr24=ObjInDiv.INPAYZstr24
	s Zstr25=ObjInDiv.INPAYZstr25
	s Zstr26=ObjInDiv.INPAYZstr26
	s Zstr27=ObjInDiv.INPAYZstr27
	s Zstr28=ObjInDiv.INPAYZstr28
	s Zstr29=ObjInDiv.INPAYZstr29
	s Zstr30=ObjInDiv.INPAYZstr30
	s:zyksmc["-" zyksmc=$p(zyksmc,"-",2)
	do ObjInDiv.%Close()
 	
	 	s tmpjob=..GetinsuCateFeeExt(tInDivDr,DhcInvPrtDr,DHCpblDr,"",States)
	 	s (ZlFee,JCFee,SsFee,GhFee,HlFee,CwFee,ZCFee,HyFee,SxFee,ClFee,ZCaoYFee,ZCheFee,XyFee,YBZLFee,QTFee)=0
		s (ZlFee1,JCFee1,SsFee1,GhFee1,HlFee1,CwFee1,ZCFee1,HyFee1,SxFee1,ClFee1,ZCaoYFee1,ZCheFee1,XyFee1,YBZLFee1,QTFee1)=0
		s (ZlFee2,JCFee2,SsFee2,GhFee2,HlFee2,CwFee2,ZCFee2,HyFee2,SxFee2,ClFee2,ZCaoYFee2,ZCheFee2,XyFee2,YBZLFee2,QTFee2)=0
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"01")) CwFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"01"))			//床位费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"02")) ZCFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"02"))	//诊察费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"03")) JCFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"03"))	//检查费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"04")) HyFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"04"))	//化验费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"05")) ZlFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"05"))	//治疗费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"06")) SsFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"06"))	//手术费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"07")) HlFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"07"))	//护理费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"08")) ClFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"08"))	//卫生材料费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"09")) XyFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"09"))	//西药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"10")) ZCaoYFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"10"))	//中草药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"11")) ZCheFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"11"))	//中成药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"12")) YBZLFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"12"))	//一般诊疗费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"13")) GhFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"13"))	//挂号费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"14")) QTFee=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"14"))	//其他费
	
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"01","ZF")) CwFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"01","ZF"))			//床位费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"02","ZF")) ZCFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"02","ZF"))	//诊察费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"03","ZF")) JCFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"03","ZF"))	//检查费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"04","ZF")) HyFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"04","ZF"))	//化验费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"05","ZF")) ZlFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"05","ZF"))	//治疗费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"06","ZF")) SsFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"06","ZF"))	//手术费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"07","ZF")) HlFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"07","ZF"))	//护理费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"08","ZF")) ClFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"08","ZF"))	//卫生材料费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"09","ZF")) XyFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"09","ZF"))	//西药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"10","ZF")) ZCaoYFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"10","ZF"))	//中草药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"11","ZF")) ZCheFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"11","ZF"))	//中成药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"12","ZF")) YBZLFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"12","ZF"))	//一般诊疗费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"14","ZF")) QTFee1=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"14","ZF"))	//其他费
	
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"01","BFZF")) CwFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"01","BFZF"))			//床位费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"02","BFZF")) ZCFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"02","BFZF"))	//诊察费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"03","BFZF")) JCFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"03","BFZF"))	//检查费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"04","BFZF")) HyFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"04","BFZF"))	//化验费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"05","BFZF")) ZlFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"05","BFZF"))	//治疗费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"06","BFZF")) SsFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"06","BFZF"))	//手术费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"07","BFZF")) HlFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"07","BFZF"))	//护理费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"08","BFZF")) ClFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"08","BFZF"))	//卫生材料费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"09","BFZF")) XyFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"09","BFZF"))	//西药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"10","BFZF")) ZCaoYFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"10","BFZF"))	//药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"11","BFZF")) ZCheFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"11","BFZF"))	//中成药费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"12","BFZF")) YBZLFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"12","BFZF"))	//一般诊疗费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"13","BFZF")) GhFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"13","BFZF"))	//挂号费
		s:$d(^TMP("INSUBILL","InsuCateFee",tmpjob,"14","BFZF")) QTFee2=+(^TMP("INSUBILL","InsuCateFee",tmpjob,"14","BFZF"))	//其他费
	
 q 
 
BuidInAdmNew 	
 s (AAdmDr,InsuId,CardNo,PatType,CardStatus,Company,States,Center,Account,AdmSeriNo,ActiveFlag,AdmDate,AdmTime,AdmType,DeptDesc,InsuUser,IpTimes,InsuType,AdmCancelNo,OutDate,OutTime,OutUser,UserDr,FunDate,FunTime,XString1,XString2,XString3,XString4,XFloat1,XFloat2,XFloat3,XFloat4,XString5,XString6,XString7,XString8,XString9,XString10,XString11,XString12,XString13,XString14,XString15,XString16,XString17,XString18,XString19,XString20,InsuAdmInfoDr,psnidet,psnidetdesc,yljzbz)=""

 s ObjInAdm=##class(User.INSUAdmInfo).%OpenId(AdmInfoDr)	
 if (ObjInAdm)
 {
	 
	 s AAdmDr=ObjInAdm.INADMAdmDrGetObjectId()
	 s InsuId=ObjInAdm.INADMInsuId
	 s ACardNo=ObjInAdm.INADMCardNo
	 s PatType=ObjInAdm.INADMPatType
	 s CardStatus=ObjInAdm.INADMCardStatus
	 s Company=ObjInAdm.INADMCompany
	 s States=ObjInAdm.INADMStates
	 s Center=ObjInAdm.INADMCenter
	 s Account=ObjInAdm.INADMAccount
	 s AdmSeriNo=ObjInAdm.INADMAdmSeriNo
	 s ActiveFlag=ObjInAdm.INADMActiveFlag
	 s AdmDate=ObjInAdm.INADMAdmDate
	 s:AdmDate'="" AdmDate=$zd(AdmDate,3)
	 s AdmTime=ObjInAdm.INADMAdmTime
	 s:AdmTime'="" AdmTime=$zt(AdmTime)
	 s AdmType=ObjInAdm.INADMAdmType
	 s DeptDesc=ObjInAdm.INADMDeptDesc
	 s InsuUser=ObjInAdm.INADMInsuUser
	 s IpTimes=ObjInAdm.INADMIpTimes
	 s InsuType=ObjInAdm.INADMInsuType
	 s AdmCancelNo=ObjInAdm.INADMAdmCancelNo
	 s OutDate=ObjInAdm.INADMOutDate
	 s OutTime=ObjInAdm.INADMOutTime
	 s OutUser=ObjInAdm.INADMOutUser
	 s UserDr=ObjInAdm.INADMUserDrGetObjectId()
	 s FunDate=ObjInAdm.INADMFunDate
	 s:FunDate'="" FunDate=$zd(FunDate,3)
	 s FunTime=ObjInAdm.INADMFunTime
	 s:FunTime'="" FunTime=$zt(FunTime)
	 s XString1=ObjInAdm.INADMXString1
	 s XString2=ObjInAdm.INADMXString2
	 s XString3=ObjInAdm.INADMXString3
	 s XString4=ObjInAdm.INADMXString4
	 s XFloat1=ObjInAdm.INADMXFloat1
	 s XFloat2=ObjInAdm.INADMXFloat2
	 s XFloat3=ObjInAdm.INADMXFloat3
	 s XFloat4=ObjInAdm.INADMXFloat4
	 s XString5=ObjInAdm.INADMXString5
	 s XString6=ObjInAdm.INADMXString6
	 i Company=$p(XString6,"|",1) s Company=""
	 
	 s XString7=ObjInAdm.INADMXString7
	 s XString8=ObjInAdm.INADMXString8
	 s XString9=ObjInAdm.INADMXString9
	 s XString10=ObjInAdm.INADMXString10
	 s XString11=ObjInAdm.INADMXString11
	 s XString12=ObjInAdm.INADMXString12
	 s XString13=ObjInAdm.INADMXString13
	 s XString14=ObjInAdm.INADMXString14
	 s XString15=ObjInAdm.INADMXString15
	 s XString16=ObjInAdm.INADMXString16
	 s XString17=ObjInAdm.INADMXString17
	 s XString18=ObjInAdm.INADMXString18
	 s XString19=ObjInAdm.INADMXString19
	 s XString20=ObjInAdm.INADMXString20
	 s:DeptDesc["-" DeptDesc=$p(DeptDesc,"-",2)
	 s InsuAdmInfoDr=ObjInAdm.INADMInsuAdmInfoDrGetObjectId()
	 do ObjInAdm.%Close()
	 ;st-数据字典描述
	 s tHospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AAdmDr)
	 s tmpInsuPatTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("psn_type"_InsuType,PatType,4,tHospDr)	;tHospDr
	 s tmpInsuAdmTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("med_type"_InsuType,AdmType,4,tHospDr)

	 s:tmpInsuPatTypeDesc'="" PatType=tmpInsuPatTypeDesc
	 s:tmpInsuAdmTypeDesc'="" AdmType=tmpInsuAdmTypeDesc
		 
	 s tmpXString7=##class(web.INSUDicDataCom).GetDicByCodeAndInd("insutype"_InsuType,XString7,4,tHospDr)
	 s:(tmpXString7'="") XString7=tmpXString7
     
     s tmpXString5=$e(XString5,1,6)_"********"_$e(XString5,15,18)
	 s:(tmpXString5'="") XString5=tmpXString5
     
     s yljzbz=0
     s psnidet=$p(XString20,"#",9)
     s:psnidet'="" psnidet=$p(psnidet,"|",1)
     s:psnidet'="" psnidetdesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("psn_idet_type"_InsuType,psnidet,4,tHospDr)
     s:(psnidet="3487")||(psnidet="2303")||(psnidet="2304")||(psnidet="3407")||(psnidet="3402")||(psnidet="3405")||(psnidet="3404") yljzbz=1
     b ;psnidet
	 /* 
	 i States["4402"  d
	 .s tmpStateDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("YAB003"_InsuType,States,4)
	 e             d
	 .s tmpStateDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AreaSGD",States,4)
	 s:tmpStateDesc'="" States=tmpStateDesc
	 */
	 /*s tmpCenterDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("YAB003"_InsuType,Center,4)
	 i tmpCenterDesc="" d
	 .s tmpCenterDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("insuplc_admdvs"_InsuType,Center,4)
	 s:tmpCenterDesc'="" Center=tmpCenterDesc
	 */
	 s tmpCenterDesc=..GetCenterDesc(Center,InsuType,tHospDr) //DingSH 20211103
	 s:tmpCenterDesc'="" Center=tmpCenterDesc
	 ;注意,医保类型要放到最后编程描述
	 s tmpInsuTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DLLType",InsuType,4,tHospDr)
	 s:tmpInsuTypeDesc'="" InsuType=tmpInsuTypeDesc
	 ;ed-数据字典描述
	 
	 s Grsflb=$p(XString20,"@",5)
 }
 else{
	 q $$$OK
	 }
 
 q	
 
BuildJSDNew	
    
	Set data = $lb(ind,AAdmDr,InsuId,ACardNo,PatType,CardStatus,Company,States,Center,Account,AdmSeriNo,ActiveFlag,AdmDate,AdmTime,AdmType,DeptDesc,InsuUser,IpTimes,InsuType,AdmCancelNo,OutDate,OutTime,OutUser,UserDr,FunDate,FunTime,XString1,XString2,XString3,XString4,XFloat1,XFloat2,XFloat3,XFloat4,XString5,XString6,XString7,XString8,XString9,XString10,XString11,XString12,XString13,XString14,XString15,XString16,XString17,XString18,XString19,XString20,InsuAdmInfoDr,DAdmDr,AdmInfoDr,DHCpblDr,DhcInvPrtDr,Flag,INSUDivideDr,bcbxf0,djlsh0,bckbcs,bqbm00,brnl00,cardno,cfms0,crbcts,grzfe0,iDate,iTime,id0000,jjzfe0,ptbcts,sUserDr,sfrq00,sfrm0,sfsj00,sftsbz,bie00,ming0,zhzfe0,zyksmc,zylsh0,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,Zstr01,Zstr02,Zstr03,Zstr04,Zstr05,Zstr06,Zstr07,Zstr08,Zstr09,Zstr10,InsuPay6,InsuPay7,InsuPay8,InsuPay9,InsuPay10,Zstr11,Zstr12,Zstr13,Zstr14,Zstr15,Zstr16,Zstr17,Zstr18,Zstr19,Zstr20,Zstr21,Zstr22,Zstr23,Zstr24,Zstr25,Zstr26,Zstr27,Zstr28,Zstr29,Zstr30,PAPMINo,PAPMIName,PAPMISex,PAPMIAge,IPDays,DiagCBDiagCode,DiagCBDiagDesc,DiagRYDiagCode,DiagRYDiagDesc,DiagMZDiagCode,DiagMZDiagDesc,DiagCYDiagCode,DiagCYDiagDesc,ZlFee,JCFee,SsFee,GhFee,HlFee,CwFee,ZCFee,HyFee,SxFee,ClFee,ZCaoYFee,ZCheFee,XyFee,YBZLFee,QTFee,PAPMIDob,Tel,BedID,Medicare,ZlFee1,JCFee1,SsFee1,GhFee1,HlFee1,CwFee1,ZCFee1,HyFee1,SxFee1,ClFee1,ZCaoYFee1,ZCheFee1,XyFee1,YBZLFee1,QTFee1,ZlFee2,JCFee2,SsFee2,GhFee2,HlFee2,CwFee2,ZCFee2,HyFee2,SxFee2,ClFee2,ZCaoYFee2,ZCheFee2,XyFee2,YBZLFee2,QTFee2,GwyBZ,Grsflb,InsuHospCode,InsuHospDesc,yljzbz)
 	Set ^CacheTemp(repid,ind) = data
 	Set ind = ind +1
 	q
}

ClassMethod QueryInsuJSDNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInsuJSDNewExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
