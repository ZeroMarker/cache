/// Creator    : wk
/// CreatDate  : 2018-09-25
/// Desc       : 医技工作量维护函数
Class web.DHCWL.V1.WL.WLGroupCfgFun Extends %RegisteredObject
{

/// Creator   : wk
/// CreatDate : 2018-09-25
/// Desc      : 大组数据展示
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.WL.WLGroupCfgFun","GetGrp")
Query GetGrp(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,desc:%String:描述,IItem:%String:住院口径,OItem:%String:门诊口径,EItem:%String:急诊口径,HItem:%String:检验口径") [ SqlProc ]
{
}

ClassMethod GetGrpExecute(ByRef qHandle As %Binary, fillterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:fillterValue'="" fillterValue=$zcvt(fillterValue,"U")
	s sql="SELECT ID,GrpCode,GrpDesc,IItem,OItem,EItem,HItem FROM web_DHCWL_V1_WL.WLGroup"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s grpCpde=rs.Data("GrpCode")
		s grpDesc=rs.Data("GrpDesc")
		s IItem=rs.Data("IItem")
		s OItem=rs.Data("OItem")
		s EItem=rs.Data("EItem")
		s HItem=rs.Data("HItem")
		s IItemValue=$lg(^web.DHCWL.V1.WL.WLDataTypeD(IItem),3)
		s OItemValue=$lg(^web.DHCWL.V1.WL.WLDataTypeD(OItem),3)
		s EItemValue=$lg(^web.DHCWL.V1.WL.WLDataTypeD(EItem),3)
		s HItemValue=$lg(^web.DHCWL.V1.WL.WLDataTypeD(HItem),3)
		continue:(fillterValue'="")&&($zcvt(grpCpde,"U") '[ fillterValue)&&($zcvt(grpDesc,"U") '[ fillterValue)&&($zcvt(IItemValue,"U") '[ fillterValue)&&($zcvt(OItemValue,"U") '[ fillterValue)&&($zcvt(EItemValue,"U") '[ fillterValue)&&($zcvt(HItemValue,"U") '[ fillterValue)
		s ^CacheTemp(repid,ind)=$lb(ID,grpCpde,grpDesc,IItemValue,OItemValue,EItemValue,HItemValue)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-25
/// Desc      : 大组保存
/// Other     : do ##class(web.DHCWL.V1.WL.WLGroupCfgFun).AddGrp()
ClassMethod AddGrp(code, desc, IItem, OItem, EItem, HItem)
{
	q:code="" "编码不能为空"
	q:$d(^web.DHCWL.V1.WL.WLGroupI("Code"," "_$ZCVT(code,"U"))) "编码重复,不能添加"
	s dimID=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI","ARCIM",""))
	q:(dimID="") "没有找到医嘱项维度"
	s date=+$H
	s IItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(IItem,"U"),""))
	s OItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(OItem,"U"),""))
	s EItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(EItem,"U"),""))
	s HItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(HItem,"U"),""))
	&sql(insert into web_DHCWL_V1_WL.WLGroup(GrpCode,GrpDesc,GrpDimDr,GrpCreateDate,IItem,OItem,EItem,HItem) values (:code,:desc,:dimID,:date,:IItemValue,:OItemValue,:EItemValue,:HItemValue))
	if SQLCODE'=0 {
		q "操作失败,"_SQLCODE
	}
	q "操作成功"
}

/// Creator   : wk
/// CreatDate : 2018-09-25
/// Desc      : 修改统计大组
/// Other     : do ##class(web.DHCWL.V1.WL.WLGroupCfgFun).UpdateGrp()
ClassMethod UpdateGrp(ID, desc, IItem, OItem, EItem, HItem)
{
	q:ID="" "大组获取失败"
	s IItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(IItem,"U"),""))
	s OItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(OItem,"U"),""))
	s EItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(EItem,"U"),""))
	s HItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(HItem,"U"),""))
	s date=+$H
	&sql(update web_DHCWL_V1_WL.WLGroup set GrpDesc=:desc,GrpCreateDate=:date,IItem=:IItemValue,OItem=:OItemValue,EItem=:EItemValue,HItem=:HItemValue where ID=:ID)
	if SQLCODE'=0 {
		q "操作失败,"_SQLCODE
	}
	q "操作成功"
}

