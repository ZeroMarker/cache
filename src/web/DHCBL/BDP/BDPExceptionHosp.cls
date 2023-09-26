/// Function: 基础数据表结构登记子表-例外医院，包含增删改查等功能
/// Creator: 基础数据平台-李可凡
/// CreateDate：2020年4月29日
Class web.DHCBL.BDP.BDPExceptionHosp Extends %RegisteredObject
{

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年4月29日
/// Description：查询例外医院表
/// Table：User.BDPExceptionHosp
/// Input: rowid(例外医院表rowid)，parref(指向父表User.BDPTableList，表结构登记RowId)
/// Output: 例外医院表rowid，医院描述，是否启用，开始日期，结束日期
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPExceptionHosp","GetList","","1")
Query GetList(rowid As %String, parref As %String) As %Query(ROWSPEC = "ID,HospitalDR,ActiveFlag,ActiveFrom,ActiveTo")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s ParRef=$p(ID,"||",1)
		s childsub=$p(ID,"||",2)
		s HospitalDR=$lg($g(^User.BDPTableListD(ParRef,"ChildExceptionHosp",childsub)),2)		//医院DR
		s:HospitalDR'="" HospitalDR=$p($g(^CT("HOSP",HospitalDR)),"^",2)						//取医院描述
		s ActiveFlag=$lg($g(^User.BDPTableListD(ParRef,"ChildExceptionHosp",childsub)),3)		//是否启用
		s ActiveFrom=$lg($g(^User.BDPTableListD(ParRef,"ChildExceptionHosp",childsub)),4)		//开始日期
		s ActiveTo=$lg($g(^User.BDPTableListD(ParRef,"ChildExceptionHosp",childsub)),5)		//结束日期
		s:ActiveFrom'="" ActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ActiveFrom)	//转换日期格式
        s:ActiveTo'="" ActiveTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ActiveTo)	//转换日期格式
		d Outputrow
	}
	else
	{
		if (parref'="")
		{
			s childsub=0
			for 
			{
				s childsub=$o(^User.BDPTableListD(parref,"ChildExceptionHosp",childsub)) q:childsub=""
				s ID=parref_"||"_childsub
				s HospitalDR=$lg($g(^User.BDPTableListD(parref,"ChildExceptionHosp",childsub)),2)		//医院DR
				s:HospitalDR'="" HospitalDR=$p($g(^CT("HOSP",HospitalDR)),"^",2)						//取医院描述
				s ActiveFlag=$lg($g(^User.BDPTableListD(parref,"ChildExceptionHosp",childsub)),3)		//是否启用
				s ActiveFrom=$lg($g(^User.BDPTableListD(parref,"ChildExceptionHosp",childsub)),4)		//开始日期
				s ActiveTo=$lg($g(^User.BDPTableListD(parref,"ChildExceptionHosp",childsub)),5)		//结束日期
				s:ActiveFrom'="" ActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ActiveFrom)	//转换日期格式
        		s:ActiveTo'="" ActiveTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ActiveTo)	//转换日期格式
				d Outputrow
			}
		}
	}
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputrow
	set Data=$lb(ID,HospitalDR,ActiveFlag,ActiveFrom,ActiveTo)
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

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年4月29日
/// Description：点击修改时查询数据
/// Table：User.BDPExceptionHosp
/// Input：id
/// Output: 例外医院表rowid，医院描述，是否启用，开始日期，结束日期
/// Others：w ##class(web.DHCBL.BDP.BDPExceptionHosp).OpenData("1||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s obj=##class(User.BDPExceptionHosp).%OpenId(id)
	s eobj=##class(web.Entity.BDP.BDPExceptionHosp).%New()
	s eobj.ID=id								//ID
	s eobj.ExceptionHospParRef=$p(id,"||",1)	//ParRef
	s:obj.HospitalDR'="" eobj.HospitalDR=obj.HospitalDR.%Id()		//医院DR
	s eobj.ActiveFlag=obj.ActiveFlag			//是否启用
	s eobj.ActiveFrom=obj.ActiveFrom			//开始日期
	s eobj.ActiveTo=obj.ActiveTo				//结束日期
	s:eobj.ActiveFrom'="" eobj.ActiveFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ActiveFrom)
	s:eobj.ActiveTo'="" eobj.ActiveTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ActiveTo)
	s:eobj.ActiveFlag="Y" eobj.ActiveFlag="true"
	d obj.%Close()
	k obj
	s str=eobj.JsonS()
	s str="{list:["_str_"]}"
	q str
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年4月29日
/// Description：删除数据
/// Table：User.BDPExceptionHosp
/// Input：id
/// Others：w ##class(web.DHCBL.BDP.BDPExceptionHosp).DeleteData("2||5")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		s obj = ##class(User.BDPExceptionHosp).%OpenId(id)
		s pobj = ##class(web.Entity.BDP.BDPExceptionHosp).%New()
		s pobj.ID = id			//ID
		s pobj.ExceptionHospParRef=$p(id,"||",1)		//ParRef
		s:obj.HospitalDR'="" pobj.HospitalDR=obj.HospitalDR.%Id()		//医院DR
		s pobj.ActiveFlag=obj.ActiveFlag		//是否启用
		s pobj.ActiveFrom=obj.ActiveFrom		//开始日期
		s pobj.ActiveTo=obj.ActiveTo			//结束日期
		TSTART
		s sc=##class(User.BDPExceptionHosp).%DeleteId(id)
		if (sc=1)
		{
			TCOMMIT
			s result="{success:'true',info:'删除成功！'}"
			s HOSPDesc=""
			s HOSPDesc=$p($g(^CT("HOSP",pobj.HospitalDR)),"^",2)		//取医院描述
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_ExceptionHosp","User.BDPExceptionHosp","例外医院",id,HOSPDesc,"D",pobj)
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

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年4月29日
/// Description：数据重复校验
/// Table：User.BDPExceptionHosp
/// Input:id,parref,hospitaldr
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.BDP.BDPExceptionHosp).FormValidate("1||1","1","2")
ClassMethod FormValidate(id As %String, parref As %String, hospitaldr As %String) As %String
{
	s flag=0
	if (hospitaldr'="")&&(parref'="")
	{
		s childsub=$o(^User.BDPExceptionHospI("HospitalIndex",hospitaldr,parref,0))
		s ID=parref_"||"_childsub
		if (childsub'="")&&(id'=ID) s flag=1
	}
	q flag
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年4月29日
/// function:例外医院表的新增修改
/// Table：User.BDPExceptionHosp
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPExceptionHosp) As %String
{
	s result=""
	s:eobj.ActiveFrom'="" eobj.ActiveFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ActiveFrom)  //转换日期
	s:eobj.ActiveFrom="" eobj.ActiveFrom=+$h
	s:eobj.ActiveTo'="" eobj.ActiveTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ActiveTo)  //转换日期
	s:eobj.ActiveFlag="" eobj.ActiveFlag="N"
	s flag=..FormValidate(eobj.ID,eobj.ExceptionHospParRef,eobj.HospitalDR)  //调用重复验证
	if (flag=1)
	{
		q "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	if (eobj.ID="")
	{
		s obj=##class(User.BDPExceptionHosp).%New(eobj.ExceptionHospParRef)
	}
	else
	{
		s obj=##class(User.BDPExceptionHosp).%OpenId(eobj.ID)
		s bobj=##class(web.Entity.BDP.BDPExceptionHosp).%New()
	    s bobj.ID=eobj.ID		// RowID
	    s bobj.ExceptionHospParRef=eobj.ExceptionHospParRef				//ParRef
	    s:obj.HospitalDR'="" bobj.HospitalDR=obj.HospitalDR.%Id()		//医院DR
		s bobj.ActiveFlag=obj.ActiveFlag		//是否启用
		s bobj.ActiveFrom=obj.ActiveFrom		//开始日期
		s bobj.ActiveTo=obj.ActiveTo			//结束日期
	}
	d:eobj.ExceptionHospParRef'="" obj.ExceptionHospParRefSetObjectId(eobj.ExceptionHospParRef)		//ParRef
	d:eobj.HospitalDR'="" obj.HospitalDRSetObjectId(eobj.HospitalDR)		//医院DR
	s obj.ActiveFlag=eobj.ActiveFlag		//是否启用
	s obj.ActiveFrom=eobj.ActiveFrom		//开始日期
	s obj.ActiveTo=eobj.ActiveTo			//结束日期
	TSTART
	s sc=obj.%Save()
	d obj.%Close()
	if (sc=1)
	{
		TCOMMIT
		s id=obj.%Id()
		s result="{success:'true',id:'"_id_"'}"
		s HOSPDesc=""
		s HOSPDesc=$p($g(^CT("HOSP",eobj.HospitalDR)),"^",2)		//取医院描述
		d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_ExceptionHosp","User.BDPExceptionHosp","例外医院",id,HOSPDesc,"U",eobj,bobj)
		d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_ExceptionHosp","User.BDPExceptionHosp","例外医院",id,HOSPDesc,"A",eobj)
	}
	else
	{
		TROLLBACK
		s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
	}
	q result
}

/// Function:查询医院，过滤医院组默认医院，为combo查询提供接口
/// CreateDate:2020年5月11日
/// Creator:基础数据平台-李可凡
/// Table:User.CTHospital
/// Input: rowid, code 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPExceptionHosp", "GetDataForCmb1","")
/// 获取医院信息
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, active As %String, communityid As %String) As %Query(ROWSPEC = "HOSPRowId,HOSPCode,HOSPDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, active As %String, communityid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	//获取授权Json
	s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	s AuStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s HospitalDRs = ##class(web.DHCBL.BDP.BDPGradeManage).GetCurrentHospital(communityid)
	if (rowid'="") //根据rowid返回该条记录
	{
		s HOSPRowId=rowid
		s HOSPCode=$p($g(^CT("HOSP",HOSPRowId)),"^",1)
		s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
		d OutputRow1
	}
	else
	{
		s AuFlag=0
		if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
		s HOSPRowId=0
		for  
		{	
			s HOSPRowId=$o(^CT("HOSP",HOSPRowId)) q:HOSPRowId=""
			s strRowId = "{ID:"_HOSPRowId_"}"
			i ((AuStr[strRowId)||(AuFlag=1))&((AuHospStr="off")||(AuHospStr[strRowId)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s HOSPCode=$p($g(^CT("HOSP",HOSPRowId)),"^",1)
				s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
				s HOSPDateTo=$p($g(^CT("HOSP",HOSPRowId)),"^",10)
				continue:(HOSPDateTo'="")&&(HOSPDateTo<+$h)
				
				//2020年5月11日 lkf
				s HOSPDefaultHospitalDR=$p($g(^CT("HOSP",HOSPRowId)),"^",41)	//医院组默认医院
				continue:(HOSPDefaultHospitalDR="")||(HOSPDefaultHospitalDR=HOSPRowId)
				
				if (desc'="")
		        {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Hospital",HOSPRowId,HOSPDesc,desc)
		        }
			   	else
		        {
		         	s AliasFlag= 1   
		        } 
					
				s HospitalDR = "<"_HOSPRowId_">"
				i ($$ALPHAUP^SSUTIL4(HOSPCode)[code)&(AliasFlag=1)
				{
					if (communityid'=""){
						if (HospitalDRs[HospitalDR) d OutputRow1
					}else{
						d OutputRow1
					}
				}
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    set Data=$lb(HOSPRowId,HOSPCode,HOSPDesc)
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

/// 基础数据平台-李可凡
/// 2020年6月15日
/// 删除时判断是否需要密码校验
/// input：例外医院描述
/// output：1：需要	0：不需要
/// w ##class(web.DHCBL.BDP.BDPExceptionHosp).DeletePasswordFlag("2020-06-12")
ClassMethod DeletePasswordFlag(hospdesc As %String) As %String
{
	s flag=0
	s HOSPRowId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hospdesc),0))
	s HOSPDateFrom=$p($g(^CT("HOSP",HOSPRowId)),"^",9)
	s date=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(HOSPDateFrom)  //转换日期
	s:(date'=+$h) flag=1
	q flag
}

/// 基础数据平台-李可凡
/// 2020年6月15日
/// 保存时判断是否需要密码校验
/// input：ID，例外医院DR，是否启用
/// output：1：需要	0：不需要
/// w ##class(web.DHCBL.BDP.BDPExceptionHosp).SavePasswordFlag("1||12","97","1")
ClassMethod SavePasswordFlag(id As %String, hospdr As %String, activeflag As %String) As %String
{
	s flag=0
	if (activeflag=1)||(activeflag="true")||(activeflag="Y") s activeflag="Y"
	else  s activeflag="N"
	if (id="")	//新增例外医院
	{
		s HOSPDateFrom=$p($g(^CT("HOSP",hospdr)),"^",9)
		s date=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(HOSPDateFrom)  //转换日期
		s:(date'=+$h) flag=1
	}
	else	//修改例外医院
	{
		s ParRef=$p(id,"||",1)
		s childsub=$p(id,"||",2)
		s HospitalDR=$lg($g(^User.BDPTableListD(ParRef,"ChildExceptionHosp",childsub)),2)		//医院DR
		s ActiveFlag=$lg($g(^User.BDPTableListD(ParRef,"ChildExceptionHosp",childsub)),3)		//是否启用
		s HOSPDateFrom=$p($g(^CT("HOSP",HospitalDR)),"^",9)		//取原医院的日期
		if (HOSPDateFrom'=+$h)	//如果原医院不是当天新增的医院，有任何改动都返回1
		{
			s:(HospitalDR'=hospdr) flag=1
			s:(ActiveFlag'=activeflag) flag=1
		}
		else
		{
			s HOSPDateFrom=$p($g(^CT("HOSP",hospdr)),"^",9)
			s date=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(HOSPDateFrom)  //转换日期
			s:(date'=+$h) flag=1
		}
	}
	q flag
}

/// 基础数据平台-李可凡
/// 2020年6月12日
/// 生成密码，并进行密码校验
/// input：表结构登记代码，例外医院DR，密码
/// output：1：校验不通过		0：校验通过
/// w ##class(web.DHCBL.BDP.BDPExceptionHosp).CheckPassword("CT_Spec","95","7774162AE07B201951F0E527C8653050")
ClassMethod CheckPassword(tablecode As %String, hospdr As %String, password As %String) As %String
{
	s flag=0
	s HOSPID=$g(%session.Data("LOGON.HOSPID"))
	s sessionHOSPCode=$p($g(^CT("HOSP",HOSPID)),"^",1)	//获取当前登录医院代码
	s ExcepHOSPCode=$p($g(^CT("HOSP",hospdr)),"^",1)	//例外医院代码
	s Today=$zd(+$h,3)
	s Password=Today_"+"_sessionHOSPCode_"+"_tablecode_"+"_ExcepHOSPCode
	//产生密码所需信息：系统日期，当前登录医院代码，基础数据表代码/配置数据表代码，例外医院代码
	//w ##class(web.Util.Encryption).MD5HexStr("2020-06-15+DHSZHYYZY+CT_Spec+A2")
	s PasswordMD5=##class(web.Util.Encryption).MD5HexStr(Password)
	s:PasswordMD5'=password flag=1
	q flag
}

/// 基础数据平台-李可凡
/// 2020年6月12日
/// 删除时调用密码校验
/// input：表结构登记代码，例外医院描述，密码
/// output：1：校验不通过		0：校验通过
/// w ##class(web.DHCBL.BDP.BDPExceptionHosp).CheckPassword("CT_Spec","A2","7774162AE07B201951F0E527C8653050")
ClassMethod CheckDeletePassword(tablecode As %String, hospdesc As %String, password As %String) As %String
{
	s flag=0
	s hospdr=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hospdesc),0))
	s flag=..CheckPassword(tablecode,hospdr,password)
	q flag
}

/// 删除表结构登记界面的例外医院时，需要查询该表在私有数据关联医院中是否存在与【该例外医院】有对照的数据
/// Creator: likefan
/// CreatDate: 2022-11-11
/// output：1：存在数据		0：不存在数据
/// w ##class(web.DHCBL.BDP.BDPExceptionHosp).CheckExistTableHosp("PAC_BedType","东华标准版数字化医院[东院]")
ClassMethod CheckExistTableHosp(tablename As %String, hospname As %String) As %String
{
	q:tablename="" ""
	q:hospname="" ""
	s hospid=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hospname),0))
	q:hospid="" ""
	s flag=0
	if ($d(^User.BDPMappingHospI("DataRef",tablename,hospid))>0)
	{
		s flag=1
	}
	q flag
}

/// Function: 删除某个表在某个医院下关联的所有数据
/// Creator: likefan
/// CreatDate: 2022-11-11
/// debug: w ##class(web.DHCBL.BDP.BDPExceptionHosp).DeleteTableHospitals("PAC_BedType","东华标准版数字化医院[东院]")
ClassMethod DeleteTableHospitals(tablename As %String, hospname As %String) As %String
{
    q:tablename="" ""
    q:hospname="" ""
	s hospid=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hospname),0))
	q:hospid="" ""
    s result=1
    s Reference=0
    for
    {
        s Reference=$o(^User.BDPMappingHospI("DataRef",tablename,hospid,Reference))  q:Reference=""
        s ID=$o(^User.BDPMappingHospI("DataRef",tablename,hospid,Reference,0))
        continue:ID=""
        s sc=##class(User.BDPMappingHosp).%DeleteId(ID)
        s:sc'=1 result=-1
    }
    q result
}

}
