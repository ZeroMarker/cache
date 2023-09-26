Class BILL.DC.BL.CheckResultCtl Extends (%RegisteredObject, %XML.Adaptor, %ZEN.DataModel.Adaptor)
{

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 新增
/// Table : BILL_DC_PO.CheckResult
/// Input:	InJson,SessionStr="UserId^"
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.CheckResultCtl).Save(InJson)
ClassMethod Save(InStr, SessionStr) [ ProcedureBlock = 0 ]
{
	new (InStr, SessionStr)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultCtl).Save(InStr, SessionStr)开始:",InStr, SessionStr)
	s $zt="SaveErr"
	s ^CacheTemp("BILL.DC.BL.CheckResultCtl","Save")=$lb(InStr,SessionStr)
	q:InStr="" "-1"
	k PLIST
	s UserId=+SessionStr
	s PLIST(1)=$p(InStr,"^",1) // rowid
	s PLIST(2)=$p(InStr,"^",2) // 业务类型代码
	s PLIST(3)=$p(InStr,"^",3) // 指标代码
	s PLIST(4)=$p(InStr,"^",4) // 指标名称
	s PLIST(5)=$p(InStr,"^",5) // 核查方式
	s PLIST(6)=$p(InStr,"^",6) // 核查开始日期
	s PLIST(7)=$p(InStr,"^",7) // 核查开始时间
	s PLIST(8)=$p(InStr,"^",8) // 核查结束日期
	s PLIST(9)=$p(InStr,"^",9) // 核查结束时间
	s PLIST(10)=$p(InStr,"^",10) // 审核标志
	s PLIST(11)=$p(InStr,"^",11) // HOSPID
	s PLIST(18)=$p(InStr,"^",18) // Batch
	
	s PLIST(19)=$p(InStr,"^",19) // ExceptionNum
	q:PLIST(11)="" "-2^HOSPID"
	s RowId=PLIST(1)
	if +RowId=0  d
	.s PLIST(12)= UserId 
	.s PLIST(13)=+$h
	.s PLIST(14)=$p($h,",",2)
	.s PLIST(15)=UserId
	.s PLIST(16)=+$h
	.s PLIST(17)=$p($h,",",2)
	.&sql(insert into BILL_DC_PO.CheckResult values PLIST())
	else  d
	.s PLIST(15)=UserId
	.s PLIST(16)=+$h
	.s PLIST(17)=$p($h,",",2)
	.&sql(update BILL_DC_PO.CheckResult  values PLIST() where RowId=:RowId)
	s rtn=-1
	if +SQLCODE=0  d
	.s rtn=%ROWID
	else  d
	.s rtn=SQLCODE
	.s:(+rtn>0) rtn=-rtn // 保证插入失败时 肯定返回负值
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultCtl).Save(InStr, SessionStr)结束:",rtn)
	q rtn
SaveErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.CheckResultCtl).Save(InStr, SessionStr)异常:",InStr, SessionStr,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 删除
/// Table : 
/// Input:	
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.CheckResultCtl).Save(InJson)
ClassMethod Delete(RowId)
{
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultCtl).Delete(RowId)开始:",RowId)
	s $zt="DeleteErr"
	q:RowId="" "-2"
	s ^CacheTemp("INSU.MI.PORTCOMMON","Save")=$lb(RowId)
	&sql(delete from BILL_DC_PO.CheckResult where RowId=:RowId)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultCtl).Delete(RowId)结束:",SQLCODE)
	q SQLCODE
DeleteErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.CheckResultCtl).Delete(RowId)异常:",RowId,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2020-03-09
/// Descript: 更新指定字段
/// Table : 
/// Input:		JsonStr : 字段对应的json串
/// Output: 
/// Return: 0 表示 成功 非0表示失败
/// DeBug:  w ##class(BILL.DC.BL.CheckResultCtl).UpdaeByJson("{name:"a",b:"b"}","3334")
ClassMethod UpdaeByJson(JsonStr, Id) As %String
{
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultCtl).UpdaeByJson(JsonStr, Id)结束:",JsonStr, Id)
	s $zt="UpdaeByJsonErr"
	set ^CacheTemp("UpdaDicInfoByJson")=$lb(JsonStr, Id)
	set rtn=0
	set obj=##class(%DynamicAbstractObject).%FromJSON(JsonStr)
	set Data=##class(BILL.DC.PO.CheckResult).%OpenId(Id,0)
	quit:('$IsObject(Data)) "-1"
	
	set iter = obj.%GetIterator()
	while iter.%GetNext(.key , .value ) {
	   set $ZOBJPROPERTY(Data,key)=$ZOBJPROPERTY(obj,key)
	}
	set err=Data.%Save()
    if $$$ISERR(err){
		set rtn="-100^"_$SYSTEM.Status.GetErrorText(err)
	}else{
		set rtn=0
	}
	set obj=""
	set Data=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultCtl).UpdaeByJson(JsonStr, Id)结束:",rtn)
	quit rtn
UpdaeByJsonErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.CheckResultCtl).UpdaeByJson(JsonStr, Id)异常:",JsonStr, Id,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2020-03-09
/// Descript: 更新指定字段
/// Table : 
/// Input:		JsonStr : 字段对应的json串
/// Output: 
/// Return: 0 表示 成功 非0表示失败
/// DeBug:  w ##class(BILL.DC.BL.CheckResultCtl).UpdaeByJson("{name:"a",b:"b"}","3334")
ClassMethod UpdateExceptionNum(ExceptionNum, Id) As %String
{
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultCtl).UpdateExceptionNum(ExceptionNum, Id)开始:",ExceptionNum, Id)
	s $zt="UpdateExceptionNumErr"
	set ^CacheTemp("UpdaDicInfoByJson")=$lb(ExceptionNum, Id)
	set rtn=0
	set Data=##class(BILL.DC.PO.CheckResult).%OpenId(Id,0)
	quit:('$IsObject(Data)) "-1"
	s Data.ExceptionNum=ExceptionNum
	set err=Data.%Save()
    if $$$ISERR(err){
		set rtn="-100^"_$SYSTEM.Status.GetErrorText(err)
	}else{
		set rtn=0
	}
	set obj=""
	set Data=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultCtl).UpdateExceptionNum(ExceptionNum, Id)结束:",rtn)
	quit rtn
UpdateExceptionNumErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.CheckResultCtl).UpdateExceptionNum(ExceptionNum, Id)异常:",ExceptionNum, Id,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 查询
/// Table : BILL_DC_PO.CheckResult
/// Input:	HospDr
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.DC.BL.CheckResultCtl","QueryInfo","2","")
Query QueryInfo(HospID = "", keyCode) As websys.Query(ROWSPEC = "BusinessType,IndicatorCode,IndicatorName,CheckMode,CheckStartDate,CheckStartTime,CheckEndDate,CheckEndTime,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,CheckBatch,ExceptionNum") [ SqlProc ]
{
}

