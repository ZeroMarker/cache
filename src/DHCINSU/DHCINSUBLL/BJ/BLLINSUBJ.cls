Import SQLUser

Class DHCINSU.DHCINSUBLL.BJ.BLLINSUBJ Extends %RegisteredObject
{

/// HisAdmInfo： Type^Name^TotalAmount^HisDepCode^UserID ^发票号^ ^费别Dr ^工伤认定信息 ^预约挂号时间^^ZZFlag^YJJAmount!TarItemDr^Code^Desc^Amount! TarItemDr2^Code2^Desc2^Amount2!……
/// 入参：
/// 		HisAdmInfo		：	同窗口挂号一样医生站传进来的入参
/// 		PersonInfoXml	：	首信读卡串	get_person_info节点
/// 出参：string串		
/// 对应自助的 4.2.1.10	查询是否可取号	divide节点
/// w ##class(DHCINSU.DHCINSUBLL.BJ.BLLINSUBJ).InsuGetOPRegInStr("O^魏国新^42^0301340101^1^^^^^^^!6729^W0101020010^医事服务费【三级医院】【普通门诊】^42", "1024","PersonInfoXml")
/// PersonInfoXml
/// w ##class(DHCINSU.DHCINSUBLL.BJ.BLLINSUBJ).InsuGetOPRegInStr("O^测试卡七^4^0301050101^1305^口腔科门诊(南区)^^10^1^!33751^w0101020001^门急诊诊疗费(三级医院)^4", "1024","PersonInfoXml")
ClassMethod InsuGetOPRegInStr(HisAdmInfo, UserId, PersonInfoXml) As %String
{

	q:HisAdmInfo="" OutStr
	
	//1 定义变量
	s Flag="-1"
	s OutStr="-1"
	s (tmpPayModeDr,index,OutputXML)=""
	s objPatMas=##class(User.PAPatMas).%New()
	s objPAAdm=##class(User.PAAdm).%New()
	
	s objINSUOPRegInfo=##class(DHCINSU.Model.BJ.INSUOPRegInfo).%New()
	s objFeesInfoCollection=##class(DHCINSU.Model.BJ.INSUBasFeesInfoCollection).%New()
	s objDHCTarItemInfo=##class(User.DHCTarItem).%New()
	s objINSUDivideInput=##class(DHCINSU.Model.BJ.INSUDivideInput).%New()
	s objINSUTradeinfo=##class(DHCINSU.Model.BJ.INSUTradeinfo).%New()
	s objINSURecipearray=##class(DHCINSU.Model.BJ.INSURecipearray).%New()
	s objINSUFeeitemarray=##class(DHCINSU.Model.BJ.INSUFeeitemarray).%New()
	s objINSURecipe=##class(DHCINSU.Model.BJ.INSURecipe).%New()
	s objINSUFeeitem=##class(DHCINSU.Model.BJ.INSUFeeitem).%New()

	;s HisAdmInfo=##class(web.DHCINSUFacadeBJ).GetDepInfo(HisAdmInfo)	//肿瘤项目之前方法 add by May 2020-07-28
    s HisAdmInfo=##class(web.DHCINSUFacade).TransforRegInfo(HisAdmInfo)	//新版方法 add by May 2020-07-28
    
    //s objINSUCardInfo=##class(DHCINSU.Model.BJ.INSUCardInfo).%New()
	//s Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).ReadCard(PersonInfoXml,.objINSUCardInfo)
	//q:Flag'=0 OutStr
	    
	s Len=$l(HisAdmInfo,"!")
	s tmpAdmInfo=$p(HisAdmInfo,"!",1)
	s tmpFeeInfo=$p(HisAdmInfo,"!",2,3)
	s UserId=$p(tmpAdmInfo,"^",5)	
	s PAADMType =$p(tmpAdmInfo,"^",1)	
    s PAPMIName =$p(tmpAdmInfo,"^",2)	
    s PAADMDepCode=$p(tmpAdmInfo,"^",4)
    s InsuDepCode = $p(##class(web.INSUDicDataCom).QueryByCode("LocCodeCon",PAADMDepCode),"^",6) 
    s InsuDepDesc = $p(##class(web.INSUDicDataCom).QueryByCode("LocCodeCon",PAADMDepCode),"^",7) 
    s tmpDate=$p(tmpAdmInfo,"^",18) 
    ///肿瘤项目之前方法 add by May 2020-07-28
    ;s InsuDepCode = $p(tmpAdmInfo,"^",6)
    ;s InsuDepDesc = $p(tmpAdmInfo,"^",7)		
    ;s tmpDate=$p(tmpAdmInfo,"^",10)
    
    //modefy by zhangdongliang at 2017-02-22 for 当日期时间传进来不为空时，格式定义为yyyy-MM-dd HH:mm:ss
   	//医保要求的日期时间格式为yyyyMMddHHmmss				
    if tmpDate="" 
    {
	    s PAADMAdmDate = $tr($zd($p($H,",",1),3),"-","")
    	s PAADMAdmTime = $tr($zt($p($H,",",2)),":","")
	}
	else
	{  
		s PAADMAdmDate =$tr($p(tmpDate," ",1),"-","")
    	s PAADMAdmTime =$tr($p(tmpDate," ",2),":","")
	}	   

	//Tradeinfo
    i PAADMType="O" d
    .s objINSUTradeinfo.curetype="17"
    i PAADMType="E" d
    .s objINSUTradeinfo.curetype="18"
	s objINSUTradeinfo.illtype=0
	s objINSUTradeinfo.feeno=PAADMAdmDate_PAADMAdmTime_UserId
	s objINSUTradeinfo.operator=UserId
	s objINSUDivideInput.tradeinfo=objINSUTradeinfo
	
	
	//Recipearray
	s objINSURecipe.diagnoseno=1
	s objINSURecipe.recipeno=1
	s objINSURecipe.recipedate=PAADMAdmDate_PAADMAdmTime
	s objINSURecipe.diagnosecode=""
	s objINSURecipe.diagnosename=""
	
	s objINSURecipe.medicalrecord=""
	s objINSURecipe.sectioncode=InsuDepCode
	s objINSURecipe.sectionname=InsuDepDesc
	s objINSURecipe.hissectionname=PAADMDepCode
	s objINSURecipe.drid=""
	
	s objINSURecipe.drname=""
	s objINSURecipe.recipetype=1
	s objINSURecipe.helpmedicineflag=""
	s objINSURecipe.remark=""
	s objINSURecipe.registertradeno=""
	s objINSURecipe.billstype="1"

	d objINSURecipearray.recipe.Insert(objINSURecipe)
	s objINSUDivideInput.recipearray=objINSURecipearray
	
	//Feeitemarray
	f Index=2:1:Len
	{
    	s objINSUFeeitem=##class(DHCINSU.Model.BJ.INSUFeeitem).%New()
    	s tmpFeeInfo=$p(HisAdmInfo,"!",Index)
    	s objINSUFeeitem.itemno=Index-1
    	s objINSUFeeitem.recipeno=1
    	s objINSUFeeitem.hiscode=$p(tmpFeeInfo,"^",2)
    	s objINSUFeeitem.itemname=$p(tmpFeeInfo,"^",3)
    	s objINSUFeeitem.itemtype=1
    	s objINSUFeeitem.unitprice=$p(tmpFeeInfo,"^",4)
    	s objINSUFeeitem.count=1
    	s objINSUFeeitem.fee=$p(tmpFeeInfo,"^",4)
 		d objINSUFeeitemarray.feeitem.Insert(objINSUFeeitem) //每取到一个处方明细，就把它插入到主体Obj中
 		;w objINSUFeeitemarray.feeitem.GetAt(Index-1).hiscode,!

	}
	s objINSUDivideInput.feeitemarray=objINSUFeeitemarray
	
	//ToStr
	Do objINSUDivideInput.XMLExportToString(.OutputXML,"input")	
	//怎么转换xml中文字符格式 UTF-8
	//会有乱码，如何解决？
	//s OutputXML=$zcvt(OutputXML,"I","UTF8")
	//s OutputXML=$zcvt(OutputXML,"I","GB2312")

	q OutputXML
}

/// w ##class(DHCINSU.DHCINSUBLL.BJ.BLLINSUBJ).GetOPRegBaseInfo("", "UserId","PersonInfoXml")
ClassMethod GetOPRegBaseInfo(HisAdmInfo, objPatMas As User.PAPatMas, objINSUOPRegInfo As DHCINSU.Model.BJ.INSUOPRegInfo) As %String
{
	s HisAdmInfo=##class(web.DHCINSUFacadeBJ).GetDepInfo(HisAdmInfo)
	s Len=$l(HisAdmInfo,"!")
	s tmpAdmInfo=$p(HisAdmInfo,"!",1)
	s tmpFeeInfo=$p(HisAdmInfo,"!",2,3)
	s UserId=$p(tmpAdmInfo,"^",5)	
	s objINSUOPRegInfo.PAADMType =$p(tmpAdmInfo,"^",1)	
    s objINSUOPRegInfo.PAPMIName =$p(tmpAdmInfo,"^",2)	
    s PAADMDepCode = $p(tmpAdmInfo,"^",4)
    s objINSUOPRegInfo.PAADMDepCode=PAADMDepCode
    s InsuDepCode = $p(##class(web.INSUDicDataCom).QueryByCode("LocCodeCon",PAADMDepCode),"^",6) 
    s InsuDepDesc = $p(##class(web.INSUDicDataCom).QueryByCode("LocCodeCon",PAADMDepCode),"^",7) 
    s objINSUOPRegInfo.InsuDepCode = InsuDepCode
    s objINSUOPRegInfo.InsuDepDesc = InsuDepDesc		
    s tmpDate=$p(tmpAdmInfo,"^",18)					;##class(web.INSUBase).GetSysDateTime()
   	///肿瘤项目之前方法 add by May 2020-07-28
    ;s objINSUOPRegInfo.InsuDepCode = $p(tmpAdmInfo,"^",6)
    ;s objINSUOPRegInfo.InsuDepDesc = $p(tmpAdmInfo,"^",7)		
    ;s tmpDate=$p(tmpAdmInfo,"^",10)					;##class(web.INSUBase).GetSysDateTime()
    
    if tmpDate="" 
    {
	    s objINSUOPRegInfo.PAADMAdmDate = $zd($p($H,",",1),3)
    	s objINSUOPRegInfo.PAADMAdmTime = $zt($p($H,",",2))
	}
	else
	{  
    	s objINSUOPRegInfo.PAADMAdmDate =$p(tmpDate," ",1)	
    	s objINSUOPRegInfo.PAADMAdmTime =$p(tmpDate," ",2)
	}
    q 0
}

/// 入参：
/// 		AdmDr		：	paadmrowid
/// 		PersonInfoXml	：	首信读卡串	get_person_info节点
/// 		DivideXml	：	首信Divide函数返回串	divide节点
/// 		TradeXml	：	首信Trade函数返回串		trade 节点
/// 出参："0" & "^" & InsuAdmDr & "^" & tmpPayModeDr(0) & "!" & objDivideResult.cash & Chr(2) & tmpPayModeDr(1) & "!" & objDivideResult.fund & Chr(2) & tmpPayModeDr(2) & "!" & 	objDivideResult.personcountpay
/// 	说明：	InsuAdmDr：				insu_adminfo.rowid
/// 			tmpPayModeDr(0)：		现金支付方式rowid
/// 			objDivideResult.cash：	现金金额
/// 			tmpPayModeDr(1)：		医保统筹支付方式rowid
///       	objDivideResult.fund：	医保统筹支付金额
/// 			tmpPayModeDr(2)：		医保账户支付方式rowid
/// 			objDivideResult.personcountpay：医保账户支付金额
/// 		4.2.1.11	取号	。
/// w ##class(DHCINSU.DHCINSUBLL.BJ.BLLINSUBJ).InsuOPReg("O^测试卡七九^42^0301070101^1305^心血管门诊(南区)^^2^!6729^W0101020010^医事服务费【三级医院】【普通门诊】^42", "1024","PersonInfoXml", "DivideXml", "TradeXml")
ClassMethod InsuOPReg(HisAdmInfo, UserId, PersonInfoXml, DivideXml, TradeXml) As %String
{
	
	//1 定义变量
	s Flag="-1"
	s OutStr="-1"
	q:HisAdmInfo="" OutStr
	q:PersonInfoXml="" OutStr
	q:DivideXml="" OutStr
	q:TradeXml="" OutStr
	
	S ^TEMPZDL("InsuOPReg")=HisAdmInfo
	S ^TEMPZDL("PersonInfoXml")=PersonInfoXml
	S ^TEMPZDL("DivideXml")=DivideXml
	S ^TEMPZDL("TradeXml")=TradeXml
	
	/*
	s file=##class(%File).%New("D:\InsuOPRegPersonInfo.Xml")
	d file.Open("WSN")
	d file.WriteLine(PersonInfoXml)
	d file.Close()
	
	s file=##class(%File).%New("D:\InsuOPRegDivide.Xml")
	d file.Open("WSN")
	d file.WriteLine(DivideXml)
	d file.Close()
	
	s file=##class(%File).%New("D:\InsuOPRegTrade.Xml")
	d file.Open("WSN")
	d file.WriteLine(TradeXml)
	d file.Close()
	*/
			
	//2 初始化变量 GetOPRegBaseInfo//3 GetDepInfo//4 GetPayModeDr
	s objPatMas=##class(User.PAPatMas).%New()
	s objINSUAdm=##class(User.INSUAdmInfo).%New()
	s objINSUOPRegInfo=##class(DHCINSU.Model.BJ.INSUOPRegInfo).%New()
	
	//Cash_"^"_TCzf_"^"_ZHzf_"^"_HospitalCode_"^"_UserName_"^"_Insu16
	s tmpPayModeDr=##class(web.DHCINSUFacadeBJ).GetPayModeDr(UserId)
	
	s Flag=##class(DHCINSU.DHCINSUBLL.BJ.BLLINSUBJ).GetOPRegBaseInfo(HisAdmInfo,objPatMas,.objINSUOPRegInfo)
    q:Flag'=0 OutStr
	
	s objINSUCardInfo=##class(DHCINSU.Model.BJ.INSUCardInfo).%New()
	s Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).ReadCard(PersonInfoXml,.objINSUCardInfo)
	q:Flag'=0 OutStr
	
	s objINSUDivideOutput=##class(DHCINSU.Model.BJ.INSUDivideOutput).%New()
	S Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).InsuOPBillPre(DivideXml,.objINSUDivideOutput)
	q:Flag'=0 OutStr
	
	s objINSUTradeOutput=##class(DHCINSU.Model.BJ.INSUTradeOutput).%New()
	S Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).InsuOPBill(TradeXml,.objINSUTradeOutput)
	q:Flag'=0 OutStr
	
	///test:
	//w "INSUCardInfo.ic.cardno="_objINSUCardInfo.ic.cardno,!
	//w "INSUDivideOutput.tradeinfo.tradeno="_objINSUDivideOutput.tradeinfo.tradeno,!
	//w "INSUTradeOutput.certid="_objINSUTradeOutput.certid,!
	
	S Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).BuildInsuAdm(UserId,.objINSUOPRegInfo,objINSUCardInfo,objINSUDivideOutput,objINSUTradeOutput,.objINSUAdm)
	q:Flag'=0 OutStr
	
	s sc=objINSUAdm.%Save()  //成功的话sc为1
	If ($System.Status.IsError(sc))	
	{
		q OutStr_$System.Status.GetErrorText(sc)
	}

	q 0_"^"_objINSUAdm.%Id()_"^"_$p(tmpPayModeDr,"^",1)_"!"_objINSUAdm.INADMXString2_$CHAR(2)_$p(tmpPayModeDr,"^",2)_"!"_objINSUAdm.INADMXString3_$CHAR(2)_$p(tmpPayModeDr,"^",3)_"!"_objINSUAdm.INADMXString4
}

// 入参：

// 		AdmDr		：	paadmrowid

// 		PersonInfoXml	：	首信读卡串	get_person_info节点

// 		DivideXml	：	首信refundment函数返回串	refundment_divide节点

// 		TradeXml	：	首信Trade函数返回串		trade 节点

// 出参：0成功、非0失败。	4.2.1.13	提交医保退费信息

/// w ##class(DHCINSU.DHCINSUBLL.BJ.BLLINSUBJ).InsuOPRegStrike("557623", 1024,"PersonInfoXml", "refundmentdivideXml", "TradeXml")
ClassMethod InsuOPRegStrike(INSUAdmDr, UserId, PersonInfoXml, refundmentdivideXml, TradeXml) As %String
{
	
	//S ^TEMPZDL("InsuOPReg")=INSUAdmDr
	
	/*
	s file=##class(%File).%New("D:\InsuOPRegStrikePersonInfo.Xml")
	d file.Open("WSN")
	d file.WriteLine(PersonInfoXml)
	d file.Close()
	
	s file=##class(%File).%New("D:\InsuOPRegStrikeDivide.Xml")
	d file.Open("WSN")
	d file.WriteLine(PersonInfoXml)
	d file.Close()
	
	s file=##class(%File).%New("D:\InsuOPRegStrikeTrade.Xml")
	d file.Open("WSN")
	d file.WriteLine(PersonInfoXml)
	d file.Close()
	*/
	
	//1 定义变量
	s Flag="-1"
	s OutStr="-1"
	//2 初始化变量 GetOPRegBaseInfo//3 GetDepInfo//4 GetPayModeDr
	s objINSUAdmOLD=##class(User.INSUAdmInfo).%OpenId(INSUAdmDr)
	s objINSUAdmNew=##class(User.INSUAdmInfo).%New()
	//s objPAAdm=objINSUAdmOLD.INADMAdmDr		
	//s objPatMas=##class(User.PAPatMas).%OpenId(objPAAdm.PAADMPAPMIDR)
	s objPAAdm=##class(User.PAAdm).%New()
	s objPatMas=##class(User.PAPatMas).%New()

	s objINSUCardInfo=##class(DHCINSU.Model.BJ.INSUCardInfo).%New()
	s Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).ReadCard(PersonInfoXml,.objINSUCardInfo)
	q:Flag'=0 OutStr
	s objINSUDivideOutput=##class(DHCINSU.Model.BJ.INSUDivideOutput).%New()
	S Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).InsuOPBillStrikePre(refundmentdivideXml,.objINSUDivideOutput)
	q:Flag'=0 OutStr
	s objINSUTradeOutput=##class(DHCINSU.Model.BJ.INSUTradeOutput).%New()
	S Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).InsuOPBillStrike(TradeXml,.objINSUTradeOutput)
	q:Flag'=0 OutStr
	///test:
	//w "INSUCardInfo.ic.cardno="_objINSUCardInfo.ic.cardno,!
	//w "INSUDivideOutput.tradeinfo.tradeno="_objINSUDivideOutput.tradeinfo.tradeno,!
	//w "INSUTradeOutput.certid="_objINSUTradeOutput.certid,!
		
	S Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).BuildInsuAdmStrike(UserId,objPAAdm,objINSUCardInfo,objINSUDivideOutput,objINSUTradeOutput,.objINSUAdmNew,objINSUAdmOLD)
	q:Flag'=0 OutStr

    tstart    
    &sql(Update INSU_AdmInfo SET INADM_ActiveFlag='I' where INADM_Rowid=:INSUAdmDr)
   	q:SQLCODE'="0" OutStr
   	
   	s sc=objINSUAdmNew.%Save()  //成功的话sc为1
	If ($System.Status.IsError(sc))	
	{
		trollback	
		q OutStr_$System.Status.GetErrorText(sc)
	}
	else
	{
		tcommit
	}


	q 0
}

