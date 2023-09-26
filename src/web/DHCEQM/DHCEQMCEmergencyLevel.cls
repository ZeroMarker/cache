/// Modified By ZX 2013-09-24 
/// 描述:维护维修申请的紧急程度
Class web.DHCEQM.DHCEQMCEmergencyLevel Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

//Modified By HHM 20150904 HHM0006

//添加控制，不允许输入与已有数值相同的字段

//返回值添加："^UpdateMsg"、"^DeleteMsg"、"^DeleteMsg"字段

ClassMethod SaveData(val, isDel As %Library.String = "")
{
	k PLIST,RowID
    s RowID=$p(val,"^",1)
	s PLIST(2)=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s PLIST(6)="N"
	s Code=$p(val,"^",2) 
	s Desc=$p(val,"^",3) 
	i (+isDel=1)
	{
	   	&SQL(update SQLUSER.DHC_EQMCEmergencyLevel set EL_InvalidFlag='Y' where EL_RowID=:RowID)
	}
	else
	{
	  	s tmpid=""
	  	&SQL(select EL_RowID into :tmpRowID from sqluser.DHC_EQMCEmergencyLevel where EL_Code=:Code and EL_Desc=:Desc and EL_InvalidFlag!='Y')
	  	if ((tmpRowID'="")&(tmpRowID'=RowID)) q -3001
		if RowID="" 
	  	{
	    	&SQL(insert into SQLUSER.DHC_EQMCEmergencyLevel values:PLIST())
	  	}
	  	else 
	  	{
	     	&SQL(update SQLUSER.DHC_EQMCEmergencyLevel values:PLIST() where EL_RowID=:RowID)
	  	}
	}
	if SQLCODE q SQLCODE
	s ID=$g(%ROWID)
	q ID
}

/// modified by czf 406181 增加TRow并输出
Query EmergencyLevel(Code As %String = "", Desc As %String = "", Remark As %String = "", Level As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TLevel:%String,TRemark:%String,TInvalidFlage:%String,TJob:%String,TRow:%String")
{
}

ClassMethod EmergencyLevelExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "", Level As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Remark=$ZCONVERT(Remark ,"U")
 	s Level=$ZCONVERT(Level ,"U")

	s index=1
	s rowid=0
	s TRow=1
	//s TJob=$j
	
	d BuildDataGetEmergencyLevel
	
	//d ##Class(web.DHCEQCommon).SetPageInfo("DHCEQMCEmergencyLevel.EmergencyLevel",TJob,index-1)
	
	Quit $$$OK
BuildDataGetEmergencyLevel
	f  s rowid=$o(^DHCEQCCode("DHCEQMCEmergencyLevel",rowid))  quit:rowid=""  d
	.d ResetVariablesGetEmergencyLevel
	.s LTRowID = rowid	//rowid
	.s LTCode=$p($g(^DHCEQCCode("DHCEQMCEmergencyLevel",rowid)),"^",1) //代码
	.s LTDesc=$p($g(^DHCEQCCode("DHCEQMCEmergencyLevel",rowid)),"^",2) //描述
	.s LTLevel=$p($g(^DHCEQCCode("DHCEQMCEmergencyLevel",rowid)),"^",3) //级别
	.s LTRemark=$p($g(^DHCEQCCode("DHCEQMCEmergencyLevel",rowid)),"^",4) //备注
	.s LTInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCEmergencyLevel",rowid)),"^",5) //无符号标志
	.q:LTInvalidFlag="Y"
	.q:($ZCONVERT(LTCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(LTDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(LTRemark,"U")'[Remark)&(Remark'="")
	.q:($ZCONVERT(LTLevel,"U")'[Level)&(Level'="")
	.d OutputRowGetEmergencyLevel
	quit
OutputRowGetEmergencyLevel
   	s Data=$lb(LTRowID,LTCode,LTDesc,LTLevel,LTRemark,LTInvalidFlag,TJob,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetEmergencyLevel
	s (LTRowID,LTCode,LTDesc,LTLevel,LTRemark,LTInvalidFlag)=""
	quit
}

ClassMethod EmergencyLevelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmergencyLevelExecute ]
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

ClassMethod EmergencyLevelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmergencyLevelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQMCEmergencyLevel",rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCEmergencyLevel",rowid)),"^",1)
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCEmergencyLevel",rowid)),"^",2) //描述
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCEmergencyLevel",rowid)),"^",3) //备注
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCEmergencyLevel",rowid)),"^",4) //
	s resultex=resultex_"^"	
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCEmergencyLevel",rowid)),"^",5)
	q resultex
}

}
