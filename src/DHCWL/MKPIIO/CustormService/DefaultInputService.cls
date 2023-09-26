Class DHCWL.MKPIIO.CustormService.DefaultInputService Extends DHCWL.MKPIIO.util.InputInterface
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
	if (classFullName="DHCWL.MKPI.MKPI") {
		if ($d(^TEMPDHCWL("REALINPUT",$j,primaryFieldValue))){
			q "11"
		}else{
			q "00"
		}
	}elseif (classFullName="DHCWL.MKPI.MKPIDimensions"){
		if (primaryFieldValue'=""){
			
			/*
			s kpiCode=$p(primaryFieldValue,"||")
			s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
			q:kpiId="" "01"
			if ('$d(^TEMPDHCWL("REALINPUT",$j,kpiCode))) q "10"
			q "11"
			s kpiDimCode=$p(primaryFieldValue,"||",2)
			s kpiDimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(primaryFieldValue,"DHCWL.MKPI.MKPIDimensions")
			if (kpiDimId'=""){
				;s kpiId=$lg()
			}
			*/
			//modify by wz.2014-10-15。
			s kpiCode=$p(primaryFieldValue,"||")
			if ('$d(^TEMPDHCWL("REALINPUT",$j,kpiCode))) q "00"
			s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
			q:kpiId="" "10"
			q "10"
			


		}
		q "00"
	}elseif (classFullName="DHCWL.MKPI.CreatDataTask"){
		if (primaryFieldValue'=""){
			/*
			s kpiCode=$p(primaryFieldValue,"||")
			s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
			q:kpiId="" "01"
			if ('$d(^TEMPDHCWL("REALINPUT",$j,kpiCode))) q "10"
			q "01"
			*/
			//modify by wz.2014-10-15
			s kpiCode=$p(primaryFieldValue,"||")
			if ('$d(^TEMPDHCWL("REALINPUT",$j,kpiCode))) q "00"
			s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
			q:kpiId="" "10"

			q "11"
			
		}
		q "00"
	}elseif (classFullName="DHCWL.MKPI.MKPIDimType"){
		s okFlag=0,result="00"
		q result
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
						s okFlag=1,result="10"
						q
					}
				}
			}
		}
		q result
	}elseif (classFullName="DHCWL.MKPI.DimProperty"){
		s okFlag=0,result="00"
		q result
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
							s okFlag=1,result="10"
							q
						}
						
					}
				}
			}
		}
		q result
	}elseif (classFullName="DHCWL.MKPI.ConfigTaskGroup") {
		if ($d(^TEMPDHCWL("REALINPUT",$j,primaryFieldValue))){
			q "01"
		}else{
			q "00"
		}
	}elseif (classFullName="DHCWL.MKPI.TaskGroupDetail") {
		if (primaryFieldValue'=""){
			s groupCode=$p(primaryFieldValue,"||",1)
			s kpiCode=$p(primaryFieldValue,"||",2)
			if ('$d(^TEMPDHCWL("REALINPUT",$j,groupCode))) q "00"
			s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
			q:kpiId="" "00"
			s groupId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(groupCode,"DHCWL.MKPI.ConfigTaskGroup")
			q:groupId="" "00"

			q "01"
			
		}
		q "00"
	}elseif (classFullName="DHCWL.MeasureDimrole.Measure"){
		s okFlag=0,result="00"
		q result
	}elseif (classFullName="DHCWL.MKPI.MKPIMeasure"){
		if (primaryFieldValue'=""){
			s kpiCode=$p(primaryFieldValue,"||")
			if ('$d(^TEMPDHCWL("REALINPUT",$j,kpiCode))) q "00"
			s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
			q:kpiId="" "10"
			q "10"
			


		}
		q "00"
	}
	q "11"
}

}
