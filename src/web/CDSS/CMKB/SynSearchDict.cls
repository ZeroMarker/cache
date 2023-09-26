/// Description: 同义词检索字典
/// Creator: 杨继鸿
/// CreatDate： 2022-03-09
Class web.CDSS.CMKB.SynSearchDict Extends %RegisteredObject
{

/// Creator：杨继鸿
/// CreatDate: 2022-03-09
/// Description：查询方法
/// Table： CT.WDT.CDSS.SynSearchDict
/// Input： 
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.SynSearchDict","GetList","","","bg","","","","","","")
Query GetList(rowid, abbre As %String, pyCode As %String, fullname As %String, operator As %String, state As %String, timescope As %String, remarks As %String, sortmethod As %String) As %Query(ROWSPEC = "RowId,SynSAbbre,SynSAbbrePYCode,SynSFullName,Operator,OperateTime,State,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, abbre As %String, pyCode As %String, fullname As %String, operator As %String, state As %String, timescope As %String, remarks As %String, sortmethod As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{
		//RowId,SynSAbbre,SynSAbbrePYCode,SynSFullName,Operator,OperateTime,State,Remarks
		s RowId=rowid
		s SynSAbbre=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),2)		//中文简称
		s SynSAbbrePYCode=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),3)		//简称拼音码
		s SynSFullName=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),4)		//全称
		s Operator=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),5)			//操作人
		s OperateTime=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),6)			//操作时间
		s State=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),7)				//状态
		s:State="" State=0
		s Remarks=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),8)			//备注

		d OutputRow
	}
	else
	{
		s:pyCode'="" pyCode=$ZCONVERT(pyCode,"U") //转换成大写
		s:abbre'="" abbre=$ZCONVERT(abbre,"U") //转换成大写
		s:fullname'="" fullname=$ZCONVERT(fullname,"U") //转换成大写 
		s:operator'="" operator=$ZCONVERT(operator,"U") //转换成大写 
		s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写 
		k ^TempDataHandle
		if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.SynSearchDictD(ID))
				q:ID=""
				s SynSAbbre= $lg($g(^CT.WDT.CDSS.SynSearchDictD(ID)),2)		//简称
				s length=$l(SynSAbbre)
				s ^TempDataHandle("Short",length,ID)=ID
			}
			s num=0
			s le=0
			for
			{
				s le=$o(^TempDataHandle("Short",le))
				q:le=""
				s id=0
				for
				{
					s id=$o(^TempDataHandle("Short",le,id))
					q:id=""
					s num=num+1
					s ^TempDataHandle("Handle",num)=id
				}
			}	
		}
		else
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.SynSearchDictD(ID))
				q:ID=""
				s OperateTime= $lg($g(^CT.WDT.CDSS.SynSearchDictD(ID)),6)				//操作时间
				s:OperateTime="" OperateTime="2022-01-01"
				s ^TempDataHandle("OperateTime",OperateTime,ID)=ID
			}
			s num=0
			s le=""
			for
			{
				s le=$o(^TempDataHandle("OperateTime",le),-1)
				q:le=""
				s id=0
				for
				{
					s id=$o(^TempDataHandle("OperateTime",le,id))
					q:id=""
					s num=num+1
					s ^TempDataHandle("Handle",num)=id
				}
			}
		}

		s Number=0
		for
		{ 	
			s Number=$o(^TempDataHandle("Handle",Number))
			q:Number=""
			s RowId=^TempDataHandle("Handle",Number)

			s SynSAbbre=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),2)		//中文简称
			continue:((abbre'="")&&($ZCONVERT(SynSAbbre,"U")'[abbre))
			s SynSAbbrePYCode=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),3)		//简称拼音码
			continue:((pyCode'="")&&($ZCONVERT(SynSAbbrePYCode,"U")'[pyCode))
			s SynSFullName=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),4)		//全称
			continue:((fullname'="")&&($ZCONVERT(SynSFullName,"U")'[fullname))
			s Operator=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),5)			//操作人
			continue:((operator'="")&&($ZCONVERT(Operator,"U")'[operator))
			s OperateTime=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),6)			//操作时间
			s starttime=$p(timescope,"^",1)
			s endtime=$p(timescope,"^",2)
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(OperateTime,3)))
			continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(OperateTime,3)))
			s State=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),7)				//状态
			s:State="" State=0
			if (state=""){
				continue:(State="1")			
			}
			else{
				continue:((state'="")&&(State'=state))
			}
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),8)			//备注
			continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))

			d OutputRow
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowId,SynSAbbre,SynSAbbrePYCode,SynSFullName,Operator,OperateTime,State,Remarks)
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

