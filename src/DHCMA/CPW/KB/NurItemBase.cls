/// 名称: DHCMA.CPW.KB.NurItemBase
/// 描述: 知识库-护理项目库（公有数据）
/// 编写者：yankai
/// 编写日期: 2022-05-12
Class DHCMA.CPW.KB.NurItemBase Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 项目描述
Property NIDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 项目别名
Property NIAlias As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 关联护理内容代码（多值逗号分隔）
Property NINURCode As %String;

/// 分类（备用）
Property NICategory As %String;

/// 项目执行判断公式（备用）
Property NIExeFun As %String;

/// 是否启用
Property NIIsActive As %String;

/// 操作日期
Property NIActDate As %Date;

/// 操作时间
Property NIActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property NIActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 对描述建立索引
Index IdxofDesc On (NIIsActive As Exact, NIDesc As AlphaUp);

/// Creator：     yankai
/// CreatDate：   2022-05-13
/// Description:  根据ID取护理项目库记录
/// Table：       DHCMA.CPW.KB.NurItemBase
/// Input：       aId :  DHCMA.CPW.KB.NurItemBase.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.KB.NurItemBase).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.KB.NurItemBase
{
	New (aId)
	Quit:'##class(DHCMA.CPW.KB.NurItemBase).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.KB.NurItemBase).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2022-05-13
/// Description:  更新护理项目库记录
/// Table：       DHCMA.CPW.KB.NurItemBase
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.NurItemBase).Update()   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aHospID As %String = "") As %String
{
	New (aInputStr,aSeparete,aHospID)
	Set return=-1
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID				= $p(aInputStr,aSeparete,1) 
	Set Desc     		= $p(aInputStr,aSeparete,2)
	Set Alias    		= $p(aInputStr,aSeparete,3)
	Set:Alias="" Alias=##class(ext.util.String).ToChineseSpell($$ALPHAUP^SSUTIL4(Desc))
	Set NURCode    		= $p(aInputStr,aSeparete,4)
	Set Category    	= $p(aInputStr,aSeparete,5)
	Set ExeFun    		= $p(aInputStr,aSeparete,6)
	Set IsActive    	= $p(aInputStr,aSeparete,7)
	Set ActDate    		= $p(aInputStr,aSeparete,8)
	Set:ActDate="" ActDate = +$h
	Set ActTime    		= $p(aInputStr,aSeparete,9)
	Set:ActTime="" ActTime = $p($h,",",2)
	Set ActUserID    	= $p(aInputStr,aSeparete,10)
	
	If ID="" {
		Set obj=##class(DHCMA.CPW.KB.NurItemBase).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.KB.NurItemBase).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.NIDesc    		= Desc      //写入数据
	Set obj.NIAlias    		= Alias
	Set obj.NINURCode		= NURCode
	Set obj.NICategory		= Category
	Set obj.NIExeFun		= ExeFun
	Set obj.NIIsActive		= IsActive
	Set obj.NIActDate		= ActDate			//直接按传值赋值（会覆盖原值），需保留原值时另写保存方法
	Set obj.NIActTime		= ActTime
	Set obj.NIActUserID		= ActUserID
	
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

/// Creator：     yankai
/// CreatDate：   2022-05-13
/// Description:  删除护理项目库记录
/// Table：       DHCMA.CPW.KB.NurItemBase
/// Input：       aId : DHCMA.CPW.KB.NurItemBase.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.NurItemBase).DeleteById(1)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.KB.PathMast")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.KB.NurItemBase).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2022-06-27
/// Description:  更新时判断Desc是否重复
/// Table：       DHCMA.CPW.KB.NurItemBase
/// Input：       aDesc：    描述
/// Return：      重复：ID，不重复：0
/// w ##class(DHCMA.CPW.KB.NurItemBase).CheckKBDesc("向患者/家属交待病情及术后注意事项")
ClassMethod CheckKBDesc(aDesc As %String, aID As %String = "") As %String
{
	New (aDesc,aID)
	Set return=""
	Quit:(aDesc="") return
	Set aDesc=##class(DHCMA.CPW.KBS.ImportPathWay).CleanSpecialChar(aDesc)
	If ($d(^CT.MA.CPW.KB.NurItemBaseI("IdxofDesc","1",aDesc)))
	{
		Set ID=$o(^CT.MA.CPW.KB.NurItemBaseI("IdxofDesc","1",aDesc,""),-1)
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}
	Quit return
}

Storage Default
{
<Data name="NurItemBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NIDesc</Value>
</Value>
<Value name="3">
<Value>NIAlias</Value>
</Value>
<Value name="4">
<Value>NINURCode</Value>
</Value>
<Value name="5">
<Value>NICategory</Value>
</Value>
<Value name="6">
<Value>NIExeFun</Value>
</Value>
<Value name="7">
<Value>NIIsActive</Value>
</Value>
<Value name="8">
<Value>NIActDate</Value>
</Value>
<Value name="9">
<Value>NIActTime</Value>
</Value>
<Value name="10">
<Value>NIActUserID</Value>
</Value>
</Data>
<DataLocation>^CT.MA.CPW.KB.NurItemBaseD</DataLocation>
<DefaultData>NurItemBaseDefaultData</DefaultData>
<IdLocation>^CT.MA.CPW.KB.NurItemBaseD</IdLocation>
<IndexLocation>^CT.MA.CPW.KB.NurItemBaseI</IndexLocation>
<StreamLocation>^CT.MA.CPW.KB.NurItemBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
