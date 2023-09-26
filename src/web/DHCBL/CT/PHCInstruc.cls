Import SQLUser

/// 名称:药学 8药品用法
/// 描述:药品用法维护，包含增删改查功能
/// 编写者：基础数据平台组 - 陈莹 
/// 编写日期:  2012-8-30
Class web.DHCBL.CT.PHCInstruc Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹 		
/// CreatDate: 2012-8-29
/// Description：查询 药品用法
/// Table：User.PHCInstruc
/// Input：rowid,code,desc1,desc2
/// Output：PHCINRowId,PHCINCode,PHCINDesc1,PHCINDesc2,PHCINActiveFlag,PHCINClinicType
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCInstruc","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc1 As %String, desc2 As %String) As %Query(ROWSPEC = "PHCINRowId:%String,PHCINCode:%String,PHCINDesc1:%String,PHCINDesc2:%String,PHCINActiveFlag,PHCINClinicType,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc1 As %String, desc2 As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="")
	{
		s PHCINRowId=rowid
		
		s PHCINCode= $p($g(^PHCIN(PHCINRowId)),"^",1)
		s PHCINDesc1 = $p($g(^PHCIN(PHCINRowId)),"^",2)
		s PHCINDesc2 = $p($g(^PHCIN(PHCINRowId)),"^",3)
		s PHCINActiveFlag = $p($g(^PHCIN(PHCINRowId)),"^",4)         ;是否激活 20170612
		s:PHCINActiveFlag="" PHCINActiveFlag="Y"                     ;激活标志为空时默认为激活
		s PHCINClinicType = $p($g(^PHCIN(PHCINRowId)),"^",5)         ;就诊类型
		//就诊类型 (门诊,急诊,住院,体检,新生儿) 20170612
		s PHCINClinicType=##class(web.DHCBL.CT.PHCFreq).GetClinicType(PHCINClinicType)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Instruc",PHCINRowId)  //就诊类型
		s BDPInternalCode =$p($g(resultStr),"^",1)
		s BDPInternalDesc = $p($g(resultStr),"^",2)
		s BDPHospNationalCode=$p($g(resultStr),"^",3)  
		s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc1'="" desc1=$ZCONVERT(desc1,"U")
		s:desc2'="" desc2=$ZCONVERT(desc2,"U")
		s AuStr=##class(web.DHCBL.Authorize.PHCInstruc).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCINRowId=0
		for
		{
			s PHCINRowId=$o(^PHCIN(PHCINRowId)) q:PHCINRowId=""
			s strRowId="{ID:"_PHCINRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCINCode=$p($g(^PHCIN(PHCINRowId)),"^",1)
				s PHCINDesc1 = $p($g(^PHCIN(PHCINRowId)),"^",2)
				s PHCINDesc2 = $p($g(^PHCIN(PHCINRowId)),"^",3)
				s PHCINActiveFlag = $p($g(^PHCIN(PHCINRowId)),"^",4)       ;是否激活 20170612
				s:PHCINActiveFlag="" PHCINActiveFlag="Y"                   ;激活标志为空时默认为激活
				s PHCINClinicType = $p($g(^PHCIN(PHCINRowId)),"^",5)       ;就诊类型
				
				//就诊类型 (门诊,急诊,住院,体检,新生儿) 20170612
				s PHCINClinicType=##class(web.DHCBL.CT.PHCFreq).GetClinicType(PHCINClinicType)
				
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Instruc",PHCINRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)
				s BDPInternalDesc = $p($g(resultStr),"^",2)
				s BDPHospNationalCode=$p($g(resultStr),"^",3)  
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)
				
				if (desc1'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Instruc",PHCINRowId,PHCINDesc1,desc1)
				}
				else
				{
					s AliasFlag=1
				}
				s PINYIN2=""
				s:desc2'="" PINYIN2= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHCINDesc2)
				i ($ZCONVERT(PHCINCode,"U")[code)&(AliasFlag=1)&(($ZCONVERT(PHCINDesc2,"U")[desc2)||((PINYIN2[desc2)))
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHCINRowId,PHCINCode,PHCINDesc1,PHCINDesc2,PHCINActiveFlag,PHCINClinicType,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Description：查询 药品用法
/// Table：User.PHCInstruc
/// Input：code,desc(desc1)
/// Output：PHCINRowId,PHCINCode,PHCINDesc1
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCInstruc","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCINRowId:%String,PHCINCode:%String,PHCINDesc1:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="")
	{
		s PHCINRowId=rowid	
		s PHCINCode= $p($g(^PHCIN(PHCINRowId)),"^",1)
		s PHCINDesc1 = $p($g(^PHCIN(PHCINRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc1=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.PHCInstruc).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCINRowId=0
		for
		{
			s PHCINRowId=$o(^PHCIN(PHCINRowId)) q:PHCINRowId=""
			s strRowId="{ID:"_PHCINRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCINCode=$p($g(^PHCIN(PHCINRowId)),"^",1)
				s PHCINDesc1 = $p($g(^PHCIN(PHCINRowId)),"^",2)
				
				s PHCINActiveFlag = $p($g(^PHCIN(PHCINRowId)),"^",4)
				CONTINUE:PHCINActiveFlag="N"
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Instruc",PHCINRowId,PHCINDesc1,desc)
				}
				else
				{
					s AliasFlag=1
				}
				i ($ZCONVERT(PHCINCode,"U")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(PHCINRowId,PHCINCode,PHCINDesc1)
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
/// Table:User.PHCInstruc
/// Input:id, code, desc1
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PHCInstruc).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc1 As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc1'="" desc1=$$ALPHAUP^SSUTIL4(desc1) //$ZCONVERT(desc1,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^PHCIN(0,"Code",code))
	s:desc1'="" flagd=$d(^PHCIN(0,"Desc1",desc1))
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
		s:code'="" idc=$o(^PHCIN(0,"Code",code,0))
		s:desc1'="" idd=$o(^PHCIN(0,"Desc1",desc1,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
			
	}
	q flag
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：新增、修改时打开Form，根据RowId查询
/// Table：User.PHCInstruc
/// w ##class(web.DHCBL.CT.PHCInstruc).OpenData("3")
ClassMethod OpenData(PHCINRowId As %String) As %String
{
	
    s str = ""
	s pobj = ##class(User.PHCInstruc).%OpenId(PHCINRowId)
	s eobj = ##class(web.Entity.CT.PHCInstruc).%New()
	s eobj.PHCINRowId = PHCINRowId
	s eobj.PHCINCode  = pobj.PHCINCode
	s eobj.PHCINDesc1 = pobj.PHCINDesc1
	s eobj.PHCINDesc2 = pobj.PHCINDesc2
	s eobj.PHCINActiveFlag = pobj.PHCINActiveFlag
	s eobj.PHCINClinicType = pobj.PHCINClinicType
	s:eobj.PHCINActiveFlag="Y" eobj.PHCINActiveFlag="true"
	s:eobj.PHCINActiveFlag="" eobj.PHCINActiveFlag="true"           //激活标志为空时默认为激活
	if eobj.PHCINClinicType="" s eobj.PHCINClinicType = "O,E,I,H,N"   //就诊类型为空时 默认门诊，急诊，住院，体检，新生儿都可以开
	s eobj.PHCINClinicTypeO=$P(eobj.PHCINClinicType,",",1)  // 就诊类型 门诊
	s eobj.PHCINClinicTypeE=$P(eobj.PHCINClinicType,",",2)  // 就诊类型 急诊
	s eobj.PHCINClinicTypeI=$P(eobj.PHCINClinicType,",",3)  // 就诊类型 住院
	s eobj.PHCINClinicTypeH=$P(eobj.PHCINClinicType,",",4)  // 就诊类型 体检
	s eobj.PHCINClinicTypeN=$P(eobj.PHCINClinicType,",",5)  // 就诊类型 新生儿
	
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹 
/// CreatDate: 2012-8-3
/// Description：添加/修改 药品用法
/// Table：User.PHCInstruc
ClassMethod SaveEntity(eobj As web.Entity.CT.PHCInstruc) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.PHCINActiveFlag="" eobj.PHCINActiveFlag="N"
		
		//针对导入修改  20170812 
		if eobj.PHCINClinicType["门诊" s eobj.PHCINClinicTypeO="O"
		if eobj.PHCINClinicType["急诊" s eobj.PHCINClinicTypeE="E"
		if eobj.PHCINClinicType["住院" s eobj.PHCINClinicTypeI="I"
		if eobj.PHCINClinicType["体检" s eobj.PHCINClinicTypeH="H"
		if eobj.PHCINClinicType["新生儿" s eobj.PHCINClinicTypeN="N"
		
		
		///将就诊类型拼起来， 用,分隔  20170615
		s eobj.PHCINClinicType=eobj.PHCINClinicTypeO_","_eobj.PHCINClinicTypeE_","_eobj.PHCINClinicTypeI_","_eobj.PHCINClinicTypeH_","_eobj.PHCINClinicTypeN
		///如果就诊类型都勾选，将就诊类型置为空，所有的都可以开
		I (eobj.PHCINClinicTypeO'="")&&(eobj.PHCINClinicTypeE'="")&&(eobj.PHCINClinicTypeI'="")&&(eobj.PHCINClinicTypeH'="")&&(eobj.PHCINClinicTypeN'="") s eobj.PHCINClinicType=""
		///如果就诊类型都不勾选，将就诊类型置为空，所有的都可以开
		I (eobj.PHCINClinicTypeO="")&&(eobj.PHCINClinicTypeE="")&&(eobj.PHCINClinicTypeI="")&&(eobj.PHCINClinicTypeH="")&&(eobj.PHCINClinicTypeN="") s eobj.PHCINClinicType=""
		
		s flag=..FormValidate(eobj.PHCINRowId,eobj.PHCINCode,eobj.PHCINDesc1)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.PHCINRowId="")
		{	
	        s obj=##class(User.PHCInstruc).%New()
		}
		else
		{
			s obj=##class(User.PHCInstruc).%OpenId(eobj.PHCINRowId)
			
			s bobj = ##class(web.Entity.CT.PHCInstruc).%New()	
			s bobj.PHCINRowId = eobj.PHCINRowId
			s bobj.PHCINCode = obj.PHCINCode
			s bobj.PHCINDesc1 = obj.PHCINDesc1
			s bobj.PHCINDesc2 = obj.PHCINDesc2
			s bobj.PHCINActiveFlag = obj.PHCINActiveFlag
			s bobj.PHCINClinicType = obj.PHCINClinicType
	
		}
		
		s obj.PHCINCode = eobj.PHCINCode
		s obj.PHCINDesc1 = eobj.PHCINDesc1
		s obj.PHCINDesc2 = eobj.PHCINDesc2 //国外描述
		s obj.PHCINActiveFlag = eobj.PHCINActiveFlag
		s obj.PHCINClinicType = eobj.PHCINClinicType
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.PHCINRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Instruc","User.PHCInstruc","药品用法",id,eobj.PHCINDesc1,"A",eobj)
			d:eobj.PHCINRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Instruc","User.PHCInstruc","药品用法",id,eobj.PHCINDesc1,"U",eobj,bobj)
			if (eobj.DataAlias'="")  //2017-2-8 自动添加别名到BDPAlias表
			{
				s length=$l(eobj.DataAlias,"/")
				for aliasi=1:1:length
				{
					s alias=$p(eobj.DataAlias,"/",aliasi)
					s:alias'="" aliasstr=##class(web.DHCBL.BDP.BDPAlias).Insert("PHC_Instruc",alias,id)
				}
			}
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品用法","web.DHCBL.CT.PHCInstruc","SaveEntity",eobj)
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
	n (id)
	s return="",myInfo=""
	i ($d(^PHCD("Instruc",+id))'=0)
	{
		s myInfo=myInfo_"<药学项-药物形态设定>"
	}
	
	s PHCINCode= $p($g(^PHCIN(id)),"^",1)
	i ($o(^DHCPHINSTCON(0,"HisCode",PHCINCode,"")))
	{
		s myInfo=myInfo_"<用法对照表>"
	}
	/*
	i ($o(^PHCINLD(0,"Instruc",id,0))'="")	
	{
		s myInfo=myInfo_"<用法与用量关联表>"
	}
	i ($o(^PHCINLF(0,"Instruc",id,0))'="")	
	{
		s myInfo=myInfo_"<用法与频次关联表>"
	}
	*/
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：根据id删除 药品用法
/// Table：User.PHCInstruc
/// Input：id 
/// Return：成功返回true和info，失败返回false和info
ClassMethod DeleteData(id) As %String
{
	n (id,%session)
	s result=""

	s re=##class(web.DHCBL.CT.PHCInstruc).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.PHCInstruc).%OpenId(id)
		s eobj = ##class(web.Entity.CT.PHCInstruc).%New()
		s eobj.PHCINRowId = id
		s eobj.PHCINCode  = pobj.PHCINCode
		s eobj.PHCINDesc1 = pobj.PHCINDesc1
		s eobj.PHCINDesc2 = pobj.PHCINDesc2
		s eobj.PHCINActiveFlag = pobj.PHCINActiveFlag
		s eobj.PHCINClinicType = pobj.PHCINClinicType
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(User.PHCInstruc).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Instruc","User.PHCInstruc","药品用法",id,eobj.PHCINDesc1,"D",eobj)
			
			
			///2017-07-05 删掉用法时，删掉对应的用法关联用量和用法关联频次
			i ($o(^PHCINLD(0,"Instruc",id,0))'="")	
			{
				s ILDRowId=0
				for
				{
					s ILDRowId=$o(^PHCINLD(0,"Instruc",id,ILDRowId)) q:ILDRowId=""
					d ##class(web.DHCBL.CT.PHCInstrucLinkDosage).DeleteData(ILDRowId)
				}
			}
			i ($o(^PHCINLF(0,"Instruc",id,0))'="")	
			{
				s ILFRowId=0
				for
				{
					s ILFRowId=$o(^PHCINLF(0,"Instruc",id,ILFRowId)) q:ILFRowId=""
					d ##class(web.DHCBL.CT.PHCInstrucLinkFreq).DeleteData(ILFRowId)
				}
			}
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品用法","web.DHCBL.CT.PHCInstruc","DeleteData",eobj)
	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

///           ofy1 江西南大二附院 增加“是否需要执行科室”字段 PHCINExecuteLocFlag  节点位置4

}
