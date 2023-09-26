Import SQLUser

/// 名称: 	DHCMedIPBKTemplateCtl
/// 描述: 	住院证模板表:DHC_MedIPBKTemplate操作
/// 编写者：	刘学峰
/// 编写日期:2008-10-24
Class web.DHCMedIPBKTemplateCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

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
	
	s RowID=0
	f  s RowID=$o(^DHCMedIPBKT(RowID)) q:RowID=""  d
	.s str=$g(^DHCMedIPBKT(+RowID))
	.s TempCode=$p(str,"^",1)
	.s TempDesc=$p(str,"^",2)
	.s IsActive=$p(str,"^",3)
	.s ResumeText=$p(str,"^",4)
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
/// CreatDate：  2008-10-24
/// Description：查询住院证模板表Query
/// Table：      DHC_MedIPBKTemplate
/// Input：      无
/// Output：     所有住院证模板数据
/// Debug:	
Query QueryAll() As %Query(ROWSPEC = "RowID,TempCode,TempDesc,IsActive,ResumeText")
{
}

/// Creator：    刘学峰
/// CreatDate：  2008-10-24
/// Description：添加或修改住院证模板
/// Table：      DHC_MedIPBKTemplate
/// Input：      RowID^TempCode^TempDesc^IsActive^ResumeText
/// Output：     SQLCODE/RowID
/// Debug:		 w ##class(web.DHCMedIPBKTemplateCtl).Update("入参")
ClassMethod Update(InPut)
{

    n (InPut)  
    s RowID=$p(InPut,"^",1)
    s PLIST(2)=$p(InPut,"^",2)      ;TempCode	代码             
    s PLIST(3)=$p(InPut,"^",3)      ;TempDesc	名称                                            
    s PLIST(4)=$p(InPut,"^",4)      ;IsActive	有效状态          
    s PLIST(5)=$p(InPut,"^",5)      ;ResumeText	备注             
    
    i RowID="" d
    .&sql(Insert into DHC_MedIPBKTemplate values :PLIST())
    e  d
    .&sql(Update DHC_MedIPBKTemplate values :PLIST() where RowID=:RowID)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

/// Creator：    刘学峰
/// CreatDate：  2008-10-24
/// Description：根据RowID获取模板
/// Table：      DHC_MedIPBKTemplate
/// Input：      RowID
/// Output：     RowID^ItemCode^ItemDesc^DateTypeID^DictionaryName^IsActive^ResumeText
/// Debug:		 w ##class(web.DHCMedIPBKTemplateCtl).GetDataById("RowID")
ClassMethod GetDataById(RowID)
{
    n (RowID)
    q:'$d(^DHCMedIPBKT(RowID)) ""
    s s=$g(^DHCMedIPBKT(RowID))
    s s=RowID_"^"_s
    q s
}

}
