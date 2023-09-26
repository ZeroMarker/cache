Class BILL.EINV.BL.COM.InvBuyApplyCtl Extends %RegisteredObject
{

/// InputPam --> 申请主要信息(1票据种类^2票据种类名称^3申请数量^4开始号码^5结束号码^6申请人^7安全组^8登陆科室)
ClassMethod SaveApplyBuyData(ByRef InvBuyApplyObj As BILL.EINV.PO.InvBuyApply) As %String
{
	s rtnFlg="0"
	
	s NowDtStr=$h
	s InvBuyApplyObj.UpdateDate=$p(NowDtStr, ",", 1)
	s InvBuyApplyObj.UpdateTime=$p(NowDtStr, ",", 2)

    s sc=InvBuyApplyObj.%Save()
	i ($System.Status.IsError(sc)) {
		s rtnFlg="-1"
	}else{
		s rtnFlg=InvBuyApplyObj.%Id()
	}
    
	q rtnFlg
}

ClassMethod SaveApplyBuyDataBak(InputPam As %String, ApplyCommon As %String, InvBuyApplyObj As BILL.EINV.PO.InvBuyApply) As %String
{
	s rtnFlg="0"
	
	s InvBuyApplyObj.IBATypeCode=$p(InputPam,"^",1)			;票据种类代码
	s InvBuyApplyObj.IBATypeName=$p(InputPam,"^",2)			;票据种类名称
	s InvBuyApplyObj.IBAEBillCount=$p(InputPam,"^",3)		;票据种类数量
	s:InvBuyApplyObj.IBAStartNo="" InvBuyApplyObj.IBAStartNo=$p(InputPam,"^",4)   ;开始号码
	
	s:InvBuyApplyObj.IBAEndNo="" InvBuyApplyObj.IBAEndNo=$p(InputPam,"^",5)       ;结束号码
	
	s InvBuyApplyObj.ApplyCommon=ApplyCommon			    ;票据申请备注
	s InvBuyApplyObj.IBAUsr=$p(InputPam,"^",6)		        ;申请人
	s InvBuyApplyObj.IBAApplyStatus="1"                     ;申请状态  0 待申请 1 已申请 2 申请成功 3 申请失败 9 申请作废

    s sc=InvBuyApplyObj.%Save()
	i ($System.Status.IsError(sc)) {
		s rtnFlg="-1"
	}else{
		s rtnFlg=InvBuyApplyObj.%Id()
	}
    
	q rtnFlg
}

/// 功能：保存电子票据购入数据
/// 修改人：苏惠德
/// 日期：2019-12-10
/// 入参：InputPam ->传入入参信息
///       ExpStr   -->扩展串信息
/// 出参：0成功  其他失败
/// Table：DHC_AMTMAG
/// debug:w ##class(BILL.EINV.BL.COM.InvBuyApplyCtl).SaveAMTMAGData("")
ClassMethod SaveAMTMAGData(InputPam As %String, ByRef EBillBuyObj As BILL.EINV.DTO.COM.EBillBuyInfo) As %String
{
	s PLIST(1)=""
	s PLIST(2)=+$h
	s HospDr=EBillBuyObj.BuyHospital			;院区指针
	//根据发票代码对照票据购入类型
	s EBillCode=EBillBuyObj.BuyBillCode			;票据代码
	s finacloc=	EBillBuyObj.BuyType				;获取票据类型
	
	s PLIST(3)=finacloc						;finac_loc  购入类型
	s PLIST(4)=EBillBuyObj.BuyUsr			;finac_buyer 购入人
	s PLIST(6)=EBillBuyObj.BuyStartNo		;finac_stnum  购入开始号码
	s PLIST(8)=PLIST(6)						;finac_note   购入当前号码
	s PLIST(7)=EBillBuyObj.BuyEndNo			;finac_ednum  购入结束号码
	s PLIST(9)=EBillBuyObj.BuyUsr			;finac_updateusr  购入人
	s PLIST(14)=""							;finac_title  购入字母标识
	s PLIST(14)=$replace(PLIST(14)," ","") ;add by wangjian 2015-03-18 去掉字母中空格
	s PLIST(16)=EBillBuyObj.BuyCount   		;finac_comment1   购入数量
	s PLIST(17)=HospDr						;finac_hospital  院区指针
	s PLIST(18)=EBillBuyObj.BuyBillCode			;finac_code  票据代码
	s PLIST(19)=EBillBuyObj.BuyBillName			;finac_name  票据名称
	
	s cw=..finaccw(PLIST(3),HospDr)			;通过购入类型和院区指针判断使用状态(Y 可用)
	i cw>0 d
	.s PLIST(11)=""							;finac_avail  使用状态
	e  d
	.s PLIST(11)="Y"
	
	s myBegINVNo=PLIST(6)					;购入当前号码
	s myEndINVNo=PLIST(7)					;购入结束号码
	s myINVType=PLIST(3)					;购入类型
	s myPreNoABC=PLIST(14)					;购入字母标识
	// 发票的购入验证
	s myCheckInfo=##class(web.UDHCINVManager).CheckINVBuyInfo(myPreNoABC, myINVType, myBegINVNo, myEndINVNo)
	s myrtn=$p(myCheckInfo,"^",1)
	s myFindFlag=$p(myCheckInfo,"^",2)
	q:(+myrtn) myrtn
	q:(+myFindFlag=1) -505
	
	TSTART
	&sql(INSERT INTO SQLUser.DHC_AMTMAG Values PLIST())
	i SQLCODE=0 d   
	.TCOMMIT
	.s retcode=0
	e  d
	.Trollback
	.s retcode=SQLCODE
	q retcode
}

ClassMethod finaccw(type, HospDr) As %Integer
{
	k P1
	&sql(select count(*) into :count from SQLUser.DHC_AMTMAG where finac_avail='Y' and finac_loc=:type and finac_hospital=:HospDr)
	s P1=count
	q count
}

/// 功能：通过购入申请表id获取表信息
/// 修改人：苏惠德
/// 日期：2019-12-10
/// 入参：IBARowid ->申请表id      
/// 出参：0成功  其他失败
/// Table：BILL_EINV_PO.InvBuyApply
/// debug:w ##class(BILL.EINV.BL.COM.InvBuyApplyCtl).GetBuyApplyInfo("")
ClassMethod GetBuyApplyInfo(IBARowid, ByRef ObjBuyApply As BILL.EINV.DTO.COM.InvBuyApplyCtl) As %String
{
	s RtnFlag="-1"
	s InvBuyApplyObj=##class(BILL.EINV.PO.InvBuyApply).%OpenId(IBARowid)
	i $isObject(ObjBuyApply)=0  Do
	.s ObjBuyApply=##class(BILL.EINV.DTO.COM.InvBuyApplyCtl).%New() 
	s ObjBuyApply.RowId=IBARowid								;申请购入表id
	s ObjBuyApply.IBATypeCode=InvBuyApplyObj.IBATypeCode		;电子票据种类代码
	s ObjBuyApply.IBATypeName=InvBuyApplyObj.IBATypeName		;电子票据种类名称
	s ObjBuyApply.IBATypeCount=InvBuyApplyObj.IBATypeCount		;电子票据种类数量
	i ((ObjBuyApply.IBATypeCode)'="") s RtnFlag="0"
	q RtnFlag
}

/// 功能说明：票据类型下拉框数据获取
/// 修改履历：董科锋 2019 12 16 新做成
/// w ##class(BILL.EINV.BL.COM.InvBuyApplyCtl).GetEInvTypeList()
ClassMethod GetEInvTypeList() As %String
{
	
	s EInvTypeList=""
	s info=""
	
	s EInvTypeDataFrom=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","EInvType_DataFrom", 5)  ;1:从第三方获取  0:获取东华自己的票据类型
	s:EInvTypeDataFrom="" EInvTypeDataFrom="0"  ;默认从东华his中获取
	
	i EInvTypeDataFrom="0" d
	.s status=..GetEInvTypeListCom(.EInvTypeList, .info)     ;东华his 获取票据类型   0代表获取成功
	i EInvTypeDataFrom="1" d
	.s status=..GetEInvTypeListOther(.EInvTypeList, .info)   ;第三发服务获取票据类型 0代表获取成功
	
	s RtnObj=##class(%ArrayOfDataTypes).%New()
	d RtnObj.SetAt(status, "status")
	d RtnObj.SetAt(info, "info")
	d RtnObj.SetAt(EInvTypeList, "EinvTypeArr")
	
	q ##class(ext.util.JsonObject).ObjToJson(RtnObj)
}

/// 功能说明：获取东华his中的票据类型
/// w ##class(BILL.EINV.BL.COM.InvBuyApplyCtl).GetEInvTypeListCom("","")
ClassMethod GetEInvTypeListCom(ByRef EInvTypeList As %ListOfDataTypes, ByRef RtnMsg As %String) As %String
{
	if $isobject(EInvTypeList)=0 {
		s EInvTypeList = ##class(%ListOfDataTypes).%New()
	}
	s ADMCONRowid = ""
	f  s ADMCONRowid=$o(^DHCJFBILLADMREACON(ADMCONRowid)) q:ADMCONRowid=""  d
	.s ADMCONInfo=$g(^DHCJFBILLADMREACON(ADMCONRowid))
	.s EInvType=##class(BILL.EINV.DTO.COM.ComboboxRec).%New()
	.s ADMCONVal=$p(ADMCONInfo,"^",3)
	.q:(ADMCONVal="O")||(ADMCONVal="I")||(ADMCONVal="R")
	.s EInvType.value=ADMCONVal
	.s EInvType.text=$p(ADMCONInfo,"^",2)
	.s:ADMCONVal="EO" EInvType.selected="true"
	.d EInvTypeList.Insert(EInvType)
	;s EInvType1=##class(BILL.EINV.DTO.COM.ComboboxRec).%New()
	;s EInvType1.value="EO"
	;s EInvType1.text="门诊电子票据"
	;s EInvType1.selected="true"
	;d EInvTypeList.Insert(EInvType1)
	
	;s EInvType2=##class(BILL.EINV.DTO.COM.ComboboxRec).%New()
	;s EInvType2.value="EI"
	;s EInvType2.text="住院电子票据"
	;d EInvTypeList.Insert(EInvType2)
	
	q "0"
}

/// 功能说明：第三发服务获取票据类型
/// w ##class(BILL.EINV.BL.COM.InvBuyApplyCtl).GetEInvTypeListOther("","")
ClassMethod GetEInvTypeListOther(ByRef EInvTypeList As %ListOfDataTypes, ByRef RtnMsg As %String) As %String
{
	s RtnFlag="-1"
	if $isobject(EInvTypeList)=0 {
		s EInvTypeList = ##class(%ListOfDataTypes).%New()
	}
	s InputPam=""
	s OutputJsonStr=##class(BILL.EINV.BL.EInvoiceLogic).GetEBillTypeInfo(InputPam, .RtnMsg)
	q:($p(OutputJsonStr,"^",1)'=0) RtnFlag 
	;s rtnInfo="{""result"":""00000"",""information"":""success"",""count"":""1"",""invoicetypelist"":[{""invoice_type_code"":""320101"",""invoice_type_name"":""非税一般缴款书""},{""invoice_type_code"":""320000"",""invoice_type_name"":""北望一般缴款书""}]}"
	s rtnInfo=$p(OutputJsonStr,"^",2)
	s ResultObj=##class(BILL.EINV.DTO.JSA.QueryEBillTypeRes).%New()
	s ResultStream=##class(%GlobalCharacterStream).%New()
	d ResultStream.Write(rtnInfo)
	d ##class(ext.util.JsonObject).JSONStreamToObject(ResultStream,.ResultObj,"")
	i ((ResultObj.invoicetypelist.Size)'=0){
		f i=1:1:ResultObj.invoicetypelist.Size  d
		.s EInvType=##class(BILL.EINV.DTO.COM.ComboboxRec).%New()
		.s EInvType.value=ResultObj.invoicetypelist.GetAt(i)."invoice_type_code"
		.s EInvType.text=ResultObj.invoicetypelist.GetAt(i)."invoice_type_name"
		.d EInvTypeList.Insert(EInvType)
		.s RtnFlag="0"
	}
	
	q RtnFlag
}

/// Description:   查询电子票据申请列表
/// Table：        被访问的表(BILL.EINV.PO.InvBuyApply)
/// Debug:         d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.InvBuyApplyCtl","QueryInvBuyApplyInfo")
Query QueryInvBuyApplyInfo(InputPam As %String) As %Query(ROWSPEC = "ind,ID:%String,IBAUsr:%String,IBABusNo:%String,IBATypeCode:%String,IBATypeName:%String,IBAEBillCount:%String,IBAApplyFlag:%String,IBAResultCode:%String,IBAResultMeg:%String,IBAApplyNo:%String,IBAInvoiceCode:%String,IBAInvoiceName:%String,IBAApplyStatus:%String,IBAApplyCount:%String,IBAApplyList:%String,IBAApplyDate:%String,IBAApplyTime:%String,IBAStartNo:%String,IBAEndNo:%String,IBAStockStatus:%String,StockDate:%String,StockTime:%String,ApplyCommon:%String,UpdateDate:%String,UpdateTime:%String,StockApplyCommon:%String,StockApplyDate:%String,StockApplyTime:%String,StockApplyUsr:%String,RevokeCommon:%String,StockUsr:%String")
{
}

ClassMethod QueryInvBuyApplyInfoExecute(ByRef qHandle As %Binary, InputPam As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    ;s ^TMPQueryInvBuyApplyInfo=$lb(InputPam)
    q:InputPam=""
    s IBAInvoiceCodePam=$p(InputPam,"^",1) ;票据类型
    s IBAApplyStatusPam=$p(InputPam,"^",2) ;申请状态
    s:IBAApplyStatusPam="All" IBAApplyStatusPam=""
    s IBAStockStatusPam=$p(InputPam,"^",3) ;库存状态
    s:IBAStockStatusPam="All" IBAStockStatusPam=""
    s IBAUsrPam=$p(InputPam,"^",4)		   ;申请人
    
    s RowId=0
    f  s RowId=$o(^BILL.EINV.PO.InvBuyApplyD(RowId)) q:RowId=""  d
    .s list=$g(^BILL.EINV.PO.InvBuyApplyD(RowId))
    .s IBAUsr=$lg(list,2)				;申请人
    .q:(IBAUsrPam'="")&&(IBAUsrPam'=IBAUsr)
    .s:IBAUsr'="" IBAUsr=$p($g(^SSU("SSUSR",IBAUsr)),"^",2)
    .s IBABusNo=$lg(list,3)				;申请唯一流水号	
    .s IBATypeCode=$lg(list,4)			;电子票据种类代码
    .q:(IBAInvoiceCodePam'="")&&(IBAInvoiceCodePam'=IBATypeCode)
    .s IBATypeName=$lg(list,5)			;电子票据种类名称
    .;s IBATypeCount=$lg(list,6)		;电子票据种类数量
    .s IBAApplyFlag=$lg(list,7)			;电子票据申请标志
    .s IBAResultCode=$lg(list,8)		;返回申请结果代码
    .s IBAResultMeg=$lg(list,9)			;返回申请结果描述
    .s IBAApplyNo=$lg(list,10)			;申请单号
    .s IBAInvoiceCode=$lg(list,11)		;电子票据代码
    .s IBAInvoiceName=$lg(list,12)		;电子票据名称
    .s IBAApplyStatus=$lg(list,13)		;申请状态
    .q:(IBAApplyStatusPam'="")&&(IBAApplyStatusPam'=IBAApplyStatus)
    .s IBAApplyCount=$lg(list,14)		;返回申请单数量
    .s IBAApplyList=$lg(list,15)		;返回申请单列表
    .s IBAApplyDate=$lg(list,16)		;申请成功日期
    .s:IBAApplyDate'="" IBAApplyDate=$zd(IBAApplyDate,3)
    .s IBAApplyTime=$lg(list,17)		;申请成功时间
    .s:IBAApplyTime'="" IBAApplyTime=$zt(IBAApplyTime,1)
    .s IBAStartNo=$lg(list,18)			;票据开始号码
    .s IBAEndNo=$lg(list,19)			;票据结束号码
    .s IBAStockStatus=$lg(list,20)		;票据库存状态
    .s:IBAStockStatus="" IBAStockStatus="1"
    .q:(IBAStockStatusPam'="")&&(IBAStockStatusPam'=IBAStockStatus)
    .s StockDate=$lg(list,21)			;入库日期
    .s:StockDate'="" StockDate=$zd(StockDate,3)
    .s StockTime=$lg(list,22)			;入库时间
    .s:StockTime'="" StockTime=$zt(StockTime,1)
    .s ApplyCommon=$lg(list,23)			;申请备注
    .s UpdateDate=$lg(list,24)			;最近一次更新日期
    .s:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
    .s UpdateTime=$lg(list,25)			;最近一次更新时间
    .s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
    .s StockApplyCommon=$lg(list,26)	;取消申请备注
    .s StockApplyDate=$lg(list,27)		;取消申请新日期
    .s:StockApplyDate'="" StockApplyDate=$zd(StockApplyDate,3)
    .s StockApplyTime=$lg(list,28)		;取消申请时间
    .s:StockApplyTime'="" StockApplyTime=$zt(StockApplyTime,1)
    .s StockApplyUsr=$lg(list,29)		;取消申请人
    .s:StockApplyUsr'="" StockApplyUsr=$p($g(^SSU("SSUSR",StockApplyUsr)),"^",2)
   	.s RevokeCommon=$lg(list,30)		;申请撤销备注
   	.s IBAEBillCount=$lg(list,31)		;电子票据总数
   	.s StockUsr=$lg(list,32)			;入库人
   	.s:StockUsr'="" StockUsr=$p($g(^SSU("SSUSR",StockUsr)),"^",2)
   	
    .d OutputRow
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(ind,RowId,IBAUsr,IBABusNo,IBATypeCode,IBATypeName,IBAEBillCount,IBAApplyFlag,IBAResultCode,IBAResultMeg,IBAApplyNo,IBAInvoiceCode,IBAInvoiceName,IBAApplyStatus,IBAApplyCount,IBAApplyList,IBAApplyDate,IBAApplyTime,IBAStartNo,IBAEndNo,IBAStockStatus,StockDate,StockTime,ApplyCommon,UpdateDate,UpdateTime,StockApplyCommon,StockApplyDate,StockApplyTime,StockApplyUsr,RevokeCommon,StockUsr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind_1
	q
}

ClassMethod QueryInvBuyApplyInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInvBuyApplyInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryInvBuyApplyInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInvBuyApplyInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 功能说明：票据申请
/// 入参说明：DataInfo    --> 申请主要信息(1票据种类^2票据种类名称^3申请数量^4开始号码^5结束号码^6申请人^7安全组^8登陆科室)
///           ApplyCommon --> 申请备注
/// 修改履历：董科锋 2019 12 18 新做成
/// w ##class(BILL.EINV.BL.COM.InvBuyApplyCtl).InvBuyApply("EO^门诊电子票据^1000^1^1000^1^2^3","dongkf 测试票据申请")
ClassMethod InvBuyApply(DataInfo As %String, ApplyCommon As %String) As %String
{
	s Data=""
	s ErrMsg=""
	
	s ReleaseFlg=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","EInv_Release_Flg", 5)    ;正式环境使用标志 1:正式环境  0:测试环境
	s:ReleaseFlg="" ReleaseFlg="0"
	if (ReleaseFlg="1") {
		s ApplyDr=##class(BILL.EINV.BL.EInvoiceLogic).InvBuyApply(DataInfo, ApplyCommon, .ErrMsg)  ;调用第三方服务 申请购入票据
	}else{
		s ApplyDr=..CreateApplyDataTest(DataInfo, ApplyCommon) ;test method.......................
	}
	if (ApplyDr>0){
		s Data=##class(BILL.EINV.PO.InvBuyApply).%OpenId(ApplyDr)
		s:Data.IBAUsr'="" Data.IBAUsr=$p($g(^SSU("SSUSR",Data.IBAUsr)),"^",2)			;申请人
		s:Data.StockUsr'="" Data.StockUsr=$p($g(^SSU("SSUSR",Data.StockUsr)),"^",2)		;入库人
		s:Data.StockApplyUsr'="" Data.StockApplyUsr=$p($g(^SSU("SSUSR",Data.StockApplyUsr)),"^",2)	;撤销申请人
	}else{
		s:ErrMsg="" ErrMsg="申请失败！"
	}
	
	
	s RtnObj=##class(%ArrayOfDataTypes).%New()
	d RtnObj.SetAt(ApplyDr, "status")
	d RtnObj.SetAt(ErrMsg, "info")
	d RtnObj.SetAt(Data, "ApplyData")
	
	q ##class(ext.util.JsonObject).ObjToJson(RtnObj)
}

/// 测试保存申请记录的方法
/// 入参说明：DataInfo    --> 撤销申请主要信息(1票据种类^2票据种类名称^3申请数量^4开始号码^5结束号码^6申请人^7安全组^8登陆科室)
///           ApplyCommon --> 申请备注
ClassMethod CreateApplyDataTest(DataInfo As %String, ApplyCommon As %String) As %String
{
	s InvBuyApplyObj = ##class(BILL.EINV.PO.InvBuyApply).%New()
	
	q ..SaveApplyBuyDataBak(DataInfo, ApplyCommon, .InvBuyApplyObj)
}

/// 功能说明：票据申请撤销
/// 入参说明：InputPam     --> 撤销申请主要信息(1申请记录Dr^2操作员^3安全组^4登陆科室)
///           RevokeCommon --> 撤销申请备注
/// 修改履历：董科锋 2019 12 18 新做成
/// w ##class(BILL.EINV.BL.COM.InvBuyApplyCtl).InvBuyApplyRevoke("43^^^^^","撤销测试")
ClassMethod InvBuyApplyRevoke(InputPam As %String, RevokeCommon As %String) As %String
{
	s Data=""
	s ErrMsg=""
	
	s ReleaseFlg=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","EInv_Release_Flg", 5)    ;正式环境使用标志 1:正式环境  0:测试环境
	s:ReleaseFlg="" ReleaseFlg="0"
	if (ReleaseFlg="1") {
		s ApplyDr=##class(BILL.EINV.BL.EInvoiceLogic).InvBuyApplyRevoke(InputPam, RevokeCommon, .ErrMsg)  ;调用第三方服务 申请购入票据
	}else{
		s ApplyDr=..CreateApplyRevokeTest(InputPam, RevokeCommon) ;test method.......................
	}
	
	if (ApplyDr>0){
		s Data=##class(BILL.EINV.PO.InvBuyApply).%OpenId(ApplyDr)
		s:Data.IBAUsr'="" Data.IBAUsr=$p($g(^SSU("SSUSR",Data.IBAUsr)),"^",2)			;申请人
		s:Data.StockUsr'="" Data.StockUsr=$p($g(^SSU("SSUSR",Data.StockUsr)),"^",2)		;入库人
		s:Data.StockApplyUsr'="" Data.StockApplyUsr=$p($g(^SSU("SSUSR",Data.StockApplyUsr)),"^",2)	;撤销申请人
	}else{
		s:ErrMsg="" ErrMsg="申请失败！"
	}
	
	
	s RtnObj=##class(%ArrayOfDataTypes).%New()
	d RtnObj.SetAt(ApplyDr, "status")
	d RtnObj.SetAt(ErrMsg, "info")
	d RtnObj.SetAt(Data, "ApplyData")
	
	q ##class(ext.util.JsonObject).ObjToJson(RtnObj)
}

/// 仅测试用
ClassMethod CreateApplyRevokeTest(InputPam As %String, RevokeCommon As %String) As %String
{
	s AppplyDr=$p(InputPam, "^", 1)
	s InvBuyApplyObj = ##class(BILL.EINV.PO.InvBuyApply).%OpenId(AppplyDr)
	s InvBuyApplyObj.IBAApplyStatus="9"  ;申请状态  0 待申请 1 已申请 2 申请成功 3 申请失败 9 申请作废
	s InvBuyApplyObj.RevokeCommon=RevokeCommon   ;撤销备注
	s sc=InvBuyApplyObj.%Save()
	i ($System.Status.IsError(sc)) {
		s AppplyDr="-1"
	}else{
		s AppplyDr=InvBuyApplyObj.%Id()
	}
	
	q AppplyDr
}

/// 功能说明：申请的票据购入票据入库
/// 入参说明：InputPam     --> 入库主要信息(1申请记录Dr^2申请人^3安全组^4登陆科室)
/// 修改履历：董科锋 2019 12 18 新做成
/// w ##class(BILL.EINV.BL.COM.InvBuyApplyCtl).SaveApplyInvResult("43^^^^^")
ClassMethod SaveApplyInvResult(InputPam As %String) As %String
{
	s Data=""
	s ErrMsg=""
	
	s ReleaseFlg=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","EInv_Release_Flg", 5)    ;正式环境使用标志 1:正式环境  0:测试环境
	s:ReleaseFlg="" ReleaseFlg="0"
	if (ReleaseFlg="1") {
		s ApplyDr=##class(BILL.EINV.BL.EInvoiceLogic).SaveApplyInvResult(DataInfo, ApplyCommon, .ErrMsg)  ;调用第三方服务 申请购入票据
	}else{
		s ApplyDr=..CreateSaveApplyInvInfoTest(InputPam) ;test method.......................
	}
	if (ApplyDr>0){
		s Data=##class(BILL.EINV.PO.InvBuyApply).%OpenId(ApplyDr)
		s:Data.IBAUsr'="" Data.IBAUsr=$p($g(^SSU("SSUSR",Data.IBAUsr)),"^",2)			;申请人
		s:Data.StockUsr'="" Data.StockUsr=$p($g(^SSU("SSUSR",Data.StockUsr)),"^",2)		;入库人
		s:Data.StockApplyUsr'="" Data.StockApplyUsr=$p($g(^SSU("SSUSR",Data.StockApplyUsr)),"^",2)	;撤销申请人
	}else{
		s:ErrMsg="" ErrMsg="申请失败！"
	}
	
	
	s RtnObj=##class(%ArrayOfDataTypes).%New()
	d RtnObj.SetAt(ApplyDr, "status")
	d RtnObj.SetAt(ErrMsg, "info")
	d RtnObj.SetAt(Data, "ApplyData")
	
	q ##class(ext.util.JsonObject).ObjToJson(RtnObj)
}

/// 功能说明：查询票据购入申请结果并更新申请记录
/// 入参说明：InputPam     --> 查询记录信息(1申请记录Dr^2申请人^3安全组^4登陆科室)
///           Index        --> 数据在页面上的索引序号
/// 修改履历：董科锋 2019 12 18 新做成
/// w ##class(BILL.EINV.BL.COM.InvBuyApplyCtl).SearchBuyApplyResult("43^^^^^", "3")
ClassMethod SearchBuyApplyResult(InputPam As %String, Index As %String) As %String
{
	
	s Data=""
	s ErrMsg=""
	
	s ReleaseFlg=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","EInv_Release_Flg", 5)    ;正式环境使用标志 1:正式环境  0:测试环境
	s:ReleaseFlg="" ReleaseFlg="0"
	if (ReleaseFlg="1") {
		s ApplyDr=##class(BILL.EINV.BL.EInvoiceLogic).SearchBuyApplyResult(InputPam, .ErrMsg)
	}else{
		s ApplyDr=$p(InputPam, "^", 1) ;test code.......................
	}
	if (ApplyDr>0){
		s Data=##class(BILL.EINV.PO.InvBuyApply).%OpenId(ApplyDr)
		s:Data.IBAUsr'="" Data.IBAUsr=$p($g(^SSU("SSUSR",Data.IBAUsr)),"^",2)			;申请人
		s:Data.StockUsr'="" Data.StockUsr=$p($g(^SSU("SSUSR",Data.StockUsr)),"^",2)		;入库人
		s:Data.StockApplyUsr'="" Data.StockApplyUsr=$p($g(^SSU("SSUSR",Data.StockApplyUsr)),"^",2)	;撤销申请人
		s:ApplyDr="45" Data.IBAApplyStatus="2"       ;test code.......................
	}else{
		s:ErrMsg="" ErrMsg="查询购入申请结果失败！"
	}
	
	
	s RtnObj=##class(%ArrayOfDataTypes).%New()
	d RtnObj.SetAt(ApplyDr, "status")
	d RtnObj.SetAt(ErrMsg, "info")
	d RtnObj.SetAt(Data, "ApplyData")
	d RtnObj.SetAt(Index, "DataIndex")   ;数据在页面上的索引序号
	
	q ##class(ext.util.JsonObject).ObjToJson(RtnObj)
}

/// 功能说明：通过第三方服务查询是否存在待入库的记录
/// 入参说明：InputPam --> 暂时传空
/// 修改履历：董科锋 2019 12 18 新做成
/// w ##class(BILL.EINV.BL.COM.InvBuyApplyCtl).SearchNotStockData("43^^^^^")
ClassMethod SearchNotStockData(InputPam As %String) As %String
{
	s Data=""
	s ErrMsg=""
	

	s ReleaseFlg=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","EInv_Release_Flg", 5)    ;正式环境使用标志 1:正式环境  0:测试环境
	s:ReleaseFlg="" ReleaseFlg="0"
	if (ReleaseFlg="1") {
		/// status  返回值状态 负数代表服务调用失败 0 标识没有待入库的数据 大于0代表有未更新成待入库状态的数据
		s status=##class(BILL.EINV.BL.EInvoiceLogic).SearchNotStockData(InputPam, .ErrMsg)
	}else{
		s status="1"
	}
	
	s RtnObj=##class(%ArrayOfDataTypes).%New()
	d RtnObj.SetAt(status, "status")            ;这个状态为大于0 的时候，需要把页面上 已经申请的记录重新加载下
	d RtnObj.SetAt(ErrMsg, "info")
	
	q ##class(ext.util.JsonObject).ObjToJson(RtnObj)
}

/// 功能说明：根据申请记录的Dr获取最新的记录信息
/// 入参说明：ApplyDataDr --> 申请记录Dr
///           Index       --> 数据在页面上的索引
/// 修改履历：董科锋 2019 12 18 新做成
/// w ##class(BILL.EINV.BL.COM.InvBuyApplyCtl).GetApplyDataByDr("45", 2)
ClassMethod GetApplyDataByDr(ApplyDataDr As %String, Index As %String) As %String
{
	s status="-1"
	s Data=""
	s ErrMsg=""
	
	if (ApplyDataDr'=""){
		if (##class(BILL.EINV.PO.InvBuyApply).%ExistsId(ApplyDataDr)){
			s Data=##class(BILL.EINV.PO.InvBuyApply).%OpenId(ApplyDataDr)
			s:Data.IBAUsr'="" Data.IBAUsr=$p($g(^SSU("SSUSR",Data.IBAUsr)),"^",2)			;申请人
			s:Data.StockUsr'="" Data.StockUsr=$p($g(^SSU("SSUSR",Data.StockUsr)),"^",2)		;入库人
			s:Data.StockApplyUsr'="" Data.StockApplyUsr=$p($g(^SSU("SSUSR",Data.StockApplyUsr)),"^",2)	;撤销申请人
			s status=ApplyDataDr
		}
	}
	if (status="-1") {
		s ErrMsg="数据ID为["_ApplyDataDr_"]申请记录不存在！"
	}
	
	s RtnObj=##class(%ArrayOfDataTypes).%New()
	d RtnObj.SetAt(status, "status")
	d RtnObj.SetAt(ErrMsg, "info")
	d RtnObj.SetAt(Data, "ApplyData")
	d RtnObj.SetAt(Index, "DataIndex")   ;数据在页面上的索引序号
	
	q ##class(ext.util.JsonObject).ObjToJson(RtnObj)
}

/// 测试方法 仅仅测试用
ClassMethod CreateSaveApplyInvInfoTest(InputPam As %String) As %String
{
	s AppplyDr=$p(InputPam, "^", 1)
	s InvBuyApplyObj = ##class(BILL.EINV.PO.InvBuyApply).%OpenId(AppplyDr)
	;s InvBuyApplyObj.IBAApplyStatus="9"  ;申请状态  0 待申请 1 已申请 2 申请成功 3 申请失败 9 申请作废
	s InvBuyApplyObj.IBAStockStatus="2"   ;(1.待入库,2.已入库,9.已撤销)
    s sc=InvBuyApplyObj.%Save()
	i ($System.Status.IsError(sc)) {
		s AppplyDr="-1"
	}else{
		s AppplyDr=InvBuyApplyObj.%Id()
	}
	
	q AppplyDr
}

/// 根据第三方的放回结果 查看我们的申请记录的待入库状态是否已经更新，仅仅更新不一致的记录，有更新的记录 返回具体的更新数目
ClassMethod JudgeEBillStatus(InputPam As %String, ByRef ObjCheckData As BILL.EINV.DTO.COM.CheckData, ByRef ErrMsgStr As %String) As %String
{
	s CountIdx=0			;记录更新次数
	f i=1:1:ObjCheckData.InvBillNoList.Size d
	.s IBAApplyNo=ObjCheckData.InvBillNoList.GetAt(i).applyNo			;申请单号
	
	.//取his表中的电子票据信息
	.s ApplyRowid=$o(^BILL.EINV.PO.InvBuyApplyI("IBAApplyNo",IBAApplyNo,ApplyRowid))   	;根据申请单号获取申请表id
	.s ObjInvBuyApply=##class(BILL.EINV.PO.InvBuyApply).%OpenId(ApplyRowid)				;打开申请表对象
	.s IBAHisApplyNo=ObjInvBuyApply.IBAApplyNo				;原申请表中申请单号
	.s IBAInvoiceCode=ObjInvBuyApply.IBAInvoiceCode			;原申请表中电子票据代码
	.s IBAInvoiceName=ObjInvBuyApply.IBAInvoiceName			;原申请表中电子票据名称
	.s IBAEBillCount=ObjInvBuyApply.IBAEBillCount			;原申请表中电子票据总数
	.s IBAStartNo=ObjInvBuyApply.IBAStartNo					;原申请表中票据开始号码
	.s IBAEndNo=ObjInvBuyApply.IBAEndNo						;原申请表中票据结束号码
	
	.//取接口返回的电子票据信息
	.s LYGInvoiceCode=ObjCheckData.InvBillNoList.GetAt(i).billBatchCode			;第三方电子票据代码
	.s LYGInvoiceName=ObjCheckData.InvBillNoList.GetAt(i).billName				;第三方电子票据名称
	.s LYGEBillCount=ObjCheckData.InvBillNoList.GetAt(i).copyNum				;第三方电子票据总数
	.s LYGInvoiceCode=ObjCheckData.InvBillNoList.GetAt(i).billBatchCode			;第三方电子票据代码
	.s LYGStartNo=ObjCheckData.InvBillNoList.GetAt(i).bgnNo						;第三方票据开始号码
	.s LYGEndNo=ObjCheckData.InvBillNoList.GetAt(i).endNo						;第三方电子结束号码

	.i (IBAInvoiceCode'=LYGInvoiceCode)||(IBAEBillCount'=LYGEBillCount)||(IBAStartNo'=LYGStartNo)||(IBAEndNo'=LYGEndNo) d
	..s ErrMsg="第三方返回的申请单号["_ IBAApplyNo_"]信息与His原有的申请单号["_IBAHisApplyNo_"]信息不一致.请核实."  
	..i (ErrMsgStr="") s ErrMsgStr=ErrMsg
	..e  s ErrMsgStr=ErrMsgStr_":"_ErrMsg
	
	.s ApplyStatus=ObjInvBuyApply.IBAApplyStatus			;申请状态
	.s StockStatus=ObjInvBuyApply.IBAStockStatus			;票据库存状态
	
	.i (ApplyStatus'="2")&&(StockStatus'="1") d
	..//更新购入申请表 申请状态和库存状态为申请成功和待入库
	..s ObjInvBuyApply.IBAApplyStatus="2"
	..s ObjInvBuyApply.IBAStockStatus="1"
	..s SaveRtn=##class(BILL.EINV.BL.COM.InvBuyApplyCtl).SaveApplyBuyData(.ObjInvBuyApply)   ;修改为共通的方法？？？？？？？？
	..q:(SaveRtn<0) 
	..s CountIdx=CountIdx+1
	.e  d
	..s CountIdx=0
	
	q CountIdx
}

/// 查询用户信息
/// d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.InvBuyApplyCtl","QuerySSUserInfo","D")
Query QuerySSUserInfo(KeyWord As %String) As %Query(ROWSPEC = "ind,userName:%String,userID:%String")
{
}

ClassMethod QuerySSUserInfoExecute(ByRef qHandle As %Binary, KeyWord As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    /////以上不用动
    q:KeyWord=""
    s:KeyWord'="" KeyWord=$$ALPHAUP^SSUTIL4(KeyWord)
    s SName=""
    f  s SName=$o(^SSU("SSUSR",0,"SSUSR_Name",SName)) q:SName=""  d
    .s SRowid=""
    .f  s SRowid=$o(^SSU("SSUSR",0,"SSUSR_Name",SName,SRowid)) q:SRowid=""  d
    ..s SSUserInfo=$g(^SSU("SSUSR",SRowid))
    ..s UserCode=$p(SSUserInfo,"^",1)
    ..S userName=$p(SSUserInfo,"^",2)
    ..s:userName'="" UpuserName=$$ALPHAUP^SSUTIL4(userName)
	..q:UpuserName'[KeyWord
	..d OutputRow
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(ind,userName,SRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QuerySSUserInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySSUserInfoExecute ]
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

ClassMethod QuerySSUserInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySSUserInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
