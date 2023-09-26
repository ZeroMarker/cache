/// Description：中药字典表 
/// Table：CT.WDT.CDSS.TCMMedicine
Class web.CDSS.CMKB.TCMMedicine Extends %RegisteredObject
{

/// Creator：赵文伟
/// CreatDate: 2021-08-30
/// Description：查询 中药[下拉框方法]
/// Table：CT.WDT.CDSS.TCMMedicine
/// Input：rowid, code,name
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMMedicine","GetDataForCmb1","","","","")
Query GetDataForCmb1(rowid As %String, code As %String, name As %String, q As %String) As %Query(ROWSPEC = "MedicineRowId:%String,MedicineCode:%String,MedicineName:%String,MedicineDR:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, name As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 	if (rowid'="") //根据rowid返回该条记录
 	{
 		s MedicineRowId=rowid
		s MedicineCode=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),2)
		s MedicineName=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),3)  		
  		d OutputRowCmb
 	}
 	else
 	{		
  		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
  		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.TCMMedicineD(ID))
			q:ID=""
			s MedicineName=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(ID)),3)
			s length=$l(MedicineName)
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
			s MedicineRowId=0
			for
			{
				s MedicineRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,MedicineRowId))
				q:MedicineRowId=""
				s MedicineDR=MedicineRowId
				s MedicineCode=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),2)
  				s MedicineName=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),3)
  				s State=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),13)
  				if ((($ZCONVERT(MedicineCode,"U")[code)&($ZCONVERT(MedicineName,"U")[name))&(State=2)){
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
    set Data=$lb(MedicineRowId,MedicineCode,MedicineName,MedicineDR)
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
/// CreatDate: 2021-08-20
/// Description：查询中药字典（Query）
/// Table：CT.WDT.CDSS.TCMMedicine
/// Input：rowid,code,medicinename,alias,taste, channel,efficacy,attend,usage,taboo,operator,timescope,state,remarks
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMMedicine","GetList","","","","","","","","","","","","","","")
Query GetList(rowid As %String, code As %String, medicinename As %String, alias As %String, taste As %String, channel As %String, efficacy As %String, attend As %String, usage As %String, taboo As %String, operator As %String, timescope As %String, state As %String, remarks As %String, sortmethod) As %Query(ROWSPEC = "MedicineRowId,MedicineCode,MedicineName,MedicineAlias,MedicineTaste,MedicineChannelTropism,MedicineEfficacy,MedicineAttending,MedicineUsage,MedicineTaboo,Operator,OperatTime,State,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, medicinename As %String, alias As %String, taste As %String, channel As %String, efficacy As %String, attend As %String, usage As %String, taboo As %String, operator As %String, timescope As %String, state As %String, remarks As %String, sortmethod) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s MedicineRowId=rowid
	s MedicineCode=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),2)
	s MedicineName=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),3)
	s MedicineAlias=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),4)
	s MedicineTaste=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),5)
	s MedicineChannelTropism=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),6)
	s MedicineEfficacy=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),7)
	s MedicineAttending=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),8)
	s MedicineUsage=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),9)
	s MedicineTaboo=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),10)
	s Operator=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),11)
	s OperatTime=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),12)
	s State=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),13)
	s Remarks=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),14)
	d OutputRow
 }
 else
 {
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写 
	s:medicinename'="" medicinename=$ZCONVERT(medicinename,"U") //转换成大写 
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:taste'="" taste=$ZCONVERT(taste,"U") //转换成大写
	s:operator'="" operator=$ZCONVERT(operator,"U") //转换成大写
		
	//默认按时间倒序排列
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	if (sortmethod="Short")
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.TCMMedicineD(ID))
			q:ID=""
			s MedicineName= $lg($g(^CT.WDT.CDSS.TCMMedicineD(ID)),3)		//名称
			s length=$l(MedicineName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
		}
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.TCMMedicineD(ID))
			q:ID=""
			s UpdateDate= $lg($g(^CT.WDT.CDSS.TCMMedicineD(ID)),12)				//编辑时间
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
		s MedicineRowId=0
		for
		{
			s MedicineRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,MedicineRowId)) q:MedicineRowId=""
			s MedicineCode=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),2)
			continue:((code'="")&&($ZCONVERT(MedicineCode,"U")'[code))
			s MedicineName=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),3)
			continue:((medicinename'="")&&($ZCONVERT(MedicineName,"U")'[medicinename))
			s MedicineAlias=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),4)
			continue:((alias'="")&&($ZCONVERT(MedicineAlias,"U")'[alias))
			s MedicineTaste=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),5)
			continue:((taste'="")&&($ZCONVERT(MedicineTaste,"U")'[taste))
			s MedicineChannelTropism=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),6)
			continue:((channel'="")&&($ZCONVERT(MedicineChannelTropism,"U")'[channel))
			s MedicineEfficacy=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),7)
			continue:((efficacy'="")&&($ZCONVERT(MedicineEfficacy,"U")'[efficacy))
			s MedicineAttending=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),8)
			continue:((attend'="")&&($ZCONVERT(MedicineAttending,"U")'[attend))
			s MedicineUsage=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),9)
			continue:((usage'="")&&($ZCONVERT(MedicineUsage,"U")'[usage))
			s MedicineTaboo=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),10)
			continue:((taboo'="")&&($ZCONVERT(MedicineTaboo,"U")'[taboo))
			s Operator=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),11)
			continue:(operator'="")&&($ZCONVERT(Operator,"U")'[operator)
			s starttime=$p(timescope,"^",1)
			s endtime=$p(timescope,"^",2)
			s OperatTime=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),12)
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(OperatTime,3)))
			continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(OperatTime,3)))
			s State=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),13)
			s:State="" State=0
			if (state="")
			{
				continue:(State="1")	
			}else
			{
				continue:(State'=state)
			}
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),14)
			continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))	
			d OutputRow
		}
	}
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(MedicineRowId,MedicineCode,MedicineName,MedicineAlias,MedicineTaste,MedicineChannelTropism,MedicineEfficacy,MedicineAttending,MedicineUsage,MedicineTaboo,Operator,OperatTime,State,Remarks)
    
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
/// CreatDate:2021-08-20
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.TCMMedicine
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TCMMedicine).FormValidate("","001","测试4")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	
    //q:(code="") ""
    s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s flagc=$d(^CT.WDT.CDSS.TCMMedicineI("CodeIndex",code))
	s flagd=$d(^CT.WDT.CDSS.TCMMedicineI("NameIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s idc=$o(^CT.WDT.CDSS.TCMMedicineI("CodeIndex",code,0))
  		s idd=$o(^CT.WDT.CDSS.TCMMedicineI("NameIndex",desc,0))
  		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
	}	
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.TCMMedicine).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.TCMMedicine",Alias))
	    s flagN=$d(^CT.WDT.CDSS.TCMMedicineI("NameIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.TCMMedicine",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.TCMMedicineI("NameIndex",Alias,0))  						//字典表的名称来校验别名重复
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
/// CreatDate: 2021-08-20
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.TCMMedicine
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.TCMMedicine).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.TCMMedicine) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		s:eobj.State="" eobj.State=0
		s flag=..FormValidate(eobj.MedicineRowId,eobj.MedicineCode,eobj.MedicineName)  //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.MedicineRowId,eobj.MedicineName,eobj.MedicineAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.MedicineRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.TCMMedicine).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.TCMMedicine).%OpenId(eobj.MedicineRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMMedicine).%New()
			s bobj.MedicineCode=obj.MedicineCode		//中药编码
			s bobj.MedicineName=obj.MedicineName		//中药编码
			s bobj.MedicineAlias=obj.MedicineAlias 		//别名
			s bobj.MedicineTaste=obj.MedicineTaste		//性味
			s bobj.MedicineChannelTropism=obj.MedicineChannelTropism	//归经
			s bobj.MedicineEfficacy=obj.MedicineEfficacy	//功效
			s bobj.MedicineAttending=obj.MedicineAttending	//主治
			s bobj.MedicineUsage=obj.MedicineUsage		//用法用量
			s bobj.MedicineTaboo=obj.MedicineTaboo		//禁忌
			s bobj.Operator=obj.Operator	 	//创建人员
			s bobj.OperatTime=obj.OperatTime 	//创建时间
			s bobj.State=obj.State				//状态
			s bobj.Remarks=obj.Remarks			//备注		
		}
			s obj.MedicineCode=eobj.MedicineCode		//中药编码
			s obj.MedicineName=eobj.MedicineName		//中药编码
			s obj.MedicineAlias=eobj.MedicineAlias 		//别名
			s obj.MedicineTaste=eobj.MedicineTaste		//性味
			s obj.MedicineChannelTropism=eobj.MedicineChannelTropism	//归经
			s obj.MedicineEfficacy=eobj.MedicineEfficacy	//功效
			s obj.MedicineAttending=eobj.MedicineAttending	//主治
			s obj.MedicineUsage=eobj.MedicineUsage		//用法用量
			s obj.MedicineTaboo=eobj.MedicineTaboo		//禁忌
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
			d:eobj.MedicineRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMMedicine","CT.WDT.CDSS.TCMMedicine","中药字典",id,eobj.MedicineName,"A",eobj)
			d:eobj.MedicineRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMMedicine","CT.WDT.CDSS.TCMMedicine","中药字典",eobj.MedicineRowId,eobj.MedicineName,"U",eobj,bobj)			
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.MedicineRowId="")&&(eobj.MedicineAlias'=""))||((eobj.MedicineRowId'="")&&(eobj.MedicineAlias'=bobj.MedicineAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMMedicine",id,eobj.MedicineAlias)
            }
            //同步修改识别词项目数据
			d:eobj.MedicineRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("中药名称",eobj.MedicineName,bobj.MedicineName) 
			//同步修改对照数据
			d:eobj.MedicineRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("中药",bobj.MedicineCode_"[A]"_bobj.MedicineName,eobj.MedicineCode_"[A]"_eobj.MedicineName) 
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中药字典","web.CDSS.CMKB.TCMMedicine","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中药字典","web.CDSS.CMKB.TCMMedicine","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：赵文伟
/// CreatDate: 2021-08-20
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.TCMMedicine
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.TCMMedicine).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.TCMMedicine).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMMedicine).%New() 
	s bobj.MedicineCode=obj.MedicineCode		//中药编码
	s bobj.MedicineName=obj.MedicineName		//中药编码
	s bobj.MedicineAlias=obj.MedicineAlias 		//别名
	s bobj.MedicineTaste=obj.MedicineTaste		//性味
	s bobj.MedicineChannelTropism=obj.MedicineChannelTropism	//归经
	s bobj.MedicineEfficacy=obj.MedicineEfficacy	//功效
	s bobj.MedicineAttending=obj.MedicineAttending	//主治
	s bobj.MedicineUsage=obj.MedicineUsage		//用法用量
	s bobj.MedicineTaboo=obj.MedicineTaboo		//禁忌
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
/// Other:w ##class(web.CDSS.CMKB.TCMMedicine).ChangeStatus(003,"1")
ClassMethod ChangeStatus(RowId, Operation)
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.TCMMedicine).%New()
	
	s:Operation="通过" eobj.State="2"	//已审核
	s:Operation="弃用" eobj.State="1"	//已弃用
	s:Operation="恢复" eobj.State="0"	//编辑中
	s:Operation="驳回" eobj.State="0"	//编辑中
	s eobj.OperatTime=$zdt($h,3)
	if ($d(%session)) {s eobj.Operator=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.TCMMedicine).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMMedicine).%New()
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
		//同步删除对照数据【当状态变为已弃用或驳回时】	2022-04-08 ZWW
		if (obj.State= "1")||(obj.State="0"){ 
			d ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("中药",obj.MedicineCode_"[A]"_obj.MedicineName)
		}
		//状态改为已审核时识别词新增已拆分数据  Add By ZWW 2023-05-05 
		if (obj.State= "2"){
	        s lineI=obj.MedicineName_",识别条件,主要条件-识别词,1,中药名称,"_obj.MedicineName_",0"
	        d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMMedicine","CT.WDT.CDSS.TCMMedicine","中药字典",RowId,obj.MedicineName_"&&"_Operation,"U",eobj,bobj)	
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
/// w ##class(web.CDSS.CMKB.TCMMedicine).GetRefFlag("1790")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
 	//识别词项目引用接口
    s MedicineName=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(id)),3)
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("中药名称",MedicineName)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr
	
	//字典对照引用接口
	s Mappinginfo=##class(web.CDSS.IMP.DictMappingInfo).GetRefFlag("中药",MedicineName)
	if Mappinginfo'="" s myInfo=myInfo_Mappinginfo
	
	//规则(推荐治疗方案-处置-处置明细)引用接口
	s RuleDescStr=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("中药",id)
	if RuleDescStr'="" s myInfo=myInfo_"<规则管理："_RuleDescStr_">"
	
	//规则(推荐治疗方案-方剂-方剂组成)引用接口
	s RuleDescStr=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("方剂组成",id)
	if RuleDescStr'="" s myInfo=myInfo_"<规则管理："_RuleDescStr_">"
	
	//中医方剂-方剂组成引用接口
	s PrescriptionStr=##class(web.CDSS.CMKB.PreJoinMed).GetRefFlag(id)
	if PrescriptionStr'="" s myInfo=myInfo_"<中医方剂："_PrescriptionStr_">"
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能弃用/删除!"
    q return
}

