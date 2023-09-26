/// 名称: DHCMA.IMP.IP.URTOperReg
/// 描述: 非计划重返手术登记表
/// 编写者：fcz
/// 编写日期: 2020-5-15
Class DHCMA.IMP.IP.URTOperReg Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 登记主表ID
Property RegisterDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 首次手术ID
Property FirstOperID As %String;

/// 首次手术术中及术后情况
Property FirstOperState As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 再次手术ID
Property ReoperID As %String;

/// 再次手术原因
Property ReoperReason As %String;

/// 再次手术后预计情况
Property ReoperState As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 再次手术原因分析
Property ReoperCause As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 改进措施
Property Improvement As %String(MAXLEN = 2000, TRUNCATE = 1);

Index IdxofRegisterDr On RegisterDr [ Unique ];

/// Creator：     dsp
/// CreatDate：   2020-08-10
/// Description:  更新非计划重返手术登记表
/// Table：       DHCMA.IMP.IP.URTOperReg
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.URTOperReg).Update("^9^^^9^古典风格的^42^80^发生的发生的^水费水电费^Submit^")  
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"
	Set ID          = $p(aInputStr,aSeparete,1)
	Set RegisterDr     = $p(aInputStr,aSeparete,2)
	Set FirstOperID     = $p(aInputStr,aSeparete,3)
	Set FirstOperState 	= $p(aInputStr,aSeparete,4)
	Set ReoperID 	= $p(aInputStr,aSeparete,5)
	Set ReoperReason = $p(aInputStr,aSeparete,6)
	Set ReoperState    = $p(aInputStr,aSeparete,7)
	Set ReoperCause= $P(aInputStr,aSeparete,8)
	Set Improvement = $p(aInputStr,aSeparete,9)
	
	//根据ID判断是添加还是修改
	If ID="" { 
		Set obj=##class(DHCMA.IMP.IP.URTOperReg).%New()
	}Else{
		Set obj=##class(DHCMA.IMP.IP.URTOperReg).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	
	//写入数据
	Set obj.RegisterDr   	 = RegisterDr      
	Set obj.FirstOperID      = FirstOperID
	Set obj.FirstOperState 	 = FirstOperState
	Set obj.ReoperID   		 = ReoperID
	Set obj.ReoperReason     = ReoperReason
	Set obj.ReoperState     = ReoperState
	Set obj.ReoperCause = ReoperCause
	Set obj.Improvement = Improvement
	
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

/// Creator：     dsp
/// CreatDate：   2020-08-20
/// Description:  审核更新非计划重返手术登记表
/// Table：       DHCMA.IMP.IP.URTOperReg
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.URTOperReg).Update("^001^项目类型1^A^D")  
ClassMethod Check(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"
	Set ID          = $p(aInputStr,aSeparete,1)
	Set ReportStatus  = $P(aInputStr,aSeparete,2)
	Set CheckOpinion  = $p(aInputStr,aSeparete,3)
	Set CheckUser     = $P(aInputStr,aSeparete,4)
	Set CheckDate     = $p(aInputStr,aSeparete,5)
	Set CheckTime     = $p(aInputStr,aSeparete,6)
	
	
	Set:CheckDate'="" CheckDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(CheckDate)
	Set:CheckTime[":" CheckTime = $zth(CheckTime,1)
	Set:CheckTime="" CheckTime=$p($h,",",2)
	
	Set obj=##class(DHCMA.IMP.IP.URTOperReg).%OpenId(ID)
	
	Quit:'$IsObject(obj) return
	
	
	//写入数据
	Set obj.ReportStatus   = ReportStatus
	Set obj.CheckOpinion   = CheckOpinion
	Set obj.CheckUser = CheckUser
	Set obj.CheckDate = CheckDate
	Set obj.CheckTime = CheckTime
	
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

/// Creator：     dsp
/// CreatDate：   2020-08-10
/// Description:  根据ID获取非计划重返手术登记表信息
/// Table：       DHCMA.IMP.IP.URTOperReg
/// Input：       aId :  DHCMA.IMP.IP.URTOperReg.ID
/// Return：      返回obj
/// w ##class( DHCMA.IMP.IP.OperaCompReg).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.IP.URTOperReg
{
	New (aId)
	Quit:'##class(DHCMA.IMP.IP.URTOperReg).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.IP.URTOperReg).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     dsp
/// CreatDate：   2020-08-10
/// Description:  删除非计划重返手术登记表
/// Table：       DHCMA.IMP.IP.URTOperReg
/// Input：       aId :  DHCMA.IMP.IP.URTOperReg.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.OperaCompReg).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.IP.URTOperReg).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     dsp
/// CreatDate：   2020-09-29
/// Description:  查询是否存在登记主表的非计划重返手术信息
/// Table：       DHCMA.IMP.IP.URTOperReg
/// Input：       aRegisterDr
/// Return：      成功：返回obj，失败：返回""
/// w ##class(DHCMA.IMP.IP.URTOperReg).GetObjByRegisterDr(1)
ClassMethod GetObjByRegisterDr(aRegisterDr As %String) As DHCMA.IMP.IP.URTOperReg
{
	New (aRegisterDr)
	Set objURTOperReg=""
	
	Set xURTOperRegID = ""
	For{
		b ;
		Set xURTOperRegID = $O(^MA.IMP.IPURTOperRegI("IdxofRegisterDr"," "_+aRegisterDr,xURTOperRegID))
		Quit:xURTOperRegID=""
		b ;1
		Set objURTOperReg = ..GetObjById(xURTOperRegID)
		b ;2
	}
	Quit objURTOperReg
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RegisterDr</Value>
</Value>
<Value name="3">
<Value>FirstOperID</Value>
</Value>
<Value name="4">
<Value>FirstOperState</Value>
</Value>
<Value name="5">
<Value>ReoperID</Value>
</Value>
<Value name="6">
<Value>ReoperReason</Value>
</Value>
<Value name="7">
<Value>ReoperState</Value>
</Value>
<Value name="8">
<Value>ReoperCause</Value>
</Value>
<Value name="9">
<Value>Improvement</Value>
</Value>
</Data>
<DataLocation>^MA.IMP.IPURTOperRegD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^MA.IMP.IPURTOperRegD</IdLocation>
<IndexLocation>^MA.IMP.IPURTOperRegI</IndexLocation>
<StreamLocation>^MA.IMP.IPURTOperRegDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
