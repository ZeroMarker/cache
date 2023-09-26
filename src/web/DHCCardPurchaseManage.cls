Class web.DHCCardPurchaseManage Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*	
需嵌入到业务中
///发卡
##class(web.DHCBL.CARD.UCardPatRegBuilder).SavePCAInfoToServer()

///换卡
w ##class(web.DHCBL.CARD.UCardStatusChangeBuilder).CardExechange(

///补卡
w ##class(web.DHCBL.CARD.UCardStatusChangeBuilder).CardReissue
///退卡
w ##class(web.DHCBL.CARD.UCardRefBulider).CancelCardInfo

*/
/// / d ##Class(web.DHCCardPurchaseManage).UpdateCardPurchaseAllot(50278)
ClassMethod UpdateCardPurchaseAllot(NewCardID As %String) As %String
{
	N (NewCardID)
	s $ZT="UpdateCardPurchaseAllotErr"
	q:NewCardID="" 0
	s CardType=$P(^DHCCARD("CF",NewCardID),"^",16)
	s DefCardType=##Class(web.DHCCardPurchaseManage).GetDefCardTypeID()
	q:CardType'=DefCardType 0
	s ReclaimFlag=$P(^DHCCARDTYPEDef(CardType),"^",7)
	s CardNo=$P(^DHCCARD("CF",NewCardID),"^",2)
	s ActiveFlag=$P(^DHCCARD("CF",NewCardID),"^",10)
	if (ActiveFlag="R"){
		if (ReclaimFlag="N") q 0
		//退卡需要给号池+1
		s CardUser=$P(^DHCCARD("CF",NewCardID),"^",15)
		s ChangeNum=1
	}else{
		s ChangeNum=-1
		s CardUser=$P(^DHCCARD("CF",NewCardID),"^",9)	
	}
	/*
	s FindHistCard=0
	s HistCardID=0
	for {
		s HistCardID=$O(^DHCCARDi("CF",0,"CardTypeNo",CardType,CardNo,HistCardID))
		q:HistCardID=""
		continue:HistCardID=NewCardID
		s HisActiveFlag=$P(^DHCCARD("CF",HistCardID),"^",10)
		s FindHistCard=1
	}
	q:FindHistCard=1 ""
	*/
	s AllotID=""
	s RowID=""
	for {
		s RowID=$O(^DHCCARDManage("PurchaseAllot",0,"User",CardUser,RowID),-1)
		q:+RowID=0
		s Val=$G(^DHCCARDManage("PurchaseAllot",RowID))
		continue:Val=""
		s Active=$P(Val,"^",11)
		if (Active'="Y")&&(ActiveFlag'="R"){
			continue
		}
		s CPMBuyer=$P(Val,"^",3)
		if (CardUser'=CPMBuyer){
			continue
		}
		s Amount=$P(Val,"^",4)
		s StartNum=$P(Val,"^",5)
		s EndNum=$P(Val,"^",6)
		s LeftNum=$P(Val,"^",7)
		if ((StartNum<=CardNo)&&(EndNum>=CardNo)){
			s AllotID=RowID
			q	
		}
		
	}
	q:AllotID="" 0
	s Val=$G(^DHCCARDManage("PurchaseAllot",AllotID))
	s LeftNum=$P(Val,"^",7)
	s NewLeftNum=LeftNum+ChangeNum
	s Active="Y"
	if (NewLeftNum<=0){
		s Active="N"
	}
	&SQL(Update SQLUser.DHC_CardPurchaseAllot Set CPA_Left=:NewLeftNum , CPA_Avail=:Active where CPA_RowID=:AllotID)
	if (SQLCODE){
		q 0
	}
	q:Active="Y" 0
	///判断是否整个购入的记录都已用完
	s RepeatID=$P(Val,"^",13)
	s MainAmount=$P($G(^DHCCARDManage("Purchase",RepeatID)),"^",4)
	s MainNote=$P($G(^DHCCARDManage("Purchase",RepeatID)),"^",7)
	s Count=0
	s ID=0
	for{
		s ID=$O(^DHCCARDManage("PurchaseAllot",0,"PreManageDr",RepeatID,ID))
		q:ID=""
		s Val=$G(^DHCCARDManage("PurchaseAllot",ID))
		s Active=$P(Val,"^",11)
		if (Active="Y"){
			q
		}
		s Amount=$P(Val,"^",4)
		s Count=Count+Amount
		
	}
	//存在有效的分配记录卡段，说明该批次购入肯定没有用完
	if (Active="Y"){
		q 0
	}
	//已用完
	if (Count>=MainAmount){
		s Note=MainNote_"||"_..%ZD(+$h)_" "_..%ZT(..%SysTime())_"系统自动判断已用完"
		&SQL(Update SQLUser.DHC_CardPurchaseManage set CPM_Avail='N' ,CPM_Note=:Note where CPM_RowID=:RepeatID)
	}
	q 0
UpdateCardPurchaseAllotErr
	s ^tan("UpdateCardPurchaseAllot",$H)=NewCardID_","_$ZE
	q $ZE
}

