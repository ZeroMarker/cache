Import SQLUser

/// Creator: 	 sufan
/// CreateDate:  2018-04-09
/// Descript:    配送岗位和类型关联维护类
Class web.DHCDISWorkLinkType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  配送岗位查询
/// Table：        DHC_DisWorkNodeType
/// Others：       w ##class(web.DHCDISWorkLinkType).QueryWorkLinkType(10,1,"")
ClassMethod QueryWorkLinkType(rows As %String, page As %String, NodeId As %String) As %String
{
	n (rows,page,NodeId)
	s end=page*rows
	s start=(page-1)*rows+1
	q:NodeId="" ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	s pid=##Class(web.DHCDISCommonDS).NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s h=0,count=0
	s NodeTypeId=0
	f  s NodeTypeId=$o(^DHCDISWNT(0,"Node",NodeId,NodeTypeId)) q:NodeTypeId=""  d  //查询表DHC_DisWorkNodeType
	.s TypeId=$p(^DHCDISWNT(NodeTypeId),"^",1)				/// 类型Id
	.s TypeDesc=""
	.i TypeId'="" s TypeDesc=$p(^DHCDISTA(TypeId),"^",2)	/// 类型描述
	.s NodeDr=$p(^DHCDISWNT(NodeTypeId),"^",2)				/// 岗位ID
	.s h=h+1
	.s tempstr=NodeTypeId_"^"_TypeId_"^"_TypeDesc_"^"_NodeDr
	.s ^TMP("DHCDIS","web.DHCDISWorkLinkType","QueryWorkLinkType",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="NodeTypeId^TypeId^TypeDesc^NodeId"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCDIS","web.DHCDISWorkLinkType","QueryWorkLinkType",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCDIS","web.DHCDISWorkLinkType","QueryWorkLinkType",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  岗位类型维护
/// Table：        DHC_DisWorkNodeType
/// Others：       w ##class(web.DHCDISWorkLinkType).SaveNodeLinkType("4^^17^报纸^")
ClassMethod SaveNodeLinkType(params As %String) As %String
{
	n (params)
	s ^tempsufan(33)=params
  	s Err=0
	s len=$L(params,"&&")
	f i=1:1:len q:Err'=0  d
	.s tmpstr=$p(params,"&&",i)
	.i $p(tmpstr,"^",2)'="" q:Err'=0  d
	..s Err=..UpdNodeLinkType(tmpstr)		 /// 更新数据
	.e  d
	..s Err=..InsNodeLinkType(tmpstr)   	 /// 插入数据
	q Err
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  岗位类型维护
/// Table：        DHC_DisWorkNodeType
/// Others：       w ##class(web.DHCDISWorkLinkType).InsNodeLinkType(10,1,"")
ClassMethod InsNodeLinkType(ListData As %String) As %String
{
	n (ListData)
	s NodeId=$p(ListData,"^",1)				/// 岗位Id
	s NodeTypeId=$p(ListData,"^",2)			/// 岗位类型表Id
	s TypeId=$p(ListData,"^",3)				/// 配送类型ID
	&sql(insert into DHC_DisWorkNodeType (WN_DisType_Dr,WN_Node_Dr) values (:TypeId,:NodeId) )
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  岗位类型维护
/// Table：        DHC_DisWorkNodeType
/// Others：       w ##class(web.DHCDISWorkLinkType).UpdNodeLinkType("3^1^21^处方/报告^3")
ClassMethod UpdNodeLinkType(ListData As %String) As %String
{
	n (ListData)
	s NodeId=$p(ListData,"^",1)				/// 岗位Id
	s NodeTypeId=$p(ListData,"^",2)			/// 岗位类型表Id
	s TypeId=$p(ListData,"^",3)				/// 配送类型ID
	&sql(update DHC_DisWorkNodeType set WN_DisType_Dr=:TypeId,WN_Node_Dr=:NodeId where WN_RowID=:NodeTypeId)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  岗位类型维护
/// Table：        DHC_DisWorkNodeType
/// Others：       w ##class(web.DHCDISWorkLinkType).DelNodeLinkType(10,1,"")
ClassMethod DelNodeLinkType(NodeTypeId)
{
	n (NodeTypeId)
	&sql(delete from DHC_DisWorkNodeType where WN_RowID=:NodeTypeId)
	q SQLCODE
}

/// descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCDIS","web.DHCDISWorkLinkType","QueryWorkLinkType",pid)
}

}
