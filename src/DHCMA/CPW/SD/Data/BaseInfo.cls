Class DHCMA.CPW.SD.Data.BaseInfo Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 就诊ID
Property EpisodeID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 病人ID
Property PatientID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 就诊类型（O门诊、E急诊、I住院）
Property AdmType As %String(DISPLAYLIST = ",O,E,I,H", VALUELIST = ",O,E,I,H") [ Required ];

/// 就诊状态（预住院P、在院A、出院D、退院C、作废U）
Property VisitStatus As %String(DISPLAYLIST = ",A,D,C,U,P", VALUELIST = ",A,D,C,U,P") [ Required ];

/// 患者姓名
Property PatName As %String;

/// 病案号
Property MrNo As %String(MAXLEN = 50, TRUNCATE = 1);

/// 性别（M男、F女、O其他）
Property Sex As %String(DISPLAYLIST = ",M,F,O", VALUELIST = ",M,F,O");

/// 民族
Property Nation As %String(MAXLEN = 50, TRUNCATE = 1);

/// 出生日期
Property Birthday As %String;

/// 年龄
Property Age As %String(MAXLEN = 50, TRUNCATE = 1);

/// 身份证号码
Property IDNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 死亡标志
Property IsDeath As %Boolean [ Required ];

/// 入院日期时间
Property AdmDateT As %String;

/// 就诊科室
Property AdmLocID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 就诊科室Desc
Property AdmLocDesc As %String(MAXLEN = 50, TRUNCATE = 1);

/// 主管医生姓名
Property AdmDocName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 出院日期时间
Property DischDateT As %String;

/// 质控医师
Property CheckDoc As %String;

/// 质控护士
Property CheckNur As %String;

/// 主治医师
Property ClinicDoc As %String;

/// 责任护士
Property ClinicNur As %String;

/// 是否出院后31天内重复住院
Property ReAdm31 As %String;

/// 发病日期时间
Property OcurDateT As %String;

/// 到达本院急诊或者门诊日期时间
Property OEDateT As %String;

/// 入住CCU日期时间
Property InCCUDateT As %String;

/// 离开CCU日期时间
Property OutCCUDateT As %String;

/// 入住卒中中心/ICU日期时间
Property InICUDateT As %String;

/// 离开卒中中心/ICU日期时间
Property OutICUDateT As %String;

/// 费用支付方式
Property PayType As %String;

/// 收入住院途径
Property InHosWay As %String;

/// 到院交通工具
Property InHosTrans As %String;

/// 离院方式
Property OutHosWay As %String;

Index IdxAdm On EpisodeID As Exact;

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Data.BaseInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Data.BaseInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Data.BaseInfo).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

