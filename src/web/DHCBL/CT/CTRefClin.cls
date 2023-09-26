Import SQLUser

/// 名称:医疗机构方法类
/// 编写者：基础数据平台-sunfengchao
/// 创建日期: 2016-2-17
Class web.DHCBL.CT.CTRefClin Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2016-2-17
/// Description：查询医疗机构的内容
/// Table：User.CTRefClin
/// Input：rowid,code,desc,InternalType,query(用于combox查询)
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTRFCRowId,CTRFCCode,CTRFCDesc,CTRFCVEMD,CTRFCDateFrom,CTRFCDateTo,CTRFCActiveFlag,CTRFCCategoryCode,CTRFCLevel,CTRFCCityDR,CTRFCCityAreaDR,CTRFCAddress,CTRFCPersonName,CTRFCSociaCreditCode,CTRFCORGCode,CTRFCBusinessClicenseCode,CTRFCBusinessClicenseFrom,CTRFCBusinessClicenseTo,CTRFCBeds,CTRFCGradeCode,CTRFCChargeStandard,CTRFCInsuCode,CTRFCSeqNo,CTRFCPYCode,CTRFCWBCode,CTRFCMark,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.CTRefClin).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s CTRFCRowId=rowid
        s CTRFCCode=$p($g(^CT("RFC",CTRFCRowId)),"^",1)  //医疗机构编码
        s CTRFCDesc=$p($g(^CT("RFC",CTRFCRowId)),"^",2)  //医疗机构
        s CTRFCVEMD=$p($g(^CT("RFC",CTRFCRowId)),"^",4)
        s CTRFCDateFrom=$p($g(^CT("RFC",CTRFCRowId)),"^",5) //开始日期
        s CTRFCDateTo=$p($g(^CT("RFC",CTRFCRowId)),"^",6)  //结束日期
        s CTRFCActiveFlag=$p($g(^CT("RFC",CTRFCRowId)),"^",3)  //是否有效
        s:CTRFCDateFrom'="" CTRFCDateFrom=$zd(CTRFCDateFrom,1) //转换日期格式
        s:CTRFCDateTo'="" CTRFCDateTo=$zd(CTRFCDateTo,1) //转换日期格式
        s CTRFCCategoryCode =$p($g(^CT("RFC",CTRFCRowId)),"^",7)
        s CTRFCLevel=$p($g(^CT("RFC",CTRFCRowId)),"^",8)
        s CTRFCCityDR=$p($g(^CT("RFC",CTRFCRowId)),"^",9)
        s CTRFCCityAreaDR=$p($g(^CT("RFC",CTRFCRowId)),"^",10)
        s:CTRFCCityDR'="" CTRFCCityDR=$p($g(^CT("CIT",CTRFCCityDR)),"^",2)
        s:CTRFCCityAreaDR'="" CTRFCCityAreaDR=$p($g(^CT("CITAREA",CTRFCCityAreaDR)),"^",2)
        ///扩展表
        s CTRFCAddress=$p($g(^CT("RFC",CTRFCRowId,"EXT")),"^",1)			//医疗机构地址
        s CTRFCPersonName=$p($g(^CT("RFC",CTRFCRowId,"EXT")),"^",11)		//法人姓名
        s CTRFCSociaCreditCode=$p($g(^CT("RFC",CTRFCRowId,"EXT")),"^",17)	//社会信用代码
        
        s CTRFCORGCode=$p($g(^CT("RFC",CTRFCRowId)),"^",11)  ///组织机构id
		s:CTRFCORGCode'="" CTRFCORGCode=$lg($g(^CT.BDP.CT.HOSOrganizationD(CTRFCORGCode)),3) ///组织机构名称
		s CTRFCBusinessClicenseCode=$p($g(^CT("RFC",CTRFCRowId)),"^",12) /// 医疗机构执业许可证号
		s CTRFCBusinessClicenseFrom=$p($g(^CT("RFC",CTRFCRowId)),"^",13) ///医疗机构执业许可证效期开始日期
		s CTRFCBusinessClicenseTo=$p($g(^CT("RFC",CTRFCRowId)),"^",14) ///医疗机构执业许可证效期结束日期
		s:CTRFCBusinessClicenseFrom'="" CTRFCBusinessClicenseFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTRFCBusinessClicenseFrom)
		s:CTRFCBusinessClicenseTo'="" CTRFCBusinessClicenseTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTRFCBusinessClicenseTo)
		s CTRFCBeds=$p($g(^CT("RFC",CTRFCRowId)),"^",15) ///编制床位数
		s CTRFCGradeCode=$p($g(^CT("RFC",CTRFCRowId)),"^",16) ///医院等级代码
		s:CTRFCGradeCode'="" CTRFCGradeCode=$lg($g(^CT.BDP.CT.HOSHORGGradeD(CTRFCGradeCode)),3) ///医院等级代码
		s CTRFCChargeStandard=$p($g(^CT("RFC",CTRFCRowId)),"^",17) ///医院物价标准
		s CTRFCInsuCode=$p($g(^CT("RFC",CTRFCRowId)),"^",18) ///医院医保代码
		s CTRFCSeqNo=$p($g(^CT("RFC",CTRFCRowId)),"^",22) ///排序号	    
		s CTRFCPYCode=$p($g(^CT("RFC",CTRFCRowId)),"^",26) ///拼音码
		s CTRFCWBCode=$p($g(^CT("RFC",CTRFCRowId)),"^",27) ///五笔码
		s CTRFCMark=$p($g(^CT("RFC",CTRFCRowId)),"^",28) //////备注
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_RefClin",CTRFCRowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
        d OutputRow
    }
    else
    {
        s CTRFCRowId=0
        for  
        {   
            s CTRFCRowId=$o(^CT("RFC",CTRFCRowId)) q:CTRFCRowId=""
            s strRowId = "{ID:"_CTRFCRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s CTRFCCode=$p($g(^CT("RFC",CTRFCRowId)),"^",1)
                s CTRFCDesc=$p($g(^CT("RFC",CTRFCRowId)),"^",2)
                s CTRFCVEMD=$p($g(^CT("RFC",CTRFCRowId)),"^",4)
                s CTRFCDateFrom=$p($g(^CT("RFC",CTRFCRowId)),"^",5)
                s CTRFCDateTo=$p($g(^CT("RFC",CTRFCRowId)),"^",6)
                s CTRFCActiveFlag=$p($g(^CT("RFC",CTRFCRowId)),"^",3)
                s:CTRFCDateFrom'="" CTRFCDateFrom=$zd(CTRFCDateFrom,1) //转换日期格式
                s:CTRFCDateTo'="" CTRFCDateTo=$zd(CTRFCDateTo,1) //转换日期格式
                s CTRFCCategoryCode =$p($g(^CT("RFC",CTRFCRowId)),"^",7)
                s CTRFCLevel=$p($g(^CT("RFC",CTRFCRowId)),"^",8)
                s CTRFCCityDR=$p($g(^CT("RFC",CTRFCRowId)),"^",9)
                s CTRFCCityAreaDR=$p($g(^CT("RFC",CTRFCRowId)),"^",10)
                s:CTRFCCityDR'="" CTRFCCityDR=$p($g(^CT("CIT",CTRFCCityDR)),"^",2)
                s:CTRFCCityAreaDR'="" CTRFCCityAreaDR=$p($g(^CT("CITAREA",CTRFCCityAreaDR)),"^",2)
                s CTRFCAddress=$p($g(^CT("RFC",CTRFCRowId,"EXT")),"^",1)			//医疗机构地址
				s CTRFCPersonName=$p($g(^CT("RFC",CTRFCRowId,"EXT")),"^",11)		//法人姓名
				s CTRFCSociaCreditCode=$p($g(^CT("RFC",CTRFCRowId,"EXT")),"^",17)	//社会信用代码
				
				s CTRFCORGCode=$p($g(^CT("RFC",CTRFCRowId)),"^",11)  ///组织机构id
				s:CTRFCORGCode'="" CTRFCORGCode=$lg($g(^CT.BDP.CT.HOSOrganizationD(CTRFCORGCode)),3) ///组织机构名称
				s CTRFCBusinessClicenseCode=$p($g(^CT("RFC",CTRFCRowId)),"^",12) /// 医疗机构执业许可证号
				s CTRFCBusinessClicenseFrom=$p($g(^CT("RFC",CTRFCRowId)),"^",13) ///医疗机构执业许可证效期开始日期
				s CTRFCBusinessClicenseTo=$p($g(^CT("RFC",CTRFCRowId)),"^",14) ///医疗机构执业许可证效期结束日期
				s:CTRFCBusinessClicenseFrom'="" CTRFCBusinessClicenseFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTRFCBusinessClicenseFrom)
				s:CTRFCBusinessClicenseTo'="" CTRFCBusinessClicenseTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTRFCBusinessClicenseTo)
				s CTRFCBeds=$p($g(^CT("RFC",CTRFCRowId)),"^",15) ///编制床位数
				s CTRFCGradeCode=$p($g(^CT("RFC",CTRFCRowId)),"^",16) ///医院等级代码
				s:CTRFCGradeCode'="" CTRFCGradeCode=$lg($g(^CT.BDP.CT.HOSHORGGradeD(CTRFCGradeCode)),3) ///医院等级代码
				s CTRFCChargeStandard=$p($g(^CT("RFC",CTRFCRowId)),"^",17) ///医院物价标准
				s CTRFCInsuCode=$p($g(^CT("RFC",CTRFCRowId)),"^",18) ///医院医保代码
				s CTRFCSeqNo=$p($g(^CT("RFC",CTRFCRowId)),"^",22) ///排序号	    
				s CTRFCPYCode=$p($g(^CT("RFC",CTRFCRowId)),"^",26) ///拼音码
				s CTRFCWBCode=$p($g(^CT("RFC",CTRFCRowId)),"^",27) ///五笔码
				s CTRFCMark=$p($g(^CT("RFC",CTRFCRowId)),"^",28) //////备注
		
                s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
                s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_RefClin",CTRFCRowId)
                s BDPInternalCode =$p($g(resultStr),"^",1)       
                s BDPInternalDesc = $p($g(resultStr),"^",2)  
                s BDPHospNationalCode=$p($g(resultStr),"^",3)         
                s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_RefClin",CTRFCRowId,CTRFCDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                }  
                if ($ZCONVERT(CTRFCCode,"U")[code) &(AliasFlag=1)               
                { 
                    d OutputRow 
                }
            }
        }
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(CTRFCRowId,CTRFCCode,CTRFCDesc,CTRFCVEMD,CTRFCDateFrom,CTRFCDateTo,CTRFCActiveFlag,CTRFCCategoryCode,CTRFCLevel,CTRFCCityDR,CTRFCCityAreaDR,CTRFCAddress,CTRFCPersonName,CTRFCSociaCreditCode,CTRFCORGCode,CTRFCBusinessClicenseCode,CTRFCBusinessClicenseFrom,CTRFCBusinessClicenseTo,CTRFCBeds,CTRFCGradeCode,CTRFCChargeStandard,CTRFCInsuCode,CTRFCSeqNo,CTRFCPYCode,CTRFCWBCode,CTRFCMark,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，为combo查询提供接口
/// CreateDate:2016-2-17
/// Creator:基础数据平台公共产品组  sunfengchao 
/// Table:User.CTRefClin
/// Input: rowid, code 
/// Output:  RNAV_RowId,RNAV_Code,RNAV_Desc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTRefClin", "GetDataForCmb1","")
/// 获取医疗机构信息
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, active As %String, communityid As %String) As %Query(ROWSPEC = "CTRFCRowId,CTRFCCode,CTRFCDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, active As %String, communityid As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.CTRefClin).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s CTRFCRowId=rowid
        s CTRFCCode=$p($g(^CT("RFC",CTRFCRowId)),"^",1)
        s CTRFCDesc=$p($g(^CT("RFC",CTRFCRowId)),"^",2)
        d OutputRow1
    }
    else
    {
        s AuFlag=0
        if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
        s CTRFCRowId=0
        for  
        {   
            s CTRFCRowId=$o(^CT("RFC",CTRFCRowId)) q:CTRFCRowId=""
            s strRowId = "{ID:"_CTRFCRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s CTRFCCode=$p($g(^CT("RFC",CTRFCRowId)),"^",1)
                s CTRFCDesc=$p($g(^CT("RFC",CTRFCRowId)),"^",2)
                s CTRFCDateFrom=$p($g(^CT("RFC",CTRFCRowId)),"^",5)
                s CTRFCDateTo=$p($g(^CT("RFC",CTRFCRowId)),"^",6)
                s CTRFCActiveFlag=$p($g(^CT("RFC",CTRFCRowId)),"^",3)
                continue:CTRFCActiveFlag="N"
                continue:(CTRFCDateFrom'="")&&(CTRFCDateFrom>+$h)
                continue:(CTRFCDateTo'="")&&(CTRFCDateTo<+$h)
                /*s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_RefClin",CTRFCRowId,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                }
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTRFCDesc)

                i ($$ALPHAUP^SSUTIL4(CTRFCCode)[code)&(($$ALPHAUP^SSUTIL4(CTRFCDesc)[desc)||(ALIASText1[desc)||(PINYIN[desc))*/
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_RefClin",CTRFCRowId,CTRFCDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                }  
                if ($ZCONVERT(CTRFCCode,"U")[code) &(AliasFlag=1)                   
                {

                    d OutputRow1

                }
            }
        }
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow1
    set Data=$lb(CTRFCRowId,CTRFCCode,CTRFCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator：sunfengchao
/// CreatDate: 2016-2-17
/// Description：根据ID医疗机构内容
/// Table：User.CTRefClin
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
    s result = ""
    s re=..GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	s reason=$p(re,"^",2)
	if (RefFlag=0)
	{
        Ts
        s pobj = ##class(User.CTRefClin).%OpenId(id)
        s eobj = ##class(web.Entity.CT.CTRefClin).%New()
        s eobj.CTRFCRowId = id
        s eobj.CTRFCCode=pobj.CTRFCCode
        s eobj.CTRFCDesc = pobj.CTRFCDesc
        s eobj.CTRFCDateFrom= pobj.CTRFCDateFrom
        s eobj.CTRFCDateTo= pobj.CTRFCDateTo
        S eobj.CTRFCActiveFlag= pobj.CTRFCActiveFlag
        s eobj.CTRFCCategoryCode=pobj.CTRFCCategoryCode
        s eobj.CTRFCLevel=pobj.CTRFCLevel
        s:pobj.CTRFCCityDR'="" eobj.CTRFCCityDR=pobj.CTRFCCityDR.%Id()
        s:pobj.CTRFCCityAreaDR'="" eobj.CTRFCCityAreaDR=pobj.CTRFCCityAreaDR.%Id() 
        if $IsObject(pobj.CTRFCORGCode)
		{
			s eobj.CTRFCORGCode = pobj.CTRFCORGCode.%Id()   //组织机构-外键
		}
		s eobj.CTRFCBusinessClicenseCode=pobj.CTRFCBusinessClicenseCode ///医疗机构执业许可证号
		s eobj.CTRFCBusinessClicenseFrom=pobj.CTRFCBusinessClicenseFrom ///医疗机构执业许可证效期开始日期
		s eobj.CTRFCBusinessClicenseTo=pobj.CTRFCBusinessClicenseTo ///医疗机构执业许可证效期结束日期
		s eobj.CTRFCBeds=pobj.CTRFCBeds ///编制床位数
		s eobj.CTRFCGradeCode=pobj.CTRFCGradeCode ///医院等级代码
		s eobj.CTRFCChargeStandard=pobj.CTRFCChargeStandard ///医院物价标准
		if $IsObject(pobj.CTRFCInsuCode)
		{
			s eobj.CTRFCInsuCode = pobj.CTRFCInsuCode.%Id()   ///医院医保代码
		}
		s eobj.CTRFCCreateDate=pobj.CTRFCCreateDate ///系统创建日期
		s eobj.CTRFCCreateTime=pobj.CTRFCCreateTime ///系统创建时间
		if $IsObject(pobj.CTRFCCreateUser)
		{   
			s eobj.CTRFCCreateUser = pobj.CTRFCCreateUser.%Id()   ///系统创建人
		}
		s eobj.CTRFCSeqNo=pobj.CTRFCSeqNo ///排序号
		s eobj.CTRFCLastUpdateDate=pobj.CTRFCLastUpdateDate ///系统最后更新日期
		s eobj.CTRFCLastUpdateTime=pobj.CTRFCLastUpdateTime ///系统最后更新时间
		if $IsObject(pobj.CTRFCLastUpdateUser)
		{   
			s eobj.CTRFCLastUpdateUser = pobj.CTRFCLastUpdateUser.%Id()   ///系统最新更新人
		}
		s eobj.CTRFCPYCode=pobj.CTRFCPYCode ///拼音码
		s eobj.CTRFCWBCode=pobj.CTRFCWBCode ///五笔码
		s eobj.CTRFCMark=pobj.CTRFCMark ///备注
        s sc=##class(User.CTRefClin).%DeleteId(id)
        if $$$ISOK(sc)
        {
            tc
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_RefClin","User.CTRefClin","医疗机构",id,eobj.CTRFCDesc,"D",eobj)
            s result = "{success:'true',info:'删除成功！'}"
        }
        else
        {
            tro
            s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗机构","web.DHCBL.CT.CTRefClin","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
	}
    else
	{
		s result= "{success:'false',info:'"_reason_"'}"	
	}
    q result
}

/// Function:双击时显示弹出窗口的信息
/// CreateDate:2016-2-17
/// Creator:基础数据平台公共产品组 sunfengchao
/// Input:输入sid
/// Table:User.CTRefClin
ClassMethod OpenData(id As %String) As %String
{
    s str=""
    s pobj = ##class(User.CTRefClin).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTRefClin).%New()
    s eobj.CTRFCRowId=id
    s eobj.CTRFCCode = pobj.CTRFCCode
    s eobj.CTRFCDesc = pobj.CTRFCDesc
    s eobj.CTRFCVEMD=pobj.CTRFCVEMD 
    //s eobj.CTRFCActiveFlag = pobj.CTRFCActiveFlag  //radio
    s:pobj.CTRFCActiveFlag="Y" eobj.CTRFCActiveFlag="true" // checkox
    s eobj.CTRFCDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTRFCDateFrom)
    s eobj.CTRFCDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTRFCDateTo)
    s eobj.CTRFCCategoryCode=pobj.CTRFCCategoryCode
    s eobj.CTRFCLevel=pobj.CTRFCLevel
    s:pobj.CTRFCCityDR'="" eobj.CTRFCCityDR=pobj.CTRFCCityDR.%Id()
    s:pobj.CTRFCCityAreaDR'="" eobj.CTRFCCityAreaDR=pobj.CTRFCCityAreaDR.%Id() 
    
    if $IsObject(pobj.CTRFCORGCode)
	{
		s eobj.CTRFCORGCode = pobj.CTRFCORGCode.%Id()   //组织机构-外键
	}
	s eobj.CTRFCBusinessClicenseCode=pobj.CTRFCBusinessClicenseCode ///医疗机构执业许可证号
	s eobj.CTRFCBusinessClicenseFrom=pobj.CTRFCBusinessClicenseFrom ///医疗机构执业许可证效期开始日期
	s eobj.CTRFCBusinessClicenseTo=pobj.CTRFCBusinessClicenseTo ///医疗机构执业许可证效期结束日期
	s:eobj.CTRFCBusinessClicenseFrom'="" eobj.CTRFCBusinessClicenseFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTRFCBusinessClicenseFrom)
	s:eobj.CTRFCBusinessClicenseTo'="" eobj.CTRFCBusinessClicenseTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTRFCBusinessClicenseTo)
	s eobj.CTRFCBeds=pobj.CTRFCBeds ///编制床位数
	if $IsObject(pobj.CTRFCGradeCode)
	{
		s eobj.CTRFCGradeCode = pobj.CTRFCGradeCode.%Id()  ///医院等级代码
	}
	s eobj.CTRFCChargeStandard=pobj.CTRFCChargeStandard ///医院物价标准
	s eobj.CTRFCInsuCode=pobj.CTRFCInsuCode ///医院医保代码
	s eobj.CTRFCSeqNo=pobj.CTRFCSeqNo ///排序号
	s eobj.CTRFCPYCode=pobj.CTRFCPYCode ///拼音码
	s eobj.CTRFCWBCode=pobj.CTRFCWBCode ///五笔码
	s eobj.CTRFCMark=pobj.CTRFCMark ///备注
    d pobj.%Close()
    k pobj
    
    //子表三个信息
    s obj = ##class(User.CTRefClinExtend).%OpenId(id)
	s eobj.CTRFCAddress=obj.CTRFCAddress
	s eobj.CTRFCPersonName=obj.CTRFCPersonName
	s eobj.CTRFCSociaCreditCode=obj.CTRFCSociaCreditCode
   
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 sunfengchao 
/// CreateDate:2016-2-17
/// Table:CT_RefClin    
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	if $$ALPHAUP^SSUTIL4(code)'=""
	{
		s idc=$o(^CT("RFC",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
		if (idc'="")&&(idc'=id)
		{
			s flag=1  //返回重复标志
		}
	}
	if $$ALPHAUP^SSUTIL4(desc)'=""
	{
		s idd=$o(^CT("RFC",0,"Desc",$$ALPHAUP^SSUTIL4(desc),0))
		if (idd'="")&&(idd'=id)
		{
			s flag=1  //返回重复标志
		}
	}
	q flag
}

/// Creator：sunfengchao
/// CreatDate: 2016-2-17
/// Description：保存医疗机构信息
/// Table：User.CTRefClin
/// Input：Entity
ClassMethod SaveEntity(eobj As web.Entity.CT.CTRefClin) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.CTRFCDateFrom'="" eobj.CTRFCDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTRFCDateFrom)
		s:eobj.CTRFCDateTo'="" eobj.CTRFCDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTRFCDateTo)
		s:eobj.CTRFCDateFrom="" eobj.CTRFCDateFrom=+$h
		s:eobj.CTRFCActiveFlag="" eobj.CTRFCActiveFlag ="N"
		s eobj.CTRFCLastUpdateDate=+$H               ///系统最后更新日期
		s eobj.CTRFCLastUpdateTime=$p($h,",",2)       ///系统最后更新时间

		if (eobj.CTRFCRowId="")  //新增
		{
			s eobj.CTRFCCreateDate=+$H           ///系统创建日期
			s eobj.CTRFCCreateTime=$p($h,",",2)  ///系统创建时间
		}
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID")) 
			if (eobj.CTRFCCreateUser="")&&(eobj.CTRFCRowId="") s eobj.CTRFCCreateUser=USERID   ///系统创建人
			if (eobj.CTRFCLastUpdateUser="") s eobj.CTRFCLastUpdateUser=USERID  ///系统最新更新人
		}
		s flag=..FormValidate(eobj.CTRFCRowId,eobj.CTRFCCode,eobj.CTRFCDesc)  //调用重复验证
		if (flag=1)
		{  
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.CTRFCRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.CTRefClin).%New()
				s obj.CTRFCCreateDate=eobj.CTRFCCreateDate         ///系统创建日期
				s obj.CTRFCCreateTime=eobj.CTRFCCreateTime  ///系统创建时间
				d obj.CTRFCCreateUserSetObjectId(eobj.CTRFCLastUpdateUser)  ///系统创建人
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.CTRefClin).%OpenId(eobj.CTRFCRowId)
				s bobj=##class(web.Entity.CT.CTRefClin).%New()
				s bobj.CTRFCRowId=eobj.CTRFCRowId
				s bobj.CTRFCCode = obj.CTRFCCode          //修改代码
				s bobj.CTRFCDesc = obj.CTRFCDesc          //修改描述
				s bobj.CTRFCActiveFlag=obj.CTRFCActiveFlag
				s bobj.CTRFCVEMD=obj.CTRFCVEMD
				s bobj.CTRFCDateFrom = obj.CTRFCDateFrom  //修改开始日期
				s bobj.CTRFCDateTo = obj.CTRFCDateTo      //修改结束日期   
				if $IsObject(obj.CTRFCORGCode)
				{
					s bobj.CTRFCORGCode = obj.CTRFCORGCode.%Id()   //组织机构-外键
				}
				s bobj.CTRFCBusinessClicenseCode=obj.CTRFCBusinessClicenseCode ///医疗机构执业许可证号
				s bobj.CTRFCBusinessClicenseFrom=obj.CTRFCBusinessClicenseFrom ///医疗机构执业许可证效期开始日期
				s bobj.CTRFCBusinessClicenseTo=obj.CTRFCBusinessClicenseTo ///医疗机构执业许可证效期结束日期
				s bobj.CTRFCBeds=obj.CTRFCBeds ///编制床位数
				if $IsObject(obj.CTRFCGradeCode)
				{
					s bobj.CTRFCGradeCode = obj.CTRFCGradeCode.%Id()   ///医院等级代码
				}
				s bobj.CTRFCChargeStandard=obj.CTRFCChargeStandard ///医院物价标准
				s bobj.CTRFCInsuCode=obj.CTRFCInsuCode ///医院医保代码
				s bobj.CTRFCCreateDate=obj.CTRFCCreateDate ///系统创建日期
				s bobj.CTRFCCreateTime=obj.CTRFCCreateTime ///系统创建时间
				if $IsObject(obj.CTRFCCreateUser)
				{   
					s bobj.CTRFCCreateUser = obj.CTRFCCreateUser.%Id()   ///系统创建人
				}
				s bobj.CTRFCSeqNo=obj.CTRFCSeqNo ///排序号
				s bobj.CTRFCLastUpdateDate=obj.CTRFCLastUpdateDate ///系统最后更新日期
				s bobj.CTRFCLastUpdateTime=obj.CTRFCLastUpdateTime ///系统最后更新时间
				if $IsObject(obj.CTRFCLastUpdateUser)
				{   
					s bobj.CTRFCLastUpdateUser = obj.CTRFCLastUpdateUser.%Id()   ///系统最新更新人
				}
				s bobj.CTRFCPYCode=obj.CTRFCPYCode ///拼音码
				s bobj.CTRFCWBCode=obj.CTRFCWBCode ///五笔码
				s bobj.CTRFCMark=obj.CTRFCMark ///备注
			}
			Tstart          
			s obj.CTRFCCode = eobj.CTRFCCode          //代码
			s obj.CTRFCDesc = eobj.CTRFCDesc          //描述
			s obj.CTRFCActiveFlag=eobj.CTRFCActiveFlag
			s obj.CTRFCVEMD=eobj.CTRFCVEMD
			s obj.CTRFCDateFrom = eobj.CTRFCDateFrom  //开始日期
			s obj.CTRFCDateTo = eobj.CTRFCDateTo      //结束日期 
			s obj.CTRFCCategoryCode=eobj.CTRFCCategoryCode
			s obj.CTRFCLevel=eobj.CTRFCLevel
			d obj.CTRFCCityDRSetObjectId(eobj.CTRFCCityDR)
			d obj.CTRFCCityAreaDRSetObjectId(eobj.CTRFCCityAreaDR)   
			d obj.CTRFCORGCodeSetObjectId(eobj.CTRFCORGCode) ///组织机构-外键
			s obj.CTRFCBusinessClicenseCode=eobj.CTRFCBusinessClicenseCode ///医疗机构执业许可证号
			s:eobj.CTRFCBusinessClicenseFrom'="" eobj.CTRFCBusinessClicenseFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTRFCBusinessClicenseFrom)
			s obj.CTRFCBusinessClicenseFrom=eobj.CTRFCBusinessClicenseFrom ///医疗机构执业许可证效期开始日期
			s:eobj.CTRFCBusinessClicenseTo'="" eobj.CTRFCBusinessClicenseTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTRFCBusinessClicenseTo)
			s obj.CTRFCBusinessClicenseTo=eobj.CTRFCBusinessClicenseTo ///医疗机构执业许可证效期结束日期
			s obj.CTRFCBeds=eobj.CTRFCBeds          ///编制床位数
			d obj.CTRFCGradeCodeSetObjectId(eobj.CTRFCGradeCode) ///医院等级代码
			s obj.CTRFCChargeStandard=eobj.CTRFCChargeStandard ///医院物价标准
			s obj.CTRFCInsuCode=eobj.CTRFCInsuCode        ///医院医保代码
			s obj.CTRFCSeqNo=eobj.CTRFCSeqNo              ///排序号
			s obj.CTRFCLastUpdateDate=eobj.CTRFCLastUpdateDate   ///系统最后更新日期
			s obj.CTRFCLastUpdateTime=eobj.CTRFCLastUpdateTime   ///系统最后更新时间
			d obj.CTRFCLastUpdateUserSetObjectId(eobj.CTRFCLastUpdateUser)  ///系统最新更新人
			s obj.CTRFCPYCode=eobj.CTRFCPYCode ///拼音码
			s obj.CTRFCWBCode=eobj.CTRFCWBCode ///五笔码
			s obj.CTRFCMark=eobj.CTRFCMark ///备注
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()

				//保存扩展表的地址、法人姓名、社会信用代码	2020-12-10
				s objExtend=##class(User.CTRefClinExtend).%OpenId(id)
				if (eobj.CTRFCRowId'="")
				{
					s objExtend=##class(User.CTRefClinExtend).%OpenId(eobj.CTRFCRowId)
					s bobj.CTRFCAddress=objExtend.CTRFCAddress
					s bobj.CTRFCPersonName=objExtend.CTRFCPersonName
					s bobj.CTRFCSociaCreditCode=objExtend.CTRFCSociaCreditCode
				}
				s objExtend.CTRFCAddress=eobj.CTRFCAddress
				s objExtend.CTRFCPersonName=eobj.CTRFCPersonName
				s objExtend.CTRFCSociaCreditCode=eobj.CTRFCSociaCreditCode
				s scExtend=objExtend.%Save()
				d objExtend.%Close()

				s result= "{success:'true',id:'"_id_"'}"         //返回RowId
				//保存日志
				d:eobj.CTRFCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_RefClin","User.CTRefClin","医疗机构",id,eobj.CTRFCDesc,"A",eobj)
				d:eobj.CTRFCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_RefClin","User.CTRefClin","医疗机构",eobj.CTRFCRowId,eobj.CTRFCDesc,"U",eobj,bobj)
				
			}
			else
			{
				Trollback
				s result= "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗机构","web.DHCBL.CT.CTRefClin","SaveEntity",eobj)
				s ^ERRORLOGINFO(+logid)=$zconvert(sc,"O","JS")
			}
		}
	}
	else
	{
		s result= "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-07-31
/// function：删除时验证数据是否被引用
/// Debug：w ##class(web.DHCBL.CT.CTRefClin).GetRefFlag(1)
ClassMethod GetRefFlag(id As %String) As %String
{
	s result="",myInfo=""
	//校验组织部门表User.CTDepartment
	s ID=0
	for 
	{
		s ID=$o(^User.CTDepartmentD(ID)) q:ID=""
		s DEPRefClinDR=$lg($g(^User.CTDepartmentD(ID)),9)	// 医疗机构DR
		if (DEPRefClinDR=id)
		{
			s myInfo=myInfo_"<组织部门表>"
			q
		}
	}
	
	if $d(^CT.BDP.CT.HOSHORGMedSubjectsI("IndexORGCode",id))
    {
	    s myInfo=myInfo_"<医疗机构诊疗科目>"
	}
	
	i myInfo="" s result="0^未被引用可删除！"
    else  s result="1^在"_myInfo_"表里被引用,不能删除！"
	
	q result
}

}
