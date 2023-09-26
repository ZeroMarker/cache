/// 名称: CT.IPMR.DP.SoapConfig
/// 描述: 第三方数据获取接口配置
/// 创建者：liyi
/// 创建日期: 2021-12-23
Class CT.IPMR.DP.SoapConfig Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 系统指针
Property SystemDr As CT.IPMR.DP.System [ Required ];

/// 目标地址
Property TargetAddress As %String(MAXLEN = 500, TRUNCATE = 0);

/// 目标方法
Property TargetMethod As %String(MAXLEN = 500, TRUNCATE = 0);

/// 数据模型 ModelType
Property ModelTypeDr As CT.IPMR.BT.Dictionary [ Required ];

/// 参数（|分隔）
Property Arguments As %String(MAXLEN = 500, TRUNCATE = 0);

Index IndexOfModel On (SystemDr, ModelTypeDr) [ Unique ];

Index IndexOfSystem On SystemDr;

/// Creator：     liyi
/// CreatDate：   2021-12-23
/// Description:  取接口配置
/// Table：       CT.IPMR.DP.SoapConfig
/// Return：      返回obj
/// w ##class(CT.IPMR.DP.SoapConfig).GetSoapObj(2)
ClassMethod GetSoapObj(aSysId As %String, aModeCode As %String) As CT.IPMR.DP.SoapConfig
{
	new (aSysId,aModeCode)
	set return=""
	quit:(aSysId="")||(aModeCode="") return
	set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("ModelType",aModeCode)
	quit:'$isobject(objDic) return
	set id = $o(^CT.IPMR.DP.SoapConfigI("IndexOfModel",aSysId,objDic.%Id(),""))
	quit:id="" return
	Set obj=##Class(CT.IPMR.DP.SoapConfig).%OpenId(id)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// d ##class(CT.IPMR.DP.SoapConfig).test()
ClassMethod test()
{
	Set request = ##class(MA.IPMR.IOModel.ENS.Request).Create()
	Set request.Header.SourceSystem="EM"
	Set request.Header.MessageID=""
	Set request.Body.Arguments.ExCode="HIS01"
	w ##class(CT.IPMR.DP.SoapConfig).ExecuteSoap(2,"AdmInfo",request.ToXML())
}

/// w ##class(CT.IPMR.DP.SoapConfig).ExecuteSoap(2,"AdmInfo","request")
ClassMethod ExecuteSoap(aSysId As %String, aModeCode As %String, request As %GlobalCharacterStream) As %GlobalCharacterStream
{
	new (aSysId,aModeCode,request)
	set return=""
	quit:(aSysId="")||(aModeCode="")||(request="") return
	set obj = ##class(CT.IPMR.DP.SoapConfig).GetSoapObj(aSysId,aModeCode)
	quit:'$isobject(obj) return
	set TargetAddress = obj.TargetAddress
	set TargetMethod  = obj.TargetMethod	
	set Arguments	  = obj.Arguments
	Set XStr = "Set objTarget= ##class("_TargetAddress_").%New()"
	x XStr
	quit:'$isobject(objTarget) return
	set argstr = ""
	for ind = 1:1:$length(Arguments,"|") 
	{
		set arg = $p(Arguments,"|",ind)
		if arg="{request}" {
			set arg="request"
		}else{
			set arg=""""_arg_""""
		}
		if argstr="" {
			set argstr=arg
		}else{
			set argstr=argstr_","_arg
		}
	}
	//w "objTarget:"_objTarget,!
	set xmethod = "set ret = objTarget."_TargetMethod_"("_argstr_")"
	//w "xmethod:"_xmethod,!
	x xmethod
	//w "ret:"_ret,!
	q ret
}

/// Creator：     liyi
/// CreatDate：   2021-12-23
/// Description:  根据ID取接口配置
/// Table：       CT.IPMR.DP.SoapConfig
/// Input：       aId : CT.IPMR.DP.SoapConfig.ID
/// Return：      返回obj
/// w ##class(CT.IPMR.DP.SoapConfig).GetObjById(1)
ClassMethod GetObjById(aId As %String) As CT.IPMR.DP.SoapConfig
{
	New (aId)
	Quit:'##class(CT.IPMR.DP.SoapConfig).%ExistsId(aId) ""
	Set obj=##Class(CT.IPMR.DP.SoapConfig).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liyi
/// CreatDate：   2021-12-23
/// Description:  更新接口配置
/// Table：       CT.IPMR.DP.SoapConfig
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.DP.SoapConfig).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID         		= $p(aInputStr,aSeparete,1)
	Set SystemID       	= $p(aInputStr,aSeparete,2)
	Set TargetAddress   = $p(aInputStr,aSeparete,3)
	Set TargetMethod    = $p(aInputStr,aSeparete,4)
	Set ModelTypeID     = $p(aInputStr,aSeparete,5)
	Set Arguments     	= $p(aInputStr,aSeparete,6)
	Quit:(SystemID="")||(ModelTypeID="") return
	
	Set objSys = ##class(CT.IPMR.DP.System).GetObjById(SystemID)
	Quit:'$isobject(objSys) return
	
	Set objModelType = ##class(CT.IPMR.BT.Dictionary).GetObjById(ModelTypeID)
	Quit:'$isobject(objModelType) return
	
	Set tID=$o(^CT.IPMR.DP.SoapConfigI("IndexOfModel",SystemID,ModelTypeID,0))
	Quit:(tID'="")&(ID'=tID) -100
	
	If TargetAddress'="" {
		Set flg = ##class(%Dictionary.CompiledClass).%OpenId(TargetAddress)
		Quit:flg="" -102
	}
	
	If ID="" {
		Set obj=##class(CT.IPMR.DP.SoapConfig).%New()
	}Else{
		Set obj=##class(CT.IPMR.DP.SoapConfig).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.SystemDr     		= objSys
	Set obj.TargetAddress     	= TargetAddress
	Set obj.TargetMethod		= TargetMethod
	Set obj.ModelTypeDr     	= objModelType
	Set obj.Arguments			= Arguments
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
/// CreatDate：   2021-12-23
/// Description:  删除接口配置
/// Table：       CT.IPMR.DP.SoapConfig
/// Input：       aId : CT.IPMR.DP.SoapConfig.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(CT.IPMR.DP.SoapConfig).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(CT.IPMR.DP.SoapConfig).%DeleteId(aId)
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
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SystemDr</Value>
</Value>
<Value name="3">
<Value>TargetAddress</Value>
</Value>
<Value name="4">
<Value>TargetMethod</Value>
</Value>
<Value name="5">
<Value>ModelTypeDr</Value>
</Value>
<Value name="6">
<Value>Arguments</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.DP.SoapConfigD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.DP.SoapConfigD</IdLocation>
<IndexLocation>^CT.IPMR.DP.SoapConfigI</IndexLocation>
<StreamLocation>^CT.IPMR.DP.SoapConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
