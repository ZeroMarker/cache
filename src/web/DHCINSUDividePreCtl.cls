Import SQLUser

/// 医保结算信息操作类
Class web.DHCINSUDividePreCtl Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 67;

/// 保存医保结算返回信息
/// w ##class(web.DHCINSUDividePreCtl).InsertDivInfo(""^46^17^197930^^D^^345^OP00004232^0^^0^C12345678^0^0^24^^^12345678^0^0^1^2010-10-25^^1824-00-^23^1^zdl^123^^OP00004232^23^34^34^12^0^IP^^^本次医保外自费金^本次乙类自费金额^本次特检自付金额^本次特检统筹支付金额^本次特治自付金额^本次特治统筹支付金额^本次起付标准自付金额^0^0^0^0^-289.4^本次分段自付金额^本次超过统筹封顶线个人自付金额^次符合基本医疗保险累计金额^本次符合基本医疗保险费用金额^历次进入统筹医疗费用累计金额^本次进入统筹费用金额^235^34^甲类费用^乙类费用^本次帐户应支付^本年住院次数^本次进入大病部分^本次超过大病封顶线^本年历次大病统筹支付累计^住院结算类别^超过统筹封顶线标志^^^^"")
ClassMethod InsertDivInfo(InString As %String) As %String
{
	n (InString)
	q:InString="" -100
    s DivId=+$p(InString,"^",1)
    i DivId=0 d
    .s InsertDivInfo=$$InsertDivide^DHCINSUDividePre(InString)
    e  d
    .i $d(^DHCINDIVPre(DivId))=0 d    
    ..s InsertDivInfo=$$InsertDivide^DHCINSUDividePre(InString)
    .e  d
    ..s InsertDivInfo=$$UpdateDivide^DHCINSUDividePre(InString)
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
	q:$d(^DHCINDIVPre("0","DHCPB",BillRowid))=0 -100
	s Id=$O(^DHCINDIVPre("0","DHCPB",BillRowid,""),-1)
	s DivStr=..GetDivById(Id)
	s GetByBill="1!"_DivStr
	;s ^ZDL("1210")=GetByBill
	q GetByBill
}

ClassMethod GetByAdm(AdmRowid As %String) As %String
{
}

ClassMethod GetByInvprt(Invprt As %String) As %String
{
	n (Invprt)
	q:Invprt="" -1
	q:$d(^DHCINDIVPre("0","DHCInvPrt",Invprt))=0 -100
	s Id=$O(^DHCINDIVPre("0","DHCInvPrt",Invprt,""),-1)
	s DivStr=..GetDivById(Id)
	s GetByInvprt="1!"_DivStr
	q GetByInvprt
}

ClassMethod GetDivById(Id As %String) As %String
{
	s GetDivById=$$GetDivideInfo^DHCINSUDividePre(Id)
	q GetDivById
}

/// 获取预结算信息 2007 11 12
/// 入参：帐单Rowid：BillRowid
/// 出参:先用"!"分割   $p(  ,"!",1)=1 表示有结算数据
///     然后用"^"分割   1:INSU_Divide表ID  2:医保号 3:医保个人账户支付  4:医保统筹基金支付 5:医保救助支付 
ClassMethod GetDivByBillforJF(BillRowid As %String) As %String
{
	n (BillRowid)
	q:BillRowid="" -1
	q:$d(^DHCINDIVPre("0","DHCPB",BillRowid))=0 -100
	s Id=$O(^DHCINDIVPre("0","DHCPB",BillRowid,""),-1)
	s DivStr=..GetDivById(Id)
	s DivStr=$p(DivStr,"^",1)_"^"_$p(DivStr,"^",19)_"^"_$p(DivStr,"^",29)_"^"_$p(DivStr,"^",38)_"^"_$p(DivStr,"^",41)
	s GetByBill="1!"_DivStr
	q GetByBill
}

}
