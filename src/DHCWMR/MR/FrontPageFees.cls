/// 名称 : DHCWMR.MR.FrontPageFees
/// 说明 : 住院病案首页费用表【P6】
Class DHCWMR.MR.FrontPageFees Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.MR.FrontPage [ Cardinality = parent, Inverse = ChildFees ];

/// 住院费用-总费用
Property P60010000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 住院费用-自付金额
Property P60010100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 住院费用-其他支付
Property P60010200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 综合医疗服务类-一般医疗服务费
Property P60020100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 综合医疗服务类-中医辩证论治费
Property P60020200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 综合医疗服务类-中医辩证论治会诊费
Property P60020300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 综合医疗服务类-一般治疗操作费
Property P60020400 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 综合医疗服务类-护理费
Property P60020500 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 综合医疗服务类-其他费用
Property P60020600 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断类-病理诊断费
Property P60030100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断类-实验室诊断费
Property P60030200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断类-影像学诊断费
Property P60030300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断类-临床诊断项目费
Property P60030400 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 治疗类-非手术治疗项目费
Property P60040100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 治疗类-临床物理治疗费
Property P60040200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 治疗类-手术治疗费
Property P60040300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 治疗类-麻醉费
Property P60040400 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 治疗类-手术费
Property P60040500 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 康复类-康复费
Property P60050100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 中医类-中医诊断
Property P60060100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 中医类-中医治疗
Property P60060200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 中医类-中医外治
Property P60060300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 中医类-中医骨伤
Property P60060400 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 中医类-针刺与灸法
Property P60060500 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 中医类-中医推拿治疗
Property P60060600 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 中医类-中医肛肠治疗
Property P60060700 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 中医类-中医特殊治疗
Property P60060800 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 中医类-中医其他
Property P60060900 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 中医类-重要特殊调配加工
Property P60061000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 中医类-辩证施膳
Property P60061100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 西药类-西药费
Property P60070100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 西药类-抗菌药物费用
Property P60070200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 中药类-中成药费
Property P60080100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 中药类-医疗机构中药制剂费
Property P60080200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 中药类-中草药费
Property P60080300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 血液和血液制品类-血费
Property P60090100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 血液和血液制品类-白蛋白类制品费
Property P60090200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 血液和血液制品类-球蛋白类制品费
Property P60090300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 血液和血液制品类-凝血因子类制品费
Property P60090400 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 血液和血液制品类-细胞因子类制品费
Property P60090500 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 耗材费-检查用一次性医用材料费
Property P60100100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 耗材费-治疗用一次性医用材料费
Property P60100200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 耗材费-手术用一次性医用材料费
Property P60100300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 其他类-其他费
Property P60110100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  取费用信息
/// Table：       DHCWMR.MR.FrontPageFees
/// Input：       Id : DHCWMR.MR.FrontPageFees.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MR.FrontPageFees).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MR.FrontPageFees
{
	new (aId)
	quit:'##class(DHCWMR.MR.FrontPageFees).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MR.FrontPageFees).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  保存费用信息
/// Table：       DHCWMR.MR.FrontPageFees
/// Input：       InputStr ：费用信息="..."
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.MR.FrontPageFees).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	
	Set objParref=##class(DHCWMR.MR.FrontPage).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildSub="" {
		Set obj=##class(DHCWMR.MR.FrontPageFees).%New()
	} Else {
		Set obj=##class(DHCWMR.MR.FrontPageFees).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         = objParref
	Set obj.P60010000 = $p(aInputStr,aSeparate,3)     //住院费用-总费用
	Set obj.P60010100 = $p(aInputStr,aSeparate,4)     //住院费用-自付金额
	Set obj.P60020100 = $p(aInputStr,aSeparate,5)     //综合医疗服务类-一般医疗服务费
	Set obj.P60020200 = $p(aInputStr,aSeparate,6)     //综合医疗服务类-中医辩证论治费
	Set obj.P60020300 = $p(aInputStr,aSeparate,7)     //综合医疗服务类-中医辩证论治会诊费
	Set obj.P60020400 = $p(aInputStr,aSeparate,8)     //综合医疗服务类-一般治疗操作费
	Set obj.P60020500 = $p(aInputStr,aSeparate,9)     //综合医疗服务类-护理费
	Set obj.P60020500 = $p(aInputStr,aSeparate,10)    //综合医疗服务类-其他费用
	Set obj.P60030100 = $p(aInputStr,aSeparate,11)    //诊断类-病理诊断费
	Set obj.P60030200 = $p(aInputStr,aSeparate,12)    //诊断类-实验室诊断费
	Set obj.P60030300 = $p(aInputStr,aSeparate,13)    //诊断类-影像学诊断费
	Set obj.P60030400 = $p(aInputStr,aSeparate,14)    //诊断类-临床诊断项目费
	Set obj.P60040100 = $p(aInputStr,aSeparate,15)    //治疗类-非手术治疗项目费
	Set obj.P60040200 = $p(aInputStr,aSeparate,16)    //治疗类-临床物理治疗费
	Set obj.P60040300 = $p(aInputStr,aSeparate,17)    //治疗类-手术治疗费
	Set obj.P60040400 = $p(aInputStr,aSeparate,18)    //治疗类-麻醉费
	Set obj.P60040500 = $p(aInputStr,aSeparate,19)    //治疗类-手术费
	Set obj.P60050100 = $p(aInputStr,aSeparate,20)    //康复类-康复费
	Set obj.P60060100 = $p(aInputStr,aSeparate,21)    //中医类-中医诊断
	Set obj.P60060200 = $p(aInputStr,aSeparate,22)    //中医类-中医治疗
	Set obj.P60060300 = $p(aInputStr,aSeparate,23)    //中医类-中医外治
	Set obj.P60060400 = $p(aInputStr,aSeparate,24)    //中医类-中医骨伤
	Set obj.P60060500 = $p(aInputStr,aSeparate,25)    //中医类-针刺与灸法
	Set obj.P60060600 = $p(aInputStr,aSeparate,26)    //中医类-中医推拿治疗
	Set obj.P60060700 = $p(aInputStr,aSeparate,27)    //中医类-中医肛肠治疗
	Set obj.P60060800 = $p(aInputStr,aSeparate,28)    //中医类-中医特殊治疗
	Set obj.P60060900 = $p(aInputStr,aSeparate,29)    //中医类-中医其他
	Set obj.P60061000 = $p(aInputStr,aSeparate,30)    //中医类-重要特殊调配加工
	Set obj.P60061100 = $p(aInputStr,aSeparate,31)    //中医类-辩证施膳
	Set obj.P60070100 = $p(aInputStr,aSeparate,32)    //西药类-西药费
	Set obj.P60070200 = $p(aInputStr,aSeparate,33)    //西药类-抗菌药物费用
	Set obj.P60080100 = $p(aInputStr,aSeparate,34)    //中药类-中成药费
	Set obj.P60080200 = $p(aInputStr,aSeparate,35)    //中药类-医疗机构中药制剂费
	Set obj.P60080300 = $p(aInputStr,aSeparate,36)    //中药类-中草药费
	Set obj.P60090100 = $p(aInputStr,aSeparate,37)    //血液和血液制品类-血费
	Set obj.P60090200 = $p(aInputStr,aSeparate,38)    //血液和血液制品类-白蛋白类制品费
	Set obj.P60090300 = $p(aInputStr,aSeparate,39)    //血液和血液制品类-球蛋白类制品费
	Set obj.P60090400 = $p(aInputStr,aSeparate,40)    //血液和血液制品类-凝血因子类制品费
	Set obj.P60090500 = $p(aInputStr,aSeparate,41)    //血液和血液制品类-细胞因子类制品费
	Set obj.P60100100 = $p(aInputStr,aSeparate,42)    //耗材费-检查用一次性医用材料费
	Set obj.P60100200 = $p(aInputStr,aSeparate,43)    //耗材费-治疗用一次性医用材料费
	Set obj.P60100300 = $p(aInputStr,aSeparate,44)    //耗材费-手术用一次性医用材料费
	Set obj.P60110100 = $p(aInputStr,aSeparate,45)    //其他类-其他费
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  删除费用信息
/// Table：       DHCWMR.MR.FrontPageFees
/// Input：       Id : DHCWMR.MR.FrontPageFees.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MR.FrontPageFees).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>P60010000</Value>
</Value>
<Value name="3">
<Value>P60010100</Value>
</Value>
<Value name="4">
<Value>P60010200</Value>
</Value>
<Value name="5">
<Value>P60020100</Value>
</Value>
<Value name="6">
<Value>P60020200</Value>
</Value>
<Value name="7">
<Value>P60020300</Value>
</Value>
<Value name="8">
<Value>P60020400</Value>
</Value>
<Value name="9">
<Value>P60020500</Value>
</Value>
<Value name="10">
<Value>P60020600</Value>
</Value>
<Value name="11">
<Value>P60030100</Value>
</Value>
<Value name="12">
<Value>P60030200</Value>
</Value>
<Value name="13">
<Value>P60030300</Value>
</Value>
<Value name="14">
<Value>P60030400</Value>
</Value>
<Value name="15">
<Value>P60040100</Value>
</Value>
<Value name="16">
<Value>P60040200</Value>
</Value>
<Value name="17">
<Value>P60040300</Value>
</Value>
<Value name="18">
<Value>P60040400</Value>
</Value>
<Value name="19">
<Value>P60040500</Value>
</Value>
<Value name="20">
<Value>P60050100</Value>
</Value>
<Value name="21">
<Value>P60060100</Value>
</Value>
<Value name="22">
<Value>P60060200</Value>
</Value>
<Value name="23">
<Value>P60060300</Value>
</Value>
<Value name="24">
<Value>P60060400</Value>
</Value>
<Value name="25">
<Value>P60060500</Value>
</Value>
<Value name="26">
<Value>P60060600</Value>
</Value>
<Value name="27">
<Value>P60060700</Value>
</Value>
<Value name="28">
<Value>P60060800</Value>
</Value>
<Value name="29">
<Value>P60060900</Value>
</Value>
<Value name="30">
<Value>P60061000</Value>
</Value>
<Value name="31">
<Value>P60061100</Value>
</Value>
<Value name="32">
<Value>P60070100</Value>
</Value>
<Value name="33">
<Value>P60070200</Value>
</Value>
<Value name="34">
<Value>P60080100</Value>
</Value>
<Value name="35">
<Value>P60080200</Value>
</Value>
<Value name="36">
<Value>P60080300</Value>
</Value>
<Value name="37">
<Value>P60090100</Value>
</Value>
<Value name="38">
<Value>P60090200</Value>
</Value>
<Value name="39">
<Value>P60090300</Value>
</Value>
<Value name="40">
<Value>P60090400</Value>
</Value>
<Value name="41">
<Value>P60090500</Value>
</Value>
<Value name="42">
<Value>P60100100</Value>
</Value>
<Value name="43">
<Value>P60100200</Value>
</Value>
<Value name="44">
<Value>P60100300</Value>
</Value>
<Value name="45">
<Value>P60110100</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("FEES")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("FEES")</IdLocation>
<IndexLocation>^DHCWMR.MR.FrontPageI("FEES")</IndexLocation>
<StreamLocation>^DHCWMR.MR.FrontPageFeesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
