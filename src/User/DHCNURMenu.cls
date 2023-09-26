Class User.DHCNURMenu Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_NURMenu ]
{

Relationship ChildRec As User.DHCNURMenuSub [ Cardinality = children, Inverse = RecParref ];

Property name As %String(TRUNCATE = 1);

Property code As %String(TRUNCATE = 1);

Property sort As %String(TRUNCATE = 1);

Property ifon As %String(TRUNCATE = 1);

Property UserREC As %String(TRUNCATE = 1);

Property RECDate As %Library.Date;

Property RECTime As %Library.Time;

Property Loc As %String(TRUNCATE = 1);

Property Link As %String(TRUNCATE = 1);

Index codeIndex On code;

Index LocIndex On Loc;

Index Locsort On (Loc, sort);

Index LoccodeIndex On (Loc, code);

ClassMethod getlocward(loc) As %String
{
  s ward=$O(^PAWARD(0,"WARD_LocationDR",loc,"")) 
  q ward
}

//取某根目录下最大序号

//Creat:2014-08

ClassMethod getmaxindex(loc) As %String
{
	s max=0
	s code=""  f  s code=$O(^User.DHCNURMenuI("Locsort"," "_loc,code)) q:(code="")  d
	.s chl=""  f  s chl=$O(^User.DHCNURMenuI("Locsort"," "_loc,code,chl)) q:(chl="")  d
    ..s a=##class(User.DHCNURMenu).%OpenId(chl)
    ..s seq=a.sort
    ..i seq>max s max=seq
    q max
}

//上移或下移

//input:rw--表id, flag--1 上移，-1下移

//Creat:2014-08

// w ##class(User.DHCNURMenu).upordown("","9","1")

ClassMethod upordown(loc, rw, flag) As %String
{
	
	s oldmax=..getmaxindex(loc) //原来节点下最大序号数
	s b=##class(User.DHCNURMenu).%OpenId(rw)
    s seq=b.sort
    q:(seq=oldmax)&(flag>0) 0 //最后一个不能下移
    q:(seq="1")&(flag<0) 0  //第一个不能上移
    s upseq=seq+flag
	s sseq=""  f  s sseq=$O(^User.DHCNURMenuI("Locsort"," "_loc,sseq)) q:(sseq="")  d
	.s chl=""  f  s chl=$O(^User.DHCNURMenuI("Locsort"," "_loc,sseq,chl)) q:(chl="")  d
    ..q:chl=""
    ..s a=##class(User.DHCNURMenu).%OpenId(chl)
    ..s seqsub=a.sort
    ..i seqsub=upseq d
    ...s a.sort=seq
    ...d a.%Save()
    s b.sort=upseq
    d b.%Save()
    Q 0
}

//根目录

//w ##class(web.DHCNurseRecordComm).GetGName()

//获取科室根目录列表

//Creat:2015-08

ClassMethod GetGName(loc) As %String
{
	
	s PatJson=##class(%ListOfDataTypes).%New()
	s id="" f  s id=$O(^User.DHCNURMenuI("LocIndex"," "_loc,id)) q:id=""  d
 	.s a=##class(User.DHCNURMenu).%OpenId(id)
 	.s ChildJson=##class(%ArrayOfDataTypes).%New()
	.s rw=id
	.s name=a.name
	.d ChildJson.SetAt(name,"desc")
	.d ChildJson.SetAt(rw,"id")
    .d PatJson.Insert(ChildJson)
    q ##class(Nur.JSON).Encode(PatJson)
}

//d ##class(User.DHCNURMenu).GetDepModel("48")

ClassMethod GetDepModel(adm As %String) As %String
{
     s LocId=$p(^PAADM(adm),"^",4)
     s curWardId=$p($g(^PAADM(adm)),"^",70) 
     s Ward=..getlocward(LocId)
     s totelstr=""
     s max=0
     s rw="" f  s rw=$o(^DHCNurDepModelSet(rw)) q:rw=""  d
     .s DepModelStr=$G(^DHCNurDepModelSet(rw))
     .s totelstr=totelstr_"^"_DepModelStr
     b
   
     f ii=1:1:$L(totelstr,"^") d
	 .s DepModel=$P(totelstr,"^",ii)
	 .//b ;99
	 .q:DepModel=""
	 .s ModelKey=$P(DepModel,"|",1)
	 .s ModelName=$P(DepModel,"|",2)
	 .s ModelSort=$P(DepModel,"|",3)
	 .s PrintCode=""
	 .i ModelKey'="" s PrintCode=..getPrintCode(ModelKey)
	 .s flag=..GetModelDataStatus(adm,ModelKey)
	 .//b ;55
	 .i flag'=0 s DepModel(ModelKey)=ModelKey_"|"_PrintCode
	 .//s DepModel(ModelKey)=ModelKey_"|"_PrintCode
	b ;44
	s ret=""
	s sort="" f  s sort=$O(DepModel(sort)) q:sort=""  d
	.s ret=ret_DepModel(sort)_"^"
	b ;66
 	q ret
}

//d ##class(User.DHCNURMenu).GetPerModel("171")

ClassMethod GetPerModel(adm As %String) As %String
{
    
     s ret="" 
     s id="" f  s id=$O(^User.DHCNURMenuD(id)) q:id=""  d
 	 .s a=##class(User.DHCNURMenu).%OpenId(id)
 	 .s PrintCode=a.PrintCode
 	 .s Code=a.Code
 	 .s typ=a.typ
 	 .s ifon=a.ifon
 	 .s Sort=a.Sortno
 	 .i Sort'="" d
 	 ..s tmpsort(Sort)=id
 	 s i="" f  s i=$o(tmpsort(i)) q:i=""  d
 	 .s id=tmpsort(i)
 	 .s a=##class(User.DHCNURMenu).%OpenId(id)
 	 .s PrintCode=a.PrintCode
 	 .s Code=a.Code
 	 .s typ=a.typ
 	 .s ifon=a.ifon
 	 .q:ifon="N"
 	 .s flag=..GetModelDataStatus(adm,Code,PrintCode)
	 .i flag'=0 d
	 ..i typ["多次评估" d
 	 ...i ret="" s ret=..Getlb(adm,Code,PrintCode,typ)
 	 ...e  s ret=ret_"|"_..Getlb(adm,Code,PrintCode,typ)
 	 ..e  d
	 ...i ret="" s ret=Code_"^"_PrintCode_"^"_typ_"^^"
	 ...e  s ret=ret_"|"_Code_"^"_PrintCode_"^"_typ_"^^"
 	q ret
}

ClassMethod Getlb(EpisodeID, EmrCode, prncode, type) As %String
{
    s ret="", ii=0
     s code=$ZConvert(EmrCode,"U")
	 s DHCMoudid=""  f  s DHCMoudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,DHCMoudid)) q:DHCMoudid=""  d
	 .i DHCMoudid'="" d
	 ..s b=##class(Nur.DHCMoudData).%OpenId(DHCMoudid)
	 ..i (b.RecCancelUser="") d
	 ...i ret="" s ret=code_"^"_prncode_"^"_type_"^"_DHCMoudid_"^"_ii
	 ...e  s ret=ret_"|"_code_"^"_prncode_"^"_type_"^"_DHCMoudid_"^"_ii
	 ...s ii=ii+1
	 q ret
}

