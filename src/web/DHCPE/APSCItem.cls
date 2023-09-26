Class web.DHCPE.APSCItem Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

// w ##class(web.DHCPE.APSCItem).InsertItem("ITEM","3126||1","I","31","")

ClassMethod InsertItem(ItemType, ItemID, Type, APRowID, SCRowID)
{
	i SCRowID'=""
	{
		s APID=+SCRowID
		s OSub=$P(SCRowID,"||",2)
		s Sub=$O(^DHCPEAP(APID,"SC",""),-1)
		i Sub'=OSub q "不是最新的卡记录"
	}
	else
	{
		s APID=APRowID
		s Sub=$O(^DHCPEAP(APID,"SC",""),-1)
	}
	s CardType=$P(^DHCPEAP(APID),"^",3)
	q:CardType="R" "预缴金不需要记录项目"
	s Status=$P(^DHCPEAP(APID),"^",5)
	q:Status'="N" "卡状态不是正常状态,不能添加项目"
	s HadFlag=0
	i ItemType="ITEM"
	{
		s ISub=0
		
		f  s ISub=$O(^DHCPEAP(0,"ARCID",ItemID,APID,Sub,"")) q:ISub=""  d
		.s Status=$p(^DHCPEAP(APID,"SC",Sub,"Item",ISub),"^",1)
		.s:Status="N" HadFlag=1
	}
	else
	{
		s ISub=0
		f  s ISub=$O(^DHCPEAP(0,"OrdSets",ItemID,APID,Sub,ISub)) q:ISub=""  d
		.s Status=$p(^DHCPEAP(APID,"SC",Sub,"OrdSets",ISub),"^",1)
		.s:Status="N" HadFlag=1
	
	}
	q:HadFlag=1 "Had"
	s SCID=APID_"||"_Sub
	s SQLCODE=0
	s UserID=%session.Get("LOGON.USERID")
	s Date=+$H
	s Time=$P($H,",",2)
	TSTART
	i ItemType="ITEM" d
	.d InsertItem(ItemID,SCID,"")
	e  d
	.d InsertOrdSets(ItemID,SCID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "插入错误,错误号:"_SQLCODE
	}
	TCOMMIT
	q 0
InsertItem(ARCItemID,SCID,SCOrdSetsID)
	k PLIST
	s PLIST(0)=SCID
	s PLIST(3)="N"
	i SCOrdSetsID'="" s PLIST(4)=SCOrdSetsID
	s PLIST(5)=ARCItemID
	s PLIST(6)=Date
	s PLIST(7)=Time
	s PLIST(8)=UserID
	s PLIST(13)=##class(web.DHCPE.PreItemList).GetOrderPrice(ARCItemID)
	&SQL(Insert Into sqluser.DHC_PE_APSCItem values :PLIST())
	q
InsertOrdSets(ARCOrdSetID,SCID)
	k PLIST
	s PLIST(0)=SCID
	s PLIST(3)="N"
	s PLIST(4)=ARCOrdSetID
	s PLIST(5)=Date
	s PLIST(6)=Time
	s PLIST(7)=UserID
	s PLIST(12)=##class(web.DHCPE.Handle.ARCOrdSets).GetPrice(ARCOrdSetID)
	&SQL(Insert Into sqluser.DHC_PE_APSCOrdSets values :PLIST())
	q:SQLCODE
	s SCOrdSetsID=%ROWID
	d InsertItemByOrdSets(ARCOrdSetID,SCID,SCOrdSetsID)

InsertItemByOrdSets(arcsetid,SCID,SCOrdSetsID)
	s arcitemid=""
	s arcdata=$g(^ARCOS(arcsetid))
	i arcdata="" q 0
	s datefrom=$p(arcdata,"^",15)
	if datefrom'=""
	{
		s datefrom=+datefrom
		if (+datefrom>+$h) q
	}
	s dateto=$p(arcdata,"^",16)
	i ((dateto'="")&&(dateto<+$h)) q
	s arcsetdateid=""
	f  s arcsetdateid=$o(^ARCOS(arcsetid,"DATE",arcsetdateid)) q:((arcsetdateid="")||(SQLCODE'=0))  d
	.s arcdata=$g(^ARCOS(arcsetid,"DATE",arcsetdateid))
	.q:arcdata=""
	.s datefrom=$p(arcdata,"^",1)
	.q:datefrom>+$h
	.s dateto=$p(arcdata,"^",2)
	.q:((dateto'="")&&(dateto<+$h))
	.s arcsetdateitemid=0
	.///取项目
	.f  s arcsetdateitemid=$o(^ARCOS(arcsetid,"DATE",arcsetdateid,"ITM",arcsetdateitemid)) q:((arcsetdateitemid="")||(SQLCODE'=0))  d
	..s arcdata=$g(^ARCOS(arcsetid,"DATE",arcsetdateid,"ITM",arcsetdateitemid))
	..s arcitemid=$p(arcdata,"^",1)
	..q:arcitemid=""
	..d InsertItem(arcitemid,SCID,SCOrdSetsID)
	.///取套餐
	.s arcsetdateitemid=0
	.f  s arcsetdateitemid=$o(^ARCOS(arcsetid,"DATE",arcsetdateid,"OS",arcsetdateitemid)) q:((arcsetdateitemid="")||(SQLCODE'=0))  d
	..s arcdata=$g(^ARCOS(arcsetid,"DATE",arcsetdateid,"OS",arcsetdateitemid))
	..s arcitemid=$p(arcdata,"^",1)
	..q:arcitemid=""
	..d InsertItemByOrdSets(arcitemid,SCID,SCOrdSetsID)
	q
}

// ..DeleteItem("Item",ItemID,"O")

ClassMethod DeleteItem(ItemType, ItemID, Status)
{
	s ret=0
	s APID=$p(ItemID,"||",1)
	s SCSub=$p(ItemID,"||",2)
	s Sub=$p(ItemID,"||",3)
	s UserID=%session.Get("LOGON.USERID")
	s Date=+$H
	s Time=$P($H,",",2)
	s SQLCODE=0
	TSTART
	i ItemType="Item"
	{
		s OStatus=$p(^DHCPEAP(APID,"SC",SCSub,"Item",Sub),"^",1)
		q:OStatus="D" "HadDel" //"项目已经删除,不需要再删除"
		q:OStatus="O" "HadUse" //"项目已经使用,不能再删除"
		s SCOrdSetsID=$p(^DHCPEAP(APID,"SC",SCSub,"Item",Sub),"^",2)
		s Amount=+$p(^DHCPEAP(APID,"SC",SCSub,"Item",Sub),"^",11)
		&SQL(Update sqluser.DHC_PE_APSCItem Set APSCI_Status=:Status,APSCI_UpdateUser_DR=:UserID,APSCI_UpdateDate=:Date,APSCI_UpdateTime=:Time where APSCI_RowID=:ItemID)
		//修改套餐金额
		if SQLCODE=0
		{
			i (+SCOrdSetsID'=0)
			{
				s User=""
				s UDate=""
				s UTime=""
				s items=##class(web.DHCPE.APSCItem).GetItemsBySCOrdSets(SCOrdSetsID)
				s OStatus="N"
				S:items="" OStatus="D"
				
				&SQL(Update sqluser.DHC_PE_APSCOrdSets Set APSCO_1=APSCO_1-:Amount,APSCO_Status=:OStatus where APSCO_RowID=:SCOrdSetsID)
			}
		}
	}
	else
	{
		s OStatus=$p(^DHCPEAP(APID,"SC",SCSub,"OrdSets",Sub),"^",1)
		q:OStatus="D" "HadDel" //"套餐已经删除,不需要再删除"
		q:OStatus="O" "HadUse" //"套餐已经使用,不能再删除"
		&SQL(Update sqluser.DHC_PE_APSCOrdSets Set APSCO_Status=:Status,APSCO_UpdateUser_DR=:UserID,APSCO_UpdateDate=:Date,APSCO_UpdateTime=:Time where APSCO_RowID=:ItemID)
		i SQLCODE=0
		{
			&SQL(Update sqluser.DHC_PE_APSCItem Set APSCI_Status=:Status,APSCI_UpdateUser_DR=:UserID,APSCI_UpdateDate=:Date,APSCI_UpdateTime=:Time where APSCI_OrdEnt_DR=:ItemID and APSCI_Status='N')
			S:SQLCODE=100 SQLCODE=0
		}
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE  //"删除项目错误,错误号:"_SQLCODE
}

Query SearchAPSCItem(APRowID As %String = "", SCRowID As %String = "", SCOrdSetsID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TItemDesc:%String,TOrdSetsDesc:%String,TAddUser:%String,TAddDate:%String,TUpdateUser:%String,TUpdateDate:%String,TStatus:%String,TAmount:%String,TItemType:%String")
{
}

ClassMethod SearchAPSCItemExecute(ByRef qHandle As %Binary, APRowID As %String = "", SCRowID As %String = "", SCOrdSetsID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=2
 	i SCRowID'=""
	{
		s APID=+SCRowID
		s Sub=$P(SCRowID,"||",2)
	}
	elseif APRowID'=""
	{
		s APID=APRowID
		
		i '$d(^DHCPEAP(APID,"SC")){
			Set qHandle=$lb(0,repid,0)
	        Quit $$$OK
		}

		s Sub=$O(^DHCPEAP(APID,"SC",""),-1)
	}
	else
	{
		s APID=+SCOrdSetsID
		s Sub=$p(SCOrdSetsID,"||",2)
	}
	s TotalAmount=0
	s ItemSub=0
	f  s ItemSub=$o(^DHCPEAP(APID,"SC",Sub,"Item",ItemSub)) q:ItemSub=""  d
	.d GetOneItemInfoDetail
	s ItemSub=0
	f  s ItemSub=$o(^DHCPEAP(APID,"SC",Sub,"OrdSets",ItemSub)) q:ItemSub=""  d
	.q:SCOrdSetsID'=""
	.d GetOneOrdSetsInfoDetail
	
	//输出合计
	s ind=1
	d ClearVari
	s TAmount=TotalAmount
	s TItemDesc="合计金额"
	d FindBuildDetail
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneItemInfoDetail
	d ClearVari
 	s TRowID=APID_"||"_Sub_"||"_ItemSub
	s OrdSet=$p(^DHCPEAP(APID,"SC",Sub,"Item",ItemSub),"^",2)
	q:(OrdSet'="")&&(SCOrdSetsID'=OrdSet)
	q:(OrdSet="")&&(SCOrdSetsID'="")
	s ARCID=$p(^DHCPEAP(APID,"SC",Sub,"Item",ItemSub),"^",3)
	s TItemDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ARCID)
	s TAmount=$p(^DHCPEAP(APID,"SC",Sub,"Item",ItemSub),"^",11)
	s TStatus=$p(^DHCPEAP(APID,"SC",Sub,"Item",ItemSub),"^",1)
	
	s:TStatus="N" TStatus="新增"
	i TStatus="D" d
	.s TStatus="删除"
	.s TAmount=0
	s:TStatus="O" TStatus="已用"
	s TotalAmount=TotalAmount+TAmount
	s TAddUser=$p(^DHCPEAP(APID,"SC",Sub,"Item",ItemSub),"^",6)
	i TAddUser'="" s TAddUser=$P(^SSU("SSUSR",TAddUser),"^",2)
	s TAddDate=$p(^DHCPEAP(APID,"SC",Sub,"Item",ItemSub),"^",4)
	i TAddDate'="" s TAddDate=##class(websys.Conversions).DateLogicalToHtml(TAddDate)
	s TUpdateUser=$p(^DHCPEAP(APID,"SC",Sub,"Item",ItemSub),"^",9)
	i TUpdateUser'="" s TUpdateUser=$P($G(^SSU("SSUSR",TUpdateUser)),"^",2)
	s TUpdateDate=$p(^DHCPEAP(APID,"SC",Sub,"Item",ItemSub),"^",7)
	i TUpdateDate'="" s TUpdateDate=##class(websys.Conversions).DateLogicalToHtml(TUpdateDate)
	s TItemType="Item"
	d FindBuildDetail
	q
GetOneOrdSetsInfoDetail
	d ClearVari
	s TRowID=APID_"||"_Sub_"||"_ItemSub
	s (TRowID,TItemDesc,TOrdSetsDesc,TAddUser,TAddDate,TUpdateUser,TUpdateDate,TStatus,TAmount)=""
 	s TRowID=APID_"||"_Sub_"||"_ItemSub
	s OrdSet=$p(^DHCPEAP(APID,"SC",Sub,"OrdSets",ItemSub),"^",2)
	s TOrdSetsDesc=$p($g(^ARCOS(OrdSet)),"^",2)
	s TAmount=$p(^DHCPEAP(APID,"SC",Sub,"OrdSets",ItemSub),"^",10)
	s TStatus=$p(^DHCPEAP(APID,"SC",Sub,"OrdSets",ItemSub),"^",1)
	s:TStatus="N" TStatus="新增"
	i TStatus="D" d
	.s TStatus="删除"
	.s TAmount=0
	s:TStatus="O" TStatus="已用"
	s TotalAmount=TotalAmount+TAmount
	s TAddUser=$p(^DHCPEAP(APID,"SC",Sub,"OrdSets",ItemSub),"^",5)
	i TAddUser'="" s TAddUser=$P(^SSU("SSUSR",TAddUser),"^",2)
	s TAddDate=$p(^DHCPEAP(APID,"SC",Sub,"OrdSets",ItemSub),"^",3)
	i TAddDate'="" s TAddDate=##class(websys.Conversions).DateLogicalToHtml(TAddDate)
	s TUpdateUser=$p(^DHCPEAP(APID,"SC",Sub,"OrdSets",ItemSub),"^",8)
	i TUpdateUser'="" s TUpdateUser=$P(^SSU("SSUSR",TUpdateUser),"^",2)
	s TUpdateDate=$p(^DHCPEAP(APID,"SC",Sub,"OrdSets",ItemSub),"^",6)
	i TUpdateDate'="" s TUpdateDate=##class(websys.Conversions).DateLogicalToHtml(TUpdateDate)
	s TItemType="OrdSets"
	d FindBuildDetail
	q
ClearVari
	s (TRowID,TItemDesc,TOrdSetsDesc,TAddUser,TAddDate,TUpdateUser,TUpdateDate,TStatus,TAmount,TItemType)=""
	s TAmount=0
	q
FindBuildDetail      
	set Data=$lb(TRowID,TItemDesc,TOrdSetsDesc,TAddUser,TAddDate,TUpdateUser,TUpdateDate,TStatus,TAmount,TItemType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchAPSCItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchAPSCItemExecute ]
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

ClassMethod SearchAPSCItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchAPSCItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod InsertPreItem(PIADM, ADMType, CardType)
{
	
	if ADMType="PERSON" d
	.s IBaseInfo=$P(^DHCPEPreIADM(PIADM),"^",1)
	.s RegNo=$P(^DHCPEPreIBI(IBaseInfo),"^",1)
	e  d
	.s GBaseInfo=$P(^DHCPEPreGADM(+PIADM),"^",1)
	.s RegNo=$P(^DHCPEPreGBI(GBaseInfo),"^",13)
	s APID=##class(web.DHCPE.AdvancePayment).GetRowIDByRegNo(RegNo,CardType)
	q:APID="" "对应类型的卡不存在"
	s Status=$P(^DHCPEAP(APID),"^",5)
	q:Status'="N" "卡状态不是正常状态,不能添加项目"
	s CSub=$O(^DHCPEAP(APID,"SC",""),-1)
	s UserID=%session.Get("LOGON.USERID")
	s ret=0
	s ISub=0
	f  s ISub=$O(^DHCPEAP(APID,"SC",CSub,"Item",ISub)) q:(ISub="")||(ret'=0)  d
	.s Status=$P(^DHCPEAP(APID,"SC",CSub,"Item",ISub),"^",1)
	.q:Status'="N"
	.s SCSetID=$P(^DHCPEAP(APID,"SC",CSub,"Item",ISub),"^",2)
	.q:SCSetID'=""
	.s ARCIMID=$P(^DHCPEAP(APID,"SC",CSub,"Item",ISub),"^",3)
	.s ret=##class(web.DHCPE.PreItemList).IInsertItem(PIADM, ADMType, "PRE", ARCIMID, "",UserID)
	.i ret="" s ret=0
	.q:ret'=0
	.s aa=..DeleteItem("Item",APID_"||"_CSub_"||"_ISub,"O")
	q:ret'=0 ret
	s ISub=0
	f  s ISub=$O(^DHCPEAP(APID,"SC",CSub,"OrdSets",ISub)) q:(ISub="")||(ret'=0)  d
	.s Status=$P(^DHCPEAP(APID,"SC",CSub,"OrdSets",ISub),"^",1)
	.q:Status'="N"
	.s ARCIMID=$P(^DHCPEAP(APID,"SC",CSub,"OrdSets",ISub),"^",2)
	.s ret=##class(web.DHCPE.PreItemList).IInsertItem(PIADM, ADMType, "PRE", "",ARCIMID_"^"_APID_"||"_CSub_"||"_ISub, UserID)
	.i ret="" s ret=0
	.q:ret'=0
	.s aa=..DeleteItem("OrdSets",APID_"||"_CSub_"||"_ISub,"O")
	q ret
}

// w ##class(web.DHCPE.APSCItem).GetItemsBySCOrdSets("36||1||1")

ClassMethod GetItemsBySCOrdSets(SCOrdSetsID)
{
	s itemIds=""
	s SISub=0
	f  s SISub=$O(^DHCPEAP(+SCOrdSetsID,"SC",$P(SCOrdSetsID,"||",2),"Item",SISub)) q:SISub=""  d
	.s OldOrdSetsID=$P(^DHCPEAP(+SCOrdSetsID,"SC",$P(SCOrdSetsID,"||",2),"Item",SISub),"^",2)
	.q:OldOrdSetsID'=SCOrdSetsID
	.q:$P(^DHCPEAP(+SCOrdSetsID,"SC",$P(SCOrdSetsID,"||",2),"Item",SISub),"^",1)'="N"
	.i itemIds="" d
	..s itemIds=$P(^DHCPEAP(+SCOrdSetsID,"SC",$P(SCOrdSetsID,"||",2),"Item",SISub),"^",3)
	.e  d
	..s itemIds=itemIds_"^"_$P(^DHCPEAP(+SCOrdSetsID,"SC",$P(SCOrdSetsID,"||",2),"Item",SISub),"^",3)
	q itemIds
}

}
