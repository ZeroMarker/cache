Import SQLUser

/// 名称: 字典对照-手术对照界面维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-徐文虎
/// 编写日期: 2020-12-24
Class web.CDSS.IMP.ConOperDict Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:徐文虎
/// CreatDate:2020-12-24
/// Description:查询数据
/// Table：CT.WDT.CDSS.ConOperDict
/// Input：rowid,source(来源),operationName(客户手术名称),operationCode(客户手术代码),state(状态),dhoperationName(东华手术名称),hospid(医院),sortmethod(排序方法)
/// Return: ID:OperationCode:OperationName:Source:DHOperationName:State:Remarks:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.ConOperDict","GetList","","","","","","","","","","","CreateTime")
Query GetList(rowid As %String, source As %String, operationName As %String, operationCode As %String, state As %String, dhoperationName As %String, hospid As %String, icd As %String, dhcicd As %String, remarks As %String, sortmethod As %String) As %Query(ROWSPEC = "RowID:%String,OperationCode:%String,OperationName:%String,Source:%String,ICDCode:%String,DictID:%String,DHOperationName:%String,State:%String,Remarks:%String,MKBICDConNumber:%String,HospAreaDesc,HospitalAreaDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, source As %String, operationName As %String, operationCode As %String, state As %String, dhoperationName As %String, hospid As %String, icd As %String, dhcicd As %String, remarks As %String, sortmethod As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryLabel).DHCGetDataByDefaultSession()
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    s:operationName'="" operationName=$ZCONVERT(operationName,"U") //转换成大写
	s:operationCode'="" operationCode=$ZCONVERT(operationCode,"U") //转换成大写
	s:dhoperationName'="" dhoperationName=$ZCONVERT(dhoperationName,"U") //转换成大写
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写
	s:icd'="" icd=$ZCONVERT(icd,"U") //转换成大写
	s:dhcicd'="" dhcicd=$ZCONVERT(dhcicd,"U") //转换成大写
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s ID=rowid
		s HospAreaDR="",HospAreaDesc="",HospitalAreaDR="",HospitalAreaDRStr=""
		for
		{
			s HospAreaDR=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex","手术",ID,HospAreaDR))
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
		s OperationCode=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),2) //客户手术字典代码
        s OperationName=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),3) //客户手术字典名称
        s Source=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),4) //来源
        s HospitalDR=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),5) //医院
        s Remarks=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),6) //备注
        s State=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),7) 
        s ICDCode=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),12) //icd
        s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"手术",ID,0))
		
		s DictNameStr="",DictCodeStr="",DictIDStr="",MKBICDConNumberStr="" //知识库描述串、知识库代码串、ID串
		s RowID=ID,DictID="",DictCode= "",DHOperationName= "",ConState=State,ConRemarks=""  //需要输出的字段：对接方字典id，知识库字典ID、代码、描述、对照状态（改为输出字典的状态）、对照备注

		if (haveState'="")  //如果有对照
		{
			//走对照表，找对接的知识库id、代码、描述
			s ContrastState=""
			for
			{
				s ContrastState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"手术",ID,ContrastState))
				q:ContrastState=""
				
				s ConID=0
				for
				{
					s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"手术",ID,ContrastState,ConID))
					q:ConID=""
					
					s DictID=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),10)		//知识库字典ID
					s DictCode= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),2)		//知识库字典代码
					s DictName= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),3)		//知识库字典描述
					//知识库描述串
					if (DictNameStr=""){
						s DictNameStr=DHOperationName
					}
					else{
						s DictNameStr=DictNameStr_","_DHOperationName
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
					s ConDictCode=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),5)		//对接方字典代码
					s ConDictName=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),6)		//对接方字典描述
					s ConRemarks=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),9)		//备注
					
				}				
			}
		} 
		s DHOperationName=DictNameStr,DictCode=DictCodeStr,DictID=DictIDStr   //给需要输出的字段：知识库字典ID、代码、描述重新赋值，多个的话拼串
		d OutputRow
    }
    else
    {
	    k ^TempDataHandle
	    if (hospid'="")
		{
		//RowID,DrugCode,DrugName,DrugTradeName,Source,Manufacturers,Specification,HospitalDR,DictHospDesc,Remarks,DictCode,DictName,ConState
		if (sortmethod="Short")
		{
			s num=0
			s CreateTime=""
			for
			{
				s CreateTime=$o(^CT.WDT.CDSS.ConOperDictI("CreateDateIndex",hospid,CreateTime),-1)
				q:CreateTime=""
				s ID=0
				for 
				{
					s ID=$o(^CT.WDT.CDSS.ConOperDictI("CreateDateIndex",hospid,CreateTime,ID))
					q:ID=""
					s OperationCode= $lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),2)		//代码
					s OperationName= $lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),3)		//名称
					s length=$l(OperationName)
					s ^TempDataHandle("Short",length,ID)=ID
				}
			}
			s num=0
			s le=0
			for
			{
				s le=$o(^TempDataHandle("Short",le))
				q:le=""
				s OperID=0
				for
				{
					s OperID=$o(^TempDataHandle("Short",le,OperID))
					q:OperID=""
					s num=num+1
					s ^TempDataHandle("Handle",num)=OperID
				}
			}
		}	
		
		
		elseif (sortmethod="UpdateTime")
		{
			s num=0
			s UpdateTime=""
			for
				{
					s UpdateTime=$o(^CT.WDT.CDSS.ConOperDictI("UpdateDateIndex",hospid,UpdateTime),-1)
					q:UpdateTime=""
					s ID=0
					for
					{
						s ID=$o(^CT.WDT.CDSS.ConOperDictI("UpdateDateIndex",hospid,UpdateTime,ID))
						q:ID=""
						s num=num+1
						s ^TempDataHandle("Handle",num)=ID
					}
				}
			
				
		}
		else
		{
			s num=0
			s CreateTime=""
			for
				{
					s CreateTime=$o(^CT.WDT.CDSS.ConOperDictI("CreateDateIndex",hospid,CreateTime),-1)
					q:CreateTime=""
					s ID=0
					for
					{
						s ID=$o(^CT.WDT.CDSS.ConOperDictI("CreateDateIndex",hospid,CreateTime,ID))
						q:ID=""
						s num=num+1
						s ^TempDataHandle("Handle",num)=ID
					}
				}
			
		}
		}
        s Number=0
       	for {
            s Number=$o(^TempDataHandle("Handle",Number))
			q:Number=""
			s ID=^TempDataHandle("Handle",Number)
			s HospAreaDR="",HospAreaDesc="",HospitalAreaDR="",HospitalAreaDRStr=""
			for
			{
				s HospAreaDR=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex","手术",ID,HospAreaDR))
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
	       	s OperationCode=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),2) //客户手术字典代码
	       	continue:((operationCode'="")&&($ZCONVERT(OperationCode,"U")'[operationCode))
        	s OperationName=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),3) //客户手术字典名称
        	continue:((operationName'="")&&($ZCONVERT(OperationName,"U")'[operationName))
        	s Source=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),4) //来源
        	continue:((source'="")&&($ZCONVERT(Source,"U")'[source))
        	s ICDCode= $lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),12)
			continue:((icd'="")&&($ZCONVERT(ICDCode,"U")'[icd))
        	s HospitalDR=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),5) //医院
        	s DictHospDesc=""
        	continue:((hospid'="")&&(HospitalDR'=hospid))
        	s:HospitalDR'="" DictHospDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)  //医院描述
        	//s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","手术",ID,0))
        	//continue:(ConID="")
        	s State=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),7)		//状态（未关联/已关联/已确认/已删除）
        	if (state="")	//默认不显示 已删除
			{
				continue:(State="已删除")
			}
			else
			{
				continue:(State'=state)
			}
        	//continue:((state'="")&&($ZCONVERT(State,"U")'[state))
        	s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"手术",ID,0))
			
			s DictNameStr="",DictCodeStr="",DictIDStr="",MKBICDConNumberStr="" //知识库描述串、知识库代码串、ID串
			s RowID=ID,DictID="",DictCode= "",DHOperationName= "",ConState=State,ConRemarks=""  //需要输出的字段：对接方字典id，知识库字典ID、代码、描述、对照状态（改为输出字典的状态）、对照备注

			if (haveState'="")
			{
				//走对照表，找对接的知识库id、代码、描述
				s ContrastState=""
				for
				{
					s ContrastState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",hospid,"手术",ID,ContrastState))
					q:ContrastState=""
					s ConID=0
					for
					{
						s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",hospid,"手术",ID,ConState,ConID))
						q:ConID=""
						
						s DictID=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),10)		//知识库字典ID
						s DHOperationName= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),3)		//知识库字典描述
						s MKBICDConNumber=..GetOperICD(DHOperationName)							
						//知识库描述串
						if (DictNameStr=""){
							s DictNameStr=DHOperationName
						}
						else{
							s DictNameStr=DictNameStr_","_DHOperationName
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
						//continue:((dhoperationName'="")&&($ZCONVERT(DHOperationName,"U")'[dhoperationName))
						continue:((dhcicd'="")&&($ZCONVERT(MKBICDConNumber,"U")'[dhcicd))
						s OperationCode=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),5)		//对接方字典代码
						s OperationName=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),6)		//对接方字典描述
						s State=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),7)		//状态（已关联/已确认/已删除）
						s Remarks=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),9)		//备注
						continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
						//s operationNamePY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(OperationName)  //客户手术名称拼音
	        			//s dhoperationNamePY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DHOperationName)  //知识库手术名称拼音
	            		//d OutputRow
					}		
				} 
			}
			s DHOperationName=DictNameStr,DictCode=DictCodeStr,DictID=DictIDStr,MKBICDConNumber=MKBICDConNumberStr   //给需要输出的字段：知识库字典ID、代码、描述重新赋值，多个的话拼串
			if (($ZCONVERT(DHOperationName,"U")[dhoperationName))&(ConRemarks[remarks)  //满足条件则输出
			{
				d OutputRow
			}
		}
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(RowID,OperationCode,OperationName,Source,ICDCode,DictID,DHOperationName,State,Remarks,MKBICDConNumber,HospAreaDesc,HospitalAreaDR)
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
/// Description:获取当前手术的ICD字段
/// Table:CT.WDT.CDSS.ConOperDict 对接方手术字典表
/// Input:namestr, 
/// Return:
/// Other:w ##class(web.CDSS.IMP.ConOperDict).GetOperICD("Morrow手术")
ClassMethod GetOperICD(namestr As %String) As %String
{
	s dicttotal=$l(namestr,",")
	s icdstr=""
	
	for m=1:1:dicttotal
	{
		s icd=""
		s dictname=$p(namestr,",",m)
		s id=$o(^CT.WDT.CDSS.OperationDictI("NameIndex"," "_$zconvert(dictname,"U"),0))
		s:id'="" icd=$lg($G(^CT.WDT.CDSS.OperationDictD(id)),3)
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

/// Creator：徐文虎
/// CreatDate:2020-12-28
/// Description：数据重复验证方法(验证code，name)
/// Table：CT.WDT.CDSS.ConOperDict
/// Input：id,operationcode,operationname,hospitaldr
/// Return："1"(数据重复),"0"(数据不重复)
/// Other: w ##class(web.CDSS.IMP.ConOperDict).FormValidate("","zlqc","","1")
ClassMethod FormValidate(id As %String, icdcode As %String, code As %String, name As %String, hosp As %String) As %String
{
	s flag="",flagc=""
	s:icdcode="" icdcode=-100000000000000
	s:((hosp'="")&&(name'="")) flagc=$d(^CT.WDT.CDSS.ConOperDictI("HospCNIndex",hosp,code,name,icdcode))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:((hosp'="")&&(name'="")) idc=$o(^CT.WDT.CDSS.ConOperDictI("HospCNIndex",hosp,code,name,icdcode,0))
		if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:徐文虎
/// CreatDate:2020-12-28
/// Description：保存对接方手术字典表内容
/// Table：CT.WDT.CDSS.ConOperDict
/// Input：web.CDSSEntity.IMP.ConOperDict 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.IMP.ConOperDict).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.IMP.ConOperDict, LogFlag As %String = "") As %String
{
    s result=""
    if $IsObject(eobj)
    {   
    	s:eobj.Source="" eobj.Source="住院"
		s:eobj.UpdateDate="" eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
	    s:eobj.UpdateUser="" eobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
	    s:eobj.OperationCode="" eobj.OperationCode=..getFactorCode()
        s flag=..FormValidate(eobj.ID,eobj.ICDCode,eobj.OperationCode,eobj.OperationName,eobj.HospitalDR)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.ConOperDict).%New()
                s:eobj.CreateDate="" eobj.CreateDate=$ZDATETIME($HOROLOG,3)
	        	s:eobj.CreateUser="" eobj.CreateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
	        	s:eobj.UpdateDate="" eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
	        	s:eobj.UpdateUser="" eobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
            }
            else             //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.ConOperDict).%OpenId(eobj.ID)
                s bobj=##class(web.CDSSEntity.IMP.ConOperDict).%New()
                s bobj.ID=eobj.ID
                s bobj.OperationCode=obj.OperationCode				//手术代码
                s bobj.OperationName = obj.OperationName        	//手术名称
                s bobj.Remarks=obj.Remarks							//备注
                s bobj.Source=obj.Source							//来源
                s bobj.ICDCode=obj.ICDCode                          //icd
                s:obj.HospitalDR'="" bobj.HospitalDR=obj.HospitalDR.%Id()				//医院
                s bobj.State=obj.State								//状态
                s bobj.CreateUser=obj.CreateUser					//创建用户
                s bobj.CreateDate=obj.CreateDate					//创建时间
                s bobj.UpdateUser=obj.UpdateUser					//更新用户
                s bobj.UpdateDate=obj.UpdateDate					//更新时间
                s bobj.StartDate=obj.StartDate						//医嘱开始时间
				s bobj.EndDate=obj.EndDate							//医嘱开始时间    
            }
            s obj.OperationCode = eobj.OperationCode				//手术代码
            s obj.OperationName = eobj.OperationName       			//手术名称
            s obj.Remarks=eobj.Remarks								//备注
            s obj.Source=eobj.Source								//来源
            s obj.ICDCode=eobj.ICDCode	
           	d:eobj.HospitalDR'="" obj.HospitalDRSetObjectId(eobj.HospitalDR)
           	d:eobj.HospitalDR="" obj.HospitalDRSetObjectId("")		//医院
           	s obj.State=eobj.State
           	s obj.CreateDate=eobj.CreateDate						//创建时间
           	s obj.CreateUser=eobj.CreateUser						//创建用户
           	s obj.UpdateUser=eobj.UpdateUser						//更新用户
           	s obj.UpdateDate=eobj.UpdateDate						//更新时间
           	s obj.StartDate=eobj.StartDate							//医嘱开始时间
			s obj.EndDate=eobj.EndDate								//医嘱开始时间
        	Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
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
							s resultx=##class(web.CDSS.IMP.ConDictConArea).SaveData("","手术",id,areaID)
							if (resultx["false")
							{
								q
							}
						}
						//d ##class(web.CDSS.IMP.ConDictConArea).SaveData("","手术",id,eobj.HospitalAreaDR)
					}
				}
                if (LogFlag="")
				{
                //保存日志
				d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConOperDict","CT.WDT.CDSS.ConOperDict","对接方手术字典表",id,eobj.OperationName,"A",eobj)
				d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConOperDict","CT.WDT.CDSS.ConOperDict","对接方手术字典表",eobj.ID,eobj.OperationName,"U",eobj,bobj)
				}
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("对接方手术字典表","web.CDSS.IMP.ConOperDict","SaveData",eobj)
       	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }
        }               
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
    s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("对接方手术字典表","web.CDSS.IMP.ConOperDict","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：阚延新
/// Description：得到新增数据的code
/// Table:CT.WDT.CDSS.ConOperDict对接方手术对照表
/// Input：id
/// Other: w ##class(web.CDSS.IMP.ConOperDict).getFactorCode()
ClassMethod getFactorCode() As %String
{
    s dataid = $o(^CT.WDT.CDSS.ConOperDictD(""),-1)
    s result=""
	if (dataid=""){
		s result=1
	}else{
		s result = dataid+1
	}
	q result
}

/*/// Creator：徐文虎 
/// CreatDate: 2020-01-04
/// Description:删除限制
/// Input：id 
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.IMP.ConoperDict).GetRefFlag("97")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
    s flag=0
    
	s OperationCode= $lg($g(^CT.WDT.CDSS.ConOperDictD(id)),2)		//代码
	s OperationName= $lg($g(^CT.WDT.CDSS.ConOperDictD(id)),3)		//名称
	s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConOperDictD(id)),5)	//所属医院
	s State=""
	for
	{
		s State=$o(^CT.WDT.CDSS.ContrastDictI("ConNameStateIndex",HospitalDR,"手术",OperationName,State))
		q:State=""
		s DictHospDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s myInfo=myInfo_"<字典对照表:"_DictHospDesc_"-手术>"		
	}	
	
	if myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:徐文虎
/// CreatDate:2020-12-29
/// Description：根据ID删除对接方手术字典表的内容
/// Table：CT.WDT.CDSS.ConOperDict
/// Input：id-对接方手术字典表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.IMP.ConOperDict).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s Flag=$p(..GetRefFlag(id),"^",1)
	s msg=$p(..GetRefFlag(id),"^",2)
	if (Flag=1){						//删除限制
		q "{success:'false',errorinfo:'该数据"_msg_"'}"	
	}else{		
		s pobj=##class(CT.WDT.CDSS.ConOperDict).%OpenId(id)
		s eobj = ##class(web.CDSSEntity.IMP.ConOperDict).%New()
	
		s eobj.OperationCode= pobj.OperationCode		//代码
		s eobj.OperationName= pobj.OperationName		//描述
		s eobj.Source=pobj.Source						//来源
		s:pobj.HospitalDR'="" eobj.HospitalDR=pobj.HospitalDR   //医院指针
		s eobj.Source=pobj.Source		//来源（住院/门诊/急诊）
		s eobj.Remarks=pobj.Remarks	 //备注
		s eobj.State=pobj.State		//状态（未关联/已关联/已确认/已删除）
		s eobj.CreateDate=pobj.CreateDate		//创建时间（手术数据导入或者手动新增的时间）
		s eobj.CreateUser=pobj.CreateUser		//创建人
		s eobj.UpdateDate=pobj.UpdateDate		//修改时间（对应的就是所有操作时间包括 删除 确认 关联 取消关联）
		s eobj.UpdateUser=pobj.UpdateUser		//修改人

		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(CT.WDT.CDSS.ConOperDict).%DeleteId(id)
		IF $$$ISOK(sc)	//删除成功
		{
		
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("DHCDSSConOperDict","CT.WDT.CDSS.ConOperDict","对接方手术字典表",id,eobj.HospitalDR_"-"_eobj.OperationCode,"D",eobj)
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("对接方手术字典表","web.CDSS.IMP.ConOperDict","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	q result
}*/
/// Creator：徐文虎 
/// CreatDate: 2020-12-29
/// Description：修改对接方手术字典表的状态
/// Table:CT.WDT.CDSS.ConOperDict
/// Input： id, state(状态)
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConOperDict).UpdateState("","")
ClassMethod UpdateState(id, state)
{
	q:id="" "false"
	s obj=##class(CT.WDT.CDSS.ConOperDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.IMP.ConOperDict).%New()
	s bobj.ID = id
	
	s bobj.OperationCode= obj.OperationCode		//代码
	s bobj.OperationName= obj.OperationName		//描述
	s bobj.ICDCode=obj.ICDCode						//ICD
	s bobj.Source=obj.Source						//来源
	s:obj.HospitalDR'="" bobj.HospitalDR=obj.HospitalDR.%Id()   //医院指针
	s bobj.Source=obj.Source		//来源（住院/门诊/急诊）
	s bobj.Remarks=obj.Remarks	 //备注
	s bobj.State=state		//状态（未关联/已关联/已确认/已删除）
	s bobj.CreateDate=obj.CreateDate		//创建时间（手术数据导入或者手动新增的时间）
	s bobj.CreateUser=obj.CreateUser		//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		//修改时间（对应的就是所有操作时间包括 删除 确认 关联 取消关联）
	s bobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))		//修改人
	
	s result= ..SaveData(bobj)
	q result
}

