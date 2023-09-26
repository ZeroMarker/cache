/// 名称: DHCMA.IMP.IP.IMPRecord
/// 描述: 重点患者筛查记录
/// 编写者：fcz
/// 编写日期: 2020-5-15
Class DHCMA.IMP.IP.IMPRecord Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 操作日志
Relationship ChildLog As DHCMA.IMP.IP.IMPRecordLog [ Cardinality = children, Inverse = Parref ];

/// 消息记录
Relationship ChildMsg As DHCMA.IMP.IP.IMPRecordMsg [ Cardinality = children, Inverse = Parref ];

/// 就诊号
Property EpisodeID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 关联上次就诊信息
Property LnkEpisInfo As %String(MAXLEN = 50, TRUNCATE = 1);

/// 关联上次手术信息
Property LnkOperInfo As %String(MAXLEN = 50, TRUNCATE = 1);

/// 重点患者分类
Property IMPCateDr As DHCMA.IMP.BT.IMPCategory [ Required ];

/// 记录码（唯一区分，例：非计划重返手术，手麻记录ID可作为唯一码）
Property IMPOrdNo As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 筛查关键词
Property IMPKeywords As %String(MAXLEN = 100, TRUNCATE = 1);

/// 特因分类
Property IMPReasonDr As DHCMA.IMP.BT.IMPReasonDic;

/// 责任科室（DHCMA.Util.EP.Location.OID）
Property OccuLocID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 责任病区（DHCMA.Util.EP.Location.OID）
Property OccuWardID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 责任医生（DHCMA.Util.EP.CareProv.OID）
Property OccuDocID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 发生日期
Property HappenDate As %Date;

/// 发生时间
Property HappenTime As %Time;

/// 当前状态（"IMPStatus" 自动标记、手动标记、排除、确诊、终结）
Property StatusDr As DHCMA.Util.BT.Dictionary;

/// 是否手动标记
Property IsMarkAuto As %Boolean;

/// 处置意见
Property Opinion As %String(MAXLEN = 500, TRUNCATE = 1);

/// 操作日期
Property ActDate As %Date;

/// 操作时间
Property ActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property ActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 就诊+分类+记录码 索引
Index IndexEpisCateOrdNo On (EpisodeID, IMPCateDr, IMPOrdNo) [ Unique ];

/// 患者分类+发生日期 索引
Index IdxOfCateHappenDate On (IMPCateDr, HappenDate);

/// 患者分类+操作日期 索引
Index IdxOfCateActDate On (IMPCateDr, ActDate);

