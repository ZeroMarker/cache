Class User.DHCNURMenuSub Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship RecParref As User.DHCNURMenu [ Cardinality = parent, Inverse = ChildRec ];

Property EmrDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required ];

Property EmrTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property EmrUser As %String(TRUNCATE = 1);

Property Loc As %String(TRUNCATE = 1);

Property Loctype As %String(TRUNCATE = 1);

// 根目录id

Property gId As %String(TRUNCATE = 1);

// 根目录名

Property gName As %String(TRUNCATE = 1);

// 模板关键字

Property Code As %String(TRUNCATE = 1);

// 模板名

Property Name As %String(TRUNCATE = 1);

// 显示顺序

Property Seq As %String(TRUNCATE = 1);

Index gIdCode On (gId, Code);

Index EmrCode On Code;

Index Seq On (gId, Seq);

Index LocGidCode On (Loc, gId, Code);

Index LocSeq On (Loc, gId, Seq);

Index LocEmrCode On (Loc, Code);

// d ##class(User.DHCNURMenuSub).%BuildIndices()

// w ##class(User.DHCNURMenuSub).getdescbycode("DHCNURTESHUHUANZHEHULI")

ClassMethod getdescbycode(code) As %String
{
 
  //s ^okk=code
  s code=$zconvert(code,"U")
  s ret=""
  s id="" f  s id=$O(^User.DHCNURMenuD(id)) q:(id="")!(ret'="")  d
  .s chl=""  f  s chl=$O(^User.DHCNURMenuSubD(id,chl)) q:(chl="")!(ret'="")  d
  ..q:chl=""
  ..s a=##class(User.DHCNURMenuSub).%OpenId(id_"||"_chl)
  ..s Code=$zconvert(a.Code,"U")
  ..i Code=code s ret=a.Name
  q ret
}

// w ##class(User.DHCNURMenuSub).getgnamebycode("","DHCNURXHNEWRYPG")

// 根据模板名取根目录名称

// Creat:2014-08

ClassMethod getgnamebycode(loc, code) As %String
{
 
 // s ^okk=code
  s emrcode=$zconvert(code,"U")
  s ret=""
  i '$d(^User.DHCNURMenuSubI("LocGidCode"," "_loc)) s loc=""  //如果某病区没维护 默认取全院的
  i loc="9000" s loc="" //全院的
  s id=""  f  s id=$O(^User.DHCNURMenuSubI("LocGidCode"," "_loc,id)) q:(id="")!(ret'="")  d
  .s code=""  f  s code=$O(^User.DHCNURMenuSubI("LocGidCode"," "_loc,id,code)) q:(code="")!(ret'="")  d
  ..s Code=$zconvert(code,"U")
  ..s Code=$tr(Code," ","")
  ..i Code=emrcode d
  ...s gid=$tr(id," ","")
  ...s a=##class(User.DHCNURMenu).%OpenId(gid)
  ...s ret=a.name
  q ret
}

ClassMethod getgnamebycodenew(loc) As %String
{
 
 // s ^okk=code
  ;s emrcode=$zconvert(code,"U")
  s ret=""
  i '$d(^User.DHCNURMenuSubI("LocGidCode"," "_loc)) s loc=""  //如果某病区没维护 默认取全院的
  i loc="9000" s loc="" //全院的
  s id=""  f  s id=$O(^User.DHCNURMenuSubI("LocGidCode"," "_loc,id)) q:(id="")!(ret'="")  d
  .s code=""  f  s code=$O(^User.DHCNURMenuSubI("LocGidCode"," "_loc,id,code)) q:(code="")!(ret'="")  d
  ..s Code=$zconvert(code,"U")
  ..s Code=$tr(Code," ","")
  ..;i Code=emrcode d
  ..s gid=$tr(id," ","")
  ..s a=##class(User.DHCNURMenu).%OpenId(gid)
  ..s ret=a.name
  q ret
}

// 取某根目录下最大序号

// Creat:2014-08

ClassMethod getmaxindex(loc, id As %String) As %String
{
	s max=0
	s code=""  f  s code=$O(^User.DHCNURMenuSubI("LocGidCode"," "_loc," "_id,code)) q:(code="")  d
	.s chl=""  f  s chl=$O(^User.DHCNURMenuSubI("LocGidCode"," "_loc," "_id,code,id,chl)) q:(chl="")  d
    ..s a=##class(User.DHCNURMenuSub).%OpenId(id_"||"_chl)
    ..s seq=a.Seq
    ..i seq>max s max=seq
    q max
}

// 修改模板绑定的根节点

// Creat:2014-08

ClassMethod refreshseq(loc, oldid As %String, ogid) As %String
{
   
    s a=##class(User.DHCNURMenuSub).%OpenId(oldid)
    s oldseq=a.Seq //原来节点下序号
    s oldmax=..getmaxindex(loc,ogid) //原来节点下最大序号数
    i oldseq'=oldmax d //如果删除的不是最后一条
    .d ..changeseq(loc,ogid,oldseq) //修改序号
    q 0
}

// Creat:2014-08

// 修改删除节点后的seq

ClassMethod changeseq(loc, gid As %String, spos) As %String
{
	s code=""  f  s code=$O(^User.DHCNURMenuSubI("LocGidCode"," "_loc," "_gid,code)) q:(code="")  d
	.s chl=""  f  s chl=$O(^User.DHCNURMenuSubI("LocGidCode"," "_loc," "_gid,code,gid,chl)) q:(chl="")  d
    ..q:chl=""
    ..s a=##class(User.DHCNURMenuSub).%OpenId(gid_"||"_chl)
    ..s seq=a.Seq
    ..i seq>spos d
    ...s a.Seq=a.Seq-1
    ...d a.%Save()
}

// 上移或下移

// input:gid--根节点id ,sub--子表id, flag--1 上移，-1下移

// Creat:2014-08

ClassMethod upordown(loc, gid As %String, sub, flag) As %String
{
	
	s oldmax=..getmaxindex(loc,gid) //原来节点下最大序号数
	s b=##class(User.DHCNURMenuSub).%OpenId(gid_"||"_sub)
    s seq=b.Seq
    q:(seq=oldmax)&(flag>0) 0 //最后一个不能下移
    q:(seq="1")&(flag<0) 0  //第一个不能上移
    s upseq=seq+flag
	s sseq=""  f  s sseq=$O(^User.DHCNURMenuSubI("LocSeq"," "_loc," "_gid,sseq)) q:(sseq="")  d
	.s chl=""  f  s chl=$O(^User.DHCNURMenuSubI("LocSeq"," "_loc," "_gid,sseq,gid,chl)) q:(chl="")  d
    ..q:chl=""
    ..s a=##class(User.DHCNURMenuSub).%OpenId(gid_"||"_chl)
    ..s seqsub=a.Seq
    ..i seqsub=upseq d
    ...s a.Seq=seq
    ...d a.%Save()
    s b.Seq=upseq
    d b.%Save()
    Q 0
}

// change:2014-08

ClassMethod Saveback(parr As %String, rw As %String) As %String
{
	s par=""
	//s ^objcyf212=parr
	s gid=$p(parr,"^",1)       //主表id
	s Code=$p(parr,"^",2)      //EmrCode
	s loc=$p(parr,"^",3)       //保存科室
	s modelname=$p(parr,"^",4) //模板名称
	s gname=$p(parr,"^",5)     //根目录名称
	q:gid="" "根目录不能为空" 
	s par="" s par=$o(^User.DHCNURMenuSubI("LocGidCode"," "_loc," "_gid," "_Code,gid,par)) //当前根节点下是否存在该模板
	s emrcode=$ZConvert(Code,"U")
	s GName=""
    s id="" f  s id=$O(^User.DHCNURMenuD(id)) q:(id="")  d
    .s chl=""  f  s chl=$O(^User.DHCNURMenuSubD(id,chl)) q:(chl="")  d
    ..q:chl=""
    ..s a=##class(User.DHCNURMenuSub).%OpenId(id_"||"_chl)
    ..s EmrCode=$zconvert(a.Code,"U")
    ..q:EmrCode'=emrcode
    ..s ids=id_"||"_chl
	..i id'=gid d  //该模板已经关联根节点，要修改其绑定的根节点
	...d ..refreshseq(ids,id)
	...d ##class(User.DHCNURMenuSub).%DeleteId(ids) //删除原节点下绑定
	..e  d //重复保存
	...s b=##class(User.DHCNURMenuSub).%OpenId(ids)
	...s GName=b.gName
	...i gname=GName d
	....s rw=ids
	i (par'="")&(GName'=gname) q GName_"目录下已经保存过已经保存过"
	i rw=""
	{
	  s max=..getmaxindex(gid)
      s a=##class(User.DHCNURMenuSub).%New()
      s a.RecParref=##class(User.DHCNURMenu).%OpenId(gid)
      s a.Loc=loc
	  s a.gId=gid
	  s a.gName=gname
	  s a.Code=Code
	  s a.Name=modelname
	  s a.Seq=max+1
	  d a.%Save()
	}
	else
	{
      s a=##class(User.DHCNURMenuSub).%OpenId(rw)
      s a.Loc=loc
	  s a.gId=gid
	  s a.gName=gname
	  s a.Code=Code
	  s a.Name=modelname
	  d a.%Save()
		
	}
	q 0
}

// change:2015-08-20

// 增加子项

// w ##class(User.DHCNURMenuSub).Additm(^ojbin)

ClassMethod Additm(parr As %String) As %String
{
	s ^ojbin=parr
    s gid=$p(parr,"^",1)       //主表id
	s Code=$p(parr,"^",2)      //EmrCode
	s loc=$p(parr,"^",3)       //保存科室
	s modelname=$p(parr,"^",4) //模板名称
	s gname=$p(parr,"^",5)     //根目录名称
	q:gid="" "根目录不能为空" 
	//q:'$d(^User.DHCNURMenuSubI("LocGidCode"," "_loc)) "请先保存再增加"
	s par="" 
	i $d(^User.DHCNURMenuSubI("LocGidCode"," "_loc)) d
	.s par=$o(^User.DHCNURMenuSubI("LocGidCode"," "_loc," "_gid," "_Code,par)) //当前根节点下是否存在该模板
	b ;
	q:par'="" "该节点下已经存在该模板"
	s emrcode=$ZConvert(Code,"U")
	s id="" f  s id=$O(^User.DHCNURMenuD(id)) q:(id="")  d
    .s cod=""  f  s cod=$O(^User.DHCNURMenuSubI("LocGidCode"," "_loc," "_id,cod)) q:(cod="")  d
    ..s chl=""  f  s chl=$O(^User.DHCNURMenuSubI("LocGidCode"," "_loc," "_id,cod,id,chl)) q:(chl="")  d
    ...s a=##class(User.DHCNURMenuSub).%OpenId(id_"||"_chl)
    ...s EmrCode=$zconvert(a.Code,"U")
    ...q:EmrCode'=emrcode
    ...s ids=id_"||"_chl
	...i id'=gid d  //该模板已经关联过其他根节点，要修改其绑定的根节点
	....b ;
	....d ..refreshseq(loc,ids,id)
	....d ##class(User.DHCNURMenuSub).%DeleteId(ids) //删除原节点下绑定
      s max=..getmaxindex(loc,gid) //最大seq
      b ;44
      s a=##class(User.DHCNURMenuSub).%New()
      s a.RecParref=##class(User.DHCNURMenu).%OpenId(gid)
      s a.Loc=loc
	  s a.gId=gid
	  s a.gName=gname
	  s a.Code=Code
	  s a.Name=modelname
	  s a.Seq=max+1
	  d a.%Save()
	  q 0
}

// change:2015-08-19

ClassMethod Save(parr As %String) As %String
{
	s ^ojbin=parr
	s len=$l(parr,"$")
	for i=1:1:len
	{
	   s itm=$p(parr,"$",i)
	   i itm="" continue
	   s l=$L(itm,"^")
	   k tmpmenusub
	   for j=1:1:l
	   {
	     s itmsub=$P(itm,"^",j)
	     if itmsub="" continue
	     s name=$P(itmsub,"|")
	     s val=$P(itmsub,"|",2)
	     i name="" continue
	     s tmpmenusub(name)=val
	   }
	   i (($g(tmpmenusub("rw"))="")||($g(tmpmenusub("par"))=""))&&($g(tmpmenusub("gid"))'="")  d
	   .s a=##class(User.DHCNURMenuSub).%New()
	   .s a.RecParref=##class(User.DHCNURMenu).%OpenId(tmpmenusub("gid"))
       .s a.Loc=tmpmenusub("loc")
	   .s a.gId=tmpmenusub("gid")
	   .s a.gName=tmpmenusub("gName")
	   .s a.Code=tmpmenusub("Code")
	   .s a.Name=tmpmenusub("Name")
	   .s a.Seq=tmpmenusub("Seq")
	   .d a.%Save()
	}
	
	q 0
}

// d ##class(%ResultSet).RunQuery("User.DHCNURMenuSub","CRItem","^^^^")

// change:2014-08

ClassMethod CRItemExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ^ojyb=parr
 	s Id=$p(parr,"^",1)
	s INGName=$p(parr,"^",2) //gen name
	s xsname=$p(parr,"^",3) //mo ban id
	s modecode=$p(parr,"^",4) //xian shi ming chen
	s LocId=$p(parr,"^",5)  //Loc
 	s ind=1
 	b ;00
 	i '$d(^User.DHCNURMenuSubI("LocSeq")) d   //增加索引后重新生成索引
 	.&sql(update sqluser.DHCNURMenuSub set Loc=:null) 
 	.d ##class(User.DHCNURMenuSub).%BuildIndices()
 	
 	s Menusub=""
    s id="" f  s id=$O(^User.DHCNURMenuD(id)) q:id=""  d
    .s index=0
    .s seqchl=""  f  s seqchl=$O(^User.DHCNURMenuSubI("LocSeq"," "_LocId," "_id,seqchl)) q:seqchl=""  d
    ..s chl=""  f  s chl=$O(^User.DHCNURMenuSubI("LocSeq"," "_LocId," "_id,seqchl,id,chl)) q:chl=""  d
    ...s b=##class(User.DHCNURMenu).%OpenId(id)
 	...s a=##class(User.DHCNURMenuSub).%OpenId(id_"||"_chl)
 	...s index=index+1
    ...i a.Seq="" d  //如果没有顺序默认生成一个
 	....s a.Seq=index
 	....d a.%Save()
 	...s gName=a.gName
 	...s gid=a.gId
 	...s Name=a.Name
 	...s Code=a.Code
 	...s Seq=a.Seq
 	...q:(INGName'="")&&(INGName'=gid)
 	...q:(modecode'="")&&(modecode'=Code)
 	...q:(xsname'="")&&(Name'[xsname)
	...s rw=id
	...s par=chl
	...q:id=""
	...q:Seq=""
	...s Menusub(id,Seq)="gName|"_gName_"^Name|"_Name_"^Code|"_Code_"^rw|"_id_"^par|"_par_"^Seq|"_Seq_"^gid|"_id_"^loc|"_LocId
	i '$d(^User.DHCNURMenuSubI("LocSeq"," "_LocId))  
	{
	k Menusub
	s id="" f  s id=$O(^User.DHCNURMenuD(id)) q:id=""  d
    .s index=0
    .s seqchl=""  f  s seqchl=$O(^User.DHCNURMenuSubI("LocSeq"," "," "_id,seqchl)) q:seqchl=""  d
    ..s chl=""  f  s chl=$O(^User.DHCNURMenuSubI("LocSeq"," "," "_id,seqchl,id,chl)) q:chl=""  d
    ...s b=##class(User.DHCNURMenu).%OpenId(id)
 	...s a=##class(User.DHCNURMenuSub).%OpenId(id_"||"_chl)
 	...s index=index+1
    ...i a.Seq="" d  //如果没有顺序默认生成一个
 	....s a.Seq=index
 	....d a.%Save()
 	...s gName=a.gName
 	...s gid=a.gId
 	...s Name=a.Name
 	...s Code=a.Code
 	...s Seq=a.Seq
	...s rw=""
	...s par=""
	...q:id=""
	...q:Seq=""
	...s Menusub(id,Seq)="gName|"_gName_"^Name|"_Name_"^Code|"_Code_"^rw|"_"^par|"_"^Seq|"_Seq_"^gid|"_id_"^loc|"_LocId
	}
	s p="" f  s p=$o(Menusub(p)) q:p=""  d
	.s sub="" f  s sub=$o(Menusub(p,sub)) q:sub=""  d
	..s ret=Menusub(p,sub)
	..d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CRItemExecuteback(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ^ojyb=parr
 	s Id=$p(parr,"^",1)
	s INGName=$p(parr,"^",2) //gen name
	s xsname=$p(parr,"^",3) //mo ban id
	s modecode=$p(parr,"^",4) //xian shi ming chen
	s type=$p(parr,"^",5)
 	s ind=1
 	b ;00
 	i '$d(^User.DHCNURMenuSubI("LocSeq")) d   //增加索引后重新生成索引
 	.&sql(update sqluser.DHCNURMenuSub set Loc=:null) 
 	.d ##class(User.DHCNURMenuSub).%BuildIndices()
 	s Menusub=""
    s id="" f  s id=$O(^User.DHCNURMenuD(id)) q:id=""  d
    .s index=0
    .s chl=""  f  s chl=$O(^User.DHCNURMenuSubD(id,chl)) q:chl=""  d
	..q:chl=""
    ..s b=##class(User.DHCNURMenu).%OpenId(id)
 	..s a=##class(User.DHCNURMenuSub).%OpenId(id_"||"_chl)
 	..s index=index+1
    ..i a.Seq="" d  //如果没有顺序默认生成一个
 	...s a.Seq=index
 	...d a.%Save()
 	..s gName=a.gName
 	..s gid=a.gId
 	..s Name=a.Name
 	..s Code=a.Code
 	..s Seq=a.Seq
 	..q:(INGName'="")&&(INGName'=gid)
 	..q:(modecode'="")&&(modecode'=Code)
 	..q:(xsname'="")&&(Name'[xsname)
	..s rw=id
	..s par=chl
	..q:id=""
	..q:Seq=""
	..s Menusub(id,Seq)="gName|"_gName_"^Name|"_Name_"^Code|"_Code_"^rw|"_id_"^par|"_par_"^Seq|"_Seq
	s p="" f  s p=$o(Menusub(p)) q:p=""  d
	.s sub="" f  s sub=$o(Menusub(p,sub)) q:sub=""  d
	..s ret=Menusub(p,sub)
	..d outtyp233
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp233
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

/// 取护理模版的代码与名称
/// 2010-09-14
ClassMethod GetDepModelSet3(funname As %String) As %String
{
	s SubKCode="" f  s SubKCode=$O(^NurEmr.NurEmrSubI("KCode",SubKCode)) q:SubKCode=""  d
	.s ItmId=$O(^NurEmr.NurEmrSubI("KCode",SubKCode,""))
	.q:ItmId=""
	.s ItmDesc=$List(^NurEmr.NurEmrSubD(ItmId),4)
	.s ItmCode=$TR(SubKCode," ","")
	.//q:($E(ItmCode,1,6)'="DHCNUR")!($L(ItmCode)>10)
 	.s rtnval=funname_"('"_$ZCVT($g(ItmCode),"O","JS")_"','"_$ZCVT($g(ItmDesc),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	q 0
}

/// 护理记录单配置
/// 2010-09-28
ClassMethod GetDepModelSet(funname As %String) As %String
{
	//w ##class(web.DHCNurseRecordComm).GetDepModelSet("211","")
	s LocId="9000"
	i LocId'="" d
	.s DepModelStr=$G(^DHCNurDepModelSet(LocId))
	.f ii=1:1:$L(DepModelStr) d
	..s DepModel=$P(DepModelStr,"^",ii)
	..q:DepModel=""
	..s ModelKey=$P(DepModel,"|",1)
	..s ModelName=$P(DepModel,"|",2)
	..s ModelSort=$P(DepModel,"|",3)
	..s DepModel(ModelKey)=ModelName_"^"_ModelSort
	..s rtnval=funname_"('"_$ZCVT($g(ModelKey),"O","JS")_"','"_$ZCVT($g(ModelName),"O","JS")_"');"
    ..&javascript<#(rtnval)#>
	s rtnval=funname_"('"_$ZCVT("DHCNURTEM","O","JS")_"','"_$ZCVT("体温单","O","JS")_"');"
    &javascript<#(rtnval)#>
 	q 0
}

ClassMethod delete(parr As %String) As %String
{
	
	s rw=$p(parr,"^")
	s par=$p(parr,"^",2)
    s id=rw_"||"_par
   q:id=""
   s a=##class(User.DHCNURMenuSub).%DeleteId(id)
	q 0
}

ClassMethod deleteloc(loc As %String) As %String
{
	
	q:loc="" "病区不能为空"
	&sql(delete sqluser.DHCNURMenuSub where Loc=:loc) 
	q 0
}

// 获取当前科室是否有维护

ClassMethod iflochaveset(loc As %String) As %String
{
	
	q:loc="" "病区不能为空"
	s ret=""
	i $d(^User.DHCNURMenuSubI("LocSeq"," "_loc)) s ret="Y"
	q ret
}

// d ##class(%ResultSet).RunQuery("User.DHCNURMenuSub","GetRootname","W")

ClassMethod GetRootnameExecute(ByRef qHandle As %Binary, typ As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
	s rw=""
	s ^objtmp=typ
	f {
      s rw=$O(^User.DHCNURMenuD(rw))
      q:rw=""
      s b=##class(User.DHCNURMenu).%OpenId(rw)
      s desc=b.name
      s ret="^rw|"_rw_"^Desc|"_desc
      d outtyp2

	 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetRootnameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRootnameExecute ]
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

Query GetRootname(typ As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetRootnameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRootnameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 将科室配置的模板自动取到筛选集合中

// w ##class(web.DHCNurseRecordComm).initselects()

// Creat:2014-08

ClassMethod initselects() As %String
{
	s rw="" f  s rw=$o(^DHCNurDepModelSet(rw)) q:rw=""  d
	.q:rw="9000"
	.d ..insertselect(rw)
}

// Creat:2014-08

ClassMethod insertselect(rw) As %String
{
  s Selected=$G(^DHCNurDepModelSet("9000")) //已经筛选的记录单
  s locstr=$G(^DHCNurDepModelSet(rw)) //已经筛选的记录单
  s tmpsel=""
  b ;
  for i=1:1:$l(Selected,"^")
  {
	  s itm=$p(Selected,"^",i)
	  s code=$p(itm,"|")
	  i code="" continue
	  s tmpsel(code)=""
  }
  for j=1:1:$l(locstr,"^")
  {
	  s itm2=$p(locstr,"^",j)
	  s code2=$p(itm2,"|")
	  i code2="" continue
	  i '$d(tmpsel(code2))  d
	  .s Selected=Selected_"^"_itm2
  }
  b ;3
  s ^DHCNurDepModelSet("9000")=Selected
}

// Creat:2014-08

// input:LocId

//            9000 --查询已筛选模板

//           All --查询全院都能显示的模板 ，

//           "" --查询库中所有模板

//           其他id--查询某科室(id)模板

/// 科室显示模板查询
ClassMethod GetDepModelSet2014(LocId As %String, funname As %String) As %String
{
	//w ##class(web.DHCNurseRecordComm).GetDepModelSet(^objcyf812,"add")
	i '$d(^DHCNurDepModelSet("TongBu")) d  //更新后第一次查询时将所有已经配置给病区的单子都置成已经筛选
	.d ..initselects()
	.s ^DHCNurDepModelSet("TongBu")=""
	//s ^objcyf812=LocId
	s DepModelSort=""
	i LocId'="" d
	.s DepModelStr=$G(^DHCNurDepModelSet(LocId))
	.f ii=1:1:$L(DepModelStr) d
	..s DepModel=$P(DepModelStr,"^",ii)
	..q:DepModel=""
	..s ModelKey=$P(DepModel,"|",1)
	..s ModelName=$P(DepModel,"|",2)
	..s ModelSort=$P(DepModel,"|",3)
	..s DepModel(ModelKey)=ModelName_"^"_ModelSort
	..s DepModelSort(ModelSort,ModelKey)=ModelName_"^"_ModelSort
    s DepModelStr=$G(^DHCNurDepModelSet("9000")) //筛选的记录单
    s SelectedDepModel=""
	f ii=1:1:$L(DepModelStr) d
	.s DepModel=$P(DepModelStr,"^",ii)
	.q:DepModel=""
	.s ModelKey=$P(DepModel,"|",1)
	.s ModelName=$P(DepModel,"|",2)
	.s ModelSort=$P(DepModel,"|",3)
	.s QYDepModel(ModelKey)=ModelName_"^"_ModelSort
	.s SelectedDepModel(ModelSort,ModelKey)=ModelName_"^"_ModelSort
	s DepModelStrAll=$G(^DHCNurDepModelSet("All")) //配置给说有科室的记录单
	f ii=1:1:$L(DepModelStrAll) d
	.s DepModel=$P(DepModelStrAll,"^",ii)
	.q:DepModel=""
	.s ModelKey=$P(DepModel,"|",1)
	.s ModelName=$P(DepModel,"|",2)
	.s ModelSort=$P(DepModel,"|",3)
	.s DepModelAll(ModelKey)=ModelName_"^"_ModelSort
	.s DepModelAllSort(ModelSort,ModelKey)=ModelName_"^"_ModelSort
	i LocId="" d  //查询库中所有模板
	.s SubKCode="" f  s SubKCode=$O(^NurEmr.NurEmrSubI("KCode",SubKCode)) q:SubKCode=""  d
	..s ItmId=$O(^NurEmr.NurEmrSubI("KCode",SubKCode,""))
	..q:ItmId=""
	..s RecName=$List(^NurEmr.NurEmrSubD(ItmId),4)
	..s RecTyp=$TR(SubKCode," ","")
	..q:($E(RecTyp,1,6)'="DHCNUR")
	..q:($E(RecName,1,3)="Win")
	..q:RecName["打印"
	..q:RecTyp["PRN"
	..q:RecName["**"
	..s ModelName="",ModelSort="",IfShow=0,IfAllShow=0,IfSelect=0
	..s IfAllShow=0
	..s IfShow=0
	..s gitem=""
	..i $D(QYDepModel(RecTyp)) d //筛选的记录
	...s ModelName=$P(QYDepModel(RecTyp),"^",1)
	...s ModelSort=$P(QYDepModel(RecTyp),"^",2)
	...s IfSelect=1
	...s gitem=##class(User.DHCNURMenuSub).getgnamebycode(LocId,RecTyp) //获取根目录名
	..i $d(DepModelAll(RecTyp)) d //配置给全院的记录
	...s IfAllShow=1
 	..s rtnval=funname_"('"_$ZCVT($g(RecTyp),"O","JS")_"','"_$ZCVT($g(RecName),"O","JS")_"','"_$ZCVT($g(IfShow),"O","JS")_"','"_$ZCVT($g(ModelSort),"O","JS")_"','"_$ZCVT($g(ModelName),"O","JS")_"','"_$ZCVT($g(IfAllShow),"O","JS")_"','"_$ZCVT($g(IfSelect),"O","JS")_"','"_$ZCVT($g(gitem),"O","JS")_"');"
 	..&javascript<#(rtnval)#>
 	q:LocId="" 0
 	i LocId="9000" d //查询已经筛选过得记录
 	.s rw="" f  s rw=$o(DepModelAllSort(rw)) q:rw=""  d
 	..s id="" f  s id=$o(DepModelAllSort(rw,id)) q:id=""  d
 	...s itm=DepModelAllSort(rw,id)
 	...s name=$p(itm,"^")
 	...s allshow=1,select=1
 	...s gitem=##class(User.DHCNURMenuSub).getgnamebycode(LocId,id) //获取根目录名
 	...s rtnval=funname_"('"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"','"_$ZCVT($g(ifshow),"O","JS")_"','"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"','"_$ZCVT($g(allshow),"O","JS")_"','"_$ZCVT($g(select),"O","JS")_"','"_$ZCVT($g(gitem),"O","JS")_"');"
 	...&javascript<#(rtnval)#>
 	.s rw="" f  s rw=$o(SelectedDepModel(rw)) q:rw=""  d
 	..s id="" f  s id=$o(SelectedDepModel(rw,id)) q:id=""  d
 	...s itm=SelectedDepModel(rw,id)
 	...s name=$p(itm,"^")
 	...s allshow=0,select=1,gitem=""
 	...q:$d(DepModelAll(id))
 	...s gitem=##class(User.DHCNURMenuSub).getgnamebycode(LocId,id)
 	...i $d(DepModelAll(id)) d
 	....s allshow=1
 	...s rtnval=funname_"('"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"','"_$ZCVT($g(ifshow),"O","JS")_"','"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"','"_$ZCVT($g(allshow),"O","JS")_"','"_$ZCVT($g(select),"O","JS")_"','"_$ZCVT($g(gitem),"O","JS")_"');"
 	...&javascript<#(rtnval)#>
 	e  d //按科室查询
 	.s rw="" f  s rw=$o(DepModelAllSort(rw)) q:rw=""  d   //查询全院的
 	..s id="" f  s id=$o(DepModelAllSort(rw,id)) q:id=""  d
 	...s itm=DepModelAllSort(rw,id)
 	...s name=$p(itm,"^")
 	...s allshow=1,select=1
 	...s gitem=##class(User.DHCNURMenuSub).getgnamebycode(LocId,id) //获取根目录名
 	...s rtnval=funname_"('"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"','"_$ZCVT($g(ifshow),"O","JS")_"','"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"','"_$ZCVT($g(allshow),"O","JS")_"','"_$ZCVT($g(select),"O","JS")_"','"_$ZCVT($g(gitem),"O","JS")_"');"
 	...&javascript<#(rtnval)#>
 	.s rw="" f  s rw=$o(DepModelSort(rw)) q:rw=""  d //查询科室的
 	..s id="" f  s id=$o(DepModelSort(rw,id)) q:id=""  d
 	...s itm=DepModelSort(rw,id)
 	...s name=$p(itm,"^")
 	...s allshow=0,select=1,ifshow=1,gitem=1
 	...q:$d(DepModelAll(id))
 	...s gitem=##class(User.DHCNURMenuSub).getgnamebycode(LocId,id) //获取根目录名
 	...s rtnval=funname_"('"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"','"_$ZCVT($g(ifshow),"O","JS")_"','"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"','"_$ZCVT($g(allshow),"O","JS")_"','"_$ZCVT($g(select),"O","JS")_"','"_$ZCVT($g(gitem),"O","JS")_"');"
 	...&javascript<#(rtnval)#>
 	.s rw="" f  s rw=$o(SelectedDepModel(rw)) q:rw=""  d //查询筛选中未配置的
 	..s id="" f  s id=$o(SelectedDepModel(rw,id)) q:id=""  d
 	...s itm=SelectedDepModel(rw,id)
 	...s name=$p(itm,"^")
 	...s allshow=0,select=1,ifshow=0,gitem=1
 	...q:$d(DepModelAll(id))
 	...q:$d(DepModel(id))
 	...s gitem=##class(User.DHCNURMenuSub).getgnamebycode(LocId,id) //获取根目录名
 	...s rtnval=funname_"('"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"','"_$ZCVT($g(ifshow),"O","JS")_"','"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"','"_$ZCVT($g(allshow),"O","JS")_"','"_$ZCVT($g(select),"O","JS")_"','"_$ZCVT($g(gitem),"O","JS")_"');"
 	...&javascript<#(rtnval)#>
 	q 0
}

// 根目录

// w ##class(web.DHCNurseRecordComm).GetGName()

// 获取根目录列表

// Creat:2014-08

ClassMethod GetGName() As %String
{
	
	s PatJson=##class(%ListOfDataTypes).%New()
	s id="" f  s id=$O(^User.DHCNURMenuD(id)) q:id=""  d
 	.s a=##class(User.DHCNURMenu).%OpenId(id)
 	.s ChildJson=##class(%ArrayOfDataTypes).%New()
	.s rw=id
	.s name=a.name
	.d ChildJson.SetAt(name,"desc")
	.d ChildJson.SetAt(rw,"id")
    .d PatJson.Insert(ChildJson)
    q ##class(Nur.JSON).Encode(PatJson)
}

/// 更新子目录名称
ClassMethod update(id As %String, parr As %String) As %String
{
	q:(id="")||(parr="") "不能更新为空"
	s Name=parr
	s ids=id
    s a=##class(User.DHCNURMenuSub).%OpenId(id)
	s a.Name=Name
	d a.%Save()
	q 0
}

Storage Default
{
<Data name="DHCNURMenuSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EmrDate</Value>
</Value>
<Value name="3">
<Value>EmrTime</Value>
</Value>
<Value name="4">
<Value>EmrUser</Value>
</Value>
<Value name="5">
<Value>Loc</Value>
</Value>
<Value name="6">
<Value>Loctype</Value>
</Value>
<Value name="7">
<Value>NurseNo</Value>
</Value>
<Value name="8">
<Value>Code</Value>
</Value>
<Value name="9">
<Value>Name</Value>
</Value>
<Value name="10">
<Value>gName</Value>
</Value>
<Value name="11">
<Value>gId</Value>
</Value>
<Value name="12">
<Value>Seq</Value>
</Value>
</Data>
<DataLocation>^User.DHCNURMenuSubD</DataLocation>
<DefaultData>DHCNURMenuSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNURMenuSubD</IdLocation>
<IndexLocation>^User.DHCNURMenuSubI</IndexLocation>
<StreamLocation>^User.DHCNURMenuSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
