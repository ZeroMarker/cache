Class web.DHCPE.Settings.Param Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 查询参数
/// Author:WZH 20210914
/// Param:appId
/// Debugger:d ##class(%ResultSet).RunQuery("web.DHCPE.Settings.Param","SearchParam","")
Query SearchParam(appId = "") As websys.Query(ROWSPEC = "SPRowId:%String,SPCode:%String,SPDesc:%String,SPDefault:%String,SPNote:%String")
{
}

ClassMethod SearchParamExecute(ByRef qHandle As %Binary, appId = "") As %Status
{
    Set repid=$INCREMENT(^CacheTemp)
    Set ind=1
    If appId=""{
        Set qHandle=$LISTBUILD(0,repid,0)
        Quit $$$OK
    }
    Set SP=0
    For   Set SP=$ORDER(^DHCPESettingsParam(0,"AppDr",appId,SP)) Quit:(SP="")  Do
    .Set SPData=$GET(^DHCPESettingsParam(SP))
    .Set Code=$PIECE(SPData,"^",2)
    .Set Desc=$PIECE(SPData,"^",3)
    .Set Defualt=$PIECE(SPData,"^",4)
    .Set Note=$PIECE(SPData,"^",5)
    .Set Data=$LISTBUILD(SP,Code,Desc,Defualt,Note)
    .Do OutPutRow

    Set qHandle=$LISTBUILD(0,repid,0)
    Quit $$$OK

OutPutRow
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

/// 新增参数 成功返回id 失败返回错误信息
/// Author:WZH 20210914
/// Param:SAId:应用id NotNull
/// Param:SPCode:参数编码 NotNull
/// Param:SPDesc:参数描述
/// Param:SPDefault:参数默认值
/// Param:SPNote:参数备注
/// Debugger:w ##class(web.DHCPE.Settings.Param).AddParam(5,"cas","casdf","123","")
ClassMethod AddParam(SAId = "", SPCode = "", SPDesc = "", SPDefault = "", SPNote = "") As %Status
{
    Quit:(SAId="")||(SPCode="") "-1^入参不能为空"
    Set $ZTRAP="AddParamError"
    Quit:('$DATA(^DHCPESettingsApp(SAId))) "-2^SAId不存在"
    Set myObj=##class(User.DHCPESettingsParam).%New()
    Do myObj.SPSADRSetObjectId(SAId)
    Set myObj.SPCode=SPCode
    Set myObj.SPDesc=SPDesc
    Set myObj.SPDefault=SPDefault
    Set myObj.SPNote=SPNote

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
/// Param:SPId:参数id NotNull
/// Param:SPCode:参数编码 NotNull
/// Param:SPDesc:参数描述
/// Param:SPDefault:参数默认值
/// Param:SPNote:参数备注
/// Debugger:w ##class(web.DHCPE.Settings.Param).UpdateParam()
ClassMethod UpdateParam(SPId = "", SPCode = "", SPDesc = "", SPDefault = "", SPNote = "") As %Status
{
    Quit:(SPId="")||(SPCode="") "-1^入参不能为空"
    Set $ZTRAP="UpdateParamError"
    Set myObj=##class(User.DHCPESettingsParam).%OpenId(SPId)
    Set myObj.SPCode=SPCode
    Set myObj.SPDesc=SPDesc
    Set myObj.SPDefault=SPDefault
    Set myObj.SPNote=SPNote

    Set sc=myObj.%Save()
    If $$$ISERR(sc) {
        Quit "-100^"_$SYSTEM.Status.GetErrorCodes(sc)
    }
    Quit 0
UpdateParamError
    Set $ZTRAP=""
    Quit "-200^"_$ZERROR
}

/// 删除参数 返回SQLCODE 0成功 其它失败
/// Author:WZH 20210914
/// Param:SPId:参数Id NotNull
/// Debugger:w ##class(web.DHCPE.Settings.Param).DeleteParam()
ClassMethod DeleteParam(SPId = "") As %Status
{
    Quit:(SPId="") "-1^入参不能为空"
    Tstart
    Set SQLCODE=0
    Set SQLCODE=##class(web.DHCPE.Settings.Value).DeleteValueBySPId(SPId)
    Set:SQLCODE=100 SQLCODE=0
    If SQLCODE'=0{
        Trollback
        Quit SQLCODE
    }

    &sql(DELETE FROM SQLUSER.DHC_PE_SettingsParam WHERE SP_RowId=:SPId)
    If SQLCODE'=0{
        Trollback
        Quit SQLCODE
    }
    Tcommit

    Quit SQLCODE
}

/// 删除App下关联的所有参数 返回SQLCODE 0成功 其它失败
/// Author:WZH 20210914
/// Debugger:w ##class(web.DHCPE.Settings.Param).DeleteParamByAppId()
ClassMethod DeleteParamByAppId(AppId = "") As %Status
{
    Quit:(AppId="") "-1^入参不能为空"
    Set $ZTRAP="DeleteParamByAppIdError"

    Tstart
    Set SQLCODE=0
    Set SPId=$ORDER(^DHCPESettingsParam(0,"AppDr",AppId,0))
    While (SPId'="") {
        Set SQLCODE=..DeleteParam(SPId)
        If SQLCODE'=0{
            Trollback
            Quit
        }
        Set SPId=$ORDER(^DHCPESettingsParam(0,"AppDr",AppId,SPId))
    }
    If SQLCODE=0{
        Tcommit
    }
    Quit SQLCODE
DeleteParamByAppIdError
    Set $ZTRAP=""
    Quit "-200^"_$ZERROR
}

