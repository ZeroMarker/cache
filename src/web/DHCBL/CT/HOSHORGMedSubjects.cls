/// Function: HOS 医疗机构诊疗科目
/// CreateDate:2022-11-21
/// Creator:gaoshanshan
Class web.DHCBL.CT.HOSHORGMedSubjects Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  医疗机构诊疗科目信息查询
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-21
/// Table：     CT_BDP_CT.HOS_HORGMedSubjects   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSHORGMedSubjects","GetList","","","")
Query GetList(rowid As %String, code As %String) As %Query(ROWSPEC = "ID,HORGMSORGDesc,HORGMSMSUBDesc,HORGMSMSPECDesc,HORGMSMSPECIDesc,HORGMSSource,HORGMSActivity,HORGMSStartDate,HORGMSEndDate,HORGMSSeqNo,HORGMSPYCode,HORGMSWBCode,HORGMSMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s HORGMSORGDesc=""
        s HORGMSORGCode=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),2)	//医疗机构代码
        s:HORGMSORGCode'="" HORGMSORGDesc=$p($g(^CT("RFC",HORGMSORGCode)),"^",2)
		s HORGMSMSUBDesc="",HORGMSMSPECDesc="",HORGMSMSPECIDesc=""
		s HORGMSMSUBCode = $listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),4) 	//一级诊疗科目-外键
		s:HORGMSMSUBCode'="" HORGMSMSUBDesc=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(HORGMSMSUBCode)),3)
		s HORGMSMSPECCode = $listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),5) 	//二级诊疗科目-外键
		s:HORGMSMSPECCode'="" HORGMSMSPECDesc=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(HORGMSMSPECCode)),3)
		s HORGMSMSPECICode = $listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),6) 	//三级诊疗科目-外键
		s:HORGMSMSPECICode'="" HORGMSMSPECIDesc=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(HORGMSMSPECICode)),3)
		s HORGMSSource=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),7) 		//分类来源
		s HORGMSActivity=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),8) 	//是否有效(Y/N)
		s HORGMSStartDate=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),9) 		//开始日期
		s:HORGMSStartDate'="" HORGMSStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HORGMSStartDate) 
		s HORGMSEndDate=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),10) 		//结束日期
		s:HORGMSEndDate'="" HORGMSEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HORGMSEndDate) 
		s HORGMSSeqNo=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),14) 		//系统排序号
		s HORGMSPYCode=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),18) 		//拼音码
		s HORGMSWBCode=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),19) 		//五笔码
		s HORGMSMark=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),20) 		//备注
	
        d OutputRow
    }
    else
    {   
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSHORGMedSubjectsD(ID))
            q:ID="" 
	        s HORGMSORGDesc=""
	        s HORGMSORGCode=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),2)	//医疗机构代码
	        s:HORGMSORGCode'="" HORGMSORGDesc=$p($g(^CT("RFC",HORGMSORGCode)),"^",2)
			s HORGMSMSUBDesc="",HORGMSMSPECDesc="",HORGMSMSPECIDesc=""
			s HORGMSMSUBCode = $listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),4) 	//一级诊疗科目-外键
			s:HORGMSMSUBCode'="" HORGMSMSUBDesc=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(HORGMSMSUBCode)),3)
			s HORGMSMSPECCode = $listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),5) 	//二级诊疗科目-外键
			s:HORGMSMSPECCode'="" HORGMSMSPECDesc=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(HORGMSMSPECCode)),3)
			s HORGMSMSPECICode = $listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),6) 	//三级诊疗科目-外键
			s:HORGMSMSPECICode'="" HORGMSMSPECIDesc=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(HORGMSMSPECICode)),3)
			s HORGMSSource=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),7) 		//分类来源
			s HORGMSActivity=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),8) 	//是否有效(Y/N)
			s HORGMSStartDate=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),9) 		//开始日期
			s:HORGMSStartDate'="" HORGMSStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HORGMSStartDate) 
			s HORGMSEndDate=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),10) 		//结束日期
			s:HORGMSEndDate'="" HORGMSEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HORGMSEndDate) 
			s HORGMSSeqNo=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),14) 		//系统排序号
			s HORGMSPYCode=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),18) 		//拼音码
			s HORGMSWBCode=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),19) 		//五笔码
			s HORGMSMark=$listget($g(^CT.BDP.CT.HOSHORGMedSubjectsD(ID)),20) 		//备注
		
            if ((HORGMSORGCode=code)||(code=""))
            {
                d OutputRow
            }  
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,HORGMSORGDesc,HORGMSMSUBDesc,HORGMSMSPECDesc,HORGMSMSPECIDesc,HORGMSSource,HORGMSActivity,HORGMSStartDate,HORGMSEndDate,HORGMSSeqNo,HORGMSPYCode,HORGMSWBCode,HORGMSMark)
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

