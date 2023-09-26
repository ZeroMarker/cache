Import SQLUser

Class web.INSUDivideCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 39;

/// 保存医保结算返回信息
ClassMethod InsertDivInfo(InString As %String)
{
	n (InString)
	q:InString="" 100
	s obj=##class(User.INSUDivide).%New()
	s obj.AdmDr=$p(InString,"^",1)    ///指向PAADM的指针User.PAAdm
	s obj.AdmInfoDr=$p(InString,"^",2)        ///指针INSUAdmInfoUser.INSUAdmInfo
	s obj.DHCpblDr=$p(InString,"^",3)       ///指向DHC_PatientBill的指针User.DHCPatientBill
	s obj.Flag=$p(InString,"^",4)   ///结算状态（insuhispaidstrike）
	s obj.bcbxf0=+$p(InString,"^",5)     ///总费用
	s obj.djlsh0=$p(InString,"^",6)     ///单据流水号
	s obj.bckbcs=$p(InString,"^",7)     ///本次看病次数(即视同住院次数)
	s obj.bqbm00=$p(InString,"^",8)     ///病种编码
	s obj.brnl00=+$p(InString,"^",9)     ///年龄
	s obj.cardno=$p(InString,"^",10)     ///卡号
	s obj.cfxms0=+$p(InString,"^",11)     ///收费项目数
	s obj.crbcts=+$p(InString,"^",12)     ///传染病床天数
	s obj.grzfe0=+$p(InString,"^",13)     ///个人现金支付额
	s obj.id0000=$p(InString,"^",14)     ///医保号
	s obj.jjzfe0=+$p(InString,"^",15)     ///基金支付额
	s obj.ptbcts=+$p(InString,"^",16)     ///普通病床天数
	s obj.sfrq00=$p(InString,"^",17)     ///收费日期
	s obj.sfrxm0=$p(InString,"^",18)     ///收费人姓名
	s obj.sfsj00=$p(InString,"^",19)     ///收费时间
	s obj.sftsbz=$p(InString,"^",20)     ///是否特殊病种
	s obj.xbie00=$p(InString,"^",21)     ///性别
	s obj.xming0=$p(InString,"^",22)     ///姓名
	s obj.zhzfe0=+$p(InString,"^",23)     ///帐户支付额
	s obj.zyksmc=$p(InString,"^",24)     ///住院科室名称
	s obj.zylsh0=$p(InString,"^",25)     ///入院登记流水号
    s obj.sUserDr=$p(InString,"^",26)      ///操作员User.SSUser
    s obj.DhcInvPrtDr=$p(InString,"^",27)      ///Dhc_InvPrt的指针
    s obj.INSUDivideDr=$p(InString,"^",28)      ///被冲销的指针
	s obj.iDate=$p($h,",",1)    ///操作日期
	s obj.iTime=$p($h,",",2)    ///操作时间	
	d obj.%Save()
    s id=obj.%Id()
    d obj.%Close()
    q id
}

/// 取医保结算信息
ClassMethod GetDivInfo(DivRowid As %String)
{
	//n (DivRowid)
	q:DivRowid="" 100
	q:$d(^DHCINSUDivideD(DivRowid))=0 100
	s obj=##class(User.INSUDivide).%OpenId(DivRowid)
	s AdmDr=obj.AdmDr                     ///指向PAADM的指针User.PAAdm
    s AdmInfoDr=obj.AdmInfoDr                     ///指针INSUAdmInfoUser.INSUAdmInfo
    s DHCpblDr=obj.DHCpblDr                     ///指向DHC_PatientBill的指针User.DHCPatientBill
    s Flag=obj.Flag                     ///结算状态（insuhispaidstrike）
    s bcbxf0=$FN(+obj.bcbxf0,"",2)                     ///总费用
    s djlsh0=obj.djlsh0                     ///单据流水号
    s bckbcs=obj.bckbcs                     ///本次看病次数(即视同住院次数)
    s bqbm00=obj.bqbm00                     ///病种编码
    s brnl00=obj.brnl00                     ///年龄
    s cardno=obj.cardno                     ///卡号
    s cfxms0=obj.cfxms0                     ///收费项目数
    s crbcts=obj.crbcts                     ///传染病床天数
    s grzfe0=$FN(+obj.grzfe0,"",2)                     ///个人现金支付额
    s id0000=obj.id0000                     ///医保号
    s jjzfe0=$FN(+obj.jjzfe0,"",2)                     ///基金支付额
    s ptbcts=obj.ptbcts                     ///普通病床天数
    s sfrq00=obj.sfrq00                     ///收费日期
    s sfrxm0=obj.sfrxm0                     ///收费人姓名
    s sfsj00=obj.sfsj00                     ///收费时间
    s sftsbz=obj.sftsbz                     ///是否特殊病种
    s xbie00=obj.xbie00                     ///性别
    s xming0=obj.xming0                     ///姓名
    s zhzfe0=$FN(+obj.zhzfe0,"",2)                     ///帐户支付额
    s zyksmc=obj.zyksmc                     ///住院科室名称
    s zylsh0=obj.zylsh0                     ///入院登记流水号
    s sUserDr=obj.sUserDr                     ///操作员User.SSUser
    s DhcInvPrtDr=obj.DhcInvPrtDr                     ///Dhc_InvPrt的指针
    s INSUDivideDr=obj.INSUDivideDr                     ///被冲销的指针
    s iDate=$zd(obj.iDate,3)                     ///操作日期
    s iTime=$zt(obj.iTime)                     ///操作时间	
    d obj.%Close()
    s Info=DivRowid_"^"_AdmDr_"^"_AdmInfoDr_"^"_DHCpblDr_"^"_Flag_"^"_bcbxf0_"^"_djlsh0_"^"_bckbcs_"^"_bqbm00_"^"_brnl00_"^"_cardno_"^"_cfxms0_"^"_crbcts_"^"_grzfe0_"^"_id0000_"^"_jjzfe0_"^"_ptbcts_"^"_sfrq00_"^"_sfrxm0_"^"_sfsj00_"^"_sftsbz_"^"_xbie00_"^"_xming0_"^"_zhzfe0_"^"_zyksmc_"^"_zylsh0_"^"_sUserDr_"^"_DhcInvPrtDr_"^"_INSUDivideDr_"^"_iDate_"^"_iTime
    q Info
}

/// 修改结算信息状态
ClassMethod UpdateDivActive(DivRowid As %String, ActiveFlag As %String, User As %String, InvPrtDr As %String)
{
	n (DivRowid,ActiveFlag,User,InvPrtDr)
	q:DivRowid="" 100
	q:$d(^DHCINSUDivideD(DivRowid))=0 100
	s obj=##class(User.INSUDivide).%OpenId(DivRowid)
	s obj.iDate=$p($h,",",1)    ///操作日期
	s obj.iTime=$p($h,",",2)    ///操作时间	
	s obj.sUserDr=User      ///操作员User.SSUser
	s obj.Flag=ActiveFlag	
	s:InvPrtDr'="" obj.DhcInvPrtDr=InvPrtDr
	d obj.%Save()
    d obj.%Close()
    q 0
}

}
