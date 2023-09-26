/// 名称: DHCHAI.DP.LabTestCode
/// 描述: 常规检验项目
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.LabTestCode Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验项目代码
Property BTTCCode As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 检验项目名称
Property BTTestCode As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 常规检验
Property BTTestSetDr As DHCHAI.DP.LabTestSet;

/// 临床意义
Property BTClDiagnos As %String(MAXLEN = 100, TRUNCATE = 1);

/// 正常参考值
Property BTRefRanges As %String(MAXLEN = 100, TRUNCATE = 1);

/// 缩写码
Property BTWCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 项目代码索引
Index IndexTCCode On BTTCCode As Exact;

/// 项目名称索引
Index IndexTestCode On BTTestCode As Exact;

/// 缩写码索引
Index IndexWCode On BTWCode As Exact;

/// Creator：     liyi
/// CreatDate：   2017-04-17
/// Description:  根据代码、名称取常规检验项目
/// Table：       DHCHAI.DP.LabTestCode
/// Input：       aTCCode :    项目代码
/// 			  aTestCode:    检验项目
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabTestCode).GetObjByCodeDesc("B0048","")
ClassMethod GetObjByCodeDesc(aTCCode As %String, aTestCode As %String) As DHCHAI.DP.LabTestCode
{
	New (aTCCode,aTestCode)
	Set return=""
	Quit:((aTCCode="")&&(aTestCode=""))||((aTCCode'="")&&(aTestCode'="")) return
	
	Set id=""
	Set:aTCCode'="" id = $o(^DHCHAI.DP.LabTestCodeI("IndexTCCode",aTCCode,0))
	Set:aTestCode'="" id = $o(^DHCHAI.DP.LabTestCodeI("IndexTestCode",aTestCode,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取常规检验项目
/// Table：       DHCHAI.DP.LabTestCode
/// Input：       ID:    DHCHAI.DP.LabTestCode.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabTestCode).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabTestCode
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabTestCode).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabTestCode).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新常规检验项目
/// Table：       DHCHAI.DP.LabTestCode
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabTestCode).Update("^检验项目代码^检验项目名称^^临床意义^正常参考值^缩写码^1","^")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set TCCode		= $p(InStr,aSeparete,2)
	Set TestCode	= $p(InStr,aSeparete,3)
	Set TestSetDr	= $p(InStr,aSeparete,4)
	Set ClDiagnos	= $p(InStr,aSeparete,5)
	Set RefRanges	= $p(InStr,aSeparete,6)
	Set WCode		= $p(InStr,aSeparete,7)
	Set IsActive	= +$p(InStr,aSeparete,8)
	Quit:(TCCode="")||(TestCode="")||(IsActive="") return
	Set TestCode = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestCode) //去掉特殊字符
	
	//项目代码唯一性
	Set tID =$o(^DHCHAI.DP.LabTestCodeI("IndexTCCode",TCCode,0)) 
	Quit:(tID'="")&(ID'=tID) -100 
	
	Set objTestSet = ##class(DHCHAI.DP.LabTestSet).GetObjById(TestSetDr)
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabTestCode).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabTestCode).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.BTTCCode	= TCCode
	Set obj.BTTestSetDr	= objTestSet
	Set obj.BTTestCode	= TestCode
	Set obj.BTClDiagnos	= ClDiagnos
	Set obj.BTRefRanges	= RefRanges
	Set obj.BTWCode		= WCode
	Set obj.BTIsActive	= IsActive

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
/// Description:  删除常规检验项目
/// Table：       DHCHAI.DP.LabTestCode
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.LabTestCode).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  导入常规检验项目
/// w ##Class(DHCHAI.DP.LabTestCode).ImportTestCode("^A0001^血常规^*白细胞^^^WBC^1","^")
ClassMethod ImportTestCode(aInStr As %String, aSeparate As %String) As %String
{
	New (aInStr,aSeparate)
	Set return = ""
	Quit:(aInStr="")||(aSeparate="") return
	
	Set TestSetDr = ""
	Set TestSet	= $p(aInStr,aSeparate,3)
	Set objTestSet = ##class(DHCHAI.DP.LabTestSet).GetObjByCodeDesc("",TestSet)
	Set:$isobject(objTestSet) TestSetDr = objTestSet.%Id()
	Set $p(aInStr,aSeparate,3) = TestSetDr 

	Set return = ..Update(aInStr,aSeparate)
	Quit return
}

Storage Default
{
<Data name="LabTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTTCCode</Value>
</Value>
<Value name="3">
<Value>BTTestCode</Value>
</Value>
<Value name="4">
<Value>BTTestSetDr</Value>
</Value>
<Value name="5">
<Value>BTClDiagnos</Value>
</Value>
<Value name="6">
<Value>BTRefRanges</Value>
</Value>
<Value name="7">
<Value>BTWCode</Value>
</Value>
<Value name="8">
<Value>BTIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabTestCodeD</DataLocation>
<DefaultData>LabTestCodeDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabTestCodeD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabTestCodeI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
