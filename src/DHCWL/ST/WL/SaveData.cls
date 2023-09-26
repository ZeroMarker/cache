Class DHCWL.ST.WL.SaveData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(DHCWL.ST.WL.SaveData).AddSubGrp(.dim)
ClassMethod AddSubGrp(ByRef dim) As %String
{
	n (dim)
	s typeCode=$g(dim("subgrpCode")) 
	i typeCode="" q "子类代码不能为空！"
	s typeDesc=$g(dim("subgrpDesc"))
	i typeDesc="" q "子类名称不能为空！"
	s GrpId=$g(dim("GrpId"))
	i +GrpId=0 q "请选择大组"
	s IsRouteflag=##class(DHCWL.ST.WL.SaveData).isCheckRoute(GrpId)  ///判断口径是否维护齐全
	Q:+IsRouteflag=0 "口径未维护齐全！"
	s DFTI=$g(dim("DFTI"))
	s DFTO=$g(dim("DFTO"))
	s DFTE=$g(dim("DFTE"))
	s DFTH=$g(dim("DFTH"))	
	s DFTIId=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTIdByDesc(DFTI)
	s DFTOId=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTIdByDesc(DFTO)
	s DFTEId=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTIdByDesc(DFTE)
	s DFTHId=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTIdByDesc(DFTH)
	s id=$O(^DHCWL.CodeCfg.SubGroupI("Code",GrpId," "_$ZCVT(typeCode,"U"),""))
	i +id'=0 q "代码不能重复！"
	s Sort=$O(^DHCWL.CodeCfg.SubGroupI("GrpDrSort",GrpId,""),-1)
	s Sort=Sort+1
	//s typeObj=##class(DHCWL.CodeCfg.SubGroup).%New()
	s GrpObj=##class(DHCWL.CodeCfg.Group).%OpenId(GrpId)
	//s typeObj.SGrpGrpDr=GrpObj
	//s typeObj.SGrpCode=$g(typeCode)
	//s typeObj.SGrpDesc=$g(typeDesc)
	//s typeObj.SGrpSort=$g(Sort)
	//s sc=typeObj.%Save()
	/// add ycm 2017-10-12
	k dimsubData
	s dimsubData("SGrpCode")=typeCode
	s dimsubData("SGrpDesc")=typeDesc
	s dimsubData("SGrpGrpDr")=GrpId
	s ret=##class(DHCWL.CodeCfgData.SaveData).AddCodeTreeSubGrp(.dimsubData)
	q:ret'="ok" ret
	i ret="ok"  d
	.s result="ok"
	.//s SubGrp=typeObj.%Id()
	.s SubGrp=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgSGrpidByCode(GrpId,typeCode)
	.s GrpSubGrp=GrpId_"||"_SubGrp
	.i +DFTIId'=0 d ##class(DHCWL.ST.WL.WLInterFace).InsDataFrom(GrpSubGrp_"^"_"I"_"^"_DFTIId_"^M"_"^"_+$H)
	.i +DFTOId'=0 d ##class(DHCWL.ST.WL.WLInterFace).InsDataFrom(GrpSubGrp_"^"_"O"_"^"_DFTOId_"^M"_"^"_+$H)
	.i +DFTEId'=0 d ##class(DHCWL.ST.WL.WLInterFace).InsDataFrom(GrpSubGrp_"^"_"E"_"^"_DFTEId_"^M"_"^"_+$H)
	.i +DFTHId'=0 d ##class(DHCWL.ST.WL.WLInterFace).InsDataFrom(GrpSubGrp_"^"_"H"_"^"_DFTHId_"^M"_"^"_+$H)
	e  d
	.s result="保存失败！"
	q result
}

/// w ##class(DHCWL.ST.WL.SaveData).DeleteSubGrp()
ClassMethod DeleteSubGrp(GId As %String) As %String
{
	n (GId)
	s GrpId=+GId
	s SubGrpId=$P(GId,"||",2)
	i +GrpId=0 q "请选择大类！"
	i +SubGrpId=0 q "请选择子类！"
	&SQL(DELETE FROM DHCWL_Codecfg.DHCWLCodeCfgSubGroup WHERE SGrp_Grp_Dr=:GrpId AND ID=:SubGrpId)
	i SQLCODE=0 d
	.s return="ok"
	.&SQL(DELETE FROM DHCWL_Codecfg.DHCWLCodeCfgSubGroupItem WHERE SGrpIM_Grp_Dr=:GrpId AND SGrpIM_SGrp_Dr=:SubGrpId)
	.d ##class(DHCWL.ST.WL.SaveData).DeleteWLF(GId)
	else  d
	.s return="删除失败！"
	q $g(return)
}

