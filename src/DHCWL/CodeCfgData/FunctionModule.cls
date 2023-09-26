Class DHCWL.CodeCfgData.FunctionModule Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      yuanxu
/// CreatDate：    2014-05-05
/// Description:： 通过分组大类ID得到组下面的明细
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgSubGroup
/// Input：       
/// Output：      
/// Return：      返回JsonData格式和记录数
/// Others：w ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpListByGrpId("1")
ClassMethod GetSubGrpListByGrpId(id, SGrpCode = "", SGrpDesc = "") As %String
{
	
	n (id,SGrpCode,SGrpDesc)
	q:id="" 0
	s count=0
	s subGrpList=""
	s subgrpId=0 f  s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",id,subgrpId)) q:subgrpId=""  d
	.s value=##class(DHCWL.CodeCfg.SubGroup).%OpenId(subgrpId)
	.s count=count+1
	.s subgrpDesc=value.SGrpDesc
	.q:(SGrpDesc'="")&($zcvt(subgrpDesc,"U")'[$zcvt(SGrpDesc,"U"))
	.s subgrpCode=value.SGrpCode
	.q:(SGrpCode'="")&($zcvt(subgrpCode,"U")'[$zcvt(SGrpCode,"U"))
	.s subgrpSort=value.SGrpSort
	.s subGrpList=subGrpList_"{ID:"_subgrpId_",SGrpCode:'"_subgrpCode_"',SGrpDesc:'"_subgrpDesc_"',SGrpSort:'"_subgrpSort_"'},"
	q subGrpList_"^"_count
}

/// Creator：      wk
/// CreatDate：    2016-11-28
/// Description:： 通过搜索获得大组下子组条目
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgSubGroup
/// Input：       
/// Output：      
/// Return：      
/// Others：d ##class(DHCWL.CodeCfgData.FunctionModule).GetSearchSubGrpList()
ClassMethod GetSearchSubGrpList(id, SGrpCode, SGrpDesc)
{
	n (id,SGrpCode,SGrpDesc)
	q:id=""
	k treeCodeList
	s subgrpId=0 f  s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",id,subgrpId)) q:subgrpId=""  d
	.s value=##class(DHCWL.CodeCfg.SubGroup).%OpenId(subgrpId)
	.s subgrpDesc=value.SGrpDesc
	.q:(SGrpDesc'="")&($zcvt(subgrpDesc,"U")'[$zcvt(SGrpDesc,"U"))
	.s subgrpCode=value.SGrpCode
	.q:(SGrpCode'="")&($zcvt(subgrpCode,"U")'[$zcvt(SGrpCode,"U"))
	.s subgrpTreeCode=$p(value.SGrpTreeCode,".",1,2)
	.if '$d(treeCodeList(subgrpTreeCode))  s treeCodeList(subgrpTreeCode)=""
	
	/*s num=0
	w "{data:["
	s subgrpId=0 f  s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",id,subgrpId)) q:subgrpId=""  d
	.s subgrpTreeCode=$p($lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),6),".",1,2)
	.q:'$d(treeCodeList(subgrpTreeCode))
	.s num=num+1
	.s subgrpCode=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),2)
	.s subgrpDesc=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),3)
	.s subgrpSort=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),5)
	.s subgrpTreeCode=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),6)
	.s subgrpPTreeCode=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),7)
	.if num'=1 w ","
	.w "{""className"":""DHCWL.MKPI.MMgrModuleCfg"",""ModuleCfgCode"":"_""""_subgrpCode_""""_",""ModuleCfgDesc"":"_""""_subgrpDesc_""""_",""ID"":"_""""_subgrpId_""""_",""ModuleCfgPTreeCode"":"_""""_subgrpPTreeCode_""""_",""ModuleCfgTreeCode"":"_""""_subgrpTreeCode_""""_",""code"":"_""""_subgrpSort_""""_"}"
	w "]}"*/
	s grpId=id
	s num=0
	w "{data:["
		s subgrpId=""
		s mlevel=""
		s num=0
		for{
			s mlevel=$o(^DHCWL.CodeCfg.SubGroupI("GrpLevelSort",grpId,mlevel))
			q:mlevel=""
			s mSort=""
			for{
				//s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpId,subgrpId))
				s mSort=$o(^DHCWL.CodeCfg.SubGroupI("GrpLevelSort",grpId,mlevel,mSort))
				q:mSort=""
				s subgrpId=""
				for{
					s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpLevelSort",grpId,mlevel,mSort,subgrpId))
					q:subgrpId=""
					s mTreeCode=$p($lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),6),".",1,2)
					continue:'$d(treeCodeList(mTreeCode))
					s subgrpCode=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),2)
					s subgrpDesc=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),3)
					s subgrpSort=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),5)
					s subgrpTreeCode=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),6)
					s subgrpPTreeCode=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),7)
					s subgrpLevel=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),8)
					s num=num+1
					if (num>1){
						w ","
					}
					w "{""className"":""DHCWL.CodeCfg.SubGroup"",""CodeCfgGroupCode"":"_""""_subgrpCode_""""_",""CodeCfgGroupDesc"":"_""""_subgrpDesc_""""_",""ID"":"_""""_subgrpId_""""_",""CodeCfgGroupPTreeCode"":"_""""_subgrpPTreeCode_""""_",""CodeCfgGroupTreeCode"":"_""""_subgrpTreeCode_""""_",""code"":"_""""_subgrpSort_""""_",""level"":"_""""_subgrpLevel_""""_"}"
				}
			}
		}
		w "]}"
		q
}

/// Creator：      yuanxu
/// CreatDate：    2014-05-05
/// Description:： 通过分组大类CODE得到组下面的明细
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgSubGroup
/// Input：       
/// Output：      
/// Return：      返回JsonData格式和记录数
/// Others：w ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpListByGrpCode("IPLocGrp")
ClassMethod GetSubGrpListByGrpCode(code) As %String
{
	
	n (code,mPLIST)
	q:code="" 0
	s code=$zcvt(code,"U")
	s count=0
	s subGrpList=""
	s grpId=0 f  s grpId=$o(^DHCWL.CodeCfg.GroupI("Code"," "_code,grpId)) q:grpId=""  d
	.s subgrpId=0 f  s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpId,subgrpId)) q:subgrpId=""  d
	..s count=count+1
	..s value=##class(DHCWL.CodeCfg.SubGroup).%OpenId(subgrpId)
	..s subgrpDesc=value.SGrpDesc
	..s subgrpCode=value.SGrpCode
	..s subgrpSort=value.SGrpSort
	..s subGrpList=subGrpList_"{ID:"_subgrpId_",SGrpCode:'"_subgrpCode_"',SGrpDesc:'"_subgrpDesc_"',SGrpSort:'"_subgrpSort_"'},"
	q subGrpList_"^"_count
}

/// Creator：      yuanxu
/// CreatDate：    2014-05-05
/// Description:： 检查某一分类大组下内容是否加全，未加全的显示出来
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem  DHCWL_CodeCfg.DHCWLCodeCfgSubGroup
/// Input：       
/// Output：      
/// Return：      返回记录数
/// Others：w ##class(DHCWL.CodeCfgData.FunctionModule).CheckStatItem("1")
ClassMethod CheckStatItem(id) As %String
{
	
	n (id)
	k ^TEMPDHCWLCode($j),^TEMPDHCWLCodeCheck($j)
	q:id="" 0
	s row=0
	q:'$d(^DHCWL.CodeCfg.GroupD(id)) 0
	//s typeId=$li(^DHCWL.CodeCfg.GroupD(id),7)
	//s rs=##class(DHCWL.CodeCfg.Type).GetCfgTypeDataById(typeId)
	s typeId=$li(^DHCWL.CodeCfg.GroupD(id),11)
	s rs=##class(DHCWL.CodeCfgData.CodeTypeItemQuery).QryDimValuesByDimType(typeId)
	;s dimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimTypeID),2)
	;s flag=0
	;s:($ZCVT(dimCode,"U")="ARCIM") flag=1
	f num=0:1:rs-1 d
	.s itemDr=$p(^TEMPDHCWLCode($j,num),"^",1)
	.s itemCode=$p(^TEMPDHCWLCode($j,num),"^",2)
	.s itemDesc=$p(^TEMPDHCWLCode($j,num),"^",3)
	.;i (flag=1) d
	..;s hosp=$p(##class(web.DHCBL.CT.ARCItmMast).GetHospInfo("User.ARCItmMast",itemDr),"^",2)
	..;s itemDesc=itemDesc_"^"_hosp
	.s itemDesc=##class(DHCWL.CodeCfgData.FunctionModule).DePecialChar(itemDesc)
	.q:$d(^DHCWL.CodeCfg.SubGroupItemI("Grp",id," "_$ZCVT(itemDr,"U")))
	.s ^TEMPDHCWLCodeCheck($j,row)=itemDr_"^"_itemCode_"^"_itemDesc
	.s row=row+1
	k ^TEMPDHCWLCode($j)
	q $g(row)
}

