/// Creator: wang ying
/// CreatDate: 2009-01-11
/// Description: 对数据分层套的基本操作
Class dhc.ca.cache.report.comm.itemLevelSetTree Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-01-11
/// Description: rowid是否存在
/// Table：DataLevelSets
/// Input: rowid-数据项id
/// Output: -1-不存在;1-存在;
/// Others: w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).checkExistence(52)
ClassMethod checkExistence(rowid) As %String
{
 s flag=-1
 s tmpid=$p(rowid,"^",1)
 i ($p(rowid,"^",2)="") d
 .i ($d(^DHCCADATALEVELSETS(tmpid))=1)||($d(^DHCCADATALEVELSETS(tmpid))=11) d 
 ..s flag=1
 e  d
 .s tmpSubid=$p(rowid,"^",2)
 .i $d(^DHCCADATALEVELSETS(tmpid,"Items",tmpSubid)) d
 ..s flag=1
 q flag
}

/// Creator: wang ying
/// CreatDate: 2009-01-11
/// Description: 查询当前数据项的父id
/// Table：DataLevelSets
/// Input: rowid
/// Output: 父id,不存在为-1
/// Others: w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getParentid(78)
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
 .s tmpPar=$p($g(^DHCCADATALEVELSETS(tmpid)),"^",7)
 s tmpCheck=..checkExistence(tmpPar)
 q:tmpCheck=-1 "-1"
 q tmpPar
}

/// Creator: wang ying
/// CreatDate: 2010-01-11
/// Description: 查询当前数据项的所有子数据项
/// Table：DataLevelSets
/// Input: rowid-数据项id
/// Output: 数据rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getOffspringUnleaf(1,"")
ClassMethod getOffspringUnleaf(rowid) As %String
{
 n (rowid)
 s tmpChildrenid=""
 s tmpChildid=""
 s tmpOrder=""
 f  s tmpOrder=$o(^DHCCADATALEVELSETS(0,"Parent",rowid,tmpOrder)) q:tmpOrder=""  d
 .f  s tmpChildid=$o(^DHCCADATALEVELSETS(0,"Parent",rowid,tmpOrder,tmpChildid)) q:tmpChildid=""  d 
 ..s tmpChildrenid=tmpChildrenid_"^"_tmpChildid
 ..s tmpChildrenid=tmpChildrenid_..getOffspringUnleaf(tmpChildid)
 q tmpChildrenid
}

/// Creator: wang ying
/// CreatDate: 2010-01-11
/// Description: 查询当前数据项在数据分层套程中的同一级类别的所有数据项
/// Table：DataLevelSets
/// Input: setid-顶层分层套id;rowid-末端数据项id在分层套中的id
/// Output: 数据项rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getCurrentClass(1,6)
ClassMethod getCurrentClass(setid, rowid) As %String
{
 n (setid,rowid)
 s tmpid=..getParentid(rowid)
 q:tmpid'=setid "-1"
 s tmpUnleafRowids=rowid_..getOffspringUnleaf(rowid)
 s tmpRowids=""
 s tmpCur=1
 f  s tmpUnleafRowid=$p(tmpUnleafRowids,"^",tmpCur) q:tmpUnleafRowid=""  d
 .s tmpCur=tmpCur+1
 .i tmpRowids="" d
 ..s tmpRowids=tmpUnleafRowid_"^0"
 .e  d
 ..s tmpRowids=tmpRowids_"||"_tmpUnleafRowid_"^0"
 .i $d(^DHCCADATALEVELSETS(tmpUnleafRowid,"Items",0)) d
 ..s tmpSubNum=^DHCCADATALEVELSETS(tmpUnleafRowid,"Items",0)
 ..s tmpSubCur=0
 ..f  q:tmpSubCur=tmpSubNum  d
 ...s tmpSubCur=tmpSubCur+1
 ...i $d(^DHCCADATALEVELSETS(tmpUnleafRowid,"Items",tmpSubCur)) d
 ....i tmpRowids="" d
 .....s tmpRowids=tmpUnleafRowid_"^"_tmpSubCur
 ....e  d
 .....s tmpRowids=tmpRowids_"||"_tmpUnleafRowid_"^"_tmpSubCur
 q tmpRowids
}

