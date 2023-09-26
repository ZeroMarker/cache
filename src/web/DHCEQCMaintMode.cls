Import SQLUser

Class web.DHCEQCMaintMode Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 5;

//维修方式

Parameter SQLCODE = "MM_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "MM_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "MM_RowID";

Parameter SQLFILTER = " (MM_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT MM_Desc,
	   MM_RowID,
	   MM_Code
FROM sqluser.DHC_EQCMaintMode
where MM_InvalidFlag = 'N' and MM_Desc like nvl(:para,'')||'%'
}

ClassMethod MaintModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintModeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod MaintModeExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetMaintMode
	Quit $$$OK
BuildDataGetMaintMode
	f  s rowid=$o(^DHCEQCCode("DHCEQCMaintMode",rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaintMode
	.s LTRowID = rowid	//rowid
	.s LTCode = $p($g(^DHCEQCCode("DHCEQCMaintMode",rowid)),"^",1)	//代码
	.s LTDesc = $p($g(^DHCEQCCode("DHCEQCMaintMode",rowid)),"^",2)	//描述
	.s LTRemark = $p($g(^DHCEQCCode("DHCEQCMaintMode",rowid)),"^",3)	//备注
	.s YLTType= $p($g(^DHCEQCCode("DHCEQCMaintMode",rowid)),"^",4)	//类型
	.i YLTType="1" s LTType="自修"
	.i YLTType="2" s LTType="委外维修"
	.i YLTType="3" s LTType="保修"
	.s LTInvalidFlag = $p($g(^DHCEQCCode("DHCEQCMaintMode",rowid)),"^",5) //无效标志
	.q:(LTInvalidFlag="Y") 
	.d OutputRowGetMaintMode
	quit
OutputRowGetMaintMode
	s Data=$lb(LTRowID,LTCode,LTDesc,LTRemark,LTType,LTInvalidFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintMode
	s (LTRowID,LTCode,LTDesc,LTRemark,LTType,LTInvalidFlag)=""
	quit
}

ClassMethod MaintModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintModeExecute ]
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

Query MaintMode() As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TType:%String,TInvalidFlag:%String")
{
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCMaintMode",rowid)
	s resultex=rowid
	s resultex=resultex_"^"	//结果
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintMode",rowid)),"^",1)
	s resultex=resultex_"^"	//类型
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintMode",rowid)),"^",2)
	s resultex=resultex_"^"	//单位代码
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintMode",rowid)),"^",3)
	s resultex=resultex_"^"	//单位代码
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintMode",rowid)),"^",4)
	s resultex=resultex_"^"	//单位代码
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintMode",rowid)),"^",5)
	s resultex=##Class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
	q resultex
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
	 s PLIST(6) = "Y"
    &SQL(Update SQLUSER.DHC_EQCMaintMode Values :PLIST() where MM_RowID = :rowid) 	 	 
 	//&SQL(Delete From SQLUSER.DHC_EQCMaintMode where MM_RowID = :rowid)
 	if SQLCODE  q SQLCODE
 	q rowid
 } 
 ;i $p(val,"^",2)'="" 
  s PLIST(2) = $p(val,"^",2)	;结果
 ;i $p(val,"^",3)'=""  
 s PLIST(3) = $p(val,"^",3)	;类型
  s PLIST(4) = $p(val,"^",4)	;类型
  s PLIST(5) = $p(val,"^",5)	;类型
 i (+isDel=2)
 {
	  s PLIST(6) = "N"
 	&SQL(Insert Into SQLUSER.DHC_EQCMaintMode Values :PLIST())
 	if SQLCODE  q SQLCODE
 	Set ID=$g(%ROWID)
 q ID
 } 
 if (rowid'="") 
 {
	  s PLIST(6) = "N"
 	 &SQL(Update SQLUSER.DHC_EQCMaintMode Values :PLIST() where MM_RowID = :rowid) 	 
 }
 else
 {	 
 	 s PLIST(6) = "N"
	 &SQL(Insert Into SQLUSER.DHC_EQCMaintMode Values :PLIST())
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

ClassMethod Type(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=> </option>"
	w "<option value=1>自修</option>"
	w "<option value=2>委外维修</option>"
	w "<option value=3>保修</option>"
	w "</select>",!
}

}