/// Creator:赵文伟
/// CreatDate:2021-08-20
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.TCMMedicine
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.TCMMedicine).DeleteData("001")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Quit:id="" result="{success:'false',info:'删除失败,入参为空！'}" 
		s obj=##class(CT.WDT.CDSS.TCMMedicine).%OpenId(id)
		s bobj = ##class(web.CDSSEntity.CMKB.TCMMedicine).%New() 
		s bobj.MedicineCode=obj.MedicineCode		//中药编码
		s bobj.MedicineName=obj.MedicineName		//中药编码
		s bobj.MedicineAlias=obj.MedicineAlias 		//别名
		s bobj.MedicineTaste=obj.MedicineTaste		//性味
		s bobj.MedicineChannelTropism=obj.MedicineChannelTropism	//归经
		s bobj.MedicineEfficacy=obj.MedicineEfficacy	//功效
		s bobj.MedicineAttending=obj.MedicineAttending	//主治
		s bobj.MedicineUsage=obj.MedicineUsage		//用法用量
		s bobj.MedicineTaboo=obj.MedicineTaboo		//禁忌
		s bobj.Operator=obj.Operator	 	//创建人员
		s bobj.OperatTime=obj.OperatTime 	//创建时间
		s bobj.State=obj.State				//状态
		s bobj.Remarks=obj.Remarks			//备注
		Ts
		//同步删除对照数据 2022-01-21
		s re =  ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("中药",obj.MedicineCode_"[A]"_obj.MedicineName)
	 	if (re="true[A]true"){
			s sc=##class(CT.WDT.CDSS.TCMMedicine).%DeleteId(id)
			if $$$ISOK(sc)
			{
				Tc
				s result = "{success:'true',info:'删除成功！'}"	
				//保存日志
				d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMMedicine","CT.WDT.CDSS.TCMMedicine","中药字典",id,bobj.MedicineName,"D",bobj)
				//同步删除别名通用表中数据 
				d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.TCMMedicine",id)
				
				d bobj.%Close()
			}
			else
			{
				Tro
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("中药字典","web.CDSS.CMKB.TCMMedicine","DeleteData",bobj)
		       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
		} else{
	    s result = "{success:'false',info:'字典对照同步删除失败！'}"
	    }
	q result
}

