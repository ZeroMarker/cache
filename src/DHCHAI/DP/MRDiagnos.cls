/// 名称: DHCHAI.DP.MRDiagnos
/// 描述: 诊断表
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.MRDiagnos Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property MREpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 诊断ICD10
Property MRDiagICD10 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断名称
Property MRDiagDesc As %String(MAXLEN = 1000, TRUNCATE = 1) [ Required ];

/// 诊断备注
Property MRDiagNote As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断类型代码
Property MRDiagTpCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断类型描述
Property MRDiagTpDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断日期
Property MRDiagDate As %Date;

/// 诊断时间
Property MRDiagTime As %Time;

/// 诊断来源（C临床、E首页、F编目、D出院诊断证明书,A首程）
Property MRDiagSource As %String(DISPLAYLIST = ",C,E,F,D,A", VALUELIST = ",C,E,F,D,A") [ Required ];

/// 子系统代码
Property MRSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 记录索引码
Property MRXCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property MRIsActive As %Boolean [ Required ];

/// 更新日期
Property MRUpdateDate As %Date [ Required ];

/// 更新时间
Property MRUpdateTime As %Time [ Required ];

/// 入院病情
Property MRAdmission As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊记录索引
Index IndexEpisodeDr On MREpisodeDr;

/// 子系统代码 + 记录索引码 索引
Index IndexSCodeXCode On (MRSCode As Exact, MRXCode As Exact);

/// 诊断来源、就诊记录索引
Index IndexSourceEpis On (MRDiagSource As Exact, MREpisodeDr);

/// add 20191211
/// 更新日期 索引
Index IndexEpisUpdateDate On (MREpisodeDr, MRUpdateDate);

