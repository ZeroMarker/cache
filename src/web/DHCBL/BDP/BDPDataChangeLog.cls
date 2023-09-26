/// 名称: 码表数据日志管理
/// 编写者：基础数据平台组 sunfengchao
/// 编写日期: 2013-1-29
Class web.DHCBL.BDP.BDPDataChangeLog Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function:获取服务器IP
/// Creator:  sunfengchao
/// CreateDate: 2018-1-31
ClassMethod ServerIP()
{
    n (%request)
    Set SERVER=""
    if $d(%request)&&(%request.CgiEnvs("LOCAL_ADDR")){
        Set SERVER = %request.CgiEnvs("LOCAL_ADDR") ;%request.CgiEnvs("SERVER_ADDR")
    }else{
        Set SERVER = $p($zu(54,13,$zu(54,0)),",")
    }
    Quit SERVER
}

/// Function: 用来获得当前客户端的IP
/// CreateDate: 2022-05-12
/// Creator:  sunfengchao 
ClassMethod ClientIP()
{
    Set ClientIP=""
    if $d(%request)&&$d(%request.CgiEnvs("REMOTE_ADDR")){
        Set ClientIP = %request.CgiEnvs("REMOTE_ADDR")
    }
    if $d(%session),$d(%session.Data("LOGON.SSUSERLOGINID")){
        Set LoginId = %session.Data("LOGON.SSUSERLOGINID")
        if LoginId'="" Set ClientIP = $p($g(^SST("LOG",LoginId,"ADDR")),"^",1)
    }
    else
    {
        if $d(%session),$d(%session.Data("REMOTE_ADDR")){ 
            Set ClientIP = $g(%session.Data("REMOTE_ADDR"))
        }
    } 
    Quit ClientIP
}

/// Function: 设置日志标识ID 用于标记有关联关系的日志数据
/// Creator:  sunfengchao
/// CreateDate: 2018-1-31
ClassMethod SetLogFlagID()
{
    n (%session)
    s IPAddress=##class(web.DHCBL.BDP.BDPDataChangeLog).ClientIP()
    s ProdureID=$Job 
    s LogFlagID=$i(^BDPChangeLogLogD)
    if ($d(%session))
    {
      s LogUser=$Get(%session.Data("LOGON.USERID"))
      s LogInfo=IPAddress_"+"_ProdureID_"+"_LogUser
    }
    else{
        s LogInfo=IPAddress_"+"_ProdureID 
    }
    s ^TMP("BDPLog",LogInfo)=LogFlagID
}

/// Function: 设置日志标识ID 用于标记有关联关系的日志数据
/// Creator:  sunfengchao
/// CreateDate: 2018-1-31
ClassMethod GetLogFlagID()
{
    n (%session)
    s IPAddress=##class(web.DHCBL.BDP.BDPDataChangeLog).ClientIP()
    s ProdureID=$Job
    if ($d(%session))
    {
      s LogUser=$Get(%session.Data("LOGON.USERID"))
      s LogInfo=IPAddress_"+"_ProdureID_"+"_LogUser
    }
    else{
        s LogInfo=IPAddress_"+"_ProdureID 
    } 
    q $g(^TMP("BDPLog",LogInfo))
}

ClassMethod KillLogFlagID()
{
    n (%session)
    s IPAddress=##class(web.DHCBL.BDP.BDPDataChangeLog).ClientIP()
    s ProdureID=$Job
    if ($d(%session))
    {
      s LogUser=$Get(%session.Data("LOGON.USERID"))
      s LogInfo=IPAddress_"+"_ProdureID_"+"_LogUser
    }
    else{
        s LogInfo=IPAddress_"+"_ProdureID 
    }
    k ^TMP("BDPLog",LogInfo)
}

/// Function: 根据条件去删除ID数据
/// Creator:  sunfengchao
/// CreateDate: 2018-1-31
/// w ##class(web.DHCBL.BDP.BDPDataChangeLog).ExecuteKillGlobal(11424)   
ClassMethod ExecuteKillGlobal(RowId As %String) As %String
{
    n (%session,RowId)
    ;没有日期索引 只能按id去删除 日期 之前的所有日志数据
    q:RowId="" ""
    s start=0
    s start=$O(^User.BDPDataChangeLogD(0))
    for ID=0:1:(start+RowId-1)
    {
       if ($d(^User.BDPDataChangeLogD(ID))){
        k ^User.BDPDataChangeLogD(ID)
       }
    }
    k ^User.BDPDataChangeLogI 
    d ##class(User.BDPDataChangeLog).%BuildIndices()
    q "success"
}

/// Function:判断类是否存在 1:存在 0:不存在
/// Creator:sunfengchao
/// CreateDate:2016-2-3
/// Debug： w ##class(web.DHCBL.BDP.BDPDataChangeLog).IsValidClassName("websys.Conversions")
ClassMethod IsValidClassName(classname As %String) As %Library.Boolean
{
  n (%session,classname)
  q:(classname="") 0
  s myobj=##class(%Dictionary.CompiledClass).%OpenId(classname)
  s myrtn=0
  i ($IsObject(myobj))
  {
    s myobj=""
    s myrtn = 1
  }
  q myrtn
}

/// Function:判断类方法是否存在 1:存在 0:不存在
/// Creator:sunfengchao
/// CreateDate:2016-2-3
/// Debug： w ##class(web.DHCBL.BDP.BDPDataChangeLog).IsValidMethodName("web.DHCBL.CT.CTTitle","SaveEntity")
ClassMethod IsValidMethodName(classname As %String, methodname As %String) As %Library.Boolean
{
  n (%session,classname,methodname)
  q:((classname="")||(methodname="")) 0
  s myobj=##class(%Dictionary.CompiledMethod).%OpenId(classname_"||"_methodname)
  s myrtn=0
  i ($IsObject(myobj))
  {
    s myobj=""
    s myrtn = 1
  }
  q myrtn
}

/// Function: 保存单页面查看日志数据生命周期的参数
/// Creator:  sunfengchao
/// CreateDate: 2016-10-9
ClassMethod SaveLogParams(objrowid, objdesc, classdesc = "")
{
     k ^tmp("datalogsavelogparams")
     s ^tmp("datalogsavelogparams")=objrowid_"^"_objdesc_"^"_classdesc 
     q ""
}

/// Function: 获取单页面查看日志数据生命周期的参数
/// Creator:  sunfengchao
/// CreateDate: 2016-10-11
ClassMethod GetLogParams()
{
    s result=""
    s result= $g(^tmp("datalogsavelogparams"))
    q result
}

/// Function: 清除单页面查看日志数据生命周期的参数
/// Creator:  sunfengchao
/// CreateDate: 2016-10-12
ClassMethod KillDatalogGlobal()
{
    k ^tmp("datalogsavelogparams")
    q ""
}

/// Function: 获取默认日期
/// Debug:   w ##class(web.DHCBL.BDP.BDPDataChangeLog).GetDefaultDate()
ClassMethod GetDefaultDate() As %String
{
    set reuslt=""
    set EndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)     
    set StartDate=+$h-6
    set StartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(StartDate)
    set reuslt=StartDate_"^"_EndDate     
    quit reuslt
}

