Import SQLUser

/// Creator: 	 sufan
/// CreateDate:  2018-04-09
/// Descript:    岗位位置关联维护类
Class web.DHCDISNodeLinkLoc Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  中转站和科室查询
/// Table：        DHC_DisNodeLoc,CT_Loc
/// Others：       w ##class(web.DHCDISNodeLinkLoc).QueryNodeLoc(10,1,"")
ClassMethod QueryNodeLoc(rows As %String, page As %String, q)
{
	n (rows,page,q)
	s End = page*rows
	s Start=(page-1)*rows+1
	s q=$ZCONVERT(q,"U")
	s pid=##Class(web.DHCDISCommonDS).NewPid()	
	d ..killTmpGlobal(pid)
	
	d ..GetCtLocList(pid,q)    ///获取科室信息
	d ..GetNodeLocList(pid,q)  ///获取中转站信息
	
	///转换数据为Json格式
	S ListTitle="NodeLocId^NodeName^NodeCode^NodeType"
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	s index="",count=0
	f  s index=$o(^TMP("DHCDIS","web.DHCDISNodeLinkLoc","QueryNodeLoc",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCDIS","web.DHCDISNodeLinkLoc","QueryNodeLoc",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(count) //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  中转站查询
/// Table：        DHC_DisNodeLoc,CT_Loc
/// Others：       w ##class(web.DHCDISNodeLinkLoc).GetNodeLocList(1,"")
ClassMethod GetNodeLocList(pid As %String, input As %String) As %String
{
	n (pid,input)
	s NodeLocId=0
	for  s NodeLocId=$o(^DHCDISNL(NodeLocId)) q:NodeLocId=""  d
	.s NodeName=$p(^DHCDISNL(NodeLocId),"^",2)    //描述
	.q:(input'="")&($f(NodeName,input)=0)
	.s NodeCode="0"	  							  //代码
	.s NodeType="中转站"
	.s ListData=NodeLocId_"^"_NodeName_"^"_NodeCode_"^"_NodeType
	.s index=NodeLocId_"^"_NodeCode
	.s ^TMP("DHCDIS","web.DHCDISNodeLinkLoc","QueryNodeLoc",pid,index)=ListData
	q ""
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  中转站查询
/// Table：        DHC_DisNodeLoc,CT_Loc
/// Others：       w ##class(web.DHCDISNodeLinkLoc).QueryNodeLoc(10,1,"")
ClassMethod GetCtLocList(pid As %String, input As %String) As %String
{
	n (pid,input)
	s LocId=0
	f  s LocId = $o(^CTLOC(LocId)) q:LocId=""  d
	.s FromDate=$p(^CTLOC(LocId),"^",24)
	.s EndDate=$p(^CTLOC(LocId),"^",25)
	.q:(FromDate>+$h)&(FromDate'="")
	.q:(EndDate<+$h)&(EndDate'="")
	.s LocDesc = $p(^CTLOC(LocId),"^",2)
	.s LocDesc=$ZCONVERT(LocDesc,"U")
	.q:(input'="")&($f(LocDesc,input)=0)
	.s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)
	.s NodeCode="1"
	.s NodeType="科室"
	.s ListData=LocId_"^"_LocDesc_"^"_NodeCode_"^"_NodeType
	.s index=LocId_"^"_NodeCode
	.s ^TMP("DHCDIS","web.DHCDISNodeLinkLoc","QueryNodeLoc",pid,index)=ListData
	q ""
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  保存岗位关联工作位置信息
/// Table：        DHC_DisWorkNode,DHC_DisWorkNodeItm
/// Others：       w ##class(web.DHCDISNodeLinkLoc).SaveNodeLinkLoc("4^100^大十字中调^1^科室^")
ClassMethod SaveNodeLinkLoc(params As %String) As %String
{
	n (params)
  	s Err=0
	s len=$L(params,"&&")
	f i=1:1:len q:Err'=0  d
	.s tmpstr=$p(params,"&&",i)
	.i $p(tmpstr,"^",6)'="" q:Err'=0  d
	..s Err=..UpdNodeLinkLoc(tmpstr)		 /// 更新数据
	.e  d
	..s Err=..InsNodeLinkLoc(tmpstr)   		 /// 插入数据
	q Err
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  保存岗位关联工作位置信息
/// Table：        DHC_DisWorkNode,DHC_DisWorkNodeItm
/// Others：       w ##class(web.DHCDISNodeLinkLoc).InsNodeLinkLoc("4^100^大十字中调^1^科室^")
ClassMethod InsNodeLinkLoc(ListData As %String) As %String
{
	n (ListData)
	s NodeId=$p(ListData,"^",1)     	 	/// 岗位ID
	s LocationId=$p(ListData,"^",2)     	/// 工作位置ID
	s LocationFlag=$p(ListData,"^",4)  		/// 位置标识
	s ChildSub=$o(^DHCDISWN(NodeId,"I",""),-1)+1
	&sql(insert into DHC_DisWorkNodeItm(WN_ParRef,WN_ChildSub,WN_Loction,WN_LoctionFlag) 
		values(:NodeId,:ChildSub,:LocationId,:LocationFlag))
    q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  保存岗位关联工作位置信息
/// Table：        DHC_DisWorkNode,DHC_DisWorkNodeItm
/// Others：       w ##class(web.DHCDISNodeLinkLoc).UpdNodeLinkLoc(10,1,"")
ClassMethod UpdNodeLinkLoc(ListData As %String) As %String
{
	n (ListData)
	s NodeId=$p(ListData,"^",1)     	 	/// 岗位ID
	s LocationId=$p(ListData,"^",2)     	/// 工作位置ID
	s LocationFlag=$p(ListData,"^",4)  		/// 位置标识
	s NodeItmId=$p(ListData,"^",6)  		/// 子表ID
	&sql(update DHC_DisWorkNodeItm set WN_Loction=:LocationId,WN_LoctionFlag=:LocationFlag where WN_RowID=:NodeItmId)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  保存岗位关联工作位置信息
/// Table：        DHC_DisWorkNode,DHC_DisWorkNodeItm
/// Others：       w ##class(web.DHCDISNodeLinkLoc).UpdNodeLinkLoc(10,1,"")
ClassMethod DelNodeLinkLoc(NodeItmId)
{
	n (NodeItmId)
	&sql(delete from DHC_DisWorkNodeItm where WN_RowID=:NodeItmId)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  查询岗位关联工作位置信息
/// Table：        DHC_DisWorkNode,DHC_DisWorkNodeItm
/// Others：       w ##class(web.DHCDISNodeLinkLoc).QueryNodeLinkLoc(10,1,"")
ClassMethod QueryNodeLinkLoc(rows As %String, page As %String, NodeId As %String) As %String
{
	n (rows,page,NodeId)
	s End = page*rows
	s Start=(page-1)*rows+1
    s pid=##Class(web.DHCDISCommonDS).NewPid()
    i NodeId="" w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0) 
    d ..killTmpGlobal(pid) //k掉临时global
	s h=0,count=0
	s CH=""
	f  s CH=$o(^DHCDISWN(NodeId,"I",CH)) q:CH=""  d
	.s NodeItmId=NodeId_"||"_CH
	.s LocationFlag=$p(^DHCDISWN(NodeId,"I",CH),"^",2)  /// 标识
	.s LocationId=$p(^DHCDISWN(NodeId,"I",CH),"^",1)		/// 位置ID
	.i LocationFlag="0"  d
	..s LocationDesc="中转站"							/// 类型描述
	..s NlDesc=$p(^DHCDISNL(LocationId),"^",2)			/// 中转站描述
	.i LocationFlag="1"  d
	..s LocationDesc="科室"								/// 类型描述
	..s NlDesc=$p(^CTLOC(LocationId),"^",2)			/// 中转站描述
	.s h=h+1
	.s tempstr=NodeItmId_"^"_LocationId_"^"_NlDesc_"^"_LocationFlag_"^"_LocationDesc
	.s ^TMP("DHCDIS","web.DHCDISNodeLinkLoc","QueryNodeLinkLoc",pid,h)=tempstr
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="NodeItmId^LocationId^NodeCode^LocFlagCode^LocFlag"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCDIS","web.DHCDISNodeLinkLoc","QueryNodeLinkLoc",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCDIS","web.DHCDISNodeLinkLoc","QueryNodeLinkLoc",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCDIS","web.DHCDISNodeLinkLoc","QueryNodeLoc",pid)
}

}
