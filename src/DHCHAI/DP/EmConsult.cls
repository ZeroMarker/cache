/// 名称: DHCHAI.DP.EmConsult
/// 描述: 会诊表
/// 编写者：pylian
/// 编写日期: 2019-09-17
Class DHCHAI.DP.EmConsult Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property ECEpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 医嘱记录
Property ECOrdItemDr As DHCHAI.DP.OEOrdItem [ Required ];

/// 申请科室  
Property ECRLocDr As DHCHAI.BT.Location [ Required ];

/// 申请日期 
Property ECRDate As %Date;

/// 申请时间  
Property ECRTime As %Time;

/// 申请医生  
Property ECRUserDr As DHCHAI.BT.CareProv;

/// 病情及诊疗经过  
Property ECTrePro As %String(MAXLEN = 500, TRUNCATE = 1);

/// 会诊的理由和目的 
Property ECPurpose As %String(MAXLEN = 500, TRUNCATE = 1);

/// 会诊类别  
Property ECCategory As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医生级别  
Property ECDocLev As %String(MAXLEN = 100, TRUNCATE = 1);

/// 会诊日期  
Property ECNDate As %Date;

/// 会诊时间  
Property ECNTime As %Time;

/// 会诊地点  
Property ECNPlace As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 审核科室  
Property ECALocDr As DHCHAI.BT.Location;

/// 审核人  
Property ECAUserDr As DHCHAI.BT.CareProv;

/// 审核日期  
Property ECADate As %Date;

/// 审核时间  
Property ECATime As %Time;

/// 最终治疗措施  
Property ECTreMeasures As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 申请状态  
Property ECRStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 会诊类型  
Property ECType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 完成日期  
Property ECCDate As %Date;

/// 完成时间  
Property ECCTime As %Time;

/// 完成人 
Property ECCUserDr As DHCHAI.BT.CareProv;

/// 会诊科室 
Property ECCLocDr As DHCHAI.BT.Location;

/// 是否加急  
Property ECEmFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N");

/// 是否院外  
Property ECOutFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N");

/// 会诊意见 
Property ECOpintion As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 是否同意使用抗生素 
Property ECConsentAnti As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N");

/// 子系统代码
Property ECSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 记录索引码
Property ECXCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property ECIsActive As %Boolean [ Required ];

/// 更新日期
Property ECUpdateDate As %Date [ Required ];

/// 更新时间
Property ECUpdateTime As %Time [ Required ];

/// 就诊记录索引
Index IndexEpisodeDr On ECEpisodeDr;

/// 子系统代码 + 记录索引码 索引
Index IndexSCodeXCode On (ECSCode As Exact, ECXCode As Exact);

