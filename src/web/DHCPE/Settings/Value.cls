Class web.DHCPE.Settings.Value Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 根据App、Param获取Value
/// Author:WZH 20210914
/// Param:AppCode:应用编码
/// Param:ParamCode:参数编码
/// Debugger:w ##class(web.DHCPE.Settings.Value).GetValue("appointprivacy","Name")
ClassMethod GetValue(AppCode = "", ParamCode = "") As %Status
{
    Quit:(AppCode="")||(ParamCode="") ""

    Set appId=$ORDER(^DHCPESettingsApp(0,"Code",AppCode,0))
    Quit:(appId="") "" ;AppCode 不存在

    Set paramId=0
    Set PMId=""
    For  Set PMId=$ORDER(^DHCPESettingsParam(0,"AppDr",appId,PMId)) Quit:(PMId="")||(paramId'=0)  Do
    .Set PMCode=$PIECE(^DHCPESettingsParam(PMId),"^",2)
    .Set:ParamCode=PMCode paramId=PMId

    Quit:paramId=0 ""

    Set sessionObj={}
    If $DATA(%session) Do
    .Set sessionObj.U=%session.Get("LOGON.USERID")
    .Set sessionObj.L=%session.Get("LOGON.CTLOCID")
    .Set sessionObj.G=%session.Get("LOGON.GROUPID")
    .Set sessionObj.H=%session.Get("LOGON.HOSPID")
    Else  Do
    .Set sessionObj.U=13811
    .Set sessionObj.L=23
    .Set sessionObj.G=737
    .Set sessionObj.H=2
    
    Set ^tempwzh("DHCPESettingsValue")=sessionObj.%ToJSON()
    Set value=""
    ; 类型优先级 用户 -- 安全组 -- 科室 -- 院区
    Set TypeArr=["U","G","L","H"]
    Set iter=TypeArr.%GetIterator()
    Set flag=0
    While (iter.%GetNext(.index,.type)) {
        Set SVId=0
        For  Set SVId=$ORDER(^DHCPESettingsValue(0,"ParamDr",paramId,"Type",type,SVId)) Quit:(SVId="")||(flag=1)  Do
        .Set SVData=$GET(^DHCPESettingsValue(SVId))
        .Set TypeValue=$PIECE(SVData,"^",3)
        .Set myValue=sessionObj.%Get(type)
        .Quit:(TypeValue'=myValue)
        .Set ParamValue=$PIECE(SVData,"^",4)
        .Set value=ParamValue
        .Set flag=1
        Quit:(flag=1)
    }
    ; 不能通过判断value是否为空来取param默认值，因为设置的value有可能本身就是空
    If 'flag{
        Set paramData=$GET(^DHCPESettingsParam(paramId))
        Set Default=$PIECE(paramData,"^",4)
        Set value=Default
    }
    Quit value
}

/// 查询参数
/// Author:WZH 20210914
/// Param:appId
/// Debugger:d ##class(%ResultSet).RunQuery("web.DHCPE.Settings.Value","SearchValue","CSource")
Query SearchValue(paramId = "") As websys.Query(ROWSPEC = "SVRowId:%String,SVType:%String,SVTypeValue:%String,SVParamValue:%String,TypeDesc,TypeValueDesc,Remark")
{
}

ClassMethod SearchValueExecute(ByRef qHandle As %Binary, paramId = "") As %Status
{
    Set repid=$INCREMENT(^CacheTemp)
    Set ind=1
    If paramId=""{
        Set qHandle=$LISTBUILD(0,repid,0)
        Quit $$$OK
    }
    Set Type=""
    For  Set Type=$ORDER(^DHCPESettingsValue(0,"ParamDr",paramId,"Type",Type)) Quit:(Type="")  Do
    .Set SV=0
    .For  Set SV=$ORDER(^DHCPESettingsValue(0,"ParamDr",paramId,"Type",Type,SV)) Quit:(SV="")  Do
    ..Set SVData=$GET(^DHCPESettingsValue(SV))
    ..;Set Type=$PIECE(SVData,"^",2)
    ..Set TypeValue=$PIECE(SVData,"^",3)
    ..Set ParamValue=$PIECE(SVData,"^",4)
    
    ..Set TypeDesc=..GetTypeDesc(Type)
    ..Set TypeValueDesc=..GetTypeValueDesc(Type,TypeValue)
    ..Set Remark=$PIECE(SVData,"^",5)
    
    ..Set Data=$LISTBUILD(SV,Type,TypeValue,ParamValue,TypeDesc,TypeValueDesc,Remark)
    ..Do OutPutRow

    Set qHandle=$LISTBUILD(0,repid,0)
    Quit $$$OK

OutPutRow
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

/// 新增参数值 成功返回id 失败返回错误信息
/// Author:WZH 20210914
/// Param:SPId:参数id NotNull
/// Param:SVType:参数类型 NotNull
/// Param:SVTypeValue:参数类型值 NotNull
/// Param:SVParamValue:参数值
/// Debugger:w ##class(web.DHCPE.Settings.Value).AddValue()
ClassMethod AddValue(SPId = "", SVType = "", SVTypeValue = "", SVParamValue = "", Remark = "") As %Status
{
    Set:(SVType="C")&&(SVTypeValue="") SVTypeValue="C"  //自定义类型
    Quit:(SPId="")||(SVType="")||(SVTypeValue="") "-1^入参不能为空"
    Set $ZTRAP="AddParamError"
    Quit:('$DATA(^DHCPESettingsParam(SPId))) "-2^SPId不存在"
    Set myObj=##class(User.DHCPESettingsValue).%New()
    Do myObj.SVSPDRSetObjectId(SPId)
    Set myObj.SVType=SVType
    set SPSA=$p(^DHCPESettingsParam(SPId),"^",1)
    set SACode=$p(^DHCPESettingsApp(SPSA),"^",1)
    s Flag=0
    i (SACode="PEComplain")&&(SVType="C") d
    .i $D(^DHCPESettingsValue(0,"ParamTV",SPId,"Type",SVType,SVTypeValue)) s Flag=1
    q:Flag=1 "-3^代码重复"

    Set myObj.SVTypeValue=SVTypeValue
    Set myObj.SVParamValue=SVParamValue
    Set myObj.SVRemark = Remark

    Set sc=myObj.%Save()
    If $$$ISERR(sc) {
        Quit "-100^"_$SYSTEM.Status.GetErrorCodes(sc)
    }

    Quit myObj.%Id()
AddParamError
    Set $ZTRAP=""
    Quit "-200^"_$ZERROR
}

/// 更新参数内容 成功返回0 失败返回错误信息
/// Author:WZH 20210914
/// Param:SVId:值id NotNull
/// Param:SVType:参数类型 NotNull
/// Param:SVTypeValue:参数类型值 NotNull
/// Param:SVParamValue:参数值
/// Debugger:w ##class(web.DHCPE.Settings.Value).UpdateValue()
ClassMethod UpdateValue(SVId = "", SVType = "", SVTypeValue = "", SVParamValue = "", Reamrk = "") As %Status
{
    
    Set:(SVType="C")&&(SVTypeValue="") SVTypeValue="C"  //自定义类型
    Quit:(SVId="")||(SVType="")||(SVTypeValue="") "-1^入参不能为空"
    Set $ZTRAP="UpdateParamError"
    Set myObj=##class(User.DHCPESettingsValue).%OpenId(SVId)
    Set myObj.SVType=SVType    
    Set myObj.SVTypeValue=SVTypeValue
    Set myObj.SVParamValue=SVParamValue
    Set myObj.SVRemark = Reamrk

    Set sc=myObj.%Save()
    If $$$ISERR(sc) {
        Quit "-100^"_$SYSTEM.Status.GetErrorCodes(sc)
    }
    Quit 0
UpdateParamError
   Set $ZTRAP=""
    Quit "-200^"_$ZERROR
}

/// 根据值Id删除一个值 返回SQLCODE 0成功 其它失败
/// Author:WZH 20210914
/// Param:SVId:值Id NotNull
/// Debugger:w ##class(web.DHCPE.Settings.Value).DeleteValue()
ClassMethod DeleteValue(SVId = "") As %Status
{
    Quit:(SVId="") "-1^入参不能为空"
    &SQL(DELETE FROM SQLUSER.DHC_PE_SettingsValue WHERE SV_RowId=:SVId)
    Quit SQLCODE
}

/// 删除参数，删除同一个参数的值 返回SQLCODE 0成功 其它失败
/// Author:WZH 20210914
/// Param:SPId:参数Id NotNull
/// Debugger:w ##class(web.DHCPE.Settings.Value).DeleteValueBySPId()
ClassMethod DeleteValueBySPId(SPId = "") As %Status
{
    Quit:(SPId="") "-1^入参不能为空"
    &SQL(DELETE FROM SQLUSER.DHC_PE_SettingsValue WHERE SV_SP_DR=:SPId)
    Set:SQLCODE=100 SQLCODE=0
    Quit SQLCODE
}

/// w ##class(web.DHCPE.Settings.Value).GetTypeDesc("C")
ClassMethod GetTypeDesc(PV = "")
{
    Set obj={}
    Do obj.%Set("H","全院")
    Do obj.%Set("L","科室")
    Do obj.%Set("G","安全组")
    Do obj.%Set("U","人员")
    Do obj.%Set("V","VIP等级")
    Do obj.%Set("C","自定义")
    Quit obj.%Get(PV)
}

ClassMethod GetTypeValueDesc(Type = "", Value = "")
{
    Set ^tempwzh("GetTypeValueDesc")=$LISTBUILD(Type,Value)
    Set Desc=""
    Quit:Type="H" ..GetHospitalDesc(Value)
    Quit:Type="L" ..GetLocDesc(Value)
    Quit:Type="G" ..GetGroupDesc(Value)
    Quit:Type="U" ..GetUserDesc(Value)
    Quit:Type="V" ..GetVIPDesc(Value)
    Quit:Type="C" Value
    Quit Desc
}

ClassMethod GetHospitalDesc(id = "")
{
    Quit:id="" ""
    Quit:'$DATA(^CT("HOSP",id)) ""
    Quit $PIECE(^CT("HOSP",id),"^",2)
}

ClassMethod GetLocDesc(id)
{
    Quit:id="" ""
    Quit:'$DATA(^CTLOC(id)) ""
    Quit $PIECE(^CTLOC(id),"^",2)
}

ClassMethod GetGroupDesc(id = "")
{
    Quit:id="" ""
    Quit:'$DATA(^SSU("SSGRP",id)) ""
    Quit $PIECE(^SSU("SSGRP",id),"^",1)
}

ClassMethod GetUserDesc(id)
{
    Quit:id="" ""
    Quit:'$DATA(^SSU("SSUSR",id)) ""
    Quit $PIECE(^SSU("SSUSR",id),"^",2)
}

ClassMethod GetVIPDesc(id)
{
    Quit:id="" ""
    Quit $lg($g(^CT.PE.VIPLevelD(id)),3)
}

/// 查询参数
/// Debugger:d ##class(%ResultSet).RunQuery("web.DHCPE.Settings.Value","QueryValue","HealthCard","Conclusion","V")
Query QueryValue(APPCode, ParamCode, CType, Desc = "", TypeId = "") As websys.Query(ROWSPEC = "SVRowId:%String,SVType:%String,SVTypeValue:%String,SVParamValue:%String,TypeDesc,TypeValueDesc")
{
}

ClassMethod QueryValueExecute(ByRef qHandle As %Binary, APPCode, ParamCode, CType, Desc = "", TypeId = "") As %Status
{
    Set repid=$INCREMENT(^CacheTemp)
    Set ind=1
    
    s appId = $O(^DHCPESettingsApp(0,"Code",APPCode,""))
    If appId=""{
        Set qHandle=$LISTBUILD(0,repid,0)
        Quit $$$OK
    }
    s paramId = $O(^DHCPESettingsParam(0,"APPCode",appId,ParamCode,""))
    If paramId=""{
        Set qHandle=$LISTBUILD(0,repid,0)
        Quit $$$OK
    }
    
    Set Type=""
    For  Set Type=$ORDER(^DHCPESettingsValue(0,"ParamDr",paramId,"Type",Type)) Quit:(Type="")  Do
    .q:(CType'="")&&(Type'=CType)
    .Set SV=0
    .For  Set SV=$ORDER(^DHCPESettingsValue(0,"ParamDr",paramId,"Type",Type,SV)) Quit:(SV="")  Do
    ..Set SVData=$GET(^DHCPESettingsValue(SV))
    ..;Set Type=$PIECE(SVData,"^",2)
    ..Set TypeValue=$PIECE(SVData,"^",3)
    ..Set ParamValue=$PIECE(SVData,"^",4)
    ..q:(TypeId'="")&&(TypeValue'=TypeId)
    ..Set TypeDesc=..GetTypeDesc(Type)
    ..Set TypeValueDesc=..GetTypeValueDesc(Type,TypeValue)
    ..q:(Desc'="")&&(TypeValueDesc'[Desc)
    ..Set Data=$LISTBUILD(SV,Type,TypeValue,ParamValue,TypeDesc,TypeValueDesc)
    ..Do OutPutRow

    Set qHandle=$LISTBUILD(0,repid,0)
    Quit $$$OK

OutPutRow
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

}
