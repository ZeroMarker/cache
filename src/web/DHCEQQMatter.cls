Class web.DHCEQQMatter Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 47;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MT_RowID";

Parameter SQLDESCRIPTION = "MT_MatterDesc";

Parameter SQLROWID = "MT_RowID";

ClassMethod UpdateData(itms As %Library.String = "", itmsex As %Library.String = "", val, Type)
{
   //0,新增
    //1，分配

    //2，受理

    //3，解决

    //4，关闭

    //
    //6,删除
    s Date=+$H
    s Time=$P($H,",",2)
    s RowID=$p(val,"^",1)
    s PLIST(6)=Type
    TSTART
	if Type=0
	{
		s PLIST(2) = $p(val,"^",2)	;ModuleDR
 		s PLIST(3) = $p(val,"^",3)	;FunctionDR
 		s PLIST(4) = $p(val,"^",4)	;MatterDesc
 		s PLIST(5) = $p(val,"^",5)	;TypeDR
 		s PLIST(9) = $p(val,"^",9)	;BringUserDR
 		s PLIST(19) = $p(val,"^",18)	;CustormDR
 		s PLIST(7)=Date
 		s PLIST(8)=Time
 		if RowID=""
 		{
	 		&SQL(insert into sqluser.DHC_EQQMatter values :PLIST())
 		}
 		else
 		{
	 		&SQL(update sqluser.DHC_EQQMatter values :PLIST() where MT_RowID=:RowID)
 		}
 		i SQLCODE 
 		{
	 		TROLLBACK
	 		q SQLCODE
 		}
 		TCOMMIT
 		s ID=$G(%ROWID)
 		q ID
	}
	if Type=1
	{
		s PLIST(13) = $p(val,"^",19)	;DutyUserDR
		s PLIST(12) = $p(val,"^",12)	;SolveUserDR
		s PLIST(20)=Date
		s PLIST(21)=Time
		&SQL(update sqluser.DHC_EQQMatter values :PLIST() where MT_RowID=:RowID)
		i SQLCODE 
 		{
	 		TROLLBACK
	 		q SQLCODE
 		}
 		TCOMMIT
 		s ID=$G(%ROWID)
 		q ID
	}
	if Type=2
	{
		s PLIST(22)=Date
		s PLIST(23)=Time
		&SQL(update sqluser.DHC_EQQMatter values :PLIST() where MT_RowID=:RowID)
		i SQLCODE 
 		{
	 		TROLLBACK
	 		q SQLCODE
 		}
 		TCOMMIT
 		s ID=$G(%ROWID)
 		q ID
	}
	if Type=3
	{
		s PLIST(15) = $p(val,"^",13)	;SolveReason
 		s PLIST(14) = $p(val,"^",14)	;SolveMethod
 		s PLIST(10)=Date
 		s PLIST(11)=Time
 		&SQL(update sqluser.DHC_EQQMatter values :PLIST() where MT_RowID=:RowID)
 		i SQLCODE 
 		{
	 		TROLLBACK
	 		q SQLCODE
 		}
 		TCOMMIT
 		s ID=$G(%ROWID)
 		q ID
	}
	if Type=4
	{
		s PLIST(16) = $p(val,"^",15)	;CloseUserDR
		s PLIST(17)=Date
		s PLIST(18)=Time
		&SQL(update sqluser.DHC_EQQMatter values :PLIST() where MT_RowID=:RowID)
		i SQLCODE 
 		{
	 		TROLLBACK
	 		q SQLCODE
 		}
 		TCOMMIT
 		s ID=$G(%ROWID)
 		q ID
	}
	if Type=6
	{
		&SQL(Delete from sqluser.DHC_EQQMatter where MT_RowID=:RowID)
		i SQLCODE 
 		{
	 		TROLLBACK
	 		q SQLCODE
 		}
 		TCOMMIT
 		q ""
	}
}

