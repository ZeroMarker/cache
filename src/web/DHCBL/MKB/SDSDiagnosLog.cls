/// Creator:高姗姗
/// CreatDate:2019-07-23
/// Description：结构化诊断子表-维护修改历史记录
/// Table：User.SDSDiagnosLog
Class web.DHCBL.MKB.SDSDiagnosLog Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2018-04-12
/// Description：查询结构化诊断历史记录
/// Table：User.SDSDiagnosLog
/// Input：rowid, desc
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosLog).GetLog("20","")
ClassMethod GetLog(parref, desc) As %String
{
  s resultLog=""
  if (parref'=""){
	  d ..GetLogContent(parref)
	  s:desc'="" desc=$ZCONVERT(desc,"U")
	  s rowid=""
	  for{  
		  s rowid=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,parref,rowid)) q:rowid=""   
		  s SDSUpdateUserDR=$LISTGET($G(^User.SDSDiagnosLogD(rowid)),2)
		  i SDSUpdateUserDR'="" s SDSUpdateUser=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetUserLocDesc("U",SDSUpdateUserDR)
		  i SDSUpdateUserDR="" s SDSUpdateUser=""
		  s:SDSUpdateUser'="" PINYINUser= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(SDSUpdateUser)
		  s SDSUpdateDate=$LISTGET($G(^User.SDSDiagnosLogD(rowid)),3)
		  i SDSUpdateDate'="" s SDSUpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(SDSUpdateDate)
		  s SDSUpdateTime=$LISTGET($G(^User.SDSDiagnosLogD(rowid)),4)
		  s SDSOperateType=$LISTGET($G(^User.SDSDiagnosLogD(rowid)),5)
		  i SDSUpdateTime'="" s SDSUpdateTime=$zt(SDSUpdateTime,1)
		  	      
	      s key=""
	      s content=""
	      for{
		      s key=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,parref,rowid,key)) q:key=""
		      if ($g(^TMPSTRUCTDIAGNOSLOG($zn,$j,"Flag",parref,rowid,key))="D"){
			      s keyDesc=$LISTGET($G(^User.MKBTermProDetailD(key)),3)
			  }else{
				  s keyDesc=$LISTGET($G(^User.MKBTermPropertyD(key)),3)
			  }
			  
			  ;属性内容值及描述
			  s oldValue=$p(^TMPSTRUCTDIAGNOSLOG($zn,$j,parref,rowid,key),"&%",1)
			  s oldValueDesc=""
			  if (oldValue'=""){
				  s oldValueLen=$Length(oldValue,"*")
				  for i=1:1:oldValueLen{
					  s oneoldValue=$p(oldValue,"*",i)
					  if (oneoldValue["S"){
						  s oneoldValueDesc=$listGet($g(^User.MKBTermD($p(oneoldValue,"S",2))),3)
					  }else{
						  s oneoldValueDesc=$LISTGET($G(^User.MKBTermProDetailD(oneoldValue)),3)
					  }
					  if (oldValueDesc=""){
						  s oldValueDesc=oneoldValueDesc
					  }else{
						  s oldValueDesc=oldValueDesc_","_oneoldValueDesc 
					  }
				  }
			  }
			  s:oldValueDesc="" oldValueDesc="ø"
			  s newValue=$p(^TMPSTRUCTDIAGNOSLOG($zn,$j,parref,rowid,key),"&%",2)
			  s newValueDesc=""
			  if (newValue'=""){
				  s newValueLen=$Length(newValue,"*")
				  for i=1:1:newValueLen{
					  s onenewValue=$p(newValue,"*",i)
					  if (onenewValue["S"){
						  s onenewValueDesc=$listGet($g(^User.MKBTermD($p(onenewValue,"S",2))),3)
					  }else{
						  s onenewValueDesc=$LISTGET($G(^User.MKBTermProDetailD(onenewValue)),3)
					  }
					  if (newValueDesc=""){
						 s newValueDesc=onenewValueDesc 
					  }else{
						 s newValueDesc=newValueDesc_","_onenewValueDesc 
					  } 
				  }
			  }
			  s:newValueDesc="" newValueDesc="ø"
			  if (SDSOperateType="R"){ //引用类型,颜色区分
				  if (content=""){
					  s content="<a style='color:#FF1493;font-size:16px;'>"_keyDesc_":"_newValueDesc_"<a>"
				  }else{
					  s content=content_"&%<a style='color:#FF1493;font-size:16px;'>"_keyDesc_":"_newValueDesc_"<a>"
				  }
			  }else{ //新增修改类型
				  if (content=""){
					  s content=keyDesc_":"_oldValueDesc_"->"_newValueDesc
				  }else{
					  s content=content_"&%"_keyDesc_":"_oldValueDesc_"->"_newValueDesc
				  }
			  }
			  
		  }
		  //未保存属性情况下显示诊断名
		  if (content=""){
			  s MKBTRowId=$g(^TMPSTRUCTDIAGNOSLOG($zn,$j,parref,rowid))
			  s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3) 
			  s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowId)
			  s strCom=$p(strComAndAlisa,"[A]",1)
			  s comDesc=$p(strCom,"&%",1) //诊断常用名
			  s content=MKBTDesc
			  s:comDesc'="" content=comDesc_"("_MKBTDesc_")" //常用名(中心词)
			  s:comDesc="" content=MKBTDesc_"("_MKBTDesc_")" //中心词(中心词)
			  if (SDSOperateType="R"){ //引用类型,颜色区分
				  s content="<a style='color:#FF1493;font-size:16px;'>"_content_"<a>"
			  }
		  }
		  s:content'="" PINYINContent= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(content)
		  if ((desc="")||((desc'="")&(($ZCONVERT(content,"U")[desc)||(PINYINContent[desc)||($ZCONVERT(SDSUpdateUser,"U")[desc)||(PINYINUser[desc)))){
			  if (resultLog=""){
				  s resultLog=SDSUpdateUser_"^"_SDSUpdateDate_"^"_SDSUpdateTime_"^"_content_"^"_SDSOperateType
			  }else{
				  s resultLog=resultLog_"*"_SDSUpdateUser_"^"_SDSUpdateDate_"^"_SDSUpdateTime_"^"_content_"^"_SDSOperateType
			  }
		  }
	  }
 }
  q resultLog
}