/// Function： 修改时打开的数据
/// Creator:   gaoshanshan
/// CreatDate: 2022-11-21
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.HOSHORGMedSubjects).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSHORGMedSubjects).%New()
    s pobj = ##class(CT.BDP.CT.HOSHORGMedSubjects).%OpenId(id)
    s eobj.ID=id
    s:$IsObject(pobj.HORGMSORGCode) eobj.HORGMSORGCode = pobj.HORGMSORGCode.%Id() //医疗机构代码
    s:$IsObject(pobj.HORGMSMSUBCode) eobj.HORGMSMSUBCode = pobj.HORGMSMSUBCode.%Id() 	//一级诊疗科目-外键 
    s:$IsObject(pobj.HORGMSMSPECCode) eobj.HORGMSMSPECCode = pobj.HORGMSMSPECCode.%Id() 	//二级诊疗科目-外键 
    s:$IsObject(pobj.HORGMSMSPECICode) eobj.HORGMSMSPECICode = pobj.HORGMSMSPECICode.%Id() 	//三级诊疗科目-外键 
	s eobj.HORGMSSource=pobj.HORGMSSource		//分类来源
	s eobj.HORGMSActivity=pobj.HORGMSActivity	//是否有效(Y/N)
	s eobj.HORGMSStartDate=pobj.HORGMSStartDate		//开始日期
	s:eobj.HORGMSStartDate'="" eobj.HORGMSStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.HORGMSStartDate) 
	s eobj.HORGMSEndDate=pobj.HORGMSEndDate		//结束日期
	s:eobj.HORGMSEndDate'="" eobj.HORGMSEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.HORGMSEndDate) 
	s eobj.HORGMSSeqNo=pobj.HORGMSSeqNo		//系统排序号
	s eobj.HORGMSPYCode=pobj.HORGMSPYCode		//拼音码
	s eobj.HORGMSWBCode=pobj.HORGMSWBCode		//五笔码
	s eobj.HORGMSMark=pobj.HORGMSMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  gaoshanshan
