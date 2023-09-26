/// 查询疾病分类详细信息
/// 和DHCWMRCodingQry类配合使用
Class web.DHCWMRCodingDetailQry Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod GetPatientBaseInfoByMainID(MainID) As %String
{
		quit ##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainID)
}

ClassMethod GetPatientAdmInfo(VolID) As %String
{
		quit ##class(web.DHCWMRFPCodingQry).GetAdmitInfoString(VolID)
}

ClassMethod GetICDInfo(FrontPageID, ICDType) As %String
{
		set ICDRowID = ""
		set ret = ""
		set strData = "" 
		set ICDTypeData = ##class(web.DHCWMRDictionaryCtl).QueryByTypeCode("ICDType", ICDType)
		set ICDTypeDr = $p(ICDTypeData, "^", 1)
		
		while (1)
		{
			set ICDRowID = $o(^DHCWMRFPICD(0,"FP", FrontPageID, ICDRowID))
			quit:ICDRowID=""
			set strData = $g(^DHCWMRFPICD(ICDRowID))
			if ($p(strData, "^", 10) = ICDTypeDr)
			{
				set:ret'="" ret=ret_$c(1)
				if (ICDType = "D")
				{
					set ret = ret _ ##class(web.DHCWMRFPCodingQry).GetFpDiagnoseString(ICDRowID)
				}
				else
				{
					set ret = ret _ ##class(web.DHCWMRFPCodingQry).GetFpOperationString(ICDRowID)
				}
			}
		}
		quit ret
}

Storage Default
{
<Data name="DHCWMRCodingDetailQryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCWMRCodingDetailQryD</DataLocation>
<DefaultData>DHCWMRCodingDetailQryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCWMRCodingDetailQryD</IdLocation>
<IndexLocation>^web.DHCWMRCodingDetailQryI</IndexLocation>
<StreamLocation>^web.DHCWMRCodingDetailQryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
