/// Creator:李欣
/// CreatDate:2018-05-10
/// Table：CT.WDT.CDSS.AssBase
Class web.CDSS.Access.AssBase Extends %RegisteredObject
{

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：查询评分表注册表内容
/// Table：CT.WDT.CDSS.AssBase
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Access.AssBase","GetList","","","","","","","","","","","","")
Query GetList(rowid As %String, desc As %String, keywords As %String, disease As %String, dept As %String, updateuser As %String, audituser As %String, state As %String, starttime As %String, endtime As %String, version As %String, coniws As %String, type As %String) As %Query(ROWSPEC = "MKBABRowId,MKBABCode,MKBABDesc,MKBABNote,MKBABVersion,MKBABState,MKBABUpdateUser,MKBABUpdateDate,MKBABAuditUser,MKBABAuditDate,SpecialFlag,MKBABType,IsConWordsFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, keywords As %String, disease As %String, dept As %String, updateuser As %String, audituser As %String, state As %String, starttime As %String, endtime As %String, version As %String, coniws As %String, type As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1

    if (rowid'="") //根据rowid返回该条记录
    {
        s MKBABRowId=rowid
        s MKBABCode=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),2)
        s MKBABDesc=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),3)
        s MKBABNote=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),4)
        s MKBABVersion=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),5)
        s MKBABState=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),6)
        s MKBABUpdateUser=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),7)
        s MKBABUpdateDate=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),8)
        s MKBABAuditUser=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),9)
        s MKBABAuditDate=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),10)
        s MKBABType=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),11)
        d OutputRow
    }
    else
    {
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s:version'="" version=$ZCONVERT(version,"U") //转换成大写
        s:updateuser'="" updateuser=$ZCONVERT(updateuser,"U") //转换成大写
        s:audituser'="" audituser=$ZCONVERT(audituser,"U") //转换成大写
        s:keywords'="" keywords=$ZCONVERT(keywords,"U") //转换成大写
        s MKBABRowId=""
        for
        {  
            s MKBABRowId=$o(^CT.WDT.CDSS.AssBaseD(MKBABRowId),-1) 
            q:MKBABRowId=""  
			
			if keywords'=""
			{
				s KeyWordsId=0
				for
				{
					s KeyWordsId=$o(^CT.WDT.CDSS.AssKeyWordsI("AssIndex",MKBABRowId,KeyWordsId))
					q:KeyWordsId=""
					s KeyWords=$LISTGET($G(^CT.WDT.CDSS.AssKeyWordsD(KeyWordsId)),3)
					q:($ZCONVERT(KeyWords,"U")[keywords)
				}
				continue:(KeyWordsId="")
			}
			continue:((disease'="")&&($d(^CT.WDT.CDSS.DiseJoinAssessI("RatingScaleDRIndex",disease,MKBABRowId))=0))
			continue:((dept'="")&&($d(^CT.WDT.CDSS.AssConDeptI("DeptAssIndex",dept,MKBABRowId))=0))
            s MKBABCode=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),2)
            s MKBABDesc=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),3)
            s MKBABNote=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),4)
            s MKBABVersion=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),5)
            continue:((version'="")&&($ZCONVERT(MKBABVersion,"U")'[version))
	        s MKBABState=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),6)
	        continue:((state'="")&&(MKBABState'=state))
	        s MKBABUpdateUser=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),7)
	        continue:((updateuser'="")&&($ZCONVERT(MKBABUpdateUser,"U")'[updateuser))
	        s MKBABUpdateDate=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),8)
	        continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(MKBABUpdateDate,3)))
        	continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(MKBABUpdateDate,3)))
	        s MKBABAuditUser=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),9)
	        continue:((audituser'="")&&($ZCONVERT(MKBABAuditUser,"U")'[audituser))
	        s MKBABAuditDate=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),10)
	        s MKBABType=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),11)
	        continue:((type'="")&&(MKBABType'=type))
	        s SpecialFlag=0
           	if $d(^CT.WDT.CDSS.AssConResCondiI("AssIndex",MKBABRowId))
           	{
	        	s SpecialFlag=1 	
	        }
	        s IsConWordsFlag=0
	        if $d(^CT.WDT.CDSS.AssBaseFieldI("ParIndex",MKBABRowId))
	        {
		        s FieldId=0
		    	for
		    	{
			    	 s FieldId=$o(^CT.WDT.CDSS.AssBaseFieldI("ParIndex",MKBABRowId,FieldId))
			    	 q:FieldId=""
			    	 s MKBABFIdentifyWords=$LG($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId,"ChildField",FieldId)),10)
			    	 if MKBABFIdentifyWords'=""
			    	 {
				          s IsConWordsFlag=1	
				          q  
				   	 }
			   	}   
		    }
	        continue:((coniws'="")&(IsConWordsFlag'=coniws))
            s MKBABDescPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBABDesc)  
            s MKBABDescPY = $TR(MKBABDescPY,"_","")
            s AliasName=""
            s BaseId=$o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",MKBABRowId,0))
            s:BaseId'="" AliasName=$LISTGET($G(^CT.WDT.CDSS.AssBasicInfoD(BaseId)),21)
            if (($ZCONVERT(MKBABDesc,"U")[desc)||(MKBABDescPY[desc)||(AliasName[desc))
            {
                d OutputRow
            }
        }
    }
 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(MKBABRowId,MKBABCode,MKBABDesc,MKBABNote,MKBABVersion,MKBABState,MKBABUpdateUser,MKBABUpdateDate,MKBABAuditUser,MKBABAuditDate,SpecialFlag,MKBABType,IsConWordsFlag)
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

/// Creator：石萧伟
/// CreatDate: 2021-12-02
/// Description：查询评分表注册表内容
/// Table：CT.WDT.CDSS.AssBase
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Access.AssBase","GetDataForCom1","","test","")
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
        s MKBABDesc=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),3)
        d OutputRowCmb
    }
    else
    {
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s:q'="" q=$ZCONVERT(q,"U") //转换成大写
        s MKBABRowId=""
        for
        {  
            s MKBABRowId=$o(^CT.WDT.CDSS.AssBaseD(MKBABRowId),-1)
            q:MKBABRowId=""  

            s MKBABDesc=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),3)
            
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
/// Table：CT.WDT.CDSS.AssBase
/// Input：
/// Other: w ##class(web.CDSS.Access.AssBase).GenerateCode()
ClassMethod GenerateCode()
{
    if ($D(^CT.WDT.CDSS.AssBaseI("CodeIndex"))=0)
    {
        s code = "B00000001"    
    }
    else
    {
        s pre = $O(^CT.WDT.CDSS.AssBaseI("CodeIndex",""),-1)
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
/// Table：CT.WDT.CDSS.AssBase
/// Input：id, desc
/// Other: w ##class(web.CDSS.Access.AssBase).Validate("","测试",2)
ClassMethod Validate(id, desc, version)
{
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s:version'="" version=$ZCONVERT(version,"U") //转换成大写
    s flag="",flagd=""
    s:desc'="" flagd=$d(^CT.WDT.CDSS.AssBaseI("DescVersionIndex"," "_desc," "_version))
    if (id="") //如果为空，增加时的重复判断
    {
        if (flagd>0) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idd=""
        s:desc'="" idd=$o(^CT.WDT.CDSS.AssBaseI("DescVersionIndex"," "_desc," "_version,0))
        if ((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.AssBase
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.Access.AssBase).SaveEntity()
ClassMethod SaveEntity(eobj As web.CDSSEntity.Access.AssBase) As %String
{
    s result=""
    if $IsObject(eobj)
    { 
        s flag=..Validate(eobj.MKBABRowId,eobj.MKBABDesc,eobj.MKBABVersion)   
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.MKBABRowId="")  //如果RowId未赋值则增加
            { 
                s obj=##class(CT.WDT.CDSS.AssBase).%New()
            }
            else   //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.AssBase).%OpenId(eobj.MKBABRowId)
                s bobj=##class(web.CDSSEntity.Access.AssBase).%New()
                s bobj.MKBABRowId = obj.%Id()
                s bobj.MKBABCode = obj.MKBABCode
                s bobj.MKBABDesc = obj.MKBABDesc
                s bobj.MKBABNote = obj.MKBABNote
                s bobj.MKBABVersion=obj.MKBABVersion
                s bobj.MKBABState=obj.MKBABState
                s bobj.MKBABUpdateUser=obj.MKBABUpdateUser
                s bobj.MKBABUpdateDate=obj.MKBABUpdateDate
                s bobj.MKBABAuditUser=obj.MKBABAuditUser
                s bobj.MKBABAuditDate=obj.MKBABAuditDate
                s bobj.MKBABType=obj.MKBABType
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
            s obj.MKBABVersion=eobj.MKBABVersion
            s obj.MKBABState=eobj.MKBABState
            //s obj.MKBABUpdateUser=$g(%session.Data("LOGON.USERNAME"))
            s obj.MKBABUpdateDate=$ZDT($H,3)
            s obj.MKBABAuditUser=eobj.MKBABAuditUser
            s obj.MKBABAuditDate=eobj.MKBABAuditDate 
            s obj.MKBABType=eobj.MKBABType
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            s id=""
            If $$$ISOK(sc)
            {
                tc
                //保存日志
                s id = obj.%Id()
                d:eobj.MKBABRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssBase","CT.WDT.CDSS.AssBase","评估表注册",id,eobj.MKBABDesc,"A",eobj)
                d:eobj.MKBABRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssBase","CT.WDT.CDSS.AssBase","评估表注册",eobj.MKBABRowId,eobj.MKBABDesc,"U",eobj,bobj)
                s result = "{success:'true',id:'"_id_"'}"
                
                //同步修改识别词项目数据
                d:eobj.MKBABRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("评估表名称",eobj.MKBABDesc,bobj.MKBABDesc)  
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
                ;s errortip = $SYSTEM.Status.GetErrorText(sc)
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("评估表注册","web.CDSS.Access.AssBase","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
            }
        }
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
        s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("评估表注册","web.CDSS.Access.AssBase","SaveEntity","")
        //s ^ERRORLOGINFO(logid)="对象不存在！"   
    } 
    q result
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存测试方法
/// Table：CT.WDT.CDSS.AssBase
/// Input：
/// Return:
/// Other: w ##class(web.CDSS.Access.AssBase).SaveTest()
ClassMethod SaveTest()
{
    s eobj = ##class(web.CDSSEntity.Access.AssBase).%New()
    s eobj.MKBABRowId = ""
    s eobj.MKBABCode = ..GenerateCode()
    s eobj.MKBABDesc = "IPI评分"
    s eobj.MKBABNote = "无聊"
    s result = ..SaveEntity(eobj)
    q result
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.AssBase
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.CDSS.Access.AssBase).DeleteData(34)
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    /*s errorinfo = ##class(web.DHCBL.MKB.MKBReference).DeleteData("ASS",id)
    if (errorinfo'="")
    {
	    s result = "{success:'false',info:'"_errorinfo_"'}"
        q result 	 
	}*/
    if ($D(^CT.WDT.CDSS.AssBaseD(id))=0)
    {
        s result = "{success:'false',info:'输入的id不存在'}"
        q result    
    }
    s Desc=$lg($g(^CT.WDT.CDSS.AssBaseD(id)),3)
    s errorinfo=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("评估表名称",Desc)
    if (errorinfo'="")
    {
	    s result = "{success:'false',info:'在"_errorinfo_"表里被引用,不能删除!'}"
        q result 	 
	}
	s errorinfo=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("评估表",id)
	if errorinfo'=""
	{
		s result = "{success:'false',info:'在<循证规则>"_errorinfo_"表里被引用,不能删除!'}"
		q result
	}
	
    s eobj = ##class(web.CDSSEntity.Access.AssBase).%New()
    s obj = ##class(CT.WDT.CDSS.AssBase).%OpenId(id)
    
    s eobj.MKBABRowId = id
    s eobj.MKBABCode = obj.MKBABCode
    s eobj.MKBABDesc = obj.MKBABDesc
    s eobj.MKBABNote = obj.MKBABNote
    s eobj.MKBABVersion=obj.MKBABVersion
    s eobj.MKBABState=obj.MKBABState
    s eobj.MKBABUpdateUser=obj.MKBABUpdateUser
    s eobj.MKBABUpdateDate=obj.MKBABUpdateDate
    s eobj.MKBABAuditUser=obj.MKBABAuditDate
    s eobj.MKBABAuditDate=obj.MKBABUpdateDate
    s eobj.MKBABType=obj.MKBABType
    
    d obj.%Close()
    k obj
    
    Tstart
    s sc=##class(CT.WDT.CDSS.AssBase).%DeleteId(id)
    if $$$ISOK(sc)
    {
        d eobj.%Close()
        Tcommit
        d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssBase","CT.WDT.CDSS.AssBase","评估表注册",id,eobj.MKBABDesc,"D",eobj)
        s result="{success:'true',info:'删除成功！'}"
    }
    else
    {
        Tro
        s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
    }
    q result
}

/// w ##class(web.CDSS.Access.AssBase).AssessmentLock(87)
ClassMethod AssessmentLock(id) As %String
{
	s ^TMP("Lock","Assessment"_id,"Y")=""
	q ""
}

/// 解锁
/// w ##class(web.CDSS.Access.AssBase).unLockMethod(5)
ClassMethod unLockMethod(id) As %String
{
	k ^TMP("Lock","Assessment"_id)
	q ""
}

/// w ##class(web.CDSS.Access.AssBase).AssessmentReadLock(87)
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
/// w ##class(web.CDSS.Access.AssBase).findPassWord()
ClassMethod findPassWord() As %String
{
	//取index
	s pwIndex=""
	s pwIndex=$o(^User.BDPPlatformConfigI("ConfigCodeI"," ASSESSPASSWORD",0))
	s password=$LISTGET($G(^User.BDPPlatformConfigD(pwIndex)),3)
	q password
}

/// Creator:Xuwenhu
/// CreatDate:2021-11-10
/// Description:根据评估表ID获取该评估表的状态变化的日志 生成临时global
/// Input: AssRowId-评估表ID
/// Return: 是否成功 
/// others:w ##class(web.CDSS.Access.AssBase).CreateTEMPLogGlobal("182")
ClassMethod CreateTEMPLogGlobal(AssRowId As %String)
{
	s str="sucess"	
	k ^TEMPAssLog
	
    //状态发生变化的日志
	s ID="",ClassName="CT.WDT.CDSS.AssBase"
    for
    {
    	s ID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex",ClassName,AssRowId,ID)) q:ID=""
    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),7)
    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),8)
      	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),9)
      	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),13)   //新增对象描述
      	if (ObjectDesc["&&")
      	{
          	s Opreation=$p(ObjectDesc,"&&",2)
          	s ^TEMPAssLog("AssLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^"_Opreation
        }
     	else
     	{
      		s ^TEMPAssLog("AssLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^"_"编辑中"
     	}
    }
	q str
}

/// Creator:Xuwenhu
/// CreatDate:2021-11-10
/// Description:根据评估表ID获取该评估表的状态变化的日志
/// Table: User.DHCDSSRuleDict、User.BDPDataChangeLog
/// Input: AssRowId 规则ID
/// Return:返回规则ID获取该规则的状态变化的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Access.AssBase","GetAssLogList","33")
Query GetAssLogList(AssRowId As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Opreation")
{
}

ClassMethod GetAssLogListExecute(ByRef qHandle As %Binary, AssRowId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s str="",preUpdateUserName="",preOpreation=""
 	if (AssRowId'="") s str=..CreateTEMPLogGlobal(AssRowId)
 	if (str="sucess")
 	{
	 	s UpdateDateID=""
		for
		{
			s UpdateDateID = $o(^TEMPAssLog("AssLog",UpdateDateID),-1) q:UpdateDateID=""
			s UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDateID)
			s UpdateTimeID=""
		    for
		    {
		    	s UpdateTimeID=$o(^TEMPAssLog("AssLog",UpdateDateID,UpdateTimeID),-1) q:UpdateTimeID=""
		    	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTimeID) 
		    	s LogID=$P(^TEMPAssLog("AssLog",UpdateDateID,UpdateTimeID),"^",1)
		    	s UpdateUserName=$P(^TEMPAssLog("AssLog",UpdateDateID,UpdateTimeID),"^",2)
		    	s Opreation=$P(^TEMPAssLog("AssLog",UpdateDateID,UpdateTimeID),"^",3)
		    	continue:(preOpreation=Opreation)&&(preUpdateUserName=UpdateUserName) 
		    	s preOpreation=Opreation
		    	s preUpdateUserName=UpdateUserName	
		    	d OutputRowLog
		    }
	    }
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLog
	set Data=$lb(LogID,UpdateDate,UpdateTime,UpdateUserName,Opreation)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAssLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAssLogListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAssLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAssLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Xuwenhu
/// CreatDate:2021-11-10
/// Input:RowId AssID Opreation 操作
/// Return:
/// Other:w ##class(web.CDSS.Access.AssBase).ChangeState(288,"1")
ClassMethod ChangeState(RowId, Operation)
{
	s result=""
	s eobj=##class(web.CDSSEntity.Access.AssBase).%New()
	s State=$case(Operation,0:"编辑中",1:"待审核",2:"审核不通过",3:"已上线",4:"已下线",5:"审核通过",:"编辑中")
	s eobj.MKBABState=State

	s obj=##class(CT.WDT.CDSS.AssBase).%OpenId(RowId)
	s bobj=##class(web.CDSSEntity.Access.AssBase).%New()
	s bobj.MKBABRowId=RowId
 	s bobj.MKBABState=obj.MKBABState
 	s bobj.MKBABUpdateDate=obj.MKBABUpdateDate							//编辑时间
 	s bobj.MKBABUpdateUser=obj.MKBABUpdateUser							//编辑人
 	s bobj.MKBABAuditDate=obj.MKBABAuditDate							//审核时间
 	s bobj.MKBABAuditUser=obj.MKBABAuditUser							//审核人

 	s obj.MKBABState=State
 	if ((Operation="0")||(Operation="1"))
	{
		s eobj.MKBABUpdateUser=$g(%session.Data("LOGON.USERNAME"))
 		s eobj.MKBABUpdateDate=$zdt($h,3)
 		s obj.MKBABUpdateUser=$g(%session.Data("LOGON.USERNAME"))
 		s obj.MKBABUpdateDate=$zdt($h,3)	
	}
 	if ((Operation="2")||(Operation="3")||(Operation="4")||(Operation="5"))
	{
		s eobj.MKBABAuditUser=$g(%session.Data("LOGON.USERNAME"))		//审核人
		s eobj.MKBABAuditDate=$ZDT($H,3)
		s obj.MKBABAuditUser=$g(%session.Data("LOGON.USERNAME"))
 		s obj.MKBABAuditDate=$zdt($h,3)								//审核时间
	}
 	
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
    {
        tc
        //保存日志
        s id = obj.%Id()
        s result="{success:'true'}"
        //保存日志 描述拼接操作，在日志中读取显示
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssBase","CT.WDT.CDSS.AssBase","评估表注册",RowId,obj.MKBABDesc_"&&"_eobj.MKBABState,"U",eobj,bobj)    
    }
    else
    {
        Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("评估表注册","web.CDSS.Access.AssBase","ChangeState",eobj)
   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
    }
 	
	q result
}

/// Creator:Xuwenhu
/// CreatDate:2021-11-11
/// Description:导出评估表字典数据
/// Table:
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.Access.AssBase).ExportData("","")
ClassMethod ExportData(desc As %String, version As %String) As %String
{
	s sum=0
	
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"评估表字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	*/
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"评估表字典数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file = Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file = Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){	//文件保存路径不存在，新建文件夹
		d ##class(%File).CreateDirectoryChain(DirName)
	}
	
	o file:"NWS"
	u file
	w "评估表名称	版本号	类型	就诊类型	结果解读	文献出处	相关解释	备注	关联科室	关联疾病	关联关键字	最后编辑时间"
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:version'="" version=$ZCONVERT(version,"U") //转换成大写
	
	s MKBABRowId=""
    for
    {  
        s MKBABRowId=$o(^CT.WDT.CDSS.AssBaseD(MKBABRowId),-1) 
        q:MKBABRowId=""  
        s MKBABCode=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),2)
        s MKBABDesc=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),3)
        s MKBABNote=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),4)
        s MKBABVersion=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),5)
        continue:((version'="")&&($ZCONVERT(MKBABVersion,"U")'[version))
        s MKBABState=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),6)
        s MKBABUpdateUser=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),7)
        s MKBABUpdateDate=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),8)
        s MKBABAuditUser=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),9)
        s MKBABAuditDate=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),10)
        s MKBABType=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),11)
        s SpecialFlag=0
       	if $d(^CT.WDT.CDSS.AssConResCondiI("AssIndex",MKBABRowId))
       	{
        	s SpecialFlag=1 	
        }
       	//基本信息
       	s (VisitType,ResultExplain,DocSource,RelatedExplain)=""
       	if $d(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",MKBABRowId))
       	{
	       	s BasicId=$o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",MKBABRowId,0))
	    	s VisitType=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(BasicId)),14)		//就诊类型
	    	s ResultExplain=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(BasicId)),11)		//结果解读
	    	s DocSource=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(BasicId)),3)			//文献来源
	    	s RelatedExplain=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(BasicId)),12)		//相关解释
	    }
       	//关联科室
       	s DeptDescStr=""
       	if $d(^CT.WDT.CDSS.AssConDeptI("AssIndex"))
       	{
	       	s DeptDescStr=""
	       	s DeptId=0
	       	for 
	       	{
		    	s DeptId=$o(^CT.WDT.CDSS.AssConDeptI("AssIndex",MKBABRowId,DeptId))
		    	q:DeptId=""
		    	s DeptDR=$lg($g(^CT.WDT.CDSS.AssConDeptD(DeptId)),3)
		    	s DeptDesc=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)		//科室名称
		    	s:DeptDescStr="" DeptDescStr=DeptDesc
		    	s:DeptDescStr'="" DeptDescStr=DeptDescStr_"|"_DeptDesc
		   	}
	    }
       	//关联关键字
       	s KeyWordsStr=""
       	if $d(^CT.WDT.CDSS.AssKeyWordsI("AssIndex"))
       	{
	       	s KeyWordsStr=""
	       	s KeyWordId=0
	       	for 
	       	{
		    	s KeyWordId=$o(^CT.WDT.CDSS.AssKeyWordsI("AssIndex",MKBABRowId,KeyWordId))
		    	q:KeyWordId=""
		    	s KeyWordsDesc=$lg($g(^CT.WDT.CDSS.AssKeyWordsD(KeyWordId)),3)		//关联关键字
		    	s:KeyWordsStr="" KeyWordsStr=KeyWordsDesc
		    	s:KeyWordsStr'="" KeyWordsStr=KeyWordsStr_"|"_KeyWordsDesc
		   	}
	    }
       	//关联疾病
       	s DiseStr=""
       	if $d(^CT.WDT.CDSS.DiseJoinAssessI("AssIndex"))
       	{
	       	s DiseStr=""
	       	s DiseId=0
	       	for 
	       	{
		    	s DiseId=$o(^CT.WDT.CDSS.DiseJoinAssessI("AssIndex",MKBABRowId,DiseId))
		    	q:DiseId=""
		    	s DiseDR=$lg($g(^CT.WDT.CDSS.DiseJoinAssessD(DiseId)),2)		
		    	s DiseDesc=$lg($g(^CT.WDT.CDSS.DiseJoinAssessD(DiseDR)),3)		//疾病名称
		    	s:DiseStr="" DiseStr=DiseDesc
		    	s:DiseStr'="" DiseStr=DiseStr_"|"_DiseDesc
		   	}
	    }
       	
        s MKBABDescPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBABDesc)  
        s MKBABDescPY = $TR(MKBABDescPY,"_","")
        if (($ZCONVERT(MKBABDesc,"U")[desc)||(MKBABDescPY[desc))
        {
            w !,MKBABDesc_"	"_MKBABVersion_"	"_MKBABType_"	"_VisitType_"	"_ResultExplain_"	"_DocSource_"	"_RelatedExplain_"	"_MKBABNote_"	"_DeptDescStr_"	"_DiseStr_"	"_KeyWordsStr
        }	
	}
	c file
	q fileName
}

