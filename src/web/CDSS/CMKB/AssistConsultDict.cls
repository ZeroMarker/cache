/// Description: 辅助问诊字典
/// Creator: 赵文伟
/// CreatDate： 2023-05-08
Class web.CDSS.CMKB.AssistConsultDict Extends %RegisteredObject
{

/// Creator：赵文伟
/// CreatDate: 2023-05-08
/// Description：查询方法
/// Table： CT.WDT.CDSS.AssistConsult
/// Input： 
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.AssistConsultDict","GetList","","发热","","","","","","","","","","","","","","","","","UpdateDate")
Query GetList(rowid, mainsymptopm, locdesc, partdesc, companysym, cause, emergency, degree, nature, useflag, updateuser, timescope, sortmethod) As %Query(ROWSPEC = "RowId,MainSymptom,LocDesc,PartDesc,CompanySym,Cause,Emergency,Degree,Nature,ReliefFactor,Spirit,Physical,Appetite,Sleep,Defecation,UseFlag,UpdateUser,UpdateDate")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, mainsymptopm, locdesc, partdesc, companysym, cause, emergency, degree, nature, useflag, updateuser, timescope, sortmethod) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s RowId=rowid
	s MainSymptom=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),2)	
	s LocDesc=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),3)
	s CompanySym=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),4)		
	s Cause=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),5)		
	s Emergency=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),6)
	s Degree=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),7)	
	s Nature=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),8)	
	s ReliefFactor=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),9)
	s Spirit=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),10)
	s Physical=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),11)		
	s Appetite=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),12)		
	s Sleep=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),13)	
	s Defecation=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),14)	
	s UseFlag=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),15)
	s:UseFlag="" UseFlag=0
	s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),16)
	s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),17)
	s PartDesc=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),18)
	d OutputRow
 }
 else
 {
	s:mainsymptopm'="" mainsymptopm=$ZCONVERT(mainsymptopm,"U") //转换成大写
	s:locdesc'="" locdesc=$ZCONVERT(locdesc,"U") 
	s:partdesc'="" partdesc=$ZCONVERT(partdesc,"U") 
	s:companysym'="" companysym=$ZCONVERT(companysym,"U")
	s:cause'="" cause=$ZCONVERT(cause,"U")
	s:emergency'="" emergency=$ZCONVERT(emergency,"U")
	s:degree'="" degree=$ZCONVERT(degree,"U")
	s:nature'="" nature=$ZCONVERT(nature,"U")
	s:updateuser'="" updateuser=$ZCONVERT(updateuser,"U")
	
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	if (sortmethod="Short")
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.AssistConsultD(ID))
			q:ID=""
			s MainSymptom= $lg($g(^CT.WDT.CDSS.AssistConsultD(ID)),2)		//主要症状
			s length=$l(MainSymptom)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
		}
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.AssistConsultD(ID))
			q:ID=""
			s UpdateDate= $lg($g(^CT.WDT.CDSS.AssistConsultD(ID)),17)				//操作时间
			s:UpdateDate="" UpdateDate="2022-01-01"
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
		
		s RowId=0
		for
		{
			s RowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,RowId)) q:RowId=""
			
			s MainSymptom=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),2)
			continue:((mainsymptopm'="")&&($ZCONVERT(MainSymptom,"U")'[mainsymptopm))	
			s LocDesc=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),3)
			continue:((locdesc'="")&&($ZCONVERT(LocDesc,"U")'[locdesc))
			s CompanySym=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),4)	
			continue:((companysym'="")&&($ZCONVERT(CompanySym,"U")'[companysym))	
			s Cause=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),5)
			continue:((cause'="")&&($ZCONVERT(Cause,"U")'[cause))
			s Emergency=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),6)
			continue:((emergency'="")&&($ZCONVERT(Emergency,"U")'[emergency))
			s Degree=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),7)
			s Degree=##class(web.DHCBL.BDP.FunLib).EvalJSON(Degree)
			continue:((degree'="")&&($ZCONVERT(Degree,"U")'[degree))	
			s Nature=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),8)	
			continue:((nature'="")&&($ZCONVERT(Nature,"U")'[nature))
			s ReliefFactor=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),9)
			s Spirit=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),10)
			s Physical=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),11)		
			s Appetite=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),12)	
			s Sleep=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),13)
			s Defecation=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),14)	
			s UseFlag=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),15)
			s:UseFlag="" UseFlag=0
			if (useflag=""){
				continue:(UseFlag="1")			
			}
			else{
				continue:((useflag'="")&&(UseFlag'=useflag))
			}
			s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),16)
			continue:((updateuser'="")&&($ZCONVERT(UpdateUser,"U")'[updateuser))	
			s starttime=$p(timescope,"^",1)
			s endtime=$p(timescope,"^",2)
			s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),17)
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
			continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
			s PartDesc=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),18)
			continue:((partdesc'="")&&($ZCONVERT(PartDesc,"U")'[partdesc))
			
			d OutputRow
		}
	}
}
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(RowId,MainSymptom,LocDesc,PartDesc,CompanySym,Cause,Emergency,Degree,Nature,ReliefFactor,Spirit,Physical,Appetite,Sleep,Defecation,UseFlag,UpdateUser,UpdateDate)
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