/// Creator   : wk
/// CreatDate : 2018-09-28
/// Desc      : 删除大组
/// Other     : do ##class(web.DHCWL.V1.WL.WLGroupCfgFun).DeleteGrp()
ClassMethod DeleteGrp(grpID As %String)
{
	q:'$d(^web.DHCWL.V1.WL.WLGroupD(grpID)) "获取大组失败"
	q:$d(^web.DHCWL.V1.WL.WLSubGroupI("GrpDr",grpID)) "请删除大组关联子组后再进行操作"
	//q:$d(^web.DHCWL.V598C.WLSubGroupItemD(grpID)) "请删除大组关联子组后在进行操作"
	&sql(delete from web_DHCWL_V1_WL.WLGroup where ID=:grpID)
	if (SQLCODE'=0){
		q "删除失败"
	}else{
		q "删除成功"
	}
}

/// Creator   : wk
/// CreatDate : 2018-09-25
/// Desc      : 获取子组
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.WL.WLGroupCfgFun","GetSubGrp")
Query GetSubGrp(grpID As %String = "", filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,desc:%String:描述,IItem:%String:住院口径,OItem:%String:门诊口径,EItem:%String:急诊口径,HItem:%String:检验口径") [ SqlProc ]
{
}

ClassMethod GetSubGrpExecute(ByRef qHandle As %Binary, grpID As %String = "", filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:grpID="" $$$OK
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	s sql="SELECT ID,SGrpCode,SGrpDesc,IItem,OItem,EItem,HItem FROM web_DHCWL_V1_WL.WLSubGroup WHERE SGrpGrpDr="_grpID_" ORDER BY SGrpSort"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s subGrpCpde=rs.Data("SGrpCode")
		s subGrpDesc=rs.Data("SGrpDesc")
		s IItem=rs.Data("IItem")
		s OItem=rs.Data("OItem")
		s EItem=rs.Data("EItem")
		s HItem=rs.Data("HItem")
		s IItemValue=$lg(^web.DHCWL.V1.WL.WLDataTypeD(IItem),3)
		s OItemValue=$lg(^web.DHCWL.V1.WL.WLDataTypeD(OItem),3)
		s EItemValue=$lg(^web.DHCWL.V1.WL.WLDataTypeD(EItem),3)
		s HItemValue=$lg(^web.DHCWL.V1.WL.WLDataTypeD(HItem),3)
		continue:((filterValue'="")&&($zcvt(subGrpCpde,"U") '[ filterValue)&&($zcvt(subGrpDesc,"U") '[ filterValue)&&($zcvt(IItemValue,"U") '[ filterValue)&&($zcvt(OItemValue,"U") '[ filterValue)&&($zcvt(EItemValue,"U") '[ filterValue)&&($zcvt(HItemValue,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(ID,subGrpCpde,subGrpDesc,IItemValue,OItemValue,EItemValue,HItemValue)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-25
/// Desc      : 新增统计子组
/// Other     : do ##class(web.DHCWL.V1.WL.WLGroupCfgFun).AddSubGrp()
ClassMethod AddSubGrp(code, desc, IItem, OItem, EItem, HItem, grpID)
{
	q:code="" "编码不能为空"
	q:grpID="" "获取大组失败"
	//s sort=1
	q:($d(^web.DHCWL.V1.WL.WLSubGroupI("Code",grpID," "_$ZCVT(code,"U")))) "编码重复,不能添加"
	s sort=$o(^web.DHCWL.V1.WL.WLSubGroupI("GrpDrSort",grpID,""),-1)
	s sort=+sort+1
	s IItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(IItem,"U"),""))
	s OItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(OItem,"U"),""))
	s EItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(EItem,"U"),""))
	s HItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(HItem,"U"),""))
	&sql(insert into web_DHCWL_V1_WL.WLSubGroup(SGrpCode,SGrpDesc,SGrpGrpDr,SGrpSort,IItem,OItem,EItem,HItem) values (:code,:desc,:grpID,:sort,:IItemValue,:OItemValue,:EItemValue,:HItemValue))
	if SQLCODE'=0 {
		q "操作失败,"_SQLCODE
	}
	q "操作成功"
}

