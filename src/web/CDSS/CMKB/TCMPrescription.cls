/// Description：中医方剂字典 
/// Table：CT.WDT.CDSS.TCMPrescription
Class web.CDSS.CMKB.TCMPrescription Extends %RegisteredObject
{

/// Creator：赵文伟
/// CreatDate: 2020-08-30
/// Description：查询 方剂
/// Table：CT.WDT.CDSS.TCMPrescription
/// Input：rowid,code,name
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMPrescription","GetDataForCmb1","","","","")
Query GetDataForCmb1(rowid As %String, code As %String, name As %String, q As %String) As %Query(ROWSPEC = "PrescriptionRowId:%String,PrescriptionCode:%String,PrescriptionName:%String,PrescriptionDR:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, name As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 	if (rowid'="") //根据rowid返回该条记录
 	{
 		s PrescriptionRowId=rowid
		s PrescriptionCode=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),2)
		s PrescriptionName=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),3)
  		d OutputRowCmb
 	}
 	else
 	{
  		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
  		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.TCMPrescriptionD(ID))
			q:ID=""
			s PrescriptionName=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(ID)),3)
			s length=$l(PrescriptionName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s:code'="" code=$ZCONVERT(code,"U") //转换成大写
			s:name'="" name=$ZCONVERT(name,"U") //转换成大写
			s:q'="" name=$ZCONVERT(q,"U")
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s PrescriptionRowId=0
			for
			{
				s PrescriptionRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,PrescriptionRowId))
				q:PrescriptionRowId=""
				s PrescriptionDR=PrescriptionRowId 
				s PrescriptionCode=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),2)
  				s PrescriptionName=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),3)
				s State=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),10)
  				if ((($ZCONVERT(PrescriptionCode,"U")[code)&($ZCONVERT(PrescriptionName,"U")[name))&(State=2)){
  				d OutputRowCmb
  				}
  				continue:((code'="")||(name'=""))		
				s num=num+1
				q:num=1000
			}
			q:num=1000
		}
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(PrescriptionRowId,PrescriptionCode,PrescriptionName,PrescriptionDR)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：赵文伟
/// CreatDate: 2020-08-27
/// Description：查询中医方剂字典（Query）
/// Table：CT.WDT.CDSS.TCMPrescription
/// Input：rowid,code,Prescriptionname,alias,attend, functions,type,operator,timescope,state,remarks
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMPrescription","GetList","","","","","","","","","","","")
Query GetList(rowid As %String, code As %String, prescriptionname As %String, alias As %String, attend As %String, functions As %String, type As %String, operator As %String, timescope As %String, state As %String, remarks As %String, sortmethod) As %Query(ROWSPEC = "PrescriptionRowId,PrescriptionCode,PrescriptionName,PrescriptionAlias,PrescriptionAttending,PrescriptionFunction,PrescriptionType,Operator,OperatTime,State,Remarks,JoinMedicine")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, prescriptionname As %String, alias As %String, attend As %String, functions As %String, type As %String, operator As %String, timescope As %String, state As %String, remarks As %String, sortmethod) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s PrescriptionRowId=rowid
	s PrescriptionCode=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),2)		//方剂编码
	s PrescriptionName=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),3)		//方剂名称
	s PrescriptionAlias=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),4)		//别名
	s PrescriptionAttending=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),5)	//主治
	s PrescriptionFunction=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),6)	//功用
	s PrescriptionType=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),7)		//方剂分类
	s Operator=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),8)				//操作人员
	s OperatTime=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),9)			//操作时间
	s State=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),10)				//状态
	s Remarks=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),11)				//备注
	//关联中药
	s MedicineDR=""
	s JoinMedicine=""
	for {
		s MedicineDR=$o(^CT.WDT.CDSS.TCMPreJoinMedI("PrescriptMedIndex",PrescriptionRowId,MedicineDR)) q:MedicineDR=""
		s MedicineName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(MedicineDR)),3)
		if (JoinMedicine=""){
			s JoinMedicine=MedicineName
		}else{
			s JoinMedicine=JoinMedicine_"，<br>"_MedicineName
		}
	}
	d OutputRow
 }
 else
 {
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:prescriptionname'="" prescriptionname=$ZCONVERT(prescriptionname,"U") 	//转换成大写 
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:operator'="" operator=$ZCONVERT(operator,"U") //转换成大写
	//默认按时间倒序排列
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	if (sortmethod="Short")
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.TCMPrescriptionD(ID))
			q:ID=""
			s PrescriptionName= $lg($g(^CT.WDT.CDSS.TCMPrescriptionD(ID)),3)		//名称
			s length=$l(PrescriptionName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
		}
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.TCMPrescriptionD(ID))
			q:ID=""
			s UpdateDate= $lg($g(^CT.WDT.CDSS.TCMPrescriptionD(ID)),9)			//编辑时间
			s:UpdateDate="" UpdateDate="2021-08-08"
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",UpdateDate,ID)=ID
		}
	}
	s le=""
	for
	{
		if (sortmethod="Short"){
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le)) 
		} else{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le),-1) 
		}
		q:le=""
		s PrescriptionRowId=0
		for
		{
			s PrescriptionRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,PrescriptionRowId)) q:PrescriptionRowId=""
			s PrescriptionCode=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),2)
			continue:((code'="")&&($ZCONVERT(PrescriptionCode,"U")'[code))
			s PrescriptionName=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),3)
			continue:((prescriptionname'="")&&($ZCONVERT(PrescriptionName,"U")'[prescriptionname))
			s PrescriptionAlias=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),4)
			continue:((alias'="")&&($ZCONVERT(PrescriptionAlias,"U")'[alias))
			s PrescriptionAttending=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),5)
			continue:((attend'="")&&($ZCONVERT(PrescriptionAttending,"U")'[attend))
			s PrescriptionFunction=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),6)
			continue:((functions'="")&&($ZCONVERT(PrescriptionFunction,"U")'[functions))
			s PrescriptionType=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),7)
			continue:((type'="")&&($ZCONVERT(PrescriptionType,"U")'[type))
			s Operator=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),8)
			continue:(operator'="")&&($ZCONVERT(Operator,"U")'[operator)
			s starttime=$p(timescope,"^",1)
			s endtime=$p(timescope,"^",2)
			s OperatTime=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),9)
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(OperatTime,3)))
			continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(OperatTime,3)))
			s State=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),10)
			s:State="" State=0
			//continue:((state'="")&&(State'=state))
			if (state="")
			{
				continue:(State="1")	
			}else
			{
				continue:(State'=state)	
			}
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),11)
			continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))	
			//关联中药
			s MedicineStr=""
			s MedicineDR=""
			s JoinMedicine=""
			for {
				s MedicineDR=$o(^CT.WDT.CDSS.TCMPreJoinMedI("PrescriptMedIndex",PrescriptionRowId,MedicineDR)) q:MedicineDR=""
				s MedicineStr=MedicineStr_"<"_MedicineDR_">"
				
				s MedicineName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(MedicineDR)),3)
				if (JoinMedicine=""){
					s JoinMedicine=MedicineName
				}else{
					s JoinMedicine=JoinMedicine_"，<br>"_MedicineName
				}
			}	
			d OutputRow	
		}
	}
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(PrescriptionRowId,PrescriptionCode,PrescriptionName,PrescriptionAlias,PrescriptionAttending,PrescriptionFunction,PrescriptionType,Operator,OperatTime,State,Remarks,JoinMedicine)
    
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
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

