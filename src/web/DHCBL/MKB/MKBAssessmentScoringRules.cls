/// Creator:李欣
/// CreatDate:2018-05-10
/// Table：User.MKBAssessmentScoringRules
Class web.DHCBL.MKB.MKBAssessmentScoringRules Extends %RegisteredObject
{

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：查询评估表注册字段表内容
/// Table：User.MKBAssessmentScoringRules
/// Input：base 评估表注册表id
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBAssessmentScoringRules","GetList","")
Query GetList(base As %String) As %Query(ROWSPEC = "MKBASRRowId,MKBASRCode,MKBASRDesc,MKBASRMinValue,MKBASRMaxValue,MKBASRRank")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, base As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (base'="")
	{
		s MKBASRChild = 0
		for
		{
			s MKBASRChild = $O(^User.MKBAssessmentBaseD(base,"ChildRules",MKBASRChild))
			q:MKBASRChild=""
			
			s MKBASRRowId = base_"||"_MKBASRChild
			s MKBASRCode = $LG($G(^User.MKBAssessmentBaseD(base,"ChildRules",MKBASRChild)),2)
			s MKBASRDesc = $LG($G(^User.MKBAssessmentBaseD(base,"ChildRules",MKBASRChild)),3)
			s MKBASRMinValue = $LG($G(^User.MKBAssessmentBaseD(base,"ChildRules",MKBASRChild)),4)
			s MKBASRMaxValue = $LG($G(^User.MKBAssessmentBaseD(base,"ChildRules",MKBASRChild)),5)
			s MKBASRRank = $LG($G(^User.MKBAssessmentBaseD(base,"ChildRules",MKBASRChild)),6)
			d OutputRow
		}	
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBASRRowId,MKBASRCode,MKBASRDesc,MKBASRMinValue,MKBASRMaxValue,MKBASRRank)
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
/// Table：User.MKBAssessmentScoringRules
/// Input：rowid, desc, type
/// Other: w ##class(web.DHCBL.MKB.MKBAssessmentScoringRules).GenerateCode(1)
ClassMethod GenerateCode(base)
{
	q:base="" ""
	if ($D(^User.MKBAssessmentScoringRulesI("CodeIndex",base))=0)
	{
		s code = "SR00000001"	
	}
	else
	{
		s pre = $O(^User.MKBAssessmentBaseFieldI("CodeIndex",base,""),-1)
		s pre = $E(pre,"3",$L(pre))	
		s code = pre+1
		s codelen = $L(code)
		for i=codelen:1:7
		{
			s code = "0"_code	
		}
		s code = "SR"_code
	}
	q code
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据重复验证 重复返回1
/// Table：User.MKBAssessmentScoringRules
/// Input：id, base.desc
/// Other: w ##class(web.DHCBL.MKB.MKBAssessmentScoringRules).Validate()
ClassMethod Validate(id, base, desc)
{
	q:base="" 1
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagd=""
	s:desc'="" flagd=$d(^User.MKBAssessmentScoringRulesI("DescIndex",base," "_desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""
		s:desc'="" idd=base_"||"_$o(^User.MKBAssessmentScoringRulesI("DescIndex",base," "_desc,0))
		if ((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存方法
/// Table：User.KBAssessmentScoringRules
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.DHCBL.MKB.MKBAssessmentScoringRules).SaveEntity()
ClassMethod SaveEntity(str) As %String
{
	s result=""
	s eobj = ##class(web.Entity.MKB.MKBAssessmentScoringRules).%New()
	s eobj.MKBASRParRef = $P(str,"&^",1)
	s eobj.MKBASRRowId = $P(str,"&^",2)
	s eobj.MKBASRCode= $P(str,"&^",3)
	s eobj.MKBASRDesc= $P(str,"&^",4)
	s eobj.MKBASRMinValue= $P(str,"&^",5)
	s eobj.MKBASRMaxValue= $P(str,"&^",6)
	s eobj.MKBASRRank= $P(str,"&^",7)
	q:eobj.MKBASRParRef="" "{success:'false',info:'为选择父表！'}"
	if $IsObject(eobj)
	{ 
		s flag=..Validate(eobj.MKBASRRowId,eobj.MKBASRParRef,eobj.MKBASRDesc)   
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.MKBASRRowId="")  //如果RowId未赋值则增加
			{ 
				s obj=##class(User.MKBAssessmentScoringRules).%New(eobj.MKBASRParRef)
			}
			else   //如果RowId已赋值则修改
			{
				s obj=##class(User.MKBAssessmentScoringRules).%OpenId(eobj.MKBASRRowId)
				s bobj=##class(web.Entity.MKB.MKBAssessmentScoringRules).%New()
				s bobj.MKBASRRowId = obj.%Id()
				s bobj.MKBASRParRef=obj.MKBASRParRef.%Id()
				s bobj.MKBASRCode = obj.MKBASRCode
				s bobj.MKBASRDesc = obj.MKBASRDesc
				s bobj.MKBASRMinValue = obj.MKBASRMinValue
				s bobj.MKBASRMaxValue = obj.MKBASRMaxValue
				s bobj.MKBASRRank = obj.MKBASRRank
			}
			if (eobj.MKBASRCode="")
			{
				s obj.MKBASRCode = ..GenerateCode(eobj.MKBASRParRef)	
			}
			else
			{
				s obj.MKBASRCode = eobj.MKBASRCode
			}
			d obj.MKBASRParRefSetObjectId(eobj.MKBASRParRef)
			s obj.MKBASRDesc = eobj.MKBASRDesc
			s obj.MKBASRMinValue = eobj.MKBASRMinValue
			s obj.MKBASRMaxValue = eobj.MKBASRMaxValue
			s obj.MKBASRRank = eobj.MKBASRRank
			
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			s id=""
			If $$$ISOK(sc)
			{
				tc
				//保存日志
				s id = obj.%Id()
				d:eobj.MKBASRRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_AssessmentScoringRules","User.MKBAssessmentScoringRules","评估表注册评分等级信息",id,eobj.MKBASRDesc,"A",eobj)
				d:eobj.MKBASRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_AssessmentScoringRules","User.MKBAssessmentScoringRules","评估表注册评分等级信息",eobj.MKBASRRowId,eobj.MKBASRRank,"U",eobj,bobj)
				s result = "{success:'true',id:'"_id_"'}"    
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
				;s errortip = $SYSTEM.Status.GetErrorText(sc)
				//s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("评估表注册评分等级信息","web.DHCBL.MKB.MKBKMBMappingBaseField","SaveEntity",eobj)
				//s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")   
			}
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
		//s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识点映射注册字段","web.DHCBL.MKB.MKBKMBMappingBaseField","SaveEntity","")
		//s ^ERRORLOGINFO(logid)="对象不存在！"   
	} 
	q result
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存测试方法
/// Table：User.MKBAssessmentScoringRules
/// Input：
/// Return:
/// Other: w ##class(web.DHCBL.MKB.MKBAssessmentScoringRules).SaveTest()
ClassMethod SaveTest()
{
	s eobj = ##class(web.Entity.MKB.MKBAssessmentScoringRules).%New()
	s eobj.MKBASRRowId = "2||1"
	s eobj.MKBASRParRef = 2
	s eobj.MKBASRCode = ..GenerateCode(eobj.MKBASRParRef)
	s eobj.MKBASRDesc = "列2"
	s eobj.MKBASRMinValue = "1"
	s eobj.MKBASRMaxValue = "2"
	s eobj.MKBASRRank = "C" 
	s result = ..SaveEntity(eobj)
	q result
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存方法
/// Table：User.MKBAssessmentScoringRules
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.DHCBL.MKB.MKBAssessmentScoringRules).DeleteData("2||1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if ($D(^User.MKBAssessmentBaseD($P(id,"||",1),"ChildRules",$P(id,"||",2)))=0)
	{
		s result = "{success:'false',info:'输入的id不存在'}"
		q result	
	}
	s eobj = ##class(web.Entity.MKB.MKBAssessmentScoringRules).%New()
	s obj = ##class(User.MKBAssessmentScoringRules).%OpenId(id)
	
	s eobj.MKBASRRowId = id
	s eobj.MKBASRParRef = obj.MKBASRParRef
	s eobj.MKBASRCode = obj.MKBASRCode
	s eobj.MKBASRDesc = obj.MKBASRDesc
	s eobj.MKBASRMinValue = obj.MKBASRMinValue
	s eobj.MKBASRMaxValue = obj.MKBASRMaxValue
	s eobj.MKBASRRank = obj.MKBASRRank
	
	d obj.%Close()
	k obj
	
	Tstart
	
	s sc=##class(User.MKBAssessmentScoringRules).%DeleteId(id)
	if $$$ISOK(sc)
	{
		d eobj.%Close()
		Tcommit
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_AssessmentScoringRules","User.MKBAssessmentScoringRules","评估表注册评分等级信息",id,eobj.MKBASRDesc,"D",eobj)
		s result="{success:'true',info:'删除成功！'}"
	}
	else
	{
		Tro
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
    q result
}

}
