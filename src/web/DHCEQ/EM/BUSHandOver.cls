Class web.DHCEQ.EM.BUSHandOver Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Add By ZC 2021-08-10
/// 描述:根据科室获取设备清单
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSHandOver","GetEquipList","127","86")
Query GetEquipList(vLocDR As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TItemDR:%String,TNo:%String,TName:%String,TModel:%String,TOriginalFee:%String,TEquipType:%String,TStoreLoc:%String,TStoreLocDR:%String,TManuFactory:%String,TLeaveFactoryNo:%String,TUnit:%String,TUseLoc:%String,TFileNo:%String,TAdvanceDisFlag:%String,TEquipStatus:%String") [ SqlProc ]
{
}

ClassMethod GetEquipListExecute(ByRef qHandle As %Binary, vLocDR As %String = "", CurGroupID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1

	s StoreLocDR=0
	f  s StoreLocDR=$o(^DHCEQEquip(0,"StoreEquipType","N",1,StoreLocDR))  q:StoreLocDR=""  d
	.q:(vLocDR'="")&&(StoreLocDR'=vLocDR)
	.s EquipTypeDR=0
	.f  s EquipTypeDR=$o(^DHCEQEquip(0,"StoreEquipType","N",1,StoreLocDR,EquipTypeDR))  q:EquipTypeDR=""  d
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,CurGroupID)=1
	..s EQRowID=0
	..f  s EQRowID=$o(^DHCEQEquip(0,"StoreEquipType","N",1,StoreLocDR,EquipTypeDR,EQRowID))  q:EQRowID=""  d
	...d ResetVariablesGetEquipList
	...q:##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("02","3",EQRowID)'="Y"
	...q:(##Class(web.DHCEQ.EM.BUSEquipAttribute).GetOneEquipAttribute("3",EQRowID)'["id3")
	...;q:##Class(web.DHCEQ.EM.BUSHandOver).CheckEquipIsInRent(EQRowID)=1
	...q:$p($g(^DHCEQEquip(EQRowID)),"^",93)="2"
	...s TAdvanceDisFlag=0
	...s TRowID=EQRowID
	...s TItemDR=$p($g(^DHCEQEquip(EQRowID)),"^",7)
	...s TNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	...s TName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	...s TCode=$p($g(^DHCEQEquip(EQRowID)),"^",6)
	...s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQEquip(EQRowID)),"^",3))
	...s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",27))
	...s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)
	...s TStoreLocDR=StoreLocDR
	...s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	...s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p($g(^DHCEQEquip(EQRowID)),"^",26)) 
	...s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p($g(^DHCEQEquip(EQRowID)),"^",5)) 
	...s TLeaveFactoryNo=$p($g(^DHCEQEquip(EQRowID)),"^",10)
	...s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(EQRowID)),"^",19))
	...s TFileNo=$p($g(^DHCEQEquip(EQRowID)),"^",85)
	...i ((",3,4,")[(","_$p($g(^DHCEQEquip(EQRowID)),"^",93)_",")) d
	....s TAdvanceDisFlag=1
	...e  i ((",1,")[(","_$p($g(^DHCEQEquip(EQRowID)),"^",93)_",")) d
	....s TAdvanceDisFlag=2
	...i ##Class(web.DHCEQ.EM.BUSHandOver).CheckEquipIsInRent(EQRowID)=1  s TAdvanceDisFlag=3
	...s TEquipStatus=$case(TAdvanceDisFlag,0:"正常",1:"维修中",2:"报废中",3:"调配中",:"未知")
	...d OutputRowGetEquipList

	s rowid=0
	f  s rowid=$o(^DHCEQSShareResource(rowid))  quit:rowid=""  d
	.d ResetVariablesGetEquipList
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",19)="N"
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",15)'="1"
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",14)'=vLocDR
	.s EquipDR=$p($g(^DHCEQSShareResource(rowid)),"^",3)
	.q:##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("02","3",EquipDR)'="Y"
	.s TRowID=EquipDR
	.s TItemDR=$p($g(^DHCEQEquip(EquipDR)),"^",7)
	.s TNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	.s TName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	.s TCode=$p($g(^DHCEQEquip(TRowID)),"^",6)
	.s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQEquip(EquipDR)),"^",3))
	.s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EquipDR)),"^",27))
	.s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p($g(^DHCEQEquip(EquipDR)),"^",63))
	.s TStoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
	.s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	.s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p($g(^DHCEQEquip(EquipDR)),"^",26)) 
	.s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p($g(^DHCEQEquip(EquipDR)),"^",5)) 
	.s TLeaveFactoryNo=$p($g(^DHCEQEquip(TRowID)),"^",10)
	.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(EquipDR)),"^",19))_"(调出)"
	.s TFileNo=$p($g(^DHCEQEquip(TRowID)),"^",85)
	.s TAdvanceDisFlag=3
	.s TEquipStatus=$case(TAdvanceDisFlag,0:"正常",1:"维修中",2:"报废中",3:"调配中",:"未知")
	.d OutputRowGetEquipList
	
	
	Quit $$$OK
OutputRowGetEquipList
	s Data=$lb(TRowID,TItemDR,TNo,TName,TModel,TOriginalFee,TEquipType,TStoreLoc,TStoreLocDR,TManuFactory,TLeaveFactoryNo,TUnit,TUseLoc,TFileNo,TAdvanceDisFlag,TEquipStatus)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipList
	s (TRowID,TItemDR,TNo,TName,TModel,TOriginalFee,TEquipType,TStoreLoc,TStoreLocDR,TManuFactory,TLeaveFactoryNo,TUnit,TUseLoc,TFileNo,EquipDR,TAdvanceDisFlag,TEquipStatus)=""
	quit
}

ClassMethod GetEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipListExecute ]
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

ClassMethod GetEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.BUSHandOver).CheckEquipIsInRent(1764)
ClassMethod CheckEquipIsInRent(EquipDR As %String = "")
{
	i EquipDR="" q "0"
	s Flag=1
	i '$d(^DHCEQSShareResource(0,"Equip",EquipDR)) q 0
	s ShareResourceDR=$o(^DHCEQSShareResource(0,"Equip",EquipDR,""))
	i ShareResourceDR="" q 0
	i $p($g(^DHCEQSShareResource(ShareResourceDR)),"^",19)'="Y" q Flag
	i $p($g(^DHCEQSShareResource(ShareResourceDR)),"^",15)'="0" q Flag
	s Flag=0
	q Flag
}

