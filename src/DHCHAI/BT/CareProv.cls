/// 名称: DHCHAI.BT.CareProv
/// 描述: 医护人员表
/// 编写者：zhufei
/// 编写日期: 2018-01-22
Class DHCHAI.BT.CareProv Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 工号
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 医护类型（D医生、N护士）
Property BTTypeDr As DHCHAI.BT.Dictionary;

/// 记录索引码（HIS中医护人员ID）
Property BTXCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 记录索引码索引
Index IndexXCode On BTXCode As Exact;

/// Creator：     zhufei
/// CreatDate：   2018-01-22
/// Description:  根据XCode取医护人员
/// Table：       DHCHAI.BT.CareProv
/// Input：       aSCode : DHCHAI.BT.CareProv.BTSCode
///               aXCode : DHCHAI.BT.CareProv.BTXCode
/// Return：      返回obj
/// w ##class(DHCHAI.BT.CareProv).GetObjByXCode("HIS01",1)
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.BT.CareProv
{
	New (aSCode,aXCode)
	Set return = ""
	Quit:(aSCode="")||(aXCode="") return
	
	Set aSCode=$zcvt(aSCode,"U")
	Set aXCode=$zcvt(aXCode,"U")
	Set ID=$o(^DHCHAI.BT.CareProvI("IndexXCode",aSCode_"||"_aXCode,0))
	Set:ID'="" return=##class(DHCHAI.BT.CareProv).GetObjById(ID)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-01-22
/// Description:  根据ID取医护人员信息
/// Table：       DHCHAI.BT.CareProv
/// Input：       aId : DHCHAI.BT.Location.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.CareProv).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.CareProv
{
	New (aId)
	Quit:'##class(DHCHAI.BT.CareProv).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.CareProv).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-01-22
/// Description:  更新用户信息
/// Table：       DHCHAI.BT.CareProv
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.CareProv).Update("^med^med manager^^HIS01||1")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID	   		= $p(aInputStr,aSeparete,1)
	Set Code	    = $p(aInputStr,aSeparete,2)
	Set Desc	    = $p(aInputStr,aSeparete,3)
	Set TypeDr	    = $p(aInputStr,aSeparete,4)
	Set XCode		= $p(aInputStr,aSeparete,5)
	Quit:(Code="")||(Desc="")||(XCode="") return
	
	Set Code=$zcvt(Code,"U")
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set XCode=$zcvt(XCode,"U")
	Set tID=$o(^DHCHAI.BT.CareProvI("IndexXCode",XCode,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set objType=##class(DHCHAI.BT.Dictionary).GetObjById(TypeDr)
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.CareProv).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.CareProv).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.BTCode	    = Code
	Set obj.BTDesc	    = Desc
	Set obj.BTTypeDr	= objType
	Set obj.BTXCode		= XCode
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-01-22
/// Description:  删除医护人员信息
/// Table：       DHCHAI.BT.CareProv
/// Input：       aId : DHCHAI.BT.CareProv.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.CareProv).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.BT.CareProv).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="CareProvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTTypeDr</Value>
</Value>
<Value name="5">
<Value>BTXCode</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.CareProvD</DataLocation>
<DefaultData>CareProvDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.CareProvD</IdLocation>
<IndexLocation>^DHCHAI.BT.CareProvI</IndexLocation>
<StreamLocation>^DHCHAI.BT.CareProvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
