Class EMRservice.Ajax.Tooth Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	
	if (action = "TP")
	{
		//获取牙位信息
		s ResultStream = ..GetToothPosition()
		//输出流数据
		while (ResultStream.AtEnd = 0)
		{
			w $ZSTRIP(ResultStream.Read(32000),"*C",,$c(1)_$c(2))
		}
	}
	elseif (action = "TS")
	{
		//获取牙面信息
		s ResultStream = ..GetToothSurface()
		//输出流数据
		while (ResultStream.AtEnd = 0)
		{
			w $ZSTRIP(ResultStream.Read(32000),"*C",,$c(1)_$c(2))
		}
	}
	elseif (action = "TR")
	{
		//获取牙面信息
		s ResultStream = ..GetToothRepresentation()
		//输出流数据
		while (ResultStream.AtEnd = 0)
		{
			w $ZSTRIP(ResultStream.Read(32000),"*C",,$c(1)_$c(2))
		}
	}
	elseif (action = "ToothNumAndSur")
	{
		//牙位编号
		s ResultStream = ..GetToothNumAndSur()
		//输出流数据
		while (ResultStream.AtEnd = 0)
		{
			w $ZSTRIP(ResultStream.Read(32000),"*C",,$c(1)_$c(2))
		}
	}
	elseif (action = "ToothBasicSurface")
	{
		//获取牙面编码
		s ResultStream = ..GetBasicSurface()
		//输出流数据
		while (ResultStream.AtEnd = 0)
		{
			w $ZSTRIP(ResultStream.Read(32000),"*C",,$c(1)_$c(2))
		}
	}
	elseif (action = "ToothIdent")
	{
		//获取所有的牙位表示法
		s ResultStream = ..GetToothIdent()
		//输出流数据
		while (ResultStream.AtEnd = 0)
		{
			w $ZSTRIP(ResultStream.Read(32000),"*C",,$c(1)_$c(2))
		}
	}
	
	Quit $$$OK
}

