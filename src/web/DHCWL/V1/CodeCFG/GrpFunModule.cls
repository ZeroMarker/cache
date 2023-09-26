/// Creator    :     wk
/// CreatDate  :     2018-08-09
/// Description:	 BS代码维护统计子组相关程序维护
Class web.DHCWL.V1.CodeCFG.GrpFunModule Extends %RegisteredObject
{

/// Creator		：wk
/// CreatDate	：2018-08-09
/// Description : 获取归集大组信息 
/// Others		：d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CodeCFG.GrpFunModule","GetGroupQuery")
Query GetGroupQuery(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,codecfgCode:%String:大组编码,codecfgName:%String:大组描述,codecfgDim:%String:关联维度,codecfgCreator:%String:大组创建者") [ SqlProc ]
{
}

ClassMethod GetGroupQueryExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
 	
	s sql="SELECT ID,Grp_Code,Grp_Desc,Grp_Dim_Dr,Grp_CreateUse FROM DHCWL_CodeCfg.DHCWLCodeCfgGroup"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID = rs.Data("ID")
		s grpCode = rs.Data("Grp_Code")
		s grpDesc = rs.Data("Grp_Desc")
		s dimID = rs.Data("Grp_Dim_Dr")
		s dimInfor = ""
		if ((dimID'="")&&($d(^DHCWL.MKPI.MKPIDimTypeD(dimID)))){
			s dimInfor=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),2)_":"_$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),3)
		}
		s creator = rs.Data("Grp_CreateUse")
		continue:((filterValue'="")&&($zcvt(grpCode,"U") '[ filterValue)&&($zcvt(grpDesc,"U") '[ filterValue)&&($zcvt(dimInfor,"U") '[ filterValue)&&($zcvt(creator,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(ID,grpCode,grpDesc,dimInfor,creator)
		s ind=ind+1
	}
	d rs.Close()
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-08-13
/// Desc       : 获取归集子组信息
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.CodeCFG.GrpFunModule","GetSubGrpTreeQuery","9")
Query GetSubGrpTreeQuery(grpID As %String, filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,grpID:%String:grpID,name:%String:描述,code:%String:编码,sort:%String:排序,state:%String:是否展开,checked:%String:是否选中,_parentId:%String:父节点,flag:%String:是否可维护明细") [ SqlProc ]
{
}

ClassMethod GetSubGrpTreeQueryExecute(ByRef qHandle As %Binary, grpID As %String, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	s grpId=grpID
	q:grpId="" $$$OK
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	if (filterValue=""){
		s sql="SELECT ID,SGrp_Code,SGrp_Desc,SGrp_Sort,SGrp_TreeCode,SGrp_PTreeCode,SGrp_Level FROM DHCWL_CodeCfg.DHCWLCodeCfgSubGroup WHERE SGrp_Grp_Dr ="_grpID_" ORDER BY SGrp_Level, SGrp_Sort"
		s rs=##class(%Library.ResultSet).%New()
		d rs.Prepare(sql)
		d rs.Execute()
		While(rs.Next()){
			s ID=rs.Data("ID")
			s code=rs.Data("SGrp_Code")
			s desc=rs.Data("SGrp_Desc")
			s sort=rs.Data("SGrp_Sort")
			s treeCode=rs.Data("SGrp_TreeCode")
			s pTreeCode=rs.Data("SGrp_PTreeCode")
			s:pTreeCode="root" pTreeCode=""
			s level=rs.Data("SGrp_Level")+1
			s flag=1
			b
			s:$d(^DHCWL.CodeCfg.SubGroupI("GrpLevel",grpId,level)) flag=0
			s ^CacheTemp(repid,ind)=$lb(treeCode,ID,desc,code,sort,"open","",pTreeCode,flag)
			s ind=ind+1
		}
	}else{
	 	k codeCfgNodeList
	 	s subGrpID=""
	 	for{
		 	s subGrpID=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpID,subGrpID))
		 	q:subGrpID=""
	 		s grpCode=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),2)
	 		s grpDesc=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),3)
	 		continue:(($zcvt(grpCode,"U") '[ filterValue)&&($zcvt(grpDesc,"U") '[ filterValue))
	 		s treeCode=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),6)
	 		do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).GetAllParentNode(treeCode,.moduleNodeList)
	 	}
	 	
 		s index=""
 		for {
	 		s index=$o(moduleNodeList(index))
	 		q:index=""
	 		s treeCode=""
	 		for {
	 			s treeCode=$o(moduleNodeList(index,treeCode))
	 			q:treeCode=""
	 			continue:treeCode="root"
	 			s subGrpID=$o(^DHCWL.CodeCfg.SubGroupI("GrpTreeCode",grpID," "_$zcvt(treeCode,"U"),""))
	 			s grpCode=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),2)
	 			s grpDesc=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),3)
	 			s grpSort=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),5)
	 			s pTreeCode=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),7)
				s:pTreeCode="root" pTreeCode=""
	 			s ^CacheTemp(repid,ind)=$lb(treeCode,subGrpID,grpDesc,grpCode,grpSort,"open","",pTreeCode,0)
				s ind=ind+1
	 		}
 		}
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-11-29
/// Desc      : 根据传入节点获取所有父节点
/// Other     : do ##Class(web.DHCWL.V1.CodeCFG.GrpFunModule).GetAllParentNode("root")
ClassMethod GetAllParentNode(treeCode As %String, ByRef moduleNode)
{
	q:treeCode=""
	s len=$l(treeCode,".")
	for i=1:1:len {
		s moduleNode(i)=""
		s node=$p(treeCode,".",1,i)
		if ('$d(moduleNode(i,node))){
			s moduleNode(i,node)=""
		}
	}
}

