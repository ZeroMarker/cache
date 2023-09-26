Import SQLUser

Class web.DHCWMRDictionaryCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 69;

ClassMethod Update(InString)
{
	//***************************************
	//功能说明：添加或修改字典项(添加数据时WMRRowid设空值)
	//入参：WMRRowid^DictionaryName^Code^Description^FromDate^ToDate^TextA^TextB^TextC^TextD^IsActive^ResumeText
	//出参：-1/SQLCODE/WMRRowid
	//调试：w ##class(web.DHCWMRDictionaryCtl).Update("入参")
	//*****************************************
	n (InString)  
    s WMRRowid=$p(InString,"^",1)
    s PLIST(2)=$p(InString,"^",2)      ;字典类别
    q:PLIST(2)="" -1                
    s PLIST(3)=$p(InString,"^",3)      ;代码
    q:PLIST(3)="" -1                
    s PLIST(4)=$p(InString,"^",4)      ;描述                
    s:$p(InString,"^",5)'="" PLIST(5)=$zdh($p(InString,"^",5),3)      ;起始日期         
    s:$p(InString,"^",6)'="" PLIST(6)=$zdh($p(InString,"^",6),3)      ;截止日期                       
    s PLIST(7)=$p(InString,"^",7)      ; 
    s PLIST(8)=$p(InString,"^",8)      ;            
    s PLIST(9)=$p(InString,"^",9)      ;            
    s PLIST(10)=$p(InString,"^",10)    ;            
    s PLIST(11)=$s($p(InString,"^",11)["Y":"Y",1:"N")  ;有效标记
    s PLIST(12)=$p(InString,"^",12)    ;备注
    q:($d(^DHCWMRDIC("0","DicNameCode",PLIST(2),PLIST(3))))&(WMRRowid="") -100
    i WMRRowid="" d
    .&sql(Insert into DHC_WMR_Dictionary values :PLIST())
    e  d
    .&sql(Update DHC_WMR_Dictionary values :PLIST() where Rowid=:WMRRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod InitStaID() As %String
{
	;k ^DHCWMRDIC
	Set MaxID=500
	Set MID=$O(^DHCWMRDIC(""),-1)
	Set:MID'="" MaxID=MaxID+1
	Set ^mdata("DHCWMRDICTIONARY")=MID	
	Quit 1
}

ClassMethod ImportDictionaryData(InString) As %String
{
	New (InString)
	Set ^Test=InString
	Set Rtn=..Update(InString)
	Quit Rtn
}

ClassMethod GetDataById(WMRRowid)
{
	//***************************************
	//功能说明：根据WMRRowid获取字典项
	//入参：WMRRowid
	//出参：WMRRowid^DictionaryName^Code^Description^FromDate^ToDate^TextA^TextB^TextC^TextD^IsActive^ResumeText
	//调试：w ##class(web.DHCWMRDictionaryCtl).GetDataById("WMRRowid")
	//*****************************************
	
    n (WMRRowid)
    
    q:+WMRRowid=0 ""
    q:'$d(^DHCWMRDIC(WMRRowid)) ""
    s s=$g(^DHCWMRDIC(WMRRowid))
    s:$p(s,"^",4)'="" $p(s,"^",4)=$zd($p(s,"^",4),3)
    s:$p(s,"^",5)'="" $p(s,"^",5)=$zd($p(s,"^",5),3)
    s s=WMRRowid_"^"_s
    q s
}

ClassMethod QueryByTypeFlagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByTypeFlagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryByTypeFlagExecute(ByRef qHandle As %Binary, Type As %String, Flag As %String) As %Status
{
	//***************************************
	//功能说明：根据类型和有效标记查询字典项记录集
	//入参：DictionaryName,IsActive
	//出参：WMRRowid^DictionaryName^Code^Description^FromDate^ToDate^TextA^TextB^TextC^TextD^IsActive^ResumeText
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRDictionaryCtl","QueryByTypeFlag","DictionaryName","IsActive")
	//*****************************************
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
    s iCount=$$QueryByTypeFlag(Type,Flag)
    s JIndex=$p(iCount,"^",2),iCount=+iCount
	q:iCount<0 $$$OK
	f i=0:1:iCount d
	.s s=$g(^CacheTemp("DQueryByTypeFlag",JIndex,i))
	.d BuildData

	Quit $$$OK
QueryByTypeFlag(Type,Flag)
    n (Type,Flag)
    k ^CacheTemp("DQueryByTypeFlag",$j)
    
    s:Flag'="" Flag=$s(Flag["Y":"Y",1:"N")
    q:Type="" -1
    q:'$d(^DHCWMRDIC(0,"DicName",Type)) -100
    s n=0
    i Flag="" d
    .s sFlag=""
    .f  s sFlag=$o(^DHCWMRDIC(0,"DicName",Type,sFlag))  q:sFlag=""  d
    ..s WMRRowid=""
    ..f  s WMRRowid=$o(^DHCWMRDIC(0,"DicName",Type,sFlag,WMRRowid))  q:WMRRowid=""  d
    ...s ^CacheTemp("DQueryByTypeFlag",$j,n)=..GetDataById(WMRRowid)
    ...s n=n+1
    e  d
    .q:'$d(^DHCWMRDIC(0,"DicName",Type,Flag))
    .s WMRRowid=""
    .f  s WMRRowid=$o(^DHCWMRDIC("0","DicName",Type,Flag,WMRRowid))  q:WMRRowid=""  d
    ..s ^CacheTemp("DQueryByTypeFlag",$j,n)=..GetDataById(WMRRowid)
    ..s n=n+1
    q n-1_"^"_$j
    
BuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryByTypeFlagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByTypeFlagExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Query QueryByTypeFlag(Type As %String, Flag As %String) As %Query(ROWSPEC = "Rowid:%String,DictionaryName:%String,Code:%String,Description:%String,FromDate:%String,ToDate:%String,TextA:%String,TextB:%String,TextC:%String,TextD:%String,IsActive:%String,ResumeText:%String")
{
}

ClassMethod QueryListByTypeFlagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryListByTypeFlagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryListByTypeFlagExecute(ByRef qHandle As %Binary, Type As %String, Flag As %String) As %Status
{
	//***************************************
	//功能说明：根据类型和有效标记查询字典项记录List
	//入参：DictionaryName,IsActive
	//出参：WMRRowid^Description
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRDictionaryCtl","QueryListByTypeFlag","DictionaryName","IsActive")
	//*****************************************
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:Flag'="" Flag=$s(Flag["Y":"Y",1:"N")
	i Type="" d
	.s WMRRowid=0 f  S WMRRowid=$o(^DHCWMRDIC(WMRRowid)) q:WMRRowid=""  d
	..q:'$d(^DHCWMRDIC(WMRRowid))
	..q:((Flag'="")&&(Flag'=$p(^DHCWMRDIC(WMRRowid),"^",10)))
	..s s=WMRRowid_"^"_$p(^DHCWMRDIC(WMRRowid),"^",3)
	..d BuildData
	e  d
	.i Flag="" d
	..s SFlag="" f  S SFlag=$o(^DHCWMRDIC(0,"DicName",Type,SFlag)) q:SFlag=""  d
	...q:'$d(^DHCWMRDIC(0,"DicName",Type,SFlag))
	...s WMRRowid=0 f  s WMRRowid=$o(^DHCWMRDIC(0,"DicName",Type,SFlag,WMRRowid)) q:WMRRowid=""  d
	....q:'$d(^DHCWMRDIC(WMRRowid))
	....s s=WMRRowid_"^"_$p(^DHCWMRDIC(WMRRowid),"^",3)
	....d BuildData
	.e  d
	..q:'$d(^DHCWMRDIC(0,"DicName",Type,Flag))
	..s WMRRowid=0 f  s WMRRowid=$o(^DHCWMRDIC(0,"DicName",Type,Flag,WMRRowid)) q:WMRRowid=""  d
	...q:'$d(^DHCWMRDIC(WMRRowid))
	...s s=WMRRowid_"^"_$p(^DHCWMRDIC(WMRRowid),"^",3)
	...d BuildData

	Quit $$$OK
}

ClassMethod QueryListByTypeFlagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryListByTypeFlagExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Query QueryListByTypeFlag(Type As %String, Flag As %String) As %Query(ROWSPEC = "Rowid:%String,Description:%String")
{
}

ClassMethod QueryByTypeFlagLIST(Type, Flag)
{
	n (Type,Flag)
 
	s ret=""
	q:Type="" ret
	
	s ZIndex=$zn,JIndex=$j
	k ^TMP(ZIndex,JIndex,"ByTypeFlagLIST")
	s:Flag'="" Flag=$s(Flag["Y":"Y",1:"N")
    s Rowid=0
    f  s Rowid=$o(^DHCWMRDIC(Rowid)) q:Rowid=""  d
    .s tmpDic=$g(^DHCWMRDIC(Rowid))
    .s:$p(tmpDic,"^",4)'="" $p(tmpDic,"^",4)=$zd($p(tmpDic,"^",4),3)
    .s:$p(tmpDic,"^",5)'="" $p(tmpDic,"^",5)=$zd($p(tmpDic,"^",5),3)
    .s tmpType=$p(tmpDic,"^",1)
    .s tmpActive=$p(tmpDic,"^",10)
    .q:tmpType'=Type
    .q:(Flag'="")&&(tmpActive'=Flag)
    .s Descs=$p(tmpDic,"^",3)
    .q:Descs=""
    .s ^TMP(ZIndex,JIndex,"ByTypeFlagLIST",Descs,Rowid)=Rowid_"^"_tmpDic
    
	s Descs=""
	f  s Descs=$o(^TMP(ZIndex,JIndex,"ByTypeFlagLIST",Descs)) q:Descs=""  d
	.s Rowid=0
	.f  s Rowid=$o(^TMP(ZIndex,JIndex,"ByTypeFlagLIST",Descs,Rowid)) q:Rowid=""  d
	..s s=$g(^TMP(ZIndex,JIndex,"ByTypeFlagLIST",Descs,Rowid))
	..s ret=ret_$c(1)_s
	k ^TMP(ZIndex,JIndex,"ByTypeFlagLIST")
    
    s:ret'="" ret=$e(ret,2,$l(ret))
    q ret
}

ClassMethod QueryByTypeCode(Type, Code)
{
	//***************************************
	//功能说明：根据DictionaryName和Code获取字典项
	//入参：DictionaryName,Code
	//出参：WMRRowid^DictionaryName^Code^Description^FromDate^ToDate^TextA^TextB^TextC^TextD^IsActive^ResumeText/""
	//调试：w ##class(web.DHCWMRDictionaryCtl).QueryByTypeCode("DictionaryName","Code")
	//*****************************************
	
    n (Type,Code)
    
    q:(Type="")!(Code="") -1
    q:'$d(^DHCWMRDIC(0,"DicNameCode",Type,Code)) -100
    s WMRRowid=$o(^DHCWMRDIC(0,"DicNameCode",Type,Code,""),-1)
    s s=..GetDataById(WMRRowid)
    q s
}

ClassMethod QueryAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryAllExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
    
	;^DHCWMRDIC(0,"DicName",{DictionaryName},{IsActive},{Rowid}) 
	s DicName=""
	f  s DicName=$o(^DHCWMRDIC(0,"DicName",DicName)) q:DicName=""  d
	.s Active=""
    .f  s Active=$o(^DHCWMRDIC(0,"DicName",DicName,Active)) q:Active=""  d
    ..s Id=""
    ..f  s Id=$o(^DHCWMRDIC(0,"DicName",DicName,Active,Id)) q:Id=""  d
    ...s s=..GetDataById(Id)
    ...s:$p(s,"^",2)'="SYS" $p(s,"^",2)=$p(..QueryByTypeCode("SYS",$p(s,"^",2)),"^",4)
    ...s:$p(s,"^",2)="SYS" $p(s,"^",2)="字典类别"
	...d BuildData
    
	Quit $$$OK
}

ClassMethod QueryAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Query QueryAll() As %Query(ROWSPEC = "Rowid:%String,DictionaryName:%String,Code:%String,Description:%String,FromDate:%String,ToDate:%String,TextA:%String,TextB:%String,TextC:%String,TextD:%String,IsActive:%String,ResumeText:%String")
{
}

ClassMethod QueryListByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryListByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryListByTypeExecute(ByRef qHandle As %Binary, Type As %String, Flag As %String, Str As %String) As %Status
{
	//***************************************
	//功能说明：根据类型查询字典项记录List
	//入参：DictionaryName
	//出参：WMRRowid,Description
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRDictionaryCtl","QueryListByType","","","")
	//*****************************************
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
    i Str'="" d
    .s s=Str
	.d LBuildData
	s:Flag'="" Flag=$s(Flag["Y":"Y",1:"N")
    s WMRRowid=0
    f  s WMRRowid=$o(^DHCWMRDIC(WMRRowid)) q:WMRRowid=""  d
    .q:'$d(^DHCWMRDIC(WMRRowid))
    .q:((Type'="")&&(Type'=$p(^DHCWMRDIC(WMRRowid),"^",1)))
    .q:((Flag'="")&&(Flag'=$p(^DHCWMRDIC(WMRRowid),"^",10)))
    .s s=WMRRowid_"^"_$p(^DHCWMRDIC(WMRRowid),"^",3)
	.d LBuildData

	Quit $$$OK
LBuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryListByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryListByTypeExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 根据类型查询字典项列表
Query QueryListByType(Type As %String, Flag As %String, Str As %String) As %Query(ROWSPEC = "Rowid:%String,lsType:%String")
{
}

ClassMethod LookUpQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LookUpQueryExecute(ByRef qHandle As %Binary, Type As %String, Flag As %String) As %Status
{
	
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	
    s iCount=$$QueryByTypeFlag(Type,Flag)
    s JIndex=$p(iCount,"^",2),iCount=+iCount
	q:iCount<0 $$$OK
	f i=0:1:iCount d
	.s s=$g(^CacheTemp("DQueryByTypeFlag",JIndex,i))
	.d BuildLookUp
	Quit $$$OK
BuildLookUp
	set Data=$lb($p(s,"^",1),$p(s,"^",4))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod LookUpQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpQueryExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Query LookUpQuery(Type As %String, Flag As %String) As %Query(ROWSPEC = "Rowid:%String,Description:%String")
{
}

ClassMethod QueryRSbilByTitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRSbilByTitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryRSbilByTitExecute(ByRef qHandle As %Binary, Title As %String, Type As %String, Flag As %String) As %Status
{
	//***************************************
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRDictionaryCtl","QueryRSbilByTit","","","")
	//*****************************************
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:Type="" Type="Responsibility"
	s:Flag'="" Flag=$s(Flag["Y":"Y",1:"N")
    s WMRRowid=0
    f  s WMRRowid=$o(^DHCWMRDIC(WMRRowid)) q:WMRRowid=""  d
    .q:'$d(^DHCWMRDIC(WMRRowid))
    .q:((Title'="")&($p(^DHCWMRDIC(WMRRowid),"^",3)'[Title))
    .q:((Type'="")&&(Type'=$p(^DHCWMRDIC(WMRRowid),"^",1)))
    .q:((Flag'="")&&(Flag'=$p(^DHCWMRDIC(WMRRowid),"^",10)))
    .s s=WMRRowid_"^"_$p(^DHCWMRDIC(WMRRowid),"^",3)
    .d LBuildData
	Quit $$$OK
}

ClassMethod QueryRSbilByTitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRSbilByTitExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 查询责任人类型
Query QueryRSbilByTit(Title As %String, Type As %String, Flag As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

ClassMethod GetByType(Type, Flag)
{
	n (Type,Flag)
	s ret=""
	s ZIndex=$zn,JIndex=$j
	
    s iCount=$$QueryByTypeFlag(Type,Flag)
    s JIndex=$p(iCount,"^",2),iCount=+iCount
	q:iCount<0 $$$OK
	
	
	k ^TMP(ZIndex,JIndex,"GetByType")
	f i=0:1:iCount d
	.s s=$g(^CacheTemp("DQueryByTypeFlag",JIndex,i))
	.s Rowid=$p(s,"^",1)
	.s Descs=$p(s,"^",4)
	.s ^TMP(ZIndex,JIndex,"GetByType",Descs,Rowid)=s
	s Descs=""
	f  s Descs=$o(^TMP(ZIndex,JIndex,"GetByType",Descs)) q:Descs=""  d
	.s Rowid=0
	.f  s Rowid=$o(^TMP(ZIndex,JIndex,"GetByType",Descs,Rowid)) q:Rowid=""  d
	..s s=$g(^TMP(ZIndex,JIndex,"GetByType",Descs,Rowid))
	..s ret=ret_s_$c(1)
	k ^CacheTemp("DQueryByTypeFlag",JIndex)
	k ^TMP(ZIndex,JIndex,"GetByType")
	q ret
}

ClassMethod LookUpForCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpForCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod LookUpForCodeExecute(ByRef qHandle As %Binary, Type As %String, Flag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	q:'$d(^DHCWMRDIC(0,"DicName",Type,Flag)) $$$OK
	
    s Id="0"
    f  s Id=$o(^DHCWMRDIC(0,"DicName",Type,Flag,Id)) q:Id=""  d
    .s s=$g(^DHCWMRDIC(+Id))
    .s Code=$p(s,"^",2)
    .s Desc=$p(s,"^",3)
    .s Data=$lb(Code,Desc)
 	.Set ^CacheTemp(repid,ind)=Data
 	.Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod LookUpForCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpForCodeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Query LookUpForCode(Type As %String, Flag As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String")
{
}

/// w ##Class(web.DHCWMRDictionaryCtl).ImportDic()
ClassMethod ImportDic()
{
	;WMRRowid^DictionaryName^Code^Description^FromDate^ToDate^TextA^TextB^TextC^TextD^IsActive^ResumeText
	s ^CacheTempWMR("Dic",1)="^NarcosisType^020101^蛛网膜下腔阻滞^^^zwmxqzz^^^^N"
	s ^CacheTempWMR("Dic",2)="^NarcosisType^020102^硬膜外麻醉^^^ymwmz^^^^N"
	s ^CacheTempWMR("Dic",3)="^NarcosisType^020103^如硬腰联合麻醉^^^ryylhmz^^^^N"
	s ^CacheTempWMR("Dic",4)="^NarcosisType^020104^硬腰联合麻醉^^^yylhmz^^^^N"
	s ^CacheTempWMR("Dic",5)="^NarcosisType^0202^神经及神经丛阻滞^^^sjjsjczz^^^^N"
	s ^CacheTempWMR("Dic",6)="^NarcosisType^020201^颈丛阻滞^^^jczz^^^^N"
	s ^CacheTempWMR("Dic",7)="^NarcosisType^020202^臂丛阻滞及上肢神经阻滞^^^bczzjszsjzz^^^^N"
	s ^CacheTempWMR("Dic",8)="^NarcosisType^020203^腰骶神经丛阻滞及下肢神经阻滞^^^ydsjczzjxzsjzz^^^^N"
	s ^CacheTempWMR("Dic",9)="^NarcosisType^020204^躯干神经阻滞:肋间神经阻滞^^^qgsjzz^^^^N"
	s ^CacheTempWMR("Dic",10)="^NarcosisType^020205^椎旁神经阻滞^^^zpsjzz^^^^N"
	s ^CacheTempWMR("Dic",11)="^NarcosisType^020206^会阴神经阻滞^^^hysjzz^^^^N"
	s ^CacheTempWMR("Dic",12)="^NarcosisType^020207^交感神经阻滞:星状神经节阻滞^^^jgsjzz^^^^N"
	s ^CacheTempWMR("Dic",13)="^NarcosisType^020208^胸腰交感神经阻滞^^^xyjgsjzz^^^^N"
	s ^CacheTempWMR("Dic",14)="^NarcosisType^020209^脑神经阻滞:三叉,舌咽神经阻滞^^^nsjzz^^^^N"
	s ^CacheTempWMR("Dic",15)="^NarcosisType^03^局部麻醉^^^jbmz^^^^N"
	s ^CacheTempWMR("Dic",16)="^NarcosisType^0301^表面麻醉^^^bmmz^^^^N"
	s ^CacheTempWMR("Dic",17)="^NarcosisType^0302^局部浸润麻醉^^^jbjrmz^^^^N"
	s ^CacheTempWMR("Dic",18)="^NarcosisType^0303^局部阻滞麻醉^^^jbzzmz^^^^N"
	s ^CacheTempWMR("Dic",19)="^NarcosisType^0304^静脉局部麻醉^^^jmjbmz^^^^N"
	s ^CacheTempWMR("Dic",20)="^NarcosisType^04^针麻+局麻+强化^^^zmjmqh^^^^N"
	s ^CacheTempWMR("Dic",21)="^NarcosisType^05^局麻+强化^^^jmqh^^^^N"
	s ^CacheTempWMR("Dic",22)="^NarcosisType^0501^药物复合麻醉^^^ywfhmz^^^^N"
	s ^CacheTempWMR("Dic",23)="^NarcosisType^0502^方法复合麻醉^^^fffhmz^^^^N"
	s ^CacheTempWMR("Dic",24)="^NarcosisType^0503^特殊方法复合麻醉^^^tsfffhmz^^^^N"
	s ^CacheTempWMR("Dic",25)="^NarcosisType^9^无^^^w^^^^N"
	s ^CacheTempWMR("Dic",26)="^NarcosisType^99^其他^^^qt^^^^N"
	s i=0
	f  s i=$o(^CacheTempWMR("Dic",i)) q:i=""  d
	.s InString=$g(^CacheTempWMR("Dic",i))
	.w InString,!
	.s ret=..Update(InString)
	.s:ret<0 ^CacheTempWMR("DicErr",i)=ret
	q "Finish"
}

/// 编写者：王成山
/// 日期：2013-04-27
/// 描述：根据字典Type和Code获取字典数据
/// w ##Class(web.DHCWMRDictionaryCtl).GetDataByTypeAndCode("ICDAndCM3Setting","ICDSetting")
ClassMethod GetDataByTypeAndCode(Type As %String, Code As %String)
{
	New (Type,Code)
	Set Rtn=""
	Set DicID=0,TextA=""
	For {
		Set DicID=$o(^DHCWMRDIC(0,"DicNameCode",Type,Code,DicID))
		Quit:(DicID="")||(TextA'="")
		
		Set IsActive=$p(^DHCWMRDIC(DicID),"^",10)
		Continue:IsActive'="Y"
		Set TextA=$p(^DHCWMRDIC(DicID),"^",6)
	}
	Set Rtn=TextA
	Quit Rtn
}

/// 编写者：王成山
/// 日期：2013-04-27
/// 描述：根据字典类型获取该类型下所有数据，各个字典项之间用$c(2)分割；
///      从^DHCWMRDICOfData取值，如果^DHCWMRDICOfData值为空从数据库内取值；调试程序请先K ^DHCWMRDICOfData
/// w ##Class(web.DHCWMRDictionaryCtl).GetDicByType("FPICDType")
ClassMethod GetDicByType(Type As %String)
{
	New (Type)
	Set Rtn=""
	If ('$d(^DHCWMRDICOfData("DHCWMR",Type))){  ;是否已经存在数据
		Set DicID=0
		For {
			Set DicID=$o(^DHCWMRDIC(0,"DicName",Type,"Y",DicID))
			Quit:DicID=""
			Set TextB=+$p($g(^DHCWMRDIC(DicID)),"^",7)
			Set TextA=$p(^DHCWMRDIC(DicID),"^",6)
			Set Desc=$p(^DHCWMRDIC(DicID),"^",3)
			Set TextA=Desc_"#TYPE:"_TextA
			Set:'$IsValidNum(TextB) TextB=0
			Set:TextA'="" ^DHCWMRDICOfData("DHCWMR",Type,TextB)=TextA
		 }
	}
	Set TextB=0
	For {
		Set TextB=$o(^DHCWMRDICOfData("DHCWMR",Type,TextB))
		Quit:TextB=""
		
		Set TextA=^DHCWMRDICOfData("DHCWMR",Type,TextB)
		If (Rtn=""){
			Set Rtn=TextA
		}Else{
			Set Rtn=Rtn_$c(2)_TextA
		}
	}
	Quit Rtn
}

}
