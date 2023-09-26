/// Creator:李欣
/// CreatDate:2018-05-10
/// Table：CT.WDT.CDSS.AssBaseField
Class web.CDSS.Access.AssBaseField Extends %RegisteredObject
{

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：查询评估表注册字段表内容
/// Table：CT.WDT.CDSS.AssBaseField
/// Input：base 评估表注册表id
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Access.AssBaseField","GetList","")
Query GetList(base As %String) As %Query(ROWSPEC = "MKBABFRowId,MKBABFCode,MKBABFDesc,MKBABFType,MKBABFConfig,MKBABFSequence,MKBABFExclusion,MKBABFJumpOption")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, base As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (base'="")
	{
		s MKBABFSequence = ""
		for
		{
			s MKBABFSequence = $O(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",base,MKBABFSequence))
			q:MKBABFSequence=""
			s MKBABFChildSub = 0
			for
			{
				s MKBABFChildSub = $O(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",base,MKBABFSequence,MKBABFChildSub))
				q:MKBABFChildSub=""
				s MKBABFRowId = base_"||"_MKBABFChildSub
				s MKBABFCode = $LG($G(^CT.WDT.CDSS.AssBaseD(base,"ChildField",MKBABFChildSub)),2)
				s MKBABFDesc = $LG($G(^CT.WDT.CDSS.AssBaseD(base,"ChildField",MKBABFChildSub)),3)
				s MKBABFType = $LG($G(^CT.WDT.CDSS.AssBaseD(base,"ChildField",MKBABFChildSub)),4)
				s MKBABFConfig = $LG($G(^CT.WDT.CDSS.AssBaseD(base,"ChildField",MKBABFChildSub)),5)
				s MKBABFSequence = $LG($G(^CT.WDT.CDSS.AssBaseD(base,"ChildField",MKBABFChildSub)),6)
				s MKBABFExclusion =	$LG($G(^CT.WDT.CDSS.AssBaseD(base,"ChildField",MKBABFChildSub)),7)
				s MKBABFJumpOption = $LG($G(^CT.WDT.CDSS.AssBaseD(base,"ChildField",MKBABFChildSub)),8)
				d OutputRow	
			}
			
		}	
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBABFRowId,MKBABFCode,MKBABFDesc,MKBABFType,MKBABFConfig,MKBABFSequence,MKBABFExclusion,MKBABFJumpOption)
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
/// Table：CT.WDT.CDSS.AssBaseField
/// Input：rowid, desc, type
/// Other: w ##class(web.CDSS.Access.AssBaseField).GenerateCode(1)
ClassMethod GenerateCode(base)
{
	q:base="" ""
	if ($D(^CT.WDT.CDSS.AssBaseFieldI("CodeIndex",base))=0)
	{
		s code = "BF00000001"	
	}
	else
	{
		s pre = $O(^CT.WDT.CDSS.AssBaseFieldI("CodeIndex",base,""),-1)
		s pre = $E(pre,"3",$L(pre))	
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
/// Table：CT.WDT.CDSS.AssBaseField
/// Input：id, base.desc
/// Other: w ##class(web.CDSS.Access.AssBaseField).Validate()
ClassMethod Validate(id, base, desc)
{
	q:base="" 1
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagd=""
	s:desc'="" flagd=$d(^CT.WDT.CDSS.AssBaseFieldI("DescIndex",base," "_desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""
		s:desc'="" idd=base_"||"_$o(^CT.WDT.CDSS.AssBaseFieldI("DescIndex",base," "_desc,0))
		if ((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.AssBaseField
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.CDSS.Access.AssBaseField).SaveEntity("305&^&^&^多次评分&^M&^1[BDP]2[BDP]3[BDP]&^1&^&^")
ClassMethod SaveEntity(str) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.Access.AssBaseField).%New()
	s eobj.MKBABFParRef = $P(str,"&^",1)
	s eobj.MKBABFRowId = $P(str,"&^",2)
	s eobj.MKBABFCode = $P(str,"&^",3)
	s eobj.MKBABFDesc = $P(str,"&^",4)
	s eobj.MKBABFType = $P(str,"&^",5)
	s eobj.MKBABFConfig = $P(str,"&^",6)
	s eobj.MKBABFSequence = $P(str,"&^",7)
	s eobj.MKBABFExclusion=	$P(str,"&^",8)
	s eobj.MKBABFJumpOption=$P(str,"&^",9)
	q:eobj.MKBABFParRef="" "{success:'false',info:'为选择父表！'}"
	if $IsObject(eobj)
	{ 
		s flag=..Validate(eobj.MKBABFRowId,eobj.MKBABFParRef,eobj.MKBABFDesc)
		//s flag=0   
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.MKBABFRowId="")  //如果RowId未赋值则增加
			{ 
				s obj=##class(CT.WDT.CDSS.AssBaseField).%New(eobj.MKBABFParRef)
			}
			else   //如果RowId已赋值则修改
			{
				s obj=##class(CT.WDT.CDSS.AssBaseField).%OpenId(eobj.MKBABFRowId)
				s bobj=##class(web.CDSSEntity.Access.AssBaseField).%New()
				s bobj.MKBABFRowId = obj.%Id()
				s bobj.MKBABFParRef = obj.MKBABFParRef.%Id()
				s bobj.MKBABFCode = obj.MKBABFCode
				s bobj.MKBABFDesc = obj.MKBABFDesc
				s bobj.MKBABFType = obj.MKBABFType
				s bobj.MKBABFConfig = obj.MKBABFConfig
				s bobj.MKBABFSequence = obj.MKBABFSequence
				s bobj.MKBABFExclusion=obj.MKBABFExclusion
				s bobj.MKBABFJumpOption=obj.MKBABFJumpOption
			}
			if (eobj.MKBABFCode="")
			{
				s obj.MKBABFCode = ..GenerateCode(eobj.MKBABFParRef)	
			}
			else
			{
				s obj.MKBABFCode = eobj.MKBABFCode
			}
			d obj.MKBABFParRefSetObjectId(eobj.MKBABFParRef)
			s obj.MKBABFDesc = eobj.MKBABFDesc
			s obj.MKBABFType = eobj.MKBABFType
			s obj.MKBABFConfig = eobj.MKBABFConfig
			s obj.MKBABFSequence = eobj.MKBABFSequence
			s obj.MKBABFExclusion = eobj.MKBABFExclusion
			s obj.MKBABFJumpOption = eobj.MKBABFJumpOption
			
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			s id=""
			If $$$ISOK(sc)
			{
				tc
				//保存日志
				s id = obj.%Id()
				//d:eobj.MKBABFRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssBaseField","CT.WDT.CDSS.AssBaseField","评估表注册字段信息",id,eobj.MKBABFDesc,"A",eobj)
				//d:eobj.MKBABFRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssBaseField","CT.WDT.CDSS.AssBaseField","评估表注册字段信息",eobj.MKBABFRowId,eobj.MKBABFDesc,"U",eobj,bobj)
				s result = "{success:'true',id:'"_id_"'}"    
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
				;s errortip = $SYSTEM.Status.GetErrorText(sc)
				//s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识点映射注册字段","web.CDSS.Access.AssBaseField","SaveEntity",eobj)
				//s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")   
			}
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
		//s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识点映射注册字段","web.CDSS.Access.AssBaseField","SaveEntity","")
		//s ^ERRORLOGINFO(logid)="对象不存在！"   
	} 
	q result
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存测试方法
/// Table：CT.WDT.CDSS.AssBaseField
/// Input：
/// Return:
/// Other: w ##class(web.CDSS.Access.AssBaseField).SaveTest()
ClassMethod SaveTest()
{
	s eobj = ##class(web.CDSSEntity.Access.AssBaseField).%New()
	s eobj.MKBABFRowId = ""
	s eobj.MKBABFParRef = 2
	s eobj.MKBABFCode = ..GenerateCode(eobj.MKBABFParRef)
	s eobj.MKBABFDesc = "列1"
	s eobj.MKBABFConfig = "1&%2"
	s eobj.MKBABFSequence = 1
	s eobj.MKBABFType = "C" 
	s result = ..SaveEntity(eobj)
	q result
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.AssBaseField
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.CDSS.Access.AssBaseField).DeleteData("876||5619")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if ($D(^CT.WDT.CDSS.AssBaseD($P(id,"||",1),"ChildField",$P(id,"||",2)))=0)
	{
		s result = "{success:'false',info:'输入的id不存在'}"
		q result	
	}
	s eobj = ##class(web.CDSSEntity.Access.AssBaseField).%New()
	s obj = ##class(CT.WDT.CDSS.AssBaseField).%OpenId(id)
	
	s eobj.MKBABFRowId = id
	s eobj.MKBABFParRef = obj.MKBABFParRef
	s eobj.MKBABFCode = obj.MKBABFCode
	s eobj.MKBABFDesc = obj.MKBABFDesc
	s eobj.MKBABFConfig = obj.MKBABFConfig
	s eobj.MKBABFSequence = obj.MKBABFSequence
	s eobj.MKBABFType = obj.MKBABFType
	
	d obj.%Close()
	k obj
	
	Tstart
	
	s sc=##class(CT.WDT.CDSS.AssBaseField).%DeleteId(id)
	if $$$ISOK(sc)
	{
		d eobj.%Close()
		Tcommit
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssBaseField","CT.WDT.CDSS.AssBaseField","评估表注册字段信息",id,eobj.MKBABFDesc,"D",eobj)
		s result="{success:'true',info:'删除成功！'}"
	}
	else
	{
		Tro
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
    q result
}

/// w ##class(web.CDSS.Access.AssBaseField).ReDealData()
ClassMethod ReDealData() As %String
{
	s ID=812
	s Newcount=5389
	for
	{
		s ID=$o(^CT.WDT.CDSS.AssBaseD(ID))
		q:ID=""
		
		s FieldID=0
		for
		{
			s FieldID=$o(^CT.WDT.CDSS.AssBaseFieldI("ParIndex",ID,FieldID))
			q:FieldID=""
			
			s ^CT.WDT.CDSS.AssBaseD(ID,"ChildField",Newcount)=^CT.WDT.CDSS.AssBaseD(ID,"ChildField",FieldID)   
			k ^CT.WDT.CDSS.AssBaseD(ID,"ChildField",FieldID)
			s Newcount=Newcount+1
		}
	}
	q ""
}

}
