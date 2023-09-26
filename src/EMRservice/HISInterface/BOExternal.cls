/// 对外提供的服务
Class EMRservice.HISInterface.BOExternal Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

Parameter SERVICENAME = "External";

/*
对外提供三个方法：
方法1.1
方法名：GetTodayPrintList
参数：登记号，就诊号可为空
说明：根据登记号获取当日门诊病历的打印记录
返回：json格式的信息，id：病历记录号；ctloc：就诊科室；doc：医生；date：就诊日期；status：通过自助设备打印的日期
例：[{"id":"2461||1","ctloc":"基本外科门诊","doc":"牛备战","date":"2014-12-08 10:36:09","status":"2014-12-08 17:38:49"}]
无返回 []

方法1.2
方法名：GetTodayPrintListStream
说明:此方法与1.1方法用法一致、返回值格式一致，只不过此方法中增加参数控制查询天数，参数为SelfPrintSearchDays
为了防止部分项目查询天数过多导致报错，将此方法返回值改为流数据，建议以后项目自助机使用此接口

方法2.
方法名：GetSelfPrintParam 标准，使用全尺寸病历，返回自助打印设备的打印参数

方法3.
方法名：GetSelfPrintParam2
返回main2界面要套打实现的自助打印设备的打印参数
套打： 连云港  南方医院(argInstanceId传入空，自助机需增加 argExt:&AP=Y)

上面三个方法都可在EMRservice.BL.opInterface.cls中，对父类进行重写
*/
/// //  自助打印机  start
/// 根据登记号获取当日门诊病历的打印记录
/// 返回 insID  科室  日期时间 打印状态 （json）
/// 返回：json格式的信息，id：病历记录号；ctloc：就诊科室；doc：医生；date：就诊日期；status：通过自助设备打印的日期
/// 例：[{"id":"2461||1","ctloc":"基本外科门诊","doc":"牛备战","date":"2014-12-08 10:36:09","status":"2014-12-08 17:38:49"}]
/// w ##Class(EMRservice.HISInterface.BOExternal).GetTodayPrintList("40000888")
ClassMethod GetTodayPrintList(argPapmiNo As %String, argEpisodeID As %String = "") As %String [ WebMethod ]
{
	s ret = "[]"
	q:(""=argPapmiNo)&&(""=argEpisodeID) ret
	s ret = ##Class(EMRservice.BL.opInterface).GetTodayPrintList(argPapmiNo, argEpisodeID)
	q ret
}

ClassMethod GetTodayPrintListStream(argPapmiNo As %String, argEpisodeID As %String = "") As %GlobalCharacterStream [ WebMethod ]
{
	s ret = ##Class(%GlobalCharacterStream).%New()
	d ret.Write("[]")
	q:(""=argPapmiNo)&&(""=argEpisodeID) ret
	s ret = ##Class(EMRservice.BL.opInterface).GetTodayPrintListStream(argPapmiNo, argEpisodeID)
	q ret
}

/// 标准，使用全尺寸病历，返回自助打印设备的打印参数
ClassMethod GetSelfPrintParam(argInstanceId As %String) As %String [ WebMethod ]
{
	s ret = ##Class(EMRservice.BL.opInterface).GetSelfPrintParam(argInstanceId)
	q ret
}

/// 返回main2界面要套打实现的自助打印设备的打印参数
/// 套打 连云港  南方医院(argInstanceId传入空，自助机需增加 argExt:&AP=Y)
ClassMethod GetSelfPrintParam2(argEpisodeID As %String, argInstanceId As %String = "", argExt As %String = "") As %String [ WebMethod ]
{
	s ret = ##Class(EMRservice.BL.opInterface).GetSelfPrintParam2(argEpisodeID, argInstanceId, argExt)
	q ret
}

/// 设置已经打印的病历状态
/// w ##Class(EMRservice.HISInterface.BOExternal).SetSelfPrintStatus("2461||1")
ClassMethod InsertCustomSelfPrintLog(id As %String, ip As %String, userID As %String) As %String
{
	s $zt = "ErrorHandler"
	s result = "0"
	q:(id = "") result
	Tstart
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(id)
	if (objInstance.TheECRecord.DocumentCharacteristic = "1"){
		s eCRecordId = $p(id,"||",1)
		q:(eCRecordId = "") result
		s date = ""
		for
		{
			s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date))
			q:(date = "")
			s time = ""
			for
			{
				s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date,time)) 
				q:(time = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date,time,subId))
					q:(subId = "")
					s rowId = eCRecordId_"||"_subId
					d insertCustomSelfPrintLog
					q:(result = "0")
				}
				q:(result = "0")
			}
			q:(result = "0")
		}
	}else{
		s rowId = id
		d insertCustomSelfPrintLog
	}
	if (result = "0"){
		Trollback
	}else{
		Tcommit
	}
	q result
