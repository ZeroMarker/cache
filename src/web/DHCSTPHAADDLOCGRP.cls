Import SQLUser

Class web.DHCSTPHAADDLOCGRP Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator			hulihua
/// Creatdate		2014-06-25
/// Description	    住院药房科室组配置的科室组描述的增加
/// Input           LocDesc-科室组描述,DispLocRowid-药房的id
/// table           DHC_StkLocGroup
ClassMethod Insert(LocDesc, DispLocRowid) As %String
{
    
	 n (LocDesc,DispLocRowid)
	 q:DispLocRowid="" -2
	 q:LocDesc="" -1
	 q:'$d(^CTLOC(DispLocRowid)) -2
	 &SQL(
		SELECT * FROM DHC_StkLocGroup 
		WHERE SLG_Loc_DR=:DispLocRowid AND SLG_Type='G' AND SLG_Desc=:LocDesc AND SLG_AppType='DHCSTCOMMON'
	 )
	 q:SQLCODE=0 -4
	 k PLIST
	 s PLIST(2)=LocDesc
	 s PLIST(3)=LocDesc
	 s PLIST(4)="G"
	 s PLIST(5)="DHCSTCOMMON"
	 s PLIST(6)=DispLocRowid
	 &sql(insert into  DHC_StkLocGroup values PLIST())
	 q:SQLCODE'=0 -3
	 q $p(%ROWID,$c(1))
}

/// Creator			hulihua
/// Creatdate		2014-06-25
/// Description	    住院药房科室组配置的科室组描述的修改
/// Input           Trowid-科室组的id,LocDesc-科室组描述,DispLocRowid-药房的id
/// table           DHC_StkLocGroup
ClassMethod Update(Trowid, LocDesc, DispLocRowid) As %String
{
	 n (Trowid,LocDesc,DispLocRowid)
	 q:DispLocRowid="" -1
	 q:'$d(^CTLOC(DispLocRowid)) -2
	 &SQL(
		SELECT * FROM DHC_StkLocGroup 
		WHERE SLG_Loc_DR=:DispLocRowid AND SLG_Type='G' AND SLG_Desc=:LocDesc AND SLG_AppType='DHCSTCOMMON'
		AND SLG_RowId!=:Trowid
	 )
	 q:SQLCODE=0 -4
	 s SLGType="G"
	 s AppType="DHCSTCOMMON"
	 i Trowid="" d
     .&sql(insert into DHC_StkLocGroup(SLG_Code, SLG_Desc, SLG_Type, SLG_AppType, SLG_Loc_DR) values (:LocDesc,:LocDesc,:SLGType,:AppType,:DispLocRowid) )
     e  d
	 .&sql(update DHC_StkLocGroup set SLG_Code=:LocDesc, SLG_Desc=:LocDesc, SLG_Type=:SLGType, SLG_AppType=:AppType, SLG_Loc_DR=:DispLocRowid where  SLG_RowId=:Trowid)
	 q:SQLCODE'=0 -1
	 q $p(%ROWID,$c(1))
}

/// Creator			hulihua
/// Creatdate		2014-06-25
/// Description	    住院药房科室组配置的科室组描述的删除
/// Input           Trowid-科室组的id
/// table           DHC_StkLocGroup
ClassMethod Delete(Trowid) As %String
{
	 n (Trowid)
	 &sql(delete from  DHC_StkLocGroup where SLG_RowId=:Trowid)
	 q:SQLCODE'=0 -1
	 q $p(%ROWID,$c(1))
}

/// Creator			hulihua
/// Creatdate		2014-06-25
/// Description	    住院药房科室组配置的科室组列表
/// Input			DispLoc药房名称，LocDesc科室组描述
/// Output:         科室组描述 科室组id 所关联的药房
/// table:          DHC_StkLocGroup
Query GetLocGrp(LocDesc As %String, DispLocRowid As %String, LocGrpName, HospId = "") As %Query(ROWSPEC = "Tdesc:%String,Trowid:%String,Tdisploc:%String,TdisplocId:%String")
{
}

