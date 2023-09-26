/// Description：知识提交和审核
/// Creator：程和贵
/// Date：2018-03-29
Class web.DHCBL.MKB.MKBKnoManage Extends %RegisteredObject
{

/// 查询数据
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKnoManage","GetList","","")
Query GetList(rowid As %String, desc As %String, flag As %String, username As %String) As %Query(ROWSPEC = "MKBKMRowId,MKBKMCode,MKBKMDesc,MKBKMSource,MKBKMType,SSUSRName,MKBKMUpdateDate,MKBKMFlag,MKBKMNote,MKBKMPath,MKBKMTermDr,MKBKMTerm,MKBKMProDr,MKBKMPro,MKBKMUpdateLoc,MKBKMDetail,MKBKMDetailo,MKBKMMiniFlag,MKBKMFailureReason")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, flag As %String, username As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s len=0
 if (rowid'="") //根据rowid返回该条记录
 {
    s MKBKMRowId=rowid
    s MKBKMCode=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),2)
    s MKBKMDesc=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),3)
    s MKBKMPath=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),4)
    s MKBKMSource=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),5)
    s MKBKMType=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),6)
    s SSUSRName=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),7)
    //s:MKBKMUpdateUser'="" SSUSRName=$p($g(^SSU("SSUSR",MKBKMUpdateUser)),"^",2)//2019-09-09
    //s:MKBKMUpdateUser="" SSUSRName=""
    s MKBKMUpdateDate=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),8)
    s:MKBKMUpdateDate'="" MKBKMUpdateDate=$zd(MKBKMUpdateDate,3)
    s MKBKMFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),9)
    s MKBKMNote=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),10)
    s MKBKMUpdateLoc = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),11)
    s:MKBKMUpdateLoc'="" MKBKMUpdateLoc=$p($g(^CTLOC(MKBKMUpdateLoc)),"^",2)
    s:MKBKMUpdateLoc="" MKBKMUpdateLoc=""
    s MKBKMPro = ""
    s MKBKMTerm = ""
    s MKBKMTermDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),12)
    s:MKBKMTermDr'="" MKBKMTerm=$LISTGET($g(^User.MKBTermD(MKBKMTermDr)),3)
    s MKBKMProDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),13)
    
    s:MKBKMProDr'="" MKBKMPro=$LISTGET($g(^User.MKBTermPropertyD(MKBKMProDr)),3)
    s MKBKMDetailo =  $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),14)
    s:MKBKMDetailo'="" len = $L(MKBKMDetailo,"^")
    s MKBKMDetail=""
    for i=0:1:len
    {
       s MKBKMDetaili=$p($g(MKBKMDetailo),"^",i)
       s DetailiDesc = ##class(web.DHCBL.MKB.MKBTermProDetail).GetDesc(MKBKMDetaili)
       s:MKBKMDetail'="" MKBKMDetail=MKBKMDetail_"^"_DetailiDesc
       s:MKBKMDetail="" MKBKMDetail=DetailiDesc
    }
    s MKBKMMiniFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),15)
    s MKBKMFailureReason=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),16)
    d OutputRow
 }
 else
 {
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s MKBKMRowId=""
    for{  
        s MKBKMRowId=$o(^User.MKBKnoManageD(MKBKMRowId),-1) q:MKBKMRowId=""   
        s MKBKMCode=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),2)
        s MKBKMDesc=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),3)
        s MKBKMPath=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),4)
        s MKBKMSource=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),5)
        s MKBKMType=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),6)
        s SSUSRName=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),7)
        //s:MKBKMUpdateUser'="" SSUSRName=$p($g(^SSU("SSUSR",MKBKMUpdateUser)),"^",2)
        //s:MKBKMUpdateUser="" SSUSRName=""
        s MKBKMUpdateDate=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),8)
        s:MKBKMUpdateDate'="" MKBKMUpdateDate=$zd(MKBKMUpdateDate,3)
        s MKBKMFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),9)
        /*s:(MKBKMFlag'="Y")&&(MKBKMFlag'="N") MKBKMFlag="初传"
        s:MKBKMFlag="N" MKBKMFlag="审核未通过"
        s:MKBKMFlag="Y" MKBKMFlag="审核通过"*/
        s MKBKMNote=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),10)
        s MKBKMUpdateLoc = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),11)
        s:MKBKMUpdateLoc'="" MKBKMUpdateLoc=$p($g(^CTLOC(MKBKMUpdateLoc)),"^",2)
        s:MKBKMUpdateLoc="" MKBKMUpdateLoc=""
        s MKBKMPro = ""
    	s MKBKMTerm = ""
        s MKBKMTermDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),12)
        s:MKBKMTermDr'="" MKBKMTerm=$LISTGET($g(^User.MKBTermD(MKBKMTermDr)),3)
        s MKBKMProDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),13)
        s:MKBKMProDr'="" MKBKMPro=$LISTGET($g(^User.MKBTermPropertyD(MKBKMProDr)),3)
        s MKBKMDetailo =  $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),14)
        s:MKBKMDetailo'="" len = $L(MKBKMDetailo,"^")
        s MKBKMDetail=""
        for i=0:1:len
        {
           s MKBKMDetaili=$p($g(MKBKMDetailo),"^",i)
           s DetailiDesc = ##class(web.DHCBL.MKB.MKBTermProDetail).GetDesc(MKBKMDetaili)
           s:MKBKMDetail'="" MKBKMDetail=MKBKMDetail_"^"_DetailiDesc
           s:MKBKMDetail="" MKBKMDetail=DetailiDesc
        }
        s MKBKMMiniFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),15)
   		s MKBKMFailureReason=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),16)

        s PINYIN=""
        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBKMDesc)  
        if ((($ZCONVERT(MKBKMDesc,"U")[desc)||(PINYIN[desc)) && (MKBKMMiniFlag[flag) && (SSUSRName[username))
        {
            d OutputRow
        }
    }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(MKBKMRowId,MKBKMCode,MKBKMDesc,MKBKMSource,MKBKMType,SSUSRName,MKBKMUpdateDate,MKBKMFlag,MKBKMNote,MKBKMPath,MKBKMTermDr,MKBKMTerm,MKBKMProDr,MKBKMPro,MKBKMUpdateLoc,MKBKMDetail,MKBKMDetailo,MKBKMMiniFlag,MKBKMFailureReason)
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

/// Description:为combobox查询取数据
/// Table：User.MKBKMManage
/// Input：rowid,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKnoManage","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "MKBKMRowId,MKBKMCode,MKBKMDesc,MKBKMPath")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
    s MKBKMRowId=rowid
    s MKBKMCode=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),2)
    s MKBKMDesc=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),3)
    s MKBKMPath=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),4)
    d OutputRowCmb
 }
 else
 {
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写

    s MKBKMRowId=0
    for{  
      s MKBKMRowId=$o(^User.MKBKnoManageD(MKBKMRowId)) q:MKBKMRowId=""   
      s MKBKMCode=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),2)
      s MKBKMDesc=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),3)
      s MKBKMPath=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),4)

      s PINYIN=""
      s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBKMDesc)  
      if (($ZCONVERT(MKBKMDesc,"U")[desc)||(PINYIN[desc)) {
        d OutputRowCmb
      }
    }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(MKBKMRowId,MKBKMCode,MKBKMDesc,MKBKMPath)
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

/// Function:用于实现数据校验功能的方法
/// w ##class(web.DHCBL.MKB.MKBKnoManage).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s flag="",flagc=""
    s:code'="" flagc=$d(^User.MKBKnoManageI("CodeIndex"," "_code))
    if (id="") //如果为空，增加时的重复判断
    {
        if (flagc>0) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc=""
        s:code'="" idc=$o(^User.MKBKnoManageI("CodeIndex"," "_code,0))
        if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

ClassMethod SaveFailureReason(id, reason)
{
	
	s obj=##class(User.MKBKnoManage).%OpenId(id)
	s obj.MKBKMFailureReason=reason
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	if $$$ISOK(sc)
	{
		Tc
		set id=obj.%Id()
		set result = "{success:'true',id:'"_id_"'}" 
	}
	else
	{
		Tro
		set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
		
	}
	q result
}

/// Description：保存修改内容
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other
ClassMethod SaveData(eobj As web.Entity.MKB.MKBKnoManage) As %String
{
    
    s result = ""
    Set UpdateDate=$p($h,",",1)       //上传日期
    Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
    Set UpdateLocDR=%session.Get("LOGON.CTLOCID")   //上传科室
     //s UpdateUserDR=1
    // s UpdateLocDR=102
    if $IsObject(eobj)
    {
        s flag=..FormValidate(eobj.MKBKMRowId,eobj.MKBKMCode)   
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'代码已经存在！'}"
        }
        else
        {   
            if (eobj.MKBKMRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.MKBKnoManage).%New()
                s obj.MKBKMUpdateDate = UpdateDate
                d:UpdateLocDR'="" obj.MKBKMUpdateLocSetObjectId(UpdateLocDR)
                
                s:UpdateUserDR'="" obj.MKBKMUpdateUser = $p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
                s obj.MKBKMCode = eobj.MKBKMCode
                s obj.MKBKMDesc = eobj.MKBKMDesc
                s obj.MKBKMSource = eobj.MKBKMSource
                s obj.MKBKMType = eobj.MKBKMType
                s obj.MKBKMNote = eobj.MKBKMNote
                s obj.MKBKMPath = eobj.MKBKMPath
               
                d:eobj.MKBKMTermDr'="" obj.MKBKMTermDrSetObjectId(eobj.MKBKMTermDr)
                d:eobj.MKBKMProDr'="" obj.MKBKMProDrSetObjectId(eobj.MKBKMProDr)
                s obj.MKBKMDetail = eobj.MKBKMDetail
                s obj.MKBKMMiniFlag = "C"
                }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.MKBKnoManage).%OpenId(eobj.MKBKMRowId)
                s obj.MKBKMFlag = eobj.MKBKMFlag
                s bobj = ##class(web.Entity.MKB.MKBKnoManage).%New()
                s bobj.MKBKMRowId = eobj.MKBKMRowId
                s bobj.MKBKMFlag = obj.MKBKMFlag
                
            }
          
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.MKBKMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KnoManage","User.MKBKnoManage","知识提交",id,eobj.MKBKMDesc,"A",eobj)
                d:eobj.MKBKMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KnoManage","User.MKBKnoManage","知识审核",eobj.MKBKMRowId,obj.MKBKMDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识提交","web.DHCBL.MKB.MKBKnoManage","SaveData",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }
        }   
    }   
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在'}"
    }
    
    q result
}