/// Creator:赵文伟
/// CreatDate:2020-08-27
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.TCMPrescription
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TCMPrescription).FormValidate("","1111","1111","100.01")
ClassMethod FormValidate(id As %String, code As %String, name As %String) As %String
{
	
    //q:(code="") ""
    s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:name'="" name=" "_$ZCONVERT(name,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s flagc=$d(^CT.WDT.CDSS.TCMPrescriptionI("CodeIndex",code))
	s flagd=$d(^CT.WDT.CDSS.TCMPrescriptionI("NameIndex",name))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0))
		{ s flag=1 } //返回重复标志
		else { s flag=0 } //返回不重复标志
		
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s idc=$o(^CT.WDT.CDSS.TCMPrescriptionI("CodeIndex",code,0))
  		s idd=$o(^CT.WDT.CDSS.TCMPrescriptionI("NameIndex",name,0))
  		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.TCMPrescription).ValidateAlias("","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod ValidateAlias(id As %String, name As %String, aliasStr As %String) As %String
{
	s flag=0
	s len = $l(aliasStr,",")
	for i=1:1:len
	{
		s Alias=$p(aliasStr,",",i)
		if (Alias="") continue  //别名为空，则跳过
		if (Alias=name)
		{
			s flag=1  //如果别名=名称，则数据重复
			q
		}
		
		s Alias=" "_$ZCONVERT(Alias,"U") //别名转换成大写
	    s flagA="",flagN=""
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.TCMPrescription",Alias))
	    s flagN=$d(^CT.WDT.CDSS.TCMPrescriptionI("NameIndex",Alias))
	    if (id="")	//如果为空，增加时的重复判断
	    {
	        if ((flagA>0)||(flagN>0)) 
	        {
		        s flag=1  //返回重复标志
		        q
	        }
	    }
	    else 	//如果不为空，修改时的重复判断
	    {
	        s idA="",idN=""
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.TCMPrescription",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.TCMPrescriptionI("NameIndex",Alias,0))  						//字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Other: w ##class(web.CDSS.CMKB.TCMPrescription).Test()
ClassMethod Test()
{
	s eobj = ##class(web.CDSSEntity.CMKB.TCMPrescription).%New()
	s eobj.PrescriptionRowId=""	
	s eobj.PrescriptionCode="002"
	s eobj.PrescriptionName="测试2"
	s eobj.PrescriptionAlias="32"
	s eobj.PrescriptionAttending="465"
	s eobj.PrescriptionFunction="adeswa"
	s eobj.PrescriptionType="6"
	s eobj.Operator="Domo"
	s eobj.OperatTime="2021-08-31 16:03:55"
	s eobj.State=0
	s eobj.Remarks="yyuiop"
	s eobj.Medicine="^950,^951"
	
	w ..SaveData(eobj)
	q ""
}

/// Creator：赵文伟
/// CreatDate: 2021-08-27
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.TCMPrescription
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.TCMPrescription).SaveData()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.TCMPrescription) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.State="" eobj.State=0
		s flag=..FormValidate(eobj.PrescriptionRowId,eobj.PrescriptionCode,eobj.PrescriptionName)  //调用重复验证
		if (flag=1)		//重复
		{
			
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.PrescriptionRowId,eobj.PrescriptionName,eobj.PrescriptionAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		
		if (eobj.PrescriptionRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.TCMPrescription).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.TCMPrescription).%OpenId(eobj.PrescriptionRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMPrescription).%New()
			s bobj.PrescriptionCode=obj.PrescriptionCode		//方剂编码
			s bobj.PrescriptionName=obj.PrescriptionName		//方剂名称
			s bobj.PrescriptionAlias=obj.PrescriptionAlias 		//别名
			s bobj.PrescriptionAttending=obj.PrescriptionAttending	//主治
			s bobj.PrescriptionFunction=obj.PrescriptionFunction		//功用
			s bobj.PrescriptionType=obj.PrescriptionType	//方剂分类
			s bobj.Operator=obj.Operator	 	//创建人员
			s bobj.OperatTime=obj.OperatTime 	//创建时间
			s bobj.State=obj.State				//状态
			s bobj.Remarks=obj.Remarks			//备注
				
		}
			s obj.PrescriptionCode=eobj.PrescriptionCode		//方剂编码
			s obj.PrescriptionName=eobj.PrescriptionName		//方剂名称
			s obj.PrescriptionAlias=eobj.PrescriptionAlias 		//别名
			s obj.PrescriptionAttending=eobj.PrescriptionAttending	//主治
			s obj.PrescriptionFunction=eobj.PrescriptionFunction		//功用
			s obj.PrescriptionType=eobj.PrescriptionType	//方剂分类
			s obj.Operator=eobj.Operator	 	//创建人员
			s obj.OperatTime=eobj.OperatTime 	//创建时间
			s obj.State=eobj.State				//状态
			s obj.Remarks=eobj.Remarks			//备注
				
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			
			s id = obj.%Id()
			//d ##class(web.CDSS.CMKB.PreJoinMed).SaveData(id,eobj.Medicine) //关联中药保存
			
			Tc
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.PrescriptionRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMPrescription","CT.WDT.CDSS.TCMPrescription","中医方剂字典",id,eobj.PrescriptionName,"A",eobj)
			d:eobj.PrescriptionRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMPrescription","CT.WDT.CDSS.TCMPrescription","中医方剂字典",eobj.PrescriptionRowId,eobj.PrescriptionName,"U",eobj,bobj)			
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.PrescriptionRowId="")&&(eobj.PrescriptionAlias'=""))||((eobj.PrescriptionRowId'="")&&(eobj.PrescriptionAlias'=bobj.PrescriptionAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMPrescription",id,eobj.PrescriptionAlias)
            }
            
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医方剂字典","web.CDSS.CMKB.TCMPrescription","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医方剂字典","web.CDSS.CMKB.TCMPrescription","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：赵文伟
/// CreatDate: 2020-08-27
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.TCMPrescription
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.TCMPrescription).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.TCMPrescription).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMPrescription).%New() 
	s bobj.PrescriptionCode=obj.PrescriptionCode		//方剂编码
	s bobj.PrescriptionName=obj.PrescriptionName		//方剂名称
	s bobj.PrescriptionAlias=obj.PrescriptionAlias 		//别名
	s bobj.PrescriptionAttending=obj.PrescriptionAttending	//主治
	s bobj.PrescriptionFunction=obj.PrescriptionFunction		//功用
	s bobj.PrescriptionType=obj.PrescriptionType	//方剂分类
	s bobj.Operator=obj.Operator	 	//创建人员
	s bobj.OperatTime=obj.OperatTime 	//创建时间
	s bobj.State=obj.State				//状态
	s bobj.Remarks=obj.Remarks			//备注
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator：赵文伟
/// CreatDate:2021-08-27
/// Input:RowId  Opreation 操作(操作状态改变)
/// Return:
/// Other:w ##class(web.CDSS.CMKB.TCMPrescription).ChangeStatus(003,"1")
ClassMethod ChangeStatus(RowId, Operation)
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.TCMPrescription).%New()
	
	s:Operation="通过" eobj.State="2"	//已审核
	s:Operation="弃用" eobj.State="1"	//已弃用
	s:Operation="恢复" eobj.State="0"	//编辑中
	s:Operation="驳回" eobj.State="0"	//编辑中
	s eobj.OperatTime=$zdt($h,3)
	if ($d(%session)) {s eobj.Operator=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.TCMPrescription).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMPrescription).%New()
	s bobj.State=obj.State
	s bobj.OperatTime=obj.OperatTime
	s bobj.Operator=obj.Operator
	
	s obj.State=eobj.State
 	s obj.OperatTime=eobj.OperatTime
 	s obj.Operator=eobj.Operator
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		//状态改为已审核时识别词新增已拆分数据  Add By ZWW 2023-05-05 
		if (obj.State= "2"){
	        s lineI=obj.PrescriptionName_",识别条件,主要条件-识别词,1,中医方剂名称,"_obj.PrescriptionName_",0"
	        d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMPrescription","CT.WDT.CDSS.TCMPrescription","中医方剂字典",RowId,obj.PrescriptionName_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:赵文伟
/// CreatDate:2021-08-27
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.TCMPrescription
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.TCMPrescription).DeleteData("001")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Quit:id="" result="{success:'false',info:'删除失败,入参为空！'}" 
	
		s obj=##class(CT.WDT.CDSS.TCMPrescription).%OpenId(id)
		s bobj = ##class(web.CDSSEntity.CMKB.TCMPrescription).%New() 
		s bobj.PrescriptionCode=obj.PrescriptionCode		//方剂编码
		s bobj.PrescriptionName=obj.PrescriptionName		//方剂名称
		s bobj.PrescriptionAlias=obj.PrescriptionAlias 		//别名
		s bobj.PrescriptionAttending=obj.PrescriptionAttending	//主治
		s bobj.PrescriptionFunction=obj.PrescriptionFunction		//功用
		s bobj.PrescriptionType=obj.PrescriptionType	//方剂分类
		s bobj.Operator=obj.Operator	 	//创建人员
		s bobj.OperatTime=obj.OperatTime 	//创建时间
		s bobj.State=obj.State				//状态
		s bobj.Remarks=obj.Remarks			//备注
		Ts
		s sc=##class(CT.WDT.CDSS.TCMPrescription).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMPrescription","CT.WDT.CDSS.TCMPrescription","中医方剂字典",id,bobj.PrescriptionName,"D",bobj)
			//同步删除别名通用表中数据 
			d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.TCMPrescription",id)
			//同步删除关联表中数据[方剂组成、推荐剂量、剂量单位、煎法]
			d ##class(web.CDSS.CMKB.PreJoinMed).DeleteLinkData(id)
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("中医方剂字典","web.CDSS.CMKB.TCMPrescription","DeleteData",bobj)
	       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
    
	q result
}

