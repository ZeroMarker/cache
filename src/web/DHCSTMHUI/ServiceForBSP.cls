Import sqluser

/// Descript:	同东华BSP(基础平台)之间的接口程序
/// Creator:	lxt
/// CreateDate:	2021-02-04
Class web.DHCSTMHUI.ServiceForBSP Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	根据医嘱id获取高值台账信息
/// Creator:	lxt
/// CreateDate:	2021-02-04
/// Input:		医嘱id
/// Output:		台账信息（操作类型代码、操作人、操作时间、处理号、位置信息）
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ServiceForBSP","QueryHVTransByOeori","86||31")
Query QueryHVTransByOeori(Oeori As %String) As Query(ROWSPEC = "Type,OperUser,OperDate,OperTime,OperNo,OperOrg") [ SqlProc ]
{
}

ClassMethod QueryHVTransByOeoriExecute(ByRef qHandle As %Binary, Oeori As %String) As %Status
{
	n (qHandle,Oeori)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s Hvm=""
	f  s Hvm=$O(^DHCHVMORI(0,"OEORI",Oeori,Hvm)) q:Hvm=""  d
	.s BarCode=$p(^DHCHVMORI(Hvm,1),"^",24)
	.q:BarCode=""
	.s Dhcit=$o(^DHCIT(0,"LABEL",BarCode,0))
	.s:Dhcit="" Dhcit=$o(^DHCIT(0,"ORIGINALCODE",BarCode,0))
	.q:Dhcit=""
	.s Date=""
	.f  s Date=$o(^DHCITD(0,"DATE",Date)) q:Date=""  d
	..s chl=""
	..f  s chl=$o(^DHCITD(0,"DATE",Date,Dhcit,chl)) q:chl=""  d
	...s RowId=Dhcit_"||"_chl
	...s Pointer=$p(^DHCITD(Dhcit,"I",chl),"^",1)
	...s Type=$p(^DHCITD(Dhcit,"I",chl),"^",2)
	...s OperType=$s(Type="SG":"G",Type="ST":"T",Type="SK":"K",Type="SR":"R",Type="SP":"P",Type="SY":"Y",1:Type)
	...s OperDate=$p(^DHCITD(Dhcit,"I",chl),"^",3)
	...s:OperDate'="" OperDate=..DL2H(OperDate)
	...s OperTime=$p(^DHCITD(Dhcit,"I",chl),"^",4)
	...s:OperTime'="" OperTime=..TL2H(OperTime)
	...s OperUser=$p(^DHCITD(Dhcit,"I",chl),"^",5)
	...s:OperUser'="" OperUser=$p($g(^SSU("SSUSR",OperUser)),"^",2)
	...s OperNoInfo=##class(web.DHCSTMHUI.DHCItmTrack).GetOperNo(OperType,Pointer)
	...s OperNo=$p(OperNoInfo,"^",1)
	...s OperOrg=$p(OperNoInfo,"^",2)	;业务机构信息(科室或患者)
	...d OutPutRowHVTrans
	...s DhcitDA=0
	...f  s DhcitDA=$o(^DHCITD(0,"DHCITD",RowId,DhcitDA)) q:DhcitDA=""  d
	....s dhcitdaInfo=^DHCITD("IA",DhcitDA)
	....s Pointer=$p(dhcitdaInfo,"^",1)
	....s Type=$p(dhcitdaInfo,"^",2)
	....s OperType=$s(Type="SG":"G",Type="ST":"T",Type="SK":"K",Type="SR":"R",Type="SP":"P",Type="SY":"Y",1:Type)
	....s OperDate=$p(dhcitdaInfo,"^",3)
	....s OperTime=$p(dhcitdaInfo,"^",4)
	....s OperUser=$p(dhcitdaInfo,"^",5)
	....s:OperDate'="" OperDate=..DL2H(OperDate)
	....s:OperTime'="" OperTime=..TL2H(OperTime)
	....s:OperUser'="" OperUser=$p($g(^SSU("SSUSR",OperUser)),"^",2)
	....q:'$d(^DHCINTR(0,"TypePointer",OperType,Pointer))
	....s OperNoInfo=##class(web.DHCSTMHUI.DHCItmTrack).GetOperNo(OperType,Pointer)
	....s OperNo=$p(OperNoInfo,"^",1)
	....s OperOrg=$p(OperNoInfo,"^",2)
	....d OutPutRowHVTrans
	...i (OperType="G")||(OperType="R") d
	....d GetPayTrans(OperType,Pointer)
	
	Quit $$$OK

OutPutRowHVTrans
	//i Type="G" s Type="入库"
	//e  i Type="R" s Type="退货"
	//e  i Type="T" s Type="转移出库"
	//e  i Type="K" s Type="转移接收"
	//e  i (Type="P")||(MType="MP") s Type="住院医嘱"
	//e  i (Type="Y")||(MType="MY") s Type="住院医嘱取消"
	//e  i Type="A" s Type="库存调整"
	//e  i Type="D" s Type="库存报损"
	//e  i (Type="F")||(MType="MF") s Type="门诊医嘱"
	//e  i (Type="H")||(MType="MH") s Type="门诊医嘱取消"
	////e  i Type="RD" s Type="请求"
	////e  i Type="PD" s Type="采购"
	////e  i Type="POD" s Type="订单"
	//e  i Type="SG" s Type="补录入库"
	//e  i Type="ST" s Type="补录出库"
	//e  i Type="SK" s Type="补录出库-接收"
	//e  i Type="SR" s Type="补录入库-退货"
	//e  i Type="SP" s Type="补录医嘱消减"
	//e  i Type="GPay" s Type="入库付款"
	//e  i Type="RPay" s Type="退货付款"
	s Data=$lb(Type,OperUser,OperDate,OperTime,OperNo,OperOrg)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
	
	
GetPayTrans(OperType,Pointer)
	s Type=OperType_"Pay"
	s PayId=""
	f  s PayId=$o(^DHCPAY(0,"TYPEGR",OperType,Pointer,PayId)) q:PayId=""  d
	.s Ack1=$p(^DHCPAY(PayId),"^",8)
	.q:Ack1'="Y"
	.s Ack2=$p(^DHCPAY(PayId),"^",9)
	.q:Ack2'="Y"
	.s Ack3=$p(^DHCPAY(PayId),"^",22)
	.q:Ack3'="Y"
	.s OperNo=$p(^DHCPAY(PayId),"^",1)
	.s OperOrg=$p(^DHCPAY(PayId),"^",2)
	.s:OperOrg'="" OperOrg=$p($g(^APC("APCVM",OperOrg)),"^",3)
	.s OperTime=""
	.s Ack1Date=$p(^DHCPAY(PayId),"^",13)
	.s Ack1User=$p(^DHCPAY(PayId),"^",15)
	.s Ack2Date=$p(^DHCPAY(PayId),"^",14)
	.s Ack2User=$p(^DHCPAY(PayId),"^",16)
	.s Ack3Date=$p(^DHCPAY(PayId),"^",23)
	.s Ack3User=$p(^DHCPAY(PayId),"^",24)
	.i (Ack1Date>=Ack2Date)&&(Ack1Date>=Ack3Date) d
	..s OperDate=Ack1Date
	..s OperUser=Ack1User
	.e  i (Ack2Date>=Ack1Date)&&(Ack2Date>=Ack3Date) d
	..s OperDate=Ack2Date
	..s OperUser=Ack2User
	.e  d
	..s OperDate=Ack3Date
	..s OperUser=Ack3User
	.s:OperDate'="" OperDate=..DL2H(OperDate)
	.s:OperUser'="" OperUser=$p($g(^SSU("SSUSR",OperUser)),"^",2)
	.d OutPutRowHVTrans
}

