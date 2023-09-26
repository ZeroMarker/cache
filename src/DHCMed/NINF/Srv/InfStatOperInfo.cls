/// Creator:wangcs
/// CreateDate:2013-03-13
Class DHCMed.NINF.Srv.InfStatOperInfo Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 病人就诊ID
Property Paadm As %String(TRUNCATE = 1);

/// 手术名称
Property OperationName As %String(TRUNCATE = 1);

/// 手术类型
Property OperationType As %String(TRUNCATE = 1);

/// 主刀医师
Property Operator As %String(TRUNCATE = 1);

/// 手术日期
Property OperDate As %Date;

/// 持续时间
Property Duration As %String(TRUNCATE = 1);

/// ASA分级
Property ASARank As %String(TRUNCATE = 1);

/// 切口等级
Property CutType As %String(TRUNCATE = 1);

/// 手术分级
Property OperRank As %String(TRUNCATE = 1);

/// 麻醉类型
Property NarcosisType As %String(TRUNCATE = 1);

/// 手术部位
Property OperPosition As %String(TRUNCATE = 1);

/// 术中出血(ml)
Property OperOfHaemorrhage As %String(TRUNCATE = 1);

/// 数据来源
Property DataSource As %String(TRUNCATE = 1);

/// 相关院感报告
Property ReportList As list Of DHCMed.NINF.Rep.InfReport;

/// 是否感染
Property IsInf As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 就诊索引
Index IndexOfPaadm On Paadm;

//Relationship ParOfBaseInfo As DHCMed.NINF.Srv.InfStatBaseInfo [ Cardinality = parent, Inverse = ChildOfOper ];

/// Debug:w ##Class(DHCMed.NINF.Srv.InfStatOperInfo).Update("^277^甲状旁腺探查术^择期^11^2013^60^Ⅰ^Ⅱ^^全麻^^10^ReportID:78","^")
ClassMethod Update(InputStr As %String, Separate As %String)
{
	New (InputStr,Separate)	
	Set:Separate="" Separate=..#SEPARATE
	Set Rtn=""
	Set ^Test=InputStr
	Set ID=$p(InputStr,Separate,1)
	If (ID'=""){
		Set Obj=##Class(DHCMed.NINF.Srv.InfStatOperInfo).%OpenId(ID)
	}Else{
		Set Obj=##Class(DHCMed.NINF.Srv.InfStatOperInfo).%New()
	}
	Quit:'$IsObject(Obj) Rtn
	Set Paadm=$p($g(InputStr),Separate,2)
	Set Obj.Paadm=Paadm
	Set Obj.OperationName=$p($g(InputStr),Separate,3)
	Set Obj.OperationType=$p($g(InputStr),Separate,4)
	Set Obj.Operator=$p($g(InputStr),Separate,5)
	Set OperDate=$p($g(InputStr),Separate,6)
	Set Obj.OperDate=OperDate
	Set Obj.Duration=$p($g(InputStr),Separate,7)
	Set Obj.ASARank=$p($g(InputStr),Separate,8)
	Set Obj.CutType=$p($g(InputStr),Separate,9)
	Set Obj.OperRank=$p($g(InputStr),Separate,10)
	Set Obj.NarcosisType=$p($g(InputStr),Separate,11)
	Set Obj.OperPosition=$p($g(InputStr),Separate,12)
	Set Obj.OperOfHaemorrhage=$p($g(InputStr),Separate,13)
	Set Obj.DataSource=$p($g(InputStr),Separate,14)
	//手术关联院感报告
	Set RepID=0,IsOprInf="N"  ;院感报告ID 
	For {
		Set RepID=$O(^DHCMed.NINFi("InfRep",0,"IndexPaadm",Paadm,RepID))
		Quit:RepID=""
		
		Set SubID=0
		For {
			Set SubID=$O(^DHCMed.NINF("InfRep",RepID,"Opr",SubID))	
			Quit:SubID=""
				
			Set SubOprID=RepID_"||"_SubID
			Set ObjOpr=##class(DHCMed.NINF.Rep.InfReportOpr).GetObjById(SubOprID)
			Continue:'$IsObject(ObjOpr)
			Set OprDate=ObjOpr.OperStartDate
			If (OprDate=OperDate){
				Set IsOprInf="Y"  ;手术日期相等说明是本次手术感染
				Set RepObj=##Class(DHCMed.NINF.Rep.InfReport).%OpenId(RepID)
				Continue:'$IsObject(RepObj)
				Do Obj.ReportList.Insert(RepObj)
			}
		}
	}	
	Set Obj.IsInf=IsOprInf
	Set sc=Obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set Rtn=-1
	} Else {
		Set Rtn=Obj.%Id()
	}
	Do Obj.%Close()
	Quit Rtn
}

/// 描述：根据Paadm删除记录
/// Debug:W ##Class(DHCMed.NINF.Srv.InfStatOperInfo).DeleteByPaadm(277)
ClassMethod DeleteByPaadm(Paadm As %String)
{
	New (Paadm)
	Set NPaadm=" "_Paadm,Count=0
	Set ID=0
	For {
		Set ID=$O(^DHCMed.NINF.Srv.InfStatOperI("IndexOfPaadm",NPaadm,ID))	
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
	Set sc = ##class(DHCMed.NINF.Srv.InfStatOperInfo).%DeleteId(ID)
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
<Data name="InfStatOperInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Paadm</Value>
</Value>
<Value name="3">
<Value>OperationName</Value>
</Value>
<Value name="4">
<Value>OperationType</Value>
</Value>
<Value name="5">
<Value>Operator</Value>
</Value>
<Value name="6">
<Value>OperDate</Value>
</Value>
<Value name="7">
<Value>Duration</Value>
</Value>
<Value name="8">
<Value>ASARank</Value>
</Value>
<Value name="9">
<Value>CutType</Value>
</Value>
<Value name="10">
<Value>OperRank</Value>
</Value>
<Value name="11">
<Value>NarcosisType</Value>
</Value>
<Value name="12">
<Value>OperPosition</Value>
</Value>
<Value name="13">
<Value>OperOfHaemorrhage</Value>
</Value>
<Value name="14">
<Value>DataSource</Value>
</Value>
<Value name="15">
<Value>ReportList</Value>
</Value>
<Value name="16">
<Value>IsInf</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Srv.InfStatOperD</DataLocation>
<DefaultData>InfStatOperInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Srv.InfStatOperD</IdLocation>
<IndexLocation>^DHCMed.NINF.Srv.InfStatOperI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Srv.InfStatOperS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
