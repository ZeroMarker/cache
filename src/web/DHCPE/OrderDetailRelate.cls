Import SQLUser

/// 创建时间		：2006.06.08
/// 创建人		：xuwm
/// 存在系统		：体检系统
/// 关联数据		: DHC_PE_OrderDetailRelate
/// 主要功能		：提供给WEB页面的操作接口 
/// 主要功能		：大项和细项组合关系对照
/// 最后修改时间	：
/// 最后修改人	：
Class web.DHCPE.OrderDetailRelate Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 51;

// ////////////////////////////////////////////////////////////////////////

/// 显示所有的组合项目关系 页面测试使用
Query QueryAll() As %SQLQuery(ROWSPEC = "ODR_RowId:%String, ODR_ARCIM_DR:%String, ODR_OD_DR:%String, ODR_Sequence:%String, ODR_Required:%String, ODR_ARCIM_DR_Name:%String, ODR_OD_DR_Name:%String")
{
	
 select odr.ODR_RowId, odr.ODR_ARCIM_DR, odr.ODR_OD_DR, ODR_Sequence, ODR_Required
        , ai.ARCIM_Desc as ODR_ARCIM_DR_Name
        , od.OD_Desc as ODR_OD_DR_Name
 from DHC_PE_OrderDetailRelate as odr
 inner join sqluser.DHC_PE_OrderDetail as od on od.OD_RowId=odr.ODR_OD_DR
 inner join sqluser.arc_itmmast as ai on ai.ARCIM_RowId=odr.ODR_ARCIM_DR
 order by odr.ODR_ARCIM_DR,ODR_OD_DR
}

/// 供层次非顶层的项目查找父项 
Query SearchParentOrderDetailRelate(ARCIMDR As %Library.String = "", Desc As %Library.String = "") As %SQLQuery(ROWSPEC = "Desc:%String, ID:%String")
{
 select odr.ODR_OD_DR->OD_Desc,odr.ODR_RowId
 from DHC_PE_OrderDetailRelate as odr
 where odr.ODR_Cascade='1' and odr.ODR_ARCIM_DR=:ARCIMDR
}

/// 提供给Web页面 显示指组合项目的所有子项(列表) 
/// 细项列表
/// d ##class(%ResultSet).RunQuery("web.DHCPE.OrderDetailRelate","SreachOrderDetailRelate","10","1596||1")
Query SreachOrderDetailRelate(ParRef As %Library.String = "", ParARCIMDR As %Library.String = "") As %Query(ROWSPEC = "ODR_RowId:%String, ODR_ARCIM_DR:%String, ODR_OD_DR:%String, ODR_ARCIM_DR_Name:%String, ODR_OD_DR_Name:%String, ODR_OD_DR_Code:%String, ODR_Sequence:%String, ODR_Required:%String, ODR_Parent_DR:%String, ODR_Parent_DR_Name:%String, ODR_Cascade:%String,THistoryFlag:%String")
{
}

