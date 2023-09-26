/// 临床上报查询
Class DHCMed.CRService.ReportQry Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CRService.ReportQry).BuildCRReportHeader()
ClassMethod BuildCRReportHeader(argPrjID As %String) As %String
{
	New (argPrjID)
	Set return=""
	
	Set $ZT="BuildCRReportHeaderErr"
	
	Set gridColumn=""
	Set gridColumn=gridColumn_"var gridColumn=["
	Set gridColumn=gridColumn_"	{header: '报告编号',"
	Set gridColumn=gridColumn_"		width: 100,"
	Set gridColumn=gridColumn_"		dataIndex: 'ReportNo',"
	Set gridColumn=gridColumn_"		sortable: true,"
	Set gridColumn=gridColumn_"		renderer : function(v, m, rd, r, c, s){"
	Set gridColumn=gridColumn_"			var cPrjID = rd.get(""ProjectID"");"
	Set gridColumn=gridColumn_"			var cRowid = rd.get(""ReportID"");"
	Set gridColumn=gridColumn_"			var cEpisodeID = rd.get(""EpisodeID"");"
	Set gridColumn=gridColumn_"			var cCategoryID = rd.get(""TemplateCatID"");"
	Set gridColumn=gridColumn_"			var cInstanceID = rd.get(""InstanceID"");"
	Set gridColumn=gridColumn_"			var cprtDocID = rd.get(""PrtTemplateID"");"
	Set gridColumn=gridColumn_"			var cProjectDesc = rd.get(""ProjectDesc"");"
	Set gridColumn=gridColumn_"			return "" <a href='#' onclick='ClinReportLookUpHeader(\""""+cPrjID+""\"",\""""+cRowid+""\"",\""""+cEpisodeID+""\"",\""""+cCategoryID+""\"",\""""+cInstanceID+""\"",\""""+cprtDocID+""\"",\""""+cProjectDesc+""\"");'>&nbsp;"" + v + ""&nbsp; </a>"";"
	Set gridColumn=gridColumn_"		}"
	Set gridColumn=gridColumn_"	}"
	//Set gridColumn=gridColumn_"	{header: '报告号',width: 80,align: 'center',sortable: false,dataIndex: 'ReportNo'}"
	Set gridColumn=gridColumn_"	,{header: '登记号',width: 80,align: 'center',sortable: false,dataIndex: 'RegNo'}"
	Set gridColumn=gridColumn_"	,{header: '姓名',width: 80,align: 'center',sortable: false,dataIndex: 'PatName'}"
	Set gridColumn=gridColumn_"	,{header: '性别',width: 50,align: 'center',sortable: false,dataIndex: 'PatSex'}"
	Set gridColumn=gridColumn_"	,{header: '年龄',width: 50,align: 'center',sortable: false,dataIndex: 'PatAge'}"
	Set gridColumn=gridColumn_"	,{header: '报告状态',width: 50,align: 'center',sortable: false,dataIndex: 'ReportStatus'}"
	Set gridColumn=gridColumn_"	,{header: '报告科室',width: 100,align: 'center',sortable: false,dataIndex: 'RepLocDesc'}"
	Set gridColumn=gridColumn_"	,{header: '报告人',width: 80,align: 'center',sortable: false,dataIndex: 'RepUser'}"
	Set gridColumn=gridColumn_"	,{header: '报告日期',width: 80,align: 'center',sortable: false,dataIndex: 'RepDate'}"
	Set gridColumn=gridColumn_"	,{header: '报告时间',width: 80,align: 'center',sortable: false,dataIndex: 'RepTime'}"
	Set gridColumn=gridColumn_"	,{header: '审核人',width: 80,align: 'center',sortable: false,dataIndex: 'CheckUser'}"
	Set gridColumn=gridColumn_"	,{header: '审核日期',width: 80,align: 'center',sortable: false,dataIndex: 'CheckDate'}"
	Set gridColumn=gridColumn_"	,{header: '审核时间',width: 80,align: 'center',sortable: false,dataIndex: 'CheckTime'}"
	Set gridColumn=gridColumn_"	,{header: '退回原因',width: 80,align: 'center',sortable: false,dataIndex: 'ReturnRes'}"
	Set ItemIndex="",Num=0
	For {
		Set ItemIndex=$o(^DHCMed.CR.ProjectI("Items","IndexElIndex",+argPrjID,ItemIndex))
		Quit:ItemIndex=""
		Set ItemID=0
		For {
			Set ItemID=$o(^DHCMed.CR.ProjectI("Items","IndexElIndex",+argPrjID,ItemIndex,ItemID))
			Quit:ItemID=""
			Set objItem=##Class(DHCMed.CR.ProjectItems).GetById(argPrjID_"||"_ItemID)
			Continue:'$IsObject(objItem)
			Set ItemDesc=objItem.ElementDesc
			Continue:ItemDesc=""
			Set Num=Num+1
			Set gridColumn=gridColumn_"	,{header: '"_ItemDesc_"',width: 100,align: 'center',sortable: false,dataIndex: 'ItemData"_Num_"'}"
		}
	}
	Set gridColumn=gridColumn_"];"
	
	Set storeFields=""
	Set storeFields=storeFields_"var storeFields=["
	Set storeFields=storeFields_"	{name: 'ReportID', mapping: 'ReportID'}"
	Set storeFields=storeFields_"	,{name: 'InstanceID', mapping: 'InstanceID'}"
	Set storeFields=storeFields_"	,{name: 'ProjectID', mapping: 'ProjectID'}"
	Set storeFields=storeFields_"	,{name: 'EpisodeID', mapping: 'EpisodeID'}"
	Set storeFields=storeFields_"	,{name: 'ReportNo', mapping: 'ReportNo'}"
	Set storeFields=storeFields_"	,{name: 'ReportStatus', mapping: 'ReportStatus'}"
	Set storeFields=storeFields_"	,{name: 'RepLocDesc', mapping: 'RepLocDesc'}"
	Set storeFields=storeFields_"	,{name: 'RepUser', mapping: 'RepUser'}"
	Set storeFields=storeFields_"	,{name: 'RepDate', mapping: 'RepDate'}"
	Set storeFields=storeFields_"	,{name: 'RepTime', mapping: 'RepTime'}"
	Set storeFields=storeFields_"	,{name: 'CheckUser', mapping: 'CheckUser'}"
	Set storeFields=storeFields_"	,{name: 'CheckDate', mapping: 'CheckDate'}"
	Set storeFields=storeFields_"	,{name: 'CheckTime', mapping: 'CheckTime'}"
	Set storeFields=storeFields_"	,{name: 'ReturnRes', mapping: 'ReturnRes'}"
	Set storeFields=storeFields_"	,{name: 'Text1', mapping: 'Text1'}"
	Set storeFields=storeFields_"	,{name: 'Text2', mapping: 'Text2'}"
	Set storeFields=storeFields_"	,{name: 'Resume', mapping: 'Resume'}"
	Set storeFields=storeFields_"	,{name: 'PatientID', mapping: 'PatientID'}"
	Set storeFields=storeFields_"	,{name: 'RegNo', mapping: 'RegNo'}"
	Set storeFields=storeFields_"	,{name: 'PatName', mapping: 'PatName'}"
	Set storeFields=storeFields_"	,{name: 'PatSex', mapping: 'PatSex'}"
	Set storeFields=storeFields_"	,{name: 'PatAge', mapping: 'PatAge'}"
	Set storeFields=storeFields_"	,{name: 'ProjectDesc', mapping: 'ProjectDesc'}"
	Set storeFields=storeFields_"	,{name: 'TemplateCatID', mapping: 'TemplateCatID'}"
	Set storeFields=storeFields_"	,{name: 'PrtTemplateID', mapping: 'PrtTemplateID'}"
	
	Set ItemIndex="",Num=0
	For {
		Set ItemIndex=$o(^DHCMed.CR.ProjectI("Items","IndexElIndex",+argPrjID,ItemIndex))
		Quit:ItemIndex=""
		Set ItemID=0
		For {
			Set ItemID=$o(^DHCMed.CR.ProjectI("Items","IndexElIndex",+argPrjID,ItemIndex,ItemID))
			Quit:ItemID=""
			Set objItem=##Class(DHCMed.CR.ProjectItems).GetById(argPrjID_"||"_ItemID)
			Continue:'$IsObject(objItem)
			Set ItemDesc=objItem.ElementDesc
			Continue:ItemDesc=""
			Set Num=Num+1
			Set storeFields=storeFields_"	,{name: 'ItemData"_Num_"', mapping: 'ItemData"_Num_"'}"
		}
	}
	Set storeFields=storeFields_"];"
	
	Set return=gridColumn_" "_storeFields
	Quit return
	
