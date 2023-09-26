Import SQLUser

Class DHCWL.CodeCfgData.SaveData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(DHCWL.CodeCfgData.SaveData).AddCodeType(.dim)
ClassMethod AddCodeType(ByRef dim) As %String
{
	n (dim,%session)
	s typeCode=$g(dim("TypeCode")) 
	i typeCode="" q "分类代码不能为空！"
	s typeDesc=$g(dim("TypeDesc"))
	i typeDesc="" q "分类名称不能为空！"
	s id=..GetCodecfgidByCode(typeCode)
	i id'="" q "代码不能重复！"
	s extCode=$g(dim("TypeExtCode"))
	s valuedes=$g(dim("TypeValueDes"))
	s validFlag=$g(dim("TypeFlag"))
	s createUse=$g(dim("TypeCreateUse"))
	s typeObj=##class(DHCWL.CodeCfg.Type).%New()
	s typeObj.TypeCode=$g(typeCode)
	s typeObj.TypeDesc=$g(typeDesc)
	s typeObj.TypeValueDes=$g(valuedes)
	s typeObj.TypeFlag=$g(validFlag)
	s typeObj.TypeExtCode=$g(extCode)
	s typeObj.TypeCreateDate=+$h
	s typeObj.TypeCreateUse=createUse
	s sc=typeObj.%Save()
	s rJson=typeObj.GetDataStr()  
	//s ^yxtest("rJson")=rJson
	i sc=1  d
	.s result="ok"
	.;s JsonStr="{RowId:"_+$g(%ROWID)_",TypeCode:"_typeCode_",TypeDesc:"_typeDesc_",TypeValueDes:"_valuedes_",TypeFlag:"_validFlag_",TypeExtCode:"_extCode_",TypeCreateUse:"_createUse_"}" 
 	.;s JsonStr=typeObj.GetDataStr()
 	.//s ^yxtest("JsonStr")=rJson
 	.s ret=typeObj.InsLog("A",rJson)
 	.;d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHCWL_CodeCfg.DHCWLCodeCfgType","DHCWL.CodeCfg.Type","类型代码维护",+$g(%ROWID),typeDesc,"A",JsonStr)
	e  d
	.s result="保存失败！"
	q result
}

//s dim("ID")=6

//s dim("TypeDesc")="afdfd"

//s dim("TypeCode")="test"

/// w ##class(DHCWL.CodeCfgData.SaveData).UpdateCodeType(.dim)
ClassMethod UpdateCodeType(ByRef dim) As %String
{
	n (dim,%session)
	s id=$g(dim("ID"))
	q:'$d(^DHCWL.CodeCfg.TypeD(id)) "请选择要更新的行！"
	s typeCode=$g(dim("TypeCode")) 
	s codeId=..GetCodecfgidByCode(typeCode)
	i id'=codeId q "代码不能修改！"
	s typeDesc=$g(dim("TypeDesc"))
	i typeDesc="" q "分类名称不能为空！"
	s extCode=$g(dim("TypeExtCode"))
	s valuedes=$g(dim("TypeValueDes"))
	s validFlag=$g(dim("TypeFlag"))
	s createUse=$g(dim("TypeCreateUse"))
	s typeObj=##class(DHCWL.CodeCfg.Type).%OpenId(id)
	s rJsonOld=typeObj.GetDataStr()
	s typeObj.TypeCode=$g(typeCode)
	s typeObj.TypeDesc=$g(typeDesc)
	s typeObj.TypeFlag=$g(validFlag)
	s typeObj.TypeExtCode=$g(extCode)
	s typeObj.TypeValueDes=$g(valuedes)
	s typeObj.TypeCreateDate=+$h
	s typeObj.TypeCreateUse=createUse
	s sc=typeObj.%Save()
	s rJson=typeObj.GetDataStr()
	s result="更新失败！"
	i sc=1 d
	.s result="ok"
	.s ret=typeObj.InsLog("U",rJson,rJsonOld)
	q result
}

/// w ##class(DHCWL.CodeCfgData.SaveData).DeleteCodeType("3")
ClassMethod DeleteCodeType(id) As %String
{
	n (id,%session)
	i +id=0 q "ok"
	s typeObj=##class(DHCWL.CodeCfg.Type).%OpenId(id)
	s rJson=typeObj.GetDataStr()
	s sc=##class(DHCWL.CodeCfg.Type).%DeleteId(id)
	s result="删除失败！"
	i sc=1 d
	.s result="ok"
	.s ret=typeObj.InsLog("D",rJson)
	q result
}

ClassMethod GetCodecfgidByCode(code) As %String
{
	
	n (code)
	q:code="" ""
	s id=$o(^DHCWL.CodeCfg.TypeI("Code"," "_$zcvt(code,"U"),""))
	q id
}

/// dim("GrpTypeDr")="测试"
/// dim("GrpCode")="fddadd"
/// dim("GrpDesc")="fddadd"
/// w ##class(DHCWL.CodeCfgData.SaveData).AddCodeGrp(.dim)
ClassMethod AddCodeGrp(ByRef dim) As %String
{
	n (dim,%session)
	s grpCode=$g(dim("GrpCode")) 
	s grpDesc=$g(dim("GrpDesc"))
	s id=..GetCodecfgGrpidByCode(grpCode)
	i id'="" q "代码不能重复！"
	s grpType=$g(dim("GrpTypeDr"))
	s grpTypeId=$o(^DHCWL.CodeCfg.TypeI("Desc"," "_$zcvt(grpType,"U"),""))
	s grpCreateUse=$g(dim("GrpCreateUse"))
	s GrpCreateDate=+$h
	//s grpDimDr=$g(dim("GrpDimDr"))
	s grpDimCode=$p($g(dim("GrpDimDr")),":",1)
	s grpDimDr=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$zcvt(grpDimCode,"U"),""))
	&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgGroup(Grp_Code,Grp_Desc,grp_type_dr,Grp_CreateUse,Grp_CreateDate,Grp_Dim_Dr) VALUES(:grpCode,:grpDesc,:grpTypeId,:grpCreateUse,:GrpCreateDate,:grpDimDr))
	//s typeObj=##class(DHCWL.CodeCfg.Group).%New()
	//s typeObj.GrpCode=$g(grpCode)
	//s typeObj.GrpDesc=$g(grpDesc)
	//s typeObj.GrpTypeDr=$g(grpTypeId)
	//s typeObj.GrpCreateUse=$g(grpCreateUse)
	//s typeObj.GrpCreateDate=+$h
	//s sc=typeObj.%Save()
	s id=+$g(%ROWID)
	s typeObj=##class(DHCWL.CodeCfg.Group).%OpenId(id)
	s rJson=typeObj.GetDataStr()
	s result="保存失败！"
	i SQLCODE=0  d  
	.s result="ok"          //++wk~2017-06-12~增加成功，收集信息保存日志
	.s grpID=..GetCodecfgGrpidByCode(grpCode)
	.s dim("operType")="新增"
	.s dim("modType")="归集大组"
	.;s dim("code")=grpCode_":"_grpDesc
	.;s dim("ID")=grpID
	.i (grpDimDr="")!('$d(^DHCWL.MKPI.MKPIDimTypeD(+grpDimDr))) s dimdesc=""
	.e  s dimdesc=$list(^DHCWL.MKPI.MKPIDimTypeD(grpDimDr),2)_":"_$list(^DHCWL.MKPI.MKPIDimTypeD(grpDimDr),3)
	.;s dim("afterInfor")="维度:"_dimdesc_";创建人:"_$g(grpCreateUse)_";创建时间:"_$zd($h,3)
	.;s dim("LogHeader")="ID"_"&"_"编码"_"&"_"描述"_"&"_"维度"_"&"_"创建人"
	.;s dim("LogInfor")="#"_grpID_"&#"_grpCode_"&#"_grpDesc_"&#"_dimdesc_"&#"_$g(grpCreateUse)
	.s dim("GrpModAttr")="编码:"_grpCode_","_"描述:"_grpDesc_","_"维度:"_dimdesc_","_"创建人:"_$g(grpCreateUse)
	.s dim("depMod")=grpCode_":"_grpDesc
	.s sc=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dim)
	.s ret=typeObj.InsLog("A",rJson)
	q result
}

