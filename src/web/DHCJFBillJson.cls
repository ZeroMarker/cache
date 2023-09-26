Class web.DHCJFBillJson Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// @author: 	wanghuicai 
/// @date:		2010-3-11
/// @Params: 	groupRowid安全组Rowid,nodeCode表中TN_Code,nodeDr节点的DHC_TreeNode表中的rowid
/// @retrun:    子树json
/// @Desc:		查询出groupRowid安全组下以nodeDr为父节点的
ClassMethod ToTreeJson(groupRowid As %String, nodeDr As %String) As %String
{
	;w ##class(web.DHCJFBillJson).ToTreeJson(1,4)
	q:groupRowid="" "[]"
	q:nodeDr="" "[]"
	s parrentNodeRowid=nodeDr
	s treeNodeRowid="",rtnResponseString="["
	f  s treeNodeRowid=$o(^DHCTREENODE("0",parrentNodeRowid,"ParrentNode",treeNodeRowid)) q:treeNodeRowid=""  d
	.s linkRowid=$o(^DHCTREEGROUP(0,groupRowid,"GroupTree",treeNodeRowid,"TreeGroup",0))
	.;w linkRowid,!
	.q:(linkRowid="")||($d(^DHCTREEGROUP(linkRowid))=0)	
	.s useRight=$p(^DHCTREEGROUP(linkRowid),"^",3)
	.;w useRight,!
	.q:useRight'="Y"	//	没有权限
	.s treeNodeObj = ##class(User.DHCTreeNode).%OpenId(treeNodeRowid)
	.i $isObject(treeNodeObj) d
	..if (rtnResponseString="[") d
	...s rtnResponseString=rtnResponseString_""_treeNodeObj.ToJson()
	..else  d
	...s rtnResponseString=rtnResponseString_","_treeNodeObj.ToJson()
	q rtnResponseString_"]"
}

ClassMethod ToGrantTreeJson(groupRowid As %String, nodeDr As %String) As %String
{
	q:groupRowid="" "[]"
	q:nodeDr="" "[]"
	s parrentNodeRowid=nodeDr
	s treeNodeRowid="",rtnResponseString="["
	f  s treeNodeRowid=$o(^DHCTREENODE("0",parrentNodeRowid,"ParrentNode",treeNodeRowid)) q:treeNodeRowid=""  d
	.s linkRowid=$o(^DHCTREEGROUP(0,groupRowid,"GroupTree",treeNodeRowid,"TreeGroup",0))
	.q:(linkRowid="")||($d(^DHCTREEGROUP(linkRowid))=0)
	.s useRight=$p(^DHCTREEGROUP(linkRowid),"^",3)
	.q:useRight'="Y"
	.s treeNodeObj = ##class(User.DHCTreeNode).%OpenId(treeNodeRowid)
	.i $isObject(treeNodeObj) d
	..if (rtnResponseString="[") d
	...s rtnResponseString=rtnResponseString_""_treeNodeObj.ToCheckJson()
	..else  d
	...s rtnResponseString=rtnResponseString_","_treeNodeObj.ToCheckJson()
	q rtnResponseString_"]"
}

/// @desc:通过表User.DHCTreeNode的rowid拿到他对应的大类或子类的数据
ClassMethod ToGridJson(nodeDr As %String) As %String
{
	q:nodeDr="" "{columnCount:0,rows:[]}"
	s tableName=""
	s rtnJson="{columnCount:0,rows:["
	s treeNodeObj = ##class(User.DHCTreeNode).%OpenId(nodeDr)
	i $isObject(treeNodeObj) d
	.s tableName=treeNodeObj.TNUserClass
	s propertyDr=""
	i (tableName'="") {
	    s exec="SELECT * FROM "_tableName 
	    Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
		Do result.Prepare(exec)
		Do result.Execute()
		s columnCount=result.GetColumnCount()
		s rtnJson = "{columnCount:"_columnCount_",rows:["
		s count=0
		While ((result.Next())) {
			//大类
			if (columnCount=3) {
				s Rowid=result.GetData(1),Code=result.GetData(2),Desc=result.GetData(3)
				if ($e(rtnJson,$l(rtnJson))="["){
					s rtnJson=rtnJson_"{Rowid:'"_Rowid_"',Desc:'"_Desc_"',Code:'"_Code_"'}"
				}else{
					s rtnJson=rtnJson_",{Rowid:'"_Rowid_"',Desc:'"_Desc_"',Code:'"_Code_"'}"
				}
			}
			//子类
			if (columnCount=4) {
				s Rowid=result.GetData(1),Code=result.GetData(2),Desc=result.GetData(3),CateDr=result.GetData(4)
				if (propertyDr="") {
					s index=##class(web.DHCJFBillCodeManageComm).GetDRToTable(tableName,.PLISTArr)
					s:index>0 propertyDr=$g(PLISTArr(index-1))
				}
				s:propertyDr'="" CateDesc=##CLASS(web.DHCJFBillCodeManageComm).GetDRValueDesc(tableName,propertyDr,CateDr)
				if ($e(rtnJson,$l(rtnJson))="["){
					s rtnJson=rtnJson_"{Rowid:'"_Rowid_"',Desc:'"_Desc_"',Code:'"_Code_"',CateDr:'"_$g(CateDesc)_"'}"
				}else{
					s rtnJson=rtnJson_",{Rowid:'"_Rowid_"',Desc:'"_Desc_"',Code:'"_Code_"',CateDr:'"_$g(CateDesc)_"'}"
				}
			}
			s count=count+1
		}
    }
	q rtnJson_"]}"
}

