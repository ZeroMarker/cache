Class web.DHCEQImportDataForAna Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod SetGloble(RowStr) As %String
{
	s TmpStr=RowStr
	q:TmpStr="" ""
	s num=$l(TmpStr,"^"),i=0
	S PatNo=$p(TmpStr,"^")
	S ^FHQIQIQ("DATA")=$I(^FHQIQIQ("DATA"))
	s ^FHQIQIQ0109(PatNo)=TmpStr
	Q ""
}

ClassMethod UpData(ChangeType As %String = "", RowStr As %String = "", UpType As %String = "", Para As %String = "") As %String
{
	q:UpType=""
	s RetStr=""
	if Para'=""  d
	.s DateStr=$p(Para,"^")
	else  d
	.s DateStr=""
	s:UpType="DeviceMap" RetStr=..DeviceMap(ChangeType,RowStr)
	/// modified by ZY0301 20220513
	s:UpType="EquipServiceItem" RetStr=..EquipServiceItem(ChangeType,RowStr)
	s:UpType="EquipServiceItemConsumable" RetStr=..EquipServiceConsumableItem(ChangeType,RowStr)
	s:UpType="EquipServiceDetails" RetStr=..EquipServiceDetails(ChangeType,RowStr)
	s:UpType="ServiceItemAndDetItemByCode" RetStr=..ServiceItemAndDetItemByCode(ChangeType,RowStr)
	s:UpType="ConsumableItemByCode" RetStr=..ConsumableItemByCode(ChangeType,RowStr)
	//modified by ZY0217 2020-04-08
	s:UpType="UseRecord" RetStr=..UseRecord(ChangeType,RowStr)
	s:UpType="UsedRecource" RetStr=..UsedRecource(ChangeType,RowStr)
	s:UpType="ServiceConsumable" RetStr=..ServiceConsumable(ChangeType,RowStr)	//modified BY ZY0247 2020-12-14
			
	Quit RetStr
}

/// 创建：zy 2010-07-26 ZY0025
/// 描述：导入库房管理科室数据
/// 输入：ChangeType：操作类别
/// 	RowStr：设备编号^检验科设备^
/// w ##class(web.DHCEQImportDataForAna).DeviceMap("","2400499000153^DHC-LIS^1^")		
ClassMethod DeviceMap(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQDeviceMap
	q:ChangeType="Clear" "数据已清:设备对照(DHC_EQDeviceMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	//modified by ZY0217 2020-04-08
 	s EquipNo=$p(RowStr,del,1),EXType=$p(RowStr,del,2),DeviceID=$p(RowStr,del,3),Remark=$p(RowStr,del,4)
 	s EquipNo=##Class(web.DHCEQCommon).Trim(EquipNo)
 	s DeviceID=##Class(web.DHCEQCommon).Trim(DeviceID)
 	s Remark=##Class(web.DHCEQCommon).Trim(Remark)
 	i EquipNo="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备编号不能为空DHC_EQDeviceMap:")
 	i DeviceID="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"检验系统设备不能为空DHC_EQDeviceMap:")
 	if RetStr'="" q RetStr
 	k PLIST
 	i EquipNo'=""  d
	.&SQL(Select EQ_RowID into :tmpid  from sqluser.DHC_EQEquip where EQ_No=:EquipNo)
	.i tmpid=""  d
	..s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备管理系统中没有找到设备:设备编号="_EquipNo)
	.e  d
	..s PLIST(2)=tmpid
	e  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备管理系统中没有找到设备:设备编号="_EquipNo)
 	///modified by ZY0200
 	i DeviceID=""  d
 	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"检验系统中没有找到设备:设备="_DeviceID)
 	e  d
	.//modified by ZY0217 2020-04-08
 	.i EXType="DHC-LIS" d
 	..s LISVersion=##class(web.DHCEQCommon).GetSysInfo("992001")
 	..s flag=0
 	..i LISVersion=0 d
 	...s rowid=0
 	...f  s rowid=$o(^TMIF(rowid))  quit:rowid=""||flag'=0  d
 	....s (LTRowID,LName)=""
 	....s LTRowID = rowid	//rowid
 	....s LName=$p($g(^TMIF(rowid)),"\",1)
 	....s PLIST(3)=DeviceID
 	....s PLIST(13)=LName
 	....i DeviceID=LTRowID s flag=1 //找到了该设备
 	....q:flag=0
 	..e  d
 	...s rowid=0
	...f  s rowid=$o(^dbo.BTMIMachineParameterD(rowid)) q:rowid=""||flag'=0  d
	....s strData=$g(^dbo.BTMIMachineParameterD(rowid))
	....s LName=$lg(strData,5)
	....s Sname=$lg(strData,3)
	....s LTRowID = rowid
 	....s PLIST(3)=rowid
 	....s PLIST(13)=LName
	....i DeviceID=rowid s flag=1 // modify by wl 2020-04-13 找到了该设备
 	....q:flag=0 
 	.e  i EXType="DHC-RIS" d
	..zn "DHC-PACS"
	..s Code=0
	..s flag=0 //add by wl 2020-04-13 
	..f  s Code=$o(^User.MODALITYI("MDLCODEIndex",Code))  quit:(Code="")||(flag'=0)  d
	...s rowid=0
	...f  s rowid=$o(^User.MODALITYI("MDLCODEIndex",Code,rowid))  quit:(rowid="")||(flag'=0)  d
	....s DataList=$g(^User.MODALITYD(rowid))
	....s LTRowID=$LIST(DataList,7)
	....s LName=$LIST(DataList,5)
	....i DeviceID=LTRowID s flag=1 //找到了该设备
	....s PLIST(13)=LName		//add by wl 2020-04-13
	....s PLIST(3)=DeviceID  
	..zn "DHC-APP"
 	.
 	.i flag=0  d
 	..s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"系统中没有找到设备:设备="_DeviceID)
	s PLIST(4)=EXType
	s PLIST(5)=Remark
	s PLIST(12)="N"
 	if RetStr'="" q RetStr 
    if ChangeType'="Test"  d
    .&SQL(Insert Into SQLUSER.DHC_EQDeviceMap Values :PLIST())
	.i SQLCODE  s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"插入失败: EquipNo="_EquipNo_" DeviceID="_DeviceID_" SQLCODE="_SQLCODE)
	
 	q:RetStr="" "OK"
	q RetStr
}