/// Creator：赵文伟
/// CreatDate:2020-08-27
/// Description：导出中医方剂字典表数据
/// Other:w ##class(web.CDSS.CMKB.TCMPrescription).ExportTCMPrescriptionTXT()
ClassMethod ExportTCMPrescriptionTXT(code, prescriptionname, alias, attend, functions, type, operator, starttime, endtime, state, remarks) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"中医方剂字典数据.txt"		
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
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:prescriptionname'="" prescriptionname=$ZCONVERT(prescriptionname,"U") 	//转换成大写 
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:operator'="" operator=$ZCONVERT(operator,"U") //转换成大写
	w "RowID	方剂编码	方剂名称	别名	主治	功用	方剂组成	方剂分类	操作人	操作时间	状态	备注"
	//d file.WriteLine()
	s PrescriptionRowId=""
	for
	{ 
		s PrescriptionRowId=$o(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId),-1) q:PrescriptionRowId="" 
		s PrescriptionCode=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),2)
			continue:((code'="")&&($ZCONVERT(PrescriptionCode,"U")'[code))
			s PrescriptionName=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),3)
			continue:((prescriptionname'="")&&($ZCONVERT(PrescriptionName,"U")'[prescriptionname))
			s PrescriptionAlias=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),4)
			continue:((alias'="")&&($ZCONVERT(PrescriptionAlias,"U")'[alias))
			s PrescriptionAttending=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),5)
			continue:((attend'="")&&($ZCONVERT(PrescriptionAttending,"U")'[attend))
			s PrescriptionFunction=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),6)
			continue:((functions'="")&&($ZCONVERT(PrescriptionFunction,"U")'[functions))
			s PrescriptionType=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),7)
			continue:((type'="")&&($ZCONVERT(PrescriptionType,"U")'[type))
			s Operator=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),8)
			continue:(operator'="")&&($ZCONVERT(Operator,"U")'[operator)
			
			s OperatTime=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),9)
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(OperatTime,3)))
			continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(OperatTime,3)))
			s State=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),10)
			s:State="" State=0
			continue:((state'="")&&(State'=state))
			/*if (state="")
			{
				continue:(State="1")	
			}else
			{
				continue:(State'=state)	
			}*/
			s State=$case(State,"0":"编辑中","1":"已弃用","2":"已审核",:"")
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionRowId)),11)
			continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))	
			//关联中药
			s MedicineDR=""
			s JoinMedicine=""
			for {
				s MedicineDR=$o(^CT.WDT.CDSS.TCMPreJoinMedI("PrescriptMedIndex",PrescriptionRowId,MedicineDR)) q:MedicineDR=""
				
				s MedicineName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(MedicineDR)),3)
				if (JoinMedicine=""){
					s JoinMedicine=MedicineName
				}else{
					s JoinMedicine=JoinMedicine_"，"_MedicineName
				}
			}	
			w !,PrescriptionRowId_"	"_PrescriptionCode_"	"_PrescriptionName_"	"_PrescriptionAlias_"	"_PrescriptionAttending_"	"_PrescriptionFunction_"	"_JoinMedicine_"	"_PrescriptionType_"	"_Operator_"	"_OperatTime_"	"_State_"	"_Remarks		
		}
	c file
	q fileName
}

