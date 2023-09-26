/// 名称 : DHCMed.DC.EMR.FirstCourse
/// 说明 : 首次病程记录
Class DHCMed.DC.EMR.FirstCourse Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 记录ID
Property ResultID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊号（PA_Adm.ID）
Property EpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病程内容
Property Course As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 记录日期
Property ActDate As %Date;

/// 记录时间
Property ActTime As %Time;

/// 记录医生
Property ActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效（1有效、0无效）
Property IsActive As %Boolean;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

Index IndexEpisodeResult On (EpisodeID, ResultID) [ Unique ];

/// Creator：     liyi
/// CreatDate：   2016-04-27
/// Description:  根据ID取首次病程记录
/// Table：       DHCMed.DC.EMR.FirstCourse
/// Input：       ID:    DHCMed.DC.EMR.FirstCourse.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.EMR.FirstCourse).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.EMR.FirstCourse
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.EMR.FirstCourse).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.EMR.FirstCourse).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liyi
/// CreatDate：   2016-04-27
/// Description:  更新首次病程记录
/// Table：       DHCMed.DC.EMR.FirstCourse
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.EMR.FirstCourse).Update()
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set ResultID   	= $p(InStr,separete,1)
	set EpisodeID  	= $p(InStr,separete,2)
	set Course  	= $p(InStr,separete,3)
	set ActDate  	= $p(InStr,separete,4)
	set ActTime  	= $p(InStr,separete,5)
	set ActUser 	= $p(InStr,separete,6)
	set IsActive   	= +$p(InStr,separete,7)
	set UpdateDate 	= +$h
	set UpdateTime 	= $p($h,",",2)
	quit:(ResultID="")||(EpisodeID="")||(Course="") return
	
	//记录唯一性
	set ID=$o(^DHCMed.DC.EMR.FirstCourseI("IndexEpisodeResult"," "_$zcvt(EpisodeID,"U")," "_$zcvt(ResultID,"U"),0))
	
	if ID="" {
		set obj=##class(DHCMed.DC.EMR.FirstCourse).%New()
	}else{
		set obj=##class(DHCMed.DC.EMR.FirstCourse).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.ResultID   	= ResultID
	set obj.EpisodeID  	= EpisodeID
	set obj.Course  	= Course
	set obj.ActDate  	= ActDate
	set obj.ActTime  	= ActTime
	set obj.ActUser  	= ActUser
	set obj.IsActive   	= IsActive
	set obj.UpdateDate 	= +$h
	set obj.UpdateTime 	= $p($h,",",2)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     liyi
/// CreatDate：   2016-04-27
/// Description:  删除首次病程记录
/// Table：       DHCMed.DC.EMR.FirstCourse
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.EMR.FirstCourse).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

Storage Default
{
<Data name="FirstCourseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResultID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>Course</Value>
</Value>
<Value name="5">
<Value>ActDate</Value>
</Value>
<Value name="6">
<Value>ActTime</Value>
</Value>
<Value name="7">
<Value>ActUser</Value>
</Value>
<Value name="8">
<Value>IsActive</Value>
</Value>
<Value name="9">
<Value>UpdateDate</Value>
</Value>
<Value name="10">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.EMR.FirstCourseD</DataLocation>
<DefaultData>FirstCourseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.EMR.FirstCourseD</IdLocation>
<IndexLocation>^DHCMed.DC.EMR.FirstCourseI</IndexLocation>
<StreamLocation>^DHCMed.DC.EMR.FirstCourseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