ClassMethod GetCodecfgGrpidByCode(code) As %String
{
	
	n (code)
	q:code="" ""
	s id=$o(^DHCWL.CodeCfg.GroupI("Code"," "_$zcvt(code,"U"),""))
	q id
}

ClassMethod GetCodecfgSGrpidByCode(grpdr, code) As %String
{
	
	n (grpdr,code)
	q:code="" ""
	s id=$o(^DHCWL.CodeCfg.SubGroupI("Code",grpdr," "_$zcvt(code,"U"),""))
	q id
}

ClassMethod GetInterfaceidByCode(code) As %String
{
	
	n (code)
	q:code="" ""
	s id=$o(^DHCWL.CodeCfg.InterfaceI("Code"," "_$zcvt(code,"U"),""))
	q id
}

ClassMethod GetCodecfgGrptypeidByCode(typeid) As %String
{
	
	n (typeid)
	q:typeid="" ""
	s id=$o(^DHCWL.CodeCfg.GroupI("TypeDr",typeid,""))
	q id
}

/// w ##class(DHCWL.CodeCfgData.SaveData).GetCodecfgItemGrpidByCode("test5")
ClassMethod GetCodecfgItemGrpidByCode(code) As %String
{
	
	n (code)
	q:code="" ""
	s id=$o(^DHCWL.CodeCfg.ItemGroupI("Code"," "_$zcvt(code,"U"),""))
	q id
}

/// w ##class(DHCWL.CodeCfgData.SaveData).DeleteCodeGrp("3")
ClassMethod DeleteCodeGrp(id) As %String
{
	n (id,%session)
	i +id=0 q "ok"
	k dim
	
	//++add by wk~2017-06-14日志记录更新前数据
	s dim("operType")="删除"
	s dim("modType")="归集大组"
	s grpCode=$lg(^DHCWL.CodeCfg.GroupD(id),2)
	s grpDesc=$lg(^DHCWL.CodeCfg.GroupD(id),3)
	s grpDate=$lg(^DHCWL.CodeCfg.GroupD(id),8)
	s grpUser=$lg(^DHCWL.CodeCfg.GroupD(id),10)
	s grpDim=$lg(^DHCWL.CodeCfg.GroupD(id),11)
	s dimInfor=""
	i grpDim'="" d
	.s dimInfor=$lg($g(^DHCWL.MKPI.MKPIDimTypeD(grpDim)),2)_":"_$lg($g(^DHCWL.MKPI.MKPIDimTypeD(grpDim)),3)

	s typeObj=##class(DHCWL.CodeCfg.Group).%OpenId(id)
	s rJson=typeObj.GetDataStr()
	&sql(delete from DHCWL_CodeCfg.DHCWLCodeCfgGroup where ID=:id)
	s retsql=SQLCODE
	s result="删除失败！"
	i retsql=0 d
	.//++删除成功后，将信息保存到日志表中
	.;s dim("LogHeader")="ID"_"&"_"编码"_"&"_"描述"_"&"_"维度"_"&"_"创建人"
	.;s dim("LogInfor")=id_"&"_grpCode_"&"_grpDesc_"&"_dimInfor_"&"_grpUser
	.s dim("GrpModAttr")="编码:"_grpCode_","_"描述:"_grpDesc_","_"维度:"_dimInfor_","_"创建人:"_grpUser
	.s dim("depMod")=grpCode_":"_grpDesc
	.s sc=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dim)
	.s result="ok"
	.s ret=typeObj.InsLog("D",rJson)
	q result
}

/// w ##class(DHCWL.CodeCfgData.SaveData).UpdateCodeGrp(.dim)
ClassMethod UpdateCodeGrp(ByRef dim) As %String
{
	n (dim,%session)
	//s dim("GrpCode")="IPLocGrpx"
	//s dim("GrpCreateUse")="aaa"
	//s dim("GrpDesc")="111"
	//s dim("GrpTypeDr")="科室"
	//s dim("ID")=18
	s id=$g(dim("ID"))
	k dimLogList
	q:'$d(^DHCWL.CodeCfg.GroupD(id)) "请选择要更新的行！"
	s grpCode=$g(dim("GrpCode")) 
	s codeId=..GetCodecfgGrpidByCode(grpCode)
	i id'=codeId q "代码不能修改！"
	s grpDesc=$g(dim("GrpDesc"))
	i grpDesc="" q "名称不能为空！"
	//s grpType=$g(dim("GrpTypeDr"))
	//s grpTypeId=$o(^DHCWL.CodeCfg.TypeI("Desc"," "_$zcvt(grpType,"U"),""))
	//s codeIdByCode=..GetCodecfgGrptypeidByCode(grpTypeId)
	//s codeIdByCode=$li(^DHCWL.CodeCfg.GroupD(id),7)
	//i grpTypeId'=codeIdByCode q "类型不能修改！"
	s GrpCreateUse=$g(dim("GrpCreateUse"))
	s GrpCreateDate=+$h
	s grpDimCode=$p($g(dim("GrpDimDr")),":",1)
	s grpDimId=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$zcvt(grpDimCode,"U"),""))    //$g(dim("GrpDimDr"))
	s codeDimIdByCode=$li(^DHCWL.CodeCfg.GroupD(id),11)
	i (grpDimId'=codeDimIdByCode)&(codeDimIdByCode'="") q "维度类型不能修改！"
	s typeObj=##class(DHCWL.CodeCfg.Group).%OpenId(id)
	s rJsonOld=typeObj.GetDataStr()
	;d typeObj.%OnClose()
	s typeObj=""
	//++add by wk~2017-06-14日志记录更新前数据
	s code=$lg(^DHCWL.CodeCfg.GroupD(id),2)
	s desc=$lg(^DHCWL.CodeCfg.GroupD(id),3)
	s grpUser=$lg(^DHCWL.CodeCfg.GroupD(id),10)
	s grpDim=$lg(^DHCWL.CodeCfg.GroupD(id),11)
	s dimInfor=""
	i grpDim'="" d
	s dimInfor=$lg($g(^DHCWL.MKPI.MKPIDimTypeD(grpDim)),2)_":"_$lg($g(^DHCWL.MKPI.MKPIDimTypeD(grpDim)),3)
	//插入数据
	&sql(update DHCWL_CodeCfg.DHCWLCodeCfgGroup set Grp_Code=:grpCode,Grp_Desc=:grpDesc,grp_type_dr=:grpTypeId,Grp_CreateUse=:GrpCreateUse,Grp_CreateDate=:GrpCreateDate where ID=:id)
	s typeObj=##class(DHCWL.CodeCfg.Group).%OpenId(id)
	s rJson=typeObj.GetDataStr()
	s result="更新失败！"
	i SQLCODE=0 d
	.//++add by wk~2017-06-14 操作成功后整理内容插入到日志表中
	.s dimLogList("operType")="更新"
	.s dimLogList("modType")="归集大组"
	.;s dimLogList("LogHeader")="ID"_"&"_"编码"_"&"_"描述"_"&"_"维度"_"&"_"创建人"
	.;s dimLogList("LogInfor")=id_"#"_id_"&"_code_"#"_$g(dim("GrpCode"))_"&"_desc_"#"_$g(dim("GrpDesc"))_"&"_dimInfor_"#"_dimInfor_"&"_grpUser_"#"_$g(dim("GrpCreateUse"))
	.s dimLogList("depMod")=code_":"_desc
	.s GrpModAttr=""
	.if (desc'=$g(dim("GrpDesc"))) d
	..s GrpModAttr="描述: "_desc_" -> "_$g(dim("GrpDesc"))
	.if (grpUser'=$g(dim("GrpCreateUse"))) d
	..s GrpModAttr=GrpModAttr_" 创建人: "_grpUser_" -> "_$g(dim("GrpCreateUse"))
	.s dimLogList("GrpModAttr")=GrpModAttr
	.s sc=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList)
	.s result="ok"
	.s ret=typeObj.InsLog("U",rJson,rJsonOld)
	q result
}

