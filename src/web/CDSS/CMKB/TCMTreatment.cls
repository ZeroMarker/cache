/// Description: 中医治法字典
/// Creator: 赵文伟
/// CreatDate： 2022-02-11
Class web.CDSS.CMKB.TCMTreatment Extends %RegisteredObject
{

/// Creator：赵文伟
/// CreatDate: 2022-02-11
/// Description：查询方法
/// Table： CT.WDT.CDSS.TCMTreatment
/// Input： 
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMTreatment","GetList","","","","","","","","","","")
Query GetList(rowid, code As %String, name As %String, alias As %String, operator As %String, state As %String, timescope As %String, remarks As %String, sortmethod As %String) As %Query(ROWSPEC = "TreatmentRowId,TreatmentCode,TreatmentName,TreatmentAlias,Operator,OperatTime,State,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code As %String, name As %String, alias As %String, operator As %String, state As %String, timescope As %String, remarks As %String, sortmethod As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s TreatmentRowId=rowid
	s TreatmentCode=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),2)		//治法编码
	s TreatmentName=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),3)		//治法名称
	s TreatmentAlias=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),4)		//别名
	s Operator=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),5)			//操作人
	s OperatTime=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),6)			//操作时间
	s State=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),7)				//状态
	s:State="" State=0
	s Remarks=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),8)			//备注
	
	d OutputRow
 }
 else
 {
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:name'="" name=$ZCONVERT(name,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写 
	s:operator'="" operator=$ZCONVERT(operator,"U") //转换成大写 
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写 
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	if (sortmethod="Short")
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.TCMTreatmentD(ID))
			q:ID=""
			s TreatmentName= $lg($g(^CT.WDT.CDSS.TCMTreatmentD(ID)),3)		//名称
			s length=$l(TreatmentName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
		}
		
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.TCMTreatmentD(ID))
			q:ID=""
			s OperatTime= $lg($g(^CT.WDT.CDSS.TCMTreatmentD(ID)),6)				//操作时间
			s:OperatTime="" OperatTime="2022-01-01"
			s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",OperatTime,ID)=ID
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
		s TreatmentRowId=0
		for
		{
			s TreatmentRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,TreatmentRowId)) q:TreatmentRowId=""
			s TreatmentCode=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),2)		//治法编码
			continue:((code'="")&&($ZCONVERT(TreatmentCode,"U")'[code))
			s TreatmentName=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),3)		//治法名称
			continue:((name'="")&&($ZCONVERT(TreatmentName,"U")'[name))
			s TreatmentAlias=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),4)		//别名
			continue:((alias'="")&&($ZCONVERT(TreatmentAlias,"U")'[alias))
			s Operator=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),5)			//操作人
			continue:((operator'="")&&($ZCONVERT(Operator,"U")'[operator))
			s OperatTime=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),6)			//操作时间
			s starttime=$p(timescope,"^",1)
			s endtime=$p(timescope,"^",2)
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(OperatTime,3)))
	        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(OperatTime,3)))
			s State=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),7)				//状态
			s:State="" State=0
			if (state=""){
				continue:(State="1")			
			}
			else{
				continue:((state'="")&&(State'=state))
			}
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),8)			//备注
			continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
			
			d OutputRow
		}
	}
}
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(TreatmentRowId,TreatmentCode,TreatmentName,TreatmentAlias,Operator,OperatTime,State,Remarks)
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
/// CreatDate: 2022-02-17
/// Description：查询【下拉框方法】
/// Table： CT.WDT.CDSS.TCMTreatment
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMTreatment","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, name As %String, q As %String) As %Query(ROWSPEC = "TreatmentRowId:%String,TreatmentName:%String,TreatmentDR:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, name As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s TreatmentRowId=rowid
		s TreatmentName=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),3)		
		d OutputRowCmb
	}
	else
	{
		
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.TCMTreatmentD(ID))
			q:ID=""
			s TreatmentName=$lg($g(^CT.WDT.CDSS.TCMTreatmentD(ID)),3)		
			s length=$l(TreatmentName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s:name'="" name=$ZCONVERT(name,"U") //转换成大写
			//s:q'="" q=$ZCONVERT(q,"U") //转换成大写
			s:q'="" name=$ZCONVERT(q,"U")
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s TreatmentRowId=0
			for
			{
				s TreatmentRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,TreatmentRowId))
				q:TreatmentRowId=""
				s TreatmentDR=TreatmentRowId
				s TreatmentName=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),3)
				s State=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),7)				//状态
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TreatmentName) 
				if ($ZCONVERT(TreatmentName,"U")[name)||(PINYIN[name)&(($ZCONVERT(TreatmentName,"U")[q)||(PINYIN[q))&(State=2) {
					d OutputRowCmb
				}
				continue:((name'="")||(q'=""))
				s num=num+1
				q:num=1000
			}
			q:num=1000
		}

	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(TreatmentRowId,TreatmentName,TreatmentDR)
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
/// CreatDate:2022-02-11
/// Description:用于实现数据校验功能的方法
/// Table: CT.WDT.CDSS.TCMTreatment
/// Input: TreatmentRowId、TreatmentCode、TreatmentName
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.CDSS.CMKB.TCMTreatment).FormValidate("","","")
ClassMethod FormValidate(id As %String, name As %String, code As %String) As %String
{
	
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:name'="" name=" "_$ZCONVERT(name,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.TCMTreatmentI("CodeIndex",code))
	s:name'="" flagd=$d(^CT.WDT.CDSS.TCMTreatmentI("NameIndex",name))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.TCMTreatmentI("CodeIndex",code,0))
		s:name'="" idd=$o(^CT.WDT.CDSS.TCMTreatmentI("NameIndex",name,0))
		
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.TCMTreatment).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.TCMTreatment",Alias))
	    s flagN=$d(^CT.WDT.CDSS.TCMTreatmentI("NameIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.TCMTreatment",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.TCMTreatmentI("NameIndex",Alias,0))  						//字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator:赵文伟
/// CreatDate:2022-02-11
/// Description:保存中医治法字典表
/// Table: CT.WDT.CDSS.TCMTreatment
/// Input: eobj 字典表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.CMKB.TCMTreatment).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.TCMTreatment)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s eobj.TreatmentName=$tr(eobj.TreatmentName," ","")
		s flag=..FormValidate(eobj.TreatmentRowId,eobj.TreatmentName,eobj.TreatmentCode)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在'}"
		}
		s flagAlias=..ValidateAlias(eobj.TreatmentRowId,eobj.TreatmentName,eobj.TreatmentAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}" 
		}
		if (eobj.TreatmentRowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.TCMTreatment).%New()
			
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.TCMTreatment).%OpenId(eobj.TreatmentRowId)
		    s bobj = ##class(web.CDSSEntity.CMKB.TCMTreatment).%New()
		    s bobj.TreatmentCode = obj.TreatmentCode
			s bobj.TreatmentName = obj.TreatmentName
			s bobj.TreatmentAlias = obj.TreatmentAlias
			s bobj.Operator = obj.Operator
			s bobj.OperatTime = obj.OperatTime
			s bobj.State = obj.State
			s bobj.Remarks = obj.Remarks		
		}		
		s obj.TreatmentCode = eobj.TreatmentCode
		s obj.TreatmentName = eobj.TreatmentName
		s obj.TreatmentAlias = eobj.TreatmentAlias
		s obj.Operator = eobj.Operator
		s obj.OperatTime = eobj.OperatTime
		s obj.State = eobj.State
		s obj.Remarks = eobj.Remarks
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志			
			d:eobj.TreatmentRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMTreatment","CT.WDT.CDSS.TCMTreatment","中医治法字典",id,eobj.TreatmentName,"A",eobj)
			d:eobj.TreatmentRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMTreatment","CT.WDT.CDSS.TCMTreatment","中医治法字典",eobj.TreatmentRowId,eobj.TreatmentName,"U",eobj,bobj)
			
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.TreatmentRowId="")&&(eobj.TreatmentAlias'=""))||((eobj.TreatmentRowId'="")&&(eobj.TreatmentAlias'=bobj.TreatmentAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMTreatment",id,eobj.TreatmentAlias)
            }  
                      
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医治法字典","web.CDSS.CMKB.TCMTreatment","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}		
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医治法字典","web.CDSS.CMKB.TCMTreatment","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 s result= "{success:'false',errorinfo:'保存失败！'}"
 q result
}

