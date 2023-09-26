/// 名称: DHCHAI.IR.OccExpReg
/// 描述: 职业暴露（occupational exposure to infectious materials）
/// 编写者：zhufei
/// 编写日期: 2018-04-25
Class DHCHAI.IR.OccExpReg Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 更新日志
Relationship ChildLog As DHCHAI.IR.OccExpRegLog [ Cardinality = children, Inverse = Parref ];

/// 内容扩展
Relationship ChildExt As DHCHAI.IR.OccExpRegExt [ Cardinality = children, Inverse = Parref ];

/// 血清学检查
Relationship ChildLab As DHCHAI.IR.OccExpRegLab [ Cardinality = children, Inverse = Parref ];

/// 登记类型
Property OERegTypeDr As DHCHAI.IR.OccExpType;

/// 登记日期
Property OERegDate As %Date;

/// 登记时间
Property OERegTime As %Time;

/// 登记科室
Property OERegLocDr As DHCHAI.BT.Location;

/// 登记人
Property OERegUserDr As DHCHAI.BT.SysUser;

/// 状态
Property OEStatusDr As DHCHAI.BT.Dictionary;

/// 当事人
Property OEExposerDr As DHCHAI.BT.SysUser;

/// 姓名
Property OEName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 工号（登记号）
Property OERegNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 性别（M男、F女、O其他）
Property OESex As %String(DISPLAYLIST = ",M,F,O", VALUELIST = ",M,F,O") [ Required ];

/// 出生日期
Property OEBirthday As %Date;

/// 年龄
Property OEAge As %String(MAXLEN = 100, TRUNCATE = 1);

/// 工龄
Property OEWorkAge As %String(MAXLEN = 100, TRUNCATE = 1);

/// 职别
Property OEDuty As %String(MAXLEN = 100, TRUNCATE = 1);

/// 科室
Property OEExpLocDr As DHCHAI.BT.Location;

/// 发生日期
Property OEExpDate As %Date;

/// 发生时间
Property OEExpTime As %Time;

/// 发生地点
Property OEExpAddr As %String(MAXLEN = 200, TRUNCATE = 1);

/// 联系电话
Property OETelPhone As %String(MAXLEN = 100, TRUNCATE = 1);

/// 追踪检测(新)
Property OELabList As %String(MAXLEN = 100, TRUNCATE = 1);

/// 登记类型 + 登记日期
Index IndexRegTypeDate On (OERegTypeDr As Exact, OERegDate);

