Import SQLUser

/// 名称:药学 6药理学分类
/// 描述:药理学分类维护，包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹 
/// 编写日期:  2012-8-30
Class web.DHCBL.CT.PHCCat Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：陈莹 		
/// CreatDate: 2012-8-29
/// Description：查询 药理学分类
/// Table：User.PHCCat
/// Input：rowid,code,desc
/// Output:PHCCRowId,PHCCCode,PHCCDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCCat","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCCRowId:%String,PHCCCode:%String,PHCCDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHCCRowId=rowid
		s PHCCCode=$p($g(^PHCC(PHCCRowId)),"^",1)
		s PHCCDesc=$p($g(^PHCC(PHCCRowId)),"^",2)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Cat",PHCCRowId)
		s BDPInternalCode =$p($g(resultStr),"^",1)
		s BDPInternalDesc = $p($g(resultStr),"^",2)
		s BDPHospNationalCode=$p($g(resultStr),"^",3)  
		s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s AuStr=##class(web.DHCBL.Authorize.PHCCat).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCCRowId=0
		for
		{
			s PHCCRowId=$o(^PHCC(PHCCRowId)) q:(PHCCRowId="SC_Code")||(PHCCRowId="MIN_Code")   ;此处例外,不是在PHCCRowId为空的情况下quit
			s strRowId="{ID:"_PHCCRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCCCode=$p($g(^PHCC(PHCCRowId)),"^",1)
				s PHCCDesc=$p($g(^PHCC(PHCCRowId)),"^",2)
				s PHCCCode1=$ZCONVERT(PHCCCode,"U")
				s PHCCDesc1=$ZCONVERT(PHCCDesc,"U")
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Cat",PHCCRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)
				s BDPInternalDesc = $p($g(resultStr),"^",2)
				s BDPHospNationalCode=$p($g(resultStr),"^",3)  
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		
				//别名查询
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PHC_Cat",PHCCRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
					
				}
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHCCDesc1)
				i (PHCCCode1[code)&((PHCCDesc1[desc)||(ALIASText1[desc)||(PINYIN[desc))
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHCCRowId,PHCCCode,PHCCDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Description：查询 药理学分类for combo
/// Table：User.PHCCat
/// Input：code,desc
/// Output:PHCCRowId,PHCCCode,PHCCDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCCat","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCCRowId:%String,PHCCCode:%String,PHCCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{
		s PHCCRowId=rowid
		s PHCCCode=$p($g(^PHCC(PHCCRowId)),"^",1)
		s PHCCDesc=$p($g(^PHCC(PHCCRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s AuStr=##class(web.DHCBL.Authorize.PHCCat).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCCRowId=0
		for
		{
			s PHCCRowId=$o(^PHCC(PHCCRowId)) q:(PHCCRowId="SC_Code")||(PHCCRowId="MIN_Code")   ;此处例外,不是在PHCCRowId为空的情况下quit
			s strRowId="{ID:"_PHCCRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCCCode=$p($g(^PHCC(PHCCRowId)),"^",1)
				s PHCCDesc=$p($g(^PHCC(PHCCRowId)),"^",2)
				s PHCCCode1=$ZCONVERT(PHCCCode,"U")
				s PHCCDesc1=$ZCONVERT(PHCCDesc,"U")
				
				//别名查询
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PHC_Cat",PHCCRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHCCDesc1)
				i (PHCCCode1[code)&((PHCCDesc1[desc)||(ALIASText1[desc)||(PINYIN[desc))
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(PHCCRowId,PHCCCode,PHCCDesc)
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
/// CreatDate:2012-12-24
/// Description:数据重复验证方法,js调用
/// Table:User.PHCCat
/// Input:id, code, name
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PHCCat).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^PHCC(0,"Code",code))
	s:desc'="" flagd=$d(^PHCC(0,"Desc",desc))
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
		s:code'="" idc=$o(^PHCC(0,"Code",code,0))
		s:desc'="" idd=$o(^PHCC(0,"Desc",desc,0))
	
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
			
	}
	q flag
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：新增、修改时打开Form，根据RowId查询
/// Table：User.PHCCat
/// Others:d ##class(web.DHCBL.CT.PHCCat).OpenData(5)
ClassMethod OpenData(PHCCRowId As %String) As %String
{
    s str = ""
	s pobj = ##class(User.PHCCat).%OpenId(PHCCRowId)
	s eobj = ##class(web.Entity.CT.PHCCat).%New()
	s eobj.PHCCRowId = PHCCRowId
	s eobj.PHCCCode  = pobj.PHCCCode
	s eobj.PHCCDesc = pobj.PHCCDesc
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹 
/// CreatDate: 2012-8-3
/// Description：添加/修改 药理学分类
/// Table：User.PHCCat
ClassMethod SaveEntity(eobj As web.Entity.CT.PHCCat) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{	
		if (eobj.PHCCRowId="")
		{	
	        s obj=##class(User.PHCCat).%New()
		}
		else
		{
			s obj=##class(User.PHCCat).%OpenId(eobj.PHCCRowId)
			
			s bobj=##class(web.Entity.CT.PHCCat).%New()
			s bobj.PHCCRowId = eobj.PHCCRowId
			s bobj.PHCCCode = obj.PHCCCode
			s bobj.PHCCDesc = obj.PHCCDesc
		}
				
		s obj.PHCCCode = eobj.PHCCCode
		s obj.PHCCDesc = eobj.PHCCDesc
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.PHCCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Cat","User.PHCCat","药理学分类",id,eobj.PHCCDesc,"A",eobj)
			d:eobj.PHCCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Cat","User.PHCCat","药理学分类",id,eobj.PHCCDesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药理学分类","web.DHCBL.CT.PHCCat","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
			s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROR
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药理学分类","web.DHCBL.CT.PHCCat","SaveEntity",eobj)
	s ^ERRORLOGINFO(logid)=$ze
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:陈莹
/// CreatDate:2013-8-22
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	s PHCSCChildSub=0,flag=0
	for
	{
		s PHCSCChildSub=$o(^PHCC(id,"SC",PHCSCChildSub)) q:(PHCSCChildSub="")||(flag=1)
		s PHCSCRowId=id_"||"_PHCSCChildSub	
		s MINChildsub=0
		for
		{
			s MINChildsub=$o(^PHCC(id,"SC",PHCSCChildSub,"MIN",MINChildsub)) q:(MINChildsub="")||(flag=1)
			s MINRowId=id_"||"_PHCSCChildSub_"||"_MINChildsub
			s PHCDRowId=0
			for
			{
				s PHCDRowId=$o(^PHCD(PHCDRowId)) q:(PHCDRowId="")||(flag=1)
				s PHCDPHCSCDR=$p($g(^PHCD(PHCDRowId,1)),"^",3)
				i PHCDPHCSCDR=PHCSCRowId
				{
					s flag=1
					s myInfo=myInfo_"<该分类的子分类在药学项>"
				}
				s PHCDMinSubCatDR=$p($g(^PHCD(PHCDRowId,1)),"^",6)
				i PHCDMinSubCatDR=MINRowId
				{
					s flag=1
					s myInfo=myInfo_"<其小子分类在药学项表>"
				}
			}
		}
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator:陈莹 
/// CreatDate:2012-8-30
/// Description:根据id删除 药理学分类
/// Table:User.PHCCat
/// Input:id 
/// Return:成功返回true和info，失败返回false和info
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.PHCCat).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.PHCCat).%OpenId(id)
		s eobj = ##class(web.Entity.CT.PHCCat).%New()
		s eobj.PHCCRowId = id
		s eobj.PHCCCode  = pobj.PHCCCode
		s eobj.PHCCDesc = pobj.PHCCDesc
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(User.PHCCat).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Cat","User.PHCCat","药理学分类",id,eobj.PHCCDesc,"D",eobj)
		}
		else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药理学分类","web.DHCBL.CT.PHCCat","DeleteData",eobj)
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
