Class DHCEPRFS.Tool.AdmQueueMgr Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	添加患者到队列——通过日期和出院科室ID
/// Debug:	d ##Class(DHCEPRFS.Tool.AdmQueueMgr).AddAdmQueueByDay("2013-5-13","13")
ClassMethod AddAdmQueueByDay(ADisDate As %String, ADeptID As %String) As %String
{
	q:(ADisDate = "") "0"
	
	s disDate = $zdh(ADisDate,3)
	
	s count = 0
	s admID = ""
	for {
		s admID = $o(^PAADMi("DischDate",disDate,admID))
		q:(admID = "")
		
		s disDeptDR=$P($g(^PAADM(admID)),"^",4)
		continue:(disDeptDR="")
		continue:(ADeptID'="")&&(disDeptDR '= ADeptID)
		//continue:(disDeptDR=462)||(disDeptDR=310)||(disDeptDR=154)||(disDeptDR=324)||(disDeptDR=19)||(disDeptDR=261)||(disDeptDR=54)
		
		s sc = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",admID,"1")
		w !, "EpisodeID:"_admID_", Status:"_sc
		
		s count = count + 1
	}
	
	w !, "Total Added EpisodeID:"_count
	w !
	
	q "1"
}

/// Desc:	添加患者到队列——通过出院时间段
/// Debug:	d ##Class(DHCEPRFS.Tool.AdmQueueMgr).AddAdmQueue("2013-5-13","2013-5-15")
ClassMethod AddAdmQueue(ADisDateStart As %String, ADisDateEnd As %String) As %String
{
	q:(ADisDateStart = "") "0"
	q:(ADisDateEnd = "") "0"
	
	s disDateStart = $zdh(ADisDateStart,3)
	s disDateEnd = $zdh(ADisDateEnd,3)
	
	for disDate=disDateStart:1:disDateEnd
	{
		s count = 0
		s admID = ""
		for {
			s admID = $o(^PAADMi("DischDate",disDate,admID))
			q:(admID = "")
		
			//就诊类型
			s PAAdmType = $p($g(^PAADM(admID)),"^",2)   
			
			if (PAAdmType = "I")
			{
				s sc = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",admID,"40")
				w !, "EpisodeID:"_admID_", Status:"_sc
		
				s count = count + 1
			}
		}

	}
	
	w !, "Total Added EpisodeID:"_count
	w !
	
	q "1"
}

/// Desc:	添加患者到队列——通过文件中就诊列表
/// Debug:	d ##Class(DHCEPRFS.Tool.AdmQueueMgr).AddAdmQueueByFile("d:\episodeID.txt","100","","N")
ClassMethod AddAdmQueueByFile(AFileName As %String, APriority As %String, ASchemeType As %String, ATaskType As %String) As %String
{
	q:(AFileName = "")||(APriority = "")||(ATaskType = "") "-1"
	s isExisted = ##class(%File).Exists(AFileName)
	if ('isExisted)
	{
		Write !,"The file is not exist!"
		quit "-1"
	}
	
	s count = 0
	
	Set fs = ##class(%FileCharacterStream).%New()
	Set fs.Filename = AFileName
	
	While 'fs.AtEnd {
		Set sRec = fs.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		
		s admID = $p(sRec, $c(9), 1)
		s sc = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",admID,APriority,ASchemeType,ATaskType)
		s:(sc '= "") count = count + 1
	}
	
	d fs.%Close()
	s fs = ""
	
	w !, "Total Added EpisodeID:"_count
	
	q "1"
}

/// Desc:	通过就诊生成队列 (排除取消的就诊)
/// Input:	ADisDateStart	- 出院日期(开始)
///         ADisDateEnd	- 出院日期(截止)
///         AAdmType	- 就诊类型(I、O、E )
///         APriority	- 优先级
///         ASchemeType - 方案类型，支持自定义表达式类型；""，默认当前生成方案；
///         ATaskType 	- 任务类型，（N、G、O、S）
///         APreviewFlag	- 预览模式.
///             0 实际执行模式，会生成队列
///             1 提供termianl的列表显示和总行数显示，不实际生成队列
///             
/// Debug:	d ##Class(DHCEPRFS.Tool.AdmQueueMgr).Add2Queue("2019-1-30","2019-4-20","I",50,"","N","1")
ClassMethod Add2Queue(ADisDateStart As %String, ADisDateEnd As %String, AAdmType As %String, APriority As %Integer, ASchemeType As %String, ATaskType As %String, APreviewFlag As %String) As %String
{
    if ((ADisDateStart = "") || (ADisDateEnd = ""))
    {
        w "日期参数错误"
        q
    }
    
    //任务类型：N、G、O、S
    if ((ATaskType'="N") && (ATaskType'="G") && (ATaskType'="O") && (ATaskType'="S"))
    {
        w "任务类型错误"
        q
    }
    
    //AdmType 限定为
    if ((AAdmType '= "I") && (AAdmType '= "O") && (AAdmType '= "E"))
    {
        w "AdmType参数错误"
        q
    }
    s disDateStart = $zdh(ADisDateStart,3)
    s disDateEnd = $zdh(ADisDateEnd,3)
    s schemeID = ##class(DHCEPRFS.BL.BLPrintScheme).GetSchemeIDBySchemeType(ASchemeType)
    s count = 0
    for date=disDateStart:1:disDateEnd
    {
        s admID = ""
        for {
            
            if (AAdmType = "I")    //住院用DischDate索引
            {
                s admID = $o(^PAADMi("DischDate",date,admID))
            }
            else
            {
                s admID = $o(^PAADMi("PAADM_AdmDate",date,admID))    //非住院用AdmDate索引
            }
            q:(admID = "")
            
            //是否是取消的就诊
            s flag = $p(^PAADM(admID),"^",20)
            continue:(flag = "c")
            continue:(flag = "C")
            
            //就诊类型
            s PAAdmType = $p($g(^PAADM(admID)),"^",2)
            continue:(PAAdmType'=AAdmType)
            s APatientID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPapmiDR(admID)
            continue:(APatientID="")
            ;获取待打印项目信息
            s SchemeJsonInfo=##class(DHCEPRFS.web.eprajax.GetPDFCreateScheme).GetPDFCreateSchemeJson(APatientID,admID,"",schemeID,"","","")
            s needPrintCount=##class(DHCEPRFS.Util.StringHelper).FromJSON(SchemeJsonInfo).GetValue("TotalCount")
            continue:needPrintCount<1    ;若待打印项目数量小于1，则跳到下一循环
            s count = count + 1
            
            s admTaskQueueID = ""
            //是否预览
            if (APreviewFlag="0")
            {
                s admTaskQueueID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",admID,APriority,ASchemeType,ATaskType)
            }
            w !, "总数:"_count_"  就诊日期:"_$zd(date,3)_"  就诊号:"_admID_"  队列ID:"_admTaskQueueID
        }

    }
    
    s items = ##class(DHCEPRFS.web.eprajax.GetPDFCreateScheme).GetPDFCreateItems(schemeID)
    s itemcount = $l(items,"^")
    s itemnames = ""
    for k=1:1:itemcount
    {
        s item = $p(items,"^",k)
        s itemid = $p(item,"#",3)
        s itemObj = ##Class(DHCEPRFS.META.MRItem).%OpenId(itemid)
        s itemname = itemObj.Name
        if (itemnames="")
        {
            s itemnames = itemname
        }
        else
        {
            s itemnames = itemnames_","_itemname
        }
    }
    w !, "生成项："_itemnames
    w !, "加入队列数:"_count
    w !
    q ""
}

}