/// 创建：zy 2010-11-11  ZY0043
/// 描述：服务项目，主要是his里面的设备分析取到设备能做的医嘱项
/// 输入：ChangeType：操作类别
/// 	RowStr：EX_ID^Code^服务项^EquipID
///  w ##class(web.DHCEQImportData2CSP).EquipServiceConsumableItem("","设备^2282^6842||1^BCSJMRPS^臂丛神经MR平扫^胶片^1")
///  w ##class(web.DHCEQImportData2CSP).EquipServiceConsumableItem("","设备^2282^6857||1^CTPS+ZQ^垂体平扫+增强^胶片^1")
ClassMethod EquipServiceConsumableItem(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.;k ^DHCEQCCode("DHCEQCConsumableItem")
	.;k ^DHCEQEquipService
	q:ChangeType="Clear" "数据已清:设备对照(DHC_EQDeviceMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s SourceType=$p(RowStr,del,1),SourceID=$p(RowStr,del,2)
	//modified by ZY0217 2020-04-08
 	s SICode=$p(RowStr,del,3),SIDesc=$p(RowStr,del,4),SIPrice=$p(RowStr,del,5)
 	s SIEXType=$p(RowStr,del,6),SIEXID=$p(RowStr,del,7)
 	s ConsumableCode=$p(RowStr,del,8),ConsumableItem=$p(RowStr,del,9),ConsumablePrice=$p(RowStr,del,10)
 	s CIEXType=$p(RowStr,del,11),CIEXID=$p(RowStr,del,12)
 	s Quantity=$p(RowStr,del,13)
 	
 	s SourceType=##Class(web.DHCEQCommon).Trim(SourceType)
 	s SourceID=##Class(web.DHCEQCommon).Trim(SourceID)
 	s SIEXID=##Class(web.DHCEQCommon).Trim(SIEXID)
 	s SICode=##Class(web.DHCEQCommon).Trim(SICode)
 	s SIDesc=##Class(web.DHCEQCommon).Trim(SIDesc)
 	s ConsumableItem=##Class(web.DHCEQCommon).Trim(ConsumableItem)
 	s Quantity=##Class(web.DHCEQCommon).Trim(Quantity)

 	i SourceType="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"来源类型不能为空")
 	i SourceID="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"来源ID不能为空")
 	i SIEXID="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"医嘱项ID不能为空")
 	i SICode="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项Code不能为空")
 	i SIDesc="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项Desc不能为空")
 	i ConsumableItem="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"消耗项不能为空")
 	i Quantity="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"消耗项数量不能为空")
 	if RetStr'="" q RetStr
 	i SourceType="设备" s SourceType="1"
 	i SourceType="设备项" s SourceType="2"
 	k PLIST,PESList,PSCList
 	
 	s PLIST(2)=SIDesc
 	s PLIST(3)=SICode
 	s PLIST(4)=""
 	s PLIST(5)=""
 	s PLIST(6)="DHC-HIS"
 	s PLIST(7)=SIEXID
 	s PLIST(8)=""
 	s PLIST(9)="N"
 	s PLIST(10)=""
 	s PLIST(11)=""
 	s PLIST(12)=""
 	s PLIST(13)="N"
 	s PLIST(14)=""
 	s PLIST(15)=SIDesc
 	
 	s (tmpid,SIRowID)=""
	&SQL(Select SI_RowID into :tmpid  from sqluser.DHC_EQCServiceItem where SI_Desc=:SIDesc and  SI_ExType='DHC-HIS')
	i tmpid'=""  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务相中有重复……"_SIDesc)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServiceItem Values :PLIST())
	..s SIRowID=$G(%ROWID)
	..i SQLCODE s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项插入记录失败……"_SIDesc)
	i RetStr'="" q RetStr
	
	s PESList(2)=SourceType					//SourceType
	s PESList(3)=SourceID 					//SourceID
	s PESList(4)=$p($g(^DHCEQEquip(SourceID)),"^",3)				//ModelDR
	s PESList(5)=SIRowID 					//ServiceDR
	s PESList(6)="" 						//MinMinutes
	s PESList(7)=""							//MinutesPerTimes
	s PESList(8)="" 						//MaxMinutes
	s PESList(9)="" 						//Remark
	s PESList(10)="N"
	s (tmpid)=""
	&SQL(Select ES_RowID into :tmpid  from sqluser.DHC_EQEquipService where ES_SourceType=:SourceType and ES_SourceID=:SourceID and ES_ModelDR=:PESList(4) and ES_ServiceDR=:SIRowID and ES_InvalidFlag='N')
	i tmpid'=""  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项中有重复……"_SIDesc)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQEquipService Values :PESList())
	..i SQLCODE s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备服务对照插入记录失败……"_SIDesc)
	i RetStr'="" q RetStr
	
	s PSCList(2)=SourceType					//SourceType
	s PSCList(3)=SourceID 					//SourceID
	s PSCList(4)=SIRowID					//ServiceItemDR
	s PSCList(7)=Quantity					//quantity
	s PSCList(8)=$p($g(^DHCEQEquip(SourceID)),"^",3)		//ModelDR
	
	//modified by ZY0217 2020-04-08
 	s tmpid=..InsertConsumableItem(ChangeType,"DHC-ST",ConsumableCode)
 	//
	//&SQL(Select CI_RowID into :tmpid  from sqluser.DHC_EQCConsumableItem where CI_Desc=:ConsumableItem and CI_InvalidFlag='N')
	i tmpid=""  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"消耗项没有找到^"_ConsumableItem)
	e  d
	.s PSCList(5)=tmpid											//ConsumableItemDR
	.s PSCList(6)=$p($g(^DHCEQCCode("DHCEQCConsumableItem",tmpid)),"^",4)		//uomDR
	i RetStr'="" q RetStr
	
	s (tmpid)=""
	&SQL(Select SIC_RowID into :tmpid  from sqluser.DHC_EQCServiceConsumable where SIC_SourceType=:SourceType and SIC_SourceID=:SourceID and SIC_ModelDR=:PSCList(6) and SIC_ServiceItemDR=:SIRowID)
	i tmpid'=""  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项中有重复……"_SIDesc)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServiceConsumable Values :PSCList())
	..i SQLCODE s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备服务对照插入记录失败……"_SIDesc)
 		
 	q:RetStr="" "OK"
	q RetStr
}

