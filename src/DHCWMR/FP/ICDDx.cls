/// 诊断库(疾病+手术)
Class DHCWMR.FP.ICDDx Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildAlias As DHCWMR.FP.ICDAlias [ Cardinality = children, Inverse = Parref ];

/// 代码
Property IDCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property IDDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断库版本
Property IDVCode As DHCWMR.FP.ICDVersion;

/// ICD10
Property IDICD10 As %String(MAXLEN = 100, TRUNCATE = 1);

/// ICD9
Property IDICD9 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 肿瘤码
Property IDMCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术操作类型（1手术、2治疗性操作、3诊断性操作）
Property IDMOperType As %String(MAXLEN = 100, TRUNCATE = 1);

/// HIS诊断库指针
Property IDMRCDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// HIS手术库指针
Property IDORCDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property IDIsActive As %Boolean;

/// 备注
Property IDResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexCode On (IDVCode, IDCode);

Index IndexDesc On (IDVCode, IDDesc);

Index IndexICD10 On (IDVCode, IDICD10);

Index IndexICD9 On (IDVCode, IDICD9);

Index IndexMCode On (IDVCode, IDMCode);

Index IndexMRCDr On IDMRCDr;

Index IndexORCDr On IDORCDr;

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-27
/// Description:  取诊断库数据
/// Table：       DHCWMR.FP.ICDDx
/// Input：       ID : DHCWMR.FP.ICDDx.ID
/// Return：      返回obj
/// w ##class(DHCWMR.FP.ICDDx).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.FP.ICDDx
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.FP.ICDDx).%ExistsId(aId) return
	set obj=##Class(DHCWMR.FP.ICDDx).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-28
