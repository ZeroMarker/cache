Class web.DHCEQ.BA.BUSUseRecord Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSUseRecord","GatherDataList","1","1","2019")
Query GatherDataList(SourceType As %String = "", SourceID As %String = "", InitYear As %String = "") As %Query(ROWSPEC = "TMonthStr:%String:月份,TFlag:%String:已采标记")
{
}

ClassMethod GatherDataListExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", InitYear As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=0
	i (SourceType="")||(SourceID="")||(InitYear="") Quit $$$OK
 	
	s StartDate=$ZDH(InitYear_"-01-01",3)-1
	s EndDate=+$h
	i StartDate>EndDate Quit $$$OK
	
	f Date=StartDate:1:EndDate  d
	.s TYear=+$E($ZD(Date,3),1,4)
	.s TMonth=+$E($ZD(Date,3),6,7)
	.s TFlag="N"
	.i $data(^DHCEQUseRecordStat(0,"SourceMonth",SourceType,SourceID,TYear,TMonth))'=0 s TFlag="Y"
	.i TMonth<10 s TMonth="0"_TMonth
	.s TMonthStr=TYear_"-"_TMonth
	.d OutputRowGatherDataList
	.i TMonth=12  d
	..s TYear=TYear+1
	..s TMonth=1
	.e  d
	..s TMonth=TMonth+1
	.s Date=$ZDH(TYear_"-"_TMonth_"-01",3) - 1
 	
	Quit $$$OK
OutputRowGatherDataList
	s Data=$lb(TMonthStr,TFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GatherDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GatherDataListExecute ]
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

ClassMethod GatherDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GatherDataListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Add by：ZY0234 20200609
/// 入参：JsonData：采集数据中直接设置成json格式
/// modify by lmm 2018-05-22 增加入参 OeoStr：医嘱Rowid:部位代码@部位代码,检查项目描述;医嘱Rowid:部位代码@部位代码,检查项目描述
/// 返回：成功返回RowID，失败返回值小于等于0
/// w ##Class(web.DHCEQ.BA.BUSUseRecord).SaveUseRecord("","N","1","1^615^23/05/2018^^23/05/2018^^1^^162^168313&王化根&男&38872^1634.00^1634.00^2018^05^2^DHC-RIS^MR20180522044^N^2^N^^^^^^^^1237^^阳性^^^","1443935||19:TB01~JC000065*1443935||18:TB01~JC000067*1443935||17:TB01~JC000768*1443935||16:TB01~JC000689")
ClassMethod SaveUseRecord(JsonData, IsInputFlag As %String = "")
{
	new PLIST,URRowID,ExType,ExID,InputFlag
	k PLIST
	
	//通过界面录入的时候,拼成json字符串,需要转换成Json.从接口采集的数据直接是Json对象格式
	i IsInputFlag="Y" s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(JsonData)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQUseRecord",JsonData,.PLIST)
	s URRowID=JsonData.URRowID
	s InputFlag=JsonData.URIsInputFlag
	s ExType=JsonData.URExType
	s ExID=JsonData.URExID
	s DoctorOrderID=JsonData.URDoctorOrderID  //modified by wy 2022-3-4 WY0097
	;如果是系统采集数据,检查是否已经采集过该记录，
	;如果采集过，返回不操作
	
	///非手工录入，不能修改
	i (URRowID'="")&&(InputFlag'="Y") q 0
	
	i (InputFlag'="Y")
	{
		///modified by ZY0279 20210819 变量错误导致死循环
		///ExID 存医嘱ID,避免通过不同系统重复采集了收入数据.
		s ExitFlag=0
		s vExType=""
		f  s vExType=$o(^DHCEQUseRecord(0,"ExID",vExType))  q:(vExType="")||(ExitFlag=1)  d
		.i $o(^DHCEQUseRecord(0,"ExID",vExType,ExID,0))'="" s ExitFlag=1
		i ExitFlag=1 q 0
	}
	;Status,系统采集时直接置为审核状态，否则置为新增
	i InputFlag="Y"
	{	s PLIST(20)=0	}
	else
	{	s PLIST(20)=2	}
	
	Set $ZT="TrapSaveUseRecord"
	TStart
	i URRowID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQUseRecord Values :PLIST())
		Set URRowID=$g(%ROWID)
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQUseRecord Values :PLIST() where UR_RowID = :URRowID)
	}
 	if SQLCODE 
 	{
	 	TRollBack
	 	q SQLCODE
 	}
	///modified by ZY0276 20210713
	//modified by wy 2022-3-4 WY0097
   	i PLIST(20)=2
 	{
	 	s SQLCODE=##Class(web.DHCEQ.BA.BUSUseRecord).InsertConsumable(URRowID)
		if SQLCODE 
	 	{
		 	TRollBack
		 	q SQLCODE
	 	}
	}
 	if DoctorOrderID'=""
 	{
		s SQLCODE=##Class(web.DHCEQ.BA.BUSUseRecord).InsertConsumableByOrderID(URRowID)
		if SQLCODE 
	 	{
		 	TRollBack
		 	q SQLCODE
	 	}
	}
	
 	TCommit
 	q URRowID