/// modified BY ZY0247 2020-12-14
/// 创建：zy 2011-03-03  ZY0063
/// 描述：根据已经做好的His设备服务项,导入服务项对应的收费项以及每个收费项对用的消耗明细.
/// 输入：ChangeType：操作类别
/// 	RowStr：设备ID^医嘱项ID^收费项ID^EquipID^消耗材料ID
///  w ##class(web.DHCEQImportData2CSP).ServiceConsumable("Append","2282^16830||1^14147^1")
ClassMethod ServiceConsumable(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.;k ^DHCEQCCode("DHCEQCConsumableItem")
	.;k ^DHCEQEquipService
	q:ChangeType="Clear" "数据已清:设备对照(DHC_EQDeviceMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s SIRowID=$p(RowStr,del,1),SIDesc=$p(RowStr,del,2),ConsumableItem=$p(RowStr,del,3),Quantity=$p(RowStr,del,4)
 	
 	s SIDesc=##Class(web.DHCEQCommon).Trim(SIDesc)
 	s ConsumableItem=##Class(web.DHCEQCommon).Trim(ConsumableItem)
 	s Quantity=##Class(web.DHCEQCommon).Trim(Quantity)

 	i SIDesc="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项Desc不能为空")
 	i ConsumableItem="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"消耗项不能为空")
 	i Quantity="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"消耗项数量不能为空")
 	if RetStr'="" q RetStr
 	k PSCList
 	
	//s PSCList(2)=SourceType					//SourceType
	//s PSCList(3)=SourceID 					//SourceID
	i '$Data(^DHCEQCCode("DHCEQCServiceItem",SIRowID))  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项没有找到……"_SIDesc)
	e  d
	.s PSCList(4)=SIRowID
	i RetStr'="" q RetStr
	
 	s tmpid=""
 	&SQL(Select CI_RowID into :tmpid  from sqluser.DHC_EQCConsumableItem where CI_Desc=:ConsumableItem and CI_InvalidFlag='N')
	i tmpid=""  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"消耗项没有找到^"_ConsumableItem)
	e  d
	.s PSCList(5)=tmpid											//ConsumableItemDR
	.s PSCList(6)=$p($g(^DHCEQCCode("DHCEQCConsumableItem",tmpid)),"^",4)		//uomDR
	i RetStr'="" q RetStr
	
	s PSCList(7)=Quantity					//quantity
	//s PSCList(8)=$p($g(^DHCEQEquip(SourceID)),"^",3)		//ModelDR
	s PSCList(9)="1"						//quantityType
	//s PSCList(10)=""						//ServDetItemDR
	s PSCList(11)="N"						//MonthStatFlag
	
	s (tmpid)=""
	&SQL(Select SIC_RowID into :tmpid  from sqluser.DHC_EQCServiceConsumable where SIC_ServiceItemDR=:SIRowID and SIC_ConsumableItemDR =:PSCList(5))
	i tmpid'=""  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项中有重复……")
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServiceConsumable Values :PSCList())
	..i SQLCODE s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备服务对照插入记录失败……"_SIDesc)
 		
 	q:RetStr="" "OK"
	q RetStr
}

/// 创建：zy 2011-03-03  ZY0063
/// 描述：根据已经做好的His设备服务项,导入服务项对应的收费项以及每个收费项对用的消耗明细.
/// 输入：ChangeType：操作类别
/// 	RowStr：设备ID^医嘱项ID^收费项ID^EquipID^消耗材料ID
///  w ##class(web.DHCEQImportData2CSP).EquipServiceDetails("Append","2282^16830||1^14147^1")
ClassMethod EquipServiceDetails(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.;k ^DHCEQCCode("DHCEQCConsumableItem")
	.;k ^DHCEQEquipService
	q:ChangeType="Clear" "数据已清:设备对照(DHC_EQDeviceMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s EquipID=$p(RowStr,del,1),ARCIMID=$p(RowStr,del,2),TARItemID=$p(RowStr,del,3),INCIID=$p(RowStr,del,4)
 	
 	s EquipID=##Class(web.DHCEQCommon).Trim(EquipID)
 	s ARCIMID=##Class(web.DHCEQCommon).Trim(ARCIMID)
 	s TARItemID=##Class(web.DHCEQCommon).Trim(TARItemID)
 	s INCIID=##Class(web.DHCEQCommon).Trim(INCIID)

 	i EquipID="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备ID不能为空")
 	i ARCIMID="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"医嘱项ID不能为空")
 	i TARItemID="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"收费项ID不能为空")
 	i INCIID="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"消耗材料ID不能为空")
 	if RetStr'="" q RetStr
 	
 	k PLIST,PSIList,PCILIST,PSICLIST
 	
 	i $D(^DHCEQCCode("DHCEQCServiceItem",0,"ExID","DHC-HIS",ARCIMID)) d
 	.s ServiceItemID=$o(^DHCEQCCode("DHCEQCServiceItem",0,"ExID","DHC-HIS",ARCIMID,""))
 	i ServiceItemID="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项不存在"_ARCIMID)
 	if RetStr'="" q RetStr
 	
 	s TARCode=$p($g(^DHCTARI(TARItemID)),"^",1)  ;Code
 	s TARDesc=$p($g(^DHCTARI(TARItemID)),"^",2)  ;Desc
 	s TARUOM=$p($g(^DHCTARI(TARItemID)),"^",3)	 ;UOM
 	s TARPrice=$p($g(^DHCTARI(TARItemID)),"^",8)  ;Price
 	
	s vDate=$o(^DHCOLT(0,"ARTTA",ARCIMID,TARItemID,""))
	i vDate'="" d
	.s OLTRowID=$o(^DHCOLT(0,"ARTTA",ARCIMID,TARItemID,vDate,""))
	.i OLTRowID'="" s Qty=$p($g(^DHCOLT(OLTRowID)),"^",3)
	
 	s PLIST(2)=TARDesc		;Desc
 	s PLIST(3)=TARCode		;Code
 	s PLIST(4)=TARUOM		;UnitDR
 	s PLIST(5)=TARPrice		;Price
 	s PLIST(6)="2"			;ExType
 	s PLIST(7)=TARItemID	;ExID
 	s PLIST(8)=""			;Remark		
 	s PLIST(9)="Y"			;ImportFlag
 	s PLIST(10)=""			;MinMinutes	
 	s PLIST(11)=""			;MinutesPerTime
 	s PLIST(12)=""			;MaxMinutes
 	s PLIST(13)=""			;InvalidFlag
 	s PLIST(14)=+$h			;UpdateDate
 	s PLIST(15)=TARDesc		;ExDesc
 	
 	s (tmpid)=""
	&SQL(Select SDI_RowID into :tmpid  from sqluser.DHC_EQCServDetItem where SDI_ExID=:TARItemID and SDI_InvalidFlag='N' and SDI_ExType='DHC-HIS')
	i tmpid'=""  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务细项中有重复……"_TARItemID)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServDetItem Values :PLIST())
	..s SDIRowID=$G(%ROWID)
	..i SQLCODE s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务细项插入记录失败……"_TARItemID)
	i RetStr'="" q RetStr
	
	i SDIRowID="" q "OK"
	
	s PSIList(2)=ServiceItemID				;ServiceItemDR
	s PSIList(3)=SDIRowID 					;ServDetItemDR
	s PSIList(4)=Qty						;Quantity
	s PSIList(5)=""		 					;Remark
	s PSIList(6)="" 						;InvalidFlag
	
	s (tmpid)=""
	&SQL(Select SD_RowID into :tmpid  from sqluser.DHC_EQCServiceDetails where SD_ServiceItemDR=:ServiceItemID and SD_ServDetItemDR=:SDIRowID and SD_InvalidFlag='N')
	i tmpid'=""  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项与细项中有重复……"_SDIRowID)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServiceDetails Values :PSIList())
	..i SQLCODE s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项与细项对照插入记录失败……"_SDIRowID)
	i RetStr'="" q RetStr
	
	///消耗项目明细
	//INCIID
	s INCICode=$p($g(^INCI(INCIID,1)),"^",1)  ;Code
	s INCIDesc=$p($g(^INCI(INCIID,1)),"^",2)  ;Desc
	s INCIPrice=$p($g(^INCI(INCIID,1)),"^",5)  ;Price
	s INCIUomDR=$p($g(^INCI(INCIID,1)),"^",10)  ;UomDR
	
	s PCILIST(2)=INCIDesc			;Desc
	s PCILIST(3)=INCICode			;Code
	s PCILIST(4)=INCIPrice			;Price
	s PCILIST(5)=INCIUomDR			;UomDR
	s PCILIST(6)="DHC-ST"			;ExType 
	s PCILIST(7)=INCIID				;ExID
	s PCILIST(8)=""					;InvalidFlag
	s PCILIST(9)=INCIDesc			;ExDesc 
	
	s (tmpid)=""
	&SQL(Select CI_RowID into :tmpid  from sqluser.DHC_EQCConsumableItem where CI_ExType='DHC-ST' and CI_ExID=:INCIID and CI_InvalidFlag='N')
	i tmpid=""  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCConsumableItem Values :PCILIST())
	..s CIRowID=$G(%ROWID)
	..i SQLCODE s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"消耗项插入记录失败……"_INCIID)
	i RetStr'="" q RetStr
	
	///服务项对应消耗项目
	s PSICLIST(2)="1"			;SourceType
	s PSICLIST(3)=EquipID		;SourceID
	s PSICLIST(4)=ServiceItemID	;ServiceItemDR
	s PSICLIST(5)=CIRowID		;ConsumableItemDR
	s PSICLIST(6)=INCIUomDR		;UomDR
	s PSICLIST(7)="1"			;Quantity
	s PSICLIST(8)=$p($g(^DHCEQEquip(EquipID)),"^",3)	;ModelDR
	s PSICLIST(9)="2"			;QuantityType  
	s PSICLIST(10)=SDIRowID		;ServDetItemDR
		
	s (tmpid)=""
	&SQL(Select SIC_RowID into :tmpid  from sqluser.DHC_EQCServiceConsumable where SIC_SourceType='1' and SIC_SourceID=:EquipID and SIC_ServiceItemDR=:ServiceItemID and SIC_ConsumableItemDR=:CIRowID and SIC_ServDetItemDR=:SDIRowID)
	i tmpid'=""  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项消耗项对照中有重复……"_CIRowID)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServiceConsumable Values :PSICLIST())
	..s CIRowID=$G(%ROWID)
	..i SQLCODE s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项消耗项对照插入记录失败……"_CIRowID)
	i RetStr'="" q RetStr
	
 	q:RetStr="" "OK"
	q RetStr
}