ClassMethod SreachOrderDetailRelateExecute(ByRef qHandle As %Binary, ParRef As %Library.String = "", ParARCIMDR As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if (""=ParARCIMDR) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s id="0"	//不能使用空字符串开始 s id="" ,否则会取到 0
 	f  s id=$o(^DHCPEODR(0,"ARCIM",ParARCIMDR,id)) q:id=""  d
	.s CurData=$g(^DHCPEODR(id))
	
	.//ODR_ARCIM_DR 大项RowId
	.s ODRARCIMDR=$p(CurData,"^",1)
    .// ARCIM_Desc	大项名称(ARC_ItmMast)
    .s ARCIMSubscript=$p(ODRARCIMDR,"||",1)		//ARCIM_Subscript
    .s ARCIMVersion=$p(ODRARCIMDR,"||",2)		//ARCIM_Version
    .s ODRARCIMDRName=$p($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	.
	.
	.//ODR_OD_DR 细项RowId
    .s ODRODDR=$p(CurData,"^",2)
    .q:ODRODDR=""
    .// OD_Desc 细项名称
    .s STRowId=$p(ODRODDR,"||",1)
    .s ODChildSub=$p(ODRODDR,"||",2)
    .s ODRODDRName=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",1)
    .q:(""=ODRODDRName) 
    .// OD_Code 细项编码
    .s ODRODDRCode=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",11)
	.
	.// ODR_Sequence	顺序号
	.s ODRSequence=$p(CurData,"^",3)
	.
	.// ODR_Required	是否必填项
	.s ODRRequired=$p(CurData,"^",4)
	.i ODRRequired="Y" S ODRRequired="是"
	.e  s ODRRequired="否"
	
	.// ODR_Parent_DR	大类指针
	.s ODRParentDR=$p(CurData,"^",5)
	.
	.i ""'=ODRParentDR d
	..s PODRODDR=$p($g(^DHCPEODR(ODRParentDR)),"^",2)
	..i ""'=PODRODDR
	..s PSTRowId=$p(PODRODDR,"||",1)
	..q:PSTRowId=""
	..s PODChildSub=$p(PODRODDR,"||",2)
	..s ODRParentDRName=$p($G(^DHCPEST(PSTRowId,"OD",PODChildSub)),"^",1)
	.e  d
	..s ODRParentDR=""
	..s ODRParentDRName=""
	.
	.// ODR_Cascade	层次
	.s ODRCascade=$p(CurData,"^",6)
	.i "1"=ODRCascade d
	..s ODRParentDR=""
	..s ODRParentDRName=""
	.
	.s HistoryFlag=$g(^DHCPECTDataEx("DHCPEOrderDetailRelate","History",ODRARCIMDR,ODRODDR))
	.i HistoryFlag="Y"  S HistoryFlag="是"
	.e  s HistoryFlag="否"
	.d Build	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build      
	set Data=$lb($g(id),ODRARCIMDR,ODRODDR,ODRARCIMDRName,ODRODDRName,ODRODDRCode, ODRSequence, ODRRequired,ODRParentDR,ODRParentDRName,ODRCascade,HistoryFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SreachOrderDetailRelateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SreachOrderDetailRelateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SreachOrderDetailRelateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SreachOrderDetailRelateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// and ai.ARCIM_Desc [:Desc

/*
/// 显示指定站点的组合项目列表 用于显示一个组合项目列表的页面 组件DHCPEOrderDetailRelateListCom使用
Query OrderDetailRelateList(ParRef As %Library.String = "", ListTargeURL As %Library.String = "", ParamName As %Library.String = "", Desc As %Library.String = "") As %SQLQuery(ROWSPEC = "ODR_ARCIM_DR:%String, ODR_ARCIM_DR_Name:%String, ODR_ARCIM_Code:%String")
{
 select so.STORD_ARCIM_DR as ODR_ARCIM_DR,ai.ARCIM_Desc as ODR_ARCIM_DR_Name, ai.ARCIM_Code as ODR_ARCIM_Code
 from DHC_PE_StationOrder as so
 inner join sqluser.arc_itmmast as ai on ai.ARCIM_RowId=so.STORD_ARCIM_DR
 where so.STORD_ParRef=:ParRef
}
*/
/// d ##class(%ResultSet).RunQuery("web.DHCPE.OrderDetailRelate","OrderDetailRelateList",1,"","","",2)
Query OrderDetailRelateList(ParRef As %Library.String = "", ListTargeURL As %Library.String = "", ParamName As %Library.String = "", Desc As %Library.String = "", hospId As %Library.String = "") As %Query(ROWSPEC = "ODR_ARCIM_DR:%String, ODR_ARCIM_DR_Name:%String, ODR_ARCIM_Code:%String")
{
}

ClassMethod OrderDetailRelateListExecute(ByRef qHandle As %Binary, ParRef As %Library.String = "", ListTargeURL As %Library.String = "", ParamName As %Library.String = "", Desc As %Library.String = "", hospId As %Library.String = "") As %Status
{
    // "7^DHCPEOrderDetailRelateCom^ParRef^乙肝" 
    
	Set repid=$I(^CacheTemp)
 	s Desc=##class(web.DHCPE.DHCPECommon).UnEscape(Desc)
 	s ind=1
    s STORDChildSub=0
    f  s STORDChildSub=$o(^DHCPEST(ParRef,"O",STORDChildSub))  q:STORDChildSub=""  d
    .s STORDARCIMDR=$p(^DHCPEST(ParRef,"O",STORDChildSub),"^",1)
    .s ArcItemDesc=$p(^ARCIM($p(STORDARCIMDR,"||",1),$p(STORDARCIMDR,"||",2),1),"^",2)
    .q:ArcItemDesc'[Desc
    .s ARCIMCode=$p(^ARCIM($p(STORDARCIMDR,"||",1),$p(STORDARCIMDR,"||",2),1),"^",1)
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",STORDARCIMDR,hospId)
	.q:HOSPshowFlag="N"

 	.d Find
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Find
 	set Data=$lb(STORDARCIMDR,ArcItemDesc,ARCIMCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod OrderDetailRelateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OrderDetailRelateListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OrderDetailRelateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OrderDetailRelateListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 提供给Web页面 显示一个细项列表(页面) 用于查找检验细项 
Query OrderDetailAll(ParRef As %Library.String = "") As %SQLQuery(ROWSPEC = "OD_Desc:%String,OD_RowId:%String")
{
 select od.OD_Desc,od.OD_RowId
 from sqluser.DHC_PE_OrderDetail as od
}

/// 提供给Web页面 检验医嘱(大项)列表 用于查找组合项目  见“web.DHCPEStationOrderCom”
Query ArcItmmastList(ParRef As %Library.String = "") As %SQLQuery(ROWSPEC = "STORD_ARCIM_Code:%String, STORD_ARCIM_Desc:%String, STORD_ARCIM_DR:%String")
{
 select ai.ARCIM_Code as STORD_ARCIM_Code,ai.ARCIM_Desc as STORD_ARCIM_Desc,ai.ARCIM_RowId as STORD_ARCIM_DR
 from arc_itmmast as ai
 inner join ARC_BillSub as ab on ((ab.ARCSG_RowId=ai.ARCIM_BillSub_DR) and (ab.ARCSG_Desc='体检费'))
}

/// 更新函数  
ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{

	s Rowid=$p(InString,"^",1)
	s ARCIMDR=$p(InString,"^",2)
    s ODRODDR=$p(InString,"^",3)
	s Sequence=$p(InString,"^",4)
    s Required=$p(InString,"^",5)
    s ParentDR=$p(InString,"^",6)
    s Cascade=$p(InString,"^",7)
    s HistoryFlag=$p(InString,"^",8)
	s ret=..ISave(Rowid, ARCIMDR, ODRODDR, Sequence, Required, ParentDR, Cascade)
	i ret=0 d
	.s ^DHCPECTDataEx("DHCPEOrderDetailRelate","History",ARCIMDR,ODRODDR)=HistoryFlag
	Q ret
}

/// 删除函数
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", Rowid As %Library.String = "")
{
	TStart
	&sql(update DHC_PE_OrderDetailRelate 
		set ODR_Parent_DR=''
		where ODR_Parent_DR=:Rowid)
	
	s ARCIMDR=$p($g(^DHCPEODR(Rowid)),"^",1)
	s ODRODDR=$p($g(^DHCPEODR(Rowid)),"^",2)

	s ret=SQLCODE
	i '(("0"=ret)||("100"=ret)) goto DeleteErr
	&sql(delete from DHC_PE_OrderDetailRelate where ODR_RowId=:Rowid)
	k ^DHCPECTDataEx("DHCPEOrderDetailRelate","History",ARCIMDR,ODRODDR)
	s ret=SQLCODE
	i '(("0"=ret)||("100"=ret)) goto DeleteErr
	TCOMMIT
	q ret
	
DeleteErr
	TROLLBACK
	q ret
}

/// 删除函数
/// test w ##class(DHC_PE_OrderDetailRelate).IsExistRecord("","","")
ClassMethod IsExistRecord(Rowid As %String, ARCIMDR As %Library.String = "", ODRODDR As %Library.String = "")
{
	&sql(select ODR_RowId into :id
		from DHC_PE_OrderDetailRelate 
		where ODR_ARCIM_DR=:ARCIMDR and ODR_OD_DR=:ODRODDR)
	q RCount
}

/// 保存数据
ClassMethod ISave(Rowid As %String, ARCIMDR As %String, ODDR As %String, Sequence As %String, Required As %String, ParentDR As %String, Cascade As %String)
{

	s ReturnFlag=""
	
	i Rowid="" d
	.s ReturnFlag=..Insert(Rowid,ARCIMDR,ODDR, Sequence, Required,ParentDR, Cascade)
	.//s ReturnFlag=..IsExistRecord(ARCIMDR,ODRODDR)
	.//i ReturnFlag>0 d
	.//.s ReturnFlag=..Insert(Rowid,ARCIMDR,ODDR, Sequence, Required)
	.//e  d
	.//.s ReturnFlag="Err 01"
	e  d
	.s ReturnFlag=..Update(Rowid,ARCIMDR,ODDR, Sequence, Required, ParentDR, Cascade)
	q ReturnFlag
}

/// ODR_RowId,ODR_ARCIM_DR,ODR_OD_DR
ClassMethod Insert(Rowid As %String, ARCIMDR As %String, ODDR As %String, Sequence As %String, Required As %String, ParentDR As %String, Cascade As %String)
{
	&sql(insert into DHC_PE_OrderDetailRelate(ODR_ARCIM_DR, ODR_OD_DR, ODR_Sequence, ODR_Required, ODR_Parent_DR, ODR_Cascade)
	     values (:ARCIMDR, :ODDR, :Sequence, :Required,:ParentDR, :Cascade)
	     )
	q SQLCODE
}

ClassMethod Update(Rowid As %String, ARCIMDR As %String, ODDR As %String, Sequence As %String, Required As %String, ParentDR As %String, Cascade As %String)
{
	
	&sql(update DHC_PE_OrderDetailRelate
	     set ODR_ARCIM_DR = :ARCIMDR
	         ,ODR_OD_DR = :ODDR
	         ,ODR_Sequence = :Sequence
	         ,ODR_Required = :Required
	         ,ODR_Parent_DR =:ParentDR
	         ,ODR_Cascade=:Cascade
	     where ODR_RowId= :Rowid
	     )
	 q SQLCODE
}

ClassMethod IsOrderDetailFlag(ODID)
{
	///d ##class(web.DHCPE.OrderDetailRelate).IsOrderDetailFlag()
	s Flag=0
	q:ODID="" Flag
	q:$l(ODID,"||")'=2 Flag
	s STRowId=$p(ODID,"||",1)
	s ODSub=$p(ODID,"||",2)
	q:'$d(^DHCPEST(STRowId,"OD",ODSub)) Flag
	i $d(^DHCPEST(STRowId,"OD",ODSub)) s Flag=1
	q Flag
}

}
