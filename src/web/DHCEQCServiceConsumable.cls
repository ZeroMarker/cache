Import SQLUser

/// modified by ZY0276 20210713  合入李苗苗在东风总医院做的检查部位的功能
/// -------------------------------------------------
/// Modefied by zc 2014-11-04
/// 修改位置:GetServiceConsumable
/// 描述:添加Type和TType参数
/// -------------------------------------------------
Class web.DHCEQCServiceConsumable Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SIC_RowID";

Parameter SQLDESCRIPTION = "SIC_RowID";

Parameter SQLROWID = "SIC_RowID";

ClassMethod GetServiceConsumableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetServiceConsumableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// modified by czf 397032 增加TRow并输出
/// modified by sjh  2020-01-20 增加TBussType并输出
ClassMethod GetServiceConsumableExecute(ByRef qHandle As %Binary, SourceTypeDR As %String = "", SourceIDDR As %String = "", ModelDR As %String = "", ServiceItemDR As %String = "", ConsumableItemDR As %String = "", QXType As %String = "", Type As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetServiceConsumable
	Quit $$$OK
BuildDataGetServiceConsumable
	f  s rowid=$o(^DHCEQCCode("DHCEQCServiceConsumable",rowid))  quit:rowid=""  d
	.d ResetVariablesGetServiceConsumable
	.s TRowID = rowid	//rowid
	.s TSourceType=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",1)
	.q:(SourceTypeDR'="")&&(TSourceType'=SourceTypeDR)
	.s TSourceID=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",2)
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
	.s TServiceItem=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",3)
	.q:(ServiceItemDR'="")&&(TServiceItem'=ServiceItemDR)
	.i TServiceItem'="" s TServiceItem=$p($g(^DHCEQCCode("DHCEQCServiceItem",TServiceItem)),"^",1)	
	.s TConsumableItem=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",4)
	.q:(ConsumableItemDR'="")&&(TConsumableItem'=ConsumableItemDR)
	.i TConsumableItem'=""  s TConsumableItem=$p($g(^DHCEQCCode("DHCEQCConsumableItem",TConsumableItem)),"^",1)
	.s TUnit=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",5)
	.i TUnit'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	.s TQuantity=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",6)
	.s TQuantity=##class(web.DHCEQCommon).FormatNumber(TQuantity,"",2)		//czf 1915083 2021-05-22
	.s TModel=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",7)
	.q:(ModelDR'="")&&(TModel'=ModelDR)
	.i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	.s TType=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",13)  //Modefied by zc 2014-11-04 zc0019 bgin
	.Quit:(Type'="")&&(TType'=Type)  
	.If TType'="" Set TType=$CASE(TType,"1":"使用","2":"质控")     //Modefied by zc 2014-11-04 zc0019 end
	.// Mozy	2010-11-22
	.Set TQuantityType=$Piece($Get(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",8)
	.Set TQuantityType=##Class(web.DHCEQCServiceConsumable).GetEditQuantityType(TQuantityType)
	.Set TServDetItem=$Piece($Get(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",9)
	.If TServDetItem'="" Set TServDetItem=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",TServDetItem)),"^",1)
	.;add by lmm 2018-05-22 begin
	.Set TSubKey=$Piece($Get(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",15)
	.Set TPartDR=$Piece(TSubKey,",",1)
	.i TPartDR'="" Set TPart=$Piece($Get(^MRC("BODP",TPartDR)),"^",2)
	.Set TCheckMethodDR=$Piece(TSubKey,",",2)
	.i TCheckMethodDR'="" Set TCheckMethod=$Piece($Get(^DHCDocRisOrderMethod(TCheckMethodDR)),"^",1)
	.;add by lmm 2018-05-22 end
	.//modify by wl 2020-02-28 begin WL0058
	.s TBussTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",19)
	.s TBussType=$case(TBussTypeDR,"0":"效益分析","1":"采购申请",:"")
	.//modify by wl 2020-02-28 end  WL0058
	.s TStoreLocDR=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",16)	//czf 1915092
	.s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	.d OutputRowGetServiceConsumable
	Quit
OutputRowGetServiceConsumable
	Set Data=$lb(TRowID,TSourceType,TSourceID,TServiceItem,TConsumableItem,TUnit,TQuantity,TModel,TEquipNo,TQuantityType,TServDetItem,TType,TRow,TBussType,TStoreLocDR,TStoreLoc,TPartDR,TCheckMethodDR,TPart,TCheckMethod,TServiceItemDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	Quit
ResetVariablesGetServiceConsumable
	Set (TRowID,TSourceType,TSourceID,TServiceItem,TConsumableItem,TUnit,TQuantity,TModel,TEquipNo,TQuantityType,TServDetItem,TType,TBussType,TStoreLocDR,TStoreLoc,TSubKey,TPartDR,TCheckMethodDR,TPart,TCheckMethod,TServiceItemDR)=""
	Quit
}

ClassMethod GetServiceConsumableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetServiceConsumableExecute ]
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

/// d ##class(%ResultSet).RunQuery("web.DHCEQCServiceConsumable","GetServiceConsumable","","","","","","")
Query GetServiceConsumable(SourceTypeDR As %String = "", SourceIDDR As %String = "", ModelDR As %String = "", ServiceItemDR As %String = "", ConsumableItemDR As %String = "", QXType As %String = "", Type As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TServiceItem:%String,TConsumableItem:%String,TUnit:%String,TQuantity:%String,TModel:%String,TEquipNo:%String,TQuantityType:%String,TServDetItem:%String,TType:%String,TRow:%String,TBussType:%String,TStoreLocDR:%String,TStoreLoc:%String,TPartDR:%String,TCheckMethodDR:%String,TPart:%String,TCheckMethod:%String,TServiceItemDR:%String")
{
}

/// w ##class(web.DHCEQCServiceConsumable).GetDocByID("","",1)
ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= $g(^DHCEQCCode("DHCEQCServiceConsumable",rowid))
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
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCServiceItem",$p(result,"^",3))),"^",1)
	s resultex=resultex_"^"
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCConsumableItem",$p(result,"^",4))),"^",1)
	s resultex=resultex_"^"
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",5))
	s resultex=resultex_"^"
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",7))),"^",2)
	// Mozy	2010-11-22
	Set resultex=resultex_"^"
	If $Piece(result,"^",8)'=""  Do
	.Set resultex=resultex_$CASE($Piece(result,"^",8),"1":"绝对量","2":"相对量")    //Modefied by zc 2014-11-04 zc0019
	Set resultex=resultex_"^"
	If $Piece(result,"^",9)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",$Piece(result,"^",9))),"^",1)
	Set resultex=resultex_"^"      //Modefied by zc 2014-11-04 zc0019 begin
	i $p(result,"^",12)'=""  d     
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCCycleUnit",$p(result,"^",12))),"^",2)    //Modefied by zc 2014-11-04 zc0019  end
	Set resultex=resultex_"^"      //czf 1915092 2021-05-22
	s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",16))
	s resultex=result_resultex
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n") //回车符转换为"\n"
	q rowid_"^"_resultex
}

// modified by sjh 2020-01-21 增加BussType入参

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "", BussType As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	&SQL(Delete From SQLUSER.DHC_EQCServiceConsumable where SIC_RowID = :rowid) 
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s PLIST(2)=$P(val,"^",2) //SourceType
 s SourceType=$P(val,"^",2)
 s PLIST(3)=$P(val,"^",3) //SourceID
 s SourceID=$P(val,"^",3)
 s PLIST(4)=$P(val,"^",4) //ServiceItemDR
 s ServiceItemDR=$P(val,"^",4)
 s PLIST(5)=$P(val,"^",5) //ConsumableItemDR
 s ConsumableItemDR=$P(val,"^",5)
 s PLIST(6)=$P(val,"^",6) //UnitDR
 s PLIST(7)=$P(val,"^",7) //Quantity
 s PLIST(8)=$P(val,"^",8) //ModelDR
 s Model=$P(val,"^",8)
 // Mozy0031	2010-11-19
 Set PLIST(9)=$Piece(val,"^",9) //QuantityType
 Set PLIST(10)=$Piece(val,"^",10) //ServDetItemDR
 Set ServDetItemDR=$Piece(val,"^",10)
 //Modefied by zc 2014-11-04 zc0019  begin
 i $p(val,"^",11)'="" s PLIST(11) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"bool")  //MonthStatFlag
 s PLIST(12)=$P(val,"^",12) //CycleNum
 s PLIST(13)=$P(val,"^",13) //CycleNuitDR
 s CycleNuitDR=$P(val,"^",13)
 s PLIST(14)=$Piece(val,"^",14) //Type
 s PLIST(15) = $p(val,"^",15) 	//Hold1
 s PLIST(16) = $p(val,"^",16) 	//Hold2
 s PLIST(17) = $p(val,"^",17)   //Hold3
 s StoreLocDR= $p(val,"^",17)	//czf 1915092
 s PLIST(18) = $p(val,"^",18) 	//Hold4
 s PLIST(19) = $p(val,"^",19) 	//Hold5
 s PLIST(20) = BussType 	 //modify by wl 2020-02-28 WL0058
 //Modefied by zc 2014-11-04 zc0019  end
 Set RowidFind=""
 Set SICRowID=0
 For  Set SICRowID=$Order(^DHCEQCCode("DHCEQCServiceConsumable",SICRowID))  Quit:(SICRowID="")||(RowidFind'="")  Do
 .Set TConsumableItemDR=$Piece($Get(^DHCEQCCode("DHCEQCServiceConsumable",SICRowID)),"^",4)	;消耗项
 .Quit:(ConsumableItemDR'=TConsumableItemDR)
 .Set TServiceItemDR=$Piece($Get(^DHCEQCCode("DHCEQCServiceConsumable",SICRowID)),"^",3)	;服务项
 .Set TServDetItemDR=$Piece($Get(^DHCEQCCode("DHCEQCServiceConsumable",SICRowID)),"^",9)	;服务细项
 .Set TSourceID=$Piece($Get(^DHCEQCCode("DHCEQCServiceConsumable",SICRowID)),"^",2)			;SourceID  //modified by czf 393808 begin
 .Set TSourceType=$Piece($Get(^DHCEQCCode("DHCEQCServiceConsumable",SICRowID)),"^",1)		;czf 1915092 begin
 .Set TModelDR=$Piece($Get(^DHCEQCCode("DHCEQCServiceConsumable",SICRowID)),"^",7)
 .q:(SourceType'="")&&(SourceType'=TSourceType)
 .q:(SourceID'="")&&(SourceID'=TSourceID)
 .Set TStoreLocDR=$Piece($Get(^DHCEQCCode("DHCEQCServiceConsumable",SICRowID)),"^",16)
 .q:(TSourceType=2)&&((StoreLocDR'=TStoreLocDR)||(Model'=TModelDR))							;czf 1915092 end
 .;If (ServiceItemDR'="")&&(ServDetItemDR'="")&&(SourceID'="") Do
 .If (ServiceItemDR=TServiceItemDR)&&(ServDetItemDR=TServDetItemDR)&&(SourceID=TSourceID) Set RowidFind=SICRowID
 .;Else  Do
 ..;If (ServiceItemDR="")&&(ServDetItemDR=TServDetItemDR) Set RowidFind=SICRowID
 ..;If (ServDetItemDR="")&&(ServiceItemDR=TServiceItemDR) Set RowidFind=SICRowID    //modified by czf 393808 end
 
 i (rowid="")&&(RowidFind'="") q ""
 i (rowid'="")&&(RowidFind'="")&&(RowidFind'=rowid) q ""
 i (rowid="")  //新增按钮操作
 {
	 &SQL(Insert Into SQLUSER.DHC_EQCServiceConsumable Values :PLIST())
 }
 else  //更新按钮操作
 {
	 i (RowidFind="")
	 {
		 &SQL(Update SQLUSER.DHC_EQCServiceConsumable Values :PLIST() where SIC_RowID = :rowid)
	 }
	 else
	 {
		 i (RowidFind=rowid)
		 {
			 &SQL(Update SQLUSER.DHC_EQCServiceConsumable Values :PLIST() where SIC_RowID = :rowid) 	 
		 }
	 }
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

/********************************************************************/
ClassMethod GetConsumableItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsumableItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetConsumableItemExecute(ByRef qHandle As %Binary, ConsumableItem As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetConsumableItem
	Quit $$$OK
BuildDataGetConsumableItem
	f  s rowid=$o(^DHCEQCCode("DHCEQCConsumableItem",rowid))  quit:rowid=""  d
	.d ResetVariablesGetConsumableItem
	.s TRowID = rowid	//rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",7)
	.q:InvalidFlag="Y"
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",1)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",2)
	.q:(ConsumableItem'="")&&(TCode'[ConsumableItem)&&(TDesc'[ConsumableItem)
	.s TUnitDR=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",4)
	.i TUnitDR'=""  s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.s TPrice=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",3)
	.d OutputRowGetConsumableItem
	quit
OutputRowGetConsumableItem
	s Data=$lb(TDesc,TRowID,TCode,TUnitDR,TPrice,TUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetConsumableItem
	s (TDesc,TRowID,TCode,TUnitDR,TPrice,TUnit)=""
	quit
}

ClassMethod GetConsumableItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsumableItemExecute ]
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

Query GetConsumableItem(ConsumableItem As %String = "") As %Query(ROWSPEC = "TDesc:%String:描述,TRowID:%String,TCode:%String:编码,Hidden:%String,TPrice:%String:单价,TUnit:%String:单位")
{
}

/********************************************************************/
/// Mozy0031 2010-11-19
/// QuantityType
/// 数量类型：1:绝对量 2:相对量
/// Modify By QW 2018-09-29 HISUI改造：自定义下拉列表显示格式错误
ClassMethod QuantityType(name, width) As %String
{
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	;Write "<option value=></option>"
	Write "<option value=1>绝对量</option>"
	Write "<option value=2>相对量</option>"
	Write "</select>",!
}

ClassMethod GetEditQuantityType(Type As %Library.String) As %Status
{
	If Type=""  Quit ""
	If +Type=1  Quit "绝对量"
	If +Type=2  Quit "相对量"
	Quit "未定义"
}

/********************************************************************/
/// Modefied by zc 2014-11-04
/// Type
/// 类型：1:使用 2:质控
/// Modify By QW 2018-09-29 HISUI改造：自定义下拉列表显示格式错误
ClassMethod Type(name, width) As %String
{
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	;Write "<option value=></option>"
	Write "<option value=1>使用</option>"
	Write "<option value=2>质控</option>"
	Write "</select>",!
}

/// add by hly 2020-01-09
ClassMethod NewSaveData(val As %Library.String = "", isDel As %Library.String = "")
{
	Kill PLIST,RowID
	Set $ZT="SaveDataERROR"
	s JsonData=##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(val)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCServiceConsumable",JsonData,.PLIST)
	s RowID=JsonData.SICRowID
	
	TSTART
	If (+isDel=1)
	{
		i RowID="" Quit "-1"
	 	&SQL(delete from sqluser.DHC_EQCServiceConsumable where SIC_RowID=:RowID)
 	}
 	If (+isDel=0) //新增,更新
 	{
		if RowID'=""
		{
		 	
			    &SQL(Update SQLUSER.DHC_EQCServiceConsumable Values:PLIST() where SIC_RowID=:RowID)
			    i SQLCODE
				{
					TROLLBACK
					q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
				}
		}
		else
		{
			&SQL(insert into SQLUSER.DHC_EQCServiceConsumable Values :PLIST())
			i SQLCODE
			{
				TROLLBACK
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
			}
			
		}
		
 	}
 	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
SaveDataERROR 
	TRollBack	
	Set ErrorMsg=$ZE	  
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1000",ErrorMsg)
}

ClassMethod GetServiceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetServiceConsumableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetServiceExecute(ByRef qHandle As %Binary, SourceID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	q:SourceID=""
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCServiceConsumable",rowid))  quit:rowid=""  d
	.d ResetVariablesGetServiceConsumable
	.s TSourceID=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",2)
	.q:(SourceID'="")&&(TSourceID'=SourceID)
	.s TRowID=rowid
	.s TSourceType=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",1)
	.If TSourceType'="" Set TSource=$CASE(TSourceType,"1":"设备","2":"设备项")
	.s TServiceItemDR=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",3)
	.i TServiceItemDR'="" s TServiceItem=$p($g(^DHCEQCCode("DHCEQCServiceItem",TServiceItemDR)),"^",1)	
	.s TConsumableItemDR=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",4)
	.i TConsumableItemDR'=""  d
	..s TConsumableItem=$p($g(^DHCEQCCode("DHCEQCConsumableItem",TConsumableItemDR)),"^",1)
	..s TPrice=$p($g(^DHCEQCCode("DHCEQCConsumableItem",TConsumableItemDR)),"^",3)
	..s TExType=$p($g(^DHCEQCCode("DHCEQCConsumableItem",TConsumableItemDR)),"^",5)
	..s TExID=$p($g(^DHCEQCCode("DHCEQCConsumableItem",TConsumableItemDR)),"^",6)
	.s TUOMDR=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",5)
	.i TUOMDR'="" s TUOM=$p($g(^DHCEQCCode("DHCEQCUOM",TUOMDR)),"^",4)
	.s TQuantity=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",6)
	.s TModelDR=$p($g(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",7)
	.i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.Set TQuantityTypeID=$Piece($Get(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",8)
	.If TQuantityTypeID'="" Set TQuantityType=$CASE(TQuantityTypeID,"1":"绝对量","2":"相对量")
	.;Set TQuantityType=##Class(web.DHCEQCServiceConsumable).GetEditQuantityType(TQuantityType)
	.Set TServDetItemDR=$Piece($Get(^DHCEQCCode("DHCEQCServiceConsumable",rowid)),"^",9)
	.If TServDetItemDR'="" Set TServDetItem=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",TServDetItemDR)),"^",1)
	.d OutputRowGetService
	Quit $$$OK
OutputRowGetService
	Set TRow=index
	Set Data=$lb(TRowID,TSource,TServiceItemDR,TServiceItem,TUOMDR,TUOM,TQuantity,TModelDR,TModel,TServDetItemDR,TServDetItem,TConsumableItemDR,TConsumableItem,TQuantityType,TPrice,TExType,TExID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetService
	Set (TRowID,TSource,TServiceItemDR,TServiceItem,TUOMDR,TUOM,TQuantity,TModelDR,TModel,TServDetItemDR,TServDetItem,TConsumableItemDR,TConsumableItem,TQuantityType,TPrice,TExType,TExID)=""
	Quit
}

ClassMethod GetServiceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetServiceConsumableExecute ]
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

/// add hly 2020-02-09
/// d ##class(%ResultSet).RunQuery("web.DHCEQCServiceConsumable","GetService","")TRowID,TSource,       TServiceItemDR,          TServiceItem,          TUOMDR,          TUOM,          TQuantity,          TModelDR,          TModel,          TServDetItemDR,          TServDetItem,          TConsumableItemDR,          TConsumableItem,          TQuantityType,          TPrice,          TExType,          TExID
Query GetService(SourceID As %String = "") As %Query(ROWSPEC = "SICRowID:%String,SICSourceType:%String,SICServiceItemDR:%String,SICServiceItem:%String,SICUomDR:%String,SICUom:%String,SICQuantity:%String,SICModelDR:%String,SICModel:%String,SICServDetItemDR:%String,SICServDetItem:%String,SICConsumableItemDR:%String,SICConsumableItem:%String,SICQuantityType:%String,SICPrice:%String,SICExType:%String,SICExID:%String")
{
}

/// add hly 2020-02-09
ClassMethod GetServiceTypeID(RowID As %Library.String = "")
{
	s $ZT="ERRORGetSICList"
	s SICList=##Class(User.DHCEQCServiceConsumable).%OpenId(RowID)
	s SICListInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(SICList)
	d SICListInfo.%Set("SICRowID",RowID)
	if SICList.SICQuantity="" d SICListInfo.%Set("SICQuantity","")
	if SICList.SICUomDR'="" d SICListInfo.%Set("SICUom",##Class(web.DHCEQCommon).GetTrakNameByID("uom",SICList.SICUomDR))
	if SICList.SICServiceItemDR'="" d SICListInfo.%Set("SICServiceItem",$p($g(^DHCEQCCode("DHCEQCServiceItem",SICList.SICServiceItemDR)),"^",1))
	if SICList.SICConsumableItemDR'="" d SICListInfo.%Set("SICConsumableItem",$p($g(^DHCEQCCode("DHCEQCConsumableItem",SICList.SICConsumableItemDR)),"^",1))
	if SICList.SICModelDR'="" d SICListInfo.%Set("SICModel",$p($g(^DHCEQCCode("DHCEQCModel",SICList.SICModelDR)),"^",2))
	if SICList.SICServDetItemDR'="" d SICListInfo.%Set("SICServDetItem",$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",SICList.SICServDetItemDR)),"^",1))
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,SICListInfo)
ERRORGetSICList
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// add by lmm 2018-05-22
/// 保存部位数据
ClassMethod SavePartData(rowid As %Library.String = "", subkey As %Library.String = "")
{
	 k PLIST
	 s PLIST(15)="DHC-Pacs" 
	 s PLIST(16)=subkey 
	 &SQL(Update SQLUSER.DHC_EQCServiceConsumable Values :PLIST() where SIC_RowID = :rowid) 	 
	 Set ID=$g(%ROWID)
	 q SQLCODE_"^"_ID
}

}