/// Creator:杨继鸿
/// CreatDate:2022-03-09
/// Description:用于实现数据校验功能的方法
/// Table: CT.WDT.CDSS.SynSearchDict
/// Input: id、name 同义词简称、fullname 全称
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.CDSS.CMKB.SynSearchDict).FormValidate("","","")
ClassMethod FormValidate1(id As %String, name As %String, fullname As %String) As %String
{
	s:name'="" name=$ZCONVERT(name,"U") //转换成大写
	s:fullname'="" fullname=$ZCONVERT(fullname,"U") //转换成大写
	s flag="",flagd=""
	s:(name'="")&(fullname'="") flagd=$d(^CT.WDT.CDSS.SynSearchDictI("AbbreIndex",name,fullname))
	if (id="") //如果为空，增加时的重复判断
	{		
		if (flagd>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""
		s:(name'="")&(fullname'="") idd=$o(^CT.WDT.CDSS.SynSearchDictI("AbbreIndex",name,fullname,0))
		if ((idd'="")&(idd'=id)&(flagd>0))
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0
		}
	}
	q flag
}

ClassMethod FormValidate(id As %String, name As %String, fullname As %String) As %String
{
	s flag=""
	s flagc=""
	s:((fullname'="")&&(name'="")) flagc=$d(^CT.WDT.CDSS.SynSearchDictI("AbbreIndex",name,fullname))
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
		s:((fullname'="")&&(name'="")) idc=$o(^CT.WDT.CDSS.SynSearchDictI("AbbreIndex",name,fullname,0))
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

/// Creator:杨继鸿
/// CreatDate:2022-03-09
/// Description:保存同义词检索字典表
/// Table: CT_WDT_CDSS.SynSearchDict
/// Input: eobj 字典表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.CMKB.SynSearchDict).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.SynSearchDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		
		s eobj.SynSAbbre=$tr(eobj.SynSAbbre," ","")
		s flag=..FormValidate(eobj.RowId,eobj.SynSAbbre,eobj.SynSFullName)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'记录已经存在'}"
			q result
		}
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.SynSearchDict).%New()	
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.SynSearchDict).%OpenId(eobj.RowId)
		    s bobj = ##class(web.CDSSEntity.CMKB.SynSearchDict).%New()
		    s bobj.RowId = eobj.RowId
		    s bobj.SynSAbbre = obj.SynSAbbre
			s bobj.SynSAbbrePYCode = obj.SynSAbbrePYCode
			s bobj.SynSFullName = obj.SynSFullName
			s bobj.Operator = obj.Operator
			s bobj.OperateTime = obj.OperateTime
			s bobj.State = obj.State
			s bobj.Remarks = obj.Remarks		
		}	
		s obj.SynSAbbre = eobj.SynSAbbre
		s obj.SynSAbbrePYCode = eobj.SynSAbbrePYCode
		s obj.SynSFullName = eobj.SynSFullName
		s obj.Operator = eobj.Operator
		s obj.OperateTime = eobj.OperateTime
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
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.SynSearchDict","CT.WDT.CDSS.SynSearchDict","同义词检索字典",id,eobj.SynSAbbre,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.SynSearchDict","CT.WDT.CDSS.SynSearchDict","同义词检索字典",eobj.RowId,eobj.SynSAbbre,"U",eobj,bobj)          
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("同义词检索字典","web.CDSS.CMKB.SynSearchDict","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}		
	}
	q result
