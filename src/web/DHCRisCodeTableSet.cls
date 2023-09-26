Import SQLUser

/// 2014-05-28
/// 新增了同仁眼科配置程序函数:
/// 增加了导入数据函数
/// 2014-06-13 
/// 修改了 GetMemo函数
Class web.DHCRisCodeTableSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query QueryRoom() As %Query(ROWSPEC = "rowid:%String,code:%String,name:%String,LocName:%String,Locdr:%String,address:%String")
{
}

ClassMethod QueryRoomExecute(ByRef qHandle As %Binary) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTable","QueryRoom") 
 Set repid=$I(^CacheTemp)
 s ind=1
 
 s roomrowid="" f  s roomrowid=$O(^DHCRBC("Room",roomrowid)) q:(roomrowid="")  d
 .s code=$p(^DHCRBC("Room",roomrowid),"^",1)
 .s desc=$p(^DHCRBC("Room",roomrowid),"^",2)
 .s Locdr=$p($g(^DHCRBC("Room",roomrowid)),"^",3)
 .s:Locdr'="" LocName=$p(^CTLOC(Locdr),"^",2)
 .s address=$p($g(^DHCRBC("Room",roomrowid)),"^",4)
 .Do OutRoom
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutRoom
 set Data=$lb(roomrowid,code,desc,LocName,Locdr,address)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryRoomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRoomExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryRoomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRoomExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SetDHCRBCRoom(AllInfo As %String, OperateCode As %String) As %String
{
	//d ##class(web.DHCRisCodeTable).SetDHCRBCRoom("","I")
	s Rowid = $P(AllInfo,"^",1)
	s Code=$P(AllInfo,"^",2)
	s Desc=$P(AllInfo,"^",3)
	s LocDR = $P(AllInfo,"^",4)
	s Address=$P(AllInfo,"^",5)
	
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_Room(DCRM_RoomCode,DCRM_RoomName,DCRM_Loc_DR) 
	      values(:Code,:Desc,:LocDR))
	.s srowid=$p(%ROWID,$c(1))
	.i srowid'="" d
	..s $p(^DHCRBC("Room",srowid),"^",4)=Address
	
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_Room(DCRM_RoomCode,DCRM_RoomName,DCRM_Loc_DR) 
	      values(:Code,:Desc,:LocDR)
	      where DCRM_RowID=:Rowid )
	.s srowid=$p(%ROWID,$c(1))
	.i srowid'="" d
	..s $p(^DHCRBC("Room",srowid),"^",4)=Address
	
	s RegInfoUsedCount=0,RoomEquipmentUsed=0
	i OperateCode="D" d
	.&sql(select count(*) into :RegInfoUsedCount from DHCRB_RegInfo where RAR_Room_DR=:Rowid )
	.&sql(select count(*) into :RoomEquipmentUsed from DHCRBC_Room_Equipment where DCRME_ParRef=:Rowid)
	.i (RegInfoUsedCount=0)&(RoomEquipmentUsed=0) d
	..&sql(Delete from DHCRBC_Room where DCRM_RowID = :Rowid)
	i (OperateCode="D") & ((RegInfoUsedCount'=0)!(RoomEquipmentUsed'=0)) q -999
    q SQLCODE
}

Query QueryDHCRBCRoomEquipment(RoomDR As %String) As %Query(ROWSPEC = "roomrowid:%String,roomname:%String,equipdr:%String,equipname:%String,RoomDR:%String")
{
}

ClassMethod QueryDHCRBCRoomEquipmentExecute(ByRef qHandle As %Binary, RoomDR As %String) As %Status
{
	s ^DHCRis("TMP")=RoomDR
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryDHCRBCRoomEquipment","5") 
 Set repid=$I(^CacheTemp)
 ;s RoomDR=''
 ;i RoomName'=''  d  &sql(select DCRM_RowID into :RoomDR from  DHCRBC_Room where DCRM_RoomName=:RoomName)
 s ind=1
 s RoomRowid="" f  s RoomRowid=$O(^DHCRBC(0,"RoomEquipment",RoomRowid)) q:(RoomRowid="")  d
 .i (RoomRowid=RoomDR) s ChildSub="" f  s ChildSub=$O(^DHCRBC(0,"RoomEquipment",RoomRowid,ChildSub)) q:ChildSub=""  d
 ..s RoomName=$p(^DHCRBC("Room",RoomRowid),"^",2)
 ..S EquipDR=""
 ..s EquipDR=$P(^DHCRBC(0,"RoomEquipment",RoomRowid,ChildSub),"^",1)
 ..S EquipName=""
 ..s:EquipDR'="" EquipName=$p($g(^RBC("EQ",EquipDR)),"^",2) //^RBC("EQ",18)=1^CT16^7^60433^
 ..Do OutRoomEquipment
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutRoomEquipment
 set Data=$lb(RoomRowid_"||"_ChildSub,RoomName,EquipDR,EquipName,RoomDR)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryDHCRBCRoomEquipmentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDHCRBCRoomEquipmentExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryDHCRBCRoomEquipmentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDHCRBCRoomEquipmentExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SetDHCRBCRoomEquipment(AllInfo As %String, OperateCode As %String) As %String
{
	//d ##class(web.DHCRisCodeTable).SetDHCRBCRoomEquipment("","I")
	s RERowid=$P(AllInfo,"^",1)
	s RoomDR=$P(AllInfo,"^",2)
	s EquipDR=$P(AllInfo,"^",3)
	//s EquipDR=""
	//&sql(select DCRM_RowID into :RoomDR from  DHCRBC_Room where DCRM_RoomName=:RoomName)
	;&sql(select EQ_RowId into :EquipDR from  RBC_Equipment where EQ_Desc=:EquipName) 
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_Room_Equipment(DCRME_ParRef,DCRME_Equipment_DR) 
	      values(:RoomDR,:EquipDR))
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_Room_Equipment(DCRME_Equipment_DR) 
	      values(:EquipDR)
	      where DCRME_RowID=:RERowid )
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_Room_Equipment where DCRME_RowID = :RERowid)
    q SQLCODE
}

Query QueryRBCEquipment() As %Query(ROWSPEC = "EQrowid:%String,EQcode:%String,EQdesc:%String")
{
}

ClassMethod QueryRBCEquipmentExecute(ByRef qHandle As %Binary) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTable","QueryRBCEquipment") 
 s ind=1
 Set repid=$I(^CacheTemp)
 s Rowid="0" f  s Rowid=$O(^RBC("EQ",Rowid)) q:(Rowid="")  d
 .s Code=$p(^RBC("EQ",Rowid),"^",1)
 .S Desc=$p(^RBC("EQ",Rowid),"^",2)
 .Do OutRBCEquipment
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutRBCEquipment
 set Data=$lb(Rowid,Code,Desc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryRBCEquipmentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRBCEquipmentExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryRBCEquipmentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRBCEquipmentExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query QueryRBCEquipmentGroup() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,DateFrom:%String,DateTo:%String")
{
}

ClassMethod QueryRBCEquipmentGroupExecute(ByRef qHandle As %Binary) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTable","QueryRBCEquipmentGroup") 
 s ind=1
 Set repid=$I(^CacheTemp)
 s Rowid=0 f  s Rowid=$O(^RBC("GRP",Rowid)) q:(Rowid="")  d
 .s Code=$p(^RBC("GRP",Rowid),"^",1)
 .S Desc=$p(^RBC("GRP",Rowid),"^",2)
 .S DateFrom=$p(^RBC("GRP",Rowid),"^",3)
 .s DateTo=$p(^RBC("GRP",Rowid),"^",4)
 .Do OutEquipmentGroup
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutEquipmentGroup
 set Data=$lb(Rowid,Code,Desc,DateFrom,DateTo)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryRBCEquipmentGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRBCEquipmentGroupExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryRBCEquipmentGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRBCEquipmentGroupExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetEquipmentList() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryRBCEquipment")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(3)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(3)
	}	
	d rset.Close()
	q ret
}

/// 查询医嘱关联的检查目的
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryDHCRBCGoal")
Query QueryDHCRBCGoal(Info As %String) As %Query(ROWSPEC = "Rowid:%String,ItmCode:%String,Goal:%String,ArcItemRowid:%String")
{
}

ClassMethod QueryDHCRBCGoalExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
 ;^DHCRBCApp("GLOBAL",{DRG_RowID}) ;s Rowid="" f  s Rowid=$O(^DHCRBCApp("GLOBAL",Rowid)) q:(Rowid="")  d
 s ind=1
 Set repid=$I(^CacheTemp)
 s QArcItemID=$p($g(Info),"^",1)
 
 s Rowid="" f  s Rowid=$O(^DHCRBCApp("GLOBAL",Rowid),-1) q:(Rowid="")  d
 .s ItmCode=$p($g(^DHCRBCApp("GLOBAL",Rowid)),"^",1)
 .q:(ItmCode="")
 .s ArcItemRowid=ItmCode
 .q:(QArcItemID'="")&(QArcItemID'=ArcItemRowid)
 .s Subscript=$p(ItmCode,"||",1),Version=$p(ItmCode,"||",2)
 .s ItmCode=$p(^ARCIM(Subscript,Version,1),"^",2)
 .s Goal=$p(^DHCRBCApp("GLOBAL",Rowid),"^",2)
 .;s Goal=..ChangeRportInfo(Goal)
 .Do OutGoal
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutGoal
 set Data=$lb(Rowid,ItmCode,Goal,ArcItemRowid)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryDHCRBCGoalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDHCRBCGoalExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryDHCRBCGoalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDHCRBCGoalExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(web.DHCRisCodeTable).SetDHCRBCGoal("","I")
ClassMethod SetDHCRBCGoal(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid=$P(AllInfo,"^",1)
	s ItmDR=$P(AllInfo,"^",2)
	s Goal=$P(AllInfo,"^",3)
	
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_Goal(DRG_ArcItmMast_DR,DRG_GoalDesc) 
	      values(:ItmDR,:Goal))
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_Goal(DRG_GoalDesc)  
	      values(:Goal)
	      where DRG_RowID=:Rowid )
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_Goal where DRG_RowID = :Rowid)
    q SQLCODE
}

/// 设置医嘱关联的注意事项
/// d ##class(web.DHCRisCodeTable).SetDHCRBMemo("","I")
ClassMethod SetDHCRBMemo(AllInfo As %String, OperateCode As %String) As %String
{

	s Rowid=$P(AllInfo,"^",1)
	s ItmDR=$P(AllInfo,"^",2)
	s Memo=$P(AllInfo,"^",3)
	i OperateCode="I" d
	.&sql(Insert into DHCRB_Memo(DM_ARCItmMast_DR)values(:ItmDR))
	.s srowid=$p(%ROWID,$c(1))
	.i srowid'="" d
	..s $p(^DHCRBApp("Memo",srowid),"^",2)=Memo
	
	i OperateCode="U" d
	.s $p(^DHCRBApp("Memo",Rowid),"^",2)=Memo
	.s SQLCODE="0"
	
	i OperateCode="D" d
	.&sql(Delete from DHCRB_Memo where DM_RowID = :Rowid)
    q SQLCODE
}

/// 查询医嘱关联的注意事项
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryDHCRBMemo") 
Query QueryDHCRBMemo(Info As %String) As %Query(ROWSPEC = "Rowid:%String,ItmCode:%String,Memo:%String,ArcItemRowid:%String")
{
}

ClassMethod QueryDHCRBMemoExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
 
 ;^DHCRBApp("Memo",{DM_RowID});s Rowid="" f  s Rowid=$O(^DHCRBApp("Memo",Rowid)) q:(Rowid="")  d
 s ind=1
 Set repid=$I(^CacheTemp)
 s QARCItemID=$p($g(Info),"^",1)
 
 s Rowid="" f  s Rowid=$O(^DHCRBApp("Memo",Rowid),-1) q:(Rowid="")  d
 .s ItmCode=$p($g(^DHCRBApp("Memo",Rowid)),"^",1)
 .q:(ItmCode="")
 .s ArcItemRowid=ItmCode
 .q:(QARCItemID'="")&(QARCItemID'=ArcItemRowid)
 .s Subscript=$p(ItmCode,"||",1),Version=$p(ItmCode,"||",2)
 .s ItmCode=$p(^ARCIM(Subscript,Version,1),"^",2)
 .S Memo=$p($g(^DHCRBApp("Memo",Rowid)),"^",2)
 .Do OutMemo
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutMemo
 set Data=$lb(Rowid,ItmCode,Memo,ArcItemRowid)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryDHCRBMemoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDHCRBMemoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryDHCRBMemoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDHCRBMemoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCRisCodeTableSet).GetGoalbyRowid("434")
ClassMethod GetGoalbyRowid(Rowid As %String)
{
	s Goal=""
	s Goal=$p($g(^DHCRBCApp("GLOBAL",Rowid)),"^",2)
	s Goal=..ChangeRportInfo(Goal)
	q Goal
}

ClassMethod GetMemobyRowid(Rowid As %String)
{
	s Memo=""
	s Memo=$p($g(^DHCRBApp("Memo",Rowid)),"^",2)
	s Memo=..ChangeRportInfo(Memo)
	q Memo
}

/// 对\n(_$c(13,10)_)和\r(_$c_)分别进行了16进制的转义，变为\X000a\和\X000b\
ClassMethod ChangeRportInfo(Param) As %String
{
   s Info=""
   s nums=$l(Param,$c(13,10))
   for i=1:1:nums  d
   .s perContent=$p(Param,$c(13,10),i)
   .i Info="" s Info=perContent
   .else  d
   ..s Info=Info_"X000a"_perContent
   
   s Param=Info
   s Info=""
   s nums=$l(Param,$c(13,10,13,10))
   for i=1:1:nums  d
   .s perContent=$p(Param,$c(13,10,13,10),i)
   .i Info="" s Info=perContent
   .else  d
   ..s Info=Info_"X000a"_perContent
   
   s Param=Info
   s Info=""
   s nums=$l(Param,$c(0))
   for i=1:1:nums  d
   .s perContent=$p(Param,$c(0),i)
   .i Info="" s Info=perContent
   .else  d
   ..s Info=Info_"X000b"_perContent
   
   s Param=Info
   s Info=""
   s nums=$l(Param,$c(13,10,13,10,13,10,13,10,13,10,13,10))
   for i=1:1:nums  d
   .s perContent=$p(Param,$c(13,10,13,10,13,10,13,10,13,10,13,10),i)
   .i Info="" s Info=perContent
   .else  d
   ..s Info=Info_"X000b"_perContent
   
   q Info
}

/// do ##class(web.DHCRisCodeTableSet).GetMemo("75911||57")
ClassMethod GetMemo(OEOrdItemID As %String) As %String
{
	q:(OEOrdItemID="")
	s OEOrdItemID=$p(OEOrdItemID,"@",1)
	
	s OrderRowid=$p(OEOrdItemID,"||",1)
	s itemsub=$p(OEOrdItemID,"||",2)
	s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	s Memo="",MRowid="",MTRowid="",ERowid=""
	
	i arcimid'="" d
	.s MRowid=$o(^DHCRBAppi("Memo-ItMast",arcimid,0))
	.i MRowid'="" d
	..s MTRowid=$p($g(^DHCRBApp("Memo",MRowid)),"^",4)
	..i MTRowid'=""  s Memo=$p($g(^DHCRBCApp("Memo-Template",MTRowid)),"^",3)
	..i Memo="" s Memo=$p($g(^DHCRBApp("Memo",MRowid)),"^",2)
	..s Memo=..ChangeRportInfo(Memo)
	
	i ((Memo="")!(Memo=" ")) d
	.s ERowid=$o(^DHCRBCExternalBookInfoi("OrdItemID",OEOrdItemID,ERowid))
	.i ERowid'="" s Memo=$p($g(^DHCRBCExternalBookInfo(ERowid)),"^",10)
	.s Memo=..ChangeRportInfo(Memo)
	
	q Memo
}

/// 设置注意事项模板
/// sunyi 2012-04-20
/// d ##class(web.DHCRisCodeTable).SetMemoTemplate("","I")
ClassMethod SetMemoTemplate(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid=$P($g(AllInfo),"^",1)
	s Code=$P($g(AllInfo),"^",2)
	s Desc=$P($g(AllInfo),"^",3)
	s Content=$P($g(AllInfo),"^",4)
	
	s MemoUseCount=0
	
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_Memo_Template(DMT_Code,DMT_Desc)values(:Code,:Desc))
	.s srowid=$p(%ROWID,$c(1))
	.i srowid'="" d
	..s $p(^DHCRBCApp("Memo-Template",srowid),"^",3)=Content
	
	i OperateCode="U" d
	.s $p(^DHCRBCApp("Memo-Template",Rowid),"^",3)=Content
	.s SQLCODE="0"
	
	i (OperateCode="D")
	{
	   &sql(select count(*) into :MemoUseCount from DHCRB_Memo where DM_MTemplate_DR=:Rowid)
	   i (MemoUseCount=0) 
	   {
	     &sql(Delete from DHCRBC_Memo_Template where DMT_RowId =:Rowid)
	   }
       else
       {
	     s SQLCODE=-999
	   }
    }
	
    q SQLCODE
}

