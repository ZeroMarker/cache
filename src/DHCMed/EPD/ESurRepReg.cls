/// 名称: DHCMed.EPD.ESurRepReg
/// 描述: 流调登记表主表
/// 编写者：chenrui
/// 编写日期: 2021-07-17
Class DHCMed.EPD.ESurRepReg Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 内容扩展
Relationship ChildExt As DHCMed.EPD.ESurRegExt [ Cardinality = children, Inverse = Parref ];

/// 登记类型
Property SERegTypeDr As DHCMed.EPD.ESurType;

/// 姓名
Property SEName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 登记号
Property SERegNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 身份证号
Property SEIDNumber As %String(MAXLEN = 100, TRUNCATE = 1);

/// 性别
Property SESex As %String(MAXLEN = 100, TRUNCATE = 1);

/// 电话号码
Property SETelPhone As %String(MAXLEN = 100, TRUNCATE = 1);

/// 接诊时间
Property SEDiagDateTime As %String(MAXLEN = 100, TRUNCATE = 1);

/// 接诊科室
Property SEDiagLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 接诊医生
Property SEDiagDoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告状态
Property SERepStutas As %String(MAXLEN = 100, TRUNCATE = 1);

/// 录入日期
Property SEEnterDate As %Date;

/// 就诊号
Property EpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// PatientID
Property PatientID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 登记类型 + 录入日期
Index IndexRegTypeDate On (SERegTypeDr As Exact, SEEnterDate);

/// 录入日期索引
Index IndexEnterDate On SEEnterDate As Exact;

/// 就诊号索引
Index IndexEpisodeID On EpisodeID As Exact;

/// PatientID索引
Index IndexPatientID On PatientID As Exact;

/// Creator：     chenrui
/// CreatDate：   2021-07-17
/// Description:  根据ID取流调表
/// Table：       DHCHAI.IR.OccExpReg
/// Input：       aId : DHCMed.EPD.ESurRepReg.ID
/// Return：      返回obj
/// w ##class(DHCMed.EPD.ESurRepReg).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.EPD.ESurRepReg
{
	New (aId)
	Quit:'##class(DHCMed.EPD.ESurRepReg).%ExistsId(aId) ""
	Set obj=##Class(DHCMed.EPD.ESurRepReg).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenr
/// CreatDate：   2021-07-17
/// Description:  更新流调
/// Table：       DHCMed.EPD.ESurRepReg
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.ESurRepReg).Update("")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
    Set ID				= $p(aInputStr,aSeparete,1)
	Set RegTypeDr   	= $p(aInputStr,aSeparete,2)
	Set SEName			= $p(aInputStr,aSeparete,3)
	Set SERegNo	    	= $p(aInputStr,aSeparete,4)
	Set SEIDNumber		= $p(aInputStr,aSeparete,5)
	Set SESex			= $p(aInputStr,aSeparete,6)
	Set SETelPhone    	= $p(aInputStr,aSeparete,7)
	Set SEDiagDateTime	= $p(aInputStr,aSeparete,8)
	Set SEDiagLoc	    = $p(aInputStr,aSeparete,9)
	Set SEDiagDoc		= $p(aInputStr,aSeparete,10)
	Set SERepStutas		= $p(aInputStr,aSeparete,11)
	Set EpisodeID		= $p(aInputStr,aSeparete,12)
	Set PatientID		= $p(aInputStr,aSeparete,13)
	
	
	
	Quit:(RegTypeDr="")||(SEName="") return
	
	Set objRegType = ##class(DHCMed.EPD.ESurType).GetObjById(RegTypeDr)
	Quit:'$IsObject(objRegType) return
	
	
	If ID="" {
		Set obj=##class(DHCMed.EPD.ESurRepReg).%New()
	}Else{
		Set obj=##class(DHCMed.EPD.ESurRepReg).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.SERegTypeDr  	= objRegType   
	Set obj.SEName	 		= SEName		
	Set obj.SERegNo	 		= SERegNo	    	
	Set obj.SEIDNumber   	= SEIDNumber    
	Set obj.SESex  			= SESex	
	Set obj.SETelPhone	    = SETelPhone	    
	Set obj.SEDiagDateTime	= SEDiagDateTime		
	Set obj.SEDiagLoc		= SEDiagLoc		    
	Set obj.SEDiagDoc	 	= SEDiagDoc	
	Set obj.SERepStutas	    = SERepStutas	
	Set:ID="" obj.SEEnterDate = +$h	 
	Set obj.EpisodeID	    = EpisodeID	
	Set obj.PatientID	    = PatientID	       
	
	
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

/// Creator：     chenrui
/// CreatDate：   2021-07-17
/// Description:  删除流调表
/// Table：       DHCMed.EPD.ESurRepReg
/// Input：       aId : DHCMed.EPD.ESurRepReg.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.EPD.ESurRepReg).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMed.EPD.ESurRepReg).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2021-07-17
/// Description:  审核
/// Table：       DHCMed.EPD.ESurRepReg
/// Input：       aId : DHCMed.EPD.ESurRepReg.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.ESurRepReg).DeleteById(1)
ClassMethod CheckReport(aId As %String) As %String
{
	New (aId)
	Set obj=##class(DHCMed.EPD.ESurRepReg).%OpenId(aId)
	Quit:'$IsObject(obj) return
	Set obj.SERepStutas	    = 2	
	
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

/// Creator：     chenrui
/// CreatDate：   2021-07-17
/// Description:  取消审核
/// Table：       DHCMed.EPD.ESurRepReg
/// Input：       aId : DHCMed.EPD.ESurRepReg.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.EPD.ESurRepReg).DeleteById(1)
ClassMethod UnCheckReport(aId As %String) As %String
{
	New (aId)
	Set obj=##class(DHCMed.EPD.ESurRepReg).%OpenId(aId)
	Quit:'$IsObject(obj) return
	Set obj.SERepStutas	    = 1	
	
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

Storage Default
{
<Data name="ESurRepRegDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SERegTypeDr</Value>
</Value>
<Value name="3">
<Value>SEName</Value>
</Value>
<Value name="4">
<Value>SERegNo</Value>
</Value>
<Value name="5">
<Value>SEIDNumber</Value>
</Value>
<Value name="6">
<Value>SESex</Value>
</Value>
<Value name="7">
<Value>SETelPhone</Value>
</Value>
<Value name="8">
<Value>SEDiagDateTime</Value>
</Value>
<Value name="9">
<Value>SEDiagLoc</Value>
</Value>
<Value name="10">
<Value>SEDiagDoc</Value>
</Value>
<Value name="11">
<Value>SERepStutas</Value>
</Value>
<Value name="12">
<Value>SEEnterDate</Value>
</Value>
<Value name="13">
<Value>EpisodeID</Value>
</Value>
<Value name="14">
<Value>PatientID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD.ESurRepRegD</DataLocation>
<DefaultData>ESurRepRegDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.ESurRepRegD</IdLocation>
<IndexLocation>^DHCMed.EPD.ESurRepRegI</IndexLocation>
<StreamLocation>^DHCMed.EPD.ESurRepRegS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
