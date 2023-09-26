/// -------------------------------
/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：配件分类维护
/// -------------------------------
Class web.DHCEQCAccessoryCat Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 159;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "AC_RowID";

Parameter SQLDESCRIPTION = "AC_Desc";

Parameter SQLROWID = "AC_RowID";

/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：配件分类查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQCAccessoryCat","GetAccessoryCat","")
Query GetAccessoryCat(VarParCatDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TParCat:%String,TParCatDR:%String,TText:%String,TDesc:%String,TRemark:%String,TInvalidFlag:%String,TRow:%String")
{
}

ClassMethod GetAccessoryCatExecute(ByRef qHandle As %Binary, VarParCatDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s TRow=0
	d BuildDataAccessoryCat
	Quit $$$OK
BuildDataAccessoryCat
	f  s rowid=$o(^DHCEQCCode("DHCEQCAccessoryCat",rowid))  quit:rowid=""  d
	.d ResetVariablesAccessoryCat
	.s TRowID = rowid	                                            //rowid
	.s TParCatDR = $p($g(^DHCEQCCode("DHCEQCAccessoryCat",rowid)),"^",1)	    //父类DR
	.q:(TParCatDR'=VarParCatDR)&&(TParCatDR'="")&&(VarParCatDR'="")     //同一父类
	.i TParCatDR'="" s TParCat = $p($g(^DHCEQCCode("DHCEQCAccessoryCat",TParCatDR)),"^",3)  //父类
	.s TText = $p($g(^DHCEQCCode("DHCEQCAccessoryCat",rowid)),"^",2)	//代码
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",rowid)),"^",3)      //名称
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",rowid)),"^",4)    //备注
	.s TInvalidFlag= $p($g(^DHCEQCCode("DHCEQCAccessoryCat",rowid)),"^",5)	//可用标志
	.q:TInvalidFlag="Y"
	.d OutputRowAccessoryCat
	quit
OutputRowAccessoryCat
	s TRow=TRow+1
	s Data=$lb(TRowID,TParCat,TParCatDR,TText,TDesc,TRemark,TInvalidFlag,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesAccessoryCat
	s (TRowID,TParCat,TParCatDR,TText,TDesc,TRemark,TInvalidFlag)=""
	quit
}

ClassMethod GetAccessoryCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccessoryCatExecute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAccessoryCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccessoryCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Mozy003003	1246529		2020-3-27	修正SaveData()方法增加查找数据是否已存在
/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：数据添加,修改,删除
/// 访问表:DHC_EQCAccessoryCat
/// -------------------------------
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	s rowid=$p(val,"^",1)
	s SQLCODE=0
	if +isDel=2 //删除按钮操作
	{
		&SQL(Update SQLUser.DHC_EQCAccessoryCat set AC_InvalidFlag='Y' where AC_RowID = :rowid)
		q SQLCODE
	}
	k PLIST
	s PLIST(2) = $p(val,"^",2)	;ParCatDR
 	s PLIST(3) = $p(val,"^",3)	;Code
 	s Code= $p(val,"^",3)
	s PLIST(4) = $p(val,"^",4) ;Desc
	s Desc= $p(val,"^",4)
 	s PLIST(5) = $p(val,"^",5) ;Remark
 	
	i +isDel=0  //新增按钮操作
	{
		;代码或名称重复!
 		s tmpid=""
		&SQL(select AC_RowID into :tmpid from sqluser.DHC_EQCAccessoryCat where (AC_Code=:Code or AC_Desc=:Desc) and AC_InvalidFlag='N')
		i tmpid'="" q tmpid
		s PLIST(6) = "N" ;InvalidFlag
		&SQL(Insert Into SQLUSER.DHC_EQCAccessoryCat Values :PLIST())
	}
	i +isDel=1  //更新按钮操作
	{
		;代码或名称重复!
 		s tmpid=""
		&SQL(select AC_RowID into :tmpid from sqluser.DHC_EQCAccessoryCat where (AC_Code=:Code or AC_Desc=:Desc) and AC_InvalidFlag='N' and AC_RowID<>:rowid)
		i tmpid'="" q tmpid
		&SQL(Update SQLUSER.DHC_EQCAccessoryCat Values :PLIST() where AC_RowID = :rowid)
	}
	
	q SQLCODE
}

/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：根据rowid取数据
/// 访问表:DHC_EQCAccessoryCat
/// -------------------------------
ClassMethod GetDataByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	if (rowid=0)||(rowid="")  q ""
	s result= $g(^DHCEQCCode("DHCEQCAccessoryCat",rowid))
	if result="" q ""
	s resultex=resultex_"^"	;ParCatDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAccessoryCat",$p(result,"^",1))),"^",3)
	s result=result_resultex
	s result=##Class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：根据父类DR取分类名称
/// 访问表:DHC_EQCAccessoryCat
/// -------------------------------
ClassMethod GetParCat(ParCatDR)
{
	i ParCatDR="" q ""
	i ParCatDR=0 q ""
	q $P(^DHCEQCCode("DHCEQCAccessoryCat",ParCatDR),"^",3)
}

/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：根据父类DR取包含的全部子类ID
/// 访问表:DHC_EQCAccessoryCat
/// 输入：parid：父类ID
/// 返回：成功返回信息字符串格式为ID1^ID2^.....^IDn
/// -------------------------------
ClassMethod GetTreeNodeIDs(parid)
{
	s nodeids=""
	s ID=0
	f  s ID=$o(^DHCEQCCode("DHCEQCAccessoryCat",0,"ParCatDR",parid,ID))  quit:ID=""  d
	.;s ECDesc=$p(^DHCEQCCode("DHCEQCAccessoryCat",ID),"^",3)
	.s InvalidFlag=$p(^DHCEQCCode("DHCEQCAccessoryCat",ID),"^",5)
	.q:InvalidFlag="Y"
	.i nodeids'="" s nodeids=nodeids_"^"
	.s nodeids=nodeids_ID
	q nodeids
}

/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：获取当前节点的所有信息,然后根据这些信息显示树型结构
/// 访问表:DHC_EQCAccessoryCat
/// -------------------------------
ClassMethod GetTreeNode(parid, layer, preline, id)
{
	//CreateNode中参数意义对应为“节点ID，节点名称，是否有子节点，是否最后一个节点，层，父节点ID，”
	q:id=""
	s Desc=$p(^DHCEQCCode("DHCEQCAccessoryCat",id),"^",3)
	s InvalidFlag=$p(^DHCEQCCode("DHCEQCAccessoryCat",id),"^",5)
	q:InvalidFlag="Y"
	s ISChildID=..HasChild(id)
	s ISEndID=..ISEnd(parid,id)
	q ##class(web.DHCEQTree).CreateNode(id,Desc,ISChildID,ISEndID,layer,parid,preline)
}

/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：一个节点是否有子节点
/// 访问表:DHC_EQCAccessoryCat
/// -------------------------------
ClassMethod HasChild(ParID)
{
	s Total=0
	s Total=..AllInvalidFlag(ParID,0)
	i Total > 0 q 1
	q 0
}

/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：是否同一级节点的最后一个节点
/// 访问表:DHC_EQCAccessoryCat
/// -------------------------------
ClassMethod ISEnd(ParID, ID)
{
	s Total=0
	s Total=..AllInvalidFlag(ParID,ID)
	i Total > 0 q 0
	q 1
}

/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：判断一个节点后是否还有同一级的节点
/// 访问表:DHC_EQCAccessoryCat
/// -------------------------------
ClassMethod AllInvalidFlag(ParID, ID)
{
	s RowID=ID
	s Total=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCAccessoryCat",0,"ParCatDR",ParID,RowID))  quit:RowID=""  d
	.s InvalidFlag=$p(^DHCEQCCode("DHCEQCAccessoryCat",RowID),"^",5)
	.i InvalidFlag="N" s Total=Total+1
	q Total
}

/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：根据分类名称得到分类ID串，格式1^2^3,4^5
/// 访问表:DHC_EQCAccessoryCat
/// -------------------------------
ClassMethod GetCatsID(CatName)
{
	i CatName="" q ""
	s CatName=$ZCONVERT(CatName,"U")
	s ReturnCatsID=""
	s CurrentCatID=""
	s ParID=0
	s Flag="N"
	s HasFlag="N"
	f  s ParID=$o(^DHCEQCCode("DHCEQCAccessoryCat",ParID))  quit:(ParID="")  d
	.s ParName=$p(^DHCEQCCode("DHCEQCAccessoryCat",ParID),"^",3)
	.s ParCode=$p(^DHCEQCCode("DHCEQCAccessoryCat",ParID),"^",2)
	.s ParName=$ZCONVERT(ParName,"U")
	.s ParCode=$ZCONVERT(ParCode,"U")
	.i (ParName[CatName)||(ParCode[CatName) d
	..s HasFlag="N"
	..i ((ParName=CatName)||(ParCode=CatName))&&(Flag="N") d
	...s CurrentCatID=..GetParentCats(ParID)
	...s Flag="Y"
	...s HasFlag="Y"
	..i HasFlag="N" s ReturnCatsID=ReturnCatsID_..GetParentCats(ParID)_","
	i CurrentCatID'="" s ReturnCatsID=ReturnCatsID_CurrentCatID_","
	q $P(ReturnCatsID,",",1,$L(ReturnCatsID,",")-1)
}

/// 创建:ZY  2009-08-31   BugNo.：ZY0011
/// 描述：从当前节点一直取到根节点，格式1^2^3^4^5
/// 访问表:DHC_EQCAccessoryCat
/// -------------------------------
ClassMethod GetParentCats(ParID)
{
	q:ParID=""
	s ID=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",ParID)),"^",1)
	i ID'="" s ParID=..GetParentCats(ID)_"^"_ParID
	q ParID
}

}
