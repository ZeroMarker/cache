/// 名称: DHCMed.DTH.CodeRecycle
/// 描述: 死亡证明书回收作废的编码表
/// 编写者： chenrui
/// 编写日期:  2023-01-16
Class DHCMed.DTH.CodeRecycle Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 原死亡报告ID
Property RMainReportID As %String(TRUNCATE = 1);

/// 回收的死亡证明编号
Property RDeathNo As %String(TRUNCATE = 1);

/// 现死亡报告ID
Property NMainReportID As %String(TRUNCATE = 1);

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 以更新日期为索引
Index IndexUpdateDate On UpdateDate As Exact;

/// 以更新日期、更新时间为索引
Index IndexUpdateDateTime On (UpdateDate As Exact, UpdateTime As Exact);

/// 以编码为索引
Index IndexRDeathNo On RDeathNo As Exact;

/// Creator:	chenrui
/// CreatDate:	2023-01-16
/// Description: 死亡证明书回收作废的编码表
/// w ##class(DHCMed.DTH.CodeRecycle).GetObjById("") 
ClassMethod GetObjById(aId As %String) As DHCMed.DTH.CodeRecycle
{
	New (aId)
	Quit:'##class(DHCMed.DTH.CodeRecycle).%ExistsId(aId) ""
	Set obj=##class(DHCMed.DTH.CodeRecycle).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenrui
/// CreatDate：   2023-01-16
/// Description:  更新死亡证回收的编码
/// Table：       DHCMed.EPD.EpidemicLog
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DTH.CodeRecycle).Update("^28^20230003^","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID				= $p(aInputStr,aSeparete,1)
	Set RMainReportID	= $p(aInputStr,aSeparete,2)
	Set RDeathNo		= $p(aInputStr,aSeparete,3)
	Set NMainReportID	= $p(aInputStr,aSeparete,4)
	Quit:(RMainReportID="")||(RDeathNo="") return
	if ($d(^DHCMed.DTH.CodeRecycleI("IndexRDeathNo",RDeathNo))){
		Quit -99
	}
	If ID="" {
		Set obj=##class(DHCMed.DTH.CodeRecycle).%New()
	}Else{
		Set obj=##class(DHCMed.DTH.CodeRecycle).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.RMainReportID		= RMainReportID
	Set obj.RDeathNo			= RDeathNo
	Set obj.NMainReportID		= NMainReportID
	Set obj.UpdateDate			= +$h
	Set obj.UpdateTime			= $p($h,",",2)
	
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

/// Creator:	chenrui
/// CreatDate:	2023-01-16
/// Description: 是否存在有回收并且未使用的编码
/// w ##class(DHCMed.DTH.CodeRecycle).IsExistCode() 
ClassMethod IsExistCode() As %String
{
	Set return=""
	Set xDate = ""
	For{
		Set xDate = $o(^DHCMed.DTH.CodeRecycleI("IndexUpdateDate",xDate))
		Quit:return=1
		Quit:xDate=""
		Set xID = ""
		For{
			Set xID = $o(^DHCMed.DTH.CodeRecycleI("IndexUpdateDate",xDate,xID))
			Quit:xID=""
			Set CodeInfo = ^DHCMed.DTH.CodeRecycleD(xID)
			Set NReport  = $lg(CodeInfo,4)
			Set:NReport="" return =1
			Quit:NReport=""    // 当存在新报告ID为空时，代表改回收的编码还未被使用
		}
	}
	Quit return
}

/// Creator:	chenrui
/// CreatDate:	2023-01-16
/// Description: 获取最早被回收未使用的编码
/// w ##class(DHCMed.DTH.CodeRecycle).GetRecycleCode() 
ClassMethod GetRecycleCode() As %String
{
	Set return=""
	Set xDate = ""
	For{
		Set xDate = $o(^DHCMed.DTH.CodeRecycleI("IndexUpdateDateTime",xDate))
		Quit:return'=""
		Quit:xDate=""
		Set xTime = ""
		For{
			Set xTime = $o(^DHCMed.DTH.CodeRecycleI("IndexUpdateDateTime",xDate,xTime))
			Quit:return'=""
			Quit:xTime=""
			Set xID = ""
			For{
				Set xID = $o(^DHCMed.DTH.CodeRecycleI("IndexUpdateDateTime",xDate,xTime,xID))
				Quit:xID=""
				Set CodeInfo = ^DHCMed.DTH.CodeRecycleD(xID)
				Set Code  	 = $lg(CodeInfo,3)
				Set NReport  = $lg(CodeInfo,4)
				if (NReport=""){
					Set return = Code
				}
				Quit:return'=""
			}
		}
	}
	Quit return
}

/// Creator:	chenrui
/// CreatDate:	2023-01-16
/// Description: 新建报告之后，使用收回的编码保存新报告的ID
/// w ##class(DHCMed.DTH.CodeRecycle).UpdateNewReportID() 
ClassMethod UpdateNewReportID(aReportID As %String, aCode As %String) As %String
{
	new (aReportID,aCode)
	Set return=""
	Quit:aReportID="" return
	Set xRepID = $o(^DHCMed.DTH.CodeRecycleI("IndexRDeathNo",aCode,0))
	Set obj=##class(DHCMed.DTH.CodeRecycle).%OpenId(xRepID)
	Quit:'$IsObject(obj) return
	Set obj.NMainReportID		= aReportID
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

Storage Default
{
<Data name="CodeRecycleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RMainReportID</Value>
</Value>
<Value name="3">
<Value>RDeathNo</Value>
</Value>
<Value name="4">
<Value>NMainReportID</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
<Value name="6">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DTH.CodeRecycleD</DataLocation>
<DefaultData>CodeRecycleDefaultData</DefaultData>
<IdLocation>^DHCMed.DTH.CodeRecycleD</IdLocation>
<IndexLocation>^DHCMed.DTH.CodeRecycleI</IndexLocation>
<StreamLocation>^DHCMed.DTH.CodeRecycleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
