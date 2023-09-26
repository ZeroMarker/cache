/// Description：输血品分类字典表 
/// Table：CT.WDT.CDSS.BPClassDict
Class web.CDSS.CMKB.BPClassDict Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2020-06-20
/// Description：查询输血品分类字典
/// Table：CT.WDT.CDSS.BPClassDict
/// Input：desc 
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.BPClassDict","GetList","","","","","","1","","UpdateDate")
Query GetList(rowid, code, desc, alias, operuser, state, timescope, sortmethod) As %Query(ROWSPEC = "BPClassRowId,BPClassCode,BPClassName,BPClassPinyin,BPClassFirstPinyin,BPClassDesc,UpdateDate,UpdateUser,UseFlag,BPClassAlias")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc, alias, operuser, state, timescope, sortmethod) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s BPClassRowId=rowid
	s BPClassCode=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),2)
	s BPClassName=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),3)
	s BPClassPinyin=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),4)
	s BPClassFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),5)
	s BPClassDesc=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),6)
	s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),7)
	s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),8)
	s UseFlag=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),9)
	s BPClassAlias=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),10)
	d OutputRow
 }
 else
 {
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写 
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写 
	//默认按时间倒序排列
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.BPClassDictD(ID))
				q:ID=""
				s BPClassName= $lg($g(^CT.WDT.CDSS.BPClassDictD(ID)),3)		//名称
				s length=$l(BPClassName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
		}
		else
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.BPClassDictD(ID))
				q:ID=""
				s UpdateDate= $lg($g(^CT.WDT.CDSS.BPClassDictD(ID)),7)				//编辑时间
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
			s BPClassRowId=0
			for
			{
				s BPClassRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,BPClassRowId)) q:BPClassRowId=""
				s BPClassCode=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),2)
				continue:((code'="")&&($ZCONVERT(BPClassCode,"U")'[code))
				s BPClassName=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),3)
				s BPClassPinyin=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),4)
				s BPClassFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),5)
				s BPClassDesc=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),6)
				s starttime=$p(timescope,"^",1)
				s endtime=$p(timescope,"^",2)
				s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),7)
				continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
		        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
				s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),8)
				continue:((operuser'="")&&($ZCONVERT(UpdateUser,"U")'[operuser))
				s UseFlag=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),9)
				s:UseFlag="" UseFlag=0
				if (state="")
				{
					continue:(UseFlag="1")	
				}else
				{
					continue:(UseFlag'=state)
				}
				//s:UseFlag="" UseFlag=0
				//continue:((UseFlag'="")&&(UseFlag'=state))
				s BPClassAlias=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),10)
				continue:((alias'="")&&($ZCONVERT(BPClassAlias,"U")'[alias))	
				if (($ZCONVERT(BPClassName,"U")[desc)||($ZCONVERT(BPClassPinyin,"U")[desc)||($ZCONVERT(BPClassFirstPinyin,"U")[desc)||(desc="")) 
				{
					d OutputRow
				}
			}
	}
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(BPClassRowId,BPClassCode,BPClassName,BPClassPinyin,BPClassFirstPinyin,BPClassDesc,UpdateDate,UpdateUser,UseFlag,BPClassAlias)
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

/// Creator:zww
/// CreatDate:2021-11-09
/// Description:代码自动生成  
/// Input：
/// Return： code
/// Other:w ##class(web.CDSS.CMKB.BPClassDict).GetLastCode()
ClassMethod GetLastCode() As %String
{
  	s Code=""
  	//s LabSpecimenID=0
	s Code=$o(^CT.WDT.CDSS.BPClassDictD(""),-1)
	
	if (Code="")
	{
		s:Code="" Code="00001"
	}
	else
	{
		s Code=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(Code+1,5)	//补0
		//s Code="PE"_Code
	}
	q Code
}

/// Creator:赵文伟
/// CreatDate:2020-11-02
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.BPClassDict
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.BPClassDict).FormValidate("","014","测试1")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	
    q:(code="") ""
    q:(desc="") ""
    //s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	//s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s flagc=$d(^CT.WDT.CDSS.BPClassDictI("CodeIndex",code))
	
	s flagd=$d(^CT.WDT.CDSS.BPClassDictI("NameIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) 
		{ 
		s flag=1
		}  //返回重复标志
		else { s flag=0 } //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s idc=$o(^CT.WDT.CDSS.BPClassDictI("CodeIndex",code,0))
  		s idd=$o(^CT.WDT.CDSS.BPClassDictI("NameIndex",desc,0))
  		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
	}	
	
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.BPClassDict).ValidateAlias("","")
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
		
		//s Alias=" "_$ZCONVERT(Alias,"U") //别名转换成大写
	    s flagA="",flagN=""
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.BPClassDict"," "_$ZCONVERT(Alias,"U")))
	    s flagN=$d(^CT.WDT.CDSS.BPClassDictI("NameIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.BPClassDict"," "_$ZCONVERT(Alias,"U"),0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.BPClassDictI("NameIndex",Alias,0))  						//字典表的名称来校验别名重复
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
/// Table：CT.WDT.CDSS.BPClassDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.BPClassDict).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.BPClassDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.BPClassRowId,eobj.BPClassCode,eobj.BPClassName)
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		 s flagAlias=..ValidateAlias(eobj.BPClassRowId,eobj.BPClassName,eobj.BPClassAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.BPClassRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.BPClassDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.BPClassDict).%OpenId(eobj.BPClassRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.BPClassDict).%New() 
			s bobj.BPClassCode = obj.BPClassCode  
			s bobj.BPClassName = obj.BPClassName  
			s bobj.BPClassPinyin = obj.BPClassPinyin 
			s bobj.BPClassFirstPinyin = obj.BPClassFirstPinyin
			s bobj.BPClassDesc = obj.BPClassDesc  
			s bobj.UpdateUser = obj.UpdateUser  
			s bobj.UseFlag = obj.UseFlag 
			s bobj.UpdateDate = obj.UpdateDate
			s bobj.BPClassAlias = obj.BPClassAlias
		}
		
		s obj.BPClassCode = eobj.BPClassCode  
		s obj.BPClassName = eobj.BPClassName  
		s obj.BPClassPinyin = eobj.BPClassPinyin 
		s obj.BPClassFirstPinyin = eobj.BPClassFirstPinyin
		s obj.BPClassDesc = eobj.BPClassDesc  
		s obj.UpdateUser = eobj.UpdateUser  
		s obj.UseFlag = eobj.UseFlag 
		s obj.UpdateDate = eobj.UpdateDate       //创建时间日期
		s obj.BPClassAlias = eobj.BPClassAlias
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.BPClassRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BPClassDict","CT.WDT.CDSS.BPClassDict","输血品分类字典",id,eobj.BPClassName,"A",eobj)
			d:eobj.BPClassRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BPClassDict","CT.WDT.CDSS.BPClassDict","输血品分类字典",eobj.BPClassRowId,eobj.BPClassName,"U",eobj,bobj)
			
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.BPClassRowId="")&&(eobj.BPClassAlias'=""))||((eobj.BPClassRowId'="")&&(eobj.BPClassAlias'=bobj.BPClassAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.BPClassDict",id,eobj.BPClassAlias)
            }
            //同步修改识别词项目数据
			d:eobj.BPClassRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("输血史",eobj.BPClassName,bobj.BPClassName)
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("输血品分类字典","web.CDSS.CMKB.BPClassDict","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("输血品分类字典","web.CDSS.CMKB.BPClassDict","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2020-06-18
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.BPClassDict
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.BPClassDict).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.BPClassDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.BPClassDict).%New() 
	s bobj.BPClassCode = obj.BPClassCode  
	s bobj.BPClassName = obj.BPClassName  
	s bobj.BPClassPinyin = obj.BPClassPinyin 
	s bobj.BPClassFirstPinyin = obj.BPClassFirstPinyin
	s bobj.BPClassDesc = obj.BPClassDesc  
	s bobj.UpdateUser = obj.UpdateUser  
	s bobj.UseFlag = obj.UseFlag 
	s bobj.UpdateDate = obj.UpdateDate
	s bobj.BPClassAlias = obj.BPClassAlias
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
/// w ##class(web.CDSS.CMKB.BPClassDict).GetRefFlag("97")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0
    s count=0
    if ($d(^CT.WDT.CDSS.BloodProductDictI("BPClassDRIndex",id)))
    {
	    s BPDictID=0
	    for
	    {
	        s BPDictID=$o(^CT.WDT.CDSS.BloodProductDictI("BPClassDRIndex",id,BPDictID)) q:(BPDictID="")
            s BPName=$lg($g(^CT.WDT.CDSS.BloodProductDictD(BPDictID)),4)
            s count=count+1
            s flag=1
            if (count>3)
            {
	            s myInfo=myInfo_"..."
	            q
            }
            else
            {
	            s myInfo=myInfo_"<输血字典:"_BPName_">"
            }
            
	        
	    }
    }
 
 	//识别词项目引用接口
    s BPClassName=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(id)),3)
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("输血史",BPClassName)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr
	
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:丁亚男
/// CreatDate:2020-06-18
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.BPClassDict
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.BPClassDict).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	s obj=##class(CT.WDT.CDSS.BPClassDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.BPClassDict).%New() 
	s bobj.BPClassCode = obj.BPClassCode  
	s bobj.BPClassName = obj.BPClassName  
	s bobj.BPClassPinyin = obj.BPClassPinyin 
	s bobj.BPClassFirstPinyin = obj.BPClassFirstPinyin
	s bobj.BPClassDesc = obj.BPClassDesc  
	s bobj.UpdateUser = obj.UpdateUser  
	s bobj.UseFlag = obj.UseFlag 
	s bobj.UpdateDate = obj.UpdateDate
	s bobj.BPClassAlias = obj.BPClassAlias
	s sc=##class(CT.WDT.CDSS.BPClassDict).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BPClassDict","CT.WDT.CDSS.BPClassDict","输血品分类字典",id,bobj.BPClassName,"D",bobj)
		//同步删除别名通用表中数据 
		d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.BPClassDict",id)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("输血品分类字典","web.CDSS.CMKB.BPClassDict","DeleteData",bobj)
	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator：丁亚男