/// w ##class(DHCWL.CodeCfgData.SaveData).DeleteCodeSubGrp("3")
ClassMethod DeleteCodeSubGrp(id) As %String
{
	n (id,%session)
	i +id=0 q "ok"
	//s sc=##class(DHCWL.CodeCfg.SubGroup).%DeleteId(id)
	//i sc=1 q "ok"
	s typeObj=##class(DHCWL.CodeCfg.SubGroup).%OpenId(id)
	s rJson=typeObj.GetDataStr()
	&sql(delete from DHCWL_CodeCfg.DHCWLCodeCfgSubGroup where ID=:id)
	s retsql=SQLCODE
	i retsql=0 d
	.&sql(delete from DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem where sgrpim_sgrp_dr=:id)
	.s retsql=$G(retsql)+SQLCODE
	s result="删除失败！"
	i (retsql=0)!(retsql=100) d
	.s result="ok"
	.s ret=typeObj.InsLog("D",rJson)
	//i retsql=0  d
    //.//Tcommit
    ///e  d
    //.//Trollback
	q result
}

//creator:wk

//data:2016-11-24

//描述：删除统计子组树节点

//other:w ##class(DHCWL.CodeCfgData.SaveData).DeleteCodeSubTreeGrp("3")

ClassMethod DeleteCodeSubTreeGrp(id) As %String
{
	n (id,%session)
	if $d(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",id)) q "error"
	s grpDr=$lg(^DHCWL.CodeCfg.SubGroupD(id),4)
	s grpTreeCode=$lg(^DHCWL.CodeCfg.SubGroupD(id),7)
	s subGrpID=""
	k subGrpIDList
	//+add by wk~2017-06-14~删除归集子组之前记录信息放便记录日志
	s oldSubGrpCode=$lg(^DHCWL.CodeCfg.SubGroupD(id),2)
	s oldSubGrpDesc=$lg(^DHCWL.CodeCfg.SubGroupD(id),3)
	s oldSubGrpDr=$lg(^DHCWL.CodeCfg.SubGroupD(id),4)
	s oldGrpInfor=$lg(^DHCWL.CodeCfg.GroupD(oldSubGrpDr),2)_":"_$lg(^DHCWL.CodeCfg.GroupD(oldSubGrpDr),3)_"."_$lg(^DHCWL.CodeCfg.SubGroupD(id),2)_":"_$lg(^DHCWL.CodeCfg.SubGroupD(id),3)
	s oldSubGrpSort=$lg(^DHCWL.CodeCfg.SubGroupD(id),5)
	s oldSubGrpTreeCode=$lg(^DHCWL.CodeCfg.SubGroupD(id),6)
	s:oldSubGrpTreeCode'="" oldSubGrpTreeCode=$p(oldSubGrpTreeCode,".",2,$l(oldSubGrpTreeCode,"."))
	s oldSubGrpPTreeCode=$lg(^DHCWL.CodeCfg.SubGroupD(id),7)
	s:oldSubGrpPTreeCode'="" oldSubGrpPTreeCode=$p(oldSubGrpPTreeCode,".",2,$l(oldSubGrpPTreeCode,"."))
	s oldSubGrplevel=$lg(^DHCWL.CodeCfg.SubGroupD(id),8)
	
	&sql(delete from DHCWL_CodeCfg.DHCWLCodeCfgSubGroup where ID=:id)
	s retsql=SQLCODE
	i retsql=0 {
		for{
		s subGrpID=$o(^DHCWL.CodeCfg.SubGroupI("GrpPTreeCode",grpDr," "_$zcvt(grpTreeCode,"U"),subGrpID))
		q:subGrpID=""
		s sort=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),5)
		s subGrpIDList(sort,subGrpID)=""
		}
		s sort=""
		s num=1
		s errorFlag=0
		for{
			s sort=$o(subGrpIDList(sort))
			q:sort=""
			s subGrpID=""
			for{
				s subGrpID=$o(subGrpIDList(sort,subGrpID))
				q:subGrpID=""
				&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroup set SGrp_Sort=:num where ID=:subGrpID)
				s sqlvalue=SQLCODE
				if (sqlvalue'=0){
					s errorFlag=1
					q
				}
				s num=num+1
			}
			q:errorFlag=1
		}
		if (errorFlag=0){
			//add by wk~2017-06-14~将信息保存到日志表中
			k dimLogList
			s dimLogList("operType")="删除"
			s dimLogList("modType")="归集子组"
			s dimLogList("depMod")=oldGrpInfor
			s dimLogList("GrpModAttr")="编码:"_oldSubGrpCode_","_"描述:"_oldSubGrpDesc_","_"排序值:"_oldSubGrpSort_","_"当前节点:"_oldSubGrpTreeCode_","_"父节点:"_oldSubGrpPTreeCode_","_"层级:"_oldSubGrplevel
			//s dimLogList("LogHeader")="ID"_"&"_"编码"_"&"_"描述"_"&"_"排序值"_"&"_"当前节点"_"&"_"父节点"_"&"_"层级"
			//s dimLogList("LogInfor")=id_"&"_oldSubGrpCode_"&"_oldSubGrpDesc_"&"_oldSubGrpSort_"&"_oldSubGrpTreeCode_"&"_oldSubGrpPTreeCode_"&"_oldSubGrplevel
			s sc=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList)
			q "ok"
		}else{
			q "false"
		}
	}
	q "false"
}

/// dim("GrpTypeDr")="测试"
/// dim("GrpCode")="fddadd"
/// dim("GrpDesc")="fddadd"
/// w ##class(DHCWL.CodeCfgData.SaveData).AddCodeSubGrp(.dim)
ClassMethod AddCodeSubGrp(ByRef dim) As %String
{
	n (dim,%session)
	s sGrpCode=$g(dim("SGrpCode")) 
	s sGrpDesc=$g(dim("SGrpDesc"))
	s sGrpGrpDr=$g(dim("SGrpGrpDr"))
	s id=..GetCodecfgSGrpidByCode(sGrpGrpDr,sGrpCode)
	i id'="" q "代码不能重复！"
	s sGrpSort=$g(dim("SGrpSort"))
	&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgSubGroup(SGrp_Code,SGrp_Desc,SGrp_Grp_Dr,SGrp_Sort) VALUES(:sGrpCode,:sGrpDesc,:sGrpGrpDr,:sGrpSort))
	s id=+$g(%ROWID)
	s typeObj=##class(DHCWL.CodeCfg.SubGroup).%OpenId(id)
	s rJson=typeObj.GetDataStr()
	s result="保存失败！"
	//s typeObj=##class(DHCWL.CodeCfg.Group).%New()
	//s typeObj.GrpCode=$g(grpCode)
	//s typeObj.GrpDesc=$g(grpDesc)
	//s typeObj.GrpTypeDr=$g(grpTypeId)
	//s typeObj.GrpCreateUse=$g(grpCreateUse)
	//s typeObj.GrpCreateDate=+$h
	//s sc=typeObj.%Save()
	i SQLCODE=0 d
	.s result="ok"
	.s ret=typeObj.InsLog("A",rJson)
	//i sc=1 q "ok"
	q result
}

