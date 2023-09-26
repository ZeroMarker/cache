Import SQLUser

Class web.DHCEQCServiceItem Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SI_RowID";

Parameter SQLDESCRIPTION = "SI_RowID";

Parameter SQLROWID = "SI_RowID";

ClassMethod GetServiceItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetServiceItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// modified by czf 397032 增加TRow并输出
ClassMethod GetServiceItemExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", ExTypeDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetServiceItem
	Quit $$$OK
BuildDataGetServiceItem
	Set Code=##Class(web.DHCEQCommon).UnEscape(Code)
	Set Desc=##Class(web.DHCEQCommon).UnEscape(Desc)
	f  s rowid=$o(^DHCEQCCode("DHCEQCServiceItem",rowid))  quit:rowid=""  d
	.d ResetVariablesGetServiceItem
	.s TRowID = rowid	//rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",12)
	.q:InvalidFlag="Y"
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",1)
	.q:(Desc'="")&&(TDesc'[Desc) // modified by sjh 2019-12-10 BUG00020 描述模糊查询
	.s TCode=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",2)
	.q:(Code'="")&&(TCode'=Code)
	.s TUnit=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",3)
	.i TUnit'=""  s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	.s TPrice=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",4)
	.s TExType=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",5)
	.q:(ExTypeDR'="")&&(TExType'=ExTypeDR)
	.s TExID=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",6)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",7)
	.s TImportFlag=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",8)
	.s TImportFlag=$CASE(TImportFlag,"Y":"是","N":"否","":"否") ;add by QW 2018-10-08 描述：hisui改造,Y/N改为是/否
	.s TMinMinutes=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",9)
	.s TMinutesPerTimes=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",10)
	.s TMaxMinutes=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",11)
	.s TExDesc=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",14)
	.///add by ZY0257 20210325 增加单独使用的标记输出
	.s TSingleFlag=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",15)
	.s TSingleFlag=$CASE(TSingleFlag,"Y":"是","N":"否","":"否")
	.d OutputRowGetServiceItem
	quit
OutputRowGetServiceItem
	s Data=$lb(TRowID,TDesc,TCode,TUnit,TPrice,TExType,TExID,TRemark,TImportFlag,TMinMinutes,TMinutesPerTimes,TMaxMinutes,TExDesc,TRow,TSingleFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetServiceItem
	s (TRowID,TDesc,TCode,TUnit,TPrice,TExType,TExID,TRemark,TImportFlag,TMinMinutes,TMinutesPerTimes,TMaxMinutes,TExDesc,TSingleFlag)=""
	quit
}

ClassMethod GetServiceItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetServiceItemExecute ]
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

