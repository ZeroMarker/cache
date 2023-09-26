/// 患者医嘱信息
Class DHCMA.CPW.SD.Data.OrderInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 医嘱类型(STAT^即刻医嘱,PRN^PRN,NORM^临时医嘱,ONE^取药医嘱,S^长期医嘱,OM^自备药即刻,OUT^出院带药,OMST^自备药长期)
Property OEPriority As %String;

/// 医嘱明细ID
Property OEItemID As %String;

/// 医嘱项ID
Property ARCMastID As %String;

/// 医嘱开始日期
Property OESttDate As %Date;

/// 医嘱开始时间
Property OESttTime As %Time;

/// 医嘱开始日期时间
Property OESttDateT As %String;

/// 停医嘱日期
Property OEXDate As %Date;

/// 停医嘱时间
Property OEXTime As %Time;

/// 停医嘱日期时间
Property OEXDateT As %String;

/// 首次执行日期
Property FirstExecDate As %Date;

/// 首次执行时间
Property FirstExecTime As %Time;

/// 首次执行日期时间
Property FirstExecDateT As %String;

/// 末次执行日期
Property LastExecDate As %Date;

/// 末次执行时间
Property LastExecTime As %Time;

/// 末次执行日期时间
Property LastExecDateT As %String;

/// 药品通用名
Property OEGeneric As %String(MAXLEN = 100, TRUNCATE = 1);

/// 给药途径
Property OEInstruc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 单次剂量
Property OEDoseQty As %String(MAXLEN = 100, TRUNCATE = 1);

/// 剂量单位
Property OEDoseQtyUom As %String(MAXLEN = 100, TRUNCATE = 1);

/// 频次
Property OEFreqDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 管制分类
Property OEAntDrgPoison As %String(MAXLEN = 100, TRUNCATE = 1);

/// 使用目的
Property OEAntUsePurpose As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否送检
Property OEAntIsSubmiss As %Boolean;

/// 术前几小时用药
Property OEAntiAHours As %String;

/// 术后几小时停止用药
Property OEAntiBHours As %String;

/// 医嘱状态
Property OEStatus As %String;

/// 皮试医嘱
Property SkinTest As %Boolean;

/// 医嘱名称
Property OEARCDesc As %String;

Index IdxAdmARC On (EpisodeID As exact, ARCMastID As exact);

Index IdxAdmOEItem On (EpisodeID As exact, OEItemID As exact);

/// Table：       DHCMA.CPW.SD.Data.OrderInfo
/// Input：       aId : DHCMA.CPW.SD.Data.OrderInfo.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.SD.Data.OrderInfo).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Data.OrderInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Data.OrderInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Data.OrderInfo).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

