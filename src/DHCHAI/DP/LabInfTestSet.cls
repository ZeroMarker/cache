/// 名称: DHCHAI.DP.LabInfTestSet
/// 描述: 院感检验医嘱定义
/// 编写者：zhufei
/// 编写日期: 2020-01-16
Class DHCHAI.DP.LabInfTestSet Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 外部码
Relationship ChildExt As DHCHAI.DP.LabInfTestSetExt [ Cardinality = children, Inverse = Parref ];

/// 代码
Property BTTSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTTSDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 业务类型（1环境卫生学、2职业暴露）
Property BTLabType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

Index IdxofCode On BTTSCode As Exact;

Index IdxofDesc On BTTSDesc As Exact;

Index IdxofType On BTLabType As Exact;

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  根据ID取院感检验医嘱定义信息
/// Table：       DHCHAI.DP.LabInfTestSet
/// Input：       aId : DHCHAI.DP.LabInfTestSet.ID
/// Return：      返回obj
/// w ##class(DHCHAI.DP.LabInfTestSet).GetObjById("8")
ClassMethod GetObjById(aId As %String) As DHCHAI.DP.LabInfTestSet
{
	New (aId)
	Quit:'##class(DHCHAI.DP.LabInfTestSet).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.DP.LabInfTestSet).%OpenId(aId)
	
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  根据代码取院感检验医嘱定义信息
/// Table：       DHCHAI.DP.LabInfTestSet
/// Input：       aCode : DHCHAI.DP.LabInfTestSet.BTCode
/// Return：      返回obj
/// w ##class(DHCHAI.DP.LabInfTestSet).GetObjByCode("01")
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.DP.LabInfTestSet
{
	New (aCode)
	Quit:(aCode="") ""
	Set ID=$o(^DHCHAI.DP.LabInfTestSetI("IdxofCode",aCode,0))
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  更新院感检验医嘱定义信息
/// Table：       DHCHAI.DP.LabInfTestSet
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabInfTestSet).Update("^01^乙肝标志物五项定量^1","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set LabType  = $p(aInputStr,aSeparete,4)
	Set IsActive = $p(aInputStr,aSeparete,5)
	Quit:(Code="")||(Desc="") return
	
	Set tID=$o(^DHCHAI.DP.LabInfTestSetI("IdxofCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.DP.LabInfTestSet).%New()
	}Else{
		Set obj=##class(DHCHAI.DP.LabInfTestSet).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTTSCode   = Code
	Set obj.BTTSDesc   = Desc
	Set obj.BTLabType  = LabType
	Set obj.BTIsActive = IsActive
	
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

/// Creator：     zhoubo
/// CreatDate：   2022-06-14
/// Description:  导入外部码字典
/// w ##Class(DHCHAI.DP.LabInfTestSet).ImportDic("^3^dfdf^1^1^WWWWW","^")
ClassMethod ImportDic(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return

	Set Code      = $p(aInputStr,aSeparate,2)
	Set Desc      = $p(aInputStr,aSeparate,3)
	Set LabType   = $p(aInputStr,aSeparate,4)
	Set IsActive  = +$p(aInputStr,aSeparate,5)
	Set ExtCode   = $p(aInputStr,aSeparate,6)
	Quit:(Code="")||(Desc="") return
	Set ID=$o(^DHCHAI.DP.LabInfTestSetI("IdxofCode",Code,0))
	
	Set InputStr=ID_"^"_Code_"^"_Desc_"^"_LabType_"^"_IsActive
	Set InfTestID=##Class(DHCHAI.DP.LabInfTestSet).Update(InputStr,"^")
	If (InfTestID>0){
		Set tChildSub=$o(^DHCHAI.DP.LabInfTestSetExtI("IdxofParCode",InfTestID,ExtCode,0))
		Set InputStr=InfTestID_"^"_tChildSub_"^"_ExtCode_"^^^"
		Set InfTestExtID=##Class(DHCHAI.DP.LabInfTestSetExt).Update(InputStr,"^")
	}
	Set return=InfTestID
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  删除院感检验医嘱定义信息
/// Table：       DHCHAI.DP.LabInfTestSet
/// Input：       aId : DHCHAI.DP.LabInfTestSet.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabInfTestSet).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.DP.LabInfTestSet).%DeleteId(aId)
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
<Data name="LabInfTestSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTTSCode</Value>
</Value>
<Value name="3">
<Value>BTTSDesc</Value>
</Value>
<Value name="4">
<Value>BTIsActive</Value>
</Value>
<Value name="5">
<Value>BTLabType</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabInfTestSetD</DataLocation>
<DefaultData>LabInfTestSetDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabInfTestSetD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabInfTestSetI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabInfTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
