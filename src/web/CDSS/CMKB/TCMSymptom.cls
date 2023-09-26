/// Description：中医证候字典表 
/// Table：CT.WDT.CDSS.TCMSymptom
Class web.CDSS.CMKB.TCMSymptom Extends %RegisteredObject
{

/// Creator：赵文伟
/// CreatDate: 2020-08-30
/// Description：查询 证候(下拉框方法)
/// Table：CT.WDT.CDSS.TCMSymptom
/// Input：rowid,code,name
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMSymptom","GetDataForCmb1","","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, q As %String) As %Query(ROWSPEC = "SymptomRowId:%String,SymptomCode:%String,SymptomName:%String,TCMSymDR:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 	if (rowid'="") //根据rowid返回该条记录
 	{
 		s SymptomRowId=rowid
		s SymptomCode=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),2)
		s SymptomName=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),3)
  		d OutputRowCmb
 	}
 	else
 	{
  		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
  		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.TCMSymptomD(ID))
			q:ID=""
			s SymptomName=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(ID)),3)
			s length=$l(SymptomName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s:code'="" code=$ZCONVERT(code,"U") //转换成大写
			s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
			s:q'="" desc=$ZCONVERT(q,"U")
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s SymptomRowId=0
			for
			{
				s SymptomRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,SymptomRowId))
				q:SymptomRowId=""
				s TCMSymDR=SymptomRowId 
				s SymptomCode=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),2)
  				s SymptomName=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),3)
				s State=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),8)
				if ((($ZCONVERT(SymptomCode,"U")[code)&($ZCONVERT(SymptomName,"U")[desc))&(State=2)){
					d OutputRowCmb
				
				}
  				
  				continue:((code'="")||(desc'=""))		
				s num=num+1
				q:num=1000
			}
			q:num=1000
		}
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(SymptomRowId,SymptomCode,SymptomName,TCMSymDR)
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
/// CreatDate: 2020-08-18
/// Description：查询中医证候字典（Query）
/// Table：CT.WDT.CDSS.TCMSymptom
/// Input：rowid,code,name,alias,version, operator,timescope,state,remarks,starttime,endtime,remarks,sortmethod 
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMSymptom","GetList","","")
Query GetList(rowid As %String, code As %String, symptomname As %String, alias As %String, version As %String, operator As %String, timescope As %String, state As %String, remarks As %String, sortmethod) As %Query(ROWSPEC = "SymptomRowId,SymptomCode,SymptomName,SymptomAlias,SymptomVersion,Operator,OperatTime,State,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, symptomname As %String, alias As %String, version As %String, operator As %String, timescope As %String, state As %String, remarks As %String, sortmethod) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s SymptomRowId=rowid
	s SymptomCode=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),2)
	s SymptomName=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),3)
	s SymptomAlias=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),4)
	s SymptomVersion=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),5)
	s Operator=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),6)
	s OperatTime=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),7)
	s State=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),8)
	s Remarks=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),9)

	d OutputRow
 }
 else
 {
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写 
	s:symptomname'="" symptomname=$ZCONVERT(symptomname,"U") //转换成大写 
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:operator'="" operator=$ZCONVERT(operator,"U") //转换成大写
		
	//默认按时间倒序排列
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	if (sortmethod="Short")
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.TCMSymptomD(ID))
			q:ID=""
			s SymptomName= $lg($g(^CT.WDT.CDSS.TCMSymptomD(ID)),3)		//名称
			s length=$l(SymptomName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
		}
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.TCMSymptomD(ID))
			q:ID=""
			s UpdateDate= $lg($g(^CT.WDT.CDSS.TCMSymptomD(ID)),7)				//编辑时间
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
		s SymptomRowId=0
		for
		{
			s SymptomRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,SymptomRowId)) q:SymptomRowId=""
			s SymptomCode=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),2)
			continue:((code'="")&&($ZCONVERT(SymptomCode,"U")'[code))
			s SymptomName=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),3)
			continue:((symptomname'="")&&($ZCONVERT(SymptomName,"U")'[symptomname))
			s SymptomAlias=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),4)
			continue:((alias'="")&&($ZCONVERT(SymptomAlias,"U")'[alias))
			s SymptomVersion=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),5)
			continue:((version'="")&&($ZCONVERT(SymptomVersion,"U")'[version))
			s Operator=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),6)
			continue:(operator'="")&&($ZCONVERT(Operator,"U")'[operator)
			s starttime=$p(timescope,"^",1)
			s endtime=$p(timescope,"^",2)
			s OperatTime=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),7)
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(OperatTime,3)))
			continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(OperatTime,3)))
			s State=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),8)
			s:State="" State=0
			//continue:((state'="")&&(State'=state))
			if (state="")
			{
				continue:(State="1")	
			}else
			{
				continue:(State'=state)
				
			}
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),9)	
			continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))	
			d OutputRow
		}
	}
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(SymptomRowId,SymptomCode,SymptomName,SymptomAlias,SymptomVersion,Operator,OperatTime,State,Remarks)
    
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
/// CreatDate:2020-08-17
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.TCMSymptom
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TCMSymptom).FormValidate("","1111","1111","100.01")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	
    //q:(code="") ""
    s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s flagc=$d(^CT.WDT.CDSS.TCMSymptomI("CodeIndex",code))
	s flagd=$d(^CT.WDT.CDSS.TCMSymptomI("NameIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s idc=$o(^CT.WDT.CDSS.TCMSymptomI("CodeIndex",code,0))
  		s idd=$o(^CT.WDT.CDSS.TCMSymptomI("NameIndex",desc,0))
  		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
	}	
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.TCMSymptom).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.TCMSymptom",Alias))
	    s flagN=$d(^CT.WDT.CDSS.TCMSymptomI("NameIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.TCMSymptom",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.TCMSymptomI("NameIndex",Alias,0))  						//字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator：赵文伟
/// CreatDate: 2020-08-17
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.TCMSymptom
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.TCMSymptom).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.TCMSymptom) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		s:eobj.State="" eobj.State=0
		s flag=..FormValidate(eobj.SymptomRowId,eobj.SymptomCode,eobj.SymptomName)  //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.SymptomRowId,eobj.SymptomName,eobj.SymptomAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.SymptomRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.TCMSymptom).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.TCMSymptom).%OpenId(eobj.SymptomRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMSymptom).%New()
			s bobj.SymptomCode=obj.SymptomCode		//ICD编码
			s bobj.SymptomName=obj.SymptomName	//证候名称
			s bobj.SymptomAlias=obj.SymptomAlias //别名
			s bobj.SymptomVersion=obj.SymptomVersion	//版本
			s bobj.Operator=obj.Operator	 	//创建人员
			s bobj.OperatTime=obj.OperatTime 	//创建时间
			s bobj.State=obj.State				//状态
			s bobj.Remarks=obj.Remarks			//备注		
		}
			s obj.SymptomCode=eobj.SymptomCode		//ICD编码
			s obj.SymptomName=eobj.SymptomName	//证候名称
			s obj.SymptomAlias=eobj.SymptomAlias //别名
			s obj.SymptomVersion=eobj.SymptomVersion	//版本
			s obj.Operator=eobj.Operator	 	//创建人员
			s obj.OperatTime=eobj.OperatTime 	//创建时间
			s obj.State=eobj.State				//状态
			s obj.Remarks=eobj.Remarks			//备注		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.SymptomRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMSymptom","CT.WDT.CDSS.TCMSymptom","中医证候字典",id,eobj.SymptomName,"A",eobj)
			d:eobj.SymptomRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMSymptom","CT.WDT.CDSS.TCMSymptom","中医证候字典",eobj.SymptomRowId,eobj.SymptomName,"U",eobj,bobj)			
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.SymptomRowId="")&&(eobj.SymptomAlias'=""))||((eobj.SymptomRowId'="")&&(eobj.SymptomAlias'=bobj.SymptomAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMSymptom",id,eobj.SymptomAlias)
            }
            //同步修改识别词项目数据
			d:eobj.SymptomRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("中医证型名称",eobj.SymptomName,bobj.SymptomName)  
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医证候字典","web.CDSS.CMKB.TCMSymptom","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医证候字典","web.CDSS.CMKB.TCMSymptom","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：赵文伟
/// CreatDate: 2020-08-18
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.TCMSymptom
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.TCMSymptom).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.TCMSymptom).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMSymptom).%New() 
	s bobj.SymptomCode=obj.SymptomCode		//ICD编码
	s bobj.SymptomName=obj.SymptomName	//证候名称
	s bobj.SymptomAlias=obj.SymptomAlias //别名
	s bobj.SymptomVersion=obj.SymptomVersion	//版本
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
/// CreatDate:2021-8-19
/// Input:RowId  Opreation 操作(操作状态改变)
/// Return:
/// Other:w ##class(web.CDSS.CMKB.TCMSymptom).ChangeStatus(003,"1")
ClassMethod ChangeStatus(RowId, Operation)
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.TCMSymptom).%New()
	
	s:Operation="通过" eobj.State="2"	//已审核
	s:Operation="弃用" eobj.State="1"	//已弃用
	s:Operation="恢复" eobj.State="0"	//编辑中
	s:Operation="驳回" eobj.State="0"	//编辑中
	s eobj.OperatTime=$zdt($h,3)
	if ($d(%session)) {s eobj.Operator=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.TCMSymptom).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMSymptom).%New()
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
            s lineD=obj.SymptomName_",中医诊断条件,主要条件-识别词,1,中医证型名称,"_obj.SymptomName_",0"
            s lineI=obj.SymptomName_",中医识别条件,主要条件-识别词,1,中医证型症状名称,"_obj.SymptomName_",0"
            d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineD)
            d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMSymptom","CT.WDT.CDSS.TCMSymptom","中医证候字典",RowId,obj.SymptomName_"&&"_Operation,"U",eobj,bobj)	
		
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:赵文伟
/// CreatDate:2022-02-28
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.CMKB.TCMSymptom).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
 	//识别词项目引用接口
    s SymptomName=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(id)),3)
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("中医证型名称",SymptomName)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr
	
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:赵文伟
/// CreatDate:2021-08-19
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.TCMSymptom
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.TCMSymptom).DeleteData("001")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Quit:id="" result="{success:'false',info:'删除失败,入参为空！'}" 
		s obj=##class(CT.WDT.CDSS.TCMSymptom).%OpenId(id)
		s bobj = ##class(web.CDSSEntity.CMKB.TCMSymptom).%New() 
		s bobj.SymptomCode=obj.SymptomCode		//ICD编码
		s bobj.SymptomName=obj.SymptomName	//证候名称
		s bobj.SymptomAlias=obj.SymptomAlias //别名
		s bobj.SymptomVersion=obj.SymptomVersion	//版本
		s bobj.Operator=obj.Operator	 	//创建人员
		s bobj.OperatTime=obj.OperatTime 	//创建时间
		s bobj.State=obj.State				//状态
		s bobj.Remarks=obj.Remarks			//备注
		Ts
		s sc=##class(CT.WDT.CDSS.TCMSymptom).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMSymptom","CT.WDT.CDSS.TCMSymptom","中医证候字典",id,bobj.SymptomName,"D",bobj)
			//同步删除别名通用表中数据 
			d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.TCMSymptom",id)
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("中医证候字典","web.CDSS.CMKB.TCMSymptom","DeleteData",bobj)
	       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	q result
}

