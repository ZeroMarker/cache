Import SQLUser

Class web.DHCSTPIVABATTIME Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetbattimeExecute(ByRef qHandle As %Binary, plocrowid As %String) As %Status
{
	//获取科室批次设置
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//实现；
	;q:plocrowid="" $$$OK 
	s rowid=0
    f  s rowid=$o(^PIVABT(rowid)) q:rowid=""  d
    .s stiem=$p(^PIVABT(rowid),"^",1)
    .s stiem=$zt(stiem,1)
    .s xtiem=$p(^PIVABT(rowid),"^",2)
    .s xtiem=$zt(xtiem,1)
    .s batno=$p(^PIVABT(rowid),"^",3)
    .s locdr=$p(^PIVABT(rowid),"^",4)
    .q:(locdr'=plocrowid)&(plocrowid'="")
    .s loc=$p(^CTLOC(locdr),"^",2)
    .s seqflag=$p(^PIVABT(rowid),"^",5)
    .s ward=$p(^PIVABT(rowid),"^",6)
    .s warddesc=""
    .s:+ward'=0 warddesc=$p(^PAWARD(ward),"^",2)
	.d OutPutRow
	Quit $$$OK
	
OutPutRow
	set Data=$lb(stiem,xtiem,batno,loc,rowid,seqflag,ward,$g(warddesc),locdr)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
}

ClassMethod GetbattimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetbattimeExecute ]
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

Query Getbattime(plocrowid As %String) As %Query(ROWSPEC = "Tstime:%String,Txtime:%String,Tbat:%String,Tploc:%String,Trowid:%String,TSeqFlag:%String,TWard:%String,TWarddesc:%String,Tplocrowid:%String")
{
}

ClassMethod GetbattimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetbattimeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Update(Ploc, Stime, Xtime, Bat, flag, rowid, seqflag, warddesc) As %String
{
 n (Ploc,Stime,Xtime,Bat,flag,rowid,seqflag,warddesc)
 q:'$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(Ploc)))&(flag="2") -1
 i flag="2" s Ploc=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(Ploc),""))
 s ward=""
 s:warddesc'="" ward=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(warddesc),""))
 s exist=""
 s btrowid=""
 f  s btrowid=$o(^PIVABT(btrowid)) q:btrowid=""  d
 .q:+btrowid=0
 .q:(rowid'="")&&(rowid=btrowid) //过滤本身
 .s btloc=$p(^PIVABT(btrowid),"^",4)
 .s btno=$p(^PIVABT(btrowid),"^",3)
 .s btward=$p(^PIVABT(btrowid),"^",6)
 .i ward="" d
 ..i (btloc=Ploc)&&(btno=Bat) s exist=1
 .e  d
 ..i (btloc=Ploc)&&(btno=Bat)&&(ward=btward) s exist=1
 q:exist'="" -2
 k PLIST
 s Stime=$zth(Stime,1)
 s Xtime=$zth(Xtime,1)
 s PLIST(1)=""
 s PLIST(2)=Stime
 s PLIST(3)=Xtime
 s PLIST(4)=Bat
 s PLIST(5)=Ploc
 s PLIST(6)=seqflag
 s PLIST(7)=$g(ward)
 i flag=1 &sql(insert into  PIVA_BatTime values PLIST())
 i flag=2 &sql(update  PIVA_BatTime set PBT_TimeFrom=:Stime,PBT_TimeTo=:Xtime,PBT_BatNo=:Bat,PBT_Ctloc_Dr=:Ploc,PBT_SeqFlag=:seqflag,PBT_Ward_Dr=:ward where PBT_RowId=:rowid)
 q:SQLCODE'=0 -1
 q $p(%ROWID,$c(1))
 q
}

ClassMethod Delete(rowid) As %String
{
 n (rowid)
 &sql(delete  from  PIVA_BatTime where PBT_RowId=:rowid)
 q:SQLCODE'=0 -1
 q $p(%ROWID,$c(1))
 q
}

