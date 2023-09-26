Import SQLUser

Class web.DHCEQCResourceType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1;

ClassMethod GetResourceTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResourceTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// modified by czf 397032 增加TRow并输出  
/// modify by wl 2020-2-3 增加TFixedFlag
ClassMethod GetResourceTypeExecute(ByRef qHandle As %Binary, TypeDR As %String = "", Code As %String = "", Desc As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetResourceType
	Quit $$$OK
BuildDataGetResourceType
	Set Code=##Class(web.DHCEQCommon).UnEscape(Code)
	Set Desc=##Class(web.DHCEQCommon).UnEscape(Desc)
	f  s rowid=$o(^DHCEQCCode("DHCEQCResourceType",rowid))  quit:rowid=""  d
	.d ResetVariablesGetResourceType
	.s TRowID = rowid	//rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",4)
	.q:InvalidFlag="Y"
	.s TCode=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",1)
	.q:(Code'="")&&(TCode'=Code)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",2)
	.q:(Desc'="")&&(TDesc'=Desc)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",3)
	.s TType=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",5)
	.q:(TypeDR'="")&&(TType'=TypeDR)
	.i TType'="" s TType=##Class(web.DHCEQCommon).GetEditResourceType(TType)
	.s TPrice=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",6)
	.s TPrice=##Class(web.DHCEQCommon).FormatNumber(TPrice,"",2)
	.s TUnit=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",7)
	.i TUnit'=""  s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	.s TFixedFlag=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",10) //modify by wl 2020-2-3
	.d OutputRowGetResourceType
	quit
OutputRowGetResourceType
	s Data=$lb(TRowID,TDesc,TCode,TType,TPrice,TUnit,TRemark,TRow,TFixedFlag) //modify by wl 2020-2-3
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetResourceType
	s (TRowID,TDesc,TCode,TType,TPrice,TUnit,TRemark)=""
	quit
}

ClassMethod GetResourceTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResourceTypeExecute ]
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

Query GetResourceType(TypeDR As %String = "", Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String,TCode:%String,TType:%String,TPrice:%String,TUnit:%String,TRemark:%String,TRow:%String,TFixedFlag:%String")
{
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	
	s result= $g(^DHCEQCCode("DHCEQCResourceType",rowid))
	s resultex=resultex_"^"
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",7))
	s resultex=resultex_"^"
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetEditResourceType($p(result,"^",5))
	//add hly 2019-04-16
	s resultex=resultex_"^"
	i $P(result,"^",6)'="" d
	.s resultex=resultex_##Class(web.DHCEQCommon).FormatNumber($P(result,"^",6),"",2)
	s resultex=result_resultex
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n") //回车符转换为"\n"
	q rowid_"^"_resultex
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	//删除按钮操作,更新InvalidFlag标识.
 	s PLIST(5)="Y"
 	&SQL(Update SQLUSER.DHC_EQCResourceType Values :PLIST() where RT_RowID = :rowid) 
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s PLIST(2)=$P(val,"^",2) //Code
 s code=$P(val,"^",2)
 s PLIST(3)=$P(val,"^",3) //Desc
 s desc=$P(val,"^",3)
 s PLIST(4)=$P(val,"^",4) //Remark
 s PLIST(5)="N"
 s PLIST(6)=$P(val,"^",5) //Type
 s PLIST(7)=$P(val,"^",6) //Price
 s PLIST(8)=$P(val,"^",7) //Unit
 i $p(val,"^",8)'=""  s PLIST(11) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"bool") //RTFixedFlag  modify by wl 2020-2-3
 i (rowid="")  //新增按钮操作
 {
	 //检测当前记录是否已经存在
	 &SQL(select RT_RowID into :RowidFind from DHC_EQCResourceType where RT_InvalidFlag='N' and RT_Desc=:desc)
	 i (RowidFind="") //当前记录为新记录,否则已经存在
	 {
		 &SQL(Insert Into SQLUSER.DHC_EQCResourceType Values :PLIST())
	 }
 }
 else  //更新按钮操作
 {
	 &SQL(select RT_RowID into :RowidFind from DHC_EQCResourceType where RT_InvalidFlag='N' and RT_Desc=:desc)
	 i (RowidFind="")
	 {
		 &SQL(Update SQLUSER.DHC_EQCResourceType Values :PLIST() where RT_RowID = :rowid)
	 }
	 else
	 {
		 i (RowidFind=rowid)
		 {
			 &SQL(Update SQLUSER.DHC_EQCResourceType Values :PLIST() where RT_RowID = :rowid) 	 
		 }
	 }
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT RT_Desc,
	   RT_RowID,
	   RT_Code
FROM sqluser.DHC_EQCResourceType
where RT_InvalidFlag = 'N' and RT_Desc like nvl(:para,'')||'%'
}

/// add by ZY0208
/// 在设置界面用于自动扩展成本类型列
/// W ##Class(web.DHCEQCResourceType).GetAllResourceType()
ClassMethod GetAllResourceType()
{
	new result,resultex,rowid
	s (result,resultex,rowid)=""
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCResourceType",rowid))  quit:rowid=""  d
	.s result= $g(^DHCEQCCode("DHCEQCResourceType",rowid))
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",4)
	.q:InvalidFlag="Y"
	.s result=$PIECE(result,"^",1,2)
	.s result=rowid_"^"_result
	.i resultex=""  d
	..s resultex=result
	.e  d
	.. s resultex=resultex_"&"_result
	q resultex
}

}