/// creator:wk~2016-11-25
/// desc   :增加第一层归集子组
/// 
/// w ##class(DHCWL.CodeCfgData.SaveData).AddCodeTreeSubGrp(.dim)
ClassMethod AddCodeTreeSubGrp(ByRef dim) As %String
{
	n (dim,%session)
	s sGrpCode=$g(dim("SGrpCode")) 
	s sGrpDesc=$g(dim("SGrpDesc"))
	s sGrpGrpDr=$g(dim("SGrpGrpDr"))
	s id=..GetCodecfgSGrpidByCode(sGrpGrpDr,sGrpCode)
	i id'="" q "代码不能重复！"
	s signSort=0
	s subgrpId=""
	for{
		s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpPTreeCode",sGrpGrpDr," "_$zcvt("root","U"),subgrpId))
		q:subgrpId=""
		s sort=$lg(^DHCWL.CodeCfg.SubGroupD(subgrpId),5)
		if (sort'="")&(sort>signSort){
			s signSort=sort
		}
	}
	s signSort=signSort+1
	s sGrpSort=signSort
	s treeCode="root."_sGrpCode
	s pTreeCode="root"
	s level=1
	set subGroupObj=##class(DHCWL.CodeCfg.SubGroup).%New()
	if subGroupObj=""{
		q 0
	}
	set groupObj=##class(DHCWL.CodeCfg.Group).%OpenId(sGrpGrpDr)
	if groupObj=""{
		q "打开对象失败"
	}
	s subGroupObj.SGrpCode=sGrpCode
	s subGroupObj.SGrpDesc=sGrpDesc
	s subGroupObj.SGrpGrpDr=groupObj
	s subGroupObj.SGrpLevel=level
	s subGroupObj.SGrpPTreeCode=pTreeCode
	s subGroupObj.SGrpSort=sGrpSort
	s subGroupObj.SGrpTreeCode=treeCode
	s result=subGroupObj.%Save()
	if result'=1{
		q "保存失败"
	}
	//++add by wk~保存成功时记录日志信息
	k dimLogList
	s dimLogList("operType")="新增"
	s dimLogList("modType")="归集子组"
	s dimLogList("depMod")=$lg($g(^DHCWL.CodeCfg.GroupD(sGrpGrpDr)),2)_":"_$lg($g(^DHCWL.CodeCfg.GroupD(sGrpGrpDr)),3)_"."_sGrpCode_":"_sGrpDesc
	s id=..GetCodecfgSGrpidByCode(sGrpGrpDr,sGrpCode)
	s dimLogList("GrpModAttr")="编码:"_sGrpCode_","_"描述:"_sGrpDesc_","_"排序值:"_sGrpSort_","_"当前节点:"_sGrpCode_","_"父节点:"_","_"层级:"_level
	;s dimLogList("LogHeader")="ID"_"&"_"编码"_"&"_"描述"_"&"_"层级"_"&"_"父节点"_"&"_"排序值"_"&"_"当前节点"
	;s dimLogList("LogInfor")="#"_id_"&#"_sGrpCode_"&#"_sGrpDesc_"&#"_level_"&#"_pTreeCode_"&#"_sGrpSort_"&#"_treeCode
	s sc=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList)
	q "ok"
}

/// w ##class(DHCWL.CodeCfgData.SaveData).UpdateCodeSubGrp(.dim)
ClassMethod UpdateCodeSubGrp(ByRef dim) As %String
{
	n (dim,%session)
	s id=$g(dim("ID"))
	q:'$d(^DHCWL.CodeCfg.SubGroupD(id)) "请选择要更新的行！"
	s sGrpCode=$g(dim("SGrpCode"))
	//s codeId=..GetCodecfgGrpidByCode(grpCode)
	//i id'=codeId q "代码不能修改！"
	s sGrpDesc=$g(dim("SGrpDesc"))
	i sGrpDesc="" q "名称不能为空！"
	s sGrpGrpDr=$g(dim("SGrpGrpDr"))
	s codeId=..GetCodecfgSGrpidByCode(sGrpGrpDr,sGrpCode)
	i id'=codeId q "代码不能修改！"
	s oldGrpDesc=$lg(^DHCWL.CodeCfg.SubGroupD(id),3)  //add by wk~2017-06-14~为记录日志信息
	//i id'="" q "代码不能重复！"
	s sGrpSort=$g(dim("SGrpSort"))
	s typeObj=##class(DHCWL.CodeCfg.SubGroup).%OpenId(id)
	s rJsonOld=typeObj.GetDataStr()
	s typeObj=""
	&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroup set SGrp_Desc=:sGrpDesc where ID=:id)
	s typeObj=##class(DHCWL.CodeCfg.SubGroup).%OpenId(id)
	s rJson=typeObj.GetDataStr()
	s result="更新失败！"
	i SQLCODE=0 d
	.s result="ok"
	.//++add by wk~2017-06-14~将更新的内容保存到日志表中
	.k dimLogList
	.s dimLogList("operType")="更新"
	.s dimLogList("modType")="归集子组"
	.s dimLogList("depMod")=$lg($g(^DHCWL.CodeCfg.GroupD(sGrpGrpDr)),2)_":"_$lg($g(^DHCWL.CodeCfg.GroupD(sGrpGrpDr)),3)_"."_sGrpCode_":"_sGrpDesc
	.;s dimLogList("LogHeader")="ID"_"&"_"编码"_"&"_"描述"_"&"_"排序值"
	.;s dimLogList("LogInfor")=id_"#"_id_"&"_sGrpCode_"#"_sGrpCode_"&"_oldGrpDesc_"#"_sGrpDesc_"&"_sGrpSort_"#"_sGrpSort
	.if (oldGrpDesc'=sGrpDesc) s dimLogList("GrpModAttr")="描述:"_oldGrpDesc_" -> "_sGrpDesc
	.s sc=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList)
	.s ret=typeObj.InsLog("U",rJson,rJsonOld)
	q result
}