/// Creator: 徐文虎 
/// CreatDate: 2020-12-29
/// Description: 手术对照--批量导入对接方手术
/// Table:CT.WDT.CDSS.ConOperDict
/// Input: path
/// Return:	读取数，导入成功数，导入失败数，已存在数
/// Other: w ##class(web.CDSS.IMP.ConOperDict).ImportOperAndMap("")
ClassMethod ImportOperAndMap(path)
{
	s readcount=0   	//读取总数
	s savecount=0		//导入成功总数
	s nosavecount=0 	//导入失败总数
	s incount=0			//已存在总数
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
		
		//客户手术代码、客户手术名称、来源、类型、医院
		s ConDictCode=$p(str,",",1)	//手术代码
		s ConDictName=$p(str,",",2)	//手术名称
		s Source=$p(str,",",3)	//来源
		s ConDictType="手术"		//手术
		s ConDictHosp=$p(str,",",4)	//医院
		s ICD=$p(str,",",5)	//icd
		
		//去除两端空白
		s ConDictCode=$zstrip(ConDictCode,"<>W")
		s ConDictName=$zstrip(ConDictName,"<>W")
		s Source=$zstrip(Source,"<>W")
		s ConDictHosp=$zstrip(ConDictHosp,"<>W")
		s ICD=$zstrip(ICD,"<>W")
	
		s readcount=readcount+1
		s ConDictRowID=$o(^CT.WDT.CDSS.ConOperDictI("HospCNIndex",ConDictHosp,ConDictCode,ConDictName,ICD,0))
		if (ConDictRowID="")
		{
			s bobj = ##class(web.CDSSEntity.IMP.ConOperDict).%New()
			s bobj.ID = ""
			s bobj.OperationCode= ConDictCode		//代码
			s bobj.OperationName= ConDictName		//名称
			s bobj.Source=Source				//来源
			s bobj.HospitalDR = ConDictHosp		//所属医院
			s bobj.Remarks=""					//备注
			s bobj.State="未关联"				//状态（未关联/已关联/已确认/已删除）
			//s bobj.CreateDate=$ZDATETIME($HOROLOG,3)		//维护时间
			//s bobj.CreateUser="dhcc"	//$g(%session.Data("LOGON.USERID"))		//维护人
			s bobj.CreateDate=$ZDATETIME($HOROLOG,3)		//创建时间（手术数据导入或者手动新增的时间）
			s bobj.CreateUser=$g(%session.Data("LOGON.USERNAME"))		//创建人
			s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
			s bobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))		//修改人
			
			s re=..SaveData(bobj)
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
	q "{success:'true',readcount:'"_readcount_"',savecount:'"_savecount_"',nosavecount:'"_nosavecount_"',incount:'"_incount_"'}"
}