/// Add By ZC 2021-08-10
/// 描述:根据人员与日期获取待处理交班记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSHandOver","GetHandOver","1486","2021-08-16")
Query GetHandOver(vUser As %String = "", vDate As %String = "") As %Query(ROWSPEC = "HORowID:%String,TNo:%String,TName:%String,TModel:%String,TManuFactory:%String,TLeaveFactoryNo:%String,TUnit:%String,TUseLoc:%String,HOUser:%String,HODate:%String,HOTime:%String,HOEquipStatus:%String,HORemark:%String,HOEquipStatusDesc:%String") [ SqlProc ]
{
}

ClassMethod GetHandOverExecute(ByRef qHandle As %Binary, vUser As %String = "", vDate As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (vUser="")||(vDate="") Quit $$$OK
	s vDate=##Class(web.DHCEQCommon).TransValueFromPage(vDate,"date")
	s rowid=0
	f  s rowid=$o(^DHCEQHandOverList(0,"Date",vDate,rowid))  quit:rowid=""  d
	.d ResetVariablesGetHandOver
	.q:$p($g(^DHCEQHandOverList(rowid)),"^",12)="2"
	.q:$p($g(^DHCEQHandOverList(rowid)),"^",8)'=vUser
	.s EquipDR=$p($g(^DHCEQHandOverList(rowid)),"^",2)
	.s TNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	.s TName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	.s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQEquip(EquipDR)),"^",3))
	.s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p($g(^DHCEQEquip(EquipDR)),"^",26)) 
	.s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p($g(^DHCEQEquip(EquipDR)),"^",5)) 
	.s TLeaveFactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
	.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(EquipDR)),"^",19))
	.s TDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQHandOverList(rowid)),"^",5),"date")
	.s TTime=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQHandOverList(rowid)),"^",6),"time")
	.s TUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQHandOverList(rowid)),"^",7)) 
	.s TRowID=rowid
	.s TEquipStatus=$p($g(^DHCEQHandOverList(rowid)),"^",11)
	.s TRemark=$p($g(^DHCEQHandOverList(rowid)),"^",13)
	.s TEquipStatusDesc=$CASE(TEquipStatus,"0":"正常","1":"异常","":"")
	.d OutputRowGetHandOver
	
	
	Quit $$$OK
OutputRowGetHandOver
	s Data=$lb(TRowID,TNo,TName,TModel,TManuFactory,TLeaveFactoryNo,TUnit,TUseLoc,TUser,TDate,TTime,TEquipStatus,TRemark,TEquipStatusDesc)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetHandOver
	s (TRowID,TNo,TName,TModel,TManuFactory,TLeaveFactoryNo,TUnit,TUseLoc,TUser,TDate,TTime,TEquipStatus,TRemark)=""
	quit
}

ClassMethod GetHandOverFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHandOverExecute ]
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

ClassMethod GetHandOverClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHandOverExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zc 2021-08-11
/// 急救设备交班
/// w ##Class(web.DHCEQ.EM.BUSHandOver).BatchHandOver("281,283","1486",71)
ClassMethod BatchHandOver(RowIDs As %Library.String = "", val As %Library.String = "", vUser As %Library.String = "")
{
	new (RowIDs,val,vUser)
	s flag=0
	s SQLCODE=0
	s (HOUserDR,HOLocDR)=""
	s HOUserDR= $p(val,"^",1)
	s HOLocDR= $p(val,"^",2)
	if (HOUserDR="")||(vUser="") q "无接班人信息不能交班"
	k PLIST
	s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQHandOver",+$H,HOLocDR)
	s PLIST(3)="1"
	s PLIST(4) = HOLocDR 
	s PLIST(5) = +$H
	s PLIST(6) = $P($H,",",2)
	s PLIST(7)=vUser
	s PLIST(8)=HOUserDR
	s PLIST(11) = "1" 
	s PLIST(18) = "N"   
	&SQL(insert into SQLUSER.DHC_EQHandOver Values :PLIST())
	i SQLCODE q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	s HORowID=$G(%ROWID)
	s Length=$l(RowIDs,",")
	for n=1:1:Length
	{
		q:flag'=0
		s HOEquipDR=""
		s HOEquipDR=$p(RowIDs,",",n)
		q:HOEquipDR=""
		k RPLIST
		s RPLIST(2)=HORowID
		s RPLIST(3)=HOEquipDR
		s RPLIST(4) =$p($g(^DHCEQEquip(HOEquipDR)),"^",67)
		s RPLIST(5) = HOLocDR 
		s RPLIST(6) = +$H
		s RPLIST(7) = $P($H,",",2)
		s RPLIST(8)=vUser
		s RPLIST(9)=HOUserDR
		s RPLIST(12) = "0" 
		s RPLIST(13) = "1"	;Status
		s RPLIST(20) = "N"  
		s RPLIST(15) = "0" 
		i ((",3,4,")[(","_$p($g(^DHCEQEquip(HOEquipDR)),"^",93)_",")) d
		.s RPLIST(15)=1
		e  i ((",1,")[(","_$p($g(^DHCEQEquip(HOEquipDR)),"^",93)_",")) d
		.s RPLIST(15)=2
		i ##Class(web.DHCEQ.EM.BUSHandOver).CheckEquipIsInRent(HOEquipDR)=1  s RPLIST(15)=3 
		&SQL(insert into SQLUSER.DHC_EQHandOverList Values :RPLIST())
		s flag=SQLCODE
		q:flag'=0
		
	}
	
 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(flag)
}

/// Add By ZC 2021-08-10
/// 描述:获取科室设备记录清单
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSHandOver","GetHandOverList","125","2021-08-17","")
Query GetHandOverList(vLocDR As %String = "", SDate As %String = "", EDate As %String = "") As %Query(ROWSPEC = "HORowID:%String,TNo:%String,TName:%String,TModel:%String,TManuFactory:%String,TLeaveFactoryNo:%String,TUnit:%String,TUseLoc:%String,HOUser:%String,HODate:%String,HOTime:%String,HOEquipStatus:%String,HORemark:%String,HOEquipStatusDesc:%String,HOToDate:%String,HOToTime:%String,HOToUser:%String,HOLoc:%String") [ SqlProc ]
{
}

ClassMethod GetHandOverListExecute(ByRef qHandle As %Binary, vLocDR As %String = "", SDate As %String = "", EDate As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s SDate=##Class(web.DHCEQCommon).TransValueFromPage(SDate,"date")
	i SDate="" s SDate=0
	s EDate=##Class(web.DHCEQCommon).TransValueFromPage(EDate,"date")
	i EDate="" s EDate=+$h
	d ##Class(web.DHCEQCommon).KillTempGlobal("GetHandOverList") 
	s holrowid=0
	f  s holrowid=$o(^DHCEQHandOverList(holrowid))  quit:holrowid=""  d
	.q:$p($g(^DHCEQHandOverList(holrowid)),"^",19)="Y"
	.q:$p($g(^DHCEQHandOverList(holrowid)),"^",5)<SDate
	.q:$p($g(^DHCEQHandOverList(holrowid)),"^",5)>EDate
	.q:(vLocDR'="")&&($p($g(^DHCEQHandOverList(holrowid)),"^",4)'=vLocDR)
	.s EQEquipDR=$p($g(^DHCEQHandOverList(holrowid)),"^",2)
	.s MasterItem=$p($g(^DHCEQEquip(EQEquipDR)),"^",7)
	.s ^DHCEQTemp("GetHandOverList",$j,MasterItem,holrowid)=""
	
	
	s EQMasterItem=0
	f  s EQMasterItem=$o(^DHCEQTemp("GetHandOverList",$j,EQMasterItem))  quit:EQMasterItem=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQTemp("GetHandOverList",$j,EQMasterItem,rowid))  quit:rowid=""  d
	..d ResetVariablesGetHandOverList
	..s EquipDR=$p($g(^DHCEQHandOverList(rowid)),"^",2)
	..s TNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	..s TName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	..s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQEquip(EquipDR)),"^",3))
	..s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p($g(^DHCEQEquip(EquipDR)),"^",26)) 
	..s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p($g(^DHCEQEquip(EquipDR)),"^",5)) 
	..s TLeaveFactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
	..s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(EquipDR)),"^",19))
	..s TDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQHandOverList(rowid)),"^",5),"date")
	..s TTime=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQHandOverList(rowid)),"^",6),"time")
	..s TUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQHandOverList(rowid)),"^",7)) 
	..s TRowID=rowid
	..s TEquipStatus=$p($g(^DHCEQHandOverList(rowid)),"^",11)
	..s TRemark=$p($g(^DHCEQHandOverList(rowid)),"^",13)
	..s TEquipStatusDesc=$CASE(TEquipStatus,"0":"正常","1":"异常","":"")
	..s TToDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQHandOverList(rowid)),"^",9),"date")
	..s TToTime=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQHandOverList(rowid)),"^",10),"time")
	..s TToUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQHandOverList(rowid)),"^",8)) 
	..s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQHandOverList(rowid)),"^",4))
	..d OutputRowGetHandOverList
	
	
	Quit $$$OK
