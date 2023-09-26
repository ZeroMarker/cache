Import SQLUser

/// 名称: 诊断字典维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-5
Class web.DHCBL.KB.DHCExtIcdFeild Extends %RegisteredObject
{

/// 石萧伟
/// Description：修改时打开的数据
/// Table：User.DHCExtIcdFeild
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCExtIcdFeild).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCExtIcdFeild).%New()
	s eobj.ICDRowId=id
	s eobj.ICDCode=$p($g(^DHCEXTICD(id)),"^",1)
	s eobj.ICDDesc=$p($g(^DHCEXTICD(id)),"^",2)
	s eobj.ICDType=$p($g(^DHCEXTICD(id)),"^",3)
	s eobj.ICDAcitveFlag=$p($g(^DHCEXTICD(id)),"^",4)
	s eobj.ICDSysFlag=$p($g(^DHCEXTICD(id)),"^",5)
	s eobj.ICDOpStatus=$p($g(^DHCEXTICD(id)),"^",6)
	s eobj.ICDRemark=$p($g(^DHCEXTICD(id)),"^",7)
	s:eobj.ICDAcitveFlag="" eobj.ICDAcitveFlag="Y"
	s:eobj.ICDSysFlag="" eobj.ICDSysFlag="Y"
	s str = eobj.JsonS()	
	d eobj.%Close()
	//s str = "{list:["_str_"]}"
	q str
}

/// 石萧伟
/// Description:为combobox查询取数据
/// Table:User.DHCExtIcdFeild
/// Input:code,desc
/// Return:ICDRowId,ICDCode,ICDDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCExtIcdFeild","GetDataForCmb1","","")
Query GetDataForNewCmb(rowid As %String, code As %String, q As %String) As %Query(ROWSPEC = "ICDRowId:%String,ICDCode:%String,ICDDesc:%String")
{
}