ClassMethod GetModelDataStatus(EpisodeID, EmrCode, type) As %String
{
	//w ##class(web.DHCMGNurData).GetModelDataStatus(11062752,"DHCNURANHUISPLIST")
	s ret=0
	if (EpisodeID'="")&&(EmrCode'="")
	{
	 s code=$ZConvert(EmrCode,"U")
	 i code="DHCNURANHUISPLIST" s code="DHCNURANHUI21"
	 //s ^fuckwxy(EpisodeID,code)=code
	 //s id=""  s id=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,id))
	 s id=""
	 s DHCMoudid=""  f  s DHCMoudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,DHCMoudid)) q:DHCMoudid=""  d
	 .i DHCMoudid'="" d
	 ..s b=##class(Nur.DHCMoudData).%OpenId(DHCMoudid)
	 ..i (b.RecCancelUser="") s id=DHCMoudid
	 
	 s par=""  s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_EpisodeID,par))
	 if par'=""
	 {
	 s rw="" f  s rw=$o(^Nur.DHCNurseRecSubD(par,rw)) q:rw=""  d
	 .s tmp("Id")=par_"||"_rw
	 .s a=##class(Nur.DHCNurseRecSub).%OpenId(tmp("Id"))
	 .//w !,a.RecTyp_"^"_a.RecCancelUser
	 .i (a.RecTyp=EmrCode)&&(a.RecCancelUser="") s id=tmp("Id")
	 }	 
	}
	i id'="" s ret=1
	q ret
}