/// 查询参数
/// Author:WZH 20210914
/// Param:appId
/// Debugger:d ##class(%ResultSet).RunQuery("web.DHCPE.Settings.Param","SearchByCodeParam","GenStatus")
Query SearchByCodeParam(appcode = "", invertedSort = "N") As websys.Query(ROWSPEC = "SPRowId:%String,SPCode:%String,SPDesc:%String,SPDefault:%String,SPNote:%String")
{
}

ClassMethod SearchByCodeParamExecute(ByRef qHandle As %Binary, appcode = "", invertedSort = "N") As %Status
{
    Set repid=$INCREMENT(^CacheTemp)
    Set ind=1
    If appcode=""{
        Set qHandle=$LISTBUILD(0,repid,0)
        Quit $$$OK
    }
    
    s appId=$o(^DHCPESettingsApp(0,"Code",appcode,0))
    If appId=""{
        Set qHandle=$LISTBUILD(0,repid,0)
        Quit $$$OK
    }
    
    Set SP=""
    i invertedSort = "Y"
    {
        
        For   Set SP=$ORDER(^DHCPESettingsParam(0,"AppDr",appId,SP),-1) Quit:(SP="")  Do
        .Do GetRowData
    }else{
        For   Set SP=$ORDER(^DHCPESettingsParam(0,"AppDr",appId,SP)) Quit:(SP="")  Do
        .Do GetRowData
    }
    
    Set qHandle=$LISTBUILD(0,repid,0)
    Quit $$$OK
GetRowData   
    Set SPData=$GET(^DHCPESettingsParam(SP))
    Set Code=$PIECE(SPData,"^",2)
    Set Desc=$PIECE(SPData,"^",3)
    Set Defualt=$PIECE(SPData,"^",4)
    Set Note=$PIECE(SPData,"^",5)
    Set Data=$LISTBUILD(SP,Code,Desc,Defualt,Note)
    Do OutCodePutRow
    q
    

OutCodePutRow
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

/// @description：获取参数配置项的描述
/// @create：yx
/// @input: AppCode 应用程序, ParamCode 参数的code
/// @return: 
/// @createdate: 2021-11-16
/// @debug: d ##class(web.DHCPE.Settings.Param).GetParamDesc(ReportWay,)
ClassMethod GetParamDesc(AppCode, ParamCode)
{
    q:(AppCode="")||(ParamCode="") ""
    
    s appId=$o(^DHCPESettingsApp(0,"Code",AppCode,0))
    q:appId="" ""
    
    s Desc=""
    Set SP=0
    For   Set SP=$ORDER(^DHCPESettingsParam(0,"AppDr",appId,SP)) Quit:(SP="")  Do
    .Set SPData=$GET(^DHCPESettingsParam(SP))
    .Set Code=$PIECE(SPData,"^",2)
    .q:(ParamCode'="")&&(ParamCode'=Code)
    .Set Desc=$PIECE(SPData,"^",3)
    .Set Defualt=$PIECE(SPData,"^",4)
    .Set Note=$PIECE(SPData,"^",5)
    
    q Desc
}

/// @description：获取参数配置项描述所对应的Code
/// @create：yuxiang1022@dhcc.com.cn
/// @input: AppCode, ParamDesc
/// @return: 
/// @createdate: 2021-11-29
/// @debug: w ##class(web.DHCPE.Settings.Param).GetParamCode("PEStatistic","体检中心工作量统计")
ClassMethod GetParamCode(AppCode, ParamDesc)
{
    q:(AppCode="")||(ParamDesc="") ""
    s appId=$o(^DHCPESettingsApp(0,"Code",AppCode,0))
    q:appId="" ""
    s Desc=ParamDesc
    s Code=""
    s Value=""
    s Remark=""
    
    Set SP=0
    For   Set SP=$ORDER(^DHCPESettingsParam(0,"AppDesc",appId,Desc,SP)) Quit:(SP="")  Do
    .Set SPData=$GET(^DHCPESettingsParam(SP))
    .Set Code=$PIECE(SPData,"^",2)
    .Set Value=$PIECE(SPData,"^",4)
    .Set Remark=$PIECE(SPData,"^",5)
    .Set Remark=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPESettingsParam",Remark,"SPNote","cls")
    q Code_"^"_Value_"^"_Remark
}

ClassMethod GetParamDefualt(AppCode, ParamCode)
{
    Quit:(AppCode="")||(ParamCode="") ""
    
    Set appId=$ORDER(^DHCPESettingsApp(0,"Code",AppCode,0))
    Quit:appId="" ""
    
    Set Desc="" , Defualt="",Note=""
    Set SP=0
    For   Set SP=$ORDER(^DHCPESettingsParam(0,"AppDr",appId,SP)) Quit:(SP="")  Do
    .Set SPData=$GET(^DHCPESettingsParam(SP))
    .Set Code=$PIECE(SPData,"^",2)
    .Quit:(ParamCode'="")&&(ParamCode'=Code)
    .Set Desc=$PIECE(SPData,"^",3)
    .Set Defualt=$PIECE(SPData,"^",4)
    .Set Note=$PIECE(SPData,"^",5)
    
    Quit Defualt
}

}
