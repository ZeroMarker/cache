/// -------------------------------
/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：设备别名维护
/// -------------------------------
Class web.DHCEQCAlias Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 116;

Parameter SQLCODE = "A_RowID";

Parameter SQLDATEFROM = "A_DateFrom";

Parameter SQLDATETO = "A_DateTo";

Parameter SQLDESCRIPTION = "A_Desc";

Parameter SQLROWID = "A_RowID";

/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：别名查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQCAlias","GetAlias","SourceType","SourceID")
/// -------------------------------
Query GetAlias(SourceType As %String = "", SourceID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TText:%String,TDesc:%String,TSourceType:%String,TSorceID:%String,TDateFrom:%String,TDateTo:%String,TRemark:%String")
{
}

ClassMethod GetAliasExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataAlias
	Quit $$$OK
BuildDataAlias
	q:SourceType=""
	q:SourceID=""
	f  s rowid=$o(^DHCEQCCode("DHCEQCAlias",0,"SourceID",SourceType,SourceID,rowid))  quit:rowid=""  d
	.d ResetVariablesAlias
	.s TRowID = rowid	                                            //rowid
	.s TText = $p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",1)	    //代码
	.s TDesc = $p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",2)	//名称
	.s TSourceType=$p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",3)      //来源类型
	.s TSorceID=$p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",4)    //来源ID
	.s TDateFrom=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",5),"date")	//开始日期
	.s TDateTo=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",6),"date")	//结束时间
	.s TRemark= $p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",7)	//备注
	.s TInvalidFlag= $p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",8)	//可用标志
	.q:TInvalidFlag="Y"
	.d OutputRowAlias
	quit
OutputRowAlias
	s Data=$lb(TRowID,TText,TDesc,TSourceType,TSorceID,TDateFrom,TDateTo,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesAlias
	s (TRowID,TText,TDesc,TSourceType,TSorceID,TDateFrom,TDateTo,TRemark)=""
	quit
}

ClassMethod GetAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAliasExecute ]
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

ClassMethod GetAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：数据添加,修改,删除
/// 访问表:DHC_EQCAlias
/// -------------------------------
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
		
	 k PLIST,rowid
	 s rowid=$p(val,"^",1)
	 s Date=+$H
	 s PLIST(2) = $p(val,"^",2)	;Text
 	 s PLIST(3) = $p(val,"^",3)	;Desc
 	 s PLIST(4) = $p(val,"^",4) ;SourceType
 	 s PLIST(5) = $p(val,"^",5)	;SourceID
 	 s PLIST(6) = Date ;DateFrom
 	 s PLIST(8) = $p(val,"^",6) ;Remark
 	 s PLIST(9) = "N" ;InvalidFlag
	 TSTART
	 i (+isDel=0)  //新增按钮操作
	 {
		 &SQL(Insert Into SQLUSER.DHC_EQCAlias Values :PLIST())
	 }
	 i (+isDel=1)  //删除按钮操作
	 {
	 	&SQL(Update SQLUser.DHC_EQCAlias set A_InvalidFlag='Y' ,A_DateTo=:Date where A_RowID = :rowid)
	 }
	 i (+isDel=2) //更新按钮操作
	 {
		&SQL(Update SQLUSER.DHC_EQCAlias Values :PLIST() where A_RowID = :rowid)
	 } 
	 i SQLCODE
	 {
	 	TROLLBACK
	 	q SQLCODE
	 }
	 TCOMMIT
	 q SQLCODE
}

/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：根据rowid取数据
/// 访问表:DHC_EQCAlias
/// -------------------------------
ClassMethod GetDataByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	if (rowid=0)||(rowid="")  q ""
	s result= $g(^DHCEQCCode("DHCEQCAlias",rowid))
	if result="" q ""
	s resultex=resultex_"^"	;DateFrom
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",5),"date")	
	s resultex=resultex_"^"	;DateTo
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",6),"date")
	s result=rowid_"^"_result_resultex
	s result=##Class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

}