/// Creator：      wk
/// CreatDate：    2016-11-14
/// Description:： 检查某一分类大组下内容是否加全，未加全的显示出来(统计大组维护界面)
/// Table：       
/// Input：       
/// Output：      
/// Return：      返回记录数
/// Others：w ##class(DHCWL.CodeCfgData.FunctionModule)CheckGroupItem("1")
ClassMethod CheckGroupItem(id) As %String
{
	
	n (id)
	k ^TEMPDHCWLCode($j),^TEMPDHCWLCodeGroupCheck($j)
	q:id="" 0
	s row=0
	q:'$d(^DHCWL.CodeCfg.ItemGroupD(id)) 0
	//s typeId=$li(^DHCWL.CodeCfg.GroupD(id),7)
	//s rs=##class(DHCWL.CodeCfg.Type).GetCfgTypeDataById(typeId)
	s typeId=$list(^DHCWL.CodeCfg.ItemGroupD(id),8)
	s rs=##class(DHCWL.CodeCfgData.CodeTypeItemQuery).QryDimValuesByDimType(typeId)
	f num=0:1:rs-1 d
	.s itemDr=$p(^TEMPDHCWLCode($j,num),"^",1)
	.s itemCode=$p(^TEMPDHCWLCode($j,num),"^",2)
	.s itemDesc=$p(^TEMPDHCWLCode($j,num),"^",3)
	.q:$d(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",id," "_$ZCVT(itemDr,"U")))
	.s itemDesc=##class(DHCWL.CodeCfgData.FunctionModule).DePecialChar(itemDesc)
	.s ^TEMPDHCWLCodeGroupCheck($j,row)=itemDr_"^"_itemCode_"^"_itemDesc
	.s row=row+1
	k ^TEMPDHCWLCode($j)
	q $g(row)
}

/// Creator：      yuanxu
/// CreatDate：    2014-05-05
/// Description:： 通过分组子类ID得到组下面的明细
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem
/// Input：       
/// Output：      
/// Return：      返回JsonData格式和记录数
/// Others：w ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpItemListBySubGrpId("1")
ClassMethod GetSubGrpItemListBySubGrpIdold(subgrpId) As %String
{
	
	n (subgrpId)
	q:subgrpId="" 0
	s count=0
	s subGrpItemList=""
	s subgrpItemId=0 f  s subgrpItemId=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId,subgrpItemId)) q:subgrpItemId=""  d
	.s id=0 f  s id=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId,subgrpItemId,id)) q:id=""  d
	..s count=count+1
	..s grpDr=$list(^DHCWL.CodeCfg.SubGroupItemD(id),4)
	..//s typeDr=$list(^DHCWL.CodeCfg.GroupD(grpDr),7)
	..s typeDr=$list(^DHCWL.CodeCfg.GroupD(grpDr),11)   //取维度ID
	..s itemId=$tr(subgrpItemId," ")
	..//s itemDesc=$p(##class(DHCWL.CodeCfg.Type).GetValueDeseById(typeDr,itemId),"@")
	..s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(typeDr,itemId)
	..s subGrpItemList=subGrpItemList_"{ID:"_id_",ItemDesc:'"_itemDesc_"'},"
	q subGrpItemList_"^"_count
}

/// Creator：      yuanxu
/// CreatDate：    2014-05-05
/// Description:： 通过分组子类ID得到组下面的明细
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem
/// Input：       
/// Output：      
/// Return：      返回JsonData格式和记录数
/// Others：w ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpItemListBySubGrpId("1")
ClassMethod GetSubGrpItemListBySubGrpId(subgrpId) As %String
{
	
	n (subgrpId)
	q:subgrpId="" 0
	s count=0
	s subGrpItemList=""
	s subgrpItemId=0 f  s subgrpItemId=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId,subgrpItemId)) q:subgrpItemId=""  d
	.s id=0 f  s id=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId,subgrpItemId,id)) q:id=""  d
	..s count=count+1
	..s grpDr=$list(^DHCWL.CodeCfg.SubGroupItemD(id),4)
	..//s typeDr=$list(^DHCWL.CodeCfg.GroupD(grpDr),7)
	..s typeDr=$list(^DHCWL.CodeCfg.GroupD(grpDr),11)    //取维度ID
	..s itemId=$tr(subgrpItemId," ")
	..//s itemDesc=$p(##class(DHCWL.CodeCfg.Type).GetValueDeseById(typeDr,itemId),"@")
	..s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(typeDr,itemId)
	..s subGrpItemList=subGrpItemList_"{ID:"_id_",ItemDesc:'"_itemDesc_"'},"
	q subGrpItemList_"^"_count
}

/// Creator：      yuanxu
/// CreatDate：    2014-05-05
/// Description:： 根据大组ID得到分类下的所有内容
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgGroup、DHCWL_CodeCfg.DHCWLCodeCfgType
/// Input：       
/// Output：      
/// Return：      返回JsonData格式和记录数
/// Others：w ##class(DHCWL.CodeCfgData.FunctionModule).GetTypeItemListByGrpId("1")
ClassMethod GetTypeItemListByGrpIdnew(grpId) As %String
{
	
	n (grpId)
	q:grpId="" 0
	s count=0
	s allItemList=""
	//s typeId=$list(^DHCWL.CodeCfg.GroupD(grpId),7)
	//s count=##class(DHCWL.CodeCfg.Type).GetCfgTypeDataById(typeId)
	s typeId=$list(^DHCWL.CodeCfg.GroupD(grpId),11)
	s count=##class(DHCWL.CodeCfgData.CodeTypeItemQuery).QryDimValuesByDimType(typeId)
	//f num=0:1:count-1  d
	//.s itemList=$g(^TEMPDHCWLCode($j,num))
	//.s allItemList=allItemList_"{ID:"_$p(itemList,"^",1)_",ItemCode:'"_$p(itemList,"^",2)_"',ItemDesc:'"_$p(itemList,"^",3)_"'},"
	//k ^TEMPDHCWLCode($j)
	//q allItemList_"^"_count
	q count
}

/// Creator：      yuanxu
/// CreatDate：    2014-05-05
/// Description:： 根据大组ID得到分类下的所有内容
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgGroup、DHCWL_CodeCfg.DHCWLCodeCfgType
/// Input：       
/// Output：      
/// Return：      返回JsonData格式和记录数
/// Others：w ##class(DHCWL.CodeCfgData.FunctionModule).GetTypeItemListByGrpId("1")
ClassMethod GetTypeItemListByGrpId(grpId) As %String
{
	
	n (grpId)
	q:grpId="" 0
	s count=0
	s allItemList=""
	//s typeId=$list(^DHCWL.CodeCfg.GroupD(grpId),7)
	//s count=##class(DHCWL.CodeCfg.Type).GetCfgTypeDataById(typeId)
	s typeId=$list(^DHCWL.CodeCfg.GroupD(grpId),11)
	s count=##class(DHCWL.CodeCfgData.CodeTypeItemQuery).QryDimValuesByDimType(typeId)
	f num=0:1:count-1  d
	.s itemList=$g(^TEMPDHCWLCode($j,num))
	.s allItemList=allItemList_"{ID:"_$p(itemList,"^",1)_",ItemCode:'"_$p(itemList,"^",2)_"',ItemDesc:'"_$p(itemList,"^",3)_"'},"
	k ^TEMPDHCWLCode($j)
	q allItemList_"^"_count
	//q count
}