TrapSaveUseRecord
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK
 	q ErrorMsg_"^"_SQLCODE
}

// modified by wy 2022-3-4 WY0097

/// modified by ZY0276 20210713
/// w ##Class(web.DHCEQUseRecord).InsertConsumable("1209","1443935||16:TB01~JC000689")
ClassMethod InsertConsumable(UseRecordID)
{
	s OeoStr=$p($g(^DHCEQUseRecord(UseRecordID)),"^",38)
	//add by lmm 2018-05-18 begin
	s oeoLength=$l(OeoStr,"*")
	s SQLCODE=0
	for i=1:1:oeoLength
		{
			s oeolist=$p(OeoStr,"*",i)
			s oeorowid=$p(oeolist,":",1)
			s partcodeinfo=$p(oeolist,":",2)
			s partcodestr=$p(partcodeinfo,"~",1)
			 
			//add by lmm 2018-05-29 begin 
			/*
			s oeordid=$p(oeorowid,"||",1)    //医嘱表
			s oeorichildsub=$p(oeorowid,"||",2)
			s depid=$o(^OEORD(oeordid,"I",oeorichildsub,"DEP",""))
			if depid'="" s depinfo=$g(^OEORD(oeordid,"I",oeorichildsub,"DEP",depid))
			 */
			//add by lmm 2018-05-29 begin 
			 
			s partcodeLength=$l(partcodestr,"@")  //xin
			s checkitemcode=$p(partcodeinfo,"~",2)   //$p(oeolist,"~",2)
			s checkitemid=""
			i checkitemcode'=""  d
			.s checkitemidSubscript=$o(^ARCIM(0,"Code",checkitemcode,""))   //医嘱项表
			.i checkitemidSubscript'="" d
			..s checkitemidVersion=$o(^ARCIM(0,"Code",checkitemcode,checkitemidSubscript,""))
			..s checkitemid=checkitemidSubscript_"||"_checkitemidVersion
			//w checkitemid_"?"
			s checkmethodid=""
			s checkmethodrowid=0
			f  s checkmethodrowid=$o(^DHCDocRisOrderMethod(checkmethodrowid))  q:(checkmethodrowid="")  d 
			.s checkid=0
			.f  s checkid=$o(^DHCDocRisOrderMethod(checkmethodrowid,"ARCIM",checkid))  q:(checkid="")  d 
			..q:(checkitemid'=$g(^DHCDocRisOrderMethod(checkmethodrowid,"ARCIM",checkid)))
			..s checkmethoddesc=$p($g(^DHCDocRisOrderMethod(checkmethodrowid)),"^",1)
			..;q:(depinfo'="")&&(depinfo'[checkmethoddesc)
			..s checkmethodid=checkmethodrowid
			s checkdealid=""  //后期根据检查处理与耗材是否有关，进行添加
		//s checkmethodid=14
			for j=1:1:partcodeLength
			{
				s partcode=$p(partcodestr,"@",j)
				s partid=""
				i partcode="" s checkmethodid=""
				if (partcode'="")  d
				.s partid=$o(^MRC("BODP",0,"Code",partcode,""))   //部位表
				s SubKey=""
				s SubKey=partid_","_checkmethodid_","_checkdealid   //部位id^检查方法id^检查处理id
				if (SubKey=",,") s SubKey=""
				s SQLCODE=..InsertUseConsumableItem(UseRecordID, SubKey,checkitemid)
				i SQLCODE q
			}
			
		}
		s OeoStr=""
		q SQLCODE
}

/// 生成使用记录相关的消耗项目
/// 入参：
/// 		UseRecordID：使用记录ID
/// 返回值：
/// 		成功返回0，失败返回SQLCODE
/// w ##Class(web.DHCEQUseRecord).InsertUseConsumableItem("267","27,9,")
ClassMethod InsertUseConsumableItem(UseRecordID, SubKey As %String = "", checkitemid As %String = "")
{
	n (UseRecordID, SubKey,checkitemid)
	i UseRecordID="" q 0
	s SourceType=$p($g(^DHCEQUseRecord(UseRecordID)),"^",1)
	s SourceID=$p($g(^DHCEQUseRecord(UseRecordID)),"^",2)
	s ServiceItemDR=$p($g(^DHCEQUseRecord(UseRecordID)),"^",15)
	s ModelDR=$p($g(^DHCEQUseRecord(UseRecordID)),"^",28)
	s URNum=$p($g(^DHCEQUseRecord(UseRecordID)),"^",7)
	
	;Add by JDL 2010-11-09  JDL0057
	s UseLocDR=$p($g(^DHCEQUseRecord(UseRecordID)),"^",9)
	s AddDate=+$H
	s UseDate=$p($g(^DHCEQUseRecord(UseRecordID)),"^",3)	
	k UCIList
	s UCIList(2)=UseRecordID
	s UCIList(10)=UseLocDR
	//s UCIList(13)=ServiceItemDR  //modify by lmm 2018-05-30
	s UCIList(16)=AddDate
	s UCIList(17)=UseDate
	s Modulus=1
	s Node="Source"
	s ItemDR=ServiceItemDR
	
	s SQLCODE=0
	s FindFlag=0
	
	//add by lmm 2018-05-30 begin
	d CheckCCI
	;出错返回错误码
	;i SQLCODE q SQLCODE
	;当有相应的服务项目消耗定义，返回SQLCODE
	//add by lmm 2018-05-30 end
	
	d CheckUCI
	;出错返回错误码
	i SQLCODE q SQLCODE
	;当有相应的服务项目消耗定义，返回SQLCODE
	i FindFlag=1 q SQLCODE
	
	;Add by JDL 2010-11-09  JDL0057
	;根据服务项包含的明细项是否有定义消耗
	d CheckServiceDetail	
	i SQLCODE q SQLCODE
	i FindFlag=1 q SQLCODE
	
	;当没有设备服务消耗定义时，则检测对应设备项服务消耗定义
	i (FindFlag=0)&&(SourceType=1)
	{
		;Add by JDL 2010-11-09  JDL0057
		s Modulus=1
		s Node="Source"
		s ItemDR=ServiceItemDR
		
		s SourceType=2
		s SourceID=$p($g(^DHCEQEquip(SourceID)),"^",7)
		d CheckUCI
		
		;Add by JDL 2010-11-09  JDL0057
		;当设备项服务没有对应消耗定义
		;判断服务项包含的明细项是否有定义消耗
		i SQLCODE q SQLCODE
		i FindFlag=1 q SQLCODE		
		d CheckServiceDetail	
		i SQLCODE q SQLCODE
		i FindFlag=1 q SQLCODE
	}
	
	;当设备及设备项都没有服务消耗定义时，则检测服务消耗定义
	s ConsumableRowID=0
	f  s ConsumableRowID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"ServiceConsumable",ServiceItemDR,ConsumableRowID))  q:(ConsumableRowID="")||(SQLCODE'=0)  d
	.s RowID=0
	.f  s RowID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"ServiceConsumable",ServiceItemDR,ConsumableRowID,RowID))  q:((RowID="")||(SQLCODE'=0))  d
	..q:(SubKey'=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",15)) //add by lmm 2018-05-23
	..q:(checkitemid=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",6)) //add by lmm 2018-05-23
	..s SCSourceType=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",1)
	..q:SCSourceType'=""
	..s SCSourceID=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",2)
	..q:SCSourceID'=""
	..s FindFlag=1
	..d InsertUCI
	
	;Add by JDL 2010-11-09  JDL0057
	;当服务项没有对应消耗定义,判断服务项包含的明细项是否有定义消耗
	i SQLCODE q SQLCODE
	i FindFlag=1 q SQLCODE
	s ItemDR=0
	f  s ItemDR=$o(^DHCEQCCode("DHCEQCServiceDetails",0,"ServiceItem",ServiceItemDR,ItemDR))  q:(ItemDR="")||(SQLCODE'=0)  d 
	.s SDRowID=0
	.f  s SDRowID=$o(^DHCEQCCode("DHCEQCServiceDetails",0,"ServiceItem",ServiceItemDR,ItemDR,SDRowID))  q:(SDRowID="")||(SQLCODE'=0)  d 
	..q:$p(^DHCEQCCode("DHCEQCServiceDetails",SDRowID),"^",5)'="N"
	..s Modulus=$p(^DHCEQCCode("DHCEQCServiceDetails",SDRowID),"^",3)
	..i Modulus="" s Modulus=1
	..s RowID=0
	..f  s RowID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"ServDetItem",ItemDR,RowID))  q:(RowID="")||(SQLCODE'=0)  d
	...s SCSourceType=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",1)
	...q:SCSourceType'=""
	...s SCSourceID=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",2)
	...q:SCSourceID'=""
	...d InsertUCI

	q SQLCODE
CheckServiceDetail
	;Add by JDL 2010-11-09  JDL0057
	;根据服务项包含的明细项是否有定义消耗
	s Node="SourceServDetItem"
	s ItemDR=0
	f  s ItemDR=$o(^DHCEQCCode("DHCEQCServiceDetails",0,"ServiceItem",ServiceItemDR,ItemDR))  q:(ItemDR="")||(SQLCODE'=0)  d 
	.s SDRowID=0
	.f  s SDRowID=$o(^DHCEQCCode("DHCEQCServiceDetails",0,"ServiceItem",ServiceItemDR,ItemDR,SDRowID))  q:(SDRowID="")||(SQLCODE'=0)  d 
	..q:$p(^DHCEQCCode("DHCEQCServiceDetails",SDRowID),"^",5)'="N"
	..s Modulus=$p(^DHCEQCCode("DHCEQCServiceDetails",SDRowID),"^",3)
	..i Modulus="" s Modulus=1
	..d CheckUCI
	q
CheckUCI
	s ConsumableRowID=0
	q:(SourceType="")||(SourceID="")||(ItemDR="")
	f  s ConsumableRowID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,Node,SourceType,SourceID,ItemDR,ConsumableRowID)) q:(ConsumableRowID="")||(SQLCODE'=0)  d
	.s RowID=0
	.f  s RowID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,Node,SourceType,SourceID,ItemDR,ConsumableRowID,RowID))  quit:((RowID="")||(SQLCODE'=0))  d
	..;w SubKey_"^"_$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",15)_"^"_RowID_"^"_Node_"&"
	..q:SubKey'=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",15)   //add by lmm 2018-05-23
	..;当SourceType为设备项时，需要判断机型是否一致
	..s CISModelDR=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",7)
	..q:((SourceType=2)&&(CISModelDR'="")&&(CISModelDR'=ModelDR))
	..;Add by JDL 2010-11-09  JDL0057
	..s FindFlag=1
	..d InsertUCI
	q
	
	//add by lmm 2018-05-30 begin
CheckCCI
	;当设备及设备项都没有服务消耗定义时，则检测服务消耗定义
	
	s servicedr=0
	f  s servicedr=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"ServiceConsumable",servicedr))  q:(servicedr="")||(SQLCODE'=0)  d
	.q:(checkitemid'=$p($g(^DHCEQCCode("DHCEQCServiceItem",servicedr)),"^",6)) //add by lmm 2018-05-23
	.s ConsumableRowID=0
	.f  s ConsumableRowID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"ServiceConsumable",servicedr,ConsumableRowID))  q:(ConsumableRowID="")||(SQLCODE'=0)  d
	..s RowID=0
	..f  s RowID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"ServiceConsumable",servicedr,ConsumableRowID,RowID))  q:((RowID="")||(SQLCODE'=0))  d
	...s SCSourceType=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",1)
	...q:(SourceType'=SCSourceType)&&(SourceType'="")
	...s SCSourceID=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",2)
	...q:(SourceID'=SCSourceID)&&(SourceID'="")
	...s subkey=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",15)
	...q:subkey'=""
	...s ServiceItemDR=servicedr
	...d InsertUCI	
	q
	//add by lmm 2018-05-30 end
	
InsertUCI
	s ConsumableItemDR=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",4)
	s UOMDR=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",5)
	s Quantity=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",6)
	s Quantity=URNum*Quantity*Modulus
	s TPrice=##Class(web.DHCEQUseRecord).GetConsumableItemPrice(ConsumableItemDR,UOMDR)  //add by zx 2014-09-16 统计收费
	s Price=$P(TPrice,"^",1)  
	s PayPrice=$P(TPrice,"^",2)
	s Amount=Quantity*Price
	s PayAmount=Quantity*PayPrice
	;Add by JDL 2010-11-09  JDL0057
	s QuantityType=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",8)
	s ServDetItem=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",RowID)),"^",9)
	s ExType=$p($g(^DHCEQCCode("DHCEQCConsumableItem",ConsumableItemDR)),"^",5)
	s ExID=$p($g(^DHCEQCCode("DHCEQCConsumableItem",ConsumableItemDR)),"^",6)
	s UCIList(3)=ConsumableItemDR
	s UCIList(13)=ServiceItemDR   //add by lmm 2018-05-30
	;绝对量的时候，才保存数量及单价金额
	i QuantityType="1"
	{
		s UCIList(4)=UOMDR
		s UCIList(5)=Quantity
		s UCIList(6)=Price
		s UCIList(7)=Amount
		s UCIList(28)=PayPrice  //add  by zx 2014-09-16 
		s UCIList(29)=PayAmount
		k UCIList(9)
	}
	else
	{
		k UCIList(4)
		k UCIList(5)
		k UCIList(6)
		k UCIList(7)
		k UCIList(28)
		k UCIList(29)
		s UCIList(9)=Quantity	;RelativeQty
	}
	s UCIList(8)=QuantityType
	s UCIList(11)=ExType
	s UCIList(12)=ExID
	s UCIList(14)=ServDetItem
	s UCIList(15)=URNum*Modulus
	&SQL(Insert Into SQLUSER.DHC_EQUseConsumableItem values :UCIList())	
	
	;&SQL(Insert Into SQLUSER.DHC_EQUseConsumableItem (UCI_UseRecordDR,UCI_ConsumableItemDR,UCI_UOMDR,UCI_Quantity,UCI_Price,UCI_Amount) Values (:UseRecordID,:ConsumableItemDR,:UOMDR,:Quantity,:Price,:Amount))
	q
}

/// add by ZY0283 20211116
/// 根据使用记录中的医嘱id获取医嘱对应收费项目明细数据,记录到DHC_EQUseRecordList表中,同时把其中药品耗材类的收费项目记到消耗材料中
/// 入参：使用记录的ID
/// 返回值SQLCODE  0  成功，否则失败
/// w ##Class(web.DHCEQ.BA.BUSUseRecord).InsertConsumableByOrderID("6915")
ClassMethod InsertConsumableByOrderID(URRowID)
{
	new CostIDs,n,OEOrderID,OrderDetal,Len,SQLCODE,Date,ServiceItemDR
	s Date=+$H
	k URLLIST
	s SQLCODE=0
	s CostIDs=","_##class(web.DHCEQCommon).GetSysInfo("992013")_","_##class(web.DHCEQCommon).GetSysInfo("992014")_","
 	s OEOrderID=$p($g(^DHCEQUseRecord(URRowID)),"^",38)
 	s ServiceItemDR=$p($g(^DHCEQUseRecord(URRowID)),"^",15)
	//modified by cjt 20230129 需求号2888051 方法GetOrderFeeDetal已经不再使用
	//s OrderDetal=##class(web.DHCBillInterface).GetOrderFeeDetal(OEOrderID)
	//if OrderDetal="" s OrderDetal=##class(web.DHCEQ.BA.BUSUseRecord).getOETarInfo(OEOrderID)
	s OrderDetal=##class(web.DHCEQ.BA.BUSUseRecord).getOETarInfo(OEOrderID)
	s Len=$l(OrderDetal,"&!")
	s URLLIST(2)=URRowID
	s URLLIST(3)=OEOrderID
	for n=1:1:Len
	{
		q:SQLCODE'=0
		s OneList=$p(OrderDetal,"&!",n)
		q:OneList=""
		//ItemID_"^"_ItemCode_"^"_ItemDesc_"^"_ECCateDesc_"^"_ItemQty_"^"_ItemPrice_"^"_ItemSum_"^"_uomDesc
		s URLLIST(4)=$p(OneList,"^",1)		//TariDR
		s URLLIST(5)=$p(OneList,"^",2)		//TariCode
		s URLLIST(6)=$p(OneList,"^",3)		//TariDesc
		s URLLIST(7)=$p(OneList,"^",4)		//ECCateID
		s URLLIST(8)=$p(OneList,"^",5)		//ECCateDesc
		s URLLIST(9)=$p(OneList,"^",6)		//Qty
		s URLLIST(10)=##Class(web.DHCEQCommon).FormatNumber($p(OneList,"^",7),"",2)		//Price
		s URLLIST(11)=##Class(web.DHCEQCommon).FormatNumber($p(OneList,"^",8),"",2)		//Sum
		s URLLIST(12)=$p(OneList,"^",9)		//uomDR
		s URLLIST(13)="N"					//DrugFlag
		s URLLIST(15)=$p(OneList,"^",10)	//结算标记 add by wy 2021-11-25 
		i CostIDs[(","_URLLIST(7)_",")
		{
			s URLLIST(13)="Y"
			
			k UCIList
			s UCIList(2)=URRowID
			//modified by cjt 20230129 需求号2888051 修改ConsumableInfo处理逻辑
			s ConsumableInfo="^"_URLLIST(6)_"^"_URLLIST(5)_"^"_URLLIST(10)_"^"_URLLIST(12)_"^DHC-HIS^"_URLLIST(4)_"^"_URLLIST(6)
			s UCIList(3)=##class(web.DHCEQCConsumableItem).SaveData("","",ConsumableInfo,"0")
			q:UCIList(3)'>0
			s UCIList(4)=URLLIST(12)   //单位
			s UCIList(5)=URLLIST(9)
			s UCIList(6)=URLLIST(10)
			s UCIList(7)=URLLIST(11)
			s UCIList(8)="1"			//QuantityType
			s UCIList(10)=""			//UseLocDR
			s UCIList(11)=""			//ExType
			s UCIList(12)=""			//ExID
			s UCIList(13)=ServiceItemDR //add by lmm 2018-05-30
			s UCIList(14)=""				//ServDetItem
			s UCIList(15)=""				//URNum*Modulus
			s UCIList(16)=Date
			s UCIList(17)=Date
			s UseDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQUseRecord(URRowID)),"^",3),"date")      //统计月份
			//modified by wy 2021-11-21
			s UCIList(19)= $p(UseDate,"-",1,2)  //统计月份
			s UCIList(20)="Y"   //是否是按月统计
			s UCIList(21)=$p($g(^DHCEQUseRecord(URRowID)),"^",1)   //来源类型：1：设备
			s UCIList(22)=$p($g(^DHCEQUseRecord(URRowID)),"^",2)  //设备ID
			&SQL(Insert Into SQLUSER.DHC_EQUseConsumableItem values :UCIList())	
		}
		s URLLIST(14)=""					//IncItmDR
		&SQL(Insert Into SQLUSER.DHC_EQUseRecordList values :URLLIST())	
	}
	q SQLCODE
}

/// Creator: jinlei
/// CreateDate: 2021-11-23
/// Descript: 医嘱项获取收费项
/// w ##class(web.DHCEQ.BA.BUSUseRecord).getOETarInfo("19786395||34")
ClassMethod getOETarInfo(OrdItem)
{
	;s $ZT="getOETarInfoErr"
	kill ^TMPGetOrderFeeDetail($i)
	quit:OrdItem="" ""
	set Order=+OrdItem
	set Adm=$p(^OEORD(Order),"^",1)
	set AdmType=$p(^PAADM(Adm),"^",2)

	i '$D(^DHCPECRMO(0,"OEORI",OrdItem)) q ""
	s CRMOID=$o(^DHCPECRMO(0,"OEORI",OrdItem,0))
	s PreItemID=$P(^DHCPECRMO(CRMOID),"^",2)
	q:PreItemID="" ""
	s Status=$P(^DHCPECRMO(CRMOID),"^",4)
	s PIADM=+PreItemID
	s CRMGADM=$P(^DHCPEPreIADM(PIADM),"^",2)
	s GAdm=""
	i CRMGADM'="" d
	.s GADMRowId=$O(^DHCPEGADM(0,"CRMGADM",CRMGADM,0))
	.s GAdm=$P(^DHCPEGADM(GADMRowId),"^",3)
	
	s HPInvStr=""
	s InvID=0 f  s InvID=$O(^DHCPEINVPRT(0,"ADM",Adm,InvID))  q:InvID=""  d
	.s HPInvStr=HPInvStr_"^"_InvID
	i GAdm'="" d
	.s InvID=0 f  s InvID=$O(^DHCPEINVPRT(0,"ADM",GAdm,InvID))  q:InvID=""  d
	..s HPInvStr=HPInvStr_"^"_InvID
	
	for i=1:1:$L(HPInvStr,"^")  d
	.s HPInvNo=$P(HPInvStr,"^",i)
	.q:HPInvNo=""
	.s TARITEMSub=""
	.f  s TARITEMSub=$O(^DHCPEOEITEM(HPInvNo,"OEITEM",PreItemID,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	..s Info=$G(^DHCPEOEITEM(HPInvNo,"OEITEM",PreItemID,"TARITEM",TARITEMSub))
	..s TarItemDr=$P(Info,"^",1)
	..s TarItemQty=$P(Info,"^",3)
	..s TarItemPrice=$P(Info,"^",2)
	..s TarItemPrice=$FN(TarItemPrice,"",2)
	..s TarItemSum=$P(Info,"^",4)
	..s TarItemSum=$FN(TarItemSum,"",2)
	..set ^TMPGetOrderFeeDetail($i,TarItemDr,TarItemPrice,"TarItemQty")=+$g(^TMPGetOrderFeeDetail($i,TarItemDr,TarItemPrice,"TarItemQty"))+TarItemQty
	..set ^TMPGetOrderFeeDetail($i,TarItemDr,TarItemPrice,"TarItemSum")=+$g(^TMPGetOrderFeeDetail($i,TarItemDr,TarItemPrice,"TarItemSum"))+TarItemSum

	if Status="OC" 
	{
		s CurDate=$p($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2))),"^",12)
		s GroupItemID=$p($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2))),"^",4)
		i GroupItemID'="" d
		.s CurDate=$p($g(^DHCPEPreGADM(+GroupItemID,"Team",$p(GroupItemID,"||",2),"ORDITEM",$p(GroupItemID,"||",3))),"^",9)
		s arcitmid=$p($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2))),"^",1)
		s ItemADMType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",PreItemID))
		s HospID=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
		s orderQty=+$G(^DHCPEDataEx("DHCPEPreIOrdItem","Qty",PreItemID))
		i orderQty=0 s orderQty=1
		
		s Fact=0
		s Sub=0
		f  s Sub=$o(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2),"FEE",Sub)) q:Sub=""  d
		.s DataStr=$g(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2),"FEE",Sub))
		.s AuditId=$p(DataStr,"^",5)
		.q:AuditId=""
		.s Flag=$p($g(^DHCPEPreA(AuditId)),"^",21)
		.q:Flag="NU"
		.s OneFact=$p(DataStr,"^",2)
		.i OneFact="" s OneFact=0
		.s Fact=Fact+OneFact
		
		s Amount=+$p($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2))),"^",14)
		;
		q:+Amount=0
		s TarItemDr=0
		f  s TarItemDr=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItemDr)) q:TarItemDr=""  d
		.s StartDate=0
		.f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItemDr,StartDate)) q:(StartDate="")||(StartDate>CurDate)  d
		..s OLTID=0
		..f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItemDr,StartDate,OLTID)) q:OLTID=""  d
		...s EndDate=$p(^DHCOLT(OLTID),"^",5)
		...q:(EndDate'="")&&(EndDate<CurDate)
		...s qty=$p(^DHCOLT(OLTID),"^",3)
		...;s CurPrice=+##class(web.UDHCJFPRICE).GetItmPrice(TarItemDr,CurDate,"",ItemADMType,"",HospID)   //得到当前计费项金额
		...s CurPrice=##class(web.UDHCJFPRICE).GetItmPrice(TarItemDr,CurDate,"",ItemADMType,"",HospID,"^^^"_Adm_"^^^") //得到当前计费项金额
		...s Price=$p(CurPrice,"^",4)
		...s TarItemPrice=(Fact/Amount)*Price
		
		...s TarItemQty=qty*orderQty
		...s TarItemSum=(Fact/Amount)*TarItemQty*Price
		...set ^TMPGetOrderFeeDetail($i,TarItemDr,TarItemPrice,"TarItemQty")=+$g(^TMPGetOrderFeeDetail($i,TarItemDr,TarItemPrice,"TarItemQty"))+TarItemQty
		...set ^TMPGetOrderFeeDetail($i,TarItemDr,TarItemPrice,"TarItemSum")=+$g(^TMPGetOrderFeeDetail($i,TarItemDr,TarItemPrice,"TarItemSum"))+TarItemSum

	}	

	set ItemDetail=""
	set ItemID=""
	for  set ItemID=$o(^TMPGetOrderFeeDetail($i,ItemID))  quit:ItemID=""  do
	.set ACSubCate=$p(^DHCTARI(ItemID),"^",5)			;会计子类
	.set IPSubCate=$p(^DHCTARI(ItemID),"^",14)			;住院子类
	.set OPSubCate=$p(^DHCTARI(ItemID),"^",15)			;门诊子类
	.set ECSubCate=$p(^DHCTARI(ItemID),"^",16)			;核算子类
	.set ACCateDr=$p(^DHCTarC("AC",ACSubCate),"^",3)
	.set ACCateDesc=$p(^DHCTarC("TAC",ACCateDr),"^",2)	;会计大类
	.set OPCateDr=$p(^DHCTarC("OC",OPSubCate),"^",3)
	.set OPCateDesc=$p(^DHCTarC("TOC",OPCateDr),"^",2)	;门诊大类
	.set IPCateDr=$p(^DHCTarC("IC",IPSubCate),"^",3)	
	.set IPCateDesc=$p(^DHCTarC("TIC",IPCateDr),"^",2)	;住院大类
	.set ECCateDr=$p(^DHCTarC("EC",ECSubCate),"^",3)	
	.set ECCateDesc=$p(^DHCTarC("TEC",ECCateDr),"^",2)	;核算大类
	.;set CateDr=OPCateDr,CateDesc=OPCateDesc
	.;if AdmType="I" set CateDr=IPCateDr,CateDesc=IPCateDesc
	.set CateDr=ECCateDr,CateDesc=ECCateDesc
	.set tariUom=$p($g(^DHCTARI(ItemID)),"^",3)
	.set ItemCode=$p($g(^DHCTARI(ItemID)),"^",1)
	.set ItemDesc=$p($g(^DHCTARI(ItemID)),"^",2)
  	.set uomDesc=""
  	.set:tariUom'="" uomDesc=$p($g(^CT("UOM",tariUom)),"^",2)
	.set ItemPrice=""
	.for  set ItemPrice=$o(^TMPGetOrderFeeDetail($i,ItemID,ItemPrice))  quit:ItemPrice=""  do
	..set ItemQty=$g(^TMPGetOrderFeeDetail($i,ItemID,ItemPrice,"TarItemQty"))
	..set ItemSum=$g(^TMPGetOrderFeeDetail($i,ItemID,ItemPrice,"TarItemSum"))
	..quit:ItemQty=0
	..if ItemDetail="" set ItemDetail=ItemID_"^"_ItemCode_"^"_ItemDesc_"^"_CateDr_"^"_CateDesc_"^"_ItemQty_"^"_ItemPrice_"^"_ItemSum_"^"_uomDesc_"^"_Status
	..else  set ItemDetail=ItemDetail_"&!"_ItemID_"^"_ItemCode_"^"_ItemDesc_"^"_CateDr_"^"_CateDesc_"^"_ItemQty_"^"_ItemPrice_"^"_ItemSum_"^"_uomDesc_"^"_Status
	kill ^TMPGetOrderFeeDetail($i)
	quit ItemDetail
	
	;^DHCPEPreIADM({DHC_PE_PreIADM.PIADM_RowId},"ORDITEM",{DHC_PE_PreIOrdItem.PIOI_ChildSub},"FEE",{PIOIF_ChildSub})
	;^DHCPEPreIADM({DHC_PE_PreIADM.PIADM_RowId},"ORDENT",{DHC_PE_PreIOrdEnt.PIOE_ChildSub},"FEE",{PIOEF_ChildSub})

		
getOETarInfoErr
	q ""
}

}