/// 登记类型 + 暴露日期
Index IndexTypeExpDate On (OERegTypeDr As Exact, OEExpDate);

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  根据ID取职业暴露
/// Table：       DHCHAI.IR.OccExpReg
/// Input：       aId : DHCHAI.IR.OccExpReg.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.OccExpReg).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.OccExpReg
{
	New (aId)
	Quit:'##class(DHCHAI.IR.OccExpReg).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.OccExpReg).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// 职业暴露条码
/// w ##class(DHCHAI.IR.OccExpReg).GetSpenBarCode("6",1)
ClassMethod GetSpenBarCode(aReportID As %String, aIndex As %String) As %String
{
	New (aReportID,aIndex)
	Set return=""
	Quit:aReportID="" return
	
	Set RepBarCode = ..GetBarCode(aReportID)
	Set BarCode=RepBarCode_$s($l(aIndex)<2:"0"_aIndex,1:aIndex)
	Set return=BarCode
	Quit return
}

/// 职业暴露条码生成条码规则
/// 6位条码,前边自动补零
/// w ##class(DHCHAI.IR.OccExpReg).GetBarCode("1")
ClassMethod GetBarCode(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	
	Set SSHospCode=""
	Set RepList=$g(^DHCHAI.IR.OccExpRegD(aReportID))
	Quit:RepList="" return
	
	Set BarCode=aReportID
	Set BarCode="000000"_BarCode
	Set return=$e(BarCode,$l(BarCode)-5,$l(BarCode))
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  更新职业暴露
/// Table：       DHCHAI.IR.OccExpReg
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OccExpReg).Update("^1^^^117^^1^1^hs^hs^F^^20^2^护士^^2018-06-02^10:50^科室")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
    Set ID			= $p(aInputStr,aSeparete,1)
	Set RegTypeDr   = $p(aInputStr,aSeparete,2)
	Set RegDate		= $p(aInputStr,aSeparete,3)
	Set RegTime	    = $p(aInputStr,aSeparete,4)
	Set RegLocDr	= $p(aInputStr,aSeparete,5)
	Set RegUserDr	= $p(aInputStr,aSeparete,6)
	Set StatusDr    = $p(aInputStr,aSeparete,7)
	Set ExposerDr	= $p(aInputStr,aSeparete,8)
	Set Name	    = $p(aInputStr,aSeparete,9)
	Set RegNo		= $p(aInputStr,aSeparete,10)
	Set Sex		    = $p(aInputStr,aSeparete,11)
	Set Birthday	= $p(aInputStr,aSeparete,12)
	Set Age	        = $p(aInputStr,aSeparete,13)
	Set WorkAge		= $p(aInputStr,aSeparete,14)
	Set Duty		= $p(aInputStr,aSeparete,15)
	Set ExpLocDr    = $p(aInputStr,aSeparete,16)
	Set ExpDate	    = $p(aInputStr,aSeparete,17)
	Set ExpTime		= $p(aInputStr,aSeparete,18)
	Set ExpAddr		= $p(aInputStr,aSeparete,19)
	Set TelPhone    = $p(aInputStr,aSeparete,20)
	Quit:(RegTypeDr="")||(ExpDate="")||(Name="") return

	Set Name = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Name)  //去掉特殊字符
	Set:RegDate'="" RegDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RegDate)
	Set:RegDate="" RegDate=+$h  
	Set:RegTime[":" RegTime=$zth(RegTime,1)
	Set:RegTime="" RegTime=+$p($h,",",2)
	
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(Birthday)
	Set:ExpDate'="" ExpDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ExpDate)	
	Set:ExpTime[":" ExpTime=$zth(ExpTime,1)
	
	Set objRegType = ##class(DHCHAI.IR.OccExpType).GetObjById(RegTypeDr)
	Quit:'$IsObject(objRegType) return
	Set objRegLoc = ##class(DHCHAI.BT.Location).GetObjById(RegLocDr)
	Set objRegUser = ##class(DHCHAI.BT.SysUser).GetObjById(RegUserDr)
	Set objStatus = ##class(DHCHAI.BT.Dictionary).GetObjById(StatusDr)
	Set objExposer = ##class(DHCHAI.BT.SysUser).GetObjById(ExposerDr)
	Set objExpLoc = ##class(DHCHAI.BT.Location).GetObjById(ExpLocDr)
	If ID="" {
		Set obj=##class(DHCHAI.IR.OccExpReg).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.OccExpReg).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.OERegTypeDr  = objRegType   
	Set obj.OERegDate	 = RegDate		
	Set obj.OERegTime	 = RegTime	    
	Set:(ID="") obj.OERegLocDr = objRegLoc
	Set:(ID="") obj.OERegUserDr = objRegUser	
	Set obj.OEStatusDr   = objStatus    
	Set obj.OEExposerDr  = objExposer	
	Set obj.OEName	     = Name	    
	Set obj.OERegNo	     = RegNo		
	Set obj.OESex		 = Sex		    
	Set obj.OEBirthday	 = Birthday	
	Set obj.OEAge	     = Age	        
	Set obj.OEWorkAge	 = WorkAge		
	Set obj.OEDuty		 = Duty		
	Set obj.OEExpLocDr   = objExpLoc    
	Set obj.OEExpDate	 = ExpDate	    
	Set obj.OEExpTime	 = ExpTime		
	Set obj.OEExpAddr	 = ExpAddr	
	Set obj.OETelPhone	 = TelPhone
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  删除职业暴露
/// Table：       DHCHAI.IR.OccExpReg
/// Input：       aId : DHCHAI.IR.OccExpReg.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OccExpReg).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.OccExpReg).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2021-09-17
/// Description:  保存报告追踪检测
/// Table：       DHCHAI.IR.OccExpReg
/// Input：       aRepID,aLabList
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OccExpReg).SaveOELabList(1,"HBV")
ClassMethod SaveOELabList(aRepID As %String, aLabList As %String) As %String
{
	New (aRepID,aLabList)
	Set return=-1
	//打开报告
	Set obj=##class(DHCHAI.IR.OccExpReg).%OpenId(aRepID)
	Quit:'$IsObject(obj) return
	Set obj.OELabList	 = aLabList
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2021-09-17
/// Description:  获取报告追踪检测
/// Table：       DHCHAI.IR.OccExpReg
/// Input：       aRepID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OccExpReg).GetOELabList(1)
ClassMethod GetOELabList(aRepID) As %String
{
	New (aRepID)
	Set return=""
	Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(aRepID)
	Quit:'$IsObject(objReg) return
	
	Set LabList=objReg.OELabList
	Quit LabList
}

Storage Default
{
<Data name="OccExpRegDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OERegTypeDr</Value>
</Value>
<Value name="3">
<Value>OERegDate</Value>
</Value>
<Value name="4">
<Value>OERegTime</Value>
</Value>
<Value name="5">
<Value>OERegLocDr</Value>
</Value>
<Value name="6">
<Value>OERegUserDr</Value>
</Value>
<Value name="7">
<Value>OEStatusDr</Value>
</Value>
<Value name="8">
<Value>OEExposerDr</Value>
</Value>
<Value name="9">
<Value>OEName</Value>
</Value>
<Value name="10">
<Value>OERegNo</Value>
</Value>
<Value name="11">
<Value>OESex</Value>
</Value>
<Value name="12">
<Value>OEBirthday</Value>
</Value>
<Value name="13">
<Value>OEAge</Value>
</Value>
<Value name="14">
<Value>OEWorkAge</Value>
</Value>
<Value name="15">
<Value>OEDuty</Value>
</Value>
<Value name="16">
<Value>OEExpLocDr</Value>
</Value>
<Value name="17">
<Value>OEExpDate</Value>
</Value>
<Value name="18">
<Value>OEExpTime</Value>
</Value>
<Value name="19">
<Value>OEExpAddr</Value>
</Value>
<Value name="20">
<Value>OETelPhone</Value>
</Value>
<Value name="21">
<Value>OELabList</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.OccExpRegD</DataLocation>
<DefaultData>OccExpRegDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.OccExpRegD</IdLocation>
<IndexLocation>^DHCHAI.IR.OccExpRegI</IndexLocation>
<StreamLocation>^DHCHAI.IR.OccExpRegS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
