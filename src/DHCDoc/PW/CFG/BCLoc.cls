/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 医生站交班本操作类
Class DHCDoc.PW.CFG.BCLoc Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 保存/更新交班本关联科室
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCLoc).Save("","1^1")
ClassMethod Save(ID = "", inPara = "") As %String
{
	s MID=$P(inPara,"^",1)
	s LocID=$P(inPara,"^",2)
	Q:MID="" "-1^父表ID为空！"
	Q:LocID="" "-1^科室为空！"
	s HasFlag=..IsAdd(ID,inPara)
	Q:+HasFlag<0 HasFlag
	i ID = "" s SaveOBJ = ##class(User.DHCDocPassWorkBCLoc).%New(MID)
	e  s SaveOBJ = ##class(User.DHCDocPassWorkBCLoc).%OpenId(ID)
	d SaveOBJ.BLParRefSetObjectId(MID)
	d SaveOBJ.BLLocSetObjectId(LocID)
	
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		Quit "-1^保存关联科室失败！"
	}
		
	q 1_"^"
}

/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCLoc).Delete("")
ClassMethod Delete(ID As %String)
{
	Q:ID="" 0
	&SQL(DELETE FROM SQLUser.DHCDocPassWorkBCLoc WHERE ID=:ID)
	Q:SQLCODE'=0 -102
	
	Q 0
}

/// CTOR: QP
/// DATE: 2021-08-10
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCLoc).DeleteByMID("11111")
ClassMethod DeleteByMID(MID As %String)
{
	Q:MID="" 0
	&SQL(DELETE FROM SQLUser.DHCDocPassWorkBCLoc WHERE BL_ParRef=:MID)
	Q:SQLCODE=100 0
	Q:SQLCODE'=0 -102
	
	Q 0
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 判断能否添加
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCLoc).Save("","1^1")
ClassMethod IsAdd(ID = "", inPara = "") As %String
{
	s MID=$P(inPara,"^",1)
	s LocID=$P(inPara,"^",2)
	
	i ID="" {
		i $d(^User.DHCDocPassWorkBCLocI("BLLoc",LocID,MID)) {
			Q "-1^科室已存在！"
		}
	} else {
		s sub=$p(ID,"||",2)
		s oldLoc=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildLoc",sub),2)
		i $d(^User.DHCDocPassWorkBCLocI("BLLoc",LocID,MID)) {
			i oldLoc'=LocID {
				Q "-1^科室已存在！"
			}
		}
	}
	;判断是否在其他交班类型中存在
	s CID="",Msg=""
	f  s CID=$O(^User.DHCDocPassWorkBCLocI("BLLoc",LocID,CID)) Q:CID=""  d
	.Q:CID=MID
	.s MDesc=$lg(^User.DHCDocPassWorkBCMainD(CID),4)
	.s active=$lg(^User.DHCDocPassWorkBCMainD(CID),5)
	.Q:active'=1
	.s type=$lg(^User.DHCDocPassWorkBCMainD(CID),3)
	.s typeDesc=##class(DHCDoc.PW.CFG.BCMain).GetBTypeDesc(type)
	.s Msg="该科室已在【"_typeDesc_": "_ MDesc_"】中存在！"
	
	i Msg'="" {
		Q -1_"^"_Msg
	}
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCLoc).GetLocStr(MID)
ClassMethod GetLocStr(MID As %String)
{
	s mRtn=""
	Q:MID="" mRtn
	s sub=""
	f  s sub=$o(^User.DHCDocPassWorkBCMainD(MID,"ChildLoc",sub)) q:sub=""  d
	.s locid=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildLoc",sub),2)
	.s locname=$p(^CTLOC(locid),"^",2)
	.i mRtn="" s mRtn=locname
	.e  s mRtn=mRtn_","_locname
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 查询交班本配置
/// IN  : 
/// OUT : 
/// TABL: DHC_DocPassWorkBcs
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.CFG.BCLoc","QryBCLoc",1)
Query QryBCLoc(InMID = "") As %Library.Query(ROWSPEC = "rowid,locid,locname")
{
}

ClassMethod QryBCLocExecute(ByRef qHandle As %Library.Binary, InMID = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (InMID="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s sub=""
	f  s sub=$o(^User.DHCDocPassWorkBCMainD(InMID,"ChildLoc",sub)) Q:sub=""  d
	.s locid=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildLoc",sub),2)
	.q:locid=""
	.s locname=$p(^CTLOC(locid),"^",2)
	.s rowid=InMID_"||"_sub
	.d OuputRow1
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	set Data=$lb(rowid,locid,locname)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryBCLocFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryBCLocExecute ]
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

ClassMethod QryBCLocClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryBCLocFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DESC: 科室
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCDoc.PW.CFG.BCLoc","QryGetdep","","","I")
Query QryGetdep(Desc As %String = "", InHosp = "", InLcoType = "") As %Query(ROWSPEC = "id:%String,text:%String,code")
{
}

ClassMethod QryGetdepExecute(ByRef qHandle As %Binary, Desc As %String = "", InHosp = "", InLcoType = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    Set Desc=$zcvt(Desc,"U")
    if (Desc="") {
	    //Set qHandle=$lb(0,repid,0)
    	//Quit $$$OK
	  }
    s locid=""
    f  s locid=$o(^CTLOC(locid))  q:locid=""  d
    .s locdesc=$p(^CTLOC(locid),"^",2)
    .i locdesc["-"  s locdesc=$p(locdesc,"-",2)
    .s type=$p(^CTLOC(locid),"^",13)
    .s code=$p(^CTLOC(locid),"^",43)
    .s dateFrom=$p(^CTLOC(locid),"^",24)
    .s dateTo=$p(^CTLOC(locid),"^",25)
    .q:(dateFrom'="")&&(dateFrom>+$h)
    .q:(dateTo'="")&&(dateTo<+$h)
    .s code=$zcvt(code,"U")
    .s locType=##class(DHCDoc.PW.COM.Method).GetDepType(locid)
    .q:(InLcoType'="")&&(locType'=InLcoType)
    .q:(Desc'="")&&(code'[Desc)&&(locdesc'[Desc)
    .q:(type'="E")&&(type'="EM")
    .s hospDr=$p(^CTLOC(locid),"^",22)
    .q:(InHosp'="")&&(hospDr'=InHosp)
    
    .d output7
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
output7
    set Data=$lb(locid,locdesc,code)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryGetdepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetdepExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryGetdepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetdepExecute ]
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

}
