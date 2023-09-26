Class web.DHCFBASICINFO Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

ClassMethod BEGINTRANS()
{
 ;开始一个事务
 Tstart
 q
}

ClassMethod COMMIT()
{
 ;提交事务
 TCommit
 q
}

ClassMethod ClassFetch(ByRef qHandle As %Binary, ByRef AtEnd As %Integer = 0) As %List
{
 s retrwo=""
	if $g(qHandle)'="" d
	.Set AtEnd=$LIST(qHandle,1),repid=$LIST(qHandle,2)
	.if '$d(^CacheTempF(repid)) s ind=0 
	.s:$d(^CacheTempF(repid)) ind=$g(^CacheTempF(repid))
 .Set ind=$o(^CacheTemp(repid,ind))
 .If ind="" d 
 ..Set AtEnd=1,retrwo=""
 .Else  d 
 ..Set retrwo=^CacheTemp(repid,ind)
 ..s qHandle=$lb(AtEnd,repid,ind)
 ..s ^CacheTempF(repid)=ind
 Quit retrwo
}

ClassMethod GETADMREASON()
{
 s id=0,i=1
 S del="^",sep="&"
 k TPLIST
 f  s id=$o(^PAC("ADMREA",id)) q:id=""  d
 .s str=^PAC("ADMREA",id)
 .s TPLIST(i)=id_sep_$p(str,del,2)
 .set i=i+1
 Q i-1
}

