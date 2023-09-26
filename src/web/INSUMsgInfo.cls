Class web.INSUMsgInfo Extends %RegisteredObject
{

/// Creator: tangzf
/// CreateDate: 2018-03-11
/// Descript: 插入/更新 表 User.INSUMsgInfo
/// Input:	InString : 入参串 ^ 分割的字符串 
/// 					^ 第1位 User.INSUMsgInfo RowId  若为空 则新增记录  若不为空 则修改记录
/// 					^ 第2位 User.SSUser.Initials 收费员工号 ；^ 第3位 客户端IP地址 ；^ 第4位 客户端mac地址；^ 第5位 登记号 ；^ 第6位 医保号 ；^ 第7位 就诊号 ；^ 第8位 发票Rowid
/// 					^ 第9位 账单号 ；^ 第12位 客户端日期 ；^ 第13位 客户端时间；^ 第14位 医保业务类型(如医保登记) ；^ 第15位 客户端名称 ；^ 第16位 问题是否已处理 ：Y 已处理  ；^ 第17位 问题处理人
/// 					^ 第18位 解决日期 ；^ 第19位 解决时间 ；^ 第20位 解决方法 ；^ 第21位 医保中心报错详细信息 (表里只截取保存前150位，详细信息见  ^DHCINMSG(User.INSUMsgInfo.Rowid,"ALL"))
/// 						^ 第22位 产品线 ^ 第23位 院区 ^ 第24位 业务ID ^ 第25位 参数类型
/// Output: 
/// Return: 返回值 小于 0 为失败 =-100^错误描述  ; 大于0为成功值为 User.INSUMsgInfo.RowId
/// DeBug: 
/// w ##class(web.INSUMsgInfo).insert("^demo^192.168.23.1^CA:21:58:2F:2F:15^^^^^278431^^^2018-04-25^14:53:30^InsuIPMXUpload^xian-PC^^^^^^2018/4/25 14:52:26：paadmRowid=129的医保登记挂号信息无效，InsuAdm.Rowid=34, objInsuAdm.ActiveFlagS")
/// w ##class(web.INSUMsgInfo).insert("^demo^10.1.62.57^F0:76:1C:1F:76:24^^^81^^^^^2018-03-21^11:28:34^住院医保登记^kongjian-PC^^^^^^2018/3/21 11:28:32：请在医保字典维护-->字典类型：AdmReasonDrToCenterNo中维护 社保机构代码！14")
/// w ##class(web.INSUMsgInfo).insert("^demo^192.168.1.104^00:25:11:E7:B0:A1^^^^^278431^^^2018-04-17^09:35:56^InsuASLogin^PC201804111636^^^^^^2018/4/17 9:35:34：读卡服务错误：读卡错误,错误号:50   错误信息:错误信息:解析XML出错,错误原因:[Error on line 1 of document  : The value of attribute "kh" associated with an element type "null" must not contain the '<' character. Nested exception: The value of attribute "kh" associated with an element type "null" must not contain the '<' character.]联网查询经办机构失败!")
ClassMethod insert(InString) As %String
{
	;s InString="^dzcs^^^1^^^^278431^^^^^门诊发票打印^^^^^^^入参=<?xml version='1.0' enco        ding='gbk'?><envelope><header><authen><data organ=''5251''/><data user=''2018710298''/><data service=''100051''/><data sequence=''909D6EC8D90041AB85BE1DE9C617BB6E''/><data timestamp=''20190426155455214''/><data print=''1''/></authen></header><body><logic name=''bill''><data pjhm=''15023461''/><data pjlx=''006001003''/><data pjzch=''闽财(2017)票字第40号''/><data jsh=''24625''/><data mzh=''7577''/><      data mzlsh=''7577''/><data bxhm='' ''/><data ybhm='' ''/><data ickzt='' ''/><data sybxhm='' ''/><data jzrxm=''王宗庆''/><data ks=''耳鼻喉头颈外科门诊''/><data z            hye=''0.00''/><data kpkh='' ''/><data sfy=''许晓君''/><data kpsj=''2019042618052   9''/><data xyf=''0.00''/><data zchy=''0.00''/><data zcy=''0.00''/><data jcf=''0.00''/><data zlf=''0.00''/><data fsf=''0.00''/><data ssf=''0.00''/><data hyf=''0.00''/><data syf=''0.00''/><data sxf=''0.00''/><data zcf=''0.00''/><data gcc=''0.00''/><data qt=''0.00''/><data jsf=''0.00''/><data cwf=''0.00''/><data hlf=''0.00''/><data jhcf=''0.00''/><data jcf=''1700''/><data grylzhzf='' ''/><data xj='' ''/><data zz='' ''/><data/><data jmfy='' ''/><data gszf='' ''/><data jkzhzfe='' ''/><data jkzhye='' ''/><data cjjjzf='' ''/><data cjzhye='' ''/><data bcyljz='' ''/><data/><data ytk='' ''/><data tczf='' ''/><data qzzf=''1700''/><data gjzhzf='' ''/><data fzkz='' ''/><data fylb=''自费''/><data wsclf='' ''/><data/><data/><  data gwybz='' ''/><data bjjjzf='' ''/><data/><data wtdk='' ''/><data grzf='' ''/><data ylzf='' ''/><data cfdx='' ''/><data fybfy='' ''/><data xjhj='' ''/><data hj=''1700''/><data yjjye='' ''/><data fkfs=''支付''/><data ghrq='' ''/><data ghf  ='' ''/><data ghcs='' ''/><dataset name=''mzsfzypjmx''><row sl=''1'' xmid=''10073'' xmdm=''021020000120'' xmmc=''场强大于等于1.5T磁共振平扫'' dj=''850.00'' je='           '850.00''></row><row sl=''1'' xmid=''10073'' xmdm=''021020000120'' xmmc=''场强大   于等于1.5T磁共振平扫'' dj=''850.00'' je=''850.00''></row></dataset></logic></bod        y></envelope>'"
	s ^temp("MsgInfoInsert1223")=InString
	i InString="" q 0
	s rowid=$p(InString,"^",1)	  
	s:rowid="" obj=##class(User.INSUMsgInfo).%New()
	s:rowid'="" obj=##class(User.INSUMsgInfo).%OpenId(rowid)
    s obj.INMSGUserCode=$p(InString,"^",2) ; 收费员工号
    s obj.INMSGIPAdress=$p(InString,"^",3)	; IP地址
    s obj.INMSGIPMAC=$p(InString,"^",4)
    s obj.INMSGRegNo=$p(InString,"^",5)
    s obj.INMSGInsuNo=$p(InString,"^",6)
    s obj.INMSGAdmDr=$p(InString,"^",7)
    s obj.INMSGInvPrtDr=$p(InString,"^",8)
    s obj.INMSGPBDr=$p(InString,"^",9)
    if obj.INMSGRegNo="" d
    .set obj.INMSGRegNo=..GetPAPMINoByINVOrBillOrAdm(obj.INMSGAdmDr,obj.INMSGInvPrtDr,obj.INMSGPBDr)
    s obj.INMSGDate=+$h
    s obj.INMSGTime=$p($h,",",2)
    s:$p(InString,"^",12)'="" obj.INMSGCliDate=##class(websys.Conversions).DateHtmlToLogical($p(InString,"^",12))
    s:$p(InString,"^",13)'="" obj.INMSGCliTime=##class(websys.Conversions).TimeHtmlToLogical($p(InString,"^",13))
    s obj.INMSGYWLX=$p(InString,"^",14)
    s obj.INMSGCliName=$P(InString,"^",15)
    s obj.INMSGSolveFlag=$P(InString,"^",16)	
    s obj.INMSGSolveUser=$p(InString,"^",17)
    s:$p(InString,"^",18)'="" obj.INMSGSolveDate=##class(websys.Conversions).DateHtmlToLogical($p(InString,"^",18))
    s:$p(InString,"^",19)'="" obj.INMSGSolveTime=##class(websys.Conversions).TimeHtmlToLogical($p(InString,"^",19))
    s obj.INMSGResolvent=$P(InString,"^",20)
    s obj.INMSGMsg=$e($P(InString,"^",21),1,150)
    s obj.INMSGProductLine=$P(InString,"^",22) // 2020-6-19 产品线
    s obj.INMSGHospDr=$P(InString,"^",23) // 2020-6-19 院区
    //VB.Net 调用 和其他接口调动区别
    i obj.INMSGProductLine="VBNETLog" d
    .s obj.INMSGBusinessId=$P(InString,"^",25) // 业务ID
    .s obj.INMSGParamType=$P(InString,"^",26) // 参数类型
    e  d
    .s obj.INMSGBusinessId=$P(InString,"^",24) // 业务ID
    .s obj.INMSGParamType=$P(InString,"^",25) // 参数类型
    s err=obj.%Save()
    
    if $$$ISERR(err){
		Quit "-100^"_$SYSTEM.Status.GetErrorText(err)
	}else{

		;s ^DHCINMSG(obj.%Id(),"ALL")=$P(InString,"^",21) ;保存全部错误信息 20180417
		s ^DHCINMSG(obj.%Id(),"ALL")=$zcvt($SYSTEM.Encryption.Base64Decode($P($g(InString),"^",21)),"I","UTF8") ;保存全部错误信息 upt 20221223 HanZH	
		b ;zxc
		i obj.INMSGProductLine ="VBNETLog" d
		.s ^DHCINMSG(obj.%Id(),"ALL","INPUT")=$zcvt($SYSTEM.Encryption.Base64Decode($P($g(InString),"^",24)),"I","UTF8") ;保存全部入参信息 20210116
		Quit obj.%Id()
	}
}

/// Creator: tangzf
/// CreateDate: 2018-03-11
/// Descript: 更新 表 User.INSUMsgInfo
/// Input:		MsgInfoDr: 	User.INSUMsgInfo.RowId
/// 				InString : 入参串 ^ 分割的字符串 
/// 					^ 第1位 解决办法  若为空 ；^ 第2位 解决标记  ；如果第一位传空 则只更新解决标记字段  否则 更新 解决问题像关信息
/// Output: 
/// Return: 返回值 小于 0 为失败 =-100^错误描述  ; 大于0为成功值为 User.INSUMsgInfo.RowId
/// DeBug: 
/// w ##class(web.INSUMsgInfo).update()
ClassMethod update(MsgInfoDr, InString) As %String
{
	s ^CacheTempTang=$LB(MsgInfoDr, InString)
	Quit:MsgInfoDr=""
	s obj=##class(User.INSUMsgInfo).%OpenId(MsgInfoDr)
	if $P(InString,"^",1)'="" {
    	s obj.INMSGResolvent=$P(InString,"^",1)
    	s obj.INMSGSolveUser=$g(%session.Data("LOGON.USERNAME"))
    	s obj.INMSGSolveDate=+$H
    	s obj.INMSGSolveTime=$P($h,",",2)
    	s obj.INMSGSolveFlag="Y"	
	}
	else{
		s obj.INMSGSolveFlag=$P(InString,"^",2)	
	}
	s id=obj.%Id()
	s err=obj.%Save()
	d obj.%Close()
    if $$$ISERR(err){
		Quit "-100^"_$SYSTEM.Status.GetErrorText(err)
	}else
	{
		Quit obj.%Id()
	}
}

