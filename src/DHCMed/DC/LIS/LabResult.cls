/// 名称 : DHCMed.DC.LIS.LabResult
/// 说明 : 检验结果
Class DHCMed.DC.LIS.LabResult Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildSen As DHCMed.DC.LIS.LabResultSen [ Cardinality = children, Inverse = Parref ];

/// 报告ID
Property ReportID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检测项目
Property TestCodeDR As DHCMed.DC.LIS.BTTestCode;

/// 检测结果类型（数字N、文本T、列表S、细菌V|M、血型A|B2、阴性血型R）
Property ResultFormat As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检测结果
Property Result As %String(MAXLEN = 100, TRUNCATE = 1);

/// 定性结果
Property TextRes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 扩展结果
Property ExtraRes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 其它结果
Property OtherRes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果说明(细菌备注)
Property ResNoes As %String(MAXLEN = 500, TRUNCATE = 1);

/// 异常提示
Property AbFlag As %String(MAXLEN = 100, TRUNCATE = 1);

/// 单位
Property Unit As %String(MAXLEN = 100, TRUNCATE = 1);

/// 参考范围
Property RefRanges As %String(MAXLEN = 100, TRUNCATE = 1);

/// 多耐菌标注
Property MDRResult As %String(MAXLEN = 100, TRUNCATE = 1);

/// 产超广谱β-内酰胺酶(ESBLs)检测结果
Property ESBLsResult As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexReportID On (ReportID As Exact, TestCodeDR As Exact);

/// Creator：     zhufei
/// CreatDate：   2016-03-04
/// Description:  根据ID取检验项目结果
/// Table：       DHCMed.DC.LIS.LabResult
/// Input：       ID:    DHCMed.DC.LIS.LabResult.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.LIS.LabResult).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.LIS.LabResult
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.LIS.LabResult).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.LIS.LabResult).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-04
/// Description:  更新检验项目结果记录
/// Table：       DHCMed.DC.LIS.LabResult
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.LIS.LabResult).Update()
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set ReportID    = $p(InStr,separete,1)
	set TestCodeDR  = $p(InStr,separete,2)
	set ResultFormat= $p(InStr,separete,3)
	set Result      = $p(InStr,separete,4)
	set TextRes     = $p(InStr,separete,5)
	set ResNoes     = $p(InStr,separete,6)
	set AbFlag      = $p(InStr,separete,7)
	set Unit        = $p(InStr,separete,8)
	set RefRanges   = $p(InStr,separete,9)
	set MDRResult   = $p(InStr,separete,10)
	set ESBLsResult = $p(InStr,separete,11)
	quit:(ReportID="")||(TestCodeDR="") return
	
	set objTestCode=##Class(DHCMed.DC.LIS.BTTestCode).GetObjById(TestCodeDR)
	quit:'$IsObject(objTestCode) return
	
	//报告记录唯一性
	set ID=$o(^DHCMed.DC.LIS.LabResultI("IndexReportID",ReportID,TestCodeDR,0))
	
	if ID="" {
		set obj=##class(DHCMed.DC.LIS.LabResult).%New()
	}else{
		set obj=##class(DHCMed.DC.LIS.LabResult).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.ReportID    = ReportID
	set obj.TestCodeDR  = objTestCode
	set obj.ResultFormat= ResultFormat
	set obj.Result      = Result
	set obj.TextRes     = TextRes
	set obj.ResNoes     = ResNoes
	set obj.AbFlag      = AbFlag
	set obj.Unit        = Unit
	set obj.RefRanges   = RefRanges
	set obj.MDRResult   = MDRResult
	set obj.ESBLsResult = ESBLsResult
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

/// Creator：     zhufei
/// CreatDate：   2016-03-04
/// Description:  删除检验项目结果记录
/// Table：       DHCMed.DC.LIS.LabResult
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.LIS.LabResult).%DeleteId(+Id)
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
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReportID</Value>
</Value>
<Value name="3">
<Value>""</Value>
</Value>
<Value name="4">
<Value>TestCodeDR</Value>
</Value>
<Value name="5">
<Value>ResultFormat</Value>
</Value>
<Value name="6">
<Value>Result</Value>
</Value>
<Value name="7">
<Value>TextRes</Value>
</Value>
<Value name="8">
<Value>ExtraRes</Value>
</Value>
<Value name="9">
<Value>OtherRes</Value>
</Value>
<Value name="10">
<Value>ResNoes</Value>
</Value>
<Value name="11">
<Value>AbFlag</Value>
</Value>
<Value name="12">
<Value>Unit</Value>
</Value>
<Value name="13">
<Value>RefRanges</Value>
</Value>
<Value name="14">
<Value>MDRResult</Value>
</Value>
<Value name="15">
<Value>ESBLsResult</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.LIS.LabResultD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.LIS.LabResultD</IdLocation>
<IndexLocation>^DHCMed.DC.LIS.LabResultI</IndexLocation>
<StreamLocation>^DHCMed.DC.LIS.LabResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
