Class DHCWL.ModuleManageServ.ModuleInputServ Extends DHCWL.MKPIIO.util.InputInterface
{

//s ^TEMPDHCWL("REALINPUT",$j,"MZDocGhf")="MZDocGhf"

//s service=##class(DHCWL.MKPIIO.CustormService.DefaultInputService).%New()

//w service.JudgeInput("DHCWL.MKPI.MKPI","MZDocGhf")

//w service.JudgeInput("DHCWL.MKPI.MKPIDimensions","MZDocGhf||RegDoc")

//w service.JudgeInput("DHCWL.MKPI.CreatDataTask","MZDocGhf||D")

//w service.JudgeInput("DHCWL.MKPI.MKPIDimType","DimRegType")

//w service.JudgeInput("DHCWL.MKPI.DimProperty","DimRegType||Des")

Method JudgeInput(classFullName As %String, primaryFieldValue As %String, primaryField As %String = "") As %String
{
	
	
	
	if (classFullName="DHCWL.MKPI.MMgrModuleCfg") {
		if ($d(^TEMPDHCWL("REALINPUT",$j,primaryFieldValue))){
			q "11"
		}else{
			q "00"
		}
	}elseif (classFullName="DHCWL.MKPI.MMgrRptCfg") {
		if ($d(^TEMPDHCWL("REALINPUT",$j,primaryFieldValue))){
			q "11"
		}else{
			q "00"
		}
	}elseif (classFullName="DHCWL.MKPI.MMgrDataSetCfg") {
		if ($d(^TEMPDHCWL("REALINPUT",$j,primaryFieldValue))){
			q "11"
		}else{
			q "00"
		}
	}elseif (classFullName="DHCWL.MKPI.MMgrKPICfg") {
		if ($d(^TEMPDHCWL("REALINPUT",$j,primaryFieldValue))){
			q "11"
		}else{
			q "00"
		}
	}elseif (classFullName="DHCWL.MKPI.MKPI") {
		if ($d(^TEMPDHCWL("REALINPUT",$j,primaryFieldValue))){
			q "11"
		}else{
			q "00"
		}
	}elseif (classFullName="DHCWL.MKPI.MKPIDimensions"){
		if (primaryFieldValue'=""){
			s kpiCode=$p(primaryFieldValue,"||")
			s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
			if ('$d(^TEMPDHCWL("REALINPUT",$j,kpiCode))) q "00"
			q:kpiId="" "00"
			q "11"
			s kpiDimCode=$p(primaryFieldValue,"||",2)
			s kpiDimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(primaryFieldValue,"DHCWL.MKPI.MKPIDimensions")
			if (kpiDimId'=""){
				;s kpiId=$lg()
			}
		}
		q "00"
	}elseif (classFullName="DHCWL.MKPI.CreatDataTask"){
		if (primaryFieldValue'=""){
			s kpiCode=$p(primaryFieldValue,"||")
			s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
			q:kpiId="" "00"
			if ('$d(^TEMPDHCWL("REALINPUT",$j,kpiCode))) q "10"
			q "01"
		}
		q "00"
	}elseif (classFullName="DHCWL.MKPI.MKPIDimType"){
		s okFlag=0,result="00"
		if (primaryFieldValue'=""){
			s kpiCode=""
			f {
				s kpiCode=$o(^TEMPDHCWL("REALINPUT",$j,kpiCode))
				q:kpiCode=""
				q:okFlag=1
				s kpiDimPriValue=""
				f {
					s kpiDimPriValue=$o(^TEMPDHCWLKPIDATA("XMLNodeSession",$j,"DHCWL.MKPI.MKPIDimensions",kpiDimPriValue))
					q:kpiDimPriValue=""
					continue:($p(kpiDimPriValue,"||")'= kpiCode)
					if ($d(^TEMPDHCWLKPIDATA("XMLNodeSession",$j,"DHCWL.MKPI.MKPIDimensions",kpiDimPriValue,"MKPIDimDimDr"))&&(^TEMPDHCWLKPIDATA("XMLNodeSession",$j,"DHCWL.MKPI.MKPIDimensions",kpiDimPriValue,"MKPIDimDimDr")=primaryFieldValue)){
						s okFlag=1,result="11"
						q
					}
				}
			}
		}
		q result
	}elseif (classFullName="DHCWL.MKPI.DimProperty"){
		s okFlag=0,result="00"
		if (primaryFieldValue'=""){
			s kpiCode=""
			f {
				s kpiCode=$o(^TEMPDHCWL("REALINPUT",$j,kpiCode))
				q:kpiCode=""
				q:okFlag=1
				s kpiDimPriValue=""
				f {
					s kpiDimPriValue=$o(^TEMPDHCWLKPIDATA("XMLNodeSession",$j,"DHCWL.MKPI.MKPIDimensions",kpiDimPriValue))
					q:kpiDimPriValue=""
					continue:($p(kpiDimPriValue,"||")'= kpiCode)
					if ($d(^TEMPDHCWLKPIDATA("XMLNodeSession",$j,"DHCWL.MKPI.MKPIDimensions",kpiDimPriValue,"MKPIDimDimDr"))){
						s baseDimCode=^TEMPDHCWLKPIDATA("XMLNodeSession",$j,"DHCWL.MKPI.MKPIDimensions",kpiDimPriValue,"MKPIDimDimDr")
						continue:(baseDimCode'=$p(primaryFieldValue,"||"))
						if (($d(^TEMPDHCWLKPIDATA("XMLNodeSession",$j,"DHCWL.MKPI.DimProperty",primaryFieldValue)))){
							s okFlag=1,result="11"
							q
						}
						
					}
				}
			}
		}
		q result
	}
	q "11"
}

}
