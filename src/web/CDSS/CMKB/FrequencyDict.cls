/// Description：频率字典表 
/// Table：CT.WDT.CDSS.FrequencyDict
Class web.CDSS.CMKB.FrequencyDict Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2020-06-20
/// Description：查询频率字典
/// Table：CT.WDT.CDSS.FrequencyDict
/// Input：desc 
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.FrequencyDict","GetList","","","","","","")
Query GetList(rowid, code, name, desc, operuser, timescope, state, alias) As %Query(ROWSPEC = "FrequencyRowId,FrequencyCode,FrequencyName,FrequencyDesc,UseFlag,CreateDate,CreateUserID,Remarks,FrequencyAlias")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, name, desc, operuser, timescope, state, alias) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s FrequencyRowId=rowid
	s FrequencyCode=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),2)
	s FrequencyName=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),3)
	s FrequencyDesc=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),4)
	s UseFlag=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),5)
	s:UseFlag="" UseFlag=0
	s CreateDate=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),6)
	s CreateUserID=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),7)
	s Remarks=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),8)
	s FrequencyAlias=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),9)
	d OutputRow
 }
 else
 {
	s:name'="" name=$ZCONVERT(name,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:operuser'="" operuser=$ZCONVERT(operuser,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s FrequencyRowId=""
	for
	{ 
		s FrequencyRowId=$o(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId),-1) q:FrequencyRowId="" 
		s FrequencyCode=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),2)
		continue:((code'="")&&($ZCONVERT(FrequencyCode,"U")'[code))
		s FrequencyName=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),3)
		s FrequencyDesc=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),4)
		s UseFlag=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),5)
		s:UseFlag="" UseFlag=0
		if (state=""){
			continue:(UseFlag=1)			
		}
		else{
			continue:((state'="")&&(UseFlag'=state))
		}
		
		s starttime=$p(timescope,"^",1)
		s endtime=$p(timescope,"^",2)
		s CreateDate=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),6)
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
		s CreateUserID=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),7)
		continue:((operuser'="")&&($ZCONVERT(CreateUserID,"U")'[operuser))
		s Remarks=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),8)
		s FrequencyAlias=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),9)
		continue:((alias'="")&&($ZCONVERT(FrequencyAlias,"U")'[alias))
		if (($ZCONVERT(FrequencyName,"U")[name)&($ZCONVERT(FrequencyDesc,"U")[desc)) 
		{
			d OutputRow
		}
	}
}
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(FrequencyRowId,FrequencyCode,FrequencyName,FrequencyDesc,UseFlag,CreateDate,CreateUserID,Remarks,FrequencyAlias)
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 丁亚男
/// CreateDate:2018-03-27    
/// w ##class(web.CDSS.CMKB.FrequencyDict).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, desc As %String, code As %String) As %String
{
	
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.FrequencyDictI("CodeIndex",code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.FrequencyDictI("NameIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.FrequencyDictI("CodeIndex",code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.FrequencyDictI("NameIndex",desc,0))
		
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.FrequencyDict).ValidateAlias("146","QWE")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.FrequencyDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.FrequencyDictI("NameIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.FrequencyDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.FrequencyDictI("NameIndex",Alias,0))  						//字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator：丁亚男
/// CreatDate: 2020-06-19
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.FrequencyDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.FrequencyDict).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.FrequencyDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.FrequencyRowId,eobj.FrequencyName,eobj.FrequencyCode)
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.FrequencyRowId,eobj.FrequencyName,eobj.FrequencyAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.FrequencyRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.FrequencyDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.FrequencyDict).%OpenId(eobj.FrequencyRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.FrequencyDict).%New() 
			s bobj.FrequencyCode = obj.FrequencyCode  
			s bobj.FrequencyName = obj.FrequencyName  
			s bobj.FrequencyDesc = obj.FrequencyDesc 
			s bobj.UseFlag = obj.UseFlag 
			s bobj.CreateDate = obj.CreateDate
			s bobj.CreateUserID = obj.CreateUserID
			s bobj.Remarks = obj.Remarks
			s bobj.FrequencyAlias = obj.FrequencyAlias
		}
		
		s obj.FrequencyCode = eobj.FrequencyCode  
		s obj.FrequencyName = eobj.FrequencyName  
		s obj.FrequencyDesc = eobj.FrequencyDesc
		s obj.UseFlag = eobj.UseFlag  
		s eobj.CreateDate = $ZDATETIME($HOROLOG,3)
		s obj.CreateDate=eobj.CreateDate
		s eobj.CreateUserID = $g(%session.Data("LOGON.USERNAME"))
		s obj.CreateUserID = eobj.CreateUserID
		s obj.Remarks = eobj.Remarks 
		s obj.FrequencyAlias = eobj.FrequencyAlias
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.FrequencyRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.FrequencyDict","CT.WDT.CDSS.FrequencyDict","频率字典",id,eobj.FrequencyName,"A",eobj)
			d:eobj.FrequencyRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.FrequencyDict","CT.WDT.CDSS.FrequencyDict","频率字典",eobj.FrequencyRowId,eobj.FrequencyName,"U",eobj,bobj)
			
			//同步修改对照数据
			d:eobj.FrequencyRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("频率",bobj.FrequencyCode_"[A]"_bobj.FrequencyName,eobj.FrequencyCode_"[A]"_eobj.FrequencyName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.FrequencyRowId="")&&(eobj.FrequencyAlias'=""))||((eobj.FrequencyRowId'="")&&(eobj.FrequencyAlias'=bobj.FrequencyAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.FrequencyDict",id,eobj.FrequencyAlias)
            }
            //同步修改识别词项目数据   
			//d:eobj.FrequencyRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("每日频率",eobj.FrequencyName,bobj.FrequencyName)
			d:eobj.FrequencyRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("频率",eobj.FrequencyName,bobj.FrequencyName)
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("频率字典","web.CDSS.CMKB.FrequencyDict","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("频率字典","web.CDSS.CMKB.FrequencyDict","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2020-06-18
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.FrequencyDict
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.FrequencyDict).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.FrequencyDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.FrequencyDict).%New() 
	s bobj.FrequencyCode = obj.FrequencyCode  
	s bobj.FrequencyName = obj.FrequencyName  
	s bobj.FrequencyDesc = obj.FrequencyDesc
	s bobj.UseFlag = obj.UseFlag 
	s bobj.CreateDate = obj.CreateDate
	s bobj.CreateUserID = obj.CreateUserID
	s bobj.Remarks = obj.Remarks
	s bobj.FrequencyAlias = obj.FrequencyAlias
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator:丁亚男
/// CreatDate:2020-08-19
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// 目前没有引用手术的表、病因等用到但是保存的是手术名称，不影响
/// w ##class(web.CDSS.CMKB.FrequencyDict).GetRefFlag("97")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
   
    s DictDesc=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(id)),3)
	s hosp=0
	for
	{
		s hosp=$o(^CT.WDT.CDSS.InterDictMappingI("HospDictNameIndex",hosp))
		q:hosp=""
		s mappingid=0
		for
		{
			s mappingid=$o(^CT.WDT.CDSS.InterDictMappingI("HospDictNameIndex",hosp,DictDesc,mappingid))
			q:mappingid=""
			s MatchFlag= $lg($g(^CT.WDT.CDSS.InterDictMappingD(mappingid)),8)	
			if (MatchFlag=0)
			{
				s HospitalName= $lg($g(^CT.WDT.CDSS.CustomerHospD(hosp)),3)
				s myInfo=myInfo_"<字典对照:"_HospitalName_">"
				q
			}
		}
	}
	
	//识别词项目引用接口    
	s FrequencyName=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(id)),3)
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("频率",FrequencyName)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr
	
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:丁亚男
/// CreatDate:2020-06-18
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.FrequencyDict
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.FrequencyDict).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	s obj=##class(CT.WDT.CDSS.FrequencyDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.FrequencyDict).%New() 
	s bobj.FrequencyCode = obj.FrequencyCode  
	s bobj.FrequencyName = obj.FrequencyName  
	s bobj.FrequencyDesc = obj.FrequencyDesc
	s bobj.UseFlag = obj.UseFlag 
	s bobj.CreateDate = obj.CreateDate
	s bobj.CreateUserID = obj.CreateUserID
	s bobj.Remarks = obj.Remarks
	s bobj.FrequencyAlias = obj.FrequencyAlias
	s sc=##class(CT.WDT.CDSS.FrequencyDict).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.FrequencyDict","CT.WDT.CDSS.FrequencyDict","频率字典",id,bobj.FrequencyName,"D",bobj)
		//同步删除别名通用表中数据 
		d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.FrequencyDict",id)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("频率字典","web.CDSS.CMKB.FrequencyDict","DeleteData",bobj)
	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2020-06-03