/// modified by ZY0301 20220523
/// 创建：zy 2011-03-03  ZY0063
/// 描述：效益分析设备对应his里面的服务项(医嘱项)
/// 输入：ChangeType：操作类别
/// 	RowStr：设备^设备ID^医嘱项ID
///  w ##class(web.DHCEQImportData2CSP).EquipServiceConsumableItem("","设备^2282^16830||1")
///  w ##class(web.DHCEQImportData2CSP).EquipServiceItem("Append","设备^2282^16830||1")
ClassMethod EquipServiceItem(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.;k ^DHCEQCCode("DHCEQCConsumableItem")
	.;k ^DHCEQEquipService
	q:ChangeType="Clear" "数据已清:设备对照(DHC_EQDeviceMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s SourceType=$p(RowStr,del,1),SourceID=$p(RowStr,del,2)
 	s SourceID=##class(web.DHCEQEquip).GetEquipIDByNo(SourceID)
 	s SIEXID=$p(RowStr,del,3)
 	s (tmpid)=""
 	&SQL(SELECT ARCIM_RowID into :tmpid FROM sqluser.ARC_ItmMast WHERE ARCIM_Code=:SIEXID)
 	s SIEXID=tmpid
 	
 	s SourceType=##Class(web.DHCEQCommon).Trim(SourceType)
 	s SourceID=##Class(web.DHCEQCommon).Trim(SourceID)
 	s SIEXID=##Class(web.DHCEQCommon).Trim(SIEXID)

 	i SourceType="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"来源类型不能为空")
 	i SourceID="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"来源ID不能为空")
 	i SIEXID="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"医嘱项ID不能为空")
 	if RetStr'="" q RetStr
 	s subscript=$p(SIEXID,"||",1)
 	s version=$p(SIEXID,"||",2)
 	S SICode=$p($g(^ARCIM(subscript,version,1)),"^",1)
 	S SIDesc=$p($g(^ARCIM(subscript,version,1)),"^",2)
 	
 	i SICode="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项Code不能为空")
 	i SIDesc="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项Desc不能为空") 	
 	if RetStr'="" q RetStr
 	
 	i SourceType="设备" s SourceType="1"
 	i SourceType="设备项" s SourceType="2"
 	k PLIST,PESList
 	
 	s PLIST(2)=SIDesc
 	s PLIST(3)=SICode
 	s PLIST(4)=""
 	s PLIST(5)=""
 	s PLIST(6)="DHC-HIS"
 	s PLIST(7)=SIEXID
 	s PLIST(8)=""
 	s PLIST(9)="N"
 	s PLIST(10)=""
 	s PLIST(11)=""
 	s PLIST(12)=""
 	s PLIST(13)="N"
 	s PLIST(14)=""
 	s PLIST(15)=SIDesc
 	
 	s (tmpid,SIRowID)=""
	&SQL(Select SI_RowID into :tmpid  from sqluser.DHC_EQCServiceItem where SI_Desc=:SIDesc and SI_ExID=:SIEXID and SI_ExType='DHC-HIS')
	i tmpid'=""  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务相中有重复……"_SIDesc)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServiceItem Values :PLIST())
	..s SIRowID=$G(%ROWID)
	..i SQLCODE s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项插入记录失败……"_SIDesc)
	i RetStr'="" q RetStr
	
	s PESList(2)=SourceType					//SourceType
	s PESList(3)=SourceID 					//SourceID
	s PESList(4)=$p($g(^DHCEQEquip(SourceID)),"^",3)				//ModelDR
	s PESList(5)=SIRowID 					//ServiceDR
	s PESList(6)="" 						//MinMinutes
	s PESList(7)=""							//MinutesPerTimes
	s PESList(8)="" 						//MaxMinutes
	s PESList(9)="" 						//Remark
	s PESList(10)="N"
	s PESList(11)="0"
	s PESList(12)="DHC-HIS"
	s (tmpid)=""
	&SQL(Select ES_RowID into :tmpid  from sqluser.DHC_EQEquipService where ES_SourceType=:SourceType and ES_SourceID=:SourceID and ES_ModelDR=:PESList(4) and ES_ServiceDR=:SIRowID and ES_InvalidFlag='N')
	i tmpid'=""  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项中有重复……"_SIDesc)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQEquipService Values :PESList())
	..i SQLCODE s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备服务对照插入记录失败……"_SIDesc)
	i RetStr'="" q RetStr
	
 	q:RetStr="" "OK"
	q RetStr
}