/// Creator:Xuwenhu
/// CreatDate:2021-11-11
/// Description:导出评估表字典数据[停用]
/// Table:
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.Access.AssBase).ExportData2()
ClassMethod ExportData2() As %String
{
	s sum=0
	
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="评估表字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
	o file:"NWS"
	u file
	w "评估表名称	题干序号	题目	选项"
	
	s MKBABRowId=""
    for
    {  
        s MKBABRowId=$o(^CT.WDT.CDSS.AssBaseD(MKBABRowId),-1) 
        q:MKBABRowId=""  
        s MKBABCode=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),2)
        s MKBABDesc=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),3)
        s MKBABFSequence = ""
		for
		{
			s MKBABFSequence = $O(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",MKBABRowId,MKBABFSequence))
			q:MKBABFSequence=""
			s MKBABFChildSub = 0
			for
			{
				s MKBABFChildSub = $O(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",MKBABRowId,MKBABFSequence,MKBABFChildSub))
				q:MKBABFChildSub=""
				s MKBABFRowId = MKBABRowId_"||"_MKBABFChildSub
				s MKBABFCode = $LG($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId,"ChildField",MKBABFChildSub)),2)
				s MKBABFDesc = $LG($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId,"ChildField",MKBABFChildSub)),3)
				s MKBABFConfig = $LG($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId,"ChildField",MKBABFChildSub)),5)
				for i=1:1:$l(MKBABFConfig,"&%")-1
				{
					s Text=$p($p(MKBABFConfig,"&%",i),"[BDP]",1)
					w !,MKBABDesc_"	"_MKBABFSequence_"	"_MKBABFDesc_"	"_Text
				}
			}
		}	
	}
	c file
	q fileName
}

