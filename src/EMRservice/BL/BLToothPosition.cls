/// 名称: 牙位图BL层
/// 描述: 牙位图
/// 编写者：yejian
/// 编写日期: 2018-1-31
Class EMRservice.BL.BLToothPosition Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc: 初始化数据
/// Creator:yejian
/// CreateDate:2020-7-22
/// Debug:d ##Class(EMRservice.BL.BLToothPosition).InitData()
ClassMethod InitData()
{
		//FDI：FDI牙位表示法,PALMER：帕尔默牙位表示法,UNIVERSAL：通用记录表示法,GB/T9938-2013：牙科学牙位和口腔区域的标示法
		d ##Class(EMRservice.BL.BLToothPosition).AddData("FDI","FDI牙位表示法",0)
		d ##Class(EMRservice.BL.BLToothPosition).AddData("PALMER","帕尔默牙位表示法",0)	
		d ##Class(EMRservice.BL.BLToothPosition).AddData("UNIVERSAL","通用记录表示法",0)
		d ##Class(EMRservice.BL.BLToothPosition).AddData("GB/T9938-2013","牙科学牙位和口腔区域的标示法",1)
}

/// Desc:添加目录数据
/// Creator:Candy
/// CreateDate:2018-2-28
/// Input: AName 名称
///       AType 类型
///       AParentID 父节点
ClassMethod AddData(ACode As %String, AName As %String, AStatus As %String) As %String
{
		s result = ""
		q:(ACode = "")||(AName = "")||(AStatus = "") result
		s rowId = $o(^DHCEMRM.ToothRepresentationI("IdxCode"," "_$zcvt(ACode,"u"),""))
		if (rowId = "")
		{
			s obj = ##Class(EMRmeta.ToothRepresentation).%New()
		}
		else
		{
			s obj = ##Class(EMRmeta.ToothRepresentation).%OpenId(rowId)
		}
		s obj.ToothCode = ACode
		s obj.ToothName = AName
		s obj.Status = AStatus
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = "1"
		q result
}