/// Creator：赵文伟 
/// CreatDate: 2020-08-27
/// Description：获取当前时间
/// Other: w ##class(web.CDSS.CMKB.TCMPrescription).CurrentDate()
ClassMethod CurrentDate()
{
	s Date=$zdate(($p($h,",",1)),3)
	s Time=$ztime(($p($h,",",2)),1)
    q Date_" "_Time
}

/// Creator：赵文伟
/// CreatDate: 2021-08-24
/// Description：导入中医方剂字典表,导入文本格式为txt，TXT要求格式为ANSI编码
/// Table:CT.WDT.CDSS.TCMPrescription 中医方剂字典表
/// Other: w ##class(web.CDSS.CMKB.TCMPrescription).ImportDataTXT("")
ClassMethod ImportDataTXT(path) As %String
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s linksavecount=0
	s updatecount=0
	s continuecount=0
	s id=0
	//s file=##class(%File).%New(path)
	
	s path="E:\中医基础字典数据\中医方剂字典.txt"
	if '##class(%File).Exists(path) 
	{
   		q "文件不存在"
    }
	s file=##class(%File).%New(path)
	d file.Open("R")
	
	s TheType=""
	s TheHosp=""
	s TheMarkFlag=""
	
	s num=0
	k myFileAry
	TS
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s readcount=readcount+1
		s num=num+1
		continue:num=1  //跳过第一行
		s myFileAry(i)=data
		
		s PrescriptionCode=$p(data,$c(9),1)	//中医方剂编码
		s PrescriptionName=$p(data,$c(9),2)	//中医方剂名称
		s PrescriptionAlias=$p(data,$c(9),3)	//别名
		
		
		s PrescriptionAttending=$p(data,$c(9),4)	//主治
		s PrescriptionFunction=$p(data,$c(9),5)	//功用
		s JoinMedicine=$p(data,$c(9),6)	//方剂组成
		s PrescriptionType=$p(data,$c(9),7)	//方剂分类
		
		s Operator=$p(data,$c(9),8)	//操作人
		if (Operator="")
		{
		 s Operator="赵文伟"	
		}
		s OperatTime=$p(data,$c(9),9)	//操作时间
		if (OperatTime="")
		{
		 	s OperatTime=..CurrentDate()
		}
		
		s State=$p(data,$c(9),10)	//状态
		s State=$case(State,"已审核":"1","编辑中":"0",:"0")
		s Remarks=$p(data,$c(9),11)	//备注
		
		s PrescriptionID=$o(^CT.WDT.CDSS.TCMPrescriptionI("NameIndex"," "_$ZCONVERT(PrescriptionName,"U"),0))
		
		s eobj = ##class(web.CDSSEntity.CMKB.TCMPrescription).%New()
		//s obj=##class(CT.WDT.CDSS.TCMPrescription).%OpenId(PrescriptionID)
		//s eobj.ID = PrescriptionID
		
		s eobj.PrescriptionCode=PrescriptionCode		//方剂编码
		s eobj.PrescriptionName=PrescriptionName		//方剂名称
		s eobj.PrescriptionAlias=PrescriptionAlias 		//别名
		s eobj.PrescriptionAttending=PrescriptionAttending	//主治
		s eobj.PrescriptionFunction=PrescriptionFunction		//功用
		s eobj.PrescriptionType=PrescriptionType	//方剂分类
		s eobj.Operator=Operator	 	//创建人员
		s eobj.OperatTime=OperatTime 	//创建时间
		s eobj.State=State				//状态
		s eobj.Remarks=Remarks			//备注
		//s eobj.Medicine=Medicine
		s result=..SaveData(eobj)
		
		if ((result'["false"))
		{			
			s savecount=savecount+1
		}
		else
		{
			
			s nosavecount=nosavecount+1
		}
	}
	close file
    k file
	w "readcount："_(readcount-1),!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	w "linksavecount:"_linksavecount,!
	w "updatecount:"_updatecount,!
	w "continuecount:"_continuecount,!
	//q result
	TC
	q "{success:'true'}"
}

