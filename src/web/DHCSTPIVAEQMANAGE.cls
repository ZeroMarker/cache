Import SQLUser

/// /Description:配液设备管理
/// /Creator:Liang Qiang
/// /CreatDate:2010-04-28
Class web.DHCSTPIVAEQMANAGE Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Insert(Code, Desc, IP, Com) As %String
{
	 n (Code,Desc,IP,Com)
	 q:(Code="")||(Desc="")||(IP="")||(Com="") -1
	 k PLIST
	 s PLIST(2)=Code
	 s PLIST(3)=Desc
	 s PLIST(4)=IP
	 s PLIST(5)=Com
	 &sql(insert into  PIVA_EqManage values PLIST())
	 q:SQLCODE'=0 -2
	 q $p(%ROWID,$c(1))
}

ClassMethod Update(Code, Desc, IP, Com, Rowid) As %String
{
	 n (Code,Desc,IP,Com,Rowid)
	 &sql(update PIVA_EqManage set EQ_Code=:Code ,EQ_Desc=:Desc,EQ_IP=:IP,EQ_Com=:Com where  EQ_Rowid=:Rowid)
	 q:SQLCODE'=0 -1
	 q $p(%ROWID,$c(1))
}

ClassMethod Delete(Rowid) As %String
{
	 n (Rowid)
	 &sql(delete from  PIVA_EqManage where EQ_Rowid=:Rowid)
	 q:SQLCODE'=0 -1
	 q $p(%ROWID,$c(1))
}

ClassMethod GetEqInfoExecute(ByRef qHandle As %Binary) As %Status
{

    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    ;
    s eq="0"
    f  s eq=$o(^PIVAEM(eq)) q:eq=""  d
    .s code=$p(^PIVAEM(eq),"^",1)
    .s desc=$p(^PIVAEM(eq),"^",2)
    .s ip=$p(^PIVAEM(eq),"^",3)
    .s com=$p(^PIVAEM(eq),"^",4)
    .s state=$p(^PIVAEM(eq),"^",5)
    .d OutRowOrdLink
	Quit $$$OK
OutRowOrdLink
	set Data=$lb(code,desc,ip,com,state,eq)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetEqInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEqInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
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

Query GetEqInfo() As %Query(ROWSPEC = "tbCode:%String,tbDesc:%String,tbIP:%String,tbCom:%String,tbState:%String,tbRowid:%String")
{
}

ClassMethod GetEqInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEqInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Description:启动设备端口
/// Creator:Liang Qiang
/// CreatDate:2010-04-28
/// Input:设备代码,设备端口,服务器IP
ClassMethod StartEQ(code, com, ip) As %String
{
	N (code,com,ip)
	;
	b
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set CurrentNS=$ZNSPACE
	ZN MEDDATA
	;
	s Ret=$$start^DHCMIFTEST(code,com,ip)
	;
	ZN CurrentNS
	QUIT Ret
}

/// Description:停止设备端口
/// Creator:Liang Qiang
/// CreatDate:2010-04-28
/// Input:设备代码,设备端口,服务器IP
ClassMethod StopEQ(code, com, ip) As %String
{
	N (code,com,ip)
	;
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set CurrentNS=$ZNSPACE
	ZN MEDDATA
	;
	S Ret=$$stop^DHCMIFTEST(code,com,ip)
	;
	ZN CurrentNS
	QUIT Ret
}

/// Description:置启动设备后状态
/// Creator:Liang Qiang
/// CreatDate:2010-04-28
/// Input:设备管理Rowid
ClassMethod Setstate(Rowid, Flag) As %String
{
	n (Rowid,Flag)
	&sql(update PIVA_EqManage set EQ_State=:Flag  where  EQ_Rowid=:Rowid)
	q:SQLCODE'=0 -1
	q SQLCODE
	;q $p(%ROWID,$c(1))
}

}