ERROR
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("同义词检索字典","web.CDSS.CMKB.SynSearchDict","SaveData",eobj)
	s ^ERRORLOGINFO(logid)=$ze
	s result= "{success:'false',errorinfo:'保存失败！'}"
	q result
}

/// Creator:杨继鸿
/// CreatDate:2022-03-09
/// Description:通过id获取字典表内容
/// Table: CT.WDT.CDSS.SynSearchDict
/// Input: id 字典表id
/// Return: 同义词检索字典表内容
/// others:w ##class(web.CDSS.CMKB.SynSearchDict).OpenData("3")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.SynSearchDict).%New()
	s eobj.RowId = id
    s abbre=$lg($g(^CT.WDT.CDSS.SynSearchDictD(id)),2)
    q:abbre=""
    s eobj.SynSAbbre=abbre
    s eobj.SynSAbbrePYCode = $lg($g(^CT.WDT.CDSS.SynSearchDictD(id)),3)
    s eobj.SynSFullName = $lg($g(^CT.WDT.CDSS.SynSearchDictD(id)),4)
    s eobj.Operator = $lg($g(^CT.WDT.CDSS.SynSearchDictD(id)),5)
    s eobj.OperateTime = $lg($g(^CT.WDT.CDSS.SynSearchDictD(id)),6)
	s eobj.State = $lg($g(^CT.WDT.CDSS.SynSearchDictD(id)),7)
	s eobj.Remarks = $lg($g(^CT.WDT.CDSS.SynSearchDictD(id)),8)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:杨继鸿
/// CreatDate:2022-03-09
/// Description:删除同义词检索字典表
/// Table: CT.WDT.CDSS.SynSearchDict
/// Input: id 字典表id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.SynSearchDict).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	s obj=##class(CT.WDT.CDSS.SynSearchDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.SynSearchDict).%New()
    s bobj.SynSAbbre = obj.SynSAbbre
	s bobj.SynSAbbrePYCode = obj.SynSAbbrePYCode
	s bobj.SynSFullName = obj.SynSFullName
	s bobj.Operator = obj.Operator
	s bobj.OperateTime = obj.OperateTime
	s bobj.State = obj.State
	s bobj.Remarks = obj.Remarks
	
	Ts	
		
	s sc=##class(CT.WDT.CDSS.SynSearchDict).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.SynSearchDict","CT.WDT.CDSS.SynSearchDict","同义词检索字典",id,bobj.SynSAbbre,"D",bobj)
		
		//删除别名通用表中数据
    	//d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.SynSearchDict",id)
    	
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
       	s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("同义词检索字典","web.CDSS.CMKB.SynSearchDict","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator：杨继鸿
/// CreatDate:2022-03-09
/// Input:RowId  Opreation操作(改变操作状态方法)
/// Return: 成功返回{success:'true'}，失败返回{success:'false',info:''}
/// Other:w ##class(web.CDSS.CMKB.SynSearchDict).ChangeState(003,"1")
ClassMethod ChangeState(id, state)
{
	s result=""
	s obj=##class(CT.WDT.CDSS.SynSearchDict).%OpenId(id)
	s obj.State=state
	s obj.OperateTime=$zdt($h,3)
 	s obj.Operator=$g(%session.Data("LOGON.USERNAME"))
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s result = "{success:'true'}" 
	}
	else{
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
	}
	q result
}