/// Global 获取归集子组树备份
/// Creator   : wk
/// CreatDate : 2018-08-13
/// Desc      : 获取所有明细
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.CodeCFG.GrpFunModule","GetAllDetailQuery","9")
Query GetAllDetailQuery(grpid As %String, filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String,code:%String,desc:%String") [ SqlProc ]
{
}

ClassMethod GetAllDetailQueryExecute(ByRef qHandle As %Binary, grpid As %String = "", filterValue As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:grpid="" ""
	s count=0
	s count=##class(DHCWL.CodeCfgData.FunctionModule).CheckStatItem(grpid)
 	f num=0:1:count-1  d
	.s itemList=$g(^TEMPDHCWLCodeCheck($j,num))
	.s ID=$p(itemList,"^",1)
	.s ItemCode=$p(itemList,"^",2)
	.s ItemDesc=$p(itemList,"^",3)
	.i (filterValue'="") q:((##class(DHCWL.CodeCfgData.CheckGrpItemQuery).FilterValue(ItemCode,filterValue)=0)&&(##class(DHCWL.CodeCfgData.CheckGrpItemQuery).FilterValue(ItemDesc,filterValue)=0))
	.s ^CacheTemp(repid,ind)=$lb(ID,ItemCode,ItemDesc)
	.s ind=ind+1
	
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-13
/// Desc      : 获取已配置明细
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.CodeCFG.GrpFunModule","GetSelectDetailQuery","9")
Query GetSelectDetailQuery(subgrpId As %String, filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String,grpDetailID:%String,desc:%String,sort:%String,code:%String") [ SqlProc ]
{
}

ClassMethod GetSelectDetailQueryExecute(ByRef qHandle As %Binary, subgrpId As %String, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:subgrpId="" ""
	do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).UpdateGrpItemSortNew(subgrpId)
	s flag=0
	if ('$d(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subgrpId)))&&($d(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId))) d
	.s sc=##class(DHCWL.CodeCfgData.FunctionModule).UpdateGrpItemSort(subgrpId)
	.s:sc'="ok" flag=1
	q:flag=1 $$$OK
	s subGrpItemList=""
	s subGrpItemSort="" f  s subGrpItemSort=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subgrpId,subGrpItemSort)) q:subGrpItemSort=""  d
	.s subgrpItemId=0 f  s subgrpItemId=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subgrpId,subGrpItemSort,subgrpItemId)) q:subgrpItemId=""  d
	..s id=0 f  s id=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subgrpId,subGrpItemSort,subgrpItemId,id)) q:id=""  d
	...s grpDr=$list(^DHCWL.CodeCfg.SubGroupItemD(id),4)
	...s sort=$lg(^DHCWL.CodeCfg.SubGroupItemD(id),7)
	...s itemCode=$lg(^DHCWL.CodeCfg.SubGroupItemD(id),6)
	...//s typeDr=$list(^DHCWL.CodeCfg.GroupD(grpDr),7)
	...s typeDr=$list(^DHCWL.CodeCfg.GroupD(grpDr),11)    //取维度ID
	...s subgrpDetailId=$list(^DHCWL.CodeCfg.SubGroupItemD(id),2)  //add by wk~2017-07-03~解决获取到的明细ID是大写的问题
	...s itemId=$tr(subgrpDetailId," ")
	...s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(typeDr,itemId)
	...i (filterValue'="") q:((##class(DHCWL.CodeCfgData.CheckGrpItemQuery).FilterValue(itemCode,filterValue)=0)&&(##class(DHCWL.CodeCfgData.CheckGrpItemQuery).FilterValue(itemDesc,filterValue)=0))
	...;q:ind>1000 
	...s ^CacheTemp(repid,ind)=$lb(id,subgrpDetailId,itemDesc,sort,itemCode)
	...s ind=ind+1
	
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-13
/// Desc      : 归集大组新增
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).AddCodecfggrp()
ClassMethod AddCodecfggrp(grpCode, grpDesc, grpDimDr, grpCreator)
{
	s dim("GrpCode")=grpCode
	s dim("GrpDesc")=grpDesc
	s dim("GrpTypeDr")=""
	s dim("GrpCreateUse")=grpCreator
	s dim("GrpDimDr")=grpDimDr
	s dimCode=$p($g(dim("GrpDimDr")),":",1)
	if (dimCode=""){
		q "维护获取失败,请重试"
	}else{
		s dimID=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$zcvt(dimCode,"U"),""))
		if (dimID=""){
			q "维护获取失败,请重试"
		}
	}
	s tip=##class(DHCWL.CodeCfgData.SaveData).AddCodeGrp(.dim)
	s:tip="ok" tip="保存成功"
	q tip
}

