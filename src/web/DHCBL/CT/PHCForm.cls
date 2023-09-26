Import SQLUser

/// 名称:药学 7药品剂型
/// 描述:药品剂型维护，包含增删改查功能
/// 编写者：基础数据平台组 - 陈莹 
/// 编写日期:  2012-8-30
Class web.DHCBL.CT.PHCForm Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹 		
/// CreatDate: 2012-8-29
/// Description：查询 药品剂型
/// 注意:code和desc有些数据有回车^PHCF(32) = "普通片剂"_$c(13,10)_"^普通片剂"_$c(13,10) 
/// Table：User.PHCForm
/// Input：rowid, code, desc
/// Output:PHCFRowId,PHCFCode,PHCFDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCForm","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCFRowId:%String,PHCFCode:%String,PHCFDesc:%String ,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHCFRowId=rowid
		s PHCFCode=$p($g(^PHCF(PHCFRowId)),"^",1)
		s PHCFDesc=$p($g(^PHCF(PHCFRowId)),"^",2)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Form",PHCFRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.PHCForm).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCFRowId=0
		for
		{
			s PHCFRowId=$o(^PHCF(PHCFRowId)) q:PHCFRowId=""
			s strRowId="{ID:"_PHCFRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCFCode=$p($g(^PHCF(PHCFRowId)),"^",1) //"普通片剂"_$c(13,10)_"
				s PHCFDesc=$p($g(^PHCF(PHCFRowId)),"^",2)
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Form",PHCFRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)
				s BDPInternalDesc = $p($g(resultStr),"^",2)
				s BDPHospNationalCode=$p($g(resultStr),"^",3)  
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Form",PHCFRowId,PHCFDesc,desc)
				}
				else
				{
					s AliasFlag=1
				}
				i ($ZCONVERT(PHCFCode,"U")[code)&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHCFRowId,PHCFCode,PHCFDesc ,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Description：查询 药品剂型for combo
/// 注意:code和desc有些数据有回车^PHCF(32) = "普通片剂"_$c(13,10)_"^普通片剂"_$c(13,10) 
/// Table：User.PHCForm
/// Input： code, desc
/// Output:PHCFRowId,PHCFCode,PHCFDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCForm","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCFRowId:%String,PHCFCode:%String,PHCFDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHCFRowId=rowid
		s PHCFCode=$p($g(^PHCF(PHCFRowId)),"^",1)
		s PHCFDesc=$p($g(^PHCF(PHCFRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.PHCForm).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCFRowId=0
		for
		{
			s PHCFRowId=$o(^PHCF(PHCFRowId)) q:PHCFRowId=""
			s strRowId="{ID:"_PHCFRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCFCode=$p($g(^PHCF(PHCFRowId)),"^",1) //"普通片剂"_$c(13,10)_"
				s PHCFDesc=$p($g(^PHCF(PHCFRowId)),"^",2)
				s PHCFCode1=$ZCONVERT(PHCFCode,"U")
				s PHCFDesc1=$ZCONVERT(PHCFDesc,"U")
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Form",PHCFRowId,PHCFDesc,desc)
				}
				else
				{
					s AliasFlag=1
				}
				i ($ZCONVERT(PHCFCode,"U")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(PHCFRowId,PHCFCode,PHCFDesc)
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
/// Table:User.PHCForm
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.PHCForm).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^PHCF(0,"Code",code))
	s:desc'="" flagd=$d(^PHCF(0,"Desc",desc))
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
		s:code'="" idc=$o(^PHCF(0,"Code",code,0))
		s:desc'="" idd=$o(^PHCF(0,"Desc",desc,0))
		
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
			
	}
	q flag
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.PHCForm
/// Return：Json格式的字符串(即：form表单中对应的数据项)
ClassMethod OpenData(PHCFRowId As %String) As %String
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
	s pobj = ##class(User.PHCForm).%OpenId(PHCFRowId)
	s eobj = ##class(web.Entity.CT.PHCForm).%New()
	s eobj.PHCFRowId = PHCFRowId
	//Code,Desc中有回车换行键
	s eobj.PHCFCode = $p(pobj.PHCFCode,$c(13,10),1)
	s eobj.PHCFDesc = $p(pobj.PHCFDesc,$c(13,10),1)
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：保存 药品剂型
/// Table：User.PHCPHCForm
/// Return:成功返回true，失败返回false
ClassMethod SaveEntity(eobj As web.Entity.CT.PHCForm) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{	
		s flag=..FormValidate(eobj.PHCFRowId,eobj.PHCFCode,eobj.PHCFDesc)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.PHCFRowId="")
		{	
	        s obj=##class(User.PHCForm).%New()
		}
		else
		{
			s obj=##class(User.PHCForm).%OpenId(eobj.PHCFRowId)
			
			s bobj = ##class(web.Entity.CT.PHCForm).%New()
			s bobj.PHCFRowId = eobj.PHCFRowId
			s bobj.PHCFCode = obj.PHCFCode
			s bobj.PHCFDesc = obj.PHCFDesc
		}
				
		s obj.PHCFCode = $p(eobj.PHCFCode,$c(13,10),1) 
		s obj.PHCFDesc = $p(eobj.PHCFDesc,$c(13,10),1)
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.PHCFRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Form","User.PHCForm","药品剂型",id,eobj.PHCFDesc,"A",eobj)
			d:eobj.PHCFRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Form","User.PHCForm","药品剂型",id,eobj.PHCFDesc,"U",eobj,bobj)
			if (eobj.DataAlias'="")  //2017-2-8 自动添加别名到BDPAlias表
			{
				s length=$l(eobj.DataAlias,"/")
				for aliasi=1:1:length
				{
					s alias=$p(eobj.DataAlias,"/",aliasi)
					s:alias'="" aliasstr=##class(web.DHCBL.BDP.BDPAlias).Insert("PHC_Form",alias,id)
				}
			}
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品剂型","web.DHCBL.CT.PHCForm","SaveEntity",eobj)
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
	i ($d(^PHCD("DF_Form",+id))'=0)
	{
		s myInfo=myInfo_"<药学项-药物形态设定>"
	}
	
	s PHCFCode=$p($g(^PHCF(id)),"^",1)
	i ($o(^DHCPHFOCON(0,"HisCode",PHCFCode,"")))
	{
		s myInfo=myInfo_"<剂型对照表>"
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Modified By 陈莹，2013-8-2
/// Description：根据id删除 药品剂型
/// Table：User.PHCForm
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
/// w ##class(web.DHCBL.CT.PHCForm).DeleteData("174")
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.PHCForm).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.PHCForm).%OpenId(id)
		s eobj = ##class(web.Entity.CT.PHCForm).%New()
		s eobj.PHCFRowId = id
		//Code,Desc中有回车换行键
		s eobj.PHCFCode = $p(pobj.PHCFCode,$c(13,10),1)
		s eobj.PHCFDesc = $p(pobj.PHCFDesc,$c(13,10),1)
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(User.PHCForm).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Form","User.PHCForm","药品剂型",id,eobj.PHCFDesc,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品剂型","web.DHCBL.CT.PHCForm","DeleteData",eobj)
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