OutputRowGetHandOverList
	s Data=$lb(TRowID,TNo,TName,TModel,TManuFactory,TLeaveFactoryNo,TUnit,TUseLoc,TUser,TDate,TTime,TEquipStatus,TRemark,TEquipStatusDesc,TToDate,TToTime,TToUser,TLoc)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetHandOverList
	s (TRowID,TNo,TName,TModel,TManuFactory,TLeaveFactoryNo,TUnit,TUseLoc,TUser,TDate,TTime,TEquipStatus,TRemark,TToDate,TToTime,TToUser,TLoc)=""
	quit
}

ClassMethod GetHandOverListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHandOverListExecute ]
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

ClassMethod GetHandOverListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHandOverListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class("web.DHCEQ.EM.BUSHandOver").CheckEquipHasHandOver("1")
ClassMethod CheckEquipHasHandOver(EquipDR)
{
	i EquipDR="" q "0^"
	s Flag=0
	s vDate=+$h
	s rowid=0
	f  s rowid=$o(^DHCEQHandOverList(0,"Equip",EquipDR,rowid))  quit:(rowid="")||(Flag'=0)  d
	.q:$p($g(^DHCEQHandOverList(rowid)),"^",5)'=vDate
	.q:$p($g(^DHCEQHandOverList(rowid)),"^",12)'=2
	.s Flag=1
	i Flag=0 q "0^"
	i Flag'=0 q "-1^"_$p($g(^DHCEQEquip(EquipDR)),"^",1)_"("_$p($g(^DHCEQEquip(EquipDR)),"^",71)_")今天存在未处理交班记录"
}

/// 描述:保存盘点结果
/// w ##Class(web.DHCEQ.EM.BUSHandOver).SaveHandOverList("1^4^3^传真机^124^1880^8^5^5^25^备注^04/03/2011^^^^^^&2^^2^笔记本电脑^1^^8^5000^10^50000^^^^^^^^")
ClassMethod SaveHandOverList(dataList)
{
	Set SQLCODE=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set Length=$l(dataList,SplitRowCode)
	
	TStart
	for k=1:1:Length
	{
		q:SQLCODE'=0
		k PLIST
		s info=$p(dataList,SplitRowCode,k)
		q:info=""
		s HOLRowID=$p(info,"^",1)
		s PLIST(10)=+$H
		s PLIST(11)=+$p($H,",",2)
		s PLIST(12)=$p(info,"^",2)	
		s PLIST(13)	="2"
		s PLIST(14)=$p(info,"^",3)	
		&SQL(Update sqluser.DHC_EQHandOverList values :PLIST() Where HOL_RowID=:HOLRowID)
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	else
	{	TCommit		}
	
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

/// w ##Class(web.DHCEQ.EM.BUSHandOver).SaveHandOver("106^158^76^86")
ClassMethod SaveHandOver(valinfo As %Library.String = "")
{
	s SQLCODE=0
	s CurLocDR= $p(valinfo,"^",2)
	s CurUser= $p(valinfo,"^",3)
	s CurGroupID= $p(valinfo,"^",4)

	s EquipIDs=""
	s EquipTypeDR=0
	f  s EquipTypeDR=$o(^DHCEQEquip(0,"StoreEquipType","N",1,CurLocDR,EquipTypeDR))  q:EquipTypeDR=""  d
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,CurGroupID)=1
	.s EQRowID=0
	.f  s EQRowID=$o(^DHCEQEquip(0,"StoreEquipType","N",1,CurLocDR,EquipTypeDR,EQRowID))  q:EQRowID=""  d
	..q:##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("02","3",EQRowID)'="Y"
	..q:$p($g(^DHCEQEquip(EQRowID)),"^",93)="2"
	..q:##Class(web.DHCEQCommon).IdInIds(EQRowID,EquipIDs,0)=1
	..i EquipIDs="" d
	...s EquipIDs=EQRowID
	..e  d
	...s EquipIDs=EquipIDs_","_EQRowID

	s rowid=0
	f  s rowid=$o(^DHCEQSShareResource(rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",19)="N"
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",15)'="1"
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",14)'=CurLocDR
	.s EquipDR=$p($g(^DHCEQSShareResource(rowid)),"^",3)
	.q:##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("02","3",EquipDR)'="Y"
	.q:##Class(web.DHCEQCommon).IdInIds(EquipDR,EquipIDs,0)=1
	.i EquipIDs="" d
	..s EquipIDs=EquipDR
	.e  d
	..s EquipIDs=EquipIDs_","_EquipDR
	i EquipIDs="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9201")
	s SQLCODE=##Class(web.DHCEQ.EM.BUSHandOver).BatchHandOver(EquipIDs,valinfo,CurUser)
	
	q SQLCODE
}

/// Add By ZC 2021-08-10
/// 描述:根据人员获取待处理交班记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSHandOver","GetHandOverBuss","167")
Query GetHandOverBuss(vUser As %String = "") As %Query(ROWSPEC = "HORowID:%String,TNo:%String,TUseLoc:%String,HOUser:%String,HODate:%String,HOTime:%String") [ SqlProc ]
{
}

ClassMethod GetHandOverBussExecute(ByRef qHandle As %Binary, vUser As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i vUser="" Quit $$$OK
	s rowid=0
	f  s rowid=$o(^DHCEQHandOver(rowid))  quit:rowid=""  d
	.d ResetVariablesGetHandOverBuss
	.q:$p($g(^DHCEQHandOver(rowid)),"^",17)="Y"
	.q:$p($g(^DHCEQHandOver(rowid)),"^",10)="2"
	.q:$p($g(^DHCEQHandOver(rowid)),"^",7)'=vUser
	.s TNo=$p($g(^DHCEQHandOver(rowid)),"^",1)
	.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQHandOver(rowid)),"^",3))
	.s TDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQHandOver(rowid)),"^",4),"date")
	.s TTime=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQHandOver(rowid)),"^",5),"time")
	.s TUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQHandOver(rowid)),"^",6)) 
	.s TRowID=rowid
	.d OutputRowGetHandOverBuss
	
	
	Quit $$$OK
