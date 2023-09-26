Import SQLUser

Class DHCBP.Anticoagulant Extends web.DHCClinicCom
{

// 获取所有的抗凝方式

Query FindAntModeList() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select %ID as Id,BPCAM_Code as Code,BPCAM_Desc as Name,BPCAM_SubType as Type 
	from DHC_BPC_AnticoagulantMode where BPCAM_SubType="H"
}

// 根据抗凝模式获取药品

// d ##class(DHCBP.Anticoagulant).GetDrugByAntModeId(2)

ClassMethod GetDrugByAntModeId(antId) As %GlobalBinaryStream
{
	// w ##class(DHCBP.Anticoagulant).GetDrugByAntModeId(2)
	&sql(DECLARE c CURSOR FOR
	SELECT BPCAMD_BPCAD_Dr into:drugId
	FROM DHC_BPC_AnticoagulantModeDrug WHERE BPCAMD_BPCAM_Dr=:antId)
	
	&sql(OPEN c)
	
    FOR { &sql(FETCH c)
        QUIT:SQLCODE 
        s drug=##class(User.DHCBPCAnticoagulantDrug).%OpenId(drugId)
        s Array(drugId,"Id")=drugId
        s Array(drugId,"Code")=drug.BPCADCode
        s Array(drugId,"Desc")=drug.BPCADDesc
        d drug.%Close()
    }
    &sql(Close c)
    b
    q ..ToJson(.Array)
}

// d ##class(DHCBP.Anticoagulant).GetDrugOptionsByAntModeId(114,5)

ClassMethod GetDrugOptionsByAntModeId(arrangeId, antId) As %GlobalBinaryStream
{
	// w ##class(DHCBP.Anticoagulant).GetDrugOptionsByAntModeId(2)
	&sql(DECLARE d CURSOR FOR
	SELECT BPCAMD_BPCAD_Dr into:drugId
	FROM DHC_BPC_AnticoagulantModeDrug WHERE BPCAMD_BPCAM_Dr=:antId)
	
	&sql(OPEN d)
	
    FOR { &sql(FETCH d)
        QUIT:SQLCODE 
        s drug=##class(User.DHCBPCAnticoagulantDrug).%OpenId(drugId)
        s Array(drugId,"Id")=drugId
        s Array(drugId,"Code")=drug.BPCADCode
        s Array(drugId,"Desc")=drug.BPCADDesc
        d drug.%Close()
        d ..GetDrugOptions(arrangeId,drugId,.DrugData)
		m Array(drugId,"Options")=DrugData
    }
    &sql(Close d)
    b
    q ..ToJson(.Array)
}

// 根据药品获取控件: 如果有业务数据获取业务数据，如没有则没有Value属性

// 由于表结构设计的原因,写代码要逐个判断；单位只能有两种；是否是盐水要单独处理

// d ##class(DHCBP.Anticoagulant).GetDrugOptions(5,1)