/// Creator：赵文伟
/// CreatDate: 2023-05-08
/// Description：查询【下拉框方法】
/// Table： CT.WDT.CDSS.AssistConsult
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.AssistConsultDict","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, mainsymptom As %String, q As %String) As %Query(ROWSPEC = "RowId:%String,MainSymptom:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, mainsymptom As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowId=rowid
		s MainSymptom=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),2)		
		d OutputRowCmb
	}
	else
	{
		
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.AssistConsultD(ID))
			q:ID=""
			s MainSymptom=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(ID)),2)		
			s length=$l(MainSymptom)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s:mainsymptom'="" mainsymptom=$ZCONVERT(mainsymptom,"U") //转换成大写
			s:q'="" q=$ZCONVERT(q,"U") //转换成大写
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s RowId=0
			for
			{
				s RowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,RowId))
				q:RowId=""
				s MainSymptom=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),2)
				s UseFlag=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),15)
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MainSymptom) 
				if ($ZCONVERT(MainSymptom,"U")[mainsymptom)||(PINYIN[mainsymptom)&(($ZCONVERT(MainSymptom,"U")[q)||(PINYIN[q))&(UseFlag=2) {
					
					d OutputRowCmb
				}
				continue:((mainsymptom'="")||(q'=""))
				s num=num+1
				q:num=1000
			}
			q:num=1000
		}

	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(RowId,MainSymptom)
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

/// Creator:赵文伟
/// CreatDate:2023-05-08
/// Description:用于实现数据校验功能的方法
/// Table: CT.WDT.CDSS.AssistConsult
/// Input: RowId、MainSymptom
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.CDSS.CMKB.AssistConsultDict).FormValidate("","","")
ClassMethod FormValidate(id As %String, desc As %String) As %String
{
	
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagd=""
	s:desc'="" flagd=$d(^CT.WDT.CDSS.AssistConsultI("MainSymptomIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""
		s:desc'="" idd=$o(^CT.WDT.CDSS.AssistConsultI("MainSymptomIndex",desc,0))
		
		if ((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// w ##class(web.CDSS.CMKB.AssistConsultDict).TestSaveData()
ClassMethod TestSaveData() As %String
{
	s eobj = ##class(web.CDSSEntity.CMKB.AssistConsultDict).%New()
	s eobj.RowId=""
	s eobj.MainSymptom = "头贼吉儿疼"
	s eobj.LocDesc = ""
	s eobj.PartDesc = ""
	s eobj.CompanySym = ""
	s eobj.Cause = ""
	s eobj.Emergency = ""
	s eobj.Degree = ""
	s eobj.Nature = ""
	s eobj.ReliefFactor = ""
	s eobj.Spirit = ""
	s eobj.Physical = ""
	s eobj.Appetite = ""
	s eobj.Sleep = ""
	s eobj.Defecation = ""
	s eobj.UseFlag = 0
	//s eobj.UpdateUser = $g(%session.Data("LOGON.USERNAME")) 
	s eobj.UpdateUser = "Demo Group"
	//s eobj.UpdateDate=$zdt($h,3)
	s eobj.UpdateDate = "2023-05-10 10:05:42"
}

/// Creator:赵文伟
/// CreatDate:2023-05-08
/// Description:保存辅助问诊字典表
/// Table: CT.WDT.CDSS.AssistConsult
/// Input: eobj 字典表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.CMKB.AssistConsultDict).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.AssistConsultDict)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s eobj.MainSymptom=$tr(eobj.MainSymptom," ","")
		s flag=..FormValidate(eobj.RowId,eobj.MainSymptom)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
			q result
		}
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.AssistConsult).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.AssistConsult).%OpenId(eobj.RowId)
		    s bobj = ##class(web.CDSSEntity.CMKB.AssistConsultDict).%New()
		    s bobj.MainSymptom = obj.MainSymptom
			s bobj.LocDesc = obj.LocDesc
			s bobj.PartDesc = obj.PartDesc
			s bobj.CompanySym = obj.CompanySym
			s bobj.Cause = obj.Cause
			s bobj.Emergency = obj.Emergency
			s bobj.Degree = obj.Degree
			s bobj.Nature = obj.Nature
			s bobj.ReliefFactor = obj.ReliefFactor
			s bobj.Spirit = obj.Spirit
			s bobj.Physical = obj.Physical
			s bobj.Appetite = obj.Appetite
			s bobj.Sleep = obj.Sleep
			s bobj.Defecation = obj.Defecation
			s bobj.UseFlag = obj.UseFlag
			s bobj.UpdateUser = obj.UpdateUser
			s bobj.UpdateDate = obj.UpdateDate
		}		
		s obj.MainSymptom = eobj.MainSymptom
		s obj.LocDesc = eobj.LocDesc
		s obj.PartDesc = eobj.PartDesc
		s obj.CompanySym = eobj.CompanySym
		s obj.Cause = eobj.Cause
		s obj.Emergency = eobj.Emergency
		s obj.Degree = eobj.Degree
		s obj.Nature = eobj.Nature
		s obj.ReliefFactor = eobj.ReliefFactor
		s obj.Spirit = eobj.Spirit
		s obj.Physical = eobj.Physical
		s obj.Appetite = eobj.Appetite
		s obj.Sleep = eobj.Sleep
		s obj.Defecation = eobj.Defecation
		s obj.UseFlag = eobj.UseFlag
		//s eobj.UpdateUser = $g(%session.Data("LOGON.USERNAME")) 
		s obj.UpdateUser = eobj.UpdateUser
		//s eobj.UpdateDate=$zdt($h,3)
		s obj.UpdateDate = eobj.UpdateDate
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志			
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssistConsult","CT.WDT.CDSS.AssistConsult","辅助问诊字典",id,eobj.MainSymptom,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssistConsult","CT.WDT.CDSS.AssistConsult","辅助问诊字典",eobj.RowId,eobj.MainSymptom,"U",eobj,bobj)
		
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("辅助问诊字典","web.CDSS.CMKB.AssistConsultDict","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}		
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("辅助问诊字典","web.CDSS.CMKB.AssistConsultDict","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 s result= "{success:'false',errorinfo:'保存失败！'}"
 q result
}

/// Creator:赵文伟
/// CreatDate:2023-05-08
/// Description:通过id获取字典表内容
/// Table: CT.WDT.CDSS.AssistConsult
/// Input: id 字典表id
/// Return: 辅助问诊字典表内容
/// others:w ##class(web.CDSS.CMKB.AssistConsultDict).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.AssistConsultDict).%New()
	s eobj.RowId = id
	s eobj.MainSymptom = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),2)
	s eobj.LocDesc = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),3)
	
	s eobj.CompanySym = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),4)
	s eobj.Cause = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),5)
	s eobj.Emergency = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),6)
	s eobj.Degree = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),7)
	s eobj.Nature = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),8)
	s eobj.ReliefFactor = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),9)
	s eobj.Spirit = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),10)
	s eobj.Physical = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),11)
	s eobj.Appetite = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),12)
	s eobj.Sleep = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),13)
	s eobj.Defecation = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),14)
	s eobj.UseFlag = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),15)
	s eobj.UpdateUser = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),16)
	s eobj.UpdateDate = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),17)
	s eobj.PartDesc = $lg($g(^CT.WDT.CDSS.AssistConsultD(id)),18)
	
    
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:赵文伟
/// CreatDate:2023-05-08
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.CMKB.AssistConsultDict).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能弃用或删除!"
    q return
}