OutputRowGetHandOverBuss
	s Data=$lb(TRowID,TNo,TUseLoc,TUser,TDate,TTime)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetHandOverBuss
	s (TRowID,TNo,TUseLoc,TUser,TDate,TTime)=""
	quit
}

ClassMethod GetHandOverBussFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHandOverBussExecute ]
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

ClassMethod GetHandOverBussClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHandOverBussExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod UpDateEquipStatus(HOLRowID)
{
	s SQLCODE=0
	s EquipStatus=$p($g(^DHCEQHandOverList(HOLRowID)),"^",11)
	i EquipStatus=1 d
	.s EquipStatus=0
	e  d
	.s EquipStatus=1
	&SQL(Update SQLUSER.DHC_EQHandOverList Set HOL_EquipStatus=:EquipStatus where HOL_RowID=:HOLRowID)
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

ClassMethod UpDateHandOver(HORowID)
{
	s SQLCODE=0
	k PLIST
	s PLIST(9)=+$H
	s PLIST(10)=+$p($H,",",2)
	s PLIST(11)=2
	&SQL(Update SQLUSER.DHC_EQHandOver values :PLIST() Where HO_RowID=:HORowID)
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

/// Add By ZC 2021-08-10
/// 描述:获取科室设备记录清单
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSHandOver","GetHandOverEquipList","1")
Query GetHandOverEquipList(HORowID As %String = "") As %Query(ROWSPEC = "HOLRowID:%String,TNo:%String,TName:%String,TModel:%String,TManuFactory:%String,TLeaveFactoryNo:%String,TUseLoc:%String,HOEquipStatus:%String,HORemark:%String,HOEquipStatusDesc:%String") [ SqlProc ]
{
}

ClassMethod GetHandOverEquipListExecute(ByRef qHandle As %Binary, HORowID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i HORowID="" Quit $$$OK
	s rowid=0
	f  s rowid=$o(^DHCEQHandOverList(0,"HandOver",HORowID,rowid))  quit:rowid=""  d
	.d ResetVariablesGetHandOverEquipList
	.q:$p($g(^DHCEQHandOverList(rowid)),"^",19)="Y"
	.s EquipDR=$p($g(^DHCEQHandOverList(rowid)),"^",2)
	.s TNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	.s TName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	.s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQEquip(EquipDR)),"^",3))
	.s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p($g(^DHCEQEquip(EquipDR)),"^",26)) 
	.s TLeaveFactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
	.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(EquipDR)),"^",19))
	.s TRowID=rowid
	.s TEquipStatus=$p($g(^DHCEQHandOverList(rowid)),"^",11)
	.s TRemark=$p($g(^DHCEQHandOverList(rowid)),"^",13)
	.s TEquipStatusDesc=$CASE(TEquipStatus,"0":"正常","1":"异常","":"")
	.d OutputRowGetHandOverEquipList
	
	
	Quit $$$OK
OutputRowGetHandOverEquipList
	s Data=$lb(TRowID,TNo,TName,TModel,TManuFactory,TLeaveFactoryNo,TUseLoc,TEquipStatus,TRemark,TEquipStatusDesc)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetHandOverEquipList
	s (TRowID,TNo,TName,TModel,TManuFactory,TLeaveFactoryNo,TUseLoc,TEquipStatus,TRemark,TEquipStatusDesc)=""
	quit
}

ClassMethod GetHandOverEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHandOverEquipListExecute ]
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

ClassMethod GetHandOverEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHandOverEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 2016-11-29 ZX0036
/// 获取新增单据数量,暂时处理维修
/// w ##Class(web.DHCEQ.EM.BUSHandOver).GetHandOverNums(1)
/// // Modefied by zx 2020-09-16 调整获取方式
ClassMethod GetHandOverNums(UserID)
{
	n HandOverNums
	s HandOverNums=0
	s hdrowid=0
	f  s hdrowid=$o(^DHCEQHandOver(hdrowid))  quit:hdrowid=""  d
	.q:$p($g(^DHCEQHandOver(hdrowid)),"^",17)="Y"
	.q:$p($g(^DHCEQHandOver(hdrowid)),"^",10)="2"
	.q:$p($g(^DHCEQHandOver(hdrowid)),"^",7)'=UserID
	.s HandOverNums=HandOverNums+1
	q HandOverNums
}

