Class web.DHCEQMove Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(%ResultSet).RunQuery("web.DHCEQMove","MoveList","", "", "", "", "", "", "", "", "", "", "", "", "0", "", "")
///            No, EquipName, SourceType, EventType, FromDeptType, FromLocationDR, StartDate, SendUserDR, ToDeptType, ToLocationDR, EndDate, AcceptUserDR, Status, EquipNo, ObjID
Query MoveList(No, EquipName, SourceType, EventType, FromDeptType, FromLocationDR, StartDate, SendUserDR, ToDeptType, ToLocationDR, EndDate, AcceptUserDR, Status, EquipNo, ObjID, CurUser) As %Query(ROWSPEC = "rowid:%String,no:%String,objtypedr:%String,objtype:%String,objid:%String,sourcetypedr:%String,sourcetype:%String,sourceid:%String,eventypedr:%String,eventype:%String,fromdepttypedr:%String,fromdepttype:%String,fromdeptid:%String,fromlocationdr:%String,fromlocation:%String,startdate:%String,movereason:%String,senduserdr:%String,senduser:%String,todepttypedr:%String,todepttype:%String,todeptid:%String,tolocationdr:%String,tolocation:%String,enddate:%String,acceptuserdr:%String,acceptuser:%String,remark:%String,statusdr:%String,status:%String,invalidflag:%String,invalidreason:%String,equipname:%String,equipno:%String") [ SqlProc ]
{
}