ClassMethod GetDrugOptions(arrangeId, drugId, Array) As %GlobalBinaryStream
{
	// w ##class(DHCBP.Anticoagulant).GetDrugOptions(1)
	s drug=##class(User.DHCBPCAnticoagulantDrug).%OpenId(drugId)
	s dataId=$$GetDataId()
	s drugData=""
	if (dataId){
	   s drugData=##class(User.DHCBPArrangeAnticoagulantDrug).%OpenId(dataId)
	}
	s drugDesc=drug.BPCADDesc
	s unitId=drug.BPCADUomDr
	
	s suDesc=""
	s unitDesc=""
	if (unitId){
	  s unit=##class(User.CTUOM).%OpenId(unitId)
	  s unitDesc=unit.CTUOMDesc
	}
	if (drug.BPCADBPCSUDr){
		s suId=drug.BPCADBPCSUDr.%Id()
		s su=##class(User.DHCBPCSpeedUnit).%OpenId(suId)
		s suDesc=su.BPCSUDesc
	}
	if (drug.BPCADFirstAmount>-1){
		//s Array("FirstAmount","Desc")=drugDesc_"首推"
		s Array("FirstAmount","Desc")="首推"
		s Array("FirstAmount","Code")="FirstAmount"
		s Array("FirstAmount","Unit")=unitDesc
		if (drugData) s Array("FirstAmount","Value")=$fn(drugData.BPAADFirstAmount,"",1)
	}
	if (drug.BPCADDose>-1){
		//s Array("Dose","Desc")=drugDesc_"剂量"
		s Array("Dose","Desc")="剂量"
		s Array("Dose","Code")="Dose"
		s Array("Dose","Unit")=suDesc
		if (drugData) s Array("Dose","Value")=$fn(drugData.BPAADDose,"",1)
	}
	if (drug.BPCADDuration>-1){
		//s Array("Duration","Desc")=drugDesc_"维持时间"
		s Array("Duration","Desc")="维持时间"
		s Array("Duration","Code")="Duration"
		s Array("Duration","Unit")="分钟"
		if (drugData) s Array("Duration","Value")=drugData.BPAADDuration
	}
	if (drug.BPCADFrequency>-1){
		//s Array("Frequency","Desc")=drugDesc_"频率"
		s Array("Frequency","Desc")="频率"
		s Array("Frequency","Code")="Frequency"
		s Array("Frequency","Unit")="分钟"
		if (drugData) s Array("Frequency","Value")=drugData.BPAADDuration
	}
	if (drug.BPCADNote>-1){
		//s Array("Note","Desc")=drugDesc_"Note"
		s Array("Note","Desc")="Note"
		s Array("Note","Code")="Note"
		s Array("Note","Unit")=""
		if (drugData) s Array("Note","Value")=drugData.BPAADNote
	}
	if (drug.BPCADCode="Saline"){
		//s Array("IntervalMinute","Desc")=drugDesc_"间隔时间"
		s Array("IntervalMinute","Desc")="间隔时间"
		s Array("IntervalMinute","Code")="IntervalMinute"
		s Array("IntervalMinute","Unit")="分钟"
		if (drugData) s Array("IntervalMinute","Value")=drugData.BPAADIntervalMinute
	}
	if (drug.BPCADAmount>-1){
		//s Array("Amount","Desc")=drugDesc_"总量"
		s Array("Amount","Desc")="总量"
		s Array("Amount","Code")="Amount"
		s Array("Amount","Unit")=unitDesc
		if (drugData) s Array("Amount","Value")=$fn(drugData.BPAADAmount,"",1)
	}
	
	b
	q ..ToJson(.Array)
GetDataId()
    &sql(SELECT BPAAD_RowId into:dataId FROM DHC_BP_ArrangeAnticoagulantDrug 
    WHERE BPAAD_BPArrange_Dr=:arrangeId AND BPAAD_BPCAD_Dr=:drugId AND BPAAD_IfAbandon!="Y")
    q dataId
}

// 河南省医

ClassMethod GetArrangeSchemeDrugOptions(arrangeSchemeId, drugId, Array) As %GlobalBinaryStream
{
	// w ##class(DHCBP.Anticoagulant).GetDrugOptions(1)
	s drug=##class(User.DHCBPCAnticoagulantDrug).%OpenId(drugId)
	s dataId=$$GetDataId()
	s drugData=""
	if (dataId){
	   s drugData=##class(User.DHCBPSchemeAnticoagulantDrug).%OpenId(dataId)
	}
	s drugDesc=drug.BPCADDesc
	s unitId=drug.BPCADUomDr
	s unitDesc=""
	s speedId=drug.BPCADBPCSUDr.%Id()
	s unitDesc=""
	s speedDesc=""
	if (unitId){
	  s unit=##class(User.CTUOM).%OpenId(unitId)
	  s unitDesc=unit.CTUOMDesc
	}
	if (speedId) {
		s SpeedUnit=##class(User.DHCBPCSpeedUnit).%OpenId(speedId)
		s speedDesc=SpeedUnit.BPCSUDesc
	}
	s:unitDesc="" unitDesc=speedDesc
	if (drug.BPCADFirstAmount>-1){
		//s Array("FirstAmount","Desc")=drugDesc_"首推"
		s Array("FirstAmount","Desc")="首推"
		s Array("FirstAmount","Code")="FirstAmount"
		s Array("FirstAmount","Unit")=unitDesc
		if (drugData) s Array("FirstAmount","Value")=drugData.BPSADFirstAmount 
	}
	if (drug.BPCADDose>-1){
		//s Array("Dose","Desc")=drugDesc_"追加量"
		s Array("Dose","Desc")="追加量"
		s Array("Dose","Code")="Dose"
		s Array("Dose","Unit")=speedDesc
		if (drugData) s Array("Dose","Value")=drugData.BPSADDose
	}
	if (drug.BPCADDuration>-1){
		//s Array("Duration","Desc")=drugDesc_"维持时间"
		s Array("Duration","Desc")="维持时间"
		s Array("Duration","Code")="Duration"
		s Array("Duration","Unit")="分钟"
		if (drugData) s Array("Duration","Value")=drugData.BPSADDuration
	}
	if (drug.BPCADFrequency>-1){
		//s Array("Frequency","Desc")=drugDesc_"频率"
		s Array("Frequency","Desc")="频率"
		s Array("Frequency","Code")="Frequency"
		s Array("Frequency","Unit")="分钟"
		if (drugData) s Array("Frequency","Value")=drugData.BPSADDuration
	}
	if (drug.BPCADNote>-1){
		//s Array("Note","Desc")=drugDesc_"Note"
		s Array("Note","Desc")="Note"
		s Array("Note","Code")="Note"
		s Array("Note","Unit")=""
		if (drugData) s Array("Note","Value")=drugData.BPSADNote
	}
	if (drug.BPCADCode="Saline"){
		//s Array("IntervalMinute","Desc")=drugDesc_"间隔时间"
		s Array("IntervalMinute","Desc")="间隔时间"
		s Array("IntervalMinute","Code")="IntervalMinute"
		s Array("IntervalMinute","Unit")="分钟"
		if (drugData) s Array("IntervalMinute","Value")=drugData.BPSADIntervalMinute
	}
	if (drug.BPCADAmount>-1){
		//s Array("Amount","Desc")=drugDesc_"总量"
		s Array("Amount","Desc")="总量"
		s Array("Amount","Code")="Amount"
		s Array("Amount","Unit")=unitDesc
		if (drugData) s Array("Amount","Value")=drugData.BPSADAmount
	}
	q ..ToJson(.Array)
GetDataId()
    &sql(SELECT BPSAD_RowId into:dataId FROM DHC_BP_SchemeAnticoagulantDrug 
    WHERE BPSAD_BPArrangeScheme_Dr=:arrangeSchemeId AND BPSAD_BPCAD_Dr=:drugId)
    i SQLCODE="0" q dataId
	e  q ""
}