ClassMethod GetDataForNewCmbExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	s AuStr=##class(web.DHCBL.Authorize.DHCExtIcdFeild).DHCGetDataByDefaultSession()
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ICDRowId=rowid
		s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
		s ICDDesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)	
		d OutputRowNewCmb
	}
	else
	{
		s count=0
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:q'="" q=$ZCONVERT(q,"U") //转换成大写
		s ICDRowId=0
		for {
			s ICDRowId=$o(^DHCEXTICD(ICDRowId))
			q:(ICDRowId="")||(count>49)
			//筛选授权后的数据
			s strRowId="{ID:"_ICDRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) {
				s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
				s ICDDesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
				s ICDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(ICDDesc)
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ICDDesc)
				if ($ZCONVERT(ICDCode,"U")[code)&(($ZCONVERT(ICDDesc,"U")[q)||(PINYIN[q))
				{
					s count=count+1
					d OutputRowNewCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowNewCmb
    set Data=$lb(ICDRowId,ICDCode,ICDDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForNewCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForNewCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Description：修改时打开的数据
/// Table：User.DHCExtIcdFeild
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCExtIcdFeild).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCExtIcdFeild).%New()
	s eobj.ICDRowId=id
	s eobj.ICDCode=$p($g(^DHCEXTICD(id)),"^",1)
	s eobj.ICDDesc=$p($g(^DHCEXTICD(id)),"^",2)
	s eobj.ICDType=$p($g(^DHCEXTICD(id)),"^",3)
	s eobj.ICDAcitveFlag=$p($g(^DHCEXTICD(id)),"^",4)
	s eobj.ICDSysFlag=$p($g(^DHCEXTICD(id)),"^",5)
	s eobj.ICDOpStatus=$p($g(^DHCEXTICD(id)),"^",6)
	s eobj.ICDRemark=$p($g(^DHCEXTICD(id)),"^",7)
	s:eobj.ICDAcitveFlag'="N" eobj.ICDAcitveFlag="true" 
	s:eobj.ICDSysFlag'="N" eobj.ICDSysFlag="true" 
	s str = eobj.JsonS()	
	d eobj.%Close()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：数据重复验证方法，由js调用
/// Table：User.DHCExtIcdFeild
/// Input：id, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^DHCEXTICD(0,"Code",code))
	s:desc'="" flagd=$d(^DHCEXTICD(0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^DHCEXTICD(0,"Code",code,0))
		s:desc'="" idd=$o(^DHCEXTICD(0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Description：保存诊断字典的内容
/// Table：User.DHCExtIcdFeild
/// Input：web.Entity.KB.DHCExtIcdFeild 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCExtIcdFeild).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCExtIcdFeild) As %String
{
	s $zt="ERROE"
	s result="",flag=""
	if $IsObject(eobj)
	{	
		s flag=..Validate(eobj.ICDRowId,eobj.ICDCode,eobj.ICDDesc)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.ICDRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCExtIcdFeild).%New()
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCExtIcdFeild).%OpenId(eobj.ICDRowId)
				/*s re=##class(web.DHCBL.KB.DHCExtIcdFeild).GetRefFlag(eobj.ICDRowId)
				s RefFlag=$p(re,"^",1)
				s str=$p(re,"^",2)
				if (RefFlag=1)&(str["<诊断与his诊断对照>"){
					s result = "{success:'false',errorinfo:'在诊断与his诊断对照中被引用，不能修改!'}"  //返回错误信息
					q result
				}*/
				s bobj=##class(web.Entity.KB.DHCExtIcdFeild).%New()
				s bobj.ICDRowId=eobj.ICDRowId
				s bobj.ICDCode=obj.ICDCode
				s bobj.ICDDesc = obj.ICDDesc          //修改描述
				s bobj.ICDType = obj.ICDType          
				s bobj.ICDAcitveFlag = obj.ICDAcitveFlag 
				s bobj.ICDSysFlag = obj.ICDSysFlag
				s bobj.ICDOpStatus = obj.ICDOpStatus
				s bobj.ICDRemark = obj.ICDRemark
			}
			Ts
			s obj.ICDCode = eobj.ICDCode
			s obj.ICDDesc = eobj.ICDDesc          //修改描述
			s obj.ICDType = eobj.ICDType    
			s:eobj.ICDAcitveFlag="" eobj.ICDAcitveFlag ="N" 
			s obj.ICDAcitveFlag = eobj.ICDAcitveFlag 
			s:eobj.ICDSysFlag="" eobj.ICDSysFlag ="N" 
			s obj.ICDSysFlag = eobj.ICDSysFlag
			s obj.ICDOpStatus = eobj.ICDOpStatus
			s obj.ICDRemark=eobj.ICDRemark	
					
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
				//新增时，日志
				d:eobj.ICDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ExtIcdFeild","User.DHCExtIcdFeild","诊断字典",id,eobj.ICDDesc,"A",eobj)
				//修改时，日志
				d:eobj.ICDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ExtIcdFeild","User.DHCExtIcdFeild","诊断字典",eobj.ICDRowId,eobj.ICDDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断字典","web.DHCBL.KB.DHCExtIcdFeild","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断字典","web.DHCBL.KB.DHCExtIcdFeild","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:丁亚男
/// CreatDate:2019-12-26
/// Description：查询诊断字典的内容
/// Table：User.DHCExtIcdFeild
/// Input：rowid,code,desc
/// Return:Json格式的字符串
/// Other:w ##class(web.DHCBL.KB.DHCExtIcdFeild).GetMyList("","","26316",5,1)
ClassMethod GetMyList(rowid, code, desc, rows, page) As %String
{
	s result="",total=0,jsonstr=""
	
	//获取授权
	s AuStr=##class(web.DHCBL.Authorize.DHCExtIcdFeild).DHCGetDataByDefaultSession()
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	w "{""rows"":["
	
	if (rowid'="") //根据rowid返回该条记录
	{
		
		s total=total+1
		s ICDRowId=rowid
		s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
		s ICDDesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
		s ICDType=$p($g(^DHCEXTICD(ICDRowId)),"^",3)
		s ICDAcitveFlag=$p($g(^DHCEXTICD(ICDRowId)),"^",4)
		s ICDSysFlag=$p($g(^DHCEXTICD(ICDRowId)),"^",5)
		s ICDOpStatus=$p($g(^DHCEXTICD(ICDRowId)),"^",6)
		s ICDRemark=$p($g(^DHCEXTICD(ICDRowId)),"^",7)
		s:ICDAcitveFlag="" ICDAcitveFlag="Y"
		s:ICDSysFlag="" ICDSysFlag="Y"
		s mainstr="{""ICDRowId"":"""_ICDRowId_""",""ICDCode"":"""_ICDCode_""",""ICDDesc"":"""_ICDDesc_""",""ICDType"":"""_ICDType
		_""",""ICDAcitveFlag"":"""_ICDAcitveFlag_""",""ICDSysFlag"":"""_ICDSysFlag_""",""ICDOpStatus"":"""_ICDOpStatus_""",""ICDRemark"":"""_ICDRemark_"""}"
		w mainstr

	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		
		s ICDRowId=0
		for {
			s ICDRowId=$o(^DHCEXTICD(ICDRowId)) q:ICDRowId=""
			s ICDDescU="",ICDCodeU=""
			if ((total+1<stpage)||(total+1>endpage))&&((desc="")&(code=""))   //如果不是当前页则只计数，不输出。
			{
				
			}
			else
			{
				//筛选授权后的数据
				s strRowId="{ID:"_ICDRowId_"}"
				if (AuStr[strRowId)||(AuFlag=1) {	

					s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
					s ICDCodeU=$ZCONVERT(ICDCode,"U")
					s ICDDesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
					s ICDDescU=$ZCONVERT(ICDDesc,"U")
					s ICDType=$p($g(^DHCEXTICD(ICDRowId)),"^",3)	
					s ICDAcitveFlag=$p($g(^DHCEXTICD(ICDRowId)),"^",4)
					s ICDSysFlag=$p($g(^DHCEXTICD(ICDRowId)),"^",5)
					s ICDOpStatus=$p($g(^DHCEXTICD(ICDRowId)),"^",6)
					s ICDRemark=$p($g(^DHCEXTICD(ICDRowId)),"^",7)
					s:ICDAcitveFlag="" ICDAcitveFlag="Y"
					s:ICDSysFlag="" ICDSysFlag="Y"	
				}
			}

			s PINYIN=""
			s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ICDDescU)
			if (ICDCodeU[code)&((ICDDescU[desc)||(PINYIN[desc))
			{
				s total=total+1
			    if (total<stpage) continue
			    if (total<=endpage)
			    {
					s mainstr="{""ICDRowId"":"""_ICDRowId_""",""ICDCode"":"""_ICDCode_""",""ICDDesc"":"""_ICDDesc_""",""ICDType"":"""_ICDType
						_""",""ICDAcitveFlag"":"""_ICDAcitveFlag_""",""ICDSysFlag"":"""_ICDSysFlag_""",""ICDOpStatus"":"""_ICDOpStatus_""",""ICDRemark"":"""_ICDRemark_"""}"
					if (jsonstr'="")
					{ 
						w ","
						s jsonstr=jsonstr_","_mainstr
					}
					else
					{
						s jsonstr=mainstr
					}
					w mainstr
				 }
			}
				
			
		}
	}
	w "], ""total"":"_total_"}"
	
	q ""
}

/// Description：查询诊断字典的内容
/// Table：User.DHCExtIcdFeild
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCExtIcdFeild","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ICDRowId:%String,ICDCode:%String,ICDDesc:%String,ICDType:%String,ICDAcitveFlag:%String,ICDSysFlag:%String,ICDOpStatus:%String,ICDRemark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	s AuStr=##class(web.DHCBL.Authorize.DHCExtIcdFeild).DHCGetDataByDefaultSession()
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ICDRowId=rowid
		s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
		s ICDDesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
		s ICDType=$p($g(^DHCEXTICD(ICDRowId)),"^",3)
		s ICDAcitveFlag=$p($g(^DHCEXTICD(ICDRowId)),"^",4)
		s ICDSysFlag=$p($g(^DHCEXTICD(ICDRowId)),"^",5)
		s ICDOpStatus=$p($g(^DHCEXTICD(ICDRowId)),"^",6)
		s ICDRemark=$p($g(^DHCEXTICD(ICDRowId)),"^",7)
		s:ICDAcitveFlag="" ICDAcitveFlag="Y"
		s:ICDSysFlag="" ICDSysFlag="Y"
	
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s ICDRowId=0
		for {
			s ICDRowId=$o(^DHCEXTICD(ICDRowId))
			q:ICDRowId=""
			//筛选授权后的数据
			s strRowId="{ID:"_ICDRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) {
				s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
				s ICDDesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
				s ICDType=$p($g(^DHCEXTICD(ICDRowId)),"^",3)	
				s ICDAcitveFlag=$p($g(^DHCEXTICD(ICDRowId)),"^",4)
				s ICDSysFlag=$p($g(^DHCEXTICD(ICDRowId)),"^",5)
				s ICDOpStatus=$p($g(^DHCEXTICD(ICDRowId)),"^",6)
				s ICDRemark=$p($g(^DHCEXTICD(ICDRowId)),"^",7)
				s:ICDAcitveFlag="" ICDAcitveFlag="Y"
				s:ICDSysFlag="" ICDSysFlag="Y"
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ICDDesc)
	
				if ($ZCONVERT(ICDCode,"U")[code)&(($ZCONVERT(ICDDesc,"U")[desc)||(PINYIN[desc))
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ICDRowId,ICDCode,ICDDesc,ICDType,ICDAcitveFlag,ICDSysFlag,ICDOpStatus,ICDRemark)
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

/// Description:为combobox查询取数据
/// Table:User.DHCExtIcdFeild
/// Input:code,desc
/// Return:ICDRowId,ICDCode,ICDDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCExtIcdFeild","GetDataForCmb1","23651","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ICDRowId:%String,ICDCode:%String,ICDDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	s AuStr=##class(web.DHCBL.Authorize.DHCExtIcdFeild).DHCGetDataByDefaultSession()
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ICDRowId=rowid
		s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
		s ICDDesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
		s ICDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(ICDDesc)	
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s ICDRowId=0
		for {
			s ICDRowId=$o(^DHCEXTICD(ICDRowId))
			q:ICDRowId=""
			//筛选授权后的数据
			s strRowId="{ID:"_ICDRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) {
				s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
				s ICDDesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
				s ICDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(ICDDesc)
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ICDDesc)
				if ($ZCONVERT(ICDCode,"U")[code)&(($ZCONVERT(ICDDesc,"U")[desc)||(PINYIN[desc))
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(ICDRowId,ICDCode,ICDDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Description:病症关联诊断界面为combobox查询取数据
/// Table:User.DHCExtIcdFeild
/// Input:code,desc
/// Return:ICDRowId,ICDCode,ICDDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCExtIcdFeild","GetDataForCmb1","","")
Query GetDataForCmb2(rowid As %String, desc As %String, con As %String) As %Query(ROWSPEC = "ICDRowId:%String,ICDCode:%String,ICDDesc:%String,ConFlag:%String,")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, con As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	s AuStr=##class(web.DHCBL.Authorize.DHCExtIcdFeild).DHCGetDataByDefaultSession()
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ICDRowId=rowid
		s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
		s ICDDesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)	
		d OutputRowCmb2
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s ConFlag=""
		s conicdstr=##class(web.DHCBL.KB.DHCPHDiseaseItmList).ConICDStr()
		s ICDRowId=0
		for {
			s ICDRowId=$o(^DHCEXTICD(ICDRowId))
			q:ICDRowId=""
			//筛选授权后的数据
			s strRowId="{ID:"_ICDRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) {
				s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
				s ICDDesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)				
				s ICDOpStatus=$p($g(^DHCEXTICD(ICDRowId)),"^",6)
				continue:ICDOpStatus=0    //放弃状态的不在诊断列表显示
				s id="{"_ICDRowId_"}"
				if (conicdstr[id)
				{
					s ConFlag="Y"			
				}
				else
				{
					s ConFlag="N"
				}
					
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ICDDesc)
				if (($ZCONVERT(ICDCode,"U")[desc)||($ZCONVERT(ICDDesc,"U")[desc)||(PINYIN[desc))&(ConFlag[con)
				{
					d OutputRowCmb2
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb2
    set Data=$lb(ICDRowId,ICDCode,ICDDesc,ConFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
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

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCExtIcdFeild).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="", myInfo=""
	s ICDKRowId=0,flag=0
	for
	{
		s ICDKRowId=$o(^DHCEXTICDK(ICDKRowId)) q:(ICDKRowId="")||(flag=1)  d
		s ICDKICDDr=$p($g(^DHCEXTICDK(ICDKRowId)),"^",1)
		i ICDKICDDr=id
		{
			s flag=1
			s myInfo=myInfo_"<诊断关键字表>"
		}
	}
	
	i ($d(^DHCPHDISL(0,"ICD",id))){
		s myInfo=myInfo_"<病症与诊断关联表>"
	}
	i ($d(^DHCPHHLOCICD(0,"ICD",id)))
	{
		s myInfo=myInfo_"<科室与诊断关联表>"
	}
	s ICDCode=$p($g(^DHCEXTICD(id)),"^",1) 
	s ICONRowId=0
	for  
	{	
		s ICONRowId=$o(^DHCEXTICON(ICONRowId)) q:ICONRowId=""||(flag=1)  d 
		s ICONCode=$p($g(^DHCEXTICON(ICONRowId)),"^",1)  
		i (ICONCode=ICDCode){
			s flag=1
			s myInfo=myInfo_"<诊断与his诊断对照>"	
		}	
	}
	
	i ($d(^DHCPHDLSY(0,"ICD",id))){
		s myInfo=myInfo_"<诊断与症状关联表>"
	}
	i ($d(^DHCPHSYNICD(0,"ICD",id))){
		s myInfo=myInfo_"<诊断与证型关联表>"
	}
	
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"里被引用,不能删除!"
 	q return
}

/// Description:根据id删除 诊断字典
/// Table:User.DHCExtIcdFeild
/// Input:id 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCExtIcdFeild).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	
	s re=##class(web.DHCBL.KB.DHCExtIcdFeild).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		
		s pobj = ##class(User.DHCExtIcdFeild).%OpenId(id)
		s eobj = ##class(web.Entity.KB.DHCExtIcdFeild).%New()
		s eobj.ICDRowId= id
		s eobj.ICDCode = pobj.ICDCode
		s eobj.ICDDesc = pobj.ICDDesc
		s eobj.ICDType = pobj.ICDType
		s eobj.ICDAcitveFlag=pobj.ICDAcitveFlag
		s eobj.ICDSysFlag=pobj.ICDSysFlag
		s eobj.ICDOpStatus=pobj.ICDOpStatus
		s eobj.ICDRemark=pobj.ICDRemark

		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.DHCExtIcdFeild).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ExtIcdFeild","User.DHCExtIcdFeild","诊断字典",id,eobj.ICDDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断字典","web.DHCBL.KB.DHCExtIcdFeild","DeleteData",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	
	q result
}

/// Description：将his诊断内容转移到诊断字典表
/// Table：User.DHCExtIcdFeild
/// Other: d ##class(web.DHCBL.KB.DHCExtIcdFeild).TransData()
ClassMethod TransData() As %String
{
	s result=""
	s MRCIDRowId=0
	
	for {
		s MRCIDRowId=$o(^MRC("ID",MRCIDRowId))
		q:MRCIDRowId=""
		s MRCIDCode=$p($g(^MRC("ID",MRCIDRowId)),"^",1)
		s MRCIDDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",2)
		s obj=##class(User.DHCExtIcdFeild).%New()
		s obj.ICDCode=MRCIDCode
		s obj.ICDDesc=MRCIDDesc
		s obj.ICDType="10"
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			s result="{success:'true'}"
		}
		else{
			s result= "{success:'false'}"
		}			 
	}
	q result
}

}
