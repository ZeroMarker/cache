Class CT.WS.web.DicDataValueMapLR Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	//systemcode
	s systemCode =$g(%request.Data("systemCode",1),"")
	//映射左边自定义字典数据选择长度
	s leftlength =$g(%request.Data("leftlength",1),"")
	////映射左边自定义字典数据集合"DEVID:04^Meaning:CZ-藏族|@|DEVID:05^Meaning:WWEZ-维吾尔族"
	s seldataleft = $g(%request.Data("seldataleft",1),"")
	//映射右边标准值域代码"CtmDictCode:01^CtmDictDesc:病历概要"
	s seldataright =$g(%request.Data("seldataright",1),"")
	//映射删除的id "id1^id2"
	s delectIds =$g(%request.Data("delectId",1),"")
	//SO4
	s nodeCode = $g(%request.Data("nodeCode",1),"")
	//CV0000.01
	s nodeRightCode =$g(%request.Data("nodeRightCode",1),"")
	//操作按钮  映射按钮:"btndataMap" 删除按钮:"btnDelete"
	s actionBtn = $g(%request.Data("actionBtn",1),"")
	
	s strSystemCode = "DHCC"	
	d ..GetJsonDate(strSystemCode,nodeCode,nodeRightCode,actionBtn,leftlength,seldataleft,seldataright,delectIds)
	q $$$OK
}

/// Creator:	yejian
/// CreatDate:	2013-4-23
/// Desc:		获取字典表维护数据
/// Input：		start：每页开始行数，limit：每页行数，actionbtn：前台触发事件，datavalue，前台传入的更新数据
/// Return：	"0":删除失败	"1":删除成功	
/// d ##Class(CT.WS.web.DicDataValueMapLR).GetJsonDate(0,12,"1^^家庭关系代码","updateidbtn","ID:105^CtmDictCode:erer^CtmDictComment:32432^CtmDictLink:3333^CtmDictOther:23222ded")
ClassMethod GetJsonDate(strSystemCode As %String, nodeCode As %String, nodeRightCode As %String, actionBtn As %String, leftlength As %String, seldataleft As %String, seldataright As %String, delectIds As %String)
{
   	s strValue = ""
   	//系统编码
   	if (strSystemCode=""&strSystemCode=$char(0))
	{
		q ""
	}
	//自定义字典定义编码
   	if (nodeCode=""&nodeCode=$char(0))
	{
		q ""
	}
   	//对维护字典进行更新处理
   	if (actionBtn '= ""&leftlength'= "")
   	{
	   	if (actionBtn = "btndataMap")
	   	{
		   	//映射右边标准值域代码"CtmDictCode:01^CtmDictDesc:病历概要"
			s strDevids = $p(seldataright,"^",1)
			s strDevidV = $p(strDevids,":",2)
			s strMeanings = $p(seldataright,"^",2)
			s strMeaningV = $p(strMeanings,":",2)
			s objEDataValueMap = ""
		   	for inti=1:1:leftlength
		   	{
			 	//映射左边自定义字典数据集合"DEVID:04^Meaning:CZ-藏族|@|DEVID:05^Meaning:WWEZ-维吾尔族"
				s strLeftDataS =$p(seldataleft,"|@|",inti)
				s strCtmDictCodes = $p(strLeftDataS,"^",1)
				s strCtmDictCodeV = $p(strCtmDictCodes,":",2)
				s strCtmDictDescs = $p(strLeftDataS,"^",2)
				s strCtmDictDescV = $p(strCtmDictDescs,":",2)
				// 检查数据是否唯一
				s objEDataValueMap = ##Class(CT.WS.entity.EDataValueMap).%New()
		   		s objEDataValueMap.SystemCode = strSystemCode
		   		s objEDataValueMap.DicCode = nodeCode
		   		s objEDataValueMap.DECVMID = nodeRightCode
		   		s objEDataValueMap.CtmDictCode = strCtmDictCodeV
		   		s objEDataValueMap.CtmDictDesc = strCtmDictDescV
		   		s objEDataValueMap.DEVID = strDevidV
		   		s objEDataValueMap.Meaning = strMeaningV
		   		s rowid = ""
		   		s rowid = ##Class(CT.WS.BO.BODataValueMap).CheckExist(objEDataValueMap.SystemCode,objEDataValueMap.DicCode,objEDataValueMap.CtmDictCode)
				if (rowid = "")
				{
					s res = ##Class(CT.WS.BO.BODataValueMap).CreateDataValueMap(objEDataValueMap)
				}
				else
				{
					
					s objEDataValueMap.ID = rowid
		   			s res = ##Class(CT.WS.BO.BODataValueMap).UpdateGlossaryItemMap(objEDataValueMap)
				}
		   	}
	   	}
	   	elseif (actionBtn = "btnDelete"&delectIds'="")
	   	{
		   	for intj=1:1:$l(delectIds,"^")
		   	{
			   	s deleteid = $p($p(delectIds,"^",intj),":",2)
		   		s res = ##Class(CT.WS.BO.BODataValueMap).DeleteGlossaryItemMap(deleteid)
		   	}
	   	}
   	}
   
	s jsons = ##class(CT.WS.BO.BODataValueMap).GetDataJson(strSystemCode,nodeCode)
	w jsons
}

}