/// CreatDate:2022-11-21
/// Table：   CT.BDP.CT.HOSHORGMedSubjects
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSHORGMedSubjects).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String) As %String
{
    s flag=0
    if ((code'=""))
    {
	    s idc=$o(^CT.BDP.CT.HOSHORGMedSubjectsI("IndexORGCode",code,0))
	    if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
    }
    
    q flag
}

/// Function    保存医疗机构诊疗科目内容
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-21
/// Table：     CT.BDP.CT.HOSHORGMedSubjects
/// Input：     web.Entity.CT.HOSHORGMedSubjects  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSHORGMedSubjects).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSHORGMedSubjects) As %String
{
 
    s result="" 
    s UserID=""
    s:$d(%session) UserID=$g(%session.Data("LOGON.USERID"))  
     
    s:eobj.HORGMSStartDate'="" eobj.HORGMSStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HORGMSStartDate) 
    s:eobj.HORGMSEndDate'="" eobj.HORGMSEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HORGMSEndDate)
    s:eobj.HORGMSStartDate="" eobj.HORGMSStartDate=+$h
    
    s:eobj.HORGMSLastUpdateDate="" eobj.HORGMSLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.HORGMSLastUpdateTime="" eobj.HORGMSLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.HORGMSLastUpdateUser="" eobj.HORGMSLastUpdateUser=UserID	//系统最新更新人
    s:eobj.HORGMSActivity="" eobj.HORGMSActivity="N"		//是否有效
   
    
    s flag=  ..FormValidate(eobj.ID,eobj.HORGMSORGCode)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSHORGMedSubjects).%New()
            s:eobj.HORGMSCreateDate="" eobj.HORGMSCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.HORGMSCreateTime="" eobj.HORGMSCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.HORGMSCreateUser="" eobj.HORGMSCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.HORGMSCreateDate=eobj.HORGMSCreateDate		//系统创建日期
			s obj.HORGMSCreateTime=eobj.HORGMSCreateTime		//系统创建时间
			d obj.HORGMSCreateUserSetObjectId(eobj.HORGMSCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSHORGMedSubjects).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSHORGMedSubjects).%New()
            s bobj.ID=eobj.ID 
            s:$IsObject(obj.HORGMSORGCode) bobj.HORGMSORGCode = obj.HORGMSORGCode.%Id() //医疗机构代码	
            s:$IsObject(obj.HORGMSMSUBCode) bobj.HORGMSMSUBCode = obj.HORGMSMSUBCode.%Id() 	//一级诊疗科目-外键
            s:$IsObject(obj.HORGMSMSPECCode) bobj.HORGMSMSPECCode = obj.HORGMSMSPECCode.%Id() 	//二级诊疗科目-外键
            s:$IsObject(obj.HORGMSMSPECICode) bobj.HORGMSMSPECICode = obj.HORGMSMSPECICode.%Id() 	//三级诊疗科目-外键
			s bobj.HORGMSSource=obj.HORGMSSource		//分类来源
			s bobj.HORGMSActivity=obj.HORGMSActivity	//是否有效(Y/N)
			s bobj.HORGMSStartDate=obj.HORGMSStartDate		//开始日期
			s bobj.HORGMSEndDate=obj.HORGMSEndDate		//结束日期
			s bobj.HORGMSCreateDate=obj.HORGMSCreateDate		//系统创建日期
			s bobj.HORGMSCreateTime=obj.HORGMSCreateTime		//系统创建时间
			s:$IsObject(obj.HORGMSCreateUser) bobj.HORGMSCreateUser = obj.HORGMSCreateUser.%Id() 	//系统创建人
			s bobj.HORGMSSeqNo=obj.HORGMSSeqNo		//系统排序号
			s bobj.HORGMSLastUpdateDate=obj.HORGMSLastUpdateDate		//系统最后更新日期
			s bobj.HORGMSLastUpdateTime=obj.HORGMSLastUpdateTime		//系统最后更新时间
			s:$IsObject(obj.HORGMSLastUpdateUser) bobj.HORGMSLastUpdateUser = obj.HORGMSLastUpdateUser.%Id() 	//系统最新更新人
			s bobj.HORGMSPYCode=obj.HORGMSPYCode		//拼音码
			s bobj.HORGMSWBCode=obj.HORGMSWBCode		//五笔码
			s bobj.HORGMSMark=obj.HORGMSMark		//备注

        }
        
        d obj.HORGMSORGCodeSetObjectId(eobj.HORGMSORGCode) //医疗机构代码
        d obj.HORGMSMSUBCodeSetObjectId(eobj.HORGMSMSUBCode)	//一级诊疗科目-外键
        d obj.HORGMSMSPECCodeSetObjectId(eobj.HORGMSMSPECCode)	//二级诊疗科目-外键
        d obj.HORGMSMSPECICodeSetObjectId(eobj.HORGMSMSPECICode)	//三级诊疗科目-外键
		s obj.HORGMSSource=eobj.HORGMSSource		//分类来源
		s obj.HORGMSActivity=eobj.HORGMSActivity	//是否有效(Y/N)
		s obj.HORGMSStartDate=eobj.HORGMSStartDate		//开始日期
		s obj.HORGMSEndDate=eobj.HORGMSEndDate		//结束日期
		s obj.HORGMSSeqNo=eobj.HORGMSSeqNo		//系统排序号
		s obj.HORGMSLastUpdateDate=eobj.HORGMSLastUpdateDate		//系统最后更新日期
		s obj.HORGMSLastUpdateTime=eobj.HORGMSLastUpdateTime		//系统最后更新时间
		d obj.HORGMSLastUpdateUserSetObjectId(eobj.HORGMSLastUpdateUser)	//系统最新更新人
		s obj.HORGMSPYCode=eobj.HORGMSPYCode		//拼音码
		s obj.HORGMSWBCode=eobj.HORGMSWBCode		//五笔码
		s obj.HORGMSMark=eobj.HORGMSMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_HORGMedSubjects","CT.BDP.CT.HOSHORGMedSubjects","医疗机构诊疗科目",id,eobj.HORGMSORGCode,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_HORGMedSubjects","CT.BDP.CT.HOSHORGMedSubjects","医疗机构诊疗科目",eobj.ID,eobj.HORGMSORGCode,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗机构诊疗科目","web.DHCBL.CT.HOSHORGMedSubjects","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-21