BuildCRReportHeaderErr
	Quit ""
}

/// w ##Class(DHCMed.CRService.ReportQry).BuildCRReportStore(1,"2011-12-01","2011-12-27","","")
ClassMethod BuildCRReportStore(argPrjID As %String, argargDateFrom As %String, argargDateTo As %String, argLocID As %String, argStatus As %String) As %String
{
	New (argPrjID,argargDateFrom, argargDateTo, argLocID, argStatus)
	Set return=0,Count=0
	
	Set $ZT="BuildCRReportStoreErr"
	
	Write "{record:[",!
	Set rset = ##class(%ResultSet).%New()
	Set rset.ClassName = "DHCMed.CRService.ReportQry"
	Set rset.QueryName = "QueryCRReport"
	Do rset.Execute(argargDateFrom, argargDateTo, argLocID, argStatus, argPrjID)
	While (rset.Next(.sc))
	{
		If ($SYSTEM.Status.IsOK(sc))
		{
			Set Count=Count+1
			Write:Count>1 ","
			Set json=""
			Set json=json_"{"
			Set json=json_"ReportID:'"_rset.Data("ReportID")_"'"
			Set json=json_",InstanceID:'"_rset.Data("InstanceID")_"'"
			Set json=json_",ProjectID:'"_rset.Data("ProjectID")_"'"
			Set json=json_",EpisodeID:'"_rset.Data("EpisodeID")_"'"
			Set json=json_",ReportNo:'"_rset.Data("ReportNo")_"'"
			Set json=json_",ReportStatus:'"_rset.Data("ReportStatus")_"'"
			Set json=json_",RepLocDesc:'"_rset.Data("RepLocDesc")_"'"
			Set json=json_",RepUser:'"_rset.Data("RepUser")_"'"
			Set json=json_",RepDate:'"_rset.Data("RepDate")_"'"
			Set json=json_",RepTime:'"_rset.Data("RepTime")_"'"
			Set json=json_",CheckUser:'"_rset.Data("CheckUser")_"'"
			Set json=json_",CheckDate:'"_rset.Data("CheckDate")_"'"
			Set json=json_",CheckTime:'"_rset.Data("CheckTime")_"'"
			Set json=json_",ReturnRes:'"_rset.Data("ReturnRes")_"'"
			Set json=json_",Text1:'"_rset.Data("Text1")_"'"
			Set json=json_",Text2:'"_rset.Data("Text2")_"'"
			Set json=json_",Resume:'"_rset.Data("Resume")_"'"
			Set json=json_",PatientID:'"_rset.Data("PatientID")_"'"
			Set json=json_",RegNo:'"_rset.Data("RegNo")_"'"
			Set json=json_",PatName:'"_rset.Data("PatName")_"'"
			Set json=json_",PatSex:'"_rset.Data("PatSex")_"'"
			Set json=json_",PatAge:'"_rset.Data("PatAge")_"'"
			Set json=json_",ProjectDesc:'"_rset.Data("ProjectDesc")_"'"
			Set json=json_",TemplateCatID:'"_rset.Data("TemplateCatID")_"'"
			Set json=json_",PrtTemplateID:'"_rset.Data("PrtTemplateID")_"'"
			
			Set Num=0
			Set ItemDataList=rset.Data("ItemDataList")
			For itemIndex=1:1:$l(ItemDataList,$c(1)) {
				Set tmpItemData=$p(ItemDataList,$c(1),itemIndex)
				Set Num=Num+1
				Set json=json_",ItemData"_Num_":'"_tmpItemData_"'"
			}
			Set json=json_"}"
			Write json,!
		}Else{ Quit }
	}
	Write "],total : "_Count_"}"
	
	Set return=1
	Quit return
	
BuildCRReportStoreErr
	Write "],total : "_Count_"}"
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2011-12-27
/// Description:  根据综合条件查询临床报告
/// Table：       DHCMed.CR.Report
/// Input：       argDateFrom 开始时间
///               argDateTo   结束时间
///               argLocID    科室
///               argStatus   状态
///               argPrjID 临床上报项目IDs
/// Return：      $lb(临床上报相关信息)
/// d ##Class(%ResultSet).RunQuery("DHCMed.CRService.ReportQry","QueryCRReport","2011-12-01","2011-12-27","","*D*Y*","1")
Query QueryCRReport(argDateFrom As %String, argDateTo As %String, argLocID As %String, argStatus As %String, argPrjID As %String) As %Query(ROWSPEC = "ReportID:%String,InstanceID:%String,ProjectID:%String,EpisodeID:%String,ReportNo:%String,ReportStatus:%String,RepLocDesc:%String,RepUser:%String,RepDate:%String,RepTime:%String,CheckUser:%String,CheckDate:%String,CheckTime:%String,ReturnRes:%String,Text1:%String,Text2:%String,Resume:%String,PatientID:%String,RegNo:%String,PatName:%String,PatSex:%String,PatAge:%String,ProjectDesc:%String,TemplateCatID:%String,PrtTemplateID:%String,ItemDataList:%String")
{
}

ClassMethod QueryCRReportExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argLocID As %String, argStatus As %String, argPrjID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//同步电子病历与临床上报数据
	Set flg=##class(DHCMed.CRService.Interface).SyncDataEPRToCR("")
	Quit:flg<0 $$$OK
	
    Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
    Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
    Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
    Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
    Set:argDateFrom'="" argDateFrom=+argDateFrom
    Set:argDateTo'="" argDateTo=+argDateTo
    Quit:(argDateFrom="")||(argDateTo="") $$$OK
    Quit:argDateFrom>argDateTo $$$OK
    
    Set ProjectInfo=##Class(DHCMed.CR.Project).GetById(argPrjID)
	Set ProjectDesc=$p(ProjectInfo,"^",3)
	Set TemplateCatID=$p(ProjectInfo,"^",6)     //界面模板ID
	Set PrtTemplateID=$p(ProjectInfo,"^",4)     //打印模板ID
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QueryCRReport")
	Set ItemIndex=""
	For {
		Set ItemIndex=$o(^DHCMed.CR.ProjectI("Items","IndexElIndex",+argPrjID,ItemIndex))
		Quit:ItemIndex=""
		Set ItemID=0
		For {
			Set ItemID=$o(^DHCMed.CR.ProjectI("Items","IndexElIndex",+argPrjID,ItemIndex,ItemID))
			Quit:ItemID=""
			Set objItem=##Class(DHCMed.CR.ProjectItems).GetById(argPrjID_"||"_ItemID)
			Continue:'$IsObject(objItem)
			Set ItemCode=objItem.ElementCode
			Continue:ItemCode=""
			Set Num=$i(^TMP(ZIndex,JIndex,"QueryCRReport"))
			Set ^TMP(ZIndex,JIndex,"QueryCRReport",Num)=ItemCode
		}
	}
    
    //Index DateLoc On (RepDate As Exact, RepargLocID As SqlString);
    Set xRepDate=argDateFrom-1
    For {
		Set xRepDate=$o(^DHCMed.CR.ReportI("DateLoc",xRepDate))
		Quit:(xRepDate="")||(xRepDate>argDateTo)
		Set xRepLoc=""
		For {
			Set xRepLoc=$o(^DHCMed.CR.ReportI("DateLoc",xRepDate,xRepLoc))
			Quit:xRepLoc=""
			//Quit:(argLocID'="")&&($e(xRepLoc,2,$l(xRepLoc))'=argLocID)
			Set xReportID=0
			For {
				Set xReportID=$o(^DHCMed.CR.ReportI("DateLoc",xRepDate,xRepLoc,xReportID))
				Quit:xReportID=""
				
				//同步电子病历与临床上报状态数据
				Set ReportStatus=##Class(DHCMed.CRService.Interface).GetStatusByRepID(xReportID)
				
				Set ReportStr=##Class(DHCMed.CR.Report).GetById(xReportID)
				Set ReportID=$p(ReportStr,"^",1)
				Set InstanceID=$p(ReportStr,"^",2)
				Set ProjectID=$p(ReportStr,"^",3)
				Continue:(argPrjID'="")&&(("|"_argPrjID_"|")'[("|"_ProjectID_"|"))
				Set EpisodeID=$p(ReportStr,"^",4)
				Set ReportStatus=$p(ReportStr,"^",5)
				Continue:(argStatus'="")&&(argStatus'[ReportStatus)
				Set:ReportStatus'="R" $p(ReportStr,"^",12)=""
				Set ReportStatus=$s(ReportStatus="D":"待审",ReportStatus="Y":"已审",ReportStatus="R":"退回",ReportStatus="S":"删除",1:"")
				Set RepUser=$p(ReportStr,"^",6)    //报告人
				If RepUser'="" {
					Set UserInfo=##class(DHCMed.CRService.CommonFun).GetLogUserInfo(+RepUser)
					Set RepUser=$p(UserInfo,"^",3)
				}
				Set RepDate=$p(ReportStr,"^",7)
				Set ReportNo=$p($p(ReportStr,"^",7),"-")_$tr($justify($p(ReportStr,"^",1),4)," ",0)   //报告编号
				Set RepTime=$p(ReportStr,"^",8)
				Set CheckUser=$p(ReportStr,"^",9)  //审核人
				If CheckUser'="" {
					Set UserInfo=##class(DHCMed.CRService.CommonFun).GetLogUserInfo(+CheckUser)
					Set CheckUser=$p(UserInfo,"^",3)
				}
				Set CheckDate=$p(ReportStr,"^",10)
				Set CheckTime=$p(ReportStr,"^",11)
				Set ReturnRes=$p(ReportStr,"^",12)
				Set Text1=$p(ReportStr,"^",13)
				Set Text2=$p(ReportStr,"^",14)
				Set Resume=$p(ReportStr,"^",15)
				Set RepLocDesc=$p(ReportStr,"^",16)
				
				//就诊科室代替报告科室
				Set AdmLoc=$p($g(^PAADM(+EpisodeID)),"^",4)
				Continue:(argLocID'="")&&(argLocID'=AdmLoc)
				Set RepLocDesc=$p($g(^CTLOC(+AdmLoc)),"^",2)
				Set:$p(RepLocDesc,"-",2)'="" RepLocDesc=$p(RepLocDesc,"-",2)
				
				Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
				Set RegNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
				Set PatName=$p($g(^PAPER(+PatientID,"ALL")),"^",1)
				Set PatSex=$p($g(^PAPER(+PatientID,"ALL")),"^",7)
				If PatSex'="" {
		    		Set PatSex=$p($g(^CT("SEX",+PatSex)),"^",2)
		    	}
		    	Set PatAge=0
		    	Set BirthDay=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
		    	If BirthDay'="" {
			    	Set PatAge= (+$zd(+$h,3))-(+$zd(BirthDay,3))
			    	Set:PatAge<1 PatAge=1
			    }
			    
			    Set ItemIndex=0,ItemDatas=""
			    For {
				    Set ItemIndex=$o(^TMP(ZIndex,JIndex,"QueryCRReport",ItemIndex))
				    Quit:ItemIndex=""
				    Set ElCode=$g(^TMP(ZIndex,JIndex,"QueryCRReport",ItemIndex))
				    Continue:ElCode=""
				    Set EPRData=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID,ElCode)
					Set EPRData=$tr(EPRData,$c(13),";")
					Set EPRData=$tr(EPRData,$c(0),"")
					Set EPRData=$tr(EPRData,"'","")
					Set EPRData=$tr(EPRData,"""","")
					If ItemDatas'="" {
						Set ItemDatas=ItemDatas_$c(1)_EPRData
					}Else{
						Set ItemDatas=EPRData
					}
				}
				
				Set Data=$lb(ReportID,InstanceID,ProjectID,EpisodeID)
				Set Data=Data_$lb(ReportNo,ReportStatus,RepLocDesc)
				Set Data=Data_$lb(RepUser,RepDate,RepTime,CheckUser,CheckDate,CheckTime)
				Set Data=Data_$lb(ReturnRes,Text1,Text2,Resume)
				Set Data=Data_$lb(PatientID,RegNo,PatName,PatSex,PatAge)
				Set Data=Data_$lb(ProjectDesc,TemplateCatID,PrtTemplateID)
				Set Data=Data_$lb(ItemDatas)
			 	Set ^CacheTemp(repid,ind)=Data
			 	Set ind=ind+1
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,"QueryCRReport")
	
    Quit $$$OK
}

ClassMethod QueryCRReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCRReportExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryCRReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCRReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

}