/// Creator:赵文伟
/// CreatDate:2022-02-11
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.TCMTreatment
/// Input: id-疾病表id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMTreatment","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s TreatmentAlias = $lg($g(^CT.WDT.CDSS.TCMTreatmentD(id)),4)
		s Len=$Length(TreatmentAlias,",")
		for i=1:1:Len{
			s Desc=$p(TreatmentAlias,",",i)
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

/// Creator:赵文伟
/// CreatDate:2022-02-11
/// Description:通过id获取字典表内容
/// Table: CT.WDT.CDSS.TCMTreatment
/// Input: id 字典表id
/// Return: 中医治法字典表内容
/// others:w ##class(web.CDSS.CMKB.TCMTreatment).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.TCMTreatment).%New()
	s eobj.TreatmentRowId = id
    s eobj.TreatmentCode = $lg($g(^CT.WDT.CDSS.TCMTreatmentD(id)),2)
    s eobj.TreatmentName = $lg($g(^CT.WDT.CDSS.TCMTreatmentD(id)),3)
    s eobj.TreatmentAlias = $lg($g(^CT.WDT.CDSS.TCMTreatmentD(id)),4)
    s eobj.Operator = $lg($g(^CT.WDT.CDSS.TCMTreatmentD(id)),5)
    s eobj.OperatTime = $lg($g(^CT.WDT.CDSS.TCMTreatmentD(id)),6)
	s eobj.State = $lg($g(^CT.WDT.CDSS.TCMTreatmentD(id)),7)
	s eobj.Remarks = $lg($g(^CT.WDT.CDSS.TCMTreatmentD(id)),8)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:赵文伟
/// CreatDate:2022-02-11
/// Description:删除中医治法字典表
/// Table: CT.WDT.CDSS.TCMTreatment
/// Input: id 字典表id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.TCMTreatment).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
		s obj=##class(CT.WDT.CDSS.TCMTreatment).%OpenId(id)
		s bobj = ##class(web.CDSSEntity.CMKB.TCMTreatment).%New()
	    s bobj.TreatmentCode = obj.TreatmentCode
		s bobj.TreatmentName = obj.TreatmentName
		s bobj.TreatmentAlias = obj.TreatmentAlias
		s bobj.Operator = obj.Operator
		s bobj.OperatTime = obj.OperatTime
		s bobj.State = obj.State
		s bobj.Remarks = obj.Remarks
		
		Ts	
			
		s sc=##class(CT.WDT.CDSS.TCMTreatment).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMTreatment","CT.WDT.CDSS.TCMTreatment","中医治法字典",id,bobj.TreatmentName,"D",bobj)
			
			//删除别名通用表中数据
        	d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.TCMTreatment",id)
        	
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			
	       	s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("中医治法字典","web.CDSS.CMKB.TCMTreatment","DeleteData",bobj)
	       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
    
	q result
}