/// w ##class(DHCWL.CodeCfgData.SaveData).DeleteSubGrpDetail("3")
ClassMethod DeleteSubGrpDetail(id) As %String
{
	n (id,%session)
	i +id=0 q "ok"
	//++add by wk~2016-06-14~获取被删除的子组明细信息准备日志记录
	s grpID=$lg(^DHCWL.CodeCfg.SubGroupItemD(id),4)
	s grpSubID=$lg(^DHCWL.CodeCfg.SubGroupItemD(id),3)
	s depModGrp=$lg($g(^DHCWL.CodeCfg.GroupD(grpID)),2)_":"_$lg($g(^DHCWL.CodeCfg.GroupD(grpID)),3)_","_$lg($g(^DHCWL.CodeCfg.SubGroupD(grpSubID)),2)_":"_$lg($g(^DHCWL.CodeCfg.SubGroupD(grpSubID)),3)
	//s depModGrp=$lg($g(^DHCWL.CodeCfg.GroupD(grpID)),2)_","_$lg($g(^DHCWL.CodeCfg.SubGroupD(grpSubID)),2)
	s dimDr=$lg(^DHCWL.CodeCfg.GroupD(grpID),11) //获取维度
	s itemId=$lg(^DHCWL.CodeCfg.SubGroupItemD(id),2)
 	;s itemId=$tr(itemId," ")
 	;s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(dimDr,itemId)
	;s LogInfor=itemId_":"_itemDesc
	
	s typeObj=##class(DHCWL.CodeCfg.SubGroupItem).%OpenId(id)
	s rJson=typeObj.GetDataStr()
	s sc=##class(DHCWL.CodeCfg.SubGroupItem).%DeleteId(id)
	s result="删除失败！"
	i sc=1 d
	.d ##class(DHCWL.CodeCfgData.SaveData).updateForTJZZItem(depModGrp,itemId,dimDr,"Del")
	.;if ('$d(^TEMPDHCWL("olnyForGrpLog","TJZZ","depMod"))) d
	..;s ^TEMPDHCWL("olnyForGrpLog","TJZZ","depMod")=depModGrp
	.;s num=+$g(^TEMPDHCWL("olnyForGrpLog","TJZZ"))+1
	.;s ^TEMPDHCWL("olnyForGrpLog","TJZZ")=num
	.;s ^TEMPDHCWL("olnyForGrpLog","TJZZ","Data",num,"Del")=LogInfor
	.s result="ok"
	.s ret=typeObj.InsLog("D",rJson)
	q result
}

/// w ##class(DHCWL.CodeCfgData.SaveData).DeleteSubGrpAllDetail("3")
ClassMethod DeleteSubGrpAllDetail(subid) As %String
{
	n (subid,%session)
	i +subid=0 q "ok"
	k dimLogList
	s grpId=$lg($g(^DHCWL.CodeCfg.SubGroupD(subid)),4)
 	s depModGrp=$lg($g(^DHCWL.CodeCfg.GroupD(grpId)),2)_":"_$lg($g(^DHCWL.CodeCfg.GroupD(grpId)),3)_"."_$lg($g(^DHCWL.CodeCfg.SubGroupD(subid)),2)_":"_$lg($g(^DHCWL.CodeCfg.SubGroupD(subid)),3)
 	//s depModGrp=$lg($g(^DHCWL.CodeCfg.GroupD(grpId)),2)_"."_$lg($g(^DHCWL.CodeCfg.SubGroupD(subid)),2)
	s dimDr=$lg(^DHCWL.CodeCfg.GroupD(grpId),11)
	
	s itemId=0 f  s itemId=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subid,itemId)) q:itemId=""  d
	.s id=0 f  s id=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subid,itemId,id)) q:id=""  d
	..s typeObj=##class(DHCWL.CodeCfg.SubGroupItem).%OpenId(id)
	..s rJson=typeObj.GetDataStr()
	..&sql(delete from DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem where ID=:id)
	..s retsqlcode=$g(retsqlcode)+SQLCODE
	..i SQLCODE=0 d   //代码升级~modify by wk~2017-11-14
	...d ##class(DHCWL.CodeCfgData.SaveData).updateForTJZZItem(depModGrp,itemId,dimDr,"DelAll")
	...;if ('$d(^TEMPDHCWL("olnyForGrpLog","TJZZ","depMod"))) d
	....;s ^TEMPDHCWL("olnyForGrpLog","TJZZ","depMod")=depModGrp
	...;s itemId=$tr(itemId," ")
 	...;s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(dimDr,itemId)
 	...;s LogInfor=itemId_":"_itemDesc
 	...;s num=+$g(^TEMPDHCWL("olnyForGrpLog","TJZZ"))+1
	...;s ^TEMPDHCWL("olnyForGrpLog","TJZZ")=num
 	...;s ^TEMPDHCWL("olnyForGrpLog","TJZZ","Data",num,"DelAll")=LogInfor
	...s ret=typeObj.InsLog("D",rJson)
	s result="删除失败！"
	i retsqlcode=0 d
	.s result="ok"
	q result
}

/// w ##class(DHCWL.CodeCfgData.SaveData).AddSubGrpItem(.dim)
ClassMethod AddSubGrpItem(ByRef dim) As %String
{
	n (dim,%session)
	s grpId=$g(dim("GrpId")) 
	s subGrpId=$g(dim("SubGrpId"))
	s itemPara=$g(dim("selectItemPara"))
	s selectItemCode=$g(dim("selectItemCode"))
	f count=1:1:$l(itemPara,"-") d
	.s itemId=$p(itemPara,"-",count)
	.s itemCode=$p(selectItemCode,"@",count)
	.s ret=..SaveData()
	.s sqlPara=$g(sqlPara)+ret
	//q:$d(^DHCWL.CodeCfg.SubGroupItemI("Grp",grpId," "_itemId)) "该组已添加过此项目，不能重复添加"
	//&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem(SGrpIM_Grp_Dr,SGrpIM_SGrp_Dr,SGrpIM_Item_DR) VALUES(:grpId,:subGrpId,:itemId))
	i ret=0 q "ok"
	q ret
	q "保存失败！"
}

ClassMethod SaveData() As %String
{
 s dtId=$o(^DHCWL.CodeCfg.SubGroupItemI("Grp",grpId," "_$ZCVT(itemId,"U"),""))
 i dtId'="" d
 .s sGrpId=$list(^DHCWL.CodeCfg.SubGroupItemD(dtId),3)
 .s sGrpDes=$list(^DHCWL.CodeCfg.SubGroupD(sGrpId),3)
 q:dtId'="" "已在"_sGrpDes_"子组中添加过此项目，不能重复添加!"
 s sort=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpSort",subGrpId,""),-1)
 s sort=sort+1
 &sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem(SGrpIM_Grp_Dr,SGrpIM_SGrp_Dr,SGrpIM_Item_DR,SGrpIM_Item_Code,SGrpIM_Sort) VALUES(:grpId,:subGrpId,:itemId,:itemCode,:sort))
 s id=+$g(%ROWID)
 //s typeObj=##class(DHCWL.CodeCfg.SubGroupItem).%New()
 s typeObj=##class(DHCWL.CodeCfg.SubGroupItem).%OpenId(id)
 s rJson=typeObj.GetDataStr()
 i SQLCODE=0  d
 .//++add by wk~获取统计子组明细内容记录到日志中~2017-06-14
 .if ('$d(^TEMPDHCWL("olnyForGrpLog","TJZZ","depMod"))) d
 ..s ^TEMPDHCWL("olnyForGrpLog","TJZZ","depMod")=$lg($g(^DHCWL.CodeCfg.GroupD(grpId)),2)_":"_$lg($g(^DHCWL.CodeCfg.GroupD(grpId)),3)_"."_$lg($g(^DHCWL.CodeCfg.SubGroupD(subGrpId)),2)_":"_$lg($g(^DHCWL.CodeCfg.SubGroupD(subGrpId)),3)
 .s dimDr=$lg(^DHCWL.CodeCfg.GroupD(grpId),11) //获取维度
 .s itemId=$tr(itemId," ")
 .s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(dimDr,itemId)
 .s num=+$g(^TEMPDHCWL("olnyForGrpLog","TJZZ"))+1
 .s ^TEMPDHCWL("olnyForGrpLog","TJZZ")=num
 .s ^TEMPDHCWL("olnyForGrpLog","TJZZ","Data",num,"Add")=itemId_":"_itemDesc
 .s ret=typeObj.InsLog("A",rJson)
 s ^yxtest("derjson")=rJson
 q SQLCODE
}

