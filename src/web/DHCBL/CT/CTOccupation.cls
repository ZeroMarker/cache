Import SQLUser

/// 名称: 职业维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-31
Class web.DHCBL.CT.CTOccupation Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.CTOccupation
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.CTOccupation).%New()
 s obj = ##class(User.CTOccupation).%OpenId(id)
 s eobj.CTOCCRowId = id
 s eobj.CTOCCCode=obj.CTOCCCode
 s eobj.CTOCCDesc=obj.CTOCCDesc
 s eobj.CTOCCDateFrom=obj.CTOCCDateFrom
 s eobj.CTOCCDateTo=obj.CTOCCDateTo
 if $IsObject(obj.OCCUOCCUCCode)
 {
	s eobj.OCCUOCCUCCode = obj.OCCUOCCUCCode.%Id()   //职业大类
 }
 s eobj.OCCUSCActivity=obj.OCCUSCActivity
 s:eobj.OCCUSCActivity="" eobj.OCCUSCActivity="Y"
 s:eobj.OCCUSCActivity="Y" eobj.OCCUSCActivity="true"
 s eobj.OCCUSCSeqNo=obj.OCCUSCSeqNo
 s eobj.OCCUSCPYCode=obj.OCCUSCPYCode
 s eobj.OCCUSCWBCode=obj.OCCUSCWBCode
 s eobj.OCCUSCMark=obj.OCCUSCMark
 s:eobj.CTOCCDateFrom'="" eobj.CTOCCDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTOCCDateFrom) //转换日期格式
 s:eobj.CTOCCDateTo'="" eobj.CTOCCDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTOCCDateTo)       //转换日期格式
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法，js调用
/// Table：User.CTOccupation
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("OCC",0,"Code",code))
 s:desc'="" flagd=$d(^CT("OCC",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("OCC",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("OCC",0,"Desc",desc,0))
  if (desc="")
  {
   if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
  elseif (code="")
  {
   if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-11-7
/// Description：数据重复验证方法
/// Table：User.CTOccupation
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("OCC",0,"Code",code))
 s:desc'="" flagd=$d(^CT("OCC",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("OCC",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("OCC",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022年11月14日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.CTOccupation).TestSave()
ClassMethod TestSave()
{
	s eobj=##class(web.Entity.CT.CTOccupation).%New()
	s eobj.CTOCCCode="792"
	s eobj.CTOCCDesc="测试3"
	
	w ..SaveEntity(eobj)
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：保存修改职业的内容
/// Table：User.CTOccupation
/// Input：web.Entity.CT.CTOccupation 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.CTOccupation).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.CTOccupation) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.CTOCCDateFrom'="" eobj.CTOCCDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTOCCDateFrom) //转换日期
  s:eobj.CTOCCDateTo'="" eobj.CTOCCDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTOCCDateTo)      //转换日期
  s:eobj.CTOCCDateFrom="" eobj.CTOCCDateFrom=+$h
  s:eobj.OCCUSCActivity="" eobj.OCCUSCActivity="N"
  s eobj.OCCUSCLastUpdateDate=$p($h,",",1) ///系统最后更新日期
  s eobj.OCCUSCLastUpdateTime=$p($h,",",2) ///系统最后更新时间
  if $d(%session)
  {
	s USERID=$g(%session.Data("LOGON.USERID"))
	if (eobj.OCCUSCCreateUser="") s eobj.OCCUSCCreateUser=USERID   ///系统创建人
	if (eobj.OCCUSCLastUpdateUser="") s eobj.OCCUSCLastUpdateUser=USERID  ///系统最新更新人
  }        
  s flag=..Validate(eobj.CTOCCRowId,eobj.CTOCCCode,eobj.CTOCCDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.CTOCCRowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.CTOccupation).%New()
    d obj.OCCUSCCreateUserSetObjectId(eobj.OCCUSCCreateUser)  ///系统创建人
	s obj.OCCUSCCreateDate=+$H           ///系统创建日期
	s obj.OCCUSCCreateTime=$p($h,",",2)  ///系统创建时间	    
   }
   else                     //如果RowId已赋值则修改
   {
    s obj=##class(User.CTOccupation).%OpenId(eobj.CTOCCRowId)
    s bobj=##class(web.Entity.CT.CTOccupation).%New()
    s bobj.CTOCCRowId=eobj.CTOCCRowId
    s bobj.CTOCCCode = obj.CTOCCCode          
    s bobj.CTOCCDesc = obj.CTOCCDesc          
    s bobj.CTOCCDateFrom = obj.CTOCCDateFrom   
    s bobj.CTOCCDateTo = obj.CTOCCDateTo
	if $IsObject(obj.OCCUOCCUCCode){
	s bobj.OCCUOCCUCCode = obj.OCCUOCCUCCode.%Id()   //职业大类
	}          
 	s bobj.OCCUSCCreateUser=obj.OCCUSCCreateUser ///系统创建日期
	s bobj.OCCUSCCreateTime=obj.OCCUSCCreateTime ///系统创建时间  
	if $IsObject(obj.OCCUSCCreateUser)
	{   
		s bobj.OCCUSCCreateUser = obj.OCCUSCCreateUser.%Id()   ///系统创建人
	}
	s bobj.OCCUSCSeqNo=obj.OCCUSCSeqNo ///系统排序号
	
	s bobj.OCCUSCLastUpdateDate=obj.OCCUSCLastUpdateDate ///系统最后更新日期
	s bobj.OCCUSCLastUpdateTime=obj.OCCUSCLastUpdateTime ///系统最后更新时间
	if $IsObject(obj.OCCUSCLastUpdateUser)
	{   
		s bobj.OCCUSCLastUpdateUser = obj.OCCUSCLastUpdateUser.%Id()   ///系统最新更新人
	}
	s bobj.OCCUSCPYCode=obj.OCCUSCPYCode ///拼音码
	s bobj.OCCUSCWBCode=obj.OCCUSCWBCode ///五笔码
	s bobj.OCCUSCMark=obj.OCCUSCMark ///备注	
	  
   }
   Ts         
   s obj.CTOCCCode = eobj.CTOCCCode          //修改代码
   s obj.CTOCCDesc = eobj.CTOCCDesc          //修改描述
   s obj.CTOCCDateFrom = eobj.CTOCCDateFrom  //修改开始日期
   s obj.CTOCCDateTo = eobj.CTOCCDateTo      //修改结束日期
   d obj.OCCUOCCUCCodeSetObjectId(eobj.OCCUOCCUCCode) //职业大类
   s obj.OCCUSCActivity=eobj.OCCUSCActivity		  //是否有效
   s obj.OCCUSCSeqNo=eobj.OCCUSCSeqNo ///系统排序号
   s obj.OCCUSCLastUpdateDate=eobj.OCCUSCLastUpdateDate ///系统最后更新日期
   s obj.OCCUSCLastUpdateDate=eobj.OCCUSCLastUpdateDate ///系统最后更新时间
   
   d obj.OCCUSCLastUpdateUserSetObjectId(eobj.OCCUSCLastUpdateUser)  ///系统最新更新人
   s:eobj.OCCUSCPYCode="" eobj.OCCUSCPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.CTOCCDesc,4) ///自动生成拼音码
   
   s obj.OCCUSCPYCode=eobj.OCCUSCPYCode ///拼音码
   
   s:eobj.OCCUSCWBCode="" eobj.OCCUSCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.CTOCCDesc,1) ///自动生成五笔码
   s obj.OCCUSCWBCode=eobj.OCCUSCWBCode ///五笔码
   s obj.OCCUSCMark=eobj.OCCUSCMark ///备注   
   
   s sc=obj.%Save()
   
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    d:eobj.CTOCCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Occupation","User.CTOccupation","职业",id,eobj.CTOCCDesc,"A",eobj)
    d:eobj.CTOCCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Occupation","User.CTOccupation","职业",eobj.CTOCCRowId,eobj.CTOCCDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"     
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职业","web.DHCBL.CT.CTOccupation","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }
 }
 else
 {
  s result= "{success:'false',errorinfo:'对象不存在！'}"
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职业","web.DHCBL.CT.CTOccupation","SaveEntity","")
  s ^ERRORLOGINFO(logid)= "对象不存在！"
 }
 q result
