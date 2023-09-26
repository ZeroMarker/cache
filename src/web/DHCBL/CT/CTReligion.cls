Import SQLUser

/// 名称: 宗教维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2013-7-1
Class web.DHCBL.CT.CTReligion Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2013-7-1
/// Description：修改时打开的数据
/// Table：User.CTReligion
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.CTReligion).%New()
 s obj = ##class(User.CTReligion).%OpenId(id)
 s eobj.CTRLGRowId = id
 s eobj.CTRLGCode=obj.CTRLGCode
 s eobj.CTRLGDesc=obj.CTRLGDesc
 s eobj.CTRLGDateFrom=obj.CTRLGDateFrom
 s eobj.CTRLGDateTo=obj.CTRLGDateTo
 s eobj.CTRLGActivity=obj.CTRLGActivity
 s:eobj.CTRLGActivity="" eobj.CTRLGActivity="Y"
 s:eobj.CTRLGActivity="Y" eobj.CTRLGActivity="true"
 s eobj.CTRLGSeqNo=obj.CTRLGSeqNo
 s eobj.CTRLGPYCode=obj.CTRLGPYCode
 s eobj.CTRLGWBCode=obj.CTRLGWBCode
 s eobj.CTRLGMark=obj.CTRLGMark
 s:eobj.CTRLGDateFrom'="" eobj.CTRLGDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTRLGDateFrom) //转换日期格式
 s:eobj.CTRLGDateTo'="" eobj.CTRLGDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTRLGDateTo)       //转换日期格式
 
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2013-7-1
/// Description：数据重复验证方法,js调用
/// Table：User.CTReligion
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("RLG",0,"Code",code))
 s:desc'="" flagd=$d(^CT("RLG",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("RLG",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("RLG",0,"Desc",desc,0))
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
/// CreatDate: 2013-7-1
/// Description：数据重复验证方法
/// Table：User.CTReligion
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("RLG",0,"Code",code))
 s:desc'="" flagd=$d(^CT("RLG",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("RLG",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("RLG",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2013-7-1