/// Descript:	根据医嘱id获取高值批次信息
/// Creator:	lxt
/// CreateDate:	2021-02-04
/// Input:		医嘱id
/// Output:		批次信息（批次id、库存项代码、库存项名称、条码号、批号、效期、单位、批次供应商、批次生产厂家）
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ServiceForBSP","QueryHVBatByOeori","86||31")
Query QueryHVBatByOeori(Oeori As %String) As Query(ROWSPEC = "Incib,InciCode,InciDesc,BarCode,BatNo,ExpDate,BUom,Vendor,Manf") [ SqlProc ]
{
}

ClassMethod QueryHVBatByOeoriExecute(ByRef qHandle As %Binary, Oeori As %String) As %Status
{
	n (qHandle,Oeori)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s Hvm=""
	f  s Hvm=$O(^DHCHVMORI(0,"OEORI",Oeori,Hvm)) q:Hvm=""  d
	.s BarCode=$p(^DHCHVMORI(Hvm,1),"^",24)
	.q:BarCode=""
	.s MoIngri=$p(^DHCHVMORI(Hvm,1),"^",36)
	.s Dhcit=$o(^DHCIT(0,"LABEL",BarCode,0))
	.s:Dhcit="" Dhcit=$o(^DHCIT(0,"ORIGINALCODE",BarCode,0))
	.q:Dhcit=""
	.s Incib=""
	.i MoIngri'="" d
	..s ingr=$p(MoIngri,"||",1)
	..s ingrchl=$p(MoIngri,"||",2)
	..s Inclb=$p(^DHCINGR(ingr,"GRI",ingrchl),"^",1)
	..s inc=$p(Inclb,"||",1)
	..s il=$p(Inclb,"||",2)
	..s lb=$p(Inclb,"||",3)
	..s Incib=$p(^INCI(inc,"IL",il,"LB",lb),"^",1)
	.s:Incib="" Incib=$p(^DHCIT(Dhcit),"^",7)
	.q:Incib=""
	.s InciId=$p(Incib,"||",1)
	.s BatCh=$p(Incib,"||",2)
	.s InciCode=$p(^INCI(InciId,1),"^",1)
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s BUom=$p(^INCI(InciId,1),"^",10)
	.s:BUom'="" BUom=$p($g(^CT("UOM",BUom)),"^",2)
	.s BatNo=$p(^INCI(InciId,"IB",BatCh),"^",1)
	.s ExpDate=$p(^INCI(InciId,"IB",BatCh),"^",2)
	.s:ExpDate'="" ExpDate=..DL2H(ExpDate)
	.s dhcIncib=$o(^DHCINCIB(0,"INCIB",Incib,0))
	.s Vendor=$p(^DHCINCIB(dhcIncib),"^",8)
	.s:Vendor'="" Vendor=$p($g(^APC("APCVM",Vendor)),"^",3)
	.s Manf=$p(^DHCINCIB(dhcIncib),"^",7)
	.s:Manf'="" Manf=$p(^PHMNF(Manf),"^",2)
	.d OutPutRowHVBat
	Quit $$$OK

OutPutRowHVBat
	s Data=$lb(Incib,InciCode,InciDesc,BarCode,BatNo,ExpDate,BUom,Vendor,Manf)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