/// 查询注意事项模板
/// sunyi 2012-04-20
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryMemoTemplate","^") 
Query QueryMemoTemplate(Info As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod QueryMemoTemplateExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
 
 s ind=1
 Set repid=$I(^CacheTemp)
 s GetDesc=$p($g(Info),"^",1)
 s GetCode=$p($g(Info),"^",2)
 
 s Rowid="" f  s Rowid=$o(^DHCRBCApp("Memo-Template",Rowid),-1) q:(Rowid="")  d
 .s Code=$p($g(^DHCRBCApp("Memo-Template",Rowid)),"^",1)
 .q:(GetCode'="")&(GetCode'=Code)
 .s Desc=$p($g(^DHCRBCApp("Memo-Template",Rowid)),"^",2)
 .q:(GetDesc'="")&(GetDesc'=Desc)
 .;s Content=$p($g(^DHCRBCApp("Memo-Template",Rowid)),"^",3)
 .Do OutMemoTemplate
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutMemoTemplate
 set Data=$lb(Rowid,Code,Desc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryMemoTemplateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMemoTemplateExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryMemoTemplateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMemoTemplateExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##class(web.DHCRisCodeTableSet).GetMTemplate("1")
ClassMethod GetMTemplate(Rowid As %String)
{
	s Memo=""
	s Memo=$p($g(^DHCRBCApp("Memo-Template",Rowid)),"^",3)
	s Memo=..ChangeRportInfo(Memo)
	q Memo
}

/// 设置医嘱关联的注意事项模板(协和)
/// d ##class(web.DHCRisCodeTable).SetMemo("","I")
ClassMethod SetMemo(AllInfo As %String, OperateCode As %String) As %String
{

	s Rowid=$P(AllInfo,"^",1)
	s ItmDR=$P(AllInfo,"^",2)
	s MTRowid=$P(AllInfo,"^",3)
	s UMRowid=$p(AllInfo,"^",4)
	
	;判断是否已经存在
	if (ItmDR'="")
	{
		s memoRowidGet = $o(^DHCRBAppi("Memo-ItMast",ItmDR,""))
	}
	i OperateCode="I" d
	.if $g(memoRowidGet)'="" d
	..s SQLCODE="200"
	.e  d
	..&sql(Insert into DHCRB_Memo(DM_ARCItmMast_DR,DM_MTemplate_DR,DM_UseMethod_DR)values(:ItmDR,:MTRowid,:UMRowid))
	
	i OperateCode="U" d
	.&sql(UpDate DHCRB_Memo(DM_ARCItmMast_DR,DM_MTemplate_DR,DM_UseMethod_DR)values(:ItmDR,:MTRowid,:UMRowid)
	      where DM_RowID=:Rowid )
	
	i OperateCode="D" d
	.&sql(Delete from DHCRB_Memo where DM_RowID = :Rowid)
	
    q SQLCODE
}

/// 查询医嘱关联的注意事项模板(协和)
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryMemo") 
Query QueryMemo(Info As %String) As %Query(ROWSPEC = "Rowid:%String,ItmDesc:%String,TMDesc:%String,ItmRowid:%String,TMRowid:%String,UMRowid:%String,UseDesc:%String,BodyPartID:%String,BodyPart:%String")
{
}

ClassMethod QueryMemoExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
 
 s ind=1
 Set repid=$I(^CacheTemp)
 
 s OrdCatID=$p($g(Info),"^",1)
 s ItmCatID=$p($g(Info),"^",2)
 s ItmID=$p($g(Info),"^",3)
 s TemplateID=$p($g(Info),"^",4)
 s UMID=$p($g(Info),"^",5)
 s BodyPartID=$p($g(Info),"^",6)
 s Rowid="" f  s Rowid=$o(^DHCRBApp("Memo",Rowid),-1) q:(Rowid="")  d
 .s (ItmDesc,Subscript,Version,TMRowid,TMDesc,UseDesc,UMRowid)=""
 .s ItmRowid=$p($g(^DHCRBApp("Memo",Rowid)),"^",1)
 .q:(ItmRowid="" )
 .s ItmCatDR=$p($g(^ARCIM($p(ItmRowid,"||",1),$p(ItmRowid,"||",2),1)),"^",10)
 .q:(ItmCatDR="") 
 .s OrdCatDR=$p($g(^ARC("IC",ItmCatDR)),"^",8)
 .q:(OrdCatID'="")&(OrdCatID'=OrdCatDR)
 .q:(ItmCatID'="")&(ItmCatID'=ItmCatDR)
 .q:(ItmID'="")&(ItmID'=ItmRowid)
 .s Subscript=$p(ItmRowid,"||",1),Version=$p(ItmRowid,"||",2)
 .s ItmDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2)
 .s TMRowid=$p($g(^DHCRBApp("Memo",Rowid)),"^",4)
 .s UMRowid=$p($g(^DHCRBApp("Memo",Rowid)),"^",5)
 .q:(TemplateID'="")&(TemplateID'=TMRowid)
 .i TMRowid'="" d 
 ..s TMDesc=$p($g(^DHCRBCApp("Memo-Template",TMRowid)),"^",2)
 .q:(UMID'="")&(UMID'=UMRowid)  
 .i UMRowid'="" d
 ..s UseDesc=$p($g(^DHCRBCApp("USE-METHOD",UMRowid)),"^",2)
 .s BodyPartID=$p($g(^DHCRBApp("Memo",Rowid)),"^",6)
 .I BodyPartID'="" d
 ..s BodyPart=$p($g(^DHCAPPART(BodyPartID)),"^",2)
 
 .Do OutMemoNew
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutMemoNew
 set Data=$lb(Rowid,ItmDesc,TMDesc,ItmRowid,TMRowid,UMRowid,UseDesc,BodyPartID,BodyPart)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryMemoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMemoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryMemoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMemoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 使用分类方式查询

/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryUseMethod","^")
Query QueryUseMethod(Info As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod QueryUseMethodExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
 
 s ind=1
 Set repid=$I(^CacheTemp)
 
 s GetCode=$p($g(Info),"^",1)
 s GetDesc=$p($g(Info),"^",2)
 
 s Rowid="" f  s Rowid=$o(^DHCRBCApp("USE-METHOD",Rowid),-1) q:(Rowid="")  d
 .s (Code,Desc)=""
 .s Code=$p($g(^DHCRBCApp("USE-METHOD",Rowid)),"^",1)
 .q:(GetCode'="")&(GetCode'=Code)
 .s Desc=$p($g(^DHCRBCApp("USE-METHOD",Rowid)),"^",2) 
 .q:(GetDesc'="")&(GetDesc'=Desc) 
 .Do OutUseM
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutUseM
 set Data=$lb(Rowid,Code,Desc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryUseMethodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUseMethodExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryUseMethodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUseMethodExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SetUseFun(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid=$P($g(AllInfo),"^",1)
	s Code=$P($g(AllInfo),"^",2)
	s Desc=$P($g(AllInfo),"^",3)
	
	s UseCount=0
	
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_UseMethod(DUM_Code,DUM_Desc)values(:Code,:Desc))
	
	
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_UseMethod(DUM_Code,DUM_Desc)values(:Code,:Desc)
	      where DUM_RowId=:Rowid )
	
	
	i (OperateCode="D")
	{
	   &sql(select count(*) into :UseCount from DHCRB_Memo where DM_UseMethod_DR=:Rowid)
	   i (UseCount=0) 
	   {
	     &sql(Delete from DHCRBC_UseMethod where DUM_RowId =:Rowid)
	   }
       else
       {
	     s SQLCODE=-999
	   }
    }
	
    q SQLCODE
}

/// w ##class(web.DHCRisCodeTableSet).GetUseMethodList()
ClassMethod GetUseMethodList() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryUseMethod")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(3)_"-"_rset.GetData(1)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(3)_"-"_rset.GetData(1)
	}	
	d rset.Close()
	q ret
}

// 设置接收科室对应得 科室位置 预约位置 划价位置

// 解决多个院区 位置不同的问题

// sunyi 2012-08-22

/// do ##class(web.DHCRisCodeTableSet).SetLocationFun("^83^科室位置1^预约位置1^划价位置1","U")
ClassMethod SetLocationFun(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid=$P($g(AllInfo),"^",1)
	s LocDR=$P($g(AllInfo),"^",2)
	s RecLocDesc=$P($g(AllInfo),"^",3)
	s BookedDesc=$P($g(AllInfo),"^",4)
	s InputFeeDesc=$P($g(AllInfo),"^",5)
	
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_RecLoc_Location(DRL_RecLocDR)values(:LocDR))
	.s srowid=$p(%ROWID,$c(1))
	.i srowid'="" d
	.s $p(^DHCRBCLocation("LOCATION",srowid),"^",2)=RecLocDesc
	.s $p(^DHCRBCLocation("LOCATION",srowid),"^",3)=BookedDesc
	.s $p(^DHCRBCLocation("LOCATION",srowid),"^",4)=InputFeeDesc
	
	
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_RecLoc_Location(DRL_RecLocDR)values(:LocDR)
	      where DRL_RowID=:Rowid )
	.s srowid=$p(%ROWID,$c(1))
	.i srowid'="" d
	..s $p(^DHCRBCLocation("LOCATION",srowid),"^",2)=RecLocDesc
	..s $p(^DHCRBCLocation("LOCATION",srowid),"^",3)=BookedDesc
	..s $p(^DHCRBCLocation("LOCATION",srowid),"^",4)=InputFeeDesc      
	
	
	i (OperateCode="D")
	{
	     &sql(Delete from DHCRBC_RecLoc_Location where DRL_RowID =:Rowid)
    }
	
    q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryLocation","")
Query QueryLocation(Info As %String) As %Query(ROWSPEC = "TRowid:%String,TLocDR:%String,TRecLocDesc:%String,TBookedDesc:%String,TInputFeeDesc:%String,TLocDesc:%String")
{
}