/// w ##class(DHCINSU.DHCINSUBLL.BJ.BLLINSUBJ).InsuReadCard("PersonInfoXml")
/// 入参：首信读卡返回的XML串
/// 出参：
/// 			失败：  -1
/// 			成功：	000002721005|00000272100S|999999197006227223|张三2|2|19700622|3|11|0.00||18991230|0|0|0|true|1|true|1,2,3,4,5,6||
ClassMethod InsuReadCard(PersonInfoXml) As %String
{
	s Flag="-1"
	s OutStr="-1"
	q:PersonInfoXml="" OutStr
	
	s objINSUCardInfo=##class(DHCINSU.Model.BJ.INSUCardInfo).%New()
	s Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).ReadCard(PersonInfoXml,.objINSUCardInfo)
	q:Flag'=0 OutStr
	                   
    s OutStr=objINSUCardInfo.ic.cardno_"|"_objINSUCardInfo.ic.icno_"|"_objINSUCardInfo.ic.idno_"|"_objINSUCardInfo.ic.personname_"|"_objINSUCardInfo.ic.sex
	s OutStr=OutStr_"|"_objINSUCardInfo.ic.birthday_"|"_objINSUCardInfo.ic.fundtype_"|"_objINSUCardInfo.net.persontype_"|"_objINSUCardInfo.net.personcount_"|"_objINSUCardInfo.ic.fromhosp
	s OutStr=OutStr_"|"_objINSUCardInfo.ic.fromhospdate_"|"_objINSUCardInfo.ic.isyt_"|"_objINSUCardInfo.ic.jclevel_"|"_objINSUCardInfo.ic.hospflag_"|"_objINSUCardInfo.net.isinredlist
	s OutStr=OutStr_"|"_objINSUCardInfo.net.isspecifiedhosp_"|"_objINSUCardInfo.net.ischronichosp_"|"_objINSUCardInfo.net.chroniccode_"|"_""_"|"_""
	
	q OutStr
}