/// w ##class(DHCWL.CodeCfgData.SaveData).AddCodeInterface(.dim)
ClassMethod AddCodeInterface(ByRef dim) As %String
{
	n (dim,%session)
	s interCode=$g(dim("InterCode")) 
	i interCode="" q "接口代码不能为空！"
	s id=..GetInterfaceidByCode(interCode)
	i id'="" q "编码不能重复！"
	s interDesc=$g(dim("InterDesc"))
	i interDesc="" q "接口名称不能为空！"
	s interCreateUse=$g(dim("InterCreateUse"))
	s typeObj=##class(DHCWL.CodeCfg.Interface).%New()
	s typeObj.InterCode=$g(interCode)
	s typeObj.InterDesc=$g(interDesc)
	s typeObj.InterCreateUse=$g(interCreateUse)
	s typeObj.InterCreateDate=+$h
	s sc=typeObj.%Save()
	i sc=1 q "ok"
	q "保存失败！"
}

/// w ##class(DHCWL.CodeCfgData.SaveData).UpdateCodeInterface(.dim)
ClassMethod UpdateCodeInterface(ByRef dim) As %String
{
	n (dim,%session)
	s id=$g(dim("ID"))
	q:'$d(^DHCWL.CodeCfg.InterfaceD(id)) "请选择要更新的行！"
	s interCode=$g(dim("InterCode")) 
	s interDesc=$g(dim("InterDesc"))
	i interDesc="" q "分类名称不能为空！"
	s interCreateUse=$g(dim("InterCreateUse"))
	s typeObj=##class(DHCWL.CodeCfg.Interface).%OpenId(id)
	s typeObj.InterCode=$g(interCode)
	s typeObj.InterDesc=$g(interDesc)
	s typeObj.InterCreateUse=$g(interCreateUse)
	s typeObj.InterCreateDate=+$h
	s sc=typeObj.%Save()
	i sc=1 q "ok"
	q "更新失败！"
}

/// w ##class(DHCWL.CodeCfgData.SaveData).DeleteCodeInterface("3")
ClassMethod DeleteCodeInterface(id) As %String
{
	n (id,%session)
	i +id=0 q "ok"
	s sc=##class(DHCWL.CodeCfg.Interface).%DeleteId(id)
	i sc=1 q "ok"
	q "删除失败！"
}

/// dim("GrpTypeDr")="测试"
/// dim("GrpCode")="fddadd"
/// dim("GrpDesc")="fddadd"
/// w ##class(DHCWL.CodeCfgData.SaveData).AddInterfaceContrast(.dim)
ClassMethod AddInterfaceContrast(ByRef dim) As %String
{
	n (dim,%session)
	s choiceTypeId=$g(dim("choiceTypeId")) 
	s choiceInterfaceId=$g(dim("choiceInterfaceId"))
	s choiceHisId=$g(dim("choiceHisId"))
	s InterItem=$g(dim("InterItem"))
	&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgContrast(Contr_Interface_Dr,Contr_Type_Dr,Contr_HisItem_Dr,Contr_InterItem_Dr) VALUES(:choiceInterfaceId,:choiceTypeId,:choiceHisId,:InterItem))
	i SQLCODE=0 q "ok"
	q "保存失败！"
}

/// w ##class(DHCWL.CodeCfgData.SaveData).DeleteInterfaceContrast("3")
ClassMethod DeleteInterfaceContrast(id) As %String
{
	n (id)
	i +id=0 q "ok"
	s sc=##class(DHCWL.CodeCfg.Contrast).%DeleteId(id)
	i sc=1 q "ok"
	q "删除失败！"
}

/// w ##class(DHCWL.CodeCfgData.SaveData).UpdateInterfaceContrast(.dim)
ClassMethod UpdateInterfaceContrast(ByRef dim) As %String
{
	n (dim,%session)
	s id=$g(dim("ID"))
	//s ^yxtest("id")=id
	q:'$d(^DHCWL.CodeCfg.ContrastD(id)) "请选择要更新的行！"
	//s TypeId=$g(dim("choiceTypeId")) 
	//s codeId=..GetCodecfgGrpidByCode(grpCode)
	//i id'=codeId q "代码不能修改！"
	//s InterfaceId=$g(dim("choiceInterfaceId"))
	//i grpDesc="" q "名称不能为空！"
	s HisId=$g(dim("choiceHisId"))
	s InterItem=$g(dim("InterItem"))
	&sql(update DHCWL_CodeCfg.DHCWLCodeCfgContrast set Contr_HisItem_Dr=:HisId,Contr_InterItem_Dr=:InterItem where ID=:id)
	i SQLCODE=0 q "ok"
	q "更新失败！"
}

/// w ##class(DHCWL.CodeCfgData.SaveData).UpdateSgrpSort(strPara)
ClassMethod UpdateSgrpSort(ByRef strPara) As %String
{
	n (strPara,%session)
	s flag=0
	q:strPara="" "无条目信息怎么更新！"
	s ret="更新失败！"
	s len=$l(strPara,"-")
	f i=1:1:len d
	.s id=$p($P(strPara,"-",i),"*",1)
	.s sort=$p($P(strPara,"-",i),"*",2)
	.s sortById=$list(^DHCWL.CodeCfg.SubGroupD(id),5)
	.i sortById=sort s flag=$g(flag)+1
	.q:sortById=sort
	.&sql(update DHCWL_CodeCfg.DHCWLCodeCfgSubGroup set SGrp_Sort=:sort where ID=:id)
	.i SQLCODE=0 s ret="ok"
	q:flag=len "请上下拖动条目顺序后再来更新排序吧！"
	q ret
}

ClassMethod AddCodeItemGrp(ByRef dim) As %String
{
	n (dim,%session)
	s grpCode=$g(dim("GrpCode")) 
	s grpDesc=$g(dim("GrpDesc"))
	s id=..GetCodecfgItemGrpidByCode(grpCode)
	i id'="" q "代码不能重复！"
	s grpType=$g(dim("GrpTypeDr"))
	s grpTypeId=$o(^DHCWL.CodeCfg.TypeI("Desc"," "_$zcvt(grpType,"U"),""))
	s grpCreateUse=$g(dim("GrpCreateUse"))
	s GrpCreateDate=+$h
	//s grpDimId=$g(dim("GrpDimDr"))
	s grpDimCode=$p($g(dim("GrpDimDr")),":",1)
	s grpDimId=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$zcvt(grpDimCode,"U"),""))
	&sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgItemGroup(ItemGrp_Code,ItemGrp_Desc,Itemgrp_type_dr,ItemGrp_CreateUse,ItemGrp_CreateDate,ItemGrp_Dim_Dr) VALUES(:grpCode,:grpDesc,:grpTypeId,:grpCreateUse,:GrpCreateDate,:grpDimId))
	s id=+$g(%ROWID)
	s typeObj=##class(DHCWL.CodeCfg.ItemGroup).%OpenId(id)
	s rJson=typeObj.GetDataStr()
	s result="保存失败！"
	i SQLCODE=0  d  
	.k dimLogList
	.s dimLogList("operType")="新增"
	.s dimLogList("modType")="统计大组"
	.i (grpDimId="")!('$d(^DHCWL.MKPI.MKPIDimTypeD(+grpDimId))) s dimdesc=""
	.e  s dimdesc=$list(^DHCWL.MKPI.MKPIDimTypeD(grpDimId),2)_":"_$list(^DHCWL.MKPI.MKPIDimTypeD(grpDimId),3)
	.;s dimLogList("LogHeader")="ID"_"&"_"编码"_"&"_"描述"_"&"_"维度"_"&"_"创建人"
	.;s dimLogList("LogInfor")="#"_id_"&#"_grpCode_"&#"_grpDesc_"&#"_dimdesc_"&#"_$g(grpCreateUse)
	.s dimLogList("depMod")=$g(grpCode)_":"_$g(grpDesc)
	.s dimLogList("GrpModAttr")="编码:"_grpCode_" ,描述:"_grpDesc_" ,维度:"_dimdesc_" ,创建人:"_$g(grpCreateUse)
	.s sc=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList)
	.s result="ok"
	.s ret=typeObj.InsLog("A",rJson)
	q result
}