/// Creator：赵文伟
/// CreatDate:2021-08-20
/// Description：导出中药字典表数据
/// Other:w ##class(web.CDSS.CMKB.TCMMedicine).ExportTCMMedicineTXT()
ClassMethod ExportTCMMedicineTXT(code, medicinename, alias, taste, channel, efficacy, attend, usage, taboo, operator, starttime, endtime, state, remarks) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"中药字典数据.txt"		
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
	s:medicinename'="" medicinename=$ZCONVERT(medicinename,"U") //转换成大写 
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:taste'="" taste=$ZCONVERT(taste,"U") //转换成大写
	s:operator'="" operator=$ZCONVERT(operator,"U") //转换成大写
	w "RowID	中药编码	中药名称	别名	性味	归经	功效	主治	用法用量	禁忌	操作人	操作时间	状态	备注"
	
	s MedicineRowId=""
	for
	{ 
		s MedicineRowId=$o(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId),-1) q:MedicineRowId="" 
		s MedicineCode=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),2)
		continue:((code'="")&&($ZCONVERT(MedicineCode,"U")'[code))
		s MedicineName=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),3)
		continue:((medicinename'="")&&($ZCONVERT(MedicineName,"U")'[medicinename))
		s MedicineAlias=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),4)
		continue:((alias'="")&&($ZCONVERT(MedicineAlias,"U")'[alias))
		s MedicineTaste=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),5)
		continue:((taste'="")&&($ZCONVERT(MedicineTaste,"U")'[taste))
		s MedicineChannelTropism=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),6)
		continue:((channel'="")&&($ZCONVERT(MedicineChannelTropism,"U")'[channel))
		s MedicineEfficacy=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),7)
		continue:((efficacy'="")&&($ZCONVERT(MedicineEfficacy,"U")'[efficacy))
		s MedicineAttending=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),8)
		continue:((attend'="")&&($ZCONVERT(MedicineAttending,"U")'[attend))
		s MedicineUsage=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),9)
		continue:((usage'="")&&($ZCONVERT(MedicineUsage,"U")'[usage))
		s MedicineTaboo=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),10)
		continue:((taboo'="")&&($ZCONVERT(MedicineTaboo,"U")'[taboo))
		s Operator=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),11)
		continue:(operator'="")&&($ZCONVERT(Operator,"U")'[operator)
			
		s OperatTime=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),12)
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(OperatTime,3)))
		continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(OperatTime,3)))
		s State=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),13)
		s:State="" State=0
		/*if (state="")
		{
			continue:(State="1")	
		}else
		{
			continue:(State'=state)
		}*/
		continue:((state'="")&&(State'=state))
		s State=$case(State,"0":"编辑中","1":"已弃用","2":"已审核",:"编辑中")
		s Remarks=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),14)
		continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))	
		w !,MedicineRowId_"	"_MedicineCode_"	"_MedicineName_"	"_MedicineAlias_"	"_MedicineTaste_"	"_MedicineChannelTropism_"	"_MedicineEfficacy_"	"_MedicineAttending_"	"_MedicineUsage_"	"_MedicineTaboo_"	"_Operator_"	"_OperatTime_"	"_State_"	"_Remarks	
	}
	c file
	q fileName
}