/// Desc: 批量处理更新牙象限数据
/// Creator:yejian
/// CreateDate:2020-7-22
/// Debug:d ##Class(EMRservice.BL.BLToothPosition).SetQuadrantDatas()
ClassMethod SetQuadrantDatas() As %String
{
	s result = "1"
	s objCruTooth = ##Class(EMRservice.BL.BLToothPosition).GetCurToothRepresentation()
	if ((objCruTooth="")||(objCruTooth.ToothCode=""))
	{
		d ##Class(EMRservice.BL.BLToothPosition).InitData()
		s objCruTooth = ##Class(EMRservice.BL.BLToothPosition).GetCurToothRepresentation()
	}
	s ToothPCode = ""
	for {
		s ToothPCode = $o(^DHCEMRM.ToothPositionI("IdxCode",ToothPCode))
		q:(ToothPCode="")
		s rowID = $o(^DHCEMRM.ToothPositionI("IdxCode",ToothPCode,""))
		q:(rowID="")
		set objTooth=##class(EMRmeta.ToothPosition).%OpenId(rowID)
		q:(objTooth="")
		s objTooth.ToothPQuadrant = ##Class(EMRservice.BL.BLToothPosition).GetToothPQuadrant(objTooth.ToothPCode,objCruTooth.ToothCode)
		s sc = objTooth.%Save()
		if ('$$$ISOK(sc)) 
		{
			s result = "-1"
			q
		}
	}		
	q result
}

/// 根据编码获取牙象限
ClassMethod GetToothPQuadrant(aToothPCode As %String, aToothCode As %String) As %String
{
	s ToothPQuadrant = ""
	q:((aToothPCode="")||(aToothCode="")) ToothPQuadrant
	if ((aToothCode="FDI")||(aToothCode="GB/T9938-2013"))
	{
		if ((aToothPCode [ "AUR")||(aToothPCode [ "CUR"))
		{
			s ToothPQuadrant = "10"
		}
		elseif ((aToothPCode [ "AUL")||(aToothPCode [ "CUL"))
		{
			s ToothPQuadrant = "20"
		}
		elseif ((aToothPCode [ "ALL")||(aToothPCode [ "CLL"))
		{
			s ToothPQuadrant = "30"
		}
		elseif ((aToothPCode [ "ALR")||(aToothPCode [ "CLR"))
		{
			s ToothPQuadrant = "40"
		}
	}
	else
	{
		if ((aToothPCode [ "AUR")||(aToothPCode [ "CUR"))
		{
			s ToothPQuadrant = "A"
		}
		elseif ((aToothPCode [ "AUL")||(aToothPCode [ "CUL"))
		{
			s ToothPQuadrant = "B"
		}
		elseif ((aToothPCode [ "ALL")||(aToothPCode [ "CLL"))
		{
			s ToothPQuadrant = "C"
		}
		elseif ((aToothPCode [ "ALR")||(aToothPCode [ "CLR"))
		{
			s ToothPQuadrant = "D"
		}
	}		
	q ToothPQuadrant
}

/// 查询所有牙位表示法
Query SelectToothRepresentation() As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%Integer,ToothCode:%String,ToothName:%String,Status:%String", SELECTMODE = "RUNTIME")
{
	SELECT ID,ToothCode,ToothName,Status
    FROM EMRmeta.ToothRepresentation
}

/// 获取当前使用的牙位表示法
ClassMethod GetCurToothRepresentation() As EMRservice.entity.EToothRepresentation
{
	set Result = ##class(EMRservice.entity.EToothRepresentation).%New()
	s ToothCode = ""
	s ToothCode = $o(^DHCEMRM.ToothRepresentationI("IdxStatusCode"," 1",ToothCode))
	q:(ToothCode="") Result
	s rowID = $o(^DHCEMRM.ToothRepresentationI("IdxStatusCode"," 1",ToothCode,""))
	q:(rowID="") Result
	set objTooth=##class(EMRmeta.ToothRepresentation).%OpenId(rowID)
	set Result.ID = objTooth.%Id()
	set Result.ToothCode = objTooth.ToothCode
	set Result.ToothName = objTooth.ToothName
	set Result.Status = objTooth.Status
	Quit Result
}

/// 设置当前使用的牙位表示法
ClassMethod UpdateToothRepresentation(aToothCode As %String) As %String
{
	s res ="1"
	s ToothCode = ""
	for {
		s ToothCode = $o(^DHCEMRM.ToothRepresentationI("IdxCode",ToothCode))
		q:(ToothCode="")
		s rowID = $o(^DHCEMRM.ToothRepresentationI("IdxCode",ToothCode,""))
		q:(rowID="")
		set objTooth=##class(EMRmeta.ToothRepresentation).%OpenId(rowID)
		q:(objTooth="")
		if (objTooth.ToothCode =aToothCode)
		{
			s objTooth.Status = "1"
		}
		else
		{
			s objTooth.Status = "0"
		}
		s sc = objTooth.%Save()
		if ('$$$ISOK(sc))
		{		
			 s res = "-1"
			 q
		}
	}
	q res
}

/// 查询所有牙位数据
Query SelectTPosition() As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%Integer,ToothPCode:%String,ToothPDes:%String,ToothPDefine:%String,ToothPQuadrant:%String,ToothType:%String", SELECTMODE = "RUNTIME")
{
	SELECT ID,ToothPCode, ToothPDes,ToothPDefine,ToothPQuadrant,ToothType
    FROM EMRmeta.ToothPosition
}

Query SelectTPositionByCode(AToothCode As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%Integer,ToothPCode:%String,ToothPDes:%String,ToothPDefine:%String,ToothPQuadrant:%String,ToothType:%String", SELECTMODE = "RUNTIME")
{
	SELECT ID,ToothPCode, ToothPDes,ToothPDefine,ToothPQuadrant,ToothType
    FROM EMRmeta.ToothPosition WHERE ToothPCode = :AToothCode
}

/// 更新一个牙位信息
ClassMethod UpdateToothPos(aEToothPos As EMRservice.entity.EToothPosition) As %String [ WebMethod ]
{
	set objPos=##class(EMRmeta.ToothPosition).%OpenId(aEToothPos.ID)
	q:(objPos="") ""	
	;s objPos.ToothPCode=$case(aEToothPos.ToothPCode,$c(0):"",:aEToothPos.ToothPCode)		
	;s objPos.ToothPDefine=$case(aEToothPos.ToothPDefine,$c(0):"",:aEToothPos.ToothPDefine)
	s objPos.ToothPDes=$case(aEToothPos.ToothPDes,$c(0):"",:aEToothPos.ToothPDes)
	s sc = objPos.%Save()
	if ($$$ISOK(sc))
	{		
		 q aEToothPos.ID
	}
	else
	{
		 q "-1"	
	}
}

/// 更新所有牙位描述
ClassMethod UpdateAllToothPos(argStr As %String) As %String
{
	 s objCruTooth = ##Class(EMRservice.BL.BLToothPosition).GetCurToothRepresentation()
	 S IDCount =$L(argStr,",")
	 S strMrk= 1
	 TSTART 
	 For I=1:1:IDCount
	 {
		S argstrItem= $P(argStr,",",I)
		S argPosCode = $P(argstrItem,"^",1)
		S argPosDes = $P(argstrItem,"^",2)
		if ($d(argPosCode)=0)||(argPosCode="")||($d(argPosDes)=0)||(argPosDes="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s objPos="",result=""
		s argPosID = $o(^DHCEMRM.ToothPositionI("IdxCode"," "_argPosCode,""))
		s objPos=##class(EMRmeta.ToothPosition).%OpenId(argPosID)
		if (objPos ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s objPos.ToothPDes=argPosDes
		s objPos.ToothPQuadrant = ##Class(EMRservice.BL.BLToothPosition).GetToothPQuadrant(argPosCode,objCruTooth.ToothCode)
		s result=""
		if '(objPos.%Save())
		{
			TROLLBACK
			s strMrk = 0
		    quit
		}
	 }
	 if (strMrk = 0)
	 {
		 TROLLBACK
		 quit 0
	 }
	TCOMMIT
	Quit 1
}

/// 查询所有牙位数据
Query SelectTSurfaceItem() As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%Integer,ToothPCode:%String,ToothSICode:%String,ToothSIDes:%String,ToothSIDefine:%String,ScriptMode:%String,ToothType:%String", SELECTMODE = "RUNTIME")
{
	SELECT ID,ToothPCode, ToothSICode,ToothSIDes,ToothSIDefine,ScriptMode,ToothType
    FROM EMRmeta.ToothSurfaceItem
}

/// 更新一个牙位信息
ClassMethod UpdateToothSItem(aEToothSItem As EMRservice.entity.EToothSurfaceItem) As %String [ WebMethod ]
{
	set objSItem=##class(EMRmeta.ToothSurfaceItem).%OpenId(aEToothSItem.ID)
	q:(objSItem="") ""	
	s objSItem.ToothSIDes=$case(aEToothSItem.ToothSIDes,$c(0):"",:aEToothSItem.ToothSIDes)
	s objSItem.ScriptMode=$case(aEToothSItem.ScriptMode,$c(0):"",:aEToothSItem.ScriptMode)
	s sc = objSItem.%Save()
	if ($$$ISOK(sc))
	{		
		 q aEToothSItem.ID
	}
	else
	{
		 q "-1"	
	}
}

/// 更新所有牙位描述
ClassMethod UpdateAllToothSItem(argStr As %String) As %String
{
	
	 S IDCount =$L(argStr,",")
	 S strMrk= 1
	 TSTART 
	 For I=1:1:IDCount
	 {
		B
		S argstrItem= $P(argStr,",",I)
		S argPosID = $P(argstrItem,"^",1)
		S argPosDes = $P(argstrItem,"^",2)
		if ($d(argPosID)=0)||($d(argPosDes)=0)||(argPosID="")||(argPosDes="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s objSItem="",result=""
		s objSItem=##class(EMRmeta.ToothPosition).%OpenId(argPosID)
		if (objSItem ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s objSItem.ToothPDes=argPosDes
		s result=""
		if '(objSItem.%Save())
		{
			TROLLBACK
			s strMrk = 0
		    quit
		}
	 }
	 if (strMrk = 0)
	 {
		 TROLLBACK
		 quit 0
	 }
	TCOMMIT
	Quit 1
}

/// 描述：根据牙位查询牙面数据
/// 创建者：牛才才
/// 创建日期：2018-04-10
Query SelectTSItemByTPCode(ATPCode As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%Integer,ToothPCode:%String,ToothSICode:%String,ToothSIDes:%String,ToothSIDefine:%String,ScriptMode:%String,ToothType:%String", SELECTMODE = "RUNTIME")
{
	SELECT ID,ToothPCode, ToothSICode,ToothSIDes,ToothSIDefine,ScriptMode,ToothType
    FROM EMRmeta.ToothSurfaceItem WHERE ToothPCode = :ATPCode
}

/// 查询所有牙面数据
Query SelectToothSurface() As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%Integer,ToothSCode:%String,ToothSDefine:%String,ToothSDes:%String", SELECTMODE = "RUNTIME")
{
	SELECT ID,ToothSCode, ToothSDefine,ToothSDes
    FROM EMRmeta.ToothSurface
}

/// w ##Class(EMRservice.Ajax.Tooth).GetToothPosition()
ClassMethod GetToothPosition() As %String
{
	s result = ##Class(%ResultSet).%New("EMRservice.BL.BLToothPosition:SelectTPosition")
	s sc = result.Execute()
 	s json = ##Class(%GlobalCharacterStream).%New()
 	d json.Write("{success:true,Data:[")
 	s count = 0
 	While (result.Next())
 	{
	 	if (count > 0)
	 	{
		 	d json.Write(",")
		}
		
	 	d json.Write("{""ID"":"""_$g(result.Data("ID"))_""",")
	 	d json.Write("""Code"":"""_$g(result.Data("ToothPCode"))_""",")
		d json.Write("""Desc"":"""_$g(result.Data("ToothPDes"))_""",")
		d json.Write("""Define"":"""_$g(result.Data("ToothPDefine"))_""",")
		d json.Write("""Type"":"""_$g(result.Data("ToothType"))_"""}" )
		
		s count = count + 1
 	}
 	d json.Write("],TotalCount:'"_count_"'}")
 	q json
}

/// w ##Class(EMRservice.BL.BLToothPosition).GetToothPositionByCode("AUL.1")
ClassMethod GetToothPositionByCode(AToothCode As %String) As %String
{
	s ret = ""
	q:(AToothCode = "") ret
	s result = ##Class(%ResultSet).%New("EMRservice.BL.BLToothPosition:SelectTPositionByCode")
	s sc = result.Execute(AToothCode)
 	While (result.Next())
 	{
	 	s ret = $g(result.Data("ID"))_"^"_$g(result.Data("ToothPCode"))_"^"_$g(result.Data("ToothPDes"))_"^"_$g(result.Data("ToothPDefine"))_"^"_$g(result.Data("ToothType"))
 	}
 	q ret
}

}
