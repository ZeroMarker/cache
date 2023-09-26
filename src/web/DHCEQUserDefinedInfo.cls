/// Add By DJ 2013-07-24
/// --------------------------------------------------------------------------------------------------------------
/// modified by GR 2014-09-17 缺陷号 3178设备采购申请-设备采购申请-批量新增采购界面，不能直接提交采购申请，提示"第x行需要论证表"
/// 修改位置SaveData()
/// 缺陷原因：费用超过5000000要进行效益分析与论证两次更新，这两次更新的sourceID应该是相同的,原程序的sourceID设置错误
/// ---------------------------------------------------------------------------------------------------------------------- 
Class web.DHCEQUserDefinedInfo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveData(UDCodes, val, valList)
{
	k PLIST
	s updDate=+$H
	s updTime=$p($H,",",2)
	s PLIST(2)=$p(val,"^",1)	//SourceType
	s PLIST(3)=$p(val,"^",2)	//SourceID
	s updUser=$p(val,"^",3)
	s UDCount=$L(UDCodes,"^")
	s SourceID=$p(val,"^",2) //modified by GR 2014-09-17 缺陷号 3178
	//检测UserDefinedCode
	s (Flag,SQLCODE)=0
	f i=1:1:UDCount  d
	.q:Flag'=0
	.s UserDefinedCode=$p(UDCodes,"^",i)
	.i '$D(^DHCEQCCode("DHCEQCUserDefined",0,"Code",UserDefinedCode)) s Flag=-1111
	i Flag'=0 q Flag
	//检测UserDefinedListCode
	s UDLCount=$L(valList,"&")
	f i=1:1:UDLCount  d
	.q:Flag'=0
	.s FiledInfo=$p(valList,"&",i)
	.s FiledName=$p(FiledInfo,"^",1)
	.i '$D(^DHCEQCCode("DHCEQCUserDefinedList",0,"Name",FiledName)) s Flag=-1112
	i Flag'=0 q Flag
	
	TSTART
	f i=1:1:UDCount  d
	.q:SQLCODE'=0
	.s UserDefinedCode=$p(UDCodes,"^",i)
	.s PLIST(5)=$o(^DHCEQCCode("DHCEQCUserDefined",0,"Code",UserDefinedCode,0))
	.s RowID=$o(^DHCEQUserDefinedInfo(0,"SourceType",PLIST(2),+PLIST(3),PLIST(5),0))	//2014-04-08 DJ
	.i RowID=""  d
	..s PLIST(4)=0
	..s PLIST(6)=updUser
	..s PLIST(7)=updDate
	..s PLIST(8)=updTime
	..s PLIST(18)="N"
	..&SQL(Insert Into SQLUSER.DHC_EQUserDefinedInfo values :PLIST())
	..q:SQLCODE'=0
	..s RowID=$G(%ROWID)
	..;2014-04-08 DJ && modified by GR 2014-09-17 缺陷号 3178
	..i SourceID'=""  d
	...&SQL(Update SQLUSER.DHC_EQUserDefinedInfo Set UDI_SourceID=:SourceID Where UDI_RowID=:RowID)	//2014-04-08 DJ
	..e  d
	...&SQL(Update SQLUSER.DHC_EQUserDefinedInfo Set UDI_SourceID=:RowID Where UDI_RowID=:RowID)	//2014-04-08 DJ
	..q:SQLCODE'=0
	..K PLLIST
	..f j=1:1:UDLCount  d
	...q:SQLCODE'=0
	...s FiledInfo=$p(valList,"&",j)
	...s FiledName=$p(FiledInfo,"^",1)
	...s FiledValue=$p(FiledInfo,"^",2)
	...q:'$D(^DHCEQCCode("DHCEQCUserDefinedList",0,"UserDefinedName",PLIST(5),FiledName))
	...s FiledDR=$o(^DHCEQCCode("DHCEQCUserDefinedList",0,"UserDefinedName",PLIST(5),FiledName,0))
	...s FiledType=$p($g(^DHCEQCCode("DHCEQCUserDefinedList",FiledDR)),"^",5)
	...i FiledType=1 s FiledValue=##Class(web.DHCEQCommon).TransValueFromPage(FiledValue,"date")
	...;i FiledType=2 s FiledValue=$ZTH(FiledValue,4)
	...;日期格式统一调整    Modify by CSY 2017-03-02
	...i FiledType=2 s FiledValue=##Class(web.DHCEQCommon).TransValueFromPage(FiledValue,"time")
	...i FiledType=3 s FiledValue=##Class(web.DHCEQCommon).TransValueFromPage(FiledValue,"bool")
	...i FiledType=5 s FiledValue=##Class(web.DHCEQCommon).FormatNumber(FiledValue,"",2)
	...s PLLIST(2)=RowID
	...s PLLIST(3)=FiledDR
	...s PLLIST(4)=FiledValue
	...&SQL(Insert Into SQLUSER.DHC_EQUserDefinedInfoList values :PLLIST())
	.e  d
	..s PLIST(9)=updUser
	..s PLIST(10)=updDate
	..s PLIST(11)=updTime
	..&SQL(update SQLUSER.DHC_EQUserDefinedInfo values :PLIST() where UDI_RowID=:RowID)
	..q:SQLCODE'=0
	..f k=1:1:UDLCount  d
	...q:SQLCODE'=0
	...s FiledInfo=$p(valList,"&",k)
	...s FiledName=$p(FiledInfo,"^",1)
	...s FiledValue=$p(FiledInfo,"^",2)
	...q:'$D(^DHCEQCCode("DHCEQCUserDefinedList",0,"UserDefinedName",PLIST(5),FiledName))
	...s FiledDR=$o(^DHCEQCCode("DHCEQCUserDefinedList",0,"UserDefinedName",PLIST(5),FiledName,0))
	...s FiledType=$p($g(^DHCEQCCode("DHCEQCUserDefinedList",FiledDR)),"^",5)
	...i FiledType=1 s FiledValue=##Class(web.DHCEQCommon).TransValueFromPage(FiledValue,"date")
	...;i FiledType=2 s FiledValue=$ZTH(FiledValue,4)
	...;日期格式统一调整    Modify by CSY 2017-03-02
	...i FiledType=2 s FiledValue=##Class(web.DHCEQCommon).TransValueFromPage(FiledValue,"time")
	...i FiledType=3 s FiledValue=##Class(web.DHCEQCommon).TransValueFromPage(FiledValue,"bool")
	...s PLLIST(2)=RowID
	...s PLLIST(3)=FiledDR
	...s PLLIST(4)=FiledValue
	...s UDILRowID=$o(^DHCEQUserDefinedInfoList(0,"UserDefinedInfo",RowID,FiledDR,0))
	...i UDILRowID=""  d
	....&SQL(Insert Into SQLUSER.DHC_EQUserDefinedInfoList values :PLLIST())
	...e  d
	....&SQL(update SQLUSER.DHC_EQUserDefinedInfoList values :PLLIST() where UDIL_RowID=:UDILRowID)
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod GetListData(valCode, vSourceType, vSourceID)
{
	i vSourceID="" q ""	//2014-04-08 DJ
	s ReturnStr=""
	s Count=$L(valCode,"^")
	f i=1:1:Count  d
	.s UserDefinedCode=$p(valCode,"^",i)
	.s UDRowID=$o(^DHCEQCCode("DHCEQCUserDefined",0,"Code",UserDefinedCode,0))
	.q:UDRowID=""
	.s UDIRowID=$o(^DHCEQUserDefinedInfo(0,"SourceType",vSourceType,vSourceID,UDRowID,0))
	.q:UDIRowID=""
	.s UDLRowID=0
	.f  s UDLRowID=$o(^DHCEQCCode("DHCEQCUserDefinedList",0,"UserDefined",UDRowID,UDLRowID))  q:UDLRowID=""  d
	..s FiledType=$p($g(^DHCEQCCode("DHCEQCUserDefinedList",UDLRowID)),"^",5)
	..s FiledName=$p($g(^DHCEQCCode("DHCEQCUserDefinedList",UDLRowID)),"^",3)
	..i ReturnStr'="" s ReturnStr=ReturnStr_"&"
	..i '$D(^DHCEQUserDefinedInfoList(0,"UserDefinedInfo",UDIRowID,UDLRowID))  d
	...s ReturnStr=ReturnStr_FiledName_"^"_FiledType_"^"
	..e  d
	...s UDILRowID=0
	...f  s UDILRowID=$o(^DHCEQUserDefinedInfoList(0,"UserDefinedInfo",UDIRowID,UDLRowID,UDILRowID))  q:UDILRowID=""  d
	....s FiledValue=$p($g(^DHCEQUserDefinedInfoList(UDILRowID)),"^",3)
	....i FiledType=1 s FiledValue=##Class(web.DHCEQCommon).TransValueToPage(FiledValue,"date")
	....;i FiledType=2 s FiledValue=$ZT(FiledValue,4)
	....;日期格式统一调整    Modify by CSY 2017-03-02
	....i FiledType=2 s FiledValue=##Class(web.DHCEQCommon).TransValueFromPage(FiledValue,"time")
	....i FiledType=3 s FiledValue=##Class(web.DHCEQCommon).TransValueToPage(FiledValue,"bool")
	....s ReturnStr=ReturnStr_FiledName_"^"_FiledType_"^"_FiledValue
	....i FiledType=4  d
	.....s FiledDescName=$E(FiledName,1,$L(FiledName)-2)
	.....s FiledDescValue=..GetDesc(FiledDescName,FiledValue,UDLRowID)
	.....s ReturnStr=ReturnStr_"&"_FiledDescName_"^"_FiledType_"^"_FiledDescValue
	s ReturnStr=##class(web.DHCEQCommon).Replace(ReturnStr,$C(13,10),"\n")
	q ReturnStr
}

ClassMethod GetDesc(vName, vRowID, vFiledRowID)
{
	i ((vName="")||(vRowID="")) q ""
	i vFiledRowID'=""
	{
		s vUDRowID=$p($g(^DHCEQCCode("DHCEQCUserDefinedList",vFiledRowID)),"^",1)
		s vShortCode=$p($g(^DHCEQCCode("DHCEQCUserDefined",vUDRowID)),"^",3)
		i vShortCode'="" s vName=$E(vName,$L(vShortCode)+1,$L(vName))
	}
	i vName="Model" 		q $p($g(^DHCEQCCode("DHCEQCModel",vRowID)),"^",2)
	i vName="Provider" 		q $p($g(^DHCEQCCode("DHCEQCVendor",vRowID)),"^",2)
	i vName="Manufacturer" 	q $p($g(^DHCEQCCode("DHCEQCManufacturer",vRowID)),"^",2)
}

ClassMethod GetFiledData(valCode)
{
	i valCode="" q ""
	s Count=$L(valCode,"^")
	s ReturnStr=""
	s Flag=0
	f i=1:1:Count  d
	.q:Flag'=0
	.s UserDefinedCode=$p(valCode,"^",i)
	.s UDRowID=$o(^DHCEQCCode("DHCEQCUserDefined",0,"Code",UserDefinedCode,0))
	.i UDRowID="" s Flag=1
	.q:Flag'=0
	.s UDLRowID=0
	.f  s UDLRowID=$o(^DHCEQCCode("DHCEQCUserDefinedList",0,"UserDefined",UDRowID,UDLRowID))  q:UDLRowID=""  d
	..s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCUserDefinedList",UDLRowID)),"^",7)
	..q:InvalidFlag="Y"
	..s HiddenFlag=$p($g(^DHCEQCCode("DHCEQCUserDefinedList",UDLRowID)),"^",6)
	..q:HiddenFlag="Y"
	..s FiledType=$p($g(^DHCEQCCode("DHCEQCUserDefinedList",UDLRowID)),"^",5)
	..s FiledName=$p($g(^DHCEQCCode("DHCEQCUserDefinedList",UDLRowID)),"^",3)
	..i ReturnStr'="" s ReturnStr=ReturnStr_"&"
	..s ReturnStr=ReturnStr_FiledName_"^"_FiledType
	i Flag'=0 q ""
	q ReturnStr
}

/*********************************************************/
ClassMethod GetSourceData(SourceType, SourceID)
{
	i ((SourceType="")||(SourceID="")) q ""
	i SourceType="BuyRequest" q ..GetBuyRequestData(SourceID)
}

ClassMethod GetBuyRequestData(BRLRowID)
{
	i BRLRowID="" q ""
	s ReturnStr=""
	s BRRowID=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",1)
	
	s ReturnStr=ReturnStr_"RequestNo^0^"_$p($g(^DHCEQBuyRequest(BRRowID)),"^",35)_"&"
	s RequestLocDR=$p($g(^DHCEQBuyRequest(BRRowID)),"^",2)
	i RequestLocDR'=""  d
	.s ReturnStr=ReturnStr_"RequestLoc^0^"_##Class(web.DHCEQCommon).GetTrakNameByID("dept",RequestLocDR)_"&"
	e  d
	.s ReturnStr=ReturnStr_"RequestLoc^0^&"
	s RequestUserDR=$p($g(^DHCEQBuyRequest(BRRowID)),"^",28)
	i RequestUserDR'=""  d
	.s ReturnStr=ReturnStr_"RequestUser^0^"_##Class(web.DHCEQCommon).GetTrakNameByID("user",RequestUserDR)_"&"
	e  d
	.s ReturnStr=ReturnStr_"RequestUser^0^&"
	s UseLocDR=$p($g(^DHCEQBuyRequest(BRRowID)),"^",4)
	i UseLocDR'=""  d
	.s ReturnStr=ReturnStr_"UseLoc^0^"_##Class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)_"&"
	e  d
	.s ReturnStr=ReturnStr_"UseLoc^0^&"
	s ReturnStr=ReturnStr_"EquipName^0^"_$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",2)_"&"
	s ReturnStr=ReturnStr_"RequestNum^0^"_$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",20)_"&"
	s ReturnStr=ReturnStr_"PriceFee^0^"_$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",6)_"&"
	s ReturnStr=ReturnStr_"AdviseModel^0^"_$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",16)_"&"
	s ModelDR=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",3)
	i ModelDR'=""  d
	.s ReturnStr=ReturnStr_"Model^0^"_$p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)_"&"
	e  d
	.s ReturnStr=ReturnStr_"Model^0^&"
	s FundsOriginDR=$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",21)
	i FundsOriginDR'="" s ReturnStr=ReturnStr_"FundsOrigin"_FundsOriginDR_"^3^"_1_"&"
	s FTRowID=0
	f  s FTRowID=$o(^DHCEQCCode("DHCEQCFundsType",FTRowID))  q:FTRowID=""  d
	.q:FTRowID=FundsOriginDR
	.s ReturnStr=ReturnStr_"FundsOrigin"_FTRowID_"^3^"_0_"&"
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
	s Opinion2=..GetOneOption(ApproveType, BRRowID, "2")
	s ReturnStr=ReturnStr_"Opinion2^0^"_Opinion2_"&"
	s Opinion3=..GetOneOption(ApproveType, BRRowID, "3")
	s ReturnStr=ReturnStr_"Opinion3^0^"_Opinion3_"&"
	s ReturnStr=ReturnStr_"LimitYearsNum^0^"_$p($g(^DHCEQBuyRequestList(BRLRowID)),"^",26)_"&"
	
	q ReturnStr
}

