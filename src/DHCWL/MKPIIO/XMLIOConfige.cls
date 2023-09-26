Class DHCWL.MKPIIO.XMLIOConfige Extends %RegisteredObject [ Not ProcedureBlock ]
{

/*
*该类问数据配置及其辅助方法类
*Creator:李海红
*/
/// 配置时运行方法
/// d ##class(DHCWL.MKPIIO.XMLIOConfige).test()
ClassMethod test()
{
		d ..ConfigeCodeAndId()
}

/// 配置每个表中Code和ID的关系（即哪个字段可以获得唯一ID）
/// d ##class(DHCWL.MKPIIO.XMLIOConfige).ConfigeCodeAndId()
/// Creator:李海红
ClassMethod ConfigeCodeAndId()
{
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.Day")="KPIMDCode"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.MKPI")="MKPICode"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.MKPIDimType")="KDTCode"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.MKPIFL")="MKPIFLCode"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.Months")="KPIMCode"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.Section")="SecCode"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.DimProperty")="DimDr||Code"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.MKPIDimensions")="MKPIDr||MKPIDimCode"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.CreatDataTask")="DTaskKPIDR||DTaskSectionDR"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.SectionProperty")="SecDimDr||Code"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.ExecuteCode")="ExeCodeType||ExcCodeSubType||ExeCodeWrite"
	 //add by wz
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.MMgrModuleCfg")="ModuleCfgTreeCode"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.MMgrRptCfg")="RptCfgTreeCode||RptCfgCode"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.MMgrDataSetCfg")="DatasetTreeCode||DatasetRptCode||DatasetCfgCode"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.MMgrKPICfg")="KPITreeCode||KPIRptCode||KPIDatasetCfgCode||KPICfgCode"
	 //add by wk
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.MKPIMeasure")="MKPIKpiDr||MKPIMeaDr"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MeasureDimrole.Measure")="MeaCode"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.ConfigTaskGroup")="DTaskGroupCode"
	 s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.TaskGroupDetail")="DTaskGroupDr||DTaskKpiDr"

	 //s ^DHCWL.MKPI.CodeAndId("DHCWL.MKPI.ModeMagKpiCfg")="ID"
}

/// s res=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeByClassName("DHCWL.MKPI.Day")
/// Creator:李海红
ClassMethod GetCodeByClassName(className) As %String
{
	n (className)
	q $g(^DHCWL.MKPI.CodeAndId(className))
}

/// s res=##class(DHCWL.MKPIIO.XMLIOConfige).GetPrimaryFieldByClassName("DHCWL.MKPI.Day")
ClassMethod GetPrimaryFieldByClassName(className) As %String
{
	n (className)
	q $g(^DHCWL.MKPI.CodeAndId(className))
}

