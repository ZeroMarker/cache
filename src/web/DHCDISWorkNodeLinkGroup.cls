Import SQLUser

/// Creator: 	 sufan
/// CreateDate:  2018-08-23
/// Descript:    岗位服务组关联维护
Class web.DHCDISWorkNodeLinkGroup Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2018-08-23
/// Description：  岗位服务组关联维护
/// Table：        DHC_DisWorkNodeLinkGroup
/// Others：       w ##class(web.DHCDISWorkNodeLinkGroup).QueryWorkLinkGroup(10,1,"")
ClassMethod QueryWorkLinkGroup(rows As %String, page As %String, NodeId As %String) As %String
{
	n (rows,page,NodeId)
	s end=page*rows
	s start=(page-1)*rows+1
	q:NodeId="" ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	s pid=##Class(web.DHCDISCommonDS).NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s h=0,count=0
	s NodeGroId=0
	f  s NodeGroId=$o(^DHCDISWNLG(0,"Node",NodeId,NodeGroId)) q:NodeGroId=""  d  //查询表DHC_DisWorkNodeLinkGroup
	.s SerGroupId=$p(^DHCDISWNLG(NodeGroId),"^",1)						/// 服务组Id
	.s SerGroupIDesc=""
	.i SerGroupId'="" s SerGroupIDesc=$p(^DHCDISSERG(SerGroupId),"^",2)	/// 服务组描述
	.s NodeDr=$p(^DHCDISWNLG(NodeGroId),"^",2)				/// 岗位ID
	.s h=h+1
	.s tempstr=NodeGroId_"^"_SerGroupId_"^"_SerGroupIDesc_"^"_NodeDr
	.s ^TMP("DHCDIS","web.DHCDISWorkNodeLinkGroup","QueryWorkLinkGroup",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="NodeGroId^SerGroupId^SerGroupIDesc^NodeDr"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCDIS","web.DHCDISWorkNodeLinkGroup","QueryWorkLinkGroup",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCDIS","web.DHCDISWorkNodeLinkGroup","QueryWorkLinkGroup",pid,index))
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
/// CreatDate：    2018-08-23
/// Description：  岗位服务组
/// Table：        DHC_DisWorkNodeLinkGroup
/// Others：       w ##class(web.DHCDISWorkNodeLinkGroup).SaveNodeGroup("^1^21^白静^")
ClassMethod SaveNodeGroup(params As %String) As %String
{
	n (params)
  	s Err=0
	s len=$L(params,"&&")
	f i=1:1:len q:Err'=0  d
	.s tmpstr=$p(params,"&&",i)
	.i $p(tmpstr,"^",1)'="" q:Err'=0  d
	..s Err=..UpdNodeGroup(tmpstr)		 /// 更新数据
	.e  d
	..s Err=..InsNodeGroup(tmpstr)   	 /// 插入数据
	q Err
}

/// Creator：      sufan
/// CreatDate：    2018-08-23
/// Description：  岗位服务组
/// Table：        DHC_DisWorkNodeLinkGroup
/// Others：       w ##class(web.DHCDISWorkNodeLinkGroup).InsNodeGroup(10,1,"")
ClassMethod InsNodeGroup(ListData As %String) As %String
{
	n (ListData)
	s NodeGroupId=$p(ListData,"^",1)		/// 岗位服务组Id
	s NodeId=$p(ListData,"^",2)				/// 岗位Id
	s SerGroupId=$p(ListData,"^",3)			/// 服务组ID
	&sql(insert into DHC_DisWorkNodeLinkGroup (WN_SerGro_Dr,WN_Node_Dr) values (:SerGroupId,:NodeId) )
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-08-23
/// Description：  岗位服务组
/// Table：        DHC_DisWorkNodeLinkGroup
/// Others：       w ##class(web.DHCDISWorkNodeLinkGroup).UpdNodeGroup("3^1^21^处方/报告^3")
ClassMethod UpdNodeGroup(ListData As %String) As %String
{
	n (ListData)
	s NodeGroupId=$p(ListData,"^",1)		/// 岗位服务组Id
	s NodeId=$p(ListData,"^",2)				/// 岗位Id
	s SerGroupId=$p(ListData,"^",3)			/// 服务组ID
	&sql(update DHC_DisWorkNodeLinkGroup set WN_Node_Dr=:NodeId,WN_SerGro_Dr=:SerGroupId where WN_RowID=:NodeGroupId)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-08-23
/// Description：  岗位服务组
/// Table：        DHC_DisWorkNodeLinkGroup
/// Others：       w ##class(web.DHCDISWorkNodeLinkGroup).DelNodeGroup(10,1,"")
ClassMethod DelNodeGroup(NodeGroupId)
{
	n (NodeGroupId)
	&sql(delete from DHC_DisWorkNodeLinkGroup where WN_RowID=:NodeGroupId)
	q SQLCODE
}

/// CreatDate：    2018-08-23
/// Description：  服务组下拉数据
/// Table：        DHC_DisServiceGroup
/// Others：       w ##class(web.DHCDISWorkNodeLinkGroup).QuerySerGroup("")
ClassMethod QuerySerGroup(q = "")
{
	
	s Start=1
	s Count=0
	s q=$ZCONVERT(q,"U")
	w "["
	s SerGroId=""
	f  s SerGroId = $o(^DHCDISSERG(SerGroId)) q:SerGroId=""  d
	.q:SerGroId=0
	.s SerGroDesc=$p(^DHCDISSERG(SerGroId),"^",2)
	.q:(q'="")&&(SerGroDesc'[q)
	.s Count=Count+1
	.q:Count<Start
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",SerGroId_"^"_SerGroDesc)
	w "]"
	q ""
}

/// descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCDIS","web.DHCDISWorkNodeLinkGroup","QueryWorkLinkGroup",pid)
}

}
