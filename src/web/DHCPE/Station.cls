Import SQLUser

/// 创幀o时间		：2006.06.07
/// 创建人		：xuwm
/// 存在系统		：体检系统
/// 关联数据		: DHC_PE_Station
/// 索引			: ^DHCPEST(RowId)
/// 主要功能		：
/// 主要功能		："站点"操作 插入 删除 更改 
/// 最后修改时间	：
/// 最后修改人	：
/// 完成dhcmrdiagnosnew.csp PatientID EpisodeID  dhcrisappbill.csp 
Class web.DHCPE.Station Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 40;

/// 根据输入条件查找站点 涉及组件 DHCPEStation.List
Query FindStation(aCode As %Library.String = "", aDesc As %Library.String = "", aPlace As %Library.String = "", aSequence As %Library.String = "", aActive As %Library.String = "") As %Query(ROWSPEC = "ST_RowId:%String,ST_Code:%String,ST_Desc:%String,ST_Place:%String,ST_Sequence:%String,ST_Active:%String,ST_AutoAudit:%String,ST_LayoutType:%String,ST_ButtonType:%String,ST_ReportSequence:%String,ST_AllResultShow:%String")
{
}

ClassMethod FindStationExecute(ByRef qHandle As %Binary, aCode As %Library.String = "", aDesc As %Library.String = "", aPlace As %Library.String = "", aSequence As %Library.String = "", aActive As %Library.String = "") As %Status
{
	
	i ("on"=aActive) s aActive="Y"
	Set repid=$I(^CacheTemp)
	s curLoc=%session.Get("LOGON.CTLOCID")
 	s ind=1
 	s id="0"	//不能使用空字符串开始 s id="" ,否则会取到 0
	f  s id=$o(^DHCPEST(id)) q:id=""  d
	.s CurData=$g(^DHCPEST(id))
	.s STCode=$p(CurData,"^",1)
	.q:((""'=aCode)&('(STCode[aCode)))
    .s STDesc=$p(CurData,"^",2)
    .q:((""'=aDesc)&('(STDesc[aDesc)))
    .s STPlace=$p(CurData,"^",3)
    .s STPlace=$G(^DHCPECTDataEx("DHCPEStation",id,"Place",curLoc))
    .q:((""'=aPlace)&('(STPlace[aPlace)))
    .s STSequence=$p(CurData,"^",4) 
    .q:((""'=aSequence)&('(STSequence[aSequence)))
    .s STActive=$p(CurData,"^",5)
    .q:((""'=aActive)&(STActive'=aActive))
    .i STActive="Y" S STActive="是"
    .e  s STActive="否"
    .s STAutoAudit=$p(CurData,"^",6)
    .i STAutoAudit="Y" S STAutoAudit="是"
    .e  s STAutoAudit="否"
    .s STLayoutType="",STButtonType=""
    .s STLayoutType=$p(CurData,"^",7)
    .i STLayoutType'="" s STLayoutType=STLayoutType_":"_..GetLayoutDesc(STLayoutType)
    .s STButtonType=$p(CurData,"^",8)
    .i STButtonType'="" s STButtonType=STButtonType_":"_..GetButtonDesc(STButtonType)
    .s STReportSequence=$p(CurData,"^",9)
    .s AllResultShow=$g(^DHCPECTDataEx("DHCPEStation",id,"AllResultShow",curLoc))
    .i AllResultShow="Y" S AllResultShow="是"
    .e  s AllResultShow="否"
    .d FindBuild	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb($g(id),STCode,STDesc,STPlace,STSequence,STActive,STAutoAudit,STLayoutType,STButtonType,STReportSequence,AllResultShow)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindStationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStationExecute ]
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

ClassMethod FindStationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// //////////////////////////////////////////////////////////////////////////////////

/// 提供给Web页面 列表显示所有站点的详细信息 DHCPEStationCom
Query StationAll() As %SQLQuery(ROWSPEC = "ST_RowId:%String,ST_Code:%String,ST_Desc:%String,ST_Place:%String,ST_Sequence:%String,ST_Active:%String")
{
	select ST_RowId,ST_Code,ST_desc,ST_Place,ST_Sequence,ST_Active 
	from DHC_PE_Station
}

/// 提供给Web页面 显示站点的的列表 DHCPEStationListCom
Query StationList(ListTargeURL As %Library.String = "", ParamName As %Library.String = "", OtherParam As %Library.String = "") As %SQLQuery(ROWSPEC = "ST_Desc:%String:站点名称,ST_RowId:%String:站点ID,ST_Code:%String:站点编码")
{
	select ST_desc,ST_RowId,ST_Code
	from DHC_PE_Station where ST_Active='Y'
}

/// 提供给Web页面 根据Desc查找站点 列表 
Query FromDescToStation(StationDesc As %Library.String = "") As %SQLQuery(ROWSPEC = "ST_Desc:%String,ST_RowId:%String,ST_Code:%String")
{
	select ST_desc,ST_RowId,ST_Code
	from DHC_PE_Station
	where %ALPHAUP(ST_desc) %STARTSWITH %ALPHAUP(:StationDesc)
}

/// 提供给Web页面 根据ROwId查找指定站点 所有信息
Query FromIDToStation(ID As %Library.String = "") As %SQLQuery(ROWSPEC = "ST_RowId:%String,ST_Code:%String,ST_Desc:%String,ST_Place:%String,ST_Sequence:%String,ST_Active:%String")
{
	select ST_RowId,ST_Code,ST_desc,ST_Place,ST_Sequence,ST_Active 
	from DHC_PE_Station
	where ST_RowId=:ID
}

/// 更新函数  
ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	
	//ST_RowId ST_Code ST_Desc ST_Place ST_Sequence ST_Active
	s Length=$L(InString,"^")
	s Rowid=$p(InString,"^",1)
	s Code=$p(InString,"^",2)
    s Desc=$p(InString,"^",3)
    s Place=$p(InString,"^",4)
    s Sequence=$p(InString,"^",5)
    s Active=$p(InString,"^",6)
    s AutoAudit=$p(InString,"^",7,Length)
    s ret=..ISave(Rowid,Code,Desc,Place,Sequence,Active,AutoAudit)
	
	q ret
}

/// 删除函数
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", Rowid As %Library.String = "")
{
	&sql(delete from DHC_PE_Station where ST_RowId=:Rowid)
	q SQLCODE
}

/// 获取团体信息
ClassMethod DocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s id=$g(InString)
	
	i ""=id  d
	.s Data="0^"_Code
	e  d
	.s CurData=$g(^DHCPEST(id))
	.s STCode=$p(CurData,"^",1)
    .s STDesc=$p(CurData,"^",2)
    .s STPlace=$p(CurData,"^",3)
    .s STSequence=$p(CurData,"^",4)
    .s STActive=$p(CurData,"^",5)
	.
	.//		0
	.s Data=$g(id)_"^"_STCode_"^"_STDesc_"^"_STPlace_"^"_STSequence_"^"_STActive

	s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	&javascript<#(retval)#>
	q Data
}

/// 保存数据
ClassMethod ISave(Rowid As %Library.String, Code As %Library.String, Desc As %Library.String, Place As %String, Sequence As %String, Active As %String, AutoAudit As %String = "N")
{

	s ReturnFlag=""
	i ""=Rowid d
	.s ReturnFlag=..Insert(Rowid,Code,Desc,Place,Sequence,Active,AutoAudit)
	e  d
	.i $d(^DHCPEST(Rowid)) d
	..s ReturnFlag=..Update(Rowid,Code,Desc,Place,Sequence,Active,AutoAudit)
	.e  d
	..s ReturnFlag=..Insert(Rowid,Code,Desc,Place,Sequence,Active,AutoAudit)
	q ReturnFlag
}

ClassMethod Insert(Rowid As %String, Code As %String, Desc As %String, Place As %String, Sequence As %String, Active As %String, AutoAudit As %String = "N")
{
	s curLoc=$P(Str,"^",6)
	i curLoc="" s curLoc=%session.Get("LOGON.CTLOCID")

	
	s Str=AutoAudit
	s AutoAudit=$P(Str,"^",1)
	s LayoutType=$P(Str,"^",2)
	s ButtonType=$P(Str,"^",3)
	s ReportSequence=$P(Str,"^",4)
	S AllResultShow=$P(Str,"^",5)
	S SingleRoomManager=$P(Str,"^",7)
	&sql(insert into DHC_PE_Station(ST_Code, ST_Desc, ST_Place, ST_Sequence, ST_Active,ST_AutoAudit,ST_LayoutType,ST_ButtonType,ST_ReportSequence)
	     values (:Code,:Desc,:Place,:Sequence,:Active,:AutoAudit,:LayoutType,:ButtonType,:ReportSequence))
	i SQLCODE=0 d
	.s ^DHCPECTDataEx("DHCPEStation",%ROWID,"Place",curLoc)=Place
	.S ^DHCPECTDataEx("DHCPEStation",%ROWID,"AllResultShow",curLoc)=AllResultShow
	.S:(SingleRoomManager="Y") ^DHCPESetting("DHCPE","UseSingleRoomManagerStation",curLoc)=%ROWID
	.k:(^DHCPESetting("DHCPE","UseSingleRoomManagerStation",curLoc)=%ROWID)&&((SingleRoomManager="N")) ^DHCPESetting("DHCPE","UseSingleRoomManagerStation",curLoc)
	d:SQLCODE=0 ..SetSettingGlobal(curLoc)
	Q SQLCODE_"^"_%ROWID	
	
	//q SQLCODE
}

ClassMethod Update(Rowid As %String, Code As %String, Desc As %String, Place As %String, Sequence As %String, Active As %String, AutoAudit As %String = "N")
{
	
	s Str=AutoAudit
	s AutoAudit=$P(Str,"^",1)
	s LayoutType=$P(Str,"^",2)
	s ButtonType=$P(Str,"^",3)
	s ReportSequence=$P(Str,"^",4)
	S AllResultShow=$P(Str,"^",5)
	s curLoc=$P(Str,"^",6)
	s SingleRoomManager=$P(Str,"^",7)
	i curLoc="" s curLoc=%session.Get("LOGON.CTLOCID")

	&sql(update DHC_PE_Station
	     set ST_Code =:Code,
	         ST_Desc =:Desc,
	         ST_Place =:Place,
	         ST_Sequence =:Sequence,
	         ST_Active=:Active,
	         ST_AutoAudit=:AutoAudit,
	         ST_LayoutType=:LayoutType,
	         ST_ButtonType=:ButtonType,
	         ST_ReportSequence=:ReportSequence
	     where ST_RowId= :Rowid
	     )
	 s ^DHCPECTDataEx("DHCPEStation",Rowid,"Place",curLoc)=Place
	 S ^DHCPECTDataEx("DHCPEStation",Rowid,"AllResultShow",curLoc)=AllResultShow
	 
	 
	i SingleRoomManager="Y" s ^DHCPESetting("DHCPE","UseSingleRoomManagerStation",curLoc)=Rowid
	k:(^DHCPESetting("DHCPE","UseSingleRoomManagerStation",curLoc)=Rowid)&&((SingleRoomManager="N")) ^DHCPESetting("DHCPE","UseSingleRoomManagerStation",curLoc)
	 
	 d:SQLCODE=0 ..SetSettingGlobal(curLoc)
	 q SQLCODE
}

ClassMethod SetSettingGlobal(LocID)
{
	;w ##class(web.DHCPE.Station).SetSettingGlobal()
	s RisIDs=""
	/*
	k ^DHCPESetting("DHCPE","StationId_Lab")
	k ^DHCPESetting("DHCPE","StationId_Medical")
	k ^DHCPESetting("DHCPE","StationId_Lab")
	k ^DHCPESetting("DHCPE","StationId_Ris")
	*/
	k ^DHCPESetting("DHCPE","StationId_Lab",LocID)
	k ^DHCPESetting("DHCPE","StationId_Medical",LocID)
	k ^DHCPESetting("DHCPE","StationId_Lab",LocID)
	k ^DHCPESetting("DHCPE","StationId_Ris",LocID)
	s id=0

	f  s id=$O(^DHCPEST(id)) q:id=""  d
	.s LayOutType=$p(^DHCPEST(id),"^",7)
	.i LayOutType="4" d
	..;s ^DHCPESetting("DHCPE","StationId_Lab")=id
	..s ^DHCPESetting("DHCPE","StationId_Lab",LocID)=id
	
	.i LayOutType="7" d
	..;s ^DHCPESetting("DHCPE","StationId_Other")=id
	..s ^DHCPESetting("DHCPE","StationId_Other",LocID)=id
	.i LayOutType="8" d
	..;s ^DHCPESetting("DHCPE","StationId_Medical")=id
	..s ^DHCPESetting("DHCPE","StationId_Medical",LocID)=id
	
	.i (LayOutType="5")||(LayOutType="6") d
	..i RisIDs="" d
	...s RisIDs=id
	..e  d
	...s RisIDs=RisIDs_"^"_id
	//s ^DHCPESetting("DHCPE","StationId_Ris")=RisIDs
	s ^DHCPESetting("DHCPE","StationId_Ris",LocID)=RisIDs
	q ""
}

ClassMethod OutStation(ContrlWidth As %String = "", DefaultValue = "")
{
	;StationID
	s:(""=ContrlWidth) ContrlWidth="155"
	i $L(DefaultValue,"||")>1 d
	.s obj=##class(User.DHCPERoom).%OpenId($P(DefaultValue,"$",1))
	.s DefaultValue=obj.RStationDR
	e  i DefaultValue="" d
	.;^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Default",chartID)=DefaultFlag
	.s UserID=%session.Get("LOGON.USERID")
	.s LocID=%session.Get("LOGON.CTLOCID")
	.s GroupID=%session.Get("LOGON.GROUPID")
	.s chartID=""
	.f  s chartID=$O(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Default",chartID)) q:(chartID="")||(DefaultValue'="")  d
	..s Flag=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Default",chartID))
	..s:Flag="Y" DefaultValue=chartID
	w "<select name='StationID' id='StationID' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^DHCPEST(id)) q:id=""  d
	.s Active=$p($g(^DHCPEST(id)),"^",5)
	.q:Active'="Y"
	.s selected=""
	.i id=DefaultValue s selected="selected"
	.w "<option value='"_id_"' "_selected_">"_$P($G(^DHCPEST(id)),"^",2)_"</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutStationNew(ContrlWidth As %String = "", DefaultValue = "")
{
	
	s:(""=ContrlWidth) ContrlWidth="155"
	w "<select name='StationID' id='StationID' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=2>",!
	w "<option value=''> </option>",!
	s id=0
	f  s id=$O(^DHCPEST(id)) q:id=""  d
	.s Active=$p($g(^DHCPEST(id)),"^",5)
	.s selected=""
	.i id=DefaultValue s selected="selected"
	.q:Active'="Y"
	.w "<option value='"_id_"' "_selected_">"_$P($G(^DHCPEST(id)),"^",2)_"</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutLayoutType(ContrlWidth As %String = "")
{
	s:(""=ContrlWidth) ContrlWidth="80"
	w "<select name='LayoutType' id='LayoutType' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w "<option value=''></option>",!
	w "<option value='1'>"_..GetLayoutDesc(1)_"</option>",!
	w "<option value='2'>"_..GetLayoutDesc(2)_"</option>",!
	w "<option value='3'>"_..GetLayoutDesc(3)_"</option>",!
	w "<option value='4'>"_..GetLayoutDesc(4)_"</option>",!
	w "<option value='5'>"_..GetLayoutDesc(5)_"</option>",!
	w "<option value='6'>"_..GetLayoutDesc(6)_"</option>",!
	w "<option value='7'>"_..GetLayoutDesc(7)_"</option>",!
	w "<option value='8'>"_..GetLayoutDesc(8)_"</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod GetLayoutDesc(Type)
{
	q:Type=1 "简化"
	q:Type=2 "详细"
	q:Type=3 "普通化验"
	q:Type=4 "接口化验"
	q:Type=5 "普通检查"
	q:Type=6 "接口检查"
	q:Type=7 "其它"
	q:Type=8 "药品"
	q ""
}

ClassMethod OutButtonType(ContrlWidth As %String = "")
{
	s:(""=ContrlWidth) ContrlWidth="60"
	w "<select name='ButtonType' id='ButtonType' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w "<option value=''></option>",!
	w "<option value='1'>标准</option>",!
	w "<option value='2'>妇科</option>",!
	w "<option value='3'>超声</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod GetButtonDesc(Type)
{
	q:Type=1 "标准"
	q:Type=2 "妇科"
	q:Type=3 "超声"
	q ""
}

ClassMethod GetStaionDesc(STRowId)
{
	q:STRowId="" ""
	s STDesc=""
	s STDesc=$p($g(^DHCPEST(STRowId)),"^",2)
	q STDesc
}

ClassMethod GetStaionInfoByID(STRowId)
{
	q:STRowId="" ""
	s curLoc=%session.Get("LOGON.CTLOCID")
	s Place="",AllResultShow=""
	s StationInfo=$g(^DHCPEST(STRowId))
	s Place=$g(^DHCPECTDataEx("DHCPEStation",STRowId,"Place",curLoc))
	s AllResultShow=$g(^DHCPECTDataEx("DHCPEStation",STRowId,"AllResultShow",curLoc))
	s SingleRoomManager="N"
	s SingleRoomManagerStation=$g(^DHCPESetting("DHCPE","UseSingleRoomManagerStation",curLoc))
	s:(SingleRoomManagerStation=STRowId) SingleRoomManager="Y"
	q StationInfo_"^"_Place_"^"_AllResultShow_"^"_SingleRoomManager
}

}
