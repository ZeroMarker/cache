Import SQLUSER

Class web.DHCANCOPCount Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 取手术器材敷料清点项目
/// Table：DHC_ANC_OPCount,DHC_ANC_OPCountType
/// Input：
/// Return：项目代码,项目描述,清点类型,项目ID,清点类型ID
/// d ##class(%ResultSet).RunQuery("web.DHCANCOPCount","FindOPCount","","","1")
Query FindOPCount(Code As %String = "", Desc As %String = "", Type As %String = "") As %Query(ROWSPEC = "OPCountCode:%String,OPCountDesc:%String,tOPCountType:%String,tOPCountId:%String,tOPCountTypeId:%String")
{
}

ClassMethod FindOPCountExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Type As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^DHCANC("OPC",RowId))  q:RowId=""  d
	.s OPCountCode=$p($g(^DHCANC("OPC",RowId)),"^",1)
	.q:(Code'="")&&(Code'=OPCountCode)
	.s OPCountDesc=$p($g(^DHCANC("OPC",RowId)),"^",2)
	.q:(Desc'="")&&(OPCountDesc'[Desc)
	.s tOPCountTypeId=$p($g(^DHCANC("OPC",RowId)),"^",3)
	.q:(Type'="")&&(Type'=tOPCountTypeId)
	.i tOPCountTypeId'="" s tOPCountType=$p($g(^DHCANC("OPCT",tOPCountTypeId)),"^",2)
	.e  s tOPCountType=""
	.s tOPCountId=RowId
	.d OutputRow  
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(OPCountCode,OPCountDesc,tOPCountType,tOPCountId,tOPCountTypeId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOPCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOPCountExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindOPCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOPCountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 比较手术器材敷料清点项目码表代码有无重复
/// Table：DHC_ANC_OPCount
/// Input：
/// Return：有重复返回Y,否则返回N
ClassMethod RepOPCount(Code As %String)
{
	s OPRowid=0
	s flag="N"
	s Code=$$ALPHAUP^SSUTIL4(Code)
	f  s OPRowid=$o(^DHCANC("OPC",OPRowid)) q:(OPRowid="")  d
	.s RCode=$p(^DHCANC("OPC",OPRowid),"^",1)
	.s RCode=$$ALPHAUP^SSUTIL4(RCode)
	.i (RCode=Code) s flag="Y"
	q flag
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 新加手术器材敷料清点项目码表数据
/// Table：DHC_ANC_OPCount
/// Input：
/// Return：成功返回0,否则返回非0
ClassMethod AddMethod(Code As %String, Desc As %String, OPCountTypeId As %String = "")
{
	q:(Code="")||(Desc="") -1
	s Code=$$ALPHAUP^SSUTIL4(Code)
	&SQL(insert into DHC_ANC_OPCount(ANCOPC_Code,ANCOPC_Desc,ANCOPC_CountType_Dr) Values (:Code,:Desc,:OPCountTypeId))
	q SQLCODE
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 修改手术器材敷料清点项目码表数据
/// Table：DHC_ANC_OPCount
/// Input：
/// Return：成功返回0,否则返回非0
ClassMethod UpdateMethod(OPCountId As %String, Code As %String, Desc As %String, OPCountTypeId As %String = "")
{
	q:(OPCountId="")||(Code="")||(Desc="") -1
	&SQL(update DHC_ANC_OPCount set ANCOPC_Code=:Code,ANCOPC_Desc=:Desc ,ANCOPC_CountType_Dr=:OPCountTypeId  where ANCOPC_RowId=:OPCountId)
	q SQLCODE
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 删除手术器材敷料清点项目码表数据
/// Table：DHC_ANC_OPCount
/// Input：
/// Return：成功返回0,否则返回非0
ClassMethod DeleteMethod(OPCountId As %String)
{
	q:OPCountId="" -1
	&SQL(Delete from DHC_ANC_OPCount where ANCOPC_RowId=:OPCountId)
	q SQLCODE
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 取手术器材敷料清点项目类型
/// Table：DHC_ANC_OPCountType
/// Input：
/// Return：清点类型代码,清点类型,清点类型ID
Query FindOPCountType(countTypeName As %String) As %Query(ROWSPEC = "TypeCode:%String,TypeDesc:%String,TypeId:%String")
{
}

ClassMethod FindOPCountTypeExecute(ByRef qHandle As %Binary, countTypeName As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^DHCANC("OPCT",RowId))  q:RowId=""  d
	.s TypeDesc=$p(^DHCANC("OPCT",RowId),"^",2)
	.s TypeCode=$p(^DHCANC("OPCT",RowId),"^",1)
	.s TypeId=RowId
	.i TypeDesc[countTypeName d OutputRow1 q
	.s TypeCode=$$ALPHAUP^SSUTIL4(TypeCode)
	.s countTypeName=$$ALPHAUP^SSUTIL4(countTypeName)
	.i TypeCode[countTypeName d OutputRow1 q
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(TypeCode,TypeDesc,TypeId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOPCountTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOPCountTypeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindOPCountTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOPCountTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 比较手术器材敷料清点类型代码有无重复
/// Table：DHC_ANC_OPCountType
/// Input：
/// Return：有重复返回Y,否则返回N
ClassMethod RepType(Code As %String)
{
	s OPRowid=0
	s flag="N"
	s Code=$$ALPHAUP^SSUTIL4(Code)
	f  s OPRowid=$o(^DHCANC("OPCT",OPRowid)) q:(OPRowid="")  d
	.s RCode=$p(^DHCANC("OPCT",OPRowid),"^",1)
	.s RCode=$$ALPHAUP^SSUTIL4(RCode)
	.i (RCode=Code) s flag="Y"
	q flag
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 新加手术器材敷料清点类型
/// Table：DHC_ANC_OPCountType
/// Input：
/// Return：成功返回0,否则返回非0
ClassMethod AddType(Code As %String, Desc As %String)
{
	q:(Code="")||(Desc="") -1
	&SQL(insert into DHC_ANC_OPCountType(ANCOPCT_Code,ANCOPCT_Desc) Values (:Code,:Desc))
	q SQLCODE
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 修改手术器材敷料清点类型
/// Table：DHC_ANC_OPCountType
/// Input：
/// Return：成功返回0,否则返回非0
ClassMethod UpdateType(TypeId As %String, Code As %String, Desc As %String)
{
	q:(TypeId="")||(Code="")||(Desc="") -1
	&SQL(update DHC_ANC_OPCountType set ANCOPCT_Code=:Code,ANCOPCT_Desc=:Desc where ANCOPCT_RowId=:TypeId)
	q SQLCODE
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 删除手术器材敷料清点类型
/// Table：DHC_ANC_OPCountType
/// Input：
/// Return：成功返回0,否则返回非0
ClassMethod DeleteType(TypeId As %String)
{
	q:TypeId="" -1
	&SQL(Delete from DHC_ANC_OPCountType where ANCOPCT_RowId=:TypeId)
	q SQLCODE
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 取手术器材敷料清点类型所选择的清点项目
/// Table：DHC_ANC_OPCountType
/// Input：TypeId:清点类型ID
/// Return：清点项目ID|清点项目描述
ClassMethod GetTypeSel(TypeId As %String)
{
	//w ##class(web.DHCANCOPCount).GetTypeSel("1")
	q:TypeId="" ""
	s DefItemStr=""
	s DefItem=$g(^DHCANC("OPCT",TypeId,"Default"))
	q:DefItem="" ""
	f i=1:1:$l(DefItem,"^") d
	.s DefItemId=$p(DefItem,"^",i)
	.q:DefItemId=""
	.s DefItemId=+DefItemId
	.s DefItemCode=$p($g(^DHCANC("OPC",DefItemId)),"^",1)
	.s DefItemDesc=$p($g(^DHCANC("OPC",DefItemId)),"^",2)
	.s DefItemDesc=$$ALPHAUP^SSUTIL4(DefItemCode)_"-"_DefItemDesc
	.i DefItemStr="" s DefItemStr=DefItemId_"|"_DefItemDesc
	.e  s DefItemStr=DefItemStr_"^"_DefItemId_"|"_DefItemDesc 
	q DefItemStr
}

/// 取所有清点项目
Query GetCountItem(countItemName As %String) As %Query(ROWSPEC = "ANCOPC_RowId:%Integer,ANCOPC_Desc:%String")
{
}

ClassMethod GetCountItemExecute(ByRef qHandle As %Binary, countItemName As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPAnOp("OPC",$j)
	s RowId=0	
	f  s RowId=$o(^DHCANC("OPC",RowId))  q:RowId=""  d
	.s OPCountCode=$p($g(^DHCANC("OPC",RowId)),"^",1)
	.s OPCountDesc=$p($g(^DHCANC("OPC",RowId)),"^",2)
	.;s tOPCountTypeId=$p($g(^DHCANC("OPC",RowId)),"^",3)
	.;i tOPCountTypeId'="" s tOPCountType=$p($g(^DHCANC("OPCT",tOPCountTypeId)),"^",2)
	.;e  s tOPCountType=""
	.s tOPCountId=RowId
	.s OPCountCode=$$ALPHAUP^SSUTIL4(OPCountCode)
	.s countItemName=$$ALPHAUP^SSUTIL4(countItemName)
	.q:(OPCountCode'[countItemName)&&(OPCountDesc'[countItemName)&&(countItemName'="")
	.s DefItemStr=$g(^DHCANC("OPCT",74,"Default"))
	.s ex=0
	.f i=1:1:$l(DefItemStr,"^") d
	..s DefItemId=$p(DefItemStr,"^",i)
	..q:DefItemId=""
	..s DefItemId=+DefItemId
	..i DefItemId=tOPCountId s ex=1
	.s tOPCountDesc=$$ALPHAUP^SSUTIL4(OPCountCode)_"-"_OPCountDesc
	.i ex=1 s ^TMPAnOp("OPC",$j,1,tOPCountId)=$lb(tOPCountId,tOPCountDesc) 
	.e  s ^TMPAnOp("OPC",$j,2,tOPCountId)=$lb(tOPCountId,tOPCountDesc) 
	.;d OutputRow
	s n=""
	f  s n=$o(^TMPAnOp("OPC",$j,n)) q:n=""  d
	.s countId=""  f  s countId=$o(^TMPAnOp("OPC",$j,n,countId)) q:countId=""  d
	..d OutputRow
	k ^TMPAnOp("OPC",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	;set OPCountDesc=OPCountCode_OPCountDesc
	;set OPCountCode=$$ALPHAUP^SSYTUK4(OPCountCode)
	;set Data=$lb(tOPCountId,OPCountDesc)
 	Set ^CacheTemp(repid,ind)=^TMPAnOp("OPC",$j,n,countId)
 	Set ind=ind+1
	quit
}

ClassMethod GetCountItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOPCountExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod GetCountItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOPCountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 保存所选清点项目
ClassMethod SaveTypeSel(TypeId As %String, DefItemStr As %String)
{
	//w ##class(web.DHCANCOPCount).SaveTypeSel("1","1")
	s oldDefItemStr=$g(^DHCANC("OPCT",TypeId,"Default"))

	s newCount=$length(DefItemStr,"^")
	s oldCount=$length(oldDefItemStr,"^")
	s num=""
	s i=1 f i=1:1:oldCount d
	.s oldItemId=$p($p(oldDefItemStr,"^",i),"!",1)
	.s num=$p($p(oldDefItemStr,"^",i),"!",2)
	.i num=""  s num=0
	.s ^TMPDEBUG("DTJ",i)=num
	.s j=1 f j=1:1:newCount d
	..s newItemId=$p($p(DefItemStr,"^",j),"!",1)
	..q:newItemId'=oldItemId
	..b
	..s itemStr=$p(DefItemStr,"^",j)
	..s $p(itemStr,"!",2)=num
	..s $p(DefItemStr,"^",j)=itemStr
	
	s ^DHCANC("OPCT",TypeId,"Default")=DefItemStr
	q "保存成功!"
}

ClassMethod Clear(opaId As %String)
{
	//s ^TMPDEBUG("dtj","Clear")=opaId
	q:opaId="" "未选中手术"
	k ^DHCANOPArrange(opaId,"OPCount")
	q 1
}

/// Creator: zhangtao
/// CreatDate: 2011-10-11
/// Description: 取手术器材敷料清点类型所选项目
/// Table：DHC_AN_OPArrange,DHC_ANC_OPCount,DHC_ANC_OPCountType
/// Input：CountTypeId:清点类型ID,OpaId:手术申请ID
/// Return：器械名称,术前清点数,术中加数,关前清点数,关后清点数,器械ID,项目ID
Query FindPackageItem(opaId As %String) As %Query(ROWSPEC = "anOPCPackageNo:%String")
{
}

ClassMethod FindPackageItemExecute(ByRef qHandle As %Binary, opaId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if opaId=""	Set qHandle=$lb(0,repid,0) Quit $$$OK
	k ^TMPPaNo($j)
	s ANOPCSub=0
	f  s ANOPCSub=$o(^DHCANOPArrange(opaId,"OPCount",ANOPCSub))  q:ANOPCSub=""  d
	.s anOPCPackageNo=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",7)
	.q:anOPCPackageNo=""
	.s ^TMPPaNo($j,anOPCPackageNo)=anOPCPackageNo
	s paNo="" f  s paNo=$o(^TMPPaNo($j,paNo)) q:paNo=""  d
	.s anOPCPackageNo=^TMPPaNo($j,paNo)
	.d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(anOPCPackageNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPackageItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPackageItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindPackageItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPackageItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 取手术器材敷料清点类型所选项目
/// Table：DHC_AN_OPArrange,DHC_ANC_OPCount,DHC_ANC_OPCountType
/// Input：CountTypeId:清点类型ID,OpaId:手术申请ID
/// Return：器械名称,术前清点数,术中加数,关前清点数,关后清点数,器械ID,项目ID
/// d ##class(%ResultSet).RunQuery("web.DHCANCOPCount","FindTypeSel","","100","")
Query FindTypeSel(CountTypeId As %String, opaId As %String, paNo As %String) As %Query(ROWSPEC = "OPCountDesc:%String,tOriginalNum:%String,tPreOperNum:%String,tAddNum:%String,tUnSewNum:%String,tSewedNum:%String,tSkinSewedNum:%String,OPCountId:%String,tANOPCId:%String,tSelfDefine:%String,tScanPackageNo:%String,tScanPackageItemId:%String,tPackageName:%String,tNote:%String,tConditon:%String,tConditonDesc:%String,tGuiGe")
{
}

ClassMethod FindTypeSelExecute(ByRef qHandle As %Binary, CountTypeId As %String, opaId As %String, anOPCPackageNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^TMPCCQ("ANOPCount")=CountTypeId_"^"_opaId_"^"_anOPCPackageNo
	;s opaId=188822
	if opaId=""	Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ANOPCSub=0
	f  s ANOPCSub=$o(^DHCANOPArrange(opaId,"OPCount",ANOPCSub))  q:ANOPCSub=""  d
	.s OPCountId=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",1)
	.s ANOPCINCIDr=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",8)
	.
	.s typeId=$p($g(^DHCANOPArrange(opaId,"OPCount",ANOPCSub)),"^",9)
	.i typeId'="" s typeDesc=$p($g(^DHCANC("OPCT",typeId)),"^",2)
	.e  s typeDesc=""
	.
	.q:(OPCountId="")&(ANOPCINCIDr="")
	.i OPCountId'="" d
	..s OPCountDesc=$p($g(^DHCANC("OPC",OPCountId)),"^",2)
	..q:OPCountDesc=""
	..s OPCountCode=$p($g(^DHCANC("OPC",OPCountId)),"^",1)
	..s tSelfDefine=""
	..i OPCountCode="Define" d
	...s OPCountDesc=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",6)
	...s tSelfDefine="Y"
	.i ANOPCINCIDr'="" d
	..//s OPCountDesc=$p($g(^INCI(ANOPCINCIDr,1)),"^",2)
	..s OPCountDesc=$lg(^User.CSSDItemD(ANOPCINCIDr),2)
	..s OPCountDesc=$p(OPCountDesc,"-",2)
	..//s OPCountCode=$p($g(^INCI(ANOPCINCIDr,1)),"^",1)
	..s OPCountCode=$lg(^User.CSSDItemD(ANOPCINCIDr),1)
	..s tSelfDefine="包号"
	.s opaPackageNo=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",7) 
	
	.i opaPackageNo'="" s tScanPackageNo=opaPackageNo ;dtj 2012-04-18
	.e  s tScanPackageNo=""
	.s guige=""
	.s tScanPackageItemId=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",8) ;dtj 2012-04-18
	.i tScanPackageItemId'="" s guige=$lg(^User.CSSDItemD(tScanPackageItemId),3)
	.q:(anOPCPackageNo'="")&(anOPCPackageNo'=opaPackageNo)
	.s tPreOperNum=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",2)
	.s tAddNum=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",3)
	.s tUnSewNum=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",4)
	.s tSewedNum=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",5)
	.s tOriginalNum=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",10)
	.s tNote=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",6)
	.s tConditon=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",11)
	.s tSkinSewedNum=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",12)
	.s:tConditon="Y" tConditonDesc="是"
	.s:tConditon="N" tConditonDesc="否"
	.s tANOPCId=opaId_"||"_ANOPCSub
	.d OutputRow2
	
	//首次填写时,可选择清点类型
	i CountTypeId'="",$o(^DHCANOPArrange(opaId,"OPCount",0))="" d
	.s DefItem=$g(^DHCANC("OPCT",CountTypeId,"Default"))
	.q:DefItem=""
	.f i=1:1:$l(DefItem,"^") d
	..s OPCountStr=$p(DefItem,"^",i)
	..s OPCountId=$p(OPCountStr,"!",1)
	..q:OPCountId=""
	..s OPCountDesc=$p(^DHCANC("OPC",OPCountId),"^",2)
	..s tOriginalNum=$p(OPCountStr,"!",2)
	..s tPreOperNum="" 
	..s tAddNum=""
	..s tUnSewNum=""
	..s tSewedNum=""
	..s tSkinSewedNum=""
	..s tANOPCId=""
	..s tSelfDefine=""
	..s guige=""
	..d OutputRow2 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set tPackageName=""  //..GetPackageNameByLabel(tScanPackageNo)
	if tPackageName="" s tPackageName=typeDesc
	
	set Data=$lb(OPCountDesc,tOriginalNum,tPreOperNum,tAddNum,tUnSewNum,tSewedNum,tSkinSewedNum,OPCountId,tANOPCId,tSelfDefine,tScanPackageNo,tScanPackageItemId,tPackageName,tNote,tConditon,tConditonDesc,guige)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTypeSelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTypeSelExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindTypeSelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTypeSelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 比较手术器材敷料清点项目有无重复
/// Table：DHC_AN_OPCount
/// Input：CountId:器械ID, opaId:手术申请ID
/// Return：有重复返回Y,否则返回N
ClassMethod RepCountItem(CountId As %String, opaId As %String)
{
	q:(opaId="")!(CountId="") ""
	s OPCountCode=$p(^DHCANC("OPC",CountId),"^",1)
	q:OPCountCode="Define" "N"	
	s ANOPCSub=0
	s flag="N"
	f  s ANOPCSub=$o(^DHCANOPArrange(opaId,"OPCount",ANOPCSub))  q:ANOPCSub=""  d
	.s OPCountId=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",1)
	.i OPCountId=CountId s flag="Y"
	q flag
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 新加手术器材敷料清点项目
/// Table：DHC_AN_OPCount
/// Input：CountId:器械ID(自定义项为Y时为描述), opaId:手术申请ID,PreOperNum:术前清点数,AddNum:术中加数,UnSewNum:关前清点数,SewedNum:关后清点数,SkinSewedNum:缝皮后清点数,SelfDefine:自定义项目(Y/N),Note:自定义项目内容
/// Return：成功返回0,否则返回非0
/// d ##Class(web.DHCANCOPCount).AddCount
ClassMethod AddCount(CountId As %String, opaId As %String, OriginalNum As %String = "", PreOperNum As %String = "", AddNum As %String = "", UnSewNum As %String = "", SewedNum As %String = "", SkinSewedNum As %String = "", SelfDefine As %String = "", Note As %String = "")
{
	s ^top(123)=CountId_"^"_opaId_"^"_OriginalNum_"^"_PreOperNum_"^"_AddNum_"^"_UnSewNum_"^"_SewedNum_"^"_SelfDefine_"^"_Note
	q:((CountId="")&(SelfDefine'="Y"))||(opaId="") -1
	if (SelfDefine="Y"){
		s CountId=$O(^DHCANC("OPC",0,"Code","Define",""))
		q:CountId="" -1
		&SQL(insert into DHC_AN_OPCount (ANOPC_Parref,ANOPC_OPCount_Dr,ANOPC_OriginalNum,ANOPC_PreOperNum,ANOPC_AddNum,ANOPC_UnSewNum,ANOPC_SewedNum,ANOPC_SkinSewedNum,ANOPC_Note) Values (:opaId,:CountId,:OriginalNum,:PreOperNum,:AddNum,:UnSewNum,:SewedNum,:SkinSewedNum,:Note))
	}
	else {
		&SQL(insert into DHC_AN_OPCount (ANOPC_Parref,ANOPC_OPCount_Dr,ANOPC_OriginalNum,ANOPC_PreOperNum,ANOPC_AddNum,ANOPC_UnSewNum,ANOPC_SewedNum,ANOPC_SkinSewedNum) Values (:opaId,:CountId,:OriginalNum,:PreOperNum,:AddNum,:UnSewNum,:SewedNum,:SkinSewedNum))
	}
	q SQLCODE_"^"_%ROWID
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 修改手术器材敷料清点项目
/// Table：DHC_AN_OPCount
/// Input：CountId:器械ID(自定义项为Y时为描述), ANOPCId:器械敷料清点表ID,PreOperNum:术前清点数,AddNum:术中加数,UnSewNum:关前清点数,SewedNum:关后清点数,SkinSewedNum:缝皮后清点数,SelfDefine:自定义项目(Y/N),Note:自定义项目内容
/// Return：成功返回0,否则返回非0
ClassMethod UpdateCount(CountId As %String, ANOPCId As %String, OriginalNum As %String = "", PreOperNum As %String = "", AddNum As %String = "", UnSewNum As %String = "", SewedNum As %String = "", SkinSewedNum As %String = "", SelfDefine As %String = "", Note As %String = "", IfConditon As %String = "")
{
	q:ANOPCId="" -1
	if (SelfDefine="Y")
	{
		s CountId=$O(^DHCANC("OPC",0,"Code","Define",""))
		q:CountId="" -1
		&SQL(update DHC_AN_OPCount set ANOPC_OPCount_Dr=:CountId,ANOPC_OriginalNum=:OriginalNum,ANOPC_PreOperNum=:PreOperNum ,ANOPC_AddNum=:AddNum,ANOPC_UnSewNum=:UnSewNum,ANOPC_SewedNum=:SewedNum,ANOPC_SkinSewedNum=:SkinSewedNum,ANOPC_Note=:Note,ANOPC_Conditon=:IfConditon where ANOPC_RowId=:ANOPCId)
	}
	else 
	{		
		&SQL(update DHC_AN_OPCount set ANOPC_OPCount_Dr=:CountId,ANOPC_OriginalNum=:OriginalNum,ANOPC_PreOperNum=:PreOperNum ,ANOPC_AddNum=:AddNum,ANOPC_UnSewNum=:UnSewNum,ANOPC_SewedNum=:SewedNum,ANOPC_SkinSewedNum=:SkinSewedNum,ANOPC_Note=:Note,ANOPC_Conditon=:IfConditon where ANOPC_RowId=:ANOPCId)
	}
	
	q SQLCODE
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 删除手术器材敷料清点项目
/// Table：DHC_AN_OPCount
/// Input：strId:器械敷料清点表ID
/// Return：成功返回0,否则返回非0
ClassMethod DeleteCount(strId As %String)
{
	q:strId="" -1
	s SQLCODE=-2
	TStart
	f i=1:1:$l(strId,"/") d
	.s ANOPCId=$p(strId,"/",i)
	.q:ANOPCId=""
	.&SQL(Delete from DHC_AN_OPCount where ANOPC_RowId=:ANOPCId)
	.i SQLCODE'=0 TRollBack  q
	q:SQLCODE -2
	Tcommit
	q SQLCODE
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 插入清点类型所对应的默认清点项目
/// Table：DHC_AN_OPCount
/// Input：CountTypeId:清点类型ID,OpaId:手术申请ID
/// Return：成功返回0,否则返回非0
ClassMethod InsertDefCountItem(CountTypeId As %String, OpaId As %String)
{
	q:(CountTypeId="")!(OpaId="") 0
	;q:$o(^DHCANOPArrange(OpaId,"OPCount",0))'="" 0 有清点项则不添加
	s isAddType="N"
    s ANOPCSub=0
    f  s ANOPCSub=$o(^DHCANOPArrange(OpaId,"OPCount",ANOPCSub)) q:ANOPCSub=""  d
    .i CountTypeId=$p($g(^DHCANOPArrange(OpaId,"OPCount",ANOPCSub)),"^",9) d
    ..s isAddType="Y" 
    .e  q
    q:isAddType="Y" "这个手术包已添加"
    
	s err=0
	s DefItem=$g(^DHCANC("OPCT",CountTypeId,"Default"))
	q:DefItem="" 0
	f i=1:1:$l(DefItem,"^")  d  q:SQLCODE'=0
	.s OPCountStr=$p(DefItem,"^",i)
	.s OPCountId=$p(OPCountStr,"!",1)
	.q:OPCountId=""
	.s OriginalNum=$p(OPCountStr,"!",2)
	.s PreOperNum=OriginalNum   //取demo中事前维护的初始数量  YuanLin 20170830
	.s AddNum=0
	.s UnSewNum=PreOperNum
	.s SewedNum=PreOperNum
	.s SkinSewedNum=PreOperNum
	.&SQL(insert into DHC_AN_OPCount (ANOPC_Parref,ANOPC_OPCount_Dr,ANOPC_OriginalNum,ANOPC_PreOperNum,ANOPC_AddNum,ANOPC_UnSewNum,ANOPC_SewedNum,ANOPC_SkinSewedNum,ANOPC_OPCountType_Dr) 
		Values (:OpaId,:OPCountId,:OriginalNum,:PreOperNum,:AddNum,:UnSewNum,:SewedNum,:SkinSewedNum,:CountTypeId))
	.i SQLCODE'=0 s err=SQLCODE q
	q err
}

/// Creator: zhangtao
/// CreatDate: 2011-10-09
/// Description: 插入消毒包所包含的消毒器械清点项目
/// Table：DHC_AN_OPCount
/// Input：cssdPackegId:消毒包ID,OpaId:手术申请ID
/// Return：成功返回0,否则返回非0
/// w ##class(web.DHCANCOPCount).InsertCSSDPackegItem("001002001000040",190)
ClassMethod InsertCSSDPackegItem(anOPCPackageNo As %String, opaId As %String) As %String
{
	q:(anOPCPackageNo="")!(opaId="") "消毒包号或手术记录为空"
	k ^TMPSort("OPCount",$j)
	s ANOPCSub=0,qFlag=0,opIdFlag=0
	f  s ANOPCSub=$o(^DHCANOPArrange(opaId,"OPCount",ANOPCSub))  q:ANOPCSub=""  d
	.s opaPackageNo=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",7)
	.i opaPackageNo=anOPCPackageNo s qFlag=1
	q:qFlag=1 "该手术已存在此消毒包"
	s opId="" f  s opId=$o(^DHCANOPArrange(opId))  q:opId=""  d
	.s opIdSub=0 f  s opIdSub=$o(^DHCANOPArrange(opId,"OPCount",opIdSub))  q:opIdSub=""  d
	..s opIdPackageNo=$p(^DHCANOPArrange(opId,"OPCount",opIdSub),"^",7)
	..i opIdPackageNo=anOPCPackageNo s opIdFlag=1
	q:opIdFlag=1 "该此消毒包已被其他病人绑定"
	s adm=$P(^DHCANOPArrange(opaId),"^",1) //7555
	s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	s opdrStr="",i=0,scnDr="",cirDr=""
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
	.s i=i+1
	.s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)
	.i opdrStr="" s opdrStr=opdr
	.e  s opdrStr=opdrStr_"^"_opdr
	.q:i>1
	.s docdr=$P($g(^OR(adm,"ANA",chl,"OP",subchl)),"^",8) 
	.s operLocId=$P($g(^OR(adm,"ANA",chl,"OP",subchl)),"^",10) 		;ANAOP_CTLOC_DR
	.s p=0  ;洗手
	.s scnId=0 f  s scnId=$O(^OR(adm,"ANA",chl,"OP",subchl,"SCN",scnId)) q:(scnId="")!(p=1)  d
	..q:scnId>20
	..s scnDr=$P(^OR(adm,"ANA",chl,"OP",subchl,"SCN",scnId),"^",1)
	..q:scnDr=""
	..s p=p+1
	.s p=0  ;巡回
	.s cirId=0 f  s cirId=$O(^OR(adm,"ANA",chl,"OP",subchl,"CIRN",cirId)) q:(cirId="")!(p=1)   d
	..q:cirId>20
	..s cirDr=$P(^OR(adm,"ANA",chl,"OP",subchl,"CIRN",cirId),"^",1)
	..q:cirDr=""
	..s p=p+1 
	s yg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",29)						//OPA_PATestHBsAg  	免疫乙肝表面抗原
	s bg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",34)						//OPA_PATestHCVAb 	免疫丙型肝炎抗体
	s az=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",35)						//OPA_PATestHivAb 	免疫艾滋病毒抗体
	s md=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",36)						//OPA_PATestTPAb 	免疫梅毒
	s PATestOther=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",2)				//OPA_PATestOther	检其它阴阳性
	s infectName=""
	i yg="阳性" s infectName="乙肝阳性"_" "
	i bg="阳性" s infectName=infectName_"丙肝阳性"_" "
	i az="阳性" s infectName=infectName_"艾滋病阳性"_" "
	i md="阳性" s infectName=infectName_"梅毒阳性"_" "
	i PATestOther="阳性" s infectName=infectName_"其他阳性"_" "
	//s nurUserId=%session.Data("LOGON.USERID")
	s nurUserId=4636
	s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	s patname=""
	s admId=$P(^DHCANOPArrange(opaId),"^",1)
	s papmiId=$p($g(^PAADM(admId)),"^",1)
	s patname=$p($g(^PAPER(papmiId,"ALL")),"^",1)

	s dateTime=+$h
	s uCssdFlag=##class(web.CSSDTransOP).InsertRec(anOPCPackageNo,nurUserId,dateTime,adm,opaId,opdrStr,infectName,docdr,oproomdr,scnDr,cirDr,patname)
	i uCssdFlag'=0 q "更新消毒供应接口错误"_uCssdFlag
	
	//修改消供接口 YuanLin 20170901
	s err=0
	s lblength=$l(anOPCPackageNo)
	q:(lblength'=15) "消毒包条码不对!应为15位条码号"
	s lb=$e(anOPCPackageNo,1,9)
	s packageDr=""
	&sql(SELECT CSSDCD_PackDR into:packageDr FROM sqluser.cssd_codedict WHERE CSSDCD_Code=:lb)
	q:packageDr="" "不存在此消毒包"
	s id="" f  s id=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",packageDr,id)) q:id=""  d
	.s objPackageItem=""
	.s objPackageItem=##class(User.CSSDPackageItem).%OpenId(id)
	.q:objPackageItem=""
	.s itmDr=objPackageItem.CSSDPIItmDR.%Id()
	.q:itmDr=""
	.s itmDesc=objPackageItem.CSSDPIItmDR.CSSDIDesc
	.s qty=objPackageItem.CSSDPIQty
    .s ^TMPSort("OPCount",$j,anOPCPackageNo,id)=itmDesc_"^"_qty_"^"_itmDr
    s rowId=""  f  s rowId=$o(^TMPSort("OPCount",$j,anOPCPackageNo,rowId)) q:rowId=""  d
    .s str=^TMPSort("OPCount",$j,anOPCPackageNo,rowId)
    .s OriginalNum=$p(str,"^",2)
    .s ANOPCINCIDr=$p(str,"^",3)
	.s PreOperNum=OriginalNum
	.s AddNum=0
	.s UnSewNum=PreOperNum
	.s SewedNum=PreOperNum
	.s SkinSewedNum=PreOperNum
	.&SQL(insert into DHC_AN_OPCount (ANOPC_Parref,ANOPC_OriginalNum,ANOPC_PreOperNum,ANOPC_AddNum,ANOPC_UnSewNum,ANOPC_SewedNum,ANOPC_SkinSewedNum,ANOPC_PackageNo,ANOPC_INCI_Dr) 
		Values (:opaId,:OriginalNum,:PreOperNum,:AddNum,:UnSewNum,:SewedNum,:SkinSewedNum,:anOPCPackageNo,:ANOPCINCIDr))
	.i SQLCODE'=0 s err=SQLCODE q
	k ^TMPSort("OPCount",$j)
	q err
}

/// Creator: wulingling
/// CreatDate: 2013-08-09
/// Description: 清除插入消毒包所包含的消毒器械清点项目的数量
/// Table：DHC_AN_OPCount
/// Input：cssdPackegId:消毒包ID
/// Return：成功返回0,否则返回非0
/// w ##class(web.DHCANCOPCount).ClearAllItemNum("39")
ClassMethod ClearAllItemNum(opaId As %String, anOPCPackageNo As %String = "")
{
	q:opaId="" -1
	s ret=0
	s ANOPCSub=0
	f  s ANOPCSub=$o(^DHCANOPArrange(opaId,"OPCount",ANOPCSub))  q:ANOPCSub=""  d
	.s opaPackageNo=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",7)
	.q:(anOPCPackageNo'="")&(anOPCPackageNo'=opaPackageNo)
	.&SQL(update DHC_AN_OPCount set ANOPC_OriginalNum=0 where ANOPC_Parref=:opaId)
	.i SQLCODE'=0 s ret=SQLCODE q
	q ret
}

/// Creator: wangxinlei
/// CreatDate: 2010-06-04
/// Description: 取手术器材敷料清点类型所选择的清点项目的默认值
/// Table：DHC_ANC_OPCountType
/// Input：TypeId:清点类型ID
/// Return：OPCountDesc,PreOperNum,AddNum,UnSewNum,SewedNum,SeqNo
/// 		器材名称,术前清点数,术中加数,
Query FindTypeSelDefVal(TypeId As %String) As %Query(ROWSPEC = "SeqNo,OPCountDesc,OriginalNum,OPCountId")
{
}

ClassMethod FindTypeSelDefValExecute(ByRef qHandle As %Binary, TypeId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if TypeId'="" {
		s DefItemArr=$g(^DHCANC("OPCT",TypeId,"Default"))
	}
	else {
		s DefItemArr=""
	}
	if DefItemArr=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
	f i=1:1:$l(DefItemArr,"^") d
	.s DefItemStr=$p(DefItemArr,"^",i)
	.q:DefItemStr=""
	.s SeqNo=i
	.s OPCountId=$p(DefItemStr,"!",1)
	.i OPCountId'="" s OPCountDesc=$p($g(^DHCANC("OPC",OPCountId)),"^",2)
	.e  s OPCountDesc=""
	.s OriginalNum=$p(DefItemStr,"!",2)
	.d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(SeqNo,OPCountDesc,OriginalNum,OPCountId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTypeSelDefValFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTypeSelDefValExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindTypeSelDefValClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTypeSelDefValExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 保存所选清点器材的默认值
ClassMethod SaveTypeSelDefVal(TypeId As %String, SeqNo As %String, para As %String)
{
	q:(TypeId="")!(SeqNo="") "所选清点类型或清点器材为空!"
	s $P(^DHCANC("OPCT",TypeId,"Default"),"^",SeqNo)=para
	q "保存成功!"
}

/// dyl+旧版他们更新的时候缺少这个+20150804
Query FindTypeSelect(TypeId As %String) As %Query(ROWSPEC = "SeqNo,DefItemCode,DefItemDesc,OPCountId")
{
}

ClassMethod FindTypeSelectExecute(ByRef qHandle As %Binary, TypeId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if TypeId'="" {
		s DefItemArr=$g(^DHCANC("OPCT",TypeId,"Default"))
	}
	else {
		s DefItemArr=""
	}
	if DefItemArr=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
	f i=1:1:$l(DefItemArr,"^") d
		.s DefItemStr=$p(DefItemArr,"^",i)
		.q:DefItemStr=""
		.s SeqNo=i
		.s OPCountId=$p(DefItemStr,"!",1)
		.i OPCountId'="" d
		..s OPCountCode=$p($g(^DHCANC("OPC",OPCountId)),"^",1)
		..s OPCountDesc=$p($g(^DHCANC("OPC",OPCountId)),"^",2)
		.e  s OPCountDesc="",OPCountCode=""
		.s OriginalNum=$p(DefItemStr,"!",2)
		.d OutputRowCT
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCT
	set Data=$lb(SeqNo,OPCountCode,OPCountDesc,OPCountId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTypeSelectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTypeSelectExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindTypeSelectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTypeSelectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator: YuanLin
/// CreatDate: 2017-09-12
/// Description: 取病人名下所绑定的无菌包的灭菌信息
/// Input：opaId
/// Return：无菌包名称 无菌包灭菌时间 无菌包失效时间 无菌包是否合格
/// d ##class(%ResultSet).RunQuery("web.DHCANCOPCount","FindSterExpByLabel","133")
Query FindSterExpByLabel(opaId) As %Query(ROWSPEC = "PackDesc,SterilizingDate,SterilizingTime,ExpiredDate,ExpiredTime,QualifiedDesc")
{
}

ClassMethod FindSterExpByLabelExecute(ByRef qHandle As %Binary, opaId) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s label=""
	s labelList=""
	s dateformatnum=##class(websys.Conversions).DateFormat()
	s ANOPCSub=0 f  s ANOPCSub=$o(^DHCANOPArrange(opaId,"OPCount",ANOPCSub))  q:ANOPCSub=""  d
	.s label=$p(^DHCANOPArrange(opaId,"OPCount",ANOPCSub),"^",7)
	.q:(label="")
	.q:((label'="")&&(labelList[label))   //查重
	.s labelList=labelList_"^"_label
	.s id="" f  s id=$o(^User.CSSDTransI("CSSDTLabel",label,id)) q:id=""  d
	..s transObj=""
	..s transObj=##Class(User.CSSDTrans).%OpenId(id)
	..s PackDesc=transObj.CSSDTPackage.CSSDPDesc
	..s ExpiredDate=$list(^User.CSSDTransD(id),12)
	..q:(ExpiredDate="")
	..s ExpiredDate=$zd(ExpiredDate,dateformatnum)
	..s SterilizingDate=$list(^User.CSSDTransD(id),20)
	..q:(SterilizingDate="")
	..s SterilizingDate=$zd(SterilizingDate,dateformatnum)
	..s SterilizingTime=$zt($list(^User.CSSDTransD(id),21),1)
	..s ExpiredTime=$zt($list(^User.CSSDTransD(id),21),1)	 //同
	..s nowdate=$zd($p($h,",",1),3)
	..s day=$list(^User.CSSDTransD(id),12)-$p($h,",",1)
	..i day>0 d
	...s QualifiedDesc="否"
	..e  d
	...s QualifiedDesc="是"
	..do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(PackDesc,SterilizingDate,SterilizingTime,ExpiredDate,ExpiredTime,QualifiedDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSterExpByLabelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSterExpByLabelExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindSterExpByLabelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSterExpByLabelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCANCOPCount).CheckPackValid("12452014012200001")
ClassMethod CheckPackValid(anOPCPackageNo)
{
	/*
	s CSSDPackId=##class(web.CSSDTransOP).GetPackId(anOPCPackageNo)
	s ret=0
	q:$d(^User.CSSDTransD(CSSDPackId))<1
	s packageTo=$li(^User.CSSDTransD(CSSDPackId),12)
	i packageTo<+$h set ret=1
	q ret
	*/
	s ret=0
	&sql(select CSSDT_ExpDate ,CSSDT_Status into :CSSDTExpDate, :cssstat from SQLUser.CSSD_Trans where CSSDT_Label=:anOPCPackageNo)
	i SQLCODE'=0 s ret="该消毒包没有相关记录,尚未进行灭菌发放或接收"
	e  d
	.s packageTo=CSSDTExpDate
	.i packageTo<+$h set ret="该消毒包已过期"
	.i cssstat'="R" set ret="该消毒包未接收"
		q ret
}

/*

/// 通过扫描扫码查找包号名
ClassMethod GetPackageNameByLabel(scanPackageLabel As %String) As %String
{
	k PLIST
	s scanPackageLabel=$E(scanPackageLabel,1,9)
	&SQL(select CSSDCD_PackName into :PLIST() from cssd_codedict where  CSSDCD_Code=:scanPackageLabel)
	s packageName=$g(PLIST(4))
	q packageName
}
*/
Query FindCSSDPack() As %Query(ROWSPEC = "CssdId,CssdPack")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCANCOPCount","FindCSSDPack")
ClassMethod FindCSSDPackExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s cssdId=""
	f  s cssdId=$o(^User.CSSDPackageD(cssdId)) q:cssdId=""  d
		.s cssdpack=$li(^User.CSSDPackageD(cssdId),5)
		.i $l(cssdpack,"-")>1 s cssdpack=$p(cssdpack,"-",2)
		.Do Output
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	s data=$lb(cssdId,cssdpack)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	quit
}

ClassMethod FindCSSDPackFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCSSDPackExecute ]
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

ClassMethod FindCSSDPackClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCSSDPackExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
