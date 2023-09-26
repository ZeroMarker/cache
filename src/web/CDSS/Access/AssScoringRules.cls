/// Creator:李欣
/// CreatDate:2018-05-10
/// Table：CT.WDT.CDSS.AssScoringRules
Class web.CDSS.Access.AssScoringRules Extends %RegisteredObject
{

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：查询评估表注册字段表内容
/// Table：CT.WDT.CDSS.AssScoringRules
/// Input：base 评估表注册表id
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Access.AssScoringRules","GetList","")
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
			s MKBASRChild = $O(^CT.WDT.CDSS.AssBaseD(base,"ChildRules",MKBASRChild))
			q:MKBASRChild=""
			
			s MKBASRRowId = base_"||"_MKBASRChild
			s MKBASRCode = $LG($G(^CT.WDT.CDSS.AssBaseD(base,"ChildRules",MKBASRChild)),2)
			s MKBASRDesc = $LG($G(^CT.WDT.CDSS.AssBaseD(base,"ChildRules",MKBASRChild)),3)
			s MKBASRMinValue = $LG($G(^CT.WDT.CDSS.AssBaseD(base,"ChildRules",MKBASRChild)),4)
			s MKBASRMaxValue = $LG($G(^CT.WDT.CDSS.AssBaseD(base,"ChildRules",MKBASRChild)),5)
			s MKBASRRank = $LG($G(^CT.WDT.CDSS.AssBaseD(base,"ChildRules",MKBASRChild)),6)
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
/// Table：CT.WDT.CDSS.AssScoringRules
/// Input：rowid, desc, type
/// Other: w ##class(web.CDSS.Access.AssScoringRules).GenerateCode(1)
ClassMethod GenerateCode(base)
{
	q:base="" ""
	if ($D(^CT.WDT.CDSS.AssScoringRulesI("CodeIndex",base))=0)
	{
		s code = "SR00000001"	
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
		s code = "SR"_code
	}
	q code
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据重复验证 重复返回1
/// Table：CT.WDT.CDSS.AssScoringRules
/// Input：id, base.desc
/// Other: w ##class(web.CDSS.Access.AssScoringRules).Validate()
ClassMethod Validate(id, base, desc)
{
	q:base="" 1
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagd=""
	s:desc'="" flagd=$d(^CT.WDT.CDSS.AssScoringRulesI("DescIndex",base," "_desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""
		s:desc'="" idd=base_"||"_$o(^CT.WDT.CDSS.AssScoringRulesI("DescIndex",base," "_desc,0))
		if ((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.AssScoringRules
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.Access.AssScoringRules).SaveEntity()
ClassMethod SaveEntity(str) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.Access.AssScoringRules).%New()
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
				s obj=##class(CT.WDT.CDSS.AssScoringRules).%New(eobj.MKBASRParRef)
			}
			else   //如果RowId已赋值则修改
			{
				s obj=##class(CT.WDT.CDSS.AssScoringRules).%OpenId(eobj.MKBASRRowId)
				s bobj=##class(web.CDSSEntity.Access.AssScoringRules).%New()
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
				d:eobj.MKBASRRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssScoringRules","CT.WDT.CDSS.AssScoringRules","评估表注册评分等级信息",id,eobj.MKBASRDesc,"A",eobj)
				d:eobj.MKBASRRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssScoringRules","CT.WDT.CDSS.AssScoringRules","评估表注册评分等级信息",eobj.MKBASRRowId,eobj.MKBASRRank,"U",eobj,bobj)
				s result = "{success:'true',id:'"_id_"'}"    
				//同步关联结果
				d ##class(web.CDSS.Access.AssScoringRules).SaveConData(id, eobj.MKBASRRank)
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
				;s errortip = $SYSTEM.Status.GetErrorText(sc)
				//s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("评估表注册评分等级信息","web.CDSS.Access.AssScoringRules","SaveEntity",eobj)
				//s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")   
			}
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
		//s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识点映射注册字段","web.CDSS.Access.AssScoringRules","SaveEntity","")
		//s ^ERRORLOGINFO(logid)="对象不存在！"   
	} 
	q result
}