/// 创建：zy 2011-03-03  ZY0063
/// 描述：效益分析设备对应his里面的服务项(医嘱项)
/// 输入：ChangeType：操作类别
/// 	RowStr：ExType^SourceType^SourceID^收费项Code^医嘱项
///  w ##class(web.DHCEQImportData2CSP).ServiceItemAndDetItemByCode("Append","DHC-HIS^设备^1^120100011^111||1")
ClassMethod ServiceItemAndDetItemByCode(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCServiceDetails")
	.k ^DHCEQCCode("DHCEQCServiceItem")
	.k ^DHCEQCCode("DHCEQCServDetItem")
	.k ^DHCEQEquipService
	quit:ChangeType="Clear" ""
	IF ChangeType="Clear"  quit "数据已清:设备对照(DHC_EQDeviceMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s ExType=$p(RowStr,del,1),SourceType=$p(RowStr,del,2),SourceID=$p(RowStr,del,3)
 	s TARICode=$p(RowStr,del,4),ExID=$p(RowStr,del,5)
  
 	s ExType=##Class(web.DHCEQCommon).Trim(ExType)
 	s SourceType=##Class(web.DHCEQCommon).Trim(SourceType)
 	s SourceID=##Class(web.DHCEQCommon).Trim(SourceID)
 	s TARICode=##Class(web.DHCEQCommon).Trim(TARICode)
 	s ExID=##Class(web.DHCEQCommon).Trim(ExID)
 	
 	i SourceType="设备" s SourceType="1"
 	i SourceType="设备项" s SourceType="2"
	
 	i ExType="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"分析来源类型不能为空")
 	i SourceType="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"来源类型不能为空")
 	i SourceID="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"来源ID不能为空")
 	i TARICode="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"TARICode不能为空")
 	//i ExID="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"ExID不能为空")
 	if RetStr'="" q RetStr
 	 	
	//取收费项目ID	//^DHCOLT(0,"TAR",{OLT_Tariff_DR},{OLT_StartDate},{OLT_RowId})
	s TARIID=""
	s TARICode=$ZCONVERT(TARICode,"U")
 	if $Data(^DHCTARI(0,"Code",TARICode))'=0 d
 	.s TARIID=$o(^DHCTARI(0,"Code",TARICode,0))
	i TARIID="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"收费项不存在……"_TARICode)
	i RetStr'="" q RetStr
 	
 	//通过收费项目到DHC_OrderLinkTar表中循环找医嘱项
 	if $data(^DHCOLT(0,"TAR",TARIID)) d
 	.s OLTStartDate=0
 	.for  s OLTStartDate=$o(^DHCOLT(0,"TAR",TARIID,OLTStartDate)) quit:OLTStartDate=""  d
 	..s oltrowid=0
 	..for  s oltrowid=$o(^DHCOLT(0,"TAR",TARIID,OLTStartDate,oltrowid)) quit:oltrowid=""  d
 	...s ARCIMID=$p($g(^DHCOLT(oltrowid)),"^",1)
 	...quit:(ExID'="")&&(ExID'=ARCIMID)
 	...s result=..CheckARCItem(ARCIMID)
 	...quit:result'=0
 	...
 	...//写入收费项目   DHC_EQCServDetItem
 	...s ServDetItemID=..InsertSerDetItem(ChangeType,ExType,TARIID,ARCIMID)
 	...quit:ServDetItemID<=0
 	...
 	...//写入服务项     DHC_EQCServiceItem
 	...s ServiceItemID=..InsertServiceItem(ChangeType,ExType,ARCIMID)
 	...quit:ServiceItemID=""
 	...
 	...//写入设备对应的服务项  DHC_EQEquipService
 	...if ExType="DHC-HIS"  d
 	....s result=..InsertEquipServiceItem(ChangeType,ExType,SourceType,SourceID,ServiceItemID)
 	...quit:result'=0
 	...
 	...//取服务项对收费项的数量
 	...s Qty=0
	...s vDate=$o(^DHCOLT(0,"ARTTA",ARCIMID,TARIID,""))
	...i vDate'="" d
	....s OLTRowID=$o(^DHCOLT(0,"ARTTA",ARCIMID,TARIID,vDate,""))
	....i OLTRowID'="" s Qty=$p($g(^DHCOLT(OLTRowID)),"^",3)
	...
 	...//写入服务项和收费项的对照关系   DHC_EQCServiceDetails
 	...s flag=..InsertEquipServDetItem(ChangeType,ExType,ServiceItemID,ServDetItemID,Qty)
 	...quit:flag'=0
	
 	q:RetStr="" "OK"
	q RetStr
}

