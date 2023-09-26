Import SQLUser

Class web.DHCEQEquipService Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ES_RowID";

Parameter SQLDESCRIPTION = "ES_RowID";

Parameter SQLROWID = "ES_RowID";

ClassMethod GetEquipServiceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipServiceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// modified by czf 397032 增加TRow并输出
ClassMethod GetEquipServiceExecute(ByRef qHandle As %Binary, SourceTypeDR As %String = "", SourceIDDR As %String = "", ModelDR As %String = "", ServiceDR As %String = "", QXType As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetEquipService
	Quit $$$OK
BuildDataGetEquipService
	f  s rowid=$o(^DHCEQEquipService(rowid))  quit:rowid=""  d
	.d ResetVariablesGetEquipService
	.s TRowID = rowid	//rowid
	.s InvalidFlag=$p($g(^DHCEQEquipService(rowid)),"^",9)
	.q:InvalidFlag="Y"
	.s TSourceType=$p($g(^DHCEQEquipService(rowid)),"^",1)
	.q:(SourceTypeDR'="")&&(TSourceType'=SourceTypeDR)
	.s TSourceID=$p($g(^DHCEQEquipService(rowid)),"^",2)
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
	.i TSourceType'="" s TSourceType=..GetEditSourceType(TSourceType)
	.s TModel=$p($g(^DHCEQEquipService(rowid)),"^",3)
	.q:(ModelDR'="")&&(TModel'=ModelDR)
	.i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	.s TService=$p($g(^DHCEQEquipService(rowid)),"^",4)
	.q:(ServiceDR'="")&&(TService'=ServiceDR)
	.i TService'="" s TService=$p($g(^DHCEQCCode("DHCEQCServiceItem",TService)),"^",1)
	.s TMinMinutes=$p($g(^DHCEQEquipService(rowid)),"^",5)
	.s TMinutesPerTimes=$p($g(^DHCEQEquipService(rowid)),"^",6)
	.s TMaxMinutes=$p($g(^DHCEQEquipService(rowid)),"^",7)
	.s TRemark=$p($g(^DHCEQEquipService(rowid)),"^",8)
	.d OutputRowGetEquipService
	quit
OutputRowGetEquipService
	s Data=$lb(TRowID,TSourceType,TSourceID,TModel,TService,TRemark,TMinMinutes,TMinutesPerTimes,TMaxMinutes,TEquipNo,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetEquipService
	s (TRowID,TSourceType,TSourceID,TModel,TService,TRemark,TMinMinutes,TMinutesPerTimes,TMaxMinutes,TEquipNo)=""
	quit
}

ClassMethod GetEquipServiceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipServiceExecute ]
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