/// 取门诊发票账单明细类
/// add by lilizhi
/// 2016-07-20
/// 入参：StrInvDr：发票rowid串
///       InsuType: 医保类型
/// 出参：0 成功
/// w ##class(DHCINSU.DHCINSUBLL.BJ.BLLINSUBJ).GetOPInvObjByStrInvDr("19884222","BJ","")
ClassMethod GetOPInvObjByStrInvDr(StrInvDr As %String, InsuType As %String, objInvPrtCol As DHCINSU.InvPrtCol) As %String
{
	s instype=""
	s OutStr="-1"
    s BillFlag="",InvStr=""
    s InvDrNum=$l(StrInvDr,"^")    
    s myIdx="",ConStr="",TmpInvRowid="",TmpFlag="",paadm="",BillFlag=""
    s OutputXML=""
   	//s objInvPrtCol=##class(DHCINSU.InvPrtCol).%New()
    f i=1:1:InvDrNum     d
    .s billStr=""
    .s myIdx=1
    .s tmpPrtRowID=$p(StrInvDr,"^",i)
    .q:tmpPrtRowID=""
    .s InvPrt=$p($g(^DHCINVPRT(tmpPrtRowID)),"^",14)
    .q:'$d(^DHCBCI(0,"INV",tmpPrtRowID))
    .s TmpInvRowid=tmpPrtRowID
    .s PRTAcount=$p($g(^DHCINVPRT(tmpPrtRowID)),"^",1)
    .s instype=$p($g(^DHCINVPRT(tmpPrtRowID)),"^",9)
    .s BillConInvRowid=""
    .s objInvPrt=##class(DHCINSU.InvPrt).%New()
    .s objInvPrt.InvPrtNo=InvPrt
    .s objInvPrt.TmpInvRowid=TmpInvRowid
    .s objInvPrt.InvTotal=PRTAcount
    .s objInvPrt.InvAdmReason=instype
    
    .s objPatientBill=##class(DHCINSU.PatientBill).%New()
    .//这里有bug，北京门诊程序是把同一个发票rowid内的多个账单rowid当作一个，如果合科室结算，就会出现多个账单rowid，暂时不知道哪家医院是合科室结算。
    .s RtnStr=##class(web.DHCINSUFacadeBJ).GetBillInfoByPRTINVDR(StrInvDr)	//Num-1_"|"_$j_"|"_InvTotal
    .s count=$p(RtnStr,"|",1)
    .s InsuPID=$p(RtnStr,"|",2)
    .s PBTotal=$p(RtnStr,"|",3)
    .s AdmDr=""
	.f BillIndex=1:1:count   d
	..s BillInfo=^CacheTemp("BillInfo",InsuPID,BillIndex)
	..s BillDr=$p(BillInfo,"=",1)
	..s AdmDr=$p($g(^DHCPB(BillDr)),"^",1)
	..s objPatientBill.PBDr=$p(BillInfo,"=",1)
	..s BillDetailsInfo=$p(BillInfo,"=",3)
	..s TarItemInfo=$p(BillInfo,"=",4)
	..s OeordInfo=$p(BillInfo,"=",5)
	..s OeordExtInfo=$p(BillInfo,"=",6)
	..s TarContrastInfo=$p(BillInfo,"=",7)
	..s DivideSubInfo=$p(BillInfo,"=",8)

	..s objPatBillDetails=##class(DHCINSU.PatBillDetails).%New()
	..s objHisTarItemInfo=##class(DHCINSU.HisTarItemInfo).%New()
	..s objInsuTarItemInfo=##class(DHCINSU.InsuTarItemInfo).%New()
	..s objInsuTarContrastInfo=##class(DHCINSU.InsuTarContrastInfo).%New()
	..s objInsuDivideSubInfo=##class(DHCINSU.InsuDivideSubInfo).%New()
	..s objOeordInfo=##class(DHCINSU.OeordInfo).%New()

	..s rtn=$$BuildobjHisTarItem^DHCINSUOPBill(TarItemInfo,objHisTarItemInfo)
	..s objPatBillDetails.HisTarItemInfo=objHisTarItemInfo
	..s rtn=$$BuildobjInsuTarItem^DHCINSUOPBill(TarItemInfo,objInsuTarItemInfo)
	..s objPatBillDetails.InsuTarItemInfo=objInsuTarItemInfo
	..s rtn=$$BuildobjInsuTarContrastInfo^DHCINSUOPBill(TarContrastInfo,objInsuTarContrastInfo)
	..s objPatBillDetails.InsuTarContrastInfo=objInsuTarContrastInfo
	..s rtn=$$BuildobjInsuDivideSubInfo^DHCINSUOPBill(DivideSubInfo,objInsuDivideSubInfo)
	..s objPatBillDetails.InsuDivideSubInfo=objInsuDivideSubInfo
	..s rtn=$$BuildobjOeordInfo^DHCINSUOPBill(OeordInfo,OeordExtInfo,objOeordInfo,TarItemInfo)
	..s objPatBillDetails.OeordInfo=objOeordInfo
	..s objPatBillDetails.PBDr=BillDr
	..s objPatBillDetails.BillQty=$p(BillDetailsInfo,"^",5)
	..s objPatBillDetails.UnitPrice=$p(BillDetailsInfo,"^",6)
	..s objPatBillDetails.TotalAmount=$p(BillDetailsInfo,"^",7)
	..s objPatBillDetails.PBOOrderDate=$p(BillDetailsInfo,"^",12)
	..s objPatBillDetails.PBOOrderTime=$p(BillDetailsInfo,"^",13)
	..s objPatBillDetails.PBDID=$p(BillDetailsInfo,"^",15)
	..d objPatientBill.PatBillDetails.Insert(objPatBillDetails)

	.;此处有bug，无法取到非最后一笔pbd的账单信息
	.s objPatientBill.PBDr=BillDr
	.s objPatientBill.PBPayedFlag=$p(BillDetailsInfo,"^",1)
	.s objPatientBill.INSUPID=InsuPID
	.s objPatientBill.PBDateFrom=$p(BillDetailsInfo,"^",3)
	.s objPatientBill.PBDateTo=$p(BillDetailsInfo,"^",4)
	.s objPatientBill.PBUpdateUserDr=$p(BillDetailsInfo,"^",8)
	.s objPatientBill.PBUpdateUser=$p(BillDetailsInfo,"^",9)
	.s objPatientBill.UpdateDate=$p(BillDetailsInfo,"^",10)
	.s objPatientBill.UpdateTime=$p(BillDetailsInfo,"^",11)
	.s objPatientBill.PBTotalAmount=PBTotal
	.s objPatientBill.PBAdmDr=$p(BillDetailsInfo,"^",14)
	.d objInvPrt.PatientBill.Insert(objPatientBill)
	
	.//取处方信息
	.s RecipeInfoStr=##class(web.DHCINSUFacadeBJ).GetRecipeInfoByInvprtdrNew(StrInvDr)
	.s RecipeRunTimeID = $p(RecipeInfoStr,"^",1)
    .s RecipeCount = $p(RecipeInfoStr,"^",2)
    .f RecipeIndex=0:1:RecipeCount-1   d
    ..s objINSUOPDiagInfo=##class(DHCINSU.Model.BJ.INSUOPDiagInfo).%New()
    ..s RecipeInfo=##class(web.DHCINSUFacadeBJ).GetRecipeInfoFromCacheTmp(RecipeRunTimeID, RecipeIndex)
    ..;InvPrtDr_"^"_i_"^"_RecipeNO_"^"_PBOOrderDate_"^"_DiagnoseCode_"^"_
    ..;DiagnoseName_"^"_MedicalRecord_"^"_InsuDepCode_"^"_InsuDepDesc_"^"_HisDepDesc_"^"_
    ..;DocCode_"^"_DocName_"^"_RecipeType_"^"_""_"^"_INADMAdmSeriNo_"^"_
    ..;billstype
    ..;1-5
    ..s objINSUOPDiagInfo.InvprtDr=$p(RecipeInfo,"^",1)
    ..s objINSUOPDiagInfo.DiagIdx=$p(RecipeInfo,"^",2)
    ..s objINSUOPDiagInfo.OeordDR=$p(RecipeInfo,"^",3)
    ..s objINSUOPDiagInfo.OeordDate=$p(RecipeInfo,"^",4)
    ..s objINSUOPDiagInfo.DiagCode=$p(RecipeInfo,"^",5)
	..;6-10
    ..s objINSUOPDiagInfo.DiagDesc=$p(RecipeInfo,"^",6)
    ..s objINSUOPDiagInfo.PatEPRInfo=$p(RecipeInfo,"^",7)
    ..s objINSUOPDiagInfo.BasDicDepCode=$p(RecipeInfo,"^",8)
    ..s objINSUOPDiagInfo.BasDicDepDesc=$p(RecipeInfo,"^",9)
    ..s objINSUOPDiagInfo.AdmDepDesc=$p(RecipeInfo,"^",10)
	..;11-15
    ..s objINSUOPDiagInfo.DocCode=$p(RecipeInfo,"^",11)
    ..s objINSUOPDiagInfo.DocName=$p(RecipeInfo,"^",12)
    ..s objINSUOPDiagInfo.OeordType=$p(RecipeInfo,"^",13)
    ..s objINSUOPDiagInfo.OeordDemo=$p(RecipeInfo,"^",14)
    ..s objINSUOPDiagInfo.registertradeno=$p(RecipeInfo,"^",15)
    ..;16
    ..s objINSUOPDiagInfo.billstype=$p(RecipeInfo,"^",16)
    ..d objInvPrt.INSUOPDiagInfoCol.Insert(objINSUOPDiagInfo)
	
    .s objInvPrt.PaadmRowid=AdmDr
    .s TmpFlag=""
    .s TmpFlag=..CheckInv(AdmDr,TmpInvRowid)
    .s:TmpFlag="Y" BillFlag="Y"
    .d objInvPrtCol.InvPrt.Insert(objInvPrt)
    
    s objInvPrtCol.PaadmRowid=AdmDr
    s objInvPrtCol.BillFlag=BillFlag

    d objInvPrtCol.XMLExportToString(.OutputXML,"InvPrtCol")

	/*
	s LogFileName="D:\GetOPInvObjByStrInvDr_"_StrInvDr_".xml"
	s file=##class(%File).%New(LogFileName)
	d file.Open("WSN")
	d file.WriteLine(OutputXML)
	d file.Close()
	*/
	
    s OutStr="0"

    q OutStr
}

