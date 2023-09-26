/// Function:流程审批调用的服务接口
/// CreateDate:2023-05-23
/// Creator:sunfengchao
Class web.DHCBL.CT.DHCINCMaterialService Extends %RegisteredObject
{

///  数据审批流 的服务器IP
Parameter ServerIP = "111.205.6.203";

/// 数据审批流的服务端口
Parameter ServerPort = 8004;

/// 数据审批流的服务超时时间 
Parameter ServerTimeOut = 60;

/// Function: 启动流程
/// CreateDate:2023-05-06
/// Creator:sunfengchao
/// Others: w ##class(web.DHCBL.CT.DHCINCMaterialService).StartTask("1","DHC_INCMaterialAudit","材料科新增材料-安全组:demo","hrp","HIS","2")
ClassMethod StartTask(bizId As %String, bizKey As %String, bizTitle As %String, procDefKey As %String, tenantId As %String, userCode As %String) As %String
{
    
    Set httpRequest=##class(%Net.HttpRequest).%New()
    Set httpRequest.Timeout=..#ServerTimeOut
    Set httpRequest.Server=..#ServerIP
    Set httpRequest.Port=..#ServerPort
    s httpRequest.Location ="api/bpm/user/startProcess" 
    Set httpRequest.ContentCharset="UTF-8" 
    d httpRequest.InsertFormData("tenantId", tenantId) 
    d httpRequest.InsertFormData("bizId", bizId) 
    d httpRequest.InsertFormData("bizKey", bizKey)  
    d httpRequest.InsertFormData("bizTitle",bizTitle)  
    d httpRequest.InsertFormData("procDefKey",procDefKey)  
    d httpRequest.InsertFormData("userCode",userCode)  
    Set retStr=httpRequest.Post() 
    s responseStr = ""  // 获取响应
    s httpResponse = httpRequest.HttpResponse   
    i $IsObject(httpResponse) {
        s streamData = httpResponse.Data
        s responseStr = streamData.Read() 
        s responseStr = $ZCVT(responseStr, "I", "UTF8")  
    } else {
        s responseStr = {"success":0, "msg":"请求超时!"}.%ToJSON()
    }
    q responseStr
}

/// Function: 获取下一个流程
/// CreateDate:2023-05-06
/// Creator:sunfengchao
/// Input:  taskId:任务号
/// Others: w ##class(web.DHCBL.CT.DHCINCMaterialService).GetNextTask("1656495023895420930")
ClassMethod GetNextTask(taskId As %String) As %String
{
    q:taskId="" {"success":0, "msg":"任务Id不能为空!"}.%ToJSON()
    Set httpRequest=##class(%Net.HttpRequest).%New()
    Set httpRequest.Timeout=..#ServerTimeOut
    Set httpRequest.Server=..#ServerIP
    Set httpRequest.Port=..#ServerPort
    Set httpRequest.ContentCharset="UTF-8" 
    Set httpRequest.ContentType="application/json"
    s httpRequest.Location ="/api/bpm/user/getNextTaskInfo"  
    d httpRequest.InsertFormData("taskId", taskId)  
    Set retStr=httpRequest.Post() 
    s responseStr = ""  // 获取响应
    s httpResponse = httpRequest.HttpResponse
    i $IsObject(httpResponse) {
        s streamData = httpResponse.Data
        s responseStr = streamData.Read() 
        s responseStr = $ZCVT(responseStr, "I", "UTF8")  
    } else {
        s responseStr = {"success":0, "msg":"请求超时!"}.%ToJSON()
    }
    q responseStr
}

/// Function:获取下一个审批流程对应的审批人
/// CreateDate:2023-05-06
/// Creator:sunfengchao
/// Input:  taskId:任务号
/// Others: w ##class(web.DHCBL.CT.DHCINCMaterialService).GetNextTaskAuditor("1656495023895420930")
ClassMethod GetNextTaskAuditor(taskId As %String) As %String
{
     s participantsData2=""
     q:taskId="" {}  
     s NextLCInfo= ##class(web.DHCBL.CT.DHCINCMaterialService).GetNextTask(taskId)  ///  获取下一个流程信息
     s NextLCInfo = $ZCVT(NextLCInfo, "I", "UTF8") 
     s NextLCInfoJsonObj=##class(%DynamicAbstractObject).%FromJSON(NextLCInfo) //将返回值json处理成对象  
     if (NextLCInfoJsonObj.message["操作成功")  // 成功
     {   
         s dynamicArray=NextLCInfoJsonObj.data 
         s taskRole=dynamicArray.%Get(0).%Get("taskRole")   
         s participantsData=dynamicArray.%Get(0).%Get("participantsData")       //可选审批人数据
         s presetParticipantsData=dynamicArray.%Get(0).%Get("presetParticipantsData")      //固定审批人数据
               
          //固定审批人数据
         s presetParticis="" 
         if (presetParticipantsData'="")
         {
             for Index=0:1:presetParticipantsData.%Size()-1
            {
             s Item=presetParticipantsData.%Get(Index)  
             s initials=Item.%Get("id")  
             if presetParticis="" s presetParticis=""_initials_"" 
             else  s presetParticis=presetParticis_""","""_initials_"" 
            }
         } 
         //可选审批人数据
         s participants="" 
         if (participantsData'="")
         {
             for Index2=0:1:participantsData.%Size()-1
            {
             s Item2=participantsData.%Get(Index)  
             s initials2=Item.%Get("id")  
             if participants="" s participants=""_initials2_"" 
             else  s participants=participants_""","""_initials2_"" 
            }
         } 
          
          /// 可选审批人数据  拼在 固定审批人后面 
         if (participants'="")&(presetParticis'="") s participantsAll = presetParticis_""","""_participants
         else  s participantsAll =presetParticis
        
         if (taskRole'="")
         {
             s participantsData2="{"""_taskRole_""":["""_participantsAll_"""]}" 
         }   
    }
    q participantsData2
}

/// Function: 获取下一个节点的执行人,然后提交任务
/// CreateDate:2023-05-11
/// Creator:sunfengchao
/// Input:  taskId:任务号  s participantsData2="{""task_1"":[""wjyh""]}" 
/// Others: w ##class(web.DHCBL.CT.DHCINCMaterialService).SubmitTask("1656584729010184193","同意")
ClassMethod SubmitTask(taskId As %String, comment As %String) As %String
{
    q:taskId="" {"success":0, "msg":"任务Id不能为空!"}.%ToJSON()  
    Set httpRequest=##class(%Net.HttpRequest).%New()
    Set httpRequest.Timeout=..#ServerTimeOut
    Set httpRequest.Server=..#ServerIP
    Set httpRequest.Port=..#ServerPort
    Set httpRequest.ContentCharset="UTF-8" 
    Set httpRequest.ContentType="application/json"
    s httpRequest.Location ="/api/bpm/user/submitTask"  
    
    d httpRequest.InsertFormData("comment",comment)   //审批意见
    d httpRequest.InsertFormData("taskId", taskId)   // 任务ID 
    s NextAuditor= ##class(web.DHCBL.CT.DHCINCMaterialService).GetNextTaskAuditor(taskId)  
    d httpRequest.InsertFormData("participantsJsonStr", NextAuditor)  //参与者  json 格式  {"task_1":['cjyh']}
    d httpRequest.InsertFormData("varsJsonStr", {})  //流程变量
    Set retStr=httpRequest.Post() 
    s responseStr = ""  // 获取响应
    s httpResponse = httpRequest.HttpResponse
    i $IsObject(httpResponse) {
        s streamData = httpResponse.Data
        s responseStr= streamData.Read() 
        s responseStr = $ZCVT(responseStr, "I", "UTF8")
    } else {
        s responseStr = {"success":0, "msg":"请求超时!"}.%ToJSON()
    }
    q responseStr
}

/// Function: 
/// CreateDate:2023-05-11
/// Creator:sunfengchao
/// Input:  taskId: 任务ID ，comment:审批意见
/// Others：w ##class(web.DHCBL.CT.DHCINCMaterialService).SubmitTask("1656585266153725954","同意")
ClassMethod SumbitOwnTask(taskId As %String, comment As %String) As %String
{
    q:taskId="" {} 
    s NextAuditor= ##class(web.DHCBL.CT.DHCINCMaterialService).GetNextTaskAuditor(taskId) 
    s varsJsonStr={}
    s responseStr= ##class(web.DHCBL.CT.DHCINCMaterialService).SubmitTask(taskId,comment,NextAuditor,varsJsonStr) b ;22 
    q responseStr
}

/// Function: 驳回到拟稿  
/// CreateDate:2023-05-19
/// Creator:sunfengchao
/// Input:  taskId:任务号
/// Others: w ##class(web.DHCBL.CT.DHCINCMaterialService).BackToInitiator("1654676970069037060")
ClassMethod BackToInitiator(taskId As %String, comment As %String) As %String
{
  
    q:taskId="" {"success":0, "msg":"任务Id不能为空!"}.%ToJSON()
    s participantsJsonStr="" //参与者
    s varsJsonStr="" //流程变量 
    Set httpRequest=##class(%Net.HttpRequest).%New()
    Set httpRequest.Timeout=..#ServerTimeOut
    Set httpRequest.Server=..#ServerIP
    Set httpRequest.Port=..#ServerPort
    Set httpRequest.ContentCharset="UTF-8" 
    Set httpRequest.ContentType="application/json"
    s httpRequest.Location ="/api/bpm/user/backToInitiator"  
    d httpRequest.InsertFormData("comment", comment)  // 驳回时填写的原因或意见
    d httpRequest.InsertFormData("taskId", taskId)   //  执行驳回操作的任务节点ID 
    d httpRequest.InsertFormData("varsJsonStr", varsJsonStr)  //流程需要的变量内容
    Set retStr=httpRequest.Post() 
    s responseStr = ""  // 获取响应
    s httpResponse = httpRequest.HttpResponse
    i $IsObject(httpResponse) {
        s streamData = httpResponse.Data
        s responseStr= streamData.Read() 
        s responseStr = $ZCVT(responseStr, "I", "UTF8")
    } 
    else 
    {
        s responseStr = {"success":0, "msg":"请求超时!"}.%ToJSON()
    }
    q responseStr
}

/// Function:驳回到指定节点  
/// CreateDate:2023-05-09
/// Creator:sunfengchao
/// Input:  taskId:任务号
/// Others: w ##class(web.DHCBL.CT.DHCINCMaterialService).BackToCustom("1654676970069037060")
ClassMethod BackToCustom(activityId As %String, comment As %String, taskId As %String, varsJsonStr As %String) As %String
{
    q:taskId="" {"success":0,"msg":"任务Id不能为空!"}.%ToJSON() 
    q:activityId="" {"success":0,"msg":"驳回目标的任务节点ID不能为空!"}.%ToJSON() 
    s participantsJsonStr="" //参与者 
    Set httpRequest=##class(%Net.HttpRequest).%New()
    Set httpRequest.Timeout=..#ServerTimeOut
    Set httpRequest.Server="111.205.6.203"
    Set httpRequest.Port=8004 
    Set httpRequest.ContentCharset="UTF-8" 
    Set httpRequest.ContentType="application/json"
    s httpRequest.Location ="/api/bpm/user/backToCustom"  
    d httpRequest.InsertFormData("activityId",activityId)   //驳回目标的任务节点ID
    d httpRequest.InsertFormData("comment", comment)  // 驳回时填写的原因或意见
    d httpRequest.InsertFormData("taskId", taskId)   //  执行驳回操作的任务节点ID 
    d httpRequest.InsertFormData("varsJsonStr", participantsJsonStr)  //流程需要的变量内容
    Set retStr=httpRequest.Post() 
    s responseStr = ""  // 获取响应
    s httpResponse = httpRequest.HttpResponse
    i $IsObject(httpResponse) {
        s streamData = httpResponse.Data
       s responseStr= streamData.Read()  
        s responseStr = $ZCVT(responseStr, "I", "UTF8")
    } else {
        s responseStr = {"success":0, "msg":"请求超时!"}.%ToJSON()
    }
    q responseStr
}

/// Function:   流程跟踪
/// CreateDate: 2023-05-18
/// Creator:    sunfengchao
/// Inupt:      procInsId
/// Output:
/// Other:      w ##class(web.DHCBL.CT.DHCINCMaterialService).GetAllNodes("1658667240074862593")
ClassMethod GetAllNodes(procInstId As %String) As %String
{
    s result="" 
    q:(procInstId="") {"success":0,"msg":"流程实例ID不能为空!"}.%ToJSON() 
    Set httpRequest=##class(%Net.HttpRequest).%New()
    Set httpRequest.Timeout=..#ServerTimeOut
    Set httpRequest.Server=..#ServerIP
    Set httpRequest.Port=..#ServerPort
    Set httpRequest.ContentCharset="UTF-8" 
    Set httpRequest.ContentType="application/json"
    s httpRequest.Location ="/api/bpm/user/traceList/"_procInstId   
    d httpRequest.InsertFormData("procInstId", procInstId)   //   
    Set retStr=httpRequest.Post() 
    s responseStr = ""  // 获取响应
    s httpResponse = httpRequest.HttpResponse
    i $IsObject(httpResponse) {
        s streamData = httpResponse.Data
       s responseStr= streamData.Read()  
        s responseStr = $ZCVT(responseStr, "I", "UTF8")
    } else {
        s responseStr = {"success":0, "msg":"请求超时!"}.%ToJSON()
    }
    q responseStr
}

/// Function:   判断是否完成审批
/// CreateDate: 2023-05-18
/// Creator:    sunfengchao
/// Inupt:      procInsId
/// Other:      w ##class(web.DHCBL.CT.DHCINCMaterialService).GetAuditResult("14")
ClassMethod GetAuditResult(ID As %String) As %String
{
   s $zt="Error"
   s result="" ,taskNameStr=""
   s isEnd="",totallen=0
   q:ID="" {"success":0, "msg":"审批表ID不能为空!"}.%ToJSON() 
   s procInstId =$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),21)  
   q:procInstId="" {"success":0,"msg":"流程实例ID不能为空!"}.%ToJSON()     
   s resultstr=  ##class(web.DHCBL.CT.DHCINCMaterialService).GetAllNodes(procInstId)
   if (resultstr'="")
   {
     s resultstr = $ZCVT(resultstr, "I", "UTF8") 
     s NextLCInfoJsonObj=##class(%DynamicAbstractObject).%FromJSON(resultstr) //将返回值json处理成对象  
     if (NextLCInfoJsonObj.code=200)  // 成功
     {   
         s dynamicArray=NextLCInfoJsonObj.data 
         s totallen =dynamicArray.%Size()-1
         for Index=0:1:totallen
         {
             s Item=dynamicArray.%Get(Index)  
             s taskName=Item.%Get("taskName")   //任务名称
             s typeName=Item.%Get("typeName")  
             s time= Item.%Get("time")    
             s isEnd= Item.%Get("isEnd")  
             s userName=Item.%Get("userName")  
             if taskName["审批" s taskName=$tr(taskName,"审批","")
             if taskName'["结束" s TaskA=taskName_typeName
             else  s TaskA=taskName
             if taskNameStr="" s taskNameStr=TaskA_"^"_userName_"^"_time_"^"_isEnd
             else  s taskNameStr=taskNameStr_"#"_TaskA_"^"_userName_"^"_time_"^"_isEnd
          }
      } 
   } 
   q (totallen+1)_"$%"_taskNameStr
Error
    s $zt=""
    q ""
}

/// Function:判断是否完成审批
/// CreateDate: 2023-05-19
/// Creator:    sunfengchao
/// Inupt:      procInsId
/// Other:      w ##class(web.DHCBL.CT.DHCINCMaterialService).GetTimeProcess(748"1658667240062593")
ClassMethod GetTimeProcess(ID As %String) As %String
{
    s result=""  
    q:ID="" {"success":0, "msg":"审批表ID不能为空!"}.%ToJSON()    
    s procInstId =$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),21)  
    q:procInstId="" {"success":0,"msg":"流程实例ID不能为空!"}.%ToJSON()   
    Set httpRequest=##class(%Net.HttpRequest).%New()
    Set httpRequest.Timeout=..#ServerTimeOut
    Set httpRequest.Server=..#ServerIP
    Set httpRequest.Port=..#ServerPort
    Set httpRequest.ContentCharset="UTF-8" 
    Set httpRequest.ContentType="application/json"
    s httpRequest.Location ="/api/bpm/process/inst/traceList/"_procInstId   //    
    Set retStr=httpRequest.Post() 
    s responseStr = ""  // 获取响应
    s httpResponse = httpRequest.HttpResponse
    i $IsObject(httpResponse) {
        s streamData = httpResponse.Data
       s responseStr= streamData.Read()  
        s responseStr = $ZCVT(responseStr, "I", "UTF8")
    } else {
        s responseStr = {"success":0, "msg":"请求超时!"}.%ToJSON()
    }
    q responseStr
}

/// Function:   获取下一个数据节点 
/// CreateDate: 2023-05-18
/// Creator:    sunfengchao
/// Inupt:      ID  http://111.205.6.203:8004/api/bpm/user/current-task-info?procInstId=1659115205021265922
/// Other:      w ##class(web.DHCBL.CT.DHCINCMaterialService).GetNextNode("14")
ClassMethod GetNextNode(ID As %String) As %String
{
    s $zt="Error"
    s result=""  
    q:ID="" {"success":0, "msg":"审批表ID不能为空!"}.%ToJSON()      
    s procInstId =$lg($g(^CT.BDP.CT.DHCINCMaterialAuditD(ID)),21)  
    q:(procInstId="") {"success":0,"msg":"流程实例ID不能为空!"}.%ToJSON()   
    Set httpRequest=##class(%Net.HttpRequest).%New()
    Set httpRequest.Timeout=..#ServerTimeOut
    Set httpRequest.Server=..#ServerIP
    Set httpRequest.Port=..#ServerPort
    Set httpRequest.ContentCharset="UTF-8" 
    Set httpRequest.ContentType="application/json" 
    s httpRequest.Location ="/api/bpm/user/current-task-info"
    d httpRequest.InsertFormData("procInstId",procInstId)      
    Set retStr=httpRequest.Post() 
    s responseStr = ""  // 获取响应
    s httpResponse = httpRequest.HttpResponse
    i $IsObject(httpResponse) {
        s streamData = httpResponse.Data
        s responseStr= streamData.Read()  
        s responseStr = $ZCVT(responseStr, "I", "UTF8")
        s NextLCObj=##class(%DynamicAbstractObject).%FromJSON(responseStr) //将返回值json处理成对象  
        if (NextLCObj.code=200)  // 成功
        {   
            s responseStr=NextLCObj.data.%Get(0).%Get("taskName")   //任务名称
        }
        
    } else {
        s responseStr = {"success":0, "msg":"请求超时!"}.%ToJSON()
    }
    q responseStr
Error
    s $zt=""
    q ""
}

}