ClassMethod GetLocGrpExecute(ByRef qHandle As %Binary, LocDesc As %String, DispLocRowid As %String, LocGrpName, HospId = "") As %Status
{

    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    //i DispLocRowid="" s DispLocRowid=$g(%session.Data("LOGON.CTLOCID"))
    i DispLocRowid="全部" s DispLocRowid=""
    s slg="0"
    f  s slg=$o(^DHCSLG(slg)) q:slg=""  d
    .s desc=$p(^DHCSLG(slg),"^",2)
    .s disploc=$p(^DHCSLG(slg),"^",5)
    .q:disploc=""
    .q:(LocGrpName'="")&(desc'[LocGrpName)
    .s displocdesc=$p(^CTLOC(disploc),"^",2)
    .q:(desc'=LocDesc)&(LocDesc'="")
    .q:(disploc'=DispLocRowid)&(DispLocRowid'="")
    .q:(HospId'="")&&(HospId'=$p(^CTLOC(disploc),"^",22))
    .d OutRowLocGrp
	Quit $$$OK
OutRowLocGrp
	set Data=$lb(desc,slg,displocdesc,disploc)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetLocGrpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocGrpExecute ]
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

ClassMethod GetLocGrpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocGrpExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator			hulihua
/// Creatdate		2014-06-25
/// Description	    住院药房科室组配置的科室列表
/// Input			mRowid科室组的id
/// Output:         科室名称 科室id 是否与左边科室组关联
/// table:          DHC_StkLocGrpItm
Query GetGetLocGrpItm(mRowid As %String, HospId = "") As %Query(ROWSPEC = "Tdesc:%String,Trowid:%String,Tselect:%String")
{
}

ClassMethod GetGetLocGrpItmExecute(ByRef qHandle As %Binary, mRowid As %String, HospId = "") As %Status
{

    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    ;
    s typestring="W"
    s cnt=$l(typestring,"^")
    f i=1:1:cnt d
    .s type=$p(typestring,"^",i)
    .s locdr=""
    .f  s locdr=$o(^CTLOC(0,"LocType",type,locdr)) q:locdr=""  d
    ..s locdesc=$p(^CTLOC(locdr),"^",2)
    ..//i locdesc["-" s locdesc=$p(locdesc,"-",2,$l(locdesc,"-"))
    ..q:(HospId'="")&&(HospId'=$p($g(^CTLOC(locdr)),"^",22))
    ..s rowid=locdr
    ..s tselect=$$CheckLoc(mRowid,locdr)
    ..d OutRowLocGrpItm
	Quit $$$OK
OutRowLocGrpItm
	set Data=$lb(locdesc,rowid,tselect)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
CheckLoc(slg,locdr)
    s ret="N"
    q:slg="" ret
    s sub=""
    f  s sub=$o(^DHCSLG(slg,"I",sub)) q:sub=""  d
    .s tmplocdr=$p(^DHCSLG(slg,"I",sub),"^",1)
    .i locdr=tmplocdr d
    ..s ret="Y"
    quit ret
}

ClassMethod GetGetLocGrpItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGetLocGrpItmExecute ]
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