/// Creator：赵文伟
/// CreatDate:2020-08-19
/// Description：导出中医证候字典表数据
/// Other:w ##class(web.CDSS.CMKB.TCMSymptom).ExportTCMSymptomTXT()
ClassMethod ExportTCMSymptomTXT(code, symptomname, alias, version, operator, starttime, endtime, state, remarks) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"中医证候字典数据.txt"		
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
	s:symptomname'="" symptomname=$ZCONVERT(symptomname,"U") //转换成大写 
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:operator'="" operator=$ZCONVERT(operator,"U") //转换成大写
	w "RowID	ICD编码	证候名称	别名	版本	操作人		操作时间		状态	备注"
	//d file.WriteLine()
	s SymptomRowId=""
	for
	{ 
		s SymptomRowId=$o(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId),-1) q:SymptomRowId="" 
		s SymptomCode=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),2)
		continue:((code'="")&&($ZCONVERT(SymptomCode,"U")'[code))
		s SymptomName=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),3)
		continue:((symptomname'="")&&($ZCONVERT(SymptomName,"U")'[symptomname))
		s SymptomAlias=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),4)
		continue:((alias'="")&&($ZCONVERT(SymptomAlias,"U")'[alias))
		s SymptomVersion=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),5)
		continue:((version'="")&&($ZCONVERT(SymptomVersion,"U")'[version))
		s Operator=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),6)
		continue:(operator'="")&&($ZCONVERT(Operator,"U")'[operator)
		
		s OperatTime=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),7)
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(OperatTime,3)))
		continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(OperatTime,3)))
		s State=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),8)
		s:State="" State=0
		continue:((state'="")&&(State'=state))
		/*if (state="")
		{
			continue:(State="1")	
		}else
		{
			continue:(State'=state)
			
		}*/
		s State=$case(State,"0":"编辑中","1":"已弃用","2":"已审核",:"编辑中")
		s Remarks=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(SymptomRowId)),9)	
		continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))	
			w !,SymptomRowId_"	"_SymptomCode_"	"_SymptomName_"	"_SymptomAlias_"	"_SymptomVersion_"	"_Operator_"	"_OperatTime_"	"_State_"	"_Remarks
	}	
	c file
	q fileName
}

