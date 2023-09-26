/// -------------------------------
/// 创建:jdl 2009-09-09
/// 描述：设备分类树管理，用于定义各种分类
/// --------------------------------
Class web.DHCEQCTreeMap Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*********************************************************************************/
ClassMethod UpdateData(AppType, RowID, Data)
{
	k PLIST
	
	if (Data'="")
	{
		s ParTreeDR=$p(Data,"^",1)
		s PLIST(2)=$p($g(^DHCEQCCode("DHCEQCTreeMap",ParTreeDR)),"^",1) ;SourceType
		s PLIST(3)=$p($g(^DHCEQCCode("DHCEQCTreeMap",ParTreeDR)),"^",2) ;Type
		s Type=PLIST(3)
		s PLIST(4)=$p(Data,"^",2) ;TreeDR
		s TreeDR=$p(Data,"^",2)
		s PLIST(5)=$p(Data,"^",1) ;ParTreeDR
		s ParTreeDR=$p(Data,"^",1)
		s PLIST(7)=$p(Data,"^",3) ;Remark
		s PLIST(13)="N"
	}
	
	i +AppType=1
	{
		/*s Find=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TreeID",Type,TreeDR,0)) ///modify by mwz 2017-05-05 需求号:371746
		i Find'=""
		{
			s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCTreeMap",Find)),"^",12)
			i InvalidFlag="Y" s Find=""
		}*/
		//需求序号:	419733		Mozy	20170808	节点增加了无效字段导致记录TreeID重复,因此需要进行全表记录的过滤判断
		s Find=""
		s TMID=0
		f  s TMID=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TreeID",Type,TreeDR,TMID)) quit:(TMID="")||(Find'="")  d
		.q:$p($g(^DHCEQCCode("DHCEQCTreeMap",TMID)),"^",12)="Y"
		.s Find=TMID
		i Find'=""
		{
			i (RowID="")||(RowID'=Find)
			{
				s FindPar=$p($g(^DHCEQCCode("DHCEQCTreeMap",Find)),"^",4)
				s FindDesc=..GetTreeDesc(FindPar)
				s Treename="此项"		//czf 1967029 2021-06-22
				i PLIST(2)="CT_Loc" s Treename=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TreeDR)
				q "^设置有误!["_Treename_"]已在["_FindDesc_"]中存在!"
			}
		}
		i RowID="" //新增
		{
			&sql(insert into sqluser.DHC_EQCTreeMap  values :PLIST())
		}
		else
		{
			//检测父节点是否为其子节点的子节点
			s ParIDS=..GetParentTrees(ParTreeDR)
			i ("^"_ParIDS_"^")[("^"_RowID_"^")
			{
				s ParDesc=..GetTreeDesc(ParTreeDR)
				s TreeDesc=..GetTreeDesc(RowID)
				q "^设置有误!["_ParDesc_"]是["_TreeDesc_"]的子节点!"
			}
			&sql(update sqluser.DHC_EQCTreeMap  values :PLIST()  where TM_RowID=:RowID)
		}
	}
	i +AppType=2 //删除
	{
		//需求序号:	419733		Mozy	20170808	删除节点及其全部子节点记录
		TSTART
		s SQLCODE=0
		s TMRowIDs=##Class(web.DHCEQCTreeMap).GetAllTreeNoteIds(RowID)
		s tlen=$l(TMRowIDs,"^")
		for i=1:1:tlen q:SQLCODE'=0  d
		.s TMRowID=$p(TMRowIDs,"^",i)
		.&sql(update sqluser.DHC_EQCTreeMap set TM_InvalidFlag='Y' where TM_RowID=:TMRowID)
		If SQLCODE'=0
		{
			TROLLBACK
			Quit SQLCODE
		}
		TCOMMIT
	}
	q SQLCODE
}

/// ##Class(web.DHCEQCTreeMap).GetTreeNotes("","",parid,layer,preline,treetype)
ClassMethod GetTreeNotes(itmjs As %Library.String = "", itmjsex As %Library.String = "", parid, layer, preline, treetype)
{
	//CreateNode中参数意义对应为“节点ID，节点名称，是否有子节点，是否最后一个节点，层，父节点ID，”
	;s ^DHCEQTempJdl("GetTreeNotes")=parid_","_layer_","_preline
	s nodes=""
	s ID=0
	f  s ID=$o(^DHCEQCCode("DHCEQCTreeMap",0,"ParTreeID",parid,ID))  quit:ID=""  d
	.s ECDesc=..GetTreeDesc(ID)
	.s InvalidFlag=$p(^DHCEQCCode("DHCEQCTreeMap",ID),"^",12)
	.q:InvalidFlag="Y"
	.s ISChildID=..HasChild(ID)
	.s ISEndID=..ISEnd(parid,ID)
	.;s nodes=nodes_",ECDesc=" ;_ECDesc_",ISChildID="_ISChildID_",ISEndID="_ISEndID
	.s nodes=nodes_##class(web.DHCEQTree).CreateNode(ID,ECDesc,ISChildID,ISEndID,layer,parid,preline)
	q nodes
}

/// 获取父节点下一层的全部子节点记录
/// w ##Class(web.DHCEQCTreeMap).GetTreeNoteIds(7,"treeid")
/// modified by czf 2021-07-14 增加Type入参
ClassMethod GetTreeNoteIds(parid, Type = "")
{
	n (parid,Type)
	i parid="" q ""
	s nodeids=""
	s treeids=""
	s ID=0
	f  s ID=$o(^DHCEQCCode("DHCEQCTreeMap",0,"ParTreeID",parid,ID))  quit:ID=""  d
	.s InvalidFlag=$p(^DHCEQCCode("DHCEQCTreeMap",ID),"^",12)
	.q:InvalidFlag="Y"
	.i nodeids'="" s nodeids=nodeids_"^"
	.s nodeids=nodeids_ID
	.s treeid=$p(^DHCEQCCode("DHCEQCTreeMap",ID),"^",3)
	.i treeids'="" s treeids=treeids_","
	.s treeids=treeids_treeid
	
	i Type="treeid" q treeids
	q nodeids
}

/// w ##Class(web.DHCEQCTreeMap).GetTreeNote(parid,layer,preline)
ClassMethod GetTreeNote(parid, layer, preline, id)
{
	//CreateNode中参数意义对应为“节点ID，节点名称，是否有子节点，是否最后一个节点，层，父节点ID，”
	if id="" q ""
	s ECDesc=..GetTreeDesc(id)
	s InvalidFlag=$p(^DHCEQCCode("DHCEQCTreeMap",id),"^",12)
	q:InvalidFlag="Y" ""
	s ISChildID=..HasChild(id)
	s ISEndID=..ISEnd(parid,id)
	q ##class(web.DHCEQTree).CreateNode(id,ECDesc,ISChildID,ISEndID,layer,parid,preline)
}

/// 一个节点是否有子节点
ClassMethod HasChild(ParID)
{
	s Total=0
	s Total=..AllInvalidFlag(ParID,0)
	i Total > 0 q 1
	q 0
}

/// 是否同一级节点的最后一个节点
ClassMethod ISEnd(ParID, ID)
{
	s Total=0
	s Total=..AllInvalidFlag(ParID,ID)
	i Total > 0 q 0
	q 1
}

/// add by czf 2021-06-22
/// Input:科室ID
/// OutPut:0：不是末级科室  1:是末级科室
/// 根据科室ID判断当前科室是否是末级科室
/// w ##class(web.DHCEQCTreeMap).ISEndLoc(1)
ClassMethod ISEndLoc(LocID)
{
	i LocID="" q 1
	
	s (ParID,ID)=""
	s FindID=""
	s TMTreeID=0
	f  s TMTreeID=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TreeID",1,LocID,TMTreeID)) q:(TMTreeID="")||(FindID'="")  d
	.q:$P(^DHCEQCCode("DHCEQCTreeMap",TMTreeID),"^",12)="Y"
	.s FindID=TMTreeID
	
	i FindID="" q 1
	i $d(^DHCEQCCode("DHCEQCTreeMap",0,"ParTreeID",FindID)) q 0
	q 1
}

/// add by czf 2021-07-14
/// Input:TreeID:
/// 	  TypeID：(1：科室)
/// OutPut:TreeMapID
/// 根据TreeID和类型获取TreeMapID
/// w ##class(web.DHCEQCTreeMap).GetTreeMapIDByTreeID(437,1)
ClassMethod GetTreeMapIDByTreeID(TreeID, TypeID)
{
	n (TreeID, TypeID)
	i (TreeID="")||(TypeID="") q ""
	
	s FindID=""
	s TMTreeID=0
	f  s TMTreeID=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TreeID",TypeID,TreeID,TMTreeID)) q:(TMTreeID="")||(FindID'="")  d
	.q:$P(^DHCEQCCode("DHCEQCTreeMap",TMTreeID),"^",12)="Y"
	.s FindID=TMTreeID
	
	q FindID
}

/// 判断一个节点后是否还有同一级的节点
ClassMethod AllInvalidFlag(ParID, ID)
{
	s RowID=ID
	s Total=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCTreeMap",0,"ParTreeID",ParID,RowID))  quit:RowID=""  d
	.s InvalidFlag=$p(^DHCEQCCode("DHCEQCTreeMap",RowID),"^",12)
	.i InvalidFlag="N" s Total=Total+1
	q Total
}

/// 根据分类树名称得到分类树ID串，格式1^2^3,4^5
ClassMethod GetTreesID(CatName)
{
	i CatName="" q ""
	s CatName=$ZCONVERT(CatName,"U")
	s ReturnCatsID=""
	s CurrentCatID=""
	s ParID=0
	s Flag="N"
	s HasFlag="N"
	f  s ParID=$o(^DHCEQCCode("DHCEQCTreeMap",ParID))  quit:(ParID="")  d
	.s ParName=..GetTreeDesc(ParID)
	.s ParName=$ZCONVERT(ParName,"U")
	.i (ParName[CatName) d
	..s HasFlag="N"
	..i (ParName=CatName)&&(Flag="N") d
	...s CurrentCatID=..GetParentTrees(ParID)
	...s Flag="Y"
	...s HasFlag="Y"
	..i HasFlag="N" s ReturnCatsID=ReturnCatsID_..GetParentTrees(ParID)_","
	i CurrentCatID'="" s ReturnCatsID=ReturnCatsID_CurrentCatID_","
	q $P(ReturnCatsID,",",1,$L(ReturnCatsID,",")-1)
}

ClassMethod GetParentTrees(ParID)
{
	s ID=$p(^DHCEQCCode("DHCEQCTreeMap",ParID),"^",4)
	i ID'="" s ParID=..GetParentTrees(ID)_"^"_ParID
	q ParID
}

ClassMethod GetTreeDesc(ID)
{
	s TreeName=""
	
	s SourceType=$p($g(^DHCEQCCode("DHCEQCTreeMap",ID)),"^",1)
	s ParTreeID=$p($g(^DHCEQCCode("DHCEQCTreeMap",ID)),"^",4)
	s TreeID=$p($g(^DHCEQCCode("DHCEQCTreeMap",ID)),"^",3)
	i ParTreeID=0 q TreeID
	
	i SourceType="CT_Loc" s TreeName=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TreeID)
	q TreeName
}

/// modified by czf 2021-07-14，增加TTreeID元素
/// d ##class(%ResultSet).RunQuery("web.DHCEQCTreeMap","GetTreeByParent",1)
Query GetTreeByParent(ParTreeDR) As %Query(ROWSPEC = "TRowID:%String,TTree:%String,TRemark:%String,TRow:%String,TTreeID:%String,TLocManager:%String,TLocDirector:%String")
{
}

ClassMethod GetTreeByParentExecute(ByRef qHandle As %Binary, ParTreeDR) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	i ParTreeDR'="" d BuildDataGetTreeByParent
	Quit $$$OK
BuildDataGetTreeByParent
	// MZY0097	2083132		2021-09-22	取消注释
	f  s rowid=$o(^DHCEQCCode("DHCEQCTreeMap",0,"ParTreeID",ParTreeDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetTreeByParent
	.s TRowID = rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCTreeMap",TRowID)),"^",12)
	.q:InvalidFlag="Y"
	.s TTree=..GetTreeDesc(TRowID)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCTreeMap",TRowID)),"^",6)
	.s TTreeID=$p($g(^DHCEQCCode("DHCEQCTreeMap",TRowID)),"^",3)
	.i $p($g(^DHCEQCCode("DHCEQCTreeMap",TRowID)),"^",2)=1 d	//czf 2245455
	..s TLocManager=##Class(web.DHCEQ.Plat.CTLocUser).GetLocUserNames(TTreeID,"1")		//科室管理员
	..s TLocDirector=##Class(web.DHCEQ.Plat.CTLocUser).GetLocUserNames(TTreeID,"2")
	.d OutputRowGetTreeByParent
	quit
	
	/*;输出当前节点父元素 czf begin
	s AllParentNodes=..GetParentTrees(ParTreeDR)
	f i=1:1:$l(AllParentNodes,"^") d
	.d ResetVariablesGetTreeByParent
	.s TRowID=$p(AllParentNodes,"^",i)
	.q:TRowID=0
	.q:$p(^DHCEQCCode("DHCEQCTreeMap",TRowID),"^",4)=0
	.d GetTreeMapInfo
	.d OutputRowGetTreeByParent
	
	;获取当前节点所有子节点，包含他自身
	s AllLeafNodes=##Class(web.DHCEQCTreeMap).GetAllTreeNoteIds(ParTreeDR)
	f j=1:1:$l(AllLeafNodes,"^") d
	.d ResetVariablesGetTreeByParent
	.s TRowID=$p(AllLeafNodes,"^",j)
	.q:ParTreeDR=TRowID
	.d GetTreeMapInfo
	.d OutputRowGetTreeByParent
	
	quit
	*/
GetTreeMapInfo
	q:TRowID=""
	q:$p($g(^DHCEQCCode("DHCEQCTreeMap",TRowID)),"^",12)="Y"
	s TTree=..GetTreeDesc(TRowID)
	s TRemark=$p($g(^DHCEQCCode("DHCEQCTreeMap",TRowID)),"^",6)
	s TTreeID=$p($g(^DHCEQCCode("DHCEQCTreeMap",TRowID)),"^",3)
	i $p($g(^DHCEQCCode("DHCEQCTreeMap",TRowID)),"^",2)=1 d
	.s TLocManager=##Class(web.DHCEQ.Plat.CTLocUser).GetLocUserNames(TTreeID,"1")		//科室管理员
	.s TLocDirector=##Class(web.DHCEQ.Plat.CTLocUser).GetLocUserNames(TTreeID,"2")		//科室负责人
	quit
OutputRowGetTreeByParent                                
	s Data=$lb(TRowID,TTree,TRemark,TRow,TTreeID,TLocManager,TLocDirector)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetTreeByParent
	s (TRowID,TTree,TRemark,TTreeID,TLocManager,TLocDirector)=""
	quit
}

ClassMethod GetTreeByParentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTreeByParentExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTreeByParentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTreeByParentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOneTree(RowID)
{
	
	i RowID="" q ""
	s ResultEx=""
	s Result=$g(^DHCEQCCode("DHCEQCTreeMap",RowID))
	
	s ResultEx=ResultEx_"^"_..GetTreeDesc(RowID) //当前节点解析
	
	s ParTreeID=$p($g(^DHCEQCCode("DHCEQCTreeMap",RowID)),"^",4) //父节点解析
	i ParTreeID'=0  d
	.s ResultEx=ResultEx_"^"_..GetTreeDesc(ParTreeID)
	e  d
	.s ResultEx=ResultEx_"^"_"设备级别树"
	
	q Result_ResultEx
}

ClassMethod GetOldParTree(RowID)
{
	q $p($g(^DHCEQCCode("DHCEQCTreeMap",RowID)),"^",4)
}

/************************************************************************************/
/// 父节点放大镜选择
/// Add By DJ 2010-10-19
Query GetParentTree(Type, ParTree) As %Query(ROWSPEC = "TDesc:%String,TRowID:%String")
{
}

ClassMethod GetParentTreeExecute(ByRef qHandle As %Binary, Type, ParTree) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i Type'="" d BuildDataGetParentTree
	Quit $$$OK
BuildDataGetParentTree
	s ParTree=##Class(web.DHCEQCommon).UnEscape(ParTree)
	s ParTree=$ZCONVERT(ParTree ,"U")
	f  s rowid=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TypeTree",Type,rowid))  quit:rowid=""  d
	.d ResetVariablesGetParentTree
	.s TRowID = rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCTreeMap",TRowID)),"^",12)
	.q:InvalidFlag="Y"
	.s TDesc=..GetTreeDesc(TRowID)
	.s TDesc=$ZCONVERT(TDesc ,"U")
	.q:(ParTree'="")&&(TDesc'[ParTree)
	.d OutputRowGetParentTree
	quit
OutputRowGetParentTree                                
	s Data=$lb(TDesc,TRowID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetParentTree
	s (TDesc,TRowID)=""
	quit
}

ClassMethod GetParentTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetParentTreeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetParentTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetParentTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/*********************************************************************************/
/// Add By DJ 2010-10-27
/// 描述:判断一个节点是否另一个节点的子节点，1:是,0:否
ClassMethod IsChildPar(Type, ParentPar, ChildPar)
{
	new Flag,ParID
	s Flag=0
	s ParID=0
	s ParentPar=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TreeID",Type,ParentPar,0))
	i ParentPar="" q Flag
	f  s ParID=$o(^DHCEQCCode("DHCEQCTreeMap",0,"ParTreeID",ParentPar,ParID))  quit:(ParID="")||(Flag="1")  d
	.s InvalidFlag=$p(^DHCEQCCode("DHCEQCTreeMap",ParID),"^",12)
	.q:InvalidFlag'="N"
	.s TreeID=$p($g(^DHCEQCCode("DHCEQCTreeMap",ParID)),"^",3)
	.i TreeID=ChildPar s Flag="1"
	.q:Flag="1"
	.s Flag=..IsChildPar(Type,TreeID,ChildPar)
	q Flag
}

/// 需求序号:	419733	Mozy	2017-8-8
/// 获取节点全部子节点记录(TMRowID串)
/// 输入 ParID 记录ID
/// w ##Class(web.DHCEQCTreeMap).GetAllTreeNoteIds(7)
ClassMethod GetAllTreeNoteIds(ParID)
{
	n len,i,NoteID,TreeNoteIds
	
	s TreeNoteIds=##Class(web.DHCEQCTreeMap).GetTreeNoteIds(ParID)
	i TreeNoteIds'="" d
	.s len=$l(TreeNoteIds,"^")
	.for i=1:1:len d
	..s NoteID=$p(TreeNoteIds,"^",i)
	..s ParID=ParID_"^"_##Class(web.DHCEQCTreeMap).GetAllTreeNoteIds(NoteID)
	q ParID
}

/*********************************************************************************/
}