/// Creator：李欣
/// CreatDate: 2018-05-10
/// Description：数据保存测试方法
/// Table：CT.WDT.CDSS.AssScoringRules
/// Input：
/// Return:
/// Other: w ##class(web.CDSS.Access.AssScoringRules).SaveTest()
ClassMethod SaveTest()
{
	s eobj = ##class(web.CDSSEntity.Access.AssScoringRules).%New()
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
/// Table：CT.WDT.CDSS.AssScoringRules
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.CDSS.Access.AssScoringRules).DeleteData("2||1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if ($D(^CT.WDT.CDSS.AssBaseD($P(id,"||",1),"ChildRules",$P(id,"||",2)))=0)
	{
		s result = "{success:'false',info:'输入的id不存在'}"
		q result	
	}
	s eobj = ##class(web.CDSSEntity.Access.AssScoringRules).%New()
	s obj = ##class(CT.WDT.CDSS.AssScoringRules).%OpenId(id)
	
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
	
	s sc=##class(CT.WDT.CDSS.AssScoringRules).%DeleteId(id)
	if $$$ISOK(sc)
	{
		d eobj.%Close()
		Tcommit
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssScoringRules","CT.WDT.CDSS.AssScoringRules","评估表注册评分等级信息",id,eobj.MKBASRDesc,"D",eobj)
		s result="{success:'true',info:'删除成功！'}"
	}
	else
	{
		Tro
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
    q result
}

/// Creator：Xuwenhu
/// CreatDate: 2022-03-02
/// Description：查询评估表注册字段表内容
/// Table：CT.WDT.CDSS.AssScoringRules
/// Input：base 评估表注册表id
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Access.AssScoringRules","GetDataForCmb","肩锁关节脱位Rockwood分型")
Query GetDataForCmb(baseDesc As %String) As %Query(ROWSPEC = "MKBASRRowId,MKBASRCode,MKBASRDesc,MKBASRRank")
{
}

ClassMethod GetDataForCmbExecute(ByRef qHandle As %Binary, baseDesc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (baseDesc'="")
	{
		s BaseID=$o(^CT.WDT.CDSS.AssBaseI("DescIndex"," "_$ZCONVERT(baseDesc,"U"),0))
		s MKBASRChild = 0
		for
		{
			s MKBASRChild = $o(^CT.WDT.CDSS.AssBaseD(BaseID,"ChildRules",MKBASRChild))
			q:MKBASRChild=""
			s MKBASRRowId = BaseID_"||"_MKBASRChild
			s MKBASRCode = $LG($G(^CT.WDT.CDSS.AssBaseD(BaseID,"ChildRules",MKBASRChild)),2)
			s MKBASRDesc = $LG($G(^CT.WDT.CDSS.AssBaseD(BaseID,"ChildRules",MKBASRChild)),3)
			s MKBASRRank = $LG($G(^CT.WDT.CDSS.AssBaseD(BaseID,"ChildRules",MKBASRChild)),6)
			d OutputRow
		}	
		
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBASRRowId,MKBASRCode,MKBASRDesc,MKBASRRank)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmbExecute ]
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

/// Creator：Xuwenhu
/// CreatDate: 2022-03-02
/// Description：根据评估结论字典名称 查询评估表注册字段表内容
/// Table：CT.WDT.CDSS.AssScoringRules
/// Input：resultDesc 评估结论字典名称
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Access.AssScoringRules","GetDataForCmbResult","mRS评分")
Query GetDataForCmbResult(resultDesc As %String) As %Query(ROWSPEC = "MKBASRRowId,MKBASRRank")
{
}

ClassMethod GetDataForCmbResultExecute(ByRef qHandle As %Binary, resultDesc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

    s ResultDR=0
	for
	{
	    s ResultDR = $o(^CT.WDT.CDSS.AssessResultDictI("DescIndex", " "_$ZCONVERT(resultDesc,"U"), ResultDR))
	    q:ResultDR=""
	    s Rowid=0
		for
		{
			s Rowid=$o(^CT.WDT.CDSS.AssConResultI("ResultDRIndex",ResultDR,Rowid))
			q:Rowid=""
			s AssDR=$lg($g(^CT.WDT.CDSS.AssConResultD(Rowid)),2)
			s ARDesc=$lg($g(^CT.WDT.CDSS.AssessResultDictD(AssDR)),2)
			s MKBASRChild = 0
			for
			{
				s MKBASRChild = $o(^CT.WDT.CDSS.AssBaseD(AssDR,"ChildRules",MKBASRChild))
				q:MKBASRChild=""
				s MKBASRRowId = AssDR_"||"_MKBASRChild
				s MKBASRRankA = $LG($G(^CT.WDT.CDSS.AssBaseD(AssDR,"ChildRules",MKBASRChild)),6)
				s MKBASRRankA = $p(MKBASRRankA,resultDesc_"：",2)
				s Len=$L(MKBASRRankA,"，")
			 	for i=1:1:Len
			 	{
				 	s MKBASRRank=$p(MKBASRRankA,"，",i)
				 	d OutputRow
				}
				
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBASRRowId,MKBASRRank)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmbResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmbResultExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmbResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmbResultExecute ]
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

/// Creator：Xuwenhu
/// CreatDate: 2023-1-11
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.AssessResultDict,CT.WDT.CDSS.AssConResult
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.CDSS.Access.AssScoringRules).SaveConData("6个月PFS：81%；12个月PFS：50%")
ClassMethod SaveConData(id As %String, str As %String) As %String
{
	for i=1:1:$l(str,"；")
	{
		s Res=$p(str,"；",i)		//6个月PFS：81%
		continue:Res=""
		s ResName=$p(Res,"：",1)	//6个月PFS
		continue:ResName=""
		for j=1:1:$l(ResName,"｜")
		{
			s ResN=$p(ResName,"｜",j)
			continue:ResN=""
			s AssResId=$o(^CT.WDT.CDSS.AssessResultDictI("DescIndex"," "_$ZCVT(ResN,"U"),0))
			if AssResId=""
			{
				s eobj=##class(web.CDSSEntity.CMKB.AssessResultDict).%New()
				s eobj.ARCode=$o(^CT.WDT.CDSS.AssessResultDictD(""),-1)+1
				s eobj.ARDesc=ResN
				s eobj.UseFlag="0"									//状态（0编辑中,1已弃用,2已审核）
				s eobj.UpdateUser="dhcc"							//编辑人员
				s eobj.UpdateDate=$ZDATETIME($H,3)					//编辑时间
				s eobj.Remarks=""									//备注
	            s eobj.AssessResultAlias=""							
	            s re1=##class(web.CDSS.CMKB.AssessResultDict).SaveData(eobj)
	            s AssResId=$p($p(re1,"id:'",2),"'",1)
			}
			s ConResId=$o(^CT.WDT.CDSS.AssConResultI("AssResIndex",$p(id,"||",1),AssResId,0))
			if ConResId=""
			{
				s acrobj=##class(web.CDSSEntity.Access.AssConResult).%New()
				s acrobj.AssDR=$p(id,"||",1)
				s acrobj.ResultDR=AssResId
				s re2=##class(web.CDSS.Access.AssConResult).SaveData(acrobj)
			}		
		}
	}
    q ""
}

/// 批量处理数据
/// w ##class(web.CDSS.Access.AssScoringRules).BatchDealData()
ClassMethod BatchDealData() As %String
{
	TS
	s base=0
	for
	{
		s base=$o(^CT.WDT.CDSS.AssBaseD(base))
		q:base=""
		
		s MKBASRChild = 0
		for
		{
			s MKBASRChild = $O(^CT.WDT.CDSS.AssBaseD(base,"ChildRules",MKBASRChild))
			q:MKBASRChild=""
			
			s MKBASRRowId = base_"||"_MKBASRChild
			s MKBASRRank = $LG($G(^CT.WDT.CDSS.AssBaseD(base,"ChildRules",MKBASRChild)),6)
			if MKBASRRank'=""
			{
				d ..SaveConData(MKBASRRowId,MKBASRRank) 
			}	
		}
	}
	q "success"
}

/// Creator：Xuwenhu 
/// CreatDate: 2022-10-28
/// Description：导入关联识别词
/// Table:User.MKBAssessmentBaseField
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.Access.AssScoringRules).SaveImportData("中国糖尿病风险评分表[next]4||8[next]请应进行口服葡萄糖耐量实验检查。[next]25[next]51[next]糖尿病风险评分：高危[next]糖尿病风险评分[next]")
ClassMethod SaveImportData(dataStr)
{
	s result=""
	s dataStr=$tr(dataStr," ","")
	s dataStr=##class(web.DHCBL.BDP.FunLib).EvalJSONB(dataStr)		
	
	s AssName=$p(dataStr,"[next]",1)		//评估表名
	s ID=$p(dataStr,"[next]",2)				//ID
	s Desc=$p(dataStr,"[next]",3) 			//描述
	s MinValue=$p(dataStr,"[next]",4) //最小值
	s MaxValue=$p(dataStr,"[next]",5)	//最大值
	s Rank=$p(dataStr,"[next]",6)			//等级
 	
	s obj=##class(CT.WDT.CDSS.AssScoringRules).%OpenId(ID)
	s obj.MKBASRMaxValue=MaxValue
	s obj.MKBASRMinValue=MinValue
	s obj.MKBASRRank=Rank
	s obj.MKBASRDesc=Desc
	d obj.%Save()
	d obj.%Close()
	q "true"
}

/// Creator：Xuwenhu 
/// CreatDate: 2023-04-14
/// Description：是否维护了分值
/// Table:User.MKBAssessmentBaseField
/// Input： 
/// Return：
/// w ##class(web.CDSS.Access.AssScoringRules).IsDefinedScore()
ClassMethod IsDefinedScore(BaseId As %String) As %String
{
	s flag=0
	if $d(^CT.WDT.CDSS.AssScoringRulesI("ParIndex",BaseId))
	{
		s flag=1	
	}
	q flag
}

}
