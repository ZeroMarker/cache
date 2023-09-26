/// Creator    :     wk
/// CreatDate  :     2018-08-09
/// Description:	 BS代码维护统计大组相关程序维护
Class web.DHCWL.V1.CodeCFG.FunModule Extends %RegisteredObject
{

/// Creator：      wk
/// CreatDate：    2018-08-09
/// Description:： 获取统计大组信息 
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CodeCFG.FunModule","GetItemGroupQuery")
Query GetItemGroupQuery(filterValue As %String) As websys.Query(ROWSPEC = "ID:%String:ID,codecfgCode:%String:大组编码,codecfgName:%String:大组描述,codecfgDim:%String:关联维度,codecfgCreator:%String:大组创建者") [ SqlProc ]
{
}

ClassMethod GetItemGroupQueryExecute(ByRef qHandle As %Binary, filterValue As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
 	
	s sql="SELECT ID,ItemGrp_Code,ItemGrp_Desc,ItemGrp_Dim_Dr,ItemGrp_CreateUse FROM DHCWL_CodeCfg.DHCWLCodeCfgItemGroup"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID = rs.Data("ID")
		s grpCode = rs.Data("ItemGrp_Code")
		s grpDesc = rs.Data("ItemGrp_Desc")
		s dimID = rs.Data("ItemGrp_Dim_Dr")
		s dimInfor = ""
		if ((dimID'="")&&($d(^DHCWL.MKPI.MKPIDimTypeD(dimID)))){
			s dimInfor=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),2)_":"_$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),3)
		}
		s creator = rs.Data("ItemGrp_CreateUse")
		continue:((filterValue'="")&&($zcvt(grpCode,"U") '[ filterValue)&&($zcvt(grpDesc,"U") '[ filterValue)&&($zcvt(dimInfor,"U") '[ filterValue)&&($zcvt(creator,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(ID,grpCode,grpDesc,dimInfor,creator)
		s ind=ind+1
	}
	d rs.Close()
	Quit $$$OK
}

/// Creator：       wk
/// CreatDate：     2018-08-09
/// Description: 	获取统计大组明细信息
/// Others：        d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CodeCFG.FunModule","GetItemGrpDetail")
/// 
Query GetItemGrpDetail(itemGrpID As %String = "") As websys.Query(ROWSPEC = "rowID:%String:大组明细ID,ID:%String:明细ID,detailDesc:%String:大组明细描述,detailSort:%String:大组明细排序值") [ SqlProc ]
{
}

ClassMethod GetItemGrpDetailExecute(ByRef qHandle As %Binary, itemGrpID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:itemGrpID="" $$$OK
 	s sc=##class(web.DHCWL.V1.CodeCFG.FunModule).UpdateGrpItemSortNew(itemGrpID)
	s sql="SELECT ID,ItmGrpDet_Item_DR,ItmGrpDet_Sort FROM DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails WHERE ItmGrpDet_Grp_Dr="_itemGrpID_" order by ItmGrpDet_Sort"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s sort=rs.Data("ItmGrpDet_Sort")
		s itemID=rs.Data("ItmGrpDet_Item_DR")
		s itemDesc=##class(web.DHCWL.V1.CodeCFG.FunModule).GetDimDescByItemGrp(itemGrpID,itemID)
		s ^CacheTemp(repid,ind)=$lb(ID,itemID,itemDesc,sort)
		s ind=ind+1
	}
	d rs.Close()
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-09
/// Desc 	  : 根据统计大组ID以及维度明细ID获取解析后的值
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.FunModule).GetDimDescByItemGrp()
ClassMethod GetDimDescByItemGrp(itemGrpID, itemID)
{
	q:((itemGrpID="")||(itemID="")) ""
	s dimID=""
	if ($d(^DHCWL.CodeCfg.ItemGroupD(itemGrpID))){
		s dimID=$lg(^DHCWL.CodeCfg.ItemGroupD(itemGrpID),8)
	}
	q:dimID="" ""
	s value=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(dimID,itemID)
	q value
}

/// Creator：      wk
/// CreatDate：    2018-08-09
/// Description:： 获取维度信息 
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CodeCFG.FunModule","GetDimQuery")
/// 
Query GetDimQuery(q As %String = "") As websys.Query(ROWSPEC = "dimID:%String:维度ID,dimDesc:%String:维度描述") [ SqlProc ]
{
}

ClassMethod GetDimQueryExecute(ByRef qHandle As %Binary, q As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s filterValue=""
 	s:q'="" filterValue=$zcvt(q,"U")
 	
 	d ##class(DHCWL.CodeCfgData.FunctionModule).getOldDimList(.list)
	s sql="SELECT ID,KDT_Code,KDT_Name,KDT_ExeCode FROM DHCWL_MKPI.DHCWLMKPIDimType"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s dimCode=rs.Data("KDT_Code")
		s dimDesc=rs.Data("KDT_Name")
		s exeCode=rs.Data("KDT_ExeCode")
		s upDimCode=$zcvt(dimCode,"U")
		continue:exeCode=""
		continue:($d(list(upDimCode)))
		s dimDesc=dimCode_":"_dimDesc
		continue:(filterValue'="")&&($zcvt(dimDesc,"U")'[filterValue)
		s ^CacheTemp(repid,ind)=$lb(rs.Data("ID"),dimDesc)
		s ind=ind+1
	}
	d rs.Close()
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-09
/// Desc      : 统计大组新增
/// Other     ：do ##class(web.DHCWL.V1.CodeCFG.FunModule).addItemgrp()
ClassMethod addItemgrp(grpCode, grpDesc, grpDimID, grpUser)
{
	s dim("GrpCode")=grpCode
	s dim("GrpDesc")=grpDesc
	s dim("GrpTypeDr")=""
	s dim("GrpCreateUse")=grpUser
	s dim("GrpDimDr")=grpDimID
	s dimCode=$p($g(dim("GrpDimDr")),":",1)
	if (dimCode=""){
		q "维护获取失败,请重试"
	}else{
		s dimID=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$zcvt(dimCode,"U"),""))
		if (dimID=""){
			q "维护获取失败,请重试"
		}
	}
	s tip=##class(DHCWL.CodeCfgData.SaveData).AddCodeItemGrp(.dim)
	q tip
}

/// Creator    : wk
/// CreatDate  : 2018-08-10
/// Desc       : 统计大组更新
/// Other      : do ##class(web.DHCWL.V1.CodeCFG.FunModule).UpdateItemgrp
ClassMethod UpdateItemgrp(ID, grpCode, grpDesc, grpTypeDr, grpCreateUse, grpDimDr)
{
	s dim("ID")=ID
	s dim("GrpCode")=grpCode
	s dim("GrpDesc")=grpDesc
	s dim("GrpTypeDr")=grpTypeDr
	s dim("GrpCreateUse")=grpCreateUse
	s dim("GrpDimDr")=grpDimDr
	s tip=##class(DHCWL.CodeCfgData.SaveData).UpdateCodeItemGrp(.dim)
	s:(tip="ok") tip="更新成功"
	q tip
}

/// Creator   : wk
/// CreatDate : 2018-08-10
/// Desc      : 获取统计大组所有明细
/// Other     :d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CodeCFG.FunModule","CheckGroupItemQuery","1")
Query CheckGroupItemQuery(grpid As %String, filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String,detailAddCode:%String,detailAddDesc:%String") [ SqlProc ]
{
}

ClassMethod CheckGroupItemQueryExecute(ByRef qHandle As %Binary, grpid As %String, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:grpid="" ""
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	s count=0
	s count=##class(DHCWL.CodeCfgData.FunctionModule).CheckGroupItem(grpid)
 	f num=0:1:count-1  d
	.s itemList=$g(^TEMPDHCWLCodeGroupCheck($j,num))
	.s ID=$p(itemList,"^",1)
	.s ItemCode=$p(itemList,"^",2)
	.s ItemDesc=$p(itemList,"^",3)
	.q:(filterValue'="")&&($zcvt(ItemCode,"U") '[ filterValue)&&($zcvt(ItemDesc,"U") '[ filterValue)
	.q:ind>1000    //暂时只显示1000条
	.s ^CacheTemp(repid,ind)=$lb(ID,ItemCode,ItemDesc)
	.s ind=ind+1
	
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-10
/// Desc      : 统计大组删除
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.FunModule).DeleteItemgrp()
ClassMethod DeleteItemgrp(itemID)
{
	s id=itemID
	if ($d(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",id))){
		q "请先删除明细之后再删除统计大组"
	}
	s tip=##class(DHCWL.CodeCfgData.SaveData).DeleteCodeItemGrp(id)
	s:tip="ok" tip="删除成功"
	q tip
}

/// Creator   : wk
/// CreatDate : 2018-08-10
/// Desc      : 统计大组导出
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.FunModule).ExportGrp()
ClassMethod ExportGrp(selectID As %String)
{
	q:selectID="" ""
	d ##class(DHCWL.CodeCfgData.FunctionModule).GetItemGrpInfor(selectID)
	s str="",deli=",",num=1
	w "["
	s itemGrpID=""
	for {
		s itemGrpID=$o(^||TEMPDHCWL($j,"Grp","Export",itemGrpID))
		q:itemGrpID=""
		if ($g(^||TEMPDHCWL($j,"Grp","Export",itemGrpID))'=""){
			s infor=^||TEMPDHCWL($j,"Grp","Export",itemGrpID)
			w:num'=1 ","
			s num=num+1
			s str="['"_$p(infor,"&",1)_"'"_deli_"'"_$p(infor,"&",2)_"'"_deli_"'"_$p(infor,"&",3)_"'"_deli_"'"_$p(infor,"&",4)_"'"_deli_"'"_$p(infor,"&",5)_"']"
			w str
		}else{
			s itemID=""
			for{
				s itemID=$o(^||TEMPDHCWL($j,"Grp","Export",itemGrpID,itemID))
				q:itemID=""
				w:num'=1 ","
				s num=num+1
				s infor=^||TEMPDHCWL($j,"Grp","Export",itemGrpID,itemID)
				s str="['"_$p(infor,"&",1)_"'"_deli_"'"_$p(infor,"&",2)_"'"_deli_"'"_$p(infor,"&",3)_"'"_deli_"'"_$p(infor,"&",4)_"'"_deli_"'"_$p(infor,"&",5)_"'"_deli_"'"_$p(infor,"&",6)_"'"_deli_"'"_$p(infor,"&",7)_"'"_deli_"'"_$p(infor,"&",8)_"']"
				w str
			}
		}	
	}
	w "]"
	q ""
}

/// Creator   : wk
/// CreatDate : 2018-08-13
/// Desc      : 统计大组导出--谷歌版
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.CodeCFG.FunModule","ExportGrpQuery","9")
Query ExportGrpQuery(selectID As %String) As websys.Query(ROWSPEC = "grouCode:%String:大组编码,groupDesc:%String:大组描述,creatDate:%String:创建时间,creator:%String:创建人,dimType:%String:维度类型,detailID:%String:明细ID,detailDesc:%String:明细描述,detailSort:%String:明细排序值") [ SqlProc ]
{
}

ClassMethod ExportGrpQueryExecute(ByRef qHandle As %Binary, selectID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	
 	q:selectID="" ""
	d ##class(DHCWL.CodeCfgData.FunctionModule).GetItemGrpInfor(selectID)
	s str="",deli=",",num=1
	s itemGrpID=""
	for {
		s itemGrpID=$o(^||TEMPDHCWL($j,"Grp","Export",itemGrpID))
		q:itemGrpID=""
		if ($g(^||TEMPDHCWL($j,"Grp","Export",itemGrpID))'=""){
			s infor=^||TEMPDHCWL($j,"Grp","Export",itemGrpID)
			s num=num+1
			s str="['"_$p(infor,"&",1)_"'"_deli_"'"_$p(infor,"&",2)_"'"_deli_"'"_$p(infor,"&",3)_"'"_deli_"'"_$p(infor,"&",4)_"'"_deli_"'"_$p(infor,"&",5)_"']"
			s ^CacheTemp(repid,ind)=$lb($p(infor,"&",1),$p(infor,"&",2),$p(infor,"&",3),$p(infor,"&",4),$p(infor,"&",5),)
			s ind=ind+1
		}else{
			s itemID=""
			for{
				s itemID=$o(^||TEMPDHCWL($j,"Grp","Export",itemGrpID,itemID))
				q:itemID=""
				s num=num+1
				s infor=^||TEMPDHCWL($j,"Grp","Export",itemGrpID,itemID)
				//s str="['"_$p(infor,"&",1)_"'"_deli_"'"_$p(infor,"&",2)_"'"_deli_"'"_$p(infor,"&",3)_"'"_deli_"'"_$p(infor,"&",4)_"'"_deli_"'"_$p(infor,"&",5)_"'"_deli_"'"_$p(infor,"&",6)_"'"_deli_"'"_$p(infor,"&",7)_"'"_deli_"'"_$p(infor,"&",8)_"']"
				s ^CacheTemp(repid,ind)=$lb($p(infor,"&",1),$p(infor,"&",2),$p(infor,"&",3),$p(infor,"&",4),$p(infor,"&",5),$p(infor,"&",6),$p(infor,"&",7),$p(infor,"&",8))
				s ind=ind+1
			}
		}	
	}
	q $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-08-12
/// Desc       : 保存统计大组明细
/// Other      : do ##class(web.DHCWL.V1.CodeCFG.FunModule).Addgrpitem()
ClassMethod Addgrpitem(grpId, selectItemPara)
{
	s dim("GrpId")=grpId
	s dim("selectItemPara")=selectItemPara
	s tip=##class(DHCWL.CodeCfgData.SaveData).AddGrpItem(.dim)
	s:tip="ok" tip="保存成功"
	q tip
}

/// Creator    : wk
/// CreatDate  : 2018-08-10
/// Desc       : 结束统计大组日志记录
/// Other      : do ##class(web.DHCWL.V1.CodeCFG.FunModule).EndItemGrpLogGlobal()
ClassMethod EndItemGrpLogGlobal()
{
	if ($d(^TEMPDHCWL("olnyForGrpLog","TJDZ"))){
		k dimLogList
		s dimLogList("operType")="新增"
		s dimLogList("modType")="大组明细"
		s dimLogList("depMod")=$g(^TEMPDHCWL("olnyForGrpLog","TJDZ","depMod"))
		s logID=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList,1)
		s dimLogList("LogHeader")="ID:编码"
		s dimLogList("logDr")=logID
		s num=""
		for{
			s num=$o(^TEMPDHCWL("olnyForGrpLog","TJDZ","Data",num),-1)
			q:num=""
			s type=$o(^TEMPDHCWL("olnyForGrpLog","TJDZ","Data",num,""),-1)
			continue:type=""
			s logInfor=$g(^TEMPDHCWL("olnyForGrpLog","TJDZ","Data",num,type))
			s dimLogList("LogInfor")=logInfor
			s dimLogList("Type")=type
			d ##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList,2)
		}
	
		k ^TEMPDHCWL("olnyForGrpLog","TJDZ")
	}
	//w "{success:true,tip:'ok'}"
	q "ok"
}

/// Creator   : wk
/// CreatDate : 2018-08-10
/// Desc      : 初始化日志记录
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.FunModule).InitItemGrpLogGlobal()
ClassMethod InitItemGrpLogGlobal()
{
	k ^TEMPDHCWL("olnyForGrpLog","TJDZ")
	//w "{success:true,tip:'ok'}"
	q "ok"
}

/// Creator   : wk
/// CreatDate : 2018-08-10
/// Desc      : 删除统计大组明细
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.FunModule).Delitem()
ClassMethod Delitem(grpID, selectItemPara)
{
	s dim("GrpId")=grpID
	s dim("selectItemPara")=selectItemPara
	s tip=##class(DHCWL.CodeCfgData.SaveData).DelItem(.dim)
	if (tip="ok") {
		s tip="删除成功"
	}
	q tip
}

/// Creator   : wk
/// CreatDate : 2018-08-10
/// Desc      : 更新统计大组明细的排序
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.FunModule).UpdateGrpItemSortNew()
ClassMethod UpdateGrpItemSortNew(grpID As %String)
{
	s sort=""
	s errorFlag=0
	s num=1
	for {
		s sort=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpID,sort))
		q:sort=""
		q:errorFlag=1
		s itemID=""
		for {
			s itemID=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpID,sort,itemID))
			q:itemID=""
			s detailID=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpID,sort,itemID,""))
			if (sort'=num){
				&sql(UPDATE DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails SET ItmGrpDet_Sort=:num WHERE ID=:detailID)
					if (SQLCODE'=0){
						s errorFlag=1
						q
					}
			}
			s num=num+1
		}
	}
	q:errorFlag=1 "error"
	q "ok"
}

