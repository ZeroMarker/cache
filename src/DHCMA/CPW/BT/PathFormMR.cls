/// 名称: DHCMA.CPW.BT.PathFormMR
/// 描述: 临床路径表单关联病历内容
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.BT.PathFormMR Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.BT.PathFormItem [ Cardinality = parent, Inverse = ChildMR ];

/// 病历类型
Property MRTypeDr As DHCMA.Util.BT.Dictionary [ Required ];

/// 病历模板ID（电子病历/护理病历）
Property MRTempID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 是否有效
Property MRIsActive As %Boolean;

/// 处置日期
Property MRActDate As %Date;

/// 处置时间
Property MRActTime As %Time;

/// 处置人（指向DHCMA.CPW.EP.SSUser.OID）
Property MRActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.BT.PathFormMR
/// Input：       aId : DHCMA.CPW.BT.PathFormMR.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.PathFormMR).GetObjById("1||1")
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathFormMR
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathFormMR).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathFormMR).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  更新实体对象
/// Table：       DHCMA.CPW.BT.PathFormMR
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathFormMR).Update("^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref		   = $p(aInputStr,aSeparete,1)
	Set ChildSub       = $p(aInputStr,aSeparete,2)
	Set:ChildSub["||" ChildSub =$p(ChildSub,"||",4)
	Set MRTypeDr       = $p(aInputStr,aSeparete,3)
	Set MRTempID       = $p(aInputStr,aSeparete,4)
	Set MRIsActive     = +$p(aInputStr,aSeparete,5)
	Set MRActDate      = $p(aInputStr,aSeparete,6)
	Set MRActTime      = $p(aInputStr,aSeparete,7)
	Set MRActUserID    = $p(aInputStr,aSeparete,8)
	
	Set:MRActDate'="" MRActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(MRActDate)
	Set:MRActTime[":" MRActTime = $zth(MRActTime,1)
	Set:MRActDate="" MRActDate=+$h
	Set:MRActTime="" MRActTime=+$p($h,",",2)	
	
	Quit:(Parref="")||(MRTempID="")||(MRTypeDr="") -1
	Set objPathFormItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(Parref)
	Set objMRType =##class(DHCMA.Util.BT.Dictionary).GetObjById(MRTypeDr)
	Quit:('$Isobject(objPathFormItem))||('$Isobject(objMRType)) -1
		
	If ChildSub="" {
		Set obj=##class(DHCMA.CPW.BT.PathFormMR).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCMA.CPW.BT.PathFormMR).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	
	Set obj.Parref       = objPathFormItem  //对象
	Set obj.MRTypeDr	 = objMRType  
	Set obj.MRTempID  	 = MRTempID
	Set obj.MRIsActive   = MRIsActive
	Set obj.MRActDate    = MRActDate
	Set obj.MRActTime    = MRActTime
	Set obj.MRActUserID  = MRActUserID
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
		Set:return["||" return = $p(return,"||",4) //返回childsub
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  删除对象信息
/// Table：       DHCMA.CPW.BT.PathFormMR
/// Input：       aId : DHCMA.CPW.BT.PathFormMR.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathFormItem).DeleteById("1||1")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.BT.PathFormMR).%DeleteId(aId)
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
<Data name="PathFormMRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRTypeDr</Value>
</Value>
<Value name="3">
<Value>MRTempID</Value>
</Value>
<Value name="4">
<Value>MRIsActive</Value>
</Value>
<Value name="5">
<Value>MRActDate</Value>
</Value>
<Value name="6">
<Value>MRActTime</Value>
</Value>
<Value name="7">
<Value>MRActUserID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("MR")</DataLocation>
<DefaultData>PathFormMRDefaultData</DefaultData>
<IdLocation>{%%PARENT}("MR")</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathFormI("MR")</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathFormMRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
