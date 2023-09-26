/// 名称: DHCMA.CPW.KB.PathStage
/// 描述: 路径阶段
/// 编写者：yankai
/// 编写日期: 2022-05-12
Class DHCMA.CPW.KB.PathStage Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.KB.PathBase [ Cardinality = parent, Inverse = ChildStg ];

Relationship ChildClinItem As DHCMA.CPW.KB.PathClinItem [ Cardinality = children, Inverse = Parref ];

Relationship ChildNurItem As DHCMA.CPW.KB.PathNurItem [ Cardinality = children, Inverse = Parref ];

Relationship ChildOrdItem As DHCMA.CPW.KB.PathOrdItem [ Cardinality = children, Inverse = Parref ];

/// 阶段描述
Property PSDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 阶段描述2
Property PSDesc2 As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 阶段顺序号
Property PSIndNo As %Integer [ Required ];

/// 阶段长度
Property PSTime As %Integer;

/// 阶段时间单位（MTH:月,W:周,D:天,H:时,M:分钟,T:次）
Property PSTimeUnit As %String(DISPLAYLIST = "Month,Week,Day,Hour,Minute,Time", VALUELIST = ",MTH,W,D,H,M,T");

/// 是否关键阶段
Property PSIsKeyStep As %Boolean;

/// 是否手术日
Property PSIsOperDay As %Boolean;

/// 是否第1天
Property PSIsFirstDay As %Boolean;

/// 是否有效
Property PSIsActive As %Boolean;

Index IdxofIndNo On (Parref, PSIndNo);

/// Creator：     yankai
/// CreatDate：   2022-05-12
/// Description:  根据ID取路径阶段信息
/// Table：       DHCMA.CPW.KB.PathStage
/// Input：       aId :  DHCMA.CPW.KB.PathStage.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.KB.PathStage).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.KB.PathStage
{
	New (aId)
	Quit:'##class(DHCMA.CPW.KB.PathStage).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.KB.PathStage).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2022-05-12
/// Description:  更新路径阶段信息
/// Table：       DHCMA.CPW.KB.PathStage
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.PathStage).Update()   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aHospID As %String = "") As %String
{
	New (aInputStr,aSeparete,aHospID)
	Set return=-1
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref			= $p(aInputStr,aSeparete,1)
	Set objParref		= ##class(DHCMA.CPW.KB.PathBase).GetObjById(Parref)
	Quit:'$IsObject(objParref) -1
	Set ChildSub     	= $p(aInputStr,aSeparete,2)  
	Set Desc     		= $p(aInputStr,aSeparete,3)
	Set Desc2    		= $p(aInputStr,aSeparete,4)
	Set IndNo    		= $p(aInputStr,aSeparete,5)
	Set Time    		= $p(aInputStr,aSeparete,6)
	Set TimeUnit		= $p(aInputStr,aSeparete,7)
	Set IsKeyStep    	= $p(aInputStr,aSeparete,8)
	Set IsOperDay    	= $p(aInputStr,aSeparete,9)
	Set IsFirstDay    	= $p(aInputStr,aSeparete,10)
	Set IsActive    	= $p(aInputStr,aSeparete,11)
	if ($d(^CT.MA.CPW.KB.PathBaseI("STG","IdxofIndNo",Parref,IndNo))){
		Set ChildSub=$o(^CT.MA.CPW.KB.PathBaseI("STG","IdxofIndNo",Parref,IndNo,""),-1)
	}
	If ChildSub="" {
		Set obj=##class(DHCMA.CPW.KB.PathStage).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCMA.CPW.KB.PathStage).%OpenId(ID)
	}
	Quit:'$IsObject(obj) -2

	Set obj.Parref    		= objParref      //写入数据
	Set obj.PSDesc    		= Desc
	Set obj.PSDesc2			= Desc2
	Set obj.PSIndNo			= IndNo
	Set obj.PSTime			= Time
	Set obj.PSTimeUnit		= TimeUnit
	Set obj.PSIsKeyStep		= IsKeyStep
	Set obj.PSIsOperDay		= IsOperDay
	Set obj.PSIsFirstDay	= IsFirstDay
	Set obj.PSIsActive		= IsActive
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-3
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-05-12
/// Description:  删除路径阶段信息
/// Table：       DHCMA.CPW.KB.PathStage
/// Input：       aId : DHCMA.CPW.KB.PathStage.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.PathStage).DeleteById(1)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.KB.PathMast")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.KB.PathStage).%DeleteId(aId)
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
<Data name="PathStageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PSDesc</Value>
</Value>
<Value name="3">
<Value>PSDesc2</Value>
</Value>
<Value name="4">
<Value>PSIndNo</Value>
</Value>
<Value name="5">
<Value>PSTime</Value>
</Value>
<Value name="6">
<Value>PSIsKeyStep</Value>
</Value>
<Value name="7">
<Value>PSIsOperDay</Value>
</Value>
<Value name="8">
<Value>PSIsFirstDay</Value>
</Value>
<Value name="9">
<Value>PSIsActive</Value>
</Value>
<Value name="10">
<Value>PSTimeUnit</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("STG")</DataLocation>
<DefaultData>PathStageDefaultData</DefaultData>
<IdLocation>{%%PARENT}("STG")</IdLocation>
<IndexLocation>^CT.MA.CPW.KB.PathBaseI("STG")</IndexLocation>
<StreamLocation>^CT.MA.CPW.KB.PathStageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