/// Creator：徐文虎 
/// CreatDate: 2020-12-29
/// Description：手术对照--导出导入模板
/// Table:CT.WDT.CDSS.ConOperDict
/// Input:
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConOperDict).ExportTemplate()
ClassMethod ExportTemplate()
{
		
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"对接方手术字典表导入模板.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\IMP\DataExport\"_fileName
	s file=##class(%File).%New(P)*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"对接方手术字典表导入模板.csv"		
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
	
	d file.Write("手术代码,"_"手术名称,"_"来源,"_"医院,"_"备注")
	d file.WriteLine()
	
	d file.%Save()
	d file.%Close()
	q fileName
}

/// Creator：徐文虎 
/// CreatDate: 2020-12-29
/// Description：手术对照--自动匹配
/// Table:CT.WDT.CDSS.ConOperDict
/// Input： hospid(医院id), id
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConOperDict).AutoMatch(1)
ClassMethod AutoMatch(hosp As %String, id As %String = "")
{
	q:(hosp="") "{success:'false',errorinfo:'自动匹配失败，传入的医院为空！'}"
	s result=""
	s linksavecount=0
	s unlinksavecount=0
	
	//生成手术检索索引(名称或别名中包含括号或者-的数据处理后生成到一个临时global里，用于后面的匹配)
	d ##class(web.CDSS.IMP.ConOperDict).CreateOperIndex()
	
	//遍历所有未关联的手术
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.ConOperDictI("HospStateIndex",hosp,"未关联",ID))
		q:ID=""
		continue:((id'="")&&(id'=ID))
		s TrastID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","手术",ID,0)) //当前数据在对照表中的ID
		s DictCode= $lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),2)		//代码
		//s DictDesc= $lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),3)		//通用名
		s DictName=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),3)		//商品名		
		
		 //0 从已确认数据中找名称相同的数据
		s OperID=$o(^CT.WDT.CDSS.ConOperDictI("StateDescIndex","已确认",DictName,0))
		s ConIDFlag=0
		s:OperID'="" ConIDFlag=$d(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","手术",OperID))
		if (ConIDFlag>0)  //如果有已确认的名称相同的数据，则跟该数据对照同样的知识库数据
		{
			s DictDRStr=""
			s ConID=0
			for
			{
				s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","手术",OperID,ConID))
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
					if (RowID="")&($d(^TEMPCDSSCON("OperIndex",1))>0)
					{
						s RowID=$o(^TEMPCDSSCON("OperIndex",1,$zconvert(DictNameNoBracket,"U"),0))
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
					if (RowID="")&($d(^TEMPCDSSCON("OperIndex",2))>0)
					{
						s RowID=$o(^TEMPCDSSCON("OperIndex",2,$zconvert(DictNameNoBracketinside,"U"),0))
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
					if (RowID="")&($d(^TEMPCDSSCON("OperIndex",3))>0)
					{
						s RowID=$o(^TEMPCDSSCON("OperIndex",3,$zconvert(DictNameNOMinus,"U"),0))
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
	k ^TEMPCDSSCON("OperIndex")
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：建立关联
/// Table:CT.WDT.CDSS.ConOperDict
/// Input： hisid 项目手术id，dictid 手术知识库id，remark-备注
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConOperDict).Mapping(1,7356,"")
ClassMethod Mapping(hisid As %String, dictid As %String, remark As %String = "")
{
	q:(hisid="")||(dictid="") "false"  //项目手术id或东华手术id为空则输出错误信息
	s result=""
	s eobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
	s eobj.ID = ""
	s eobj.ContrastType= "手术"		//对照类型
	s eobj.ConDictCode=$lg($g(^CT.WDT.CDSS.ConOperDictD(hisid)),2)	//对接方字典代码
	s eobj.ConDictName=$lg($g(^CT.WDT.CDSS.ConOperDictD(hisid)),3)		//对接方字典描述
	s eobj.HospitalDR =$LISTGET($G(^CT.WDT.CDSS.ConOperDictD(hisid)),5)	//医院
	s eobj.Remarks=remark		//备注	
	s eobj.DictCode= $lg($g(^CT.WDT.CDSS.OperationDictD(dictid)),3)		//知识库字典代码
	s eobj.DictName= $lg($g(^CT.WDT.CDSS.OperationDictD(dictid)),4)		//知识库字典描述
	q:(eobj.ConDictCode="")||(eobj.ConDictName="")||(eobj.DictCode="")||(eobj.DictName="")||(eobj.HospitalDR="") "false"	//对照表中的必填字段有一个为空就输出错误信息，不能对照
	s eobj.State="已关联"		//状态（未关联/已关联/已确认/已删除）
	s eobj.DictDR=dictid       //知识库id
	s eobj.IntDictDR=hisid 		//对接方手术id	
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
/// Table:CT.WDT.CDSS.ConOperDict
/// Input：HisID-项目手术字典id，DictIDStr 东华手术id串（用,分开），remark-备注，hospareaDR-院区id
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConOperDict).BatchMapping(250391,00001111,"测试商品名1228111","胃散,乙醇","","101||14")
ClassMethod BatchMapping(HisID As %String, DictIDStr As %String, remark As %String, hospareaDR As %String)
{
	q:(HisID="")||(DictIDStr)="" "{success:'false',errorinfo:'传入的项目数据id或者东华知识id为空！'}"
	s result=""
	TS	
	//先删除原来的对照
	s flag=$o(^CT.WDT.CDSS.ContrastDictI("NameIndex","手术",HisID,""))
	if ((flag'=""))
	{
		s result=##class(web.CDSS.IMP.ContrastDict).CancelMapping(HisID,"手术")
	}
	//s result=##class(web.CDSS.IMP.ContrastDict).CancelMapping(HisID,"手术")
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
	//把对接方手术字典的数据改为已关联的状态
	if (result'["false")
	{
		s result=..UpdateState(HisID,"已关联")
	}
	//保存对接方字典关联院区 
	if (result'["false")&&((hospareaDR="")||(hospareaDR["||"))  //如果传入的院区为空 或是正确的格式才保存对接方字典关联院区 ，如果不是正确的格式则不需要处理该表数据
	{

		//找到这个手术关联的院区（有多个的用英文,拼接）
		s HospAreaDRStr=""
		s HospAreaID=0
		for
		{
			s HospAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex","手术",HisID,HospAreaID))
			q:HospAreaID=""
			s:HospAreaDRStr'="" HospAreaDRStr=HospAreaDRStr_","
			s HospAreaDRStr=HospAreaDRStr_HospAreaID
		}

		if (HospAreaDRStr'=hospareaDR)  //如果原来关联的院区和传入的院区数据不一致
		{
			s result=##class(web.CDSS.IMP.ConDictConArea).DelHospArea("手术",HisID)  //先删除之前的关联院区
			//重新关联院区，否则对接方关联院区表会有冗余数据
			if (hospareaDR'="")&&(result'["false")
			{
				s areatotal=$l(hospareaDR,",")
				for areai=1:1:areatotal
				{
					s areaID=$p(hospareaDR,",",areai)
					s result=##class(web.CDSS.IMP.ConDictConArea).SaveData("","手术",HisID,areaID)
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

/*ClassMethod BatchMapping(HisID As %String, DictIDStr As %String, remark As %String, hospareaDR As %String)
{
	q:(HisID="")||(DictIDStr)="" "{success:'false',errorinfo:'传入的项目数据id或者东华知识id为空！'}"
	s result=""
	s HospAreaDR=""
	TS	
	//先删除原来的对照
	s flag=$o(^CT.WDT.CDSS.ContrastDictI("NameIndex","手术",HisID,""))
	if ((flag'=""))
	{
		s result=##class(web.CDSS.IMP.ContrastDict).CancelMapping(HisID,"手术")
	}
	//s result=##class(web.CDSS.IMP.ContrastDict).CancelMapping(HisID,"手术")
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
	//把对接方手术字典的数据改为已关联的状态
	if (result'["false")
	{
		s result=..UpdateState(HisID,"已关联")
	}
	//保存对接方字典关联院区
	if (result'["false")
	{
		s HospAreaDR=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex","手术",HisID,0))
		if (HospAreaDR'=hospareaDR)
		{
			s result=##class(web.CDSS.IMP.ConDictConArea).DelHospArea("手术",HisID)  //先删除之前的关联院区
			//重新关联院区，否则对接方关联院区表会有冗余数据
			if (hospareaDR'="")&(result'["false")
			{
				s result=##class(web.CDSS.IMP.ConDictConArea).SaveData("","手术",HisID,hospareaDR)
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
*/
/// Creator: 徐文虎 
/// CreatDate: 2020-12-29
/// Description：导出当前的查询内容
/// Table:CT.WDT.CDSS.ConOperDict
/// Input： source(来源) operationName(手术名称) operationCode(手术代码) state(状态) dhoperationName(东华手术名)
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConOperDict).ExportMapping("","","","未关联","","31","","","")
ClassMethod ExportMapping(source As %String, operationName As %String, operationCode As %String, state As %String, dhoperationName As %String, hospid As %String, icd As %String, dhcicd As %String, remarks As %String)
{
		
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"手术字典对照结果.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\IMP\DataExport\"_fileName
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"手术字典对照结果.txt"		
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
	
	w "来源	客户手术操作代码	客户ICD	客户手术操作名称	东华ICD	东华手术操作名称	状态	类型	医院	备注"

	
	s:operationCode'="" operationCode=$ZCONVERT(operationCode,"U") //转换成大写
	s:operationName'="" operationName=$ZCONVERT(operationName,"U") //转换成大写
	s:dhoperationName'="" dhoperationName=$ZCONVERT(dhoperationName,"U") //转换成大写
	s:icd'="" icd=$ZCONVERT(icd,"U") //转换成大写
	s:dhcicd'="" dhcicd=$ZCONVERT(dhcicd,"U") //转换成大写	
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.ConOperDictD(ID))
		q:ID=""
		s OperationCode= $lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),2)		//代码
		continue:((operationCode'="")&&($ZCONVERT(OperationCode,"U")'[operationCode))
		s OperationName= $lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),3)		//名称
		continue:((operationName'="")&&($ZCONVERT(OperationName,"U")'[operationName))
		s Source=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),4)		//来源（住院/门诊/急诊）
		continue:((source'="")&&($ZCONVERT(Source,"U")'[source))
		s ICDCode= $lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),12)
		continue:((icd'="")&&($ZCONVERT(ICDCode,"U")'[icd))
		s DictHospDesc=""
		s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConOperDictD(ID)),5)	//所属医院
		continue:((hospid'="")&&(HospitalDR'=hospid))
		
		s:HospitalDR'="" DictHospDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s Remarks=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),6)		//备注
		s State=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),7)			//状态（未关联/已关联/已确认/已删除）
		
		if (state="")	//默认不显示 已删除
		{
			continue:(State="已删除")
		}
		else
		{
			continue:(State'=state)
		}
		s CreateDate=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),14)		//创建时间（手术数据导入或者手动新增的时间）
		s CreateUser=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),15)		//创建人
		s UpdateDate=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),16)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s UpdateUser=$lg($g(^CT.WDT.CDSS.ConOperDictD(ID)),17)		//修改人
		
		s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"手术",ID,0))

		s RowID=ID,DictID="",DictCode= "",DictName= "",ConState=State,ConRemarks="",MKBICDConNumber=""  //需要输出的字段：对接方字典id，知识库字典ID、代码、描述、对照状态（改为输出字典的状态）、对照备注

		
		if (haveState'="")
		{
			s ConState=""
			for
			{
				s ConState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"手术",ID,ConState))
				q:ConState=""
				//continue:((state'="")&&(ConState'=state))
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
					s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"手术",ID,ConState,ConID))
					q:ConID=""
					s RowID=ConID
					s DictCodes= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),2)		//知识库字典代码
					s DictNames= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),3)		//知识库字典描述
					s MKBICDConNumbers=..GetOperICD(DictNames)
					
					s size=$l(DictCodes,",")
					for i=1:1:size
					{
    					s DictCode=$p(DictCodes,",",i)
    					s DictName=$p(DictNames,",",i)
    					s MKBICDConNumber=$p(MKBICDConNumbers,",",i)
    					continue:((dhoperationName'="")&&($ZCONVERT(DictName,"U")'[dhoperationName)) 
						continue:((dhcicd'="")&&($ZCONVERT(MKBICDConNumber,"U")'[dhcicd))				
						s ConDictCode=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),5)		//对接方字典代码
						s ConDictName=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),6)		//对接方字典描述
						s ConState=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),7)		//状态（已关联/已确认/已删除）
						s ConRemarks=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),9)		//备注
						continue:((remarks'="")&&($ZCONVERT(ConRemarks,"U")'[remarks))
						w !,Source_"	"_OperationCode_"	"_ICDCode_"	"_OperationName_"	"_MKBICDConNumber_"	"_DictName_"	"_ConState_"	"_"手术	"_DictHospDesc_"	"_ConRemarks
					}
				}	
			} 
		}
		else
		{
			w !,Source_"	"_OperationCode_"	"_ICDCode_"	"_OperationName_"	"_MKBICDConNumber_"	"_DictName_"	"_ConState_"	"_"手术	"_DictHospDesc_"	"_ConRemarks
		}			
	}
	c file
	q fileName
}

