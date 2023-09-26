Import SQLUser

/// 创建人：李阳
/// 创建时间：2009-12-09
/// 功能：模糊查询ICD字典库
Class web.DHCWMRICDDxQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 51;

/// 通过疾病名称查询
Query QueryICDByDesc(DicType As %String, ICDCode As %String, Desc As %String) As %Query(ROWSPEC = "ID:%String:ID,ICD:%String:ICD,DiseaseName:%String:DiseaseName")
{
}

ClassMethod QueryICDByDescExecute(ByRef qHandle As %Binary, DicType As %String, ICDCode As %String, Desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:DicType="" $$$OK
	q:(ICDCode="")&&(Desc="") $$$OK
	s TypeDIC=$g(^DHCWMRDIC(DicType))
	s TypeCode=$p(TypeDIC,"^",2)
	
	s setting=+$g(^DHCWMRICDSetting(TypeCode))
	
	i setting=0  d
	.s rowid="" f  s rowid=$o(^DHCWMRICD(rowid)) q:rowid=""  d
	..s dic=$g(^DHCWMRICD(rowid))
	..q:dic=""
	..s ret=..IsInclude($p(dic,"^",3),Desc)
	..q:ret=0
	..q:($p(dic,"^",1)'="")&&($p(dic,"^",1)'[ICDCode)
	..q:$p(dic,"^",6)="N" //检查DHC_WMR_ICDDx的IsActive
	..s ver=$g(^DHCWMRICDV(+$p(dic,"^",4)))
	..q:$p(ver,"^",4)="N" //检查DHC_WMR_ICDVersion的IsActive
	..q:$p(ver,"^",3)'=TypeCode
	..s data=$lb("")
	..s $li(data,1)=rowid
	..s $li(data,2)=$p(dic,"^",1)
	..s $li(data,3)=$p(dic,"^",3)
	..s ^CacheTemp(repid,ind)=data
	..s ind=ind+1
	
	
	i ((setting=1)&&(TypeCode="D")) d //查询疾病
	.s rowid=0 
	.f  s rowid=$o(^MRC("ID",rowid)) q:rowid=""  d
	..s dic=$g(^MRC("ID",rowid))
	..s DateActiveFrom=+$p(dic,"^",6)
	..s DateActiveTo=+$p(dic,"^",7)
	..q:(DateActiveFrom'=0)&&(DateActiveFrom>+$h) //检查是否尚未生效
	..q:(DateActiveTo'=0)&&(DateActiveTo<+$h) 	//检查是否过期
	..s MRCIDCode=$p(dic,"^",4)	//MRCID_ICD9CM_Code
	..q:MRCIDCode'[ICDCode
	..s MRCIDDesc=$p(dic,"^",2)	//MRCID_Desc
	..s ret=..IsInclude(MRCIDDesc,Desc)
	..q:ret=0
	..s data=$lb("")
	..s $li(data,1)=rowid
	..s $li(data,2)=MRCIDCode 
	..s $li(data,3)=MRCIDDesc 
	..s ^CacheTemp(repid,ind)=data
	..s ind=ind+1
	
	i ((setting=1)&&(TypeCode="O")) d //查询手术
	.s rowid=0
	.f  s rowid=$o(^ORC("OPER",rowid)) q:rowid=""  d
	..s dic=$g(^ORC("OPER",rowid))
	..s DateActiveFrom=+$p(dic,"^",5)
	..s DateActiveTo=+$p(dic,"^",6)
	..q:(DateActiveFrom'=0)&&(DateActiveFrom>+$h) //检查是否尚未生效
	..q:(DateActiveTo'=0)&&(DateActiveTo<+$h) 	//检查是否过期
	..s OPERICD10=$p(dic,"^",14)	//OPER_ICD10
	..q:OPERICD10'[ICDCode
	..s OPERDesc=$p(dic,"^",2)	//OPER_Desc
	..s ret=..IsInclude(OPERDesc,Desc)
	..q:ret=0
	..s data=$lb("")
	..s $li(data,1)=rowid
	..s $li(data,2)=OPERICD10
	..s $li(data,3)=OPERDesc
	..s ^CacheTemp(repid,ind)=data
	..s ind=ind+1	
	Quit $$$OK
}

ClassMethod QueryICDByDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryICDByDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryICDByDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryICDByDescExecute ]
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

/// 根据输入描述过滤数据，Mask为使用空格分隔的关键词
ClassMethod IsInclude(Exp, Mask)
{
	n (Exp,Mask)
	s ret=1
	f i=1:1:$l(Mask," ")  d
	.s:Exp'[$p(Mask," ",i) ret=0
	q ret
}

ClassMethod Test()
{
	//w ##class(web.DHCWMRICDDxQry).Test()
	d ##Class(%ResultSet).RunQuery("web.DHCWMRICDDxQry","QueryICDByDesc",47,"I10","高血压")
	q ""
}

}
