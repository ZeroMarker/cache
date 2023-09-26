Class web.DHCEQOpenCheckItem Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 340;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OCI_RowID";

Parameter SQLDESCRIPTION = "OCI_RowID";

Parameter SQLROWID = "OCI_RowID";

ClassMethod GetOpenCheckItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpenCheckItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOpenCheckItemExecute(ByRef qHandle As %Binary, RowID) As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetOpenCheckItem
	Quit $$$OK
BuildDataGetOpenCheckItem
	f  s rowid=$o(^DHCEQOpenCheckItem(0,"OpenCheckRequest", RowID, rowid))  quit:rowid=""  d
	.d ResetVariablesGetOpenCheckItem
	.s TRowID = rowid	//rowid
	.s TNormalFlag=$p($g(^DHCEQOpenCheckItem(rowid)),"^", 6) //2009-08-06 党军 DJ0022
	.s TCheckItem=$p($g(^DHCEQOpenCheckItem(rowid)),"^", 2)
	.i TCheckItem'="" s TCheckItem=$p($g(^DHCEQCCode("DHCEQCCheckItem",TCheckItem)),"^", 2)
	.s TCheckContent=$p($g(^DHCEQOpenCheckItem(rowid)),"^", 3)
	.s TCheckResult=$p($g(^DHCEQOpenCheckItem(rowid)),"^", 4)
	.i TCheckResult'="" s TCheckResult=$p($g(^DHCEQCCode("DHCEQCCheckResult",TCheckResult)),"^", 2)
	.s TCheckResultRemark=$p($g(^DHCEQOpenCheckItem(rowid)),"^", 5)
	.s TUser=$p($g(^DHCEQOpenCheckItem(rowid)),"^", 8)
	.s TDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckItem(rowid)),"^", 9),"date")
	.;s TTime=$ZT($p($g(^DHCEQOpenCheckItem(rowid)),"^", 10))
	.;日期格式统一调整   modify by jyp  2017-03-02
	.s TTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckItem(rowid)),"^", 10),"date")
	.d OutputRowGetOpenCheckItem
	quit
OutputRowGetOpenCheckItem
	s Data=$lb(TRowID,TCheckItem,TCheckContent,TCheckResult,TCheckResultRemark,TUser,TDate,TTime,TNormalFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOpenCheckItem
	s (TRowID,TCheckItem,TCheckContent,TCheckResult,TCheckResultRemark,TUser,TDate,TTime,TNormalFlag)=""
	quit
}

ClassMethod GetOpenCheckItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpenCheckItemExecute ]
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

Query GetOpenCheckItem(RowID) As %Query(ROWSPEC = "TRowID:%String,TCheckItem:%String,TCheckContent:%String,TCheckResult:%String,TCheckResultRemark:%String,TUser:%String,TDate:%String,TTime:%String,TNormalFlag:%String")
{
}

/********************************************************************************/
ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQOpenCheckItem(rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckItem(rowid)),"^",2) //验收项目DR
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCCheckItem",$p($g(^DHCEQOpenCheckItem(rowid)),"^",2))),"^",2) //验收项目名称
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckItem(rowid)),"^",3) //验收内容
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckItem(rowid)),"^",4) //验收结果DR
	s resultex=resultex_"^"	//5
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCCheckResult",$p($g(^DHCEQOpenCheckItem(rowid)),"^",4))),"^",2) //验收结果名称
	s resultex=resultex_"^"	//6
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckItem(rowid)),"^",5) //验收结果备注
	s resultex=resultex_"^"	//7
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckItem(rowid)),"^",8) //验收人员
	s resultex=resultex_"^"	//8
	;i $p(result,"^",9)'=""  d
    s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckItem(rowid)),"^",9),"date") //验收日期
	s resultex=resultex_"^"	//9
	;i $p(result,"^",10)'=""  d
	;.s resultex=resultex_$ZT($p($g(^DHCEQOpenCheckItem(rowid)),"^",10)) //验收时间
	;日期格式统一调整   modify by jyp  2017-03-02
	s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckItem(rowid)),"^",10),"time")
	s resultex=resultex_"^"	//10 2009-08-06 党军 begin DJ0022
	;i $p(result,"^",6)'="" d
	s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"bool") //正常标识 2009-08-06 党军 end
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n") //回车符转换为"\n"
	q resultex
}

/********************************************************************************/
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	//删除按钮操作.
 	&SQL(Delete From SQLUSER.DHC_EQOpenCheckItem where OCI_RowID = :rowid) //2009-08-06 党军 DJ0022
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s PLIST(2) = $p(val,"^",2)	//批量验收RowID
 s OCRRowID = $p(val,"^",2)
 s PLIST(3) = $p(val,"^",3)	//验收项目
 s OCIItem = $p(val,"^",3)
 s PLIST(4) = $p(val,"^",4) //验收内容
 s PLIST(5) = $p(val,"^",5) //验收结果
 s PLIST(6) = $p(val,"^",6) //验收结果备注
 s PLIST(7) = $p(val,"^",10) //正常标识 2009-08-06 党军 DJ0022
 s PLIST(9) = $p(val,"^",7) //验收人员
 s PLIST(10) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"date")
 ;i $p(val,"^",9)'="" s PLIST(11) = $ZTH($p(val,"^",9))
 ;日期格式统一调整   modify by jyp  2017-03-02
 s PLIST(11)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",9),"time")
 i (rowid="")  //新增按钮操作
 {
	 //检测当前记录时候已经存在
	 &SQL(select OCI_RowID into :RowidFind from SQLUSER.DHC_EQOpenCheckItem where OCI_OpenCheckRequestDR=:OCRRowID and OCI_CheckItemDR=:OCIItem)
	 i (RowidFind="") //当前记录为新记录,否则已经存在
	 {
		 &SQL(Insert Into SQLUSER.DHC_EQOpenCheckItem Values :PLIST())
	 }
 }
 else  //更新按钮操作
 {
	 &SQL(select OCI_RowID into :RowidFind from SQLUSER.DHC_EQOpenCheckItem where OCI_OpenCheckRequestDR=:OCRRowID and OCI_CheckItemDR=:OCIItem)
	 i (RowidFind="")
	 {
		 &SQL(Update SQLUSER.DHC_EQOpenCheckItem Values :PLIST() where OCI_RowID = :rowid)
	 }
	 else
	 {
		 i (RowidFind=rowid)
		 {
			 &SQL(Update SQLUSER.DHC_EQOpenCheckItem Values :PLIST() where OCI_RowID = :rowid) 	 
		 }
	 }
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

/******************************************************************************/
}
