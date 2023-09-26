/// 免审核项目操作类
Class BILL.DC.BL.UnAuditItmCtl Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 新增
/// Table : CF.BILL.DataCheck.UnAuditItm
/// Input:	InJson,SessionStr="UserId^"
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.UnAuditItmCtl).Save(InJson)
/// w ##class(BILL.DC.BL.UnAuditItmCtl).Save("312^CT||14^TarItem^无^^63^锡类散[1g*1]^Y^2^^^^^^^^2022-09-15^16:00:00^测试","1")
ClassMethod Save(InStr, SessionStr)
{
	new (InStr, SessionStr)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.UnAuditItmCtl).Save(InStr, SessionStr)开始:",InStr, SessionStr)
	s $zt="SaveErr"
	s ^CacheTemp("BILL.DataCheck.BL.UnAuditItmComCtl","Save")=$lb(InStr,SessionStr)
	q:InStr="" "-1"
	k PLIST
	s UserId=+SessionStr
	s PLIST(1)=$p(InStr,"^",1) // rowid
	s PLIST(2)=$p(InStr,"^",2) // IndicatorId
	s PLIST(3)=$p(InStr,"^",3) // CateCode
	s PLIST(4)=$p(InStr,"^",4) // CateDesc
	s PLIST(5)=$p(InStr,"^",5) // CateDataSrc
	s ConfigValue=$p(InStr,"^",6) //ConfigValue保存的是rowid
	s PLIST(8)=$p(InStr,"^",8) // ActiveFlag
	if ($p(InStr,"^",6)="")&&($p(InStr,"^",10)'="") //导入的时候，没有收费项/医嘱项rowid，只有收费项/医嘱项code
	{
		if ($p(InStr,"^",3)="ArcItm")
		{
			q:$d(^ARCIM(0,"Code",$p(InStr,"^",10)))=0 "-2"
			s rtnStr=$o(^ARCIM(0,"Code",$p(InStr,"^",10),""))
			s:rtnStr'="" ConfigValue=rtnStr_"||1"
		}
		elseif($p(InStr,"^",3)="TarItm")
		{
			s ConfigValue=$o(^DHCTARI(0,"Code",$p(InStr,"^",10),""))
		}
		s PLIST(8)="N" // ActiveFlag
	}
	s PLIST(6)= ConfigValue
	s PLIST(7)=$p(InStr,"^",7) // ConfigDesc
	;s PLIST(9)=$p(InStr,"^",9) // HospDr
	s HospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("CF_BILL_DC.UnAuditItm", $p(InStr,"^",9))
	s PLIST(9)=HospID // HospDr
	s PLIST(16)="" // AuditId
	s PLIST(17)="" // AuditDate
	s PLIST(18)="" // AuditTime
	s PLIST(19)="" //AuditMemo
	q:PLIST(9)="" "-2^HOSPID"
	//zhangjb 2022/06/23 增加校验保存免审项是否已存在
	//HospDr, IndicatorId, CateCode, ActiveFlag, ConfigValue
	s CheckIndex=..CheckIndexExistence($p(InStr,"^",9), $p(InStr,"^",2), $p(InStr,"^",3), $p(InStr,"^",8), ConfigValue) // 0不存在，1存在
	q:CheckIndex="1" "-1"
	
	s RowId=PLIST(1)
	if +RowId=0  d
	.s PLIST(10)= UserId 
	.s PLIST(11)=+$h
	.s PLIST(12)=$p($h,",",2)
	.s PLIST(13)=UserId
	.s PLIST(14)=+$h
	.s PLIST(15)=$p($h,",",2)
	.&sql(insert into CF_BILL_DC.UnAuditItm values PLIST())
	else  d
	.s PLIST(13)=UserId
	.s PLIST(14)=+$h
	.s PLIST(15)=$p($h,",",2)
	.&sql(update CF_BILL_DC.UnAuditItm  values PLIST() where RowId=:RowId)
	s rtn=-1
	if +SQLCODE=0  d
	.s rtn=%ROWID
	else  d
	.s rtn=SQLCODE
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.UnAuditItmCtl).Save(InStr, SessionStr)结束:",rtn)
	q rtn
SaveErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.UnAuditItmCtl).Save(InStr, SessionStr)异常",InStr, SessionStr,$ze)
	q "-2"
}

