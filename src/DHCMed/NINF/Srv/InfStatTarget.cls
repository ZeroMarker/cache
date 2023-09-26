/// Creator:wangcs
/// CreateDate:2013-02-26
/// Description:三级医院院感评审指标
Class DHCMed.NINF.Srv.InfStatTarget Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 月统计开始日期
Property DischStaDate As %Date;

/// 月统计结束日期
Property DischEndDate As %Date;

/// 统计月份
Property Month As %String(TRUNCATE = 1);

/// 出院患者院感发生例数
Property InfOfCount As %String(TRUNCATE = 1);

/// 出院人次
Property DischOfCount As %String(TRUNCATE = 1);

/// 手术相关医院感染例数
Property OperInfOfCount As %String(TRUNCATE = 1);

/// 手术患者出院人次
Property OperDischOfCount As %String(TRUNCATE = 1);

/// 手术相关肺部感染例数
Property OperPulmInfOfCount As %String(TRUNCATE = 1);

/// 新生儿医院感染发生例数
Property NewBornInfOfCount As %String(TRUNCATE = 1);

/// 同期新生儿患者出院人次 
Property NewBornDischOfCount As %String(TRUNCATE = 1);

/// 手术患者手术部位感染发生例数
Property OperPosiInfofCount As %String(TRUNCATE = 1);

/// 择期手术患者医院感染发生例数
Property SelTimeOperOfCount As %String(TRUNCATE = 1);

/// 同期择期手术患者出院人次 
Property SelTimeOperDischOfCount As %String(TRUNCATE = 1);

/// 择期手术患者肺部感染发生例数
Property SelTimeOperPulmInfOfCount As %String(TRUNCATE = 1);

/// 0级手术感染例数
Property Lev0OperInfOfCount As %String(TRUNCATE = 1);

/// 0级手术出院人次
Property Lev0OperDischOfCount As %String(TRUNCATE = 1);

/// 1级手术感染例数
Property Lev1OperInfOfCount As %String(TRUNCATE = 1);

/// 1级手术出院人次
Property Lev1OperDischOfCount As %String(TRUNCATE = 1);

/// 2级手术感染例数
Property Lev2OperInfOfCount As %String(TRUNCATE = 1);

/// 2级手术出院人次
Property Lev2OperDischOfCount As %String(TRUNCATE = 1);

/// 3级手术感染例数
Property Lev3OperInfOfCount As %String(TRUNCATE = 1);

/// 3级手术出院人次
Property Lev3OperDischOfCount As %String(TRUNCATE = 1);

/// 中心静脉相关血源性感染例数
Property VenousBloodInfOfCount As %String(TRUNCATE = 1);

/// 中心静脉置管病人日数
Property VenousCatheterOfDays As %String(TRUNCATE = 1);

/// 呼吸机相关肺部感染例数
Property RespPlumInfOfCount As %String(TRUNCATE = 1);

/// 使用呼吸机病人日数
Property RespOfDays As %String(TRUNCATE = 1);

/// 留置导尿管相关泌尿道感染例数
Property CathUrinaryTractInfoOfCount As %String(TRUNCATE = 1);

/// 留置导尿管病人日数
Property CathOfDays As %String(TRUNCATE = 1);

/// 血液感染例数
Property BloodInfOfCount As %String(TRUNCATE = 1);

/// 血液透析例数
Property HemodialysisOfCount As %String(TRUNCATE = 1);

Index IndexOfDischEndDate On DischEndDate;

Index IndexOfDischStaDate On DischStaDate;

Index IndexOfMonth On Month;

ClassMethod DeleteById(ID) As %String
{
	New (ID)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Srv.InfStatTarget).%DeleteId(ID)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

ClassMethod DeleteTargetByStaData(StaData As %String)
{
	New (StaData)
	Set TargetID=0,Count=0
	For {
		Set TargetID=$o(^DHCMed.NINF.Srv.InfStatTargetI("IndexOfDischStaDate",StaData,TargetID))
		Quit:TargetID=""
		
		Set Rtn=..DeleteById(TargetID)
		Set:Rtn=1 Count=$i(Count)
	}	
	Quit Count
}

Storage Default
{
<Data name="InfStatTargetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DischStaDate</Value>
</Value>
<Value name="3">
<Value>DischEndDate</Value>
</Value>
<Value name="4">
<Value>Month</Value>
</Value>
<Value name="5">
<Value>InfOfCount</Value>
</Value>
<Value name="6">
<Value>DischOfCount</Value>
</Value>
<Value name="7">
<Value>OperInfOfCount</Value>
</Value>
<Value name="8">
<Value>OperDischOfCount</Value>
</Value>
<Value name="9">
<Value>OperPulmInfOfCount</Value>
</Value>
<Value name="10">
<Value>NewBornInfOfCount</Value>
</Value>
<Value name="11">
<Value>NewBornDischOfCount</Value>
</Value>
<Value name="12">
<Value>OperPosiInfofCount</Value>
</Value>
<Value name="13">
<Value>SelTimeOperOfCount</Value>
</Value>
<Value name="14">
<Value>SelTimeOperDischOfCount</Value>
</Value>
<Value name="15">
<Value>SelTimeOperPulmInfOfCount</Value>
</Value>
<Value name="16">
<Value>Lev0OperInfOfCount</Value>
</Value>
<Value name="17">
<Value>Lev0OperDischOfCount</Value>
</Value>
<Value name="18">
<Value>Lev1OperInfOfCount</Value>
</Value>
<Value name="19">
<Value>Lev1OperDischOfCount</Value>
</Value>
<Value name="20">
<Value>Lev2OperInfOfCount</Value>
</Value>
<Value name="21">
<Value>Lev2OperDischOfCount</Value>
</Value>
<Value name="22">
<Value>Lev3OperInfOfCount</Value>
</Value>
<Value name="23">
<Value>Lev3OperDischOfCount</Value>
</Value>
<Value name="24">
<Value>VenousBloodInfOfCount</Value>
</Value>
<Value name="25">
<Value>VenousCatheterOfCount</Value>
</Value>
<Value name="26">
<Value>RespPlumInfOfCount</Value>
</Value>
<Value name="27">
<Value>RespOfCount</Value>
</Value>
<Value name="28">
<Value>CathUrinaryTractInfoOfCount</Value>
</Value>
<Value name="29">
<Value>CathOfCount</Value>
</Value>
<Value name="30">
<Value>BloodInfOfCount</Value>
</Value>
<Value name="31">
<Value>HemodialysisOfCount</Value>
</Value>
<Value name="32">
<Value>VenousCatheterOfDays</Value>
</Value>
<Value name="33">
<Value>RespOfDays</Value>
</Value>
<Value name="34">
<Value>CathOfDays</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Srv.InfStatTargetD</DataLocation>
<DefaultData>InfStatTargetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Srv.InfStatTargetD</IdLocation>
<IndexLocation>^DHCMed.NINF.Srv.InfStatTargetI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Srv.InfStatTargetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
