Import SQLUser

/// 创建时间		：2006.06.07
/// 创建人		：xuwm 
/// 存在系统		：体检系统
/// 关联数据		: DHC_PE_OrderDetail
/// 索引			: ^DHCPEST(DHC_PE_Station.Rowid,”OD”,OD_ChildSub)
/// 主要功能		：
/// 主要功能		：检验细项表操作插入 删除 更改 
/// 最后修改时间	：
/// 最后修改人	：
Class web.DHCPE.OrderDetail Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 112;

// ****************************************************************************

/// 提供给Web页面 显示所有检验细项的查询 未使用(测试) 
Query QueryAll() As %SQLQuery(ROWSPEC = "OD_ParRef:%String,OD_RowId:%String,OD_ChildSub:%String,OD_Desc:%String,OD_Type:%String,OD_Expression:%String,OD_Unit:%String,OD_Summary:%String,OD_Advice:%String,OD_Explain:%String,OD_Sequence:%String, OD_Sex:%String, OD_Code:%String")
{
 select OD_ParRef,OD_RowId,OD_ChildSub,OD_Code,OD_Desc,OD_Type,OD_Expression,OD_Unit,OD_Summary,OD_Advice,OD_Explain,OD_Sequence,OD_Sex
 from DHC_PE_OrderDetail
}

/// 提供给Web页面 查询指定检验细项的 未使用
Query SearchOrderDetail(ParRef As %Library.String = "", ChildSub As %Library.String = "") As %SQLQuery(ROWSPEC = "OD_ParRef:%String,OD_RowId:%String,OD_ChildSub:%String,OD_Desc:%String,OD_Type:%String,OD_Expression:%String,OD_Unit:%String,OD_Summary:%String,OD_Advice:%String,OD_Explain:%String,OD_Sequence:%String,OD_Sex:%String, OD_Code:%String")
{
 select OD_ParRef,OD_RowId,OD_ChildSub,OD_Code,OD_Desc,OD_Type,OD_Expression,OD_Unit,OD_Summary,OD_Advice,OD_Explain,OD_Sequence,OD_Sex 
 from DHC_PE_OrderDetail
 where OD_ParRef=:ParRef and OD_ChildSub=:ChildSub
}

// 

/*
Query OrderDetailList(ParRef As %Library.String = "", ParRefName As %Library.String = "", ListTargeURL As %Library.String = "", ParamName As %Library.String = "", Desc As %Library.String = "") As %SQLQuery(ROWSPEC = "OD_Code:%String, OD_Desc:%String, OD_Type:%String, OD_RowId:%String")
{
	
	select OD_Code, OD_Desc, OD_Type, OD_RowId
	from DHC_PE_OrderDetail
	where OD_ParRef=:ParRef and OD_Desc %STARTSWITH :Desc
}
*/
/// 提供给Web页面 提供子项项目的列表 组件 DHCPEODDDCom(细项数据字典),DHCPEStationOrderCom(体检标准) DHCPEOrderDetailListCom(项目列表) 的DD_ChildSub_Name 控件使用
Query OrderDetailList(ParRef As %Library.String = "", ParRefName As %Library.String = "", ListTargeURL As %Library.String = "", ParamName As %Library.String = "", Desc As %Library.String = "") As %Query(ROWSPEC = "OD_Code:%String, OD_Desc:%String, OD_Type:%String, OD_RowId:%String")
{
}