/// Description：查询 频率
/// Table：CT.WDT.CDSS.FrequencyDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.FrequencyDict","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "FrequencyDR:%String,FrequencyName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s FrequencyDR=rowid
		s FrequencyName=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyDR)),3)
		d OutputRowCmb
	}
	else
	{
		
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s:q'="" q=$ZCONVERT(q,"U") //转换成大写
		
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
  		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.FrequencyDictD(ID))
			q:ID=""
			s FrequencyName=$lg($g(^CT.WDT.CDSS.FrequencyDictD(ID)),3)		//名称
			s length=$l(FrequencyName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s FrequencyDR=0
			for
			{
				s FrequencyDR=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,FrequencyDR))
				q:FrequencyDR="" 
				//s FrequencyDR=$o(^CT.WDT.CDSS.FrequencyDictD(FrequencyDR),-1) q:FrequencyDR=""  
				s FrequencyName=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyDR)),3)
				s UseFlag=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyDR)),5)
				//continue:UseFlag=0													//过滤停用
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(FrequencyName)  
				if (($ZCONVERT(FrequencyName,"U")[desc)||(PINYIN[desc)&(($ZCONVERT(FrequencyName,"U")[q)||(PINYIN[q))&(UseFlag=2)) {
					d OutputRowCmb
				}
				continue:((desc'="")||(q'=""))
				s num=num+1
				q:num=1000
			}
			q:num=1000
		}
	}
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(FrequencyDR,FrequencyName)
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

/// Creator:丁亚男
/// CreatDate:2020-11-30
/// Description:导出频率字典表数据【暂不用】
/// Table:
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.FrequencyDict).ExportFrequencyCSVData()
ClassMethod ExportFrequencyCSVData() As %String
{
	s sum=0
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="频率字典数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.WriteLine("频率编码,频率名称,频率描述,操作时间,操作人")
	s FrequencyRowId=""
	for
	{ 
		s FrequencyRowId=$o(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId),-1) q:FrequencyRowId="" 
		s FrequencyCode=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),2)
		s FrequencyName=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),3)
		s FrequencyDesc=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),4)
		
		s CreateDate=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),6)
		s CreateUserID=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),7)
		
		
 		//替换双引号
		s FrequencyCode=$replace(FrequencyCode,"""","”")
		s FrequencyName=$replace(FrequencyName,"""","”")
		s FrequencyDesc=$replace(FrequencyDesc,"""","”")
		
		//将英文逗号转换为中文逗号
		s FrequencyCode=$replace(FrequencyCode,",","，")
		s FrequencyName=$replace(FrequencyName,",","，")
		s FrequencyDesc=$replace(FrequencyDesc,",","，")
		s CreateUserID=$replace(CreateUserID,",","，")
			
		s str=FrequencyCode_","_FrequencyName_","_FrequencyDesc_","_CreateDate_","_CreateUserID
		d file.WriteLine(str)
		s sum = sum+1
	}
	
	d file.%Save()
	d file.%Close()
	//w sum 
	//q "{fileName:"""_fileName_"""}"
	q fileName
}

/// Creator:zhaowenwei
/// CreatDate:2021-11-05
/// Description：导出频率字典表数据txt【在用】
/// Other:w ##class(web.CDSS.CMKB.FrequencyDict).ExportFrequencyTXTData()
ClassMethod ExportFrequencyTXTData(code, name, alias, desc, operuser, state, starttime, endtime) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"频率字典数据.txt"		
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
	s:name'="" name=$ZCONVERT(name,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:operuser'="" operuser=$ZCONVERT(operuser,"U") //转换成大写
	w "频率编码	频率名称	频率别名	频率描述	状态	操作时间	操作人	备注"

	s FrequencyRowId=""
	for
	{ 
		s FrequencyRowId=$o(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId),-1) q:FrequencyRowId="" 
		s FrequencyCode=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),2)
		continue:((code'="")&&($ZCONVERT(FrequencyCode,"U")'[code))
		s FrequencyName=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),3)
		s FrequencyDesc=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),4)
		s UseFlag=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),5)
		s:UseFlag="" UseFlag=0
		if (state=""){
			continue:(UseFlag=1)			
		}
		else{
			continue:((state'="")&&(UseFlag'=state))
		}
		s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核","":"编辑中")
		s CreateDate=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),6)
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
		s CreateUserID=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),7)
		continue:((operuser'="")&&($ZCONVERT(CreateUserID,"U")'[operuser))
		s Remarks=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),8)
		s FrequencyAlias=$LISTGET($G(^CT.WDT.CDSS.FrequencyDictD(FrequencyRowId)),9)
		continue:((alias'="")&&($ZCONVERT(FrequencyAlias,"U")'[alias))
		if (($ZCONVERT(FrequencyName,"U")[name)&($ZCONVERT(FrequencyDesc,"U")[desc)) 
		{
			w !,FrequencyCode_"	"_FrequencyName_"	"_FrequencyAlias_"	"_FrequencyDesc_"	"_UseFlag_"	"_CreateDate_"	"_CreateUserID_"	"_Remarks
		}
	}
	c file
	q fileName
}

/// Creator:赵文伟
/// CreatDate:2021-10-20
/// Description：修改状态
/// Input：id, state 状态
/// Return: result
/// Other:w ##class(web.CDSS.CMKB.FrequencyDict).UpdateState("","")
ClassMethod UpdateState(RowId, Operation)
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.FrequencyDict).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.CreateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.FrequencyDict).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.FrequencyDict).%New()
	s bobj.UseFlag=obj.UseFlag
	s bobj.CreateDate=obj.CreateDate
	s bobj.CreateUserID=obj.CreateUserID
	
	s obj.UseFlag=eobj.UseFlag
 	s obj.CreateDate=eobj.CreateDate
 	s obj.CreateUserID=eobj.CreateUserID
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.FrequencyDict","CT.WDT.CDSS.FrequencyDict","频率字典",RowId,obj.FrequencyName_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-20
/// Description: 批量通过
/// Table: CT.WDT.CDSS.FrequencyDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.FrequencyDict).ChangeStatusPass("")
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
			s flag=..UpdateState(id,"通过")

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
/// CreatDate: 2021-10-20
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.FrequencyDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.FrequencyDict).ChangeStatusBack("")
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
			s flag=..UpdateState(id,"驳回")

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
/// CreatDate:2021-12-23
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.FrequencyDict
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.FrequencyDict","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s FrequencyAlias = $lg($g(^CT.WDT.CDSS.FrequencyDictD(id)),9)
		s Len=$Length(FrequencyAlias,",")
		for i=1:1:Len{
			s Desc=$p(FrequencyAlias,",",i)
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
/// CreatDate: 2022-01-19
/// Description：别名数据转存到别名通用表中
/// Table: CT.WDT.CDSS.FrequencyDict
/// Other: w ##class(web.CDSS.CMKB.FrequencyDict).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.FrequencyDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.FrequencyDictD(RowId)),9)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.FrequencyDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.FrequencyDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.FrequencyDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.FrequencyDictD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.FrequencyDictD(RowId)),5)       
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
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.FrequencyDict","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.FrequencyDict",RowId,LogID),-1) q:LogID=""
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
/// CreatDate: 2023-01-16
/// Description：修正数据保存方法
/// Table：CT.WDT.CDSS.FrequencyDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.FrequencyDict).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.FrequencyDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.FrequencyRowId,eobj.FrequencyName,eobj.FrequencyCode)
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.FrequencyRowId,eobj.FrequencyName,eobj.FrequencyAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.FrequencyRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.FrequencyDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.FrequencyDict).%OpenId(eobj.FrequencyRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.FrequencyDict).%New() 
			s bobj.FrequencyCode = obj.FrequencyCode  
			s bobj.FrequencyName = obj.FrequencyName
			s bobj.CreateDate = obj.CreateDate
			s bobj.CreateUserID = obj.CreateUserID
			s bobj.FrequencyAlias = obj.FrequencyAlias
		}
		
		s obj.FrequencyCode = eobj.FrequencyCode  
		s obj.FrequencyName = eobj.FrequencyName 
		s eobj.CreateDate = $ZDATETIME($HOROLOG,3)
		s obj.CreateDate=eobj.CreateDate
		s eobj.CreateUserID = $g(%session.Data("LOGON.USERNAME"))
		s obj.CreateUserID = eobj.CreateUserID
		s obj.FrequencyAlias = eobj.FrequencyAlias
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.FrequencyRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.FrequencyDict","CT.WDT.CDSS.FrequencyDict","频率字典",id,eobj.FrequencyName,"A",eobj)
			d:eobj.FrequencyRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.FrequencyDict","CT.WDT.CDSS.FrequencyDict","频率字典",eobj.FrequencyRowId,eobj.FrequencyName,"U",eobj,bobj)
			
			//同步修改对照数据
			d:eobj.FrequencyRowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("频率",bobj.FrequencyCode_"[A]"_bobj.FrequencyName,eobj.FrequencyCode_"[A]"_eobj.FrequencyName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.FrequencyRowId="")&&(eobj.FrequencyAlias'=""))||((eobj.FrequencyRowId'="")&&(eobj.FrequencyAlias'=bobj.FrequencyAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.FrequencyDict",id,eobj.FrequencyAlias)
            }
            //同步修改识别词项目数据   
			//d:eobj.FrequencyRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("每日频率",eobj.FrequencyName,bobj.FrequencyName)
			d:eobj.FrequencyRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("频率",eobj.FrequencyName,bobj.FrequencyName)
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("频率字典","web.CDSS.CMKB.FrequencyDict","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("频率字典","web.CDSS.CMKB.FrequencyDict","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

}