/// Creator: tangzf
/// CreateDate: 2018-03-11
/// Descript: 删除 表 User.INSUMsgInfo 中记录
/// Input:		MsgInfoDr: 	User.INSUMsgInfo.RowId
/// Output: 
/// Return: 返回值 =SQLCODE 不为0为失败  
/// DeBug: 
/// w ##class(web.INSUMsgInfo).MsgInfoDr
ClassMethod delete(MsgInfoDr) As %String
{
	&sql(DELETE FROM SQLUser.INSU_MSGInfo WHERE  INMSG_Rowid=:MsgInfoDr)
	Quit SQLCODE
}

/// Creator: tangzf
/// CreateDate: 2018-03-14
/// Descript: 查询医保日志信息
/// Input:		UserCode : 	操作员[工号]
/// 			StrIp : 	客户端IP地址
/// 			IPMAC : 	客户端MAC地址
/// 			RegNo : 	患者登记号
/// 			InsuNo : 	患者医保号 INSUAdmInfo.INSUId
/// 			AdmDr : 	就诊号
/// 			InvPrtDr : 	发票RowID
/// 			PBDr : 	账单号
/// 			StartDate : 	开始日期
/// 			EndDate : 	结束日期
/// 			DateFlag : ”true“  按照日期查询等多条件查询  否则为单条件查询（仅一个条件生效） 优先级按照入参顺序
/// 			SolveFlag : 	”Y“ 已解决
/// 			YWLX : 	医保业务类型 （INSUIPDivide,INSUOPDivide,INSUIPReg）
/// 			HospId : 	院区 
/// 			ParamProductLine : 	产品线 
/// 			ExpStr :ErrKey日志信息关键字|ParamType参数类型I入参O出参 2021-6-16
/// Output: 见下 query Data
/// Return: 
/// DeBug: 
/// d ##class(%ResultSet).RunQuery("web.INSUMsgInfo","GetINMSGInfo","","","","","","","","","2018-05-18","2018-05-18","true","","")
Query GetINMSGInfo(UserCode = "", StrIp As %String = "", IPMAC = "", RegNo = "", InsuNo = "", AdmDr = "", InvPrtDr = "", PBDr = "", StartDate = "", EndDate = "", DateFlag = "", SolveFlag = "", YWLX As %String = "", HospId, ParamProductLine, ExpStr) As websys.Query(ROWSPEC = "MsgInfoDr:%String,OutUserCode:%String, OutIPAdress:%String, OutIPMAC:%String, OutRegNo:%String, OutInsuNo:%String, OutAdmDr:%String, OutInvPrtDr:%String, OutPBDr:%String, OutDate:%String ,OutTime:%String,OutCliDate:%String,OutCliTime:%String,OutYWLX:%String,OutCliName:%String,OutMsg:%String,OutSolveFlag:%String,OutSolveUser:%String,OutSolveDate:%String,OutSolveTime:%String,OutResolvent:%String,OutPaName:%String,ProductLine,BusinessId,TParamType") [ SqlProc ]
{
}