/// Creator：      yuanxu
/// CreatDate：    2014-06-09
/// Description:： 通过对照项目得到东华HIS对应的ID
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgContrast、DHCWL_CodeCfg.DHCWLCodeCfgType、DHCWL_CodeCfg.DHCWLCodeCfgInterface
/// Input：       
/// Output：      
/// Return：      返回东华HIS
/// Others：w ##class(DHCWL.CodeCfgData.FunctionModule).GetHisIdByInterItemCode("WH","CTLoc","妇科")
ClassMethod GetHisIdByInterItemCode(interCode, typeCode, interItemCode) As %String
{
	
	n (interCode,typeCode,interItemCode)
	s interId=$o(^DHCWL.CodeCfg.InterfaceI("Code"," "_$zcvt(interCode,"U"),""))
	q:interId="" "^"
	s typeId=$o(^DHCWL.CodeCfg.TypeI("Code"," "_$zcvt(typeCode,"U"),""))
	q:typeId="" "^"
	s hisId=$o(^DHCWL.CodeCfg.ContrastI("TypeItem",interId,typeId," "_interItemCode,"")) 
	s hisDesc=$p(##class(DHCWL.CodeCfg.Type).GetValueDeseById(typeId,hisId),"@")
	q $p(hisId," ",2)_"^"_$g(hisDesc)
}

/// Creator：      yuanxu
/// CreatDate：    2014-06-09
/// Description:： 通过某一项目明细ID得到该大组下所属归集名称,目前只支持两层关系的
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgType、
/// Input：       rule:0
/// Output：      
/// Return：      返回归集描述
/// Others：w ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr("4","IPLocGrp","") locgrpgrp IPLocGrp
///         w ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr("4","locgrpgrp","CTLoc")
ClassMethod GetSubGrpByItemDr1(arg) As %String
{
	
	n (arg)
	s dtId=$p(arg,"~",1)
    s grpCode=$p(arg,"~",2)
    s typeCode=$p(arg,"~",3)
	s grpId=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgGrpidByCode(grpCode)
	q:grpId="" ""
	s typeId=$list(^DHCWL.CodeCfg.GroupD(grpId),7)
	s tCode=$list(^DHCWL.CodeCfg.TypeD(typeId),2)
	//w !,grpId ,!
	i (typeCode="")!(tCode=typeCode) d
	.s value=..GetSGrpDrByGrpDr(grpId,dtId)
	e  d
	.s value=..GetSGrpDrByGrpItemDr(grpId,dtId,typeCode)
	q:value="" "NULL"
	s value=$li(^DHCWL.CodeCfg.SubGroupD(value),3)
	q value
}

/// Creator：      yuanxu
/// CreatDate：    2014-06-09
/// Description:： 通过某一项目明细ID得到该大组下所属归集名称,目前只支持两层关系的
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgType、
/// Input：       rule:0
/// Output：      
/// Return：      返回归集描述
/// Others：w ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr("4","IPLocGrp","") locgrpgrp IPLocGrp
///         w ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr("4","locgrpgrp","CTLoc")
ClassMethod GetSubGrpByItemDrold(dtId, grpCode, typeCode = "") As %String
{
	
	n (grpCode,dtId,typeCode)
	s grpId=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgGrpidByCode(grpCode)
	q:grpId="" ""
	s typeId=$list(^DHCWL.CodeCfg.GroupD(grpId),7)
	s tCode=$list(^DHCWL.CodeCfg.TypeD(typeId),2)
	//w !,grpId ,!
	i (typeCode="")!(tCode=typeCode) d
	.s value=..GetSGrpDrByGrpDr(grpId,dtId)
	e  d
	.s value=..GetSGrpDrByGrpItemDr(grpId,dtId,typeCode)
	q:value="" "NULL"
	s desc=$li(^DHCWL.CodeCfg.SubGroupD(value),3)
	s code=$li(^DHCWL.CodeCfg.SubGroupD(value),2)
	s seq=$li(^DHCWL.CodeCfg.SubGroupD(value),5)
	
	q desc_"^"_code_"^"_seq
}

/// Creator：      yuanxu
/// CreatDate：    2014-06-09
/// Description:： 通过某一项目明细ID得到该大组下所属归集名称,目前只支持两层关系的
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgType、
/// Input：       rule:0
/// Output：      
/// Return：      返回归集描述^代码^顺序
/// Others：w ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr("10","ACCItemGrp","") locgrpgrp IPLocGrp
///         w ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr("10","ACCItemGrp","CTLOC")
ClassMethod GetSubGrpByItemDr(dtId, grpCode, typeCode = "") As %String
{
	
	n (grpCode,dtId,typeCode,mode)
	s grpId=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgGrpidByCode(grpCode)
	q:grpId="" ""
	//s typeId=$list(^DHCWL.CodeCfg.GroupD(grpId),7)
	//s tCode=$list(^DHCWL.CodeCfg.TypeD(typeId),2)
	s typeId=$list(^DHCWL.CodeCfg.GroupD(grpId),11)
	q:typeId="" ""
	s tCode=$list(^DHCWL.MKPI.MKPIDimTypeD(typeId),2)
	//w !,grpId ,!
	i (typeCode="")!(tCode=typeCode) d
	.s value=..GetSGrpDrByGrpDr(grpId,dtId)
	e  d
	.s value=..GetSGrpDrByGrpItemDr(grpId,dtId,typeCode)
	q:value="" "NULL"
	s desc=$li(^DHCWL.CodeCfg.SubGroupD(value),3)
	s code=$li(^DHCWL.CodeCfg.SubGroupD(value),2)
	s treeCode=$li(^DHCWL.CodeCfg.SubGroupD(value),6)
	s treeLen=$l(treeCode,".")
	s treeCode=$p(treeCode,".",2,treeLen)
	s mgrpDescS=""
	for i=1:1:(treeLen-1){
		s mgrpCode=$p(treeCode,".",i)
		if (mgrpCode=""){
			s mgrpDesc=""
		}else{
			s mID=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgSGrpidByCode(grpId,mgrpCode)
			s mgrpDesc=$li(^DHCWL.CodeCfg.SubGroupD(mID),3)
		}
		if (mgrpDescS=""){
			s mgrpDescS=mgrpDesc
		}else{
			s mgrpDescS=mgrpDescS_"."_mgrpDesc
		}
	}
	//s seq=$li(^DHCWL.CodeCfg.SubGroupD(value),5)
	s seq=##class(DHCWL.CodeCfgData.FunctionModule).GetCountLevel(grpId,value)
	s level=$li(^DHCWL.CodeCfg.SubGroupD(value),8)
	
	/*if (mode="W"){
		s treeCode=$li(^DHCWL.CodeCfg.SubGroupD(value),6)
		s pTreeCode=$li(^DHCWL.CodeCfg.SubGroupD(value),7)
		s level=$li(^DHCWL.CodeCfg.SubGroupD(value),8)
		q desc_"^"_code_"^"_seq_"^"_level_"^"_treeCode_"^"_pTreeCode
	}else{
		q desc_"^"_code_"^"_seq
	}*/
	q mgrpDescS_"^"_treeCode_"^"_seq_"^"_level
}

ClassMethod GetSGrpDrByGrpDr(grpId, dtId) As %String
{
	
	q:'$d(^DHCWL.CodeCfg.SubGroupItemI("Grp",grpId," "_dtId)) ""
	s id=0 f  s id=$o(^DHCWL.CodeCfg.SubGroupItemI("Grp",grpId," "_dtId,id)) q:id=""  d
	.s sGrpDr=$list(^DHCWL.CodeCfg.SubGroupItemD(id),3)
	q sGrpDr
}

ClassMethod GetSGrpDrByGrpItemDr(grpId, dtDr, typeCode) As %String
{
	n (grpId,dtDr,typeCode)
	//q:'$d(^DHCWL.CodeCfg.TypeI("Code"," "_$zcvt(typeCode,"U"))) "Null"
	q:'$d(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$zcvt(typeCode,"U"))) "Null"
	s flag=0,num=0
	s index(num)=grpId
	f  q:flag=1  d
	.s isValid=$$GetTypeByGrpCode(grpId,typeCode)
	.i isValid=1 s flag=1 q
	.s detId=$$GetDetailsIdByGrpCode(grpId)
	.s grpId=0 s grpId=$li(^DHCWL.CodeCfg.SubGroupD(detId),4)
	.s num=num+1
	.s index(num)=grpId
	
	s num="" f  s num=$o(index(num),-1) q:num=""  d
	.q:dtDr=""
	.s grpId=index(num)
	.s retId=$o(^DHCWL.CodeCfg.SubGroupItemI("Grp",grpId," "_dtDr,"")) 
	.i retId="" s dtDr=""
	.e  s dtDr=$li(^DHCWL.CodeCfg.SubGroupItemD(retId),3)
	
	q $g(dtDr)
	
GetTypeByGrpCode(grpId,typeCode)
	//s typeId=$list(^DHCWL.CodeCfg.GroupD(grpId),7)
	//s tCode=$list(^DHCWL.CodeCfg.TypeD(typeId),2)
	s typeId=$list(^DHCWL.CodeCfg.GroupD(grpId),11)
	s tCode=$list(^DHCWL.MKPI.MKPIDimTypeD(typeId),2)
	q:tCode'=typeCode 0
	q 1

GetDetailsIdByGrpCode(grpId)
	;b	//3
	s dtId=0 s dtId=$o(^DHCWL.CodeCfg.SubGroupItemI("Grp",grpId,dtId)) 
	q $p(dtId," ",2)
}

/// Creator：      yuanxu
/// CreatDate：    2014-07-04
/// Description:： 把CS系统下的统计项目配置中的内容迁移到BS代码维护中
/// Table：       
/// Input：       
/// Output：      
/// Return：      
/// Others：      w ##class(DHCWL.CodeCfgData.FunctionModule).CSItemToBS("YY")
ClassMethod CSItemToBS(hos) As %String
{
	n (hos)
	k ^TEMPDHCWL($j)
	s statId=0 f  s statId=$o(^DHCWLSTAT(statId)) q:statId=""  d
	.s statDes=$p(^DHCWLSTAT(statId),"^",2)
	.s statType=$p(^DHCWLSTAT(statId),"^",4)
	.s piece=$$GetStatPiece(statType)
	.s stitId=0 f  s stitId=$o(^DHCWLSTAT(statId,"ITEM",stitId)) q:stitId=""  d
	..s stitDes=$p(^DHCWLSTAT(statId,"ITEM",stitId),"^",2)
	..s stdtId=0 f  s stdtId=$o(^DHCWLSTAT(statId,"ITEM",stitId,"DETAIL",stdtId)) q:stdtId=""  d
	...s itemId=$p(^DHCWLSTAT(statId,"ITEM",stitId,"DETAIL",stdtId),"^",piece)
	...s ^TEMPDHCWL($j,statType,statDes,stitDes,itemId)=itemId
	
	s num=1
	s date=+$h
	s stType=0 f  s stType=$o(^TEMPDHCWL($j,stType)) q:stType=""  d
	.s BSCodeType=$$SetCSTypeToBS(stType)
	.s codeTypeId=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgidByCode(BSCodeType)
	.q:codeTypeId=""
	.s grpDesc=0 f  s grpDesc=$o(^TEMPDHCWL($j,stType,grpDesc)) q:grpDesc=""  d
	..//q:$d(^DHCWLCodeLog(grpDesc))
	..s grpCode=hos_"WLStat"_num
	..s num=num+1
	..&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgGroup(Grp_Code,Grp_Desc,grp_type_dr,Grp_CreateUse,Grp_CreateDate) VALUES(:grpCode,:grpDesc,:codeTypeId,"demo",:date))
	..s grpId=+$g(%ROWID)
	..s count=1
	..s sgrpDesc=0 f  s sgrpDesc=$o(^TEMPDHCWL($j,stType,grpDesc,sgrpDesc)) q:sgrpDesc=""  d
	...s sgrpCode=hos_count
	...s sort=count
	...s count=count+1
	...&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgSubGroup(SGrp_Code,SGrp_Desc,SGrp_Grp_Dr,SGrp_Sort) VALUES(:sgrpCode,:sgrpDesc,:grpId,:sort))
	...s sgrpId=+$g(%ROWID)
	...s dtId=0 f  s dtId=$o(^TEMPDHCWL($j,stType,grpDesc,sgrpDesc,dtId)) q:dtId=""  d
	....&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem(SGrpIM_Grp_Dr,SGrpIM_SGrp_Dr,SGrpIM_Item_DR) VALUES(:grpId,:sgrpId,:dtId))
	....w grpCode_"^"_grpDesc_"^"_sgrpCode_"^"_sgrpDesc_"^"_dtId,!
	....s ^DHCWLCodeLog(grpDesc,stType)=1
    k ^TEMPDHCWL($j)
    q num
    
	///Description:   根据统计项目的类型返回取统计项目明细的那个字段
	///Table?        DHCWL_STDetail
	///Input?        statType:统计项目的类型
	///Output?                
	///Return?       statPiece:返回统计项目明细对应那个字段的global位置
	///Others?
GetStatPiece(statType)
	        i statType="IC" d
	        .s statPiece=3
	        i statType="IM" d
	        .s statPiece=4
	        i statType="BG" d
	        .s statPiece=1
	        i statType="BS" d
	        .s statPiece=2
	        i statType="TM" d
	        .s statPiece=5
	        i statType="TMC" d
	        .s statPiece=9
	        i statType="TEC" d
	        .s statPiece=7
	        i statType="TIC" d
	        .s statPiece=8
	        i statType="TOC" d
	        .s statPiece=10
	        i statType="TSC" d
	        .s statPiece=11
	        i statType="TAC" d
	        .s statPiece=6
	        ;***************************
	        q $g(statPiece)

SetCSTypeToBS(type)
            i type="IC" d
	        .s codeType="ARCIC"
	        i type="IM" d
	        .s codeType="ARCIM"
	        i type="BG" d
	        .s codeType="ARCBG"
	        i type="BS" d
	        .s codeType="ARCSG"
	        i type="TM" d
	        .s codeType="TARI"
	        i type="TMC" d
	        .s codeType="TARMC"
	        i type="TEC" d
	        .s codeType="TAREC"
	        i type="TIC" d
	        .s codeType="TARIC"
	        i type="TOC" d
	        .s codeType="TAROC"
	        i type="TSC" d
	        .s codeType="TARSC"
	        i type="TAC" d
	        .s codeType="TARAC"
	        i type="O" d
	        .s codeType="CTDoc"
	        i (type="S")!(type="E") d
	        .s codeType="CTLoc"
	        ;***************************
	        q $g(codeType)
}