/// Creator：赵文伟 
/// CreatDate: 2021-8-26
/// Description：获取当前时间
/// Other: w ##class(web.CDSS.CMKB.TCMMedicine).CurrentDate()
ClassMethod CurrentDate()
{
	s Date=$zdate(($p($h,",",1)),3)
	s Time=$ztime(($p($h,",",2)),1)
    q Date_" "_Time
}

/// Creator：赵文伟
/// CreatDate: 2021-08-24
/// Description：导入中药字典表,导入文本格式为txt，TXT要求格式为ANSI编码
/// Table:CT.WDT.CDSS.TCMMedicine 中药字典表
/// Other: w ##class(web.CDSS.CMKB.TCMMedicine).ImportDataTXT("")
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
	/*
	s path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    s file=##class(%File).%New(path)
	*/
	s path="D:\中医基础字典数据\中药字典.txt"
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
		
		s MedicineCode=$p(data,$c(9),1)	//中药编码
		s MedicineName=$p(data,$c(9),2)	//中药名称
		s MedicineAlias=$p(data,$c(9),3)	//别名
		s MedicineTaste=$p(data,$c(9),4)	//性味
		s MedicineChannelTropism=$p(data,$c(9),5)	//归经
		s MedicineEfficacy=$p(data,$c(9),6)	//功效
		s MedicineAttending=$p(data,$c(9),7)	//主治
		s MedicineUsage=$p(data,$c(9),8)	//用法用量
		s MedicineTaboo=$p(data,$c(9),9)	//禁忌
		s Operator=$p(data,$c(9),10)	//操作人
		if (Operator="")
		{
		 s Operator="张静静"	
		}
		s OperatTime=$p(data,$c(9),11)	//操作时间
		if (OperatTime="")
		{
		 	s OperatTime=..CurrentDate()
		}
		
		s State=$p(data,$c(9),12)	//状态
		s State=$case(State,"已审核":"1","编辑中":"0",:"0")
		s Remarks=$p(data,$c(9),13)	//备注
		
		
		
		s MedicineID=$o(^CT.WDT.CDSS.TCMMedicineI("NameIndex"," "_$ZCONVERT(MedicineName,"U"),0))
	
		//if (MedicineID'="")	
		
		s eobj = ##class(web.CDSSEntity.CMKB.TCMMedicine).%New()
		//s obj=##class(CT.WDT.CDSS.TCMMedicine).%OpenId(MedicineID)
		//s eobj.ID = MedicineID
		
		s eobj.MedicineCode=MedicineCode		//中药编码
		s eobj.MedicineName=MedicineName		//中药编码
		s eobj.MedicineAlias=MedicineAlias 		//别名
		s eobj.MedicineTaste=MedicineTaste		//性味
		s eobj.MedicineChannelTropism=MedicineChannelTropism	//归经
		s eobj.MedicineEfficacy=MedicineEfficacy	//功效
		s eobj.MedicineAttending=MedicineAttending	//主治
		s eobj.MedicineUsage=MedicineUsage		//用法用量
		s eobj.MedicineTaboo=MedicineTaboo		//禁忌
		s eobj.Operator=Operator	 	//创建人员
		s eobj.OperatTime=OperatTime 	//创建时间
		s eobj.State=State				//状态
		s eobj.Remarks=Remarks			//备注
		
		s result=..SaveData(eobj)
		
		if ((result'["false"))
		{			
			s savecount=savecount+1
			
		}
		else
		{
			//b ;
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

/// Creator: 赵文伟 
/// CreatDate: 2021-10-18
/// Description: 批量通过
/// Table: CT.WDT.CDSS.TCMMedicine
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.TCMMedicine).ChangeStatusPass("")
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
/// Table: CT.WDT.CDSS.TCMMedicine
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.TCMMedicine).ChangeStatusBack("")
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
/// Table: CT.WDT.CDSS.TCMMedicine
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMMedicine","GetAliasList","1790")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		
		s MedicineAlias=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(id)),4)
		s Len=$Length(MedicineAlias,",")
		for i=1:1:Len{
			s Desc=$p(MedicineAlias,",",i)
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
/// Table: CT.WDT.CDSS.TCMMedicine
/// Other: w ##class(web.CDSS.CMKB.TCMMedicine).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMMedicineD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.TCMMedicineD(RowId)),4)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMMedicine",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.TCMMedicine
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.TCMMedicine).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMMedicineD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.TCMMedicineD(RowId)),13)       
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
/// CreatDate: 2022-02-11
/// Description：查询 中药[下拉框方法][编码，名称，用法用量]
/// Table：CT.WDT.CDSS.TCMMedicine
/// Input：rowid, code,name,usage
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMMedicine","GetDataForCmb2","","","","","")
Query GetDataForCmb2(rowid As %String, code As %String, name As %String, usage As %String, q As %String) As %Query(ROWSPEC = "MedicineRowId:%String,MedicineCode:%String,MedicineName:%String,MedicineUsage:%String,MedicineDR:%String")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, name As %String, usage As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 	if (rowid'="") //根据rowid返回该条记录
 	{
 		s MedicineRowId=rowid
		s MedicineCode=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),2)
		s MedicineName=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),3)  		
  		d OutputRowCmb
 	}
 	else
 	{		
  		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
  		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.TCMMedicineD(ID))
			q:ID=""
			s MedicineName=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(ID)),3)
			s length=$l(MedicineName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s:code'="" code=$ZCONVERT(code,"U") //转换成大写
			s:name'="" name=$ZCONVERT(name,"U") //转换成大写
			s:usage'="" usage=$ZCONVERT(usage,"U") //转换成大写
			s:q'="" name=$ZCONVERT(q,"U")
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s MedicineRowId=0
			for
			{
				s MedicineRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,MedicineRowId))
				q:MedicineRowId=""
				s MedicineDR=MedicineRowId
				s MedicineCode=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),2)
  				s MedicineName=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),3)
  				s MedicineUsage=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),9)
  				s State=$LISTGET($G(^CT.WDT.CDSS.TCMMedicineD(MedicineRowId)),13)
  				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MedicineName) 
  				if ((($ZCONVERT(MedicineCode,"U")[code)&(($ZCONVERT(MedicineName,"U")[name)||(PINYIN[name))&($ZCONVERT(MedicineUsage,"U")[usage))&(State=2)){
	  				
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
    set Data=$lb(MedicineRowId,MedicineCode,MedicineName,MedicineUsage,MedicineDR)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
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

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
	Set repid=$LIST(qHandle,2)
	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:zhaowenwei
/// CreatDate:2022-03-10
/// Description:自动生成最新编码【取当前编码最大值+1】  
/// Table: CT.WDT.CDSS.TCMMedicine
/// Return： 最新编码Code
/// Other:w ##class(web.CDSS.CMKB.TCMMedicine).GetNewCode()
ClassMethod GetNewCode() As %String
{
  	
	s RowId=0
	s MaxCode=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMMedicineD(RowId))
		q:RowId=""
		s Code = $lg($g(^CT.WDT.CDSS.TCMMedicineD(RowId)),2)
		if (Code>MaxCode){
			s MaxCode=Code
		}
	}
	s Code=MaxCode+1
	q Code
}

/// Creator：赵文伟
/// CreatDate: 2022-03-10
/// Description：导入中药字典数据,导入文本格式为txt，TXT要求格式为ANSI编码
/// Table: CT.WDT.CDSS.TCMMedicine 
/// Other: w ##class(web.CDSS.CMKB.TCMMedicine).ImportNewDataTXT("D:\字典数据\中药字典新增颗粒剂数据.txt")
ClassMethod ImportNewDataTXT(path) As %String
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
		s MedicineCode=..GetNewCode()
		s MedicineName=$p(data,$c(9),1)		//名称
		s MedicineAlias=$p(data,$c(9),2)	//别名
		s MedicineTaste=""
		s MedicineChannelTropism=""
		s MedicineEfficacy=""
		s MedicineAttending=""
		s MedicineUsage=""
		s MedicineTaboo=""
		s Operator="dhcc"	
		s OperatTime=$ZDATETIME($HOROLOG,3)	
		s State=""
		s State=$case(State,"已审核":"2","编辑中":"0",:"0")
		s Remarks=""		//备注
		
		s RowId=$o(^CT.WDT.CDSS.TCMMedicineI("NameIndex"," "_$ZCONVERT(MedicineName,"U"),0))
		
		if (RowId=""){
		
			s eobj = ##class(web.CDSSEntity.CMKB.TCMMedicine).%New()
		
			s eobj.MedicineCode=MedicineCode		//中药编码
			s eobj.MedicineName=MedicineName		//中药编码
			s eobj.MedicineAlias=MedicineAlias 		//别名
			s eobj.MedicineTaste=MedicineTaste		//性味
			s eobj.MedicineChannelTropism=MedicineChannelTropism	//归经
			s eobj.MedicineEfficacy=MedicineEfficacy	//功效
			s eobj.MedicineAttending=MedicineAttending	//主治
			s eobj.MedicineUsage=MedicineUsage		//用法用量
			s eobj.MedicineTaboo=MedicineTaboo		//禁忌
			s eobj.Operator=Operator	 	//创建人员
			s eobj.OperatTime=OperatTime 	//创建时间
			s eobj.State=State				//状态
			s eobj.Remarks=Remarks			//备注
		
			s result=..SaveData(eobj)
			
			if ((result["true"))
			{	
				s savecount=savecount+1
			}
			else
			{
				s nosavecount=nosavecount+1
			}
		}else{
			w MedicineName_"已存在" ,!
		}
	}
	close file
    k file
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	
	q "{success:'true'}"
}

/// Creator：赵文伟
/// CreatDate: 2022-04-08
/// Description：修正数据保存方法
/// Table： CT.WDT.CDSS.TCMMedicine
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.TCMMedicine).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.TCMMedicine) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.MedicineRowId,eobj.MedicineCode,eobj.MedicineName)  //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.MedicineRowId,eobj.MedicineName,eobj.MedicineAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.MedicineRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.TCMMedicine).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.TCMMedicine).%OpenId(eobj.MedicineRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMMedicine).%New()
			s bobj.MedicineCode = obj.MedicineCode  
			s bobj.MedicineName = obj.MedicineName 
			s bobj.MedicineAlias = obj.MedicineAlias 
			s bobj.OperatTime=obj.OperatTime		//创建时间
			s bobj.Operator=obj.Operator	//创建人员
			
		}
		s obj.MedicineCode = eobj.MedicineCode  
		s obj.MedicineName = eobj.MedicineName 
		s obj.MedicineAlias = eobj.MedicineAlias 
		s eobj.OperatTime=$ZDATETIME($H,3)	
		s obj.OperatTime=eobj.OperatTime
		s eobj.Operator=$g(%session.Data("LOGON.USERNAME"))	
		s obj.Operator=eobj.Operator
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.MedicineRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMMedicine","CT.WDT.CDSS.TCMMedicine","中药字典",id,eobj.MedicineName,"A",eobj)
			d:eobj.MedicineRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMMedicine","CT.WDT.CDSS.TCMMedicine","中药字典",eobj.MedicineRowId,eobj.MedicineName,"U",eobj,bobj)			
			
            //同步修改识别词项目数据
			d:eobj.MedicineRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("中药名称",eobj.MedicineName,bobj.MedicineName) 
			//同步修改对照数据
			d:eobj.MedicineRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("中药",bobj.MedicineCode_"[A]"_bobj.MedicineName,eobj.MedicineCode_"[A]"_eobj.MedicineName) 
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.MedicineRowId="")&&(eobj.MedicineAlias'=""))||((eobj.MedicineRowId'="")&&(eobj.MedicineAlias'=bobj.MedicineAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMMedicine",id,eobj.MedicineAlias)
            }
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中药字典","web.CDSS.CMKB.TCMMedicine","SaveAmendData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中药字典","web.CDSS.CMKB.TCMMedicine","SaveAmendData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:赵文伟
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMMedicine","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.TCMMedicine",RowId,LogID),-1) q:LogID=""
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