insertCustomSelfPrintLog
	s obj=##Class(EMRinstance.Custom.SelfPrintLog).%New()
	s obj.InstanceDataID = rowId
	s obj.PrintDate = $P($H,",",1)
	s obj.PrintTime = $P($H,",",2)
	s obj.IPAddress = ip
	s obj.UserID = userID
	s sc = obj.%Save()
	if ($$$ISOK(sc)){
		s result = "1"
	}else{
		s result = "0"
	}
	q
ErrorHandler
	Trollback
	q result
}

/// 原对外的接口，现在不在使用，日志由op.print.js中在打印完成后记录，
/// 之前有提供给第三方，防止调用失败，保留方法但是内部为空
ClassMethod InsertSelfPrintLog(id As %String) [ WebMethod ]
{
}

/// 保存补打的病历日志
/// Return：新增SelfPrintLog的json数据  或者 0(失败)
/// w ##Class(EMRservice.HISInterface.BOExternal).AddCustomSelfPrintLog("91||1","10.56.131.22","600")
ClassMethod AddCustomSelfPrintLog(id As %String, ip As %String, userID As %String) As %String
{
    s result = 0
    q:(id="")&&(ip="")&&(userID="") result
    s obj=##Class(EMRinstance.Custom.SelfPrintLog).%New()
    s obj.InstanceDataID = id
    s obj.PrintDate = $P($H,",",1)
    s obj.PrintTime = $P($H,",",2)
    s obj.IPAddress = ip
    s obj.UserID = userID
    s userName = ##class(EMRservice.BL.BLPowerUser).GetUserName(userID)
    s $zt = "SelfPrintLogErrorHandler"
    s scEMRSelfPrintLog = obj.%Save() 
    if ($$$ISOK(scEMRSelfPrintLog))
    {
        s result = "{""InstanceDataID"":"""_obj.InstanceDataID_""","
        s result = result_"""PrintDate"":"""_$zd(obj.PrintDate,3)_""","
        s result = result_"""PrintTime"":"""_$zt(obj.PrintTime)_""","
        s result = result_"""IPAddress"":"""_obj.IPAddress_""","
        s result = result_"""UserID"":"""_obj.UserID_""","
        s result = result_"""UserName"":"""_userName_"""}"
    }
    k obj
    s result = $ZSTRIP(result,"*C")
    q result
SelfPrintLogErrorHandler
    q result
}

/// //  自助打印机  end
/// 江苏省中医院医生站获取门诊病历的方法
/// w ##Class(EMRservice.HISInterface.BOExternal).ScatterDataForOP("237")
ClassMethod ScatterDataForOP(AEpisodeID As %String) As %ArrayOfDataTypes
{
	s ret = ##Class(%ArrayOfDataTypes).%New()
	
	s ACategoryInternalID="HDSD00.03"
	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") ret
	//通过术语集目录获取关联的模板ID
	s objGlossaryCategory =  ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
	q:(objGlossaryCategory="") ret
	s templateCategoryID = objGlossaryCategory.TemplateCategroyID
	q:(templateCategoryID="") ret	
	s InstanceIDS = ##Class(EMRservice.BL.BLScatterData).GetInstanceIDByTInterIDOP(AEpisodeID,templateCategoryID,ACategoryInternalID)
	s intInsCount = $ll(InstanceIDS)
	for i = 1:1:intInsCount
	{
		s AInstanceID = $lg(InstanceIDS,i)
		continue:(AInstanceID="")
		
		s signID=$O(^DHCEMRI.EMRSignI("IdxInstance", " "_AInstanceID, ""))
		continue:(signID="")
		s sign=##Class(EMRinstance.EMRSign).%OpenId(signID)
		continue:(sign.isSignValid'="1")
		s signUsrID=sign.UsrID
		s arr = ##Class(%ArrayOfDataTypes).%New()
		d ##Class(EMRservice.BL.BLScatterData).setScatterDataInArr(AEpisodeID,glossaryCategoryID,AInstanceID,.ret)
		d ret.SetAt(sign.UsrID, "signUsrID")
		
		d arr.SetAt(ret, AInstanceID)
	}
	
	q arr
}

/// edit   : Lina 2018-05-07
/// Desc   : 提供给标准版8.2医生站接口,获取指定就诊所有保存状态的病历接口
/// input  : AEpisodeID 就诊号ID
/// output : json
///          InstanceId：病历实例ID，Text：病历实例的名称
/// w ##class(EMRservice.HISInterface.BOExternal).GetSavedInstanceByEpisodeID("2161")
ClassMethod GetSavedInstanceByEpisodeID(AEpisodeID As %String) As %String
{
    s json = ""
    q:(AEpisodeID="") json
    //判断新版全局图表是否包含就诊，如果包含走四版接口
    if (##class(%Dictionary.CompiledClass).%ExistsId("EMR.GB.GlobalData") '= "0")
	{
		s HasData = $o(^EMR.GB.GlobalDataI("IdxMain",AEpisodeID,""))
		if (HasData'="")
		{
			s json = ##class(EMR.OP.BL.DocumentViewPrint).GetSavedDocumentByEpisodeID(AEpisodeID)
			q json
		}
	}
    s CategoryID = ""
    for {
        s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID))
        q:(CategoryID="")
        s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID, ""))
        s id = "" 
        for {
            s id = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID", " "_CategoryID, id))
            q:(id="")
            s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(id)
            s tempCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(emrTmpl.CategoryID)
            s cateChapter = ##class(EMRmeta.EMRTemplateCategory).%OpenId(tempCate.ParentCategoryID)
            //s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)
            s ecID = $tr(ecRecordID," ","")
            s insID = ""
            for {
                s insID = $O(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecID,emrTmpl.BindTemplateID," SAVE", insID))	   
                q:(""=insID)
                s InstanceId = ecID_"||"_insID
                s instanceObj = ##class(EMRinstance.InstanceData).%OpenId(InstanceId)
				//1,有效签名 0,未签名 或签名无效 
				s isSigned = ##Class(EMRservice.BOPrivAssist).HasValidSign(InstanceId)
                s:(json'="") json = json_","
                s json = json_"{""InstanceId"":"""_InstanceId_""","
                s json = json_"""Text"":"""_instanceObj.Title_""","
                s json = json_"""CategoryName"":"""_cateChapter.CategoryName_""","
				s json = json_"""IsSigned"":"""_isSigned_"""}"
            }
        }
    }
    q "["_json_"]"
}