/// Creator   : wk
/// CreatDate : 2018-08-13
/// Desc      : 归集大组更新
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).UpdateCodecfggrp()
ClassMethod UpdateCodecfggrp(grpID, grpCode, grpDesc, grpDimDr, grpCreator)
{
	s dim("ID")=grpID
	s dim("GrpCode")=grpCode
	s dim("GrpDesc")=grpDesc
	s dim("GrpTypeDr")=""
	s dim("GrpCreateUse")=grpCreator
	s dim("GrpDimDr")=grpDimDr
	s tip=##class(DHCWL.CodeCfgData.SaveData).UpdateCodeGrp(.dim)
	s:tip="ok" tip="更新成功"
	q tip
}

/// Creator   : wk
/// CreatDate : 2018-08-13
/// Desc      : 归集大组删除
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).DeleteCodecfggrp()
ClassMethod DeleteCodecfggrp(grpID)
{
	s id=grpID
	if ($d(^DHCWL.CodeCfg.SubGroupI("GrpDr",id))||($d(^DHCWL.CodeCfg.SubGroupItemI("Grp",id)))){
		q "子组下有条目和明细,请先删除之后再操作"
	}
	s tip=##class(DHCWL.CodeCfgData.SaveData).DeleteCodeGrp(id)
	s:tip="ok" tip="删除成功"
	q tip
}

