Import SQLUser

/// 名称:药学 2疗程
/// 描述:疗程维护，包含增删改查功能
/// 编写者：基础数据平台组 - 陈莹 
/// 编写日期:  2012-8-30
Class web.DHCBL.CT.PHCDuration Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹 		
/// CreatDate: 2012-8-29
/// Description：查询 疗程
/// Table：User.PHCDuration
/// Input：rowid, code, factor, desc1, desc2
/// Output:PHCDURowId,PHCDUCode,PHCDUFactor,PHCDUDesc1,PHCDUDesc2,PHCDUDateFrom,PHCDUDateTo
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCDuration","GetList","","","","","")
Query GetList(rowid As %String, code As %String, factor As %String, desc1 As %String, desc2 As %String) As %Query(ROWSPEC = "PHCDURowId:%String,PHCDUCode:%String,PHCDUFactor:%String,PHCDUDesc1:%String,PHCDUDesc2:%String,PHCDUDateFrom:%String,PHCDUDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, factor As %String, desc1 As %String, desc2 As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHCDURowId=rowid
		s PHCDUCode= $p($g(^PHCDU(PHCDURowId)),"^",1)
		s PHCDUDesc1 = $p($g(^PHCDU(PHCDURowId)),"^",3)
		s PHCDUDesc2 = $p($g(^PHCDU(PHCDURowId)),"^",4)
		s PHCDUFactor = $p($g(^PHCDU(PHCDURowId)),"^",2)
		s PHCDUDateFrom = $p($g(^PHCDU(PHCDURowId)),"^",5)
		s PHCDUDateTo = $p($g(^PHCDU(PHCDURowId)),"^",6)
		s:PHCDUDateFrom'="" PHCDUDateFrom=$zd(PHCDUDateFrom,1)
		s:PHCDUDateTo'="" PHCDUDateTo=$zd(PHCDUDateTo,1)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Duration",PHCDURowId)
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
		s AuStr=##class(web.DHCBL.Authorize.PHCDuration).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCDURowId=0
		for
		{
			s PHCDURowId=$o(^PHCDU(PHCDURowId)) q:PHCDURowId=""
			s strRowId="{ID:"_PHCDURowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCDUCode=$p($g(^PHCDU(PHCDURowId)),"^",1)
				s PHCDUDesc1 = $p($g(^PHCDU(PHCDURowId)),"^",3)
				s PHCDUDesc2 = $p($g(^PHCDU(PHCDURowId)),"^",4)
				s PHCDUFactor = $p($g(^PHCDU(PHCDURowId)),"^",2)
				s PHCDUDateFrom = $p($g(^PHCDU(PHCDURowId)),"^",5)
				s PHCDUDateTo = $p($g(^PHCDU(PHCDURowId)),"^",6)
				s:PHCDUDateFrom'="" PHCDUDateFrom=$zd(PHCDUDateFrom,1)
				s:PHCDUDateTo'="" PHCDUDateTo=$zd(PHCDUDateTo,1)
		
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Duration",PHCDURowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)
				s BDPInternalDesc = $p($g(resultStr),"^",2)
				s BDPHospNationalCode=$p($g(resultStr),"^",3)  
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)
				
				if (desc1'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Duration",PHCDURowId,PHCDUDesc1,desc1)
				}
				else
				{
					s AliasFlag= 1
				}
				s PINYIN2=""
				s:desc2'="" PINYIN2= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHCDUDesc2)
				i ($ZCONVERT(PHCDUCode,"U")[code)&($ZCONVERT(PHCDUFactor,"U")[factor)&(AliasFlag=1)&((PHCDUDesc2[desc2)||(PINYIN2[desc2))
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHCDURowId,PHCDUCode,PHCDUFactor,PHCDUDesc1,PHCDUDesc2,PHCDUDateFrom,PHCDUDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// CreatDate: 2012-8-29
/// Description：查询 疗程
/// Table：User.PHCDuration
/// Input：code,desc,desc
/// Output:PHCDURowId,PHCDUCode,PHCDUDesc1
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCDuration","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCDURowId:%String,PHCDUCode:%String,PHCDUDesc1:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{
		s PHCDURowId=rowid
		s PHCDUCode= $p($g(^PHCDU(PHCDURowId)),"^",1)
		s PHCDUDesc1 = $p($g(^PHCDU(PHCDURowId)),"^",3)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s AuStr=##class(web.DHCBL.Authorize.PHCDuration).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCDURowId=0
		for
		{
			s PHCDURowId=$o(^PHCDU(PHCDURowId)) q:PHCDURowId=""
			s strRowId="{ID:"_PHCDURowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCDUCode=$p($g(^PHCDU(PHCDURowId)),"^",1)
				s PHCDUDesc1 = $p($g(^PHCDU(PHCDURowId)),"^",3)
				s PHCDUDateFrom = $p($g(^PHCDU(PHCDURowId)),"^",5)
				continue:(PHCDUDateFrom'="")&&(PHCDUDateFrom>+$h)
				s PHCDUDateTo = $p($g(^PHCDU(PHCDURowId)),"^",6)
				continue:(PHCDUDateTo'="")&&(PHCDUDateTo<+$h)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Duration",PHCDURowId,PHCDUDesc1,desc)
				}
				else
				{
					s AliasFlag=1
				}
				i ($ZCONVERT(PHCDUCode,"U")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(PHCDURowId,PHCDUCode,PHCDUDesc1)
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
/// CreatDate:2012-12-24  modified @201702015
/// Description:数据重复验证方法,js调用
/// Table:User.PHCDuration
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PHCPHCDuration).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc1 As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc1'="" desc1=$$ALPHAUP^SSUTIL4(desc1) //$ZCONVERT(desc1,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^PHCDU(0,"Code",code))
	s:desc1'="" flagd=$d(^PHCDU(0,"Desc1",desc1))
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
		s:code'="" idc=$o(^PHCDU(0,"Code",code,0))
		s:desc1'="" idd=$o(^PHCDU(0,"Desc1",desc1,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
			
	}
	q flag
}

/// Creator：杨帆
/// CreatDate: 2019-8-4
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.PHCDuration
/// Input：PHCDURowId
ClassMethod NewOpenData(id As %String) As %String
{
	
    s str = ""
	s pobj = ##class(User.PHCDuration).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PHCDuration).%New()
	s eobj.PHCDURowId = id
	s eobj.PHCDUCode  = pobj.PHCDUCode
	s eobj.PHCDUFactor = pobj.PHCDUFactor
	s eobj.PHCDUDesc1 = pobj.PHCDUDesc1
	s eobj.PHCDUDesc2 =pobj.PHCDUDesc2
	s:pobj.PHCDUDateFrom'="" eobj.PHCDUDateFrom =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PHCDUDateFrom)
	s:pobj.PHCDUDateTo'="" eobj.PHCDUDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PHCDUDateTo)
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.PHCDuration
/// Input：PHCDURowId
ClassMethod OpenData(PHCDURowId As %String) As %String
{
	
    s str = ""
	s pobj = ##class(User.PHCDuration).%OpenId(PHCDURowId)
	s eobj = ##class(web.Entity.CT.PHCDuration).%New()
	s eobj.PHCDURowId = PHCDURowId
	s eobj.PHCDUCode  = pobj.PHCDUCode
	s eobj.PHCDUFactor = pobj.PHCDUFactor
	s eobj.PHCDUDesc1 = pobj.PHCDUDesc1
	s eobj.PHCDUDesc2 =pobj.PHCDUDesc2
	s:pobj.PHCDUDateFrom'="" eobj.PHCDUDateFrom =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PHCDUDateFrom)
	s:pobj.PHCDUDateTo'="" eobj.PHCDUDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PHCDUDateTo)
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：保存 疗程
/// Input: eobj As web.DHCBL.CT.PHCDuration
/// Table：User.PHCDuration
/// Return:成功返回true，失败返回false
ClassMethod SaveEntity(eobj As web.Entity.CT.PHCDuration) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.PHCDUDateFrom'="" eobj.PHCDUDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PHCDUDateFrom)
		s:eobj.PHCDUDateTo'="" eobj.PHCDUDateTo =##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PHCDUDateTo)
		if eobj.PHCDUDateFrom="" s eobj.PHCDUDateFrom=+$h   //空则默认当天
		
		s flag=..FormValidate(eobj.PHCDURowId,eobj.PHCDUCode,eobj.PHCDUDesc1)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.PHCDURowId="")
		{	
	        s obj=##class(User.PHCDuration).%New()
		}
		else
		{
			s obj=##class(User.PHCDuration).%OpenId(eobj.PHCDURowId)
			
			s bobj = ##class(web.Entity.CT.PHCDuration).%New()
			s bobj.PHCDURowId = eobj.PHCDURowId
			s bobj.PHCDUCode = obj.PHCDUCode
			s bobj.PHCDUFactor = obj.PHCDUFactor
			s bobj.PHCDUDesc1 = obj.PHCDUDesc1		        
			s bobj.PHCDUDesc2 = obj.PHCDUDesc2
			s bobj.PHCDUDateFrom=obj.PHCDUDateFrom
			s bobj.PHCDUDateTo=obj.PHCDUDateTo
		}	

		s obj.PHCDUCode = eobj.PHCDUCode
		s obj.PHCDUFactor = eobj.PHCDUFactor //系数
		s obj.PHCDUDesc1 = eobj.PHCDUDesc1		        
		s obj.PHCDUDesc2 = eobj.PHCDUDesc2
		s obj.PHCDUDateFrom=eobj.PHCDUDateFrom
		s obj.PHCDUDateTo=eobj.PHCDUDateTo
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.PHCDURowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Duration","User.PHCDuration","疗程",id,eobj.PHCDUDesc1,"A",eobj)
			d:eobj.PHCDURowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Duration","User.PHCDuration","疗程",id,eobj.PHCDUDesc1,"U",eobj,bobj)
			if (eobj.DataAlias'="")  //2017-2-8 自动添加别名到BDPAlias表
			{
				s length=$l(eobj.DataAlias,"/")
				for aliasi=1:1:length
				{
					s alias=$p(eobj.DataAlias,"/",aliasi)
					s:alias'="" aliasstr=##class(web.DHCBL.BDP.BDPAlias).Insert("PHC_Duration",alias,id)
				}
			}
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("疗程","web.DHCBL.CT.PHCDuration","SaveEntity",eobj)
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
/// CreatDate:2013-8-22
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	i ($d(^PHCD("Durat",id))'=0)
	{
		s myInfo=myInfo_"<药学项-药物形态设定>"
	}
	s ARCIMSubscript=0,flag=0
	for
	{
		s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:(ARCIMSubscript="")||(flag=1)
		s ARCIMVersion=0
		for
		{
			s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:(ARCIMVersion="")||(flag=1)
			s ARCIMRMDurationDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",16)
			i ARCIMRMDurationDR=id
			{
				s flag=1
				s myInfo=myInfo_"<医嘱项>"
			}
		}
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：根据id删除 疗程
/// Table：User.PHCDuration
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: d ##class( web.DHCBL.PHC.PHCDuration).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.PHCDuration).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.PHCDuration).%OpenId(id)
		s eobj = ##class(web.Entity.CT.PHCDuration).%New()
		s eobj.PHCDURowId = id
		s eobj.PHCDUCode  = pobj.PHCDUCode
		s eobj.PHCDUFactor = pobj.PHCDUFactor
		s eobj.PHCDUDesc1 = pobj.PHCDUDesc1
		s eobj.PHCDUDesc2 =pobj.PHCDUDesc2
		s eobj.PHCDUDateFrom = pobj.PHCDUDateFrom 
		s eobj.PHCDUDateTo =  pobj.PHCDUDateTo 
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(User.PHCDuration).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Duration","User.PHCDuration","疗程",id,eobj.PHCDUDesc1,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("疗程","web.DHCBL.CT.PHCDuration","DeleteData",eobj)
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
