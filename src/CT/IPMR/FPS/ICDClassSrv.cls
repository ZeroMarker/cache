/// 名称: CT.IPMR.FPS.ICDClassSrv
/// 描述: 编码库按疾病分类服务方法
/// 创建者：liyi
/// 创建日期: 2019-10-21
Class CT.IPMR.FPS.ICDClassSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2020-02-22
/// Description:  导入分类字典
/// Table：       CT.IPMR.FP.ICDClass
/// Input：       aInputStr ：字典数据
///               aSeparate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FPS.ICDClassSrv).ImportICDClass("^O^1813^其他非手术性操作^99","^")
ClassMethod ImportICDClass(aInputStr As %String, aSeparate As %String = "") As %String
{
	New (aInputStr,aSeparate)
	Set return = 0
	Set ^TMP("ImportICDClass")=$lb(aInputStr,aSeparate)
	Set TypeCode = $p(aInputStr,"^",2)
	Set objType = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("ICDType",TypeCode)
	Quit:'$isobject(objType) return
	
	Set $p(aInputStr,"^",2) = objType.%Id()
	Set ret = ##class(CT.IPMR.FP.ICDClass).Update(aInputStr,aSeparate)
	if ret<1 {
		Quit return
	}
	Set return = ret
	Quit return
}

/// w ##class(CT.IPMR.FPS.ICDClassSrv).BuildJosn(3,"01")
/// w ##class(CT.IPMR.FPS.ICDClassSrv).BuildJosn(3)
ClassMethod BuildJosn(aVerID As %String, id As %String = "root")
{
	new (aVerID,id)
	Set return=""
	Set xID =""
	For {
		Set xID = $o(^CT.IPMR.FP.ICDClassI("IndexICDVerDr",aVerID,xID))
		Quit:xID=""
		
		Set objClass = ##class(CT.IPMR.FP.ICDClass).GetObjById(xID)
		Continue:'$IsObject(objClass)
		Set Alias = objClass.FIICDAlias
		Set Desc = objClass.FIDesc
		Set Code = objClass.FICode
		if id="root" {
			Continue:$l(Code)'=2
		}else{
			Set objLeaf = ##class(CT.IPMR.FP.ICDClass).GetObjById(id)
			Continue:'$IsObject(objLeaf)
			Set LeafCode = objLeaf.FICode
			Continue:LeafCode=Code
			Continue:LeafCode'=$e(Code,0,$length(LeafCode))
			Continue:$length(Code)-$length(LeafCode)'=2
		}
		Set Josn = "{"_""""_"id"_""""_":"_""""_xID_""""_","_
		""""_"text"_""""_":"_""""_Desc_""""_","
		
		// 判断是否存在子节点
		Set xCode = "",flg=0
		For {
			Set xCode = $o(^CT.IPMR.FP.ICDClassI("IndexCode",aVerID,xCode))
			Quit:xCode=""
			Quit:flg=1
			Continue:Code=$e(xCode,2,$length(xCode))
			COntinue:$e(xCode,2,$length(Code)+1)'=Code
			Set flg=1
		}
		if flg="1" {
			Set Josn = Josn_""""_"state"_""""_":"_""""_"closed"_""""_","
		}else{
			Set Josn = Josn_""""_"state"_""""_":"_""""_"open"_""""_","
		}
		Set Josn = Josn_""""_"children"_""""_":[]"_"}"
		if return="" {
			Set return = "["_Josn
		}else{
			Set return = return_","_Josn
		}
	}
	if return="" {
		Set return = "[]"
	}else{
		Set return = return_"]"
	}
	Quit return
}

}