/// Creator：      yuanxu
/// CreatDate：    2014-07-04
/// Description:： 把CS系统下的科室子组配置中的内容迁移到BS代码维护中
/// Table：       DHC_WLCFG_Group  DHC_WLCFG_SubGroup  DHC_WLCFGR_SubGrpDep DHC_WLCFGR_SubGrpDoc DHC_WLCFGR_GrpDep
///               O-医生    S-科室子组   E-科室组
/// Input：       
/// Output：      
/// Return：      
/// Others：      w ##class(DHCWL.CodeCfgData.FunctionModule).CSDepGrpToBS("YY")
ClassMethod CSDepGrpToBS(hos) As %String
{
	n (hos)
	k ^TEMPDHCWL($j)
	s cfgGrpId=0 f  s cfgGrpId=$o(^DHCWLCFG("GRP",cfgGrpId)) q:cfgGrpId=""  d
	.q:$d(^DHCWLCFG("GRP",cfgGrpId))=10
	.s grpDesc=$p(^DHCWLCFG("GRP",cfgGrpId),"^",2)
	.s grpType=$p(^DHCWLCFG("GRP",cfgGrpId),"^",4)
	.i grpType="E" d
	..s itemDr=0 f  s itemDr=$o(^DHCWLCFGR("GRPDEPCTLOC",cfgGrpId,itemDr)) q:itemDr=""  d
	...s ^TEMPDHCWL($j,"G",grpType,grpDesc,itemDr)=itemDr
	.s sgrpId=0 f  s sgrpId=$o(^DHCWLCFG("GRP",cfgGrpId,"SUBGRP",sgrpId)) q:sgrpId=""  d
	..s sgrpDesc=$p(^DHCWLCFG("GRP",cfgGrpId,"SUBGRP",sgrpId),"^",2)
	..i grpType="O" s subtype="SUBGRPDOC",piece=2
	..i grpType="S" s subtype="SUBGRPDEP",piece=3
	..i (grpType="O")!(grpType="S") d
	...s sgrpDepId=0 f  s sgrpDepId=$o(^DHCWLCFGR(subtype,"SUBGRP",cfgGrpId_"||"_sgrpId,sgrpDepId)) q:sgrpDepId=""  d
	....s itemDr=$p(^DHCWLCFGR(subtype,sgrpDepId),"^",piece)
	....s ^TEMPDHCWL($j,"SG",grpType,grpDesc,sgrpDesc,itemDr)=itemDr
	
	s num=1
	s date=+$h
	s stType=0 f  s stType=$o(^TEMPDHCWL($j,"SG",stType)) q:stType=""  d
	.s BSCodeType=$$SetCSTypeToBS(stType)
	.s codeTypeId=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgidByCode(BSCodeType)
	.q:codeTypeId=""
	.s grpDesc=0 f  s grpDesc=$o(^TEMPDHCWL($j,"SG",stType,grpDesc)) q:grpDesc=""  d
	..//q:$d(^DHCWLCodeLog(grpDesc))
	..i stType="S" s grpCode=hos_"WLLOC"_num
	..i stType="O" s grpCode=hos_"WLDOC"_num
	..s num=num+1
	..&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgGroup(Grp_Code,Grp_Desc,grp_type_dr,Grp_CreateUse,Grp_CreateDate) VALUES(:grpCode,:grpDesc,:codeTypeId,"demo",:date))
	..s grpId=+$g(%ROWID)
	..s count=1
	..s sgrpDesc=0 f  s sgrpDesc=$o(^TEMPDHCWL($j,"SG",stType,grpDesc,sgrpDesc)) q:sgrpDesc=""  d
	...s sgrpCode=hos_count
	...s sort=count
	...s count=count+1
	...&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgSubGroup(SGrp_Code,SGrp_Desc,SGrp_Grp_Dr,SGrp_Sort) VALUES(:sgrpCode,:sgrpDesc,:grpId,:sort))
	...s sgrpId=+$g(%ROWID)
	...s dtId=0 f  s dtId=$o(^TEMPDHCWL($j,"SG",stType,grpDesc,sgrpDesc,dtId)) q:dtId=""  d
	....&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem(SGrpIM_Grp_Dr,SGrpIM_SGrp_Dr,SGrpIM_Item_DR) VALUES(:grpId,:sgrpId,:dtId))
	....w grpCode_"^"_grpDesc_"^"_sgrpCode_"^"_sgrpDesc_"^"_dtId,!
	....s ^DHCWLCodeLog(grpDesc,stType)=1
    
    s numG=1
    s stType=0 f  s stType=$o(^TEMPDHCWL($j,"G",stType)) q:stType=""  d
    .s BSCodeType=$$SetCSTypeToBS(stType)
	.s codeTypeId=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgidByCode(BSCodeType)
	.q:codeTypeId=""
	.s grpDesc=0 f  s grpDesc=$o(^TEMPDHCWL($j,"G",stType,grpDesc)) q:grpDesc=""  d
	..s grpCode=hos_"WLLocGrp"_numG
	..s numG=numG+1
	..&sql(insert into DHCWL_CodeCfg.DHCWLCodeCfgItemGroup(ItemGrp_Code,ItemGrp_Desc,ItemGrp_Type_Dr,ItemGrp_CreateDate,ItemGrp_CreateUse) values (:grpCode,:grpDesc,:codeTypeId,:date,"demo"))
	..s grpId=+$g(%ROWID)
	..s sort=0
	..s dtId=0 f  s dtId=$o(^TEMPDHCWL($j,"G",stType,grpDesc,dtId)) q:dtId=""  d
	...s sort=sort+1
	...&sql(insert into DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails(ItmGrpDet_Grp_Dr,ItmGrpDet_Item_DR,ItmGrpDet_Sort) values (:grpId,:dtId,:sort))
    
    k ^TEMPDHCWL($j)
    
	q num+numG
}

/// Creator：      yuanxu
/// CreatDate：    2015-6-10
/// Description:： 导入其他系统对照内容做为子组条目
/// Table：       DHC_WLCFG_Group  DHC_WLCFG_SubGroup  DHC_WLCFGR_SubGrpDep DHC_WLCFGR_SubGrpDoc DHC_WLCFGR_GrpDep
///               ^DHCWLContrast("类型",num)=值
/// Input：       
/// Output：      
/// Return：      
/// Others：      w ##class(DHCWL.CodeCfgData.FunctionModule).ImportContrast()
ClassMethod ImportContrast() As %String
{
    n
    s date=+$h,retsqlcode=0
    s CodeType=0 f  s CodeType=$o(^DHCWLContrast(CodeType)) q:CodeType=""  d
    .s codeTypeId=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgidByCode(CodeType)
	.q:codeTypeId=""
	.s codeTypeDesc=$li(^DHCWL.CodeCfg.TypeD(codeTypeId),6)_"对照"
	.//q:$d(^DHCWLCodeLog(grpDesc))
	.s grpCode=CodeType_"Grp"
	.&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgGroup(Grp_Code,Grp_Desc,grp_type_dr,Grp_CreateUse,Grp_CreateDate) VALUES(:grpCode,:codeTypeDesc,:codeTypeId,"demo",:date))
	.s retsqlcode=SQLCODE
	.s grpId=+$g(%ROWID)
	.s count=1
	.s num=0 f  s num=$o(^DHCWLContrast(CodeType,num)) q:num=""  d
	..s sgrpCode=$p(^DHCWLContrast(CodeType,num),"^",1)
	..s sgrpDesc=$p(^DHCWLContrast(CodeType,num),"^",2)
	..s sort=count
	..s count=count+1
	..&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgSubGroup(SGrp_Code,SGrp_Desc,SGrp_Grp_Dr,SGrp_Sort) VALUES(:sgrpCode,:sgrpDesc,:grpId,:sort))
    ..s retsqlcode=$g(retsqlcode)+SQLCODE
    q retsqlcode
}

/// Creator：      yuanxu
/// CreatDate：    2015-6-10
/// Description:： 导出类型内容
/// Table：       
///               ^DHCWLCodeCfgTypeExport=typecode_"$"_desc_"$"_flag_"$"_extcode_"$"_valuedes_"$"_createuse
/// Input：       codestr为空默认全部  codestr="CTLoc^CTDoc^TAREC"
/// Output：      
/// Return：      
/// Others：      w ##class(DHCWL.CodeCfgData.FunctionModule).ExportType("")
ClassMethod ExportType(codestr = "") As %String
{
    n (codestr)
    k ^DHCWLCodeCfgTypeExport
    //s File="d:\ExportType.txt"
    ;s File="/hisdata/ExportType.txt"  //根据项目服务器地址改路径
    //o File:"WNS"
    //u File
    w "code$desc$flag$extcode$valuedes$createuse",!
    s len=$l(codestr,"^")
    s id=0 f  s id=$o(^DHCWL.CodeCfg.TypeD(id)) q:id=""  d
    .s typecode=$li(^DHCWL.CodeCfg.TypeD(id),2)
    .f i=1:1:len d
    ..s code=$p(codestr,"^",i)
    ..q:(codestr'="")&(typecode'=code)
    ..s desc=$li(^DHCWL.CodeCfg.TypeD(id),6)
    ..s flag=$li(^DHCWL.CodeCfg.TypeD(id),8)
    ..s extcode=$li(^DHCWL.CodeCfg.TypeD(id),7)
    ..s valuedes=$li(^DHCWL.CodeCfg.TypeD(id),9)
    ..s createuse=$li(^DHCWL.CodeCfg.TypeD(id),5)
    ..s ^DHCWLCodeCfgTypeExport(id)=typecode_"$"_desc_"$"_flag_"$"_extcode_"$"_valuedes_"$"_createuse
    ..w typecode_"$"_desc_"$"_flag_"$"_extcode_"$"_valuedes_"$"_createuse,!
    //c File
    q 1
}

