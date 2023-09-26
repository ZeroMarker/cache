/// @author:wanghuicai
/// @date: 2010-4-14
Class web.DHCJFBillOperate Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// @para:    str = rowmsg1 $c(2) rowmsg2 $c(2)....rowmsgN,	i=第几个行(对象) 
/// @retrun:  rowmsgi
ClassMethod getObjectStr(str As %String, i As %Integer)
{
		q $p(str,$c(2),i)
}

/// @param:   groupRowid安全组rowid,treeCode:树表中的Code,nodeRowidMsg节点rowid串1^2^3^4
/// @return:  sqlrtn=SQLCODE
/// @desc:    为某组写入查看树权限
ClassMethod InsertGroupLink(groupRowid As %String, treeCode As %String, nodeRowidMsg As %String) As %String
{
	s sqlrtn=0
	q:groupRowid="" ""
	d ##class(web.DHCJFBillOperate).tb()
	//清除安全组权限
	&sql(delete from SQLUSER.DHC_TreeGroupLink where TGL_Group_DR=:groupRowid and tgl_TreeNode_dr->TN_Code=:treeCode )
	S sqlrtn=SQLCODE
	i sqlrtn d
	.Trollback 
	s:sqlrtn=100 sqlrtn=0
	q:sqlrtn ""
	//循环写入权限
	s len=$l(nodeRowidMsg,"^")
	i len>1 d
	.f i=1:1:len Q:sqlrtn  d
	..s nodeRowid=+$p(nodeRowidMsg,"^",i)
	..q:nodeRowid=0
	..&sql(insert into SQLUSER.DHC_TreeGroupLink(TGL_Group_Dr,TGL_TreeNode_Dr,TGL_UseRight) values (:groupRowid,:nodeRowid,'Y'))
	..s sqlrtn=SQLCODE
	i sqlrtn d 
	.trollback
	e  d
	.d ##class(web.DHCJFBillOperate).tc()
	q sqlrtn
}

/// @param:   nodeDr valueStr="desc^code^cateDr^rowid"
/// w ##class(web.DHCJFBillOperate).SaveDHCTarCate(9,"1^1^^1")
ClassMethod SaveDHCTarCate(nodeDr As %String, saveValueStr As %String) As %String
{
	q:nodeDr="" "paramNull" 
	q:saveValueStr="" "paramNull"
	d ##class(web.DHCJFBillOperate).tb()
	s treeNodeObj = ##class(User.DHCTreeNode).%OpenId(nodeDr)
	//拿到表名
	s cateClassName=""
	i $isObject(treeNodeObj) d
	.s cateClassName=$tr(treeNodeObj.TNUserClass,"_","")
	q:cateClassName="" "TableNull"
	s rtn=""
	s (codeProperty,descProperty,cateDrProperty,exec)=""
	//拿到表的属性
	k PLISTArr
	s propCount=##class(web.DHCJFBillCodeManageComm).GetPropertyByDescEnd(cateClassName,"Code",0,.PLISTArr)
	i propCount>0 d 
	.s codeProperty = PLISTArr(propCount-1)
	s propCount=0
	s propCount=##class(web.DHCJFBillCodeManageComm).GetPropertyByDescEnd(cateClassName,"Desc",0,.PLISTArr)
	i propCount>0 d 
	.s descProperty = PLISTArr(propCount-1)
	s propCount=0
	s propCount=##class(web.DHCJFBillCodeManageComm).GetDRToTable(cateClassName,.PLISTArr)
	i propCount>0 d 
	.s cateDrProperty = PLISTArr(propCount-1)
	//要保存的串数据
	s objNum = $l(saveValueStr,$c(2))
	s sc=1
	f i=1:1:objNum {
		s valueStr= ..getObjectStr(i) //
		s len=$l(valueStr,"^")
		if (len=4){
			s rowid=+$p(valueStr,"^",4)
			//拿到要写入的对象
			i rowid=0 d
			.s exec="obj=##class(User."_cateClassName_").%New()"
			e  d
			.s exec="obj=##class(User."_cateClassName_").%OpenId("_rowid_")"
			s @exec
			i $isObject(obj){
				//写对象属性
				s:descProperty'="" exec="obj."_descProperty_"="""_$p(valueStr,"^",1)_"""",@exec
				s:codeProperty'="" exec="obj."_codeProperty_"="""_$p(valueStr,"^",2)_"""",@exec
				s:cateDrProperty'="" exec="obj."_cateDrProperty_"="""_$p(valueStr,"^",3)_"""",@exec
				Set exec="sc=obj.%Save()", @exec
				q:$$$ISERR(sc)	//break
			}else{
				s rtn="Object Null"
			}
		}else{
			s rtn="Object Error"
		}
	} 
	If $$$ISERR(sc){
		trollback
		Do $System.Status.DisplayError(sc)
		Q "insertErr"
	}else {
		d ##class(web.DHCJFBillOperate).tc()
	}
	q:rtn'="" rtn
	q sc
}

/// @param:  nodeDr  valueStr="rowid^rowid"
ClassMethod DeleteDHCTarCate(nodeDr As %String, valueStr As %String) As %String
{
	q:nodeDr="" "paramNull" 
	q:valueStr="" "paramNull"
	d ##class(web.DHCJFBillOperate).tb()
	//拿到表名
	s cateClassName=""
	s treeNodeObj = ##class(User.DHCTreeNode).%OpenId(nodeDr)
	i $isObject(treeNodeObj) d
	.s cateClassName=$tr(treeNodeObj.TNUserClass,"_","")
	q:cateClassName="" "tableNameNull"
	s objNum = $l(valueStr,$c(2))
	f i=1:1:objNum {
		s rowid=+$p(valueStr,$c(2))
		i rowid'="" d
		.s exec="sc=##class(User."_cateClassName_").%DeleteId("_rowid_")"
		s @exec
		q:$$$ISERR(sc)
	}
	If $$$ISERR(sc){
		trollback
		Do $System.Status.DisplayError(sc)
		Q "deleteErr"
	}else  {
		d ##class(web.DHCJFBillOperate).tc()
	}
	q sc
}

ClassMethod test(nodeDr As %String, saveValueStr As %String) As %String
{
	q nodeDr_" "_saveValueStr
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	N SQLCODE
	i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
