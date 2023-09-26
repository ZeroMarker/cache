/// 名称:  节假日特殊业务代码维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2018-02-05
Class web.DHCBL.CT.BDPSpecialService Extends %RegisteredObject
{

/// Creator：陈莹
/// CreatDate: 2018-02-05
/// Description：数据重复验证方法,js调用
/// Table：User.BDPSpecialService
/// Input：id, code,desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT("BDPSS",0,"Code",code))
	s:desc'="" flagd=$d(^CT("BDPSS",0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		
		s idc="",idd=""
		s:code'="" idc=$o(^CT("BDPSS",0,"Code",code,0))
		s:desc'="" idd=$o(^CT("BDPSS",0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：陈莹
/// CreatDate:2018-02-05
/// Description：保存修改节假日特殊业务代码表的内容
/// Table：User.BDPSpecialService
/// Input：web.Entity.CT.BDPSpecialService 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.BDPSpecialService).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.BDPSpecialService) As %String
{
	s result = ""
	if $IsObject(eobj)
	{
		s:eobj.BDPSSTimeRangeFlag="" eobj.BDPSSTimeRangeFlag="N"
		s flag=..FormValidate(eobj.BDPSSRowId,eobj.BDPSSCode,eobj.BDPSSDesc)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.BDPSSRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.BDPSpecialService).%New()
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.BDPSpecialService).%OpenId(eobj.BDPSSRowId)
				s bobj=##class(web.Entity.CT.BDPSpecialService).%New()
				s bobj.BDPSSRowId = eobj.BDPSSRowId
				s bobj.BDPSSCode = obj.BDPSSCode          
				s bobj.BDPSSDesc = obj.BDPSSDesc          	
				s bobj.BDPSSTimeRangeFlag = obj.BDPSSTimeRangeFlag			
				s bobj.BDPSSRemark = obj.BDPSSRemark
			}
			Ts	        		        	
			s obj.BDPSSCode = eobj.BDPSSCode          //修改代码
			s obj.BDPSSDesc = eobj.BDPSSDesc          //修改描述			
			s obj.BDPSSTimeRangeFlag=eobj.BDPSSTimeRangeFlag			
			s obj.BDPSSRemark = eobj.BDPSSRemark
			s sc = obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
				//保存日志
				d:eobj.BDPSSRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_SpecialService","User.BDPSpecialService","节假日特殊业务代码",id,eobj.BDPSSDesc,"A",eobj)
				d:eobj.BDPSSRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_SpecialService","User.BDPSpecialService","节假日特殊业务代码",eobj.BDPSSRowId,eobj.BDPSSDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("节假日特殊业务代码","web.DHCBL.CT.BDPSpecialService","SaveEntity",eobj)
    			s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// 删除时验证数据是否被引用
ClassMethod GetRefFlag(id As %String) As %String
{
	
	s return="",myInfo=""
	
	i $d(^CT("BDPHS",0,"Service",id)) s myInfo=myInfo_"<节假日与特殊业务关联表>"
 	
 	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用,不能删除!"
 	q return
}

