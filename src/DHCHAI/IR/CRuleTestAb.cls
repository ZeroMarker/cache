/// 名称: DHCHAI.IR.CRuleTestAb
/// 描述: 常规检验规则维护
/// 编写者：zhufei
/// 编写日期: 2017-03-15
Class DHCHAI.IR.CRuleTestAb Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验项目
Relationship ChildTC As DHCHAI.IR.CRuleTestCode [ Cardinality = children, Inverse = Parref ];

/// 标本
Relationship ChildTSP As DHCHAI.IR.CRuleTestSpec [ Cardinality = children, Inverse = Parref ];

/// 检验结果
Relationship ChildTR As DHCHAI.IR.CRuleTestResult [ Cardinality = children, Inverse = Parref ];

/// 异常标志
Relationship ChildTRF As DHCHAI.IR.CRuleTestAbFlag [ Cardinality = children, Inverse = Parref ];

/// 常规检验医嘱
Property BTTestSet As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 常规检验项目
Property BTTestCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 筛查标志（检验项目）
Property BTIsActive As %Boolean;

/// 筛查标志（标本）
Property BTTSPFlag As %Boolean;

/// 比较标志（异常标志）
Property BTTRFFlag As %Boolean;

/// 比较标志（检验结果 列表）
Property BTTRFlag As %Boolean;

/// 比较上限（检验结果 数值）
Property BTTRVMaxFlag As %Boolean;

/// 比较上限（男）
Property BTMaxValM As %Float;

/// 比较上限（女）
Property BTMaxValF As %Float;

/// 比较下限（检验结果 数值）
Property BTTRVMinFlag As %Boolean;

/// 比较下限（男）
Property BTMinValM As %Float;

/// 比较下限（女）
Property BTMinValF As %Float;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUser As DHCHAI.BT.SysUser;

Index IndexTestSetCode On (BTTestSet As Exact, BTTestCode As Exact);

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  根据ID取常规检验项目维护信息
/// Table：       DHCHAI.IR.CRuleTestAb
/// Input：       aId : DHCHAI.IR.CRuleTestAb.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleTestAb).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleTestAb
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleTestAb).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleTestAb).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  更新常规检验项目维护信息
/// Table：       DHCHAI.IR.CRuleTestAb
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1 RowId 2 CIDr 3 CIItemDr 4 CISpecList(ID#ID) 5 CIKeyWords 6 CIMaxObs 7 CIMinObs
/// w ##class(DHCHAI.IR.CRuleTestAb).Update("^1^1^1^1^2017-01-16^11:33^1^处置意见^1^2017-01-17^11:43^1^反馈意见","^,#")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	 
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE	
	Set ID		   = $p(InStr,aSeparete,1)
	Set TestSet    = $p(InStr,aSeparete,2)
	Set TestCode   = $p(InStr,aSeparete,3)
	Set IsActive   = $p(InStr,aSeparete,4)
	Set TSPFlag    = $p(InStr,aSeparete,5)
	Set TRFFlag    = $p(InStr,aSeparete,6)
	Set TRFlag     = $p(InStr,aSeparete,7)
	Set TRVMaxFlag = $p(InStr,aSeparete,8)
	Set MaxValM	   = $p(InStr,aSeparete,9)
	Set MaxValF	   = $p(InStr,aSeparete,10)
	Set TRVMinFlag = $p(InStr,aSeparete,11)
	Set MinValM    = $p(InStr,aSeparete,12)
	Set MinValF    = $p(InStr,aSeparete,13)
	
	Quit:(TestSet="")||(TestCode="") return
	Set TestSet = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSet) //去掉特殊字符
	Set TestCode = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestCode)
	
	//常规检验项目代码唯一性
	Set tID =$o(^DHCHAI.IR.CRuleTestAbI("IndexTestSetCode",TestSet,TestCode,0)) 
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.CRuleTestAb).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleTestAb).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTTestSet    = TestSet
	Set obj.BTTestCode   = TestCode
	Set obj.BTIsActive   = IsActive  
	Set obj.BTTSPFlag    = TSPFlag 
	Set obj.BTTRFFlag    = TRFFlag 
	Set obj.BTTRFlag     = TRFlag  
	Set obj.BTTRVMaxFlag = TRVMaxFlag
	Set obj.BTMaxValM	 = MaxValM
	Set obj.BTMaxValF	 = MaxValF
	Set obj.BTTRVMinFlag = TRVMinFlag
	Set obj.BTMinValM    = MinValM 
	Set obj.BTMinValF    = MinValF 
	
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
/// CreatDate：   2017-03-15
/// Description:  删除常规检验项目维护信息
/// Table：       DHCHAI.IR.CRuleTestAb
/// Input：       aId : DHCHAI.IR.CRuleTestAb.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleTestAb).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleTestAb).%DeleteId(aId)
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
<Data name="CRuleTestAbDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTTestSet</Value>
</Value>
<Value name="3">
<Value>BTTestCode</Value>
</Value>
<Value name="4">
<Value>BTIsActive</Value>
</Value>
<Value name="5">
<Value>BTTSPFlag</Value>
</Value>
<Value name="6">
<Value>BTTRFFlag</Value>
</Value>
<Value name="7">
<Value>BTTRFlag</Value>
</Value>
<Value name="8">
<Value>BTTRVMaxFlag</Value>
</Value>
<Value name="9">
<Value>BTMaxValM</Value>
</Value>
<Value name="10">
<Value>BTMaxValF</Value>
</Value>
<Value name="11">
<Value>BTTRVMinFlag</Value>
</Value>
<Value name="12">
<Value>BTMinValM</Value>
</Value>
<Value name="13">
<Value>BTMinValF</Value>
</Value>
<Value name="14">
<Value>BTActDate</Value>
</Value>
<Value name="15">
<Value>BTActTime</Value>
</Value>
<Value name="16">
<Value>BTActUser</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CRuleTestAbD</DataLocation>
<DefaultData>CRuleTestAbDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CRuleTestAbD</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleTestAbI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleTestAbS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