/// Description：保存微信小程序提供的数据
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// input:note（修改备注，即要修改的内容）, termid（修改的中心词id）, proid（修改的属性d）, detail（修改的属性内容），username(用户名字符串)
/// Other:w ##class(web.DHCBL.MKB.MKBKnoManage).SaveMiniData("","","","","")
ClassMethod SaveMiniData(note, termid, proid, detail, username) As %String
{
    
    s result = ""
    Set UpdateDate=$p($h,",",1)       //上传日期
   	if ((note="") && (termid="") &&  (proid="") &&  (detail="") &&  (username="")){
	   	s result = "{success:'false',errorinfo:'请保证数据至少有一项不为空'}"   //返回错误信息
	}
	else{
	    s obj=##class(User.MKBKnoManage).%New()
	    s obj.MKBKMUpdateDate = UpdateDate
	    s obj.MKBKMType = ""
	    s obj.MKBKMNote = note
	   
	    d:termid'="" obj.MKBKMTermDrSetObjectId(termid)
	    d:proid'="" obj.MKBKMProDrSetObjectId(proid)
	    s obj.MKBKMDetail = detail
	    s obj.MKBKMMiniFlag = "M"
	  	s obj.MKBKMUpdateUser = username
	    Ts
	    s sc=obj.%Save()
	    d obj.%Close()
	    If $$$ISOK(sc){
	        Tc
	        s id = obj.%Id()
	        s result = "{success:'true',id:'"_id_"'}" //返回RowId
	    }else{
	        Trollback
	        s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
	    }

	}
      
    
    q result
}