/// Creator: 杨继鸿 
/// CreatDate: 2022-03-09
/// Description: 批量通过
/// Table: CT.WDT.CDSS.SynSearchDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.SynSearchDict).ChangeStatusPass("")
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
			s obj=##class(CT.WDT.CDSS.SynSearchDict).%OpenId(id)
			s obj.State=2
			s obj.OperateTime=$zdt($h,3)
 			s obj.Operator=$g(%session.Data("LOGON.USERNAME"))
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				continue
			}
			else{
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

/// Creator: 杨继鸿 
/// CreatDate: 2022-03-09
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.SynSearchDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.SynSearchDict).ChangeStatusBack("")
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
			s obj=##class(CT.WDT.CDSS.SynSearchDict).%OpenId(id)
			s obj.State=0
			s obj.OperateTime=$zdt($h,3)
 			s obj.Operator=$g(%session.Data("LOGON.USERNAME"))
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				continue
			}
			else{
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

/// Creator：杨继鸿
/// CreatDate:2022-03-09
/// Description：导出同义词检索字典表数据
/// Other:w ##class(web.CDSS.CMKB.SynSearchDict).ExportTXTData()
ClassMethod ExportTXTData()
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
#;	s Path=##class(%File).GetDirectory()
#;	s Disk=$p(Path,":",1) //截取盘符
#;	s fileName=time_"同义词检索字典数据.txt"
#;	s filePath=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"
#;	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
#;	if '##class(%File).Exists(filePath)
#;	{
#;   		q "文件路径不存在！请确认是否存在如下路径：<br>"_filePath
#;    }
    Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"同义词检索字典数据.txt"		
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
	w "中文简称	简称拼音码	全称	操作人员	操作时间	状态	备注"
	
	s RowId=""
	for
	{		
		s RowId=$o(^CT.WDT.CDSS.SynSearchDictD(RowId),-1) q:RowId="" 	
	 	s SynSAbbre=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),2)		//中文简称
		s SynSAbbrePYCode=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),3)		//简称拼音码
		s SynSFullName=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),4)		//全称
		s Operator=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),5)			//操作人
		s OperateTime=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),6)			//操作时间
		s State=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),7)				//状态
		s:State="" State=0
		s State=$case(State,0:"编辑中",1:"已弃用",2:"已审核","":"编辑中")
		s Remarks=$LISTGET($G(^CT.WDT.CDSS.SynSearchDictD(RowId)),8)			//备注
	 		
		w !,SynSAbbre_"	"_SynSAbbrePYCode_"	"_SynSFullName_"	"_Operator_"	"_OperateTime_"	"_State_"	"_Remarks
			
	}
	c file
	q fileName
}

/// Creator：杨继鸿 
/// CreatDate: 2022-03-09
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.SynSearchDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.SynSearchDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.SynSearchDictD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s State = $lg($g(^CT.WDT.CDSS.SynSearchDictD(RowId)),7)       
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

/// Creator：杨继鸿
/// CreatDate: 2022-03-10
/// Description：导入同义词检索字典表,导入文本格式为csv
/// Table: CT.WDT.CDSS.SynSearchDict 
/// Other: w ##class(web.CDSS.CMKB.SynSearchDict).ImportData("D:\workFile\需求\同义词检索字典\0304简称字典.csv")
ClassMethod ImportData(path) As %String
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
	
	while 'file.AtEnd
	{
		s data=file.Read()
		s readcount=readcount+1
		q:data=""
		
		s abbre=$p(data,",",1)
		s pycode=$p(data,",",2)
		s fullname=$p(data,",",3)
		s OperateTime=$ZDATETIME($HOROLOG,3)
		s Operator="dhcc"
		s state="0"
		s Remarks=""
		
		s eobj = ##class(web.CDSSEntity.CMKB.SynSearchDict).%New()
		s eobj.RowId=""
		s eobj.SynSAbbre=abbre
		s eobj.SynSAbbrePYCode=pycode
		s eobj.SynSFullName=fullname 
		s eobj.Operator=Operator	
		s eobj.OperateTime=OperateTime 
		s eobj.State=state
		s eobj.Remarks=Remarks
	
		s result=..SaveData(eobj)
		if ((result["true"))
		{	
			s savecount=savecount+1
		}
		else
		{
			w "保存失败："_abbre_" "_fullname
			s nosavecount=nosavecount+1
		}
	}
	close file
    k file
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	
	q "{success:'true'}"
}

