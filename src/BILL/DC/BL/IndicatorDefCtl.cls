Class BILL.DC.BL.IndicatorDefCtl Extends (%RegisteredObject, %XML.Adaptor, %ZEN.DataModel.Adaptor)
{

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 新增
/// Table : CT.BILL.DC.IndicatorDef
/// Input:	InJson,SessionStr="UserId^"
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.IndicatorDefCtl).Save(InJson)
ClassMethod Save(InStr, SessionStr) [ ProcedureBlock = 0 ]
{
	new (InStr, SessionStr)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.IndicatorDefCtl).Save(InStr, SessionStr)开始:",InStr, SessionStr)
	s $zt="SaveErr"
	s ^CacheTemp("CT.BILL.DC.IndicatorDef","Save")=$lb(InStr,SessionStr)
	q:InStr="" "-1"
	k PLIST
	s UserId=+SessionStr
	s PLIST(1)=$p(InStr,"^",1) // rowid
	s PLIST(2)=$p(InStr,"^",2) // Code
	s PLIST(3)=$p(InStr,"^",3) // Name
	s PLIST(4)=$p(InStr,"^",4) // IndicatorTypeId
	s PLIST(5)=$p(InStr,"^",5) // CheckType
	s PLIST(6)=$p(InStr,"^",6) // EXlevelId
	s PLIST(7)=$p(InStr,"^",7) // Description
	s PLIST(8)=$p(InStr,"^",8) // ActiveFlag
	s PLIST(9)=$p(InStr,"^",9) // ExecClass
	s PLIST(10)=$p(InStr,"^",10) // ExecClassMethod
	s PLIST(11)=$p(InStr,"^",11) // HOSPID
	s PLIST(18)=$p(InStr,"^",18) // BusinessTypeCode
	s PLIST(19)=$p(InStr,"^",19) // HISVer
	q:PLIST(11)="" "-2^HOSPID"
	s Flag=..CheckUniqueCode(PLIST(11),PLIST(8),PLIST(18),PLIST(2))
	q:(PLIST(6)="L3")&&(PLIST(8)="N") "-3^异常等级为严重的指标不允许停用"
	q:(+Flag>0)&&(+PLIST(1)=0) "-3^新增数据时指标代码重复" 
	q:(+PLIST(1)>0)&&($lg(^CT.BILL.DC.IndicatorDefD(+PLIST(1)),1)'=PLIST(2))&&(+Flag>0) "-3^修改数据时指标代码重复" 
	s RowId=PLIST(1)
	if +RowId=0  d
	.s PLIST(12)= UserId 
	.s PLIST(13)=+$h
	.s PLIST(14)=$p($h,",",2)
	.s PLIST(15)=UserId
	.s PLIST(16)=+$h
	.s PLIST(17)=$p($h,",",2)
	.&sql(insert into CT_BILL_DC.IndicatorDef values PLIST())
	else  d
	.s PLIST(15)=UserId
	.s PLIST(16)=+$h
	.s PLIST(17)=$p($h,",",2)
	.&sql(update CT_BILL_DC.IndicatorDef  values PLIST() where RowId=:RowId)
	s rtn=-1
	if +SQLCODE=0  d
	.s rtn=%ROWID
	else  d
	.s rtn=SQLCODE
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.IndicatorDefCtl).Save(InStr, SessionStr)结束:",rtn)
	q rtn
SaveErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.IndicatorDefCtl).Save(InStr, SessionStr)异常",InStr, SessionStr,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2020-03-09
/// Descript: 更新指定字段
/// Table : 
/// Input:		JsonStr : 字段对应的json串
/// Output: 
/// Return: 0 表示 成功 非0表示失败
/// DeBug:  w ##class(BILL.DC.BL.IndicatorDefCtl).UpdaeByJson("{name:"a",b:"b"}","3334")
ClassMethod UpdaeByJson(JsonStr, Id) As %String
{
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.IndicatorDefCtl).UpdaeByJson(JsonStr, Id)开始:",JsonStr, Id)
	s $zt="UpdaeByJsonErr"
	set ^CacheTemp("BILL.DC.BL.IndicatorDefCtl")=$lb(JsonStr, Id)
	set rtn=0
	set obj=##class(%DynamicAbstractObject).%FromJSON(JsonStr)
	set Data=##class(CT.BILL.DC.IndicatorDef).%OpenId(Id,0)
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
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.IndicatorDefCtl).UpdaeByJson(JsonStr, Id)结束:",rtn)
	quit rtn
UpdaeByJsonErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.IndicatorDefCtl).UpdaeByJson(JsonStr, Id)异常",JsonStr, Id,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 修改有效标志
/// Table : CT.BILL.DC.IndicatorDef
/// Input:	InJson,SessionStr="UserId^"
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.IndicatorDefCtl).ChangeActiveFlagByCodeAndBusTC(InJson)
ClassMethod ChangeActiveFlagByCodeAndBusTC(InStr, SessionStr) [ ProcedureBlock = 0 ]
{
	new (InStr, SessionStr)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.IndicatorDefCtl).ChangeActiveFlagByCodeAndBusTC(InStr, SessionStr)开始:",InStr, SessionStr)
	s $zt="ChangeActiveFlagByCodeAndBusTCErr"
	s ^CacheTemp("CT.BILL.DC.IndicatorDef","ChangeActiveFlagByRowId")=$lb(InStr,SessionStr)
	q:InStr="" "-1"
	s Code=$p(InStr,"^",1)
	s BusinessTypeCode=$p(InStr,"^",2)
	s HospID=$p(InStr,"^",3)
	s UpdtId=+SessionStr
	s UpdtDate=+$h
	s UpdtTime=$p($h,",",2)
	&sql(update CT_BILL_DC.IndicatorDef set ActiveFlag="N",UpdtId=:UpdtId,UpdtDate=:UpdtDate,UpdtTime=:UpdtTime  where Code=:Code and BusinessTypeCode=:BusinessTypeCode)
	s rtn=-1
	if +SQLCODE=0  d
	.s rtn=%ROWID
	else  d
	.if +SQLCODE>0 d
	..s SQLCODE=-SQLCODE
	.s rtn=SQLCODE
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.IndicatorDefCtl).ChangeActiveFlagByCodeAndBusTC(InStr, SessionStr)结束:",rtn)
	q rtn
ChangeActiveFlagByCodeAndBusTCErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.IndicatorDefCtl).ChangeActiveFlagByCodeAndBusTC(InStr, SessionStr)异常",InStr, SessionStr,$ze)
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
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.IndicatorDefCtl).Delete(RowId)开始:",RowId)
	s $zt="DeleteErr"
	q:RowId="" "-2"
	s ^CacheTemp("INSU.MI.PORTCOMMON","Save")=$lb(RowId)
	&sql(delete from CT_BILL_DC.IndicatorDef where RowId=:RowId)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.IndicatorDefCtl).Delete(RowId)结束:",SQLCODE)
	q SQLCODE
DeleteErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.IndicatorDefCtl).Delete(RowId)异常",RowId,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 查询
/// Table : CF_BILL_DC.UnAuditItm
/// Input:	HospDr
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.DC.BL.IndicatorDefCtl","QueryInfo")
Query QueryInfo(HospID = "", PCheckType = "", KeyCode = "", QBusinessType = "", QName = "", QExceptionLeval = "", QHISVer = "", PCheckFlag = "") As websys.Query(ROWSPEC = "Code,Name,IndicatorTypeId,CheckType,EXlevelId,Description,ActiveFlag,ExecClass,ExecClassMethod,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,BusinessTypeCode,BusinessTypeDesc,HISVer,ReferenceHISVer,IndicatorTypeDesc,EXlevelDesc,CheckTypeDesc") [ SqlProc ]
{
}