ClassMethod getdata() As %String
{
   s ret="" 
   s id="" f  s id=$O(^User.DHCNURMenuD(id)) q:id=""  d
 	.s a=##class(User.DHCNURMenu).%OpenId(id)
 	.s PrintCode=a.PrintCode
 	
	.s ret=ret_"^rw|"_id_"^PrintCode|"_PrintCode
	q ret
}

//d ##class(User.DHCNURMenu).getPrintCode("DHCNURXH12")

ClassMethod getPrintCode(RecTyp) As %String
{
   s ret="" 
   s RecTyp=$zconvert(RecTyp,"U")
   s id="" f  s id=$O(^User.DHCNURMenuI("CodeIndex"," "_RecTyp,id)) q:id=""  d
 	.s a=##class(User.DHCNURMenu).%OpenId(id)
 	.s PrintCode=a.PrintCode
 	.s typ=a.typ
	.s ret=PrintCode_"|"_typ

	q ret
}

//d ##class(User.DHCNURMenu).getPrintCode("DHCNURXH12")

//根据id获取名称

ClassMethod getnamebyid(id) As %String
{
   s ret="" 
   q:id="" ""
   s a=##class(User.DHCNURMenu).%OpenId(id)
   s ret=a.name
   q ret
}

/// 更新子目录名称
ClassMethod update(id As %String, parr As %String) As %String
{
	q:(id="")||(parr="") "不能更新为空"
	s Name=parr
	s ids=id
    s a=##class(User.DHCNURMenu).%OpenId(id)
	s a.name=Name
	s loc=a.Loc
	s code=..GetCNCODE(Name,4,"")
	s code=$zcvt(code,"U")
	s a.code=code
	s par="" 
	s par=$o(^User.DHCNURMenuI("LoccodeIndex"," "_loc," "_code,par)) //当前根节点下是否存在该模板
	q:(par'="")&&(par'=id) "已经存在该名称"
	d a.%Save()
	q 0
}

//获取当前科室是否有维护

ClassMethod iflochaveset(loc As %String) As %String
{
	
	q:loc="" "病区不能为空"
	s ret=""
	i $d(^User.DHCNURMenuI("LocIndex"," "_loc)) s ret="Y"
	q ret
}

//change:2015-08-20

//增加子项

// w ##class(User.DHCNURMenu).Additm(^ojbin)

ClassMethod Additm(parr As %String) As %String
{
	s ^ojbinmain=parr
    s loc=$p(parr,"^",1)       //科室
	s name=$p(parr,"^",2)      //EmrCode
	q:name="" "名称不能为空" 
	q:'$d(^User.DHCNURMenuI("LocIndex"," "_loc)) "请先保存再增加"
	s namecode=..GetCNCODE(name,4,"")
	s namecode=$zcvt(namecode,"U")
	s par="" s par=$o(^User.DHCNURMenuI("LoccodeIndex"," "_loc," "_namecode,par)) //当前根节点下是否存在该模板
	b ;
	q:par'="" "该节点下已经存在该模板"
      s max=..getmaxindex(loc) //最大seq
      s a=##class(User.DHCNURMenu).%New()
      s a.code=namecode
	  s a.name=name
	  s a.sort=max+1
	  s a.ifon="Y"
	  s a.Loc=loc
	  s a.RECDate=$p($h,",",1)
	  s a.RECTime=$p($h,",",2)
	  s a.UserREC=%session.Get("LOGON.USERNAME")
	  d a.%Save()
	  q 0
}