/// Creator：高姗姗
/// CreatDate: 2018-04-12
/// Description：获取结构化诊断历史记录内容
/// Table：User.SDSDiagnosLog
/// Input：rowid, desc
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosLog).GetLogContent("20")
ClassMethod GetLogContent(parref) As %String
{
 	//生成属性(含起始节点)及属性内容的临时global
   k ^TMPSTRUCTDIAGNOSLOG($zn,$j,parref)
   k ^TMPSTRUCTDIAGNOSLOG($zn,$j,"NodeOld",parref)
   k ^TMPSTRUCTDIAGNOSLOG($zn,$j,"NodeNew",parref)
   k ^TMPSTRUCTDIAGNOSLOG($zn,$j,"Flag",parref)
   s SDSTermDR=$LISTGET($G(^User.SDSDiagnosD(parref)),2) //术语id

   q:SDSTermDR="" ""
   d ##Class(web.DHCBL.MKB.SDSDiagnos).GetPropertyByNode(SDSTermDR)

   s rowid=""
   for{  
	   s rowid=$o(^User.SDSDiagnosLogI("RefIndex",parref,rowid)) q:rowid="" 
	   s OldValue=$LISTGET($G(^User.SDSDiagnosLogD(rowid)),6)
	   s NewValue=$LISTGET($G(^User.SDSDiagnosLogD(rowid)),7)
	  
	   /*//OldValue Json转对象，获取Old SDSValue值 //不支持2010
	   s OldValueObj=##class(web.DHCBL.MKB.SDSCommonFromJson).%New()
       s OldFromJSON=OldValueObj.%FromJSON(OldValue)
       s SDSOldValue=OldValueObj.%Get("SDSValue")
       //NewValue Json转对象，获取New SDSValue值
	   s NewValueObj=##class(web.DHCBL.MKB.SDSCommonFromJson).%New()
       s NewFromJSON=NewValueObj.%FromJSON(NewValue)
       s SDSNewValue=NewValueObj.%Get("SDSValue")*/
       //OldValue Json转对象，获取Old SDSValue值
       s SDSOldValue=""
       if (OldValue'=""){
	       //OldValue中逗号与Json转对象方法中逗号冲突，先转为中文逗号，取到SDSValue值
	       s ReOldValue=""
		   s lenJson=$Length(OldValue,""",")
		   for k=1:1:lenJson{
		  	 s json=$p(OldValue,""",",k)
		  	 if (json["SDSValue") s json=$tr(json,",","，")
		  	 if ReOldValue="" s ReOldValue=json
		  	 else  s ReOldValue=ReOldValue_","_json
		   }
		   
		   //s OldValue=$tr(ReOldValue,"""","")
	       s OldFromJSON= ##class(ext.util.JsonObject).FromJSON(OldValue)
	       s:OldFromJSON'="" SDSOldValue=OldFromJSON.GetValue("SDSValue")
	       s SDSOldValue=$tr(SDSOldValue,"，",",") //中文字符再转为英文字符
       }
	   //NewValue Json转对象，获取New SDSValue值
	   s SDSNewValue=""
	   if (NewValue'=""){
		   //NewValue中逗号与Json转对象方法中逗号冲突，先转为中文逗号，取到SDSValue值
		   s ReNewValue=""
		   s lenJson=$Length(NewValue,""",")
		   for k=1:1:lenJson{
		  	 s json=$p(NewValue,""",",k)
		  	 if (json["SDSValue") s json=$tr(json,",","，")
		  	 if ReNewValue="" s ReNewValue=json
		  	 else  s ReNewValue=ReNewValue_","_json
		   }
		   
		   //s NewValue=$tr(ReNewValue,"""","")
		   s NewFromJSON= ##class(ext.util.JsonObject).FromJSON(NewValue)
	       s:NewFromJSON'="" SDSNewValue=NewFromJSON.GetValue("SDSValue")
	       s SDSNewValue=$tr(SDSNewValue,"，",",") //中文字符再转为英文字符
	   }
	   if (SDSOldValue'=""){
		  s len=$Length(SDSOldValue,",")
		  for i=1:1:len{
		  	 s OldVal=$p(SDSOldValue,",",i)
			 s key = $p(OldVal,":",1)
			 s value = $p(OldVal,":",2)
			 s detailLen=$Length(value,"*")
			 for j=1:1:detailLen{
				 s DetailTitleNode=""
				 s detailid=$p(value,"*",j)
				 if (detailid'["S"){
				    s DetailNode=##Class(web.DHCBL.MKB.SDSDiagnos).GetDetailNode(SDSTermDR,detailid)
			  	  	s:DetailNode'="" DetailTitleNode=$LISTGET($G(^User.MKBTermProDetailD(DetailNode)),4)  //诊断模板定义的起始节点
			  		s:DetailNode="" DetailTitleNode=""	
				 }
				 //生成含起始节点临时global
				 if (DetailTitleNode'=""){
					s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"NodeOld",parref,rowid,DetailTitleNode,detailid)=""	
					s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"Flag",parref,rowid,DetailTitleNode)="D"  
				 }else{
					s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"NodeOld",parref,rowid,key,detailid)=""  
					s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"Flag",parref,rowid,key)=""  
				 }
			  	}
		    }
		    s pro=""
		    for {
			    s pro=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"NodeOld",parref,rowid,pro)) q:pro=""
			    s detailItmOld=""
			    s detailid=""
			    for {
				    s detailid=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"NodeOld",parref,rowid,pro,detailid)) q:detailid=""
				    if (detailItmOld=""){
					    s detailItmOld=detailid
					}else{
						s detailItmOld=detailItmOld_"*"_detailid
					}
				    
				}
				s ^TMPSTRUCTDIAGNOSLOG($zn,$j,parref,rowid,pro)=detailItmOld
			}
	    }
	  	 if (SDSNewValue'=""){
		  	s len=$Length(SDSNewValue,",")
		 	for i=1:1:len{
		  		s NewVal=$p(SDSNewValue,",",i)
				s key = $p(NewVal,":",1)
				s value = $p(NewVal,":",2)
				s detailLen=$Length(value,"*")
			 	for j=1:1:detailLen{
				 	s DetailTitleNode=""
				 	s detailid=$p(value,"*",j)
				 	if (detailid'["S"){
				    	s DetailNode=##Class(web.DHCBL.MKB.SDSDiagnos).GetDetailNode(SDSTermDR,detailid)
				    	
			  	  		s:DetailNode'="" DetailTitleNode=$LISTGET($G(^User.MKBTermProDetailD(DetailNode)),4)  //诊断模板定义的起始节点
			  			s:DetailNode="" DetailTitleNode=""	
			  			
				 	}

				 	//生成含起始节点临时global
				 	if (DetailTitleNode'=""){
						s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"NodeNew",parref,rowid,DetailTitleNode,detailid)=""	
						s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"Flag",parref,rowid,DetailTitleNode)="D"    
					}else{
						s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"NodeNew",parref,rowid,key,detailid)=""
						s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"Flag",parref,rowid,key)=""    
				 	}
				  
			  	}
		    }
		    s pro=""
		    for {
			    s pro=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"NodeNew",parref,rowid,pro)) q:pro=""
			    s detailItmNew=""
			    s detailid=""
			    for {
				    s detailid=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"NodeNew",parref,rowid,pro,detailid)) q:detailid=""
				    if (detailItmNew=""){
					    s detailItmNew=detailid
					}else{
						s detailItmNew=detailItmNew_"*"_detailid
					}
				}
				s ^TMPSTRUCTDIAGNOSLOG($zn,$j,parref,rowid,pro)=$g(^TMPSTRUCTDIAGNOSLOG($zn,$j,parref,rowid,pro))_"&%"_detailItmNew
			}
		  }
   	
	  //未保存属性情况下显示诊断名
	  if ((SDSOldValue="")&(SDSNewValue="")){
		  s ^TMPSTRUCTDIAGNOSLOG($zn,$j,parref,rowid)=SDSTermDR
	  }
 	}
	q 1
}

