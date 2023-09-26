Class web.UDHCANOPSET Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 116;

ClassMethod SaveAnOpSet(AnOpLoc) As %String
{
	q:AnOpLoc="" ""
	s curHospId=%session.Data("LOGON.HOSPID")
	i curHospId="" s curHospId=1
	s ^DHCANOPSET(curHospId,"anloc")=$P(AnOpLoc,"!")
	s ^DHCANOPSET(curHospId,"oploc")=$P(AnOpLoc,"!",2)
   q 0
}

ClassMethod GetAnLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnLocExecute ]
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

ClassMethod GetAnLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetAnLocExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s curHospId=%session.Data("LOGON.HOSPID")	;当前登陆的医院Id
 	if $G(^DHCANOPSET(curHospId,"anloc"))="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
 	s ^tmpDyl("hos")=curHospId
 	i curHospId="" s curHospId=1
 	s num=$L(^DHCANOPSET(curHospId,"anloc"),"^")
 	f i=1:1:num
 	{   
 		s prior=$P(^DHCANOPSET(curHospId,"anloc"),"^",i)
	 	s rw=$P(prior,"|")
	 	s hospId=$p(^CTLOC(rw),"^",22)
	 	q:(hospId'=curHospId)&(hospId'="")
	 	s desc=$P(prior,"|",2)
	 	Do Outputcat2
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat2
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetAnLoc() As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod GetOpLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpLocExecute ]
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

ClassMethod GetOpLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.UDHCANOPSET","GetOpLoc","mzs")

