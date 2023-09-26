/// 名称:实施综合管理平台-字典对照-对接方诊断字典表
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2020-12-23
Class web.CDSS.IMP.ConDiseaseDict Extends %RegisteredObject
{

/// Creator：阚延新		
/// CreatDate: 2020-12-23
/// Description：查询 对接方诊断字典
/// Table：CT.WDT.CDSS.ConDiseaseDict 对接方诊断字典表
/// Input:source,name,id,state,dhcname,icd,dhcicd
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.ConDiseaseDict","GetList","","","","","","","","","","")
Query GetList(hosp As %String, source As %String, name As %String, id As %String, state As %String, dhcname As %String, icd As %String, dhcicd As %String, remarks As %String, sortmethod) As %Query(ROWSPEC = "RowID,DiseaseCode,DiseaseName,Source,ICDCode,HospitalDR,ConRemarks,ConState,CreateDate,CreateUser,UpdateDate,UpdateUser,DictID,DictName,MKBICDConNumber,HospAreaDesc,HospitalAreaDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, hosp As %String, source As %String, name As %String, id As %String, state As %String, dhcname As %String, icd As %String, dhcicd As %String, remarks As %String, sortmethod) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:dhcname'="" code=$ZCONVERT(dhcname,"U") //转换成大写
	s:name'="" name=$ZCONVERT(name,"U") //转换成大写
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写
	s:icd'="" icd=$ZCONVERT(icd,"U") //转换成大写
	s:dhcicd'="" dhcicd=$ZCONVERT(dhcicd,"U") //转换成大写
	s:dhcname'="" dhcname=$ZCONVERT(dhcname,"U") //转换成大写
	s:id'="" id=$ZCONVERT(id,"U") //转换成大写
	k ^TempDataHandle
	if (hosp'="")
	{
		if (sortmethod="Short")
		{
			s num=0
			s CreateTime=""
			for
			{
				s CreateTime=$o(^CT.WDT.CDSS.ConDiseaseDictI("CreateDateIndex",hosp,CreateTime),-1)
				q:CreateTime=""
				s ID=0
				for
				{
					s ID=$o(^CT.WDT.CDSS.ConDiseaseDictI("CreateDateIndex",hosp,CreateTime,ID))
					q:ID=""
					s DiseaseCode= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),2)		//代码
					s DiseaseName= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),3)		//名称
					s length=$l(DiseaseName)
					s ^TempDataHandle("Short",length,ID)=ID			
				}
			}
			s num=0
			s le=0
			for
			{
				s le=$o(^TempDataHandle("Short",le))
				q:le=""
				s DiseaseID=0
				for
				{
					s DiseaseID=$o(^TempDataHandle("Short",le,DiseaseID))
					q:DiseaseID=""
					s num=num+1
					s ^TempDataHandle("Handle",num)=DiseaseID
				}
			}
			
		}
		elseif (sortmethod="UpdateTime")  //按修改日期排序
		{
			s num=0
			s UpdateTime=""
			for
			{
				s UpdateTime=$o(^CT.WDT.CDSS.ConDiseaseDictI("UpdateDateIndex",hosp,UpdateTime),-1)
				q:UpdateTime=""
				s ID=0
				for
				{
					s ID=$o(^CT.WDT.CDSS.ConDiseaseDictI("UpdateDateIndex",hosp,UpdateTime,ID))
					q:ID=""
					s num=num+1
					s ^TempDataHandle("Handle",num)=ID
				}
			}
			
				
		}
		else  //按创建日期排序
		{
			s num=0
			s CreateTime=""
			for
			{
				s CreateTime=$o(^CT.WDT.CDSS.ConDiseaseDictI("CreateDateIndex",hosp,CreateTime),-1)
				q:CreateTime=""
				s ID=0
				for
				{
					s ID=$o(^CT.WDT.CDSS.ConDiseaseDictI("CreateDateIndex",hosp,CreateTime,ID))
					q:ID=""
					s num=num+1
					s ^TempDataHandle("Handle",num)=ID
				}
			}
			
		}
	}
	s Number=0
	for 
	{
		s Number=$o(^TempDataHandle("Handle",Number))
		q:Number=""
		s ID=^TempDataHandle("Handle",Number)
		s HospAreaDR="",HospAreaDesc="",HospitalAreaDR="",HospitalAreaDRStr=""
		for
		{
			s HospAreaDR=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex","诊断",ID,HospAreaDR))
			q:HospAreaDR=""
			s ParRef=$p(HospAreaDR,"||",1)
			s ChildSub=$p(HospAreaDR,"||",2)
			if (HospAreaDesc="")
			{
				s HospAreaDesc= $lg($g(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub)),3)		//院区名称
			}
			else
			{
				s HospAreaDesc=HospAreaDesc_","_$lg($g(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub)),3)		//院区名称
			}
			if (HospitalAreaDRStr=""){
				s HospitalAreaDRStr=HospAreaDR
			}
			else{
				s HospitalAreaDRStr=HospitalAreaDRStr_","_HospAreaDR
			}
			s HospitalAreaDR=HospitalAreaDRStr
			//s HospitalAreaDR=HospAreaDR
		}
		s DiseaseCode= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),2)
		continue:((id'="")&&($ZCONVERT(DiseaseCode,"U")'[id))
		s DiseaseName= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),3)
		continue:((name'="")&&($ZCONVERT(DiseaseName,"U")'[name))
		s Source= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),4) 
		continue:((source'="")&&(Source'[source))
		s ICDCode= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),5)
		continue:((icd'="")&&($ZCONVERT(ICDCode,"U")'[icd))
		s Hospital=$lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),6)	//所属医院
		s:Hospital'="" HospitalDR=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(Hospital)),3)
		continue:((hosp'="")&&(Hospital'=hosp))
		//s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","诊断",ID,0))
        // continue:(ConID="")
		s Remarks= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),7)
	   	s State= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),8)
		if (state="")	//默认不显示 已删除
		{
			continue:(State="已删除")
		}
		else
		{
			continue:(State'=state)
		}
		s CreateDate= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),9)
		s CreateUser= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),10)
		s UpdateDate= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),11)
		s UpdateUser= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),12)
		s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",Hospital,"诊断",ID,0))
        
        s DictNameStr="",DictCodeStr="",DictIDStr="",MKBICDConNumberStr="" //知识库描述串、知识库代码串、ID串
		s RowID=ID,DictID="",DictCode= "",DictName= "",ConState=State,ConRemarks="",MKBICDConNumber=""  //需要输出的字段：对接方字典id，知识库字典ID、代码、描述、对照状态（改为输出字典的状态）、对照备注

        if (haveState'="")
        {
			//走对照表，找对接的知识库id、代码、描述
			s ContrastState=""
			for
			{
				s ContrastState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",Hospital,"诊断",ID,ContrastState))
				q:ContrastState=""
						
				s ConID=0
				for
				{
					s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",Hospital,"诊断",ID,ContrastState,ConID))
					q:ConID=""
					
					s DictID=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),10)		//知识库字典ID
					s DictCode= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),2)		//知识库字典代码
					s DictName= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),3)		//知识库字典描述
					s MKBICDConNumber=..GetDiseaseICD(DictName)
					;s MKBICDConNumber=$o(^User.MKBICDContrastI("DescIndex"," "_$zconvert(DictName,"U"),0))  //东华ICD
					;s:MKBICDConNumber'="" MKBICDConNumber=$lg($G(^User.MKBICDContrastD(MKBICDConNumber)),4)		
					//知识库描述串
					if (DictNameStr=""){
						s DictNameStr=DictName
					}
					else{
						s DictNameStr=DictNameStr_","_DictName
					}
					//知识库ID串
					if (DictIDStr=""){
						s DictIDStr=DictID
					}
					else{
						s DictIDStr=DictIDStr_","_DictID
					}	
					//知识库代码串
					if (DictCodeStr=""){
						s DictCodeStr=DictCode
					}
					else{
						s DictCodeStr=DictCodeStr_","_DictCode
					}
					//知识库ICD串
					if (MKBICDConNumberStr=""){
						s MKBICDConNumberStr=MKBICDConNumber
					}
					else{
						s MKBICDConNumberStr=MKBICDConNumberStr_","_MKBICDConNumber
					}							
					//continue:((dhcname'="")&&($ZCONVERT(DictName,"U")'[dhcname)) 
					//continue:((dhcicd'="")&&($ZCONVERT(MKBICDConNumber,"U")'[dhcicd))
							
					s ConDictCode=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),5)		//对接方字典代码
					s ConDictName=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),6)		//对接方字典描述
					s ConRemarks=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),9)		//备注
					//continue:((remarks'="")&&($ZCONVERT(ConRemarks,"U")'[remarks))
					//d OutputRow
				}
			}
        }
		s DictName=DictNameStr,DictCode=DictCodeStr,DictID=DictIDStr,MKBICDConNumber=MKBICDConNumberStr   //给需要输出的字段：知识库字典ID、代码、描述重新赋值，多个的话拼串
		if (($ZCONVERT(DictName,"U")[dhcname))&(ConRemarks[remarks)&(($ZCONVERT(MKBICDConNumber,"U")[dhcicd))  //满足条件则输出
		{
			d OutputRow
		}
					
	}


	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowID,DiseaseCode,DiseaseName,Source,ICDCode,HospitalDR,ConRemarks,ConState,CreateDate,CreateUser,UpdateDate,UpdateUser,DictID,DictName,MKBICDConNumber,HospAreaDesc,HospitalAreaDR)
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

/// Creator:阚延新
/// CreatDate:2021-4-26
/// Description:获取当前诊断的ICD字段
/// Table:CT.WDT.CDSS.DiseaseDict 
/// Input:namestr, 
/// Return:
/// Other:w ##class(web.CDSS.IMP.ConDiseaseDict).GetDiseaseICD("")
ClassMethod GetDiseaseICD(namestr As %String) As %String
{
	s dicttotal=$l(namestr,",")
	s icdstr=""
	for m=1:1:dicttotal
	{
		s dictname=$p(namestr,",",m)
		s icd=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$zconvert(dictname,"U"),0))
		s:icd'="" icd=$lg($G(^CT.WDT.CDSS.DiseaseDictD(icd)),2)
		;s icd=$o(^User.MKBICDContrastI("DescIndex"," "_$zconvert(dictname,"U"),0))
		;s:icd'="" icd=$lg($G(^User.MKBICDContrastD(icd)),4)
        if (m=1)
        {
	    	s icdstr=icd
	    }
	    else 
	    {
		    s icdstr=icdstr_","_icd
		}
	}
	q icdstr
}