/// Creator：赵文伟
/// CreatDate: 2021-09-01
/// Description：处理关联数据——获取关联表中不存在的数据
/// Table:CT.WDT.CDSS.TCMPrescription 中医方剂字典表
/// Other: w ##class(web.CDSS.CMKB.TCMPrescription).HandleImportData()
ClassMethod HandleImportData()
{
	s PreID=""
	s readcount=0
	
	s path="D:\中医基础字典数据\中医方剂字典.txt"
	if '##class(%File).Exists(path) 
	{
   		q "文件不存在"
    }
	s file=##class(%File).%New(path)
	d file.Open("R")
	s num=0
	k myFileAry
	
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s readcount=readcount+1
		s num=num+1
		continue:num=1  //跳过第一行
		s myFileAry(i)=data
		
		s JoinMedicine=$p(data,$c(9),6)	//方剂组成
		s numb=$L(JoinMedicine,"，") //4
		for i=1:1:numb
		{
		s MedicineName=$p(JoinMedicine,"，",i)
		
		s ID=$o(^CT.WDT.CDSS.TCMMedicineI("NameIndex"," "_$zconvert(MedicineName,"U"),""))
		
		if (ID="") 
		{
			w MedicineName_"不存在" ,!
			
		}else{
			s PreID=PreID_"^"_ID 
		}
	}
	}
	close file
    k file
	w "readcount："_(readcount-1),!
	q PreID
}

