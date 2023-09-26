/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualitySetting
/// * Description:	电子病历事件参数设置，用于保存启动开关设置
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:		
/// ************************************************************/
Class EPRmeta.Quality.QualitySetting Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxSSGroup On (SSGroupDR, EventTypeDR, HospitalDR);

Index IdxHospitalStruct On (IsActive, QualityRuleDR, HospitalDR, StructDR);

Index IdxComposite On (HospitalDR, SSGroupDR, EventTypeDR, ControlTypeDR, QualityRuleDR) [ Unique ];

/// Binding hospital reference
Property HospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// Binding security group reference
Property SSGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// Binding event type reference
Property EventTypeDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// Binding control type reference
Property ControlTypeDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// Binding quality rule reference
Property QualityRuleDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// Whether this quality setting is active or not
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7 ];

/// Resume of this quality setting
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

/// 病历目录结构
Property StructDR As %Integer [ SqlColumnNumber = 9 ];

Query SelectQuaSettingData() As %Query(ROWSPEC = "RowId,HospitalId,HospitalDesc,SSGroupId,SSGroupDesc,EventTypeId,EventTypeDesc,ControlTypeId,ControlTypeDesc,QualityRuleId,QualityRuleDesc,IsActive,ResumeText,QualityStructId,QualityStructDesc")
{
}

ClassMethod SelectQuaSettingDataExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s (RowId,HospitalId,HospitalDesc,SSGroupId,SSGroupDesc,EventTypeId,EventTypeDesc,ControlTypeId,ControlTypeDesc,QualityRuleId,QualityRuleDesc,IsActive,ResumeText,QualityStructId,QualityStructDesc)=""
	s RowId = ""
	for
	{
		s RowId = $o(^DHCEPRM.QualitySettingD(RowId))
		q:(RowId = "")
		s objSetting = ##Class(EPRmeta.Quality.QualitySetting).%OpenId(RowId)
		continue:(objSetting = "")
		s HospitalId = objSetting.HospitalDR
		if (HospitalId '= "")
		{
			s HospitalDesc = $P($g(^CT("HOSP",+HospitalId)),"^",2)
		}
		
		s SSGroupId = objSetting.SSGroupDR
		if (SSGroupId '= "")
		{
			s SSGroupDesc=$p($g(^SSU("SSGRP",+SSGroupId)),"^",1)
		}
		
		s EventTypeId = objSetting.EventTypeDR
		if (EventTypeId '= "")
		{
			s objDic = ##Class(EPRmeta.Quality.QualityDictionary).%OpenId(EventTypeId)
			continue:(objDic = "")
			s EventTypeDesc = objDic.Name
			k objDic
		}
		
		s ControlTypeId = objSetting.ControlTypeDR
		if (ControlTypeId '= "")
		{
			s objDic = ##Class(EPRmeta.Quality.QualityDictionary).%OpenId(ControlTypeId)
			continue:(objDic = "")
			s ControlTypeDesc = objDic.Name
			k objDic
		}
		
		s QualityRuleId = objSetting.QualityRuleDR
		if (QualityRuleId '= "")
		{
			s objRule = ##Class(EPRmeta.Quality.QualityRule).%OpenId(QualityRuleId)
			continue:(objRule = "")
			s QualityRuleDesc = objRule.Name
			k objRule
		}
		
		s QualityStructId = objSetting.StructDR
		if (QualityStructId '= "") 
		{
			s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(QualityStructId)
			continue:(objStruct = "")
			s QualityStructDesc = objStruct.StandardName
			k objStruct
		}
		
		s IsActive = objSetting.IsActive
		s ResumeText = objSetting.ResumeText
		
		s Data = $lb(RowId,HospitalId,HospitalDesc,SSGroupId,SSGroupDesc,EventTypeId,EventTypeDesc,ControlTypeId,ControlTypeDesc,QualityRuleId,QualityRuleDesc,IsActive,ResumeText,QualityStructId,QualityStructDesc)
		s ^CacheTemp(repid,ind)=Data
		s ind=ind+1
	}
	q $$$OK
}

ClassMethod SelectQuaSettingDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectQuaSettingDataExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectQuaSettingDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectQuaSettingDataExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Storage Default
{
<Data name="QualitySettingDefaultData">
<Value name="1">
<Value>HospitalDR</Value>
</Value>
<Value name="2">
<Value>SSGroupDR</Value>
</Value>
<Value name="3">
<Value>EventTypeDR</Value>
</Value>
<Value name="4">
<Value>ControlTypeDR</Value>
</Value>
<Value name="5">
<Value>QualityRuleDR</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
<Value name="7">
<Value>ResumeText</Value>
</Value>
<Value name="8">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="9">
<Value>StructDR</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualitySettingD</DataLocation>
<DefaultData>QualitySettingDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QualitySettingD</IdLocation>
<IndexLocation>^DHCEPRM.QualitySettingI</IndexLocation>
<StreamLocation>^DHCEPRM.QualitySettingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