ClassMethod CheckInv(paadm, TmpInvRowid) As %String
{
	;paadm 的最后一笔结算成功，中间几笔数据已经结果，这个函数会结算第二次函数有漏洞。
	;n (paadm, TmpInvRowid)
	;w !,TmpInvRowid
    ;n (paadm, TmpInvRowid)
	s CheckInv="N"
	;^DHCINDIV(0,"Paadm",1017,2
	q:'$d(^DHCINDIV(0,"Paadm",paadm)) CheckInv
	s indiv=""
	f  s indiv=$o(^DHCINDIV(0,"Paadm",paadm,indiv))  q:(indiv="")!(CheckInv="Y")  d
	.s DivFlag=$p($g(^DHCINDIV(indiv)),"^",5)
	.s divTmpInv=$p($g(^DHCINDIV(indiv)),"^",4)
	.;w !,indiv_"//"_DivFlag_"//"_divTmpInv,!
	.q:DivFlag'="I"
	.s CheckInv=$$Check(divTmpInv,TmpInvRowid)	
	q CheckInv
	
Check(divTmpInv,TmpInvRowid)
   ;n (divTmpInv,TmpInvRowid)
   s iDivCount=$l(divTmpInv,"!")
   s iTmpCount=$l(TmpInvRowid,"!")
   ;w iDivCount_"//"_iTmpCount
   s Flag=""
   f i=2:1:iDivCount  d
   .s divTmp=$p(divTmpInv,"!",i)
   .f j=2:1:iTmpCount d
   ..s TmpInv=$p(TmpInvRowid,"!",j)
   ..;w !,"  divTmp=TmpInv "_divTmp_"---"_TmpInv
   ..s:divTmp=TmpInv Flag="Y"
   q Flag
}

/// PersonInfoXml
/// w ##class(DHCINSU.DHCINSUBLL.BJ.BLLINSUBJ).InsuGetOPDivideInStr("1024","19884176","PersonInfoXml","")
/// 预计ExpStr用不到，暂时传空。itemno使用时间流水，不使用真实发票号
/// 自助机只能单张发票结算
ClassMethod InsuGetOPDivideInStr(UserId, InvPrtDr, PersonInfoXml, ExpStr) As %GlobalCharacterStream
{
	s Flag="-1"
	s OutStr="-1"
	q:InvPrtDr="" OutStr
	
	//1 定义变量
	s (OutputXML)=""
	;s objPatMas=##class(User.PAPatMas).%New()
	s objPAAdm=##class(User.PAAdm).%New()
	;s objINSUAdm=##class(User.INSUAdmInfo).%New()
	s objInvPrtCol=##class(DHCINSU.InvPrtCol).%New()
	s objINSUDivideInput=##class(DHCINSU.Model.BJ.INSUDivideInput).%New()

    //用来校验his与传进来的person信息是否一致
    ;s objINSUCardInfo=##class(DHCINSU.Model.BJ.INSUCardInfo).%New()
	;s Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).ReadCard(PersonInfoXml,.objINSUCardInfo)
	;q:Flag'=0 OutStr
	//Todo 核对姓名，核对医保卡号，但：部分医院objPat.Name3取不到医保号，后台没有存，objInsuAdm.CardNo没有登记信息，也取不到。
	      
	//取发票集合信息
	s Flag=..GetOPInvObjByStrInvDr(InvPrtDr,"BJ",.objInvPrtCol)	
	q:Flag'=0 OutStr
	s objInvPrt=##class(DHCINSU.InvPrt).%New()
	s objInvPrt=objInvPrtCol.InvPrt.GetAt(1)
	
	//取基本信息             
    s AdmDr=objInvPrt.PaadmRowid
    s objPAAdm=##class(User.PAAdm).%OpenId(AdmDr)	
	//取医保登记信息、判断是否可以挂号 
	//组织dividein数据
	s Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).InsuGetOPDivideInStr(UserId,objPAAdm,objInvPrt,.objINSUDivideInput)
	q:Flag'=0 OutStr
	
	//ToStr
	s OutputXMLLog=""
	
	//Do objINSUDivideInput.XMLExportToString(.OutputXMLLog,"input")
	Do objINSUDivideInput.XMLExportToStream(.OutputXML,"input")	
	
	/*
	//生成XML文件日志
	s LogFileName="D:\DivideIn_"_InvPrtDr_".xml"
	s file=##class(%File).%New(LogFileName)
	d file.Open("WSN")
	d file.WriteLine(OutputXMLLog)
	d file.Close()
	*/

	q OutputXML
}