ClassMethod GetOpLocExecute(ByRef qHandle As %Binary, curdesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s curdesc=##class(web.DHCClinicCom).GetChinaChar(curdesc)
	s curdesc=$$ALPHAUP^SSUTIL4(curdesc)
	s curHospId=%session.Data("LOGON.HOSPID")	;当前登陆的医院Id
   	if $G(^DHCANOPSET(curHospId,"oploc"))="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
	i curHospId="" s curHospId=1
 	s num=$L(^DHCANOPSET(curHospId,"oploc"),"^")
 	f i=1:1:num d
 		.s prior=$P(^DHCANOPSET(curHospId,"oploc"),"^",i)
	 	.s rw=$P(prior,"|")
	 	.s hospId=$p(^CTLOC(rw),"^",22)
	 	.q:(hospId'=curHospId)&(hospId'="")
	 	.s desc=$P(prior,"|",2)
	 	.q:(curdesc'="")&($$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(desc))'[curdesc)
	 	.Do Outputcat
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetOpLoc(curdesc As %String = "") As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod ctloclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctloclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ctloclookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	;s rowid=0
	i $g(desc)'="" s desc=$$ALPHAUP^SSUTIL4(desc)
	s curHospId=%session.Data("LOGON.HOSPID")	;当前登陆的医院Id
	s len=$l(desc)
    s ctlocrowid="" f  s ctlocrowid=$o(^CTLOC(ctlocrowid)) q:ctlocrowid=""  d
	    . q:'$d(^CTLOC(ctlocrowid))
	    . s locHospId=$p(^CTLOC(ctlocrowid),"^",22)
	    . q:(locHospId'=curHospId)&(locHospId'="")&(curHospId'="")
	    . s LocActiveFrom=+$p($g(^CTLOC(ctlocrowid)),"^",24)
		. s LocActiveTo=+$p($g(^CTLOC(ctlocrowid)),"^",25)
		. q:((LocActiveFrom'=0)&&(LocActiveFrom>+$h))||((LocActiveTo<+$h)&&(LocActiveTo'=0))
	    . s ctlocdesc=$p(^CTLOC(ctlocrowid),"^",2)
	    . s desc1=$$ALPHAUP^SSUTIL4(ctlocdesc)
	    . s desc1=$e(desc1,1,len)
	    .// w !,desc1_"    "_"desc"_"^"_desc
	    . Q:##class(web.DHCOPAdmReg).CheckLocDesc(ctlocrowid,desc)'=1
	 	.Do OutputRow4
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	s ctlocdesc=##class(web.DHCOPAdmReg).LocDescFormate(ctlocdesc)
	set Data=$lb(ctlocrowid,ctlocdesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ctloclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctloclookupExecute ]
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

Query ctloclookup(desc As %String) As %Query(ROWSPEC = "ctlocid:%String,ctloc:%String")
{
}

ClassMethod ifloc(Loc) As %String
{
	 q:Loc="" ""
	 s ret=0
	 s curHospId=%session.Data("LOGON.HOSPID")
	 /*
	 s num=$L($G(^DHCANOPSET(curHospId,"oploc")),"^")
	 f i=1:1:num
	 { 
	   s str=$P($g(^DHCANOPSET(curHospId,"oploc")),"^",i)
	   s id=$P(str,"|")
	   i id=Loc s ret=1
	 }
	 s num=$L($G(^DHCANOPSET(curHospId,"anloc")),"^")
	 f i=1:1:num
	 { 
	   s str=$P($g(^DHCANOPSET(curHospId,"anloc")),"^",i)
	   s id=$P(str,"|")
	   i id=Loc s ret=2
	 }
	 */
	 s LOCParRef="" f  s LOCParRef=$o(^CT("LL",0,"Loc1",Loc,LOCParRef)) q:LOCParRef=""  d
	 .s LOCChildsub="" f  s LOCChildsub=$o(^CT("LL",0,"Loc1",Loc,LOCParRef,LOCChildsub)) q:LOCChildsub=""  d
	 ..s HospId=$p(^CT("LL",LOCParRef,"LOC",LOCChildsub),"^",2)
	 ..q:((HospId'="")&(HospId'=curHospId))
     ..s LLCode=$p(^CT("LL",LOCParRef),"^",1)
     ..i ("^OP^EMOP^OUTOP^")[("^"_LLCode_"^") s ret=1
     ..i ("^AN^EMAN^OUTAN^")[("^"_LLCode_"^") s ret=2
     ..q:ret'=0
	 q ret
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-26
/// Description: 增加手术麻醉单据
/// Table：^DHCCLSet
/// Input：code: 手术麻醉单据代码 typeStr:打印单据名^模版名^手术状态^手术状态代码
/// Return：成功返回0,失败返回-1
ClassMethod TypeAdd(code As %String, typeStr As %String)
{
	q:(code="") -2
	i $d(^DHCCLSet("AnOp","PrnCol","VarDef",code))>0 q -1
	s ^DHCCLSet("AnOp","PrnCol","VarDef",code)=typeStr q 0
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-26
/// Description: 修改手术麻醉单据
/// Table：^DHCCLSet
/// Input：oldCode:手术麻醉单据原代码 code:手术麻醉单据代码 typeStr:打印单据名^模版名^手术状态^手术状态代码
/// Return：成功返回0,失败返回-1
ClassMethod TypeUpdate(oldCode As %String, code As %String, typeStr As %String)
{
	s ret=0
	q:(code="") -2
	q:(oldCode="") -1
	i oldCode'=code d
		.i $d(^DHCCLSet("AnOp","PrnCol","VarDef",code))>0 s ret=1
	    .e  d
		    ..m ^DHCCLSet("AnOp","PrnCol","VarDef",code)=^DHCCLSet("AnOp","PrnCol","VarDef",oldCode)
		    ..k ^DHCCLSet("AnOp","PrnCol","VarDef",oldCode)
		    ..i $d(^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",oldCode)) d
			    ...m ^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",code)=^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",oldCode)
			    ...k ^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",oldCode)
			..s ret=0
	s ^DHCCLSet("AnOp","PrnCol","VarDef",code)=typeStr
	 q ret
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-26
/// Description: 删除手术麻醉单据
/// Table：^DHCCLSet
/// Input：code:手术麻醉单据代码
/// Return：成功返回0,失败返回-2
ClassMethod TypeDel(code As %String)
{
	q:(code="") -2
	k ^DHCCLSet("AnOp","PrnCol","VarDef",code)
	q 0
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-26
/// Description: 查询手术麻醉单据
/// Table：^DHCCLSet
/// Input：
/// Return：返回: code:手术麻醉单据代码 name:打印单据名 filename:模版名 operStat:手术状态 statCode:手术状态代码
Query FindQueryType() As %Query(ROWSPEC = "code,name,filename,operStat,statCode")
{
}

ClassMethod FindQueryTypeExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
	s ind=1
	s queryTypeCode=0
	f  s queryTypeCode=$o(^DHCCLSet("AnOp","PrnCol","VarDef",queryTypeCode)) q:queryTypeCode=""  d
	 .s code=queryTypeCode
	 .s name=$p(^DHCCLSet("AnOp","PrnCol","VarDef",queryTypeCode),"^",1)
     .s filename=$p(^DHCCLSet("AnOp","PrnCol","VarDef",queryTypeCode),"^",2)
     .s operStat=$p(^DHCCLSet("AnOp","PrnCol","VarDef",queryTypeCode),"^",3)
     .s statCode=$p(^DHCCLSet("AnOp","PrnCol","VarDef",queryTypeCode),"^",4)
     .d OutRowtyp1
    s qHandle=$lb(0,repid,0)  
     q $$$OK

OutRowtyp1
	s Data=$lb(code,name,filename,operStat,statCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q

 //code,name,filename,byadm,prnframe,prechkdays
}

ClassMethod FindQueryTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQueryTypeExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindQueryTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQueryTypeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-26
/// Description: 增加手术麻醉单据打印列
/// Table：^DHCCLSet
/// Input：code:手术麻醉单据代码, typeStr:定义打印列名|列名|列代码|序号
/// Return：成功返回0,失败返回-2
ClassMethod AddTitle(code As %String, typeStr As %String)
{
	q:(code="") -2
	s rw=$I(^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",code))
	s ^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",code,rw)=typeStr
	q 0
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-26
/// Description: 更新手术麻醉单据打印列
/// Table：^DHCCLSet
/// Input：rw: 打印列rowId, TypeStr:定义打印列名|列名|列代码|序号, Type:手术麻醉单据代码 
/// Return：成功返回0,失败返回-1
ClassMethod UpdateTitle(rw, TypStr, Typ) As %String
{
	q:(Typ="")!(rw="") -1
	s ^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",Typ,rw)=TypStr
	q 0
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-26
/// Description: 删除手术麻醉单据打印列
/// Table：^DHCCLSet
/// Input：rw: 打印列rowId, Type:手术麻醉单据代码 
/// Return：成功返回0,失败返回-1
ClassMethod DelTitle(Typ, rw) As %String
{
	q:(Typ="")!(rw="") -1
	k ^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",Typ,rw)
	q 0
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-26
/// Description: 查询所有列
/// Table：^DHCCLSet
/// Input：ColName:列名
/// Return：返回: desc:列名 ID:列代码
Query FindAllVarLink(ColName As %String) As %Query(ROWSPEC = "desc,ID")
{
}

ClassMethod FindAllVarLinkExecute(ByRef qHandle As %Binary, ColName As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
	s var=0
	f  s var=$o(^DHCCLSet("AnOp","PrnCol","Var",var)) q:var=""  d
	    .s varStr=$p(^DHCCLSet("AnOp","PrnCol","Var",var),"^",1)
	    .q:(ColName'="")&(ColName'=" ")&(varStr'[ColName)
	    .s varAlp=$p(^DHCCLSet("AnOp","PrnCol","Var",var),"^",2)
        .d Outvar
    s qHandle=$lb(0,repid,0)
	q $$$OK

Outvar
	s Data=$lb(varStr,varAlp)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindAllVarLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllVarLinkExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindAllVarLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllVarLinkExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-26
/// Description: 查询手术麻醉单据打印列
/// Table：^DHCCLSet
/// Input：queryTypeCode:手术麻醉单据代码
/// Return：返回: seqno:序号,name:定义打印列名,ColLink:列名,ColLinkID:列代码,rw:打印列rowId
Query FinTypeSetPrint(queryTypeCode As %String = "") As %Query(ROWSPEC = "seqno,name,ColLink,ColLinkID,rw")
{
}

ClassMethod FinTypeSetPrintExecute(ByRef qHandle As %Binary, queryTypeCode As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
	s rw=0
	i (queryTypeCode'="")
	{
	f  s rw=$o(^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",queryTypeCode,rw)) q:rw=""  d
	    .s name=$p(^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",queryTypeCode,rw),"|",1)
	    .s ColLink=$p(^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",queryTypeCode,rw),"|",2)
	    .s ColLinkID=$p(^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",queryTypeCode,rw),"|",3)
        .s seqno=$p(^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",queryTypeCode,rw),"|",4)
        .s tem(seqno,rw)=$lb(seqno,name,ColLink,ColLinkID,rw)
	}
	s i=0
    s seqno=""  f  s seqno=$O(tem(seqno))  q:seqno=""  d
    .s rw=0 f  s rw=$O(tem(seqno,rw)) q:rw=""  d
    ..s name=$List(tem(seqno,rw),2)
    ..s ColLink=$List(tem(seqno,rw),3)
    ..s ColLinkID=$List(tem(seqno,rw),4)
    ..s i=i+1
    ..d OutRow
    if (i=0)&(queryTypeCode'="") k ^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",queryTypeCode)
    s qHandle=$lb(0,repid,0)
    q $$$OK
OutRow
	s Data=$lb(seqno,name,ColLink,ColLinkID,rw)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q

 //code,name,filename,byadm,prnframe
}

ClassMethod FinTypeSetPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FinTypeSetPrintExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FinTypeSetPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FinTypeSetPrintExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-27
/// Description: 取手术麻醉单据打印列
/// Table：^DHCCLSet
/// Input：queryTypeCode: 手术麻醉打印列设置的代码
/// Return：返回打印单据名!模版名!手术申请状态!打印列名称^打印列代码
ClassMethod GetPrintTitle(queryTypeCode = "SSD") As %String
{
	q:queryTypeCode="" ""
	s valStr="",TypeName="",fileName="",OpStatus="",captionStr="" 
	if '$D(^DHCCLSet("AnOp","PrnCol","VarDef",queryTypeCode)){
		s TypeName="手术病人清单"
		s fileName="oppatlist.xls"
		s OpStatus="安排"
		s captionStr="序号|ordno^类型|jzstat^开始日期|opdate^手术间|oproom^台次|opordno^科室|loc^登记号|regno^病人姓名|patname^性别|sex^年龄|age^术前诊断|diag^手术名称|opname^手术医师|opdoc^巡回护士|circulnurs^麻醉方法|anmethod^麻醉医师|andoc^器械护士|scrubnurse^手术要求|opmem"
		s valStr=TypeName_"!"_fileName_"!"_OpStatus_"!"_captionStr
		q valStr
	} 
	s TypeName=$p(^DHCCLSet("AnOp","PrnCol","VarDef",queryTypeCode),"^",1)
	s fileName=$p(^DHCCLSet("AnOp","PrnCol","VarDef",queryTypeCode),"^",2)
	s OpStatus=$p(^DHCCLSet("AnOp","PrnCol","VarDef",queryTypeCode),"^",3)
	if '$D(^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",queryTypeCode)){
		s captionStr="序号|ordno^类型|jzstat^开始日期|opdate^手术间|oproom^台次|opordno^科室|loc^登记号|regno^病人姓名|patname^性别|sex^年龄|age^术前诊断|diag^手术名称|opname^手术医师|opdoc^巡回护士|circulnurs^麻醉方法|anmethod^麻醉医师|andoc^器械护士|scrubnurse^手术要求|opmem"
	}
	s no=""  f  s no=$O(^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",queryTypeCode,no)) q:no=""  d
		.s caption=$P(^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",queryTypeCode,no),"|",1)
		.s code=$P(^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",queryTypeCode,no),"|",3)
		.s seqno=+$P(^DHCCLSet("AnOp","PrnCol","VarSetColumnPrt",queryTypeCode,no),"|",4)
		.i seqno>0 d
			..s $P(captionStr,"^",seqno)=caption_"|"_code
	s valStr=TypeName_"!"_fileName_"!"_OpStatus_"!"_captionStr
	q valStr
}

/// Description: 保存导出目录
ClassMethod SaveExportParth(ExportParth) As %String
{
	s ^DHCCLSet("AnOp","ExportParth")=ExportParth
	q 0
}

/// Description: 保存导出目录
ClassMethod GetExportParth() As %String
{
	q $g(^DHCCLSet("AnOp","ExportParth"))
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-27
/// Description: 导入手术麻醉打印设置关联列数据
/// Table：^DHCCLSet
/// Input：
/// Return：
/// d 
ClassMethod Test() As %String
{
	//1.运行
	//d ##class(web.UDHCANOPSET).Test()
	s ^DHCCLSet("AnOp","PrnCol","Var",0)="58"
	s ^DHCCLSet("AnOp","PrnCol","Var",1)="开始日期^opdate"
	s ^DHCCLSet("AnOp","PrnCol","Var",2)="手术间^oproom"
	s ^DHCCLSet("AnOp","PrnCol","Var",3)="登记号^regno"
	s ^DHCCLSet("AnOp","PrnCol","Var",4)="病人姓名^patname"
	s ^DHCCLSet("AnOp","PrnCol","Var",5)="手术名称^opname"
	s ^DHCCLSet("AnOp","PrnCol","Var",6)="性别^sex"
	s ^DHCCLSet("AnOp","PrnCol","Var",7)="年龄^age"
	s ^DHCCLSet("AnOp","PrnCol","Var",8)="手术医师^opdoc"
	s ^DHCCLSet("AnOp","PrnCol","Var",9)="麻醉方法^anmethod"
	s ^DHCCLSet("AnOp","PrnCol","Var",10)="麻醉医师^andoc"
	s ^DHCCLSet("AnOp","PrnCol","Var",11)="器械护士^scrubnurse"
	s ^DHCCLSet("AnOp","PrnCol","Var",12)="巡回护士^circulnurse"
	s ^DHCCLSet("AnOp","PrnCol","Var",13)="手术包^oppack"
	s ^DHCCLSet("AnOp","PrnCol","Var",14)="科室^loc"
	s ^DHCCLSet("AnOp","PrnCol","Var",15)="序号^ordno"
	s ^DHCCLSet("AnOp","PrnCol","Var",16)="状态^status"
	s ^DHCCLSet("AnOp","PrnCol","Var",17)="类型^jzstat"
	s ^DHCCLSet("AnOp","PrnCol","Var",18)="特殊感染^yy"
	s ^DHCCLSet("AnOp","PrnCol","Var",19)="台次^opordno"
	s ^DHCCLSet("AnOp","PrnCol","Var",20)="术前诊断^diag"
	s ^DHCCLSet("AnOp","PrnCol","Var",21)="选择^SelItem"
	s ^DHCCLSet("AnOp","PrnCol","Var",22)="就诊号^adm"
	s ^DHCCLSet("AnOp","PrnCol","Var",23)="手术时间^opdatestr"
	s ^DHCCLSet("AnOp","PrnCol","Var",24)="手术申请时间^OpAppDateStr"
	s ^DHCCLSet("AnOp","PrnCol","Var",25)="手术要求^opmem"
	s ^DHCCLSet("AnOp","PrnCol","Var",26)="是否补充器械^isAddInstrument"
	s ^DHCCLSet("AnOp","PrnCol","Var",27)="器械^instrument"
	s ^DHCCLSet("AnOp","PrnCol","Var",28)="病区^patWard"
	s ^DHCCLSet("AnOp","PrnCol","Var",29)="麻醉护士^anNurse"
	s ^DHCCLSet("AnOp","PrnCol","Var",30)="住院号^medCareNo"
	s ^DHCCLSet("AnOp","PrnCol","Var",31)="手术间楼层^oprFloor"
	s ^DHCCLSet("AnOp","PrnCol","Var",32)="预计手术时间^estiOperDuration"
	s ^DHCCLSet("AnOp","PrnCol","Var",33)="术前讨论日期^preDiscussDate"
	s ^DHCCLSet("AnOp","PrnCol","Var",34)="是否体外循环^isExCirculation"
	s ^DHCCLSet("AnOp","PrnCol","Var",35)="血型^bloodType"
	s ^DHCCLSet("AnOp","PrnCol","Var",36)="手术编号^opSeqNote"
	s ^DHCCLSet("AnOp","PrnCol","Var",37)="手术医师备注^opDocNote"
	s ^DHCCLSet("AnOp","PrnCol","Var",38)="麻醉医师备注^anDocNote"
	s ^DHCCLSet("AnOp","PrnCol","Var",39)="合并疾病^anCompDesc"
	s ^DHCCLSet("AnOp","PrnCol","Var",40)="是否自体血回输^isUseSelfBlood"
	s ^DHCCLSet("AnOp","PrnCol","Var",41)="体位^operPosition"
	s ^DHCCLSet("AnOp","PrnCol","Var",42)="手术分类^OPCategory"
	s ^DHCCLSet("AnOp","PrnCol","Var",43)="特殊器械^operInstrument"
	s ^DHCCLSet("AnOp","PrnCol","Var",44)="麻醉会诊^NeedAnaesthetist"
	s ^DHCCLSet("AnOp","PrnCol","Var",45)="病人级别^patLevel"
	s ^DHCCLSet("AnOp","PrnCol","Var",46)="手术开始时间^opStaTime"
    s ^DHCCLSet("AnOp","PrnCol","Var",47)="手术结束时间^opEndTime"
    s ^DHCCLSet("AnOp","PrnCol","Var",48)="手术体位^operPosition"
    s ^DHCCLSet("AnOp","PrnCol","Var",49)="交巡回护士^sCirNurStr"
    s ^DHCCLSet("AnOp","PrnCol","Var",50)="巡回护士备注^cirNurNote"
	s ^DHCCLSet("AnOp","PrnCol","Var",51)="主诉^selfReport"
    s ^DHCCLSet("AnOp","PrnCol","Var",52)="手术预约资源^operResource"
    s ^DHCCLSet("AnOp","PrnCol","Var",53)="预约号^queueNo"
    s ^DHCCLSet("AnOp","PrnCol","Var",54)="手术预备耗材^operStock"
    s ^DHCCLSet("AnOp","PrnCol","Var",55)="预备耗材备注^operStockNote"
    s ^DHCCLSet("AnOp","PrnCol","Var",56)="手术备注/要求/病例摘要^opmem"
    s ^DHCCLSet("AnOp","PrnCol","Var",57)="病人电话^patTel"
    s ^DHCCLSet("AnOp","PrnCol","Var",58)="病案号^medCareNo"
}

Query FindGroupCanSeeDay() As %Query(ROWSPEC = "GroupId:%String,Group:%String,CanSeeDay:%String")
{
}

ClassMethod FindGroupCanSeeDayExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s rowId=""
 	f  s rowId = $o(^DHCCLC("GroupCanSeeDay",rowId)) q:rowId=""  d
	 	.s day = $g(^DHCCLC("GroupCanSeeDay",rowId))
	 	.s group = $P(^SSU("SSGRP",rowId),"^",1)
	 	.d OutPut
 	s qHandle=$lb(0,repid,0)
	q $$$OK
OutPut
 	s Data=$lb(rowId,group,day)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod FindGroupCanSeeDayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGroupCanSeeDayExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {			
 		s Row=^CacheTemp(repid,ind)
 		//w "<b>"_$List(Row,3)_"</b>"
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindGroupCanSeeDayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGroupCanSeeDayExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod InsertGroupDay(groupId As %String, day As %String) As %String
{
	q:groupId="" "安全组不能为空"
	s ^DHCCLC("GroupCanSeeDay",groupId)=day

		q "0"
}

ClassMethod UpdateGroupDay(groupId As %String, day As %String) As %String
{
		
	q:groupId="" "安全组不能为空"
	s ^DHCCLC("GroupCanSeeDay",groupId)=day

		q "0"
}

ClassMethod DeleteGroupDay(groupId As %String) As %String
{
	k ^DHCCLC("GroupCanSeeDay",groupId)
		 q "0"
}

ClassMethod GetGroupCanSeeDay(groupId)
{
	s day=""
	s day=$g(^DHCCLC("GroupCanSeeDay",groupId))
	q day
}

ClassMethod GetSpecGroupInitDate(userGroupId) As %String
{
 	s ret="",date=""
	s format=##class(websys.Conversions).DateFormat()
 	s canseeday=$g(^DHCCLC("GroupCanSeeDay",userGroupId))
 	i canseeday'="" s date=$h+canseeday
 	i date'="" s date=$ZD(date,format)
 	s ret=date
 	
	q ret
}

}