ClassMethod GetOneMatter(itms As %Library.String = "", itmsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQQ("DHCEQQMatter",rowid)
	s resultex=resultex_"^"	;ModuleDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQQ("DHCEQQModule",$p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;FunctionDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQQ("DHCEQQFunction",$p(result,"^",2))),"^",1)
	s resultex=resultex_"^"	;TypeDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQQ("DHCEQQType",$p(result,"^",4))),"^",1)
	s $p(result,"^",6)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"date") ;BringDate
	s resultex=resultex_"^"	;BringUserDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQQ("DHCEQQUser",$p(result,"^",8))),"^",1)
	s $p(result,"^",9)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date") ;SolveDate
	s resultex=resultex_"^"	;SolveUserDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_$p($g(^DHCEQQ("DHCEQQUser",$p(result,"^",11))),"^",1)
	s resultex=resultex_"^"	;CloseUserDR
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_$p($g(^DHCEQQ("DHCEQQUser",$p(result,"^",14))),"^",1)
	s $p(result,"^",15)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",15),"date")	;CloseDate
	s resultex=resultex_"^"	;CustormDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_$p($g(^DHCEQQ("DHCEQQCustorm",$p(result,"^",17))),"^",1)
	s resultex=resultex_"^"	;DutyUserDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_$p($g(^DHCEQQ("DHCEQQUser",$p(result,"^",18))),"^",1)
	s $p(result,"^",19)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",19),"date")	;AssignDate
	s $p(result,"^",21)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",21),"date")	;AcceptDate
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

Query GetMatter(ModuleDR, FunctionDR, BringUserDR, CustormDR, DutyUserDR, SolveUserDR, TypeDR, StartDate, EndDate) As %Query(ROWSPEC = "TRowID:%String,TModuleDR:%String,TFunctionDR:%String,TMatterDesc:%String,TTypeDR:%String,TStatus:%String,TBringDate:%String,TBringTime:%String,TBringUserDR:%String,TSolveDate:%String,TSolveTime:%String,TSolveUserDR:%String,TSolveReason:%String,TSolveMethod:%String,TCloseUserDR:%String,TCloseDate:%String,TCloseTime:%String,TCustormDR:%String,TDutyUserDR:%String,TAssignDate:%String,TAssignTime:%String,TAcceptDate:%String,TAcceptTime:%String,TModule:%String,TFunction:%String,TType:%String,TBringUser:%String,TSolveUser:%String,TCloseUser:%String,TCustorm:%String,TDutyUser:%String")
{
}

ClassMethod GetMatterExecute(ByRef qHandle As %Binary, ModuleDR, FunctionDR, BringUserDR, CustormDR, DutyUserDR, SolveUserDR, TypeDR, StartDate, EndDate) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetMatter
	Quit $$$OK