/// Creator：Xuwenhu
/// CreatDate: 2018-05-10
/// Description：查询评分表注册表内容[停用]
/// Table：CT.WDT.CDSS.AssBase
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Access.AssBase","GetOpList")
Query GetOpList() As %Query(ROWSPEC = "MKBABDesc,MKBABFSequence,MKBABFDesc,Text,OptionSeq,MKBABFRowId")
{
}

ClassMethod GetOpListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1

    s MKBABRowId=""
    for
    {  
        s MKBABRowId=$o(^CT.WDT.CDSS.AssBaseD(MKBABRowId),-1) 
        q:MKBABRowId=""  
        s MKBABCode=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),2)
        s MKBABDesc=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId)),3)
        s MKBABFSequence = ""
		for
		{
			s MKBABFSequence = $O(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",MKBABRowId,MKBABFSequence))
			q:MKBABFSequence=""
			s MKBABFChildSub = 0
			for
			{
				s MKBABFChildSub = $O(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",MKBABRowId,MKBABFSequence,MKBABFChildSub))
				q:MKBABFChildSub=""
				s MKBABFRowId = MKBABRowId_"||"_MKBABFChildSub
				s MKBABFCode = $LG($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId,"ChildField",MKBABFChildSub)),2)
				s MKBABFDesc = $LG($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId,"ChildField",MKBABFChildSub)),3)
				s MKBABFConfig = $LG($G(^CT.WDT.CDSS.AssBaseD(MKBABRowId,"ChildField",MKBABFChildSub)),5)
				for i=1:1:$l(MKBABFConfig,"&%")-1
				{
					s Text=$p($p(MKBABFConfig,"&%",i),"[BDP]",1)
					s OptionSeq=i
					//w !,MKBABDesc_"	"_MKBABFSequence_"	"_MKBABFDesc_"	"_Text
					d OutputRow
				}
			}
		}	
	}
 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(MKBABDesc,MKBABFSequence,MKBABFDesc,Text,OptionSeq,MKBABFRowId)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetOpListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetOpListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpListExecute ]
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