/// Creator：赵文伟
/// CreatDate: 2021-09-01
/// Description：导入中医方剂字典表,包含关联数据
/// Table:CT.WDT.CDSS.TCMPrescription 中医方剂字典表
/// Other: w ##class(web.CDSS.CMKB.TCMPrescription).ImportJoinDataTXT("")
ClassMethod ImportJoinDataTXT(path) As %String
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s linksavecount=0
	s updatecount=0
	s continuecount=0
	s PreID=""
	s path="D:\中医基础字典数据\中医方剂字典2.txt"
	if '##class(%File).Exists(path) 
	{
   		q "文件不存在"
    }
	s file=##class(%File).%New(path)
	d file.Open("R")
	s num=0
	k myFileAry
	//TS
	for i=1:1:file.Size 
	{
		s PreID=""
		s data=file.Read()
		q:data=""
		s readcount=readcount+1
		s num=num+1
		continue:num=1  //跳过第一行
		s myFileAry(i)=data
		
		s PrescriptionCode=$p(data,$c(9),1)	//中医方剂编码
		s PrescriptionName=$p(data,$c(9),2)	//中医方剂名称
		s PrescriptionAlias=$p(data,$c(9),3)	//别名
		s PrescriptionAttending=$p(data,$c(9),4)	//主治
		s PrescriptionFunction=$p(data,$c(9),5)	//功用
		s JoinMedicine=$p(data,$c(9),6)	//方剂组成
		s PrescriptionType=$p(data,$c(9),7)	//方剂分类
		s Operator=$p(data,$c(9),8)	//操作人
		if (Operator="")
		{
		 s Operator="赵文伟"	
		}
		s OperatTime=$p(data,$c(9),9)	//操作时间
		if (OperatTime="")
		{
		 	s OperatTime=..CurrentDate()
		}
		s State=$p(data,$c(9),10)	//状态
		s State=$case(State,"已审核":"1","编辑中":"0",:"0")
		s Remarks=$p(data,$c(9),11)	//备注
		
		s PrescriptionID=$o(^CT.WDT.CDSS.TCMPrescriptionI("NameIndex"," "_$ZCONVERT(PrescriptionName,"U"),0))

		s eobj = ##class(web.CDSSEntity.CMKB.TCMPrescription).%New()
		s eobj.PrescriptionCode=PrescriptionCode		//方剂编码
		s eobj.PrescriptionName=PrescriptionName		//方剂名称
		s eobj.PrescriptionAlias=PrescriptionAlias 		//别名
		s eobj.PrescriptionAttending=PrescriptionAttending	//主治
		s eobj.PrescriptionFunction=PrescriptionFunction		//功用
		s eobj.PrescriptionType=PrescriptionType	//方剂分类
		s eobj.Operator=Operator	 	//创建人员
		s eobj.OperatTime=OperatTime 	//创建时间
		s eobj.State=State				//状态
		s eobj.Remarks=Remarks			//备注
			
		////////////////////////////////保存数据//////////////////////////////////////
		
		s result=""
		if $IsObject(eobj)
		{
			s:eobj.State="" eobj.State=0
			s flag=..FormValidate(eobj.PrescriptionRowId,eobj.PrescriptionCode,eobj.PrescriptionName)  //调用重复验证
		if (flag=1)		
		{
			//q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.PrescriptionRowId="") 
		{ 
			s obj=##class(CT.WDT.CDSS.TCMPrescription).%New() 
		}
		else   
		{
			s obj=##class(CT.WDT.CDSS.TCMPrescription).%OpenId(eobj.PrescriptionRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMPrescription).%New()
			s bobj.PrescriptionCode=obj.PrescriptionCode		//方剂编码
			s bobj.PrescriptionName=obj.PrescriptionName		//方剂名称
			s bobj.PrescriptionAlias=obj.PrescriptionAlias 		//别名
			s bobj.PrescriptionAttending=obj.PrescriptionAttending	//主治
			s bobj.PrescriptionFunction=obj.PrescriptionFunction		//功用
			s bobj.PrescriptionType=obj.PrescriptionType	//方剂分类
			s bobj.Operator=obj.Operator	 	//创建人员
			s bobj.OperatTime=obj.OperatTime 	//创建时间
			s bobj.State=obj.State				//状态
			s bobj.Remarks=obj.Remarks			//备注		
		}
			s obj.PrescriptionCode=eobj.PrescriptionCode		//方剂编码
			s obj.PrescriptionName=eobj.PrescriptionName		//方剂名称
			s obj.PrescriptionAlias=eobj.PrescriptionAlias 		//别名
			s obj.PrescriptionAttending=eobj.PrescriptionAttending	//主治
			s obj.PrescriptionFunction=eobj.PrescriptionFunction		//功用
			s obj.PrescriptionType=eobj.PrescriptionType	//方剂分类
			s obj.Operator=eobj.Operator	 	//创建人员
			s obj.OperatTime=eobj.OperatTime 	//创建时间
			s obj.State=eobj.State				//状态
			s obj.Remarks=eobj.Remarks			//备注
				
		//Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{	
		s numb=$L(JoinMedicine,"，") //4
		for i=1:1:numb
		{
			s MedicineName=$p(JoinMedicine,"，",i)
			s ID=$o(^CT.WDT.CDSS.TCMMedicineI("NameIndex"," "_$zconvert(MedicineName,"U"),""))
			if (ID="") 
			{
				w MedicineName_"不存在" ,!
			}else{
				s PreID=PreID_"^"_ID_","
				w PreID ,! 
				
			}
		}
			s id = obj.%Id()
			d ##class(web.CDSS.CMKB.PreJoinMed).SaveData(id,PreID) //关联中药保存
			//Tc
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.PrescriptionRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_WDT_CDSS.TCMPrescription","CT.WDT.CDSS.TCMPrescription","中医方剂字典",id,eobj.PrescriptionName,"A",eobj)
			d:eobj.PrescriptionRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_WDT_CDSS.TCMPrescription","CT.WDT.CDSS.TCMPrescription","中医方剂字典",eobj.PrescriptionRowId,eobj.PrescriptionName,"U",eobj,bobj)			
		}
		else
		{
			//Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("中医方剂字典","web.CDSS.CMKB.TCMPrescription","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 

		if ((result'["false"))
		{
			s savecount=savecount+1
		}
		else
		{
			
			s nosavecount=nosavecount+1
		}
	}
	close file
    k file
	w "readcount："_(readcount-1),!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	w "linksavecount:"_linksavecount,!
	w "updatecount:"_updatecount,!
	w "continuecount:"_continuecount,!
	q result
	
	q "{success:'true'}"
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-18
/// Description: 批量通过
/// Table: CT.WDT.CDSS.TCMPrescription
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.TCMPrescription).ChangeStatusPass("")
ClassMethod ChangeStatusPass(RowIdStr As %String)
{
	s result=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)
			s flag=..ChangeStatus(id,"通过")

			if (flag'["true"){
				s errorflag = errorflag+1
			}
		}
	}
	if (errorflag'=0)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result="true"	
	}
		q result
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-18
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.TCMPrescription
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.TCMPrescription).ChangeStatusBack("")
ClassMethod ChangeStatusBack(RowIdStr As %String)
{
	s result=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)
			s flag=..ChangeStatus(id,"驳回")

			if (flag'["true"){
				s errorflag = errorflag+1
			}
		}
	}
	if (errorflag'=0)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result="true"	
	}
		q result
}

