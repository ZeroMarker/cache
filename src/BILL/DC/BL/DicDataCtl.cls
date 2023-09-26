Class BILL.DC.BL.DicDataCtl Extends %RegisteredObject
{

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 新增
/// Table : CT.BILL.DC.IndicatorDef
/// Input:	InJson,SessionStr="UserId^"
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.ErrDicCtl).Save(InJson)
ClassMethod Save(InStr, SessionStr) [ ProcedureBlock = 0 ]
{
	new (InStr, SessionStr)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.DicDataCtl).Save(InStr, SessionStr)开始:",InStr, SessionStr)
	s $zt="SaveErr"
	s ^CacheTemp("BILL.DC.BL.DicDataCtl","Save")=$lb(InStr,SessionStr)
	q:InStr="" "-1"
	k PLIST
	s UserId=+SessionStr
	s PLIST(1)=$p(InStr,"^",1) // rowid
	s PLIST(2)=$p(InStr,"^",2) // ErrCode
	s PLIST(3)=$p(InStr,"^",3) // ErrDefaultDesc
	s PLIST(4)=$p(InStr,"^",4) // ErrConfig
	s PLIST(5)=$p(InStr,"^",5) // Demo
	s PLIST(6)=$p(InStr,"^",6) // RuleInfo
	s PLIST(7)=$p(InStr,"^",7) // ActiveFlag
	s PLIST(8)=$p(InStr,"^",8) // HOSPID
	s PLIST(15)=$p(InStr,"^",15) // ConCode
	s PLIST(16)=$p(InStr,"^",16) // DicType
	q:PLIST(8)="" "-2^HOSPID"
	s RowId=PLIST(1)
	if +RowId=0  d
	.s PLIST(9)= UserId 
	.s PLIST(10)=+$h
	.s PLIST(11)=$p($h,",",2)
	.s PLIST(12)=UserId
	.s PLIST(13)=+$h
	.s PLIST(14)=$p($h,",",2)
	.&sql(insert into CT_BILL_DC.DicData values PLIST())
	else  d
	.s PLIST(12)=UserId
	.s PLIST(13)=+$h
	.s PLIST(14)=$p($h,",",2)
	.&sql(update CT_BILL_DC.DicData  values PLIST() where RowId=:RowId)
	s rtn=-1
	if +SQLCODE=0  d
	.s rtn=%ROWID
	else  d
	.s rtn=SQLCODE
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.DicDataCtl).Save(InStr, SessionStr)结束:",rtn)
	q rtn
SaveErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.DicDataCtl).Save(InStr, SessionStr)异常",InStr, SessionStr,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2020-03-09
/// Descript: 更新指定字段
/// Table : 
/// Input:		JsonStr : 字段对应的json串
/// Output: 
/// Return: 0 表示 成功 非0表示失败
/// DeBug:  w ##class(BILL.DC.BL.DicDataCtl).UpdaeByJson("{name:"a",b:"b"}","3334")
ClassMethod UpdaeByJson(JsonStr, Id) As %String
{
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.DicDataCtl).UpdaeByJson(JsonStr, Id)开始:",JsonStr, Id)
	s $zt="UpdaeByJsonErr"
	set ^CacheTemp("UpdaDicInfoByJson")=$lb(JsonStr, Id)
	set rtn=0
	set obj=##class(%DynamicAbstractObject).%FromJSON(JsonStr)
	set Data=##class(CT.BILL.DC.DicData).%OpenId(Id,0)
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
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.DicDataCtl).UpdaeByJson(JsonStr, Id)结束:",rtn)
	quit rtn
UpdaeByJsonErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.DicDataCtl).UpdaeByJson(JsonStr, Id)异常",JsonStr, Id,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 删除
/// Table : CF_BILL_DataCheck.UnAuditItm
/// Input:	
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.DicDataCtl).Save(InJson)
ClassMethod Delete(RowId)
{
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.DicDataCtl).Delete(RowId)开始:",RowId)
	s $zt="DeleteErr"
	q:RowId="" "-2"
	s ^CacheTemp("CT_BILL_DC","Save")=$lb(RowId)
	&sql(delete from CT_BILL_DC.DicData where RowId=:RowId)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.DicDataCtl).Delete(RowId)结束:",SQLCODE)
	q SQLCODE
DeleteErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.DicDataCtl).Delete(RowId)异常",RowId,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2022-05-23
/// Descript: 查询
/// Table : CT_BILL_DC.DicData
/// Input:	HospDr ExpStr:是否输出一个全部Y 输出 ,默认不输出|……
/// +DicNum tanfb 2022-09-26
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.DC.BL.DicDataCtl","QueryInfo",2,"","BusinessTypeCode")
Query QueryInfo(HospID = "", KeyCode = "", PDicType = "", ExpStr = "") As websys.Query(ROWSPEC = "DicType,DicCode,DicDesc,DicDemo,ConDesc,ConDemo,ActiveFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,ConCode,DicNum") [ SqlProc ]
{
}