/// Creator:赵文伟
/// CreatDate:2023-05-08
/// Description:删除辅助问诊字典表
/// Table: CT.WDT.CDSS.AssistConsult
/// Input: id 字典表id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.AssistConsultDict).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	s obj=##class(CT.WDT.CDSS.AssistConsult).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.AssistConsultDict).%New()
	s bobj.MainSymptom = obj.MainSymptom
	s bobj.LocDesc = obj.LocDesc
	s bobj.PartDesc = obj.PartDesc
	s bobj.CompanySym = obj.CompanySym
	s bobj.Cause = obj.Cause
	s bobj.Emergency = obj.Emergency
	s bobj.Degree = obj.Degree
	s bobj.Nature = obj.Nature
	s bobj.ReliefFactor = obj.ReliefFactor
	s bobj.Spirit = obj.Spirit
	s bobj.Physical = obj.Physical
	s bobj.Appetite = obj.Appetite
	s bobj.Sleep = obj.Sleep
	s bobj.Defecation = obj.Defecation
	s bobj.UseFlag = obj.UseFlag
	s bobj.UpdateUser = obj.UpdateUser
	s bobj.UpdateDate = obj.UpdateDate
		
	Ts	
	s sc=##class(CT.WDT.CDSS.AssistConsult).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssistConsult","CT.WDT.CDSS.AssistConsult","辅助问诊字典",id,bobj.MainSymptom,"D",bobj)
		
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	    s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("辅助问诊字典","web.CDSS.CMKB.AssistConsultDict","DeleteData",bobj)
	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator：赵文伟
