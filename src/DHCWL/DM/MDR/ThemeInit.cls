Class DHCWL.DM.MDR.ThemeInit Extends %RegisteredObject
{

// d ##class(DHCWL.DM.MDR.ThemeInit).ThemeInit()

ClassMethod ThemeInit()
{
	s ns=##class(DHCWL.DM.T.Namespace).ThemeNamespace("/DW")
	if ns=""{
		s ns=##class(DHCWL.DM.T.Namespace).CreateNamespace("TH:/DW")
	}
	s theme=##class(DHCWL.DM.T.ThemeBase).GetByPath("/DW/DHCWorkLoad.t")
	s meta=##class(DHCWL.DM.T.MetaTableBase).GetByPath("/DHCWorkLoad.mf")
	s fetchConfig=""
	if theme=""{
		s theme=##class(DHCWL.DM.T.ThemeBase).%New()
		s theme.Code="DHCWorkLoad",theme.Namespace=ns,theme.Name=meta.Name,theme.Description=meta.Description,theme.Creator=meta.Creator
		s theme.CreatedDate=+$h,theme.NeedStore="N"
		s status=theme.%Save()
		If $$$ISERR(status) {
			Do DecomposeStatus^%apiOBJ(status,.err,"-d")
			For i=1:1:err Write err(i),!
				q
		}
		s fetchConfig=##class(DHCWL.DM.T.ThemeFetchConfig).%New()
	  s fetchConfig.ThemeBase=theme,fetchConfig.FactMetaTable=meta,fetchConfig.LinkPosition=1
	  s status=fetchConfig.%Save()
	  If $$$ISERR(status) {
			Do DecomposeStatus^%apiOBJ(status,.err,"-d")
			For i=1:1:err Write err(i),!
				q
		}
	}
	if fetchConfig=""{
		s fetchConfig=##class(DHCWL.DM.T.ThemeFetchConfig).GetAt("/DW/DHCWorkLoad.t",1)
	}
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Set sc=result.Prepare("SELECT CTSDDimDR->CTDDCode CTDDCode,CTSDDimDR->CTDDDesc CTDDDesc,CTSDSubjectCode FROM DWMDR.CTSubjectDim WHERE CTSDSubjectDimDR=? AND CTSDDimDR->CTDDCode NOT IN('TotleFee','ZFFee','ZKFee','JZFee','Quantity')")
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	Set sc=result.Execute(2) If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	While result.Next(.sc) {
		If $$$ISERR(sc) Quit
		s code=result.Data("CTDDCode"),desc=result.Data("CTDDDesc"),metaPro=result.Data("CTSDSubjectCode")
		s dim=theme.GetDim(code)
		s pro=meta.GetProperty(metaPro)
		continue:pro=""
		if dim=""{
			s dim=##class(DHCWL.DM.T.ThemeDims).%New()
			s dim.ThemeBase=theme,dim.Code=code,dim.Name=desc,dim.Description=desc,dim.DataType=pro.DataType
			s dim.DimType=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:LD"),dim.SrcField=pro,dim.UpdateDate=+$h
			s dim.SrcFetchConfig=fetchConfig,dim.SrcMeta=meta
			s status= dim.%Save()
			If $$$ISERR(status) {
				Do DecomposeStatus^%apiOBJ(status,.err,"-d")
				For i=1:1:err Write err(i),! 
				q
	  	}
		}
	}
	
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Set sc=result.Prepare("SELECT CTSDDimDR->CTDDCode CTDDCode,CTSDDimDR->CTDDDesc CTDDDesc,CTSDSubjectCode FROM DWMDR.CTSubjectDim WHERE CTSDSubjectDimDR=? AND CTSDDimDR->CTDDCode IN('TotleFee','ZFFee','ZKFee','JZFee','Quantity')")
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	Set sc=result.Execute(2) If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	While result.Next(.sc) {
		If $$$ISERR(sc) Quit
		s code=result.Data("CTDDCode"),desc=result.Data("CTDDDesc"),metaPro=result.Data("CTSDSubjectCode")
		s metric=theme.GetMetric(code)
		s pro=meta.GetProperty(metaPro)
		continue:pro=""
		if metric=""{
			s metric=##class(DHCWL.DM.T.ThemeMetrics).%New()
			s metric.Code=code,metric.Name=desc,metric.DataType=pro.DataType,metric.Description=desc
	    s metric.SrcFetchConfig=fetchConfig,metric.SrcField=pro,metric.UpdateDate=+$h
	    s metric.SrcMeta=meta,metric.ThemeBase=theme
	    s status= metric.%Save()
	  	If $$$ISERR(status) {
				Do DecomposeStatus^%apiOBJ(status,.err,"-d")
				For i=1:1:err Write err(i),! 
				q
	  	}
		}
	}
	s dateDimList=$lb("AccountDate","AdmDate","CreatDate","DisDate","ExecDate","FlagDate","HandDate","OeoriDate","OrdDate","UpdateDate")
	f i=1:1:$ll(dateDimList){
		continue:$lg(dateDimList,i)=""
		s dim=theme.GetDim($lg(dateDimList,i))
		s dim.DataType=##class(DHCWL.DM.T.DataType).GetByPath("DATE")
		w dim.%Save()
	}
	w theme.%Save()
}

// d ##class(DHCWL.DM.MDR.ThemeInit).ThemeDimType()

ClassMethod ThemeDimType()
{
	s theme=##class(DHCWL.DM.T.ThemeBase).GetByPath("/DW/DHCWorkLoad.t")
	w theme.SetLinkPath("AccCat","/CT_ACChargeCategory.d")
	w theme.SetLinkPath("AccSubCat","/CT_ACChargeChildCategory.d")
	w theme.SetLinkPath("AccountDate","/CT_DIMDAY.d")
	w theme.SetLinkPath("AdmDate","/CT_DIMDAY.d")
	w theme.SetLinkPath("AdmStatus","/CT_PatientPosition.d")
	w theme.SetLinkPath("AdmType","/CT_MDRDictionary.d")
	w theme.SetLinkPath("AntiFlag","/CT_MDRDictionary.d")
	w theme.SetLinkPath("ArcCat","/CT_Category.d")
	w theme.SetLinkPath("ArcItem","/CT_ARCItmMast.d")
	w theme.SetLinkPath("ArcSubCat","/CT_ChildCategory.d")
	w theme.SetLinkPath("BillCat","/CT_BillCat.d")
	w theme.SetLinkPath("BillSubCat","/CT_BillChildCat.d")
	w theme.SetLinkPath("ExeDep","/CT_Dept.d")
	w theme.SetLinkPath("ExeDepHos","/CT_Hospital.d")
	w theme.SetLinkPath("ExeDoc","/CT_CareProv.d")
	w theme.SetLinkPath("ExecDate","/CT_DIMDAY.d")
	w theme.SetLinkPath("FlagDate","/CT_DIMDAY.d")
	w theme.SetLinkPath("HandDate","/CT_DIMDAY.d")
	w theme.SetLinkPath("OrdDate","/CT_DIMDAY.d")
	w theme.SetLinkPath("PatDep","/CT_Dept.d")
	w theme.SetLinkPath("PatDepHos","/CT_Hospital.d")
	w theme.SetLinkPath("PatDoc","/CT_CT_CareProv.d")
	w theme.SetLinkPath("PatWard","/CT_Dept.d")
	w theme.SetLinkPath("PatWardHos","/CT_Hospital.d")
	w theme.SetLinkPath("RecDep","/CT_Dept.d")
	w theme.SetLinkPath("RecDepHos","/CT_Hospital.d")
	w theme.SetLinkPath("RecDoc","/CT_CT_CareProv.d")
	w theme.SetLinkPath("ResDep","/CT_Dept.d")
	w theme.SetLinkPath("ResDepHos","/CT_Hospital.d")
	w theme.SetLinkPath("ResDoc","/CT_CT_CareProv.d")
	w theme.SetLinkPath("TecCat","/CT_EMChargeCategory.d")
	w theme.SetLinkPath("TecSubCat","/CT_EMChargeChildCategory.d")
	w theme.SetLinkPath("TranFromLoc","/CT_Dept.d")
	w theme.SetLinkPath("TranFromWard","/CT_Dept.d")
	
	
	s fun=##class(DHCWL.DM.T.FunctionConfig).GetByPath("DYCDIMPRO:GroupFun")
	s funPara=##class(DHCWL.DM.T.FunParaConfig).GetParameter(fun.%Id(),"Code")
	
	s dim=theme.GetDim("AccCat")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTACCC_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("AccSubCat")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTACCCC_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("AdmStatus")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTPP_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("AntiFlag")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="UniCode"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("ArcCat")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTC_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("ArcSubCat")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTCC_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("ArcItem")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTARCIM_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("BillCat")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTBC_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("BillSubCat")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTBCC_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("ExeDep")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTD_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("ExeDepHos")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTH_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("ExeDoc")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTCP_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("PatDep")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTD_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("PatDepHos")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTH_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("PatDoc")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTCP_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("PatWard")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTD_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("PatWardHos")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTH_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("RecDep")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTD_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("RecDepHos")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTH_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("RecDoc")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTCP_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("ResDep")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTD_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("ResDepHos")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTH_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("ResDoc")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTCP_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("TecCat")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTEMCC_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("TecSubCat")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTEMCCC_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("TranFromLoc")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTD_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
	
	s dim=theme.GetDim("TranFromWard")
	s paraUse=##class(DHCWL.DM.T.FunParaUsing).GetInstance("DHCWL.DM.T.ThemeDims:"_dim.%Id(),funPara.%Id())
	if paraUse=""{
		s paraUse=##class(DHCWL.DM.T.FunParaUsing).%New()
	}
	s paraUse.UsingMaster="DHCWL.DM.T.ThemeDims:"_dim.%Id(),paraUse.DefinedPara=funPara,paraUse.ParaValue="CTD_Code"
	s status=paraUse.%Save()
	w:status'=$$$OK status,!
}

// d ##class(DHCWL.DM.MDR.ThemeInit).CubeInit()

ClassMethod CubeInit()
{
    s status= ##class(DHCWL.DM.T.CubeBase).NewCube2("/DW/DHCWorkLoad.t",$lb("OrdDate","AccCat","AccSubCat","AdmStatus","AdmType","ArcCat","ArcItem","ArcSubCat","BillCat","BillSubCat","ExeDep","ExeDepHos","ExeDoc","InCat","InSubCat","MRCat","MRSubCat","PatDep","PatDepHos","PatDoc","PatWard","PatWardHos","RecDep","RecDepHos","RecDoc","ResDep","ResDepHos","ResDoc","TecCat","TecSubCat","TranFromLoc","TranFromWard"),$lb("TotleFee","ZFFee","ZKFee","JZFee","Quantity"),"DHCWorkLoad_OrdDate1")
    if status'=$$$OK {
	    Do DisplayError^%apiOBJ(status)
	    q status
    }
		s status= ##class(DHCWL.DM.T.CubeBase).NewCube2("/DW/DHCWorkLoad.t",$lb("OrdDate","PatDoc","RecDoc","ResDoc","PatDep","RecDep","ResDep","ResDepHos","RecDepHos","PatDepHos","TranFromLoc","TranFromWard","AccCat","AccSubCat","AccountMonth","AdmDate","AdmStatus","AdmTime","AdmType","AnaeCode","AntiFlag","ArcCat","ArcItem","ArcSubCat","BaseDrugFlag","BillCat","BillSubCat","ConsumFlag","CreatDate","CreatTime","DisDate","DisTime","DrugFlag","ExeDep","ExeDepHos","ExeDoc","ExeDocMG","ExeDocSM","ExecDate","ExecItem","ExecTime","FlagMonth","FlagTime","FlagYN","HISKey","HVCFlag","HandInFlagYN","HandMonth","HandTime","InCat","InSubCat","InjectFlag","MDRType","MRCat","MRSubCat","OeordDirect","OeoriDate","OeoriItem","OeoriTime","OpCat","OpSubCat","OperCode","OperFlag","OrdMonth","OrdTime","PBDNo","PBJNType","PBNo","PBONo","PHCCat","PHCPO","PapmiNo","PatBed","PatBillJN","PatDocMG","PatDocSM","PatRoom","PatWard","PatWardHos","RecDocMG","RecDocSM","Receiver","ResDocMG","ResDocSM","SeqNo","StockCat","TariCat","TariItem","TariSubCat","TecCat","TecSubCat","UpdateDate","UpdateTime","UniCode","UnitPrice","ItmMastUnitPrice"),$lb("TotleFee","ZFFee","ZKFee","JZFee","Quantity"),"DHCWorkLoad_OrdDate2")
    if status'=$$$OK {
	    Do DisplayError^%apiOBJ(status)
	    q status
    }
    s status= ##class(DHCWL.DM.T.CubeBase).NewCube2("/DW/DHCWorkLoad.t",$lb("HandDate","AccCat","AccSubCat","AdmStatus","AdmType","ArcCat","ArcItem","ArcSubCat","BillCat","BillSubCat","ExeDep","ExeDepHos","ExeDoc","InCat","InSubCat","MRCat","MRSubCat","PatDep","PatDepHos","PatDoc","PatWard","PatWardHos","RecDep","RecDepHos","RecDoc","ResDep","ResDepHos","ResDoc","TecCat","TecSubCat","TranFromLoc","TranFromWard"),$lb("TotleFee","ZFFee","ZKFee","JZFee","Quantity"),"DHCWorkLoad_HandDate1")
    if status'=$$$OK {
	    Do DisplayError^%apiOBJ(status)
	    q status
    }
    s status= ##class(DHCWL.DM.T.CubeBase).NewCube2("/DW/DHCWorkLoad.t",$lb("HandDate","PatDoc","RecDoc","ResDoc","PatDep","RecDep","ResDep","ResDepHos","RecDepHos","PatDepHos","TranFromLoc","TranFromWard","AccCat","AccSubCat","AccountMonth","AdmDate","AdmStatus","AdmTime","AdmType","AnaeCode","AntiFlag","ArcCat","ArcItem","ArcSubCat","BaseDrugFlag","BillCat","BillSubCat","ConsumFlag","CreatDate","CreatTime","DisDate","DisTime","DrugFlag","ExeDep","ExeDepHos","ExeDoc","ExeDocMG","ExeDocSM","ExecDate","ExecItem","ExecTime","FlagMonth","FlagTime","FlagYN","HISKey","HVCFlag","HandInFlagYN","HandMonth","HandTime","InCat","InSubCat","InjectFlag","MDRType","MRCat","MRSubCat","OeordDirect","OeoriDate","OeoriItem","OeoriTime","OpCat","OpSubCat","OperCode","OperFlag","OrdMonth","OrdTime","PBDNo","PBJNType","PBNo","PBONo","PHCCat","PHCPO","PapmiNo","PatBed","PatBillJN","PatDocMG","PatDocSM","PatRoom","PatWard","PatWardHos","RecDocMG","RecDocSM","Receiver","ResDocMG","ResDocSM","SeqNo","StockCat","TariCat","TariItem","TariSubCat","TecCat","TecSubCat","UpdateDate","UpdateTime","UniCode","UnitPrice","ItmMastUnitPrice"),$lb("TotleFee","ZFFee","ZKFee","JZFee","Quantity"),"DHCWorkLoad_HandDate2")
    if status'=$$$OK {
	    Do DisplayError^%apiOBJ(status)
	    q status
    }
    s status= ##class(DHCWL.DM.T.CubeBase).NewCube2("/DW/DHCWorkLoad.t",$lb("FlagDate","AccCat","AccSubCat","AdmStatus","AdmType","ArcCat","ArcItem","ArcSubCat","BillCat","BillSubCat","ExeDep","ExeDepHos","ExeDoc","InCat","InSubCat","MRCat","MRSubCat","PatDep","PatDepHos","PatDoc","PatWard","PatWardHos","RecDep","RecDepHos","RecDoc","ResDep","ResDepHos","ResDoc","TecCat","TecSubCat","TranFromLoc","TranFromWard"),$lb("TotleFee","ZFFee","ZKFee","JZFee","Quantity"),"DHCWorkLoad_FlagDate1")
    if status'=$$$OK {
	    Do DisplayError^%apiOBJ(status)
	    q status
    }
    s status= ##class(DHCWL.DM.T.CubeBase).NewCube2("/DW/DHCWorkLoad.t",$lb("FlagDate","PatDoc","RecDoc","ResDoc","PatDep","RecDep","ResDep","ResDepHos","RecDepHos","PatDepHos","TranFromLoc","TranFromWard","AccCat","AccSubCat","AccountMonth","AdmDate","AdmStatus","AdmTime","AdmType","AnaeCode","AntiFlag","ArcCat","ArcItem","ArcSubCat","BaseDrugFlag","BillCat","BillSubCat","ConsumFlag","CreatDate","CreatTime","DisDate","DisTime","DrugFlag","ExeDep","ExeDepHos","ExeDoc","ExeDocMG","ExeDocSM","ExecDate","ExecItem","ExecTime","FlagMonth","FlagTime","FlagYN","HISKey","HVCFlag","HandInFlagYN","HandMonth","HandTime","InCat","InSubCat","InjectFlag","MDRType","MRCat","MRSubCat","OeordDirect","OeoriDate","OeoriItem","OeoriTime","OpCat","OpSubCat","OperCode","OperFlag","OrdMonth","OrdTime","PBDNo","PBJNType","PBNo","PBONo","PHCCat","PHCPO","PapmiNo","PatBed","PatBillJN","PatDocMG","PatDocSM","PatRoom","PatWard","PatWardHos","RecDocMG","RecDocSM","Receiver","ResDocMG","ResDocSM","SeqNo","StockCat","TariCat","TariItem","TariSubCat","TecCat","TecSubCat","UpdateDate","UpdateTime","UniCode","UnitPrice","ItmMastUnitPrice"),$lb("TotleFee","ZFFee","ZKFee","JZFee","Quantity"),"DHCWorkLoad_FlagDate2")
    if status'=$$$OK {
	    Do DisplayError^%apiOBJ(status)
	    q status
    }
    s status= ##class(DHCWL.DM.T.CubeBase).NewCube2("/DW/DHCWorkLoad.t",$lb("AccountDate","AccCat","AccSubCat","AdmStatus","AdmType","ArcCat","ArcItem","ArcSubCat","BillCat","BillSubCat","ExeDep","ExeDepHos","ExeDoc","InCat","InSubCat","MRCat","MRSubCat","PatDep","PatDepHos","PatDoc","PatWard","PatWardHos","RecDep","RecDepHos","RecDoc","ResDep","ResDepHos","ResDoc","TecCat","TecSubCat","TranFromLoc","TranFromWard"),$lb("TotleFee","ZFFee","ZKFee","JZFee","Quantity"),"DHCWorkLoad_AccountDate1")
    if status'=$$$OK {
	    Do DisplayError^%apiOBJ(status)
	    q status
    }
    s status= ##class(DHCWL.DM.T.CubeBase).NewCube2("/DW/DHCWorkLoad.t",$lb("AccountDate","PatDoc","RecDoc","ResDoc","PatDep","RecDep","ResDep","ResDepHos","RecDepHos","PatDepHos","TranFromLoc","TranFromWard","AccCat","AccSubCat","AccountMonth","AdmDate","AdmStatus","AdmTime","AdmType","AnaeCode","AntiFlag","ArcCat","ArcItem","ArcSubCat","BaseDrugFlag","BillCat","BillSubCat","ConsumFlag","CreatDate","CreatTime","DisDate","DisTime","DrugFlag","ExeDep","ExeDepHos","ExeDoc","ExeDocMG","ExeDocSM","ExecDate","ExecItem","ExecTime","FlagMonth","FlagTime","FlagYN","HISKey","HVCFlag","HandInFlagYN","HandMonth","HandTime","InCat","InSubCat","InjectFlag","MDRType","MRCat","MRSubCat","OeordDirect","OeoriDate","OeoriItem","OeoriTime","OpCat","OpSubCat","OperCode","OperFlag","OrdMonth","OrdTime","PBDNo","PBJNType","PBNo","PBONo","PHCCat","PHCPO","PapmiNo","PatBed","PatBillJN","PatDocMG","PatDocSM","PatRoom","PatWard","PatWardHos","RecDocMG","RecDocSM","Receiver","ResDocMG","ResDocSM","SeqNo","StockCat","TariCat","TariItem","TariSubCat","TecCat","TecSubCat","UpdateDate","UpdateTime","UniCode","UnitPrice","ItmMastUnitPrice"),$lb("TotleFee","ZFFee","ZKFee","JZFee","Quantity"),"DHCWorkLoad_AccountDate2")
    if status'=$$$OK {
	    Do DisplayError^%apiOBJ(status)
	    q status
    }
    d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/DW/DHCWorkLoad.t")
    d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/DW/DHCWorkLoad.t")
    d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/DW/DHCWorkLoad.t")
    d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/DW/DHCWorkLoad.t")
}

