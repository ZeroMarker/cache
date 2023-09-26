Class web.DHCEQMaintUserList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 增加、修改数据
ClassMethod SaveList(ListInfo)
{
	n Plist,RowID
	k Plist
	s RowID=$P(ListInfo,"^",1)
	s Plist(1)=$P(ListInfo,"^",1) ;rowid
	s Plist(2)=$P(ListInfo,"^",2) ;SourceType/业务类型(暂定为1)
	s Plist(3)=$P(ListInfo,"^",3) ;SourceID/业务ID(指向BuyRequest)
	s Plist(4)=$P(ListInfo,"^",4) ;UserID
	s Plist(5)=$P(ListInfo,"^",5) ;WorkHour
	s Plist(6)=$P(ListInfo,"^",6) ;Hold1
	s Plist(7)=$P(ListInfo,"^",7) ;Hold2
	s Plist(8)=$P(ListInfo,"^",8) ;Hold3
	s Plist(9)=$P(ListInfo,"^",9) ;Hold4
	s Plist(10)=$P(ListInfo,"^",10) ;Hold5
	if RowID=""
	{
		&SQL(insert into sqluser.DHC_EQMaintUserList values :Plist())
		q SQLCODE
	}
	else
	{
		&SQL(update sqluser.DHC_EQMaintUserList values :Plist() where MUL_RowID=:RowID)
		q SQLCODE
	}
}

/// w ##Class(web.DHCEQMaintUserList).SaveData("1^1^1^1^6^^^^^&2^1^1^2^7^^^^^&3^1^1^6^8^^^^^")
ClassMethod SaveData(val)
{
    Set $ZT="ERROR" //2009-08-10 党军
	TSTART //2009-08-10 党军
	s SQLCODE=0
    s length=$l(val,"&")
	f i=1:1:length  d
	.q:SQLCODE'=0
	.s ListInfo=$p(val,"&",i)
	.s SQLCODE=##Class(web.DHCEQMaintUserList).SaveList(ListInfo)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
    q SQLCODE
    
ERROR 
	Set ErrorMsg=$ZE	          
	TROLLBACK		      
	Quit "<ERROR>"_ErrorMsg
}

/// 根据rowid号删除数据
ClassMethod DeleteData(RowID)
{
	if RowID'=""
	{
		&SQL(delete FROM sqluser.DHC_EQMaintUserList where MUL_RowID=:RowID)
		q SQLCODE
	}
	q "删除失败"
}

/// 根据索引IndexBIBuyRequestDR查找数据
/// d ##Class(%ResultSet).RunQuery("web.DHCEQMaintUserList","GetMaintUserList","31","134")
/// Modefiedy by ZC0041 2018-10-29 添加输出TTypeDesc
Query GetMaintUserList(SourceType As %String = "", SourceID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TUserID:%String,TUser:%String,TWorkHour:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TTypeDesc:%String")
{
}

ClassMethod GetMaintUserListExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "") As %Status
{
	new repid,index,rowid
	set repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	i (SourceType="")||(SourceID="") Quit $$$OK
	i '$Data(^DHCEQMaintUserList(0,"Source",SourceType,SourceID)) Quit $$$OK
	s index=1	
	s rowid=0
	f  s rowid=$o(^DHCEQMaintUserList(0,"Source",SourceType,SourceID,rowid)) q:rowid=""  d
	.s BillItemInfo=$g(^DHCEQMaintUserList(rowid))
	.s TRowID=rowid
	.s TSourceType=$P(BillItemInfo,"^",1)
	.s TSourceID=$P(BillItemInfo,"^",2)
	.s TUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",$P(BillItemInfo,"^",3))   /// Modefiedy by ZC0041 2018-10-29
	.s TUser=##Class(web.DHCEQCommon).getMapIDBySource("usernamne",$P(BillItemInfo,"^",3))  /// Modefiedy by ZC0041 2018-10-29
	.s TWorkHour=$P(BillItemInfo,"^",4)  
	.s THold1=$P(BillItemInfo,"^",5)
	.s TTypeDesc=$case(THold1,"":"","1":"临时","2":"正式","3":"指导","4":"其他")  ///Modefiedy by ZC0041 2018-10-29
	.s THold2=$P(BillItemInfo,"^",6)
	.s THold3=$P(BillItemInfo,"^",7)
	.s THold4=$P(BillItemInfo,"^",8)
	.s THold5=$P(BillItemInfo,"^",9)
	.d OutputRowGetMaintUserList
	Quit $$$OK
OutputRowGetMaintUserList
	s Data=$lb(TRowID,TSourceType,TSourceID,TUserID,TUser,TWorkHour,THold1,THold2,THold3,THold4,THold5,TTypeDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetMaintUserListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintUserListExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		s AtEnd=1
		s Row=""
	}
	else
	{
		set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMaintUserListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintUserListExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	Quit $$$OK
}

/// Modefiedy by ZC0041 2018-10-29
/// 获取维修工程师json字符串
/// d ##Class(web.DHCEQMaintUserList).GetMaintUser()
ClassMethod GetMaintUser() As %String
{
	s count=0
	s info=""
	s rowid=0
	w "["
	f  s rowid=$o(^DHCEQCCode("DHCEQMCMaintGroupList",rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",6)="Y"
	.q:$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",5)="Y"
	.q:1=##Class(web.DHCEQCommon).Find(info,$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",2),"Y")
	.i info="" d
	..s info=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",2)
	.e  d
	..s info=info_","_$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",2)
	.s tmp=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",2)_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",2))    //modified by wy 2021-8-24 2139902
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCEQCommon).getJsonData("id^text",tmp)
	.e  d
	..W ","_##class(web.DHCEQCommon).getJsonData("id^text",tmp)
	
	w "]"
}

Storage Default
{
<Data name="DHCEQMaintUserListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQMaintUserListD</DataLocation>
<DefaultData>DHCEQMaintUserListDefaultData</DefaultData>
<IdLocation>^web.DHCEQMaintUserListD</IdLocation>
<IndexLocation>^web.DHCEQMaintUserListI</IndexLocation>
<StreamLocation>^web.DHCEQMaintUserListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
