Import SQLUser

Class web.DHCEQ.Plat.CTMaintItem Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 29;

Parameter SQLCODE = "MI_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "MI_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "MI_RowID";

Parameter SQLFILTER = " (MI_InvalidFlag = 'N') ";

/*
Query LookUp(para, type) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT MI_Desc,
	   MI_RowID,
	   MI_Code
FROM sqluser.DHC_EQCMaintItem
where MI_InvalidFlag = 'N' and MI_Desc like nvl(:para,'')||'%' and MI_Type =:type
}
*/

// add by mwz 20221228 mwz0066 

Query GetMaintItem(Code As %String = "", Desc As %String = "", Type As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlag:%String,TType:%String,TCaption:%String,TItemCatDR:%String,TItemCatDesc:%String,THold1:%String,THold2:%String,THold3:%String")
{
}

ClassMethod GetMaintItemExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Type As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s index=1
	s rowid=0
	//s ^GR(0)=$lb(Code,Desc)
	for  s rowid=$o(^DHCEQCCode("DHCEQCMaintItem",rowid)) quit:rowid=""  d
	.d ResetVariablesGetMaintItem
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",1)
	.q:(Code'="")&&($ZCONVERT(TCode ,"U")'[Code)	//modified by csj 20190618
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",2)
	.q:(Desc'="")&&($ZCONVERT(TDesc ,"U")'[Desc)	//modified by csj 20190618
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",3)
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",4)
	.q:TInvalidFlag="Y"
	.s TType=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",5)
	.q:(Type'="")&&(Type'=TType)  // add by mwz 20221228 mwz0066
	.s TType=$Case(TType,"":"","1":"保养","2":"检查","3":"维修") //Type
	.s TCaption=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",6)
	.s TItemCatDR=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",7)
	.i TItemCatDR'=""   s TItemCatDesc=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",TItemCatDR)),"^",3)
	.s THold1=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",8)	//modified by csj 20190601
	.s THold2=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",9)	//modified by csj 20190601
	.s THold3=$p($g(^DHCEQCCode("DHCEQCMaintItem",rowid)),"^",10)	//modified by csj 20190601
	.d OutputRowGetMaintItem
	Quit $$$OK
OutputRowGetMaintItem
	s Data=$lb(TRowID,TCode,TDesc,TRemark,TInvalidFlag,TType,TCaption,TItemCatDR,TItemCatDesc,THold1,THold2,THold3)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintItem
	s (TRowID,TCode,TDesc,TRemark,TInvalidFlag,TType,TCaption,TItemCatDR,TItemCatDesc,THold1,THold2,THold3)=""
	quit
}

ClassMethod GetMaintItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintItemExecute ]
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

ClassMethod GetMaintItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod SaveData(val, isDel)
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	i (+isDel=1)
	{
		s PLIST(5)="Y"
		&SQL(Update sqluser.DHC_EQCMaintItem Values :PLIST() where MI_RowID = :rowid) 
		if SQLCODE  q SQLCODE
		q rowid
	} 
	s PLIST(2)=$p(val,"^",2)
	s Code=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s Desc=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)="N"	//modified by csj 20190612
	s PLIST(6)=$p(val,"^",6)	//modified by csj 20190601
	s PLIST(7)=$p(val,"^",7)
	s PLIST(8)=$p(val,"^",8)
	s PLIST(9)=$p(val,"^",9)
	s PLIST(10)=$p(val,"^",10)
	s PLIST(11)=$p(val,"^",11)

	s tmpid=""
	&SQL(select MI_RowID into :tmpid from sqluser.DHC_EQCMaintItem where MI_Code=:Code and MI_Desc=:Desc and MI_InvalidFlag!='Y')
	if ((tmpid'="")&&(tmpid'=rowid)) q -3003	;重复记录
	i (rowid="")
	{
		&SQL(Insert Into sqluser.DHC_EQCMaintItem Values :PLIST())
	} 
	else
	{
		&SQL(Update sqluser.DHC_EQCMaintItem Values :PLIST() where MI_RowID = :rowid)
	}
	if SQLCODE  q -3001
	Set ID=$g(%ROWID)
	q ID
}

ClassMethod GetOneMaintItem(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCMaintItem",rowid)
	s resultex=result_"^"	//1
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$Case($p(result,"^",5),"":"","1":"保养","2":"检查","3":"维修") //Type
	s resultex=resultex_"^"	//7
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintItemCat",$p(result,"^",7))),"^",3) //ItemCatDR

	q resultex
}

/// add by zy 2016-12-12  ZY0153  
/// 通过jquery控制列表中下拉数据集显示维护项目获取代码
/// d ##class(web.DHCEQ.Plat.CTMaintItem).GetMaintItem()
ClassMethod GetMaintItem() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM DHC_EQCMaintItem"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("MI_RowID")
		s Desc = result.Data("MI_Desc")
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEQCommon).getJsonData("val^text",tmp)
		e  d
		.W ","_##class(web.DHCEQCommon).getJsonData("val^text",tmp)
	}
	w "]"
}

}