/// Creator   : wk
/// CreatDate : 2018-08-10
/// Desc      : 更新统计大组的排序
/// Other     : do ##class(web.DHCWL.V1.CodeCFG.FunModule).updategrpitemSort()
ClassMethod updategrpitemSort(grpID As %String, strParaValue As %Text)
{
	s grpId=grpID
	s strPara=strParaValue
	s tip=##class(DHCWL.CodeCfgData.SaveData).updategrpitemSort(grpId,strPara)
	s:tip="ok" tip="排序成功"
	q tip
}

/// Creator    : wk
/// CreatDate  : 2018-08-14
/// Desc       : 大组明细上/下移一位
/// Other      : do ##Class(web.DHCWL.V1.CodeCFG.FunModule).GrpMoveUpAndDown()
ClassMethod GrpMoveUpAndDown(grpDetailID, sign)
{
	q:('$d(^DHCWL.CodeCfg.ItemGroupDetailsD(grpDetailID))) "获取统计大组明细失败"
	s grpID=$lg(^DHCWL.CodeCfg.ItemGroupDetailsD(grpDetailID),2)
	s sort=$lg(^DHCWL.CodeCfg.ItemGroupDetailsD(grpDetailID),5)
	q:((sign="up")&&(sort<2)) "已经是第一个喽~"
	s maxSortNum=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpID,""),-1)
	q:((sign="down")&&(sort>=maxSortNum)) "已经是最后一个喽~"
	if (sign="up"){
		s targetSort=sort-1
	}elseif(sign="down"){
		s targetSort=sort+1
	}else{
		q "无法移动"
	}
	s itemID=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpID,targetSort,""))
	s targetGrpID=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpID,targetSort,itemID,""))
	q:targetGrpID="" "获取目标明细错误"
	&sql(update DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails set ItmGrpDet_Sort=:sort where ID=:targetGrpID)
	if (SQLCODE'=0){
		q "更新失败"
	}
	&sql(update DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails set ItmGrpDet_Sort=:targetSort where ID=:grpDetailID)
	if (SQLCODE'=0){
		q "更新失败"
	}
	s dimDr=$lg($g(^DHCWL.CodeCfg.ItemGroupD(grpID)),8)
	s itemID=$lg($g(^DHCWL.CodeCfg.ItemGroupDetailsD(grpDetailID)),3)
	s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(dimDr,itemID)
	s dimLogList("operType")="更新"
	s dimLogList("modType")="大组明细"
	s dimLogList("depMod")=itemDesc
	if (sign="up") {
		s dimLogList("GrpModAttr")="上移一位"
	}elseif(sign="down"){
		s dimLogList("GrpModAttr")="下移一位"
	}
	s dimLogList("LogHeader")="ID:描述"
	s dimLogList("LogInfor")=itemID_":"_itemDesc
	s sc=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList)
	q "更新成功"
}

