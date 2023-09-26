Class BILL.DC.BL.CheckResultDetCtl Extends (%RegisteredObject, %XML.Adaptor, %ZEN.DataModel.Adaptor)
{

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 新增
/// Table : CT.BILL.DC.IndicatorDef
/// Input:	InJson,SessionStr="UserId^"
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.CheckResultDetCtl).Save(InJson)
ClassMethod Save(InStr, SessionStr) [ ProcedureBlock = 0 ]
{
	new (InStr, SessionStr)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultDetCtl).Save(InStr, SessionStr)开始:",InStr, SessionStr)
	s $zt="SaveErr"
	s ^CacheTemp("BILL.DC.BL.CheckResultCtl","Save")=$lb(InStr,SessionStr)
	q:InStr="" "-1"
	k PLIST
	s UserId=+SessionStr
	s PLIST(1)=$p(InStr,"^",1) // rowid
	s PLIST(2)=$p(InStr,"^",2) // ParID
	s PLIST(3)=$p(InStr,"^",3) // DataSrc
	s PLIST(4)=$p(InStr,"^",4) // DataID
	s PLIST(5)=$p(InStr,"^",5) // ErrCode
	s PLIST(6)=$p(InStr,"^",6) // ErrInfo
	s PLIST(7)=$p(InStr,"^",7) // ParNodeDataSrc
	s PLIST(8)=$p(InStr,"^",8) // ParNodeDataID
	s PLIST(9)=$p(InStr,"^",9) // ParNodeFlag
	s PLIST(10)=$p(InStr,"^",10) // CheckFlag
	s PLIST(11)=$p(InStr,"^",11) // HOSPID
	s PLIST(18)=$p(InStr,"^",18) // uPDATEDemo
	q:PLIST(11)="" "-2^HOSPID"
	s RowId=PLIST(1)
	if +RowId=0  d
	.s PLIST(12)= UserId 
	.s PLIST(13)=+$h
	.s PLIST(14)=$p($h,",",2)
	.s PLIST(15)="" //UserId
	.s PLIST(16)=+$h
	.s PLIST(17)=$p($h,",",2)
	.&sql(insert into BILL_DC_PO.CheckResultDet values PLIST())
	else  d
	.s PLIST(15)=UserId
	.s PLIST(16)=+$h
	.s PLIST(17)=$p($h,",",2)
	.&sql(update BILL_DC_PO.CheckResultDet  values PLIST() where RowId=:RowId)
	s rtn=-1
	if +SQLCODE=0  d
	.s rtn=%ROWID
	else  d
	.s rtn=SQLCODE
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultDetCtl).Save(InStr, SessionStr)结束:",rtn)
	q rtn
SaveErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.CheckResultDetCtl).Save(InStr, SessionStr)异常:",InStr, SessionStr,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 删除
/// Table : CF_BILL_DataCheck.UnAuditItm
/// Input:	
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.UnAuditItmCtl).Save(InJson)
ClassMethod Delete(RowId)
{
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultDetCtl).Delete(RowId)开始:",RowId)
	s $zt="DeleteErr"
	q:RowId="" "-2"
	s ^CacheTemp("INSU.MI.PORTCOMMON","Save")=$lb(RowId)
	&sql(delete from BILL_DC_PO.CheckResultDet where RowId=:RowId)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultDetCtl).Delete(RowId)结束:",SQLCODE)
	q SQLCODE
DeleteErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.CheckResultDetCtl).Delete(RowId)异常:",RowId,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 删除
/// Table : CF_BILL_DataCheck.UnAuditItm
/// Input:	
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.CheckResultDetCtl).DeleteByParent(InJson)
ClassMethod DeleteByParent(ParentId)
{
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultDetCtl).DeleteByParent(ParentId)开始:",ParentId)
	s $zt="DeleteByParentErr"
	q:ParentId="" "-2"
	s ^CacheTemp("INSU.MI.PORTCOMMON","DeleteByParent")=$lb(ParentId)
	&sql(delete from BILL_DC_PO.CheckResultDet where ParID=:ParentId)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultDetCtl).Save(InStr, SessionStr)结束:",SQLCODE)
	q SQLCODE
DeleteByParentErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.CheckResultDetCtl).DeleteByParent(ParentId)异常:",ParentId,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2020-03-09
/// Descript: 更新指定字段
/// Table : 
/// Input:		JsonStr : 字段对应的json串
/// Output: 
/// Return: 0 表示 成功 非0表示失败
/// DeBug:  w ##class(BILL.DC.BL.CheckResultDetCtl).UpdaeByJson("{""CheckFlag"":""Y""}","4916")
ClassMethod UpdaeByJson(JsonStr, Id) As %String
{
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultDetCtl).UpdaeByJson(JsonStr, Id)开始:",JsonStr, Id)
	s $zt="UpdaeByJsonErr"
	set ^CacheTemp("UpdaDicInfoByJson")=$lb(JsonStr, Id)
	set rtn=0
	s OldData=$listtostring(^BILL.DC.PO.CheckResultDetD(Id),"^")
	set obj=##class(%DynamicAbstractObject).%FromJSON(JsonStr)
	set Data=##class(BILL.DC.PO.CheckResultDet).%OpenId(Id,0)
	quit:('$IsObject(Data)) "-1001"
	
	set iter = obj.%GetIterator()
	while iter.%GetNext(.key , .value ) {
	   set $ZOBJPROPERTY(Data,key)=$ZOBJPROPERTY(obj,key)
	}
	s Data.UpdtDate=+$h
	s Data.UpdtTime=$p($h,",",2)
	set err=Data.%Save()
    if $$$ISERR(err){
		set rtn="-100^"_$SYSTEM.Status.GetErrorText(err)
	}else{
		set rtn=0
	}
#;	s OptDate=+$h
#;	s OptTime=$p($h,",",2)
#;	s UserId=##class(INSU.COM.Tools).GetKeyVal(JsonStr,"UpdtId")
#;	s NewData=$listtostring(^BILL.DC.PO.CheckResultDetD(Id),"^")
#;	d ##class(INSU.COM.Tools).SaveLog("BILL.DC.PO.CheckResultDet",Id,"1","UPDATE",OptDate,OptTime,UserId,OldData,NewData)
	set obj=""
	set Data=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultDetCtl).UpdaeByJson(JsonStr,Id)结束:",rtn)
	quit rtn
UpdaeByJsonErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.CheckResultDetCtl).UpdaeByJson(JsonStr, Id)异常:",JsonStr, Id,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 查询
/// Table : CF_BILL_DC.UnAuditItm
/// Input:	HospDr
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.DC.BL.CheckResultDetCtl","QueryInfo",367,"","N")
Query QueryInfo(ParentID, KeyCode = "", PCheckFlag = "", BeginNum = "", EndNum = "", QueryType = "", IndexCode = "") As websys.Query(ROWSPEC = "ParID,DataSrc,DataID,ErrCode,ErrInfo,ParNodeDataSrc,ParNodeDataID,ParNodeFlag,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,UPDTDemo,ErrConfInfo,ChargeType,PAADM,TarId,TotalNum,FormatterInfo") [ SqlProc ]
{
}