/// Creator:赵文伟
/// CreatDate:2021-10-22
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.TCMPrescription
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMPrescription","GetAliasList","751")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		
		s PrescriptionAlias=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(id)),4)
		s Len=$Length(PrescriptionAlias,",")
		for i=1:1:Len{
			s Desc=$p(PrescriptionAlias,",",i)
			continue:(Desc="")
			d OutputRowKeyWords
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowKeyWords
	set Data=$lb(Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAliasListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAliasListExecute ]
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

ClassMethod GetAliasListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAliasListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-20
/// Description：别名数据转存到别名通用表中
/// Table: CT.WDT.CDSS.TCMPrescription
/// Other: w ##class(web.CDSS.CMKB.TCMPrescription).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMPrescriptionD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.TCMPrescriptionD(RowId)),4)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMPrescription",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.TCMPrescription
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.TCMPrescription).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMPrescriptionD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.TCMPrescriptionD(RowId)),10)       
		if (UseFlag'="")
		{
			if (UseFlag=0){
				s editcount=editcount+1
			} elseif (UseFlag=2){
				s auditcount=auditcount+1
			}
		}	 
		s totalcount=editcount+auditcount	
	}
	q totalcount_"^"_editcount_"^"_auditcount_"^"_unauditcount
}

/// Creator:zhaowenwei
/// CreatDate:2022-02-24
/// Description:自动生成最新编码【取当前编码最大值+1】  
/// Table: CT.WDT.CDSS.TCMPrescription
/// Return： 最新编码Code
/// Other:w ##class(web.CDSS.CMKB.TCMPrescription).GetNewCode()
ClassMethod GetNewCode() As %String
{
  	
	s RowId=0
	s MaxCode=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMPrescriptionD(RowId))
		q:RowId=""
		s Code = $lg($g(^CT.WDT.CDSS.TCMPrescriptionD(RowId)),2)
		if (Code>MaxCode){
			s MaxCode=Code
		}
	}
	s Code=MaxCode+1
	q Code
}

