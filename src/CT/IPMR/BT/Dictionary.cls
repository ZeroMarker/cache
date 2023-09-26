/// 名称: CT.IPMR.BT.Dictionary
/// 描述: 基础字典表
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.BT.Dictionary Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 类型
Property BDType As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 代码
Property BDCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 描述
Property BDDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 排序码
Property BDOrderNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院ID (指向CT_Hospital 或 CT_IPMR_BT.Hospital)
Property BDHospID As %String(MAXLEN = 100, TRUNCATE = 1);

/// TextA
Property BDTextA As %String(MAXLEN = 100, TRUNCATE = 1);

/// TextB
Property BDTextB As %String(MAXLEN = 100, TRUNCATE = 1);

/// TextC
Property BDTextC As %String(MAXLEN = 100, TRUNCATE = 1);

/// TextD
Property BDTextD As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property BDIsActive As %Boolean;

/// 备注
Property BDResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 检索码
Property BDPYAlias As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexTypeCode On (BDType, BDCode, BDHospID) [ Unique ];

Index IndexTypeDesc On (BDType, BDDesc, BDHospID);

Index IndexTypeOrder On (BDType, BDOrderNo As Exact, BDHospID);

Index IndexDicType On BDType;

/// Creator：     liyi
/// CreatDate：   2022-10-12
/// Description:  根据类别和代码取字典项目ID
/// Table：       CT.IPMR.BT.Dictionary
/// Input：       aType : 字典类别
///               aCode ：字典代码
///               aHospID ：医院ID
///               aIsActive ：是否有效
/// Return：      返回ID
/// w ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("","")
ClassMethod GetIDByTypeCode(aType As %String, aCode As %String, aHospID As %String = "", aIsActive As %String = "") As %String
{
	New (aType,aCode,aHospID,aIsActive)
	Set return=""
	Quit:(aType="")||(aCode="") return
	Set xID=""
	For {
		Set xID=$o(^CT.IPMR.BT.DictionaryI("IndexTypeCode"," "_$ZCVT(aType,"U")," "_$ZCVT(aCode,"U")," "_$ZCVT(aHospID,"U"),xID))
		Quit:xID=""
		Set Str = $g(^CT.IPMR.BT.DictionaryD(xID))
		Continue:Str=""
		Set IsActive=$lg(Str,11)
		Continue:(aIsActive'="")&&(IsActive'=aIsActive)
		Set return=xID
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  根据类别和代码取字典项目
/// Table：       CT.IPMR.BT.Dictionary
/// Input：       aType : 字典类别
///               aCode ：字典代码
///               aHospID ：医院ID
///               aIsActive ：是否有效
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("","")
ClassMethod GetByTypeCode(aType As %String, aCode As %String, aHospID As %String = "", aIsActive As %String = "") As CT.IPMR.BT.Dictionary
{
	New (aType,aCode,aHospID,aIsActive)
	Set return=""
	Quit:(aType="")||(aCode="") return
	Set xID=""
	For {
		Set xID=$o(^CT.IPMR.BT.DictionaryI("IndexTypeCode"," "_$ZCVT(aType,"U")," "_$ZCVT(aCode,"U")," "_$ZCVT(aHospID,"U"),xID))
		Quit:xID=""
		Set objDic=..GetObjById(xID)
		Continue:'$IsObject(objDic)
		Set IsActive=objDic.BDIsActive
		Continue:(aIsActive'="")&&(IsActive'=aIsActive)
		Set return=objDic
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  根据类别和名称取字典项目
/// Table：       CT.IPMR.BT.Dictionary
/// Input：       aType : 字典类别
///               aDesc ：字典名称
///               aHospID ：医院ID
///               aIsActive ：是否有效
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("","")
ClassMethod GetByTypeDesc(aType As %String, aDesc As %String, aHospID As %String = "", aIsActive As %String = "") As CT.IPMR.BT.Dictionary
{
	New (aType,aDesc,aHospID,aIsActive)
	Set return=""
	Quit:(aType="")||(aDesc="") return

	Set xID=""
	For {
		Set xID=$o(^CT.IPMR.BT.DictionaryI("IndexTypeDesc"," "_$ZCVT(aType,"U")," "_$ZCVT(aDesc,"U")," "_$ZCVT(aHospID,"U"),xID))
		Quit:xID=""
		
		Set objDic=..GetObjById(xID)
		Continue:'$IsObject(objDic)
		Set IsActive=objDic.BDIsActive
		Continue:(aIsActive'="")&&(IsActive'=aIsActive)
		Set return=objDic
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  取基础字典
/// Table：       CT.IPMR.BT.Dictionary
/// Input：       Id : CT.IPMR.BT.Dictionary.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.Dictionary).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.BT.Dictionary
{
	new (aId)
	quit:'##class(CT.IPMR.BT.Dictionary).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.BT.Dictionary).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  更新基础字典
/// Table：       CT.IPMR.BT.Dictionary
/// Input：       InputStr ：字典数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.BT.Dictionary).Update("^DiaType^2^其他诊断^2^^^^^^1^备注","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID		= $p(aInputStr,aSeparate,1)
	Set Type 	= $p(aInputStr,aSeparate,2)
	Set Code 	= $p(aInputStr,aSeparate,3)
	Set Desc 	= $p(aInputStr,aSeparate,4)
	Set OrderNo	= $p(aInputStr,aSeparate,5)
	Set HospID 	= $p(aInputStr,aSeparate,6)
	Set TextA 	= $p(aInputStr,aSeparate,7)
	Set TextB 	= $p(aInputStr,aSeparate,8)
	Set TextC 	= $p(aInputStr,aSeparate,9)
	Set TextD 	= $p(aInputStr,aSeparate,10)
	Set IsActive= +$p(aInputStr,aSeparate,11)
	Set Resume 	= $p(aInputStr,aSeparate,12)
	Set PYAlias= $p(aInputStr,aSeparate,13)
	If ID="" {
		Quit:$o(^CT.IPMR.BT.DictionaryI("IndexTypeCode"," "_$ZCVT(Type,"U")," "_$ZCVT(Code,"U")," "_$ZCVT(HospID,"U"),0)) -100
	}
	
	If ID="" {
		Set obj=##class(CT.IPMR.BT.Dictionary).%New()
	}Else{
		Set obj=##class(CT.IPMR.BT.Dictionary).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BDType		= Type
	Set obj.BDCode		= Code
	Set obj.BDDesc		= Desc
	Set obj.BDOrderNo 	= OrderNo
	Set obj.BDHospID	= HospID
	Set obj.BDTextA		= TextA
	Set obj.BDTextB		= TextB
	Set obj.BDTextC		= TextC
	Set obj.BDTextD		= TextD
	Set obj.BDIsActive	= IsActive
	Set obj.BDResume	= Resume
	Set obj.BDPYAlias	= PYAlias
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

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  删除基础字典
/// Table：       CT.IPMR.BT.Dictionary
/// Input：       Id : CT.IPMR.BT.Dictionary.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.BT.Dictionary).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.BT.Dictionary).%DeleteId(aId)
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
<Value>BDType</Value>
</Value>
<Value name="3">
<Value>BDCode</Value>
</Value>
<Value name="4">
<Value>BDDesc</Value>
</Value>
<Value name="5">
<Value>BDOrderNo</Value>
</Value>
<Value name="6">
<Value>BDHospID</Value>
</Value>
<Value name="7">
<Value>BDTextA</Value>
</Value>
<Value name="8">
<Value>BDTextB</Value>
</Value>
<Value name="9">
<Value>BDTextC</Value>
</Value>
<Value name="10">
<Value>BDTextD</Value>
</Value>
<Value name="11">
<Value>BDIsActive</Value>
</Value>
<Value name="12">
<Value>BDResume</Value>
</Value>
<Value name="13">
<Value>BDPYAlias</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.BT.DictionaryD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.BT.DictionaryD</IdLocation>
<IndexLocation>^CT.IPMR.BT.DictionaryI</IndexLocation>
<StreamLocation>^CT.IPMR.BT.DictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