ClassMethod QueryInfoExecute(ByRef qHandle As %Binary, HospID = "", PCheckType = "", KeyCode = "", QBusinessType = "", QName = "", QExceptionLeval = "", QHISVer = "", PCheckFlag = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s ^CacheTemp("QueryInfo","QueryInfo")=$lb(HospID, PCheckType , KeyCode, QBusinessType , QName , QExceptionLeval , QHISVer,PCheckFlag)
	//s QHISVer=$ListBuild(QHISVer)
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(KeyCode)
	s Rowid=0
	f  s Rowid=$o(^CT.BILL.DC.IndicatorDefD(Rowid)) q:Rowid=""  d
	.s Code=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),1)
	.s Name=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),2)
	.q:(QName'="")&&(QName'=Name)
	.s IndicatorTypeId=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),3)
	.s CheckType=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),4)
	.q:(PCheckType'="")&&(PCheckType'=CheckType)
	.s EXlevelId=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),5)
	.s Description=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),6)
	.s ActiveFlag=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),7)
	.s ExecClass=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),8)
	.s ExecClassMethod=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),9)
	.s HospDr=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),10)
	.s CRTER=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),11)
	.s CRTEDATE=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),12)
	.s:CRTEDATE'="" CRTEDATE=$zd(CRTEDATE,3) //##class(websys.Conversions).DateLogicalToHtml(CRTEDATE)
	.s CRTETIME=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),13)
	.s:CRTETIME'="" CRTETIME=$zt(CRTETIME)
	.s UPDTID=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),14)
	.s UPDTDATE=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),15)
	.s:UPDTDATE'="" UPDTDATE=$zd(UPDTDATE,3) //##class(websys.Conversions).DateLogicalToHtml(UPDTDATE)
	.s UPDTTIME=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),16)
	.s:UPDTTIME'="" UPDTTIME=$zt(UPDTTIME)
	.;q:(HospID'="")&&(HospID'=HospDr)
	.s BusinessTypeCode=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),17)
	.s HISVer=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),18)
	.s ReferenceHISVer=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),19)
	.s IndicatorTypeDesc=##class(BILL.DC.BL.DicDataCtl).GetDicInfoByTypeCode("IndiType", IndicatorTypeId, "G","2")
	.s EXlevelDesc=##class(BILL.DC.BL.DicDataCtl).GetDicInfoByTypeCode("ExceptionLevel", EXlevelId, "G","2")
	.s CheckTypeDesc=##class(BILL.DC.BL.DicDataCtl).GetDicInfoByTypeCode("CheckType", CheckType, "G","2")
	.q:..CheckHisVer(BusinessTypeCode,Code,HospID)="0"
	.s QHISVerCount=$l(QHISVer,",")
	.s QHISVerFlag="N" 
	.if (QHISVer'="") d
	..s HISVerList=$LISTFROMSTRING(HISVer,",")
	..f HisVerIndex=1:1:QHISVerCount  d
	...s QHISVerNew=$p(QHISVer,",",HisVerIndex)
	...if $LISTFIND(HISVerList,QHISVerNew)'=0 d
	....s QHISVerFlag="Y"
	.q:(QHISVer'="")&&(QHISVerFlag="N")
	.q:(PCheckFlag'="")&&(ActiveFlag'=PCheckFlag)
	.q:(QExceptionLeval'="")&&(QExceptionLeval'=EXlevelId)
	.q:(QBusinessType'="")&&(QBusinessType'=BusinessTypeCode)
	.s BusinessTypeDesc=##class(BILL.DC.BL.DicDataCtl).GetDicInfoByTypeCode("BusinessTypeCode", BusinessTypeCode, "G","2")
	.q:($$ALPHAUP^SSUTIL4(Code)'[tCodeAndDesc)&&(BusinessTypeCode'[tCodeAndDesc)&&(BusinessTypeDesc'[KeyCode)&&(Name'[KeyCode)&&(CheckType'[KeyCode)&&(ExecClassMethod'[KeyCode)&&(ExecClass'[tCodeAndDesc)
	.d QueryPortList	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryPortList
	set Data=$lb(Code,Name,IndicatorTypeId,CheckType,EXlevelId,Description,ActiveFlag,ExecClass,ExecClassMethod,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,BusinessTypeCode,BusinessTypeDesc,HISVer,ReferenceHISVer,IndicatorTypeDesc,EXlevelDesc,CheckTypeDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator：      tangzf
/// CreatDate：    2022-05-19
/// Description：  获取指标RowId
/// Table：        
/// input:		   
/// Output：       
/// Debug：       w ##class(BILL.DC.BL.IndicatorDefCtl).CheckUniqueCode(2,"Y","CT","04")
ClassMethod CheckUniqueCode(HospDr, ActFlag, BusinessType, IndiCode)
{
	q:(HospDr="")||(ActFlag="")||(IndiCode="")||(BusinessType="") "-1"
	s Rowid=+$o(^CT.BILL.DC.IndicatorDefI("IndexUnique","G",ActFlag,BusinessType,IndiCode,""))
	q Rowid
}

/// Creator：      tangzf
/// CreatDate：    2022-05-19
/// Description：  根据指标代码取最新序号
/// Table：        
/// input:		   
/// Output：       
/// Debug：       w ##class(BILL.DC.BL.IndicatorDefCtl).GetNewIndiCode(2,"Y","COM")
ClassMethod GetNewIndiCode(HospDr, ActFlag, BusinessType)
{
	q:(HospDr="")||(ActFlag="")||(BusinessType="") "-1"
	s ^CacheTemp("GetNewIndiCode")=$lb(HospDr, ActFlag, BusinessType)
	s IndiCode=$o(^CT.BILL.DC.IndicatorDefI("IndexUnique","G",ActFlag,BusinessType,""),-1)
	i IndiCode="" s IndiCode="01"
	e  d 
	.s IndiCode=IndiCode+1
	s:$l(IndiCode)=1 IndiCode="0"_IndiCode
	;d:+$o(^CT.BILL.DC.IndicatorDefI("IndexUnique",HospDr,ActFlag,BusinessType,IndiCode,""))>0 ..GetNewIndiCode(HospDr, ActFlag, BusinessType)

	q IndiCode
}

// Creator：      tangzf

/// CreatDate：    2022-05-19
/// Description：  根据指标代码取指标信息
/// Table：        
/// input:		   index=4 CheckType ,6=监控点说明
/// Output：       
/// Debug：       w ##class(BILL.DC.BL.IndicatorDefCtl).GetIndiInfo(2,"Y","OPBILL","12","13")
ClassMethod GetIndiInfo(HospDr, ActFlag, BusinessType, IndiCode, index = "")
{
	q:(HospDr="")||(ActFlag="")||(IndiCode="")||(BusinessType="") "-1"
	s Rowid=+$o(^CT.BILL.DC.IndicatorDefI("IndexUnique","G",ActFlag,BusinessType,IndiCode,""))
	q:+Rowid=0 "-2"
	s ErrInfo=^CT.BILL.DC.IndicatorDefD(Rowid)
	if (+index'=0)&&(index<19)  d 
	.s ErrInfo=$lg(ErrInfo,+index)
	if index=""  d
	.s ErrInfo=$LISTTOSTRING(ErrInfo,"^")
	q ErrInfo
}

/// Creator：      tangzf
/// CreatDate：    2022-05-12
/// Description：  根据HIS版本判断指标是否需要核查
/// Table：        
/// input: BussinessType 业务类型,	IndiCode:指标代码	   
/// Output： 0 不需要校验 1 满足版本核查 需要校验      
/// Debug：        
///  d ##class(BILL.DC.Check).CheckHisVer(BussinessType)
/// 
ClassMethod CheckHisVer(BussinessType, IndiCode, HospDr)
{

	q:HospDr="" "1" //查所有
	s CurHISVer=##class(BILL.DC.BL.DicDataCtl).GetDicInfoByTypeCode("SYS","HISVer",HospDr,14)
	s IndiHisVer=##class(BILL.DC.BL.IndicatorDefCtl).GetIndiInfo("G","Y",BussinessType,IndiCode,18)
	if ((IndiHisVer[CurHISVer)||(IndiHisVer=CurHISVer))&&(CurHISVer'=""){
		q "1"	
	}else{
		q "0"	
	}
	;q:(BussinessType="BILLREP")&&(HISVer'="")&&(+HISVer<8.2) 0 // 报表相关指标从8.2以后开始校验
	;q:(UniqueCode="CT01")&&(HISVer'="")&&(+HISVer<8.2) 0 // 院区相关指标从8.2以后开始校验
	q "1"
}

}