/// Creator：      yuanxu
/// CreatDate：    2015-6-10
/// Description:： 导入类型内容
/// Table：       ^DHCWLCodeCfgTypeExport=typecode_"$"_desc_"$"_flag_"$"_extcode_"$"_valuedes_"$"_createuse
///               
/// Input：       
/// Output：      
/// Return：      
/// Others：      w ##class(DHCWL.CodeCfgData.FunctionModule).ImportType()
ClassMethod ImportType() As %String
{
    n
    s date=+$h,retsqlcode=0
    s id="" f  s id=$o(^DHCWLCodeCfgTypeExport(id)) q:id=""  d
	.s code=$p(^DHCWLCodeCfgTypeExport(id),"$",1)
	.q:$d(^DHCWL.CodeCfg.TypeI("Code"," "_$zcvt(code,"U")))
	.s desc=$p(^DHCWLCodeCfgTypeExport(id),"$",2)
	.s flag=$p(^DHCWLCodeCfgTypeExport(id),"$",3)
	.s extcode=$p(^DHCWLCodeCfgTypeExport(id),"$",4)
	.s valuedes=$p(^DHCWLCodeCfgTypeExport(id),"$",5)
	.s createuse=$p(^DHCWLCodeCfgTypeExport(id),"$",6)
	.&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgType(Type_Code,Type_Desc,Type_Flag,Type_ExtCode,Type_ValueDes,Type_CreateUse,Type_CreateDate) VALUES(:code,:desc,:flag,:extcode,:valuedes,:createuse,:date))
	.s retsqlcode=SQLCODE
    q retsqlcode
}

/// Creator：      yuanxu
/// CreatDate：    2015-6-10
/// Description:： 导出大组子组内容
/// Table：       s ^DHCWLCodeCfgGrpExport(typecode_"^"_grpcode_"^"_grpdesc,sort)=subgrpcode_"^"_subgrpdesc
///               
/// Input：       codestr为空默认全部  codestr="CTLoc^CTDoc^TAREC"
/// Output：      
/// Return：      
/// Others：      d ##class(DHCWL.CodeCfgData.FunctionModule).ExportGrp("")
ClassMethod ExportGrp(codestr = "") As %String
{
    n (codestr)
    k ^DHCWLCodeCfgGrpExport
    //s File="d:\ExportGrp.txt"
    ;s File="/hisdata/ExportGrp.txt"  //根据项目服务器地址改路径
    //o File:"WNS"
    //u File
    //w "code$desc$flag$extcode$valuedes$createuse",!
    s len=$l(codestr,"^")
    s id=0 f  s id=$o(^DHCWL.CodeCfg.GroupD(id)) q:id=""  d
    .s grpcode=$li(^DHCWL.CodeCfg.GroupD(id),2)
    .f i=1:1:len d
    ..s code=$p(codestr,"^",i)
    ..q:(codestr'="")&(grpcode'=code)
    ..s grpdesc=$li(^DHCWL.CodeCfg.GroupD(id),3)
    ..s typedr=$li(^DHCWL.CodeCfg.GroupD(id),7)
    ..q:'$d(^DHCWL.CodeCfg.TypeD(typedr))
    ..s typecode=$li(^DHCWL.CodeCfg.TypeD(typedr),2)
    ..s subgrpid=0 f  s subgrpid=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",id,subgrpid)) q:subgrpid=""  d
    ...s subgrpcode=$li(^DHCWL.CodeCfg.SubGroupD(subgrpid),2)
    ...s subgrpdesc=$li(^DHCWL.CodeCfg.SubGroupD(subgrpid),3)
    ...s sort=$li(^DHCWL.CodeCfg.SubGroupD(subgrpid),5)
    ...//s ^DHCWLCodeCfgExport(grpcode,grpdesc,typecode,subgrpcode,subgrpdesc,sort)=sort
    ...s ^DHCWLCodeCfgGrpExport(typecode_"^"_grpcode_"^"_grpdesc,sort)=subgrpcode_"^"_subgrpdesc
    ...//w grpcode_"$"_grpdesc_"$"_typecode_"$"_subgrpcode_"$"_subgrpdesc_"$"_sort,!
    //c File
    q
}

/// Creator：      yuanxu
/// CreatDate：    2015-6-10
/// Description:： 导入大组子组内容
/// Table：        ^DHCWLCodeCfgGrpExport(typecode_"^"_grpcode_"^"_grpdesc,sort)=subgrpcode_"^"_subgrpdesc
///               
/// Input：       
/// Output：      
/// Return：      
/// Others：      d ##class(DHCWL.CodeCfgData.FunctionModule).ImportGrp("")
ClassMethod ImportGrp() As %String
{
    n
    s date=+$h,retsqlcode=0
    s CodeType="" f  s CodeType=$o(^DHCWLCodeCfgGrpExport(CodeType)) q:CodeType=""  d
    .s codeTypeId=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgidByCode($p(CodeType,"^"))
	.q:codeTypeId=""
	.s grpDesc=$p(CodeType,"^",3)_"对照"
	.//q:$d(^DHCWLCodeLog(grpDesc))
	.s grpCode=$p(CodeType,"^",2)
	.q:$d(^DHCWL.CodeCfg.GroupI("Code"," "_$zcvt(grpCode,"U")))
	.&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgGroup(Grp_Code,Grp_Desc,grp_type_dr,Grp_CreateUse,Grp_CreateDate) VALUES(:grpCode,:grpDesc,:codeTypeId,"demo",:date))
	.s retsqlcode=SQLCODE
	.s grpId=+$g(%ROWID)
	.s count=1
	.s num=0 f  s num=$o(^DHCWLCodeCfgGrpExport(CodeType,num)) q:num=""  d
	..s sgrpCode=$p(^DHCWLCodeCfgGrpExport(CodeType,num),"^",1)
	..s sgrpDesc=$p(^DHCWLCodeCfgGrpExport(CodeType,num),"^",2)
	..s sort=count
	..s count=count+1
	..&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgSubGroup(SGrp_Code,SGrp_Desc,SGrp_Grp_Dr,SGrp_Sort) VALUES(:sgrpCode,:sgrpDesc,:grpId,:num))
    ..s retsqlcode=$g(retsqlcode)+SQLCODE
    q retsqlcode
}

/// Creator：      yuanxu
/// CreatDate：    2015-10-30
/// Description:： 判断明细记录是否在统计大组中
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails
/// Input：       
/// Output：      
/// Return：      返回0不存在，1存在
/// Others：w ##class(DHCWL.CodeCfgData.FunctionModule).ItemYoNByGrpCode("test","3")
ClassMethod ItemYoNByGrpCode(grpCode, dtId) As %String
{
	
	n (grpCode,dtId)
	s flag=0
	q:grpCode="" flag
    q:'$d(^DHCWL.CodeCfg.ItemGroupI("Code"," "_$zcvt(grpCode,"U"))) flag
    s grpId=$o(^DHCWL.CodeCfg.ItemGroupI("Code"," "_$zcvt(grpCode,"U"),""))
    i $d(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",grpId," "_dtId)) s flag=1
    e  s flag=0
	q flag
}

/// Creator：      yuanxu
/// CreatDate：    2015-10-30
/// Description:： 取明细记录在大组中的顺序
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails
/// Input：       dtId：明细ID、grpCode：统计大组
/// Output：      
/// Return：      返回顺序，如果明细不在此组中返Null
/// Others：w ##class(DHCWL.CodeCfgData.FunctionModule).GetSortByGrpItemDr("3","test")
ClassMethod GetSortByGrpItemDr(dtId, grpCode) As %String
{
	
	n (dtId,grpCode)
	s sort="Null"
	q:grpCode="" sort
	q:dtId="" sort
    q:'$d(^DHCWL.CodeCfg.ItemGroupI("Code"," "_$zcvt(grpCode,"U"))) sort
    s grpId=$o(^DHCWL.CodeCfg.ItemGroupI("Code"," "_$zcvt(grpCode,"U"),""))
    s id=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",grpId," "_dtId,""))
    q:'$d(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",grpId," "_dtId)) sort
    s sort=$$GetItemGrpSortById^DHCWLCodeCFGFunctionModule(id)
	q sort
}

/// Creator：      yuanxu
/// CreatDate：    2016-1-14
/// Description:： 根据维度取出该维度下的大组或子组
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgGroup  DHCWL_CodeCfg.DHCWLCodeCfgItemGroup
/// Input：       dimCode:维度类型CODE type:G大组;SG子组
/// Output：      id,Code,Desc
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.CodeCfgData.FunctionModule","GetGrpListByDimCode","TarEC","G")
/// 
Query GetGrpListByDimCode(dimCode As %String, type As %String) As %Query(ROWSPEC = "id:%String,Code:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod GetGrpListByDimCodeExecute(ByRef qHandle As %Binary, dimCode As %String, type As %String) As %Status
{
	n (qHandle,dimCode,type)
 	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
    s ind=1
    
	q:(dimCode="")!(type="") $$$OK
	s dimId=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$ZCVT(dimCode,"U"),""))
	q:dimId="" $$$OK
	if type="SG" {
		s id="" f  s id=$o(^DHCWL.CodeCfg.GroupI("DimDr",dimId,id)) q:id=""  d
		.s Code=$li(^DHCWL.CodeCfg.GroupD(id),2)
		.s Desc=$li(^DHCWL.CodeCfg.GroupD(id),3)
		.d OutPutRow
	}
	if type="G" {
		s id="" f  s id=$o(^DHCWL.CodeCfg.ItemGroupI("DimDr",dimId,id)) q:id=""  d
		.s Code=$li(^DHCWL.CodeCfg.ItemGroupD(id),2)
		.s Desc=$li(^DHCWL.CodeCfg.ItemGroupD(id),3)
		.d OutPutRow
	}
	;d rs.Close()
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPutRow
	s Data=$lb(id,Code,Desc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod GetGrpListByDimCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGrpListByDimCodeExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetGrpListByDimCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGrpListByDimCodeExecute ]
{
	n (AtEnd,qHandle,Row)
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

/// Creator：      wk
/// CreatDate：    2016-11-17
/// Description:： 保存统计项
/// Table：       DHCWL_CodeCfg.SubGroup
/// Input：       grpId:统计大组ID code:统计项code desc:统计项描述;groupCode:父节点
/// Output：      1,0
/// Return：      
/// Others：d ##class(DHCWL.CodeCfgData.FunctionModule).SaveSubGroup(1,"cs2","ff","root.cs")
/// 
ClassMethod SaveSubGroup(grpId, code, desc, groupCode) As %Integer
{
	n (grpId,code,desc,groupCode,%session)
	s id=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgSGrpidByCode(grpId,code)
	i id'="" q -2
	s result=##class(DHCWL.CodeCfgData.FunctionModule).subGrpCheckItem(grpId,groupCode,code)
	if result=0 q -1
	if result=-1 q -2
	s subgrpId=""
	s signSort=0
	for{
		s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpPTreeCode",grpId," "_$zcvt(groupCode,"U"),subgrpId))
		q:subgrpId=""
		s sort=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),5)
		if (sort'="")&(sort>signSort){
			s signSort=sort
		}
	}
	s signSort=signSort+1
	set subGroupObj=##class(DHCWL.CodeCfg.SubGroup).%New()
	if subGroupObj=""{
		q 0
	}
	set groupObj=##class(DHCWL.CodeCfg.Group).%OpenId(grpId)
	if groupObj=""{
		q 0
	}
	s subGroupObj.SGrpCode=code
	s subGroupObj.SGrpDesc=desc
	s subGroupObj.SGrpGrpDr=groupObj
	s subGroupObj.SGrpPTreeCode=groupCode
	s subGroupObj.SGrpSort=signSort
	s subGroupObj.SGrpTreeCode=groupCode_"."_code
	s subGroupObj.SGrpLevel=$l(groupCode,".")
	s result=subGroupObj.%Save()
	if result'=1{
		q 0
	}
	//add by wk~2017-06-14~将信息保存到日志表中
	k dimLogList
	s level=$l(groupCode,".")
	s treeCode=groupCode_"."_code
	s id=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgSGrpidByCode(grpId,code)
	s dimLogList("operType")="新增"
	s dimLogList("modType")="归集子组"
	s dimLogList("depMod")=$lg($g(^DHCWL.CodeCfg.GroupD(grpId)),2)_":"_$lg($g(^DHCWL.CodeCfg.GroupD(grpId)),3)_"."_code_":"_desc
	s dimLogList("GrpModAttr")="编码:"_code_","_"描述:"_desc_","_"排序值:"_signSort_","_"当前节点:"_$p(treeCode,".",2,$l(treeCode,"."))_","_"父节点:"_$p(groupCode,".",2,$l(groupCode,"."))_","_"层级:"_level
	;s dimLogList("LogHeader")="ID"_"&"_"编码"_"&"_"描述"_"&"_"排序值"_"&"_"当前节点"_"&"_"父节点"_"&"_"层级"
	;s dimLogList("LogInfor")="#"_id_"&#"_code_"&#"_desc_"&#"_signSort_"&#"_treeCode_"&#"_groupCode_"&#"_level
	s sc=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList)
	q 1
}