/// w ##class(DHCWL.ST.WL.SaveData).DeleteWLF()
ClassMethod DeleteWLF(GrpSubGrp As %String) As %String
{
	n (GrpSubGrp)
	s WLFId=0,SQLCODE=0
	f  s WLFId=$O(^DHCWLWLFromD(WLFId)) Q:WLFId=""  d
	.s Statdr=$li(^DHCWLWLFromD(WLFId),2)
	.Q:Statdr'[GrpSubGrp
	.&SQL(DELETE FROM DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom WHERE ID=:WLFId)
	q "ok"
}

ClassMethod UpdataSubGrp(ByRef dim) As %String
{
	n (dim)
	s SQLCODE=0
	s subGrpId=$g(dim("subGrpId"))
	s subGrpCode=$g(dim("subgrpCode"))
	s subGrpDesc=$g(dim("subgrpDesc"))
	s subGrpDFTI=$g(dim("subgrpDFTI"))
	s subGrpDFTO=$g(dim("subgrpDFTO"))
	s subGrpDFTE=$g(dim("subgrpDFTE"))
	s subGrpDFTH=$g(dim("subgrpDFTH"))
	s GrpId=$g(dim("GrpId"))
	q:+subGrpId=0 "更新失败"
	s GrpSubGrp=GrpId_"||"_subGrpId
	&SQL(UPDATE DHCWL_Codecfg.DHCWLCodeCfgSubGroup SET SGrp_Code=:subGrpCode, SGrp_Desc=:subGrpDesc WHERE ID=:subGrpId AND SGrp_Grp_Dr=:GrpId)
	i SQLCODE=0 d
	.s return="ok"
	.i subGrpDFTI'="" d
	..s DFTId=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTIdByDesc(subGrpDFTI)
	..Q:+DFTId=0
	..s DataType="I",FlagType="M",InDate=+$h
	..i $D(^DHCWLWLFromI("StatDrDataType"," "_GrpSubGrp," I")) d
	...&SQL(UPDATE DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom SET WLF_FromType=:DFTId WHERE WLF_StatDr=:GrpSubGrp AND WLF_DataType=:DataType)
	..else  d
	...&SQL(INSERT INTO DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpSubGrp,:DataType,:DFTId,:FlagType,:InDate))
	.i subGrpDFTO'="" d
	..s DFTId=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTIdByDesc(subGrpDFTO)
	..Q:+DFTId=0
	..s DataType="O",FlagType="M",InDate=+$h
	..i $D(^DHCWLWLFromI("StatDrDataType"," "_GrpSubGrp," O")) d
	...&SQL(UPDATE DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom SET WLF_FromType=:DFTId WHERE WLF_StatDr=:GrpSubGrp AND WLF_DataType=:DataType)
	..else  d
	...&SQL(INSERT INTO DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpSubGrp,:DataType,:DFTId,:FlagType,:InDate))
	.i subGrpDFTE'="" d
	..s DFTId=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTIdByDesc(subGrpDFTE)
	..Q:+DFTId=0
	..s DataType="E",FlagType="M",InDate=+$h
	..i $D(^DHCWLWLFromI("StatDrDataType"," "_GrpSubGrp," E")) d
	...&SQL(UPDATE DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom SET WLF_FromType=:DFTId WHERE WLF_StatDr=:GrpSubGrp AND WLF_DataType=:DataType)
	..else  d
	...&SQL(INSERT INTO DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpSubGrp,:DataType,:DFTId,:FlagType,:InDate))
	.i subGrpDFTH'="" d
	..s DFTId=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTIdByDesc(subGrpDFTH)
	..Q:+DFTId=0
	..s DataType="H",FlagType="M",InDate=+$h
	..i $D(^DHCWLWLFromI("StatDrDataType"," "_GrpSubGrp," H")) d
	...&SQL(UPDATE DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom SET WLF_FromType=:DFTId WHERE WLF_StatDr=:GrpSubGrp AND WLF_DataType=:DataType)
	..else  d
	...&SQL(INSERT INTO DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpSubGrp,:DataType,:DFTId,:FlagType,:InDate))
	else  d
	.s return="ok"
	q return
}