/// Description：保存修改宗教的内容
/// Table：User.CTReligion
/// Input：web.Entity.CT.CTReligion 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.CTReligion).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.CTReligion) As %String
{
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.CTRLGDateFrom'="" eobj.CTRLGDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTRLGDateFrom)  //转换日期
  s:eobj.CTRLGDateTo'="" eobj.CTRLGDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTRLGDateTo)      //转换日期
  s:eobj.CTRLGDateFrom="" eobj.CTRLGDateFrom=+$h
  s:eobj.CTRLGActivity="" eobj.CTRLGActivity="N"

  s eobj.CTRLGLastUpdateDate=$p($h,",",1) ///系统最后更新日期
  s eobj.CTRLGLastUpdateTime=$p($h,",",2) ///系统最后更新时间
  if $d(%session)
  {
	s USERID=$g(%session.Data("LOGON.USERID"))
	if (eobj.CTRLGCreateUser="") s eobj.CTRLGCreateUser=USERID   ///系统创建人
	if (eobj.CTRLGLastUpdateUser="") s eobj.CTRLGLastUpdateUser=USERID  ///系统最新更新人
  }  
  s flag=..Validate(eobj.CTRLGRowId,eobj.CTRLGCode,eobj.CTRLGDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.CTRLGRowId="")  //如果RowId未赋值则增加
   {
     s obj=##class(User.CTReligion).%New()
     d obj.CTRLGCreateUserSetObjectId(eobj.CTRLGCreateUser)  ///系统创建人
	 s obj.CTRLGCreateDate=+$H           ///系统创建日期
	 s obj.CTRLGCreateTime=$p($h,",",2)  ///系统创建时间	
   }
   else                   //如果RowId已赋值则修改
   {
    s obj=##class(User.CTReligion).%OpenId(eobj.CTRLGRowId)
    s bobj=##class(web.Entity.CT.CTReligion).%New()
    s bobj.CTRLGRowId=eobj.CTRLGRowId
    s bobj.CTRLGCode = obj.CTRLGCode          
    s bobj.CTRLGDesc = obj.CTRLGDesc           
    s bobj.CTRLGDateFrom = obj.CTRLGDateFrom  
    s bobj.CTRLGDateTo = obj.CTRLGDateTo
    
	s bobj.CTRLGCreateUser=obj.CTRLGCreateUser ///系统创建日期
	s bobj.CTRLGCreateTime=obj.CTRLGCreateTime ///系统创建时间
	if $IsObject(obj.CTRLGCreateUser)
	{   
		s bobj.CTRLGCreateUser = obj.CTRLGCreateUser.%Id()   ///系统创建人
	}
	s bobj.CTRLGSeqNo=obj.CTRLGSeqNo ///系统排序号
	
	s bobj.CTRLGLastUpdateDate=obj.CTRLGLastUpdateDate ///系统最后更新日期
	s bobj.CTRLGLastUpdateTime=obj.CTRLGLastUpdateTime ///系统最后更新时间
	if $IsObject(obj.CTRLGLastUpdateUser)
	{   
		s bobj.CTRLGLastUpdateUser = obj.CTRLGLastUpdateUser.%Id()   ///系统最新更新人
	}
	s bobj.CTRLGPYCode=obj.CTRLGPYCode ///拼音码
	s bobj.CTRLGWBCode=obj.CTRLGWBCode ///五笔码
	s bobj.CTRLGMark=obj.CTRLGMark ///备注
			      
   }
   Ts                    
   s obj.CTRLGCode = eobj.CTRLGCode          //修改代码
   s obj.CTRLGDesc = eobj.CTRLGDesc          //修改描述
   s obj.CTRLGDateFrom = eobj.CTRLGDateFrom  //修改开始日期
   s obj.CTRLGDateTo = eobj.CTRLGDateTo      //修改结束日期
   s obj.CTRLGActivity=eobj.CTRLGActivity		  ///是否有效

   s obj.CTRLGSeqNo=eobj.CTRLGSeqNo ///系统排序号
   s obj.CTRLGLastUpdateDate=eobj.CTRLGLastUpdateDate ///系统最后更新日期
   s obj.CTRLGLastUpdateDate=eobj.CTRLGLastUpdateDate ///系统最后更新时间
   d obj.CTRLGLastUpdateUserSetObjectId(eobj.CTRLGLastUpdateUser)  ///系统最新更新人
   s:eobj.CTRLGPYCode="" eobj.CTRLGPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.CTRLGDesc,4) ///自动生成拼音码
   s obj.CTRLGPYCode=eobj.CTRLGPYCode ///拼音码
   s:eobj.CTRLGWBCode="" eobj.CTRLGWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.CTRLGDesc,1) ///自动生成五笔码
   s obj.CTRLGWBCode=eobj.CTRLGWBCode ///五笔码
   s obj.CTRLGMark=eobj.CTRLGMark ///备注
   
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    d:eobj.CTRLGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Religion","User.CTReligion","宗教",id,eobj.CTRLGDesc,"A",eobj)
    d:eobj.CTRLGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Religion","User.CTReligion","宗教",eobj.CTRLGRowId,eobj.CTRLGDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("宗教","web.DHCBL.CT.CTReligion","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }
 }
 else
 {
  s result= "{success:'false',errorinfo:'对象不存在！'}"
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("宗教","web.DHCBL.CT.CTReligion","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
 }
 q result
}