ClassMethod GetGetLocGrpItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGetLocGrpItmExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator			hulihua
/// Creatdate		2014-06-25
/// Description	    住院药房科室组与科室关联
/// Input           mrowid-科室组的id
/// table           DHC_StkLocGrpItm
ClassMethod InsertLocGrpItm(locstring, mrowid) As %String
{
	 n (locstring,mrowid)
	 q:locstring="" -1
	 q:mrowid="" -2
	 s apptype=$p(^DHCSLG(mrowid),"^",4)
	 s mlocdr=$p(^DHCSLG(mrowid),"^",5)
	 s cnt=$l(locstring,"^")
	 s ret=0
	 tstart
	 f i=1:1:cnt q:ret=-1  d
	 .s locdr=$p(locstring,"^",i)
	 .s exist=""
	 .s tmpmrowid=""
	 .f  s tmpmrowid=$o(^DHCSLG(0,"LOC",locdr,tmpmrowid)) q:(tmpmrowid="")||(exist=1)  d
	 ..q:+tmpmrowid=0
	 ..s tmpapptype=$p(^DHCSLG(tmpmrowid),"^",4)
	 ..s tmpmlocdr=$p(^DHCSLG(tmpmrowid),"^",5)
	 ..i (tmpapptype=apptype)&&(tmpmlocdr=mlocdr) s exist=1
	 .q:exist=1 //主表slg_apptype相同时不允许插入重复记录
	 .s sub=$o(^DHCSLG(mrowid,"I",""),-1)+1  ;child sub
	 .k PLIST
	 .s PLIST(0)=mrowid
	 .s PLIST(2)=sub
	 .s PLIST(3)=locdr
	 .&sql(insert into DHC_StkLocGrpItm values PLIST())
	 .i SQLCODE'=0 s ret=-1
	 .i ret=-1 trollback
     .q:ret=-1
     tcommit
     q:exist=1 -11
	 ;q $p(%ROWID,$c(1))
	 q ret
}

/// Creator			hulihua
/// Creatdate		2014-06-25
/// Description	    住院药房科室组与科室解除关联
/// Input           mrowid-科室组的id
/// table           DHC_StkLocGrpItm
ClassMethod DeleteLocGrpItm(locstring, mrowid) As %String
{
	 n (locstring,mrowid)
	 q:locstring="" -1
	 q:mrowid="" -2
	 s cnt=$l(locstring,"^")
	 s succ=0
	 tstart
	 f i=1:1:cnt q:succ=-1  d
	 .s locdr=$p(locstring,"^",i)
	 .i $d(^DHCSLG(0,"LOC",locdr,mrowid)) d
	 ..s sub=$o(^DHCSLG(0,"LOC",locdr,mrowid,""))
	 ..s tmpmrowidsub=mrowid_"||"_sub
	 ..&SQL(DELETE FROM DHC_StkLocGrpItm WHERE SLGI_RowId=:tmpmrowidsub)
	 ..s succ=1
	 ..i SQLCODE'=0 tro succ=-1
	 q:succ<0 succ
     tcommit
	 q 0
}

/// creator:yunhaibao
/// createdate:2016-10-18
/// description:json版本科室组gird
/// w ##class(web.DHCSTPHAADDLOCGRP).jsQueryLocGroup("")
ClassMethod jsQueryLocGroup(params, HospId = "")
{
	//s ^yunhaibao("jsQueryLocGroup")=params
	s inputgrpdesc=$p(params,"^",1)
	s inputloc=$p(params,"^",2)
	s result=##class(%Library.ResultSet).%New("web.DHCSTPHAADDLOCGRP:GetLocGrp")
	s sc=result.Execute("",inputloc,inputgrpdesc,HospId)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e  s ret=ret_"^"_result.%GetData(i)
		s countrecords=countrecords+1
		I countrecords=1 d
		.w "{""rows"":["
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "],""total"":"_countrecords_"}" 
	q ""
}

/// creator:yunhaibao
/// createdate:2016-10-18
/// description:json版本科室组对应明细grid
/// w ##class(web.DHCSTPHAADDLOCGRP).jsQueryLoc(1,30,"")
ClassMethod jsQueryLoc(page, rows, params, HospId = "")
{
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s inputrowid=$p(params,"^",1)
	s result=##class(%Library.ResultSet).%New("web.DHCSTPHAADDLOCGRP:GetGetLocGrpItm")
	s sc=result.Execute(inputrowid,HospId)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e  s ret=ret_"^"_result.%GetData(i)
		s countrecords=countrecords+1
		continue:countrecords>endpage
		continue:countrecords<stpage
		I countrecords=stpage d
		.w "{""rows"":["
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  i countrecords>stpage d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "],""total"":"_countrecords_"}" 
	q ""
}

}