/// Creator：徐文虎
/// CreatDate: 2020-01-05
/// Description：批量导入对接方手术
/// Table:CT.WDT.CDSS.ConOperDict
/// Input： datastr,hospid
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConOperDict).SaveImportData("331301001[next]穿刺术","1")
ClassMethod SaveImportData(dataStr, hosp)
{
	s result=""
	s dataStr=$tr(dataStr," ","")
	s dataStr=##class(web.DHCBL.BDP.FunLib).EvalJSONB(dataStr)		
	
	s OperationCode=$p(dataStr,"[next]",1)			//代码
	s:OperationCode="" OperationCode=..getFactorCode()
	s OperationName=$p(dataStr,"[next]",2)			//名称
	q:OperationName="" "false" 			
	s ICDCode=$p(dataStr,"[next]",3)
	s StartDate=$p(dataStr,"[next]",4)
	s EndDate=$p(dataStr,"[next]",5)
	s Source=$p(dataStr,"[next]",6)
	q:Source="" "false" 
	s Remarks=$p(dataStr,"[next]",7)		
	
	s bobj = ##class(web.CDSSEntity.IMP.ConOperDict).%New()
	s bobj.ID = ""
	s bobj.OperationCode=OperationCode 							//代码
	s bobj.OperationName=OperationName							//名称
	s bobj.ICDCode=ICDCode                                      //ICD
	s bobj.Source=Source   										//来源（住院/门诊/急诊
	s bobj.HospitalDR=hosp		    							//所属医院
	s bobj.Remarks=Remarks										//备注
	s bobj.State="未关联"   									//状态（未关联/已关联/已确认/已删除）
	s bobj.CreateDate=$ZDATETIME($HOROLOG,3)					//创建时间（手术数据导入或者手动新增的时间）
	s bobj.CreateUser=$g(%session.Data("LOGON.USERNAME"))		//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)					//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
	s bobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))		//修改人
	s bobj.StartDate=StartDate
	s bobj.EndDate=EndDate
	s re=..SaveData(bobj)
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