/// Creator:鲁俊文
/// CreatDate:2022-11-30
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	if $d(^CT.BDP.CT.HOSPersonI("IndexReligion",id)){
		s myInfo=myInfo_"<人员基本信息>"
	}	
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator：sunfengchao
/// CreatDate: 2013-7-1
/// Description：根据ID删除宗教的内容
/// Table：User.CTReligion
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result=""
 s re=##class(web.DHCBL.CT.CTReligion).GetRefFlag(id)
 s RefFlag=$p(re,"^",1)
 if (RefFlag=0){
 s eobj = ##class(web.Entity.CT.CTReligion).%New()
 s eobj.CTRLGRowId = id
 s eobj.CTRLGCode=pobj.CTRLGCode //代码
 s eobj.CTRLGDesc=pobj.CTRLGDesc //描述
 s eobj.CTRLGDateFrom=pobj.CTRLGDateFrom //开始日期
 s eobj.CTRLGDateTo=pobj.CTRLGDateTo //结束日期
 s eobj.CTRLGActivity=pobj.CTRLGActivity //是否有效
 
 s eobj.CTRLGCreateDate=pobj.CTRLGCreateDate ///系统创建日期
 s eobj.CTRLGCreateTime=pobj.CTRLGCreateTime ///系统创建时间
 if $IsObject(pobj.CTRLGCreateUser)
 {   
	s eobj.CTRLGCreateUser = pobj.CTRLGCreateUser.%Id()   ///系统创建人
 }
 
 s eobj.CTRLGSeqNo=pobj.CTRLGSeqNo  //系统排序号
 s eobj.CTRLGLastUpdateDate=pobj.CTRLGLastUpdateDate ///系统最后更新日期
 s eobj.CTRLGLastUpdateTime=pobj.CTRLGLastUpdateTime ///系统最后更新时间 
 if $IsObject(pobj.CTRLGLastUpdateUser)
 {   
 s eobj.CTRLGLastUpdateUser = pobj.CTRLGLastUpdateUser.%Id()   ///系统最新更新人
 }
 s eobj.CTRLGPYCode=pobj.CTRLGPYCode //拼音码
 s eobj.CTRLGWBCode=pobj.CTRLGWBCode //五笔码
 s eobj.CTRLGMark=pobj.CTRLGMark //备注
 d pobj.%Close()
 k pobj
 Tstart
 s sc=##class(User.CTReligion).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result= "{success:'true',info:'删除成功！'}"
  //保存日志 
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Religion","User.CTReligion","宗教",id,eobj.CTRLGDesc,"D",eobj)
  d eobj.%Close()
 }
 else 
 {
  s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("宗教","web.DHCBL.CT.CTReligion","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
 }
 else{
	 s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2013-7-1
/// Description：查询宗教的内容
/// Table： CT_Religion
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTReligion","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTRLGRowId:%String,CTRLGCode:%String,CTRLGDesc:%String,CTRLGDateFrom:%String,CTRLGDateTo:%String,CTRLGActivity:%String,CTRLGSeqNo:%String,CTRLGPYCode:%String,CTRLGWBCode:%String,CTRLGMark:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
 
   //获取授权Json
   s AuStr=##class(web.DHCBL.Authorize.CTReligion).DHCGetDataByDefaultSession()
   s AuFlag=0
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
   if (rowid'="") //根据rowid返回该条记录
   {
     s CTRLGRowId=rowid
     s CTRLGCode=$p($g(^CT("RLG",CTRLGRowId)),"^",1) //代码
     s CTRLGDesc=$p($g(^CT("RLG",CTRLGRowId)),"^",2) //描述
     s CTRLGDateFrom=$p($g(^CT("RLG",CTRLGRowId)),"^",3) //开始日期
     s CTRLGDateTo=$p($g(^CT("RLG",CTRLGRowId)),"^",4)  //结束日期
     s CTRLGActivity=$p($g(^CT("RLG",CTRLGRowId)),"^",5) //是否有效
     s:CTRLGActivity="" CTRLGActivity="Y"
     s CTRLGSeqNo=$p($g(^CT("RLG",CTRLGRowId)),"^",9)  //系统排序号
     s CTRLGPYCode=$p($g(^CT("RLG",CTRLGRowId)),"^",13) //拼音码
     s CTRLGWBCode=$p($g(^CT("RLG",CTRLGRowId)),"^",14) //五笔码
     s CTRLGMark=$p($g(^CT("RLG",CTRLGRowId)),"^",15) //备注
     s:CTRLGDateFrom'="" CTRLGDateFrom=$zd(CTRLGDateFrom,1)  
     s:CTRLGDateTo'="" CTRLGDateTo=$zd(CTRLGDateTo,1)  
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Religion",CTRLGRowId)
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
     s CTRLGRowId=0
     for
     {
        s CTRLGRowId=$o(^CT("RLG",CTRLGRowId))
        q:CTRLGRowId=""
        //筛选授权后的数据
        s strRowId="{ID:"_CTRLGRowId_"}"
        if (AuStr[strRowId)||(AuFlag=1) 
        {
		    s CTRLGCode=$p($g(^CT("RLG",CTRLGRowId)),"^",1) //代码
		    s CTRLGDesc=$p($g(^CT("RLG",CTRLGRowId)),"^",2) //描述
		    s CTRLGDateFrom=$p($g(^CT("RLG",CTRLGRowId)),"^",3) //开始日期
		    s CTRLGDateTo=$p($g(^CT("RLG",CTRLGRowId)),"^",4)  //结束日期
		    s CTRLGActivity=$p($g(^CT("RLG",CTRLGRowId)),"^",5) //是否有效
		    s:CTRLGActivity="" CTRLGActivity="Y"
		    s CTRLGSeqNo=$p($g(^CT("RLG",CTRLGRowId)),"^",9)  //系统排序号
		    s CTRLGPYCode=$p($g(^CT("RLG",CTRLGRowId)),"^",13) //拼音码
		    s CTRLGWBCode=$p($g(^CT("RLG",CTRLGRowId)),"^",14) //五笔码
		    s CTRLGMark=$p($g(^CT("RLG",CTRLGRowId)),"^",15) //备注            
            s:CTRLGDateFrom'="" CTRLGDateFrom=$zd(CTRLGDateFrom,1)  
            s:CTRLGDateTo'="" CTRLGDateTo=$zd(CTRLGDateTo,1) 
            s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
            s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Religion",CTRLGRowId)
            s BDPInternalCode =$p($g(resultStr),"^",1)       
            s BDPInternalDesc = $p($g(resultStr),"^",2)  
            s BDPHospNationalCode=$p($g(resultStr),"^",3)         
            s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
            if (desc'="")
            {
                ;需要对描述或者别名进行检索      
                s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Religion",CTRLGRowId,CTRLGDesc,desc)
            }
            else
            {
                s AliasFlag= 1   
            }   
            if ($ZCVT(CTRLGCode,"U")[code)&(AliasFlag=1) 
            {
              d OutputRow
            }
         }
      }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(CTRLGRowId,CTRLGCode,CTRLGDesc,CTRLGDateFrom,CTRLGDateTo,CTRLGActivity,CTRLGSeqNo,CTRLGPYCode,CTRLGWBCode,CTRLGMark,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// CreatDate: 2013-7-1
/// Description：查询宗教的内容,用于combox查询
/// Table：User.CTReligion
/// Input：rowid,code,desc
/// Return：CTRLGRowId,CTRLGCode,CTRLGDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTReligion","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTRLGRowId:%String,CTRLGCode:%String,CTRLGDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.CTReligion).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s CTRLGRowId=rowid
  s CTRLGCode=$p($g(^CT("RLG",CTRLGRowId)),"^",1)
  s CTRLGDesc=$p($g(^CT("RLG",CTRLGRowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
  s CTRLGRowId=0
  for
  {
   s CTRLGRowId=$o(^CT("RLG",CTRLGRowId))
   q:CTRLGRowId=""
   s CTRLGActivity=$p($g(^CT("RLG",CTRLGRowId)),"^",5) //是否有效
   continue:CTRLGActivity="N" 
   s CTRLGDateFrom=$p($g(^CT("RLG",CTRLGRowId)),"^",3)
   continue:(CTRLGDateFrom'="")&&(CTRLGDateFrom>+$h)
   s CTRLGDateTo=$p($g(^CT("RLG",CTRLGRowId)),"^",4) 
   continue:(CTRLGDateTo'="")&&(CTRLGDateTo<+$h)
   //筛选授权后的数据
   s strRowId="{ID:"_CTRLGRowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) 
   {
      s CTRLGCode=$p($g(^CT("RLG",CTRLGRowId)),"^",1)
      s CTRLGDesc=$p($g(^CT("RLG",CTRLGRowId)),"^",2)
      if (desc'="")
      {
          ;需要对描述或者别名进行检索      
          s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Religion",CTRLGRowId,CTRLGDesc,desc)
      }
      else
      {
          s AliasFlag= 1   
      }   
      if ($ZCVT(CTRLGCode,"U")[code)&(AliasFlag=1) 
      {
        d OutputRow2
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(CTRLGRowId,CTRLGCode,CTRLGDesc)
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