/// edit   : Lina 2018-05-07
/// Desc   : 提供给标准版8.2医生站接口，通过术语集获取当前就诊指定病历的概述接口
/// input  : AEpisodeID 就诊号ID
///          AInstanceID 病历实例ID
/// output : json
///          Name：病历章节名称，Text：病历章节内容
/// w ##Class(EMRservice.HISInterface.BOExternal).ScatterDataForOPToMedic("2161","159||3")
ClassMethod ScatterDataForOPToMedic(AEpisodeID, AInstanceID As %String) As %String
{
    s ret = ""
    q:((AEpisodeID = "")||(AInstanceID = "")) ret
    s ACategoryInternalID="HDSD00.03.01"
    s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
    q:(glossaryCategoryID="") ret
    s glossaryID = ""
    for {
        s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
        q:(glossaryID = "")
        s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
        continue:(objGlossary = "")
        s internalID = objGlossary.InternalID
        s name = objGlossary.Name
        s:(name[internalID) name = $p(name," ",2)
        s content = ##Class(EMRservice.BL.BLScatterData).GetNewScatterDataByGlossaryIDOP(AEpisodeID,glossaryID,AInstanceID)
        continue:(content = "")
        d setJson
    }
    s:(ret '= "") ret = "["_ret_"]"
    q ret
setJson
    s:(ret'="") ret = ret_","
    s ret = ret_"{""Name"":"""_name_""","
    s ret = ret_"""Text"":"""_content_"""}"
}

/// edit   : Lina 2019-07-04
/// Desc   : 协和项目-通过查表EMRinstance.Custom.SelfPrintLog获取自助机打印门诊病历数量、人工补打界面打印病历数量（补打界面：emr.op.printSearch.csp）
/// input  : AStartDate 打印开始时间
///          AEndDate   打印结束时间
/// output : 打印总数，人工补打数量，自助机打印数量
/// w ##Class(EMRservice.HISInterface.BOExternal).getPrintedOPRecordNum("2018-11-04","2018-11-06")
ClassMethod getPrintedOPRecordNum(AStartDate, AEndDate As %String) As %String
{
    q:(AStartDate = "")||(AEndDate = "") "请补全入参！"
    s num = 0, selfnum = 0, handnum = 0
    s stDate = $zdh(AStartDate,3)
    s edDate = $zdh(AEndDate,3)
    for date = stDate:1:edDate {
        s rowid = ""
        for {
            s rowid = $O(^DHCEMRI.SelfPrintLogI("IdxPrintDate",date,rowid))
            q:(rowid = "")
            s obj=##Class(EMRinstance.Custom.SelfPrintLog).%OpenId(rowid)
            q:(obj = "")
            if (obj.UserID '= "")&&(obj.UserID '= "自助机") {
                s handnum = handnum + 1
            }else {
                s selfnum = selfnum + 1
            }
            s num = num + 1
        }
    }
    q "打印总数："_num_",人工补打数量："_handnum_",自助机打印数量："_selfnum
}

}
