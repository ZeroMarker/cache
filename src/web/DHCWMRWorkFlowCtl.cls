Import SQLUser

Class web.DHCWMRWorkFlowCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 36;

//病案工作流父表操作

ClassMethod Update(InString)
{
	//***************************************
	//功能说明：添加或修改病案工作流项目(添加数据时WMRRowid设空值)
	//入参：WMRRowid^MrType_Dr^Description^IsActive^DateFrom^DateTo^Resume
	//出参：WMRRowid
	//调试：w ##class(web.DHCWMRWorkFlowCtl).Update("1^7^顺序工作流^Y^01/03/2010^12/03/2099^")
	//***************************************
	n (InString)
    s WMRRowid=$p(InString,"^",1)
    s PLIST(2)=+$p(InString,"^",2)     ;工作流类型
    q:PLIST(2)=0 -1
    s PLIST(3)=$p(InString,"^",3)      ;工作流描述
    q:PLIST(3)="" -1
    s PLIST(4)=$s($p(InString,"^",4)["Y":"Y",1:"N")                   ;是否有效
    s:($p(InString,"^",5)'="")&($p(InString,"^",5)["-") PLIST(5)=$zdh($p(InString,"^",5),3)      ;生效日期  
    s:($p(InString,"^",5)'="")&($p(InString,"^",5)["/") PLIST(5)=$zdh($p(InString,"^",5),4)      ;生效日期        
    s:($p(InString,"^",6)'="")&($p(InString,"^",5)["-") PLIST(6)=$zdh($p(InString,"^",6),3)      ;废止日期  
    s:($p(InString,"^",6)'="")&($p(InString,"^",5)["/") PLIST(6)=$zdh($p(InString,"^",6),4)      ;废止日期             
    s PLIST(7)=$p(InString,"^",7)      ;备注
    i WMRRowid="" d
    .&sql(Insert into DHC_WMR_WorkFlow values :PLIST())
    e  d
    .&sql(Update DHC_WMR_WorkFlow values :PLIST() where Rowid=:WMRRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetDataById(WMRRowid)
{
	//***************************************
	//功能说明：根据RowID获取病案工作流项目记录
	//入参：WMRRowid
	//出参：WMRRowid^MrType_Dr^Description^IsActive^DateFrom^DateTo^Resume/""
	//调试：w ##class(web.DHCWMRWorkFlowCtl).GetDataById("WMRRowid")
	//***************************************
	n (WMRRowid)
	n (WMRRowid)
    q:'$d(^DHCWMRWFLOW(WMRRowid)) ""
    s s=$g(^DHCWMRWFLOW(WMRRowid))
    s:$p(s,"^",4)'="" $p(s,"^",4)=$zd($p(s,"^",4),3)
    s:$p(s,"^",5)'="" $p(s,"^",5)=$zd($p(s,"^",5),3)
    s:$p(s,"^",1)'="" id=$p(s,"^",1)
	s MrTypeDesc=""
	s:$d(^DHCWMRDIC(id)) MrTypeDesc=$p(^DHCWMRDIC(id),"^",3)
	s $p(s,"^",7)=MrTypeDesc
    s s=WMRRowid_"^"_s
	i s'="" d
	.s:$p(s,"^",5)'="" $p(s,"^",5)=$zd($zdh($p(s,"^",5),3),4)
	.s:$p(s,"^",6)'="" $p(s,"^",6)=$zd($zdh($p(s,"^",6),3),4)
	q s
}

ClassMethod QueryByTypeActiveDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByTypeActiveDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryByTypeActiveDateExecute(ByRef qHandle As %Binary, Type As %String, Active As %String, Date As %String) As %Status
{
	//****************************************
	//功能说明：查询病案工作流项目记录集
	//入参：MrType_Dr,IsActive,DateFrom
	//出参：WMRRowid,MrTypee_Dr,Description,IsActive,DateFrom,DateTo,Resume
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRWorkFlowCtl","QueryByTypeActiveDate","MrType_Dr","IsActive","DateFrom")
	//****************************************
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
    q:Type="SYS" $$$OK
    s iCount=..QueryByTypeActiveDate(Type,Active,Date)
    s JIndex=$p(iCount,"^",2),iCount=+iCount
	q:iCount<0 $$$OK
	f i=0:1:iCount d
	.s s=$g(^CacheTemp("WFQueryByTypeActiveDate",JIndex,i))
	.d BuildData

	Quit $$$OK
BuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryByTypeActiveDate(Type, Active, Date)
{
    n (Type,Active,Date)
    k ^CacheTemp("WFQueryByTypeActiveDate",$j)
    
    s:Type'="" Type=+Type
    s:Active'="" Active=$s(Active["Y":"Y",1:"N")
    s:Date'="" Date=$zdh(Date,3)
    s n=0
    i (Type="")!(Date="") d
    .s WMRRowid=0
    .f  s WMRRowid=$o(^DHCWMRWFLOW(WMRRowid)) q:WMRRowid=""  d
    ..q:((Type'="")&(Type'=$p(^DHCWMRWFLOW(WMRRowid),"^",1)))
    ..q:((Active'="")&(Active'=$p(^DHCWMRWFLOW(WMRRowid),"^",3)))
    ..q:((Date'="")&(Date'=$p(^DHCWMRWFLOW(WMRRowid),"^",4)))
    ..s ^CacheTemp("WFQueryByTypeActiveDate",$j,n)=..GetDataById(WMRRowid)
    ..s n=n+1
    e  d
    .q:'$d(^DHCWMRWFLOW(0,"TypeActiveDate",Type))
    .i Active="" d
    ..s SActive=""
    ..f  s SActive=$o(^DHCWMRWFLOW(0,"TypeActiveDate",Type,SActive)) q:SActive=""  d
    ...q:'$d(^DHCWMRWFLOW(0,"TypeActiveDate",Type,SActive,Date))
    ...s WMRRowid=0
    ...f  s WMRRowid=$o(^DHCWMRWFLOW(0,"TypeActiveDate",Type,SActive,Date,WMRRowid)) q:WMRRowid=""  d
    ....s ^CacheTemp("WFQueryByTypeActiveDate",$j,n)=..GetDataById(WMRRowid)
    ....s n=n+1
    .e  d
    ..q:'$d(^DHCWMRWFLOW(0,"TypeActiveDate",Type,Active,Date))
    ..s WMRRowid=0
    ..f  s WMRRowid=$o(^DHCWMRWFLOW(0,"TypeActiveDate",Type,Active,Date,WMRRowid)) q:WMRRowid=""  d
    ...s ^CacheTemp("WFQueryByTypeActiveDate",$j,n)=..GetDataById(WMRRowid)
    ...s n=n+1
    q n-1_"^"_$j
}

ClassMethod QueryByTypeActiveDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByTypeActiveDateExecute ]
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

Query QueryByTypeActiveDate(Type As %String = "All", Active As %String, Date As %String) As %Query(ROWSPEC = "Rowid:%String,MrType_Dr:%String,Description:%String,IsActive:%String,DateFrom:%String,DateTo:%String,Resume:%String,MrTypeDesc:%String")
{
}

ClassMethod QueryByTypeActiveDateLIST(Type, Active, Date)
{
	//***************************************
	//功能说明：查询病案工作流项目列表记录集字串
	//          $c(1)分割记录,"^"分割字段
	//入参：MrType_Dr,IsActive,DateFrom
	//出参：记录集'WMRRowid^MrType_Dr^Description^IsActive^DateFrom^DateTo^Resume'
	//调试：w ##class(web.DHCWMRWorkFlowCtl).QueryByTypeActiveDateLIST("MrType_Dr","IsActive","DateFrom")
	//***************************************
	n (Type,Active,Date)
	s iCount=..QueryByTypeActiveDate(Type,Active,Date)
    s JIndex=$p(iCount,"^",2),iCount=+iCount
	q:iCount<0 $$$OK
	f i=0:1:iCount d
	.s j=i+1
	.s $p(s,$c(1),j)=$g(^CacheTemp("WFQueryByTypeActiveDate",JIndex,i))
	q s
}

// 病案工作流子表操作

ClassMethod SSUpdate(InString)
{
	//***************************************
	//功能说明：添加或修改病案工作流子表记录(添加数据时WMRRowid设空值)
	//入参：ParId^SubID^IndexNo^Item_Dr
	//出参：WMRRowid
	//调试：w ##class(web.DHCWMRWorkFlowCtl).SSUpdate("ParId^SubID^IndexNo^Item_Dr")
	//***************************************
	n (InString)
    s ParID=$p(InString,"^",1)
    s SubID=$p(InString,"^",2)
    s WMRRowid=ParID_"||"_SubID
    
    s PLIST(0)=ParID
    q:ParID="" -1
    s PLIST(3)=+$p(InString,"^",3)      ;序号
    s PLIST(4)=+$p(InString,"^",4)      ;病案操作项目
    q:PLIST(4)=0 -1
    q:($d(^DHCWMRWFLOW(ParID,"S",0,"ItemDr",PLIST(4))))&(SubID="") -1
    i SubID="" d
    .&sql(Insert into DHC_WMR_WorkFlowSub values :PLIST())
    e  d
    .&sql(Update DHC_WMR_WorkFlowSub values :PLIST() where Rowid=:WMRRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod SSGetDataById(WMRRowid)
{
	//***************************************
	//功能说明：根据RowID获取病案工作流子表记录
	//入参：WMRRowid
	//出参：WMRRowid^IndexNo^Item_Dr
	//调试：w ##class(web.DHCWMRWorkFlowCtl).SSGetDataById("WMRRowid")
	//***************************************
	n (WMRRowid)
    s ParID=$p(WMRRowid,"||",1)
    s SubID=$p(WMRRowid,"||",2)
    
    q:'$d(^DHCWMRWFLOW(ParID,"S",SubID)) ""
    s s=$g(^DHCWMRWFLOW(ParID,"S",SubID))
    s $p(s,"^",1)=+$p(s,"^",1)
    s $p(s,"^",2)=+$p(s,"^",2)
    s s=WMRRowid_"^"_s
    q s
}

ClassMethod SSGetDataByIdLIST(ParID)
{
	//***************************************
	//功能说明：获取病案工作流子表记录集字串
	//          $c(1)分割记录,"^"分割字段
	//入参：ParID
	//出参：WMRRowid^IndexNo^Item_Dr
	//调试：w ##class(web.DHCWMRWorkFlowCtl).SSGetDataByIdLIST("ParID")
	//***************************************
	n (ParID)
    q:'$d(^DHCWMRWFLOW(ParID,"S")) ""
    s n=0,s=""
    s SubID=0
    f  s SubID=$o(^DHCWMRWFLOW(ParID,"S",SubID)) q:SubID=""  d
    .q:'$d(^DHCWMRWFLOW(ParID,"S",SubID))
    .s n=n+1
    .s $p(s,$c(1),n)=ParID_"||"_SubID_"^"_$g(^DHCWMRWFLOW(ParID,"S",SubID))
    q s
}

ClassMethod SSQueryListByParIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SSQueryListByParIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod SSQueryListByParIDExecute(ByRef qHandle As %Binary, ParID As %String) As %Status
{
	//****************************************
	//功能说明：取工作流项目List，顺序就是配置的顺序
	//入参：ParID
	//出参：Type_Dr,Type_Desc
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRWorkFlowCtl","SSQueryListByParID","ParID")
	//****************************************
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	i ParID'="" d
	.s SubID=0 f  s SubID=$o(^DHCWMRWFLOW(ParID,"S",SubID)) q:SubID=""  d
	..q:'$d(^DHCWMRWFLOW(ParID,"S",SubID))
	..s Id=$p(^DHCWMRWFLOW(ParID,"S",SubID),"^",2)
	..q:'$d(^DHCWMRWITM(Id))
	..s Desc=$p(^DHCWMRWITM(Id),"^",2)
	..s s=Id_"^"_Desc
	..d BuildData
	q $$$OK
}

ClassMethod SSQueryListByParIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SSQueryListByParIDExecute ]
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

Query SSQueryListByParID(ParID As %String = "0") As %Query(ROWSPEC = "Type_Dr:%String,Type_Desc:%String")
{
}

//更新工作流父子表数据类方法。

ClassMethod UpdateWorkFlow(MStr, SStr)
{
	//***************************************
	//功能说明：添加或修改病案工作流
	//入参：MStr，SStr（父表记录和子表记录）
	//出参：Flag
	//调试：w ##class(web.DHCWMRWorkFlowCtl).UpdateWorkFlow(MStr，SStr)
	//***************************************
	n (MStr,SStr)
	s Flag=0
	q:((MStr="")||(SStr="")) Flag
	Tstart
	s Id=##Class(web.DHCWMRWorkFlowCtl).Update(MStr)
	q:Id<1 $$$OK
	k ^DHCWMRWFLOW(Id,"S")
	s Flag=1
	s Count=$l(SStr,$c(1))
	q:Count<1
	f i=1:1:Count d
	.q:Flag=0
	.s Item=Id_"^^"_$p(SStr,$c(1),i)
	.S WId=##Class(web.DHCWMRWorkFlowCtl).SSUpdate(Item)
	.s WId=+WId
	.i WId<1 Trollback
	Tcommit
	q Flag
}

//业务流程信息查询

ClassMethod GetWFLByTypeActiveDate(Type, Active, Date)
{
	//***************************************
	//功能说明：查询当前工作流项目List
	//入参：Type,Active,Date(当前系统日期,格式“2007-01-01”)
	//出参：IndexNo^Item_Dr
	//调试：w ##class(web.DHCWMRWorkFlowCtl).GetWFLByTypeActiveDate("Type","Active","Date")
	//***************************************
	n (Type,Active,Date)
	
	q:((Type="")||(Active="")||(Date="")) ""
	s:Type'="" Type=+Type
	s:Active'="" Active=$s(Active["Y":"Y",1:"N")
	s Date=$zdh(Date,3)
	q:'$d(^DHCWMRWFLOW(0,"TypeActive",Type,Active)) ""
	s Flag=0,s=""
	s ID=""
	f  s ID=$o(^DHCWMRWFLOW(0,"TypeActive",Type,Active,ID),-1) q:ID=""  d
	.q:Flag=1
	.q:'$d(^DHCWMRWFLOW(ID))
	.q:($p($g(^DHCWMRWFLOW(ID)),"^",4)>Date)
	.q:'$d(^DHCWMRWFLOW(ID,"S"))
	.s SID=0
	.f  s SID=$o(^DHCWMRWFLOW(ID,"S",SID)) q:SID=""  d
	..q:'$d(^DHCWMRWFLOW(ID,"S",SID))
	..s Temp=$g(^DHCWMRWFLOW(ID,"S",SID))
	..s Tmp=ID_"||"_SID_"^"_$p(Temp,"^",1)_"^"_$p(Temp,"^",2)
	..i s="" d
	...s s=Tmp
	..e  d
	...s s=s_$c(1)_Tmp
	.s Flag=1
    q s
}

ClassMethod QueryWFLByTypeActiveDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWFLByTypeActiveDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryWFLByTypeActiveDateExecute(ByRef qHandle As %Binary, Type As %String, Active As %String, Date As %String) As %Status
{
	//***************************************
	//功能说明：查询当前工作流项目
	//入参：Type,Active,Date(当前系统日期,格式“2007-01-01”)
	//出参：IndexNo,Item_Dr
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRWorkFlowCtl","QueryWFLByTypeActiveDate","Type","Active","Date")
	//***************************************
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:Date="" Date=$zd($h,3)
	s Str=..GetWFLByTypeActiveDate(Type,Active,Date)
	q:Str="" $$$OK
	s Count=$l(Str,$c(1))
	f i=1:1:Count d
	.s s=$p(Str,$c(1),i)
	.d BuildData
	q $$$OK
}

ClassMethod QueryWFLByTypeActiveDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWFLByTypeActiveDateExecute ]
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

Query QueryWFLByTypeActiveDate(Type As %String, Active As %String, Date As %String) As %Query(ROWSPEC = "Rowid:%String,IndexNo:%String,Item_Dr:%String")
{
}

ClassMethod QueryWFLByMrTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWFLByMrTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryWFLByMrTypeExecute(ByRef qHandle As %Binary, Type As %String) As %Status
{
	//***************************************
	//功能说明：查询病案类型当前相应的工作流项目
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRWorkFlowCtl","QueryWFLByMrType","Type")
	//***************************************
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s Active="Y"
	s Date=$zd($h,3)
	s Str=..GetWFLByTypeActiveDate(Type,Active,Date)
	q:Str="" $$$OK
	s Count=$l(Str,$c(1))
	f i=1:1:Count d
	.s s=$p(Str,$c(1),i)
	.s ItemId=$p(s,"^",3)
	.s ItemDesc=$p($g(^DHCWMRWITM(ItemId)),"^",2)
	.s s=ItemId_"^"_ItemDesc
	.d BuildData
	q $$$OK
}

ClassMethod QueryWFLByMrTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWFLByMrTypeExecute ]
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

Query QueryWFLByMrType(Type As %String) As %Query(ROWSPEC = "ItmeId:%String,ItemDesc:%String")
{
}

}