/// Creator：赵文伟
/// CreatDate:2022-02-11
/// Input:RowId  Opreation操作(改变操作状态方法)
/// Return: 成功返回{success:'true'}，失败返回{success:'false',info:''}
/// Other:w ##class(web.CDSS.CMKB.TCMTreatment).ChangeState(003,"1")
ClassMethod ChangeState(RowId, Operation)
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.TCMTreatment).%New()
	
	s:Operation="通过" eobj.State="2"	//已审核
	s:Operation="弃用" eobj.State="1"	//已弃用
	s:Operation="恢复" eobj.State="0"	//编辑中
	s:Operation="驳回" eobj.State="0"	//编辑中
	s eobj.OperatTime=$zdt($h,3)
	if ($d(%session)) {s eobj.Operator=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.TCMTreatment).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMTreatment).%New()
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
	        s lineI=obj.TreatmentName_",识别条件,主要条件-识别词,1,中医治法名称,"_obj.TreatmentName_",0"
	        d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMTreatment","CT.WDT.CDSS.TCMTreatment","中医治法字典",RowId,obj.TreatmentName_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator: 赵文伟 
/// CreatDate: 2022-02-11
/// Description: 批量通过
/// Table: CT.WDT.CDSS.TCMTreatment
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.TCMTreatment).ChangeStatusPass("")
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
/// CreatDate: 2022-02-11
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.TCMTreatment
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.TCMTreatment).ChangeStatusBack("")
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
/// CreatDate:2022-02-11
/// Description：导出中医治法字典表数据
/// Other:w ##class(web.CDSS.CMKB.TCMTreatment).ExportTXTData()
ClassMethod ExportTXTData(code, name, alias, operator, state, starttime, endtime, remarks) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"中医治法字典数据.txt"		
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
	w "治法编码	治法名称	治法别名	操作人员	操作时间	状态	备注"
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:name'="" name=$ZCONVERT(name,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写 
	s:operator'="" operator=$ZCONVERT(operator,"U") //转换成大写 
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写 
	s TreatmentRowId=""
	for
	{ 
		s TreatmentRowId=$o(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId),-1) q:TreatmentRowId="" 	
		s TreatmentCode=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),2)		//治法编码
		continue:((code'="")&&($ZCONVERT(TreatmentCode,"U")'[code))
		s TreatmentName=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),3)		//治法名称
		continue:((name'="")&&($ZCONVERT(TreatmentName,"U")'[name))
		s TreatmentAlias=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),4)		//别名
		continue:((alias'="")&&($ZCONVERT(TreatmentAlias,"U")'[alias))
		s Operator=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),5)			//操作人
		continue:((operator'="")&&($ZCONVERT(Operator,"U")'[operator))
		s OperatTime=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),6)			//操作时间
		
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(OperatTime,3)))
	    continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(OperatTime,3)))
		s State=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),7)				//状态
		s:State="" State=0
		continue:((state'="")&&(State'=state))
		/*if (state=""){
			continue:(State="1")			
		}
		else{
			continue:((state'="")&&(State'=state))
		}*/
		s State=$case(State,0:"编辑中",1:"已弃用",2:"已审核","":"编辑中")
		s Remarks=$LISTGET($G(^CT.WDT.CDSS.TCMTreatmentD(TreatmentRowId)),8)			//备注
		continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
		w !,TreatmentCode_"	"_TreatmentName_"	"_TreatmentAlias_"	"_Operator_"	"_OperatTime_"	"_State_"	"_Remarks
	}
	c file
	q fileName
}