/// Creator：      wk
/// CreatDate：    2016-11-24
/// Description:： 检查同级下有没有子节点
/// Table：       DHCWL_CodeCfg.SubGroup
/// Input：       grpId:统计大组ID groupCode:父节点
/// Output：      1,0
/// Return：      
/// Others：d ##class(DHCWL.CodeCfgData.FunctionModule).subGrpCheckItem(1,1)
ClassMethod subGrpCheckItem(grpId, groupCode, code) As %Integer
{
	n (grpId,groupCode,code)
	s level=$l(groupCode,".")-1
	s codeTestLevel=level+1
	s subGrpId=""
	s errorFlag=0
	for{
		s subGrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpLevel",grpId,codeTestLevel,subGrpId))
		q:subGrpId=""
		s codeExsit=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpId),2)
		if (codeExsit=code){
			s errorFlag=1
			q
		}
	}
	if (errorFlag=1){
		q -1
	}
	
	s subGrpId=""
	s errorFlag=0
	for{
		s subGrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpLevel",grpId,level,subGrpId))
		q:subGrpId=""
		if ($d(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subGrpId))){
			s errorFlag=1
			q
		}
	}
	if (errorFlag=1){
		q 0
	}else{
		q 1
	}
}

/// Creator：      wk
/// CreatDate：    2016-11-17
/// Description:： 获取树是否维护正确的树信息
/// Table：       DHCWL_CodeCfg.SubGroup
/// Input：       grpId:统计大组ID code:统计项code desc:统计项描述;groupCode:父节点
/// Output：      1,0
/// Return：      
/// Others：d ##class(DHCWL.CodeCfgData.FunctionModule).SaveSubGroup(1,"cs2","ff","root.cs")
/// 
ClassMethod GetCheckGroupTree(grpId)
{
	n (grpId)
	s sign=""
	s subgrpId=""
	k subgrpTreeList
	for{
		s sign=$o(^DHCWL.CodeCfg.SubGroupI("GrpLevel",grpId,sign))
		q:sign=""
		s pTreeSign=-1
		s errorSign=-1
		k treeGroupList
		for{
			s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpLevel",grpId,sign,subgrpId))
			q:subgrpId=""
			s subgrpTreeCode=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),6)
			if ($d(^DHCWL.CodeCfg.SubGroupI("GrpPTreeCode",grpId," "_$zcvt(subgrpTreeCode,"U")))){
				if (pTreeSign'=0){
					s pTreeSign=1
				}else{
					s errorSign=1
				}
			}else{
				if (pTreeSign'=1){
					s pTreeSign=0
				}else{
					s errorSign=1
				}
				s treeGroupList(subgrpTreeCode)=0
			}
		}
		if (errorSign=1){
			s subGrpTreeCode=""
			for {
				s subGrpTreeCode=$o(treeGroupList(subGrpTreeCode))
				q:subGrpTreeCode=""
				s subgrpTreeList(subGrpTreeCode)=0
			}
		}
		
	}
	w "{data:["
		s subgrpId=""
		s mlevel=""
		s num=0
		for{
			s mlevel=$o(^DHCWL.CodeCfg.SubGroupI("GrpLevelSort",grpId,mlevel))
			q:mlevel=""
			s mSort=""
			for{
				//s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpId,subgrpId))
				s mSort=$o(^DHCWL.CodeCfg.SubGroupI("GrpLevelSort",grpId,mlevel,mSort))
				q:mSort=""
				s subgrpId=""
				for{
					s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpLevelSort",grpId,mlevel,mSort,subgrpId))
					q:subgrpId=""
					s subgrpCode=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),2)
					s subgrpDesc=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),3)
					s subgrpSort=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),5)
					s subgrpTreeCode=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),6)
					s subgrpPTreeCode=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),7)
					s num=num+1
					if (num>1){
						w ","
					}
					if $d(subgrpTreeList(subgrpTreeCode)){
						s error=1
					}else{
						s error=0
					}
					w "{""className"":""DHCWL.CodeCfg.SubGroup"",""CodeCfgGroupCode"":"_""""_subgrpCode_""""_",""CodeCfgGroupDesc"":"_""""_subgrpDesc_""""_",""ID"":"_""""_subgrpId_""""_",""CodeCfgGroupPTreeCode"":"_""""_subgrpPTreeCode_""""_",""CodeCfgGroupTreeCode"":"_""""_subgrpTreeCode_""""_",""code"":"_""""_subgrpSort_""""_",""error"":"_""""_error_""""_"}"
				}
			}
		}
		w "]}"
}

/// creator:wk~2016-12-7
/// 获取统计子组计算过的层级
/// d ##class(DHCWL.CodeCfgData.FunctionModule).GetCountLevel(1,7)
ClassMethod GetCountLevel(grpId, subgrpId) As %Integer
{
	n (grpId,subgrpId)
	s pTreeCode=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),7)
	s sort=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),5)
	if (pTreeCode="root"){
		q sort
	}else{
		s len=$l(pTreeCode,".")
		s pCode=$p(pTreeCode,".",len)
		s pSubgrpId=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgSGrpidByCode(grpId,pCode)
		s pSort=$lg(^DHCWL.CodeCfg.SubGroupD(pSubgrpId),5)
		if (pSort=1){
			q sort
		}else{
			s level=$lg(^DHCWL.CodeCfg.SubGroupD(pSubgrpId),8)
			s pSort=pSort-1
			s num=0
			for i=1:1:pSort{
				s mgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpLevelSort",grpId,level,i,""))
				q:mgrpId=""
				s mtreeCode=$lg(^DHCWL.CodeCfg.SubGroupD(mgrpId),6)
				s count=0
				s subgrpIdReal=""
				for{
					s subgrpIdReal=$o(^DHCWL.CodeCfg.SubGroupI("GrpPTreeCode",grpId," "_$zcvt(mtreeCode,"U"),subgrpIdReal))
					q:subgrpIdReal=""
					s count=count+1
				}
				s num=num+count
			}
			s num=num+sort
			q num
		}
		
	}
	//s mID=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgSGrpidByCode(grpId,mgrpCode)
}

/// Creator:wk~2016-12-08
/// Desc:获取统计子组树节点全路径描述
/// other:w ##class(DHCWL.CodeCfgData.FunctionModule).GetAllSubGrpDesc(grpId,mgrpCode)
ClassMethod GetAllSubGrpDesc(grpId, subgrpTreeCode) As %String
{
	n (grpId,subgrpTreeCode)
	s treeLen=$l(subgrpTreeCode,".")
	s subgrpTreeCode=$p(subgrpTreeCode,".",2,treeLen)
	s mgrpDescS=""
	for i=1:1:(treeLen-1){
		s mgrpCode=$p(subgrpTreeCode,".",i)
		if (mgrpCode=""){
			s mgrpDesc=""
		}else{
			s mID=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgSGrpidByCode(grpId,mgrpCode)
			s mgrpDesc=$li(^DHCWL.CodeCfg.SubGroupD(mID),3)
		}
		if (mgrpDescS=""){
			s mgrpDescS=mgrpDesc
		}else{
			s mgrpDescS=mgrpDescS_"."_mgrpDesc
		}
	}
	q mgrpDescS
}

/// Creator：wk~2016-12-8
/// Desc:获取统计子组下叶子节点的信息global
/// w ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpList(grpId)
ClassMethod GetSubGrpList(grpId)
{
	n (grpId)
	k ^||TEMPDHCWLCode("S",$j)
	s UtreeCode=""
	for{
		s UtreeCode=$o(^DHCWL.CodeCfg.SubGroupI("GrpTreeCode",grpId,UtreeCode))
		q:UtreeCode=""
		s subgrpId=""
		for{
			s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpTreeCode",grpId,UtreeCode,subgrpId))
			q:subgrpId=""
			s value=##class(DHCWL.CodeCfg.SubGroup).%OpenId(subgrpId)
			s subgrpDesc=value.SGrpDesc
	  		s subgrpCode=value.SGrpCode
			//s subgrpSort=value.SGrpSort
			s subgrpLevel=value.SGrpLevel
			s subgrpSort=##class(DHCWL.CodeCfgData.FunctionModule).GetCountLevel(grpId,subgrpId)
			s subgrpTreeCode=value.SGrpTreeCode
			if $d(^DHCWL.CodeCfg.SubGroupI("GrpPTreeCode",grpId," "_$zcvt(subgrpTreeCode,"U"))){
				continue
			}
			s mgrpDescS=##class(DHCWL.CodeCfgData.FunctionModule).GetAllSubGrpDesc(grpId,subgrpTreeCode)
			s len=$l(subgrpTreeCode,".")
			s subgrpTreeCode=$p(subgrpTreeCode,".",2,len)
			s ^||TEMPDHCWLCode("S",$j,subgrpSort)=mgrpDescS_"^"_subgrpTreeCode_"^"_subgrpLevel_"^"_subgrpId
		}
	}
}