ClassMethod AddSubGrpItem(ByRef dim) As %String
{
	n (dim)
	s SQLCODE=0
	s GrpId=$g(dim("GrpId"))
	s SubGrpId=$g(dim("SubGrpId"))
	s selectItemId=$g(dim("selectItemPara"))
	Q:+GrpId=0 "请先选择分组大类"
	Q:+SubGrpId=0 "请先选择分组子类"
	s IsGrpRouteflag=##class(DHCWL.ST.WL.SaveData).isCheckRoute(GrpId)
	s IsSubGrpRouteflag=##class(DHCWL.ST.WL.SaveData).isCheckRoute(GrpId_"||"_SubGrpId)  ///判断口径是否维护齐全
	Q:(+IsGrpRouteflag=0)||(+IsSubGrpRouteflag=0) "口径未维护齐全!"
	k data
	f i=1:1:$L(selectItemId,"-")  d
	.s ArcimId=$P(selectItemId,"-",i)
	.Q:+ArcimId=0
	.Q:'$D(^ARCIM(+ArcimId,$P(ArcimId,"||",2)))
	.Q:$D(^DHCWL.CodeCfg.SubGroupItemI("SGrp"," "_ArcimId))  ///医嘱已经维护，就退出
	.s SQLCODE=0
	.&SQL(insert into dhcwl_Codecfg.DHCWLCodeCfgSubGroupItem (SGrpIM_SGrp_Dr,SGrpIM_Item_DR,SGrpIM_Grp_Dr) values(:SubGrpId,:ArcimId,:GrpId))
	.i SQLCODE=0 d
	..s RowId=+$g(%ROWID)
	..Q:+RowId=0
	..s WLFStatdr=GrpId_"||"_SubGrpId_"||"_RowId
	..s DFTId=$O(^DHCWLDFTypeI("DFTCode"," JF",""))
	..Q:DFTId=""
	..f DateType="I","O","E","H" d
	...s WLFFlag="L"
	...s WLFDate=+$H
	...Q:$D(^DHCWLWLFromI("StatDrDataType"," "_WLFStatdr," "_DateType))
	...s SQLCODE=0
	...TStart
	...&SQL(INSERT INTO DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:WLFStatdr,:DateType,:DFTId,:WLFFlag,:WLFDate))
	...i SQLCODE=0 TCOMMIT
	...else  TROLLBACK
	
	q "ok"
}

/// w ##class(DHCWL.ST.WL.SaveData).DeleteSubGrpItem("601","6","N")
ClassMethod DeleteSubGrpItem(subGrpItemId As %String, SubGrpId As %String, Type As %String) As %String
{
	n (subGrpItemId,SubGrpId,Type)
	;s ^yu(1)=subGrpItemId_"!!"_SubGrpId_"!!"_Type
	s SQLCODE=0,return=""
	;Q:(Type="N")&&(+subGrpItemId=0) "请选择删除明细！"
	i Type="N" d
	.Q:'$D(^DHCWL.CodeCfg.SubGroupItemD(subGrpItemId))
	.s GrpId=$li(^DHCWL.CodeCfg.SubGroupItemD(subGrpItemId),4)
	.&SQL(DELETE FROM dhcwl_Codecfg.DHCWLCodeCfgSubGroupItem WHERE ID=:subGrpItemId)
	.s GrpSubGrpItemId=GrpId_"||"_SubGrpId_"||"_subGrpItemId
	.&SQL(Delete from DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom WHERE WLF_StatDr=:GrpSubGrpItemId)
	i Type="A" d
	.&SQL(DELETE FROM dhcwl_Codecfg.DHCWLCodeCfgSubGroupItem WHERE SGrpIM_SGrp_Dr=:SubGrpId)
	.d ##class(DHCWL.ST.WL.SaveData).DeleteItemBySubGrpId(SubGrpId)
	i SQLCODE=0 d
	.s return="ok"
	else  d
	.s return=""
	q return
}

