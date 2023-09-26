/// Creator：      ZY 2913588,2913589,2913590 
/// CreatDate：    2022-09-13
/// Description:   无形资产处理类
Class web.DHCEQ.EM.BUSIntangibleAssets Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetOneIntangibleAssets(RowID As %Library.String = "")
{
    i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("","")
    s $ZT="ERRORGetOneIntangibleAssets"
    s obj=##Class(User.DHCEQIntangibleAssets).%OpenId(RowID)
    s objInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(obj)
    d objInfo.%Set("IARowID",RowID)
    q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,objInfo)
ERRORGetOneIntangibleAssets
    s ErrorMsg=$ZE
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// Creator：      ZY
/// CreatDate：    2022-09-13
/// Description:   数据保存
/// Input：        data:前台获取字符串 field:value,filed:vale
/// Return：       ID
ClassMethod SaveData(Data)
{
    k PLIST,RowID
    s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQIntangibleAssets",JsonData,.PLIST)
    s RowID = JsonData.IARowID
    if RowID'=""
    {
        &SQL(Update SQLUSER.DHC_EQIntangibleAssets Values :PLIST() where IA_RowID = :RowID)
    }
    else
    {
        &SQL(insert into SQLUSER.DHC_EQIntangibleAssets Values :PLIST())
        s RowID=$g(%ROWID)
    }
    if SQLCODE
    {
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
    }
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
}

}
