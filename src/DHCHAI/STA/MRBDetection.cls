/// 名称: DHCHAI.STA.MRBDetection
/// 描述: 多重耐药菌检出情况统计
/// 编写者: mayanpeng
/// 编写日期: 2018-09-26
Class DHCHAI.STA.MRBDetection Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 科室
Property ECLocDr As DHCHAI.BT.Location;

/// 月份
Property ECMonth As %Date [ Required ];

/// 多重耐药菌DHCHAI.IR.CRuleMRB.ID/病原体DHCHAI.DP.LabBacteria.ID
Property ECMRBBactID As %String [ Required ];

/// 类型(1月数据/2季度数据/3年数据)
Property ECType As %String;

/// 是否多耐
Property ECIsMRB As %Boolean;

/// 例数
Property ECCount As %String(MAXLEN = 5, TRUNCATE = 1) [ Required ];

/// 更新日期
Property ECUpdateDate As %Date;

/// 更新时间
Property ECUpdateTime As %Time;

Index IndexLocMonTypeIsMRBID On (ECLocDr, ECMonth, ECType As Exact, ECIsMRB, ECMRBBactID As Exact);

/// Creator：     mayanpeng
/// CreatDate：   2018-09-27
/// Description:  根据ID取多重耐药菌检出情况
/// Table：       DHCHAI.STA.MRBDetection
/// Input：       aId : DHCHAI.STA.MRBDetection
/// Return：      返回obj
/// w ##class(DHCHAI.STA.MRBDetection).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.STA.MRBDetection
{
	New (aId)
	Quit:'##class(DHCHAI.STA.MRBDetection).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.STA.MRBDetection).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     mayanpeng
/// CreatDate：   2018-09-27
/// Description:  更新多重耐药菌检出情况
/// Table：       DHCHAI.STA.MRBDetection
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.STA.MRBDetection).Update("^599^64830^205^1^0^1^^","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID      	= $p(aInputStr,aSeparete,1)
	Set ECLocID	    = $p(aInputStr,aSeparete,2)
	Set ECMonth     = $p(aInputStr,aSeparete,3)
	Set ECMRBBactID	= $p(aInputStr,aSeparete,4)
	Set ECType		= +$p(aInputStr,aSeparete,5)
	Set ECIsMRB    	= +$p(aInputStr,aSeparete,6)
	Set ECCount  	= +$p(aInputStr,aSeparete,7)
	Set UpdateDate  = $p(aInputStr,aSeparete,8)
	Set UpdateTime  = $p(aInputStr,aSeparete,9)
	Set UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(UpdateDate)
	Set:UpdateDate="" UpdateDate=+$h
	Set:UpdateTime[":" UpdateTime=$zth(UpdateTime,1)
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
	Quit:(ECLocID="")||(ECMonth="")||(ECMRBBactID="")||(ECCount="")||(ECType=0) return
	
	Set ECMonth=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(ECMonth,1) //月份存当月的第一天
	Quit:ECMonth="" return
	Set ECMonth=$p(ECMonth,"^",1)
	Set:ECIsMRB'=1 ECIsMRB=0
	
	Set tID=$o(^DHCHAI.STA.MRBDetectionI("IndexLocMonTypeIsMRBID",ECLocID,ECMonth,ECType,ECIsMRB,ECMRBBactID,""))
	Set:(tID'="")&&(ID'=tID) ID=tID
	
	If ID="" {
		Set obj=##class(DHCHAI.STA.MRBDetection).%New()
	}Else{
		Set obj=##class(DHCHAI.STA.MRBDetection).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(ECLocID)
	Quit:'$IsObject(objLoc) return
	If (ECIsMRB=1){
		Set objMRB=##class(DHCHAI.IR.CRuleMRB).GetObjById(ECMRBBactID)
		Quit:'$IsObject(objMRB) return
	} Else {
		Set objBact=##class(DHCHAI.DP.LabBacteria).GetObjById(ECMRBBactID)
		Quit:'$IsObject(objBact) return
	}
	
	Set obj.ECLocDr    = objLoc
	Set obj.ECMonth    = ECMonth
	Set obj.ECMRBBactID= ECMRBBactID
	Set obj.ECType	   = ECType
	Set obj.ECIsMRB    = ECIsMRB
	Set obj.ECCount    = ECCount
	Set obj.ECUpdateDate= UpdateDate
	Set obj.ECUpdateTime= UpdateTime
	
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

/// Creator：     mayanpeng
/// CreatDate：   2018-09-27
/// Description:  删除多重耐药菌检出情况
/// Table：       DHCHAI.STA.MRBDetection
/// Input：       aId : DHCHAI.STA.MRBDetection.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.STA.MRBDetection).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.STA.MRBDetection).%DeleteId(aId)
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
<Data name="MRBDetectionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ECLocDr</Value>
</Value>
<Value name="3">
<Value>ECTime</Value>
</Value>
<Value name="4">
<Value>ECLocID</Value>
</Value>
<Value name="5">
<Value>ECIsMRB</Value>
</Value>
<Value name="6">
<Value>ECCount</Value>
</Value>
<Value name="7">
<Value>ECMonth</Value>
</Value>
<Value name="8">
<Value>ECMRBDr</Value>
</Value>
<Value name="9">
<Value>ECMRBBactID</Value>
</Value>
<Value name="10">
<Value>ECType</Value>
</Value>
<Value name="11">
<Value>ECUpdateDate</Value>
</Value>
<Value name="12">
<Value>ECUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.STA.MRBDetectionD</DataLocation>
<DefaultData>MRBDetectionDefaultData</DefaultData>
<IdLocation>^DHCHAI.STA.MRBDetectionD</IdLocation>
<IndexLocation>^DHCHAI.STA.MRBDetectionI</IndexLocation>
<StreamLocation>^DHCHAI.STA.MRBDetectionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
