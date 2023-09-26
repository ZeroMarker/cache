Class web.CDSS.Demo.TriggLISRDetail Extends %RegisteredObject
{

/// Creator：杨继鸿
/// CreatDate: 2022-03-21
/// Description：查询方法
/// Input： rowid patid 患者id
/// Output: RowId,PatDR,LabItem,LabResult,Unit,RefRange,AbnormalResult,OriginalContent
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Demo.TriggLISRDetail","GetList","","1")
Query GetList(rowid, patid As %String) As %Query(ROWSPEC = "RowId,PatDR,LabItem,LabResult,Unit,RefRange,AbnormalResult,OriginalContent,LabItemDetail")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, patid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (patid="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
		d OutputRow
	}
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowId=rowid
		s PatDR=$LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),2)	// 指向患者
		s LabItem=$LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),3)		// 检验项目
		s LabResult=$LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),4)		// 检验结果
		s Unit=$LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),5)			// 单位
		s RefRange=$LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),6)			// 参考范围
		s AbnormalResult = $LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),7)	// 异常结果显示
		s OriginalContent = $LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),8)	// 病历原文
		s LabItemDetail = $LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),9)
		d OutputRow
	}
	else
	{
		s RowId=""
		for
		{
			s RowId=$o(^WDT.CDSS.TriggLISRDetailD(RowId))
			q:RowId=""
			s PatDR=$LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),2)	// 指向患者
			continue:PatDR'=patid
			s LabItem=$LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),3)		// 检验项目
			s LabResult=$LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),4)		// 检验结果
			s Unit=$LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),5)			// 单位
			s RefRange=$LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),6)			// 参考范围
			s AbnormalResult = $LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),7)	// 异常结果显示
			s OriginalContent = $LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),8)	// 病历原文
			s LabItemDetail = $LISTGET($G(^WDT.CDSS.TriggLISRDetailD(RowId)),9)
			d OutputRow
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowId,PatDR,LabItem,LabResult,Unit,RefRange,AbnormalResult,OriginalContent,LabItemDetail)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 k ^TempDataHandle($ZNAME,repid,$JOB)
 Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// w ##class(web.CDSS.Demo.TriggLISRDetail).Test1()
ClassMethod Test1()
{
    s eobj = ##class(web.CDSSEntity.Demo.TriggLISRDetail).%New()
    s eobj.PatDR = "20"
	s eobj.LabItem = "尿酮体"
	s eobj.LabItemDetail="尿总钙"
	s eobj.LabResult = ""
	s eobj.Unit=""
	s eobj.RefRange=""
	s eobj.AbnormalResult=""
	s eobj.OriginalContent=""
	
	s rs=..SaveData("1",eobj,"31")
	q rs
}

/// Creator：杨继鸿
/// CreatDate: 2022-03-21
/// Description：保存方法
/// Input： flag 数据来源 0-关联新增 1-用户新增；eobj web.CDSSEntity.Demo.TriggLISRDetail；taskid WDT.CDSS.TriggTasksDetail的ID
/// Output: success 成功true,失败false id 任务集ID errorinfo 错误原因
/// Other: d ##class(web.CDSS.Demo.TriggLISRDetail).SaveData("")
ClassMethod SaveData(flag As %String = "1", eobj As web.CDSSEntity.Demo.TriggLISRDetail, taskid As %String) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(WDT.CDSS.TriggLISRDetail).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(WDT.CDSS.TriggLISRDetail).%OpenId(eobj.RowId)
		    s bobj = ##class(web.CDSSEntity.Demo.TriggLISRDetail).%New()
		    s bobj.PatDR = obj.PatDR.%Id()
			s bobj.LabItem = obj.LabItem
			s bobj.LabResult = obj.LabResult
			s bobj.Unit=obj.Unit
			s bobj.RefRange=obj.RefRange
			s bobj.AbnormalResult=obj.AbnormalResult
			s bobj.OriginalContent=obj.OriginalContent
			s bobj.LabItemDetail = obj.LabItemDetail
			
		}
		d obj.PatDRSetObjectId(eobj.PatDR)
		s obj.LabItem = eobj.LabItem
		s obj.LabResult = eobj.LabResult
		s obj.Unit=eobj.Unit
		s obj.RefRange=eobj.RefRange
		s obj.AbnormalResult=eobj.AbnormalResult
		s obj.OriginalContent=eobj.OriginalContent
		s obj.LabItemDetail = eobj.LabItemDetail
		s falseFlag=0
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
			// 检验报告直接保存到检验信息表中
			s:eobj.RowId="" SLIResult=..SaveLabInfo(id,0)
			s:eobj.RowId'="" SLIResult=..SaveLabInfo(id,1)
			if SLIResult.success'="false"
			{
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				//仅对用户新增的数据，保存日志
				if flag="1"
				{
					d ##class(web.CDSS.Demo.TriggTasksDetail).UpdateState(taskid)
					d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TriggLISRDetail","WDT.CDSS.TriggLISRDetail","LIS报告明细",id,eobj.LabItem,"A",eobj)
					d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TriggLISRDetail","WDT.CDSS.TriggLISRDetail","LIS报告明细",id,eobj.LabItem,"U",eobj,bobj)
				}
			}
			else
			{
				s falseFlag=1
			}
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("LIS报告明细","web.CDSS.Demo.TriggLISRDetail","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
       		s falseFlag=1
		}
		if falseFlag=1
		{
			TRO
		}
		else
		{
			TC
		}
	}
	q result