/// Creator:高姗姗
/// CreatDate:2018-4-12
/// Description：保存结构化诊断历史记录
/// Table：User.SDSDiagnosLog
/// Input：父id 操作类型 旧值 新值
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosLog).SaveLog("")
ClassMethod SaveLog(ParRef As %String, OperateType As %String, OldValue As %String = "", NewValue As %String, AdmDr As %String, Type As %String = "", Scene As %String = "") As %String
{
 s result=""
 if (ParRef=""){
   s result="诊断ID不能为空"	 
 }
 elseif (OperateType="") 
 {
   s result="操作类型不能为空!"
 }
 elseif ('$d(%session))
 {
   s result="获取不到session!"
 }
 else 
 {
    Ts
    s obj=##class(User.SDSDiagnosLog).%New()
    s obj.SDSUpdateUserDR=$Get(%session.Data("LOGON.USERID"))
    s obj.SDSOperateType = OperateType
    s obj.SDSOldValue = OldValue
    s obj.SDSNewValue = NewValue
    s obj.SDSUpdateLocDR=$Get(%session.Data("LOGON.CTLOCID"))
    d:AdmDr'="" obj.SDSAdmDRSetObjectId(AdmDr)
    s obj.SDSIpAddress=$Get(%session.Data("REMOTE_ADDR"))
    d obj.SDSReferenceSetObjectId(ParRef)
    
    s baseScene=##class(web.DHCBL.MKB.MKBTermBase).GetIdByDesc("诊断引用场景")
    s SceneDR=""
    if (baseScene'=""){
	    if (Type="MR"){ //医生站诊断引用场景保存
		    s:Scene="I" Scene="住院"
		    s:Scene="O" Scene="门诊"
		    s:Scene="E" Scene="急诊"
		}
		if ($d(^User.MKBTermI("DescIndex",baseScene," "_Scene))){ //场景存在则直接指向
		   s SceneDR=$o(^User.MKBTermI("DescIndex",baseScene," "_Scene,0))
		}else{ //场景不存在则新增后再指向
			s eobjTerm = ##class(web.Entity.MKB.MKBTerm).%New()
			s eobjTerm.MKBTRowId=""
			s eobjTerm.MKBTDesc=Scene
			s eobjTerm.MKBTLastLevel=$o(^User.MKBTermI("DescIndex",baseScene," 医生站",0))
			s eobjTerm.MKBTBaseDR=baseScene
			s rtnTerm=##class(web.DHCBL.MKB.MKBTerm).SaveData(eobjTerm)
			if (rtnTerm["true"){
				s SceneDR=$e(rtnTerm,21,*-2)
			}
		}
	}
	d obj.SDSSceneDRSetObjectId(SceneDR)
    
    s sc=obj.%Save()
    s id=obj.%Id()
    d obj.%Close()
    If $$$ISOK(sc) 
    {
       Tc
       s result=id_"^"_"添加成功!"
    }
    else 
    {
      Trollback
      s result="添加失败!"
    }
   }
   q result
}

/**************************接口-提供给诊断监控页面**********************************/
/// Creator：高姗姗
/// CreatDate: 2019-06-20
/// Description：查询结构化诊断修改历史中的科室
/// Table：User.SDSDiagnosLog
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnosLog","GetLocForCmb")
Query GetLocForCmb() As %Query(ROWSPEC = "locid,locdesc")
{
}

ClassMethod GetLocForCmbExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s locid=""
	for{
		s locid=$o(^User.SDSDiagnosLogI("UpdateLocIndex","A",locid)) q:locid=""
		s locdesc=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetUserLocDesc("L",locid) 
		d OutputRowCmbLoc	
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmbLoc
    set Data=$lb(locid,locdesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetLocForCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocForCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocForCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocForCmbExecute ]
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

/// Creator：高姗姗
/// CreatDate: 2019-06-20
/// Description：查询用户或科室所下诊断次数或诊断频次
/// Table：User.SDSDiagnosLog
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnosLog","GetFreqList","User","","","")
Query GetFreqList(flag, locid, datefrom, dateto) As %Query(ROWSPEC = "Id,Desc,Freq")
{
}

ClassMethod GetFreqListExecute(ByRef qHandle As %Binary, flag, locid, datefrom, dateto) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:datefrom'="" datefrom=$ZDH(datefrom,3)
	s:dateto'="" dateto = $ZDH(dateto,3)
	s locid=$tr(locid," ","")
	
	if (flag="User"){ //用户诊断次数
		k ^TMPSTRUCTDIAGNOSLOG($zn,$j,"UpdateUser")
		s userid=""
		for{
			s userid=$o(^User.SDSDiagnosLogI("UpdateUserIndex","A",userid))	q:userid=""
			s parref=""
			s freq=0
			for {
				s parref=$o(^User.SDSDiagnosLogI("UpdateUserIndex","A",userid,parref)) q:parref=""
				continue:'$d(^User.SDSDiagnosD(parref))
				s sub=$o(^User.SDSDiagnosLogI("UpdateUserIndex","A",userid,parref,0))
				s UpdateUserDR=$LISTGET($G(^User.SDSDiagnosLogD(sub)),2) 
		  		s UpdateDate=$LISTGET($G(^User.SDSDiagnosLogD(sub)),3)
		  		s SDSUpdateLocDR=$LISTGET($G(^User.SDSDiagnosLogD(sub)),8)
		  		continue:((datefrom'="")&&(datefrom>UpdateDate))
		  		continue:((dateto'="")&&(dateto<UpdateDate))
		  		if ((locid=SDSUpdateLocDR)||(locid="")){
					s freq=freq+1
				}
			}
			continue:freq=0
			s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"UpdateUser",freq,userid)=""
		}
		
		s Freq=""
		for{
			s Freq=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"UpdateUser",Freq),-1) q:Freq=""
			s Id=""
			for{
				s Id=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"UpdateUser",Freq,Id)) q:Id=""	
				s Desc=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetUserLocDesc("U",Id)
				d OutputRowFreq
			}
		}
		
	}
	elseif(flag="Loc"){ //科室诊断次数
		k ^TMPSTRUCTDIAGNOSLOG($zn,$j,"UpdateLoc")
		s locrid=""
		for{
			s locrid=$o(^User.SDSDiagnosLogI("UpdateLocIndex","A",locrid))	q:locrid=""
			s parref=""
			s freq=0
			for {
				s parref=$o(^User.SDSDiagnosLogI("UpdateLocIndex","A",locrid,parref)) q:parref=""
				continue:'$d(^User.SDSDiagnosD(parref))
				s sub=$o(^User.SDSDiagnosLogI("UpdateLocIndex","A",locrid,parref,0))
				s UpdateUserDR=$LISTGET($G(^User.SDSDiagnosLogD(sub)),2) 
		  		s UpdateDate=$LISTGET($G(^User.SDSDiagnosLogD(sub)),3)
		  		continue:((datefrom'="")&&(datefrom>UpdateDate))
		  		continue:((dateto'="")&&(dateto<UpdateDate))
		  		if ((locid=locrid)||(locid="")){
					s freq=freq+1
				}
			}
			continue:freq=0
			s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"UpdateLoc",freq,locrid)=""
		}
		s Freq=""
		for {
			s Freq=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"UpdateLoc",Freq),-1) q:Freq=""
			s Id=""
			for{
				s Id=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"UpdateLoc",Freq,Id)) q:Id=""	
				s Desc=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetUserLocDesc("L",Id)
				d OutputRowFreq
			}	
		}
		
	}elseif (flag="Term"){ //诊断频次
		k ^TMPSTRUCTDIAGNOSLOG($zn,$j,"TermIndex")
		k ^TMPSTRUCTDIAGNOSLOG($zn,$j,"Term")

		s parref=""
		for {
			s parref=$o(^User.SDSDiagnosLogI("OperateTypeIndex","A",parref)) q:parref=""
			s sub=$o(^User.SDSDiagnosLogI("OperateTypeIndex","A",parref,0))
			s SDSTermDR=$LISTGET($G(^User.SDSDiagnosD(parref)),2)
			continue:(SDSTermDR="")
	  		s UpdateDate=$LISTGET($G(^User.SDSDiagnosLogD(sub)),3)
	  		s SDSUpdateLocDR=$LISTGET($G(^User.SDSDiagnosLogD(sub)),8)
	  		continue:((datefrom'="")&&(datefrom>UpdateDate))
	  		continue:((dateto'="")&&(dateto<UpdateDate))
	  		if ((locid=SDSUpdateLocDR)||(locid="")){
				s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"TermIndex",SDSTermDR,parref)=""
			}
		}
		
		s termid=""
		for{
			s termid=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"TermIndex",termid)) q:termid=""
			s parref=""
			s freq=0
			for {
				s parref=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"TermIndex",termid,parref)) q:parref=""
				s freq=freq+1
			}
			continue:freq=0
			s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"Term",freq,termid)=""
		}
		s Freq=""
		for{
			s Freq=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"Term",Freq),-1) q:Freq=""	
			s Id=""
			for{
				s Id=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"Term",Freq,Id)) q:Id=""	
				s Desc=##class(web.DHCBL.MKB.SDSDiagnos).GetTermName(Id)
				d OutputRowFreq
			}
		}	
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFreq
    set Data=$lb(Id,Desc,Freq)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetFreqListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFreqListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetFreqListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFreqListExecute ]
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

