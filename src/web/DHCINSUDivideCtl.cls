Import SQLUser

/// 医保结算信息操作类
Class web.DHCINSUDivideCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 251;

/// 保存医保结算返回信息
ClassMethod InsertDivInfo(InString As %String) As %String
{
	n (InString)
	q:InString="" -100
    s DivId=+$p(InString,"^",1)
    i DivId=0 d
    .s InsertDivInfo=$$InsertDivide^DHCINSUDivide(InString)
    e  d
    .i $d(^DHCINDIV(DivId))=0 d
    ..s InsertDivInfo=$$InsertDivide^DHCINSUDivide(InString)
    .e  d
    ..s InsertDivInfo=$$UpdateDivide^DHCINSUDivide(InString)
    q InsertDivInfo
	/*
	/
	
 //医保结算返回信息
 
 /// 保存医保结算返回信息

	s obj=##class(User.INSUDivide).%New()
	s obj.AdmDr=$p(InString,"^",2)                    ///指向PAADM的指针User.PAAdm
	s obj.AdmInfoDr=$p(InString,"^",3)                    ///指针User.INSUAdmInfo
	s obj.DHCpblDr=$p(InString,"^",4)                    ///指向DHC_PatientBill的指针
	s obj.DhcInvPrtDr=$p(InString,"^",5)                    ///Dhc_InvPrt的指针
	s obj.Flag=$p(InString,"^",6)                    ///结算状态（insuhispaidstrike）
	s obj.INSUDivideDr=$p(InString,"^",7)                    ///被冲销的指针
	s obj.bcbxf0=+$p(InString,"^",8)                    ///总费用
	s obj.djlsh0=$p(InString,"^",9)                    ///单据流水号
	s obj.bckbcs=+$p(InString,"^",10)                    ///本次看病次数(即视同住院次数)
	s obj.bqbm00=$p(InString,"^",11)                    ///病种编码
	s obj.brnl00=+$p(InString,"^",12)                    ///年龄
	s obj.cardno=$p(InString,"^",13)                    ///卡号
	s obj.cfxms0=+$p(InString,"^",14)                    ///收费项目数
	s obj.crbcts=+$p(InString,"^",15)                    ///传染病床天数
	s obj.grzfe0=+$p(InString,"^",16)                    ///个人现金支付额
	s obj.iDate=$p($h,",",1)                    ///操作日期
	s obj.iTime=$p($h,",",2)                    ///操作时间
	s obj.id0000=$p(InString,"^",19)                    ///医保号
	s obj.jjzfe0=+$p(InString,"^",20)                    ///基金支付额
	s obj.ptbcts=+$p(InString,"^",21)                    ///普通病床天数
	s obj.sUserDr=$p(InString,"^",22)                    ///操作员User.SSUser
	s obj.sfrq00=$p(InString,"^",23)                    ///收费日期
	s obj.sfrxm0=$p(InString,"^",24)                    ///收费人姓名
	s obj.sfsj00=$p(InString,"^",25)                    ///收费时间
	s obj.sftsbz=$p(InString,"^",26)                    ///是否特殊病种
	s obj.xbie00=$p(InString,"^",27)                    ///性别
	s obj.xming0=$p(InString,"^",28)                    ///姓名
	s obj.zhzfe0=+$p(InString,"^",29)                    ///帐户支付额
	s obj.zyksmc=$p(InString,"^",30)                    ///住院科室名称
	s obj.zylsh0=$p(InString,"^",31)                    ///入院登记流水号
	s obj.InsuPay1=$p(InString,"^",32)                    ///医保支付方式
	s obj.InsuPay2=$p(InString,"^",33)                    ///医保支付方式
	s obj.InsuPay3=$p(InString,"^",34)                    ///医保支付方式
	s obj.InsuPay4=$p(InString,"^",35)                    ///医保支付方式
	s obj.InsuPay5=$p(InString,"^",36)                    ///医保支付方式
	d obj.%Save()
    s id=$p(obj.%Id(),$c(1))
    d obj.%Close()
    s InsertDivInfo=id
    q InsertDivInfo
    */
}