/// Creator: Lizhi
/// CreateDate: 2020-03-09
/// Descript: 保存审核人等信息
/// Table : 
/// Input:		
/// Output: 
/// Return: 0 表示 成功 非0表示失败
/// DeBug:  w ##class(BILL.DC.BL.UnAuditItmCtl).SaveAudit("302^Y^审核备注","3334")
ClassMethod SaveAudit(InStr, SessionStr)
{
	new (InStr, SessionStr)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.UnAuditItmCtl).SaveAudit(InStr, SessionStr)开始:",InStr, SessionStr)
	s $zt="SaveAuditErr"
	s ^CacheTemp("BILL.DataCheck.BL.UnAuditItmComCtl","Save")=$lb(InStr,SessionStr)
	q:InStr="" "-1"
	k PLIST
	s UserId=+SessionStr
	s PLIST(1)=$p(InStr,"^",1) // rowid
	s PLIST(8)=$p(InStr,"^",2) // ActiveFlag
	s PLIST(19)=$p(InStr,"^",3) // AuditMemo
	s PLIST(16)=UserId  // AuditId
	s PLIST(17)=+$h // AuditDate
	s PLIST(18)=$p($h,",",2) // AuditTime
	s RowId=PLIST(1)
	q:RowId="" "rowid不能为空"
	&sql(update CF_BILL_DC.UnAuditItm  values PLIST() where RowId=:RowId)
	s rtn=-1
	if +SQLCODE=0  d
	.s rtn=%ROWID
	else  d
	.s rtn=SQLCODE
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.UnAuditItmCtl).SaveAudit(InStr, SessionStr)结束:",rtn)
	q rtn
SaveAuditErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.UnAuditItmCtl).SaveAudit(InStr, SessionStr)异常",InStr, SessionStr,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 删除
/// Table : CF_BILL_DataCheck.UnAuditItm
/// Input:	
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.UnAuditItmCtl).Delete(RowId)
ClassMethod Delete(RowId)
{
	new (RowId)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.UnAuditItmCtl).Delete(RowId)开始:",RowId)
	s $zt="DeleteErr"
	q:RowId="" "-2"
	s ^CacheTemp("INSU.MI.PORTCOMMON","Save")=$lb(RowId)
	&sql(delete from CF_BILL_DC.UnAuditItm where RowId=:RowId)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.UnAuditItmCtl).Delete(RowId)结束:",SQLCODE)
	q SQLCODE
DeleteErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.UnAuditItmCtl).Delete(RowId)异常",RowId,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 停用
/// Table : CF_BILL_DataCheck.UnAuditItm
/// Input:	
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.UnAuditItmCtl).Stop(RowId,SessionStr)
ClassMethod Stop(RowId, SessionStr)
{
	new (RowId,SessionStr)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.UnAuditItmCtl).Stop(RowId,SessionStr)开始:",RowId,SessionStr)
	s $zt="StopErr"
	q:RowId="" "-2"
	s Data=+$h
	s Time=$p($h,",",2)
	s UpdtId=+SessionStr
	s ^CacheTemp("INSU.MI.PORTCOMMON","Stop")=$lb(RowId)
	&sql(UPDATE CF_BILL_DC.UnAuditItm SET ActiveFlag="N",AuditMemo="停用",AuditId="",AuditDate=Null,AuditTime=Null,UpdtId=:UpdtId,UpdtDate=:Data,UpdtTime=:Time where RowId=:RowId)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.UnAuditItmCtl).Stop(RowId,SessionStr)结束:",SQLCODE)
	q SQLCODE
StopErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.UnAuditItmCtl).Stop(RowId,SessionStr)异常",RowId,SessionStr,$ze)
	q "-2"
}

/// Creator: Lizhi
/// CreateDate: 2023-05-11
/// Descript: 启用
/// Table : CF_BILL_DataCheck.UnAuditItm
/// Input:	
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.UnAuditItmCtl).Open(RowId,SessionStr)
ClassMethod Open(RowId, SessionStr)
{
	new (RowId,SessionStr)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.UnAuditItmCtl).Open(RowId, SessionStr)开始:",RowId,SessionStr)
	s $zt="OpenErr"
	q:RowId="" "-2"
	s Data=+$h
	s Time=$p($h,",",2)
	s UpdtId=+SessionStr
	s ^CacheTemp("INSU.MI.PORTCOMMON","Open")=$lb(RowId)
	&sql(UPDATE CF_BILL_DC.UnAuditItm SET ActiveFlag="N",AuditMemo="",AuditId="",UpdtId=:UpdtId,UpdtDate=:Data,UpdtTime=:Time where RowId=:RowId)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.UnAuditItmCtl).Open(RowId, SessionStr)结束:",SQLCODE)
	q SQLCODE
OpenErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.UnAuditItmCtl).Open(RowId, SessionStr)异常",RowId,SessionStr,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 查询
/// Table : CF_BILL_DC.UnAuditItm
/// Input:	HospDr
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.DC.BL.UnAuditItmCtl","QueryUnAuditItm",2,"","TarItem")
Query QueryUnAuditItm(HospID, KeyCode, CateCode, BusinessType = "", IndexCode = "", ExamineFlag = "") As websys.Query(ROWSPEC = "IndicatorId,IndicatorName,CateCode,CateDesc,CateDataSrc,ConfigValue,ConfigDesc,ActiveFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,BusinessTypeName,AuditId,AuditDate,AuditTime,AuditMemo") [ SqlProc ]
{
}

ClassMethod QueryUnAuditItmExecute(ByRef qHandle As %Binary, HospID, KeyCode, CateCode, BusinessType = "", IndexCode = "", ExamineFlag = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s ^CacheTemp("INSU.MI.PortCommonCom","QueryPortCommon")=$lb(HospID, KeyCode, CateCode, BusinessType, IndexCode, ExamineFlag)
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(KeyCode)
	s Rowid=0
	set HospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("CF_BILL_DC.UnAuditItm", HospID)
	f  s Rowid=$o(^CF.BILL.DC.UnAuditItmD(Rowid)) q:Rowid=""  d
	.s IndicatorId=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),1)
	.s CateCodeD=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),2)
	.s CateDesc=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),3)
	.s CateDataSrc=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),4)
	.s ConfigValue=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),5)
	.s ConfigDesc=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),6)
	.if (ConfigDesc="")&&(CateCode="TarItem") d  //zjb 2022/07/05,分类代码为‘TarItem’时，如果备注为空，通过DHC_TarItem
	..s ConfigDesc=..GetDHCTarItemByRowid(ConfigValue)
	.s ActiveFlag=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),7)
	.s HospDr=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),8)
	.s CRTER=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),9)
	.s:CRTER'="" CRTER=$p($g(^SSU("SSUSR",CRTER)),"^",2)
	.s CRTEDATE=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),10)
	.s CRTETIME=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),11)
	.s UPDTID=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),12)
	.s:UPDTID'="" UPDTID=$p($g(^SSU("SSUSR",UPDTID)),"^",2)
	.s UPDTDATE=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),13)
	.s UPDTTIME=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),14)
	.s AuditId=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),15)
	.s:AuditId'="" AuditId=$p($g(^SSU("SSUSR",AuditId)),"^",2)
	.s AuditDate=##class(websys.Conversions).DateLogicalToHtml($lg(^CF.BILL.DC.UnAuditItmD(Rowid),16))
	.s AuditTime=##class(websys.Conversions).TimeLogicalToHtml($lg(^CF.BILL.DC.UnAuditItmD(Rowid),17))
	.s CRTEDATE=##class(websys.Conversions).DateLogicalToHtml(CRTEDATE)
	.s CRTETIME=##class(websys.Conversions).TimeLogicalToHtml(CRTETIME)
	.s UPDTDATE=##class(websys.Conversions).DateLogicalToHtml(UPDTDATE)
	.s UPDTTIME=##class(websys.Conversions).TimeLogicalToHtml(UPDTTIME)
	.s AuditMemo=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),18)
	.s BusinessTypeName=##class(BILL.DC.BL.DicDataCtl).GetDicInfoByTypeCode("BusinessTypeCode",$p(IndicatorId,"||",1) , HospDr,"2")
	.s IndicatorName=..GetIndexName(HospDr,"Y",$p(IndicatorId,"||",1),$p(IndicatorId,"||",2)) //拿免审核得生效标志去查询指标名字，两个标志不一样名字就会为空
	.if IndicatorName="" d
	..s IndicatorName=..GetIndexName(HospDr,"N",$p(IndicatorId,"||",1),$p(IndicatorId,"||",2))
	.q:(HospID'="")&&(HospID'=HospDr)
	.q:(BusinessType'="")&&(BusinessType'=$p(IndicatorId,"||",1)&&($p(IndicatorId,"||",1)'="ALL"))
	.q:(IndexCode'="")&&(IndexCode'=$p(IndicatorId,"||",2))
	.q:(ExamineFlag'="")&&(ExamineFlag="Y")&&(ActiveFlag'="Y") //只查询已经审核过的项目
	.q:(ExamineFlag'="")&&(ExamineFlag="N")&&(((ActiveFlag'="N")&&(AuditId'=""))||((ActiveFlag="N")&&(AuditId=""))) //只查询拒绝审核过的项目
	.q:(ExamineFlag'="")&&(ExamineFlag="W")&&(AuditId'="") //只查询未审核过的项目
	.q:(IndicatorId'[tCodeAndDesc)&&(ConfigValue'[tCodeAndDesc)&&(IndicatorName'[KeyCode)&&(ConfigDesc'[KeyCode)
	.q:(CateCodeD'=CateCode)
	.d QueryPortList	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryPortList
	set Data=$lb(IndicatorId,IndicatorName,CateCode,CateDesc,CateDataSrc,ConfigValue,ConfigDesc,ActiveFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,BusinessTypeName,AuditId,AuditDate,AuditTime,AuditMemo)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator: zjb
/// CreateDate: 2022-05-11
/// Descript: 判断传入的项目是否属于免审核项目
/// Table : CF.BILL.DataCheck.UnAuditItm
/// Input:	HospDr:院区ID，IndicatorCode：指标代码(传'空' 或 'ALL'  表示不按指标校验),CateCode:规则分类 先传TarItem,ConfigValue ，规则值：先传收费项目ID
/// Output: 
/// Return: Y 属于 免审核项目，N不属于免审核项目
/// w ##class(BILL.DC.BL.UnAuditItmCtl).CheckUnAuditItm(2,"COM||13","TarItem",63) 
/// w ##class(BILL.DC.BL.UnAuditItmCtl).CheckUnAuditItm(HospDr,IndicatorId,CateCode,ConfigValue)
ClassMethod CheckUnAuditItm(HospDr, IndicatorId, CateCode, ConfigValue)
{
	new (HospDr, IndicatorId, CateCode, ConfigValue)
	set:(IndicatorId="") IndicatorId="ALL"
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("CF_BILL_DC.UnAuditItm", HospDr)
	set Rowid=$o(^CF.BILL.DC.UnAuditItmI("IndexActiveData",defHospId,IndicatorId,CateCode,"Y",ConfigValue,""))
	if (IndicatorId'="ALL")&&(+Rowid=0) //指标不为ALL,查询一下ALL下面的数据
	{
		s IndicatorId="ALL"
		set Rowid=$o(^CF.BILL.DC.UnAuditItmI("IndexActiveData",defHospId,IndicatorId,CateCode,"Y",ConfigValue,""))
	}
	quit $s((+Rowid'=0):"Y",1:"N")
}

/// Creator: zhangjb
/// CreateDate: 2022-06-17
/// Descript: 获取费用项目：DHC_TarItem
/// Table : CF_BILL_DC.UnAuditItm
/// Input:	
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.DC.BL.UnAuditItmCtl","QueryDHCTarItem")
Query QueryDHCTarItem(HospID = "", Key = "") As websys.Query(ROWSPEC = "TARIRowid,TARIDesc") [ SqlProc ]
{
}

ClassMethod QueryDHCTarItemExecute(ByRef qHandle As %Binary, HospID = "", Key = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s ^CacheTemp("BILL.DC.BL.UnAuditItmCtl","QueryDHCTarItem")=$lb(HospID,Key)
	s TARIRowid=0
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(Key)
	
	f  s TARIRowid=$o(^DHCTARI(TARIRowid)) q:TARIRowid=""  d
	.s ChildSub="0"
	.s flag="N" //是否属于本院区 N不属于，Y属于
	.if HospID'="" d
	..s flag=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("DHC_TarItem",TARIRowid,HospID,"","Y")
	.q:(HospID'="")&&(flag="N")
	.s TARIData=$g(^DHCTARI(TARIRowid))
	.q:TARIData=""
	.s TARIDesc=$p(TARIData,"^",2)
	.s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(TARIDesc,4,"")
	.s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(TARIDesc,3,"")
	.q:(Key'="")&&(($$ALPHAUP^SSUTIL4($p(TARIData,"^",1))'[tCodeAndDesc)&&(HZSPCode'[tCodeAndDesc)&&(HZPYCode'[Key)&&($p(TARIData,"^",1)'[Key)&&(TARIDesc'[Key)&&(TARIDesc'[tCodeAndDesc))
	.d QueryTarItem
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryTarItem
	set Data=$lb(TARIRowid,TARIDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator: Lizhi
/// CreateDate: 2022-09-21
/// Descript: 获取医嘱项目：ARC_ItmMast
/// Table : CF_BILL_DC.UnAuditItm
/// Input:	
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.DC.BL.UnAuditItmCtl","QueryARCItmMast")
Query QueryARCItmMast(HospID = "", Key = "") As websys.Query(ROWSPEC = "TARIRowid,TARIDesc") [ SqlProc ]
{
}

ClassMethod QueryARCItmMastExecute(ByRef qHandle As %Binary, HospID = "", Key = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(Key)
	s ^CacheTemp("BILL.DC.BL.UnAuditItmCtl","QueryARCItmMast")=$lb(HospID,Key)
	s ARCIMRowId=0
	f  s ARCIMRowId=$o(^ARCIM(ARCIMRowId)) q:ARCIMRowId=""  d
	.s ARCIMData=$g(^ARCIM(ARCIMRowId,"1","1"))
	.q:ARCIMData=""
	.s TARIRowid=ARCIMRowId_"||"_"1"
	.s flag="N" //是否属于本院区 N不属于，Y属于
	.s ARCItmHosDR="0"
	.f  s ARCItmHosDR=$o(^ARCIM(ARCIMRowId,"1","HOSP",0,"Hosp",ARCItmHosDR)) q:(ARCItmHosDR="")||(flag="Y")  d
	..if ARCItmHosDR=HospID d
	...s flag="Y"
	.q:(HospID'="")&&(flag="N")
	.s TARIDesc=$p(ARCIMData,"^",2)
	.s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(TARIDesc,4,"")
	.s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(TARIDesc,3,"")
	.q:(Key'="")&&(($$ALPHAUP^SSUTIL4($p(ARCIMData,"^",1))'[tCodeAndDesc)&&(HZSPCode'[tCodeAndDesc)&&(HZPYCode'[Key)&&($p(ARCIMData,"^",1)'[Key)&&(TARIDesc'[Key)&&(TARIDesc'[tCodeAndDesc))
	.d QueryARCItm
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryARCItm
	set Data=$lb(TARIRowid,TARIDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator: zhangjb
/// CreateDate: 2022-06-17
/// Descript: 校验指标是否存在
/// Table : CF_BILL_DC.UnAuditItm
/// Input:	HospDr：医院id, IndicatorId：业务类型ID||指标ID, CateCode：分类代码，暂传"TarItem", ActiveFlag:有效标志Y/N, ConfigValue:配置值
/// Output: 0不存在，1存在
/// Return: 
/// w ##class(BILL.DC.BL.UnAuditItmCtl).CheckIndexExistence(2,"COM||13","TarItem","Y","63")
ClassMethod CheckIndexExistence(HospDr, IndicatorId, CateCode, ActiveFlag, ConfigValue)
{
	//Index IndexActiveData On (HospDr As Exact, IndicatorId As Exact, CateCode As Exact, ActiveFlag As Exact, ConfigValue As Exact);
	New (HospDr,IndicatorId,CateCode,ActiveFlag,ConfigValue)
	set:(IndicatorId="") IndicatorId="ALL"
	set HospDr=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("CF_BILL_DC.UnAuditItm", HospDr)
	s Rowid=$o(^CF.BILL.DC.UnAuditItmI("IndexActiveData",HospDr,IndicatorId,CateCode,"N",ConfigValue,""))
	if Rowid="" d
	.s Rowid=$o(^CF.BILL.DC.UnAuditItmI("IndexActiveData",HospDr,IndicatorId,CateCode,"Y",ConfigValue,""))
	q:Rowid="" "0"
	q:Rowid'="" "1"
}

/// Creator: zhangjb
/// CreateDate: 2022-06-17
/// Descript: 通过rowid获取费用项目：DHC_TarItem
/// Table : CF_BILL_DC.UnAuditItm
/// Input:	
/// Output: 
/// Return: 
/// d ##class(BILL.DC.BL.UnAuditItmCtl).GetDHCTarItemByRowid()
ClassMethod GetDHCTarItemByRowid(TARIRowid)
{
	New (TARIRowid)
	if TARIRowid="" Quit $$$OK

	s TARIData=$g(^DHCTARI(TARIRowid))
	q:TARIData="" ""
	s TARIDesc=$p(TARIData,"^",2)
	q:TARIDesc="" ""
	q TARIDesc
}

/// Creator: zhangjb
/// CreateDate: 2022-06-20
/// Descript: 获取指标名称
/// Table : CF_BILL_DC.UnAuditItm
/// Input:	HospDr医院id，ActiveFlag有效标志，BusinessTypeCode指标业务类型，Code指标代码
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.UnAuditItmCtl).GetIndexName("2","Y","CT","98")
ClassMethod GetIndexName(HospDr, ActiveFlag, BusinessTypeCode, Code)
{
	New (HospDr, ActiveFlag, BusinessTypeCode, Code)
	if (HospDr="")||(ActiveFlag="")||(BusinessTypeCode="")||(Code="") q ""
	s Rowid=$o(^CT.BILL.DC.IndicatorDefI("IndexUnique","G",ActiveFlag,BusinessTypeCode,Code,""))
	q:Rowid="" ""
	s IndexName=$lg(^CT.BILL.DC.IndicatorDefD(Rowid),2)
	q IndexName
	//w "IndexNmae:",IndexData,!
}

/// Creator: zhangjb
/// CreateDate: 2022-08-09
/// Descript: 复制指定指标下的免审项添加到新指标
/// Table : CF_BILL_DC.UnAuditItm
/// Input:	HospDr医院id，ActiveFlag有效标志，BusinessTypeCode指标业务类型，Code指标代码
/// Output: 
/// Return: 
/// d ##class(BILL.DC.BL.UnAuditItmCtl).CopyIndexUnAditItm(2,"COM||99","TarItem","COM||98","TarItem","1")
ClassMethod CopyIndexUnAditItm(HospDr, IndicatorId, CateCode, NewIndicatorId, NewCateCode, UserID)
{
	New (HospDr,IndicatorId,CateCode, NewIndicatorId, NewCateCode, UserID)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.UnAuditItmCtl).CopyIndexUnAditItm(HospDr, IndicatorId, CateCode, NewIndicatorId, NewCateCode, UserID)开始:",HospDr, IndicatorId, CateCode, NewIndicatorId, NewCateCode, UserID)
	s $zt="CopyIndexUnAditItmErr"
	s ConfigValue=""
	s Rowid=""
    for  s ConfigValue=$o(^CF.BILL.DC.UnAuditItmI("IndexActiveData",HospDr,IndicatorId,CateCode,"Y",ConfigValue)) q:ConfigValue=""  d
    .for  s Rowid=$o(^CF.BILL.DC.UnAuditItmI("IndexActiveData",HospDr,IndicatorId,CateCode,"Y",ConfigValue,Rowid)) q:Rowid=""  d
    ..s CateCodeD=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),2) //CateCodeD
	..s CateDesc=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),3) //CateDesc
	..s CateDataSrc=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),4) //CateDataSrc
	..s ConfigValue=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),5) //ConfigValue
	..s ConfigDesc=$lg(^CF.BILL.DC.UnAuditItmD(Rowid),6) //ConfigDesc
	..if (ConfigDesc="")&&(CateCode="TarItem") d  //zjb 2022/07/05,分类代码为‘TarItem’时，如果备注为空，通过DHC_TarItem
	...s ConfigDesc=..GetDHCTarItemByRowid(ConfigValue)
	..d CopyIndexItm
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.UnAuditItmCtl).CopyIndexUnAditItm(HospDr, IndicatorId, CateCode, NewIndicatorId, NewCateCode, UserID)结束:","")
	q ""
CopyIndexUnAditItmErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.UnAuditItmCtl).CopyIndexUnAditItm(HospDr, IndicatorId, CateCode, NewIndicatorId, NewCateCode, UserID)异常",HospDr, IndicatorId, CateCode, NewIndicatorId, NewCateCode, UserID,$ze)
	q "-2"
CopyIndexItm
	k PLIST
	
	s PLIST(1)="" // rowid
	s PLIST(2)=NewIndicatorId // IndicatorId
	s PLIST(3)=NewCateCode // CateCode
	s PLIST(4)=CateDesc // CateDesc
	s PLIST(5)=CateDataSrc // CateDataSrc
	s PLIST(6)=ConfigValue // ConfigValue
	s PLIST(7)=ConfigDesc // ConfigDesc
	s PLIST(8)="Y" // ActiveFlag
	s PLIST(9)=HospDr // HospDr
	s PLIST(10)=+UserID 
	s PLIST(11)=+$h
	s PLIST(12)=$p($h,",",2)
	s PLIST(13)=+UserID
	s PLIST(14)=+$h
	s PLIST(15)=$p($h,",",2)
	
	//zhangjb 2022/06/23 增加校验保存免审项是否已存在
	//HospDr, IndicatorId, CateCode, ActiveFlag, ConfigValue
	s CheckIndex=..CheckIndexExistence(HospDr, NewIndicatorId, NewCateCode, "Y", ConfigValue) // 0不存在，1存在
	b //111
	q:CheckIndex="1" "-1"
	&sql(insert into CF_BILL_DC.UnAuditItm values PLIST())
}

/// Creator: Lizhi
/// CreateDate: 2022-05-11
/// Descript: 自动查询插入免审核
/// Table : CF_BILL_DataCheck.UnAuditItm
/// Input:	
/// Output: 
/// Return: 
/// w ##class(BILL.DC.BL.UnAuditItmCtl).GetUnAuditItmFromAuto(2)
ClassMethod GetUnAuditItmFromAuto(HospDr)
{
	new (HospDr)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.UnAuditItmCtl).GetUnAuditItmFromAuto(HospDr)开始:",HospDr)
	s $zt= "GetUnAuditItmFromAutoErr"
	s RowId=""
	s rtn=0
	s DicDescStr=""
	f  s RowId=$o(^CT.BILL.DC.DicDataI("IndexDicTypeHosp",HospDr,"UnAuditWords",RowId)) q:RowId=""  d
	.if DicDescStr="" d
	..s DicDescStr=$lg(^CT.BILL.DC.DicDataD(RowId),2)
	.else  d
	..s DicDescStr=DicDescStr_"^"_$lg(^CT.BILL.DC.DicDataD(RowId),2)
	s RowId=""
	f  s RowId = $o(^DHCTARI(RowId)) q:RowId=""   d
	.q:(+RowId=0)
	.q:$g(^DHCTARI(RowId))=""
	.q:$p(^DHCTARI(RowId),"^",7)'="Y" //过滤无效标志
	.s TARIDesc=$p(^DHCTARI(RowId),"^",2) //收费项目名称
	.s DicDescCount=1
	.f  s DicDesc=$p(DicDescStr,"^",DicDescCount) q:DicDesc=""  d
	..s DicDescCount=DicDescCount+1
	..if TARIDesc[DicDesc d
	...s InStr="^COM||98^TarItem^无^^"_RowId_"^"_TARIDesc_"^N^"_HospDr //拼凑免审核保存入参
	...d ##class(BILL.DC.BL.UnAuditItmCtl).Save(InStr,"Auto")
	...s rtn=rtn+1
	...s InStr="^CT||04^TarItem^无^^"_RowId_"^"_TARIDesc_"^N^"_HospDr //拼凑免审核保存入参
	...d ##class(BILL.DC.BL.UnAuditItmCtl).Save(InStr,"Auto")
	...s rtn=rtn+1
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.DC.BL.UnAuditItmCtl).GetUnAuditItmFromAuto(HospDr)结束:",rtn)
	q rtn
GetUnAuditItmFromAutoErr
	s $zt= ""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.DC.BL.UnAuditItmCtl).GetUnAuditItmFromAuto(HospDr)异常",HospDr,$ze)
	q -1_"^"_$ze
}

}