/// w ##Class(web.DHCEQ.EM.BUSHandOver).SaveLocPMTemplate("^158^76^86")
ClassMethod SaveLocPMTemplate(valinfo As %Library.String = "")
{
	s SQLCODE=0
	s CurLocDR= $p(valinfo,"^",2)
	s CurUser= $p(valinfo,"^",3)
	s CurGroupID= $p(valinfo,"^",4)

	s EquipIDs=""
	s EquipTypeDR=0
	f  s EquipTypeDR=$o(^DHCEQEquip(0,"StoreEquipType","N",1,CurLocDR,EquipTypeDR))  q:EquipTypeDR=""  d
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,CurGroupID)=1
	.s EQRowID=0
	.f  s EQRowID=$o(^DHCEQEquip(0,"StoreEquipType","N",1,CurLocDR,EquipTypeDR,EQRowID))  q:EQRowID=""  d
	..q:##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("02","3",EQRowID)'="Y"
	..q:$p($g(^DHCEQEquip(EQRowID)),"^",93)="2"
	..q:##Class(web.DHCEQCommon).IdInIds(EQRowID,EquipIDs,0)=1
	..i EquipIDs="" d
	...s EquipIDs=EQRowID
	..e  d
	...s EquipIDs=EquipIDs_","_EQRowID

	s rowid=0
	f  s rowid=$o(^DHCEQSShareResource(rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",19)="N"
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",15)'="1"
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",14)'=CurLocDR
	.s EquipDR=$p($g(^DHCEQSShareResource(rowid)),"^",3)
	.q:##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("02","3",EquipDR)'="Y"
	.q:##Class(web.DHCEQCommon).IdInIds(EquipDR,EquipIDs,0)=1
	.i EquipIDs="" d
	..s EquipIDs=EquipDR
	.e  d
	..s EquipIDs=EquipIDs_","_EquipDR
	i EquipIDs="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9201")
	s SQLCODE=##Class(web.DHCEQ.EM.BUSHandOver).BatchLocPMTemplate(EquipIDs,valinfo,CurUser)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

/// w ##Class(web.DHCEQ.EM.BUSHandOver).BatchLocPMTemplate(1,"^158^76^86",1)
ClassMethod BatchLocPMTemplate(PlanEquipInfo, ValInfo, User As %String = "")
{
	n Flag,InfoLength
	s $ZT="ERRORBatchLocPMTemplate"
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	TSTART	
	s Flag=0
	// MZY0093	2021-09-08
	s InfoLength=$l(PlanEquipInfo,",")
	f n=1:1:InfoLength
	{
		k PLISTMX
		s EquipID=$p(PlanEquipInfo,",",n)
		s SQLCODE=##class(web.DHCEQ.EM.BUSHandOver).CheckEquipMaint(EquipID,Date)
		i SQLCODE s Flag=SQLCODE
		Quit:Flag
		s ExecuteDate=Date	//add by lmm 执行日期
		s PLISTMX(2)=EquipID
		s PLISTMX(3)=1
		s PLISTMX(5)=1	;MaintTypeDR
		s PLISTMX(6)=ExecuteDate	;MaintDate   ;modify by lmm 2020-11-18
		s PLISTMX(7)=$p(ValInfo,"^",2)	;MaintLocDR
		s PLISTMX(8)=User		//czf 1283059
		s PLISTMX(11)=""	;NormalFlag
		s PLISTMX(12)=""	;ManageLocDR
		s PLISTMX(13)=$p($g(^DHCEQEquip(EquipID)),"^",19)	;UseLocDR
		s PLISTMX(14)=2		;Status
		s PLISTMX(16)=User
		s PLISTMX(17) = Date	;UpdateDate
		s PLISTMX(18) = Time	;UpdateTime
		s PLISTMX(19) = User	;AuditUserDR
		s PLISTMX(20) = Date	;AuditDate
		s PLISTMX(21) = Time	;AuditTime
		s PLISTMX(40) = "N"	;InvalidFlag
		&SQL(insert into sqluser.DHC_EQMaint values :PLISTMX())
		s MaintRowID=$G(%ROWID)
		i SQLCODE s Flag=SQLCODE
		s SQLCODE=##class(web.DHCEQ.EM.BUSMaint).InsertEQLifeInfo(MaintRowID,User)
		i SQLCODE s Flag=SQLCODE
		Quit:Flag
		s PMRTemplateDR=+##Class("web.DHCEQ.EM.BUSHandOver").GetRangSourceByEquip(EquipID,5,5)
		i PMRTemplateDR>0
		{
			&SQL(insert into SQLUSER.DHC_EQPMReport (PMR_TemplateDR,PMR_MaintDR,PMR_Status,PMR_InvalidFlag) Values (:PMRTemplateDR,:MaintRowID,'0','N'))
			i SQLCODE s Flag=SQLCODE
			Quit:Flag
			s PMReportDR=$g(%ROWID)
			
			s dataList=""
			s Sort=0
			f  s Sort=$o(^DHCEQCCode("DHCEQCPMTemplateList",0,"PMTLTemplateDR",PMRTemplateDR,Sort)) q:Sort=""  d
			.s TemplateListDR=""
			.f  s TemplateListDR=$o(^DHCEQCCode("DHCEQCPMTemplateList",0,"PMTLTemplateDR",PMRTemplateDR,Sort,TemplateListDR)) q:TemplateListDR=""  d
			..s MaintItemDR=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TemplateListDR)),"^",2)
			..q:MaintItemDR=""
			..q:$p($g(^DHCEQCCode("DHCEQCMaintItem",MaintItemDR)),"^",4)="Y"
			..s PSort=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TemplateListDR)),"^",4)
			..s DefaultVal=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TemplateListDR)),"^",5)
			..//i DefaultVal="" s DefaultVal=0
			..if (dataList'="") s dataList=dataList_"#"
			..s dataList=dataList_"^^"_MaintItemDR_"^"_DefaultVal_"^^^"_PSort_"^^^^^^"
			
			s SQLCODE=##Class(web.DHCEQ.Process.DHCEQPMReportList).SaveMPReportListNew(PMReportDR,dataList)
			i SQLCODE s Flag=SQLCODE
		}
	}
	i Flag
	{
		TROLLBACK
		q Flag
	}
	TCOMMIT
 	q Flag
