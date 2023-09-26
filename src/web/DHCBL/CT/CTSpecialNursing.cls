/// 项目：重庆人民医院，添加专项护理字典维护界面
/// 描述: 专项护理，包含增删改查等功能
/// 表名：CTSpecialNursing
/// 编写者：基础数据平台组 李可凡
/// 编写日期: 2019年8月22日
Class web.DHCBL.CT.CTSpecialNursing Extends %RegisteredObject
{

/// Creator：李可凡
/// CreatDate: 2019年8月27日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.CTSpecialNursing).Test()
ClassMethod Test()
{
	s obj=##class(web.Entity.CT.CTSpecialNursing).%New()
	s obj.SpecialNursingRowId="1"
	s obj.SpecialNursingCode="01"
	s obj.SpecialNursingDesc="洗头"
	s obj.SpecialNursingRemark="每两天一次"
	w ..SaveEntity(obj)
}

/// Creator：李可凡
/// CreatDate: 2019年8月27日
/// Description：提供专项护理字典表下拉列表
/// Table：User.CTSpecialNursing
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTSpecialNursing","GetDataForCmb1","","")
Query GetDataForCmb1(rowid, desc) As %Query(ROWSPEC = "SpecialNursingRowId,SpecialNursingDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:desc'="" desc=$ZCONVERT(desc,"U")
	if (rowid'="") //根据rowid返回该条记录
	{
		s SpecialNursingRowId=rowid
		s SpecialNursingDesc=$lg($g(^User.CTSpecialNursingD(SpecialNursingRowId)),3)  //专项护理名
		d OutputRow1
	}
	else
	{
		s SpecialNursingRowId=0
	 	for
	 	{
		 	s SpecialNursingRowId=$O(^User.CTSpecialNursingD(SpecialNursingRowId))
		 	q:SpecialNursingRowId=""
		 	s SpecialNursingDesc=$lg($g(^User.CTSpecialNursingD(SpecialNursingRowId)),3)
		 	if ($ZCONVERT(SpecialNursingDesc,"U")[desc)
		 	{
				d OutputRow1
			}

		}
	}
	
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    set Data=$lb(SpecialNursingRowId,SpecialNursingDesc)
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

/// Creator：李可凡
/// CreatDate: 2019年8月27日
/// Description：查询专项护理字典表
/// Table：User.CTSpecialNursing
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTSpecialNursing","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "SpecialNursingRowId,SpecialNursingCode,SpecialNursingDesc,SpecialNursingRemark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	if (rowid'="")
 	{
	 	s SpecialNursingRowId=rowid
	 	s SpecialNursingCode=$lg($g(^User.CTSpecialNursingD(SpecialNursingRowId)),2) //代码
	 	s SpecialNursingDesc=$lg($g(^User.CTSpecialNursingD(SpecialNursingRowId)),3) //描述
	 	s SpecialNursingRemark=$lg($g(^User.CTSpecialNursingD(SpecialNursingRowId)),4) //备注
	 	d OutputRow
	 }
	 else
	 {
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")	 
	 	s SpecialNursingRowId=0
	 	for
	 	{
		 	s SpecialNursingRowId=$O(^User.CTSpecialNursingD(SpecialNursingRowId))
		 	q:SpecialNursingRowId=""
		 	s SpecialNursingCode=$lg($g(^User.CTSpecialNursingD(SpecialNursingRowId)),2) //代码
		 	s SpecialNursingDesc=$lg($g(^User.CTSpecialNursingD(SpecialNursingRowId)),3) //描述
		 	s SpecialNursingRemark=$lg($g(^User.CTSpecialNursingD(SpecialNursingRowId)),4) //备注
		 	
		 	if (desc'="")
	        {
		        ;需要对描述或者别名进行检索      
		        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CTSpecialNursing",SpecialNursingRowId,SpecialNursingDesc,desc)
	        }
		   	else
	        {
	         	s AliasFlag= 1   
	        } 
		 	if ($ZCONVERT(SpecialNursingCode,"U")[code)&(AliasFlag=1)
		 	{
				d OutputRow
			}

		}
	 }
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(SpecialNursingRowId,SpecialNursingCode,SpecialNursingDesc,SpecialNursingRemark)
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

/// Creator：李可凡
/// CreatDate: 2019年8月22日
/// Description：专项护理字典表新增修改
/// Table：User.CTSpecialNursing
/// Input：SpecialNursingRowId SpecialNursingCode SpecialNursingDesc SpecialNursingRemark
/// Ohter：
ClassMethod SaveEntity(eobj As web.Entity.CT.CTSpecialNursing) As %String
{
	s result=""
	if (eobj.SpecialNursingRowId="")
	{
		s obj=##class(User.CTSpecialNursing).%New()
	}
	else
	{
		s obj=##class(User.CTSpecialNursing).%OpenId(eobj.SpecialNursingRowId)
		s bobj=##class(web.Entity.CT.CTSpecialNursing).%New()
	    s bobj.SpecialNursingRowId=eobj.SpecialNursingRowId
	    s bobj.SpecialNursingCode = obj.SpecialNursingCode
	    s bobj.SpecialNursingDesc= obj.SpecialNursingDesc
	    s bobj.SpecialNursingRemark = obj.SpecialNursingRemark
	}
	if (obj)
	{
		s obj.SpecialNursingCode=eobj.SpecialNursingCode
		s obj.SpecialNursingDesc=eobj.SpecialNursingDesc
		s obj.SpecialNursingRemark=eobj.SpecialNursingRemark
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.SpecialNursingRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CTSpecialNursing","User.CTSpecialNursing","专项护理字典",eobj.SpecialNursingRowId,eobj.SpecialNursingDesc,"U",eobj,bobj)
    		d:eobj.SpecialNursingRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CTSpecialNursing","User.CTSpecialNursing","专项护理字典",id,eobj.SpecialNursingDesc,"A",eobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
		k obj
		k eobj
	}
	q result
}

/// Creator：李可凡
/// CreatDate: 2019年8月27日
/// function:专项护理字典表数据删除
/// Table：User.CTSpecialNursing
/// w ##class(web.DHCBL.CT.CTSpecialNursing).DeleteData(8)
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		
		s pobj = ##class(User.CTSpecialNursing).%OpenId(id)
		s eobj = ##class(web.Entity.CT.CTSpecialNursing).%New()
		s eobj.SpecialNursingRowId = id
		S eobj.SpecialNursingCode=pobj.SpecialNursingCode
		s eobj.SpecialNursingDesc= pobj.SpecialNursingDesc
		s eobj.SpecialNursingRemark=pobj.SpecialNursingRemark
		TSTART
		s sc=##class(User.CTSpecialNursing).%DeleteId(id)
		if (sc=1)
		{
			TCOMMIT
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CTSpecialNursing","User.CTSpecialNursing","专项护理字典",id,eobj.SpecialNursingDesc,"D",eobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
	}
	else
	{
		s result="{success:'false',info:'数据不存在！'}"
	}
	q result
}

/// Creator：李可凡
/// CreatDate: 2019年8月27日
/// function:专项护理字典表行数据加载
/// Input:id
/// Table：User.CTSpecialNursing
/// Others :w ##class(web.DHCBL.CT.CTSpecialNursing).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	 s str=""
	 s pobj = ##class(User.CTSpecialNursing).%OpenId(id)
	 s eobj = ##class(web.Entity.CT.CTSpecialNursing).%New()
	 s eobj.SpecialNursingRowId = id
	 S eobj.SpecialNursingCode=pobj.SpecialNursingCode
	 s eobj.SpecialNursingDesc= pobj.SpecialNursingDesc
	 s eobj.SpecialNursingRemark=pobj.SpecialNursingRemark
	 d pobj.%Close()
	 k pobj
	 s str = eobj.JsonS()
	 s str = "{list:["_str_"]}"
	 q str
}

/// Function:数据校验功能
/// Creator:李可凡
/// CreateDate:2019年8月29日  
/// w ##class(web.DHCBL.CT.CTSpecialNursing).FormValidate("","01","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^User.CTSpecialNursingI("SpNurCodeIndex"," "_code))
	s:desc'="" flagd=$d(^User.CTSpecialNursingI("SpNurDescIndex"," "_desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0)||(flagd>0)
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
		s:code'="" idc=$o(^User.CTSpecialNursingI("SpNurCodeIndex"," "_code,0))
		s:desc'="" idd=$o(^User.CTSpecialNursingI("SpNurDescIndex"," "_desc,0))
		if (desc="")
		{
			if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		else
		{
			if (code="")
			{
				if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
				else  s flag=0 //返回不重复标志
			}
			else
			{
				if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1 //返回重复标志
				else  s flag=0 //返回不重复标志
			}
		}	
	}
	q flag
}

}
