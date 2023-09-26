Import SQLUser

/// 名称:地理信息 - 1 国籍/地区
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-10
Class web.DHCBL.CT.CTCountry Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-19
/// Description:查询 国籍/地区
/// Table:User.CTCountry
/// Input:rowid,code,desc,active
/// Return:CTCOURowId,CTCOUCode,CTCOUDesc,CTCOUActive,CTCOUDateActiveFrom,CTCOUDateActiveTo
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCountry","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, active As %String) As %Query(ROWSPEC = "CTCOURowId:%String,CTCOUCode:%String,CTCOUDesc:%String,CTCOUActive:%String,CTCOUDateActiveFrom:%String,CTCOUDateActiveTo:%String,CTCOUENGShortDesc,CTCOUCHNFullDesc,CTCOUENGFullDesc,CTCOURomanCode2,CTCOURomanCode3,CTCOUSeqNo,CTCOUPYCode,CTCOUWBCode,CTCOUMark,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String,CTCOULanguageDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, active As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    
    if (rowid'="")
    {
        s CTCOURowId=rowid
        s CTCOUCode=$p($g(^CT("COU",CTCOURowId)),"^",1)
        s CTCOUDesc=$p($g(^CT("COU",CTCOURowId)),"^",2)
        s CTCOUActive=$p($g(^CT("COU",CTCOURowId)),"^",3)
        s:CTCOUActive="" CTCOUActive="Y"
        s CTCOUDateActiveFrom=$p($g(^CT("COU",CTCOURowId)),"^",4)
        s CTCOUDateActiveTo=$p($g(^CT("COU",CTCOURowId)),"^",5)
        s CTCOULanguageDR=$p($g(^CT("COU",CTCOURowId)),"^",6)
        s:CTCOULanguageDR'="" CTCOULanguageDR=$p($g(^SS("LAN",CTCOULanguageDR)),"^",2)      //语言
        s:CTCOUDateActiveFrom'="" CTCOUDateActiveFrom=$zd(CTCOUDateActiveFrom,1)
        s:CTCOUDateActiveTo'="" CTCOUDateActiveTo=$zd(CTCOUDateActiveTo,1)
        s CTCOUENGShortDesc = $p($g(^CT("COU",CTCOURowId)),"^",7)	//英文简称
	    s CTCOUCHNFullDesc = $p($g(^CT("COU",CTCOURowId)),"^",8)		//中文全称
	    s CTCOUENGFullDesc = $p($g(^CT("COU",CTCOURowId)),"^",9)		//英文全称
	    s CTCOURomanCode2 = $p($g(^CT("COU",CTCOURowId)),"^",10)		//罗马2字符代码
	    s CTCOURomanCode3 = $p($g(^CT("COU",CTCOURowId)),"^",11)		//罗马3字符代码
	    
		s CTCOUSeqNo=$p($g(^CT("COU",CTCOURowId)),"^",15)		//系统排序号
		s CTCOUPYCode=$p($g(^CT("COU",CTCOURowId)),"^",19)		//拼音码
		s CTCOUWBCode=$p($g(^CT("COU",CTCOURowId)),"^",20)		//五笔码
		s CTCOUMark=$p($g(^CT("COU",CTCOURowId)),"^",21)		//备注
	
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Country",CTCOURowId)
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
        s AuStr=##class(web.DHCBL.Authorize.CTCountry).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        s CTCOURowId=0
        for
        {   
            s CTCOURowId=$o(^CT("COU",CTCOURowId)) q:CTCOURowId=""
            s strRowId="{ID:"_CTCOURowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s CTCOUCode=$p($g(^CT("COU",CTCOURowId)),"^",1)
                s CTCOUDesc=$p($g(^CT("COU",CTCOURowId)),"^",2)
                s CTCOUCode1=$ZCONVERT(CTCOUCode,"U")
                s CTCOUDesc1=$ZCONVERT(CTCOUDesc,"U")
                s CTCOUActive=$p($g(^CT("COU",CTCOURowId)),"^",3)
                s:CTCOUActive="" CTCOUActive="Y"
                s CTCOUDateActiveFrom=$p($g(^CT("COU",CTCOURowId)),"^",4)
                s CTCOUDateActiveTo=$p($g(^CT("COU",CTCOURowId)),"^",5)
                s CTCOULanguageDR=$p($g(^CT("COU",CTCOURowId)),"^",6)
        		s:CTCOULanguageDR'="" CTCOULanguageDR=$p($g(^SS("LAN",CTCOULanguageDR)),"^",2)      //语言
                s:CTCOUDateActiveFrom'="" CTCOUDateActiveFrom=$zd(CTCOUDateActiveFrom,1)
                s:CTCOUDateActiveTo'="" CTCOUDateActiveTo=$zd(CTCOUDateActiveTo,1)
                
                s CTCOUENGShortDesc = $p($g(^CT("COU",CTCOURowId)),"^",7)	//英文简称
			    s CTCOUCHNFullDesc = $p($g(^CT("COU",CTCOURowId)),"^",8)		//中文全称
			    s CTCOUENGFullDesc = $p($g(^CT("COU",CTCOURowId)),"^",9)		//英文全称
			    s CTCOURomanCode2 = $p($g(^CT("COU",CTCOURowId)),"^",10)		//罗马2字符代码
			    s CTCOURomanCode3 = $p($g(^CT("COU",CTCOURowId)),"^",11)		//罗马3字符代码
			    
				s CTCOUSeqNo=$p($g(^CT("COU",CTCOURowId)),"^",15)		//系统排序号
				s CTCOUPYCode=$p($g(^CT("COU",CTCOURowId)),"^",19)		//拼音码
				s CTCOUWBCode=$p($g(^CT("COU",CTCOURowId)),"^",20)		//五笔码
				s CTCOUMark=$p($g(^CT("COU",CTCOURowId)),"^",21)		//备注
		
                s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
                s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Country",CTCOURowId)
                s BDPInternalCode =$p($g(resultStr),"^",1)
                s BDPInternalDesc = $p($g(resultStr),"^",2)
                s BDPHospNationalCode=$p($g(resultStr),"^",3)  
                s BDPHospNationalDesc = $p($g(resultStr),"^",4)
                
                //别名查询
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Country",CTCOURowId,CTCOUDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                }  
                if ($ZCONVERT(CTCOUCode,"U")[code) &(AliasFlag=1)&((CTCOUActive=active)||(active=""))
                {
                    d OutputRow
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(CTCOURowId,CTCOUCode,CTCOUDesc,CTCOUActive,CTCOUDateActiveFrom,CTCOUDateActiveTo,CTCOUENGShortDesc,CTCOUCHNFullDesc,CTCOUENGFullDesc,CTCOURomanCode2,CTCOURomanCode3,CTCOUSeqNo,CTCOUPYCode,CTCOUWBCode,CTCOUMark,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,CTCOULanguageDR)
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
/// Table:User.CTCountry
/// Input:code,desc
/// Return:CTCOURowId,CTCOUCode,CTCOUDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCountry","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTCOURowId:%String,CTCOUCode:%String,CTCOUDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s CTCOURowId=rowid
        s CTCOUCode=$p($g(^CT("COU",CTCOURowId)),"^",1)
        s CTCOUDesc=$p($g(^CT("COU",CTCOURowId)),"^",2)
        d OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s AuStr="limited:0" // ##class(web.DHCBL.Authorize.CTCountry).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        s CTCOURowId=0
        for
        {
            s CTCOURowId=$o(^CT("COU",CTCOURowId)) q:CTCOURowId=""
            s strRowId="{ID:"_CTCOURowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s CTCOUCode=$p($g(^CT("COU",CTCOURowId)),"^",1)
                s CTCOUDesc=$p($g(^CT("COU",CTCOURowId)),"^",2)
                s CTCOUActive=$p($g(^CT("COU",CTCOURowId)),"^",3)
                continue:CTCOUActive="N"
                s CTCOUDateActiveFrom=$p($g(^CT("COU",CTCOURowId)),"^",4)
                continue:(CTCOUDateActiveFrom'="")&&(CTCOUDateActiveFrom>+$h)
                s CTCOUDateActiveTo=$p($g(^CT("COU",CTCOURowId)),"^",5) 
                continue:(CTCOUDateActiveTo'="")&&(CTCOUDateActiveTo<+$h)
                s CTCOUCode1=$ZCONVERT(CTCOUCode,"U")
                s CTCOUDesc1=$ZCONVERT(CTCOUDesc,"U") 
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Country",CTCOURowId,CTCOUDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                }  
                if ($ZCONVERT(CTCOUCode,"U")[code) &(AliasFlag=1)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(CTCOURowId,CTCOUCode,CTCOUDesc)
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

/// Creator:陈莹
/// CreatDate:2012-12-24
/// Description:数据重复验证方法,js调用
/// Table:User.CTCountry
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.CTCountry).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    new (id,code,desc)
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
    s flag=""
    s flagc=""
    s flagd=""
    s:code'="" flagc=$d(^CT("COU",0,"Code",code))
    s:desc'="" flagd=$d(^CT("COU",0,"Desc",desc))
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
        s:code'="" idc=$o(^CT("COU",0,"Code",code,0))
        s:desc'="" idd=$o(^CT("COU",0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-10
/// Description:双击修改时,从后台取数据
/// Table:User.CTCountry
/// Input:id
/// Return:Json格式的字符串str={list:[CTCOUCode,CTCOUDesc,CTCOUActive,CTCOUDateActiveFrom,CTCOUDateActiveTo,CTCOURowId]}
/// Other:d ##class(web.DHCBL.CT.CTCountry).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    n (id)
    s str=""
    s pobj = ##class(User.CTCountry).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTCountry).%New()
    s eobj.CTCOURowId = id
    s eobj.CTCOUCode = pobj.CTCOUCode
    s eobj.CTCOUDesc = pobj.CTCOUDesc
    //s eobj.CTCOUActive = pobj.CTCOUActive  //radio
    s:pobj.CTCOUActive="Y" eobj.CTCOUActive="true" // checkox
    s eobj.CTCOUDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTCOUDateActiveFrom)
    s eobj.CTCOUDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTCOUDateActiveTo)
    //s:pobj.CTCOUDateActiveFrom'="" eobj.CTCOUDateActiveFrom =$zd(pobj.CTCOUDateActiveFrom,1)
    //s:pobj.CTCOUDateActiveTo'="" eobj.CTCOUDateActiveTo = $zd(pobj.CTCOUDateActiveTo,1)
    s:pobj.CTCOULanguageDR'="" eobj.CTCOULanguageDR = pobj.CTCOULanguageDR.%Id()
    
    s eobj.CTCOUENGShortDesc = pobj.CTCOUENGShortDesc	//英文简称
    s eobj.CTCOUCHNFullDesc = pobj.CTCOUCHNFullDesc		//中文全称
    s eobj.CTCOUENGFullDesc = pobj.CTCOUENGFullDesc		//英文全称
    s eobj.CTCOURomanCode2 = pobj.CTCOURomanCode2		//罗马2字符代码
    s eobj.CTCOURomanCode3 = pobj.CTCOURomanCode3		//罗马3字符代码
    
	s eobj.CTCOUSeqNo=pobj.CTCOUSeqNo		//系统排序号
	s eobj.CTCOUPYCode=pobj.CTCOUPYCode		//拼音码
	s eobj.CTCOUWBCode=pobj.CTCOUWBCode		//五笔码
	s eobj.CTCOUMark=pobj.CTCOUMark		//备注
			
    d pobj.%Close()
    k pobj
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Creator:陈莹
/// CreatDate:2012-9-10
/// Description:增加/修改国籍/地区的内容
/// Table:User.CTCountry
/// Input:web.Entity.CT.CTCountry
/// Return:成功返回success:'true'和新增或修改的数据的CTCOURowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.CTCountry) As %String
{
    new (eobj,%session)
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    }  
    
    s:eobj.CTCOULastUpdateDate="" eobj.CTCOULastUpdateDate=+$h		//系统最后更新日期
    s:eobj.CTCOULastUpdateTime="" eobj.CTCOULastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.CTCOULastUpdateUser="" eobj.CTCOULastUpdateUser=UserID	//系统最新更新人
    
    s result=""
    if $IsObject(eobj)
    {
        s:eobj.CTCOUActive="" eobj.CTCOUActive="N" //checkbox
        //前台js已添加空值判断、重复判断、开始日期是否小于结束日期
        //s:eobj.CTCOUDateActiveFrom'="" eobj.CTCOUDateActiveFrom = $zdh(eobj.CTCOUDateActiveFrom,15)
        //s:eobj.CTCOUDateActiveTo'="" eobj.CTCOUDateActiveTo = $zdh(eobj.CTCOUDateActiveTo,15)
        s:eobj.CTCOUDateActiveFrom'="" eobj.CTCOUDateActiveFrom= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTCOUDateActiveFrom)
        s:eobj.CTCOUDateActiveTo'="" eobj.CTCOUDateActiveTo= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTCOUDateActiveTo)
        s:eobj.CTCOUDateActiveFrom="" eobj.CTCOUDateActiveFrom=+$h
        if (eobj.CTCOURowId="")       
        {
            s obj=##class(User.CTCountry).%New()
            s:eobj.CTCOUCreateDate="" eobj.CTCOUCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.CTCOUCreateTime="" eobj.CTCOUCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.CTCOUCreateUser="" eobj.CTCOUCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.CTCOUCreateDate=eobj.CTCOUCreateDate		//系统创建日期
			s obj.CTCOUCreateTime=eobj.CTCOUCreateTime		//系统创建时间
			d obj.CTCOUCreateUserSetObjectId(eobj.CTCOUCreateUser)	//系统创建人
        }
        else                           
        {
            s obj=##class(User.CTCountry).%OpenId(eobj.CTCOURowId)
            s bobj = ##class(web.Entity.CT.CTCountry).%New()
            s bobj.CTCOURowId = eobj.CTCOURowId
            s bobj.CTCOUCode = obj.CTCOUCode
            s bobj.CTCOUDesc = obj.CTCOUDesc
            s bobj.CTCOUActive = obj.CTCOUActive		//是否有效(Y/N)
            s bobj.CTCOUDateActiveFrom = obj.CTCOUDateActiveFrom
            s bobj.CTCOUDateActiveTo = obj.CTCOUDateActiveTo
            s:obj.CTCOULanguageDR'="" bobj.CTCOULanguageDR = obj.CTCOULanguageDR.%Id()
            
            s bobj.CTCOUENGShortDesc = obj.CTCOUENGShortDesc	//英文简称
            s bobj.CTCOUCHNFullDesc = obj.CTCOUCHNFullDesc		//中文全称
            s bobj.CTCOUENGFullDesc = obj.CTCOUENGFullDesc		//英文全称
            s bobj.CTCOURomanCode2 = obj.CTCOURomanCode2		//罗马2字符代码
            s bobj.CTCOURomanCode3 = obj.CTCOURomanCode3		//罗马3字符代码
            
            s bobj.CTCOUCreateDate=obj.CTCOUCreateDate		//系统创建日期
			s bobj.CTCOUCreateTime=obj.CTCOUCreateTime		//系统创建时间
			if $IsObject(obj.CTCOUCreateUser){
				s bobj.CTCOUCreateUser = obj.CTCOUCreateUser.%Id() 	//系统创建人
			}
			s bobj.CTCOUSeqNo=obj.CTCOUSeqNo		//系统排序号
			s bobj.CTCOULastUpdateDate=obj.CTCOULastUpdateDate		//系统最后更新日期
			s bobj.CTCOULastUpdateTime=obj.CTCOULastUpdateTime		//系统最后更新时间
			if $IsObject(obj.CTCOULastUpdateUser){
				s bobj.CTCOULastUpdateUser = obj.CTCOULastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.CTCOUPYCode=obj.CTCOUPYCode		//拼音码
			s bobj.CTCOUWBCode=obj.CTCOUWBCode		//五笔码
			s bobj.CTCOUMark=obj.CTCOUMark		//备注
        }
        s obj.CTCOUCode = eobj.CTCOUCode
        s obj.CTCOUDesc = eobj.CTCOUDesc
        s obj.CTCOUActive = eobj.CTCOUActive
        s obj.CTCOUDateActiveFrom = eobj.CTCOUDateActiveFrom
        s obj.CTCOUDateActiveTo = eobj.CTCOUDateActiveTo
        d obj.CTCOULanguageDRSetObjectId(eobj.CTCOULanguageDR)
        
        s obj.CTCOUENGShortDesc = eobj.CTCOUENGShortDesc	//英文简称
        s obj.CTCOUCHNFullDesc = eobj.CTCOUCHNFullDesc		//中文全称
        s obj.CTCOUENGFullDesc = eobj.CTCOUENGFullDesc		//英文全称
        s obj.CTCOURomanCode2 = eobj.CTCOURomanCode2		//罗马2字符代码
        s obj.CTCOURomanCode3 = eobj.CTCOURomanCode3		//罗马3字符代码
        
		s obj.CTCOUSeqNo=eobj.CTCOUSeqNo		//系统排序号
		s obj.CTCOULastUpdateDate=eobj.CTCOULastUpdateDate		//系统最后更新日期
		s obj.CTCOULastUpdateTime=eobj.CTCOULastUpdateTime		//系统最后更新时间
		d obj.CTCOULastUpdateUserSetObjectId(eobj.CTCOULastUpdateUser) 	//系统最新更新人
		s:eobj.CTCOUPYCode="" eobj.CTCOUPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.CTCOUDesc)
		s obj.CTCOUPYCode=eobj.CTCOUPYCode		//拼音码
		s:eobj.CTCOUWBCode="" eobj.CTCOUWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.CTCOUDesc,1)
		s obj.CTCOUWBCode=eobj.CTCOUWBCode		//五笔码
		s obj.CTCOUMark=eobj.CTCOUMark		//备注
        
        Tstart
        s sc=obj.%Save()
        do obj.%Close()
        if $$$ISOK(sc){
            Tcommit
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"
            d:eobj.CTCOURowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Country","User.CTCountry","国籍/地区",id,eobj.CTCOUDesc,"A",eobj)
            d:eobj.CTCOURowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Country","User.CTCountry","国籍/地区",id,eobj.CTCOUDesc,"U",eobj,bobj)
            
			//同时修改语言
			if (eobj.CTCOULanguageDR'="")
			{
				s teobj = ##class(web.Entity.CT.HOSCountryLinkLan).%New()
			    s teobj.CLLLANCode=eobj.CTCOULanguageDR			// 语言
			    s teobj.CLLCountryCode=id	//国家
				s teobj.CLLIsDefault="Y"			// 默认
				
				d ##class(web.DHCBL.CT.HOSCountryLinkLan).SaveEntity(teobj)
			}
			
			//如果修改时去掉已有的默认语言，关联语言的默认勾选去掉
			if (eobj.CTCOURowId'="")&&(eobj.CTCOULanguageDR="")&&(bobj.CTCOULanguageDR'="")
			{
				s ID=$o(^CT.BDP.CT.HOSCountryLinkLanI("IndexCountryLAN",id,bobj.CTCOULanguageDR,0))
				if (ID'="")
				{
					s tobj=##class(CT.BDP.CT.HOSCountryLinkLan).%OpenId(ID)
					s tobj.CLLIsDefault=""
					s tsc=tobj.%Save()
					d tobj.%Close()
				}
			}
			
        }else{
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("国籍/地区","web.DHCBL.CT.CTCountry","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
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
    
    s CTRGRowId=0,flag=0
    for
    {
        s CTRGRowId=$o(^CT("RG",CTRGRowId)) q:(CTRGRowId="")||(flag=1)
        s CTRGCountryDR=$p($g(^CT("RG",CTRGRowId)),"^",4)
        i CTRGCountryDR=id
        {
            s flag=1
            s myInfo=myInfo_"<区域>"
        }
    }
    
    s INAGRowId=0,flag=0
    for
    {
        s INAGRowId=$o(^CT("INAG",INAGRowId)) q:(INAGRowId="")||(flag=1)
        s INAGCountryDR=$p($g(^CT("INAG",INAGRowId)),"^",3)
        i INAGCountryDR=id
        {
            s flag=1
            s myInfo=myInfo_"<国际协定>"
        }
    }
    if $d(^CT.BDP.CT.HOSOrganizationI("IndexCountryCode",id)){
        s myInfo=myInfo_"<组织机构树>"
    }
    if $d(^CT.BDP.CT.HOSCountryLinkLanI("IndexCountryCode",id)){
        s myInfo=myInfo_"<国家关联语言>"
    }
    if $d(^CT.BDP.CT.HOSPersonI("IndexNationalityCode",id)){
        s myInfo=myInfo_"<组织人员>"
    }
    if $d(^CT.BDP.CT.HOSPersonI("IndexNPCountryCode",id)){
        s myInfo=myInfo_"<组织人员>"
    }
    if $d(^CT.BDP.CT.HOSPersonI("IndexAddrCountryCode",id)){
        s myInfo=myInfo_"<组织人员>"
    }
    
    
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    q return
}

/// Creator:陈莹
/// CreatDate:2012-9-10
/// Description:根据id删除 国籍/地区
/// Table:User.CTCountry
/// Input:id(CTCountry的CTCOURowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.CTCountry).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    
    s re=##class(web.DHCBL.CT.CTCountry).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
        
    s pobj = ##class(User.CTCountry).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTCountry).%New()
    s eobj.CTCOURowId = id
    s eobj.CTCOUCode = pobj.CTCOUCode
    s eobj.CTCOUDesc = pobj.CTCOUDesc
    s eobj.CTCOUActive = pobj.CTCOUActive
    //s:pobj.CTCOUActive="Y" eobj.CTCOUActive="true"
    s eobj.CTCOUDateActiveFrom =pobj.CTCOUDateActiveFrom
    s eobj.CTCOUDateActiveTo = pobj.CTCOUDateActiveTo
    //s:pobj.CTCOUDateActiveFrom'="" eobj.CTCOUDateActiveFrom =$zd(pobj.CTCOUDateActiveFrom,1)
    //s:pobj.CTCOUDateActiveTo'="" eobj.CTCOUDateActiveTo = $zd(pobj.CTCOUDateActiveTo,1)
    s:pobj.CTCOULanguageDR'="" eobj.CTCOULanguageDR = pobj.CTCOULanguageDR.%Id()
    
    s eobj.CTCOUENGShortDesc = pobj.CTCOUENGShortDesc	//英文简称
    s eobj.CTCOUCHNFullDesc = pobj.CTCOUCHNFullDesc		//中文全称
    s eobj.CTCOUENGFullDesc = pobj.CTCOUENGFullDesc		//英文全称
    s eobj.CTCOURomanCode2 = pobj.CTCOURomanCode2		//罗马2字符代码
    s eobj.CTCOURomanCode3 = pobj.CTCOURomanCode3		//罗马3字符代码
    
	s eobj.CTCOUSeqNo=pobj.CTCOUSeqNo		//系统排序号
	s eobj.CTCOUPYCode=pobj.CTCOUPYCode		//拼音码
	s eobj.CTCOUWBCode=pobj.CTCOUWBCode		//五笔码
	s eobj.CTCOUMark=pobj.CTCOUMark		//备注
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(User.CTCountry).%DeleteId(id)
    if $$$ISOK(sc){
        Tcommit
        s result="{success:'true',info:'删除成功！'}"
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Country","User.CTCountry","国籍/地区",id,eobj.CTCOUDesc,"D",eobj)
    }
    else{
        Trollback
        s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("国籍/地区","web.DHCBL.CT.CTCountry","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    
    q result
}

}
