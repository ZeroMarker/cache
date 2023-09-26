Class web.DHCBL.KB.DHCPHExtGeneric Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：查询通用名字典表内容
/// Table：User.DHCPHExtGeneric
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtGeneric","GetList","","","","","")
Query GetList(rowid, code, desc, lib, cat) As %Query(ROWSPEC = "PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLICode,PHLIDesc,PHEGSysFlag,PHEGDataPool,PHICStr,PHEINGStr")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc, lib, cat) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHEGRowId=rowid
        s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
        s PHEGCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGCode)
        s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
        s PHEGDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGDesc)
        s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
        s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
        s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
        s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
        s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
        s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
        s:PHEGSysFlag'="N" PHEGSysFlag="Y"
        s PHEGDataPool=$p($g(^DHCPHEGEN(PHEGRowId)),"^",9)  //数据池标识
        
        s PHICStr=""
        s PHEINGStr=""
        if (PHLICode="DRUG"){
            ;药品分类
            s PHGPRRowId=0
            for  
            {   
                s PHGPRRowId=$o(^DHCPHDGP(PHGPRRowId)) q:PHGPRRowId="" 
                s PHGPRGenDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",1)  //通用名Dr
                s PHGPRCatDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",4)  //分类标识DR
                s:PHGPRCatDr'="" PHICDesc=$LISTGET($G(^User.DHCPHLibCatD(PHGPRCatDr)),3) //分类标识名称
                s:PHGPRCatDr="" PHICDesc="" //分类标识名称
                if (PHGPRGenDr=PHEGRowId){
                    if (PHICStr=""){
                        s PHICStr = PHICDesc
                    }else{
                        s PHICStr = PHICStr_","_PHICDesc
                    }
                }
            }
            ;成分分类
            s PHEGIRowId=0
            for  
            {   
                s PHEGIRowId=$o(^DHCPHEGENIN(PHEGIRowId)) q:PHEGIRowId="" 
                s PHEGIPHEGDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",1)  //通用名Dr
                s PHEGIIngrDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",2)  //成分DR
                s:PHEGIIngrDr'="" PHEINGDesc=$LISTGET($G(^User.DHCPHExtIngrD(PHEGIIngrDr)),3)  //成分名称
                s:PHEGIIngrDr="" PHEINGDesc=""  //成分名称
                if (PHEGIPHEGDr=PHEGRowId){
                    if (PHEINGStr=""){
                        s PHEINGStr = PHEINGDesc
                    }else{
                        s PHEINGStr = PHEINGStr_","_PHEINGDesc
                    }
                }
            }
        }
                
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s:lib'="" lib=$ZCONVERT(lib,"U")
        s PHEGRowId=0
        for  
        {   
            s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId="" 
            s strRowId = "{ID:"_PHEGRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
                s PHEGCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGCode)
                s PHEGCodeU=$ZCONVERT(PHEGCode,"U")
                s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
                s PHEGDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGDesc)
                s PHEGDescU=$ZCONVERT(PHEGDesc,"U")
                s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
                s:PHEGActiveFlag'="N" PHEGActiveFlag="Y"
                s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
                s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
                s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
                s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
                s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
                s:PHEGSysFlag'="N" PHEGSysFlag="Y"
                s PHEGDataPool=$p($g(^DHCPHEGEN(PHEGRowId)),"^",9)  //数据池标识
                 //通用名药品属性
				s:cat'="" PHEGRowId1="<"_PHEGRowId_">"
				s:cat="" PHEGRowId1=""
				s PHGPRStr=""
				
                s PHICStr=""
                s PHEINGStr=""
                if (PHLICode="DRUG"){
                    ;药品分类
                    s PHGPRRowId=0
                    for  
                    {   
                        s PHGPRRowId=$o(^DHCPHDGPi(0,"Gen",PHEGRowId,PHGPRRowId)) q:PHGPRRowId="" 
                        s PHGPRGenDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",1)  //通用名Dr
                        s PHGPRCatDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",4)  //分类标识DR
                        s:PHGPRCatDr'="" PHICDesc=$LISTGET($G(^User.DHCPHLibCatD(PHGPRCatDr)),3) //分类标识名称
                        s:PHGPRCatDr="" PHICDesc="" //分类标识名称
                        //if (PHGPRGenDr=PHEGRowId){
                            if (PHICStr=""){
                                s PHICStr = PHICDesc
                            }else{
                                s PHICStr = PHICStr_","_PHICDesc
                            }
                        if (PHGPRCatDr=cat){
							s PHGPRStr=PHGPRStr_"^<"_PHGPRGenDr_">"
						}
                        //}
                    }
                    ;成分分类
                    s PHEGIRowId=0
                    for  
                    {   
                        s PHEGIRowId=$o(^DHCPHEGENINi(0,"GEN",PHEGRowId,PHEGIRowId)) q:PHEGIRowId="" 
                        s PHEGIPHEGDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",1)  //通用名Dr
                        s PHEGIIngrDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",2)  //成分DR
                        s:PHEGIIngrDr'="" PHEINGDesc=$LISTGET($G(^User.DHCPHExtIngrD(PHEGIIngrDr)),3)  //成分名称
                        s:PHEGIIngrDr="" PHEINGDesc=""  //成分名称
                        //if (PHEGIPHEGDr=PHEGRowId){
                            if (PHEINGStr=""){
                                s PHEINGStr = PHEINGDesc
                            }else{
                                s PHEINGStr = PHEINGStr_","_PHEINGDesc
                            }
                        //}
                    }
                }
               
				
				
                //别名查询
                s ALIASText1=""
                s ALIASText=""
                for{
                    s ALIASText=$o(^DHCPHEGALi(0,"GenText",PHEGRowId,ALIASText))
                    q:ALIASText=""
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                }
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGDescU))
                i (PHEGCodeU[code)&((PHEGDescU[desc)||(ALIASText1[desc)||(PINYIN[desc))&((PHEGLibDrU=lib)||(lib=""))&(PHGPRStr[PHEGRowId1)   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLICode,PHLIDesc,PHEGSysFlag,PHEGDataPool,PHICStr,PHEINGStr)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
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

/// Creator:高姗姗
/// CreatDate:2014-11-7
/// Description:查询 通用名标识 
/// Input:desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtGeneric","GetDataForCmb1","","CHECK","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHEGRowId:%String,PHEGDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s PHEGRowId=rowid
        s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)
        s PHEGDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGDesc)
        s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
        d:PHEGActiveFlag'="N" OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        //if code="CHECK" s code="ELECT ULTR RADI ENDO"
        
        s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s PHEGRowId=0
        for
        {
            s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId=""
            
            s strRowId="{ID:"_PHEGRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
                continue:PHEGActiveFlag="N"
                s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)
                s PHEGDesc1=$ZCONVERT(PHEGDesc,"U")
                s PHEGDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGDesc)
                s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7) 
                s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) 
                s PHLICode1=$ZCONVERT(PHLICode,"U")
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGDesc1))
               
                if (code="CHECK")
                {
	                 
	                s code1="ELECT ULTR RADI ENDO CHECK"
	                i (code1[PHLICode1)&((PHEGDesc1[desc)||(PINYIN[desc))
	                {
	                    d OutputRowCmb
	                }
	                
	            }
	            elseif(((code'="")&(code'="CHECK")&(code=PHLICode1))||(code=""))&((PHEGDesc1[desc)||(PINYIN[desc))
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PHEGRowId,PHEGDesc)
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

/// Creator：陈莹
/// CreatDate: 2017-04-19
/// Description：根据知识库标志代码查询通用名字典表内容（推导目录明细表里调用）
/// Table：User.DHCPHExtGeneric
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtGeneric","GetDataForCmb2","","","","","")
Query GetDataForCmb2(rowid, code, desc, lib, libcode) As %Query(ROWSPEC = "PHEGRowId,PHEGCode,PHEGDesc")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, rowid, code, desc, lib, libcode) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHEGRowId=rowid
        s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
      
        s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
        s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
        s PHEGDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGDesc)
        s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
        s PHLICode="",PHLIDesc=""
        s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
        s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称  
        d:PHEGActiveFlag'="N" OutputRowCmb2
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        /*s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        */
        s:libcode'="" libcode=$ZCONVERT(libcode,"U")
        s PHEGRowId=0
        for  
        {   
            s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId="" 
            /*s strRowId="{ID:"_PHEGRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
	            */
	            s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
	            continue:PHEGActiveFlag="N"
	            s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
	            s PHEGCodeU=$ZCONVERT(PHEGCode,"U")
	            s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
	            s PHEGDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGDesc)
	            s PHEGDescU=$ZCONVERT(PHEGDesc,"U")
	            s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
	            s PHLICode="",PHLIDesc=""
	            s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
	            s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
	            s:PHLICode'="" PHLICode=$ZCONVERT(PHLICode,"U") 
	            //别名查询
	            s ALIASText1=""
	            if desc'=""
	            {
	                s ALIASText=""
	                for{
	                    s ALIASText=$o(^DHCPHEGALi(0,"GenText",PHEGRowId,ALIASText))
	                    q:ALIASText=""
	                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
	                }
	            }
	            s PINYIN=""
	            s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHEGDescU)
	            i (PHEGCodeU[code)&((PHEGDescU[desc)||(ALIASText1[desc)||(PINYIN[desc))&((libcode="")||(PHLICode=libcode))&((lib="")||(PHEGLibDr=lib))
	            {
	                d OutputRowCmb2
	            }       
            //}  
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb2
    set Data=$lb(PHEGRowId,PHEGCode,PHEGDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
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

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:修改对照表限制
/// Return:1-被引用不可修改,0-未被引用可修改
/// w ##class(web.DHCBL.KB.DHCPHExtGeneric).GetModifyFlag("60")
ClassMethod GetModifyFlag(id As %String) As %String
{
    s return="",myInfo=""
    
    s flag=0
    s PHEGCode=$p($g(^DHCPHEGEN(id)),"^",1) 
    s LibDr=$p($g(^DHCPHEGEN(id)),"^",7)  //知识库标识DR
    s:LibDr'="" PHLICode=$p($g(^DHCPHLIBL(LibDr)),"^",1) //知识库标识代码
    s PHLICodeU=$ZCONVERT(PHLICode,"U")
    s GICTRowId=0
    for  
    {   
        s GICTRowId=$o(^DHCPHGENCON(GICTRowId)) q:GICTRowId=""||(flag=1)  d 
        s GICTCode=$p($g(^DHCPHGENCON(GICTRowId)),"^",1)  //his代码
        i (GICTCode=PHEGCode){
            s flag=1
            if (PHLICodeU="DRUG"){
                s myInfo=myInfo_"<药品通用名与his项目对照表>"  
            }
            if (PHLICodeU="LAB"){
                s myInfo=myInfo_"<检验通用名与his项目对照表>"  
            }
            if (PHLICodeU="SPEC"){
                s myInfo=myInfo_"<检验通用名与his项目对照表>"  
            }
            if ((PHLICodeU="CHECK")||(PHLICodeU="ULTR")||(PHLICodeU="RADI")||(PHLICodeU="ENDO")){
                s myInfo=myInfo_"<检查通用名与his项目对照表>"  
            }
            if (PHLICodeU="ELECT"){
                s myInfo=myInfo_"<心电项目与his项目对照表>"   
            }
            if (PHLICodeU="TREAT"){
                s myInfo=myInfo_"<治疗项目与his项目对照表>"   
            }
        }   
    }

    i myInfo="" s return="0^未被引用可修改!"
    else  s return="1^在"_myInfo_"表里被引用,不能修改!"
    q return
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:校验知识库标识限制
/// Return:1-被引用不可修改,0-未被引用可修改
/// w ##class(web.DHCBL.KB.DHCPHExtGeneric).ValidateLib("60")
ClassMethod ValidateLib(id As %String) As %String
{
    s flag=0
    
    s PHEGAlRowId=0
    for
    {
        s PHEGAlRowId=$o(^DHCPHEGAL(PHEGAlRowId)) q:(PHEGAlRowId="")||(flag=1)  d
        s PHEGAlGenDr=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",1)
        i PHEGAlGenDr=id
        {
            s flag=1
        }
    }
    s PHGPRRowId=0
    for
    {
        s PHGPRRowId=$o(^DHCPHDGP(PHGPRRowId)) q:(PHGPRRowId="")||(flag=1)  d
        s PHGPRGenDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",1)
        i PHGPRGenDr=id
        {
            s flag=1
        }
    }
    s LGPRowId=0
    for
    {
        s LGPRowId=$o(^DHCLISGP(LGPRowId)) q:(LGPRowId="")||(flag=1)  d
        s LGPGenDr=$p($g(^DHCLISGP(LGPRowId)),"^",1)
        i LGPGenDr=id
        {
            s flag=1
        }
    }
    s GlPRowId=0
    for
    {
        s GlPRowId=$o(^DHCGENLINP(GlPRowId)) q:(GlPRowId="")||(flag=1)  d
        s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)
        i GlPGenDr=id
        {
            s flag=1
        }
    }   
    s PHEGIRowId=0
    for
    {
        s PHEGIRowId=$o(^DHCPHEGENIN(PHEGIRowId)) q:(PHEGIRowId="")||(flag=1)  d
        s PHEGIPHEGDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",1)
        i PHEGIPHEGDr=id
        {
            s flag=1
        }
    }

    s PHEGCode=$p($g(^DHCPHEGEN(id)),"^",1) 
    s GICTRowId=0
    for  
    {   
        s GICTRowId=$o(^DHCPHGENCON(GICTRowId)) q:GICTRowId=""||(flag=1)  d 
        s GICTCode=$p($g(^DHCPHGENCON(GICTRowId)),"^",1)  //his代码
        i (GICTCode=PHEGCode){
            s flag=1
        }   
    }
    q flag
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2014-10-30    
/// w ##class(web.DHCBL.KB.DHCPHExtGeneric).FormValidate("123","利福平","利福平")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHEGENi(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHEGENi(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHEGENi(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHEGENi(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：保存修改内容
/// Table：User.DHCPHExtGeneric
/// Input：web.Entity.KB.DHCPHExtGeneric 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHExtGeneric) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        
        
        s flag=..FormValidate(eobj.PHEGRowId,eobj.PHEGCode,eobj.PHEGDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.PHEGRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHExtGeneric).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHExtGeneric).%OpenId(eobj.PHEGRowId)
                
                s re=##class(web.DHCBL.KB.DHCPHExtGeneric).GetModifyFlag(eobj.PHEGRowId)
                s RefFlag=$p(re,"^",1)
                if (RefFlag'=0){
                    s result= "{success:'false',errorinfo:'"_$p(re,"^",2)_"'}"
                    q result
                }
                s bobj = ##class(web.Entity.KB.DHCPHExtGeneric).%New()
                s bobj.PHEGRowId = eobj.PHEGRowId
                s bobj.PHEGCode = obj.PHEGCode
                s bobj.PHEGDesc = obj.PHEGDesc
                s:obj.PHEGLibDr'="" bobj.PHEGLibDr = obj.PHEGLibDr.%Id()
                s bobj.PHEGActiveFlag=  obj.PHEGActiveFlag
                s bobj.PHEGSysFlag = obj.PHEGSysFlag
            }
    
            s obj.PHEGCode = eobj.PHEGCode
            s obj.PHEGDesc = eobj.PHEGDesc
            d:eobj.PHEGLibDr'="" obj.PHEGLibDrSetObjectId(eobj.PHEGLibDr)
            d:eobj.PHEGLibDr="" obj.PHEGLibDrSetObjectId("")     
            i eobj.PHEGActiveFlag="Y"
            {
                s obj.PHEGActiveFlag = "Y"
            }
            else
            {
                s obj.PHEGActiveFlag = "N"
            }
            i eobj.PHEGSysFlag="Y"
            {
                s obj.PHEGSysFlag = "Y"
            }
            else
            {
                s obj.PHEGSysFlag = "N"
            }
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.PHEGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtGeneric","User.DHCPHExtGeneric","通用名字典",id,eobj.PHEGDesc,"A",eobj)
                d:eobj.PHEGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtGeneric","User.DHCPHExtGeneric","通用名字典",eobj.PHEGRowId,eobj.PHEGDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名字典","web.DHCBL.KB.DHCPHExtGeneric","SaveData",eobj)
                s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")   
            }
        }   
    }   

    else
    {
        s result = "{success:'false',errorinfo:'对象不存在'}"
    }
    
    q result
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：获取修改时的记录
/// Table：User.DHCPHExtGeneric
/// Other: d ##class(web.DHCBL.KB.DHCPHExtGeneric).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHExtGeneric).%New()
    s pobj = ##class(User.DHCPHExtGeneric).%OpenId(id)
    s eobj.PHEGRowId = id
    s eobj.PHEGCode = pobj.PHEGCode
    s eobj.PHEGDesc = pobj.PHEGDesc
    s:pobj.PHEGLibDr'="" eobj.PHEGLibDr = pobj.PHEGLibDr.%Id()
    s:pobj.PHEGActiveFlag="Y" eobj.PHEGActiveFlag="true"
    s:pobj.PHEGSysFlag="Y" eobj.PHEGSysFlag="true"  

    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Creator：丁亚男
/// CreatDate: 2018-7-18
/// Description：获取修改时的记录
/// Table：User.DHCPHExtGeneric
/// Other: d ##class(web.DHCBL.KB.DHCPHExtGeneric).OpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHExtGeneric).%New()
    s pobj = ##class(User.DHCPHExtGeneric).%OpenId(id)
    s eobj.PHEGRowId = id
    s eobj.PHEGCode = pobj.PHEGCode
    s eobj.PHEGDesc = pobj.PHEGDesc
    s:pobj.PHEGLibDr'="" eobj.PHEGLibDr = pobj.PHEGLibDr.%Id()
    s eobj.PHEGActiveFlag=pobj.PHEGActiveFlag
    s eobj.PHEGSysFlag=pobj.PHEGSysFlag
    
    s:pobj.PHEGActiveFlag'="N" eobj.PHEGActiveFlag="Y"
    s:pobj.PHEGSysFlag'="N" eobj.PHEGSysFlag="Y" 

    s str = eobj.JsonS()
    d eobj.%Close()    
    //s str = "{data:["_str_"]}"
    q str
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHExtGeneric).GetRefFlag("124")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
    s PHEGAlRowId=0,flag=0
    for
    {
        s PHEGAlRowId=$o(^DHCPHEGAL(PHEGAlRowId)) q:(PHEGAlRowId="")||(flag=1)  d
        s PHEGAlGenDr=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",1)
        i PHEGAlGenDr=id
        {
            s flag=1
            s myInfo=myInfo_"<通用名别名字典>"
        }
    }
    s PHGPRRowId=0,flag=0
    for
    {
        s PHGPRRowId=$o(^DHCPHDGP(PHGPRRowId)) q:(PHGPRRowId="")||(flag=1)  d
        s PHGPRGenDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",1)
        i PHGPRGenDr=id
        {
            s flag=1
            s myInfo=myInfo_"<通用名药品属性表>"
        }
    }
    s LGPRowId=0,flag=0
    for
    {
        s LGPRowId=$o(^DHCLISGP(LGPRowId)) q:(LGPRowId="")||(flag=1)  d
        s LGPGenDr=$p($g(^DHCLISGP(LGPRowId)),"^",1)
        i LGPGenDr=id
        {
            s flag=1
            s myInfo=myInfo_"<通用名检验属性表>"
        }
    }
    s GlPRowId=0,flag=0
    for
    {
        s GlPRowId=$o(^DHCGENLINP(GlPRowId)) q:(GlPRowId="")||(flag=1)  d
        s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)
        s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)
                
        s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
        s PHLICode=""
        s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识
        s PHLICode1=$ZCONVERT(PHLICode,"U")
        
        i GlPGenDr=id
        {
            s flag=1
            if (PHLICode1="DRUG"){
                s myInfo=myInfo_"<药品通用名和剂型关联表>"
            }
            elseif (PHLICode1="LAB"){
                s myInfo=myInfo_"<检验通用名和标本关联表>"
            }
            elseif (PHLICode1="CHECK"){
                s myInfo=myInfo_"<检查项目通用名和部位关联表>"
            }
            elseif (PHLICode1="SPEC"){
                s myInfo=myInfo_"<心电项目通用名和部位关联表>"
            }
            elseif (PHLICode1="ULTR"){
                s myInfo=myInfo_"<超声项目通用名和部位关联表>"
            }
            elseif (PHLICode1="RADI"){
                s myInfo=myInfo_"<放射项目通用名和部位关联表>"
            }
            elseif (PHLICode1="ENDO"){
                s myInfo=myInfo_"<内镜项目通用名和部位关联表>"
            }
            elseif (PHLICode1="OPERATION"){
                s myInfo=myInfo_"<手术项目通用名和部位关联表>"
            }elseif (PHLICode1="TREAT"){
                s myInfo=myInfo_"<治疗项目通用名和部位关联表>"
            }
        }
        i (GlPPointer=id)&(PHLICode1="LAB")
        {
            s flag=1
            s myInfo=myInfo_"<检验通用名和标本关联表>"
        }
    }
    
    i $d(^DHCLSCCARE(0,"Gen",id)){
        s myInfo=myInfo_"<通用名标本采集注意事项>"
    }
    
    s PHEGIRowId=0,flag=0
    for
    {
        s PHEGIRowId=$o(^DHCPHEGENIN(PHEGIRowId)) q:(PHEGIRowId="")||(flag=1)  d
        s PHEGIPHEGDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",1)
        i PHEGIPHEGDr=id
        {
            s flag=1
            s myInfo=myInfo_"<药品通用名成分明细表>"
        }
    }
        
    i $d(^DHCLABIF(0,"VAL",id)){
        s myInfo=myInfo_"<检验项目与指标关联表>"
    }
    

    i $d(^DHCLABIF(0,"RESULT",id)){
        s myInfo=myInfo_"<检验项目与结果关联表>"
    }
    
    i $d(^DHCPHPNA(0,"Gen",id)){
        s myInfo=myInfo_"<药品商品名字典>"
    }
    
    s flag=0
    s PHEGCode=$p($g(^DHCPHEGEN(id)),"^",1) 
    s LibDr=$p($g(^DHCPHEGEN(id)),"^",7)  //知识库标识DR
    s:LibDr'="" PHLICode=$p($g(^DHCPHLIBL(LibDr)),"^",1) //知识库标识代码
    s PHLICodeU=$ZCONVERT(PHLICode,"U")
    s GICTRowId=0
    for  
    {   
        s GICTRowId=$o(^DHCPHGENCON(GICTRowId)) q:GICTRowId=""||(flag=1)  d 
        s GICTCode=$p($g(^DHCPHGENCON(GICTRowId)),"^",1)  //his代码
        i (GICTCode=PHEGCode){
            s flag=1
            if (PHLICodeU="DRUG"){
                s myInfo=myInfo_"<药品通用名与his项目对照表>"  
            }
            if (PHLICodeU="LAB"){
                s myInfo=myInfo_"<检验通用名与his项目对照表>"  
            }
            if (PHLICodeU="SPEC"){
                s myInfo=myInfo_"<检验通用名与his项目对照表>"  
            }
            if ((PHLICodeU="CHECK")||(PHLICodeU="ULTR")||(PHLICodeU="RADI")||(PHLICodeU="ENDO")){
                s myInfo=myInfo_"<检查通用名与his项目对照表>"  
            }
            if (PHLICodeU="ELECT"){
                s myInfo=myInfo_"<心电项目与his项目对照表>"   
            }
            if (PHLICodeU="TREAT"){
                s myInfo=myInfo_"<治疗项目与his对照表>"   
            }
        }   
    }
    s PHOCTRowId=0,flag=0
    s PHEGCode=$p($g(^DHCPHEGEN(id)),"^",1) 
    for  
    {   
        s PHOCTRowId=$o(^DHCPHOPCON(PHOCTRowId)) q:(PHOCTRowId="")||(flag=1)  d 
        s PHOCTOperCode=$p($g(^DHCPHOPCON(PHOCTRowId)),"^",1) 
        if (PHOCTOperCode=PHEGCode) {
            s flag=1
            s myInfo=myInfo_"<手术对照表>"   
        }
    }
    s LABIRowId=0,flag=0
    for
    {
        s LABIRowId=$o(^DHCLIBLABI(LABIRowId)) q:(LABIRowId="")||(flag=1)  d
        s LABILabDr=$p($g(^DHCLIBLABI(LABIRowId)),"^",2)
        i LABILabDr=id
        {
            s flag=1
            s myInfo=myInfo_"<检验指标业务表>"
        }
    }
    
    s PDINTRowId=0,flag=0
    for
    {
        s PDINTRowId=$o(^DHCPHDINTER(PDINTRowId)) q:(PDINTRowId="")||(flag=1)  d
        s PDINTGenDr=$p($g(^DHCPHDINTER(PDINTRowId)),"^",2)
        i PDINTGenDr=id
        {
            s flag=1
            s myInfo=myInfo_"<相互作用业务表>"
        }
    }
    
    ;User.DHCPHRepeatItm
    s PHRIRowId=0,flag=0
    for
    {
        s PHRIRowId=$o(^DHCPHRITM(PHRIRowId)) q:(PHRIRowId="")||(flag=1)  d
        s PHRIGenDr=$p($g(^DHCPHRITM(PHRIRowId)),"^",2)
        i PHRIGenDr=id
        {
            s flag=1
            s myInfo=myInfo_"<药品说明书编辑器-重复用药>"
        }
    }
    
    s LSYRowId=0,flag=0
    for
    {
        s LSYRowId=$o(^DHCPHDLSYI(LSYRowId)) q:(LSYRowId="")||(flag=1)  d
        s PHRIGenDr=$p($g(^DHCPHDLSYI(LSYRowId)),"^",2)
        i PHRIGenDr=id
        {
            s flag=1
            s myInfo=myInfo_"<诊断字典-关联症状>"
        }
    }
   	s PHSGRowId=0,flag=0
    for
    {
        s PHSGRowId=$o(^DHCPHSYNGEN(PHSGRowId)) q:(PHSGRowId="")||(flag=1)  d
        s PHRIGenDr=$p($g(^DHCPHSYNGEN(PHSGRowId)),"^",2)
        i PHRIGenDr=id
        {
            s flag=1
            s myInfo=myInfo_"<诊断字典-关联证型>"
        }
    }
    
    s PDLIRowId=0,flag=0
    for
    {
        s PDLIRowId=$o(^DHCPHDISLITM(PDLIRowId)) q:(PDLIRowId="")||(flag=1)  d
        s PHRIGenDr=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",2)
        i PHRIGenDr=id
        {
            s flag=1
            s myInfo=myInfo_"<诊断逻辑推导目录-推到目录明细>"
        }
    }
    
    s PDPRowId=0,flag=0
    for
    {
        s PDPRowId=$o(^DHCPHDISLPRO(PDPRowId)) q:(PDPRowId="")||(flag=1)  d
        s PHRIGenDr=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",3)
        i PHRIGenDr=id
        {
            s flag=1
            s myInfo=myInfo_"<诊断逻辑推导目录-推到目录提示表>"
        }
    }
    
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCPHExtGeneric
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHExtGeneric).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    
    s re=##class(web.DHCBL.KB.DHCPHExtGeneric).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.KB.DHCPHExtGeneric).%New()
        s pobj = ##class(User.DHCPHExtGeneric).%OpenId(id)
        s eobj.PHEGRowId = id
        s eobj.PHEGCode = pobj.PHEGCode
        s eobj.PHEGDesc = pobj.PHEGDesc
        s:pobj.PHEGLibDr'="" eobj.PHEGLibDr = pobj.PHEGLibDr.%Id()  
        s eobj.PHEGActiveFlag = pobj.PHEGActiveFlag
        s eobj.PHEGSysFlag = pobj.PHEGSysFlag
    
        s sc=##class(User.DHCPHExtGeneric).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtGeneric","User.DHCPHExtGeneric","通用名字典",id,eobj.PHEGDesc,"D",eobj)  
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名字典","web.DHCBL.KB.DHCPHExtGeneric","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
    }
    q result
}