/// 获取传入的节点是不是最底层节点
ClassMethod GetTreeNodeChildFlag(ID) As %String
{
	n (ID)
	q:'$d(^DHCWL.CodeCfg.SubGroupD(ID)) "error"
	s Level=$lg(^DHCWL.CodeCfg.SubGroupD(ID),8)
	s grpDr=$lg(^DHCWL.CodeCfg.SubGroupD(ID),4)
	s num=""
	s flag=0
	for{
		s num=$o(^DHCWL.CodeCfg.SubGroupI("GrpLevel",grpDr,num))
		q:num=""
		if (num>Level){
			s flag=1
			q
		}
	}
	if (flag=0){
		q "ok"
	}else{
		q "no"
	}
}

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     
/// Table:           
/// Input: 			
/// Output:			
/// Return:
/// Others:			d ##class(%ResultSet).RunQuery("DHCWL.CodeCfgData.FunctionModule","getDimInforQuery","科室")
Query getDimInforQuery(filterDesc = "") As %Query(ROWSPEC = "cfgdimCode:%String,cfgdimName:%String") [ SqlProc ]
{
}

ClassMethod getDimInforQueryExecute(ByRef qHandle As %Binary, filterDesc = "") As %Status
{
	n (qHandle,filterDesc)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s dimID=""
 	k list
 	d ##class(DHCWL.CodeCfgData.FunctionModule).getOldDimList(.list)  
 	for {
	 	s dimID=$o(^DHCWL.MKPI.MKPIDimTypeD(dimID))
	 	q:dimID=""
	 	s execode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),9)
	 	continue:execode'["^"
	 	s dimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),2)
	 	s dimDesc=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),3)
	 	s upDimCode=$zcvt(dimCode,"U")
	 	continue:($d(list(upDimCode)))
	 	s dimInfor=dimCode_":"_dimDesc
	 	s upDimInfor=$zcvt(dimInfor,"U")
	 	s upFilterDesc=$zcvt(filterDesc,"U")
	 	continue:upDimInfor'[upFilterDesc
	 	s ^CacheTemp(repid,ind)=$lb(dimID,dimInfor)
	 	s ind=ind+1
 	}
	
	Quit $$$OK
}

ClassMethod getDimInforQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getDimInforQueryExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod getDimInforQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getDimInforQueryExecute ]
{
	n (AtEnd,qHandle,Row)
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

/// Creator:        wk
/// CreatDate:      2017-04-27
/// Description:    获取老版本维度
/// Input:
/// Others:         d ##class(DHCWL.CodeCfgData.FunctionModule).getOldDimList(.list)        
ClassMethod getOldDimList(ByRef data)
{
	n (data)
	k data
	s data("ADMREASON")=""
	s data("ADMREA")=""
	s data("ARCIMID")=""
	s data("DOC")=""
	s data("LOC")=""
	s data("SESSTYPE")=""
	s data("TARICDESC")=""
	//s data("TAREC")=""   //---modify by wk~2017-09-22
	s data("USER")=""
	q
}

/// Creator:         wk
/// CreatDate:       2017-06-09
/// Description:     获取日志信息
/// Table:           
/// Input: 			 用于过滤日志信息的参数
/// Return:
/// Others:			d ##class(%ResultSet).RunQuery("DHCWL.CodeCfgData.FunctionModule","GetLogInforQuery","")
Query GetLogInforQuery(seaName = "", seaModeType = "", seaOperType = "", seaDate = "", grpCode = "", grpFlag = "") As %Query(ROWSPEC = "logID:%String,userID:%String,userName:%String,userIP:%String,operType:%String,dependMoudle:%String,operModule:%String,operDate:%String,operTime:%String,dependSubGrp:%String") [ SqlProc ]
{
}

ClassMethod GetLogInforQueryExecute(ByRef qHandle As %Binary, seaName = "", seaModeType = "", seaOperType = "", seaDate = "", grpCode = "", grpFlag = "") As %Status
{
	n (qHandle,seaName,seaDate,seaModeType,seaOperType,grpCode,grpFlag)
	//s ^TEMPDHCWL("wangkai","grpTest","qqq")=seaName_"@"_seaModeType_"@"_seaOperType_"@"_seaDate_"@"_grpCode
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

ClassMethod GetLogInforQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLogInforQueryExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetLogInforQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLogInforQueryExecute ]
{
	n (qHandle,AtEnd,Row)
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

/// Creator:         wk
/// CreatDate:       2017-06-09
/// Description:     将传入的统计组的信息保存到日志表中
/// Table:           
/// Input: 			 存储统计组日志信息的数组
/// Return:
/// Others:			d ##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dim)
ClassMethod SaveGrpLogInfor(ByRef dim, flag = 0)
{
	n (dim,flag,%session)
 	s modType=$g(dim("modType"))
 	s operType=$g(dim("operType"))
 	s depMod=$g(dim("depMod"))
 	s operDate=$p($h,",",1)
 	s operTime=$p($h,",",2)
 	s logHeader=$g(dim("LogHeader"))
 	s logInfor=$g(dim("LogInfor"))
 	s logDr=$g(dim("logDr"))
 	s type=$g(dim("Type"))
 	s GrpModAttr=$g(dim("GrpModAttr"))
 	q:(logDr="")&&(flag=2) "false"
 	//flag=2时表示已有日志ID，只需要插入日志明细信息
 	if (flag=2){                   
		s result="false"
	 	&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgLogDetailInfo(Grp_LogHeader,Grp_LogInfor,Grp_LogDr,Grp_OperType) VALUES(:logHeader,:logInfor,:logDr,:type))
	   	if (SQLCODE=0){
		   	s result="ok"
	   	}
 	}else{
	 	//根据是否存在session存储操作用户信息。
		if ('$d(%session))
	 	{
	   		s userID="获取不到操作用户信息!"
	   		s userName=""
	   		s userIP=""
	 	}else{
		 	s userID=$Get(%session.Data("LOGON.USERID"))
		 	s userName=$Get(%session.Data("LOGON.USERNAME"))
		 	s userIP=$Get(%session.Data("REMOTE_ADDR"))
	 	}
	 	&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgLogInfo(Grp_UserID,Grp_UserName,Grp_UserIP,Grp_OperType,Grp_ModuleType,Grp_DependMoudle,Grp_OperDate,Grp_OperTime,Grp_ModAttr) VALUES(:userID,:userName,:userIP,:operType,:modType,:depMod,:operDate,:operTime,:GrpModAttr))
	   	q:(SQLCODE'=0) "error"
	   	s id=+$g(%ROWID)
	   	if ($g(flag)=1){
		   	q id
	   	}else{
		   	q "ok"
	   	}
	   	/*s result="false"
	   	i (SQLCODE=0)&&(id'=""){
		   	&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgLogDetailInfo(Grp_LogHeader,Grp_LogInfor,Grp_LogDr) VALUES(:logHeader,:logInfor,:id))
		   	if (SQLCODE=0){
			   	s result="ok"
		   	}
	   	}*/
	}
	q result
}

/// Creator:         wk
/// CreatDate:       2017-06-20
/// Description:     将统计子组信息保存到global中
/// Table:           
/// Input: 			 
/// Return:			存储统计子组信息的global
/// Others:			d ##class(DHCWL.CodeCfgData.FunctionModule).GetGrpInfor()
ClassMethod GetGrpInfor(selectID As %String)
{
	k ^||TEMPDHCWL($j,"Grp","Export")
	s grpID=""
	for {
		s grpID=$o(^DHCWL.CodeCfg.GroupD(grpID))
		q:grpID=""
		continue:grpID'=selectID
		s grpCode=$lg(^DHCWL.CodeCfg.GroupD(grpID),2)
		s grpDesc=$lg(^DHCWL.CodeCfg.GroupD(grpID),3)
		s grpData=$lg(^DHCWL.CodeCfg.GroupD(grpID),8)
		s:grpData'="" grpData=$zd(grpData,3) 
		s grpUser=$lg(^DHCWL.CodeCfg.GroupD(grpID),10)
		s grpDim=$lg(^DHCWL.CodeCfg.GroupD(grpID),11)
		s:grpDim'="" grpDimInfor=$lg($g(^DHCWL.MKPI.MKPIDimTypeD(grpDim)),2)_":"_$lg($g(^DHCWL.MKPI.MKPIDimTypeD(grpDim)),3)
		s subGrpID=""
		for{
			s subGrpID=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpID,subGrpID))
			q:subGrpID=""
			s subGrpCode=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),2)
			s subGrpDesc=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),3)
			s subGrpSort=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),5)
			s subGrpTreeCode=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),6)
			s subGrpLevel=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),8)
			if ($d(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subGrpID))){
				s indexDetailID=""
				for{
					s indexDetailID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subGrpID,indexDetailID))
					q:indexDetailID=""
					s indexSubGrpItemID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subGrpID,indexDetailID,""))
					s subGrpItemDetailID=$lg(^DHCWL.CodeCfg.SubGroupItemD(indexSubGrpItemID),2)
					s dimDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(grpDim,subGrpItemDetailID)
					s ^||TEMPDHCWL($j,"Grp","Export",grpID,subGrpTreeCode,indexSubGrpItemID)=grpCode_"&"_grpDesc_"&"_grpData_"&"_grpUser_"&"_grpDimInfor_"&"_subGrpCode_"&"_subGrpDesc_"&"_subGrpSort_"&"_subGrpLevel_"&"_subGrpItemDetailID_"&"_dimDesc
				}
			}else{
				s ^||TEMPDHCWL($j,"Grp","Export",grpID,subGrpTreeCode)=grpCode_"&"_grpDesc_"&"_grpData_"&"_grpUser_"&"_grpDimInfor_"&"_subGrpCode_"&"_subGrpDesc_"&"_subGrpSort_"&"_subGrpLevel
			}
		}
	}
}

