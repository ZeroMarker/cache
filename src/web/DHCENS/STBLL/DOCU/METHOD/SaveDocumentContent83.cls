Class web.DHCENS.STBLL.DOCU.METHOD.SaveDocumentContent83 Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.DOCU.METHOD.SaveDocumentContent83).GetXMLConternFromTable("2")
/// 测试从"HOS_Document"表里面取数据
ClassMethod GetXMLConternFromTable(DocumentID As %String) As %String
{
	set $zt="Exception"
	set rowId=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTPKey",DocumentID,""))
	q:+rowId=0 ""
	set docObj=##class(User.EnsHOSDocument).%OpenId(rowId)
	set content=##class(%GlobalCharacterStream).%New()
	do content.CopyFrom(docObj.HOSDCContent)
	set str=content.Read()
	q str
Exception
	q "-1"_$ze
}

/// Creator：WangYaru
/// CreatDate：2017—08-09
/// Description：保存以xml格式传入的检查、检验结果信息(其中报告内容以base64加密)
/// Table：User.EnsHOSDocument、User.EnsRelOrderDocument
/// Input：xml字符串格式的检查、检验结果
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.DOCU.METHOD.SaveDocumentContent83).SaveXmlResult("<Request><Header><SourceSystem>PACS</SourceSystem><MessageID>20181212141200931</MessageID></Header><Body><RegisterDocumentRt><OrganizationCode>0001</OrganizationCode><PATPatientID>0000000061</PATPatientID><PAADMVisitNumber>61</PAADMVisitNumber><RISRExamID>86500</RISRExamID><SpecimenID></SpecimenID><OEORIOrderItemID>14||109</OEORIOrderItemID><DocumentType>17：其他检查结果</DocumentType><DocumentID>0001517166</DocumentID><DocumentContent>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjxjbGluaWNhbERvY3VtZW50Pg0KPGRvY3VtZW50SGVhZGVyPg0KICAgIDxyZWFsbUNvZGU+PC9yZWFsbUNvZGU+IDwhLS3KudPDt7bOpy0tPiANCgk8dHlwZUlkPjwvdHlwZUlkPiA8IS0tzsS1tcDg0M0tLT4NCgk8dGVtcGxhdGUvPiA8IS0txKOw5UlEvLCw5rG+usUtLT4NCiAgICA8aWQ+PC9pZD4gIDwhLS3OxLW1wffLrrrFLS0+ICAgICAgICAgIA0KICAgIDx0aXRsZT687LLpsai45jwvdGl0bGU+DQoJPGVmZmVjdGl2ZVRpbWU+MjAxODEyMTIxNDEyMDA5MzQ8L2VmZmVjdGl2ZVRpbWU+IDwhLS3OxLW1yfqzycqxvOQtLT4gDQoJPGNvbmZpZGVudGlhbGl0eSBjb2RlPSK8trHwtPrC6yIgPry2sfDD+7PGPC9jb25maWRlbnRpYWxpdHk+ICA8IS0tsaPD3Ly2sfAtLT4NCgk8dmVyc2lvbk51bWJlcj48L3ZlcnNpb25OdW1iZXI+ICAgPCEtLc7EtbWw5rG+usUtLT4NCgk8YXV0aG9yIGlkPSLSvcn6seC6xSI+0r3J+tDVw/s8L2F1dGhvcj4JPCEtLc7EtbW0tNf31d8tLT4NCgk8Y3VzdG9kaWFuPjwvY3VzdG9kaWFuPgk8IS0tsaO53Lv6ubktLT4NCgk8cGF0aWVudD4NCgkJPG1lZGljYXJlTm8+MTAwNTgxPC9tZWRpY2FyZU5vPiAgPCEtLdeh1Lq6xS0tPg0KCQk8YWRtdmlzaXRObz48L2FkbXZpc2l0Tm8+ICA8IS0tvs3V77rFLS0+DQoJCTxtZWRSZWNvcmRObz48L21lZFJlY29yZE5vPiAgPCEtLbKhsLi6xS0tPg0KCQk8aGVhbHRoQ2FyZE5vPjwvaGVhbHRoQ2FyZE5vPiAgPCEtLb2hv7W/qLrFLS0+DQoJCTxjZXJ0aWZpY2F0ZT4NCgkJCTxuYW1lIGNvZGU9IjEiPsntt93WpDwvbmFtZT4NCgkJCTx2YWx1ZT48L3ZhbHVlPg0KCQk8L2NlcnRpZmljYXRlPg0KCQk8YWRkciBkZXNjPSLP1teh1rciPg0KCQkJPHRleHQ+PC90ZXh0Pg0KCQkJPGhvdXNlTnVtYmVyPjwvaG91c2VOdW1iZXI+DQoJCQk8c3RyZWV0TmFtZT4yc3RyZWV0TmFtZTwvc3RyZWV0TmFtZT4NCgkJCTx0b3duc2hpcD48L3Rvd25zaGlwPg0KCQkJPGNvdW50eT40Y291bnR5PC9jb3VudHk+DQoJCQk8Y2l0eT48L2NpdHk+DQoJCQk8c3RhdGU+PC9zdGF0ZT4NCgkJCTxwb3N0YWxDb2RlPjwvcG9zdGFsQ29kZT4NCgkJPC9hZGRyPg0KCQk8bmFtZT7B9eSvwMA8L25hbWU+DQoJCTx0ZWxlY29tPjE4ODIyNDQ1MTYyPC90ZWxlY29tPg0KCQk8YWRtaW5pc3RyYXRpdmVHZW5kZXIgY29kZT0iMiIgPsWuPC9hZG1pbmlzdHJhdGl2ZUdlbmRlcj4NCgkJPFN0YXR1cyBjb2RlPSJDb2RlIj48L1N0YXR1cz4NCgkJPGV0aG5pY0dyb3VwIGNvZGU9ImV0aG5pY0dyb3VwQ29kZSI+PC9ldGhuaWNHcm91cD4NCgkJPGFnZSB1bml0PSIiIHZhbHVlPSIyNsvqIi8+DQoJPC9wYXRpZW50Pg0KCTxwYXJ0aWNpcGFudD4NCgkJPGNvZGUgY29kZT0iQ29kZSI+PC9jb2RlPg0KICAgICAgICA8YWRkciBkZXNjPSLBqs+1yMu12Na3Ij4JDQoJCQkJPHRleHQ+PC90ZXh0Pg0KCQkJCTxob3VzZU51bWJlcj48L2hvdXNlTnVtYmVyPg0KCQkJCTxzdHJlZXROYW1lPjwvc3RyZWV0TmFtZT4NCgkJCQk8dG93bnNoaXA+PC90b3duc2hpcD4NCgkJCQk8Y291bnR5PjwvY291bnR5Pg0KCQkJCTxjaXR5PjwvY2l0eT4NCgkJCQk8c3RhdGU+PC9zdGF0ZT4NCgkJCQk8cG9zdGFsQ29kZT48L3Bvc3RhbENvZGU+DQoJCTwvYWRkcj4NCgkJPHRlbGVjb20+PC90ZWxlY29tPg0KCQk8bmFtZT48L25hbWU+DQoJPC9wYXJ0aWNpcGFudD4NCjwvZG9jdW1lbnRIZWFkZXI+DQo8c3RydWN0dXJlZEJvZHk+DQoJPEUwMDA0IGRlc2M9ItDVw/siPsH15K/AwDwvRTAwMDQ+DQoJPEUwMDA1IGRlc2M9ItDUsfC0+sLrIj4yPC9FMDAwNT4NCgk8RTAwMDYgZGVzYz0i0NSx8MPoyvYiPsWuPC9FMDAwNj4NCgk8RTAwMDggZGVzYz0ixOrB5CI+MjbL6jwvRTAwMDg+DQoJPEUwMTQ4IGRlc2M9IrKhyMvA4NDNtPrC6yI+MjwvRTAxNDg+DQoJPEUwMTQ5IGRlc2M9IrKhyMvA4NDNw/uzxiI+16HUujwvRTAxNDk+DQoJPEUwMTU2IGRlc2M9Ir/GytJpZCI+MDA5MzwvRTAxNTY+DQoJPEUwMDc3IGRlc2M9Ir/GytIiPsfpuNAyv8bK0jwvRTAwNzc+DQoJPEUwMDAyIGRlc2M9Iteh1Lq6xSI+MTAwNTgxPC9FMDAwMj4NCgk8RTAwMDAgZGVzYz0iw8XV77rFIj48L0UwMDAwPg0KCTxFMDE1NCBkZXNjPSKyobSyaWQiPjAxPC9FMDE1ND4NCgk8RTAwNzUgZGVzYz0isqG0siI+PC9FMDA3NT4tDQoJPHNlY3Rpb24gY29kZT0iUzAwNDgiIGRlc2M9ItXvts8iPg0KCQk8dGV4dC8+ICA8IS0t1e+2z7XEz+rPuNDFz6ItLT4NCgkJPEUwNyBkZXNjPSLSvcn6zO7QtLXE1e+2zyI+PC9FMDc+DQoJCTxFMDEgZGVzYz0i1e+2z8P7s8YiPtXvts/D+7PGPC9FMDE+PCEtLSDV77bPw/uzxiAtLT4NCgkJPEUwMiBkZXNjPSLV77bPtPrC6yI+1e+2z7T6wus8L0UwMj48IS0tINXvts+0+sLrIC0tPg0KCTwvc2VjdGlvbj4NCgk8c2VjdGlvbiBjb2RlPSJTMDA3NiIgZGVzYz0ivOyy6bzHwrwiPg0KCQk8dGV4dC8+ICA8IS0tvOyy6bzHwry1xM/qz7jQxc+iLS0+DQoJCTxFMDEgZGVzYz0ivOyy6brFIj44NjUwMDwvRTAxPg0KCQk8RTAyIGRlc2M9IrzssunJ6LG4seDC6yI+MDA0ODwvRTAyPg0KCQk8RTAzIGRlc2M9IrzssunJ6LG4w/uzxiI+wvXI8ERDODwvRTAzPg0KCQk8RTA0IGRlc2M9Irzssumyv867tPrC6yI+PC9FMDQ+DQoJCTxFMDUgZGVzYz0ivOyy6bK/zrvD+7PGIj6xx9HK0+u/2tHKPC9FMDU+LQ0KCQk8RTA2IGRlc2M9Irzssumyv8670r3J+srW0LQiPjwvRTA2Pg0KCQk8RTA3IGRlc2M9Irzssumyv867Ij48L0UwNz4NCgkJPEUwOCBkZXNjPSK87LLpy/m8+yI+tdoyoaIzvrHXtdau17Ww5c60vPu5x9DU0/q6z6Osz+DTprK/zrvTsry5xKTP8s3ixfKz9qOstO/GpM/Cs8qhsNHGweWhsdDOoaNUN6GiONe1zOW8sNfzsuDXtbDlwN/XtbnYvdqjrMDfucfNt6OsuuHNu7PKyNy5x9DUxsa7taOsvtayv7z7zcW/6de0yO3X6dav07CjrM/yx7DT68qztcC8sNDY1ve2r8L2vfTD3M/gwdqjrM/yxNqyos27yOvXtbnc0bnGyNOyxKTE0qOs1/Oy4MDfucfNt7ywVDnLrsa90tTXtczlxdTX87LgzqrW0NDEv8m8+9K7sru55tTyyO3X6dav1te/6aOsVDEw1/Oy4Lrhzbu8sNe1ua24+bywwN/XtbnYvdq5x9bKxsa7taOssqGx5LKiwNu8sL7Wsr/Q2LHavLDQ2MSko6zX87Lg0NjHu7z7ydnBv8uu0fnD3LbI07Cho9DY17VDVMmow+jKvqO6VDnQ2Ne1y67Gvb/JvPvSu7jfw9y2yNW8zrujrENU1rXOqjM4OEhVo6yx373nx+Wz/qOs1+6089axvrbOqjEwbW2jrNbXwfa3ts6nvtbP3lQ50NjXtcuuxr2jqEltMTEtSW0xM6Opwdq9/Ne1zOXOtLz7xsa7taGjPC9FMDg+DQoJCTxFMDkgZGVzYz0ivOyy6b3hufsiPry51vnB0aOsvLnEpMXys/bXtczl16rSxsH217W53MTa1bzOu7KhseQ8L0UwOT4NCgkJPEUxMCBkZXNjPSK87LLp0r3KprT6wusiPjwvRTEwPi0NCgkJPEUxMSBkZXNjPSK87LLp0r3KptDVw/siPjwvRTExPi0NCgkJPEUxMiBkZXNjPSLJ87rL0r3KprT6wusiPkRFTU88L0UxMj4NCgkJPEUxMyBkZXNjPSLJ87rL0r3KptDVw/siPrLiytTUsTwvRTEzPg0KCQk8RTE0IGRlc2M9IrzHwrzV37T6wusiPrLiytTUsU5vPC9FMTQ+DQoJCTxFMTUgZGVzYz0ivMfCvNXf0NXD+yI+suLK1NSxPC9FMTU+DQoJCTxFMTYgZGVzYz0ivOyy6cjVxtoiPjIwMTgtMTItMTI8L0UxNj4NCgkJPEUxNyBkZXNjPSK87LLpyrG85CI+MTM6Mzk6MTE8L0UxNz4NCgkJPEUxOCBkZXNjPSKxqLjmusUiPjE8L0UxOD4NCgkJPEUxOSBkZXNjPSLJ87rLyNXG2iI+MjAxOC0xMi0xMjwvRTE5Pg0KCQk8RTIwIGRlc2M9IsnzusvKsbzkIj4xMzo0OTowOTwvRTIwPg0KCQk8RTIxIGRlc2M9IrzssunP7sS/w+jK9iI+PC9FMjE+LQ0KCQk8RTIyIGRlc2M9Irzssum3vbeow+jK9iI+PC9FMjI+LQ0KCQk8RTIzIGRlc2M9IrGouObI1cbaIj4yMDE4LTEyLTEyPC9FMjM+DQoJCTxFMjQgZGVzYz0isai45sqxvOQiPjEzOjQ5OjA2PC9FMjQ+DQoJCTxFMjUgZGVzYz0i0r3W9rrFIj4xNHx8MTA5PC9FMjU+LQ0KCTwvc2VjdGlvbj4NCjwvc3RydWN0dXJlZEJvZHk+DQo8L2NsaW5pY2FsRG9jdW1lbnQ+</DocumentContent><DocumentPath>12DocumentPath</DocumentPath><UpdateUserCode>DEMO</UpdateUserCode><UpdateDate>2018-12-12</UpdateDate><UpdateTime>13:49:09</UpdateTime></RegisterDocumentRt></Body></Request>")
ClassMethod SaveXmlResult(inputXmlString As %GlobalCharacterStream) As %GlobalCharacterStream
{
	;set tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.SaveDocumentContent83).InsertHOSDocumentObj(inputXmlString)
	set tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.SaveDocumentContent).SaveXMLResult(inputXmlString)
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(tSC)
	q stream
}

/// Creator：WangYaru
/// CreatDate：2017—07-14
/// Description：保存以xml格式传入的检查、检验结果信息(其中报告内容以base64加密)
/// Table：
/// Input：xml流格式的检查、检验结果
/// Return：1：创建成功，-1：失败原因
ClassMethod InsertHOSDocumentObj(inputContent As %GlobalCharacterStream) As %String
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	if $$$ISERR(tSC) {
		Quit "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_tSC_"</ResultContent></Body></Response>"
	}else{
		set tSC=tDocument.EvaluateExpression("/Request/Body","count(RegisterDocumentRt)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>信息为空</ResultContent></Body></Response>"
			for i=1:1:hsCount {	
				set DocumentID=""
				set PATPatientID=""
				set PAADMVisitNumber=""
				set OrganizationCode=""	
				set DocumentType=""
				set UpdateUserCode=""
				set UpdateDate=""
				set UpdateTime=""
				set DocumentPath=""
				set DocumentContent=""
				set OEORIOrderItemID=""
				set RISRExamID=""
				set SpecimenID=""
				set DocumentPicPath=""
				// 来源系统的文档流水号
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/DocumentID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set DocumentID=$tr(fieldValue,$c(0),"")
				}
				// 患者主索引
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/PATPatientID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set PATPatientID=$tr(fieldValue,$c(0),"")
				}
				// 就诊号
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/PAADMVisitNumber","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
				}	
				// 医疗机构编码
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/OrganizationCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OrganizationCode=$tr(fieldValue,$c(0),"")
				}	
				// 文档类别
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/DocumentType","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set DocumentType=$tr(fieldValue,$c(0),"")
				}
				// 最后更新人编码	
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/UpdateUserCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateUserCode=$tr(fieldValue,$c(0),"")
				}	
				// 结果更新日期
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/UpdateDate","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateDate=$tr(fieldValue,$c(0),"")
				}
				// 结果更新时间
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/UpdateTime","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateTime=$tr(fieldValue,$c(0),"")
				}
				// LIS或PACS提供的报告链接
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/DocumentPath","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set DocumentPath=$tr(fieldValue,$c(0),"")
				}
				// LIS或PACS提供的图像链接
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/DocumentPicPath","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set DocumentPicPath=$tr(fieldValue,$c(0),"")
				}
				// base加密过的检查/检验报告
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/DocumentContent","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set DocumentContent=tRes.GetAt(1).Value
					;set DocumentContent=$tr(fieldValue,$c(0),"")
				}
				// 医嘱号
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/OEORIOrderItemID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORIOrderItemID=$tr(fieldValue,$c(0),"")
				}	
				// 检查号
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/RISRExamID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set RISRExamID=$tr(fieldValue,$c(0),"")
				}
				// 样本号
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/SpecimenID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set SpecimenID=$tr(fieldValue,$c(0),"")
				}		
				if DocumentPath'=""{
					set DocumentIndex=DocumentType_"_"_DocumentID_".pdf"
				}
				else{
					set DocumentIndex=DocumentType_"_"_DocumentID_".xml"
				}
				set tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.SaveDocumentContent83).GetDocRowIdByDocNum(DocumentIndex,.id)
				continue:tSC'=1
				// 文档尚未存储
				if id="" {
					set pTarget=##class(User.EnsHOSDocument).%New()
					if DocumentPath'="" {
						set pTarget.HOSDSerialNumber=DocumentType_"_"_DocumentID_".pdf"
						
						set pTarget.HOSDFormat="pdf"
					}
					else{
						set pTarget.HOSDSerialNumber=DocumentType_"_"_DocumentID_".xml"
						set pTarget.HOSDFormat="xml"
					}
					// 患者基本信息表的rowId
					set patRowId=""
					set patRowId=$o(^PAPERi("PAPMI_PatNo",PATPatientID,patRowId))
					d pTarget.HOSDPatientIDSetObjectId(patRowId)
					// 患者就诊表的rowId
					set admRowId=""
					set admRowId=PAADMVisitNumber
					//set admRowId=$o(^PAADMi("No",PAADMVisitNumber,admRowId))
					d pTarget.HOSDVisitNumberSetObjectId(admRowId)
					//医疗机构编码
					set pTarget.HOSDOrganId=OrganizationCode
					//文档来源
					set pTarget.HOSDManufacturerID="00001"
					//子系统内文档的唯一标识(===XML中的文档流水号)
					set pTarget.HOSDSubsysDocumentID=DocumentID
					//文档类型
					set pTarget.HOSDClassificationCode=DocumentType
					//文档版本号
					set pTarget.HOSDTemplateVersionNumber="V1.0"
					//文档类型编码
					set pTarget.HOSDTypeCode="1"
					//文档状态码
					set pTarget.HOSDStatus="1"
					set pTarget.HOSDUpdateUserCode=UpdateUserCode
					set:UpdateDate'="" pTarget.HOSDUpdateDate=$zdh(UpdateDate,3)		
					set:UpdateTime'="" pTarget.HOSDUpdateTime=$zth(UpdateTime,1)
					set pTarget.HOSDUrl=DocumentPath
					set pTarget.HOSDCPicUrl=DocumentPicPath
					set xmlString=""
					if DocumentContent'=""{
						// 若文档内容超长，则用xpath解析时自动存储为流的形式，在解密前需要先转换为字符串格式
						if $ISObject(DocumentContent){
							Set len = DocumentContent.Size
						    Do DocumentContent.Rewind()
					        Set xmlString = DocumentContent.Read(.len, .st)
						}else{
							set xmlString=DocumentContent
						}
						set xmlString=$SYSTEM.Encryption.Base64Decode(xmlString)
						set xmlString=$zcvt(xmlString,"I","UTF8")
						do pTarget.HOSDCContent.Write(xmlString)
					}
					set tSC=0
					ts
					set tSC = pTarget.%Save()
					if $$$ISOK(tSC) {
						//HOSDocument的RowID
						set HOSDRowID = pTarget.%Id()
						set:OEORIOrderItemID["_" OEORIOrderItemID=$replace(OEORIOrderItemID,"_","||")
						set OrdLen=$l(OEORIOrderItemID,"^")
						set ordIndex=0
						for
						{
							set ordIndex=ordIndex+1
							Quit:(ordIndex>OrdLen)
							// 文档存储成功后，新建文档关联表，存储医嘱等相关信息
							set relDocObj=##class(User.EnsRelOrderDocument).%New()
							// 患者基本信息表rowId
							d relDocObj.RelODPatientIDSetObjectId(patRowId)
							// 就诊表rowId
							d relDocObj.RelODVisitNumberSetObjectId(admRowId)
							// 医嘱号与就诊表核对
							set OrderItemID=$p(OEORIOrderItemID,"^",ordIndex)
							set ordId=$p(OrderItemID,"||",1) //医嘱主表的rowId
							set admRowId1=$p($g(^OEORD(ordId)),"^",1) //通过医嘱主表找见的就诊表rowId
							if (admRowId1'=admRowId){
								set ordFlag=0
								if faInfo'="" {
									s faInfo=faInfo_"#"_"就诊号与医嘱号不匹配"
									}
								else {
									s faInfo="就诊号与医嘱号不匹配"
									}
							}else{
								set ordFlag=1	
								d relDocObj.RelODOrderItemIDSetObjectId(OrderItemID)
							}
						}
						set relDocObj.RelODRisExamID=RISRExamID
						set relDocObj.RelODSpecimenID=SpecimenID
						//文档ID与HOS_Document的主键一致 
					    set documentId=$lg(^Busi.ENS.EnsHOSDocumentD(HOSDRowID),2)
						set relDocObj.RelODDocumentID=documentId
						set relDocObj.RelODDocumentType=pTarget.HOSDFormat
						set reltSC=relDocObj.%Save()
						set ResultCode="",ResultContent=""
						if (DocumentType="01001")||(DocumentType="01002") //检验报告、微生物检验报告
						{
							set ParseLISReportRet=##class(%GlobalCharacterStream).%New()
							set ParseLISReportRet=##class(web.DHCENS.STBLL.Method.PostReportInfo).ParseLISReport(inputContent)	
							set ResultCode=..GetResultCode(ParseLISReportRet)
							set ResultContent=..GetResultContent(ParseLISReportRet)
						}
						if (DocumentType="02001")||(DocumentType="02002")||(DocumentType="02003")||(DocumentType="02004")||(DocumentType="02005") //文档类型02001-02006分别为放射,超声,内镜,心电,核医学,病理报告
						{
							set ParsePACSReportRet=##class(%GlobalCharacterStream).%New()
							set ParsePACSReportRet=##class(web.DHCENS.STBLL.Method.PostReportInfo).ParsePACSReport(inputContent)	
							set ResultCode=..GetResultCode(ParsePACSReportRet)
							set ResultContent=..GetResultContent(ParsePACSReportRet)
						}
						if (DocumentType="02006") //病理报告
						{
							set ParsePISReportRet=##class(%GlobalCharacterStream).%New()
							set ParsePISReportRet=##class(web.DHCENS.STBLL.Method.PostReportInfo).ParsePISReport(inputContent)	
							set ResultCode=..GetResultCode(ParsePISReportRet)
							set ResultContent=..GetResultContent(ParsePISReportRet)
						}
						if ($e(DocumentType,1,2)="04")||($e(DocumentType,1,2)="05") //手麻单 
						{
							set ResultCode="0",ResultContent="成功"	
						}
						if $$$ISOK($$$ISOK(reltSC))&&($$$ISOK(ordFlag)&&(ResultCode="0")){
							tc
							set relRowId=relDocObj.%Id()
							set suCount=suCount+1
						}else{	
							set faCount=faCount+1
							set faInfo=faInfo_"#"_ResultContent
							tro
						}
						d relDocObj.%Close()
					}
					else {
						tro
					}
					d pTarget.%Close()	
				}
				// 文档已存在进行更新 id不为空
				else { 
					set pTarget=##class(User.EnsHOSDocument).%OpenId(id)
					if DocumentPath'="" {
						set pTarget.HOSDSerialNumber=DocumentType_"_"_DocumentID_".pdf"
						set pTarget.HOSDFormat="pdf"
					}
					else{
						set pTarget.HOSDSerialNumber=DocumentType_"_"_DocumentID_".xml"
						set pTarget.HOSDFormat="xml"
					}
					// 患者基本信息表rowId
					set patRowId=""
					set patRowId=$o(^PAPERi("PAPMI_PatNo",PATPatientID,patRowId))
					d pTarget.HOSDPatientIDSetObjectId(patRowId)
					// 患者就诊表rowId
					set admRowId=""
					set admRowId=PAADMVisitNumber
					d pTarget.HOSDVisitNumberSetObjectId(admRowId)
					set pTarget.HOSDOrganId=OrganizationCode
					set:pTarget.HOSDManufacturerID="" pTarget.HOSDManufacturerID=2
					set pTarget.HOSDSubsysDocumentID=DocumentID
					set pTarget.HOSDClassificationCode=DocumentType
					set pTarget.HOSDTemplateVersionNumber="V1.0"
					set pTarget.HOSDTypeCode="1"
					set pTarget.HOSDStatus="1"
					set pTarget.HOSDUpdateUserCode=UpdateUserCode
					set:UpdateDate'="" pTarget.HOSDUpdateDate=$zdh(UpdateDate,3)			
					set:UpdateTime'="" pTarget.HOSDUpdateTime=$zth(UpdateTime,1)
					set pTarget.HOSDUrl=DocumentPath
					set pTarget.HOSDCPicUrl=DocumentPicPath
					set xmlString=""
					if DocumentContent'=""{
						// 若文档内容超长，则用xpath解析时自动存储为流的形式，在解密前需要先转换为字符串格式
						if $ISObject(DocumentContent){
							Set len = DocumentContent.Size
						    Do DocumentContent.Rewind()
					        Set xmlString = DocumentContent.Read(.len, .st)
						}else{
							set xmlString=DocumentContent
						}
						set xmlString=$SYSTEM.Encryption.Base64Decode(xmlString)
						set xmlString=$zcvt(xmlString,"I","UTF8")
						do pTarget.HOSDCContent.Write(xmlString)
					}
					set tSC=0
					ts
					set tSC = pTarget.%Save()
					if $$$ISOK(tSC) {
						// 文档内容更新成功后，更新文档关联表
						//文档ID与HOS_Document的主键一致 
					    set documentId=$lg(^Busi.ENS.EnsHOSDocumentD(id),2)
						set relDocRowId=""
						for     
						{
							set relDocRowId=$o(^Busi.ENS.EnsRelOrderDocumentI("INDEXODDocumentID",documentId,relDocRowId))
							q:relDocRowId=""
							set relDocObj=##class(User.EnsRelOrderDocument).%OpenId(relDocRowId)
							// 患者基本信息表rowId
							d relDocObj.RelODPatientIDSetObjectId(patRowId)
							// 就诊表rowId
							d relDocObj.RelODVisitNumberSetObjectId(admRowId)
							// 医嘱号
							set ordId=$p(OEORIOrderItemID,"||",1) // 医嘱主表rowId
							set admRowId1=$p($g(^OEORD(ordId)),"^",1) // 根据医嘱主表找见的就诊表rowId
							if (admRowId1'=admRowId){
								set ordFlag=0
								if faInfo'="" {
									s faInfo=faInfo_"#"_"就诊号与医嘱号不匹配"
									}
								else {
									s faInfo="就诊号与医嘱号不匹配"
									}
							}
							else{
								set ordFlag=1	
								d relDocObj.RelODOrderItemIDSetObjectId(OEORIOrderItemID)
							}
						}
						set relDocObj.RelODRisExamID=RISRExamID
						set relDocObj.RelODSpecimenID=SpecimenID						
						set relDocObj.RelODDocumentID=documentId
						set relDocObj.RelODDocumentType=pTarget.HOSDFormat
						set reltSC=relDocObj.%Save()
						set ResultCode="",ResultContent=""
						if (DocumentType="01001")||(DocumentType="01002") //检验报告、微生物检验报告
						{
							set ParseLISReportRet=##class(%GlobalCharacterStream).%New()
							set ParseLISReportRet=##class(web.DHCENS.STBLL.Method.PostReportInfo).ParseLISReport(inputContent)	
							set ResultCode=..GetResultCode(ParseLISReportRet)
							set ResultContent=..GetResultContent(ParseLISReportRet)
						}
						if (DocumentType="02001")||(DocumentType="02002")||(DocumentType="02003")||(DocumentType="02004")||(DocumentType="02005") //文档类型02001-02006分别为放射,超声,内镜,心电,核医学
						{
							set ParsePACSReportRet=##class(%GlobalCharacterStream).%New()
							set ParsePACSReportRet=##class(web.DHCENS.STBLL.Method.PostReportInfo).ParsePACSReport(inputContent)
							set ResultCode=..GetResultCode(ParsePACSReportRet)
							set ResultContent=..GetResultContent(ParsePACSReportRet)
						}
						if (DocumentType="02006") //病理报告
						{
							set ParsePISReportRet=##class(%GlobalCharacterStream).%New()
							set ParsePISReportRet=##class(web.DHCENS.STBLL.Method.PostReportInfo).ParsePISReport(inputContent)	
							set ResultCode=..GetResultCode(ParsePISReportRet)
							set ResultContent=..GetResultContent(ParsePISReportRet)
						}
						if ($e(DocumentType,1,2)="04")||($e(DocumentType,1,2)="05") //手麻单 
						{
							set ResultCode="0",ResultContent="成功"	
						}
						if $$$ISOK($$$ISOK(reltSC))&&($$$ISOK(ordFlag)&&(ResultCode="0")){
							tc
							set relRowId=relDocObj.%Id()
							set suCount=suCount+1
						}else{	
							set faCount=faCount+1
							set faInfo=faInfo_"#"_ResultContent
							tro
						}
						d relDocObj.%Close()
					}
					else {
						tro
					}
					d pTarget.%Close()	
				}	
			}
		}
	}
	if ((faCount>0)||(suCount=0)) {
		Quit "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>成功数量："_suCount_",失败数量："_faCount_",失败内容："_faInfo_"</ResultContent></Body></Response>"
		
	}
	else {
		Quit "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></Body></Response>"
		
	}
