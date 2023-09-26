/// 名称: CT.IPMR.FP.DataItem
/// 描述: 编目数据项
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.FP.DataItem Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 首页类型 （"FrontPageType" 中医首页/西医首页）
Property FDFPType As list Of CT.IPMR.BT.Dictionary [ Required ];

/// 代码
Property FDCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 描述
Property FDDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 分类
Property FDCatDr As CT.IPMR.FP.DataItemCat;

/// 备注
Property FDResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexCode On FDCode [ Unique ];

Index IndexCatDr On FDCatDr;

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  取编目数据项
/// Table：       CT.IPMR.FP.DataItem
/// Input：       aCode : CT.IPMR.FP.DataItem.FDCode
/// 			  aFPTypeID : CT.IPMR.FP.DataItem.FDFPTypeDr.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.DataItem).GetObjByCode("P01.001.01",156)
ClassMethod GetObjByCode(aCode As %String, aFPTypeID As %String = "") As CT.IPMR.FP.DataItem
{
	new (aCode,aFPTypeID)
	Set return=""
	Set id = $o(^CT.IPMR.FP.DataItemI("IndexCode"," "_$ZCVT(aCode,"U"),0))
	Quit:id="" return
	Set obj = ..GetObjById(id)
	Set ListobjFPType=obj.FDFPType
	Set CheckFlg=0
	For ind=1:1:ListobjFPType.Count() {
		Set objDic= ListobjFPType.GetAt(ind)
		Continue:'$isobject(objDic)
		Continue:(aFPTypeID'="")&&(objDic.%Id()'=aFPTypeID)
		Set CheckFlg=1
	}
	Quit:CheckFlg=0 return
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  取编目数据项
/// Table：       CT.IPMR.FP.DataItem
/// Input：       Id : CT.IPMR.FP.DataItem.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.DataItem).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.FP.DataItem
{
	new (aId)
	quit:'##class(CT.IPMR.FP.DataItem).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.FP.DataItem).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  更新编目数据项
/// Table：       CT.IPMR.FP.DataItem
/// Input：       InputStr ：字典数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FP.DataItem).Update("^DiaType^2^其他诊断^2^^^^^^1^备注","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID		 = $p(aInputStr,aSeparate,1)
	Set FPTypeIDs= $p(aInputStr,aSeparate,2)
	Set Code 	 = $p(aInputStr,aSeparate,3)
	Set Desc 	 = $p(aInputStr,aSeparate,4)
	Set CatID	 = $p(aInputStr,aSeparate,5)
	Set Resume 	 = $p(aInputStr,aSeparate,6)
	Quit:(Code="")||(Desc="")||(FPTypeIDs="") return
	
	Set listFPType =##Class(%Library.ListOfObjects).%New()
	for ind=1:1:$length(FPTypeIDs,","){
		Set FPTypeID = $p(FPTypeIDs,",",ind)
		Continue:FPTypeID=""
		Set objFPType = ##class(CT.IPMR.BT.Dictionary).GetObjById(FPTypeID)
		Continue:'$IsObject(objFPType)
		d listFPType.Insert(objFPType)
	}
	
	Set objCat = ##class(CT.IPMR.FP.DataItemCat).GetObjById(CatID)
	
	Set tID = $o(^CT.IPMR.FP.DataItemI("IndexCode"," "_$ZCVT(Code,"U"),0))
	Quit:(ID'="")&&(ID'=tID) return
	Set ID = tID
	If ID="" {
		Set obj=##class(CT.IPMR.FP.DataItem).%New()
	}Else{
		Set obj=##class(CT.IPMR.FP.DataItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.FDFPType	= listFPType
	Set obj.FDCode		= Code
	Set obj.FDDesc		= Desc
	Set obj.FDCatDr 	= objCat
	Set obj.FDResume	= Resume
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

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  删除编目数据项
/// Table：       CT.IPMR.FP.DataItem
/// Input：       Id : CT.IPMR.FP.DataItem.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.FP.DataItem).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.FP.DataItem).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FDFPType</Value>
</Value>
<Value name="3">
<Value>FDCode</Value>
</Value>
<Value name="4">
<Value>FDDesc</Value>
</Value>
<Value name="5">
<Value>FDCatDr</Value>
</Value>
<Value name="6">
<Value>FDResume</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.FP.DataItemD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.FP.DataItemD</IdLocation>
<IndexLocation>^CT.IPMR.FP.DataItemI</IndexLocation>
<StreamLocation>^CT.IPMR.FP.DataItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
