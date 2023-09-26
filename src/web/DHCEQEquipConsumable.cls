Import SQLUser

Class web.DHCEQEquipConsumable Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EC_RowID";

Parameter SQLDESCRIPTION = "EC_RowID";

Parameter SQLROWID = "EC_RowID";

ClassMethod GetEquipConsumableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipConsumableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// modified by czf 397032 增加TRow并输出
ClassMethod GetEquipConsumableExecute(ByRef qHandle As %Binary, SourceTypeDR As %String = "", SourceIDDR As %String = "", ModelDR As %String = "", ResourceTypeDR As %String = "", QXType As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetEquipConsumable
	Quit $$$OK
BuildDataGetEquipConsumable
	f  s rowid=$o(^DHCEQEquipConsumable(rowid))  quit:rowid=""  d
	.d ResetVariablesGetEquipConsumable
	.s TRowID = rowid	//rowid
	.s TSourceType=$p($g(^DHCEQEquipConsumable(rowid)),"^",1)
	.q:(SourceTypeDR'="")&&(TSourceType'=SourceTypeDR)
	.s TSourceID=$p($g(^DHCEQEquipConsumable(rowid)),"^",2)
	.q:(SourceIDDR'="")&&(TSourceID'=SourceIDDR)
	.s Find=0 //2010-10-29 DJ
	.i (TSourceID'="")&&(TSourceType=1) d //设备
	..s TEquipNo=$p($g(^DHCEQEquip(TSourceID)),"^",71)
	..s StoreLoc=$p($g(^DHCEQEquip(TSourceID)),"^",67) //2010-10-29 DJ
	..i StoreLoc'=""  d
	...s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc)
	..s TSourceID=$p($g(^DHCEQEquip(TSourceID)),"^",1)
	.q:Find'=0 //2010-10-29 DJ
	.i (TSourceID'="")&&(TSourceType=2) d //设备项
	..s TSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceID)),"^",1)
	.i TSourceType'="" s TSourceType=##Class(web.DHCEQEquipService).GetEditSourceType(TSourceType)
	.s TResourceType=$p($g(^DHCEQEquipConsumable(rowid)),"^",3)
	.q:(ResourceTypeDR'="")&&(TResourceType'=ResourceTypeDR)
	.i TResourceType'=""  s TResourceType=$p($g(^DHCEQCCode("DHCEQCResourceType",TResourceType)),"^",2)
	.s TModel=$p($g(^DHCEQEquipConsumable(rowid)),"^",9)
	.q:(ModelDR'="")&&(TModel'=ModelDR)
	.i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	.s TPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquipConsumable(rowid)),"^",4))	//modified by csj 20190612
	.s TUnit=$p($g(^DHCEQEquipConsumable(rowid)),"^",5)
	.i TUnit'="" s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	.s TQuantity=$p($g(^DHCEQEquipConsumable(rowid)),"^",6)
	.s TAmount=$p($g(^DHCEQEquipConsumable(rowid)),"^",7)
	.s TRemark=$p($g(^DHCEQEquipConsumable(rowid)),"^",8)
	.d OutputRowGetEquipConsumable
	quit
OutputRowGetEquipConsumable
	s Data=$lb(TRowID,TSourceType,TSourceID,TResourceType,TPrice,TUnit,TQuantity,TAmount,TRemark,TModel,TEquipNo,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	S TRow=TRow+1
	quit
ResetVariablesGetEquipConsumable
	s (TRowID,TSourceType,TSourceID,TResourceType,TPrice,TUnit,TQuantity,TAmount,TRemark,TModel,TEquipNo)=""
	quit
}

ClassMethod GetEquipConsumableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipConsumableExecute ]
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