/// Creator: wang ying
/// CreatDate: 2009-01-25
/// Description: 查询当前数据项在数据分层套的级别（在第几层）
/// Table：DataLevelSets
/// Input: setid-数据分层套id，itemid-数据项id
/// Output: tmpNum_"||"_tmpName-层数||层名称
/// Others: w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getItemLevelNumAndClassInItem(3,3)
ClassMethod getItemLevelNumAndClassInItem(setid, itemid) As %String
{
 //^DHCCADATALEVELSETS({DataLevelSets.DataLevelSets_rowid},"Items",{LevelItems_childSub})
 n (setid,itemid)
 s tmpRowid=setid
 s tmpPreRowid=""
 s tmpSubid=""
 f  s tmpRowid=$o(^DHCCADATALEVELSETS(tmpRowid)) q:(tmpRowid="")||(tmpSubid'="")  d
 .s tmpSubid=$o(^DHCCADATALEVELSETS(0,"Item",tmpRowid,itemid,tmpSubid))
 .s tmpPreRowid=tmpRowid
 q:tmpRowid="" "-1"
 s tmpNum=0
 s tmpid=tmpPreRowid
 f  s tmpid=$p(^DHCCADATALEVELSETS(tmpid),"^",7) q:(tmpid=0)||(tmpid=setid)  d
 .s tmpNum=tmpNum+1
 .s tmpPreRowid=tmpid
 q:tmpid=0 "-1"
 s tmpName=$p(^DHCCADATALEVELSETS(tmpPreRowid),"^",2)
 s tmpNum=tmpNum+1
 q tmpNum_"||"_tmpName
}

/// 修改末端科室显示的层数
/// Creator: wang ying
/// CreatDate: 2009-01-11
/// Description: 查询当前数据项在数据分层套的级别（在第几层）
/// Table：DataLevelSets
/// Input: rowid-数据分层套id,末层输入格式为"3^1"
/// Output: tmpLevelNum-层数
/// Others: w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getItemLevelNumberInId(3)
ClassMethod getItemLevelNumberInId(rowid) As %String
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

/// Creator: wang ying
/// CreatDate: 2010-01-11
/// Description: 查询当前数据项的类别（如收入大类、会计收入分类等）
/// Table：DataLevelSets
/// Input: rowid-分层套id
/// Output: tmpRowid-类别所在数据分成套的id
/// Others: w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getItemClassInId(6)
ClassMethod getItemClassInId(rowid) As %String
{
 n (rowid)
 s tmpItemLocation=rowid
 q:tmpItemLocation="0^0" "-1"
 s tmpRowid=$p(tmpItemLocation,"^",1)
 i ($p(rowid,"^",2)="") d
 .s tmpSubid=0
 e  d
 .s tmpSubid=$p(rowid,"^",2)
 q:('$d(^DHCCADATALEVELSETS(tmpRowid,"Items",tmpSubid))) "-1"
 f  q:..getItemLevelNumberInId(tmpRowid)=1  d
 .s tmpRowid=..getParentid(tmpRowid)
 q tmpRowid
}

/// Creator: wang ying
/// CreatDate: 2010-01-12
/// Description: 查询当前数据项在分层套的上一级（下一级，同一级）类别所有数据项
/// Table：DataLevelSets
/// Input: setid-分层套id;rowid-id;direction-0:同一级,-1:上一级,1:下一级
/// Output: 数据项rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getDeptUpDownClassInId(1,6,-1)
ClassMethod getItemUpDownClassInId(setid, rowid, direction) As %String
{
 n (setid,rowid,direction)
 s tmpRowid=rowid
 s tmpRowid=..getOneSiblingsUnleaf(tmpRowid,direction)
 s tmpRowids=""
 i tmpRowid'="" d
 .s tmpRowids=..getCurrentClass(setid,tmpRowid)
 q tmpRowids
}

/// Creator: wang ying
/// CreatDate: 2010-01-12
/// Description: 查询当前数据项的兄弟数据项
/// Table：DataLevelSets
/// Input: rowid-分层套id;direction-0:同一级,-1:下一级,1:上一级
/// Output: 数据项rowid或""或-1(出错)
/// Others: w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getOneSiblingsUnleaf(6,0)
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
 ..s tmpSibRowid=$o(^DHCCADATALEVELSETS(0,"Parent",tmpPar,rowid),direction)
 q tmpSibRowid
}

/// Creator: wang ying
/// CreatDate: 2010-01-13
/// Description: 查询当前数据项的下一层子数据项
/// Table：DataLevelSets
/// Input: rowid-分层套id
/// Output: 数据项rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getChildren(6)
ClassMethod getChildren(rowid) As %String
{
 n (rowid)
 s tmpRowid=$p(rowid,"^",1)
 s tmpSubid=$p(rowid,"^",2)
 q:(tmpSubid'=0)&&(tmpSubid'="") "-1"
 s tmpSibRowids=""
 s tmpOrder=""
 f  s tmpOrder=$o(^DHCCADATALEVELSETS(0,"Parent",tmpRowid,tmpOrder)) q:tmpOrder=""  d
 .s tmpSib=""
 .f  s tmpSib=$o(^DHCCADATALEVELSETS(0,"Parent",tmpRowid,tmpOrder,tmpSib)) q:tmpSib=""  d
 ..i tmpSibRowids="" d
 ...s tmpSibRowids=tmpSib_"^0"
 ..e  d
 ...s tmpSibRowids=tmpSibRowids_"||"_tmpSib_"^0"
 i $d(^DHCCADATALEVELSETS(tmpRowid,"Items",0)) d
 .s tmpSubNum=^DHCCADATALEVELSETS(tmpRowid,"Items",0)
 .s tmpSubCur=0
 .f  q:tmpSubCur=tmpSubNum  d
 ..s tmpSubCur=tmpSubCur+1
 ..i $d(^DHCCADATALEVELSETS(tmpRowid,"Items",tmpSubCur)) d
 ...i tmpSibRowids="" d
 ....s tmpSibRowids=tmpRowid_"^"_tmpSubCur
 ...e  d
 ....s tmpSibRowids=tmpSibRowids_"||"_tmpRowid_"^"_tmpSubCur
 q tmpSibRowids
}

/// Creator: wang ying
/// CreatDate: 2009-01-26
/// Description: 查询当前数据项在成本分摊过程中上面（下面）的所有类别中的所有科室 
/// Table：DataLevelSets
/// Input: setid-分层套id;rowid-id;direction- -1:上一级,1:下一级
/// Output:  科室rowid,例"rowid1^rowid2^..."
/// Others: direction- -1,查询rowid的左边的兄弟节点以及兄弟节点的子节点；direction- 1,查询rowid的右边的兄弟节点以及兄弟节点的子节点
/// w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getItemAllUpDownClassInId(1,10105,-1)
ClassMethod getItemAllUpDownClassInId(setid, rowid, direction) As %String
{
 n (setid,rowid,direction)
 s tmpSib=rowid
 s tmpRowids=""
 f  s tmpSib=..getOneSiblingsUnleaf(tmpSib,direction)  q:(tmpSib="")||(tmpSib=-1)  d
 .i tmpRowids="" d
 ..s tmpRowids=..getCurrentClass(setid,tmpSib)
 .i tmpSib="" d
 ..s tmpRowids=""
 .i tmpRowids="" d
 ..s tmpRowids=..getCurrentClass(setid,tmpSib)
 .e  d
 ..s tmpRowids=tmpRowids_"||"_..getCurrentClass(setid,tmpSib)
 q tmpRowids
}

/// Creator: wang ying
/// CreatDate: 2009-01-27
/// Description: 查询当前类别中当前数据项的上级（下级、同级）数据项 
/// Table：DataLevelSets
/// Input: rowid-id形式为4或末层为4^1;direction-0:同一级,-1:上一级,1:下一级
/// Output: 分层套rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getItemUpDownInId("3^3",1)
ClassMethod getItemUpDownInId(rowid, direction) As %String
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
 ..i ..getItemLevelNumberInId($p(tmpRowid,"^",1))>2 d
 ...s tmpRowid=..getParentid($p(tmpRowid,"^",1))
 ...s tmpRowids=..getAllSiblings(tmpRowid)
 .e  d
 ..i ..getItemLevelNumberInId($p(tmpRowid,"^",1))>1 d
 ...s tmpRowid=$p(tmpRowid,"^",1)_"^0"
 ...s tmpRowids=..getAllSiblings(tmpRowid)
 q tmpRowids
}