/// Creator:ZhanMingChao
/// Description:返回汉字的编码信息
/// Input：HANZI:汉字,FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码6:五笔码7:区位码8:笔划数9:郑码),SPLIT:分割符(可以为空)
/// Output：
/// 	非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
/// 	0：未找到编码信息
/// CreatDate:2011-06-08
/// w ##class(web.DHCINSUPort).GetCNCODE("东华",4,"^")
ClassMethod GetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
	s Rtnstr="0"
	q:$g(HANZIS)="" Rtnstr
	s Rtnstr=""
	f i=1:1:$l(HANZIS) d
	.s HANZI=$EXTRACT(HANZIS,i)
	.s ASCIICODE=$ASCII(HANZI)
	.i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
	..s rowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
	..s tmpstr=""
	..s:FLAG="" tmpstr=$g(^DHCCharacterEncoding(rowid))
	..s:FLAG'="" tmpstr=$p(^DHCCharacterEncoding(rowid),"^",FLAG)
	..i Rtnstr=""  d
	...s Rtnstr=tmpstr
	..e  d
	...s Rtnstr=Rtnstr_SPLIT_tmpstr
	.e  d
	..s:Rtnstr="" Rtnstr=HANZI
	..s Rtnstr=Rtnstr_SPLIT_HANZI
	q Rtnstr
}

ClassMethod Save(parr As %String) As %String
{

	s ^ojbin=parr
	s len=$l(parr,"$")
	for i=1:1:len
	{
	   s itm=$p(parr,"$",i)
	   i itm="" continue
	   s l=$L(itm,"^")
	   k tmpmenu
	   for j=1:1:l
	   {
	     s itmsub=$P(itm,"^",j)
	     if itmsub="" continue
	     s name=$P(itmsub,"|")
	     s val=$P(itmsub,"|",2)
	     i name="" continue
	     s tmpmenu(name)=val
	   }
	   i ($g(tmpmenu("rw"))="")  d
	   .s a=##class(User.DHCNURMenu).%New()
	   .if $D(tmpmenu("code")) s a.code=tmpmenu("code")
	   .if $D(tmpmenu("name")) s a.name=tmpmenu("name")
	   .if $D(tmpmenu("sort")) s a.sort=tmpmenu("sort")
	   .if $D(tmpmenu("ifon")) s a.ifon=tmpmenu("ifon")
	   .if $D(tmpmenu("loc")) s a.Loc=tmpmenu("loc")
	   .if $D(tmpmenu("link")) s a.Link=tmpmenu("link")
	   .s a.RECDate=$p($h,",",1)
	   .s a.RECTime=$p($h,",",2)
	   .s a.UserREC=%session.Get("LOGON.USERNAME")
	   .d a.%Save()
	}
	q 0
}

ClassMethod QtDelete(id As %String) As %String
{
   q:id="" "id不能为空"
   s a=##class(User.DHCNURMenu).%DeleteId(id)
   q 0
}

// d ##class(%ResultSet).RunQuery("web.DHCNurblsjflwh","CRItem","parr$111")

ClassMethod getVal(id) As %String
{
	s ret=""
	if id'=""
	{
	s a=##class(User.DHCNURMenu).%OpenId(id)	
	s tmp("code")=a.code
	s tmp("name")=a.name
	s tmp("sort")=a.sort
	s tmp("ifon")=a.ifon
	s tmp("link")=a.Link	
	s k=""
	f {
	s k=$O(tmp(k))
	q:k=""
	s ret=ret_k_"|"_tmp(k)_"^"
	}
	}
	q ret
}

//d ##class(%ResultSet).RunQuery("User.DHCNURMenu","CRItem","")

