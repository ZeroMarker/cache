Class DHCWL.SysService.SetFilterService Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod MetrixToTreePanelJson(ByRef metrix, ByRef json)
{
	n (metrix,json)
	s num=$o(metrix("")),value=""
	do{
		s json(num)=""
		s tab=$o(metrix(num,""))
		do{
			s value=metrix(num,tab)
			i ""=json(num) s json(num)=tab_":"_value
			e  s json(num)=json(num)_","_tab_":"_value
			s tab=$o(metrix(num,tab))
		}while(""'=tab)
		s json(num)="{"_json(num)_"}"
		s num=$o(metrix(num))
	}while(""'=num)
	q
}

/// 	s kpiRule="RegLocOpNums:PatLoc.Loc,RegLocStOpNums:Loc.Loc,RegLocSexAge:Loc.Loc,MRLocCyrs:Loc.Loc,MRLocSjzcr:Loc,GetLocFee"
/// 	d ##class(DHCWL.SysService.SetFilterService).InitKpiNode(kpiRule,.json)
ClassMethod InitKpiNode(kpiRule, ByRef json)
{
	n (kpiRule, json)
	q:(""=kpiRule)
	k json
	;d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPosition(kpiRule, .arr)
	s kpiLen=$l(kpiRule,",")
	for i=1:1:kpiLen{
		s kpis=$p(kpiRule,",",i)
		continue:kpis=""
		s kpi=$p(kpis,":",1)
		continue:kpi=""
		s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpi,"DHCWL.MKPI.MKPI")
		s arr("ID",kpiId)=""
	}
	q:(0=$d(arr("ID")))
	
	s num=1
	s kpiId=""
	do{
		s kpiId=$o(arr("ID",kpiId))
		q:(""=kpiId)
		continue:(0=$d(^DHCWL.MKPI.MKPID(kpiId)))
		s kpiCode=##class(DHCWL.Interface.MkpiData).ToKpiCode(kpiId,",")
		s treeNod(num,"text")="'"_kpiCode_"'"
		s treeNod(num,"id")="'kpi-"_kpiId_"'"
		s treeNod(num,"cls")="'folder'"
		s treeNod(num,"leaf")="false"
		s num=num+1
	}while(""'=kpiId)
	i $d(treeNod) d ##class(DHCWL.SysService.SetFilterService).MetrixToTreePanelJson(.treeNod,.json)
	q
}

/// 		s kpiRule="RegLocOpNums:PatLoc.Loc,RegLocStOpNums:Loc.Loc,RegLocSexAge:Loc.Loc,MRLocCyrs:Loc.Loc,MRLocSjzcr:Loc,GetLocFee"
/// 	d ##class(DHCWL.SysService.SetFilterService).InitDimNode(kpiRule,"GetLocFee",.json)
ClassMethod InitDimNode(kpiRule = "", kpiCode, ByRef json)
{
	n (kpiRule, kpiCode,json)
	q:(""=kpiCode)
	k json
	d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPosition(kpiRule, .arr)
	q:(""'=kpiRule)&&(0=$d(arr("ID")))
	
	s kpiCode=$zcvt(kpiCode,"U")
	s num=1
	s kpiId=$o(^DHCWL.MKPI.MKPII("MKPICode",kpiCode,""))
	s kpiDimId="", mKpiDimCode=""
	do{
		if (""'=kpiRule) {
			s kpiDimId=$o(arr("ID",kpiId,kpiDimId))
		}else{
			s mKpiDimCode=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,mKpiDimCode))
			q:(""=mKpiDimCode)
			s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,mKpiDimCode,""))
		}
		q:(""=kpiDimId)
		continue:(0=$d(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId)))
		s kpiDimCode=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),2)
		s kpiDimDesc=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),4)
		s kpiDimInfor=kpiDimCode_"-"_kpiDimDesc
		s treeNod(num,"text")="'"_kpiDimInfor_"'"
		s treeNod(num,"id")="'kpiDim-"_kpiId_"."_kpiDimId_"'"
		s treeNod(num,"cls")="'folder'"
		s treeNod(num,"leaf")="false"
		s num=num+1
	}while(""'=kpiDimId)
	
	
	//add by wz.2015-1-27.增加区间维度
	s kpiSecFlag=$lg(^DHCWL.MKPI.MKPID(kpiId),11)
	s secData=$g(^DHCWL.MKPI.SectionD(kpiSecFlag))
	i $g(secData)'="" {
		s secCode=$lg(secData,2)
		s secDesc=$lg(secData,4)
		s secInfor=secCode_"-"_secDesc
		//s secDesc=$lg(secData,3)
		s treeNod(num,"text")="'"_secInfor_"'"
		s treeNod(num,"id")="'secDim-"_kpiId_"."_kpiSecFlag_"'"
		s treeNod(num,"cls")="'folder'"
		s treeNod(num,"leaf")="false"
		s num=num+1
	}
			
	i $d(treeNod) d ##class(DHCWL.SysService.SetFilterService).MetrixToTreePanelJson(.treeNod,.json)
	q
}