/// Creator：高姗姗
/// CreatDate: 2019-06-20
/// Description：查询诊断具体信息,根据用户或科室或中心词
/// Table：User.SDSDiagnosLog
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnosLog","GetDiagList","User","","","2018-01-01,"2019-10-01")
Query GetDiagList(flag, id, locid, datefrom, dateto) As %Query(ROWSPEC = "SDSRowId,SDSTermDR,SDSDisplayName,SDSSupplement,SDSOpenDate,LinkIcdCode,LinkIcdDesc,SDSSequence,SDSWordDR,SDSWordDesc,SDSTagDR,SDSTag,SDSOnsetDate,UpdateLocDesc,UpdateUserDesc")
{
}

ClassMethod GetDiagListExecute(ByRef qHandle As %Binary, flag, id, locid, datefrom, dateto) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:datefrom'="" datefrom=$ZDH(datefrom,3)
	s:dateto'="" dateto = $ZDH(dateto,3)
	s locid=$tr(locid," ","")
	
	if (flag="User"){ //用户诊断详情
		s SDSRowId=""
		for {
			s SDSRowId=$o(^User.SDSDiagnosLogI("UpdateUserIndex","A",id,SDSRowId)) q:SDSRowId=""
			continue:'$d(^User.SDSDiagnosD(SDSRowId))
			s sub=$o(^User.SDSDiagnosLogI("UpdateUserIndex","A",id,SDSRowId,0))
			s UpdateUserDR=$LISTGET($G(^User.SDSDiagnosLogD(sub)),2) 
	  		s UpdateDate=$LISTGET($G(^User.SDSDiagnosLogD(sub)),3)
	  		s SDSUpdateLocDR=$LISTGET($G(^User.SDSDiagnosLogD(sub)),8)
	  		continue:((datefrom'="")&&(datefrom>UpdateDate))
	  		continue:((dateto'="")&&(dateto<UpdateDate))
	  		if ((locid=SDSUpdateLocDR)||(locid="")){
				s SDSTermDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),2)
				s SDSDisplayName=##class(web.DHCBL.MKB.SDSDiagnos).GetDiagName(SDSRowId)
				s SDSSupplement=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),4)
				s SDSOpenDate=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),8)
				s:SDSOpenDate'="" SDSOpenDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(SDSOpenDate)
				s LinkIcdCode=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),5)
			  	s LinkIcdDesc=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),6)
				s SDSSequence=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),9)
				s SDSWordDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),7)
				s SDSWordDesc=""
				s version=##class(web.DHCBL.MKB.SDSDiagnos).GetWordVersion()
				if (version["ICD"){ //取自各版本icd对照
					s:SDSWordDR'="" SDSWordDesc=$listGet($g(^User.MKBICDContrastD(SDSWordDR)),3)
				}else{ //取自数据处理工厂
					s:SDSWordDR'="" SDSWordDesc=$listGet($g(^User.MKBStructuredDataD(SDSWordDR)),2)
				}
				s SDSTagDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),11)
				s:SDSTagDR'="" SDSTag=##class(web.DHCBL.MKB.SDSDiagnos).GetTagText(SDSTagDR)
				s:SDSTagDR="" SDSTag=""
				s SDSOnsetDate=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),13)
				s:SDSOnsetDate'="" SDSOnsetDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(SDSOnsetDate)
				s UpdateLocDesc=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetUserLocDesc("L",SDSUpdateLocDR)
				s UpdateUserDesc=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetUserLocDesc("U",UpdateUserDR)
				d OutputRowDiag
			}
		}
	}elseif (flag="Loc"){ //科室诊断详情
		s SDSRowId=""
		for {
			s SDSRowId=$o(^User.SDSDiagnosLogI("UpdateLocIndex","A",id,SDSRowId)) q:SDSRowId=""
			continue:'$d(^User.SDSDiagnosD(SDSRowId))
			s sub=$o(^User.SDSDiagnosLogI("UpdateLocIndex","A",id,SDSRowId,0))
			s UpdateUserDR=$LISTGET($G(^User.SDSDiagnosLogD(sub)),2) 
	  		s UpdateDate=$LISTGET($G(^User.SDSDiagnosLogD(sub)),3)
	  		s SDSUpdateLocDR=$LISTGET($G(^User.SDSDiagnosLogD(sub)),8)
	  		
	  		continue:((datefrom'="")&&(datefrom>UpdateDate))
	  		continue:((dateto'="")&&(dateto<UpdateDate))
	  	
			s SDSTermDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),2)
			s SDSDisplayName=##class(web.DHCBL.MKB.SDSDiagnos).GetDiagName(SDSRowId)
			s SDSSupplement=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),4)
			s SDSOpenDate=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),8)
			s:SDSOpenDate'="" SDSOpenDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(SDSOpenDate)
			s LinkIcdCode=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),5)
		  	s LinkIcdDesc=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),6)
			s SDSSequence=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),9)
			s SDSWordDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),7)
			s SDSWordDesc=""
			s version=##class(web.DHCBL.MKB.SDSDiagnos).GetWordVersion()
			if (version["ICD"){ //取自各版本icd对照
				s:SDSWordDR'="" SDSWordDesc=$listGet($g(^User.MKBICDContrastD(SDSWordDR)),3)
			}else{ //取自数据处理工厂
				s:SDSWordDR'="" SDSWordDesc=$listGet($g(^User.MKBStructuredDataD(SDSWordDR)),2)
			}
			s SDSTagDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),11)
			s:SDSTagDR'="" SDSTag=##class(web.DHCBL.MKB.SDSDiagnos).GetTagText(SDSTagDR)
			s:SDSTagDR="" SDSTag=""
			s SDSOnsetDate=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),13)
			s:SDSOnsetDate'="" SDSOnsetDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(SDSOnsetDate)
			s UpdateLocDesc=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetUserLocDesc("L",SDSUpdateLocDR)
			s UpdateUserDesc=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetUserLocDesc("U",UpdateUserDR)
			d OutputRowDiag
			
		}
	}elseif (flag="Term"){ //中心词详情
		s SDSRowId=""
		for {
			s SDSRowId=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"TermIndex",id,SDSRowId)) q:SDSRowId=""
			s sub=$o(^User.SDSDiagnosLogI("OperateTypeIndex","A",SDSRowId,0))
			s UpdateUserDR=$LISTGET($G(^User.SDSDiagnosLogD(sub)),2) 
	  		s UpdateDate=$LISTGET($G(^User.SDSDiagnosLogD(sub)),3)
	  		s SDSUpdateLocDR=$LISTGET($G(^User.SDSDiagnosLogD(sub)),8)
	  	
	  		continue:((datefrom'="")&&(datefrom>UpdateDate))
	  		continue:((dateto'="")&&(dateto<UpdateDate))
	  		if ((locid=SDSUpdateLocDR)||(locid="")){
				s SDSTermDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),2)
				s SDSDisplayName=##class(web.DHCBL.MKB.SDSDiagnos).GetDiagName(SDSRowId)
				s SDSSupplement=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),4)
				s SDSOpenDate=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),8)
				s:SDSOpenDate'="" SDSOpenDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(SDSOpenDate)
				s LinkIcdCode=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),5)
			  	s LinkIcdDesc=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),6)
				s SDSSequence=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),9)
				s SDSWordDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),7)
				s SDSWordDesc=""
				s version=##class(web.DHCBL.MKB.SDSDiagnos).GetWordVersion()
				if (version["ICD"){ //取自各版本icd对照
					s:SDSWordDR'="" SDSWordDesc=$listGet($g(^User.MKBICDContrastD(SDSWordDR)),3)
				}else{ //取自数据处理工厂
					s:SDSWordDR'="" SDSWordDesc=$listGet($g(^User.MKBStructuredDataD(SDSWordDR)),2)
				}
				s SDSTagDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),11)
				s:SDSTagDR'="" SDSTag=##class(web.DHCBL.MKB.SDSDiagnos).GetTagText(SDSTagDR)
				s:SDSTagDR="" SDSTag=""
				s SDSOnsetDate=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),13)
				s:SDSOnsetDate'="" SDSOnsetDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(SDSOnsetDate)
				s UpdateLocDesc=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetUserLocDesc("L",SDSUpdateLocDR)
				s UpdateUserDesc=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetUserLocDesc("U",UpdateUserDR)
				d OutputRowDiag
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDiag
    set Data=$lb(SDSRowId,SDSTermDR,SDSDisplayName,SDSSupplement,SDSOpenDate,LinkIcdCode,LinkIcdDesc,SDSSequence,SDSWordDR,SDSWordDesc,SDSTagDR,SDSTag,SDSOnsetDate,UpdateLocDesc,UpdateUserDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDiagListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiagListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagListExecute ]
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
/// CreatDate: 2019-09-03
/// Description：导出插件版开立诊断监控界面数据
/// Table：User.SDSStructDiagnosLog
/// Other: d ##class(web.DHCBL.MKB.SDSDiagnosLog).ExportDiagnosLog("","2019-11-27","2019-12-03","User")
ClassMethod ExportDiagnosLog(locid As %String, datefrom As %String, dateto As %String, flag As %String)
{
	s User=%session.Get("LOGON.USERID")
	;s User="4634"
	s:User'="" UserName=$p($g(^SSU("SSUSR",User)),"^",2)
	s:User="" UserName=$zd($Now(),3)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1)
	s DownLoadDir=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"_UserName_".csv"
	s filename = UserName_".csv"
	s file=##class(%File).%New(DownLoadDir)
	d file.Open("NWS")
	d file.WriteLine("姓名,诊断短语,诊断表达式,补充诊断,科室,icd编码,icd描述,开立日期")
	
	s Freq = ""
	for
	{

		s Freq=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"UpdateUser",Freq),-1) q:Freq=""
		s Userid=0
		for
		{
			s Userid=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"UpdateUser",Freq,Userid))
			q:Userid=""
			;GetDiagList(userid, locid, datefrom, dateto)
			s TmpUserid=$zstrip(Userid,"<>W")
			s Name=$p($g(^SSU("SSUSR",TmpUserid)),"^",2)
			;s userid=$zstrip(Userid,"<>W")
			s rs=##class(%ResultSet).%New("web.DHCBL.MKB.SDSDiagnosLog:GetDiagList")
			d rs.Execute(flag,Userid,locid,datefrom,dateto)
			while rs.Next()
			{
				s SDSRowId=rs.Data("SDSRowId")
				s SDSDisplayName=rs.Data("SDSDisplayName")  //诊断表达式
				s SDSDisplayName=$replace(SDSDisplayName,",","，")
				s SDSSupplement=rs.Data("SDSSupplement")   //补充诊断
				s SDSSupplement=$replace(SDSSupplement,",","，")
				s SDSOpenDate=rs.Data("SDSOpenDate")     //开立日期       
				s LinkIcdCode=rs.Data("LinkIcdCode")      //icd编码
				s LinkIcdDesc=rs.Data("LinkIcdDesc")      //icd描述
				s SDSSequence=rs.Data("SDSSequence")      
				s SDSWordDR=rs.Data("SDSWordDR")         
				s SDSWordDesc=rs.Data("SDSWordDesc")        //诊断短语
				s SDSWordDesc=$replace(SDSWordDesc,",","，")
				s UpdateLocDesc=rs.Data("UpdateLocDesc")       //科室
				;"医生,诊断短语,诊断表达式,补充诊断,科室,icd编码,icd描述,开立日期"
				d file.WriteLine(Name_","_SDSWordDesc_","_SDSDisplayName_","_SDSSupplement_","_UpdateLocDesc_","_LinkIcdCode_","_LinkIcdDesc_","_SDSOpenDate)
				
			}
		}
	}
	d file.%Save()
	d file.%Close()
	k file
	q filename
}

