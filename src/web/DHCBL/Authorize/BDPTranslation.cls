/// 关于翻译字段授权的维护
/// 2015-4-22 by GuXueping
Class web.DHCBL.Authorize.BDPTranslation Extends web.BDP.sys.ExtPreferencesSubKey [ Not ProcedureBlock ]
{

/// d ##class(web.DHCBL.Authorize.BDPTranslation).DHCSaveDataToServer("G","1","[{ID:1},{ID:2}]","CT_UOM")
/// w ##class(web.DHCBL.Authorize.BDPTranslation).DHCGetDataByReference("G","1","CT_UOM")
/// Element
Parameter ParaAppKey = "T";

Parameter EntityClassName = "web.Entity.Authorize.BDPTranslation";

Parameter DataSplitString = "JSON";

/// 获取功能JSON串
/// 分级
ClassMethod GetExecutableTreeJson(ParentID As %String) As %String
{
    if (ParentID="ExecutablegroupTreeRoot") s ParentID=-100000000000000
    s mySMRowID=0
    s myMenuCount=0
    s mySMSeq=0
    k myMenuArray
    
    //生成菜单索引数组
    s mySMSeq=0
    s n=0
    for {
        s mySMSeq=$o(^User.BDPMenuI("ParSeqIdx",ParentID,mySMSeq))
        q:(mySMSeq="")
        s n=n+1
        s a(n)= $p(mySMSeq," ",2)
    }
    set left=1,right=n
    d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序
    s mySMRowID=0
    s n=0
    s mySMSeq=0
    for {
        s n=$o(a(n))
        q:(n="")
        s mySMSeq=$g(a(n))
        for {
            s mySMRowID=$o(^User.BDPMenuI("ParSeqIdx",ParentID," "_mySMSeq,mySMRowID))
            q:(mySMRowID="")
            s myMenuCount=myMenuCount+1
            s myMenuArray(myMenuCount)=mySMRowID
            ;w !,mySMRowID
        }
    }
    
    //输出菜单JSON串
    s mySMRowID=0
    s myMenuSeq=0
    s myJsonStr=""
    for {
        s myMenuSeq=$o(myMenuArray(myMenuSeq))
        q:(myMenuSeq="")
        s mySMRowID=$g(myMenuArray(myMenuSeq))
        continue:mySMRowID=1 //屏蔽菜单:"系统配置"
        ;continue:mySMRowID=282 //屏蔽菜单:"产品组配置"
        
        s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
        if $IsObject(myMenuObj) {
            s myCode = myMenuObj.Code
            s myCaption = myMenuObj.Caption
            s myLinkUrl = myMenuObj.LinkUrl
            s myImage = myMenuObj.Image
            s myFuntionDR = myMenuObj.LinkFuntionDR
            s myExeCode = myMenuObj.LinkFuntionDR.Code
            s myActiveFlag = myMenuObj.ActiveFlag
            //查看该菜单是否被激活（资源定义和分配资源到科室在授权页面不显示）
            continue:(myActiveFlag'="")&&('$p(myActiveFlag,"^",2))||(myCaption="资源定义")||(myCaption="分配资源到科室")||(myCaption="访问类型位置")||(myCaption="单位转换")||(myCaption="医疗单元")
            
            //判断是否有子菜单
            if (myLinkUrl="") s myChildFlag=1
            else  s myChildFlag=0
            
            s:(myJsonStr'="") myJsonStr=myJsonStr_","
            s myJsonStr=myJsonStr_"{"
            s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
            s myJsonStr=myJsonStr_"""iconCls"":"""_""_myImage_""","
            
            if (+myChildFlag'=0) {
                s myJsonStr=myJsonStr_"""leaf"":false,"
                s myJsonStr=myJsonStr_"""expanded"":true"
                //获取子菜单
                ;s myJsonStr=myJsonStr_"""children"":"_..GetExecutableTreeJson(mySMRowID)
            }else {
                s myJsonStr=myJsonStr_"""myExeCode"":"""_""_myExeCode_""","
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

/// 获取功能JSON串
/// 不分级
ClassMethod GetExecutableTreeJson2(ExecutableDesc = "")
{
    s ETID = 0
    s code = ""
    s ETRTNJson = ""
    f  s ETID = $o(^User.BDPExecutablesD(ETID)) q:ETID=""  d
    .s obj = ##Class(User.BDPExecutables).%OpenId(ETID)
    .s code = obj.Code
    .s Caption = obj.Caption
    .if ($ZCONVERT(Caption,"U")[$ZCONVERT(ExecutableDesc,"U")) d
    ..if ETRTNJson="" d
    ...s ETRTNJson=ETRTNJson_"{id:'"_code_"',text:'"_Caption_"',leaf:true}"
    ..else  d
    ...s ETRTNJson=ETRTNJson_",{id:'"_code_"',text:'"_Caption_"',leaf:true}"
    q "["_ETRTNJson_"]"
}

/// 获取需要翻译的字段
/// w ##class(web.DHCBL.Authorize.BDPTranslation).GetAbleItemJson("G","1","SS_User")
ClassMethod GetAbleItemJson(ObjectType As %String, ObjectReference As %String, SubKey As %String) As %String
{
    //s ^temp("efase")=ObjectType_"^"_ObjectReference_"^"_SubKey
    q:ObjectReference="" "{data:[], success:true, total:0}"
    q:SubKey="" "{data:[], success:true, total:0}"
    s ItemJson="",Count=0
    
    s ItemStr=##class(web.DHCBL.Authorize.BDPTranslation).DHCGetDataByReference(ObjectType,ObjectReference,SubKey)
    s:SubKey'="" SubKey=$p($ZCONVERT(SubKey,"U"),"^",1)
    s ExecutableID = $o(^User.BDPExecutablesI("CodeIndex"," "_SubKey,""))
    q:ExecutableID="" "{data:[], success:true, total:0}"
    s ClassName=$LISTGET($G(^User.BDPExecutablesD(ExecutableID)),9)  //表名
    s ClassName=$ZCONVERT(ClassName,"U") //转换成大写
    s ParRef=$o(^User.BDPTableListI("UqIndex"," "_ClassName,0))  //表结构id、
    q:ParRef="" "{data:[], success:true, total:0}"
    s ID=0
    f  s ID=$o(^User.BDPTableListD(ParRef,"ChildField",ID)) q:ID=""  d
    .s Name=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),2)
    .s FieldType=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),5)
    .s Translation=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),6)
    .if (FieldType="String")&(Translation'="N") d
        ..s rowid=ParRef_"||"_ID
        ..s ItemStr2="{ID:"_rowid_"}"
    
        ..if (ItemStr[ItemStr2) d  //如果有权则输出
        ...if ItemJson'="" d
        ....s ItemJson =ItemJson_",{ID:"""_rowid_""",Name:"""_Name_"""}"
        ...else  d
        ....s ItemJson =ItemJson_"{ID:"""_rowid_""",Name:"""_Name_"""}"
        ...s Count=Count+1

    s ItemJson = "{data:["_ItemJson_"], success:true, total:"_Count_"}"
    q ItemJson
}

/// 获取不需要翻译的字段
/// w ##class(web.DHCBL.Authorize.BDPTranslation).GetDisableItemJson("G","1","SS_User")
ClassMethod GetDisableItemJson(ObjectType As %String, ObjectReference As %String, SubKey As %String) As %String
{
    q:ObjectReference="" "{data:[], success:true, total:0}"
    q:SubKey="" "{data:[], success:true, total:0}"
    s ItemJson="",Count=0
    
    s ItemStr=##class(web.DHCBL.Authorize.BDPTranslation).DHCGetDataByReference(ObjectType,ObjectReference,SubKey)
    s:SubKey'="" SubKey=$p($ZCONVERT(SubKey,"U"),"^",1)
    s ExecutableID = $o(^User.BDPExecutablesI("CodeIndex"," "_SubKey,""))
    q:ExecutableID="" "{data:[], success:true, total:0}"
    s ClassName=$LISTGET($G(^User.BDPExecutablesD(ExecutableID)),9)
    s ClassName=$ZCONVERT(ClassName,"U")  //转换成大写
    s ParRef=$o(^User.BDPTableListI("UqIndex"," "_ClassName,0))
    q:ParRef="" "{data:[], success:true, total:0}"
    s ID=0
    f  s ID=$o(^User.BDPTableListD(ParRef,"ChildField",ID)) q:ID=""  d
    .s Name=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),2)
    .s FieldType=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),5)
    .s Translation=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),6)
    .if (FieldType="String")&(Translation'="N") d
        ..s rowid=ParRef_"||"_ID
        ..s ItemStr2="{ID:"_rowid_"}"
        ..q:(ItemStr[ItemStr2) //如果有权则跳到下一条
        ..if ItemJson'="" d
        ...s ItemJson =ItemJson_",{ID:"""_rowid_""",Name:"""_Name_"""}"
        ..else  d
        ...s ItemJson =ItemJson_"{ID:"""_rowid_""",Name:"""_Name_"""}"
        ..s Count=Count+1
    s ItemJson = "{data:["_ItemJson_"], success:true, total:"_Count_"}"
    q ItemJson
}

/// 用于元素授权页面中功能项颜色区分
/// w ##class(web.DHCBL.Authorize.BDPTranslation).GetItemPreferences("G","1")
ClassMethod GetItemPreferences(ObjectType As %String, ObjectReference As %String) As %String
{
    //^User.BDPPreferencesI("UqIndex"," G"," 1"," T"," CT_CARPRVTP",264)
    s json=""
    
    s subLan=""
    for {
        s subLan=$o(^User.BDPPreferencesI("UqIndex"," "_ObjectType," "_ObjectReference," T",subLan))
        q:subLan=""
        s sub=$p(subLan,"^",1)
        s tablesID=$o(^User.BDPExecutablesI("CodeIndex",sub,""))
        s menuID=""
        for {
            s menuID=$o(^User.BDPMenuD(menuID))
            q:menuID=""
            s menuFunDR=$LISTGET($G(^User.BDPMenuD(menuID)),4)
            if (menuFunDR=tablesID) {
                if (json'="") {
                    s json =json_",{ID:"""_menuID_"""}"
                }
                else {
                    s json =json_"{ID:"""_menuID_"""}"
                }
                q
            }
        }
    }
    
    s json="["_json_"]"
    q json
}

/// 给其他组提供的接口
/// 根据表名，字段名，语言和翻译前中文，返回翻译后内容
/// w ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.PACRoom","ROOMDesc","EN","产科01")
ClassMethod GetTransDesc(TableName, FieldName, Languages, FieldDesc) As %String
{
    new (TableName, FieldName, Languages, FieldDesc,%session)
    q:(TableName="")||(FieldName="")||(FieldDesc="") FieldDesc
    s flag= ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPTranslation")  //2020-08-12 判断是否开启翻译功能
    if (flag="N") q FieldDesc
    s BTTransDesc=""
    s BTTableName=$ZCONVERT(TableName,"U")
    s BTFieldName=$ZCONVERT(FieldName,"U")
    if (Languages="")  //语言入参为空
    {
        if ($d(%session))  //取session的语言
        {
            s LanguagesDr=$g(%session.Data("LOGON.LANGID"))
            s:LanguagesDr'="" Languages=$p($g(^SS("LAN",LanguagesDr)),"^",1)
        }
        else
        {
            q FieldDesc  //如果没有获取到语言，默认返回要翻译的内容本身
        }
    }
    else
    {
	    if (Languages>0)
	    {
		    if $d(^SS("LAN",Languages))>0
		    {
			    s:Languages'="" Languages=$p($g(^SS("LAN",Languages)),"^",1)
		    }
	    }
    }
    s BTLanguages=$ZCONVERT(Languages,"U")
    //s BTFieldDesc=$ZCONVERT(FieldDesc,"U")
    s BTFieldDesc=FieldDesc
    if $l(BTFieldDesc)>200 s BTFieldDesc=$e(BTFieldDesc,1,200)
    q:(BTTableName="")||(BTFieldName="")||(BTLanguages="")||(BTFieldDesc="") ""
    s id=$o(^User.BDPTranslationI("TransIndex"," "_BTTableName," "_BTFieldName," "_BTLanguages,BTFieldDesc,0))
    if (id=""){
        s BTTransDesc=FieldDesc
    }else{
        s BTTransDesc=$LISTGET($G(^User.BDPTranslationD(id)),6)
    }
    //s BTTransDesc=$o(^User.BDPTranslationI("TransIndex"," "_BTTableName," "_BTFieldName," "_BTLanguages," "_BTFieldDesc,""))
    
    q BTTransDesc
}

/// 给基础平台组提供的接口
/// 2021-10-11
/// chenying
/// 根据表名，字段名，语言和翻译后内容，返回翻译前中文
/// w ##class(web.DHCBL.Authorize.BDPTranslation).GetBeforeTransDesc("User.CTLoc","CTLOCDesc","EN","obstetrical department")
ClassMethod GetBeforeTransDesc(TableName, FieldName, Languages, FieldDesc) As %String
{
    new (TableName, FieldName, Languages, FieldDesc,%session)
    q:(TableName="")||(FieldName="")||(FieldDesc="") FieldDesc
    s flag= ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPTranslation")  //2020-08-12 判断是否开启翻译功能
    if (flag="N") q FieldDesc
    s BTTransDesc=""
    s BTTableName=$ZCONVERT(TableName,"U")
    s BTFieldName=$ZCONVERT(FieldName,"U")
    if (Languages="")  //语言入参为空
    {
        if ($d(%session))  //取session的语言
        {
            s LanguagesDr=$g(%session.Data("LOGON.LANGID"))
            s:LanguagesDr'="" Languages=$p($g(^SS("LAN",LanguagesDr)),"^",1)
        }
        else
        {
            q FieldDesc  //如果没有获取到语言，默认返回要翻译的内容本身
        }
    }
    s BTLanguages=$ZCONVERT(Languages,"U")
    s BTFieldDesc=FieldDesc
    q:(BTTableName="")||(BTFieldName="")||(BTLanguages="")||(BTFieldDesc="") ""
    if $l(BTFieldDesc)>200 s BTFieldDesc=$e(BTFieldDesc,1,200)
    s BTBeforeTransDesc=$o(^User.BDPTranslationI("SrcIndex"," "_BTTableName," "_BTFieldName," "_BTLanguages,BTFieldDesc,0))
    q:BTBeforeTransDesc'="" BTBeforeTransDesc
    q FieldDesc
}

/// 基础数据自己用
/// 根据表名，字段名，语言和翻译前中文，返回翻译后内容
/// w ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDescOwn("User.PACRoom","ROOMDesc","EN","产科01")
ClassMethod GetTransDescOwn(TableName, FieldName, Languages, FieldDesc) As %String
{
    new (TableName, FieldName, Languages, FieldDesc,%session)   
    q:(TableName="")||(FieldName="")||(FieldDesc="") ""
    s BTTableName=$ZCONVERT(TableName,"U")
    s BTFieldName=$ZCONVERT(FieldName,"U")
    if (Languages="")  //语言入参为空
    {
        if ($d(%session))  //取session的语言
        {
            s LanguagesDr=$g(%session.Data("LOGON.LANGID"))
            s:LanguagesDr'="" Languages=$p($g(^SS("LAN",LanguagesDr)),"^",1)
        }
        else
        {
            q ""
        }
    }
    s BTLanguages=$ZCONVERT(Languages,"U")
    //s BTFieldDesc=$ZCONVERT(FieldDesc,"U")
    s BTFieldDesc=FieldDesc
    q:(BTTableName="")||(BTFieldName="")||(BTLanguages="")||(BTFieldDesc="") ""
    if $l(BTFieldDesc)>200 s BTFieldDesc=$e(BTFieldDesc,1,200)
    s id=$o(^User.BDPTranslationI("TransIndex"," "_BTTableName," "_BTFieldName," "_BTLanguages,BTFieldDesc,0))

    if (id=""){
        s BTTransDesc=""
    }else{
        s BTTransDesc=$LISTGET($G(^User.BDPTranslationD(id)),6)
    }
    //s BTTransDesc=$o(^User.BDPTranslationI("TransIndex"," "_BTTableName," "_BTFieldName," "_BTLanguages," "_BTFieldDesc,""))
    q id_"^"_BTTransDesc
}

/// 获取翻译语言下拉框数据
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSLanguage","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTLANRowId:%String,CTLANCode:%String,CTLANDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    
    if (rowid'="")
    {
        s CTLANRowId=rowid
        s CTLANCode=$p($g(^SS("LAN",CTLANRowId)),"^",1)
        s CTLANDesc=$p($g(^SS("LAN",CTLANRowId)),"^",2)
        d OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s AuStr=##class(web.DHCBL.Authorize.SSLanguage).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        s CTLANRowId=0
        for
        {
            s CTLANRowId=$o(^SS("LAN",CTLANRowId)) q:CTLANRowId=""
            s strRowId="{ID:"_CTLANRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s CTLANCode=$p($g(^SS("LAN",CTLANRowId)),"^",1)
                s CTLANDesc=$p($g(^SS("LAN",CTLANRowId)),"^",2)
                s CTLANCode1=$ZCONVERT(CTLANCode,"U")
                s CTLANDesc1=$ZCONVERT(CTLANDesc,"U")
                
                //别名查询
                s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","SS_Language",CTLANRowId,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                }

                i (CTLANCode1[code)&((CTLANDesc1[desc)||(ALIASText1[desc))&((CTLANCode1'="CH")||(CTLANDesc1'="CHINESE"))
                {
                    d OutputRowCmb
                }
            }
    
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(CTLANRowId,CTLANCode,CTLANDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