/// Creator:阚延新
/// CreatDate:2021-1-4
/// Description:数据重复验证方法,js调用
/// Table:CT.WDT.CDSS.ConDiseaseDict 对接方诊断字典表
/// Input:id, 
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.IMP.ConDiseaseDict).FormValidate("","","","1")
ClassMethod FormValidate(id As %String, icdcode As %String, code As %String, name As %String, hosp As %String) As %String
{
	s flag=""
	s flagc=""
	s:((icdcode'="")&&(hosp'="")&&(name'="")) flagc=$d(^CT.WDT.CDSS.ConDiseaseDictI("HospCNIndex",hosp,icdcode,code,name))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0)
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
		s:((icdcode'="")&&(hosp'="")&&(name'="")) idc=$o(^CT.WDT.CDSS.ConDiseaseDictI("HospCNIndex",hosp,icdcode,code,name,0))
		if (idc'="")&(idc'=id)&(flagc>0)
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator:阚延新
/// CreatDate: 2020-12-29
/// Description：保存对接方诊断字典表
/// Table:CT.WDT.CDSS.ConDiseaseDict 对接方诊断字典表
/// Input: eobj As web.CDSSEntity.IMP.ConDiseaseDict
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ConDiseaseDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.IMP.ConDiseaseDict, LogFlag As %String = "") As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.Source="" eobj.Source="住院"
		s:eobj.UpdateDate="" eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
	    s:eobj.UpdateUser="" eobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
	    s:eobj.DiseaseCode="" eobj.DiseaseCode=..getFactorCode()	
		s flag=..FormValidate(eobj.ID,eobj.ICDCode,eobj.DiseaseCode,eobj.DiseaseName,eobj.HospitalDR)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.ConDiseaseDict).%New()
	        s:eobj.CreateDate="" eobj.CreateDate=$ZDATETIME($HOROLOG,3)
	        s:eobj.CreateUser="" eobj.CreateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
	        s:eobj.UpdateDate="" eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
	        s:eobj.UpdateUser="" eobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
	        
		}else	//修改
		{
			s obj=##class(CT.WDT.CDSS.ConDiseaseDict).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.IMP.ConDiseaseDict).%New()
			s bobj.ID = eobj.ID
			s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//医院
			s bobj.DiseaseCode=obj.DiseaseCode			
			s bobj.DiseaseName=obj.DiseaseName				
			s bobj.Source=obj.Source				
			s bobj.ICDCode=obj.ICDCode
			s bobj.Remarks=obj.Remarks			
			s bobj.State=obj.State				
			s bobj.CreateDate=obj.CreateDate				
			s bobj.CreateUser=obj.CreateUser					
			s bobj.UpdateDate=obj.UpdateDate				
			s bobj.UpdateUser=obj.UpdateUser
		}
		d:eobj.HospitalDR'="" obj.HospitalDRSetObjectId(eobj.HospitalDR)		//所属医院
		d:eobj.HospitalDR="" obj.HospitalDRSetObjectId("")		
		s obj.DiseaseCode=eobj.DiseaseCode			
		s obj.DiseaseName=eobj.DiseaseName				
        s obj.Source=eobj.Source				
		s obj.ICDCode=eobj.ICDCode	  	
		s obj.Remarks=eobj.Remarks	//备注
		s obj.State=eobj.State		//状态（未关联/已关联/已确认/已删除）					
		s obj.CreateDate=eobj.CreateDate	
		s obj.CreateUser=eobj.CreateUser				
		s obj.UpdateDate=eobj.UpdateDate
		s obj.UpdateUser=eobj.UpdateUser	
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			if (eobj.ID="")
			{
				s count= ..AutoMatch(eobj.HospitalDR,id)	//自动匹配	
				s count=$p(count,"'",4)
				s result = "{success:'true',id:'"_id_"',count:'"_count_"'}"	
				if (eobj.HospitalAreaDR'="")
				{
					s areatotal=$l(eobj.HospitalAreaDR,",")
					for areai=1:1:areatotal
					{
						s areaID=$p(eobj.HospitalAreaDR,",",areai)
						s resultx=##class(web.CDSS.IMP.ConDictConArea).SaveData("","诊断",id,areaID)
						if (resultx["false")
						{
							q
						}
					}
					//d ##class(web.CDSS.IMP.ConDictConArea).SaveData("","诊断",id,eobj.HospitalAreaDR)
					
				}
			}
			if (LogFlag="")
			{
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConDiseaseDict","CT.WDT.CDSS.ConDiseaseDict","对接方诊断字典表",id,eobj.DiseaseName,"A",eobj)
		    d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConDiseaseDict","CT.WDT.CDSS.ConDiseaseDict","对接方诊断字典表",id,eobj.DiseaseName,"U",eobj,bobj)
			}
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("对接方诊断字典表","web.CDSS.IMP.ConDiseaseDict","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：阚延新
/// Description：得到新增数据的code
/// Table:CT.WDT.CDSS.ConDiseaseDict对接方诊断对照表
/// Input：id
/// Other: w ##class(web.CDSS.IMP.ConDiseaseDict).getFactorCode()
ClassMethod getFactorCode() As %String
{
    s dataid = $o(^CT.WDT.CDSS.ConDiseaseDictD(""),-1)
    s result=""
	if (dataid=""){
		s result=1
	}else{
		s result = dataid+1
	}
	q result
}

/// Creator:阚延新
/// CreatDate: 2020-12-30
/// Description：更改对接方诊断字典表的状态
/// Table:CT.WDT.CDSS.ConDiseaseDict 对接方诊断字典表
/// Input: id
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ConDiseaseDict).UpdateState(id,"")
ClassMethod UpdateState(id, state) As %String
{
	s result=""
	s obj=##class(CT.WDT.CDSS.ConDiseaseDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.IMP.ConDiseaseDict).%New()
    s bobj.ID = id
	s bobj.DiseaseCode= obj.DiseaseCode							//代码
	s bobj.DiseaseName= obj.DiseaseName							//名称
	s bobj.ICDCode=obj.ICDCode									//ICD
	s bobj.Source=obj.Source									//来源（住院/门诊/急诊）
	s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id() //所属医院
	s bobj.Remarks=obj.Remarks	                                //备注
	s bobj.State=state		                                    //状态（未关联/已关联/已确认/已删除）
	
	        
	s bobj.CreateDate=obj.CreateDate		                     //创建时间（诊断数据导入或者手动新增的时间）
	s bobj.CreateUser=obj.CreateUser		                     //创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		             //修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
	s bobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))		 //修改人	
	s result= ..SaveEntity(bobj)
	q result
}

/// Creator：阚延新
/// CreatDate: 2020-12-29
/// Description：自动匹配
/// Table:CT.WDT.CDSS.ConDiseaseDict 对接方诊断字典表
/// Input： hosp 医院id, id
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConDiseaseDict).AutoMatch(1,"35873")
ClassMethod AutoMatch(hosp As %String, id As %String = "")
{
	q:(hosp="") "{success:'false',errorinfo:'自动匹配失败，传入的医院为空！'}"
	s result=""
	s linksavecount=0
	s unlinksavecount=0
	
	//生成诊断检索索引(名称或别名中包含括号或者-的数据处理后生成到一个临时global里，用于后面的匹配)
	d ##class(web.CDSS.IMP.ConDiseaseDict).CreateDiseaseIndex()
	
	//遍历所有未关联的诊断
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.ConDiseaseDictI("HospStateIndex",hosp,"未关联",ID))
		q:ID=""
		continue:((id'="")&&(id'=ID))
		s TrastID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","诊断",ID,0)) //当前数据在对照表中的ID
		s DictCode= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),2)		//代码
		s DictName= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),3)		//名称
		//s DictName=$lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),4)		//商品名		
		
		 //0 从已确认数据中找名称相同的数据
		s DiseaseID=$o(^CT.WDT.CDSS.ConDiseaseDictI("StateDescIndex","已确认",DictName,0))
		s ConIDFlag=0
		s:DiseaseID'="" ConIDFlag=$d(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","诊断",DiseaseID))
		if (ConIDFlag>0)  //如果有已确认的名称相同的数据，则跟该数据对照同样的知识库数据
		{
			s DictDRStr=""
			s ConID=0
			for
			{
				s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","诊断",DiseaseID,ConID))
				q:ConID=""
				s DictDR=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),10)  //对照的知识库字典ID
				s:DictDRStr'="" DictDRStr=DictDRStr_","
				s DictDRStr=DictDRStr_DictDR
				
			}
			//调用关联方法保存对照数据
			s result=..BatchMapping(ID,DictDRStr,"",1)
			if (result["false")
			{
				s unlinksavecount=unlinksavecount+1
			}
			else
			{
				s linksavecount=linksavecount+1
			}
		}
		else
		{
			//-----------------------------------自动匹配-----------------------------------------------------------------------------
			//his商品名处理符号：去除空格；全角转半角；小括号-中文；逗号-中文；中括号-英文；去除<>及其中内容；去除%及前面数字														
			s DictNameNew=##class(web.CDSS.IMP.ContrastDict).DealBracketBeforeCon(DictName)	  
			//1 his商品名和知识库名和别名匹配
			s RowID=..FindDictIdByName(DictNameNew)
			
			/*/2 his通用名和知识库名和别名匹配
			if (RowID="")&&(DictDesc'="")
			{
				//his通用名处理符号：去除空格；全角转半角；小括号-中文；逗号-中文；中括号-英文；去除<>及其中内容；去除%及前面数字		
				s DictDescNew=##class(web.CDSS.IMP.ContrastDict).DealBracketBeforeCon(DictDesc)	  
				s RowID=..FindDictIdByName(DictDescNew)
			}*/
			
			if (RowID="")
			{
				s DictNameNoBracket=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(DictNameNew)
				if (DictNameNoBracket'="")
				{
					if (DictNameNoBracket'=DictNameNew)
					{
						//3 忽略对接方商品名括号 "()"、"[]"、"（）"、"【】" 跟知识库名称和别名匹配
						s RowID=..FindDictIdByName(DictNameNoBracket)
					}
					//4 忽略知识库名称和别名中的括号"()"、"[]"、"（）"、"【】" 进行匹配
					if (RowID="")&($d(^TEMPCDSSCON("DiseaseIndex",1))>0)
					{
						s RowID=$o(^TEMPCDSSCON("DiseaseIndex",1,$zconvert(DictNameNoBracket,"U"),0))
					}
				}
			}
			
			if (RowID="")
			{
				s DictNameNoBracketinside=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(DictNameNew)
				if (DictNameNoBracketinside'="")
				{
					if (DictNameNoBracketinside'=DictNameNew)
					{
						//5 忽略对接方商品名括号 "()"、"[]"、"（）"、"【】" 及内容跟知识库名称和别名匹配
						s RowID=..FindDictIdByName(DictNameNoBracketinside)
					}
					//6 忽略知识库名称和别名中的括号"()"、"[]"、"（）"、"【】"及内容 进行匹配
					if (RowID="")&($d(^TEMPCDSSCON("DiseaseIndex",2))>0)
					{
						s RowID=$o(^TEMPCDSSCON("DiseaseIndex",2,$zconvert(DictNameNoBracketinside,"U"),0))
					}
				}
			}
			
			if (RowID="")
			{
				s DictNameNOMinus=$Replace(DictNameNew,"-","")
				if (DictNameNOMinus'="")
				{
					if (DictNameNOMinus'=DictNameNew)
					{
						//7 忽略对接方 - 跟知识库名称和别名匹配
						s RowID=..FindDictIdByName(DictNameNOMinus)
					}
					//8 忽略知识库名称和别名中的 -  进行匹配
					if (RowID="")&($d(^TEMPCDSSCON("DiseaseIndex",3))>0)
					{
						s RowID=$o(^TEMPCDSSCON("DiseaseIndex",3,$zconvert(DictNameNOMinus,"U"),0))
					}
				}
			}
			if (RowID'="")
			{
				//调用关联方法保存对照数据
				s result=..BatchMapping(ID,RowID,"",1)
				if (result["false")
				{
					s unlinksavecount=unlinksavecount+1
				}
				else
				{
					s linksavecount=linksavecount+1
				}		
			}
			else
			{
				s unlinksavecount=unlinksavecount+1
			}

	  	}
	  	
	}
	
	s result="{success:'true',linksavecount:'"_linksavecount_"',unlinksavecount:'"_unlinksavecount_"'}"
	k ^TEMPCDSSCON("DiseaseIndex")
	q result
}

/// Creator：阚延新
/// CreatDate: 2021-1-4
/// Description：批量导入对接方诊断
/// Table:CT.WDT.CDSS.ConDiseaseDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConDiseaseDict).SaveImportData("22[next]肺结核(显微镜检证实)[next]A15.000x001[next]门诊[next][next]山大二院[next]")
ClassMethod SaveImportData(dataStr, hosp)
{
	s result=""
	s dataStr=$tr(dataStr," ","")
	s dataStr=##class(web.DHCBL.BDP.FunLib).EvalJSONB(dataStr)		
	
	s DiseaseCode=$p(dataStr,"[next]",1)
	s:DiseaseCode="" DiseaseCode=..getFactorCode()
	s DiseaseName=$p(dataStr,"[next]",2)
	q:DiseaseName="" "false" 
	s ICDCode=$p(dataStr,"[next]",3)
	s StartDate=$p(dataStr,"[next]",4)
	s EndDate=$p(dataStr,"[next]",5)
	s Source=$p(dataStr,"[next]",6)
	q:Source="" "false" 
	s Remarks=$p(dataStr,"[next]",7)

	s bobj = ##class(web.CDSSEntity.IMP.ConDiseaseDict).%New()
	s bobj.ID = ""
	s bobj.DiseaseCode= DiseaseCode		//客户诊断代码
	s bobj.DiseaseName= DiseaseName		//客户诊断名
	s bobj.ICDCode=ICDCode				//客户ICD
	s bobj.Source=Source				//来源（住院/门诊/急诊）
	s bobj.HospitalDR =hosp				//所属医院
	s bobj.State="未关联"				//状态（未关联/已关联/已确认/已删除）
	s bobj.Remarks=Remarks
	s bobj.CreateDate=$ZDATETIME($HOROLOG,3)		//创建时间（诊断数据导入或者手动新增的时间）
	s bobj.CreateUser=$g(%session.Data("LOGON.USERNAME"))		//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
	s bobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))		//修改人
	s bobj.StartDate=StartDate
	s bobj.EndDate=EndDate
	
	s re=..SaveEntity(bobj)
	if (re["true")
	{
		s result="true"	
	}
	else
	{
		s result="false"
	}
	
	q result
}

/// Creator：阚延新
/// CreatDate: 2020-12-31
/// Description：批量导入对接方诊断
/// Table:CT.WDT.CDSS.ConDiseaseDict 对接方诊断字典表
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConDiseaseDict).ImportDrugAndMap("")
ClassMethod ImportDrugAndMap(path)
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s incount=0
	s TheType=""
	s TheHosp=""
	s id=0
	Ts
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		//客户诊断代码、客户通用名、客户商品名、规格包装、厂家
		s DictCode=$p(str,",",1)	//客户诊断代码
		s DictICD=$p(str,",",2)	    //客户ICD
		s DictName=$p(str,",",3)	//客户诊断名	
		s DictType="诊断"		    //诊断
		s DictHosp=$p(str,",",4)	//医院
		
		s DictCode=$zstrip(DictCode,"<>W")
		s DictDesc=$zstrip(DictICD,"<>W")
		s DictName=$zstrip(DictName,"<>W")
		s DictHosp=$zstrip(DictHosp,"<>W")
	
		s readcount=readcount+1
		s DictRowID=$o(^CT.WDT.CDSS.ConDiseaseDictI("HospCNIndex",DictHosp,DictICD,DictCode,DictName,0))
		if (DictRowID="")
		{
			s bobj = ##class(web.CDSS.IMP.ConDiseaseDict).%New()
			s bobj.ID = eobj.ID
			
			s bobj.DiseaseCode= DictCode	//诊断代码
			s bobj.ICDCode= DictICD		    //ICD
			s bobj.DiseaseName=DictName		//诊断名
			s bobj.HospitalDR = DictHosp	//所属医院
			s bobj.Remarks=""	            //备注
			s bobj.State="未关联"		    //状态（未关联/已关联/已确认/已删除）
			
			s bobj.CreateDate=$ZDATETIME($HOROLOG,3)		//维护时间
			s eobj.CreateUser="dhcc"	    //$g(%session.Data("LOGON.USERID"))		//维护人员
			
			s bobj.CreateDate=$ZDATETIME($HOROLOG,3)		//创建时间
			s bobj.CreateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))		//创建人
			s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
			s bobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))		//修改人
			
			s re=..SaveEntity(bobj)
			if (re["true")
			{
				s savecount=savecount+1
				
			}
			else
			{
				s nosavecount=nosavecount+1	
			}
				
		}
		else
		{
			s incount=incount+1
			continue	
		}
		
	}
	w "readcount："_readcount,!
	
	w "savecount:"_savecount,!
	w "nosavecount:"_nosavecount,!
	w "已存在:"_incount,!
	
	
	q "{success:'true'}"
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：建立关联
/// Table:CT.WDT.CDSS.ConDiseaseDict
/// Input： hisid 项目诊断id，dictid 诊断知识库id，remark-备注
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConDiseaseDict).Mapping(1,7356,"")
ClassMethod Mapping(hisid As %String, dictid As %String, remark As %String = "")
{
	q:(hisid="")||(dictid="") "false"  //项目诊断id或东华诊断id为空则输出错误信息
	s result=""
	s eobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
	s eobj.ID = ""
	s eobj.ContrastType= "诊断"		//对照类型
	s eobj.ConDictCode=$lg($g(^CT.WDT.CDSS.ConDiseaseDictD(hisid)),2)	//对接方字典代码
	s eobj.ConDictName=$lg($g(^CT.WDT.CDSS.ConDiseaseDictD(hisid)),3)		//对接方字典描述
	s eobj.HospitalDR =$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(hisid)),6)	//医院
	s eobj.Remarks=remark		//备注	
	s eobj.DictCode= $lg($g(^CT.WDT.CDSS.DiseaseDictD(dictid)),2)		//知识库字典代码
	s eobj.DictName= $lg($g(^CT.WDT.CDSS.DiseaseDictD(dictid)),3)		//知识库字典描述
	q:(eobj.ConDictCode="")||(eobj.ConDictName="")||(eobj.DictCode="")||(eobj.DictName="")||(eobj.HospitalDR="") "false"	//对照表中的必填字段有一个为空就输出错误信息，不能对照
	s eobj.State="已关联"		//状态（未关联/已关联/已确认/已删除）
	s eobj.DictDR=dictid       //知识库id
	s eobj.IntDictDR=hisid 		//对接方诊断id	
	s linkresult=##class(web.CDSS.IMP.ContrastDict).SaveEntity(eobj)
	if (linkresult["false")		//保存失败
	{
		s result="false"	
	}
	else	//保存成功
	{
		s result="true"	
	}
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：批量关联
/// Table:CT.WDT.CDSS.ConDiseaseDict
/// Input：HisID-项目诊断字典id，DictIDStr 东华诊断id串（用,分开），remark-备注，hospareaDR-院区id
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConDiseaseDict).BatchMapping(250391,00001111,"测试商品名1228111","胃散,乙醇","","101||14")
ClassMethod BatchMapping(HisID As %String, DictIDStr As %String, remark As %String, hospareaDR As %String)
{
	q:(HisID="")||(DictIDStr)="" "{success:'false',errorinfo:'传入的项目数据id或者东华知识id为空！'}"
	s result=""
	TS	
	//先删除原来的对照
	s flag=$o(^CT.WDT.CDSS.ContrastDictI("NameIndex","诊断",HisID,""))
	if ((flag'=""))
	{
		s result=##class(web.CDSS.IMP.ContrastDict).CancelMapping(HisID,"诊断")
	}
	//s result=##class(web.CDSS.IMP.ContrastDict).CancelMapping(HisID,"诊断")
	if (result'["false")
	{
		//再重新保存对照数据
		s DictTotal=$l(DictIDStr,",")
		for DictLen=1:1:DictTotal
		{
			s dictid=$p(DictIDStr,",",DictLen)
			s result=..Mapping(HisID,dictid,remark)
			if (result["false")
			{
				q
			}
		}
	}
	//把对接方诊断字典的数据改为已关联的状态
	if (result'["false")
	{
		s result=..UpdateState(HisID,"已关联")
	}
	//保存对接方字典关联院区 
	if (result'["false")&&((hospareaDR="")||(hospareaDR["||"))  //如果传入的院区为空 或是正确的格式才保存对接方字典关联院区 ，如果不是正确的格式则不需要处理该表数据
	{

		//找到这个诊断关联的院区（有多个的用英文,拼接）
		s HospAreaDRStr=""
		s HospAreaID=0
		for
		{
			s HospAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex","诊断",HisID,HospAreaID))
			q:HospAreaID=""
			s:HospAreaDRStr'="" HospAreaDRStr=HospAreaDRStr_","
			s HospAreaDRStr=HospAreaDRStr_HospAreaID
		}

		if (HospAreaDRStr'=hospareaDR)  //如果原来关联的院区和传入的院区数据不一致
		{
			s result=##class(web.CDSS.IMP.ConDictConArea).DelHospArea("诊断",HisID)  //先删除之前的关联院区
			//重新关联院区，否则对接方关联院区表会有冗余数据
			if (hospareaDR'="")&&(result'["false")
			{
				s areatotal=$l(hospareaDR,",")
				for areai=1:1:areatotal
				{
					s areaID=$p(hospareaDR,",",areai)
					s result=##class(web.CDSS.IMP.ConDictConArea).SaveData("","诊断",HisID,areaID)
					if (result["false")
					{
						q
					}
				}
			}
		}
	}
	if (result["false")
	{
		tro
		s result="{success:'false',errorinfo:'关联失败！'}"
	}
	else
	{
		tc	
		s result="{success:'true',saveid:'"_HisID_"'}"	
	}		
	q result
}

/// Creator：阚延新
/// CreatDate: 2020-12-31
/// Description：导出当前的查询内容
/// Table:CT.WDT.CDSS.ConDiseaseDict 对接方诊断字典表
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConDiseaseDict).ExportMapping("","","","58","","","","","")
ClassMethod ExportMapping(source As %String, name As %String, id As %String, hosp As %String, state As %String, dhcname As %String, icd As %String, dhcicd As %String, remarks As %String)
{
		
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"诊断字典对照结果.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\IMP\DataExport\"_fileName*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"诊断字典对照结果.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\IMP\DataExport\"
		s file=Path_"scripts\bdp\CDSS\IMP\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/IMP/DataExport/"
		s file=Path_"scripts/bdp/CDSS/IMP/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){d ##class(%File).CreateDirectoryChain(DirName)}
	
	
	o file:"NWS"
	u file
	
	w "来源	客户诊断代码	客户ICD	客户诊断名	东华ICD	东华诊断名	状态	类型	医院	备注"

	
	s:name'="" name=$ZCONVERT(name,"U") //转换成大写
	s:dhcname'="" dhcname=$ZCONVERT(dhcname,"U") //转换成大写
	s:icd'="" icd=$ZCONVERT(icd,"U") //转换成大写
	s:dhcicd'="" dhcicd=$ZCONVERT(dhcicd,"U") //转换成大写
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.ConDiseaseDictD(ID))
		q:ID=""
		s DiseaseCode= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),2)
		continue:((id'="")&&($ZCONVERT(DiseaseCode,"U")'[id))
		s DiseaseName= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),3)
		continue:((name'="")&&($ZCONVERT(DiseaseName,"U")'[name))
		s Source= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),4) 
		continue:((source'="")&&($ZCONVERT(Source,"U")'[source))
		s ICDCode= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),5)
		continue:((icd'="")&&($ZCONVERT(ICDCode,"U")'[icd))
		s HospitalDesc=""
		s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(ID)),6)	//所属医院
		continue:((hosp'="")&&(HospitalDR'=hosp))
		s:HospitalDR'="" HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s Remarks= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),7)
	   	s State= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),8)
		if (state="")	//默认不显示 已删除
		{
			continue:(State="已删除")
		}
		else
		{
			continue:(State'=state)
		}
		s CreateDate= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),9)
		s CreateUser= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),10)
		s UpdateDate= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),11)
		s UpdateUser= $lg($g(^CT.WDT.CDSS.ConDiseaseDictD(ID)),12)
		
		
		s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"诊断",ID,0))
		s DictNameStr="",DictCodeStr="",DictIDStr="",MKBICDConNumberStr="" //知识库描述串、知识库代码串、ID串
		s RowID=ID,DictID="",DictCode= "",DictName= "",ConState=State,ConRemarks="",MKBICDConNumber=""  //需要输出的字段：对接方字典id，知识库字典ID、代码、描述、对照状态（改为输出字典的状态）、对照备注

		if (haveState'="")
		{
			s ConState=""
			for
			{
				s ConState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"诊断",ID,ConState))
				q:ConState=""
				if (state="已删除"){
					continue:(ConState'=state)			
				}
				else{
					continue:(ConState="已删除")
					continue:((state'="")&&(ConState'=state))
				}
				s ConID=0
				for
				{
					s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"诊断",ID,ConState,ConID))
					q:ConID=""
					s RowID=ConID
					
					s DictCodes= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),2)		//知识库字典代码
					s DictNames= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),3)		//知识库字典描述
					s MKBICDConNumbers=..GetDiseaseICD(DictNames)
					
					s size=$l(DictCodes,",")
					for i=1:1:size
					{
    					s DictCode=$p(DictCodes,",",i)
    					s DictName=$p(DictNames,",",i)
    					s MKBICDConNumber=$p(MKBICDConNumbers,",",i)
    					continue:((dhcname'="")&&($ZCONVERT(DictName,"U")'[dhcname)) 
						continue:((dhcicd'="")&&($ZCONVERT(MKBICDConNumber,"U")'[dhcicd))
						s ConDictCode=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),5)		//对接方字典代码
						s ConDictName=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),6)		//对接方字典描述
						s ConState=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),7)		    //状态（已关联/已确认/已删除）
						s ConRemarks=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),9)		//备注
						continue:((remarks'="")&&($ZCONVERT(ConRemarks,"U")'[remarks))
						w !,Source_"	"_DiseaseCode_"	"_ICDCode_"	"_DiseaseName_"	"_MKBICDConNumber_"	"_DictName_"	"_ConState_"	"_"诊断	"_HospitalDesc_"	"_ConRemarks
					}
				}				
			} 
		}
		else
		{
			w !,Source_"	"_DiseaseCode_"	"_ICDCode_"	"_DiseaseName_"	"_MKBICDConNumber_"	"_DictName_"	"_ConState_"	"_"诊断	"_HospitalDesc_"	"_ConRemarks
		}
		
	}
	c file
	q fileName
}