ERRORBatchLocPMTemplate 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORExecute>"_ErrorMsg     //返回错误消息 ;
}

/// w ##Class(web.DHCEQ.EM.BUSHandOver).GetRangSourceByEquip("","5","5","","86")
ClassMethod GetRangSourceByEquip(EquipID As %Library.String = "", SourceType As %Library.String = "", PlanType As %Library.String = "", ExecuteFlag As %Library.String = "", CurGroupID As %Library.String = "")
{
	s Result=""
	i SourceType="" q Result
	i SourceType="5"
	{
		s ResultID=""
		s defaultTemplate=""		// MZY0092	2021-08-27
		s SourceID=0
		f  s SourceID=$o(^DHCEQCCode("DHCEQCPMTemplate",SourceID)) q:(SourceID="")||(ResultID'="")  d
		.q:(PlanType'="")&&(PlanType'=$p($g(^DHCEQCCode("DHCEQCPMTemplate",SourceID)),"^",1))
		.i $p($g(^DHCEQCCode("DHCEQCPMTemplate",SourceID)),"^",8)'="" s defaultTemplate=SourceID
		.s ResultID=SourceID
		
		i ResultID'="" d
		.s Result=ResultID_"^"_$p($g(^DHCEQCCode("DHCEQCPMTemplate",ResultID)),"^",2)
		e  d
		.s Result=defaultTemplate_"^"_$p($g(^DHCEQCCode("DHCEQCPMTemplate",+defaultTemplate)),"^",2)
	}
	
	q ResultID
}

ClassMethod CheckEquipMaint(EquipDR, vDate)
{
	i EquipDR="" q 0
	s mflag=0
	s mrowid=0
	f  s mrowid=$o(^DHCEQMaint(0,"Equip",1,EquipDR,mrowid))  quit:(mrowid="")||(mflag'=0)  d
	.q:$p($g(^DHCEQMaint(mrowid)),"^",5)'=vDate
	.s mflag=-9210
	q mflag
}

/// Author ZX 2021-03-26
/// Desc 获取保养检查模板明细信息,用于生成保养检查项目明细清单
/// Input TemplateDR:模板ID;
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSHandOver","GetTemplateList")
/// Modify by zx 2021-07-14 参数调整,不局限于设备id获取模板 
Query GetTemplateList() As %Query(ROWSPEC = "TRowID:%String,TMaintItemDR:%String,TNote:%String,TSort:%String,TDefaultVal:%String,TItemFactorKey:%String,TItemCode:%String,TItemDesc:%String,TItemRemark:%String,TItemType:%String,TItemItemCatDR:%String,TItemItemCat:%String,TItemNote:%String,TItemDateType:%String,TItemDisplayType:%String,TItemQualitative:%String,TItemSettingFlag:%String,TItemMultiChoiceFlag:%String,TMaintItemValues:%String,TMaintItemNormalValues:%String,TPMReportListID:%String,TTemplateDR:%String,TTemplate:%String")
{
}

ClassMethod GetTemplateListExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)

	s index=1
	//模板id和设备id不能同时为空
	s TemplateDR=##Class("web.DHCEQ.EM.BUSHandOver").GetRangSourceByEquip("",5,5)
	i TemplateDR="" Quit $$$OK
	s RecievedItemDR=""  //一个项目仅获取一次
	s PMReportDR=""
	s TemplateListDR=0
	s TTemplateDR=TemplateDR
	s TTemplate=$p($g(^DHCEQCCode("DHCEQCPMTemplate",TTemplateDR)),"^",2)
	s Sort=0
	f  s Sort=$o(^DHCEQCCode("DHCEQCPMTemplateList",0,"PMTLTemplateDR",TemplateDR,Sort)) q:Sort=""  d
	.f  s TemplateListDR=$o(^DHCEQCCode("DHCEQCPMTemplateList",0,"PMTLTemplateDR",TemplateDR,Sort,TemplateListDR)) q:TemplateListDR=""  d
	..d ResetVariablesGetTemplateList
	..s TRowID=TemplateListDR
	..s TMaintItemDR=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TRowID)),"^",2)
	..q:TMaintItemDR=""
	..s TNote=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TRowID)),"^",3)
	..s TSort=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TRowID)),"^",4)
	..s TDefaultVal=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TRowID)),"^",5)
	..s TItemFactorKey=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TRowID)),"^",6)
	..q:$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",4)="Y"
	..i (","_RecievedItemDR_",")'[(","_TMaintItemDR_",") d
	...i RecievedItemDR'="" s RecievedItemDR=RecievedItemDR_","
	...s RecievedItemDR=RecievedItemDR_TMaintItemDR
	...d GetTemplateListInfo
	
	Quit $$$OK

GetTemplateListInfo
	s TItemCode=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",1)
	s TItemDesc=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",2)
	s TItemRemark=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",3)
	s TItemType=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",5)
	s TItemItemCatDR=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",6)
	i TItemItemCatDR'="" s TItemItemCat=$p($g(^DHCEQCCode("DHCEQCMaintItemCat")),"^",3)
	s TItemNote=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",8)
	s TItemDateType=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",9)
	s TItemDisplayType=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",10)
	s TItemQualitative=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",11)
	s TItemSettingFlag=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",12)
	s TItemMultiChoiceFlag=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",13)
	s TMaintItemValues=##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintItemValues(TMaintItemDR)
	s TMaintItemNormalValues=##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintItemNormalValues(TMaintItemDR,PMReportDR)
	d OutputRowGetTemplateList
	
	quit
OutputRowGetTemplateList
	s Data=$lb(TRowID,TMaintItemDR,TNote,TSort,TDefaultVal,TItemFactorKey,TItemCode,TItemDesc,TItemRemark,TItemType,TItemItemCatDR,TItemItemCat,TItemNote,TItemDateType,TItemDisplayType,TItemQualitative,TItemSettingFlag,TItemMultiChoiceFlag,TMaintItemValues,TMaintItemNormalValues,TPMReportListID,TTemplateDR,TTemplate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetTemplateList
	s (TRowID,TMaintItemDR,TNote,TSort,TDefaultVal,TItemFactorKey,TItemCode,TItemDesc,TItemRemark,TItemType,TItemItemCatDR,TItemItemCat,TItemNote,TItemDateType,TItemDisplayType,TItemQualitative,TItemSettingFlag,TItemMultiChoiceFlag,TMaintItemValues,TMaintItemNormalValues,TPMReportListID,TFactorID)=""
	quit
}