/// Creator：赵文伟 
/// CreatDate: 2022-02-11
/// Description：别名数据转存到别名通用表中
/// Table: CT.WDT.CDSS.TCMTreatment
/// Other: w ##class(web.CDSS.CMKB.TCMTreatment).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMTreatmentD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.TCMTreatmentD(RowId)),4)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMTreatment",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-02-11
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.TCMTreatment
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.TCMTreatment).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMTreatmentD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s State = $lg($g(^CT.WDT.CDSS.TCMTreatmentD(RowId)),7)       
		if (State'="")
		{
			if (State=0){
				s editcount=editcount+1
			} elseif (State=2){
				s auditcount=auditcount+1
			}
		}
		s totalcount=editcount+auditcount	 	
	}
	q totalcount_"^"_editcount_"^"_auditcount_"^"_unauditcount
}

/// Creator:zhaowenwei
/// CreatDate:2022-02-16
/// Description:自动生成编码  
/// Input：
/// Return： code
/// Other:w ##class(web.CDSS.CMKB.TCMTreatment).GetLastCode()
ClassMethod GetLastCode() As %String
{
  	s id = $o(^CT.WDT.CDSS.TCMTreatmentD(""),-1)
    s Code=""
	if (id=""){
		s Code=1
	}else{
		s NowCode = $lg($g(^CT.WDT.CDSS.TCMTreatmentD(id)),2)
		s Code = NowCode+1
	}
	q Code
}

/// Creator:zhaowenwei
/// CreatDate:2022-02-24
/// Description:自动生成最新编码【取当前编码最大值+1】  
/// Table: CT.WDT.CDSS.TCMTreatment
/// Return： 最新编码Code
/// Other:w ##class(web.CDSS.CMKB.TCMTreatment).GetNewCode()
ClassMethod GetNewCode() As %String
{
  	
	s RowId=0
	s MaxCode=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TCMTreatmentD(RowId))
		q:RowId=""
		s Code = $lg($g(^CT.WDT.CDSS.TCMTreatmentD(RowId)),2)
		if (Code>MaxCode){
			s MaxCode=Code
		}
	}
	s Code=MaxCode+1
	q Code
}

