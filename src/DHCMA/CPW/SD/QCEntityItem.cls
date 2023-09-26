/// 名称: DHCMA.CPW.SD.QCEntityItem
/// 描述: 单病种质控项目
/// 编写者：fcz
/// 编写日期: 2018-09-10
Class DHCMA.CPW.SD.QCEntityItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.SD.QCEntity [ Cardinality = parent, Inverse = ChildItem ];

/// 项目校验规则
Relationship ChildValid As DHCMA.CPW.SD.QCItemValidRule [ Cardinality = children, Inverse = Parref ];

/// 质控项目代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 质控项目名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目类型
Property BTTypeDr As DHCMA.Util.BT.Dictionary;

/// 项目大类
Property BTItemCat As %String(MAXLEN = 1000);

/// 项目子类
Property BTItemSubCat As %String(MAXLEN = 1000);

/// 取值表达式
Property BTExpressDr As DHCMA.CPW.SD.QCExpress;

/// 取值参数设置
Property GetDataParam As %String(MAXLEN = 1000);

/// 质控参数设置
Property BTExpressParam As %String(MAXLEN = 1000);

/// 有效标志
Property BTIsActive As %Boolean;

/// 是否必填
Property BTIsNeeded As %Boolean;

/// 排序码
Property BTIndNo As %Integer;

/// 关联质控项目
Property BTLinkedItem As DHCMA.CPW.SD.QCEntityItem;

/// 关联质控项目触发条件
Property BTTriggerCondition As %String(MAXLEN = 5000);

/// 质控项目备注
Property BTResume As %String(MAXLEN = 5000);

/// 项目上传值类型
Property BTUpTypeDr As DHCMA.Util.BT.Dictionary;

/// 版本信息
Property BTVersion As DHCMA.CPW.SD.QCEntityVersion [ Required ];

/// 对照项目
Property BTMatchItem As DHCMA.CPW.SD.QCEntityItem;

/// 项目更新日期
Property BTFixDate As %Date;

/// 项目更新时间
Property BTFixTime As %Time;

/// 单一版本索引（作废）
Index IdxOfCode On BTCode;

/// 版本+项目代码
Index IdxOfVerCode On (BTVersion, BTCode);

/// 病种+版本+项目代码
Index IdxOfQCVerCode On (Parref, BTVersion, BTCode);

/// 病种项目描述索引（For 项目对照）
Index IdxOfPDesc On (Parref, BTDesc As Exact);

Index IdxOfCat On (Parref, BTItemCat As Exact);

Index IdxOfSubCat On (Parref, BTItemCat As Exact, BTItemSubCat As Exact);

Index IdxOfParref On Parref;

Index IdxOfLinked On BTLinkedItem;

/// w ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCEntityItem
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCEntityItem).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCEntityItem).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.QCEntityItem).GetObjByCode("Code")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set PID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfCode"," "_$zcvt(aCode,"U"),0))
	Quit:PID="" return
	Set SubID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfCode"," "_$zcvt(aCode,"U"),PID,0))
	Quit:SubID="" return
	Set return=..GetObjById(PID_"||"_SubID)
	Quit return
}

/// w ##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode("2","33","VTE-0-1-1")
ClassMethod GetObjByVerCode(aVersion As %String, aParref As %String, aCode As %String) As %String
{
	New (aVersion,aParref,aCode)
	Set return=""
	Quit:aCode="" return
	Set SubID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",aVersion," "_$zcvt(aCode,"U"),aParref,0))
	Quit:SubID="" return
	Set return=..GetObjById(aParref_"||"_SubID)
	Quit return
}

