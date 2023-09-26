/// 名称: DHCMA.CPW.BT.PathFormEp
/// 描述: 临床路径表单阶段
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.BT.PathFormEp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.BT.PathForm [ Cardinality = parent, Inverse = ChildEp ];

/// 表单项目
Relationship ChildItem As DHCMA.CPW.BT.PathFormItem [ Cardinality = children, Inverse = Parref ];

/// 阶段描述
Property EpDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 阶段描述2
Property EpDesc2 As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 阶段顺序号
Property EpIndNo As %Integer [ Required ];

/// 阶段天数（天）
Property EpDays As %Integer [ Required ];

/// 是否关键阶段
Property EpIsKeyStep As %Boolean;

/// 是否手术日
Property EpIsOperDay As %Boolean;

/// 是否第1天
Property EpIsFirstDay As %Boolean;

/// 是否有效
Property EpIsActive As %Boolean;

/// 处置日期
Property EpActDate As %Date;

/// 处置时间
Property EpActTime As %Time;

/// 处置人（指向DHCMA.CPW.EP.SSUser.OID）
Property EpActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 阶段OID（主要处理旧系统升级问题）
Property EpOID As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxofIndNo On (Parref, EpIndNo);

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.BT.PathFormEp
/// Input：       aId : DHCMA.CPW.BT.PathFormEp.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.PathFormEp).GetObjById("1||1")
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathFormEp
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathFormEp).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathFormEp).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  更新实体对象
/// Table：       DHCMA.CPW.BT.PathFormEp
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathFormEp).Update("^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref		 = $p(aInputStr,aSeparete,1)
	Set ChildSub     = $p(aInputStr,aSeparete,2)
	Set:ChildSub["||" ChildSub= $p(ChildSub,"||",2)
	Set EpDesc       = $p(aInputStr,aSeparete,3)
	Set EpDesc2      = $p(aInputStr,aSeparete,4)
	Set EpIndNo      = +$p(aInputStr,aSeparete,5)
	Set EpDays  	 = +$p(aInputStr,aSeparete,6)
	Set EpIsKeyStep  = +$p(aInputStr,aSeparete,7)
	Set EpIsOperDay  = +$p(aInputStr,aSeparete,8)
	Set EpIsFirstDay = +$p(aInputStr,aSeparete,9)
	Set EpIsActive   = +$p(aInputStr,aSeparete,10)
	Set EpActDate    = $p(aInputStr,aSeparete,11)
	Set EpActTime    = $p(aInputStr,aSeparete,12)
	Set EpActUserID  = $p(aInputStr,aSeparete,13)
	Set EpOID        = $p(aInputStr,aSeparete,14)
	
	Set:EpActDate'="" EpActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(EpActDate)
	Set:EpActTime[":" EpActTime = $zth(EpActTime,1)
	Set:EpActDate="" EpActDate=+$h
	Set:EpActTime="" EpActTime=+$p($h,",",2)	
	
	Quit:(Parref="")||(EpDesc="")||(EpDesc2="")||(EpIndNo=0)||(EpDays=0) -1
	Set objPathForm = ##class(DHCMA.CPW.BT.PathForm).GetObjById(Parref)
	Quit:'$Isobject(objPathForm) -1
	
	//Set tID=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",FormPathDr,FormVersion,0))
	//Quit:(tID'="")&(ID'=tID) -2
	
	If ChildSub="" {
		Set obj=##class(DHCMA.CPW.BT.PathFormEp).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCMA.CPW.BT.PathFormEp).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       = objPathForm  //对象
	Set obj.EpDesc	     = EpDesc  
	Set obj.EpDesc2  	 = EpDesc2
	Set obj.EpIndNo      = EpIndNo
	Set obj.EpDays  	 = EpDays
	Set obj.EpIsKeyStep	 = EpIsKeyStep
	Set obj.EpIsOperDay  = EpIsOperDay
	Set obj.EpIsFirstDay = EpIsFirstDay
	Set obj.EpIsActive	 = EpIsActive
	Set obj.EpActDate    = EpActDate
	Set obj.EpActTime    = EpActTime
	Set obj.EpActUserID  = EpActUserID	
	Set obj.EpOID        = EpOID
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=$p(obj.%Id(),"||",2)
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  删除对象信息
/// Table：       DHCMA.CPW.BT.PathFormEp
/// Input：       aId : DHCMA.CPW.BT.PathFormEp.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathFormEp).DeleteById("1||1")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.BT.PathFormEp).%DeleteId(aId)
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
<Data name="PathFormEpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpDesc</Value>
</Value>
<Value name="3">
<Value>EpDesc2</Value>
</Value>
<Value name="4">
<Value>EpIndNo</Value>
</Value>
<Value name="5">
<Value>EpDays</Value>
</Value>
<Value name="6">
<Value>EpIsKeyStep</Value>
</Value>
<Value name="7">
<Value>EpIsOperDay</Value>
</Value>
<Value name="8">
<Value>EpIsFirstDay</Value>
</Value>
<Value name="9">
<Value>EpIsActive</Value>
</Value>
<Value name="10">
<Value>EpActDate</Value>
</Value>
<Value name="11">
<Value>EpActTime</Value>
</Value>
<Value name="12">
<Value>EpActUserID</Value>
</Value>
<Value name="13">
<Value>EpOID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EP")</DataLocation>
<DefaultData>PathFormEpDefaultData</DefaultData>
<IdLocation>{%%PARENT}("EP")</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathFormI("EP")</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathFormEpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
