Import SQLUser

/// 名称:药学 9药品用量
/// 描述:药品用量维护，包含增删改查功能
/// 编写者：基础数据平台组 - 陈莹 
/// 编写日期:  2016-8-26
Class web.DHCBL.CT.PHCDosage Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹 		
/// CreatDate: 2016-8-26
/// Description：查询 药品用量
/// Table：User.PHCDosage
/// Input：rowid, code, factor, desc1, desc2
/// Output:PHCDORowId,PHCDOCode,PHCDOFactor,PHCDODesc1,PHCDODesc2,PHCDOCTUOMDR,PHCDOQty
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCDosage","GetList","","","","","")
Query GetList(rowid As %String, code As %String, factor As %String, desc1 As %String, desc2 As %String) As %Query(ROWSPEC = "PHCDORowId:%String,PHCDOCode:%String,PHCDOFactor:%String,PHCDODesc1:%String,PHCDODesc2:%String,PHCDOCTUOMDR:%String,PHCDOQty:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, factor As %String, desc1 As %String, desc2 As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHCDORowId=rowid
		
		s PHCDOCode= $p($g(^PHCDO(PHCDORowId)),"^",1)
		s PHCDODesc1 = $p($g(^PHCDO(PHCDORowId)),"^",3)
		s PHCDODesc2 = $p($g(^PHCDO(PHCDORowId)),"^",4)
		s PHCDOFactor = $p($g(^PHCDO(PHCDORowId)),"^",2)
		s PHCDOCTUOMDR = $p($g(^PHCDO(PHCDORowId)),"^",5)
		s:PHCDOCTUOMDR'="" PHCDOCTUOMDR=$p($g(^CT("UOM",PHCDOCTUOMDR)),"^",2)
		s PHCDOQty = $p($g(^PHCDO(PHCDORowId)),"^",6)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Dosage",PHCDORowId)
		s BDPInternalCode =$p($g(resultStr),"^",1)
		s BDPInternalDesc = $p($g(resultStr),"^",2)
		s BDPHospNationalCode=$p($g(resultStr),"^",3)  
		s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc1'="" desc1=$ZCONVERT(desc1,"U") //转换成大写
		s:desc2'="" desc2=$ZCONVERT(desc2,"U") //转换成大写
		s:factor'="" factor=$ZCONVERT(factor,"U") //转换成大写
		s AuStr=##class(web.DHCBL.Authorize.PHCDosage).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		
		
		s UOMAuStr=##class(web.DHCBL.Authorize.CTUOM).DHCGetDataByDefaultSession()
		s UOMAuFlag=0
		;未授权情况下，默认显示全部数据
		if (UOMAuStr="")||(UOMAuStr["limited:0") s UOMAuFlag=1

		s PHCDORowId=0
		for
		{
			s PHCDORowId=$o(^PHCDO(PHCDORowId)) q:PHCDORowId=""
			s strRowId="{ID:"_PHCDORowId_"}"			
			s PHCDOCTUOMDRID = $p($g(^PHCDO(PHCDORowId)),"^",5)
			s UOMstrRowId="{ID:"_PHCDOCTUOMDRID_"}"
			if ((UOMAuStr[UOMstrRowId)||(UOMAuFlag=1))&&((AuStr[strRowId)||(AuFlag=1)) ;用来筛选授权数据
			{
				s PHCDOCode=$p($g(^PHCDO(PHCDORowId)),"^",1)
				s PHCDODesc1 = $p($g(^PHCDO(PHCDORowId)),"^",3)
				s PHCDODesc2 = $p($g(^PHCDO(PHCDORowId)),"^",4)
				s PHCDOFactor = $p($g(^PHCDO(PHCDORowId)),"^",2)
				s PHCDOCTUOMDR = $p($g(^PHCDO(PHCDORowId)),"^",5)
				s:PHCDOCTUOMDR'="" PHCDOCTUOMDR=$p($g(^CT("UOM",PHCDOCTUOMDR)),"^",2)
				s PHCDOQty = $p($g(^PHCDO(PHCDORowId)),"^",6)
				
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Dosage",PHCDORowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)
				s BDPInternalDesc = $p($g(resultStr),"^",2)
				s BDPHospNationalCode=$p($g(resultStr),"^",3)  
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)
				if (desc1'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Dosage",PHCDORowId,PHCDODesc1,desc1)
				}
				else
				{
					s AliasFlag= 1
				} 
				s PINYIN2=""
				s:desc2'="" PINYIN2= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHCDODesc2)
				i ($ZCVT(PHCDOCode,"u")[code)&($ZCONVERT(PHCDOFactor,"U")[factor)&(AliasFlag=1)&(($ZCONVERT(PHCDODesc2,"U")[desc2)||(PINYIN2[desc2))
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHCDORowId,PHCDOCode,PHCDOFactor,PHCDODesc1,PHCDODesc2,PHCDOCTUOMDR,PHCDOQty,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Creator：陈莹 		
/// CreatDate: 2016-8-26
/// Description：查询 药品用量
/// Table：User.PHCDosage
/// Input：code,desc,desc
/// Output:PHCDORowId,PHCDOCode,PHCDODesc1
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCDosage","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCDORowId:%String,PHCDOCode:%String,PHCDODesc1:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{
		s PHCDORowId=rowid
		s PHCDOCode= $p($g(^PHCDO(PHCDORowId)),"^",1)
		s PHCDODesc1 = $p($g(^PHCDO(PHCDORowId)),"^",3)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s AuStr=##class(web.DHCBL.Authorize.PHCDosage).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCDORowId=0
		for
		{
			s PHCDORowId=$o(^PHCDO(PHCDORowId)) q:PHCDORowId=""
			s strRowId="{ID:"_PHCDORowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCDOCode=$p($g(^PHCDO(PHCDORowId)),"^",1)
				s PHCDODesc1 = $p($g(^PHCDO(PHCDORowId)),"^",3)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Dosage",PHCDORowId,PHCDODesc1,desc)
				}
				else
				{
					s AliasFlag= 1
				} 
				i ($ZCONVERT(PHCDOCode,"U")[code)&&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(PHCDORowId,PHCDOCode,PHCDODesc1)
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

/// Creator:陈莹 
/// CreatDate:2016-8-26  modified @201702015
/// Description:数据重复验证方法,js调用
/// Table:User.PHCDosage
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PHCPHCDosage).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc1 As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc1'="" desc1=$$ALPHAUP^SSUTIL4(desc1) //$ZCONVERT(desc1,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^PHCDO(0,"Code",code))
	s:desc1'="" flagd=$d(^PHCDO(0,"Desc1",desc1))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0))
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
		s idd=""
		s:code'="" idc=$o(^PHCDO(0,"Code",code,0))
		s:desc1'="" idd=$o(^PHCDO(0,"Desc1",desc1,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
			
	}
	q flag
}

/// Creator：陈莹 
/// CreatDate: 2016-8-26
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.PHCDosage
/// Input：PHCDORowId
ClassMethod OpenData(PHCDORowId As %String) As %String
{
	
    s str = ""
	s pobj = ##class(User.PHCDosage).%OpenId(PHCDORowId)
	s eobj = ##class(web.Entity.CT.PHCDosage).%New()
	s eobj.PHCDORowId = PHCDORowId
	s eobj.PHCDOCode  = pobj.PHCDOCode
	s eobj.PHCDOFactor = pobj.PHCDOFactor
	s eobj.PHCDODesc1 = pobj.PHCDODesc1
	s eobj.PHCDODesc2 =pobj.PHCDODesc2
	if $IsObject(pobj.PHCDOCTUOMDR){
		s eobj.PHCDOCTUOMDR = pobj.PHCDOCTUOMDR.%Id() 
	}
	s eobj.PHCDOQty = pobj.PHCDOQty
	
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹 
/// CreatDate: 2016-8-26
/// Description：保存 药品用量
/// Input: eobj As web.DHCBL.CT.PHCDosage
/// Table：User.PHCDosage
/// Return:成功返回true，失败返回false
ClassMethod SaveEntity(eobj As web.Entity.CT.PHCDosage) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{	
		s flag=..FormValidate(eobj.PHCDORowId,eobj.PHCDOCode,eobj.PHCDODesc1)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.PHCDORowId="")
		{	
	        s obj=##class(User.PHCDosage).%New()
		}
		else
		{
			s obj=##class(User.PHCDosage).%OpenId(eobj.PHCDORowId)
			s bobj = ##class(web.Entity.CT.PHCDosage).%New()
			s bobj.PHCDORowId = eobj.PHCDORowId
			s bobj.PHCDOCode = obj.PHCDOCode
			s bobj.PHCDOFactor = obj.PHCDOFactor
			s bobj.PHCDODesc1 = obj.PHCDODesc1		        
			s bobj.PHCDODesc2 = obj.PHCDODesc2
			s:obj.PHCDOCTUOMDR'="" bobj.PHCDOCTUOMDR=obj.PHCDOCTUOMDR.%Id()
			s bobj.PHCDOQty=obj.PHCDOQty
		}	

		s obj.PHCDOCode = eobj.PHCDOCode
		s obj.PHCDOFactor = eobj.PHCDOFactor //系数
		s obj.PHCDODesc1 = eobj.PHCDODesc1		        
		s obj.PHCDODesc2 = eobj.PHCDODesc2
		D:eobj.PHCDOCTUOMDR'="" obj.PHCDOCTUOMDRSetObjectId(eobj.PHCDOCTUOMDR)
		D:eobj.PHCDOCTUOMDR="" obj.PHCDOCTUOMDRSetObjectId("")
		s obj.PHCDOQty=eobj.PHCDOQty
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.PHCDORowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Dosage","User.PHCDosage","药品用量",id,eobj.PHCDODesc1,"A",eobj)
			d:eobj.PHCDORowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Dosage","User.PHCDosage","药品用量",id,eobj.PHCDODesc1,"U",eobj,bobj)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品用量","web.DHCBL.CT.PHCDosage","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:陈莹
/// CreatDate:2016-8-26
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	n (id)
	s return="",myInfo=""
	
	i ($o(^PHCINLD(0,"Dosage",id,0))'="")	
	{
		s myInfo=myInfo_"<用法与用量关联表>"
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：陈莹 
/// CreatDate: 2016-8-26
/// Description：根据id删除 药品用量
/// Table：User.PHCDosage
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: d ##class( web.DHCBL.PHC.PHCDosage).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	n (id,%session)
	s result=""
	s re=##class(web.DHCBL.CT.PHCDosage).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.PHCDosage).%OpenId(id)
		s eobj = ##class(web.Entity.CT.PHCDosage).%New()
		s eobj.PHCDORowId = id
		s eobj.PHCDOCode  = pobj.PHCDOCode
		s eobj.PHCDOFactor = pobj.PHCDOFactor
		s eobj.PHCDODesc1 = pobj.PHCDODesc1
		s eobj.PHCDODesc2 =pobj.PHCDODesc2
		s:pobj.PHCDOCTUOMDR'="" eobj.PHCDOCTUOMDR = pobj.PHCDOCTUOMDR.%Id()
		s eobj.PHCDOQty =  pobj.PHCDOQty 
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(User.PHCDosage).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Dosage","User.PHCDosage","药品用量",id,eobj.PHCDODesc1,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品用量","web.DHCBL.CT.PHCDosage","DeleteData",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

}
