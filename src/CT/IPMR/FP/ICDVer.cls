/// 名称: CT.IPMR.FP.ICDVer
/// 描述: ICD字典版本
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.FP.ICDVer Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property FICode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述 （作废）
Property FIDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 启用日期
Property FIActDate As %Date;

/// 停用日期
Property FIEndDate As %Date;

/// 备注
Property FIResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 版本（ICDEdition） 全国版/北京版
Property FIEdition As CT.IPMR.BT.Dictionary [ Required ];

/// ICD编码类型（ICDType） 手术与操作分类/疾病分类
Property FIICDType As CT.IPMR.BT.Dictionary [ Required ];

/// 版本号
Property FIVersion As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

Index IndexCode On FICode [ Unique ];

Index IndexVersion On (FIEdition, FIICDType, FIVersion) [ Unique ];

/// Creator：     chenPJ
/// CreatDate：   2019-10-18
/// Description:  取ICD字典版本
/// Table：       CT.IPMR.FP.ICDVer
/// Input：       Id : CT.IPMR.FP.ICDVer.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.ICDVer).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.FP.ICDVer
{
	New (aId)
	Quit:'##class(CT.IPMR.FP.ICDVer).%ExistsId(aId) ""
	Set obj=##Class(CT.IPMR.FP.ICDVer).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenPJ
/// CreatDate：   2019-10-18
/// Description:  更新ICD字典版本
/// Table：       CT.IPMR.FP.ICDVer
/// Input：       InputStr ：字典数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FP.ICDVer).Update("^HIS-D^HIS诊断^2019-10-22^^测试诊断库版本","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID		= $p(aInputStr,aSeparate,1)
	Set Code 	= $p(aInputStr,aSeparate,2)
	Set Desc 	= $p(aInputStr,aSeparate,3)
	Set SttDate	= $p(aInputStr,aSeparate,4)
	Set EndDate = $p(aInputStr,aSeparate,5)
	Set SttDate = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(SttDate)
	Set EndDate = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(EndDate)
	Set Resume 	= $p(aInputStr,aSeparate,6)
	Set Edition = $p(aInputStr,aSeparate,7)
	Set ICDType = $p(aInputStr,aSeparate,8)
	Set Version = $p(aInputStr,aSeparate,9)
	
	Set objEdition = ##class(CT.IPMR.BT.Dictionary).GetObjById(Edition)
	Quit:'$isobject(objEdition) return
	
	Set objICDType = ##class(CT.IPMR.BT.Dictionary).GetObjById(ICDType)
	Quit:'$isobject(objICDType) return
	
	set tID=$o(^CT.IPMR.FP.ICDVerI("IndexCode"," "_$zcvt(Code,"U"),0))
	Quit:'((ID=tID)||(tID="")) -99
	
	Set tID = $o(^CT.IPMR.FP.ICDVerI("IndexVersion",Edition,ICDType," "_$zcvt(Version,"U"),0))
	Quit:'((ID=tID)||(tID="")) -100	
	
	If ID="" {
		Set obj=##class(CT.IPMR.FP.ICDVer).%New()
	}Else{
		Set obj=##class(CT.IPMR.FP.ICDVer).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.FICode		= Code
	Set obj.FIDesc		= Desc
	Set obj.FIActDate	= SttDate
	Set obj.FIEndDate	= EndDate
	Set obj.FIResume	= Resume
	Set obj.FIEdition	= objEdition
	Set obj.FIICDType	= objICDType
	Set obj.FIVersion	= Version
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
/// Description:  删除ICD字典版本
/// Table：       CT.IPMR.FP.ICDVer
/// Input：       Id : CT.IPMR.FP.ICDVer.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.FP.ICDVer).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Quit:aId="" return
	
	Set sc = ##class(CT.IPMR.FP.ICDVer).%DeleteId(aId)
	If $system.Status.IsError(sc) {  //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} else {
		Set return=1
	}
	Quit return
}

/// Creator：     zhouyang
/// CreatDate：   2021-08-17
/// Description:  根据版本号取编码库版本
/// Table：       CT.IPMR.FP.ICDVer
/// Input：       aSourceDesc : 来源描述
/// 			  aICDTypeDesc : 类型描述
/// 			  aVerCode : 版本代码
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.ICDVer).GetObjByVersion("全国版","手术","V2.0")
ClassMethod GetObjByVersion(aSourceDesc As %String, aICDTypeDesc As %String, aVersion As %String) As CT.IPMR.FP.ICDVer
{
	new (aSourceDesc,aICDTypeDesc,aVersion)
	Set return=""
	Quit:(aSourceDesc="")||(aICDTypeDesc="")||(aVersion="") return
	
	Set objSource =  ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("ICDEdition",aSourceDesc,"",1)
	Quit:'$isobject(objSource) return
	
	Set objICDType = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("ICDType",aICDTypeDesc,"",1)
	Quit:'$isobject(objICDType) return
	
	Set id = $o(^CT.IPMR.FP.ICDVerI("IndexVersion",objSource.%Id(),objICDType.%Id()," "_$zcvt(aVersion,"U"),0))
	Quit:id="" return
	
	set obj=##Class(CT.IPMR.FP.ICDVer).GetObjById(id)
	quit obj
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FICode</Value>
</Value>
<Value name="3">
<Value>FIDesc</Value>
</Value>
<Value name="4">
<Value>FIActDate</Value>
</Value>
<Value name="5">
<Value>FIEndDate</Value>
</Value>
<Value name="6">
<Value>FIResume</Value>
</Value>
<Value name="7">
<Value>FIEdition</Value>
</Value>
<Value name="8">
<Value>FIICDType</Value>
</Value>
<Value name="9">
<Value>FIVersion</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.FP.ICDVerD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.FP.ICDVerD</IdLocation>
<IndexLocation>^CT.IPMR.FP.ICDVerI</IndexLocation>
<StreamLocation>^CT.IPMR.FP.ICDVerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
