Import SQLUser

/// 名称:药学 5管制药品分类
/// 描述:管制药品分类维护，包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹 
/// 编写日期:  2012-8-30
Class web.DHCBL.CT.PHCPoison Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹 		
/// CreatDate: 2012-8-29
/// Description：查询 管制药品分类
/// Table：User.PHCPoison
/// Input：rowid,code,desc
/// Output:PHCPORowId,PHCPOCode,PHCPODesc,PHCPOOTCFlag,PHCPOSaleRpt,PHCPOMHRpt
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCPoison","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCPORowId:%String,PHCPOCode:%String,PHCPODesc:%String,PHCPOOTCFlag:%String,PHCPOSaleRpt:%String,PHCPOMHRpt:%String ,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="")
	{
		s PHCPORowId=rowid
		s PHCPOCode=$p($g(^PHCPO(PHCPORowId)),"^",1)
		s PHCPODesc=$p($g(^PHCPO(PHCPORowId)),"^",2)
		s PHCPOOTCFlag=$p($g(^PHCPO(PHCPORowId)),"^",3)
		s PHCPOSaleRpt=$p($g(^PHCPO(PHCPORowId)),"^",4)
		s PHCPOMHRpt=$p($g(^PHCPO(PHCPORowId)),"^",5)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Poison",PHCPORowId)
		s BDPInternalCode =$p($g(resultStr),"^",1)
		s BDPInternalDesc = $p($g(resultStr),"^",2)
		s BDPHospNationalCode=$p($g(resultStr),"^",3)  
		s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.PHCPoison).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCPORowId=0
		for
		{
			s PHCPORowId=$o(^PHCPO(PHCPORowId)) q:PHCPORowId=""
			s strRowId="{ID:"_PHCPORowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCPOCode=$p($g(^PHCPO(PHCPORowId)),"^",1)
				s PHCPODesc=$p($g(^PHCPO(PHCPORowId)),"^",2)
				s PHCPOOTCFlag=$p($g(^PHCPO(PHCPORowId)),"^",3)
				s PHCPOSaleRpt=$p($g(^PHCPO(PHCPORowId)),"^",4)
				s PHCPOMHRpt=$p($g(^PHCPO(PHCPORowId)),"^",5)
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Poison",PHCPORowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)
				s BDPInternalDesc = $p($g(resultStr),"^",2)
				s BDPHospNationalCode=$p($g(resultStr),"^",3)  
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Poison",PHCPORowId,PHCPODesc,desc)
				}
				else
				{
					s AliasFlag=1
				}
				i ($zcvt(PHCPOCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHCPORowId,PHCPOCode,PHCPODesc,PHCPOOTCFlag,PHCPOSaleRpt,PHCPOMHRpt ,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Description：查询 管制药品分类
/// Table：User.PHCPoison
/// Input：code,desc
/// Output:PHCPORowId,PHCPOCode,PHCPODesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCPoison","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCPORowId:%String,PHCPOCode:%String,PHCPODesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="")
	{
		s PHCPORowId=rowid
		s PHCPOCode=$p($g(^PHCPO(PHCPORowId)),"^",1)
		s PHCPODesc=$p($g(^PHCPO(PHCPORowId)),"^",2)
		
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.PHCPoison).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCPORowId=0
		for
		{
			s PHCPORowId=$o(^PHCPO(PHCPORowId)) q:PHCPORowId=""
			s strRowId="{ID:"_PHCPORowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCPOCode=$p($g(^PHCPO(PHCPORowId)),"^",1)
				s PHCPODesc=$p($g(^PHCPO(PHCPORowId)),"^",2)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Poison",PHCPORowId,PHCPODesc,desc)
				}
				else
				{
					s AliasFlag=1
				}
				i ($zcvt(PHCPOCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
	
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(PHCPORowId,PHCPOCode,PHCPODesc)
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
/// Table:User.PHCPoison
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PHCPoison).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^PHCPO(0,"Code",code))
	s:desc'="" flagd=$d(^PHCPO(0,"Desc",desc))
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
		s:code'="" idc=$o(^PHCPO(0,"Code",code,0))
		s:desc'="" idd=$o(^PHCPO(0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
			
	}
	q flag
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：新增、修改时打开Form，根据RowId查询
/// Table：User.PHCPoison
ClassMethod OpenData(PHCPORowId As %String) As %String
{
	/*Code,Desc中有回车换行键(PHCPoison,PHCForm)
	$CHAR(10)换行键，$CHAR(13)回车键
	$c(13,10)
	^PHCF(32) = "普通片剂"_$c(13,10)_"^普通片剂"_$c(13,10) 
	!,*10,取长度$l(A),取字段$Extract(A,1,5)
	C中：回车符是Carriage Return, C语言中是'\r';换行符是Line Feed, C语言中是'\n';回车换行符实际是两个字符, 就是\r\n
	换行是光标从当前位置换到下一行；回车是光标从当前位置回到本行的行首；换行回车效果就是前面两个效果的叠加，也就是换到下一行，并回到行首
	*/
    s str = ""
	s pobj = ##class(User.PHCPoison).%OpenId(PHCPORowId)
	s eobj = ##class(web.Entity.CT.PHCPoison).%New()
	s eobj.PHCPORowId = PHCPORowId
	//Code,Desc中有回车键
	s eobj.PHCPOCode = $p(pobj.PHCPOCode,$c(13,10),1)
	s eobj.PHCPODesc = $p(pobj.PHCPODesc,$c(13,10),1)
	s:pobj.PHCPOOTCFlag="Y" eobj.PHCPOOTCFlag="true" //checkbox
	//s eobj.PHCPOOTCFlag = pobj.PHCPOOTCFlag  //radio
	s:pobj.PHCPOSaleRpt="Y" eobj.PHCPOSaleRpt="true" //checkbox
	s:pobj.PHCPOMHRpt="Y" eobj.PHCPOMHRpt="true" //checkbox
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹 
/// CreatDate: 2012-8-3
/// Description：添加/修改 管制药品分类
/// Table：User.PHCPoison
ClassMethod SaveEntity(eobj As web.Entity.CT.PHCPoison) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.PHCPOOTCFlag="" eobj.PHCPOOTCFlag="N"
		s:eobj.PHCPOSaleRpt="" eobj.PHCPOSaleRpt="N"
		s:eobj.PHCPOMHRpt="" eobj.PHCPOMHRpt="N"
		
		s flag=..FormValidate(eobj.PHCPORowId,eobj.PHCPOCode,eobj.PHCPODesc)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.PHCPORowId="")
		{	
	        s obj=##class(User.PHCPoison).%New()
		}
		else
		{
			s obj=##class(User.PHCPoison).%OpenId(eobj.PHCPORowId)
			
			s bobj = ##class(web.Entity.CT.PHCPoison).%New()
			s bobj.PHCPORowId = eobj.PHCPORowId
			s bobj.PHCPOOTCFlag = obj.PHCPOOTCFlag    
			s bobj.PHCPOSaleRpt = obj.PHCPOSaleRpt   
			s bobj.PHCPOMHRpt = obj.PHCPOMHRpt    
			s bobj.PHCPOCode = obj.PHCPOCode
			s bobj.PHCPODesc = obj.PHCPODesc
		}
		
		s obj.PHCPOOTCFlag = eobj.PHCPOOTCFlag
		s obj.PHCPOSaleRpt = eobj.PHCPOSaleRpt
		s obj.PHCPOMHRpt = eobj.PHCPOMHRpt    
		s obj.PHCPOCode =$p(eobj.PHCPOCode,$c(13,10),1) 
		s obj.PHCPODesc = $p(eobj.PHCPODesc,$c(13,10),1) 
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.PHCPORowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Poison","User.PHCPoison","管制药品分类",id,eobj.PHCPODesc,"A",eobj)
			d:eobj.PHCPORowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Poison","User.PHCPoison","管制药品分类",id,eobj.PHCPODesc,"U",eobj,bobj)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("管制药品分类","web.DHCBL.CT.PHCPoison","SaveEntity",eobj)
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
/// CreatDate:2013-8-21
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	i ($d(^PHCD(0,"Poison",+id))'=0)
	{
		s myInfo=myInfo_"<药学项>"
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator:陈莹 
/// CreatDate:2012-9-10
/// Description:根据id删除 管制药品分类
/// Table:User.PHCPoison
/// Input:id(PHCPoison的PHCPORowId) 
/// Return:成功返回"{success:'true'和info}";失败返回"{success:'false'和info}
/// Other:d ##class(web.DHCBL.CT.PHCPoison).DeleteData("1")
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.PHCPoison).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.PHCPoison).%OpenId(id)
		s eobj = ##class(web.Entity.CT.PHCPoison).%New()
		s eobj.PHCPORowId = id
		//Code,Desc中有回车键
		s eobj.PHCPOCode = $p(pobj.PHCPOCode,$c(13,10),1)
		s eobj.PHCPODesc = $p(pobj.PHCPODesc,$c(13,10),1)
		s eobj.PHCPOOTCFlag=pobj.PHCPOOTCFlag 
		s eobj.PHCPOMHRpt=pobj.PHCPOMHRpt 
		s eobj.PHCPOSaleRpt=pobj.PHCPOSaleRpt 
		//s:pobj.PHCPOOTCFlag="Y" eobj.PHCPOOTCFlag="true" //checkbox
		//s eobj.PHCPOOTCFlag = pobj.PHCPOOTCFlag  //radio
		//s:pobj.PHCPOSaleRpt="Y" eobj.PHCPOSaleRpt="true" //checkbox
		//s:pobj.PHCPOMHRpt="Y" eobj.PHCPOMHRpt="true" //checkbox
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(User.PHCPoison).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Poison","User.PHCPoison","管制药品分类",id,eobj.PHCPODesc,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("管制药品分类","web.DHCBL.CT.PHCPoison","DeleteData",eobj)
	    	s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

}