ClassMethod GetOneOption(ApproveType, SourceID, Role)
{
	i SourceID="" q ""
	s OpptionStr=""
	s Flag=0
	s ALRowID=0
	f  s ALRowID=$o(^DHCEQApproveList(0,"Source",ApproveType,SourceID,ALRowID))  q:(ALRowID="")||(Flag'=0)  d
	.s CurRole=$p($g(^DHCEQApproveList(ALRowID)),"^",5)
	.q:CurRole'=Role
	.s Flag=1
	.s OpptionStr=$p($g(^DHCEQApproveList(ALRowID)),"^",3)
	q OpptionStr
}

/**********************************************************************/
Query UDDepreYear() As %Query(ROWSPEC = "TName:%String,TYears:%String,TRemark:%String")
{
}

ClassMethod UDDepreYearExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCUserDefinedYears",rowid)) quit:rowid=""  d
	.d ResetVariablesGetUDDepreYear
	.s TRowID=rowid
	.s Str=$g(^DHCEQCCode("DHCEQCUserDefinedYears",rowid))
	.s TName=$p(Str,"^",1)
	.s TYears=$p(Str,"^",2)
	.s TRemark=$p(Str,"^",3)
	.d OutputRowGetUDDepreYear
	Quit $$$OK
OutputRowGetUDDepreYear
	s Data=$lb(TName,TYears,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetUDDepreYear
	s (TName,TYears,TRemark)=""
	quit
}

ClassMethod UDDepreYearFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UDDepreYearExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod UDDepreYearClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UDDepreYearExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/***********************************************************************************************/
ClassMethod aa()
{
	s ^DHCEQCCode("DHCEQCUserDefinedYears",1)="一、房屋及建筑物^^"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",2)="1.业务用房^^"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",3)="钢结构^50年^"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",4)="钢筋混凝土结构^50年^"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",5)="砖混结构^30年^"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",6)="砖木结构^30年^"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",7)="2.简易房^8年^围墙、货场等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",8)="3.其他建筑物^8年^"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",9)="二、专用设备^^"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",10)="1.医用电子仪器^5年^心、脑、肌电图、监护仪器、除颤器、起博器等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",11)="2.光学仪器及窥镜^6年^验光仪、裂隙灯、手术显微镜、内窥镜等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",12)="3.医用超声仪器^6年^超声诊断仪、超声手术刀、超声治疗机等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",13)="4.激光仪器设备^5年^激光诊断仪、激光治疗仪、激光手术设备等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",14)="5.医用高频仪器设备^5年^高频手术、微波、射频治疗设备等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",15)="6.物理治疗及体疗设备^5年^电疗、光疗、理疗、生物反馈仪等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",16)="7.高压氧舱^6年^"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",17)="8.中医仪器设备^5年^脉相仪、舌色相仪、经络仪、穴位治疗机、电针治疗仪器"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",18)="9.医用磁共振设备^6年^永磁型、常导型、超导型等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",19)="10.医用X线设备^6年^X射线诊断、治疗设备、CT、造影机、数字减影机、X光刀"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",20)="11.高能射线设备^8年^医用加速器、放射治疗模拟机等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",21)="12.医用核素设备^6年^核素扫描仪、SPECT、钴60机、PET等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",22)="13.临床检验分析仪器^5年^电泳仪、色谱仪、生化分析仪、血氧分析仪、蛋白测定仪、肌肝测定仪、酶标仪等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",23)="14.体外循环设备^5年^人工心肺机、透析机等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",24)="15.手术急救设备^5年^手术床、麻醉机、呼吸机、吸引器等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",25)="16.口腔设备^6年^牙钻、综合治疗台等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",26)="17.病房护理设备^5年^病床、推车、婴儿暖箱、通讯设备、供氧设备等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",27)="18.消毒设备^6年^各类消毒器、灭菌器等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",28)="19.其他^5年^以上未包括的医药专用设备等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",29)="三、一般设备^^"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",30)="1.家具用具及其他类^5年^"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",31)="2.交通运输设备^10年^"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",32)="3.电子产品及通信设备^5年^彩电、摄像机、服务器、计算机、电话、传真等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",33)="4.电气设备^5年^发电机、冰箱、空调、洗衣机等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",34)="5.通用设备^10年^锅炉、电梯、空调机组、冷藏柜等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",35)="四、其他固定资产^^"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",36)="1.仪器仪表及量具^5年^电表、万能表、显微镜等"
	s ^DHCEQCCode("DHCEQCUserDefinedYears",37)="2.其他^5年^以上未包括的其他固定资产"
}

}