// d ##class(DHCBP.Anticoagulant).GetAntDetails(1278)

ClassMethod GetAntDetails(arrangeId) As %GlobalBinaryStream
{
	// d ##class(DHCBP.Anticoagulant).GetAntDetails(4)
	s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
	s antModeId=""
	
	if (arrange.BPAAnticoagulantModeDr) {
		if (arrange.BPAAnticoagulantModeDr.BPCAMSubType="H"){
			s antModeId=arrange.BPAAnticoagulantModeDr.%Id()
			s Array("AntModeId")=antModeId
			s Array("AntModeCode")=arrange.BPAAnticoagulantModeDr.BPCAMCode
			s Array("AntModeDesc")=arrange.BPAAnticoagulantModeDr.BPCAMDesc
			&sql(DECLARE DrugCursorhnsy CURSOR FOR 
			SELECT BPAAD_RowId into :drugDataId FROM DHC_BP_ArrangeAnticoagulantDrug 
			where BPAAD_BPArrange_Dr=:arrangeId)
			&sql(OPEN DrugCursorhnsy)
			FOR { 
				&sql(FETCH DrugCursorhnsy)
	    		QUIT:SQLCODE 
				//s drugDataId=..GetDrugDataId(arrangeId)
				if (drugDataId){
	      			s drugDataObj=##class(User.DHCBPArrangeAnticoagulantDrug).%OpenId(drugDataId)
	       			if (drugDataObj.BPAADIfAbandon'="Y"){
		       			s drugId=drugDataObj.BPAADBPCADDr.%Id()
			   			d ..GetDrugOptions(arrangeId,drugId,.DrugData)
			   			s Array("Drug",drugDataId,"DrugDataId")=drugDataId
			   			s Array("Drug",drugDataId,"DrugId")=drugId
			   			s Array("Drug",drugDataId,"DrugDesc")=drugDataObj.BPAADBPCADDr.BPCADDesc
			   			s Array("Drug",drugDataId,"DrugCode")=drugDataObj.BPAADBPCADDr.BPCADCode
			   			m Array("Drug",drugDataId,"Options")=DrugData
	       			}
				}
			}
			&sql(CLOSE DrugCursorhnsy)
		}
		
	}
	else{
		if (arrange.BPASecondBPCBPModeDr) s bpModeDr=arrange.BPASecondBPCBPModeDr.%Id()
		else  s bpModeDr=arrange.BPABPCBPModeDr.%Id()
		s schemeId=arrange.BPABPSchemeDr.%Id()
		s arrangeSchemeId=$$GetArrangeSchemeId()
		s arrangeSchemeObj=##class(User.DHCBPArrangeScheme).%OpenId(arrangeSchemeId)
		i (arrangeSchemeObj.BPASAnticoagulantModeDr.BPCAMSubType="H"){
			i (arrangeSchemeObj.BPASAnticoagulantModeDr){
				s Array("AntModeId")=arrangeSchemeObj.BPASAnticoagulantModeDr.%Id()
				s Array("AntModeCode")=arrangeSchemeObj.BPASAnticoagulantModeDr.BPCAMCode
				s Array("AntModeDesc")=arrangeSchemeObj.BPASAnticoagulantModeDr.BPCAMDesc
			}
		
			&sql(DECLARE SDrugCursorhnsy CURSOR FOR 
			SELECT BPSAD_RowId into :drugDataId FROM DHC_BP_SchemeAnticoagulantDrug 
			where BPSAD_BPArrangeScheme_Dr=:arrangeSchemeId)
			&sql(OPEN SDrugCursorhnsy)
			FOR { 
				&sql(FETCH SDrugCursorhnsy)
	    		QUIT:SQLCODE 
				if (drugDataId){
	      			s drugDataObj=##class(User.DHCBPSchemeAnticoagulantDrug).%OpenId(drugDataId)
	       			if (drugDataObj.BPSADIfAbandon'="Y"){
		       			if (drugDataObj.BPSADBPCADDr){
			   				s drugId=drugDataObj.BPSADBPCADDr.%Id()
			   				d ..GetArrangeSchemeDrugOptions(arrangeSchemeId,drugId,.DrugData)
			   				s Array("Drug",drugDataId,"DrugDataId")=drugDataId
			   				s Array("Drug",drugDataId,"DrugId")=drugId
			   				s Array("Drug",drugDataId,"DrugDesc")=drugDataObj.BPSADBPCADDr.BPCADDesc
			   				s Array("Drug",drugDataId,"DrugCode")=drugDataObj.BPSADBPCADDr.BPCADCode
			   				m Array("Drug",drugDataId,"Options")=DrugData
		       			}
					}
				}
			}
			&sql(CLOSE SDrugCursorhnsy)
		}
	}
	s res=..ToJson(.Array)
    w res.Read()
    q res.Read()
GetArrangeSchemeId()
    &sql(SELECT top 1 ID into:dataId FROM DHC_BP_ArrangeScheme 
    WHERE BPAS_BPCBPMode_Dr=:bpModeDr AND BPAS_BPScheme_Dr=:schemeId)
    q dataId
}