/// Creator: wang ying
/// CreatDate: 2010-01-27
/// Description: 查询当前数据的所有兄弟数据项
/// Table：DeptLevelSets
/// Input: rowid-数据分层套id;
/// Output: 数据项rowid,例"rowid1^rowid2^..."
/// Others: w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getAllSiblings(6)
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

/// Creator：秦虎
/// CreatDate：2010-1-26
/// Description: 查询所有父级数据项
/// Table：DataLevelSets
/// Input：RowId in ^DHCCADATALEVELSETS table
/// Output：
/// Return：返回数据项列表 RowId1^RowId2^...
/// Others： w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).AllParentItemIdByDatalevelId(3)
ClassMethod AllParentItemIdByDatalevelId(datalevelSetId) As %String
{
	n (datalevelSetId)
	s parentId = datalevelSetId
	s allParentId = datalevelSetId
	f  s parentId = $p($g(^DHCCADATALEVELSETS(parentId)),"^",7) q:(parentId=0)||(parentId="")  d
	.Set allParentId=allParentId_"^"_parentId
	
	Quit allParentId
}

/// Creator: 秦虎
/// CreatDate: 2010-1-26
/// Description: 查询数据项码表的数据项在指定数据分层套中的父层数据
/// Table：DataLevelSets
/// Input: dataSetDr---数据分层套RowId, RowId in AllDataItems table
/// Output: 数据项rowid
/// Others: w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getIdInDatalevelSet(2,133)
ClassMethod getIdInDatalevelSet(dataSetDr, allDataItemsId) As %String
{
 
 n (dataSetDr,allDataItemsId)
 s rowId="-1"
 s flag = 0
 s res = "-1"
 
 s itemTypeId=0
 f  s itemTypeId=$o(^DHCCADATALEVELSETS(0,"TypeItem",dataSetDr,itemTypeId)) q:(itemTypeId="")||(flag=1)  d
 .i $d(^DHCCADATALEVELSETS(0,"TypeItem",dataSetDr,itemTypeId,allDataItemsId)) d
 ..s rowId=dataSetDr
 ..s flag=1

 s orderNum=0
 f  s orderNum=$o(^DHCCADATALEVELSETS(0,"Parent",dataSetDr,orderNum)) q:(orderNum="")||(flag=1)||(res'="-1")  d
 .s chidrenId=0
 .f  s chidrenId=$o(^DHCCADATALEVELSETS(0,"Parent",dataSetDr,orderNum,chidrenId)) q:(chidrenId="")||(flag=1)||(res'="-1")  d
 ..s itemTypeId=0
 ..f  s itemTypeId=$o(^DHCCADATALEVELSETS(0,"TypeItem",chidrenId,itemTypeId)) q:(itemTypeId="")||(flag=1)||(res'="-1")  d
 ...i $d(^DHCCADATALEVELSETS(0,"TypeItem",chidrenId,itemTypeId,allDataItemsId)) d
 ....s rowId=chidrenId
 ....s flag=1
 ..s res=..getIdInDatalevelSet(chidrenId,allDataItemsId)
 i flag=0 s rowId=res
 q rowId
}

/// Creator：秦虎
/// CreatDate：2010-1-26
/// Description: 根据分层id和数据项码表的数据项id查询所有父级数据项
/// Table：DataLevelSets
/// Input：dataSetDr---数据分层套RowId, RowId in AllDataItems table
/// Output：
/// Return：返回数据项列表 RowId1^RowId2^...
/// Others： w ##class(dhc.ca.cache.report.comm.itemLevelSetTree).AllParentItemIdByItemsId(2,133)
ClassMethod AllParentItemIdByItemsId(dataSetDr, allDataItemsId) As %String
{
	
	n (dataSetDr, allDataItemsId)
	s datalevelSetId=..getIdInDatalevelSet(dataSetDr,allDataItemsId)
	
	Quit:datalevelSetId="-1" ""

	Quit ..AllParentItemIdByDatalevelId(datalevelSetId)
}

/// Creator: 秦虎
/// CreatDate: 2010-1-26
/// Description: 生成排序好的数据分层套树形结构
/// Table：DataLevelSets
/// Input: dataSetDr---数据分层套RowId
/// Output: 树形结构临时global,值为排序号_"||"_父级数据项id
/// Others: 
ClassMethod getDatalevelSetSortedTree(dataSetDr As %Integer, sortNum As %Integer) As %String
{
 n (dataSetDr,sortNum)
 s order=""
 f  s order=$o(^DHCCADATALEVELSETS(0,"Parent",dataSetDr,order)) q:(order="")  d
 .s chidrenId=0
 .f  s chidrenId=$o(^DHCCADATALEVELSETS(0,"Parent",dataSetDr,order,chidrenId)) q:(chidrenId="")  d
 ..s sortNum=sortNum+1
 ..s allParentItemId=..AllParentItemIdByDatalevelId(chidrenId)
 ..s ^tmpdhccadataleveltree($j,"trunk",chidrenId)=sortNum_"||"_allParentItemId
 ..s sortNum=..getDatalevelSetSortedTree(chidrenId,sortNum)
 ..s itemTypeId = 0
 ..f  s itemTypeId=$o(^DHCCADATALEVELSETS(0,"TypeItem",chidrenId,itemTypeId)) q:(itemTypeId="")  d
 ...s leafId = 0
 ...f  s leafId=$o(^DHCCADATALEVELSETS(0,"TypeItem",chidrenId,itemTypeId,leafId)) q:(leafId="")  d
 ....s sortNum=sortNum+1
 ....s allParentLocId=..AllParentItemIdByItemsId(dataSetDr, leafId)
 ....s ^tmpdhccadataleveltree($j,"leaf",leafId)=sortNum_"||"_allParentLocId
 q sortNum
}

/// Creator: wang ying
/// CreatDate: 2009-1-15
/// Description:根据输入的分层套id和科室id，返回科室id对应的类别在分层套中的id
/// Table：DataLevelSets,CostDistSets,CostResultData
/// Input: costDistSetId-成本分摊套id，itemClass-数据分层套id，deptClass-科室分层套id,month-区间，interval-时间段
/// Output:
/// Others: w ##class(dhc.ca.cache.report.uBalanceofpayment).FindItemDr(2,133)
ClassMethod FindItemDr(Setid, itemDr)
{
	n (Setid,itemDr)
	s itemSetDrs=##class(dhc.ca.cache.report.comm.itemLevelSetTree).getOffspringUnleaf(Setid)
	;w "itemSetDrs="_itemSetDrs,!
	s itemSetDr=""
	s len=$l(itemSetDrs,"^")
	;w len,!
	s i=2
	f  q:i>len  d
	.s tmpitemDr=$p(itemSetDrs,"^",i)
	.s i=i+1
	.i $d(^DHCCADATALEVELSETS(tmpitemDr,"Items"))  d
	..s tmpItemSub=0
	..f  s tmpItemSub=$o(^DHCCADATALEVELSETS(tmpitemDr,"Items",tmpItemSub)) q:tmpItemSub=""  d
	...s tmpItem=$p(^DHCCADATALEVELSETS(tmpitemDr,"Items",tmpItemSub),"^",3)
	...i tmpItem=itemDr d
	....s itemSetDr=##class(dhc.ca.cache.report.comm.itemLevelSetTree).getItemClassInId(tmpitemDr)
    q itemSetDr
}

Storage Default
{
<Data name="itemLevelSetTreeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.itemLevelSetTreeD</DataLocation>
<DefaultData>itemLevelSetTreeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.itemLevelSetTreeD</IdLocation>
<IndexLocation>^dhc.ca.c.itemLevelSetTreeI</IndexLocation>
<StreamLocation>^dhc.ca.c.itemLevelSetTreeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