ERROR
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("LIS报告明细","web.CDSS.Demo.TriggLISRDetail","SaveData",eobj)
	s ^ERRORLOGINFO(logid)=$ze
	s result= "{success:'false',errorinfo:'保存失败！'}"
	q result
}

/// Creator:杨继鸿
/// CreatDate:2022-03-17
/// Description: 删除方法
/// Table: WDT.CDSS.TriggLISRDetail
/// Input: flag 删除来源 0-批量删除 1-用户删除；rowid；taskid 任务ID；
/// Return: 删除成功返回"{success:'true'}"，失败返回{success:false,errorinfo:""}
/// others: w ##class(web.CDSS.Demo.TriggLISRDetail).DeleteData("0","1")
ClassMethod DeleteData(flag As %String = "1", rowid As %String, taskid As %String) As %String
{
	s result=""
	
	s obj=##class(WDT.CDSS.TriggLISRDetail).%OpenId(rowid)
    s bobj = ##class(web.CDSSEntity.Demo.TriggLISRDetail).%New()
    s bobj.PatDR = obj.PatDR.%Id()
	s bobj.LabItem = obj.LabItem
	s bobj.LabResult = obj.LabResult
	s bobj.Unit=obj.Unit
	s bobj.RefRange=obj.RefRange
	s bobj.AbnormalResult=obj.AbnormalResult
	s bobj.OriginalContent=obj.OriginalContent
	s bobj.LabItemDetail = obj.LabItemDetail
	Ts	
		
	s sc=##class(WDT.CDSS.TriggLISRDetail).%DeleteId(rowid)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true'}"
		//保存日志
		if flag="1" 
		{
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TriggLISRDetail","WDT.CDSS.TriggLISRDetail","LIS报告明细",rowid,bobj.LabItem,"D",bobj)
			d ##class(web.CDSS.Demo.TriggTasksDetail).UpdateState(taskid)
		}
		
    	//删除关联表
    	
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
       	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("LIS报告明细","web.CDSS.Demo.TriggLISRDetail","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
       	d bobj.%Close()
	}
    
	q result
}

