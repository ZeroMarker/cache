Class DHCWL.MKPIService.KpiModuleData Extends %Persistent [ Not ProcedureBlock ]
{

/*
	*获取模块中包含的指标
	*creator：汪凯
	*s sign=##class(DHCWL.MKPIService.KpiModuleData).GetKpiModuleData("2314")
	*/

/*ClassMethod GetKpiModuleData(kpi)
{
	k saveKpiList
	s DatasetId=""
	s DatasetRule=""
	for{
		s DatasetId=$o(^DHCWL.MKPI.MMgrDataSetCfgD(DatasetId))
		q:DatasetId=""
		s DatasetRule=$lg(^DHCWL.MKPI.MMgrDataSetCfgD(DatasetId),5,"")
		continue:DatasetRule=""
		s RuleLength=$length(DatasetRule,",")
		for i=1:1:RuleLength{
			s kpiRule=$p(DatasetRule,",",i)
			s DatasetKpiCode=$p(kpiRule,":",1)
			continue:DatasetKpiCode=""
			s saveKpiList(DatasetKpiCode)=""
		}
	}
	s kpiCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(kpi,"DHCWL.MKPI.MKPI")
	i ""=kpiCode {
		q 0
	}
	if $d(saveKpiList(kpiCode)){
		q 1
	}
	q 0
}*/

/*
*返回模块或报表中的指标code
*creator:wk
*createdate：2015-10-26
*/
ClassMethod GetModuleRptKpiInfor(treeNodes, kpimoduleRptSign, ByRef saveKpiList)
{
	if (kpimoduleRptSign="module"){  //用户操作的是模块
		s treeNum=$length(treeNodes,",")
		for i=1:1:treeNum{
			s treeNode=$p(treeNodes,",",i)
			q:treeNode=""
			s reportCode=""
			for{
				s reportCode=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeNode,reportCode))
				q:reportCode=""
				s datasetCode=""
				for{
					s datasetCode=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeNode,reportCode,datasetCode))
					q:datasetCode=""
					s datasetId=""
					for{
						s datasetId=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeNode,reportCode,datasetCode,datasetId))
						q:datasetId=""
						s datasetRule=$lg(^DHCWL.MKPI.MMgrDataSetCfgD(datasetId),5,"")
						continue:datasetRule=""
						s RuleLength=$length(datasetRule,",")
						for j=1:1:RuleLength{
							s kpiRule=$p(datasetRule,",",j)
							s datasetKpiCode=$p(kpiRule,":",1)
							continue:datasetKpiCode=""
							if ($d(saveKpiList(datasetKpiCode))=0){
							s saveKpiList(datasetKpiCode)=""
							}
						}
					}
				}
		}
	}
	}elseif (kpimoduleRptSign="report"){//用户操作的报表
		//s ^TEMPDHCWL("mod","test")=treeNodes_"^"_kpimoduleRptSign
		s rptIDs=treeNodes
		s rptNum=$length(rptIDs,",")
		for i=1:1:rptNum{
			s rptID=$p(rptIDs,",",i)
			q:rptID=""
			s len=$l(rptID,".")
			s rptCode=$p(rptID,".",len)
			//s rptCode=$lg(^DHCWL.MKPI.MMgrRptCfgD(rptID),2,"")
			continue:rptCode=""
			s moduleCode=$p(rptID,".",1,(len-1))
			//s moduleCode=$lg(^DHCWL.MKPI.MMgrRptCfgD(rptID),5,"")
			continue:moduleCode=""
			s dataSetCode=""
			for{
				s dataSetCode=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",moduleCode,rptCode,dataSetCode))
				q:dataSetCode=""
				s dataSetId=""
				s dataSetId=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",moduleCode,rptCode,dataSetCode,dataSetId))
				continue:dataSetId=""
				s dataSetRule=$lg(^DHCWL.MKPI.MMgrDataSetCfgD(dataSetId),5,"")
				continue:dataSetRule=""
				s RuleLength=$length(dataSetRule,",")
				for j=1:1:RuleLength{
					s kpiRule=$p(dataSetRule,",",j)
					s datasetKpiCode=$p(kpiRule,":",1)
					continue:datasetKpiCode=""
					if ($d(saveKpiList(datasetKpiCode))=0){
						s saveKpiList(datasetKpiCode)=""
					}
				}
			}
		}
	}
}