Exception
	if $TLEVEL>0
	{
	 	tro	
	}
	Quit "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_$ze_"</ResultContent></Body></Response>"
}

/// Creator：     WangYaRu
/// CreatDate：   2017-07-14
/// Description:  根据文档流水号查询RowId
/// Table：       HOS_Document
/// Input：       DocNum:    文档流水号
/// Output:    	  RowId:   文档RowId
/// Return：      返回操作状态  0：操作成功；非0：操作未成功
/// Others:       w ##class(web.DHCENS.STBLL.DOCU.METHOD.SaveDocumentContent83).GetDocRowIdByDocNum()
ClassMethod GetDocRowIdByDocNum(DocNum As %String, Output RowId As %String) As %Status
{
	set $zt="Exception"
	set RowId=""
	set RowId=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",DocNum,""))
	Quit "1"
Exception
	set RowId=""
	Quit "-1^"_$ze
}

/// Creator：     zhangxiaofang
/// CreatDate：   2017-10-09
/// Description:  获取报告title（是检查还是检验）
/// Table：      
/// Input：       inputXmlStream：报告xml流
/// Output:    	  title：报告title
/// Return：      1：获取成功 -1：获取失败
/// Others:       w ##class(web.DHCENS.STBLL.DOCU.METHOD.SaveDocumentContent83).GetTitleFromXmlStreatm()
ClassMethod GetTitleFromXmlStreatm(inputXmlStream As %GlobalCharacterStream, Output title As %String) As %String
{
	set $zt="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputXmlStream,.tDocument)
	
	if $$$ISERR(tSC) {
	
		Quit "-1^"_tSC
		
	}else{
		set tSC=tDocument.EvaluateExpression("/clinicalDocument/documentHeader/title","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set title=$tr(fieldValue,$c(0),"")
			}	
		}
		if $p(tSC,"^",1)'="1" {
			q
		}
	Quit tSC
Exception
	Quit "-1^"_$ze
}

/// d ##class(web.DHCENS.STBLL.DOCU.METHOD.SaveDocumentContent83).TestTitle()
ClassMethod TestTitle()
{
	//set DocumentContent="PGNsaW5pY2FsRG9jdW1lbnQ+Cgk8ZG9jdW1lbnRIZWFkZXI+CgkJPHJlYWxtQ29kZS8+CgkJPHR5cGVJZC8+CgkJPHRlbXBsYXRlLz4KCQk8aWQvPgoJCTx0aXRsZT7lvq7nlJ/nianmo4DpqozmiqXlkYo8L3RpdGxlPgoJCTxlZmZlY3RpdmVUaW1lPjIwMTcwODE3MTIxODAwPC9lZmZlY3RpdmVUaW1lPgoJCTxjb25maWRlbnRpYWxpdHkgY29kZT0iIiAvPgoJCTx2ZXJzaW9uTnVtYmVyLz4KCQk8YXV0aG9yIGlkPSIwNTciPuiuuOS/iue6ojwvYXV0aG9yPgoJCTxjdXN0b2RpYW4vPgoJCTxwYXRpZW50PgoJCQk8bWVkaWNhcmVObz4wMDAxNzg2NzcwPC9tZWRpY2FyZU5vPgoJCQk8YWRtdmlzaXRObz4zMTAxMDczPC9hZG12aXNpdE5vPgoJCQk8bWVkUmVjb3JkTm8+MDAwNzQwMTc2NDwvbWVkUmVjb3JkTm8+CgkJCTxoZWFsdGhDYXJkTm8vPgoJCQk8Y2VydGlmaWNhdGU+CgkJCQk8bmFtZSBjb2RlPSIiLz4KCQkJCTx2YWx1ZS8+CgkJCTwvY2VydGlmaWNhdGU+CgkJCTxhZGRyIGRlc2M9IueOsOS9j+WdgCI+CgkJCQk8dGV4dC8+CgkJCQk8aG91c2VOdW1iZXIvPgoJCQkJPHN0cmVldE5hbWUvPgoJCQkJPHRvd25zaGlwLz4KCQkJCTxjb3VudHkvPgoJCQkJPGNpdHkvPgoJCQkJPHN0YXRlLz4KCQkJCTxwb3N0YWxDb2RlLz4KCQkJPC9hZGRyPgoJCQk8bmFtZT7liJjmtbfoh6M8L25hbWU+CgkJCTx0ZWxlY29tLz4KCQkJPGFkbWluaXN0cmF0aXZlR2VuZGVyIGNvZGU9IjEiPueUtzwvYWRtaW5pc3RyYXRpdmVHZW5kZXI+CgkJCTxtYXJpdGFsU3RhdHVzIGNvZGU9IiIvPgoJCQk8ZXRobmljR3JvdXAgY29kZT0iIi8+CgkJCTxhZ2UgdW5pdD0i5bKBIiB2YWx1ZT0iNjYiLz4KCQk8L3BhdGllbnQ+CgkJPHBhcnRpY2lwYW50PgoJCQk8Y29kZSBjb2RlPSIiLz4KCQkJPGFkZHIgZGVzYz0iIj4KCQkJCTx0ZXh0Lz4KCQkJCTxob3VzZU51bWJlci8+CgkJCQk8c3RyZWV0TmFtZS8+CgkJCQk8dG93bnNoaXAvPgoJCQkJPGNvdW50eS8+CgkJCQk8Y2l0eS8+CgkJCQk8c3RhdGUvPgoJCQkJPHBvc3RhbENvZGUvPgoJCQk8L2FkZHI+CgkJCTx0ZWxlY29tLz4KCQkJPG5hbWUvPgoJCTwvcGFydGljaXBhbnQ+Cgk8L2RvY3VtZW50SGVhZGVyPgoJPHN0cnVjdHVyZWRCb2R5PgoJCTxFMDAwNCBkZXNjPSLlp5PlkI0iPuWImOa1t+iHozwvRTAwMDQ+CgkJPEUwMDAwIGRlc2M9IumXqOiviuWPtyI+MDAwMTc4Njc3MDwvRTAwMDA+CgkJPEUwMDAyIGRlc2M9IuS9j+mZouWPtyI+MDAwMTc4Njc3MDwvRTAwMDI+CgkJPEUwMTQ4IGRlc2M9IueXheS6uuexu+Wei+S7o+eggSI+MzwvRTAxNDg+CgkJPEUwMTQ5IGRlc2M9IueXheS6uuexu+Wei+WQjeensCI+5L2P6ZmiPC9FMDE0OT4KCQk8RTAxNTAgZGVzYz0i6LS55Yir5Luj56CBIj5aRjwvRTAxNTA+CgkJPEUwMTUxIGRlc2M9Iui0ueWIq+WQjeensCI+5YWo6Ieq6LS5PC9FMDE1MT4KCQk8RTAwMDUgZGVzYz0i5oCn5Yir5Luj56CBIj4xPC9FMDAwNT4KCQk8RTAwMDYgZGVzYz0i5oCn5Yir5o+P6L+wIj7nlLc8L0UwMDA2PgoJCTxFMDE1NiBkZXNjPSLnp5HlrqRpZCI+MTAxNTAxQjwvRTAxNTY+CgkJPEUwMDc3IGRlc2M9IuenkeWupCI+MTwvRTAwNzc+CgkJPEUwMDA4IGRlc2M9IuW5tOm+hCI+NjY8L0UwMDA4PgoJCTxFMDE1NCBkZXNjPSLnl4XluoppZCIvPgoJCTxFMDA3NSBkZXNjPSLnl4XluooiPjIy5bqKPC9FMDA3NT4KCQk8c2VjdGlvbiBjb2RlPSJTMDA0OCIgZGVzYz0i6K+K5patIj4KCQkJPHRleHQvPgoJCQk8RTA3IGRlc2M9IuWMu+eUn+Whq+WGmeeahOiviuaWrSIvPgoJCQk8RTAxIGRlc2M9IuiviuaWreWQjeensCI+5aSa5Y+R5LykPC9FMDE+CgkJCTxFMDIgZGVzYz0i6K+K5pat5Luj56CBIi8+CgkJPC9zZWN0aW9uPgoJCTxzZWN0aW9uIGNvZGU9IlMwMDYxIiBkZXNjPSLmo4DpqozorrDlvZUiPgoJCQk8dGV4dC8+CgkJCTxFMDEgZGVzYz0i5qOA6aqM6aG555uu5Luj56CBIj5KWTUwMDA5MTwvRTAxPgoJCQk8RTAyIGRlc2M9IuajgOmqjOmhueebruWQjeensCI+5Yqo5oCB6KGA5bCP5p2/5Yqf6IO955uR5rWL77yI6IK+5LiK6IW657Sg6K+x6IGa5YmC77yJPC9FMDI+CgkJCTxFMDMgZGVzYz0i6YCB5qOA5pel5pyfIi8+CgkJCTxFMDQgZGVzYz0i6YCB5qOA5pe26Ze0Ii8+CgkJCTxFMDUgZGVzYz0i5qCH5pys57G75Z6L5Luj56CBIj45PC9FMDU+CgkJCTxFMDYgZGVzYz0i5qCH5pys57G75Z6L5ZCN56ewIj7lhajooYA8L0UwNj4KCQkJPEUwNyBkZXNjPSLmoIfmnKzlj7ciPjQxNzA4MTY3NDU3ODwvRTA3PgoJCQk8RTA4IGRlc2M9IuajgOmqjOWkh+azqCIvPgoJCQk8RTA5IGRlc2M9IumAgeajgOWMu+eUn+S7o+eggSI+MjwvRTA5PgoJCQk8RTEwIGRlc2M9IumAgeajgOWMu+eUn+Wnk+WQjSIvPgoJCQk8RTExIGRlc2M9IuajgOmqjOaXpeacnyIvPgoJCQk8RTEyIGRlc2M9IuajgOmqjOaXtumXtCIvPgoJCQk8RTEzIGRlc2M9IuajgOmqjOiAheS7o+eggSI+MjwvRTEzPgoJCQk8RTE0IGRlc2M9IuajgOmqjOiAheWnk+WQjSI+5p2O5ben6ImzPC9FMTQ+CgkJCTxFMTUgZGVzYz0i5oql5ZGK5pel5pyfIj4yMDE3LTA4LTE3PC9FMTU+CgkJCTxFMTYgZGVzYz0i5oql5ZGK5pe26Ze0Ij4xNjoxNDoxNDwvRTE2PgoJCQk8RTE3IGRlc2M9IuWuoeaguOaKpeWRiuaXpeacnyI+MjAxNy0wOC0xNzwvRTE3PgoJCQk8RTE4IGRlc2M9IuWuoeaguOaKpeWRiuaXtumXtCI+MTY6MTQ6MTQ8L0UxOD4KCQkJPEUxOSBkZXNjPSLlrqHmoLjogIXku6PnoIEiPjI8L0UxOT4KCQkJPEUyMCBkZXNjPSLlrqHmoLjogIXlp5PlkI0iPui1teWugeawkTwvRTIwPgoJCQk8RTIxIGRlc2M9IuaKpeWRiuWkh+azqCIvPgoJCQk8RTIyIGRlc2M9IuajgOmqjOebrueahCI+5Yqo5oCB6KGA5bCP5p2/5Yqf6IO95qOA5rWL77yI5LqM56O36YW46IW66Iu36K+xLOWKqOaAgeihgOWwj+adv+WKn+iDveajgOa1i++8iOiKseeUn+Wbm+eDr+mFuOivsSzliqjmgIHooYDlsI/mnb/lip/og73nm5HmtYvvvIjog7bljp/or7HogZrliYLvvIks5Yqo5oCB6KGA5bCP5p2/5Yqf6IO955uR5rWL77yI6IK+5LiK6IW6PC9FMjI+CgkJCTxFMjMgZGVzYz0i5qOA6aqM57uT5p6cIi8+CgkJCTxFMjQgZGVzYz0i5oql5ZGK5Y+3Ij44MjQxOTk4PC9FMjQ+CgkJCTxFMjUgZGVzYz0i5Yy75Zix5Y+3Ij4xfHwxPC9FMjU+CgkJCTxzZWN0aW9uIGNvZGU9IlMwMDYzIiBkZXNjPSLlvq7nlJ/nianln7nlhbvnlJ/miJDnu4boj4zkv6Hmga8iPgoJCQkJPHRleHQvPgoJCQkJPEUwMSBkZXNjPSLnu4boj4zku6PnoIEiPkM8L0UwMT4KCQkJCTxFMDIgZGVzYz0i57uG6I+M5ZCN56ewIj7pu4Tmm7LpnIk8L0UwMj4KCQkJCTxFMDMgZGVzYz0i57uG6I+M6K6h5pWwIi8+CgkJCQk8RTA0IGRlc2M9IuS4k+WutuinhOWImSIvPgoJCQkJPEUwNSBkZXNjPSLlpIfms6giLz4KCQkJCTxzZWN0aW9uIGNvZGU9IlMwMDY0IiBkZXNjPSLnu4boj4znmoToja/mlY/kv6Hmga8iPgoJCQkJCTx0ZXh0Lz4KCQkJCQk8IS0t57uG6I+M55qE6I2v5pWP5L+h5oGv55qE6K+m57uG5L+h5oGvLS0+CgkJCQkJPEUwMSBkZXNjPSLmipfnlJ/ntKDku6PnoIEiPkFhPC9FMDE+CgkJCQkJPEUwMiBkZXNjPSLmipfnlJ/ntKDlkI3np7AiPuWktOWtouWTjOmFri/oiJLlt7TlnaY8L0UwMj4KCQkJCQk8RTAzIGRlc2M9IuacgOS9juaKkeiPjOa1k+W6piI+Jmd0Oz0zMjwvRTAzPgoJCQkJCTxFMDQgZGVzYz0i6I2v5pWP57uT5p6c5Luj56CBIi8+CgkJCQkJPEUwNSBkZXNjPSLoja/mlY/nu5Pmnpzmj4/ov7AiPuaVj+aEnzwvRTA1PgoJCQkJCTxFMDYgZGVzYz0i5bu66K6uIi8+CgkJCQkJPEUwNyBkZXNjPSLoja/mlY/nu5PmnpzmoIflv5ciLz4KCQkJCQk8RTA4IGRlc2M9IknmipjngrnojIPlm7QiLz4KCQkJCQk8RTA5IGRlc2M9IlPmipjngrnojIPlm7QiLz4KCQkJCQk8RTEwIGRlc2M9IlLmipjngrnojIPlm7QiLz4KCQkJCQk8RTExIGRlc2M9IuivlemqjOaWueazlSIvPgoJCQkJPC9zZWN0aW9uPgoJCQkJPHNlY3Rpb24gY29kZT0iUzAwNjQiIGRlc2M9Iue7huiPjOeahOiNr+aVj+S/oeaBryI+CgkJCQkJPHRleHQvPgoJCQkJCTwhLS3nu4boj4znmoToja/mlY/kv6Hmga/nmoTor6bnu4bkv6Hmga8tLT4KCQkJCQk8RTAxIGRlc2M9IuaKl+eUn+e0oOS7o+eggSI+QmE8L0UwMT4KCQkJCQk8RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+5aS05a2i5ZOM6YWuL+iIkuW3tOWdpjwvRTAyPgoJCQkJCTxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj4mZ3Q7PTMyPC9FMDM+CgkJCQkJPEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiLz4KCQkJCQk8RTA1IGRlc2M9IuiNr+aVj+e7k+aenOaPj+i/sCI+6ICQ6I2vPC9FMDU+CgkJCQkJPEUwNiBkZXNjPSLlu7rorq4iLz4KCQkJCQk8RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyIvPgoJCQkJCTxFMDggZGVzYz0iSeaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTEgZGVzYz0i6K+V6aqM5pa55rOVIi8+CgkJCQk8L3NlY3Rpb24+CgkJCQk8c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj4KCQkJCQk8dGV4dC8+CgkJCQkJPCEtLee7huiPjOeahOiNr+aVj+S/oeaBr+eahOivpue7huS/oeaBry0tPgoJCQkJCTxFMDEgZGVzYz0i5oqX55Sf57Sg5Luj56CBIj5DYzwvRTAxPgoJCQkJCTxFMDIgZGVzYz0i5oqX55Sf57Sg5ZCN56ewIj7lpLTlraLlk4zpha4v6IiS5be05Z2mPC9FMDI+CgkJCQkJPEUwMyBkZXNjPSLmnIDkvY7mipHoj4zmtZPluqYiPiZndDs9MzI8L0UwMz4KCQkJCQk8RTA0IGRlc2M9IuiNr+aVj+e7k+aenOS7o+eggSIvPgoJCQkJCTxFMDUgZGVzYz0i6I2v5pWP57uT5p6c5o+P6L+wIj7ogJDoja88L0UwNT4KCQkJCQk8RTA2IGRlc2M9IuW7uuiuriIvPgoJCQkJCTxFMDcgZGVzYz0i6I2v5pWP57uT5p6c5qCH5b+XIi8+CgkJCQkJPEUwOCBkZXNjPSJJ5oqY54K56IyD5Zu0Ii8+CgkJCQkJPEUwOSBkZXNjPSJT5oqY54K56IyD5Zu0Ii8+CgkJCQkJPEUxMCBkZXNjPSJS5oqY54K56IyD5Zu0Ii8+CgkJCQkJPEUxMSBkZXNjPSLor5Xpqozmlrnms5UiLz4KCQkJCTwvc2VjdGlvbj4KCQkJCTxzZWN0aW9uIGNvZGU9IlMwMDY0IiBkZXNjPSLnu4boj4znmoToja/mlY/kv6Hmga8iPgoJCQkJCTx0ZXh0Lz4KCQkJCQk8IS0t57uG6I+M55qE6I2v5pWP5L+h5oGv55qE6K+m57uG5L+h5oGvLS0+CgkJCQkJPEUwMSBkZXNjPSLmipfnlJ/ntKDku6PnoIEiPkRkPC9FMDE+CgkJCQkJPEUwMiBkZXNjPSLmipfnlJ/ntKDlkI3np7AiPuWktOWtouWTjOmFri/oiJLlt7TlnaY8L0UwMj4KCQkJCQk8RTAzIGRlc2M9IuacgOS9juaKkeiPjOa1k+W6piI+Jmd0Oz0zMjwvRTAzPgoJCQkJCTxFMDQgZGVzYz0i6I2v5pWP57uT5p6c5Luj56CBIi8+CgkJCQkJPEUwNSBkZXNjPSLoja/mlY/nu5Pmnpzmj4/ov7AiPuiAkOiNrzwvRTA1PgoJCQkJCTxFMDYgZGVzYz0i5bu66K6uIi8+CgkJCQkJPEUwNyBkZXNjPSLoja/mlY/nu5PmnpzmoIflv5ciLz4KCQkJCQk8RTA4IGRlc2M9IknmipjngrnojIPlm7QiLz4KCQkJCQk8RTA5IGRlc2M9IlPmipjngrnojIPlm7QiLz4KCQkJCQk8RTEwIGRlc2M9IlLmipjngrnojIPlm7QiLz4KCQkJCQk8RTExIGRlc2M9IuivlemqjOaWueazlSIvPgoJCQkJPC9zZWN0aW9uPgoJCQkJPHNlY3Rpb24gY29kZT0iUzAwNjQiIGRlc2M9Iue7huiPjOeahOiNr+aVj+S/oeaBryI+CgkJCQkJPHRleHQvPgoJCQkJCTwhLS3nu4boj4znmoToja/mlY/kv6Hmga/nmoTor6bnu4bkv6Hmga8tLT4KCQkJCQk8RTAxIGRlc2M9IuaKl+eUn+e0oOS7o+eggSI+RWU8L0UwMT4KCQkJCQk8RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+5aS05a2i5ZOM6YWuL+iIkuW3tOWdpjwvRTAyPgoJCQkJCTxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj4mZ3Q7PTMyPC9FMDM+CgkJCQkJPEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiLz4KCQkJCQk8RTA1IGRlc2M9IuiNr+aVj+e7k+aenOaPj+i/sCI+6ICQ6I2vPC9FMDU+CgkJCQkJPEUwNiBkZXNjPSLlu7rorq4iLz4KCQkJCQk8RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyIvPgoJCQkJCTxFMDggZGVzYz0iSeaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTEgZGVzYz0i6K+V6aqM5pa55rOVIi8+CgkJCQk8L3NlY3Rpb24+CgkJCTwvc2VjdGlvbj4KCQkJPHNlY3Rpb24gY29kZT0iUzAwNjMiIGRlc2M9IuW+rueUn+eJqeWfueWFu+eUn+aIkOe7huiPjOS/oeaBryI+CgkJCQk8dGV4dC8+CgkJCQk8RTAxIGRlc2M9Iue7huiPjOS7o+eggSI+QjwvRTAxPgoJCQkJPEUwMiBkZXNjPSLnu4boj4zlkI3np7AiPijps57nirbkuIrnmq7nu4bog54mbHQ7MTDvvIznmb3nu4bog54mZ3Q7MjUpPC9FMDI+CgkJCQk8RTAzIGRlc2M9Iue7huiPjOiuoeaVsCIvPgoJCQkJPEUwNCBkZXNjPSLkuJPlrrbop4TliJkiLz4KCQkJCTxFMDUgZGVzYz0i5aSH5rOoIi8+CgkJCQk8c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj4KCQkJCQk8dGV4dC8+CgkJCQkJPCEtLee7huiPjOeahOiNr+aVj+S/oeaBr+eahOivpue7huS/oeaBry0tPgoJCQkJCTxFMDEgZGVzYz0i5oqX55Sf57Sg5Luj56CBIj5BYTE8L0UwMT4KCQkJCQk8RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+5aS05a2i5ZOM6YWuL+iIkuW3tOWdpjwvRTAyPgoJCQkJCTxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj4mZ3Q7PTMyPC9FMDM+CgkJCQkJPEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiLz4KCQkJCQk8RTA1IGRlc2M9IuiNr+aVj+e7k+aenOaPj+i/sCI+5pWP5oSfPC9FMDU+CgkJCQkJPEUwNiBkZXNjPSLlu7rorq4iLz4KCQkJCQk8RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyIvPgoJCQkJCTxFMDggZGVzYz0iSeaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTEgZGVzYz0i6K+V6aqM5pa55rOVIi8+CgkJCQk8L3NlY3Rpb24+CgkJCQk8c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj4KCQkJCQk8dGV4dC8+CgkJCQkJPCEtLee7huiPjOeahOiNr+aVj+S/oeaBr+eahOivpue7huS/oeaBry0tPgoJCQkJCTxFMDEgZGVzYz0i5oqX55Sf57Sg5Luj56CBIj5CYTE8L0UwMT4KCQkJCQk8RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+5aS05a2i5ZOM6YWuL+iIkuW3tOWdpjwvRTAyPgoJCQkJCTxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj4mZ3Q7PTMyPC9FMDM+CgkJCQkJPEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiLz4KCQkJCQk8RTA1IGRlc2M9IuiNr+aVj+e7k+aenOaPj+i/sCI+6ICQ6I2vPC9FMDU+CgkJCQkJPEUwNiBkZXNjPSLlu7rorq4iLz4KCQkJCQk8RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyIvPgoJCQkJCTxFMDggZGVzYz0iSeaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTEgZGVzYz0i6K+V6aqM5pa55rOVIi8+CgkJCQk8L3NlY3Rpb24+CgkJCQk8c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj4KCQkJCQk8dGV4dC8+CgkJCQkJPCEtLee7huiPjOeahOiNr+aVj+S/oeaBr+eahOivpue7huS/oeaBry0tPgoJCQkJCTxFMDEgZGVzYz0i5oqX55Sf57Sg5Luj56CBIj5DYzE8L0UwMT4KCQkJCQk8RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+5aS05a2i5ZOM6YWuL+iIkuW3tOWdpjwvRTAyPgoJCQkJCTxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj4mZ3Q7PTMyPC9FMDM+CgkJCQkJPEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiLz4KCQkJCQk8RTA1IGRlc2M9IuiNr+aVj+e7k+aenOaPj+i/sCI+6ICQ6I2vPC9FMDU+CgkJCQkJPEUwNiBkZXNjPSLlu7rorq4iLz4KCQkJCQk8RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyIvPgoJCQkJCTxFMDggZGVzYz0iSeaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTEgZGVzYz0i6K+V6aqM5pa55rOVIi8+CgkJCQk8L3NlY3Rpb24+CgkJCQk8c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj4KCQkJCQk8dGV4dC8+CgkJCQkJPCEtLee7huiPjOeahOiNr+aVj+S/oeaBr+eahOivpue7huS/oeaBry0tPgoJCQkJCTxFMDEgZGVzYz0i5oqX55Sf57Sg5Luj56CBIj5EZDE8L0UwMT4KCQkJCQk8RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+5aS05a2i5ZOM6YWuL+iIkuW3tOWdpjwvRTAyPgoJCQkJCTxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj4mZ3Q7PTMyPC9FMDM+CgkJCQkJPEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiLz4KCQkJCQk8RTA1IGRlc2M9IuiNr+aVj+e7k+aenOaPj+i/sCI+6ICQ6I2vPC9FMDU+CgkJCQkJPEUwNiBkZXNjPSLlu7rorq4iLz4KCQkJCQk8RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyIvPgoJCQkJCTxFMDggZGVzYz0iSeaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTEgZGVzYz0i6K+V6aqM5pa55rOVIi8+CgkJCQk8L3NlY3Rpb24+CgkJCQk8c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj4KCQkJCQk8dGV4dC8+CgkJCQkJPCEtLee7huiPjOeahOiNr+aVj+S/oeaBr+eahOivpue7huS/oeaBry0tPgoJCQkJCTxFMDEgZGVzYz0i5oqX55Sf57Sg5Luj56CBIj5FZTE8L0UwMT4KCQkJCQk8RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+5aS05a2i5ZOM6YWuL+iIkuW3tOWdpjwvRTAyPgoJCQkJCTxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj4mZ3Q7PTMyPC9FMDM+CgkJCQkJPEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiLz4KCQkJCQk8RTA1IGRlc2M9IuiNr+aVj+e7k+aenOaPj+i/sCI+6ICQ6I2vPC9FMDU+CgkJCQkJPEUwNiBkZXNjPSLlu7rorq4iLz4KCQkJCQk8RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyIvPgoJCQkJCTxFMDggZGVzYz0iSeaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTEgZGVzYz0i6K+V6aqM5pa55rOVIi8+CgkJCQk8L3NlY3Rpb24+CgkJCTwvc2VjdGlvbj4KCQkJPHNlY3Rpb24gY29kZT0iUzAwNjMiIGRlc2M9IuW+rueUn+eJqeWfueWFu+eUn+aIkOe7huiPjOS/oeaBryI+CgkJCQk8dGV4dC8+CgkJCQk8RTAxIGRlc2M9Iue7huiPjOS7o+eggSI+QTwvRTAxPgoJCQkJPEUwMiBkZXNjPSLnu4boj4zlkI3np7AiPijps57nirbkuIrnmq7nu4bog54mbHQ7MTDvvIznmb3nu4bog54mZ3Q7MjUpPC9FMDI+CgkJCQk8RTAzIGRlc2M9Iue7huiPjOiuoeaVsCIvPgoJCQkJPEUwNCBkZXNjPSLkuJPlrrbop4TliJkiLz4KCQkJCTxFMDUgZGVzYz0i5aSH5rOoIi8+CgkJCQk8c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj4KCQkJCQk8dGV4dC8+CgkJCQkJPCEtLee7huiPjOeahOiNr+aVj+S/oeaBr+eahOivpue7huS/oeaBry0tPgoJCQkJCTxFMDEgZGVzYz0i5oqX55Sf57Sg5Luj56CBIj5FZTE8L0UwMT4KCQkJCQk8RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+5aS05a2i5ZOM6YWuL+iIkuW3tOWdpjwvRTAyPgoJCQkJCTxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj4mZ3Q7PTMyPC9FMDM+CgkJCQkJPEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiLz4KCQkJCQk8RTA1IGRlc2M9IuiNr+aVj+e7k+aenOaPj+i/sCI+6ICQ6I2vPC9FMDU+CgkJCQkJPEUwNiBkZXNjPSLlu7rorq4iLz4KCQkJCQk8RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyIvPgoJCQkJCTxFMDggZGVzYz0iSeaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCIvPgoJCQkJCTxFMTEgZGVzYz0i6K+V6aqM5pa55rOVIi8+CgkJCQk8L3NlY3Rpb24+CgkJCTwvc2VjdGlvbj4KCQk8L3NlY3Rpb24+Cgk8L3N0cnVjdHVyZWRCb2R5Pgo8L2NsaW5pY2FsRG9jdW1lbnQ+"
	set DocumentContent="PGNsaW5pY2FsRG9jdW1lbnQ+Cgk8ZG9jdW1lbnRIZWFkZXI+CgkJPHRpdGxlPuajgOafpeaKpeWRijwvdGl0bGU+Cgk8L2RvY3VtZW50SGVhZGVyPgo8L2NsaW5pY2FsRG9jdW1lbnQ+Cg=="
	if $ISObject(DocumentContent){
		set xmlString=DocumentContent.Read()	
	}
	set xmlString=$SYSTEM.Encryption.Base64Decode(DocumentContent)
	set xmlString=$zcvt(xmlString,"I","UTF8")
	set xmlStream=##class(%GlobalCharacterStream).%New()
	do xmlStream.Write(xmlString)
	d ##class(web.DHCENS.STBLL.DOCU.METHOD.SaveDocumentContent83).GetTitleFromXmlStreatm(xmlStream,.title)
	w title
}