ClassMethod GetDrugDataId(arrangeId)
{
	&sql(SELECT BPAAD_RowId into:rowId FROM DHC_BP_ArrangeAnticoagulantDrug 
	where BPAAD_BPArrange_Dr=:arrangeId)
	q rowId
}

ClassMethod Save(paramStr)
{
	// w ##class(DHCBP.Anticoagulant).Save(paramStr)
	s d=..ToJsonObj(paramStr)
	s arrangeId=d.GetAt("ArrangeId")
	s antModeId=d.GetAt("AntModeId")
	s drugs=d.GetAt("Drug")
	s count=drugs.Count()
	d ..DeleteDrugData(arrangeId)
	For i=1:1:count  {
		s drug=drugs.GetAt(i)
		s drugDesc=drug.GetAt("DrugDesc")
		s drugId=drug.GetAt("DrugId")
		s drugDataId=drug.GetAt("DrugDataId")
		s options=drug.GetAt("Options")
		/*
		if (drugDataId){
			s drugObj=##class(User.DHCBPArrangeAnticoagulantDrug).%OpenId(drugDataId)
		}
		else{
			s drugObj=##class(User.DHCBPArrangeAnticoagulantDrug).%New()
		}*/
		// 每次保存: 删除后修改
		
		s drugObj=##class(User.DHCBPArrangeAnticoagulantDrug).%New()
		s drugObj.BPAADIfAbandon="N"
		s drugObj.BPAADBPArrangeDr=##class(User.DHCBPArrange).%OpenId(arrangeId)
		s drugObj.BPAADBPCADDr=##class(User.DHCBPCAnticoagulantDrug).%OpenId(drugId)
		For j=1:1:options.Count() {
			s option=options.GetAt(j)
			s code=option.GetAt("Code")
			s value=option.GetAt("Value")
			if (code="Duration") s drugObj.BPAADDuration=value
			if (code="Dose") s drugObj.BPAADDose=value
			if (code="Amount") s drugObj.BPAADAmount=value
			if (code="FirstAmount") s drugObj.BPAADFirstAmount=value
			if (code="Frequency") s drugObj.BPAADFrequency=value
			if (code="IntervalMinute") s drugObj.BPAADIntervalMinute=value
			if (code="Note") s drugObj.BPAADNote=value
		}
		d drugObj.%Save()
	}
	q "1"
}

ClassMethod DeleteDrugData(arrangeId)
{
	&sql(update DHC_BP_ArrangeAnticoagulantDrug set BPAAD_IfAbandon='Y' 
	WHERE BPAAD_BPArrange_Dr=:arrangeId)
	q 0
}

}