/// Creator：赵文伟 
/// CreatDate: 2022-07-08
/// Description：导入中医方剂字典表补充数据
/// Table: CT.WDT.CDSS.TCMPrescription
/// Input： path
/// Return：
/// Other: w ##class(web.CDSS.CMKB.TCMPrescription).ImportAddData("C:\Users\墨羽旌\Desktop\新建文件夹\中医馆方剂708.csv")
ClassMethod ImportAddData(path)
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	
	if '##class(%File).Exists(path) 
	{
   		q "文件不存在"
    }
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		
		s PrescriptionCode=..GetNewCode()
		s PrescriptionName=$p(str,",",1)		//中医方剂名称
		s PrescriptionAlias=$p(str,",",2)		//别名
		s PrescriptionAttending=$p(str,",",3)	//主治
		s PrescriptionFunction=$p(str,",",4)	//功用
		s JoinMedicine=$p(str,",",5)			//方剂组成
		s PrescriptionType=$p(str,",",6)		//方剂分类
		s Operator="dhcc"						//操作人员
		s OperatTime=$ZDATETIME($HOROLOG,3)		//操作时间
		s State=0								//状态【编辑中】
		
		s readcount=readcount+1
		
		s eobj = ##class(web.CDSSEntity.CMKB.TCMPrescription).%New()
		s eobj.PrescriptionRowId=""
		s eobj.PrescriptionCode=PrescriptionCode
		s eobj.PrescriptionName=PrescriptionName
		s eobj.PrescriptionAlias=PrescriptionAlias
		s eobj.PrescriptionAttending=PrescriptionAttending
		s eobj.PrescriptionFunction=PrescriptionFunction
		s eobj.PrescriptionType=PrescriptionType
		s eobj.Operator=Operator
		s eobj.OperatTime=OperatTime
		s eobj.State=State
		
		s result=..SaveData(eobj)
		
		if ((result'["false"))
		{
			s savecount=savecount+1
			s result=$replace(result,"success","'success'")
			s result=$replace(result,"id","'id'")
			s result=$replace(result,"'","""")
			
			set resultobj = ##class(%DynamicAbstractObject).%FromJSON(result)
			
			s id=resultobj.id
			//保存方剂组成数据到中医方剂关联中药表中
			s len=$l(JoinMedicine,"，")    //以",作为分隔符取数据长度
	        for j=1:1:len 
	        {
				s Medicine=$p(JoinMedicine,"，",j)		//遍历取每一项方剂组成
				
				s Medicine=$zstrip(Medicine,"<>W")		//去除两端空白
				s MedicineDR=$o(^CT.WDT.CDSS.TCMMedicineI("NameIndex"," "_$ZCONVERT(Medicine,"U"),0))
				if (MedicineDR=""){
					w !,Medicine
				}else{
					s joinResult=##class(web.CDSS.CMKB.PreJoinMed).SaveData("",id,MedicineDR,"","","")
				}
	        }
		}
		else
		{
			s nosavecount=nosavecount+1
			w PrescriptionName_"保存失败！"
			
		}
	}
	
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	
	q "{success:'true'}"
}

/// Creator：赵文伟 
/// CreatDate: 2022-07-08
/// Description：查找导入的补充数据在中药字典表中不存在的方剂组成数据
/// Table: CT.WDT.CDSS.TCMPrescription
/// Input： path
/// Return：
/// Other: d ##class(web.CDSS.CMKB.TCMPrescription).FindData("C:\Users\墨羽旌\Desktop\新建文件夹\中医方剂0708.csv")
ClassMethod FindData(path)
{
	
	
	if '##class(%File).Exists(path) 
	{
   		q "文件不存在"
    }
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		s JoinMedicine=$p(str,",",5)			//方剂组成
		
		s len=$l(JoinMedicine,"，")    //以",作为分隔符取数据长度
	    for j=1:1:len 
	    { 
			s Medicine=$p(JoinMedicine,"，",j)    //遍历取每一项方剂组成
			s MedicineDR=$o(^CT.WDT.CDSS.TCMMedicineI("NameIndex"," "_Medicine,0))
			if (MedicineDR=""){
				w !,Medicine
			}
	    }
	}
	q "{success:'true'}"
}

/// Creator:赵文伟
/// CreatDate:2022-09-02
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.CMKB.TCMPrescription).GetRefFlag("509")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0
    
    s RuleDescStr=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("方剂",id)
	if RuleDescStr'="" s myInfo=myInfo_"<规则管理："_RuleDescStr_">"
	
    i myInfo="" s return="0^未被引用!"
    else  s return="1^在"_myInfo_"表里被引用!"
    q return
}

/// Creator:赵文伟
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMPrescription","GetLogList","20")
Query GetLogList(RowId As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Operation")
{
}

ClassMethod GetLogListExecute(ByRef qHandle As %Binary, RowId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str=""
 	if (RowId'="")
 	{
		s LogID=""
	    for
	    {
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.TCMPrescription",RowId,LogID),-1) q:LogID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),8)
	    	s UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),9)
          	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime)
          	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),13)   //新增对象描述
          	if (ObjectDesc["&&")
          	{
	          	s Operation=$p(ObjectDesc,"&&",2)
          	}
         	else
         	{
          		s Operation="编辑"
         	}
         	d OutputRowLog
	    }
	    
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLog
	set Data=$lb(LogID,UpdateDate,UpdateTime,UpdateUserName,Operation)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLogListExecute ]
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

ClassMethod GetLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：赵文伟
/// CreatDate: 2023-01-19
/// Description：修正数据保存方法
/// Table：CT.WDT.CDSS.TCMPrescription
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.TCMPrescription).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.TCMPrescription) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		
		s flag=..FormValidate(eobj.PrescriptionRowId,eobj.PrescriptionCode,eobj.PrescriptionName)  //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.PrescriptionRowId,eobj.PrescriptionName,eobj.PrescriptionAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.PrescriptionRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.TCMPrescription).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.TCMPrescription).%OpenId(eobj.PrescriptionRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMPrescription).%New()
			s bobj.PrescriptionCode=obj.PrescriptionCode		//方剂编码
			s bobj.PrescriptionName=obj.PrescriptionName		//方剂名称
			s bobj.PrescriptionAlias=obj.PrescriptionAlias 		//别名
			s bobj.Operator=obj.Operator	 	//创建人员
			s bobj.OperatTime=obj.OperatTime 	//创建时间
				
		}
			s obj.PrescriptionCode=eobj.PrescriptionCode		//方剂编码
			s obj.PrescriptionName=eobj.PrescriptionName		//方剂名称
			s obj.PrescriptionAlias=eobj.PrescriptionAlias 		//别名
			s eobj.Operator = $g(%session.Data("LOGON.USERNAME")) 
			s obj.Operator=eobj.Operator	 	//创建人员
			s eobj.OperatTime=$zdt($h,3)
			s obj.OperatTime=eobj.OperatTime 	//创建时间
				
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			
			s id = obj.%Id()
			Tc
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.PrescriptionRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMPrescription","CT.WDT.CDSS.TCMPrescription","中医方剂字典",id,eobj.PrescriptionName,"A",eobj)
			d:eobj.PrescriptionRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMPrescription","CT.WDT.CDSS.TCMPrescription","中医方剂字典",eobj.PrescriptionRowId,eobj.PrescriptionName,"U",eobj,bobj)			
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.PrescriptionRowId="")&&(eobj.PrescriptionAlias'=""))||((eobj.PrescriptionRowId'="")&&(eobj.PrescriptionAlias'=bobj.PrescriptionAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMPrescription",id,eobj.PrescriptionAlias)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医方剂字典","web.CDSS.CMKB.TCMPrescription","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医方剂字典","web.CDSS.CMKB.TCMPrescription","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

}