/// 双击打开修改
/// w ##class(web.DHCBL.MKB.MKBKnoManage).OpenData("4")
ClassMethod OpenData(RowId As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.MKB.MKBKnoManage).%New()
    s pobj = ##class(User.MKBKnoManage).%OpenId(RowId)
    s eobj.MKBKMRowId = RowId
    s eobj.MKBKMCode = pobj.MKBKMCode
    s eobj.MKBKMDesc = pobj.MKBKMDesc
    s eobj.MKBKMSource = pobj.MKBKMSource
    s eobj.MKBKMType = pobj.MKBKMType
    s eobj.MKBKMFlag = pobj.MKBKMFlag
    s eobj.MKBKMNote = pobj.MKBKMNote
    s eobj.MKBKMPath = pobj.MKBKMPath
    s eobj.MKBKMDetail = pobj.MKBKMDetail
    s eobj.MKBKMUpdateUser = pobj.MKBKMUpdateUser
    s eobj.MKBKMUpdateLoc = pobj.MKBKMUpdateLoc
    if $IsObject(pobj.MKBKMTermDr){
        s eobj.MKBKMTermDr = pobj.MKBKMTermDr.%Id() 
        }
    if $IsObject(pobj.MKBKMProDr){
        s eobj.MKBKMProDr = pobj.MKBKMProDr.%Id() 
        }
        
    d pobj.%Close() 
    k pobj  

    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// w ##class(web.DHCBL.MKB.MKBKnoManage).OpenData1("4")