/// s res=##class(DHCWL.MKPIIO.XMLIOConfige).GetPrimaryValue(a,"cc")
ClassMethod GetPrimaryValue(obj As %ObjectHandle, primaryField, defDeli = "||") As %String
{
	n (obj,primaryField,defDeli)
	s len=$l(primaryField,defDeli),primaryValue=""
	if (primaryField="ID"){
		x "s primaryValue=obj.%Id()"
		q primaryValue
	}
	NEW $ETRAP
	s $ETRAP="d ##class(DHCWL.MKPIIO.XMLIOConfige).RunError()"
	f i=1:1:len {
		s field=$p(primaryField,defDeli,i)
		s value=##class(DHCWL.MKPIIO.InputFromXML).ReflactProperty(obj,field)
		if (value_"" [ "@"){
			s tempClass=##class(DHCWL.MKPIIO.util.ClassType).GetClassFullNameFromHandle(value)
			s tempField=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeByClassName(tempClass)
			s value=..GetPrimaryValue(value,tempField)
		}
		if i=1 s primaryValue=value
		else  s primaryValue=primaryValue_defDeli_value
	}
	q primaryValue
}

ClassMethod RunError()
{
	s $ETRAP=""
	NEW $ETRAP
	q ""
}

/// 根据id或code返回给定表结构的id，无论入参是id或code确保一定返回的是id（如果存在该id的话）
/// 根据对象Code获得对象的ID
/// s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode("EPRMRPoison10DDShswNums","DHCWL.MKPI.MKPI")
/// Creator:李海红
ClassMethod GetIdByCode(code, classType)
{
	n (code, classType)
	q:(code="")||(classType="") ""
	s inputCode=code
	s code=$zcvt(code,"U")
	s alphaCode=$SYSTEM.SQL.ALPHAUP(inputCode)  //w $SYSTEM.SQL.ALPHAUP(" hello haha--_||dd")
	if (classType="DHCWL.MKPI.Section"){
		i $d(^DHCWL.MKPI.SectionD(code)) q code
		S id=$o(^DHCWL.MKPI.SectionI("SecCode",alphaCode,""))
		i id="" q $o(^DHCWL.MKPI.SectionI("SecCode"," "_code,""))
		q id
	}elseif (classType="DHCWL.MKPI.Months"){
		//q ##class(DHCWL.MKPIService.ConfigService).GetMonthByCode(code)
		i $d(^DHCWL.MKPI.MonthsD(code)) q code
		s id=$o(^DHCWL.MKPI.MonthsI("Code",alphaCode,""))
		i id="" q $o(^DHCWL.MKPI.MonthsI("Code"," "_code,""))
		q id
	}elseif (classType="DHCWL.MKPI.MKPIFL"){
		;s code=$zconvert(code,"U")
		;q:code="" ""
		i $d(^DHCWL.MKPI.MKPIFLD(code)) q code
		s id=$o(^DHCWL.MKPI.MKPIFLI("FLCode",alphaCode,""))
		i id="" q $o(^DHCWL.MKPI.MKPIFLI("FLCode"," "_code,""))
		q id
	}elseif(classType="DHCWL.MKPI.MKPIDimType"){
		;s code=$zconvert(code,"U")
		i $d(^DHCWL.MKPI.MKPIDimTypeD(code)) q code
		s id=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",alphaCode,""))
		i id="" q $o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI"," "_code,""))
		q id
	}elseif(classType="DHCWL.MKPI.MKPI"){
		i $d(^DHCWL.MKPI.MKPID(code)) q code
		s id=$o(^DHCWL.MKPI.MKPII("MKPICode",alphaCode,""))
		i id="" q $o(^DHCWL.MKPI.MKPII("MKPICode"," "_code,""))
		q id
		;q ##class(DHCWL.MKPIService.ConfigService).GetKPIByName(code)
	}elseif(classType="DHCWL.MKPI.Day"){
		q $o(^DHCWL.MKPI.DayI("Code",code,""))
	}elseif(classType="DHCWL.MKPI.DimProperty"){
		i $d(^DHCWL.MKPI.DimPropertyD(code)) q code
		s dimCode=$p(code,"||",1)
		s proCode=$p(code,"||",2)
		q:(dimCode="")||(proCode="") ""
		s dimId=..GetIdByCode(dimCode,"DHCWL.MKPI.MKPIDimType")
		q:dimId="" ""
		s proCode2=$SYSTEM.SQL.ALPHAUP(proCode)   ;$zcvt(proCode,"U")
		s id=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimId,proCode2,""))
		i id="" q $o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimId," "_$zcvt(proCode,"U"),""))
		q id
	}elseif(classType="DHCWL.MKPI.MKPIDimensions"){
		i $d(^DHCWL.MKPI.MKPIDimensionsD(code)) q code
		s kpiCode=$p(code,"||",1)
		s dimCode=$p(code,"||",2)
		q:(kpiCode="")||(dimCode="") ""
		s kpiId=##class(DHCWL.MKPIService.ConfigService).GetKPIByName(kpiCode)
		q:(kpiId="")||(dimCode="") ""
		s dimCode2=$SYSTEM.SQL.ALPHAUP(dimCode)  ;$zcvt(dimCode,"U")
		s id=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,dimCode2,""))
		i id="" q $o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId," "_$zcvt(dimCode,"U"),""))
		q id
	}elseif(classType="DHCWL.MKPI.CreatDataTask"){
		i $d(^DHCWL.MKPI.CreatDataTaskD(code)) q code
		s kpiId=$p(code,"||",1)
		s secId=$p(code,"||",2)
		s:($g(kpiId)'="") kpiId=..GetIdByCode(kpiId,"DHCWL.MKPI.MKPI")
		s:($g(secId)'="") secId=..GetIdByCode(secId,"DHCWL.MKPI.Section")
		q:($g(kpiId)="")||($g(secId)="") ""
		if $d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secId,kpiId)) {
			s act=$o(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secId,kpiId,""))
			q:act="" ""
			q $o(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secId,kpiId,act,""))
		}
		q ""
	}elseif(classType="DHCWL.MKPI.SectionProperty"){
		i $d(^DHCWL.MKPI.SectionPropertyD(code)) q code
		s secCode=$p(code,"||",1)
		s secProCode=$p(code,"||",2)
		q:(secCode="")||(secProCode="") ""
		s secId=..GetIdByCode(secCode,"DHCWL.MKPI.Section")
		q:(secId="") ""
		s secProCodeAlp=$SYSTEM.SQL.ALPHAUP(secProCode)  ;$zcvt(dimCode,"U")
		s id=$o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",secId,secProCodeAlp,""))
		i id="" q $o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",secId," "_$zcvt(secProCode,"U"),""))
		q id
	}elseif(classType="DHCWL.MKPI.MMgrModuleCfg"){
		i $d(^DHCWL.MKPI.MMgrModuleCfgD(code)) q code
		if ($d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",inputCode))){
			q $o(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",inputCode,""))
		}
		/*
		if ($d(^DHCWL.MKPI.ModeMagModeCfgI("ModeCfgCodeUnqIdx1"," "_code))){
			q $o(^DHCWL.MKPI.ModeMagModeCfgI("ModeCfgCodeUnqIdx1"," "_code,""))
		}
		if ($d(^DHCWL.MKPI.ModeMagModeCfgI("ModeCfgCodeUnqIdx1",alphaCode))){
			q $o(^DHCWL.MKPI.ModeMagModeCfgI("ModeCfgCodeUnqIdx1",alphaCode,""))
		}
		*/
		q ""
	}elseif(classType="DHCWL.MKPI.MMgrRptCfg"){
		i $d(^DHCWL.MKPI.MMgrRptCfgD(code)) q code
		s treeCode=$p(inputCode,"||",1)
		s rptCode=$p(inputCode,"||",2)
		if ($d(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,rptCode))){
			q $o(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,rptCode,""))
		}
		/*
		if ($d(^DHCWL.MKPI.ModeMagRptCfgI("RptCfgCodeUnqIdx1"," "_code))){
			q $o(^DHCWL.MKPI.ModeMagRptCfgI("RptCfgCodeUnqIdx1"," "_code,""))
		}
		if ($d(^DHCWL.MKPI.ModeMagRptCfgI("RptCfgCodeUnqIdx1",alphaCode))){
			q $o(^DHCWL.MKPI.ModeMagRptCfgI("RptCfgCodeUnqIdx1",alphaCode,""))
		}
		*/
		q ""
	}elseif(classType="DHCWL.MKPI.MMgrDataSetCfg"){
		i $d(^DHCWL.MKPI.MMgrDataSetCfgD(code)) q code
		s treeCode=$p(inputCode,"||",1)
		s rptCode=$p(inputCode,"||",2)
		s datasetCode=$p(inputCode,"||",3)
		if ($d(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rptCode,datasetCode))){
			q $o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rptCode,datasetCode,""))
		}
		q ""
	}elseif(classType="DHCWL.MKPI.MMgrKPICfg"){
		i $d(^DHCWL.MKPI.MMgrKPICfgD(code)) q code
		s treeCode=$p(inputCode,"||",1)
		s rptCode=$p(inputCode,"||",2)
		s datasetCode=$p(inputCode,"||",3)
		s kpiCode=$p(inputCode,"||",4)
		if ($d(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",treeCode,rptCode,datasetCode,kpiCode))){
			q $o(^DHCWL.MKPI.MMgrKPICfgI("TRDKIdx",treeCode,rptCode,datasetCode,kpiCode,""))
		}
		q ""

	}elseif(classType="DHCWL.MKPI.ExecuteCode"){
		i $d(^DHCWL.MKPI.ExecuteCodeD(code)) q code
		s type=$p(inputCode,"||",1)
		s subType=$p(inputCode,"||",2)
		s code=$p(inputCode,"||",3)
		s id=""
		&sql(select ID into :id from DHCWL_MKPI.MKPI_ExecuteCode where ExeCode_Type=:type and ExcCode_SubType=:subType and ExcCode_Write=:code )
		q id

	}elseif(classType="DHCWL.MKPI.ConfigTaskGroup"){
		i $d(^DHCWL.MKPI.ConfigTaskGroupD(code)) q code
		S id=$o(^DHCWL.MKPI.ConfigTaskGroupI("Code",alphaCode,""))
		i id="" q $o(^DHCWL.MKPI.ConfigTaskGroupI("Code"," "_code,""))
		q id
	}elseif(classType="DHCWL.MKPI.TaskGroupDetail"){
		i $d(^DHCWL.MKPI.TaskGroupDetailD(code)) q code
		s groupCode=$p(inputCode,"||",1)
		s groupDetail=$p(inputCode,"||",2)
		s id=""
		&sql(select a.ID into :id from DHCWL_MKPI.DHCWLTaskGroupDetail a,DHCWL_MKPI.DHCWLConfigTaskGroup b where a.DTask_GroupDr=b.ID and a.DTask_KpiDr=:groupDetail and b.DTask_GroupCode=:groupCode)
		q id
	}elseif(classType="DHCWL.MeasureDimrole.Measure"){
		i $d(^DHCWL.MeasureDimrole.MeasureD(code)) q code
		S id=$o(^DHCWL.MeasureDimrole.MeasureI("Code",alphaCode,""))
		i id="" q $o(^DHCWL.MeasureDimrole.MeasureI("Code"," "_code,""))
		q id
	}elseif(classType="DHCWL.MKPI.MKPIMeasure"){
		i $d(^DHCWL.MKPI.MKPIMeasureD(code)) q code
		s kpiCode=$p(inputCode,"||",1)
		s meaCode=$p(inputCode,"||",2)
		s kpiDr=$o(^DHCWL.MKPI.MKPII("MKPICode",$zcvt(kpiCode,"U"),""))
		s meaDr=$o(^DHCWL.MeasureDimrole.MeasureI("Code"," "_$zcvt(meaCode,"U"),""))
		s id=""
		s id=$o(^DHCWL.MKPI.MKPIMeasureI("MKPIMeaI",kpiDr,meaDr,""))
		q id
	}else{
		q ""
	}
}

