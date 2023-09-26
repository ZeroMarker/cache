/// 关于数据翻译的维护
/// 2015-5-5 by GuXueping
Class web.DHCBL.BDP.BDPTranslation Extends web.BDP.sys.ExtPreferences [ Not ProcedureBlock ]
{

/// Description：打开数据
/// Table：User.BDPTranslation
/// Input：id
/// Other: w ##class(web.DHCBL.BDP.BDPTranslation).OpenData("CT_Loc","EN","1")
ClassMethod OpenData(TableName As %String, Languages As %String, rowid As %String) As %String
{
    
    s myJsonStr=""
    s ParRef=$o(^User.BDPTableListI("NameIndex"," "_$zcvt(TableName,"U"),0)) //直接取表结构登记里得数据
    if ParRef=""
    {
	    //找不到的才取功能元素大表
	    s strClassInfo= ##class(web.DHCBL.BDP.BDPExecutables).GetClassInfoByCode(TableName) //根据表名->user类名->表结构维护的rowId
	    s classAllName=$p(strClassInfo,"^",1)
	    s ParRef=$o(^User.BDPTableListI("UqIndex"," "_$ZCONVERT(classAllName,"U"),0))     
    }
    Else
    {
	    s classAllName=$LISTGET($G(^User.BDPTableListD(ParRef)),2) //表字段描述  
    }
    q:ParRef="" ""
    s count=0
 
    s ID=0
    for 
    {
        s ID=$o(^User.BDPTableListD(ParRef,"ChildField",ID)) q:ID=""  
        s FieldRowId=ParRef_"||"_ID
        s FieldDesc=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),2) //表字段描述
        continue:$ZCVT(FieldDesc,"u")["ROWID"  //过滤掉RowId
        
        s FieldType=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),5)
        s FieldTranslation=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),6)
        continue:((FieldTranslation="N")||(FieldTranslation="")||(FieldType'="String"))    //过滤不可翻译字段 2020-4-27 钟荣枫 
        s count=count+1
             
        s FieldName=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),3) //获取字段名FieldName    
        s TitleDesc=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),2) 
       
         //根据表名和字段名->翻译前中文
        s desc=""
        s xobjStr="s dataobj=##class("_classAllName_").%OpenId("""_rowid_""")"
        //if (classAllName="User.ARCItmMast")&(rowid'["||") s xobjStr="s dataobj=##class("_classAllName_").%OpenId("""_rowid_"||1"_""")"  //医嘱项特殊
        x xobjStr
        
        s FieldName=$tr(FieldName,"_","")  //有些字段错误得维护了_
        s FieldName=$tr(FieldName," ","")
        if (dataobj)&&(FieldName'="")
        {
            s DescXstr="s desc=dataobj."_FieldName
            x DescXstr
            
        }
        if Languages="" s Languages="EN"
        ///过滤乱码、回车符
        s desc=##class(ext.util.String).EvalJSON(desc)
        //根据表名，字段名，语言，翻译前中文->翻译后内容、
        s descAf=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDescOwn(classAllName, FieldName, Languages, desc)
        s TransDesc=$p(descAf,"^",2)
        s TransDesc=##class(ext.util.String).EvalJSON(TransDesc)
        s:(myJsonStr'="") myJsonStr=myJsonStr_","
        s myJsonStr=myJsonStr_"{"
        s myJsonStr=myJsonStr_"""BTFieldDesc"":"""_""_desc_""",""BTTransDesc"":"""_TransDesc_""",""BTFieldName"":"""_FieldName_""",""TitleDesc"":"""_TitleDesc_""",""classAllName"":"""_classAllName_""""
        s myJsonStr=myJsonStr_"}"
    }
    
    s myJsonStr="{success:'true',data:["_myJsonStr_"],totalCount:"_count_"}"
      
    if count=0
    {
        s myJsonStr="{success:'false',info:'没有需要翻译的字段，请在表结构登记界面设置是否可翻译!'}"
    }  
    q myJsonStr
}