/// /w ##class(web.DHCBL.KB.DHCPHExtGeneric).GetCTCareProvCount()
ClassMethod GetItemsCount() As %String
{
    k ^TMPITEMSCOUNT
    s count=0
    s id=0,PHEGCode=""
    for {
        s id=$o(^DHCPHEGEN(id)) q:id=""
        s PHEGCode=$p($g(^DHCPHEGEN(id)),"^",1)       //工号
        s count=count+1
        s ^TMPITEMSCOUNT(count)=id
    }   
    q count
}

/// /w ##class(web.DHCBL.KB.DHCPHExtGeneric).GetItemInfo("2")
ClassMethod GetItemInfo(i) As %String
{
    n (i)
    s str=""
    S PHEGRowId=$g(^TMPITEMSCOUNT(i))
    q:(PHEGRowId="") ""
    
    s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
    s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
        
    s str=PHEGCode_"#"_PHEGDesc
    q str
}

/// Creator：丁亚男
/// CreatDate: 2018-08-07
/// Description：查询通用名字典表描述
/// Table：User.DHCPHExtGeneric
/// Input：rowid
/// w ##class(web.DHCBL.KB.DHCPHExtGeneric).GetDesc("88")
ClassMethod GetDesc(rowid) As %String
{
    n (rowid)
    q:(rowid="") ""
    s PHEGDesc=$p($g(^DHCPHEGEN(rowid)),"^",2)  //描述
    q PHEGDesc
}

}
