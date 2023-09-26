Import SQLUser

/// 创建时间		：2006.06.08
/// 创建人		：xuwm 
/// 存在系统		：体检系统
/// 关联数据		: DHC_PE_StationWait
/// 主要功能		：提供给WEB页面的操作接口 
/// 主要功能		：站点等候客户排队表（DHC_PE_Station的子表）
/// 最后修改时间	：
/// 最后修改人	：
Class web.DHCPE.StationWait Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 35;

/// 提供给Web页面 显示所有站点排队等候的客户 页面测试使用
Query QueryAll() As %SQLQuery(ROWSPEC = "STW_ParRef:%String, STW_RowId:%String, STW_Childsub:%String, STW_IADM_DR:%String, STW_ParRef_Name:%String, STW_IADM_DR_Name:%String")
{
 select sw.STW_ParRef, sw.STW_RowId, sw.STW_Childsub, sw.STW_IADM_DR
        ,s.ST_Desc as STW_ParRef_Name
        ,sw.STW_IADM_DR as STW_IADM_DR_Name
 from DHC_PE_StationWait as sw
 inner join sqluser.DHC_PE_Station as s on s.ST_RowId=sw.STW_ParRef
}

// ////////////////////////////////////////////////////////////////////

Query SearchStationWait(ParRef As %Library.String = "") As %Query(ROWSPEC = "STW_ParRef:%String, STW_RowId:%String, STW_Childsub:%String, STW_IADM_DR:%String,STW_ParRef_Name:%String, STW_IADM_DR_No:%String, STW_IADM_DR_Name:%String, STW_IADM_Count:%String")
{
}

ClassMethod SearchStationWaitExecute(ByRef qHandle As %Binary, ParRef As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1

	i (""=ParRef) s ParRef="16" // 测试站点 内科 65
	s STWIADMCount=0
	s id="0"
	f  s id=$o(^DHCPEST(ParRef,"Wait",id)) q:id=""  d
	.s CurData=$g(^DHCPEST(ParRef,"Wait",id))
	.s STWRowId=ParRef_"||"_id
    .s STWParRefName=$p($g(^DHCPEST(ParRef)),"^",2)
	.s STWIADMDR=$p(CurData,"^",1)
	.s IADMPAADMDR=$p($g(^DHCPEIADM(STWIADMDR)),"^",1)			// DHC_PE_IADM IADM_PAADM_DR Medtrak的ADM号			
	.q:(""=IADMPAADMDR)
	.s PAPMIDR=$p($g(^PAADM(IADMPAADMDR)),"^",1)			// PA_ADM	PAADM_PAPMI_DR
	.q:(""=PAPMIDR)
	.s STWIADMNo=$p($g(^PAPER(PAPMIDR,"PAT",1)),"^",2)			// 登记号 PAPMI_OPNo PA_PatMas
	.s STWIADMDRName=$p(^PAPER(PAPMIDR,"ALL"),"^",1)			// 姓名	PAPMI_Name PA_PatMas
	.s STWIADMCount=STWIADMCount+1
	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild
	set Data=$lb(ParRef, STWRowId ,$g(id), STWIADMDR,STWParRefName, STWIADMNo, STWIADMDRName, STWIADMCount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchStationWaitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchStationWaitExecute ]
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

ClassMethod SearchStationWaitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchStationWaitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/*Query SearchStationWaitCount() As %SQLQuery(ROWSPEC = "ST_RowId:%String, ST_Code:%String, ST_Desc:%String, ST_Count:%String")
{
	select s.ST_RowId, s.ST_Code, s.ST_Desc, count(sw.STW_ParRef) as ST_Count
 	from sqluser.DHC_PE_Station as s
 	inner join DHC_PE_StationWait as sw on s.ST_RowId=*sw.STW_ParRef
 	Group by s.ST_RowId
 	Order by ST_Count ASC,s.ST_RowId DESC
}
*/
/// 提供给Web页面 显示所有站点排队的统计
/// 更新函数  
ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s ^xwmTest("wait")=InString
    s ParRef=$p(InString,"^",1)
	//s Rowid=$p(InString,"^",2)
	s Rowid=""	
    s ChildSub=$p(InString,"^",3)
    s IADMDR=$p(InString,"^",4)      
                       
    s ret=..ISave(ParRef, Rowid, ChildSub, IADMDR)
	q ret
}