ClassMethod GetINMSGInfoExecute(ByRef qHandle As %Binary, UserCode = "", StrIp As %String = "", IPMAC = "", RegNo = "", InsuNo = "", AdmDr = "", InvPrtDr = "", PBDr = "", StartDate = "", EndDate = "", DateFlag = "", SolveFlag = "", YWLX As %String = "", HospId, ParamProductLine, ExpStr) As %Status
{
	set repid=$I(^CacheTemp)
	if $g(ind)="" Set ind=1
	set qHandle=$lb(0,repid,0)
	s ^CacheTemp("GetINMSGInfo")=$LB(UserCode, StrIp, IPMAC, RegNo, InsuNo , AdmDr, InvPrtDr, PBDr, StartDate, EndDate, DateFlag, SolveFlag , YWLX , HospId, ParamProductLine,ExpStr)
	s ErrKey=$p(ExpStr,"|",1)
	s ParamType=$p(ExpStr,"|",2)
	;入参初始化
	d iniInStr 
	;日期多条件查询
	if (StartDate'="")&&(DateFlag="true")  d
	.for date=StartDate:1:EndDate  d
	..set MsgInfoDr=""
	..for  set MsgInfoDr=$O(^DHCINMSGi(0,"Date",date,MsgInfoDr),-1) Quit:MsgInfoDr=""  d
	...set MsgInfoStr=^DHCINMSG(MsgInfoDr)
	...Quit:($P(MsgInfoStr,"^",15)'=SolveFlag)&&(SolveFlag="Y")
	...Quit:($P(MsgInfoStr,"^",15)="Y")&&(SolveFlag="N")
	...Quit:(UserCode'="")&&($P(MsgInfoStr,"^",1)'=UserCode)
	...Quit:(StrIp'="")&&($P(MsgInfoStr,"^",2)'=StrIp)
	...Quit:(IPMAC'="")&&($P(MsgInfoStr,"^",3)'=IPMAC)
	...Quit:(RegNo'="")&&($P(MsgInfoStr,"^",4)'=RegNo)
	...Quit:(InsuNo'="")&&($P(MsgInfoStr,"^",5)'=InsuNo)
	...Quit:(AdmDr'="")&&($P(MsgInfoStr,"^",6)'=AdmDr)
	...Quit:(InvPrtDr'="")&&($P(MsgInfoStr,"^",7)'=InvPrtDr)
	...Quit:(PBDr'="")&&($P(MsgInfoStr,"^",8)'=PBDr)
	...Quit:(YWLX'="")&&($P(MsgInfoStr,"^",13)'=YWLX)
	...Quit:(ParamProductLine'="")&&($P(MsgInfoStr,"^",21)'=ParamProductLine)
	...Quit:(ErrKey'="")&&($P(MsgInfoStr,"^",20)'[ErrKey)
	...Quit:(ParamType'="")&&($P(MsgInfoStr,"^",24)'=ParamType)
	...d BuildDataMsg
	;单条件查询
	else  d
	.for  set MsgInfoDr=$O(^DHCINMSGi(0,Type,ValPara,MsgInfoDr),-1) Quit:MsgInfoDr=""  d
	..set MsgInfoStr=^DHCINMSG(MsgInfoDr)
	..Quit:($P(MsgInfoStr,"^",15)'=SolveFlag)&&(SolveFlag="Y")
	..Quit:($P(MsgInfoStr,"^",15)="Y")&&(SolveFlag="N")
	..d BuildDataMsg		
	Quit $$$OK	 
BuildDataMsg
	set HospDr=$P(MsgInfoStr,"^",22)
	Quit:HospDr'=HospId
	set OutUserCode=$P(MsgInfoStr,"^",1)
	set OutIPAdress=$P(MsgInfoStr,"^",2)
	set OutIPMAC=$P(MsgInfoStr,"^",3)
	set OutRegNo=$P(MsgInfoStr,"^",4)
	set OutInsuNo=$P(MsgInfoStr,"^",5)
	set OutAdmDr=$P(MsgInfoStr,"^",6)
	set OutInvPrtDr=$P(MsgInfoStr,"^",7)
	set OutPBDr=$P(MsgInfoStr,"^",8)
	set OutDate=##class(websys.Conversions).DateLogicalToHtml($P(MsgInfoStr,"^",9)) 
	set OutTime=$Zt($P(MsgInfoStr,"^",10),3)
	set OutCliDate=##class(websys.Conversions).DateLogicalToHtml($P(MsgInfoStr,"^",11)) 
	set OutCliTime=$case($P(MsgInfoStr,"^",12),"":"",:$Zt($P(MsgInfoStr,"^",12),3))
	set OutYWLX=$P(MsgInfoStr,"^",13)
	set OutCliName=$P(MsgInfoStr,"^",14)
	set OutSolveFlag=$case($P(MsgInfoStr,"^",15),"Y":"已解决",:"未解决")
	set OutSolveUser=$P(MsgInfoStr,"^",16)
	set OutSolveDate=$P(MsgInfoStr,"^",17)
	set OutSolveTime=$P(MsgInfoStr,"^",18)
	set:OutSolveDate'="" OutSolveDate=##class(websys.Conversions).DateLogicalToHtml(OutSolveDate)
	set:OutSolveTime'="" OutSolveTime=$ZT(OutSolveTime,3)
	set OutResolvent=$P(MsgInfoStr,"^",19)
	;set OutMsg=$P(MsgInfoStr,"^",20)
	set OutMsg=$G(^DHCINMSG(MsgInfoDr,"ALL")) ;upt 20221223 HanZH
	set PAPMIOutStr=##class(web.DHCINSUPatInfo).GetPatInfoByPatNO(OutRegNo,HospId)
	set PAPMInfo=$P(PAPMIOutStr,"!",2)
	set OutPaName=$P(PAPMInfo,"^",3)
	set ProductLine=$P(MsgInfoStr,"^",21)
	;set ProductLine=##class(web.INSUDicDataCom).GetDicByCodeAndInd("ProductLine",ProductLine,4,"")
	set ProductLine=##class(web.INSUDicDataCom).GetDicByCodeAndInd("ProductLine",ProductLine,4,HospId) ;upt 20221209
	set BusinessId=$P(MsgInfoStr,"^",23)
	set TParamType=$P(MsgInfoStr,"^",24)
	// OutUserCode:%String, OutIPAdress:%String, OutIPMAC:%String, OutRegNo:%String, OutInsuNo:%String, OutAdmDr:%String, OutInvPrtDr:%String, OutPBDr:%String, OutDate:%String	,OutTime:%String,OutCliDate:%String,OutCliTime:%String,OutYWLX:%String,OutCliName:%String,OutMsg:%String			
    //			1.rowid	2.操作员工号	3.IP地址	4.MAC地址 5.登记号 6.医保号   7.就诊号 8.发票rowid 9.账单号 10.插表日期 11   12.客户端错误发生日期 14.业务类型 15      16.详细信息 17.解决标记 18         19处理日期    20         21处理办法   22 患者姓名         
    s data=$lb(MsgInfoDr,OutUserCode, OutIPAdress, OutIPMAC, OutRegNo, OutInsuNo, OutAdmDr, OutInvPrtDr, OutPBDr, OutDate,OutTime,OutCliDate,OutCliTime,OutYWLX,OutCliName,OutMsg,OutSolveFlag,OutSolveUser,OutSolveDate,OutSolveTime,OutResolvent,OutPaName,ProductLine,BusinessId,TParamType)
    s ^CacheTemp(repid,ind)=data
    s ind=ind+1
    quit
iniInStr
	set (MsgInfoDr,Type,ValPara)=""
	set:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	set:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	set:SolveFlag="true" SolveFlag="Y"
	set:SolveFlag="false" SolveFlag="N"
	//查询方式 ；单条件查询时 通过 设置 ValPara Type 使用对应索引查询
	if UserCode'="" d
	.set ValPara=UserCode,Type="UserCode"
	else  if StrIp'=""  d
	.set ValPara=StrIp,Type="IPAdress"
	else  if IPMAC'=""  d
	.set ValPara=IPMAC,Type="IPMAC"
	else  if RegNo'=""  d
	.set ValPara=RegNo,Type="RegNo"
	else  if InsuNo'=""  d
	.set ValPara=InsuNo,Type="InsuNo"
	else  if AdmDr'=""  d
	.set ValPara=AdmDr,Type="Adm"
	else  if InvPrtDr'=""  d
	.set ValPara=InvPrtDr, Type="InvPrtDr"
	else  if PBDr'=""  d
	.set ValPara=PBDr,Type="PBDr"
	else  if YWLX'=""  d
	.set ValPara=YWLX,Type="YWLX"
	else  if ParamProductLine'=""  d
	.set ValPara=ParamProductLine,Type="ProductLine"
	
	Quit
}

/// Creator: tangzf
/// CreateDate: 2018-03-14
/// Descript: 通过就就诊号或者发票Dr或者账单号获取登记号
/// Input:		Adm : 	就诊号
/// 			INVDr : 发票rowid
/// 			Bill : 	账单号
/// Output: 
/// Return: PAPMINo 患者登记号
/// DeBug: 
///  ##class(web.INSUMsgInfo).GetPAPMINoByINVOrBillOrAdm("202486","","")
ClassMethod GetPAPMINoByINVOrBillOrAdm(Adm, INVDr, Bill) As %String
{
	set PAPMINo=""
	Quit:(Adm="")&(INVDr="")&(Bill="") ""
	if Adm'="" d
	.set PAPMIDr=$P($G(^PAADM(Adm)),"^",1)
	.set PAPMINo=$p($G(^PAPER(PAPMIDr,"PAT",1)),"^",1)
	else  if Bill'="" d
	.;Update By YangSX 20180425 传入账单号时应该从账单表中取就诊dr
	.set AdmDr=$P($G(^DHCPB(Bill)),"^",1)
	.b ;Bill
	.;set AdmDr=$P($G(^PAPMI(PAPMIDr,"ALL")),"^",1)
	.set PAPMIDr=$P($G(^PAADM(AdmDr)),"^",1)
	.set PAPMINo=$p($G(^PAPER(PAPMIDr,"PAT",1)),"^",1)
	else  if INVDr'=""  d
	.s NewINVDr=INVDr
	.s PEFlag=$e(INVDr,1,1)
	.i PEFlag="P" d ;体检发票Dr
	..s NewINVDr=$E(INVDr,2,$l(INVDr))
	..;s PAPMIDr=$P($G(^DHCPEINVPRT(NewINVDr)),"^",5)
	..;s PBRowid=$P($G(^DHCPEINVPRT(NewINVDr)),"^",3)
	..s PrtAdmDr=$P($G(^DHCPEINVPRT(NewINVDr)),"^",2)
	..s PAPMIDr=$P(^PAADM(PrtAdmDr),"^",1)
	.e  i PEFlag="Y" d ;集中打印进程号
	..s JustThread=$E(INVDr,2,$l(INVDr)) 
    ..s AdmReasonId=""
	..s AdmReasonId=$o(^DHCTMPACCColPRT("IP",JustThread,"")) 
	..s myIdx=""
	..s:AdmReasonId'="" myIdx=$o(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId,""))
	..s tmpPrtRowID=""
	..s:myIdx'="" tmpPrtRowID=$o(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId,myIdx,"PrtRowID",""))
	..s NewINVDr=tmpPrtRowID
	..s PAPMIDr=""
	..s:NewINVDr'="" PAPMIDr=$P($G(^DHCINVPRT(NewINVDr)),"^",15)
	..s:PAPMIDr'="" PAPMINo=$p($G(^PAPER(PAPMIDr,"PAT",1)),"^",1)
	.e  d
	..set PAPMIDr=$P($G(^DHCINVPRT(NewINVDr)),"^",15)
	.;set PAPMIDr=$P($G(^DHCINVPRT(INVDr)),"^",15)
	.set PAPMINo=$p($G(^PAPER(PAPMIDr,"PAT",1)),"^",1)
	Quit PAPMINo
}

/// Creator: tangzf
/// CreateDate: 2018-03-14
/// Descript: 通过医保结算表RowId获取就诊号,发票Dr
/// Input:		INDIVDr : 	INSUDivide.RowId
/// Output: 就诊号	^ 发票Rowid
/// Return: ADMDr_"^"_INVDr
/// DeBug: 
///  w ##class(web.INSUMsgInfo).GetAdmDrAndInvDrByDivDr("202486")
ClassMethod GetAdmDrAndInvDrByDivDr(INDIVDr) As %String
{
	Quit:INDIVDr="" "^"
	Quit:'$d(^DHCINDIV(INDIVDr)) "^"
	Quit:$P(^DHCINDIV(INDIVDr),"^",5)'="I" "^"
	set ADMDr=$P(^DHCINDIV(INDIVDr),"^",1)
	set INVDr=$P(^DHCINDIV(INDIVDr),"^",4)
	set OutStr=ADMDr_"^"_INVDr
	Quit OutStr
}

/// Creator: tangzf
/// CreateDate: 2018-03-14
/// Descript: 返回医保日志表中的错误信息对应的GLOBAL
/// Input:		RowId : INSUMsgInfo.RowId
/// Output: 
/// Return: ^DHCINMSG(RowId,"ALL") 错误信息全部字符串
/// DeBug: 
///  w ##class(web.INSUMsgInfo).GetMsgAllInfoByRowId("202486")
ClassMethod GetMsgAllInfoByRowId(RowId) As %String
{
	Quit:RowId="" ""
	Quit:'$D(^DHCINMSG(RowId,"ALL")) ""
	set rtn=$G(^DHCINMSG(RowId,"ALL"))
	set rtn=rtn_"	INPUT:"_$G(^DHCINMSG(RowId,"ALL","INPUT"))
	Quit rtn
}

/// Creator: tangzf
/// CreateDate: 2020-02-15
/// Descript: 新增医保日志信息
/// Table : User.INSUMsgInfo.cls
/// Input:		JsonStr : json串
/// 	INMSGUserCode 操作员【工号】
/// 	INMSGIPAdress 客户端IP 
/// 	MAC MAC
/// 	INMSGRegNo 登记号
/// 	INMSGInsuNo 医保号
/// 	INMSGAdmDr 就诊号
/// 	INMSGInvPrtDr 发票Dr
/// 	INMSGPBDr 账单
/// 	INMSGDate 插入日期(插入记录日期) +$h 格式
/// 	INMSGTime 插入时间(插入时间) $p($h,",",2) 格式
/// 	INMSGCliDate 客户端日期(发生错误日期) +$h 格式
/// 	INMSGC1iTime 客户端日期(发生错误日期) $p($h,",",2) 格式
/// 	INMSGYWLX 业务类型 (医保字典配置INSUMsgYWlX ) (*必填)
/// 	INMSGC1iName 客户端名称
/// 	INMSGSolveFlag 解决标记 Y已处理
/// 	INMSGSolveUser 解决人
/// 	INMSGSolveDate 解决日期 +$h 格式
/// 	INMSGSolveTime 解决时间 $p($h,",",2) 格式
/// 	INMSGResolvent 解决办法
/// 	INMSGMsg	错误信息 只截取前150位存表，全部信息存储到GLOBAL
/// 	INMSGProductLine	产品线  (*必填)
/// 	INMSGHospDr	院区  (*必填)
/// 	INMSGBusinessId 业务ID
/// 
/// InputType : 入参格式 json串：json ;; 或者数组：array
/// Output: 
/// Return: 0 表示 成功 非0表示失败
/// DeBug:  w ##class(web.INSUMsgInfo).AddMsgInfoByJson("","json")
ClassMethod AddMsgInfoByJson(JsonStr, Type As %String = "json")
{
	s $zt="AddMsgInfoByJsonErr"
	/*	
	
	// 保存日志 2021-4-9 tangzf start
	s obj=##class(%ArrayOfDataTypes).%New()
	s UserCode=$p($g(^SSU("SSUSR",guser)),"^",2)
	d obj.SetAt(UserCode,"INMSGUserCode") ; 收费员工号
    d obj.SetAt(INMSGUserCode,"INMSGIPAdress")	; IP地址
    d obj.SetAt(INMSGUserCode,"MAC")
    d obj.SetAt(INMSGUserCode,"INMSGRegNo")
    d obj.SetAt(INMSGUserCode,"INMSGInsuNo")
    d obj.SetAt(INMSGUserCode,"INMSGAdmDr")
    d obj.SetAt(INMSGUserCode,"INMSGInvPrtDr")
    d obj.SetAt(INMSGUserCode,"INMSGPBDr")
    d obj.SetAt(INMSGUserCode,"INMSGDate")
    d obj.SetAt(INMSGUserCode,"INMSGTime")
    d obj.SetAt(INMSGUserCode,"INMSGCliDate")
    d obj.SetAt(INMSGUserCode,"INMSGC1iTime")
    d obj.SetAt(INMSGUserCode,"INMSGYWLX")
    d obj.SetAt(INMSGUserCode,"INMSGC1iName")
    d obj.SetAt(INMSGUserCode,"INMSGSolveFlag")	
    d obj.SetAt(INMSGUserCode,"INMSGSolveUser")
    d obj.SetAt(INMSGUserCode,"INMSGSolveDate")
    d obj.SetAt(INMSGUserCode,"INMSGSolveTime")
    d obj.SetAt(INMSGUserCode,"INMSGResolvent")
    d obj.SetAt(INMSGUserCode,"INMSGMsg")
    d obj.SetAt(INMSGUserCode,"INMSGProductLine") // 2020-6-19 产品线
    d obj.SetAt(INMSGUserCode,"INMSGHospDr") // 2020-6-19 院区
    d obj.SetAt(INMSGUserCode,"INMSGBusinessId") // 2020-6-19 院区
	d ##class(INSU.COM.Tools).Log(obj,"array")
    */
	set rtn=0
	if Type="json"  d
	.s obj=##class(INSU.Utils.COM.Object).FromJSON(JsonStr)
	else  if Type="array"  d
	.s obj=JsonStr
	quit:obj="" "0"
	k PLIST
	s PLIST(2)=obj.GetAt("INMSGUserCode") ; 收费员工号
    s PLIST(3)=obj.GetAt("INMSGIPAdress")	; IP地址
    s PLIST(4)=obj.GetAt("MAC")
    s PLIST(5)=obj.GetAt("INMSGRegNo")
    s PLIST(6)=obj.GetAt("INMSGInsuNo")
    s PLIST(7)=obj.GetAt("INMSGAdmDr")
    s PLIST(8)=obj.GetAt("INMSGInvPrtDr")
    s PLIST(9)=obj.GetAt("INMSGPBDr")
    s PLIST(10)=obj.GetAt("INMSGDate")
    if PLIST(5)="" d
    .set PLIST(5)=..GetPAPMINoByINVOrBillOrAdm(PLIST(7),PLIST(8),PLIST(9))
    s PLIST(11)=obj.GetAt("INMSGTime")
    s PLIST(12)=obj.GetAt("INMSGCliDate")
    s PLIST(13)=obj.GetAt("INMSGC1iTime")
    s PLIST(14)=obj.GetAt("INMSGYWLX")
    s PLIST(15)=obj.GetAt("INMSGC1iName")
    s PLIST(16)=obj.GetAt("INMSGSolveFlag")	
    s PLIST(17)=obj.GetAt("INMSGSolveUser")
    s PLIST(18)=obj.GetAt("INMSGSolveDate")
    s PLIST(19)=obj.GetAt("INMSGSolveTime")
    s PLIST(20)=obj.GetAt("INMSGResolvent")
    s PLIST(21)=$e(obj.GetAt("INMSGMsg"),1,150)
    s PLIST(22)=obj.GetAt("INMSGProductLine") // 2020-6-19 产品线
    s PLIST(23)=obj.GetAt("INMSGHospDr") // 2020-6-19 院区
    s PLIST(24)=obj.GetAt("INMSGBusinessId") // 2020-6-19 院区
    s PLIST(25)=obj.GetAt("INMSGParamType") // 入参出参类型
	if PLIST(22)="" do
	.set rtn="-1^INMSGProductLine(产品线)不能为空"
	if PLIST(14)="" do
	.set rtn="-2^INMSGYWLX(业务类型)不能为空"
	if PLIST(23)="" do
	.set rtn="-3^院区不能为空"
	
	quit:+rtn'=0 rtn
	;;&sql(insert into SQLUser.INSU_MsgInfo values PLIST())
	&sql(insert into SQLUser.INSU_MsgInfo set INMSG_UserCode=:PLIST(2), INMSG_IPAdress=:PLIST(3), INMSG_IPMAC=:PLIST(4), INMSG_RegNo=:PLIST(5), INMSG_InsuNo=:PLIST(6),
	 INMSG_Adm_Dr=:PLIST(7), INMSG_InvPrt_Dr=:PLIST(8), INMSG_PB_Dr=:PLIST(9), INMSG_Date=:PLIST(10), INMSG_Time=:PLIST(11), 
	 INMSG_CliDate=:PLIST(12), INMSG_CliTime=:PLIST(13), INMSG_YWLX=:PLIST(14), INMSG_CliName=:PLIST(15), INMSG_SolveFlag=:PLIST(16), INMSG_SolveUser=:PLIST(17), INMSG_SolveDate=:PLIST(18),
	 INMSG_SolveTime=:PLIST(19), INMSG_Resolvent=:PLIST(20), INMSG_Msg=:PLIST(21), INMSG_ProductLine=:PLIST(22), INMSG_HospDr=:PLIST(23), INMSG_BusinessId=:PLIST(24), INMSG_ParamType=:PLIST(25)
	) 
	s:+SQLCODE=0 ^DHCINMSG($g(%ROWID),"ALL")=obj.GetAt("INMSGMsg") ;保存全部错误信息 20180417
	quit SQLCODE
AddMsgInfoByJsonErr
	s $zt=""
	s ^CacheTemp("AddMsgInfoByJsonErr",+$h,$p($h,",",2))=JsonStr
	q 0
}

}
