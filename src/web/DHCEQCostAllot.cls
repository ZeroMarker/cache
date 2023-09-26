Import SQLUser

Class web.DHCEQCostAllot Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Parameter SQLCODE = "CA_RowID";

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "CA_RowID";

Parameter SQLROWID = "CA_RowID";

ClassMethod CostAllotClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CostAllotExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CostAllotExecute(ByRef qHandle As %Binary, EquipDR As %String = "", Types As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s TRow=0
	d BuildDataGetCostAllot
	Quit $$$OK
BuildDataGetCostAllot
	q:(EquipDR="")||(Types="")
	s rowid=$o(^DHCEQCostAllot(0,"EquipType",EquipDR,Types,rowid))
	q:rowid=""
	s ListID=0
	f  s ListID=$o(^DHCEQCostAllotList(0,"CostAllotDR",rowid,ListID))  quit:ListID=""  d
	.d ResetVariablesGetCostAllot
	.s TRowID = ListID	//rowid
	.s TAllotLoc=$p($g(^DHCEQCostAllotList(TRowID)),"^",2)
	.i TAllotLoc'="" s TAllotLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TAllotLoc)
	.s TAllotRate=$p($g(^DHCEQCostAllotList(TRowID)),"^",3)
	.s TAllotTypeDR=$p($g(^DHCEQCostAllot(rowid)),"^",14)
	.i TAllotTypeDR'="" s TAllotType=##Class(web.DHCEQFind).GetDisplayAllotType(TAllotTypeDR)
	.s TAllotValue=$p($g(^DHCEQCostAllotList(TRowID)),"^",5)
	.d OutputRowGetCostAllot
	quit
OutputRowGetCostAllot
	Set TRow=TRow+1		;需求序号:	441553		Mozy	20170903
	s Data=$lb(TRowID,TAllotLoc,TAllotRate,TAllotType,TAllotValue,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCostAllot
	s (TRowID,TAllotLoc,TAllotRate,TAllotType,TAllotValue)=""
	quit
}

ClassMethod CostAllotFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CostAllotExecute ]
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

Query CostAllot(EquipDR As %String = "", Types As %String = "") As %Query(ROWSPEC = "TRowID:%String,TAllotLoc:%String,TAllotRate:%String,TAllotType:%String,TAllotValue:%String,TRow:%String")
{
}

/*****************************************/
ClassMethod GetList(rowid)
{
	s AllotLoc=""
	s AllotLocDR=$p($g(^DHCEQCostAllotList(rowid)),"^",2)
	i AllotLocDR'="" s AllotLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",AllotLocDR)
	s AllotRate=$p($g(^DHCEQCostAllotList(rowid)),"^",3)
	s CARowID=$p($g(^DHCEQCostAllotList(rowid)),"^",1)
	s AllotType=$p($g(^DHCEQCostAllot(CARowID)),"^",14)
	s AllotValue=$p($g(^DHCEQCostAllotList(rowid)),"^",5)
	q AllotLocDR_"^"_AllotLoc_"^"_AllotRate_"^"_AllotType_"^"_AllotValue
}