BuildDataGetMatter
	f  s rowid=$o(^DHCEQQ("DHCEQQMatter",rowid))  quit:rowid=""  d
	.d ResetVariablesGetMatter
	.s TRowID = rowid
	.s TModuleDR = $p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",1)
	.q:(ModuleDR'="")&&(TModuleDR'=ModuleDR)
	.i TModuleDR '=""  d
	..s TModule = $p($g(^DHCEQQ("DHCEQQModule",TModuleDR)),"^",1)
	.s TFunctionDR = $p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",2)
	.q:(FunctionDR'="")&&(TFunctionDR'=FunctionDR)
	.i TFunctionDR '=""  d
	..s TFunction = $p($g(^DHCEQQ("DHCEQQFunction",TFunctionDR)),"^",1)
	.s TMatterDesc = $p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",3)
	.s TTypeDR = $p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",4)
	.q:(TypeDR'="")&&(TTypeDR'=TypeDR)
	.i TTypeDR '=""  d
	..s TType = $p($g(^DHCEQQ("DHCEQQType",TTypeDR)),"^",1)
	.s TStatus = $p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",5)
	.s TStatus = $CASE(TStatus,"0":"激活","1":"分配","2":"受理","3":"解决","4":"关闭")
	.s TBringDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",6),"date")
	.i StartDate="" s StartDate=0
    .i EndDate="" s EndDate=+$H
    .q:($p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",6)<StartDate)!($p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",6)>EndDate)
	.s TBringTime = $p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",7)
	.s TBringUserDR = $p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",8)
	.q:(BringUserDR'="")&&(TBringUserDR'=BringUserDR)
	.i TBringUserDR '=""  d
	..s TBringUser = $p($g(^DHCEQQ("DHCEQQUser",TBringUserDR)),"^",1)
	.s TSolveDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",9),"date")
	.s TSolveTime = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",10),"time")
	.s TSolveUserDR = $p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",11)
	.q:(SolveUserDR'="")&&(TSolveUserDR'=SolveUserDR)
	.i TSolveUserDR '=""  d
	..s TSolveUser = $p($g(^DHCEQQ("DHCEQQUser",TSolveUserDR)),"^",1)
	.s TSolveReason = $p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",12)
	.s TSolveMethod = $p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",13)
	.s TCloseUserDR = $p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",14)
	.i TCloseUserDR '=""  d
	..s TCloseUser = $p($g(^DHCEQQ("DHCEQQUser",TCloseUserDR)),"^",1)
	.s TCloseDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",15),"date")
	.s TCloseTime = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",16),"time")
	.s TCustormDR = $p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",17)
	.q:(CustormDR'="")&&(TCustormDR'=CustormDR)
	.i TCustormDR '=""  d
	..s TCustorm = $p($g(^DHCEQQ("DHCEQQCustorm",TCustormDR)),"^",1)
	.s TDutyUserDR = $p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",18)
	.q:(DutyUserDR'="")&&(TDutyUserDR'=DutyUserDR)
	.i TDutyUserDR '=""  d
	..s TDutyUser = $p($g(^DHCEQQ("DHCEQQUser",TDutyUserDR)),"^",1)
	.s TAssignDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",19),"date")
	.s TAssignTime = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",20),"time")
	.s TAcceptDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",21),"date")
	.s TAcceptTime = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQQ("DHCEQQMatter",rowid)),"^",22),"time")
	.d OutputRowGetMatter
	quit
OutputRowGetMatter
	s Data=$lb(TRowID,TModuleDR,TFunctionDR,TMatterDesc,TTypeDR,TStatus,TBringDate,TBringTime,TBringUserDR,TSolveDate,TSolveTime,TSolveUserDR,TSolveReason,TSolveMethod,TCloseUserDR,TCloseDate,TCloseTime,TCustormDR,TDutyUserDR,TAssignDate,TAssignTime,TAcceptDate,TAcceptTime,TModule,TFunction,TType,TBringUser,TSolveUser,TCloseUser,TCustorm,TDutyUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMatter
	s (TRowID,TModuleDR,TFunctionDR,TMatterDesc,TTypeDR,TStatus,TBringDate,TBringTime,TBringUserDR,TSolveDate,TSolveTime,TSolveUserDR,TSolveReason,TSolveMethod,TCloseUserDR,TCloseDate,TCloseTime,TCustormDR,TDutyUserDR,TAssignDate,TAssignTime,TAcceptDate,TAcceptTime,TModule,TFunction,TType,TBringUser,TSolveUser,TCloseUser,TCustorm,TDutyUser)=""
	quit
}

ClassMethod GetMatterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMatterExecute ]
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

ClassMethod GetMatterClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMatterExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetFunction(ModuleDR) As %SQLQuery(ROWSPEC = "TDesc:%String,TRowID:%String,TInvaildFlag:%String")
{
SELECT F_Desc TDesc,
	   F_RowID TRowID,
	   F_InvaildFlag TInvaildFlag
FROM sqluser.DHC_EQQFunction
where F_ModuleDR=:ModuleDR
}

}
