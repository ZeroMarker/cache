/// 名称: DHCMA.IMP.IP.IMPRegister
/// 描述: 重点患者登记主表
/// 编写者：fcz
/// 编写日期: 2020-5-15
Class DHCMA.IMP.IP.IMPRegister Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 操作日志
Relationship ChildLog As DHCMA.IMP.IP.IMPRegisterLog [ Cardinality = children, Inverse = Parref ];

/// 就诊号
Property EpisodeID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 类型（手术并发症1、非计划重返手术2、非计划重返住院3）
Property RegType As %Integer [ Required ];

/// 当前状态（"IMPRegStatus"  提交Submit、审核Check）
Property StatusDr As DHCMA.Util.BT.Dictionary;

/// 处置意见
Property Opinion As %String(MAXLEN = 500, TRUNCATE = 1);

/// 登记日期
Property RegDate As %Date;

/// 登记时间
Property RegTime As %Time;

/// 登记人ID（指向DHCMA.Util.EP.SSUser.OID）
Property RegUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 审核日期
Property CheckDate As %Date;

/// 审核时间
Property CheckTime As %Time;

/// 审核人（指向DHCMA.Util.EP.SSUser.OID）
Property CheckUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 筛查记录
Property IMPRecordDr As DHCMA.IMP.IP.IMPRecord;

/// 筛查记录
Index IdxofIMPRecordDr On IMPRecordDr [ Unique ];

/// 就诊号索引
Index IdxofEpisodeID On EpisodeID As Exact;