ClassMethod GetByBill(BillRowid As %String) As %String
{
	n (BillRowid)
	q:BillRowid="" -1
	q:$d(^DHCINDIV("0","DHCPB",BillRowid))=0 -100
	s Id=$O(^DHCINDIV("0","DHCPB",BillRowid,""),-1)
	s DivStr=..GetDivById(Id)
	s GetByBill="1!"_DivStr
	q GetByBill
}

ClassMethod GetByInvprt(Invprt As %String) As %String
{
	n (Invprt)
	q:Invprt="" -1
	q:$d(^DHCINDIV("0","DHCInvPrt",Invprt))=0 -100
	s Id=$O(^DHCINDIV("0","DHCInvPrt",Invprt,""),-1)
	s DivStr=..GetDivById(Id)
	s GetByInvprt="1!"_DivStr
	q GetByInvprt
}

ClassMethod GetDivById(Id As %String) As %String
{
	s GetDivById=$$GetDivideInfo^DHCINSUDivide(Id)
	q GetDivById
}

ClassMethod Delete(InpayDr As %String) As %String
{
	n (InpayDr)
	q:(+InpayDr<1) "-1"
	&sql(delete from  INSU_Divide  where INPAY_Rowid=:InpayDr) 
	q SQLCODE
}

/// Creator：      刘书凤
/// CreatDate：    2010 06 18
/// Description:   退费，退费时往Insu_divide表插一条新记录
/// Table：        
/// Input：        
/// Output：       
/// Return：       成功返回 0
/// Others：
/// w ##class(web.DHCINSUDivideCtl).StrikeDivide("") 
ClassMethod StrikeDivide(Instring As %String) As %String
{
	s StrikeInsuDiv=$$StrikeDivide^DHCINSUDivide(Instring)
    q StrikeInsuDiv
}

///   Creator：      zhangdongliang
///   CreatDate：    2011 05 12
///   Description:   查找发票表没有更新的数据
///   Table：        
///   Input：        	StartDate:开始日期
/// 						EndDate:结束日期 如果空的话默认当天日期
/// 						
///   Output：       		DhcInvPrtDr_"^"_PrtAcount_"^"_Prtdate_"^"_Prttime_"^"_grzfe_"^"_zhzfe_"^"_tc_"^"_gwy_"^"_db_"^"_yljg,!
/// 						发票表rowid	^ 发票总金额   ^ 打印发票日期 ^ 打印发票时间^ 现金 ^ 账户   ^ 统筹 ^公务员补助^大病^医疗机构负担
/// 							临时global赋值
/// 						Rtn^医保结算表rowid^现金支付^发票表rowid_$c(2)_支付模式表PayMode_DR^账户支付_$c(2)_ PayMode_DR ^统筹支付_$c(2)_ PayMode_DR ^公务员补助_$c(2)_ PayMode_DR ^大病统筹_$c(2)_ PayMode_DR ^医疗机构负担  _$c(3)发票2
///   Return：       成功返回 0
///   Others：
///   w ##class(web.DHCINSUDivideCtl).ComparisonDivide("2011-01-01","2011-02-01")
ClassMethod ComparisonDivide(StartDate As %String, EndDate As %String) As %String
{
	k ^returnStr
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	
	s iDate=StartDate-1
	f  s iDate=$o(^DHCINDIV("0","IDate",iDate)) q:(iDate="")!(iDate>EndDate)  d
	.s DivDr=""
	.f  s DivDr=$o(^DHCINDIV("0","IDate",iDate,DivDr)) q:DivDr=""  d
	..s (DivInfo,DhcInvPrtDr,Flag,DHCINVPRTInfo,PrtAcount,Prtdate,Prttime,grzfe,zhzfe,tc,gwy,db,yljg)=""
	..s DivInfo=$g(^DHCINDIV(DivDr))
	..s DhcInvPrtDr=$p(DivInfo,"^",4)
	..q:(DhcInvPrtDr="")
	..s Flag=$p(DivInfo,"^",5)
	..q:Flag'="I"
	
	..s grzfe=+$p(DivInfo,"^",15)				;现金
	..s bcbxf0=+$p(DivInfo,"^",7)				;总费用
	..s zhzfe=+$p(DivInfo,"^",28)				;本次帐户支付金额
	..s tc=+$p(DivInfo,"^",31)					;统筹
	..s db=+$p(DivInfo,"^",32)					;本次大病统筹支付金额
	..s gwy=+$p(DivInfo,"^",33)					;本次公务员补助支出金额
	..s yljg=+$p(DivInfo,"^",35)				;医疗机构负担
	..s cezd=+$p(DivInfo,"^",50)					;医保支付10（误差）
	
	..s DHCINVPRTInfo=$g(^DHCINVPRT(DhcInvPrtDr))
	..q:DhcInvPrtDr=""
	..s PRTInsDivDR=$p(DHCINVPRTInfo,"^",30)
	..q:DHCINVPRTInfo=""
	..i PRTInsDivDR=""  d
	...s PrtAcount=$p(DHCINVPRTInfo,"^",1)
	...s Prtdate=$p(DHCINVPRTInfo,"^",5)
	...s:Prtdate'="" Prtdate=$zd(Prtdate,3)
	...s Prttime=$p(DHCINVPRTInfo,"^",20)
	...s:Prttime'="" Prttime=$zt(Prttime,1)
	...w DhcInvPrtDr_"^"_PrtAcount_"^"_Prtdate_"^"_Prttime_"^"_grzfe_"^"_zhzfe_"^"_tc_"^"_gwy_"^"_db_"^"_yljg,!
	...s Rtn="0"
	...;Rtn^DHC_InsuDivideRowID^现金支付^DHCINVRowID_$c(2)_PayMode_DR^账户支付_$c(2)_ PayMode_DR ^统筹支付_$c(2)_ PayMode_DR ^公务员补助_$c(2)_ PayMode_DR ^大病统筹_$c(2)_ PayMode_DR ^医疗机构负担  _$c(3)发票2
	...;y因为分隔符号$c(2)，$c(3)在w时是现实不出来的，所以给计费组的返回值拼串放在临时global中，计费要测试时从global取值即可
	...s ^returnStr(DhcInvPrtDr)= Rtn_"^"_DivDr_"^"_grzfe_"^"_DhcInvPrtDr_$c(2)_"13"_"^"_zhzfe_$c(2)_"14"_"^"_tc_$c(2)_"15"_"^"_gwy_$c(2)_"16"_"^"_db_$c(2)_"17"_"^"_yljg_$c(3)
	
	q 0
}