ClassMethod ToCateJson(nodeDr As %String) As %String
{
	q:nodeDr="" "{rows:[]}"
	s tableName=""
	s rtnJson="{rows:["
	s treeNodeObj = ##class(User.DHCTreeNode).%OpenId(nodeDr)
	i $isObject(treeNodeObj) d
	.s cateTableName=treeNodeObj.TNUserClass
	q:cateTableName="" "{rows:[]}"
	s index=##class(web.DHCJFBillCodeManageComm).GetDRToTable(cateTableName,.PLISTArr)
	s:index>0 propDrName=$g(PLISTArr(index-1))
	q:$g(propDrName)="" "{rows:[]}"
	s drCateTableName=##class(web.DHCJFBillCodeManageComm).GetTableNameByDRName(cateTableName,propDrName)
	i (cateTableName'="") {
	    s exec="SELECT * FROM "_drCateTableName 
	    Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
		Do result.Prepare(exec)
		Do result.Execute()
		s columnCount=result.GetColumnCount()
		s count=0
		While ((result.Next())) {
				s Rowid=result.GetData(1),Code=result.GetData(2),Desc=result.GetData(3)
				if ($e(rtnJson,$l(rtnJson))="["){
					s rtnJson=rtnJson_"{cateRowid:'"_Rowid_"',cateDesc:'"_Desc_"'}"
				}else{
					s rtnJson=rtnJson_",{cateRowid:'"_Rowid_"',cateDesc:'"_Desc_"'}"
				}
				s count=count+1
		}
    }
	q rtnJson_"]}"
}

ClassMethod ToGroupComboJson(groupRowid, groupCode)
{
	q:groupRowid="" "{rows:[]}"
	s rtnJson="{rows:["
	s rowid=0 f  s rowid=$o(^SSU("SSGRP",rowid)) q:rowid=""  d
	.q:groupRowid=rowid 
	.s Desc=$p(^SSU("SSGRP",rowid),"^",1)
	.q:$ZCVT(Desc,"U")'[$ZCVT(groupCode,"U")  ;转换为大写比较
	.if ($e(rtnJson,$l(rtnJson))="[") d
	..s rtnJson=rtnJson_"{groupRowid:'"_rowid_"',groupDesc:'"_Desc_"'}"
	.else  d
	..s rtnJson=rtnJson_",{groupRowid:'"_rowid_"',groupDesc:'"_Desc_"'}"
	q rtnJson_"]}"
}

ClassMethod ToWardTreeJson()
{
	s wardJson="["
	s rowid=0 f  s rowid=$o(^PAWARD(rowid)) q:rowid=""  d
	.s info=$g(^PAWARD(rowid))
	.q:info=""
	.s code=$p(info,"^",1)
	.i wardJson="[" d
	..s wardJson=wardJson_"{id=Ward-"_rowid_","_"text="_code_",leaf=false}"
	.e  d
	..s wardJson=wardJson_",{id=Ward-"_rowid_","_"text="_code_",leaf=false}"
	q wardJson_"]"
}

ClassMethod ToPaadmByWardTreeJson(wardRowid)
{
	s paadmTreeJson="["
	s roomRowid=0 f  s roomRowid=$o(^PAADMi("CurrWard",wardRowid,roomRowid))  q:roomRowid=""  d
	.s rowid=0 f  s rowid=$o(^PAADMi("CurrWard",wardRowid,roomRowid,rowid)) q:rowid=""  d
	..s patinfo=$g(^PAADM(rowid))
	..q:patinfo=""
	.i wardJson="[" d
	..s paadmTreeJson=paadmTreeJson_"{id=Paadm-"_rowid_","_"text="_code_",leaf=true}"
	.e  d
	..s paadmTreeJson=paadmTreeJson_",{id=Paadm-"_rowid_","_"text="_code_",leaf=true}"
	q paadmTreeJson_"]"
}

}