ClassMethod GETCTLOCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GETCTLOCExecute ]
{
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

ClassMethod GETCTLOCExecute(ByRef qHandle As %Binary, LocType As %String, LocId As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s qHandle=$lb(0,repid,0)
 If $g(ind)="" Set ind=1
 s del="^"
 S loctype=""
	s id=0,i=2,del="^",sep="&"
 s desc="",loctype1=""
 f  s desc=$o(^CTLOC(0,"Desc",desc)) q:desc=""  d
 .s id=$o(^CTLOC(0,"Desc",desc,""))
 .q:((LocId'="")&(LocId'=id))
 .s loctype1=$p(^CTLOC(id),del,13) 
	.;i ($p(^CTLOC(id),del,1)="ICU") S loctype1="CL"
	.Q:((LocType'=loctype1) & (LocType'=""))
	.s CtDesc=$p(^CTLOC(id),del,2)
	.s CtDesc=$p(CtDesc,"-",2)
	.s Data=$lb(id,CtDesc)
 .s ^CacheTemp(repid,ind)=Data
 .S ind=ind+1
 Quit $$$OK
}

ClassMethod GETCTLOCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GETCTLOCExecute ]
{
 s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

ClassMethod GETDATA(i)
{
 K P9
 s P9=TPLIST(i)
 Q 1
}

ClassMethod GETHOSNAME()
{
 K TPLIST
 S TPLIST(1)=$P(^CF("SM",1),"^",5)
 s TPLIST(1)=TPLIST(1)_"&"_$P(^CF("SM",1),"^",11)
 Q 1
}

ClassMethod GETOCCUPATION()
{
 ;取职业
 s id=0,i=1
 S del="^",sep="&",ret="",name=""
 k TPLIST
 f  s id=$o(^PAC("PCAT",id)) q:id=""  d
 .s str=^PAC("PCAT",id)
 .s TPLIST(i)=id_sep_$p(str,del,2)
 .set i=i+1
 Q i-1
}

ClassMethod GETPATTYPE()
{
 ;获取病人自定义的分类
 s id=0,i=2
 S del="^",sep="&"
 k TPLIST
 f  s id=$o(^PATTYPE("PatType",id)) q:id=""  d
 .s str=^PATTYPE("PatType",id)
 .s TPLIST(i)=id_sep_$p(str,del,1)
 .set i=i+1
 S TPLIST(1)="000"_sep_"全部"
 Q i-1
}

ClassMethod GETPATTYPESUB(parid)
{
 ;获取病人自定义的分类的子类
 s id=0,i=1
 S del="^",sep="&"
 k TPLIST
 Q:'$d(^PATTYPE("PatType",parid)) 0
 q:'$d(^PATTYPE("PatType",parid,1)) 0
 s str=$g(^PATTYPE("PatType",parid,1))
 s icount=$l(str,del)-1
 q:icount<0 0
 f j=1:1:icount  d
 .s admreasonid=$p(str,del,j)
 .q:'$d(^PAC("ADMREA",admreasonid))
 .s pattype=$p(^PAC("ADMREA",admreasonid),del,1)
 .s TPLIST(i)=admreasonid_sep_pattype
 .s i=i+1
 Q i-1
}

ClassMethod GETSEX()
{
 s i=1,del="^",sep="&"
 K TPLIST
 s sexrid=0
 F  s sexrid=$o(^CT("SEX",sexrid)) q:sexrid=""  d
 .s sex=$p(^CT("SEX",sexrid),del,2)
 .s TPLIST(i)=sexrid_sep_sex
 .s i=i+1
 q i-1
}

ClassMethod GETSYSDATE()
{
 ;获取系统时间
 S P8=$zd(+$h,3)
 s P9=$zt($p($h,",",2))
 Q 1
}

ClassMethod GETUNIT()
{
 s id=0,i=1
 S del="^",sep="&",ret="",name=""
 k TPLIST
 f  s id=$o(^CT("UOM",id)) q:id=""  d
 .s str=^CT("UOM",id)
 .s TPLIST(i)=id_sep_$p(str,del,1)
 .set i=i+1
 Q i-1
}

ClassMethod GETWARD(str)
{
 s id=0,del="^",sep="&"
 K TPLIST
 s varid=$p($g(str),sep,1)
 s wardset=""
 if varid'=""  d
 .s i=1
 .s wardset=..GETWARDIDBYCTLOCID(varid)
 .if wardset="" d 
 ..s TPLIST(1)="0"_sep_"全部"_sep_"全部", i=2
 e  d
 .s TPLIST(1)="0"_sep_"全部"_sep_"全部", i=2
 s wardrid=0,warddesc=""
 F  s warddesc=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(warddesc))) q:warddesc=""  d
 .s wardrid=$o(^PAWARD(0,"WARD_Desc",warddesc,""))
 .b
 .q:((varid'="") & (wardset'="") & (wardset'[(wardrid_sep)))
 .b
 .S wardcode=$p(^PAWARD(wardrid),del,1)
 .s TPLIST(i)=wardrid_sep_warddesc_sep_wardcode
 .s i=i+1
 q i-1
}

ClassMethod GETWARDIDBYCTLOCID(ctlocid)
{
 S wardid=""
 s del="^",sep="&"
 s wardidstr="",wardid1=""
 f  s wardid1=$o(^PAWARD(0,"WBALL",ctlocid,wardid1)) q:wardid1=""  d
 .s wardidstr=wardidstr_sep_wardid1
 if wardidstr'="" s wardidstr=wardidstr_sep
 if wardidstr="" d
 .s wardidstr=$o(^PAWARD(0,"WARD_LocationDR",ctlocid,"") )
 .if wardidstr'="" s wardidstr=wardidstr_sep
 q wardidstr
}

ClassMethod PAGEGET()
{
 s sep="&"
 S pagerows=49,titlerows=2
 S P9=pagerows_sep_titlerows_sep_$P(^CF("SM",1),"^",5)
 Q 1
}

ClassMethod QueryClose(ByRef qHandle As %Binary) As %Status
{
	if $g(qHandle)'="" d
	.Set repid=$li(qHandle,2)
	.Kill ^CacheTemp(repid)
	.Kill ^CacheTempF(repid)
	Quit $$$OK
}

ClassMethod QueryFetch(ByRef qHandle As %Binary, ByRef AtEnd As %Integer = 0) As %List
{
 if $g(qHandle)'="" d
 .Set AtEnd=$LIST(qHandle,1),repid=$LIST(qHandle,2)
 .if '$d(^CacheTempF(repid)) s ind=0 
 .s:$d(^CacheTempF(repid)) ind=$g(^CacheTempF(repid))
 .Set ind=$o(^CacheTemp(repid,ind))
 .If ind="" d 
 ..Set AtEnd=1,retrwo=""
 .Else  d 
 ..Set retrwo=^CacheTemp(repid,ind)
 ..s qHandle=$lb(AtEnd,repid,ind)
 ..s ^CacheTempF(repid)=ind
 Quit retrwo
}

ClassMethod ROLLBACK()
{
 ;事务回滚
 TROLLBACK
 q
}

ClassMethod SendPara(Para As %String = "") As %String
{
 s ^ab=Para
	q Para
	s ^ab(1)=Para
	s mm=%request.Get("&Para")
	s ^ab=mm
	q $g(mm)
}

ClassMethod UPPATTYPE(str)
{
 ;更新病人类型
 q:str="" "传入数据不能为空"
 s del="^",sep="&",retstr=""
 s uptype=$p(str,sep,1)
 s pattype=$p(str,sep,2),pattype=$tr(pattype," ","")
 s pattypeid=$p(pattype,del,1),pattypedesc=$p(pattype,del,2)
 q:uptype="" "更新类型不能为空"
 q:pattype="" "病人类型组不能为空"
 ;s pattypeid=$o(^PATTYPE("PatType",""),-1)
 s sameflag=0
 if uptype="I" D
 .f  s pattypeid=$o(^PATTYPE("PatType",pattypeid)) q:((pattypeid="") !(sameflag=1))  d
 ..s:($g(^PATTYPE("PatType",pattypeid))=pattypedesc ) sameflag=1,retstr="有相同的病人类型组,不能增加"
 .if sameflag'=1 s rid=$o(^PATTYPE("PatType",""),-1),^PATTYPE("PatType",rid+1)=pattypedesc,P8=rid+1
 if uptype="U" D
 .S ^PATTYPE("PatType",pattypeid)=pattypedesc
 if uptype="D" K ^PATTYPE("PatType",pattypeid)
 q retstr
}

ClassMethod UPPATTYPESUB(str)
{
 ;更新病人类型子类
 q:str="" "传入数据不能为空"
 s del="^",sep="&",retstr=""
 s pattype=$p(str,sep,1)
 s pattypesub=$p(str,sep,2)
 q:pattype="" "病人类型组不能为空"
 q:pattypesub="" "病人类型不能为空"
 s ^PATTYPE("PatType",pattype,1)=pattypesub
 q ""
}

Query GETCTLOC(LocType As %String, LocId As %String = "") As %Query(ROWSPEC = "id:%String,desc:%String")
{
}

Storage Default
{
<Data name="DHCFBASICINFODefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCFBASICINFOD</DataLocation>
<DefaultData>DHCFBASICINFODefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCFBASICINFOD</IdLocation>
<IndexLocation>^web.DHCFBASICINFOI</IndexLocation>
<StreamLocation>^web.DHCFBASICINFOS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
