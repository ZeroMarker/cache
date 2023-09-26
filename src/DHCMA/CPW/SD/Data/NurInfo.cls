/// 入院时，生命体征情况
Class DHCMA.CPW.SD.Data.NurInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 记录日期
Property RecDate As %Date;

/// 收缩压
Property SBP As %String(TRUNCATE = 1);

/// 舒张压
Property DBP As %String(TRUNCATE = 1);

/// 脉搏
Property pulse As %String(TRUNCATE = 1);

/// 呼吸
Property breath As %String(TRUNCATE = 1);

/// 心率
Property heartRate As %String(TRUNCATE = 1);

/// 体重(kg)
Property weight As %String(TRUNCATE = 1);

/// 身高
Property height As %String(TRUNCATE = 1);

/// 血氧饱和度
Property satO2 As %String(TRUNCATE = 1);

/// 压疮评估
Property braden As %String(TRUNCATE = 1);

Index IdxAdm On EpisodeID As Exact;

Index IdxAdmDate On (EpisodeID As Exact, RecDate);

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Data.NurInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Data.NurInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Data.NurInfo).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

ClassMethod GetFormatObjById(aId As %String) As DHCMA.CPW.SD.Data.NurInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Data.NurInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Data.NurInfo).%OpenId(aId)
	//数据格式处理
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zgz
/// CreatDate：   2021-05-19
/// Description:  更新体温单记录
/// Table：       DHCMA.CPW.SD.Data.NurInfo
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.NurInfo).Update()
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set EpisodeID	= $p(aInputStr,aSeparete,1)
	Set RecDate		= $p(aInputStr,aSeparete,2)
	Set SBP			= $p(aInputStr,aSeparete,3)
	Set DBP			= $p(aInputStr,aSeparete,4)
	Set pulse		= $p(aInputStr,aSeparete,5)
	Set breath		= $p(aInputStr,aSeparete,6)
	Set heartRate	= $p(aInputStr,aSeparete,7)
	Set weight		= $p(aInputStr,aSeparete,8)
	Set height		= $p(aInputStr,aSeparete,9)
	Set satO2		= $p(aInputStr,aSeparete,10)
	Set braden		= $p(aInputStr,aSeparete,11)
	Quit:(EpisodeID="") return
	Set ID=$o(^DHCMA.CPW.SD.Data.NurInfoI("IdxAdmDate",EpisodeID,RecDate,0))
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Data.NurInfo).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Data.NurInfo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	//写入数据
	Set obj.EpisodeID	=EpisodeID	
	Set obj.RecDate		=RecDate	
	Set obj.SBP			=SBP	        
	Set obj.DBP			=DBP       
	Set obj.pulse		=pulse	
	Set obj.breath		=breath	
	Set obj.heartRate	=heartRate	        
	Set obj.weight		=weight	        
	Set obj.height		=height	       
	Set obj.satO2		=satO2	
	Set obj.braden		=braden	          
	//检查Save是否成功
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Description:  删除项检查记录
/// Table：       DHCMA.CPW.SD.Data.NurInfo
/// Input：       aId :  DHCMA.CPW.SD.Data.NurInfo.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.NurInfo).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Data.NurInfo).%DeleteId(aId)
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
<Data name="NurInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>SBP</Value>
</Value>
<Value name="4">
<Value>DBP</Value>
</Value>
<Value name="5">
<Value>pulse</Value>
</Value>
<Value name="6">
<Value>breath</Value>
</Value>
<Value name="7">
<Value>heartRate</Value>
</Value>
<Value name="8">
<Value>weight</Value>
</Value>
<Value name="9">
<Value>height</Value>
</Value>
<Value name="10">
<Value>braden</Value>
</Value>
<Value name="11">
<Value>satO2</Value>
</Value>
<Value name="12">
<Value>RecDate</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Data.NurInfoD</DataLocation>
<DefaultData>NurInfoDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Data.NurInfoD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Data.NurInfoI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Data.NurInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