// d ##class(DHCWL.DM.MDR.ThemeInit).CubeFetchInit()

ClassMethod CubeFetchInit()
{
	d ##class(DHCWL.DM.T.CubeFetchConfig).FetchConfig("DHCWorkLoad_OrdDate1","OrdDate")
	d ##class(DHCWL.DM.T.CubeFetchConfig).FetchConfig("DHCWorkLoad_OrdDate2","OrdDate")
	d ##class(DHCWL.DM.T.CubeFetchConfig).FetchConfig("DHCWorkLoad_HandDate1","HandDate")
	d ##class(DHCWL.DM.T.CubeFetchConfig).FetchConfig("DHCWorkLoad_HandDate2","HandDate")
	d ##class(DHCWL.DM.T.CubeFetchConfig).FetchConfig("DHCWorkLoad_FlagDate1","FlagDate")
	d ##class(DHCWL.DM.T.CubeFetchConfig).FetchConfig("DHCWorkLoad_FlagDate2","FlagDate")
	d ##class(DHCWL.DM.T.CubeFetchConfig).FetchConfig("DHCWorkLoad_AccountDate1","AccountDate")
	d ##class(DHCWL.DM.T.CubeFetchConfig).FetchConfig("DHCWorkLoad_AccountDate2","AccountDate")
}