/// w ##Class(EMRservice.Ajax.Tooth).GetToothIdent().Read()
ClassMethod GetToothIdent() As %GlobalCharacterStream
{
	s ToothStatus = ""
	s json = ##Class(%GlobalCharacterStream).%New()
	s total = 0
	s select = ""
	d json.Write("{""ident"":")
	d json.Write("[")
	for{
		s ToothStatus = $o(^DHCEMRM.ToothRepresentationI("IdxStatusCode",ToothStatus))
		q:ToothStatus=""
		s ToothCode = ""
		for{
			s ToothCode = $o(^DHCEMRM.ToothRepresentationI("IdxStatusCode",ToothStatus,ToothCode))
			q:ToothCode=""
			s rowID = $o(^DHCEMRM.ToothRepresentationI("IdxStatusCode",ToothStatus,ToothCode,""))
			s objTooth=##class(EMRmeta.ToothRepresentation).%OpenId(rowID)
			if (total'=0){
				d json.Write(",")
			}
			s toothDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",objTooth.ToothName)
			d json.Write("{")
			d json.Write("""Code"":"""_objTooth.ToothCode_""",")
			d json.Write("""Status"":"""_objTooth.Status_""",")
			d json.Write("""ID"":"""_objTooth.%Id()_""",")
			d json.Write("""Desc"":"""_toothDesc_""",")
			s ToothIdent = ..GetIdentNum(objTooth.ToothCode)
			d json.Write("""ToothIdent"":"_ToothIdent_"")
			d json.Write("}")
			
			s total = total+1
			
			if ($replace(ToothStatus," ","")="1"){
				s select = objTooth.ToothCode
				}
		}
	}
 	d json.Write("],""select"":"_""""_select_"""}")
 	q json
}

/// w ##Class(EMRservice.Ajax.Tooth).GetIdentNum("AUR.1")
ClassMethod GetIdentNum(code As %String) As %String
{
	s json = ##Class(%GlobalCharacterStream).%New()
	d json.Write("{")
	s count = 0
	
	s rowId = ""
	for{
		s rowId = $o(^EMRmeta.ToothRepresentItemI("IdxRepresent"," "_code,rowId))
		q:rowId=""
		if (count>0){
			d json.Write(",")
			}
		s obj = ##Class(EMRmeta.ToothRepresentItem).%OpenId(rowId)
		s ToothPCode = obj.ToothPCode
		s ToothPDes = obj.ToothPDes
		s ToothPQuadrant = obj.ToothPQuadrant
		d json.Write(""""_ToothPCode_""""_":{")
		d json.Write("""ToothPDes"":"""_ToothPDes_""",")
	 	d json.Write("""ToothPQuadrant"":"""_ToothPQuadrant_"""}")
		s count = count+1
	}
	d json.Write("}")
	q json.Read()
}

/// w ##Class(EMRservice.Ajax.Tooth).GetBasicSurface().Read()
ClassMethod GetBasicSurface() As %GlobalCharacterStream
{
	s result = ##Class(%ResultSet).%New("EMRservice.BL.BLToothPosition:SelectToothSurface")
	s sc = result.Execute()
 	s json = ##Class(%GlobalCharacterStream).%New()
 	d json.Write("{")
 	s count = 0
 	While (result.Next())
 	{
	 	if (count > 0)
	 	{
		 	d json.Write(",")
		}
		
		s ToothSICode = $g(result.Data("ToothSICode"))
		s SurfaceCode = $p(ToothSICode,".",3)
		s SurfaceID = $O(^DHCEMRM.ToothSurfaceI("IdxCode"," "_SurfaceCode,""))
		if (SurfaceID '= "")
		{
			s SurfaceObj = ##class(EMRmeta.ToothSurface).%OpenId(SurfaceID)
			s SurfaceDefine = SurfaceObj.ToothSDefine
		}
		
	    d json.Write(""""_$g(result.Data("ToothSCode"))_""""_":{")
		d json.Write("""ID"":"""_$g(result.Data("ID"))_""",")
	 	d json.Write("""Desc"":"""_$g(result.Data("ToothSDefine"))_""",")
	 	d json.Write("""Code"":"""_$g(result.Data("ToothSCode"))_""",")
		d json.Write("""Value"":"""_$g(result.Data("ToothSDes"))_"""}" )
		
		s count = count + 1
 	}
 	d json.Write("}")
	q json
}

// 获取牙位对应的编码信息以及牙面信息

// w ##Class(EMRservice.Ajax.Tooth).GetToothNumAndSur().Read()

ClassMethod GetToothNumAndSur() As %String
{
	s result = ##Class(%ResultSet).%New("EMRservice.BL.BLToothPosition:SelectTPosition")
	s sc = result.Execute()
 	s json = ##Class(%GlobalCharacterStream).%New()
 	s count = 0
 	d json.Write("{")
 	While (result.Next())
 	{
	 	if (count > 0)
	 	{
		 	d json.Write(",")
		}
		s surfacePCode = $g(result.Data("ToothPCode"))
		s SurfaceObj = ..GetSurfacePDesc(surfacePCode)
	 	d json.Write(""""_$g(result.Data("ToothPCode"))_""""_":{")
		d json.Write("""ID"":"""_$g(result.Data("ID"))_""",")
	 	d json.Write("""Code"":"""_surfacePCode_""",")
	 	d json.Write("""Desc"":"""_$g(result.Data("ToothPDes"))_""",")
		d json.Write("""Define"":"""_$g(result.Data("ToothPDefine"))_""",")
		d json.Write("""Quadrant"":"""_$g(result.Data("ToothPQuadrant"))_""",")
		d json.Write("""SurfaceObj"":"_SurfaceObj_",")
		d json.Write("""Type"":"""_$g(result.Data("ToothType"))_"""}" )
		s count = count + 1
 	}
 	d json.Write("}")
 	q json
}

/// w ##Class(EMRservice.Ajax.Tooth).GetSurfacePDesc("AUR.1")
ClassMethod GetSurfacePDesc(surfacePCode) As %String
{
	s result = ##Class(%ResultSet).%New("EMRservice.BL.BLToothPosition:SelectTSItemByTPCode")
	s sc = result.Execute(surfacePCode)
 	s json = ##Class(%GlobalCharacterStream).%New()
 	d json.Write("{")
 	s count = 0
 	While (result.Next())
 	{
	 	if (count > 0)
	 	{
		 	d json.Write(",")
		}
		
		s ToothSICode = $g(result.Data("ToothSICode"))
		s SurfaceCode = $p(ToothSICode,".",3)
		s SurfaceID = $O(^DHCEMRM.ToothSurfaceI("IdxCode"," "_SurfaceCode,""))
		s SurfaceDefine = ""
		if (SurfaceID '= "")
		{
			s SurfaceObj = ##class(EMRmeta.ToothSurface).%OpenId(SurfaceID)
			s SurfaceDefine = SurfaceObj.ToothSDefine
		}
		d json.Write(""""_SurfaceCode_""""_":{")
	 	d json.Write("""ID"":"""_$g(result.Data("ID"))_""",")
	 	d json.Write("""ToothPCode"":"""_$g(result.Data("ToothPCode"))_""",")
		d json.Write("""ToothSICode"":"""_$g(result.Data("ToothSICode"))_""",")
		d json.Write("""ToothSIDes"":"""_$g(result.Data("ToothSIDes"))_""",")
		d json.Write("""ToothSIDefine"":"""_$g(result.Data("ToothSIDefine"))_""",")
		d json.Write("""ScriptMode"":"""_$g(result.Data("ScriptMode"))_""",")
		d json.Write("""ToothType"":"""_$g(result.Data("ToothType"))_""",")
		d json.Write("""SurfaceCode"":"""_SurfaceCode_""",")
		d json.Write("""SurfaceDefine"":"""_SurfaceDefine_"""}")
		
		
		s count = count + 1
 	}
 	d json.Write("}")
	q json.Read()
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
		d json.Write("""Quadrant"":"""_$g(result.Data("ToothPQuadrant"))_""",")
		d json.Write("""Type"":"""_$g(result.Data("ToothType"))_"""}" )
		
		s count = count + 1
 	}
 	d json.Write("],TotalCount:'"_count_"'}")
 	q json
}

/// w ##Class(EMRservice.Ajax.Tooth).GetToothSurface().Read()
ClassMethod GetToothSurface() As %GlobalCharacterStream
{
	s result = ##Class(%ResultSet).%New("EMRservice.BL.BLToothPosition:SelectTSItemByTPCode")
	s sc = result.Execute("AUL.1")
 	s json = ##Class(%GlobalCharacterStream).%New()
 	d json.Write("{success:true,Data:[")
 	s count = 0
 	While (result.Next())
 	{
	 	if (count > 0)
	 	{
		 	d json.Write(",")
		}
		
		s ToothSICode = $g(result.Data("ToothSICode"))
		s SurfaceCode = $p(ToothSICode,".",3)
		s SurfaceID = $O(^DHCEMRM.ToothSurfaceI("IdxCode"," "_SurfaceCode,""))
		if (SurfaceID '= "")
		{
			s SurfaceObj = ##class(EMRmeta.ToothSurface).%OpenId(SurfaceID)
			s SurfaceDefine = SurfaceObj.ToothSDefine
		}
		
	 	d json.Write("{""ID"":"""_$g(result.Data("ID"))_""",")
	 	d json.Write("""ToothPCode"":"""_$g(result.Data("ToothPCode"))_""",")
		d json.Write("""ToothSICode"":"""_$g(result.Data("ToothSICode"))_""",")
		d json.Write("""ToothSIDes"":"""_$g(result.Data("ToothSIDes"))_""",")
		d json.Write("""ToothSIDefine"":"""_$g(result.Data("ToothSIDefine"))_""",")
		d json.Write("""ScriptMode"":"""_$g(result.Data("ScriptMode"))_""",")
		d json.Write("""ToothType"":"""_$g(result.Data("ToothType"))_""",")
		d json.Write("""SurfaceCode"":"""_SurfaceCode_""",")
		d json.Write("""SurfaceDefine"":"""_SurfaceDefine_"""}")
		
		s count = count + 1
 	}
 	d json.Write("],TotalCount:'"_count_"'}")
	q json
}

/// w ##Class(EMRservice.Ajax.Tooth).GetToothRepresentation().Read()
ClassMethod GetToothRepresentation()
{
	s result = ##class(EMRservice.entity.EToothRepresentation).%New()
	s result = ##Class(EMRservice.BL.BLToothPosition).GetCurToothRepresentation()
 	s json = ##Class(%GlobalCharacterStream).%New()
 	if (result.ID '= "")&&(result.ToothCode '= "")
 	{
 		d json.Write("{success:true,Data:[")
 		d json.Write("{""ID"":"""_result.ID_""",")
		d json.Write("""Code"":"""_result.ToothCode_""",")
		d json.Write("""Name"":"""_result.ToothName_""",")
		d json.Write("""Status"":"""_result.Status_"""}" )
 		d json.Write("],TotalCount:'1'}")
 	}
 	else
    {
	    d json.Write("-1")
	}
 	q json
}

}