/// Creator：     liyi
/// CreatDate：   2017-12-05
/// Description:  根据ID作废诊断记录
/// Table：       DHCHAI.DP.MRDiagnos
/// Input：       id:    DHCHAI.DP.MRDiagnos.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.MRDiagnos).CancelById(1)
ClassMethod CancelById(id As %String) As %String
{
	New (id)
	Set return=""
	Quit:id="" return
	
	Set obj=##class(DHCHAI.DP.MRDiagnos).%OpenId(id)
	Quit:'$IsObject(obj) return
	
	Set obj.MRIsActive		= 0
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取诊断表
/// Table：       DHCHAI.DP.MRDiagnos
/// Input：       id:    DHCHAI.DP.MRDiagnos.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.MRDiagnos).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.MRDiagnos
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.MRDiagnos).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.MRDiagnos).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据子系统代码，记录索引码取诊断
/// Table：       DHCHAI.DP.MRDiagnos
/// Input：       aSCode: 子系统代码
///               aXCode: 记录索引码
/// Return：      返回Object
/// w ##class(DHCHAI.DP.MRDiagnos).GetObjByXCode(1)
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.DP.MRDiagnos
{
	New (aSCode,aXCode)
	Set return = ""
	Quit:(aSCode="")||(aXCode="") return
	
	Set id=$o(^DHCHAI.DP.MRDiagnosI("IndexSCodeXCode",aSCode,aXCode,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新诊断表
/// Table：       DHCHAI.DP.MRDiagnos
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.MRDiagnos).Update("^269^E16.000^药物性低血糖^^^^64117^35483^C^HIS01^408||2^1^64495^58739")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set EpisodeDr	= $p(InStr,aSeparete,2)
	Set DiagICD10	= $p(InStr,aSeparete,3)
	Set DiagDesc	= $p(InStr,aSeparete,4)
	Set DiagNote	= $p(InStr,aSeparete,5)
	Set DiagTpCode	= $p(InStr,aSeparete,6)
	Set DiagTpDesc	= $p(InStr,aSeparete,7)
	Set DiagDate	= $p(InStr,aSeparete,8)
	Set DiagTime	= $p(InStr,aSeparete,9)
	Set DiagSource	= $p(InStr,aSeparete,10)
	Set SCode		= $p(InStr,aSeparete,11)
	Set XCode		= $p(InStr,aSeparete,12)
	Set IsActive	= +$p(InStr,aSeparete,13)
	Set UpdateDate	= $p(InStr,aSeparete,14)
	Set UpdateTime	= $p(InStr,aSeparete,15)
	Set Admission	= $p(InStr,aSeparete,16)
	Set:DiagDate["-" DiagDate = $zdh(DiagDate,3)
	Set:DiagTime[":" DiagTime = $zth(DiagTime,1)
	Quit:(EpisodeDr="")||(DiagDesc="")||(DiagSource="") return
	Quit:(SCode="")||(XCode="")||(IsActive="") return
	
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:objAdm="" return
	
	//子系统代码+记录索引码 唯一性
	Set tID =$o(^DHCHAI.DP.MRDiagnosI("IndexSCodeXCode",SCode,XCode,0)) 
	Quit:(tID'="")&(ID'=tID) -100 
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.MRDiagnos).%New()
	}else{
		Set obj=##class(DHCHAI.DP.MRDiagnos).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.MREpisodeDr		= objAdm
	Set obj.MRDiagICD10		= DiagICD10
	Set obj.MRDiagDesc		= DiagDesc
	Set obj.MRDiagNote		= DiagNote
	Set obj.MRDiagTpCode	= DiagTpCode
	Set obj.MRDiagTpDesc	= DiagTpDesc
	Set obj.MRDiagDate		= DiagDate
	Set obj.MRDiagTime		= DiagTime
	Set obj.MRDiagSource	= DiagSource
	Set obj.MRSCode			= SCode
	Set obj.MRXCode			= XCode	
	Set obj.MRIsActive		= IsActive
	Set obj.MRUpdateDate	= +$h
	Set obj.MRUpdateTime	= $p($h,",",2)
	Set obj.MRAdmission     =Admission
   
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除诊断表
/// Table：       DHCHAI.DP.MRDiagnos
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.MRDiagnos).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     pylian
/// CreatDate：   2019-09-10
/// Description:  处理记录索引码历史问题
/// 			  
/// Table		  DHCHAI.DP.MRDiagnos
/// w ##class(DHCHAI.DP.MRDiagnos).UpdateDiagnos()
ClassMethod UpdateDiagnos() As %String
{
	Set return =0 ,Count=0
	
	W "开始",!
	Set CurrTime = $h
	
	Set MRXCode=""		
	Set xDiagID=""
	For { 
		Set xDiagID =$o(^DHCHAI.DP.MRDiagnosD(xDiagID))
		Quit:xDiagID=""
        
		Set objDiag = ##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagID)
		Continue:'$IsObject(objDiag)	
		Continue:objDiag.MRDiagSource'="E"	
        //53470667||4221741||1,HDSD00.11.024||HDSD00.11.024
		Set XCode = objDiag.MRXCode
		Continue:XCode=""
		Set Code1= $p(XCode,",",1)
		Set Code2= $p(XCode,",",2)
		Set Code3= $p(Code2,"||",1)
		Continue:Code2=""
		w !,xDiagID
		Set MRXCode= Code1_"||"_Code3
		
		Set obj=##class(DHCHAI.DP.MRDiagnos).%OpenId(xDiagID)
		Set obj.MRXCode = MRXCode
		Set sc=obj.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc)
		}Else {
			Set Count =Count+1
		}
		Do obj.%Close()
	}
	
	Write "用时："_($p($h,",",2)-$p(CurrTime,",",2))_"s",!
	
	Set return = Count
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeDr</Value>
</Value>
<Value name="3">
<Value>MRDiagICD10</Value>
</Value>
<Value name="4">
<Value>MRDiagDesc</Value>
</Value>
<Value name="5">
<Value>MRDiagNote</Value>
</Value>
<Value name="6">
<Value>MRDiagTpCode</Value>
</Value>
<Value name="7">
<Value>MRDiagTpDesc</Value>
</Value>
<Value name="8">
<Value>MRDiagDate</Value>
</Value>
<Value name="9">
<Value>MRDiagTime</Value>
</Value>
<Value name="10">
<Value>MRDiagSource</Value>
</Value>
<Value name="11">
<Value>MRSCode</Value>
</Value>
<Value name="12">
<Value>MRXCode</Value>
</Value>
<Value name="13">
<Value>MRIsActive</Value>
</Value>
<Value name="14">
<Value>MRUpdateDate</Value>
</Value>
<Value name="15">
<Value>MRUpdateTime</Value>
</Value>
<Value name="16">
<Value>MRAdmission</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.MRDiagnosD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.MRDiagnosD</IdLocation>
<IndexLocation>^DHCHAI.DP.MRDiagnosI</IndexLocation>
<StreamLocation>^DHCHAI.DP.MRDiagnosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