ClassMethod QueryLocationExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
 
 s ind=1
 Set repid=$I(^CacheTemp)
 
 s GetLocDR=$p($g(Info),"^",1)
 
 s Rowid="" f  s Rowid=$o(^DHCRBCLocation("LOCATION",Rowid)) q:(Rowid="")  d
 .s (LocDR,RecLocDesc,BookedDesc,InputFeeDesc,LocDesc)=""
 .s LocDR=$p($g(^DHCRBCLocation("LOCATION",Rowid)),"^",1)
 .q:(GetLocDR'="")&(GetLocDR'=LocDR)
 .i LocDR'="" s LocDesc=$p($g(^CTLOC(LocDR)),"^",2)
 .s RecLocDesc=$p($g(^DHCRBCLocation("LOCATION",Rowid)),"^",2)
 .s BookedDesc=$p($g(^DHCRBCLocation("LOCATION",Rowid)),"^",3)
 .s InputFeeDesc=$p($g(^DHCRBCLocation("LOCATION",Rowid)),"^",4)
 .Do OutAddress
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutAddress
 set Data=$lb(Rowid,LocDR,RecLocDesc,BookedDesc,InputFeeDesc,LocDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryLocationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocationExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryLocationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocationExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetInfobyRowid(Rowid As %String, Index As %String)
{
	s Info=""
	s Info=$p($g(^DHCRBCLocation("LOCATION",Rowid)),"^",Index)
	s Info=..ChangeRportInfo(Info)
	q Info
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryStudyNoCreatRule")
Query QueryStudyNoCreatRule() As %Query(ROWSPEC = "Rowid:%String,EQGroupDesc:%String,Prefix:%String,MaxNumber:%String,LocDesc:%String,AppType:%String,SubCatDesc:%String,LocDR:%String,EQGroup:%String,SubCatDR:%String,OperationDR:%String,Operation:%String,MoreStudyNo:%String")
{
}

ClassMethod QueryStudyNoCreatRuleExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s Rowid=""
	f  s Rowid=$o(^DHCPACRegInfoCR("CreateRule",0,Rowid)) q:(Rowid="")  d
	.s LocDesc="",EQGroupDesc="",ArcItemCatDesc="",SubCatDR="",AppType=""
	.s MoreStudyNo=""
	.s OperationDR="",Operation=""
	.s EQGroup=$P(^DHCPACRegInfoCR("CreateRule",0,Rowid),"^",1)
	.i (EQGroup'="") d
	..i $g(^RBC("GRP",EQGroup))'="" s EQGroupDesc=$P(^RBC("GRP",EQGroup),"^",2)
	.s Prefix=$p(^DHCPACRegInfoCR("CreateRule",0,Rowid),"^",2)
	.s LocDR=$p(^DHCPACRegInfoCR("CreateRule",0,Rowid),"^",3)
	.s:LocDR'="" LocDesc=$P(^CTLOC(LocDR),"^",2)
	.s MaxNumber=$p(^DHCPACRegInfoCR("CreateRule",0,Rowid),"^",4)
	.s MoreStudyNo=$p(^DHCPACRegInfoCR("CreateRule",0,Rowid),"^",8)
	.s AppType=$p($g(^DHCPACRegInfoCR("CreateRule",0,Rowid)),"^",5)
	.i AppType="0" s AppType="应用于编号"
	.i AppType="1" s AppType="应用于检查号"
	.s SubCatDR=$p($g(^DHCPACRegInfoCR("CreateRule",0,Rowid)),"^",6)
	.i SubCatDR'="" d
	..;s ArcItemCatDesc=$p(^ARC("IC",SubCatDR),"^",2)  
	.s OperationDR=$p(^DHCPACRegInfoCR("CreateRule",0,Rowid),"^",7)
	.i OperationDR'="" s Operation=$p($g(^DHCRBCStatus("PatientStatus",OperationDR)),"^",2)
	.Do ExportStudyNoCreatRule
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportStudyNoCreatRule
	set Data=$lb(Rowid,$g(EQGroupDesc),Prefix,MaxNumber,$g(LocDesc),AppType,ArcItemCatDesc,LocDR,$g(EQGroup),$g(SubCatDR),$g(OperationDR),$g(Operation),$g(MoreStudyNo))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryStudyNoCreatRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStudyNoCreatRuleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryStudyNoCreatRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStudyNoCreatRuleExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SetStudyNoCreatRule(AllInfo As %String, OperateCode As %String) As %String
{
	//d ##class(web.DHCRisCodeTableSet).SetStudyNoCreatRule("1^7^N^T^86^1^3^206^","U")
	//RSC_Rowid,RSC_EQGroup_DR,RSC_PREFIX,RSC_MAXNUMBER,RSC_Loc_DR
	s Rowid="",EQGroup="",Prefix="",MaxNumber="",LocDR="",ApplyType=""
	s ^tts=AllInfo
	s Rowid = $P(AllInfo,"^",1)
	s EQGroup = $P(AllInfo,"^",2) 
	s Prefix = $P(AllInfo,"^",3)
	s MaxNumber=$p(AllInfo,"^",4)
	s LocDR=$p(AllInfo,"^",5)
	s ApplyType=$p(AllInfo,"^",6)
	s OptionsDR=$p(AllInfo,"^",7)
	s SubCatID=$p(AllInfo,"^",8)
	s MoreStudyNo=$p(AllInfo,"^",9)
	s SameCount=0
	i ((EQGroup'="")&(LocDR'="")) d
	.&sql(select count(*) into :SameCount from DHCRB_StudyNo_CreateRule
	       where RSC_EQGroup_DR=:EQGroup and RSC_Loc_DR=:LocDR) 
	       
	i ((SubCatID'="")&(LocDR'="")) d
	.&sql(select count(*) into :SameCount from DHCRB_StudyNo_CreateRule
	       where RSC_SUBORDERCAT_DR=:SubCatID and RSC_Loc_DR=:LocDR) 
	       
	i ((EQGroup="")&(LocDR'="")&(SubCatID="")) d
	.&sql(select count(*) into :SameCount from DHCRB_StudyNo_CreateRule
	       where RSC_Loc_DR=:LocDR) 
	       
	/*i (EQGroup="")&(LocDR'="") d
	.&sql(select count(*) into :SameCount from DHCRB_StudyNo_CreateRule
	       where RSC_EQGroup_DR is null and RSC_Loc_DR=:LocDR)
	
	i (EQGroup'="")&(LocDR="") d
	.&sql(select count(*) into :SameCount from DHCRB_StudyNo_CreateRule
	       where RSC_EQGroup_DR =:EQGroup and RSC_Loc_DR is null) */
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRB_StudyNo_CreateRule
	     (RSC_EQGroup_DR,RSC_PREFIX,RSC_MAXNUMBER,RSC_Loc_DR,RSC_AppType,RSC_Operation_DR, RSC_SUBORDERCAT_DR,RSC_MoreStudyNo) 
	     values(:EQGroup,:Prefix,:MaxNumber,:LocDR,:ApplyType,:OptionsDR,:SubCatID,:MoreStudyNo))
	i OperateCode="U" d    //;.i SameCount=1 d  ; 增加判断，合并by QZG 0407
	.&sql(UpDate DHCRB_StudyNo_CreateRule(RSC_EQGroup_DR,RSC_PREFIX,RSC_MAXNUMBER,RSC_Loc_DR,RSC_AppType,RSC_Operation_DR,RSC_SUBORDERCAT_DR,RSC_MoreStudyNo) 
	      values(:EQGroup,:Prefix,:MaxNumber,:LocDR,:ApplyType,:OptionsDR,:SubCatID,:MoreStudyNo)
	      where RSC_Rowid=:Rowid )
	
	i OperateCode="D" d
	.&sql(Delete from DHCRB_StudyNo_CreateRule where RSC_Rowid = :Rowid)
    q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QuerySystemPatientStatus")
Query QuerySystemPatientStatus() As %Query(ROWSPEC = "rowid:%String,code:%String,desc:%String")
{
}

ClassMethod QuerySystemPatientStatusExecute(ByRef qHandle As %Binary, USERDR As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s rowid=0 f  s rowid=$o(^DHCRBCStatus("PatientStatus",rowid)) q:(rowid="")  d
	.s code=$p(^DHCRBCStatus("PatientStatus",rowid),"^",1)
	.s desc=$p(^DHCRBCStatus("PatientStatus",rowid),"^",2)
	.i (code="I")!(code="B") d
	..Do OutSystmStatus 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSystmStatus
	set Data=$lb(rowid,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QuerySystemPatientStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySystemPatientStatusExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QuerySystemPatientStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySystemPatientStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// do ##class(web.DHCRisCodeTableSet).GetOptionsList()
ClassMethod GetOptionsList() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QuerySystemPatientStatus")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(3)_"-"_rset.GetData(1)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(3)_"-"_rset.GetData(1)
	}	
	d rset.Close()
	q ret
}

/// w ##class(web.DHCRisCodeTableSet).GetUseTypeList()
ClassMethod GetUseTypeList() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryUseMethod")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ((rset.GetData(2)="Z")!(rset.GetData(2)="L")!(rset.GetData(2)="R"))
		{
			i (ret="")
			{
				s ret=rset.GetData(1)_$C(1)_rset.GetData(3)_"-"_rset.GetData(1)
			}
		    else
		    {  
		       s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(3)_"-"_rset.GetData(1)
		    }
		}
	}	
	d rset.Close()
	q ret
}

// 插入流水号生成方式

ClassMethod SetUseData() As %String
{
	&sql(Insert into DHCRBC_UseMethod(DUM_Code,DUM_Desc)values('R','诊间流水号'))
	&sql(Insert into DHCRBC_UseMethod(DUM_Code,DUM_Desc)values('L','科室流水号'))
	&sql(Insert into DHCRBC_UseMethod(DUM_Code,DUM_Desc)values('Z','资源组流水号'))
	&sql(Insert into DHCRBC_UseMethod(DUM_Code,DUM_Desc)values('P','打印'))
	&sql(Insert into DHCRBC_UseMethod(DUM_Code,DUM_Desc)values('N','不打印'))
}

/// 插入预约方式(以下方法仅执行一次)
/// do ##class(web.DHCRisCodeTableSet).InsertBookType()
ClassMethod InsertBookType() As %String
{
	&sql(Insert into DHCRBC_AppointMethod(DRAM_Code,DRAM_Desc)values('1','无需预约'))
	&sql(Insert into DHCRBC_AppointMethod(DRAM_Code,DRAM_Desc)values('2','不需预约'))
	&sql(Insert into DHCRBC_AppointMethod(DRAM_Code,DRAM_Desc)values('3','自动预约'))
	&sql(Insert into DHCRBC_AppointMethod(DRAM_Code,DRAM_Desc)values('4','服务台预约'))
	&sql(Insert into DHCRBC_AppointMethod(DRAM_Code,DRAM_Desc)values('5','科室内预约'))
	&sql(Insert into DHCRBC_AppointMethod(DRAM_Code,DRAM_Desc)values('6','专科预约'))
	&sql(Insert into DHCRBC_AppointMethod(DRAM_Code,DRAM_Desc)values('7','会诊预约'))
	&sql(Insert into DHCRBC_AppointMethod(DRAM_Code,DRAM_Desc)values('8','外部预约'))
	&sql(Insert into DHCRBC_AppointMethod(DRAM_Code,DRAM_Desc)values('9','转诊预约'))
}

/// 设置检查号生成规则数据
/// sunyi 2013-04-16
/// 修改日期:2015-01-06
/// do ##calss(web.DHCRisCodeTableSet).SetNumberCreateRule("^83^7^0^3","I")
ClassMethod SetNumberCreateRule(AllInfo As %String, OperateCode As %String) As %String
{
	//d ##class(web.DHCRisSystemParam).SetNumberCreateRule("","I")
	s Rowid="",LocDR="",NoRuleDR="",AppDateType="",OpertionDR="",IsSaveNo=""
	s Rowid = $P(AllInfo,"^",1)
	s LocDR = $P(AllInfo,"^",2) 
	s NoRuleDR = $P(AllInfo,"^",3)
	s AppDateType=$p(AllInfo,"^",4)
	s OpertionDR=$p(AllInfo,"^",5)
	s IsSaveNo=$p(AllInfo,"^",6)
	
	s SameCount=0
	i (LocDR'="") d
	.&sql(select count(*) into :SameCount from DHCRB_Number_CreateRule
	       where DNC_RecLoc_DR=:LocDR)
	      
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRB_Number_CreateRule
	     (DNC_RecLoc_DR,DNC_UseMethod_DR,DNC_AppType,DNC_Operation_DR,DNC_SaveIndex) 
	     values(:LocDR,:NoRuleDR,:AppDateType,:OpertionDR,:IsSaveNo))
	i OperateCode="U" d
	.i SameCount=1 d  ; 增加判断，合并by QZG 0407
	..&sql(UpDate DHCRB_Number_CreateRule(DNC_RecLoc_DR,DNC_UseMethod_DR,DNC_AppType,DNC_Operation_DR,DNC_SaveIndex)  
	      values(:LocDR,:NoRuleDR,:AppDateType,:OpertionDR,:IsSaveNo)
	      where DNC_Rowid=:Rowid )
	i OperateCode="D" d
	.&sql(Delete from DHCRB_Number_CreateRule where DNC_Rowid = :Rowid)
    q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryNumberCreatRule")
/// 修改日期:2015-01-06 
/// 修改人:sunyi
Query QueryNumberCreatRule() As %Query(ROWSPEC = "Rowid:%String,LocDesc:%String,NoRuleDesc:%String,AppDateType:%String,Opertion:%String,LocDR:%String,NoRuleDR:%String,OperationDR:%String,IsSaveNo:%String")
{
}

ClassMethod QueryNumberCreatRuleExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s Rowid=""
	f  s Rowid=$o(^DHCRBSerialNumber("SerialCreateRule",Rowid)) q:(Rowid="")  d
	.s LocDesc="",NoRuleDesc="",AppDateType="",Opertion="",OpertionDR="",LocDR="",IsSaveNo=""
	.s LocDR=$p($g(^DHCRBSerialNumber("SerialCreateRule",Rowid)),"^",1)
	.s NoRuleDR=$p($g(^DHCRBSerialNumber("SerialCreateRule",Rowid)),"^",2)
	.s AppDateType=$p($g(^DHCRBSerialNumber("SerialCreateRule",Rowid)),"^",3)
	.s OpertionDR=$p($g(^DHCRBSerialNumber("SerialCreateRule",Rowid)),"^",4)
	.i LocDR'=""  s LocDesc=$P(^CTLOC(LocDR),"^",2)
	.i NoRuleDR'="" s NoRuleDesc=$p($g(^DHCRBCApp("USE-METHOD",NoRuleDR)),"^",2) 
	.i OpertionDR'="" s Opertion=$p($g(^DHCRBCStatus("PatientStatus",OpertionDR)),"^",2)
	.i AppDateType="0" s AppDateType="天"
	.i AppDateType="1" s AppDateType="时间段"
	.s IsSaveNo=$p($g(^DHCRBSerialNumber("SerialCreateRule",Rowid)),"^",5)
	.i IsSaveNo="" s IsSaveNo="N"
	.Do ExportNumberCreatRule
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportNumberCreatRule
	set Data=$lb(Rowid,$g(LocDesc),NoRuleDesc,AppDateType,$g(Opertion),$g(LocDR),$g(NoRuleDR),$g(OpertionDR),$g(IsSaveNo))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryNumberCreatRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNumberCreatRuleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryNumberCreatRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNumberCreatRuleExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 插入流水号类型表

/// do ##class(web.DHCRisCodeTableSet).InsertIndexType()
ClassMethod InsertIndexType() As %String
{
	&sql(Insert into DHCRBC_IndexType(DIT_Code,DIT_Desc)values('LD','科室号(天)'))
	&sql(Insert into DHCRBC_IndexType(DIT_Code,DIT_Desc)values('ZD','资源组号(天)'))
	&sql(Insert into DHCRBC_IndexType(DIT_Code,DIT_Desc)values('RD','诊室号(天)'))
	&sql(Insert into DHCRBC_IndexType(DIT_Code,DIT_Desc)values('LT','科室号(时间段)'))
	&sql(Insert into DHCRBC_IndexType(DIT_Code,DIT_Desc)values('ZT','资源组号(时间段)'))
	&sql(Insert into DHCRBC_IndexType(DIT_Code,DIT_Desc)values('RT','诊室号(时间段)'))
}

/// @param: {%String} name 
/// @param: {%String} codes 
/// @param: {%String} descs  如果为空刚默认为值等于codes
/// @param: {%String} selectedValue 当前选中的元素的值
/// @param: {%String} defaultValue 默认选中的值
/// @param: {%Int} size select的长度
/// d ##class(web.DHCRisCodeTableSet).CoustomSelect("token",",SELECT,UPDATE,INSERT","",$g(%request.Data("token",1)),"",1)
/// d ##class(web.DHCTTSqlLog).CoustomSelect("token",",SELECT,UPDATE,INSERT","",$g(%request.Data("token",1)),"",1)
/// d ##class(web.DHCTTSqlLog).CoustomSelect("Type",",SELECT,UPDATE,INSERT","全部,查询,更新,插入",$g(%request.Data("Type",1)),"",1)
ClassMethod CoustomSelect(name, codes, descs, selectedValue As %String = "", defaultValue As %String = "", size As %String = 1)
{
	q:name="" -1
	q:codes="" -1
	i selectedValue="" s selectedValue=defaultValue
	if descs="" s descs=codes
	w "<select id='"_name_"' name='"_name_"' size='"_size_"'>"
	set len = $l(codes,",")
	f j=1:1:len {
		set code = $p(codes,",",j), desc = $p(descs,",",j)
		w "<option value='"_code_"' "_$s(selectedValue=code:"selected" ,1:"")_">"_desc_"</option>"
	}
	w "</select>"
	q 0
}

/// 增加病人同接收科室多条医嘱一起登记,是否产生多个检查号配置项.
/// sunyi 2013-07-17
/// w ##class(web.DHCRisCodeTableSet).IsCreateMoreStudyNo("83","20017||3881","超声")
ClassMethod IsCreateMoreStudyNo(LocDr As %String, orditmrowid As %String, EQGoup As %String) As %String
{
	s IsMoreStudyNo="N"
	q:(orditmrowid'["||") "N"
	
	s orditmrowid=$p(orditmrowid,"@",1)
	
    q:orditmrowid="" IsMoreStudyNo
	s EQGoupDr=##class(web.DHCRisCommFunction).GetEQGroupDR(LocDr,EQGoup)
	s rowid="",AppType="",ItmCatRowid=""
	s ItmCatRowid=##class(web.DHCRisCodeTableAdd).GetItmCatDR(orditmrowid)
	s rowid="" 
	
    i EQGoupDr'="" d 
	.s rowid=$o(^DHCPACRegInfoCRi("LocEQGroupRule",LocDr,EQGoupDr,rowid))
	.i rowid'="" s IsMoreStudyNo=$p(^DHCPACRegInfoCR("CreateRule",0,rowid),"^",8)
	i ((ItmCatRowid'="")&(rowid="")) d
	.s rowid=$o(^DHCPACRegInfoCRi("SubOrderCat",ItmCatRowid,rowid))
	.i rowid'="" s IsMoreStudyNo=$p(^DHCPACRegInfoCR("CreateRule",0,rowid),"^",8)
	
    if rowid="" d
	.s rowid=$o(^DHCPACRegInfoCRi("LocCreateNo",0,LocDr,rowid))
	.i rowid'="" s IsMoreStudyNo=$p(^DHCPACRegInfoCR("CreateRule",0,rowid),"^",8)
	
	q IsMoreStudyNo
}

/// ---------------------------------------同仁眼科预约函数------------------------------------
/// 按病人类型设置医嘱项目的预约类型
/// sunyi 2014-04-06
/// W ##class(web.DHCRisCodeTableSet).ItemPatTypeSet("^8866||1^I^4","I")
ClassMethod ItemPatTypeSet(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid="",ARCItmMastDR="",PatTypeCode="",AppointMethodDR=""
	
	s Rowid = $P(AllInfo,"^",1)
	s ARCItmMastDR = $P(AllInfo,"^",2) 
	s PatTypeCode = $P(AllInfo,"^",3)
	s AppointMethodDR=$p(AllInfo,"^",4)
	
	s SameCount=0
	i ((ARCItmMastDR'="")&(PatTypeCode'="")) d
	.&sql(select count(*) into :SameCount from DHCRBC_ItemPatTypeSet
	       where DIPTS_ArcItmMast_DR=:ARCItmMastDR and DIPTS_PatientType_Code=:PatTypeCode) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_ItemPatTypeSet
	     (DIPTS_ArcItmMast_DR,DIPTS_PatientType_Code,DIPTS_AppointMethod_DR) values(:ARCItmMastDR,:PatTypeCode,:AppointMethodDR))
	     
	i OperateCode="U" d 
	.&sql(UpDate DHCRBC_ItemPatTypeSet(DIPTS_ArcItmMast_DR,DIPTS_PatientType_Code,DIPTS_AppointMethod_DR) 
	      values(:ARCItmMastDR,:PatTypeCode,:AppointMethodDR)
	      where DIPTS_RowID=:Rowid )
	
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_ItemPatTypeSet where DIPTS_RowID = :Rowid)
    q SQLCODE
}

/// 根据病人类型与医嘱项目设置查询医嘱对应的预约方式
/// sunyi 2014-04-06
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryItemBookType","")
Query QueryItemBookType(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,OrderName:%String,PatDesc:%String,AppMethod:%String,ArcItmRowid:%String,PatCode:%String,AppMethodTypeDR:%String")
{
}

ClassMethod QueryItemBookTypeExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
    s GetArcItmRowid=$p($g(Info),"^",1)
    s GetPatCode=$p($g(Info),"^",2)
    s GetAppointMethodDR=$p($g(Info),"^",3)
    
	s Rowid="",ArcItmRowid="",PatCode="", AppMethodTypeDR=""
	
	f  s Rowid=$o(^DHCRBCItemPatTypeSet("ItemPatTypeSet",Rowid)) q:(Rowid="")  d
    .s ArcItmRowid="",PatCode="", AppMethodTypeDR=""
    .s OrderName="",PatDesc="", AppMethod=""
	.s ArcItmRowid=$p($g(^DHCRBCItemPatTypeSet("ItemPatTypeSet",Rowid)),"^",1)
	.q:(GetArcItmRowid'="")&(GetArcItmRowid'=ArcItmRowid)
	.i ArcItmRowid'="" d
	..s OrderName=$p(^ARCIM($p(ArcItmRowid,"||",1),$p(ArcItmRowid,"||",2),1),"^",2)
	.s PatCode=$p($g(^DHCRBCItemPatTypeSet("ItemPatTypeSet",Rowid)),"^",2)
	.q:(GetPatCode'="")&(GetPatCode'=PatCode)
	.i PatCode'="" d
	..s PatDesc=##class(web.DHCRisCommFunction).GetTypeDesc(PatCode)
	.s AppMethodTypeDR=$p($g(^DHCRBCItemPatTypeSet("ItemPatTypeSet",Rowid)),"^",3)
	.q:(GetAppointMethodDR'="")&(GetAppointMethodDR'=AppMethodTypeDR)
	.i AppMethodTypeDR'="" d
	..s AppMethod=$p($g(^DHCRBCAppointMethod(AppMethodTypeDR)),"^",2)
	.Do ExportItemBookType
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportItemBookType
	set Data=$lb(Rowid,$g(OrderName),$g(PatDesc),$g(AppMethod),ArcItmRowid,PatCode,AppMethodTypeDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryItemBookTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemBookTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryItemBookTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemBookTypeExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 登陆科室资源设置
/// sunyi 2014-04-06
ClassMethod LoginLocResourceSet(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid="",HospitalDR="",AppLocDR="",ResourceDR="",RecLocDR=""
	
	s Rowid = $P(AllInfo,"^",1)
	s HospitalDR = $P(AllInfo,"^",2) 
	s AppLocDR = $P(AllInfo,"^",3)
	s ResourceDR=$p(AllInfo,"^",4)
	s RecLocDR=$p(AllInfo,"^",5)
	
	s SameCount=0
	i ((AppLocDR'="")&(ResourceDR'="")&(RecLocDR'="")) d
	.&sql(select count(*) into :SameCount from DHCRBC_LocResourceSet
	       where DLRS_AppLoc_DR=:AppLocDR and DLRS_RecLoc_DR=:RecLocDR and DLRS_Resource_DR=:ResourceDR) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_LocResourceSet
	     (DLRS_AppLoc_DR,DLRS_Resource_DR,DLRS_Hospital_DR,DLRS_RecLoc_DR) values(:AppLocDR,:ResourceDR,:HospitalDR,:RecLocDR))
	     
	i OperateCode="U" d 
	.&sql(UpDate DHCRBC_LocResourceSet(DLRS_AppLoc_DR,DLRS_Resource_DR,DLRS_Hospital_DR,DLRS_RecLoc_DR) 
	      values(:AppLocDR,:ResourceDR,:HospitalDR,:RecLocDR)
	      where DLRS_RowID=:Rowid )
	
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_LocResourceSet where DLRS_RowID =:Rowid)
    q SQLCODE
}

/// 查询登陆科室资源设置
/// /sunyi 2014-04-06
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryLocResource","")
Query QueryLocResource(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,Hospital:%String,AppLocDesc:%String,ResourceDesc:%String,RecLocDesc:%String,HospitalDR:%String,AppLocDR:%String,ResourceDR:%String,RecLocDR:%String")
{
}

ClassMethod QueryLocResourceExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
    s GetHospitalDR=$p($g(Info),"^",1)
    s GetAppLocDR=$p($g(Info),"^",2)
    s GetResourceDR=$p($g(Info),"^",3)
    s GetRecLocDR=$p($g(Info),"^",4)
    
	s Rowid=""
	
	f  s Rowid=$o(^DHCRBCLocResourceSet("LoginLocRes",Rowid) ) q:(Rowid="")  d
    .s HospitalDR="",AppLocDR="",ResourceDR="",RecLocDR=""
    .s hospital="",AppLocDesc="", ResourceDesc="",RecLocDesc=""
	.s AppLocDR=$p($g(^DHCRBCLocResourceSet("LoginLocRes",Rowid)),"^",1)
	.s ResourceDR=$p($g(^DHCRBCLocResourceSet("LoginLocRes",Rowid)),"^",2)
	.s HospitalDR=$p($g(^DHCRBCLocResourceSet("LoginLocRes",Rowid)),"^",3)
	.s RecLocDR=$p($g(^DHCRBCLocResourceSet("LoginLocRes",Rowid)),"^",4)
	.q:(GetHospitalDR'="")&(GetHospitalDR'=HospitalDR)
	.q:(GetAppLocDR'="")&(GetAppLocDR'=AppLocDR)
	.q:(GetResourceDR'="")&(GetResourceDR'=ResourceDR)
	.q:(GetRecLocDR'="")&(GetRecLocDR'=RecLocDR)
	.i HospitalDR'="" s hospital=$p($g(^CT("HOSP",HospitalDR)),"^",2)
	.i AppLocDR'="" s AppLocDesc=$p($g(^CTLOC(AppLocDR)),"^",2)
	.i ResourceDR'="" s ResourceDesc=$p($g(^RB("RES",ResourceDR)),"^",17) 
	.i RecLocDR'="" s RecLocDesc=$p($g(^CTLOC(RecLocDR)),"^",2)
	.Do ExportLocResource
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportLocResource
	set Data=$lb(Rowid,$g(hospital),$g(AppLocDesc),$g(ResourceDesc),$g(RecLocDesc),$g(HospitalDR),$g(AppLocDR),$g(ResourceDR),$g(RecLocDR))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryLocResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocResourceExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryLocResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocResourceExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 根据接收科室ID查询可是可用的设备
/// 此处设备ID将转为资源ID
/// sunyi-2014-04-14
Query QueryResourcebyLoc(LocDR As %String) As %Query(ROWSPEC = "RBRowid:%String,EQcode:%String,EQdesc:%String")
{
}

ClassMethod QueryResourcebyLocExecute(ByRef qHandle As %Binary, LocDR As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryResourcebyLoc","83") 
 s ind=1
 Set repid=$I(^CacheTemp)
  
 s Rowid="0" f  s Rowid=$O(^RBC("EQ",Rowid)) q:(Rowid="")  d
 .s RBRowid="" f  s RBRowid=$o(^RB("RES",0,"EQ",Rowid,LocDR,RBRowid)) q:(RBRowid="")  d 
 ..s Code=$p(^RBC("EQ",Rowid),"^",1)
 ..S Desc=$p(^RBC("EQ",Rowid),"^",2)
 ..Do OutResource
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutResource
 set Data=$lb(RBRowid,Code,Desc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryResourcebyLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResourcebyLocExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryResourcebyLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResourcebyLocExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query QueryHospital() As %Query(ROWSPEC = "RBRowid:%String,EQcode:%String,EQdesc:%String")
{
}

ClassMethod QueryHospitalExecute(ByRef qHandle As %Binary) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryHospital") 
 s ind=1
 Set repid=$I(^CacheTemp)
  
 s Rowid="0" f  s Rowid=$O(^CT("HOSP",Rowid)) q:(Rowid="")  d
 .s Code=$p(^CT("HOSP",Rowid),"^",1)
 .S Desc=$p(^CT("HOSP",Rowid),"^",2)
 .Do OutHospital
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutHospital
 set Data=$lb(Rowid,Code,Desc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHospitalExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHospitalExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCRisCodeTableSet).GetadmTypeList()
ClassMethod GetadmTypeList() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCommFunction:QueryPadmType")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{

		i (ret="")
		{
			s ret=rset.GetData(2)_$C(1)_rset.GetData(1)_"-"_rset.GetData(2)
		}
	    else
	    {  
	       s ret=ret_"^"_rset.GetData(2)_$C(1)_rset.GetData(1)_"-"_rset.GetData(2)
	    }
	
	}	
	d rset.Close()
	q ret
}

/// w ##class(web.DHCRisCodeTableSet).GetAppointMethod()
ClassMethod GetAppointMethodList() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisBookParam:QueryBookMethod")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{

		i (ret="")
		{
			s ret=rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(1)
		}
	    else
	    {  
	       s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(1)
	    }
	
	}	
	d rset.Close()
	q ret
}

/// w ##class(web.DHCRisCodeTableSet).GetResourceList("83")
ClassMethod GetResourceList(LocDR As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryResourcebyLoc")
	s ret=""
	do rset.Execute(LocDR)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(3)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(3)
	}	
	d rset.Close()
	q ret
}

/// w ##class(web.DHCRisCodeTableSet).GetHospitalList()
ClassMethod GetHospitalList() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryHospital")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(3)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(3)
	}	
	d rset.Close()
	q ret
}

/// ---------------------------------同仁增加配置---------------------------------
/// 医嘱项目分组与科室设置
/// w ##class(web.DHCRisCodeTableSet).ItemGroupLocSet("^超声^BC^83","I")
ClassMethod ItemGroupLocSet(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid="",Desc="",Code="",LocDR=""
	
	s Rowid =$P(AllInfo,"^",1)
	s Desc = $P(AllInfo,"^",2) 
	s Code = $P(AllInfo,"^",3)
	s LocDR=$p(AllInfo,"^",4)
	
	s SameCount=0
	i (Desc'="")&(Code'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_ItemGroupLocSet
	       where DIGS_Code=:Code and DIGS_Desc=:Desc) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_ItemGroupLocSet
	     (DIGS_Code,DIGS_Desc,DIGS_RecLoc_DR) values(:Code,:Desc,:LocDR))
	     
	i OperateCode="U" d 
	.&sql(UpDate DHCRBC_ItemGroupLocSet(DIGS_Code,DIGS_Desc,DIGS_RecLoc_DR) 
	      values(:Code,:Desc,:LocDR)where DIGS_RowID=:Rowid )
	
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_ItemGroupLocSet where DIGS_RowID = :Rowid)
    q SQLCODE
}

/// 查询医嘱项目分组与科室设置
/// sunyi 2014-04-06
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryItemGroupLoc","")
Query QueryItemGroupLoc(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String,AppLoc:%String,AppLocDR:%String")
{
}

ClassMethod QueryItemGroupLocExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
    s InDesc=$p($g(Info),"^",1)
    s InCode=$p($g(Info),"^",2)
    s InLocDR=$p($g(Info),"^",3)
    
	s (Rowid,Desc,Code,AppLoc,AppLocDR)=""
	
	f  s Rowid=$o(^DHCRBCItemGroupLocSet("ItmGroup-Loc",Rowid)) q:(Rowid="")  d
    .s (Desc,Code,AppLoc,AppLocDR)=""
	.s Desc=$p($g(^DHCRBCItemGroupLocSet("ItmGroup-Loc",Rowid)),"^",2)
	.q:(InDesc'="")&(InDesc'=Desc)
	.s Code=$p($g(^DHCRBCItemGroupLocSet("ItmGroup-Loc",Rowid)),"^",1)
	.q:(InCode'="")&(InCode'=Code)
	.s AppLocDR=$p($g(^DHCRBCItemGroupLocSet("ItmGroup-Loc",Rowid)),"^",3)
	.q:(InLocDR'="")&(InLocDR'=AppLocDR)
	.i AppLocDR'="" d
	..s AppLoc=$p($g(^CTLOC(AppLocDR)),"^",2)
	.Do ExportItemGroupLoc
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportItemGroupLoc
	set Data=$lb(Rowid,Desc,Code,AppLoc,AppLocDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryItemGroupLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemGroupLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryItemGroupLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemGroupLocExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 医嘱分组与医嘱项设置(停用)
/// w ##class(web.DHCRisCodeTableSet).GroupArcItmMastSet("^1^8866||1","I")
ClassMethod GroupArcItmMastSet(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid="",ItmGroupDR="",ArcItmMastDR=""
	
	s Rowid=$P(AllInfo,"^",1)
	s ItmGroupDR =$P(AllInfo,"^",2) 
	s ArcItmMastDR =$P(AllInfo,"^",3)

	
	s SameCount=0
	i (ItmGroupDR'="")&(ArcItmMastDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_GroupArcItmMast
	       where DGA_ArcItmMast_DR=:ArcItmMastDR and DGA_ItemGroup_DR=:ItmGroupDR) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_GroupArcItmMast
	     (DGA_ArcItmMast_DR,DGA_ItemGroup_DR) values(:ArcItmMastDR,:ItmGroupDR))
	     
	i OperateCode="U" d 
	.&sql(UpDate DHCRBC_GroupArcItmMast(DGA_ArcItmMast_DR,DGA_ItemGroup_DR) 
	      values(:ArcItmMastDR,:ItmGroupDR)where DGA_RowID=:Rowid )
	
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_GroupArcItmMast where DGA_RowID = :Rowid)
    q SQLCODE
}

/// 查询分组与对应的医嘱项目(停用)
/// sunyi 2014-04-06
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryGroupArcItmMast","")
Query QueryGroupArcItmMast(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,AppLoc:%String,ItemGroup:%String,ArcItmMast:%String,ItmGroupDR:%String,ArcItmDR:%String,AppLocDR:%String")
{
}

ClassMethod QueryGroupArcItmMastExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s InLocDR=$p($g(Info),"^",1)
    s InItmGroupDR=$p($g(Info),"^",2)
    s InArcItmMastDR=$p($g(Info),"^",3)
   
    
	s (Rowid,ItemGroup,ArcItmMast,ItmGroupDR,ArcItmDR,AppLoc,AppLocDR)=""
	
	f  s Rowid=$o(^DHCRBCGroupArcItmMast(Rowid)) q:(Rowid="")  d
    .s (ItemGroup,ArcItmMast,ItmGroupDR,ArcItmDR)=""
	.s ItmGroupDR=$p($g(^DHCRBCGroupArcItmMast(Rowid)),"^",1)
	.q:(InItmGroupDR'="")&(InItmGroupDR'=ItmGroupDR)
	.s AppLocDR=$p($g(^DHCRBCItemGroupLocSet("ItmGroup-Loc",ItmGroupDR)),"^",3)
	.q:((InLocDR'="")&(InLocDR'=AppLocDR))
	.i AppLocDR'=""  s AppLoc=$p($g(^CTLOC(AppLocDR)),"^",2)
	.s ArcItmDR=$p($g(^DHCRBCGroupArcItmMast(Rowid)),"^",2)
	.q:(InArcItmMastDR'="")&(InArcItmMastDR'=ArcItmDR)
	.i ItmGroupDR'="" s ItemGroup=$p($g(^DHCRBCItemGroupLocSet("ItmGroup-Loc",ItmGroupDR)),"^",2)
	.i ArcItmDR'="" s ArcItmMast=$p(^ARCIM($p(ArcItmDR,"||",1),$p(ArcItmDR,"||",2),1),"^",2)
	.Do ExportGroupArcItmMast
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportGroupArcItmMast
	set Data=$lb(Rowid,AppLoc,ItemGroup,ArcItmMast,ItmGroupDR,ArcItmDR,AppLocDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryGroupArcItmMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGroupArcItmMastExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryGroupArcItmMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGroupArcItmMastExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 医护人员关注医嘱项目设置
/// w ##class(web.DHCRisCodeTableSet).UserAttentionSet("^687^8866||1^83","I")
ClassMethod UserAttentionSet(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid="",UserDR="",ArcItmid="",AppLocDR=""
	
	s Rowid =$P(AllInfo,"^",1)
	s UserDR = $P(AllInfo,"^",2) 
	s ArcItmid = $P(AllInfo,"^",3)
	s AppLocDR=$p(AllInfo,"^",4)
	
	s SameCount=0
	i (UserDR'="")&(ArcItmid'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_UserAttentionSet
	       where DUAS_User_DR=:UserDR and DUAS_ArcItmMast_DR=:ArcItmid) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_UserAttentionSet
	     (DUAS_User_DR,DUAS_ArcItmMast_DR,DUAS_AppLoc_DR) values(:UserDR,:ArcItmid,:AppLocDR))
	     
	i OperateCode="U" d 
	.&sql(UpDate DHCRBC_UserAttentionSet(DUAS_User_DR,DUAS_ArcItmMast_DR,DUAS_AppLoc_DR) 
	      values(:UserDR,:ArcItmid,:AppLocDR)where DUAS_RowID=:Rowid )
	
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_UserAttentionSet where DUAS_RowID = :Rowid)
    q SQLCODE
}

/// 医护人员关注医嘱项目设置
/// sunyi 2014-04-06
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryUserAttention","687^")
Query QueryUserAttention(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,OrdName:%String,ArcItmID:%String")
{
}

ClassMethod QueryUserAttentionExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
    s InUserID=$p($g(Info),"^",1)
    s InArcItmID=$p($g(Info),"^",2)
    i InUserID="" s InUserID=%session.Get("LOGON.USERID")
	s (Rowid,UserID,ArcItmID,User,OrdName)=""
	
	f  s Rowid=$o(^DHCRBCUserAttentionSeti("USER",InUserID,Rowid)) q:(Rowid="")  d
    .s (UserID,ArcItmID,User,OrdName)=""
	.s ArcItmID=$p($g(^DHCRBCUserAttentionSet(Rowid)),"^",2)
	.q:((InArcItmID'="")&(InArcItmID'=ArcItmID))
	.i ArcItmID'="" s OrdName=$p(^ARCIM($p(ArcItmID,"||",1),$p(ArcItmID,"||",2),1),"^",2)
	.Do ExportUserAttention
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportUserAttention
	set Data=$lb(Rowid,OrdName,ArcItmID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryUserAttentionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserAttentionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryUserAttentionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserAttentionExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 医嘱项目服务组可用设备设置
/// w ##class(web.DHCRisCodeTableSet).SerAvailableResSet("^4^1383","I")
ClassMethod SerAvailableResSet(AllInfo As %String, OperateCode As %String) As %String
{
	/*s Rowid=""
	
	s Rowid =$P($g(AllInfo),"^",1) 
	s ArcItmID= $P($g(AllInfo),"^",2)
	s SerGroupID = $P($g(AllInfo),"^",3)
	s ResourceID=$p($g(AllInfo),"^",4)
	s StartDate=$p($g(AllInfo),"^",5)
	s EndDate=$p($g(AllInfo),"^",6)
	       
	i OperateCode="I" d
	.&sql(Insert into DHCRBC_SerAvailableRes
	     (DSAR_ServiceGroup_DR,DSAR_ArcItmMast_DR,DSAR_Resource_DR,DSAR_StartDate,DSAR_EndDate) 
	      values(:SerGroupID,:ArcItmID,:ResourceID,:StartDate,:EndDate))
	     
	i OperateCode="U" d 
	.&sql(UpDate DHCRBC_SerAvailableRes(DSAR_ServiceGroup_DR,DSAR_ArcItmMast_DR,DSAR_Resource_DR,DSAR_StartDate,DSAR_EndDate) 
	      values(:SerGroupID,:ArcItmID,:ResourceID,:StartDate,:EndDate)where DSAR_RowID=:Rowid )
	
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_SerAvailableRes where DSAR_RowID = :Rowid)
    q SQLCODE*/
    
    s Rowid =$P($g(AllInfo),"^",1) 
	s SerGroupID = $P($g(AllInfo),"^",2)
	s ResourceID=$p($g(AllInfo),"^",3)
	
	s SameCount=0
	i (SerGroupID'="")&(ResourceID'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_SerAvailableRes
	       where DSAR_ServiceGroup_DR=:SerGroupID and DSAR_Resource_DR=:ResourceID) 
	
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_SerAvailableRes
	     (DSAR_ServiceGroup_DR,DSAR_Resource_DR) values(:SerGroupID,:ResourceID))
	     
	i OperateCode="U" d 
	.&sql(UpDate DHCRBC_SerAvailableRes(DSAR_ServiceGroup_DR,DSAR_Resource_DR) 
	      values(:SerGroupID,:ResourceID)where DSAR_RowID=:Rowid )
	
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_SerAvailableRes where DSAR_RowID = :Rowid)
    q SQLCODE
}

/// 查询医嘱项目服务组可用设备设置
/// sunyi 2014-04-06
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryAvailableRes","4")
Query QueryAvailableRes(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,SerDesc:%String,Res:%String,SerGroupID:%String,ResID:%String,SDate:%String,EDate:%String")
{
}

ClassMethod QueryAvailableResExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
    s InSerGroupID=$p($g(Info),"^",1)
   
	s (Rowid,SerGroupID,ArcItmID,ResID,ArcItmID,SDate,EDate)=""
	s (OrdName,SerDesc,Res,EQDR)=""
	
	f  s Rowid=$o(^DHCRBCSerAvailableRes(Rowid)) q:(Rowid="")  d
    .s (OrdName,SerDesc,Res,SerGroupID,ArcItmID,ResID,ArcItmID,SDate,EDate,EQDR)=""
	.;s ArcItmID=$p($g(^DHCRBCSerAvailableRes(Rowid)),"^",5)
	.;q:((InArcItmID'="")&(InArcItmID'=ArcItmID))
	.;i ArcItmID'="" s OrdName=$p(^ARCIM($p(ArcItmID,"||",1),$p(ArcItmID,"||",2),1),"^",2)
	.s SerGroupID=$p($g(^DHCRBCSerAvailableRes(Rowid)),"^",1)
	.q:((InSerGroupID'="")&(InSerGroupID'=SerGroupID))
	.s ResID=$p($g(^DHCRBCSerAvailableRes(Rowid)),"^",2)
	.s SDate=$p($g(^DHCRBCSerAvailableRes(Rowid)),"^",3)
	.s EDate=$p($g(^DHCRBCSerAvailableRes(Rowid)),"^",4)
	.i SerGroupID'="" s SerDesc=$p($g(^RBC("SG",SerGroupID)),"^",2)
	.i ResID'="" s EQDR=$p($g(^RB("RES",ResID)),"^",3)
	.i EQDR'=""  s Res=$p($g(^RBC("EQ",EQDR)),"^",2)
	.i SDate'="" s SDate=$zd(SDate,"3")
	.i EDate'="" s EDate=$zd(EDate,"3")
	.Do ExportAvailableRes
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportAvailableRes
	//set Data=$lb(Rowid,OrdName,SerDesc,Res,ArcItmID,SerGroupID,ResID,SDate,EDate)
	set Data=$lb(Rowid,SerDesc,Res,SerGroupID,ResID,SDate,EDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryAvailableResFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAvailableResExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryAvailableResClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAvailableResExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCRisCodeTableSet).GetAvailableResList("4")
/// 查找服务组下的设备
ClassMethod GetResList(SerGroupDR As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryResbySerGroup")
	s ret=""
	
	do rset.Execute(SerGroupDR)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// w ##class(web.DHCRisCodeTableSet).GetItmGroupList("83")
ClassMethod GetItmGroupList(LocDR As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryItmGroupbyLoc")
	s ret=""
	
	do rset.Execute(LocDR)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// 根据科室ID查询项目分组
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryItmGroupbyLoc","83")
Query QueryItmGroupbyLoc(LocDR As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod QueryItmGroupbyLocExecute(ByRef qHandle As %Binary, LocDR As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
   
    i (LocDR="")
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	s (Rowid,Desc,Code)=""
	f  s Rowid=$o(^DHCRBCItemGroupLocSeti("AppLoc",LocDR,Rowid)) q:(Rowid="")  d
    .s (Desc,Code)=""
	.s Desc=$p($g(^DHCRBCItemGroupLocSet("ItmGroup-Loc",Rowid)),"^",2)
	.s Code=$p($g(^DHCRBCItemGroupLocSet("ItmGroup-Loc",Rowid)),"^",1)
	.Do Export
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Export
	set Data=$lb(Rowid,Desc,Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryItmGroupbyLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItmGroupbyLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryItmGroupbyLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItmGroupbyLocExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询分组下的医嘱项目
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryItembyGroupID","1","20019")
Query QueryItembyGroupID(Groupdr As %String, paadmdr As %String) As %Query(ROWSPEC = "Rowid:%String,ArcItmMast:%String,ArcItmDR:%String,Flag:%String")
{
}

ClassMethod QueryItembyGroupIDExecute(ByRef qHandle As %Binary, Groupdr As %String, paadmdr As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
    s ^TempRIS("TMPRIS")=Groupdr_"^"_paadmdr
    i ((Groupdr="")!(paadmdr=""))
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	
	s (Rowid,ArcItmMast,ArcItmDR,Flag)=""
	s patienttype=$p($g(^PAADM(paadmdr)),"^",2) ;病人类型
	
	f  s Rowid=$o(^DHCRBCGroupArcItmMasti("ItmGroup",Groupdr,Rowid)) q:(Rowid="")  d
    .s (ArcItmMast,ArcItmDR,Flag)=""
	.s ArcItmDR=$p($g(^DHCRBCGroupArcItmMast(Rowid)),"^",2)
	.q:(ArcItmDR="")
	.s ArcItmMast=$p(^ARCIM($p(ArcItmDR,"||",1),$p(ArcItmDR,"||",2),1),"^",2)
	.s Flag=##class(web.DHCRisResApptSchudleSystem).RequestAppMethod(ArcItmDR,patienttype)
	.Do ExportA
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportA
	set Data=$lb(Rowid,ArcItmMast,ArcItmDR,Flag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryItembyGroupIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItembyGroupIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryItembyGroupIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItembyGroupIDExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 医护人员关注医嘱项目设置
/// sunyi 2014-04-06
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryItembyUser","687","20019")
Query QueryItembyUser(UserDR As %String, paadmdr As %String) As %Query(ROWSPEC = "Rowid:%String,ArcItmMast:%String,ArcItmDR:%String,Flag:%String")
{
}

ClassMethod QueryItembyUserExecute(ByRef qHandle As %Binary, UserDR As %String, paadmdr As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
   
    i UserDR="" s UserDR=%session.Get("LOGON.USERID")
    i (paadmdr="")
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
    s patienttype=$p($g(^PAADM(paadmdr)),"^",2) ;病人类型
	s (Rowid,ArcItmDR,Flag,ArcItmMast)=""
	
	f  s Rowid=$o(^DHCRBCUserAttentionSeti("USER",UserDR,Rowid)) q:(Rowid="")  d
    .s (ArcItmDR,Flag,ArcItmMast)=""
	.s ArcItmDR=$p($g(^DHCRBCUserAttentionSet(Rowid)),"^",2)
	.q:(ArcItmDR="")
	.i ArcItmDR'="" s ArcItmMast=$p(^ARCIM($p(ArcItmDR,"||",1),$p(ArcItmDR,"||",2),1),"^",2)
	.s Flag=##class(web.DHCRisResApptSchudleSystem).RequestAppMethod(ArcItmDR,patienttype)
	.Do ExportB
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportB
	set Data=$lb(Rowid,ArcItmMast,ArcItmDR,Flag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryItembyUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItembyUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryItembyUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItembyUserExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 医护人员关注医嘱项目设置
/// sunyi 2014-04-06
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryUserUseItem","687^")
Query QueryUserUseItem(Info As %String) As %Query(ROWSPEC = "Rowid:%String,ArcItmMast:%String,ArcItmDR:%String,Flag:%String")
{
}

ClassMethod QueryUserUseItemExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s UserDR=$p($g(Info),"^",1)
	s InArcItmDR=$p($g(Info),"^",2)
   
    i UserDR="" s UserDR=%session.Get("LOGON.USERID")
    
	s (Rowid,ArcItmDR,Flag,ArcItmMast)=""
	s ^ttttt=UserDR
	f  s Rowid=$o(^DHCRBCUserAttentionSeti("USER",UserDR,Rowid)) q:(Rowid="")  d
    .s (ArcItmDR,Flag,ArcItmMast)=""
	.s ArcItmDR=$p($g(^DHCRBCUserAttentionSet(Rowid)),"^",2)
	.q:(ArcItmDR="")
	.q:(InArcItmDR'="")&(InArcItmDR'=ArcItmDR)
	.i ArcItmDR'="" s ArcItmMast=$p(^ARCIM($p(ArcItmDR,"||",1),$p(ArcItmDR,"||",2),1),"^",2)
	.;s Flag=##class(web.DHCRisResApptSchudleSystem).RequestAppMethod(ArcItmDR,patienttype)
	.Do ExportC
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportC
	set Data=$lb(Rowid,ArcItmMast,ArcItmDR,Flag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryUserUseItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserUseItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryUserUseItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserUseItemExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 根据登陆用户获取所在科室
/// sunyi 2014-04-13	
/// w ##class(web.DHCRisCodeTableSet).GetAppLocDRbyUser("687")
ClassMethod GetAppLocDRbyUser(SSURowid As %String) As %String
{
	s AppLocDR=""
	q:(SSURowid="") AppLocDR
	
	i SSURowid'="" d
	.s AppLocDR=$p($g(^SSU("SSUSR",SSURowid)),"^",4)
	
	q AppLocDR
}

/// 查询名称：QueryResbySerGroup
/// 功能：查询服务组下可用的资源
/// 参数：
/// 返回：
/// 作者：sunyi
/// 日期：2014-05-08
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryResbySerGroup","4")
Query QueryResbySerGroup(SerGroupDR As %String) As %Query(ROWSPEC = "ResourceID:%String,Res:%String")
{
}

ClassMethod QueryResbySerGroupExecute(ByRef qHandle As %Binary, SerGroupDR As %String) As %Status
{
 s ind=1
 Set repid=$I(^CacheTemp)
 k ^DHCRISTEMP("RESTMP")
 
 s Rowid=0  f  s Rowid=$o(^DHCRBCResourcePlan(Rowid)) q:Rowid=""  d
 .d OutUseRes 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
OutUseRes
 s ResourceID=$p($g(^DHCRBCResourcePlan(Rowid)),"^",2)
 s ServiceGroupID=$p($g(^DHCRBCResourcePlan(Rowid)),"^",3)
 q:(SerGroupDR'="")&(SerGroupDR'=ServiceGroupID)
 q:(ResourceID="")
 s EqId="",CareProvId="",Res=""
 s EqId=$p(^RB("RES",ResourceID),"^",3)
 s CareProvId=$p(^RB("RES",ResourceID),"^",2)
 i EqId'="" s Res=$p(^RBC("EQ",EqId),"^",2)
 i CareProvId'="" s Res=$p(^CTPCP(CareProvId,1),"^",2)
 /*i $d(^DHCRISTEMP("RESTMP",Res))
 {
	 q:(^DHCRISTEMP("RESTMP"))=Res
 }*/
 
 q:($d(^DHCRISTEMP("RESTMP",Res)))
 s ^DHCRISTEMP("RESTMP",Res)=""
 set Data=$lb(ResourceID,Res)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryResbySerGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResbySerGroupExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryResbySerGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResbySerGroupExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// ///////////---------------------------------新修改同仁类-20140523--------------------------------
/// 检查大类设置
/// 2014-05-23
/// w ##class(web.DHCRisCodeTableSet).StudyCategorySet("^超声^BC","I")
ClassMethod StudyCategorySet(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid="",Desc="",Code="",LocDR=""
	
	s Rowid =$P(AllInfo,"^",1)
	s Desc = $P(AllInfo,"^",2) 
	s Code = $P(AllInfo,"^",3)
	
	s SameCount=0
	s LocUse=0
	s CategoryUse=0
	
	i (Desc'="")&(Code'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_StudyCategory
	       where DSC_Code=:Code and DSC_Desc=:Desc) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_StudyCategory(DSC_Code,DSC_Desc) values(:Code,:Desc))
	     
	i OperateCode="U" d 
	.&sql(UpDate DHCRBC_StudyCategory(DSC_Code,DSC_Desc) values(:Code,:Desc)where DSC_RowID=:Rowid )
	
	i OperateCode="D" d
	.&sql(select count(*) into :LocUse from DHCRBC_CategoryInLoc where DCIL_StudyCategory_DR=:Rowid) 
	.&sql(select count(*) into :CategoryUse from DHCRBC_CategoryAndCat where DCAC_StudyCategory_DR=:Rowid) 
	.i ((LocUse=0)&(CategoryUse=0)) d
	..&sql(Delete from DHCRBC_StudyCategory where DSC_RowID =:Rowid)
	.e  d
	..s SQLCODE="-999"
	
    q SQLCODE
}

/// 查询检查大类
/// sunyi 2014-05-23
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryCategory","")
Query QueryCategory(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod QueryCategoryExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
    s InDesc=$p($g(Info),"^",1)
    s InCode=$p($g(Info),"^",2)
    
	s (Rowid,Desc,Code)=""
	
	f  s Rowid=$o(^DHCRBCStudyCategory(Rowid)) q:(Rowid="")  d
    .s (Desc,Code)=""
	.s Desc=$p($g(^DHCRBCStudyCategory(Rowid)),"^",2)
	.q:(InDesc'="")&(InDesc'=Desc)
	.s Code=$p($g(^DHCRBCStudyCategory(Rowid)),"^",1)
	.q:(InCode'="")&(InCode'=Code)
	.Do ExportCategory
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportCategory
	set Data=$lb(Rowid,Desc,Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCategoryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCategoryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 指定检查大类到科室设置
/// sunyi 2014-05-23
/// w ##class(web.DHCRisCodeTableSet).CategoryInLocSet("^2^83","I")
ClassMethod CategoryInLocSet(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid="",CategoryDR="",LocDR=""
	
	s Rowid =$P(AllInfo,"^",1)
	s CategoryDR = $P(AllInfo,"^",2) 
	s LocDR = $P(AllInfo,"^",3)
	
	s SameCount=0
	i (CategoryDR'="")&(LocDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_CategoryInLoc
	       where DCIL_StudyCategory_DR=:CategoryDR and DCIL_LOC_DR=:LocDR) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_CategoryInLoc(DCIL_StudyCategory_DR,DCIL_LOC_DR) values(:CategoryDR,:LocDR))
	     
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_CategoryInLoc where DCIL_RowID =:Rowid)
	
    q SQLCODE
}

/// 根据检查大类ID查询使用的科室
/// sunyi 2014-05-23
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","CategoryInLoc","2")
Query CategoryInLoc(InCategoryDR As %String = "") As %Query(ROWSPEC = "Rowid:%String,LocDesc:%String,LocDR:%String")
{
}

ClassMethod CategoryInLocExecute(ByRef qHandle As %Binary, InCategoryDR As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
    i (InCategoryDR="")
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	s (Rowid,LocDR,LocDesc)=""
	
	f  s Rowid=$o(^DHCRBCCategoryInLoci("CATEGORY",InCategoryDR,Rowid)) q:(Rowid="")  d
    .s (Desc,LocDR,LocDesc)=""
	.s LocDR=$p($g(^DHCRBCCategoryInLoc(Rowid)),"^",2)
	.i LocDR'="" s LocDesc=$p($g(^CTLOC(LocDR)),"^",2)
	.Do ExportCategoryInLoc
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportCategoryInLoc
	set Data=$lb(Rowid,LocDesc,LocDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CategoryInLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CategoryInLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CategoryInLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CategoryInLocExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 根据检查大类ID查询对应的科室 
ClassMethod GetLocByCategoryId(InCategoryDR As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:CategoryInLoc")
	s ret=""
	do rset.Execute(InCategoryDR)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// 检查子类设置
/// 2014-05-23
/// w ##class(web.DHCRisCodeTableSet).StudyItmCatSet("^超声1^BC1","I")
ClassMethod StudyItmCatSet(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid="",Desc="",Code="",LocDR=""
	
	s Rowid =$P(AllInfo,"^",1)
	s Desc = $P(AllInfo,"^",2) 
	s Code = $P(AllInfo,"^",3)
	
	s SameCount=0
	s ItemUse=0
	s CategoryUse=0
	
	i (Desc'="")&(Code'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_StudyItmCat
	       where DSIC_Code=:Code and DSIC_Desc=:Desc) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_StudyItmCat(DSIC_Code,DSIC_Desc) values(:Code,:Desc))
	     
	i OperateCode="U" d 
	.&sql(UpDate DHCRBC_StudyItmCat(DSIC_Code,DSIC_Desc) values(:Code,:Desc)where DSIC_RowID=:Rowid )
	
	i OperateCode="D" d
	.&sql(select count(*) into :ItemUse from DHCRBC_ItmMastCatSet where DICS_StudyItmCat_DR=:Rowid) 
	.&sql(select count(*) into :CategoryUse from DHCRBC_CategoryAndCat where DCAC_StudyItmCat_DR=:Rowid) 
	.i ((ItemUse=0)&(CategoryUse=0)) d
	..&sql(Delete from DHCRBC_StudyItmCat where DSIC_RowID = :Rowid)
	.e  d
	..s SQLCODE="-999"
	
    q SQLCODE
}

/// 查询检查子类
/// sunyi 2014-05-23
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryItmCat","")
Query QueryItmCat(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod QueryItmCatExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
    s InDesc=$p($g(Info),"^",1)
    s InCode=$p($g(Info),"^",2)
    
	s (Rowid,Desc,Code)=""
	
	f  s Rowid=$o(^DHCRBCStudyItmCat(Rowid)) q:(Rowid="")  d
    .s (Desc,Code)=""
	.s Desc=$p($g(^DHCRBCStudyItmCat(Rowid)),"^",2)
	.q:(InDesc'="")&(InDesc'=Desc)
	.s Code=$p($g(^DHCRBCStudyItmCat(Rowid)),"^",1)
	.q:(InCode'="")&(InCode'=Code)
	.Do ExportItmCat
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportItmCat
	set Data=$lb(Rowid,Desc,Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryItmCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItmCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryItmCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItmCatExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 子类关联检查项目设置
/// sunyi 2014-05-23
/// w ##class(web.DHCRisCodeTableSet).ItmMastCatSet("^1^8866||1","I")
ClassMethod ItmMastCatSet(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid="",ItmCatDR="",ArcItmDR=""
	
	s Rowid =$P(AllInfo,"^",1)
	s ItmCatDR = $P(AllInfo,"^",2) 
	s ArcItmDR = $P(AllInfo,"^",3)
	
	s SameCount=0
	i (ItmCatDR'="")&(ArcItmDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_ItmMastCatSet
	       where DICS_StudyItmCat_DR=:ItmCatDR and DICS_ArcItemMast_DR=:ArcItmDR) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_ItmMastCatSet(DICS_StudyItmCat_DR,DICS_ArcItemMast_DR) values(:ItmCatDR,:ArcItmDR))
	     
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_ItmMastCatSet where DICS_RowID =:Rowid)
	
    q SQLCODE
}

/// 根据检查子类ID查询关联的检查项目
/// sunyi 2014-05-23
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryItembyCatDR","1")
Query QueryItembyCatDR(InItmCatDR As %String = "") As %Query(ROWSPEC = "Rowid:%String,ArcItmMast:%String,ArcItmDR:%String,Flag:%String")
{
}

ClassMethod QueryItembyCatDRExecute(ByRef qHandle As %Binary, InItmCatDR As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
    i ((InItmCatDR=""))
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	
	//i Paadmdr'="" s patienttype=$p($g(^PAADM(Paadmdr)),"^",2) ;病人类型
	
	s (Rowid,ArcItmMast,ArcItmDR)=""
	f  s Rowid=$o(^DHCRBCItmMastCatSeti("StudyItmCat",InItmCatDR,Rowid)) q:(Rowid="")  d
    .s (ArcItmMast,ArcItmDR)=""
	.s ArcItmDR=$p($g(^DHCRBCItmMastCatSet(Rowid)),"^",2)
	.i ArcItmDR'="" s ArcItmMast=$p(^ARCIM($p(ArcItmDR,"||",1),$p(ArcItmDR,"||",2),1),"^",2)
	.q:(ArcItmDR="")
	.s ArcItmMast=$p(^ARCIM($p(ArcItmDR,"||",1),$p(ArcItmDR,"||",2),1),"^",2)
	.;i Paadmdr'="" s Flag=##class(web.DHCRisResApptSchudleSystem).RequestAppMethod(ArcItmDR,patienttype)
	.Do ExportItembyCatDR
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportItembyCatDR
	set Data=$lb(Rowid,ArcItmMast,ArcItmDR,$g(Flag))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryItembyCatDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItembyCatDRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryItembyCatDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItembyCatDRExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 根据检查子类ID查询对应的项目 
/// w ##class(DHCRisCodeTableSet).GetItmbyCatId("2")
ClassMethod GetItmbyCatId(InCatDR As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryItembyCatDR")
	s ret="",Paadmdr=""
	do rset.Execute(InCatDR)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// 检查大类与子类关联设置
/// 2014-05-23
/// w ##class(web.DHCRisCodeTableSet).CategoryAndCatSet("^2^1","I")
ClassMethod CategoryAndCatSet(AllInfo As %String, OperateCode As %String) As %String
{
	s Rowid="",CategoryDR="",CatDR=""
	
	s Rowid =$P(AllInfo,"^",1)
	s CategoryDR = $P(AllInfo,"^",2) 
	s CatDR = $P(AllInfo,"^",3)
	
	s SameCount=0
	
	
	i (CategoryDR'="")&(CatDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_CategoryAndCat
	       where DCAC_StudyCategory_DR=:CategoryDR and DCAC_StudyItmCat_DR=:CatDR) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_CategoryAndCat(DCAC_StudyCategory_DR,DCAC_StudyItmCat_DR) values(:CategoryDR,:CatDR))
	     
	i OperateCode="U" d 
	.&sql(UpDate DHCRBC_CategoryAndCat(DCAC_StudyCategory_DR,DCAC_StudyItmCat_DR) values(:CategoryDR,:CatDR)where DCAC_RowID=:Rowid )
	
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_CategoryAndCat where DCAC_RowID = :Rowid)
		
    q SQLCODE
}

/// 查询检查子类与大类
/// sunyi 2014-05-23
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryCategoryAndCat","")
Query QueryCategoryAndCat(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,Category:%String,Cat:%String,CategoryDR:%String,CatDR:%String")
{
}

ClassMethod QueryCategoryAndCatExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
    s InCategoryDR=$p($g(Info),"^",1)
    s InCatDR=$p($g(Info),"^",2)
    
	s (Rowid,Category,Cat,CategoryDR,CatDR)=""
	
	f  s Rowid=$o(^DHCRBCCategoryAndCat(Rowid)) q:(Rowid="")  d
    .s (Category,Cat,CategoryDR,CatDR)=""
	.s CategoryDR=$p($g(^DHCRBCCategoryAndCat(Rowid)),"^",1)
	.q:(InCategoryDR'="")&(InCategoryDR'=CategoryDR)
	.s CatDR=$p($g(^DHCRBCCategoryAndCat(Rowid)),"^",2)
	.q:(InCatDR'="")&(InCatDR'=CatDR)
	.i CategoryDR'="" s Category=$p($g(^DHCRBCStudyCategory(CategoryDR)),"^",2)
	.i CatDR'="" s Cat=$p($g(^DHCRBCStudyItmCat(CatDR)),"^",2)
	.Do ExportCategoryAndCat
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportCategoryAndCat
	set Data=$lb(Rowid,Category,Cat,CategoryDR,CatDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryCategoryAndCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCategoryAndCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryCategoryAndCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCategoryAndCatExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 根据科室查询检查大类
/// sunyi 2014-05-23
/// 入参:CT_Loc_Rowid
/// 返回值:Rowid,Category,CategoryDR
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryCategorybyLoc","83")
Query QueryCategorybyLoc(LocDR As %String) As %Query(ROWSPEC = "Rowid:%String,Category:%String,CategoryDR:%String")
{
}

ClassMethod QueryCategorybyLocExecute(ByRef qHandle As %Binary, LocDR As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	i (LocDR="")
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	s (Rowid,Category,CategoryDR)=""
	
	f  s Rowid=$o(^DHCRBCCategoryInLoci("LOC",LocDR,Rowid)) q:(Rowid="")  d
    .s (Category,CategoryDR)=""
	.s CategoryDR=$p($g(^DHCRBCCategoryInLoc(Rowid)),"^",1)
	.i CategoryDR'="" s Category=$p($g(^DHCRBCStudyCategory(CategoryDR)),"^",2)
	.Do ExportCategorybyLoc
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportCategorybyLoc
	set Data=$lb(Rowid,Category,CategoryDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryCategorybyLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCategorybyLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryCategorybyLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCategorybyLocExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 根据检查大类ID查询子类
/// sunyi 2014-05-23
/// 入参:检查大类ID
/// 返回值:Rowid,Cat,CatDR
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryCatbyCateDR","2")
Query QueryCatbyCateDR(InCategoryDR As %String = "") As %Query(ROWSPEC = "Rowid:%String,Cat:%String,CatDR:%String")
{
}

ClassMethod QueryCatbyCateDRExecute(ByRef qHandle As %Binary, InCategoryDR As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
    i (InCategoryDR="")
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	s (Rowid,Cat,CatDR)=""
	f  s Rowid=$o(^DHCRBCCategoryAndCati("STUDY-CATEGORY",InCategoryDR,Rowid)) q:(Rowid="")  d
    .s (Cat,CatDR)=""
	.s CatDR=$p($g(^DHCRBCCategoryAndCat(Rowid)),"^",2)
	.i CatDR'="" s Cat=$p($g(^DHCRBCStudyItmCat(CatDR)),"^",2)
	.Do ExportCatbyCateDR
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportCatbyCateDR
	set Data=$lb(Rowid,Cat,CatDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryCatbyCateDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCatbyCateDRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryCatbyCateDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCatbyCateDRExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 得到大类列表
/// w ##class(web.DHCRisCodeTableSet).GetCategoryList()
ClassMethod GetCategoryList() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryCategory")
	s ret=""
	s Info=""
	
	do rset.Execute(Info)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// 得到子类列表
/// w ##class(web.DHCRisCodeTableSet).GetItmCatList()
ClassMethod GetItmCatList() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryItmCat")
	s ret=""
	s Info=""
	
	do rset.Execute(Info)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryArcItembyCatDR","1","20019")
Query QueryArcItembyCatDR(InItmCatDR As %String = "", Paadmdr As %String = "") As %Query(ROWSPEC = "Rowid:%String,ArcItmMast:%String,ArcItmDR:%String,Flag:%String")
{
}

ClassMethod QueryArcItembyCatDRExecute(ByRef qHandle As %Binary, InItmCatDR As %String, Paadmdr As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
    i ((InItmCatDR="")!(Paadmdr=""))
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	
	i Paadmdr'="" s patienttype=$p($g(^PAADM(Paadmdr)),"^",2) ;病人类型
	
	s (Rowid,ArcItmMast,ArcItmDR)=""
	f  s Rowid=$o(^DHCRBCItmMastCatSeti("StudyItmCat",InItmCatDR,Rowid)) q:(Rowid="")  d
    .s (ArcItmMast,ArcItmDR)=""
	.s ArcItmDR=$p($g(^DHCRBCItmMastCatSet(Rowid)),"^",2)
	.i ArcItmDR'="" s ArcItmMast=$p(^ARCIM($p(ArcItmDR,"||",1),$p(ArcItmDR,"||",2),1),"^",2)
	.q:(ArcItmDR="")
	.s ArcItmMast=$p(^ARCIM($p(ArcItmDR,"||",1),$p(ArcItmDR,"||",2),1),"^",2)
	.i Paadmdr'="" s Flag=##class(web.DHCRisResApptSchudleSystem).RequestAppMethod(ArcItmDR,patienttype)
	.Do ExportArcItembyCatDR
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportArcItembyCatDR
	set Data=$lb(Rowid,ArcItmMast,ArcItmDR,$g(Flag))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryArcItembyCatDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryArcItembyCatDRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryArcItembyCatDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryArcItembyCatDRExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// //////////---------------------------------导入程序-------------------------------------
/// 根据院区代码获取ID
ClassMethod GetHospitalIDbyCode(Code As %String)
{
	s HospRowid=""
	q:(Code="")
	s HospRowid=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(Code),HospRowid))
	q HospRowid
}

/// 根据科室代码获取ID
ClassMethod GetLocIDbyCode(Code As %String)
{
	s LocRowid=""
	q:(Code="")
	s LocRowid=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code),LocRowid))
	q LocRowid
}

/// 根据BC_Equipment设备待码获取RB_Resource资源表ID
/// w ##class(web.DHCRisCodeTableSet).GetResIDbyEqCode("SIMENS")
ClassMethod GetResIDbyEqCode(Code As %String)
{
	s ResRowid=""
	q:(Code="")
	s EqRowid=""
	s EqRowid=$o(^RBC("EQ",0,"Code",$$ALPHAUP^SSUTIL4(Code),EqRowid))
	q:(EqRowid="")
	s ResLocRowid="" 
	s ResLocRowid=$o(^RB("RES",0,"EQ",EqRowid,ResLocRowid))
	i ResLocRowid'="" d
	.s ResRowid= $o(^RB("RES",0,"EQ",EqRowid,ResLocRowid,ResRowid))
	q ResRowid
}

/// 根据项目代码找到ArcItemid
ClassMethod GetArcItmRowidbyCode(ArcItmCode As %String) As %String
{
	s SubscriptID="",VersionID="",ArcItmRowid=""
	i ArcItmCode'="" d
    .s SubscriptID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),0))
    .i SubscriptID'="" d
    ..s VersionID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),SubscriptID,0))
    ..i VersionID'="" s ArcItmRowid=SubscriptID_"||"_VersionID 
    
    q ArcItmRowid
}

/// 根据服务组描述获取Rowid
ClassMethod GetSerGroupDRbyDesc(ServiceGroup As %String) As %String
{
	s ServiceGroupId=""
	i ServiceGroup'="" d
	.s ServiceGroupId=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(ServiceGroup),0))
	q ServiceGroupId
}

/// w ##class(web.DHCRisCodeTableSet).ImportResInHospital("BJDTYY^6501^LOG9^6501")
/// 导入设备所在院区
ClassMethod ImportResInHospital(Info As %String) As %String
{
	s hospCode=$p($g(Info),"^",1)
	s AppCode=$p($g(Info),"^",2)
	s EqCode=$p($g(Info),"^",3)
	s RecCode=$p($g(Info),"^",4)
	
	s HospitalDR="",AppDR="",RecDR="",ResDR="",SQLCODE="-1"
	
	s HospitalDR=..GetHospitalIDbyCode(hospCode)
	s AppDR=..GetLocIDbyCode(AppCode)
	s ResDR=..GetResIDbyEqCode(EqCode)
	s RecDR=..GetLocIDbyCode(RecCode)
	q:((HospitalDR="")!(AppDR="")!(ResDR="")!(RecDR="")) 
	
	s SameCount=0
	i ((AppDR'="")&(ResDR'="")&(RecDR'="")) d
	.&sql(select count(*) into :SameCount from DHCRBC_LocResourceSet
	       where DLRS_AppLoc_DR=:AppDR and DLRS_RecLoc_DR=:RecDR and DLRS_Resource_DR=:ResDR) 
	i SameCount=0 d
	.&sql(Insert into DHCRBC_LocResourceSet
	     (DLRS_AppLoc_DR,DLRS_Resource_DR,DLRS_Hospital_DR,DLRS_RecLoc_DR) values(:AppDR,:ResDR,:HospitalDR,:RecDR))
	else  d
	.&sql(UpDate DHCRBC_LocResourceSet(DLRS_AppLoc_DR,DLRS_Resource_DR,DLRS_Hospital_DR,DLRS_RecLoc_DR) 
	      values(:AppDR,:ResDR,:HospitalDR,:RecDR)
	       where DLRS_AppLoc_DR=:AppDR and DLRS_RecLoc_DR=:RecDR and DLRS_Resource_DR=:ResDR)
	
	q SQLCODE
}

/// w ##class(web.DHCRisCodeTableSet).ImportItemGroup("眼科B超^YKBC^6501")
/// w ##class(web.DHCRisCodeTableSet).ImportItemGroup("OTC^OTC^6501")
/// 导入项目分组与科室设置
ClassMethod ImportItemGroup(Info As %String) As %String
{
	s Desc=$p($g(Info),"^",1)
	s Code=$p($g(Info),"^",2)
	s LocCode=$p($g(Info),"^",3)
	
	s LocDR="",SQLCODE="-1"
	s LocDR=..GetLocIDbyCode(LocCode)
	q:((Desc="")!(Code="")!(LocDR=""))

	s SameCount=0
	i (Desc'="")&(Code'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_ItemGroupLocSet
	       where DIGS_Code=:Code and DIGS_Desc=:Desc) 
	                     
	i SameCount=0 d
	.&sql(Insert into DHCRBC_ItemGroupLocSet(DIGS_Code,DIGS_Desc,DIGS_RecLoc_DR) values(:Code,:Desc,:LocDR))
	e  d
	.&sql(UpDate DHCRBC_ItemGroupLocSet(DIGS_Code,DIGS_Desc,DIGS_RecLoc_DR) 
	      values(:Code,:Desc,:LocDR)where DIGS_Code=:Code And DIGS_Desc=:Desc And DIGS_RecLoc_DR=:LocDR)
	q SQLCODE
}

/// 导入分组下医嘱项目
/// w ##class(web.DHCRisCodeTableSet).ImportGroupArcItm("BC^WL0126")
ClassMethod ImportGroupArcItm(Info As %String) As %String
{
	s GroupCode=$p($g(Info),"^",1)
	s ArcItmCode=$p($g(Info),"^",2)
	
	s GroupDR="",ArcItmRowid="",SQLCODE="-1"
	q:(GroupCode="")
	
	s GroupDR=$o(^DHCRBCItemGroupLocSeti("Code",GroupCode,GroupDR))
	s ArcItmRowid=..GetArcItmRowidbyCode(ArcItmCode)
	q:((GroupDR="")!(ArcItmRowid=""))
	s SameCount=0
	i (GroupDR'="")&(ArcItmRowid'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_GroupArcItmMast
	       where DGA_ArcItmMast_DR=:ArcItmRowid and DGA_ItemGroup_DR=:GroupDR) 
	
	i SameCount=0 d
	.&sql(Insert into DHCRBC_GroupArcItmMast
	     (DGA_ArcItmMast_DR,DGA_ItemGroup_DR) values(:ArcItmRowid,:GroupDR))
	e  d
	.&sql(UpDate DHCRBC_GroupArcItmMast(DGA_ArcItmMast_DR,DGA_ItemGroup_DR) 
	      values(:ArcItmRowid,:GroupDR)where DGA_ArcItmMast_DR=:ArcItmRowid And DGA_ItemGroup_DR=:GroupDR) 
	     
    q SQLCODE
}

/// 导入服务组下可用的设备
/// w ##class(web.DHCRisCodeTableSet).ImportServiceUseRes("挂号^MRI1")
ClassMethod ImportServiceUseRes(Info As %String) As %String
{
	s SerGroupDesc =$P($g(Info),"^",1)  //服务组描述
	s EqCode =$P($g(Info),"^",2)
	
	s SerGroupDR="",ResDR=""
	s SerGroupDR=..GetSerGroupDRbyDesc(SerGroupDesc)
	s ResDR=..GetResIDbyEqCode(EqCode)
	
	q:((SerGroupDR="")!(ResDR=""))
	s SameCount=0
	i (SerGroupDR'="")&(ResDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_SerAvailableRes
	       where DSAR_ServiceGroup_DR=:SerGroupDR and DSAR_Resource_DR=:ResDR) 
	
	i SameCount=0 d
	.&sql(Insert into DHCRBC_SerAvailableRes
	     (DSAR_ServiceGroup_DR,DSAR_Resource_DR) values(:SerGroupDR,:ResDR))
	e  d
	.&sql(UpDate DHCRBC_SerAvailableRes(DSAR_ServiceGroup_DR,DSAR_Resource_DR) 
	      values(:SerGroupDR,:ResDR)where DSAR_ServiceGroup_DR=:SerGroupDR And DSAR_Resource_DR=:ResDR)
    q SQLCODE
}

/// 根据大类代码获取ID
/// w ##class(web.DHCRisCodeTableSet).GetCategoryDRbyCode("BC")
ClassMethod GetCategoryDRbyCode(Code As %String) As %String
{
	s CategoryDR=""
	q:(Code="")
	s CategoryDR=$o(^DHCRBCStudyCategoryi("CODE",$$ALPHAUP^SSUTIL4(Code),CategoryDR))
	q CategoryDR
}

/// 根据子类代码获取ID
/// w ##class(web.DHCRisCodeTableSet).GetCatDRbyCode("BC1")
ClassMethod GetCatDRbyCode(Code As %String) As %String
{
	s CatDR=""
	q:(Code="")
	s CatDR=$o(^DHCRBCStudyItmCati("CODE",$$ALPHAUP^SSUTIL4(Code),CatDR))
    q CatDR
}

/// 导入检查大类
/// w ##class(web.DHCRisCodeTableSet).ImportCategory("超声心动^CS")
ClassMethod ImportCategory(Info As %String) As %String
{
	s Desc=$p($g(Info),"^",1)
	s Code=$p($g(Info),"^",2)
	
	q:((Desc="")!(Code=""))
	
	s SameCount=0
	i (Desc'="")&(Code'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_StudyCategory
	       where DSC_Code=:Code and DSC_Desc=:Desc) 
	                     
	i SameCount=0 d
	.&sql(Insert into DHCRBC_StudyCategory(DSC_Code,DSC_Desc) values(:Code,:Desc))
	e  d
	.&sql(UpDate DHCRBC_StudyCategory(DSC_Code,DSC_Desc) 
	      values(:Code,:Desc)where DSC_Code=:Code And DSC_Desc=:Desc)
	q SQLCODE
}

/// 导入检查子类
/// w ##class(web.DHCRisCodeTableSet).ImportItemCat("CS^CS")
ClassMethod ImportItemCat(Info As %String) As %String
{
	s Desc=$p($g(Info),"^",1)
	s Code=$p($g(Info),"^",2)
	
	q:((Desc="")!(Code=""))
	
	s SameCount=0
	i (Desc'="")&(Code'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_StudyItmCat
	       where DSIC_Code=:Code and DSIC_Desc=:Desc) 
	                     
	i SameCount=0 d
	.&sql(Insert into DHCRBC_StudyItmCat(DSIC_Code,DSIC_Desc) values(:Code,:Desc))
	e  d
	.&sql(UpDate DHCRBC_StudyItmCat(DSIC_Code,DSIC_Desc) 
	      values(:Code,:Desc)where DSIC_Code=:Code And DSIC_Desc=:Desc)
	q SQLCODE
}

/// 导入指定检查大类到科室
/// w ##class(web.DHCRisCodeTableSet).ImportCateAndLoc("BC^医学影像科CT室")
ClassMethod ImportCateAndLoc(Info As %String) As %String
{
	s CategroyCode=$p($g(Info),"^",1)
	s LocCode=$p($g(Info),"^",2)
	
	q:((CategroyCode="")!(LocCode=""))
	s CategroyDR="",LocDR=""
	s CategroyDR=..GetCategoryDRbyCode(CategroyCode)
	s LocDR=..GetLocIDbyCode(LocCode)
	s SameCount=0
	i (CategroyDR'="")&(LocDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_CategoryInLoc
	       where DCIL_StudyCategory_DR=:CategroyDR and DCIL_LOC_DR=:LocDR) 
	                     
	i SameCount=0 d
	.&sql(Insert into DHCRBC_CategoryInLoc(DCIL_StudyCategory_DR,DCIL_LOC_DR) values(:CategroyDR,:LocDR))
	e  d
	.&sql(UpDate DHCRBC_CategoryInLoc(DCIL_StudyCategory_DR,DCIL_LOC_DR) 
	      values(:CategroyDR,:LocDR)where DCIL_StudyCategory_DR=:CategroyDR And DCIL_LOC_DR=:LocDR)
	q SQLCODE
}

/// 导入检查子类与项目设置
/// w ##class(web.DHCRisCodeTableSet).ImportArcItmInCat("BC1^WL0056")
ClassMethod ImportArcItmInCat(Info As %String) As %String
{
	s CatCode=$p($g(Info),"^",1)
	s ArcItmCode=$p($g(Info),"^",2)
	
	q:((CatCode="")!(ArcItmCode=""))
	s CatDR="",ArcItmDR="",SQLCODE=0
	
	s CatDR=..GetCatDRbyCode(CatCode)
	s ArcItmDR=..GetArcItmRowidbyCode(ArcItmCode)
	
	s SameCount=0
	i (CatDR'="")&(ArcItmDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_ItmMastCatSet
	       where DICS_StudyItmCat_DR=:CatDR and DICS_ArcItemMast_DR=:ArcItmDR) 
	                     
	i SameCount=0 d
	.&sql(Insert into DHCRBC_ItmMastCatSet(DICS_StudyItmCat_DR,DICS_ArcItemMast_DR) values(:CatDR,:ArcItmDR))
	
	q SQLCODE
}

/// 导入检查大类与子类设置
/// w ##class(web.DHCRisCodeTableSet).ImportCateAndCat("BC^BC2")
ClassMethod ImportCateAndCat(Info As %String) As %String
{
	s CategoryCode=$p($g(Info),"^",1)
	s CatCode=$p($g(Info),"^",2)
	
	q:((CatCode="")!(CategoryCode=""))
	s CatDR="",CategoryDR="",SQLCODE=0
	s CatDR=..GetCatDRbyCode(CatCode)
	s CategoryDR=$o(^DHCRBCStudyCategoryi("CODE",$$ALPHAUP^SSUTIL4(CategoryCode),CategoryDR))
	
	s SameCount=0
	i (CatDR'="")&(CategoryDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_CategoryAndCat
	       where DCAC_StudyItmCat_DR=:CatDR and DCAC_StudyCategory_DR=:CategoryDR)                     
	i SameCount=0 d
	.&sql(Insert into DHCRBC_CategoryAndCat(DCAC_StudyItmCat_DR,DCAC_StudyCategory_DR) values(:CatDR,:CategoryDR))
	
	q SQLCODE
}

/// ---------------------------------中国医大增加------------------------------
/// 函数名称:ResInAppLocSet
/// 功能:对申请科室可使用资源编辑
/// 输入参数:"AllInfo=Rowid^AppLocDR^ServiceGroupDR^ResourceDR", OperateCode="I,U,D"
/// 返回:SQLCODE
/// 作者:孙毅
/// 日期:2014-07-05
/// w ##class(web.DHCRisCodeTableSet).ResInAppLocSet("^83^4^1383","I")
ClassMethod ResInAppLocSet(AllInfo As %String, OperateCode As %String) As %String
{
	s (Rowid,AppLocDR,ServiceGroupDR,ResourceDR)=""
	
	s Rowid=$P(AllInfo,"^",1)
	s AppLocDR=$P(AllInfo,"^",2) 
	s ServiceGroupDR=$P(AllInfo,"^",3)
	s ResourceDR=$P(AllInfo,"^",4)
	
	s SameCount=0
	i (AppLocDR'="")&(ResourceDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_ResourceInAppLoc
	       where DRIL_Resource_DR=:ResourceDR and DRIL_AppLoc_DR=:AppLocDR) ;DRIL_AppLoc_DR=:AppLocDR and
	       
	i SameCount'=0  s SQLCODE=-1
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_ResourceInAppLoc(DRIL_AppLoc_DR,DRIL_ServiceGroup_DR,DRIL_Resource_DR) values(:AppLocDR,:ServiceGroupDR,:ResourceDR))
	
	i OperateCode="U" d
	.&sql(UpDate  DHCRBC_ResourceInAppLoc(DRIL_AppLoc_DR,DRIL_ServiceGroup_DR,DRIL_Resource_DR) 
	      values(:AppLocDR,:ServiceGroupDR,:ResourceDR)where DRIL_RowID =:Rowid)
	     
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_ResourceInAppLoc where DRIL_RowID =:Rowid)
	
    q SQLCODE
}

/// 函数名称:QueryResInAppLoc
/// 功能:查询申请科室可使用的预约资源
/// 输入参数:"Info="GetAppLocDR^GetServiceGroupDR^GetResourceDR"
/// 返回:"Rowid:%String,AppLoc:%String,ServiceGroup:%String,Res:%String,AppLocDR:%String,ServiceGroupDR:%String,ResourceDR:%String"
/// 作者:孙毅
/// 日期:2014-07-05
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryResInAppLoc","")
Query QueryResInAppLoc(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,AppLoc:%String,ServiceGroup:%String,Res:%String,AppLocDR:%String,ServiceGroupDR:%String,ResourceDR:%String")
{
}

ClassMethod QueryResInAppLocExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s GetAppLocDR=$P($g(Info),"^",1) 
	s GetServiceGroupDR=$P($g(Info),"^",2)
	s GetResourceDR=$P($g(Info),"^",3)
	
	
	s (Rowid)=""
	f  s Rowid=$o(^DHCRBCResourceInAppLoc(Rowid)) q:(Rowid="")  d
	.s AppLocDR="",ServiceGroupDR="",ResourceDR="",AppLoc="",ServiceGroup="",Res=""
    .s AppLocDR=$p($g(^DHCRBCResourceInAppLoc(Rowid)),"^",1)
    .q:(GetAppLocDR'="")&(GetAppLocDR'=AppLocDR)
    .i AppLocDR'="" s AppLoc=$p($g(^CTLOC(AppLocDR)),"^",2)
    .s ResourceDR=$p($g(^DHCRBCResourceInAppLoc(Rowid)),"^",2)
    .q:(GetResourceDR'="")&(GetResourceDR'=ResourceDR)
    .q:(ResourceDR="")
    .s EqId="",CareProvId=""
    .s EqId=$p($g(^RB("RES",ResourceDR)),"^",3)
    .s CareProvId=$p($g(^RB("RES",ResourceDR)),"^",2)
    .i EqId'="" s Res=$p(^RBC("EQ",EqId),"^",2)
    .i CareProvId'="" s Res=$p(^CTPCP(CareProvId,1),"^",2)
    .s ServiceGroupDR=$p($g(^DHCRBCResourceInAppLoc(Rowid)),"^",3)
    .q:(GetServiceGroupDR'="")&(GetServiceGroupDR'=ServiceGroupDR)
    .i ServiceGroupDR'="" s ServiceGroup=$p($g(^RBC("SG",ServiceGroupDR)),"^",2)
	.Do ExportResInAppLoc
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportResInAppLoc
	set Data=$lb(Rowid,AppLoc,ServiceGroup,Res,AppLocDR,ServiceGroupDR,ResourceDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryResInAppLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResInAppLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryResInAppLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResInAppLocExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 函数名称:PatTypeUseResSet
/// 功能:病人类型与预约设备编辑函数
/// 输入参数:"AllInfo=Rowid^TypeCode^ServiceGroupDR^ResourceDR", OperateCode="I,U,D"
/// 返回:SQLCODE
/// 作者:孙毅
/// 日期:2014-07-05
/// w ##class(web.DHCRisCodeTableSet).PatTypeUseResSet("^I^4^1383","I")
ClassMethod PatTypeUseResSet(AllInfo As %String, OperateCode As %String) As %String
{
	s (Rowid,TypeCode,ServiceGroupDR,ResourceDR)=""
	
	s Rowid=$P(AllInfo,"^",1)
	s TypeCode=$P(AllInfo,"^",2) 
	s ServiceGroupDR=$P(AllInfo,"^",3)
	s ResourceDR=$P(AllInfo,"^",4)
	
	s SameCount=0
	i (TypeCode'="")&(ResourceDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_PatTypeUseRes
	       where DPTR_Resource_DR=:ResourceDR) ;DPTR_PatTypeCode=:TypeCode and
	
	i SameCount'=0  s SQLCODE=-1
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_PatTypeUseRes(DPTR_PatTypeCode,DPTR_ServiceGroup_DR,DPTR_Resource_DR) values(:TypeCode,:ServiceGroupDR,:ResourceDR))
	
	i OperateCode="U" d
	.&sql(UpDate  DHCRBC_PatTypeUseRes(DPTR_PatTypeCode,DPTR_ServiceGroup_DR,DPTR_Resource_DR) 
	      values(:TypeCode,:ServiceGroupDR,:ResourceDR)where DPTR_RowID =:Rowid)
	     
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_PatTypeUseRes where DPTR_RowID =:Rowid)
	
    q SQLCODE
}

/// 函数名称:QueryPatTypeUseRes
/// 功能:查询病人类型可使用的预约资源
/// 输入参数:"Info="GetAppLocDR^GetServiceGroupDR^GetResourceDR"
/// 返回:"Rowid:%String,PatType:%String,ServiceGroup:%String,Res:%String,TypeCode:%String,ServiceGroupDR:%String,ResourceDR:%String"
/// 作者:孙毅
/// 日期:2014-07-05
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryPatTypeUseRes","")
Query QueryPatTypeUseRes(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,PatType:%String,ServiceGroup:%String,Res:%String,TypeCode:%String,ServiceGroupDR:%String,ResourceDR:%String")
{
}

ClassMethod QueryPatTypeUseResExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s GetTypeCode=$P($g(Info),"^",1) 
	s GetServiceGroupDR=$P($g(Info),"^",2)
	s GetResourceDR=$P($g(Info),"^",3)
	
	s (Rowid)=""
	f  s Rowid=$o(^DHCRBCPatTypeUseResource(Rowid)) q:(Rowid="")  d
	.s TypeCode="",ServiceGroupDR="",ResourceDR="",ServiceGroup="",Res="",PatType=""
	.s TypeCode=$p($g(^DHCRBCPatTypeUseResource(Rowid)),"^",1)
	.q:(GetTypeCode'="")&(GetTypeCode'=TypeCode)
	.s PatType=##class(web.DHCRisCommFunction).GetTypeDesc(TypeCode)
	.s ServiceGroupDR=$p($g(^DHCRBCPatTypeUseResource(Rowid)),"^",2)
    .q:(GetServiceGroupDR'="")&(GetServiceGroupDR'=ServiceGroupDR)
    .i ServiceGroupDR'="" s ServiceGroup=$p($g(^RBC("SG",ServiceGroupDR)),"^",2)
	.s ResourceDR=$p($g(^DHCRBCPatTypeUseResource(Rowid)),"^",3)
	.q:(GetResourceDR'="")&(GetResourceDR'=ResourceDR)
    .q:(ResourceDR="")
    .s EqId="",CareProvId=""
    .s EqId=$p($g(^RB("RES",ResourceDR)),"^",3)
    .s CareProvId=$p($g(^RB("RES",ResourceDR)),"^",2)
    .i EqId'="" s Res=$p(^RBC("EQ",EqId),"^",2)
    .i CareProvId'="" s Res=$p(^CTPCP(CareProvId,1),"^",2)
	.Do ExportTypeUseRes
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportTypeUseRes
	set Data=$lb(Rowid,PatType,ServiceGroup,Res,TypeCode,ServiceGroupDR,ResourceDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryPatTypeUseResFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatTypeUseResExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryPatTypeUseResClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatTypeUseResExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询名称：QueryPadmType
/// 功能：查询病人类型
/// 参数：空
/// 返回：病人类型，ROWID 
/// 作者：龚平
/// 日期：2007-03-02
Query QueryPadmType() As %Query(ROWSPEC = "TRowid:%String,TDesc:%String,TCode:%String")
{
}

ClassMethod QueryPadmTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	Set ^CacheTemp(repid,1)=$lb("O","门诊病人")
 	Set ^CacheTemp(repid,2)=$lb("I","住院病人")
 	Set ^CacheTemp(repid,3)=$lb("E","急诊病人")
    Set ^CacheTemp(repid,4)=$lb("H","体检病人")
    Set ^CacheTemp(repid,5)=$lb("N","其他病人")
    //Set ^CacheTemp(repid,6)=$lb("所有","")
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPadmTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPadmTypeExecute ]
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

ClassMethod QueryPadmTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPadmTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ////////////////////////////中国医大增加2014-09-16///////////////////////////////////
/// 函数名称:OutWorkerSet
/// 功能:外勤人员设置函数
/// 输入参数:"AllInfo=Rowid^UserID^Type", OperateCode="I,U,D"
/// 返回:SQLCODE
/// 作者:孙毅
/// 日期:2014-09-16
/// w ##class(web.DHCRisCodeTableSet).OutWorkerSet("^687^1","I")
/// w ##class(web.DHCRisCodeTableSet).OutWorkerSet("^457^0","I")
ClassMethod OutWorkerSet(AllInfo As %String, OperateCode As %String) As %String
{
	s (Rowid,UserID,Type)=""
	
	s Rowid=$P(AllInfo,"^",1)
	s UserID=$P(AllInfo,"^",2) 
	s Type=$P(AllInfo,"^",3)
	
	s SameCount=0,LocSet=0,WardSet=0,Group=0,AdmLocSet=0
	
	i UserID'="" d
	.&sql(select count(*) into :SameCount from DHCRBC_OutWorkerSet where DOW_USER_DR=:UserID) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_OutWorkerSet(DOW_USER_DR,DOW_Type) values(:UserID,:Type))
	
	i OperateCode="U" d
	.&sql(UpDate  DHCRBC_OutWorkerSet(DOW_USER_DR,DOW_Type) 
	      values(:UserID,:Type)where DOW_RowID=:Rowid)
	     
	i OperateCode="D" d
	.&sql(select count(*) into :LocSet from DHCRBC_YardmanLocSet where DYLS_Dispatcher_DR=:Rowid) 
	.&sql(select count(*) into :AdmLocSet from DHCRBC_YardAdmLocSet where DYAS_Dispatcher_DR=:Rowid)
	.&sql(select count(*) into :WardSet from DHCRBC_RetinueWardSet where DRWS_Retinue_DR=:Rowid) 
	.&sql(select count(*) into :Group from DHCRBC_ControlCenter where DCC_Dispatcher_DR=:Rowid )
	
	.i ((LocSet=0)&(WardSet=0)&(Group=0)&(AdmLocSet=0)) d
	..&sql(Delete from DHCRBC_OutWorkerSet where DOW_RowID = :Rowid)
	.e  d
	..s SQLCODE="-999"
	
    q SQLCODE
}

/// 函数名称:QueryOutWorker
/// 功能:查询外请人员配置信息
/// 输入参数:"Info="UserID^Type"
/// 返回:"Rowid:%String,User:%String,Type:%String,TypeCode:%String,UserID:%String,Edit:%String"
/// 作者:孙毅
/// 日期:2014-07-05
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryOutWorker","")
Query QueryOutWorker(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,User:%String,Type:%String,TypeCode:%String,UserID:%String,Edit:%String,AdmLocEdit:%String")
{
}

ClassMethod QueryOutWorkerExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s GetUserDR=$P($g(Info),"^",1)
	s GetTypeCode=$P($g(Info),"^",2)
	
	s (Rowid)=""
	f  s Rowid=$o(^DHCRBCOutWorkerSet(Rowid)) q:(Rowid="")  d
	.s (User,Type,TypeCode,UserID,Edit,AdmLocEdit)=""
	.s UserID=$p($g(^DHCRBCOutWorkerSet(Rowid)),"^",1)
	.q:(GetUserDR'="")&(GetUserDR'=UserID) 
	.i UserID'="" s User=$p($g(^SSU("SSUSR",UserID)),"^",2)
	.s TypeCode=$p($g(^DHCRBCOutWorkerSet(Rowid)),"^",2)
	.q:(GetTypeCode'="")&(GetTypeCode'=TypeCode)
	.i TypeCode="0" s Type="陪检人员"
	.i TypeCode="1" s Type="调度人员" s Edit="编辑" s AdmLocEdit="编辑"
	.Do OutWorker
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWorker
	set Data=$lb(Rowid,User,Type,TypeCode,UserID,Edit,AdmLocEdit)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryOutWorkerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOutWorkerExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryOutWorkerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOutWorkerExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 函数名称:YardmanLocSet
/// 功能:调度员关注科室设置
/// 输入参数:"AllInfo=Rowid^DispatcherDR^LocDR",OperateCode="I,U,D"
/// 返回:SQLCODE
/// 作者:孙毅
/// 日期:2014-09-16
/// w ##class(web.DHCRisCodeTableSet).YardmanLocSet("^1^83","I")
ClassMethod YardmanLocSet(AllInfo As %String, OperateCode As %String) As %String
{
	s (Rowid,DispatcherDR,LocDR)=""
	
	s Rowid=$P(AllInfo,"^",1)
	s DispatcherDR=$P(AllInfo,"^",2) 
	s LocDR=$P(AllInfo,"^",3)
	
	s SameCount=0	
	i (DispatcherDR'="")&(LocDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_YardmanLocSet 
	         where DYLS_Dispatcher_DR=:DispatcherDR And DYLS_RecLoc_DR=:LocDR) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_YardmanLocSet(DYLS_Dispatcher_DR,DYLS_RecLoc_DR) values(:DispatcherDR,:LocDR))
	
	i OperateCode="U" d
	.&sql(UpDate  DHCRBC_YardmanLocSet(DYLS_Dispatcher_DR,DYLS_RecLoc_DR) 
	      values(:DispatcherDR,:LocDR)where DYLS_RowID=:Rowid)
	     
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_YardmanLocSet where DYLS_RowID=:Rowid)
	
    q SQLCODE
}

/// 函数名称:RetinueWardSet
/// 功能:陪检员关注病区设置
/// 输入参数:"AllInfo=Rowid^DispatcherDR^LocDR",OperateCode="I,U,D"
/// 返回:SQLCODE
/// 作者:孙毅
/// 日期:2014-09-16
/// w ##class(web.DHCRisCodeTableSet).RetinueWardSet("^2^19","I")
ClassMethod RetinueWardSet(AllInfo As %String, OperateCode As %String) As %String
{
	s (Rowid,DispatcherDR,LocDR)=""
	
	s Rowid=$P(AllInfo,"^",1)
	s RetinueDR=$P(AllInfo,"^",2) 
	s WardDR=$P(AllInfo,"^",3)
	
	s SameCount=0
	
	i (RetinueDR'="")&(WardDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_RetinueWardSet 
	         where DRWS_Retinue_DR=:RetinueDR And DRWS_Ward_DR=:WardDR) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_RetinueWardSet(DRWS_Retinue_DR,DRWS_Ward_DR) values(:RetinueDR,:WardDR))
	
	i OperateCode="U" d
	.&sql(UpDate  DHCRBC_RetinueWardSet(DRWS_Retinue_DR,DRWS_Ward_DR) 
	      values(:RetinueDR,:WardDR)where DRWS_RowID=:Rowid)
	     
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_RetinueWardSet where DRWS_RowID=:Rowid)
	
    q SQLCODE
}

/// 函数名称:QueryYardmanLoc
/// 功能:查询调度员所关注的科室
/// 输入参数:"DispatcherDR:调度员Rowid"
/// 返回:"RecLocRowid:%String,RecLoc:%String"
/// 作者:孙毅
/// 日期:2014-07-05
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryYardmanLoc","1")
Query QueryYardmanLoc(DispatcherDR As %String = "") As %Query(ROWSPEC = "RecLocRowid:%String,RecLoc:%String,Rowid:%String")
{
}

ClassMethod QueryYardmanLocExecute(ByRef qHandle As %Binary, DispatcherDR As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s (Rowid,RecLocRowid,RecLoc)=""
	
	i (DispatcherDR="")
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}

	f  s Rowid=$o(^DHCRBCYardmanLocSeti("Yardman-Loc",DispatcherDR,Rowid)) q:(Rowid="")  d
	.s (RecLocRowid,RecLoc)=""
	.s RecLocRowid=$p($g(^DHCRBCYardmanLocSet(Rowid)),"^",2)
	.i RecLocRowid'="" s RecLoc=$p($g(^CTLOC(RecLocRowid)),"^",2)
	.Do YardmanLoc
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
YardmanLoc
	set Data=$lb(RecLocRowid,RecLoc,Rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryYardmanLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryYardmanLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryYardmanLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryYardmanLocExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 函数名称:QueryRetinueWard
/// 功能:查询陪检员关注病区
/// 输入参数:"RetinueDR:陪检员Rowid"
/// 返回:"WardRowid:%String,Ward:%String"
/// 作者:孙毅
/// 日期:2014-07-05
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryRetinueWard","2")
Query QueryRetinueWard(RetinueDR As %String = "") As %Query(ROWSPEC = "WardRowid:%String,Ward:%String,Rowid:%String")
{
}

ClassMethod QueryRetinueWardExecute(ByRef qHandle As %Binary, RetinueDR As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s (Rowid,WardRowid,Ward)=""
	i (RetinueDR="")
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	
	f  s Rowid=$o(^DHCRBCRetinueWardSeti("Retinue-Ward",RetinueDR,Rowid)) q:(Rowid="")  d
	.s (WardRowid,Ward)=""
	.s WardRowid=$p($g(^DHCRBCRetinueWardSet(Rowid)),"^",2)
	.i WardRowid'="" s Ward=$p($g(^PAWARD(WardRowid)),"^",2)
	.Do RetinueWard
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
RetinueWard
	set Data=$lb(WardRowid,Ward,Rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryRetinueWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRetinueWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryRetinueWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRetinueWardExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 函数名称:QueryUserbyType
/// 功能:按类型0-1 查询配置人员
/// 输入参数:"Type"
/// 返回:"Rowid:%String,User:%String,UserID:%String"
/// 作者:孙毅
/// 日期:2014-07-05
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryUserbyType","1")
Query QueryUserbyType(Type As %String = "") As %Query(ROWSPEC = "Rowid:%String,User:%String,UserID:%String")
{
}

ClassMethod QueryUserbyTypeExecute(ByRef qHandle As %Binary, Type As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	

	s (Rowid)=""
	f  s Rowid=$o(^DHCRBCOutWorkerSet(Rowid)) q:(Rowid="")  d
	.s (User,TypeCode,UserID)=""
	.s UserID=$p($g(^DHCRBCOutWorkerSet(Rowid)),"^",1)
	.i UserID'="" s User=$p($g(^SSU("SSUSR",UserID)),"^",2)
	.s TypeCode=$p($g(^DHCRBCOutWorkerSet(Rowid)),"^",2)
	.q:(Type'="")&(Type'=TypeCode)
	.Do UserbyType
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
UserbyType
	set Data=$lb(Rowid,User,UserID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryUserbyTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserbyTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryUserbyTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserbyTypeExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 函数名称:ControlCenterSet
/// 功能:调度管理陪检人员设置
/// 输入参数:"AllInfo=Rowid^DispatcherDR^RetinueDR",OperateCode="I,U,D"
/// 返回:SQLCODE
/// 作者:孙毅
/// 日期:2014-09-16
/// w ##class(web.DHCRisCodeTableSet).ControlCenterSet("^1^2","I")
ClassMethod ControlCenterSet(AllInfo As %String, OperateCode As %String) As %String
{
	s (Rowid,DispatcherDR,RetinueDR)=""
	
	s Rowid=$P(AllInfo,"^",1)
	s DispatcherDR=$P(AllInfo,"^",2) 
	s RetinueDR=$P(AllInfo,"^",3)
	
	s SameCount=0	
	i (DispatcherDR'="")&(RetinueDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_ControlCenter 
	         where DCC_Dispatcher_DR=:DispatcherDR And DCC_Retinue_DR=:RetinueDR) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_ControlCenter(DCC_Dispatcher_DR,DCC_Retinue_DR) values(:DispatcherDR,:RetinueDR))
	
	i OperateCode="U" d
	.&sql(UpDate  DHCRBC_ControlCenter(DCC_Dispatcher_DR,DCC_Retinue_DR) 
	      values(:DispatcherDR,:RetinueDR)where DCC_RowID=:Rowid)
	     
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_ControlCenter where DCC_RowID=:Rowid)
	
    q SQLCODE
}

/// 函数名称:QueryUser
/// 功能:查询SSUSER表用户
/// 输入参数:"Code"
/// 返回:"Rowid:%String,User:%String,UserCode:%String"
/// 作者:孙毅
/// 日期:2014-07-05
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryUser","")
Query QueryUser(Code As %String = "") As %Query(ROWSPEC = "Rowid:%String,User:%String,UserCode:%String")
{
}

ClassMethod QueryUserExecute(ByRef qHandle As %Binary, Code As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s (Rowid)=""
	f  s Rowid=$o(^SSU("SSUSR",Rowid)) q:(Rowid="")  d
	.s (User,TypeCode,UserCode)=""
	.s User=$p($g(^SSU("SSUSR",Rowid)),"^",2)
	.q:(User=" ")
	.s UserCode=$p($g(^SSU("SSUSR",Rowid)),"^",1)
	.q:(Code'="")&(Code'[UserCode)
	.Do User
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
User
	set Data=$lb(Rowid,User,UserCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询名称：QueryUserType
/// 功能：查询用户管理类型
/// 参数：空
/// 返回：ROWID,管理类型 
/// 作者：孙毅
/// 日期：2014-09-16
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryUserType")
Query QueryUserType() As %Query(ROWSPEC = "TRowid:%String,TDesc:%String")
{
}

ClassMethod QueryUserTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	Set ^CacheTemp(repid,1)=$lb("0","陪检人员")
 	Set ^CacheTemp(repid,2)=$lb("1","调度人员")
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryUserTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserTypeExecute ]
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

ClassMethod QueryUserTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询病区信息
/// do ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryWard","") 
Query QueryWard(InDesc As %String) As %Query(ROWSPEC = "TRowid:%String,Desc:%String")
{
}

ClassMethod QueryWardExecute(ByRef qHandle As %Binary, InDesc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
    i (InDesc'="")
    {
      s Info=""
      s Info=InDesc
      s Info=$p($g(InDesc),"-",1)
      s InDesc= $ZCONVERT(Info,"U")
	  
    }
    
    s rowid=0 f  s rowid=$o(^PAWARD(rowid)) q:rowid=""  d
    .s Getdesc=$p($g(^PAWARD(rowid)),"^",2)
    .i (InDesc="") d
    ..Do OutRowQueryWard
    .i (InDesc'="")&(Getdesc[InDesc) d
    ..Do OutRowQueryWard
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRowQueryWard
	set Data=$lb(rowid,Getdesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWardExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod QueryWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 函数名称:QueryUserbyYardmanDR
/// 功能:查询SSUSER表用户
/// 输入参数:"Code"
/// 返回:"Rowid:%String,User:%String,UserID:%String"
/// 作者:孙毅
/// 日期:2014-07-05
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryUserbyYardmanDR","1")
Query QueryUserbyYardmanDR(YardmanDR As %String = "") As %Query(ROWSPEC = "Rowid:%String,User:%String,UserID:%String")
{
}

ClassMethod QueryUserbyYardmanDRExecute(ByRef qHandle As %Binary, YardmanDR As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s (UserID,User)=""
	s Rowid="" f  s Rowid=$o(^DHCRBCControlCenteri("Dispatcher",YardmanDR,Rowid)) q:(Rowid="")  d
	.s RetinueDR=$p($g(^DHCRBCControlCenter(Rowid)),"^",2)
	.q:(RetinueDR="") 
	.s UserID=$p($g(^DHCRBCOutWorkerSet(RetinueDR)),"^",1)
	.q:(UserID="")
	.s User=$p($g(^SSU("SSUSR",UserID)),"^",2)
    .Do User1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
User1
	set Data=$lb(Rowid,User,UserID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryUserbyYardmanDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserbyYardmanDRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryUserbyYardmanDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserbyYardmanDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询所有的执行病区
ClassMethod GetWardInfo(Desc As %String = "") As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryWard")
	s ret=""
	do rset.Execute(Desc)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// 根据调度员查询关注科室 
/// do ##class(web.DHCRisCodeTableSet).GetYardmanLoc("1")
ClassMethod GetYardmanLoc(DispatcherDR As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryYardmanLoc")
	s ret=""
	do rset.Execute(DispatcherDR)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// 根据陪检员查询关注病区 
/// do ##class(web.DHCRisCodeTableSet).GetRetinueWard("2")
ClassMethod GetRetinueWard(RetinueDR As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryRetinueWard")
	s ret=""
	do rset.Execute(RetinueDR)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// 查询陪检人员列表数据
/// w ##class(web.DHCRisCodeTableSet).GetRetinue()
ClassMethod GetRetinue() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryUserbyType")
	s ret=""
	do rset.Execute("0")
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// 查询调度员管理的陪检人员
/// w ##class(web.DHCRisCodeTableSet).GetAttentionUser("1")
ClassMethod GetAttentionUser(DispatcherDR) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryUserbyYardmanDR")
	s ret=""
	do rset.Execute(DispatcherDR)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	}
	
	d rset.Close()
	q ret
}

/// w ##class(web.DHCRisCodeTableSet).GetAttUser("1")
ClassMethod GetAttUser(DispatcherDR) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryUserbyYardmanDR")
	s ret=""
	do rset.Execute(DispatcherDR)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(3)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(3)_$C(1)_rset.GetData(2)
	}
	s pertet=""_$C(1)_""
	d rset.Close()
	s ret=pertet_"^"_ret
	q ret
}

/// 函数名称:YardmanLocSet
/// 功能:调度员关注开单科室设置
/// 输入参数:"AllInfo=Rowid^DispatcherDR^AdmLocDR",OperateCode="I,U,D"
/// 返回:SQLCODE
/// 作者:孙毅
/// 日期:2014-09-16
/// w ##class(web.DHCRisCodeTableSet).YardAdmLocSet("^1^15","I")
ClassMethod YardAdmLocSet(AllInfo As %String, OperateCode As %String) As %String
{
	s (Rowid,DispatcherDR,AdmLocDR)=""
	
	s Rowid=$P(AllInfo,"^",1)
	s DispatcherDR=$P(AllInfo,"^",2) 
	s AdmLocDR=$P(AllInfo,"^",3)
	
	s SameCount=0	
	i (DispatcherDR'="")&(AdmLocDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_YardAdmLocSet 
	         where DYAS_Dispatcher_DR=:DispatcherDR And DYAS_AdmLoc_DR=:AdmLocDR) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_YardAdmLocSet(DYAS_Dispatcher_DR,DYAS_AdmLoc_DR) values(:DispatcherDR,:AdmLocDR))
	
	i OperateCode="U" d
	.&sql(UpDate  DHCRBC_YardAdmLocSet(DYAS_Dispatcher_DR,DYAS_AdmLoc_DR) 
	      values(:DispatcherDR,:AdmLocDR)where DYAS_RowID=:Rowid)
	     
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_YardAdmLocSet where DYAS_RowID=:Rowid)
	
    q SQLCODE
}

/// 函数名称:QueryYardAdmLoc
/// 功能:查询调度员所关注的科室
/// 输入参数:"DispatcherDR:调度员Rowid"
/// 返回:"AdmLocRowid:%String,RecLoc:%String"
/// 作者:孙毅
/// 日期:2014-07-05
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryYardAdmLoc","1")
Query QueryYardAdmLoc(DispatcherDR As %String = "") As %Query(ROWSPEC = "AdmLocRowid:%String,RecLoc:%String,Rowid:%String")
{
}

ClassMethod QueryYardAdmLocExecute(ByRef qHandle As %Binary, DispatcherDR As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s (Rowid,RecLocRowid,RecLoc)=""
	
	i (DispatcherDR="")
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}

	f  s Rowid=$o(^DHCRBCYardAdmLocSeti("Yard-AdmLoc",DispatcherDR,Rowid)) q:(Rowid="")  d
	.s (AdmLocRowid,RecLoc)=""
	.s AdmLocRowid=$p($g(^DHCRBCYardAdmLocSet(Rowid)),"^",2)
	.i AdmLocRowid'="" s RecLoc=$p($g(^CTLOC(AdmLocRowid)),"^",2)
	.Do YardAdmLoc
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
YardAdmLoc
	set Data=$lb(AdmLocRowid,RecLoc,Rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryYardAdmLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryYardAdmLoccExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryYardAdmLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryYardAdmLocExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 根据调度员查询关注科室 
/// do ##class(web.DHCRisCodeTableSet).GetYardAdmLoc("1")
ClassMethod GetYardAdmLoc(DispatcherDR As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryYardAdmLoc")
	s ret=""
	do rset.Execute(DispatcherDR)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// 根据调度员查询关注科室(为查询时下拉列表使用) 
/// do ##class(web.DHCRisCodeTableSet).GetYardManAdmLoc("1")
ClassMethod GetYardManAdmLoc(DispatcherDR As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryYardAdmLoc")
	s ret=""
	do rset.Execute(DispatcherDR)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	s pertet=""_$C(1)_""
	d rset.Close()
	s ret=pertet_"^"_ret
	q ret
}

/// ---------------------------------积水潭增加2015.03.15------------------------------
/// 函数名称:MuscleNameSet
/// 功能:设置肌肉名称
/// 输入参数:"AllInfo=Rowid^Code^Desc, OperateCode="I,U,D"
/// 返回:SQLCODE
/// 作者:孙毅
/// 日期:2014-03-15
/// w ##class(web.DHCRisCodeTableSet).MuscleNameSet("^GSTJ^肱三头肌","I")
ClassMethod MuscleNameSet(AllInfo As %String, OperateCode As %String) As %String
{
	s (Rowid,Code,Desc)=""
	s Rowid=$P(AllInfo,"^",1)
	s Code=$P(AllInfo,"^",2) 
	s Desc=$P(AllInfo,"^",3)
	
	s SameCount=0
	i (Code'="")!(Desc'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_MuscleName
	       where DMN_Desc=:Desc OR DMN_Code=:Code) 
	       
	i SameCount'=0  s SQLCODE=-1
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_MuscleName(DMN_Desc,DMN_Code) values(:Desc,:Code))
	
	i OperateCode="U" d
	.&sql(UpDate  DHCRBC_MuscleName(DMN_Desc,DMN_Code) values(:Desc,:Code)where DMN_RowID =:Rowid)
	     
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_MuscleName where DMN_RowID =:Rowid)
	
    q SQLCODE
}

/// 函数名称:QueryMuscle
/// 功能:查询肌肉名称数据
/// 输入参数:"Desc^Code"
/// 返回:"Rowid:%String,TMDesc:%String,TMCode:%String"
/// 作者:孙毅
/// 日期:2015-03-15
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryMuscle","")
Query QueryMuscle(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,TMDesc:%String,TMCode:%String")
{
}

ClassMethod QueryMuscleExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s GetDesc=$p($g(Info),"^",1)
	s GetCode=$p($g(Info),"^",2)
	s (Rowid)=""
	f  s Rowid=$o(^DHCRBCMuscleName(Rowid)) q:(Rowid="")  d
	.s (MDesc,MCode)=""
	.s MDesc=$p($g(^DHCRBCMuscleName(Rowid)),"^",1)
	.s MCode=$p($g(^DHCRBCMuscleName(Rowid)),"^",2)
	.q:(GetCode'="")&(MCode'[GetCode)
	.q:(GetDesc'="")&(MCode'[GetDesc)
	.Do Muscle
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Muscle
	set Data=$lb(Rowid,$g(MDesc),$g(MCode))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryMuscleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMuscleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryMuscleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMuscleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 函数名称:BodyPartMuscleSet
/// 功能:检查部位与肌肉关联设置
/// 输入参数:"AllInfo=Rowid^Code^Desc, OperateCode="I,U,D"
/// 返回:SQLCODE
/// 作者:孙毅
/// 日期:2014-03-15
/// w ##class(web.DHCRisCodeTableSet).BodyPartMuscleSet("^13^1","I")
ClassMethod BodyPartMuscleSet(AllInfo As %String, OperateCode As %String) As %String
{
	s (Rowid,Code,Desc)=""
	s Rowid=$P(AllInfo,"^",1)
	s BodyPartDR=$P(AllInfo,"^",2) 
	s MuscleDR=$P(AllInfo,"^",3)
	
	s SameCount=0
	i (MuscleDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_BodyPartMuscleSet
	       where DBPM_Muscle_DR=:MuscleDR) 
	       
	i SameCount'=0  s SQLCODE=-1
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_BodyPartMuscleSet(DBPM_BodyPart_DR,DBPM_Muscle_DR) values(:BodyPartDR,:MuscleDR))
	
	i OperateCode="U" d
	.&sql(UpDate  DHCRBC_BodyPartMuscleSet(DBPM_BodyPart_DR,DBPM_Muscle_DR) values(:BodyPartDR,:MuscleDR)where DBPM_RowID =:Rowid)
	     
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_BodyPartMuscleSet where DBPM_RowID =:Rowid)
	
    q SQLCODE
}

/// 函数名称:QueryBodyPartMuscle
/// 功能:查询检查部位关联的肌肉名称数据
/// 输入参数:"GetBodyPartDR^GetMuscleDR"
/// 返回:"Rowid:%String,TBodyPart:%String,TMuscleName:%String,TBodyPartDR:%String,MuscleDR:%String"
/// 作者:孙毅
/// 日期:2015-03-15
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryBodyPartMuscle","")
Query QueryBodyPartMuscle(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,TBodyPart:%String,TMuscleName:%String,TBodyPartDR:%String,MuscleDR:%String")
{
}

ClassMethod QueryBodyPartMuscleExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s GetBodyPartDR=$p($g(Info),"^",1)
	s GetMuscleDR=$p($g(Info),"^",2)
	s (Rowid)=""
	f  s Rowid=$o(^DHCRBCBodyPartMuscleSet(Rowid)) q:(Rowid="")  d
	.s (BodyPartDR,MuscleDR,BodyPart,MuscleName)=""
	.s BodyPartDR=$p($g(^DHCRBCBodyPartMuscleSet(Rowid)),"^",1)
	.s MuscleDR=$p($g(^DHCRBCBodyPartMuscleSet(Rowid)),"^",2)
	.q:(GetBodyPartDR'="")&(GetBodyPartDR'=BodyPartDR)
	.q:(GetMuscleDR'="")&(GetMuscleDR'=MuscleDR)
	.i BodyPartDR'="" s BodyPart=$p($g(^MRC("BODP",BodyPartDR)),"^",2)
	.i MuscleDR'="" s MuscleName=$p($g(^DHCRBCMuscleName(MuscleDR)),"^",1)
	.Do BodyPartMuscle
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BodyPartMuscle
	set Data=$lb(Rowid,$g(BodyPart),$g(MuscleName),$g(BodyPartDR),$g(MuscleDR))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryBodyPartMuscleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBodyPartMuscleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryBodyPartMuscleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBodyPartMuscleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 函数名称:GetData
/// 功能:解析保存的肌电数据
/// 入参:BodyPartsDR:MuscleDR^.....
/// 返回值:部位:肌肉名称1、肌肉名称2.../n/r部位2:肌肉名称3、肌肉名称4
/// 作者:sunyi 2015-03-26
/// w ##class(web.DHCRisCodeTableSet).GetData("13:1^3:3^13:2")
ClassMethod GetData(Info As %String) As %String
{
	s DataCount=0
	s DataCount=$l(Info,"^")
	
	for i=1:1:DataCount
	{
		s perData=$p(Info,"^",i)
		q:(perData="")
		s perBodyDR="", perMuscleDR=""
		s perBodyDR=$p(perData,":",1)
		q:(perBodyDR="")
		s perMuscleDR=$p(perData,":",2)
		
		s BodyParts="",Muscle=""
		i perMuscleDR'="" s Muscle=$p($g(^DHCRBCMuscleName(perMuscleDR)),"^",1)
		s BodyParts=$p($g(^MRC("BODP",perBodyDR)),"^",2)
		
	    i $g(SameBodyPartDR(perBodyDR))="" d
        .s SameBodyPartDR(perBodyDR)=BodyParts_":"_Muscle
        e  d
        .s SameBodyPartDR(perBodyDR)=SameBodyPartDR(perBodyDR)_"、"_Muscle
	}
	
	s SameInfo=""
	s Rowid=0 f  s Rowid=$o(SameBodyPartDR(Rowid)) q:(Rowid="")  d
	.i SameInfo="" d
	..s SameInfo=SameBodyPartDR(Rowid)
	.e  d
	..s SameInfo=SameInfo_$c(10,13)_SameBodyPartDR(Rowid)

	k SameBodyPartDR
	
	q SameInfo
}

/// 函数名称:LocStatusMapSet
/// 功能:RIS4.0与RIS3.0对应表
/// 输入参数:"AllInfo=Rowid^LocDR^Code^Desc, OperateCode="I,U,D"
/// 返回:SQLCODE
/// 作者:孙毅
/// 日期:2014-03-15
/// w ##class(web.DHCRisCodeTableSet).LocStatusMapSet("^83^A^申请","I")
ClassMethod LocStatusMapSet(AllInfo As %String, OperateCode As %String) As %String
{
	s (Rowid,Code,Desc)=""
	s Rowid=$P(AllInfo,"^",1)
	s LocDR=$P(AllInfo,"^",2) 
	s Code=$P(AllInfo,"^",3) 
	s Desc=$P(AllInfo,"^",4) 
	
	s SameCount=0
	i (LocDR'="")&(Code'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_LocStatus
	       where DLS_LOC_DR=:LocDR And DLS_StatusCode=:Code) 
	       
	i SameCount'=0  s SQLCODE=-1
	         
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_LocStatus(DLS_LOC_DR,DLS_StatusCode,DLS_StatusDesc) values(:LocDR,:Code,:Desc))
	
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_LocStatus(DLS_LOC_DR,DLS_StatusCode,DLS_StatusDesc) values(:LocDR,:Code,:Desc)where DLS_Rowid =:Rowid)
	     
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_LocStatus where DLS_Rowid =:Rowid)
	
    q SQLCODE
}

/// 函数名称:QueryLocStatus
/// 功能:查询RIS4.0与RIS3.0科室状态对应表
/// 输入参数:"GetLocDR^GetStatusCode"
/// 返回:"Rowid:%String,TLocDR:%String,TCode:%String,TDesc:%String"
/// 作者:孙毅
/// 日期:2015-03-15
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryLocStatus","")
Query QueryLocStatus(Info As %String = "") As %Query(ROWSPEC = "Rowid:%String,TRecLoc:%String,TLocDR:%String,TCode:%String,TDesc:%String")
{
}

ClassMethod QueryLocStatusExecute(ByRef qHandle As %Binary, Info As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s GetLocDR=$p($g(Info),"^",1)
	s GetStatusCode=$p($g(Info),"^",2)
	s (Rowid)=""
	f  s Rowid=$o(^DHCRBCLocStatus("Status",Rowid)) q:(Rowid="")  d
	.s (LocDR,Code,Desc,RecLoc)=""
	.s LocDR=$p($g(^DHCRBCLocStatus("Status",Rowid)),"^",1)
	.i LocDR'="" s RecLoc=$p($g(^CTLOC(LocDR)),"^",2)
	.s Code=$p($g(^DHCRBCLocStatus("Status",Rowid)),"^",2)
	.s Desc=$p($g(^DHCRBCLocStatus("Status",Rowid)),"^",3)
	.q:(GetLocDR'="")&(GetLocDR'=LocDR)
	.q:(GetStatusCode'="")&(GetStatusCode'=Code)
	.Do QLocStatus
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QLocStatus
	set Data=$lb(Rowid,$g(RecLoc),$g(LocDR),$g(Code),$g(Desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryLocStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocStatusExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryLocStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ///////////////////////////////////////////同仁2015-10-22add/////////////////////////////
/// 函数名称:ItemUseAppLocSet
/// 功能:设置医嘱项目使用的申请科室
/// 输入参数:"AllInfo=Rowid^ArcItemRowid^AppLocDR, OperateCode="I,U,D"
/// 返回:SQLCODE
/// 作者:孙毅
/// 日期:2015-10-22
/// w ##class(web.DHCRisCodeTableSet).ItemUseAppLocSet("^8866||1^36","I")
ClassMethod ItemUseAppLocSet(AllInfo As %String, OperateCode As %String) As %String
{
	s (Rowid,Code,Desc)=""
	s Rowid=$P(AllInfo,"^",1)
	s ArcItemRowid=$P(AllInfo,"^",2) 
	s AppLocDR=$P(AllInfo,"^",3) 
	
	s SameCount=0
	i (ArcItemRowid'="")&(AppLocDR'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_ArcItemAppLoc
	       where DAA_ArcItem_DR=:ArcItemRowid And DAA_AppLoc_DR=:AppLocDR) 
	       
	i SameCount'=0  s SQLCODE=-1
	         
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_ArcItemAppLoc(DAA_ArcItem_DR,DAA_AppLoc_DR) values(:ArcItemRowid,:AppLocDR))
	
	i OperateCode="U" d
	.&sql(UpDate DHCRBC_ArcItemAppLoc(DAA_ArcItem_DR,DAA_AppLoc_DR) values(:ArcItemRowid,:AppLocDR)where DAA_RowID =:Rowid)
	     
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_ArcItemAppLoc where DAA_RowID =:Rowid)
	
    q SQLCODE
}

/// 函数名称:QueryItemUseAppLoc
/// 功能:查询检查项目关联的申请科室
/// 输入参数:"ArcItemRowid"
/// 返回:"Rowid:%String,TAppLoc:%String,TAppLocDR:%String,TArcItemDR:%String"
/// 作者:孙毅
/// 日期:2015-10-22
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryItemUseAppLoc","8866||1")
Query QueryItemUseAppLoc(ArcItemRowid As %String = "") As %Query(ROWSPEC = "Rowid:%String,TAppLoc:%String,TAppLocDR:%String,TArcItemDR:%String")
{
}

ClassMethod QueryItemUseAppLocExecute(ByRef qHandle As %Binary, ArcItemRowid As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s (Rowid,AppLocDR,AppLoc)=""
	
	i (ArcItemRowid="")
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	
	s AppLocRowid="",Rowid=""
	f  s AppLocRowid=$o(^DHCRBCArcItemAppLoci("ARC-APPLOC",ArcItemRowid,AppLocRowid)) q:(AppLocRowid="")  d 
    .f  s Rowid=$o(^DHCRBCArcItemAppLoci("ARC-APPLOC",ArcItemRowid,AppLocRowid,Rowid)) q:(Rowid="")  d
	..s (AppLocDR,AppLoc,ArcItemDR)=""
	..s AppLocDR=$p($g(^DHCRBCArcItemAppLoc(Rowid)),"^",2)
	..i AppLocDR'="" s AppLoc=$p($g(^CTLOC(AppLocDR)),"^",2)
	..s ArcItemDR=$p($g(^DHCRBCArcItemAppLoc(Rowid)),"^",1)
	..Do OutApp
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutApp
	set Data=$lb(Rowid,$g(AppLoc),$g(AppLocDR),$g(ArcItemDR))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryItemUseAppLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemUseAppLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryItemUseAppLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemUseAppLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCRisCodeTableSet).GetArcItemLoc("8866||1")
ClassMethod GetArcItemLoc(ArcItemRowid As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryItemUseAppLoc")
	s ret=""
	do rset.Execute(ArcItemRowid)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// 函数名称:EqAddressSet
/// 功能:设备地址设置
/// 输入参数:"AllInfo=EqDR^Address"
/// 返回:SQLCODE
/// 作者:孙毅
/// 日期:2015-10-22
/// w ##class(web.DHCRisCodeTableSet).EqAddressSet("7^病房楼3层第一门诊部")
ClassMethod EqAddressSet(AllInfo As %String) As %String
{
	s (Rowid,EqDR,Address)=""
	s EqDR=$P(AllInfo,"^",1) 
	s Address=$P(AllInfo,"^",2) 
	
	i (EqDR'="") d
	.s Rowid=$o(^DHCRBCEquipmentAddressi(EqDR,Rowid))
	       
	i Rowid="" d
	.&sql(Insert into DHCRBC_Equipment_Address(DEA_Equipment_DR,DEA_Address) values(:EqDR,:Address))
	e  d
	.&sql(UpDate DHCRBC_Equipment_Address(DEA_Equipment_DR,DEA_Address) values(:EqDR,:Address)where DEA_RowID =:Rowid)
	   
    q SQLCODE
}

/// 函数名称:QueryEQ
/// 功能:查询设备表记录
/// 输入参数:"EQDR"
/// 返回:"Rowid:%String,TDesc:%String"
/// 作者:孙毅
/// 日期:2015-10-22
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryEQ","")
Query QueryEQ(EqRowid As %String = "") As %Query(ROWSPEC = "Rowid:%String,TDesc:%String")
{
}

ClassMethod QueryEQExecute(ByRef qHandle As %Binary, EqRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ^RIS("2015")=EqRowid
	s Rowid="0" f  s Rowid=$O(^RBC("EQ",Rowid)) q:(Rowid="")  d
	.q:(EqRowid'="")&(EqRowid'=Rowid)
    .s Code=$p(^RBC("EQ",Rowid),"^",1)
    .S Desc=$p(^RBC("EQ",Rowid),"^",2)
	.Do OutEQ
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutEQ
	set Data=$lb(Rowid,$g(Desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryEQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEQExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryEQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 函数名称:GetEqAddress
/// 功能:根据设备ID获取地址
/// 输入参数:"EqDR"
/// 返回:"Address"
/// 作者:孙毅
/// 日期:2015-10-22
/// d ##class(web.DHCRisCodeTableSet).GetEqAddress("7")
ClassMethod GetEqAddress(EqDR As %String) As %String
{
	s Address="",Rowid=""
	i (EqDR'="") d
	.s Rowid=$o(^DHCRBCEquipmentAddressi(EqDR,Rowid))
	.i Rowid'="" s Address=$p(^DHCRBCEquipmentAddress(Rowid),"^",2)
	q Address
}

/// 函数名称:QueryAppLoc
/// 功能:查询科室记录
/// 输入参数:"EQDR"
/// 返回:"TLocName:%String,TRowid:%String"
/// 作者:孙毅
/// 日期:2015-10-22
/// d ##class(%ResultSet).RunQuery("web.DHCRisCodeTableSet","QueryAppLoc","")
Query QueryAppLoc(Desc As %String) As %Query(ROWSPEC = "TLocName:%String,TRowid:%String")
{
}

ClassMethod QueryAppLocExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	/*s LocType="E"
	Set RowId=0	f  s RowId=$o(^CTLOC(0,"LocType",LocType,RowId)) q:RowId=""  d
	.s GetDesc=$p(^CTLOC(RowId),"^",2) 
	.i (GetDesc[Desc) d
	..Do OutputRow*/

 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s LocType=""
 	s Desc=$ZCONVERT(Desc,"U") 
	Set RowId=0	f  s RowId=$o(^CTLOC(RowId)) q:RowId=""  d
	.s GetDesc=$p(^CTLOC(RowId),"^",2)
	.q:(GetDesc="")
	.s Gettype=$p(^CTLOC(RowId),"^",13)
	.q:(LocType'="")&(Gettype'=LocType)
	.i (GetDesc[Desc) d
	..Do OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(GetDesc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryAppLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppLocExecute ]
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

ClassMethod QueryAppLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询所有科室
ClassMethod GetLocInfo(Desc As %String = "") As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryAppLoc")
	s ret=""
	do rset.Execute(Desc)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(2)_$C(1)_rset.GetData(1)
	    e  s ret=ret_"^"_rset.GetData(2)_$C(1)_rset.GetData(1)
	}	
	d rset.Close()
	q ret
}

/// 函数名称:GetEqList
/// 功能:获取格式化的设备信息
/// 输入参数:
/// 返回:"1GE CT-1^2消化镜-2^..."
/// 作者:孙毅
/// 日期:2015-10-22
/// d ##class(web.DHCRisCodeTableSet).GetEqList()
ClassMethod GetEqList() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCodeTableSet:QueryRBCEquipment")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(3)_"-"_rset.GetData(1)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(3)_"-"_rset.GetData(1)
	}	
	d rset.Close()
	q ret
}

}
