/// Creator:李欣
/// CreatDate:2018-05-10
/// Table：User.MKBKLMappingBaseField
Class web.DHCBL.MKB.MKBKLMappingBaseField Extends %RegisteredObject
{

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：查询知识点映射注册字段表内容
/// Table：User.MKBKLMappingBaseField
/// Input：base
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKLMappingBaseField","GetList","17")
Query GetList(base As %String) As %Query(ROWSPEC = "MKBKMBFRowId,MKBKMBFCode,MKBKMBFDesc,MKBKMBFType,MKBKMBFConfig,MKBKMBFSequence")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, base As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	s MKBKMBFSequence = 0
	for
	{
		s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence))
		q:MKBKMBFSequence=""
		s MKBKMBFChildSub=0
		for
		{
			s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence,MKBKMBFChildSub))
			q:MKBKMBFChildSub=""
			s MKBKMBFRowId = base_"||"_MKBKMBFChildSub
			s MKBKMBFCode = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),2)
			s MKBKMBFDesc = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),3)
			s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),4)
			s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),5)
			s MKBKMBFSequence = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),6)
			d OutputRow
		}
	}

 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBKMBFRowId,MKBKMBFCode,MKBKMBFDesc,MKBKMBFType,MKBKMBFConfig,MKBKMBFSequence)
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

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：自动生成代码
/// Table：User.MKBKLMappingBaseField
/// Input：rowid, desc, type
/// Other: w ##class(web.DHCBL.MKB.MKBKLMappingBaseField).GenerateCode()
ClassMethod GenerateCode(base)
{
	q:base="" ""
	if ($D(^User.MKBKLMappingBaseFieldI("CodeIndex",base))=0)
	{
		s code = "BF00000001"	
	}
	else
	{
		s pre = $O(^User.MKBKLMappingBaseFieldI("CodeIndex",base,""),-1)
		s pre = $E(pre,4,$L(pre))	
		s code = pre+1
		s codelen = $L(code)
		for i=codelen:1:7
		{
			s code = "0"_code	
		}
		s code = "BF"_code
	}
	q code
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据重复验证 重复返回1
/// Table：User.MKBKLMappingBaseField
/// Input：id, desc
/// Other: w ##class(web.DHCBL.MKB.MKBKLMappingBaseField).Validate()
ClassMethod Validate(id, base, desc)
{
	q:base="" 1
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagd=""
	s:desc'="" flagd=$d(^User.MKBKLMappingBaseFieldI("DescIndex",base," "_desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""
		s:desc'="" idd=base_"||"_$o(^User.MKBKLMappingBaseFieldI("DescIndex",base," "_desc,0))
		if ((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存方法
/// Table：User.MKBKLMappingBaseField
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.DHCBL.MKB.MKBKLMappingBaseField).SaveEntity()
ClassMethod SaveEntity(str) As %String
{
	q:str="" result="{success:'false',info:'传入的值为空'}"
	s eobj = ##class(web.Entity.MKB.MKBKLMappingBaseField).%New()
	s eobj.MKBKMBFParRef = $P(str,"&^",1)
	s eobj.MKBKMBFRowId = $P(str,"&^",2)
	s eobj.MKBKMBFCode = $P(str,"&^",3)
	s eobj.MKBKMBFDesc = $P(str,"&^",4)	
	s eobj.MKBKMBFType = $P(str,"&^",5)
	s eobj.MKBKMBFConfig = $P(str,"&^",6)
	s eobj.MKBKMBFSequence = $P(str,"&^",7)
	
	s result=""
	q:eobj.MKBKMBFParRef="" "{success:'false',info:'未选择父表！'}"
	if $IsObject(eobj)
	{ 
		s flag=..Validate(eobj.MKBKMBFRowId,eobj.MKBKMBFParRef,eobj.MKBKMBFDesc) 
		//s flag=0  
		if (flag=1)
		{
			s result = "{'success':'false','errorinfo':'列名重复,添加重复列失败！'}"
		}
		else
		{
			if (eobj.MKBKMBFRowId="")  //如果RowId未赋值则增加
			{ 
				s obj=##class(User.MKBKLMappingBaseField).%New(eobj.MKBKMBFParRef)
			}
			else   //如果RowId已赋值则修改
			{
				s obj=##class(User.MKBKLMappingBaseField).%OpenId(eobj.MKBKMBFRowId)
				s bobj=##class(web.Entity.MKB.MKBKLMappingBaseField).%New()
				s bobj.MKBKMBFRowId = obj.%Id()
				s bobj.MKBKMBFParRef=obj.ParRef.%Id()
				s bobj.MKBKMBFCode = obj.MKBKMBFCode
				s bobj.MKBKMBFDesc = obj.MKBKMBFDesc
				s bobj.MKBKMBFType = obj.MKBKMBFType
				s bobj.MKBKMBFConfig = obj.MKBKMBFConfig
				s bobj.MKBKMBFSequence = obj.MKBKMBFSequence
			}
			if (eobj.MKBKMBFCode="")
			{
				s obj.MKBKMBFCode = ..GenerateCode(eobj.MKBKMBFParRef)	
			}
			else
			{
				s obj.MKBKMBFCode = eobj.MKBKMBFCode
			}
			d obj.ParRefSetObjectId(eobj.MKBKMBFParRef)
			s obj.MKBKMBFDesc = eobj.MKBKMBFDesc
			s obj.MKBKMBFType = eobj.MKBKMBFType
			s obj.MKBKMBFConfig = eobj.MKBKMBFConfig
			s obj.MKBKMBFSequence = eobj.MKBKMBFSequence
			
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			s id=""
			If $$$ISOK(sc)
			{
				tc
				//保存日志
				s id = obj.%Id()
				d:eobj.MKBKMBFRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingBaseField","User.MKBKLMappingBaseField","知识点映射注册字段信息",id,eobj.MKBKMBFDesc,"A",eobj)
				d:eobj.MKBKMBFRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingBaseField","User.MKBKLMappingBaseField","知识点映射注册字段信息",eobj.MKBKMBFRowId,eobj.MKBKMBFDesc,"U",eobj,bobj)
				s result = "{success:'true',id:'"_id_"'}"    
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
				;s errortip = $SYSTEM.Status.GetErrorText(sc)
				//s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识点映射注册字段","web.DHCBL.MKB.MKBKMBMappingBaseField","SaveEntity",eobj)
				//s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")   
			}
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
		
	} 
	q result
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存测试方法
/// Table：User.MKBKLMappingBase
/// Input：
/// Return:
/// Other: w ##class(web.DHCBL.MKB.MKBKLMappingBaseField).SaveTest()
ClassMethod SaveTest()
{
	s eobj = ##class(web.Entity.MKB.MKBKLMappingBaseField).%New()
	s eobj.MKBKMBFRowId = ""
	s eobj.MKBKMBFParRef = 9
	s eobj.MKBKMBFCode = ..GenerateCode(eobj.MKBKMBFParRef)
	s eobj.MKBKMBFDesc = "列1"
	s eobj.MKBKMBFConfig = "1&%2"
	s eobj.MKBKMBFSequence = 1
	s eobj.MKBKMBFType = "C" 
	s result = ..SaveEntity(eobj)
	q result
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存方法
/// Table：User.MKBKLMappingBaseField
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.DHCBL.MKB.MKBKLMappingBaseField).DeleteData("7||827")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if ($D(^User.MKBKLMappingBaseD($P(id,"||",1),"ChildField",$P(id,"||",2)))=0)
	{
		s result = "{success:'false',info:'输入的id不存在'}"
		q result	
	}
	s eobj = ##class(web.Entity.MKB.MKBKLMappingBaseField).%New()
	s obj = ##class(User.MKBKLMappingBaseField).%OpenId(id)
	
	s eobj.MKBKMBFRowId = id
	s eobj.MKBKMBFParRef = obj.ParRef
	s eobj.MKBKMBFCode = obj.MKBKMBFCode
	s eobj.MKBKMBFDesc = obj.MKBKMBFDesc
	s eobj.MKBKMBFConfig = obj.MKBKMBFConfig
	s eobj.MKBKMBFSequence = obj.MKBKMBFSequence
	s eobj.MKBKMBFType = obj.MKBKMBFType
	
	d obj.%Close()
	k obj
	
	Tstart
	
	
	
	s rc=""
	s KMDRowId = 0
	for
	{
		s KMDRowId = $O(^User.MKBKLMappingDetailI("FieldDrIndex",id,KMDRowId))
		q:KMDRowId=""
		
		s cobj = ##class(web.Entity.MKB.MKBKLMappingDetail).%New()
		s cbj = ##class(User.MKBKLMappingDetail).%OpenId(KMDRowId)
		
		s cobj.MKBKMDKMBaseDr=cbj.MKBKMDKMBaseDr.%Id()
		s cobj.MKBKMDKMBaseFieldDr = cbj.MKBKMDKMBaseFieldDr.%Id()
		s cobj.MKBKMDRowNum = cbj.MKBKMDRowNum
		s cobj.MKBKMDValue = cbj.MKBKMDValue
		s cobj.MKBKMDRowId = KMDRowId
		
		s scc = ##class(User.MKBKLMappingDetail).%DeleteId(KMDRowId)
		
		if $$$ERROR(scc)
		{
			s rc = rc_"1"	
		}
		else
		{
			s rc = rc_"0"	
		}

		q:rc["1"
		
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingDetail","User.MKBKLMappingDetail","知识点映射管理",KMDRowId,cobj.MKBKMDValue,"D",cobj)
	}	
	
	s sc=##class(User.MKBKLMappingBaseField).%DeleteId(id)
	
	if ($$$ISOK(sc)&&(rc'["1"))
	{
		d eobj.%Close()
		k ^TMP("MKB","MKBKLMappingDetail",id)
		Tcommit
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_KLMappingBaseField","User.MKBKLMappingBaseField","知识点映射注册字段信息",id,eobj.MKBKMBFDesc,"D",eobj)
		s result="{success:'true',info:'删除成功！'}"
	}
	else
	{
		Tro
		if $$$ERROR(sc)
		{
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息	
		}
		else
		{
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scc)_"'}"  //返回错误信息	
		}
		
	}
    q result
}

}
