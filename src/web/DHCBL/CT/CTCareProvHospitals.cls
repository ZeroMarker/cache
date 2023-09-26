/// 名称: 医护人员与医院关联维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-高姗姗
/// 编写日期: 2015-1-28
Class web.DHCBL.CT.CTCareProvHospitals Extends %RegisteredObject
{

/// Description：查询医护人员关联医院的内容
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCareProvHospitals","GetList","","","")
Query GetList(rowid As %String, ParRef As %String) As %Query(ROWSPEC = "HOSPRowId,HOSPHospitalDR,HOSPDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, ParRef As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s HOSPRowId=rowid
		s CTPCPRowId=$p(HOSPRowId,"||",1)
		s HOSPChildsub=$p(HOSPRowId,"||",2)
		s HOSPHospitalDR=$p($g(^CTPCP(CTPCPRowId,"HOSP",HOSPChildsub)),"^",1)
		s HOSPDesc = $p($g(^CT("HOSP",HOSPHospitalDR)),"^",2)
	
		d OutputRow
	}
	else
	{
		if (ParRef'="")
		{
			s CTPCPRowId=ParRef,HOSPChildsub=0
			for 
			{
				s HOSPChildsub=$o(^CTPCP(CTPCPRowId,"HOSP",HOSPChildsub)) q:HOSPChildsub=""
				s HOSPRowId=CTPCPRowId_"||"_HOSPChildsub
				s HOSPHospitalDR=$p($g(^CTPCP(CTPCPRowId,"HOSP",HOSPChildsub)),"^",1)
				s strHospitalID = "{ID:"_HOSPHospitalDR_"}"
				s HOSPDesc = $p($g(^CT("HOSP",HOSPHospitalDR)),"^",2)
				if ((AuHospStr="off")||(AuHospStr[strHospitalID)||(AuHospStr=1))
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(HOSPRowId,HOSPHospitalDR,HOSPDesc)
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

/// Creator：高姗姗
/// CreatDate: 2015-1-27
/// Description：保存修改内容
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.CTCareProvHospitals) As %String
{
	s result = ""
	if $IsObject(eobj)
	{
			if (eobj.HOSPRowId="")  //如果RowId未赋值则增加
			{
				s disLength=$d(^CTPCP(eobj.HOSPParRef,"HOSP",0,"Hosp",eobj.HOSPHospitalDR))
				if (disLength=0)
				{
					s obj=##class(User.CTCareProvHospitals).%New(eobj.HOSPParRef)
					d obj.HOSPHospitalDRSetObjectId(eobj.HOSPHospitalDR)
					d obj.HOSPParRefSetObjectId(eobj.HOSPParRef)
					s hospDesc=$p($g(^CT("HOSP",eobj.HOSPHospitalDR)),"^",2)
					Tstart
					s sc=obj.%Save()
					do obj.%Close()
					if $$$ISOK(sc){
						Tcommit
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProvHospitals","User.CTCareProvHospitals","医护人员关联医院",id,hospDesc,"A",eobj,"",eobj.HOSPParRef)
					}else{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员关联医院","web.DHCBL.CT.CTCareProvHospitals","SaveEntity",eobj)
						s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
					}
				}
				else
				{
					s result = "{success:'false',errorinfo:'该记录已经存在！'}"
				}
			}
			else  //如果RowId已赋值则修改
			{
				s disLength=$d(^CTPCP(eobj.HOSPParRef,"HOSP",0,"Hosp",eobj.HOSPHospitalDR))
				s HOSPChildsub=$p(eobj.HOSPRowId,"||",2)
				s TempChildsub=$o(^CTPCP(eobj.HOSPParRef,"HOSP",0,"Hosp",eobj.HOSPHospitalDR,0))
				if (disLength=0)||((disLength'=0)&(HOSPChildsub=TempChildsub))
				{
					s obj=##class(User.CTCareProvHospitals).%OpenId(eobj.HOSPRowId)
					s bobj=##class(web.Entity.CT.CTCareProvHospitals).%New()
					s bobj.HOSPRowId=eobj.HOSPRowId
					s bobj.HOSPParRef=$p(eobj.HOSPRowId,"||",1)
					s bobj.HOSPHospitalDR = obj.HOSPHospitalDR.%Id() 
				    
					d obj.HOSPHospitalDRSetObjectId(eobj.HOSPHospitalDR)
					d obj.HOSPParRefSetObjectId(eobj.HOSPParRef)
					
					s hospDesc=$p($g(^CT("HOSP",eobj.HOSPHospitalDR)),"^",2)     	
					Ts					
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						Tc
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"  //返回RowId
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProvHospitals","User.CTCareProvHospitals","医护人员关联医院",eobj.HOSPRowId,hospDesc,"U",eobj,bobj,eobj.HOSPParRef)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员关联医院","web.DHCBL.CT.CTCareProvHospitals","SaveEntity",eobj)
						s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
					}
				}
				else
				{
					s result = "{success:'false',errorinfo:'该记录已经存在！'}"
				}
			}
	}	
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
}

/// Description：修改时打开的数据
/// Other: w ##class(web.DHCBL.CT.CTCareProvHospitals).OpenData("10||8")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.CTCareProvHospitals).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTCareProvHospitals).%New()
	s eobj.HOSPRowId=id
	s eobj.HOSPParRef=$p(id,"||",1)
	s eobj.HOSPHospitalDR = pobj.HOSPHospitalDR.%Id() 

	d pobj.%Close()
	s str = eobj.JsonS()
	s str = "{data:["_str_"]}"
	q str
}

/// Description：根据ID删除医护人员与医院关联表的内容
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s HospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
    if (HospAutflag = "Y")
    {
		s ParRef=$p(id,"||",1)
		s count=0
		s HOSPChildsub=0
		for 
		{
			s HOSPChildsub=$o(^CTPCP(ParRef,"HOSP",HOSPChildsub)) q:HOSPChildsub=""
			s HOSPRowId=ParRef_"||"_HOSPChildsub
			s HOSPHospitalDR=$p($g(^CTPCP(ParRef,"HOSP",HOSPChildsub)),"^",1)
			continue:HOSPHospitalDR=""
	   		s count=count+1
	    }
	    if (count=1)
		{
			s result = "{success:'false',info:'不允许删除该医院关联，需要保证一条数据至少关联一个医院'}"
			q result
		}
    }  	
	    	
	s result = ""
	s pobj=##class(User.CTCareProvHospitals).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTCareProvHospitals).%New()
	s eobj.HOSPRowId = id
	s eobj.HOSPParRef=$p(id,"||",1)
	s eobj.HOSPHospitalDR=pobj.HOSPHospitalDR.%Id()

	s hospDesc=$p($g(^CT("HOSP",eobj.HOSPHospitalDR)),"^",2)     
	d pobj.%Close()
	Tstart
	s sc=##class(User.CTCareProvHospitals).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProvHospitals","User.CTCareProvHospitals","医护人员关联医院",id,hospDesc,"D",eobj,"",eobj.HOSPParRef)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员关联医院","web.DHCBL.CT.CTCareProvHospitals","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

}
