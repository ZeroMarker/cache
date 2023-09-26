/// // k ^DHCWL.MKPI.MMgrDataSetCfgI  d ##class(DHCWL.MKPI.MMgrDataSetCfg).%BuildIndices()   
/// DHCWL_MKPI.MMgrDatasetCfg
Class DHCWL.MKPI.MMgrDataSetCfg Extends %Persistent [ ClassType = persistent, SqlRowIdName = DatasetCfg_RowID, SqlTableName = MMgrDatasetCfg ]
{

Parameter EXTENTSIZE = 250;

Property DatasetCfgCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DatasetCfg_Code ];

Property DatasetCfgDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DatasetCfg_Desc ];

Property DatasetRuleList As %Library.Text(COLLATION = "Exact", MAXLEN = 4096, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DatasetCfg_RuleList ];

Property DatasetRptCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DatasetCfg_RptCode ];

Property DatasetTreeCode As %Library.String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DatasetCfg_TreeCode ];

Property DatasetFilterList As %Library.Text(COLLATION = "Exact", MAXLEN = 2048, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DatasetCfg_FilterList ];

Index DatasetMRCodeIdx On (DatasetTreeCode, DatasetRptCode, DatasetCfgCode);

Trigger TriggerForModify [ Event = UPDATE, Time = AFTER ]
{
	s treeCode={DatasetCfg_TreeCode}
	s rptCode={DatasetCfg_RptCode}
	s dsCode={DatasetCfg_Code}
	&sql(delete from DHCWL_MKPI.MMgrKPICfg where KPICfg_DatasetCode=:dsCode and KPICfg_RptCode=:rptCode and KPICfg_TreeCode=:treeCode )
	s listKpiCode=$LISTFROMSTRING({DatasetCfg_RuleList},",")
	for i=1:1:$ll(listKpiCode) {
		s kpiCode=$lg(listKpiCode,i)
		s kpiCode=$p(kpiCode,":",1)
		&sql(insert into DHCWL_MKPI.MMgrKPICfg (KPICfg_Code,KPICfg_DatasetCode,KPICfg_RptCode,KPICfg_TreeCode) values (:kpiCode,:dsCode,:rptCode,:treeCode) )
	}
}

Trigger TriggerForIns [ Event = INSERT, Time = AFTER ]
{
	s treeCode={DatasetCfg_TreeCode}
	s rptCode={DatasetCfg_RptCode}
	s dsCode={DatasetCfg_Code}
	&sql(delete from DHCWL_MKPI.MMgrKPICfg where KPICfg_DatasetCode=:dsCode and KPICfg_RptCode=:rptCode and KPICfg_TreeCode=:treeCode )
	s listKpiCode=$LISTFROMSTRING({DatasetCfg_RuleList},",")
	for i=1:1:$ll(listKpiCode) {
		s kpiCode=$lg(listKpiCode,i)
		s kpiCode=$p(kpiCode,":",1)
		&sql(insert into DHCWL_MKPI.MMgrKPICfg (KPICfg_Code,KPICfg_DatasetCode,KPICfg_RptCode,KPICfg_TreeCode) values (:kpiCode,:dsCode,:rptCode,:treeCode) )
	}
}

Method %OnAfterSave(Insert As %Boolean) As %Status [ Private ]
{
	s treeCode=..DatasetTreeCode
	s rptCode=..DatasetRptCode
	s dsCode=..DatasetCfgCode

	&sql(delete from DHCWL_MKPI.MMgrKPICfg where KPICfg_DatasetCode=:dsCode and KPICfg_RptCode=:rptCode and KPICfg_TreeCode=:treeCode )
	
	s listKpiCode=$LISTFROMSTRING(..DatasetRuleList,",")
	for i=1:1:$ll(listKpiCode) {
		s kpiCode=$lg(listKpiCode,i)
		s kpiCode=$p(kpiCode,":",1)
		&sql(insert into DHCWL_MKPI.MMgrKPICfg (KPICfg_Code,KPICfg_DatasetCode,KPICfg_RptCode,KPICfg_TreeCode) values (:kpiCode,:dsCode,:rptCode,:treeCode) )
	}
	
	q 1
}

