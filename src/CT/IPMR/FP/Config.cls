/// 名称: CT.IPMR.FP.Config
/// 描述: 编目配置
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.FP.Config Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 编目操作项目
Property FCWorkFItemDr As CT.IPMR.BT.WorkFItem;

/// 编目数据版本（CodeMultiVer）
Property FCCodeMultiVer As CT.IPMR.BT.Dictionary;

/// 诊断编码库
Property FCICDVer As CT.IPMR.FP.ICDVer;

/// 手术编码库
Property FCOprVer As CT.IPMR.FP.ICDVer;

/// 中医诊断库
Property FCICDVer2 As CT.IPMR.FP.ICDVer;

/// 肿瘤码诊断库
Property FCICDVer3 As CT.IPMR.FP.ICDVer;

/// 是否默认配置（维护为正常编目的配置项时，为是；其他版本编目为否）
Property FCIsDefault As %Boolean;

/// 备注
Property FCResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexCodeMultiVer On (FCWorkFItemDr, FCCodeMultiVer) [ Unique ];

Index IndexWorkFItemDr On FCWorkFItemDr;

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  通过病案分类取配置值
/// Table：       CT.IPMR.FP.Config
/// Input：       aCode : CT.IPMR.BT.MrClass.BMCode
/// Input：       aCodeMultiVer : 编目数据版本字典代码（为空取默认版本）
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.Config).GetIDByMrClass("I","")
ClassMethod GetIDByMrClass(aCode As %String, aCodeMultiVerCode As %String = "") As %String
{
	New (aCode,aCodeMultiVerCode)
	Set return= ""
	Quit:aCode="" return
	
	set aCodeMultiVer = ##class(CT.IPMR.BT.Dictionary).GetIDByTypeCode("CodeMultiVer",aCodeMultiVerCode,"","")
	
	// 优化速度
	Set xId = ""
	For {
		Set xId = $o(^CT.IPMR.FP.ConfigD(xId))
		Quit:xId=""
		Set ConfigInfo = $g(^CT.IPMR.FP.ConfigD(xId))
		Continue:ConfigInfo=""
		
		Set WorkFItemID = $lg(ConfigInfo,2)
		Set CodeMultiVer= $lg(ConfigInfo,8) 
		Set IsDefault	= $lg(ConfigInfo,9) 
		Continue:WorkFItemID=""
		
		Set WorkFlowID = +WorkFItemID
		Set xMrTypeID = "",checkMrClassFlg=0
		For {
	  		Set xMrTypeID = $o(^CT.IPMR.BT.MrTypeD(xMrTypeID))
	  		Quit:xMrTypeID=""
			Set MrTypeInfo=$g(^CT.IPMR.BT.MrTypeD(xMrTypeID))
			Continue:MrTypeInfo=""
			Set xWorkFlowID=$lg(MrTypeInfo,7)
			Continue:xWorkFlowID=""
			Set MrClassID = $lg(MrTypeInfo,"2")
			Continue:MrClassID=""
			Set MrClass = $lg($g(^CT.IPMR.BT.MrClassD(MrClassID)),"2")
			Continue:MrClass=""
			Continue:aCode'=MrClass
			Set checkMrClassFlg =1
			Quit
		}
		Continue:checkMrClassFlg=0  // 与aCode不匹配
		If aCodeMultiVer="" {	// 取默认版本
			If IsDefault=1 {
				Set return = xId
				Quit	// 取到值退出
			}
		}else{
			If aCodeMultiVer=CodeMultiVer {
				Set return = xId
				Quit	// 取到值退出
			}
		}
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  通过病案分类取配置值
/// Table：       CT.IPMR.FP.Config
/// Input：       aCode : CT.IPMR.BT.MrClass.BMCode
/// Input：       aCodeMultiVer : 编目数据版本字典代码（为空取默认版本）
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.Config).GetObjByMrClass("I","")
ClassMethod GetObjByMrClass(aCode As %String, aCodeMultiVerCode As %String = "") As CT.IPMR.FP.Config
{
	New (aCode,aCodeMultiVerCode)
	Set return= ""
	Quit:aCode="" return
	
	set aCodeMultiVer = ##class(CT.IPMR.BT.Dictionary).GetIDByTypeCode("CodeMultiVer",aCodeMultiVerCode,"","")
	
	// 优化速度
	Set xId = ""
	For {
		Set xId = $o(^CT.IPMR.FP.ConfigD(xId))
		Quit:xId=""
		Set obj = ..GetObjById(xId)
		Continue:'$isobject(obj)
		Continue:'$isobject(obj.FCCodeMultiVer)
		
		Set objWorkFItem = obj.FCWorkFItemDr
		Continue:'$isobject(objWorkFItem)
		Continue:'$isobject(objWorkFItem.Parref)
		Set WorkFlowID = objWorkFItem.Parref.%Id()
		
		Set xMrTypeID = "",checkMrClassFlg=0
		For {
	  		Set xMrTypeID = $o(^CT.IPMR.BT.MrTypeD(xMrTypeID))
	  		Quit:xMrTypeID=""
			Set MrTypeInfo=$g(^CT.IPMR.BT.MrTypeD(xMrTypeID))
			Continue:MrTypeInfo=""
			Set xWorkFlowID=$lg(MrTypeInfo,7)
			Continue:xWorkFlowID=""
			Set MrClassID = $lg(MrTypeInfo,"2")
			Continue:MrClassID=""
			Set MrClass = $lg($g(^CT.IPMR.BT.MrClassD(MrClassID)),"2")
			Continue:MrClass=""
			Continue:aCode'=MrClass
			Set checkMrClassFlg =1
			Quit
		}
		Continue:checkMrClassFlg=0  // 与aCode不匹配
		If aCodeMultiVer="" {	// 取默认版本
			If obj.FCIsDefault=1 {
				Set return = obj
				Quit	// 取到值退出
			}
		}else{
			If aCodeMultiVer=obj.FCCodeMultiVer.%Id() {
				Set return = obj
				Quit	// 取到值退出
			}
		}
	}
	/*
	Set xMrTypeID = "",ConfigID=""
	For {
  		Set xMrTypeID = $o(^CT.IPMR.BT.MrTypeD(xMrTypeID))
  		Quit:xMrTypeID=""
  		Quit:ConfigID'=""
  		Set objMrType = ##class(CT.IPMR.BT.MrType).GetObjById(xMrTypeID)
  		Continue:'$isobject(objMrType)
  		Set objMrClass = objMrType.BMMrClass
  		Continue:'$isobject(objMrClass)
  		Continue:aCode'=objMrClass.BMCode
  		Set objWorkFlow = objMrType.BMWorkFlow
  		Continue:'$isobject(objWorkFlow)
  	
  		For indx=1:1:objWorkFlow.ChildItem.Count() {
			Set objWorkFItem=objWorkFlow.ChildItem.GetAt(indx)
			Continue:'$IsObject(objWorkFItem)
			Quit:ConfigID'=""
			Set WorkFItemID = objWorkFItem.%Id()
			Set ConfigID = ""
			Set xConfigID = ""
			For {
				Set xConfigID = $o(^CT.IPMR.FP.ConfigI("IndexWorkFItemDr",WorkFItemID,xConfigID))
				Quit:xConfigID=""
				set objConfig = ..GetObjById(xConfigID)
				If aCodeMultiVer="" {
					If objConfig.FCIsDefault=1{
						Set ConfigID=xConfigID
					}
				}else{
					If $isobject(objConfig.FCCodeMultiVer){
						set CodeMultiVer = objConfig.FCCodeMultiVer.%Id()
						Set:aCodeMultiVer=CodeMultiVer ConfigID=xConfigID
					}
				}
				Quit:ConfigID'=""
			}
		}
	}
	Set return = ..GetObjById(ConfigID)
	*/
	quit return
}

/// Creator：     liyi
/// CreatDate：   2022-03-16
/// Description:  取默认配置为1的编目配置
/// Table：       CT.IPMR.FP.Config
/// Input：       aWorkFItemID：编目操作项目ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.Config).GetDefaultObj("1||4")
ClassMethod GetDefaultObj(aWorkFItemID) As CT.IPMR.FP.Config
{
	new (aWorkFItemID)
	Set return=""
	set xCodeMultiVer = ""
	For {
		set xCodeMultiVer = $o(^CT.IPMR.FP.ConfigI("IndexCodeMultiVer",aWorkFItemID,xCodeMultiVer))
		Quit:xCodeMultiVer=""
		Quit:$isobject(return)
		
		Set xId = ""
		For {
			set xId = $o(^CT.IPMR.FP.ConfigI("IndexCodeMultiVer",aWorkFItemID,xCodeMultiVer,xId))
			Quit:xId=""
			set obj = ..GetObjById(xId)
			continue:'$isobject(obj)
			Set:obj.FCIsDefault=1 return=obj
			Quit:$isobject(return)
		}
	}
	quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  取编目配置
/// Table：       CT.IPMR.FP.Config
/// Input：       Id : CT.IPMR.FP.Config.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.Config).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.FP.Config
{
	new (aId)
	quit:'##class(CT.IPMR.FP.Config).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.FP.Config).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  更新编目配置
/// Table：       CT.IPMR.FP.Config
/// Input：       InputStr ：字典数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FP.Config).Update("^1||1^1^1^1^1^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID			= $p(aInputStr,aSeparate,1)
	Set WorkFItemID	= $p(aInputStr,aSeparate,2)
	Set ICDVer 		= $p(aInputStr,aSeparate,3)
	Set OprVer 		= $p(aInputStr,aSeparate,4)
	Set ICDVer2		= $p(aInputStr,aSeparate,5)
	Set ICDVer3		= $p(aInputStr,aSeparate,6)
	Set Resume 		= $p(aInputStr,aSeparate,7)
	Set CodeMultiVer= $p(aInputStr,aSeparate,8)
	Set IsDefault   = $p(aInputStr,aSeparate,9)
	Quit:(WorkFItemID="")||(OprVer="")||(CodeMultiVer="") return
	Quit:(ICDVer="")&&(ICDVer2="") return
	
	Set objWorkFItem = ##class(CT.IPMR.BT.WorkFItem).GetObjById(WorkFItemID)
	Quit:'$IsObject(objWorkFItem) return
	
	Set tID = $o(^CT.IPMR.FP.ConfigI("IndexCodeMultiVer",WorkFItemID,CodeMultiVer,""))
	Quit:(tID'="")&&(ID'=tID) -100

	If ID="" {
		Set obj=##class(CT.IPMR.FP.Config).%New()
	}Else{
		Set obj=##class(CT.IPMR.FP.Config).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.FCWorkFItemDr	= objWorkFItem
	Set obj.FCICDVer		= ##class(CT.IPMR.FP.ICDVer).GetObjById(ICDVer)
	Set obj.FCOprVer		= ##class(CT.IPMR.FP.ICDVer).GetObjById(OprVer)
	Set obj.FCICDVer2 		= ##class(CT.IPMR.FP.ICDVer).GetObjById(ICDVer2)
	Set obj.FCICDVer3 		= ##class(CT.IPMR.FP.ICDVer).GetObjById(ICDVer3)
	Set obj.FCResume		= Resume
	Set obj.FCCodeMultiVer	= ##class(CT.IPMR.BT.Dictionary).GetObjById(CodeMultiVer)
	Set obj.FCIsDefault		= IsDefault
	
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
/// Description:  删除编目配置
/// Table：       CT.IPMR.FP.Config
/// Input：       Id : CT.IPMR.FP.Config.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.FP.Config).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.FP.Config).%DeleteId(aId)
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
<Value>FCWorkFItemDr</Value>
</Value>
<Value name="3">
<Value>FCICDVer</Value>
</Value>
<Value name="4">
<Value>FCOprVer</Value>
</Value>
<Value name="5">
<Value>FCICDVer2</Value>
</Value>
<Value name="6">
<Value>FCICDVer3</Value>
</Value>
<Value name="7">
<Value>FCResume</Value>
</Value>
<Value name="8">
<Value>FCCodeMultiVer</Value>
</Value>
<Value name="9">
<Value>FCIsDefault</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.FP.ConfigD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.FP.ConfigD</IdLocation>
<IndexLocation>^CT.IPMR.FP.ConfigI</IndexLocation>
<StreamLocation>^CT.IPMR.FP.ConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