ClassMethod MoveListExecute(ByRef qHandle As %Binary, No, EquipName, SourceType, EventType, FromDeptType, FromLocationDR, StartDate, SendUserDR, ToDeptType, ToLocationDR, EndDate, AcceptUserDR, Status, EquipNo, ObjID, CurUser) As %Status
{
	new repid, index, rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	i StartDate="" d
 	.s StartDate=0
 	e  d
 	.;s StartDate=$zdh(StartDate,3)
 	.;日期格式统一调整   modify by jyp  2017-03-02
	.s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
 	i EndDate="" d
 	.s EndDate=$h
 	e  d
 	.;s EndDate=$zdh(EndDate,3)
 	.;日期格式统一调整   modify by jyp  2017-03-02
	.s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	s mrowid=0
	f  s mrowid=$o(^DHCEQMove(mrowid))  q:mrowid=""  d
	.;Add By QW20160229 筛选个人单据
	.i CurUser'=""  d
	..s CurUserID="^"_CurUser_"^"
	..s useid="^"_$p($g(^DHCEQMove(mrowid)),"^",18)_"^"_$Piece($Get(^DHCEQMove(mrowid)),"^",19)_"^"_$Piece($Get(^DHCEQMove(mrowid)),"^",20)_"^"_$Piece($Get(^DHCEQMove(mrowid)),"^",23)_"^"_$Piece($Get(^DHCEQMove(mrowid)),"^",26)_"^"_$Piece($Get(^DHCEQMove(mrowid)),"^",33)_"^" ;Add By QW20160229 筛选个人单据
	.q:(CurUser'="")&&(useid'[CurUserID) 
	.;End By QW20160229 筛选个人单据
	.d ResetVariablesMoveList
	.s no=$p($g(^DHCEQMove(mrowid)),"^",1)
	.q:(No'="")&&(no'=No)
	.s objtypedr=$p($g(^DHCEQMove(mrowid)),"^",2)
	.s objtype=$Case(objtypedr,1:"设备",:"")
	.s sourcetypedr=$p($g(^DHCEQMove(mrowid)),"^",4)
	.q:(SourceType'="")&&(sourcetypedr'=SourceType)
	.s sourcetype=$Case(sourcetypedr,1:"维修",2:"租赁",3:"转移单",:"")
	.s sourceid=$p($g(^DHCEQMove(mrowid)),"^",5)
	.i sourcetypedr=3 d
	..s num=""
	..s smrowid=$p($g(^DHCEQMove(mrowid)),"^",5)
	..&SQL(select count(*)  into :num from sqluser.DHC_EQStoreMoveList where SML_StoreMoveDR=:smrowid) 
	..i num=1 d
	...s mlrowid=$o(^DHCEQStoreMoveList(0,"StoreMove",smrowid,0))
	...i $p($g(^DHCEQStoreMoveList(mlrowid)),"^",3)'="Y" d   ;批量处理
	....s objid=$p($g(^DHCEQMove(mrowid)),"^",3)
	....q:(ObjID'="")&&(objid'=ObjID)
	....i objid'="" d 
	.....s equipname=$p($g(^DHCEQEquip(objid)),"^",1)
	.....q:(EquipName'="")&&(equipname'=EquipName)
	.....s equipno=$p($g(^DHCEQEquip(objid)),"^",71)
	.....q:(EquipNo'="")&&(equipno'=EquipNo)
	...e  d
	....s equipname=$p($g(^DHCEQStoreMoveList(mlrowid)),"^",5)
	....q:(EquipName'="")&&(equipname'=EquipName) 
	....s objid=$g(^DHCEQMove(mrowid,"EX","RowIDs"))
	....q:(ObjID'="")&&(0=(##Class(web.DHCEQCommon).IdInIds(ObjID,objid)))
	....s equipno=..GetEquipNoInfo($g(^DHCEQMove(mrowid,"EX","RowIDs")))
	....s equipno=##Class(web.DHCEQCommon).NoToGroupNo(equipno)   //add by HHM 2016-01-22 合并批量设备编号
	....q:(EquipNo'="")&&(0=(##Class(web.DHCEQCommon).IdInIds(EquipNo,equipno)))
	..e  d
	...s objid=$g(^DHCEQMove(mrowid,"EX","RowIDs"))
	...q:(ObjID'="")&&(0=(##Class(web.DHCEQCommon).IdInIds(ObjID,objid)))
	...s equipno=..GetEquipNoInfo($g(^DHCEQMove(mrowid,"EX","RowIDs")))
	...q:(EquipNo'="")&&(0=(##Class(web.DHCEQCommon).IdInIds(EquipNo,equipno)))
	.e  d
	..s objid=$p($g(^DHCEQMove(mrowid)),"^",3)
	..q:(ObjID'="")&&(objid'=ObjID)
	..i objid'="" d 
	...s equipname=$p($g(^DHCEQEquip(objid)),"^",1)
	...q:(EquipName'="")&&(equipname'=EquipName)
	...s equipno=$p($g(^DHCEQEquip(objid)),"^",71)
	...q:(EquipNo'="")&&(equipno'=EquipNo)
	.s eventypedr=$p($g(^DHCEQMove(mrowid)),"^",6)
	.q:(EventType'="")&&(eventypedr'=EventType)
	.s eventype=$Case(eventypedr,1:"送出",2:"返还",:"")
	.s fromdepttypedr=$p($g(^DHCEQMove(mrowid)),"^",8)
	.q:(FromDeptType'="")&&(fromdepttypedr'=FromDeptType)
	.s fromdepttype=$Case(fromdepttypedr,1:"科室",2:"服务商",3:"供应商",4:"生产厂商",:"")
	.s fromdeptid=$p($g(^DHCEQMove(mrowid)),"^",9)
	.s fromlocationdr=$p($g(^DHCEQMove(mrowid)),"^",10)
	.q:(FromLocationDR'="")&&(fromlocationdr'=FromLocationDR)
	.i fromlocationdr'="" s fromlocation=$p($g(^DHCEQCCode("DHCEQCLocation",fromlocationdr)),"^",2)
	.q:$p($g(^DHCEQMove(mrowid)),"^",11)<StartDate
	.s startdate=$p($g(^DHCEQMove(mrowid)),"^",11)
	.;i startdate'="" s startdate=$zd(startdate,3)
	.;日期格式统一调整   modify by jyp  2017-03-02
	.s startdate=##Class(web.DHCEQCommon).TransValueToPage(startdate,"date")
	.s movereason=$p($g(^DHCEQMove(mrowid)),"^",7)
	.s senduserdr=$p($g(^DHCEQMove(mrowid)),"^",18)
	.q:(SendUserDR'="")&&(senduserdr'=SendUserDR)
	.i senduserdr'="" s senduser=##class(web.DHCEQCommon).GetTrakNameByID("user",senduserdr)
	.s todepttypedr=$p($g(^DHCEQMove(mrowid)),"^",14)
	.q:(ToDeptType'="")&&(todepttypedr'=ToDeptType)
	.s todepttype=$Case(todepttypedr,1:"科室",2:"服务商",3:"供应商",4:"生产厂商",:"")
	.s todeptid=$p($g(^DHCEQMove(mrowid)),"^",15)
	.s tolocationdr=$p($g(^DHCEQMove(mrowid)),"^",13)
	.q:(ToLocationDR'="")&&(tolocationdr'=ToLocationDR)
	.i tolocationdr'="" s tolocation=$p($g(^DHCEQCCode("DHCEQCLocation",tolocationdr)),"^",2)
	.q:$p($g(^DHCEQMove(mrowid)),"^",16)>EndDate
	.s enddate=$p($g(^DHCEQMove(mrowid)),"^",16)
	.;i enddate'="" s enddate=$zd(enddate,3)
	.;日期格式统一调整   modify by jyp  2017-03-02
	.s enddate=##Class(web.DHCEQCommon).TransValueToPage(enddate,"date")
	.s acceptuserdr=$p($g(^DHCEQMove(mrowid)),"^",19)
	.q:(AcceptUserDR'="")&&(acceptuserdr'=AcceptUserDR)
	.i acceptuserdr'="" s acceptuser=##class(web.DHCEQCommon).GetTrakNameByID("user",acceptUserDR)
	.s remark=$p($g(^DHCEQMove(mrowid)),"^",29)
	.s statusdr=$p($g(^DHCEQMove(mrowid)),"^",30)
	.q:(Status'="")&&(statusdr'=Status)
	.s status=$Case(statusdr,0:"新增",1:"提交",2:"审核",3:"作废",:"")
	.s invalidflag=$p($g(^DHCEQMove(mrowid)),"^",31)
	.q:invalidflag="Y"
	.s invalidreason=$p($g(^DHCEQMove(mrowid)),"^",32)
	.s rowid=mrowid
	.d OutputRowMoveList
 
	Quit $$$OK
	
OutputRowMoveList
	s Data=$lb(rowid,no,objtypedr,objtype,objid,sourcetypedr,sourcetype,sourceid,eventypedr,eventype,fromdepttypedr,fromdepttype,fromdeptid,fromlocationdr,fromlocation,startdate,movereason,senduserdr,senduser,todepttypedr,todepttype,todeptid,tolocationdr,tolocation,enddate,acceptuserdr,acceptuser,remark,statusdr,status,invalidflag,invalidreason,equipname,equipno)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesMoveList
	s (rowid,no,objtypedr,objtype,objid,sourcetypedr,sourcetype,sourceid,eventypedr,eventype,fromdepttypedr,fromdepttype,fromdeptid,fromlocationdr,fromlocation,startdate,movereason,senduserdr,senduser,todepttypedr,todepttype,todeptid,tolocationdr,tolocation,enddate,acceptuserdr,acceptuser,remark,statusdr,status,invalidflag,invalidreason,equipname,equipno)=""
	quit
}

ClassMethod MoveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MoveListExecute ]
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

ClassMethod MoveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MoveListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCEQMove).GetMoveInfo("1")
ClassMethod GetMoveInfo(rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQMove(rowid)
	s resultex=resultex_"^"
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$Case($p(result,"^",2),1:"设备",:"")
	s resultex=resultex_"^"
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",3))),"^",1)
	s resultex=resultex_"^"	
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$Case($p(result,"^",4),1:"维修",2:"租赁",3:"转移单",:"")
	s resultex=resultex_"^"	
	i ($p(result,"^",5)'="")&&($p(result,"^",4)=1)  d
	.s resultex=resultex_$p($g(^DHCEQMMaintRequest($p(result,"^",5))),"^",1)
	i ($p(result,"^",5)'="")&&($p(result,"^",4)=2)  d
	.s resultex=resultex_$p($g(^DHCEQRent($p(result,"^",5))),"^",1)
	i ($p(result,"^",5)'="")&&($p(result,"^",4)=3)  d
	.s resultex=resultex_$p($g(^DHCEQStoreMove($p(result,"^",5))),"^",1)
	s resultex=resultex_"^"	
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$Case($p(result,"^",6),1:"送出",2:"返还",:"")
	s resultex=resultex_"^"	
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$Case($p(result,"^",8),1:"科室",2:"服务商",3:"供应商",4:"生产厂商",:"")
	s resultex=resultex_"^"	
	i ($p(result,"^",9)'="")&&($p(result,"^",8)=1)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept", $p(result,"^",9))
	i ($p(result,"^",9)'="")&&($p(result,"^",8)=2)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("cservice", $p(result,"^",9))
	i ($p(result,"^",9)'="")&&($p(result,"^",8)=3)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("prov", $p(result,"^",9))
	i ($p(result,"^",9)'="")&&($p(result,"^",8)=4)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer", $p(result,"^",9))
	s resultex=resultex_"^"	
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("location", $p(result,"^",10))
	s resultex=resultex_"^"	
	;i $p(result,"^",11)'=""  d
	;.s resultex=resultex_$zd($p(result,"^",11),3)
	;日期格式统一调整   modify by jyp  2017-03-02
	s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")
	s resultex=resultex_"^"	
	//i $p(result,"^",12)'=""  d
	s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"time")
	s resultex=resultex_"^"	
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("location", $p(result,"^",13))
	s resultex=resultex_"^"	
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_$Case($p(result,"^",14),1:"科室",2:"服务商",3:"供应商",4:"生产厂商",:"")
	s resultex=resultex_"^"	
	i ($p(result,"^",15)'="")&&($p(result,"^",14)=1)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept", $p(result,"^",15))
	i ($p(result,"^",15)'="")&&($p(result,"^",14)=2)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("cservice", $p(result,"^",15))
	i ($p(result,"^",15)'="")&&($p(result,"^",14)=3)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("prov", $p(result,"^",15))
	i ($p(result,"^",15)'="")&&($p(result,"^",14)=4)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer", $p(result,"^",15))
	s resultex=resultex_"^"	
	;i $p(result,"^",16)'=""  d
	;.s resultex=resultex_$zd($p(result,"^",16),3)
	;日期格式统一调整   modify by jyp  2017-03-02
	s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",16),"date")
	s resultex=resultex_"^"	
	//i $p(result,"^",17)'=""  d
	s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",17),"time")
	s resultex=resultex_"^"	
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",18))
	s resultex=resultex_"^"	
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",19))
	s $p(result,"^",21)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",21),"date")   //add by zc
	s resultex=resultex_"^"	
	s resultex=resultex_##class(web.DHCEQMove).GetPosition(rowid,$p(result,"^",4),$p(result,"^",10),$p(result,"^",31))
	s resultex=resultex_"^"	
	s resultex=resultex_(..GetPosition(rowid,$p(result,"^",4),$p(result,"^",13),$p(result,"^",31)))
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

/// w ##class(web.DHCEQMove).GetPosition(2,1,1,N)
ClassMethod GetPosition(movedr, eventype, locationdr, flag) As %String
{
	i locationdr="" q ""
	s prowid=""
	s mprowid=0
	s mprowid=$o(^DHCEQMovePosition(0,"Move",locationdr,movedr,mprowid))  q:mprowid=""  d
	.q:$p($g(^DHCEQMovePosition(mprowid)),"^",2)'=eventype
	.q:$p($g(^DHCEQMovePosition(mprowid)),"^",11)'=flag
	.s prowid=mprowid
	q prowid
}

ClassMethod GetLocation() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM DHC_EQCLocation where L_InvalidFlag = 'N'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("L_RowID")
		s Desc = result.Data("L_Desc")
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEQCommon).getJsonData("id^text",tmp)
		e  d
		.W ","_##class(web.DHCEQCommon).getJsonData("id^text",tmp)
	}
	w "]"
}

ClassMethod GetMenu() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM DHC_EQCSysMenus"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("M_RowID")
		s Desc = result.Data("M_Name")
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEQCommon).getJsonData("id^text",tmp)
		e  d
		.W ","_##class(web.DHCEQCommon).getJsonData("id^text",tmp)
	}
	w "]"
}

ClassMethod GetUser() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM SS_User"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("SSUSR_RowId")
		s Desc = result.Data("SSUSR_Name")
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEQCommon).getJsonData("id^text",tmp)
		e  d
		.W ","_##class(web.DHCEQCommon).getJsonData("id^text",tmp)
	}
	w "]"
}

ClassMethod GetDeptID(str) As %String
{
	if (str=1)
	{
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT * FROM CT_Loc"
    	d result.Prepare(sqlStr)
		d result.Execute()
		s count = 0
		w "["
		While(result.Next())
		{	
			s RowId = result.Data("CTLOC_RowID")
			s Desc = result.Data("CTLOC_Desc")
			s tmp=RowId_"^"_Desc
			s count = count+1
			I count=1 d
			.W ##class(web.DHCEQCommon).getJsonData("id^text",tmp)
			e  d
			.W ","_##class(web.DHCEQCommon).getJsonData("id^text",tmp)
		}
		w "]"
	}
	if (str=2)
	{
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT * FROM DHC_EQCService"
    	d result.Prepare(sqlStr)
		d result.Execute()
		s count = 0
		w "["
		While(result.Next())
		{	
			s RowId = result.Data("SV_RowID")
			s Desc = result.Data("SV_Name")
			s tmp=RowId_"^"_Desc
			s count = count+1
			I count=1 d
			.W ##class(web.DHCEQCommon).getJsonData("id^text",tmp)
			e  d
			.W ","_##class(web.DHCEQCommon).getJsonData("id^text",tmp)
		}
		w "]"
	}
	if (str=3)
	{
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT * FROM DHC_EQCVendor"
    	d result.Prepare(sqlStr)
		d result.Execute()
		s count = 0
		w "["
		While(result.Next())
		{	
			s RowId = result.Data("V_RowID")
			s Desc = result.Data("V_Name")
			s tmp=RowId_"^"_Desc
			s count = count+1
			I count=1 d
			.W ##class(web.DHCEQCommon).getJsonData("id^text",tmp)
			e  d
			.W ","_##class(web.DHCEQCommon).getJsonData("id^text",tmp)
		}
		w "]"
	}
	if (str=4)
	{
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT * FROM DHC_EQCManufacturer"
    	d result.Prepare(sqlStr)
		d result.Execute()
		s count = 0
		w "["
		While(result.Next())
		{	
			s RowId = result.Data("MF_RowID")
			s Desc = result.Data("MF_Name")
			s tmp=RowId_"^"_Desc
			s count = count+1
			I count=1 d
			.W ##class(web.DHCEQCommon).getJsonData("id^text",tmp)
			e  d
			.W ","_##class(web.DHCEQCommon).getJsonData("id^text",tmp)
		}
		w "]"
	}
}

/// w ##Class(web.DHCEQMove).SaveMoveInfo()
ClassMethod SaveMoveInfo(val, user, frowid, trowid)
{
	new (val,user,frowid,trowid,mrowid,num,mlrowid,flag,EquipIDs)
	k PLIST,rowid
	Set $ZT="ERRORSave"
	s rowid=$p(val,"^",1)		//RowID   
	s PLIST(2)=$p(val,"^",2)	//No
	s PLIST(3)="1"				//ObjType
	s PLIST(4)=$p(val,"^",3)	//ObjID
	s PLIST(5)=$p(val,"^",4)	//SourceType
	s PLIST(6)=$p(val,"^",5)	//SourceID
	s PLIST(7)=$p(val,"^",6)	//EventType
	s PLIST(8)=$p(val,"^",7)	//MoveReason
	s PLIST(9)=$p(val,"^",8)	//FromDeptType
	s PLIST(10)=$p(val,"^",9)	//FromDeptID
	s PLIST(11)=$p(val,"^",10)	//FromLocationDR
	;s PLIST(12)=$zdh($p(val,"^",11),3)	//StartDate
	;日期格式统一调整   modify by jyp  2017-03-02
	s PLIST(12)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"date")
	s PLIST(13)=$p(val,"^",12)	//StartTime
	;i $p(val,"^",12)'="" s PLIST(13)=$zth($p(val,"^",12),3)
	;日期格式统一调整   modify by jyp  2017-03-02
	s PLIST(13)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",12),"time")
	s PLIST(14)=$p(val,"^",13)	//ToLocationDR
	s PLIST(15)=$p(val,"^",14)	//ToDeptType
	s PLIST(16)=$p(val,"^",15)	//ToDeptID
	s PLIST(17)=$p(val,"^",16)
	;i $p(val,"^",16)'="" s PLIST(17)=$zdh($p(val,"^",16),3)	//EndDate
	;日期格式统一调整   modify by jyp  2017-03-02
    s PLIST(17)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",16),"date")
	s PLIST(18)=$p(val,"^",17)	//EndTime
	;i $p(val,"^",17)'="" s PLIST(18)=$zth($p(val,"^",17),3)
	;日期格式统一调整   modify by jyp  2017-03-02
	s PLIST(18)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",17),"time")
	s PLIST(19)=$p(val,"^",18)	//SendUserDR
	s PLIST(20)=$p(val,"^",19)	//AcceptUserDR
	S PLIST(21)=user
	S PLIST(22)=+$H
	S PLIST(23)=$P($H,",",2)
	s PLIST(30)=$p(val,"^",20)	//Remark
	s PLIST(31)=$p(val,"^",21)				//Status
	i $p(val,"^",21)="" s PLIST(31)="0"
	s PLIST(32) ="N"
	s EquipIDs=""
	if ($p(val,"^",4)=3)
	{
		s mrowid=$p(val,"^",5)
		s num=""
		&SQL(select count(*)  into :num from sqluser.DHC_EQStoreMoveList where SML_StoreMoveDR=:mrowid)
		if (num=1)
		{
			s mlrowid=$o(^DHCEQStoreMoveList(0,"StoreMove",mrowid,0))
			s flag=$p($g(^DHCEQStoreMoveList(mlrowid)),"^",3)
			if (flag="Y")
			{
				s PLIST(4)=""
				s EquipIDs=^DHCEQStoreMoveList(mlrowid,"EX","RowIDs")
			}
			else
			{
				s PLIST(4)=$p($g(^DHCEQStoreMoveList(mlrowid)),"^",2)
				s EquipIDs=""
			}
		}
		else
		{
			s PLIST(4)=""
			s EquipIDs=##Class(web.DHCEQMove).GetEquipIds(mrowid)
		}
	} 	
	s tmpid=""
	&SQL(select M_RowID into :tmpid from sqluser.DHC_EQMove where M_ObjID=:PLIST(4) and M_EventType=:PLIST(7) and M_SourceType=:PLIST(5) and M_SourceID=:PLIST(6) and M_FromDeptType=:PLIST(9) and M_FromDeptID=:PLIST(10) and M_InvalidFlag='N')
	if ((tmpid'="")&&(tmpid'=rowid)) q -3003	;重复记录
	TSTART
	if (rowid="")
	{
		i PLIST(2)="" s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQMove",$h,PLIST(10))
		&SQL(Insert Into sqluser.DHC_EQMove Values :PLIST())
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s rowid=$G(%ROWID)
	} 
	else
	{
		&SQL(Update sqluser.DHC_EQMove Values :PLIST() where M_RowID = :rowid)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	if EquipIDs'=""
	{		
	 	s ^DHCEQMove(rowid,"EX","RowIDs")=EquipIDs   	
	}
	else
	{
		k ^DHCEQMove(rowid,"EX","RowIDs")
	}
	i PLIST(11)'=""
	{
		s SQLCODE=..SavePosition(frowid,rowid,PLIST(5),PLIST(11),PLIST(12),PLIST(13),PLIST(32),user)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	i PLIST(14)'=""
	{
		s SQLCODE=..SavePosition(trowid,rowid,PLIST(5),PLIST(14),PLIST(17),PLIST(18),PLIST(32),user)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	TCOMMIT
	Set ID=rowid
	q ID
ERRORSave 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息 ;
}

ClassMethod SaveMoveUser(RowID, MoveDR, UserDR, Remark)
{
	k PLISTMX
	s rowid=RowID
	s PLISTMX(2)=MoveDR				
	s PLISTMX(3)=UserDR	
	s PLISTMX(4)=Remark 
	s tmpid=""
	&SQL(select MU_RowID into :tmpid from sqluser.DHC_EQMoveUsers where MU_MoveDR=:MoveDR and MU_UserDR=:UserDR)
	if ((tmpid'="")&&(tmpid'=rowid)) q -3003	;重复记录
	if (rowid="")
	{
		&SQL(Insert Into SQLUSER.DHC_EQMoveUsers Values :PLISTMX())
		s rowid=$G(%ROWID)
	}
	else
	{
		&SQL(update sqluser.DHC_EQMoveUsers values :PLISTMX() where MU_RowID=:rowid)
	}
	Set ID=rowid
	q ID
}

ClassMethod SavePosition(mrowid, rowid, eventype, locationdr, date, time, flag, user)
{
	new (mrowid,rowid,eventype,locationdr,date,time,flag,user)
	s Date=+$H
	s Time=$P($H,",",2)
	i rowid="" q -1
	k PLISTX
	s PLISTX(2)=mrowid
	s PLISTX(2)=rowid
	s PLISTX(3)=eventype
	s PLISTX(5)=locationdr
	s PLISTX(6)=date
	s PLISTX(7)=time
	s PLISTX(8)=user
	s PLISTX(9)=Date
	s PLISTX(10)=Time
	s PLISTX(12)=flag
	i PLISTX(12)="Y"
	{
		s PLISTX(14)=user
		s PLISTX(15)=Date
		s PLISTX(16)=Time
	}
	if (mrowid="")
	{
		&SQL(Insert Into SQLUSER.DHC_EQMovePosition Values :PLISTX())
		s mrowid=$G(%ROWID)
	}
	else
	{
		&SQL(update sqluser.DHC_EQMovePosition values :PLISTX() where MP_RowID=:mrowid)
	}
 	q SQLCODE
}

/// Modified by HHM 2016-01-21 下拉列表中添加维修设备
/// d ##class(%ResultSet).RunQuery("web.DHCEQMove","GetMaintRequest","","","","1")
Query GetMaintRequest(No, LocName, Date, EventType) As %Query(ROWSPEC = "rowid:%String,no:%String,locname:%String,date:%String,equip:%String") [ SqlProc ]
{
}

ClassMethod GetMaintRequestExecute(ByRef qHandle As %Binary, No, LocName, Date, EventType) As %Status
{
 	new repid, index, rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
	s mrowid=0
	f  s mrowid=$o(^DHCEQMMaintRequest(mrowid))  q:mrowid=""  d
	.d ResetVariablesGetMaintRequest
	.q:($p($g(^DHCEQMMaintRequest(mrowid)),"^",57)="Y")
	.s SourceID=0                  ;add by HHM 2016-01-25
	.d PutOutMoveByMaintRequest    ;add by HHM 2016-01-25   
	.q:mrowid=SourceID             ;过滤已有单子数据
	.s no=$p($g(^DHCEQMMaintRequest(mrowid)),"^",1)
	.s locname=$p($g(^CTLOC($p($g(^DHCEQMMaintRequest(mrowid)),"^",7))),"^",2)
	.s date=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMMaintRequest(mrowid)),"^",18),"date")
	.s equipDR=$p($g(^DHCEQMMaintRequest(mrowid)),"^",5)   ;add by HHM 2016-01-21 添加维修设备
	.q:equipDR=""
	.s equip=$p($g(^DHCEQMExObj(equipDR)),"^",1)      ;add by HHM 2016-01-21 添加维修设备
	.s rowid=mrowid

	.d OutputRowGetMaintRequest
	Quit $$$OK
	
	//add by HHM 2016-01-25  过滤已有单子数据
	//维修
PutOutMoveByMaintRequest
	q:EventType=""
	s Flag="N"
	s MoveDR=0    
	f  s MoveDR=$o(^DHCEQMove(0,"SourceType",1,MoveDR)) q:((MoveDR="")||(Flag="Y"))  d    
	.s InvalidFlag=$p($g(^DHCEQMove(MoveDR)),"^",31)
	.q:InvalidFlag="Y"   //过滤无效数据
	.s SourceID=$p($g(^DHCEQMove(MoveDR)),"^",5)
	.s TEventType=$p($g(^DHCEQMove(MoveDR)),"^",6)
	.s SourceType=$p($g(^DHCEQMove(MoveDR)),"^",4)
	.i ((SourceID=mrowid)&(TEventType=EventType)) s Flag="Y"
	.e  s SourceID=0
	quit
OutputRowGetMaintRequest
	s Data=$lb(rowid,no,locname,date,equip)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintRequest
	s (rowid,no,locname,date,equip)=""
	quit
}

ClassMethod GetMaintRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintRequestExecute ]
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

ClassMethod GetMaintRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modified by HHM 2016-01-21 添加下拉列表租赁列
/// d ##class(%ResultSet).RunQuery("web.DHCEQMove","GetRent","","","","1")
Query GetRent(No, LocName, Date, EventType) As %Query(ROWSPEC = "rowid:%String,no:%String,locname:%String,date:%String,equip:%String") [ SqlProc ]
{
}

ClassMethod GetRentExecute(ByRef qHandle As %Binary, No, LocName, Date, EventType) As %Status
{
 	new repid, index, rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
	s rrowid=0
	f  s rrowid=$o(^DHCEQRent(rrowid))  q:rrowid=""  d
	.d ResetVariablesGetRent
	.s SourceID=0
	.d PutOutMoveByRent
	.q:rrowid=SourceID
	.s no=$p($g(^DHCEQRent(rrowid)),"^",1)
	.s locname=$p($g(^CTLOC($p($g(^DHCEQRent(rrowid)),"^",2))),"^",2)
	.s date=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQRent(rrowid)),"^",5),"date")
	.s equipDR=$p($g(^DHCEQRent(rrowid)),"^",9)  ;add by HHM 2016-01-21 
	.q:equipDR=""
	.s equip=$p($g(^DHCEQEquip(equipDR)),"^",1)  ;add by HHM 2016-01-21
	.s rowid=rrowid
	.d OutputRowGetRent
	Quit $$$OK
	
	//add by HHM 2016-01-25  过滤已有单子数据
	//租赁
PutOutMoveByRent
	q:EventType=""
	s Flag="N"
	s MoveDR=0    
	f  s MoveDR=$o(^DHCEQMove(0,"SourceType",2,MoveDR)) q:((MoveDR="")||(Flag="Y"))  d
	.s InvalidFlag=$p($g(^DHCEQMove(MoveDR)),"^",31)
	.q:InvalidFlag="Y"   //过滤无效数据
	.s SourceID=$p($g(^DHCEQMove(MoveDR)),"^",5)
	.s TEventType=$p($g(^DHCEQMove(MoveDR)),"^",6)
	.s SourceType=$p($g(^DHCEQMove(MoveDR)),"^",4)
	.;i ((SourceID=rrowid)&(TEventType=EventType)&(SourceType="2")) s Flag="Y"
	.i ((SourceID=rrowid)&(TEventType=EventType)) s Flag="Y"
	.e  s SourceID=0	
	quit

OutputRowGetRent
	s Data=$lb(rowid,no,locname,date,equip)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRent
	s (rowid,no,locname,date,equip)=""
	quit
}