/// Creator   : wk
/// CreatDate : 2018-08-13
/// Desc      : 统计子组导出
/// Other     :	do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).ExportSubGrp()
ClassMethod ExportSubGrp(selectID As %String)
{
	q:selectID="" ""
	d ##class(DHCWL.CodeCfgData.FunctionModule).GetGrpInfor(selectID)
	s str="",deli=",",num=1
	w "["
	s grpID=""
	for{
		s grpID=$o(^||TEMPDHCWL($j,"Grp","Export",grpID))
		q:grpID=""
		s treeCode=""
		for{
			s treeCode=$o(^||TEMPDHCWL($j,"Grp","Export",grpID,treeCode))
			q:treeCode=""
			if ($g(^||TEMPDHCWL($j,"Grp","Export",grpID,treeCode))'=""){
				s infor=^||TEMPDHCWL($j,"Grp","Export",grpID,treeCode)
				w:num'=1 ","
				s num=num+1
				s newTreeCode=$p(treeCode,".",2,$l(treeCode,"."))
				s str="['"_$p(infor,"&",1)_"'"_deli_"'"_$p(infor,"&",2)_"'"_deli_"'"_$p(infor,"&",3)_"'"_deli_"'"_$p(infor,"&",4)_"'"_deli_"'"_$p(infor,"&",5)_"'"_deli_"'"_newTreeCode_"'"_deli_"'"_$p(infor,"&",6)_"'"_deli_"'"_$p(infor,"&",7)_"'"_deli_"'"_$p(infor,"&",8)_"'"_deli_"'"_$p(infor,"&",9)_"']"
				w str
			}else{
				s item=""
				for{
					s item=$o(^||TEMPDHCWL($j,"Grp","Export",grpID,treeCode,item))
					q:item=""
					w:num'=1 ","
					s infor=^||TEMPDHCWL($j,"Grp","Export",grpID,treeCode,item)
					s newTreeCode=$p(treeCode,".",2,$l(treeCode,"."))
					s str="['"_$p(infor,"&",1)_"'"_deli_"'"_$p(infor,"&",2)_"'"_deli_"'"_$p(infor,"&",3)_"'"_deli_"'"_$p(infor,"&",4)_"'"_deli_"'"_$p(infor,"&",5)_"'"_deli_"'"_newTreeCode_"'"_deli_"'"_$p(infor,"&",6)_"'"_deli_"'"_$p(infor,"&",7)_"'"_deli_"'"_$p(infor,"&",8)_"'"_deli_"'"_$p(infor,"&",9)_"'"_deli_"'"_$p(infor,"&",10)_"'"_deli_"'"_$p(infor,"&",11)_"']"
					s num=num+1
					w str
				}
			}
			
		}
	}
	w "]"
	q ""
}

/// Creator   : wk
/// CreatDate : 2018-08-13
/// Desc      : 统计子组导出--谷歌版
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.CodeCFG.GrpFunModule","ExportSubGrpQuery","9")
Query ExportSubGrpQuery(selectID As %String) As websys.Query(ROWSPEC = "code:%String:归集大组编码,desc:%String:归集大组描述,date:%String:创建时间,creator:%String:创建人,dimType:%String:维度类型,node:%String:当前节点,subGrpCode:%String:归集子组编码,subgrpDesc:%String:归集子组描述,sortValue:%String:排序值,level:%String:层级,detailID:%String:明细ID,detailDesc:%String:明细描述") [ SqlProc ]
{
}