Query GetEquipService(SourceTypeDR As %String = "", SourceIDDR As %String = "", ModelDR As %String = "", ServiceDR As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TModel:%String,TService:%String,TRemark:%String,TMinMinutes:%String,TMinutesPerTimes:%String,TMaxMinutes:%String,TEquipNo:%String,TRow:%String")
{
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= $g(^DHCEQEquipService(rowid))
	s resultex=resultex_"^"
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_..GetEditSourceType($p(result,"^",1))
	s resultex=resultex_"^"
	i ($p(result,"^",2)'="")&&($p(result,"^",1)=1)  d //设备
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",2))),"^",1)
	i ($p(result,"^",2)'="")&&($p(result,"^",1)=2)  d //设备项
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",2))),"^",1)
	s resultex=resultex_"^"
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCServiceItem",$p(result,"^",4))),"^",1)
	s resultex=result_resultex
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n") //回车符转换为"\n"
	q rowid_"^"_resultex
}

ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	//删除按钮操作,更新InvalidFlag标识.
 	s PLIST(10)="Y"
 	&SQL(Update SQLUSER.DHC_EQEquipService Values :PLIST() where ES_RowID = :rowid) 
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s PLIST(2)=$P(val,"^",2) //SourceType
 s SourceType=$P(val,"^",2)
 s PLIST(3)=$P(val,"^",3) //SourceID
 s SourceID=$P(val,"^",3)
 s PLIST(4)=$P(val,"^",4) //ModelDR
 s Model=$P(val,"^",4)
 s PLIST(5)=$P(val,"^",5) //ServiceDR
 s ServiceDR=$P(val,"^",5)
 s PLIST(6)=$P(val,"^",6) //MinMinutes
 s PLIST(7)=$P(val,"^",7) //MinutesPerTimes
 s PLIST(8)=$P(val,"^",8) //MaxMinutes
 s PLIST(9)=$P(val,"^",9) //Remark
 s PLIST(10)="N"
 s RowidFind=""
 //检测当前记录是否已经存在
 s ESRowID=0
 f  s ESRowID=$o(^DHCEQEquipService(0,"ServiceSource",ServiceDR,SourceType,SourceID,ESRowID))  q:(ESRowID="")||(RowidFind'="")  d
 .s InvalidFlag=$p($g(^DHCEQEquipService(ESRowID)),"^",9)
 .q:InvalidFlag="Y"
 .i SourceType=2  d
 ..s ModelDR=$p($g(^DHCEQEquipService(ESRowID)),"^",3)
 ..i (ModelDR=Model)||(ModelDR="") s RowidFind=ESRowID
 .e  d
 ..s RowidFind=ESRowID
 i (rowid="")&&(RowidFind'="") q ""
 i (rowid'="")&&(RowidFind'="")&&(RowidFind'=rowid) q ""
 i (rowid="")  //新增按钮操作
 {
	 &SQL(Insert Into SQLUSER.DHC_EQEquipService Values :PLIST())
 }
 else  //更新按钮操作
 {
	 i (RowidFind="")
	 {
		 &SQL(Update SQLUSER.DHC_EQEquipService Values :PLIST() where ES_RowID = :rowid)
	 }
	 else
	 {
		 i (RowidFind=rowid)
		 {
			 &SQL(Update SQLUSER.DHC_EQEquipService Values :PLIST() where ES_RowID = :rowid) 	 
		 }
	 }
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

/***********************************************************************/
ClassMethod GetServiceItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetServiceItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetServiceItemExecute(ByRef qHandle As %Binary, Service As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetServiceItem
	Quit $$$OK
BuildDataGetServiceItem
	f  s rowid=$o(^DHCEQCCode("DHCEQCServiceItem",rowid))  quit:rowid=""  d
	.d ResetVariablesGetServiceItem
	.s TRowID = rowid	//rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",12)
	.q:InvalidFlag="Y"
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",1)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",2)
	.q:(Service'="")&&(TDesc'[Service)&&(TCode'[Service)
	.s TUnit=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",3)
	.s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	.s TPrice=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",4)
	.s TMinMinutes=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",9)
	.s TMinutesPerTimes=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",10)
	.s TMaxMinutes=$p($g(^DHCEQCCode("DHCEQCServiceItem",rowid)),"^",11)
	.d OutputRowGetServiceItem
	quit
OutputRowGetServiceItem
	s Data=$lb(TDesc,TRowID,TCode,TUnit,TPrice,TMinMinutes,TMinutesPerTimes,TMaxMinutes)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetServiceItem
	s (TRowID,TDesc,TCode,TUnit,TPrice,TMinMinutes,TMinutesPerTimes,TMaxMinutes)=""
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

/// modified by sjh SJH0036 2020-20-13 输出列标题修改
Query GetServiceItem(Service As %String = "") As %Query(ROWSPEC = "TDesc:%String:描述,Hidden:%String,TCode:%String:编码,TUnit:%String:单位,TPrice:%String:单价,Hidden:%String,Hidden:%String,Hidden:%String")
{
}

/***********************************************************************/
ClassMethod GetEditSourceType(Type As %Library.String) As %Status
{
	i Type=""  q ""
	i +Type=1  q "设备"
	i +Type=2  q "设备项"
	q "未定义"
}

/// Modify By QW 2018-09-29 HISUI改造：自定义下拉列表显示格式错误
ClassMethod SourceType(name, width) As %String
{
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	;w "<option value=></option>"
	w "<option value=1>设备</option>"
	w "<option value=2>设备项</option>"
	w "</select>",!
}

/*************************************************************************/
/// modified by YZ0253 20200122 表结构调整,索引变化
/// modified by czf 421875 增加TRow并输出
ClassMethod GetEquipServiceListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipServiceListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetEquipServiceListExecute(ByRef qHandle As %Binary, EquipDR As %String = "", Service As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^DHCEQTemp("EquipService",curuser)
	s index=1
	s rowid=0
	s TRow=1
	d BuildDataGetEquipServiceList
	Quit $$$OK
BuildDataGetEquipServiceList
	q:EquipDR=""
	s ItemDR=$p($g(^DHCEQEquip(EquipDR)),"^",7)
	s ModelDR=$p($g(^DHCEQEquip(EquipDR)),"^",3)
	s EQService=0
	f  s EQService=$o(^DHCEQEquipService(0,"SourceService",0,1,EquipDR,EQService))  quit:EQService=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQEquipService(0,"SourceService",0,1,EquipDR,EQService,rowid))  quit:rowid=""  d
	..s TServiceRowID = rowid	//rowid
	..s InvalidFlag=$p($g(^DHCEQEquipService(rowid)),"^",9)
	..q:InvalidFlag="Y"
	..s TModel=$p($g(^DHCEQEquipService(rowid)),"^",3)
	..i TModel="" s TModel=ModelDR ///modified BY ZY0247 2020-12-14
	..s TService=$p($g(^DHCEQEquipService(rowid)),"^",4)
	..s ^DHCEQTemp("EquipService",curuser,TService)=TServiceRowID_"^"_TModel

	i ItemDR'="" d
	.s EQService=0
	.f  s EQService=$o(^DHCEQEquipService(0,"SourceService",0,2,ItemDR,EQService))  quit:EQService=""  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQEquipService(0,"SourceService",0,2,ItemDR,EQService,rowid))  quit:rowid=""  d
	...s TServiceRowID=rowid
	...s InvalidFlag=$p($g(^DHCEQEquipService(rowid)),"^",9)
	...q:InvalidFlag="Y"
	...s TService=$p($g(^DHCEQEquipService(rowid)),"^",4)
	...s TModel=$p($g(^DHCEQEquipService(rowid)),"^",3)
	...q:$g(^DHCEQTemp("EquipServie",curuser,TService))'=""
	...q:(TModel'="")&&(TModel'=ModelDR)
	...s ^DHCEQTemp("EquipService",curuser,TService)=TServiceRowID_"^"_TModel
	s rowid=0
	f  s rowid=$o(^DHCEQTemp("EquipService",curuser,rowid))  quit:rowid=""  d
	.d ResetVariablesGetEquipServiceList
	.s TService=rowid
	.s TServiceRowID=rowid
	.s TModel=$p($g(^DHCEQTemp("EquipService",curuser,rowid)),"^",2)
	.i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	.i TService'="" s TService=$p($g(^DHCEQCCode("DHCEQCServiceItem",TService)),"^",1)
	.q:(Service'="")&&(TService'=Service)
	.d OutputRowGetEquipServiceList
	quit
OutputRowGetEquipServiceList
	s Data=$lb(TService,TServiceRowID,TModel,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetEquipServiceList
	s (TService,TServiceRowID,TModel)=""
	quit
}

ClassMethod GetEquipServiceListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipServiceListExecute ]
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

/// modified by sjh SJH0041 2020-12-02 输出列标题修改
Query GetEquipServiceList(EquipDR As %String = "", Service As %String = "") As %Query(ROWSPEC = "TService:%String:服务,TServiceRowID:%String,TModel:%String:型号,TRow:%String")
{
}

/*************************************************************************/
}
