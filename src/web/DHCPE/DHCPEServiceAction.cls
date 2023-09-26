Import SQLUser

/// 体检webservice业务代码维护
/// Creater:王国营
Class web.DHCPE.DHCPEServiceAction Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCPE.DHCPEServiceAction","DataListQuery")
Query DataListQuery(txtID As %String = "", txtActionCode As %String = "", txtActionName As %String = "", txtClassName As %String = "", txtMethodName As %String = "") As %Query(ROWSPEC = "ID:%String,ActionCode:%String,ActionName:%String,ClassName:%String,MethodName:%String")
{
}

ClassMethod DataListQueryExecute(ByRef qHandle As %Binary, txtID As %String = "", txtActionCode As %String = "", txtActionName As %String = "", txtClassName As %String = "", txtMethodName As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
	s txtActionCode=$TR(txtActionCode," ")
	s txtActionName=$TR(txtActionName," ")
	s txtClassName=$TR(txtClassName," ")
	s txtMethodName=$TR(txtMethodName," ")
	s ID=""
	f  s ID=$O(^User.DHCPEServiceActionD(ID)) q:ID=""  d
	.q:$G(^User.DHCPEServiceActionD(ID))=""
	.q:(txtID'="")&&(txtID'=ID)
	.s ActionObj=##class(User.DHCPEServiceAction).%OpenId(ID)
	.s ActionCode=ActionObj.ActionCode
	.q:ActionCode'[txtActionCode
	.s ActionName=ActionObj.ActionName
	.q:ActionName'[txtActionName
	.s ClassName=ActionObj.ClassName
	.q:ClassName'[txtClassName
	.s MethodName=ActionObj.MethodName
	.q:MethodName'[txtMethodName
	.d ActionObj.%Close()
	.s Data=$lb(ID,ActionCode,ActionName,ClassName,MethodName)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1

    s qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod DataListQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DataListQueryExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	if ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	else {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DataListQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DataListQueryExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetJob()
{
	q $j
}

ClassMethod KillImportGlobal(Job)
{
	k ^DHCPEImportServAct("ImportInfo",Job)
	q 0
}

ClassMethod InsertImportGlobal(Job, InString)
{
	q:(Job="")||(InString) "-100" 
	s len=$l(InString,"@")
	s lstSort=0
	i $D(^DHCPEImportServAct("ImportInfo",Job)) d
	.s lstSort=$o(^DHCPEImportServAct("ImportInfo",Job,""),-1)
	f i=1:1:len d
	.s param=$p(InString,"@",i)
	.s sort=lstSort+i
	.s ^DHCPEImportServAct("ImportInfo",Job,sort)=param
	q 0
}

/// w ##class(web.DHCPE.DHCPEServiceAction).RunImport(180,10)
ClassMethod RunImport(Job, Count, Type)
{
	Set $ZTrap = "MessageCatch"
	s lstSort=$o(^DHCPEImportServAct("ImportInfo",Job,""),-1)
	q:lstSort'=Count "-8^导入失败，请检查数据(共"_Count_"条记录，实际有效记录"_lstSort_"条)"
	TS
	i Type="Cover"  d
	.k ^User.DHCPEServiceActionD
	.k ^User.DHCPEServiceActionI
	s Flag=0
	i Type="ForceAdd"  s Flag=1
	s error=""
	s sort=""
	f  s sort=$O(^DHCPEImportServAct("ImportInfo",Job,sort)) q:(sort="")||(error'="")  d
	.s param=$g(^DHCPEImportServAct("ImportInfo",Job,sort))
	.s ret=..Save("",param,Flag)
	.i (+ret)<0  s error=ret q
	i error'="" tro  q error
	TC
	q 0
MessageCatch
	Tro
  	Quit "-100^"_$ZError
}

/// 为HIS-UI 调用封装返回结果  Json
/// w ##class(web.DHCPE.DHCPEServiceAction).SaveRetJson("","HS10001^HS10001^HS10001^HS10001")
ClassMethod SaveRetJson(ID As %String = "", ParmList As %String = "", Flag = "0")
{
	s retJson=""
	s ret=..Save(ID,ParmList,Flag)
	s len=$l(ret,"^")
	i len=1 d
	.i ret="0" d
	..s retJson="{""ResultCode"":""0"",""ResultDesc"":""保存成功""}"
	.e  d
	..s retJson="{""ResultCode"":"""_ret_""",""ResultDesc"":""保存失败""}"
	e  d
	.s retJson="{""ResultCode"":"""_$P(ret,"^",1)_""",""ResultDesc"":"""_$P(ret,"^",2)_"""}"
	q retJson
}

ClassMethod Save(ID As %String = "", ParmList As %String = "", Flag = "0")
{
	Set $ZTrap = "MessageCatch"
	s ParmList=$TR(ParmList," ") 	
  	s ActionCode=$p(ParmList,"^",1)
  	s ActionName=$p(ParmList,"^",2)
  	s ClassName=$p(ParmList,"^",3)
  	s MethodName=$p(ParmList,"^",4)
  	q:(ActionCode="")||(ActionName="")||(ClassName="")||(MethodName="") "-99^参数不能为空"
	s OldID=$O(^User.DHCPEServiceActionI("ActionCode",$$ALPHAUP^SSUTIL4(ActionCode),""))
	q:(ID="")&&(OldID'="")&&(Flag="0") "8^业务代码重复!" 
	if $G(ID)'="" s ActionObj=##class(User.DHCPEServiceAction).%OpenId(ID)
	e  i (OldID'="")&&(Flag="1") s ActionObj=##class(User.DHCPEServiceAction).%OpenId(OldID)
	e  s ActionObj=##class(User.DHCPEServiceAction).%New()
	s ActionObj.ActionCode=ActionCode
	s ActionObj.ActionName=ActionName
	s ActionObj.ClassName=ClassName
	s ActionObj.MethodName=MethodName
	s sc=ActionObj.%Save()
	q:$$$ISERR(sc) "-200^"_$System.Status.GetErrorText(sc)
	s RowID=ActionObj.%Id()
	d ActionObj.%Close()
	q:RowID>0 "0"
	q RowID
MessageCatch
	Set $ZTrap = ""
  	Quit "-100^"_$ZError
}

/// w ##class(User.DHCPEServiceAction).Delete(1)
ClassMethod Delete(ID As %String = "")
{
	Set $ZTrap = "MessageCatch"
	q:(ID="") "业务行为ID为空!" 
	&SQL(delete from DHC_PE_ServiceAction where ID=:ID)
	q:SQLCODE'=0 SQLCODE_"^"_$g(%msg)
	q 0
MessageCatch
	Set $ZTrap = ""
  	Quit "-100^"_$ZError
}

}