ClassMethod GetDefCardTypeID() As %String
{
	&SQL(SELECT CTD_RowID into :ID FROM SQLUser.DHC_CardTypeDef WHERE CTD_Code='02')
	q ID
}

/// /w ##Class(web.DHCCardPurchaseManage).SaveCardPurchaseInfo(^tan("SaveCardPurchaseInfo"))
ClassMethod SaveCardPurchaseInfo(PurchaseInfo As %String) As %String
{
	s ^tmptan("CardPurchaseInfo","Save")=PurchaseInfo
	s StartNum=$P(PurchaseInfo,"^",1)
	s Amount=$P(PurchaseInfo,"^",2)
	s EndNum=$P(PurchaseInfo,"^",3)
	s Buyer=$P(PurchaseInfo,"^",4)
	s LogonDept=$P(PurchaseInfo,"^",5)
	s Note=$P(PurchaseInfo,"^",6)
	if (StartNum="")||(Amount="")||(EndNum="")||(Buyer="") {
		q "{"_"""result"""_":"_""""_100_""""_"}"
	}
	s HOSPID=$P(PurchaseInfo,"^",7)
	s CheckInfo=..CheckPurchaseRepeat(StartNum,EndNum,Amount)
	if (+CheckInfo'=0){
		q "{"_"""result"""_":"_""""_CheckInfo_""""_"}"
	}
	k PLIST
	s PLIST(2)=..%SysDate()
	s PLIST(3)=LogonDept
	s PLIST(4)=Buyer
	s PLIST(5)=Amount
	s PLIST(6)=StartNum
	s PLIST(7)=EndNum
	s PLIST(8)=Note
	s PLIST(11)="Y"
	s PLIST(12)=HOSPID
	&sql( INSERT INTO SQLUser.DHC_CardPurchaseManage VALUES :PLIST())
	
	q "{"_"""result"""_":"_""""_SQLCODE_""""_"}"
}

ClassMethod delete(IDS As %String, User As %String) As %String
{
	s ^tmptan("CardPurchaseInfo","delete")=IDS_"^"_User
	s Ret=0
	s ToDay=..%SysDate()
	for i=1:1:$length(IDS,","){
		s ID=$P(IDS,",",i)
		

		if ($D(^DHCCARDManage("PurchaseAllot",0,"PreManageDr",ID))) {
			s Ret="已发放过，不允许删除"
			q
		}
		&sql( Update SQLUser.DHC_CardPurchaseManage set CPM_Avail='N' , 
		CPM_UpdateUsr=:User , CPM_UpdateDat=:ToDay where CPM_RowID=:ID)
		s Ret=Ret+SQLCODE
	}
	q "{"_"""result"""_":"_""""_Ret_""""_"}"
}