ClassMethod QueryInfoExecute(ByRef qHandle As %Binary, HospID = "", keyCode) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s ^CacheTemp("INSU.MI.PortCommonCom","QueryPortCommon")=$lb(HospID,keyCode)
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(keyCode)
	s Rowid=0
	f  s Rowid=$o(^BILL.DC.PO.CheckResultD(Rowid)) q:Rowid=""  d
	.s BusinessType=$lg(^BILL.DC.PO.CheckResultD(Rowid),1)
	.s IndicatorCode=$lg(^BILL.DC.PO.CheckResultD(Rowid),2)
	.s IndicatorName=$lg(^BILL.DC.PO.CheckResultD(Rowid),3)
	.s CheckMode=$lg(^BILL.DC.PO.CheckResultD(Rowid),4)
	.s CheckStartDate=$lg(^BILL.DC.PO.CheckResultD(Rowid),5)
	.s:CheckStartDate'="" CheckStartDate=##class(websys.Conversions).DateLogicalToHtml(CheckStartDate)
	.s CheckStartTime=$lg(^BILL.DC.PO.CheckResultD(Rowid),6)
	.s:CheckStartTime'="" CheckStartTime=$zt(CheckStartTime)
	.s CheckEndDate=$lg(^BILL.DC.PO.CheckResultD(Rowid),7)
	.s:CheckEndDate'="" CheckEndDate=##class(websys.Conversions).DateLogicalToHtml(CheckEndDate)
	.s CheckEndTime=$lg(^BILL.DC.PO.CheckResultD(Rowid),8)
	.s:CheckEndTime'="" CheckEndTime=$zt(CheckEndTime)
	.s CheckFlag=$lg(^BILL.DC.PO.CheckResultD(Rowid),9)
	.s HospDr=$lg(^BILL.DC.PO.CheckResultD(Rowid),10)
	.s CRTER=$lg(^BILL.DC.PO.CheckResultD(Rowid),11)
	.s CRTEDATE=$lg(^BILL.DC.PO.CheckResultD(Rowid),12)
	.s:CRTEDATE'="" CRTEDATE=##class(websys.Conversions).DateLogicalToHtml(CRTEDATE)
	.s CRTETIME=$lg(^BILL.DC.PO.CheckResultD(Rowid),13)
	.s:CRTETIME'="" CRTETIME=$zt(CRTETIME)
	.s UPDTID=$lg(^BILL.DC.PO.CheckResultD(Rowid),14)
	.s UPDTDATE=$lg(^BILL.DC.PO.CheckResultD(Rowid),15)
	.s UPDTTIME=$lg(^BILL.DC.PO.CheckResultD(Rowid),16)
	.s CheckBatch=$lg(^BILL.DC.PO.CheckResultD(Rowid),17)
	.s ExceptionNum=$lg(^BILL.DC.PO.CheckResultD(Rowid),18)
	.q:(HospID'="")&&(HospID'=HospDr)
	.s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(IndicatorCode,4,"")
	.s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(IndicatorName,3,"")	
	.q:(CheckBatch'[keyCode)&&($$ALPHAUP^SSUTIL4(IndicatorCode)'[tCodeAndDesc)&&(HZSPCode'[tCodeAndDesc)&&(HZPYCode'[IndicatorCode)&&(IndicatorCode'[keyCode)&&(IndicatorName'[tCodeAndDesc)
	.d QueryPortList	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryPortList
	set Data=$lb(BusinessType,IndicatorCode,IndicatorName,CheckMode,CheckStartDate,CheckStartTime,CheckEndDate,CheckEndTime,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,CheckBatch,ExceptionNum)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 查询
/// Table : BILL_DC_PO.CheckResult
/// Input:	HospDr
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.DC.BL.CheckResultCtl","QueryInfoGroup","2","")
Query QueryInfoGroup(HospID = "", keyCode, ParentID = "", QEXlevelId = "", StDate, EdDate) As websys.Query(ROWSPEC = "IndicatorId,IndicatorCode,IndicatorName,CheckMode,CheckStartDate,CheckStartTime,CheckEndDate,CheckEndTime,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,CheckBatch,ExceptionNum,_parentId,BusinessCode,EXlevelId,Description,EXlevelName") [ SqlProc ]
{
}

ClassMethod QueryInfoGroupExecute(ByRef qHandle As %Binary, HospID = "", keyCode, ParentID = "", QEXlevelId = "", StDate, EdDate) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s ^CacheTemp("INSU.MI.PortCommonCom","QueryPortCommon")=$lb(HospID,keyCode)
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(keyCode)
	s ParamCheckBatch=""
	s StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	s EdDate=##class(websys.Conversions).DateHtmlToLogical(EdDate)
	for date=StDate:1:EdDate d
	.for  s ParamCheckBatch=$o(^BILL.DC.PO.CheckResultI("IndexOptDateCheckBatch",date,ParamCheckBatch),-1) q:ParamCheckBatch=""  d
	..s IndexBusinessCode=""
	..s KeyQueNum=0
	..s TotalExNum=0
	..//过滤非该院区批次号
	..s Rowid=$o(^BILL.DC.PO.CheckResultI("IndexOptDateCheckBatch",date,ParamCheckBatch,""))
	..q:Rowid=""
	..s HospDr=$lg(^BILL.DC.PO.CheckResultD(Rowid),10) 
	..q:(HospID'="")&&(HospID'=HospDr)
	..s FlagAll="Y" //批次号总审批状态
	..s NeedDoFlag="Y"
	..for  s IndexBusinessCode=$o(^BILL.DC.PO.CheckResultI("IndexUnique",ParamCheckBatch,IndexBusinessCode))  q:IndexBusinessCode=""  d
	...s IndexIndiCode=""
	...for  s IndexIndiCode=$o(^BILL.DC.PO.CheckResultI("IndexUnique",ParamCheckBatch,IndexBusinessCode,IndexIndiCode))  q:IndexIndiCode=""  d
	....s TparentCode=$o(^BILL.DC.PO.CheckResultI("IndexUnique",ParamCheckBatch,IndexBusinessCode,""),-1)
	....q:TparentCode=""
	....s TparentId=$o(^BILL.DC.PO.CheckResultI("IndexUnique",ParamCheckBatch,IndexBusinessCode,TparentCode,""),-1)
	....q:TparentId=""
	....s TparentId=ParamCheckBatch
	....s Rowid=""
	....for  s Rowid=$o(^BILL.DC.PO.CheckResultI("IndexUnique",ParamCheckBatch,IndexBusinessCode,IndexIndiCode,Rowid)) q:Rowid=""  d
	.....s CheckFlagNew=$lg(^BILL.DC.PO.CheckResultD(Rowid),9) //查询审批号下的指标审批状态
	.....s ExceptionNumNew=+$lg(^BILL.DC.PO.CheckResultD(Rowid),18) //异常数量是0的，默认是已审核状态，不做判断
	.....s:(CheckFlagNew="")&&(ExceptionNumNew'=0) CheckFlagNew="N"
	.....if (CheckFlagNew="N")&&(NeedDoFlag="Y")  d
	......s (FlagAll,NeedDoFlag)="N"
	.....d BuildCheckResult1
	..s CheckFlag=FlagAll
	..s (IndicatorId,IndicatorCode,IndicatorName,parentId,EXlevelId,Description)=""
	..s tmpRowId=TparentId
	..s ExceptionNum=TotalExNum
	..q:(keyCode'="")&&(KeyQueNum=0) //过滤模糊检索为空的核查批次
	..q:(QEXlevelId'="")&&(TotalExNum=0)
	..d QueryPortList1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildCheckResult1 
	s IndicatorId=$lg(^BILL.DC.PO.CheckResultD(Rowid),1)
	s IndicatorCode=$lg(^BILL.DC.PO.CheckResultD(Rowid),2)
	s IndicatorName=$lg(^BILL.DC.PO.CheckResultD(Rowid),3)
	s CheckMode=$lg(^BILL.DC.PO.CheckResultD(Rowid),4)
	s CheckStartDate=$lg(^BILL.DC.PO.CheckResultD(Rowid),5)
	s:CheckStartDate'="" CheckStartDate=##class(websys.Conversions).DateLogicalToHtml(CheckStartDate)
	s CheckStartTime=$lg(^BILL.DC.PO.CheckResultD(Rowid),6)
	s:CheckStartTime'="" CheckStartTime=$zt(CheckStartTime)
	s CheckEndDate=$lg(^BILL.DC.PO.CheckResultD(Rowid),7)
	s:CheckEndDate'="" CheckEndDate=##class(websys.Conversions).DateLogicalToHtml(CheckEndDate)
	s CheckEndTime=$lg(^BILL.DC.PO.CheckResultD(Rowid),8)
	s:CheckEndTime'="" CheckEndTime=$zt(CheckEndTime)
	s CheckFlag=$lg(^BILL.DC.PO.CheckResultD(Rowid),9)
	s HospDr=$lg(^BILL.DC.PO.CheckResultD(Rowid),10)
	s CRTER=$lg(^BILL.DC.PO.CheckResultD(Rowid),11)
	s CRTEDATE=$lg(^BILL.DC.PO.CheckResultD(Rowid),12)
	s:CRTEDATE'="" CRTEDATE=##class(websys.Conversions).DateLogicalToHtml(CRTEDATE)
	s CRTETIME=$lg(^BILL.DC.PO.CheckResultD(Rowid),13)
	s:CRTETIME'="" CRTETIME=$zt(CRTETIME)
	s UPDTID=$lg(^BILL.DC.PO.CheckResultD(Rowid),14)
	s UPDTDATE=$lg(^BILL.DC.PO.CheckResultD(Rowid),15)
	s:UPDTDATE'="" UPDTDATE=##class(websys.Conversions).DateLogicalToHtml(UPDTDATE)
	s UPDTTIME=$lg(^BILL.DC.PO.CheckResultD(Rowid),16)
	s:UPDTTIME'="" UPDTTIME=$zt(UPDTTIME)
	s CheckBatch=$lg(^BILL.DC.PO.CheckResultD(Rowid),17)
	s ExceptionNum=+$lg(^BILL.DC.PO.CheckResultD(Rowid),18)
	q:(HospID'="")&&(HospID'=HospDr)
	s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(IndicatorCode,4,"")
	s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(IndicatorName,3,"")
	s BusinessCode=IndicatorId
	s EXlevelId=""
	s Description=""
	s IndiInfo=##class(BILL.DC.BL.IndicatorDefCtl).GetIndiInfo(HospID,"Y",BusinessCode,IndicatorCode)
	if IndiInfo="-2" d
	.s IndiInfo=##class(BILL.DC.BL.IndicatorDefCtl).GetIndiInfo(HospID,"N",BusinessCode,IndicatorCode)
	if (IndiInfo'="-2")&&(IndicatorCode'="") d
	.s EXlevelId=$p(IndiInfo,"^",5)
	.s Description=$p(IndiInfo,"^",6)
	.s EXlevelName=##class(BILL.DC.BL.DicDataCtl).GetDicInfoByTypeCode("ExceptionLevel", EXlevelId, "G","2")
	q:(QEXlevelId'="")&&(QEXlevelId'=EXlevelId)
	q:(CheckBatch'[keyCode)&&($$ALPHAUP^SSUTIL4(IndicatorCode)'[tCodeAndDesc)&&(HZSPCode'[tCodeAndDesc)&&(IndicatorCode'[keyCode)&&(IndicatorName'[tCodeAndDesc)
	s parentId=TparentId
	s tmpRowId=Rowid
	i (tmpRowId=TparentId)&&(parentId'="")  d
	.s tmpRowId=tmpRowId
	s TotalExNum=$i(TotalExNum,ExceptionNum)
	i (keyCode'="") d
	.s KeyQueNum=KeyQueNum+1
	d QueryPortList1
	q

QueryPortList1
	//s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(IndicatorCode,4,"")
	//s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(IndicatorName,3,"")	
	//q:(CheckBatch'[keyCode)&&($$ALPHAUP^SSUTIL4(IndicatorCode)'[tCodeAndDesc)&&(HZSPCode'[tCodeAndDesc)&&(IndicatorCode'[keyCode)&&(IndicatorName'[tCodeAndDesc)
	s BusinessCode=IndicatorId
	set IndicatorId=IndicatorId_##class(BILL.DC.BL.DicDataCtl).GetDicInfoByTypeCode("BusinessTypeCode", IndicatorId, "G","2")
	q:(ParentID'="")&&(ParentID'=parentId)
	set Data=$lb(IndicatorId,IndicatorCode,IndicatorName,CheckMode,CheckStartDate,CheckStartTime,CheckEndDate,CheckEndTime,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,tmpRowId,CheckBatch,ExceptionNum,parentId,BusinessCode,EXlevelId,Description,EXlevelName)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// w ##class(BILL.DC.BL.CheckResultCtl).UpdaeByJson("")
ClassMethod UpdateExceptionNumByBatch(ParamCheckBatch)
{
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultCtl).UpdateExceptionNumByBatch(ParamCheckBatch)开始:",ParamCheckBatch)
	s $zt="UpdateExceptionNumByBatchErr"
	s IndexBusinessCode=""
	for  s IndexBusinessCode=$o(^BILL.DC.PO.CheckResultI("IndexUnique",ParamCheckBatch,IndexBusinessCode))  q:IndexBusinessCode=""  d
	.s IndexIndiCode=""
	.for  s IndexIndiCode=$o(^BILL.DC.PO.CheckResultI("IndexUnique",ParamCheckBatch,IndexBusinessCode,IndexIndiCode))  q:IndexIndiCode=""  d
	..s TparentId=$o(^BILL.DC.PO.CheckResultI("IndexUnique",ParamCheckBatch,IndexBusinessCode,IndexIndiCode,""),-1)
	..q:TparentId=""
	..s DetailRowId=""
	..s ExNum=0
	..for  s DetailRowId=$o(^BILL.DC.PO.CheckResultDetI("IndexParID",TparentId,DetailRowId)) q:DetailRowId=""  d
	...s ExNum=ExNum+1
	..s $list(^BILL.DC.PO.CheckResultD(TparentId),18)=ExNum
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultCtl).UpdateExceptionNumByBatch(ParamCheckBatch)结束:","")
	q ""
UpdateExceptionNumByBatchErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.CheckResultCtl).UpdateExceptionNumByBatch(ParamCheckBatch)异常:",ParamCheckBatch,$ze)
	q "-2"
}

/// Creator: tanfb
/// CreateDate: 2022-11-17
/// Descript: 查询一段时间每一天的异常数量
/// Table : BILL_DC_PO.CheckResult
/// Input:	HospDr
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.DC.BL.CheckResultCtl","QueryForDate","2","2022-09-07","2022-09-08")
Query QueryForDate(HospID, StDate, EdDate) As websys.Query(ROWSPEC = "date,Num") [ SqlProc ]
{
}

ClassMethod QueryForDateExecute(ByRef qHandle As %Binary, HospID, StDate, EdDate) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s ParamCheckBatch=""
	s StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	s EdDate=##class(websys.Conversions).DateHtmlToLogical(EdDate)
	for date=StDate:1:EdDate d
	.s Num=0
	.for  s ParamCheckBatch=$o(^BILL.DC.PO.CheckResultI("IndexOptDateCheckBatch",date,ParamCheckBatch),-1) q:ParamCheckBatch=""  d
	..s Rowid=""
	..for  s Rowid=$o(^BILL.DC.PO.CheckResultI("IndexOptDateCheckBatch",date,ParamCheckBatch,Rowid)) q:Rowid=""  d
	...s ExceptionNum=$lg(^BILL.DC.PO.CheckResultD(Rowid),18)
	...s Num=Num+ExceptionNum
	.d QueryPortList
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryPortList
    set date=##class(websys.Conversions).DateLogicalToHtml(date)
	set Data=$lb(date,Num)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	set date=##class(websys.Conversions).DateHtmlToLogical(date)
 	q
}

/// Creator: zjb
/// CreateDate: 2023/1/19
/// Descript: 更新BILL.DC.PO.CheckResult审核状态，当对应CheckResultDet都已审核时，则更新已审核状态，否则均未审核
/// Table : 
/// Input:	rowid
/// Output: 
/// Return: 0 表示 成功 非0表示失败
/// DeBug:  w ##class(BILL.DC.BL.CheckResultCtl).CheckResultDetCheckFlag("4284")
ClassMethod UpdateCheckResultCheckFlag(ParID) As %String
{
	q:ParID="" ""
	
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultCtl).UpdateCheckResultCheckFlag(ParID)开始:",ParID)
	s $zt="UpdateCheckResultCheckFlagErr"
	
	s CheckFlag=$lg(^BILL.DC.PO.CheckResultD(ParID),9)
	s:CheckFlag="" CheckFlag="N"
	s CheckFlagNew="Y"
	s RowidDet=0
	f  s RowidDet=$o(^BILL.DC.PO.CheckResultDetI("IndexParID",ParID,RowidDet)) q:(RowidDet="")||(CheckFlagNew="N")  d
	.s CheckFlagDet=$lg(^BILL.DC.PO.CheckResultDetD(RowidDet),9)
	.i (CheckFlagDet="")||(CheckFlagDet="N") d
	..s CheckFlagNew="N"
	//.q:CheckFlagNew="N"
	q:CheckFlag=CheckFlagNew "0"
	set Data=##class(BILL.DC.PO.CheckResult).%OpenId(ParID,0)
	quit:('$IsObject(Data)) "-1"
	s Data.CheckFlag=CheckFlagNew
	set err=Data.%Save()
    if $$$ISERR(err){
		set rtn="-100^"_$SYSTEM.Status.GetErrorText(err)
	}else{
		set rtn=0
	}
	set Data=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.CheckResultCtl).UpdateCheckResultCheckFlag(ParID)结束:",rtn)
	q rtn
UpdateCheckResultCheckFlagErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.CheckResultCtl).UpdateCheckResultCheckFlag(ParID)异常:",ParID,$ze)
	q "-2"
}

}