ClassMethod CRItemExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s loc=$tr(parr," ","")
 	i '$d(^User.DHCNURMenuI("LocIndex")) d   //增加索引后重新生成索引
 	.&sql(update sqluser.DHC_NURMenu set Loc=:null) 
 	.d ##class(User.DHCNURMenu).%BuildIndices()
 	.s idrw="" f  s idrw=$O(^User.DHCNURMenuI("LocIndex"," ",idrw)) q:idrw=""  d
 	..s aobj=##class(User.DHCNURMenu).%OpenId(idrw)
 	..s aobj.code=..GetCNCODE(aobj.name,4,"")
 	..d aobj.%Save()
 	s lochaveflag=""  //科室是否已经保存过
 	i ('$d(^User.DHCNURMenuI("LocIndex"," "_loc)))&&(loc'="") d
 	.s loc=""
 	.s lochaveflag="N"
 	b ;
 	k seqdata
    s seq="" f  s seq=$O(^User.DHCNURMenuI("Locsort"," "_loc,seq)) q:seq=""  d
    .s id="" f  s id=$O(^User.DHCNURMenuI("Locsort"," "_loc,seq,id)) q:id=""  d
 	..s a=##class(User.DHCNURMenu).%OpenId(id)
	..s rw=id
	..s ret=""
	..s ret=..getVal(rw)
	..s linkrw=a.Link
	..i parr="" d  //默认配置
	...s linkrw=id
	..i lochaveflag="N" d  //科室没保存过
	...s rw=""
	...s linkrw=id
	..b ;77
	..s ret=ret_"^rw|"_rw_"^loc|"_parr_"^link|"_linkrw
	..s seqdata(a.sort)=ret
	s rw="" f  s rw=$o(seqdata(rw)) q:rw=""  d
	.s ret=seqdata(rw)
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CRItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CRItemExecute ]
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

Query CRItem(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod CRItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CRItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod CRItem2Execute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    s id="" f  s id=$O(^User.DHCNURMenuD(id)) q:id=""  d
 	.s a=##class(User.DHCNURMenu).%OpenId(id)
	.s rw=id
	.s sortno=a.sort
	.s ret=""
	.s ret=..getVal(rw)
	
	.s ret=ret_"^rw|"_id
	.i sortno'="" d
	..s tmpsort(sortno)=ret
	s ret=""
	s i="" f  s i=$o(tmpsort(i)) q:i=""  d
	.s ret=tmpsort(i)
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CRItem2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CRItem2Execute ]
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

Query CRItem2(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod CRItem2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CRItem2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// w ##class(User.DHCNURMenu).getgbox(^objgbox,"add")

ClassMethod getgbox(loc, funname As %String) As %String
{
	s ^objgbox=loc
	i '$d(^User.DHCNURMenuI("LocIndex"," "_loc)) s loc=""
	s id="" f  s id=$O(^User.DHCNURMenuI("LocIndex"," "_loc,id)) q:id=""  d
 	.s a=##class(User.DHCNURMenu).%OpenId(id)
	.s desc=a.name
	.s link=a.Link
	.s ID=id
	.i link'="" s ID=link
 	.s rtnval=funname_"('"_$ZCVT($g(ID),"O","JS")_"','"_$ZCVT($g(desc),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	q 0
}

ClassMethod deleteloc(loc As %String) As %String
{
	
	q:loc="" "病区不能为空"
	s id="" f  s id=$O(^User.DHCNURMenuI("LocIndex"," "_loc,id)) q:id=""  d
 	.d ##class(User.DHCNURMenu).%DeleteId(id)
	q 0
}

Storage Default
{
<Data name="DHCNURMenuDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>code</Value>
</Value>
<Value name="4">
<Value>sort</Value>
</Value>
<Value name="5">
<Value>ifon</Value>
</Value>
<Value name="6">
<Value>UserREC</Value>
</Value>
<Value name="7">
<Value>RECDate</Value>
</Value>
<Value name="8">
<Value>RECTime</Value>
</Value>
<Value name="9">
<Value>Loc</Value>
</Value>
<Value name="10">
<Value>Link</Value>
</Value>
</Data>
<DataLocation>^User.DHCNURMenuD</DataLocation>
<DefaultData>DHCNURMenuDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNURMenuD</IdLocation>
<IndexLocation>^User.DHCNURMenuI</IndexLocation>
<StreamLocation>^User.DHCNURMenuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