/// Creator：赵文伟 
/// CreatDate: 2020-8-26
/// Description：获取当前时间
/// Other: w ##class(web.CDSS.CMKB.TCMSymptom).CurrentDate()
ClassMethod CurrentDate()
{
	s Date=$zdate(($p($h,",",1)),3)
	s Time=$ztime(($p($h,",",2)),1)
    q Date_" "_Time
}

/// Creator：赵文伟 
/// CreatDate: 2020-8-23
/// Description：导入中医证候字典数据
/// Table:CT.WDT.CDSS.TCMSymptom 中医证候字典
/// Other: w ##class(web.CDSS.CMKB.TCMSymptom).ImportSymptomData()
ClassMethod ImportSymptomData()
{
	
	s readcount=0
	s savecount=0
	s nosavecount=0
	s updatecount=0
	s id=0
	Ts

	s path="D:\中医基础字典数据\中医证候字典.csv"
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
		//s SymptomCode=$o(^CT.WDT.CDSS.TCMSymptomD(""),-1)
  		//s SymptomCode=$g(SymptomCode)+1		//ICD编码
  		s SymptomCode=$p(str,",",1)	//ICD编码
		s SymptomName=$p(str,",",2)	//证候名称
		s SymptomAlias=$p(str,",",3)	//别名
		s SymptomVersion=$p(str,",",4)	//版本
		s Operator=$p(str,",",5)	//操作人
		
		if (Operator="")
		{
		 s Operator="张静静"	
		}
		s OperatTime=$p(str,",",6)	//操作时间
		if (OperatTime="")
		{
		 	s OperatTime=..CurrentDate()
		}
		
		//s Operator=importer	//默认导入时间
		//s OperatTime=importdate	//默认导入者
		s State=$p(str,",",7)	//状态
		s State=$case(State,"已审核":"1","编辑中":"0",:"0")
		s Remarks=$p(str,",",8)	//备注
		
		s SymptomCode=$Zstrip(SymptomCode,"<>W")
		s SymptomName=$Zstrip(SymptomName,"<>W")
		s SymptomAlias=$zstrip(SymptomAlias,"<>W")
		s SymptomVersion=$zstrip(SymptomVersion,"<>W")
		s Operator=$zstrip(Operator,"<>W")
		s OperatTime=$zstrip(OperatTime,"<>W")
		s State=$zstrip(State,"<>W")
		s Remarks=$zstrip(Remarks,"<>W")
		
		s readcount=readcount+1
		s SymptomID=$o(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_$ZCONVERT(SymptomName,"U"),0))
		if (SymptomID'="")	
		{
			s obj=##class(CT.WDT.CDSS.TCMSymptom).%OpenId(SymptomID)
			
			s obj.SymptomCode=SymptomCode		//ICD编码
			s obj.SymptomName=SymptomName	//证候名称
			s obj.SymptomAlias=SymptomAlias //别名
			s obj.SymptomVersion=SymptomVersion	//版本
			s obj.Operator=Operator	 	//创建人员
			s obj.OperatTime=OperatTime 	//创建时间
			s obj.State=State				//状态
			s obj.Remarks=Remarks			//备注
			s sc= obj.%Save()
			if $$$ISOK(sc)
			{
				s result = "{success:'true'}"		
			}
			else
			{
				s result = "{success:'false'}"
			}
		}
		else
		{
			s eobj = ##class(web.CDSSEntity.CMKB.TCMSymptom).%New()
			s eobj.SymptomCode=SymptomCode		//ICD编码
			s eobj.SymptomName=SymptomName	//证候名称
			s eobj.SymptomAlias=SymptomAlias //别名
			s eobj.SymptomVersion=SymptomVersion	//版本
			s eobj.Operator=Operator	 	//创建人员
			s eobj.OperatTime=OperatTime 	//创建时间
			s eobj.State=State				//状态
			s eobj.Remarks=Remarks			//备注

			s result=..SaveData(eobj)
		}	

		if ((result'["false"))
		{
			s savecount=savecount+1
			if (SymptomID'="")
			{
				s updatecount=updatecount+1
			}
		}
		else
		{
			s nosavecount=nosavecount+1
			b ;1
			
		}
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	w "updatecount"_updatecount,!
	TC
	
	q "{success:'true'}"
}

/// Creator:赵文伟
/// CreatDate:2021-10-19
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.TCMSymptom
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMSymptom","GetAliasList","1592")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		
		s SymptomAlias=$LISTGET($G(^CT.WDT.CDSS.TCMSymptomD(id)),4)
		s Len=$Length(SymptomAlias,",")
		for i=1:1:Len{
			s Desc=$p(SymptomAlias,",",i)
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

/// Creator: 赵文伟 
/// CreatDate: 2021-10-18
/// Description: 批量通过
/// Table: CT.WDT.CDSS.TCMSymptom
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.TCMSymptom).ChangeStatusPass("3615,3617")
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
/// Table: CT.WDT.CDSS.TCMSymptom
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.TCMSymptom).ChangeStatusBack("3615,3617")
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

/// Creator：赵文伟 
/// CreatDate: 2022-01-20
/// Description：别名数据转存到别名通用表中
/// Table: CT.WDT.CDSS.TCMSymptom
/// Other: w ##class(web.CDSS.CMKB.TCMSymptom).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMSymptomD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.TCMSymptomD(RowId)),4)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMSymptom",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.TCMSymptom
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.TCMSymptom).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMSymptomD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.TCMSymptomD(RowId)),8)       
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