/// Creator：     zhangdc
/// CreatDate：   2020-05-19
/// Description:  根据ID取重点患者记录列表信息
/// Table：       DHCMA.IMP.IP.IMPRecord
/// Input：       aId : DHCMA.IMP.IP.IMPRecord.ID
/// Return：      返回obj
/// w ##class(DHCMA.IMP.IP.IMPRecord).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.IP.IMPRecord
{
	New (aId)
	Quit:'##class(DHCMA.IMP.IP.IMPRecord).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.IP.IMPRecord).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhangdc
/// CreatDate：   2020-05-19
/// Description:  更新重点患者记录列表信息
/// Table：       DHCMA.IMP.IP.IMPRecord
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.IMPRecord).Update("^5^4^^^2^2020-06-13^^^^10209^211^^^95^3^1")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"
	Set ID                    = $p(aInputStr,aSeparete,1)
	Set EpisodeID             = $p(aInputStr,aSeparete,2)
	Set LnkEpisInfo       	  = $p(aInputStr,aSeparete,3)
	Set LnkOperInfo           = $p(aInputStr,aSeparete,4)
	Set IMPCateDr             = $p(aInputStr,aSeparete,5)
	Set IMPOrdNo			  = $p(aInputStr,aSeparete,6)
	Set IMPKeywords           = $p(aInputStr,aSeparete,7)
	Set IMPReasonDr           = $p(aInputStr,aSeparete,8)
	Set OccuLocID             = $p(aInputStr,aSeparete,9)
	Set OccuWardID            = $p(aInputStr,aSeparete,10)
	Set OccuDocID             = $p(aInputStr,aSeparete,11)
	Set HappenDate            = $p(aInputStr,aSeparete,12)
	Set HappenTime            = $p(aInputStr,aSeparete,13)
	Set Status             	  = $p(aInputStr,aSeparete,14)
	Set Opinion               = $p(aInputStr,aSeparete,15)
	Set ActDate               = $p(aInputStr,aSeparete,16)
	Set ActTime               = $p(aInputStr,aSeparete,17)
	Set ActUserID             = $p(aInputStr,aSeparete,18)
	Set IsMarkAuto            = +$p(aInputStr,aSeparete,19)

	Quit:(EpisodeID="")||(IMPCateDr="")||(IMPOrdNo="") return
	//Set tID=$o(^MA.IMP.IPIMPRecordI("IdxOfEpisodeID"," "_$zcvt(EpisodeID,"U"),0))
	//Quit:(tID'="")&(ID'=tID) -2 
	
	If ID="" {
		Set obj=##class(DHCMA.IMP.IP.IMPRecord).%New()
	}Else{
		Set obj=##class(DHCMA.IMP.IP.IMPRecord).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set:ActDate'="" ActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	//筛查日期为空查询不出来
	Set:HappenDate'="" HappenDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(HappenDate)
	Set:HappenTime[":" HappenTime = $zth(HappenTime,1)
	Set:HappenDate="" HappenDate=+$h
	Set:HappenTime="" HappenTime=$p($h,",",2)
	
	Set obj.EpisodeID             = EpisodeID
	Set obj.LnkEpisInfo           = LnkEpisInfo
	Set obj.LnkOperInfo           = LnkOperInfo
	Set obj.IMPCateDr             = ##class(DHCMA.IMP.BT.IMPCategory).GetObjById(IMPCateDr)
	Set obj.IMPOrdNo              = IMPOrdNo
	Set obj.IMPKeywords           = IMPKeywords
	Set obj.IMPReasonDr           = ##class(DHCMA.IMP.BT.IMPReasonDic).GetObjById(IMPReasonDr)
	Set obj.OccuLocID             = OccuLocID
	Set obj.OccuWardID            = OccuWardID
	Set obj.OccuDocID             = OccuDocID
	Set obj.HappenDate            = HappenDate
	Set obj.HappenTime            = HappenTime
	Set obj.StatusDr           	  = ##class(DHCMA.Util.BT.Dictionary).GetObjById(Status)
	Set obj.Opinion               = Opinion
	Set obj.ActDate               = ActDate
	Set obj.ActTime               = ActTime
	Set obj.ActUserID             = ActUserID
	Set obj.IsMarkAuto            = IsMarkAuto
	
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

/// Creator：     zhangdc
/// CreatDate：   2020-05-19
/// Description:  删除重点患者记录列表
/// Table：       DHCMA.IMP.IP.IMPRecord
/// Input：       aId : DHCMA.IMP.IP.IMPRecord.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.IMPRecord).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.IP.IMPRecord).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-16
/// Description:  根据就诊号和分类、记录码查找唯一对象
/// Table：       DHCMA.IMP.IP.IMPRecord
/// Input：       aEpisodeID,aCategory,aIMPOrdNo
/// Return：      返回obj
/// w ##class(DHCMA.IMP.IP.IMPRecord).GetObjByEpisodeIDAndCategory(4,5)
ClassMethod GetObjByEpisodeIDAndCategory(aEpisodeID As %String, aCategory As %String, aIMPOrdNo As %String) As DHCMA.IMP.IP.IMPRecord
{
	New (aEpisodeID,aCategory,aIMPOrdNo)
	Quit:aEpisodeID="" ""
	Quit:aCategory="" ""
	Quit:aIMPOrdNo="" ""
	
	Set ID=""
	Set ID=$o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(aEpisodeID,"U"),aCategory," "_$zcvt(aIMPOrdNo,"U"),ID))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
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
<Value>LnkEpisInfo</Value>
</Value>
<Value name="4">
<Value>LnkOperInfo</Value>
</Value>
<Value name="5">
<Value>IMPCateDr</Value>
</Value>
<Value name="6">
<Value>IMPOrdNo</Value>
</Value>
<Value name="7">
<Value>IMPKeywords</Value>
</Value>
<Value name="8">
<Value>IMPReasonDr</Value>
</Value>
<Value name="9">
<Value>OccuLocID</Value>
</Value>
<Value name="10">
<Value>OccuWardID</Value>
</Value>
<Value name="11">
<Value>OccuDocID</Value>
</Value>
<Value name="12">
<Value>HappenDate</Value>
</Value>
<Value name="13">
<Value>HappenTime</Value>
</Value>
<Value name="14">
<Value>StatusDr</Value>
</Value>
<Value name="15">
<Value>Opinion</Value>
</Value>
<Value name="16">
<Value>ActDate</Value>
</Value>
<Value name="17">
<Value>ActTime</Value>
</Value>
<Value name="18">
<Value>ActUserID</Value>
</Value>
<Value name="19">
<Value>StatusMark</Value>
</Value>
<Value name="20">
<Value>IsMark</Value>
</Value>
<Value name="21">
<Value>IsMarkAuto</Value>
</Value>
</Data>
<DataLocation>^MA.IMP.IPIMPRecordD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^MA.IMP.IPIMPRecordD</IdLocation>
<IndexLocation>^MA.IMP.IPIMPRecordI</IndexLocation>
<StreamLocation>^MA.IMP.IPIMPRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