ClassMethod ExportSubGrpQueryExecute(ByRef qHandle As %Binary, selectID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	
 	q:selectID="" $$$OK
	d ##class(DHCWL.CodeCfgData.FunctionModule).GetGrpInfor(selectID)
	s str="",deli=",",num=1
	s grpID=""
	for{
		s grpID=$o(^||TEMPDHCWL($j,"Grp","Export",grpID))
		q:grpID=""
		s treeCode=""
		for{
			s treeCode=$o(^||TEMPDHCWL($j,"Grp","Export",grpID,treeCode))
			q:treeCode=""
			if ($g(^||TEMPDHCWL($j,"Grp","Export",grpID,treeCode))'=""){
				s infor=^||TEMPDHCWL($j,"Grp","Export",grpID,treeCode)
				s num=num+1
				s newTreeCode=$p(treeCode,".",2,$l(treeCode,"."))
				//s str="['"_$p(infor,"&",1)_"'"_deli_"'"_$p(infor,"&",2)_"'"_deli_"'"_$p(infor,"&",3)_"'"_deli_"'"_$p(infor,"&",4)_"'"_deli_"'"_$p(infor,"&",5)_"'"_deli_"'"_newTreeCode_"'"_deli_"'"_$p(infor,"&",6)_"'"_deli_"'"_$p(infor,"&",7)_"'"_deli_"'"_$p(infor,"&",8)_"'"_deli_"'"_$p(infor,"&",9)_"']"
				s ^CacheTemp(repid,ind)=$lb($p(infor,"&",1),$p(infor,"&",2),$p(infor,"&",3),$p(infor,"&",4),$p(infor,"&",5),newTreeCode,$p(infor,"&",6),$p(infor,"&",7),$p(infor,"&",8),$p(infor,"&",9),"","")
				s ind=ind+1
			}else{
				s item=""
				for{
					s item=$o(^||TEMPDHCWL($j,"Grp","Export",grpID,treeCode,item))
					q:item=""
					s infor=^||TEMPDHCWL($j,"Grp","Export",grpID,treeCode,item)
					s newTreeCode=$p(treeCode,".",2,$l(treeCode,"."))
					//s str="['"_$p(infor,"&",1)_"'"_deli_"'"_$p(infor,"&",2)_"'"_deli_"'"_$p(infor,"&",3)_"'"_deli_"'"_$p(infor,"&",4)_"'"_deli_"'"_$p(infor,"&",5)_"'"_deli_"'"_newTreeCode_"'"_deli_"'"_$p(infor,"&",6)_"'"_deli_"'"_$p(infor,"&",7)_"'"_deli_"'"_$p(infor,"&",8)_"'"_deli_"'"_$p(infor,"&",9)_"'"_deli_"'"_$p(infor,"&",10)_"'"_deli_"'"_$p(infor,"&",11)_"']"
					s ^CacheTemp(repid,ind)=$lb($p(infor,"&",1),$p(infor,"&",2),$p(infor,"&",3),$p(infor,"&",4),$p(infor,"&",5),newTreeCode,$p(infor,"&",6),$p(infor,"&",7),$p(infor,"&",8),$p(infor,"&",9),$p(infor,"&",10),$p(infor,"&",11))
					s ind=ind+1
				}
			}
			
		}
	}
	q $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-14
/// Desc      : 新增归集子组
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).AddCodecfgTreesubgrp()
ClassMethod AddCodecfgTreesubgrp(subGrpCode, subGrpDesc, grpID)
{
	s dim("SGrpCode")=subGrpCode
	s dim("SGrpDesc")=subGrpDesc
	s dim("SGrpGrpDr")=grpID
	s tip=##class(DHCWL.CodeCfgData.SaveData).AddCodeTreeSubGrp(.dim)
	s:tip="ok" tip="保存成功"
	q tip
}

/// Creator   : wk
/// CreatDate : 2018-08-14
/// Desc      : 修改归集子组
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).UpdateCodecfgsubgrp()
ClassMethod UpdateCodecfgsubgrp(ID, subGrpCode, subGrpDesc, grpID, subGrpSort)
{
	s dim("ID")=ID
	s dim("SGrpCode")=subGrpCode
	s dim("SGrpDesc")=subGrpDesc
	s dim("SGrpGrpDr")=grpID
	s dim("SGrpSort")=subGrpSort
	s tip=##class(DHCWL.CodeCfgData.SaveData).UpdateCodeSubGrp(.dim)
	s:tip="ok" tip="保存成功"
	q tip
}

/// Creator   : wk
/// CreatDate : 2018-08-14
/// Desc      : 删除归集子组
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).DeleteCodecfgsubtreegrp()
ClassMethod DeleteCodecfgsubtreegrp(subGrpID)
{
	s id=subGrpID
	s treeCode=$lg(^DHCWL.CodeCfg.SubGroupD(id),6)
	s grpID=$lg(^DHCWL.CodeCfg.SubGroupD(id),4)
	if ($d(^DHCWL.CodeCfg.SubGroupI("GrpPTreeCode",grpID," "_$zcvt(treeCode,"U"))))
	{
		q "请删除子节点后再进行操作"
	}
	s tip=##class(DHCWL.CodeCfgData.SaveData).DeleteCodeSubTreeGrp(id)
	s:tip="ok" tip="删除成功"
	s:tip="error" tip="请删除该组下的所有明细"
	return tip
}