/// Creator：赵文伟 
/// CreatDate: 2022-03-03
/// Description：导入中医证候字典数据——新 （适合数据中无逗号）
/// Table:CT.WDT.CDSS.TCMSymptom 中医证候字典
/// Other: w ##class(web.CDSS.CMKB.TCMSymptom).ImportSymptomNewData("E:\Downloads\CDSS数据采集\中医证候数据-新.csv")
ClassMethod ImportSymptomNewData(path)
{
	
	s readcount=0
	s savecount=0
	s nosavecount=0
	s updatecount=0
	Ts
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
  		s SymptomCode=$p(str,",",1)		//ICD编码
		s SymptomName=$p(str,",",2)		//证候名称
		s SymptomAlias=$p(str,",",3)	//别名
		s SymptomVersion=$p(str,",",4)	//版本
		s Operator=$p(str,",",5)		//操作人
		
		if (Operator="")
		{
		 s Operator="dhcc"	
		}
		s OperatTime=$p(str,",",6)		//操作时间
		if (OperatTime="")
		{
		 	s OperatTime=$ZDT($H,3)
		}
		
		s State=$p(str,",",7)			//状态
		s State=$case(State,"编辑中":"0","已弃用":"1","已审核":"2",:"0")
		s Remarks=$p(str,",",8)			//备注
		//去除两端空白
		s SymptomCode=$Zstrip(SymptomCode,"<>W")
		s SymptomName=$Zstrip(SymptomName,"<>W")
		s SymptomAlias=$zstrip(SymptomAlias,"<>W")
		s SymptomVersion=$zstrip(SymptomVersion,"<>W")
		s Operator=$zstrip(Operator,"<>W")
		s OperatTime=$zstrip(OperatTime,"<>W")
		s State=$zstrip(State,"<>W")
		s Remarks=$zstrip(Remarks,"<>W")
		
		s readcount=readcount+1
		s SymptomID=$o(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_$ZCONVERT(SymptomName,"U"),0))
		if (SymptomID'="")		//已存在修改
		{
			s obj=##class(CT.WDT.CDSS.TCMSymptom).%OpenId(SymptomID)
			
			s obj.SymptomCode=SymptomCode		//ICD编码
			s obj.SymptomName=SymptomName		//证候名称
			s obj.SymptomAlias=SymptomAlias 	//别名
			s obj.SymptomVersion=SymptomVersion	//版本
			s obj.Operator=Operator	 			//创建人员
			s obj.OperatTime=OperatTime 		//创建时间
			s obj.State=State					//状态
			s obj.Remarks=Remarks				//备注
			s sc= obj.%Save()
			if $$$ISOK(sc)
			{
				s result = "{success:'true'}"		
			}
			else
			{
				s result = "{success:'false'}"
			}
		}
		else	//不存在新增
		{
			s eobj = ##class(web.CDSSEntity.CMKB.TCMSymptom).%New()
			s eobj.SymptomCode=SymptomCode		//ICD编码
			s eobj.SymptomName=SymptomName		//证候名称
			s eobj.SymptomAlias=SymptomAlias 	//别名
			s eobj.SymptomVersion=SymptomVersion	//版本
			s eobj.Operator=Operator	 		//创建人员
			s eobj.OperatTime=OperatTime 		//创建时间
			s eobj.State=State					//状态
			s eobj.Remarks=Remarks				//备注
			s result=..SaveData(eobj)
		}	
		if ((result["true"))
		{
			s savecount=savecount+1
			if (SymptomID'="")
			{
				s updatecount=updatecount+1
			}
		}
		else
		{
			
			s nosavecount=nosavecount+1
			w result,!
			
		}
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	w "updatecount"_updatecount,!
	TC
	q "{success:'true'}"
}

/// Creator：赵文伟
/// CreatDate: 2022-03-03
/// Description：导入中医体征字典表,导入文本格式为txt，TXT要求格式为ANSI编码
/// Table: CT.WDT.CDSS.TCMSymptom 
/// Other: w ##class(web.CDSS.CMKB.TCMSymptom).ImportDataTXT("D:\字典数据\中医证候数据-新.txt")
ClassMethod ImportDataTXT(path) As %String
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	
	if '##class(%File).Exists(path) 
	{
   		q "文件不存在"
    }
	s file=##class(%File).%New(path)
	d file.Open("R")
	k myFileAry
	
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s readcount=readcount+1
		s myFileAry(i)=data
		
		s SymptomCode=$p(data,$c(9),1)		//中药编码
		s SymptomName=$p(data,$c(9),2)		//中药名称
		s SymptomAlias=$p(data,$c(9),3)		//别名
		s SymptomVersion=$p(data,$c(9),4)	//版本
		s Operator=$p(data,$c(9),5)	
		if (Operator="")
		{
		 s Operator="dhcc"	
		}
		s OperatTime=$p(data,$c(9),6)	
		if (OperatTime="")
		{
		 	s OperatTime=$ZDATETIME($HOROLOG,3)
		}
		s State=$p(data,$c(9),7)			//状态
		s State=$case(State,"编辑中":"0","已弃用":"1","已审核":"2",:"0")
		s Remarks=$p(data,$c(9),8)			//备注
		
		s SymptomRowId=$o(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_$ZCONVERT(SymptomName,"U"),0))
		//b ;1
		if (SymptomRowId=""){
		
			s eobj = ##class(web.CDSSEntity.CMKB.TCMSymptom).%New()
			s eobj.SymptomRowId=""
			s eobj.SymptomCode=SymptomCode
			s eobj.SymptomName=SymptomName
			s eobj.SymptomAlias=SymptomAlias
			s eobj.SymptomVersion=SymptomVersion 
			s eobj.Operator=Operator	
			s eobj.OperatTime=OperatTime 
			s eobj.State=State				
			s eobj.Remarks=Remarks
		
			s result=..SaveData(eobj)
			//b ;2
			if ((result["true"))
			{	
				s savecount=savecount+1
			}
			else
			{
				s nosavecount=nosavecount+1
			}
		}else{
			w SymptomName_"已存在" ,!
		}
	}
	close file
    k file
	w "readcount："_(readcount-1),!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	
	q "{success:'true'}"
}

