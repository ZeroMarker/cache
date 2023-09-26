/// 名称: DHCMed.CC.Evaluation
/// 描述: 监控评价信息表
/// 编写者：zhufei
/// 编写日期: 2011-05-20
Class DHCMed.CC.Evaluation Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// SubjectDr	主题ID
Property SubjectDr As DHCMed.CC.Subject;

/// PaadmDr	就诊号
/// -->表:Paadm
Property PaadmDr As %String;

/// EvalDate	评价日期
Property EvalDate As %Date;

/// EvalTime	评价时间
Property EvalTime As %Time;

/// EvalUser	评价用户
/// -->表:SS_User
Property EvalUser As %String;

/// EvalLoc	评价科室
/// -->表:CT_Loc
Property EvalLoc As %String;

/// EvalInfo	评价内容
Property EvalInfo As %String(MAXLEN = 500);

/// IsActive	是否有效
Property IsActive As %Boolean;

/// Resume	备注
Property Resume As %String(MAXLEN = 500);

/// 监控+就诊号索引
Index IndexSubjectAdm On (SubjectDr As Exact, PaadmDr As Exact);

/// Add By LiYang 2011-09-09 增加评价时的快照保存功能
/// 自定义监控指标的列表
Property SubjectItmIDList As %String;

/// 分数	
Property Score As %String;

/// 触发项目个数
Property FiredCount As %Integer;

/// 触发项目类别个数
Property FiredTypeCount As %Integer;

