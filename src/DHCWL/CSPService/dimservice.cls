Class DHCWL.CSPService.dimservice Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod GetKpiDimAndPro(inputRule As %String, treeDeep = "") As %Integer
{
	n (inputRule,treeDeep)
	

	s kpiLen=$l(inputRule,",")
	k ^TEMPDHCWL($j)
	f i=1:1:kpiLen d
	.s aKpiRule=$p(inputRule,",",i)
	.s kpiCode=$p(aKpiRule,":",1)
	.s ^TEMPDHCWL($j,"inputRule","normalDim",kpiCode)=1
	.s dimAndProRules=$p(aKpiRule,":",2)
	.q:$g(dimAndProRules)=""
	.s dAndPCnt=$l(dimAndProRules,"^")
	.f j=1:1:dAndPCnt d
	..s aDimAndPro=$p(dimAndProRules,"^",j)
	..s dimCode=$p(aDimAndPro,".",1)
	..i ($g(dimCode)'="") d
	...i ($f(dimCode,"$")'=2) d 	//常规维度及属性 
	....s ^TEMPDHCWL($j,"inputRule","normalDim",kpiCode,dimCode)=1
	....s proCode=$p(aDimAndPro,".",2)
   	....i $g(proCode)'="" s ^TEMPDHCWL($j,"inputRule","normalDim",kpiCode,dimCode,proCode)=1	
   	...e  d							//区间维度及属性
	....s ^TEMPDHCWL($j,"inputRule","secDim",kpiCode,dimCode)=1
	....s proCode=$p(aDimAndPro,".",2)
   	....i $g(proCode)'="" s ^TEMPDHCWL($j,"inputRule","secDim",kpiCode,dimCode,proCode)=1	
   	
   	
   	   	
   	s i=1
   	s NOBase=1
   	s loopCnt=$l(inputRule,",")
   	w "["
   	f {	
   		q:i>loopCnt
   		
   		s aKpiRule=$p(inputRule,",",i)
		s iKpiCode=$p(aKpiRule,":",1)
		
		s jsonData=""
		s jsonDatas=""

	
		//指标
		//s NOBase=1
		s kpiID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(iKpiCode,"DHCWL.MKPI.MKPI")
		s kpiParentNO="root"
		s kpiNO=iKpiCode_NOBase
		s NOBase=NOBase+1
		s kpiText=$lg(^DHCWL.MKPI.MKPID(kpiID),5)
		s kpiSecFlag=$lg(^DHCWL.MKPI.MKPID(kpiID),11)

		s jsonData="{""code"":"""_iKpiCode_""""_",""className"":"""_"DHCWL.MKPI.MKPI"_""""
		s jsonData=jsonData_",""parentNO"":"""_kpiParentNO_""""_",""NO"":"""_kpiNO_""""	
		s jsonData=jsonData_",""text"":"""_kpiText_"""}"

		s jsonDatas=jsonData
	
		//维度
		s MKPIDimOrder=""
		f {
			s MKPIDimOrder=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpiID,MKPIDimOrder))
			q:$g(MKPIDimOrder)=""
			//f {
				s kpiDimID=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpiID,MKPIDimOrder,""))
				q:kpiDimID=""

				s kpiDimData=$g(^DHCWL.MKPI.MKPIDimensionsD(kpiDimID))
				q:kpiDimData=""
				s MKPIDimCode=$lg(kpiDimData,2)
				s MKPIDimDes=$lg(kpiDimData,4)
				s MKPIDimDimDr=$lg(kpiDimData,5)
				continue:MKPIDimDimDr=""
				s MKPIDimNO=iKpiCode_NOBase
				s NOBase=NOBase+1
					
				s MKPIDimDes=##class(DHCWL.util.StringUtil).Trim(MKPIDimDes)
				if ((MKPIDimDes="") || (MKPIDimDes=$c(0))) s MKPIDimDes="!!!未设置指标维度描述信息"
				s checked="false"
				i $d(^TEMPDHCWL($j,"inputRule","normalDim",iKpiCode,MKPIDimCode)) s checked="true"
				s jsonData="{""code"":"""_MKPIDimCode_""""_",""className"":"""_"DHCWL.MKPI.MKPIDimensions"_""""
				s jsonData=jsonData_",""parentNO"":"""_kpiNO_""""_",""NO"":"""_MKPIDimNO_""""_",""checked"":"""_checked_""""	
				s jsonData=jsonData_",""text"":"""_MKPIDimDes_"""}"
				s jsonDatas=jsonDatas_","
				s jsonDatas=jsonDatas_jsonData
		
				//维度属性
				continue:((treeDeep'="")&&(treeDeep'="dimpro"))
				s dimProCode=""
				f {
					s dimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",MKPIDimDimDr,dimProCode))
					q:$g(dimProCode)=""
					s dimProID=""
					f {
						s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",MKPIDimDimDr,dimProCode,dimProID))
						q:$g(dimProID)=""
						s proCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),3)
						s proDesc=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),5)
					
				
						s proNO=iKpiCode_NOBase
						s NOBase=NOBase+1
						s checked="false"
						i $d(^TEMPDHCWL($j,"inputRule","normalDim",iKpiCode,MKPIDimCode,proCode)) s checked="true"
						s jsonData="{""code"":"""_proCode_""""_",""className"":"""_"DHCWL.MKPI.DimProperty"_""""
						s jsonData=jsonData_",""parentNO"":"""_MKPIDimNO_""""_",""NO"":"""_proNO_""""_",""checked"":"""_checked_""""	
						s jsonData=jsonData_",""text"":"""_proDesc_"""}"
						s jsonDatas=jsonDatas_","
						s jsonDatas=jsonDatas_jsonData
					} 
				}
			//}
		}

		//d Rs.Close()

		
		//区间维度
		s secData=$g(^DHCWL.MKPI.SectionD(kpiSecFlag))
		i $g(secData)="" {
			s i=i+1
			continue
		}
		s secCode=$lg(secData,2)
		s secDesc=$lg(secData,3)
		
		
		s secDimNO=iKpiCode_NOBase
		s NOBase=NOBase+1
		s checked="false"
		i $d(^TEMPDHCWL($j,"inputRule","secDim",iKpiCode,"$"_secCode)) s checked="true"
		s jsonData="{""code"":"""_secCode_""""_",""className"":"""_"DHCWL.MKPI.Section"_""""
		s jsonData=jsonData_",""parentNO"":"""_kpiNO_""""_",""NO"":"""_secDimNO_""""_",""checked"":"""_checked_""""	
		s jsonData=jsonData_",""text"":"""_secDesc_"""}"
		s jsonDatas=jsonDatas_","
		s jsonDatas=jsonDatas_jsonData
	
		//维度属性
		if ((treeDeep="")||(treeDeep="dimpro")) {
			s secProCode=""
			f {
				s secProCode=$o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",kpiSecFlag,secProCode))
				q:$g(secProCode)=""
				s secProID=""
				f {
					s secProID=$o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",kpiSecFlag,secProCode,secProID))
					q:$g(secProID)=""
					s proCode=$lg(^DHCWL.MKPI.SectionPropertyD(secProID),2)
					s proDesc=$lg(^DHCWL.MKPI.SectionPropertyD(secProID),4)
					
					s proNO=iKpiCode_NOBase
					s NOBase=NOBase+1
					s checked="false"
					i $d(^TEMPDHCWL($j,"inputRule","secDim",iKpiCode,"$"_secCode,proCode)) s checked="true"
					s jsonData="{""code"":"""_proCode_""""_",""className"":"""_"DHCWL.MKPI.SectionProperty"_""""
					s jsonData=jsonData_",""parentNO"":"""_secDimNO_""""_",""NO"":"""_proNO_""""_",""checked"":"""_checked_""""	
					s jsonData=jsonData_",""text"":"""_proDesc_"""}"
					s jsonDatas=jsonDatas_","
					s jsonDatas=jsonDatas_jsonData
				} 
			}
		}
		
		w $g(jsonDatas)

	   	s i=i+1
	   	i i<=loopCnt w ","
   	}
   	w "]"
   	k ^TEMPDHCWL($j)
	q 1
	
ErrorDel
	k ^TEMPDHCWL($j)
	q 0
}

//s kpiId=##class(DHCWL.CSPService.dimservice).GetDimAndPro("CTLOC:LocDesc^LocHospid")

ClassMethod GetDimAndPro(inputRule As %String, treeDeep = "") As %Integer
{
	n (inputRule,treeDeep)
	
	k ^TEMPDHCWL($j)
	s dimCode=$p(inputRule,":",1)
	s ^TEMPDHCWL($j,"inputRule","normalDim",dimCode)=1
	s proRules=$p(inputRule,":",2)
	if $g(proRules)'="" d
	.s pCnt=$l(proRules,"^")
	.f j=1:1:pCnt d
	..s proCode=$p(proRules,"^",j)
	..i ($g(proCode)'="") d
	...s ^TEMPDHCWL($j,"inputRule","normalDim",dimCode,proCode)=1
	   	
   	s i=1
   	s NOBase=1
   	s loopCnt=$l(inputRule,",")
   	w "["
   		
	s iDimCode=$p(inputRule,":",1)
		
	s jsonData=""
	s jsonDatas=""

	//维度
	s dimID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(iDimCode,"DHCWL.MKPI.MKPIDimType")
	s dimParentNO="root"
	s dimNO=iDimCode_NOBase
	s NOBase=NOBase+1
	s dimText=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),3)
	//s kpiSecFlag=$lg(^DHCWL.MKPI.MKPID(kpiID),11)

	s jsonData="{""code"":"""_iDimCode_""""_",""className"":"""_"DHCWL.MKPI.MKPIDimType"_""""
	s jsonData=jsonData_",""parentNO"":"""_dimParentNO_""""_",""NO"":"""_dimNO_""""	
	s jsonData=jsonData_",""text"":"""_dimText_"""}"

	s jsonDatas=jsonData
	
	//维度属性
	s upDimProCode=""
	f {
		s upDimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimID,upDimProCode))
		q:$g(upDimProCode)=""
		s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimID,upDimProCode,""))
		q:dimProID=""

		s dimProData=$g(^DHCWL.MKPI.DimPropertyD(dimProID))
		q:dimProData=""
		s dimProCode=$lg(dimProData,3)
		s dimProDes=$lg(dimProData,5)
		s dimProNO=iDimCode_NOBase
		s NOBase=NOBase+1
					
		s dimProDes=##class(DHCWL.util.StringUtil).Trim(dimProDes)
		if ((dimProDes="") || (dimProDes=$c(0))) s dimProDes="!!!未设置指标维度描述信息"
		s checked="false"
		i $d(^TEMPDHCWL($j,"inputRule","normalDim",iDimCode,dimProCode)) s checked="true"
		s jsonData="{""code"":"""_dimProCode_""""_",""className"":"""_"DHCWL_MKPI.DHCWLDimProperty"_""""
		s jsonData=jsonData_",""parentNO"":"""_dimNO_""""_",""NO"":"""_dimProNO_""""_",""checked"":"""_checked_""""	
		s jsonData=jsonData_",""text"":"""_dimProDes_"""}"
		s jsonDatas=jsonDatas_","
		s jsonDatas=jsonDatas_jsonData
	}
	w $g(jsonDatas)

   	w "]"
   	k ^TEMPDHCWL($j)
	q 1
	
ErrorDel1
	k ^TEMPDHCWL($j)
	q 0
}

}
