/// 名称: DHCMed.INF.RepCtlApp
/// 描述: 医政管理 监控评价
/// 编写者：ChenJB
/// 编写日期: 2010-10-28
Class DHCMed.INF.RepCtlApp Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// PA_Adm 就诊表
Property PaadmDR As %Integer [ Required ];

/// 分数
Property Points As %Integer [ Required ];

/// 初评诊断
Property InfDiaginos1 As %String;

/// 诊断评价 Code
Property DiagnoseApp As %String;

/// 报告评价
Property ReportApp As %String;

/// 性质评价
Property NatureApp As %String;

/// 监控【评价】人
Property CtlUser As %Integer;

/// 日期
Property CtlDate As %Date;

/// 时间
Property CtlTime As %Time;

/// 终评诊断
Property InfDiaginos2 As %Integer;

/// 终评【评价】人
Property AppUser As %Integer;

/// 日期
Property AppDate As %Date;

/// 时间
Property AppTime As %Time;

/// 状态 字典code
Property AppStatus As %String;

/// 触发类型数
Property Width As %Integer;

/// 评价依据
Property CtlContents As %String(MAXLEN = 10000);

/// 备注
Property Resume As %String;

/// 索引
Index Paadm On PaadmDR;

/// 评价日期
Index CtlDate On CtlDate;

//Index TypePaadm On (Type, PaadmDR);

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.RepCtlApp
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: PaadmDR 3: Points 4: InfDiaginos1 5: DiagnoseApp 6: ReportApp 7: NatureApp 
/// 8: CtlUser 9: CtlDate 10: CtlTime 11: InfDiaginos2 12: AppUser 13: AppDate 14: AppTime
/// 15: AppStatus 16: Width 17: CtlContents 18: Resume
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..PaadmDR_separete
	set return=return_..Points_separete
	set return=return_..InfDiaginos1_separete
	set return=return_..DiagnoseApp_separete
	set return=return_..ReportApp_separete
	set return=return_..NatureApp_separete
	set return=return_..CtlUser_separete
	set return=return_..CtlDate_separete
	set return=return_..CtlTime_separete
	set return=return_..InfDiaginos2_separete
	set return=return_..AppUser_separete
	set return=return_..AppDate_separete
	set return=return_..AppTime_separete
	set return=return_..AppStatus_separete
	set return=return_..Width_separete
	set return=return_..CtlContents_separete
	set return=return_..Resume
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告信息
/// Table：       DHCMed.INF.RepCtlApp
/// Input：       ID:    DHCMed.INF.RepCtlApp.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.RepCtlApp).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.RepCtlApp
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.RepCtlApp).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.RepCtlApp).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告信息
/// Table：       DHCMed.INF.RepCtlApp
/// Input：       ID:    DHCMed.INF.RepCtlApp.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.RepCtlApp).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-10-12
/// Description:  更新感染报告信息
/// Table：       DHCMed.INF.RepCtlApp
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: PaadmDR 3: Points 4: InfDiaginos1 5: DiagnoseApp 6: ReportApp 7: NatureApp 
/// 8: CtlUser 9: CtlDate 10: CtlTime 11: InfDiaginos2 12: AppUser 13: AppDate 14: AppTime
/// 15: AppStatus 16: Width 17: CtlContents 18: Resume
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.RepCtlApp).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.RepCtlApp).%OpenId(ID)
		}
	set obj.PaadmDR=$p(InStr,separete,2)
	set obj.Points=$p(InStr,separete,3)
	set obj.InfDiaginos1=$p(InStr,separete,4)
	set obj.DiagnoseApp=$p(InStr,separete,5)
	set obj.ReportApp=$p(InStr,separete,6)
	set obj.NatureApp=$p(InStr,separete,7)
	set obj.CtlUser=$p(InStr,separete,8)
	set CtlDate=$p(InStr,separete,9)
	set CtlTime=$p(InStr,separete,10)
	set:CtlDate["-" CtlDate=$zdh(CtlDate,3)
	set:CtlDate["/" CtlDate=$zdh(CtlDate,4)   //  14/05/2010
	set:CtlTime[":" CtlTime=$zth(CtlTime,1)
	set:CtlDate="" CtlDate=+$h
	set:CtlTime="" CtlTime=$p($h,",",2)
	set obj.CtlDate=+CtlDate
	set obj.CtlTime=+CtlTime
	set obj.InfDiaginos2=$p(InStr,separete,11)
	set obj.AppUser=$p(InStr,separete,12)
	set AppDate=$p(InStr,separete,13)
	set AppTime=$p(InStr,separete,14)
	set:AppDate["-" AppDate=$zdh(AppDate,3)
	set:AppDate["/" AppDate=$zdh(AppDate,4)   //  14/05/2010
	set:AppTime[":" AppTime=$zth(AppTime,1)
	//set:AppDate="" AppDate=0
	//set:AppTime="" AppTime=0
	set obj.AppDate=AppDate
	set obj.AppTime=AppTime
	set obj.AppStatus=$p(InStr,separete,15)
	set obj.Width=+$p(InStr,separete,16)
	set obj.CtlContents=$p(InStr,separete,17)
	set obj.Resume=$p(InStr,separete,18)
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

/// Creator：     ChenJB
/// CreatDate：   2010-10-12
/// Description:  删除
/// Table：       DHCMed.INF.RepCtlApp
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.RepCtlApp).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

Storage Default
{
<Data name="RepCtlAppDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AppDate</Value>
</Value>
<Value name="3">
<Value>AppStatus</Value>
</Value>
<Value name="4">
<Value>AppTime</Value>
</Value>
<Value name="5">
<Value>AppUser</Value>
</Value>
<Value name="6">
<Value>CtlContents</Value>
</Value>
<Value name="7">
<Value>CtlDate</Value>
</Value>
<Value name="8">
<Value>CtlTime</Value>
</Value>
<Value name="9">
<Value>CtlUser</Value>
</Value>
<Value name="10">
<Value>DiagnoseApp</Value>
</Value>
<Value name="11">
<Value>InfDiaginos1</Value>
</Value>
<Value name="12">
<Value>InfDiaginos2</Value>
</Value>
<Value name="13">
<Value>NatureApp</Value>
</Value>
<Value name="14">
<Value>PaadmDR</Value>
</Value>
<Value name="15">
<Value>Points</Value>
</Value>
<Value name="16">
<Value>ReportApp</Value>
</Value>
<Value name="17">
<Value>Resume</Value>
</Value>
<Value name="18">
<Value>Width</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.RepCtlAppD</DataLocation>
<DefaultData>RepCtlAppDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.RepCtlAppD</IdLocation>
<IndexLocation>^DHCMed.INF.RepCtlAppI</IndexLocation>
<StreamLocation>^DHCMed.INF.RepCtlAppS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
