/// 名称:床位费时制关联时段信息 
/// 描述:包含增删改查功能
/// 编写者：鲁俊文
/// 编写日期: 2022-10-17
Class web.DHCBL.CT.BedFeeTimePeriod Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:鲁俊文
/// CreatDate:2022-09-21
/// Description：查询床位费时制关联时段信息
/// Table：CT_BDP_CT.BedFeeTimePeriod
/// Input：parref(父表Id),rowid
/// Return: RowId:RowId DateFrom:开始日期  DateTo:结束日期  
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BedFeeTimePeriod","GetList","1","")
Query GetList(parref As %String, rowid As %String) As %Query(ROWSPEC = "RowId:%String,ParRef:%String,DateFrom:%String,DateTo:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, parref As %String, rowid As %String) As %Status
{
	s ind=1
	s repid=$I(^CacheTemp)

	if (rowid'="") //根据rowid返回该条记录
	{
		s ChildSub=$p(rowid,"||",2) //子表ID
		s RowId=rowid //子表RowId
		s ParRef=$p(rowid,"||",1) //父表ID
		s DateFrom=$LISTGET($G(^CT.BDP.CT.BedFeeTimeD(ParRef,"TimePeriod",ChildSub)),2) //开始日期
		s DateTo=$LISTGET($G(^CT.BDP.CT.BedFeeTimeD(ParRef,"TimePeriod",ChildSub)),3)   //结束日期
		s:DateFrom'="" DateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateFrom)	//转日期格式
		s:DateTo'="" DateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateTo)	//转日期格式
		d OutputRow
	}
	else
	{
		if (parref'="")
		{	
			s ChildSub=0  
			for 
			{
				s ChildSub=$o(^CT.BDP.CT.BedFeeTimeD(parref,"TimePeriod",ChildSub)) q:ChildSub=""
				s RowId=parref_"||"_ChildSub  //子表ID
				s ParRef=parref ///父表ID
				s DateFrom=$LISTGET($G(^CT.BDP.CT.BedFeeTimeD(ParRef,"TimePeriod",ChildSub)),2) //开始日期
				s DateTo=$LISTGET($G(^CT.BDP.CT.BedFeeTimeD(ParRef,"TimePeriod",ChildSub)),3)   //结束日期
				s:DateFrom'="" DateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateFrom)	//转日期格式
				s:DateTo'="" DateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateTo)	//转日期格式
            	d OutputRow
        		
			}
		}

	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,ParRef,DateFrom,DateTo) 
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

/// Creator:鲁俊文
/// CreatDate:2022-09-09
/// Description:为combobox查询取数据(根据时制获取对应时段)
/// Table：CT_BDP_CT.BedFeeTime
/// Input：parref,rowid
/// Return: BedFeeTimeName:时制名称 RowId:RowId DateFrom:开始日期 DateTo:结束日期
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BedFeeTimePeriod","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "BedFeeTimeName:%String,RowId:%String,DateFrom:%String,DateTo:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{
		s ChildSub=$p(rowid,"||",2) //ChildSub
		s RowId=rowid //子表RowId
		s ParRef=$p(rowid,"||",1) ///父表ID
		s DateFrom=$LISTGET($G(^CT.BDP.CT.BedFeeTimeD(ParRef,"TimePeriod",ChildSub)),2) //开始日期
		s DateTo=$LISTGET($G(^CT.BDP.CT.BedFeeTimeD(ParRef,"TimePeriod",ChildSub)),3)   //结束日期
		s BedFeeTimeName=$lg($g(^CT.BDP.CT.BedFeeTimeD(ParRef)),3) //时制名称
		s:DateFrom'="" DateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateFrom) //转日期格式
		s:DateTo'="" DateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateTo)	//转日期格式
	    d OutputRowCmb
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s ParRef=0
		for
		{
			s ParRef=$o(^CT.BDP.CT.BedFeeTimeD(ParRef)) q:ParRef=""
	    	s ChildSub=0 
    		for 
    		{	
		        s ChildSub=$o(^CT.BDP.CT.BedFeeTimeD(ParRef,"TimePeriod",ChildSub)) q:ChildSub=""
				s RowId=ParRef_"||"_ChildSub  //子表ID
				s DateFrom=$LISTGET($G(^CT.BDP.CT.BedFeeTimeD(ParRef,"TimePeriod",ChildSub)),2) //开始日期
				s DateTo=$LISTGET($G(^CT.BDP.CT.BedFeeTimeD(ParRef,"TimePeriod",ChildSub)),3)   //结束日期
				s BedFeeTimeName=$lg($g(^CT.BDP.CT.BedFeeTimeD(ParRef)),3) //时制名称
				s:DateFrom'="" DateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateFrom)	//转日期格式
				s:DateTo'="" DateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateTo)	//转日期格式 
				continue:(DateFrom'="")&&(DateFrom>+$h)
				continue:(DateTo'="")&&(DateTo<+$h) //时间限制
				s PINYIN="" 
	        	s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BedFeeTimeName) 
		    	if (($ZCONVERT(BedFeeTimeName,"U")[desc)||(PINYIN[desc))
	        	{
	            	d OutputRowCmb
	        	} 
    		}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(BedFeeTimeName,RowId,DateFrom,DateTo)
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

/// Creator：鲁俊文
/// CreatDate: 2022-10-18
/// Description：日期校验
/// Table：CT_BDP_CT.BedFeeTimePeriod
/// Input：id datefrom dateto
/// Others：w ##class(web.DHCBL.CT.BedFeeTimePeriod).FormValidate(5,"5||7",66141,66393) 
ClassMethod FormValidate(parref As %String, rowid As %String, datefrom As %String, dateto As %String) As %String
{
	s flag=0 
	if (rowid="")
	{	
			s ChildSub=0  
			for 
			{
				s ChildSub=$o(^CT.BDP.CT.BedFeeTimeD(parref,"TimePeriod",ChildSub)) q:ChildSub="" 
				s RowId=parref_"||"_ChildSub  //子表ID
				s ParRef=parref ///父表ID
				s DateFrom=$LISTGET($G(^CT.BDP.CT.BedFeeTimeD(parref,"TimePeriod",ChildSub)),2) //子表开始日期
				s DateTo=$LISTGET($G(^CT.BDP.CT.BedFeeTimeD(parref,"TimePeriod",ChildSub)),3)   //子表结束日期								
				if ((dateto<DateFrom)||(DateTo<datefrom))
				{
					s flag=0
				}
				else
				{
					s flag=1
					q
				}
				
			}

	}
	else
	{
		s ChildSub=0 
    	for 
    	{
	        s ChildSub=$o(^CT.BDP.CT.BedFeeTimeD(parref,"TimePeriod",ChildSub)) q:ChildSub=""
			s RowId=parref_"||"_ChildSub  //子表ID
			s ParRef=parref ///父表ID
			continue:RowId=rowid
			s DateFrom=$LISTGET($G(^CT.BDP.CT.BedFeeTimeD(ParRef,"TimePeriod",ChildSub)),2) //子表开始日期
			s DateTo=$LISTGET($G(^CT.BDP.CT.BedFeeTimeD(ParRef,"TimePeriod",ChildSub)),3)   //子表结束日期				
			if ((dateto<DateFrom)||(DateTo<datefrom))
			{
				s flag=0
			}
			else
			{
				s flag=1
				q
			}  	
		}	
	}
 q flag
}

/// Creator:    鲁俊文
/// CreatDate:  2022-10-17
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// debug: w ##class(web.DHCBL.CT.BedFeeTimePeriod).OpenData("1||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""    
	s eobj = ##class(web.Entity.CT.BedFeeTimePeriod).%New()
	s obj = ##class(CT.BDP.CT.BedFeeTimePeriod).%OpenId(id)
	s eobj.RowId=id //RowId
	s eobj.ParRef=$P(id,"||",1) //ParRef
	s eobj.DateFrom= obj.DateFrom  //开始日期
	s eobj.DateTo= obj.DateTo    //结束日期
	s:eobj.DateFrom'="" eobj.DateFrom= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.DateFrom) //转日期格式
	s:eobj.DateTo'="" eobj.DateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.DateTo)       //转日期格式
	s str = eobj.JsonS()    
	d eobj.%Close()
	d obj.%Close()
	q str
}

/*/// Creator：鲁俊文
/// CreatDate: 2022年10月17日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.BedFeeTimePeriod).savetest()
ClassMethod savetest()
{
	
	s eobj=##class(web.Entity.CT.BedFeeTimePeriod).%New()
	s eobj.ParRef="1"
	s eobj.DateFrom="2022-10-18"
	s eobj.DateTo="2022-11-16"
	w ..SaveEntity(eobj)
}*/
/// Creator：鲁俊文
/// CreatDate: 2022-09-21
/// Description：保存床位费时制关联时段信息  
/// Table：CT_BDP_CT.BedFeeTimePeriod
/// Others：w ##class(web.DHCBL.CT.BedFeeTimePeriod).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.BedFeeTimePeriod) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.DateFrom'="" eobj.DateFrom= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DateFrom)	//开始日期
	    s:eobj.DateTo'="" eobj.DateTo= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DateTo)	//结束日期
	    s flag=..FormValidate(eobj.ParRef,eobj.RowId,eobj.DateFrom,eobj.DateTo)
	    if (flag=1)
	    {
		    q "{success:'false',errorinfo:'日期存在交叉！'}" 
	    }    
		if (eobj.RowId="")
		{
			s obj=##class(CT.BDP.CT.BedFeeTimePeriod).%New(eobj.ParRef)
		}
		else
		{
			s obj=##class(CT.BDP.CT.BedFeeTimePeriod).%OpenId(eobj.RowId)
			s bobj=##class(web.Entity.CT.BedFeeTimePeriod).%New()
		    s bobj.RowId=eobj.RowId      //RowId
		    s bobj.DateFrom=obj.DateFrom //开始日期
			s bobj.DateTo=obj.DateTo     //结束日期
			s SaveBlog=bobj.RowId
		}
		
		d:eobj.ParRef'="" obj.ParRefSetObjectId(eobj.ParRef) //修改数据时ParRef为空
		s obj.DateFrom= eobj.DateFrom	//开始日期
		s obj.DateTo= eobj.DateTo		//结束日期
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			s DateFromBlog= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.DateFrom)
			s DateToBlog=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.DateTo)
			s SaveBlog=id_"-"_DateFromBlog_"-"_DateToBlog
			d:eobj.RowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.BedFeeTimePeriod","CT.BDP.CT.BedFeeTimePeriod","时制关联时段信息",eobj.RowId,SaveBlog,"U",eobj,bobj)
			d:eobj.RowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.BedFeeTimePeriod","CT.BDP.CT.BedFeeTimePeriod","时制关联时段信息",eobj.RowId,SaveBlog,"A",eobj)
		}
		else
		{
			TRO
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("时制关联时段信息","web.DHCBL.CT.BedFeeTimePeriod","DeleteData",eobj)
	    	s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator:鲁俊文
/// CreatDate:2022-09-21
/// Description：根据ID删除床位费时制关联时段的内容
/// Table：CT_BDP_CT.BedFeeTimePeriod
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.BedFeeTimePeriod).DeleteData("1||2")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	//new Entity对象，用于保存日志
	s pobj = ##class(CT.BDP.CT.BedFeeTimePeriod).%OpenId(id)
	s eobj = ##class(web.Entity.CT.BedFeeTimePeriod).%New()
	s eobj.RowId = id				//RowId
	s eobj.DateFrom=pobj.DateFrom	//开始日期
	s eobj.DateTo=pobj.DateTo		//结束日期
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.BedFeeTimePeriod).%DeleteId(id)
	if $$$ISOK(sc)
	{
	    Tcommit
	    s result = "{success:'true',info:'删除成功！'}"  
	    //保存日志
	    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.BedFeeTimePeriod","CT.BDP.CT.BedFeeTimePeriod","时制关联时段信息",id,eobj.RowId,"D",eobj)
	    d eobj.%Close()
	}
	else 
	{
	    Trollback
	    s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("时制关联时段信息","web.DHCBL.CT.BedFeeTimePeriod","DeleteData",eobj)
	    s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	} 
	q result
}

}