/// 根据id或code返回给定表结构的code，无论入参是id或code确保一定返回的是code（如果存在该code的话）
/// s res=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(170,"DHCWL.MKPI.DimProperty")
ClassMethod GetCodeById(id, classType)
{
	n (id, classType)
	q:(id="")||(classType="") ""
	s gessId=..GetIdByCode(id,classType)
	i (gessId'="")&&(gessId'=id) q id
	if (classType="DHCWL.MKPI.Section"){
		q:'$d(^DHCWL.MKPI.SectionD(id)) ""
		i $d(^DHCWL.MKPI.SectionD(id)) q $lg(^DHCWL.MKPI.SectionD(id),2)
		q ""
	}elseif (classType="DHCWL.MKPI.Months"){
		q:'$d(^DHCWL.MKPI.Months(id)) ""
		i $d(^DHCWL.MKPI.Months(id)) q $lg(^DHCWL.MKPI.Months(id),2)
		q ""
	}elseif (classType="DHCWL.MKPI.MKPIFL"){
		q:'$d(^DHCWL.MKPI.MKPIFLD(id)) ""
		i $d(^DHCWL.MKPI.MKPIFLD(id)) q $lg(^DHCWL.MKPI.MKPIFLD(id),2)
		q ""
	}elseif(classType="DHCWL.MKPI.MKPIDimType"){
		q:'$d(^DHCWL.MKPI.MKPIDimTypeD(id)) ""
		i $d(^DHCWL.MKPI.MKPIDimTypeD(id)) q $lg(^DHCWL.MKPI.MKPIDimTypeD(id),2)
		q ""
	}elseif(classType="DHCWL.MKPI.MKPIDimensions"){
		q:'$d(^DHCWL.MKPI.MKPIDimensionsD(id)) ""
		s kpiCode=..GetCodeById($lg(^DHCWL.MKPI.MKPIDimensionsD(id),3),"DHCWL.MKPI.MKPI")
		s dimCode=$lg(^DHCWL.MKPI.MKPIDimensionsD(id),2)
		q kpiCode_"||"_dimCode
	}elseif(classType="DHCWL.MKPI.DimProperty"){
		q:'$d(^DHCWL.MKPI.DimPropertyD(id)) ""
		q ..GetCodeById($lg(^DHCWL.MKPI.DimPropertyD(id),2),"DHCWL.MKPI.MKPIDimType")_"||"_$lg(^DHCWL.MKPI.DimPropertyD(id),3)
	}elseif(classType="DHCWL.MKPI.MKPI"){
		q:'$d(^DHCWL.MKPI.MKPID(id)) ""
		i $d(^DHCWL.MKPI.MKPID(id)) q $lg(^DHCWL.MKPI.MKPID(id),2)
		q ""
	}elseif(classType="DHCWL.MKPI.Day"){
		q:'$d(^DHCWL.MKPI.DayD(id)) ""
		i $d(^DHCWL.MKPI.DayD(id)) q lg(^DHCWL.MKPI.DayD(id),2)
		q ""
	}elseif(classType="DHCWL.MKPI.CreatDataTask"){
		q:'$d(^DHCWL.MKPI.CreatDataTaskD(id)) ""
		s kpiCode=..GetCodeById($lg(^DHCWL.MKPI.CreatDataTaskD(id),4),"DHCWL.MKPI.MKPI")
		s secCode=..GetCodeById($lg(^DHCWL.MKPI.CreatDataTaskD(id),5),"DHCWL.MKPI.Section")
		q kpiCode_"||"_secCode
	}elseif(classType="DHCWL.MKPI.SectionProperty"){
		q:'$d(^DHCWL.MKPI.SectionPropertyD(id)) ""
		s secId=$lg(^DHCWL.MKPI.DimPropertyD(id),6)
		s secCode=..GetCodeById(secId,"DHCWL.MKPI.Section")
		s secProCode=$lg(^DHCWL.MKPI.DimPropertyD(id),2)
		q secCode_"||"_secProCode
	}elseif(classType="DHCWL.MKPI.ModeMagModeCfg"){
		if ('$d(^DHCWL.MKPI.ModeMagModeCfgD(id))){
			if ($d(^DHCWL.MKPI.ModeMagModeCfgD(gessId))){
				s id=gessId
			}else{
				q ""
			}
		}
		q $lg(^DHCWL.MKPI.ModeMagModeCfgD(id),2)
	}elseif(classType="DHCWL.MKPI.ModeMagRptCfg"){
		if ('$d(^DHCWL.MKPI.ModeMagRptCfgD(id))){
			if ($d(^DHCWL.MKPI.ModeMagRptCfgD(gessId))){
				s id=gessId
			}else{
				q ""
			}
		}
		q $lg(^DHCWL.MKPI.ModeMagRptCfgD(id),2)
	}elseif(classType="DHCWL.MKPI.ModeMagKpiCfg"){
		if ('$d(^DHCWL.MKPI.ModeMagKpiCfgD(id))){
			q ""
			if ($d(^DHCWL.MKPI.ModeMagKpiCfgD(gessId))){
				s id=gessId
			}else{
				q ""
			}
		}
		q id
	}elseif(classType="DHCWL.MKPI.ExecuteCode"){
		if ($d(^DHCWL.MKPI.ExecuteCodeD(id))){
			s type=$lg(^DHCWL.MKPI.ExecuteCodeD(id),2)
			s subType=$lg(^DHCWL.MKPI.ExecuteCodeD(id),11)
			s code=$lg(^DHCWL.MKPI.ExecuteCodeD(id),3)
			q:code'="" type_"||"_subType_"||"_code
		}
		q ""

	}else{
		q ""
	}
}

}