ClassMethod QueryInfoExecute(ByRef qHandle As %Binary, ParentID, KeyCode = "", PCheckFlag = "", BeginNum = "", EndNum = "", QueryType = "", IndexCode = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(KeyCode)
	s ^CacheTemp("BILL.DC.BL.CheckResultDetCtl","QueryInfo")=$lb(ParentID,KeyCode,PCheckFlag)
	s GetNum=0
	s Rowid=0
	set (ParID,DataSrc,DataID,ErrCode,ErrInfo,ParNodeDataSrc,ParNodeDataID,ParNodeFlag,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,UPDTDemo,ErrConfInfo,ChargeType,PAADM,TarId)=""
	//if (IndexCode="CT04")||(IndexCode="COM99") d
	//set Col="8#{""title"":""收费项目ID"",""field"":""TarId"",""width"":""100""}&{""title"":""姓名"",""field"":""Name"",""width"":""100""}"
	s TotalNum=0 //计总数
	//d QueryPortList
	f  s Rowid=$o(^BILL.DC.PO.CheckResultDetI("IndexParID",ParentID,Rowid)) q:Rowid=""  d
	
	.s ParID=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),1)
	.s DataSrc=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),2)
	.s DataID=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),3)
	.s ErrCode=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),4)
	.s ErrInfo=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),5)
	.s ParNodeDataSrc=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),6)
	.s ParNodeDataID=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),7)
	.s ParNodeFlag=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),8)
	.s CheckFlag=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),9)
	.s:CheckFlag="" CheckFlag="N"
	.q:(PCheckFlag'="")&&(PCheckFlag'=CheckFlag)
	.s HospDr=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),10)
	.s CRTER=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),11)
	.s CRTEDATE=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),12)
	.s CRTETIME=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),13)
	.s UPDTID=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),14)
	.s UPDTDATE=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),15)
	.s:UPDTDATE'="" UPDTDATE=$zd(UPDTDATE,3) //##class(websys.Conversions).DateLogicalToHtml(UPDTDATE)
	.s UPDTTIME=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),16)
	.s UPDTDemo=$lg(^BILL.DC.PO.CheckResultDetD(Rowid),17)
	.s:UPDTTIME'="" UPDTTIME=$zt(UPDTTIME)
	.;q:(HospID'="")&&(HospID'=HospDr)
	.;s ErrConfInfo=..FormatterData("",DataSrc,DataID)
	.;s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(ErrCode,4,"")
	.;s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(ErrInfo,3,"")
	.;q:((QueryType="1")||(QueryType=""))&&($$ALPHAUP^SSUTIL4(ErrCode)'[tCodeAndDesc)&&(HZSPCode'[tCodeAndDesc)&&(HZPYCode'[KeyCode)&&(ErrCode'[KeyCode)&&(ErrInfo'[tCodeAndDesc)&&(ErrConfInfo'[KeyCode)&&(ErrConfInfo'[tCodeAndDesc)
	.;q:(QueryType="2")&&(($$ALPHAUP^SSUTIL4(ErrCode)[tCodeAndDesc)||(HZSPCode[tCodeAndDesc)||(HZPYCode[KeyCode)||(ErrCode[KeyCode)||(ErrInfo[tCodeAndDesc)||(ErrConfInfo[KeyCode)||(ErrConfInfo[tCodeAndDesc))
	.s TotalNum=TotalNum+1
	.s GetNum=GetNum+1
	.q:(BeginNum'="")&&(EndNum'="")&&(+BeginNum>GetNum)
	.q:(BeginNum'="")&&(EndNum'="")&&(+EndNum<GetNum)
	.s FormatterInfo=..FormatterData(ErrCode,DataSrc,DataID,HospDr)
	.s ErrConfInfo=$p(FormatterInfo,$c(2),1)
	
	.//含关键字查询
	.q:((QueryType="1")||(QueryType=""))&&($$ALPHAUP^SSUTIL4(ErrCode)'[tCodeAndDesc)&&(ErrCode'[KeyCode)&&(ErrInfo'[tCodeAndDesc)&&(ErrConfInfo'[KeyCode)&&(ErrConfInfo'[tCodeAndDesc)
	.//不含关键字查询
	.q:(QueryType="2")&&(KeyCode'="")&&(($$ALPHAUP^SSUTIL4(ErrCode)[tCodeAndDesc)||(ErrCode[KeyCode)||(ErrInfo[tCodeAndDesc)||(ErrConfInfo[KeyCode)||(ErrConfInfo[tCodeAndDesc))
	
	.set TarId=$p(FormatterInfo,$c(2),4)
	.s ChargeType=$p(FormatterInfo,$c(2),2)
	.s PAADM=$p(FormatterInfo,$c(2),3)
	.;s:ErrInfo="" ErrInfo="维护提示信息"
	 
	.d QueryPortList	
	//目的输出总数
	set (ParID,DataSrc,DataID,ErrCode,ErrInfo,ParNodeDataSrc,ParNodeDataID,ParNodeFlag,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,UPDTDemo,ErrConfInfo,ChargeType,PAADM,TarId)=""
	d QueryPortList	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryPortList
	set Data=$lb(ParID,DataSrc,DataID,ErrCode,ErrInfo,ParNodeDataSrc,ParNodeDataID,ParNodeFlag,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,UPDTDemo,ErrConfInfo,ChargeType,PAADM,TarId,TotalNum,$g(FormatterInfo))
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FormatterData(ErrCode, DataSrc, DataId, HospDr)
{
	s $zt="BILLDCFormatterDataErr"
		s ChargeType="" // 收费类型 挂号、门收费、住收费、急收费
		s Channel="" // 渠道 自助机、窗口
		s (PAADM,PAPMI,BILL,rtn,PRTRowid,ArcItmId,TarId,IPPRTRowid,OEORI,OEORD,IPDepositId,INPAYID,INADM)=""
		s inputObj=##class(%ArrayOfDataTypes).%New()
		
		if (DataSrc="User.DHCPatientBill")||(DataSrc="User.DHCPatBillOrder")||(DataSrc="User.DHCPatBillDetails")  d
		.s PAADM=$p(^DHCPB(+DataId),"^",1)
		.s PAPMI=$p(^PAADM(PAADM),"^",1)
		.s BILL=+DataId
		.if (DataSrc="User.DHCPatBillDetails")  d
		..s PBO=$p(DataId,"||",2)
		..s PBD=$p(DataId,"||",3)
		..s TarId=$p(^DHCPB(BILL,"O",PBO,"D",PBD),"^",3)
		if DataSrc="User.DHCINVPRT"  d
		.s PRTRowid=+DataId
		.s PAPMI=$p(^DHCINVPRT(PRTRowid),"^",15)
		.s DHCBCIRowid=$o(^DHCBCI(0,"INV",PRTRowid,""))
		.i DHCBCIRowid'=""  d
		..set PAADM=$p(^DHCBCI(DHCBCIRowid),"^",3) 
		if (DataSrc="User.OEOrdItem")||(DataSrc="User.OEOrder")||(DataSrc="User.OEOrdExec")  d
		.s OEORD=+DataId
		.s PAADM=$p(^OEORD(OEORD),"^",1)
		.s PAPMI=$p(^PAADM(PAADM),"^",1)
		.i (DataSrc="User.OEOrdItem")||(DataSrc="User.OEOrdExec")  d
		..s ArcItmId=$p(^OEORD(+DataId,"I",$p(DataId,"||",2),1),"^",2)
		..s OEORI=$p(DataId,"||",1)_"||"_$p(DataId,"||",2)
		if (DataSrc="User.DHCTarItem")||(DataSrc="User.DHCTarItemPrice")  d
		.s TarId=+DataId
		if (DataSrc="User.ArcItmMast")  d
		.s ArcItmId=DataId
		if (DataSrc="User.DHCINVPRTZY")   d
		.s IPPRTRowid=DataId
		.s PAPMI=$p(^DHCINVPRTZY(IPPRTRowid),"^",18)
		.s PAADM=$p(^DHCINVPRTZY(IPPRTRowid),"^",4)
		if (DataSrc="User.INSUDivide")   d
		.s INPAYID=DataId
		.s PAADM=$p(^DHCINDIV(INPAYID),"^",1)
		.s PAPMI=$p(^PAADM(PAADM),"^",1)
		.s PRTRowid=$p(^DHCINDIV(INPAYID),"^",4)
		.s BILL=$p(^DHCINDIV(INPAYID),"^",3)
		.s:BILL'="" IPPRTRowid=$o(^DHCINVPRTZY("0","AR",BILL,""),-1)
		if (DataSrc="User.INSUAdmInfo")   d
		.s INADM=DataId
		.s PAADM=$p(^DHCINADM(INADM),"^",1)
		.s PAPMI=$p(^PAADM(PAADM),"^",1)
		if (DataSrc="User.dhcsfprintdetail")   d
		.s IPDepositId=DataId
		.s PAADM=$p(^DHCSFPRINTDETAIL(IPDepositId),"^",4)
		.s PAPMI=$p(^PAADM(PAADM),"^",1)
		
		i PRTRowid'=""  d
		.s FairType=$p(^DHCINVPRT(PRTRowid),"^",34)
		.s:FairType="R" ChargeType="挂号"
		.s:FairType="F" ChargeType="门诊收费"
		.i PAADM'=""  d
		..s PAADMType=$p(^PAADM(PAADM),"^",2)
		..s:PAADMType="E" ChargeType="急诊收费"
		i IPPRTRowid'=""  d
		.s ChargeType="住院收费"
		
		
		
		s DefFormatterInfo=""
		d inputObj.SetAt(PAPMI,"User.PAPatMas") //表的唯一rowid
		s:PAPMI'="" DefFormatterInfo="登记号：{User.PAPatMas||PAPMINo},姓名：{User.PAPatMas||PAPMIName}"
		
		d inputObj.SetAt(PAADM,"User.PAAdm") //表的唯一rowid
		s:PAADM'="" DefFormatterInfo=DefFormatterInfo_",就诊类型：{User.PAAdm||PAADMType}"
		
		d inputObj.SetAt(BILL,"User.DHCPatientBill") //表的唯一rowid
		s:BILL'="" DefFormatterInfo=DefFormatterInfo_",账单计费状态：{User.DHCPatientBill||PBPayedFlag}"
		
		d inputObj.SetAt(PRTRowid,"User.DHCINVPRT") //表的唯一rowid
		s:PRTRowid'="" DefFormatterInfo=DefFormatterInfo_",发票状态：{User.DHCINVPRT||PRTFlag}"

		d inputObj.SetAt(IPPRTRowid,"User.DHCINVPRTZY") //表的唯一rowid
		s:IPPRTRowid'="" DefFormatterInfo=DefFormatterInfo_",发票状态：{User.DHCINVPRTZY||PRTFlag}"
		
		d inputObj.SetAt(ArcItmId,"User.ARCItmMast") //表的唯一rowid
		s:ArcItmId'="" DefFormatterInfo=DefFormatterInfo_",医嘱项名称：{User.ARCItmMast||ARCIMDesc}"

		d inputObj.SetAt(TarId,"User.DHCTarItem") //表的唯一rowid
		s:TarId'="" DefFormatterInfo=DefFormatterInfo_",收费项名称：{User.DHCTarItem||TARIDesc}"

		d inputObj.SetAt(OEORI,"User.OEOrdItem") //表的唯一rowid
		s:OEORI'="" DefFormatterInfo=DefFormatterInfo_",医嘱状态：{User.OEOrdItem||OEORIItemStatDR}"
		
		//取配置
		s ErrCFGInfo=""
		s ErrDicInfo=##class(BILL.COM.BL.ErrDicCtl).GetErrInfoByErrCode(ErrCode,HospDr)
		i +ErrDicInfo=0  d
		.s ErrCFGInfo = $lg(ErrDicInfo,3) // 格式
		// use default
		s FormatterInfo=ErrCFGInfo_DefFormatterInfo
		s rtn=FormatterInfo
		s CfgLen=$l(FormatterInfo,"{")
		s JsonStr="{"
		for i=1:1:CfgLen  d
		.s tmp1=$p(FormatterInfo,"{",(i+1))
		.q:tmp1'["}"
		.s tmp2=$p(tmp1,"}",1)
		.s ClassName=$p(tmp2,"||",1)
		.s Property=$p(tmp2,"||",2)
		.s replaceStr="{"_tmp2_"}"
		.i +inputObj.GetAt(ClassName)=0  d
		..s rtn=$replace(rtn,replaceStr,"")
		.e  d
		..s Value=..GetFormatterInfo(ClassName, inputObj.GetAt(ClassName),Property)
		..s rtn=$replace(rtn,replaceStr,Value)
		.i JsonStr="{" s JsonStr=JsonStr_""""_tmp2_""":"""_$g(Value)_""""
		.e  s JsonStr=JsonStr_","""_tmp2_""":"""_$g(Value)_""""
		s JsonStr=JsonStr_"}"
		q rtn_$c(2)_Channel_ChargeType_$c(2)_PAADM_$c(2)_TarId_$c(2)_JsonStr
BILLDCFormatterDataErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.CheckResultDetCtl).BILLDCFormatterData(ErrCode, DataSrc, DataId, HospDr)异常",ErrCode, DataSrc, DataId, HospDr,$ze)
	q "格式化失败"_$ze
}

/// d ##class(BILL.DC.BL.CheckResultDetCtl).GetConfigFiled("{pa_patmas.PAPMI_No},{pa_patmas.PAPMI_Name}123")
ClassMethod GetFormatterInfo(ClassName, RowId, Property)
{
	s $zt="GetFormatterInfoErr"
	q:+RowId=0 "[RowID不能为0"_ClassName_"."_Property_"]"
	s cdef=$ZOBJCLASSMETHOD(ClassName, "%OpenId", RowId, 0)
	q:('$IsObject(cdef)) "[RowID="_RowId_"对应数据(或类)不存在:"_ClassName_"]"
	q:(1=2) "[属性"_ClassName_"."_Property_"不存在]"
	s Value=$ZOBJPROPERTY(cdef,Property)
	i $IsObject(Value)  d
	.s Value=Value.%Id()
	s cdef=""
	q Value
GetFormatterInfoErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.CheckResultDetCtl).GetFormatterInfo(ClassName, RowId, Property)异常",ClassName, RowId, Property,$ze)
	s cdef=""
	q "格式化数据失败"
}

}