/// 根据子分组删除下面的明细口径关系
/// w ##class(DHCWL.ST.WL.SaveData).DeleteItemBySubGrpId("")
ClassMethod DeleteItemBySubGrpId(SubGrpId As %String) As %String
{
	n (SubGrpId)
	q:+SubGrpId=0 ""
	s SubGrpItemId=0
	f  s SubGrpItemId=$O(^DHCWL.CodeCfg.SubGroupItemD(SubGrpItemId)) Q:SubGrpItemId=""  d
	.s ItemDr=$li(^DHCWL.CodeCfg.SubGroupItemD(SubGrpItemId),2)
	.s SubGrpId=$li(^DHCWL.CodeCfg.SubGroupItemD(SubGrpItemId),3)
	.s GrpId=$li(^DHCWL.CodeCfg.SubGroupItemD(SubGrpItemId),4)
	.s GrpSubGrpItemId=GrpId_"||"_SubGrpId_"||"_SubGrpItemId
	.&SQL(DELETE FROM DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom WHERE WLF_StatDr=:GrpSubGrpItemId)
	q "ok"
}

/// 更新明细统计口径
ClassMethod UpdateItemDetails(GrpId As %String, SubGrpId As %String, ItemId As %String, field As %String, value As %String) As %String
{
	n (GrpId,SubGrpId,ItemId,field,value)
	s SQLCODE=0
	Q:field="" ""
	Q:(+GrpId=0)||(+SubGrpId=0)||(+ItemId=0) ""
	s GrpGourpId=GrpId_"||"_SubGrpId_"||"_ItemId
	s DataType=""
	i field="DFTI" s DataType="I"
	i field="DFTO" s DataType="O"
	i field="DFTE" s DataType="E"
	i field="DFTH" s DataType="H"
	s WLFlag="L"
	s WLFDate=+$H
	s DFTId=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTIdByDesc(value)
	s WLFID=$O(^DHCWLWLFromI("StatDrDataType"," "_GrpGourpId," "_DataType,""))
	i +WLFID=0 d
	.&SQL(INSERT into DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpGourpId,:DataType,:DFTId,:WLFlag,:WLFDate))
	else  d
	.&SQL(UPDATE DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom SET WLF_FromType=:DFTId WHERE ID=:WLFID)
	q "ok"
}

/// 更新大组统计口径
ClassMethod UpdateGrpRoute(GrpId As %String, field As %String, value As %String) As %String
{
	n (GrpId,field,value)
	s SQLCODE=0
	Q:field="" ""
	Q:(+GrpId=0) ""
	s DataType=""
	s GrpGourpId=GrpId
	i field="IDFTDesc" s DataType="I"
	i field="ODFTDesc" s DataType="O"
	i field="EDFTDesc" s DataType="E"
	i field="HDFTDesc" s DataType="H"
	s WLFlag="B"
	s WLFDate=+$H
	s DFTId=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTIdByDesc(value)
	s WLFID=$O(^DHCWLWLFromI("StatDrDataType"," "_GrpGourpId," "_DataType,""))
	i +WLFID=0 d
	.&SQL(INSERT into DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpGourpId,:DataType,:DFTId,:WLFlag,:WLFDate))
	else  d
	.&SQL(UPDATE DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom SET WLF_FromType=:DFTId WHERE ID=:WLFID)
	q "ok"
}

/// 根据传入的条目Id，判断本条目的口径是否维护完全，维护全--1  ，否则  0
/// w ##class(DHCWL.ST.WL.SaveData).isCheckRoute("")
ClassMethod isCheckRoute(StatDr As %String) As %String
{
	n (StatDr)
	q:+StatDr=0 ""
	s Isfalse=0
	s RouteNum=+$g(^TEMPDHCWLYJGroupBS("RouteNum"))
	i +RouteNum=0 s RouteNum=4
	s WLFId=""
	f  s WLFId=$O(^DHCWLWLFromI("StatDr"," "_StatDr,WLFId)) Q:WLFId=""  d
	.s DFTId=$li(^DHCWLWLFromD(WLFId),4)
	.Q:+DFTId=0
	.Q:'$D(^DHCWLDFTypeD(DFTId))
	.s Isfalse=Isfalse+1
	q Isfalse=RouteNum
}

// w ##class(DHCWL.ST.WL.SaveData).editSubGrp("18","569","DFTO","检验接口")