ClassMethod OrderDetailListExecute(ByRef qHandle As %Binary, ParRef As %Library.String = "", ParRefName As %Library.String = "", ListTargeURL As %Library.String = "", ParamName As %Library.String = "", Desc As %Library.String = "") As %Status
{
    
	//q:ParRef="" ""
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Desc=##class(web.DHCPE.DHCPECommon).UnEscape(Desc)
 	i ParRef'="" d
    .s ODChildSub=0
    .f  s ODChildSub=$o(^DHCPEST(ParRef,"OD",ODChildSub))   q:ODChildSub=""  d
    ..s ODRowID=ParRef_"||"_ODChildSub
    ..s ODDesc=$p(^DHCPEST(ParRef,"OD",ODChildSub),"^",1)
    ..s ODType=$p(^DHCPEST(ParRef,"OD",ODChildSub),"^",2)
    ..s ODCode=$p(^DHCPEST(ParRef,"OD",ODChildSub),"^",11)
    ..q:ODDesc'[Desc
 	..d Find
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Find
 	set Data=$lb(ODCode,ODDesc,ODType,ODRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod OrderDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OrderDetailListExecute ]
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

ClassMethod OrderDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OrderDetailListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 根据项目名称 查找符合条件的记录
/// 使用组件
/// 	DHCPEOrderDetailRelateCom    OD_DR_Name(子项名称)
/// 		
/// 		select OD_Desc, OD_Code, OD_RowId
/// 		from DHC_PE_OrderDetail
/// 		where OD_ParRef=:ParRef and OD_Desc %STARTSWITH :Desc
/// 	
/// 	
Query FromDescOrderDetail(ParRef As %Library.String = "", Desc As %Library.String = "") As %SQLQuery(ROWSPEC = "OD_Desc:%String:名称, OD_Code:%String:编码, OD_RowId:%String:ID")
{
	select OD_Desc, OD_Code, OD_RowId
	from DHC_PE_OrderDetail
	where OD_Desc %STARTSWITH :Desc
}

/// 提供给Web页面 查询给定站点的检验细项 组件 DHCPEOrderDetailCom 使用	ParRefName参数未使用
Query SearchStationOrderDetail(ParRef As %Library.String = "", ParRefName As %Library.String = "", Desc As %Library.String = "") As %SQLQuery(ROWSPEC = "OD_ParRef:%String, OD_RowId:%String, OD_ChildSub:%String, OD_Code:%String, OD_Desc:%String, OD_Type:%String, OD_Expression:%String, OD_Unit:%String, OD_Summary:%String, OD_Advice:%String, OD_Explain:%String, OD_Sequence:%String, OD_Sex:%String, OD_LabtrakCode:%String, OD_ParRef_Name:%String")
{
 select OD_ParRef, OD_RowId, OD_ChildSub, OD_Code, OD_Desc,OD_Type, OD_Expression
        ,OD_Unit, OD_Summary, OD_Advice, OD_Explain, OD_Sequence, OD_Sex, OD_LabtrakCode
        ,s.ST_Desc as OD_ParRef_Name
 from DHC_PE_OrderDetail as od
 inner join sqluser.DHC_PE_Station as s on s.ST_RowId=od.OD_ParRef
 where OD_ParRef=:ParRef and OD_Desc %STARTSWITH :Desc
}

/// 站点细项列表																		站点编码	1		项目编码	2			项目编号	3			项目代码	4		项目名称	5		项目类型	6			表达式	7				单位	8			是否进入小结	9	是否有建编号议项	10		说明	11				顺序号	12			适用性别	13		Labtrak检验对应项目	14	站点名称 15
Query StationOrderDetailList(ParRef As %Library.String = "", Desc As %Library.String = "", Code As %Library.String) As %Query(ROWSPEC = "OD_ParRef:%String, OD_RowId:%String, OD_ChildSub:%String, OD_Code:%String, OD_Desc:%String, OD_Type:%String, OD_Expression:%String, OD_Unit:%String, OD_Summary:%String, OD_Advice:%String, OD_Explain:%String, OD_Sequence:%String, OD_Sex:%String, OD_LabtrakCode:%String, OD_ParRef_Name:%String,ZhToEng:%String,NoPrint:%String,SpecialNature:%String,Married:%String,MarriedDesc:%String,HistoryFlag:%String")
{
}

ClassMethod StationOrderDetailListExecute(ByRef qHandle As %Binary, ParRef As %Library.String = "", Desc As %Library.String = "", Code As %Library.String) As %Status
{
	
	i ""'=ParRef  d
	.s ParRefName=$p($g(^DHCPEST(ParRef)),"^",2)
	e  d
	.s ParRefName=""
	Set repid=$I(^CacheTemp)
		i ""=ParRef {	
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}

 	s ind=1
 	s id="0"	//不能使用空字符串开始 s id="" ,否则会取到 0
	f  s id=$o(^DHCPEST(ParRef,"OD",id)) q:id=""  d
	.s CurData=$g(^DHCPEST(ParRef,"OD",id))
	.
	.s iLLoop=1
	.
	.// OD_Desc	1
	.s ODDesc=$p(CurData,"^",iLLoop)
	.q:(Desc'="")&&(ODDesc'[Desc)
	.s iLLoop=iLLoop+1
	.// OD_Type	2
    .s ODType=$p(CurData,"^",iLLoop)
    .s ODType=..GetODType(ODType)
    
    .s iLLoop=iLLoop+1
    .// OD_Expression	3
    .s ODExpression=$p(CurData,"^",iLLoop)
    .
    .s iLLoop=iLLoop+1
    .// OD_Unit	4
    .s ODUnit=$p(CurData,"^",iLLoop) 
    .
    .s iLLoop=iLLoop+1
    .// OD_Summary	5
    .s ODSummary=$p(CurData,"^",iLLoop)
    .I ODSummary="Y" S ODSummary="是"
	.e  S ODSummary="否"
    .s iLLoop=iLLoop+1
    .// OD_Advice	6
    .s ODAdvice=$p(CurData,"^",iLLoop)
    .
    .s iLLoop=iLLoop+1
    .// OD_Explain	7
    .s ODExplain=$p(CurData,"^",iLLoop)
    .
    .s iLLoop=iLLoop+1
    .// OD_Sequence	8
    .s ODSequence=$p(CurData,"^",iLLoop)
    .
    .s iLLoop=iLLoop+1
    .// OD_Sex	9
    .s ODSex=$p(CurData,"^",iLLoop)
    .S ODSex=..GetODSex(ODSex)
    
    .s iLLoop=iLLoop+1
    .// OD_LabtrakCode	10
    .s ODLabtrakCode=$p(CurData,"^",iLLoop)
    .
    .s iLLoop=iLLoop+1
    .// OD_Code	11
    .s ODCode=$p(CurData,"^",iLLoop)
    .Q:(""=ODDesc)&(""=ODCode)
	.q:(Code'="")&&((Code'=" "))&&(ODCode'[Code)
	.s ZhToEng=$g(^DHCPECTDataEx("BaseData","ZhToEn",ParRef_"||"_id))
	.s NoPrint=$g(^DHCPECTDataEx("DHCPEOrderDetail","NoPrint",ParRef_"||"_id))
	.I NoPrint="Y" S NoPrint="是"
	.e  S NoPrint="否"
	
	.s HistoryFlag=$g(^DHCPECTDataEx("DHCPEOrderDetail","HistoryFlag",ParRef_"||"_id))
	.I HistoryFlag="Y" S HistoryFlag="是"
	.e  S HistoryFlag="否"
	
	.s SpecialNature=$g(^DHCPECTDataEx("OrderDetail","Range",ParRef_"||"_id))
	.s Married=$g(^DHCPECTDataEx("DHCPEOrderDetail","Married",ParRef_"||"_id))
	.s MarriedDesc=""
	.i Married'="" S MarriedDesc=$p($g(^CT("MAR",Married)),"^",2)
	.d StationOrderDetailList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK  
StationOrderDetailList
	//			站点编码 1 项目编码 2			项目编号 3 项目代码	4 项目名称 5 项目类型 6	 表达式 7	      单位 8  是否进入小结 9 是否有建编号议项 10 说明 1      顺序号 12    适用性别 13 Labtrak检验对应项目 14 站点名称 15
	set Data=$lb(ParRef, ParRef_"||"_$g(id), $g(id),  ODCode, ODDesc,  ODType,  ODExpression, ODUnit, ODSummary,   ODAdvice,        ODExplain, ODSequence, ODSex,    ODLabtrakCode,      ParRefName ,ZhToEng,NoPrint,SpecialNature,Married,MarriedDesc,HistoryFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod StationOrderDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StationOrderDetailListExecute ]
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

ClassMethod StationOrderDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StationOrderDetailListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetODType(ODType)
{
   s Type=""
	i ODType="T" S Type="说明型"
	i ODType="N" S Type="数值型"
	i ODType="C" S Type="计算型"
	i ODType="S" S Type="选择型"
	i ODType="A" S Type="多行文本"
	q Type
}

ClassMethod GetODSex(ODSex)
{
    s Sex=""
	i ODSex="M" S Sex="男"
	i ODSex="F" S Sex="女"
	i ODSex="N" S Sex="不限"
	
	q Sex
}

ClassMethod GetODCodeByID(ID, EXpession)
{
	q:RowId="" ""
	s Code=""
	s sub=""
	f  s sub=$o(^DHCPEST(ID,"OD",sub))  q:sub=""  d
	.s Code=$p($g(^DHCPEST(ID,"OD",sub)),"^", 11)
	.q:EXpession'=Code
	q:Code="" ""
	q "["_Code_"]"
}

ClassMethod GetOrdDetailByID(RowId)
{
	 q:RowId="" ""
	 s Data=$g(^DHCPEST($p(RowId,"||",1),"OD",$p(RowId,"||",2)))
	 s ZhToEng=$g(^DHCPECTDataEx("BaseData","ZhToEn",RowId))
	 s NoPrint=$g(^DHCPECTDataEx("DHCPEOrderDetail","NoPrint",RowId))
	 s SpecialNature=$g(^DHCPECTDataEx("OrderDetail","Range",RowId))
	 s Married=$g(^DHCPECTDataEx("DHCPEOrderDetail","Married",RowId))
	 s HistoryFlag=$g(^DHCPECTDataEx("DHCPEOrderDetail","HistoryFlag",RowId))
	 q Data_"^"_ZhToEng_"^"_NoPrint_"^"_SpecialNature_"^"_Married_"^"_HistoryFlag
}

/// 更新函数 具有跟新（修改）和插入的功能 
ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	
    s ParRef=$p(InString,"^",1)
    //无法传入 特殊处理 位置预留
    //s RowId=$p(InString,"^",2)
    
    s ChildSub=$p(InString,"^",3)
    
    i ""'=ChildSub d
    .s RowId=ParRef_"||"_ChildSub
    e  d
    .s RowId=""
    
    s Code=$p(InString,"^",4)
    s Desc=$p(InString,"^",5)
    s Type=$p(InString,"^",6)
    s Expression=$p(InString,"^",7)
    s Unit=$p(InString,"^",8)
    s Summary=$p(InString,"^",9)
    s Advice=$p(InString,"^",10)
    s Explain=$p(InString,"^",11)
    s Sequence=$p(InString,"^",12)
    s Sex=$p(InString,"^",13)
    s NoPrint=$p(InString,"^",14)
    s ZhToEng=$p(InString,"^",15)
    s SpecialNature=$p(InString,"^",16) 
    s Married=$p(InString,"^",17) 
    s HistoryFlag=$p(InString,"^",18)
    s ret=..ISave(ParRef,RowId,ChildSub,Code,Desc,Type,Expression,Unit,Summary,Advice,Explain,Sequence,Sex)
	if ret=0
	{
		s RowId=%ROWID
		s ^DHCPECTDataEx("BaseData","ZhToEn",RowId)=ZhToEng
		s ^DHCPECTDataEx("DHCPEOrderDetail","NoPrint",RowId)=NoPrint
		s ^DHCPECTDataEx("DHCPEOrderDetail","Married",RowId)=Married
		s ^DHCPECTDataEx("DHCPEOrderDetail","HistoryFlag",RowId)=HistoryFlag
		i SpecialNature="" d
		.k ^DHCPECTDataEx("OrderDetail","Range",RowId)
		e  d
		.s ^DHCPECTDataEx("OrderDetail","Range",RowId)=SpecialNature
	}
	q ret
}

/// 验证细项编码是否可用
/// w ##Class(web.DHCPE.OrderDetail).IsUse("","","7||11","100001")
ClassMethod IsUse(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowId As %Library.String = "", Code As %Library.String = "")
{

    &sql(select OD_RowId into :ODRowId from DHC_PE_OrderDetail where OD_Code=:Code)
    q:("100"=SQLCODE) 1		// 编码未使用,可用
    Q:(""=RowId) 0			// 编码使用,插入操作,不可用
    q:(ODRowId'=RowId) 0	// 编码使用,更改操作,不可用
    Q 1
}

/// 删除函数
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", ParRef As %Library.String = "", ChildSub As %Library.String = "")
{
	s id=ParRef_"||"_ChildSub
	&sql(select * from DHC_PE_OrderDetailRelate where ODR_OD_DR=:id)
	
	q:("0"=SQLCODE) "Err 07" //是医嘱项目的子项，不能删除
	
	&sql(delete from DHC_PE_OrderDetail where OD_ParRef=:ParRef and OD_ChildSub=:ChildSub)
	if (SQLCODE="0"){
	 	k ^DHCPECTDataEx("BaseData","ZhToEn",id)
	 	k ^DHCPECTDataEx("DHCPEOrderDetail","NoPrint",id)
	 	k ^DHCPECTDataEx("OrderDetail","Range",id)
	 	k ^DHCPECTDataEx("DHCPEOrderDetail","Married",id)
	}

	q SQLCODE
}

/// 更新数据接口（对象）函数 给出RowId 的更改数据 没有RowId传入的将数据插入数据库
ClassMethod ISave(ParRef As %String, RowId As %String, ChildSub As %String, Code As %String, Desc As %String, Type As %String, Expression As %String, Unit As %String, Summary As %String, Advice As %String, Explain As %String, Sequence As %String, Sex As %String)
{
	s ReturnFlag=""
	s ReturnFlag=..IsUse("","",RowId,Code)
	Q:("0"=ReturnFlag) "Err 03" //编码已被其他项目使用
	i (ChildSub="") d
	.s ReturnFlag=..Insert(ParRef, RowId, ChildSub, Code, Desc, Type, Expression,Unit,Summary,Advice,Explain,Sequence,Sex)
	e  d
	.s ReturnFlag=..Update(ParRef, RowId, ChildSub, Code, Desc, Type, Expression,Unit,Summary,Advice,Explain,Sequence,Sex)
	q ReturnFlag
}

/// 插入新的记录
ClassMethod Insert(ParRef As %String, RowId As %String, ChildSub As %String, Code As %String, Desc As %String, Type As %String, Expression As %String, Unit As %String, Summary As %String, Advice As %String, Explain As %String, Sequence As %String, Sex As %String)
{
	&sql(insert into DHC_PE_OrderDetail
	     (OD_ParRef,OD_Code,OD_Desc,OD_Type,OD_Expression,OD_Unit,OD_Summary,OD_Advice,OD_Explain,OD_Sequence,OD_Sex)
	     values 
	     (:ParRef,:Code,:Desc,:Type,:Expression,:Unit,:Summary,:Advice,:Explain,:Sequence,:Sex)
	     )
	q SQLCODE
}

/// 更改数据
ClassMethod Update(ParRef As %String, RowId As %String, ChildSub As %String, Code As %String, Desc As %String, Type As %String, Expression As %String, Unit As %String, Summary As %String, Advice As %String, Explain As %String, Sequence As %String, Sex As %String)
{
	&sql(update DHC_PE_OrderDetail
	
	     set OD_Code =:Code,
	     	 OD_Desc =:Desc,
	         OD_Type =:Type,
	         OD_Expression =:Expression,
	         OD_Unit =:Unit,
	         OD_Summary =:Summary,
	         OD_Advice =:Advice,
	         OD_Explain =:Explain,
	         OD_Sequence =:Sequence,
	         OD_Sex =:Sex
	     where OD_ParRef=:ParRef and OD_ChildSub=:ChildSub
	     )
	 q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.OrderDetail", "OrderDetailByStation","8","bxb")
Query OrderDetailByStation(ParRef As %Library.String = "", OrderDetail As %Library.String = "") As %Query(ROWSPEC = "OD_Desc:%String,OD_Type:%String,OD_Expression:%String,OD_Unit:%String,OD_Summary:%String,OD_Advice:%String,OD_Explain:%String,OD_Sequence:%String, OD_Sex:%String, OD_RowId:%String, OD_Code:%String,ARDesc:%String")
{
}

/// OD_Desc,OD_Type,OD_Expression,OD_Unit,OD_Summary,OD_Advice,OD_Explain,OD_Sequence, OD_Sex, OD_RowId, OD_Code")
ClassMethod OrderDetailByStationExecute(ByRef qHandle As %Binary, ParRef As %Library.String = "", OrderDetail As %Library.String = "") As %Status
{
	i ""'=ParRef  d
	.s ParRefName=$p($g(^DHCPEST(ParRef)),"^",2)
	e  d
	.s ParRefName=""
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id="0"	//不能使用空字符串开始 s id="" ,否则会取到 0
	f  s id=$o(^DHCPEST(ParRef,"OD",id)) q:id=""  d
	.s ODRowId=ParRef_"||"_id
	.s ODRDR=$O(^DHCPEODR(0,"OD",ODRowId,0))
	.s ARDesc=""
	.i ODRDR'="" d
	..s ARID=$p($G(^DHCPEODR(ODRDR)),"^",1)
	..i ARID'="" s ARDesc=$p($G(^ARCIM(+ARID,$p(ARID,"||",2),1)),"^",2)
	.s CurData=$g(^DHCPEST(ParRef,"OD",id))
	.s iLLoop=1
	.
	.// OD_Desc	1
	.s ODDesc=$p(CurData,"^",iLLoop)
	.
	.s iLLoop=iLLoop+1
	.// OD_Type	2
    .s ODType=$p(CurData,"^",iLLoop)
    .
    .s iLLoop=iLLoop+1
    .// OD_Expression	3
    .s ODExpression=$p(CurData,"^",iLLoop)
    .
    .s iLLoop=iLLoop+1
    .// OD_Unit	4
    .s ODUnit=$p(CurData,"^",iLLoop) 
    .
    .s iLLoop=iLLoop+1
    .// OD_Summary	5
    .s ODSummary=$p(CurData,"^",iLLoop)
    .
    .s iLLoop=iLLoop+1
    .// OD_Advice	6
    .s ODAdvice=$p(CurData,"^",iLLoop)
    .
    .s iLLoop=iLLoop+1
    .// OD_Explain	7
    .s ODExplain=$p(CurData,"^",iLLoop)
    .
    .s iLLoop=iLLoop+1
    .// OD_Sequence	8
    .s ODSequence=$p(CurData,"^",iLLoop)
    .
    .s iLLoop=iLLoop+1
    .// OD_Sex	9
    .s ODSex=$p(CurData,"^",iLLoop)
    .
    .s iLLoop=iLLoop+1
    .// OD_LabtrakCode	10
    .s ODLabtrakCode=$p(CurData,"^",iLLoop)
    .
    .s iLLoop=iLLoop+1
    .// OD_Code	11
    .s ODCode=$p(CurData,"^",iLLoop)
    .Q:(""=ODDesc)&(""=ODCode)
	.q:(OrderDetail'="")&&((ODDesc'[OrderDetail)&&(ODCode'[OrderDetail))
	.//q:(OrderDetail'="")&&(ODCode'[OrderDetail)
	.d OrderDetailByStation
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OrderDetailByStation
	//			站点编码 1 项目编码 2			项目编号 3 项目代码	4 项目名称 5 项目类型 6	 表达式 7	      单位 8  是否进入小结 9 是否有建编号议项 10 说明 1      顺序号 12    适用性别 13 Labtrak检验对应项目 14 站点名称 15
	set Data=$lb(ODDesc,ODType,ODExpression,ODUnit,ODSummary,ODAdvice,ODExplain,ODSequence, ODSex, ODRowId, ODCode,ARDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod OrderDetailByStationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OrderDetailByStationExecute ]
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

ClassMethod OrderDetailByStationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OrderDetailByStationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(web.DHCPE.OrderDetail).ImpLabDetail()

ClassMethod ImpLabDetail()
{
	
	s CTTCCode=""
	f  s CTTCCode=$O(^TTAB("TC",CTTCCode)) q:CTTCCode=""  d
	.d ..ImpOneLabDetail(CTTCCode)
}

ClassMethod ImpOneLabDetail(CTTCCode)
{
	s Flag="Y"
	 s loc=%session.Get("LOGON.CTLOCID")
	//s labStationId=^DHCPESetting("DHCPE","StationId_Lab")
	s labStationId=^DHCPESetting("DHCPE","StationId_Lab",loc)

	s detailDesc=$p($g(^TTAB("TC",CTTCCode)),"\",1)
  	s detailUnits=$p($g(^TTAB("TC",CTTCCode)),"\",2)
  	s detailActiveFlag=$p($g(^TTAB("TC",CTTCCode)),"\",19)
  	s myId=""
	&sql(select OD_RowId into :myId from SQLUSER.DHC_PE_OrderDetail where OD_LabTrakCode=:CTTCCode)
	i myId="" d
	.&sql( insert into SQLUSER.DHC_PE_OrderDetail(
	 		OD_Parref, OD_Code, OD_Type,  OD_Unit,  OD_DESC, OD_LabTrakCode
			) values(:labStationId,:CTTCCode, 'N',:detailUnits,:detailDesc,:CTTCCode))
	.i SQLCODE=0 d
	..s myId=%ROWID
	/*
	..s Date=0
	..f  s Date=$o(^TTAB("TC",CTTCCode,4,Date)) q:Date=""  d
	...s Type=""
	...f  s Type=$o(^TTAB("TC",CTTCCode,4,Date,Type)) q:Type=""  d
	....s Order=""
	....f  s Order=$o(^TTAB("TC",CTTCCode,4,Date,Type,Order)) q:Order=""  d
	.....s Sex=$p(^TTAB("TC",CTTCCode,4,Date,Type,Order),"\",22)
	.....s Min=$p(^TTAB("TC",CTTCCode,4,Date,Type,Order),"\",1)
	.....s Max=$p(^TTAB("TC",CTTCCode,4,Date,Type,Order),"\",2)
	.....s Age=$p(^TTAB("TC",CTTCCode,4,Date,Type,Order),"\",23)
	.....s MinAge=$p(Age,"-",1)
	.....s MaxAge=$p(Age,"-",2)
	.....&SQL(insert into SQLUSER.DHC_PE_ODStandard(
    			  ODS_ParRef, ODS_NatureValue, ODS_Sex
    			, ODS_min , ODS_Max, ODS_AgeMin, ODS_AgeMax) 
    			values (:myId,:Flag,:Sex,:Min,:Max,:MinAge,:MaxAge))
    */
    q myId
}

ClassMethod ImpOneLabDetailNew(CTTCCode, Name, Units, ZhToEng)
{
	s Flag="Y"
	 s loc=%session.Get("LOGON.CTLOCID")
	//s labStationId=^DHCPESetting("DHCPE","StationId_Lab")
	s labStationId=^DHCPESetting("DHCPE","StationId_Lab",loc)

	s detailDesc=$p($g(^TTAB("TC",CTTCCode)),"\",1)
  	s detailUnits=$p($g(^TTAB("TC",CTTCCode)),"\",2)
  	s detailActiveFlag=$p($g(^TTAB("TC",CTTCCode)),"\",19)
  	s myId=""
	&sql(select OD_RowId into :myId from SQLUSER.DHC_PE_OrderDetail where OD_LabTrakCode=:CTTCCode)
	i myId="" d
	.&sql( insert into SQLUSER.DHC_PE_OrderDetail(
	 		OD_Parref, OD_Code, OD_Type,  OD_Unit,  OD_DESC, OD_LabTrakCode,OD_Summary
			) values(:labStationId,:CTTCCode, 'N',:Units,:Name,:CTTCCode,'Y'))
	.i SQLCODE=0 d
	..s myId=%ROWID
	s ^DHCPECTDataEx("BaseData","ZhToEn",myId)=ZhToEng
	/*
	..s Date=0
	..f  s Date=$o(^TTAB("TC",CTTCCode,4,Date)) q:Date=""  d
	...s Type=""
	...f  s Type=$o(^TTAB("TC",CTTCCode,4,Date,Type)) q:Type=""  d
	....s Order=""
	....f  s Order=$o(^TTAB("TC",CTTCCode,4,Date,Type,Order)) q:Order=""  d
	.....s Sex=$p(^TTAB("TC",CTTCCode,4,Date,Type,Order),"\",22)
	.....s Min=$p(^TTAB("TC",CTTCCode,4,Date,Type,Order),"\",1)
	.....s Max=$p(^TTAB("TC",CTTCCode,4,Date,Type,Order),"\",2)
	.....s Age=$p(^TTAB("TC",CTTCCode,4,Date,Type,Order),"\",23)
	.....s MinAge=$p(Age,"-",1)
	.....s MaxAge=$p(Age,"-",2)
	.....&SQL(insert into SQLUSER.DHC_PE_ODStandard(
    			  ODS_ParRef, ODS_NatureValue, ODS_Sex
    			, ODS_min , ODS_Max, ODS_AgeMin, ODS_AgeMax) 
    			values (:myId,:Flag,:Sex,:Min,:Max,:MinAge,:MaxAge))
    */
    q myId
}

}