/// w ##class(web.CDSS.Demo.TriggLISRDetail).BatchSaveData("1","2022-03-17 15:33:34","yjh","2,3")
ClassMethod BatchSaveData(taskID, OperationTime As %String, OperatorUser, PatIDStr As %String = "") As %String
{
	s result=""
	s count=0
	s length=$length(PatIDStr,",")
	
	TS
	for i=1:1:length
	{
		s patID=$p(PatIDStr,",",i)
	    s eobj = ##class(web.CDSSEntity.Demo.TriggLISRDetail).%New()
	    s eobj.PatientDR = patID
		s eobj.TaskDR = taskID
		s eobj.State = "0"
		s eobj.OperationTime = OperationTime
		s eobj.OperatorUser = OperatorUser
		
		s rs=..SaveData("0", eobj)
		if rs["false"
		{
			s result=rs	//错误信息赋值
			quit
		}
		else
		{
			s count=count+1
		}
		//测试父级的错误处理
#;		if count=2
#;		{
#;			b ;2
#;			s result="false"
#;			quit
#;		}
	}
	if result["false"
	{
		TRO
	}
	else
	{
		TC
		s result="{success:'true',count:'"_count_"'}"
	}
	q result
}

/// w ##class(web.CDSS.Demo.TriggLISRDetail).BatchDeleteData("1","2022-03-17 15:33:34","yjh")
ClassMethod BatchDeleteData(taskID) As %String
{
	s result=""
	s count=0
	
	s ID=""
	TS
	for
	{
		s ID=$o(^WDT.CDSS.TriggLISRDetailI("TaskIndex",taskID,ID))
		q:ID=""
		
		s rs=..DeleteData("0",ID)
		if rs["false"
		{
			s result=rs	//错误信息赋值
			quit
		}
		else
		{
			s count=count+1
		}
		//测试父级的错误处理
#;		if count=2
#;		{
#;			b ;2
#;			s result="false"
#;			quit
#;		}
	}
	if result["false"
	{
		TRO
	}
	else
	{
		TC
		s result="{success:'true',count:'"_count_"'}"
	}
	q result
}

/// w ##class(web.CDSS.Demo.TriggLISRDetail).Test()
ClassMethod Test()
{
    s bobj = ##class(web.CDSSEntity.Demo.TriggLISRDetail).%New()
    s bobj.PatDR = "284"
	s bobj.LabItem = "碳14呼气试验"
	s bobj.LabResult = "脑脊液细菌培养阳性"
	s bobj.Unit=""
	s bobj.RefRange=""
	s bobj.AbnormalResult="杆菌超标"
	s bobj.OriginalContent=""
	
	s rs=..SaveData("0",bobj)
	q rs
}

/// Creator：杨继鸿
/// CreatDate: 2022-04-24
/// Description：获取检验医嘱JSON，对接CDSS2.0
/// Table：WDT.CDSS.TriggLISRDetail
/// Input: PatDR Demo患者Id；Ids 检验项目字典表Id；Flag 操作标志（1-新增/修改；2-删除）
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.EvalWordTrigg).GetLISOrderJSON("3")
ClassMethod GetLISOrderJSON(PatDR, Ids, Flag) As %String
{
	s ResJSON={}
	s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(PatDR)
	s IDNO =pobj.IDNO //患者主索引
	s PatientDR =pobj.PatientDR //病人标识
	s VisitID =pobj.AdmissionCount //就诊次
	s VisitType ="3" //就诊类型 1急诊，2门诊，3住院
	s Name =pobj.Name //患者姓名
	s UserID ="" //医生ID 
	s:$d(%session)>0 UserName =$G(%session.Data("LOGON.USERNAME")) //医生姓名
	s:$d(%session)=0 UserName ="Demo Group" //医生姓名
	s DeptCode ="" //科室编码
	s DeptName =pobj.Department //科室名称
	s HospCode ="" //医院编码
	s HospName =pobj.Hospital //医院名称
	d ResJSON.%Set("IDNO",IDNO)
	d ResJSON.%Set("PatientDR",PatientDR)
	d ResJSON.%Set("VisitID",VisitID)
	d ResJSON.%Set("VisitType",VisitType)
	d ResJSON.%Set("Name",Name)
	d ResJSON.%Set("UserID",UserID)
	d ResJSON.%Set("UserName",UserName)
	d ResJSON.%Set("DeptCode",DeptCode)
	d ResJSON.%Set("DeptName",DeptName)
	d ResJSON.%Set("HospCode",HospCode)
	d ResJSON.%Set("HospName",HospName)
	
	s PatientInfo={}
	s Sex=pobj.Sex //性别
	s Gender="2"
	s:Sex="女" Gender="0"
	s:Sex="男" Gender="1"
	s BirthDate=pobj.Birthday //出生日期
	s PregnancyStatus="" //妊娠状态
	d PatientInfo.%Set("Gender",Gender)
	d PatientInfo.%Set("BirthDate",BirthDate)
	d PatientInfo.%Set("PregnancyStatus",PregnancyStatus)
	d ResJSON.%Set("PatientInfo",PatientInfo)

	s OrderEntry=[]
	s IdLen=$Length(Ids,"^")
	for i=1:1:IdLen{
		s RowId=$p(Ids,"^",i)
		s OrderTime= $lg($g(^WDT.CDSS.DEMOLabOrdersD(RowId)),3) // 医嘱时间
		s PriorType= $lg($g(^WDT.CDSS.DEMOLabOrdersD(RowId)),5) 
		s:PriorType="长期医嘱" PriorType="long"
		s:PriorType="临时医嘱" PriorType="short"
		s OrderContent= $lg($g(^WDT.CDSS.DEMOLabOrdersD(RowId)),6) // 医嘱内容
		s OrderContentId=""
		s:OrderContent'="" OrderContentId=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_OrderContent,0))
		s Specimen= $lg($g(^WDT.CDSS.DEMOLabOrdersD(RowId)),7) // 样本
		s Position= $lg($g(^WDT.CDSS.DEMOLabOrdersD(RowId)),8) // 部位
		s Frequency= $lg($g(^WDT.CDSS.DEMOLabOrdersD(RowId)),9) // 频次
		s Recorder= $lg($g(^WDT.CDSS.DEMOLabOrdersD(RowId)),10) // 录入人员
		s RecorderId=""
		s:Recorder'="" RecorderId=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(Recorder),0))
		s OrderJson={}
		d OrderJson.%Set("OrderID",RowId) //医嘱唯一标识
		d OrderJson.%Set("OrderClass",1) //医嘱类型 1住院医嘱
		d OrderJson.%Set("OrderFlag",Flag) //操作类型 1新增/修改 2取消
		d OrderJson.%Set("OrderType",3) //医嘱分类 1 药品 2检查 3 检验 4 手术 5 护理 6 处置 7 膳食 8 会诊 9 麻醉 10其他
		d OrderJson.%Set("PriorType",PriorType) //长期医嘱 long   临时医嘱 short
		d OrderJson.%Set("CreatTime","") //医嘱创建时间 OrderFlag=1时填写
		d OrderJson.%Set("StopTime","") //医嘱作废时间 OrderFlag=1时填写
		d OrderJson.%Set("DoctorId",RecorderId) //医生唯一标识（当前操作者）
		d OrderJson.%Set("DoctorName",Recorder) //医生姓名
		d OrderJson.%Set("CreateDeptCode","") //开立科室代码
		d OrderJson.%Set("CreatDeptName",pobj.Department) //开立科室名称
		d OrderJson.%Set("GroupSequence","1") //医嘱组顺序号
		d OrderJson.%Set("OrderCode",OrderContentId) //医嘱项目代码
		d OrderJson.%Set("OrderContent",OrderContent) //医嘱项目内容
		d OrderJson.%Set("Dosage","") //给药剂量 Ordertype=1时 填写
		d OrderJson.%Set("Unit","") //剂量单位 Ordertype=1时 填写
		d OrderJson.%Set("Frequency","") //频率 Ordertype=1时 填写
		d OrderJson.%Set("Specification","") //规格 Ordertype=1时 填写
		d OrderJson.%Set("Pathway","") //给药方式 Ordertype=1时 填写
		d OrderJson.%Set("Sample",Specimen) //样本 如血、尿 Ordertype=3时填写
		d OrderJson.%Set("Position","") //部位（检查部位/手术部位） Ordertype=2或4时 填写
		d OrderJson.%Set("Level","") //手术等级 Ordertype=4时填写
		d OrderJson.%Set("IncisionType","") //切口类型 Ordertype=4时填写
		d OrderJson.%Set("Anesthesia","") //麻醉方式 Ordertype=4时填写
		d OrderJson.%Set("PreoperativeDiagnose","") //术前诊断 Ordertype=4时填写
		d OrderJson.%Set("OperationPosition","") //手术体位 Ordertype=4时填写
		d OrderEntry.%Push(OrderJson)	
	}
	d ResJSON.%Set("OrderEntry",OrderEntry)
	q ResJSON.%ToJSON()
}

/// Creator：杨继鸿
/// CreatDate: 2022-04-20
/// Description：获取LIS报告及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.TriggLISRDetail
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.EvalWordTrigg).GetLISRJSONData("3")
ClassMethod GetLISRJSONData(patId) As %String
{
	s ResJSON={}
	//s robj = ##class(WDT.CDSS.DEMOLISReport).%OpenId(RowId)
	
	s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(patId)
	if pobj'=""
	{
		s IDNO =pobj.IDNO //患者主索引
		s PatientDR =pobj.PatientDR //病人标识
		s VisitID =pobj.AdmissionCount //就诊次
		s VisitType ="3" //就诊类型 1急诊，2门诊，3住院
		s Name =pobj.Name //患者姓名
		s UserID ="" //医生ID 
		s UserName ="" //医生姓名
		s DeptCode ="" //科室编码
		s DeptName =pobj.Department //科室名称
		s HospCode ="" //医院编码
		s HospName ="" //医院名称
		d ResJSON.%Set("IDNO",IDNO)
		d ResJSON.%Set("PatientDR",PatientDR)
		d ResJSON.%Set("VisitID",VisitID)
		d ResJSON.%Set("VisitType",VisitType)
		d ResJSON.%Set("Name",Name)
		d ResJSON.%Set("UserID",UserID)
		d ResJSON.%Set("UserName",UserName)
		d ResJSON.%Set("DeptCode",DeptCode)
		d ResJSON.%Set("DeptName",DeptName)
		d ResJSON.%Set("HospCode",HospCode)
		d ResJSON.%Set("HospName",HospName)
		
		//s:robj.OrdersDR'="" GroupFlag=robj.OrdersDR.%Id() //医嘱号
		//s:robj.OrdersDR="" GroupFlag=""
		s GroupFlag=""	//不关联检验医嘱
		
		s InspectionCode="" //检验编码
		s InspectionName="" //检验名称
		s ExecuteTime="" //执行时间
		s ReportTime="" //报告时间
		d ResJSON.%Set("GroupFlag",GroupFlag)
		d ResJSON.%Set("InspectionCode",InspectionCode)
		d ResJSON.%Set("InspectionName",InspectionName)
		
		s LabResultInfo=[]
		s id=0
		for
		{
			s id=$o(^WDT.CDSS.TriggLISRDetailD(id))
			q:id=""
			
			s patDR=$lg($g(^WDT.CDSS.TriggLISRDetailD(id)),2)
			continue:patDR'=patId
			s LabItem = $lg($g(^WDT.CDSS.TriggLISRDetailD(id)),3) //检验医嘱
			s LabResult = $lg($g(^WDT.CDSS.TriggLISRDetailD(id)),4) //检验结果
			s Unit = $lg($g(^WDT.CDSS.TriggLISRDetailD(id)),5) //单位
			s RefRange = $lg($g(^WDT.CDSS.TriggLISRDetailD(id)),6) //参考范围
			s AbnormalResult = $lg($g(^WDT.CDSS.TriggLISRDetailD(id)),7) //异常结果显示
			s LabItemDetail= $lg($g(^WDT.CDSS.TriggLISRDetailD(id)),9) //检验项目
			s LabDetail={}
			d LabDetail.%Set("LabItemCode",LabItem)
			d LabDetail.%Set("LabItemName",LabItem)
			d LabDetail.%Set("LabResult",LabResult)
			d LabDetail.%Set("LabResultFlag",AbnormalResult)
			d LabDetail.%Set("Unit",Unit)
			d LabDetail.%Set("Reference",RefRange)
			d LabDetail.%Set("Reference",LabDetailMin)
			d LabResultInfo.%Push(LabItemDetail)
		}		
		d ResJSON.%Set("LabResultInfo",LabResultInfo)
		d ResJSON.%Set("ExecuteTime",ExecuteTime)
		d ResJSON.%Set("ReportTime",ReportTime)
		d ResJSON.%Set("Remarks","")
	}
	else
	{
		q "0"
	}
	q ResJSON.%ToJSON()
}

/// Creator: 杨继鸿
/// CreatDate: 2022-04-24
/// Description: 保存到检验信息表
/// Input: id LIS报告明细Id；flag 操作标志 0-新增；1-修改
/// Output: result json
/// Return: 成功 "{success:'true',count:删除的数量}"；失败 "{success:'false',errorinfo:'...'}"
/// Others: w ##class(web.CDSS.Demo.TriggLISRDetail).SaveLabInfo("2","0")
ClassMethod SaveLabInfo(id, flag)
{
	s $zt="SaveLabInfoERROR"
	s result={}
	s obj=##class(WDT.CDSS.TriggLISRDetail).%OpenId(id)
	
	if obj'=""
	{
		s groupFlag="TLISRD-"_id	// TLISRD，表示数据来自LIS报告明细；id表示LIS报告明细的Id，已”-“分隔
		
		s InspectionName=obj.LabItem
		s LabItemName=obj.LabItemDetail
		
		// 检验医嘱字典表
		s ordersId=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_$ZCONVERT(InspectionName,"U"),0))
		s InspectionCode=ordersId	// 检验医嘱Id
		// 检验项目字典表
		s inspectionId=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(LabItemName,"U"),0))
		s LabItemCode=inspectionId	// 检验项目Id
		s labInfoJSON={}
		// 患者基础信息表
		s pObj=##class(WDT.CDSS.DEMOPatMaster).%OpenId(obj.PatDR.%Id())
		s labInfoJSON.IDNO=pObj.IDNO	// 患者主索引
		s labInfoJSON.PatientDR=pObj.PatientDR	// 病人标识（就诊医院id）
		s labInfoJSON.VisitID=pObj.AdmissionCount	// 就诊次数编号（第几次）
		s labInfoJSON.VisitType="住院"	// 就诊类型（急诊、门诊、住院）
		s labInfoJSON.Name=pObj.Name	// 姓名
		s labInfoJSON.UserID=""
		s labInfoJSON.DeptCode=""
		s labInfoJSON.DeptName=pObj.Department	// 科室
		s labInfoJSON.HospCode=""
		s labInfoJSON.HospName=""
		s labInfoJSON.GroupFlag=groupFlag
		s labInfoJSON.InspectionCode=InspectionCode
		s labInfoJSON.InspectionName=InspectionName
		//s labInfoJSON.LabItemCode=LabItemCode
		//s labInfoJSON.LabItemName=LabItemName
		
		s labResultInfo=[]
		s resultData={}
		s resultData.LabItemCode=LabItemCode	// 检验小项编码
		s resultData.LabItemName=LabItemName	// 检验小项名称
		s resultData.LabResult=obj.LabResult	// 检验结果
		s resultData.LabResultFlag=""	// 检验结果指标（阴性或阳性）
		s resultData.Unit=obj.Unit	// 单位
		s resultData.Reference=obj.RefRange	// 参考范围		
		d labResultInfo.%Push(resultData)
		
		s labInfoJSON.LabResultInfo=labResultInfo
		s labInfoJSON.ExecuteTime=""
		s labInfoJSON.ReportTime=""
		s labInfoJSON.Remarks=""
		
		if flag=1
		{
			// 修改时，只修改检验信息表中，有关检验报告的数据
			d ##class(web.CDSS.MachineLearning.Inteplatform).SaveLabJsonInfo(labInfoJSON.%ToJSON())
			s result.success="true"
		}
		else
		{
			// 先将检验项目保存到检验信息表中
			s labInfoObj=##class(WDT.CDSS.LabInfo).%New()
			s labInfoObj.IDNO=labInfoJSON.IDNO
			s labInfoObj.PatientDR=labInfoJSON.PatientDR
			s labInfoObj.VisitID=labInfoJSON.VisitID
			s labInfoObj.VisitType=labInfoJSON.VisitType
			s labInfoObj.GroupFlag=labInfoJSON.GroupFlag
			s labInfoObj.InspectionCode=labInfoJSON.InspectionCode
			s labInfoObj.InspectionName=labInfoJSON.InspectionName
			s labInfoObj.ProjectName=labInfoJSON.InspectionName
			s labInfoObj.LabItemCode=resultData.LabItemCode
			s labInfoObj.LabItemName=resultData.LabItemName
			s sc=labInfoObj.%Save()
			if $$$ISOK(sc)
			{
				// 保存检验信息的检验报告
				d ##class(web.CDSS.MachineLearning.Inteplatform).SaveLabJsonInfo(labInfoJSON.%ToJSON())
				s result.success="true"
			}
			else
			{
				s result.success="false"
				s result.errorinfo=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
			d labInfoObj.%Close()
		}
		d pObj.%Close()
		d obj.%Close()
	}
	q result
SaveLabInfoERROR
	if ($d(labInfoObj)>0)
	{
		s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检验信息表","web.CDSS.Demo.TriggLISRDetail","SaveLabInfo",labInfoObj)
		s ^ERRORLOGINFO(logid)=$ze
		s result.success="false"
		s result.errorinfo=$ze
	}
	else
	{
		s result.success="false"
		s result.errorinfo="SaveLabInfo程序出现错误！"
	}
	q result
}

}