ClassMethod GetFormatObjById(aId As %String) As DHCMA.CPW.SD.Data.BaseInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Data.BaseInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Data.BaseInfo).%OpenId(aId)
	//数据格式处理
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zgz
/// CreatDate：   2021-05-20
/// Description:  更新基本信息
/// Table：       DHCMA.CPW.SD.Data.BaseInfo
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.BaseInfo).Update()
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set EpisodeID	= $p(aInputStr,aSeparete,1)
	Set PatientID	= $p(aInputStr,aSeparete,2)
	Set AdmType		= $p(aInputStr,aSeparete,3)		
	Set VisitStatus	= $p(aInputStr,aSeparete,4)
	Set MrNo		= $p(aInputStr,aSeparete,5)	
	Set Sex			= $p(aInputStr,aSeparete,6)
	Set Nation		= $p(aInputStr,aSeparete,7)		
	Set Birthday	= $p(aInputStr,aSeparete,8)
	Set Age			= $p(aInputStr,aSeparete,9)
	Set IDNo		= $p(aInputStr,aSeparete,10)	
	Set IsDeath		= $p(aInputStr,aSeparete,11)		
	Set AdmDateT	= $p(aInputStr,aSeparete,12)
	Set AdmLocID	= $p(aInputStr,aSeparete,13)
	Set AdmLocDesc	= $p(aInputStr,aSeparete,14)
	Set AdmDocName	= $p(aInputStr,aSeparete,15)
	Set DischDateT	= $p(aInputStr,aSeparete,16)
	Set CheckDoc	= $p(aInputStr,aSeparete,17)
	Set CheckNur	= $p(aInputStr,aSeparete,18)
	Set ClinicDoc	= $p(aInputStr,aSeparete,19)
	Set ClinicNur	= $p(aInputStr,aSeparete,20)
	Set ReAdm31		= $p(aInputStr,aSeparete,21)		
	Set OcurDateT	= $p(aInputStr,aSeparete,22)
	Set OEDateT		= $p(aInputStr,aSeparete,23)		
	Set InCCUDateT	= $p(aInputStr,aSeparete,24)
	Set OutCCUDateT	= $p(aInputStr,aSeparete,25)
	Set InICUDateT	= $p(aInputStr,aSeparete,26)
	Set OutICUDateT	= $p(aInputStr,aSeparete,27)
	Set PayType		= $p(aInputStr,aSeparete,28)		
	Set InHosWay	= $p(aInputStr,aSeparete,29)
	Set InHosTrans	= $p(aInputStr,aSeparete,30)
	Set OutHosWay	= $p(aInputStr,aSeparete,31)
	Set PatName		= $p(aInputStr,aSeparete,32)
	Quit:(EpisodeID="") return
	Set ID=$o(^DHCMA.CPW.SD.Data.BaseInfoI("IdxAdm",EpisodeID,0))
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Data.BaseInfo).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Data.BaseInfo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.EpisodeID	 = EpisodeID	
	Set obj.PatientID	 = PatientID	
	Set obj.PatName		 = PatName
	Set obj.AdmType		 = AdmType		
	Set obj.VisitStatus	 = VisitStatus	
	Set obj.MrNo		 = MrNo		
	Set obj.Sex		 	 = Sex		
	Set obj.Nation		 = Nation		
	Set obj.Birthday	 = Birthday	
	Set obj.Age		     = Age		
	Set obj.IDNo		 = IDNo		
	Set obj.IsDeath		 = IsDeath		
	Set obj.AdmDateT	 = AdmDateT	
	Set obj.AdmLocID	 = AdmLocID	
	Set obj.AdmLocDesc	 = AdmLocDesc	
	Set obj.AdmDocName	 = AdmDocName	
	Set obj.DischDateT	 = DischDateT	
	Set obj.CheckDoc	 = CheckDoc	
	Set obj.CheckNur	 = CheckNur	
	Set obj.ClinicDoc	 = ClinicDoc	
	Set obj.ClinicNur	 = ClinicNur	
	Set obj.ReAdm31		 = ReAdm31		
	Set obj.OcurDateT	 = OcurDateT	
	Set obj.OEDateT		 = OEDateT		
	Set obj.InCCUDateT	 = InCCUDateT	
	Set obj.OutCCUDateT	 = OutCCUDateT	
	Set obj.InICUDateT	 = InICUDateT	
	Set obj.OutICUDateT	 = OutICUDateT	
	Set obj.PayType		 = PayType		
	Set obj.InHosWay	 = InHosWay	
	Set obj.InHosTrans	 = InHosTrans	
	Set obj.OutHosWay	 = OutHosWay	     
	//检查Save是否成功
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Description:  删除基本信息
/// Table：       DHCMA.CPW.SD.Data.BaseInfo
/// Input：       aId :  DHCMA.CPW.SD.Data.BaseInfo.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.BaseInfo).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Data.BaseInfo).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="BaseInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>AdmType</Value>
</Value>
<Value name="5">
<Value>VisitStatus</Value>
</Value>
<Value name="6">
<Value>MrNo</Value>
</Value>
<Value name="7">
<Value>Sex</Value>
</Value>
<Value name="8">
<Value>Nation</Value>
</Value>
<Value name="9">
<Value>Birthday</Value>
</Value>
<Value name="10">
<Value>Age</Value>
</Value>
<Value name="11">
<Value>IDNo</Value>
</Value>
<Value name="12">
<Value>IsDeath</Value>
</Value>
<Value name="13">
<Value>AdmDateT</Value>
</Value>
<Value name="14">
<Value>AdmLocID</Value>
</Value>
<Value name="15">
<Value>AdmLocDesc</Value>
</Value>
<Value name="16">
<Value>AdmDocName</Value>
</Value>
<Value name="17">
<Value>DischDateT</Value>
</Value>
<Value name="18">
<Value>CheckDoc</Value>
</Value>
<Value name="19">
<Value>CheckNur</Value>
</Value>
<Value name="20">
<Value>ClinicDoc</Value>
</Value>
<Value name="21">
<Value>ClinicNur</Value>
</Value>
<Value name="22">
<Value>ReAdm31</Value>
</Value>
<Value name="23">
<Value>OcurDateT</Value>
</Value>
<Value name="24">
<Value>OEDateT</Value>
</Value>
<Value name="25">
<Value>InCCUDateT</Value>
</Value>
<Value name="26">
<Value>OutCCUDateT</Value>
</Value>
<Value name="27">
<Value>InICUDateT</Value>
</Value>
<Value name="28">
<Value>OutICUDateT</Value>
</Value>
<Value name="29">
<Value>PayType</Value>
</Value>
<Value name="30">
<Value>InHosWay</Value>
</Value>
<Value name="31">
<Value>InHosTrans</Value>
</Value>
<Value name="32">
<Value>OutHosWay</Value>
</Value>
<Value name="33">
<Value>PatName</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Data.BaseInfoD</DataLocation>
<DefaultData>BaseInfoDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Data.BaseInfoD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Data.BaseInfoI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Data.BaseInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