/// Creator：阚延新
/// CreatDate: 2020-12-31
/// Description：导出导入模板
/// Table:CT.WDT.CDSS.ConDiseaseDict
/// Input： 
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConDiseaseDict).ExportTemplate()
ClassMethod ExportTemplate()
{
		
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="对接方诊断字典表导入模板.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\IMP\DataExport\"_fileName
	s file=##class(%File).%New(P)*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"对接方诊断字典表导入模板.csv"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\IMP\DataExport\"
		s file=Path_"scripts\bdp\CDSS\IMP\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/IMP/DataExport/"
		s file=Path_"scripts/bdp/CDSS/IMP/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){d ##class(%File).CreateDirectoryChain(DirName)}
	
	
	d file.Open("NWS")
	d file.Write("客户诊断代码,"_"客户诊断名,"_"客户ICD,"_"来源,"_"备注,"_"医院")
	d file.WriteLine()
	
	d file.%Save()
	d file.%Close()
	q fileName
}

/// Creator：阚延新
/// CreatDate: 2021-1-7
/// Description：获取最近一次新增数据时间
/// Table:CT.WDT.CDSS.ConDiseaseDict
/// Input： hospid 医院id
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConDiseaseDict).GetLastTime(hospid)
ClassMethod GetLastTime(hosp)
{
	s lasttime=""
	
	if ($d(^CT.WDT.CDSS.ConDiseaseDictI("CreateDateIndex",hosp)))
	{
		s lasttime=$o(^CT.WDT.CDSS.ConDiseaseDictI("CreateDateIndex",hosp,""),-1)
	}	
	q lasttime
}