/// Creator   : wk
/// CreatDate : 2018-08-14
/// Desc      : 新增统计子组明细
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).Addsubgrpitem()
ClassMethod Addsubgrpitem(grpID, subGrpID, selectItemPara, selectItemCode)
{
	s dim("GrpId")=grpID
	s dim("SubGrpId")=subGrpID
	s dim("selectItemPara")=selectItemPara
	s dim("selectItemCode")=selectItemCode
	s tip=##class(DHCWL.CodeCfgData.SaveData).AddSubGrpItem(.dim)
	s:tip="ok" tip="添加成功"
	q tip
}

/// Creator    : wk
/// CreatDate  : 2018-08-14
/// Desc       : 删除统计子组明细
/// Other      : do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).DeleteSubGrpDetail()
ClassMethod DeleteSubGrpDetail(grpDetailID)
{
	s id=grpDetailID
	s tip=##class(DHCWL.CodeCfgData.SaveData).DeleteSubGrpDetail(id)
	s:tip="ok" tip="删除明细成功"
	q tip
}

/// Creator    : wk
/// CreatDate  : 2018-08-14
/// Desc       : 删除全部统计子组明细
/// Other      : do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).DeleteAllSubGrpDetail()
ClassMethod DeleteAllSubGrpDetail(subgrpID)
{
	s subgrpId=subgrpID
	if ('$d(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId))){
		q "不存在需要删除的明细"
	}
	s tip=##class(DHCWL.CodeCfgData.SaveData).DeleteSubGrpAllDetail(subgrpId)
	s:tip="ok" tip="删除成功"
	q tip
}

/// Creator   : wk
/// CreatDate : 2018-08-14
/// Desc      : 统计子组明细排序重置
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).UpdategrpitemSort()
ClassMethod UpdategrpitemSort()
{
	s grpId=$g(%request.Data("grpId",1))
	s strPara=$g(%request.Data("strPara",1))
	s tip=##class(DHCWL.CodeCfgData.SaveData).updategrpitemSort(grpId,strPara)
	w "{success:true,tip:'"_tip_"'}"
}

/// Creator    ：wk
/// CreatDate  : 2018-12-10
/// Desc       : 统计子组明细排序
/// Other      : do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).UpdateGrpItemSortNew()
ClassMethod UpdateGrpItemSortNew(subGrpID As %String)
{
	s sort=""
	s errorFlag=0
	s num=1
	for {
		s sort=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,sort))
		q:sort=""
		q:errorFlag=1
		s itemID=""
		for {
			s itemID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,sort,itemID))
			q:itemID=""
			if (num'=sort){
				s rowID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,sort,itemID,""))
				&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem set SGrpIM_Sort=:num where ID=:rowID)
				if (SQLCODE'=0){
					s errorFlag=1
					q
				}
			}
			s num=num+1
		}
	}
	q:(errorFlag=1) "error"
	q "ok"
}