/// Creator   : wk
/// CreatDate : 2018-09-25
/// Desc      : 修改子组
/// Other     : do ##class(web.DHCWL.V1.WL.WLGroupCfgFun).UpdateSubGrp()
ClassMethod UpdateSubGrp(ID, desc, IItem, OItem, EItem, HItem)
{
	q:ID="" "获取子组失败"
	s IItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(IItem,"U"),""))
	s OItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(OItem,"U"),""))
	s EItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(EItem,"U"),""))
	s HItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(HItem,"U"),""))
	&sql(update web_DHCWL_V1_WL.WLSubGroup set SGrpDesc=:desc,IItem=:IItemValue,OItem=:OItemValue,EItem=:EItemValue,HItem=:HItemValue where ID=:ID)
	if SQLCODE'=0 {
		q "操作失败,"_SQLCODE
	}
	q "操作成功"
}

/// Creator   : wk
/// CreatDate : 2018-09-28
/// Desc      : 删除子组
/// Other     : do ##class(web.DHCWL.V1.WL.WLGroupCfgFun).DeleteSubGrp()
ClassMethod DeleteSubGrp(subGrpID As %String)
{
	q:'$d(^web.DHCWL.V1.WL.WLSubGroupD(subGrpID)) "获取子组失败"
	q:$d(^web.DHCWL.V598C.WLSubGroupItemI("SGrpIM",subGrpID)) "子组下维护有明细,请先删除后再进行操作"
	&sql(delete from web_DHCWL_V1_WL.WLSubGroup where ID=:subGrpID)
	if (SQLCODE'=0){
		q "删除失败"
	}
	q "删除成功"
}