Query GetEquipConsumable(SourceTypeDR As %String = "", SourceIDDR As %String = "", ModelDR As %String = "", ResourceTypeDR As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TResourceType:%String,TPrice:%String,TUnit:%String,TQuantity:%String,TAmount:%String,TRemark:%String,TModel:%String,TEquipNo:%String,TRow:%String")
{
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= $g(^DHCEQEquipConsumable(rowid))
	s $p(result,"^",4)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",4))	//modified by csj 20190612
	s resultex=resultex_"^"
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_##Class(web.DHCEQEquipService).GetEditSourceType($p(result,"^",1))
	s resultex=resultex_"^"
	i ($p(result,"^",2)'="")&&($p(result,"^",1)=1)  d //设备
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",2))),"^",1)
	i ($p(result,"^",2)'="")&&($p(result,"^",1)=2)  d //设备项
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",2))),"^",1)
	s resultex=resultex_"^"
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCResourceType",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",5))
	s resultex=resultex_"^"
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",9))),"^",2)
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
 	&SQL(Delete From SQLUSER.DHC_EQEquipConsumable where EC_RowID = :rowid) 
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s PLIST(2)=$P(val,"^",2) //SourceType
 s SourceType=$P(val,"^",2)
 s PLIST(3)=$P(val,"^",3) //SourceID
 s SourceID=$P(val,"^",3)
 s PLIST(4)=$P(val,"^",4) //ResourceTypeDR
 s ResourceTypeDR=$P(val,"^",4)
 s PLIST(5)=$P(val,"^",5) //Price
 s PLIST(6)=$P(val,"^",6) //UnitDR
 s PLIST(7)=$P(val,"^",7) //Quantity
 s PLIST(8)=$P(val,"^",8) //Amount
 s PLIST(9)=$P(val,"^",9) //Remark
 s PLIST(10)=$P(val,"^",10) //ModelDR
 s Model=$P(val,"^",10)
 s RowidFind=""
 //检测当前记录是否已经存在
 s ECRowID=0
 f  s ECRowID=$o(^DHCEQEquipConsumable(0,"Resource",ResourceTypeDR,SourceType,SourceID,ECRowID))  q:(ECRowID="")||(RowidFind'="")  d
 .i SourceType=2  d
 ..s ModelDR=$p($g(^DHCEQEquipConsumable(ECRowID)),"^",9)
 ..i (ModelDR=Model)||(ModelDR="") s RowidFind=ECRowID
 .e  d
 ..s RowidFind=ECRowID
 i (rowid="")&&(RowidFind'="") q ""
 i (rowid'="")&&(RowidFind'="")&&(RowidFind'=rowid) q ""
 i (rowid="")  //新增按钮操作
 {
	 &SQL(Insert Into SQLUSER.DHC_EQEquipConsumable Values :PLIST())
 }
 else  //更新按钮操作
 {
	 i (RowidFind="")
	 {
		 &SQL(Update SQLUSER.DHC_EQEquipConsumable Values :PLIST() where EC_RowID = :rowid)
	 }
	 else
	 {
		 i (RowidFind=rowid)
		 {
			 &SQL(Update SQLUSER.DHC_EQEquipConsumable Values :PLIST() where EC_RowID = :rowid) 	 
		 }
	 }
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

/***********************************************************************/
ClassMethod GetResourceTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResourceTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetResourceTypeExecute(ByRef qHandle As %Binary, ResoueceType As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetResourceType
	Quit $$$OK
BuildDataGetResourceType
	f  s rowid=$o(^DHCEQCCode("DHCEQCResourceType",rowid))  quit:rowid=""  d
	.d ResetVariablesGetResourceType
	.s TRowID = rowid	//rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",4)
	.q:InvalidFlag="Y"
	.s TCode=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",1)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",2)
	.q:(ResoueceType'="")&&(TCode'[ResoueceType)&&(TDesc'[ResoueceType)
	.s TType=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",5)
	.s TType=##Class(web.DHCEQCommon).GetEditResourceType(TType)
	.s TPrice=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",6)
	.i TPrice'="" s TPrice=##class(web.DHCEQCommon).FormatNumber(TPrice,"") //add by wl 2019-09-12  1025419  
	.s TUnitDR=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",7)
	.i TUnitDR'=""  s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.d OutputRowGetResourceType
	quit
OutputRowGetResourceType
	s Data=$lb(TDesc,TRowID,TCode,TType,TPrice,TUnitDR,TUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetResourceType
	s (TDesc,TRowID,TCode,TType,TPrice,TUnitDR,TUnit)=""
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

/// modified by sjh SJH0036 2020-20-13 输出列标题修改
Query GetResourceType(ResoueceType As %String = "") As %Query(ROWSPEC = "TDesc:%String:描述,Hidden:%String,TCode:%String:编码,TType:%String:类型,TPrice:%String:单价,Hidden:%String,TUnit:%String:单位")
{
}

/***********************************************************************/
}