ClassMethod GetFormatObjById(aId As %String) As DHCMA.CPW.SD.Data.OrderInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Data.OrderInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Data.OrderInfo).%OpenId(aId)
	Set obj.OESttDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(obj.OESttDate)
	Set obj.OESttTime=$zt(obj.OESttTime,1)
	Set obj.FirstExecDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(obj.FirstExecDate)
	Set obj.FirstExecTime=$zt(obj.FirstExecTime,1)
	Set obj.LastExecDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(obj.LastExecDate)
	Set obj.LastExecTime=$zt(obj.LastExecTime,1)
	Set obj.OESttDateT=obj.OESttDate_" "_obj.OESttTime
	Set obj.FirstExecDateT=obj.FirstExecDate_" "_obj.FirstExecTime
	Set obj.LastExecDateT=obj.LastExecDate_" "_obj.LastExecTime
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Description:  更新值域字典类型
/// Table：       DHCMA.CPW.SD.Data.OrderInfo
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.OrderInfo).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return	
	Set:aSeparete="" aSeparete="^"
	Set ARCMastID			= $p(aInputStr,aSeparete,1)
	Set EpisodeID           = $p(aInputStr,aSeparete,2) 
	Set OEAntDrgPoison      = $p(aInputStr,aSeparete,3)        
	Set OEAntIsSubmiss      = $p(aInputStr,aSeparete,4)        
	Set OEAntUsePurpose     = $p(aInputStr,aSeparete,5)         
	Set OEAntiAHours        = $p(aInputStr,aSeparete,6)                    
	Set OEAntiBHours        = $p(aInputStr,aSeparete,7)                        
	Set OEDoseQty           = $p(aInputStr,aSeparete,8)   
	Set OEDoseQtyUom        = $p(aInputStr,aSeparete,9)      
	Set OEFreqDesc          = $p(aInputStr,aSeparete,10)
	Set OEGeneric           = $p(aInputStr,aSeparete,11)     
	Set OEInstruc           = $p(aInputStr,aSeparete,12)   
	Set OEItemID            = $p(aInputStr,aSeparete,13)    
	Set OESttDate           = $p(aInputStr,aSeparete,14)       
	Set OESttDateT          = $p(aInputStr,aSeparete,15)            
	Set OESttTime           = $p(aInputStr,aSeparete,16)       
	Set OEXDate             = $p(aInputStr,aSeparete,17)   
	Set OEXDateT            = $p(aInputStr,aSeparete,18)        
	Set OEXTime             = $p(aInputStr,aSeparete,19)
	Set OEStatus            = $p(aInputStr,aSeparete,20)
	Set OEARCDesc           = $p(aInputStr,aSeparete,21)
	Set ID=$o(^DHCMA.CPW.SD.Data.OrderInfoI("IdxAdmOEItem",EpisodeID,OEItemID,0))
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.Data.OrderInfo).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Data.OrderInfo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ARCMastID          = ARCMastID                 
	Set obj.EpisodeID          = EpisodeID              
	Set obj.OEAntDrgPoison     = OEAntDrgPoison                
	Set obj.OEAntIsSubmiss     = OEAntIsSubmiss                
	Set obj.OEAntUsePurpose    = OEAntUsePurpose                
	Set obj.OEAntiAHours       = OEAntiAHours                              
	Set obj.OEAntiBHours       = OEAntiBHours                                  
	Set obj.OEDoseQty          = OEDoseQty                
	Set obj.OEDoseQtyUom       = OEDoseQtyUom                
	Set obj.OEFreqDesc         = OEFreqDesc            
	Set obj.OEGeneric          = OEGeneric                  
	Set obj.OEInstruc          = OEInstruc                
	Set obj.OEItemID           = OEItemID                  
	Set obj.OESttDate          = OESttDate                    
	Set obj.OESttDateT         = OESttDateT                        
	Set obj.OESttTime          = OESttTime                    
	Set obj.OEXDate            = OEXDate                  
	Set obj.OEXDateT           = OEXDateT                      
	Set obj.OEXTime            = OEXTime
	Set obj.OEStatus		   = OEStatus
	Set obj.OEARCDesc		   = OEARCDesc
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

/// Table：       DHCMA.CPW.SD.Data.OrderInfo
/// Input：       aId : DHCMA.CPW.SD.Data.OrderInfo.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.OrderInfo).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Data.OrderInfo).%DeleteId(aId)
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
<Data name="OrderInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>OEItemID</Value>
</Value>
<Value name="4">
<Value>ARCMastID</Value>
</Value>
<Value name="5">
<Value>OESttDate</Value>
</Value>
<Value name="6">
<Value>OESttTime</Value>
</Value>
<Value name="7">
<Value>OESttDateT</Value>
</Value>
<Value name="8">
<Value>OEXDate</Value>
</Value>
<Value name="9">
<Value>OEXTime</Value>
</Value>
<Value name="10">
<Value>OEXDateT</Value>
</Value>
<Value name="11">
<Value>OEGeneric</Value>
</Value>
<Value name="12">
<Value>OEInstruc</Value>
</Value>
<Value name="13">
<Value>OEDoseQty</Value>
</Value>
<Value name="14">
<Value>OEDoseQtyUom</Value>
</Value>
<Value name="15">
<Value>OEFreqDesc</Value>
</Value>
<Value name="16">
<Value>OEAntDrgPoison</Value>
</Value>
<Value name="17">
<Value>OEAntUsePurpose</Value>
</Value>
<Value name="18">
<Value>OEAntIsSubmiss</Value>
</Value>
<Value name="19">
<Value>OEAntiAHours</Value>
</Value>
<Value name="20">
<Value>OEAntiBHours</Value>
</Value>
<Value name="21">
<Value>OEStatus</Value>
</Value>
<Value name="22">
<Value>OEPriority</Value>
</Value>
<Value name="23">
<Value>FirstExecDate</Value>
</Value>
<Value name="24">
<Value>FirstExecTime</Value>
</Value>
<Value name="25">
<Value>FirstExecDateT</Value>
</Value>
<Value name="26">
<Value>LastExecDate</Value>
</Value>
<Value name="27">
<Value>LastExecTime</Value>
</Value>
<Value name="28">
<Value>LastExecDateT</Value>
</Value>
<Value name="29">
<Value>SkinTest</Value>
</Value>
<Value name="30">
<Value>OEARCDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Data.OrderInfoD</DataLocation>
<DefaultData>OrderInfoDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Data.OrderInfoD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Data.OrderInfoI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Data.OrderInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
