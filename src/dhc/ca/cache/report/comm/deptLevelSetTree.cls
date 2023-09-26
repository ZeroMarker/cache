/// Creator: 王赢赢
/// CreatDate: 2009-12-31
/// Description: 对部门分层套的基本操作
Class dhc.ca.cache.report.comm.deptLevelSetTree Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-1-11
/// Description: 1.查询当前科室在科室分层套的级别（在第几层）
/// Table：DeptLevelSets
/// Input: rowid-科室id
/// Output: 层数
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptLevelNumAndClassInDept(1,55)
ClassMethod getDeptLevelNumAndClassInDept(setid, deptid) As %String
{
 n (setid,deptid)
 s tmpRowid=setid
 s tmpPreRowid=setid
 s tmpPreRowid2=""
 s tmpMax=0
 do {
	 s tmpRowid=tmpPreRowid
	 s tmpSubid=""
 	 f  s tmpRowid=$o(^DHCCADEPTLEVELSETS(tmpRowid)) q:(tmpRowid="")||(tmpSubid'="")  d
	 .s tmpSubid=$o(^DHCCADEPTLEVELSETS(0,"Dept",tmpRowid,deptid,tmpSubid))
	 .s tmpPreRowid=tmpRowid
	 s tmpNum=0
	 s tmpid=tmpPreRowid
	 s tmpPreRowid2=tmpid
	 f  s tmpid=$p(^DHCCADEPTLEVELSETS(tmpid),"^",7) q:(tmpid=0)||(tmpid=setid)  d
	 .s tmpPreRowid2=tmpid
	 .s tmpNum=tmpNum+1
	 s tmpMax=tmpMax+1
	 ;w tmpSubid,!
 }while(tmpid=0)&&(tmpMax<9)
 q:((tmpRowid="")&&(tmpSubid=""))||(tmpMax=9) "-1"
 s tmpName=$p(^DHCCADEPTLEVELSETS(tmpPreRowid2),"^",2)
 s tmpNum=tmpNum+1
 q tmpNum_"||"_tmpName
}

/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).testDeptLevelNumAndClassInDept()
ClassMethod testDeptLevelNumAndClassInDept() As %String
{
	s tmpI=0
	f  s tmpI=$o(^DHCCADEPTLEVELSETS(tmpI)) q:tmpI=""  d
	.;w tmpI,":"
	.s tmpJ=0
	.f  s tmpJ=$o(^DHCCADEPTLEVELSETS(tmpI,"Depts",tmpJ)) q:tmpJ=""  d
	..;w tmpJ,","
	..s tmpDept=$p(^DHCCADEPTLEVELSETS(tmpI,"Depts",tmpJ),"^",1)
	..;w tmpDept,","
	..i tmpI<78 d 
	...w tmpI,"^",tmpJ,","
	...i tmpDept'="" w ..getDeptLevelNumAndClassInDept(1,tmpDept)
	..e  d
	...w tmpI,","
	...w ..getDeptLevelNumAndClassInDept(78,tmpDept)
	.;w !
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-31
/// Description: 1.查询当前科室在科室分层套的级别（在第几层）
/// Table：DeptLevelSets
/// Input: rowid-科室id
/// Output: 层数
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptLevelNumberInId(rowid)
ClassMethod getDeptLevelNumberInId(rowid) As %String
{
 n (rowid)
 s tmpCheck=..checkExistence(rowid)
 s tmpid=$p(rowid,"^",1)
 s tmpSubid=$p(rowid,"^",2)
 q:tmpCheck=-1 "-1"
 s tmpLevelNum=0
 s tmpPreid=tmpid
 f  s tmpid=..getParentid(tmpid) q:(tmpid=0)||(tmpid=-1)  d
 .s tmpLevelNum=tmpLevelNum+1
 .s tmpPreid=tmpid
 q:tmpid=-1 "-1"
 i (tmpSubid'=0)&&(tmpSubid'="") d
 .s tmpLevelNum=tmpLevelNum+1
 q tmpLevelNum
}

/// ////作废
/// Creator: 王赢赢
/// CreatDate: 2009-12-31
/// Description: 1.查询当前科室在科室分层套的级别（在第几层）
/// Table：DeptLevelSets
/// Input: setid-分层套id;code-代码
/// Output: 层数
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptLevelNumberInCode(1,10102)
ClassMethod getDeptLevelNumberInCode(setid, code) As %String
{
 n (setid,code)
 s tmpLevelNum=-1
 s tmpDeptLocation=..getDeptLocation(setid,code)
 s tmpLevelNum=..getDeptLevelNumberInId(tmpDeptLocation)
 q tmpLevelNum
}

/// Creator: 王赢赢
/// CreatDate: 2010-01-4
/// Description: 2.查询当前科室的类别（如公共、管理、医辅、直接、科研等）
/// Table：DeptLevelSets
/// Input: rowid-科室id
/// Output: 类别
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptClassInId(1,1005)
ClassMethod getDeptClassInId(rowid) As %String
{
 n (rowid)
 s tmpDeptLocation=rowid
 q:tmpDeptLocation="0^0" "-1"
 s tmpRowid=$p(tmpDeptLocation,"^",1)
 i ($p(rowid,"^",2)="") d
 .s tmpSubid=0
 e  d
 .s tmpSubid=$p(rowid,"^",2)
 q:('$d(^DHCCADEPTLEVELSETS(tmpRowid,"Depts",tmpSubid))) "-1"
 f  q:..getDeptLevelNumberInId(tmpRowid)=1  d
 .s tmpRowid=..getParentid(tmpRowid)
 //s tmpDeptClass=$p(^DHCCADEPTLEVELSETS(tmpRowid),"^",2)
 q tmpRowid
}

/// Creator: 王赢赢
/// CreatDate: 2010-01-4
/// Description: 2.查询当前科室的类别（如公共、管理、医辅、直接、科研等）
/// Table：DeptLevelSets
/// Input: setid-分层套id;code-代码
/// Output: 类别
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptClassInCode(1,1005)
ClassMethod getDeptClassInCode(setid, code) As %String
{
 n (setid,code)
 s tmpDeptLocation=..getDeptLocation(setid,code)
 s tmpRowid=..getDeptClassInId(tmpDeptLocation)
 q tmpRowid
}

/// Creator: 王赢赢
/// CreatDate: 2010-01-4
/// Description: 3.查询当前科室在成本分摊过程中的上一级（下一级，同一级）类别所有科室
/// Table：DeptLevelSets
/// Input: setid-分层套id;rowid-id;direction-0:同一级,-1:上一级,1:下一级
/// Output: 科室rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptUpDownClassInId(1,6,-1)
ClassMethod getDeptUpDownClassInId(setid, rowid, direction) As %String
{
 n (setid,rowid,direction)
 s tmpRowid=rowid
 s tmpRowid=..getOneSiblingsUnleaf(tmpRowid,direction)
 s tmpRowids=""
 i tmpRowid'="" d
 .s tmpRowids=..getCurrentClass(setid,tmpRowid)
 q tmpRowids
}

/// Creator: 王赢赢
/// CreatDate: 2010-01-4
/// Description: 3.查询当前科室在成本分摊过程中的上一级（下一级，同一级）类别所有科室
/// Table：DeptLevelSets
/// Input: setid-分层套id;code-代码;direction-0:同一级,-1:上一级,1:下一级
/// Output: 科室rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptUpDownClassInCode(1,10105,-1)
ClassMethod getDeptUpDownClassInCode(setid, code, direction) As %String
{
 n (setid,code,direction)
 s tmpRowid=..getDeptClassInCode(setid,code)
 s tmpRowid=..getOneSiblingsUnleaf(tmpRowid,direction)
 s tmpRowids=""
 i tmpRowid'="" d
 .s tmpRowids=..getCurrentClass(setid,tmpRowid)
 q tmpRowids
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-31
/// Description: 4.查询当前科室在成本分摊过程中上面（下面）的所有类别中的所有科室 
/// Table：DeptLevelSets
/// Input: setid-分层套id;rowid-id;direction- -1:上一级,1:下一级
/// Output:  科室rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptAllUpDownClassInId(1,6,-1)
ClassMethod getDeptAllUpDownClassInId(setid, rowid, direction) As %String
{
 n (setid,rowid,direction)
 s tmpSib=rowid
 s tmpRowids=""
 f  s tmpSib=..getOneSiblingsUnleaf(tmpSib,direction)  q:tmpSib=""  d
 .i tmpRowids="" d
 ..s tmpRowids=..getCurrentClass(setid,tmpSib)
 .e  d
 ..s tmpRowids=tmpRowids_"||"_..getCurrentClass(setid,tmpSib)
 q tmpRowids
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-31
/// Description: 4.查询当前科室在成本分摊过程中上面（下面）的所有类别中的所有科室 
/// Table：DeptLevelSets
/// Input: setid-分层套id;code-代码;direction- -1:上一级,1:下一级
/// Output:  科室rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptAllUpDownClassInCode(1,10105,-1)
ClassMethod getDeptAllUpDownClassInCode(setid, code, direction) As %String
{
 n (setid,code,direction)
 s tmpSib=..getDeptClassInCode(setid,code)
 s tmpRowids=""
 f  s tmpSib=..getOneSiblingsUnleaf(tmpSib,direction)  q:tmpSib=""  d
 .i tmpRowids="" d
 ..s tmpRowids=..getCurrentClass(setid,tmpSib)
 .e  d
 ..s tmpRowids=tmpRowids_"||"_..getCurrentClass(setid,tmpSib)
 q tmpRowids
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-31
/// Description: 5.查询当前类别中当前科室的上级（下级、同级）科室 
/// Table：DeptLevelSets
/// Input: rowid-id;direction-0:同一级,-1:上一级,1:下一级
/// Output: 科室rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptUpDownInId("3^3",1)
ClassMethod getDeptUpDownInId(rowid, direction) As %String
{
 n (rowid,direction)
 s tmpRowid=rowid
 s tmpRowids=-1
 i direction=0 d
 .s tmpRowids=..getAllSiblings(tmpRowid)
 e  i direction=1 d
 .s tmpRowids=..getChildren(tmpRowid)
 e  i direction=-1 d
 .i $p(tmpRowid,"^",2)=0 d
 ..i ..getDeptLevelNumberInId($p(tmpRowid,"^",1))>2 d
 ...s tmpRowid=..getParentid($p(tmpRowid,"^",1))
 ...s tmpRowids=..getAllSiblings(tmpRowid)
 .e  d
 ..i ..getDeptLevelNumberInId($p(tmpRowid,"^",1))>1 d
 ...s tmpRowid=$p(tmpRowid,"^",1)_"^0"
 ...s tmpRowids=..getAllSiblings(tmpRowid)
 q tmpRowids
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-31
/// Description: 5.查询当前类别中当前科室的上级（下级、同级）科室 
/// Table：DeptLevelSets
/// Input: setid-分层套id;code-代码;direction-0:同一级,-1:上一级,1:下一级
/// Output: 科室rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptUpDownInCode(1,1010205,1)
ClassMethod getDeptUpDownInCode(setid, code, direction) As %String
{
 n (setid,code,direction)
 s tmpRowid=..getDeptLocation(setid,code)
 s tmpRowids=..getDeptUpDownInId(tmpRowid,direction)
 q tmpRowids
}

/// ////////////////////////////////////////
/// Creator：秦虎
/// CreatDate：2010-1-16
/// Description: 查询所有父级科室
/// Table：DHCCAUNITDEPTS
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAUNITDEPTS table
/// Output：
/// Return：返回科室列表 RowId1^RowId2^...
/// Others：w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptlevelSetSortedTree(1,1)
ClassMethod AllParentLocIdFindByUnitdeptsId(deptSetDr, unitdeptsId) As %String
{
	n (deptSetDr, unitdeptsId)
	s deptlevelSetId=..getIdInDeptlevelSet(deptSetDr,unitdeptsId)

	Quit:deptlevelSetId="-1" ""

	Quit ..AllParentLocIdFindByDeptlevelId(deptlevelSetId)
}

/// Creator：秦虎
/// CreatDate：2010-1-16
/// Description: 查询所有父级科室
/// Table：DHCCADEPTLEVELSETS
/// Input：RowId in DHCCADEPTLEVELSETS table
/// Output：
/// Return：返回科室列表 RowId1^RowId2^...
/// Others：w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).AllParentLocIdFindByDeptlevelId(1)
ClassMethod AllParentLocIdFindByDeptlevelId(deptlevelSetId) As %String
{
	n (deptlevelSetId)
	s parentId = deptlevelSetId
	s allParentId = deptlevelSetId
	f  s parentId = ..getParentid(parentId) q:(parentId=0)||(parentId="")  d
	.Set allParentId=allParentId_"^"_parentId
	
	Quit allParentId
}

/// Creator: 秦虎
/// CreatDate: 2010-1-16
/// Description: 查询单位部门码表的科室在指定科室分层套中的父层科室
/// Table：DeptLevelSets
/// Input: deptSetDr---科室分层套RowId, RowId in DHCCAUNITDEPTS table
/// Output: 科室rowid
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getIdInDeptlevelSet(1,1)
ClassMethod getIdInDeptlevelSet(deptSetDr, unitdeptsId) As %String
{
 n (deptSetDr, unitdeptsId)
 s rowId="-1"
 s chidrenId=0
 s flag = 0
 s res = "-1"
 f  s chidrenId=$o(^DHCCADEPTLEVELSETS(0,"Parent",deptSetDr,chidrenId)) q:(chidrenId="")||(flag=1)||(res'="-1")  d
 .i $d(^DHCCADEPTLEVELSETS(0,"Dept",chidrenId,unitdeptsId)) d
 ..s rowId=chidrenId
 ..s flag=1
 .s res=..getIdInDeptlevelSet(chidrenId,unitdeptsId)
 i flag=0 s rowId=res
 q rowId
}

/// Creator: 秦虎
/// CreatDate: 2010-1-16
/// Description: 生成排序好的科室分层套树形结构
/// Table：DeptLevelSets
/// Input: deptSetDr---科室分层套RowId
/// Output: 树形结构临时global,值为排序号_"||"_父级科室id
/// Others:  w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptlevelSetSortedTree(1,1)
ClassMethod getDeptlevelSetSortedTree(deptSetDr As %Integer, sortNum As %Integer) As %String
{
 n (deptSetDr,sortNum)
 s order=""
 f  s order=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",deptSetDr,order)) q:(order="")  d
 .s chidrenId=0
 .f  s chidrenId=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",deptSetDr,order,chidrenId)) q:(chidrenId="")  d
 ..s sortNum=sortNum+1
 ..s allParentLocId=..AllParentLocIdFindByDeptlevelId(chidrenId)
 ..;w allParentLocId
 ..s ^tmpdhccadeptleveltree($j,"trunk",chidrenId)=sortNum_"||"_allParentLocId
 ..s sortNum=..getDeptlevelSetSortedTree(chidrenId,sortNum)
 ..s leafId = 0
 ..f  s leafId=$o(^DHCCADEPTLEVELSETS(0,"Dept",chidrenId,leafId)) q:(leafId="")  d
 ...s sortNum=sortNum+1
 ...s allParentLocId=..AllParentLocIdFindByUnitdeptsId(deptSetDr, leafId)
 ...s ^tmpdhccadeptleveltree($j,"leaf",leafId)=sortNum_"||"_allParentLocId
 q sortNum
}

/// Creator: wang ying
/// CreatDate: 2010-5-12
/// Description: 生成排序好的科室分层套树形结构,带有一层的末端科室
/// Table：DeptLevelSets
/// Input: deptSetDr---科室分层套RowId
/// Output: 树形结构临时global,值为排序号_"||"_父级科室id
/// Others:  w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptTreeAddLeaf(1,1)
ClassMethod getDeptTreeAddLeaf(deptSetDr As %Integer, sortNum As %Integer) As %String
{
 n (deptSetDr,sortNum)
 s sortNum = ..getDeptlevelSetSortedTree(deptSetDr,sortNum)
 s leafDeptDr = 0
 f  s leafDeptDr=$o(^DHCCADEPTLEVELSETS(deptSetDr,"Depts",leafDeptDr))  q:leafDeptDr=""  d
 .s sortNum = sortNum+1
 .s deptDr = $p(^DHCCADEPTLEVELSETS(deptSetDr,"Depts",leafDeptDr),"^",1)
 .s ^tmpdhccadeptleveltree($j,"leaf",deptDr)=sortNum_"||"_deptSetDr
 q sortNum
}

/// ////////////////////////////////////////////
/// Creator: 王赢赢
/// CreatDate: 2009-12-31
/// Description: 6.输出指定科室分层套的科室树形结构（全部、局部）
/// Table：DeptLevelSets
/// Input:tmpTreeName-临时global第一节点处名称 rowid-id
/// Output: 形成多条形如^tmpDept("tmpTreeName",$j,rowid,subid)数据
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).genDeptTree("tmp",6)
ClassMethod genDeptTree(tmpTreeName, rowid) As %String
{
 n (rowid,tmpTreeName)
 s job=$j
 k ^tmpDept
 s ^tmpDept(tmpTreeName,job,0)=0
 k ^tmpDepts
 d ..nextDeptLevel(tmpTreeName,job,rowid,"0")
 s tmpOrder=0
 s curser=""
 f  s curser=$o(^tmpDept(tmpTreeName,job,curser)) q:curser=""  d
 .s curserJ=""
 .f  s curserJ=$o(^tmpDept(tmpTreeName,job,curser,curserJ)) q:curserJ=""  d
 ..;w curser,",",curserJ,!
 ..s rCurser=..revertStr(curser)
 ..s tmpOrder=tmpOrder+1
 ..s tmpCheck=..checkStr(curser)
 ..s tmpNum=$p(tmpCheck,"^",2)
 ..s tmpDept=$p(tmpCheck,"^",1)
 ..i curserJ=0  d
 ...s tmpADept=$p(^DHCCADEPTLEVELSETS(tmpDept),"^",2)
 ...;w ^tmpDept(tmpTreeName,job,curser,curserJ),!
 ...s ^tmpDepts(^tmpDept(tmpTreeName,job,curser,curserJ))=tmpADept_"^"_tmpNum_"^"_"unLeaf"_"^"_rCurser_"^"_curserJ
 ..e  d
 ...s tmpADeptDr=$p(^DHCCADEPTLEVELSETS(tmpDept,"Depts",curserJ),"^",1)
 ...i tmpADeptDr'="" d
 ....s tmpADept=$p(^DHCCAUNITDEPTS(tmpADeptDr),"^",2)
 ....s tmpNum=tmpNum+1
 ....;w ^tmpDept(tmpTreeName,job,curser,curserJ),!
 ....s ^tmpDepts(^tmpDept(tmpTreeName,job,curser,curserJ))=tmpADept_"^"_tmpNum_"^"_"leaf"_"^"_rCurser_"^"_curserJ
 ..;w tmpDept,",",curserJ,",",tmpADept,!
}

/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).revertStr("0||1||157")
ClassMethod revertStr(deptStru) As %String
{
 n (deptStru)
 s tmpCur=0
 s preRowid=""
 s num=0
 s tmp=""
 f  s tmpCur=tmpCur+1 q:$p(deptStru,"||",tmpCur)=""  d
 .s preRowid=$p(deptStru,"||",tmpCur)
 .s num=num+1
 .i tmp="" d
 ..s tmp=preRowid
 .e  d
 ..s tmp=preRowid_"||"_tmp
 q tmp
}

/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).checkStr("0||1||157")
ClassMethod checkStr(deptStru) As %String
{
 n (deptStru)
 s tmpCur=0
 s preRowid=""
 s num=0
 f  s tmpCur=tmpCur+1 q:$p(deptStru,"||",tmpCur)=""  d
 .;w $p(deptStru,"||",tmpCur),!
 .s preRowid=$p(deptStru,"||",tmpCur)
 .s num=num+1
 s num=num-2
 s tmp=preRowid_"^"_num
 q tmp
}

/// Creator: 王赢赢
/// CreatDate: 2009-1-5
/// Description: 
/// Table：DeptLevelSets
/// Input: rowid-id
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).nextDeptLevel("tmp1",0,6,0)
ClassMethod nextDeptLevel(tmpTreeName, job, rowid, newid) As %String
{
 n (tmpTreeName,job,rowid,newid)
 s tmpOrder=^tmpDept(tmpTreeName,job,0)
 s tmpOrder=tmpOrder+1
 s ^tmpDept(tmpTreeName,job,0)=tmpOrder
 s newid=newid_"||"_rowid
 s ^tmpDept(tmpTreeName,job,newid,0)=tmpOrder
 s tmpOrder=tmpOrder+1
 s ^tmpDept(tmpTreeName,job,0)=tmpOrder
 i $D(^DHCCADEPTLEVELSETS(rowid,"Depts")) d
 .s tmpSubOrder=""
 .f  s tmpSubOrder=$o(^DHCCADEPTLEVELSETS(0,"DeptOrder",rowid,tmpSubOrder)) q:tmpSubOrder=""  d
 ..s tmpSubid=""
 ..s tmpSubid=$o(^DHCCADEPTLEVELSETS(0,"DeptOrder",rowid,tmpSubOrder,tmpSubid))
 ..s ^tmpDept(tmpTreeName,job,newid,tmpSubid)=tmpOrder
 ..s tmpOrder=tmpOrder+1
 ..s ^tmpDept(tmpTreeName,job,0)=tmpOrder
 i $D(^DHCCADEPTLEVELSETS(0,"Parent",rowid)) d
 .s tmpChildid=0
 .f  s tmpChildid=$o(^DHCCADEPTLEVELSETS(0,"Parent",rowid,tmpChildid)) q:tmpChildid=""  d
 ..d ..nextDeptLevel(tmpTreeName,job,tmpChildid,newid)
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-31
/// Description: rowid是否存在
/// Table：DeptLevelSets
/// Input: rowid-科室id
/// Output: -1-不存在;1-存在;
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).checkExistence(52)
ClassMethod checkExistence(rowid) As %String
{
 s flag=-1
 s tmpid=$p(rowid,"^",1)
 i ($p(rowid,"^",2)="") d
 .i ($d(^DHCCADEPTLEVELSETS(tmpid))=1)||($d(^DHCCADEPTLEVELSETS(tmpid))=11) d 
 ..s flag=1
 e  d
 .s tmpSubid=$p(rowid,"^",2)
 .i $d(^DHCCADEPTLEVELSETS(tmpid,"Depts",tmpSubid)) d
 ..s flag=1
 q flag
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-31
/// Description: 查询当前科室的父id
/// Table：DeptLevelSets
/// Input: rowid
/// Output: 父id,不存在为-1
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getParentid(78)
ClassMethod getParentid(rowid) As %String
{
 n (rowid)
 s tmpCheck=..checkExistence(rowid)
 q:tmpCheck=-1 "-1"
 s tmpid=$p(rowid,"^",1)
 s tmpSubid=$p(rowid,"^",2)
 i tmpSubid>0 d
 .s tmpPar=tmpid
 e  d
 .s tmpPar=$p($g(^DHCCADEPTLEVELSETS(tmpid)),"^",7)
 s tmpCheck=..checkExistence(tmpPar)
 q:tmpCheck=-1 "-1"
 q tmpPar
}

/// ///作废
/// Creator: 王赢赢
/// CreatDate: 2009-12-31
/// Description: 查询当前科室的位置
/// Table：DeptLevelSets
/// Input: setid-分层套id;code-代码
/// Output: rowid^subid,非叶子节点subid为0,0^0为未找到
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptLocation(1,110565)
ClassMethod getDeptLocation(setid, code) As %String
{
 n (setid,code)
 s tmpDeptLocation="0^0"
 s tmpRow=0
 f  s tmpRow=$o(^DHCCADEPTLEVELSETS(tmpRow))  q:tmpRow=""  d
 .i ..getDeptSetid(tmpRow)=setid d
 ..i $p(^DHCCADEPTLEVELSETS(tmpRow),"^",1)=code d
 ...s tmpDeptLocation=tmpRow_"^0"
 ..e  d
 ...i $d(^DHCCADEPTLEVELSETS(tmpRow,"Depts",0)) d
 ....s tmpSubNum=^DHCCADEPTLEVELSETS(tmpRow,"Depts",0)
 ....s tmpSubRow=0
 ....f  s tmpSubRow=$o(^DHCCADEPTLEVELSETS(tmpRow,"Depts",tmpSubRow)) q:tmpSubRow=""  d
 .....s tmpSubDeptid=$p(^DHCCADEPTLEVELSETS(tmpRow,"Depts",tmpSubRow),"^",1)
 .....i tmpSubDeptid'="" d
 ......s tmpSubDeptCode=$p(^DHCCAUNITDEPTS(tmpSubDeptid),"^",1)
 ......i tmpSubDeptCode=code d
 .......s tmpDeptLocation=tmpRow_"^"_tmpSubRow
 q tmpDeptLocation
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-31
/// Description: 查询当前科室的分层套id
/// Table：DeptLevelSets
/// Input: rowid
/// Output: setid-分层套id,不存在为-1
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptSetid(76)
ClassMethod getDeptSetid(rowid) As %String
{
 n (rowid)
 s tmpid=rowid
 s tmpPreid=tmpid
 f  s tmpid=..getParentid(tmpid) q:(tmpid=0)||(tmpid=-1)  d
 .s tmpPreid=tmpid
 i tmpid=-1 d
 .s tmpPreid=-1
 q tmpPreid
}

/// Creator: 王赢赢
/// CreatDate: 2010-01-4
/// Description: 查询当前科室在成本分摊过程中的同一级类别的所有科室
/// Table：DeptLevelSets
/// Input: setid-分层套id;rowid
/// Output: 科室rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getCurrentClass(1,6)
ClassMethod getCurrentClass(setid, rowid) As %String
{
 n (setid,rowid)
 s tmpid=..getParentid(rowid)
 ;q:tmpid'=setid "-1"
 s tmpUnleafRowids=rowid_..getOffspringUnleaf(rowid)
 s tmpRowids=""
 s tmpCur=1
 f  s tmpUnleafRowid=$p(tmpUnleafRowids,"^",tmpCur) q:tmpUnleafRowid=""  d
 .s tmpCur=tmpCur+1
 .i tmpRowids="" d
 ..s tmpRowids=tmpUnleafRowid_"^0"
 .e  d
 ..s tmpRowids=tmpRowids_"||"_tmpUnleafRowid_"^0"
 .i $d(^DHCCADEPTLEVELSETS(tmpUnleafRowid,"Depts",0)) d
 ..s tmpSubNum=^DHCCADEPTLEVELSETS(tmpUnleafRowid,"Depts",0)
 ..s tmpSubCur=0
 ..f  q:tmpSubCur=tmpSubNum  d
 ...s tmpSubCur=tmpSubCur+1
 ...i $d(^DHCCADEPTLEVELSETS(tmpUnleafRowid,"Depts",tmpSubCur)) d
 ....i tmpRowids="" d
 .....s tmpRowids=tmpUnleafRowid_"^"_tmpSubCur
 ....e  d
 .....s tmpRowids=tmpRowids_"||"_tmpUnleafRowid_"^"_tmpSubCur
 q tmpRowids
}

/// Creator: 王赢赢
/// CreatDate: 2010-01-4
/// Description: 查询当前科室的所有子科室
/// Table：DeptLevelSets
/// Input: rowid-科室id
/// Output: 科室rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getOffspringUnleaf(6)
ClassMethod getOffspringUnleaf(rowid) As %String
{
 n (rowid)
 s tmpChildrenid=""
 s tmpChildid=""
 f  s tmpChildid=$o(^DHCCADEPTLEVELSETS(0,"Parent",rowid,tmpChildid)) q:tmpChildid=""  d
 .s tmpChildrenid=tmpChildrenid_"^"_tmpChildid
 .s tmpChildrenid=tmpChildrenid_..getOffspringUnleaf(tmpChildid)
 q tmpChildrenid
}

/// Creator: 王赢赢
/// CreatDate: 2010-01-4
/// Description: 查询当前科室的下一层子科室
/// Table：DeptLevelSets
/// Input: rowid-科室id
/// Output: 科室rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getChildren(6)
ClassMethod getChildren(rowid) As %String
{
 n (rowid)
 s tmpRowid=$p(rowid,"^",1)
 s tmpSubid=$p(rowid,"^",2)
 q:(tmpSubid'=0)&&(tmpSubid'="") "-1"
 s tmpSibRowids=""
 s tmpSib=""
 f  s tmpSib=$o(^DHCCADEPTLEVELSETS(0,"Parent",tmpRowid,tmpSib)) q:tmpSib=""  d
 .i tmpSibRowids="" d
 ..s tmpSibRowids=tmpSib_"^0"
 .e  d
 ..s tmpSibRowids=tmpSibRowids_"||"_tmpSib_"^0"
 i $d(^DHCCADEPTLEVELSETS(tmpRowid,"Depts",0)) d
 .s tmpSubNum=^DHCCADEPTLEVELSETS(tmpRowid,"Depts",0)
 .s tmpSubCur=0
 .f  q:tmpSubCur=tmpSubNum  d
 ..s tmpSubCur=tmpSubCur+1
 ..i $d(^DHCCADEPTLEVELSETS(tmpRowid,"Depts",tmpSubCur)) d
 ...i tmpSibRowids="" d
 ....s tmpSibRowids=tmpRowid_"^"_tmpSubCur
 ...e  d
 ....s tmpSibRowids=tmpSibRowids_"||"_tmpRowid_"^"_tmpSubCur
 q tmpSibRowids
}

/// Creator: 王赢赢
/// CreatDate: 2010-01-4
/// Description: 查询当前科室的兄弟科室
/// Table：DeptLevelSets
/// Input: rowid-科室id;direction-0:同一级,-1:下一级,1:上一级
/// Output: 科室rowid或""或-1(出错)
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getOneSiblingsUnleaf(6,0)
ClassMethod getOneSiblingsUnleaf(rowid, direction) As %String
{
 n (rowid,direction)
 q:direction=0 rowid
 s tmpSibRowid=-1
 i (direction=-1)||(direction=1) d
 .s tmpPar=..getParentid(rowid)
 .i tmpPar=-1 d
 ..s tmpSibRowid=-1
 .e  d
 ..s tmpSibRowid=$o(^DHCCADEPTLEVELSETS(0,"Parent",tmpPar,rowid),direction)
 q tmpSibRowid
}

/// Creator: 王赢赢
/// CreatDate: 2010-01-4
/// Description: 查询当前科室的所有兄弟科室
/// Table：DeptLevelSets
/// Input: rowid-科室id;
/// Output: 科室rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getAllSiblings(6)
ClassMethod getAllSiblings(rowid) As %String
{
 n (rowid)
 s tmpSibRowids=""
 s flag=-1
 i ($p(rowid,"^",2)="")||($p(rowid,"^",2)=0) d
 .s tmpPar=..getParentid($p(rowid,"^",1))
 .i tmpPar'=-1 d
 ..s tmpSibRowids=..getChildren(tmpPar)
 ..s flag=1
 e  d
 .s tmpPar=$p(rowid,"^",1)
 .s tmpSibRowids=..getChildren(tmpPar)
 .s tmpCur=1
 .s tmpRow=""
 .f  s tmpRow=$p(tmpSibRowids,"||",tmpCur) q:tmpRow=""  d
 ..s tmpCur=tmpCur+1
 ..i tmpRow=rowid d
 ...s flag=1
 q:flag=-1 "-1"
 q tmpSibRowids
}

/// Creator: 王赢赢
/// CreatDate: 2010-01-22
/// Description: 通过session中的userCode查询人员
/// Table：^DHCCAUSERS
/// Input: userCode
/// Output:
/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getUser("demo")
ClassMethod getUser(userCode) As %String
{
	n (userCode)
	
	s sqlStr="SELECT Users_rowid,Users_order,Users_password,Users_loginName,Users_unitPersonDr,Users_remark,Users_active FROM dhc_ca_cache_data.Users"
	
	s whereStr=" WHERE %ID>0 and Users_loginName='"_userCode_"'"
	s whereStr=whereStr_" AND Users_active='Y'"
		
	s sqlStr=sqlStr_whereStr
	;w sqlStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	d result.Next()
	s resultString=""
	
	s rowid=result.Data("Users_rowid")
	s password=result.Data("Users_password")
	s loginName=result.Data("Users_loginName")
	s unitPersonDr=result.Data("Users_unitPersonDr")
	s unitPsersonName=""
	s unitDr=""
	s unitName=""
	s unitTypeDr=""
	s unitTypeName=""
	i unitPersonDr'="" d
	.s unitPsersonName=$p($g(^DHCCAUNITPERSONS(unitPersonDr)),"^",2)
	.s unitDr=$p($g(^DHCCAUNITPERSONS(unitPersonDr)),"^",17)
	.i unitDr'="" d
	..s unitName=$p($g(^DHCCAUNITS(unitDr)),"^",2)
	..s unitTypeDr=$p($g(^DHCCAUNITS(unitDr)),"^",8)
	..i unitTypeDr'="" d
	...s unitTypeName=$p($g(^DHCCAUNITTYPES(unitTypeDr)),"^",2)
	
	s order=result.Data("Users_order")
	s remark=result.Data("Users_remark")
	s active=result.Data("Users_active")
	s resultString=rowid_"^"_order_"^"_loginName_"^"_password_"^"_unitPersonDr_"^"_unitPsersonName_"^"_remark_"^"_active_"^"_unitTypeDr_"^"_unitTypeName_"^"_unitDr_"^"_unitName

	d result.Close()
	q resultString
}

/// Others: w ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getLeaf(1)
ClassMethod getLeaf(costDr) As %String
{
	n (costDr)
	s tmpDeptSetDr=$p(^DHCCACOSTDISTSETS(costDr),"^",5)
	s tmpDepts=..getCurrentClass(tmpDeptSetDr,tmpDeptSetDr)
	s num=1
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^Name"
	f  s tmpDept=$p(tmpDepts,"||",num) q:tmpDept=""  d
	.s num=num+1
	.s tmpDeptId=$p(tmpDept,"^",1)
	.s tmpDeptSub=$p(tmpDept,"^",2)
	.i tmpDeptSub'=0 d
	..s tmpDeptDr=$p(^DHCCADEPTLEVELSETS(tmpDeptId,"Depts",tmpDeptSub),"^",1)
	..s tmpDeptName=$p(^DHCCAUNITDEPTS(tmpDeptDr),"^",2)
	..d json.InsertRowData(tmpDeptDr_"^"_tmpDeptName)
	s num=num-1
	s resultString = json.getJsonData(jsonTitle,num)
 	k json
	q resultString
}

Storage Default
{
<Data name="deptLevelSetTreeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.deptLevelSetTreeD</DataLocation>
<DefaultData>deptLevelSetTreeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.deptLevelSetTreeD</IdLocation>
<IndexLocation>^dhc.ca.c.deptLevelSetTreeI</IndexLocation>
<StreamLocation>^dhc.ca.c.deptLevelSetTreeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
