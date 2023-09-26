/// 名称: DHCHAI.IR.EnviHyObject
/// 描述: 环境卫生学监测对象
/// 编写者：liyi
/// 编写日期: 2018-01-15
Class DHCHAI.IR.EnviHyObject Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 对象名称（全名，可注明几类环境，特定科室）
Property EHObjDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 对象别名（科室申请，别名不为空，以别名显示）
Property EHObjDesc2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 对象特指科室
Property EHLocationDr As DHCHAI.BT.Location;

/// 标本类型
Property EHSpecimenTypeDr As DHCHAI.BT.Dictionary [ Required ];

/// 是否有效
Property EHIsActive As %Boolean [ Required ];

/// [新增]更新日期
Property EHActDate As %Date;

/// [新增]更新时间
Property EHActTime As %Time;

/// [新增]更新人
Property EHActUserDr As DHCHAI.BT.SysUser;

/// [新增]支持多院区
Property EHHospDr As DHCHAI.BT.Hospital;

/// 对象名称 索引
Index IndexOnObjDesc On EHObjDesc As Exact;

/// 标本类型 索引
Index IndexOnSpecimenType On EHSpecimenTypeDr As Exact;

/// 院区+对象名称 索引
Index IdxHospDrObjDesc On (EHHospDr, EHObjDesc) [ Unique ];

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  根据ID取监测对象
/// Table：       DHCHAI.IR.EnviHyObject
/// Input：       id:    DHCHAI.IR.EnviHyObject.ID
/// Return：      返回Object
/// w ##class(DHCHAI.IR.EnviHyObject).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.IR.EnviHyObject
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.IR.EnviHyObject).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.IR.EnviHyObject).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  更新监测对象
/// Table：       DHCHAI.IR.EnviHyObject
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.EnviHyObject).Update("1^空气^空气^1^^8")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set $ZT="UpdateErr"
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID				= $p(InStr,aSeparete,1)
	Set ObjDesc			= $p(InStr,aSeparete,2)
	Set SpecimenTypeDesc= $p(InStr,aSeparete,3)
	Set IsActive		= +$p(InStr,aSeparete,4)
	Set HospID			= +$p(InStr,aSeparete,5)	
	Set ActUserDr		= +$p(InStr,aSeparete,6)
	Set ObjDesc2		= $p(InStr,aSeparete,7)
	Set LocationDr		= +$p(InStr,aSeparete,8)
	Quit:(ObjDesc="")||(SpecimenTypeDesc="")||(IsActive="") return
	
	Set objSpecType = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("EHSpenType",SpecimenTypeDesc)
	Quit:'$IsObject(objSpecType) return
	//关联院区处理
	Set HospDr=""
	if (+HospID'=0) {
		Set HospDr=##class(DHCHAI.BT.Hospital).GetObjById(HospID)
		Quit:'$IsObject(HospDr) return
	}
	Set ActUserDr = ##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocationDr)
	
	// 医院+项目名称索引码 唯一性(这里允许医院为空，为空则对所有医院生效；反之则只对关联医院生效)
	Set tID =..GetExsitID(ObjDesc,HospDr)
	Quit:(tID'="")&(ID'=tID) -100 
	if ID="" {
		Set obj=##class(DHCHAI.IR.EnviHyObject).%New()
	}else{
		Set obj=##class(DHCHAI.IR.EnviHyObject).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EHObjDesc			= ObjDesc
	Set obj.EHObjDesc2			= ObjDesc2
	Set obj.EHLocationDr        = objLoc
	Set obj.EHSpecimenTypeDr	= objSpecType
	Set obj.EHIsActive			= IsActive
	Set obj.EHHospDr			= HospDr
	Set obj.EHActDate			= +$h
	Set obj.EHActTime			= $p($h,",",2)
	Set obj.EHActUserDr			= ActUserDr	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
UpdateErr
	Write "Error:"_$ZERROR,!
 	Quit -1
}

/// w ##class(DHCHAI.IR.EnviHyObject).GetExsitID("诊疗工作台面","")
ClassMethod GetExsitID(ObjDesc, HospDr) As %String
{
	New (ObjDesc,HospDr)
	Set HospID="",return=""
	Set:$Isobject(HospDr) HospID=HospDr.%Id()
	if (HospID'=""){
		Set return=$o(^DHCHAI.IR.EnviHyObjectI("IdxHospDrObjDesc",HospID," "_ObjDesc,0))
	}else{
		Set xID=""
		for {
			Set xID=$o(^DHCHAI.IR.EnviHyObjectI("IndexOnObjDesc",ObjDesc,xID)) 
			Quit:(xID="")||(return'="")
			Set ItemObj=##class(DHCHAI.IR.EnviHyObject).GetObjById(xID)
			continue:'$IsObject(ItemObj)
			Set xHospID=""
			Set:$IsObject(ItemObj.EHHospDr) xHospID=ItemObj.EHHospDr.%Id()
			Set:(HospID=xHospID) return=xID
		}
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  删除监测对象
/// Table：       DHCHAI.IR.EnviHyObject
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.IR.EnviHyObject).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     zhangdc
/// CreatDate：   2019-09-18
/// Description:  根据对象名称取监测对象
/// Table：       DHCHAI.IR.EnviHyObject
/// Input：       
/// Return：      返回Object
/// w ##class(DHCHAI.IR.EnviHyObject).GetObjByDesc("")
ClassMethod GetObjByDesc(Desc As %String) As DHCHAI.IR.EnviHyObject
{
	New (Desc)
	Set return=""
	Quit:Desc="" return
	
	Set ID=$o(^DHCHAI.IR.EnviHyObjectI("IndexOnObjDesc",Desc,0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

Storage Default
{
<Data name="EnviHyObjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EHObjDesc</Value>
</Value>
<Value name="3">
<Value>EHSpecimenTypeDr</Value>
</Value>
<Value name="4">
<Value>EHIsActive</Value>
</Value>
<Value name="5">
<Value>EHActDate</Value>
</Value>
<Value name="6">
<Value>EHActTime</Value>
</Value>
<Value name="7">
<Value>EHActUserDr</Value>
</Value>
<Value name="8">
<Value>EHHospDr</Value>
</Value>
<Value name="9">
<Value>EHObjDesc2</Value>
</Value>
<Value name="10">
<Value>EHLocationDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.EnviHyObjectD</DataLocation>
<DefaultData>EnviHyObjectDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.EnviHyObjectD</IdLocation>
<IndexLocation>^DHCHAI.IR.EnviHyObjectI</IndexLocation>
<StreamLocation>^DHCHAI.IR.EnviHyObjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