/// Creator:Xuwenhu
/// CreatDate:2022-01-20
/// Description:数据统计
/// Table:CT.WDT.CDSS.AssBase
/// Input:
/// Return:总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Others:w ##class(web.CDSS.Access.AssBase).CountData()
ClassMethod CountData() As %String
{
	s (EditNum,AuditNum,StayNum,AllNum)=0
	s SQL="SELECT MKBAB_State AS state,Count(*) AS num FROM CT_WDT_CDSS.AssBase GROUP BY MKBAB_State"
	s tStatement=##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(SQL)
	if qStatus '= 1 
	{
		w "%Prepare failed:"
		d $System.status.DisplayError(qStatus)
		q
	}
	s rset = tStatement.%Execute()
	while rset.%Next() 
	{
		if ((rset.state="")||(rset.state="编辑中"))
		{
			s EditNum=EditNum+rset.num		
		}
		if ((rset.state="审核通过")||(rset.state="已上线"))
		{
			s AuditNum=AuditNum+rset.num	
		}
		if rset.state="待审核"
		{
			s StayNum=StayNum+rset.num	
		}
		s AllNum=AllNum+rset.num
	}
	q AllNum_"^"_EditNum_"^"_AuditNum_"^"_StayNum
}

/// Description:用临时global导入数据
/// ^MTEMPMKBAssBaseD
/// Test: w ##class(web.CDSS.Access.AssBase).DataImport("569")
ClassMethod DataImport(id) As %String
{
	
	s MKBABCode=$LISTGET($G(^MTEMPMKBAssBaseD(id)),2)
    s MKBABDesc=$LISTGET($G(^MTEMPMKBAssBaseD(id)),3)
    s MKBABNote=$LISTGET($G(^MTEMPMKBAssBaseD(id)),4)
	
	s eobj=##class(web.CDSSEntity.Access.AssBase).%New()
	s eobj.MKBABCode=MKBABCode
	s eobj.MKBABDesc=MKBABDesc
	s eobj.MKBABNote=MKBABNote
	
	s result=..SaveEntity(eobj)
	w result,!
	s NewBaseID=$e(result,21,*-2)
	
	s MKBABFChildSub = 0
	for
	{
		s MKBABFChildSub = $O(^MTEMPMKBAssBaseD(id,"ChildField",MKBABFChildSub))
		q:MKBABFChildSub=""
		s MKBABFRowId = id_"||"_MKBABFChildSub
		s MKBABFCode = $LG($G(^MTEMPMKBAssBaseD(id,"ChildField",MKBABFChildSub)),2)
		s MKBABFDesc = $LG($G(^MTEMPMKBAssBaseD(id,"ChildField",MKBABFChildSub)),3)
		s MKBABFType = $LG($G(^MTEMPMKBAssBaseD(id,"ChildField",MKBABFChildSub)),4)
		s MKBABFConfig = $LG($G(^MTEMPMKBAssBaseD(id,"ChildField",MKBABFChildSub)),5)
		s MKBABFSequence = $LG($G(^MTEMPMKBAssBaseD(id,"ChildField",MKBABFChildSub)),6)
		
		s str=NewBaseID_"&^&^"_MKBABFCode_"&^"_MKBABFDesc_"&^"_MKBABFType_"&^"_MKBABFConfig_"&^"_MKBABFSequence
		w ##class(web.CDSS.Access.AssBaseField).SaveEntity(str),!
	}	
	s MKBASRChild = 0
	for
	{
		s MKBASRChild = $O(^MTEMPMKBAssBaseD(id,"ChildRules",MKBASRChild))
		q:MKBASRChild=""
		
		s MKBASRRowId = id_"||"_MKBASRChild
		s MKBASRCode = $LG($G(^MTEMPMKBAssBaseD(id,"ChildRules",MKBASRChild)),2)
		s MKBASRDesc = $LG($G(^MTEMPMKBAssBaseD(id,"ChildRules",MKBASRChild)),3)
		s MKBASRMinValue = $LG($G(^MTEMPMKBAssBaseD(id,"ChildRules",MKBASRChild)),4)
		s MKBASRMaxValue = $LG($G(^MTEMPMKBAssBaseD(id,"ChildRules",MKBASRChild)),5)
		s MKBASRRank = $LG($G(^MTEMPMKBAssBaseD(id,"ChildRules",MKBASRChild)),6)
		
		s str2=NewBaseID_"&^&^"_MKBASRCode_"&^"_MKBASRDesc_"&^"_MKBASRMinValue_"&^"_MKBASRMaxValue_"&^"_MKBASRRank
		w ##class(web.CDSS.Access.AssScoringRules).SaveEntity(str2),!
	}	
	
	q "success"
}