/// Description:插入科室批次配置表
/// Input:药房科室ID,病区ID
/// Output: 0 成功 , 非0失败
/// Creator:LiangQiang
/// CreatDate:2014-03-20
ClassMethod InsLocBat(Phalocdr, WardDr) As %String
{
	 n (Phalocdr,WardDr)
	 q:Phalocdr="" 0
	 s existflag=""
	 s locBatId=""
	 f  s locBatId=$o(^PIVALBAT(0,"Loc",Phalocdr,locBatId)) q:(locBatId="")||(existflag'="")  d
	 .q:+locBatId=0
	 .s tmpWardDr=$p(^PIVALBAT(locBatId),"^",2)
	 .i tmpWardDr=WardDr s existflag=-1
	 q:existflag'="" existflag
	 k PLIST
	 s PLIST(2)=+Phalocdr
	 s PLIST(3)=WardDr
	 &sql(insert into  PIVA_LocBat values PLIST())
	 q:SQLCODE'=0 SQLCODE
	 q 0
}

/// Description:插入科室批次药品列表
/// Input:药房科室ID,病区ID
/// Output: 0 成功 , 非0失败
/// Creator:LiangQiang
/// CreatDate:2014-03-20
ClassMethod InsLocBatItm(Main, Inci, BatNo) As %String
{
	 n (Main,Inci,BatNo)	 
     s pid=$I(^DHCSTPIVA("COLL"))
     s existinci=""
	 s sub=""
	 f  s sub=$o(^PIVALBAT(Main,"Itm",sub)) q:sub=""  d
	 .s ordnum=+$p(^PIVALBAT(Main,"Itm",sub),"^",4)
	 .s itminci=$p(^PIVALBAT(Main,"Itm",sub),"^",1)
	 .s itmno=$p(^PIVALBAT(Main,"Itm",sub),"^",3)
	 .i itminci=Inci s existinci="1" //已存在
	 .s ^TMP("DHCST","DHCSTPIVABATTIME","InsLocBatItm",pid,ordnum)=""
	 i existinci'="" k ^TMP("DHCST","DHCSTPIVABATTIME","InsLocBatItm",pid)
	 q:existinci'="" -10
	 s ordnum=+$o(^TMP("DHCST","DHCSTPIVABATTIME","InsLocBatItm",pid,""),-1)+1 
	 k ^TMP("DHCST","DHCSTPIVABATTIME","InsLocBatItm",pid)
	 k PLIST
	 s PLIST(0)=+Main
	 s PLIST(2)=+$o(^PIVALBAT(Main,"Itm",""),-1)+1
	 s PLIST(3)=Inci
	 s PLIST(5)=BatNo
	 s PLIST(6)=ordnum
	 &sql(insert into  PIVA_LocBatItm values PLIST())
	 q:SQLCODE'=0 SQLCODE
	 q 0
}

/// Description:插入科室批次容量表
/// Input:药房科室ID,病区ID
/// Output: 0 成功 , 非0失败
/// Creator:LiangQiang
/// CreatDate:2014-03-20
ClassMethod InsLocBatCubage(Main, Min, Max, BatNo) As %String
{
	 n (Main,Min,Max,BatNo)
	 s Sub="",ExistCub=""
	 f  s Sub=$o(^PIVALBATCU(Main,"Cub",Sub)) Q:(Sub="")||(ExistCub'="")  d
	 .q:+Sub=0
	 .s SubBatNo=$p(^PIVALBATCU(Main,"Cub",Sub),"^",2)
	 .i SubBatNo=BatNo s ExistCub=1
	 q:ExistCub'="" -10
	 k PLIST
	 s PLIST(0)=+Main
	 s PLIST(2)=+$o(^PIVALBATCU(Main,"Cub",""),-1)
	 s PLIST(2)=PLIST(2)+1
	 s PLIST(3)=Max
	 s PLIST(4)=BatNo
	 s PLIST(5)=Min
	 &sql(insert into  PIVA_LocBatCubage values PLIST())
	 q:SQLCODE'=0 SQLCODE
	 q 0
}

/// Description:更新科室批次药品列表
/// Input:药房科室ID,病区ID
/// Output: 0 成功 , 非0失败
/// Creator:LiangQiang
/// CreatDate:2014-03-20
ClassMethod UpdLocBatItm(SubRowid, Inci, BatNo) As %String
{
	 n (SubRowid,Inci,BatNo)

	 &sql(update  PIVA_LocBatItm set PLBATI_INCI_DR=:Inci,PLBATI_BatNo=:BatNo where PLBATI_RowID=:SubRowid)
	 q:SQLCODE'=0 SQLCODE
	 q 0
}

/// Description:更新科室批次药品容积表
/// Input:药房科室ID,病区ID
/// Output: 0 成功 , 非0失败
/// Creator:LiangQiang
/// CreatDate:2014-03-20
ClassMethod UpdLocBatCubage(SubRowid, Min, Max, BatNo) As %String
{
	 n (SubRowid,Min,Max,BatNo)

	 &sql(update  PIVA_LocBatCubage set PLBATCU_MIN=:Min,PLBATCU_MAX=:Max,PLBATCU_BatNo=:BatNo where PLBATCU_RowID=:SubRowid)
	 q:SQLCODE'=0 SQLCODE
	 q 0
}

/// 获取科室批次扩展
ClassMethod GetLocBatDs(phalocdr) As %String
{
	n (phalocdr)
	
	s pid=$I(^DHCSTPIVA("COLL"))
	s h=0
	s plbr=""
	f  s plbr=$o(^PIVALBAT(0,"Loc",phalocdr,plbr)) q:plbr=""  d
	.s warddesc=""
	.q:'$d(^PIVALBAT(plbr))
	.s locdr=$p(^PIVALBAT(plbr),"^",1)
	.s locdesc=$p(^CTLOC(locdr),"^",2)
	.s warddr=$p(^PIVALBAT(plbr),"^",2)
	.i warddr'="" s warddesc=$p(^PAWARD(warddr),"^",2)
	.s rowId=plbr
	.s h=h+1
    .s data=warddesc_"^"_rowId_"^"_warddr_"^"_locdesc_"^"_locdr
    .s ^TMP("DHCST","DHCSTPIVA","GetLocBatDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPIVA","GetLocBatDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPIVA","GetLocBatDs",pid,h)
    .s warddesc=$p(data,"^",1)
    .s rowId=$p(data,"^",2)
    .s warddr=$p(data,"^",3)
    .s locdesc=$p(data,"^",4)
    .s locdr=$p(data,"^",5)
    .
    .s warddesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("warddesc",warddesc)
	.s rowId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rowId",rowId)
	.s warddr=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("warddr",warddr)
	.s locdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locdesc",locdesc)
	.s locdr=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("locdr",locdr)
	.
	.s tmpstr=warddesc_rowId_warddr_locdesc_locdr
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("DHCST","DHCSTPIVA","GetLocBatDs",pid)
	q ""
}

/// 获取科室批次扩展
ClassMethod GetLocBatItmDs(main) As %String
{
	n (main)
	s main=+main
	s pid=$I(^DHCSTPIVA("COLL"))
	s h=0
	s sub=""
	f  s sub=$o(^PIVALBAT(main,"Itm",sub)) q:sub=""  d
	.s inci=$p(^PIVALBAT(main,"Itm",sub),"^",1)
	.s itmdesc=$p(^INCI(inci,1),"^",2)
	.s batno=$p(^PIVALBAT(main,"Itm",sub),"^",3)
	.s ordernum=$p(^PIVALBAT(main,"Itm",sub),"^",4)
	.s ordernum=ordernum+10000
	.s rowId=main_"||"_sub
	.s h=h+1
    .s data=inci_"^"_itmdesc_"^"_rowId_"^"_batno_"^"_ordernum
    .s ^TMP("DHCST","DHCSTPIVABATTIME","GetLocBatItmDs",pid,ordernum_"^"_h)=data
    .
    
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPIVABATTIME","GetLocBatItmDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPIVABATTIME","GetLocBatItmDs",pid,h)
    .s itmrowid=$p(data,"^",1)
    .s itmdesc=$p(data,"^",2)
    .s rowId=$p(data,"^",3)
    .s batno=$p(data,"^",4)
    .s ordernum=$p(data,"^",5)
    .
    .s itmrowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("itmrowid",itmrowid)
	.s itmdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("itmdesc",itmdesc)
	.s rowId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rowId",rowId)
	.s batno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("batno",batno)
	.s ordernum=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("ordernum",ordernum)
	.
	.s tmpstr=itmrowid_itmdesc_rowId_batno_ordernum
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("DHCST","DHCSTPIVABATTIME","GetLocBatItmDs",pid)
	q ""
}

ClassMethod DelLocBatItm(SubRowid) As %String
{
	 n (SubRowid)

	 &sql(delete from   PIVA_LocBatItm  where PLBATI_RowID=:SubRowid)
	 q:SQLCODE'=0 SQLCODE
	 q 0
}

/// 获取科室批次容量扩展
ClassMethod GetLocBatCubageDs(main) As %String
{
	n (main)
	s main=+main
	s pid=$I(^DHCSTPIVA("COLL"))
	s h=0
	s sub=""
	f  s sub=$o(^PIVALBATCU(main,"Cub",sub)) q:sub=""  d
	.s max=$p(^PIVALBATCU(main,"Cub",sub),"^",1)
	.s batno=$p(^PIVALBATCU(main,"Cub",sub),"^",2)
	.s min=$p(^PIVALBATCU(main,"Cub",sub),"^",3)
	.s rowId=main_"||"_sub
	.s h=h+1
    .s data=max_"^"_batno_"^"_rowId_"^"_min
    .s ^TMP("DHCST","DHCSTPIVABATTIME","GetLocBatCubageDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPIVABATTIME","GetLocBatCubageDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPIVABATTIME","GetLocBatCubageDs",pid,h)
    .s max=$p(data,"^",1)
    .s batno=$p(data,"^",2)
    .s rowId=$p(data,"^",3)
    .s min=$p(data,"^",4)
    .
    .s min=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("min",min)
    .s max=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("max",max)
	.s batno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("batno",batno)
	.s rowId=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("rowId",rowId)
	.
	.s tmpstr=min_max_batno_rowId
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("DHCST","DHCSTPIVABATTIME","GetLocBatCubageDs",pid)
	q ""
}

ClassMethod DelLocBatCubage(SubRowid) As %String
{
	 n (SubRowid)

	 &sql(delete from   PIVA_LocBatCubage  where PLBATCU_RowID=:SubRowid)
	 q:SQLCODE'=0 SQLCODE
	 q 0
}

/// Description:上移记录
/// Input:当前行ID^移后顺序号%上一行ID^移后顺序号
/// Output: 0 成功 , 非0失败
/// Creator:LiangQiang
/// CreatDate:2014-04-01
ClassMethod UpLocBatItm(input) As %String
{
	n (input)

	s currowid=$p(input,"^",1)
	s curordernum=$p(input,"^",2)
	s lastrowid=$p(input,"^",3)
	s lastordernum=$p(input,"^",4)
	
	s curordernum=$p(^PIVALBAT(+lastrowid,"Itm",$p(lastrowid,"||",2)),"^",4)
	s lastordernum=$p(^PIVALBAT(+currowid,"Itm",$p(currowid,"||",2)),"^",4)
	
	tstart
	&sql(update PIVA_LocBatItm  set PLBATI_Order=:curordernum where PLBATI_RowID=:currowid)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 -1
	&sql(update PIVA_LocBatItm  set PLBATI_Order=:lastordernum where PLBATI_RowID=:lastrowid)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 -2
	tcommit
	
	q 0
}

/// creator:yunhaibao
/// createdate:20160405
/// description:删除科室批次配置表 
ClassMethod DelLocBat(pivalocid)
{
	ts 
	&SQL(delete from PIVA_LocBat where PLBAT_RowID=:pivalocid)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 SQLCODE
	tc
	q 0
}

/// creator:yunhaibao
/// createdate:20160405
/// description:修改科室批次配置表
ClassMethod UpdateLocBat(PLBRowid, Phalocdr, WardDr) As %String
{
	 n (PLBRowid,Phalocdr,WardDr)
	 q:PLBRowid="" 0
	 q:Phalocdr="" 0
	 s existflag=""
	 s locBatId=""
	 f  s locBatId=$o(^PIVALBAT(0,"Loc",Phalocdr,locBatId)) q:(locBatId="")||(existflag'="")  d
	 .q:+locBatId=0
	 .s tmpWardDr=$p(^PIVALBAT(locBatId),"^",2)
	 .i tmpWardDr=WardDr s existflag=-1
	 q:existflag'="" existflag
	 &SQL(UPDATE PIVA_LocBat SET PLBAT_Loc_DR=:Phalocdr,PLBAT_Ward_Dr=:WardDr WHERE PLBAT_RowID=:PLBRowid)
	 q:SQLCODE'=0 SQLCODE
	 q 0
}

}
