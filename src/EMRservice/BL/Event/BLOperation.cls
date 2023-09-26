/// Desc:       手术事件逻辑类
/// Creator:    Candy
/// CreateDate: 2015-4-1 
Class EMRservice.BL.Event.BLOperation Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// Desc:       手术事件(数据推送接口)
/// Creator:    Candy
/// CreateDate: 2015-3-23
/// Input:      APatientID 病人ID
///             AEpisodeID 就诊号
///             AOpaID 手术ID
///             AOperID 手术代码表ID
///             AOperDesc 手术手术名称
///             OperLevel  手术等级
///             OperDocID  术者
///             AOperAssistFirstID 一助ID
///             AOperAssistFirstDesc 一助 
///             AOperAssistSecondID 二助ID
///             AOperAssistSecondDesc 二助
///             AOperDate (cache内部格式) 手术日期
///             AOperTime (cache内部格式) 手术时间
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLOperation).SetData(48,76,1,"01","身体检查n",1,63634,36676,105,"王芳",1,"n1",3,"n3")
ClassMethod SetData(AID As %String, APatientID As %String, AEpisodeID As %String, AData As %GlobalBinaryStream) As %String
{
		s result = "0"
		q:(AData.Size<=0) result
		s objJson = ##Class(EMRservice.Parser.Json).%New()  
		s array = objJson.Deserialize(AData)
		if (AID = "")
		{
			s cmdObj = "obj = ##class(EMRinstance.Events.Operation).%New()"
			s @cmdObj
			s cmdPropety = "obj.PatientID ="_APatientID
			s @cmdPropety
			s cmdPropety = "obj.EpisodeID ="_AEpisodeID
			s @cmdPropety
			s cmdPropety = "obj.CreateDate ="_$p($h,",",1)
			s @cmdPropety
			s cmdPropety = "obj.CreateTime ="_$p($h,",",2)
			s @cmdPropety
			s cmdPropety = "obj.IsActive ="_"""Y"""	
			s @cmdPropety	
		}
		else
		{
			s cmdObj = "obj = ##class(EMRinstance.Events.Operation).%OpenId("_AID_")"	
			s @cmdObj
			&SQL(delete from EMRinstance_Events.OperationSub where OperRef=:AID)
		}
	
		s key = ""
		for 
		{
			s value = array.GetNext(.key)
			q:(key = "")
			continue:((key = "operSubs")||(value = ""))
			s cmdPropety = "obj."_key_" = """_value_""""
			s @cmdPropety
		} 
		s result = 1
		Tstart
		s cmdObjSave = "scobj = obj.%Save()"
		s @cmdObjSave 
		if ($$$ISOK(@"scobj"))
		{
			s count = array.GetAt("operSubs").Count()
			for i=1:1:count
			{
				s subId = array.GetAt("operSubs").GetAt(i).GetAt("SubID")
				if (subId = "")
				{
					s cmdObjSub = "objSub = ##class(EMRinstance.Events.OperationSub).%New()"
				}
				else
				{
					s cmdObjSub = "objSub = ##class(EMRinstance.Events.OperationSub).%OpenId("_subId_")"
				}
				s @cmdObjSub
				s subKey = ""
				for
				{
					s subValue = array.GetAt("operSubs").GetAt(i).GetNext(.subKey)
					q:(subKey = "")
					continue:(subKey = "SubID")
					continue:(subValue = "")
					s cmdPropety = "objSub."_subKey_" = """_subValue_""""
					s @cmdPropety
				}
				s cmdPropety = "objSub.OperRef = obj"
				s @cmdPropety	
				s cmdObjSub = "scobjsub = objSub.%Save()"
				s @cmdObjSub
				if (@"scobjsub" '= 1)
				{
					Trollback
					s result = 0
					q
				}
				q:(result = 0)				
			}
			if (result '= 0) 
			{
				TCOMMIT
				s cmdGetId = "result = obj.%Id()"
				s @cmdGetId
				s result = @"result"
			}
		}
		q result
}

/// Desc:        取抢救记录
/// Creator:     Candy
/// CreateDate:  2013-3-23
/// Input:       AEpisodeID 就诊ID
/// Output:      result 
/// Debug:       w ##Class(EMRservice.BL.Event.BLOperation).GetData(76)
ClassMethod GetData(AEpisodeID As %String) As %String
{
	s result = ""
	s count = 0
	q:(AEpisodeID = "") result
	s flag = ""
	for
	{
		s flag = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag),-1)
		q:(flag = "")
		s date = ""
		for
		{
		    s date = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date),-1)
		    q:(date = "")
		    s time = ""
		    for
		    {
		    	s time = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time),-1)
		    	q:(time = "")
		    	s rowId = "" 
			    for
			    {
			    	s rowId = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time,rowId))
			    	q:(rowId = "")
			    	s obj = ##Class(EMRinstance.Events.Operation).%OpenId(rowId)
			    	continue:(obj = "")
			    	s subId = $o(^DHCEMRI.Events.OperationSubI("IdxOperRef",rowId,""))
			    	continue:(subId = "")
			    	s objSub = ##Class(EMRinstance.Events.OperationSub).%OpenId(rowId_"||"_subId)
			    	continue:(objSub = "")
					s isActive = $case(obj.IsActive,"Y":"提示",:"不提示")
					s:((obj.OperPAStatus = "拒绝")||(obj.OperPAStatus = "撤销")) isActive = "不提示"
			    	
			    	s textField = objSub.Oper
			    	
			    	s:(count '= 0) result = result_","
			    	s result = result_"{"
			    	s result = result_"""ID"":"""_rowId_""""
			    	s result = result_",""OpaID"":"""_obj.OpaID_""""
			    	s result = result_",""OperID"":"""_objSub.OperID_""""
 				    s result = result_",""OperCode"":"""_$Case(objSub.OperID,"":objSub.OperID,:$p($g(^ORC("OPER",objSub.OperID)),"^",1))_""""
			    	s result = result_",""OperDesc"":"""_objSub.Oper_""""
			    	s result = result_",""OperLevel"":"""_objSub.OperLevel_""""
			    	s result = result_",""OperDocID"":"""_obj.OperDocID_""""
			    	s result = result_",""OperDocName"":"""_obj.OperDoc_""""
			    	s result = result_",""OperAssistFirstID"":"""_obj.OperAssistFirstID_""""
			    	s result = result_",""OperAssistFirstDesc"":"""_obj.OperAssistFirst_""""
			    	s result = result_",""OperAssistSecondID"":"""_obj.OperAssistSecondID_""""
			    	s result = result_",""OperAssistSecondDesc"":"""_obj.OperAssistSecond_""""
			    	s result = result_",""OperAssistThirdID"":"""_obj.OperAssistThirdID_""""
			    	s result = result_",""OperAssistThirdDesc"":"""_obj.OperAssistThird_""""
			    	s result = result_",""OperDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$Case(obj.OperStartDate,"":obj.OperDate,:obj.OperStartDate))_""""
			    	s result = result_",""OperTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$Case(obj.OperStartTime,"":"",:obj.OperStartTime))_""""
			    	s result = result_",""IsActive"":"""_isActive_""""
			    	s result = result_",""TextField"":"""_textField_""""
			    	s result = result_",""OperPAStatus"":"""_obj.OperPAStatus_""""
			    	s result = result_"}"
			    	s count = count + 1
				}
		    }
		}			
	}
	q result
}

/// Desc:        取手术记录
/// Creator:     Candy
/// CreateDate:  2016-2-18
/// Input:       AEpisodeID 就诊ID
/// Output:      result 
/// Debug:       w ##Class(EMRservice.BL.Event.BLOperation).GetDataToXml(76)
ClassMethod GetDataToXml(AEpisodeID As %String) As %GlobalBinaryStream
{
	s stream = ##Class(%GlobalBinaryStream).%New()
	q:(AEpisodeID = "") stream
	d stream.Write("<Operations>")
	s flag = ""
	for
	{
		s flag = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag),-1)
		q:(flag = "")
		s date = ""
		for
		{
		    s date = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date),-1)
		    q:(date = "")
		    s time = ""
		    for
		    {
		    	s time = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time),-1)
		    	q:(time = "")
		    	s rowId = "" 
			    for
			    {
			    	s rowId = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time,rowId))
			    	q:(rowId = "")
			    	s obj = ##Class(EMRinstance.Events.Operation).%OpenId(rowId)
			    	continue:(obj = "")
			    	s subId = $o(^DHCEMRI.Events.OperationSubI("IdxOperRef",rowId,""))
			    	continue:(subId = "")
			    	s objSub = ##Class(EMRinstance.Events.OperationSub).%OpenId(rowId_"||"_subId)
			    	continue:(objSub = "")
					d stream.Write("<Operation>")
					d stream.Write("<ID>"_rowId_"</ID>")
					d stream.Write("<OpaID>"_obj.OpaID_"</OpaID>")
					d stream.Write("<OperID>"_objSub.OperID_"</OperID>")
					d stream.Write("<OperName>"_##Class(EMRservice.Util.EscapeSpecialWord).XmlEscape($zcvt(objSub.Oper,"O","UTF8"))_"</OperName>")
					d stream.Write("<OperLevel>"_$zcvt(objSub.OperLevel,"O","UTF8")_"</OperLevel>") 
					d stream.Write("<OperDateTime>"_$Case(obj.OperStartDate,"":obj.OperDate,:obj.OperStartDate)_" "_$Case(obj.OperStartTime,"":"",:$zt(obj.OperStartTime))_"</OperDateTime>") 
					d stream.Write("<OperDocID>"_$zcvt(obj.OperDocID,"O","UTF8")_"</OperDocID>")
					d stream.Write("<OperDocName>"_$zcvt(obj.OperDoc,"O","UTF8")_"</OperDocName>") 
					d stream.Write("<OperAssistFirstID>"_$zcvt(obj.OperAssistFirstID,"O","UTF8")_"</OperAssistFirstID>")
					d stream.Write("<OperAssistFirstName>"_$zcvt(obj.OperAssistFirst,"O","UTF8")_"</OperAssistFirstName>")
					d stream.Write("<OperAssistSecondID>"_$zcvt(obj.OperAssistSecondID,"O","UTF8")_"</OperAssistSecondID>")
					d stream.Write("<OperAssistSecondName>"_$zcvt(obj.OperAssistSecond,"O","UTF8")_"</OperAssistSecondName>")
					d stream.Write("</Operation>")
				}
		    }
		}			
	}
	d stream.Write("</Operations>")
	q stream
}

/// Desc:       更改已完成状态并关联病历
/// Creator:    Candy
/// CreateDate: 2015-3-25
/// Input:      AIDs 以","分隔
///             AEpisodeID 就诊号
/// OutPut:     result 
ClassMethod SetFinish(AIDs As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	d ..SetUnActive(AIDs)
	for i=1:1:$l(AIDs,"@")
	{
		s rowId = $p(AIDs,"@",i)
		continue:(rowId = "")
		s result = ##Class(EMRservice.BL.Event.BLLinkDocument).SaveLinkDocumnet(AInstanceID,"Operation",rowId)
        q:(result = "0")
	}
	q result
}

/// Desc:       设置条目不再提示
/// Creator:    Candy
/// CreateDate: 2015-4-8
/// Input:      AID 表的rowID
/// Output:     result 1成功 0失败
ClassMethod SetUnActive(AIDs As %String) As %String
{
	
	s result = "0"
	q:(AIDs = "") result
	for i=1:1:$l(AIDs,"@")
	{
		s id = $p(AIDs,"@",i)
		s obj = ##Class(EMRinstance.Events.Operation).%OpenId(id)
		continue:(obj = "")
		s obj.IsActive = "N"
		s:($$$ISOK(obj.%Save())) result = "1"
		q:(result = "0")
	}
	q result
}

/// Desc: 手术名称
/// Creator:Candy
/// CreateDate:2016-1-26
/// d ##Class(EMRservice.BL.Event.BLOperation).GetORCOperation("白细胞")
ClassMethod GetORCOperation(ADesc As %String) As %String
{
	s $zt = "Error"	
	s json = ##Class(%GlobalBinaryStream).%New()
	s tmpJson = ##Class(%GlobalBinaryStream).%New()
	s inDesc = $zcvt(ADesc,"U")
	s count = 0
	d tmpJson.Write("[")
	s tmpdesc = ""
	for
	{
		s tmpdesc = $o(^ORC("OPER",0,"Desc",tmpdesc))
		q:(tmpdesc = "")
		if (inDesc '= "")
		{
			continue:(tmpdesc '[ inDesc)
		}
		s rowid = ""
		for
		{
			s rowid = $o(^ORC("OPER",0,"Desc",$zcvt(tmpdesc,"U"),rowid))
			q:(rowid = "")
			s code = $p($g(^ORC("OPER",rowid)),"^",1) 
			s desc = $p($g(^ORC("OPER",rowid)),"^",2)
			d:(count '= 0) tmpJson.Write(",")
			d tmpJson.Write("{")
			d tmpJson.Write("""ID"":"""_rowid_"""")
			d tmpJson.Write(",""Code"":"""_code_"""")
			d tmpJson.Write(",""Desc"":"""_$ZSTRIP(desc,"*C")_"""")
			d tmpJson.Write("}")
			s count = count + 1	
		}
	}
	d tmpJson.Write("]"	)
	d json.Write("{""total"":"_count_",""rows"":")
	d json.CopyFrom(tmpJson)
	d json.Write("}")
	q json
Error
	q json
}

/// Desc:术前诊断
/// Creator:Candy
/// CreateDate:2016-1-30
/// w ##Class(EMRservice.BL.Event.BLOperation).getMRCICD("糖")
ClassMethod getMRCICD(ADesc As %String) As %String
{
	s $zt = "Error"
	s json = ##Class(%GlobalBinaryStream).%New()
	s tmpJson = ##Class(%GlobalBinaryStream).%New()
	d tmpJson.Write("[")
	s inDesc = $zcvt(ADesc,"U")
	s count = 0
	s desc = ""
	for
	{
		s desc = $o(^MRC("ID",0,"Desc",desc))
		q:(desc = "")
		if (inDesc '= "")
		{
			continue:(desc '[ inDesc)
		}
		s rowid = ""
		for
		{
			s rowid = $o(^MRC("ID",0,"Desc",$zcvt(desc,"U"),rowid))
			q:(rowid = "")
			s tempcode = $p($g(^MRC("ID",rowid)),"^",1)
			s tempdesc = $p($g(^MRC("ID",rowid)),"^",2)
			d:(count '= 0) tmpJson.Write(",")
			d tmpJson.Write("{") 
			d tmpJson.Write("""ID"":"""_rowid_"""")
			d tmpJson.Write(",""Code"":"""_$ZSTRIP(tempcode,"*C")_"""")
			d tmpJson.Write(",""Desc"":"""_$ZSTRIP(tempdesc,"*C")_"""")			
			d tmpJson.Write("}")
			s count = count + 1	
		}
	}
	d tmpJson.Write("]")	
	d json.Write("{""total"":"_count_",""rows"":")
	d json.CopyFrom(tmpJson)
	d json.Write("}")
	q json
Error
	q json
}

/// Desc:手术级别
/// Creator:Candy
/// CreateDate:2016-1-26
/// Desc: w ##Class(EMRservice.BL.Event.BLOperation).GetORCOperationCategory()
ClassMethod GetORCOperationCategory(ADesc As %String = "") As %String
{
	s json = "["
	s count = 0
	s rowid = ""
	for
	{
		s rowid = $o(^ORC("CATEG",rowid))
		q:(rowid = "")
		s desc = $p(^ORC("CATEG",rowid),"^",2)
		continue:((ADesc '="")&&(desc '[ ADesc))
		s code = $p(^ORC("CATEG",rowid),"^",1)
		
		s:(count '= 0) json = json_","
		s json= json_"{"
		s json= json_"""ID"":"""_rowid_""""
		s json= json_",""Code"":"""_$ZSTRIP(code,"*C")_""""
		s json= json_",""Desc"":"""_$ZSTRIP(desc,"*C")_""""
		s json= json_"}"
		s count = count + 1	
	}
	s json = json_"]"
	s json = "{""total"":"_count_",""rows"":"_json_"}"
	q json
}

/// Desc:切口类型
/// Creator:Candy
/// CreateDate:2016-1-26
/// Desc: w ##Class(EMRservice.BL.Event.BLOperation).GetBladeType()
ClassMethod GetBladeType(ADesc As %String = "") As %String
{
	s json = "["
	s count = 0
	s rowid = "0"
	for
	{
		s rowid = $o(^ORC("BLDTP",rowid))
		q:(rowid = "")
		s code = $p(^ORC("BLDTP",rowid),"^",1)
		s desc = $p(^ORC("BLDTP",rowid),"^",2)
		continue:((ADesc '= "")&&(desc '[ ADesc))
		s:(count '= 0) json = json_","
		s json= json_"{"
		s json= json_"""ID"":"""_rowid_""""
		s json= json_",""Code"":"""_$ZSTRIP(code,"*C")_""""
		s json= json_",""Desc"":"""_$ZSTRIP(desc,"*C")_""""
		s json= json_"}"
		s count = count + 1	
	}
	s json = json_"]"
	s json = "{""total"":"_count_",""rows"":"_json_"}"
	q json
}

/// 血型
/// Creator:Candy
/// CreateDate:2016-1-29
/// Desc: w ##Class(EMRservice.BL.Event.BLOperation).GetPACBloodType()
ClassMethod GetPACBloodType()
{
	s json = "["
	s count = 0
	s rowid = ""
	for
	{
	    s rowid = $o(^PAC("BLDT",rowid),-1)
	    q:((rowid = "")||(rowid=0))
	    
		s code = $p(^PAC("BLDT",rowid),"^",1)
		s desc = $p(^PAC("BLDT",rowid),"^",2)
		s:(count '= 0) json = json_","
		s json= json_"{"
		s json= json_"""ID"":"""_rowid_""""
		s json= json_",""Code"":"""_$ZSTRIP(code,"*C")_""""
		s json= json_",""Desc"":"""_$ZSTRIP(desc,"*C")_""""
		s json= json_"}"
		s count = count + 1	 
	}
	s json = json_"]"
	q json
}

/// 科室列表
/// Creator:Candy
/// CreateDate:2016-1-30
/// Desc: w ##Class(EMRservice.BL.Event.BLOperation).GetDicList()
ClassMethod GetDicList(ADesc As %String) As %String
{
	s json = ##Class(%GlobalBinaryStream).%New()
	s tmpJson = ##Class(%GlobalBinaryStream).%New()
	d tmpJson.Write("[")
	s count = 0
	s desc = ""
	for
	{
		s desc = $o(^CTLOC(0,"Desc",desc))
		q:(desc = "")
		continue:((ADesc '= "")&&(desc '[ $zcvt(ADesc,"U")))
		s rowId = ""
		for
		{
			s rowId = $o(^CTLOC(0,"Desc",desc,rowId))
			q:(rowId = "")
		    d:(count '= 0) tmpJson.Write(",")
			d tmpJson.Write("{")
			d tmpJson.Write("""ID"":"""_rowId_""",")
			d tmpJson.Write("""Code"":"""_$p(^CTLOC(rowId),"^",1)_""",")
			d tmpJson.Write("""Desc"":"""_$ZSTRIP($p(^CTLOC(rowId),"^",2),"*C")_"""")		
			d tmpJson.Write("}")
			s count = count + 1		
		}
	}
	d tmpJson.Write("]")
	d json.Write("{""total"":"_count_",""rows"":")
	d json.CopyFrom(tmpJson)
	d json.Write("}")
	q json
}

/// Desc:手术部位
/// Creator:Candy
/// CreateDate:2016-2-1
/// w ##Class(EMRservice.BL.Event.BLOperation).GetOperationBody()
ClassMethod GetOperationBody(ADesc As %String = "") As %String
{
	s json = "["
	s count = 0
	s rowid = "0"
	for
	{
	    s rowid = $o(^OEC("BODS",rowid))
	    q:(rowid = "")
	    
		s code = $p(^OEC("BODS",rowid),"^",1)
		s desc = $p(^OEC("BODS",rowid),"^",2)
		continue:((ADesc '= "")&&(desc '[ADesc))
		s:(count '= 0) json = json_","
		s json= json_"{"
		s json= json_"""ID"":"""_rowid_""""
		s json= json_",""Code"":"""_$ZSTRIP(code,"*C")_""""
		s json= json_",""Desc"":"""_$ZSTRIP(desc,"*C")_""""
		s json= json_"}"
		s count = count + 1	 
	}
	s json = json_"]"
	s json = "{""total"":"_count_",""rows"":"_json_"}"
	q json
}

/// Desc:手术体位
/// Creator:Candy
/// CreateDate:2016-2-1
/// w ##Class(EMRservice.BL.Event.BLOperation).GetOperPosition()
ClassMethod GetOperPosition(ADesc As %String = "") As %String
{
	s json = "["
	s count = 0
	s rowid = "0"
	for
	{
	    s rowid = $o(^ORC("OPPOS",rowid))
	    q:(rowid = "")
	    
		s code = $p(^ORC("OPPOS",rowid),"^",1)
		s desc = $p(^ORC("OPPOS",rowid),"^",2)
		continue:((ADesc '= "")&&(desc '[ADesc))
		s:(count '= 0) json = json_","
		s json= json_"{"
		s json= json_"""ID"":"""_rowid_""""
		s json= json_",""Code"":"""_$ZSTRIP(code,"*C")_""""
		s json= json_",""Desc"":"""_$ZSTRIP(desc,"*C")_""""
		s json= json_"}"
		s count = count + 1	 
	}
	s json = json_"]"
	s json = "{""total"":"_count_",""rows"":"_json_"}"
	q json
}

/// Desc:用户字典
/// Creator:Candy
/// CreateDate:2016-2-1
/// w ##Class(EMRservice.BL.Event.BLOperation).GetCTCareProv()
ClassMethod GetCTCareProv(ADesc As %String) As %GlobalBinaryStream
{
	s count = 0
	s json = ##Class(%GlobalBinaryStream).%New()
	s tmpJson = ##Class(%GlobalBinaryStream).%New()
	d tmpJson.Write("[")
	s tmpdesc = ""
	for
	{
		s tmpdesc = $o(^CTPCP(0,"Decs",tmpdesc))
		q:(tmpdesc = "")
		continue:((ADesc '= "")&&(tmpdesc '[ $zcvt(ADesc,"U")))
		s rowid = ""
		for
		{
			s rowid = $o(^CTPCP(0,"Decs",tmpdesc,rowid))
			q:(rowid = "")
			s code = $p($g(^CTPCP(rowid,1)),"^",1)
			s desc = $p($g(^CTPCP(rowid,1)),"^",2)
			d:(count '= 0) tmpJson.Write(",")
			d tmpJson.Write("{")
			d tmpJson.Write("""ID"":"""_rowid_"""")
			d tmpJson.Write(",""Code"":"""_$ZSTRIP(code,"*C")_"""")
			d tmpJson.Write(",""Desc"":"""_$ZSTRIP(desc,"*C")_"""")			
			d tmpJson.Write("}")
			s count = count + 1	
		}
	}
	d tmpJson.Write("]")
	d json.Write("{""total"":"_count_",""rows"":")
	d json.CopyFrom(tmpJson)
	d json.Write("}")	
	q json
}

/// Desc:手术间
/// Creator:Candy
/// CreateDate:2016-2-1
/// w ##Class(EMRservice.BL.Event.BLOperation).GetOproomdr()
ClassMethod GetOproomdr(ADesc As %String = "") As %String
{
	s count = 0
	s json = "["
	s rowid = "0"
	for
	{
		s rowid = $o(^DHCANC("OPRoom",rowid))
		q:(rowid = "")
		s code = $p($g(^DHCANC("OPRoom",rowid)),"^",1)
		s desc = $p($g(^DHCANC("OPRoom",rowid)),"^",2)
		continue:((ADesc '= "")&&(desc '[ADesc))
		s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""ID"":"""_rowid_""""
		s json = json_",""Code"":"""_$ZSTRIP(code,"*C")_""""
		s json = json_",""Desc"":"""_$ZSTRIP(desc,"*C")_""""			
		s json = json_"}"
		s count = count + 1	
	}
	s json = json_"]"	
	s json = "{""total"":"_count_",""rows"":"_json_"}"
	q json
}

/// Desc:手术室
/// Creator:candy
/// CreateDate:2016-2-2
/// w ##Class(EMRservice.BL.Event.BLOperation).GetOperationRoom("OP^OUTOP^EMOP","妇")
ClassMethod GetOperationRoom(ALocListCodeStr As %String, ADesc As %String) As %GlobalBinaryStream
{
	s count = 0
	s json = ##Class(%GlobalBinaryStream).%New()
	s tmpJson = ##Class(%GlobalBinaryStream).%New()
	d tmpJson.Write("[")
	for i=1:1:$l(ALocListCodeStr,"^")
	{
		s listCode = $p(ALocListCodeStr,"^",i)
		s listId = $o(^CT("LL",0,"Code",listCode,""))
		s locId = ""
		for
		{
			s locId = $o(^CT("LL",listId,"LOC",0,"Loc",locId))
			q:(locId = "")
			continue:($d(^CTLOC(locId))<=0)
			s code = $p(^CTLOC(locId),"^",1)
			s desc = $p(^CTLOC(locId),"^",2)
			continue:((ADesc '= "")&&(desc '[ $zcvt(ADesc,"U")))
			d:(count '= 0) tmpJson.Write(",")
			d tmpJson.Write("{")
			d tmpJson.Write("""ID"":"""_locId_"""")
			d tmpJson.Write(",""Code"":"""_$ZSTRIP(code,"*C")_"""")
			d tmpJson.Write(",""Desc"":"""_$ZSTRIP(desc,"*C")_"""")			
			d tmpJson.Write("}")
			s count = count + 1				
		}
	}
	d tmpJson.Write("]")
	d json.Write("{""total"":"_count_",""rows"":")
	d json.CopyFrom(tmpJson)
	d json.Write("}")
	q json
}

/// Desc: 麻醉方法
/// Creator: candy
/// CreateDate: 2016-2-2
/// Debug: w ##Class(EMRservice.BL.Event.BLOperation).GetAnaMethod()
ClassMethod GetAnaMethod(ADesc As %String = "") As %String
{
	s count = 0
	s json = "["
	s tempDesc = ""
	for
	{
		s tempDesc = $o(^ORC("ANMET",0,"Desc",tempDesc))
		q:(tempDesc = "")
		s rowid = "0"
		for
		{
			s rowid = $o(^ORC("ANMET",0,"Desc",tempDesc,rowid))
			q:(rowid = "")
			s code = $p($g(^ORC("ANMET",rowid)),"^",1)
			s desc = $p($g(^ORC("ANMET",rowid)),"^",2)
			continue:((ADesc '= "")&&(desc '[ $zcvt(ADesc,"U")))
			s:(count '= 0) json = json_","
			s json = json_"{"
			s json = json_"""ID"":"""_rowid_""""
			s json = json_",""Code"":"""_$ZSTRIP(code,"*C")_""""
			s json = json_",""Desc"":"""_$ZSTRIP(desc,"*C")_""""			
			s json = json_"}"
			s count = count + 1	
		}		
	}

	s json = json_"]"
	s json = "{""total"":"_count_",""rows"":"_json_"}"	
	q json
}

/// Desc:        取接口存数据
/// Creator:     Candy
/// CreateDate:  2016-6-15
/// Input:       AEpisodeID 就诊号
///              AData 手术数据
ClassMethod SetOperationData(AEpisodeID As %String, AData As %GlobalCharacterStream) As %String
{
	s $ZT="ERRORSetOperationData"
	s result = "0"
	q:((AData.Size <=0)||(AEpisodeID = "")) result
	s reader = ##class(%XML.Reader).%New()
	d reader.OpenStream(AData)
	d reader.Correlate("PatInfo","web.DHCANInterface")
	
	While (reader.Next(.obj,.sc)) 
	{
		s rowId = $o(^DHCEMRI.Events.OperationI("IdxOpaID"," "_obj.OpaId,""))
		if (rowId > 0)
		{
			s objOperateion = ##Class(EMRinstance.Events.Operation).%OpenId(rowId)
		}
		else
		{
			s objOperateion = ##Class(EMRinstance.Events.Operation).%New()
			s objOperateion.EpisodeID = AEpisodeID
			s objOperateion.PatientID = $P($g(^PAADM(AEpisodeID)),"^",1)
			s objOperateion.CreateDate = $p($h,",",1)
			s objOperateion.CreateTime = $p($h,",",2)
			s objOperateion.IsActive = "Y"
			s objOperateion.OpaID = obj.OpaId
		}
		s objOperateion.AnaDoctor = obj.AnaDoctor
		s objOperateion.AnaDoctorID = obj.AnaDocCtcpId
		s objOperateion.AnaEndDate = obj.ANAEndDate
		s objOperateion.AnaEndTime = obj.ANAEndTime
		s objOperateion.AnaMethod = obj.AnaMethod
		s objOperateion.AnaMethodID= obj.AnaMethod
		s HospitalName=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
		if (obj.AnaMethodStandardCode'="")&&(HospitalName = "BeiJing_AnZhengYY") 
		{
			s objOperateion.AnaMethodID = $p($p(obj.AnaMethodStandardCode,"#",2),"^",1)   //18..3.27 增加,有些医院的接口可能没有这个字段 “CV06.00.103#47^非插管全麻^^”
		}  
		
		s objOperateion.AnaStartDate = obj.ANAStartDate
		s objOperateion.AnaStartTime = obj.ANAStartTime
		s objOperateion.BodsDesc = obj.BodsDesc
		s objOperateion.CirculNurFirst = obj.CirculNurFirstCtcp
		s objOperateion.CirculNurFirstID = obj.CirculNurFirstCtcpId
		s objOperateion.CirculNurSecond = obj.CirculNurSecondCtcp
		s objOperateion.CirculNurSecondID = obj.CirculNurSecondCtcpId
		s objOperateion.CirculNurThird = obj.CirculNurThirdCtcp
		s objOperateion.CirculNurThirdID = obj.CirculNurThirdCtcpId
		s objOperateion.InRoomTime = obj.InRoomTime
		s objOperateion.InRoomDate = obj.InRoomDate
		s objOperateion.LeaveRoomTime = obj.LeaveRoomTime
		s objOperateion.LeaveRoomDate = obj.LeaveRoomDate
		s objOperateion.OperAppLocID = obj.OPAPatDeptDr  //申请科室ID
		s objOperateion.OperAppLoc=obj.PatLoc
		s objOperateion.OperArrangeDate = obj.OPAArrangeDate
		s objOperateion.OperArrangeTime = obj.OPAArrangeTime
		s objOperateion.OperAssistFirst = obj.AssistantFirstCtcp
		s objOperateion.OperAssistFirstID = obj.AssistantFirstCtcpId
		s objOperateion.OperAssistSecond = obj.AssistantSecondCtcp
		s objOperateion.OperAssistSecondID = obj.AssistantSecondCtcpId
		s objOperateion.OperBloodType = obj.bloodType
		s objOperateion.OperCirculation = obj.OPAExCirculation
		s objOperateion.OperDate = obj.OpDate
		s objOperateion.OperDoc = obj.ANAOPSurgeon
		s objOperateion.OperDocID = obj.ANAOPSurgeonDR
		s objOperateion.OperEndDate = $p(obj.OPAEndDateTime," ",1)
		s objOperateion.OperEndTime = $p(obj.OPAEndDateTime," ",2)
		s objOperateion.OperHBsAg = obj.OPAPATestHBsAg
		s objOperateion.OperTPAb = obj.OPAPATestTPAb
		s objOperateion.OperHCVAb = obj.OPAPATestHCVAb
		s objOperateion.OperHivAb = obj.OPAPATestHivAb
		s objOperateion.OperLocID = obj.OPAOperLocDr
		s objOperateion.OperOrdNo = obj.OPASeq
		s objOperateion.OperOther = obj.OPAPATestOther
		s objOperateion.OperPosition = obj.OperPosition
		s objOperateion.OperPreopDiag = obj.ANAOPPreopDiag
		s objOperateion.OperPreopDiagID=obj.ANAOPPreopDiagDR //xuefl add by 18.1.19
		s objOperateion.OperRhBloodType = obj.bloodType
		s objOperateion.OperRoom = obj.BedRoom
		s objOperateion.OperStartDate = $p(obj.OPAStartDateTime," ",1)
		s objOperateion.OperStartTime = $p(obj.OPAStartDateTime," ",2)
		s objOperateion.OperUseSelfBlood = obj.OPAUseSelfBlood
		s objOperateion.ScrubNurFirst = obj.CirculNurFirstCtcp
		s objOperateion.ScrubNurFirstID = obj.CirculNurFirstCtcpId
		s objOperateion.ScrubNurSecond = obj.CirculNurSecondCtcp
		s objOperateion.ScrubNurSecondID = obj.CirculNurSecondCtcpId
		s objOperateion.ScrubNurThird = obj.CirculNurThirdCtcp
		s objOperateion.ScrubNurThirdID = obj.CirculNurThirdCtcpId
		s objOperateion.OperPAStatus = obj.OPAStatus
		s:((obj.OPAStatus = "拒绝")||(obj.OPAStatus = "撤销")) objOperateion.IsActive = "N" 
		s objOperateion.OperAssistThirdID=obj.AssistantThirdCtcpId
		s objOperateion.OperAssistThird=obj.AssistantThirdCtcp
		s objOperateion.OperPostDiagId=obj.PostDiagId
		s objOperateion.OperPostDiag=obj.PostDiag
		
		d objOperateion.OperSub.Clear()
		for I=1:1:$l(obj.OperId,"|")
		{
			s objOperationSub = ##Class(EMRinstance.Events.OperationSub).%New()
			s objOperationSub.OperID = $p(obj.OperId,"|",I)
			s objOperationSub.Oper = $p(obj.OpName,",",I)
			s objOperationSub.OperBladeTypeID = $p(obj.ANAOPBladeTypeId,"|",I)
			s objOperationSub.OperBladeType = $p(obj.ANAOPBladeType,",",I)
			s objOperationSub.OperLevelID = $p(obj.opLevelId,"|",I)
			s objOperationSub.OperLevel =  $p(obj.opLevelDesc,",",I)
			s objOperationSub.PlanOperID = $p(obj.PlanOperId,"|",I)
			s objOperationSub.PlanOperName = $p(obj.PlanOperName,",",I)
			
			s objOperationSub.OperRef = objOperateion
		}
		s sc = objOperateion.%Save()
		s:($$$ISOK(sc)) result = "1"
	}
	q result
ERRORSetOperationData
	q result_"^"_$zerror
}

/// Description:   取标准手术记录数据XML接口
/// Creator:       Donglulu
/// CreateDate:    2016-10-11        
/// Input：        AEpisodeID 就诊ID 
///                AOparID 手术ID
/// Output         result 1成功 0失败
/// Debug:         w ##Class(EMRservice.BL.Event.BLOperation).SetStandardOperationData("","")
ClassMethod SetStandardOperationData(AEpisodeID As %String, AOparID As %String) As %String
{
	s $ZT="ERRORStandardOperationData"
	s methodResult = 0
	q:((AEpisodeID = "")||(AOparID = "")) methodResult
	
	//s reportStream = ##Class(%FileBinaryStream).%New()
	//s reportStream.Filename="d:\stream.txt" 
	
	s reportStream = ##class(web.DHCENS.BLL.Operation.Method.GetOperationScheduleInfo).GetOpInfoByOpId(AOparID)
	q:(reportStream.Size <=0) methodResult  
	
	s screport = ##class(%XML.XPATH.Document).CreateFromStream(reportStream,.reportList)
	q:($$$ERROR(screport)) methodResult
	
	s rowId = $o(^DHCEMRI.Events.OperationI("IdxOpaID"," "_AOparID,""))
	if (rowId > 0)
	{
		s objOperateion = ##Class(EMRinstance.Events.Operation).%OpenId(rowId)	
	}
	else
	{
		s objOperateion = ##Class(EMRinstance.Events.Operation).%New()
		s objOperateion.EpisodeID = AEpisodeID
		s objOperateion.PatientID = $P($g(^PAADM(AEpisodeID)),"^",1)
		s objOperateion.CreateDate = $p($h,",",1)
		s objOperateion.CreateTime = $p($h,",",2)
		s objOperateion.IsActive = "Y"
		s objOperateion.OpaID = AOparID
	}
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E01","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OpaID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E02","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperDate = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E03","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperStartDate = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E04","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperStartTime = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E05","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperEndDate = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E06","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperEndTime = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E07","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperDocID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E08","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperDoc = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E09","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperAssistFirstID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E10","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperAssistFirst = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E11","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperAssistSecondID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E12","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperAssistSecond = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E13","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.BodsDescID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E14","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.BodsDesc = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E15","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperPositionID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E16","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperPosition = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E17","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperLocID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E18","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperLoc = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E19","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperAppLocID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E20","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperAppLoc = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E21","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperPreopDiagID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E22","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperPreopDiag = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E23","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperDiagMemo = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E24","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperCirculation = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E25","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperUseSelfBlood = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E26","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperBloodType = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E27","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperRhBloodType = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E28","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperHBsAg = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E29","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperHCVAb = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E30","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperHivAb = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E31","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperTPAb = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E32","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperOther = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E33","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.AnaDoctorID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E34","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.AnaDoctor = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E35","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.AnaMethodID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E36","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.AnaMethod = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E37","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.AnaStartDate = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E38","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.AnaStartTime = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E39","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.AnaEndDate = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E40","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.AnaEndTime = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E41","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperRoomID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E42","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperRoom = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E43","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperOrdNo = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E44","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperArrangeDate = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E45","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperArrangeTime = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E46","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.InRoomDate = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E47","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.InRoomTime = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E48","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.LeaveRoomDate = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E49","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.LeaveRoomTime = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E50","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.ScrubNurFirstID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E51","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.ScrubNurFirst = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E52","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.ScrubNurSecondID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E53","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.ScrubNurSecond = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E54","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.ScrubNurThirdID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E55","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.ScrubNurThird = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E56","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.CirculNurFirstID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E57","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.CirculNurFirst = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E58","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.CirculNurSecondID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E59","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.CirculNurSecond = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E60","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.CirculNurThirdID = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E61","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.CirculNurThird = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E62","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperPAStatus = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E63","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.AuxAnesthesiaDoc = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E64","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.BleedBlood = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E65","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.SuspenRed = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E66","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.Plasma = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E67","text()",.result)			
	s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.AnesthesiaGrad = result.GetAt(1).Value
	s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/E68","text()",.result)			
	s HospitalName=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
 	if HospitalName '= "BeiJingFXYY" 
 	{
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperateion.OperPreopDiagICD = result.GetAt(1).Value
 	}

	
	s scscreport = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']","count(section)",.reportNode)
	q:($$$ERROR(scscreport)||(reportNode.GetAt(1)="")) methodResult
	s rcount = reportNode.GetAt(1).Value
	
	d objOperateion.OperSub.Clear()
		
	for j=1:1:rcount
	{
		s objOperationSub = ##Class(EMRinstance.Events.OperationSub).%New()
		s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/section["_j_"]/E01","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperationSub.OperID = result.GetAt(1).Value
		s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/section["_j_"]/E02","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperationSub.Oper = result.GetAt(1).Value
		s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/section["_j_"]/E03","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperationSub.OperMemo = result.GetAt(1).Value
		s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/section["_j_"]/E04","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperationSub.OperLevelID = result.GetAt(1).Value
		s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/section["_j_"]/E05","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperationSub.OperLevel = result.GetAt(1).Value
		s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/section["_j_"]/E06","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperationSub.OperBladeTypeID = result.GetAt(1).Value
		s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/section["_j_"]/E07","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperationSub.OperBladeType = result.GetAt(1).Value
		s sc = reportList.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0049']/section["_j_"]/E08","text()",.result)
		s HospitalName=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
		if HospitalName '= "BeiJingFXYY" 
		{			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) objOperationSub.OperCode = result.GetAt(1).Value
		}
		
		s objOperationSub.OperRef = objOperateion	
	}
	s sc = objOperateion.%Save()
	s:($$$ISOK(sc)) methodResult = 1
ERRORStandardOperationData
	q methodResult
}

/// Desc:取手术信息
/// Creator:Candy
/// CreateDate:2016-7-7
/// Input:手术ID
/// OutPut: 返回字段意义表里查
/// Debug: do ##class(%ResultSet).RunQuery("EMRservice.BL.Event.BLOperation","GetOperations",1)
Query GetOperations(AID As %String) As %Query(ROWSPEC = "OpaID,OperDate,OperStartDate,OperStartTime,OperEndDate,OperEndTime,OperDoc,OperAssistFirstID,OperAssistFirst,OperAssistSecondID,OperAssistSecond,BodsDescID,BodsDesc,OperPositionID,OperPosition,OperLocID,OperLoc,OperAppLocID,OperAppLoc,OperPreopDiagID,OperPreopDiag,OperDiagMemo,OperCirculation,OperUseSelfBlood,OperBloodType,OperRhBloodType,OperHBsAg,OperHCVAb,OperHivAb,OperTPAb,OperOther,AnaDoctorID,AnaDoctor,AnaMethodID,AnaMethod,AnaStartDate,AnaStartTime,AnaEndDate,AnaEndTime,OperRoomID,OperRoom,OperOrdNo,OperArrangeDate,OperArrangeTime,InRoomDate,InRoomTime,LeaveRoomDate,LeaveRoomTime,ScrubNurFirstID,ScrubNurFirst,ScrubNurSecondID,ScrubNurSecond,ScrubNurThirdID,ScrubNurThird,CirculNurFirstID,CirculNurFirst,CirculNurSecondID,CirculNurSecond,CirculNurThirdID,CirculNurThird,OperID,Oper,OperMemo,OperLevelID,OperLevel,OperBladeTypeID,OperBladeType,OperPreopDiagDict,OperDocDict,OperAssistFirstDict,OperAssistSecondDict,AnaDoctorDict,OperDocProfTi,OperAssistFirstProfTi,OperAssistSecondProfTi,OpernameDict1,OperMemonname1,OperLevelnameMono1,OperBladeTypeMono1,AuxAnesthesiaDoc,BleedBlood,SuspenRed,Plasma,AnesthesiaGrad,OperPreopDiagICD,PlanOpernameDict1,OperPostDiagId,OperPostDiag,OperPostDiagDict1,OpernameCode2,OpernameDict2,Opername2,PlanOpernameCode2,PlanOpernameDict2,PlanOpername2,OpernameCode3,OpernameDict3,Opername3,PlanOpernameCode3,PlanOpernameDict3,PlanOpername3,OpernameCode4,OpernameDict4,Opername4,PlanOpernameCode4,PlanOpernameDict4,PlanOpername4,OpernameCode5,OpernameDict5,Opername5,PlanOpernameCode5,PlanOpernameDict5,PlanOpername5,OperPostDiag1,OperPostDiag2,OperPostDiagDict2,OperPostDiag3,OperPostDiagDict3,OperPostDiag4,OperPostDiagDict4,OperPostDiagAll,OperPreopDiagALL,PlanOperName,OperStartDatetime,ANAOPSurgeon2Desc,ANAOPSurgeon2Dict")
{
}

ClassMethod GetOperationsExecute(ByRef qHandle As %Binary, AID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:(AID = "") $$$OK
 	s obj = ##Class(EMRinstance.Events.Operation).%OpenId(AID)
 	q:(obj = "") $$$OK
 	s (OperID,Oper,OperMemo,OperLevelID,OperLevel,OperBladeTypeID,OperBladeType,PlanOperID,PlanOperName) = ""
 	s subId = ""
 	s count = 0
	s (OpernameDict1,OperMemonname1,OperLevelnameMono1,OperBladeTypeMono1,OpernameCode,PlanOpernameCode,PlanOpernameDict1) = ""
 	for
 	{
    	s subId = $o(^DHCEMRI.Events.OperationSubI("IdxOperRef",AID,subId))
    	q:(subId = "")
    	s rowId = AID_"||"_subId 
    	s objsub = ##Class(EMRinstance.Events.OperationSub).%OpenId(rowId)
    	q:(objsub = "")
    	s:(count '=0) OperID= OperID_"^",Oper=Oper_"^",OperMemo=OperMemo_"^",OperLevelID=OperLevelID_"^",OperLevel=OperLevel_"^",OperBladeTypeID=OperBladeTypeID_"^",OperBladeType=OperBladeType_"^"
    	s OperID = OperID_objsub.OperID
    	s Oper = Oper_objsub.Oper
    	s OperMemo = OperMemo_objsub.OperMemo
    	s OperLevelID = OperLevelID_objsub.OperLevelID
        s OperLevel = OperLevel_objsub.OperLevel
        s OperBladeTypeID = OperBladeTypeID_objsub.OperBladeTypeID
        s OperBladeType = OperBladeType_objsub.OperBladeType
		s PlanOperID = PlanOperID_objsub.PlanOperID
		s PlanOperName = PlanOperName_objsub.PlanOperName	
		//复兴医院：手术名称字典，手术级别单选，目前和院方约定一个手术申请只处理第一个手术名称。手术备注
        s HospitalName=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
		//去掉医院判定，将其定为通用格式。
		//if (HospitalName = "BeiJingFXYY")||( HospitalName = "BeiJing_AnZhengYY" )
		//{
            if (count =0)
            {
	         	if (OperID '= "")
			 	{
				 	s OpernameCode = $p($g(^ORC("OPER",objsub.OperID)),"^",1)
				 	s OpernameDict1 = objsub.OperID_"^"_OpernameCode_"^"_Oper          //本次手术的第一个实施手术名称字典，
			 	}
			 	if (PlanOperID '= "")&&(objsub.PlanOperID'="")
			 	{
				 	s PlanOpernameCode = $p($g(^ORC("OPER",objsub.PlanOperID)),"^",1)
				 	s PlanOpernameDict1 = objsub.PlanOperID_"^"_OpernameCode_"^"_objsub.PlanOperName          //本次手术的第一个拟实手术名称字典，
			 	}
	         	s OperMemonname1= OperMemo
	         	s OperLevelnameMono1=OperLevelID_"^"_OperLevel
	         	s OperBladeTypeMono1=OperBladeTypeID_"^"_OperBladeType
	        
	        }   
      	if (count =1)
            {//第二组手术，OpernameCode2,OpernameDict2,Opername2,PlanOpernameCode2,PlanOpernameDict2,PlanOpername2
	         	if (OperID '= "")
			 	{
				 	s OpernameCode2 = $p($g(^ORC("OPER",objsub.OperID)),"^",2)
				 	s OpernameDict2 = objsub.OperID_"^"_OpernameCode2_"^"_Oper          //本次手术的第二个实施手术名称字典，
				 	s Opername2=Oper
			 	}
			 	if (PlanOperID '= "")&&(objsub.PlanOperID'="")
			 	{
				 	s PlanOpernameCode2 = $p($g(^ORC("OPER",objsub.PlanOperID)),"^",2)
				 	s PlanOpernameDict2 = objsub.PlanOperID_"^"_PlanOpernameCode2_"^"_objsub.PlanOperName     //本次手术的第二个拟施手术名称字典，
			 	    s PlanOpername2=objsub.PlanOperName  
			 	}
	        
	        } 
    	if (count =2)
            {//第三组手术,OpernameCode3,OpernameDict3,Opername3,PlanOpernameCode3,PlanOpernameDict3,PlanOpername3,
	         	if (OperID '= "")
			 	{
				 	s OpernameCode3 = $p($g(^ORC("OPER",objsub.OperID)),"^",3)
				 	s OpernameDict3 = objsub.OperID_"^"_OpernameCode3_"^"_Oper          //本次手术的第三个实施手术名称字典，
				 	s Opername3=Oper
			 	}
			 	if (PlanOperID '= "")&&(objsub.PlanOperID'="")
			 	{
				 	s PlanOpernameCode3 = $p($g(^ORC("OPER",objsub.PlanOperID)),"^",3)
				 	s PlanOpernameDict3 = objsub.PlanOperID_"^"_PlanOpernameCode3_"^"_objsub.PlanOperName     //本次手术的第三个拟施手术名称字典，
			 	    s PlanOpername3=objsub.PlanOperName  
			 	}
	        
	        } 
    	if (count =3)
            {//第四组手术,OpernameCode4,OpernameDict4,Opername4,PlanOpernameCode4,PlanOpernameDict4,PlanOpername4,
	         	if (OperID '= "")
			 	{
				 	s OpernameCode4 = $p($g(^ORC("OPER",objsub.OperID)),"^",4)
				 	s OpernameDict4 = objsub.OperID_"^"_OpernameCode4_"^"_Oper          //本次手术的第四个实施手术名称字典，
				 	s Opername4=Oper
			 	}
			 	if (PlanOperID '= "")&&(objsub.PlanOperID'="")
			 	{
				 	s PlanOpernameCode4 = $p($g(^ORC("OPER",objsub.PlanOperID)),"^",4)
				 	s PlanOpernameDict4 = objsub.PlanOperID_"^"_PlanOpernameCode4_"^"_objsub.PlanOperName     //本次手术的第四个拟施手术名称字典，
			 	    s PlanOpername4=objsub.PlanOperName  
			 	}
	        
	        } 	          
	        if (count =4)
            {//第五组手术,OpernameCode5,OpernameDict5,Opername5,PlanOpernameCode5,PlanOpernameDict5,PlanOpername5
	         	if (OperID '= "")
			 	{
				 	s OpernameCode5 = $p($g(^ORC("OPER",objsub.OperID)),"^",5)
				 	s OpernameDict5 = objsub.OperID_"^"_OpernameCode5_"^"_Oper          //本次手术的第五个实施手术名称字典，
				 	s Opername5=Oper
			 	}
			 	if (PlanOperID '= "")&&(objsub.PlanOperID'="")
			 	{
				 	s PlanOpernameCode5 = $p($g(^ORC("OPER",objsub.PlanOperID)),"^",5)
				 	s PlanOpernameDict5 = objsub.PlanOperID_"^"_PlanOpernameCode5_"^"_objsub.PlanOperName     //本次手术的第五个拟施手术名称字典，
			 	    s PlanOpername5=objsub.PlanOperName  
			 	}
	        
	        } 	 	          
	    }  
		s count = count + 1
 	//}
 	
 	s OpaID = obj.OpaID 
 	s OperDate = obj.OperDate 
 	s OperStartDate = obj.OperStartDate
 	s OperStartTime = obj.OperStartTime
 	s OperEndDate = obj.OperEndDate
	s OperEndTime = obj.OperEndTime
 	s OperDocID =obj.OperDocID
 	s OperDoc = obj.OperDoc
 	s OperAssistFirstID = obj.OperAssistFirstID
 	s OperAssistFirst = obj.OperAssistFirst
 	s OperAssistSecondID = obj.OperAssistSecondID
 	s OperAssistSecond = obj.OperAssistSecond
 	s BodsDescID = obj.BodsDescID
 	s BodsDesc = obj.BodsDesc
 	s OperPositionID = obj.OperPositionID
 	s OperPosition = obj.OperPosition
 	s OperLocID = obj.OperLocID
 	s OperLoc = obj.OperLoc
 	s OperAppLocID = obj.OperAppLocID
 	s OperAppLoc = obj.OperAppLoc
 	s OperPreopDiagID = obj.OperPreopDiagID
 	s OperPreopDiag = obj.OperPreopDiag
 	s OperDiagMemo = obj.OperDiagMemo
 	s OperCirculation = obj.OperCirculation
 	s OperUseSelfBlood = obj.OperUseSelfBlood
 	s OperBloodType = obj.OperBloodType
 	s OperRhBloodType = obj.OperRhBloodType
 	s OperHBsAg = obj.OperHBsAg
 	s OperHCVAb = obj.OperHCVAb
 	s OperHivAb = obj.OperHivAb
 	s OperTPAb = obj.OperTPAb
 	s OperOther = obj.OperOther
 	s AnaDoctorID = obj.AnaDoctorID
 	s AnaDoctor = obj.AnaDoctor
 	s AnaMethodID = obj.AnaMethodID
 	s AnaMethodDesc = obj.AnaMethod
	s AnaMethod=""
 	if (AnaMethodID'=+AnaMethodID)
 	{
	 	//SQLUser.ORC_AnaestMethod
	 	s anamdid = $O(^ORC("ANMET",0,"Desc",$zcvt(AnaMethodDesc,"U"),""))
	 	s andmdcode = $p($g(^ORC("ANMET",anamdid)),"^",1)
 		s AnaMethod=anamdid_"^"_andmdcode_"^"_AnaMethodDesc
 	}
 	else
 	{
	 	s andmdcode = $p($g(^ORC("ANMET",AnaMethodID)),"^",1)
	 	s AnaMethod=AnaMethodID_"^"_andmdcode_"^"_AnaMethodDesc
	}
 	s AnaStartDate = obj.AnaStartDate
 	s AnaStartTime = obj.AnaStartTime
 	s AnaEndDate = obj.AnaEndDate
 	s AnaEndTime = obj.AnaEndTime
 	s OperRoomID = obj.OperRoomID
 	s OperRoom = obj.OperRoom
 	s OperOrdNo = obj.OperOrdNo
 	s OperArrangeDate = $ZD(obj.OperArrangeDate,3)
 	s OperArrangeTime = $zt(obj.OperArrangeTime)
 	s InRoomDate = obj.InRoomDate
 	s InRoomTime = obj.InRoomTime
 	s LeaveRoomDate = obj.LeaveRoomDate
 	s LeaveRoomTime = obj.LeaveRoomTime
 	s ScrubNurFirstID = obj.ScrubNurFirstID
 	s ScrubNurFirst = obj.ScrubNurFirst
 	s ScrubNurSecondID = obj.ScrubNurSecondID
 	s ScrubNurSecond = obj.ScrubNurSecond
 	s ScrubNurThirdID = obj.ScrubNurThirdID
 	s ScrubNurThird = obj.ScrubNurThird
 	s CirculNurFirstID = obj.CirculNurFirstID
 	s CirculNurFirst = obj.CirculNurFirst
 	s CirculNurSecondID = obj.CirculNurSecondID
 	s CirculNurSecond = obj.CirculNurSecond
 	s CirculNurThirdID = obj.CirculNurThirdID
 	s CirculNurThird = obj.CirculNurThird
	
	s AuxAnesthesiaDoc = obj.AuxAnesthesiaDoc
 	s BleedBlood = obj.BleedBlood
 	s SuspenRed = obj.SuspenRed
 	s Plasma = obj.Plasma
 	s AnesthesiaGrad = obj.AnesthesiaGrad
 	s OperPreopDiagICD = obj.OperPreopDiagICD
 	
 	s OperPostDiagId = obj.OperPostDiagId
 	s OperPostDiag = obj.OperPostDiag
 	//手麻系统改在，术前诊断优化返回值格式，修改为：id###desc###memo&&&id###desc###memo&&&id###desc###memo&&&
 	//s OperPreopDiagALL=OperPreopDiag
 	s OperPreopDiagALL=""
 	for i=1:1:$l(OperPreopDiag,"&&&")
	{
		s diag=$p(OperPreopDiag,"&&&",i)
		s desc = $p(diag,"###",2)
		s diagMemo = $p(diag,"###",3)
		s:(OperPreopDiagALL'="") OperPreopDiagALL = OperPreopDiagALL_"，"_desc_$s(diagMemo'="":"("_diagMemo_")",1:"")
		s:(OperPreopDiagALL="") OperPreopDiagALL = desc_$s(diagMemo'="":"("_diagMemo_")",1:"")
	}
	
 	s OperPostDiagAll=OperPostDiag
 	s (OperPreopDiagDict,OperDocDict,OperAssistFirstDict,OperAssistSecondDict,AnaDoctorDict) = ""
 	
 	//器械护士一  ScrubNurFirst 器械护士二 ScrubNurSecond 器械护士三 ScrubNurThird
 	//巡回护士一  CirculNurFirst  巡回护士二 CirculNurSecond  巡回护士三 CirculNurThird
 	//ScrubNurFirst,ScrubNurSecond,ScrubNurThird,CirculNurFirst,CirculNurSecond,CirculNurThird
 	///术前诊断OperPreopDiagID中有多个手术ID，“|”分隔；OperPreopDiag中有多个诊断“,”分隔
 	/*
 	if (OperPreopDiagID '= "")
 	{
	 	
	 	s OperPreopDiagCode = $p($g(^MRC("ID",OperPreopDiagID)),"^",1)
	 	s OperPreopDiagDict = OperPreopDiagID_"^"_OperPreopDiagCode_"^"_OperPreopDiag          //术前诊断字典，
		s OperPreopDiagID1 = $p(OperPreopDiagID,"|",1)
	        if (OperPreopDiagID1 '= "")
	        {
	 	    s OperPreopDiag1 = $p(OperPreopDiag,",",1)
	 		s OperPreopDiagCode1 = $p($g(^MRC("ID",OperPreopDiagID1)),"^",1)
	  		s OperPreopDiagDict1 = OperPreopDiagID1_"^"_OperPreopDiagCode1_"^"_OperPreopDiag1          //术前诊断字典1，
	       }
 	}
 	*/
 	if ($l(OperPreopDiag,"&&&")>0)
 	{
	 	s diag1=$p(OperPreopDiag,"&&&",1)
	 	s diagID1 = $p(diag1,"###",1)
		s diagDesc1 = $p(diag1,"###",2)
		s diagDescMemo1 = $p(diag1,"###",3)
		
		if (diagID1'="")
		{
			s OperPreopDiagCode = $p($g(^MRC("ID",diagID1)),"^",1)
			s OperPreopDiagDict = diagID1_"^"_OperPreopDiagCode_"^"_diagDesc1_$s(diagDescMemo1'="":"("_diagDescMemo1_")",1:"")
		}
 	}
 	
 	
 	//术后诊断字典（OperPostDiagId可能包含多个）
 	s (OperPostDiagCode1,OperPostDiagCode2,OperPostDiagCode3,OperPostDiagCode4,OperPostDiag1,OperPostDiagDict1,OperPostDiag2,OperPostDiagDict2,OperPostDiag3,OperPostDiagDict3,OperPostDiag4,OperPostDiagDict4)=""
 	if (OperPostDiagId '= "")
 	{
	 	s OperPostDiagId1 = $p(OperPostDiagId,"|",1)
	 	if (OperPostDiagId1)'="" {
 		s OperPostDiag1 = $p(OperPostDiag,",",1)
	 	s OperPostDiagCode1 = $p($g(^MRC("ID",OperPostDiagId1)),"^",1)
	 	s OperPostDiagDict1 = OperPostDiagId1_"^"_OperPostDiagCode1_"^"_OperPostDiag1          //术后诊断字典，
	 	}
	 	s OperPostDiagId2 = $p(OperPostDiagId,"|",2) //OperPostDiag2,OperPostDiagDict2,OperPostDiag3,OperPostDiagDict3,OperPostDiag4,OperPostDiagDict4
	 	if (OperPostDiagId2)'="" {
 		s OperPostDiag2 = $p(OperPostDiag,",",2)
	 	s OperPostDiagCode2 = $p($g(^MRC("ID",OperPostDiagId2)),"^",2)
	 	s OperPostDiagDict2 = OperPostDiagId2_"^"_OperPostDiagCode2_"^"_OperPostDiag2          //术后诊断字典，
	 	}
	 	s OperPostDiagId3 = $p(OperPostDiagId,"|",3)
	 	if (OperPostDiagId3)'="" {
 		s OperPostDiag3 = $p(OperPostDiag,",",3)
	 	s OperPostDiagCode3 = $p($g(^MRC("ID",OperPostDiagId3)),"^",3)
	 	s OperPostDiagDict3 = OperPostDiagId3_"^"_OperPostDiagCode3_"^"_OperPostDiag3          //术后诊断字典，
	 	}
	 	s OperPostDiagId4 = $p(OperPostDiagId,"|",4)
	 	if (OperPostDiagId4)'="" {
 		s OperPostDiag4 = $p(OperPostDiag,",",4)
	 	s OperPostDiagCode4 = $p($g(^MRC("ID",OperPostDiagId4)),"^",4)
	 	s OperPostDiagDict4 = OperPostDiagId4_"^"_OperPostDiagCode4_"^"_OperPostDiag4          //术后诊断字典，
	 	}
	 	
 	}
 	
 	if (OperDocID '= "")
 	{
	 	s OperDocCode = $p($g(^CTPCP(OperDocID,1)),"^",1)
	 	s OperDocDict = OperDocID_"^"_OperDocCode_"^"_OperDoc                            //术者字典，
 	}
 	if (OperAssistFirstID '= "")
 	{
	 	s OperAssistFirstCode = $p($g(^CTPCP(OperAssistFirstID,1)),"^",1)
	 	s OperAssistFirstDict = OperAssistFirstID_"^"_OperAssistFirstCode_"^"_OperAssistFirst    //一助字典
 	}
 	if (OperAssistSecondID '= "")
 	{
	 	s OperAssistSecondCode = $p($g(^CTPCP(OperAssistSecondID,1)),"^",1)
	 	s OperAssistSecondDict = OperAssistSecondID_"^"_OperAssistSecondCode_"^"_OperAssistSecond //二助字典
 	}
 	if (AnaDoctorID '= "")
 	{
	 	s AnaDoctorCode = $p($g(^CTPCP(AnaDoctorID,1)),"^",1)_"^"_$p($g(^CTPCP(AnaDoctorID,1)),"^",2) 	
	 	s AnaDoctorDict = AnaDoctorID_"^"_AnaDoctorCode                      //麻醉医师字典  
 	}
 	//##class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctorTitle(admid)
 	//复兴医院取医生的职称，为防其它项目报错根据医院名称来判断一下,
 	//术者职称,一助职称,二助职称,麻醉医师职称
 	s (OperDocProfTi,OperAssistFirstProfTi,OperAssistSecondProfTi,AnaDoctorProfTi) = ""
 	s HospitalName=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
 	if (HospitalName = "BeiJingFXYY")||(HospitalName = "BeiJing_AnZhengYY" )
 	{
	 	 s OperStartDate=OperStartDate_" "_OperStartTime
	 	 s OperStartDatetime=OperStartDate
		 s OperEndDate=OperEndDate_" "_obj.OperEndTime
		 s OperDocProfTi   = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctorTitle(OperDocID)
	 	 s OperAssistFirstProfTi= ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctorTitle(OperAssistFirstID)
	 	 s OperAssistSecondProfTi= ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctorTitle(OperAssistSecondID)
	 	 //s AnaDoctorProfTi   = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctorTitle(AnaDoctorID)

 	}
 	
 	s ANAOPSurgeon2Desc = obj.ANAOPSurgeon2
 	s ANAOPSurgeon2Dict = obj.ANAOPSurgeonDR2_"^"_obj.ANAOPSurgeonCode2_"^"_obj.ANAOPSurgeon2
 	
 	s OperPreopDiag = OperPreopDiagALL
 	//未提供：术者积称、一助积称、二助积称；麻醉方式只提供了名称，无ID。OperPreopDiagDict,OperDocDict,OperAssistFirstDict,OperAssistSecondDict,AnaDoctorDict
	s ^CacheTemp(repid,ind) = $lb(OpaID,OperDate,OperStartDate,OperStartTime,OperEndDate,OperEndTime,OperDoc,OperAssistFirstID,OperAssistFirst,OperAssistSecondID,OperAssistSecond,BodsDescID,BodsDesc,OperPositionID,OperPosition,OperLocID,OperLoc,OperAppLocID,OperAppLoc,OperPreopDiagID,OperPreopDiag,OperDiagMemo,OperCirculation,OperUseSelfBlood,OperBloodType,OperRhBloodType,OperHBsAg,OperHCVAb,OperHivAb,OperTPAb,OperOther,AnaDoctorID,AnaDoctor,AnaMethodID,AnaMethod,AnaStartDate,AnaStartTime,AnaEndDate,AnaEndTime,OperRoomID,OperRoom,OperOrdNo,OperArrangeDate,OperArrangeTime,InRoomDate,InRoomTime,LeaveRoomDate,LeaveRoomTime,ScrubNurFirstID,ScrubNurFirst,ScrubNurSecondID,ScrubNurSecond,ScrubNurThirdID,ScrubNurThird,CirculNurFirstID,CirculNurFirst,CirculNurSecondID,CirculNurSecond,CirculNurThirdID,CirculNurThird,OperID,Oper,OperMemo,OperLevelID,OperLevel,OperBladeTypeID,OperBladeType,OperPreopDiagDict,OperDocDict,OperAssistFirstDict,OperAssistSecondDict,AnaDoctorDict,OperDocProfTi,OperAssistFirstProfTi,OperAssistSecondProfTi,OpernameDict1,OperMemonname1,OperLevelnameMono1,OperBladeTypeMono1,AuxAnesthesiaDoc,BleedBlood,SuspenRed,Plasma,AnesthesiaGrad,OperPreopDiagICD,PlanOpernameDict1,OperPostDiagId,OperPostDiag,OperPostDiagDict1,OpernameCode2,OpernameDict2,Opername2,PlanOpernameCode2,PlanOpernameDict2,PlanOpername2,OpernameCode3,OpernameDict3,Opername3,PlanOpernameCode3,PlanOpernameDict3,PlanOpername3,OpernameCode4,OpernameDict4,Opername4,PlanOpernameCode4,PlanOpernameDict4,PlanOpername4,OpernameCode5,OpernameDict5,Opername5,PlanOpernameCode5,PlanOpernameDict5,PlanOpername5,OperPostDiag1,OperPostDiag2,OperPostDiagDict2,OperPostDiag3,OperPostDiagDict3,OperPostDiag4,OperPostDiagDict4,OperPostDiagAll,OperPreopDiagALL,PlanOperName,OperStartDatetime,ANAOPSurgeon2Desc,ANAOPSurgeon2Dict)
	s ind=ind+1 
	Quit $$$OK
}

ClassMethod GetOperationsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperationsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOperationsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperationsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod test(AdocId As %String, AstartDate As %Integer, AendDate As %Integer) As %List
{
	s result = ""
	s rowid = ""
	for
	{
		s rowid = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AdocId,rowid))
		q:(rowid = "")
		s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(rowid_"||1")
		continue:(objInstance = "")
		continue:((objInstance.HappenDate<AstartDate)&&(objInstance.HappenDate>AendDate))
		s objEcrecord = ##Class(EPRinstance.ECRecord).%OpenId(rowid)
		continue:(objEcrecord = "")
		s result = result_$lb(objEcrecord.RealEpisodeID)
	}
	q result
}

/// Desc:        通过就诊号取手术记录实例
/// Creator:     liuyunfei
/// CreateDate:  2021-09-23
/// Input:       AEpisodeID 就诊ID
/// Output:      result 
/// Debug:       w ##Class(EMRservice.BL.Event.BLOperation).GetOperationRecord(5,4,"Operation","DESC")
ClassMethod GetOperationRecord(ACategoryId As %String, AEpisodeID As %String, AEventType As %String, ASequence As %String = "") As %GlobalBinaryStream
{
	s result = ##Class(%GlobalCharacterStream).%New()
	d result.Write("[")
	s count = 0
	q:(AEpisodeID = "") result
	//手术
	s flag = ""
	for
	{
		s flag = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag),-1)
		q:(flag = "")
		s date = ""
		for
		{
		    s date = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date),-1)
		    q:(date = "")
		    s time = ""
		    for
		    {
		    	s time = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time),-1)
		    	q:(time = "")
		    	s rowId = "" 
			    for
			    {
			    	s rowId = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time,rowId))
			    	q:(rowId = "")
			    	s obj = ##Class(EMRinstance.Events.Operation).%OpenId(rowId)
			    	continue:(obj = "")
			    	s subId = $o(^DHCEMRI.Events.OperationSubI("IdxOperRef",rowId,""))
			    	continue:(subId = "")
			    	s objSub = ##Class(EMRinstance.Events.OperationSub).%OpenId(rowId_"||"_subId)
			    	continue:(objSub = "")
					s OperDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$Case(obj.OperStartDate,"":obj.OperDate,:obj.OperStartDate))
					s OperTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$Case(obj.OperStartTime,"":"",:obj.OperStartTime))
					s OperDesc = objSub.Oper
					s OperDocName = obj.OperDoc
					s OperAssistFirstDesc = obj.OperAssistFirst
					s OperAssistSecondDesc = obj.OperAssistSecond
					s OperPAStatus = obj.OperPAStatus
					s operInfo = OperDate_" "_OperTime_" | "_OperDesc_" | "_OperDocName_" | "_OperAssistFirstDesc_" | "_OperAssistSecondDesc_" "_OperPAStatus
			    	
			    	s stream = ##Class(EMRservice.BL.BLClientCategory).GetInstanceByCategoryEvent(ACategoryId,AEpisodeID,AEventType,rowId,ASequence,operInfo)
			    	if (stream.Size '= 0)
			    	{
				    	d:(result.Size > 1) result.Write(",")
				    	d result.CopyFrom(stream)
			    	}
			    }
		    }
		}
	}
	//无关联病历
	s noLinkStream = ##Class(EMRservice.BL.BLClientCategory).GetInstanceNoLinkEvent(ACategoryId,AEpisodeID,AEventType,"无关联手术相关记录")
	if (noLinkStream.Size '= 0)
	{
		d:(result.Size > 1) result.Write(",")
		d result.CopyFrom(noLinkStream)
	}
	d result.Write("]")
	q result
}

/// Desc:        实例关联手术
/// Creator:     liuyunfei
/// CreateDate:  2021-09-29
/// Input:       AEvnetID事件ID，AInstanceIDs:inistanceId(多个时以"^"分隔)
/// Output:      0/1
/// Debug:       w ##Class(EMRservice.BL.Event.BLOperation).SetContactDocument("24","236||5^")
ClassMethod SetContactDocument(AEvnetID As %String, AInstanceIDs As %String) As %String
{
	s ret = "0"
	q:(AEvnetID = "")||(AInstanceIDs = "") ret
	for i=1:1:$l(AInstanceIDs,"^")
	{
		s intanceId = $p(AInstanceIDs,"^",i)
		q:(intanceId= "")
		s ret = ..SetFinish(AEvnetID,intanceId)
		q:(ret = "0")
	}
	q ret
}

/// Desc:        手术移除实例
/// Creator:     liuyunfei
/// CreateDate:  2021-09-29
/// Input:       AInstanceIDs:inistanceId(多个时以"^"分隔), AUserID:用户ID
/// Output:      0/1
/// Debug:       w ##Class(EMRservice.BL.Event.BLOperation).SetContactDocument("236||5^","10209")
ClassMethod DeleteContactDocument(AInstanceIDs As %String, AUserID As %String) As %String
{
	s ret = "0"
	q:(AInstanceIDs = "") ret
	for i=1:1:$l(AInstanceIDs,"^")
	{
		s intanceId = $p(AInstanceIDs,"^",i)
		q:(intanceId= "")
		s ret = ##class(EMRservice.BL.Event.BLLinkDocument).DeleteData(intanceId,AUserID)
		q:(ret = "0")
	}
	q ret
}

/// Desc:       设置条目再次提示
/// Creator:    王煜
/// CreateDate: 2021-09-07
/// Input:      AID 表的rowID
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLOperation).SetActive(1)
ClassMethod SetActive(AIDs As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	for i=1:1:$l(AIDs,"@")
	{
		s id = $p(AIDs,"@",i)
		s obj = ##Class(EMRinstance.Events.Operation).%OpenId(id)
		continue:(obj = "")
		s obj.IsActive = "Y"
		s:($$$ISOK(obj.%Save())) result = "1"
		q:(result = "0")
	}
	q result
}

}