/// 获取翻译语言下拉框数据
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPTranslation","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, table As %String) As %Query(ROWSPEC = "CTLANRowId:%String,CTLANCode:%String,CTLANDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, table As %String) As %Status
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
            s CTLANRowId=$o(^SS("LAN",CTLANRowId)) 
            q:CTLANRowId=""
            s strRowId="{ID:"_CTLANRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s CTLANCode=$p($g(^SS("LAN",CTLANRowId)),"^",1)
                s CTLANDesc=$p($g(^SS("LAN",CTLANRowId)),"^",2)
                s CTLANCode1=$ZCONVERT(CTLANCode,"U")
                s CTLANDesc1=$ZCONVERT(CTLANDesc,"U")
                
                /*
                s subkey=table_"^"_CTLANCode     //CT_CarPrvTp^EN
                //获取在翻译功能配置界面授权的数据
                s ItemStr=##class(web.DHCBL.Authorize.BDPTranslation).DHCGetDataByReference("G","1",subkey)
                if (ItemStr'="[]")&(ItemStr'="") 
                {  //如果存在授权数据
                    s result=1
                }
                else
                {
                    s result=0
                }   
                */
                //别名查询
                s ALIASText1=""
                s AliasRowId=0
                for
                {
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","SS_Language",CTLANRowId,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                }

                i (CTLANCode1[code)&((CTLANDesc1[desc)||(ALIASText1[desc)) // &(result=1)
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

/// Creator：chenying
/// CreatDate: 2020-04-24
/// Description：保存翻译数据
/// Table：User.BDPTranslation
/// Input：ClassName（类名称，User.CTCareProv), Language(语言，如英文：EN)，args（翻译数据： 字段名^字段值^翻译后得值&#字段名^字段值^翻译后得值）
/// Others:w ##class(web.DHCBL.BDP.BDPTranslation).SaveBDPTranslation("User.CTCareProv","EN","CTPCPDesc^主治医师^Attending Doctor&#CTSPCDesc^主任医师^Director")
ClassMethod SaveBDPTranslation(ClassName As %String, Language As %String, args As %String) As %String
{
    n (ClassName,Language,args)
    s result=""
    Ts  
    s argsLen=$Length(args,"&#")
    for i=1:1:argsLen       
    {
        s TranslationStr=$p(args,"&#",i)
        s BTFieldName=$p(TranslationStr,"^",1)  
        s BTFieldDesc=$p(TranslationStr,"^",2)
        s BTTransDesc=$p(TranslationStr,"^",3)
        s ID = $o(^User.BDPTranslationI("TransIndex"," "_$ZCVT(ClassName,"U")," "_$ZCVT(BTFieldName,"U")," "_$ZCVT(Language,"U"),$e(BTFieldDesc,1,200),""))
        if (ID'="")
        {
            s obj=##class(User.BDPTranslation).%OpenId(ID)
        }
        else
        {
            s obj=##class(User.BDPTranslation).%New()
        }
        s obj.BTTableName=ClassName     //例如 User.CTCareProv
        s obj.BTFieldName=BTFieldName   //字段名
        s obj.BTFieldDesc=BTFieldDesc  ///// 翻译前中文
        s obj.BTLanguages=Language  
        s obj.BTTransDesc=BTTransDesc   ///翻译内容
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            s result = result_"^"_1
        }
        else
        {
            s result = result_"^"_0 
        }
    }
    if (result[0)
    {       
        Trollback
        s result = "{success:'false',errorinfo:'保存失败'}"         
    }
    else
    {
        Tc
        s result = "{success:'true',info:'保存成功！'}"
    }
            
    q result
}

/// Function:保存修改
/// Others:w ##class(web.DHCBL.BDP.BDPTranslation).SaveData("CT_Spec","EN","57","CTSPCCode^01&#CTSPCDesc^zhuanchang01")
ClassMethod SaveData(TableName As %String, Languages As %String, rowid As %String, args As %String) As %String
{
    n (TableName,Languages,rowid,args)
    s result=""
    s ParRef=$o(^User.BDPTableListI("NameIndex"," "_$zcvt(TableName,"U"),0)) //直接取表结构登记里得数据
    if ParRef=""
    {
	    //找不到的才取功能元素大表
	    s strClassInfo= ##class(web.DHCBL.BDP.BDPExecutables).GetClassInfoByCode(TableName) //根据表名->user类名->表结构维护的rowId
	    s classAllName=$p(strClassInfo,"^",1)
	    s ParRef=$o(^User.BDPTableListI("UqIndex"," "_$ZCONVERT(classAllName,"U"),0))     
    }
    Else
    {
	    s classAllName=$LISTGET($G(^User.BDPTableListD(ParRef)),2) //表字段描述  
    }
    q:classAllName="" ""
    Ts  
    s argsLen=$Length(args,"&#")
    for i=1:1:argsLen       
    {
        s Translation=$p(args,"&#",i)
        
        s BTFieldName=$p(Translation,"^",1) 
        s BTTransDesc=$p(Translation,"^",2)
        //根据表名和字段名->翻译前中文
        S desc=""
        s xobjStr="s dataobj=##class("_classAllName_").%OpenId("""_rowid_""")"
        //if classAllName="User.ARCItmMast" s xobjStr="s dataobj=##class("_classAllName_").%OpenId("""_rowid_"||1"_""")"  //医嘱项特殊
        x xobjStr
        if (dataobj)&&(BTFieldName'="")
        {
            s DescXstr="s desc=dataobj."_BTFieldName
            x DescXstr
            
        }
        ///过滤乱码、回车符
        s desc=##class(ext.util.String).EvalJSON(desc)
        s BTFieldDesc=desc  
        if (BTTransDesc="")     //翻译后内容允许为空，如果为空且原先有数据，删除该数据 2020-4-27 钟荣枫
        {
            s BTRowId = $o(^User.BDPTranslationI("TransIndex"," "_$ZCVT(classAllName,"U")," "_$ZCVT(BTFieldName,"U")," "_$ZCVT(Languages,"U"),$e(BTFieldDesc,1,200),0))
            d:BTRowId'="" ..DeleteData(BTRowId)
            
            s NewclassAllName="",NewBTFieldName=""
            //如果是用户， 同步删除医护人员翻译
			if (classAllName="User.SSUser")&&(BTFieldName="SSUSRName")
			{
				s SSUSRCareProvDR=$p($g(^SSU("SSUSR",rowid)),"^",14)      //医护人员DR
				if SSUSRCareProvDR'=""
				{
					s NewclassAllName="User.CTCareProv"
					S NewBTFieldName="CTPCPDesc"
				}
				
			}
			//如果是医护人员， 同步删除用户翻译
			if (classAllName="User.CTCareProv")&&(BTFieldName="CTPCPDesc")
			{
				s UserId=$o(^SSU("SSUSR",0,"CTPCP",rowid,0))
				if UserId'=""
				{
					s NewclassAllName="User.SSUser"
					S NewBTFieldName="SSUSRName"
				}
			}
			//如果是科室，同步删除病区翻译
			if (classAllName="User.CTLoc")&&(BTFieldName="CTLOCDesc")
			{
				s WARDRowID=$o(^PAWARD(0,"WARD_LocationDR",rowid,0))
				if (WARDRowID'="")
				{
					s NewclassAllName="User.PACWard"
					S NewBTFieldName="WARDDesc"
				}
			}
			If (NewclassAllName'="")&&(NewBTFieldName'="")
			{
				s transid=$o(^User.BDPTranslationI("TransIndex"," "_$zcvt(NewclassAllName,"U")," "_$zcvt(NewBTFieldName,"U")," "_$zcvt(Languages,"U"),$e(BTFieldDesc,1,200),0))
		        if (transid'="")
		        {
		            d ..DeleteData(transid)
		        }
			}
            continue
        }
        
        s descAf=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDescOwn(classAllName, BTFieldName, Languages, BTFieldDesc)
        s ID=$p(descAf,"^",1)
        if (ID'="")
        {
            s obj=##class(User.BDPTranslation).%OpenId(ID)
        }
        else
        {
            s obj=##class(User.BDPTranslation).%New()
        }
        s obj.BTTableName=classAllName
        s obj.BTFieldName=BTFieldName
        s obj.BTFieldDesc=BTFieldDesc
        s obj.BTLanguages=Languages
        s obj.BTTransDesc=BTTransDesc
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            s result = result_"^"_1
			
			s transid=""
			if (BTTransDesc'="")
			{
				s NewclassAllName="",NewBTFieldName=""
				//如果是用户， 同步数据到医护人员翻译
				if (classAllName="User.SSUser")&&(BTFieldName="SSUSRName")
				{
					s SSUSRCareProvDR=$p($g(^SSU("SSUSR",rowid)),"^",14)      //医护人员DR
					if SSUSRCareProvDR'=""
					{
						s NewclassAllName="User.CTCareProv"
						S NewBTFieldName="CTPCPDesc"
					}
					
				}
				//如果是医护人员， 同步数据到用户翻译
				if (classAllName="User.CTCareProv")&&(BTFieldName="CTPCPDesc")&&(BTTransDesc'="")
				{
					s UserId=$o(^SSU("SSUSR",0,"CTPCP",rowid,0))
					if UserId'=""
					{
						s NewclassAllName="User.SSUser"
						S NewBTFieldName="SSUSRName"
					}
				}
				//如果是科室，同步病区
				if (classAllName="User.CTLoc")&&(BTFieldName="CTLOCDesc")&&(BTTransDesc'="")
				{
					s WARDRowID=$o(^PAWARD(0,"WARD_LocationDR",rowid,0))
					if (WARDRowID'="")
					{
						s NewclassAllName="User.PACWard"
						S NewBTFieldName="WARDDesc"
					}
				}
				If (NewclassAllName'="")&&(NewBTFieldName'="")
				{
					s transid=$o(^User.BDPTranslationI("TransIndex"," "_$zcvt(NewclassAllName,"U")," "_$zcvt(NewBTFieldName,"U")," "_$zcvt(Languages,"U"),$e(BTFieldDesc,1,200),0))
			        if (transid'="")
			        {
			            s obj=##class(User.BDPTranslation).%OpenId(transid)
			        }
			        else
			        {
			            s obj=##class(User.BDPTranslation).%New()
			        }
			        s obj.BTTableName=NewclassAllName
			        s obj.BTFieldName=NewBTFieldName
			        s obj.BTFieldDesc=BTFieldDesc
			        s obj.BTLanguages=Languages
			        s obj.BTTransDesc=BTTransDesc
			        s sc=obj.%Save()
			        d obj.%Close()
				}
			}
        }
        else
        {
            s result = result_"^"_0 
        }
    }
    if (result[0)
    {       
        Trollback
        s result = "{success:'false',errorinfo:'保存失败'}"         
    }
    else
    {
        Tc
        s result = "{success:'true',info:'保存成功！'}"
    }
            
    q result
}

/// Function:判断翻译按钮是否开启。如果平台配置里开启翻译功能，则判断是否有翻译配置数据
/// Others:w ##class(web.DHCBL.BDP.BDPTranslation).IfTransLation("PAC_Room")
ClassMethod IfTransLation(table As %String) As %String
{
    n (table,%session)
    s result="",flag="false"
    s:table'="" tableUp=" "_$ZCONVERT(table,"U")
    s value=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPTranslation")
    
    if (value="Y")
    { //如果平台配置里开启翻译功能
    
    /*  s subLan=""
        for 
        {
            s subLan=$o(^User.BDPPreferencesI("UqIndex"," G"," 1"," T",subLan))  // CT_CAREPROV^EN(前面有空格)
            q:subLan=""
            s sub=$p(subLan,"^",1)
            s lan=$p(subLan,"^",2)
            if (sub=tableUp)
            {
                s subkey=table_"^"_lan     //CT_CarPrvTp^EN
                //获取授权的数据
                s ItemStr=##class(web.DHCBL.Authorize.BDPTranslation).DHCGetDataByReference("G","1",subkey)
                if (ItemStr'="[]")&(ItemStr'="") 
                {
                    s result=result_"^"_1
                }
                else
                {
                    s result=result_"^"_0
                }       
            }
    
        }
        if (result["1")
        {
            s flag="false"
        
        }else
        {
            s flag="true"
        }  */
        s flag="false"
    }
    else
    {  //如果没有开启翻译功能,翻译按钮的hidden属性为true
        s flag="true"
    }
    q flag
}

/// Creator:李欣
/// CreatDate:2017-09-12
/// Description:获取对应表字段翻译情况
/// Table:User.BDPTranslation
/// Input:rowid:String tablename:String fieldname:String language:String
/// Output:RowId:String;BTTableName:String;BTFieldName:String;BTLanguage:String;BTFieldDesc:String;BTTransDesc:String
/// Return:
/// Others:d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPTranslation","GetList","","","")
Query GetList(rowid As %String, language As %String, fielddesc As %String) As %Query(ROWSPEC = "RowId:%String,Language:%String,FieldDesc:%String,TransDesc:%String")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, language As %String, fielddesc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1  
    if (rowid'="")  
    {
        s BTRowId = rowid
        s BT = ##class(User.BDPTranslation).%OpenId(rowid)
        s BTTableName = "User.OTHER"
        s BTFieldName = "OTHER"
        s languages = BT.BTLanguages
        s BTLanguage =""
        if (languages'="")
        {
            s LanRowId = $o(^SS("LAN",0,"Code",$ZCVT(languages,"U"),0))
            s:LanRowId'="" BTLanguage = $p($g(^SS("LAN",LanRowId)),"^",2)
        }
        s BTFieldDesc = BT.BTFieldDesc
        s BTTransDesc = BT.BTTransDesc
        d OutputRow1
    }
    else
    {
        
        if (language'="")
        {
            ///根据Desc拿Code
            s lanid = $o(^SS("LAN",0,"Desc",$ZCVT(language,"U"),0))
            s language = $p($g(^SS("LAN",lanid)),"^",1) 
            
        }
        s:fielddesc'="" fielddesc=$ZCVT(fielddesc,"U")
        if ($d(^User.BDPTranslationI("TableIndex"," USER.OTHER")))
        {
            s BTRowId = 0
            for
            {
                s BTRowId = $o(^User.BDPTranslationI("TableIndex"," USER.OTHER",BTRowId))
                q:BTRowId=""
                s BTTableName = "User.OTHER"
                s BTFieldName = "OTHER"
                s languages = $lg($g(^User.BDPTranslationD(BTRowId)),4)
                s BTLanguage =""
                if (languages'="")
                {
                    s LanRowId = $o(^SS("LAN",0,"Code",$ZCVT(languages,"U"),0))
                    s:LanRowId'="" BTLanguage = $p($g(^SS("LAN",LanRowId)),"^",2)
                }
                s BTFieldDesc = $lg($g(^User.BDPTranslationD(BTRowId)),5)
                s BTTransDesc = $lg($g(^User.BDPTranslationD(BTRowId)),6)
            
                //b
                if (($ZCVT(languages,"U")=language)||(language=""))&(($ZCVT(BTFieldDesc,"U")[fielddesc))
                {

                    d OutputRow1
                }   
            }   
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow1
    set Data=$lb(BTRowId,BTLanguage,BTFieldDesc,BTTransDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
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

/// Creator:钟荣枫
/// CreatDate:2020-4-26
/// Description:查询 平台翻译 
/// Table:User.BDPTranslation 平台翻译
/// Input:rowid,tablename 表名,fieldname 字段名,language 语言,fielddesc 翻译前中文
/// Return:ID,BTTableName,BTFieldName,BTLanguages,BTFieldDesc,BTTransDesc   如 8:User.CTSpec(医生专长):CTSPCDesc:English:专长03:www:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPTranslation","GetListHISUI","","","","","")
Query GetListHISUI(rowid As %String, tablename As %String, fieldname As %String, language As %String, fielddesc As %String) As %Query(ROWSPEC = "ID,BTTableName,BTFieldName,BTLanguages,BTFieldDesc,BTTransDesc")
{
}

ClassMethod GetListHISUIExecute(ByRef qHandle As %Binary, rowid As %String, tablename As %String, fieldname As %String, language As %String, fielddesc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    
    if (rowid'="")
    {
        
        s ID=rowid
        s BTTableName=$lg($g(^User.BDPTranslationD(ID)),2)  //表名
        s TableID=""
        s:BTTableName'="" TableID=$o(^User.BDPTableListI("UqIndex"," "_$ZCONVERT(BTTableName,"U"),0))
        s TableDesc=""
        s:TableID'="" TableDesc=$LISTGET($G(^User.BDPTableListD(TableID)),3)    //表 中文名
        s BTTableName=BTTableName_"("_TableDesc_")"
        s BTFieldName=$lg($g(^User.BDPTranslationD(ID)),3)  //字段名
        s FieldID=""
        s:(BTFieldName'="")&&(TableID'="") FieldID=$o(^User.BDPTableFieldI("NameIndex"," "_$ZCONVERT(BTFieldName,"U"),TableID,0))
        s FieldDesc=""
        s:(FieldID'="")&&(TableID'="") FieldDesc=$LISTGET($G(^User.BDPTableListD(TableID,"ChildField",FieldID)),2)  //字段名描述
        s BTFieldName=BTFieldName_"("_FieldDesc_")"

        s BTLanguages=$lg($g(^User.BDPTranslationD(ID)),4)  //语言
        if (BTLanguages'="")
        {
            s LanRowId = $o(^SS("LAN",0,"Code",$$ALPHAUP^SSUTIL4(BTLanguages),0))       //转换大写方法
            s:LanRowId'="" BTLanguages = $p($g(^SS("LAN",LanRowId)),"^",2)
        }
        s BTFieldDesc=$lg($g(^User.BDPTranslationD(ID)),5)  //翻译前中文
        s BTTransDesc=$lg($g(^User.BDPTranslationD(ID)),6)  //翻译后内容
        d OutputRow
    }
    else
    {
        s:tablename'="" tablename=$ZCONVERT(tablename,"U")
        s:fieldname'="" fieldname=$ZCONVERT(fieldname,"U")
        s:fielddesc'="" fielddesc=$ZCONVERT(fielddesc,"U")
        
        s ID=0
        for
        {
            //ID,BTTableName,BTFieldName,BTLanguages,BTFieldDesc,BTTransDesc
            s ID=$o(^User.BDPTranslationD(ID)) q:ID=""
            
            s BTTableName=$lg($g(^User.BDPTranslationD(ID)),2)  //表名
            s TableID=""
            
            s:BTTableName'="" TableID=$o(^User.BDPTableListI("UqIndex"," "_$ZCONVERT(BTTableName,"U"),0))
            s TableDesc=""
            s:TableID'="" TableDesc=$LISTGET($G(^User.BDPTableListD(TableID)),3)    //表 中文名
            s BTTableName=BTTableName_"("_TableDesc_")"
            s TNPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BTTableName) 
            
            s BTFieldName=$lg($g(^User.BDPTranslationD(ID)),3)  //字段名
            s FieldID=""
            s:(BTFieldName'="")&&(TableID'="") FieldID=$o(^User.BDPTableFieldI("NameIndex"," "_$ZCONVERT(BTFieldName,"U"),TableID,0))
            s FieldDesc=""
            s:(TableID'="")&&(FieldID'="") FieldDesc=$LISTGET($G(^User.BDPTableListD(TableID,"ChildField",FieldID)),2)  //字段名描述
            s BTFieldName=BTFieldName_"("_FieldDesc_")"
            s FNPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BTFieldName)
            
            continue:'(($ZCONVERT(BTFieldName,"U")[fieldname)||(FNPYCode[fieldname))
            s BTLanguages=$lg($g(^User.BDPTranslationD(ID)),4)  //语言
            if (BTLanguages'="")    //语言不为空
            {
                continue:(language'="")&&(language'=BTLanguages)
                s LanRowId = $o(^SS("LAN",0,"Code",$$ALPHAUP^SSUTIL4(BTLanguages),0))   //根据代码获取id
                s:LanRowId'="" BTLanguages = $p($g(^SS("LAN",LanRowId)),"^",2)
            }
            
            
            s BTFieldDesc=$lg($g(^User.BDPTranslationD(ID)),5)  //翻译前中文
            continue:'($ZCONVERT(BTFieldDesc,"U")[fielddesc)
            
            s BTTransDesc=$lg($g(^User.BDPTranslationD(ID)),6)  //翻译后内容
            if (fieldname'="")           
            {
                ;需要对描述或者别名进行检索 
                s AliasFlag=0     
                s PINYINFlag=""
                s PINYINCODE=""   
                s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(fieldname) /// 是拼音 才去转换拼音码
                if (PINYINFlag=1)
                {
                  s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BTFieldName) 
                }
                if (($ZCONVERT(BTFieldName,"U")[fieldname)||(PINYINCODE[fieldname))      //过滤字段名
                {
                    s AliasFlag= 1  
                } 
            }
            else
            {
                s AliasFlag= 1
            } 
            i (($ZCONVERT(BTTableName,"U")[tablename)||(TNPYCode[tablename))&&(AliasFlag=1) //过滤表名
            {
                d OutputRow
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ID,BTTableName,BTFieldName,BTLanguages,BTFieldDesc,BTTransDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListHISUIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListHISUIExecute ]
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

ClassMethod GetListHISUIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListHISUIExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator:李欣
/// CreatDate:2017-09-13
/// Description:保存前台的插入及修改
/// Table:User.BDPTranslation
/// Input:eobj As web.Entity.BDP.BDPTranslation
/// Output:
/// Return:执行结果
/// Others:
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPTranslation) As %String
{
     n (eobj,%session)
     s result=""
     s flag = ""
     if $IsObject(eobj)
     { 
        s flag = ..Translated(eobj.ID,eobj.BTTableName,eobj.BTFieldName,eobj.BTLanguages,eobj.BTFieldDesc)
        if (flag=1)
        {
              s result = "{success:'false',errorinfo:'该属性已翻译，不允许再次添加！'}"    
              q result
        }
    
            if ((eobj.ID)="")                             
            { 
                
                s obj = ##class(User.BDPTranslation).%New()
                
            }
            else                                                  
            {
                s obj=##class(User.BDPTranslation).%OpenId(eobj.ID)
                s bobj=##class(web.Entity.BDP.BDPTranslation).%New()
                s bobj.ID = eobj.ID
                s bobj.BTTableName = obj.BTTableName                     
                s bobj.BTFieldName = obj.BTFieldName    
                s bobj.BTLanguages = obj.BTLanguages
                s bobj.BTFieldDesc = obj.BTFieldDesc
                s bobj.BTTransDesc = obj.BTTransDesc 
                                                     
            } 
            s obj.BTTableName = eobj.BTTableName                   
            s obj.BTFieldName = eobj.BTFieldName
            s obj.BTLanguages = eobj.BTLanguages
            s obj.BTFieldDesc = eobj.BTFieldDesc
            s obj.BTTransDesc = eobj.BTTransDesc
            /*****事务开启******/
            Ts
            s sc = obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Translation","User.BDPTranslation","其他数据翻译管理",id,eobj.BTFieldDesc,"A",eobj)
                d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Translation","User.BDPTranslation","其他数据翻译管理",eobj.ID,eobj.BTFieldDesc,"U",eobj,bobj)
                s result = "{success:'true',id:'"_id_"'}"          
            }
            else
            {
                Trollback
                //s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
                
                s result = "{success:'false',errorinfo:'"_$SYSTEM.Status.GetErrorText(sc)_"'}" 
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("其他数据翻译管理","web.DHCBL.BDP.BDPTranslation","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }  
        
     }
     else
     {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
     } 
     q result
}

/// Creator:李欣
/// CreatDate:2017-09-12
/// Description:SaveEntity()的测试方法
/// Table:User.BDPTranslation
/// Input:
/// Output:
/// Return:执行结果
/// Others:w ##class(web.DHCBL.BDP.BDPTranslation).SaveTest()
ClassMethod SaveTest()
{
    s tobj = ##class(web.Entity.BDP.BDPTranslation).%New()
    s tobj.ID = "447"
    //s tobj.BTTableName= "User.SSUser"
    //s tobj.BTFieldName = "SSUSRName"
    s tobj.BTLanguages = "FR"
    s tobj.BTFieldDesc = "asd"
    s tobj.BTTransDesc = "sassd"
    q ..SaveEntity(tobj)
}

/// Creator:李欣
/// CreatDate:2017-09-12
/// Description:数据校验方法  根据索引校验字段是否已翻译
/// Table:User.BDPTranslation
/// Input:tablename:String fieldname:String language:String fielddesc:String
/// Output:
/// Return:1:字段已翻译 0:字段未翻译
/// Others:
/// w ##class(web.DHCBL.BDP.BDPTranslation).Translated(461,"User.OTHER","OTHER","CH","asdzxc")
ClassMethod Translated(rowid As %String, tablename As %String, fieldname As %String, language As %String, fielddesc As %String) As %String
{
    new (rowid,tablename,fieldname,language,fielddesc)
    s:tablename'="" tablename=$ZCVT(tablename,"U")
    s:fieldname'="" fieldname=$ZCVT(fieldname,"U")
    s:language'="" language=$ZCVT(language,"U")
    //s:fielddesc'="" fielddesc=$ZCVT(fielddesc,"U")
    if (rowid="")
    {
        s flag = $o(^User.BDPTranslationI("TransIndex"," "_tablename," "_fieldname," "_language,$e(fielddesc,1,200),""))
        if (flag'=""){
            s result = 1    
        }else{
            s result = 0    
        }   
    }
    else
    {
        s BTRowId = 0
        s result = 0
        for
        {
            s BTRowId = $o(^User.BDPTranslationI("TransIndex"," "_tablename," "_fieldname," "_language,$e(fielddesc,1,200),BTRowId))
            q:BTRowId=""
            if (BTRowId'="")&(BTRowId'=rowid)
            {
                s result = 1    
            }   
        }   
    }
    q result
}

/// Creator:李欣
/// CreatDate:2017-09-13
/// Description:获取选中行数据
/// Table:User.BDPTranslation
/// Input:rowid:String
/// Output:
/// Return:结果封装为JSon格式
/// Others:w ##class(web.DHCBL.BDP.BDPTranslation).OpenDataNew(2)
ClassMethod OpenDataNew(id As %String) As %String
{
    n (id)
    s str = ""
    s pobj = ##class(User.BDPTranslation).%OpenId(id)
    s eobj = ##class(web.Entity.BDP.BDPTranslation).%New()
    s eobj.ID = id
    s eobj.BTTableName = "User.OTHER"
    s eobj.BTFieldName = "OTHER"
    /*s languages = BT.BTLanguages
    s LanRowId = $o(^SS("LAN",0,"Code",$ZCVT(languages,"U"),0))
    s eobj.BTLanguages = $p($g(^SS("LAN",LanRowId)),"^",2)*/
    s eobj.BTLanguages= pobj.BTLanguages
    s eobj.BTFieldDesc = pobj.BTFieldDesc
    s eobj.BTTransDesc = pobj.BTTransDesc
    kill pobj
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Creator：钟荣枫 
/// CreatDate: 2020-4-26
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.BDPTranslation   //平台翻译
/// Input：id
/// Return:JSON字符串
/// Other: w ##class(web.DHCBL.BDP.BDPTranslation).OpenDataHISUI(1,"")
ClassMethod OpenDataHISUI(id As %String, RetFlag As %String = "") As %String
{
    s str = ""
    s pobj = ##class(User.BDPTranslation).%OpenId(id) 
    s eobj = ##class(web.Entity.BDP.BDPTranslation).%New() 
    s eobj.ID = id
    s eobj.BTTableName = pobj.BTTableName   //表名
    s eobj.BTFieldName = pobj.BTFieldName   //字段名
    s eobj.BTLanguages = pobj.BTLanguages   //语言
    s eobj.BTFieldDesc = pobj.BTFieldDesc   //翻译前中文
    s eobj.BTTransDesc = pobj.BTTransDesc   //翻译后内容
    
    d pobj.%Close()
    kill pobj
    s str = eobj.JsonS()
    if (RetFlag'="JSON")    //RetFlag=""时，用于EXT, =JSON时，用于HISUI，不输出 "{list:["_str_"]}"
    {
        s str = "{list:["_str_"]}"
    }
    q str
}

/// Creator:李欣
/// CreatDate:2017-09-13
/// Description:通过rowid进行删除
/// Table:User.BDPTranslation
/// Input:rowid:String
/// Output:
/// Return:删除操作的结果
/// Others:w ##class(web.DHCBL.BDP.BDPTranslation).DeleteData(4)
ClassMethod DeleteData(id As %String) As %String
{
    new (id,%session)
    s result = ""   
    s eobj = ##class(web.Entity.BDP.BDPTranslation).%New()
    s obj = ##class(User.BDPTranslation).%OpenId(id)
    s eobj.ID = id
    s eobj.BTTableName = obj.BTTableName
    s eobj.BTFieldName = obj.BTFieldName
    s eobj.BTLanguages = obj.BTLanguages
    s eobj.BTFieldDesc = obj.BTFieldDesc 
    s eobj.BTTransDesc = obj.BTTransDesc
    
    TS  /*******事务开启********/
    s rtn = ##class(User.BDPTranslation).%DeleteId(id)  /******删除操作********/
    if (rtn=1)  /*******删除操作成功********/
    {
        /******事务提交******/
        TC  
        s result = "{success:'true',id:'"_id_"'}"
        
        /********日志记录********/
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Translation","User.BDPTranslation","其他数据翻译管理",id,eobj.BTFieldDesc,"D",eobj)
        //d eobj.%Close()
    }
    else
    {
        /*****事务回滚******/
        TRO
        s result = "{success:'false',info:'"_$SYSTEM.Status.GetErrorText(rtn)_"'}"
        
        /*******错误日志记录********/
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("翻译","web.DHCBL.BDP.BDPTranslation","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }   

    
    Q result
}

/// Creator:谷雪萍
/// CreatDate:2017-09-14
/// Description:获取导出的数量
/// Input:tablename 表名, fieldname 字段名, language 语言, fielddesc 翻以前内容
/// Output:  需要导出的数据数目
/// w ##class(web.DHCBL.BDP.BDPTranslation).GetTransCount("user.ssuser","","EN","")
ClassMethod GetTransCount(language As %String, fielddesc As %String) As %String
{
    k ^TMP("ExportTransData")
    s count=0
    //s:tablename'="" tablename=$ZCVT(tablename,"U")  
    //s:fieldname'="" fieldname=$ZCVT(fieldname,"U")
    s:language'="" language=$ZCVT(language,"U")
    s:fielddesc'="" fielddesc=$ZCVT(fielddesc,"U")
    if ($d(^User.BDPTranslationI("TableIndex"," USER.OTHER")))
    {
        s BTRowId = 0
        for
        {
            s BTRowId = $o(^User.BDPTranslationI("TableIndex"," USER.OTHER",BTRowId))
            q:BTRowId=""
            s languages = $LISTGET($G(^User.BDPTranslationD(BTRowId)),4)
            s BTFieldDesc = $LISTGET($G(^User.BDPTranslationD(BTRowId)),5)
              
            if (($ZCVT(languages,"U")=language)||(language=""))&(($ZCVT(BTFieldDesc,"U")[fielddesc))
            {
                s count=count+1
                s ^TMP("ExportTransData",count)=BTRowId         
                
            }
            
        }
    }
    q count
}

/// Creator:谷雪萍
/// CreatDate:2017-09-14
/// Description:获取导出的信息
/// Input:i :第几条
/// Output:  需要导出的数据信息
/// w ##class(web.DHCBL.BDP.BDPTranslation).GetTransDataInfo()
ClassMethod GetTransDataInfo(i As %String) As %String
{
    s str=""
    S BTRowId=$g(^TMP("ExportTransData",i))
    q:(BTRowId="") ""
    
    s BTTableName = $LISTGET($G(^User.BDPTranslationD(BTRowId)),2)
    s BTFieldName = $LISTGET($G(^User.BDPTranslationD(BTRowId)),3)
    //s BTLanguage = $lg(^User.BDPTranslationD(BTRowId),4)
    s languages = $LISTGET($G(^User.BDPTranslationD(BTRowId)),4)
    s LanRowId = $o(^SS("LAN",0,"Code",$ZCVT(languages,"U"),0))
    s BTLanguage =""
    if (languages'="")
    {
        s LanRowId = $o(^SS("LAN",0,"Code",$ZCVT(languages,"U"),0))
        s:LanRowId'="" BTLanguage = $p($g(^SS("LAN",LanRowId)),"^",2)
    }
    s BTFieldDesc = $LISTGET($G(^User.BDPTranslationD(BTRowId)),5)
    s BTTransDesc = $LISTGET($G(^User.BDPTranslationD(BTRowId)),6)
                
                
    s str=BTTableName_"&%"_BTFieldName_"&%"_BTLanguage_"&%"_BTFieldDesc_"&%"_BTTransDesc
    q str
}

/// Creator:谷雪萍
/// CreatDate:2018-01-27
/// Description:删除某个表的翻译数据
/// Table:User.BDPTranslation
/// Input:rowid:String
/// Output:
/// Return:删除操作的结果
/// Others:w ##class(web.DHCBL.BDP.BDPTranslation).DeleteTableData("User.ARCItmMast")
/// 重新生成索引: k ^User.BDPTranslationI w ##class(User.BDPTranslation).%BuildIndices()
ClassMethod DeleteTableData(tableName As %String) As %String
{
    s result="",flag=""
    s:tableName'="" tableName=" "_$ZCVT(tableName,"U")
    
    TS
    if ($d(^User.BDPTranslationI("TableIndex",tableName)))
    {
        s BTRowId = 0
        for
        {
            s BTRowId = $o(^User.BDPTranslationI("TableIndex",tableName,BTRowId))
            q:BTRowId=""
            s result=..DeleteData(BTRowId)
            if (result["false"){
                s flag=1
                q 
            }   
        }   
    }
    if (flag="")    /*******删除操作成功********/
    {
        /******事务提交******/
        TC  
        s result = "{success:'true',info:'删除成功'}"
    }
    else
    {
        /*****事务回滚******/
        TRO
        s result = "{success:'false',info:'删除失败'}"
    }   

    Q result
}

/// Creator:chenying
/// CreatDate:2021-12-21
/// Description:查询 平台翻译 (用于第二版hisui界面- 右侧查询）
/// Table:User.BDPTranslation 平台翻译
/// Input:rowid,tablename 表名,fieldname 字段名,language 语言,fielddesc 翻译前中文
/// Return:ID,BTTableName,BTFieldName,BTLanguages,BTFieldDesc,BTTransDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPTranslation","GetListHISUI","","","","","")
Query GetListHISUI2(rowid As %String, tablename As %String, fieldname As %String, language As %String, fielddesc As %String) As %Query(ROWSPEC = "ID,BTTableName,BTFieldName,BTLanguages,BTFieldDesc,BTTransDesc")
{
}

ClassMethod GetListHISUI2Execute(ByRef qHandle As %Binary, rowid As %String, tablename As %String, fieldname As %String, language As %String, fielddesc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    
    if (rowid'="")
    {
        
        s ID=rowid
        s BTTableName=$lg($g(^User.BDPTranslationD(ID)),2)  //表名
        s TableID=""
        s:BTTableName'="" TableID=$o(^User.BDPTableListI("UqIndex"," "_$ZCONVERT(BTTableName,"U"),0))
        s TableDesc=""
        s:TableID'="" TableDesc=$LISTGET($G(^User.BDPTableListD(TableID)),3)    //表 中文名
        s BTTableName=BTTableName_"("_TableDesc_")"
        s BTFieldName=$lg($g(^User.BDPTranslationD(ID)),3)  //字段名
        s FieldID=""
        s:(BTFieldName'="")&&(TableID'="") FieldID=$o(^User.BDPTableFieldI("NameIndex"," "_$ZCONVERT(BTFieldName,"U"),TableID,0))
        s FieldDesc=""
        s:(FieldID'="")&&(TableID'="") FieldDesc=$LISTGET($G(^User.BDPTableListD(TableID,"ChildField",FieldID)),2)  //字段名描述
        s BTFieldName=BTFieldName_"("_FieldDesc_")"

        s BTLanguages=$lg($g(^User.BDPTranslationD(ID)),4)  //语言
        if (BTLanguages'="")
        {
            s LanRowId = $o(^SS("LAN",0,"Code",$$ALPHAUP^SSUTIL4(BTLanguages),0))       //转换大写方法
            s:LanRowId'="" BTLanguages = $p($g(^SS("LAN",LanRowId)),"^",2)
        }
        s BTFieldDesc=$lg($g(^User.BDPTranslationD(ID)),5)  //翻译前中文
        s BTTransDesc=$lg($g(^User.BDPTranslationD(ID)),6)  //翻译后内容
        d OutputRow2
    }
    else
    {
        s:tablename'="" tablename=$ZCONVERT(tablename,"U")
        s:fieldname'="" fieldname=$ZCONVERT(fieldname,"U")
        s:fielddesc'="" fielddesc=$ZCONVERT(fielddesc,"U")
        
        s ID=0
        for
        {
            s ID=$o(^User.BDPTranslationD(ID)) q:ID=""
            
            s BTTableName=$lg($g(^User.BDPTranslationD(ID)),2)  //表名
            s TableID=""
            
            s:BTTableName'="" TableID=$o(^User.BDPTableListI("UqIndex"," "_$ZCONVERT(BTTableName,"U"),0))
            s TableDesc=""
            s:TableID'="" TableDesc=$LISTGET($G(^User.BDPTableListD(TableID)),3)    //表 中文名
             
            s BTFieldName=$lg($g(^User.BDPTranslationD(ID)),3)  //字段名
            s FieldID=""
            s:(BTFieldName'="")&&(TableID'="") FieldID=$o(^User.BDPTableFieldI("NameIndex"," "_$ZCONVERT(BTFieldName,"U"),TableID,0))
            s FieldDesc=""
            s:(TableID'="")&&(FieldID'="") FieldDesc=$LISTGET($G(^User.BDPTableListD(TableID,"ChildField",FieldID)),2)  //字段名描述
            s BTFieldName=BTFieldName_"("_FieldDesc_")"
            s FNPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BTFieldName)
            
            continue:'(($ZCONVERT(BTFieldName,"U")[fieldname)||(FNPYCode[fieldname))
            s BTLanguages=$lg($g(^User.BDPTranslationD(ID)),4)  //语言
            if (BTLanguages'="")    //语言不为空
            {
                continue:(language'="")&&(language'=BTLanguages)
                s LanRowId = $o(^SS("LAN",0,"Code",$$ALPHAUP^SSUTIL4(BTLanguages),0))   //根据代码获取id
                s:LanRowId'="" BTLanguages = $p($g(^SS("LAN",LanRowId)),"^",2)
            }
            
            
            s BTFieldDesc=$lg($g(^User.BDPTranslationD(ID)),5)  //翻译前中文
            continue:'($ZCONVERT(BTFieldDesc,"U")[fielddesc)
            
            s BTTransDesc=$lg($g(^User.BDPTranslationD(ID)),6)  //翻译后内容
            if (fieldname'="")           
            {
                ;需要对描述或者别名进行检索 
                s AliasFlag=0     
                s PINYINFlag=""
                s PINYINCODE=""   
                s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(fieldname) /// 是拼音 才去转换拼音码
                if (PINYINFlag=1)
                {
                  s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BTFieldName) 
                }
                if (($ZCONVERT(BTFieldName,"U")[fieldname)||(PINYINCODE[fieldname))      //过滤字段名
                {
                    s AliasFlag= 1  
                } 
            }
            else
            {
                s AliasFlag= 1
            } 
            continue:(AliasFlag'=1)
            if (tablename'="")
            {
	            s BTTableNameU=$ZCONVERT(BTTableName,"U")
	            if tablename'[(BTTableNameU_"^") continue
            }
            d OutputRow2
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow2
    set Data=$lb(ID,BTTableName,BTFieldName,BTLanguages,BTFieldDesc,BTTransDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListHISUI2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListHISUI2Execute ]
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

ClassMethod GetListHISUI2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListHISUI2Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Description：获取要翻译的列条数
/// Table：User.BDPTranslation
/// Input：id
/// Other: w ##class(web.DHCBL.BDP.BDPTranslation).GetTransNum("CT_Loc")
ClassMethod GetTransNum(TableName As %String) As %String
{
    
    s num=0
    s ParRef=$o(^User.BDPTableListI("NameIndex"," "_$zcvt(TableName,"U"),0)) //直接取表结构登记里得数据
    if (ParRef'="")
  	{
	  	s ID=0
	 	for 
	 	{
		 	s ID=$o(^User.BDPTableListD(ParRef,"ChildField",ID)) q:ID=""
		 	s FieldRowId=ParRef_"||"_ID
		 	s FieldParRef=ParRef
	 		s FieldType=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),5)
	 		s FieldTranslation=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),6)
	 		continue:(FieldTranslation'="Y")||(FieldType'="String")
	 		s num=num+1
	 	}
  	}
  	q num
}

}
