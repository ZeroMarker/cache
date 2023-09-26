Class web.DHCBL.KB.DHCPHManf Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2018-08-11
/// Description：获取修改时的记录
/// Table：User.DHCPHManf
/// Other: d ##class(web.DHCBL.KB.DHCPHManf).OpenData()
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPHManf).%New()
	s pobj = ##class(User.DHCPHManf).%OpenId(id)
	s eobj.PHMARowId = id
	s eobj.PHMACode = pobj.PHMACode
	s eobj.PHMADesc = pobj.PHMADesc
	s eobj.PHMAActiveFlag = pobj.PHMAActiveFlag
	s:pobj.PHMAActiveFlag="" eobj.PHMAActiveFlag="Y"
	s str = eobj.JsonS()	
	//s str = "{data:["_str_"]}"
	q str
}

/// Creator：李欣
/// CreatDate: 2017-11-28
/// Description：查询厂家表内容
/// Table：User.DHCPHManf
/// Input：rowid, code, desc,
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHManf","GetList","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "PHMARowId,PHMACode,PHMADesc,PHMAActiveFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s AuStr=##class(web.DHCBL.Authorize.DHCPHManf).DHCGetDataByDefaultSession()
	s AuFlag=0
	;未授权情况下，默认显示全部数据
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHMARowId=rowid 
		s PHMACode=$p($g(^DHCPHMANF(PHMARowId)),"^",1)  //代码
		s PHMADesc=$p($g(^DHCPHMANF(PHMARowId)),"^",2)  //描述
		s PHMAActiveFlag=$p($g(^DHCPHMANF(PHMARowId)),"^",3)  //是否可用
		s:PHMAActiveFlag="" PHMAActiveFlag="Y"
		
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s PHMARowId=0
		for  
		{	
			s PHMARowId=$o(^DHCPHMANF(PHMARowId)) q:PHMARowId="" 
			s strRowId="{ID:"_PHMARowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHMACode=$p($g(^DHCPHMANF(PHMARowId)),"^",1)  //代码
				s PHMACodeU=$ZCONVERT(PHMACode,"U")
				s PHMADesc=$p($g(^DHCPHMANF(PHMARowId)),"^",2)  //描述
				s PHMADescU=$ZCONVERT(PHMADesc,"U")
				s PHMAActiveFlag=$p($g(^DHCPHMANF(PHMARowId)),"^",3)  //是否可用
				s:PHMAActiveFlag="" PHMAActiveFlag="Y"
				
				//别名查询
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","DHC_PHManf",PHMARowId,AliasRowId))
					q:AliasRowId=""
					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
					
				}
				s PINYIN=""
				if ((ALIASText1="")&(desc'=""))
				{
				 	s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHMADescU))
				}
				i (PHMACodeU[code)&((PHMADescU[desc)||(PINYIN[desc)||(ALIASText1[desc))   //条件
				{
					d OutputRow
				}
			}		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHMARowId,PHMACode,PHMADesc,PHMAActiveFlag)
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

/// Creator:李欣
/// CreatDate:2017-11-28
/// Description:下拉框查询
/// Input:desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHManf","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "PHMARowId:%String,PHMADesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
	s AuStr=##class(web.DHCBL.Authorize.DHCPHManf).DHCGetDataByDefaultSession()
	s AuFlag=0
	;未授权情况下，默认显示全部数据
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1    
    
    if (rowid'="")
    {
        s PHMARowId=rowid
        s PHMADesc=$p($g(^DHCPHMANF(PHMARowId)),"^",2)
        s PHMAActiveFlag=$p($g(^DHCPHMANF(PHMARowId)),"^",3)  //是否可用
        d:PHMAActiveFlag'="N" OutputRowCmb
    }
    else
    {

        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s PHMARowId=0
        for
        {
            s PHMARowId=$o(^DHCPHMANF(PHMARowId)) q:PHMARowId=""
			s strRowId="{ID:"_PHMARowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
	            s PHMADesc=$p($g(^DHCPHMANF(PHMARowId)),"^",2)
	            s PHMAActiveFlag=$p($g(^DHCPHMANF(PHMARowId)),"^",3)  //是否可用
	            continue:PHMAActiveFlag="N"
	            s PHMADesc1=$ZCONVERT(PHMADesc,"U")
	            s PINYIN=""
	            s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHMADesc1))
	            i ((PHMADesc1[desc)||(PINYIN[desc))
	            {
	                d OutputRowCmb
	            }
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PHMARowId,PHMADesc)
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
        //if there are no more rows,finish fetching
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
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 李欣
/// CreateDate:2017-11-28
/// w ##class(web.DHCBL.KB.DHCPHManf).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^DHCPHMANF(0,"Code",code))
	s:desc'="" flagd=$d(^DHCPHMANF(0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^DHCPHMANF(0,"Code",code,0))
		s:desc'="" idd=$o(^DHCPHMANF(0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：李欣
/// CreatDate: 2017-11-28
/// Description：保存修改内容
/// Table：User.DHCPHManf
/// Input：web.Entity.KB.DHCPHManf 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHManf, hacom) As %String
{
	
	s result = ""
	if $IsObject(eobj)
	{
				
		s flag=..FormValidate(eobj.PHMARowId,eobj.PHMACode,eobj.PHMADesc)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
		}
		else
		{
			if (eobj.PHMARowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCPHManf).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCPHManf).%OpenId(eobj.PHMARowId)				
				s bobj = ##class(web.Entity.KB.DHCPHManf).%New()
				s bobj.PHMARowId = eobj.PHMARowId
				s bobj.PHMACode = obj.PHMACode
				s bobj.PHMADesc = obj.PHMADesc
				s bobj.PHMAActiveFlag= obj.PHMAActiveFlag
			}
	
			s obj.PHMACode = eobj.PHMACode
			s obj.PHMADesc = eobj.PHMADesc
			i eobj.PHMAActiveFlag="Y"
			{
				s obj.PHMAActiveFlag = "Y"
			}
			else
			{
				s obj.PHMAActiveFlag = "N"
			}
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.PHMARowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHManf","User.DHCPHManf","厂家字典表",id,eobj.PHMADesc,"A",eobj)
				d:eobj.PHMARowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHManf","User.DHCPHManf","厂家字典表",eobj.PHMARowId,eobj.PHMADesc,"U",eobj,bobj)
				if ((eobj.PHMARowId="")&(hacom'="Y"))
				{
					s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(eobj.PHMADesc))
					s listData="^DHC_PHManf^"_PINYIN_"^"_id
					d ##class(web.DHCBL.BDP.BDPAlias).SaveEntity(listData)
				}
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("厂家字典表","web.DHCBL.KB.DHCPHManf","SaveData",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
		}	
	}	

	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// Creator：李欣
/// CreatDate: 2017-11-28
/// Description：获取修改时的记录
/// Table：User.DHCPHManf
/// Other: d ##class(web.DHCBL.KB.DHCPHManf).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPHManf).%New()
	s pobj = ##class(User.DHCPHManf).%OpenId(id)
	s eobj.PHMARowId = id
	s eobj.PHMACode = pobj.PHMACode
	s eobj.PHMADesc = pobj.PHMADesc
	s:pobj.PHMAActiveFlag="Y" eobj.PHMAActiveFlag="true"
	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHManf).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="", myInfo=""
	
	s flag=0
	;User.DHCPHProName
	if ($d(^DHCPHPNA(0,"Manf",id)))
	{
		s flag=1
		s myInfo=myInfo_"<药品商品名字典表>"	
	}
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"里被引用,不能删除!"
 	q return
}

/// Creator:李欣
/// CreatDate:2016-11-28
/// Description:根据id删除
/// Table:User.DHCPHExtIngr
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHManf).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
	s re=##class(web.DHCBL.KB.DHCPHManf).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		Tstart
		s eobj = ##class(web.Entity.KB.DHCPHManf).%New()
		s pobj = ##class(User.DHCPHManf).%OpenId(id)
		s eobj.PHMARowId = id
		s eobj.PHMACode = pobj.PHMACode
		s eobj.PHMADesc = pobj.PHMADesc
		s eobj.PHMAActiveFlag = pobj.PHMAActiveFlag
		s sc=##class(User.DHCPHManf).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHManf","User.DHCPHManf","厂家字典表",id,eobj.PHMADesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("厂家字典表","web.DHCBL.KB.DHCPHManf","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

}
