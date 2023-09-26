/// Creator:WangCS
/// CreateDate:2012-03-13
Class DHCMed.NINF.Srv.InfStatICUInfo Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Property Paadm As %String(TRUNCATE = 1);

/// 转入ICU日期
Property InICUDate As %Date;

/// 转出ICU日期
Property OutICUDate As %Date;

/// 转出至
Property OutICUPlace As %String(TRUNCATE = 1);

/// 转入ICU诊断
Property InICUDiag1 As %String(TRUNCATE = 1);

/// 转入ICU诊断
Property InICUDiag2 As %String(TRUNCATE = 1);

/// 转入ICU诊断
Property InICUDiag3 As %String(TRUNCATE = 1);

/// ICU诊断
Property ICUDiag1 As %String(TRUNCATE = 1);

/// ICU诊断
Property ICUDiag2 As %String(TRUNCATE = 1);

/// ICU诊断
Property ICUDiag3 As %String(TRUNCATE = 1);

/// 置管日期
Property InDate As %Date;

/// 拔管日期
Property OutDate As %Date;

/// 插管操作者
Property InOperator As %String(TRUNCATE = 1);

/// 拔管操作者
Property OutOperator As %String(TRUNCATE = 1);

/// 置管地点
Property Address As %String(TRUNCATE = 1);

/// 感染日期
Property InfDate As %Date;

/// VenousCatheter：静脉插管 VentilatorTube: 呼吸机 Catheter：导尿管
Property Type As %String(DISPLAYLIST = ",VenousCatheter,VentilatorTube,Catheter", VALUELIST = ",VC,VT,C");

///  Text1
Property Text1 As %String(TRUNCATE = 1);

/// Text2
Property Text2 As %String(TRUNCATE = 1);

/// Text3
Property Text3 As %String(TRUNCATE = 1);

Index IndexOfInICUDate On InICUDate;

Index IndexOfOutICUDate On OutICUDate;

Index IndexOfPaadm On Paadm;

ClassMethod Update(InputStr As %String, Separate As %String)
{
	New (InputStr,Separate)
	Set ID=$P(InputStr,Separate,1)
	If (ID=""){
		Set Obj=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%New()
	}Else{
		Set Obj=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%OpenId(ID)
	}
	Set Obj.Paadm=$p(InputStr,Separate,2)
	Set InICUDate=$p(InputStr,Separate,3)
	Set InICUDate=..ConvertToDate(InICUDate)
	Set Obj.InICUDate=InICUDate
	
	Set OutICUPlace=$p(InputStr,Separate,4)
	Set OutICUPlace=..ConvertToDate(OutICUDate)
	Set Obj.OutICUPlace=OutICUPlace
	
	Set Obj.OutICUPlace=$p(InputStr,Separate,5)
	Set Obj.InICUDiag1=$p(InputStr,Separate,6)
	Set Obj.InICUDiag2=$p(InputStr,Separate,7)
	Set Obj.InICUDiag3=$p(InputStr,Separate,8)
	Set Obj.ICUDiag1=$p(InputStr,Separate,9)
	Set Obj.ICUDiag2=$p(InputStr,Separate,10)
	Set Obj.ICUDiag3=$p(InputStr,Separate,11)
	Set Obj.Text1=$p(InputStr,Separate,12)
	
	Set InDate=$p(InputStr,Separate,13)
	Set InDate=..ConvertToDate(InDate)
	Set Obj.InDate=InDate
	
	Set OutDate=$p(InputStr,Separate,14)
	Set OutDate=..ConvertToDate(OutDate)
	Set Obj.OutDate=OutDate
	
	Set Obj.InOperator=$p(InputStr,Separate,15)
	Set Obj.OutOperator=$p(InputStr,Separate,16)
	Set Obj.Address=$p(InputStr,Separate,17)
	
	Set InfDate=$p(InputStr,Separate,18)
	Set InfDate=..ConvertToDate(InfDate)
	Set Obj.InfDate=InfDate
	Set Obj.Type=$p(InputStr,Separate,19)
	Set Obj.Text2=$p(InputStr,Separate,20)
	Set Obj.Text3=$p(InputStr,Separate,21)
	
	Set sc=Obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=Obj.%Id()
	}
	Do Obj.%Close()
}

ClassMethod ConvertToDate(Date As %String)
{
	New (Date)	
	Set Rtn=""
	Quit:Date="" 0
	Set:Date["年" Date=$tr(Date,"年","-")
	Set:Date["月" Date=$tr(Date,"月","-")
	Set:Date["日" Date=$p(Date,"日",1)
	Set:Date["-" Date=$zdh(Date,3)
	Set:Date["/" Date=$zdh(Date,4)
	Set Rtn=+Date
	Quit Rtn
}

ClassMethod DeleteByPaadm(Paadm As %String)
{
	New (Paadm)
	;^DHCMed.NINF.Srv.InfStatICUInfI("IndexOfPaadm"," 277",1)
	Set NPaadm=" "_Paadm,Count=0
	Set ID=0
	For {
		Set ID=$O(^DHCMed.NINF.Srv.InfStatICUInfI("IndexOfPaadm",NPaadm,ID))	
		Quit:ID=""
		Set Rtn=..DeleteById(ID)
		Set:Rtn=1 Count=$i(Count)
	}	
	Quit Count
}

ClassMethod DeleteById(ID) As %String
{
	New (ID)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Srv.InfStatICUInfo).%DeleteId(ID)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="InfStatICUInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Paadm</Value>
</Value>
<Value name="3">
<Value>InICUDate</Value>
</Value>
<Value name="4">
<Value>OutICUDate</Value>
</Value>
<Value name="5">
<Value>OutICUPlace</Value>
</Value>
<Value name="6">
<Value>InICUDiag1</Value>
</Value>
<Value name="7">
<Value>InICUDiag2</Value>
</Value>
<Value name="8">
<Value>InICUDiag3</Value>
</Value>
<Value name="9">
<Value>ICUDiag1</Value>
</Value>
<Value name="10">
<Value>ICUDiag2</Value>
</Value>
<Value name="11">
<Value>ICUDiag3</Value>
</Value>
<Value name="12">
<Value>InDate</Value>
</Value>
<Value name="13">
<Value>OutDate</Value>
</Value>
<Value name="14">
<Value>InOperator</Value>
</Value>
<Value name="15">
<Value>OutOperator</Value>
</Value>
<Value name="16">
<Value>Address</Value>
</Value>
<Value name="17">
<Value>InfDate</Value>
</Value>
<Value name="18">
<Value>Type</Value>
</Value>
<Value name="19">
<Value>Text1</Value>
</Value>
<Value name="20">
<Value>Text2</Value>
</Value>
<Value name="21">
<Value>Text3</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Srv.InfStatICUInfD</DataLocation>
<DefaultData>InfStatICUInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Srv.InfStatICUInfD</IdLocation>
<IndexLocation>^DHCMed.NINF.Srv.InfStatICUInfI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Srv.InfStatICUInfS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