ClassMethod DimInitDimNode(dimRule = "", ByRef json)
{
	n (dimRule, json)
	q:(""=dimRule)
	k json
	s dim=$p(dimRule,":",1)
	q:dim=""
	s dimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dim,"DHCWL.MKPI.MKPIDimType")
	s arr("ID",dimId)=""
	q:(0=$d(arr("ID")))
	
	s num=1
	s dimId=""
	do{
		s dimId=$o(arr("ID",dimId))
		q:(""=dimId)
		continue:(0=$d(^DHCWL.MKPI.MKPIDimTypeD(dimId)))
		s dimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimId),2)
		s treeNod(num,"text")="'"_dimCode_"'"
		s treeNod(num,"id")="'dim-"_dimId_"'"
		s treeNod(num,"cls")="'folder'"
		s treeNod(num,"leaf")="false"
		s num=num+1
	}while(""'=dimId)
	i $d(treeNod) d ##class(DHCWL.SysService.SetFilterService).MetrixToTreePanelJson(.treeNod,.json)
	q
}

ClassMethod DimInitDimProNode(dimRule = "", dimCode, ByRef json)
{
	n (dimRule, dimCode,json)
	q:(""=dimCode)
	k json
	
	s num=1
	s dimID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimCode,"DHCWL.MKPI.MKPIDimType")
	s upDimProCode=""
	for{
		s upDimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimID,upDimProCode))
		q:upDimProCode=""
		s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimID,upDimProCode,""))
		s dimProCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),3)
		s dimProDesc=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),4)
		s dimProInfor=dimProCode_"-"_dimProDesc
		s treeNod(num,"text")="'"_dimProInfor_"'"
		s treeNod(num,"id")="'dimPro-"_dimID_"."_dimProID_"'"
		s treeNod(num,"cls")="'folder'"
		s treeNod(num,"leaf")="true"
		s num=num+1
	}
	i $d(treeNod) d ##class(DHCWL.SysService.SetFilterService).MetrixToTreePanelJson(.treeNod,.json)
	q
}

/// 		s kpiRule="RegLocOpNums:PatLoc.Loc,RegLocStOpNums:Loc.Loc,RegLocSexAge:Loc.Loc,MRLocCyrs:Loc.Loc,MRLocSjzcr:Loc,GetLocFee"
/// 	d ##class(DHCWL.SysService.SetFilterService).InitDimProNode(kpiRule,"GetLocFee","CTLOC",.json)
ClassMethod InitDimProNode(kpiRule = "", kpiCode, kpiDimCode, ByRef json)
{
	n (kpiRule, kpiCode, kpiDimCode, json)
	q:(""=kpiCode)||(""=kpiDimCode)
	k json
	d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPosition(kpiRule, .arr)
	q:(""'=kpiRule)&&(0=$d(arr("ID")))
	
	s kpiDimCode=$p(kpiDimCode,"-",1)
	s kpiCode=$zcvt(kpiCode,"U"), kpiDimCode=$zcvt(kpiDimCode,"U")
	s num=1
	s kpiId=$o(^DHCWL.MKPI.MKPII("MKPICode",kpiCode,""))
	s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,kpiDimCode,""))
	s dimProId="", dimTypeId=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),5), mDimProCode=""
	do{
		if (""'=kpiRule) {
			s dimProId=$o(arr("ID",kpiId,kpiDimId,dimProId))
		}else{
			s mDimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimTypeId,mDimProCode))
			q:(""=mDimProCode)
			s dimProId=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimTypeId,mDimProCode,""))
		}
		q:(""=dimProId)
		continue:(0=$d(^DHCWL.MKPI.DimPropertyD(dimProId)))
		s dimProCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProId),3)
		s dimProDesc=$lg(^DHCWL.MKPI.DimPropertyD(dimProId),4)
		s dimProInfor=dimProCode_"-"_dimProDesc
		s treeNod(num,"text")="'"_dimProInfor_"'"
		s treeNod(num,"id")="'dimPro-"_kpiId_"."_kpiDimId_"."_dimProId_"'"
		s treeNod(num,"cls")="'file'"
		s treeNod(num,"leaf")="true"
		s num=num+1
	}while(""'=dimProId)
	i $d(treeNod) d ##class(DHCWL.SysService.SetFilterService).MetrixToTreePanelJson(.treeNod,.json)
	q
}

