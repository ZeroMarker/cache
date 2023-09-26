/// Description: 号源管理
/// FileName: web.DHCPE.SourceManager.cls
/// Creator: wangguoying
/// Date: 2022-10-08
Class web.DHCPE.SourceManager Extends %RegisteredObject
{

/// DetailID的位置，不同版本的库 位置可能不同
Parameter DetailIDPosition = 30;

/// Description：查询模板内容
/// Input：
/// Return：
/// Creator： wangguoying
/// CreateDate： 2022-03-22
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.SourceManager","QueryPreTemplate",304)
Query QueryPreTemplate(LocID As %String = "") As websys.Query(ROWSPEC = "TCategory:%String:类别,TType:%String:类型,NUM_I_1:%String,NUM_O_1:%String,NUM_I_2:%String,NUM_O_2:%String,NUM_I_3:%String,NUM_O_3:%String,NUM_I_4:%String,NUM_O_4:%String,NUM_I_5:%String,NUM_O_5:%String,NUM_I_6:%String,NUM_O_6:%String,NUM_I_0:%String,NUM_O_0:%String") [ SqlProc ]
{
}

ClassMethod QueryPreTemplateExecute(ByRef qHandle As %Binary, LocID As %String = "") As %Status
{
    Set repid=$INCREMENT(^CacheTemp)
    Set ind=1
    //总数量
    Do GetTotalTemplate
    // 性别
    Do GetSexTemplate
    // VIP
    Do GetVIPTempalte
    Set qHandle=$LISTBUILD(0,repid,0)
    Quit $$$OK
GetTotalTemplate
    Set category = "总数量"
    Set type = "总数量"
    Kill NumList
    For week=0:1:6  
    {
        For cls = "I","O" {
            Set num = ..GetTemplateTotalNum(LocID,cls,week)
            Set NumList(cls,week) = num
        }
    }
    Do OutputRowData  
    Quit
GetSexTemplate
    Set category = "性别"
    For sexCode = "M","F" {
        Set type = $CASE(sexCode = "M",1:"男",:"女")
        Kill NumList
        For week=0:1:6  
        {
            For cls = "I","O" {
                Set num = ..GetTemplateSexNum(LocID,cls,week,sexCode)
                Set NumList(cls,week) = num
            }
        }
        Do OutputRowData 
    }
    Quit
GetVIPTempalte
    Set category = "VIP等级"
    Set vip = ""
    For  Set vip = $ORDER(^User.DHCPESourceTVIPTemplateI("IndOfVIPTypeParRef",vip))  Quit:vip=""  Do
    .Set vipDesc = $LISTGET($GET(^CT.PE.VIPLevelD(vip)),3)
    .Set giType = ""
    .For  Set giType = $ORDER(^User.DHCPESourceTVIPTemplateI("IndOfVIPTypeParRef",vip,giType))  Quit:giType=""  Do
    ..Set giTypeDesc = $CASE(giType,"I":"个人","G":"团体",:"不限")
    ..Set type = vipDesc_"("_giTypeDesc_")"
    ..Kill NumList
    ..For week=0:1:6  Do
    ...For clsInd = 1:1:2  Do
    ....Set cls = $PIECE("I^O","^",clsInd)
    ....Set num = ..GetTemplateVIPNum(LocID,cls,week,vip,giType)
    ....Set NumList(cls,week) = num
    ..Do OutputRowData
    Quit
OutputRowData
    Set Data=$LISTBUILD(category,type,NumList("I",1),NumList("O",1),NumList("I",2),NumList("O",2),NumList("I",3),NumList("O",3),NumList("I",4),NumList("O",4),NumList("I",5),NumList("O",5),NumList("I",6),NumList("O",6),NumList("I",0),NumList("O",0))
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

/// Description：获取模板ID
/// Input：
///               : 
/// Return：      DHC_PE_SoureTemplate
/// Creator：     wangguoying
/// CreateDate：  2022-10-09
/// Debug: w ##class(web.DHCPE.SourceManager).GetTemplateID(1)
ClassMethod GetTemplateID(LocID, CLass, WeekNum)
{
    Quit $ORDER(^User.DHCPESourceTemplateI("IndOfLocClassWeek",LocID,CLass,WeekNum,""))
}

/// Description：获取周几的总数量
/// Input：
///               LocID: 科室ID
///               Class：O：外部号源  I：内部号源
///               WeekNum: 星期 0-6
/// Return：      总数量
/// Creator：     wangguoying
/// CreateDate：  2022-03-25
/// Debug: w ##class(web.DHCPE.SourceManager).GetTemplateTotalNum(1)
ClassMethod GetTemplateTotalNum(LocID, Class, WeekNum)
{
    Set id = ..GetTemplateID(LocID,Class,WeekNum)
    Quit:id="" 0
    Set existFlag = 0
    Set total = 0
    Set startTime = 0
    For  Set startTime = $ORDER(^User.DHCPESourceTimeTemplateI("IndOfSTime",id,startTime))  Quit:startTime=""  Do
    .Set sub = ""
    .For  Set sub = $ORDER(^User.DHCPESourceTimeTemplateI("IndOfSTime",id,startTime,sub))  Quit:sub=""  Do
    ..Set num = $LISTGET(^User.DHCPESourceTemplateD(id,"STTime",sub),2)
    ..Set total = total + num
    ..Set existFlag = 1
    Quit:existFlag=0 "" //不存在返回空
    Quit total
}

/// Description：获取周几的性别总数量
/// Input：
///               LocID: 科室ID
///               WeekNum: 星期 0-6
///               SexCode: M：男 F：女
/// Return：      总数量
/// Creator：     wangguoying
/// CreateDate：  2022-03-22
/// Debug: w ##class(web.DHCPE.SourceManager).GetTemplateSexNum(304,"I",3,"M")
ClassMethod GetTemplateSexNum(LocID, Class, WeekNum, SexCode)
{
    Set id = ..GetTemplateID(LocID,Class,WeekNum)
    Quit:id="" ""
    Set total = 0
    Set existFlag = 0
    Set startTime = 0
    For  Set startTime = $ORDER(^User.DHCPESourceTimeTemplateI("IndOfSTime",id,startTime))  Quit:startTime=""  Do
    .Set sub = ""
    .For  Set sub = $ORDER(^User.DHCPESourceTimeTemplateI("IndOfSTime",id,startTime,sub))  Quit:sub=""  Do
    ..Set position = $CASE(SexCode = "M",1:3,:4)
    ..Set num =  $LISTGET(^User.DHCPESourceTemplateD(id,"STTime",sub),position)
    ..Quit:num=""
    ..Set existFlag = 1
    ..Set total = total + num
    Quit:existFlag=0 "" //不存在返回空
    Quit total
}

/// Description：获取周几的VIP总数量
/// Input：
///               LocID: 科室ID
///               WeekNum: 星期 0-6
///               VIPLevel: VIP等级
/// Return：      总数量-男性数量-女性数量
/// Creator：     wangguoying
/// CreateDate：  2022-03-22
/// Debug: w ##class(web.DHCPE.SourceManager).GetTemplateVIPNum(1)
ClassMethod GetTemplateVIPNum(LocID, Class, WeekNum, VIP, GIType)
{
    Quit:'$DATA(^User.DHCPESourceTVIPTemplateI("IndOfVIPTypeParRef",VIP,GIType)) ""
    Set id = ..GetTemplateID(LocID,Class,WeekNum)
    Quit:id="" ""
    Quit:'$DATA(^User.DHCPESourceTVIPTemplateI("IndOfVIPTypeParRef",VIP,GIType,id)) ""
    Set total = 0,mTotal = 0,fTotal=0
    Set tExist = 0 ,mExist=0,fExist=0
    Set startTime = 0
    For  Set startTime = $ORDER(^User.DHCPESourceTimeTemplateI("IndOfSTime",id,startTime))  Quit:startTime=""  Do
    .Set sub = ""
    .For  Set sub = $ORDER(^User.DHCPESourceTimeTemplateI("IndOfSTime",id,startTime,sub))  Quit:sub=""  Do
    ..Quit:'$DATA(^User.DHCPESourceTVIPTemplateI("IndOfVIPTypeParRef",VIP,GIType,id,sub))
    ..Set vipSub = $ORDER(^User.DHCPESourceTVIPTemplateI("IndOfVIPTypeParRef",VIP,GIType,id,sub,""))
    ..Set num = $LISTGET(^User.DHCPESourceTemplateD(id,"STTime",sub,"STTVIPType",vipSub),4)
    ..Set mnum = $LISTGET(^User.DHCPESourceTemplateD(id,"STTime",sub,"STTVIPType",vipSub),5)
    ..Set fnum = $LISTGET(^User.DHCPESourceTemplateD(id,"STTime",sub,"STTVIPType",vipSub),6)
    ..If num'=""  Set total = total + num  Set tExist = 1
    ..If mnum'=""  Set mTotal = mTotal + mnum  Set mExist = 1
    ..If fnum'=""  Set fTotal = fTotal + fnum  Set fExist = 1
    Quit $CASE(tExist,1:total,:"")_"-"_$CASE(mExist,1:mTotal,:"")_"-"_$CASE(fExist,1:fTotal,:"")
}

/// Description：获取模板树结构
/// Input：
///               LocID: 科室ID
///               WeekNum: 星期 0-6
/// Return：      JSONArray
/// Creator：     wangguoying
/// CreateDate：  2022-03-22
/// Debug: w ##class(web.DHCPE.SourceManager).GetTemplateWeekTree(304,3)
ClassMethod GetTemplateWeekTree(LocID, WeekNum)
{
    Set obj = ##class(web.DHCPE.HM.Entity.TreeNode).%New()
    Set obj.id = "root"
    Set obj.text = "【"_..GetWeekDesc(WeekNum)_"】"
    Set obj.iconCls = "icon-chart-sum"

    For cls = "I","O" {
        Set text = $CASE(cls,"I":"内部号源",:"外部号源")
        Set totalNum = ..GetTemplateTotalNum(LocID,cls,WeekNum)
        Set clsObj = ##class(web.DHCPE.HM.Entity.TreeNode).%New()
        Set clsObj.id = $CASE(cls,"I":"IType",:"OType")
        Set clsObj.text = "<label style='color:red;font-weight:600' >"_text_" 总数："_totalNum_"</label>"
        Set clsObj.iconCls = "con-same-height-blue"

        //性别
        Set sexObj = ##class(web.DHCPE.HM.Entity.TreeNode).%New()
        Set sexObj.id = "SEX"
        Set sexObj.text = "性别"
        Set sexObj.iconCls = "icon-stamp"
        Set sexNumObj = ##class(web.DHCPE.HM.Entity.TreeNode).%New()
        Set sexNumObj.id = "SEXNum"
        Set sexNumObj.text = "男："_..GetTemplateSexNum(LocID,cls,WeekNum,"M")_" 女："_..GetTemplateSexNum(LocID,cls,WeekNum,"F")
        Set sexNumObj.iconCls = "icon-star-yellow"    
        Do sexObj.children.Insert(sexNumObj)
        Do clsObj.children.Insert(sexObj)

        // VIP
        Set vipObj = ##class(web.DHCPE.HM.Entity.TreeNode).%New()
        Set vipObj.id = "VIP"
        Set vipObj.text = "VIP等级(总数-男-女)"
        Set vipObj.iconCls = "icon-split"
        Set parRef = ..GetTemplateID(LocID,cls,WeekNum)
        If parRef'=""
        {
            Kill VIPList
            Set startTime = 0
            For  Set startTime = $ORDER(^User.DHCPESourceTimeTemplateI("IndOfSTime",parRef,startTime))  Quit:startTime=""  Do
            .Set sub = ""
            .For  Set sub = $ORDER(^User.DHCPESourceTimeTemplateI("IndOfSTime",parRef,startTime,sub))  Quit:sub=""  Do
            ..Set vipSub = ""
            ..For  Set vipSub = $ORDER(^User.DHCPESourceTemplateD(parRef,"STTime",sub,"STTVIPType",vipSub))  Quit:vipSub=""  Do
            ...Set vip = $LISTGET(^User.DHCPESourceTemplateD(parRef,"STTime",sub,"STTVIPType",vipSub),2)
            ...Set giType = $LISTGET(^User.DHCPESourceTemplateD(parRef,"STTime",sub,"STTVIPType",vipSub),3)
            ...Set num = $LISTGET(^User.DHCPESourceTemplateD(parRef,"STTime",sub,"STTVIPType",vipSub),4)
            ...Set mNum = $LISTGET(^User.DHCPESourceTemplateD(parRef,"STTime",sub,"STTVIPType",vipSub),5)
            ...Set fNum = $LISTGET(^User.DHCPESourceTemplateD(parRef,"STTime",sub,"STTVIPType",vipSub),6)
            ...Set:num'="" VIPList(vip,giType,"T") = $GET(VIPList(vip,giType,"T"))+num
            ...Set:mNum'="" VIPList(vip,giType,"M") = $GET(VIPList(vip,giType,"M"))+mNum
            ...Set:fNum'="" VIPList(vip,giType,"F") = $GET(VIPList(vip,giType,"F"))+fNum
            Set vip = ""
            For  Set vip = $ORDER(VIPList(vip))  Quit:vip=""  Do
            .Set giType = ""
            .For  Set giType = $ORDER(VIPList(vip,giType))  Quit:giType=""  Do
            ..Set numObj = ##class(web.DHCPE.HM.Entity.TreeNode).%New()
            ..Set numObj.id = vip_"_"_giType
            ..Set numObj.text = $LISTGET($GET(^CT.PE.VIPLevelD(vip)),3)_"("_$CASE(giType,"I":"个人","G":"团体",:"不限")_")"_"："_$GET(VIPList(vip,giType,"T"))_"-"_$GET(VIPList(vip,giType,"M"))_"-"_$GET(VIPList(vip,giType,"F"))
            ..Set numObj.iconCls = "icon-star-yellow"    
            ..Do vipObj.children.Insert(numObj)
             Do clsObj.children.Insert(vipObj)
        }
        Do obj.children.Insert(clsObj)
    }   
    Quit "["_##class(ext.util.JsonObject).ObjToJson(obj)_"]"
}

/// Description：获取某天的总数量
/// Input：
///               LocID: 科室ID
///               Class：O：外部号源  I：内部号源
///               LogicalDate: 日期
/// Return：      总数量
/// Creator：     wangguoying
/// CreateDate：  2022-10-19
/// Debug: w ##class(web.DHCPE.SourceManager).GetManagerTotalNum(1)
ClassMethod GetManagerTotalNum(LocID, Class, LogicalDate)
{
    Set id = ..GetManagerID(LocID,Class,LogicalDate)
    Quit:id="" 0
    Set total = 0
    Set startTime = 0
    For  Set startTime = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",id,startTime))  Quit:startTime=""  Do
    .Set sub = ""
    .For  Set sub = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",id,startTime,sub))  Quit:sub=""  Do
    ..Set num = $LISTGET(^User.DHCPESourceManagerD(id,"SMTime",sub),2)
    ..Set total = total + num
    Quit total
}

/// Description：获取某天的性别总数量
/// Input：
///               LocID: 科室ID
///               LogicalDate: 日期
///               SexCode: M：男 F：女
/// Return：      总数量
/// Creator：     wangguoying
/// CreateDate：  2022-10-19
/// Debug: w ##class(web.DHCPE.SourceManager).GetTemplateSexNum(304,"I",3,"M")
ClassMethod GetManagerSexNum(LocID, Class, LogicalDate, SexCode)
{
    Set id = ..GetManagerID(LocID,Class,LogicalDate)
    Quit:id="" ""
    Set total = 0
    Set existFlag = 0
    Set startTime = 0
    For  Set startTime = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",id,startTime))  Quit:startTime=""  Do
    .Set sub = ""
    .For  Set sub = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",id,startTime,sub))  Quit:sub=""  Do
    ..Set position = $CASE(SexCode = "M",1:3,:4)
    ..Set num =  $LISTGET(^User.DHCPESourceManagerD(id,"SMTime",sub),position)
    ..Quit:num=""
    ..Set existFlag = 1
    ..Set total = total + num
    Quit:existFlag=0 "" //不存在返回空
    Quit total
}

/// Description：获取某天的VIP总数量
/// Input：
///               LocID: 科室ID
///               LogicalDate: 日期 
///               VIPLevel: VIP等级
/// Return：      总数量-男性数量-女性数量
/// Creator：     wangguoying
/// CreateDate：  2022-03-22
/// Debug: w ##class(web.DHCPE.SourceManager).GetManagerVIPNum(1)
ClassMethod GetManagerVIPNum(LocID, Class, LogicalDate, VIP, GIType)
{
    Quit:'$DATA(^User.DHCPESourceTimeVIPManagerI("IndOfVIPTypeParRef",VIP,GIType)) ""
    Set id = ..GetManagerID(LocID,Class,LogicalDate)
    Quit:id="" ""
    Quit:'$DATA(^User.DHCPESourceTimeVIPManagerI("IndOfVIPTypeParRef",VIP,GIType,id)) ""
    Set total = 0,mTotal = 0,fTotal=0
    Set tExist = 0 ,mExist=0,fExist=0
    Set startTime = 0
    For  Set startTime = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",id,startTime))  Quit:startTime=""  Do
    .Set sub = ""
    .For  Set sub = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",id,startTime,sub))  Quit:sub=""  Do
    ..Quit:'$DATA(^User.DHCPESourceTimeVIPManagerI("IndOfVIPTypeParRef",VIP,GIType,id,sub))
    ..Set vipSub = $ORDER(^User.DHCPESourceTimeVIPManagerI("IndOfVIPTypeParRef",VIP,GIType,id,sub,""))
    ..Set num = $LISTGET(^User.DHCPESourceManagerD(id,"SMTime",sub,"STMVIPType",vipSub),4)
    ..Set mnum = $LISTGET(^User.DHCPESourceManagerD(id,"SMTime",sub,"STMVIPType",vipSub),5)
    ..Set fnum = $LISTGET(^User.DHCPESourceManagerD(id,"SMTime",sub,"STMVIPType",vipSub),6)
    ..If num'=""  Set total = total + num  Set tExist = 1
    ..If mnum'=""  Set mTotal = mTotal + mnum  Set mExist = 1
    ..If fnum'=""  Set fTotal = fTotal + fnum  Set fExist = 1
    Quit $CASE(tExist,1:total,:"")_"-"_$CASE(mExist,1:mTotal,:"")_"-"_$CASE(fExist,1:fTotal,:"")
}

/// Description：获取限额树结构
/// Input：
///               LocID: 科室ID
///               DateStr: 日期
/// Return：      JSONArray
/// Creator：     wangguoying
/// CreateDate：  2022-10-19
/// Debug: w ##class(web.DHCPE.SourceManager).GetManagerTree(304,"2022-10-19")
ClassMethod GetManagerTree(LocID, DateStr)
{
    Set obj = ##class(web.DHCPE.HM.Entity.TreeNode).%New()
    Set obj.id = "root"
    Set obj.text = "【"_DateStr_"】"
    Set obj.iconCls = "icon-chart-sum"
    Set logicalDate = ##class(websys.Conversions).DateHtmlToLogical(DateStr)
    For cls = "I","O" {
        Set text = $CASE(cls,"I":"内部号源",:"外部号源")
        Set totalNum = ..GetManagerTotalNum(LocID,cls,logicalDate)
        Set clsObj = ##class(web.DHCPE.HM.Entity.TreeNode).%New()
        Set clsObj.id = $CASE(cls,"I":"IType",:"OType")
        Set clsObj.text = "<label style='color:red;font-weight:600' >"_text_" 总数："_totalNum_"</label>"
        Set clsObj.iconCls = "con-same-height-blue"

        //性别
        Set sexObj = ##class(web.DHCPE.HM.Entity.TreeNode).%New()
        Set sexObj.id = "SEX"
        Set sexObj.text = "性别"
        Set sexObj.iconCls = "icon-stamp"
        Set sexNumObj = ##class(web.DHCPE.HM.Entity.TreeNode).%New()
        Set sexNumObj.id = "SEXNum"
        Set sexNumObj.text = "男："_..GetManagerSexNum(LocID,cls,logicalDate,"M")_" 女："_..GetManagerSexNum(LocID,cls,logicalDate,"F")
        Set sexNumObj.iconCls = "icon-star-yellow"    
        Do sexObj.children.Insert(sexNumObj)
        Do clsObj.children.Insert(sexObj)

        // VIP
        Set vipObj = ##class(web.DHCPE.HM.Entity.TreeNode).%New()
        Set vipObj.id = "VIP"
        Set vipObj.text = "VIP等级(总数-男-女)"
        Set vipObj.iconCls = "icon-split"
        Set parRef = ..GetManagerID(LocID,cls,logicalDate)
        If parRef'=""
        {
            Kill VIPList
            Set startTime = 0
            For  Set startTime = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",parRef,startTime))  Quit:startTime=""  Do
            .Set sub = ""
            .For  Set sub = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",parRef,startTime,sub))  Quit:sub=""  Do
            ..Set vipSub = ""
            ..For  Set vipSub = $ORDER(^User.DHCPESourceManagerD(parRef,"SMTime",sub,"STMVIPType",vipSub))  Quit:vipSub=""  Do
            ...Set vip = $LISTGET(^User.DHCPESourceManagerD(parRef,"SMTime",sub,"STMVIPType",vipSub),2)
            ...Set giType = $LISTGET(^User.DHCPESourceManagerD(parRef,"SMTime",sub,"STMVIPType",vipSub),3)
            ...Set num = $LISTGET(^User.DHCPESourceManagerD(parRef,"SMTime",sub,"STMVIPType",vipSub),4)
            ...Set mNum = $LISTGET(^User.DHCPESourceManagerD(parRef,"SMTime",sub,"STMVIPType",vipSub),5)
            ...Set fNum = $LISTGET(^User.DHCPESourceManagerD(parRef,"SMTime",sub,"STMVIPType",vipSub),6)
            ...Set:num'="" VIPList(vip,giType,"T") = $GET(VIPList(vip,giType,"T"))+num
            ...Set:mNum'="" VIPList(vip,giType,"M") = $GET(VIPList(vip,giType,"M"))+mNum
            ...Set:fNum'="" VIPList(vip,giType,"F") = $GET(VIPList(vip,giType,"F"))+fNum
            Set vip = ""
            For  Set vip = $ORDER(VIPList(vip))  Quit:vip=""  Do
            .Set giType = ""
            .For  Set giType = $ORDER(VIPList(vip,giType))  Quit:giType=""  Do
            ..Set numObj = ##class(web.DHCPE.HM.Entity.TreeNode).%New()
            ..Set numObj.id = vip_"_"_giType
            ..Set numObj.text = $LISTGET($GET(^CT.PE.VIPLevelD(vip)),3)_"("_$CASE(giType,"I":"个人","G":"团体",:"不限")_")"_"："_$GET(VIPList(vip,giType,"T"))_"-"_$GET(VIPList(vip,giType,"M"))_"-"_$GET(VIPList(vip,giType,"F"))
            ..Set numObj.iconCls = "icon-star-yellow"    
            ..Do vipObj.children.Insert(numObj)
             Do clsObj.children.Insert(vipObj)
        }
        Do obj.children.Insert(clsObj)
    }   
    Quit "["_##class(ext.util.JsonObject).ObjToJson(obj)_"]"
}

ClassMethod GetWeekDesc(WeekNum)
{
    Quit $CASE(WeekNum,1:"周一",2:"周二",3:"周三",4:"周四",5:"周五",6:"周六",0:"周日")
}

/// 判断时间段是否存在  0：不存在  1：存在
ClassMethod IsExistTemaplateTime(ParRef, ID, StartTime, EndTime)
{
    Set ret = 0
    Set start = 0
    For  Set start = $ORDER(^User.DHCPESourceTimeTemplateI("IndOfSTime",ParRef,start))  Quit:(start="")||(ret=1)  Do
    .Set sub = ""
    .For  Set sub = $ORDER(^User.DHCPESourceTimeTemplateI("IndOfSTime",ParRef,start,sub))  Quit:(sub="")||(ret=1)  Do
    ..Quit:ID=(ParRef_"||"_sub)
    ..Set endTime = $LISTGET(^User.DHCPESourceTemplateD(ParRef,"STTime",sub),9)
    ..If (StartTime>=start)&&(StartTime<=endTime)  Set ret = 1 Quit
     ..If (EndTime>=start)&&(EndTime<=endTime)  Set ret = 1 Quit
    Quit ret
}

/// 判断时间段是否存在  0：不存在  1：存在
ClassMethod IsExistManagerTime(ParRef, ID, StartTime, EndTime)
{
    Set ret = 0
    Set start = 0
    For  Set start = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",ParRef,start))  Quit:(start="")||(ret=1)  Do
    .Set sub = ""
    .For  Set sub = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",ParRef,start,sub))  Quit:(sub="")||(ret=1)  Do
    ..Quit:ID=(ParRef_"||"_sub)
    ..Set endTime = $LISTGET(^User.DHCPESourceManagerD(ParRef,"SMTime",sub),9)
    ..If (StartTime>=start)&&(StartTime<=endTime)  Set ret = 1 Quit
     ..If (EndTime>=start)&&(EndTime<=endTime)  Set ret = 1 Quit
    Quit ret
}

/// Description：更新时段信息
/// Input：
///               ParRef: 父记录ID
///               ID：时段模板ID  
///               JsonParam：json格式的字符串，key为实体类属性，value为值
///               LocID：科室ID
///               UserID：更新人
///               WeekNum：星期  当父记录ID为空时必传
///               Class : 号源类别  当父记录ID为空时必传
/// Return：       模板ID 非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-03-23
/// Debug: w ##class(web.DHCPE.SourceManager).UpdateTemplateTime("15","15||3","{""PTTMaleNum"":""2"",""PTTFemaleNum"":"""",""PTTEmptyNum"":"""",""PTTRealNum"":""""}","304","11849","1")
ClassMethod UpdateTemplateTime(ParRef, ID, JsonParam, LocID, UserID, WeekNum = "", Class = "")
{
    Set ^tmpwgy("UpdateTemplateTime")=$LISTBUILD(ParRef, ID, JsonParam, LocID, UserID, WeekNum,Class )
    Quit:(ParRef="")&&((WeekNum="")||(Class="")) "-1^父记录不能为空！"
    Set $ZTRAP="UpdateTemplateTimeErr"
    Tstart
    If ParRef = ""    //不存在父表，先创建父表
    {
        Set properties = "STLocDR^STClass^STWeekNum^STUpdateUserDR"
        Set valStr = LocID_"^"_Class _"^"_ WeekNum_"^"_UserID
        Set ret = ##class(User.DHCPESourceTemplate).SaveData("",valStr,properties)
        If +ret<0 Break  Trollback  Quit ret
        Set ParRef = ret 
    }
    Break
    Set paramObj = ##class(web.DHCPE.Utils.Object).FromJSON(JsonParam)
    Set startTime = paramObj.Get("STTStartTime")
    Set endTime = paramObj.Get("STTEndTime")
    If startTime'=""
    {
        Set startTime = ##class(websys.Conversions).TimeHtmlToLogical(startTime)
        Do paramObj.Set("STTStartTime",startTime)
    }
    If endTime'=""
    {
        Set endTime = ##class(websys.Conversions).TimeHtmlToLogical(endTime)
        Do paramObj.Set("STTEndTime",endTime)
        Set exist = ..IsExistTemaplateTime(ParRef,ID,startTime,endTime)
        If exist = 1 Trollback  Quit "-1^时间段与现有时间段重叠，不允许更新！"

    }
    Set totalNum = paramObj.Get("STTNum")
    If totalNum = ""  Trollback  Quit "-1^总数量不能为空"
    Set maleNum = paramObj.Get("STTMaleNum")
    If (maleNum'="")&&(maleNum>totalNum)  Trollback  Quit "-1^男性数量【"_maleNum_"】不能大于总数量【"_totalNum_"】！"
    Set femaleNum = paramObj.Get("STTFemaleNum")
    If (femaleNum'="")&&(femaleNum>totalNum)  Trollback  Quit "-1^女性数量【"_femaleNum_"】不能大于总数量【"_totalNum_"】！"
    Set properties = "STTParRef^STTStartTime^STTEndTime^STTNum^STTMaleNum^STTFemaleNum^STTUpdateUserDR"
    Set valStr =  ParRef_"^"_startTime _"^"_endTime _"^"_ totalNum _"^"_maleNum _"^"_femaleNum _"^"_ UserID
    Break
    Set ret = ##class(User.DHCPESourceTimeTemplate).SaveData(ID,valStr,properties)
    If +ret<0  Trollback  Quit ret
    Tcommit
    Quit ParRef
UpdateTemplateTimeErr
    Set $ZTRAP=""
    Trollback
    Quit "-100^"_$ZERROR
}

/// Description：根据参数对象获取属性串和值串
/// Input：
/// Return：      属性串$C(0)值串
/// Creator：     wangguoying
/// CreateDate：  2022-03-24
/// Debug: w ##class(web.DHCPE.PreManagerJDF).CreateByTemplate(1)
ClassMethod GetParamStrByJSONObject(OBj As web.DHCPE.Utils.Object)
{
    Set properties = "" , valStr = "",i=0
    While(OBj.Next(.key,.value)){
        Set i = i +1
        If i = 1 
        {
            Set properties = key
            Set valStr = value 
        }Else{
            Set properties = properties_"^"_key
            Set valStr = valStr_"^"_value
        }
    }
    Quit properties_$CHAR(0)_valStr
}

/// Description：更新时段VIP
/// Input：
///               ParRef: 父记录ID
///               ID：时段VIPID  
///               VIPID：VIP等级_类型
///               Num: 限额总数量^男性数量^女性数量
///               UserID：更新人
/// Return：       0：成功  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-03-24
/// Debug: w ##class(web.DHCPE.PreManagerJDF).UpdateTemplateVIP("15","15||3","{""PTTMaleNum"":""2"",""PTTFemaleNum"":"""",""PTTEmptyNum"":"""",""PTTRealNum"":""""}","304","11849","1")
ClassMethod UpdateTemplateVIP(ParRef, ID, VIPID, Num, UserID)
{
    Quit:ParRef="" "-1^父记录不能为空！"
    Quit:VIPID="" "-1^VIP等级不能为空"
    Set Type = $PIECE(VIPID,"_",2)
    Set VIPID = $PIECE(VIPID,"_",1)
    Set maleNum = $PIECE(Num,"^",2)
    Set femaleNum = $PIECE(Num,"^",3)
    Set totalNum = $PIECE(Num,"^",1)
    If (maleNum'="")&&(maleNum>totalNum)  Trollback  Quit "-1^男性数量【"_maleNum_"】不能大于总数量【"_totalNum_"】！"
    If (femaleNum'="")&&(femaleNum>totalNum)  Trollback  Quit "-1^女性数量【"_femaleNum_"】不能大于总数量【"_totalNum_"】！"
    Set parTotal = $LISTGET(^User.DHCPESourceTemplateD(+ParRef,"STTime",$PIECE(ParRef,"||",2)),2)
    Quit:parTotal<totalNum "-1^类型为【"_VIPID_"_"_Type_"】的总数量【"_totalNum_"】不能大于时段总数量【"_parTotal_"】"
    Set curSub =  $ORDER(^User.DHCPESourceTVIPTemplateI("IndOfVIPTypeParRef",VIPID,Type,+ParRef,$PIECE(ParRef,"||",2),""))
    If (curSub'="")&&(ID="")  Quit "-1^该VIP等级已存在"
    If (curSub'="")&&(ID'="")&&(ID'=(ParRef_"||"_curSub)) Quit "-1^该VIP等级已存在"
    Set properties = "STTVParRef^STTVVIPLevel^STTVType^STTVNum^STTVMaleNum^STTVFemaleNum^STTVUpdateUserDR"
    Set valStr = ParRef_"^"_VIPID _"^"_ Type_"^"_totalNum _"^"_ maleNum _"^"_femaleNum _"^"_UserID
    Set ret = ##class(User.DHCPESourceTimeVIPTemplate).SaveData(ID,valStr,properties)
    Quit:+ret<0 ret
    Quit 0
}

/// Description：更新时段VIP
/// Input：
///               ParRef: 父记录ID
///               ID：时段VIPID  
///               VIPID：VIP等级_类型
///               Num: 限额数量^男性数量^女性数量
///               UserID：更新人
/// Return：       0：成功  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-03-24
/// Debug: w ##class(web.DHCPE.PreManagerJDF).UpdateTemplateVIP("15","15||3","{""PTTMaleNum"":""2"",""PTTFemaleNum"":"""",""PTTEmptyNum"":"""",""PTTRealNum"":""""}","304","11849","1")
ClassMethod UpdateManagerVIP(ParRef, ID, VIPID, Num, UserID)
{
    Quit:ParRef="" "-1^父记录不能为空！"
    Quit:VIPID="" "-1^VIP等级不能为空"
    Set Type = $PIECE(VIPID,"_",2)
    Set VIPID = $PIECE(VIPID,"_",1)
    Set curSub =  $ORDER(^User.DHCPESourceTimeVIPManagerI("IndOfVIPTypeParRef",VIPID,Type,+ParRef,$PIECE(ParRef,"||",2),""))
    If (curSub'="")&&((ID="")||(ID'=(ParRef_"||"_curSub)))  Quit "-1^该VIP等级已存在"
    Set total = $PIECE(Num,"^",1)
    Quit:total="" "-1^总数量不能为空"
    Set parTotal = $LISTGET(^User.DHCPESourceManagerD(+ParRef,"SMTime",$PIECE(ParRef,"||",2)),2)
    Quit:parTotal<total "-1^类型为【"_VIPID_"_"_Type_"】的总数量【"_total_"】不能大于时段总数量【"_parTotal_"】"
    Set maleNum = $PIECE(Num,"^",2)
    Set femaleNum = $PIECE(Num,"^",3)
    Set preObj = ..GetPreNum(ParRef)
    If preObj.Get(VIPID_"_"_Type)'=""
    {
        Set preVipObj = preObj.Get(VIPID_"_"_Type)
        Set preToltal = +preVipObj.Get("total")
        Set preMaleNum = +preVipObj.Get("maleNum")
        Set preFemaleNum = +preVipObj.Get("femaleNum")
        Quit:preToltal>total "-1^类型为【"_VIPID_"_"_Type_"】的总数量不能小于已预约数量【"_preToltal_"】"
        If (maleNum'="")&&(preMaleNum>maleNum) Quit "-1^类型为【"_VIPID_"_"_Type_"】的男性数量不能小于已预约数量【"_preMaleNum_"】"
        If (femaleNum'="")&&(preFemaleNum>femaleNum) Quit "-1^类型为【"_VIPID_"_"_Type_"】的女性数量不能小于已预约数量【"_preFemaleNum_"】"
    }
    Set properties = "STVMParRef^STVMVIPLevel^STVMType^STVMNum^STVMMaleNum^STVMFemaleNum^STVMUpdateUserDR"
    Set valStr = ParRef_"^"_VIPID_"^"_Type _"^"_ total _"^"_maleNum _"^"_femaleNum  _"^"_UserID
    Set ret = ##class(User.DHCPESourceTimeVIPManager).SaveData(ID,valStr,properties)
    Quit:+ret<0 ret
    Quit 0
}

/// Description：查询模板时段信息
/// Input：
/// Return：
/// Creator： wangguoying
/// CreateDate： 2022-03-23
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.SourceManager","QueryTemplateTime",304)
Query QueryTemplateTime(ParRef As %String = "") As websys.Query(ROWSPEC = "TRowID:%String,TStartTime:%String:开始时间,TEndTime:%String:结束时间,TNum,TMaleNum,TFemaleNum") [ SqlProc ]
{
}

ClassMethod QueryTemplateTimeExecute(ByRef qHandle As %Binary, ParRef As %String = "") As %Status
{
    Set repid=$INCREMENT(^CacheTemp)
    Set ind=1
    If ParRef = ""
    {
        Set qHandle=$LISTBUILD(0,repid,0)
        Quit $$$OK
    }

    Set startTime = 0
    For  Set startTime = $ORDER(^User.DHCPESourceTimeTemplateI("IndOfSTime",ParRef,startTime))  Quit:startTime=""  Do
    .Set sub = ""
    .For  Set sub = $ORDER(^User.DHCPESourceTimeTemplateI("IndOfSTime",ParRef,startTime,sub))  Quit:sub=""  Do
    ..Set endTime = $LISTGET(^User.DHCPESourceTemplateD(ParRef,"STTime",sub),9)
    ..Set num = $LISTGET(^User.DHCPESourceTemplateD(ParRef,"STTime",sub),2)
    ..Set maleNum = $LISTGET(^User.DHCPESourceTemplateD(ParRef,"STTime",sub),3)
    ..Set femaleNum = $LISTGET(^User.DHCPESourceTemplateD(ParRef,"STTime",sub),4)
    ..Do OutputTimeRow
    Set qHandle=$LISTBUILD(0,repid,0)
    Quit $$$OK
OutputTimeRow
    Set Data=$LISTBUILD(ParRef_"||"_sub,##class(websys.Conversions).TimeLogicalToHtml(startTime),##class(websys.Conversions).TimeLogicalToHtml(endTime),num,maleNum,femaleNum)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

/// Description：查找VIP类型  8.5需要修改成取表
/// Creator：     wangguoying
/// CreateDate：  2022-10-18
/// Debuger：d ##class(%ResultSet).RunQuery("web.DHCPE.SourceManager","FindVIPPreType")
Query FindVIPPreTypeOld() As websys.Query(ROWSPEC = "id:%String,desc:%String") [ SqlProc ]
{
}

ClassMethod FindVIPPreTypeOldExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$INCREMENT(^CacheTemp)
    If $GET(ind)="" Set ind=1	
    
    Set id=0
	For  Set id=$ORDER(^DHCPEVIPLevel("VIP",id)) Quit:id=""  Do
	.Set use=$PIECE($GET(^DHCPEVIPLevel("VIP",id)),"^",4)
	.Quit:use'="Y"
	.Set desc=$PIECE($GET(^DHCPEVIPLevel("VIP",id)),"^",2)
    .Set type = $GET(^DHCPEDataEx("VIPPreType",id))  //测试数据  需要修改
    .Set:type="" type="A"
    .If (type = "A") || (type = "I")  Do
    ..Set udesc = desc _ "(个人)"
    ..Set uid = id _"_I"
    ..Do OutVIPType
    .If (type = "A") || (type = "G" ) Do
    ..Set udesc = desc _ "(团体)"
    ..Set uid = id _"_G"
    ..Do OutVIPType
    .If (type = "N") Do
    ..Set udesc = desc _ "(不限)"
    ..Set uid = id _"_N"
    ..Do OutVIPType

    Set qHandle=$LISTBUILD(0,repid,0)
	Quit $$$OK
OutVIPType 
	Set ^CacheTemp(repid,ind)=$LISTBUILD(uid,udesc)
	Set ind=ind+1
    Quit
}

/// Description：查找VIP类型  8.5
/// Creator：     wangguoying
/// CreateDate：  2022-10-18
/// Debuger：d ##class(%ResultSet).RunQuery("web.DHCPE.SourceManager","FindVIPPreType")
Query FindVIPPreType(LocID) As websys.Query(ROWSPEC = "id:%String,desc:%String") [ SqlProc ]
{
}

ClassMethod FindVIPPreTypeExecute(ByRef qHandle As %Binary, LocID) As %Status
{
	Set repid=$INCREMENT(^CacheTemp)
    If $GET(ind)="" Set ind=1	
    
    If LocID = ""{
    	Set qHandle=$LISTBUILD(0,repid,0)
		Quit $$$OK
    }
    
    Set id=0
	For  Set id=$ORDER(^CT.PE.VIPLevelD(id)) Quit:id=""  Do
	.Set use = $LISTGET($GET(^CT.PE.VIPLevelD(id)),4)
	.Quit:use'="Y"
	.Set desc=$LISTGET($GET(^CT.PE.VIPLevelD(id)),3)
	.Set locInfoId = $ORDER(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,id,""),-1)
	.Quit:locInfoId=""
    .Set type = $LISTGET($GET(^CF.PE.LocVIPLevelD(locInfoId)),21)  
    .Set:type="" type="A"
    .If (type = "A") || (type = "I")  Do
    ..Set udesc = desc _ "(个人)"
    ..Set uid = id _"_I"
    ..Do OutVIPType
    .If (type = "A") || (type = "G" ) Do
    ..Set udesc = desc _ "(团体)"
    ..Set uid = id _"_G"
    ..Do OutVIPType
    .If (type = "N") Do
    ..Set udesc = desc _ "(不限)"
    ..Set uid = id _"_N"
    ..Do OutVIPType

    Set qHandle=$LISTBUILD(0,repid,0)
	Quit $$$OK
OutVIPType 
	Set ^CacheTemp(repid,ind)=$LISTBUILD(uid,udesc)
	Set ind=ind+1
    Quit
}

/// Description：查询模板时段VIP
/// Input：
/// Return：
/// Creator： wangguoying
/// CreateDate： 2022-10-18
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.SourceManager","QueryTimeVip","14||2")
Query QueryTimeVip(ParRef As %String = "") As websys.Query(ROWSPEC = "TRowID:%String,TVIPID:%String,TVIPDesc:%String:VIP等级,TNum:%String:数量,TMaleNum,TFemaleNum") [ SqlProc ]
{
}

ClassMethod QueryTimeVipExecute(ByRef qHandle As %Binary, ParRef As %String = "") As %Status
{
    Set repid=$INCREMENT(^CacheTemp)
    Set ind=1
    If ParRef = ""
    {
        Set qHandle=$LISTBUILD(0,repid,0)
        Quit $$$OK
    }
    Set parRef = +ParRef
    Set sub = $PIECE(ParRef,"||",2)
    Set vipSub = ""
    For  Set vipSub = $ORDER(^User.DHCPESourceTemplateD(parRef,"STTime",sub,"STTVIPType",vipSub))  Quit:vipSub=""  Do
    .Set vip = $LISTGET(^User.DHCPESourceTemplateD(parRef,"STTime",sub,"STTVIPType",vipSub),2)
    .Set vipDesc = $LISTGET($GET(^CT.PE.VIPLevelD(vip)),3)
    .Set type = $LISTGET(^User.DHCPESourceTemplateD(parRef,"STTime",sub,"STTVIPType",vipSub),3)
    .Set vipDesc = vipDesc_"("_$CASE(type,"I":"个人","G":"团体",:"不限") _")"
    .Set num = $LISTGET(^User.DHCPESourceTemplateD(parRef,"STTime",sub,"STTVIPType",vipSub),4)
    .Set maleNum = $LISTGET(^User.DHCPESourceTemplateD(parRef,"STTime",sub,"STTVIPType",vipSub),5)
    .Set femaleNum = $LISTGET(^User.DHCPESourceTemplateD(parRef,"STTime",sub,"STTVIPType",vipSub),6)
    .Do OutputTimeVIPRow
    Set qHandle=$LISTBUILD(0,repid,0)
    Quit $$$OK
OutputTimeVIPRow
    Set Data=$LISTBUILD(ParRef_"||"_vipSub,vip_"_"_type,vipDesc,num,maleNum,femaleNum)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

/// Description：查询限额时段信息
/// Input：
/// Return：
/// Creator： wangguoying
/// CreateDate： 2022-10-20
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.SourceManager","QueryManagerTime",21)
Query QueryManagerTime(ParRef As %String = "") As websys.Query(ROWSPEC = "TRowID:%String,TStartTime:%String:开始时间,TEndTime:%String:结束时间,TNum,TMaleNum,TFemaleNum,TPreNum") [ SqlProc ]
{
}

ClassMethod QueryManagerTimeExecute(ByRef qHandle As %Binary, ParRef As %String = "") As %Status
{
    Set repid=$INCREMENT(^CacheTemp)
    Set ind=1
    If ParRef = ""
    {
        Set qHandle=$LISTBUILD(0,repid,0)
        Quit $$$OK
    }

    Set startTime = 0
    For  Set startTime = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",ParRef,startTime))  Quit:startTime=""  Do
    .Set sub = ""
    .For  Set sub = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",ParRef,startTime,sub))  Quit:sub=""  Do
    ..Set endTime = $LISTGET(^User.DHCPESourceManagerD(ParRef,"SMTime",sub),9)
    ..Set num = $LISTGET(^User.DHCPESourceManagerD(ParRef,"SMTime",sub),2)
    ..Set maleNum = $LISTGET(^User.DHCPESourceManagerD(ParRef,"SMTime",sub),3)
    ..Set femaleNum = $LISTGET(^User.DHCPESourceManagerD(ParRef,"SMTime",sub),4)
    ..Set preObj = ..GetPreNum(ParRef_"||"_sub)
    ..Set preNum = +preObj.Get("total")
    ..Set preMNum = +preObj.Get("maleNum")
    ..Set preFNum = +preObj.Get("femaleNum")
    ..Do OutputMTimeRow
    Set qHandle=$LISTBUILD(0,repid,0)
    Quit $$$OK
OutputMTimeRow
    Set Data=$LISTBUILD(ParRef_"||"_sub,##class(websys.Conversions).TimeLogicalToHtml(startTime),##class(websys.Conversions).TimeLogicalToHtml(endTime),num,maleNum,femaleNum,preNum _"-"_preMNum_"-"_preFNum )
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

/// Description：查询模板时段VIP
/// Input：
/// Return：
/// Creator： wangguoying
/// CreateDate： 2022-10-20
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.SourceManager","QueryManagerTimeVip","4||5")
Query QueryManagerTimeVip(ParRef As %String = "") As websys.Query(ROWSPEC = "TRowID:%String,TVIPID:%String,TType,TVIPDesc:%String:VIP等级,TNum:%String:数量,TMaleNum,TFemaleNum,TPreNum:%String:已预约数量") [ SqlProc ]
{
}

ClassMethod QueryManagerTimeVipExecute(ByRef qHandle As %Binary, ParRef As %String = "") As %Status
{
    Set repid=$INCREMENT(^CacheTemp)
    Set ind=1
    If ParRef = ""
    {
        Set qHandle=$LISTBUILD(0,repid,0)
        Quit $$$OK
    }
    Set parRef = +ParRef
    Set preObj = ..GetPreNum(ParRef)
    Set sub = $PIECE(ParRef,"||",2)
    Set vipSub = ""
    For  Set vipSub = $ORDER(^User.DHCPESourceManagerD(parRef,"SMTime",sub,"STMVIPType",vipSub))  Quit:vipSub=""  Do
    .Set vip = $LISTGET(^User.DHCPESourceManagerD(parRef,"SMTime",sub,"STMVIPType",vipSub),2)
    .Set vipDesc = $LISTGET($GET(^CT.PE.VIPLevelD(vip)),3)
    .Set giType = $LISTGET(^User.DHCPESourceManagerD(parRef,"SMTime",sub,"STMVIPType",vipSub),3)
    .Set vipDesc = vipDesc_"("_$CASE(giType,"I":"个人","G":"团体",:"不限")_")"
    .Set num = $LISTGET(^User.DHCPESourceManagerD(parRef,"SMTime",sub,"STMVIPType",vipSub),4)
    .Set maleNum = $LISTGET(^User.DHCPESourceManagerD(parRef,"SMTime",sub,"STMVIPType",vipSub),5)
    .Set femaleNum = $LISTGET(^User.DHCPESourceManagerD(parRef,"SMTime",sub,"STMVIPType",vipSub),6)
    .Set vipPreObj = preObj.Get(vip_"_"_giType)
    .Set preTotal = 0,preMaleNum=0,preFemaleNum=0
    .If vipPreObj'=""  Do
    ..Set preTotal = +vipPreObj.Get("total")
    ..Set preMaleNum = +vipPreObj.Get("maleNum")
    ..Set preFemaleNum = +vipPreObj.Get("femaleNum")
    .Set preNum = preTotal_"-"_preMaleNum_"-"_preFemaleNum
    .Do OutputMTimeVIPRow
    Set qHandle=$LISTBUILD(0,repid,0)
    Quit $$$OK
OutputMTimeVIPRow
    Set Data=$LISTBUILD(ParRef_"||"_vipSub,vip_"_"_giType,giType,vipDesc,num,maleNum,femaleNum, preNum)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

ClassMethod GetManagerID(LocID, Class, LogicalDate)
{
    Quit $ORDER(^User.DHCPESourceManagerI("IndOfLocClassDate",LocID,Class,LogicalDate,""))
}

/// Description：查询指定时间段内已存在预约记录的日期
/// Input：
///               LocID: 科室ID
///               StartDate：开始日期
///               EndDate：结束日期
/// Return：      存在预约记录的日期
/// Creator：     wangguoying
/// CreateDate：  2022-10-18
/// Debug: w ##class(web.DHCPE.SourceManager).GetExistPrecordDate(1)
ClassMethod GetExistPrecordDate(LocID, StartDate, EndDate)
{
    Set ret = ""
    Set startDate = ##class(websys.Conversions).DateHtmlToLogical(StartDate)
    Set endDate = ##class(websys.Conversions).DateHtmlToLogical(EndDate)
    Set date = startDate -1 
    For cls = "I","O" {
        For {
            Set date = $ORDER(^User.DHCPESourceManagerI("IndOfLocClassDate",LocID,cls,date))
            Quit:(date="")||(date>endDate)
            Set id = ..GetManagerID(LocID,cls,date)
            Continue:id=""
            If ..ManagerIDsUsed(id) = 1
            {
                Set:ret'="" ret = ret_"、"_##class(websys.Conversions).DateLogicalToHtml(date)
                Set:ret="" ret = ##class(websys.Conversions).DateLogicalToHtml(date)
            } 
        }
    }
    Quit ret
}

/// Description：判断ManagerID是否已使用
/// Input：
///               ManagerID: DHC_PE_SourceManager
/// Return：       0：未使用  1：已使用
/// Creator：     wangguoying
/// CreateDate：  2022-10-18
/// Debug: w ##class(web.DHCPE.SourceManager).DetaildIsUsed(1)
ClassMethod ManagerIDsUsed(ManagerID)
{
    Set timeSub = 0,flag=0
    For {
        Set timeSub = $ORDER(^User.DHCPESourceManagerD(ManagerID,"SMTime",timeSub))
        Quit:(timeSub="")||(flag=1)
        Set detailId = ManagerID_"||"_timeSub
        If ..DetaildIsUsed(detailId) = 1  Set flag = 1
    }
    Quit flag
}

/// Description：判断DetailID是否已使用
/// Input：
///               DetailID: DHC_PE_SourceTimeManager
/// Return：       0：未使用  1：已使用
/// Creator：     wangguoying
/// CreateDate：  2022-10-18
/// Debug: w ##class(web.DHCPE.SourceManager).DetaildIsUsed(1)
ClassMethod DetaildIsUsed(DetailID)
{
    Quit ..DetaildIsUsedByNet(DetailID) || ..DetaildIsUsedByHIS(DetailID)
}

/// Description：判断DetailID是否被线上预约记录使用
/// Input：
///               DetailID: DHC_PE_SourceTimeManager
/// Return：       0：未使用  1：已使用
/// Creator：     wangguoying
/// CreateDate：  2022-10-18
/// Debug: w ##class(web.DHCPE.SourceManager).DetaildIsUsed(1)
ClassMethod DetaildIsUsedByNet(DetailID)
{
    Set date = $LISTGET(^User.DHCPESourceManagerD(+DetailID),4)
    Set flag = 0,netpreId = ""
    For  Set netpreId = $ORDER(^User.DHCPENetPreRecordI("PreDateIndex",date,netpreId))  Quit:(netpreId="")||(flag=1)  Do
    .Set stat = $LISTGET(^User.DHCPENetPreRecordD(netpreId),7)
    .Quit:(stat=2)||(stat=3)||(stat=6)
    .Set curTimeId = $LISTGET(^User.DHCPENetPreRecordD(netpreId),20)
    .Quit:curTimeId'=DetailID
    .Set flag = 1
    Quit flag
}

/// Description：判断DetailID是否被线下预约记录使用
/// Input：
///               DetailID: DHC_PE_SourceTimeManager
/// Return：       0：未使用  1：已使用
/// Creator：     wangguoying
/// CreateDate：  2022-10-18
/// Debug: w ##class(web.DHCPE.SourceManager).DetaildIsUsed(1)
ClassMethod DetaildIsUsedByHIS(DetailID)
{
    Set flag = 0,piadm = ""
    For  Set piadm = $ORDER(^DHCPEPreIADM(0,"DetailID",DetailID,piadm))  Quit:(piadm="")||(flag=1)  Do
    .Set stat = $PIECE(^DHCPEPreIADM(piadm),"^",8)
    .Quit:stat="CANCELPE"
    .Set flag = 1
    Quit flag
}

/// Description：根据模板创建预约限额
/// Input：
///               StartDate: 开始日期 HTML
///               EndDate: 结束日期 HTML
///               Mode：COVER：覆盖 SKIP：跳过已存在记录
///               LocID：科室ID
/// Return：       0：成功  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-10-18
/// Debug: w ##class(web.DHCPE.SourceManager).CreateByTemplate("2022-03-28","2022-03-31",304,1)
ClassMethod CreateByTemplate(StartDate, EndDate, Mode, LocID, UserID)
{
    Set ^tmpwgy("CreateByTemplate") = $LISTBUILD(StartDate, EndDate, Mode, LocID, UserID)
    Quit:(StartDate="")||(EndDate="") "-1^日期不能为空"
    Set StartDate = ##class(websys.Conversions).DateHtmlToLogical(StartDate)
    Set EndDate = ##class(websys.Conversions).DateHtmlToLogical(EndDate)
    Quit:EndDate<StartDate "-1^开始日期不能大于结束日期"
    Set err = ""
    Set $ZTRAP="CreateErr"
    Tstart
    For cls = "I","O" {
        For date=StartDate:1:EndDate  
        {    
            Set weekNum = $ZDATE(date,10)
            Set templateId = ..GetTemplateID(LocID,cls,weekNum)
            Continue:templateId=""
            Set ret = ..CreateManagerByTemplate(date,LocID,Mode, templateId,UserID)
            If +ret'=0 Set err= ret Quit 
        }
    }
    If err'=""  Trollback  Quit err  
    Tcommit
    Quit 0
CreateErr
    Set $ZTRAP=""
    Trollback
    Quit "-100^"_$ZERROR
}

ClassMethod CreateManagerParRef(Date, LocID, Class, UserID)
{
    Set properties = "SMLocDR^SMClass^SMDate^SMStopFlag^SMUpdateUserDR"
    Set valStr = LocID_"^"_ Class _"^"_ Date_"^N^"_UserID
    Quit ##class(User.DHCPESourceManager).SaveData("",valStr,properties)
}

/// Description：更新时段信息
/// Input：
///               ParRef: 父记录ID
///               ID：时段ID  
///               JsonParam：json格式的字符串，key为实体类属性，value为值
///               LocID：科室ID
///               UserID：更新人
///               Date：日期 HTML  当父记录ID为空时必传
///               Class：限额 类型
/// Return：      时段ID
/// Creator：     wangguoying
/// CreateDate：  2022-10-18
/// Debug: w ##class(web.DHCPE.PreManagerJDF).UpdateManagerTime("15","15||3","{""PTTMaleNum"":""2"",""PTTFemaleNum"":"""",""PTTEmptyNum"":"""",""PTTRealNum"":""""}","304","11849","1")
ClassMethod UpdateManagerTime(ParRef, ID, JsonParam, LocID, UserID, Date = "", Class = "")
{
    Quit:(ParRef="")&&(Date="") "-1^父记录不能为空！"
    Set $ZTRAP="UpdateManagerTimeErr"
    Tstart
    If ParRef = ""    //不存在父表，先创建父表
    {
        Set ret = ..CreateManagerParRef(##class(websys.Conversions).DateHtmlToLogical(Date),LocID,Class, UserID)
        If +ret<0  Trollback  Quit ret
        Set ParRef = ret 
    }
    Set paramObj = ##class(web.DHCPE.Utils.Object).FromJSON(JsonParam)
    Set startTime = paramObj.Get("STMStartTime")
    Set endTime = paramObj.Get("STMEndTime")
    If startTime'=""
    {
        Set startTime = ##class(websys.Conversions).TimeHtmlToLogical(startTime)
        Do paramObj.Set("STMStartTime",startTime)
    }
    If endTime'=""
    {
        Set endTime = ##class(websys.Conversions).TimeHtmlToLogical(endTime)
        Do paramObj.Set("STMEndTime",endTime)
        Set exist = ..IsExistManagerTime(ParRef,ID,startTime,endTime)
        If exist = 1 Trollback  Quit "-1^时间段与现有时间段重叠，不允许更新！"
    }
    If ID'=""
    {
        Set err = ..ValidPreNum(ID,paramObj)
        If err'=""  Trollback  Quit err
    }
    Set infoStr = ..GetParamStrByJSONObject(paramObj)
    If infoStr = $CHAR(0)  Trollback  Quit "-1^参数不能为空"
    Set properties = $PIECE(infoStr,$CHAR(0),1)
    Set valStr = $PIECE(infoStr,$CHAR(0),2)
    Set properties = "STMParRef^STMUpdateUserDR^"_properties
    Set valStr =  ParRef_"^"_UserID_"^"_valStr
    Set ret = ##class(User.DHCPESourceTimeManager).SaveData(ID,valStr,properties)
    If +ret<0  Trollback  Quit ret
    Tcommit
    Quit ret
UpdateManagerTimeErr
    Set $ZTRAP=""
    Trollback
    Quit "-100^"_$ZERROR
}

/// Description：获取某个时段内已预约数量  暂不考虑主场，主场仍走老程序
/// Input：
///               DetailID: DHC_PE_SourceTimeManager
/// Return：      { total:总数量,maleNum:男性数量,femaleNum:女性数量,VIP类型:{total:总数量,maleNum:男性数量,femaleNum:女性数量}...}
/// Creator：     wangguoying
/// CreateDate：  2022-10-18
/// Debug: w ##class(web.DHCPE.SourceManager).GetPreNum("20||34")
ClassMethod GetPreNum(DetailID) As web.DHCPE.Utils.Object
{
    Kill PreNumList
	Set locId = $lg(^User.DHCPESourceManagerD(+DetailID),2)
    //线上预约记录
    Set date = $LISTGET(^User.DHCPESourceManagerD(+DetailID),4)
    Set netpreId = ""
    For {
        Set netpreId = $ORDER(^User.DHCPENetPreRecordI("PreDateIndex",date,netpreId))
        Quit:(netpreId="")
        Set stat = $LISTGET(^User.DHCPENetPreRecordD(netpreId),7)
        Continue:(stat=2)||(stat=3)||(stat=6)
        Set curTimeId = $LISTGET(^User.DHCPENetPreRecordD(netpreId),20)
        Continue:curTimeId'=DetailID
        Set PreNumList("Total") = $GET(PreNumList("Total"))+1
        Set sexId = $LISTGET(^User.DHCPENetPreRecordD(netpreId),4)
        Set vipDesc = $LISTGET(^User.DHCPENetPreRecordD(netpreId),16)
        Set vipId = ##class(web.DHCPE.CT.VIPLevel).GetVIPIDByDesc(vipDesc) 
		Set locInfoId = $ORDER(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_locId,vipId,""),-1)
		Continue:locInfoId="" 
        Set vipPreType = $LISTGET($GET(^CF.PE.LocVIPLevelD(locInfoId)),21) 
        Set:vipPreType="" vipDesc = "A"
        Set pmType = $LISTGET(^User.DHCPENetPreRecordD(netpreId),22)
        Set nodeName = ""
        If pmType = "H"  {//主场
            Set piadm = $LISTGET(^User.DHCPENetPreRecordD(netpreId),13) 
            Set nodeName = $PIECE(^DHCPEPreIADM(piadm),"^",2)_"_H"
        }ElseIf vipPreType = "N" {
            Set nodeName = vipId_"_N"
        }Else{
            Set nodeName = vipId_"_"_pmType
        }
        Set PreNumList("VIPList",nodeName,"Total") = $GET(PreNumList("VIPList",nodeName,"Total"))+1
        If sexId = 1 
        {
            Set PreNumList("MaleNum") = $GET(PreNumList("MaleNum"))+1
            Set PreNumList("VIPList",nodeName,"MaleNum") = $GET(PreNumList("VIPList",nodeName,"MaleNum"))+1
        }
        Else{
            Set PreNumList("FemaleNum") = $GET(PreNumList("FemaleNum"))+1
            Set PreNumList("VIPList",nodeName,"FemaleNum") = $GET(PreNumList("VIPList",nodeName,"FemaleNum"))+1
        }
    }

    //线下预约记录
    Set piadm = ""
    For {
        Set piadm = $ORDER(^DHCPEPreIADM(0,"DetailID",DetailID,piadm))
        Quit:piadm=""
        Set stat = $PIECE(^DHCPEPreIADM(piadm),"^",8)
        Continue:stat="CANCELPE"
        Continue:##class(HS.BL.PECommon).GetEffectiveNetIDByPIADM(piadm)'=""  //线上预约的记录
        Set PreNumList("Total") = $GET(PreNumList("Total"))+1
        Set pibi = $PIECE(^DHCPEPreIADM(piadm),"^",1)
        Set pgid = $PIECE(^DHCPEPreIADM(piadm),"^",2)
        Set sexId = $PIECE(^DHCPEPreIBI(pibi),"^",3)
        Set vipId = $PIECE(^DHCPEPreIADM(piadm),"^",18) 
        Set locInfoId = $ORDER(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_locId,vipId,""),-1)
        Continue:locInfoId=""
        Set vipPreType = $LISTGET($GET(^CF.PE.LocVIPLevelD(locInfoId)),21) 
        Set:vipPreType="" vipDesc = "A"
        Set pmType = $CASE(pgid'="",1:"G",:"I")
        Set nodeName = $CASE(vipPreType,"N":vipId_"_N",:vipId_"_"_pmType)
         Set PreNumList("VIPList",nodeName,"Total") = $GET(PreNumList("VIPList",nodeName,"Total"))+1
    
        If sexId = 1 
        {
            Set PreNumList("MaleNum") = $GET(PreNumList("MaleNum"))+1
            Set PreNumList("VIPList",nodeName,"MaleNum") = $GET(PreNumList("VIPList",nodeName,"MaleNum"))+1
        }
        Else{
            Set PreNumList("FemaleNum") = $GET(PreNumList("FemaleNum"))+1
            Set PreNumList("VIPList",nodeName,"FemaleNum") = $GET(PreNumList("VIPList",nodeName,"FemaleNum"))+1
        }
    }

    Set retObj = ##class(web.DHCPE.Utils.Object).%New()
    Do retObj.Set("total",+$GET(PreNumList("Total")))
    Do retObj.Set("maleNum",+$GET(PreNumList("MaleNum")))
    Do retObj.Set("femaleNum", +$GET(PreNumList("FemaleNum")))
    Set vipType = ""
    For {
        Set vipType = $ORDER(PreNumList("VIPList",vipType))
        Quit:vipType=""
        Set vipObj = ##class(web.DHCPE.Utils.Object).%New()
        Do vipObj.Set("vipType",vipType)
        Do vipObj.Set("total", +$GET(PreNumList("VIPList",vipType,"Total")))
        Do vipObj.Set("maleNum",+$GET(PreNumList("VIPList",vipType,"MaleNum")))
        Do vipObj.Set("femaleNum", +$GET(PreNumList("VIPList",vipType,"FemaleNum")))
        Do retObj.Set(vipType,vipObj)
    }
    Quit retObj
}

/// Description：验证各时段数量是否大于已预约数量
/// Input：
///               ID: 时段ID
///               Obj：参数对象
/// Return：      ""：可以更新 非空：不可以更新
/// Creator：     wangguoying
/// CreateDate：  2022-10-18
/// Debug: w ##class(web.DHCPE.SourceManager).ValidPreNum("2022-03-28","2022-03-31",304,1)
ClassMethod ValidPreNum(ID, Obj As web.DHCPE.Utils.Object)
{
    Set STMNum = Obj.Get("STMNum")
    Quit:STMNum="" "总数量不能为空"
    Set preObj = ..GetPreNum(ID)
    Set preTotal = +preObj.Get("total")
    Quit:preTotal>STMNum "-1^总数量不能少于已预约数量【"_preTotal_"】"
    
    Set STMMaleNum = Obj.Get("STMMaleNum")
    If STMMaleNum'=""
    {
        Set preNum = +preObj.Get("maleNum")
        Quit:preNum>STMMaleNum "-1^男性数量不能少于已预约数量【"_preNum_"】"
    }
    Set STMFemaleNum = Obj.Get("STMFemaleNum")
    If STMFemaleNum'=""
    {
        Set preNum = +preObj.Get("femaleNum")
        Quit:preNum>STMFemaleNum "-1^女性数量不能少于已预约数量【"_preNum_"】"
    }
    Quit ""
}

/// Description：根据模板创建预约限额
/// Input：
///               Date: 指定日期  Logical
///               LocID：科室ID
///               Mode：COVER：覆盖 SKIP：跳过已存在记录
///               TemplateID：模板ID
/// Return：       0：成功  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-10-18
/// Debug: w ##class(web.DHCPE.SourceManager).CreateManagerByTemplate(1)
ClassMethod CreateManagerByTemplate(Date, LocID, Mode, TemplateID, UserID)
{
    Set cls = $LISTGET(^User.DHCPESourceTemplateD(TemplateID),3)
    Set oldId = ..GetManagerID(LocID,cls,Date)
    If (oldId'="")&&((..ManagerIDsUsed(oldId)=1)||(Mode="SKIP")) Quit 0  //该限额已经使用了或者跳过，直接返回成功
    Set err = ""
    Set $ZTRAP = "CreateManagerErr"
    Tstart
    If oldId'=""
    {
        //已存在且未被使用的记录 直接删除
        Set ret = ##class(User.DHCPESourceManager).Delete(oldId)
        If +ret<0  Set err = ret  Trollback  Quit err
    } 
    //先创建一个父记录
    Set parRef = ..CreateManagerParRef(Date,LocID,cls,UserID)
    If +parRef<0  Trollback  Quit parRef
    Set htmlDate = ##class(websys.Conversions).DateLogicalToHtml(Date)
    //创建时段
    Set startTime = ""
    For  Set startTime = $ORDER(^User.DHCPESourceTimeTemplateI("IndOfSTime",TemplateID,startTime))  Quit:(startTime="")||(err'="")  Do
    .Set sub = ""
    .For  Set sub = $ORDER(^User.DHCPESourceTimeTemplateI("IndOfSTime",TemplateID,startTime,sub))  Quit:(sub="")||(err'="")  Do
    ..Set endTime = $LISTGET(^User.DHCPESourceTemplateD(TemplateID,"STTime",sub),9)
    ..Set totalNum = $LISTGET(^User.DHCPESourceTemplateD(TemplateID,"STTime",sub),2)
    ..Set maleNum = $LISTGET(^User.DHCPESourceTemplateD(TemplateID,"STTime",sub),3)
    ..Set femaleNum = $LISTGET(^User.DHCPESourceTemplateD(TemplateID,"STTime",sub),4)
    ..Set paramObj = ##class(web.DHCPE.Utils.Object).%New()
    ..Do paramObj.Set("STMStartTime",startTime)
    ..Do paramObj.Set("STMEndTime",endTime)
    ..Do paramObj.Set("STMNum",totalNum)
    ..Do paramObj.Set("STMMaleNum",maleNum)
    ..Do paramObj.Set("STMFemaleNum",femaleNum)
    ..Set timeId = ..UpdateManagerTime(parRef,"",paramObj.ToJSON(),LocID,UserID,htmlDate)
    ..If +timeId<0 Set err = timeId  Quit
    ..//创建VIP
    ..Set vipSub = ""
    ..For  Set vipSub = $ORDER(^User.DHCPESourceTemplateD(TemplateID,"STTime",sub,"STTVIPType",vipSub)) Quit:(vipSub="")||(err'="")  Do
    ...Set vip = $LISTGET(^User.DHCPESourceTemplateD(TemplateID,"STTime",sub,"STTVIPType",vipSub),2)
    ...Set type = $LISTGET(^User.DHCPESourceTemplateD(TemplateID,"STTime",sub,"STTVIPType",vipSub),3)
    ...Set totalNum = $LISTGET(^User.DHCPESourceTemplateD(TemplateID,"STTime",sub,"STTVIPType",vipSub),4)
    ...Set maleNum = $LISTGET(^User.DHCPESourceTemplateD(TemplateID,"STTime",sub,"STTVIPType",vipSub),5)
    ...Set femaleNum = $LISTGET(^User.DHCPESourceTemplateD(TemplateID,"STTime",sub,"STTVIPType",vipSub),6)
    ...Set ret = ..UpdateManagerVIP(timeId,"",vip_"_"_type,totalNum _"^"_maleNum _"^"_femaleNum,UserID)
    ...If +ret'=0 Set err=ret  Quit 
    ..Quit:err'=""
    If err'="" Trollback  Quit err
    Tcommit
    Quit 0
CreateManagerErr
    Set $ZTRAP=""
    Trollback
    Quit "-100^"_$ZERROR
}

/// Description: 获取号源池Event数组
/// Input:
/// 						BeginDate：开始日期
/// 						EndDate：结束日期
/// Return:  	  
/// Creator:	wangguoying
/// CreateDate:	2022-10-19
/// Debug: w ##class(web.DHCPE.SourceManager).GetSourceEventArr(66401,66401,304)
ClassMethod GetSourceEventArr(BeginDate, EndDate, LocID) As %DynamicArray
{
	Set arr = []
	For date = BeginDate:1:EndDate
	{
        For cls = "I","O" {
            Set TotalNum=0,TMaleMum="",TFemaleNum="",TVIPInfo=""
            Set PreTotalNum=0,PreTMaleMum=0,PreTFemaleNum=0,PreTVIPInfo=""
            Kill VIPList
            Set clsText = $CASE(cls,"I":"内部号源",:"外部号源")
            Set color = $CASE(cls,"I":"rgba(255, 233, 233, 1)",:"rgba(239, 249, 255, 1)")
            Set borderColor = $CASE(cls,"I":"rgba(255, 164, 164, 1)",:"rgba(51, 158, 255, 1)")
            Set preCss = "pre-tag pre-tag-"_cls
            Set mId = ..GetManagerID(LocID,cls,date)
            Continue:mId=""
            Set stopFlag = $LISTGET(^User.DHCPESourceManagerD(mId),8)
            If stopFlag = "Y" 
            {
                Set color = "rgb(163, 175, 188)"
                Set borderColor = "rgb(163, 175, 188)"
                Set clsText = clsText_"<label class='tip'>&nbsp;&nbsp;&nbsp;&nbsp;(停诊)</label>"
            }
            Set startTime = ""
            For {
                Set startTime = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",mId,startTime))
                Quit:startTime=""
                Set timeSub = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",mId,startTime,""))
                Set endTime = $LISTGET(^User.DHCPESourceManagerD(mId,"SMTime",timeSub),9)
                Set total = $LISTGET(^User.DHCPESourceManagerD(mId,"SMTime",timeSub),2)
                Set maleNum = $LISTGET(^User.DHCPESourceManagerD(mId,"SMTime",timeSub),3)
                Set femaleNum = $LISTGET(^User.DHCPESourceManagerD(mId,"SMTime",timeSub),4)
                Set TotalNum = TotalNum + total
                If maleNum'="" Set TMaleMum = TMaleMum + maleNum
                If femaleNum'="" Set TFemaleNum = TFemaleNum + femaleNum
                Set preObj = ..GetPreNum(mId_"||"_timeSub)
                Set preTotal = +preObj.Get("total")
                If (preTotal >= total) Set color = "rgb(163, 175, 188)"
                Set preMaleNum = +preObj.Get("maleNum") 
                Set preFemaleNum = +preObj.Get("femaleNum") 
                Set PreTotalNum = PreTotalNum + preTotal
                Set PreTMaleMum = PreTMaleMum + preMaleNum
                Set PreTFemaleNum = PreTFemaleNum + preFemaleNum
                Set vipInfo = ""   
                Set vipSub = ""
                For {
                    Set vipSub = $ORDER(^User.DHCPESourceManagerD(mId,"SMTime",timeSub,"STMVIPType",vipSub))
                    Quit:vipSub=""
                    Set vip = $LISTGET(^User.DHCPESourceManagerD(mId,"SMTime",timeSub,"STMVIPType",vipSub),2)
                    Set giType = $LISTGET(^User.DHCPESourceManagerD(mId,"SMTime",timeSub,"STMVIPType",vipSub),3)
                    Set vipNum = $LISTGET(^User.DHCPESourceManagerD(mId,"SMTime",timeSub,"STMVIPType",vipSub),4)
                    Set vipMNum = $LISTGET(^User.DHCPESourceManagerD(mId,"SMTime",timeSub,"STMVIPType",vipSub),5)
                    Set vipFNum = $LISTGET(^User.DHCPESourceManagerD(mId,"SMTime",timeSub,"STMVIPType",vipSub),6)
                    Set:vipNum'="" VIPList(vip,giType,"T") = $GET(VIPList(vip,giType,"T"))+vipNum
                    Set:vipMNum'="" VIPList(vip,giType,"M") = $GET(VIPList(vip,giType,"M"))+vipMNum
                    Set:vipFNum'="" VIPList(vip,giType,"F") = $GET(VIPList(vip,giType,"F"))+vipFNum
                    Set preVipObj = preObj.Get(vip_"_"_giType)
                    Set VIPPreTotal = $CASE(preVipObj,"":0,:+preVipObj.Get("total"))
                    Set VIPPreMaleNum = $CASE(preVipObj,"":0,:+preVipObj.Get("maleNum"))
                    Set VIPPreFemaleNum = $CASE(preVipObj,"":0,:+preVipObj.Get("femaleNum"))
                    Set VIPList(vip,giType,"PT") = $GET(VIPList(vip,giType,"PT"))+VIPPreTotal
                    Set VIPList(vip,giType,"PM") = $GET(VIPList(vip,giType,"PM"))+VIPPreMaleNum
                    Set VIPList(vip,giType,"PF") = $GET(VIPList(vip,giType,"PF"))+VIPPreFemaleNum
                    Set vipText =  $LISTGET($GET(^CT.PE.VIPLevelD(vip)),3)_"("_$CASE(giType,"I":"个人","G":"团体",:"不限")_")"_"："_vipNum_"<label class='"_preCss_"'>（"_VIPPreTotal_"）</label>"_"-"_vipMNum_"<label class='"_preCss_"'>（"_VIPPreMaleNum_"）</label>"_"-"_vipFNum_"<label class='"_preCss_"'>（"_VIPPreFemaleNum_"）</label>"
                    Set:vipInfo'="" vipInfo = vipInfo_"<br>"_vipText
                    Set:vipInfo="" vipInfo = vipText
                }
                Set obj = {}
                Set title = "总数："_total_"<label class='"_preCss_"'>（"_preTotal_"）</label><br>●男："_maleNum_"<label class='"_preCss_"'>（"_preMaleNum _"）</label><br>●女："_femaleNum_"<label class='"_preCss_"'>（"_preFemaleNum_"）</label>"
                Set obj.id = mId_"||"_timeSub
                Set obj.title = title
                Set obj.type = "Time_"_cls
                Set obj.tips = vipInfo
                Set obj.backgroundColor = color
                Set obj.borderColor = borderColor
                Set obj.start = $ZDATE(date,3)_" "_$ZTIME(startTime)
                Set obj.end = $ZDATE(date,3)_" "_$ZTIME(endTime)
                Do arr.%Push(obj)
            }
            Set vip = ""
            For {
                Set vip =  $ORDER(VIPList(vip))
                Quit:vip=""
                Set giType = ""
                For {
                    Set giType = $ORDER(VIPList(vip,giType))
                    Quit:giType=""
                    Set tips = $LISTGET($GET(^CT.PE.VIPLevelD(vip)),3)_"("_$CASE(giType,"I":"个人","G":"团体",:"不限")_")"_"："
                    Set tips = tips_$GET(VIPList(vip,giType,"T"))_"<label class='"_preCss_"'>（"_$GET(VIPList(vip,giType,"PT"))_"）</label>"
                    Set tips = tips_"-"_$GET(VIPList(vip,giType,"M"))_"<label class='"_preCss_"'>（"_$GET(VIPList(vip,giType,"PM"))_"）</label>"
                    Set tips = tips_"-"_$GET(VIPList(vip,giType,"F"))_"<label class='"_preCss_"'>（"_$GET(VIPList(vip,giType,"PF"))_"）</label>"
                    Set:TVIPInfo'="" TVIPInfo = TVIPInfo_"<br>"_tips
                    Set:TVIPInfo="" TVIPInfo=tips
                }
            }
            Set obj = {}
            Set obj.id = mId
            Set obj.title = "<label class='event-title'>"_clsText_"</label><hr>总数："_TotalNum_"<label class='"_preCss_"'>（"_PreTotalNum_"）</label><br>&nbsp;&nbsp;-男："_TMaleMum_"<label class='"_preCss_"'>（"_PreTMaleMum_"）</label><br> &nbsp;&nbsp;-女："_TFemaleNum_"<label class='"_preCss_"'>（"_PreTFemaleNum_"）</label>"
            Set obj.type = "Day_"_cls
            Set obj.tips = TVIPInfo
            Set obj.backgroundColor = color
            Set obj.borderColor = borderColor
            Set obj.start = $ZDATE(date,3)
            Do arr.%Push(obj)
        }
	}
	Quit arr
}

/// Description：复制号源
/// Input：
///               SourceDate：源日期 HTML
///               TargerDate：目标日期 HTML
///               ClsType：号源类型
///               Mode：SKIP：跳过已存在记录  COVER：直接覆盖
///               UserID：用户ID 
/// Return：       0：成功  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-10-20
/// Debug: w ##class(web.DHCPE.SourceManager).CopyByDate(1)
ClassMethod CopyByDate(SourceDate, TargerDate, LocID, ClsType, Mode, UserID)
{
    Set sDate = ##class(websys.Conversions).DateHtmlToLogical(SourceDate)
    Set tDate = ##class(websys.Conversions).DateHtmlToLogical(TargerDate)
    Set sId = ..GetManagerID(LocID,ClsType,sDate)
    Set tId = ..GetManagerID(LocID,ClsType,tDate)
    Quit:sId="" "-1^原日期【"_SourceDate_"】号源不存在！"
    Quit:(Mode="SKIP")&&(tId'="") 0 //目标排班已存在，跳过
    Quit:(tId'="")&&(..ManagerIDsUsed(tId)) "-1^日期【"_TargerDate_"】号源已被使用，禁止覆盖！"
    Set $ZTRAP = "CopyByDateErr"
    Tstart
    If tId'="" //先删除 再创建
    {
        Set ret = ##class(User.DHCPESourceManager).Delete(tId)
        If +ret'=0  Trollback  Quit "-1^删除目标号源失败："_$PIECE(ret,"^",2)
    }
    Set ret = ..CreateManagerParRef(tDate,LocID,ClsType,UserID)
    If +ret<0  Trollback  Quit "-1^新建目标号源失败："_$PIECE(ret,"^",2)
    Set newParRef = +ret
    Set err = ""
    Set startTime = ""
    For {
        Set startTime = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",sId,startTime))
        Quit:(startTime="")||(err'="")
        Set timeSub = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",sId,startTime,""))
        Set endTime = $LISTGET(^User.DHCPESourceManagerD(sId,"SMTime",timeSub),9)
        Set paramObj = ##class(web.DHCPE.Utils.Object).%New()
        Do paramObj.Set("STMStartTime",startTime)
        Do paramObj.Set("STMEndTime",endTime)
        Do paramObj.Set("STMNum",$LISTGET(^User.DHCPESourceManagerD(sId,"SMTime",timeSub),2))
        Do paramObj.Set("STMMaleNum",$LISTGET(^User.DHCPESourceManagerD(sId,"SMTime",timeSub),2))
        Do paramObj.Set("STMFemaleNum",$LISTGET(^User.DHCPESourceManagerD(sId,"SMTime",timeSub),4))
        Set ret = ..UpdateManagerTime(newParRef,"",paramObj.ToJSON(),LocID,UserID)
        If +ret<0  Set err = ret   
        Set detailId = ret
        Set vipSub = ""
        For {
            Set vipSub = $ORDER(^User.DHCPESourceManagerD(sId,"SMTime",timeSub,"STMVIPType",vipSub))
            Quit:(vipSub="")||(err'="")
            Set vip = $LISTGET(^User.DHCPESourceManagerD(sId,"SMTime",timeSub,"STMVIPType",vipSub),2)
            Set giType = $LISTGET(^User.DHCPESourceManagerD(sId,"SMTime",timeSub,"STMVIPType",vipSub),3)
            Set vipNum = $LISTGET(^User.DHCPESourceManagerD(sId,"SMTime",timeSub,"STMVIPType",vipSub),4)
            Set vipMNum = $LISTGET(^User.DHCPESourceManagerD(sId,"SMTime",timeSub,"STMVIPType",vipSub),5)
            Set vipFNum = $LISTGET(^User.DHCPESourceManagerD(sId,"SMTime",timeSub,"STMVIPType",vipSub),6)
            Set ret = ..UpdateManagerVIP(detailId,"",vip_"_"_giType,vipNum _"^"_ vipMNum _"^"_vipFNum,UserID)
            If ret'=0  Set err = ret  Quit
        }
    }
    If err'=""  Trollback  Quit err
    Tcommit
    Quit 0
CopyByDateErr
    Set $ZTRAP = ""
    Trollback
    Quit "-100^"_$ZERROR
}

/// Description:获取指定日期所在周的日期范围
/// Input:   
/// 				Date：2021-07-21
/// 				RtnType: HTML Logical
/// Return: 	周一到周天的指定格式
/// Creater:	wangguoying
/// CreateDate:	2021-07-21
/// Debug: w ##class(web.DHCPE.SourceManager).GetWeekDateRange("2021-07-21")
ClassMethod GetWeekDateRange(Date, RtnType = "HTML")
{
	If Date=""
 	{
	 	Set Date = $HOROLOG
 	}Else{
		Set Date = ##class(websys.Conversions).DateHtmlToLogical(Date)
 	}
	Set week =  $ZDATE(Date,10)
	Set:week=0 week=7
	Set week1 = Date-(week-1)
	Set week7 = Date+(7-week)
	Set ret = ""
	For date=week1:1:week7
	{
		If RtnType = "Logical"
		{
			Set:ret'="" ret = ret_"^"_date
			Set:ret="" ret = date
		}Else{
			Set:ret'="" ret = ret_"^"_$ZDATE(date,3)
			Set:ret="" ret = $ZDATE(date,3)
		}
	}
	Quit ret
}

/// Description：通过周复制
/// Input：
///               SWeekDate：源日期周
///               TWeekDate：目标日期周
///               Mode：SKIP：跳过已存在记录  COVER：直接覆盖
///               UserID：用户ID 
/// Return：       0：成功  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-10-20
/// Debug: w ##class(web.DHCPE.Endoscope.SourcePool).CopySourceByWeek("2022-08-25","2022-09-08","SKIP",11849)
ClassMethod CopySourceByWeek(SWeekDate, TWeekDate, LocID, Mode, UserID)
{
    Set sDateRange = ..GetWeekDateRange(SWeekDate,"HTML")
    Set tDateRange = ..GetWeekDateRange(TWeekDate,"HTML")
    Set err = ""
    Set $ZTRAP="CopyWeekErr"
    Tstart
    For i = 1:1:7
    {
        Quit:err'=""
        For cls = "I","O" {
            Quit:err'=""
            Continue:..GetManagerID(LocID,cls,##class(websys.Conversions).DateHtmlToLogical($PIECE(sDateRange,"^",i)))="" //原日期排班为空时  跳过
            Set tId = ..GetManagerID(LocID,cls,##class(websys.Conversions).DateHtmlToLogical($PIECE(tDateRange,"^",i)))
            Continue:(tId'="")&&(..ManagerIDsUsed(tId)=1) //目标日期已使用
            Set ret = ..CopyByDate($PIECE(sDateRange,"^",i),$PIECE(tDateRange,"^",i),LocID,cls,Mode,UserID)
            If ret'=0  Set err = ret  Quit
        }
    }
    If err '="" Trollback  Quit err
    Tcommit
    Quit 0
CopyWeekErr
    Set $ZTRAP=""
    Trollback
    Quit "-100^"_$ZERROR
}

/// Description：通过月复制
/// Input：
///               SMonth：源月份  2022-08
///               TMonth：目标月份  2022-09
///               Mode：SKIP：跳过已存在记录  COVER：直接覆盖
///               UserID：用户ID 
/// Return：       0：成功  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-10-20
/// Debug: w ##class(web.DHCPE.SourceManager).CopySourceByMonth("2022-08","2022-10","SKIP",11849)
ClassMethod CopySourceByMonth(SMonth, TMonth, LocID, Mode, UserID)
{
    Set sbeginDate = $ZDATEH(SMonth_"-01",3)
    Set sendDate = $SYSTEM.SQL.LASTDAY(SMonth_"-01")  //源月份最后一天的日期
    Set diff1 = sendDate - sbeginDate
    Set tbeginDate = $ZDATEH(TMonth_"-01",3)
    Set tendDate =  $SYSTEM.SQL.LASTDAY(TMonth_"-01") //目标月份最后一天的日期
    Set diff2 = tendDate - tbeginDate
    Set diff = $CASE(diff2<diff1,1:diff2,:diff1)  //取差额最小值
    Set err = ""
    Set $ZTRAP="CopyMonthErr"
    Tstart
    For i = 0:1:diff
    {
        Quit:err'=""
        For cls = "I","O" {
            Quit:err'=""
            Continue:..GetManagerID(LocID,cls,sbeginDate+i)="" //原日期排班为空时  跳过
            Set tId = ..GetManagerID(LocID,cls,tbeginDate+i)
            Continue:(tId'="")&&(..ManagerIDsUsed(tId)=1) //目标日期已使用
            Set sDateStr = ##class(websys.Conversions).DateLogicalToHtml((sbeginDate+i))
            Set tDateStr = ##class(websys.Conversions).DateLogicalToHtml((tbeginDate+i))
            Set ret = ..CopyByDate(sDateStr,tDateStr,LocID,cls, Mode,UserID)
            If ret'=0  Set err = ret  Quit
        }
       
    }
    If err '="" Trollback  Quit err
    Tcommit
    Quit 0
CopyMonthErr
    Set $ZTRAP=""
    Trollback
    Quit "-100^"_$ZERROR
}

/// Description：停诊
/// Input：
///               StartDate: 开始日期
///               EndDate：结束日期
///               FLag：Y：停诊  N：开诊
/// Return：       0：成功  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-10-20
/// Debug: w ##class(web.DHCPE.SourceManager).SetStoFlag("2022-10-22","2022-10-22",304)
ClassMethod SetStoFlag(StartDate, EndDate, FLag, LocID, UserID, CLass = "")
{
    Set $ZTRAP="StopErr"
    Set err = ""
    Set startDate = ##class(websys.Conversions).DateHtmlToLogical(StartDate)
    Set EndDate = ##class(websys.Conversions).DateHtmlToLogical(EndDate)
    Tstart
    For date = startDate:1:EndDate{
        Quit:err'=""
        For cls = "I","O" {
            Continue:(CLass'="")&&(cls'=CLass)
            Set id = ..GetManagerID(LocID,cls,date)
            If id'=""
            {
                Set ret = ##class(User.DHCPESourceManager).SaveData(id, FLag_"^"_UserID,"SMStopFlag^SMUpdateUserDR")
                If +ret<0  Set err = ret  Quit
            }
        }
    }
    If err'=""  Trollback  Quit err
    Tcommit
    Quit 0
StopErr
    Set $ZTRAP=""
    Trollback
    Quit "-100^"_$ZERROR
}

/// Description：查询剩余号源数量
/// Input：
///               DetailID：DHC_PE_SourceTimeManager
///               SexID：性别ID
///               PMType：预约类型 I：个人  G：团体
/// 				  LevelID：VIP等级
/// Return：       0：成功  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2023-02-02
/// Debug: w ##class(web.DHCPE.SourceManager).GetAvailNum("20||34","2","I","1")
ClassMethod GetAvailNum(DetailID, SexID = "", PMType = "", LevelID = "")
{
	Set mId = +DetailID
	Quit:$LISTGET(^User.DHCPESourceManagerD(mId),8)="Y" 0 //已停诊，不可预约
	Set timeSub = $PIECE(DetailID,"||",2) 
	Set totalNum = $LISTGET(^User.DHCPESourceManagerD(mId,"SMTime",timeSub),2)
	Set sexNum = 99999 //当SexID为空时，不考虑性别
	If SexID'=""
	{
		Set sexposition = $CASE(SexID,1:3,2:4,:"")
		Quit:sexposition="" 0 //无效的性别ID
		Set sexNum = $LISTGET(^User.DHCPESourceManagerD(mId,"SMTime",timeSub),sexposition)
		Set:sexNum="" sexNum = totalNum  //性别数量为空时 取总数
	}
	Set preNumObj = ..GetPreNum(DetailID)
	Set preTotal = +preNumObj.Get("total")
	Quit:preTotal>=totalNum 0 //已预约总数大于号源总数
	Set preSexNum = $CASE(SexID,1:+preNumObj.Get("maleNum"),2:+preNumObj.Get("femaleNum"),:0)
	Quit:preSexNum>=sexNum 0 //性别预约数量大于性别号源数量
	Set availNum = totalNum - preTotal
	Set sexAvialNum = sexNum - preSexNum
	Set:availNum>sexAvialNum availNum = sexAvialNum
	If LevelID'=""  //判断VIP等级可用名额
	{
		Set levelAvailNum = ..GetVIPTypeAvailNum(DetailID,PMType,LevelID,SexID)
		Set:availNum>levelAvailNum availNum = levelAvailNum
	}
	Quit availNum
}

/// Description：查询VIP等级剩余号源数量
/// Input：
///               DetailID：DHC_PE_SourceTimeManager
///               PMType：预约类型 I：个人  G：团体
/// 			  LevelID：VIP等级
///               SexID：性别ID
/// Return：       0：成功  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2023-02-02
/// Debug: w ##class(web.DHCPE.SourceManager).GetVIPTypeAvailNum("2022-10-22","2022-10-22",304)
ClassMethod GetVIPTypeAvailNum(DetailID, PMType, LevelID, SexID = "")
{
	Set mId = +DetailID
	Quit:$LISTGET(^User.DHCPESourceManagerD(mId),8)="Y" 0 //已停诊，不可预约
	Set locId = $LISTGET(^User.DHCPESourceManagerD(mId),2)
	Set timeSub = $PIECE(DetailID,"||",2) 
	Set locInfoId = $ORDER(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_locId,LevelID,""),-1)
	Quit:locInfoId="" 0  //不存在该VIP类型
	Set vipPreType = $LISTGET($GET(^CF.PE.LocVIPLevelD(locInfoId)),21)  
	Set:vipPreType="" vipPreType="A"
	Quit:(vipPreType="I")&&(PMType="G") 99999
	Quit:(vipPreType="G")&&(PMType="I") 99999
	Set:vipPreType="N" PMType="N"
	Set availNum = 99999
	Set vipSub = $ORDER(^User.DHCPESourceTimeVIPManagerI("IndOfVIPType",mId,timeSub,LevelID,PMType,""))
	If vipSub'=""
	{
		Set vipTotal = $LISTGET(^User.DHCPESourceManagerD(mId,"SMTime",timeSub,"STMVIPType",vipSub),4)
		Set vipSexNum = 99999
		If SexID'=""
		{
			Set sexposition = $CASE(SexID,1:5,2:6,:"")
			Quit:sexposition="" 0 //无效的性别ID
			Set vipSexNum = $LISTGET(^User.DHCPESourceManagerD(mId,"SMTime",timeSub,"STMVIPType",vipSub),sexposition)
			Set:vipSexNum="" vipSexNum = vipTotal  //性别数量为空时 取总数
		}
		Set preNumObj = ..GetPreNum(DetailID).Get(LevelID_"_"_PMType)
		Set preTotal=0,preSexNum=0
		If preNumObj'=""
		{
			Set preTotal = +preNumObj.Get("total")
			Quit:preTotal>=vipTotal 0 //已预约总数大于号源总数
			Set preSexNum = $CASE(SexID,1:+preNumObj.Get("maleNum"),2:+preNumObj.Get("femaleNum"),:0)
			Quit:preSexNum>=vipSexNum 0 //性别预约数量大于性别号源数量			
		}
		Set availNum = vipTotal - preTotal
		Set sexAvialNum = vipSexNum - preSexNum
		Set:availNum>sexAvialNum availNum = sexAvialNum
	}
	Quit availNum
}

}