/*
*返回与模板中任务设置不同的指标任务信息
*creator:wk
*创建日期：2015-10-20
*d ##class(DHCWL.MKPIService.KpiModuleData).GetKpiSectionInfor("D:CreatYesterdayData^DHCWLAutoCreatMKPIData:N",1,102,"report")
*/
ClassMethod GetKpiSectionInfor(secs, sectionNum, treeNodes, kpimoduleRptSign) As %String
{
	k saveKpiList
	do ..GetModuleRptKpiInfor(treeNodes, kpimoduleRptSign,.saveKpiList)
	s kpiSectionInfor=""
	s datasetKpiCode=""
	for{
		//s kpiSectionInfor=""
		s datasetKpiCode=$o(saveKpiList(datasetKpiCode))
		q:datasetKpiCode=""
		s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(datasetKpiCode,"DHCWL.MKPI.MKPI")
		continue:kpiId=""
		s activeFlag=""
		s sectionDr=0
		if ($o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,activeFlag))=""){
			continue
		}
		for{
			//s sectionDr=0
			s activeFlag=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,activeFlag))
			q:activeFlag=""
			s sectionId=""
			for{
				s sectionId=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,activeFlag,sectionId))
				q:sectionId=""
                s sectionDr=sectionDr+$lg(^DHCWL.MKPI.CreatDataTaskD(sectionId),5,0) //求出指标任务ID总和
			}
			
		}
		//s saveKpiList(datasetKpiCode)=sectionDr
		//w datasetKpiCode_","_kpiId_","_sectionDr,!
		//s kpiSectionInfor=""
		if ((sectionDr=sectionNum)&&(secs'="")){//任务ID总和相等时，比较执行代码和激活状态
			s secLength=$length(secs,",")
			s sectionNumSign=""
			for k=1:1:secLength{
				s secodeExec=$p(secs,",",k)
				q:secodeExec=""
				s sectionCode=$p(secodeExec,":",1)
				q:sectionCode=""
				s sectionExecode=$p(secodeExec,":",2)
				q:sectionExecode=""
				s sectionActiveFlag=$p(secodeExec,":",3)
				q:sectionActiveFlag=""
				s sectionNumSign=$o(^DHCWL.MKPI.SectionI("SecCode",sectionCode,sectionNumSign))
				s activeFlag=""
				s activeFlag=$o(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",sectionNumSign,kpiId,activeFlag))
				s sectionId=""
				s sectionId=$o(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",sectionNumSign,kpiId,activeFlag,sectionId))
				s secExecode=$lg(^DHCWL.MKPI.CreatDataTaskD(sectionId),3,"")
				s secActiveFlag=$lg(^DHCWL.MKPI.CreatDataTaskD(sectionId),2,"")
				if (secExecode '=sectionExecode){  //如果执行代码不同，则使指标任务ID总和与用户需要修改的任务ID总和不同
					s sectionDr=sectionDr+1
					q
				}
				if (secActiveFlag '= sectionActiveFlag){  //若果激活状态不同，则使指标任务ID总和与用户需要修改的任务ID总和不同
					s sectionDr=sectionDr+1
					q
				}
			} 
		}
		if (sectionDr'=sectionNum){//若模板上任务ID总和和指标的不同，则将指标的任务信息返回
			s showKpiId=kpiId
			s showActiveFlag=""
			for{
			s showActiveFlag=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",showKpiId,showActiveFlag))
			q:showActiveFlag=""
			s showSectionId=""
			for{
				s showSectionId=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",showKpiId,showActiveFlag,showSectionId))
				q:showSectionId=""
				s code1=$Extract(datasetKpiCode,1,2)
				s code1=$zcvt(code1,"U")
				s code2=$Extract(datasetKpiCode,1)
				s code2=$zcvt(code2,"U")
				s publicKpiSign=""
				if code1="KP"{
					s kpiProperty="N"
				}elseif code2="K"{
					s kpiProperty="Y"
				}else{
					s kpiProperty="O"
				}
				s sectionKpiCode=datasetKpiCode
				s sectionSecCode=$lg(^DHCWL.MKPI.CreatDataTaskD(showSectionId),6,"")
				s showSectionNum=""
				s showSectionNum=$o(^DHCWL.MKPI.SectionI("SecCode",sectionSecCode,showSectionNum))
				s sectionSecName=$lg(^DHCWL.MKPI.SectionD(showSectionNum),4,"")
				s sectionDTaskExcuteCode=$lg(^DHCWL.MKPI.CreatDataTaskD(showSectionId),3,"")
				if (sectionDTaskExcuteCode'=""){
					s sectionDTaskExcuteCodeTip="s monthId="_sectionDTaskExcuteCode_"()"
				}
				s sectionDTaskActiveFlag=$lg(^DHCWL.MKPI.CreatDataTaskD(showSectionId),2,"")
				s sign=0
				s sign=0
				for n=1:1:($length(secs,",")){
					s secodeExec=$p(secs,",",n)
					q:secodeExec=""
					s sectionCode=$p(secodeExec,":",1)
					q:sectionCode
					s sectionExecode=$p(secodeExec,":",2)
					s sectionActiveFlag=$p(secodeExec,":",3)
					if (sectionCode=sectionSecCode){  //判断什么原因导致不同
						s sign=1
						if (sectionDTaskExcuteCode'=sectionExecode){
							s sign=2
						}
						if (sectionActiveFlag'=sectionDTaskActiveFlag){
							s sign=3
						}
						if ((sectionActiveFlag'=sectionDTaskActiveFlag)&&(sectionDTaskExcuteCode'=sectionExecode)){
							s sign=4
						}
					}
					if ((n=($length(secs,",")))&&(sign=0)){
						s sign=5
					}
				}
				s kpiSectionInfor=kpiSectionInfor_"{sectionKpiCode:"_"'"_sectionKpiCode_"'"_",kpiProperty:"_"'"_kpiProperty_"'"_",sectionSecCode:"_"'"_sectionSecCode_"'"_",sectionSecName:"_"'"_sectionSecName_"'"_",sectionDTaskExcuteCode:"_"'"_sectionDTaskExcuteCode_"'"_",sectionDTaskExcuteCodeTip:"_"'"_sectionDTaskExcuteCodeTip_"'"_",sectionDTaskActiveFlag:"_"'"_sectionDTaskActiveFlag_"'"_",sign:"_"'"_sign_"'"_"},"
			}
			
		}
		}
	}
	s kpiSectionInfor=$Extract(kpiSectionInfor,1,$length(kpiSectionInfor)-1)
	q kpiSectionInfor
}

/*
*为选择的指标和本身不存在任务的指标添加任务
*creator:wk
*createdate:2015-10-20
*d ##class(DHCWL.MKPIService.KpiModuleData).SetSectionTask("K0004","D,日,CreatYesterdayData^DHCWLAutoCreatMKPIData,N@M,月,CreatLastMonDataAt1^DHCWLAutoCreatMKPIData,N@Q,季,CreatLastQuaDateAt1^DHCWLAutoCreatMKPIData,N")
*/
ClassMethod SetSectionTask(kpiCodes, secinfors, kpiselNodeIDs, kpimoduleRptSign)
{
	//q:kpiCodes="" 0
	q:secinfors="" 0
	k sectionSaveList
	k checkList
	k saveKpiList
	do ..GetModuleRptKpiInfor(kpiselNodeIDs, kpimoduleRptSign,.saveKpiList)
	s datasetKpiCode=""
	for{
		s datasetKpiCode=$o(saveKpiList(datasetKpiCode))
		q:datasetKpiCode=""
		s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(datasetKpiCode,"DHCWL.MKPI.MKPI")
		continue:kpiId=""
		s activeFlag=""
		s activeFlag=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,activeFlag))
		if (activeFlag=""){
			if (kpiCodes'=""){
				s kpiCodes=kpiCodes_","
			}
			s kpiCodes=kpiCodes_datasetKpiCode
		}
	}
	s kpiLen=$length(kpiCodes,",")
	s secLen=$length(secinfors,"@")
	s sign=0
	for j=1:1:secLen{             //检测数据准确性，若准确则将信息分条保存，否则不做后续处理
		s secinfor=$p(secinfors,"@",j)
		s secCode=$p(secinfor,",",1)
		s secName=$p(secinfor,",",2)
		s secExecCode=$p(secinfor,",",3)
		s secActiveFlag=$p(secinfor,",",4)
		s secCodeC=""
		for{
			s secCodeC=$o(^DHCWL.MKPI.SectionI("SecCode",secCodeC))
			q:secCodeC=""
			s checkList(secCodeC)=""
		}
		if ($d(checkList(secCode))=0){
			s sign=1
			q
		}
		kill checkList
		s secNameC=""
		for{
			s secNameC=$o(^DHCWL.MKPI.SectionI("SecName",secNameC))
			q:secNameC=""
			s checkList(secNameC)=""
		}
		if ($d(checkList(secName))=0){
			s sign=1
			q
		}
		kill checkList
		s secExecCodeC=""
		s execCodeId=""
		for{
			s secCodeC=" "_secCode
			s execCodeId=$o(^DHCWL.MKPI.ExecuteCodeI("TypeSubType"," TAS",secCodeC,execCodeId))
			q:execCodeId=""
			s secExecCodeC=$lg(^DHCWL.MKPI.ExecuteCodeD(execCodeId),3,"")
			s checkList(secExecCodeC)=""
		}
		if ($d(checkList(secExecCodeC))=0){
			s sign=1
			q
		}
		if ((secActiveFlag'="Y")&&(secActiveFlag'="N")){
			s sign=1
			q
		}
		s sectionId=""
		s sectionId=$o(^DHCWL.MKPI.SectionI("SecCode",secCode,sectionId))
		s sectionSaveList(sectionId)=secinfor
	}
	
	if (sign=0){
	tstart
	s wrongFlag=0
	for i=1:1:kpiLen{
		s kpiCode=$p(kpiCodes,",",i)
		s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
		continue:kpiId=""
		s sectionId=""
		for{
			s sectionId=$o(^DHCWL.MKPI.SectionD(sectionId))
			q:sectionId=""
			s sectionKpi=sectionId_","_kpiId
			s activeFlag=""
			s taskId=""
			s kpiExist=0
			s secExist=0
			s activeFlag=$o(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",sectionId,kpiId,activeFlag))
			if activeFlag'=""{
				s taskId=$o(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",sectionId,kpiId,activeFlag,taskId))
				if ((taskId'="")&&($d(^DHCWL.MKPI.CreatDataTaskD(taskId)))){
					s kpiExist=1
				}
			}
			if ($d(sectionSaveList(sectionId))){
				
				s secExist=1
			}
			if ((kpiExist=0)&&(secExist=0)){
				
			}
			if ((kpiExist=1)&&(secExist=0)){
				set creatDataTaskObj=##class(DHCWL.MKPI.CreatDataTask).%OpenId(taskId)
				s result=##class(DHCWL.MKPI.CreatDataTask).%Delete(creatDataTaskObj.%Oid())
				if result'=1{
					s wrongFlag=1
					q
				}
			}
			if ((kpiExist=0)&&(secExist=1)){
				set creatDataTaskObj=##class(DHCWL.MKPI.CreatDataTask).%New()
				if creatDataTaskObj=""{
					s wrongFlag=1
					q
				}
				set creatDataTaskObj.DTaskActiveFlag=$p(sectionSaveList(sectionId),",",4)
				set creatDataTaskObj.DTaskExcuteCode=$p(sectionSaveList(sectionId),",",3)
				set kpiObj=##class(DHCWL.MKPI.MKPI).%OpenId(kpiId)
				if kpiObj=""{
					s wrongFlag=1
					q
				}
				set creatDataTaskObj.DTaskKPIDR=kpiObj
				set creatDataTaskObj.DTaskMonthExcuteCode=$p(sectionSaveList(sectionId),",",1)
				set sectionObj=##class(DHCWL.MKPI.Section).%OpenId(sectionId)
				if sectionObj=""{
					s wrongFlag=1
					q
				}
				set creatDataTaskObj.DTaskSectionDR=sectionObj
				s result=creatDataTaskObj.%Save()
				if result'=1{
					s wrongFlag=1
					q
				}
			}
			if ((kpiExist=1)&&(secExist=1)){
				set creatDataTaskObj=##class(DHCWL.MKPI.CreatDataTask).%OpenId(taskId)
				s creatDataTaskObj.DTaskActiveFlag=$p(sectionSaveList(sectionId),",",4)
				set creatDataTaskObj.DTaskExcuteCode=$p(sectionSaveList(sectionId),",",3)
				s result=creatDataTaskObj.%Save()
				if result'=1{
					s wrongFlag=1
					q
				}
			}
		}
	}
	if wrongFlag=1{
		trollback
	}
	else{
		tcommit
	}
	if (wrongFlag=1){
		q 1
	}else{
		q 0
	}
	}
	q 0
}

Storage Default
{
<Data name="KpiModuleDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPISe90C2.KpiModuleDataD</DataLocation>
<DefaultData>KpiModuleDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPISe90C2.KpiModuleDataD</IdLocation>
<IndexLocation>^DHCWL.MKPISe90C2.KpiModuleDataI</IndexLocation>
<StreamLocation>^DHCWL.MKPISe90C2.KpiModuleDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