/// w ##class(web.CDSS.IMP.ConDiseaseDict).DiseaseProcessing("Graves病")
ClassMethod DiseaseProcessing(Desc As %String)
{
	q:Desc="" ""
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.DiseaseDictD(ID))
		q:ID=""
		s state=$lg($g(^CT.WDT.CDSS.DiseaseDictD(ID)),18)  //知识库数据不是可对照状态
		continue:(state'=2)
		s Name=$zconvert($lg($g(^CT.WDT.CDSS.DiseaseDictD(ID)),3),"U")  
		s AliasName=$zconvert($lg($g(^CT.WDT.CDSS.DiseaseDictD(ID)),7),"U")
		s Name=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(Name)
		s AliasName=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(AliasName)
		s flag=0 
		if (AliasName'="")
		{
			for m=1:1:$l(AliasName,",")
			{
				s AliasDesc=$p(AliasName,",",m)
				if (Desc=AliasDesc)
				{
					s flag=1
				}
			}
		}
		q:flag=1
		q:Desc=$Replace(Name,"-","")
		q:$Replace(Desc,"-","")=$Replace(Name,"-","")
		q:$Replace(Desc,"-","")=Name
		q:Desc=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		q:##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Desc)=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		q:##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Desc)=Name
		q:Desc=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		q:##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Desc)=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		q:##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Desc)=Name
	}
	q ID
}

