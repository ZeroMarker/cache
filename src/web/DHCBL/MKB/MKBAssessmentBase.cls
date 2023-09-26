/// Creator:李欣
/// CreatDate:2018-05-10
/// Table：User.MKBAssessmentBase
Class web.DHCBL.MKB.MKBAssessmentBase Extends %RegisteredObject
{

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：查询评分表注册表内容
/// Table：User.MKBAssessmentBase
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBAssessmentBase","GetList","","")
Query GetList(rowid As %String, desc As %String) As %Query(ROWSPEC = "MKBABRowId,MKBABCode,MKBABDesc,MKBABNote")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1

    if (rowid'="") //根据rowid返回该条记录
    {
        s MKBABRowId=rowid
        s MKBABCode=$LISTGET($G(^User.MKBAssessmentBaseD(MKBABRowId)),2)
        s MKBABDesc=$LISTGET($G(^User.MKBAssessmentBaseD(MKBABRowId)),3)
        s MKBABNote=$LISTGET($G(^User.MKBAssessmentBaseD(MKBABRowId)),4)
        d OutputRow
    }
    else
    {
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s MKBABRowId=""
        for
        {  
            s MKBABRowId=$o(^User.MKBAssessmentBaseD(MKBABRowId),-1) 
            q:MKBABRowId=""  

            s MKBABCode=$LISTGET($G(^User.MKBAssessmentBaseD(MKBABRowId)),2)
            s MKBABDesc=$LISTGET($G(^User.MKBAssessmentBaseD(MKBABRowId)),3)
            s MKBABNote=$LISTGET($G(^User.MKBAssessmentBaseD(MKBABRowId)),4)
            
            s MKBABDescPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBABDesc)  
            s MKBABDescPY = $TR(MKBABDescPY,"_","")
            if (($ZCONVERT(MKBABDesc,"U")[desc)||(MKBABDescPY[desc))
            {
                d OutputRow
            }
        }
    }
 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(MKBABRowId,MKBABCode,MKBABDesc,MKBABNote)
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

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：查询评分表注册表内容
/// Table：User.MKBAssessmentBase
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBAssessmentBase","GetDataForCom1","","")
Query GetDataForCom1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "MKBABRowId,MKBABDesc")
{
}

ClassMethod GetDataForCom1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1

    if (rowid'="") //根据rowid返回该条记录
    {
        s MKBABRowId=rowid
        s MKBABDesc=$LISTGET($G(^User.MKBAssessmentBaseD(MKBABRowId)),3)
        d OutputRowCmb
    }
    else
    {
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s:q'="" q=$ZCONVERT(q,"U") //转换成大写
        s MKBABRowId=""
        for
        {  
            s MKBABRowId=$o(^User.MKBAssessmentBaseD(MKBABRowId),-1)
            q:MKBABRowId=""  

            s MKBABDesc=$LISTGET($G(^User.MKBAssessmentBaseD(MKBABRowId)),3)
            
            s MKBABDescPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBABDesc)
            s MKBABDescPY = $TR(MKBABDescPY,"_","")
            if ((($ZCONVERT(MKBABDesc,"U")[desc)||(MKBABDescPY[desc))&(($ZCONVERT(MKBABDesc,"U")[q)||(MKBABDescPY[q)))
            {
                d OutputRowCmb
            }
        }
    }
 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(MKBABRowId,MKBABDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCom1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCom1Execute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDataForCom1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCom1Execute ]
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

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：自动生成代码
/// Table：User.MKBAssessmentBase
/// Input：
/// Other: w ##class(web.DHCBL.MKB.MKBAssessmentBase).GenerateCode()
ClassMethod GenerateCode()
{
    if ($D(^User.MKBAssessmentBaseI("CodeIndex"))=0)
    {
        s code = "B00000001"    
    }
    else
    {
        s pre = $O(^User.MKBAssessmentBaseI("CodeIndex",""),-1)
        s pre = $E(pre,"3",$L(pre)) 
        s code = pre+1
        s codelen = $L(code)
        for i=codelen:1:7
        {
            s code = "0"_code   
        }
        s code = "B"_code
    }
    q code
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据验证
/// Table：User.MKBAssessmentBase
/// Input：id, desc
/// Other: w ##class(web.DHCBL.MKB.MKBAssessmentBase).Validate()
ClassMethod Validate(id, desc)
{
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagd=""
    s:desc'="" flagd=$d(^User.MKBAssessmentBaseI("DescIndex"," "_desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if (flagd>0) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idd=""
        s:desc'="" idd=$o(^User.MKBAssessmentBaseI("DescIndex"," "_desc,0))
        if ((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存方法
/// Table：User.MKBAssessmentBase
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.DHCBL.MKB.MKBAssessmentBase).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.MKB.MKBAssessmentBase) As %String
{
    s result=""
    if $IsObject(eobj)
    { 
        s flag=..Validate(eobj.MKBABRowId,eobj.MKBABDesc)   
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.MKBABRowId="")  //如果RowId未赋值则增加
            { 
                s obj=##class(User.MKBAssessmentBase).%New()
            }
            else   //如果RowId已赋值则修改
            {
                s obj=##class(User.MKBAssessmentBase).%OpenId(eobj.MKBABRowId)
                s bobj=##class(web.Entity.MKB.MKBAssessmentBase).%New()
                s bobj.MKBABRowId = obj.%Id()
                s bobj.MKBABCode = obj.MKBABCode
                s bobj.MKBABDesc = obj.MKBABDesc
                s bobj.MKBABNote = obj.MKBABNote
            }
            if (eobj.MKBABCode="")
            {
                s obj.MKBABCode = ..GenerateCode()  
            }
            else
            {
                s obj.MKBABCode = eobj.MKBABCode    
            }
            s obj.MKBABDesc = eobj.MKBABDesc
            s obj.MKBABNote = eobj.MKBABNote 
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            s id=""
            If $$$ISOK(sc)
            {
                tc
                //保存日志
                s id = obj.%Id()
                d:eobj.MKBABRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_AssessmentBase","User.MKBAssessmentBase","评估表注册",id,eobj.MKBABDesc,"A",eobj)
                d:eobj.MKBABRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_AssessmentBase","User.MKBAssessmentBase","评估表注册",eobj.MKBABRowId,eobj.MKBABDesc,"U",eobj,bobj)
                s result = "{success:'true',id:'"_id_"'}"    
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
                ;s errortip = $SYSTEM.Status.GetErrorText(sc)
                //s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("评估表注册","web.DHCBL.MKB.MKBAssessmentBase","SaveEntity",eobj)
                //s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")   
            }
        }
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
        //s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("术语库维护","web.DHCBL.MKB.MKBTermBase","SaveEntity","")
        //s ^ERRORLOGINFO(logid)="对象不存在！"   
    } 
    q result
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存测试方法
/// Table：User.MKBAssessmentBase
/// Input：
/// Return:
/// Other: w ##class(web.DHCBL.MKB.MKBAssessmentBase).SaveTest()
ClassMethod SaveTest()
{
    s eobj = ##class(web.Entity.MKB.MKBAssessmentBase).%New()
    s eobj.MKBABRowId = ""
    s eobj.MKBABCode = ..GenerateCode()
    s eobj.MKBABDesc = "IPI评分"
    s eobj.MKBABNote = "无聊"
    s result = ..SaveEntity(eobj)
    q result
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.MKB.MKBAssessmentBase).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="", myInfo=""
    s docFlag=$d(^User.DHCDSSAssConDocI("AssIndex",id))
    if (docFlag){  
	    s myInfo=myInfo_"<评估表关联文献>"   
    }
    s deptFlag=$d(^User.DHCDSSAssConDeptI("AssIndex",id))
    if (deptFlag){  
	    s myInfo=myInfo_"<评估表关联科室>"   
    }  
    s basicFlag=$d(^User.DHCDSSAssBasicInfoI("AssIndex",id))
    if (basicFlag){  
	    s myInfo=myInfo_"<评估表基本信息>"   
    }  
    s keyWordsFlag=$d(^User.DHCDSSAssKeyWordsI("AssIndex",id))
    if (keyWordsFlag){  
	    s myInfo=myInfo_"<评估表关联关键字>"   
    } 
    s diaFlag=$d(^User.DHCDSSDiseJoinAssessmentI("AssIndex",id))
    if (diaFlag){  
	    s myInfo=myInfo_"<评估表关联疾病>"   
    } 
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"里被引用，不能删除!"
 	q return
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存方法
/// Table：User.MKBAssessmentBase
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.DHCBL.MKB.MKBAssessmentBase).DeleteData(3)
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s errorinfo = ##class(web.DHCBL.MKB.MKBReference).DeleteData("ASS",id)
    if (errorinfo'="")
    {
	    s result = "{success:'false',info:'"_errorinfo_"'}"
        q result 	 
	}
	//关联表删除判断
	s re=..GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=1)  //未被引用
	{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
		q result
	}
    if ($D(^User.MKBAssessmentBaseD(id))=0)
    {
        s result = "{success:'false',info:'输入的id不存在'}"
        q result    
    }
    s eobj = ##class(web.Entity.MKB.MKBAssessmentBase).%New()
    s obj = ##class(User.MKBAssessmentBase).%OpenId(id)
    
    s eobj.MKBABRowId = id
    s eobj.MKBABCode = obj.MKBABCode
    s eobj.MKBABDesc = obj.MKBABDesc
    s eobj.MKBABNote = obj.MKBABNote
    
    d obj.%Close()
    k obj
    
    Tstart
    
    s sc=##class(User.MKBAssessmentBase).%DeleteId(id)
    if $$$ISOK(sc)
    {
        d eobj.%Close()
        Tcommit
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_AssessmentBase","User.MKBAssessmentBase","评估表注册",id,eobj.MKBABDesc,"D",eobj)
        s result="{success:'true',info:'删除成功！'}"
    }
    else
    {
        Tro
        s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
    }
    q result
}

/// w ##class(web.DHCBL.MKB.MKBAssessmentBase).AssessmentLock(87)
ClassMethod AssessmentLock(id) As %String
{
	s ^TMP("Lock","Assessment"_id,"Y")=""
	q ""
}

/// 解锁
/// w ##class(web.DHCBL.MKB.MKBAssessmentBase).unLockMethod(5)
ClassMethod unLockMethod(id) As %String
{
	k ^TMP("Lock","Assessment"_id)
	q ""
}

/// w ##class(web.DHCBL.MKB.MKBAssessmentBase).AssessmentReadLock(87)
ClassMethod AssessmentReadLock(id) As %String
{
	S Flag=""
	IF ($D(^TMP("Lock","Assessment"_id))=0)
	{
		//未锁死
		s Flag="N"	
	}
	else
	{
		//锁死
		s Flag="Y"	
	}
	q Flag
}

/// 取平台配置的密码
/// w ##class(web.DHCBL.MKB.MKBAssessmentBase).findPassWord()
ClassMethod findPassWord() As %String
{
	//取index
	s pwIndex=""
	s pwIndex=$o(^User.BDPPlatformConfigI("ConfigCodeI"," ASSESSPASSWORD",0))
	s password=$LISTGET($G(^User.BDPPlatformConfigD(pwIndex)),3)
	q password
}

}