/// CreatDate: 2020-06-03
/// Description：查询 输血品 下拉框
/// Table：CT.WDT.CDSS.BPClassDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.BPClassDict","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "BPClassRowId:%String,BPClassName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
  s BPClassRowId=rowid
  s BPClassName=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),3)
  d OutputRowCmb
 }
 else
 {
	
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s:q'="" q=$ZCONVERT(q,"U") //转换成大写
  s BPClassRowId=""
  for{  
	  s BPClassRowId=$o(^CT.WDT.CDSS.BPClassDictD(BPClassRowId),-1) q:BPClassRowId=""  
	  s BPClassName=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),3)
	  s UseFlag=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),9)
	  //continue:(UseFlag'=0)
	  s BPClassPinyin=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),4)
	  s BPClassFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),5) 
	  if (((($ZCONVERT(BPClassName,"U")[desc)||(BPClassPinyin[desc)||(BPClassFirstPinyin[desc))&(($ZCONVERT(BPClassName,"U")[q)||(BPClassPinyin[q)||(BPClassFirstPinyin[q)))&(UseFlag=2)) {
	  	d OutputRowCmb
	  }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(BPClassRowId,BPClassName)
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
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:赵文伟
/// CreatDate:2021-10-25
/// Description:导出输血品分类字典数据【暂不用】
/// Table: CT.WDT.CDSS.BPClassDict
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.BPClassDict).ExportData()
ClassMethod ExportData() As %String
{
	s sum=0
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"输血品分类字典数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.WriteLine("输血品分类编码,输血品分类名称,输血品分类拼音,拼音首拼,别名,输血品分类说明,创建时间,创建人员,使用标识")
	s BPClassRowId=""
	for 
	{
		s BPClassRowId=$o(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)) 
		q:BPClassRowId=""	
		s BPClassCode=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),2)
		s BPClassName=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),3)
		s BPClassPinyin=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),4)
		s BPClassFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),5)
		s BPClassDesc=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),6)
		s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),7)
		s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),8)
		s UseFlag=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),9)
		s BPClassAlias=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),10)
		
		/*
	 	//替换双引号
		s TreatCode=$replace(TreatCode,"""","”")
		s TreatDesc=$replace(TreatDesc,"""","”")
		s UpdateUser=$replace(UpdateUser,"""","”")
		s UpdateDate=$replace(UpdateDate,"""","”")
		s Remarks=$replace(Remarks,"""","”")
		*/
		s str=BPClassCode_","_BPClassName_","_BPClassPinyin_","_BPClassFirstPinyin_","_BPClassAlias_","_BPClassDesc_","_UpdateDate_","_UpdateUser_","_UseFlag
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
/// Description：导出输血品分类字典表数据txt
/// Other:w ##class(web.CDSS.CMKB.BPClassDict).ExportBPClassTXTData("","红细胞","","","","","")
ClassMethod ExportBPClassTXTData(code, desc, alias, operuser, state, starttime, endtime) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"输血品分类字典数据.txt"		
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
	w "输血品分类编码	输血品分类名称	输血品分类拼音	拼音首拼	别名	输血品分类说明	创建时间	创建人员	使用标识"
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写 
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s BPClassRowId=""
	for
	{ 
		s BPClassRowId=$o(^CT.WDT.CDSS.BPClassDictD(BPClassRowId),-1)  q:BPClassRowId="" 	
		s BPClassCode=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),2)
		continue:((code'="")&&($ZCONVERT(BPClassCode,"U")'[code))
		s BPClassName=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),3)
		s BPClassPinyin=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),4)
		s BPClassFirstPinyin=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),5)
		s BPClassDesc=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),6)
		
		s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),7)
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
		continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
		s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),8)
		continue:((operuser'="")&&($ZCONVERT(UpdateUser,"U")'[operuser))
		s UseFlag=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),9)
		s:UseFlag="" UseFlag=0
		continue:(state'="")&&(UseFlag'=state)
		s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核","":"编辑中")
		s BPClassAlias=$LISTGET($G(^CT.WDT.CDSS.BPClassDictD(BPClassRowId)),10)
		continue:((alias'="")&&($ZCONVERT(BPClassAlias,"U")'[alias))	
		if (($ZCONVERT(BPClassName,"U")[desc)||($ZCONVERT(BPClassPinyin,"U")[desc)||($ZCONVERT(BPClassFirstPinyin,"U")[desc)||(desc="")) 
		{
			
			w !,BPClassCode_"	"_BPClassName_"	"_BPClassPinyin_"	"_BPClassFirstPinyin_"	"_BPClassAlias_"	"_BPClassDesc_"	"_UpdateDate_"	"_UpdateUser_"	"_UseFlag
		}	
	}
	c file
	q fileName
}

/// Creator：赵文伟
/// CreatDate:2021-10-26
/// Input:RowId  Operation 操作(操作状态改变)
/// Return:
/// Other:w ##class(web.CDSS.CMKB.BPClassDict).ChangeStatus("","")
ClassMethod ChangeStatus(RowId, Operation)
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.BPClassDict).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.BPClassDict).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.BPClassDict).%New()
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
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BPClassDict","CT.WDT.CDSS.BPClassDict","输血品分类字典",RowId,obj.BPClassName_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-26
/// Description: 批量通过
/// Table: CT.WDT.CDSS.BPClassDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.BPClassDict).ChangeStatusPass("")
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
/// CreatDate: 2021-10-25
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.BPClassDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.BPClassDict).ChangeStatusBack("")
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