ERROE
 s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职业","web.DHCBL.CT.CTOccupation","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：基础数据平台-鲁俊文
/// CreatDate: 2019年2月9日
/// function：删除时验证数据是否被引用
/// Debug：w ##class(web.DHCBL.CT.CTOccupation).GetRefFlag(1)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return=""
	s myInfo=""
	///^CT.BDP.CT.HOSProfTitleDictI
	if $d(^CT.BDP.CT.HOSProfTitleDictI("IndexPROFTCType",id)) s myInfo=myInfo_"<职务字典>"
	if $d(^CT.BDP.CT.HOSPersonI("IndexOccupationCode",id)) s myInfo=myInfo_"<人员基本信息>"
	s:myInfo="" return="0^未被引用可删除！"
	s:myInfo'="" return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：根据ID删除职业的内容
/// Table：User.CTOccupation
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result=""
 s re=##class(web.DHCBL.CT.CTOccupation).GetRefFlag(id)
 s RefFlag=$p(re,"^",1)
 if (RefFlag=0){
 s eobj = ##class(web.Entity.CT.CTOccupation).%New()
 s eobj.CTOCCRowId = id
 s eobj.CTOCCCode=$p($g(^CT("OCC",id)),"^",1)
 s eobj.CTOCCDesc=$p($g(^CT("OCC",id)),"^",2)
 s eobj.CTOCCDateFrom=$p($g(^CT("OCC",id)),"^",3)
 s eobj.CTOCCDateTo=$p($g(^CT("OCC",id)),"^",4)
 s eobj.OCCUSCActivity=pobj.OCCUSCActivity //是否有效
 if $IsObject(pobj.OCCUOCCUCCode){
 s eobj.OCCUOCCUCCode = pobj.OCCUOCCUCCode.%Id()   //职业大类
 } 
 s eobj.OCCUSCCreateDate=pobj.OCCUSCCreateDate ///系统创建日期
 s eobj.OCCUSCCreateTime=pobj.OCCUSCCreateTime ///系统创建时间
 if $IsObject(pobj.OCCUSCCreateUser)
 {   
	s eobj.OCCUSCCreateUser = pobj.OCCUSCCreateUser.%Id()   ///系统创建人
 }
 
 s eobj.OCCUSCSeqNo=pobj.OCCUSCSeqNo  //系统排序号
 s eobj.OCCUSCLastUpdateDate=pobj.OCCUSCLastUpdateDate ///系统最后更新日期
 s eobj.OCCUSCLastUpdateTime=pobj.OCCUSCLastUpdateTime ///系统最后更新时间 
 if $IsObject(pobj.OCCUSCLastUpdateUser)
 {   
 s eobj.OCCUSCLastUpdateUser = pobj.OCCUSCLastUpdateUser.%Id()   ///系统最新更新人
 }
 s eobj.OCCUSCPYCode=pobj.OCCUSCPYCode //拼音码
 s eobj.OCCUSCWBCode=pobj.OCCUSCWBCode //五笔码
 s eobj.OCCUSCMark=pobj.OCCUSCMark //备注
 d pobj.%Close() 
 
 s sc=##class(User.CTOccupation).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result= "{success:'true',info:'删除成功！'}"
  //保存日志
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Occupation","User.CTOccupation","职业",id,eobj.CTOCCDesc,"D",eobj)
  d eobj.%Close()
 }
 else 
 {
  s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职业","web.DHCBL.CT.CTOccupation","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
  }
 else{
	 s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：查询职业的内容
/// Table： CT_Occupation
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTOccupation","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTOCCRowId:%String,CTOCCCode:%String,CTOCCDesc:%String,CTOCCDateFrom:%String,CTOCCDateTo:%String,OCCUOCCUCCode:%String,OCCUSCActivity:%String,OCCUSCSeqNo:%String,OCCUSCPYCode:%String,OCCUSCWBCode:%String,OCCUSCMark:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
 
   //获取授权Json
   s AuStr=##class(web.DHCBL.Authorize.CTOccupation).DHCGetDataByDefaultSession()
   s AuFlag=0
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
   if (rowid'="") 
   {
     s CTOCCRowId=rowid
     s CTOCCCode=$p($g(^CT("OCC",CTOCCRowId)),"^",1)
     s CTOCCDesc=$p($g(^CT("OCC",CTOCCRowId)),"^",2)
     s CTOCCDateFrom=$p($g(^CT("OCC",CTOCCRowId)),"^",3)
     s CTOCCDateTo=$p($g(^CT("OCC",CTOCCRowId)),"^",4)
     s OCCUOCCUCCode=$p($g(^CT("OCC",CTOCCRowId)),"^",5) //职业大类指针
     s:OCCUOCCUCCode'="" OCCUOCCUCCode=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(OCCUOCCUCCode)),3) ///职业大类描述      
     s OCCUSCActivity=$p($g(^CT("OCC",CTOCCRowId)),"^",6) //是否有效
     s:OCCUSCActivity="" OCCUSCActivity="Y"
     s OCCUSCSeqNo=$p($g(^CT("OCC",CTOCCRowId)),"^",10)  //系统排序号
     s OCCUSCPYCode=$p($g(^CT("OCC",CTOCCRowId)),"^",14) //拼音码
     s OCCUSCWBCode=$p($g(^CT("OCC",CTOCCRowId)),"^",15) //五笔码
     s OCCUSCMark=$p($g(^CT("OCC",CTOCCRowId)),"^",16) //备注    
     s:CTOCCDateFrom'="" CTOCCDateFrom=$zd(CTOCCDateFrom,1)  
     s:CTOCCDateTo'="" CTOCCDateTo=$zd(CTOCCDateTo,1) 
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Occupation",CTOCCRowId)
     s BDPInternalCode =$p($g(resultStr),"^",1)       
     s BDPInternalDesc = $p($g(resultStr),"^",2)  
     s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
     d OutputRow
   }
   else
   {
     s:code'="" code=$$ALPHAUP^SSUTIL4(code) 
     s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc)  
     s CTOCCRowId=0
     for
     {
       s CTOCCRowId=$o(^CT("OCC",CTOCCRowId))
       q:CTOCCRowId=""
       ;筛选授权后的数据
       s strRowId="{ID:"_CTOCCRowId_"}"
       if (AuStr[strRowId)||(AuFlag=1) 
       {
         s CTOCCCode=$p($g(^CT("OCC",CTOCCRowId)),"^",1)
         s CTOCCDesc=$p($g(^CT("OCC",CTOCCRowId)),"^",2) 
         s CTOCCDateFrom=$p($g(^CT("OCC",CTOCCRowId)),"^",3)
         s CTOCCDateTo=$p($g(^CT("OCC",CTOCCRowId)),"^",4)
	     s OCCUOCCUCCode=$p($g(^CT("OCC",CTOCCRowId)),"^",5) //职业大类指针
	     s:OCCUOCCUCCode'="" OCCUOCCUCCode=$lg($g(^CT.BDP.CT.HOSOccuCategoryD(OCCUOCCUCCode)),3) ///职业大类描述      
	     s OCCUSCActivity=$p($g(^CT("OCC",CTOCCRowId)),"^",6) //是否有效
	     s:OCCUSCActivity="" OCCUSCActivity="Y"
	     s OCCUSCSeqNo=$p($g(^CT("OCC",CTOCCRowId)),"^",10)  //系统排序号
	     s OCCUSCPYCode=$p($g(^CT("OCC",CTOCCRowId)),"^",14) //拼音码
	     s OCCUSCWBCode=$p($g(^CT("OCC",CTOCCRowId)),"^",15) //五笔码
	     s OCCUSCMark=$p($g(^CT("OCC",CTOCCRowId)),"^",16) //备注         
         s:CTOCCDateFrom'="" CTOCCDateFrom=$zd(CTOCCDateFrom,1)  
         s:CTOCCDateTo'="" CTOCCDateTo=$zd(CTOCCDateTo,1) 
         s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
         s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Occupation",CTOCCRowId)
         s BDPInternalCode =$p($g(resultStr),"^",1)       
         s BDPInternalDesc = $p($g(resultStr),"^",2)  
         s BDPHospNationalCode=$p($g(resultStr),"^",3)         
         s BDPHospNationalDesc = $p($g(resultStr),"^",4)
         if (desc'="")
         {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Occupation",CTOCCRowId,CTOCCDesc,desc)
         }
         else
         {
            s AliasFlag= 1   
         }   
         if ($ZCVT(CTOCCCode,"U")[code)&(AliasFlag=1)  
         {
           d OutputRow
         }
       }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(CTOCCRowId,CTOCCCode,CTOCCDesc,CTOCCDateFrom,CTOCCDateTo,OCCUOCCUCCode,OCCUSCActivity,OCCUSCSeqNo,OCCUSCPYCode,OCCUSCWBCode,OCCUSCMark,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Creator：sunfengchao
/// CreatDate: 2012-12-10
/// Description：查询职业的内容,用于combox查询
/// Table：User.CTOccupation
/// Input：rowid,code,desc
/// Return：CTOCCRowId,CTOCCCode,CTOCCDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTOccupation","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTOCCRowId:%String,CTOCCCode:%String,CTOCCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.CTOccupation).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s CTOCCRowId=rowid
  s CTOCCCode=$p($g(^CT("OCC",CTOCCRowId)),"^",1)
  s CTOCCDesc=$p($g(^CT("OCC",CTOCCRowId)),"^",2)
  d OutputRow2
 }
 else
 {
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
    s CTOCCRowId=0
    for
    {
      s CTOCCRowId=$o(^CT("OCC",CTOCCRowId))
      q:CTOCCRowId=""
      s OCCUSCActivity=$p($g(^CT("OCC",CTOCCRowId)),"^",6) //是否有效
      continue:OCCUSCActivity="N"
      s CTOCCDateFrom=$p($g(^CT("OCC",CTOCCRowId)),"^",3)
      continue:(CTOCCDateFrom'="")&&(CTOCCDateFrom>+$h)
      s CTOCCDateTo=$p($g(^CT("OCC",CTOCCRowId)),"^",4)
      continue:(CTOCCDateTo'="")&&(CTOCCDateTo<+$h)
       //筛选授权后的数据
      s strRowId="{ID:"_CTOCCRowId_"}"
      if (AuStr[strRowId)||(AuFlag=1)
      {
         s CTOCCCode=$p($g(^CT("OCC",CTOCCRowId)),"^",1)
         s CTOCCDesc=$p($g(^CT("OCC",CTOCCRowId)),"^",2)
         if (desc'="")
         {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Occupation",CTOCCRowId,CTOCCDesc,desc)
         }
         else
         {
            s AliasFlag= 1   
         }   
         if ($ZCVT(CTOCCCode,"U")[code)&(AliasFlag=1) 
         {
           d OutputRow2
         }
      }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(CTOCCRowId,CTOCCCode,CTOCCDesc)
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

}