/// Creator：     zhufei
/// CreatDate：   2011-05-20
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.Evaluation
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1::RowID、2:SubjectDr、3:PaadmDr、4:EvalDate、5:EvalTime
/// 6:EvalUser、7:EvalLoc、8:EvalInfo、9:IsActive、10:Resume
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	set return=..%Id()_separete
	set return=return_..SubjectDr.%Id()_separete
	set return=return_..PaadmDr_separete
	set return=return_..EvalDate_separete
	set return=return_..EvalTime_separete
	set return=return_..EvalUser_separete
	set return=return_..EvalLoc_separete
	set return=return_..EvalInfo_separete
	set return=return_..IsActive_separete
	set return=return_..Resume_separete
	//Add By LiYang 2011-09-13 增加快照信息
	Set return=return_..SubjectItmIDList_separete
	Set return=return_..Score_separete
	Set return=return_..FiredCount_separete
	Set return=return_..FiredTypeCount_separete
		
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-05-20
/// Description:  根据ID取监控评价信息
/// Table：       DHCMed.CC.Evaluation
/// Input：       ID:    DHCMed.CC.Evaluation.ID
/// Return：      对象
/// w ##class(DHCMed.CC.Evaluation).GetObjById(1)
ClassMethod GetObjById(argId As %String) As DHCMed.CC.Evaluation
{
	New (argId)
	Set return=""
	Quit:argId="" return
	Set return=##Class(DHCMed.CC.Evaluation).%OpenId(argId)
	If $IsObject(return) Do return.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-05-20
/// Description:  根据ID取监控评价信息
/// Table：       DHCMed.CC.Evaluation
/// Input：       ID:    DHCMed.CC.Evaluation.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.Evaluation).GetStringById(1)
ClassMethod GetStringById(argId As %String, argSeparete As %String) As %String
{
	New (argId,argSeparete)
	Set return=""
	Set obj=..GetObjById(argId)
	If $IsObject(obj){
		Set return=obj.ToString($g(argSeparete))
	}	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-05-20
/// Description:  更新监控评价信息
/// Table：       DHCMed.CC.Evaluation
/// 输入格式：    RowID^SubjectDr^PaadmDr^EvalDate^EvalTime^EvalUser^EvalLoc^EvalInfo^IsActive^Resume
/// w ##class(DHCMed.CC.Evaluation).Update("^1^1^2011-05-20^10:00^1^1^EvalInfo^Y^Resume")
ClassMethod Update(argInput As %String, argSeperator As %String = "^") As %Integer
{
	New (argInput,argSeperator)
	Set return=0
	Set ID=$p(argInput,argSeperator,1)
	If ID="" {
		Set obj=##class(DHCMed.CC.Evaluation).%New()
	}Else{
		Set obj=##class(DHCMed.CC.Evaluation).%OpenId(ID)
		Quit:'$IsObject(obj) return
	}
	Set SubjectID=$p(argInput,argSeperator,2)
	Set objSubject=##Class(DHCMed.CC.Subject).GetObjById(SubjectID)
	Set Paadm=$p(argInput,argSeperator,3)
	Set EvalDate=$p(argInput,argSeperator,4)
	Set:EvalDate["-" EvalDate=$zdh(EvalDate,3)
	Set:EvalDate["/" EvalDate=$zdh(EvalDate,4)
	Set:EvalDate="" EvalDate=+$h
	Set EvalTime=$p(argInput,argSeperator,5)
	Set:EvalTime[":" EvalTime=$zth(EvalTime,1)
	Set:EvalTime="" EvalTime=$p($h,",",2)
	Set EvalUser=$p(argInput,argSeperator,6)
	Set EvalLoc=$p(argInput,argSeperator,7)
	Set EvalInfo=$p(argInput,argSeperator,8)
	Set IsActive=$s($p(argInput,argSeperator,9)["Y":1,1:0)
	Set Resume=$p(argInput,argSeperator,10)
	//Add By LiYang 2011-09-13 增加快照信息
	Set SubjectItmIDList=$p(argInput,argSeperator,11)
	Set Score=$p(argInput,argSeperator,12)
	Set FiredCount=$p(argInput,argSeperator,13)
	Set FiredTypeCount=$p(argInput,argSeperator,14)
	
	Set obj.SubjectDr=objSubject
	Set obj.PaadmDr=Paadm
	Set obj.EvalDate=EvalDate
	Set obj.EvalTime=EvalTime
	Set obj.EvalUser=EvalUser
	Set obj.EvalLoc=EvalLoc
	Set obj.EvalInfo=EvalInfo
	Set obj.IsActive=IsActive
	Set obj.Resume=Resume
	//Add By LiYang 2011-09-13 增加快照信息
	Set obj.SubjectItmIDList=SubjectItmIDList
	Set obj.Score=Score
	Set obj.FiredCount=FiredCount
	Set obj.FiredTypeCount=FiredTypeCount
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {     //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-05-20
/// Description:  删除监控评价信息
/// Table：       DHCMed.CC.Evaluation
/// Input：       DHCMed.CC.Evaluation.ID
/// Return：      ret>0:成功  ret<0:失败
ClassMethod DeleteById(argId As %String) As %String
{
	New (argId)
	Set return=1
	Quit:argID="" return
	Set sc = ##class(DHCMed.CC.Evaluation).%DeleteId(argId)
	If $system.Status.IsError(sc) {       //检查删除是否成功
   		//d $system.OBJ.DisplayError(sc)
   		Set return=-1
	}Else{
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubjectDr</Value>
</Value>
<Value name="3">
<Value>PaadmDr</Value>
</Value>
<Value name="4">
<Value>EvalDate</Value>
</Value>
<Value name="5">
<Value>EvalTime</Value>
</Value>
<Value name="6">
<Value>EvalUser</Value>
</Value>
<Value name="7">
<Value>EvalLoc</Value>
</Value>
<Value name="8">
<Value>EvalInfo</Value>
</Value>
<Value name="9">
<Value>IsActive</Value>
</Value>
<Value name="10">
<Value>Resume</Value>
</Value>
<Value name="11">
<Value>FiredCount</Value>
</Value>
<Value name="12">
<Value>FiredTypeCount</Value>
</Value>
<Value name="13">
<Value>Score</Value>
</Value>
<Value name="14">
<Value>SubjectItmIDList</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC("Eval")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC("Eval")</IdLocation>
<IndexLocation>^DHCMed.CCi("Eval",0)</IndexLocation>
<StreamLocation>^DHCMed.CC.EvaluationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