/// w ##class(DHCMA.CPW.SD.QCEntityItem).Update("4"_$c(1)_"4||14"_$c(1)_"Cap-Adult-0-2-6"_$c(1)_"入住ICU日期 (可选项)"_$c(1)_"12"_$c(1,1)_"1"_$c(1)_"15"_$c(1,1,1)_"CPDATE:this|Cap-Adult-0-2-4,CPDATE:Cap-Adult-0-2-5|this"_$c(1)_"0"_$c(1)_"基本信息 （请参照出院/住院病历首页信息填写）"_$c(1,1)_"2-相关日期时间信息"_$c(1),$c(1))
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ParrefId		 = $p(aInputStr,aSeparete,1)
	Set ID               = $p(aInputStr,aSeparete,2)	
	Set Code             = $p(aInputStr,aSeparete,3)
	Set Desc             = $p(aInputStr,aSeparete,4)
	Set TypeDr           = $p(aInputStr,aSeparete,5)	
	Set ExpressDr        = $p(aInputStr,aSeparete,6)
	Set IsActive         = $p(aInputStr,aSeparete,7)
	Set IndNo            = $p(aInputStr,aSeparete,8)
	Set LinkedItemID     = $p(aInputStr,aSeparete,9)
	Set TriggerCondition = $p(aInputStr,aSeparete,10)
	Set BTExpressParam	 = $p(aInputStr,aSeparete,11)
	Set BTIsNeeded	 	 = $p(aInputStr,aSeparete,12)
	Set ItemCat        	 = $p(aInputStr,aSeparete,13)
	Set GetDataParam     = $p(aInputStr,aSeparete,14)
	Set ItemSubCat       = $p(aInputStr,aSeparete,15)
	Set UpTypeDr		 = $p(aInputStr,aSeparete,16)
	Set Resume		 	 = $p(aInputStr,aSeparete,17)
	Set VerID		 	 = $p(aInputStr,aSeparete,18)
	Set tSubID="",tID=""
	if ($d(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",VerID," "_$zcvt(Code,"U"),ParrefId))) {
		Set tSubID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",VerID," "_$zcvt(Code,"U"),ParrefId,0))
	}
	Set:tSubID'="" tID=ParrefId_"||"_tSubID
	Quit:(tID'="")&(ID'=tID) -2                
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.QCEntityItem).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.QCEntityItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.Parref        		=##class(DHCMA.CPW.SD.QCEntity).GetObjById(ParrefId)
	Set obj.BTCode        		= Code
	Set obj.BTDesc        		= Desc
	Set obj.BTTypeDr      		= ##class(DHCMA.Util.BT.Dictionary).GetObjById(TypeDr)	
	Set obj.BTExpressDr   		= ##class(DHCMA.CPW.SD.QCExpress).GetObjById(ExpressDr)
	Set obj.BTIsActive    		= IsActive
	Set obj.BTIndNo				= IndNo
	Set obj.BTLinkedItem  		= ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(LinkedItemID)
	Set obj.BTTriggerCondition	= TriggerCondition
	Set obj.BTExpressParam		= BTExpressParam
	Set obj.BTIsNeeded			= BTIsNeeded
	Set obj.BTItemCat           = ItemCat
	Set obj.GetDataParam        = GetDataParam
	Set obj.BTItemSubCat        = ItemSubCat
	Set obj.BTUpTypeDr      	= ##class(DHCMA.Util.BT.Dictionary).GetObjById(UpTypeDr)
	Set obj.BTResume			= Resume
	Set obj.BTFixDate			= +$h
	Set obj.BTFixTime			= $p($h,",",2)	
	Set obj.BTVersion      		= ##class(DHCMA.CPW.SD.QCEntityVersion).GetObjById(VerID)
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

/// w ##class(DHCMA.CPW.SD.QCEntityItem).DeleteById(6)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.QCEntityItem).%DeleteId(aId)
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
<Data name="QCEntityItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTDesc</Value>
</Value>
<Value name="3">
<Value>BTCatDr</Value>
</Value>
<Value name="4">
<Value>BTEpisDr</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
<Value name="6">
<Value>BTIndNo</Value>
</Value>
<Value name="7">
<Value>BTExpressDr</Value>
</Value>
<Value name="8">
<Value>BTCode</Value>
</Value>
<Value name="9">
<Value>BTStageDr</Value>
</Value>
<Value name="10">
<Value>BTLinkedItem</Value>
</Value>
<Value name="11">
<Value>BTTriggerCondition</Value>
</Value>
<Value name="12">
<Value>BTResume</Value>
</Value>
<Value name="13">
<Value>BTTypeDr</Value>
</Value>
<Value name="14">
<Value>BTExpressParam</Value>
</Value>
<Value name="15">
<Value>BTIsNeeded</Value>
</Value>
<Value name="16">
<Value>BTItemCat</Value>
</Value>
<Value name="17">
<Value>GetDataParam</Value>
</Value>
<Value name="18">
<Value>BTItemSubCat</Value>
</Value>
<Value name="19">
<Value>BTUpTypeDr</Value>
</Value>
<Value name="20">
<Value>BTFixDate</Value>
</Value>
<Value name="21">
<Value>BTFixTime</Value>
</Value>
<Value name="22">
<Value>BTVersion</Value>
</Value>
<Value name="23">
<Value>BTMatchItem</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Item")</DataLocation>
<DefaultData>QCEntityItemDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Item")</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCEntityItemI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCEntityItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