/// Creator：     pylian
/// CreatDate：   2019-09-17
/// Description:  根据ID作废会诊记录
/// Table：       DHCHAI.DP.EmConsult
/// Input：       id:    DHCHAI.DP.EmConsult.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.EmConsult).CancelById(1)
ClassMethod CancelById(id As %String) As %String
{
	New (id)
	Set return=""
	Quit:id="" return
	
	Set obj=##class(DHCHAI.DP.EmConsult).%OpenId(id)
	Quit:'$IsObject(obj) return
	
	Set obj.ECIsActive		= 0
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

/// Creator：     pylian
/// CreatDate：   2019-09-17
/// Description:  根据ID取会诊表
/// Table：       DHCHAI.DP.EmConsult
/// Input：       id:    DHCHAI.DP.EmConsult.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.EmConsult).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.EmConsult
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.EmConsult).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.EmConsult).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-09-17
/// Description:  根据子系统代码，记录索引码取会诊
/// Table：       DHCHAI.DP.EmConsult
/// Input：       aSCode: 子系统代码
///               aXCode: 记录索引码
/// Return：      返回Object
/// w ##class(DHCHAI.DP.EmConsult).GetObjByXCode(1)
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.DP.EmConsult
{
	New (aSCode,aXCode)
	Set return = ""
	Quit:(aSCode="")||(aXCode="") return
	
	Set id=$o(^DHCHAI.DP.EmConsultI("IndexSCodeXCode",aSCode,aXCode,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-09-17
/// Description:  更新会诊表
/// Table：       DHCHAI.DP.EmConsult
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.EmConsult).Update("^")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set ID          = $p(InStr,aSeparete,1)
    Set EpisodeDr   = $p(InStr,aSeparete,2)
	Set OrdItemDr   = $p(InStr,aSeparete,3)
	Set RLocDr      = $p(InStr,aSeparete,4)
	Set RDate       = $p(InStr,aSeparete,5)
	Set RTime       = $p(InStr,aSeparete,6)
	Set RUserDr     = $p(InStr,aSeparete,7)
	Set TrePro      = $p(InStr,aSeparete,8)
	Set Purpose     = $p(InStr,aSeparete,9)
	Set Category    = $p(InStr,aSeparete,10)
	Set DocLev      = $p(InStr,aSeparete,11)
	Set NDate       = $p(InStr,aSeparete,12)
	Set NTime       = $p(InStr,aSeparete,13)
	Set NPlace      = $p(InStr,aSeparete,14)
	Set ALocDr      = $p(InStr,aSeparete,15)
	Set AUserDr     = $p(InStr,aSeparete,16)
	Set ADate       = $p(InStr,aSeparete,17)
	Set ATime       = $p(InStr,aSeparete,18)
	Set TreMeasures = $p(InStr,aSeparete,19)
	Set RStatus     = $p(InStr,aSeparete,20)
	Set Type        = $p(InStr,aSeparete,21)
	Set CDate       = $p(InStr,aSeparete,22)
	Set CTime       = $p(InStr,aSeparete,23)
	Set CUserDr     = $p(InStr,aSeparete,24)
	Set CLocDr      = $p(InStr,aSeparete,25)
	Set EmFlag      = $p(InStr,aSeparete,26)
	Set OutFlag     = $p(InStr,aSeparete,27)
	Set Opintion    = $p(InStr,aSeparete,28)
	Set ConsentAnti = $p(InStr,aSeparete,29)
	Set SCode       = $p(InStr,aSeparete,30)
	Set XCode       = $p(InStr,aSeparete,31)
	Set IsActive    = $p(InStr,aSeparete,32)
	Set UpdateDate  = $p(InStr,aSeparete,33)

	Quit:(EpisodeDr="")||(OrdItemDr="") return
	Quit:(SCode="")||(XCode="")||(IsActive="") return
	
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:objAdm="" return
	Set objOrd = ##class(DHCHAI.DP.OEOrdItem).GetObjById(OrdItemDr)
	Quit:objOrd="" return
	Set objRLoc = ##class(DHCHAI.BT.Location).GetObjById(RLocDr)
	Quit:objRLoc="" return
	
	Set objALoc = ##class(DHCHAI.BT.Location).GetObjById(ALocDr)
	Set objRUser = ##class(DHCHAI.BT.CareProv).GetObjById(RUserDr)
	Set objAUser = ##class(DHCHAI.BT.CareProv).GetObjById(AUserDr)
	Set objCUser = ##class(DHCHAI.BT.CareProv).GetObjById(CUserDr)
	Set objCLoc = ##class(DHCHAI.BT.Location).GetObjById(CLocDr)

	//子系统代码+记录索引码 唯一性
	Set tID =$o(^DHCHAI.DP.EmConsultI("IndexSCodeXCode",SCode,XCode,0)) 
	Quit:(tID'="")&(ID'=tID) -100 

	if ID="" {
		Set obj=##class(DHCHAI.DP.EmConsult).%New()
	}else{
		Set obj=##class(DHCHAI.DP.EmConsult).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ECEpisodeDr   = objAdm  
	Set obj.ECOrdItemDr   = objOrd  
	Set obj.ECRLocDr      = objRLoc     
	Set obj.ECRDate       = RDate      
	Set obj.ECRTime       = RTime      
	Set obj.ECRUserDr     = objRUser    
	Set obj.ECTrePro      = TrePro     
	Set obj.ECPurpose     = Purpose    
	Set obj.ECCategory    = Category   
	Set obj.ECDocLev      = DocLev     
	Set obj.ECNDate       = NDate      
	Set obj.ECNTime       = NTime      
	Set obj.ECNPlace      = NPlace     
	Set obj.ECALocDr      = objALoc     
	Set obj.ECAUserDr     = objAUser    
	Set obj.ECADate       = ADate      
	Set obj.ECATime       = ATime      
	Set obj.ECTreMeasures = TreMeasures
	Set obj.ECRStatus     = RStatus    
	Set obj.ECType        = Type       
	Set obj.ECCDate       = CDate      
	Set obj.ECCTime       = CTime      
	Set obj.ECCUserDr     = objCUser    
	Set obj.ECCLocDr      = objCLoc     
	Set obj.ECEmFlag      = EmFlag     
	Set obj.ECOutFlag     = OutFlag    
	Set obj.ECOpintion    = Opintion   
	Set obj.ECConsentAnti = ConsentAnti
	Set obj.ECSCode       = SCode      
	Set obj.ECXCode       = XCode      
	Set obj.ECIsActive    = IsActive   
	Set obj.ECUpdateDate  = +$h 
	Set obj.ECUpdateTime  = $p($h,",",2)
   
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

/// Creator：     pylian
/// CreatDate：   2019-09-17
/// Description:  删除会诊表
/// Table：       DHCHAI.DP.EmConsult
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.EmConsult).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="EmConsultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ECEpisodeDr</Value>
</Value>
<Value name="3">
<Value>ECOrdItemDr</Value>
</Value>
<Value name="4">
<Value>ECRLocDr</Value>
</Value>
<Value name="5">
<Value>ECRDate</Value>
</Value>
<Value name="6">
<Value>ECRTime</Value>
</Value>
<Value name="7">
<Value>ECRUserDr</Value>
</Value>
<Value name="8">
<Value>ECTrePro</Value>
</Value>
<Value name="9">
<Value>ECPurpose</Value>
</Value>
<Value name="10">
<Value>ECCategory</Value>
</Value>
<Value name="11">
<Value>ECDocLev</Value>
</Value>
<Value name="12">
<Value>ECNDate</Value>
</Value>
<Value name="13">
<Value>ECNTime</Value>
</Value>
<Value name="14">
<Value>ECNPlace</Value>
</Value>
<Value name="15">
<Value>ECALocDr</Value>
</Value>
<Value name="16">
<Value>ECAUserDr</Value>
</Value>
<Value name="17">
<Value>ECADate</Value>
</Value>
<Value name="18">
<Value>ECATime</Value>
</Value>
<Value name="19">
<Value>ECTreMeasures</Value>
</Value>
<Value name="20">
<Value>ECRStatus</Value>
</Value>
<Value name="21">
<Value>ECType</Value>
</Value>
<Value name="22">
<Value>ECCDate</Value>
</Value>
<Value name="23">
<Value>ECCTime</Value>
</Value>
<Value name="24">
<Value>ECCUserDr</Value>
</Value>
<Value name="25">
<Value>ECCLocDr</Value>
</Value>
<Value name="26">
<Value>ECEmFlag</Value>
</Value>
<Value name="27">
<Value>ECOutFlag</Value>
</Value>
<Value name="28">
<Value>ECOpintion</Value>
</Value>
<Value name="29">
<Value>ECConsentAnti</Value>
</Value>
<Value name="30">
<Value>ECSCode</Value>
</Value>
<Value name="31">
<Value>ECXCode</Value>
</Value>
<Value name="32">
<Value>ECIsActive</Value>
</Value>
<Value name="33">
<Value>ECUpdateDate</Value>
</Value>
<Value name="34">
<Value>ECUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.EmConsultD</DataLocation>
<DefaultData>EmConsultDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.EmConsultD</IdLocation>
<IndexLocation>^DHCHAI.DP.EmConsultI</IndexLocation>
<StreamLocation>^DHCHAI.DP.EmConsultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