/// CreatDate:2023-05-08
/// Input:RowId  Opreation操作(改变操作状态方法)
/// Return: 成功返回{success:'true'}，失败返回{success:'false',info:''}
/// Other:w ##class(web.CDSS.CMKB.AssistConsultDict).ChangeState(003,"1")
ClassMethod ChangeState(RowId, Operation)
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.AssistConsultDict).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.AssistConsult).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.AssistConsultDict).%New()
	s bobj.UseFlag=obj.UseFlag
	s bobj.UpdateDate=obj.UpdateDate
	s bobj.UpdateUser=obj.UpdateUser
	
	s obj.UseFlag=eobj.UseFlag
 	s obj.UpdateDate=eobj.UpdateDate
 	s obj.UpdateUser=eobj.UpdateUser
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssistConsult","CT.WDT.CDSS.AssistConsult","辅助问诊字典",RowId,obj.MainSymptom_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator: 赵文伟 
/// CreatDate: 2023-05-08
/// Description: 批量通过
/// Table: CT.WDT.CDSS.AssistConsult
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.AssistConsultDict).ChangeStatusPass("")
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
			s flag=..ChangeState(id,"通过")

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
/// CreatDate: 2023-05-08
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.AssistConsult
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.AssistConsultDict).ChangeStatusBack("")
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
			s flag=..ChangeState(id,"驳回")

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
/// CreatDate:2023-05-08
/// Description：导出辅助问诊字典表数据
/// Other:w ##class(web.CDSS.CMKB.AssistConsultDict).ExportTXTData()
ClassMethod ExportTXTData(mainsymptopm, locdesc, partdesc, companysym, cause, emergency, degree, nature, useflag, updateuser, timescope) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"辅助问诊字典数据.txt"		
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
	s:mainsymptopm'="" mainsymptopm=$ZCONVERT(mainsymptopm,"U") //转换成大写
	s:locdesc'="" locdesc=$ZCONVERT(locdesc,"U") 
	s:partdesc'="" partdesc=$ZCONVERT(partdesc,"U") 
	s:companysym'="" companysym=$ZCONVERT(companysym,"U")
	s:cause'="" cause=$ZCONVERT(cause,"U")
	s:emergency'="" emergency=$ZCONVERT(emergency,"U")
	s:degree'="" degree=$ZCONVERT(degree,"U")
	s:nature'="" nature=$ZCONVERT(nature,"U")
	s:updateuser'="" updateuser=$ZCONVERT(updateuser,"U")
	w "RowId	主要症状	科室	部位	伴随症状	病因诱因	发病缓急	程度	性质	缓解或加重因素	精神	体力	食欲	大小便	使用标识	操作人员	操作时间"
	
	s RowId=""
	for
	{ 
		s RowId=$o(^CT.WDT.CDSS.AssistConsultD(RowId),-1) q:RowId="" 	
		s MainSymptom=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),2)
			continue:((mainsymptopm'="")&&($ZCONVERT(MainSymptom,"U")'[mainsymptopm))	
			s LocDesc=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),3)
			continue:((locdesc'="")&&($ZCONVERT(LocDesc,"U")'[locdesc))
			s CompanySym=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),4)	
			continue:((companysym'="")&&($ZCONVERT(CompanySym,"U")'[companysym))	
			s Cause=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),5)
			continue:((cause'="")&&($ZCONVERT(Cause,"U")'[cause))
			s Emergency=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),6)
			continue:((emergency'="")&&($ZCONVERT(Emergency,"U")'[emergency))
			s Degree=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),7)
			s Degree=##class(web.DHCBL.BDP.FunLib).EvalJSON(Degree)
			continue:((degree'="")&&($ZCONVERT(Degree,"U")'[degree))	
			s Nature=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),8)	
			continue:((nature'="")&&($ZCONVERT(Nature,"U")'[nature))
			s ReliefFactor=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),9)
			s Spirit=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),10)
			s Physical=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),11)		
			s Appetite=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),12)	
			s Sleep=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),13)
			s Defecation=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),14)	
			s UseFlag=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),15)
			s:UseFlag="" UseFlag=0
			continue:((useflag'="")&&(UseFlag'=useflag))
