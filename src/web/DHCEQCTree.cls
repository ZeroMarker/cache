/// -------------------------------
/// 创建:jdl 2009-09-09
/// 描述：设备分类树管理，用于定义各种分类
/// --------------------------------
Class web.DHCEQCTree Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by csj 20191107 
Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT T_Desc,
	   T_RowID,
	   T_Code
FROM sqluser.DHC_EQCTree
where T_InvalidFlag = 'N' and T_Desc like nvl(:para,'')||'%'
}

ClassMethod UpdateData(itmjs As %Library.String = "", itmjsex As %Library.String = "", AppType, RowID, Data)
{
	k PLIST
	
	if (Data'="")
	{
		s PLIST(2)=$p(Data,"^",1) ;Type
		s PLIST(3)=$p(Data,"^",2) ;Code
		s PLIST(4)=$p(Data,"^",3) ;Desc
		s PLIST(5)=$p(Data,"^",4) ;ParTreeDR
		s PLIST(6)=$p(Data,"^",5) ;ExCode
		s PLIST(7)=$p(Data,"^",6) ;Remark
		s PLIST(8)=$p(Data,"^",7) ;Hold1
		s PLIST(9)=$p(Data,"^",8) ;Hold2
		s PLIST(10)=$p(Data,"^",9) ;Hold3
		s PLIST(11)=$p(Data,"^",10) ;Hold4
		s PLIST(12)=$p(Data,"^",11) ;Hold5
		s PLIST(13)=$p(Data,"^",12) ;Hold6
		s PLIST(14)=$p(Data,"^",13) ;Hold7
		s PLIST(15)=$p(Data,"^",14) ;Hold8
		s PLIST(16)=$p(Data,"^",15) ;Hold9
		s PLIST(17)=$p(Data,"^",16) ;Hold10
		s PLIST(18)="N"
	}
	
	i PLIST(5)="" s PLIST(5)="0"	;ParTreeDR
	
	i +AppType=0 //新增
	{
		&sql(insert into sqluser.DHC_EQCTree  values :PLIST())
	}
	i +AppType=1 //更新
	{
		&sql(update sqluser.DHC_EQCTree  values :PLIST()  where T_RowID=:RowID)
	}
	i +AppType=2 //删除
	{
		&sql(update sqluser.DHC_EQCTree set T_InvalidFlag='Y' where T_RowID=:RowID)
	}
	q SQLCODE
}

ClassMethod GetOneTree(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID)
{
	
	i RowID="" q ""
	s Result=$g(^DHCEQCCode("DHCEQCTree",RowID))
	s Result=Result_..GetParTree($p(Result,"^",4))
	q Result
}

ClassMethod GetParTree(ParTreeDR)
{
	i ParTreeDR="" q ""
	i ParTreeDR=0 q ""
	q $P(^DHCEQCCode("DHCEQCTree",ParTreeDR),"^",3)
}

ClassMethod GetTreeValue(RowID, Location)
{
	i RowID="" q ""
	i RowID=0 q ""
	q $P(^DHCEQCCode("DHCEQCTree",RowID),"^",Location)
}

Query GetTreeByParent(TreeType, ParTreeDR) As %Query(ROWSPEC = "TRowID:%String,TCode:%String:编码,TDesc:%String:描述,TParTree:%String,TParTreeDR:%String,TRemark:%String:备注,TExCode:%String:编码,TRow:%String:序号")
{
}

ClassMethod GetTreeByParentExecute(ByRef qHandle As %Binary, TreeType, ParTreeDR) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	i (TreeType'="")&&(ParTreeDR'="") d BuildDataGetTreeByParent
	Quit $$$OK
BuildDataGetTreeByParent
	f  s rowid=$o(^DHCEQCCode("DHCEQCTree",0,"ParTree",ParTreeDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetTreeByParent
	.s TRowID = rowid
	.q:TreeType'=$p($g(^DHCEQCCode("DHCEQCTree",TRowID)),"^",1)
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCTree",TRowID)),"^",17)
	.q:TInvalidFlag'="N"
	.s TCode=$p($g(^DHCEQCCode("DHCEQCTree",TRowID)),"^",2)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCTree",TRowID)),"^",3)
	.s TParCatDR=$p($g(^DHCEQCCode("DHCEQCTree",TRowID)),"^",4)
	.s TParCat=..GetTreeValue(TParCatDR,3)
	.s TExtendCode=$p($g(^DHCEQCCode("DHCEQCTree",TRowID)),"^",5)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCTree",TRowID)),"^",6)
	.
	.d OutputRowGetTreeByParent
	quit
OutputRowGetTreeByParent                                
	s Data=$lb(TRowID,TCode,TDesc,TParCat,TParCatDR,TRemark,TExtendCode,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetTreeByParent
	s (TRowID,TCode,TDesc,TParCat,TParCatDR,TRemark,TExtendCode)=""
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

/// ##Class(web.DHCEQCTree).GetTreeNotes("","",parid,layer,preline,treetype)
ClassMethod GetTreeNotes(itmjs As %Library.String = "", itmjsex As %Library.String = "", parid, layer, preline, treetype)
{
	//CreateNode中参数意义对应为“节点ID，节点名称，是否有子节点，是否最后一个节点，层，父节点ID，”
	s ^DHCEQTempJdl("GetTreeNotes")=parid_","_layer_","_preline
	s nodes=""
	s ID=0
	f  s ID=$o(^DHCEQCCode("DHCEQCTree",0,"ParTree",parid,ID))  quit:ID=""  d
	.s ECDesc=$p(^DHCEQCCode("DHCEQCTree",ID),"^",2)
	.s InvalidFlag=$p(^DHCEQCCode("DHCEQCTree",ID),"^",7)
	.q:InvalidFlag="Y"
	.s ISChildID=..HasChild(ID)
	.s ISEndID=..ISEnd(parid,ID)
	.;s nodes=nodes_",ECDesc=" ;_ECDesc_",ISChildID="_ISChildID_",ISEndID="_ISEndID
	.s nodes=nodes_##class(web.DHCEQTree).CreateNode(ID,ECDesc,ISChildID,ISEndID,layer,parid,preline)
	q nodes
}

/// ##Class(web.DHCEQCEquipeCat).GetTreeNoteIds(parid)
ClassMethod GetTreeNoteIds(parid)
{
	s nodeids=""
	s ID=0
	f  s ID=$o(^DHCEQCCode("DHCEQCTree",0,"ParTree",parid,ID))  quit:ID=""  d
	.s ECDesc=$p(^DHCEQCCode("DHCEQCTree",ID),"^",3)
	.s InvalidFlag=$p(^DHCEQCCode("DHCEQCTree",ID),"^",17)
	.q:InvalidFlag="Y"
	.i nodeids'="" s nodeids=nodeids_"^"
	.s nodeids=nodeids_ID
	q nodeids
}

/// ##Class(web.DHCEQCEquipeCat).GetTreeNote(parid,layer,preline)
ClassMethod GetTreeNote(parid, layer, preline, id)
{
	//CreateNode中参数意义对应为“节点ID，节点名称，是否有子节点，是否最后一个节点，层，父节点ID，”
	if id="" q ""
	s ECDesc=$p(^DHCEQCCode("DHCEQCTree",id),"^",3)
	s InvalidFlag=$p(^DHCEQCCode("DHCEQCTree",id),"^",17)
	q:InvalidFlag="Y" ""
	s ISChildID=..HasChild(id)
	s ISEndID=..ISEnd(parid,id)
	q ##class(web.DHCEQTree).CreateNode(id,ECDesc,ISChildID,ISEndID,layer,parid,preline)
}

/*s id=parid_"002"
	s nodes=nodes_##class(web.DHCEQTree).CreateNode(id,"节点"_id,1,1,layer,parid,preline)*/
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

/// 判断一个节点后是否还有同一级的节点
ClassMethod AllInvalidFlag(ParID, ID)
{
	s RowID=ID
	s Total=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCTree",0,"ParTree",ParID,RowID))  quit:RowID=""  d
	.s InvalidFlag=$p(^DHCEQCCode("DHCEQCTree",RowID),"^",17)
	.i InvalidFlag="N" s Total=Total+1
	q Total
}

/// 判断一个节点是否另一个节点的子节点，1:是,0:否
ClassMethod IsChildPar(ParentPar, ChildPar)
{
	new Flag,ParID
	s Flag=0
	s ParID=0
	f  s ParID=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",ParentPar,ParID))  quit:(ParID="")||(Flag="1")  d
	.s InvalidFlag=$p(^DHCEQCCode("DHCEQCEquipeCat",ParID),"^",7)
	.q:InvalidFlag'="N"
	.i ParID=ChildPar s Flag="1"
	.q:Flag="1"
	.s Flag=..IsChildPar(ParID,ChildPar)
	q Flag
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
	f  s ParID=$o(^DHCEQCCode("DHCEQCTree",ParID))  quit:(ParID="")  d
	.s ParName=$p(^DHCEQCCode("DHCEQCTree",ParID),"^",3)
	.s ParCode=$p(^DHCEQCCode("DHCEQCTree",ParID),"^",2)
	.s ParName=$ZCONVERT(ParName,"U")
	.s ParCode=$ZCONVERT(ParCode,"U")
	.i (ParName[CatName)||(ParCode[CatName) d
	..s HasFlag="N"
	..i ((ParName=CatName)||(ParCode=CatName))&&(Flag="N") d
	...s CurrentCatID=..GetParentTrees(ParID)
	...s Flag="Y"
	...s HasFlag="Y"
	..i HasFlag="N" s ReturnCatsID=ReturnCatsID_..GetParentTrees(ParID)_","
	i CurrentCatID'="" s ReturnCatsID=ReturnCatsID_CurrentCatID_","
	q $P(ReturnCatsID,",",1,$L(ReturnCatsID,",")-1)
}

ClassMethod GetParentTrees(ParID)
{
	s ID=$p(^DHCEQCCode("DHCEQCTree",ParID),"^",4)
	i ID'="" s ParID=..GetParentTrees(ID)_"^"_ParID
	//i ID="" q ParID
	q ParID
}

ClassMethod GetCodeByTreeID(ID, Location)
{
	if ID="" q ""
	s Code=$p($g(^DHCEQCCode("DHCEQCTree",ID)),"^",Location)
	if ((Code'="")&&(Code'=$c(0)))
	{	q Code	}
	else
	{
		s ID=$p($g(^DHCEQCCode("DHCEQCTree",ID)),"^",4)
		q ..GetCodeByTreeID(ID)
	}
}

}