ClassMethod GetRentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRentExecute ]
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

ClassMethod GetRentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modified by HHM 2016-01-21  下拉列表添加转移设备列信息
/// add HHM 2016-01-21 参数：EventType 根据"借出"、"返还"和已审核的单子，过滤
/// d ##class(%ResultSet).RunQuery("web.DHCEQMove","GetStoreMove","","","","2")
Query GetStoreMove(No, LocName, Date, EventType) As %Query(ROWSPEC = "rowid:%String,no:%String,locname:%String,date:%String,equip:%String") [ SqlProc ]
{
}

ClassMethod GetStoreMoveExecute(ByRef qHandle As %Binary, No, LocName, Date, EventType) As %Status
{
 	new repid, index, rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	
	s srowid=0
	f  s srowid=$o(^DHCEQStoreMove(srowid))  q:srowid=""  d
	.d ResetVariablesGetStoreMove
	.q:($p($g(^DHCEQStoreMove(srowid)),"^",27)="Y")
	.s SourceID=0
	.d PutOutMoveByStoreMove    ;add by HHM 2016-01-25  
	.q:srowid=SourceID          //过滤
	.s no=$p($g(^DHCEQStoreMove(srowid)),"^",1)
	.s locname=$p($g(^CTLOC($p($g(^DHCEQStoreMove(srowid)),"^",2))),"^",2)
	.s date=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(srowid)),"^",5),"date")
	.s storeMoveListDR=$o(^DHCEQStoreMoveList(0,"StoreMove",srowid,0))    ;add by HHM 2016-01-21 
	.s equip=$p($g(^DHCEQStoreMoveList(storeMoveListDR)),"^",5)           ;add by HHM 2016-01-21
	.s rowid=srowid
	.d OutputRowGetStoreMove
 	
	Quit $$$OK
	
	//add by HHM 2016-01-25  过滤已有单子数据
	//转移