/// 删除函数
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", ParRef As %Library.String = "", ChildSub As %Library.String = "")
{
	//q:$d(^DHCTJST(Rowid))=0 100
	&sql(delete from DHC_PE_StationWait where STW_ParRef=:ParRef and STW_Childsub=:ChildSub)
	q SQLCODE
}

/// 按登记号查询患者
Query SearchIADM(TRegNo As %Library.String = "") As %Query(ROWSPEC = "PAPMI_Name:%String, PAPMI_No:%String, IADM_PAADM_DR:%String")
{
}

ClassMethod SearchIADMExecute(ByRef qHandle As %Binary, TRegNo As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id="0"

 	i (""=TRegNo)  d
 	.f  s id=$o(^DHCPEIADM(id)) q:id=""  d
	..s IADMPAADMDR=$p($g(^DHCPEIADM(id)),"^",1)			// DHC_PE_IADM IADM_PAADM_DR Medtrak的ADM号			
	..q:(""=IADMPAADMDR)
	..s PAPMIDR=$p($g(^PAADM(IADMPAADMDR)),"^",1)			// PA_ADM	PAADM_PAPMI_DR
	..q:(""=PAPMIDR)
	..s PAPMIName=$p(^PAPER(PAPMIDR,"ALL"),"^",1)			// 姓名	PAPMI_Name PA_PatMas
	..q:(""=PAPMIName)
	..//PAPMI_IPNo
	..S PAPMIIPNo=$P(^PAPER(PAPMIDR,"PAT",1),"^",1)			// 登记号	
	..d IADMOutput
 	e  d
 	.s TRegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(TRegNo)
 	.s PAPMIDR="0"
 	.f  s PAPMIDR=$o(^PAPERi("PAPMI_PatNo",TRegNo,PAPMIDR)) q:(""=PAPMIDR)  d
	..s PAPMIName=$p(^PAPER(PAPMIDR,"ALL"),"^",1)			// 姓名	PAPMI_Name PA_PatMas
	..q:(""=PAPMIName)
	..//PAPMI_IPNo
	..S PAPMIIPNo=$P(^PAPER(PAPMIDR,"PAT",1),"^",1)		//登记号	
	..d IADMOutput
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
IADMOutput
	set Data=$lb(PAPMIName, PAPMIIPNo, $g(id))
 	Set ^CacheTemp(repid, ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchIADMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchIADMExecute ]
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

ClassMethod SearchIADMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchIADMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 更新数据接口（对象）函数 给出RowId 的更改数据 没有RowId传入的将数据插入数据库
ClassMethod ISave(ParRef As %String, RowId As %String, ChildSub As %String, IADMDR As %String)
{

	s ReturnFlag=""
	s RecordIsExist=0
	i ("0"=..IsExist(ParRef,IADMDR)) d
	.s ReturnFlag=..Insert(ParRef,RowId,ChildSub,IADMDR)
	e  d
	.s ReturnFlag="Err 05" //受检人已在当前站点等候
	q ReturnFlag
}

ClassMethod IsExist(ParRef As %String, IADMDR As %String)
{
	&SQL(select * from DHC_PE_StationWait where STW_ParRef=:ParRef and STW_IADM_DR=:IADMDR)
	Q:(100=SQLCODE) "0"
	Q 1
}

/// 插入新的记录
ClassMethod Insert(ParRef As %String, RowId As %String, ChildSub As %String, IADMDR As %String)
{
	&sql(insert into DHC_PE_StationWait(STW_ParRef, STW_IADM_DR)
	     values(:ParRef,:IADMDR)
	     )

	q SQLCODE
}

/// 更改数据 未使用
ClassMethod Update(ParRef As %String, RowId As %String, ChildSub As %String, IADMDR As %String)
{
	&sql(update DHC_PE_StationWait
	     set STW_IADM_DR =:IADMDR
	     where STW_ParRef=:ParRef and STW_Childsub=:ChildSub
	     )
	 q SQLCODE
}

}