/// Creator:zhaowenwei
/// CreatDate:2022-01-19
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.BPClassDict
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.BPClassDict","GetAliasList","")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s BPClassAlias = $lg($g(^CT.WDT.CDSS.BPClassDictD(id)),10)
		s Len=$Length(BPClassAlias,",")
		for i=1:1:Len{
			s Desc=$p(BPClassAlias,",",i)
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
/// Table: CT.WDT.CDSS.BPClassDict
/// Other: w ##class(web.CDSS.CMKB.BPClassDict).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.BPClassDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.BPClassDictD(RowId)),10)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.BPClassDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.BPClassDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.BPClassDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.BPClassDictD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.BPClassDictD(RowId)),9)       
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
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.BPClassDict","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.BPClassDict",RowId,LogID),-1) q:LogID=""
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
/// CreatDate: 2023-01-17
/// Description：修正数据保存方法
/// Table：CT.WDT.CDSS.BPClassDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.BPClassDict).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.BPClassDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.BPClassRowId,eobj.BPClassCode,eobj.BPClassName)
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.BPClassRowId,eobj.BPClassName,eobj.BPClassAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.BPClassRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.BPClassDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.BPClassDict).%OpenId(eobj.BPClassRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.BPClassDict).%New() 
			s bobj.BPClassCode = obj.BPClassCode  
			s bobj.BPClassName = obj.BPClassName 
			s bobj.UpdateUser = obj.UpdateUser 
			s bobj.UpdateDate = obj.UpdateDate
			s bobj.BPClassAlias = obj.BPClassAlias
		}
		
		s obj.BPClassCode = eobj.BPClassCode  
		s obj.BPClassName = eobj.BPClassName 
		s eobj.UpdateUser = $g(%session.Data("LOGON.USERNAME")) 
		s obj.UpdateUser = eobj.UpdateUser  
		s eobj.UpdateDate=$zdt($h,3)
		s obj.UpdateDate = eobj.UpdateDate       //创建时间日期
		s obj.BPClassAlias = eobj.BPClassAlias
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.BPClassRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BPClassDict","CT.WDT.CDSS.BPClassDict","输血品分类字典",id,eobj.BPClassName,"A",eobj)
			d:eobj.BPClassRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BPClassDict","CT.WDT.CDSS.BPClassDict","输血品分类字典",eobj.BPClassRowId,eobj.BPClassName,"U",eobj,bobj)
			
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            if ((eobj.BPClassRowId="")&&(eobj.BPClassAlias'=""))||((eobj.BPClassRowId'="")&&(eobj.BPClassAlias'=bobj.BPClassAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.BPClassDict",id,eobj.BPClassAlias)
            }
            //同步修改识别词项目数据
			d:eobj.BPClassRowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("输血史",eobj.BPClassName,bobj.BPClassName)
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("输血品分类字典","web.CDSS.CMKB.BPClassDict","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("输血品分类字典","web.CDSS.CMKB.BPClassDict","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

}