/// w ##class(web.DHCEQCostAllot).SaveData("","","^2^138^227^^6^900^30","")
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "", TotalMaintFee As %Library.String = "")
{
 k PLIST,rowid,LIST
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
	 s CARowID=$p($g(^DHCEQCostAllotList(rowid)),"^",1)
 	&SQL(Delete From SQLUSER.DHC_EQCostAllotList where CAL_RowID = :rowid) 
 	if SQLCODE  q SQLCODE
 	//当无明细记录时需要删除主表	//Add By DJ 2017-03-22
 	i '$D(^DHCEQCostAllotList(0,"CostAllotDR",CARowID))
 	{
	 	&SQL(Delete From SQLUSER.DHC_EQCostAllot where CA_RowID = :CARowID)
	 	if SQLCODE  q SQLCODE
 	}
 	q rowid
 }
 s Types=$p(val,"^",2)
 s EquipDR=$p(val,"^",3)
 s AllotLocDR=$p(val,"^",4)
 s AllotRate=$p(val,"^",5)
 s AllotType=$p(val,"^",6)
 s AllotValue=$p(val,"^",7)
 s SourceID=$p(val,"^",8)

 TSTART
 s ID=""
 i (Types=2)  //维修 add by CZF0076 2020-02-26
 {
	 s CARowID=""
	 f  s CARowID=$o(^DHCEQCostAllot(0,"EquipType",EquipDR,Types,CARowID)) q:CARowID=""  d
	 .q:$p($g(^DHCEQCostAllot(CARowID)),"^",17)'=SourceID
	 .s ID=CARowID
 }
 else
 {
	s EQOriginalFee=$p($g(^DHCEQEquip(EquipDR)),"^",27)		//czf 2116352 2021-09-08
 	i (AllotType=6)&&(EQOriginalFee<AllotValue) q -1003
 	s ID=$o(^DHCEQCostAllot(0,"EquipType",EquipDR,Types,ID))
 }
 i (ID="")
 {
	 s PLIST(3)="N"
	 s PLIST(4)=1
	 s PLIST(5)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	 s PLIST(6)=+$H
	 s PLIST(7)=$P($H,",",2)
	 s PLIST(14)=EquipDR
	 s PLIST(15)=AllotType
	 s PLIST(16)=Types
	 s PLIST(18)=SourceID	//Hold2 add by CZF0076 2020-02-26
	 &SQL(Insert Into SQLUSER.DHC_EQCostAllot Values :PLIST())
	 i SQLCODE
	 {
		 TROLLBACK
		 q SQLCODE
	 }
	 s ID=$g(%ROWID)
 }
 else
 {
	 s IDAllotType=$p($g(^DHCEQCostAllot(ID)),"^",14)
	 //同一单据的设备分摊方式相同
	 i AllotType'=IDAllotType
	 {
		 TROLLBACK
		 q -1001
	 }
	 else
	 {
		 //固定比例分摊总占比小于等于100
		 if IDAllotType=0
		 {
			 s CALRateCount=AllotRate
			 s CALRowID=0
			 f  s CALRowID=$o(^DHCEQCostAllotList(0,"CostAllotDR",ID,CALRowID))  q:CALRowID=""  d
			 .q:(rowid'="")&&(CALRowID=rowid)
			 .s CALRateCount=CALRateCount+$p($g(^DHCEQCostAllotList(CALRowID)),"^",3)
			 i CALRateCount>100
			 {
				 TROLLBACK
				 q -1002
			 }
		 }
		 elseif IDAllotType=6 	//固定值 add by CZF0076 2020-02-26
		 {
			 s CostValueCount=AllotValue
			 s CALRowID=0
			 f  s CALRowID=$o(^DHCEQCostAllotList(0,"CostAllotDR",ID,CALRowID))  q:CALRowID=""  d
			 .q:(rowid'="")&&(CALRowID=rowid)
			 .s CostValueCount=CostValueCount+$p($g(^DHCEQCostAllotList(CALRowID)),"^",5)
			 i Types=2
			 {
				 //s TotalMaintFee=$p($g(^DHCEQMMaintRequest(SourceID)),"^",60)
				 i CostValueCount>TotalMaintFee
				 {
					 TROLLBACK
					 q -1003
				 }
			 }
		 }
	 }
 }
 s ListID=0
 s ListID=$o(^DHCEQCostAllotList(0,"AllotLoc",ID,AllotLocDR,ListID))
 s LIST(2)=ID
 s LIST(3)=AllotLocDR
 s LIST(4)=AllotRate
 s LIST(6)=AllotValue
 i rowid=""
 {
	 i ListID'=""
	 {
		 TROLLBACK
		 q -99
	 }
	 &SQL(Insert Into SQLUSER.DHC_EQCostAllotList Values :LIST())
	 i SQLCODE
	 {
		 TROLLBACK
		 q SQLCODE
	 }
	 s ListID=$g(%ROWID)
 }
 else
 {
	 i (ListID'="")&&(ListID'=rowid)
	 {
		 TROLLBACK
		 q -99
	 }
	 &SQL(Update SQLUSER.DHC_EQCostAllotList Values :LIST() where CAL_RowID=:rowid)
	 i SQLCODE
	 {
		 TROLLBACK
		 q SQLCODE
	 }
	 s ListID=rowid
 }
 s IDAllotType=$p($g(^DHCEQCostAllot(ID)),"^",14)
 if IDAllotType'=0		//非固定比例存储分摊总和
 {
	 s CALValue=0
	 s CALRowID=0
	 f  s CALRowID=$o(^DHCEQCostAllotList(0,"CostAllotDR",ID,CALRowID))  q:CALRowID=""  d
	 .s CALValue=CALValue+$p($g(^DHCEQCostAllotList(CALRowID)),"^",5)
	 &SQL(Update SQLUSER.DHC_EQCostAllot Set CA_Hold1=:CALValue Where CA_RowID=:ID)
	 i SQLCODE
	 {
		 TROLLBACK
		 q SQLCODE
	 }
 }
 TCOMMIT
 q ListID
}

/*****************************************/
}