/// Creator：徐文虎 
/// CreatDate: 2020-01-04
/// Description：获取最近一次新增数据时间
/// Table:CT.WDT.CDSS.ConOperDict
/// Input： hospid 医院id
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConOperDict).GetLastTime(hospid)
ClassMethod GetLastTime1(hospid)
{
	s LastTime=""	
	s CreateTime=0
	for
	{
		s CreateTime=$o(^CT.WDT.CDSS.ConOperDictI("CreateDateIndex",hospid,CreateTime))
		q:CreateTime=""
		s LastTime=CreateTime
	}
	
	q LastTime
}

ClassMethod GetLastTime(hosp)
{
	s lasttime=""
	
	if ($d(^CT.WDT.CDSS.ConOperDictI("CreateDateIndex",hosp)))
	{
		s lasttime=$o(^CT.WDT.CDSS.ConOperDictI("CreateDateIndex",hosp,""),-1)
	}	
	q lasttime
}

/// Creator：胡宜良 
/// CreatDate: 2023-02-24
/// Description：手术匹配    
/// Input： Desc
/// Return：ID
/// w ##class(web.CDSS.IMP.ConOperDict).OperProcessing("头部血管治疗性超声")
ClassMethod OperProcessing(Desc As %String)
{
	q:Desc="" ""
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.OperationDictD(ID))
		q:ID=""
		s state=$lg($g(^CT.WDT.CDSS.OperationDictD(ID)),12)  //知识库数据不是可对照状态
		continue:(state'=2)
		s Name=$zconvert($lg($g(^CT.WDT.CDSS.OperationDictD(ID)),4),"U")  
		s AliasName=$zconvert($lg($g(^CT.WDT.CDSS.OperationDictD(ID)),18),"U")
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

/// Creator:胡宜良
/// CreatDate: 2023-02-23
/// Description：删除关联，将状态改已删除
/// Table:CT.WDT.CDSS.ConOperDict 对接方手术字典表
/// Input: id，remark 备注
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ConOperDict).DelMapping()
ClassMethod DelMapping(id, remark)
{
	q:id="" "{success:'false',errorinfo:'对象不存在！'}"
	s obj=##class(CT.WDT.CDSS.ConOperDict).%OpenId(id)
		
	s bobj = ##class(web.CDSSEntity.IMP.ConOperDict).%New()
	s bobj.ID = id
	
	s bobj.OperationCode= obj.OperationCode		//代码
	s bobj.OperationName= obj.OperationName		//描述
	s bobj.ICDCode=obj.ICDCode						//ICD
	s bobj.Source=obj.Source						//来源
	s:obj.HospitalDR'="" bobj.HospitalDR=obj.HospitalDR.%Id()   //医院指针
	s bobj.Source=obj.Source		//来源（住院/门诊/急诊）
	s bobj.Remarks=remark	 //备注
	s bobj.State="已删除"		//状态（未关联/已关联/已确认/已删除）
	s bobj.CreateDate=obj.CreateDate		//创建时间（手术数据导入或者手动新增的时间）
	s bobj.CreateUser=obj.CreateUser		//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		//修改时间（对应的就是所有操作时间包括 删除 确认 关联 取消关联）
	s bobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))		//修改人
	
	
	d obj.%Close()
	
	s result=..SaveData(bobj)		
			
	q result
}

