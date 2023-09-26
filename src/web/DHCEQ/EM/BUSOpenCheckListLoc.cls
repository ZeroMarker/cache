/// creator  by ZY0252 20210301
Class web.DHCEQ.EM.BUSOpenCheckListLoc Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by ZY0278 20210826
/// add by ZY252 2021-01-18
/// 描述：验收明细对应的科室申购明细
/// 入参：ContractListID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSOpenCheckListLoc","GetOpenCheckListLoc",2)
Query GetOpenCheckListLoc(OpenCheckListID As %Library.String = "", SourceType As %Library.String = "", SourceID As %Library.String = "") As %Query(ROWSPEC = "OCLLRowID:%String,OCLLOpenCheckListDR:%String,OCLLContractListLocDR:%String,OCLLBuyLocDR:%String,OCLLBuyLoc_CTLOCDesc:%String,OCLLQuantity:%String,OCLLLeaveFactoryNo:%String,OCLLFileNo:%String,OCLLRemark:%String,OCLLHold1:%String,OCLLHold2:%String,OCLLHold3:%String,OCLLHold4:%String,OCLLHold5:%String")
{
}

ClassMethod GetOpenCheckListLocExecute(ByRef qHandle As %Binary, OpenCheckListID As %Library.String = "", SourceType As %Library.String = "", SourceID As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	if '$Data(^DHCEQOpenCheckListLoc(0,"OpenCheckList",OpenCheckListID))
	{
		d OutputRowGetOpenCheckListLoc
	}
	else
	{
		/// modified by ZY0278 20210826
	 	s OCLSourceType=$p($g(^DHCEQOpenCheckList(OpenCheckListID)),"^",63)
	 	s OCLSourceID=$p($g(^DHCEQOpenCheckList(OpenCheckListID)),"^",64)
		if ((OCLSourceType=1)&&(OCLSourceType=SourceType)&&(OCLSourceID'=SourceID))
		{
			s rowid=0
			f  s rowid=$o(^DHCEQContractListLoc(0,"ContractList",SourceID,rowid)) quit:rowid=""  d
			.d ResetVariablesGetOpenCheckListLoc
			.s DataList=$g(^DHCEQContractListLoc(rowid))
			.s OCLLRowID=""
			.s OCLLOpenCheckListDR=OpenCheckListID
			.s OCLLContractListLocDR=$p(DataList,"^",1)
			.s OCLLBuyLocDR=$p(DataList,"^",4)
			.s OCLLBuyLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",OCLLBuyLocDR)
			.s OCLLQuantity=$p(DataList,"^",5)-$p(DataList,"^",6)
			.q:OCLLQuantity<=0
			.s OCLLLeaveFactoryNo=""
			.s OCLLFileNo=""
			.s OCLLRemark=$p(DataList,"^",7)
			.s OCLLHold1=$p(DataList,"^",8)
			.s OCLLHold2=$p(DataList,"^",9)
			.s OCLLHold3=$p(DataList,"^",10)
			.s OCLLHold4=$p(DataList,"^",11)
			.s OCLLHold5=$p(DataList,"^",12)
			.d OutputRowGetOpenCheckListLoc
		}
		else
		{
			s rowid=0
			f  s rowid=$o(^DHCEQOpenCheckListLoc(0,"OpenCheckList",OpenCheckListID,rowid)) quit:rowid=""  d
			.d ResetVariablesGetOpenCheckListLoc
			.s DataList=$g(^DHCEQOpenCheckListLoc(rowid))
			.s OCLLRowID=rowid
			.s OCLLOpenCheckListDR=$p(DataList,"^",1)
			.s OCLLContractListLocDR=$p(DataList,"^",2)
			.s OCLLBuyLocDR=$p(DataList,"^",3)
			.s OCLLBuyLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",OCLLBuyLocDR)
			.s OCLLQuantity=$p(DataList,"^",4)
			.s OCLLLeaveFactoryNo=$p(DataList,"^",5)
			.s OCLLFileNo=$p(DataList,"^",6)
			.s OCLLRemark=$p(DataList,"^",7)
			.s OCLLHold1=$p(DataList,"^",8)
			.s OCLLHold2=$p(DataList,"^",9)
			.s OCLLHold3=$p(DataList,"^",10)
			.s OCLLHold4=$p(DataList,"^",11)
			.s OCLLHold5=$p(DataList,"^",12)
			.d OutputRowGetOpenCheckListLoc
		}
	}
	Quit $$$OK
OutputRowGetOpenCheckListLoc
	s Data=$lb(OCLLRowID,OCLLOpenCheckListDR,OCLLContractListLocDR,OCLLBuyLocDR,OCLLBuyLoc,OCLLQuantity,OCLLLeaveFactoryNo,OCLLFileNo,OCLLRemark,OCLLHold1,OCLLHold2,OCLLHold3,OCLLHold4,OCLLHold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOpenCheckListLoc
	s (DataList,OCLLRowID,OCLLOpenCheckListDR,OCLLContractListLocDR,OCLLBuyLocDR,OCLLBuyLoc,OCLLQuantity,OCLLLeaveFactoryNo,OCLLFileNo,OCLLRemark,OCLLHold1,OCLLHold2,OCLLHold3,OCLLHold4,OCLLHold5)=""
	quit
}

ClassMethod GetOpenCheckListLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpenCheckListLocExecute ]
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

ClassMethod GetOpenCheckListLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpenCheckListLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.BUSOpenCheckListLoc).SaveData("{\"CLLRowID\":\"\",\"CLLContractListDR\":\"28\",\"CLLBuyPlanListLocDR\":\"\",\"CLLBuyRequestListDR\":\"\",\"CLLBuyLocDR\":\"3\",\"CLLBuyLoc_CTLOCDesc\":\"X线室\",\"CLLQuantity\":\"3\",\"CLLArrivedQuantity\":\"\",\"CLLRemark\":\"\",\"CLLHold1\":\"\",\"CLLHold2\":\"\",\"CLLHold3\":\"\",\"CLLHold4\":\"\",\"CLLHold5\":\"\"}",0)
ClassMethod SaveData(dataList, DelIs)
{
	s $ZT="ERRORSave"
	k PLIST,RowID
	s OCLRowID=""
	TSTART
	if DelIs=1
	{
		s RowID=dataList
		s OCLRowID=$p($g(^DHCEQOpenCheckListLoc(RowID)),"^",1)	///modified by ZY0261 20210511
		&SQL(delete from SQLUSER.DHC_EQOpenCheckListLoc where OCLL_RowID = :RowID)
		s RowID=""
	}
	else
	{
		s SQLCODE=0
		Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")  //add by zx 2019-07-24 分隔符号处理
		s Length=$L(dataList,SplitRowCode)
		for i=1:1:Length
		{
			q:SQLCODE'=0
			s valList=	$p(dataList,SplitRowCode,i)  //add by zx 2019-07-24 分隔符号处理
			q:valList=""
			k PLIST,OCLLRowID
			s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
			s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQOpenCheckListLoc",JsonData,.PLIST)
			s OCLLRowID = JsonData.OCLLRowID
		    if OCLLRowID'=""
		    {
				&SQL(Update SQLUSER.DHC_EQOpenCheckListLoc Values :PLIST() where OCLL_RowID = :OCLLRowID)
			}
			else
			{
				&SQL(insert into SQLUSER.DHC_EQOpenCheckListLoc Values :PLIST())
				s OCLLRowID=$g(%ROWID)
			}
			s OCLRowID=$p($g(^DHCEQOpenCheckListLoc(OCLLRowID)),"^",1)
		}
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s SQLCODE=##Class(web.DHCEQ.EM.BUSOpenCheckListLoc).SetLeaveFactoryNoAndFileNo(OCLRowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	
ERRORSave
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// add by ZY0260 20210428
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckListLoc).SetLeaveFactoryNoAndFileNo(48)
ClassMethod SetLeaveFactoryNoAndFileNo(OCLRowID)
{
	new Locrowid,OCLLQuantity,LeaveFactoryNo,FileNo,LeaveFactoryNos,FileNos,MXNum
	s (LeaveFactoryNos,FileNos)=""
	s OCLQuantity=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
	
	s (Locrowid,MXNum)=0
	f  s Locrowid=$o(^DHCEQOpenCheckListLoc(0,"OpenCheckList",OCLRowID,Locrowid)) quit:(Locrowid="")  d
	.s (OCLLQuantity,LeaveFactoryNo,FileNo)=""
	.s OCLLQuantity=+$p($g(^DHCEQOpenCheckListLoc(Locrowid)),"^",4)
	.s LeaveFactoryNo=$p($g(^DHCEQOpenCheckListLoc(Locrowid)),"^",5)
	.s LeaveFactoryNo=##class(web.DHCEQCommon).Replace(LeaveFactoryNo,$C(13,10),"")
	.s LeaveFactoryNo=##class(web.DHCEQCommon).Replace(LeaveFactoryNo,$C(65292),",")
	.s FileNo=$p($g(^DHCEQOpenCheckListLoc(Locrowid)),"^",6)
	.s FileNo=##class(web.DHCEQCommon).Replace(FileNo,$C(13,10),"")
	.s FileNo=##class(web.DHCEQCommon).Replace(FileNo,$C(65292),",")
	.f i=1:1:OCLLQuantity  d
	..s MXNum=MXNum+1
	..i LeaveFactoryNos="" d		//czf 2022-02-28 begin
	...s LeaveFactoryNos=$p(LeaveFactoryNo,",",i)
	..e  d
	...s LeaveFactoryNos=LeaveFactoryNos_","_$p(LeaveFactoryNo,",",i)
	..i FileNos="" d
	...s FileNos=$p(FileNo,",",i)
	..e  d
	...s FileNos=FileNos_","_$p(FileNo,",",i)		//czf 2022-02-28 end
	
	if MXNum<OCLQuantity
	{
		
	}
	i +##class(web.DHCEQCommon).GetSysInfo("201015")=1  //Modified By QW20210610 BUG:QW0111
	{
		//if LeaveFactoryNos="" s LeaveFactoryNos=$g(^DHCEQOpenCheckList(OCLRowID,"EX"))  //add by wy 2021-9-2 WY0096
		s ^DHCEQOpenCheckList(OCLRowID,"EX")=LeaveFactoryNos
		s ^DHCEQOpenCheckList(OCLRowID,"FileNo")=FileNos	///modified by ZY0261 20210511
	}
	q 0
}

/// add by ZY0261 20210511
ClassMethod GetLeaveFactoryNoAndFileNo(OCLRowID)
{
	q $g(^DHCEQOpenCheckList(OCLRowID,"EX"))_"^"_$g(^DHCEQOpenCheckList(OCLRowID,"FileNo"))
}

/// w ##Class(web.DHCEQ.EM.BUSOpenCheckListLoc).CheckOpenCheckListLoc(2)
ClassMethod CheckOpenCheckListLoc(OCRRowID, OpenCheckListID As %Library.String = "")
{
	i OCRRowID="" q ""
	s result=""
	s rowid=0
	f  s rowid=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,rowid)) quit:(rowid="")||(result'="")  d
	.q:(OpenCheckListID'="")&&(OpenCheckListID'=rowid)
	.s TotalQuantityNum = $p($g(^DHCEQOpenCheckList(rowid)),"^",16)
	.s EquipName=$p($g(^DHCEQOpenCheckList(rowid)),"^",2)
	.s tmpQuantity=0
	.s Locrowid=0
	.f  s Locrowid=$o(^DHCEQOpenCheckListLoc(0,"OpenCheckList",rowid,Locrowid)) quit:(Locrowid="")||(result'="")  d
	..s CLLQuantity=$p($g(^DHCEQOpenCheckListLoc(Locrowid)),"^",4)
	..s tmpQuantity=tmpQuantity+CLLQuantity
	.i (TotalQuantityNum'=tmpQuantity) s result=EquipName_"科室明细的总数量和验收单数量不一致"
	q result
}

/// modified by ZY0303 20220616 2712598、2709358
/// Creator：      ZY
/// CreatDate：    2021-02-01
/// Description:   验收保存时存验收明细子表数据
/// Input：        OCLRowID:验收明细ID
/// Return：       SQLCODE
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckListLoc).SaveOpenCheckListLoc(139,"")
ClassMethod SaveOpenCheckListLoc(OCLRowID, sysflag As %Library.String = "")
{
	new UseLocID,OCLLRowID,SQLCODE,OCLLNum,SourceType,SourceID
	s (OCLLRowID,OCLLNum,SQLCODE)=0
	k OCLLPIST
	s UseLocID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",33)  //使用科室
	s SourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
	s SourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
	s LocListFlag=+##class(web.DHCEQCommon).GetSysInfo("201015")
	if (LocListFlag=0)
	{
		&SQL(delete from SQLUSER.DHC_EQOpenCheckListLoc  where OCLL_OpenCheckListDR=:OCLRowID)
		if SQLCODE=100 s SQLCODE=0
	}
	else
	{
		///0:设备项;1:采购合同 2、3采购计划 4:协议合同 5:投放合同
		if (SourceType=0)||(SourceType=2)||(SourceType=3)
		{
			i UseLocID="" q 0
			
			f  s OCLLRowID=$o(^DHCEQOpenCheckListLoc(0,"OpenCheckList",OCLRowID,OCLLRowID)) quit:OCLLRowID=""  d
			.s OCLLNum=OCLLNum+1
			
			s OCLLPIST(4)=UseLocID
			s OCLLPIST(5)=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
			s OCLLPIST(6)=$g(^DHCEQOpenCheckList(OCLRowID,"EX"))
			s OCLLPIST(7)=$g(^DHCEQOpenCheckList(OCLRowID,"FileNo"))
			if OCLLNum=0
			{
				s OCLLPIST(2)=OCLRowID
				&SQL(insert into SQLUSER.DHC_EQOpenCheckListLoc Values :OCLLPIST())
			}
			elseif OCLLNum=1
			{
				&SQL(Update SQLUSER.DHC_EQOpenCheckListLoc Values :OCLLPIST() where OCLL_OpenCheckListDR=:OCLRowID)
			}
		}
		else
		{
			i (UseLocID="")&&('$Data(^DHCEQContractListLoc(0,"ContractList",SourceID))) q 0
			if sysflag=0
			{
				f  s OCLLRowID=$o(^DHCEQContractListLoc(0,"ContractList",SourceID,OCLLRowID)) quit:(OCLLRowID="")||(SQLCODE'=0)  d
				.s OCLLPIST(2)=OCLRowID
				.s OCLLPIST(4)=$p($g(^DHCEQContractListLoc(OCLLRowID)),"^",4)
				.s OCLLPIST(5)=$p($g(^DHCEQContractListLoc(OCLLRowID)),"^",5)
				.s OCLLPIST(6)=$p($g(^DHCEQContractListLoc(OCLLRowID)),"^",8)  //add by wy 2021-9-2 WY0096
				.;s OCLLPIST(7)=""
				.&SQL(insert into SQLUSER.DHC_EQOpenCheckListLoc Values :OCLLPIST())
			}else
			{
				i UseLocID="" q 0
				
				s OCLLPIST(4)=UseLocID
				s OCLLPIST(5)=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
				s OCLLPIST(6)=$g(^DHCEQOpenCheckList(OCLRowID,"EX"))
				s OCLLPIST(7)=$g(^DHCEQOpenCheckList(OCLRowID,"FileNo"))
				
				s OCLLRowID=""
				&SQL(select OCLL_RowID into :OCLLRowID from SQLUSER.DHC_EQOpenCheckListLoc where OCLL_OpenCheckListDR=:OCLRowID)
				if OCLLRowID=""
				{
					s OCLLPIST(2)=OCLRowID
					&SQL(insert into SQLUSER.DHC_EQOpenCheckListLoc Values :OCLLPIST())
				}
				else
				{
					&SQL(Update SQLUSER.DHC_EQOpenCheckListLoc Values :OCLLPIST() where OCLL_RowID=:OCLLRowID)
				}
			}
		}
	}
	q SQLCODE
}

}