/// w ##class(DHCINSU.DHCINSUBLL.BJ.BLLINSUBJ).InsuOPDivide(1, "539165", "PersonInfoXml", "DivideOutXml", "TradeXml")
ClassMethod InsuOPDivide(UserId, InvPrtDr, PersonInfoXml, DivideOutXml, TradeXml) As %String
{

	//1 定义变量
	s Flag="-1"
	s OutStr="-1"

	/*
	s LogFileName="D:\PersonInfoXml_"_InvPrtDr_".xml"
	s file=##class(%File).%New(LogFileName)
	d file.Open("WSN")
	d file.WriteLine(PersonInfoXml)
	d file.Close()
	s LogFileName="D:\DivideOutXml_"_InvPrtDr_".xml"
	s file=##class(%File).%New(LogFileName)
	d file.Open("WSN")
	d file.WriteLine(DivideOutXml)
	d file.Close()
	s LogFileName="D:\TradeXml_"_InvPrtDr_".xml"
	s file=##class(%File).%New(LogFileName)
	d file.Open("WSN")
	d file.WriteLine(TradeXml)
	d file.Close()
	*/

	s ^TEMPZDL("InsuOPDivide",InvPrtDr,"InvPrtDr")=InvPrtDr
	s ^TEMPZDL("InsuOPDivide",InvPrtDr,"PersonInfoXml")=PersonInfoXml
	s ^TEMPZDL("InsuOPDivide",InvPrtDr,"DivideOutXml")=DivideOutXml
	s ^TEMPZDL("InsuOPDivide",InvPrtDr,"TradeXml")=TradeXml
	
	q:InvPrtDr="" OutStr
	q:PersonInfoXml="" OutStr
	q:DivideOutXml="" OutStr
	q:TradeXml="" OutStr
	
	//2 初始化变量 
	s objPatMas=##class(User.PAPatMas).%New()
	s objPAAdm=##class(User.PAAdm).%New()
	s objINSUAdmInfo=##class(User.INSUAdmInfo).%New()
	s objINSUDivide=##class(User.INSUDivide).%New()
	 
   	s DHCBCIDr="0",AdmDr=""
   	f  s DHCBCIDr=$o(^DHCBCI(0,"INV",InvPrtDr,DHCBCIDr)) q:(DHCBCIDr="")  d
   	.s mCurrRowDHCBillConINV=$g(^DHCBCI(DHCBCIDr))
   	.s AdmDr=$p(mCurrRowDHCBillConINV,"^",3)
   	s objPAAdm=##class(User.PAAdm).%OpenId(AdmDr)

	s INSUAdmDr=""
	s INSUAdmDr=$o(^DHCINADM("0","ADM",AdmDr,INSUAdmDr),-1)
	i INSUAdmDr'="" d
	.s objINSUAdmInfo=##class(User.INSUAdmInfo).%OpenId(INSUAdmDr)
	
	s tmpPayModeDr=##class(web.DHCINSUFacadeBJ).GetPayModeDr(UserId)
	s PayModeDrJYT=$o(^CT("CTPM",0,"Code","JYTZJJF",""),-1) 
	s PayModeDrCash=$p(tmpPayModeDr,"^",1)
	s PayModeDrTCzf=$p(tmpPayModeDr,"^",2)
	s PayModeDrZHzf=$p(tmpPayModeDr,"^",3)
	
	s objINSUCardInfo=##class(DHCINSU.Model.BJ.INSUCardInfo).%New()
	s Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).ReadCard(PersonInfoXml,.objINSUCardInfo)
	q:Flag'=0 OutStr
	s objINSUDivideOutput=##class(DHCINSU.Model.BJ.INSUDivideOutput).%New()
	S Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).InsuOPBillPre(DivideOutXml,.objINSUDivideOutput)
	q:Flag'=0 OutStr
	s objINSUTradeOutput=##class(DHCINSU.Model.BJ.INSUTradeOutput).%New()
	S Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).InsuOPBill(TradeXml,.objINSUTradeOutput)
	q:Flag'=0 OutStr
	
	s Flag=##class(DHCINSU.Adaper.BJ.AdaperINSUBJ).BuildInsuDivide(UserId,InvPrtDr,objPAAdm,objINSUAdmInfo,objINSUCardInfo,objINSUDivideOutput,objINSUTradeOutput,.objINSUDivide)
	q:Flag'=0 OutStr

	s sc=objINSUDivide.%Save()  //成功的话sc为1
	If ($System.Status.IsError(sc))	
	{
		q OutStr_$System.Status.GetErrorText(sc)
	}
		
	s OutStr=0_"^"_objINSUDivide.%Id()_"^"_objINSUDivide.INPAYgrzfe0_"^"_InvPrtDr_"^"_PayModeDrJYT_"^ZFPZ"_$CHAR(2)_PayModeDrTCzf_"^"_objINSUDivide.INPAYjjzfe0_$CHAR(2)_PayModeDrZHzf_"^"_objINSUDivide.INPAYzhzfe0
	s ^TEMPZDL("InsuOPDivide",InvPrtDr,"OutStr")=OutStr

	
	q OutStr
}

}