/// Creator:         wk
/// CreatDate:       2017-06-20
/// Description:     将统计大组信息保存到global中
/// Table:           
/// Input: 			 
/// Return:			存储统计大组信息的global
/// Others:			d ##class(DHCWL.CodeCfgData.FunctionModule).GetItemGrpInfor()
ClassMethod GetItemGrpInfor(selectID As %String)
{
	k ^||TEMPDHCWL($j,"Grp","Export")
	s itemGrpID=""
	for {
		s itemGrpID=$o(^DHCWL.CodeCfg.ItemGroupD(itemGrpID))
		q:itemGrpID=""
		continue:itemGrpID'=selectID
		s itemGrpCode=$lg(^DHCWL.CodeCfg.ItemGroupD(itemGrpID),2)
		s itemGrpDesc=$lg(^DHCWL.CodeCfg.ItemGroupD(itemGrpID),3)
		s itemGrpData=$lg(^DHCWL.CodeCfg.ItemGroupD(itemGrpID),5)
		s:itemGrpData'="" itemGrpData=$zd(itemGrpData,3) 
		s itemGrpUser=$lg(^DHCWL.CodeCfg.ItemGroupD(itemGrpID),7)
		s itemGrpDim=$lg(^DHCWL.CodeCfg.ItemGroupD(itemGrpID),8)
		s:itemGrpDim'="" grpDimInfor=$lg($g(^DHCWL.MKPI.MKPIDimTypeD(itemGrpDim)),2)_":"_$lg($g(^DHCWL.MKPI.MKPIDimTypeD(itemGrpDim)),3)
		if ($d(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",itemGrpID))){
			s indexGrpItemID=""
			for {
				s indexGrpItemID=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",itemGrpID,indexGrpItemID))
				q:indexGrpItemID=""
				s grpDetailID=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",itemGrpID,indexGrpItemID,""))
				s itemGrpDetailID=$lg(^DHCWL.CodeCfg.ItemGroupDetailsD(grpDetailID),3)
				s sort=$lg(^DHCWL.CodeCfg.ItemGroupDetailsD(grpDetailID),5)
				s dimDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(itemGrpDim,itemGrpDetailID)
				s ^||TEMPDHCWL($j,"Grp","Export",itemGrpID,grpDetailID)=itemGrpCode_"&"_itemGrpDesc_"&"_itemGrpData_"&"_itemGrpUser_"&"_grpDimInfor_"&"_itemGrpDetailID_"&"_dimDesc_"&"_sort
			}
		}else{
			s ^||TEMPDHCWL($j,"Grp","Export",itemGrpID)=itemGrpCode_"&"_itemGrpDesc_"&"_itemGrpData_"&"_itemGrpUser_"&"_grpDimInfor
		}
	}
}

/// Creator:         wk
/// CreatDate:       2017-09-22
/// Description:     过滤传入参数中的特殊字符
/// Table:           
/// Input: 			 
/// Return:			 返回传入参数去掉特殊字符后的值
/// Others:			d ##class(DHCWL.CodeCfgData.FunctionModule).DePecialChar()
ClassMethod DePecialChar(strs)
{
	n (strs)
	q:strs="" strs
	s strs=$REPLACE(strs,"'","")
	s strs=$REPLACE(strs,$c(10),"")
	s strs=$REPLACE(strs,$c(13),"")
	s strs=$REPLACE(strs,$c(32),"")
	q strs
}

/// Creator:         wk
/// CreatDate:       2017-11-13
/// Description:     更新统计子组明细排序值
/// Table:           DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem
/// Input: 			 subGrpID：归集子组ID
/// Return:			 更新状态
/// Others:			 d ##class(DHCWL.CodeCfgData.FunctionModule).UpdateGrpItemSort(92)
ClassMethod UpdateGrpItemSort(subGrpID)
{
	n (subGrpID)
	s sort=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,""))
	s num=1,flag=0
	if (sort=""){      //--没有维护排序值
		s itemID=""
		for {
			s itemID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subGrpID,itemID))
			q:itemID=""
			s rowID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subGrpID,itemID,""))
			&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem set SGrpIM_Sort=:num where ID=:rowID)
			if (SQLCODE'=0){
				s flag=1
				q
			}
			s num=num+1
		}
	}else{             //--维护了排序值
		s sort="",num=0,itemID=""
		s itemList=""  //记录维护过的明细ID，避免重复维护
		for{
			s sort=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,sort))
			q:(sort="")
			continue:(sort<0)
			s itemID=""
			for {
				s itemID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,sort,itemID))
				q:itemID=""
				if ($d(itemList(itemID))){		
					q
				}else{
					s itemList(itemID)=""
				}
				s rowID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,sort,itemID,""))
				s num=num+1
				if (sort'=num){
					&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem set SGrpIM_Sort=:num where ID=:rowID)
					if (SQLCODE'=0){
						s flag=1
						q
					}
				}
			}
			q:flag=1
		}
		s itemID=""
		for {
			s itemID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subGrpID,itemID))
			q:itemID=""
			s rowID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subGrpID,itemID,""))
			s sort=$lg(^DHCWL.CodeCfg.SubGroupItemD(rowID),7)
			if ((sort<0)||(sort="")){
				s num=num+1
				&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem set SGrpIM_Sort=:num where ID=:rowID)
				if (SQLCODE'=0){
					s flag=1
					q
				}
			}
		}
	}
	d ##class(DHCWL.CodeCfgData.SaveData).logForTJZZItem(subGrpID,"","resetSort")
	q:(flag=1) "更新失败"
	q "ok"
}

/// Creator:         wk
/// CreatDate:       2017-11-13
/// Description:     统计子组排序值上移一位
/// Table:           DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem
/// Input: 			 subGrpID：归集子组ID  itemID：明细ID
/// Return:			 更新状态
/// Others:			 d ##class(DHCWL.CodeCfgData.FunctionModule).Moveup(92,92)
ClassMethod Moveup(subGrpID, rowID)
{
	n (subGrpID,rowID)
	s flag=0
	s sort=$lg(^DHCWL.CodeCfg.SubGroupItemD(rowID),7)
	q:sort<2 "无法移动"
	s newSort=sort-1
	s preItemID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,newSort,""))
	if (preItemID'=""){
		s preRowID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,newSort,preItemID,""))
		&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem set SGrpIM_Sort=:sort where ID=:preRowID)
		if (SQLCODE'=0){
			s flag=1
			q
		}
	}
	&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem set SGrpIM_Sort=:newSort where ID=:rowID)
	if (SQLCODE'=0){
		s flag=1
		q
	}
	d ##class(DHCWL.CodeCfgData.SaveData).logForTJZZItem(subGrpID,rowID,"moveup")
	q:flag=1 "更新失败"
	q "ok"
}

/// Creator:         wk
/// CreatDate:       2017-11-13
/// Description:     统计子组排序值下移一位
/// Table:           DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem
/// Input: 			 subGrpID：归集子组ID  itemID：明细ID
/// Return:			 更新状态
/// Others:			 d ##class(DHCWL.CodeCfgData.FunctionModule).ItemNext(92,92)
ClassMethod ItemNext(subGrpID, rowID)
{
	n (subGrpID,rowID)
	s flag=0
	s sort=$lg(^DHCWL.CodeCfg.SubGroupItemD(rowID),7)
	q:$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,sort))="" "已经是最后一个啦"
	s newSort=sort+1
	s preItemID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,newSort,""))
	if (preItemID'=""){
		s preRowID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,newSort,preItemID,""))
		&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem set SGrpIM_Sort=:sort where ID=:preRowID)
		if (SQLCODE'=0){
			s flag=1
			q
		}
	}
	&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem set SGrpIM_Sort=:newSort where ID=:rowID)
	if (SQLCODE'=0){
		s flag=1
		q
	}
	d ##class(DHCWL.CodeCfgData.SaveData).logForTJZZItem(subGrpID,rowID,"itemNext")
	q:flag=1 "更新失败"
	q "ok"
}

/// Creator:         wk
/// CreatDate:       2017-11-13
/// Description:     统计子组明细跳至指定位置
/// Table:           DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem
/// Input: 			 subGrpID：归集子组ID  itemID：明细ID
/// Return:			 更新状态
/// Others:			 d ##class(DHCWL.CodeCfgData.FunctionModule).MoveToLocal(92,92)
ClassMethod MoveToLocal(subGrpID, rowID, aimsValue)
{
	n (subGrpID,rowID,aimsValue)
	s sort=$lg(^DHCWL.CodeCfg.SubGroupItemD(rowID),7)
	q:('$d(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,aimsValue))) "移动范围只能是当前已存在排序值"
	q:(sort=aimsValue) "ok"
	s flag=0
	k updateList
	if (sort>aimsValue){
		for i=aimsValue:1:(sort-1){
			s itemID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,i,""))
			continue:itemID=""
			s cycleRowID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,i,itemID,""))
			s newSort=(i+1)
			s updateList(cycleRowID)=newSort
		}
		s cycleRowID=""
		for {
			s cycleRowID=$o(updateList(cycleRowID))
			q:cycleRowID=""
			s newSort=updateList(cycleRowID)
			&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem set SGrpIM_Sort=:newSort where ID=:cycleRowID)
			if (SQLCODE'=0){
				s flag=1
				q
			}
		}
		q:flag=1 "更新失败了"
	}else{
		for i=(sort+1):1:aimsValue{
			s itemID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,i,""))
			continue:itemID=""
			s cycleRowID=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpID,i,itemID,""))
			s newSort=(i-1)
			s updateList(cycleRowID)=newSort
		}
		s cycleRowID=""
		for {
			s cycleRowID=$o(updateList(cycleRowID))
			q:cycleRowID=""
			s newSort=updateList(cycleRowID)
			&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem set SGrpIM_Sort=:newSort where ID=:cycleRowID)
			if (SQLCODE'=0){
				s flag=1
				q
			}
		}
		q:flag=1 "更新失败了"
	}
	&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem set SGrpIM_Sort=:aimsValue where ID=:rowID)
	d ##class(DHCWL.CodeCfgData.SaveData).logForTJZZItem(subGrpID,rowID,"MoveToLocal")
	q:(SQLCODE'=0) "更新失败了"
	q "ok"
}

}
