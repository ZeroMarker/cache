/// 名称: DHCMed.INF.Report
/// 描述: 医政管理 感染报告
/// 编写者：ChenJB
/// 编写日期: 2010-05-12
Class DHCMed.INF.Report Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// PA_Adm 就诊表
Property PaadmDR As %Integer [ Required ];

/// 感染报告类型 DHC_Med.SS.Dictionary
/// 院感报告 1/ICU专项  2/ 横断面 3/多重耐药  4/外科切口 5
Property Type As %String [ Required ];

/// 报告日期
Property RepDate As %Date;

/// 报告时间
Property RepTime As %Time;

/// 报告人 SS_User
Property UserDR As %Integer;

/// 报告当前状态 字典code
Property StatusDr As %String;

/// 备注
Property ResumeText As %String;

/// 报告科室Dr
Property CtLoc As %Integer;

/// 报告类型索引
Index Type On Type;

/// 类型就诊索引
Index TypePaadm On (Type, PaadmDR);

/// 报告日期和状态索引
Index RepDateSts On (RepDate, StatusDr);

Index TypeDtSts On (Type, RepDate, StatusDr);

Index TypeDate On (Type, RepDate);

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.Report
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: PaadmDR 3: Type 4: RepDate 5: RepTime 6: UserDR 7: StatusDr 8: ResumeText
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..PaadmDR_separete
	set return=return_..Type_separete
	set return=return_..RepDate_separete
	set return=return_..RepTime_separete
	set return=return_..UserDR_separete
	set return=return_..StatusDr_separete
	set return=return_..ResumeText_separete
	set return=return_..CtLoc
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告信息
/// Table：       DHCMed.INF.Report
/// Input：       ID:    DHCMed.INF.Report.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.Report).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.Report
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.Report).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.Report).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告信息
/// Table：       DHCMed.INF.Report
/// Input：       ID:    DHCMed.INF.Report.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.Report).GetStringById(1)
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
/// CreatDate：   2010-05-12
/// Description:  更新感染报告信息
/// Table：       DHCMed.INF.Report
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: PaadmDR 3: Type 4: RepDate 5: RepTime 6: UserDR 7: StatusDr 8: ResumeText
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.Report).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.Report).%OpenId(ID)
		}
	set obj.PaadmDR=$p(InStr,separete,2)
	set obj.Type=$p(InStr,separete,3)
	set RepDate=$p(InStr,separete,4)
	set RepTime=$p(InStr,separete,5)
	set:RepDate["-" RepDate=$zdh(RepDate,3)
	set:RepDate["/" RepDate=$zdh(RepDate,4)   //  14/05/2010
	set:RepTime[":" RepTime=$zth(RepTime,1)
	set:RepDate="" RepDate=+$h
	set:RepTime="" RepTime=$p($h,",",2)
	set obj.RepDate=+RepDate
	set obj.RepTime=+RepTime
	set obj.UserDR=$p(InStr,separete,6)
	set obj.StatusDr=$p(InStr,separete,7)
	set obj.ResumeText=$p(InStr,separete,8)
	set obj.CtLoc=$p(InStr,separete,9)
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
/// CreatDate：   2010-05-12
/// Description:  删除感染报告
/// Table：       DHCMed.INF.Report
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.Report).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  更新感染报告信息 审核 退回 等。。
/// Table：       DHCMed.INF.Report
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: PaadmDR 3: Type 4: RepDate 5: RepTime 6: UserDR 7: StatusDr 8: ResumeText
ClassMethod Audit(InfRowid As %String, Status As %String) As %String
{
 
	new (InfRowid,Status)
	set id=0
	if InfRowid="" {
		s id=-1
		} 
	else {
		set obj=##class(DHCMed.INF.Report).%OpenId(InfRowid)
		}
	quit:$IsObject(obj) id
	set obj.StatusDr=Status
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

/// Creator：     XQY
/// CreatDate：   2010-09-25
/// Description:  更新感染报告状态
/// Table：       DHCMed.INF.Report
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid  2: StatusDr
ClassMethod StatusUpdate(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	set obj=##class(DHCMed.INF.Report).%OpenId(ID)
	set obj.StatusDr=$p(InStr,separete,2)
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

Storage Default
{
<Data name="ReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PaadmDR</Value>
</Value>
<Value name="3">
<Value>RepDate</Value>
</Value>
<Value name="4">
<Value>RepTime</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
<Value name="6">
<Value>StatusDr</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
<Value name="8">
<Value>UserDR</Value>
</Value>
<Value name="9">
<Value>CtLoc</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.ReportD</DataLocation>
<DefaultData>ReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.ReportD</IdLocation>
<IndexLocation>^DHCMed.INF.ReportI</IndexLocation>
<StreamLocation>^DHCMed.INF.ReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