/// Creator：赵文伟
/// CreatDate: 2022-07-11
/// Description：修正数据保存方法
/// Table： CT.WDT.CDSS.TCMSymptom
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.TCMSymptom).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.TCMSymptom) As %String
{
	
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		s:eobj.State="" eobj.State=0
		s flag=..FormValidate(eobj.SymptomRowId,eobj.SymptomCode,eobj.SymptomName)  //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.SymptomRowId,eobj.SymptomName,eobj.SymptomAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.SymptomRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.TCMSymptom).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.TCMSymptom).%OpenId(eobj.SymptomRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMSymptom).%New()
			s bobj.SymptomCode=obj.SymptomCode		//ICD编码
			s bobj.SymptomName=obj.SymptomName	//证候名称
			s bobj.SymptomAlias=obj.SymptomAlias //别名
			s bobj.Operator=obj.Operator	 	//创建人员
			s bobj.OperatTime=obj.OperatTime 	//创建时间
				
		}
			s obj.SymptomCode=eobj.SymptomCode		//ICD编码
			s obj.SymptomName=eobj.SymptomName	//证候名称
			s obj.SymptomAlias=eobj.SymptomAlias //别名
			s eobj.Operator=$g(%session.Data("LOGON.USERNAME"))	 	//创建人员
			s obj.Operator=eobj.Operator
			s eobj.OperatTime=$ZDATETIME($H,3) 	//创建时间
			s obj.OperatTime=eobj.OperatTime
				
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.SymptomRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMSymptom","CT.WDT.CDSS.TCMSymptom","中医证候字典",id,eobj.SymptomName,"A",eobj)
			d:eobj.SymptomRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMSymptom","CT.WDT.CDSS.TCMSymptom","中医证候字典",eobj.SymptomRowId,eobj.SymptomName,"U",eobj,bobj)			
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.SymptomRowId="")&&(eobj.SymptomAlias'=""))||((eobj.SymptomRowId'="")&&(eobj.SymptomAlias'=bobj.SymptomAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMSymptom",id,eobj.SymptomAlias)
            }
            //同步修改识别词项目数据
			d:eobj.SymptomRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("中医证型名称",eobj.SymptomName,bobj.SymptomName)  
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医证候字典","web.CDSS.CMKB.TCMSymptom","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医证候字典","web.CDSS.CMKB.TCMSymptom","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:赵文伟
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMSymptom","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.TCMSymptom",RowId,LogID),-1) q:LogID=""
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

}