// d ##class(DHCWL.DM.MDR.ThemeInit).BuildData()

ClassMethod BuildData()
{
	s status=##class(DHCWL.DM.I.Manage).ThemeDataManualBuild("/DW/DHCWorkLoad.t","2016-05-27","2016-08-27",1) //"2012-01-01","2012-01-01"
	Do DisplayError^%apiOBJ(status)
	/*d DecomposeStatus^%apiOBJ(status,.err,"-d") 
	  s errStr="" ,oneErr="" f {
	    s oneErr=$o(err(oneErr))
	    q:oneErr=""
	    s errStr=errStr_"  "_err(oneErr)
	  }
	w errStr*/
}

// d ##class(DHCWL.DM.MDR.ThemeInit).QueryData("2016-07-27","2016-07-27")

ClassMethod QueryData(sd, ed)
{
	s cql="rs1:{"_
            "from: /DW/DHCWorkLoad.t,"_
            //"dims : AdmType,"_
            "dims: AdmType,PatDep->CTD_Code,PatDep->CTD_Desc,PatDoc,"_
            
            "metrics: sum(TotleFee) price,"_ //
            "filter:  (OrdDate between("_sd_","_ed_")) ,"_
            "print:true,"_
          "};"
  ;  s cql="rs1:{from: /DW/DHCWorkLoad.t , dims: AdmType AS AdmType,PatDep->CTD_Code AS dim2,PatDep->CTD_Desc AS dim3,PatDoc AS PatDoc , metrics: sum(TotleFee) AS test2 , filter: OrdDate between(2016-06-22,2016-06-22) && AdmType =(I)}"
  s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	s status= parser.Parse(cql)
	if status'=$$$OK{
		w status,!
		q
	}
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	w executor.Execute(),!
	s it=executor.GetIterator("rs1")
	w $lts(it.GetDimMeta(),"    ",1),"    "
	w $lts(it.GetMetricMeta(),"    ",1),!
	s count=0
	while (it.HasNext()){
	  w $lts(it.CurDims(),":",1)_"   ;  "_$lts(it.CurMetrics(),":",1),!
	  s count=count+1
	}
	w "count:"_count,!
	d executor.Close()
	s executor="",parser=""
}

}