/// w ##class(web.DHCENS.STBLL.DOCU.METHOD.SaveDocumentContent83).TestDocu()
ClassMethod TestDocu() As %String
{
	;s input="<Request>    <Header>        <SourceSystem>SYS0002</SourceSystem>        <MessageID></MessageID>    </Header>    <Body>        <RegisterDocumentRt>            <OrganizationCode>DHSZHYYZY</OrganizationCode> <HospitalCode>DHSZHYYZY</HospitalCode><BusinessFieldCode>00001</BusinessFieldCode>           <PATPatientID>0000000001</PATPatientID>            <PAADMVisitNumber>5</PAADMVisitNumber>            <RISRExamID></RISRExamID>            <SpecimenID>0000000993</SpecimenID>            <OEORIOrderItemID>5||203</OEORIOrderItemID>                    <DocumentType>01001</DocumentType>            <DocumentID>0100101</DocumentID>            <DocumentContent>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPGNsaW5pY2FsRG9jdW1lbnQ+Cjxkb2N1bWVudEhlYWRlcj4KICAgIDxyZWFsbUNvZGU+PC9yZWFsbUNvZGU+IDwhLS3kvb/nlKjojIPlm7QtLT4gCgk8dHlwZUlkPjwvdHlwZUlkPiA8IS0t5paH5qGj57G75Z6LLS0+Cgk8dGVtcGxhdGUvPiA8IS0t5qih5p2/SUTlj4rniYjmnKzlj7ctLT4KICAgIDxpZD48L2lkPiAgPCEtLeaWh+aho+a1geawtOWPty0tPiAgICAgICAgICAKICAgIDx0aXRsZT7mo4DpqozmiqXlkYo8L3RpdGxlPgoJPGVmZmVjdGl2ZVRpbWU+MjAxOTExMTExNTQ4MjM8L2VmZmVjdGl2ZVRpbWU+IDwhLS3mlofmoaPnlJ/miJDml7bpl7QtLT4gCgk8Y29uZmlkZW50aWFsaXR5IGNvZGU9Iue6p+WIq+S7o+eggSIgPue6p+WIq+WQjeensDwvY29uZmlkZW50aWFsaXR5PiAgPCEtLeS/neWvhue6p+WIqy0tPgoJPHZlcnNpb25OdW1iZXI+PC92ZXJzaW9uTnVtYmVyPiAgIDwhLS3mlofmoaPniYjmnKzlj7ctLT4KCTxhdXRob3IgaWQ9IuWMu+eUn+e8luWPtyI+TElTMDE8L2F1dGhvcj4JPCEtLeaWh+aho+WIm+S9nOiAhS0tPgoJPGN1c3RvZGlhbj48L2N1c3RvZGlhbj4JPCEtLeS/neeuoeacuuaehC0tPgoJPHBhdGllbnQ+CgkJPG1lZGljYXJlTm8+PC9tZWRpY2FyZU5vPiAgPCEtLeS9j+mZouWPty0tPgoJCTxhZG12aXNpdE5vPjU8L2FkbXZpc2l0Tm8+ICA8IS0t5bCx6K+K5Y+3LS0+CgkJPG1lZFJlY29yZE5vPjwvbWVkUmVjb3JkTm8+ICA8IS0t55eF5qGI5Y+3LS0+CgkJPGhlYWx0aENhcmRObz48L2hlYWx0aENhcmRObz4gIDwhLS3lgaXlurfljaHlj7ctLT4KCQk8Y2VydGlmaWNhdGU+CgkJCTxuYW1lIGNvZGU9IuivgeS7tuexu+Wei+S7o+eggSI+6Lqr5Lu96K+BPC9uYW1lPgoJCQk8dmFsdWU+NDEyNzI2MTk5MTA0MTc2OTc3PC92YWx1ZT4KCQk8L2NlcnRpZmljYXRlPgoJCTxhZGRyIGRlc2M9IueOsOS9j+WdgCI+CgkJCTx0ZXh0PuWujOaVtOWcsOWdgDwvdGV4dD4KCQkJPGhvdXNlTnVtYmVyPnh45Y+3eHjlsI/ljLp4eOagi3h45Y2V5YWDPC9ob3VzZU51bWJlcj4KCQkJPHN0cmVldE5hbWU+eHjlpKfpgZM8L3N0cmVldE5hbWU+CgkJCTx0b3duc2hpcD54eOS5oemVhzwvdG93bnNoaXA+CgkJCTxjb3VudHk+eHjljLo8L2NvdW50eT4KCQkJPGNpdHk+eHjluII8L2NpdHk+CgkJCTxzdGF0ZT54eOecgTwvc3RhdGU+CgkJCTxwb3N0YWxDb2RlPjUxMDAwMDwvcG9zdGFsQ29kZT4KCQk8L2FkZHI+CgkJPG5hbWU+5byg6KGjPC9uYW1lPgoJCTx0ZWxlY29tPjEzNjQ5NTAwNDMyPC90ZWxlY29tPgoJCTxhZG1pbmlzdHJhdGl2ZUdlbmRlciBjb2RlPSIxIiA+55S35oCnPC9hZG1pbmlzdHJhdGl2ZUdlbmRlcj4KCQk8bWFyaXRhbFN0YXR1cyBjb2RlPSIyMCI+5bey5amaPC9tYXJpdGFsU3RhdHVzPgoJCTxldGhuaWNHcm91cCBjb2RlPSIwMSI+5rGJ5pePPC9ldGhuaWNHcm91cD4KCQk8YWdlIHVuaXQ9IuWygSIgdmFsdWU9IjI4Ii8+Cgk8L3BhdGllbnQ+Cgk8cGFydGljaXBhbnQ+CgkJPGNvZGUgY29kZT0iMSI+5a625bqt5YWz57O75o+P6L+wPC9jb2RlPgogICAgICAgIDxhZGRyIGRlc2M9IuiBlOezu+S6uuWcsOWdgCI+CQoJCQkJPHRleHQ+5a6M5pW05Zyw5Z2APC90ZXh0PgoJCQkJPGhvdXNlTnVtYmVyPnh45Y+3PC9ob3VzZU51bWJlcj4KCQkJCTxzdHJlZXROYW1lPnh45aSn6YGTPC9zdHJlZXROYW1lPgoJCQkJPHRvd25zaGlwPnh45Lmh6ZWHPC90b3duc2hpcD4KCQkJCTxjb3VudHk+eHjljLo8L2NvdW50eT4KCQkJCTxjaXR5Pnh45biCPC9jaXR5PgoJCQkJPHN0YXRlPnh455yBPC9zdGF0ZT4KCQkJCTxwb3N0YWxDb2RlPjAyMzY4PC9wb3N0YWxDb2RlPgoJCTwvYWRkcj4KCQk8dGVsZWNvbT45OTktOTk5LTk5OTk5OTwvdGVsZWNvbT4KCQk8bmFtZT7ogZTns7vkurrlp5PlkI08L25hbWU+Cgk8L3BhcnRpY2lwYW50Pgo8L2RvY3VtZW50SGVhZGVyPgo8c3RydWN0dXJlZEJvZHk+Cgk8RTAwMDQgZGVzYz0i5aeT5ZCNIj7lvKDooaM8L0UwMDA0PgoJPEUwMDAwIGRlc2M9IumXqOiviuWPtyI+PC9FMDAwMD4KCTxFMDAwMiBkZXNjPSLkvY/pmaLlj7ciPjwvRTAwMDI+Cgk8RTAxNDggZGVzYz0i55eF5Lq657G75Z6L5Luj56CBIj48L0UwMTQ4PgoJPEUwMTQ5IGRlc2M9IueXheS6uuexu+Wei+WQjeensCI+PC9FMDE0OT4KCTxFMDE1MCBkZXNjPSLotLnliKvku6PnoIEiPjwvRTAxNTA+Cgk8RTAxNTEgZGVzYz0i6LS55Yir5ZCN56ewIj48L0UwMTUxPgoJPEUwMDA1IGRlc2M9IuaAp+WIq+S7o+eggSI+MTwvRTAwMDU+Cgk8RTAwMDYgZGVzYz0i5oCn5Yir5o+P6L+wIj7nlLc8L0UwMDA2PgoJPEUwMDc3IGRlc2M9IuenkeWupCI+5YaF5YiG5rOM56eRPC9FMDA3Nz4KCTxFMDAwOCBkZXNjPSLlubTpvoQiPjI4PC9FMDAwOD4KCTxFMDA3NSBkZXNjPSLnl4XluooiPjAzPC9FMDA3NT4KCTxzZWN0aW9uIGNvZGU9IlMwMDQ4IiBkZXNjPSLor4rmlq0iPgoJCTx0ZXh0Lz4gIDwhLS3or4rmlq3nmoTor6bnu4bkv6Hmga8tLT4KCQk8RTA3IGRlc2M9IuWMu+eUn+Whq+WGmeeahOiviuaWrSI+PC9FMDc+CgkJPEUwMSBkZXNjPSLor4rmlq3lkI3np7AiPuiCqeiDm+WMuue7k+e8lOe7hOe7h+iJr+aAp+iCv+eYpDwvRTAxPgoJCTxFMDIgZGVzYz0i6K+K5pat5Luj56CBIj5EMjEuMzAzPC9FMDI+Cgk8L3NlY3Rpb24+Cgk8c2VjdGlvbiBjb2RlPSJTMDA2MSIgZGVzYz0i5qOA6aqM6K6w5b2VIj4KCQk8dGV4dC8+ICA8IS0t5qOA6aqM6K6w5b2V55qE6K+m57uG5L+h5oGvLS0+CgkJPEUwMSBkZXNjPSLmo4Dpqozpobnnm67ku6PnoIEiPkpZTDAwMDE8L0UwMT4KCQk8RTAyIGRlc2M9IuajgOmqjOmhueebruWQjeensCI+6KGA5bi46KeEPC9FMDI+CgkJPEUwMyBkZXNjPSLpgIHmo4Dml6XmnJ8iPjIwMjAtMDItMTg8L0UwMz4KCQk8RTA0IGRlc2M9IumAgeajgOaXtumXtCI+MTQ6MTQ6MTc8L0UwND4KCQk8RTA1IGRlc2M9Iuagh+acrOexu+Wei+S7o+eggSI+U1AwMDE8L0UwNT4KCQk8RTA2IGRlc2M9Iuagh+acrOexu+Wei+WQjeensCI+5YWo6KGAPC9FMDY+CgkJPEUwNyBkZXNjPSLmoIfmnKzlj7ciPjAwMDAwMDA5OTM8L0UwNz4KCQk8RTA4IGRlc2M9IuajgOmqjOWkh+azqCI+PC9FMDg+CgkJPEUwOSBkZXNjPSLpgIHmo4DljLvnlJ/ku6PnoIEiPllTMDE8L0UwOT4KCQk8RTEwIGRlc2M9IumAgeajgOWMu+eUn+Wnk+WQjSI+5Yy755SfMDE8L0UxMD4KCQk8RTExIGRlc2M9IuajgOmqjOaXpeacnyI+MjAyMC0wMi0xODwvRTExPgoJCTxFMTIgZGVzYz0i5qOA6aqM5pe26Ze0Ij4xNDoxNDoxNzwvRTEyPgoJCTxFMTMgZGVzYz0i5qOA6aqM6ICF5Luj56CBIj5MSVMwMTwvRTEzPgoJCTxFMTQgZGVzYz0i5qOA6aqM6ICF5aeT5ZCNIj5MSVMwMTwvRTE0PgoJCTxFMTUgZGVzYz0i5oql5ZGK5pel5pyfIj4yMDIwLTAyLTE4PC9FMTU+CgkJPEUxNiBkZXNjPSLmiqXlkYrml7bpl7QiPjE0OjE0OjE3PC9FMTY+CgkJPEUxNyBkZXNjPSLlrqHmoLjmiqXlkYrml6XmnJ8iPjIwMjAtMDItMTg8L0UxNz4KCQk8RTE4IGRlc2M9IuWuoeaguOaKpeWRiuaXtumXtCI+MTQ6MTQ6MTc8L0UxOD4KCQk8RTE5IGRlc2M9IuWuoeaguOiAheS7o+eggSI+TElTMDI8L0UxOT4KCQk8RTIwIGRlc2M9IuWuoeaguOiAheWnk+WQjSI+TElTMDI8L0UyMD4KCQk8RTIxIGRlc2M9IuaKpeWRiuWkh+azqCI+PC9FMjE+CgkJPEUyMiBkZXNjPSLmo4Dpqoznm67nmoQiPjwvRTIyPgoJCTxFMjMgZGVzYz0i5qOA6aqM57uT5p6cIj48L0UyMz4KCQk8RTI0IGRlc2M9IuaKpeWRiuWPtyI+UlAwMDAwMDE8L0UyND4KCQk8RTI1IGRlc2M9IuWMu+WYseWPtyI+NXx8MjAzPC9FMjU+CgkJPEUyNiBkZXNjPSLmiqXlkYrnp5HlrqTku6PnoIEiPlpZWUowMTQ8L0UyNj4KCQk8RTI3IGRlc2M9IuaKpeWRiuenkeWupOWQjeensCI+5qOA6aqM56eRPC9FMjc+CgkJPHNlY3Rpb24gY29kZT0iUzAwNjIiIGRlc2M9IuajgOmqjOWtkOmhuee7k+aenCI+CgkJCTx0ZXh0Lz4gIDwhLS3mo4DpqozlrZDpobnnu5PmnpznmoTor6bnu4bkv6Hmga8tLT4KCQkJPEUwMSBkZXNjPSLmo4DpqozlrZDpobnku6PnoIEiPkwwMDExPC9FMDE+CgkJCTxFMDIgZGVzYz0i5qOA6aqM5a2Q6aG55ZCN56ewIj7lvq7ph4/nmb3om4vnmb08L0UwMj4KCQkJPEUwMyBkZXNjPSLmo4DpqozlrZDpobnnu5PmnpzvvIjlrprph4/vvIkiPumYtOaApzwvRTAzPgoJCQk8RTA0IGRlc2M9IuajgOmqjOWtkOmhuee7k+aenOWNleS9jSI+PC9FMDQ+CgkJCTxFMDUgZGVzYz0i5qOA6aqM5a2Q6aG557uT5p6c77yI5a6a5oCn77yM6Zi0L+mYs++8iSI+6Zi05oCnPC9FMDU+CgkJCTxFMDYgZGVzYz0i5qOA6aqM5a2Q6aG55Y+C6ICD5YC86IyD5Zu0Ij7pmLTmgKc8L0UwNj4KCQkJPEUwNyBkZXNjPSLmo4DpqozlrZDpobnlvILluLjmoIflv5ciPjwvRTA3PgoJCQk8RTA4IGRlc2M9IuajgOmqjOiuvuWkh+e8lueggSI+PC9FMDg+CgkJCTxFMDkgZGVzYz0i5qOA6aqM6K6+5aSH5ZCN56ewIj48L0UwOT4KCQk8L3NlY3Rpb24+CgkJCQk8c2VjdGlvbiBjb2RlPSJTMDA2MiIgZGVzYz0i5qOA6aqM5a2Q6aG557uT5p6cIj4KCQkJPHRleHQvPiAgPCEtLeajgOmqjOWtkOmhuee7k+aenOeahOivpue7huS/oeaBry0tPgoJCQk8RTAxIGRlc2M9IuajgOmqjOWtkOmhueS7o+eggSI+TDAwMjU8L0UwMT4KCQkJPEUwMiBkZXNjPSLmo4DpqozlrZDpobnlkI3np7AiPuiNiemFuOebkOe7k+aZtjwvRTAyPgoJCQk8RTAzIGRlc2M9IuajgOmqjOWtkOmhuee7k+aenO+8iOWumumHj++8iSI+MzM8L0UwMz4KCQkJPEUwNCBkZXNjPSLmo4DpqozlrZDpobnnu5PmnpzljZXkvY0iPi91bDwvRTA0PgoJCQk8RTA1IGRlc2M9IuajgOmqjOWtkOmhuee7k+aenO+8iOWumuaAp++8jOmYtC/pmLPvvIkiPjMzPC9FMDU+CgkJCTxFMDYgZGVzYz0i5qOA6aqM5a2Q6aG55Y+C6ICD5YC86IyD5Zu0Ij48L0UwNj4KCQkJPEUwNyBkZXNjPSLmo4DpqozlrZDpobnlvILluLjmoIflv5ciPjwvRTA3PgoJCQk8RTA4IGRlc2M9IuajgOmqjOiuvuWkh+e8lueggSI+PC9FMDg+CgkJCTxFMDkgZGVzYz0i5qOA6aqM6K6+5aSH5ZCN56ewIj48L0UwOT4KCQk8L3NlY3Rpb24+CgkJCQk8c2VjdGlvbiBjb2RlPSJTMDA2MiIgZGVzYz0i5qOA6aqM5a2Q6aG557uT5p6cIj4KCQkJPHRleHQvPiAgPCEtLeajgOmqjOWtkOmhuee7k+aenOeahOivpue7huS/oeaBry0tPgoJCQk8RTAxIGRlc2M9IuajgOmqjOWtkOmhueS7o+eggSI+TDAxMjY8L0UwMT4KCQkJPEUwMiBkZXNjPSLmo4DpqozlrZDpobnlkI3np7AiPuihgOe6ouibi+eZvTwvRTAyPgoJCQk8RTAzIGRlc2M9IuajgOmqjOWtkOmhuee7k+aenO+8iOWumumHj++8iSI+NDQ8L0UwMz4KCQkJPEUwNCBkZXNjPSLmo4DpqozlrZDpobnnu5PmnpzljZXkvY0iPmcvZGw8L0UwND4KCQkJPEUwNSBkZXNjPSLmo4DpqozlrZDpobnnu5PmnpzvvIjlrprmgKfvvIzpmLQv6Ziz77yJIj40NDwvRTA1PgoJCQk8RTA2IGRlc2M9IuajgOmqjOWtkOmhueWPguiAg+WAvOiMg+WbtCI+MzAtNzA8L0UwNj4KCQkJPEUwNyBkZXNjPSLmo4DpqozlrZDpobnlvILluLjmoIflv5ciPkw8L0UwNz4KCQkJPEUwOCBkZXNjPSLmo4Dpqozorr7lpIfnvJbnoIEiPjwvRTA4PgoJCQk8RTA5IGRlc2M9IuajgOmqjOiuvuWkh+WQjeensCI+PC9FMDk+CgkJPC9zZWN0aW9uPgoJPC9zZWN0aW9uPgo8L3N0cnVjdHVyZWRCb2R5Pgo8L2NsaW5pY2FsRG9jdW1lbnQ+</DocumentContent>            <DocumentPath></DocumentPath>            <UpdateUserCode>LIS01</UpdateUserCode>            <UpdateDate>2020-02-18</UpdateDate>            <UpdateTime>14:14:16</UpdateTime>       </RegisterDocumentRt>    </Body></Request>"
	;s input="<Request>    <Header>        <SourceSystem>SYS0003</SourceSystem>        <MessageID></MessageID>    </Header>    <Body>        <RegisterDocumentRt>          <BusinessFieldCode>00001</BusinessFieldCode>            <HospitalCode>DHSZHYYZY</HospitalCode>            <OrganizationCode>DHSZHYYZY</OrganizationCode>          <PATPatientID>0000000001</PATPatientID>            <PAADMVisitNumber>5</PAADMVisitNumber>            <RISRExamID>5-207-1</RISRExamID>            <SpecimenID></SpecimenID>          <OEORIOrderItemID>5||207</OEORIOrderItemID>                    <DocumentType>02004</DocumentType>           <DocumentID>02001001</DocumentID>         <DocumentContent>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPGNsaW5pY2FsRG9jdW1lbnQ+Cjxkb2N1bWVudEhlYWRlcj4KICAgIDxyZWFsbUNvZGU+PC9yZWFsbUNvZGU+IDwhLS3kvb/nlKjojIPlm7QtLT4gCgk8dHlwZUlkPjwvdHlwZUlkPiA8IS0t5paH5qGj57G75Z6LLS0+Cgk8dGVtcGxhdGUvPiA8IS0t5qih5p2/SUTlj4rniYjmnKzlj7ctLT4KICAgIDxpZD48L2lkPiAgPCEtLeaWh+aho+a1geawtOWPty0tPiAgICAgICAgICAKICAgIDx0aXRsZT7lv4PnlLXmo4Dmn6XmiqXlkYo8L3RpdGxlPgoJPGVmZmVjdGl2ZVRpbWU+MjAxOTExMTMwMDAwNzwvZWZmZWN0aXZlVGltZT4gPCEtLeaWh+aho+eUn+aIkOaXtumXtC0tPiAKCTxjb25maWRlbnRpYWxpdHkgY29kZT0i57qn5Yir5Luj56CBIiA+57qn5Yir5ZCN56ewPC9jb25maWRlbnRpYWxpdHk+ICA8IS0t5L+d5a+G57qn5YirLS0+Cgk8dmVyc2lvbk51bWJlcj48L3ZlcnNpb25OdW1iZXI+ICAgPCEtLeaWh+aho+eJiOacrOWPty0tPgoJPGF1dGhvciBpZD0i5Yy755Sf57yW5Y+3Ij5ZUzAxPC9hdXRob3I+CTwhLS3mlofmoaPliJvkvZzogIUtLT4KCTxjdXN0b2RpYW4+PC9jdXN0b2RpYW4+CTwhLS3kv53nrqHmnLrmnoQtLT4KCTxwYXRpZW50PgoJCTxtZWRpY2FyZU5vPjEwMDE2MTwvbWVkaWNhcmVObz4gIDwhLS3kvY/pmaLlj7ctLT4KCQk8YWRtdmlzaXRObz44MDg8L2FkbXZpc2l0Tm8+ICA8IS0t5bCx6K+K5Y+3LS0+CgkJPG1lZFJlY29yZE5vPjEwMDE2MTwvbWVkUmVjb3JkTm8+ICA8IS0t55eF5qGI5Y+3LS0+CgkJPGhlYWx0aENhcmRObz4xMjM0NTY3ODwvaGVhbHRoQ2FyZE5vPiAgPCEtLeWBpeW6t+WNoeWPty0tPgoJCTxjZXJ0aWZpY2F0ZT4KCQkJPG5hbWUgY29kZT0i6K+B5Lu257G75Z6L5Luj56CBIj7ouqvku73or4Hlj7c8L25hbWU+CgkJCTx2YWx1ZT40MTI3MjYxOTkxMDQxNzY5Nzc8L3ZhbHVlPgoJCTwvY2VydGlmaWNhdGU+CgkJPGFkZHIgZGVzYz0i546w5L2P5Z2AIj4KCQkJPHRleHQ+6ZmV6KW/55yB6KW/5a6J5biC5L+h5a6J5bCP5Yy65YWr5Y2V5YWDMjAx5a6kPC90ZXh0PgoJCQk8aG91c2VOdW1iZXI+MTQ45Y+36ZW/5a6J5bCP5Yy65LiJ5qCL5YWr5Y2V5YWDPC9ob3VzZU51bWJlcj4KCQkJPHN0cmVldE5hbWU+6ZW/5a6J5Y2X6LevPC9zdHJlZXROYW1lPgoJCQk8dG93bnNoaXA+PC90b3duc2hpcD4KCQkJPGNvdW50eT7pm4HloZTljLo8L2NvdW50eT4KCQkJPGNpdHk+6KW/5a6J5biCPC9jaXR5PgoJCQk8c3RhdGU+6ZmV6KW/55yBPC9zdGF0ZT4KCQkJPHBvc3RhbENvZGU+NTEwMDAwPC9wb3N0YWxDb2RlPgoJCTwvYWRkcj4KCQk8bmFtZT7kuIHmmbrli4c8L25hbWU+CgkJPHRlbGVjb20+MDIwLTg3ODE1MTAyPC90ZWxlY29tPgoJCTxhZG1pbmlzdHJhdGl2ZUdlbmRlciBjb2RlPSIxIiA+55S35oCnPC9hZG1pbmlzdHJhdGl2ZUdlbmRlcj4KCQk8bWFyaXRhbFN0YXR1cyBjb2RlPSIyMCI+5bey5amaPC9tYXJpdGFsU3RhdHVzPgoJCTxldGhuaWNHcm91cCBjb2RlPSIwMSI+5rGJ5pePPC9ldGhuaWNHcm91cD4KCQk8YWdlIHVuaXQ9IuWygSIgdmFsdWU9IjYwIi8+Cgk8L3BhdGllbnQ+Cgk8cGFydGljaXBhbnQ+CgkJPGNvZGUgY29kZT0iMSI+5a625bqt5YWz57O75o+P6L+wPC9jb2RlPgogICAgICAgIDxhZGRyIGRlc2M9IuiBlOezu+S6uuWcsOWdgCI+CQoJCQkJPHRleHQ+6ZmV6KW/55yB6KW/5a6J5biC5L+h5a6J5bCP5Yy65YWr5Y2V5YWDMjAx5a6kPC90ZXh0PgoJCQkJPGhvdXNlTnVtYmVyPjE0OOWPtzwvaG91c2VOdW1iZXI+CgkJCQk8c3RyZWV0TmFtZT7njonmnpflpKfpgZM8L3N0cmVldE5hbWU+CgkJCQk8dG93bnNoaXA+PC90b3duc2hpcD4KCQkJCTxjb3VudHk+6ZuB5aGU5Yy6PC9jb3VudHk+CgkJCQk8Y2l0eT7opb/lronluII8L2NpdHk+CgkJCQk8c3RhdGU+6ZmV6KW/55yBPC9zdGF0ZT4KCQkJCTxwb3N0YWxDb2RlPjAyMzY4PC9wb3N0YWxDb2RlPgoJCTwvYWRkcj4KCQk8dGVsZWNvbT45OTktOTk5LTk5OTk5OTwvdGVsZWNvbT4KCQk8bmFtZT7kuIHkvKDlj5E8L25hbWU+Cgk8L3BhcnRpY2lwYW50Pgo8L2RvY3VtZW50SGVhZGVyPgo8c3RydWN0dXJlZEJvZHk+Cgk8RTAwMDQgZGVzYz0i5aeT5ZCNIj7lvKDooaM8L0UwMDA0PgoJPEUwMDA1IGRlc2M9IuaAp+WIq+S7o+eggSI+MTwvRTAwMDU+Cgk8RTAwMDYgZGVzYz0i5oCn5Yir5o+P6L+wIj7nlLc8L0UwMDA2PgoJPEUwMDA4IGRlc2M9IuW5tOm+hCI+Mjg8L0UwMDA4PgoJPEUwMTQ4IGRlc2M9IueXheS6uuexu+Wei+S7o+eggSI+STwvRTAxNDg+Cgk8RTAxNDkgZGVzYz0i55eF5Lq657G75Z6L5ZCN56ewIj7kvY/pmaI8L0UwMTQ5PgoJPEUwMTU2IGRlc2M9IuenkeWupGlkIj5aWVpZMDA2PC9FMDE1Nj4KCTxFMDA3NyBkZXNjPSLnp5HlrqQiPuW/g+WGheenkTwvRTAwNzc+Cgk8RTAwMDIgZGVzYz0i5L2P6Zmi5Y+3Ij4xMDAxNjE8L0UwMDAyPgoJPEUwMDAwIGRlc2M9IumXqOiviuWPtyI+ODAzMjExPC9FMDAwMD4KCTxFMDE1NCBkZXNjPSLnl4XluoppZCI+5b+D5YaFMeeXheWupDwvRTAxNTQ+Cgk8RTAwNzUgZGVzYz0i55eF5bqKIj4xMjwvRTAwNzU+Cgk8c2VjdGlvbiBjb2RlPSJTMDA0OCIgZGVzYz0i6K+K5patIj4KCQk8dGV4dC8+ICA8IS0t6K+K5pat55qE6K+m57uG5L+h5oGvLS0+CgkJPEUwNyBkZXNjPSLljLvnlJ/loavlhpnnmoTor4rmlq0iPuiCqeiDm+WMuue7k+e8lOe7hOe7h+iJr+aAp+iCv+eYpDwvRTA3PgoJCTxFMDEgZGVzYz0i6K+K5pat5ZCN56ewIj7ogqnog5vljLrnu5PnvJTnu4Tnu4foia/mgKfogr/nmKQ8L0UwMT4KCQk8RTAyIGRlc2M9IuiviuaWreS7o+eggSI+RDIxLjMwMzwvRTAyPgoJPC9zZWN0aW9uPgoJPHNlY3Rpb24gY29kZT0iUzAwNzYiIGRlc2M9IuajgOafpeiusOW9lSI+CgkJPHRleHQvPiAgPCEtLeajgOafpeiusOW9leeahOivpue7huS/oeaBry0tPgoJCTxFMDEgZGVzYz0i5qOA5p+l5Y+3Ij41LTIwNy0xPC9FMDE+CgkJPEUwMiBkZXNjPSLmo4Dmn6Xorr7lpIfnvJbnoIEiPkVLRzAwMDE8L0UwMj4KCQk8RTAzIGRlc2M9IuajgOafpeiuvuWkh+WQjeensCI+RUtH6L+b5Y+jMzAwMDwvRTAzPgoJCTxFMDQgZGVzYz0i5qOA5p+l6YOo5L2N5Luj56CBIj4yMTwvRTA0PgoJCTxFMDUgZGVzYz0i5qOA5p+l6YOo5L2N5ZCN56ewIj7og7jpg6g8L0UwNT4KCQk8RTA2IGRlc2M9IuajgOafpemDqOS9jeWMu+eUn+aJi+WGmSI+PC9FMDY+CgkJPEUwNyBkZXNjPSLmo4Dmn6Xpg6jkvY0iPuiDuOmDqDwvRTA3PgoJCTxFMDggZGVzYz0i5qOA5p+l5omA6KeBIj7ml6DlvILniak8L0UwOD4KCQk8RTA5IGRlc2M9IuajgOafpee7k+aenCI+MeOAgeeqpuaAp+W/g+W+iywy44CB5q2j5bi4IEVDRywz44CB5bem5b+D5oi/6IKl5aSnPC9FMDk+CgkJPEUxMCBkZXNjPSLmo4Dmn6XljLvluIjku6PnoIEiPjEwNzQ8L0UxMD4KCQk8RTExIGRlc2M9IuajgOafpeWMu+W4iOWnk+WQjSI+546L5pmT6ZyePC9FMTE+CgkJPEUxMiBkZXNjPSLlrqHmoLjljLvluIjku6PnoIEiPjI4MDA8L0UxMj4KCQk8RTEzIGRlc2M9IuWuoeaguOWMu+W4iOWnk+WQjSI+546L5qWgPC9FMTM+CgkJPEUxNCBkZXNjPSLorrDlvZXogIXku6PnoIEiPjAxNzg8L0UxND4KCQk8RTE1IGRlc2M9IuiusOW9leiAheWnk+WQjSI+5paH5bqG6LSkPC9FMTU+CgkJPEUxNiBkZXNjPSLmo4Dmn6Xml6XmnJ8iPjIwMTktMTEtMTQ8L0UxNj4KCQk8RTE3IGRlc2M9IuajgOafpeaXtumXtCI+MTc6MjA6MzQ8L0UxNz4KCQk8RTE4IGRlc2M9IuaKpeWRiuWPtyI+RUtHRDAwMDAxPC9FMTg+CgkJPEUxOSBkZXNjPSLlrqHmoLjml6XmnJ8iPjIwMTktMTEtMTQ8L0UxOT4KCQk8RTIwIGRlc2M9IuWuoeaguOaXtumXtCI+MTc6NDk6NDQ8L0UyMD4KCQk8RTIxIGRlc2M9IuajgOafpemhueebruaPj+i/sCI+5Y2B5LqM5a+85b+D55S15Zu+5qOA5p+lPC9FMjE+CgkJPEUyMiBkZXNjPSLmo4Dmn6Xmlrnms5Xmj4/ov7AiPjwvRTIyPgoJCTxFMjMgZGVzYz0i5oql5ZGK5pel5pyfIj4yMDE5LTExLTE1PC9FMjM+CgkJPEUyNCBkZXNjPSLmiqXlkYrml7bpl7QiPjExOjIxOjM0PC9FMjQ+CgkJPEUyNSBkZXNjPSLljLvlmLHlj7ciPjV8fDIwNzwvRTI1PgoJPC9zZWN0aW9uPgo8L3N0cnVjdHVyZWRCb2R5Pgo8L2NsaW5pY2FsRG9jdW1lbnQ+</DocumentContent>           <DocumentPath></DocumentPath>            <UpdateUserCode>RIS</UpdateUserCode>            <UpdateDate>2020-02-18</UpdateDate>            <UpdateTime>14:14:16</UpdateTime>       </RegisterDocumentRt>    </Body></Request>"
	;s input="<Request> <Header> <SourceSystem>SYS0004</SourceSystem> <MessageID></MessageID> </Header> <Body> <RegisterDocumentRt> <BusinessFieldCode>00001</BusinessFieldCode> <HospitalCode>DHSZHYYZY</HospitalCode> <OrganizationCode>DHSZHYYZY</OrganizationCode> <PATPatientID>0000000003</PATPatientID> <PAADMVisitNumber>1</PAADMVisitNumber> <RISRExamID>PIS2020021000006</RISRExamID> <SpecimenID></SpecimenID> <OEORIOrderItemID>2||179</OEORIOrderItemID> <DocumentType>02006</DocumentType> <DocumentID>02006001</DocumentID> <DocumentContent>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPGNsaW5pY2FsRG9jdW1lbnQ+Cjxkb2N1bWVudEhlYWRlcj4KICAgIDxyZWFsbUNvZGU+PC9yZWFsbUNvZGU+IDwhLS3kvb/nlKjojIPlm7QtLT4gCgk8dHlwZUlkPjwvdHlwZUlkPiA8IS0t5paH5qGj57G75Z6LLS0+Cgk8dGVtcGxhdGUvPiA8IS0t5qih5p2/SUTlj4rniYjmnKzlj7ctLT4KICAgIDxpZD48L2lkPiAgPCEtLeaWh+aho+a1geawtOWPty0tPiAgICAgICAgICAKICAgIDx0aXRsZT7nl4XnkIbmo4Dmn6XmiqXlkYo8L3RpdGxlPgoJPGVmZmVjdGl2ZVRpbWU+MjAxOTExMTYwMDAwNzwvZWZmZWN0aXZlVGltZT4gPCEtLeaWh+aho+eUn+aIkOaXtumXtC0tPiAKCTxjb25maWRlbnRpYWxpdHkgY29kZT0i57qn5Yir5Luj56CBIiA+57qn5Yir5ZCN56ewPC9jb25maWRlbnRpYWxpdHk+ICA8IS0t5L+d5a+G57qn5YirLS0+Cgk8dmVyc2lvbk51bWJlcj48L3ZlcnNpb25OdW1iZXI+ICAgPCEtLeaWh+aho+eJiOacrOWPty0tPgoJPGF1dGhvciBpZD0i5Yy755Sf57yW5Y+3Ij5ZUzAxPC9hdXRob3I+CTwhLS3mlofmoaPliJvkvZzogIUtLT4KCTxjdXN0b2RpYW4+PC9jdXN0b2RpYW4+CTwhLS3kv53nrqHmnLrmnoQtLT4KCTxwYXRpZW50PgoJCTxtZWRpY2FyZU5vPjwvbWVkaWNhcmVObz4gIDwhLS3kvY/pmaLlj7ctLT4KCQk8YWRtdmlzaXRObz4xPC9hZG12aXNpdE5vPiAgPCEtLeWwseiviuWPty0tPgoJCTxtZWRSZWNvcmRObz48L21lZFJlY29yZE5vPiAgPCEtLeeXheahiOWPty0tPgoJCTxoZWFsdGhDYXJkTm8+PC9oZWFsdGhDYXJkTm8+ICA8IS0t5YGl5bq35Y2h5Y+3LS0+CgkJPGNlcnRpZmljYXRlPgoJCQk8bmFtZSBjb2RlPSLor4Hku7bnsbvlnovku6PnoIEiPui6q+S7veivgeWPtzwvbmFtZT4KCQkJPHZhbHVlPjQxMjcyNjE5OTEwNDE3Njk3NzwvdmFsdWU+CgkJPC9jZXJ0aWZpY2F0ZT4KCQk8YWRkciBkZXNjPSLnjrDkvY/lnYAiPgoJCQk8dGV4dD7pmZXopb/nnIHopb/lronluILkv6HlronlsI/ljLrlhavljZXlhYMyMDHlrqQ8L3RleHQ+CgkJCTxob3VzZU51bWJlcj4xNDjlj7fplb/lronlsI/ljLrkuInmoIvlhavljZXlhYM8L2hvdXNlTnVtYmVyPgoJCQk8c3RyZWV0TmFtZT7plb/lronljZfot688L3N0cmVldE5hbWU+CgkJCTx0b3duc2hpcD48L3Rvd25zaGlwPgoJCQk8Y291bnR5PumbgeWhlOWMujwvY291bnR5PgoJCQk8Y2l0eT7opb/lronluII8L2NpdHk+CgkJCTxzdGF0ZT7pmZXopb/nnIE8L3N0YXRlPgoJCQk8cG9zdGFsQ29kZT41MTAwMDA8L3Bvc3RhbENvZGU+CgkJPC9hZGRyPgoJCTxuYW1lPuS4geaZuumjnjwvbmFtZT4KCQk8dGVsZWNvbT4wMjAtODc4MTUxMDI8L3RlbGVjb20+CgkJPGFkbWluaXN0cmF0aXZlR2VuZGVyIGNvZGU9IjEiID7nlLfmgKc8L2FkbWluaXN0cmF0aXZlR2VuZGVyPgoJCTxtYXJpdGFsU3RhdHVzIGNvZGU9IjIwIj7lt7LlqZo8L21hcml0YWxTdGF0dXM+CgkJPGV0aG5pY0dyb3VwIGNvZGU9IjAxIj7msYnml488L2V0aG5pY0dyb3VwPgoJCTxhZ2UgdW5pdD0i5bKBIiB2YWx1ZT0iNjAiLz4KCTwvcGF0aWVudD4KCTxwYXJ0aWNpcGFudD4KCQk8Y29kZSBjb2RlPSIxIj7lrrbluq3lhbPns7vmj4/ov7A8L2NvZGU+CiAgICAgICAgPGFkZHIgZGVzYz0i6IGU57O75Lq65Zyw5Z2AIj4JCgkJCQk8dGV4dD7pmZXopb/nnIHopb/lronluILkv6HlronlsI/ljLrlhavljZXlhYMyMDHlrqQ8L3RleHQ+CgkJCQk8aG91c2VOdW1iZXI+MTQ45Y+3PC9ob3VzZU51bWJlcj4KCQkJCTxzdHJlZXROYW1lPueOieael+Wkp+mBkzwvc3RyZWV0TmFtZT4KCQkJCTx0b3duc2hpcD48L3Rvd25zaGlwPgoJCQkJPGNvdW50eT7pm4HloZTljLo8L2NvdW50eT4KCQkJCTxjaXR5Puilv+WuieW4gjwvY2l0eT4KCQkJCTxzdGF0ZT7pmZXopb/nnIE8L3N0YXRlPgoJCQkJPHBvc3RhbENvZGU+MDIzNjg8L3Bvc3RhbENvZGU+CgkJPC9hZGRyPgoJCTx0ZWxlY29tPjk5OS05OTktOTk5OTk5PC90ZWxlY29tPgoJCTxuYW1lPuS4geS8oOWPkTwvbmFtZT4KCTwvcGFydGljaXBhbnQ+CjwvZG9jdW1lbnRIZWFkZXI+CjxzdHJ1Y3R1cmVkQm9keT4KCTxFMDAwNCBkZXNjPSLlp5PlkI0iPuS4geaZuumjnjwvRTAwMDQ+Cgk8RTAwMDUgZGVzYz0i5oCn5Yir5Luj56CBIj4xPC9FMDAwNT4KCTxFMDAwNiBkZXNjPSLmgKfliKvmj4/ov7AiPueUtzwvRTAwMDY+Cgk8RTAwMDggZGVzYz0i5bm06b6EIj4yODwvRTAwMDg+Cgk8RTAwMDAgZGVzYz0i6Zeo6K+K5Y+3Ij48L0UwMDAwPgoJPEUwMDAxIGRlc2M9IueXheahiOWPtyI+PC9FMDAwMT4KCTxFMDAwMiBkZXNjPSLkvY/pmaLlj7ciPjwvRTAwMDI+Cgk8RTAwNDAgZGVzYz0i6IGU57O755S16K+dIj4xNTU5NTU3MzY0MDwvRTAwNDA+Cgk8RTAxNTQgZGVzYz0i55eF5bqKaWQiPjEwPC9FMDE1ND4KCTxFMDA3NSBkZXNjPSLnl4XluooiPuWNleS6uuW6ijwvRTAwNzU+Cgk8RTAxNTYgZGVzYz0i56eR5a6kaWQiPlpZWlkwMDM8L0UwMTU2PgoJPEUwMDc3IGRlc2M9IuenkeWupCI+5YaF5YiG5rOM56eRPC9FMDA3Nz4KCTxFMDE3OSBkZXNjPSLmmK/lkKbnu53nu48iPjwvRTAxNzk+Cgk8RTAxODAgZGVzYz0i5pyr5qyh5pyI57uP5pel5pyfIj48L0UwMTgwPgoJPHNlY3Rpb24gY29kZT0iUzAxNDEiIGRlc2M9IueXheeQhuajgOafpeiusOW9lSI+CgkJPHRleHQvPiAgPCEtLeeXheeQhuajgOafpeiusOW9leeahOivpue7huS/oeaBry0tPgoJCTxFMDEgZGVzYz0i55Sz6K+35Y+3Ij5QSVMyMDIwMDIxMDAwMDA2PC9FMDE+CgkJPEUwMiBkZXNjPSLnl4XnkIblj7ciPlBJUzIwMjAwMjEwMDAwMDY8L0UwMj4KCQk8RTAzIGRlc2M9IuWunumqjOWupOe8luWPtyI+PC9FMDM+CgkJPEUwNCBkZXNjPSLpgIHmo4DljLvpmaLnvJbnoIEiPjwvRTA0PgoJCTxFMDUgZGVzYz0i6YCB5qOA5Yy76Zmi5ZCN56ewIj48L0UwNT4KCQk8RTA2IGRlc2M9IuajgOafpeWMu+mZoue8lueggSI+PC9FMDY+CgkJPEUwNyBkZXNjPSLmo4Dmn6XljLvpmaLlkI3np7AiPjwvRTA3PgoJCTxFMDggZGVzYz0i6YCB5qOA56eR5a6k57yW56CBIj5aWVlKMDEzPC9FMDg+CgkJPEUwOSBkZXNjPSLpgIHmo4Dnp5HlrqTlkI3np7AiPueXheeQhuenkTwvRTA5PgoJCTxFMTAgZGVzYz0i5Y+W5qC35pel5pyfIj4yMDIwLzIvMjcgMDowMDowMDwvRTEwPgoJCTxFMTEgZGVzYz0i5Y+W5qC35Yy755Sf57yW56CBIj4xNzcyPC9FMTE+CgkJPEUxMiBkZXNjPSLlj5bmoLfljLvnlJ/lkI3np7AiPuiRo+WHpOWljjwvRTEyPgoJCTxFMTMgZGVzYz0i5Y+W5p2Q6YOo5L2N5Luj56CBIj48L0UxMz4KCQk8RTE0IGRlc2M9IuWPluadkOmDqOS9jeWQjeensCI+PC9FMTQ+CgkJPEUxNSBkZXNjPSLpgIHmo4Dml6XmnJ8iPjIwMjAtMDItMjcgMTI6MDA6MDA8L0UxNT4KCQk8RTE2IGRlc2M9IumAgeajgOWMu+eUn+e8lueggSI+PC9FMTY+CgkJPEUxNyBkZXNjPSLpgIHmo4DljLvnlJ/lkI3np7AiPjwvRTE3PgoJCTxFMTggZGVzYz0i5oql5ZGK5pel5pyfIj4yMDIwLTAyLTI3IDExOjAwOjAwPC9FMTg+CgkJPEUxOSBkZXNjPSLkuLTluorooajnjrAiPuWKn+iDveaAp+WSs+WXvTwvRTE5PgoJCTxFMjAgZGVzYz0i5Li05bqK6K+K5patIj7lip/og73mgKflkrPll708L0UyMD4KCQk8RTIxIGRlc2M9IueXheeQhuWkp+S9k+aJgOingSI+5bCR6K646IKd57uE57uH77yM6IKd57uG6IOe5rWK6IK/44CB5rek6IOG77yM6IKd56qm5oul5oyk77yM5Y+v6KeB54K554G254q25Z2P5q2777yM5rGH566h5Yy65pWj5Zyo5reL5be057uG6IOe5rW45ram77yM5pyq6KeB5piO56Gu6IOG566h5o2f5Lyk44CCPC9FMjE+CgkJPEUyMiBkZXNjPSLnl4XnkIbor4rmlq0iPua0u+S9k+e7hOe7h+eXheeQhuiviuaWrTwvRTIyPgoJCTxFMjMgZGVzYz0i6KGl5YWF5oSP6KeBIj48L0UyMz4KCQk8RTI0IGRlc2M9IuaguOWvueWMu+W4iOe8lueggSI+YWRtaW48L0UyND4KCQk8RTI1IGRlc2M9IuaguOWvueWMu+W4iOWnk+WQjSI+YWRtaW48L0UyNT4KCQk8RTI2IGRlc2M9IuaKpeWRiuWMu+W4iOe8lueggSI+eWowMTwvRTI2PgoJCTxFMjcgZGVzYz0i5oql5ZGK5Yy75biI5aeT5ZCNIj7ljLvmioAwMSAgPC9FMjc+CgkJPEUyOCBkZXNjPSLlpIfms6giPjwvRTI4PgoJPC9zZWN0aW9uPgo8L3N0cnVjdHVyZWRCb2R5Pgo8L2NsaW5pY2FsRG9jdW1lbnQ+</DocumentContent> <DocumentPath></DocumentPath> <UpdateUserCode>RIS</UpdateUserCode> <UpdateDate>2020-02-18</UpdateDate> <UpdateTime>14:14:16</UpdateTime> </RegisterDocumentRt> </Body></Request>"
	;s input="<Request>    <Header>        <SourceSystem>SYS0004</SourceSystem>        <MessageID></MessageID>    </Header>    <Body>        <RegisterDocumentRt>            <BusinessFieldCode>00001</BusinessFieldCode>            <HospitalCode>DHSZHYYZY</HospitalCode>            <OrganizationCode>DHSZHYYZY</OrganizationCode>            <PATPatientID>0000000003</PATPatientID>            <PAADMVisitNumber>1</PAADMVisitNumber>            <RISRExamID>PIS2020021000006</RISRExamID>            <SpecimenID></SpecimenID>            <OEORIOrderItemID>2||179</OEORIOrderItemID>                    <DocumentType>02006</DocumentType>            <DocumentID>02006001</DocumentID> <DocumentContent>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPGNsaW5pY2FsRG9jdW1lbnQ+Cjxkb2N1bWVudEhlYWRlcj4KICAgIDxyZWFsbUNvZGU+PC9yZWFsbUNvZGU+IDwhLS3kvb/nlKjojIPlm7QtLT4gCgk8dHlwZUlkPjwvdHlwZUlkPiA8IS0t5paH5qGj57G75Z6LLS0+Cgk8dGVtcGxhdGUvPiA8IS0t5qih5p2/SUTlj4rniYjmnKzlj7ctLT4KICAgIDxpZD48L2lkPiAgPCEtLeaWh+aho+a1geawtOWPty0tPiAgICAgICAgICAKICAgIDx0aXRsZT7nl4XnkIbmo4Dmn6XmiqXlkYo8L3RpdGxlPgoJPGVmZmVjdGl2ZVRpbWU+MjAxOTExMTYwMDAwNzwvZWZmZWN0aXZlVGltZT4gPCEtLeaWh+aho+eUn+aIkOaXtumXtC0tPiAKCTxjb25maWRlbnRpYWxpdHkgY29kZT0i57qn5Yir5Luj56CBIiA+57qn5Yir5ZCN56ewPC9jb25maWRlbnRpYWxpdHk+ICA8IS0t5L+d5a+G57qn5YirLS0+Cgk8dmVyc2lvbk51bWJlcj48L3ZlcnNpb25OdW1iZXI+ICAgPCEtLeaWh+aho+eJiOacrOWPty0tPgoJPGF1dGhvciBpZD0i5Yy755Sf57yW5Y+3Ij5ZUzAxPC9hdXRob3I+CTwhLS3mlofmoaPliJvkvZzogIUtLT4KCTxjdXN0b2RpYW4+PC9jdXN0b2RpYW4+CTwhLS3kv53nrqHmnLrmnoQtLT4KCTxwYXRpZW50PgoJCTxtZWRpY2FyZU5vPjwvbWVkaWNhcmVObz4gIDwhLS3kvY/pmaLlj7ctLT4KCQk8YWRtdmlzaXRObz4xPC9hZG12aXNpdE5vPiAgPCEtLeWwseiviuWPty0tPgoJCTxtZWRSZWNvcmRObz48L21lZFJlY29yZE5vPiAgPCEtLeeXheahiOWPty0tPgoJCTxoZWFsdGhDYXJkTm8+PC9oZWFsdGhDYXJkTm8+ICA8IS0t5YGl5bq35Y2h5Y+3LS0+CgkJPGNlcnRpZmljYXRlPgoJCQk8bmFtZSBjb2RlPSLor4Hku7bnsbvlnovku6PnoIEiPui6q+S7veivgeWPtzwvbmFtZT4KCQkJPHZhbHVlPjQxMjcyNjE5OTEwNDE3Njk3NzwvdmFsdWU+CgkJPC9jZXJ0aWZpY2F0ZT4KCQk8YWRkciBkZXNjPSLnjrDkvY/lnYAiPgoJCQk8dGV4dD7pmZXopb/nnIHopb/lronluILkv6HlronlsI/ljLrlhavljZXlhYMyMDHlrqQ8L3RleHQ+CgkJCTxob3VzZU51bWJlcj4xNDjlj7fplb/lronlsI/ljLrkuInmoIvlhavljZXlhYM8L2hvdXNlTnVtYmVyPgoJCQk8c3RyZWV0TmFtZT7plb/lronljZfot688L3N0cmVldE5hbWU+CgkJCTx0b3duc2hpcD48L3Rvd25zaGlwPgoJCQk8Y291bnR5PumbgeWhlOWMujwvY291bnR5PgoJCQk8Y2l0eT7opb/lronluII8L2NpdHk+CgkJCTxzdGF0ZT7pmZXopb/nnIE8L3N0YXRlPgoJCQk8cG9zdGFsQ29kZT41MTAwMDA8L3Bvc3RhbENvZGU+CgkJPC9hZGRyPgoJCTxuYW1lPuS4geaZuumjnjwvbmFtZT4KCQk8dGVsZWNvbT4wMjAtODc4MTUxMDI8L3RlbGVjb20+CgkJPGFkbWluaXN0cmF0aXZlR2VuZGVyIGNvZGU9IjEiID7nlLfmgKc8L2FkbWluaXN0cmF0aXZlR2VuZGVyPgoJCTxtYXJpdGFsU3RhdHVzIGNvZGU9IjIwIj7lt7LlqZo8L21hcml0YWxTdGF0dXM+CgkJPGV0aG5pY0dyb3VwIGNvZGU9IjAxIj7msYnml488L2V0aG5pY0dyb3VwPgoJCTxhZ2UgdW5pdD0i5bKBIiB2YWx1ZT0iNjAiLz4KCTwvcGF0aWVudD4KCTxwYXJ0aWNpcGFudD4KCQk8Y29kZSBjb2RlPSIxIj7lrrbluq3lhbPns7vmj4/ov7A8L2NvZGU+CiAgICAgICAgPGFkZHIgZGVzYz0i6IGU57O75Lq65Zyw5Z2AIj4JCgkJCQk8dGV4dD7pmZXopb/nnIHopb/lronluILkv6HlronlsI/ljLrlhavljZXlhYMyMDHlrqQ8L3RleHQ+CgkJCQk8aG91c2VOdW1iZXI+MTQ45Y+3PC9ob3VzZU51bWJlcj4KCQkJCTxzdHJlZXROYW1lPueOieael+Wkp+mBkzwvc3RyZWV0TmFtZT4KCQkJCTx0b3duc2hpcD48L3Rvd25zaGlwPgoJCQkJPGNvdW50eT7pm4HloZTljLo8L2NvdW50eT4KCQkJCTxjaXR5Puilv+WuieW4gjwvY2l0eT4KCQkJCTxzdGF0ZT7pmZXopb/nnIE8L3N0YXRlPgoJCQkJPHBvc3RhbENvZGU+MDIzNjg8L3Bvc3RhbENvZGU+CgkJPC9hZGRyPgoJCTx0ZWxlY29tPjk5OS05OTktOTk5OTk5PC90ZWxlY29tPgoJCTxuYW1lPuS4geS8oOWPkTwvbmFtZT4KCTwvcGFydGljaXBhbnQ+CjwvZG9jdW1lbnRIZWFkZXI+CjxzdHJ1Y3R1cmVkQm9keT4KCTxFMDAwNCBkZXNjPSLlp5PlkI0iPuS4geaZuumjnjwvRTAwMDQ+Cgk8RTAwMDUgZGVzYz0i5oCn5Yir5Luj56CBIj4xPC9FMDAwNT4KCTxFMDAwNiBkZXNjPSLmgKfliKvmj4/ov7AiPueUtzwvRTAwMDY+Cgk8RTAwMDggZGVzYz0i5bm06b6EIj4yODwvRTAwMDg+Cgk8RTAwMDAgZGVzYz0i6Zeo6K+K5Y+3Ij48L0UwMDAwPgoJPEUwMDAxIGRlc2M9IueXheahiOWPtyI+PC9FMDAwMT4KCTxFMDAwMiBkZXNjPSLkvY/pmaLlj7ciPjwvRTAwMDI+Cgk8RTAwNDAgZGVzYz0i6IGU57O755S16K+dIj4xNTU5NTU3MzY0MDwvRTAwNDA+Cgk8RTAxNTQgZGVzYz0i55eF5bqKaWQiPjEwPC9FMDE1ND4KCTxFMDA3NSBkZXNjPSLnl4XluooiPuWNleS6uuW6ijwvRTAwNzU+Cgk8RTAxNTYgZGVzYz0i56eR5a6kaWQiPlpZWlkwMDM8L0UwMTU2PgoJPEUwMDc3IGRlc2M9IuenkeWupCI+5YaF5YiG5rOM56eRPC9FMDA3Nz4KCTxFMDE3OSBkZXNjPSLmmK/lkKbnu53nu48iPjwvRTAxNzk+Cgk8RTAxODAgZGVzYz0i5pyr5qyh5pyI57uP5pel5pyfIj48L0UwMTgwPgoJPHNlY3Rpb24gY29kZT0iUzAxNDEiIGRlc2M9IueXheeQhuajgOafpeiusOW9lSI+CgkJPHRleHQvPiAgPCEtLeeXheeQhuajgOafpeiusOW9leeahOivpue7huS/oeaBry0tPgoJCTxFMDEgZGVzYz0i55Sz6K+35Y+3Ij5QSVMyMDIwMDIxMDAwMDA2PC9FMDE+CgkJPEUwMiBkZXNjPSLnl4XnkIblj7ciPlBJUzIwMjAwMjEwMDAwMDY8L0UwMj4KCQk8RTAzIGRlc2M9IuWunumqjOWupOe8luWPtyI+PC9FMDM+CgkJPEUwNCBkZXNjPSLpgIHmo4DljLvpmaLnvJbnoIEiPjwvRTA0PgoJCTxFMDUgZGVzYz0i6YCB5qOA5Yy76Zmi5ZCN56ewIj48L0UwNT4KCQk8RTA2IGRlc2M9IuajgOafpeWMu+mZoue8lueggSI+PC9FMDY+CgkJPEUwNyBkZXNjPSLmo4Dmn6XljLvpmaLlkI3np7AiPjwvRTA3PgoJCTxFMDggZGVzYz0i6YCB5qOA56eR5a6k57yW56CBIj5aWVlKMDEzPC9FMDg+CgkJPEUwOSBkZXNjPSLpgIHmo4Dnp5HlrqTlkI3np7AiPueXheeQhuenkTwvRTA5PgoJCTxFMTAgZGVzYz0i5Y+W5qC35pel5pyfIj4yMDIwLTAyLTI3IDA6MDA6MDA8L0UxMD4KCQk8RTExIGRlc2M9IuWPluagt+WMu+eUn+e8lueggSI+MTc3MjwvRTExPgoJCTxFMTIgZGVzYz0i5Y+W5qC35Yy755Sf5ZCN56ewIj7okaPlh6TlpY48L0UxMj4KCQk8RTEzIGRlc2M9IuWPluadkOmDqOS9jeS7o+eggSI+QTwvRTEzPgoJCTxFMTQgZGVzYz0i5Y+W5p2Q6YOo5L2N5ZCN56ewIj7ogp08L0UxND4KCQk8RTE1IGRlc2M9IumAgeajgOaXpeacnyI+MjAyMC0wMi0yNyAxMDowMDowMDwvRTE1PgoJCTxFMTYgZGVzYz0i6YCB5qOA5Yy755Sf57yW56CBIj48L0UxNj4KCQk8RTE3IGRlc2M9IumAgeajgOWMu+eUn+WQjeensCI+PC9FMTc+CgkJPEUxOCBkZXNjPSLmiqXlkYrml6XmnJ8iPjIwMjAtMDItMjcgMTE6MDA6MDA8L0UxOD4KCQk8RTE5IGRlc2M9IuS4tOW6iuihqOeOsCI+5Yqf6IO95oCn5ZKz5Ze9PC9FMTk+CgkJPEUyMCBkZXNjPSLkuLTluoror4rmlq0iPuWKn+iDveaAp+WSs+WXvTwvRTIwPgoJCTxFMjEgZGVzYz0i55eF55CG5aSn5L2T5omA6KeBIj7lsJHorrjogp3nu4Tnu4fvvIzogp3nu4bog57mtYrogr/jgIHmt6Tog4bvvIzogp3nqqbmi6XmjKTvvIzlj6/op4HngrnngbbnirblnY/mrbvvvIzmsYfnrqHljLrmlaPlnKjmt4vlt7Tnu4bog57mtbjmtqbvvIzmnKrop4HmmI7noa7og4bnrqHmjZ/kvKTjgII8L0UyMT4KCQk8RTIyIGRlc2M9IueXheeQhuiviuaWrSI+5rS75L2T57uE57uH55eF55CG6K+K5patPC9FMjI+CgkJPEUyMyBkZXNjPSLooaXlhYXmhI/op4EiPjwvRTIzPgoJCTxFMjQgZGVzYz0i5qC45a+55Yy75biI57yW56CBIj5hZG1pbjwvRTI0PgoJCTxFMjUgZGVzYz0i5qC45a+55Yy75biI5aeT5ZCNIj5hZG1pbjwvRTI1PgoJCTxFMjYgZGVzYz0i5oql5ZGK5Yy75biI57yW56CBIj55ajAxPC9FMjY+CgkJPEUyNyBkZXNjPSLmiqXlkYrljLvluIjlp5PlkI0iPuWMu+aKgDAxICA8L0UyNz4KCQk8RTI4IGRlc2M9IuWkh+azqCI+PC9FMjg+Cgk8L3NlY3Rpb24+Cjwvc3RydWN0dXJlZEJvZHk+CjwvY2xpbmljYWxEb2N1bWVudD4=</DocumentContent>           <DocumentPath></DocumentPath>            <UpdateUserCode>RIS</UpdateUserCode>            <UpdateDate>2020-02-18</UpdateDate>            <UpdateTime>14:14:16</UpdateTime>     </RegisterDocumentRt>    </Body></Request>"
	;s input="<Request>    <Header>        <SourceSystem>SYS0002</SourceSystem>        <MessageID>MES0011</MessageID>    </Header>    <Body>        <RegisterDocumentRt><BusinessFieldCode>03</BusinessFieldCode>            <HospitalCode>DHSZHYYZY</HospitalCode>            <OrganizationCode>0001</OrganizationCode>            <PATPatientID>0000001008</PATPatientID><PATPatientName>任茹</PATPatientName>            <PAADMVisitNumber>1711</PAADMVisitNumber>            <RISRExamID></RISRExamID>            <SpecimenID>0000001466</SpecimenID>            <OEORIOrderItemID>1556||1</OEORIOrderItemID>                    <DocumentType>01001</DocumentType>            <DocumentID>000000100800001</DocumentID>            <DocumentContent> PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPGNsaW5pY2FsRG9jdW1lbnQ+Cjxkb2N1bWVudEhlYWRlcj4KICAgIDxyZWFsbUNvZGU+PC9yZWFsbUNvZGU+IDwhLS3kvb/nlKjojIPlm7QtLT4gCgk8dHlwZUlkPjAxMDAxPC90eXBlSWQ+IDwhLS3mlofmoaPnsbvlnostLT4KCTx0ZW1wbGF0ZS8+IDwhLS3mqKHmnb9JROWPiueJiOacrOWPty0tPgogICAgPGlkPjAwMDAwMDU2ODE8L2lkPiAgPCEtLeaWh+aho+a1geawtOWPty0tPiAgICAgICAgICAKICAgIDx0aXRsZT7mo4DpqozmiqXlkYo8L3RpdGxlPgoJPGVmZmVjdGl2ZVRpbWU+MjAxMjEwMjQxNTQ4MjM8L2VmZmVjdGl2ZVRpbWU+IDwhLS3mlofmoaPnlJ/miJDml7bpl7QtLT4gCgk8Y29uZmlkZW50aWFsaXR5IGNvZGU9Iue6p+WIq+S7o+eggSIgPue6p+WIq+WQjeensDwvY29uZmlkZW50aWFsaXR5PiAgPCEtLeS/neWvhue6p+WIqy0tPgoJPHZlcnNpb25OdW1iZXI+My4zPC92ZXJzaW9uTnVtYmVyPiAgIDwhLS3mlofmoaPniYjmnKzlj7ctLT4KCTxhdXRob3IgaWQ9IuWMu+eUn+e8luWPtyI+MDIwMzwvYXV0aG9yPgk8IS0t5paH5qGj5Yib5L2c6ICFLS0+Cgk8Y3VzdG9kaWFuPuacrOmZojwvY3VzdG9kaWFuPgk8IS0t5L+d566h5py65p6ELS0+Cgk8cGF0aWVudD4KCQk8bWVkaWNhcmVObz4wMDAwMDAxMDA4PC9tZWRpY2FyZU5vPiAgPCEtLeS9j+mZouWPty0tPgoJCTxhZG12aXNpdE5vPjE3MTE8L2FkbXZpc2l0Tm8+ICA8IS0t5bCx6K+K5Y+3LS0+CgkJPG1lZFJlY29yZE5vPjEwMDE2NzwvbWVkUmVjb3JkTm8+ICA8IS0t55eF5qGI5Y+3LS0+CgkJPGhlYWx0aENhcmRObz48L2hlYWx0aENhcmRObz4gIDwhLS3lgaXlurfljaHlj7ctLT4KCQk8Y2VydGlmaWNhdGU+CgkJCTxuYW1lIGNvZGU9IuivgeS7tuexu+Wei+S7o+eggSI+6Lqr5Lu96K+BPC9uYW1lPgoJCQk8dmFsdWU+PC92YWx1ZT4KCQk8L2NlcnRpZmljYXRlPgoJCTxhZGRyIGRlc2M9IueOsOS9j+WdgCI+CgkJCTx0ZXh0PuWxseS4nOecgea1juWNl+W4guankOiNq+WMuuaWsOS5oemVh+e7j+S6lOi3r+eOieWxseWNjuW6reWwj+WMujLlj7fmpbwx5Y2V5YWDMDkwMzwvdGV4dD4KCQkJPGhvdXNlTnVtYmVyPueOieWxseWNjuW6reWwj+WMujLlj7fmpbwx5Y2V5YWDMDkwMzwvaG91c2VOdW1iZXI+CgkJCTxzdHJlZXROYW1lPue7j+S6lOi3rzwvc3RyZWV0TmFtZT4KCQkJPHRvd25zaGlwPuaWsOS5oemVhzwvdG93bnNoaXA+CgkJCTxjb3VudHk+5qeQ6I2r5Yy6PC9jb3VudHk+CgkJCTxjaXR5Pua1juWNl+W4gjwvY2l0eT4KCQkJPHN0YXRlPuWxseS4nOecgTwvc3RhdGU+CgkJCTxwb3N0YWxDb2RlPjI1MDAwMDwvcG9zdGFsQ29kZT4KCQk8L2FkZHI+CgkJPG5hbWU+5Lu76Iy5PC9uYW1lPgoJCTx0ZWxlY29tPjEzMTA4MDkxMjM0PC90ZWxlY29tPgoJCTxhZG1pbmlzdHJhdGl2ZUdlbmRlciBjb2RlPSIwIiA+5aWz5oCnPC9hZG1pbmlzdHJhdGl2ZUdlbmRlcj4KCQk8bWFyaXRhbFN0YXR1cyBjb2RlPSIyMCI+5bey5amaPC9tYXJpdGFsU3RhdHVzPgoJCTxldGhuaWNHcm91cCBjb2RlPSIwMSI+5rGJ5pePPC9ldGhuaWNHcm91cD4KCQk8YWdlIHVuaXQ9IuWygSIgdmFsdWU9IjI3Ii8+Cgk8L3BhdGllbnQ+Cgk8cGFydGljaXBhbnQ+CgkJPGNvZGUgY29kZT0iMSI+54i25aWzPC9jb2RlPgogICAgICAgIDxhZGRyIGRlc2M9IuiBlOezu+S6uuWcsOWdgCI+CQoJCQkJPHRleHQ+5bGx5Lic55yB5rWO5Y2X5biC5qeQ6I2r5Yy65paw5Lmh6ZWH57uP5LqU6Lev546J5bGx5Y2O5bqt5bCP5Yy6MuWPt+alvDHljZXlhYMwOTAzPC90ZXh0PgoJCQk8aG91c2VOdW1iZXI+546J5bGx5Y2O5bqt5bCP5Yy6MuWPt+alvDHljZXlhYMwOTAzPC9ob3VzZU51bWJlcj4KCQkJPHN0cmVldE5hbWU+57uP5LqU6LevPC9zdHJlZXROYW1lPgoJCQk8dG93bnNoaXA+5paw5Lmh6ZWHPC90b3duc2hpcD4KCQkJPGNvdW50eT7mp5DojavljLo8L2NvdW50eT4KCQkJPGNpdHk+5rWO5Y2X5biCPC9jaXR5PgoJCQk8c3RhdGU+5bGx5Lic55yBPC9zdGF0ZT4KCQkJPHBvc3RhbENvZGU+MjUwMDAwPC9wb3N0YWxDb2RlPgoJCTwvYWRkcj4KCQk8dGVsZWNvbT4xMzA5ODE1MDc4MjwvdGVsZWNvbT4KCQk8bmFtZT7ku7vlpKnpobY8L25hbWU+Cgk8L3BhcnRpY2lwYW50Pgo8L2RvY3VtZW50SGVhZGVyPgo8c3RydWN0dXJlZEJvZHk+Cgk8RTAwMDQgZGVzYz0i5aeT5ZCNIj7ku7vojLk8L0UwMDA0PgoJPEUwMDAwIGRlc2M9IumXqOiviuWPtyI+PC9FMDAwMD4KCTxFMDAwMiBkZXNjPSLkvY/pmaLlj7ciPjAwMDAwMDEwMDg8L0UwMDAyPgoJPEUwMTQ4IGRlc2M9IueXheS6uuexu+Wei+S7o+eggSI+STwvRTAxNDg+Cgk8RTAxNDkgZGVzYz0i55eF5Lq657G75Z6L5ZCN56ewIj7kvY/pmaI8L0UwMTQ5PgoJPEUwMTUwIGRlc2M9Iui0ueWIq+S7o+eggSI+MDc8L0UwMTUwPgoJPEUwMTUxIGRlc2M9Iui0ueWIq+WQjeensCI+5YWo6Ieq6LS5PC9FMDE1MT4KCTxFMDAwNSBkZXNjPSLmgKfliKvku6PnoIEiPjA8L0UwMDA1PgoJPEUwMDA2IGRlc2M9IuaAp+WIq+aPj+i/sCI+5aWzPC9FMDAwNj4KCTxFMDA3NyBkZXNjPSLnp5HlrqQiPuWGheWIhuazjOenkTwvRTAwNzc+Cgk8RTAwMDggZGVzYz0i5bm06b6EIj4yNzwvRTAwMDg+Cgk8RTAwNzUgZGVzYz0i55eF5bqKIj7lhoXliIbms4znp5HmiqTnkIbljZXlhYM8L0UwMDc1PgoJPHNlY3Rpb24gY29kZT0iUzAwNDgiIGRlc2M9IuiviuaWrSI+CgkJPHRleHQvPiAgPCEtLeiviuaWreeahOivpue7huS/oeaBry0tPgoJCTxFMDcgZGVzYz0i5Yy755Sf5aGr5YaZ55qE6K+K5patIj7kubPohbrogr/nmKQ8L0UwNz4KCQk8RTAxIGRlc2M9IuiviuaWreWQjeensCI+5Lmz6IW66IK/55ikPC9FMDE+CgkJPEUwMiBkZXNjPSLor4rmlq3ku6PnoIEiPkQ0OC42MDE8L0UwMj4KCTwvc2VjdGlvbj4KCTxzZWN0aW9uIGNvZGU9IlMwMDYxIiBkZXNjPSLmo4DpqozorrDlvZUiPgoJCTx0ZXh0Lz4gIDwhLS3mo4DpqozorrDlvZXnmoTor6bnu4bkv6Hmga8tLT4KCQk8RTAxIGRlc2M9IuajgOmqjOmhueebruS7o+eggSI+SllMMDAwMTwvRTAxPgoJCTxFMDIgZGVzYz0i5qOA6aqM6aG555uu5ZCN56ewIj7ooYDluLjop4Q8L0UwMj4KCQk8RTAzIGRlc2M9IumAgeajgOaXpeacnyI+MjAyMC0wMy0wMjwvRTAzPgoJCTxFMDQgZGVzYz0i6YCB5qOA5pe26Ze0Ij4xNTozMDwvRTA0PgoJCTxFMDUgZGVzYz0i5qCH5pys57G75Z6L5Luj56CBIj5TUDAwMTwvRTA1PgoJCTxFMDYgZGVzYz0i5qCH5pys57G75Z6L5ZCN56ewIj7lhajooYA8L0UwNj4KCQk8RTA3IGRlc2M9Iuagh+acrOWPtyI+MDAwMDAwMTQ2NjwvRTA3PgoJCTxFMDggZGVzYz0i5qOA6aqM5aSH5rOoIj48L0UwOD4KCQk8RTA5IGRlc2M9IumAgeajgOWMu+eUn+S7o+eggSI+MDIwMzwvRTA5PgoJCTxFMTAgZGVzYz0i6YCB5qOA5Yy755Sf5aeT5ZCNIj7lrZ/njonnp4A8L0UxMD4KCQk8RTExIGRlc2M9IuajgOmqjOaXpeacnyI+MjAyMC0wMy0wMjwvRTExPgoJCTxFMTIgZGVzYz0i5qOA6aqM5pe26Ze0Ij4xMDowMDwvRTEyPgoJCTxFMTMgZGVzYz0i5qOA6aqM6ICF5Luj56CBIj5saXMwMTwvRTEzPgoJCTxFMTQgZGVzYz0i5qOA6aqM6ICF5aeT5ZCNIj7mo4DpqoznrqHnkIblkZg8L0UxND4KCQk8RTE1IGRlc2M9IuaKpeWRiuaXpeacnyI+MjAyMC0wMy0wMzwvRTE1PgoJCTxFMTYgZGVzYz0i5oql5ZGK5pe26Ze0Ij4xMTowMDwvRTE2PgoJCTxFMTcgZGVzYz0i5a6h5qC45oql5ZGK5pel5pyfIj4yMDIwLTAzLTAzPC9FMTc+CgkJPEUxOCBkZXNjPSLlrqHmoLjmiqXlkYrml7bpl7QiPjExOjAwPC9FMTg+CgkJPEUxOSBkZXNjPSLlrqHmoLjogIXku6PnoIEiPmxpczAxPC9FMTk+CgkJPEUyMCBkZXNjPSLlrqHmoLjogIXlp5PlkI0iPuajgOmqjOeuoeeQhuWRmDwvRTIwPgoJCTxFMjEgZGVzYz0i5oql5ZGK5aSH5rOoIj48L0UyMT4KCQk8RTIyIGRlc2M9IuajgOmqjOebrueahCI+PC9FMjI+CgkJPEUyMyBkZXNjPSLmo4Dpqoznu5PmnpwiPjwvRTIzPgoJCTxFMjQgZGVzYz0i5oql5ZGK5Y+3Ij48L0UyND4KCQk8RTI1IGRlc2M9IuWMu+WYseWPtyI+MTU1Nnx8MTwvRTI1PgoJCTxFMjYgZGVzYz0i5oql5ZGK56eR5a6k5Luj56CBIj5aWVlKMDE1PC9FMjY+CgkJPEUyNyBkZXNjPSLmiqXlkYrnp5HlrqTlkI3np7AiPuS4tOajgOWupDwvRTI3PgoJCTxzZWN0aW9uIGNvZGU9IlMwMDYyIiBkZXNjPSLmo4DpqozlrZDpobnnu5PmnpwiPgoJCQk8dGV4dC8+ICA8IS0t5qOA6aqM5a2Q6aG557uT5p6c55qE6K+m57uG5L+h5oGvLS0+CgkJCTxFMDEgZGVzYz0i5qOA6aqM5a2Q6aG55Luj56CBIj5MMDA1NTwvRTAxPgoJCQk8RTAyIGRlc2M9IuajgOmqjOWtkOmhueWQjeensCI+57qi57uG6IOePC9FMDI+CgkJCTxFMDMgZGVzYz0i5qOA6aqM5a2Q6aG557uT5p6c77yI5a6a6YeP77yJIj4yNTwvRTAzPgoJCQk8RTA0IGRlc2M9IuajgOmqjOWtkOmhuee7k+aenOWNleS9jSI+KjEwXjEyL0w8L0UwND4KCQkJPEUwNSBkZXNjPSLmo4DpqozlrZDpobnnu5PmnpzvvIjlrprmgKfvvIzpmLQv6Ziz77yJIj48L0UwNT4KCQkJPEUwNiBkZXNjPSLmo4DpqozlrZDpobnlj4LogIPlgLzojIPlm7QiPjIwLTMwPC9FMDY+CgkJCTxFMDcgZGVzYz0i5qOA6aqM5a2Q6aG55byC5bi45qCH5b+XIj48L0UwNz4KCQkJPEUwOCBkZXNjPSLmo4Dpqozorr7lpIfnvJbnoIEiPlN5c21leC1LWDIxPC9FMDg+CgkJCTxFMDkgZGVzYz0i5qOA6aqM6K6+5aSH5ZCN56ewIj5TeXNtZXgtS1gyMTwvRTA5PgoJCTwvc2VjdGlvbj4KCQk8c2VjdGlvbiBjb2RlPSJTMDE1NyIgZGVzYz0i5Zu+5YOP5L+h5oGvIj4KCQkJPHRleHQ+5Zu+5YOP5L+h5oGv55qE6K+m57uG5o+P6L+wPC90ZXh0PgoJCQk8RTAxIGRlc2M9IuWbvuWDj+WQjeensCI+PC9FMDE+CgkJCTxFMDIgZGVzYz0i5Zu+5YOP5YaF5a65Ij48L0UwMj4KCQk8L3NlY3Rpb24+Cgk8L3NlY3Rpb24+Cjwvc3RydWN0dXJlZEJvZHk+CjwvY2xpbmljYWxEb2N1bWVudD4=</DocumentContent>            <DocumentPath> http://192.168.1.122/weblink/0000001008/IP0000000203-1.html</DocumentPath>            <UpdateUserCode>lis01</UpdateUserCode>            <UpdateDate>2020-03-02</UpdateDate>            <UpdateTime>11:20</UpdateTime>        </RegisterDocumentRt>    </Body></Request>"
	;s input="<Request>    <Header>        <SourceSystem>SYS0002</SourceSystem>        <MessageID>MES0011</MessageID>    </Header>    <Body>        <RegisterDocumentRt><BusinessFieldCode>00001</BusinessFieldCode>            <HospitalCode>DHSZHYYZY</HospitalCode>            <OrganizationCode>0001</OrganizationCode>            <PATPatientID>0000001026</PATPatientID><PATPatientName>jhm3021</PATPatientName>            <PAADMVisitNumber>1738</PAADMVisitNumber>            <RISRExamID></RISRExamID>            <SpecimenID>0000001578</SpecimenID>            <OEORIOrderItemID>1584||23</OEORIOrderItemID>                     <DocumentType>01002</DocumentType>            <DocumentID>LIS0000001026IP206zyt</DocumentID>            <DocumentContent>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPGNsaW5pY2FsRG9jdW1lbnQ+Cjxkb2N1bWVudEhlYWRlcj4KICAgIDxyZWFsbUNvZGU+MDE8L3JlYWxtQ29kZT4gPCEtLeS9v+eUqOiMg+WbtC0tPiAKCTx0eXBlSWQ+MDEwMDI8L3R5cGVJZD4gPCEtLeaWh+aho+exu+Weiy0tPgoJPHRlbXBsYXRlLz4gPCEtLeaooeadv0lE5Y+K54mI5pys5Y+3LS0+CiAgICA8aWQ+MDAwMDAwNTY4MjwvaWQ+ICA8IS0t5paH5qGj5rWB5rC05Y+3LS0+ICAgICAgCiAgICA8dGl0bGU+5b6u55Sf54mp5qOA6aqM5oql5ZGKPC90aXRsZT4gICAgCgk8ZWZmZWN0aXZlVGltZT4yMDIwMDMwNDEwMTAyMzwvZWZmZWN0aXZlVGltZT4gPCEtLeaWh+aho+eUn+aIkOaXtumXtC0tPiAKCTxjb25maWRlbnRpYWxpdHkgY29kZT0i57qn5Yir5Luj56CBIiA+MDwvY29uZmlkZW50aWFsaXR5PiAgPCEtLeS/neWvhue6p+WIqy0tPgoJPHZlcnNpb25OdW1iZXI+MS4wPC92ZXJzaW9uTnVtYmVyPiAgIDwhLS3mlofmoaPniYjmnKzlj7ctLT4KCTxhdXRob3IgaWQ9IuWMu+eUn+e8luWPtyI+5qOA6aqM566h55CG5ZGYPC9hdXRob3I+CTwhLS3mlofmoaPliJvkvZzogIUtLT4KCTxjdXN0b2RpYW4+5Lic5Y2O5pWw5a2X5YyW5Yy76ZmiPC9jdXN0b2RpYW4+CTwhLS3kv53nrqHmnLrmnoQtLT4KCTxwYXRpZW50PgoJCTxtZWRpY2FyZU5vPjAwMDAwMDEwMjY8L21lZGljYXJlTm8+ICA8IS0t5L2P6Zmi5Y+3LS0+CgkJPGFkbXZpc2l0Tm8+MTczODwvYWRtdmlzaXRObz4gIDwhLS3lsLHor4rlj7ctLT4KCQk8bWVkUmVjb3JkTm8+MTAwMTcwPC9tZWRSZWNvcmRObz4gIDwhLS3nl4XmoYjlj7ctLT4KCQk8aGVhbHRoQ2FyZE5vPjwvaGVhbHRoQ2FyZE5vPiAgPCEtLeWBpeW6t+WNoeWPty0tPgoJCTxjZXJ0aWZpY2F0ZT4KCQkJPG5hbWUgY29kZT0i6K+B5Lu257G75Z6L5Luj56CBIj7lsYXmsJHmiLflj6PnsL88L25hbWU+CgkJCTx2YWx1ZT4wMDEwMDkyODgyMzwvdmFsdWU+CgkJPC9jZXJ0aWZpY2F0ZT4KCQk8YWRkciBkZXNjPSLnjrDkvY/lnYAiPgoJCQk8dGV4dD7lsbHkuJznnIHmtY7ljZfluILmp5DojavljLrmlrDkuaHplYfnuqzkuIPot6/mgZLlpKfpm4Xoi5HlsI/ljLo25Y+35qW8MuWNleWFgzAxMDI8L3RleHQ+CgkJCTxob3VzZU51bWJlcj7mgZLlpKfpm4Xoi5HlsI/ljLo25Y+35qW8MuWNleWFgzAxMDI8L2hvdXNlTnVtYmVyPgoJCQk8c3RyZWV0TmFtZT7nuqzkuIPot688L3N0cmVldE5hbWU+CgkJCTx0b3duc2hpcD7mlrDkuaHplYc8L3Rvd25zaGlwPgoJCQk8Y291bnR5PuankOiNq+WMujwvY291bnR5PgoJCQk8Y2l0eT7mtY7ljZfluII8L2NpdHk+CgkJCTxzdGF0ZT7lsbHkuJznnIE8L3N0YXRlPgoJCQk8cG9zdGFsQ29kZT4yNTAwMDA8L3Bvc3RhbENvZGU+CgkJPC9hZGRyPgoJCTxuYW1lPmpobTMwMjE8L25hbWU+CgkJPHRlbGVjb20+MDUzMS04NzgxNTEwMjwvdGVsZWNvbT4KCQk8YWRtaW5pc3RyYXRpdmVHZW5kZXIgY29kZT0iMSIgPueUt+aApzwvYWRtaW5pc3RyYXRpdmVHZW5kZXI+CgkJPG1hcml0YWxTdGF0dXMgY29kZT0iMjAiPuW3suWpmjwvbWFyaXRhbFN0YXR1cz4KCQk8ZXRobmljR3JvdXAgY29kZT0iMDEiPuaxieaXjzwvZXRobmljR3JvdXA+CgkJPGFnZSB1bml0PSLlsoEiIHZhbHVlPSI1NiIvPgoJPC9wYXRpZW50PgoJPHBhcnRpY2lwYW50PgoJCTxjb2RlIGNvZGU9IjEiPueItuWtkDwvY29kZT4KICAgICAgICA8YWRkciBkZXNjPSLogZTns7vkurrlnLDlnYAiPgkKCQkJPHRleHQ+5bGx5Lic55yB5rWO5Y2X5biC5qeQ6I2r5Yy65paw5Lmh6ZWH57qs5LiD6Lev5oGS5aSn6ZuF6IuR5bCP5Yy6NuWPt+alvDLljZXlhYMwMTAyPC90ZXh0PgoJCQk8aG91c2VOdW1iZXI+5oGS5aSn6ZuF6IuR5bCP5Yy6NuWPt+alvDLljZXlhYMwMTAyPC9ob3VzZU51bWJlcj4KCQkJPHN0cmVldE5hbWU+57qs5LiD6LevPC9zdHJlZXROYW1lPgoJCQk8dG93bnNoaXA+5paw5Lmh6ZWHPC90b3duc2hpcD4KCQkJPGNvdW50eT7mp5DojavljLo8L2NvdW50eT4KCQkJPGNpdHk+5rWO5Y2X5biCPC9jaXR5PgoJCQk8c3RhdGU+5bGx5Lic55yBPC9zdGF0ZT4KCQkJPHBvc3RhbENvZGU+MjUwMDAwPC9wb3N0YWxDb2RlPgoJCTwvYWRkcj4KCQk8dGVsZWNvbT4xMzgwNjQ4MDkyODwvdGVsZWNvbT4KCQk8bmFtZT7ljaLlub/po548L25hbWU+Cgk8L3BhcnRpY2lwYW50Pgo8L2RvY3VtZW50SGVhZGVyPgo8c3RydWN0dXJlZEJvZHk+Cgk8RTAwMDQgZGVzYz0i5aeT5ZCNIj5qaG0zMDIxPC9FMDAwND4KCTxFMDAwMCBkZXNjPSLpl6jor4rlj7ciPjwvRTAwMDA+Cgk8RTAwMDIgZGVzYz0i5L2P6Zmi5Y+3Ij4wMDAwMDAxMDI2PC9FMDAwMj4KCTxFMDE0OCBkZXNjPSLnl4Xkurrnsbvlnovku6PnoIEiPkk8L0UwMTQ4PgoJPEUwMTQ5IGRlc2M9IueXheS6uuexu+Wei+WQjeensCI+5L2P6ZmiPC9FMDE0OT4KCTxFMDE1MCBkZXNjPSLotLnliKvku6PnoIEiPjA2PC9FMDE1MD4KCTxFMDE1MSBkZXNjPSLotLnliKvlkI3np7AiPuWFqOWFrOi0uTwvRTAxNTE+Cgk8RTAwMDUgZGVzYz0i5oCn5Yir5Luj56CBIj4xPC9FMDAwNT4KCTxFMDAwNiBkZXNjPSLmgKfliKvmj4/ov7AiPueUtzwvRTAwMDY+Cgk8RTAxNTYgZGVzYz0i56eR5a6kaWQiPjk1PC9FMDE1Nj4KCTxFMDA3NyBkZXNjPSLnp5HlrqQiPuWGheWIhuazjOenkTwvRTAwNzc+Cgk8RTAwMDggZGVzYz0i5bm06b6EIj41NjwvRTAwMDg+Cgk8RTAxNTQgZGVzYz0i55eF5bqKaWQiPjEyPC9FMDE1ND4KCTxFMDA3NSBkZXNjPSLnl4XluooiPjEyPC9FMDA3NT4KCTxzZWN0aW9uIGNvZGU9IlMwMDQ4IiBkZXNjPSLor4rmlq0iPgoJCTx0ZXh0Lz4gIDwhLS3or4rmlq3nmoTor6bnu4bkv6Hmga8tLT4KCQk8RTA3IGRlc2M9IuWMu+eUn+Whq+WGmeeahOiviuaWrSI+5Y2B5LqM5oyH6IKg55iYPC9FMDc+CgkJPEUwMSBkZXNjPSLor4rmlq3lkI3np7AiPuWNgeS6jOaMh+iCoOeYmDwvRTAxPgoJCTxFMDIgZGVzYz0i6K+K5pat5Luj56CBIj5LMzEuNjA0PC9FMDI+Cgk8L3NlY3Rpb24+Cgk8c2VjdGlvbiBjb2RlPSJTMDA2MSIgZGVzYz0i5qOA6aqM6K6w5b2VIj4KCQk8dGV4dC8+ICA8IS0t5qOA6aqM6K6w5b2V55qE6K+m57uG5L+h5oGvLS0+CgkJPEUwMSBkZXNjPSLmo4Dpqozpobnnm67ku6PnoIEiPkpZVzAwMDc8L0UwMT4KCQk8RTAyIGRlc2M9IuajgOmqjOmhueebruWQjeensCI+5pSv5Y6f5L2TPC9FMDI+CgkJPEUwMyBkZXNjPSLpgIHmo4Dml6XmnJ8iPjIwMjAtMDMtMDQ8L0UwMz4KCQk8RTA0IGRlc2M9IumAgeajgOaXtumXtCI+MTA6MDA8L0UwND4KCQk8RTA1IGRlc2M9Iuagh+acrOexu+Wei+S7o+eggSI+U1AwMTQ8L0UwNT4KCQk8RTA2IGRlc2M9Iuagh+acrOexu+Wei+WQjeensCI+5qOJ5out5a2QPC9FMDY+CgkJPEUwNyBkZXNjPSLmoIfmnKzlj7ciPjAwMDAwMDE1Nzg8L0UwNz4JCQoJCTxFMDggZGVzYz0i5qOA6aqM5aSH5rOoIj7ml6A8L0UwOD4KCQk8RTA5IGRlc2M9IumAgeajgOWMu+eUn+S7o+eggSI+MDIwMzwvRTA5PgoJCTxFMTAgZGVzYz0i6YCB5qOA5Yy755Sf5aeT5ZCNIj7lrZ/njonnp4A8L0UxMD4KCQk8RTExIGRlc2M9IuajgOmqjOaXpeacnyI+MjAyMC0wMy0wNDwvRTExPgoJCTxFMTIgZGVzYz0i5qOA6aqM5pe26Ze0Ij4wOTo1MDwvRTEyPgoJCTxFMTMgZGVzYz0i5qOA6aqM6ICF5Luj56CBIj5saXMwMTwvRTEzPgoJCTxFMTQgZGVzYz0i5qOA6aqM6ICF5aeT5ZCNIj7mo4DpqoznrqHnkIblkZg8L0UxND4KCQk8RTE1IGRlc2M9IuaKpeWRiuaXpeacnyI+MjAyMC0wMy0wNDwvRTE1PgoJCTxFMTYgZGVzYz0i5oql5ZGK5pe26Ze0Ij4xMDoxMDwvRTE2PgoJCTxFMTcgZGVzYz0i5a6h5qC45oql5ZGK5pel5pyfIj4yMDIwLTAzLTA0PC9FMTc+CgkJPEUxOCBkZXNjPSLlrqHmoLjmiqXlkYrml7bpl7QiPjEwOjA5PC9FMTg+CgkJPEUxOSBkZXNjPSLlrqHmoLjogIXku6PnoIEiPmxpczAxPC9FMTk+CgkJPEUyMCBkZXNjPSLlrqHmoLjogIXlp5PlkI0iPuajgOmqjOeuoeeQhuWRmDwvRTIwPgoJCTxFMjEgZGVzYz0i5oql5ZGK5aSH5rOoIj7ml6A8L0UyMT4KCQk8RTIyIGRlc2M9IuajgOmqjOebrueahCI+56Gu6K+K55eF5ZugPC9FMjI+CgkJPEUyMyBkZXNjPSLpibTlrprnu5PmnpwiPuingemcieiPjOWtouWtkDwvRTIzPgoJCTxFMjQgZGVzYz0i5oql5ZGK5Y+3Ij4wMDAwOTgwMTI1PC9FMjQ+CgkJPEUyNSBkZXNjPSLljLvlmLHlj7ciPjE1ODR8fDIzPC9FMjU+CgkJPEUyNiBkZXNjPSLmiqXlkYrnp5HlrqTku6PnoIEiPlpZWUowMjA8L0UyNj4KCQk8RTI3IGRlc2M9IuaKpeWRiuenkeWupOWQjeensCI+5b6u55Sf54mp5a6e6aqM5a6kPC9FMjc+CgkJPHNlY3Rpb24gY29kZT0iUzAwNjMiIGRlc2M9IuW+rueUn+eJqeWfueWFu+eUn+aIkOe7huiPjOS/oeaBryI+CgkJCTx0ZXh0Lz4gIDwhLS3lvq7nlJ/nianln7nlhbvnlJ/miJDnu4boj4zkv6Hmga/nmoTor6bnu4bkv6Hmga8tLT4KCQkJPEUwMSBkZXNjPSLnu4boj4zku6PnoIEiPjE0NDY8L0UwMT4KCQkJPEUwMiBkZXNjPSLnu4boj4zlkI3np7AiPuWPo+iFlOiho+WOn+S9kzwvRTAyPgoJCQk8RTAzIGRlc2M9Iue7huiPjOiuoeaVsCI+MzQ8L0UwMz4KCQkJPEUwNCBkZXNjPSLkuJPlrrbop4TliJkiPuWvueS4h+WPpOmciee0oOaVj+aEn+aAp+WHj+S9jueahOmHkem7hOiJsuiRoeiQhOeQg+iPjOeahOS4tOW6iuaEj+S5ieacquefpeOAgumAgeajgOS7u+S9lU1JQz49NCBtY2cvbUznmoToj4zmoKrliLDlj4Lmr5Tlrp7pqozlrqTjgILpgJrnn6XkuLTluorlkozmhJ/mjqfljLvnlJ/jgILlr7nnvZXop4HnmoTnu5Pmnpzov5vooYznoa7orqTjgII8L0UwND4KCQkJPEUwNSBkZXNjPSLlpIfms6giPuingemcieiPjOWtouWtkDwvRTA1PgoJCQk8c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj4KCQkJCTx0ZXh0Lz4gIDwhLS3nu4boj4znmoToja/mlY/kv6Hmga/nmoTor6bnu4bkv6Hmga8tLT4KCQkJCTxFMDEgZGVzYz0i5oqX55Sf57Sg5Luj56CBIj5BWk0xNTwvRTAxPgoJCQkJPEUwMiBkZXNjPSLmipfnlJ/ntKDlkI3np7AiPumYv+Wlh+mciee0oDwvRTAyPgoJCQkJPEUwMyBkZXNjPSLmnIDkvY7mipHoj4zmtZPluqYiPjMwdWc8L0UwMz4KCQkJCTxFMDQgZGVzYz0i6I2v5pWP57uT5p6c5Luj56CBIj4xPC9FMDQ+CgkJCQk8RTA1IGRlc2M9IuiNr+aVj+e7k+aenOaPj+i/sCI+6Ziz5oCnPC9FMDU+CgkJCQk8RTA2IGRlc2M9IuW7uuiuriI+55So6I2vPC9FMDY+CgkJCQk8RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyI+MTwvRTA3PgoJCQkJPEUwOCBkZXNjPSJJ5oqY54K56IyD5Zu0Ij4xMC0yMDwvRTA4PgoJCQkJPEUwOSBkZXNjPSJT5oqY54K56IyD5Zu0Ij4yMC0zMDwvRTA5PgoJCQkJPEUxMCBkZXNjPSJS5oqY54K56IyD5Zu0Ij4zMC00MDwvRTEwPgoJCQkJPEUxMSBkZXNjPSLor5Xpqozmlrnms5UiPuivleWJguebkuWfueWFuzwvRTExPgoJCQk8L3NlY3Rpb24+CgkJCTxzZWN0aW9uIGNvZGU9IlMwMDY0IiBkZXNjPSLnu4boj4znmoToja/mlY/kv6Hmga8iPgoJCQkJPHRleHQvPiAgPCEtLee7huiPjOeahOiNr+aVj+S/oeaBr+eahOivpue7huS/oeaBry0tPgoJCQkJPEUwMSBkZXNjPSLmipfnlJ/ntKDku6PnoIEiPktBTjMwPC9FMDE+CgkJCQk8RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+5Y2h6YKj6ZyJ57SgPC9FMDI+CgkJCQk8RTAzIGRlc2M9IuacgOS9juaKkeiPjOa1k+W6piI+MzB1ZzwvRTAzPgoJCQkJPEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiPjE8L0UwND4KCQkJCTxFMDUgZGVzYz0i6I2v5pWP57uT5p6c5o+P6L+wIj7pmLPmgKc8L0UwNT4KCQkJCTxFMDYgZGVzYz0i5bu66K6uIj7nlKjoja88L0UwNj4KCQkJCTxFMDcgZGVzYz0i6I2v5pWP57uT5p6c5qCH5b+XIj4xPC9FMDc+CgkJCQk8RTA4IGRlc2M9IknmipjngrnojIPlm7QiPjAtNTwvRTA4PgoJCQkJPEUwOSBkZXNjPSJT5oqY54K56IyD5Zu0Ij41LTc8L0UwOT4KCQkJCTxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCI+Ny05PC9FMTA+CgkJCQk8RTExIGRlc2M9IuivlemqjOaWueazlSI+6K+V5YmC55uS5Z+55YW7PC9FMTE+CgkJCTwvc2VjdGlvbj4KCQk8L3NlY3Rpb24+CgkJCQk8c2VjdGlvbiBjb2RlPSJTMDA2MyIgZGVzYz0i5b6u55Sf54mp5Z+55YW755Sf5oiQ57uG6I+M5L+h5oGvIj4KCQkJPHRleHQvPiAgPCEtLeW+rueUn+eJqeWfueWFu+eUn+aIkOe7huiPjOS/oeaBr+eahOivpue7huS/oeaBry0tPgoJCQk8RTAxIGRlc2M9Iue7huiPjOS7o+eggSI+MTQ0MTwvRTAxPgoJCQk8RTAyIGRlc2M9Iue7huiPjOWQjeensCI+5ZK95ZaJ5pSv5Y6f5L2TPC9FMDI+CgkJCTxFMDMgZGVzYz0i57uG6I+M6K6h5pWwIj4yNTwvRTAzPgoJCQk8RTA0IGRlc2M9IuS4k+WutuinhOWImSI+5a+55LiH5Y+k6ZyJ57Sg5pWP5oSf5oCn5YeP5L2O55qE6YeR6buE6Imy6JGh6JCE55CD6I+M55qE5Li05bqK5oSP5LmJ5pyq55+l44CC6YCB5qOA5Lu75L2VTUlDPj00IG1jZy9tTOeahOiPjOagquWIsOWPguavlOWunumqjOWupOOAgumAmuefpeS4tOW6iuWSjOaEn+aOp+WMu+eUn+OAguWvuee9leingeeahOe7k+aenOi/m+ihjOehruiupOOAgjwvRTA0PgoJCQk8RTA1IGRlc2M9IuWkh+azqCI+5pegPC9FMDU+CgkJCTxzZWN0aW9uIGNvZGU9IlMwMDY0IiBkZXNjPSLnu4boj4znmoToja/mlY/kv6Hmga8iPgoJCQkJPHRleHQvPiAgPCEtLee7huiPjOeahOiNr+aVj+S/oeaBr+eahOivpue7huS/oeaBry0tPgoJCQkJPEUwMSBkZXNjPSLmipfnlJ/ntKDku6PnoIEiPkxFWDMwPC9FMDE+CgkJCQk8RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+5aS05a2i5rCo6IuEPC9FMDI+CgkJCQk8RTAzIGRlc2M9IuacgOS9juaKkeiPjOa1k+W6piI+MzV1ZzwvRTAzPgoJCQkJPEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiPjA8L0UwND4KCQkJCTxFMDUgZGVzYz0i6I2v5pWP57uT5p6c5o+P6L+wIj7pmLTmgKc8L0UwNT4KCQkJCTxFMDYgZGVzYz0i5bu66K6uIj7kuI3nlKjoja88L0UwNj4KCQkJCTxFMDcgZGVzYz0i6I2v5pWP57uT5p6c5qCH5b+XIj4wPC9FMDc+CgkJCQk8RTA4IGRlc2M9IknmipjngrnojIPlm7QiPjItOTwvRTA4PgoJCQkJPEUwOSBkZXNjPSJT5oqY54K56IyD5Zu0Ij4zLTEwPC9FMDk+CgkJCQk8RTEwIGRlc2M9IlLmipjngrnojIPlm7QiPjMtMTM8L0UxMD4KCQkJCTxFMTEgZGVzYz0i6K+V6aqM5pa55rOVIj7ln7nlhbvms5U8L0UxMT4KCQkJPC9zZWN0aW9uPgoJCTwvc2VjdGlvbj4KCTwvc2VjdGlvbj4KPC9zdHJ1Y3R1cmVkQm9keT4KPC9jbGluaWNhbERvY3VtZW50Pg==</DocumentContent>            <DocumentPath> http://192.168.1.122/weblink/0000001026/ IP0000000206.html </DocumentPath>            <UpdateUserCode>lis01</UpdateUserCode>            <UpdateDate>2020-03-04</UpdateDate>            <UpdateTime>10:10</UpdateTime>        </RegisterDocumentRt>    </Body></Request>"
	s input="<Request><Header><SourceSystem>LIS</SourceSystem><MessageID>677DFAB6-8023-11EC-8587-005056BD8313</MessageID></Header><Body><RegisterDocumentRt><BusinessFieldCode>00001</BusinessFieldCode><HospitalCode>DHSZHYYZY</HospitalCode><OrganizationCode>0001</OrganizationCode><PATPatientID>0000000032</PATPatientID><PATPatientName>柿子分库</PATPatientName><PAADMVisitNumber>56</PAADMVisitNumber><RISRExamID></RISRExamID><SpecimenID>0000000705</SpecimenID><OEORIOrderItemID>47||48</OEORIOrderItemID><DocumentType>01002</DocumentType><DocumentID>172</DocumentID><DocumentContent>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48Y2xpbmljYWxEb2N1bWVudD48ZG9jdW1lbnRIZWFkZXI+PHJlYWxtQ29kZT48L3JlYWxtQ29kZT48dHlwZUlkPjwvdHlwZUlkPjx0ZW1wbGF0ZT48L3RlbXBsYXRlPjxpZD48L2lkPjx0aXRsZT7lvq7nlJ/nianmiqXlkYo8L3RpdGxlPjxlZmZlY3RpdmVUaW1lPjIwMjIwMTI4MTgxNjQ5PC9lZmZlY3RpdmVUaW1lPjxjb25maWRlbnRpYWxpdHkgY29kZT0i57qn5Yir5Luj56CBIiA+PC9jb25maWRlbnRpYWxpdHk+PHZlcnNpb25OdW1iZXI+PC92ZXJzaW9uTnVtYmVyPjxhdXRob3IgaWQ9Ik1JQzAxIj7lvq7nlJ/niannrqHnkIblkZg8L2F1dGhvcj48Y3VzdG9kaWFuPjwvY3VzdG9kaWFuPjxwYXRpZW50PjxtZWRpY2FyZU5vPjIwMDAxMTwvbWVkaWNhcmVObz48YWRtdmlzaXRObz41NjwvYWRtdmlzaXRObz48bWVkUmVjb3JkTm8+MjAwMDExPC9tZWRSZWNvcmRObz48aGVhbHRoQ2FyZE5vPjwvaGVhbHRoQ2FyZE5vPjxjZXJ0aWZpY2F0ZT48bmFtZSBjb2RlPSIiPjwvbmFtZT48dmFsdWU+PC92YWx1ZT48L2NlcnRpZmljYXRlPjxhZGRyIGRlc2M9IueOsOS9j+WdgCI+PHRleHQ+PC90ZXh0Pjxob3VzZU51bWJlcj48L2hvdXNlTnVtYmVyPjxzdHJlZXROYW1lPjwvc3RyZWV0TmFtZT48dG93bnNoaXA+PC90b3duc2hpcD48Y291bnR5PjwvY291bnR5PjxjaXR5PjwvY2l0eT48c3RhdGU+PC9zdGF0ZT48cG9zdGFsQ29kZT48L3Bvc3RhbENvZGU+PC9hZGRyPjxuYW1lPuafv+WtkOWIhuW6kzwvbmFtZT48dGVsZWNvbT4xNTUyMjI0NTY3ODwvdGVsZWNvbT48YWRtaW5pc3RyYXRpdmVHZW5kZXIgY29kZT0iMCI+5aWzPC9hZG1pbmlzdHJhdGl2ZUdlbmRlcj48bWFyaXRhbFN0YXR1cyBjb2RlPSIiPjwvbWFyaXRhbFN0YXR1cz48ZXRobmljR3JvdXAgY29kZT0iIj48L2V0aG5pY0dyb3VwPjxhZ2UgdW5pdD0i5bKBIiB2YWx1ZT0iMjEiLz48L3BhdGllbnQ+PHBhcnRpY2lwYW50Pjxjb2RlIGNvZGU9IiI+PC9jb2RlPjxhZGRyIGRlc2M9IuiBlOezu+S6uuWcsOWdgCI+PHRleHQ+PC90ZXh0Pjxob3VzZU51bWJlcj48L2hvdXNlTnVtYmVyPjxzdHJlZXROYW1lPjwvc3RyZWV0TmFtZT48dG93bnNoaXA+PC90b3duc2hpcD48Y291bnR5PjwvY291bnR5PjxjaXR5PjwvY2l0eT48c3RhdGU+PC9zdGF0ZT48cG9zdGFsQ29kZT48L3Bvc3RhbENvZGU+PC9hZGRyPjx0ZWxlY29tPjwvdGVsZWNvbT48bmFtZT48L25hbWU+PC9wYXJ0aWNpcGFudD48L2RvY3VtZW50SGVhZGVyPjxzdHJ1Y3R1cmVkQm9keT48RTAwMDQgZGVzYz0i5aeT5ZCNIj7mn7/lrZDliIblupM8L0UwMDA0PjxFMDAwMCBkZXNjPSLpl6jor4rlj7ciPjU2PC9FMDAwMD48RTAwMDIgZGVzYz0i5L2P6Zmi5Y+3Ij4yMDAwMTE8L0UwMDAyPjxFMDE0OCBkZXNjPSLnl4Xkurrnsbvlnovku6PnoIEiPkk8L0UwMTQ4PjxFMDE0OSBkZXNjPSLnl4XkurrnsbvlnovlkI3np7AiPuS9j+mZojwvRTAxNDk+PEUwMTUwIGRlc2M9Iui0ueWIq+S7o+eggSI+PC9FMDE1MD48RTAxNTEgZGVzYz0i6LS55Yir5ZCN56ewIj48L0UwMTUxPjxFMDAwNSBkZXNjPSLmgKfliKvku6PnoIEiPjA8L0UwMDA1PjxFMDAwNiBkZXNjPSLmgKfliKvmj4/ov7AiPuWlszwvRTAwMDY+PEUwMDc3IGRlc2M9IuenkeWupCI+5YaF5YiG5rOM56eRPC9FMDA3Nz48RTAwMDggZGVzYz0i5bm06b6EIj4yMeWygTwvRTAwMDg+PEUwMDc1IGRlc2M9IueXheW6iiI+MTA8L0UwMDc1PjxzZWN0aW9uIGNvZGU9IlMwMDQ4IiBkZXNjPSLor4rmlq0iPjx0ZXh0Lz48RTA3IGRlc2M9IuWMu+eUn+Whq+WGmeeahOiviuaWrSI+5YGH5oCn6auY6KGA5Y6LLOWxgOmZkOaAp+aymemXqOiPjOaEn+afkzwvRTA3PjxFMDEgZGVzYz0i6K+K5pat5ZCN56ewIj7lgYfmgKfpq5jooYDljos8L0UwMT48RTAyIGRlc2M9IuiviuaWreS7o+eggSI+WDEyNDM2PC9FMDI+PC9zZWN0aW9uPjxzZWN0aW9uIGNvZGU9IlMwMDQ4IiBkZXNjPSLor4rmlq0iPjx0ZXh0Lz48RTA3IGRlc2M9IuWMu+eUn+Whq+WGmeeahOiviuaWrSI+5YGH5oCn6auY6KGA5Y6LLOWxgOmZkOaAp+aymemXqOiPjOaEn+afkzwvRTA3PjxFMDEgZGVzYz0i6K+K5pat5ZCN56ewIj7lsYDpmZDmgKfmspnpl6joj4zmhJ/mn5M8L0UwMT48RTAyIGRlc2M9IuiviuaWreS7o+eggSI+WDAwMDQ5PC9FMDI+PC9zZWN0aW9uPjxzZWN0aW9uIGNvZGU9IlMwMDYxIiBkZXNjPSLmo4DpqozorrDlvZUiPjx0ZXh0Lz48RTAxIGRlc2M9IuajgOmqjOmhueebruS7o+eggSI+VzAwMTI8L0UwMT48RTAyIGRlc2M9IuajgOmqjOmhueebruWQjeensCI+55ew5Z+55YW76I2v5pWPPC9FMDI+PEUwMyBkZXNjPSLpgIHmo4Dml6XmnJ8iPjIwMjItMDEtMjg8L0UwMz48RTA0IGRlc2M9IumAgeajgOaXtumXtCI+MTg6MTU6NTY8L0UwND48RTA1IGRlc2M9Iuagh+acrOexu+Wei+S7o+eggSI+U1AwMDk8L0UwNT48RTA2IGRlc2M9Iuagh+acrOexu+Wei+WQjeensCI+55ewPC9FMDY+PEUwNyBkZXNjPSLmoIfmnKzlj7ciPjAwMDAwMDA3MDU8L0UwNz48RTA4IGRlc2M9IuajgOmqjOWkh+azqCI+PC9FMDg+PEUwOSBkZXNjPSLpgIHmo4DljLvnlJ/ku6PnoIEiPjEyMDA8L0UwOT48RTEwIGRlc2M9IumAgeajgOWMu+eUn+Wnk+WQjSI+546L5YWx5YabPC9FMTA+PEUxMSBkZXNjPSLmo4Dpqozml6XmnJ8iPjIwMjItMDEtMjg8L0UxMT48RTEyIGRlc2M9IuajgOmqjOaXtumXtCI+MTg6MTY6NDg8L0UxMj48RTEzIGRlc2M9IuajgOmqjOiAheS7o+eggSI+TUlDMDE8L0UxMz48RTE0IGRlc2M9IuajgOmqjOiAheWnk+WQjSI+5b6u55Sf54mp566h55CG5ZGYPC9FMTQ+PEUxNSBkZXNjPSLmiqXlkYrml6XmnJ8iPjIwMjItMDEtMjg8L0UxNT48RTE2IGRlc2M9IuaKpeWRiuaXtumXtCI+MTg6MTY6NDg8L0UxNj48RTE3IGRlc2M9IuWuoeaguOaKpeWRiuaXpeacnyI+MjAyMi0wMS0yODwvRTE3PjxFMTggZGVzYz0i5a6h5qC45oql5ZGK5pe26Ze0Ij4xODoxNjo0ODwvRTE4PjxFMTkgZGVzYz0i5a6h5qC46ICF5Luj56CBIj5NSUMwMTwvRTE5PjxFMjAgZGVzYz0i5a6h5qC46ICF5aeT5ZCNIj7lvq7nlJ/niannrqHnkIblkZg8L0UyMD48RTIxIGRlc2M9IuaKpeWRiuWkh+azqCI+PC9FMjE+PEUyMiBkZXNjPSLmo4Dpqoznm67nmoQiPjwvRTIyPjxFMjMgZGVzYz0i5qOA6aqM57uT5p6cIj48L0UyMz48RTI0IGRlc2M9IuaKpeWRiuWPtyI+MDAwMDAwMDcwNXx8MTcyPC9FMjQ+PEUyNSBkZXNjPSLljLvlmLHlj7ciPjQ3fHw0ODwvRTI1PjxFMjYgZGVzYz0i5oql5ZGK56eR5a6k5Luj56CBIj5XPC9FMjY+PEUyNyBkZXNjPSLmiqXlkYrnp5HlrqTlkI3np7AiPuW+rueUn+eJqeWupDwvRTI3PjxzZWN0aW9uIGNvZGU9IlMwMDYzIiBkZXNjPSLlvq7nlJ/nianln7nlhbvnlJ/miJDnu4boj4zkv6Hmga8iPjx0ZXh0Lz48RTAxIGRlc2M9Iue7huiPjOS7o+eggSI+MTczMzwvRTAxPjxFMDIgZGVzYz0i57uG6I+M5ZCN56ewIj7pk5znu7/lgYfljZXog57oj4w8L0UwMj48RTAzIGRlc2M9Iue7huiPjOiuoeaVsCI+PC9FMDM+PEUwNCBkZXNjPSLkuJPlrrbop4TliJkiPjwvRTA0PjxFMDUgZGVzYz0i5aSH5rOoIj48L0UwNT48RTA2IGRlc2M9Iue7huiPjOiAkOiNr+aAp+agh+W/lyI+PC9FMDY+PHNlY3Rpb24gY29kZT0iUzAwNjQiIGRlc2M9Iue7huiPjOeahOiNr+aVj+S/oeaBryI+PHRleHQvPjxFMDEgZGVzYz0i5oqX55Sf57Sg5Luj56CBIj5BTUszMDwvRTAxPjxFMDIgZGVzYz0i5oqX55Sf57Sg5ZCN56ewIj7pmL/nsbPljaHmmJ88L0UwMj48RTAzIGRlc2M9IuacgOS9juaKkeiPjOa1k+W6piI+PC9FMDM+PEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiPjwvRTA0PjxFMDUgZGVzYz0i6I2v5pWP57uT5p6c5o+P6L+wIj48L0UwNT48RTA2IGRlc2M9IuW7uuiuriI+PC9FMDY+PEUwNyBkZXNjPSLoja/mlY/nu5PmnpzmoIflv5ciPjwvRTA3PjxFMDggZGVzYz0iSeaKmOeCueiMg+WbtCI+MzI8L0UwOD48RTA5IGRlc2M9IlPmipjngrnojIPlm7QiPiZsdDs9MTY8L0UwOT48RTEwIGRlc2M9IlLmipjngrnojIPlm7QiPiZndDs9NjQ8L0UxMD48RTExIGRlc2M9IuivlemqjOaWueazlSI+TUlDPC9FMTE+PC9zZWN0aW9uPjxzZWN0aW9uIGNvZGU9IlMwMDY0IiBkZXNjPSLnu4boj4znmoToja/mlY/kv6Hmga8iPjx0ZXh0Lz48RTAxIGRlc2M9IuaKl+eUn+e0oOS7o+eggSI+QVRNMzA8L0UwMT48RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+5rCo5puy5Y2XPC9FMDI+PEUwMyBkZXNjPSLmnIDkvY7mipHoj4zmtZPluqYiPjE8L0UwMz48RTA0IGRlc2M9IuiNr+aVj+e7k+aenOS7o+eggSI+UzwvRTA0PjxFMDUgZGVzYz0i6I2v5pWP57uT5p6c5o+P6L+wIj7mlY/mhJ88L0UwNT48RTA2IGRlc2M9IuW7uuiuriI+PC9FMDY+PEUwNyBkZXNjPSLoja/mlY/nu5PmnpzmoIflv5ciPjwvRTA3PjxFMDggZGVzYz0iSeaKmOeCueiMg+WbtCI+MTY8L0UwOD48RTA5IGRlc2M9IlPmipjngrnojIPlm7QiPiZsdDs9ODwvRTA5PjxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCI+Jmd0Oz0zMjwvRTEwPjxFMTEgZGVzYz0i6K+V6aqM5pa55rOVIj5NSUM8L0UxMT48L3NlY3Rpb24+PHNlY3Rpb24gY29kZT0iUzAwNjQiIGRlc2M9Iue7huiPjOeahOiNr+aVj+S/oeaBryI+PHRleHQvPjxFMDEgZGVzYz0i5oqX55Sf57Sg5Luj56CBIj5DQVozMDwvRTAxPjxFMDIgZGVzYz0i5oqX55Sf57Sg5ZCN56ewIj7lpLTlraLku5bllbY8L0UwMj48RTAzIGRlc2M9IuacgOS9juaKkeiPjOa1k+W6piI+MTwvRTAzPjxFMDQgZGVzYz0i6I2v5pWP57uT5p6c5Luj56CBIj5TPC9FMDQ+PEUwNSBkZXNjPSLoja/mlY/nu5Pmnpzmj4/ov7AiPuaVj+aEnzwvRTA1PjxFMDYgZGVzYz0i5bu66K6uIj48L0UwNj48RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyI+PC9FMDc+PEUwOCBkZXNjPSJJ5oqY54K56IyD5Zu0Ij4xNjwvRTA4PjxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCI+Jmx0Oz04PC9FMDk+PEUxMCBkZXNjPSJS5oqY54K56IyD5Zu0Ij4mZ3Q7PTMyPC9FMTA+PEUxMSBkZXNjPSLor5Xpqozmlrnms5UiPk1JQzwvRTExPjwvc2VjdGlvbj48c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj48dGV4dC8+PEUwMSBkZXNjPSLmipfnlJ/ntKDku6PnoIEiPkNPTDEwPC9FMDE+PEUwMiBkZXNjPSLmipfnlJ/ntKDlkI3np7AiPueymOiPjOe0oDwvRTAyPjxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj48L0UwMz48RTA0IGRlc2M9IuiNr+aVj+e7k+aenOS7o+eggSI+PC9FMDQ+PEUwNSBkZXNjPSLoja/mlY/nu5Pmnpzmj4/ov7AiPjwvRTA1PjxFMDYgZGVzYz0i5bu66K6uIj48L0UwNj48RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyI+PC9FMDc+PEUwOCBkZXNjPSJJ5oqY54K56IyD5Zu0Ij48L0UwOD48RTA5IGRlc2M9IlPmipjngrnojIPlm7QiPiZsdDs9MjwvRTA5PjxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCI+Jmd0Oz00PC9FMTA+PEUxMSBkZXNjPSLor5Xpqozmlrnms5UiPk1JQzwvRTExPjwvc2VjdGlvbj48c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj48dGV4dC8+PEUwMSBkZXNjPSLmipfnlJ/ntKDku6PnoIEiPkNTTDMwPC9FMDE+PEUwMiBkZXNjPSLmipfnlJ/ntKDlkI3np7AiPuWktOWtouWTjOmFri/oiJLlt7TlnaY8L0UwMj48RTAzIGRlc2M9IuacgOS9juaKkeiPjOa1k+W6piI+PC9FMDM+PEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiPjwvRTA0PjxFMDUgZGVzYz0i6I2v5pWP57uT5p6c5o+P6L+wIj48L0UwNT48RTA2IGRlc2M9IuW7uuiuriI+PC9FMDY+PEUwNyBkZXNjPSLoja/mlY/nu5PmnpzmoIflv5ciPjwvRTA3PjxFMDggZGVzYz0iSeaKmOeCueiMg+WbtCI+MzI8L0UwOD48RTA5IGRlc2M9IlPmipjngrnojIPlm7QiPiZsdDs9MTY8L0UwOT48RTEwIGRlc2M9IlLmipjngrnojIPlm7QiPiZndDs9NjQ8L0UxMD48RTExIGRlc2M9IuivlemqjOaWueazlSI+TUlDPC9FMTE+PC9zZWN0aW9uPjxzZWN0aW9uIGNvZGU9IlMwMDY0IiBkZXNjPSLnu4boj4znmoToja/mlY/kv6Hmga8iPjx0ZXh0Lz48RTAxIGRlc2M9IuaKl+eUn+e0oOS7o+eggSI+Q1pUMzA8L0UwMT48RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+Q2VmdG9sb3phbmUvVGF6b2JhY3RhbTwvRTAyPjxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj4xPC9FMDM+PEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiPlM8L0UwND48RTA1IGRlc2M9IuiNr+aVj+e7k+aenOaPj+i/sCI+5pWP5oSfPC9FMDU+PEUwNiBkZXNjPSLlu7rorq4iPjwvRTA2PjxFMDcgZGVzYz0i6I2v5pWP57uT5p6c5qCH5b+XIj48L0UwNz48RTA4IGRlc2M9IknmipjngrnojIPlm7QiPjgvNDwvRTA4PjxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCI+Jmx0Oz00LzQ8L0UwOT48RTEwIGRlc2M9IlLmipjngrnojIPlm7QiPiZndDs9MTYvNDwvRTEwPjxFMTEgZGVzYz0i6K+V6aqM5pa55rOVIj5NSUM8L0UxMT48L3NlY3Rpb24+PHNlY3Rpb24gY29kZT0iUzAwNjQiIGRlc2M9Iue7huiPjOeahOiNr+aVj+S/oeaBryI+PHRleHQvPjxFMDEgZGVzYz0i5oqX55Sf57Sg5Luj56CBIj5ET1IxMDwvRTAxPjxFMDIgZGVzYz0i5oqX55Sf57Sg5ZCN56ewIj7lpJrnq4vln7nljZc8L0UwMj48RTAzIGRlc2M9IuacgOS9juaKkeiPjOa1k+W6piI+MTwvRTAzPjxFMDQgZGVzYz0i6I2v5pWP57uT5p6c5Luj56CBIj5TPC9FMDQ+PEUwNSBkZXNjPSLoja/mlY/nu5Pmnpzmj4/ov7AiPuaVj+aEnzwvRTA1PjxFMDYgZGVzYz0i5bu66K6uIj48L0UwNj48RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyI+PC9FMDc+PEUwOCBkZXNjPSJJ5oqY54K56IyD5Zu0Ij40PC9FMDg+PEUwOSBkZXNjPSJT5oqY54K56IyD5Zu0Ij4mbHQ7PTI8L0UwOT48RTEwIGRlc2M9IlLmipjngrnojIPlm7QiPiZndDs9ODwvRTEwPjxFMTEgZGVzYz0i6K+V6aqM5pa55rOVIj5NSUM8L0UxMT48L3NlY3Rpb24+PHNlY3Rpb24gY29kZT0iUzAwNjQiIGRlc2M9Iue7huiPjOeahOiNr+aVj+S/oeaBryI+PHRleHQvPjxFMDEgZGVzYz0i5oqX55Sf57Sg5Luj56CBIj5GRVAzMDwvRTAxPjxFMDIgZGVzYz0i5oqX55Sf57Sg5ZCN56ewIj7lpLTlraLlkKHogp88L0UwMj48RTAzIGRlc2M9IuacgOS9juaKkeiPjOa1k+W6piI+MTwvRTAzPjxFMDQgZGVzYz0i6I2v5pWP57uT5p6c5Luj56CBIj5TPC9FMDQ+PEUwNSBkZXNjPSLoja/mlY/nu5Pmnpzmj4/ov7AiPuaVj+aEnzwvRTA1PjxFMDYgZGVzYz0i5bu66K6uIj48L0UwNj48RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyI+PC9FMDc+PEUwOCBkZXNjPSJJ5oqY54K56IyD5Zu0Ij4xNjwvRTA4PjxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCI+Jmx0Oz04PC9FMDk+PEUxMCBkZXNjPSJS5oqY54K56IyD5Zu0Ij4mZ3Q7PTMyPC9FMTA+PEUxMSBkZXNjPSLor5Xpqozmlrnms5UiPk1JQzwvRTExPjwvc2VjdGlvbj48c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj48dGV4dC8+PEUwMSBkZXNjPSLmipfnlJ/ntKDku6PnoIEiPkdBVDU8L0UwMT48RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+5Yqg5pu/5rKZ5pifPC9FMDI+PEUwMyBkZXNjPSLmnIDkvY7mipHoj4zmtZPluqYiPjwvRTAzPjxFMDQgZGVzYz0i6I2v5pWP57uT5p6c5Luj56CBIj48L0UwND48RTA1IGRlc2M9IuiNr+aVj+e7k+aenOaPj+i/sCI+PC9FMDU+PEUwNiBkZXNjPSLlu7rorq4iPjwvRTA2PjxFMDcgZGVzYz0i6I2v5pWP57uT5p6c5qCH5b+XIj48L0UwNz48RTA4IGRlc2M9IknmipjngrnojIPlm7QiPjQ8L0UwOD48RTA5IGRlc2M9IlPmipjngrnojIPlm7QiPiZsdDs9MjwvRTA5PjxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCI+Jmd0Oz04PC9FMTA+PEUxMSBkZXNjPSLor5Xpqozmlrnms5UiPk1JQzwvRTExPjwvc2VjdGlvbj48c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj48dGV4dC8+PEUwMSBkZXNjPSLmipfnlJ/ntKDku6PnoIEiPkdFTjEwPC9FMDE+PEUwMiBkZXNjPSLmipfnlJ/ntKDlkI3np7AiPuW6huWkp+mciee0oDwvRTAyPjxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj48L0UwMz48RTA0IGRlc2M9IuiNr+aVj+e7k+aenOS7o+eggSI+PC9FMDQ+PEUwNSBkZXNjPSLoja/mlY/nu5Pmnpzmj4/ov7AiPjwvRTA1PjxFMDYgZGVzYz0i5bu66K6uIj48L0UwNj48RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyI+PC9FMDc+PEUwOCBkZXNjPSJJ5oqY54K56IyD5Zu0Ij44PC9FMDg+PEUwOSBkZXNjPSJT5oqY54K56IyD5Zu0Ij4mbHQ7PTQ8L0UwOT48RTEwIGRlc2M9IlLmipjngrnojIPlm7QiPiZndDs9MTY8L0UxMD48RTExIGRlc2M9IuivlemqjOaWueazlSI+TUlDPC9FMTE+PC9zZWN0aW9uPjxzZWN0aW9uIGNvZGU9IlMwMDY0IiBkZXNjPSLnu4boj4znmoToja/mlY/kv6Hmga8iPjx0ZXh0Lz48RTAxIGRlc2M9IuaKl+eUn+e0oOS7o+eggSI+SVBNMTA8L0UwMT48RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+5Lqa6IO65Z+55Y2XPC9FMDI+PEUwMyBkZXNjPSLmnIDkvY7mipHoj4zmtZPluqYiPjE8L0UwMz48RTA0IGRlc2M9IuiNr+aVj+e7k+aenOS7o+eggSI+PC9FMDQ+PEUwNSBkZXNjPSLoja/mlY/nu5Pmnpzmj4/ov7AiPjwvRTA1PjxFMDYgZGVzYz0i5bu66K6uIj48L0UwNj48RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyI+PC9FMDc+PEUwOCBkZXNjPSJJ5oqY54K56IyD5Zu0Ij40PC9FMDg+PEUwOSBkZXNjPSJT5oqY54K56IyD5Zu0Ij4mbHQ7PTI8L0UwOT48RTEwIGRlc2M9IlLmipjngrnojIPlm7QiPiZndDs9ODwvRTEwPjxFMTEgZGVzYz0i6K+V6aqM5pa55rOVIj5NSUM8L0UxMT48L3NlY3Rpb24+PHNlY3Rpb24gY29kZT0iUzAwNjQiIGRlc2M9Iue7huiPjOeahOiNr+aVj+S/oeaBryI+PHRleHQvPjxFMDEgZGVzYz0i5oqX55Sf57Sg5Luj56CBIj5MT00xMDwvRTAxPjxFMDIgZGVzYz0i5oqX55Sf57Sg5ZCN56ewIj7mtJvnvo7mspnmmJ88L0UwMj48RTAzIGRlc2M9IuacgOS9juaKkeiPjOa1k+W6piI+PC9FMDM+PEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiPjwvRTA0PjxFMDUgZGVzYz0i6I2v5pWP57uT5p6c5o+P6L+wIj48L0UwNT48RTA2IGRlc2M9IuW7uuiuriI+PC9FMDY+PEUwNyBkZXNjPSLoja/mlY/nu5PmnpzmoIflv5ciPjwvRTA3PjxFMDggZGVzYz0iSeaKmOeCueiMg+WbtCI+NDwvRTA4PjxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCI+Jmx0Oz0yPC9FMDk+PEUxMCBkZXNjPSJS5oqY54K56IyD5Zu0Ij4mZ3Q7PTg8L0UxMD48RTExIGRlc2M9IuivlemqjOaWueazlSI+TUlDPC9FMTE+PC9zZWN0aW9uPjxzZWN0aW9uIGNvZGU9IlMwMDY0IiBkZXNjPSLnu4boj4znmoToja/mlY/kv6Hmga8iPjx0ZXh0Lz48RTAxIGRlc2M9IuaKl+eUn+e0oOS7o+eggSI+TFZYNTwvRTAxPjxFMDIgZGVzYz0i5oqX55Sf57Sg5ZCN56ewIj7lt6bml4vmsKfmsJ/mspnmmJ88L0UwMj48RTAzIGRlc2M9IuacgOS9juaKkeiPjOa1k+W6piI+PC9FMDM+PEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiPjwvRTA0PjxFMDUgZGVzYz0i6I2v5pWP57uT5p6c5o+P6L+wIj48L0UwNT48RTA2IGRlc2M9IuW7uuiuriI+PC9FMDY+PEUwNyBkZXNjPSLoja/mlY/nu5PmnpzmoIflv5ciPjwvRTA3PjxFMDggZGVzYz0iSeaKmOeCueiMg+WbtCI+MjwvRTA4PjxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCI+Jmx0Oz0xPC9FMDk+PEUxMCBkZXNjPSJS5oqY54K56IyD5Zu0Ij4mZ3Q7PTQ8L0UxMD48RTExIGRlc2M9IuivlemqjOaWueazlSI+TUlDPC9FMTE+PC9zZWN0aW9uPjxzZWN0aW9uIGNvZGU9IlMwMDY0IiBkZXNjPSLnu4boj4znmoToja/mlY/kv6Hmga8iPjx0ZXh0Lz48RTAxIGRlc2M9IuaKl+eUn+e0oOS7o+eggSI+TUVNMTA8L0UwMT48RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+576O5rSb5Z+55Y2XPC9FMDI+PEUwMyBkZXNjPSLmnIDkvY7mipHoj4zmtZPluqYiPjwvRTAzPjxFMDQgZGVzYz0i6I2v5pWP57uT5p6c5Luj56CBIj48L0UwND48RTA1IGRlc2M9IuiNr+aVj+e7k+aenOaPj+i/sCI+PC9FMDU+PEUwNiBkZXNjPSLlu7rorq4iPjwvRTA2PjxFMDcgZGVzYz0i6I2v5pWP57uT5p6c5qCH5b+XIj48L0UwNz48RTA4IGRlc2M9IknmipjngrnojIPlm7QiPjQ8L0UwOD48RTA5IGRlc2M9IlPmipjngrnojIPlm7QiPiZsdDs9MjwvRTA5PjxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCI+Jmd0Oz04PC9FMTA+PEUxMSBkZXNjPSLor5Xpqozmlrnms5UiPk1JQzwvRTExPjwvc2VjdGlvbj48c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj48dGV4dC8+PEUwMSBkZXNjPSLmipfnlJ/ntKDku6PnoIEiPk5FVDMwPC9FMDE+PEUwMiBkZXNjPSLmipfnlJ/ntKDlkI3np7AiPuWliOabv+exs+aYnzwvRTAyPjxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj48L0UwMz48RTA0IGRlc2M9IuiNr+aVj+e7k+aenOS7o+eggSI+PC9FMDQ+PEUwNSBkZXNjPSLoja/mlY/nu5Pmnpzmj4/ov7AiPjwvRTA1PjxFMDYgZGVzYz0i5bu66K6uIj48L0UwNj48RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyI+PC9FMDc+PEUwOCBkZXNjPSJJ5oqY54K56IyD5Zu0Ij4xNjwvRTA4PjxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCI+Jmx0Oz04PC9FMDk+PEUxMCBkZXNjPSJS5oqY54K56IyD5Zu0Ij4mZ3Q7PTMyPC9FMTA+PEUxMSBkZXNjPSLor5Xpqozmlrnms5UiPk1JQzwvRTExPjwvc2VjdGlvbj48c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj48dGV4dC8+PEUwMSBkZXNjPSLmipfnlJ/ntKDku6PnoIEiPk5PUjEwPC9FMDE+PEUwMiBkZXNjPSLmipfnlJ/ntKDlkI3np7AiPuivuuawn+aymeaYnzwvRTAyPjxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj48L0UwMz48RTA0IGRlc2M9IuiNr+aVj+e7k+aenOS7o+eggSI+PC9FMDQ+PEUwNSBkZXNjPSLoja/mlY/nu5Pmnpzmj4/ov7AiPjwvRTA1PjxFMDYgZGVzYz0i5bu66K6uIj48L0UwNj48RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyI+PC9FMDc+PEUwOCBkZXNjPSJJ5oqY54K56IyD5Zu0Ij44PC9FMDg+PEUwOSBkZXNjPSJT5oqY54K56IyD5Zu0Ij4mbHQ7PTQ8L0UwOT48RTEwIGRlc2M9IlLmipjngrnojIPlm7QiPiZndDs9MTY8L0UxMD48RTExIGRlc2M9IuivlemqjOaWueazlSI+TUlDPC9FMTE+PC9zZWN0aW9uPjxzZWN0aW9uIGNvZGU9IlMwMDY0IiBkZXNjPSLnu4boj4znmoToja/mlY/kv6Hmga8iPjx0ZXh0Lz48RTAxIGRlc2M9IuaKl+eUn+e0oOS7o+eggSI+T0ZYNTwvRTAxPjxFMDIgZGVzYz0i5oqX55Sf57Sg5ZCN56ewIj7msKfmsJ/mspnmmJ88L0UwMj48RTAzIGRlc2M9IuacgOS9juaKkeiPjOa1k+W6piI+PC9FMDM+PEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiPjwvRTA0PjxFMDUgZGVzYz0i6I2v5pWP57uT5p6c5o+P6L+wIj48L0UwNT48RTA2IGRlc2M9IuW7uuiuriI+PC9FMDY+PEUwNyBkZXNjPSLoja/mlY/nu5PmnpzmoIflv5ciPjwvRTA3PjxFMDggZGVzYz0iSeaKmOeCueiMg+WbtCI+NDwvRTA4PjxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCI+Jmx0Oz0yPC9FMDk+PEUxMCBkZXNjPSJS5oqY54K56IyD5Zu0Ij4mZ3Q7PTg8L0UxMD48RTExIGRlc2M9IuivlemqjOaWueazlSI+TUlDPC9FMTE+PC9zZWN0aW9uPjxzZWN0aW9uIGNvZGU9IlMwMDY0IiBkZXNjPSLnu4boj4znmoToja/mlY/kv6Hmga8iPjx0ZXh0Lz48RTAxIGRlc2M9IuaKl+eUn+e0oOS7o+eggSI+UElQMTAwPC9FMDE+PEUwMiBkZXNjPSLmipfnlJ/ntKDlkI3np7AiPuWTjOaLieilv+aelzwvRTAyPjxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj4xPC9FMDM+PEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiPlM8L0UwND48RTA1IGRlc2M9IuiNr+aVj+e7k+aenOaPj+i/sCI+5pWP5oSfPC9FMDU+PEUwNiBkZXNjPSLlu7rorq4iPjwvRTA2PjxFMDcgZGVzYz0i6I2v5pWP57uT5p6c5qCH5b+XIj48L0UwNz48RTA4IGRlc2M9IknmipjngrnojIPlm7QiPjMyLTY0PC9FMDg+PEUwOSBkZXNjPSJT5oqY54K56IyD5Zu0Ij4mbHQ7PTE2PC9FMDk+PEUxMCBkZXNjPSJS5oqY54K56IyD5Zu0Ij4mZ3Q7PTEyODwvRTEwPjxFMTEgZGVzYz0i6K+V6aqM5pa55rOVIj5NSUM8L0UxMT48L3NlY3Rpb24+PHNlY3Rpb24gY29kZT0iUzAwNjQiIGRlc2M9Iue7huiPjOeahOiNr+aVj+S/oeaBryI+PHRleHQvPjxFMDEgZGVzYz0i5oqX55Sf57Sg5Luj56CBIj5QT0wzMDA8L0UwMT48RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+5aSa57KY6I+M57SgQjwvRTAyPjxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj48L0UwMz48RTA0IGRlc2M9IuiNr+aVj+e7k+aenOS7o+eggSI+PC9FMDQ+PEUwNSBkZXNjPSLoja/mlY/nu5Pmnpzmj4/ov7AiPjwvRTA1PjxFMDYgZGVzYz0i5bu66K6uIj48L0UwNj48RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyI+PC9FMDc+PEUwOCBkZXNjPSJJ5oqY54K56IyD5Zu0Ij48L0UwOD48RTA5IGRlc2M9IlPmipjngrnojIPlm7QiPiZsdDs9MjwvRTA5PjxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCI+Jmd0Oz00PC9FMTA+PEUxMSBkZXNjPSLor5Xpqozmlrnms5UiPk1JQzwvRTExPjwvc2VjdGlvbj48c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj48dGV4dC8+PEUwMSBkZXNjPSLmipfnlJ/ntKDku6PnoIEiPlRPQjEwPC9FMDE+PEUwMiBkZXNjPSLmipfnlJ/ntKDlkI3np7AiPuWmpeW4g+mciee0oDwvRTAyPjxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj48L0UwMz48RTA0IGRlc2M9IuiNr+aVj+e7k+aenOS7o+eggSI+PC9FMDQ+PEUwNSBkZXNjPSLoja/mlY/nu5Pmnpzmj4/ov7AiPjwvRTA1PjxFMDYgZGVzYz0i5bu66K6uIj48L0UwNj48RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyI+PC9FMDc+PEUwOCBkZXNjPSJJ5oqY54K56IyD5Zu0Ij44PC9FMDg+PEUwOSBkZXNjPSJT5oqY54K56IyD5Zu0Ij4mbHQ7PTQ8L0UwOT48RTEwIGRlc2M9IlLmipjngrnojIPlm7QiPiZndDs9MTY8L0UxMD48RTExIGRlc2M9IuivlemqjOaWueazlSI+TUlDPC9FMTE+PC9zZWN0aW9uPjxzZWN0aW9uIGNvZGU9IlMwMDY0IiBkZXNjPSLnu4boj4znmoToja/mlY/kv6Hmga8iPjx0ZXh0Lz48RTAxIGRlc2M9IuaKl+eUn+e0oOS7o+eggSI+VFpQMTAwPC9FMDE+PEUwMiBkZXNjPSLmipfnlJ/ntKDlkI3np7AiPuWTjOaLieilv+aely/ku5bllJHlt7TlnaY8L0UwMj48RTAzIGRlc2M9IuacgOS9juaKkeiPjOa1k+W6piI+MTwvRTAzPjxFMDQgZGVzYz0i6I2v5pWP57uT5p6c5Luj56CBIj5TPC9FMDQ+PEUwNSBkZXNjPSLoja/mlY/nu5Pmnpzmj4/ov7AiPuaVj+aEnzwvRTA1PjxFMDYgZGVzYz0i5bu66K6uIj48L0UwNj48RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyI+PC9FMDc+PEUwOCBkZXNjPSJJ5oqY54K56IyD5Zu0Ij4zMi80LTY0LzQ8L0UwOD48RTA5IGRlc2M9IlPmipjngrnojIPlm7QiPiZsdDs9MTYvNDwvRTA5PjxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCI+Jmd0Oz0xMjgvNDwvRTEwPjxFMTEgZGVzYz0i6K+V6aqM5pa55rOVIj5NSUM8L0UxMT48L3NlY3Rpb24+PHNlY3Rpb24gY29kZT0iUzAwNjQiIGRlc2M9Iue7huiPjOeahOiNr+aVj+S/oeaBryI+PHRleHQvPjxFMDEgZGVzYz0i5oqX55Sf57Sg5Luj56CBIj5DSVA8L0UwMT48RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+546v5LiZ5rKZ5pifPC9FMDI+PEUwMyBkZXNjPSLmnIDkvY7mipHoj4zmtZPluqYiPjwvRTAzPjxFMDQgZGVzYz0i6I2v5pWP57uT5p6c5Luj56CBIj48L0UwND48RTA1IGRlc2M9IuiNr+aVj+e7k+aenOaPj+i/sCI+PC9FMDU+PEUwNiBkZXNjPSLlu7rorq4iPjwvRTA2PjxFMDcgZGVzYz0i6I2v5pWP57uT5p6c5qCH5b+XIj48L0UwNz48RTA4IGRlc2M9IknmipjngrnojIPlm7QiPjE8L0UwOD48RTA5IGRlc2M9IlPmipjngrnojIPlm7QiPiZsdDs9MC41PC9FMDk+PEUxMCBkZXNjPSJS5oqY54K56IyD5Zu0Ij4mZ3Q7PTI8L0UxMD48RTExIGRlc2M9IuivlemqjOaWueazlSI+TUlDPC9FMTE+PC9zZWN0aW9uPjxzZWN0aW9uIGNvZGU9IlMwMDY0IiBkZXNjPSLnu4boj4znmoToja/mlY/kv6Hmga8iPjx0ZXh0Lz48RTAxIGRlc2M9IuaKl+eUn+e0oOS7o+eggSI+VENDMTA8L0UwMT48RTAyIGRlc2M9IuaKl+eUn+e0oOWQjeensCI+5pu/5Y2h6KW/5p6XL+WFi+aLiee7tOmFuDwvRTAyPjxFMDMgZGVzYz0i5pyA5L2O5oqR6I+M5rWT5bqmIj4xPC9FMDM+PEUwNCBkZXNjPSLoja/mlY/nu5Pmnpzku6PnoIEiPlM8L0UwND48RTA1IGRlc2M9IuiNr+aVj+e7k+aenOaPj+i/sCI+5pWP5oSfPC9FMDU+PEUwNiBkZXNjPSLlu7rorq4iPjwvRTA2PjxFMDcgZGVzYz0i6I2v5pWP57uT5p6c5qCH5b+XIj48L0UwNz48RTA4IGRlc2M9IknmipjngrnojIPlm7QiPjMyLzItNjQvMjwvRTA4PjxFMDkgZGVzYz0iU+aKmOeCueiMg+WbtCI+Jmx0Oz0xNi8yPC9FMDk+PEUxMCBkZXNjPSJS5oqY54K56IyD5Zu0Ij4mZ3Q7PTEyOC8yPC9FMTA+PEUxMSBkZXNjPSLor5Xpqozmlrnms5UiPk1JQzwvRTExPjwvc2VjdGlvbj48c2VjdGlvbiBjb2RlPSJTMDA2NCIgZGVzYz0i57uG6I+M55qE6I2v5pWP5L+h5oGvIj48dGV4dC8+PEUwMSBkZXNjPSLmipfnlJ/ntKDku6PnoIEiPkNaQTwvRTAxPjxFMDIgZGVzYz0i5oqX55Sf57Sg5ZCN56ewIj7lpLTlraLku5bllbYv6Zi/57u05be05Z2mPC9FMDI+PEUwMyBkZXNjPSLmnIDkvY7mipHoj4zmtZPluqYiPjE8L0UwMz48RTA0IGRlc2M9IuiNr+aVj+e7k+aenOS7o+eggSI+PC9FMDQ+PEUwNSBkZXNjPSLoja/mlY/nu5Pmnpzmj4/ov7AiPjwvRTA1PjxFMDYgZGVzYz0i5bu66K6uIj48L0UwNj48RTA3IGRlc2M9IuiNr+aVj+e7k+aenOagh+W/lyI+PC9FMDc+PEUwOCBkZXNjPSJJ5oqY54K56IyD5Zu0Ij48L0UwOD48RTA5IGRlc2M9IlPmipjngrnojIPlm7QiPjwvRTA5PjxFMTAgZGVzYz0iUuaKmOeCueiMg+WbtCI+PC9FMTA+PEUxMSBkZXNjPSLor5Xpqozmlrnms5UiPk1JQzwvRTExPjwvc2VjdGlvbj48L3NlY3Rpb24+PHNlY3Rpb24gY29kZT0iUzAwNjIiIGRlc2M9IuajgOmqjOWtkOmhuee7k+aenCI+PHRleHQvPjxFMDEgZGVzYz0i5qOA6aqM5a2Q6aG55Luj56CBIj5XMDAwODwvRTAxPjxFMDIgZGVzYz0i5qOA6aqM5a2Q6aG55ZCN56ewIj7mt4vnkIPoj4zln7nlhbs8L0UwMj48RTAzIGRlc2M9IuajgOmqjOWtkOmhuee7k+aenO+8iOWumumHj++8iSI+PC9FMDM+PEUwNCBkZXNjPSLmo4DpqozlrZDpobnnu5PmnpzljZXkvY0iPjwvRTA0PjxFMDUgZGVzYz0i5qOA6aqM5a2Q6aG557uT5p6c77yI5a6a5oCn77yM6Zi0L+mYs++8iSI+5pyq5qOA5Ye66Z2p5YWw6Zi05oCn5Y+M55CD6I+MPC9FMDU+PEUwNiBkZXNjPSLmo4DpqozlrZDpobnlj4LogIPlgLzojIPlm7QiPuacquajgOWHuumdqeWFsOmYtOaAp+WPjOeQg+iPjDwvRTA2PjxFMDcgZGVzYz0i5qOA6aqM5a2Q6aG55byC5bi45qCH5b+XIj48L0UwNz48RTA4IGRlc2M9IuajgOmqjOiuvuWkh+e8lueggSI+PC9FMDg+PEUwOSBkZXNjPSLmo4Dpqozorr7lpIflkI3np7AiPjwvRTA5PjxFMTAgZGVzYz0i57uT5p6c6K+05piOIj48L0UxMD48L3NlY3Rpb24+PHNlY3Rpb24gY29kZT0iUzAwNjIiIGRlc2M9IuajgOmqjOWtkOmhuee7k+aenCI+PHRleHQvPjxFMDEgZGVzYz0i5qOA6aqM5a2Q6aG55Luj56CBIj5XMDAwNjwvRTAxPjxFMDIgZGVzYz0i5qOA6aqM5a2Q6aG55ZCN56ewIj7ln7nlhbvnu5Pmnpw8L0UwMj48RTAzIGRlc2M9IuajgOmqjOWtkOmhuee7k+aenO+8iOWumumHj++8iSI+PC9FMDM+PEUwNCBkZXNjPSLmo4DpqozlrZDpobnnu5PmnpzljZXkvY0iPjwvRTA0PjxFMDUgZGVzYz0i5qOA6aqM5a2Q6aG557uT5p6c77yI5a6a5oCn77yM6Zi0L+mYs++8iSI+5qOA5Ye6QuaXj+mTvueQg+iPjDwvRTA1PjxFMDYgZGVzYz0i5qOA6aqM5a2Q6aG55Y+C6ICD5YC86IyD5Zu0Ij48L0UwNj48RTA3IGRlc2M9IuajgOmqjOWtkOmhueW8guW4uOagh+W/lyI+QTwvRTA3PjxFMDggZGVzYz0i5qOA6aqM6K6+5aSH57yW56CBIj48L0UwOD48RTA5IGRlc2M9IuajgOmqjOiuvuWkh+WQjeensCI+PC9FMDk+PEUxMCBkZXNjPSLnu5Pmnpzor7TmmI4iPjwvRTEwPjwvc2VjdGlvbj48L3NlY3Rpb24+PC9zdHJ1Y3R1cmVkQm9keT48L2NsaW5pY2FsRG9jdW1lbnQ+</DocumentContent><DocumentPath></DocumentPath><DocumentPicPath></DocumentPicPath><UpdateUserCode>MIC01</UpdateUserCode><UpdateDate>2022-01-28</UpdateDate><UpdateTime>18:16:48</UpdateTime></RegisterDocumentRt></Body></Request>"
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(input)
	s rtn=..SaveXmlResult(stream).Read()
	q rtn
}

ClassMethod GetResultCode(ResultStream As %GlobalCharacterStream) As %String
{
	set $zt="Err"
	set ResultCode=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(ResultStream,.tDocument)
	set tSC=tDocument.EvaluateExpression("/Response/Body/ResultCode","text()",.tRes)					
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
		set fieldValue=tRes.GetAt(1).Value
		set ResultCode=$tr(fieldValue,$c(0),"")
	}
	q ResultCode
Err
	q "-1^"_$ze
}

ClassMethod GetResultContent(ResultStream As %GlobalCharacterStream) As %String
{
	set $zt="Err"
	set ResultContent=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(ResultStream,.tDocument)
	set tSC=tDocument.EvaluateExpression("/Response/Body/ResultContent","text()",.tRes)					
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
		set fieldValue=tRes.GetAt(1).Value
		set ResultContent=$tr(fieldValue,$c(0),"")
	}
	q ResultContent
Err
	q "-1^"_$ze
}

}
