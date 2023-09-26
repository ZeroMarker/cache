Class DHCBILLConfig.DHCBILLSysJson Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// @author: 	TangTao 
/// @date:		2013-01-12
/// @Params: 	groupRowid安全组Rowid,nodeCode表中TN_Code,nodeDr节点的DHC_TreeNode表中的rowid
/// @retrun:    子树json
/// @Desc:		查询出groupRowid安全组下以nodeDr为父节点的
ClassMethod ToTreeJson(groupRowid As %String, nodeDr As %String) As %String
{
	;w ##class(DHCBILLConfig.DHCBILLSysJson).ToTreeJson(1,1)
	q:groupRowid="" "[]"
	q:nodeDr="" "[]"
	s parrentNodeRowid=nodeDr
	s treeNodeRowid="",rtnResponseString="["
	f  s treeNodeRowid=$o(^DHCJFSYSTREENODE("0",parrentNodeRowid,"ParrentNode",treeNodeRowid)) q:treeNodeRowid=""  d
	.s linkRowid=$o(^DHCJFSYSTREEGROUP(0,groupRowid,"GroupTree",treeNodeRowid,"TreeGroup",0))
	.q:(linkRowid="")||($d(^DHCJFSYSTREEGROUP(linkRowid))=0)	
	.s useRight=$p(^DHCJFSYSTREEGROUP(linkRowid),"^",3)
	.q:useRight'="Y"	//	没有权限
	.s treeNodeObj = ##class(User.DHCJFSysTreeNode).%OpenId(treeNodeRowid)
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
	f  s treeNodeRowid=$o(^DHCJFSYSTREENODE("0",parrentNodeRowid,"ParrentNode",treeNodeRowid)) q:treeNodeRowid=""  d
	.s linkRowid=$o(^DHCJFSYSTREEGROUP(0,groupRowid,"GroupTree",treeNodeRowid,"TreeGroup",0))
	.q:(linkRowid="")||($d(^DHCJFSYSTREEGROUP(linkRowid))=0)
	.s useRight=$p(^DHCJFSYSTREEGROUP(linkRowid),"^",3)
	.q:useRight'="Y"
	.s treeNodeObj = ##class(User.DHCJFSysTreeNode).%OpenId(treeNodeRowid)
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
	s treeNodeObj = ##class(User.DHCJFSysTreeNode).%OpenId(nodeDr)
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
	s treeNodeObj = ##class(User.DHCJFSysTreeNode).%OpenId(nodeDr)
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

}
