Class web.INSUCollating Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 查询一段日期内门诊医保和计费的数据
/// 入参：StDate:开始日期, EndDate:结束日期，日期格式：yyyy-MM-dd
/// 返回值：条数&InsuPID。其中InsuPID为临时global的节点
/// 			如果有数据，就存在^CacheTemp("Detail",InsuPID)中,
/// 			数据格式：insu_divide表的rowid^交易流水号^个人编号^医保卡号^医保结算日期^医保结算时间^收费日期^操作人员^医保险种^参保地^医保类别^就诊类型^医疗类别^中途结算标志^总费用^个人支付额^基金支付额^个人账户支付额 ^统筹支付^大病支付^公务员补助^民政救助(专项救助)^离休统筹^单位补充医疗^公务员大病医疗补充部分^保健对象支付^医院垫付(单病种垫付)^HIS总费用与医保返回数据的误差^医保内金额^医保外金额^个人自付一^个人自付二^自费金额^是否特殊病种^单病种编码^单病种定额^单病种名称^限价标志^限价类别^限价病种^定额差
/// w ##class(web.INSUCollating).GetDivDrbyDate("2015-01-01","2015-01-01")
ClassMethod GetDivDrbyDate(StDate, EndDate)
{
	//入参格式yyyy-mm-dd
	n (StDate, EndDate)
	s InsuPID=$I(^CacheTemp("Detail")) 
    s n=0
	k ^CacheTemp("Detail",InsuPID)
	s:StDate["/" StDate=$zdh(StDate,4)
	s:EndDate["/" EndDate=$zdh(EndDate,4)
	s:StDate["-" StDate=$zdh(StDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s INPAYRowid="" 
	f IDate=StDate:1:EndDate  d
	.s INPAYRowid="" 	
	.f  s INPAYRowid=$o(^DHCINDIV("0","IDate",IDate,INPAYRowid)) q:INPAYRowid=""  d
	..s admid=$p(^DHCINDIV(INPAYRowid),"^",1)
	..q:+admid=0
	..s PAADMType=$p(^PAADM(admid),"^",2)
	..q:PAADMType="I"
	..s insudivstr=^DHCINDIV(INPAYRowid)
	..s INPAYFlag=$p(insudivstr,"^",5)
	..s divDr=+$p(insudivstr,"^",6)
	..;q:INPAYFlag'="I"
    ..q:INPAYFlag="D"
	..s invdr=$p(insudivstr,"^",4)
	..;s InsuSum=$p(insudivstr,"^",52)	//??
	..s InsuTotamt=$j($p(insudivstr,"^",7),0,2)	//总金额
	..s idate=$p(insudivstr,"^",16)	//
	..s itime=$p(insudivstr,"^",17)	//
	..s userid=$p(insudivstr,"^",21)	//
	..s invprtdr=$p(insudivstr,"^",4)	//
	..;s invamt=+$p(^DHCINVPRT(invprtdr),"^",1)
	..;s invinsu=+$p(^DHCINVPRT(invprtdr),"^",31)
	..;s jjzfe=$p(insudivstr,"^",19)		//基金支付额(现金之外的所有报销金额)
	..;s zhzfe=$p(insudivstr,"^",28)		//账户支付额
	..s grzfe=$j(+$p(insudivstr,"^",15),0,2)		//个人支付额(一般指现金)
	..;s insupay1=$p(insudivstr,"^",31)		//统筹支付
	..;s insupay2=$p(insudivstr,"^",32)		//大病支付
	..;s insupay3=$p(insudivstr,"^",33)		//公务员补助支付
	..;s InsuPay10=$p(insudivstr,"^",50)		//误差
	..s regflag=$p(insudivstr,"^",36)		//结算或挂号标志
	..s Adminfodr=$p(insudivstr,"^",2)
	..s (InsuType,INSUID,INSUCard,AdmSeriNo)=""
	..i Adminfodr'="" d 
	...;s InsuType=$p(^DHCINADM(Adminfodr),"^",18)
	...;s INSUID=$p(^DHCINADM(Adminfodr),"^",2)
	...;s INSUCard=$p(^DHCINADM(Adminfodr),"^",3)
	...;s AdmSeriNo=$p(^DHCINADM(Adminfodr),"^",10)
	..s BillFlag=""
	..;暂时不校验支付方式表数据
	..;s BillFlag=..CheckInsuInvData(invdr,+admid,+InsuSum,+INPAYRowid)
	..;q:+BillFlag=0
    ..;s BillFlag=##Class(web.name).Classname(INPAYRowid) 
	..s jjzfe=InsuTotamt-grzfe
    ..s Expstr=InsuTotamt_"^"_jjzfe_"^"_INPAYFlag
    ..s insudividID=INPAYRowid
    ..s:divDr>0 insudividID=divDr,INPAYFlag="B"
    ..i regflag="R" d
    ...s tmpadminfodr=$p(^DHCINADM(Adminfodr),"^",50)
    ...s:tmpadminfodr'="" Adminfodr=tmpadminfodr
    ...s BillFlag=##class(web.DHCBillInsuReconciliation).CheckInvInsu(Adminfodr,Expstr)
    ..e  s BillFlag=##class(web.DHCBillInsuReconciliation).CheckInvInsu(insudividID,Expstr)
    ..;q:$d(^DHCINVPRT(0,"INSDIV",INPAYRowid))
    ..;s insinv=$o(^DHCINVPRT(0,"INSDIV",INPAYRowid,""))
    ..;i +insinv=0   b ;;ins
    ..;q:+insinv=0
    ..//此处需调用计费组函数，该函数入参为insu_divide表rowid，当DHC_PatientBill结算正常返回一个标志,(暂时默认正常返回0，不正常返回-1)
    ..;q:BillFlag>="0"  //此处的标志为计费n组返回的DHC_PatientBill结算正常的标志
	..q:+BillFlag>=0
	..;b ;insu
	..q:(BillFlag=-104)&&((INPAYFlag="B")||(INPAYFlag="S"))
	..s n=n+1
	..;w !,n_"^"_BillFlag_"^"_insudividID_"^"_Expstr
	..;医保结算表ID，就诊号，结算日期 结算时间，操作员，发票ID，his端发票总额，his医保支付总额，医保总费用，医保支付额，错误原因
	..s ^CacheTemp("Detail",InsuPID,n)=insudividID_"^"_admid_"^"_idate_"^"_itime_"^"_userid_"^"_invprtdr_"^"_invamt_"^"_invinsu_"^"_InsuTotamt_"^"_jjzfe_"^"_BillFlag
   q n_"&"_InsuPID
}

}