/// Description:  通过ICD10取对应诊断字典
/// Table：       DHCWMR.FP.ICDDx
/// Input：       ICDVer : 诊断库
///               ICD10 : 诊断编码
/// Return：      返回obj
/// w ##class(DHCWMR.FP.ICDDx).GetObjByICD10()
ClassMethod GetObjByICD10(aICDVer As %String, aICD10 As %String) As DHCWMR.FP.ICDDx
{
	new (aICDVer,aICD10)
	set return=""
	quit:(aICDVer="")||(aICD10="") return
	set xID=0
	for {
		set xID=$o(^DHCWMR.FP.ICDDxI("IndexICD10",aICDVer," "_$zcvt(aICD10,"U"),xID))
		quit:xID=""
		quit:return'=""
		set obj=..GetObjById(xID)
		continue:'$IsObject(obj)
		set return=obj
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-28
/// Description:  通过HIS诊断取对应诊断字典
/// Table：       DHCWMR.FP.ICDDx
/// Input：       MRCId : MRC_ICDDx.ID
/// Return：      返回obj
/// w ##class(DHCWMR.FP.ICDDx).GetObjByMRCDr(10139)
ClassMethod GetObjByMRCDr(aMRCDr As %String) As DHCWMR.FP.ICDDx
{
	new (aMRCDr)
	set return=""
	quit:aMRCDr="" return
	set xID=0
	for {
		set xID=$o(^DHCWMR.FP.ICDDxI("IndexMRCDr"," "_aMRCDr,xID))
		quit:xID=""
		quit:return'=""
		set obj=..GetObjById(xID)
		continue:'$IsObject(obj)
		set return=obj
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-28
/// Description:  通过HIS手术取对应手术字典
/// Table：       DHCWMR.FP.ICDDx
/// Input：       ORCId : ORC_Operation.ID
/// Return：      返回obj
/// w ##class(DHCWMR.FP.ICDDx).GetObjByORCDr()
ClassMethod GetObjByORCDr(aORCDr As %String) As DHCWMR.FP.ICDDx
{
	new (aORCDr)
	set return=""
	quit:aORCDr="" return
	set xID=0
	for {
		set xID=$o(^DHCWMR.FP.ICDDxI("IndexORCDr"," "_aORCDr,xID))
		quit:xID=""
		quit:return'=""
		set obj=..GetObjById(xID)
		continue:'$IsObject(obj)
		set return=obj
	}
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-27
/// Description:  更新诊断库
/// Table：       DHCWMR.FP.ICDDx
/// Input：       InputStr ：记录信息（1ID、2代码、3描述、4诊断库版本、5ICD10、6ICD9、7肿瘤码、8是否有效、9备注）
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.FP.ICDDx).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID        = $p(aInputStr,aSeparate,1)
	Set Code      = $p(aInputStr,aSeparate,2)
	Set Desc      = $p(aInputStr,aSeparate,3)
	Set IDVCode   = $p(aInputStr,aSeparate,4)
	Set ICD10     = $p(aInputStr,aSeparate,5)
	Set ICD9      = $p(aInputStr,aSeparate,6)
	Set IDMCode   = $p(aInputStr,aSeparate,7)
	Set IsActive  = $p(aInputStr,aSeparate,8)
	Set Resume    = $p(aInputStr,aSeparate,9)
	Set Alias     = $p(aInputStr,aSeparate,10)
	Set MRCDr     = $p(aInputStr,aSeparate,11)
	Set ORCDr     = $p(aInputStr,aSeparate,12)
	Set OperType  = $p(aInputStr,aSeparate,13)
	Quit:(Code="")||(Desc="")||(IDVCode="") return
	
	Set objICDVer = ##class(DHCWMR.FP.ICDVersion).GetObjById(IDVCode)
	Quit:'$IsObject(objICDVer) return //Modified By LiYang 2015-01-22 应该加上返回值
	
	Set:ID="" ID=$o(^DHCWMR.FP.ICDDxI("IndexCode",IDVCode," "_$zcvt(Code,"U"),0))
	
	If ID="" {
		Set obj=##class(DHCWMR.FP.ICDDx).%New()
	}Else{
		Set obj=##class(DHCWMR.FP.ICDDx).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IDCode     = Code
	Set obj.IDDesc     = Desc
	Set obj.IDVCode    = objICDVer
	Set obj.IDICD10    = ICD10
	Set obj.IDICD9     = ICD9
	Set obj.IDMCode    = IDMCode
	Set obj.IDMOperType= OperType  //增加手术操作类型（1手术、2治疗性操作、3诊断性操作）
	Set obj.IDMRCDr    = MRCDr
	Set obj.IDORCDr    = ORCDr
	Set obj.IDIsActive = IsActive
	Set obj.IDResume   = Resume
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	If Alias'="" {
		Set ParrefRowID = return
		Set InputStr = ParrefRowID_aSeparate_""_aSeparate_Alias
		Set flg = ##class(DHCWMR.FP.ICDAlias).Update(InputStr,aSeparate)
		If (+flg<1)
		Set return=-1
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-27
/// Description:  删除诊断库
/// Table：       DHCWMR.FP.ICDDx
/// Input：       Id
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.FP.ICDDx).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.FP.ICDDx).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
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
<Value>IDCode</Value>
</Value>
<Value name="3">
<Value>IDDesc</Value>
</Value>
<Value name="4">
<Value>IDVCode</Value>
</Value>
<Value name="5">
<Value>IDICD10</Value>
</Value>
<Value name="6">
<Value>IDICD9</Value>
</Value>
<Value name="7">
<Value>IDMCode</Value>
</Value>
<Value name="8">
<Value>IDIsActive</Value>
</Value>
<Value name="9">
<Value>IDResume</Value>
</Value>
<Value name="10">
<Value>IDMRCDr</Value>
</Value>
<Value name="11">
<Value>IDORCDr</Value>
</Value>
<Value name="12">
<Value>IDMOperType</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.FP.ICDDxD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.FP.ICDDxD</IdLocation>
<IndexLocation>^DHCWMR.FP.ICDDxI</IndexLocation>
<StreamLocation>^DHCWMR.FP.ICDDxS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