/// Description：根据ID删除医疗机构诊疗科目的内容
/// Table：CT.BDP.CT.HOSHORGMedSubjects
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSHORGMedSubjects).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSHORGMedSubjects).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSHORGMedSubjects).%New()
    s eobj.ID = id
	s:$IsObject(pobj.HORGMSORGCode) eobj.HORGMSORGCode = pobj.HORGMSORGCode.%Id() //医疗机构代码
    s:$IsObject(pobj.HORGMSMSUBCode) eobj.HORGMSMSUBCode = pobj.HORGMSMSUBCode.%Id() 	//一级诊疗科目-外键 
    s:$IsObject(pobj.HORGMSMSPECCode) eobj.HORGMSMSPECCode = pobj.HORGMSMSPECCode.%Id() 	//二级诊疗科目-外键 
    s:$IsObject(pobj.HORGMSMSPECICode) eobj.HORGMSMSPECICode = pobj.HORGMSMSPECICode.%Id() 	//三级诊疗科目-外键 
	s eobj.HORGMSSource=pobj.HORGMSSource		//分类来源
	s eobj.HORGMSActivity=pobj.HORGMSActivity	//是否有效(Y/N)
	s eobj.HORGMSStartDate=pobj.HORGMSStartDate		//开始日期
	s eobj.HORGMSEndDate=pobj.HORGMSEndDate		//结束日期
	s eobj.HORGMSCreateDate=pobj.HORGMSCreateDate		//系统创建日期
	s eobj.HORGMSCreateTime=pobj.HORGMSCreateTime		//系统创建时间
	s:$IsObject(pobj.HORGMSCreateUser) eobj.HORGMSCreateUser = pobj.HORGMSCreateUser.%Id() 	//系统创建人
	s eobj.HORGMSSeqNo=pobj.HORGMSSeqNo		//系统排序号
	s eobj.HORGMSLastUpdateDate=pobj.HORGMSLastUpdateDate		//系统最后更新日期
	s eobj.HORGMSLastUpdateTime=pobj.HORGMSLastUpdateTime		//系统最后更新时间
	s:$IsObject(pobj.HORGMSLastUpdateUser) eobj.HORGMSLastUpdateUser = pobj.HORGMSLastUpdateUser.%Id() 	//系统最新更新人
	s eobj.HORGMSPYCode=pobj.HORGMSPYCode		//拼音码
	s eobj.HORGMSWBCode=pobj.HORGMSWBCode		//五笔码
	s eobj.HORGMSMark=pobj.HORGMSMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSHORGMedSubjects).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_HORGMedSubjects","CT.BDP.CT.HOSHORGMedSubjects","医疗机构诊疗科目",id,eobj.HORGMSORGCode,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗机构诊疗科目","web.DHCBL.CT.HOSHORGMedSubjects","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

}