/// w ##class(web.CDSS.IMP.ConDiseaseDict).CountStudents("6")
ClassMethod UpdateConEndDate(hosp As %String) As %Integer
{
	s EndDate=$zdt($h-1,3)
	s EndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(EndDate)
	s hospDR=hosp

	&sql(
	UPDATE CT_WDT_CDSS.ConDiseaseDict 
	SET EndDate=:EndDate 
	WHERE HospitalDR=:hospDR)
	if (SQLCODE=0)
	{
		s result="设置截止日期成功"	
	}
	else
	{
		s result="设置截止日期失败"	
	}
	q result
}

/// Creator:胡宜良
/// CreatDate: 2023-02-23
/// Description：删除关联，将状态改已删除
/// Table:CT.WDT.CDSS.ConDiseaseDict 对接方诊断字典表
/// Input: id，remark 备注
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ConDiseaseDict).DelMapping()
ClassMethod DelMapping(id, remark)
{
	q:id="" "{success:'false',errorinfo:'对象不存在！'}"
	s obj=##class(CT.WDT.CDSS.ConDiseaseDict).%OpenId(id)
		
	s bobj = ##class(web.CDSSEntity.IMP.ConDiseaseDict).%New()
	s bobj.ID = id
	s bobj.DiseaseCode= obj.DiseaseCode							//代码
	s bobj.DiseaseName= obj.DiseaseName							//名称
	s bobj.ICDCode=obj.ICDCode									//ICD
	s bobj.Source=obj.Source									//来源（住院/门诊/急诊）
	s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id() //所属医院
	s bobj.Remarks=obj.Remarks	                                //备注
	s bobj.State="已删除"		                                    //状态（未关联/已关联/已确认/已删除）
	
	        
	s bobj.CreateDate=obj.CreateDate		                     //创建时间（诊断数据导入或者手动新增的时间）
	s bobj.CreateUser=obj.CreateUser		                     //创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		             //修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
	s bobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))		 //修改人	
	
	d obj.%Close()
	
	s result=..SaveEntity(bobj)		
			
	q result
}

