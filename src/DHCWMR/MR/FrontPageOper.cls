/// 名称 : DHCWMR.MR.FrontPageOper
/// 说明 : 住院病案首页手术/操作表【P4】
Class DHCWMR.MR.FrontPageOper Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.MR.FrontPage [ Cardinality = parent, Inverse = ChildOper ];

/// 类型
Property POType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 顺序号
Property POIndex As %Integer;

/// 流水号
Property POSerialNumber As %Integer;

/// 手术及操作
Property PO0100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术及操作编码
Property PO0101 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术及操作日期
Property PO0200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// update by shp  20151016
/// 手术及操作结束时间
Property PO0201 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术级别
Property PO0300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术级别编码
Property PO0301 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 术者
Property PO0400 As %String(MAXLEN = 100, TRUNCATE = 1);

/// Ⅰ助
Property PO0500 As %String(MAXLEN = 100, TRUNCATE = 1);

/// Ⅱ助
Property PO0600 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉方式
Property PO0700 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉方式编码
Property PO0701 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 切口愈合
Property PO0800 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 切口愈合编码
Property PO0801 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉医师
Property PO0900 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术及操作部位
Property PO1000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术及操作部位编码
Property PO1001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术持续时间
Property PO1100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉分级/ASA评分
Property PO1200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉分级/ASA评分编码
Property PO1201 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术患者类型
Property PO1300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术患者类型编码
Property PO1301 As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexTypeIndex On (Parref, POType, POIndex);

Index IndexSerialNumber On (Parref, POSerialNumber);

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  取手术信息
/// Table：       DHCWMR.MR.FrontPageOper
/// Input：       Id : DHCWMR.MR.FrontPageOper.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MR.FrontPageOper).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MR.FrontPageOper
{
	new (aId)
	quit:'##class(DHCWMR.MR.FrontPageOper).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MR.FrontPageOper).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  保存手术信息
/// Table：       DHCWMR.MR.FrontPageOper
/// Input：       InputStr ：手术信息="..."
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.MR.FrontPageOper).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set POType=$p(aInputStr,aSeparate,3)
	Set POIndex=+$p(aInputStr,aSeparate,4)
	Set POSerialNumber=+$p(aInputStr,aSeparate,5)
	
	Set objParref=##class(DHCWMR.MR.FrontPage).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildSub="" {
		Set obj=##class(DHCWMR.MR.FrontPageOper).%New()
	} Else {
		Set obj=##class(DHCWMR.MR.FrontPageOper).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         = objParref
	Set obj.POType         = POType
	Set obj.POIndex        = POIndex
	Set obj.POSerialNumber = POSerialNumber
	Set obj.PO0100         = $p(aInputStr,aSeparate,6)   //手术及操作
	Set obj.PO0101         = $p(aInputStr,aSeparate,7)   //手术及操作ICD10
	Set obj.PO0200         = $p(aInputStr,aSeparate,8)   //手术及操作日期
	Set obj.PO0300         = $p(aInputStr,aSeparate,9)   //手术级别
	Set obj.PO0301         = $p(aInputStr,aSeparate,10)  //手术级别编码
	Set obj.PO0400         = $p(aInputStr,aSeparate,11)  //术者
	Set obj.PO0500         = $p(aInputStr,aSeparate,12)  //Ⅰ助
	Set obj.PO0600         = $p(aInputStr,aSeparate,13)  //Ⅱ助
	Set obj.PO0700         = $p(aInputStr,aSeparate,14)  //麻醉方式
	Set obj.PO0701         = $p(aInputStr,aSeparate,15)  //麻醉方式编码
	Set obj.PO0800         = $p(aInputStr,aSeparate,16)  //切口愈合
	Set obj.PO0801         = $p(aInputStr,aSeparate,17)  //切口愈合编码
	Set obj.PO0900         = $p(aInputStr,aSeparate,18)  //麻醉医师
	Set obj.PO1000         = $p(aInputStr,aSeparate,19)  //手术及操作部位
	Set obj.PO1001         = $p(aInputStr,aSeparate,20)  //手术及操作部位编码
	Set obj.PO1100         = $p(aInputStr,aSeparate,21)  //手术持续时间
	Set obj.PO1200         = $p(aInputStr,aSeparate,22)  //麻醉分级/ASA评分
	Set obj.PO1201         = $p(aInputStr,aSeparate,23)  //麻醉分级/ASA评分编码
	Set obj.PO1300         = $p(aInputStr,aSeparate,24)  //手术患者类型
	Set obj.PO1301         = $p(aInputStr,aSeparate,25)  //手术患者类型编码
	//结束时间  update  by  shp  20151016
	Set obj.PO0201         = $p(aInputStr,aSeparate,26)  //手术患者类型编码
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
/// Description:  删除手术记录
/// Table：       DHCWMR.MR.FrontPageOper
/// Input：       Id : DHCWMR.MR.FrontPageOper.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MR.FrontPageOper).%DeleteId(aId)
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
<Value>POType</Value>
</Value>
<Value name="3">
<Value>POIndex</Value>
</Value>
<Value name="4">
<Value>POSerialNumber</Value>
</Value>
<Value name="5">
<Value>PO0100</Value>
</Value>
<Value name="6">
<Value>PO0101</Value>
</Value>
<Value name="7">
<Value>PO0200</Value>
</Value>
<Value name="8">
<Value>PO0300</Value>
</Value>
<Value name="9">
<Value>PO0301</Value>
</Value>
<Value name="10">
<Value>PO0400</Value>
</Value>
<Value name="11">
<Value>PO0500</Value>
</Value>
<Value name="12">
<Value>PO0600</Value>
</Value>
<Value name="13">
<Value>PO0700</Value>
</Value>
<Value name="14">
<Value>PO0701</Value>
</Value>
<Value name="15">
<Value>PO0800</Value>
</Value>
<Value name="16">
<Value>PO0801</Value>
</Value>
<Value name="17">
<Value>PO0900</Value>
</Value>
<Value name="18">
<Value>PO1000</Value>
</Value>
<Value name="19">
<Value>PO1001</Value>
</Value>
<Value name="20">
<Value>PO1100</Value>
</Value>
<Value name="21">
<Value>PO1200</Value>
</Value>
<Value name="22">
<Value>PO1201</Value>
</Value>
<Value name="23">
<Value>PO1300</Value>
</Value>
<Value name="24">
<Value>PO1301</Value>
</Value>
<Value name="25">
<Value>PO0201</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("OPER")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("OPER")</IdLocation>
<IndexLocation>^DHCWMR.MR.FrontPageI("OPER")</IndexLocation>
<StreamLocation>^DHCWMR.MR.FrontPageOperS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
