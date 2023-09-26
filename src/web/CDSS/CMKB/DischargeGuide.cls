/// Description: 出院指导工具维护数据方法集合(增删改查)
/// Creator: 徐凯
/// Date: 2021-11-06
Class web.CDSS.CMKB.DischargeGuide Extends %RegisteredObject
{

/// Creator：胡宜良
/// CreatDate: 2021-11-23
/// Description：查询出院指导 
/// Table：CT_WDT_CDSS.DischargeGuide
/// Input:id,name
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DischargeGuide","GetList","","","","","","","","")
Query GetList(rowid As %String, name As %String, source As %String, state As %String, updateuser As %String, audituser As %String, starttime As %String, endtime As %String) As %Query(ROWSPEC = "ID,DGuideName,DGuideSource,DGuideState,UpdateUser,AuditUser,UpdateDate")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, name As %String, source As %String, state As %String, updateuser As %String, audituser As %String, starttime As %String, endtime As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
        //ID,DGuideName,DGuideSource,DGuideState,UpdateUser,AuditUser,UpdateDate
		s ID=rowid
		s DGuideName= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),2)       //出院指导名称
		s DGuideSource= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),3)       //来源
		s DGuideState= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),4)       //状态：4-待审核、3-已审核、2-已驳回、1-已弃用、0-编辑中
	    s DGuideState=$case(DGuideState,0:"编辑中",1:"已弃用",2:"已驳回",3:"已审核",4:"待审核",:"") 
	    s UpdateUser= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),5) 	//操作人
	    s UpdateDate= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),6)     //操作时间
	    s AuditUser= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),7)        //审核人
	    d OutputRow
	}
	else
	{
		s:name'="" name=$ZCONVERT(name,"U") //转换成大写
		s:source'="" source=$ZCONVERT(source,"U") //转换成大写
	    s:updateuser'="" updateuser=$ZCONVERT(updateuser,"U") //转换成大写
	    s:audituser'="" audituser=$ZCONVERT(audituser,"U") //转换成大写
		
		s ID=0
		
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
		k ^TempDataHandle($ZNAME,repid,$JOB,"DescShort")
		k ^TempDataHandle($ZNAME,repid,$JOB,"DescHandle")
		for 
		{
			s ID=$o(^CT.WDT.CDSS.DischargeGuideD(ID))
			q:ID=""
			s UpdateDate= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),6)				//操作时间
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",UpdateDate,ID)=ID
		}
 		s num=0
		//s UpdateDate=$o(^TempDataHandle("short",""),-1)
		s UpdateDate=""
		for
		{
			s UpdateDate=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",UpdateDate),-1)
			q:UpdateDate=""
			s DisID=0
			for
			{
				s DisID=$o(^CT.WDT.CDSS.DischargeGuideI("UpdateDateIndex",UpdateDate,DisID))
				q:DisID=""
				s num=num+1
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",num)=DisID
	    	}
		}
		if (name'="")
		{
			s DescID=0
			for 
			{
				s DescID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",DescID))
				q:DescID=""
				s ID=^TempDataHandle($ZNAME,repid,$JOB,"Handle",DescID)
				s DGuideName= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),2)		//出院指导名称
				s length=$l(DGuideName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"DescShort",length,ID)=ID
			}
			s num1=0
			s le=0
			for
			{
				s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"DescShort",le))
				q:le=""
				s ShortID=0
				for
				{
					s ShortID=$o(^TempDataHandle($ZNAME,repid,$JOB,"DescShort",le,ShortID))
					q:ShortID=""
					s num1=num1+1
					s ^TempDataHandle($ZNAME,repid,$JOB,"DescHandle",num1)=ShortID
				}
			}	
		}
	
		s Number=0
		for 
		{
			if (name'="")
			{
				s Number=$o(^TempDataHandle($ZNAME,repid,$JOB,"DescHandle",Number))
				q:Number=""
				s ID=^TempDataHandle($ZNAME,repid,$JOB,"DescHandle",Number)
			}
			else
			{
				s Number=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",Number))
				q:Number=""
				s ID=^TempDataHandle($ZNAME,repid,$JOB,"Handle",Number)
			}
	        // DGuideName, DGuideSource, DGuideState, UpdateUser, UpdateDate, AuditUser,
            //出院指导名称,//来源,//状态：4-待审核、3-已审核、2-已驳回、1-已弃用、0-编辑中,//编辑人,//操作时间,//审核人
			s DGuideName= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),2)       //出院指导名称
		    s DGuideSource= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),3)       //来源
		    //continue:((source'="")&&(DGuideSource'[source))
	   	 	continue:((source'="")&&($ZCONVERT(DGuideSource,"U")'[source))
	   	 	s DGuideState= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),4)        //状态：4-待审核、3-已审核、2-已驳回、1-已弃用、0-编辑中
	    	s DGuideState=$case(DGuideState,0:"编辑中",1:"已弃用",2:"已驳回",3:"已审核",4:"待审核",:"") 
	    	continue:((state="")&&(DGuideState="已弃用"))
	    	s UpdateUser= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),5) 	   //编辑人
	    	s UpdateDate= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),6)     //操作时间
	    	s AuditUser= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),7)        //审核人
			continue:((audituser'="")&&($ZCONVERT(AuditUser,"U")'[audituser))
		    if (($ZCONVERT(UpdateUser,"U")[updateuser)&($ZCONVERT(DGuideName,"U")[name)&($ZCONVERT(DGuideState,"U")[state))
			{
				if ((starttime'="")&&(endtime'=""))
				{
					if ($ZDH(UpdateDate,3)<=$zdh(endtime,3))&&($ZDH(UpdateDate,3)>=$zdh(starttime,3))
					{
						d OutputRow
					}
				}
				if ((starttime="")&&(endtime'=""))
				{
					if $ZDH(UpdateDate,3)<=$zdh(endtime,3)
					{
						d OutputRow
					}
				}
				if ((endtime="")&&(starttime'=""))
				{
					if $ZDH(UpdateDate,3)>=$zdh(starttime,3)
					{
						d OutputRow
					}
				}
				if ((endtime="")&&(starttime=""))
				{
					d OutputRow
				}	
			} 
			
		}
						
	}
			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    
    set Data=$lb(ID,DGuideName,DGuideSource,DGuideState,UpdateUser,AuditUser,UpdateDate)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	k ^TempDataHandle($ZNAME,repid,$JOB,"DescShort")
	k ^TempDataHandle($ZNAME,repid,$JOB,"DescHandle")
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

/// Creator:hyl
/// CreatDate:2020-12-14
/// Description:保存出院指导
/// Table: CT.WDT.CDSS.DischargeGuide
/// Input: eobj 出院指导表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// Other: d ##class(web.CDSS.CMKB.DischargeGuide).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.DischargeGuide) As %String
{
	//s $zt="ERROR"
	s result=""
    
	if $IsObject(eobj)
	{	 
		//s:eobj.Code="" eobj.Code=..getFactorCode()
		//s:eobj.UpdateDate="" eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
		//s:eobj.UpdateUser="" eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME")) //"dhcc" //
		
		s flag=..FormValidate(eobj.ID,eobj.DGuideName)  //调用重复验证
		
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.DischargeGuide).%New()
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.DischargeGuide).%OpenId(eobj.ID)
		    s bobj = ##class(web.CDSSEntity.CMKB.DischargeGuide).%New()
			s bobj.ID = eobj.ID
			s bobj.DGuideName = obj.DGuideName
			s bobj.DGuideSource = obj.DGuideSource
			s bobj.DGuideState = obj.DGuideState
			
			s bobj.UpdateUser = obj.UpdateUser
			s bobj.UpdateDate = obj.UpdateDate
			s bobj.AuditUser = obj.AuditUser	
		}
		    s obj.DGuideName = eobj.DGuideName //_"的出院指导"			
		    s obj.DGuideSource = eobj.DGuideSource	             	
		    s obj.DGuideState = eobj.DGuideState					
		    s obj.UpdateUser = $g(%session.Data("LOGON.USERNAME")) //"dhcc"
		    s obj.UpdateDate = $ZDATETIME($HOROLOG,3)	
		    s obj.AuditUser = eobj.AuditUser			


		    Ts
		    s sc=obj.%Save()
		    d obj.%Close()
		    If $$$ISOK(sc)
		    {
			Tc
			
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			
			//d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("DischargeGuide","CT.WDT.CDSS.DischargeGuide","出院指导",id,eobj.DGuideName_"-"_eobj.DGuideSource,"A",eobj)
			//d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("DischargeGuide","CT.WDT.CDSS.DischargeGuide","出院指导",id,eobj.DGuideName_"-"_eobj.DGuideSource,"U",eobj,bobj)
			
		    }
		    else
		    {
		   	Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("出院指导","CT.WDT.CDSS.DischargeGuide","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		    }	
	    }
	    else
	{   
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	    q result
ERROR
  s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("出院指导","web.CDSS.CMKB.DischargeGuide","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
  q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Function:用于实现数据校验功能的方法
/// Creator:胡宜良
/// CreateDate:2020-11-23    
/// w ##class(web.CDSS.CMKB.DischargeGuide).FormValidate("","测试")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, name As %String) As %String
{
	s flag="",flagc=""
	s:name'="" flagc=$d(^CT.WDT.CDSS.DischargeGuideI("NameIndex",name))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		
		
		s idc=""
		s:name'="" idc=$o(^CT.WDT.CDSS.DischargeGuideI("NameIndex",name,0))
		
		if (idc'="")&(idc'=id)&(flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
		
	}
	q flag
}

/// Creator:胡宜良
/// CreatDate:2021-11-17
/// Description:数据删除方法
/// Table:CT.WDT.CDSS.DischargeGuide
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.DischargeGuide).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
    
	s result=""
	//s DGuideName=""
	
	Quit:id="" result="{success:'false',info:'删除失败,入参为空！'}"  
	s obj=##class(CT.WDT.CDSS.DischargeGuide).%OpenId(id)
	s idc=$o(^CT.WDT.CDSS.RuleResultI("TypeResultIndex","出院指导",id,0))  //RecommendType="出院指导"  id=RecommendResult
	
	if (idc'="") {
		//s idr = $o(^CT.WDT.CDSS.DischargeGuideI("",idc,0))
		//s RecommendResult  = $lg($g(^CT.WDT.CDSS.RuleResultD(idc)),5)
		//s:RecommendResult'="" RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DischargeGuideD(RecommendResult)),2)
		s result = "{success:'false',info:'该数据已经在推荐出院指导中被引用'}"
	}	
	else {
	s bobj = ##class(web.CDSSEntity.CMKB.DischargeGuide).%New()
	s bobj.ID = id
	s bobj.DGuideName = obj.DGuideName
	s bobj.DGuideSource = obj.DGuideSource
	s bobj.DGuideState = obj.DGuideState
	s bobj.AuditUser = obj.AuditUser
	s bobj.UpdateUser = obj.UpdateUser
	s bobj.UpdateDate = obj.UpdateDate
	
	Ts
	s sc=##class(CT.WDT.CDSS.DischargeGuide).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DischargeGuide","CT.WDT.CDSS.DischargeGuide","出院指导",id,bobj.DGuideName,"D",bobj)
		d bobj.%Close()   
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("出院指导","web.CDSSEntity.CMKB.DischargeGuide","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	}
	q result
}

/// Creator:胡宜良
/// CreatDate:2021-11-17
/// Description：更改状态,审批驳回数据
/// Table:CT_WDT_CDSS.DischargeGuide
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.DischargeGuide).UpdateState("5","2")
ClassMethod UpdateState(id As %String, useflag As %String) As %String
{
	s result=""
	s AuditUser=""
	if ((useflag=1)||(useflag=2)||(useflag=3))
	{
		s AuditUser=$g(%session.Data("LOGON.USERNAME"))
	}
	s obj=##class(CT.WDT.CDSS.DischargeGuide).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.DischargeGuide).%New() 
	s bobj.ID=id
	s bobj.DGuideName = obj.DGuideName
	s bobj.DGuideSource = obj.DGuideSource
	s bobj.UpdateUser = obj.UpdateUser
	s bobj.DGuideState = useflag
	s bobj.UpdateDate = obj.UpdateDate
	
	s bobj.AuditUser = AuditUser

	s result=..SaveEntity(bobj)
	q result
}

/// Creator:徐 凯
/// CreatDate: 2021-11-16
/// Description：查询 出院指导 下拉框
/// Table:CT_WDT_CDSS.DischargeGuide
/// Input：rowid, desc,q
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DischargeGuide","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "ID:%String,DGuideName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 	if (rowid'="") //根据rowid返回该条记录
 	{
 		s ID=rowid
  		s DGuideName = $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),2)
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
			s ID=$o(^CT.WDT.CDSS.DischargeGuideD(ID))
			q:ID=""
			s DGuideName = $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),2)	//名称
			s length=$l(DGuideName)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s ID=0
			for
			{
				s ID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,ID))
				q:ID=""
				s DGuideDR=ID 
  				s DGuideName=$LISTGET($G(^CT.WDT.CDSS.DischargeGuideD(ID)),2)
  				s PINYIN=""
  				s DGuideState= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),4)
  				s:q'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DGuideName)  
  				if (($ZCONVERT(DGuideName,"U")[desc)||(PINYIN[desc)&(($ZCONVERT(DGuideName,"U")[q)||(PINYIN[q))&(DGuideState="3")) {
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
    set Data=$lb(ID,DGuideName)
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

/// Creator:胡宜良
/// CreatDate:2021-12-1
/// Description：打开数据
/// Table:CT_WDT_CDSS.DischargeGuide
/// Input：id
/// Return:
/// Other: w ##class(web.CDSS.CMKB.DischargeGuide).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    
    s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.DischargeGuide).%New()
	s eobj.ID = id
	s eobj.DGuideName = $LISTGET($G(^CT.WDT.CDSS.DischargeGuideD(id)),2)
	s eobj.DGuideSource = $LISTGET($G(^CT.WDT.CDSS.DischargeGuideD(id)),3)
	s eobj.DGuideState = $LISTGET($G(^CT.WDT.CDSS.DischargeGuideD(id)),4)
    s eobj.UpdateUser = $LISTGET($G(^CT.WDT.CDSS.DischargeGuideD(id)),5)
	s eobj.UpdateDate = $LISTGET($G(^CT.WDT.CDSS.DischargeGuideD(id)),6)
	s eobj.AuditUser = $LISTGET($G(^CT.WDT.CDSS.DischargeGuideD(id)),7)

	//ID, DGuideName, DGuideSource, DGuideState, UpdateUser, UpdateDate, AuditUser")
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator：胡宜良 
/// CreatDate: 2021-12-9
/// Description：批量通过
/// Table:CT_WDT_CDSS.DischargeGuide
/// CreatDate:2021-12-17
/// Other: w ##class(web.CDSS.CMKB.DischargeGuide).BatchConfirm()
ClassMethod BatchConfirm(idstr As %String)
{
	s result=""
	s errorfalg=0
	s total=$l(idstr,",")
	
	q:idstr="" "false"
	TS
	if (total>=1)
	{
		for m=1:1:total
		{

			s ConID=$p(idstr,",",m)
			s re= ..UpdateState(ConID,"3")

			s:re["false" errorfalg=errorfalg+1

		}
		
	}
	if (errorfalg'=0)
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

/// Creator：胡宜良 
/// CreatDate: 2021-10-18
/// Description：批量驳回
/// Table:CT_WDT_CDSS.DischargeGuide
/// CreatDate:2021-12-22
/// Other: w ##class(web.CDSS.CMKB.DischargeGuide).BatchCancel()
ClassMethod BatchCancel(idstr As %String)
{
	s result=""
	s errorfalg=0
	s total=$l(idstr,",")
	
	q:idstr="" "false"
	TS
	if (total>=1)
	{
		for m=1:1:total
		{
			s ConID=$p(idstr,",",m)
			s re= ..UpdateState(ConID,"2")
			s:re["false" errorfalg=errorfalg+1
		}
		
	}
	if (errorfalg'=0)
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

/// w ##class(web.CDSS.CMKB.DischargeGuide).ImportExcelData("测试,CSM,测试") 
ClassMethod ImportExcelData(dataStr As %String) As %String
{
	
	s result=""
			
		s dataStr=$tr(dataStr,"""")
		s dataStr=##class(web.DHCBL.BDP.FunLib).EvalJSONB(dataStr)
		s ^TMP("HY",1)=dataStr		
		s DGuideName=$p(dataStr,",",1)
		q:DGuideName="" "false" 
		s DGuideSource=$p(dataStr,",",2)
		q:DGuideSource="" "false" 
		s ^TMP("HY",2)=DGuideName
		s ^TMP("HY",3)=DGuideSource
		//s fullname=$p(dataStr,",",3)
		s bobj = ##class(web.CDSSEntity.CMKB.DischargeGuide).%New()
		s bobj.ID = ""
		s bobj.DGuideState=0
		s bobj.DGuideName= DGuideName		         //名称
		s bobj.DGuideSource= DGuideSource			 //来源

	
		s re=..SaveEntity(bobj)
	
		s DGuideDR=$o(^CT.WDT.CDSS.DischargeGuideI("NameIndex",DGuideName,0))
		//s DGuideDetail=$p(dataStr,"[next]",3)
		s ^TMP("HY",4)=DGuideDR
		s DGuideDetail=$p(dataStr,",",3)
		s ^TMP("HY",5)=DGuideDetail
		q:DGuideDetail="" "false"
	 
		s re=##class(web.CDSS.CMKB.DGuideDetail).SaveData("",DGuideDetail,DGuideDR)
	
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

/// Creator：胡宜良
/// CreatDate: 2021-12-13
/// Description：批量导入
/// Table:CT_WDT_CDSS.DischargeGuide
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DischargeGuide).SaveImportData("1[next]2[next]3[next]")
ClassMethod SaveImportData(dataStr)
{
	s result=""
	s dataStr=$tr(dataStr," ","")
	s dataStr=##class(web.DHCBL.BDP.FunLib).EvalJSONB(dataStr)		
	s DGuideName=$p(dataStr,"[next]",1)
	q:DGuideName="" "false" 
	s DGuideSource=$p(dataStr,"[next]",2)
	q:DGuideSource="" "false" 


	s bobj = ##class(web.CDSSEntity.CMKB.DischargeGuide).%New()
	s bobj.ID = ""
	s bobj.DGuideState=0
	s bobj.DGuideName= DGuideName		         //名称
	s bobj.DGuideSource= DGuideSource			 //来源

	
	s re=..SaveEntity(bobj)
	
	s DGuideDR=$o(^CT.WDT.CDSS.DischargeGuideI("NameIndex",DGuideName,0))
	s DGuideDetail=$p(dataStr,"[next]",3)
	q:DGuideDetail="" "false"
	 
	s re1=##class(web.CDSS.CMKB.DGuideDetail).SaveData("",DGuideDetail,DGuideDR)
	
	if ((re="{success:'false',errorinfo:'该记录已经存在！'}")&&(re1["true"))||((re["true")&&(re1["true"))
	{
		s result="true"	
	}
	else
	{
		s result="false"
	}
	
	q result
}

/// Creator：胡宜良
/// CreatDate: 2021-12-13
/// Description：导出
/// Table:CT_WDT_CDSS.DischargeGuide
/// Input：
/// Return：
/// Others：w ##class(web.CDSS.CMKB.DischargeGuide).ExportDataTXT("肝硬化","","","","","","")
ClassMethod ExportDataTXT(name As %String, source As %String, state As %String, updateuser As %String, audituser As %String, starttime As %String, endtime As %String) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"出院指导数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
	*/
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"出院指导数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file=Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file=Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){d ##class(%File).CreateDirectoryChain(DirName)}
	
	o file:"NWS"
	u file
	w "出院指导名称	来源	状态	编辑人	审核人	编辑时间	内容"  
	
	
	s:name'="" name=$ZCONVERT(name,"U") //转换成大写
	s:source'="" source=$ZCONVERT(source,"U") //转换成大写
	s:updateuser'="" updateuser=$ZCONVERT(updateuser,"U") //转换成大写
	s:audituser'="" audituser=$ZCONVERT(audituser,"U") //转换成大写
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.DischargeGuideD(ID))
		q:ID=""
		
		s DGuideName= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),2)       //名称
		continue:((name'="")&&($ZCONVERT(DGuideName,"U")'[name))
		s DGuideSource= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),3)       //来源
        continue:((source'="")&&($ZCONVERT(DGuideSource,"U")'[source))
	   	s DGuideState= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),4)        //状态
	    s DGuideState=$case(DGuideState,0:"编辑中",1:"已弃用",2:"已驳回",3:"已审核",4:"待审核",:"") 
	    continue:((($ZCONVERT(DGuideState,"U")'[state)&&(state'=""))||((state="")&&(DGuideState="已弃用")))
	    s UpdateUser= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),5) 	   //编辑人
	    continue:(($ZCONVERT(UpdateUser,"U")'[updateuser)&&(updateuser'=""))
	    s UpdateDate= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),6)     //编辑时间
		continue:((starttime'="")&&(endtime'=""))&&(($ZDH(UpdateDate,3)>$zdh(endtime,3))||($ZDH(UpdateDate,3)<$zdh(starttime,3)))
		continue:((starttime="")&&(endtime'=""))&&($ZDH(UpdateDate,3)'=$zdh(endtime,3))
		continue:((endtime="")&&(starttime'=""))&&($ZDH(UpdateDate,3)'=$zdh(starttime,3))	
	    s AuditUser= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),7)        //审核人
        continue:(($ZCONVERT(AuditUser,"U")'[audituser)&&(audituser'=""))
        
        s DGuideDR=$o(^CT.WDT.CDSS.DischargeGuideI("NameIndex",DGuideName,0))
	    s DGuideDetail= $lg($g(^CT.WDT.CDSS.DischargeGuideD(ID)),3)     //内容
	    
		
	
		w !,DGuideName_"	"_DGuideSource_"	"_DGuideState_"	"_UpdateUser_"	"_AuditUser_"	"_UpdateDate_"	"_DGuideDetail
		
		
		
	}
	c file
	q fileName
}

/// Creator:胡宜良 
/// CreatDate:2021-12-29
/// Description:删除限制
/// Input：id 
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.CMKB.DischargeGuide).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0
    s count=0
    if ($d(^CT.WDT.CDSS.RuleDictI("RuleSourceIndex",id)))
    {
	    s RuleRowId=0
	    for
	    {
	        s RuleRowId=$o(^CT.WDT.CDSS.RuleDictI("RuleSourceIndex",id,RuleRowId)) q:(PhysicalEID="")
            s RuleCode=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowId)),2)
            s RuleSource=""
            s:RuleCode'="" RuleSource=$lg($g(^CT.WDT.CDSS.RuleDictD(DiseaseDR)),5)
            s flag=1
            s count=count+1
            
	        if (count>3)
            {
	            s myInfo=myInfo_"..."
	            q
            }
            else
            {
	            s myInfo=myInfo_"<循证规则库:"_RuleSource_"关联推荐出院指导>"
            }
	    }
    }
    
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:胡宜良 
/// CreatDate: 2022-01-28
/// Description：数据统计方法
/// Table：CT.WDT.CDSS.DischargeGuide
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.DischargeGuide).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DischargeGuideD(RowId))
		q:RowId=""
		s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.DischargeGuideD(RowId)),4)       
		if (UseFlag'="")
		{
			if (UseFlag=0){
				s editcount=editcount+1
			} elseif (UseFlag=3){
				s auditcount=auditcount+1
			}
		}
		s totalcount=editcount+auditcount	 	
	}
	q totalcount_"^"_editcount_"^"_auditcount_"^"_unauditcount
}

}
