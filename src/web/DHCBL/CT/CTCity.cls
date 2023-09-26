Import SQLUser

/// 名称:地理信息 - 4 城市
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-11 
Class web.DHCBL.CT.CTCity Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-19
/// Description:查询 城市
/// Table:User.CTCity
/// Input:rowid,code,desc,provincedr
/// Return:CTCITRowId,CTCITCode,CTCITDesc,CTCITProvinceDR,CTCITDateFrom,CTCITDateTo
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCity","GetList","","","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, provincedr As %String, start As %String, limit As %String) As %Query(ROWSPEC = "CTCITRowId:%String,CTCITCode:%String,CTCITDesc:%String,CTCITProvinceDR:%String,CTCITDateFrom:%String,CTCITDateTo:%String,CTCITRomanCode,CTCITRomanDesc,CTCITActivity,CTCITSeqNo,CTCITPYCode,CTCITWBCode,CTCITMark,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, provincedr As %String, start As %String, limit As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    
    
    if (rowid'="")
    {
        s CTCITRowId=rowid
        s CTCITCode=$p($g(^CT("CIT",CTCITRowId)),"^",1)
        s CTCITDesc=$p($g(^CT("CIT",CTCITRowId)),"^",2)
        s PROVRowId=$p($g(^CT("CIT",CTCITRowId)),"^",4)
        i PROVRowId'=""
        {
            s CTCITProvinceDR=$p($g(^CT("PROV",PROVRowId)),"^",2)
        }
        else
        {
            s CTCITProvinceDR=""
        }
        s CTCITDateFrom=$p($g(^CT("CIT",CTCITRowId)),"^",5)
        s CTCITDateTo=$p($g(^CT("CIT",CTCITRowId)),"^",6)
        s:CTCITDateFrom'="" CTCITDateFrom=$zd(CTCITDateFrom,1)
        s:CTCITDateTo'="" CTCITDateTo=$zd(CTCITDateTo,1)
        s CTCITRomanCode=$p($g(^CT("CIT",CTCITRowId)),"^",9)		//市级行政区罗马代码
	    s CTCITRomanDesc=$p($g(^CT("CIT",CTCITRowId)),"^",10)		//市级行政区罗马名称
	    s CTCITActivity=$p($g(^CT("CIT",CTCITRowId)),"^",11)	//是否有效(Y/N)
		s:CTCITActivity="" CTCITActivity="Y"
		s CTCITSeqNo=$p($g(^CT("CIT",CTCITRowId)),"^",15)		//系统排序号
		s CTCITPYCode=$p($g(^CT("CIT",CTCITRowId)),"^",19)		//拼音码
		s CTCITWBCode=$p($g(^CT("CIT",CTCITRowId)),"^",20)		//五笔码
		s CTCITMark=$p($g(^CT("CIT",CTCITRowId)),"^",21)		//备注
	
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_City",CTCITRowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)
        s BDPInternalDesc = $p($g(resultStr),"^",2)
        s BDPHospNationalCode=$p($g(resultStr),"^",3)  
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.CTCity).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1   
        s CTCITProvinceDRAuStr=##class(web.DHCBL.Authorize.CTProvince).DHCGetDataByDefaultSession()
        s CTCITProvinceDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (CTCITProvinceDRAuStr="")||(CTCITProvinceDRAuStr["limited:0") s CTCITProvinceDRAuFlag=1      
        s CTCITRowId=0
        s n=0
        for
        {
            s CTCITRowId=$o(^CT("CIT",CTCITRowId)) q:CTCITRowId=""      
            s CTCITProvinceDR=$p($g(^CT("CIT",CTCITRowId)),"^",4)
            s strRowId="{ID:"_CTCITRowId_"}"
            s CTCITProvinceDRstrRowId="{ID:"_CTCITProvinceDR_"}"
            if ((AuStr[strRowId)||(AuFlag=1))&&((CTCITProvinceDRAuStr[CTCITProvinceDRstrRowId)||(CTCITProvinceDRAuFlag=1)) ;用来筛选授权数据
            {
                s CTCITCode=$p($g(^CT("CIT",CTCITRowId)),"^",1)
                s CTCITDesc=$p($g(^CT("CIT",CTCITRowId)),"^",2)
                s CTCITCode1=$ZCONVERT(CTCITCode,"U")
                s CTCITDesc1=$ZCONVERT(CTCITDesc,"U")
                s PROVRowId=CTCITProvinceDR
                i CTCITProvinceDR'=""
                {
                    s CTCITProvinceDR=$p($g(^CT("PROV",CTCITProvinceDR)),"^",2)
                }
                
                s CTCITDateFrom=$p($g(^CT("CIT",CTCITRowId)),"^",5)
                s CTCITDateTo=$p($g(^CT("CIT",CTCITRowId)),"^",6)
                s:CTCITDateFrom'="" CTCITDateFrom=$zd(CTCITDateFrom,1)
                s:CTCITDateTo'="" CTCITDateTo=$zd(CTCITDateTo,1)
                
                s CTCITRomanCode=$p($g(^CT("CIT",CTCITRowId)),"^",9)		//市级行政区罗马代码
			    s CTCITRomanDesc=$p($g(^CT("CIT",CTCITRowId)),"^",10)		//市级行政区罗马名称
			    s CTCITActivity=$p($g(^CT("CIT",CTCITRowId)),"^",11)	//是否有效(Y/N)
				s:CTCITActivity="" CTCITActivity="Y"
				s CTCITSeqNo=$p($g(^CT("CIT",CTCITRowId)),"^",15)		//系统排序号
				s CTCITPYCode=$p($g(^CT("CIT",CTCITRowId)),"^",19)		//拼音码
				s CTCITWBCode=$p($g(^CT("CIT",CTCITRowId)),"^",20)		//五笔码
				s CTCITMark=$p($g(^CT("CIT",CTCITRowId)),"^",21)		//备注
		
                s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
                s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_City",CTCITRowId)
                s BDPInternalCode =$p($g(resultStr),"^",1)
                s BDPInternalDesc = $p($g(resultStr),"^",2)
                s BDPHospNationalCode=$p($g(resultStr),"^",3)  
                s BDPHospNationalDesc = $p($g(resultStr),"^",4)
                //别名查询
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_City",CTCITRowId,CTCITDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                }  
                if (CTCITCode1[code) &(AliasFlag=1)&((PROVRowId=provincedr)||(provincedr=""))
                {
                    d OutputRow
                }   
            }
        }
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(CTCITRowId,CTCITCode,CTCITDesc,CTCITProvinceDR,CTCITDateFrom,CTCITDateTo,CTCITRomanCode,CTCITRomanDesc,CTCITActivity,CTCITSeqNo,CTCITPYCode,CTCITWBCode,CTCITMark,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2013-2-22
/// Description:为combobox查询取数据
/// Table:User.CTCity
/// Input:code,desc,provincedr
/// Return:CTCITRowId,CTCITCode,CTCITDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCity","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, provincedr As %String) As %Query(ROWSPEC = "CTCITRowId:%String,CTCITCode:%String,CTCITDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, provincedr As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1

    if (rowid'="")
    {
        s CTCITRowId=rowid
        s CTCITCode=$p($g(^CT("CIT",CTCITRowId)),"^",1)
        s CTCITDesc=$p($g(^CT("CIT",CTCITRowId)),"^",2)
        s PROVRowId=$p($g(^CT("CIT",CTCITRowId)),"^",4)
        s PROVDesc=""
        s:PROVRowId'="" PROVDesc=$p($g(^CT("PROV",PROVRowId)),"^",2)    
        s:PROVDesc'="" CTCITDesc=CTCITDesc_"-"_PROVDesc
        d OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s AuStr=##class(web.DHCBL.Authorize.CTCity).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1   
        s CTCITProvinceDRAuStr=##class(web.DHCBL.Authorize.CTProvince).DHCGetDataByDefaultSession()
        s CTCITProvinceDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (CTCITProvinceDRAuStr="")||(CTCITProvinceDRAuStr["limited:0") s CTCITProvinceDRAuFlag=1      
        s CTCITRowId=0
        for
        {
            s CTCITRowId=$o(^CT("CIT",CTCITRowId)) q:CTCITRowId=""
            s CTCITProvinceDR=$p($g(^CT("CIT",CTCITRowId)),"^",4)
            s strRowId="{ID:"_CTCITRowId_"}"
            s CTCITProvinceDRstrRowId="{ID:"_CTCITProvinceDR_"}"
            if ((AuStr[strRowId)||(AuFlag=1))&&((CTCITProvinceDRAuStr[CTCITProvinceDRstrRowId)||(CTCITProvinceDRAuFlag=1)) ;用来筛选授权数据
            {
                s CTCITCode=$p($g(^CT("CIT",CTCITRowId)),"^",1)
                s CTCITDesc=$p($g(^CT("CIT",CTCITRowId)),"^",2)
                s CTCITDateFrom=$p($g(^CT("CIT",CTCITRowId)),"^",5)
                continue:(CTCITDateFrom'="")&&(CTCITDateFrom>+$h)
                s CTCITDateTo=$p($g(^CT("CIT",CTCITRowId)),"^",6)
                continue:(CTCITDateTo'="")&&(CTCITDateTo<+$h) 
                s CTCITCode1=$ZCONVERT(CTCITCode,"U")
                
                s PROVRowId=$p($g(^CT("CIT",CTCITRowId)),"^",4)
                s PROVDesc=""
                s:PROVRowId'="" PROVDesc=$p($g(^CT("PROV",PROVRowId)),"^",2)    
                s:PROVDesc'="" CTCITDesc=CTCITDesc_"-"_PROVDesc
                s CTCITDesc1=$ZCONVERT(CTCITDesc,"U")
                
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_City",CTCITRowId,CTCITDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                }  
                if (CTCITCode1[code) &(AliasFlag=1)&((PROVRowId=provincedr)||(provincedr=""))
                {   
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(CTCITRowId,CTCITCode,CTCITDesc)
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

Query GetDataForCmb2(rowid As %String, code As %String, desc As %String, provincedr As %String) As %Query(ROWSPEC = "CTCITRowId:%String,CTCITCode:%String,CTCITDesc:%String")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, provincedr As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1

    if (rowid'="")
    {
        s CTCITRowId=rowid
        s CTCITCode=$p($g(^CT("CIT",CTCITRowId)),"^",1)
        s CTCITDesc=$p($g(^CT("CIT",CTCITRowId)),"^",2)
        d OutputRowCmb2
    }
    else
    {
        
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s AuStr=##class(web.DHCBL.Authorize.CTCity).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1   
        s CTCITProvinceDRAuStr=##class(web.DHCBL.Authorize.CTProvince).DHCGetDataByDefaultSession()
        s CTCITProvinceDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (CTCITProvinceDRAuStr="")||(CTCITProvinceDRAuStr["limited:0") s CTCITProvinceDRAuFlag=1      
        s CTCITRowId=0
        for
        {
            s CTCITRowId=$o(^CT("CIT",CTCITRowId)) q:CTCITRowId=""
            s CTCITProvinceDR=$p($g(^CT("CIT",CTCITRowId)),"^",4)
            s strRowId="{ID:"_CTCITRowId_"}"
            s CTCITProvinceDRstrRowId="{ID:"_CTCITProvinceDR_"}"
            if ((AuStr[strRowId)||(AuFlag=1))&&((CTCITProvinceDRAuStr[CTCITProvinceDRstrRowId)||(CTCITProvinceDRAuFlag=1)) ;用来筛选授权数据
            {
                s CTCITCode=$p($g(^CT("CIT",CTCITRowId)),"^",1)
                s CTCITDesc=$p($g(^CT("CIT",CTCITRowId)),"^",2)
                s CTCITCode1=$ZCONVERT(CTCITCode,"U")
                s CTCITDesc1=$ZCONVERT(CTCITDesc,"U")
                s PROVRowId=$p($g(^CT("CIT",CTCITRowId)),"^",4)
                s CTCITDateFrom=$p($g(^CT("CIT",CTCITRowId)),"^",5)
                s CTCITDateTo=$p($g(^CT("CIT",CTCITRowId)),"^",6)
                continue:(CTCITDateTo'="")&&(CTCITDateTo<+$h)
                //别名查询
                /*s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_City",CTCITRowId,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                    
                }
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTCITDesc1)
                i (CTCITCode1[code)&((CTCITDesc1[desc)||(ALIASText1[desc)||(PINYIN[desc))&(PROVRowId=provincedr)*/
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_City",CTCITRowId,CTCITDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                }  
                if (CTCITCode1[code) &(AliasFlag=1)&(PROVRowId=provincedr)
                {   
                    d OutputRowCmb2
                }
            }
        
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb2
    set Data=$lb(CTCITRowId,CTCITCode,CTCITDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
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

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

// CTCIT_Province_DR->CT_Province

/// Creator:陈莹
/// CreatDate:2012-12-24
/// Description:数据重复验证方法,js调用,描述和省份一起校验,不同省份下 描述可以重复
/// Table:User.CTCity
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.CTCity).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, proDr As %String = "") As %String
{
	new (id,code,desc,proDr)
	s flag=""
	if ($$ALPHAUP^SSUTIL4(code)'="")
	{
		s CTCITRowId=0
		for
		{
			s CTCITRowId=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(code),CTCITRowId)) q:CTCITRowId=""      
			s CTCITDateTo=$p($g(^CT("CIT",CTCITRowId)),"^",6)
			continue:(CTCITDateTo'="")
			if (CTCITRowId'=id)
			{
				s flag=1
			}
		}
	}
	if ($$ALPHAUP^SSUTIL4(desc)'="")
	{
		s CTCITRowId=0
		for
		{
			s CTCITRowId=$o(^CT("CIT",0,"Desc",$$ALPHAUP^SSUTIL4(desc),CTCITRowId)) q:CTCITRowId=""      
			s CTCITDateTo=$p($g(^CT("CIT",CTCITRowId)),"^",6)
			continue:(CTCITDateTo'="")
			s PROVRowId=$p($g(^CT("CIT",CTCITRowId)),"^",4)
			if (CTCITRowId'=id)&&(PROVRowId=proDr)
			{
				s flag=1
			}
		} 
	}
	q flag
}

/// Creator:谷雪萍
/// CreatDate:2017-07-04
/// Description:数据重复验证方法,js调用,描述和省份一起校验,不同省份下 描述可以重复，
/// Table:User.CTCity
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.CTCity).Validate("","","")
ClassMethod Validate(id As %String, code As %String, desc As %String, proDr As %String) As %String
{
    new (id,code,desc,proDr)
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
    s flag=""
    s flagc=""
    s flagd=""
    s:code'="" flagc=$d(^CT("CIT",0,"Code",code))
    s:desc'="" flagd=$d(^CT("CIT",0,"ProvDesc",proDr,desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0))
        {
            s flag=1  //返回重复标志
        }
        else
        {
            s flag=0 //返回不重复标志
        }
    }
    else //如果不为空，修改时的重复判断
    {
        s idc=""
        s idd=""
        s:code'="" idc=$o(^CT("CIT",0,"Code",code,0))
        s:desc'="" idd=$o(^CT("CIT",0,"ProvDesc",proDr,desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-11
/// Description:双击修改时,从后台取数据
/// Table:User.CTCity
/// Input:id
/// Return:Json格式的字符串str={list:[CTCITCode,CTCITDesc,CTCITProvinceDR,CTCITDateFrom,CTCITDateTo,CTCITRowId]}
/// Other:d ##class(web.DHCBL.CT.CTCity).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    n (id)
    s str=""
    s pobj = ##class(User.CTCity).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTCity).%New()
    s eobj.CTCITRowId = id
    s eobj.CTCITCode = pobj.CTCITCode
    s eobj.CTCITDesc = pobj.CTCITDesc
    if $IsObject(pobj.CTCITProvinceDR){
        s eobj.CTCITProvinceDR = pobj.CTCITProvinceDR.%Id() 
        }
    s eobj.CTCITDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTCITDateFrom)
    s eobj.CTCITDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTCITDateTo)
    
    s eobj.CTCITRomanCode   = pobj.CTCITRomanCode		//市级行政区罗马代码
    s eobj.CTCITRomanDesc   = pobj.CTCITRomanDesc		//市级行政区罗马名称
    s eobj.CTCITActivity=pobj.CTCITActivity	//是否有效(Y/N)
	s:((eobj.CTCITActivity="")||(eobj.CTCITActivity="Y")) eobj.CTCITActivity="true"
	s eobj.CTCITSeqNo=pobj.CTCITSeqNo		//系统排序号
	s eobj.CTCITPYCode=pobj.CTCITPYCode		//拼音码
	s eobj.CTCITWBCode=pobj.CTCITWBCode		//五笔码
	s eobj.CTCITMark=pobj.CTCITMark		//备注
				
    d pobj.%Close()
    k pobj
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Creator:陈莹
/// CreatDate:2012-9-11
/// Description:增加/修改 城市
/// Table:User.CTCity
/// Input:web.Entity.CT.CTCity
/// Return:成功返回success:'true'和新增或修改的数据的CTCITRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.CTCity) As %String
{
    new (eobj,%session)
    s result=""
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 
    if $IsObject(eobj)
    {
	    s:eobj.CTCITLastUpdateDate="" eobj.CTCITLastUpdateDate=+$h		//系统最后更新日期
	    s:eobj.CTCITLastUpdateTime="" eobj.CTCITLastUpdateTime=$p($h,",",2)		//系统最后更新时间
	    s:eobj.CTCITLastUpdateUser="" eobj.CTCITLastUpdateUser=UserID	//系统最新更新人
	    s:eobj.CTCITActivity="" eobj.CTCITActivity="N"		//是否有效
        s flag=..FormValidate(eobj.CTCITRowId,eobj.CTCITCode,eobj.CTCITDesc,eobj.CTCITProvinceDR)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            //前台js已添加空值判断、重复判断、开始日期是否小于结束日期
            s:eobj.CTCITDateFrom'="" eobj.CTCITDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTCITDateFrom)
            s:eobj.CTCITDateTo'="" eobj.CTCITDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTCITDateTo)
            s:eobj.CTCITDateFrom="" eobj.CTCITDateFrom=+$h
            if (eobj.CTCITRowId="")       
            {
                s obj=##class(User.CTCity).%New()
                s:eobj.CTCITCreateDate="" eobj.CTCITCreateDate=+$h	//系统创建日期默认当前日期
			    s:eobj.CTCITCreateTime="" eobj.CTCITCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
			    s:eobj.CTCITCreateUser="" eobj.CTCITCreateUser= UserID		//系统创建人默认当前登录人员
			    s obj.CTCITCreateDate=eobj.CTCITCreateDate		//系统创建日期
				s obj.CTCITCreateTime=eobj.CTCITCreateTime		//系统创建时间
				d obj.CTCITCreateUserSetObjectId(eobj.CTCITCreateUser)	//系统创建人
            }
            else                           
            {
                s obj=##class(User.CTCity).%OpenId(eobj.CTCITRowId)
            
                s bobj=##class(web.Entity.CT.CTCity).%New()
                s bobj.CTCITRowId = eobj.CTCITRowId
                s bobj.CTCITCode = obj.CTCITCode
                s bobj.CTCITDesc = obj.CTCITDesc
                if $IsObject(obj.CTCITProvinceDR){
                        s bobj.CTCITProvinceDR = obj.CTCITProvinceDR.%Id() 
                    }
                s bobj.CTCITDateFrom = obj.CTCITDateFrom
                s bobj.CTCITDateTo   = obj.CTCITDateTo
                
                s bobj.CTCITRomanCode   = obj.CTCITRomanCode		//市级行政区罗马代码
                s bobj.CTCITRomanDesc   = obj.CTCITRomanDesc		//市级行政区罗马名称
                s bobj.CTCITActivity=obj.CTCITActivity	//是否有效(Y/N)
				s bobj.CTCITCreateDate=obj.CTCITCreateDate		//系统创建日期
				s bobj.CTCITCreateTime=obj.CTCITCreateTime		//系统创建时间
				if $IsObject(obj.CTCITCreateUser){
					s bobj.CTCITCreateUser = obj.CTCITCreateUser.%Id() 	//系统创建人
				}
				s bobj.CTCITSeqNo=obj.CTCITSeqNo		//系统排序号
				s bobj.CTCITLastUpdateDate=obj.CTCITLastUpdateDate		//系统最后更新日期
				s bobj.CTCITLastUpdateTime=obj.CTCITLastUpdateTime		//系统最后更新时间
				if $IsObject(obj.CTCITLastUpdateUser){
					s bobj.CTCITLastUpdateUser = obj.CTCITLastUpdateUser.%Id() 	//系统最新更新人
				}
				s bobj.CTCITPYCode=obj.CTCITPYCode		//拼音码
				s bobj.CTCITWBCode=obj.CTCITWBCode		//五笔码
				s bobj.CTCITMark=obj.CTCITMark		//备注

            }
            s obj.CTCITCode = eobj.CTCITCode
            s obj.CTCITDesc = eobj.CTCITDesc
            d obj.CTCITProvinceDRSetObjectId(eobj.CTCITProvinceDR)
            //s obj.CTCITProvinceDR=##class(User.CTProvince).%OpenId(eobj.CTCITProvinceDR)
            s obj.CTCITDateFrom = eobj.CTCITDateFrom
            s obj.CTCITDateTo   = eobj.CTCITDateTo
            
            s obj.CTCITRomanCode= eobj.CTCITRomanCode		//市级行政区罗马代码
            s obj.CTCITRomanDesc= eobj.CTCITRomanDesc		//市级行政区罗马名称
        	s obj.CTCITActivity=eobj.CTCITActivity	//是否有效(Y/N)
			
			s obj.CTCITSeqNo=eobj.CTCITSeqNo		//系统排序号
			s obj.CTCITLastUpdateDate=eobj.CTCITLastUpdateDate		//系统最后更新日期
			s obj.CTCITLastUpdateTime=eobj.CTCITLastUpdateTime		//系统最后更新时间
			d obj.CTCITLastUpdateUserSetObjectId(eobj.CTCITLastUpdateUser)	//系统最新更新人
			s:eobj.CTCITPYCode="" eobj.CTCITPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.CTCITDesc)
			s obj.CTCITPYCode=eobj.CTCITPYCode		//拼音码
			s:eobj.CTCITWBCode="" eobj.CTCITWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.CTCITDesc,1)
			s obj.CTCITWBCode=eobj.CTCITWBCode		//五笔码
			s obj.CTCITMark=eobj.CTCITMark		//备注
		
            Tstart
            s sc=obj.%Save()
            do obj.%Close()
            if $$$ISOK(sc){
                Tcommit
                s id = obj.%Id()
                if (eobj.CTCITRowId="")  //新增时加别名
     			{
	                s Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(obj.CTCITDesc)
	                s listData ="^"_"CT_City"_"^"_Alias_"^"_id
	                s ret=##class(web.DHCBL.BDP.BDPAlias).SaveEntity(listData)
     			}
                s result = "{success:'true',id:'"_id_"'}"
                d:eobj.CTCITRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_City","User.CTCity","城市",id,eobj.CTCITDesc,"A",eobj)
                d:eobj.CTCITRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_City","User.CTCity","城市",id,eobj.CTCITDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("城市","web.DHCBL.CT.CTCity","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }
        }
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }   
    q result
}

/// Creator:陈莹
/// CreatDate:2013-8-21
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    if $d(^CT("ZIP",0,"City",id)){
        s myInfo=myInfo_"<邮编>"
    }   
    
    if $d(^CT("CITAREA",0,"CityCode",id))
    {
        s myInfo=myInfo_"<城市区域>"
    }
    if $d(^CT("ADD",0,"City",id))
    {
        s myInfo=myInfo_"<地址>"
    }
    
    if $d(^CT.BDP.CT.HOSOrganizationI("IndexCITYCode",id)){
        s myInfo=myInfo_"<组织机构树>"
    }
    if $d(^CT.BDP.CT.HOSPersonI("IndexNPCITYCode",id)){
        s myInfo=myInfo_"<组织人员>"
    }
    if $d(^CT.BDP.CT.HOSPersonI("IndexAddrCITYCode",id)){
        s myInfo=myInfo_"<组织人员>"
    }
    
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:陈莹
/// CreatDate:2012-9-11
/// Description:根据id删除 城市
/// Table:User.CTCity
/// Input:id(CTCity的CTCITRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.CTCity).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s re=##class(web.DHCBL.CT.CTCity).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
    s pobj = ##class(User.CTCity).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTCity).%New()
    s eobj.CTCITRowId = id
    s eobj.CTCITCode = pobj.CTCITCode
    s eobj.CTCITDesc = pobj.CTCITDesc
    if $IsObject(pobj.CTCITProvinceDR){
        s eobj.CTCITProvinceDR = pobj.CTCITProvinceDR.%Id() 
        }
    s eobj.CTCITDateFrom =pobj.CTCITDateFrom
    s eobj.CTCITDateTo = pobj.CTCITDateTo
    
    //s:pobj.CTCITDateFrom'="" eobj.CTCITDateFrom =$zd(pobj.CTCITDateFrom,1)
    //s:pobj.CTCITDateTo'="" eobj.CTCITDateTo = $zd(pobj.CTCITDateTo,1)
   	s eobj.CTCITRomanCode   = pobj.CTCITRomanCode		//市级行政区罗马代码
    s eobj.CTCITRomanDesc   = pobj.CTCITRomanDesc		//市级行政区罗马名称
    s eobj.CTCITActivity=pobj.CTCITActivity	//是否有效(Y/N)

	s eobj.CTCITSeqNo=pobj.CTCITSeqNo		//系统排序号
	s eobj.CTCITPYCode=pobj.CTCITPYCode		//拼音码
	s eobj.CTCITWBCode=pobj.CTCITWBCode		//五笔码
	s eobj.CTCITMark=pobj.CTCITMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(User.CTCity).%DeleteId(id)
    if $$$ISOK(sc){
        Tcommit
        s result="{success:'true',info:'删除成功！'}"
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_City","User.CTCity","城市",id,eobj.CTCITDesc,"D",eobj)
    }
    else{
        Trollback
        s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("城市","web.DHCBL.CT.CTCity","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    q result
}

/// 用作调试增改功能
ClassMethod SaveTest()
{
    ; d ##class(web.DHCBL.CT.CTCity).SaveTest()
    s mobj = ##class(web.Entity.CT.CTCity).%New()
    s mobj.CTCITCode = "AAAAA"
    s mobj.CTCITDesc = "CCCCCC"
    d ..SaveEntity(mobj)
}

}
