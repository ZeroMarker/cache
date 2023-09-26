Class web.DHCBL.KB.DHCHisInstructions Extends %RegisteredObject
{

/// Creator:张云越
/// CreatDate:2019-10-16
/// Description:通过关联id和知识库标识
/// Input:PointerDr,LibDr
/// Other: w ##class(web.DHCBL.KB.DHCHisInstructions).GetPointerDesc("3384","检查项目")
ClassMethod GetPointerDesc(PointerDr, LibDesc)
{
	q:(PointerDr="")||(LibDesc="") ""
	s PointerDesc=""
	if ((LibDesc="检查项目")||(LibDesc="超声")||(LibDesc="放射")||(LibDesc="内镜")||(LibDesc="心电")||(LibDesc="治疗项目")) //检查
	{
		s PointerDesc = $p($g(^DHCPHEPA(PointerDr)),"^",2)
	}
	if LibDesc="检验项目" //检验
	{
		s PointerDesc = $p($g(^DHCPHEGEN(PointerDr)),"^",2)
	}
	q PointerDesc
}

/// Creator:张云越
/// CreatDate:2019-10-16
/// Description:通过通用名dr获取关联是否唯一	flag=1表示唯一
/// Input:GenDr
/// Other: w ##class(web.DHCBL.KB.DHCHisInstructions).GetFlag("134")	
ClassMethod GetFlag(GenDr)
{
	q:GenDr="" "" //2019-12-5新增控制
	s GIPRowId=0
	s count=0
	for
	{
		s GIPRowId = $o(^DHCGENLINPi(0,"Gen",GenDr,GIPRowId)) //通用名关联表id
		q:GIPRowId=""
		s count=count+1
	}
	if count>1 s Flag=0 //多条记录则不唯一
	else  s Flag=1
	q Flag
}

/// Creator:张云越
/// CreatDate:2019-10-16
/// Description:通过药品处方名获取剂型Dr
/// Input:HisDesc
/// Other: w ##class(web.DHCBL.KB.DHCHisInstructions).GetFormDr("10%葡萄糖注射液")
ClassMethod GetFormDr(HisDesc)
{
	q:HisDesc="" ""
	s PointerId=""
	s FormCode=""
	s HisName = $$ALPHAUP^SSUTIL4(HisDesc)
	s GERowId = $o(^PHCGE("GE",0,"Name",HisName,0)) //药品信息id	
	s:GERowId'="" PHCFDr = $p($g(^PHCGE("GE",GERowId,"DHC")),"^",5) //取到his的剂型id
	s:PHCFDr'="" PHCFCode = $p($g(^PHCF(PHCFDr)),"^",1) //his剂型的code	
	s:PHCFCode'="" PHFCTRowId = $o(^DHCPHFOCON(0,"HisCode",PHCFCode,0)) //剂型对照表id
	s:PHFCTRowId'="" FormCode = $p($g(^DHCPHFOCON(PHFCTRowId)),"^",1) //剂型代码
	s:FormCode'="" FormCode = $zconvert(FormCode,"U") //转换大写
	s:FormCode'="" PointerId = $o(^DHCPHEFi(0,"Code",FormCode,0))
	q PointerId
}

/// Creator:张云越
/// CreatDate:2019-10-16
/// Description:查询 检查部位字典
/// Input:desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCHisInstructions","GetDataForCmbLab","","","")
Query GetDataForCmbLab(rowid As %String, GenDr As %String, desc As %String) As %Query(ROWSPEC = "PointerId:%String,PHEGDesc:%String")
{
}

ClassMethod GetDataForCmbLabExecute(ByRef qHandle As %Binary, rowid As %String, GenDr As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (GenDr'="")
    {
	    s GIPRowId=0
	    for
	    {
		    s GIPRowId = $o(^DHCGENLINPi(0,"Gen",GenDr,GIPRowId)) q:GIPRowId=""
		    s PointerId = $p($g(^DHCGENLINP(GIPRowId)),"^",2) //标本id
		    s PHEGDesc = $p($g(^DHCPHEGEN(PointerId)),"^",2) //标本描述
		    s PHEGDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGDesc)
		    d OutputRowCmb	    
	    }
    }
    else
    {
        ;s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        /*s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1*/      
        s PointerId=0
        for
        {
	        s PointerId=$o(^DHCPHEGEN(PointerId)) q:PointerId=""
	        s LibDr = $p($g(^DHCPHEGEN(PointerId)),"^",7)
	        if (LibDr'=13) continue
	        //s strRowId="{ID:"_GICTRowId_"}"
	        //if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            //{
		    	s PHEGDesc = $p($g(^DHCPHEGEN(PointerId)),"^",2) //标本描述
                s PHEGDesc1=$ZCONVERT(PHEGDesc,"U")
                s PHEGDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEGDesc)
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGDesc1))
                i ((PHEGDesc1[desc)||(PINYIN[desc))
                {
                    d OutputRowCmb
                }
            //}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PointerId,PHEGDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmbLabFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

ClassMethod GetDataForCmbLabClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator:张云越
/// CreatDate:2019-10-16
/// Description:查询 检查部位字典
/// Input:desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCHisInstructions","GetDataForCmbCheck","","","")
Query GetDataForCmbCheck(rowid As %String, GenDr As %String, desc As %String) As %Query(ROWSPEC = "PointerId:%String,PHEPDesc:%String")
{
}

ClassMethod GetDataForCmbCheckExecute(ByRef qHandle As %Binary, rowid As %String, GenDr As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (GenDr'="")
    {
	    s GIPRowId=0
	    for
	    {
		    s GIPRowId = $o(^DHCGENLINPi(0,"Gen",GenDr,GIPRowId)) q:GIPRowId=""
		    s PointerId = $p($g(^DHCGENLINP(GIPRowId)),"^",2) //部位id
		    s PHEPDesc = $p($g(^DHCPHEPA(PointerId)),"^",2) //部位描述
		    s PHEPDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEPDesc)
		    d OutputRowCmb	    
	    }
    }
    else
    {
        ;s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        /*s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1*/      
        s PointerId=0
        for
        {
	        s PointerId=$o(^DHCPHEPA(PointerId)) q:PointerId=""
	        //s strRowId="{ID:"_GICTRowId_"}"
	        //if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            //{
		    	s PHEPDesc = $p($g(^DHCPHEPA(PointerId)),"^",2) //部位描述
                s PHEPDesc1=$ZCONVERT(PHEPDesc,"U")
                s PHEPDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEPDesc)
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEPDesc1))
                i ((PHEPDesc1[desc)||(PINYIN[desc))
                {
                    d OutputRowCmb
                }
            //}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PointerId,PHEPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmbCheckFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

ClassMethod GetDataForCmbCheckClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator:张云越
/// CreatDate:2019-10-16
/// Description:查询 剂型字典
/// Input:desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCHisInstructions","GetDataForCmbDrug","","","")
Query GetDataForCmbDrug(rowid As %String, GenDr As %String, desc As %String) As %Query(ROWSPEC = "PointerId:%String,PHEFDesc:%String")
{
}

ClassMethod GetDataForCmbDrugExecute(ByRef qHandle As %Binary, rowid As %String, GenDr As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (GenDr'="")
    {
	    s GIPRowId=0
	    for
	    {
		    s GIPRowId = $o(^DHCGENLINPi(0,"Gen",GenDr,GIPRowId)) q:GIPRowId=""
		    s PointerId = $p($g(^DHCGENLINP(GIPRowId)),"^",2) //剂型id
		    s PHEFDesc = $p($g(^DHCPHEF(PointerId)),"^",2) //剂型描述
		    s PHEFDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEFDesc)
		    d OutputRowCmb	    
	    }
    }
    else
    {
        ;s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        /*s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1*/      
        s PointerId=0
        for
        {
	        s PointerId=$o(^DHCPHEF(PointerId)) q:PointerId=""
	        //s strRowId="{ID:"_GICTRowId_"}"
	        //if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            //{
		    	s PHEFDesc = $p($g(^DHCPHEF(PointerId)),"^",2) //剂型描述
                s PHEFDesc1=$ZCONVERT(PHEFDesc,"U")
                s PHEFDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHEFDesc)
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEFDesc1))
                i ((PHEFDesc1[desc)||(PINYIN[desc))
                {
                    d OutputRowCmb
                }
            //}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PointerId,PHEFDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmbDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

ClassMethod GetDataForCmbDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator:张云越
/// CreatDate:2019-10-16
/// Description:通过通用名id查询知识库标识描述 药品 检查项目 检验项目 检验标本
/// Input:GenDr
/// Other: w ##class(web.DHCBL.KB.DHCHisInstructions).getLibDesc("134")
ClassMethod getLibDesc(GenDr)
{
	q:GenDr="" ""
	s LibId = $P($g(^DHCPHEGEN(GenDr)),"^",7)
	s LibDesc = $p($g(^DHCPHLIBL(LibId)),"^",2)
	q LibDesc
}

/// Creator:张云越
/// CreatDate:2019-10-15
/// Description:通过通用名id查询剂型、部位、标本的id
/// Input:GenDr
/// Other: w ##class(web.DHCBL.KB.DHCHisInstructions).getPointerDr("1231")
ClassMethod getPointerDr(GenDr)
{
	q:GenDr="" ""
	s PointerId=""
	s GIPRowId = $o(^DHCGENLINPi(0,"Gen",GenDr,0)) //通用名关联表id
	if GIPRowId'="" s PointerId = $p($g(^DHCGENLINP(GIPRowId)),"^",2)
	q PointerId
}

/// Creator:张云越
/// CreatDate:2019-10-15
/// Description:通过通用名查询通用名id
/// Input:GenDesc
/// Other: w ##class(web.DHCBL.KB.DHCHisInstructions).getGenDr("布洛芬缓释胶囊")
ClassMethod getGenDr(GenDesc As %String)
{
	q:GenDesc="" ""
	s GenDesc = $zconvert(GenDesc,"U")
	if $d(^DHCPHEGENi(0,"Desc",GenDesc))
	{
		s GenDr = $o(^DHCPHEGENi(0,"Desc",GenDesc,0))
		q GenDr
	}
	else
	{
		q ""
	}
}

/// Creator:张云越
/// CreatDate:2019-10-15
/// Description:通过His数据查询通用名
/// Input:HisDescID
/// Other: w ##class(web.DHCBL.KB.DHCHisInstructions).getGenDesc("1")
ClassMethod getGenDesc(HisDescID As %String)
{
	q:HisDescID="" ""
	s GenDesc = $p($g(^DHCPHGENCON(HisDescID)),"^",2)
	q GenDesc
}

/// Creator:张云越
/// CreatDate:2019-10-12
/// Description:查询 His对照数据
/// Input:desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCHisInstructions","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "GICTRowId:%String,GICTHisDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s GICTRowId=rowid
        s GICTHisDesc = $p($g(^DHCPHGENCON(GICTRowId)),"^",4)
        s GICTHisDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(GICTHisDesc)
        d OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        /*s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1*/
        
        s GICTRowId=0
        for
        {
	        s GICTRowId=$o(^DHCPHGENCON(GICTRowId)) q:GICTRowId=""
	        //s strRowId="{ID:"_GICTRowId_"}"
	        //if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            //{
                s GICTHisDesc = $p($g(^DHCPHGENCON(GICTRowId)),"^",4)
                s GICTHisDesc1=$ZCONVERT(GICTHisDesc,"U")
                s GICTHisDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(GICTHisDesc)
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(GICTHisDesc1))
                i ((GICTHisDesc1[desc)||(PINYIN[desc))
                {
                    d OutputRowCmb
                }
            //}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(GICTRowId,GICTHisDesc)
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
