/// d ##class(DHCWL.DM.T.ThemeDims).%BuildIndices()
Class DHCWL.DM.T.ThemeDims Extends %Persistent
{

Property ThemeBase As ThemeBase [ Required ];

Property SrcFetchConfig As ThemeFetchConfig [ Required ];

Property SrcMeta As MetaTableBase [ Required ];

//只能由字母,数字或者下划线组成，且必须是字母开头

Property Code As %String [ Required ];

Property Name As %String;

Property Description As %String;

Property DataType As DataType;

/// Attached="TD"
/// DimType可能的值为：R,LD,ED
Property DimType As TypeConfig [ Required ];

/// 当DimType="ED"时ProExpression保存维度的计算表达式
/// CreateType非空时保存函数表达式
Property ProExpression As %String(MAXLEN = 256);

/// only DimType='="ED"时有效
Property SrcField As MetaTablePro;

Property UpdateDate As %Date;

Property SerialNumber As %Integer;

//add@20180122

Property LinkPath As %String;

Property Status As %String(DISPLAYLIST = ",Active,NoUsed", MAXLEN = 2, TRUNCATE = 1, VALUELIST = ",AC,NS");

/// Attached="TD"
/// DimType可能的值为：STCPROFUN（静态函数调用返回非R类型的维度）,DYNPROFUN（动态函数调用返回非R类型的维度）,STCPROFUNRD（静态函数调用返回R类型的维度）,DYNPROFUNRD（动态函数调用返回R类型的维度）
Property CreateType As TypeConfig;

Index MainI On (ThemeBase, Code) [ PrimaryKey ];

Index FetchMetaI On (ThemeBase, SrcFetchConfig, SrcMeta);

Index DimTypeI On (ThemeBase, DimType);

//Index DimSerialNumberMK on (ThemeBase,"A")

// d ##class(DHCWL.DM.T.ThemeDims).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.ThemeDims)
	k ^DHCWL.DM.T.ThemeDimsD,^DHCWL.DM.T.ThemeDimsI
	s base=##class(ThemeBase).GetByPath("/workload.t")
	s base2=##class(ThemeBase).GetByPath("/workload2.t")
	s base3=##class(ThemeBase).GetByPath("/workload3.t")
	s base4=##class(ThemeBase).GetByPath("/workload4.t")
	s mf=##class(MetaTableBase).GetByPath("/workload.mf")
	s ml=##class(MetaTableBase).GetByPath("/ctloc.ml")
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="WLRowId",obj.Name="Workload ID" ,obj.DataType=mf.GetProperty("WorkLoad_Rowid").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:R"),obj.SrcField=mf.GetProperty("WorkLoad_Rowid"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="RecDep",obj.Name="接收科室" ,obj.DataType=mf.GetProperty("WorkLoad_RecDep_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.LinkPath="/Department.d",obj.SrcField=mf.GetProperty("WorkLoad_RecDep_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="RecDepName",obj.Name="接收科室名称" ,obj.DataType=##class(DataType).GetByPath("VARCHAR")
	s obj.DimType=##class(TypeConfig).GetByPath("TD:ED"),obj.ProExpression="CTLOC_Code",obj.SrcField=mf.GetProperty("WorkLoad_RecDep_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",2),obj.SrcMeta=ml
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="PatDepName",obj.Name="开单科室名称"  ,obj.DataType=##class(DataType).GetByPath("VARCHAR")
	s obj.DimType=##class(TypeConfig).GetByPath("TD:ED"),obj.ProExpression="CTLOC_Code",obj.SrcField=mf.GetProperty("WorkLoad_PatDep_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",3),obj.SrcMeta=ml
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="WarName",obj.Name="病区名称"  ,obj.DataType=##class(DataType).GetByPath("VARCHAR")
	s obj.DimType=##class(TypeConfig).GetByPath("TD:ED"),obj.ProExpression="CTLOC_Code",obj.SrcField=mf.GetProperty("WorkLoad_PatWard_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",4),obj.SrcMeta=ml
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="PatDep",obj.Name="开单科室"  ,obj.DataType=mf.GetProperty("WorkLoad_PatDep_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.LinkPath="/Department.d",obj.SrcField=mf.GetProperty("WorkLoad_PatDep_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="AdmType",obj.Name="医嘱类型"   ,obj.DataType=mf.GetProperty("WorkLoad_Type").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_Type"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="OrdDate",obj.Name="医嘱日期"  ,obj.DataType=mf.GetProperty("WorkLoad_OrdDate").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_OrdDate"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	
	;&sql(insert into DHCWL_DM_T.ThemeDims(Code,DimType,Name,SrcFetchConfig,SrcField,SrcMeta,ThemeBase)values('Test',13,'测试',1,5,2,1))
	;w !,SQLCODE
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="PatDoc",obj.Name="病人医生"   ,obj.DataType=mf.GetProperty("WorkLoad_PatDoc_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WorkLoad_PatDoc_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.LinkPath="/Doctor.d"
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="RecDoc",obj.Name="执行医生"   ,obj.DataType=mf.GetProperty("WorkLoad_RecDoc_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WorkLoad_RecDoc_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.LinkPath="/Doctor.d"
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="ResDoc",obj.Name="下医嘱医生"   ,obj.DataType=mf.GetProperty("WorkLoad_ResDoc_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WorkLoad_ResDoc_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.LinkPath="/Doctor.d"
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="TarACDr",obj.Name="会计分类"   ,obj.DataType=mf.GetProperty("WorkLoad_TarAC_dr").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_TarAC_dr"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="TarECDr",obj.Name="核算分类"   ,obj.DataType=mf.GetProperty("WorkLoad_TarEC_Dr").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_TarEC_Dr"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="TarICDr",obj.Name="住院分类"   ,obj.DataType=mf.GetProperty("WorkLoad_TarIC_Dr").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_TarIC_Dr"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="TarOutDr",obj.Name="门诊分类"   ,obj.DataType=mf.GetProperty("WorkLoad_TarOut_Dr").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_TarOut_Dr"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="TarItemDr",obj.Name="收费项目"   ,obj.DataType=mf.GetProperty("WorkLoad_TarItem_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_TarItem_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="ItemCatDr",obj.Name="医嘱子类"   ,obj.DataType=mf.GetProperty("WorkLoad_ItemCat_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_ItemCat_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="ItemOrdDr",obj.Name="医嘱项"   ,obj.DataType=mf.GetProperty("WorkLoad_ItemOrd_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_ItemOrd_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="OEORIDr",obj.Name="医嘱"   ,obj.DataType=mf.GetProperty("WorkLoad_OEORI_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_OEORI_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base,obj.Code="FlagDate",obj.Name="结算日期"  ,obj.DataType=mf.GetProperty("WorkLoad_FlagDate").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_FlagDate"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="WLRowId",obj.Name="Workload ID" ,obj.DataType=mf.GetProperty("WorkLoad_Rowid").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:R"),obj.SrcField=mf.GetProperty("WorkLoad_Rowid"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="RecDep",obj.Name="接收科室" ,obj.DataType=mf.GetProperty("WorkLoad_RecDep_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.LinkPath="/Department.d",obj.SrcField=mf.GetProperty("WorkLoad_RecDep_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="RecDepName",obj.Name="接收科室名称" ,obj.DataType=##class(DataType).GetByPath("VARCHAR")
	s obj.DimType=##class(TypeConfig).GetByPath("TD:ED"),obj.ProExpression="CTLOC_Code",obj.SrcField=mf.GetProperty("WorkLoad_RecDep_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",2),obj.SrcMeta=ml
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="PatDepName",obj.Name="开单科室名称"  ,obj.DataType=##class(DataType).GetByPath("VARCHAR")
	s obj.DimType=##class(TypeConfig).GetByPath("TD:ED"),obj.ProExpression="CTLOC_Code",obj.SrcField=mf.GetProperty("WorkLoad_PatDep_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",3),obj.SrcMeta=ml
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="WarName",obj.Name="病区名称"  ,obj.DataType=##class(DataType).GetByPath("VARCHAR")
	s obj.DimType=##class(TypeConfig).GetByPath("TD:ED"),obj.ProExpression="CTLOC_Code",obj.SrcField=mf.GetProperty("WorkLoad_PatWard_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",4),obj.SrcMeta=ml
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="PatDep",obj.Name="开单科室"  ,obj.DataType=mf.GetProperty("WorkLoad_PatDep_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.LinkPath="/Department.d",obj.SrcField=mf.GetProperty("WorkLoad_PatDep_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="AdmType",obj.Name="医嘱类型"   ,obj.DataType=mf.GetProperty("WorkLoad_Type").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_Type"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="OrdDate",obj.Name="医嘱日期"  ,obj.DataType=mf.GetProperty("WorkLoad_OrdDate").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_OrdDate"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	
	;&sql(insert into DHCWL_DM_T.ThemeDims(Code,DimType,Name,SrcFetchConfig,SrcField,SrcMeta,ThemeBase)values('Test',13,'测试',1,5,2,1))
	;w !,SQLCODE
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="PatDoc",obj.Name="病人医生"   ,obj.DataType=mf.GetProperty("WorkLoad_PatDoc_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WorkLoad_PatDoc_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.LinkPath="/Doctor.d"
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="RecDoc",obj.Name="执行医生"   ,obj.DataType=mf.GetProperty("WorkLoad_RecDoc_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WorkLoad_RecDoc_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.LinkPath="/Doctor.d"
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="ResDoc",obj.Name="下医嘱医生"   ,obj.DataType=mf.GetProperty("WorkLoad_ResDoc_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WorkLoad_ResDoc_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.LinkPath="/Doctor.d"
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="TarACDr",obj.Name="会计分类"   ,obj.DataType=mf.GetProperty("WorkLoad_TarAC_dr").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_TarAC_dr"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="TarECDr",obj.Name="核算分类"   ,obj.DataType=mf.GetProperty("WorkLoad_TarEC_Dr").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_TarEC_Dr"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="TarICDr",obj.Name="住院分类"   ,obj.DataType=mf.GetProperty("WorkLoad_TarIC_Dr").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_TarIC_Dr"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="TarOutDr",obj.Name="门诊分类"   ,obj.DataType=mf.GetProperty("WorkLoad_TarOut_Dr").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_TarOut_Dr"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="TarItemDr",obj.Name="收费项目"   ,obj.DataType=mf.GetProperty("WorkLoad_TarItem_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_TarItem_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="ItemCatDr",obj.Name="医嘱子类"   ,obj.DataType=mf.GetProperty("WorkLoad_ItemCat_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_ItemCat_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="ItemOrdDr",obj.Name="医嘱项"   ,obj.DataType=mf.GetProperty("WorkLoad_ItemOrd_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_ItemOrd_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="OEORIDr",obj.Name="医嘱"   ,obj.DataType=mf.GetProperty("WorkLoad_OEORI_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_OEORI_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base2,obj.Code="FlagDate",obj.Name="结算日期"  ,obj.DataType=mf.GetProperty("WorkLoad_FlagDate").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_FlagDate"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload2.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="WLRowId",obj.Name="Workload ID" ,obj.DataType=mf.GetProperty("WorkLoad_Rowid").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:R"),obj.SrcField=mf.GetProperty("WorkLoad_Rowid"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="RecDep",obj.Name="接收科室" ,obj.DataType=mf.GetProperty("WorkLoad_RecDep_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.LinkPath="/Department.d",obj.SrcField=mf.GetProperty("WorkLoad_RecDep_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="Ward",obj.Name="病区"  ,obj.DataType=##class(DataType).GetByPath("VARCHAR")
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.LinkPath="/Department.d",obj.SrcField=mf.GetProperty("WorkLoad_PatWard_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",4),obj.SrcMeta=ml
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="PatDep",obj.Name="开单科室"  ,obj.DataType=mf.GetProperty("WorkLoad_PatDep_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.LinkPath="/Department.d",obj.SrcField=mf.GetProperty("WorkLoad_PatDep_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="AdmType",obj.Name="医嘱类型"   ,obj.DataType=mf.GetProperty("WorkLoad_Type").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_Type"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="OrdDate",obj.Name="医嘱日期"  ,obj.DataType=mf.GetProperty("WorkLoad_OrdDate").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_OrdDate"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	
	;&sql(insert into DHCWL_DM_T.ThemeDims(Code,DimType,Name,SrcFetchConfig,SrcField,SrcMeta,ThemeBase)values('Test',13,'测试',1,5,2,1))
	;w !,SQLCODE
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="PatDoc",obj.Name="病人医生"   ,obj.DataType=mf.GetProperty("WorkLoad_PatDoc_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WorkLoad_PatDoc_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.LinkPath="/Doctor.d"
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="RecDoc",obj.Name="执行医生"   ,obj.DataType=mf.GetProperty("WorkLoad_RecDoc_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WorkLoad_RecDoc_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.LinkPath="/Doctor.d"
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="ResDoc",obj.Name="下医嘱医生"   ,obj.DataType=mf.GetProperty("WorkLoad_ResDoc_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WorkLoad_ResDoc_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.LinkPath="/Doctor.d"
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="TarACDr",obj.Name="会计分类"   ,obj.DataType=mf.GetProperty("WorkLoad_TarAC_dr").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_TarAC_dr"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="TarECDr",obj.Name="核算分类"   ,obj.DataType=mf.GetProperty("WorkLoad_TarEC_Dr").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_TarEC_Dr"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="TarICDr",obj.Name="住院分类"   ,obj.DataType=mf.GetProperty("WorkLoad_TarIC_Dr").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_TarIC_Dr"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="TarOutDr",obj.Name="门诊分类"   ,obj.DataType=mf.GetProperty("WorkLoad_TarOut_Dr").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_TarOut_Dr"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="TarItemDr",obj.Name="收费项目"   ,obj.DataType=mf.GetProperty("WorkLoad_TarItem_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_TarItem_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="ItemCatDr",obj.Name="医嘱子类"   ,obj.DataType=mf.GetProperty("WorkLoad_ItemCat_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_ItemCat_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="ItemOrdDr",obj.Name="医嘱项"   ,obj.DataType=mf.GetProperty("WorkLoad_ItemOrd_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_ItemOrd_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="OEORIDr",obj.Name="医嘱"   ,obj.DataType=mf.GetProperty("WorkLoad_OEORI_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_OEORI_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base3,obj.Code="FlagDate",obj.Name="结算日期"  ,obj.DataType=mf.GetProperty("WorkLoad_FlagDate").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WorkLoad_FlagDate"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload3.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	
	
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="WLRowId",obj.Name="Workload ID" ,obj.DataType=mf.GetProperty("WORKLOAD_ROWID").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:R"),obj.SrcField=mf.GetProperty("WORKLOAD_ROWID"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="RecDep",obj.Name="接收科室" ,obj.DataType=mf.GetProperty("WORKLOAD_RECDEP_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.LinkPath="/Department.d",obj.SrcField=mf.GetProperty("WORKLOAD_RECDEP_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="itemOrd",obj.Name="医嘱项" ,obj.DataType=mf.GetProperty("WORKLOAD_ITEMORD_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:R"),obj.SrcField=mf.GetProperty("WORKLOAD_ITEMORD_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="resDep",obj.Name="病人科室" ,obj.DataType=mf.GetProperty("WORKLOAD_RESDEP_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.LinkPath="/Department.d",obj.SrcField=mf.GetProperty("WORKLOAD_RESDEP_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="type",obj.Name="类型" ,obj.DataType=mf.GetProperty("WORKLOAD_TYPE").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WORKLOAD_TYPE"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="ordDate",obj.Name="医嘱日期" ,obj.DataType=mf.GetProperty("WORKLOAD_ORDDATE").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_ORDDATE"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	/*s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="ordTime",obj.Name="医嘱时间" ,obj.DataType=mf.GetProperty("WORKLOAD_ORDTIME").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_ORDTIME"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	*/
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="itemCat",obj.Name="医嘱子类" ,obj.DataType=mf.GetProperty("WORKLOAD_ITEMCAT_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_ITEMCAT_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="billGrp",obj.Name="账单大类" ,obj.DataType=mf.GetProperty("WORKLOAD_BILLGRP_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_BILLGRP_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="billSub",obj.Name="账单子类" ,obj.DataType=mf.GetProperty("WORKLOAD_BILLSUB_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_BILLSUB_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="paadm",obj.Name="病人就诊号" ,obj.DataType=mf.GetProperty("WORKLOAD_PAADM_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:R"),obj.SrcField=mf.GetProperty("WORKLOAD_PAADM_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="papmi",obj.Name="病人信息" ,obj.DataType=mf.GetProperty("WORKLOAD_PAPMI_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_PAPMI_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="ordStatus",obj.Name="医嘱状态" ,obj.DataType=mf.GetProperty("WORKLOAD_ORDSTATUS").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_ORDSTATUS"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="recDoc",obj.Name="接收医生" ,obj.DataType=mf.GetProperty("WORKLOAD_RECDOC_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.LinkPath="/Doctor.d",obj.SrcField=mf.GetProperty("WORKLOAD_RECDOC_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="resDoc",obj.Name="下医嘱医生" ,obj.DataType=mf.GetProperty("WORKLOAD_RESDOC_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.LinkPath="/Doctor.d",obj.SrcField=mf.GetProperty("WORKLOAD_RESDOC_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="arpbl",obj.Name="病人账单" ,obj.DataType=mf.GetProperty("WORKLOAD_ARPBL_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:R"),obj.SrcField=mf.GetProperty("WORKLOAD_ARPBL_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="oeori",obj.Name="医嘱明细" ,obj.DataType=mf.GetProperty("WORKLOAD_OEORI_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:R"),obj.SrcField=mf.GetProperty("WORKLOAD_OEORI_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="tarItem",obj.Name="收费项目" ,obj.DataType=mf.GetProperty("WORKLOAD_TARITEM_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_TARITEM_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="patDep",obj.Name="下医嘱科室" ,obj.DataType=mf.GetProperty("WORKLOAD_PATDEP_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.LinkPath="/Department.d",obj.SrcField=mf.GetProperty("WORKLOAD_PATDEP_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="patWard",obj.Name="病人病区" ,obj.DataType=mf.GetProperty("WORKLOAD_PATWARD_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.LinkPath="/Department.d",obj.SrcField=mf.GetProperty("WORKLOAD_PATWARD_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="patDoc",obj.Name="病人医生" ,obj.DataType=mf.GetProperty("WORKLOAD_PATDOC_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.LinkPath="/Doctor.d",obj.SrcField=mf.GetProperty("WORKLOAD_PATDOC_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="paidFlag",obj.Name="结算标志" ,obj.DataType=mf.GetProperty("WORKLOAD_FLAG").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WORKLOAD_FLAG"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="flagDate",obj.Name="结算日期" ,obj.DataType=mf.GetProperty("WORKLOAD_FLAGDATE").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_FLAGDATE"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="receipti",obj.Name="WORKLOAD_RECEIPTI_DR" ,obj.DataType=mf.GetProperty("WORKLOAD_RECEIPTI_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:R"),obj.SrcField=mf.GetProperty("WORKLOAD_RECEIPTI_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="cashero",obj.Name="结算员" ,obj.DataType=mf.GetProperty("WORKLOAD_CASHERO_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_CASHERO_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="userDep",obj.Name="登录科室" ,obj.DataType=mf.GetProperty("WORKLOAD_USERDEP_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.LinkPath="/Department.d",obj.SrcField=mf.GetProperty("WORKLOAD_USERDEP_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="userDr",obj.Name="登录用户" ,obj.DataType=mf.GetProperty("WORKLOAD_USER_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_USER_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="holdFlag",obj.Name="节假日标准" ,obj.DataType=mf.GetProperty("WORKLOAD_HOLDFLAG").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WORKLOAD_HOLDFLAG"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="holdFlagDate",obj.Name="节假日" ,obj.DataType=mf.GetProperty("WORKLOAD_HOLDFLAGDATE").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:LD"),obj.SrcField=mf.GetProperty("WORKLOAD_HOLDFLAGDATE"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="tarac",obj.Name="会计分类" ,obj.DataType=mf.GetProperty("WORKLOAD_TARAC_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_TARAC_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="tarsc",obj.Name="tarsc" ,obj.DataType=mf.GetProperty("WORKLOAD_TARSC_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_TARSC_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="tarout",obj.Name="门诊分类" ,obj.DataType=mf.GetProperty("WORKLOAD_TAROUT_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_TAROUT_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="tarec",obj.Name="核算分类" ,obj.DataType=mf.GetProperty("WORKLOAD_TAREC_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_TAREC_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="tarmc",obj.Name="病案分类" ,obj.DataType=mf.GetProperty("WORKLOAD_TARMC_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_TARMC_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="taric",obj.Name="住院分类" ,obj.DataType=mf.GetProperty("WORKLOAD_TARIC_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_TARIC_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	/*s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="flagTime",obj.Name="结算时间" ,obj.DataType=mf.GetProperty("WORKLOAD_FLAGTIME").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_FLAGTIME"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","*/
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="dataType",obj.Name="数据类型" ,obj.DataType=mf.GetProperty("WORKLOAD_DATATYPE").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_DATATYPE"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="pbd",obj.Name="病人账单明细" ,obj.DataType=mf.GetProperty("WORKLOAD_PBDDR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:R"),obj.SrcField=mf.GetProperty("WORKLOAD_PBDDR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="admReason",obj.Name="就诊原因" ,obj.DataType=mf.GetProperty("WORKLOAD_ADMREASON_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_ADMREASON_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="tarmcnew",obj.Name="病案新分类" ,obj.DataType=mf.GetProperty("WORKLOAD_TARMCNEW_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_TARMCNEW_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="oeore",obj.Name="医嘱执行明细" ,obj.DataType=mf.GetProperty("WORKLOAD_OEORE_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:R"),obj.SrcField=mf.GetProperty("WORKLOAD_OEORE_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="socialStatus",obj.Name="病人身份" ,obj.DataType=mf.GetProperty("WORKLOAD_SOCIALSTATUS_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:RD"),obj.SrcField=mf.GetProperty("WORKLOAD_SOCIALSTATUS_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="phcc",obj.Name="WORKLOAD_PHCC_DR" ,obj.DataType=mf.GetProperty("WORKLOAD_PHCC_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:R"),obj.SrcField=mf.GetProperty("WORKLOAD_PHCC_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="phcd",obj.Name="WORKLOAD_PHCD_DR" ,obj.DataType=mf.GetProperty("WORKLOAD_PHCD_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:R"),obj.SrcField=mf.GetProperty("WORKLOAD_PHCD_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="phcf",obj.Name="WORKLOAD_PHCDF_DR" ,obj.DataType=mf.GetProperty("WORKLOAD_PHCDF_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:R"),obj.SrcField=mf.GetProperty("WORKLOAD_PHCDF_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(ThemeDims).%New()
	s obj.ThemeBase=base4,obj.Code="phcin",obj.Name="WORKLOAD_PHCIN_DR" ,obj.DataType=mf.GetProperty("WORKLOAD_PHCIN_DR").DataType
	s obj.DimType=##class(TypeConfig).GetByPath("TD:R"),obj.SrcField=mf.GetProperty("WORKLOAD_PHCIN_DR"),obj.UpdateDate=+$p($h,",",1)
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/workload4.t",1),obj.SrcMeta=mf
	d obj.%Save()
	w obj.%Id(),","
}

Trigger AftInsertTri [ Event = INSERT, Time = AFTER ]
{
	n id
	s id={%%ID}
	n sn,themeId,date,typeId
	i id'="" d
	.s date=$p($h,",",1)
	.s themeId=$lg(^DHCWL.DM.T.ThemeDimsD(id),2)
	.s typeId=$lg(^DHCWL.DM.T.ThemeDimsD(id),9)
	.s sn=..ComputeSN(themeId,typeId)
	.&sql(update DHCWL_DM_T.ThemeDims set SerialNumber=:sn,UpdateDate=:date where ID=:id)
}

Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
    s:+..SerialNumber=0 ..SerialNumber=..ComputeSN(..ThemeBase.%Id(),..DimType)
    s ..UpdateDate=$p($h,",",1)
    q $$$OK
}

ClassMethod GetDimId(themeId, code) As %String
{
	s code=" "_$zcvt(code,"U")
	q:( ('$d(^DHCWL.DM.T.ThemeDimsI("MainI",themeId))) || ('$d(^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code))) ) ""
	q $o(^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code,""))
}

ClassMethod GetDims(themeId) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	q:themeId="" list
	q:'$d(^DHCWL.DM.T.ThemeDimsI("MainI",themeId)) list
	s code="" f{
	  s code=$o(^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code))
	  q:code=""
	  s id=$o(^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code,""))
	  s obj=##class(ThemeDims).%OpenId(id)
	  continue:obj=""
	  d list.Insert(obj)
	}
	q list
}

// s obj=##class(DHCWL.DM.T.ThemeDims).GetDim(1,"RecDep")

ClassMethod GetDim(themeId, code) As ThemeDims
{
	s code=" "_$zcvt(code,"U")
	q:( ('$d(^DHCWL.DM.T.ThemeDimsI("MainI",themeId))) || ('$d(^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code))) ) ""
	s id=$o(^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code,""))
	q ##class(ThemeDims).%OpenId(id)
}

// s list=##class(DHCWL.DM.T.ThemeDims).GetDimStruct(1)

ClassMethod GetDimStruct(themeId, dimId = "") As %List
{
	if (dimId'=""){
	  s dim=##class(ThemeDims).%OpenId(dimId)
	  q:(dim="") $lb()
	  s dt=12
	  if dim.DataType'="" s dt=dim.DataType.JDBCTypeCodeNum
	  s list= $lb(dim.Code,dim.SerialNumber,dimId,dt)	
	  s dim=""
	  q list
	}
	s list=$lb(),i=0
	q:'$d(^DHCWL.DM.T.ThemeDimsI("MainI",themeId)) list
	s code="" f  s code=$o(^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code)) q:code=""  d
	.s id=$o( ^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code,"") )
	.s obj=##class(ThemeDims).%OpenId(id)
	.q:(obj="")
	.q:(obj.CreateType'="")&&(obj.CreateType.GetPath()="TD:DYNPROFUN")
	.s i=i+1
	.s $list(list,i)=obj.Code
	.s i=i+1
	.s $list(list,i)=obj.SerialNumber
	.s i=i+1
	.s $list(list,i)=id
	.s i=i+1
	.s dt=12
	.i obj.DataType'="" d
	..s dt=obj.DataType.JDBCTypeCodeNum
	.s $list(list,i)=dt
	q list
}

// s list=##class(DHCWL.DM.T.ThemeDims).GetDimRelationStruct(1)

ClassMethod GetDimRelationStruct(themeId, dimId = "") As %List
{
	if (dimId'=""){
	  s dim=##class(ThemeDims).%OpenId(dimId)
	  q:(dim="")||(dim.DimType.Code'="R") $lb()
	  s dt=12
	  if dim.DataType'="" s dt=dim.DataType.JDBCTypeCodeNum
	  s list= $lb(dim.Code,dim.SerialNumber,dimId,dt)	
	  s dim=""
	  q list
	}
	s list=$lb(),i=0
	q:'$d(^DHCWL.DM.T.ThemeDimsI("MainI",themeId)) list
	s code="" f  s code=$o(^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code)) q:code=""  d
	.s id=$o( ^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code,"") )
	.s obj=##class(ThemeDims).%OpenId(id)
	.q:(obj="")||(obj.DimType.Code'="R")
	.s i=i+1
	.s $list(list,i)=obj.Code
	.s i=i+1
	.s $list(list,i)=obj.SerialNumber
	.s i=i+1
	.s $list(list,i)=id
	.s i=i+1
	.s dt=12
	.i obj.DataType'="" d
	..s dt=obj.DataType.JDBCTypeCodeNum
	.s $list(list,i)=dt
	q list
}

ClassMethod ComputeSN(themeId, dimTypeId) As %Integer
{
	q:'$d( ^DHCWL.DM.T.ThemeDimsI("MainI",themeId) ) 1
	s max=0
	s code="" f  s code=$o( ^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code) ) q:code=""  d
	.s id=$o( ^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code,"") )
	.s sn=$lg(^DHCWL.DM.T.ThemeDimsD(id),13)
	.s:sn>max max=sn
	q max+1
}

ClassMethod GetMaxSN(themeId) As %Integer
{
	q:'$d( ^DHCWL.DM.T.ThemeDimsI("MainI",themeId) ) 1
	s max=0
	s code="" f  s code=$o( ^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code) ) q:code=""  d
	.s id=$o( ^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code,"") )
	.s sn=$lg(^DHCWL.DM.T.ThemeDimsD(id),13)
	.i sn>max s max=sn
	q max
}

// w ##class(DHCWL.DM.T.ThemeDims).GetDimsString(1)

ClassMethod GetDimsString(themeId) As %String
{
	q:'$d( ^DHCWL.DM.T.ThemeDimsI("MainI",themeId) ) ""
	s sel="",num=0
	s code="" f  s code=$o( ^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code) ) q:code=""  d
	.s id=$o( ^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code,"") )
	.q:'$d(^DHCWL.DM.T.ThemeDimsD(id))
	.s code2=$lg(^DHCWL.DM.T.ThemeDimsD(id),5)
	.s linkPath=$lg(^DHCWL.DM.T.ThemeDimsD(id),14)
	.s num=num+1
	.s:num>1 sel=sel_","
	.s sel=sel_"{""code"":"""_code2_""",""sn"":"_$lg(^DHCWL.DM.T.ThemeDimsD(id),13)_",""LinkPath"":"""_linkPath_"""}"
	q sel
}

// w ##class(DHCWL.DM.T.ThemeDims).GetDimSelect(1)

ClassMethod GetDimSelect(themeId) As %String
{
	q:'$d( ^DHCWL.DM.T.ThemeDimsI("MainI",themeId) ) ""
	s sel="",num=0
	s code="" f  s code=$o( ^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code) ) q:code=""  d
	.s id=$o( ^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code,"") )
	.q:'$d(^DHCWL.DM.T.ThemeDimsD(id))
	.s obj=##class(ThemeDims).%OpenId(id)
	.q:obj=""
	.q:(obj.CreateType'="")&&(obj.CreateType.GetPath()="TD:DYNPROFUN")
	.s exp="t"_obj.SrcFetchConfig.%Id()_"."_obj.Code
	.;s c2=$lg(^DHCWL.DM.T.ThemeDimsD(id),5)
	.s num=num+1
	.s:num>1 sel=sel_", "
	.s sel=sel_exp
	q sel
}

// w ##class(DHCWL.DM.T.ThemeDims).GetSrcMetaSelect(1,1)

ClassMethod GetFetchSelect(themeId, fetchConfigId) As %String
{
	q:( ( '$d( ^DHCWL.DM.T.ThemeDimsI("FetchMetaI",themeId) ) ) || ( '$d( ^DHCWL.DM.T.ThemeDimsI("FetchMetaI",themeId,fetchConfigId) ) )) ""
	s select=""
	s num=0
	s srcMeta=""
	s srcMetaId=$o( ^DHCWL.DM.T.ThemeDimsI("FetchMetaI",themeId,fetchConfigId,"") )
	s id="" f  s id=$o( ^DHCWL.DM.T.ThemeDimsI("FetchMetaI",themeId,fetchConfigId,srcMetaId,id) ) q:id=""  d
	.s obj=##class(ThemeDims).%OpenId(id)
	.q:obj=""
	.s:srcMeta="" srcMeta=obj.SrcMeta
	.s dtpath=obj.DimType.GetPath()
	.i (dtpath="TD:RD")||(dtpath="TD:R") d
	..s exp=obj.SrcField.Code_" AS "_obj.Code
	..d BuildExp
	.e  i dtpath="TD:ED" d
	..s exp=obj.ProExpression_" AS "_obj.Code
	..d BuildExp
	.e  i dtpath="TD:LD" d
	..s exp=obj.SrcField.Code_" AS "_obj.Code
	..d BuildExp
	.e  i obj.CreateType'="" d
	..s ctpath=obj.CreateType.GetPath()
	..i (ctpath [ "TD:STCPROFUN")||(ctpath [ "TD:DYNPROFUN") d
	...q
	q select ;"SELECT "_select_" FROM "_srcMeta.GetSQLRef
BuildExp
    i obj.CreateType'="" d
    .s ctpath=obj.CreateType.GetPath()
    .i (ctpath [ "TD:STCPROFUN")||(ctpath [ "TD:DYNPROFUN") d
    ..q
    e  d
    .s num=num+1
    .s:num>1 select=select_", "
    .s select=select_exp
    q
}

ClassMethod GetGroupBy(themeId) As %String
{
	s typeMap("TD:RD")="",typeMap("TD:LD")=""
	s groupBy="",num=0
	s typePath="" f  s typePath=$o(typeMap(typePath)) q:typePath=""  d
	.s typeId=##class(TypeConfig).GetIdByPath(typePath)
	.if ( (typeId'="") && ( $d( ^DHCWL.DM.T.ThemeDimsI("DimTypeI",typeId) ) ) ) d
	..s id="" f  s id=$o( ^DHCWL.DM.T.ThemeDimsI("DimTypeI",typeId,id) ) q:id=""  d
	...q:'$d( ^DHCWL.DM.T.ThemeDimsD(id) )
	...s code2=$lg(^DHCWL.DM.T.ThemeDimsD(id),3)
	...s num=num+1
	...i num>1 s groupBy=groupBy_","
	...s groupBy=groupBy_code2
	q groupBy
}

ClassMethod GetDimsSerialNumber(themeId, dimList As %List, ByRef dimSerialNumMap) As %Status
{
	q:'$d(^DHCWL.DM.T.ThemeDimsI("MainI",themeId)) $$$ERROR("Can't find dim in theme id:"_themeId)
	k dimSerialNumMap
	s status=$$$OK
	s len=$ll(dimList)
	f i=1:1:len d
	.s code=$lg(dimList,i)
	.s code=" "_$zcvt(code,"U")
	.s code2=$lg(dimList,i)
	.s id=$o(^DHCWL.DM.T.ThemeDimsI("MainI",themeId,code,""))
	.i ((id="") || ('$d(^DHCWL.DM.T.ThemeDimsD(id)))) d
	..s status=$$$ERROR("Can't find dim with code:"_$lg(dimList,i))
	..s i=len+1
	.e  d
	..s sn=$lg(^DHCWL.DM.T.ThemeDimsD(id),13)
	..s dimSerialNumMap(code2)=id
	..s dimSerialNumMap(code2,"SN")=sn
	q status
}

Method GetLinkDim() As DimBase
{
	if ((..DimType.GetPath()="TD:RD")) {
	  q:..LinkPath="" ""
	  q ##class(DimBase).GetByPath(..LinkPath)
	}elseif (..DimType.GetPath()="TD:R"){
	  s themePath=$p(..LinkPath,"?",1)
	  s queryParam=$p(..LinkPath,"?",2)
	  q:(..LinkPath="")||(themePath="") ""
	  q ##class(ThemeBase).GetByPath(themePath)
	}
	q ""
}

Method GetLinkParams() As %String
{
	if (..DimType.GetPath()="TD:R"){
	  q $p(..LinkPath,"?",2)
	}
	q ""
}

Method Mask() As %String
{
  q ..%Id()
}

Method GetUsingParameters(funConfig As FunctionConfig) As %ListOfObjects
{
	s master="DHCWL.DM.T.ThemeDims:"_..%Id()
	s list=funConfig.Parameters()
	f i=1:1:list.Count(){
	  s obj=list.GetAt(i)
	  s pi=obj.%Id()
	  s pu=##class(FunParaUsing).GetInstance(master,pi)
	  continue:pu=""
	  s obj.Name=pu.ParaValue
	}
	q list
}

Storage Default
{
<Data name="ThemeDimsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ThemeBase</Value>
</Value>
<Value name="3">
<Value>SrcFetchConfig</Value>
</Value>
<Value name="4">
<Value>SrcMeta</Value>
</Value>
<Value name="5">
<Value>Code</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
<Value name="7">
<Value>Description</Value>
</Value>
<Value name="8">
<Value>DataType</Value>
</Value>
<Value name="9">
<Value>DimType</Value>
</Value>
<Value name="10">
<Value>ProExpression</Value>
</Value>
<Value name="11">
<Value>SrcField</Value>
</Value>
<Value name="12">
<Value>UpdateDate</Value>
</Value>
<Value name="13">
<Value>SerialNumber</Value>
</Value>
<Value name="14">
<Value>LinkPath</Value>
</Value>
<Value name="15">
<Value>UsedFlag</Value>
</Value>
<Value name="16">
<Value>Status</Value>
</Value>
<Value name="17">
<Value>CreateType</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.ThemeDimsD</DataLocation>
<DefaultData>ThemeDimsDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.ThemeDimsD</IdLocation>
<IndexLocation>^DHCWL.DM.T.ThemeDimsI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.ThemeDimsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