/// w ##class(DHCWL.CodeCfgData.SaveData).UpdateCodeItemGrp(.dim)
ClassMethod UpdateCodeItemGrp(ByRef dim) As %String
{
	n (dim,%session)
	s id=$g(dim("ID"))
	q:'$d(^DHCWL.CodeCfg.ItemGroupD(id)) "请选择要更新的行！"
	s grpCode=$g(dim("GrpCode")) 
	s codeId=..GetCodecfgItemGrpidByCode(grpCode)
	i id'=codeId q "代码不能修改！"
	//add by wk~2017-06-15~记录更新前大组的信息
	s oldGrpDesc=$lg(^DHCWL.CodeCfg.ItemGroupD(id),3)
	s oldGrpUser=$lg(^DHCWL.CodeCfg.ItemGroupD(id),7)
	s oldGrpDim=$lg(^DHCWL.CodeCfg.ItemGroupD(id),8)
	s dimInfor=""
	i oldGrpDim'="" d
	s dimInfor=$lg($g(^DHCWL.MKPI.MKPIDimTypeD(oldGrpDim)),2)_":"_$lg($g(^DHCWL.MKPI.MKPIDimTypeD(oldGrpDim)),3)
	
	s grpDesc=$g(dim("GrpDesc"))
	i grpDesc="" q "名称不能为空！"
	s grpType=$g(dim("GrpTypeDr"))
	s grpTypeId=$o(^DHCWL.CodeCfg.TypeI("Desc"," "_$zcvt(grpType,"U"),""))
	s codeIdByCode=$li(^DHCWL.CodeCfg.ItemGroupD(id),4)
	i grpTypeId'=codeIdByCode q "类型不能修改！"
	s GrpCreateUse=$g(dim("GrpCreateUse"))
	s GrpCreateDate=+$h
	s grpDimCode=$p($g(dim("GrpDimDr")),":",1)
	s grpDimId=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$zcvt(grpDimCode,"U"),""))    //$g(dim("GrpDimDr"))
	s codeDimIdByCode=$li(^DHCWL.CodeCfg.ItemGroupD(id),8)
	i (grpDimId'=codeDimIdByCode)&(codeDimIdByCode'="") q "维度类型不能修改！"
	s typeObj=##class(DHCWL.CodeCfg.ItemGroup).%OpenId(id)
	s rJsonOld=typeObj.GetDataStr()
	;d typeObj.%OnClose()
	s typeObj=""
	//modify by wk~2017-06-15~不能修改的信息不做更新操作。
	//&sql(update DHCWL_CodeCfg.DHCWLCodeCfgItemGroup set ItemGrp_Code=:grpCode,ItemGrp_Desc=:grpDesc,Itemgrp_type_dr=:grpTypeId,ItemGrp_CreateUse=:GrpCreateUse,ItemGrp_CreateDate=:GrpCreateDate,ItemGrp_Dim_Dr=:grpDimId where ID=:id)
	&sql(update DHCWL_CodeCfg.DHCWLCodeCfgItemGroup set ItemGrp_Desc=:grpDesc,ItemGrp_CreateUse=:GrpCreateUse,ItemGrp_CreateDate=:GrpCreateDate where ID=:id)
	s typeObj=##class(DHCWL.CodeCfg.ItemGroup).%OpenId(id)
	s rJson=typeObj.GetDataStr()
	s result="更新失败！"
	i SQLCODE=0 d
	.k dimLogList
	.s dimLogList("operType")="更新"
	.s dimLogList("modType")="统计大组"
	.;s dimLogList("LogHeader")="ID"_"&"_"编码"_"&"_"描述"_"&"_"维度"_"&"_"创建人"
	.;s dimLogList("LogInfor")=id_"#"_id_"&"_$g(dim("GrpCode"))_"#"_$g(dim("GrpCode"))_"&"_oldGrpDesc_"#"_$g(dim("GrpDesc"))_"&"_dimInfor_"#"_dimInfor_"&"_oldGrpUser_"#"_$g(dim("GrpCreateUse"))
	.s dimLogList("depMod")=$g(dim("GrpCode"))_":"_$g(dim("GrpDesc"))
	.s grpModAttr=""
	.if (oldGrpDesc'=$g(dim("GrpDesc"))) s grpModAttr="描述:"_oldGrpDesc_"->"_$g(dim("GrpDesc"))
	.if (oldGrpUser'=$g(dim("GrpCreateUse"))) s grpModAttr=grpModAttr_" 创建者:"_oldGrpUser_"->"_$g(dim("GrpCreateUse"))
	.s dimLogList("GrpModAttr")=grpModAttr
	.s sc=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList)
	.s result="ok"
	.s ret=typeObj.InsLog("U",rJson,rJsonOld)
	q result
}

/// w ##class(DHCWL.CodeCfgData.SaveData).DeleteCodeItemGrp("3")
ClassMethod DeleteCodeItemGrp(id) As %String
{
	n (id,%session)
	i +id=0 q "ok"
	
	//++add by wk~2017-06-14日志记录更新前数据
	k dimLogList
	s dimLogList("operType")="删除"
	s dimLogList("modType")="统计大组"
	s itemGrpCode=$lg(^DHCWL.CodeCfg.ItemGroupD(id),2)
	s itemGrpDesc=$lg(^DHCWL.CodeCfg.ItemGroupD(id),3)
	s itemGrpUser=$lg(^DHCWL.CodeCfg.ItemGroupD(id),7)
	s itemGrpDim=$lg(^DHCWL.CodeCfg.ItemGroupD(id),8)
	s dimInfor=""
	i itemGrpDim'="" d
	.s dimInfor=$lg($g(^DHCWL.MKPI.MKPIDimTypeD(itemGrpDim)),2)_":"_$lg($g(^DHCWL.MKPI.MKPIDimTypeD(itemGrpDim)),3)
	s typeObj=##class(DHCWL.CodeCfg.ItemGroup).%OpenId(id)
	s rJson=typeObj.GetDataStr()
	&sql(delete from DHCWL_CodeCfg.DHCWLCodeCfgItemGroup where ID=:id)
	s retsql=SQLCODE
	s result="删除失败！"
	i retsql=0 d
	.//++删除成功后，将信息保存到日志表中
	.;s dim("LogHeader")="ID"_"&"_"编码"_"&"_"描述"_"&"_"维度"_"&"_"创建人"
	.;s dim("LogInfor")=id_"&"_itemGrpCode_"&"_itemGrpDesc_"&"_dimInfor_"&"_itemGrpUser
	.s dimLogList("depMod")=$g(itemGrpCode)_":"_$g(itemGrpDesc)
	.s dimLogList("GrpModAttr")="编码:"_itemGrpCode_" ,描述:"_itemGrpDesc_" ,维度:"_dimInfor_" ,创建人:"_itemGrpUser
	.s sc=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList)
	.s result="ok"
	.s ret=typeObj.InsLog("D",rJson)
	q result
}

