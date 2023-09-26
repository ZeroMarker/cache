Import SQLUser

/// Creator: 	 sufan
/// CreateDate:  2018-04-09
/// Descript:    配送岗位和岗位人员关联维护类
Class web.DHCDISWorkNodeLinkUser Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  岗位人员维护
/// Table：        DHC_DisWorkNodeLinkUser
/// Others：       w ##class(web.DHCDISWorkNodeLinkUser).QueryWorkLinkUser(10,1,"")
ClassMethod QueryWorkLinkUser(rows As %String, page As %String, NodeId As %String) As %String
{
	n (rows,page,NodeId)
	s end=page*rows
	s start=(page-1)*rows+1
	q:NodeId="" ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	s pid=##Class(web.DHCDISCommonDS).NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s h=0,count=0
	s NodeUserId=0
	f  s NodeUserId=$o(^DHCDISWLU(0,"Node",NodeId,NodeUserId)) q:NodeUserId=""  d  //查询表DHC_DisWorkNodeType
	.s UserId=$p(^DHCDISWLU(NodeUserId),"^",1)				/// 类型Id
	.s UserDesc=""
	.i UserId'="" s UserDesc=$p(^SSU("SSUSR",UserId),"^",2)	/// 类型描述
	.s NodeDr=$p(^DHCDISWLU(NodeUserId),"^",2)				/// 岗位ID
	.s h=h+1
	.s tempstr=NodeUserId_"^"_UserId_"^"_UserDesc_"^"_NodeDr
	.s ^TMP("DHCDIS","web.DHCDISWorkNodeLinkUser","QueryWorkLinkUser",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="NodeUserId^UserId^UserDesc^NodeId"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCDIS","web.DHCDISWorkNodeLinkUser","QueryWorkLinkUser",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCDIS","web.DHCDISWorkNodeLinkUser","QueryWorkLinkUser",pid,index))
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
/// Description：  岗位人员维护
/// Table：        DHC_DisWorkNodeLinkUser
/// Others：       w ##class(web.DHCDISWorkNodeLinkUser).SaveNodeLinkUser("^1^21^白静^")
ClassMethod SaveNodeLinkUser(params As %String) As %String
{
	n (params)
	s ^tempsufan(33)=params
  	s Err=0
	s len=$L(params,"&&")
	f i=1:1:len q:Err'=0  d
	.s tmpstr=$p(params,"&&",i)
	.i $p(tmpstr,"^",1)'="" q:Err'=0  d
	..s Err=..UpdNodeLinkUser(tmpstr)		 /// 更新数据
	.e  d
	..s Err=..InsNodeLinkUser(tmpstr)   	 /// 插入数据
	q Err
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  岗位人员维护
/// Table：        DHC_DisWorkNodeLinkUser
/// Others：       w ##class(web.DHCDISWorkNodeLinkUser).InsNodeLinkUser("^1^5929^马登义 5614^")
ClassMethod InsNodeLinkUser(ListData As %String) As %String
{
	n (ListData)
	s NodeUserId=$p(ListData,"^",1)			/// 岗位人员表Id
	s NodeId=$p(ListData,"^",2)				/// 岗位Id
	s UserId=$p(ListData,"^",3)				/// 配送人员ID
	&sql(insert into DHC_DisWorkNodeLinkUser (WN_User_Dr,WN_Node_Dr) values (:UserId,:NodeId) )
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  岗位类型维护
/// Table：        DHC_DisWorkNodeLinkUser
/// Others：       w ##class(web.DHCDISWorkNodeLinkUser).UpdNodeLinkUser("3^1^21^处方/报告^3")
ClassMethod UpdNodeLinkUser(ListData As %String) As %String
{
	n (ListData)
	s NodeUserId=$p(ListData,"^",1)			/// 岗位人员表Id
	s NodeId=$p(ListData,"^",2)				/// 岗位Id
	s UserId=$p(ListData,"^",3)				/// 配送人员ID
	&sql(update DHC_DisWorkNodeLinkUser set WN_User_Dr=:UserId,WN_Node_Dr=:NodeId where WN_RowID=:NodeUserId)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  岗位类型维护
/// Table：        DHC_DisWorkNodeLinkUser
/// Others：       w ##class(web.DHCDISWorkNodeLinkUser).DelNodeLinkType(10,1,"")
ClassMethod DelNodeLinkUser(NodeUserId)
{
	n (NodeUserId)
	&sql(delete from DHC_DisWorkNodeLinkUser where WN_RowID=:NodeUserId)
	q SQLCODE
}

/// descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCDIS","web.DHCDISWorkNodeLinkUser","QueryWorkLinkUser",pid)
}

}