/// 		s kpiRule="RegLocOpNums:PatLoc.Loc,RegLocStOpNums:Loc.Loc,RegLocSexAge:Loc.Loc,MRLocCyrs:Loc.Loc,MRLocSjzcr:Loc,GetLocFee"
/// 	d ##class(DHCWL.SysService.SetFilterService)InitSecDimProNode(kpiRule,"GetLocFee","CTLOC",.json)
ClassMethod InitSecDimProNode(kpiRule = "", kpiCode, secDimCode, ByRef json)
{
	n (kpiRule, kpiCode, secDimCode, json)
	;q:(""=kpiCode)||(""=secDimCode)
	q:(""=kpiCode)
	k json
	d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPosition(kpiRule, .arr)
	q:(""'=kpiRule)&&(0=$d(arr("ID")))
	
	s kpiCode=$zcvt(kpiCode,"U")
	s num=1
	s kpiId=$o(^DHCWL.MKPI.MKPII("MKPICode",kpiCode,""))
	s kpiSecFlag=$lg(^DHCWL.MKPI.MKPID(kpiId),11)
	//上面也可以通过secDimCode来获得区间维度的ID。
	
	//维度属性
	s secProCode=""
	f {
		s secProCode=$o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",kpiSecFlag,secProCode))
		q:$g(secProCode)=""
		s secProID=""

		s secProID=$o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",kpiSecFlag,secProCode,secProID))
		q:$g(secProID)=""
		s proCode=$lg(^DHCWL.MKPI.SectionPropertyD(secProID),2)
		s proDesc=$lg(^DHCWL.MKPI.SectionPropertyD(secProID),4)
		s proInfor=proCode_"-"_proDesc
		
		s treeNod(num,"text")="'"_proInfor_"'"
		s treeNod(num,"id")="'secPro-"_kpiId_"."_kpiSecFlag_"."_secProID_"'"
		s treeNod(num,"cls")="'file'"
		s treeNod(num,"leaf")="true"
		s num=num+1
	}
		

	i $d(treeNod) d ##class(DHCWL.SysService.SetFilterService).MetrixToTreePanelJson(.treeNod,.json)
	q
}

/// 	s json=##class(DHCWL.SysService.SetFilterService).InitLogicalOperators()
ClassMethod InitLogicalOperators() As DHCWL.util.Json
{
	k logicalOper
	s logicalOper(1,"code")="&&", logicalOper(1,"desc")="与运算，cache中""&&""和""||""具有相同优先级"
	s logicalOper(2,"code")="||", logicalOper(2,"desc")="或运算，cache中""&&""和""||""具有相同优先级"
	s logicalOper(3,"code")="!", logicalOper(3,"desc")="非运算，一元运算符，其优先级高于""&&""和""||"""
	s logicalOper(4,"code")="[", logicalOper(4,"desc")="左括弧，指标系统中用""[""和""]""来改变运算优先级"
	s logicalOper(5,"code")="]", logicalOper(5,"desc")="右括弧，指标系统中用""[""和""]""来改变运算优先级"
	//add by wz.2014-4-7
	//s logicalOper(6,"code")="\\", logicalOper(6,"desc")="斜杠，做转义字符用"
	q:($d(logicalOper)) ##class(DHCWL.MKPILogin.LoginService).MetrixToJson(.logicalOper)
	q ""
}

}