ClassMethod GetTemplateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTemplateListExecute ]
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

ClassMethod GetTemplateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTemplateListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.BUSHandOver).SaveLocPMTemplatePDA("^158^76^86")
ClassMethod SaveLocPMTemplatePDA(valinfo As %Library.String = "", dataList)
{
	s SQLCODE=0
	s CurLocDR= $p(valinfo,"^",2)
	s CurUser= $p(valinfo,"^",3)
	s CurGroupID= $p(valinfo,"^",4)

	s EquipIDs=""
	s EquipTypeDR=0
	f  s EquipTypeDR=$o(^DHCEQEquip(0,"StoreEquipType","N",1,CurLocDR,EquipTypeDR))  q:EquipTypeDR=""  d
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,CurGroupID)=1
	.s EQRowID=0
	.f  s EQRowID=$o(^DHCEQEquip(0,"StoreEquipType","N",1,CurLocDR,EquipTypeDR,EQRowID))  q:EQRowID=""  d
	..q:##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("02","3",EQRowID)'="Y"
	..q:$p($g(^DHCEQEquip(EQRowID)),"^",93)="2"
	..q:##Class(web.DHCEQCommon).IdInIds(EQRowID,EquipIDs,0)=1
	..i EquipIDs="" d
	...s EquipIDs=EQRowID
	..e  d
	...s EquipIDs=EquipIDs_","_EQRowID

	s rowid=0
	f  s rowid=$o(^DHCEQSShareResource(rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",19)="N"
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",15)'="1"
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",14)'=CurLocDR
	.s EquipDR=$p($g(^DHCEQSShareResource(rowid)),"^",3)
	.q:##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("02","3",EquipDR)'="Y"
	.q:##Class(web.DHCEQCommon).IdInIds(EquipDR,EquipIDs,0)=1
	.i EquipIDs="" d
	..s EquipIDs=EquipDR
	.e  d
	..s EquipIDs=EquipIDs_","_EquipDR
	i EquipIDs="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9201")
	s SQLCODE=##Class(web.DHCEQ.EM.BUSHandOver).BatchLocPMTemplatePDA(EquipIDs,valinfo,CurUser,dataList)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

/// w ##Class(web.DHCEQ.EM.BUSHandOver).BatchLocPMTemplatePDA(1,"^158^76^86",1)
ClassMethod BatchLocPMTemplatePDA(PlanEquipInfo, ValInfo, User As %String = "", dataList)
{
	n Flag,InfoLength
	s $ZT="ERRORBatchLocPMTemplatePDA"
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	TSTART	
	s Flag=0
	// MZY0093	2021-09-08
	s InfoLength=$l(PlanEquipInfo,",")
	f n=1:1:InfoLength
	{
		k PLISTMX
		s EquipID=$p(PlanEquipInfo,",",n)
		s SQLCODE=##class(web.DHCEQ.EM.BUSHandOver).CheckEquipMaint(EquipID,Date)
		i SQLCODE s Flag=SQLCODE
		Quit:Flag
		s ExecuteDate=Date	//add by lmm 执行日期
		s PLISTMX(2)=EquipID
		s PLISTMX(3)=1
		s PLISTMX(5)=1	;MaintTypeDR
		s PLISTMX(6)=ExecuteDate	;MaintDate   ;modify by lmm 2020-11-18
		s PLISTMX(7)=$p(ValInfo,"^",2)	;MaintLocDR
		s PLISTMX(8)=User		//czf 1283059
		s PLISTMX(11)=""	;NormalFlag
		s PLISTMX(12)=""	;ManageLocDR
		s PLISTMX(13)=$p($g(^DHCEQEquip(EquipID)),"^",19)	;UseLocDR
		s PLISTMX(14)=1		;Status
		s PLISTMX(16)=User
		s PLISTMX(17) = Date	;UpdateDate
		s PLISTMX(18) = Time	;UpdateTime
		s PLISTMX(19) = User	;AuditUserDR
		s PLISTMX(20) = Date	;AuditDate
		s PLISTMX(21) = Time	;AuditTime
		s PLISTMX(40) = "N"	;InvalidFlag
		&SQL(insert into sqluser.DHC_EQMaint values :PLISTMX())
		s MaintRowID=$G(%ROWID)
		i SQLCODE s Flag=SQLCODE
		s SQLCODE=##class(web.DHCEQ.EM.BUSMaint).InsertEQLifeInfo(MaintRowID,User)
		i SQLCODE s Flag=SQLCODE
		Quit:Flag
		s PMRTemplateDR=+##Class("web.DHCEQ.EM.BUSHandOver").GetRangSourceByEquip(EquipID,5,5)
		i PMRTemplateDR>0
		{
			&SQL(insert into SQLUSER.DHC_EQPMReport (PMR_TemplateDR,PMR_MaintDR,PMR_Status,PMR_InvalidFlag) Values (:PMRTemplateDR,:MaintRowID,'0','N'))
			i SQLCODE s Flag=SQLCODE
			Quit:Flag
			s PMReportDR=$g(%ROWID)
			s SQLCODE=##Class(web.DHCEQ.Process.DHCEQPMReportList).SaveMPReportListNew(PMReportDR,dataList)
			i SQLCODE s Flag=SQLCODE
		}
	}
	i Flag
	{
		TROLLBACK
		q Flag
	}
	TCOMMIT
 	q Flag
ERRORBatchLocPMTemplatePDA 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORExecute>"_ErrorMsg     //返回错误消息 ;
}

/// w ##Class(web.DHCEQ.EM.BUSHandOver).AduitLocPMTemplatePDA("^158^76^86")
ClassMethod AduitLocPMTemplatePDA(valinfo As %Library.String = "")
{
	s SQLCODE=0
	s CurLocDR= $p(valinfo,"^",2)
	s CurUser= $p(valinfo,"^",3)
	s CurGroupID= $p(valinfo,"^",4)
	s MaintIDs=""
	s rowid=0
	f  s rowid=$o(^DHCEQMaint(rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQMaint(rowid)),"^",39)="Y"
	.q:$p($g(^DHCEQMaint(rowid)),"^",2)'="1"
	.q:$p($g(^DHCEQMaint(rowid)),"^",4)'=1
	.q:$p($g(^DHCEQMaint(rowid)),"^",13)'=1
	.q:$p($g(^DHCEQMaint(rowid)),"^",6)'=CurLocDR
	.i MaintIDs="" d
	..s MaintIDs=rowid
	.e  d
	..s MaintIDs=MaintIDs_","_rowid
	i MaintIDs="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9201")
	s SQLCODE=##Class(web.DHCEQ.EM.BUSMaint).BatckExecute(MaintIDs,CurUser)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSHandOver","GetLocPMEquipList","53","86")
Query GetLocPMEquipList(vLocDR As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TItemDR:%String,TNo:%String,TName:%String,TModel:%String,TOriginalFee:%String,TEquipType:%String,TStoreLoc:%String,TStoreLocDR:%String,TManuFactory:%String,TLeaveFactoryNo:%String,TUnit:%String,TUseLoc:%String,TFileNo:%String,TAdvanceDisFlag:%String,TEquipStatus:%String") [ SqlProc ]
{
}

ClassMethod GetLocPMEquipListExecute(ByRef qHandle As %Binary, vLocDR As %String = "", CurGroupID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1

	s StoreLocDR=0
	f  s StoreLocDR=$o(^DHCEQEquip(0,"StoreEquipType","N",1,StoreLocDR))  q:StoreLocDR=""  d
	.q:(vLocDR'="")&&(StoreLocDR'=vLocDR)
	.s EquipTypeDR=0
	.f  s EquipTypeDR=$o(^DHCEQEquip(0,"StoreEquipType","N",1,StoreLocDR,EquipTypeDR))  q:EquipTypeDR=""  d
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,CurGroupID)=1
	..s EQRowID=0
	..f  s EQRowID=$o(^DHCEQEquip(0,"StoreEquipType","N",1,StoreLocDR,EquipTypeDR,EQRowID))  q:EQRowID=""  d
	...d ResetVariablesGetLocPMEquipList
	...q:##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("02","3",EQRowID)'="Y"
	...q:(##Class(web.DHCEQ.EM.BUSEquipAttribute).GetOneEquipAttribute("3",EQRowID)'["id3")
	...;q:##Class(web.DHCEQ.EM.BUSHandOver).CheckEquipIsInRent(EQRowID)=1
	...q:$p($g(^DHCEQEquip(EQRowID)),"^",93)="2"
	...s TAdvanceDisFlag=0
	...s TRowID=EQRowID
	...s TItemDR=$p($g(^DHCEQEquip(EQRowID)),"^",7)
	...s TNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	...s TName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	...s TCode=$p($g(^DHCEQEquip(EQRowID)),"^",6)
	...s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQEquip(EQRowID)),"^",3))
	...s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",27))
	...s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)
	...s TStoreLocDR=StoreLocDR
	...s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	...s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p($g(^DHCEQEquip(EQRowID)),"^",26)) 
	...s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p($g(^DHCEQEquip(EQRowID)),"^",5)) 
	...s TLeaveFactoryNo=$p($g(^DHCEQEquip(EQRowID)),"^",10)
	...s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(EQRowID)),"^",19))
	...s TFileNo=$p($g(^DHCEQEquip(EQRowID)),"^",85)
	...i ((",3,4,")[(","_$p($g(^DHCEQEquip(EQRowID)),"^",93)_",")) d
	....s TAdvanceDisFlag=1
	...e  i ((",1,")[(","_$p($g(^DHCEQEquip(EQRowID)),"^",93)_",")) d
	....s TAdvanceDisFlag=2
	...i ##Class(web.DHCEQ.EM.BUSHandOver).CheckEquipIsInRent(EQRowID)=1  s TAdvanceDisFlag=3
	...s TEquipStatus=$case(TAdvanceDisFlag,0:"正常",1:"维修中",2:"报废中",3:"调配中",:"未知")
	...d OutputRowGetLocPMEquipList

	s rowid=0
	f  s rowid=$o(^DHCEQSShareResource(rowid))  quit:rowid=""  d
	.d ResetVariablesGetLocPMEquipList
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",19)="N"
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",15)'="1"
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",14)'=vLocDR
	.s EquipDR=$p($g(^DHCEQSShareResource(rowid)),"^",3)
	.q:##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("02","3",EquipDR)'="Y"
	.s TRowID=EquipDR
	.s TItemDR=$p($g(^DHCEQEquip(EquipDR)),"^",7)
	.s TNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	.s TName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	.s TCode=$p($g(^DHCEQEquip(TRowID)),"^",6)
	.s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQEquip(EquipDR)),"^",3))
	.s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EquipDR)),"^",27))
	.s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p($g(^DHCEQEquip(EquipDR)),"^",63))
	.s TStoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
	.s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	.s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p($g(^DHCEQEquip(EquipDR)),"^",26)) 
	.s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p($g(^DHCEQEquip(EquipDR)),"^",5)) 
	.s TLeaveFactoryNo=$p($g(^DHCEQEquip(TRowID)),"^",10)
	.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(EquipDR)),"^",19))_"(调出)"
	.s TFileNo=$p($g(^DHCEQEquip(TRowID)),"^",85)
	.s TAdvanceDisFlag=3
	.s TEquipStatus=$case(TAdvanceDisFlag,0:"正常",1:"维修中",2:"报废中",3:"调配中",:"未知")
	.d OutputRowGetLocPMEquipList
	
	
	
	Quit $$$OK
OutputRowGetLocPMEquipList
	s Data=$lb(TRowID,TItemDR,TNo,TName,TModel,TOriginalFee,TEquipType,TStoreLoc,TStoreLocDR,TManuFactory,TLeaveFactoryNo,TUnit,TUseLoc,TFileNo,TAdvanceDisFlag,TEquipStatus)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetLocPMEquipList
	s (TRowID,TItemDR,TNo,TName,TModel,TOriginalFee,TEquipType,TStoreLoc,TStoreLocDR,TManuFactory,TLeaveFactoryNo,TUnit,TUseLoc,TFileNo,EquipDR,TAdvanceDisFlag,TEquipStatus)=""
	quit
}

ClassMethod GetLocPMEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocPMEquipListExecute ]
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

ClassMethod GetLocPMEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocPMEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
