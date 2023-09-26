/// 名称: DHCMA.CPW.BT.PathFormItem
/// 描述: 临床路径表单项目
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.BT.PathFormItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.BT.PathFormEp [ Cardinality = parent, Inverse = ChildItem ];

/// 关联医嘱
Relationship ChildOrd As DHCMA.CPW.BT.PathFormOrd [ Cardinality = children, Inverse = Parref ];

/// 关联方剂
Relationship ChildTCM As DHCMA.CPW.BT.PathFormTCM [ Cardinality = children, Inverse = Parref ];

/// 关联病历
Relationship ChildMR As DHCMA.CPW.BT.PathFormMR [ Cardinality = children, Inverse = Parref ];

/// 项目描述
Property ItemDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目分类
Property ItemCatDr As DHCMA.CPW.BT.PathItemCat [ Required ];

/// 项目顺序号
Property ItemIndNo As %Integer;

/// 是否可选项
Property ItemIsOption As %Boolean;

/// 是否有效
Property ItemIsActive As %Boolean;

/// 处置日期
Property ItemActDate As %Date;

/// 处置时间
Property ItemActTime As %Time;

/// 处置人（指向DHCMA.CPW.EP.SSUser.OID）
Property ItemActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 项目OID（主要处理旧系统升级问题）
Property ItemOID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 执行提示
Property ExeDesc As %String;

/// 对项目类别和顺序号设置索引
Index IdxofCatDrIndNo On (Parref, ItemCatDr, ItemIndNo);

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.BT.PathFormItem
/// Input：       aId : DHCMA.CPW.BT.PathFormItem.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.PathFormItem).GetObjById("1||1")
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathFormEp
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathFormItem).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathFormItem).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  更新实体对象
/// Table：       DHCMA.CPW.BT.PathFormItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathFormItem).Update("^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	
	Set Parref		   = $p(aInputStr,aSeparete,1)
	Set ChildSub       = $p(aInputStr,aSeparete,2)
	Set:ChildSub["||" ChildSub= $p(ChildSub,"||",3)
	Set ItemDesc       = $p(aInputStr,aSeparete,3)
	Set ItemCatDr      = $p(aInputStr,aSeparete,4)
	Set ItemIndNo      = +$p(aInputStr,aSeparete,5)
	Set ItemIsOption   = +$p(aInputStr,aSeparete,6)
	Set ItemIsActive   = +$p(aInputStr,aSeparete,7)
	Set ItemActDate    = $p(aInputStr,aSeparete,8)
	Set ItemActTime    = $p(aInputStr,aSeparete,9)
	Set ItemActUserID  = $p(aInputStr,aSeparete,10)
	Set ItemOID        = $p(aInputStr,aSeparete,11)
	Set ExeDesc        = $p(aInputStr,aSeparete,12)
	Set:ItemActDate'="" ItemActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(ItemActDate)
	Set:ItemActTime[":" ItemActTime = $zth(ItemActTime,1)
	Set:ItemActDate="" ItemActDate=+$h
	Set:ItemActTime="" ItemActTime=+$p($h,",",2)	
	
	Quit:(Parref="")||(ItemDesc="")||(ItemCatDr="") -1
	Set objPathFormEp = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(Parref)
	Set objItemCat = ##class(DHCMA.CPW.BT.PathItemCat).GetObjById(ItemCatDr)
	Quit:('$Isobject(objPathFormEp))||('$Isobject(objItemCat)) -1
	
	//Set tID=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",FormPathDr,FormVersion,0))
	//Quit:(tID'="")&(ID'=tID) -2
	
	If ChildSub="" {
		Set obj=##class(DHCMA.CPW.BT.PathFormItem).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCMA.CPW.BT.PathFormItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	
	Set obj.Parref       = objPathFormEp  //对象
	Set obj.ItemDesc	 = ItemDesc  
	Set obj.ItemCatDr  	 = objItemCat
	Set obj.ItemIndNo    = ItemIndNo
	Set obj.ItemIsOption = ItemIsOption
	Set obj.ItemIsActive = ItemIsActive
	Set obj.ItemActDate  = ItemActDate
	Set obj.ItemActTime  = ItemActTime
	Set obj.ItemActUserID= ItemActUserID	
	Set obj.ItemOID      = ItemOID
	Set obj.ExeDesc      = ExeDesc
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
		Set return=$p(return,"||",3)
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  删除对象信息
/// Table：       DHCMA.CPW.BT.PathFormItem
/// Input：       aId : DHCMA.CPW.BT.PathFormItem.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathFormItem).DeleteById("1||1")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.BT.PathFormItem).%DeleteId(aId)
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
<Data name="PathFormItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemDesc</Value>
</Value>
<Value name="3">
<Value>ItemCatDr</Value>
</Value>
<Value name="4">
<Value>ItemIndNo</Value>
</Value>
<Value name="5">
<Value>ItemIsOption</Value>
</Value>
<Value name="6">
<Value>ItemIsActive</Value>
</Value>
<Value name="7">
<Value>ItemActDate</Value>
</Value>
<Value name="8">
<Value>ItemActTime</Value>
</Value>
<Value name="9">
<Value>ItemActUserID</Value>
</Value>
<Value name="10">
<Value>ItemOID</Value>
</Value>
<Value name="11">
<Value>ExeDesc</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ITM")</DataLocation>
<DefaultData>PathFormItemDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ITM")</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathFormI("ITM")</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathFormItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
