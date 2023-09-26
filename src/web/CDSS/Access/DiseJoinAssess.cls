/// Description：疾病关联评估量表
/// Table：CT.WDT.CDSS.DiseJoinAssess
Class web.CDSS.Access.DiseJoinAssess Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-03-22
/// Description:获得疾病关联评估量表内容
/// Table: CT.WDT.CDSS.DiseJoinAssess
/// Input: DiseID 疾病字典表RowId
/// Return:返回所有疾病关联评估量表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Access.DiseJoinAssess","GetList","348","9")
Query GetList(DiseID As %String, desc As %String) As %Query(ROWSPEC = "AssessmentRowId,RatingScaleDR,RatingScale,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, DiseID As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (DiseID="") q ""
 	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s AssessmentRowId = 0
	for
	{
		s AssessmentRowId = $o(^CT.WDT.CDSS.DiseJoinAssessI("DiseaseDRIndex",DiseID,AssessmentRowId)) q:AssessmentRowId=""
		s RatingScaleDR = $lg($g(^CT.WDT.CDSS.DiseJoinAssessD(AssessmentRowId)),3)
		s RatingScale=""
		s:RatingScaleDR'="" RatingScale=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(RatingScaleDR)),3)
		s Remarks = $lg($g(^CT.WDT.CDSS.DiseJoinAssessD(AssessmentRowId)),4)
		if (RatingScale[desc)
		{
			d OutputRow
		}	
	}
    //SET $NAMESPACE="DHC-APP"
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(AssessmentRowId,RatingScaleDR,RatingScale,Remarks)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 丁亚男
/// CreateDate:2021-03-22    
/// w ##class(web.CDSS.Access.DiseJoinAssess).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, DiseaseDR As %String, RatingScaleDR As %String) As %String
{
	if (DiseaseDR="")||(RatingScaleDR="") q "0"
	s flag="",flagc=""
	s flagc=$d(^CT.WDT.CDSS.DiseJoinAssessI("RatingScaleDRIndex",DiseaseDR,RatingScaleDR))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s idc=$o(^CT.WDT.CDSS.DiseJoinAssessI("RatingScaleDRIndex",DiseaseDR,RatingScaleDR,0))
		if (((idc'="")&(idc'=id)&(flagc>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Creator:丁亚男
/// CreatDate:2021-03-22
/// Description:保存疾病关联评估量表
/// Table: CT.WDT.CDSS.DiseJoinAssess
/// Input: eobj 疾病关联评估量表实体对象
/// Return:
/// others:w ##class(web.CDSS.Access.DiseJoinAssess).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Access.DiseJoinAssess)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.RowId,eobj.DiseaseDR,eobj.RatingScaleDR)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
			q result
		}
		
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.DiseJoinAssess).%New()
		}
		else  //如果RowId已赋值则修改
		{
			
			s obj=##class(CT.WDT.CDSS.DiseJoinAssess).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.Access.DiseJoinAssess).%New()
			s:obj.DiseaseDR'="" bobj.DiseaseDR = obj.DiseaseDR.%Id()
			s:obj.RatingScaleDR'="" bobj.RatingScaleDR = obj.RatingScaleDR.%Id()
			s bobj.Remarks = obj.Remarks
			
		}
		d:eobj.DiseaseDR'="" obj.DiseaseDRSetObjectId(eobj.DiseaseDR)
		d:eobj.RatingScaleDR'="" obj.RatingScaleDRSetObjectId(eobj.RatingScaleDR)
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
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJoinAssess","CT.WDT.CDSS.DiseJoinAssess","疾病关联评估量表",id,eobj.RatingScaleDR,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJoinAssess","CT.WDT.CDSS.DiseJoinAssess","疾病关联评估量表",eobj.RowId,eobj.RatingScaleDR,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联评估量表","web.CDSS.Access.DiseJoinAssess","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("疾病关联评估量表","web.CDSS.Access.DiseJoinAssess","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:丁亚男
/// CreatDate:2021-03-22
/// Description:删除疾病关联评估量表
/// Table: CT.WDT.CDSS.DiseJoinAssess
/// Input: id 
/// Return:
/// others:w ##class(web.CDSS.Access.DiseJoinAssess).DeleteData("4")
ClassMethod DeleteData(id)
{
	s result=""
	s obj=##class(CT.WDT.CDSS.DiseJoinAssess).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.Access.DiseJoinAssess).%New()
	s:obj.DiseaseDR'="" bobj.DiseaseDR = obj.DiseaseDR.%Id()
	s:obj.RatingScaleDR'="" bobj.RatingScaleDR = obj.RatingScaleDR.%Id()
	s bobj.Remarks = obj.Remarks
	s sc=##class(CT.WDT.CDSS.DiseJoinAssess).%DeleteId(id)
	Ts
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联评估量表","web.CDSS.Access.DiseJoinAssess","DeleteData",obj)
   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2021-03-22
/// Description:通过id获取疾病关联治疗方案内容
/// Table: CT.WDT.CDSS.DiseJoinAssess
/// Input: id 疾病关联治疗方案id
/// Return: 疾病关联治疗方案内容
/// others:w ##class(web.CDSS.Access.DiseJoinAssess).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	
	s eobj = ##class(web.CDSSEntity.Access.DiseJoinAssess).%New()
	s eobj.RowId = id
	s eobj.RatingScaleDR = $lg($g(^CT.WDT.CDSS.DiseJoinAssessD(id)),3)
	s eobj.Remarks = $lg($g(^CT.WDT.CDSS.DiseJoinAssessD(id)),4)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-03-22
/// Description:批处理数据，将存在描述表的评估表数据保存进评估量表
/// Table: CT.WDT.CDSS.DiseJoinAssess
/// Input: 
/// Return: 
/// others:w ##class(web.CDSS.Access.DiseJoinAssess).BatchDealData()
ClassMethod BatchDealData() As %String
{
	s str=""	
	
	s DescRowId = 0
	for
	{
		s DescRowId = $o(^User.DHCDSSDiseJoinDescD(DescRowId)) q:DescRowId=""
		s DiseaseDR = $lg($g(^User.DHCDSSDiseJoinDescD(DescRowId)),2)
		s DiseaseName=""
		s:DiseaseDR'="" DiseaseName=$lg($g(^User.DHCDSSDiseaseDictD(DiseaseDR)),3)
		
		s RatingScaleDRs = $lg($g(^User.DHCDSSDiseJoinDescD(DescRowId)),6)
		s RatingScaleDR=""
		if (RatingScaleDRs'="")
		{
			s RSlen=$l(RatingScaleDRs,",")
			for rsi=1:1:RSlen
			{
				s ScaleDR=$p(RatingScaleDRs,",",rsi)
				s RatingScale=""
				s:ScaleDR'="" RatingScale=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(ScaleDR)),3)
				if (ScaleDR'="")&(RatingScale'="")
				{
					s eobj = ##class(web.CDSSEntity.Access.DiseJoinAssess).%New()
					s eobj.DiseaseDR = DiseaseDR
					s eobj.RatingScaleDR = ScaleDR
					s result=..SaveData(eobj)
					if (result["true")||(result["已经存在")
					{
					}
					else
					{
						w !,DiseaseName_"-"_RatingScale_"没有导入成功！"
					}
				}
				
			}
		}
		
	}
		
	q "批处理完成"
}

/// Creator：阚延新	
/// CreatDate: 2021-03-26
/// Description：查询 疾病关联评估量表
/// Table:CT.WDT.CDSS.DiseJoinAssess 疾病关联评估量表
/// Input:id, code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Access.DiseJoinAssess","GetList1","","","")
Query GetList1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,DiseaseDR,RatingScaleDR,Remarks")
{
}

ClassMethod GetList1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$lg($g(^CT.WDT.CDSS.DiseaseDictD(code)),3)
	//s:desc'="" desc=$lg($g(^CT.WDT.CDSS.AssBaseD(desc)),3)
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s DiseaseDR= $lg($g(^CT.WDT.CDSS.DiseaseDictD($lg($g(^CT.WDT.CDSS.DiseJoinAssessD(ID)),2))),3)
		s RatingScaleDR= $lg($g(^CT.WDT.CDSS.AssBaseD($lg($g(^CT.WDT.CDSS.DiseJoinAssessD(ID)),3))),3)
		s Remarks=$lg($g(^CT.WDT.CDSS.DiseJoinAssessD(ID)),4)
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.DiseJoinAssessI("AssIndex",desc,ID))
			q:ID=""
            s DiseaseDR= $lg($g(^CT.WDT.CDSS.DiseaseDictD($lg($g(^CT.WDT.CDSS.DiseJoinAssessD(ID)),2))),3)
            s RatingScaleDesc=$lg($g(^CT.WDT.CDSS.DiseJoinAssessD(ID)),3)
			s RatingScaleDR= $lg($g(^CT.WDT.CDSS.AssBaseD(RatingScaleDesc)),3)
			s Remarks=$lg($g(^CT.WDT.CDSS.DiseJoinAssessD(ID)),4)
		    i (DiseaseDR[code)&(RatingScaleDesc=desc)
			{
				d OutputRow
			}	
		}
						
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,DiseaseDR,RatingScaleDR,Remarks)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetList1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetList1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetList1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetList1Execute ]
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

/// Creator:阚延新
/// CreatDate: 2021-03-26
/// Description：修改时打开的数据
/// Table:CT.WDT.CDSS.DiseJoinAssess 疾病关联评估量表
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.Access.DiseJoinAssess).NewOpenData("2")
ClassMethod NewOpenData(Id As %String) As %String
{
    s str="" 
    s eobj=##class(web.CDSSEntity.Access.DiseJoinAssess).%New()
    s eobj.RowId=Id
    s eobj.DiseaseDR=$lg($g(^CT.WDT.CDSS.DiseJoinAssessD(Id)),2)
    s eobj.RatingScaleDR=$lg($g(^CT.WDT.CDSS.DiseJoinAssessD(Id)),3)
    s str = eobj.JsonS()    
    d eobj.%Close()
    q str
}

/// Creator:阚延新
/// CreatDate: 2021-03-26
/// Description：根据ID删除
/// Table:CT.WDT.CDSS.DiseJoinAssess 疾病关联评估量表
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Others:w ##class(web.CDSS.Access.DiseJoinAssess).DeleteData("4")
ClassMethod DeleteData1(Id As %String) As %String
{
	s result=""
	Quit:Id="" "{success:'false',info:'删除失败,入参为空！'}"
	s obj=##class(CT.WDT.CDSS.DiseJoinAssess).%OpenId(Id)  
	s bobj=##class(web.CDSSEntity.Access.DiseJoinAssess).%New()
    s bobj.RowId =Id
    s bobj.DiseaseDR=obj.DiseaseDR.%Id()
    s bobj.RatingScaleDR=obj.RatingScaleDR.%Id()
   	d obj.%Close()
    k obj   
	TSTART
	s sc=##class(CT.WDT.CDSS.DiseJoinAssess).%DeleteId(Id)
	if ($$$ISOK(sc))
	{
		TCOMMIT
		s result="{success:'true',info:'删除成功！'}"  
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJoinAssess","CT.WDT.CDSS.DiseJoinAssess","疾病关联评估量表",Id,bobj.RowId,"D",bobj)
        d bobj.%Close() 
	}
	else
	{
		TROLLBACK
		s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
        s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联评估量表","web.CDSS.Access.DiseJoinAssess","DeleteData1")
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	Quit result
}

/// Creator:xuwenhu
/// CreatDate: 2021-04-27
/// Description：根据DiseaseDR获取疾病描述
/// Table:CT.WDT.CDSS.DiseaseDict 疾病字典表
/// Input：id-疾病表ID
/// Return:desc
/// Other: w ##class(web.CDSS.Access.DiseJoinAssess).GetDiseDesc("2")
ClassMethod GetDiseDesc(id As %String) As %String
{
    q:id="" ""
    s Desc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),3)
    q Desc
}

}