/// Creator：     dsp
/// CreatDate：   2020-09-28
/// Description:  更新重点患者登记表主表
/// Table：       DHCMA.IMP.IP.IMPRegister
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.IMPRegister).Update("^9^^^9^古典风格的^42^80^发生的发生的^水费水电费^Submit^")  
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"
	Set ID       = $p(aInputStr,aSeparete,1)
	Set EpisodeID= $p(aInputStr,aSeparete,2)
	Set RegType  = $p(aInputStr,aSeparete,3)
	Set StatusDr = $p(aInputStr,aSeparete,4)
	Set Opinion  = $p(aInputStr,aSeparete,5)
	Set RegDate  = $p(aInputStr,aSeparete,6)
	Set RegTime  = $P(aInputStr,aSeparete,7)
	Set RegUserID= $p(aInputStr,aSeparete,8)
	Set CheckDate = $p(aInputStr,aSeparete,9)
	Set CheckTime = $p(aInputStr,aSeparete,10)
	Set CheckUserID  = $P(aInputStr,aSeparete,11)
	Set IMPRecordDr  = $p(aInputStr,aSeparete,12)
	
	
	Set:IMPRecordDr'="" objIMPRecord = ##class(DHCMA.IMP.IP.IMPRecord).GetObjById(IMPRecordDr)
	Quit:'$IsObject(objIMPRecord) -2
	Set:StatusDr'="" objStatus = ##class(DHCMA.Util.BT.Dictionary).GetObjById(StatusDr)
	Quit:'$IsObject(objStatus) -2
	Set:RegDate'="" RegDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(RegDate)
	Set:RegTime[":" RegTime = $zth(RegTime,1)
	Set:RegDate="" RegDate=+$h
	Set:RegTime="" RegTime=$p($h,",",2)
	
	//根据ID判断是添加还是修改
	If ID="" { 
		Set obj=##class(DHCMA.IMP.IP.IMPRegister).%New()
	}Else{
		Set obj=##class(DHCMA.IMP.IP.IMPRegister).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	
	//写入数据
	Set obj.EpisodeID    = EpisodeID      
	Set obj.RegType      = RegType
	Set obj.StatusDr     = objStatus
	Set obj.Opinion      = Opinion
	Set obj.RegDate      = RegDate
	Set obj.RegTime 	 = RegTime
	Set obj.RegUserID    = RegUserID
	Set obj.CheckDate    = CheckDate
	Set obj.CheckTime    = CheckTime
	Set obj.CheckUserID  = CheckUserID
	Set obj.IMPRecordDr  = objIMPRecord
	
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
/// CreatDate：   2020-10-13
/// Description:  修改重点患者登记表主表状态
/// Table：       DHCMA.IMP.IP.IMPRegister
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.IMPRegister).Check("^9^^^9^古典风格的^42^80^发生的发生的^水费水电费^Submit^")  
ClassMethod Check(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"
	Set ID       = $p(aInputStr,aSeparete,1)
	Set EpisodeID= $p(aInputStr,aSeparete,2)
	Set RegType  = $p(aInputStr,aSeparete,3)
	Set StatusDr = $p(aInputStr,aSeparete,4)
	Set Opinion  = $p(aInputStr,aSeparete,5)
	Set RegDate  = $p(aInputStr,aSeparete,6)
	Set RegTime  = $P(aInputStr,aSeparete,7)
	Set RegUserID= $p(aInputStr,aSeparete,8)
	Set CheckDate = $p(aInputStr,aSeparete,9)
	Set CheckTime = $p(aInputStr,aSeparete,10)
	Set CheckUserID  = $P(aInputStr,aSeparete,11)
	Set IMPRecordDr  = $p(aInputStr,aSeparete,12)
	
	
	Set:IMPRecordDr'="" objIMPRecord = ##class(DHCMA.IMP.IP.IMPRecord).GetObjById(IMPRecordDr)
	Quit:'$IsObject(objIMPRecord) -2
	Set:StatusDr'="" objStatus = ##class(DHCMA.Util.BT.Dictionary).GetObjById(StatusDr)
	Quit:'$IsObject(objStatus) -2
	Set:CheckDate'="" CheckDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(CheckDate)
	Set:CheckTime[":" CheckTime = $zth(CheckTime,1)
	Set:CheckDate="" CheckDate=+$h
	Set:CheckTime="" CheckTime=$p($h,",",2)
	
	//根据ID判断是添加还是修改
	If ID="" { 
		Set obj=##class(DHCMA.IMP.IP.IMPRegister).%New()
	}Else{
		Set obj=##class(DHCMA.IMP.IP.IMPRegister).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	
	//写入数据
	Set obj.StatusDr     = objStatus
	Set obj.Opinion      = Opinion
	Set obj.CheckDate    = CheckDate
	Set obj.CheckTime    = CheckTime
	Set obj.CheckUserID  = CheckUserID
	
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
/// CreatDate：   2020-09-29
/// Description:  根据ID查询登记主表
/// Table：       DHCMA.IMP.IP.IMPRegister
/// Input：       aId :  DHCMA.IMP.IP.IMPRegister.ID
/// Return：      返回obj
/// w ##class( DHCMA.IMP.IP.IMPRegister).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.IP.OperCompReg
{
	New (aId)
	Quit:'##class(DHCMA.IMP.IP.IMPRegister).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.IP.IMPRegister).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     dsp
/// CreatDate：   2020-09-29
/// Description:  删除登记主表记录
/// Table：       DHCMA.IMP.IP.IMPRegister
/// Input：       aId :  DHCMA.IMP.IP.IMPRegister.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.IMPRegister).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.IP.IMPRegister).%DeleteId(aId)
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
/// Description:  查询登记主表记录
/// Table：       DHCMA.IMP.IP.IMPRegister
/// Input：       aEpisodeID  aRegType
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.IMPRegister).GetObjectByEpisodeID(1)
ClassMethod GetObjectByEpisodeID(aEpisodeID As %String, aRegType As %String)
{
	New (aEpisodeID,aRegType)
	
	Set obj=""
	Set xID=""
	For{
		Set xID = $o(^MA.IMP.IPIMPRegisterI("IdxofEpisodeID",$zcvt(aEpisodeID,"U"),xID))
		Quit:xID=""
		Set IMPRegobj=..GetObjById(xID)
		Quit:'$Isobject(IMPRegobj)
		Continue:aRegType'=IMPRegobj.RegType
		Set obj=IMPRegobj
	}
	Quit obj
}

/// Creator：     dsp
/// CreatDate：   2021-05-17
/// Description:  查询登记主表记录
/// Table：       DHCMA.IMP.IP.IMPRegister
/// Input：       aEpisodeID  aRegType
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.IMPRegister).GetObjectByRecord(1)
ClassMethod GetObjectByRecordDr(aIMPRecordDr As %String, aRegType As %String)
{
	New (aIMPRecordDr,aRegType)
	
	Set obj=""
	Set xID=""
	For{
		Set xID = $o(^MA.IMP.IPIMPRegisterI("IdxofIMPRecordDr",$zcvt(aIMPRecordDr,"U"),xID))
		Quit:xID=""
		Set IMPRegobj=..GetObjById(xID)
		Quit:'$Isobject(IMPRegobj)
		Continue:aRegType'=IMPRegobj.RegType
		Set obj=IMPRegobj
	}
	Quit obj
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>RegType</Value>
</Value>
<Value name="4">
<Value>StatusDr</Value>
</Value>
<Value name="5">
<Value>Opinion</Value>
</Value>
<Value name="6">
<Value>RegDate</Value>
</Value>
<Value name="7">
<Value>RegTime</Value>
</Value>
<Value name="8">
<Value>RegUserID</Value>
</Value>
<Value name="9">
<Value>CheckDate</Value>
</Value>
<Value name="10">
<Value>CheckTime</Value>
</Value>
<Value name="11">
<Value>CheckUserID</Value>
</Value>
<Value name="12">
<Value>IMPRecordDr</Value>
</Value>
</Data>
<DataLocation>^MA.IMP.IPIMPRegisterD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^MA.IMP.IPIMPRegisterD</IdLocation>
<IndexLocation>^MA.IMP.IPIMPRegisterI</IndexLocation>
<StreamLocation>^MA.IMP.IPIMPRegisterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
