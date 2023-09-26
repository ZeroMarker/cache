/// 名称: DHCHAI.DP.PAAdmTrans
/// 描述: 转科记录
/// 编写者：liyi
/// 编写日期: 2017-01-12
Class DHCHAI.DP.PAAdmTrans Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// HIS转科记录
Property PATransID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 就诊记录
Property PAEpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 转科分类（转科E、转病区W、转床B、...）
Property PATransType As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 转科科室
Property PATransLocDr As DHCHAI.BT.Location;

/// 转科床位(每次转病区时把床位记下)
Property PATransBedDr As DHCHAI.BT.PACBed;

/// 关联科室（主要用于转病区/转床时，记录所在科室） add by zf
Property PALinkLocDr As DHCHAI.BT.Location;

/// 转科日期
Property PATransDate As %Date;

/// 转科时间
Property PATransTime As %Time;

/// 在科天数（在科病人未出科值为-1）
Property PATransDays As %Integer;

/// 出科日期
Property PAOutLocDate As %Date;

/// 出科时间
Property PAOutLocTime As %Time;

/// 更新日期
Property PAUpdateDate As %Date [ Required ];

/// 更新时间
Property PAUpdateTime As %Time [ Required ];

/// 主管医生（ID|Code|Desc）
Property PAAdmDoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊记录索引
Index IndexEpisodeDr On PAEpisodeDr;

/// 转科记录索引
Index IndexTransID On (PATransType As Exact, PAEpisodeDr, PATransID As Exact);

/// 在科天数+转科日期索引
Index IndexTransDaysDate On (PATransType As Exact, PATransDays As Exact, PATransDate);

/// 在科天数+转科日期索引
Index IndexTransDaysOutDate On (PATransType As Exact, PATransDays As Exact, PAOutLocDate);

/// 出科日期索引
Index IndexOutLocDate On (PATransType As Exact, PAOutLocDate, PAOutLocTime);

/// 就诊记录 + 转科日期索引
Index IndexEpisodeDrTransDate On (PATransType As Exact, PAEpisodeDr, PATransDate);

/// 就诊记录 + 转科日期时间索引
Index IndexEpisTransDateTime On (PATransType As Exact, PAEpisodeDr, PATransDate, PATransTime);

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取转科记录
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       ID:    DHCHAI.DP.PAAdmTrans.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.PAAdmTrans).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.PAAdmTrans
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.PAAdmTrans).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.PAAdmTrans).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-29
/// Description:  根据XCode取转科信息
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aTransType : 转科类型（转科E、转病区W、转床B）
///               aXCode : DHCHAI.DP.PAAdmTrans.XCode
/// Return：      返回obj
/// w ##class(DHCHAI.DP.PAAdmTrans).GetObjByTransID(1)
ClassMethod GetObjByTransID(aTransType As %String, aEpisodeDr As %String, aTransID As %String) As DHCHAI.DP.PAAdmTrans
{
	New (aTransType,aEpisodeDr,aTransID)
	Set return = ""
	Quit:(aTransType="")||(aEpisodeDr="")||(aTransID="") return
	
	Set id=$o(^DHCHAI.DP.PAAdmTransI("IndexTransID",$zcvt(aTransType,"U"),aEpisodeDr,aTransID,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新转科记录
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.PAAdmTrans).Update("^1||1^1^6^0^2017-07-23^12:00:00^3^2017-07-25^14:00:00^64489^60207")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set TransID		= $p(InStr,aSeparete,2)
	Set EpisodeDr	= $p(InStr,aSeparete,3)
	Set TransType	= $p(InStr,aSeparete,4)
	Set TransLocDr	= $p(InStr,aSeparete,5)
	Set TransBedDr	= $p(InStr,aSeparete,6)
	Set TransDate	= $p(InStr,aSeparete,7)
	Set TransTime	= $p(InStr,aSeparete,8)
	Set TransDays	= $p(InStr,aSeparete,9)
	Set OutLocDate	= $p(InStr,aSeparete,10)
	Set OutLocTime	= $p(InStr,aSeparete,11)
	Set UpdateDate	= $p(InStr,aSeparete,12)
	Set UpdateTime	= $p(InStr,aSeparete,13)
	Set PAAdmDoc	= $p(InStr,aSeparete,14)
	Set:TransDate["-" TransDate = $zdh(TransDate,3)
	Set:TransTime[":" TransTime = $zth(TransTime,1)
	Set:OutLocDate["-" OutLocDate = $zdh(OutLocDate,3)
	Set:OutLocTime[":" OutLocTime = $zth(OutLocTime,1)
	Set:UpdateDate["-" UpdateDate = $zdh(UpdateDate,3)
	Set:UpdateTime[":" UpdateTime = $zth(UpdateTime,1)
	Quit:(TransID="")||(EpisodeDr="")||(TransDate="")||(TransTime="") return
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objAdm) return
	Set objTransLoc = ##class(DHCHAI.BT.Location).GetObjById(TransLocDr)
	Set objTransBed = ##class(DHCHAI.BT.PACBed).GetObjById(TransBedDr)
	Set TransType=$zcvt(TransType,"U")
	
	//转科记录唯一性
	Set tID =$o(^DHCHAI.DP.PAAdmTransI("IndexTransID",TransType,EpisodeDr,TransID,0))
	Quit:(tID'="")&(ID'=tID) -100 
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.PAAdmTrans).%New()
	}else{
		Set obj=##class(DHCHAI.DP.PAAdmTrans).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.PATransID		= TransID
	Set obj.PAEpisodeDr		= objAdm
	Set obj.PATransType		= TransType
	Set obj.PATransLocDr	= objTransLoc
	Set obj.PATransBedDr	= objTransBed
	Set obj.PATransDate		= TransDate
	Set obj.PATransTime		= TransTime
	Set obj.PATransDays		= TransDays
	Set obj.PAOutLocDate	= OutLocDate
	Set obj.PAOutLocTime	= OutLocTime
	Set obj.PAUpdateDate	= UpdateDate
	Set obj.PAUpdateTime	= UpdateTime
	Set obj.PAAdmDoc		= PAAdmDoc
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-12-19
/// Description:  更新转科关联科室
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.PAAdmTrans).UpdateLinkLoc("1^11")
ClassMethod UpdateLinkLoc(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set LinkLocDr	= $p(InStr,aSeparete,2)
	Quit:(ID="")||(LinkLocDr="") return
	
	Set objLinkLoc=##class(DHCHAI.BT.Location).GetObjById(LinkLocDr)
	Quit:'$IsObject(objLinkLoc) return
	
	Set obj=##class(DHCHAI.DP.PAAdmTrans).%OpenId(ID)
	Quit:'$IsObject(obj) return
	
	Set obj.PALinkLocDr		= objLinkLoc
	Set obj.PAUpdateDate	= +$h
	Set obj.PAUpdateTime	= $p($h,",",2)
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除转科记录
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.PAAdmTrans).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// 删除出院日期后的转科记录
/// w ##class(DHCHAI.DP.PAAdmTrans).DeleteByDischDateTime(157)
ClassMethod DeleteByDischDateTime(aEpisodeDr As %String) As %String
{
	New (aEpisodeDr)
	Set return=0
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set DischDate=objEpisode.PADischDate
	Set DischTime=objEpisode.PADischTime
	Set VisitStatus=objEpisode.PAVisitStatus
	Set AdmDate=objEpisode.PAAdmDate
	Set AdmTime = objEpisode.PAAdmTime
	Set:VisitStatus="C" DischDate=AdmDate 
	Set:VisitStatus="C" DischTime=AdmTime 
	Quit:DischDate="" return
	
	Set xType=""
	For {
		Set xType=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xType))
		Quit:xType=""
		
		Set xDate=DischDate-1
		For {
			Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xType,aEpisodeDr,xDate))
			Quit:xDate=""
			
			Set xTime=""    //update 2022-01-20  Time=0，0点病人会遗漏
			For {
				Set xTime=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xType,aEpisodeDr,xDate,xTime))
				Quit:xTime=""
				Continue:(xDate=DischDate)&&(xTime<DischTime)
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xType,aEpisodeDr,xDate,xTime,xID))
					Quit:xID=""
					
					Do ..DeleteById(xID)
				}
			}
		}
	}
	Set return=1
	Quit return
}