/// Creator    : wk
/// CreataDate : 2018-08-20
/// Desc       : 归集子组位置跳转
/// Other      : do ##class(web.DHCWL.V1.CodeCFG.FunModule).GrpMoveToLocation(17,2)
ClassMethod GrpMoveToLocation(grpDetailID, aimsValue)
{
	q:('$d(^DHCWL.CodeCfg.ItemGroupDetailsD(grpDetailID))) "获取统计大组明细失败"
	s grpID=$lg(^DHCWL.CodeCfg.ItemGroupDetailsD(grpDetailID),2)
	s sort=$lg(^DHCWL.CodeCfg.ItemGroupDetailsD(grpDetailID),5)
	q:(aimsValue < 1) "请选择合适的移动范围"
	s maxSortNum=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpID,""),-1)
	q:(aimsValue > maxSortNum) "该位置已经超出最大范围"
	q:(aimsValue=sort) "更新成功"
	s flag=0
	k updateList
	if (aimsValue > sort){
		for i=(sort+1):1:aimsValue{
			s itemID=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpID,i,""))
			continue:itemID=""
			s targetGrpID=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpID,i,itemID,""))
			s grpSort=(i-1)
			s updateList(targetGrpID)=grpSort
		}
		s targetGrpID=""
		for {
			s targetGrpID=$o(updateList(targetGrpID))
			q:targetGrpID=""
			s grpSort=updateList(targetGrpID)
			&sql(update DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails set ItmGrpDet_Sort=:grpSort where ID=:targetGrpID)
			if (SQLCODE'=0){
				s flag=1
				q
			}
		}
	}else{
		for i=aimsValue:1:(sort-1){
			s itemID=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpID,i,""))
			continue:itemID=""
			s targetGrpID=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpID,i,itemID,""))
			s grpSort=(i+1)
			s updateList(targetGrpID)=grpSort
		}
		s targetGrpID=""
		for {
			s targetGrpID=$o(updateList(targetGrpID))
			q:targetGrpID=""
			s grpSort=updateList(targetGrpID)
			&sql(update DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails set ItmGrpDet_Sort=:grpSort where ID=:targetGrpID)
			if (SQLCODE'=0){
				s flag=1
				q
			}
		}
	}
	q:flag=1 "更新失败"
	
	&sql(update DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails set ItmGrpDet_Sort=:aimsValue where ID=:grpDetailID)
	q:(SQLCODE'=0) "更新失败"
	s dimDr=$lg($g(^DHCWL.CodeCfg.ItemGroupD(grpID)),8)
	s itemID=$lg($g(^DHCWL.CodeCfg.ItemGroupDetailsD(grpDetailID)),3)
	s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(dimDr,itemID)
	s dimLogList("operType")="更新"
	s dimLogList("modType")="大组明细"
	s dimLogList("depMod")=itemDesc
	s dimLogList("GrpModAttr")="明细跳转"
	s dimLogList("LogHeader")="ID:描述"
	s dimLogList("LogInfor")=itemID_":"_itemDesc
	s sc=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList)
	q "更新成功"
}