/// w ##class(DHCWL.CodeCfgData.SaveData)DelItem(.dim)
ClassMethod DelItem(ByRef dim) As %String
{
	n (dim,%session)
	s grpId=$g(dim("GrpId")) 
	s itemPara=$g(dim("selectItemPara"))
	//S grpId=2
	//s itemPara="2-4"
	k dimLogList
	s dimLogList("operType")="删除"
 	s dimLogList("modType")="大组明细"
 	s dimLogList("depMod")=$lg($g(^DHCWL.CodeCfg.ItemGroupD(grpId)),2)_":"_$lg($g(^DHCWL.CodeCfg.ItemGroupD(grpId)),3)
	s logID=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList,1)
	s dimDr=$lg($g(^DHCWL.CodeCfg.ItemGroupD(grpId)),8)
	
	f count=1:1:$l(itemPara,"-") d
	.s itemId=$p(itemPara,"-",count)
	.s dtId=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",grpId," "_$ZCVT(itemId,"U"),""))
    .s typeObj=##class(DHCWL.CodeCfg.ItemGroupDetails).%OpenId(dtId)
    .s rJson=typeObj.GetDataStr()
    .&sql(delete from  DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails where ID=:dtId)
	.s sqlPara=$g(sqlPara)+SQLCODE
	.s itemId=$tr(itemId," ")
 	.s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(dimDr,itemId)
 	.k dimLogList
 	.s dimLogList("LogHeader")="ID:描述"
 	.s dimLogList("LogInfor")=itemId_":"_itemDesc
 	.s dimLogList("logDr")=logID
 	.s dimLogList("Type")="Del"
 	.s sc=##class(DHCWL.CodeCfgData.FunctionModule).SaveGrpLogInfor(.dimLogList,2)
	s result="删除失败！"
	i sqlPara=0 d
	.s result="ok"
	.s ret=typeObj.InsLog("D",rJson)
	q result
}

/// w ##class(DHCWL.CodeCfgData.SaveData).updategrpitemSort(grpId,strPara)
ClassMethod updategrpitemSort(ByRef grpId, ByRef strPara) As %String
{
	n (grpId,strPara,%session)
	//s grpId=2
	//s strPara="8*1-6*2"
	s flag=0
	q:strPara="" "无条目信息怎么更新！"
	s ret="更新失败！"
	s len=$l(strPara,"-")
	f i=1:1:len d
	.s itmId=$p($P(strPara,"-",i),"*",1)
	.q:'$d(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",grpId," "_$ZCVT(itmId,"U")))
	.s id=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",grpId," "_$ZCVT(itmId,"U"),""))
	.s sort=$p($P(strPara,"-",i),"*",2)
	.s sortById=$list(^DHCWL.CodeCfg.ItemGroupDetailsD(id),5)
	.i sortById=sort s flag=$g(flag)+1
	.q:sortById=sort
	.&sql(update DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails set ItmGrpDet_Sort=:sort where ID=:id)
	.i SQLCODE=0 s ret="ok"
	q:flag=len "请上下拖动条目顺序后再来更新排序吧！"
	q ret
}

/// w ##class(DHCWL.CodeCfgData.SaveData).AddGrpItem(.dim)
ClassMethod AddGrpItem(ByRef dim) As %String
{
	n (dim,%session)
	s grpId=$g(dim("GrpId")) 
	s itemPara=$g(dim("selectItemPara"))
	//s grpId=1
	//s itemPara="1-2-3-10"
	s dimDr=$lg($g(^DHCWL.CodeCfg.ItemGroupD(grpId)),8)
	if ('$d(^TEMPDHCWL("olnyForGrpLog","TJDZ","depMod"))) d
	.s ^TEMPDHCWL("olnyForGrpLog","TJDZ","depMod")=$lg($g(^DHCWL.CodeCfg.ItemGroupD(grpId)),2)_":"_$lg($g(^DHCWL.CodeCfg.ItemGroupD(grpId)),3)
	
	s sortS=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpId,""),-1)
	f count=1:1:$l(itemPara,"-") d
	.s itemId=$p(itemPara,"-",count)
	.s sortS=sortS+1
	.s ret=..SaveGrpItemData()
	.s sqlPara=$g(sqlPara)+ret
	i ret=0 q "ok"
    i ret=1 q "添加过的项目不能重复添加！"
	//q ret
	q "保存失败！"
}

ClassMethod SaveGrpItemData() As %String
{
 q:$d(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",grpId," "_$ZCVT(itemId,"U"))) 1
 //q:dtId'="" "已在"_sGrpDes_"子组中添加过此项目，不能重复添加!"
 &sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails(ItmGrpDet_Grp_Dr,ItmGrpDet_Item_DR,ItmGrpDet_Sort) VALUES(:grpId,:itemId,:sortS))
 s id=+$g(%ROWID)
 s typeObj=##class(DHCWL.CodeCfg.ItemGroupDetails).%OpenId(id)
 s rJson=typeObj.GetDataStr()
 i SQLCODE=0  d
 .s num=+$g(^TEMPDHCWL("olnyForGrpLog","TJDZ"))+1
 .s itemId=$tr(itemId," ")
 .s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(dimDr,itemId)
 .s ^TEMPDHCWL("olnyForGrpLog","TJDZ")=num
 .s ^TEMPDHCWL("olnyForGrpLog","TJDZ","Data",num,"Add")=itemId_":"_itemDesc
 .s ret=typeObj.InsLog("A",rJson)
 q SQLCODE
}

/// Creator:         wk
/// CreatDate:       2017-11-14
/// Description:     
/// Table:           
/// Input: 		depModGrp:统计大组统计子组信息   itemId：明细ID  dimDr：关联维度  operaType：操作类型	
/// Output:			
/// Return:
/// Others:     d ##class(DHCWL.CodeCfgData.SaveData).updateForTJZZItem(depModGrp,itemId,dimDr,operaType)
ClassMethod updateForTJZZItem(depModGrp, itemId, dimDr, operaType)
{
	if ('$d(^TEMPDHCWL("olnyForGrpLog","TJZZ","depMod"))) d
	.s ^TEMPDHCWL("olnyForGrpLog","TJZZ","depMod")=depModGrp
	s LogInfor="ALL"
	if itemId'="" d
	.s itemId=$tr(itemId," ")
 	.s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(dimDr,itemId)
 	.s LogInfor=itemId_":"_itemDesc
 	s num=+$g(^TEMPDHCWL("olnyForGrpLog","TJZZ"))+1
	s ^TEMPDHCWL("olnyForGrpLog","TJZZ")=num
 	s ^TEMPDHCWL("olnyForGrpLog","TJZZ","Data",num,operaType)=LogInfor
}

/// Creator:         wk
/// CreatDate:       2017-11-14
/// Description:     
/// Table:           
/// Input: 		depModGrp:统计大组统计子组信息   itemId：明细ID  dimDr：关联维度  operaType：操作类型	
/// Output:			
/// Return:
/// Others:     d ##class(DHCWL.CodeCfgData.SaveData).logForTJZZItem(subGrpID,rowID,operaType)
ClassMethod logForTJZZItem(subGrpID, rowID = "", type = "")
{
	s grpID=$lg(^DHCWL.CodeCfg.SubGroupD(subGrpID),4)
	s depModGrp=$lg($g(^DHCWL.CodeCfg.GroupD(grpID)),2)_":"_$lg($g(^DHCWL.CodeCfg.GroupD(grpID)),3)_","_$lg($g(^DHCWL.CodeCfg.SubGroupD(subGrpID)),2)_":"_$lg($g(^DHCWL.CodeCfg.SubGroupD(subGrpID)),3)
	s dimDr=$lg(^DHCWL.CodeCfg.GroupD(grpID),11)
	s itemId=""
	s:rowID'="" itemId=$lg(^DHCWL.CodeCfg.SubGroupItemD(rowID),2)
	s operaType=type
	d ##class(DHCWL.CodeCfgData.SaveData).updateForTJZZItem(depModGrp,itemId,dimDr,operaType)
}

}