/// 创建：zy 2011-03-03  ZY0063
/// 描述：根据已经做好的His设备服务项,导入服务项对应的收费项以及每个收费项对用的消耗明细.
/// 输入：ChangeType：操作类别
/// 	RowStr：EquipNo^收费项目ID^消耗材料Code
///  w ##class(web.DHCEQImportData2CSP).ConsumableItemByCode("Append","DHC-HIS^w0223000032^肝动脉造影^CG0000343^耦合剂(威高)")
ClassMethod ConsumableItemByCode(ChangeType As %String = "", RowStr As %String = "")
{
	s RetStr=""
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCConsumableItem")
	.k ^DHCEQCCode("DHCEQCServiceConsumable")
	
	IF ChangeType="Clear"  quit "数据已清:设备对照(DHC_EQDeviceMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s ExType=$p(RowStr,del,1),TARICode=$p(RowStr,del,2),TARIDesc=$p(RowStr,del,3)
 	s INCICode=$p(RowStr,del,4),INCIDesc=$p(RowStr,del,5)
 	
 	s ExType=##Class(web.DHCEQCommon).Trim(ExType)
 	s TARICode=##Class(web.DHCEQCommon).Trim(TARICode)
 	s TARIDesc=##Class(web.DHCEQCommon).Trim(TARIDesc)
 	s INCICode=##Class(web.DHCEQCommon).Trim(INCICode)
 	s INCIDesc=##Class(web.DHCEQCommon).Trim(INCIDesc)

 	i ExType="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"收费项类型不能为空")
 	i TARICode="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"收费项Code不能为空")
 	//i TARIDesc="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"收费项Desc不能为空")
 	i INCICode="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"消耗材料ID不能为空")
 	
 	if RetStr'="" q RetStr
 	
 	i ExType="DHC-HIS" set Type=1,QuantityType=1
 	i ExType="DHC-LIS" set Type=2,QuantityType=2
 	i ExType="DHC-RIS" set Type=3,QuantityType=1
	//取收费项目ID
	//^DHCOLT(0,"TAR",{OLT_Tariff_DR},{OLT_StartDate},{OLT_RowId})
	s TARIID=""
	s TARICode=$ZCONVERT(TARICode,"U")
 	if $Data(^DHCTARI(0,"Code",TARICode))'=0 d
 	.s TARIID=$o(^DHCTARI(0,"Code",TARICode,0))
	i TARIID="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"收费项……"_TARICode)
	i RetStr'="" q RetStr
	
 	s ServiceDetID=""
 	if $D(^DHCEQCCode("DHCEQCServDetItem","0",Type,TARIID))'=0 d
 	.s ServiceDetID=$Order(^DHCEQCCode("DHCEQCServDetItem","0",Type,TARIID,0))
 	if ServiceDetID="" q "收费项  不存在"_TARICode
	
	//写入消耗材料
	s ConsumableItemID=..InsertConsumableItem(ChangeType,ExType,INCICode)
	if ConsumableItemID'>0 q "消耗材料不存在"_INCICode
 	
 	s ServiceItemID=""
 	if $D(^DHCEQCCode("DHCEQCServiceDetails",0,"ServiceItem",ServiceDetID)) d
 	.s ServiceItemID=0
 	.f  s ServiceItemID=$Order(^DHCEQCCode("DHCEQCServiceDetails",0,"ServDetItem",ServiceDetID,ServiceItemID)) quit:((ServiceItemID="")||(RetStr'=""))  d
 	..s sdrowid=0
 	..f  s sdrowid=$Order(^DHCEQCCode("DHCEQCServiceDetails",0,"ServDetItem",ServiceDetID,ServiceItemID,sdrowid)) quit:((sdrowid="")||(RetStr'=""))  d
 	...//^DHCEQEquipService(0,"ServiceSource",439,1
 	...s EquipID=0
 	...f  s EquipID=$Order(^DHCEQEquipService(0,"ServiceSource",ServiceItemID,1,EquipID)) quit:((EquipID="")||(RetStr'=""))  d
 	....
 	....///服务项对应消耗项目
 	....s PSICLIST(2)="1"					;SourceType
 	....s PSICLIST(3)=EquipID				;SourceID
 	....s PSICLIST(4)=ServiceItemID			;ServiceItemDR
 	....s PSICLIST(5)=ConsumableItemID		;ConsumableItemDR
 	....s PSICLIST(6)=$p($g(^DHCEQCCode("DHCEQCServDetItem",ServiceDetID)),"^",3)				;UomDR
 	....s PSICLIST(7)="1"					;Quantity
 	....s PSICLIST(8)=$p($g(^DHCEQEquip(EquipID)),"^",3)	;ModelDR
 	....s PSICLIST(9)=QuantityType			;QuantityType  
 	....s PSICLIST(10)=ServiceDetID			;ServDetItemDR
 	....s (tmpid)=""
 	....&SQL(Select SIC_RowID into :tmpid  from sqluser.DHC_EQCServiceConsumable where SIC_SourceType='1' and SIC_SourceID=:EquipID and SIC_ServiceItemDR=:ServiceItemID and SIC_ConsumableItemDR=:ConsumableItemID and SIC_ServDetItemDR=:ServiceDetID)
 	....
 	....i tmpid'=""  d
 	.....;s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项消耗项对照中有重复……"_CIRowID)
 	....e  d
 	.....i (ChangeType="Append") d
 	......&SQL(Insert Into SQLUSER.DHC_EQCServiceConsumable Values :PSICLIST())
 	......s CIRowID=$G(%ROWID)
 	......i SQLCODE s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项消耗项对照插入记录失败……"_ConsumableItemID)
 
 	if RetStr'="" q RetStr
 	q:RetStr="" "OK"
}

/// w ##class(web.DHCEQImportData2CSP).CheckARCItem("13453||1")
ClassMethod CheckARCItem(ARCIMID)
{
 	s (subscript,version,ARCIC,ARCIMItemCatDR,ARCIMorderOnItsOwn)=""
 	s subscript=$p(ARCIMID,"||",1)
 	s version=$p(ARCIMID,"||",2)
 	//s ARCIMItemCatDR=$p($g(^ARCIM(subscript,version,1)),"^",10)  //ItemCatDR
 	//if ARCIMItemCatDR'="" s ARCIC=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)  ;OrderType
 	//if ARCIC'="N" quit 0
 	s ARCIMorderOnItsOwn=$p($g(^ARCIM(subscript,version,7)),"^",13)
 	if ARCIMorderOnItsOwn'="Y"  quit 1
 	quit 0
}

/// w ##class(web.DHCEQImportData2CSP).InsertSerDetItem("2880","3159||1")
ClassMethod InsertSerDetItem(ChangeType, ExType, TARIID, ARCIMID)
{
	///收费项目明细
	//^DHCOLT(0,"TAR",{OLT_Tariff_DR},{OLT_StartDate},{OLT_RowId})
	k PLIST
	s RetStr=""
	s ServDetItemID=""
	
 	s TARCode=$p($g(^DHCTARI(TARIID)),"^",1)  ;Code
 	s TARDesc=$p($g(^DHCTARI(TARIID)),"^",2)  ;Desc
 	s TARUOM=$p($g(^DHCTARI(TARIID)),"^",3)	 ;UOM
 	s TARPrice=$p($g(^DHCTARI(TARIID)),"^",8)  ;Price
 	if ExType="DHC-HIS" set Type=1
 	if ExType="DHC-LIS" set Type=2
 	
 	s PLIST(2)=TARDesc		;Desc
 	s PLIST(3)=TARCode		;Code
 	s PLIST(4)=TARUOM		;UnitDR
 	s PLIST(5)=TARPrice		;Price
 	s PLIST(6)=Type			;ExType	
 	s PLIST(7)=TARIID		;ExID
 	s PLIST(8)=""			;Remark		
 	s PLIST(9)="Y"			;ImportFlag
 	s PLIST(10)=""			;MinMinutes	
 	s PLIST(11)=""			;MinutesPerTime
 	s PLIST(12)=""			;MaxMinutes
 	s PLIST(13)="N"			;InvalidFlag
 	s PLIST(14)=+$h			;UpdateDate
 	s PLIST(15)=TARDesc		;ExDesc
 	
 	s (tmpid)=""
	&SQL(Select SDI_RowID into :tmpid  from sqluser.DHC_EQCServDetItem where SDI_ExType=:Type and SDI_ExID=:TARIID and SDI_InvalidFlag='N')
	i tmpid'=""  d
	.s ServDetItemID=tmpid
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServDetItem Values :PLIST())
	..s ServDetItemID=$G(%ROWID)
	..i SQLCODE s RetStr="-1"			//##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务细项插入记录失败……"_TARItemID)
	
	if RetStr'="" q RetStr
	q ServDetItemID
}

ClassMethod InsertServiceItem(ChangeType, ExType, ARCIMID)
{
 	
 	k PLIST
 	s RetStr=""
 	s (subscript,version,ServiceItemID)=""
 	s subscript=$p(ARCIMID,"||",1)
 	s version=$p(ARCIMID,"||",2)
 	S SICode=$p($g(^ARCIM(subscript,version,1)),"^",1)
 	S SIDesc=$p($g(^ARCIM(subscript,version,1)),"^",2)
 	s UnitDR=$p($g(^ARCIM(subscript,version,1)),"^",4)
 	
 	&SQL(Select SI_RowID into :tmpid  from sqluser.DHC_EQCServiceItem where SI_Desc=:SIDesc and SI_ExID=:ARCIMID and SI_ExType=:ExType)
 	i tmpid'=""  d
 	.s ServiceItemID=tmpid
 	e  d
 	.s PLIST(2)=SIDesc
 	.s PLIST(3)=SICode
 	.s PLIST(4)=UnitDR
 	.s PLIST(5)=##class(web.DHCEQIUsedRecord).GetServicePriceByExID(ExType,ARCIMID,+$h)
 	.s PLIST(6)=ExType
 	.s PLIST(7)=ARCIMID
 	.s PLIST(8)=""
 	.s PLIST(9)="N"
 	.s PLIST(10)=""
 	.s PLIST(11)=""
 	.s PLIST(12)=""
 	.s PLIST(13)="N"
 	.s PLIST(14)=""
 	.s PLIST(15)=SIDesc
 	.i (ChangeType="Append") d
 	..&SQL(Insert Into SQLUSER.DHC_EQCServiceItem Values :PLIST())
 	..s ServiceItemID=$G(%ROWID)
 	..i SQLCODE s RetStr="-1"		//##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项插入记录失败……"_SIDesc)
 	
 	i RetStr'="" q RetStr
 	
 	q ServiceItemID
}

/// w ##class(web.DHCEQImportData2CSP).InsertEquipServiceItem("Append","","1","16828","443")
ClassMethod InsertEquipServiceItem(ChangeType, ExType, SourceType, SourceID, ServiceItemID)
{
	s RetStr=0
	k PESList
	s ModelDR=""
	i SourceType=1 d
	.s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
	s PESList(2)=SourceType					//SourceType
	s PESList(3)=SourceID 					//SourceID
	s PESList(4)=ModelDR					//ModelDR
	s PESList(5)=ServiceItemID				//ServiceDR
	s PESList(6)="" 						//MinMinutes
	s PESList(7)=""							//MinutesPerTimes
	s PESList(8)="" 						//MaxMinutes
	s PESList(9)="" 						//Remark
	s PESList(10)="N"
	s (tmpid)=""
	&SQL(Select ES_RowID into :tmpid  from sqluser.DHC_EQEquipService where ES_SourceType=:SourceType and ES_SourceID=:SourceID  and ES_ServiceDR=:ServiceItemID and ES_InvalidFlag='N')
	i tmpid'=""  d
	.;s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备服务项对照中有重复……"_SIDesc)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQEquipService Values :PESList())
	..i SQLCODE s RetStr="-1"			//##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备服务对照插入记录失败……"_SIDesc)
	
	q RetStr
}

ClassMethod InsertEquipServDetItem(ChangeType, ExType, ServiceItemID, ServDetItemID, Qty)
{
	s RetStr=0
	k PSIList
	s PSIList(2)=ServiceItemID				;ServiceItemDR
	s PSIList(3)=ServDetItemID				;ServDetItemDR
	s PSIList(4)=Qty						;Quantity
	s PSIList(5)=""		 					;Remark
	s PSIList(6)="N" 						;InvalidFlag
	
	s (tmpid)=""
	&SQL(Select SD_RowID into :tmpid  from sqluser.DHC_EQCServiceDetails where SD_ServiceItemDR=:ServiceItemID and SD_ServDetItemDR=:ServDetItemID and SD_InvalidFlag='N')
	i tmpid'=""  d
	.;s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项与细项对照有重复……"_ServDetItemID)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServiceDetails Values :PSIList())
	..i SQLCODE s RetStr="-1"			//##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项与细项对照插入记录失败……"_ServDetItemID)
	q RetStr
}

/// w ##class(web.DHCEQImportData2CSP).InsertConsumableItem("Append","DHC-HIS","W050401127")
ClassMethod InsertConsumableItem(ChangeType, ExType, INCICode)
{
	///消耗项目明细
	//INCIID   ^INCI(0,"Code",$$ALPHAUP({INCI_Code}),{INCI_RowId})
	s RetStr=""
	s INCIID=""
	s INCICode=$ZCONVERT(INCICode,"U")
 	if $Data(^INCI(0,"Code",INCICode))'=0 d
 	.s INCIID=$o(^INCI(0,"Code",INCICode,0))
	i INCIID="" s RetStr="-1"		//##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"材料不存在……"_INCICode)
	i RetStr'="" q RetStr
	
	s INCICode=$p($g(^INCI(INCIID,1)),"^",1)  ;Code
	s INCIDesc=$p($g(^INCI(INCIID,1)),"^",2)  ;Desc
	s INCIPrice=$p($g(^INCI(INCIID,1)),"^",5)  ;Price
	s INCIUomDR=$p($g(^INCI(INCIID,1)),"^",10)  ;UomDR
	
	i ExType="DHC-LIS" s ExType="DHC-ST"
	
	s PCILIST(2)=INCIDesc			;Desc
	s PCILIST(3)=INCICode			;Code
	s PCILIST(4)=INCIPrice			;Price
	s PCILIST(5)=INCIUomDR			;UomDR
	s PCILIST(6)=ExType				;ExType 
	s PCILIST(7)=INCIID				;ExID
	s PCILIST(8)=""					;InvalidFlag
	s PCILIST(9)=INCIDesc			;ExDesc 
	
	s (tmpid,ConsumableItemID)=""
	&SQL(Select CI_RowID into :tmpid  from sqluser.DHC_EQCConsumableItem where CI_ExType=:ExType and CI_ExID=:INCIID)
	i tmpid'=""  d
	.;s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项消耗项对照中有重复……"_CIRowID)
	.s ConsumableItemID=tmpid
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCConsumableItem Values :PCILIST())
	..s ConsumableItemID=$G(%ROWID)
	..i SQLCODE s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"消耗项插入记录失败……"_INCIID)
 	if RetStr'="" q RetStr
	q ConsumableItemID
}

// add by ZY0217 2020-04-08

ClassMethod UseRecord(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.;k ^DHCEQDeviceMap
	q:ChangeType="Clear" "数据已清:设备对照(DHC_EQDeviceMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s EquipNo=$p(RowStr,del,1),Year=$p(RowStr,del,2),Month=$p(RowStr,del,3),UseDate=$p(RowStr,del,4)
 	s ServiceItem=$p(RowStr,del,5),Price=$p(RowStr,del,6),WorkLoadNum=$p(RowStr,del,7)
 	s TotalFee=$p(RowStr,del,8),PatientInfo=$p(RowStr,del,9)
 	s EquipNo=##Class(web.DHCEQCommon).Trim(EquipNo)
 	s Year=##Class(web.DHCEQCommon).Trim(Year)
 	s Month=##Class(web.DHCEQCommon).Trim(Month)
 	s UseDate=##Class(web.DHCEQCommon).Trim(UseDate)
 	s ServiceItem=##Class(web.DHCEQCommon).Trim(ServiceItem)
 	s Price=##Class(web.DHCEQCommon).Trim(Price)
 	s WorkLoadNum=##Class(web.DHCEQCommon).Trim(WorkLoadNum)
 	s TotalFee=##Class(web.DHCEQCommon).Trim(TotalFee)
 	s PatientInfo=##Class(web.DHCEQCommon).Trim(PatientInfo)
 	i EquipNo="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备编号不能为空:"_EquipNo)
 	i Year="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"年度不能为空:"_Year)
 	i Month="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"月份不能为空:"_Month)
 	i ServiceItem="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项目不能为空:"_ServiceItem)
 	if RetStr'="" q RetStr
 	
 	s SourceType=1
 	
 	s (tmpid,SourceID,ModelDR,UseLocDR)=""
	&SQL(Select EQ_RowID into :tmpid  from sqluser.DHC_EQEquip where EQ_No=:EquipNo)
	i tmpid=""  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备台账不存在这个设备:"_EquipNo)
	e  d
	.s SourceID=tmpid
	.s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
	.s UseLocDR=$p($g(^DHCEQEquip(SourceID)),"^",19)
	i RetStr'="" q RetStr
	
	s UseDate=$ZDH(UseDate,3)
	
 	s (tmpid,ServiceItemDR,WorkLoadUnitDR)=""
	&SQL(Select SI_RowID into :tmpid  from sqluser.DHC_EQCServiceItem where SI_Desc=:ServiceItem and  SI_ExType='DHC-HIS')
	i tmpid=""  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"服务项为空:"_ServiceItem)
	e  d
	.s ServiceItemDR=tmpid
	.s WorkLoadUnitDR=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",3)
	i RetStr'="" q RetStr
	s IsInputFlag="Y"
	
	i (ChangeType="Append") d
	.s Val=SourceType
	.s Val=Val_"^"_SourceID
	.s Val=Val_"^"_UseDate
	.s Val=Val_"^"_""	//StartTime
	.s Val=Val_"^"_""	//EndDate
	.s Val=Val_"^"_""	//EndTime
	.s Val=Val_"^"_WorkLoadNum
	.s Val=Val_"^"_WorkLoadUnitDR
	.s Val=Val_"^"_UseLocDR
	.s Val=Val_"^"_PatientInfo
	.s Val=Val_"^"_Price
	.s Val=Val_"^"_TotalFee
	.s Val=Val_"^"_Year
	.s Val=Val_"^"_Month
	.s Val=Val_"^"_ServiceItemDR
	.s Val=Val_"^"_""	//ExType
	.s Val=Val_"^"_""	//ExID
	.s Val=Val_"^"_IsInputFlag
	.s Val=Val_"^"_"2"	//LIStatus
	.s Val=Val_"^"_"N"	//InvalidFlag
	.s Val=Val_"^"_""	//Remark
	.s Val=Val_"^^^^^^^"
	.s Val=Val_ModelDR
	.s Result=##Class(web.DHCEQUseRecord).SaveUseRecord("",IsInputFlag,"",Val)
	.i Result'>0 s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"写入使用记录信息失败:"_Result)
	
 	q:RetStr="" "OK"
	q RetStr
}