/// Index DatasetMRCodeIdx On (DatasetTreeCode, DatasetRptCode, DatasetCfgCode);
ClassMethod InsertOrUpdateData(ByRef aryParam) As %String
{
	//n (aryParam)
	s ret=""
	s treeCode=aryParam("DatasetTreeCode")
	s rptCode=aryParam("DatasetRptCode")
	s code=aryParam("DatasetCfgCode")

	if $d(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rptCode,code)) {
		//如果已存在则更新
		s ID=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rptCode,code,""))
		q:$G(ID)="" ret
		s obj=##class(DHCWL.MKPI.MMgrDataSetCfg).%OpenId(ID)
		if $isobject(obj) {
			s obj.DatasetCfgDesc=aryParam("DatasetCfgDesc")
			s obj.DatasetRuleList=aryParam("DatasetRuleList")
			s sc=obj.%Save()
			If $$$ISERR(sc) {
				s ret=$System.Status.GetErrorText(sc)
			}else{
				s ret="success"
			} 
		}else{
			q "打开数据集对象："_code_"失败！"
		}
		
	}else{
		if '$d(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,rptCode)) {
			//如果父节点不存在，返回错误信息	
			q "数据集对象："_code_"的父节点不存在！"
		}else{
			//添加新数据
			s obj=##class(DHCWL.MKPI.MMgrDataSetCfg).%New()
			if $isobject(obj) {
				s obj.DatasetTreeCode=aryParam("DatasetTreeCode")
				s obj.DatasetRptCode=aryParam("DatasetRptCode")
				s obj.DatasetCfgCode=aryParam("DatasetCfgCode")
				s obj.DatasetCfgDesc=aryParam("DatasetCfgDesc")
				s obj.DatasetRuleList=aryParam("DatasetRuleList")			
				s sc=obj.%Save()
				If $$$ISERR(sc) {
					s ret=$System.Status.GetErrorText(sc)
				}else{
					s ret="success"
				} 
			
			}else{
				q "新建报表对象："_aryParam("DatasetCfgCode")_"失败！"
			}
		}
	}
	q ret
}

ClassMethod RejectKpiFromRule(kpiIDs As %String) As %String
{
	s ret=""
	s happedErr=0
	s kpiLen=$l(kpiIDs,",")
	f i=1:1:kpiLen {
		q:happedErr=1
		s kpiID=$p(kpiIDs,",",i)
		s kpiCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(kpiID,"DHCWL.MKPI.MKPI")	
		continue:kpiCode=""
		
		s KPICfgCode=kpiCode
		continue:'$d(^DHCWL.MKPI.MMgrKPICfgI("KTRDIdx",KPICfgCode))
		
		s KPITreeCode=""
		f {
			s KPITreeCode=$o(^DHCWL.MKPI.MMgrKPICfgI("KTRDIdx",KPICfgCode, KPITreeCode))
			q:KPITreeCode=""
			q:happedErr=1
			s KPIRptCode=""
			f {
				s KPIRptCode=$o(^DHCWL.MKPI.MMgrKPICfgI("KTRDIdx",KPICfgCode, KPITreeCode,KPIRptCode))
				q:KPIRptCode=""
				q:happedErr=1
				s KPIDatasetCfgCode=""
				f {
					s KPIDatasetCfgCode=$o(^DHCWL.MKPI.MMgrKPICfgI("KTRDIdx",KPICfgCode, KPITreeCode,KPIRptCode,KPIDatasetCfgCode))	
					q:KPIDatasetCfgCode=""
					q:happedErr=1

					if $d(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",KPITreeCode,KPIRptCode,KPIDatasetCfgCode)) {
						s dsID=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",KPITreeCode,KPIRptCode,KPIDatasetCfgCode,""))
						q:$g(dsID)=""
						q:happedErr=1
						s obj=##class(DHCWL.MKPI.MMgrDataSetCfg).%OpenId(dsID)
						if $isobject(obj) {
							s newRule=""
							s rule=obj.DatasetRuleList
							s ruleLen=$l(rule,",")
							f j=1:1:ruleLen {
								s pieceRule=$p(rule,",",j)
								s pieceKpi=$p(pieceRule,":",1)
								if pieceKpi'=kpiCode {
									if newRule'="" s newRule=newRule_","
									s newRule=newRule_pieceRule	
								}
								
							}
							s obj.DatasetRuleList=newRule
							s sc=obj.%Save()
							If $$$ISERR(sc) {
								s ret=$System.Status.GetErrorText(sc)
								s happedErr=1
							}

						}
					}

				}
			}
			
		}

	}
	if ret="" s ret="ok"
	q ret
}

Storage Default
{
<Data name="MMgrDataSetCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DatasetCfgCode</Value>
</Value>
<Value name="3">
<Value>DatasetCfgDesc</Value>
</Value>
<Value name="4">
<Value>DatasetRptCode</Value>
</Value>
<Value name="5">
<Value>DatasetRuleList</Value>
</Value>
<Value name="6">
<Value>DatasetTreeCode</Value>
</Value>
<Value name="7">
<Value>DatasetFilterList</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MMgrDataSetCfgD</DataLocation>
<DefaultData>MMgrDataSetCfgDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^DHCWL.MKPI.MMgrDataSetCfgD</IdLocation>
<IndexLocation>^DHCWL.MKPI.MMgrDataSetCfgI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MMgrDataSetCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
