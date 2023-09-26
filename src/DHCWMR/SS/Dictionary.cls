/// 基础字典表
Class DHCWMR.SS.Dictionary Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 类型
Property SDType As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 代码
Property SDCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 描述
Property SDDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 医院指针(指向CT_Hospital)
Property SDHospID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// TextA
Property SDTextA As %String(MAXLEN = 100, TRUNCATE = 1);

/// TextB
Property SDTextB As %String(MAXLEN = 100, TRUNCATE = 1);

/// TextC
Property SDTextC As %String(MAXLEN = 100, TRUNCATE = 1);

/// TextD
Property SDTextD As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property SDIsActive As %Boolean;

/// 备注
Property SDResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexTypeCode On (SDType, SDCode, SDHospID) [ Unique ];

Index IndexTypeDesc On (SDType, SDDesc, SDHospID);

Index IndexDicType On SDType;

/// Creator：     zhufei
/// CreatDate：   2014-08-13
/// Description:  取病案基础字典
/// Table：       DHCWMR.SS.Dictionary
/// Input：       Id : DHCWMR.SS.Dictionary.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.Dictionary).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.Dictionary
{
	new (aId)
	quit:'##class(DHCWMR.SS.Dictionary).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.Dictionary).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-19
/// Description:  根据类别和代码查询字典项目
/// Table：       DHCWMR.SS.Dictionary
/// Input：       Type : 字典类别
///               Code ：字典代码
///               IsActive ：是否有效
/// Return：      返回Object
/// w ##class(DHCWMR.SS.Dictionary).GetByTypeCode("WorkType","A")
ClassMethod GetByTypeCode(aType As %String, aCode As %String, aHospID As %String = "", aIsActive As %String = "") As DHCWMR.SS.Dictionary
{
	New (aType,aCode,aHospID,aIsActive)
	Set return=""
	Quit:(aType="")||(aCode="") return
	
	Set:aHospID="" aHospID=0
	Set xID=""
	For {
		Set xID=$o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_$ZCVT(aType,"U")," "_$ZCVT(aCode,"U")," "_$ZCVT(aHospID,"U"),xID))
		Quit:xID=""
		
		Set objDic=..GetObjById(xID)
		Continue:'$IsObject(objDic)
		Set IsActive=objDic.SDIsActive
		Continue:(aIsActive'="")&&(IsActive'=aIsActive)
		
		Set return=objDic
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-29
/// Description:  根据类别和名称查询字典项目
/// Table：       DHCWMR.SS.Dictionary
/// Input：       Type : 字典类别
///               Desc ：字典名称
///               IsActive ：是否有效
/// Return：      返回Object
/// w ##class(DHCWMR.SS.Dictionary).GetByTypeDesc("FPICDType","主要诊断")
ClassMethod GetByTypeDesc(aType As %String, aDesc As %String, aHospID As %String = "", aIsActive As %String = "") As DHCWMR.SS.Dictionary
{
	New (aType,aDesc,aHospID,aIsActive)
	Set return=""
	Quit:(aType="")||(aDesc="") return
	
	Set:aHospID="" aHospID=0
	Set xID=""
	For {
		Set xID=$o(^DHCWMR.SS.DictionaryI("IndexTypeDesc"," "_$ZCVT(aType,"U")," "_$ZCVT(aDesc,"U")," "_$ZCVT(aHospID,"U"),xID))
		Quit:xID=""
		
		Set objDic=..GetObjById(xID)
		Continue:'$IsObject(objDic)
		Set IsActive=objDic.SDIsActive
		Continue:(aIsActive'="")&&(IsActive'=aIsActive)
		
		Set return=objDic
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-13
/// Description:  更新病案基础字典
/// Table：       DHCWMR.SS.Dictionary
/// Input：       InputStr ：记录信息（1ID、2键、3键描述、4值、5值描述、6医院ID、7备注）
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.SS.Dictionary).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set Type=$p(aInputStr,aSeparate,2)
	Set Code=$p(aInputStr,aSeparate,3)
	Set Desc=$p(aInputStr,aSeparate,4)
	Set HospID=+$p(aInputStr,aSeparate,5)
	
	//Set:ID="" ID=$o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_$ZCVT(Type,"U")," "_$ZCVT(Code,"U")," "_$ZCVT(HospID,"U"),0))
	Quit:(ID="")&&$o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_$ZCVT(Type,"U")," "_$ZCVT(Code,"U")," "_$ZCVT(HospID,"U"),0)) -100
	
	If ID="" {
		Set obj=##class(DHCWMR.SS.Dictionary).%New()
	}Else{
		Set obj=##class(DHCWMR.SS.Dictionary).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.SDType=Type
	Set obj.SDCode=Code
	Set obj.SDDesc=Desc
	Set obj.SDHospID=+HospID
	Set obj.SDTextA=$p(aInputStr,aSeparate,6)
	Set obj.SDTextB=$p(aInputStr,aSeparate,7)
	Set obj.SDTextC=$p(aInputStr,aSeparate,8)
	Set obj.SDTextD=$p(aInputStr,aSeparate,9)
	Set obj.SDIsActive=$p(aInputStr,aSeparate,10)
	Set obj.SDResume=$p(aInputStr,aSeparate,11)
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-13
/// Description:  删除病案基础字典
/// Table：       DHCWMR.SS.Dictionary
/// Input：       Id : DHCWMR.SS.Dictionary.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.SS.Dictionary).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.Dictionary).%DeleteId(aId)
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
<Value>SDType</Value>
</Value>
<Value name="3">
<Value>SDCode</Value>
</Value>
<Value name="4">
<Value>SDDesc</Value>
</Value>
<Value name="5">
<Value>SDHospID</Value>
</Value>
<Value name="6">
<Value>SDTextA</Value>
</Value>
<Value name="7">
<Value>SDTextB</Value>
</Value>
<Value name="8">
<Value>SDTextC</Value>
</Value>
<Value name="9">
<Value>SDTextD</Value>
</Value>
<Value name="10">
<Value>SDIsActive</Value>
</Value>
<Value name="11">
<Value>SDResume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.DictionaryD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.DictionaryD</IdLocation>
<IndexLocation>^DHCWMR.SS.DictionaryI</IndexLocation>
<StreamLocation>^DHCWMR.SS.DictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
