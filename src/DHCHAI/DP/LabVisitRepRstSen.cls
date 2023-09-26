/// 名称: DHCHAI.DP.LabVisitRepRstSen
/// 描述: 药敏结果
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.LabVisitRepRstSen Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验结果
Property LabResultDr As DHCHAI.DP.LabVisitRepResult [ Required ];

/// 抗生素代码
Property LabAntCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 抗生素名称
Property LabAntDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 药敏结果
Property LabSensitivity As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否天然耐药
Property LabIsInt As %Boolean;

/// 检验结果索引
Index IndexLabResultDr On LabResultDr;

/// 检验结果 + 抗生素代码 索引
Index IndexResultDrAntDesc On (LabResultDr, LabAntDesc As Exact);

/// 抗生素名称 索引
Index IndexAntDesc On LabAntDesc;

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取药敏结果
/// Table：       DHCHAI.DP.LabVisitRepRstSen
/// Input：       ID:    DHCHAI.DP.LabVisitRepRstSen.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitRepRstSen).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabVisitRepRstSen
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabVisitRepRstSen).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabVisitRepRstSen).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-19
/// Description:  根据抗生素代码取药敏结果
/// Table：       DHCHAI.DP.LabVisitRepRstSen
/// Input：       aResultDr:DHCHAI.DP.LabVisitRepRstSen.LabResultDr
/// 			  aAntDesc:DHCHAI.DP.LabVisitRepRstSen.LabAntDesc
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitRepRstSen).GetObjByAntDesc("124","E0009")
ClassMethod GetObjByAntDesc(aResultDr As %String, aAntDesc As %String) As DHCHAI.DP.LabVisitRepRstSen
{
	New (aResultDr,aAntDesc)
	Set return=""
	Quit:(aResultDr="")||(aAntDesc="") return
	
	Set id = $o(^DHCHAI.DP.LabVisitRepRstSenI("IndexResultDrAntDesc",aResultDr,aAntDesc,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-03-22
/// Description:  根据检验药敏结果判断细菌是否天然耐药
/// Table：       DHCHAI.DP.LabBactAntiInt
/// Input：       aResultDr:    DHCHAI.DP.LabVisitRepResult.ID
/// Input：       aAntDesc    DHCHAI.DP.LabVisitRepRstSen.LabAntDesc
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitRepRstSen).GetIsInt(1)
ClassMethod GetIsInt(aResultDr As %String, aAntDesc As %String) As %String
{
	New (aResultDr,aAntDesc)
	Set return=""
	Set IsInt = 0
	Set LabRepResultInfo=$g(^DHCHAI.DP.LabVisitRepResultD(aResultDr))
	Quit:LabRepResultInfo="" return
	Set LabResult=$lg(LabRepResultInfo,6)
	Set LabReportDr=$lg(LabRepResultInfo,2)
	Quit:(LabResult="")||(LabReportDr="") return
	Set LabReportInfo=$g(^DHCHAI.DP.LabVisitReportD(LabReportDr))
	Quit:LabReportInfo="" return
	Set SCode=$lg(LabReportInfo,14)
	Set Bacteria="",AntDesc=""    //标准细菌名称、抗生素名称
	Set objBactMap =##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,LabResult)
	If $Isobject(objBactMap) {
		If $Isobject(objBactMap.BTMapItemDr) {
			Set Bacteria =objBactMap.BTMapItemDr.BTBacDesc 
		}
	}
	Set objAntMap =##class(DHCHAI.DP.LabAntiMap).GetObjByAntDesc(SCode,aAntDesc)
	If $Isobject(objAntMap) {
		If $Isobject(objAntMap.BTMapItemDr) {
			Set AntDesc =objAntMap.BTMapItemDr.BTAntDesc 
		}
	}
	Set:Bacteria="" Bacteria=LabResult
	Set:AntDesc="" AntDesc=aAntDesc
	Quit:'$d(^CT.MA.HAI.DP.LabBactAntiIntI("IndexBactAntDesc",Bacteria,AntDesc)) return
	Set ID =$o(^CT.MA.HAI.DP.LabBactAntiIntI("IndexBactAntDesc",Bacteria,AntDesc,0)) 
    Quit:ID="" return
    Set IntInfo=$g(^CT.MA.HAI.DP.LabBactAntiIntD(ID))
    Quit:IntInfo="" return
	Set IsInt =$lg(IntInfo,6)
	Set return = IsInt
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新药敏结果
/// Table：       DHCHAI.DP.LabVisitRepRstSen
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabVisitRepRstSen).Update("^1^代码^描述^药敏结果")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set ResultDr   	= $p(InStr,aSeparete,2)
	Set AntCode   	= $p(InStr,aSeparete,3)
	Set AntDesc 	= $p(InStr,aSeparete,4)
	Set Sensitivity	= $p(InStr,aSeparete,5)
	Quit:(ResultDr="")||(AntDesc="") return
	
	//代码唯一性
	Set tID =$o(^DHCHAI.DP.LabVisitRepRstSenI("IndexResultDrAntDesc",ResultDr,AntDesc,"")) 
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResultDr)
	Quit:'$isobject(objResult) return
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabVisitRepRstSen).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabVisitRepRstSen).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set IsInt=..GetIsInt(ResultDr,AntDesc)
	
	Set obj.LabResultDr		= objResult
	Set obj.LabAntCode		= AntCode
	Set obj.LabAntDesc		= AntDesc
	Set obj.LabSensitivity	= Sensitivity
	Set obj.LabIsInt	    = IsInt
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

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除药敏结果
/// Table：       DHCHAI.DP.LabVisitRepRstSen
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.LabVisitRepRstSen).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LabResultDr</Value>
</Value>
<Value name="3">
<Value>LabAntCode</Value>
</Value>
<Value name="4">
<Value>LabAntDesc</Value>
</Value>
<Value name="5">
<Value>LabSensitivity</Value>
</Value>
<Value name="6">
<Value>LabIsInt</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabVisitRepRstSenD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabVisitRepRstSenD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabVisitRepRstSenI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabVisitRepRstSenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
