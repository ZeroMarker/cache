/// Creator   : wk
/// CreatDate : 2018-09-18
/// Desc      : 医生应用配置维护
Class web.DHCWL.V1.DocAppCfg.DocKpiCfg Extends %RegisteredObject
{

/// Creator   : wk
/// CreatDate : 2018-09-18
/// Desc      : 医生应用表格数据获取
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.DocAppCfg.DocKpiCfg","GetDocCfg",)
Query GetDocCfg(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,desc:%String:描述,class:%String:应用分类,category:%String:取值方式,type:%String:指标类别,date:%String:更新时间") [ SqlProc ]
{
}

ClassMethod GetDocCfgExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    s:filterValue'="" filterValue=$ZCVT(filterValue,"U")
    s sql="SELECT ID,MDocKPIDef_Code,MDocKPIDef_Desc,MDocKPI_UpdateDate,MDocKPIDef_Class,MDocKPIDef_Category,MDocKPIDef_Type FROM DHCWL_DocQuery.DHCWLDocKpiDef"
 	s rs=##class(%Library.ResultSet).%New()
 	d rs.Prepare(sql)
 	d rs.Execute()
	While(rs.Next()){
		s date=rs.Data("MDocKPI_UpdateDate")
		s:date'="" date=##class(websys.Conversions).DateLogicalToHtml(+date)
		
		s ID=rs.Data("ID")
		s code=rs.Data("MDocKPIDef_Code")
		s desc=rs.Data("MDocKPIDef_Desc")
		s class=rs.Data("MDocKPIDef_Class")
		s category=rs.Data("MDocKPIDef_Category")
		s type=rs.Data("MDocKPIDef_Type")
		
		continue:(filterValue'="")&&($zcvt(code,"U") '[ filterValue)&&($zcvt(desc,"U") '[ filterValue)&&($zcvt(class,"U") '[ filterValue)&&($zcvt(category,"U") '[ filterValue)&&($zcvt(type,"U") '[ filterValue)
		s ^CacheTemp(repid,ind)=$lb(rs.Data("ID"),code,desc,class,category,type,date)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-18
/// Desc      : 获取医生关联的指标信息
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.DocAppCfg.DocKpiCfg","GetDocKPI",)
Query GetDocKPI(docID As %String) As websys.Query(ROWSPEC = "ID:%String:ID,kpiCode:%String:指标编码,kpiDim:%String:指标维度,kpiDimPro:%String:维度属性,kpiFilter:%String:过滤规则") [ SqlProc ]
{
}

ClassMethod GetDocKPIExecute(ByRef qHandle As %Binary, docID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:docID="" $$$OK
	s sql="SELECT ID,MKPI_Code As MKPICode,MKPI_Dim, MDim_Prop, OtherFilter_Rule  FROM DHCWL_DocQuery.DHCWLDocKpiRelKpi where MDocKPI_Dr="_docID
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ^CacheTemp(repid,ind)=$lb(rs.Data("ID"),rs.Data("MKPICode"),rs.Data("MKPI_Dim"),rs.Data("MDim_Prop"),rs.Data("OtherFilter_Rule"))
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-19
/// Desc      : 加载指标类别
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.DocAppCfg.DocKpiCfg","GetTypeValue",)
Query GetTypeValue() As websys.Query(ROWSPEC = "typeCode:%String:类型编码,typeName:%String:类型描述") [ SqlProc ]
{
}

ClassMethod GetTypeValueExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s num=""
	for {
		s num = $o(^DHCWLDocKpi(num))
		q:num=""
		s classField = $g(^DHCWLDocKpi(num))
		s ^CacheTemp(repid,ind)=$lb(classField,classField)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-19
/// Desc      : 获取计算指标待选择指标
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.DocAppCfg.DocKpiCfg","GetCalDocApp",)
Query GetCalDocApp(docKPIDefClass As %String, docKPIDefType As %String) As websys.Query(ROWSPEC = "code:%String:编码,desc:%String:描述,class:%String:应用分类,category:%String:取值方式,type:%String:指标类别") [ SqlProc ]
{
}

ClassMethod GetCalDocAppExecute(ByRef qHandle As %Binary, docKPIDefClass As %String, docKPIDefType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s sql="SELECT ID,MDocKPIDef_Code,MDocKPIDef_Desc,MDocKPI_UpdateDate,MDocKPIDef_Class,MDocKPIDef_Category,MDocKPIDef_Type FROM DHCWL_DocQuery.DHCWLDocKpiDef WHERE MDocKPIDef_Category LIKE "_"'%普通指标%' And MDocKPIDef_Class = "_"'"_docKPIDefClass_"' AND MDocKPIDef_Type= "_"'"_docKPIDefType_"'"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ^CacheTemp(repid,ind)=$lb(rs.Data("MDocKPIDef_Code"),rs.Data("MDocKPIDef_Desc"),rs.Data("MDocKPIDef_Class"),rs.Data("MDocKPIDef_Category"),rs.Data("MDocKPIDef_Type"))
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-11
/// Desc      : 获取指标下维度
/// Other     :	do ##class(%ResultSet).RunQuery("web.DHCWL.V1.DocAppCfg.DocKpiCfg","GetKPITree","YSKZRCX004")
Query GetKPITree(kpiCode As %String) As websys.Query(ROWSPEC = "id:%String:id,parentId:%String:父节点,name:%String:名称") [ SqlProc ]
{
}

ClassMethod GetKPITreeExecute(ByRef qHandle As %Binary, kpiCode As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	
	s syskpiCode=kpiCode
	k data
	k ^TEMPDHCWLDUH($j)
	s syskpiCode = $zcvt(syskpiCode,"u")
	s mkpiDr=$o(^DHCWL.MKPI.MKPII("MKPICode",syskpiCode,"")) 
	s num =1
	s jsonData = "["
	s mDimdimId = ""  f  s mDimdimId = $o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",mkpiDr,mDimdimId))  q:mDimdimId=""  d  //纬度ID
	.s mDimId = ""  f  s mDimId = $o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",mkpiDr,mDimdimId,mDimId)) q:mDimId=""  d 
	..s dimCode = $list(^DHCWL.MKPI.MKPIDimensionsD(mDimId),2)
	..s dimDesc = $list(^DHCWL.MKPI.MKPIDimensionsD(mDimId),4)
	..s ^CacheTemp(repid,ind)=$lb(dimCode,1,dimCode_":"_dimDesc)
	..s ind=ind+1
	..b
	..s dimProCode = ""  f  s dimProCode = $o(^DHCWL.MKPI.DimPropertyI("DimCodeI",mDimdimId,dimProCode))  q:dimProCode=""  d   //纬度属性code
	...s dimProId = ""  f  s dimProId =  $o(^DHCWL.MKPI.DimPropertyI("DimCodeI",mDimdimId,dimProCode,dimProId))  q:dimProId=""  d
	....s dimProDesc = $list(^DHCWL.MKPI.DimPropertyD(dimProId),4)
	....s code = $list(^DHCWL.MKPI.DimPropertyD(dimProId),3)
	....s ^CacheTemp(repid,ind)=$lb(code,dimCode,code_":"_dimProDesc)
	....s ind=ind+1
	
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-20
/// Desc      : 将过滤规则解析成表格形式
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.DocAppCfg.DocKpiCfg","GetDocAppFilter","")
Query GetDocAppFilter(realKPIID As %String) As websys.Query(ROWSPEC = "calSymbol:%String:运算符,dimRule:%String:维度规则,filterFun:%String:过滤函数,filterValue:%String:过滤值,calSymboxRight:%String:右运算符") [ SqlProc ]
{
}

ClassMethod GetDocAppFilterExecute(ByRef qHandle As %Binary, realKPIID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s docID=$lg(^DHCWL.DocQuery.DocKpiRelKpiD(realKPIID),2)
	s category=$lg(^DHCWL.DocQuery.DocKpiDefD(docID),8)
	q:category'="普通指标" $$$OK
	s filterRule=$lg(^DHCWL.DocQuery.DocKpiRelKpiD(realKPIID),5)
	do ##Class(web.DHCWL.V1.Util.Util).ResoleFilterRule(filterRule,.filterList)
	s index=""
	for{
		s index=$o(filterList(index))
		q:index=""
		s ^CacheTemp(repid,ind)=filterList(index)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-09-20
/// Desc       : 获取维度数据
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.DocAppCfg.DocKpiCfg","GetDimValue","")
Query GetDimValue(kpiCode As %String, kpiDimCode As %String, dimProCode As %String, filterValue As %String = "") As websys.Query(ROWSPEC = "dimCode:%String,dimValue:%String,dimProValue:%String") [ SqlProc ]
{
}

ClassMethod GetDimValueExecute(ByRef qHandle As %Binary, kpiCode As %String, kpiDimCode As %String, dimProCode As %String, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
	q:kpiId="" $$$OK
	s kpiDimID=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,$zcvt(kpiDimCode,"U"),""))
	q:kpiDimID="" $$$OK
	s dimID=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimID),5)
	q:dimID="" $$$OK
	
	s dimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),2)
	q:dimCode="" $$$OK
	q:(dimProCode [ "ItemGrp")||(dimProCode [ "ItemSubGrp") $$$OK
	s orgDimFlag=0
	s:orgDimFlag=1 dimProCode=""
	s dimCodeStr=dimCode_":"_dimProCode
	s rs=##class(%ResultSet).%New("DHCWL.Interface.MkpiData:QryDimValuesByDimType")
	s sc=rs.Execute(dimCodeStr)
	While rs.Next(.sc){
		s dimType=$g(rs.Data("dimType"))
		s dimIDV=$g(rs.Data("dimIDV")) 
		s dimProV=$g(rs.Data("dimProV"))
		//continue:(dimProV'[filterStr)
		s:orgDimFlag=1 dimProV=dimIDV
		continue:((filterValue'="")&&($zcvt(dimIDV,"U") '[ filterValue)&&($zcvt(dimProV,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(dimType,dimIDV,dimProV)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-20
/// Desc      : 保存过滤规则
/// Other     : do ##class(web.DHCWL.V1.DocAppCfg.DocKpiCfg).SaveFilterRule()
ClassMethod SaveFilterRule(filterRule, docAppID)
{
	s filterRule = filterRule
	s dKpiId = docAppID
	i filterRule["\" s filterRule=$REPLACE(filterRule,"\","\\\")
	&sql(update  DHCWL_DocQuery.DHCWLDocKpiRelKpi set OtherFilter_Rule = :filterRule where MDocKPI_Dr = :dKpiId)
	i SQLCODE = 0 q "修改成功"
 	e  q "修改失败"
}

/// Creator   : wk
/// CreatDate : 2018-09-20
/// Desc      : 获取指标
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.DocAppCfg.DocKpiCfg","GetKPI")
Query GetKPI(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,kpiCode:%String:指标编码,kpiName:%String:指标名称,section:%String:区间,dim:%String:维度,type:%String:类别") [ SqlProc ]
{
}

ClassMethod GetKPIExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	s sql="select ID,MKPI_Code,MKPI_Name,MKPI_Cate,MKPI_SectionFlag from DHCWL_MKPI.DHCWLMKPI  where ID in (SELECT MKPI_Dr FROM DHCWL_MKPI.DHCWLMKPIDim WHERE MKPIDim_DimDr->KDT_Code = 'CTPCP' or MKPIDim_DimDr->KDT_Code = 'Doc' or MKPIDim_DimDr->KDT_Code ='doc') order by ID"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s kpiId=rs.Data("ID")
		s cate=rs.Data("MKPI_Cate"),sect=rs.Data("MKPI_SectionFlag")
		
		//获取维度信息
		s tempRes=""
		s tempDim="" 
		k kpiDimOrdered
		f {
			s tempDim=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiId,tempDim))
			q:($g(tempDim)="")||(tempDim=$c(0))
			continue:(+tempDim<=0)
			s kpiDimId=""
			f {
				s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiId,tempDim,kpiDimId))
				q:kpiDimId=""
				s dimOrder=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6)
				s:(dimOrder="")||(dimOrder=$c(0)) dimOrder=1
				s kpiDimOrdered(dimOrder)=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),4)   
			}	
		}
		s dimOrder=""
		f {
			s dimOrder=$o(kpiDimOrdered(dimOrder))
			q:dimOrder=""
			i tempRes="" s tempRes=kpiDimOrdered(dimOrder)
			e  s tempRes=tempRes_","_kpiDimOrdered(dimOrder)
		}
		s dim=$g(tempRes)
		
		//获取类别
		if cate="" {
			s cate=""
		}elseif $g(^DHCWL.MKPI.MKPIFLD(cate))'="" {
			s cate=$list(^DHCWL.MKPI.MKPIFLD(cate),5)
		}else{
			s cate=""
		}
		
		//获取区间
		i sect="" {
			s setc=""
		}elseif $g(^DHCWL.MKPI.SectionD(sect))'="" {
			s sect=$list(^DHCWL.MKPI.SectionD(sect),4)
		}else {
			s sect=""
		}
		s kpiCode=rs.Data("MKPI_Code")
		s kpiName=rs.Data("MKPI_Name")
		continue:((filterValue'="")&&($zcvt(kpiCode,"U") '[ filterValue)&&($zcvt(kpiName,"U") '[ filterValue)&&($zcvt(sect,"U") '[ filterValue)&&($zcvt(dim,"U") '[ filterValue)&&($zcvt(cate,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(kpiId,kpiCode,kpiName,sect,dim,cate)
		s ind=ind+1
		
		
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-20
/// Desc      : 保存关联指标
/// Other     : do ##class(web.DHCWL.V1.DocAppCfg.DocKpiCfg).AddDocAppRel()
ClassMethod AddDocAppRel(MDocKPIDr, MKPIdr, DocKpiDefClass, SkpiId)
{
	s dim("MDocKPIDr")=MDocKPIDr
	s dim("MKPIdr")=MKPIdr
	s MDocKpiDefClass=DocKpiDefClass
	s MSkpiId=SkpiId
	q:($d(^DHCWL.DocQuery.DocKpiRelKpiI("MDocKPIDr",MDocKPIDr))) "当前记录下已关联指标"
	s dimCodePro = ##class(DHCWL.DocQueryData.SaveData).findDim($g(dim("MKPIdr")),MDocKpiDefClass)
	s dim("MKPIDim")=$p(dimCodePro,"^",1) 
	s dim("MDimProp")=$p(dimCodePro,"^",2) 
	s tip=##class(DHCWL.DocQueryData.SaveData).AddDocAppRel(.dim)
	s:tip="ok" tip="保存成功"
	q tip
}

/// Creator     : wk
/// CreatDate   : 2018-09-20
/// Desc        : 获取已经配置的计算指标规则
/// Ohter       : do ##class(web.DHCWL.V1.DocAppCfg.DocKpiCfg).GetCalRule()
ClassMethod GetCalRule(docID)
{
	q:'$d(^DHCWL.DocQuery.DocKpiDefD(docID)) ""
	s kpiID=$o(^DHCWL.DocQuery.DocKpiRelKpiI("MDocKPIDr",docID,""))
	q:kpiID="" ""
	s filterValue=$lg(^DHCWL.DocQuery.DocKpiRelKpiD(kpiID),5)
	q filterValue
}

/// Creator    : wk
/// CreatDate  : 2018-09-21
/// Desc       : 保存计算指标规则
/// Other      : do ##Class(web.DHCWL.V1.DocAppCfg.DocKpiCfg).UpdateKpiDef()
ClassMethod UpdateKpiDef(id, calExp) As %String
{
	s kpiID=$o(^DHCWL.DocQuery.DocKpiRelKpiI("MDocKPIDr",id,""))
	if (kpiID=""){
		&sql(insert DHCWL_DocQuery.DHCWLDocKpiRelKpi (MDocKPI_Dr, OtherFilter_Rule) VALUES (:id,:calExp))
	}else{
		&sql(update DHCWL_DocQuery.DHCWLDocKpiRelKpi set OtherFilter_Rule = :calExp where MDocKPI_Dr = :id)
	}
	i SQLCODE = 0 q "修改成功"
 	e  q "修改失败"
}

/// Creator   : wk
/// CreatDate : 2018-09-21
/// Desc      : 保存医生应用配置记录
/// Other     : do ##class(web.DHCWL.V1.DocAppCfg.DocKpiCfg).UpdateDocApp
ClassMethod UpdateDocApp(ID, code, desc, type, class, category)
{
	s docKpiId=ID
	s docKPIDefCode=code
	s docKPIDefDesc=desc
	s docKPIDefType=type
	s docKPIUpdateDate=+$h
	s docKPIDefClass=class 
	s docKPIDefCategory=category 
	s pv("ID")=docKpiId,pv("MDocKPIDefCode")=docKPIDefCode,pv("MDocKPIDefDesc")=docKPIDefDesc ,pv("MDocKPIDefType")=docKPIDefType
	s pv("MDocKPIUpdateDate")=docKPIUpdateDate,pv("MDocKPIDefClass")=docKPIDefClass,pv("MDocKPIDefCategory")=docKPIDefCategory
	i ($g(docKpiId)="")||(+docKpiId=0){
		s result = ##class(DHCWL.DocQueryData.SaveData).DocKpiInsert(.pv)
	}else{
		s result = ##class(DHCWL.DocQueryData.SaveData).DocKpiUpdate(docKpiId,.pv)
	}
	s:result="ok" result="保存成功"
	q result
}

}
