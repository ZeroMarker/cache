Class web.DHCEQResearch Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// s val="^2^aaa^1^2017-08-21^2017-08-20^qq^^3^beiz"
/// d ##class(web.DHCEQResearch).SaveData(val)
ClassMethod SaveData(val As %Library.String = "")
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)    //rowid
	s PLIST(2)=$P(val,"^",2) //EquipDR
	s PLIST(3)=$P(val,"^",3) //Name
	s PLIST(4)=$P(val,"^",4) //Type
	i $p(val,"^",5)'=""  s PLIST(5) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"date") //BeginDate
	i $p(val,"^",6)'=""  s PLIST(6) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"date") //EndDate
	s PLIST(7)=$P(val,"^",7) //UserDR
	s PLIST(8)=$P(val,"^",8) //Participant
	s PLIST(9)=$P(val,"^",9) //	Level 
	s PLIST(10)=$P(val,"^",10) //Remark

	i (rowid="")  //新增按钮操作
	{
		 &SQL(Insert Into SQLUSER.DHC_EQResearch Values :PLIST())
		 q SQLCODE
	}
	else  //更新按钮操作
	{
 
		 &SQL(Update SQLUSER.DHC_EQResearch Values :PLIST() where R_RowID = :rowid)
         q SQLCODE
	}
}

ClassMethod SaveResearch(val)
{
    Set $ZT="ERROR" //2009-08-10 党军
	TSTART //2009-08-10 党军
    s length=$l(val,"&")
	f i=1:1:length  d
	.s ResearchInfo=$p(val,"&",i)
	.s SQLCODE=..SaveData(ResearchInfo)
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

/// d ##class(%ResultSet).RunQuery("web.DHCEQResearch","GetResearch","13383")
Query GetResearch(EquipDR) As %Query(ROWSPEC = "TRowID:%String,TName:%String,TType:%String,TTypeDR:%String,TBeginDate:%String,TEndDate:%String,TUserDR:%String,TUser:%String,TLevel:%String,TParticipant:%String,TRemark:%String")
{
}

ClassMethod GetResearchExecute(ByRef qHandle As %Binary, EquipDR) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i EquipDR=""  Quit $$$OK
    s rowid=0
	f  s rowid=$o(^DHCEQResearch(0,"EquipDR",EquipDR,rowid))  quit:rowid=""  d
	.s Datalist=$g(^DHCEQResearch(rowid))
	.s TRowID = rowid	//rowid
	.s TName=$p(Datalist,"^",2)
	.s TTypeDR=$p(Datalist,"^",3)
	.s TType=$CASE(TTypeDR,"0":"科研项目","1":"论文")
	.s TBeginDate=##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",4),"date")
	.s TEndDate=##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",5),"date")
	.s TUserDR=$p(Datalist,"^",6)
	.s TUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
	.s TParticipant=$p(Datalist,"^",7)
	.s TLevel=$p(Datalist,"^",8)
	.s TRemark=$p(Datalist,"^",9)
	.d OutputRowGetResearch
	Quit $$$OK
OutputRowGetResearch
	s Data=$lb(TRowID,TName,TType,TTypeDR,TBeginDate,TEndDate,TUserDR,TUser,TLevel,TParticipant,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetResearchFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResearchExecute ]
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

ClassMethod GetResearchClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResearchExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(web.DHCEQResearch).GetOneResearchByID("1")
ClassMethod GetOneResearchByID(rowid) As %Status
{
	;new result,resultex
	s (result,resultex)=""
	i rowid=""  Quit $$$OK
	s result= ^DHCEQResearch(rowid)
	s resultex=rowid
	s resultex=resultex_"^"
	i $p(result,"^", 1)'="" d
	.s resultex=resultex_$p($g(^DHCEQResearch(rowid)),"^",1)
	s resultex=resultex_"^"
	i $p(result,"^", 2)'="" d
	.s resultex=resultex_$p($g(^DHCEQResearch(rowid)),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^", 3)'="" d
	.s resultex=resultex_$p($g(^DHCEQResearch(rowid)),"^",3)
	s resultex=resultex_"^"
	i $p(result,"^", 4)'="" d
	.s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQResearch(rowid)),"^",4),"date")
	s resultex=resultex_"^"
	i $p(result,"^", 5)'="" d
	.s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQResearch(rowid)),"^",5),"date")
	s resultex=resultex_"^"
	i $p(result,"^", 6)'="" d
	.s resultex=resultex_$p($g(^DHCEQResearch(rowid)),"^",6)
	s resultex=resultex_"^"
	i $p(result,"^", 7)'="" d
	.s resultex=resultex_$p($g(^DHCEQResearch(rowid)),"^",7)
	s resultex=resultex_"^"
	i $p(result,"^", 8)'="" d
	.s resultex=resultex_$p($g(^DHCEQResearch(rowid)),"^",8)
	s resultex=resultex_"^"
	i $p(result,"^", 9)'="" d
	.s resultex=resultex_$p($g(^DHCEQResearch(rowid)),"^",9)
	s resultex=resultex_"^"
	i $p(result,"^", 6)'="" d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQResearch(rowid)),"^",6))
	q resultex
}

/// d ##class(web.DHCEQResearch).DeleteData(3)
ClassMethod DeleteData(RowID)
{
	
	&sql(delete from SQLUSER.DHC_EQResearch where R_RowID=:RowID)
	q SQLCODE
}

ClassMethod GetType(TTypeDR)
{
	i TTypeDR=0  q "科研项目" 
	i TTypeDR=1  q "论文"
}

}