/// Creator：      刘书凤
/// CreatDate：    2010 06 18
/// Description:   退费，退费时往Insu_divide表插一条新记录
/// Table：        
/// Input：        
/// Output：       
/// Return：       成功返回 0
/// Others：
/// w ##class(web.DHCINSUDivideCtl).JudDivStrik("1118") 
ClassMethod JudDivStrik(InsuDivDr As %String) As %String
{
	s JudDivStrik="-1"
	n (InsuDivDr)
	s InsuInfo=""
	s InsuInfo=$$GetDivideInfo^DHCINSUDivide(InsuDivDr)
	s INPAYZstr01=$p(InsuInfo,"^",37)
	s INPAYiDate=$p(InsuInfo,"^",17)
	s INPAYiDate=$zdh(INPAYiDate,3)
	s JudDivStrik=+$H-INPAYiDate
	q JudDivStrik
}

ClassMethod GetOldInvInfoByInvPrtDr(InvPrtDr As %String) As %String
{
	s OutStr="-1"
	q:InvPrtDr="" OutStr
	s InvPrtInfo=$g(^DHCINVPRT(InvPrtDr))
	s PRTOldINVDR=$P(InvPrtInfo,"^",29)
	q:PRTOldINVDR="" OutStr
	s PRTOldINVInfo=$g(^DHCINVPRT(PRTOldINVDR))
	s PRTInsDivDr=$P(PRTOldINVInfo,"^",30)
	q:PRTInsDivDr="" "0"
	q:PRTInsDivDr<0 OutStr
    q PRTInsDivDr
}

