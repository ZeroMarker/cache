Class web.DHCPE.CashierInterface.Main Extends %Persistent
{

ClassMethod GetInfo(InvID)
{
	;w ##class(web.DHCPE.CashierInterface.Main).GetInfo(4608)
	s InvNo=$P(^DHCPEINVPRT(InvID),"^",1)
	i InvNo="" d
	.s XML=..GetInvalidInfo(InvID)
	e  d
	.s XML=..GetBillInfo(InvID)
	q XML
}

/// 需要对方提供key  version  systype 票据类型 医疗机构类型 单位开票点编码
/// 疑问;单位开票点用户编码 ;用户密码 是his中的还是对方的
/// 收费发票信息
ClassMethod GetBillInfo(InvID)
{
	;w ##class(web.DHCPE.CashierInterface.Main).GetBillInfo(245)
	s obj=##class(web.DHCPE.CashierInterface.Entity.webbill).%New()
	s OPObj=##class(web.InvoiceUpload.DHCBillInvoiceUpload).%New()
	s obj.name="InvoiceBill"  ;方法名称
	s obj.ivcnode=OPObj.#Ivcnode ;单位开票点编码
	s User=$P(^DHCPEINVPRT(InvID),"^",10)
	s UserCode=$p($g(^SSU("SSUSR",User)),"^",1)
	s obj.nodeuser=UserCode ;单位开票点用户编码
	s obj.userpwd="admin" ;用户密码
	s obj.key=OPObj.#key ;单位校验KEY
	s obj.version=OPObj.#version ;接口版本
	s obj.systype=OPObj.#Systype ;系统类型
	s paramObj=##class(web.DHCPE.CashierInterface.Entity.param).%New()
	s paramObj.param2="1" ;是否打印
	s paramObj.param3=OPObj.#MZPJLX ;票据类型
	s paramObj.param4=OPObj.#PBH ;票别号(默认为国财)
	s InvNo=$P(^DHCPEINVPRT(InvID),"^",1)
	s InvNoLength=$L(InvNo)
	s InvNo=$E(InvNo,InvNoLength-9,InvNoLength)
	s paramObj.param5=InvNo ;1323252616 ;票据号(以纸制票据号以准)
	s InvDate=$P(^DHCPEINVPRT(InvID),"^",11)
	s InvDate=$ZD(InvDate,8)
	s InvTime=$P(^DHCPEINVPRT(InvID),"^",12)
	s InvTime=$ZT(InvTime,1)
	s InvTime=##class(web.DHCPE.Public.Setting).Replace(InvTime,":","")
	s InvDate=InvDate_InvTime_"000"
	s paramObj.param6=InvDate ;开票时间（格式：yyyyMMddHHmmssSSS）
	s paramObj.param7="" ;作废日期（格式：yyyyMMdd）
	s paramObj.param8="" ;作废操作人
	s paramObj.param9="" ;备注(可为空)
	s billObj=##class(web.DHCPE.CashierInterface.Entity.bill).%New()
	s headObj=##class(web.DHCPE.CashierInterface.Entity.head).%New()
	s InvName=$G(^DHCPEDataEx("InvName",InvID))
	s SexDesc=""
	i InvName="" d
	.s Adm=$P(^DHCPEINVPRT(InvID),"^",2)
	.s patid=$p($g(^PAADM(Adm)),"^",1)
	.s InvName=$p($g(^PAPER(patid,"ALL")),"^",1)
	.s sex=$p($g(^PAPER(patid,"ALL")),"^",7)
	.i sex'="" s SexDesc=$p($g(^CT("SEX",sex)),"^",2)
	s headObj.InvName=InvName 
	s headObj.InvLSH=$G(^DHCPEINVPRT(InvID,"PEInvNum")) ;流水号
	s headObj.InvType=OPObj.#HosCode ;医疗机构类型 
	s headObj.InvSex=SexDesc ;性别
	s headObj.InvInsuType="自费" ;医保类型
	s headObj.InvInsuCardNo="" ;社会保障卡号
	s headObj.InvInsuPay="0" ;基金支付
	s headObj.InvSelfCardPay="0" ;个人账户支付
	s headObj.InvSelfPay=$P(^DHCPEINVPRT(InvID),"^",7) ;个人支付金额
	s billObj.head=headObj
	s InvListInfo=..GetInvListInfo(InvID)
	s c=$C(2)
	s Length=$L(InvListInfo,c)
	f i=1:1:Length d
	.s OneInfo=$P(InvListInfo,c,i)
	.s chargeObj=##class(web.DHCPE.CashierInterface.Entity.charge).%New()
	.s chargeObj.amt=$P(OneInfo,"^",3)
	.s CatID=$P(OneInfo,"^",1)
	.s CatCode=$p($G(^DHCTarC("TOCNEW",CatID)),"^",1)
	.s chargeObj.chargecode=CatCode
	.s chargeObj.standard=chargeObj.amt
	.s chargeObj.cnt=1
	.d billObj.chargeitems.Insert(chargeObj)
	d paramObj.param1.Insert(billObj)
	s obj.params=paramObj
	s rtn=obj.XMLExportToString(.XML,"webbill")
	
	;s XML=##class(web.DHCPE.Public.Setting).Replace(XML,"<param1>","<param1><bill>")
	;s XML=##class(web.DHCPE.Public.Setting).Replace(XML,"</param1>","</bill></param1>")
	
	q XML
}

ClassMethod GetInvListInfo(invid)
{
	;w ##class(web.DHCPE.CashierInterface.Main).GetInvListInfo(245)
	s Job=invid_"!"_$J
	k ^TempDHCPEListInfo(Job)
	s PreItemID=""
  	f  s PreItemID=$O(^DHCPEOEITEM(invid,"OEITEM",PreItemID)) q:PreItemID=""  d //,"TARITEM",itmsub)
	.s TARITEMSub=""
	.f  s TARITEMSub=$O(^DHCPEOEITEM(invid,"OEITEM",PreItemID,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	..s Info=$G(^DHCPEOEITEM(invid,"OEITEM",PreItemID,"TARITEM",TARITEMSub))
	..s TARITEMID=$P(Info,"^",1)
	..s TOCInfo=##class(web.DHCPE.Cashier).GetTarOC(TARITEMID,"N")
	..s OneAmount=+$P(Info,"^",4)
	..i $D(^DHCPEOEITEM(invid,"OEITEM",PreItemID,"SetsName")) d
	...s Desc="丙 "_$G(^DHCPEOEITEM(invid,"OEITEM",PreItemID,"SetsName"))
	...s Uom=""
	...s Qty=1
	..e  d
	...s YBCode=""
	...s Desc=YBCode_" "_$p($g(^DHCTARI(TARITEMID)),"^",2)
	...s Uom=""
	...s Qty=$g(^DHCPEDataEx("DHCPEPreIOrdItem","Qty",PreItemID))
	..//s Sort=$I(^TempDHCPEListInfo(Job))
	..s ^TempDHCPEListInfo(Job,TOCInfo)=$g(^TempDHCPEListInfo(Job,TOCInfo))+OneAmount
	s ItemInfos=""
	s c=$C(2)
	s TOCInfo=""
	f  s TOCInfo=$O(^TempDHCPEListInfo(Job,TOCInfo)) q:TOCInfo=""  d
	.s Amt=$G(^TempDHCPEListInfo(Job,TOCInfo))
	.s OneInfo=TOCInfo_"^"_Amt
	.i ItemInfos="" d
	..s ItemInfos=OneInfo
	.e  d
	..s ItemInfos=ItemInfos_c_OneInfo
	k ^TempDHCPEListInfo(Job)
	q ItemInfos
}

ClassMethod GetInvalidInfo(InvID)
{
	;w ##class(web.DHCPE.CashierInterface.Main).GetInvalidInfo(245)
	s obj=##class(web.DHCPE.CashierInterface.Entity.webbill).%New()
	s OPObj=##class(web.InvoiceUpload.DHCBillInvoiceUpload).%New()
	s obj.name="InvalidBill"  ;方法名称
	s obj.ivcnode=OPObj.#Ivcnode ;单位开票点编码
	s User=$P(^DHCPEINVPRT(InvID),"^",10)
	s UserCode=$p($g(^SSU("SSUSR",User)),"^",1)
	s obj.nodeuser=UserCode ;单位开票点用户编码
	s obj.userpwd="admin" ;用户密码
	s obj.key=OPObj.#key ;单位校验KEY
	s obj.version=OPObj.#version ;接口版本
	s obj.systype=OPObj.#Systype ;系统类型
	s paramObj=##class(web.DHCPE.CashierInterface.Entity.param).%New()
	s paramObj.param2=OPObj.#MZPJLX ;票据类型
	s paramObj.param3=OPObj.#PBH ;票别号
	s invno=""
	s initinv=$P(^DHCPEINVPRT(InvID),"^",9)
	i initinv'="" d
	.s invno=$P($G(^DHCPEINVPRT(initinv)),"^",1)
	.;b ;invno
	.s InvNoLength=$L(invno)
	.s invno=$E(invno,InvNoLength-9,InvNoLength)
	s paramObj.param10=invno  ;$P(^DHCPEINVPRT(InvID),"^",1) ;票据号
	s obj.params=paramObj
	s rtn=obj.XMLExportToString(.XML,"webbill")
	q XML
}

ClassMethod DealResult(XML, MethodName, InvID)
{
	s obj=##class(web.DHCPE.CashierInterface.Entity.result).%New()
	d obj.XMLNodeDeserialize(.obj,"result", XML)
	s Flag=obj.status
	s ^DHCPEDataEx("SendInvoiceInfo",MethodName,Flag)=XML
	q Flag
}

Storage Default
{
<Data name="MainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.CashierInterB0B.MainD</DataLocation>
<DefaultData>MainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.CashierInterB0B.MainD</IdLocation>
<IndexLocation>^web.DHCPE.CashierInterB0B.MainI</IndexLocation>
<StreamLocation>^web.DHCPE.CashierInterB0B.MainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