ClassMethod CheckPurchaseRepeat(StartNum As %String, EndNum As %String, Amount As %String) As %String
{
	if (+EndNum-StartNum+1)'=(+Amount) {
		q "-10^起始号、结束号与号数不匹配"
	}
	s RepeatID=""
	s ID=0
	for {
		s ID=$O(^DHCCARDManage("Purchase",ID))
		q:ID=""
		s Val=$G(^DHCCARDManage("Purchase",ID))
		s ActiveFlag=$P(Val,"^",10)
		continue:ActiveFlag="N"
		s myStartNum=$P(Val,"^",5)
		s myEnd=$P(Val,"^",6)
		if '((StartNum>myEnd)||(EndNum<myStartNum)){
			s RepeatID=ID
			q	
		}
	}
	if (RepeatID'=""){
		s RepeatUser=$P($G(^DHCCARDManage("Purchase",RepeatID)),"^",3)
		s RepeatUserName=$P(^SSU("SSUSR",RepeatUser),"^",2)
		s RepeatDate=$P($G(^DHCCARDManage("Purchase",RepeatID)),"^",1)
		s RepeatDate=..%ZD(RepeatDate) //$ZD(RepeatDate,3)
		q "-121^购入重复卡号："_RepeatUserName_";"_RepeatDate
	}
	q 0
}