/// Creator    : wk
/// CreatDate  : 2018-08-14
/// Desc       : 归集子组上/下移一位
/// Other      : do ##Class(web.DHCWL.V1.CodeCFG.GrpFunModule).GrpMoveUp()
ClassMethod GrpMoveUpAndDown(subGrpID, sign)
{
	q:('$d(^DHCWL.CodeCfg.SubGroupD(subGrpID))) "获取归集子组失败"
	k grpNodeList
	s parentNode=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),7)
	s subGrpSort=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),5)
	q:((sign="up")&&(subGrpSort<2)) "已经是第一个喽~"
	//q:((sign="down")&&(subGrpSort<2)) "已经是第一个喽~"
	s grpID=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),4)
	s ID=""
	for {
		s ID=$o(^DHCWL.CodeCfg.SubGroupI("GrpPTreeCode",grpID," "_$ZCVT(parentNode,"U"),ID))
		q:ID=""
		s sort=$lg(^DHCWL.CodeCfg.SubGroupD(ID),5)
		s grpNodeList(sort,ID)=""
	}
	s maxSortNum=$o(grpNodeList(""),-1)
	q:((sign="down")&&(subGrpSort>=maxSortNum)) "已经是最后一个喽~"
	if (sign="up"){
		s targetSort=subGrpSort-1
	}elseif(sign="down"){
		s targetSort=subGrpSort+1
	}else{
		q "无法移动"
	}
	if ($d(grpNodeList(targetSort))){
		s targetGrpID=$o(grpNodeList(targetSort,""))
		q:targetGrpID=""
		&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroup set SGrp_Sort=:subGrpSort where ID=:targetGrpID)
		if (SQLCODE'=0){
			q "更新失败"
		}
	}
	&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroup set SGrp_Sort=:targetSort where ID=:subGrpID)
	if (SQLCODE'=0){
		q "更新失败"
	}
	k dimLogList
	s dimLogList("operType")="更新"
	s dimLogList("modType")="归集子组"
	s subGrpCode=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),2)
	s subGrpDesc=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),3)
	s grpID=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),4)
	s grpCode=$lg($g(^DHCWL.CodeCfg.GroupD(grpID)),2)
	s grpDesc=$lg($g(^DHCWL.CodeCfg.GroupD(grpID)),3)
	s dimLogList("depMod")=grpCode_":"_grpDesc_"."_subGrpCode_":"_subGrpDesc
	if (sign="up") {
		s dimLogList("GrpModAttr")="上移一位"
	}elseif(sign="down"){
		s dimLogList("GrpModAttr")="下移一位"
	}
	s sc=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList)
	q "更新成功"
}

/// Creator    : wk
/// CreataDate : 2018-08-20
/// Desc       : 归集子组位置跳转
/// Other      : do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).GrpMoveToLocation(26,20)
ClassMethod GrpMoveToLocation(subGrpID, aimsValue)
{
	s location=aimsValue
	q:('$d(^DHCWL.CodeCfg.SubGroupD(subGrpID))) "获取归集子组失败"
	k grpNodeList
	s parentNode=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),7)
	s subGrpSort=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),5)
	q:(location < 1) "请选择合适的移动范围"
	s grpID=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),4)
	s ID=""
	for {
		s ID=$o(^DHCWL.CodeCfg.SubGroupI("GrpPTreeCode",grpID," "_$ZCVT(parentNode,"U"),ID))
		q:ID=""
		s sort=$lg(^DHCWL.CodeCfg.SubGroupD(ID),5)
		s grpNodeList(sort,ID)=""
	}
	s maxSortNum=$o(grpNodeList(""),-1)
	q:(location > maxSortNum) "该位置已经超出最大范围"
	q:(location=subGrpSort) "更新成功"
	s flag=0
	k updateList
	if (location > subGrpSort){
		for i=(subGrpSort+1):1:location{
			s IDCycle=$o(grpNodeList(i,""))
			continue:IDCycle=""
			s sort=(i-1)
			s updateList(IDCycle)=sort
		}
		s IDCycle=""
		for {
			s IDCycle=$o(updateList(IDCycle))
			q:IDCycle=""
			s sort=updateList(IDCycle)
			&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroup set SGrp_Sort=:sort where ID=:IDCycle)
			if (SQLCODE'=0){
				s flag=1
				q
			}
		}
	}else{
		for i=location:1:(subGrpSort-1){
			s IDCycle=$o(grpNodeList(i,""))
			continue:IDCycle=""
			s sort=(i+1)
			s updateList(IDCycle)=sort
		}
		s IDCycle=""
		for {
			s IDCycle=$o(updateList(IDCycle))
			q:IDCycle=""
			s sort=updateList(IDCycle)
			&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroup set SGrp_Sort=:sort where ID=:IDCycle)
			if (SQLCODE'=0){
				s flag=1
				q
			}
		}
	}
	q:flag=1 "更新失败"
	&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroup set SGrp_Sort=:aimsValue where ID=:subGrpID)
	q:(SQLCODE'=0) "更新失败"
	
	k dimLogList
	s dimLogList("operType")="更新"
	s dimLogList("modType")="归集子组"
	s subGrpCode=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),2)
	s subGrpDesc=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),3)
	s grpID=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),4)
	s grpCode=$lg($g(^DHCWL.CodeCfg.GroupD(grpID)),2)
	s grpDesc=$lg($g(^DHCWL.CodeCfg.GroupD(grpID)),3)
	s dimLogList("depMod")=grpCode_":"_grpDesc_"."_subGrpCode_":"_subGrpDesc
	s dimLogList("GrpModAttr")="子组跳转"
	s sc=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList)
	q "更新成功"
}