/// Creator：胡宜良
/// CreatDate: 2023-03-15
/// Description：生成诊断检索索引(名称或别名中包含括号或者-的)  ^TEMPCDSSCON("DiseaseIndex") 
/// Input： 
/// Return：""
/// w ##class(web.CDSS.IMP.ConDiseaseDict).CreateDiseaseIndex()
ClassMethod CreateDiseaseIndex()
{
	k ^TEMPCDSSCON("DiseaseIndex")
	s DiseaseID=0
	for 
	{
		s DiseaseID=$o(^CT.WDT.CDSS.DiseaseDictD(DiseaseID))
		q:DiseaseID=""
		s state=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),18)  
		continue:(state'=2)  //知识库数据不是已审核状态则跳过
		s Name=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),3)
		s Name=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(Name)
		s Name=$zconvert(Name,"U")
		continue:Name=""
		
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("DiseaseIndex",1,NewName,DiseaseID)=""
		}
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("DiseaseIndex",2,NewName,DiseaseID)=""
		}
		s NewName=$Replace(Name,"-","")
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("DiseaseIndex",3,NewName,DiseaseID)=""
		}
		s AliasName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseID)),7)	
		s flag=0 
		if (AliasName'="")
		{
			s AliasName=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(AliasName)
			s AliasName=$zconvert(AliasName,"U")
			for m=1:1:$l(AliasName,",")
			{
				s AliasDesc=$p(AliasName,",",m)
				continue:AliasDesc=""
				
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("DiseaseIndex",1,NewAliasDesc,DiseaseID)=""
				}
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("DiseaseIndex",2,NewAliasDesc,DiseaseID)=""
				}
				s NewAliasDesc=$Replace(AliasDesc,"-","")
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("DiseaseIndex",3,NewAliasDesc,DiseaseID)=""
				}
			}
		}
	}
	q ""
}