ClassMethod editSubGrp(GrpId, SubGrpId, field, value) As %String
{
	n (GrpId,SubGrpId,field,value)
	;s ^yu(1)=GrpId_"!!"_SubGrpId_"!!"_field_"!!"_value
	q:GrpId="" "请选择分类!"
	s DataType=""
	i (field="subgrpCode")&&(SubGrpId="") d
	.;q:'$D(^DHCWL.CodeCfg.SubGroupI("Code",GrpId))  /// 存在问题
	.q:$D(^DHCWL.CodeCfg.SubGroupI("Code",GrpId," "_value))
	.//&SQL(INSERT INTO DHCWL_COdecfg.DHCWLCodeCfgSubGroup (SGrp_Grp_Dr, SGrp_Code, SGrp_Desc) VALUES(:GrpId,:value,:value))
	./// add ycm 2017-10-12
	.k dimsubData
	.s dimsubData("SGrpCode")=value
	.s dimsubData("SGrpDesc")=value
	.s dimsubData("SGrpGrpDr")=GrpId
	.s ret=##class(DHCWL.CodeCfgData.SaveData).AddCodeTreeSubGrp(.dimsubData)
	.q:ret'="ok"
	.s SubGrp=##class(DHCWL.CodeCfgData.SaveData).GetCodecfgSGrpidByCode(GrpId,value)
	.s Id=SubGrp
	.s GrpSubId=GrpId_"||"_Id
	.s DFTId=$O(^DHCWLDFTypeI("DFTCode"," JF",""))
	.i '$D(^DHCWLWLFromI("StatDrDataType"," "_GrpSubId," E")) d
	..s DataType="E",FlagType="M",InDate=+$h
	..&SQL(INSERT INTO DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpSubId,:DataType,:DFTId,:FlagType,:InDate))
	.i '$D(^DHCWLWLFromI("StatDrDataType"," "_GrpSubId," O")) d
	..s DataType="O",FlagType="M",InDate=+$h
	..&SQL(INSERT INTO DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpSubId,:DataType,:DFTId,:FlagType,:InDate))
	.i '$D(^DHCWLWLFromI("StatDrDataType"," "_GrpSubId," I")) d
	..s DataType="I",FlagType="M",InDate=+$h
	..&SQL(INSERT INTO DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpSubId,:DataType,:DFTId,:FlagType,:InDate))
	.i '$D(^DHCWLWLFromI("StatDrDataType"," "_GrpSubId," H")) d
	..s DataType="H",FlagType="M",InDate=+$h
	..&SQL(INSERT INTO DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpSubId,:DataType,:DFTId,:FlagType,:InDate))
	else  i ((field="subgrpDesc")||(field="subgrpCode"))&&(SubGrpId'="") d
	.i field="subgrpDesc" d
	..&SQL(UPDATE DHCWL_COdecfg.DHCWLCodeCfgSubGroup SET SGrp_Desc=:value WHERE ID=:SubGrpId)
	.i field="subgrpCode" d
	..&SQL(UPDATE DHCWL_COdecfg.DHCWLCodeCfgSubGroup SET SGrp_Code=:value WHERE ID=:SubGrpId)
	else  d
	.i field="DFTI" s DataType="I"
	.i field="DFTO" s DataType="O"
	.i field="DFTE" s DataType="E"
	.i field="DFTH" s DataType="H"
	.q:DataType=""
	.q:GrpId=""
	.q:SubGrpId=""
	.s WLFlag="M"
	.s WLFDate=+$H
	.s GrpGourpId=GrpId_"||"_SubGrpId
	.s DFTId=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTIdByDesc(value)
	.s WLFID=$O(^DHCWLWLFromI("StatDrDataType"," "_GrpGourpId," "_DataType,""))
	.i +WLFID=0 d
	..&SQL(INSERT into DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpGourpId,:DataType,:DFTId,:WLFlag,:WLFDate))
	.else  d
	..&SQL(UPDATE DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom SET WLF_FromType=:DFTId WHERE ID=:WLFID)
	q "ok"
}

Storage Default
{
<Data name="SaveDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCWL.ST.WL.SaveDataD</DataLocation>
<DefaultData>SaveDataDefaultData</DefaultData>
<IdLocation>^DHCWL.ST.WL.SaveDataD</IdLocation>
<IndexLocation>^DHCWL.ST.WL.SaveDataI</IndexLocation>
<StreamLocation>^DHCWL.ST.WL.SaveDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