ClassMethod QueryInfoExecute(ByRef qHandle As %Binary, HospID = "", KeyCode = "", PDicType = "", ExpStr = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s ^CacheTemp("BILL.DC.BL.DicDataCtl","QueryInfo")=$lb(HospID,KeyCode,PDicType,ExpStr)
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(KeyCode)
	s QueryAllFlag=$p(ExpStr,"|",1)
	s GYFlag=$p(ExpStr,"|",2) // G 表示查询公有
	s QActFlag=$p(ExpStr,"|",3)
	i QueryAllFlag="Y" d
	.set (DicType,DicCode,DicDesc,DicDemo,ConDesc,ConDemo,ActiveFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,ConCode,Num)=""
	.set DicDesc="全部"
	.d QueryPortList
	i PDicType="SYS" d
	.set (DicType,DicCode,DicDesc,DicDemo,ConDesc,ConDemo,ActiveFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,ConCode,Num)=""
	.set DicDesc="系统"
	.set DicType="SYS"
	.set DicCode="SYS"
	.d QueryPortList
	s Rowid=0
	if PDicType=""{
		f  s Rowid=$o(^CT.BILL.DC.DicDataD(Rowid)) q:Rowid=""  d
		.d BuildDicData
	}else{
		f  s Rowid=$o(^CT.BILL.DC.DicDataI("IndexDicType",PDicType,Rowid)) q:Rowid=""  d
		.d BuildDicData	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
BuildDicData
	s DicCode=$lg(^CT.BILL.DC.DicDataD(Rowid),1)
	s DicDesc=$lg(^CT.BILL.DC.DicDataD(Rowid),2)
	s DicDemo=$lg(^CT.BILL.DC.DicDataD(Rowid),3)
	s ConDesc=$lg(^CT.BILL.DC.DicDataD(Rowid),4)
	s ConDemo=$lg(^CT.BILL.DC.DicDataD(Rowid),5)
	s ActiveFlag=$lg(^CT.BILL.DC.DicDataD(Rowid),6)
	q:(QActFlag'="")&&(QActFlag'=ActiveFlag)
	s HospDr=$lg(^CT.BILL.DC.DicDataD(Rowid),7)
	s CRTER=$lg(^CT.BILL.DC.DicDataD(Rowid),8)
	s CRTEDATE=$lg(^CT.BILL.DC.DicDataD(Rowid),9)
	s:CRTEDATE'="" CRTEDATE=##class(websys.Conversions).DateLogicalToHtml(CRTEDATE)
	s CRTETIME=$lg(^CT.BILL.DC.DicDataD(Rowid),10)
	s:CRTETIME'="" CRTETIME=$zt(CRTETIME)
	s UPDTID=$lg(^CT.BILL.DC.DicDataD(Rowid),11)
	s UPDTDATE=$lg(^CT.BILL.DC.DicDataD(Rowid),12)
	s:UPDTDATE'="" UPDTDATE=##class(websys.Conversions).DateLogicalToHtml(UPDTDATE)
	s UPDTTIME=$lg(^CT.BILL.DC.DicDataD(Rowid),13)
	s:UPDTTIME'="" UPDTTIME=$zt(UPDTTIME)
	s ConCode=$lg(^CT.BILL.DC.DicDataD(Rowid),14)
	s DicType=$lg(^CT.BILL.DC.DicDataD(Rowid),15)
	q:(PDicType="")&&(DicType="SYS")
	s GroupDicCode=DicType
	s:GroupDicCode="SYS" GroupDicCode=DicCode 
	;s HospDr=##class(BILL.DC.HospitalCtl).GetGroupDefaultHospId(GroupDicCode,HospDr)
	q:(GYFlag="G")&&(HospDr'="G")
	q:(GYFlag'="G")&&(HospDr="G")&&(HospID'="G")
	q:(GYFlag'="G")&&(HospDr'=HospID)
	q:(DicType="SYS")&&(DicCode="SYS")
	s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(DicCode,4,"")
	s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(DicDesc,3,"")
	q:($$ALPHAUP^SSUTIL4(DicCode)'[tCodeAndDesc)&&(HZSPCode'[tCodeAndDesc)&&(HZPYCode'[KeyCode)&&(DicCode'[KeyCode)&&(DicDesc'[tCodeAndDesc)&&(DicCode'="SYS")
	d GetDicCodeNum
	d QueryPortList	
	q
	
GetDicCodeNum
    s Num=0
    s ID=0
	if (DicCode=""){
	for {
   		s ID=$o(^CT.BILL.DC.DicDataD(ID)) 
   		q:ID=""  
   		s Num=$i(Num,1)
 	}
	}else{
		 for {
	   		s ID=$o(^CT.BILL.DC.DicDataI("IndexDicType",DicCode,ID)) 
	   		q:ID=""  
	   		s Num=$i(Num,1)
	 	}
	} 
    q
    
QueryPortList
	set Data=$lb(DicType,DicCode,DicDesc,DicDemo,ConDesc,ConDemo,ActiveFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,ConCode,Num)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator: tangzf
/// CreateDate: 2022-05-01
/// Descript: 查询指定字典
/// Table : 
/// Input:	index=2 取字典描述	,=14对照代码，=4，对照描述，3=备注
/// Output: 
/// Return: 
/// DeBug:  w ##class(BILL.DC.BL.DicDataCtl).GetDicInfoByTypeCode("IndiBusinessType", "OrdItem", "2","2")
ClassMethod GetDicInfoByTypeCode(PDicType, PDicCode, HospDr, index = "")
{
	q:(PDicType="")||(PDicCode="")||(HospDr="") ""
	i PDicType="SYS"  s GroupDicCode=PDicCode
 	e  s GroupDicCode=PDicType
	s GroupHosp=##class(BILL.DC.HospitalCtl).GetGroupDefaultHospId(GroupDicCode,HospDr)
	s RowId=$o(^CT.BILL.DC.DicDataI("IndexDicTypeCodeHosp",HospDr,PDicType,PDicCode,""))
	q:RowId="" ""
	s ErrInfo=^CT.BILL.DC.DicDataD(RowId)
	if (+index'=0)&&(index<15)  d
	.s ErrInfo=$lg(ErrInfo,+index)
	q ErrInfo
	//d ##class(CT.BILL.DC.ErrDic).%BuildIndices()
}

}
