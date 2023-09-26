Class web.DHCEQBuyReqListAlter Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCEQBuyReqListAlter).SaveData("^1^Name^2^Model^3^ManuFactory^true^^^^^")
ClassMethod SaveData(val, MainID, isDel)
{
	new Length,i,Flag
	k PLIST
	if +isDel=1
	{
		i val="" q 0
		&SQL(delete from SQLUSER.DHC_EQBuyReqListAlter where BRLA_RowID = :val)
		q SQLCODE
	}
	else
	{
		i (val="")||(MainID="") q 0
		s Length=$l(val,"&")
		s Flag=0
		for i=1:1:Length
		{
			q:Flag=1
			Set PLIST(1) = $p(val,"^",1)	//RowID
			Set PLIST(2) = MainID			//BuyReqListDR
			Set PLIST(3) = $p(val,"^",3)	//Name
			Set PLIST(4) = $p(val,"^",4)	//ModelDR
			Set PLIST(5) = $p(val,"^",5)	//Model
			Set PLIST(6) = $p(val,"^",6)	//ManuFactoryDR
			Set PLIST(7) = $p(val,"^",7)	//ManuFactory
			Set PLIST(8) = $p(val,"^",8)	//FirstFlag
			If PLIST(8)'="" Set PLIST(8) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"bool")
			Set PLIST(9) = $p(val,"^",9)	//Hold1
			Set PLIST(10) = $p(val,"^",10)	//Hold2
			Set PLIST(11) = $p(val,"^",11)	//Hold3
			Set PLIST(12) = $p(val,"^",12)	//Hold4
			Set PLIST(13) = $p(val,"^",13)	//Hold5
			if PLIST(1)=""
			{
				&SQL(Insert Into SQLUSER.DHC_EQBuyReqListAlter Values :PLIST())
			}
			else
			{
				&SQL(Update SQLUSER.DHC_EQBuyReqListAlter Values :PLIST() where BRLA_RowID = :PLIST(1))
			}
			i SQLCODE=100 s SQLCODE=0
			i SQLCODE'=0 s Flag=1
		}
		q Flag
	}
}

/// 创建：Mozy 2012-12-24 zy 
/// 描述：设备采购申请中的备选设备信息
/// 访问表:DHC_EQBuyReqListAlter
/// 输入：BuyReqListDR：采购申请明细ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQBuyReqListAlter","GetBuyReqListAlter","1")
Query GetBuyReqListAlter(BuyReqListDR) As %Query(ROWSPEC = "TRowID:%String,TName:%String,TModelDR:%String,TModel:%String,TManuFactoryDR:%String,TManuFactory:%String,TFirstFlag:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod GetBuyReqListAlterExecute(ByRef qHandle As %Binary, BuyReqListDR) As %Status
{
 	new repid, index,rowid,flag
	Set repid=$I(^CacheTemp)
 	Set qHandle=$ListBuild(0,repid,0)
	Set index=1
	i BuyReqListDR="" Quit $$$OK
	Set rowid=0
	For  Set rowid=$Order(^DHCEQBuyReqListAlter(0,"BuyReqListDR",BuyReqListDR,rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetBuyReqListAlter
	.s TRowID=rowid
	.s TName=$Piece($Get(^DHCEQBuyReqListAlter(rowid)),"^",2)
	.s TModelDR=$Piece($Get(^DHCEQBuyReqListAlter(rowid)),"^",3)
	.s TModel=$Piece($Get(^DHCEQBuyReqListAlter(rowid)),"^",4)
	.s TManuFactoryDR=$Piece($Get(^DHCEQBuyReqListAlter(rowid)),"^",5)
	.s TManuFactory=$Piece($Get(^DHCEQBuyReqListAlter(rowid)),"^",6)
	.s TFirstFlag=$Piece($Get(^DHCEQBuyReqListAlter(rowid)),"^",7)
	.i TFirstFlag'="" s TFirstFlag=##Class(web.DHCEQCommon).TransValueToPage(TFirstFlag,"bool")
	.s THold1=$Piece($Get(^DHCEQBuyReqListAlter(rowid)),"^",8)
	.s THold2=$Piece($Get(^DHCEQBuyReqListAlter(rowid)),"^",9)
	.s THold3=$Piece($Get(^DHCEQBuyReqListAlter(rowid)),"^",10)
	.s THold4=$Piece($Get(^DHCEQBuyReqListAlter(rowid)),"^",11)
	.s THold5=$Piece($Get(^DHCEQBuyReqListAlter(rowid)),"^",12)
	.d OutputRowGetBuyReqListAlter
	Quit $$$OK
	
ResetVariablesGetBuyReqListAlter
	Set (TRowID,TName,TModelDR,TModel,TManuFactoryDR,TManuFactory,TFirstFlag,THold1,THold2,THold3,THold4,THold5)=""
	Quit
OutputRowGetBuyReqListAlter
	Set Data=$ListBuild(TRowID,TName,TModelDR,TModel,TManuFactoryDR,TManuFactory,TFirstFlag,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod GetBuyReqListAlterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyReqListAlterExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$ListBuild(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetBuyReqListAlterClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyReqListAlterExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDataByID(rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQBuyReqListAlter(rowid)
	i $p(result,"^",7)'=""  d
	.s $p(result,"^",7)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"bool")
	q result
}

}
