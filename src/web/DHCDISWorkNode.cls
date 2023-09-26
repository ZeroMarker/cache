Import SQLUser

/// Creator: 	 sufan
/// CreateDate:  2018-04-09
/// Descript:    配送岗位维护类
Class web.DHCDISWorkNode Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  配送岗位查询
/// Table：        DHC_DisWorkNode
/// Others：       w ##class(web.DHCDISWorkNode).QueryDisNode(10,1,"")
ClassMethod QueryDisNode(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCDISCommonDS).NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s Code=$p(params,"^",1)
	s Desc=$p(params,"^",2)
	s h=0,count=0
	s NodeRowId=0
	f  s NodeRowId=$o(^DHCDISWN(NodeRowId)) q:NodeRowId=""  d  //查询表DHC_DisWorkNode
	.s NodeCode=$p(^DHCDISWN(NodeRowId),"^",1)			/// 岗位代码
	.s NodeDesc=$p(^DHCDISWN(NodeRowId),"^",2)			/// 岗位描述
	.s NodePerNum=$p(^DHCDISWN(NodeRowId),"^",3)		/// 岗位最大人数
	.s NodeTypeCode=$p(^DHCDISWN(NodeRowId),"^",4)		/// 岗位类型
	.s NodeType=$s(NodeTypeCode=0:"普通岗位",NodeTypeCode=1:"管理岗位",1:"")
	.q:(Code'="")&(NodeCode'[Code)
	.q:(Desc'="")&(NodeDesc'[Desc)
	.s h=h+1
	.s tempstr=NodeRowId_"^"_NodeCode_"^"_NodeDesc_"^"_NodePerNum_"^"_NodeTypeCode_"^"_NodeType
	.s ^TMP("DHCDIS","web.DHCDISWorkNode","QueryDisNode",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="NodeRowId^NodeCode^NodeDesc^NodePerNum^NodeTypeCode^NodeType"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCDIS","web.DHCDISWorkNode","QueryDisNode",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCDIS","web.DHCDISWorkNode","QueryDisNode",pid,index))
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
/// Description：  配送岗位保存
/// Table：        DHC_DisWorkNode
/// input:		   待保存数据串，分割符："^".多个串，以&&分割
/// Output：       0 ：保存成功  其他：保存失败
/// Others：       w ##class(web.DHCDISWorkNode).SaveDisNode("3^中转岗^中转岗")
ClassMethod SaveDisNode(params As %String) As %String
{
	n (params)
  	s Err=0
	s len=$L(params,"&&")
	f i=1:1:len q:Err'=0  d
	.s tmpstr=$p(params,"&&",i)
	.s Err=..CheckRepeat(tmpstr) 
	.q:Err'=0
	.i $p(tmpstr,"^",1)'="" q:Err'=0  d
	..s Err=..UpdDisNode(tmpstr)		 /// 更新数据
	.e  d
	..s Err=..InsDisNode(tmpstr)   /// 插入数据
	q Err
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  配送岗位保存
/// Table：        DHC_DisWorkNode
/// input:		   待保存数据串，分割符："^".
/// Output：       0 ：保存成功  其他：保存失败
/// Others：       w ##class(web.DHCDISWorkNode).InsDisNode("1^药品配送岗[发起科室-接收科室]^药品配送岗[发起科室-接收科室]^1^0")
ClassMethod InsDisNode(ListData As %String) As %String
{
	n (ListData)
	s NodeId=$p(ListData,"^",1)			/// 岗位Id
	s NodeCode=$p(ListData,"^",2)   	/// 岗位代码
	s NodeDesc=$p(ListData,"^",3)		/// 岗位描述
	s NodePerNum=$p(ListData,"^",4)		/// 岗位最大人数
	s NodeType=$p(ListData,"^",5)		/// 岗位类型
	&sql(insert into DHC_DisWorkNode (WN_NodeCode,WN_NodeName,WN_NodePerNum,WN_NodeType) values (:NodeCode,:NodeDesc,:NodePerNum,:NodeType) )
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  配送岗位更新
/// Table：        DHC_DisWorkNode
/// input:		   待保存数据串，分割符："^".
/// Output：       0 ：保存成功  其他：保存失败
/// Others：       w ##class(web.DHCDISWorkNode).UpdDisNode("1^药品配送岗[发起科室-接收科室]^药品配送岗[发起科室-接收科室]^1^0")
ClassMethod UpdDisNode(ListData As %String) As %String
{
	n (ListData)
	s NodeId=$p(ListData,"^",1)			/// 岗位Id
	s NodeCode=$p(ListData,"^",2)   	/// 岗位代码
	s NodeDesc=$p(ListData,"^",3)		/// 岗位描述
	s NodePerNum=$p(ListData,"^",4)		/// 岗位最大人数
	s NodeType=$p(ListData,"^",5)		/// 岗位类型
	b   //2
	&sql(update DHC_DisWorkNode set WN_NodeCode=:NodeCode,WN_NodeName=:NodeDesc, WN_NodePerNum=:NodePerNum ,WN_NodeType=:NodeType where WN_RowID=:NodeId)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  删除
/// Table：        DHC_DisWorkNode
/// input:		   NodeRowId
/// Others：       w ##class(web.DHCDISWorkNode).InsDisNode()
ClassMethod DelDisNode(NodeRowId As %String) As %String
{
	n (NodeRowId)
	&sql(delete from DHC_DisWorkNode where WN_RowID=:NodeRowId)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  重复性判断
/// Table：        DHC_DisWorkNode
ClassMethod CheckRepeat(ListData As %String) As %String
{
	N (ListData)
	s ret=0
	s ID=$p(ListData,"^",1)   		///ID
	s Code=$p(ListData,"^",2)   	///代码
	s Desc=$p(ListData,"^",3)   	///描述
	
	if ID=""  d
	.i $d(^DHCDISWN(0,"Code",$$ALPHAUP^SSUTIL4(Code))) d
	..s ret=-1
	.i $d(^DHCDISWN(0,"Name",$$ALPHAUP^SSUTIL4(Desc)))  d
	..s ret=-2
	/// 修改记录
	else  d
	.s NodeCode=$p($g(^DHCDISWN(ID)),"^",1)    //代码
	.s NodeDesc=$p($g(^DHCDISWN(ID)),"^",2)    //描述
	.i (Code'=NodeCode)&($d(^DHCDISWN(0,"Code",$$ALPHAUP^SSUTIL4(Code))))  d
	..s ret=-3
	.i (Desc'=NodeDesc)&&($d(^DHCAPARCCA(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))  d
	..s ret=-4
	q ret
}

/// descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCDIS","web.DHCDISWorkNode","QueryDisNode",pid)
}

}