/// Creator：Xuwenhu
/// CreatDate: 2022-11-14
/// Description：导入数据
/// Table:
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.Access.AssBase).ImportDataTXT("D:\Ass2.txt")
ClassMethod ImportDataTXT(path) As %String
{
	s Base=0
	s Basic=0
	s KeC=0
	s DeptC=0
	s DisC=0
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
	s num=0
	
	TS
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		
		s Name=$p(data,"	",1)			
		s Version=$p(data,"	",2)			
		s Type=$p(data,"	",3)	        
		s Conculsion=$p(data,"	",4) 			
		s AliasName=$p(data,"	",5)			
		s VisitType=$p(data,"	",6)			
		s ResultExplain=$p(data,"	",7)		
		s DocSource=$p(data,"	",8)	        
		s RelatedExplain=$p(data,"	",9)	    
		s MKBABNote=$p(data,"	",10)
		s DeptDesc=$p(data,"	",11)
		s Dise=$p(data,"	",12)
		s KeyWordDesc=$p(data,"	",13)

		s AssId=$o(^CT.WDT.CDSS.AssBaseI("DescIndex"," "_$ZCONVERT(Name,"U"),0))
		if AssId=""
		{
			w !,"未找到评估表"_Name
			continue	
		}
		if AssId'=""
		{
			s obj=##class(CT.WDT.CDSS.AssBase).%OpenId(AssId)
			s obj.MKBABVersion=Version
			s obj.MKBABType=Type
			s obj.MKBABNote=MKBABNote
			s sc1=obj.%Save()
			d obj.%Close()	
			if $$$ISOK(sc1)
			{
				s Base=Base+1	
			}
			else
			{
				w !,"Base："_Name
			}
		}
		// jiben
		if $d(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",AssId))
       	{
			s BaseId=$o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",AssId,0))
			s eobj=##class(CT.WDT.CDSS.AssBasicInfo).%OpenId(BaseId)
			s eobj.VisitType=VisitType
			s eobj.ResultExplain=ResultExplain
			s eobj.DocSource=DocSource
			s eobj.RelatedExplain=RelatedExplain
			s sc2=eobj.%Save()
			d eobj.%Close()
			if $$$ISOK(sc2)
			{
				s Basic=Basic+1	
			}
			else
			{
				w !,"Basic："_AssId
			}
	    }
	    else
	    {
			s eobj=##class(CT.WDT.CDSS.AssBasicInfo).%New()
			d eobj.AssDRSetObjectId(AssId)
			s eobj.VisitType=VisitType
			s eobj.ResultExplain=ResultExplain
			s eobj.DocSource=DocSource
			s eobj.RelatedExplain=RelatedExplain
			s sc3=eobj.%Save()
			d eobj.%Close()   
			if $$$ISOK(sc3)
			{
				s Basic=Basic+1	
			}
			else
			{
				w !,"Basic："_AssId
			}
		}
	    // keshi
	    for i=1:1:$l(DeptDesc,"｜")
	    {
		    s Dept=$p(DeptDesc,"｜",i)
		    continue:Dept=""
			s DeptDR=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex"," "_Dept,0))
			if DeptDR=""
			{
				w !,"未找到科室："_Dept
				continue
			}
		    if '$d(^CT.WDT.CDSS.AssConDeptI("DeptAssIndex",DeptDR,AssId))
	       	{
				s sobj=##class(CT.WDT.CDSS.AssConDept).%New()
				d sobj.AssDRSetObjectId(AssId)
				d sobj.DeptDRSetObjectId(DeptDR)
				s sc4=sobj.%Save()
				d sobj.%Close()
				if $$$ISOK(sc4)
				{
					s DeptC=DeptC+1	
				}
				else
				{
					w !,"Dept："_Dept
				}
		    }
	    }
	    // keyword
	    for j=1:1:$l(KeyWordDesc,"｜")
	    {
		    s KeyWord=$p(KeyWordDesc,"｜",j)
		    continue:KeyWord=""
		    if '$d(^CT.WDT.CDSS.AssKeyWordsI("WordsIndex",AssId," "_KeyWord))
	       	{
				s wobj=##class(CT.WDT.CDSS.AssKeyWords).%New()
				d wobj.AssDRSetObjectId(AssId)
				s wobj.KeyWords=KeyWord
				s sc5=wobj.%Save()
				d wobj.%Close()
				if $$$ISOK(sc5)
				{
					s KeC=KeC+1	
				}
				else
				{
					w !,"Key："_KeyWord
				}
		    }
	    }
	    for z=1:1:$l(Dise,"｜")
	    {
		    s Dis=$p(Dise,"｜",z)
		    continue:Dis=""
			s DisDR=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_Dis,0))
			if DisDR=""
			{
				w !,"未找到疾病："_Dis
				s IdenId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_Dis,0))
				if IdenId=""
				{
					w !,"未找到识别词："_Dis
					continue	
				}
				else
				{
					s NodeDR=""
					for
					{
						s NodeDR=$o(^CT.WDT.CDSS.WordsNodeI("WordsTypeIndex",IdenId,6,NodeDR))			//识别条件类型表id
						q:NodeDR=""
						s WordId=""
						for
						{
							s WordId=$o(^CT.WDT.CDSS.WordsConditionI("NodeDRIndex",NodeDR,WordId))
							q:WordId=""
							s WordsItemDR=$lg($g(^CT.WDT.CDSS.WordsConditionD(WordId)),3)					//识别词项目
							s ConditionItemValue=$lg($g(^CT.WDT.CDSS.WordsConditionD(WordId)),9)	//评估表名称
							s WordsItemDesc=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),3)					//类型
							if WordsItemDesc["诊断"
							{
								s DisDR=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_ConditionItemValue,0))									
							}	
						}
					}
				}
			}
		    if '$d(^CT.WDT.CDSS.DiseJoinAssessI("RatingScaleDRIndex",DisDR,AssId))
	       	{
				s dobj=##class(CT.WDT.CDSS.DiseJoinAssess).%New()
				d dobj.DiseaseDRSetObjectId(DisDR)
				d dobj.RatingScaleDRSetObjectId(AssId)
				s sc6=dobj.%Save()
				d dobj.%Close()
				if $$$ISOK(sc6)
				{
					s DisC=DisC+1	
				}
				else
				{
					w !,"Dise："_Dis
				}
		    }
	    }
	}
	q "共读取："_num_",修改Base："_Base_",Basic："_Basic_",Dept："_DeptC_",Key："_KeC_",DisC："_DisC
}

}
