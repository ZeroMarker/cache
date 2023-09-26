Class DHCWL.MKPIIO.CustormService.DimDefaultInputService Extends DHCWL.MKPIIO.util.InputInterface
{

Method JudgeInput(classFullName As %String, primaryFieldValue As %String, primaryField As %String = "") As %String
{
	if (classFullName="DHCWL.MKPI.MKPIDimType"){
		s okFlag=0,result="00"
		q "01"
		if (primaryFieldValue'=""){
			if ($d(^TEMPDHCWLKPIDATA("XMLNodeSession",$j,"DHCWL.MKPI.MKPIDimensions",kpiDimPriValue,"MKPIDimDimDr"))&&(^TEMPDHCWLKPIDATA("XMLNodeSession",$j,"DHCWL.MKPI.MKPIDimensions",kpiDimPriValue,"MKPIDimDimDr")=primaryFieldValue)){
				s okFlag=1,result="01"
				q
			}
		}
		q result
	}elseif (classFullName="DHCWL.MKPI.DimProperty"){
		s okFlag=0,result="00"
		q "01"
		if (primaryFieldValue'=""){
			if (($d(^TEMPDHCWLKPIDATA("XMLNodeSession",$j,"DHCWL.MKPI.DimProperty",primaryFieldValue)))){
				s okFlag=1,result="01"
				q
			}
		}
		q result
	}
	q "11"
}

}