Query GetServiceItem(Code As %String = "", Desc As %String = "", ExTypeDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String,TCode:%String,TUnit:%String,TPrice:%String,TExType:%String,TExID:%String,TRemark:%String,TImportFlag:%String,TMinMinutes:%String,TMinutesPerTimes:%String,TMaxMinutes:%String,TExDesc:%String,TRow:%String,TSingleFlag:%String")
{
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= $g(^DHCEQCCode("DHCEQCServiceItem",rowid))
	s resultex=resultex_"^"
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",3))
	s resultex=result_resultex
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n") //回车符转换为"\n"
	q rowid_"^"_resultex
}

/// w ##Class(web.DHCEQCServiceItem).SaveData("","","^2323^223^^^^^^0^^^^^^^N",2)
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	//删除按钮操作,更新InvalidFlag标识.
 	s PLIST(13)="Y"
 	&SQL(Update SQLUSER.DHC_EQCServiceItem Values :PLIST() where SI_RowID = :rowid) 
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s PLIST(2)=$P(val,"^",2) //Desc
 s desc=$P(val,"^",2)
 s PLIST(3)=$P(val,"^",3) //Code
 s code=$P(val,"^",3)
 s PLIST(4)=$P(val,"^",4) //UnitDR
 s PLIST(5)=$P(val,"^",5) //Price
 s PLIST(6)=$P(val,"^",6) //ExType
 s extype=$P(val,"^",6)
 s PLIST(7)=$P(val,"^",7) //ExID
 s exid=$P(val,"^",7)
 s PLIST(8)=$P(val,"^",8) //Remark
 s PLIST(9)=##Class(web.DHCEQCommon).TransValueFromPage($P(val,"^",9),"bool") //ImportFlag  modified by ZY287 20211218
 s PLIST(10)=$P(val,"^",10) //MinMinutes
 s PLIST(11)=$P(val,"^",11) //MinutesPerTimes
 s PLIST(12)=$P(val,"^",12) //MaxMinutes
 s PLIST(13)="N"
 s PLIST(15)=$P(val,"^",15) //ExDesc
 s PLIST(16)=$P(val,"^",16) //SingleFLag	///add by ZY0257 20210325 增加单独使用的标记
 i (rowid="")  //新增按钮操作
 {
	 //检测当前记录是否已经存在
	 i exid=""
	 {
		 &SQL(select SI_RowID into :RowidFind from DHC_EQCServiceItem where SI_InvalidFlag='N' and SI_Desc=:desc)
	 }
	 else
	 {
		 &SQL(select SI_RowID into :RowidFind from DHC_EQCServiceItem where SI_InvalidFlag='N' and SI_Desc=:desc and SI_ExType=:extype and SI_ExID=:exid)
	 }
	 i (RowidFind="") //当前记录为新记录,否则已经存在
	 {
		 &SQL(Insert Into SQLUSER.DHC_EQCServiceItem Values :PLIST())
	 }
 }
 else  //更新按钮操作
 {
	 s PLIST(14)=+$H
	 i exid=""
	 {
		 &SQL(select SI_RowID into :RowidFind from DHC_EQCServiceItem where SI_InvalidFlag='N' and SI_Desc=:desc)
	 }
	 else
	 {
		 &SQL(select SI_RowID into :RowidFind from DHC_EQCServiceItem where SI_InvalidFlag='N' and SI_Desc=:desc and SI_ExType=:extype and SI_ExID=:exid)
	 }
	 ///modified by ZY0282 20211112 增加无效数据的过滤
	 ///modified by ZY0257 20210325 增加单独使用的标记
	 s Count=0
	 if PLIST(16)="Y"
	 {
		 &SQL(select count(*) into :Count from DHC_EQEquipService where ES_ServiceDR=:rowid and ES_SourceType='1' and ES_BussType='0' and ES_InvalidFlag<>'Y')
	 }
	 if Count>1 q "-1001"
	 
	 i (RowidFind="")
	 {
		 &SQL(Update SQLUSER.DHC_EQCServiceItem Values :PLIST() where SI_RowID = :rowid)
	 }
	 else
	 {
		 i (RowidFind=rowid)
		 {
			 &SQL(Update SQLUSER.DHC_EQCServiceItem Values :PLIST() where SI_RowID = :rowid) 	 
		 }
	 }
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

/*******************************************************************************/
ClassMethod GetArcitmmastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArcitmmastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetArcitmmastExecute(ByRef qHandle As %Binary, ExDesc As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	;s subscript=0
	d BuildDataGetArcitmmast
	Quit $$$OK
BuildDataGetArcitmmast
	q:ExDesc=""
	s ExDesc=$ZCONVERT(ExDesc,"U")
	s ItemCat=0
	f  s ItemCat=$o(^ARCIM(0,"ARCIC_DR",ItemCat)) q:ItemCat=""  d
	.s ICOrderType=$p($g(^ARC("IC",ItemCat)),"^",7)
	.q:ICOrderType'="N"
	.s subscript=0
	.f  s subscript=$o(^ARCIM(0,"ARCIC_DR",ItemCat,subscript))  quit:subscript=""  d
	..s version=0
	..f  s version=$o(^ARCIM(0,"ARCIC_DR",ItemCat,subscript,version))  quit:version=""  d
	...d ResetVariablesGetArcitmmast
	...s TRowID = subscript_"||"_version	//rowid
	...s TDesc=$p($g(^ARCIM(subscript,version,1)),"^",2)
	...s AlisRowID=0
	...s Flag=0
	...f  s AlisRowID=$o(^ARC("ALIAS",0,"ARCIM",TRowID,AlisRowID))  quit:(AlisRowID="")||(Flag'=0)  d
	....s TCode=$p($g(^ARC("ALIAS",AlisRowID)),"^",6)
	....s TAlias=$p($g(^ARC("ALIAS",AlisRowID)),"^",3)
	....i (TCode[ExDesc)||(TAlias[ExDesc)  s Flag=1
	...q:(Flag=0)&&(TDesc'[ExDesc)
	...d OutputRowGetArcitmmast
	quit
OutputRowGetArcitmmast
	s Data=$lb(TDesc,TRowID,TCode,TAlias)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetArcitmmast
	s (TDesc,TRowID,TCode,TAlias)=""
	quit
}

ClassMethod GetArcitmmastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArcitmmastExecute ]
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

/// modify hly 20200319 bug:1235414
/// d ##class(%ResultSet).RunQuery("web.DHCEQCServiceItem","GetArcitmmast","")
Query GetArcitmmast(ExDesc As %String = "") As %Query(ROWSPEC = "TDesc:%String:描述,TRowID:%String:描述ID,TCode:%String:编码,TAlias:%String:扩展描述")
{
}

/*******************************************************************************/
}