/// 删除等待状态患者转科记录
/// w ##class(DHCHAI.DP.PAAdmTrans).DeleteByEpisodeID(157)
ClassMethod DeleteByEpisodeID(aEpisodeDr As %String) As %String
{
	New (aEpisodeDr)
	Set return=0
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objEpisode) return

	Set VisitStatus=objEpisode.PAVisitStatus
	Quit:VisitStatus'="P" return

	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDr",aEpisodeDr,xID))
		Quit:xID=""
		
		Do ..DeleteById(xID)
	}

	Set return=1
	Quit return
}

/// 删除已出院中间转科记录未结束的患者转科记录(手工修改转科记录前条转出日期晚于后条转入日期所致)
/// w ##class(DHCHAI.DP.PAAdmTrans).DeleteUnEndTrans(497)
ClassMethod DeleteUnEndTrans(aEpisodeDr As %String) As %String
{
	New (aEpisodeDr)
	Set return=0
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objEpisode) return

	Set VisitStatus=objEpisode.PAVisitStatus
	Quit:VisitStatus'="D" return
    
    Set LastDate=""
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDr",aEpisodeDr,xID),-1)
		Quit:xID=""
		Set TransInfo=$g(^DHCHAI.DP.PAAdmTransD(xID))
		Continue:TransInfo=""
		Set TransDate=$lg(TransInfo,10)
		Set:LastDate="" LastDate=TransDate    //最后一条是否转科结束
		Set TransDays=$lg(TransInfo,9)
		Continue:(TransDays'=-1)||(LastDate="")
		
		Do ..DeleteById(xID)
	}

	Set return=1
	Quit return
}

Storage Default
{
<Data name="PAAdmTransDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PATransID</Value>
</Value>
<Value name="3">
<Value>PAEpisodeDr</Value>
</Value>
<Value name="4">
<Value>PATransType</Value>
</Value>
<Value name="5">
<Value>PATransLocDr</Value>
</Value>
<Value name="6">
<Value>PATransBedDr</Value>
</Value>
<Value name="7">
<Value>PATransDate</Value>
</Value>
<Value name="8">
<Value>PATransTime</Value>
</Value>
<Value name="9">
<Value>PATransDays</Value>
</Value>
<Value name="10">
<Value>PAOutLocDate</Value>
</Value>
<Value name="11">
<Value>PAOutLocTime</Value>
</Value>
<Value name="12">
<Value>PAUpdateDate</Value>
</Value>
<Value name="13">
<Value>PAUpdateTime</Value>
</Value>
<Value name="14">
<Value>PALinkLocDr</Value>
</Value>
<Value name="15">
<Value>PAAdmDoc</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.PAAdmTransD</DataLocation>
<DefaultData>PAAdmTransDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.PAAdmTransD</IdLocation>
<IndexLocation>^DHCHAI.DP.PAAdmTransI</IndexLocation>
<StreamLocation>^DHCHAI.DP.PAAdmTransS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