// add by ZY0217 2020-04-08

ClassMethod UsedRecource(ChangeType As %String = "", RowStr As %String = "")
{
	
	IF ChangeType="Clear"  d
	.;k ^DHCEQDeviceMap
	q:ChangeType="Clear" "数据已清:设备对照(DHC_EQDeviceMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s EquipNo=$p(RowStr,del,1),Year=$p(RowStr,del,2),Month=$p(RowStr,del,3)
 	s ResourceType=$p(RowStr,del,4),Price=$p(RowStr,del,5),Quantity=$p(RowStr,del,6)
 	s TotalFee=$p(RowStr,del,7)
 	s EquipNo=##Class(web.DHCEQCommon).Trim(EquipNo)
 	s Year=##Class(web.DHCEQCommon).Trim(Year)
 	s Month=##Class(web.DHCEQCommon).Trim(Month)
 	s ResourceType=##Class(web.DHCEQCommon).Trim(ResourceType)
 	s Price=##Class(web.DHCEQCommon).Trim(Price)
 	s Quantity=##Class(web.DHCEQCommon).Trim(Quantity)
 	s TotalFee=##Class(web.DHCEQCommon).Trim(TotalFee)
 	i EquipNo="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备编号不能为空:"_EquipNo)
 	i Year="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"年度不能为空:"_Year)
 	i Month="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"月份不能为空:"_Month)
 	i ResourceType="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"资源类型不能为空:"_ResourceType)
 	if RetStr'="" q RetStr
 	
 	s SourceType=1
 	s (tmpid,SourceID,ModelDR,UseLocDR)=""
	&SQL(Select EQ_RowID into :tmpid  from sqluser.DHC_EQEquip where EQ_No=:EquipNo)
	i tmpid=""  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备台账不存在这个设备:"_EquipNo)
	e  d
	.s SourceID=tmpid
	.s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
	.s UseLocDR=$p($g(^DHCEQEquip(SourceID)),"^",19)
	i RetStr'="" q RetStr
		
 	s (tmpid,ResourceTypeDR,Uom)=""
	&SQL(select RT_RowID into :tmpid from SQLUSER.DHC_EQCResourceType where RT_Desc=:ResourceType)
	i tmpid=""  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"消耗资源类型为空:"_ResourceType)
	e  d
	.s ResourceTypeDR=tmpid
	.s Uom=$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeDR)),"^",7)
	i RetStr'="" q RetStr
	s IsInputFlag="Y"
	
	i (ChangeType="Append") d
	.s Val=""
	.s Val=Val_"^"_Year
	.s Val=Val_"^"_Month
	.s Val=Val_"^"_SourceType
	.s Val=Val_"^"_SourceID
	.s Val=Val_"^"_ResourceTypeDR
	.s Val=Val_"^"_Price
	.s Val=Val_"^"_Uom
	.s Val=Val_"^"_Quantity
	.s Val=Val_"^"_TotalFee
	.s Val=Val_"^"_UseLocDR
	.s Val=Val_"^"_ModelDR
	.s Val=Val_"^"_""	//Remark
	.s Val=Val_"^"_"Y"	//IsInputFlag
	.s Result=##Class(web.DHCEQUsedResource).SaveData("","",Val,0)
	.i Result'>0 s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"写入消耗资源记录信息失败:"_Result)
	
 	q:RetStr="" "OK"
	q RetStr
}

}