/// Creator   : wk
/// CreatDate : 2018-08-14
/// Desc      : 统计子组明细上移一位
/// Other     ：do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).MoveUp()
ClassMethod MoveUp(subGrpID, itemID)
{
	s subGrpID=subGrpID
	s itemID=itemID
	s sc=##class(DHCWL.CodeCfgData.FunctionModule).Moveup(subGrpID,itemID)
	s:sc="ok" sc="操作成功"
	q sc
}

/// Creator   : wk
/// CreatDate : 2018-08-14
/// Desc      : 统计子组明细上移一位
/// Other     ：do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).MoveDown()
ClassMethod MoveDown(subGrpID, itemID)
{
	s subGrpID=subGrpID
	s itemID=itemID
	s sc=##class(DHCWL.CodeCfgData.FunctionModule).ItemNext(subGrpID,itemID)
	s:sc="ok" sc="操作成功"
	q sc
}

/// Creator   : wk
/// CreatDate : 2018-08-14
/// Desc      : 根据跳转位置跳转
/// Other     ：do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).MoveToLocal()
ClassMethod MoveToLocal(subGrpID, itemID, aimsValue)
{
	s subGrpID=subGrpID
	s itemID=itemID
	s aimsValue=aimsValue
	s sc=##class(DHCWL.CodeCfgData.FunctionModule).MoveToLocal(subGrpID,itemID,aimsValue)
	s:sc="ok" sc="操作成功"
	q sc
}

/// Creator   : wk
/// CreatDate : 2018-08-14
/// Desc      : 新增归集子组子节点
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).SaveSubGroupChild()
ClassMethod SaveSubGroupChild(code As %String, desc As %String, groupCode As %String, grpId As %String)
{
	s result=##class(DHCWL.CodeCfgData.FunctionModule).SaveSubGroup(grpId,code,desc,groupCode)
	q:result=1 "保存成功"
	q:result=-1 "该项目或同级项目下维护有明细,不能添加!"
	q:result=-2 "新增项目编码重复了,再重起个名字呗!"
	q "保存失败"
}

/// Creator   : wk
/// CreatDate : 2018-08-21
/// Desc      : 统计子组日志初始化
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).InitGrpLogGlobal()
ClassMethod InitGrpLogGlobal()
{
	k ^TEMPDHCWL("olnyForGrpLog","TJZZ")
	q "ok"
}

/// Creator   : wk
/// CreatDate : 2018-08-21
/// Desc      : 统计子组日志保存
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.GrpFunModule).EndGrpLogGlobal()
ClassMethod EndGrpLogGlobal()
{
	if ($d(^TEMPDHCWL("olnyForGrpLog","TJZZ"))){
		k dimLogList
		s dimLogList("operType")="更新"
		s dimLogList("modType")="子组明细"
		s dimLogList("depMod")=$g(^TEMPDHCWL("olnyForGrpLog","TJZZ","depMod"))
		s logID=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList,1)
		s dimLogList("LogHeader")="ID:编码"
		s dimLogList("logDr")=logID
		s num=""
		for{
			s num=$o(^TEMPDHCWL("olnyForGrpLog","TJZZ","Data",num),-1)
			q:num=""
			s type=$o(^TEMPDHCWL("olnyForGrpLog","TJZZ","Data",num,""),-1)
			continue:type=""
			s logInfor=$g(^TEMPDHCWL("olnyForGrpLog","TJZZ","Data",num,type))
			s dimLogList("LogInfor")=logInfor
			s dimLogList("Type")=type
			d ##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList,2)
		}

		k ^TEMPDHCWL("olnyForGrpLog","TJZZ")
	}
	q "ok"
}

}