/// Creator：陈莹
/// CreatDate: 2018-02-05
/// Description：根据ID删除节假日特殊业务代码表的内容
/// Table：User.BDPSpecialService
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//验证是否被引用
	s re=..GetRefFlag(id)
	if ($p(re,"^",1)) {
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		s eobj = ##class(web.Entity.CT.BDPSpecialService).%New()
		s eobj.BDPSSRowId = id
		s eobj.BDPSSCode = $p($g(^CT("BDPSS",id)),"^",1)
		s eobj.BDPSSDesc = $p($g(^CT("BDPSS",id)),"^",2)	
		s eobj.BDPSSRemark = $p($g(^CT("BDPSS",id)),"^",3)
		s eobj.BDPSSTimeRangeFlag = $p($g(^CT("BDPSS",id)),"^",4)
		ts
		s sc = ##class(User.BDPSpecialService).%DeleteId(id)
		if $$$ISOK(sc)
		{
			tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_SpecialService","User.BDPSpecialService","节假日特殊业务代码",id,eobj.BDPSSDesc,"D",eobj)
			d eobj.%Close()
		}
		else 
		{
			tro
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("节假日特殊业务代码","web.DHCBL.CT.BDPSpecialService","DeleteData",eobj)
   			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2018-02-05
/// Description：修改时打开的数据/EXTJS
/// Table：User.BDPSpecialService
/// Input：id
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
	s str=""	
	s eobj = ##class(web.Entity.CT.BDPSpecialService).%New()
	s eobj.BDPSSRowId = id
	s eobj.BDPSSCode = $p($g(^CT("BDPSS",id)),"^",1)
	s eobj.BDPSSDesc = $p($g(^CT("BDPSS",id)),"^",2)	
	s eobj.BDPSSRemark = $p($g(^CT("BDPSS",id)),"^",3)
	s eobj.BDPSSTimeRangeFlag = $p($g(^CT("BDPSS",id)),"^",4)	
	if RetFlag="" 
	{
		s:eobj.BDPSSTimeRangeFlag="Y" eobj.BDPSSTimeRangeFlag="true"	
	}
	s str = eobj.JsonS()	
	d eobj.%Close()
	if RetFlag="" s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹
/// CreatDate: 2018-02-05
/// Description：查询节假日特殊业务代码表的内容
/// Table：User.BDPSpecialService
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPSpecialService","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BDPSSRowId:%String,BDPSSCode:%String,BDPSSDesc:%String,BDPSSRemark:%String,BDPSSTimeRangeFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s BDPSSRowId = rowid
		s BDPSSCode = $p($g(^CT("BDPSS",BDPSSRowId)),"^",1)
		s BDPSSDesc = $p($g(^CT("BDPSS",BDPSSRowId)),"^",2)	
		s BDPSSRemark = $p($g(^CT("BDPSS",BDPSSRowId)),"^",3)
		s BDPSSTimeRangeFlag = $p($g(^CT("BDPSS",BDPSSRowId)),"^",4)
		
		d OutputRow
	}
	else
	{
		s:code'="" code=$zcvt(code,"U") //转换成大写
		s:desc'="" desc=$zcvt(desc,"U") //转换成大写
		
		s BDPSSRowId=0
		for {
			s BDPSSRowId=$o(^CT("BDPSS",BDPSSRowId)) q:BDPSSRowId=""
			s BDPSSCode = $p($g(^CT("BDPSS",BDPSSRowId)),"^",1)
			s BDPSSDesc = $p($g(^CT("BDPSS",BDPSSRowId)),"^",2)	
			s BDPSSRemark = $p($g(^CT("BDPSS",BDPSSRowId)),"^",3)
			s BDPSSTimeRangeFlag = $p($g(^CT("BDPSS",BDPSSRowId)),"^",4)
			
			if (desc'="")
			{
				;需要对描述或者别名进行检索      
				s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("BDP_SpecialService",BDPSSRowId,BDPSSDesc,desc)
			}
			else
			{
				s AliasFlag= 1   
			}
			i ($zcvt(BDPSSCode,"u")[code)&&(AliasFlag=1)
			{
				d OutputRow
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(BDPSSRowId,BDPSSCode,BDPSSDesc,BDPSSRemark,BDPSSTimeRangeFlag)
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
/// CreatDate: 2018-02-05
/// Description：节假日特殊业务代码表,为combobox查询取数据
/// Table：User.BDPSpecialService
/// Input：rowid,code,desc
/// Return：BDPSSRowId,BDPSSCode,BDPSSDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPSpecialService","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BDPSSRowId:%String,BDPSSCode:%String,BDPSSDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s BDPSSRowId = rowid
		s BDPSSCode = $p($g(^CT("BDPSS",BDPSSRowId)),"^",1)
		s BDPSSDesc = $p($g(^CT("BDPSS",BDPSSRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$zcvt(code,"U") //转换成大写
		s:desc'="" desc=$zcvt(desc,"U") //转换成大写
		
		s BDPSSRowId=0
		f {
			s BDPSSRowId=$o(^CT("BDPSS",BDPSSRowId)) q:BDPSSRowId=""
			s BDPSSCode = $p($g(^CT("BDPSS",BDPSSRowId)),"^",1)
			s BDPSSDesc = $p($g(^CT("BDPSS",BDPSSRowId)),"^",2)
			if (desc'="")
			{
				;需要对描述或者别名进行检索      
				s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("BDP_SpecialService",BDPSSRowId,BDPSSDesc,desc)
			}
			else
			{
				s AliasFlag= 1   
			}
			i ($zcvt(BDPSSCode,"u")[code)&&(AliasFlag=1)
			{
				d OutputRowCmb
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(BDPSSRowId,BDPSSCode,BDPSSDesc)
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

}