PutOutMoveByStoreMove	
	q:EventType=""
	s Flag="N"
	s MoveDR=0    
	f  s MoveDR=$o(^DHCEQMove(0,"SourceType",3,MoveDR)) q:((MoveDR="")||(Flag="Y"))  d
	.s InvalidFlag=$p($g(^DHCEQMove(MoveDR)),"^",31)
	.q:InvalidFlag="Y"   //过滤无效数据
	.s SourceID=$p($g(^DHCEQMove(MoveDR)),"^",5)
	.s TEventType=$p($g(^DHCEQMove(MoveDR)),"^",6)
	.s SourceType=$p($g(^DHCEQMove(MoveDR)),"^",4)
	.i ((SourceID=srowid)&(TEventType=EventType)) s Flag="Y"
	.e  s SourceID=0
	quit
	
OutputRowGetStoreMove
	s Data=$lb(rowid,no,locname,date,equip)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStoreMove
	s (rowid,no,locname,date,equip)=""
	quit
}

ClassMethod GetStoreMoveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveExecute ]
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

ClassMethod GetStoreMoveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DeleteMoveInfo(Rowid, User, frowid, trowid, InvalidReason)
{
	n (Rowid,User,frowid,trowid,InvalidReason)
	s Date=+$h
	s Time=$p($h,",",2)
	i (Rowid'="") 
	{
		&SQL(update sqluser.DHC_EQMove set M_InvalidFlag='Y' ,M_InvalidUserDR=:User,M_InvalidDate=:Date, M_InvalidTime=:Time,M_InvalidReason=:InvalidReason where M_RowID = :Rowid)  //Modefied by zc
		i (frowid'="")
		{
			&SQL(update sqluser.DHC_EQMovePosition set MP_InvalidFlag='Y' ,MP_InvalidUserDR=:User,MP_InvalidDate=:Date, MP_InvalidTime=:Time,MP_InvalidReason=:InvalidReason where MP_RowID = :frowid and MP_MoveDR=:Rowid)   //Modefied by zc
		}
		i (trowid'="")
		{
			&SQL(update sqluser.DHC_EQMovePosition set MP_InvalidFlag='Y' ,MP_InvalidUserDR=:User,MP_InvalidDate=:Date, MP_InvalidTime=:Time,MP_InvalidReason=:InvalidReason where MP_RowID = :trowid and MP_MoveDR=:Rowid)   //Modefied by zc
		}
	}
	Q SQLCODE
}

ClassMethod SubitMoveInfo(flag, Rowid, User)
{
	n (flag,Rowid ,User,Date,Time)
	s Date=+$h
	s Time=$p($h,",",2)
	i (Rowid'="") 
	{
		i (flag=1)
		{
			&SQL(update sqluser.DHC_EQMove set M_Status='1' ,M_SubmitUserDR=:User,M_SubmitDate=:Date, M_SubmitTime=:Time where M_RowID = :Rowid)
		}
		i (flag=2)
		{
			&SQL(update sqluser.DHC_EQMove set M_Status='2'  ,M_AuditUserDR=:User,M_AuditDate=:Date, M_AuditTime=:Time where M_RowID = :Rowid)
		}
	}
	Q SQLCODE
}

/// w ##Class(web.DHCEQMove).GetEquipInfo(3,8)
ClassMethod GetEquipInfo(isDel, rowid)
{
	i (isDel="")||(rowid="") q ""
	s (info,model,unit,equipdr,eqname,eqno)=""
	
	i isDel=1 d
	.s equipdr=$p($g(^DHCEQMExObj($p($g(^DHCEQMMaintRequest(rowid)),"^",5))),"^",5)
	.;s equipdr=$p($g(^DHCEQMMaintRequest(rowid)),"^",5)
	.s eqname=$p($g(^DHCEQEquip(equipdr)),"^",1) 
	.s eqno=$p($g(^DHCEQEquip(equipdr)),"^",71) 
	.s modeldr = $p($g(^DHCEQEquip(equipdr)),"^",3)
	.i modeldr'="" s model = $p($g(^DHCEQCCode("DHCEQCModel",modeldr)),"^",2)
	.s unitdr = $p($g(^DHCEQEquip(equipdr)),"^",5)
	.i unitdr'="" s unit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",unitdr)
	.s storelocdr=$p($g(^DHCEQEquip(equipdr)),"^",19)
	.s locationdr=$p($g(^DHCEQEquip(equipdr)),"^",72) 
	.s info=equipdr_"^"_eqname_"^"_eqno_"^"_model_"^"_unit_"^"_storelocdr_"^"_locationdr
	e  i isDel=2 d
	.s equipdr=$p($g(^DHCEQRent(rowid)),"^",9)
	.s eqname=$p($g(^DHCEQEquip(equipdr)),"^",1) 
	.s eqno=$p($g(^DHCEQEquip(equipdr)),"^",71) 
	.s modeldr = $p($g(^DHCEQEquip(equipdr)),"^",3)
	.i modeldr'="" s model = $p($g(^DHCEQCCode("DHCEQCModel",modeldr)),"^",2)
	.s unitdr = $p($g(^DHCEQEquip(equipdr)),"^",5)
	.i unitdr'="" s unit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",unitdr)
	.s storelocdr=$p($g(^DHCEQEquip(equipdr)),"^",19)
	.s locationdr=$p($g(^DHCEQEquip(equipdr)),"^",72) 
	.s info=equipdr_"^"_eqname_"^"_eqno_"^"_model_"^"_unit_"^"_storelocdr_"^"_locationdr
	e  i isDel=3 d	
	.s smrowid=0
	.s num=""
	.&SQL(select count(*)  into :num from sqluser.DHC_EQStoreMoveList where SML_StoreMoveDR=:rowid)
	.i num=1 d
	..s smrowid=$o(^DHCEQStoreMoveList(0,"StoreMove",rowid,0))
	..i $p($g(^DHCEQStoreMoveList(smrowid)),"^",3)'="Y" d   ;非批量
	...s equipdr=$p($g(^DHCEQStoreMoveList(smrowid)),"^",2)
	...s eqname=$p($g(^DHCEQEquip(equipdr)),"^",1) 
	...s eqno=$p($g(^DHCEQEquip(equipdr)),"^",71) 
	...s modeldr = $p($g(^DHCEQEquip(equipdr)),"^",3)
	...i modeldr'="" s model = $p($g(^DHCEQCCode("DHCEQCModel",modeldr)),"^",2)
	...s unitdr = $p($g(^DHCEQEquip(equipdr)),"^",5)
	...i unitdr'="" s unit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",unitdr)
	...s storelocdr=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	...s locationdr=$p($g(^DHCEQEquip(equipdr)),"^",72)
	...s tolocdr=$p($g(^DHCEQStoreMove(rowid)),"^",3)
	...s info=equipdr_"^"_eqname_"^"_eqno_"^"_model_"^"_unit_"^"_storelocdr_"^"_locationdr_"^"_tolocdr_"^"_""
	..e  d 
	...s modeldr = $p($g(^DHCEQStoreMoveList(smrowid)),"^",9)
	...i modeldr'="" s model = $p($g(^DHCEQCCode("DHCEQCModel",modeldr)),"^",2)
	...s unitdr = $p($g(^DHCEQStoreMoveList(smrowid)),"^",10)
	...i unitdr'="" s unit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",unitdr)
	...s storelocdr=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	...s tolocdr=$p($g(^DHCEQStoreMove(rowid)),"^",3) 
	...s locationdr=$p($g(^DHCEQStoreMoveList(smrowid)),"^",12)
	...s info=equipdr_"^"_eqname_"^"_eqno_"^"_model_"^"_unit_"^"_storelocdr_"^"_""_"^"_tolocdr_"^"_locationdr
	.e  d
	..s storelocdr=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	..s tolocdr=$p($g(^DHCEQStoreMove(rowid)),"^",3)
	..s info=equipdr_"^"_eqname_"^"_eqno_"^"_model_"^"_unit_"^"_storelocdr_"^"_""_"^"_tolocdr
	q info
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQMove","GetEquip","10836","","")
Query GetEquip(RowID, No, Name) As %Query(ROWSPEC = "rowid:%String,name:%String,no:%String,modeldr:%String,model:%String") [ SqlProc ]
{
}

ClassMethod GetEquipExecute(ByRef qHandle As %Binary, RowID, No, Name) As %Status
{
 	new repid, index, rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
	s erowid=0
	f  s erowid=$o(^DHCEQEquip(erowid))  q:erowid=""  d
	.d ResetVariablesGetEquip
	.q:erowid'=RowID
	.q:($p($g(^DHCEQEquip(erowid)),"^",59)="Y")
	.q:($p($g(^DHCEQEquip(erowid)),"^",38)>3)
	.s name=$p($g(^DHCEQEquip(erowid)),"^",1)
	.s no=$p($g(^DHCEQEquip(erowid)),"^",71)
	.s modeldr=$p($g(^DHCEQEquip(erowid)),"^",3)
	.i modeldr'="" s model = $p($g(^DHCEQCCode("DHCEQCModel",modeldr)),"^",2)
	.s rowid=erowid
	.d OutputRowGetEquip
	Quit $$$OK
	
OutputRowGetEquip
	s Data=$lb(rowid,name,no,modeldr,model)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquip
	s (rowid,name,no,modeldr,model)=""
	quit
}

ClassMethod GetEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipExecute ]
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

ClassMethod GetEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQMove","MoveUser")
Query MoveUser(MoveDR) As %Query(ROWSPEC = "rowid:%String,movedr:%String,userdr:%String,user:%String,remark:%String,statusdr:%String,flag:%String") [ SqlProc ]
{
}

ClassMethod MoveUserExecute(ByRef qHandle As %Binary, MoveDR) As %Status
{
 	new repid, index, rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
	s mrowid=0
	f  s mrowid=$o(^DHCEQMoveUsers(mrowid))  q:mrowid=""  d
	.d ResetVariablesMoveUser
	.s movedr=$p($g(^DHCEQMoveUsers(mrowid)),"^",1)
	.q:movedr'=MoveDR
	.s statusdr=$p($g(^DHCEQMove(movedr)),"^",30)
	.s flag=$p($g(^DHCEQMove(movedr)),"^",31)
	.s userdr=$p($g(^DHCEQMoveUsers(mrowid)),"^",2)
	.i userdr'="" s user=##class(web.DHCEQCommon).GetTrakNameByID("user",userdr)
	.s remark=$p($g(^DHCEQMoveUsers(mrowid)),"^",3)
	.s rowid=mrowid

	.d OutputRowMoveUser
	Quit $$$OK
	
OutputRowMoveUser
	s Data=$lb(rowid,movedr,userdr,user,remark,statusdr,flag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesMoveUser
	s (rowid,movedr,userdr,user,remark,statusdr,flag)=""
	quit
}

ClassMethod MoveUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MoveUserExecute ]
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

ClassMethod MoveUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MoveUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQMove).GetMoveUserInfo(1)
ClassMethod GetMoveUserInfo(rowid)
{
	s info=""
	s mrowid=0
	f  s mrowid=$o(^DHCEQMoveUsers(mrowid))  q:mrowid=""  d
	.q:$p($g(^DHCEQMoveUsers(mrowid)),"^",1)'=rowid	
	.i info="" d
	..s info=mrowid
	.e  d
	..s info=info_"^"_mrowid	
	q info
}

/// w ##Class(web.DHCEQMove).CheckMoveUnqIdx()
ClassMethod CheckMoveUnqIdx(rowid)
{
	n result	
	s result= ^DHCEQMove(rowid)
	k PLIST
	s PLIST(3)=$p(result,"^",1)
	;modify by QW 20160218 修改字段顺序
	s PLIST(4)=$p(result,"^",3)
	s PLIST(5)=$p(result,"^",4)
	s PLIST(6)=$p(result,"^",5)
	i $p(result,"^",6)=1 d  ;End By QW 20160218
	.s PLIST(7)=2
	e  d
	.s PLIST(7)=1
	s PLIST(9)=$p(result,"^",14)
	s PLIST(10)=$p(result,"^",15)
	s PLIST(11)=$p(result,"^",13)
	s tmpid=""
	&SQL(select M_RowID into :tmpid from sqluser.DHC_EQMove where M_ObjID=:PLIST(4) and M_EventType=:PLIST(7) and M_SourceType=:PLIST(5) and M_SourceID=:PLIST(6) and M_FromDeptType=:PLIST(9) and M_FromDeptID=:PLIST(10)  and M_InvalidFlag='N')
	
	q tmpid
}

/// w ##Class(web.DHCEQMove).CreatMoveInfo()
ClassMethod CreatMoveInfo(rowid, user, frowid, trowid)
{
	new (rowid,user,frowid,trowid)
	k PLIST
	n result	
	s result= ^DHCEQMove(rowid)
	Set $ZT="ERRORCreat" 
	s PLIST(2)="" 
	s PLIST(3)="1"					//ObjType
	;s PLIST(4)=$p(result,"^",2)		//ObjID
	s PLIST(5)=$p(result,"^",4)		//SourceType
	s PLIST(6)=$p(result,"^",5)		//SourceID
	i $p(result,"^",3)=3 d
	.s num=""
	.&SQL(select count(*) into :num from sqluser.DHC_EQStoreMoveList where SML_StoreMoveDR=:PLIST(6))
	.i num>1 d
	..s PLIST(4)=^DHCEQMove(rowid,"EX","RowIDs")
	.e  d
	..s PLIST(4)=$p(result,"^",3)
	e  d
	.s PLIST(4)=$p(result,"^",3)
	i $p(result,"^",6)=1 d
	.s PLIST(7)=2
	e  d
	.s PLIST(7)=1
	s PLIST(9)=$p(result,"^",14)		//FromDeptType
	s PLIST(10)=$p(result,"^",15)	//FromDeptID
	s PLIST(11)=$p(result,"^",13)	//FromLocationDR
	;S PLIST(12)=+$H	
	s PLIST(14)=$p(result,"^",10)	//ToLocationDR
	s PLIST(15)=$p(result,"^",8)	//ToDeptType
	s PLIST(16)=$p(result,"^",9)	//ToDeptID
	s PLIST(19)=user	//SendUserDR  //Add By QW 20160218 默认存入送出人
	S PLIST(21)=user
	S PLIST(22)=+$H
	S PLIST(23)=$P($H,",",2)
	s PLIST(31)="0"				//Status
	s PLIST(32) ="N"
	TSTART
	i PLIST(2)="" s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQMove",$h,PLIST(10))
	&SQL(Insert Into sqluser.DHC_EQMove Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s rowid=$G(%ROWID)
	i PLIST(11)'=""
	{
		s SQLCODE=..SavePosition(frowid,rowid,PLIST(5),PLIST(11),"","",PLIST(32),user)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	i PLIST(14)'=""
	{
		s SQLCODE=..SavePosition(trowid,rowid,PLIST(5),PLIST(14),"","",PLIST(32),user)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	TCOMMIT
	Set ID=rowid
	q ID
ERRORCreat 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORCreat>"_ErrorMsg     //返回错误消息 ;
}

/// add by zx 2015-12-18
/// 根据设备ID获取最近时间维修、租赁等单据信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQMove","BusinessList","")
Query BusinessList(EquipDR) As %Query(ROWSPEC = "TSourceID:%String,TNo:%String,TRequestLoc:%String,TRequestDate:%String,TSourceType:%String,TSourceTypeID:%String") [ SqlProc ]
{
}

ClassMethod BusinessListExecute(ByRef qHandle As %Binary, EquipDR) As %Status
{
	new repid, index, rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	s Date=+$h
 	
	s ObjLocDR=0
	f  s ObjLocDR=$o(^DHCEQMMaintRequest(0,"ObjLoc",ObjLocDR)) q:ObjLocDR=""  d
	.s MaintRequestDR=0
	.f AddDate=Date-5:1:Date d   //5天之前的单据过滤
	..f  s MaintRequestDR=$o(^DHCEQMMaintRequest(0,"ObjLoc",ObjLocDR,AddDate,MaintRequestDR)) q:MaintRequestDR=""  d
	...d ResetVariablesBusinessList
	...s TExObjDR = $p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",5)
	...s TType=$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",63)
	...q:TType'=1
	...i TExObjDR'="" s TEquipDR=$p($g(^DHCEQMExObj(TExObjDR)),"^",5)
	...q:(EquipDR'="")&&(EquipDR'=TEquipDR)
	...s TSourceID=MaintRequestDR
	...s TNo=$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",1)
	...s TRequestLoc=$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",7)
	...i TRequestLoc'="" s TRequestLoc=$p($g(^CTLOC(TRequestLoc)),"^",2)
	...s TRequestDate=$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",18)
	...;i TRequestDate'="" s TRequestDate=$zd(TRequestDate,3)
	...;日期格式统一调整   modify by jyp  2017-03-02
	...s TRequestDate=##Class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	...s TSourceType="维修"
	...s TSourceTypeID=1
	...d OutputRowBusinessList
	
	s RentDR=0
	f  s RentDR=$o(^DHCEQRent(RentDR)) q:RentDR=""  d
	.d ResetVariablesBusinessList
	.q:$p($g(^DHCEQRent(RentDR)),"^",5)<Date-5   //5天之前的单据过滤
	.s TEquipDR=$p($g(^DHCEQRent(RentDR)),"^",9)
	.q:(EquipDR'="")&&(EquipDR'=TEquipDR)
	.s TSourceID=RentDR
	.s TNo=$p($g(^DHCEQRent(RentDR)),"^",1)
	.s TRequestLoc=$p($g(^DHCEQRent(RentDR)),"^",2)
	.i TRequestLoc'="" s TRequestLoc=$p($g(^CTLOC(TRequestLoc)),"^",2)
	.s TRequestDate=$p($g(^DHCEQRent(RentDR)),"^",5)
	.;i TRequestDate'="" s TRequestDate=$zd(TRequestDate,3)
    	.;日期格式统一调整   modify by jyp  2017-03-02
	.s TRequestDate=##Class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	.s TSourceType="租赁"
	.s TSourceTypeID=2
	.d OutputRowBusinessList
	Quit $$$OK
	
OutputRowBusinessList
	s Data=$lb(TSourceID, TNo, TRequestLoc, TRequestDate, TSourceType, TSourceTypeID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesBusinessList
	s (TExObjDR, TEquipDR, TType, TSourceID, TNo, TRequestLoc, TRequestDate, TSourceType, TSourceTypeID)=""
	quit
}

ClassMethod BusinessListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BusinessListExecute ]
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

ClassMethod BusinessListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BusinessListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQMove).GetEquipIds()
ClassMethod GetEquipIds(mrowid)
{
	s str=""
	s EquipIDs=""
	s mlrowid=0
	f  s mlrowid=$o(^DHCEQStoreMoveList(0,"StoreMove",mrowid,mlrowid))  q:mlrowid=""  d
	.s flag=$p($g(^DHCEQStoreMoveList(mlrowid)),"^",3)
	.i flag="Y" d
	..s str=^DHCEQStoreMoveList(mlrowid,"EX","RowIDs")
	.e  d
	..s str=$p($g(^DHCEQStoreMoveList(mlrowid)),"^",2)
	.i EquipIDs="" d
	..s EquipIDs=EquipIDs_str
	.e  d
	..s EquipIDs=EquipIDs_","_str
	q EquipIDs
}

/// w ##Class(web.DHCEQMove).GetEquipNoInfo("10964,10965,10955,10972")
ClassMethod GetEquipNoInfo(equipRowIDs)
{
	s count=$l(equipRowIDs,",")
	s equipno=""
	f i=1:1:count d
	.s equipdr=$p(equipRowIDs,",",i)
	.i equipdr'=""  d
	..i equipno'="" s equipno=equipno_","
	..s equipno=equipno_$p($g(^DHCEQEquip(equipdr)),"^",71)
	q equipno
}

/// d ##Class(web.DHCEQMove).CancelSub(11)
ClassMethod CancelSub(rowid)
{
	q:rowid=""
	&SQL(UPDATE SQLUSER.DHC_EQMove SET M_Status='0' WHERE M_RowID=:rowid)
	i SQLCODE q:SQLCODE
	e  q:SQLCODE
}

}