/// Function：添加码表数据日志
/// Creator:  sunfengchao
/// CreatDate:2013-1-29
/// Table：   BDP_DataChangeLog
/// Other:    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("","","","","","U","")
ClassMethod SaveLog(TableName As %String, ClassName As %String, ClassNameDesc As %String, ObjectReference As %String, ObjectDesc As %String, OperateType As %String, NewValue As %String, OldValue As %String = "", LogFlagID As %String = "") As %String
{
    new (TableName,ClassName,ClassNameDesc,ObjectReference,ObjectDesc,OperateType,NewValue,OldValue,LogFlagID,%session)
    s result=""
    if (TableName="") 
    {
        s result="表名不能为空!"
    }
    elseif(ClassName="") 
    {
        s result="类名不能为空!"
    }
    elseif(ObjectReference="") 
    {
        s result="对象ID不能为空!"
    }
    elseif(OperateType="") 
    {
        s result="修改类型不能为空!"
    }
    else 
    {   
        s obj=##class(User.BDPDataChangeLog).%New()
        s obj.TableName = TableName
        s obj.ClassName = ClassName
        s obj.ClassNameDesc = ClassNameDesc    //类描述
        s obj.ObjectReference = ObjectReference
        if $l(ObjectDesc)>50 s ObjectDesc=$e(ObjectDesc,1,50)  //对象描述
        s obj.ObjectDesc = ObjectDesc  //对象描述 
        s IpAddress="",UpdateUserDR="",UpdateUserName=""
        s IPAddress=##class(web.DHCBL.BDP.BDPDataChangeLog).ClientIP()  
        if $d(%session)
        {  
            s UpdateUserDR=$Get(%session.Data("LOGON.USERID"))
        }
        if (UpdateUserDR="")
        {
            S UpdateUserDR=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
        }
        s:UpdateUserDR'="" UpdateUserName = $p($g(^SSU("SSUSR",UpdateUserDR)),"^",2) 
        s obj.IpAddress = IPAddress   
        d obj.UpdateUserDRSetObjectId(UpdateUserDR)
        s obj.UpdateUserName = UpdateUserName
        s obj.OperateType = OperateType  
        s:NewValue'="" obj.NewValue = NewValue.JsonS()
        s:OldValue'="" obj.OldValue = OldValue.JsonS()
        s obj.RelevantKey =LogFlagID  
        Ts
        s sc=obj.%Save()

        If $$$ISOK(sc) 
        {
            Tc
            s id=obj.%Id()
            d obj.%Close()
            s result=id_"^"_"添加成功!"  
            //医学知识库
            if (ClassName["User.MKB")||(ClassName["User.SDS")
            {
                //如果是知识库的类  则调知识库的日志保存方法 
                if (ClassName["User.MKB")
                {   
                    d ##class(web.DHCBL.MKB.MKBDataChangeLog).SaveLog(TableName,ClassName,ClassNameDesc,ObjectReference,ObjectDesc,OperateType,NewValue,OldValue)
                }
                ///对历史及频次记录操作
                if (OperateType="A")||(OperateType="U")
                {
                    d ##class(web.DHCBL.BDP.BDPDataFrequency).SaveData(ClassName_"^"_ObjectReference_"^"_ObjectDesc)
                    d ##class(web.DHCBL.BDP.BDPDataHistory).SaveData(ClassName_"^"_ObjectReference_"^"_ObjectDesc)
                }
                if OperateType="D"
                {
                    d ##class(web.DHCBL.BDP.BDPDataFrequency).DeleteDataStr(ClassName_"^"_ObjectReference)
                    d ##class(web.DHCBL.BDP.BDPDataHistory).DeleteDataStr(ClassName_"^"_ObjectReference)

                    if $e(ClassName,1,12)="User.MKBTerm"
                    {
                        if $l(ClassName)>12 
                        {
                            s str=$e(ClassName,13,$l(ClassName))
                            if str?1n.n
                            {
                                //术语条目删除的时候同时去删除诊断查找的频次数据TableName: User.SDSStructDiagnos
                                d ##class(web.DHCBL.BDP.BDPDataFrequency).DeleteDataStr("User.SDSStructDiagnos"_"^"_ObjectReference)
                                d ##class(web.DHCBL.BDP.BDPDataHistory).DeleteDataStr("User.SDSStructDiagnos"_"^"_ObjectReference)
                            } 
                        } 
                    }
                }

            }
            else
            {
                s Params=""
                s myobj=""
                s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCENS.EnsHISService||DHCHisInterface")
                if $IsObject(myobj)
                {
                    s Params=myobj.FormalSpec
                    ; KeyName:%String,Input...
                    if (Params["Input...")
                    {
                        d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000039",TableName,id)
                    }
                }

                ///2020-01-20 云HIS
                s flag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")
                if flag="Y"
                {
                    s myobj=##class(%Dictionary.CompiledClass).%OpenId("web.DHCBL.BDP.BDPMappingHOSP")
                    if $IsObject(myobj)
                    {
                        s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(TableName)  //获取数据共有私有类型
                        if (DataTypeFlag'="G")
                        {
                            s TableListID=$O(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(TableName,"U"),0))
                            s MappingHospFlag=""
                            s:TableListID'="" MappingHospFlag=$LISTGET($G(^User.BDPTableListD(TableListID)),12)  //是否使用公共私有数据关联医院表，User.BDPMappingHosp,默认为Y
                            if MappingHospFlag="Y"
                            {
                                //2019-06-25区域医院 私有数据添加时自动关联登录科室的医院
                                if (OperateType="A")
                                { 
                                    //私有数据类型的全部关联医院，
                                    if (NewValue.LinkHospId'="")
                                    {
                                        for LinkHospIdi=1:1:$l(NewValue.LinkHospId,"/")
                                        {
                                            S HospID=$p(NewValue.LinkHospId,"/",LinkHospIdi)  //NewValue.LinkHospId
                                            if HospID'="" D ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP(TableName,ObjectReference,HospID)    
                                        }
                                    }
                                }
                                //2019-06-25区域医院 私有数据删除时自动删除医院mapping对应关系
                                if (OperateType="D")
                                {
                                    d ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteHospitals(TableName,ObjectReference) 
                                }
                            }
                        }
                    }
                }
            }
        }
        else 
        {
            Trollback
            s result="添加失败!"
        } 
    }
    q result
}

/// CreatDate:    2014-3-26
/// Description： 添加码表数据日志,用于项目没有对象的情况,直接存JSON串。
/// Table：       User.BDPDataChangeLog
/// Other:        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("","","","","","U","{OTHLLCTLOCDR:"22",OTHLLHospitalDR:"",OTHLLParRef:"284",OTHLLRowId:"284||1",OTHLLUserGroupDR:"103"}")
ClassMethod SaveLogForOther(TableName As %String, ClassName As %String, ClassNameDesc As %String, ObjectReference As %String, ObjectDesc As %String, OperateType As %String, NewValue As %String, OldValue As %String = "", UserId As %String = "") As %String
{
    new (TableName,ClassName,ClassNameDesc,ObjectReference,ObjectDesc,OperateType,NewValue,OldValue,UserId,%session)
    s result=""
    if (TableName="") 
    {
        s result="表名不能为空!"
    }
    elseif(ClassName="") 
    {
        s result="类名不能为空!"
    }
    elseif(ObjectReference="") 
    {
        s result="对象ID不能为空!"
    }
    elseif(OperateType="") 
    {
        s result="修改类型不能为空!"
    } 
    else 
    {
        s IpAddress="",UpdateUserDR="",UpdateUserName=""
        s IpAddress=##class(web.DHCBL.BDP.BDPDataChangeLog).ClientIP() 
        if $d(%session)
        {  
           // s IpAddress = $Get(%session.Data("REMOTE_ADDR"))
            s UpdateUserDR=$Get(%session.Data("LOGON.USERID"))
        }
        if UserId'="" s UpdateUserDR=UserId
        if (UpdateUserDR="")
        {
            S UpdateUserDR=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
            
        }
        s:UpdateUserDR'="" UpdateUserName = $p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
        s ProgressID=""
        s menuCspName="" 
        s LogFlagID=..GetLogFlagID() 

        s obj=##class(User.BDPDataChangeLog).%New()
        s obj.TableName = TableName
        s obj.ClassName = ClassName
        s obj.ClassNameDesc = ClassNameDesc //类描述
        s obj.ObjectReference = ObjectReference
        if $l(ObjectDesc)>50 s ObjectDesc=$e(ObjectDesc,1,50)  //对象描述
        s obj.ObjectDesc = ObjectDesc  //对象描述
        s obj.RelevantKey =LogFlagID 
        s obj.OperateType = OperateType
        s obj.NewValue = NewValue
        s obj.OldValue = OldValue  
        s obj.IpAddress = IpAddress
        d obj.UpdateUserDRSetObjectId(UpdateUserDR)
        s obj.UpdateUserName = UpdateUserName
        
        Tstart
        s sc=obj.%Save()

        If $$$ISOK(sc) 
        {
            Tcommit
            s id=obj.%Id()
            ; 记录具有关联关系的日志索引
            if (LogFlagID'=""){
                s ^BDPChangeLogLogI("BDPLog",LogFlagID,id)=""
            }
            d obj.%Close()
            s result=id_"^"_"添加成功!" 
            if (ClassName["User.MKB")||(ClassName["User.SDS")
            {

                //如果是知识库的类  则调知识库的日志保存方法 
                if (ClassName["User.MKB")
                {
                    d ##class(web.DHCBL.MKB.MKBDataChangeLog).SaveLogForOther(TableName,ClassName,ClassNameDesc,ObjectReference,ObjectDesc,OperateType,NewValue,OldValue,UserId)
                }
                //知识库属性内容表
                if (ClassName["User.MKBTermProDetail")  
                {
                    try
                    {
                        s ObjectDesc=##class(web.Entity.MKB.MKBTermProDetail).JsonD(NewValue).MKBTPDDesc
                    }
                    catch(e)
                    {

                    }
                }
                //知识库注册属性表
                if (ClassName["User.MKBTermBaseProperty")  
                {
                    try
                    {
                        s ObjectDesc=##class(web.Entity.MKB.MKBTermBaseProperty).JsonD(NewValue).MKBTBPDesc
                    }
                    catch(e)
                    {

                    }
                } 
                //知识库属性表
                if (ClassName["User.MKBTermProperty")  
                {
                    try
                    {
                        s ObjectDesc=##class(web.Entity.MKB.MKBTermProperty).JsonD(NewValue).MKBTPDesc
                    }
                    catch(e)
                    {

                    }

                }  
                ///对历史及频次记录操作
                if (OperateType="A")||(OperateType="U")
                {

                    d ##class(web.DHCBL.BDP.BDPDataFrequency).SaveData(ClassName_"^"_ObjectReference_"^"_ObjectDesc)
                    d ##class(web.DHCBL.BDP.BDPDataHistory).SaveData(ClassName_"^"_ObjectReference_"^"_ObjectDesc)
                }
                if OperateType="D"
                {
                    d ##class(web.DHCBL.BDP.BDPDataFrequency).DeleteDataStr(ClassName_"^"_ObjectReference)
                    d ##class(web.DHCBL.BDP.BDPDataHistory).DeleteDataStr(ClassName_"^"_ObjectReference)

                    if $e(ClassName,1,12)="User.MKBTerm"
                    {
                        if $l(ClassName)>12 
                        {
                            s str=$e(ClassName,13,$l(ClassName))
                            if str?1n.n
                            {
                                //术语条目删除的时候同时去删除诊断查找的频次数据TableName: User.SDSStructDiagnos
                                d ##class(web.DHCBL.BDP.BDPDataFrequency).DeleteDataStr("User.SDSStructDiagnos"_"^"_ObjectReference)
                                d ##class(web.DHCBL.BDP.BDPDataHistory).DeleteDataStr("User.SDSStructDiagnos"_"^"_ObjectReference)
                            } 
                        } 
                    }
                }
            }
            else
            {
                s Params=""
                s myobj=""
                s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCENS.EnsHISService||DHCHisInterface")
                if $IsObject(myobj)
                {
                    s Params=myobj.FormalSpec
                    ; KeyName:%String,Input...
                    if (Params["Input...")
                    {
                        d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000039",TableName,id)
                    }
                } 
            }
        }
        else 
        {
            Trollback
            s result="添加失败!"
        }
    }
    q result
}

/// Function： 通过参数进行数据的查询 分页版
/// Creator:   sunfengchao
/// CreateDate: 2015-12-4
/// d ##class(web.DHCBL.BDP.BDPDataChangeLog).QueryByParams("","","","王","","","","","",0,20,"","","")
ClassMethod QueryByParams(ClassN As %String, OBJDESC As %String, UserDR As %String, datefrom As %String, dateto As %String, dizzyDesc As %String, OperateTypeD As %String, MenuDataStr As %String, UserClass As %String, start As %String, limit As %String, page As %String = "", rows As %String = "", MKBFlag As %String = "") As %String
{
 
 s ID="", strResult="",menuNameStr=""
 s:datefrom'="" datefrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)  
 s:dateto'="" dateto=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)
 s:datefrom="" datefrom=+$h-730 ; 默认查询近二年 
 s:dateto="" dateto=+$h
 s:dizzyDesc'="" dizzyDesc=$zcvt(dizzyDesc,"U")
 s:UserClass'="" UserClass=$zcvt(UserClass,"U")
 
 if ((rows'="")&&(page'="")){
     s limit=rows
     s start=(page-1)*limit
  }
 
 if (MenuDataStr'="")
 {
  s MenuLen=""
  s MenuDataStr=$e(MenuDataStr,2,$length(MenuDataStr)-1)
  s MenuLen=$length(MenuDataStr,",")
  s idstr="" 
  for i=1:1:MenuLen
  {
    s idstr=$p(MenuDataStr,",",i)
    s id=$p($e(idstr,2,$l(idstr)-1),":",2)
   
    s menuname="",menuCode="",meuCodeI=""
    s menuCode=$LISTGET($G(^User.BDPMenuD(id)),2)
    s menuname=$LISTGET($G(^User.BDPMenuD(id)),3)
    s:menuname="科室/病区" menuname="科室病区"
    s:menuname="医嘱项维护" menuname="医嘱项"
   
    s menuCodeI=" "_$zcvt(menuCode,"U")
    if ($d(^User.BDPMenuTableI("mt",menuCodeI))>0)
    {
      s TableNameI=""
      for
      {
        s TableNameI=$o(^User.BDPMenuTableI("mt",menuCodeI,TableNameI))
        q:TableNameI=""
        if (menuNameStr="")
        {
          s menuNameStr="{"_$tr(TableNameI," ","")_"}"
        }
        else
        {
          s menuNameStr=menuNameStr_",{"_$tr(TableNameI," ","")_"}"
        }
      }
    }
    else
    {
      ; 过滤排除掉 当选择 <医护人员>二级菜单下的其他菜单项目时,保证不将 <医护人员>的菜单项给搜索出来
      ; 后续发现有类似情况的,采用同样方式进行过滤
      if (menuCode="dhc.bdp.Care") continue
     
      if (menuNameStr="")
      {
        s menuNameStr="{"_menuname_"}"
      }
      else
      {
        s menuNameStr=menuNameStr_",{"_menuname_"}"
      }
     }
    }  
  }
   
  ; OperateTypeD 不为空
  if (OperateTypeD'="")
  {
      s count=0 
      s Date=dateto+1
      for
      { 
        s Date=$o(^User.BDPDataChangeLogI("UpdateDateIndex",Date),-1)
        q:(Date<datefrom)||(Date="")
      
        s ID=""
        for
        { 
            s ID=$o(^User.BDPDataChangeLogI("UpdateDateIndex",Date,ID),-1)
            q:ID=""
            
            s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
            if (MKBFlag=1)
            {
                 if ($zcvt(ClassName,"U")'["USER.MKB")&&($zcvt(ClassName,"U")'["USER.DHCDSS")&&($zcvt(ClassName,"U")'="USER.BDPMENU") continue
            }  
            if ($d(^User.BDPDataChangeLogI("OperateTypeIndex"," "_OperateTypeD,ID))){
            s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2) 
            s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   
            s:ClassNameDesc="社区维护" ClassNameDesc="社区"
            s:ClassNameDesc="街道维护" ClassNameDesc="街道"
            s:ClassNameDesc="地址维护" ClassNameDesc="地址"
            s ClassNameDescStr="{"_ClassNameDesc_"}"
            s:ClassName="User.BDPTableList" ClassName="User.TableList"  
            s:ClassName="User.BDPTableField" ClassName="User.TableField"
            s ClassNameStr="{"_$zcvt(ClassName,"U")_"}"
            s TableName=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableName)
            s ClassName=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassName)
    
            if (ClassName="User.BDPAlias")
            {
              s aTableName="User."_$tr($tr($tr($p($LISTGET($G(^User.BDPDataChangeLogD(ID)),10),"TableName:",2),"}",""),"""",""),"_","")
            }
            else
            {  
              s aTableName=""
            }
              s ObjectReference=$LISTGET($G(^User.BDPDataChangeLogD(ID)),4)
              s ObjectDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),12)   //新增对象描述
              s UpdateUserDR=$LISTGET($G(^User.BDPDataChangeLogD(ID)),5)
              s UpdateUserName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),6)
              S:UpdateUserDR>0 UpdateUserName=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",2)
              s:UpdateUserDR'="" UpdateUserDR=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1) //获取用户名
              
              s ClassNameDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassNameDesc)
              s ObjectReference=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectReference)
              s ObjectDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectDesc)
              s UpdateUserName=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateUserName)
              s IpAddress=$LISTGET($G(^User.BDPDataChangeLogD(ID)),13)
              if ((($$ALPHAUP^SSUTIL4(ClassNameDesc)[ClassN)||(ClassN=""))&(($zcvt(ClassName,"U")=UserClass)||(UserClass=""))&((UserDR="")||($$ALPHAUP^SSUTIL4(UpdateUserName)[UserDR)||($$ALPHAUP^SSUTIL4(UpdateUserDR)[UserDR))&((OBJDESC="")||((OBJDESC'="")&((ObjectDesc[OBJDESC)||(ObjectReference[OBJDESC))))&((menuNameStr[ClassNameStr)||(menuNameStr[ClassNameDescStr)||(menuNameStr=""))&((dizzyDesc="")||((dizzyDesc'="")&(($zcvt(ClassName,"U")[dizzyDesc)||(($zcvt(ClassNameDesc,"U")[dizzyDesc) ||($zcvt(TableName,"U")[dizzyDesc)||($zcvt(ObjectReference,"U")[dizzyDesc)||($zcvt(ObjectDesc,"U")[dizzyDesc)||(IpAddress=dizzyDesc)||(($zcvt(UpdateUserDR,"U")[dizzyDesc) ))))))
              { 
                s count=count+1
                if (count<=start) continue
                if (count<=(start+limit))
                {
                  if (strResult'="")
                  { 
                    s strResult=strResult_"^"_ID
                  }
                  else
                  { 
                    s strResult=ID
                  }    
                }
            } 
            else{ 
                continue    
            }
        }
       }
     }
  } 
  else
  {  
      ; 默认情况 
      s count=0 
      s Date=dateto+1
      for
      { 
        s Date=$o(^User.BDPDataChangeLogI("UpdateDateIndex",Date),-1)
        q:(Date<datefrom)||(Date="")
        
        s ID=""
        for
        { 
            s ID=$o(^User.BDPDataChangeLogI("UpdateDateIndex",Date,ID),-1)
            q:ID="" 
           
            s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)
            s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
            if (MKBFlag=1)
            {
                if ($zcvt(ClassName,"U")'["USER.MKB")&&($zcvt(ClassName,"U")'["USER.DHCDSS")&&($zcvt(ClassName,"U")'="USER.BDPMENU") continue
            }  
            s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   
            s:ClassNameDesc="社区维护" ClassNameDesc="社区"
            s:ClassNameDesc="街道维护" ClassNameDesc="街道"
            s:ClassNameDesc="地址维护" ClassNameDesc="地址"
            s ClassNameDescStr="{"_ClassNameDesc_"}"
            s:ClassName="User.BDPTableList" ClassName="User.TableList"  
            s:ClassName="User.BDPTableField" ClassName="User.TableField"
            s ClassNameStr="{"_$zcvt(ClassName,"U")_"}"
            s TableName=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableName)
            s ClassName=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassName)
    
            if (ClassName="User.BDPAlias")
            {
              s aTableName="User."_$tr($tr($tr($p($LISTGET($G(^User.BDPDataChangeLogD(ID)),10),"TableName:",2),"}",""),"""",""),"_","")
            }
            else
            {  
              s aTableName=""
            }
              s ObjectReference=$LISTGET($G(^User.BDPDataChangeLogD(ID)),4)
              s ObjectDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),12)   //新增对象描述
              s UpdateUserDR=$LISTGET($G(^User.BDPDataChangeLogD(ID)),5)
              s UpdateUserName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),6)
              S:UpdateUserDR>0 UpdateUserName=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",2)
              s:UpdateUserDR'="" UpdateUserDR=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1) //获取用户名
              s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9)
              s ClassNameDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassNameDesc)
              s ObjectReference=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectReference)
              s ObjectDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectDesc)
              s UpdateUserName=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateUserName) 
              s IpAddress=$LISTGET($G(^User.BDPDataChangeLogD(ID)),13)  
              if (ClassName["^") s ClassName= $P($p(ClassName,"(",1),"^",2)
              if (TableName["^") s TableName= $P($p(ClassName,"(",1),"^",2)
              if ((($$ALPHAUP^SSUTIL4(ClassNameDesc)[ClassN)||(ClassN=""))&(($zcvt(ClassName,"U")=UserClass)||(UserClass=""))&((UserDR="")||($$ALPHAUP^SSUTIL4(UpdateUserName)[UserDR)||($$ALPHAUP^SSUTIL4(UpdateUserDR)[UserDR))&((OBJDESC="")||((OBJDESC'="")&((ObjectDesc[OBJDESC)||(ObjectReference[OBJDESC))))&((menuNameStr[ClassNameStr)||(menuNameStr[ClassNameDescStr)||(menuNameStr=""))&((OperateTypeD="")||((OperateTypeD'="")&(OperateType=OperateTypeD)))&((dizzyDesc="")||((dizzyDesc'="")&(($zcvt(ClassName,"U")[dizzyDesc)||(($zcvt(ClassNameDesc,"U")[dizzyDesc) ||($zcvt(TableName,"U")[dizzyDesc)||($zcvt(ObjectReference,"U")[dizzyDesc)||($zcvt(ObjectDesc,"U")[dizzyDesc)||(IpAddress=dizzyDesc)||(($zcvt(UpdateUserDR,"U")[dizzyDesc) ))))))
              {
                s count=count+1
                if (count<=start) continue
                if (count<=(start+limit))
                {
                  if (strResult'="")
                  { 
                    s strResult=strResult_"^"_ID
                  }
                  else
                  { 
                    s strResult=ID
                  }    
                }
              }
           }
         }     
    } 
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).QueryByRowIds(strResult)
    k ^Temp("BDPDataChangelog","Count",$j)
    s ^Temp("BDPDataChangelog","Count",$j)=count
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// Function:  日志维护查询 后台分页版本
/// Creator：  sunfengchao
/// CreateDate:2015-12-4
/// Debug:     w ##class(web.DHCBL.BDP.BDPDataChangeLog).GetList("","","","","","","","","",0,20,"","","")
ClassMethod GetQuery(ClassN As %String, OBJDESC As %String, UserDR As %String, datefrom As %String, dateto As %String, dizzyDesc As %String, OperateTypeD As %String, MenuDataStr As %String, UserClass As %String, start As %String, limit As %String, page As %String = "", rows As %String = "", MKBFlag As %String = "") As %String
{
 
  s:ClassN'="" ClassN=$$ALPHAUP^SSUTIL4(ClassN) 
  s:UserDR'="" UserDR=$$ALPHAUP^SSUTIL4(UserDR) 
  s strResult="" 
  k ^TMPATA
  s strAutLog="",strAutMenu=""
  s strAutLog= ##class(web.DHCBL.Authorize.Log).DHCGetDataByDefaultSession()
  if strAutLog["limited:1"
  {
    s IDStr=$p(strAutLog,"IDS:",2)
    s countmenu=$l(IDStr,"}")
    if countmenu>2
    {
      for ti=1:1:(countmenu-2)
      {
        s str=$p(IDStr,"}",ti)
        s MENUID=$p(str,":",2)
        s menucode=$LISTGET($G(^User.BDPMenuD(MENUID)),2)
        if menucode=""  continue
        s table=0
        for
        {
          s table=$o(^User.BDPMenuTableI("mt"," "_$zcvt(menucode,"U"),table)) q:table=""
          s ^TMPATA(table)=MENUID    
        }
      }
    }   
  }
  else 
  {
    s strAutMenu= ##class(web.DHCBL.Authorize.Menu).DHCGetDataByDefaultSession()   
    if (strAutMenu'="")&(strAutMenu'="[]")
    {
      s countmenu=$l(strAutMenu,"}")
      if countmenu>1
      {
        for ti=1:1:(countmenu-1)
        {
          s str=$p(strAutMenu,"}",ti)
          s MENUID=$p(str,":",2)
          s menucode=$LISTGET($G(^User.BDPMenuD(MENUID)),2)
          if menucode=""  continue
          s table=0
          for
          {
            s table=$o(^User.BDPMenuTableI("mt"," "_$zcvt(menucode,"U"),table)) q:table=""
            s ^TMPATA(table)=MENUID   
          }
        }
      }
    }
}
 
 if ((ClassN'="")||(OBJDESC'="")||(UserDR'="")||(datefrom'="")||(dateto'="")||(dizzyDesc'="")||(OperateTypeD'="")||(MenuDataStr'="")||(UserClass'=""))
 {
   d ##class(web.DHCBL.BDP.BDPDataChangeLog).QueryByParams(ClassN,OBJDESC,UserDR,datefrom,dateto,dizzyDesc,OperateTypeD,MenuDataStr,UserClass,start,limit,page,rows,MKBFlag)
 } 
 else
 {  
  s ID="", strResult="" 
  if ((rows'="")&&(page'="")){
     s limit=rows
     s start=(page-1)*limit 
  }
 
  s count=0   
  s CurrentDate=""
  s EndDate=+$h-7
  for
  {
        s CurrentDate =$o(^User.BDPDataChangeLogI("UpdateDateIndex",CurrentDate),-1)
        q:(CurrentDate<=EndDate)||(CurrentDate="")
     
        s ID=""
        for
        {
        s ID=$o(^User.BDPDataChangeLogI("UpdateDateIndex",CurrentDate,ID),-1)
        q:ID=""
        s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
        if (MKBFlag=1)
        {
              if ($zcvt(ClassName,"U")'["USER.MKB")&&($zcvt(ClassName,"U")'["USER.DHCDSS")&&($zcvt(ClassName,"U")'="USER.BDPMENU") continue
        }       
        s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2) 
        s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   
        s:ClassNameDesc="社区维护" ClassNameDesc="社区"
        s:ClassNameDesc="街道维护" ClassNameDesc="街道"
        s:ClassNameDesc="地址维护" ClassNameDesc="地址"
        s:ClassName="User.BDPTableList" ClassName="User.TableList"  
        s:ClassName="User.BDPTableField" ClassName="User.TableField"
        s TableName=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableName)
        s ClassName=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassName)
        if (ClassName["^") s ClassName= $P($p(ClassName,"(",1),"^",2)
        if (TableName["^") s TableName=$P($p(TableName,"(",1),"^",2)
        if (TableName="^DHCJFConfig") s TableName="DHCJFConfig"
        if (ClassName="User.BDPAlias")
        {
          s aTableName="User."_$tr($tr($tr($p($LISTGET($G(^User.BDPDataChangeLogD(ID)),10),"TableName:",2),"}",""),"""",""),"_","")
        }
        else
        {  
          s aTableName=""
        }
        if ((ClassName'="")&&($d(^TMPATA(" "_$zcvt(ClassName,"U")))=1))||($g(%session.Data("LOGON.GROUPID"))=1)||((ClassName="User.BDPAlias")&((aTableName'="")&&($d(^TMPATA(" "_$zcvt(aTableName,"U")))=1))) 
        { 
          s count=count+1
          if (count<=start) continue
          if (count<=(start+limit))
          {
          s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   //新增类描述
          s ObjectReference=$LISTGET($G(^User.BDPDataChangeLogD(ID)),4)
          s ObjectDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),12)   //新增对象描述
          s UpdateUserDR=$LISTGET($G(^User.BDPDataChangeLogD(ID)),5)
          s UpdateUserName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),6)
          S:UpdateUserDR>0 UpdateUserName=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",2)
          s:UpdateUserDR'="" UpdateUserDR=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1) //获取用户名
          s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
          s:UpdateDate'="" UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)
          s UpdateTime=$LISTGET($G(^User.BDPDataChangeLogD(ID)),8)
          s:UpdateTime'="" UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime)  
          s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9)
          s IpAddress=$LISTGET($G(^User.BDPDataChangeLogD(ID)),13)
          s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),10)
          s OldValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),14)
          s NewValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(NewValue)
          s OldValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(OldValue)
          s ClassNameDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassNameDesc)
          s ObjectReference=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectReference)
          s ObjectDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectDesc)
          s UpdateUserName=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateUserName)
          
          s str="",Property="",PropertyValueOld="",PropertyValueNew="",OldValue1="",NewValue1="",oldstr="",newstr="",StrJson="" 
          if (OperateType="U")
          {
            s OldValue1=$e(OldValue,2,$length(OldValue)-1)  
            s NewValue1=$e(NewValue,2,$length(NewValue)-1)
            s oldlen=$l(OldValue1,",")
            s newlen=$l(NewValue1,",")
            for i=1:1:oldlen 
            {
               s PropertyChinese=""
               s oldstr=$p(OldValue1,",",i)
               s newstr=$p(NewValue1,",",i)
               s Property=$p(oldstr,":",1)
               s PropertyValueOld=$p(oldstr,":",2)
               s PropertyValueNew=$p(newstr,":",2)
               s PropertyValueNew=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueNew) 
               s PropertyValueOld=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueOld) 
               s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
               if (PropertyValueOld'=PropertyValueNew) 
               {
                 if (str="")
                 {
                    s str= Property_":"_PropertyValueOld_"->"_PropertyValueNew 
                  }
                  else 
                  {
                    s str=str_","_Property_":"_PropertyValueOld_"->"_PropertyValueNew
                  }
                  s StrJson=str
                  s StrJson=##class(web.DHCBL.BDP.FunLib).EvalJSON(StrJson)
                }
            } 
           if TableName["BDP_Preferences"
           { 
             if NewValue["1#"  s $p(NewValue,":",6)="""1#"",DataSplitString"
             if NewValue["0#"  s $p(NewValue,":",6)="""0#"",DataSplitString"
             if OldValue["1#"  s $p(OldValue,":",6)="""1#"",DataSplitString"
             if OldValue["0#"  s $p(OldValue,":",6)="""0#"",DataSplitString"
             s OldData=OldValue
             s NewData=NewValue
             s StrJson=OldData_" -> "_NewData
             s StrJson=##class(web.DHCBL.BDP.FunLib).EvalJSON(StrJson)
           }
       }
       else 
       {
        if ((OperateType="D")||(OperateType="A"))  
        {
          s Property=""
          s NewValue1=$e(NewValue,2,$length(NewValue)-1)
          s StrJson=##class(web.DHCBL.BDP.FunLib).EvalJSON(NewValue1)
          for i=1:1:$l(NewValue1,",") 
          {
          s PropertyChinese=""
          s newstr=$p(NewValue1,",",i)
          s Property=$p(newstr,":",1)
          s PropertyValueNew= ##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,$p(newstr,":",2))
          s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
          if (str="") 
          {
            s str=Property_":"_PropertyValueNew 
          }
          else 
          {
            s str=str_","_Property_":"_PropertyValueNew 
          }
        s StrJson=##class(web.DHCBL.BDP.FunLib).EvalJSON(str)
        if (TableName["BDP_Preferences")
        {
            if (OperateType="D") 
            {
              if NewValue["1#"  s $p(NewValue,":",5)="""1#"",DataSplitString"
              if NewValue["0#"  s $p(NewValue,":",5)="""0#"",DataSplitString"
              if OldValue["1#"  s $p(OldValue,":",5)="""1#"",DataSplitString"
              if OldValue["0#"  s $p(OldValue,":",5)="""0#"",DataSplitString"
            }
            if (OperateType="A") 
            {
               if NewValue["1#"  s $p(NewValue,":",6)="""1#"",DataSplitString"
               if NewValue["0#"  s $p(NewValue,":",6)="""0#"",DataSplitString"
               if OldValue["1#"  s $p(OldValue,":",6)="""1#"",DataSplitString"
               if OldValue["0#"  s $p(OldValue,":",6)="""0#"",DataSplitString"
            }
        }
      }
      s OldData=##class(web.DHCBL.BDP.FunLib).EvalJSON(OldValue)
      s NewData=##class(web.DHCBL.BDP.FunLib).EvalJSON(NewValue)
      }   
     } 
     if (strResult'="")
     { 
        s strResult=strResult_"^"_ID
     }
     else
     { 
        s strResult=ID
     }    
    }
   }
  }
  }
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).QueryByRowIds(strResult)
  
  k ^Temp("BDPDataChangelog","Count",$j)
  s ^Temp("BDPDataChangelog","Count",$j)=count
 }
}

ClassMethod GetList(ClassN As %String, OBJDESC As %String, UserDR As %String, datefrom As %String, dateto As %String, dizzyDesc As %String, OperateTypeD As %String, MenuDataStr As %String, UserClass As %String, start As %String, limit As %String, page As %String, rows As %String, MKBFlag As %String) As %String
{
  ;new (ClassN,OBJDESC,UserDR,datefrom, dateto, dizzyDesc,OperateTypeD, MenuDataStr,UserClass,start,limit,%Session)
  s count=0
  w "{""success"":""true"",""rows"":[" 
  d ..GetQuery(ClassN,OBJDESC,UserDR,datefrom, dateto, dizzyDesc,OperateTypeD, MenuDataStr,UserClass,start,limit,page,rows,MKBFlag)
  w "]" 
  s count=$g(^Temp("BDPDataChangelog","Count",$j))
  w ",""total"":"_""""_count_""""
  w "}"
}

/// ////////////////////////////////////////////////////////////////////////
/// Function：  通过RowID 查询日志数据,批量查询
/// Creator:    sunfengchao
/// CreateDate: 2015-12-7
/// Debug:      d ##class(web.DHCBL.BDP.BDPDataChangeLog).QueryByRowIds("16133^16132^16131^16130")
ClassMethod QueryByRowIds(strResult As %String) As %String
{
  s len=$length(strResult,"^") 
  for i=1:1:len
  {
    s ID=$p(strResult,"^",i)
    if (ID'="")
    {
    s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)
    s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
    s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   //新增类描述
    s ObjectReference=$LISTGET($G(^User.BDPDataChangeLogD(ID)),4)
    s ObjectDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),12)   //新增对象描述
    s UpdateUserDR=$LISTGET($G(^User.BDPDataChangeLogD(ID)),5)
    s UpdateUserName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),6)
    S:UpdateUserDR>0 UpdateUserName=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",2)
    s:UpdateUserDR'="" UpdateUserDR=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1) //获取用户名
    s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
    s:UpdateDate'="" UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)   
    s UpdateTime=$LISTGET($G(^User.BDPDataChangeLogD(ID)),8)
    s:UpdateTime'="" UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime)   
    s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9)
    s IpAddress=$LISTGET($G(^User.BDPDataChangeLogD(ID)),13) 
    s TableName=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableName)
    s ClassName=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassName)
    s ClassNameDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassNameDesc)
    s ObjectReference=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectReference)
    s ObjectDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectDesc)
    s UpdateUserName=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateUserName)
    if (ClassName["^") s ClassName=  $P($p(ClassName,"(",1),"^",2)
    if (TableName["^") s TableName=  $P($p(TableName,"(",1),"^",2)
    if (ID=$p(strResult,"^",1))
    {     
       w "{"
       w """ID"":"""_""_ID_""",""IpAddress"":"""_IpAddress_"""," 
       w """TableName"":"""_""_TableName_""",""ClassName"":"""_ClassName_""",""ClassNameDesc"":"""_ClassNameDesc_"""," 
       w """ObjectReference"":"""_""_ObjectReference_""",""ObjectDesc"":"""_ObjectDesc_""",""UpdateUserDR"":"""_UpdateUserDR_"""," 
       w """UpdateUserName"":"""_""_UpdateUserName_""",""UpdateDate"":"""_UpdateDate_""",""UpdateTime"":"""_UpdateTime_"""," 
       w """OperateType"":"""_""_OperateType_""""
       w "}"
     
    }
    else
    {
       w ",{"
       w """ID"":"""_""_ID_""",""IpAddress"":"""_IpAddress_"""," 
       w """TableName"":"""_""_TableName_""",""ClassName"":"""_ClassName_""",""ClassNameDesc"":"""_ClassNameDesc_"""," 
       w """ObjectReference"":"""_""_ObjectReference_""",""ObjectDesc"":"""_ObjectDesc_""",""UpdateUserDR"":"""_UpdateUserDR_"""," 
       w """UpdateUserName"":"""_""_UpdateUserName_""",""UpdateDate"":"""_UpdateDate_""",""UpdateTime"":"""_UpdateTime_"""," 
       w """OperateType"":"""_""_OperateType_""""
       w "}"
    } 
   }
  }
}

/// Function: 查看<日志数据明细>
/// Creator:  sunfengchao
/// CreateDate: 2016-1-20
/// Input:    id
/// Debugs:   w ##class(web.DHCBL.BDP.BDPDataChangeLog).GetDataDetail("1")
ClassMethod GetDataDetail(id As %String) As %String
{
    s resultStr =""
    if (id="")
    {
      q "ID为空,未查询到数据明细!"
    }
    else
    {
       s TableName=$LISTGET($G(^User.BDPDataChangeLogD(id)),2)
       s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(id)),3)
       s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(id)),9)
       s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(id)),10)
       s OldValue=$LISTGET($G(^User.BDPDataChangeLogD(id)),14)
       s NewValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(NewValue) 
       s OldValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(OldValue) 
       s TableName=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableName)
       s ClassName=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassName)
       if (ClassName["^") s ClassName=  $P($p(TableName,"(",1),"^",2)
       if (TableName["^") s TableName=  $P($p(TableName,"(",1),"^",2)
       s str="",Property="",PropertyValueOld="",PropertyValueNew="",OldValue1="",NewValue1="",oldstr="",newstr="",StrJson="" 
       if (OperateType="U")
       { 
         s OldValue1=$e(OldValue,2,$length(OldValue)-1)  
         s NewValue1=$e(NewValue,2,$length(NewValue)-1)
         s oldlen=$l(OldValue1,",")
         s newlen=$l(NewValue1,",")
       
         if TableName["BDP_Preferences"
         { 
            if NewValue["1#"  s $p(NewValue,":",6)="""1#"",DataSplitString"
            if NewValue["0#"  s $p(NewValue,":",6)="""0#"",DataSplitString"
            if OldValue["1#"  s $p(OldValue,":",6)="""1#"",DataSplitString"
            if OldValue["0#"  s $p(OldValue,":",6)="""0#"",DataSplitString" 
            s StrJson=OldValue_" -> "_NewValue
            s StrJson=##class(web.DHCBL.BDP.FunLib).EvalJSON(StrJson)    
         }  
         for j=1:1:oldlen 
         { 
             s PropertyChinese=""
             s oldstr=$p(OldValue1,",",j)
             s newstr=$p(NewValue1,",",j)
             s Property=$p(oldstr,":",1)
             s PropertyValueOld=$p(oldstr,":",2)
             s PropertyValueNew=$p(newstr,":",2)
             s PropertyValueNew=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueNew) 
             s PropertyValueOld=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueOld) 
             s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
             if (PropertyValueOld'=PropertyValueNew) 
             {
               if (str="")
               {
                  s str= Property_":"_PropertyValueOld_"->"_PropertyValueNew 
                }
                else 
                {
                  s str=str_","_Property_":"_PropertyValueOld_"->"_PropertyValueNew
                }
                s StrJson=##class(web.DHCBL.BDP.FunLib).EvalJSON(str)
            }  
         }  
       }  
     else{ 
      if ((OperateType="D")||(OperateType="A"))  
      {
        s Property=""
        s NewValue1=$e(NewValue,2,$length(NewValue)-1)
        s StrJson=NewValue1 
    
        if (TableName["BDP_Preferences")
        {
          if (OperateType="D") 
          {
            if NewValue["1#"  s $p(NewValue,":",5)="""1#"",DataSplitString"
            if NewValue["0#"  s $p(NewValue,":",5)="""0#"",DataSplitString"
            if OldValue["1#"  s $p(OldValue,":",5)="""1#"",DataSplitString"
            if OldValue["0#"  s $p(OldValue,":",5)="""0#"",DataSplitString"
          }
          if (OperateType="A") 
          {
             if NewValue["1#"  s $p(NewValue,":",6)="""1#"",DataSplitString"
             if NewValue["0#"  s $p(NewValue,":",6)="""0#"",DataSplitString"
             if OldValue["1#"  s $p(OldValue,":",6)="""1#"",DataSplitString"
             if OldValue["0#"  s $p(OldValue,":",6)="""0#"",DataSplitString"
          }
        }  
        for k=1:1:$l(NewValue1,",") 
        {
          s newstr=$p(NewValue1,",",k)
          s Property=$p(newstr,":",1)
          s PropertyValueNew= ##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,$p(newstr,":",2))
          s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
          if (str="") 
          {
            s str=Property_":"_PropertyValueNew 
          }
          else 
          {
            s str=str_","_Property_":"_PropertyValueNew 
          }
          s StrJson=str   
        } 
        s NewData=##class(web.DHCBL.BDP.FunLib).EvalJSON(NewValue) 
        s OldData=##class(web.DHCBL.BDP.FunLib).EvalJSON(OldValue)
       }
        s StrJson=##class(web.DHCBL.BDP.FunLib).EvalJSON(StrJson)
     }        
      s resultStr ="{""ID"":"""_id_""",""OldValue"":"""_OldValue_""",""NewValue"":"""_NewValue_""",""StrJson"":"""_StrJson_"""}"
   }
   q resultStr
}

/// Function: 获取Tree类型的菜单json串
/// ParentID：父ID
/// debug:    w ##class(web.DHCBL.BDP.BDPDataChangeLog).GetTreeJson("menuTreeRoot")
ClassMethod GetTreeJson(ParentID As %String) As %String
{
  if (ParentID="menuTreeRoot") s ParentID=-100000000000000
  s mySMRowID=0
  s myMenuCount=0
  s mySMSeq=0
  k myMenuArray
  
  //生成菜单索引数组
  s mySMSeq=0
  s n=0
  for 
  {
    s mySMSeq=$o(^User.BDPMenuI("ParSeqIdx",ParentID,mySMSeq))
    q:(mySMSeq="")
    s n=n+1
    s a(n)= $p(mySMSeq," ",2)
  }
  set left=1,right=n
  d:$d(a) ##class(web.DHCBL.BDP.BDPMenuDefine).QuickSort(.a,left,right) //排序
  s mySMRowID=0
  s n=0
  s mySMSeq=0
  for 
  {
    s n=$o(a(n))
    q:(n="")
    s mySMSeq=$g(a(n))
    for 
    {
      s mySMRowID=$o(^User.BDPMenuI("ParSeqIdx",ParentID," "_mySMSeq,mySMRowID))
      q:(mySMRowID="")
      s myMenuCount=myMenuCount+1
      s myMenuArray(myMenuCount)=mySMRowID
    }
  }
 
  //输出菜单JSON串
  s mySMRowID=0
  s myMenuSeq=0
  s myJsonStr="",myImage=""
  for 
  {
    s myMenuSeq=$o(myMenuArray(myMenuSeq))
    q:(myMenuSeq="")
    s mySMRowID=$g(myMenuArray(myMenuSeq))
    s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
    if $IsObject(myMenuObj) 
    {
      s myCode = myMenuObj.Code
      s myCaption = myMenuObj.Caption
      s myLinkUrl = myMenuObj.LinkUrl
      s:myMenuObj.Image'="" myImage = "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj.Image
      s myActiveFlag = myMenuObj.ActiveFlag
      s Activeflag =$p(myActiveFlag,"^",1)
      //判断是否有子菜单
      if ((myLinkUrl="")) s myChildFlag=1
      else  s myChildFlag=0
      ; 屏蔽掉没有日志的菜单项目
      // if (mySMRowID="423")||(mySMRowID="425")||(mySMRowID="468")||(mySMRowID="788")|| (mySMRowID="670")||(mySMRowID="731")||(mySMRowID="716")||(mySMRowID="545")||(mySMRowID="528")||(mySMRowID="448")||(mySMRowID="577")||(mySMRowID="391")||(mySMRowID="283")||(mySMRowID="284")||(mySMRowID="493")||(mySMRowID="435") continue
      s:(myJsonStr'="") myJsonStr=myJsonStr_","
      s myJsonStr=myJsonStr_"{"
      s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
      s myJsonStr=myJsonStr_"""icon"":"""_""_myImage_""","
      s myJsonStr=myJsonStr_"""checked"":false,"
      if (+myChildFlag'=0) 
      {
        s myJsonStr=myJsonStr_"""leaf"":false,"
        s myJsonStr=myJsonStr_"""expanded"":true"
        //获取子菜单  
      }else 
      {
        s myJsonStr=myJsonStr_"""leaf"":true"
      }
      s myJsonStr=myJsonStr_"}"    
      d myMenuObj.%Close()
    }
  }
  k myMenuArray
  s myJsonStr="["_myJsonStr_"]"
  q myJsonStr
}

/// Function:查看数据明细
/// Creator: sunfengchao
/// CreateDate: 2016-1-29
/// Debug:  d ##class(web.DHCBL.BDP.BDPDataChangeLog).ProductTable("")
ClassMethod ProductTable(id) As %String
{
  if (id="")
  {
    q "ID为空,未查询到数据明细!"
  }
  else
  { 
     w "<table  border=""1"" width=""1060px"" height=""400px"">"
     w "<tr>"  
     w "<th width=""10%"">序号</th>"
     w "<th width=""20%"">字段 </th>"
     w "<th width=""20%"">名称</th>"     
     s TableName=$LISTGET($G(^User.BDPDataChangeLogD(id)),2)
     s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(id)),3)
     s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(id)),9)
     s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(id)),10)
     s OldValue=$LISTGET($G(^User.BDPDataChangeLogD(id)),14)
     
     s NewValue= ##class(web.BDP.util.String).Replace(NewValue,"\\\","\") 
     s OldValue= ##class(web.BDP.util.String).Replace(OldValue,"\\\","\") 
     
    // s NewValue = ##class(web.BDP.util.String).Replace(NewValue,"\""","""")
     //s OldValue = ##class(web.BDP.util.String).Replace(OldValue,"\""""","""")
      
     s:ClassName="User.ArcItmMast" ClassName="User.ARCItmMast"
     if (ClassName["^") s ClassName=  $P($p(TableName,"(",1),"^",2)
     if (TableName["^") s TableName=  $P($p(TableName,"(",1),"^",2)
     s str="",Property="",PropertyValueOld="",PropertyValueNew="",OldValue1="",NewValue1="",oldstr="",newstr="",StrJson="" 
   
     if (OperateType="U")
     { 
       w "<th width=""25%"">原值</th>"
       w "<th width=""25%"">新值</th>"
       w "</tr>"
       if TableName["BDP_Preferences"
       { 
         if NewValue["1#"  s $p(NewValue,":",6)="""1#"",DataSplitString"
         if NewValue["0#"  s $p(NewValue,":",6)="""0#"",DataSplitString"
         if OldValue["1#"  s $p(OldValue,":",6)="""1#"",DataSplitString"
         if OldValue["0#"  s $p(OldValue,":",6)="""0#"",DataSplitString" 
       } 
       s OldValue1=$e(OldValue,2,$length(OldValue)-1)  
       s NewValue1=$e(NewValue,2,$length(NewValue)-1)
       s oldlen=$l(OldValue1,",")
       s newlen=$l(NewValue1,",")
  
       for j=1:1:oldlen 
       { 
         s PropertyChinese=""
         s oldstr=$p(OldValue1,",",j)
         s newstr=$p(NewValue1,",",j)  
         s Property=$p(oldstr,":",1)
         s:Property["""" Property=$tr(Property,"""","")
        
         if (ClassName="User.ARCItmMast")||(ClassName="User.CTConFac")
         {
          s:Property["_" Property=$tr(Property,"_","")
         }
         s PropertyValueOld="",PropertyValueNew=""
           
         s PropertyOldLen=$l(oldstr,":")
         s PropertyNewLen=$l(newstr,":")
         
         if (PropertyOldLen=2)  s PropertyValueOld=$p(oldstr,":",2) 
         if (PropertyOldLen>2)  s PropertyValueOld=$p(oldstr,":",2,PropertyOldLen)  
         
         if (PropertyNewLen=2) s PropertyValueNew=$p(newstr,":",2) 
         if (PropertyNewLen>2) s PropertyValueNew=$p(newstr,":",2,PropertyNewLen)  
        
         s PropertyValueNew=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueNew) 
         s PropertyValueOld=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueOld) 
         s PropertyValueOld=$tr(PropertyValueOld,"""","")
         s PropertyValueNew=$tr(PropertyValueNew,"""","")
         if (Property["Date") 
         {
            if ((PropertyValueNew'="")&($l(PropertyValueNew,"-")=1)&($l(PropertyValueNew,"/")=1))
            {
              s PropertyValueNew=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PropertyValueNew)  
            }
            if ((PropertyValueOld'="")&((PropertyValueOld'["-")||($l(PropertyValueOld,"-")'=3))&((PropertyValueOld'["/")||($l(PropertyValueOld,"/")'=3)))
            { 
              s:PropertyValueOld'="" PropertyValueOld=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PropertyValueOld)  
            } 
         } 
         ;时间格式的转换
         if (Property["Time")
         {   
           if (PropertyValueNew'="")&($l(PropertyValueNew,":")'=3)
           {
             if (Property="ARCIM_EffDateTime")|| (Property="ARCIMEffDateTime") 
             {
                s PropertyValueNew=$p(PropertyValueNew,"Z",2)  // 处理 药品组调用日志后 ARCIM_EffDateTime字段时间格式不对导致解析无响应 卡死界面的问题
                s PropertyValueOld=$p(PropertyValueOld,"Z",2)
             }
             s:PropertyValueNew'="" PropertyValueNew=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(PropertyValueNew)   //  
             s:PropertyValueOld'="" PropertyValueOld=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(PropertyValueOld)   //  
           }
         } 
         s:PropertyValueNew'=PropertyValueOld PropertyValueNew="<font color=red>"_PropertyValueNew_"</font>"
         s:PropertyValueNew'=PropertyValueOld PropertyValueOld="<font color=blue>"_PropertyValueOld_"</font>"
         if (PropertyValueNew'=PropertyValueOld)
         {
           w " <tr bgcolor=PowderBlue align=center valign=bottom>"
         }
         else
         {
           w "<tr>"
         }
         w "<td>"_j_"</td>"
         w "<td>"_Property_"</td>"
         w "<td>"_##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)_"</td>"
         w "<td style=""word-break:break-all"">"_PropertyValueOld_"</td>"
         w "<td style=""word-break:break-all"">"_PropertyValueNew_"</td>"
         w "</tr>"
       }  
     }  
     else
     { 
      if ((OperateType="D")||(OperateType="A"))  
      { 
        w "<th width=""25%"">数据明细</th>"
        w "</tr>"
        s Property=""
        s NewValue1=$e(NewValue,2,$length(NewValue)-1)
        s StrJson=NewValue1 
        if TableName["BDP_Preferences"
        { 
           if (OperateType="D")
           {
              if NewValue["1#"  s $p(NewValue,":",5)="""1#"",DataSplitString"
              if NewValue["0#"  s $p(NewValue,":",5)="""0#"",DataSplitString"
           }
           if (OperateType="A")
           {
             if NewValue["1#"  s $p(NewValue,":",6)="""1#"",DataSplitString"
             if NewValue["0#"  s $p(NewValue,":",6)="""0#"",DataSplitString"
           }
        }
        for k=1:1:$l(NewValue1,",") 
        {
          s newstr=$p(NewValue1,",",k)
          s Property=$p(newstr,":",1)
          s:Property["""" Property=$tr(Property,"""","")
          if (ClassName="User.ARCItmMast")||(ClassName="User.CTConFac")
          {
            s:Property["_" Property=$tr(Property,"_","")
          }
          s PropertyValueNew= ##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,$p(newstr,":",2))
          s PropertyValueOld=""
          s PropertyValueNew=$tr(PropertyValueNew,"""","")
          ; 日期格式的转换
          if (Property["Date")
          {
            if ((PropertyValueNew'="")&($l(PropertyValueNew,"-")'=3)&($l(PropertyValueNew,"/")'=3))
            {
              if (Property="ARCIM_EffDateTime")|| (Property="ARCIMEffDateTime") 
              {
                   s PropertyValueNew=$p(PropertyValueNew,"Z",2) // 处理 时间格式不对导致解析无响应 卡死界面的问题
                   s PropertyValueOld=$p(PropertyValueOld,"Z",2)
              }
              s PropertyValueNew=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PropertyValueNew)  
              s PropertyValueOld=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PropertyValueOld)  
            }
          } 
         ;时间格式的转换
         if (Property["Time")
         { 
            if (PropertyValueNew'="")&($l(PropertyValueNew,":")'=3)
            {
              s:PropertyValueNew'="" PropertyValueNew=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(PropertyValueNew)
              s:PropertyValueOld'="" PropertyValueOld=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(PropertyValueOld) 
            }
         } 
          w "<tr>"
          w "<td>"_k_"</td>"
          w "<td>"_Property_"</td>"
          w "<td>"_##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)_"</td>"
          w "<td style=""word-break:break-all"">"_PropertyValueNew_"</td>"
          w "</tr>"
        }  
       }
      }
       w "</table>"  
    }
}

/// Function: 根据日志授权及系统配置来判断是否显示按钮
/// Creator:  sunfengchao
/// CreateDate:2016-9-29
/// Desc:     demo G 1 为全部授权    
/// Debug：   w ##class(web.DHCBL.BDP.BDPDataChangeLog).IfShowLogBtn("CT_Title")
ClassMethod IfShowLogBtn(table As %String)
{
   new (table,%session)
   s result="",flag="",value="",value2=""
   ;获取是否显示日志的配置信息
   s value=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPCheckDataLog") 
   ;获取是否显示数据生命周期的配置信息
   s value2=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPCheckDataTime")
   if ((value="Y")||(value2="Y"))
   { 
       if ((value="Y")&(value2="Y"))
       {
          s result=1_"^"_1
       }
       elseif((value="Y")||(value2="N"))
       {
          s result=1_"^"_0
       }
       elseif((value="N")&(value2="Y")){
          s result=0_"^"_1
       }
       else
       {
          s result= 0_"^"_0   
       }
       
      //如果平台配置里开启显示日志功能 判断页面有没有显示的权限
       
      k ^TMPATA
      s strAutLog="",strAutMenu=""
      ///获取日志授权数据
      s strAutLog=  ##class(web.DHCBL.Authorize.Log).DHCGetDataByDefaultSession()
      if strAutLog["limited:1" //授权
      {
        s IDStr=$p(strAutLog,"IDS:",2) 
        s countmenu=$l(IDStr,"}")
        if countmenu>2
        {
              for ti=1:1:(countmenu-2)
              {
                s str=$p(IDStr,"}",ti)
                s MENUID=$p(str,":",2) // 截取到ID
                s menucode=$LISTGET($G(^User.BDPMenuD(MENUID)),2) //获取菜单名
                if menucode=""  continue
                s menutable=0
                for
                {
                  s menutable=$o(^User.BDPMenuTableI("mt"," "_$zcvt(menucode,"U"),menutable)) q:menutable=""
                  s ^TMPATA(menutable)=MENUID   /// 将菜单ID采取到临时Global里
                }
              }
                s resultstr="",ClassName=""
                s resultstr=##class(web.DHCBL.BDP.BDPExecutables).GetClassInfoByCode(table)
                s:resultstr'="" ClassName= $p(resultstr,"^",1)
                if ($g(%session.Data("LOGON.GROUPID"))=1)||((ClassName'="")&&($d(^TMPATA(" "_$zcvt(ClassName,"U")))=1)) 
                {
                  s result=result_"^"_1  
                } 
                else
                {
                  s result=result_"^"_0  
                } 
            }
        }
        else
        {
          // 没有日志授权的话 则可以显示
          s result=result_"^"_1    
        }   
       }
       else
       {
         s result="0^0^0"
       } 
    q result
}

/// Function:   获取日志数据供查询数据导入的日志
/// CreateDate: 2016-11-1
/// Creator:    sunfengchao
/// Input：     table datefrom timefrom start limit
/// Debug:      w ##class(web.DHCBL.BDP.BDPDataChangeLog).GetDataLogOfImport("CT_Title",+$h,"57516",0,10)
ClassMethod GetDataLogOfImport(table As %String, datefrom As %String, timefrom As %String, start As %String, limit As %String) As %String
{
  s ID="", strResult=""
  s:start="" start=0
  s:limit="" limit=10
  
  if datefrom=""
  {
    s datefrom=$p($g(^TMP("ImportTime",table)),"^",1)
  }
  if timefrom=""
  {
    s timefrom=$p($g(^TMP("ImportTime",table)),"^",2)
  }
 
  s count=0
  s Result=""
  for
  {
    s ID=$o(^User.BDPDataChangeLogD(ID),-1)
    q:ID=""
    s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)
    s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
    s UpdateTime=$LISTGET($G(^User.BDPDataChangeLogD(ID)),8)
    if ((TableName=table)&&(UpdateDate>=datefrom)&&(UpdateTime>=timefrom))
    {   
      s count=count+1
      if (count<=start) continue
      if (count<=(start+limit))
      {
        s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
        s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   
        s:ClassNameDesc="社区维护" ClassNameDesc="社区"
        s:ClassNameDesc="街道维护" ClassNameDesc="街道"
        s:ClassNameDesc="地址维护" ClassNameDesc="地址"
        s:ClassName="User.BDPTableList" ClassName="User.TableList"  
        s:ClassName="User.BDPTableField" ClassName="User.TableField"
        s TableName=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableName)
        s ClassName=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassName)
        if (ClassName["^") s ClassName=  $P($p(TableName,"(",1),"^",2)
        if (TableName["^") s TableName=  $P($p(TableName,"(",1),"^",2)
        s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   //新增类描述
        s ObjectReference=$LISTGET($G(^User.BDPDataChangeLogD(ID)),4)
        s ObjectDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),12)   //新增对象描述
        s UpdateUserDR=$LISTGET($G(^User.BDPDataChangeLogD(ID)),5)
        s UpdateUserName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),6)
        S:UpdateUserDR>0 UpdateUserName=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",2)
        s:UpdateUserDR'="" UpdateUserDR=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1) //获取用户名
 
        s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9)
        s IpAddress=$LISTGET($G(^User.BDPDataChangeLogD(ID)),13)
        s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),10)
        s OldValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),14)
        s NewValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(NewValue)
        s OldValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(OldValue)
        s ClassNameDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassNameDesc)
        s ObjectReference=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectReference)
        s ObjectDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectDesc)
        s UpdateUserName=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateUserName)
        
        if (count=(start+1))
        { 
         
        }
        else
        { 
           s Result=Result_","   
        }  
        s Result=Result_"{""ID"":"""_ID_""",""IpAddress"":"""_IpAddress_""",""TableName"":"""_TableName_""",""ClassName"":"""_ClassName_""",""ClassNameDesc"":"""_ClassNameDesc_""",""ObjectReference"":"""_ObjectReference_""",""ObjectDesc"":"""_ObjectDesc_""",""UpdateUserDR"":"""_UpdateUserDR_""",""UpdateUserName"":"""_UpdateUserName_""",""UpdateDate"":"""_UpdateDate_""",""UpdateTime"":"""_UpdateTime_""",""OperateType"":"""_OperateType_"""}"
           
      }
    }
  }
  s strResult= "{""success"":""true"",""data"":["_Result_"],"_"""total"":"""_count_""""_"}"
  q strResult
}

/// Function:返回按照顺序排出所有的字段值 返回串 
/// CreateDate:2016-11-9
/// Creator: sunfengchao
/// debug:   w ##class(web.DHCBL.BDP.BDPDataChangeLog).GetOrderedList("User.BDPExecutables","11525") 
ClassMethod GetOrderedList(classN As %String, id As %String) As %String
{
  s resutltstr="",storageStr="",realStorage="", resutltstr2=""
  s storageStr=##class(web.DHCBL.BDP.FindTableStructure).getMasterNameAndData(classN)
  s:storageStr'="" realStorage=$p(storageStr,"$LB(",2)
  s:realStorage'="" realStorage=$e(realStorage,1,*-1)
  s realstroagelen=$Length(realStorage,",")
  for k=1:1:realstroagelen
  {
     if (resutltstr2="")
     {
        s resutltstr2=""""""
     }
     else
     {
        s resutltstr2=resutltstr2_","""""
     }
  }
  s JsonValue=$LISTGET($G(^User.BDPDataChangeLogD(id)),10)
  s NewValue=$e(JsonValue,2,*-1)
  for i=1:1:$l(NewValue,",") 
  {
    s PropertyValueNew=""
    s newstr=$p(NewValue,",",i)
    s Property=$p(newstr,":",1)
    s PropertyValueNew=$p(newstr,":",2)  
    s order= ##class(web.DHCBL.BDP.FindTableStructure).GetPropertyPiece(classN,Property)
    s $p(resutltstr2,",",order)=PropertyValueNew
  }
 q resutltstr2
}

/// Function:查询表的结构(Index及data)
/// CreatDate:2016-11-14
/// Creator:sunfengchao
/// Input:包名,类名
/// Return:type:索引类型,indexName:索引名,indexMasterData:索引结构
/// Other: w ##class(web.DHCBL.BDP.BDPDataChangeLog).GetClassIndex("User.CTTitle")   </Description>
ClassMethod GetClassIndex(classN As %String) As %String
{
    s resultstr=""
    set dcd = ##class(%Dictionary.ClassDefinition).%OpenId(classN,0) 
    if (dcd="")  q "" 
    set dsd=dcd.Storages
    set dsdCount=dsd.Count()
 
    for j=1:1:dsdCount
    { 
        s storage = dsd.GetAt(j)
        s storageType = storage.Type
        if storageType = "%Library.CacheStorage"
        {
            s storageIndexLocation=storage.IndexLocation
            s storageDataLocation=storage.DataLocation
            s storageDatas = storage.Data      ///%Library.CacheStorage
            s storageDatasCount = storageDatas.Count()
            for y=1:1:storageDatasCount //2，子表BDPExtExecItem
            {
                s storageData=storageDatas.GetAt(y)
                s storageDataValue=storageData.Values
                s storageDataValueCount=storageDataValue.Count()
                s type="Data"   
                s indexName=storageData.Name
                s storageStructure=storageData.Structure
                if storageStructure="node"   //子表Data:BDPExtExecItemClassName:{%%PARENT}("ChildExtExecItem")(ID,0)=%%CLASSNAME
                {
                    s indexMasterData=storage.DataLocation_"(ID,0)="_storageData.Attribute
                }
                else   //listnode
                {
                    s indexSub=""
                    for x=1:1:storageDataValueCount
                    {
                        if indexSub'="" s indexSub=indexSub_","_storageDataValue.GetAt(x).Value
                        else  s indexSub=storageDataValue.GetAt(x).Value
                    }
                    s indexMasterData=storage.DataLocation_"(ID)=$LB("_indexSub_")"
                }    
            }
        }
        else
        {
            ///%CacheSQLStorage 
           
            s sqlMapsID = storage.SQLMaps 
            s sqlMapsCount=sqlMapsID.Count()
            for i=1:1:sqlMapsCount
            {
                set sqlMapID=sqlMapsID.GetAt(i)
                set type=sqlMapID.Type
                set indexName=sqlMapID.Name
                set indexSub=##class(web.DHCBL.BDP.FindTableStructure).getIndexSubStr(sqlMapID.Subscripts)
                set indexMasterData=sqlMapID.Global_indexSub
                if (resultstr="")
                { 
                    s resultstr=indexName_"#"_indexMasterData   
                }
                else
                {
                    s resultstr=resultstr_"&"_indexName_"#"_indexMasterData
                }
              
            }
        }
      
    }
   
  /// 循环结束
    if (storageType'="%Library.CacheStorage") 
    {
         Quit resultstr
    }
    else
    {
    s indexDefinitions = dcd.Indices
    s indicesCount = indexDefinitions.Count()
   
    for i=1:1:indicesCount
    {
        s indexDefinition = indexDefinitions.GetAt(i)
        s type="Index"
        s indexName=indexDefinition.Name
        s indexMasterData = storageIndexLocation_"("""_indexName_""","_indexDefinition.Properties_",ID)"
        if (resultstr="")
        {
            s resultstr=indexName_"#"_indexMasterData
        }
        else
        {
            s resultstr=resultstr_"&"_indexName_"#"_indexMasterData
        }
    } 
   }  
   q resultstr
}

/// Function:获取日志数据的修改详情 
/// Retrun:日志比对信息信息
/// CreateDate:2020-12-3
/// Creator:  sunfengchao
/// w ##class(web.DHCBL.BDP.BDPDataChangeLog).GetChangeInfo(1)
ClassMethod GetChangeInfo(ID As %String) As %String
{
      s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
      s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),10)
      s OldValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),14)
      s str="",str2="",Property="",PropertyValueOld="",PropertyValueNew="",OldValue1="",NewValue1="",oldstr="",newstr=""
      s OldValue1=$e(OldValue,2,$length(OldValue)-1)  
      s NewValue1=$e(NewValue,2,$length(NewValue)-1)
      s oldlen=$l(OldValue1,",")
      s newlen=$l(NewValue1,",")
      
      for i=1:1:oldlen
      {
       s PropertyChinese=""
       s oldstr=$p(OldValue1,",",i)
       s newstr=$p(NewValue1,",",i)
       s Property=$p(oldstr,":",1)
       s PropertyValueOld=$p(oldstr,":",2)
       s PropertyValueNew=$p(newstr,":",2)
      
       s PropertyValueOld=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueOld) 
       s PropertyValueNew=##class(web.DHCBL.BDP.BDPTableList).GetPropValue(ClassName,Property,PropertyValueNew) 
       s PropertyValueOld=$tr(PropertyValueOld,"""","")
       s PropertyValueNew=$tr(PropertyValueNew,"""","")
       if (Property["Date") 
       { 
          if ((PropertyValueNew'="")&($l(PropertyValueNew,"-")=1)&($l(PropertyValueNew,"/")=1))
          {
            s:PropertyValueNew'="" PropertyValueNew=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(PropertyValueNew)
          }
          if ((PropertyValueOld'="")&($l(PropertyValueOld,"-")=1)&($l(PropertyValueOld,"/")=1))
          { 
            s:PropertyValueOld'="" PropertyValueOld=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(PropertyValueOld)
          } 
       } 
       if (Property["Time")
       {  
          if (PropertyValueNew'="")&($l(PropertyValueNew,":")'="")
          {
            s:PropertyValueNew'="" PropertyValueNew=$zt(PropertyValueNew,1) 
          }
          if (PropertyValueOld'="")&($l(PropertyValueOld,":")'="")
          {
            s:PropertyValueOld'="" PropertyValueOld=$zt(PropertyValueOld,1) 
          }
       }  
       s Property1=""
       if Property["""" s Property1=$tr(Property,"""","")  
 
       
       s Property=##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode(ClassName,Property)
      
       if (PropertyValueOld'=PropertyValueNew)
       { 
         if (str="")
         {
           s str= Property_":"_PropertyValueOld_"->"_PropertyValueNew 
         }
         else
         {
           s str=str_","_Property_":"_PropertyValueOld_"->"_PropertyValueNew 
         }
       }
      }
       s StrJson=str 
       q StrJson
}

/// Function:添加一个新用户NoSession
/// Retrun:SSUSRRowId
/// CreateDate:2021-12-07
/// Creator:  chenying
/// w ##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
ClassMethod AddUser(UserCode) As %String
{
    q:UserCode="" ""
    s SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),0))
    if (SSUSRRowId="")  //如果RowId未赋值则增加
    {
        s obj=##class(User.SSUser).%New()
        s obj.SSUSRInitials = UserCode
        s obj.SSUSRName = UserCode
        s SSUSRDefaultDeptDR=$o(^CTLOC(0))
        d obj.SSUSRDefaultDeptDRSetObjectId(SSUSRDefaultDeptDR)
        s SSUSRGroup=$o(^SSU("SSGRP",0))
        s:SSUSRGroup="" SSUSRGroup=1
        d obj.SSUSRGroupSetObjectId(SSUSRGroup)
        s SSUSRHospitalDR=""
        s:SSUSRDefaultDeptDR'="" SSUSRHospitalDR=$p($g(^CTLOC(SSUSRDefaultDeptDR)),"^",22)
        d obj.SSUSRHospitalDRSetObjectId(SSUSRHospitalDR)
        d obj.SSUSRCTLANDRSetObjectId(20)
        s obj.SSUSRPassword =##Class(web.SSUser).Encrypt(UserCode)
        s obj.SSUSRActive = "N" 
        s obj.SSUSRAdmitted ="Y"    
        s obj.SSUSRDateFrom = +$h
        s obj.SSUSRDateTo = +$h
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc){
            s SSUSRRowId = obj.%Id()
        }
        else
        {
            s SSUSRRowId =0
        }
    }
    q SSUSRRowId
}

}
