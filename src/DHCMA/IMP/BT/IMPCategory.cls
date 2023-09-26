/// 名称: DHCMA.IMP.BT.IMPCategory
/// 描述: 重点患者分类
/// 编写者：fcz
/// 编写日期: 2020-5-15
Class DHCMA.IMP.BT.IMPCategory Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 判断规则
Relationship ChildRules As DHCMA.IMP.BT.IMPCateRules [ Cardinality = children, Inverse = Parref ];

/// 筛查关键词
Relationship ChildKeys As DHCMA.IMP.BT.IMPCateKeys [ Cardinality = children, Inverse = Parref ];

/// 关联特因
Relationship ChildReason As DHCMA.IMP.BT.IMPCateReason [ Cardinality = children, Inverse = Parref ];

/// 分类代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 分类描述
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 分类标签
Property BTCateFlag As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property BTIsActive As %Boolean;

/// 是否终结
Property BTIsEnd As %Boolean;

/// 是否操作
Property BTIsOper As %Boolean;

/// 是否允许手动标记
Property BTIsManMark As %Boolean;

/// 是否允许重复标记
Property BTIsReMark As %Boolean;

/// 操作日期
Property BTActDate As %Date;

/// 操作时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 索引
Index IdxOfCode On BTCode;

/// Creator：     zhangdc
/// CreatDate：   2020-05-18
/// Description:  根据ID取重点患者分类信息
/// Table：       DHCMA.IMP.BT.IMPCategory
/// Input：       aId : DHCMA.IMP.BT.IMPCategory.ID
/// Return：      返回obj
/// w ##class(DHCMA.IMP.BT.IMPCategory).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.BT.IMPCategory
{
	New (aId)
	Quit:'##class(DHCMA.IMP.BT.IMPCategory).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.BT.IMPCategory).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhangdc
/// CreatDate：   2020-05-18
/// Description:  根据Code取重点患者分类信息
/// Table：       DHCMA.IMP.BT.IMPCategory
/// Input：       aCode : DHCMA.IMP.BT.IMPCategory.BTCode
/// Return：      返回String
/// w ##class(DHCMA.IMP.BT.IMPCategory).GetObjByCode("11")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^CT.MA.IMP.BTIMPCategoryI("IdxOfCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-05-18
/// Description:  更新重点患者分类信息
/// Table：       DHCMA.IMP.BT.IMPCategory
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.IMPCategory).Update("1^01^VIP病例^VIP.png^1^0^0^1^0")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"
	Set ID                    = $p(aInputStr,aSeparete,1)
	Set Code                  = $p(aInputStr,aSeparete,2)
	Set Desc                  = $p(aInputStr,aSeparete,3)
	Set Flag                  = $p(aInputStr,aSeparete,4)
	Set IsActive              = +$p(aInputStr,aSeparete,5)
	Set IsEnd                 = +$p(aInputStr,aSeparete,6)
	Set IsOper                = +$p(aInputStr,aSeparete,7)
	Set IsManMark             = +$p(aInputStr,aSeparete,8)
	Set IsReMark              = +$p(aInputStr,aSeparete,9)
	Set BTActDate             = $p(aInputStr,aSeparete,10)
	Set BTActTime             = $p(aInputStr,aSeparete,11)
	Set BTActUserID           = $p(aInputStr,aSeparete,12)
	
	
	Set:BTActDate'="" BTActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(BTActDate)
	Set:BTActTime[":" BTActTime = $zth(BTActTime,1)
	Set:BTActDate="" BTActDate=+$h
	Set:BTActTime="" BTActTime=$p($h,",",2)
	
	Quit:(Code="")||(Desc="") -1
	Set tID=$o(^CT.MA.IMP.BTIMPCategoryI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2  
	
	If ID="" {
		Set obj=##class(DHCMA.IMP.BT.IMPCategory).%New()
	}Else{
		Set obj=##class(DHCMA.IMP.BT.IMPCategory).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode             = Code
	Set obj.BTDesc             = Desc
	Set obj.BTCateFlag         = Flag
	Set obj.BTIsActive         = IsActive
	Set obj.BTActDate          = BTActDate
	Set obj.BTActTime          = BTActTime
	Set obj.BTActUserID        = BTActUserID
	Set obj.BTIsEnd            = IsEnd
	Set obj.BTIsOper           = IsOper
	Set obj.BTIsManMark        = IsManMark
	Set obj.BTIsReMark         = IsReMark
	
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

/// Creator：     zhangdc
/// CreatDate：   2020-05-18
/// Description:  删除重点患者分类信息
/// Table：       DHCMA.IMP.BT.IMPCategory
/// Input：       aId : DHCMA.IMP.BT.IMPCategory.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.IMPCategory).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.BT.IMPCategory).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-08
/// Description:  根据描述取重点患者分类
/// Table：       DHCMA.IMP.BT.IMPCategory
/// w ##class(DHCMA.IMP.BT.IMPCategory).GetObjByDesc("危重病例")
ClassMethod GetObjByDesc(aAlias) As DHCMA.IMP.BT.IMPCategory
{
	new (aAlias)
 	Set xRowID=0,return=""
 	For
 	{
	 	Set xRowID        = $o(^CT.MA.IMP.BTIMPCategoryD(xRowID))
	 	Quit:(xRowID="")||(return'="")
	 	Set objCategory   = ##class(DHCMA.IMP.BT.IMPCategory).GetObjById(xRowID)
	 	Set Code          = objCategory.BTCode
	 	Set Desc          = objCategory.BTDesc
	 	Set:Desc[aAlias return=objCategory
 	}
 	Quit return
}

Storage Default
{
<Data name="DefaultData">
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
<Value>BTCateFlag</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
<Value name="6">
<Value>BTActDate</Value>
</Value>
<Value name="7">
<Value>BTActTime</Value>
</Value>
<Value name="8">
<Value>BTActUserID</Value>
</Value>
<Value name="9">
<Value>BTIsEnd</Value>
</Value>
<Value name="10">
<Value>BTIsOper</Value>
</Value>
<Value name="11">
<Value>BTIsManMark</Value>
</Value>
<Value name="12">
<Value>BTIsReMark</Value>
</Value>
</Data>
<DataLocation>^CT.MA.IMP.BTIMPCategoryD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.MA.IMP.BTIMPCategoryD</IdLocation>
<IndexLocation>^CT.MA.IMP.BTIMPCategoryI</IndexLocation>
<StreamLocation>^CT.MA.IMP.BTIMPCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