/// Creator：Xuwenhu 		
/// CreatDate: 2021-08-02
/// Description：查询诊断具体信息,根据用户或科室或中心词--导出
/// Table:User.SDSDiagnosLog
/// Input:rowid,
/// Output:SDSRowId,SDSDisplayName,SDSSupplement,SDSOpenDate,LinkIcdCode,LinkIcdDesc,SDSSequence,SDSWordDR,SDSWordDesc,UpdateLocDesc,Name
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnosLog","GetDiagDetail","","","","")
Query GetDiagDetail(locid As %String, datefrom As %String, dateto As %String, flag As %String) As %Query(ROWSPEC = "SDSRowId,SDSDisplayName,SDSSupplement,SDSOpenDate,LinkIcdCode,LinkIcdDesc,SDSSequence,SDSWordDR,SDSWordDesc,UpdateLocDesc,Name")
{
}

ClassMethod GetDiagDetailExecute(ByRef qHandle As %Binary, locid As %String, datefrom As %String, dateto As %String, flag As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
	s Freq = ""
	for
	{

		s Freq=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"UpdateUser",Freq),-1) q:Freq=""
		s Userid=0
		for
		{
			s Userid=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"UpdateUser",Freq,Userid))
			q:Userid=""
			;GetDiagList(userid, locid, datefrom, dateto)
			s TmpUserid=$zstrip(Userid,"<>W")
			s Name=$p($g(^SSU("SSUSR",TmpUserid)),"^",2)
			;s userid=$zstrip(Userid,"<>W")
			s rs=##class(%ResultSet).%New("web.DHCBL.MKB.SDSDiagnosLog:GetDiagList")
			d rs.Execute(flag,Userid,locid,datefrom,dateto)
			while rs.Next()
			{
				s SDSRowId=rs.Data("SDSRowId")
				s SDSDisplayName=rs.Data("SDSDisplayName")  //诊断表达式
				s SDSDisplayName=$replace(SDSDisplayName,",","，")
				s SDSSupplement=rs.Data("SDSSupplement")   //补充诊断
				s SDSSupplement=$replace(SDSSupplement,",","，")
				s SDSOpenDate=rs.Data("SDSOpenDate")     //开立日期       
				s LinkIcdCode=rs.Data("LinkIcdCode")      //icd编码
				s LinkIcdDesc=rs.Data("LinkIcdDesc")      //icd描述
				s SDSSequence=rs.Data("SDSSequence")      
				s SDSWordDR=rs.Data("SDSWordDR")         
				s SDSWordDesc=rs.Data("SDSWordDesc")        //诊断短语
				s SDSWordDesc=$replace(SDSWordDesc,",","，")
				s UpdateLocDesc=rs.Data("UpdateLocDesc")       //科室
				d OutputRow
			}
		}
	}
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(SDSRowId,SDSDisplayName,SDSSupplement,SDSOpenDate,LinkIcdCode,LinkIcdDesc,SDSSequence,SDSWordDR,SDSWordDesc,UpdateLocDesc,Name)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDiagDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDiagDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagDetailExecute ]
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