/// Creator   : wk
/// CreatDate : 2018-09-25
/// Desc      : 获取所有明细
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.WL.WLGroupCfgFun","GetAllDetail")
Query GetAllDetail(subGrpID As %String, filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,desc:%String:描述") [ SqlProc ]
{
}

ClassMethod GetAllDetailExecute(ByRef qHandle As %Binary, subGrpID As %String, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	q:subGrpID="" "获取子组失败"
	s grpID=$lg(^web.DHCWL.V1.WL.WLSubGroupD(subGrpID),2)
	s dimID = $lg(^web.DHCWL.V1.WL.WLGroupD(grpID),4)
	q:'$d(^DHCWL.MKPI.MKPIDimTypeD(dimID)) "维度获取失败"
	
	s rs=##class(DHCWL.CodeCfgData.CodeTypeItemQuery).QryDimValuesByDimType(dimID)
	f num=0:1:rs-1 d
	.s itemDr=$p(^TEMPDHCWLCode($j,num),"^",1)
	.s itemCode=$p(^TEMPDHCWLCode($j,num),"^",2)
	.s itemDesc=$p(^TEMPDHCWLCode($j,num),"^",3)
	.s itemDesc=##class(DHCWL.CodeCfgData.FunctionModule).DePecialChar(itemDesc)
	.;q:$d(^DHCWL.CodeCfg.SubGroupItemI("Grp",id," "_$ZCVT(itemDr,"U")))
	.;q:$d(^web.DHCWL.V598C.WLSubGroupItemI("SGrpIM",subGrpID," "_$zcvt(itemDr,"U")))
	.s flag=##class(web.DHCWL.V1.WL.WLGroupCfgFun).IsInGrp(subGrpID,itemDr)
	.q:flag=1
	.q:((filterValue'="")&&($zcvt(itemDr,"U") '[ filterValue)&&($zcvt(itemCode,"U") '[ filterValue)&&($zcvt(itemDesc,"U") '[ filterValue))
	.s ^CacheTemp(repid,ind)=$lb(itemDr,itemCode,itemDesc)
	.s ind=ind+1
	
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-09-26
/// Desc       : 判断明细是否在大组中
/// Other      :
ClassMethod IsInGrp(subGrpID, itemID)
{
	s grpID=$lg(^web.DHCWL.V1.WL.WLSubGroupD(subGrpID),2)
	s ID=""
	s flag=0
	for {
		s ID=$o(^web.DHCWL.V1.WL.WLSubGroupI("GrpDr",grpID,ID))
		q:ID=""
		s:$d(^web.DHCWL.V598C.WLSubGroupItemI("SGrpIM",ID," "_$zcvt(itemID,"U"))) flag=1
		q:flag=1
	}
	q:flag=1 1
	q 0
}

/// Creator    : wk
/// CreatDate  : 2018-09-26
/// Desc       : 保存明细
/// Other      : do class(web.DHCWL.V1.WL.WLGroupCfgFun).AddGrpDetail()
ClassMethod AddGrpDetail(details, subGrpID)
{
	s len=$l(details,",")
	s errorFlag=0
	for i=1:1:len {
		s detail=$p(details,",",i)
		continue:detail=""
		s order=$o(^web.DHCWL.V598C.WLSubGroupItemI("SGrpSort",subGrpID,""),-1)
		s order=+order+1
		s code=$p(detail,"#",2)
		s ID=$p(detail,"#",1)
		b
		&sql(insert into web_DHCWL_V1_WL.WLSubGroupItem (SGrpIMSGrpDr,SGrpIMItemID,SGrpIMItemCode,SGrpIMSort) values (:subGrpID,:ID,:code,:order))
		if SQLCODE'=0 {
			s errorFlag=SQLCODE
			q
		}
	}
	q:errorFlag=0 "保存成功"
	q "保存失败"_errorFlag
}

/// Creator   : wk
/// CreatDate ：2018-09-26
/// Desc      : 获取已配置明细 
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.WL.WLGroupCfgFun","GetCfgDetail")
Query GetCfgDetail(subGrpID As %String, filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,grpDetailID:%String:ID,desc:%String:描述,IItem:%String:住院口径,OItem:%String:门诊口径,EItem:%String:急诊口径,HItem:%String:检验口径") [ SqlProc ]
{
}

ClassMethod GetCfgDetailExecute(ByRef qHandle As %Binary, subGrpID As %String, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	s grpID=$lg(^web.DHCWL.V1.WL.WLSubGroupD(subGrpID),2)
	s dimID=$lg(^web.DHCWL.V1.WL.WLGroupD(grpID),4)
	q:('$d(^DHCWL.MKPI.MKPIDimTypeD(dimID))) "维度获取失败"
	s sql="SELECT ID,SGrpIMItemID,IItem,OItem,EItem,HItem FROM web_DHCWL_V1_WL.WLSubGroupItem WHERE SGrpIMSGrpDr="_subGrpID_" ORDER BY SGrpIMSort"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s itemID=rs.Data("SGrpIMItemID")
		s itemID=$tr(itemID," ")
		s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(dimID,itemID)
		s IItem=rs.Data("IItem")
		s OItem=rs.Data("OItem")
		s EItem=rs.Data("EItem")
		s HItem=rs.Data("HItem")
		s IItemValue="",OItemValue="",EItemValue="",HItemValue=""
		s:IItem'="" IItemValue=$lg(^web.DHCWL.V1.WL.WLDataTypeD(IItem),3)
		s:OItem'="" OItemValue=$lg(^web.DHCWL.V1.WL.WLDataTypeD(OItem),3)
		s:EItem'="" EItemValue=$lg(^web.DHCWL.V1.WL.WLDataTypeD(EItem),3)
		s:HItem'="" HItemValue=$lg(^web.DHCWL.V1.WL.WLDataTypeD(HItem),3)
		continue:((filterValue'="")&&(itemID '[ filterValue)&&($zcvt(itemDesc,"U") '[ filterValue)&&($zcvt(IItemValue,"U") '[ filterValue)&&($zcvt(OItemValue,"U") '[ filterValue)&&($zcvt(EItemValue,"U") '[ filterValue)&&($zcvt(HItemValue,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(ID,itemID,itemDesc,IItemValue,OItemValue,EItemValue,HItemValue)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-27
/// Desc      : 更新以保存明细
/// Other     : do class(web.DHCWL.V1.WL.WLGroupCfgFun).UpdateGrpDetail()
ClassMethod UpdateGrpDetail(strs As %String = "")
{
	q:strs="" ""
	s len=$l(strs,",")
	s errorFlag=0
	for i=1:1:len {
		s str=$p(strs,",",i)
		continue:str=""
		s ID=$p(str,"^",1)
		s IItem=$p(str,"^",2)
		s OItem=$p(str,"^",3)
		s EItem=$p(str,"^",4)
		s HItem=$p(str,"^",5)
		s IItemValue="",OItemValue="",EItemValue="",HItemValue=""
		s:IItem'="" IItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(IItem,"U"),""))
		s:OItem'="" OItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(OItem,"U"),""))
		s:EItem'="" EItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(EItem,"U"),""))
		s:HItem'="" HItemValue=$o(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$ZCVT(HItem,"U"),""))
		&sql(update web_DHCWL_V1_WL.WLSubGroupItem set IItem=:IItemValue,OItem=:OItemValue,EItem=:EItemValue,HItem=:HItemValue where ID=:ID)
		if (SQLCODE'=0){
			s errorFlag=1
			q
		}
	}
	q:errorFlag=1 "fail"
	q "success"
}

/// Creator   : wk
/// CreatDate : 2018-09-28
/// Desc      : 删除已维护明细
/// Other     : do ##class(web.DHCWL.V1.WL.WLGroupCfgFun).DeleteSelectDetail()
ClassMethod DeleteSelectDetail(detailID)
{
	q:'$d(^web.DHCWL.V598C.WLSubGroupItemD(detailID)) "删除失败"
	&sql(delete from web_DHCWL_V1_WL.WLSubGroupItem where ID=:detailID)
	if (SQLCODE'=0){
		q "删除失败"
	}
	q "删除成功"
}

/// Creator   : wk
/// CreatDate : 2018-09-28
/// Desc      : 删除子组下所有明细
/// Other     : do ##Class(web.DHCWL.V1.WL.WLGroupCfgFun).DeleteAllDetail()
ClassMethod DeleteAllDetail(subGrpID)
{
	q:'$d(^web.DHCWL.V598C.WLSubGroupItemI("SGrpIM",subGrpID)) "删除成功"
	&sql(delete from web_DHCWL_V1_WL.WLSubGroupItem where SGrpIMSGrpDr=:subGrpID)
	if (SQLCODE'=0){
		q "删除失败"
	}
	q "删除成功"
}

/// Creator   : wk
/// CreatDate : 2018-11-13
/// Desc      : 工作量类型表中维护数据
/// Other     : do ##Class(web.DHCWL.V1.WL.WLGroupCfgFun).AddWLType()
ClassMethod AddWLType()
{
	k ^TEMPDHCWL("WL","Add","JF")
	s ^TEMPDHCWL("WL","Add","JF")="计费^GetJFMRData^KPSTWLJF"
	s ^TEMPDHCWL("WL","Add","EXE")="执行^GetEXEMRData^KPSTWLEXE"
	s ^TEMPDHCWL("WL","Add","JYInter")="检验接口^GetJYInterMRData^KPSTWLJYInter"
	s ^TEMPDHCWL("WL","Add","JCInter")="检查接口^GetJCInterMRData^KPSTWLJCInter"
	s ^TEMPDHCWL("WL","Add","HSZX")="护士执行^GetHSZXMRData^KPSTWLHSZX"
	
	s flag=0
	s code=""
	for {
		s code=$o(^TEMPDHCWL("WL","Add",code))
		q:code=""
		continue:$d(^web.DHCWL.V1.WL.WLDataTypeI("DFTCode"," "_$zcvt(code,"U"))) 
		s typeInfor=^TEMPDHCWL("WL","Add",code)
		s desc=$p(typeInfor,"^",1)
		s exeCode=$p(typeInfor,"^",2)
		s kpiCode=$p(typeInfor,"^",3)
		&sql(insert into web_DHCWL_V1_WL.WLDataType(DateTypeCode,DateTypeDesc,DateTypeExCode,DateTypeKPICode) values (:code,:desc,:exeCode,:kpiCode))
		if (SQLCODE'=0){
			s flag=1
			q
		}
	}
	if (flag=0){
		w "数据保存成功"
	}else{
		w "数据保存失败"
	}
}

}