ClassMethod CardPurchaseInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardPurchaseInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCardPurchaseManage","CardPurchaseInfo","","")
ClassMethod CardPurchaseInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, User As %String, HospID = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
    If $g(ind)="" Set ind=1
    s ^tmptan("CardPurchaseInfo")=StartDate_","_EndDate
    i StartDate["-" s StartDate=$ZDH(StartDate,3)
    i StartDate["/" s StartDate=$ZDH(StartDate,4)
    i EndDate["-" s EndDate=$ZDH(EndDate,3)
    i EndDate["/" s EndDate=$ZDH(EndDate,4)
	s RowID=""
	for {
		s RowID=$O(^DHCCARDManage("Purchase",RowID),-1)
		q:+RowID=0
		s Val=$G(^DHCCARDManage("Purchase",RowID))
		continue:Val=""
		s CPMDate=$P(Val,"^",1)
		if (StartDate'="")&&(StartDate>CPMDate){
			continue
		}
		if (EndDate'="")&&(EndDate<CPMDate){
			continue
		}
		i CPMDate'="" s CPMDate=..%ZD(CPMDate) //$ZD(CPMDate,3)
		s CPMLoc=$P(Val,"^",2)
		s LocDesc=""
		if (CPMLoc'=""){
			s LocDesc=$P(^CTLOC(CPMLoc),"^",2)
		}
		s UserName=""
		s CPMBuyer=$P(Val,"^",3)
		continue:(User'="")&&(CPMBuyer'=User)
		if (CPMBuyer'=""){
			s UserName=$P(^SSU("SSUSR",CPMBuyer),"^",2)
		}
		s Amount=$P(Val,"^",4)
		s StartNum=$P(Val,"^",5)
		s EndNum=$P(Val,"^",6)
		s CPMNote=$P(Val,"^",7)
		s UpdateUser=$P(Val,"^",8)
		if (UpdateUser'=""){
			s UpdateUser=$P(^SSU("SSUSR",UpdateUser),"^",2)
		}
		s UpdateDate=$P(Val,"^",9)
		i UpdateDate'="" s UpdateDate=..%ZD(UpdateDate) //$ZD(UpdateDate,3)
		s Active=$P(Val,"^",10)
		s HOSPID=$P(Val,"^",11)
		s HOSPName=""
		if (HOSPID'=""){
			continue:HospID'=HOSPID
			s HOSPName=$P(^CT("HOSP",HOSPID),"^",2)
		}
		d OutputRow3
		
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	//RowID,Date,LocDesc,UserName,Amount,StartNum,EndNum,Active,UpdateUser,UpdateDate
OutputRow3   
	set Data=$lb(RowID,CPMDate,LocDesc,UserName,Amount,StartNum,EndNum,Active,UpdateUser,UpdateDate,CPMNote,HOSPName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CardPurchaseInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardPurchaseInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query CardPurchaseInfo(StartDate As %String, EndDate As %String, User As %String, HospID = "") As %Query(ROWSPEC = "RowID:%String,Date:%String,LocDesc:%String,UserName:%String,Amount:%String,StartNum:%String,EndNum:%String,Active:%String,UpdateUser:%String,UpdateDate:%String,CPMNote:%String,HOSPName:%String")
{
}

/// w ##Class(web.DHCCardPurchaseManage).SaveCardPurchaseAllot(^tan("CardPurchaseInfo","SaveAllot"))
ClassMethod SaveCardPurchaseAllot(PurchaseAllotInfo As %String) As %String
{
	s ^tmptan("CardPurchaseInfo","SaveAllot")=PurchaseAllotInfo
	s StartNum=$P(PurchaseAllotInfo,"^",1)
	s Amount=$P(PurchaseAllotInfo,"^",2)
	s EndNum=$P(PurchaseAllotInfo,"^",3)
	s User=$P(PurchaseAllotInfo,"^",4)
	s LogonDept=$P(PurchaseAllotInfo,"^",5)
	s Note=$P(PurchaseAllotInfo,"^",6)
	if (StartNum="")||(Amount="")||(EndNum="")||(User="") {
		q "{"_"""result"""_":"_""""_100_""""_"}"
	}
	s HOSPID=$P(PurchaseAllotInfo,"^",7)
	s UpdateUser=$P(PurchaseAllotInfo,"^",8)
	s CheckInfo=..CheckPurchaseAllotRepeat(StartNum,EndNum,Amount,HOSPID)
	if (+CheckInfo'=0){
		q "{"_"""result"""_":"_""""_CheckInfo_""""_"}"
	}
	s RepeatID=$P(CheckInfo,"^",2)
	k PLIST
	s PLIST(2)=..%SysDate()
	s PLIST(3)=LogonDept
	s PLIST(4)=User
	s PLIST(5)=Amount
	s PLIST(6)=StartNum
	s PLIST(7)=EndNum
	s PLIST(8)=Amount	;left
	s PLIST(9)=Note
	s PLIST(10)=UpdateUser
	s PLIST(11)=..%SysDate()
	s PLIST(12)="Y"
	s PLIST(13)=HOSPID
	s PLIST(14)=RepeatID
	&sql( INSERT INTO SQLUser.DHC_CardPurchaseAllot VALUES :PLIST())
	
	q "{"_"""result"""_":"_""""_SQLCODE_""""_"}"
}

ClassMethod CheckPurchaseAllotRepeat(StartNum As %String, EndNum As %String, Amount As %String, HOSPID As %String) As %String
{
	if (+EndNum-StartNum+1)'=(+Amount) {
		q "-10^起始号、结束号与号数不匹配"
	}
	s RepeatID=""
	s ID=0
	for {
		s ID=$O(^DHCCARDManage("Purchase",ID))
		q:ID=""
		s Val=$G(^DHCCARDManage("Purchase",ID))
		s ActiveFlag=$P(Val,"^",10)
		continue:ActiveFlag="N"
		s CPMHospDr=$P(Val,"^",11)
		if (HOSPID'="")&&(CPMHospDr'=HOSPID){
			continue
		}
		s myStartNum=$P(Val,"^",5)
		s myEnd=$P(Val,"^",6)
		if ((StartNum>=myStartNum)&&(EndNum<=myEnd)){
			s RepeatID=ID
			q	
		}
	}
	if (RepeatID=""){
		q "-11^未找到对应的购入卡记录"
	}
	s AllotID=""
	s ID=0
	for{
		s ID=$O(^DHCCARDManage("PurchaseAllot",0,"PreManageDr",RepeatID,ID))
		q:ID=""
		s Val=$G(^DHCCARDManage("PurchaseAllot",ID))
		s myStartNum=$P(Val,"^",5)
		s myEnd=$P(Val,"^",6)

		if '((StartNum>myEnd)||(EndNum<myStartNum)){
			s AllotID=ID
			q	
		}
	}

	if (AllotID'=""){
		s Val=$G(^DHCCARDManage("PurchaseAllot",AllotID))
		s AllotUser=$P(Val,"^",3)
		s AllotUserName=$P(^SSU("SSUSR",AllotUser),"^",2)
		s AllotDate=$P(Val,"^",1)
		
		s AllotDate=..%ZD(AllotDate) //$ZD(AllotDate,3)
		q "-121^该卡段已分配："_AllotUserName_";"_AllotDate
	}
	q 0_"^"_RepeatID
}

ClassMethod CardPurchaseAllotInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardPurchaseAllotInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCardPurchaseManage","CardPurchaseAllotInfo","19/07/2017","","","")
ClassMethod CardPurchaseAllotInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, ReceUser As %String, CardNo As %String, HospID = "") As %Status
{
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
    s ^tmptan("CardPurchaseAllotInfo")=StartDate_","_EndDate_","_ReceUser_","_CardNo
    i StartDate["-" s StartDate=$ZDH(StartDate,3)
    i StartDate["/" s StartDate=$ZDH(StartDate,4)
    i EndDate["-" s EndDate=$ZDH(EndDate,3)
    i EndDate["/" s EndDate=$ZDH(EndDate,4)
	s RowID=""
	for {
		s RowID=$O(^DHCCARDManage("PurchaseAllot",RowID),-1)
		q:+RowID=0
		s Val=$G(^DHCCARDManage("PurchaseAllot",RowID))
		continue:Val=""
		s CPMDate=$P(Val,"^",1)
		b //1
		if (StartDate'="")&&(StartDate>CPMDate){
			continue
		}
		if (EndDate'="")&&(EndDate<CPMDate){
			continue
		}
		i CPMDate'="" s CPMDate=..%ZD(CPMDate) //$ZD(CPMDate,3)
		s CPMLoc=$P(Val,"^",2)
		s LocDesc=""
		if (CPMLoc'=""){
			s LocDesc=$P(^CTLOC(CPMLoc),"^",2)
		}
		s UserName=""
		s CPMBuyer=$P(Val,"^",3)
		if (ReceUser'="")&&(ReceUser'=CPMBuyer){
			continue
		}
		if (CPMBuyer'=""){
			s UserName=$P(^SSU("SSUSR",CPMBuyer),"^",2)
		}
		s Amount=$P(Val,"^",4)
		s StartNum=$P(Val,"^",5)
		s EndNum=$P(Val,"^",6)
		if (CardNo'="")&&(((StartNum>CardNo)||(EndNum<CardNo))){
			continue
		}
		
		s LeftNum=$P(Val,"^",7)
		s CPMNote=$P(Val,"^",8)
		s UpdateDate=$P(Val,"^",9)
		i UpdateDate'="" s UpdateDate=..%ZD(UpdateDate) //$ZD(UpdateDate,3)
		s UpdateUser=$P(Val,"^",10)
		if (UpdateUser'=""){
			s UpdateUser=$P(^SSU("SSUSR",UpdateUser),"^",2)
		}
		
		s Active=$P(Val,"^",11)
		if (Active="Y"){
			s Active="未用完"
		}else{
			s Active="已用完"
		}
		s HOSPID=$P(Val,"^",12)
		s HOSPName=""
		if (HOSPID'=""){
			continue:HospID'=HOSPID
			s HOSPName=$P(^CT("HOSP",HOSPID),"^",2)
		}
		d OutputRow4
		
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	//RowID,Date,LocDesc,UserName,Amount,StartNum,EndNum,Active,UpdateUser,UpdateDate
OutputRow4 
	set Data=$lb(RowID,CPMDate,LocDesc,UserName,Amount,StartNum,EndNum,LeftNum,Active,UpdateUser,UpdateDate,CPMNote,HOSPName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CardPurchaseAllotInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardPurchaseAllotInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query CardPurchaseAllotInfo(StartDate As %String, EndDate As %String, ReceUser As %String, CardNo As %String, HospID = "") As %Query(ROWSPEC = "RowID:%String,Date:%String,LocDesc:%String,UserName:%String,Amount:%String,StartNum:%String,EndNum:%String,LeftNum:%String,Active:%String,UpdateUser:%String,UpdateDate:%String,CPMNote:%String,HOSPName:%String")
{
}

ClassMethod GetUserLeftNum(UserID As %String, HospDr As %String = "") As %String
{
	s Count=0
	s RowID=""
	for {
		s RowID=$O(^DHCCARDManage("PurchaseAllot",0,"User",UserID,RowID),-1)
		q:+RowID=0
		s Val=$G(^DHCCARDManage("PurchaseAllot",RowID))
		continue:Val=""
		s CPMBuyer=$P(Val,"^",3)
		if (UserID'="")&&(UserID'=CPMBuyer){
			continue
		}
		s CPMHospDr=$P(Val,"^",12)
		if (HospDr'="")&&(CPMHospDr'=HospDr){
			continue
		}
		s LeftNum=$P(Val,"^",7)
		s Count=Count+LeftNum
	}
	q Count
}

}