/// Creator：胡宜良
/// CreatDate: 2023-03-15
/// Description：生成手术检索索引(名称或别名中包含括号或者-的)  ^TEMPCDSSCON("OperIndex") 
/// Input： 
/// Return：""
/// w ##class(web.CDSS.IMP.ConOperDict).CreateOperIndex()
ClassMethod CreateOperIndex()
{
	k ^TEMPCDSSCON("OperIndex")
	s OperID=0
	for 
	{
		s OperID=$o(^CT.WDT.CDSS.OperationDictD(OperID))
		q:OperID=""
		s state=$lg($g(^CT.WDT.CDSS.OperationDictD(OperID)),12)  
		continue:(state'=2)  //知识库数据不是已审核状态则跳过
		s Name=$lg($g(^CT.WDT.CDSS.OperationDictD(OperID)),4)
		s Name=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(Name)
		s Name=$zconvert(Name,"U")
		continue:Name=""
		
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("OperIndex",1,NewName,OperID)=""
		}
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("OperIndex",2,NewName,OperID)=""
		}
		s NewName=$Replace(Name,"-","")
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("OperIndex",3,NewName,OperID)=""
		}
		s AliasName=$lg($g(^CT.WDT.CDSS.OperationDictD(OperID)),18)	
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
					s ^TEMPCDSSCON("OperIndex",1,NewAliasDesc,OperID)=""
				}
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("OperIndex",2,NewAliasDesc,OperID)=""
				}
				s NewAliasDesc=$Replace(AliasDesc,"-","")
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("OperIndex",3,NewAliasDesc,OperID)=""
				}
			}
		}
	}
	q ""
}