/// Creator：      张东亮
/// CreatDate：    2015-10-21
/// Description:   根据InadmInfoDr取医保结算信息，暂定只取最后一条有效数据。
/// Table：        
/// Input：        Type: R 挂号费用信息  F 收费费用信息
/// Output：       
/// Return：       成功返回 INSU_DIVIDE表信息
/// Others：
/// w ##class(web.DHCINSUDivideCtl).GetDivByAdmInfoDr("12","R") 
ClassMethod GetDivByAdmInfoDr(InadmInfoDr As %String, Type As %String) As %String
{
	n (InadmInfoDr,Type)
	s OutStr="-1"
	q:(InadmInfoDr="")||(Type="") OutStr
	q:(Type'="R")&&(Type'="F") OutStr
	
	q:$d(^DHCINDIV("0","ADMINFO",InadmInfoDr))=0 OutStr
	s DivDr=""
	f  s DivDr=$O(^DHCINDIV("0","ADMINFO",InadmInfoDr,DivDr)) q:(DivDr="")  d
	.s DivStr=..GetDivById(DivDr)
	.s INPAYZstr01=$p(DivStr,"^",37)
	.q:(INPAYZstr01'=Type)
	.s OutStr=DivStr
	q OutStr
}

/// Creator：      DingSH
/// CreatDate：    2019-12-10
/// Description:   根据医保结算表ID取校验医保结算表和发票表(账单表)个人自付情况是否一致。
/// Table：        
/// Input：        InDivId:Insu_Divide.Rowid
/// Output：       
/// Return：       成功返回 "Y(N)^发票(账单)自付金额^医保结算表金额^误差" 或 失败 "-1"
/// Others：
/// w ##class(web.DHCINSUDivideCtl).CheckGrzf(2) 
ClassMethod CheckGrzf(InDivId) As %String
{
	n (InDivId)
	q:$g(InDivId)="" "-1"
	s Flag="Y" ,PrtGrzf=0,InGrzf=0
	q:'$d(^DHCINDIV(InDivId)) "-1"
	
	s JSLY=$P($G(^DHCINDIV(InDivId)),"^",38)  //结算来源   01现金结算模式 02集中打印模式 10本地算法 20自助机
	s JSFS=$P($G(^DHCINDIV(InDivId)),"^",36)    //结算方式   R（挂号） F（收费） ,P(体检)
	s InGrzf=$P($G(^DHCINDIV(InDivId)),"^",15)
	s InsuPay10=$P($G(^DHCINDIV(InDivId)),"^",50)  // 误差
	s PrtDrStr=$P($G(^DHCINDIV(InDivId)),"^",4)
	s BillNo=$P($G(^DHCINDIV(InDivId)),"^",3)
	s HospDr = $P($G(^DHCINDIV(InDivId)),"^",71)   //8.4 以后
	;门诊取值情况
	s AccFlag="N" //+DingSH 20220110 增加集中打印校验
	s PrtFlag="",PrtInsuDivDr=""
	if PrtDrStr'="" d
	.s PrtDr=""
	.s Cnt=$l(PrtDrStr,"!") 
	.f i=1:1:Cnt  q:AccFlag="Y"  d
	..s PrtDr=$P(PrtDrStr,"!",i) 
	..q:PrtDr=""
	..s AccInvDr=$P($G(^DHCINVPRT(PrtDr)),"^",4)
	..i +AccInvDr>0 d
	...s PrtGrzf=$P($G(^DHCINVPRTAP(AccInvDr)),"^",13)
	...s AccFlag="Y"
	..e  d
	...i JSFS="P" d
	....s PrtGrzf=PrtGrzf+##class(web.DHCPE.CRM.Gateway).GetOwnPayAmt(PrtDr) //20220905 
	....;s PrtFlag=$P($G(^DHCPEINVPRT(PrtDr)),"^",8)
	...e  d
	....s PrtGrzf=PrtGrzf+($P($G(^DHCINVPRT(PrtDr)),"^",16)-$P($G(^DHCINVPRT(PrtDr)),"^",31))
	....s PrtFlag=$P($G(^DHCINVPRT(PrtDr)),"^",8)
	....s PrtInsuDivDr=$P($G(^DHCINVPRT(PrtDr)),"^",30)
	;住院取值情况 
	if BillNo'="" d 
	.s PrtGrzf=$P($G(^DHCPB(BillNo)),"^",12)
	.//s InGrzf=$P($G(^DHCINDIV(InDivId)),"^",7) 
	
	s InsuType=""
	s InAdmId=$P($G(^DHCINDIV(InDivId)),"^",2)
	i InAdmId'="" d
	.s InsuType=$P($G(^DHCINADM(InAdmId)),"^",18)

	s MisTake=##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty"_InsuType,"Mistake",4,HospDr)
	i +MisTake=0 d
	.s MisTake=0.01
	
	i $ZABS(InGrzf+InsuPay10-PrtGrzf)>MisTake d
	.s Flag="N"
	//处理门诊异常处理异常退费情况
	i ((PrtFlag="TP") && (+PrtInsuDivDr=0)) d
	.s Flag="Y"

	q Flag_"^"_PrtGrzf_"^"_InGrzf_"^"_InsuPay10
}

/// Creator：      HanZH
/// CreatDate：    2022-08-01
/// Description:   根据医保结算事件ID取医保结算数据
/// Table：        
/// Input：        SeltId:Insu_Divide.INPAY_djlsh0
/// Output：       
/// Return：       成功返回 "1！结算信息数据" 或 失败 "-1/-100"
/// Others：
/// w ##class(web.DHCINSUDivideCtl).GetDivBySeltId(9300001032010)
ClassMethod GetDivBySeltId(SeltId As %String) As %String
{
	n (SeltId)
	q:SeltId="" -1
	q:$d(^DHCINDIV("0","Djlsh0",SeltId))=0 -100
	s Id=$O(^DHCINDIV("0","Djlsh0",SeltId,""),-1)
	s DivStr=..GetDivById(Id)
	s GetDivBySeltId="1!"_DivStr
	q GetDivBySeltId
}

/// Creator：      HanZH
/// CreatDate：    2022-11-03
/// Description:   根据医保结算ID取发票指针
/// Table：        
/// Input：        DivRowid：医保结算ID
/// Output：       
/// Return：       成功返回 "发票指针" 或 失败 "-1/-100"
/// Others：
/// w ##class(web.DHCINSUDivideCtl).GetInvprtByDivRowid("1304829") 
ClassMethod GetInvprtByDivRowid(DivRowid As %String) As %String
{
	n (DivRowid)
	q:DivRowid="" -1
	q:$d(^DHCINDIV(DivRowid))=0 -100
	s Invprt=$p($g(^DHCINDIV(DivRowid)),"^","4")
	
	q Invprt
}

/// Creator：      DingSH
/// CreatDate：    2023-03-14
/// Description:   根据医保结算Rowid判断医保结算数据是否可冲正
/// 可冲正规则：   （1）医保结算表DivFlag=D
///                （2）DivFlag=I且AdmDr="" 且(当前时间-结算时间)超过60秒 (门诊医保挂号异常情况)
///                （3）DivFlag=I且发票Rowid在门诊发票表和体检发票表不存在的。                
///                （4）DivFlag=I且发票Rowid在门诊发票表和体检发票表存在但是PrtFlag=TP 且(当前时间-结算时间)超过60秒。  
///                （5）DivFlag=I且账单Id在账单表不存在
/// Table: INSU_Divide,INSU.MI.BL.RevsTrnsLog
/// Input：        DivDr:Insu_Divide.INPAY_Rowid
/// Output：        
/// Return：       1^冲正交易表指针或Y^医保类型" ; 0^  或 -99^异常错误信息
/// Others：
/// w ##class(web.DHCINSUDivideCtl).CheckIsRevsByDivDr()
ClassMethod CheckIsRevsByDivDr(DivDr As %String) As %String
{
	n (DivDr)
	s $zt="CheckIsRevsByDivDrEx"
	s IsRevs="0" ,RevsTrnsLogDr="",tInsuType=""
	q:DivDr="" IsRevs
	q:$d(^DHCINDIV(DivDr))=0 IsRevs
    s HospId = $p(^DHCINDIV(DivDr),"^",71)
    s TrnsLogDr=""
	s DivFlag=$P(^DHCINDIV(DivDr),"^",5)
    i DivFlag="D"{
	   s IsRevs="1"
	}
    i DivFlag="I" {
		 s FJMod=$P(^DHCINDIV(DivDr),"^",36)   //分解模式 P:体检，R:挂号，F:收费
		 s DivMod=$P(^DHCINDIV(DivDr),"^",38)  //结算模式 01 现金模式，02：集中打印，10：本地算法,20:自助机 30：微信，31：支付宝
		 s tAdmDr = $P(^DHCINDIV(DivDr),"^",1)
		 s tPrtDr = $P(^DHCINDIV(DivDr),"^",4)
		 s tBillDr = $P(^DHCINDIV(DivDr),"^",3)
		 s tiDate = $P(^DHCINDIV(DivDr),"^",16)
		 s tiTime = $P(^DHCINDIV(DivDr),"^",17)
		 s tInadmDr = $P(^DHCINDIV(DivDr),"^",2)
		 s tInsuType=$P(^DHCINADM(tInadmDr),"^",18)
		 s diffDays=0,diffTimes =0
		 s diffDays = +$H-tiDate
		 s diffTimes = $p($H,",",2)-tiTime
		 s diffFlag = 0  //时间差标志
		 // 当前日期-结算日期 
		 i +diffDays > 0{
			s diffFlag = 1
		 }
		 //当前时间-结算时间
		 i (+diffFlag = 0)&&(+diffTimes>60){
	        s diffFlag = 1
		 }
		 //门诊医保挂号
		 i (FJMod="R") && (tAdmDr="") &&(+diffFlag=1){
			 s IsRevs="1"
			 }
		 //门诊发票 且非集中打印
		  s tPrtFlag = "-1"   
		 i (FJMod ="F") && (+tPrtDr>0)&&(DivMod'="02") {
			s tPrtFlag = $P($g(^DHCINVPRT(+tPrtDr)),"^",8)
		 }
		 //体检发票
		  s tPrtFlag = "-1"
	      i (FJMod ="P") && (+tPrtDr>0) {
			s tPrtFlag=$P($g(^DHCPEINVPRT(+tPrtDr)),"^",8)
		 }
		 i (+diffFlag=1)&&((tPrtFlag="TP")||(tPrtFlag=""))
		 {
			  s IsRevs="1"
	     }
	     //住院账单号(重新生成账单情况)
	     i (+tBillDr>0)&&($d(^DHCPB(tBillDr))=0){
		      s IsRevs="1"  
		     }
     }
	s TrnsLogDr=$O(^INSU.MI.TrnsLogI("IdxInsuDivDr",HospId,DivDr,""),-1)
	i +TrnsLogDr> 0 {
	  s RevsTrnsLogDr=$O(^INSU.MI.BL.RevsTrnsLogI("IdxTrnsLogDr",HospId,TrnsLogDr,""),-1)
	}
    i +RevsTrnsLogDr>0
    {
	  s tIsRevs=$lg(^INSU.MI.BL.RevsTrnsLogD(RevsTrnsLogDr),5)
	   //更新冲正标识判断
      i (tIsRevs'=IsRevs){
       &sql(Update INSU_MI.RevsTrnsLog Set IsRevs=:IsRevs where Rowid=:RevsTrnsLogDr and RevsStas!="1")
      }
	}
	q IsRevs_"^"_RevsTrnsLogDr_"^"_tInsuType
CheckIsRevsByDivDrEx
 b ;CheckIsRevsByDivDrEx
 s $zt=""
 q "-99^调用CheckIsRevsByDivDr程序异常："_$ze
}

/// 更新divide表PayFlag状态 addby LuJH
/// 20230315
ClassMethod UpdateInPayFlagByInDivDr(InDivDr As %String, InPayFlag As %String) As %String
{
	n (InDivDr,InPayFlag)
	s $zt="UpdateInPayFlagByInDivDrEx"
	q:(+InDivDr<1) "-1^更新医保结算状态失败,医保结算指针不能为空"
	q:(InPayFlag)="" "-1^更新医保结算状态失败,医保结算状态不能为空"
	&sql(Update INSU_Divide set  INPAY_Flag=:InPayFlag  where INPAY_Rowid=:InDivDr) 
	q SQLCODE
UpdateInPayFlagByInDivDrEx
  b ;UpdateInPayFlagByInDivDrEx
  s $zt=""
  q "-99^;UpdateInPayFlagByInDivDrEx程序异常："_$ze
}

/// Creator：      DingSH
/// CreatDate：    2023-03-29
/// Description:   根据医保结算Rowid获取医保登记表Rowid
/// Table:         INSU_Divide,INSU_AdmInfo
/// Input：        InDivDr:Insu_Divide.INPAY_Rowid
/// Output：        
/// Return：    成功：  医保登记表.Rowid  ; 失败 小于0^错误信息或 -99^异常错误信息
/// Others： 使用场景：在就诊登记处登记(自费)，然后在收费界面用医保收费。 再去退号，这时候调用不到医保退费 。
/// w ##class(web.DHCINSUDivideCtl).GetInAdmDrByInDivDr(DivDr)
ClassMethod GetInAdmDrByInDivDr(InDivDr As %String) As %String
{
	n (InDivDr)
	s $zt="GetInAdmDrByInDivDrEx"
	s InAdmDr =""
	q:$g(InDivDr)="" "-1^医保结算表Rowid不能为空"
	q:+$d(^DHCINDIV(InDivDr))=0 "-1^未查询医保结算表Rowid="_InDivDr_"记录"
	s InAdmDr=$P(^DHCINDIV(InDivDr),"^",2)
    q InAdmDr
GetInAdmDrByInDivDrEx
    s $zt=""
	b ;GetInAdmDrByInDivDrEx
	q "-99^调用GetInAdmDrByInDivDr接口异常:"_$ze
}

/// 根据医嘱id判断是否为医保结算
/// 入参：  医嘱id
/// 出参： Y:医保,N:非医保
/// 使用场景：根据医嘱id来判断该医嘱是否为医保结算。入参门诊为医嘱id OEORIId、住院为医嘱执行表id OEOREId，出参为医保标志
/// +靳帅1010 20221209 upt 靳帅1010 20230404
/// 门诊-OE_Order-Pa_Adm-OE_OrdItem-DHC_PatientBill-DHC_BillConINV-DHC_INVPRT-INSU_Divide-判断：医保结算状态I为医保结算
/// 住院-OE_Order-Pa_Adm-OE_OrdExec-DHC_PatientBill-INSU_Divide-判断：医保结算状态I为医保结算
/// w ##class(web.DHCINSUDivideCtl).GetIsInsuPayByOEORDId("7||4","17||1||1") 
ClassMethod GetIsInsuPayByOEORDId(OEORIId As %String, OEOREId As %String) As %String
{
   s $zt="GetIsInsuPayByOEORDIdEx"
   n (OEORIId,OEOREId)
   q:(OEORIId="")&&(OEOREId="") "-1^医嘱ID和执行记录ID不能同时为空"
   s InsuFlag="N"     
   s OEOrdRowId=$P(OEORIId,"||",1)
   s:OEOrdRowId="" OEOrdRowId=$P(OEOREId,"||",1)
   s PaadmDr=$p($g(^OEORD(OEOrdRowId)),"^",1) //就诊Dr
   s PaadmInfo=$g(^PAADM(PaadmDr))
   s PaadmType=$p(PaadmInfo,"^",2)   //就诊类型
   b ;PaadmType
   //如果就诊类型不为"I"(住院)或"P"(预住院) 为门诊医嘱
   i (PaadmType'="I")&&(PaadmType'="P")
      {
          d OpGetIsInsuPay   //门诊医嘱查询该医嘱对应的医保结算状态
      }                
   else
      {                           
          d IPGetIsInsuPay   //住院医嘱查询医保结算状态
      }
   q InsuFlag
OpGetIsInsuPay
   s PatBillId=""
   s PatBillId=$o(^DHCPBi(0,"OEORI",OEORIId,PatBillId),-1)
   q:PatBillId="" 
   s PbInfo=$g(^DHCPB(PatBillId))
   s BillConINVId="" 
   s BillConINVId=$o(^DHCBCI(0,"Bill",PatBillId,BillConINVId),-1)
   q:BillConINVId=""  
   s BillConINVInfo=$g(^DHCBCI(BillConINVId))
   s DHCINVPRTDr=$p(BillConINVInfo,"^",1)  //发票表ID
   s DivideDr=""
   s DivideDr=$O(^DHCINDIV("0","DHCPB",DHCINVPRTDr,DivideDr),-1)
   //当根据索引，取到DivideDr为空时,不为医保结算，退出
   q:DivideDr=""
   s DivideInfo=$g(^DHCINDIV(DivideDr))
   s INPAYFlag=$p(DivideInfo,"^",5)    //医保结算状态
   //当医保结算状态未为"I"(正常)时，正常结算数据
   i (INPAYFlag="I")   
		{
        	s InsuFlag="Y" 
    	}          
   q
IPGetIsInsuPay
   s IpPatBillId=""
   s IpPatBillId=$o(^DHCPB(0,"OEEXC",OEOREId,IpPatBillId),-1) 
   q:IpPatBillId="" 
   s IpPbInfo=$g(^DHCPB(IpPatBillId))
   s IPPayedFlag=$p(IpPbInfo,"^",16)      //计费状态(Paid,Bill)
   //当账单计费状态为"P"时是已经结算账单
   i (IPPayedFlag="P")
     {
        s DivideDr=""
        s DivideDr=$O(^DHCINDIV("0","DHCPB",IpPatBillId,DivideDr),-1)
        //当根据索引，取到DivideDr为空时，不为医保结算，退出
        q:DivideDr=""
        s DivideInfo=$g(^DHCINDIV(DivideDr))
        s INPAYFlag=$p(DivideInfo,"^",5)    //医保结算状态
        b ;INPAYFlag
		//当医保结算状态未为"I"时，正常结算数据
        i (INPAYFlag="I")  
			{
				s InsuFlag="Y"
			}                
     }
   q
GetIsInsuPayByOEORDIdEx
   s $zt=""
   q "-99^程序异常："_$ze
}

/// 保存医保结算人员累计信息查询（5206）信息
/// 入参：       InDivDr: 医保结算表Rowid; 
///             Cuminfo:  累计信息 (多条,@分割)
///          BefAftFlag:  结算前结算后调用标志 （BF,AF） 
///               StInd:  累计信息 (多条,@分割)开始位置
///               EndInd: 累计信息 (多条,@分割)开始位置
/// 出参： 成功：0  失败 小于0^错误信息
/// 使用场景：医保结算后发票要显示累计信息或医保结算单也要显示累计相关信息
///           国家医保接口，此功能浙江用到了。
/// + DingSH  20230412 
/// 调试：   w ##class(web.DHCINSUDivideCtl).SaveDivCuminfo() 
/// 其他说明：累计信息暂存在 ^DHCINSUDivCuminfo(InDivDr,)中
ClassMethod SaveDivCuminfo(InDivDr As %String, Cuminfo As %String, BefAftFlag As %String, StInd As %String, EndInd As %String) As %String
{
	new (InDivDr,Cuminfo,BefAftFlag,StInd,EndInd)
	set $zt="SaveDivCuminfoEx"
	set ^Cachetmp("SaveDivCuminfo")=InDivDr_"^"_Cuminfo_"^"_BefAftFlag_"^"_StInd_"^"_IntEnd
	quit:(InDivDr="")!(Cuminfo="")!(BefAftFlag="")!(StInd="")!(EndInd="") "0"
	for Num = StInd:1:EndInd  {
     set RowCuminfo = $p(Cuminfo,"@",Num-StInd+1)
	 set ^DHCINSUDivCuminfo(InDivDr,BefAftFlag,Num) = RowCuminfo
	}
	quit "0"
SaveDivCuminfoEx
  set $zt=""
  b ;SaveDivCuminfoEx
  quit "-99^调用SaveDivCuminfo异常："_$ze
}

/// 根据医保结算表Rowid更新医保分解标识 
///  DingSH 2023-04-20
/// 入参： InDivDr: 医保结算表Rowid; 
///        DivideFlag:医保分解标识 R（挂号）或F（收费）
/// 使用场景：医生给就患者就诊登记,在门诊收费界面只收医保挂号、诊查费(掉门诊医保收费挂号报销), 更新医生站挂号信息时调用
///     成功:大于0(医保结算表Rowid) 失败：小于0^错误信息
ClassMethod UpdtDivFlag(InDivDr As %String, DivideFlag As %String) As %String
{
	new (InDivDr,DivideFlag)
	set $zt="UpdtDivFlagEx"
	&sql(UPDATE INSU_Divide SET INPAY_Zstr01=:DivideFlag  WHERE INPAY_Rowid =:InDivDr)
	
	quit:+SQLCODE<0 SQLCODE_"^"_%msg
	set flag=$p(%ROWID,$c(1))
    quit flag 
UpdtDivFlagEx
  set $zt=""
  b ;UpdtDivFlagEx
  quit "-99^调用UpdtDivFlag异常："_$ze
}

}
