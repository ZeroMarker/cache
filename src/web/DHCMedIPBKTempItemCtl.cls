Import SQLUser

/// 名称: 	DHCMedIPBKTempItemCtl
/// 描述: 	住院证模板项目字典表:DHC_MedIPBKTempItem操作
/// 编写者：	刘学峰
/// 编写日期:2008-10-21
Class web.DHCMedIPBKTempItemCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 42;

ClassMethod QueryAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

//d ##class(%ResultSet).RunQuery("web.DHCMedIPBKTempItemCtl:QueryAll","")

ClassMethod QueryAllExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s RowID=0
	f  s RowID=$o(^DHCMedIPBKTI(RowID)) q:RowID=""  d
	.s str=$g(^DHCMedIPBKTI(+RowID))
	.s ItemCode=$p(str,"^",1)
	.s ItemDesc=$p(str,"^",2)
	.s DateTypeID=$p(str,"^",3)
	.s DictionaryName=$p(str,"^",4)
	.s IsActive=$p(str,"^",5)
	.s ResumeText=$p(str,"^",6)
	.s str=RowID_"^"_str
    .d BuildData
    Quit $$$OK
    
BuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(str,"^") d
 	.s $li(Data,iBuild)=$p(str,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
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

/// Creator：    刘学峰
/// CreatDate：  2008-10-21
/// Description：查询字典项目Query
/// Table：      DHC_MedIPBKTempItem
/// Input：      无
/// Output：     所有住院证模板项目
/// Debug:	
Query QueryAll() As %Query(ROWSPEC = "RowID,ItemCode,ItemDesc,DateTypeID,DictionaryName,IsActive,ResumeText")
{
}

/// Creator：    刘学峰
/// CreatDate：  2008-10-21
/// Description：添加或修改住院证模板项目
/// Table：      DHC_MedIPBKTempItem
/// Input：      RowID^ItemCode^ItemDesc^DateTypeID^DictionaryName^IsActive^ResumeText
/// Output：     -1/SQLCODE/RowID
/// Debug:		 w ##class(web.DHCMedIPBKTempItemCtl).Update("入参")
ClassMethod Update(InPut)
{
    s ^Temp("web.DHCMedIPBKTempItemCtl:Update")=InPut_"2"
    n (InPut)  
    s RowID=$p(InPut,"^",1)
    s PLIST(2)=$p(InPut,"^",2)      ;ItemCode	代码                
    s PLIST(3)=$p(InPut,"^",3)      ;ItemDesc	描述                
    s PLIST(4)=$p(InPut,"^",4)      ;DateTypeID	数值类型ID 指向DHC_MedDictory
    s PLIST(5)=$p(InPut,"^",5)      ;DictionaryName	字典名称代码             
    s:$p($g(^DHCMDIC(+PLIST(4))),"^",1)'="Dictionary" PLIST(5)=""     ;如果根据DateTypeID查询出数据类型不是字典类型，则将字典名称代码设为空           
    s PLIST(6)=$p(InPut,"^",6)      ;IsActive	有效状态           
    s PLIST(7)=$p(InPut,"^",7)      ;ResumeText	备注              
    
    q:($d(^DHCMedIPBKTI("0","ItemCode",PLIST(2))))&(RowID="") -1 ;为什么要加这句话
    i RowID="" d
    .&sql(Insert into DHC_MedIPBKTempItem values :PLIST())
    e  d
    .&sql(Update DHC_MedIPBKTempItem values :PLIST() where RowID=:RowID)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

/// Creator：    刘学峰
/// CreatDate：  2008-10-21
/// Description：根据RowID获取模板项目
/// Table：      DHC_MedIPBKTempItem
/// Input：      RowID
/// Output：     RowID^ItemCode^ItemDesc^DateTypeID^DictionaryName^IsActive^ResumeText
/// Debug:		 w ##class(web.DHCMedIPBKTempItemCtl).GetDataById("RowID")
ClassMethod GetDataById(RowID)
{
    n (RowID)
    q:'$d(^DHCMedIPBKTI(RowID)) ""
    s s=$g(^DHCMedIPBKTI(RowID))
    s s=RowID_"^"_s
    q s
}

/// Creator：    刘学峰
/// CreatDate：  2008-10-21
/// Description：根据IsActive(是否有效)获取模板项目
/// Table：      DHC_MedIPBKTempItem
/// Input：      ActiveFlag(Y/N)
/// Output：     RowID^ItemCode^ItemDesc^DateTypeID^DictionaryName^IsActive^ResumeText
/// Debug: 	   	 w ##class(web.DHCMedIPBKTempItemCtl).QueryDataByActiveFlag("Y")
ClassMethod QueryDataByActiveFlag(ActiveFlag)
{
	n (ActiveFlag)
	s ret=""		
	s RowID=0
	f  s RowID=$o(^DHCMedIPBKTI(RowID)) q:RowID=""  d
	.s str=$g(^DHCMedIPBKTI(+RowID))
	.s ItemCode=$p(str,"^",1)
	.s ItemDesc=$p(str,"^",2)
	.s DateTypeID=$p(str,"^",3)
	.s DictionaryName=$p(str,"^",4)
	.s IsActive=$p(str,"^",5)
	.q:IsActive'=ActiveFlag
	.s ResumeText=$p(str,"^",6)
	.s ret=ret_RowID_"^"_ItemCode_"^"_ItemDesc_"^"_DateTypeID_"^"_DictionaryName_"^"_IsActive_"^"_ResumeText_$c(1)
	s ret=$e(ret,1,$l(ret)-1)
	q ret
}

}