/// Creator：胡宜良
/// CreatDate: 2023-03-14
/// Description：通过名称找知识库字典ID
/// Table:CT.WDT.CDSS.DiseaseDict\CT.WDT.CDSS.Alias
/// Input： DictName-诊断名称
/// Return：RowID—诊断字典ID
/// Other: w ##class(web.CDSS.IMP.ConDiseaseDict).FindDictIdByName("安立泽片")
ClassMethod FindDictIdByName(DictName)
{
	q:DictName="" ""
	s RowID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$zconvert(DictName,"U"),0)) 	 //通过名称匹配		
	if (RowID'="")	//判断是否已审核
	{
		s flag=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RowID)),18)
		s:flag'=2 RowID=""
	}
	if (RowID="")
	{
		s RowID=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.DiseaseDict"," "_$zconvert(DictName,"U"),0)) //通过别名匹配
		if (RowID'="") //判断是否已审核
		{
			s flag=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RowID)),18)
			s:flag'=2 RowID=""
		}
			
	}
	q RowID
}

/// Creator：胡宜良	
/// CreatDate: 2023-04-03
/// Description：删除 对接方诊断字典表未关联数据
/// Table:CT.WDT.CDSS.ConDiseaseDict 对接方诊断字典表未关联数据
/// Input：hosp 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.IMP.ConDiseaseDict).DeleteUnlinkedData(31)
ClassMethod DeleteUnlinkedData(hosp As %String) As %String
{
	s result="" 
	s id=0 
	for
	{
		s id=$o(^CT.WDT.CDSS.ConDiseaseDictI("HospStateIndex",hosp,"未关联",id))
		q:id=""
			
		s pobj = ##class(CT.WDT.CDSS.ConDiseaseDict).%OpenId(id)
		s eobj = ##class(web.CDSSEntity.IMP.ConDiseaseDict).%New()
		
		s eobj.DiseaseCode= pobj.DiseaseCode							//代码
		s eobj.DiseaseName= pobj.DiseaseName							//名称
		s eobj.ICDCode=pobj.ICDCode									//ICD
		s eobj.Source=pobj.Source									//来源（住院/门诊/急诊）
		s:pobj.HospitalDR'="" eobj.HospitalDR = pobj.HospitalDR.%Id() //所属医院
		s eobj.Remarks=pobj.Remarks	                                //备注
		s eobj.State=pobj.State		                                    //状态（未关联/已关联/已确认/已删除）
		s eobj.CreateDate=pobj.CreateDate		                     //创建时间（诊断数据导入或者手动新增的时间）
		s eobj.CreateUser=pobj.CreateUser		                     //创建人
		s eobj.UpdateDate=pobj.UpdateDate		             //修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s eobj.UpdateUser=pobj.UpdateUser		 //修改人
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(CT.WDT.CDSS.ConDiseaseDict).%DeleteId(id)
		IF $$$ISOK(sc)
		{
			
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ConDiseaseDict","CT.WDT.CDSS.ConDiseaseDict","对接方诊断字典表",id,eobj.HospitalDR_"-"_eobj.DiseaseCode_"-"_eobj.DiseaseName,"D",eobj)
		}
		else
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("对接方诊断字典表","web.CDSS.IMP.ConDiseaseDict","DeleteUnlinkedData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	q result
}

}