/// Creator   : wk
/// CreatDate : 2018-08-12
/// Desc      : 获取统计组日志信息
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CodeCFG.FunModule","GetLogInforQuery","")
Query GetLogInforQuery(seaName = "", seaModeType = "", seaOperType = "", seaDate = "", grpCode = "", grpFlag = "") As websys.Query(ROWSPEC = "logID:%String,userID:%String,userName:%String,userIP:%String,operType:%String,dependMoudle:%String,operModule:%String,operDate:%String,operTime:%String,dependSubGrp:%String") [ SqlProc ]
{
}

ClassMethod GetLogInforQueryExecute(ByRef qHandle As %Binary, seaName = "", seaModeType = "", seaOperType = "", seaDate = "", grpCode = "", grpFlag = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s:(seaDate'="") seaDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(seaDate)
 	s:(grpCode'="") grpCode=$p(grpCode,":",1)
 	s logID=""
 	for{
	 	s logID=$o(^DHCWL.CodeCfg.LogInfoD(logID),-1)
	 	q:logID=""
	 	s userID=$lg(^DHCWL.CodeCfg.LogInfoD(logID),2)
	 	s userName=$lg(^DHCWL.CodeCfg.LogInfoD(logID),3)
	 	s userIP=$lg(^DHCWL.CodeCfg.LogInfoD(logID),4)
	 	s operType=$lg(^DHCWL.CodeCfg.LogInfoD(logID),5)
	 	s:operType="更新" operType="修改"
	 	s modType=$lg(^DHCWL.CodeCfg.LogInfoD(logID),6)
	 	s depModule=$lg(^DHCWL.CodeCfg.LogInfoD(logID),7)
	 	s operDate=$lg(^DHCWL.CodeCfg.LogInfoD(logID),8)
	 	continue:(grpFlag=1)&&((modType="统计大组")||(modType="大组明细"))
	 	continue:(grpFlag=2)&&((modType'="统计大组")&&(modType'="大组明细"))
	 	continue:(seaName'="")&&(($zcvt(userName,"U"))'[($zcvt(seaName,"U")))
	 	continue:(seaModeType'="")&&(($zcvt(modType,"U"))'[($zcvt(seaModeType,"U")))
	 	continue:(seaOperType'="")&&(($zcvt(operType,"U"))'[($zcvt(seaOperType,"U")))
	 	continue:(seaDate'="")&&(seaDate'=operDate)
	 	continue:(grpCode'="")&&((depModule)'[grpCode)
	 	s modAttr=$lg(^DHCWL.CodeCfg.LogInfoD(logID),11)
	 	s operDate=##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(operDate)
	 	s operTime=$lg(^DHCWL.CodeCfg.LogInfoD(logID),9)
	 	s operTime=$zt(operTime)
	 	s ^CacheTemp(repid,ind)=$lb(logID,userID,userName,userIP,operType,depModule,modType,operDate,operTime,modAttr)
		s ind=ind+1
 	}
	
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-21
/// Desc      : 获取日志明细
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CodeCFG.FunModule","GetLogDetail","") 
Query GetLogDetail(logID As %String) As websys.Query(ROWSPEC = "name:%String:名称,value:%String:值,type:%String:类型") [ SqlProc ]
{
}

ClassMethod GetLogDetailExecute(ByRef qHandle As %Binary, logID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    s sql="select Grp_LogHeader,Grp_LogInfor,Grp_OperType from DHCWL_CodeCfg.DHCWLCodeCfgLogDetailInfo where Grp_LogDr="_logID
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s logHeader=rs.Data("Grp_LogHeader")
		s logHeader=$replace(logHeader,"编码","描述")
		s logInfor=rs.Data("Grp_LogInfor")
		s type=rs.Data("Grp_OperType")
		s:type="Add" type="新增"
		s:type="Del" type="删除"
		s:type="DelAll" type="删除所有"
		s:type="itemNext" type="下移一位"
		s:type="moveup" type="上移一位"
		s:type="MoveToLocal" type="明细跳转"
		s:type="resetSort" type="排序重置"
		s ^CacheTemp(repid,ind)=$lb(logHeader,logInfor,type)
		s ind=ind+1
	}
	Quit $$$OK
}

}
