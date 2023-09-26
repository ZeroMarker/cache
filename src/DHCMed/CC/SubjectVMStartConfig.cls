/// 与Subject相关的监控虚拟机加载初始化配置(名称超长,缩短!!! )
/// 创建者：李阳
/// 创建日期：2010-09-11
Class DHCMed.CC.SubjectVMStartConfig Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 与之相关联的Subject
Property SubjectID As %Integer;

Index SubjectIDIndex On SubjectID;

/// 代码
Property Code As %String [ Required ];

Index IndexCode On Code;

Index IndexSubjectCode On (SubjectID, Code) [ Unique ];

/// 描述
Property Description As %String;

/// 是否有效
Property IsActive As %Boolean;

/// 加载的顺序
Property StartIndex As %Integer [ Required ];

Index StartIndexIndex On StartIndex;

/// 运行表达式，符合Cache语法的表达式
Property Expression As %String(MAXLEN = 500) [ Required ];

/// 备注
Property ResumeText As %String;

/// 运行类型
/// S：初始化虚拟机时运行
/// L：在每个病人paadm传入时运行
Property RunType As %String;

/// 索引:Subject-IsActive-StartIndex
Index IndexSubjectActiveStartIndex On (SubjectID, RunType, IsActive, StartIndex);

/// 虚拟机中变量的名称
Property VarName As %String [ Required ];

/// 更新虚拟机加载配置信息
/// 参数序列：
/// ID^SubjectID^Code^Description^IsActive^StartIndex^Expression^ResumeText^RunType^VarName
/// w ##class(DHCMed.CC.SubjectVMStartConfig).Update("^1^01^测试配置^Y^1^##class(DHCMed.Base.Patient).GetObjById(%PatientID)^加载患者信息^L^%Patient")
ClassMethod Update(InStr) As %Integer
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.CC.SubjectVMStartConfig).%New()
		} 
	else {
		set obj=##class(DHCMed.CC.SubjectVMStartConfig).%OpenId(ID)
		}
	set obj.SubjectID=$p(InStr,"^",2)
	set obj.Code=$p(InStr,"^",3)
	set obj.Description=$p(InStr,"^",4)
	set obj.IsActive=$s($p(InStr,"^",5)="Y":1,1:0)
	set obj.StartIndex=$p(InStr,"^",6)
	set obj.Expression=$p(InStr,"^",7)
	set obj.ResumeText=$p(InStr,"^",8)
	set obj.RunType=$p(InStr,"^",9)
	set obj.VarName=$p(InStr,"^",10)
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// 通过监控主题ID获取虚拟机加载配置
/// 参数：
/// SubjectID:监控主题ID
/// RunType:监控配置类型（S：启动加载，L：加载每个paadm时调用）
/// 返回值：DHCMed.CC.SubjectVMStartConfig的集合%ListOfObjects
/// s arry=##class(DHCMed.CC.SubjectVMStartConfig).GetConfigBySubject(1,"L")
ClassMethod GetConfigBySubject(SubjectID As %Integer, RunType As %String) As %ListOfObjects
{
	n (SubjectID, RunType)
	s RunType=" "_RunType
	s arry=##class(%Library.ListOfObjects).%New()
	s index="" f  s index=$o(^DHCMed.CCi("StartConfig","IndexSubjectActiveStartIndex",SubjectID,RunType,1,index)) q:index=""  d
	.s rowid="" f  s rowid=$o(^DHCMed.CCi("StartConfig","IndexSubjectActiveStartIndex",SubjectID,RunType,1,index,rowid)) q:rowid=""  d
	..s obj=##class(DHCMed.CC.SubjectVMStartConfig).%OpenId(rowid)
	..d obj.%Close()
	..d arry.Insert(obj)
	i arry'="" d arry.%Close()
	q arry
}

/// Creator：     zhufei
/// CreatDate：   2012-09-03
/// Description:  删除虚拟机加载配置
/// Table：       DHCMed.CC.SubjectVMStartConfig
/// Input：       ItemId
/// Return：      ret>0:成功  ret<0:失败
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.CC.SubjectVMStartConfig).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

Storage Default
{
<Data name="SubjectVMStartConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Expression</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
<Value name="7">
<Value>StartIndex</Value>
</Value>
<Value name="8">
<Value>SubjectID</Value>
</Value>
<Value name="9">
<Value>RunType</Value>
</Value>
<Value name="10">
<Value>VarName</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC("StartConfig")</DataLocation>
<DefaultData>SubjectVMStartConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC("StartConfig")</IdLocation>
<IndexLocation>^DHCMed.CCi("StartConfig")</IndexLocation>
<StreamLocation>^DHCMed.CCS("StartConfig")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
