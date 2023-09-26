/// 名称:	EMR.OP.BL.SelfPrintBase
/// 描述:	门诊病历-自助打印(基类)
/// 编写者：yejian
/// 编写日期: 2022-12-7
/// 产品组：电子病历产品组
Class EMR.OP.BL.SelfPrintBase Extends EMR.OP.COM.ActionBase
{

/// Desc:       根据登记号获取当日门诊病历的打印记录
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_TODAYPRINTLIST","product":"OP","params":{"papmiNo":"1176","episodeID":"35"}}
/// 			papmiNo:登记号，episodeID:就诊号
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData  列 [{"id":"2461||1","ctloc":"基本外科门诊","doc":"牛备战","date":"2014-12-08 10:36:09","status":"2014-12-08 17:38:49"}]
/// 			json格式的信息，id：病历记录号；ctloc：就诊科室；doc：医生；date：就诊日期；status：通过自助设备打印的日期
ClassMethod GetTodayPrintList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s papmiNo = argInJson.params.papmiNo
	s episodeID = argInJson.params.episodeID
	s product = argInJson.params.product
    s strRes = ##Class(EMR.OP.BL.SelfPrintBase).GetTodayPrintListJson(papmiNo,episodeID,product,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       根据登记号获取当日门诊病历的打印记录
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:   
/// Output:     json数组
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.SelfPrintBase).GeDateFormatJson(.obj)
ClassMethod GetTodayPrintListJson(aPapmiNo As %String, aEpisodeID As %String, aProduct As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(""=aPapmiNo) "-1^登记号不能为空"
	s arrJson = ##class(%DynamicArray).%New()
	s today=+$P($H,",",1)
	;s today=+66340
	s papmiRowid=""
	for 
	{
		s papmiRowid=$o(^PAPERi("PAPMI_PatNo",aPapmiNo,papmiRowid))
		q:(papmiRowid="")
		s paadm=""
		for 
		{
			s paadm=$o(^PAPERdr(papmiRowid,"ADM","O",paadm))
			//w "paadm:"_paadm,!
			q:(paadm="")
			s TILDocumentData = ##Class(EMR.DAO.DocumentData).GetTureIndexLocation(paadm)
			s TILPrintData = ##class(EMR.DAO.DocumentPrintRecord).GetTureIndexLocation(paadm)
			s admdate=$P($G(^PAADM(paadm)),"^",6)
			if (admdate=today) 
			{ 
			 	s DOCCategoryCode = ""
                for
                {
                    s DOCCategoryCode = $O(@TILDocumentData@("IdxMain",paadm,DOCCategoryCode))
                    q:(""=DOCCategoryCode)
	                s ListNo = ""
	                for
	                {
	                    s ListNo = $O(@TILDocumentData@("IdxMain",paadm,DOCCategoryCode, ListNo),-1)
	                    q:(""=ListNo)
	                    s documentID = $O(@TILDocumentData@("IdxMain",paadm,DOCCategoryCode, ListNo,""))
						s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(documentID)
						;s objDoc = ##class(EMR.DB.DocumentData).%OpenId(documentID)
						continue:(objDoc="")
						s objTem = objDoc.TemplateID
						//2
						s ctloc=""
						s value=$P($g(^PAADM(paadm)),"^",4)
						if (value'="")
						{
							s value=^CTLOC(value)
							s ctloc=$p($p(value, "^", 2), "-",2)
						}
						//3
						s doc=""
						s value=$P($g(^PAADM(paadm)),"^",9)
						if (value'="")
						{
							s value = $g(^SSU("SSUSR",+value))
							s doc = $p(value,"^",2)
						}
						//4
						s date=""
						s value=##Class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(paadm)
						if (value'="")
						{
							s date=$zd($P($G(value),",",1),3)_" "_$zt($P($G(value),",",2),1)
						}			    
				    	s status=""
				    	s value=$O(@TILPrintData@("IdxTypeID"," SELFPRINT",documentID, ""), -1)
				    	//b
				    	if (value'="") 
				    	{ 
				    		s obj=##Class(EMR.DAO.DocumentPrintRecord).doOpenByID(paadm,value)
				    		s status=$zd(obj.PrintDate,3)_" "_$zt(obj.PrintTime,1)
				    	}
	                    
	                    //过滤掉未签名的病历
	                    s havasign=##Class(EMR.DOC.BL.PrivAssist).HasValidSign(documentID)
	                    continue:(havasign="0")
	                    s enDocID = ##class(EMR.DOC.COM.EncryptionTool).GetEncDocId(documentID)
	                    s jsonItem=##class(%DynamicObject).%New()
						s jsonItem.id=enDocID
						s jsonItem.ctloc=ctloc
						s jsonItem.doc=doc
						s jsonItem.date=date
						s jsonItem.status=status
						s jsonItem.text=objTem.Name
						s jsonItem.chartItemType=objTem.ChartItemType
						d arrJson.%Push(jsonItem)
					}
                }
			}	 	
		}
	}
	d arrJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取自助打印的CSP地址
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_SELFPRINT_PARAM","product":"OP","params":{"documentID":"5233B76FBCB64E4B9B538DE060B49D94464290CA3D4E9AC42FA996A837AC50B614CE0AB10539DDE5F6B4E3574BB2FA4C"}}
/// 			documentID 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData  
ClassMethod GetSelfPrintParam(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s documentID = argInJson.params.documentID
	s product =argInJson.params.product
    s strRes = ##Class(EMR.OP.BL.SelfPrintBase).GetSelfPrintParamJson(documentID,product,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取自助打印的CSP地址
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:   	aENDocumentID 加密的文档ID
/// 			aProduct 项目标识
/// Output:     json数组
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.SelfPrintBase).GeDateFormatJson(.obj)
ClassMethod GetSelfPrintParamJson(aENDocumentID As %String, aProduct As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(""=aENDocumentID) "-1^文档ID不能为空"
	//获取解密文档ID
	s docmentID = ##class(EMR.DOC.COM.EncryptionTool).GetUnEncDocId(aENDocumentID)
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(docmentID)
	q:(""=objDoc) "-1^文档ID获取文档失败"
	//获取业务活动记录ID
	s recordID = ##Class(EMR.DOC.BL.TemplateCategory).GetTemplateRecord(objDoc.TemplateCategoryID)
	s objRecord = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(recordID)
	q:(objRecord="") "-1^获取业务活动记录失败"
	s serial = objDoc.Serial
	s leadframe = $case(objRecord.Title.IsLeadframe,"1":objRecord.Title.IsLeadframe,:"0")
	//指定病历实例是否有对应患者签名后的PDF文档
	s EpisodeID = objDoc.EpisodeID.%Id()
	s pdfStatus = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFStatus(docmentID, EpisodeID)
	s pluginType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"WORD")
	s pmdType ="EMR"
	s refData = """csp/emr.bs.op.print.csp?documentID="_aENDocumentID_"&serial="_serial_"&leadframe="_leadframe_"&pluginType="_pluginType_"&pmdType="_pmdType_"&product=OP&autoPrint=Y&pmdType=SELFPRINT"""
	d argOutData.Write(refData)
	q strRes
}

}