#;			if (useflag=""){
#;				continue:(UseFlag="1")			
#;			}
#;			else{
#;				continue:((useflag'="")&&(UseFlag'=useflag))
#;			}
			s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核","":"编辑中")
			s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),16)
			continue:((updateuser'="")&&($ZCONVERT(UpdateUser,"U")'[updateuser))	
			s starttime=$p(timescope,"^",1)
			s endtime=$p(timescope,"^",2)
			s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),17)
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
			continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
			s PartDesc=$LISTGET($G(^CT.WDT.CDSS.AssistConsultD(RowId)),18)
			continue:((partdesc'="")&&($ZCONVERT(PartDesc,"U")'[partdesc))
			
			w !,RowId_"	"_MainSymptom_"	"_LocDesc_"	"_PartDesc_"	"_CompanySym_"	"_Cause_"	"_Emergency_"	"_Degree_"	"_Nature_"	"_ReliefFactor_"	"_Spirit_"	"_Physical_"	"_Appetite_"	"_Sleep_"	"_Defecation_"	"_UseFlag_"	"_UpdateUser_"	"_UpdateDate
		
		}
	c file
	q fileName
}

/// Creator：赵文伟 
/// CreatDate: 2023-05-08
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.AssistConsult
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.AssistConsultDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.AssistConsultD(RowId))
		q:RowId=""
		s UseFlag = $lg($g(^CT.WDT.CDSS.AssistConsultD(RowId)),15)       
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

/// Creator:赵文伟
/// CreatDate:2023-05-08
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.AssistConsultDict","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.AssistConsult",RowId,LogID),-1) q:LogID=""
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