/// Creator：赵文伟
/// CreatDate: 2022-02-17
/// Description：导入中医治法字典表,导入文本格式为txt，TXT要求格式为ANSI编码
/// Table: CT.WDT.CDSS.TCMTreatment 
/// Other: w ##class(web.CDSS.CMKB.TCMTreatment).ImportDataTXT("D:\字典数据\中医治法数据-新.txt")
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
		
		s TreatmentCode=$p(data,$c(9),1)	//治法编码
		s TreatmentName=$p(data,$c(9),2)	//治法名称
		s TreatmentAlias=$p(data,$c(9),3)	//别名
		s Operator=$p(data,$c(9),4)	
		if (Operator="")
		{
		 s Operator="dhcc"	
		}
		s OperatTime=$p(data,$c(9),5)	
		if (OperatTime="")
		{
		 	s OperatTime=$ZDATETIME($HOROLOG,3)
		}
		s State=$p(data,$c(9),6)		//状态
		s State=$case(State,"已审核":"1","编辑中":"0",:"0")
		s Remarks=$p(data,$c(9),7)		//备注
		
		s TreatmentRowId=$o(^CT.WDT.CDSS.TCMTreatmentI("NameIndex"," "_$ZCONVERT(TreatmentName,"U"),0))
		if (TreatmentRowId=""){
		
			s eobj = ##class(web.CDSSEntity.CMKB.TCMTreatment).%New()
			s eobj.TreatmentRowId=""
			s eobj.TreatmentCode=TreatmentCode
			s eobj.TreatmentName=TreatmentName
			s eobj.TreatmentAlias=TreatmentAlias 
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
			w TreatmentName_"已存在" ,!
		}
	}
	close file
    k file
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	
	q "{success:'true'}"
}

/// Creator:赵文伟
/// CreatDate:2022-09-02
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.CMKB.TCMTreatment).GetRefFlag("97")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0
    
    s RuleDescStr=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("治法",id)
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
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMTreatment","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.TCMTreatment",RowId,LogID),-1) q:LogID=""
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
/// Table：CT.WDT.CDSS.TCMTreatment
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.TCMTreatment).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.TCMTreatment) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s eobj.TreatmentName=$tr(eobj.TreatmentName," ","")
		s flag=..FormValidate(eobj.TreatmentRowId,eobj.TreatmentName,eobj.TreatmentCode)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在'}"
		}
		s flagAlias=..ValidateAlias(eobj.TreatmentRowId,eobj.TreatmentName,eobj.TreatmentAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.TreatmentRowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.TCMTreatment).%New()
			
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.TCMTreatment).%OpenId(eobj.TreatmentRowId)
		    s bobj = ##class(web.CDSSEntity.CMKB.TCMTreatment).%New()
		    s bobj.TreatmentCode = obj.TreatmentCode
			s bobj.TreatmentName = obj.TreatmentName
			s bobj.TreatmentAlias = obj.TreatmentAlias
			s bobj.Operator = obj.Operator
			s bobj.OperatTime = obj.OperatTime
		}		
		s obj.TreatmentCode = eobj.TreatmentCode
		s obj.TreatmentName = eobj.TreatmentName
		s obj.TreatmentAlias = eobj.TreatmentAlias
		s eobj.Operator = $g(%session.Data("LOGON.USERNAME")) 
		s obj.Operator=eobj.Operator	 	//创建人员
		s eobj.OperatTime=$zdt($h,3)
		s obj.OperatTime = eobj.OperatTime
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志			
			d:eobj.TreatmentRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMTreatment","CT.WDT.CDSS.TCMTreatment","中医治法字典",id,eobj.TreatmentName,"A",eobj)
			d:eobj.TreatmentRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMTreatment","CT.WDT.CDSS.TCMTreatment","中医治法字典",eobj.TreatmentRowId,eobj.TreatmentName,"U",eobj,bobj)
			
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.TreatmentRowId="")&&(eobj.TreatmentAlias'=""))||((eobj.TreatmentRowId'="")&&(eobj.TreatmentAlias'=bobj.TreatmentAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TCMTreatment",id,eobj.TreatmentAlias)
            }            
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医治法字典","web.CDSS.CMKB.TCMTreatment","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}		
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医治法字典","web.CDSS.CMKB.TCMTreatment","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 s result= "{success:'false',errorinfo:'保存失败！'}"
 q result
}

}