ClassMethod OpenData1(RowId As %String) As %String
{
    s str=""
    s TKBTRBRowId=RowId
    s TKBTRBCode=$p($g(^TKBTREM(TKBTRBRowId)),"^",1)  //代码
    s TKBTRBDesc=$p($g(^TKBTREM(TKBTRBRowId)),"^",2)  //描述
    s str = "{""KBTRBCode:"""_TKBTRBCode_""",""TKBTRBDesc"""_TKBTRBDesc_"""}"
    q str
}

/// 获取描述
/// w ##class(web.DHCBL.MKB.MKBKnoManage).GetDesc(1881)
ClassMethod GetDesc(RowId As %String) As %String
{
    s str=""    
    s:RowId'="" str=$LISTGET($G(^User.MKBKnoManageD(RowId)),3)
    q str
}

/// 删除
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
/// w ##class(web.DHCBL.MKB.MKBKnoManage).DeleteData(13)
ClassMethod DeleteData(id) As %String
{
  s result=""

  s eobj=##class(web.Entity.MKB.MKBKnoManage).%New()
  
  s eobj.MKBKMRowId=id
  s eobj.MKBKMCode=$LISTGET($G(^User.MKBKnoManageD(id)),2)
  s eobj.MKBKMDesc=$LISTGET($G(^User.MKBKnoManageD(id)),3)
  s eobj.MKBKMPath=$LISTGET($G(^User.MKBKnoManageD(id)),4)
  s eobj.MKBKMSource=$LISTGET($G(^User.MKBKnoManageD(id)),5)
  s eobj.MKBKMType=$LISTGET($G(^User.MKBKnoManageD(id)),6)
  s eobj.MKBKMUpdateUser=$LISTGET($G(^User.MKBKnoManageD(id)),7)
  s eobj.MKBKMUpdateDate=$LISTGET($G(^User.MKBKnoManageD(id)),8)
  s eobj.MKBKMFlag=$LISTGET($G(^User.MKBKnoManageD(id)),9)
  s eobj.MKBKMNote=$LISTGET($G(^User.MKBKnoManageD(id)),10)
  s eobj.MKBKMTermDr=$LISTGET($G(^User.MKBKnoManageD(id)),12)
  s eobj.MKBKMProDr=$LISTGET($G(^User.MKBKnoManageD(id)),13)
  s eobj.MKBKMUpdateLoc=$LISTGET($G(^User.MKBKnoManageD(id)),11)
  s eobj.MKBKMDetail =  $LISTGET($G(^User.MKBKnoManageD(id)),14)
  Tstart
  s sc=##class(User.MKBKnoManage).%DeleteId(id)
  IF $$$ISOK(sc) {
   Tc
   s result="{success:'true',info:'删除成功'}"
   //保存日志
   d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KnoManage","User.MKBKnoManage","知识审核",id,eobj.MKBKMDesc,"D",eobj)
   d eobj.%Close()
  }
  else 
  {
     Trollback
     s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识审核","web.DHCBL.MKB.MKBKMManage","DeleteData",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
  }
 q result
}

/// Description:代码自动生成  TK0000000 代码最大值加1
/// w ##class(web.DHCBL.MKB.MKBKnoManage).GetLastCode()
ClassMethod GetLastCode() As %String
{
    s CodeLen="9"    //代码长度
    s StartCode="MK"  //代码起始字符
    s code=""
    s StartCodeLen=$Length(StartCode)
    s MKBKMRowId="", preCode=""    //寻找符合规则的最大的代码
    for {
        s MKBKMRowId=$o(^User.MKBKnoManageD(MKBKMRowId),"-1")
        q:MKBKMRowId=""
        s MKBKMCode=$listget($g(^User.MKBKnoManageD(MKBKMRowId)),2)
        if ($e(MKBKMCode,1,StartCodeLen)=StartCode)
        {
            s preCode=MKBKMCode
            q
        }
    
    }
    s CodeNum=""
    if (preCode="")   //如果没有符合规则的代码，则生成第一个数字1
    {
        s CodeNum=1
    }
    else  //如果有符合规则的代码，则起始字符后的数字+1
    {       
        s CodeNum=$p(preCode,StartCode,2)+1     //起始字符后的数字+1
    }
    s CodeNumLen=$Length(CodeNum)     //数字的长度

    s zeroLen=CodeLen-StartCodeLen-CodeNumLen  //中间0串的长度
    s zeroStr=""  //中间0串
    s count=0
    for
    {
        s count=count+1
        q:count>zeroLen
        s zeroStr=zeroStr_"0"
    }
    
    s mycode=StartCode_zeroStr_CodeNum  //起始字符_0串_数字 的组合

    q mycode
}

// w ##class(web.DHCBL.MKB.MKBKnoManage).Webservice("C:\\Users\\Administrator\\Desktop\\1.txt")

// 调用webservice

ClassMethod Webservice(path)
{
    s op = ##class(OfficeToPDFImpl.OfficeToPDFImplPort).%New()
    s rst = op.officeToPDF(path)
    q rst
}

// 验证文件是否已经存在

// w ##class(web.DHCBL.MKB.MKBKnoManage).FileValidate("123.txt")

// Input：文件名称

//  return ：-1 表示存在    1表示不存在

ClassMethod FileValidate(fileName)
{
    s MKBKMRowId=0
    for{  
        s MKBKMRowId=$o(^User.MKBKnoManageD(MKBKMRowId)) q:MKBKMRowId=""   
        s MKBKMDesc=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),3)
        if (fileName=MKBKMDesc)
        {
            s result = -1
        }
        else 
        {
            s result = 1
        }
    }
    q result
}

// 文件是否存在

ClassMethod IsExistsFile(filePath As %String) As %String
{
    s flag=0
    s Config = $o(^websys.ConfigurationD(""))
    s App = $lg(^websys.ConfigurationD(Config),1)
    if (App=""){
        s path="D:\DTHealth\app\dthis\web"
    }else{
        s path= $e(App,1,*-12)
    }
    s dirAll=path_"\"_filePath
    s flag=##class(%File).Exists(dirAll)
    
    q flag
}

// 删除预览文件

// w ##class(web.DHCBL.MKB.MKBKnoManage).DeletePreviewFile("scripts\bdp\Framework\Doc\123.pdf")

ClassMethod DeletePreviewFile(PreviewFilePath As %String) As %String
{
    
    s result=0
    s Config = $o(^websys.ConfigurationD(""))
    s App = $lg(^websys.ConfigurationD(Config),1)
    if (App=""){
        s path="D:\DTHealth\app\dthis\web"
    }else{
        s path= $e(App,1,*-12)
    }
    s dirAll=path_"\"_PreviewFilePath
    If (##class(%File).Exists(dirAll)=1)
    {
      s result= ##class(%File).Delete(dirAll)
    }
    q result
}

/// d ##class(web.DHCBL.MKB.MKBKnoManage).ExportGlobal()
ClassMethod ExportGlobal()
{
    k CList
    k myIdx
    
    
    //Menu.gof
    s CList($i(CList))= "User.BDPExecutablesC.GBL" 
    s CList($i(CList))= "User.BDPExecutablesD.GBL" 
    s CList($i(CList))= "User.BDPExecutablesI.GBL" 
    s CList($i(CList))= "User.BDPExtExecItemI.GBL" 
    s CList($i(CList))= "User.BDPMenuD.GBL" 
    s CList($i(CList))= "User.BDPMenuI.GBL" 

    
    s items = ""
    f {
        s myIdx = $i(myIdx)
        q:(myIdx>$g(CList))
        s:((items'="")&&(CList(myIdx)'="")) items= items_","

        s items = items_CList(myIdx)
    }
    
    d $SYSTEM.OBJ.Export(items, "D:\dthealth\Menu.gof", "", .log)
}

/// Creator:李得原
/// CreatDate:2019-04-29
/// Description:根据word文件名生成pdf文件
/// Table:
/// Input:
/// Return:
/// w ##class(web.DHCBL.MKB.MKBKnoManage).Word2Pdf("临床知识库使用说明书.doc")
ClassMethod Word2Pdf(filename)
{
	
	s cmd1="word2pdf.exe.lnk /source ""D:\DtHealth\app\dthis\web\scripts\bdp\MKB\Doc\Kno\"""_filename
	s cmd2="/target ""D:\DtHealth\app\dthis\web\scripts\bdp\MKB\Doc\Kno\"""
	s cmd=cmd1_" "_cmd2
	s sc=$zf(-2,cmd)
	q ""
}

}