/// Creator：胡宜良
/// CreatDate: 2023-03-14
/// Description：通过名称找知识库字典ID
/// Table:CT.WDT.CDSS.OperationDict\CT.WDT.CDSS.Alias
/// Input： DictName-手术名称
/// Return：RowID—手术字典ID
/// Other: w ##class(web.CDSS.IMP.ConOperDict).FindDictIdByName("安立泽片")
ClassMethod FindDictIdByName(DictName)
{
	q:DictName="" ""
	s RowID=$o(^CT.WDT.CDSS.OperationDictI("NameIndex"," "_$zconvert(DictName,"U"),0)) 	 //通过名称匹配		
	if (RowID'="")	//判断是否已审核
	{
		s flag=$lg($g(^CT.WDT.CDSS.OperationDictD(RowID)),12)
		s:flag'=2 RowID=""
	}
	if (RowID="")
	{
		s RowID=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.OperationDict"," "_$zconvert(DictName,"U"),0)) //通过别名匹配
		if (RowID'="") //判断是否已审核
		{
			s flag=$lg($g(^CT.WDT.CDSS.OperationDictD(RowID)),12)
			s:flag'=2 RowID=""
		}
			
	}
	q RowID
}

/// Creator：胡宜良	
/// CreatDate: 2023-04-03
/// Description：删除 对接方手术字典表未关联数据
/// Table:CT.WDT.CDSS.ConOperDict 对接方手术字典表未关联数据
/// Input：hosp 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.IMP.ConOperDict).DeleteUnlinkedData(31)
ClassMethod DeleteUnlinkedData(hosp As %String) As %String
{
	s result="" 
	s id=0 
	for
	{
		s id=$o(^CT.WDT.CDSS.ConOperDictI("HospStateIndex",hosp,"未关联",id))
		q:id=""
			
		s pobj = ##class(CT.WDT.CDSS.ConOperDict).%OpenId(id)
		s eobj = ##class(web.CDSSEntity.IMP.ConOperDict).%New()
		
		s eobj.OperationCode= pobj.OperationCode							//代码
		s eobj.OperationName= pobj.OperationName							//名称
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
		s sc=##class(CT.WDT.CDSS.ConOperDict).%DeleteId(id)
		IF $$$ISOK(sc)
		{
			
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ConOperDict","CT.WDT.CDSS.ConOperDict","对接方手术字典表",id,eobj.HospitalDR_"-"_eobj.OperationCode_"-"_eobj.OperationName,"D",eobj)
		}
		else
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("对接方手术字典表","web.CDSS.IMP.ConOperDict","DeleteUnlinkedData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	q result
}

}