/// Creator: 杨继鸿
/// CreatDate: 2022-04-21
/// Description: 批量删除数据
/// Input: dataStr 数据串
/// Output: savecount 保存总数；rows JOSN数组 保存失败的数据；errorinfo 错误信息 
/// Return: 成功 "{success:'true',count:删除的数量}"；失败 "{success:'false',errorinfo:'...'}"
/// Others: w ##class(web.CDSS.CMKB.SynSearchDict).NewImportData("")
/// w ##class(web.CDSS.CMKB.SynSearchDict).NewImportData(^TEMPNewImportData)
ClassMethod NewImportData(dataStr As %String) As %String
{
	//s ^TEMPNewImportData=dataStr
	s result={}
	s savecount=0
	s rows=[]
	
	s falseFlag=0
	TS
	s length=$length(dataStr,$c(13,10))	//识别回车换行
	for i=1:1:length
	{
		s data=$p(dataStr,$c(13,10),i)
		q:data=""
			
		s abbre=$p(data,",",1)
		continue:abbre=""
		s pycode=$p(data,",",2)
		s fullname=$p(data,",",3)
		s OperateTime=$ZDATETIME($HOROLOG,3)
		s:$d(%session)>0 Operator=$g(%session.Data("LOGON.USERNAME"))
		s:$d(%session)=0 Operator="dhcc"
		s state="0"
		s Remarks=""
			
		s eobj = ##class(web.CDSSEntity.CMKB.SynSearchDict).%New()
		s eobj.RowId=""
		s eobj.SynSAbbre=abbre
		s eobj.SynSAbbrePYCode=pycode
		s eobj.SynSFullName=fullname 
		s eobj.Operator=Operator	
		s eobj.OperateTime=OperateTime 
		s eobj.State=state
		s eobj.Remarks=Remarks
		s rs=..SaveData(eobj)
		if ((rs["true"))
		{	
			s savecount=savecount+1
		}
		else
		{
			s falseFlag=1
			d result.%Set("errorinfo",$p($p(rs,"errorinfo",2),"'",2))
			s errorData={}
			s errorData.SynSAbbre=abbre	// 简称中文
			s errorData.SynSAbbrePYCode=pycode	// 简称拼音码
			s errorData.SynSFullName=fullname	// 全名
			d rows.%Push(errorData.%ToJSON())
			q
		}
	}
	if falseFlag=1
	{
		TRO
		d result.%Set("success","false")
		d result.%Set("rows",rows.%ToJSON())
	}
	else
	{
		TC
		d result.%Set("success","true")
		d result.%Set("savecount",savecount)
	}
	q result.%ToJSON()
}

/// w ##class(web.CDSS.CMKB.SynSearchDict).ImportExcelData("测试,CSM,测试") 
ClassMethod ImportExcelData(dataStr As %String) As %String
{
	
	s result=""
			
		s dataStr=$tr(dataStr,"""")
		s dataStr=##class(web.DHCBL.BDP.FunLib).EvalJSONB(dataStr)		
		s abbre=$p(dataStr,",",1)
		q:abbre="" "false" 
		s pycode=$p(dataStr,",",2)
		q:pycode="" "false" 
		s fullname=$p(dataStr,",",3)
		s eobj = ##class(web.CDSSEntity.CMKB.SynSearchDict).%New()
		s eobj.RowId=""
		s eobj.SynSAbbre=abbre
		s eobj.SynSAbbrePYCode=pycode
		s eobj.SynSFullName=fullname 
		s eobj.Operator=$g(%session.Data("LOGON.USERNAME"))	
		s eobj.OperateTime=$ZDATETIME($HOROLOG,3) 
		s eobj.State=0
		s eobj.Remarks=""
		s re=..SaveData(eobj)
		if ((re="{success:'false',errorinfo:'记录已经存在'}")||(re["true"))
		{
			s result="true^"_re	
		}
		else
		{
			s result="false^"_re
		}
		
	q result
}

}
