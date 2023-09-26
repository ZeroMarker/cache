/// Description: 出院指导详情数据维护
/// Creator: 丁亚男
/// Date: 2021-11-30
Class web.CDSS.CMKB.DGuideDetail Extends %RegisteredObject
{

/// Creator：胡宜良
/// CreatDate: 2021-11-30
/// Description：查询 
/// Table：CT.WDT.CDSS.DGuideDetail
/// Input:id,code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DGuideDetail","GetList","","")
Query GetList(rowid As %String, dguidedr As %String, detail As %String) As %Query(ROWSPEC = "ID,DGuideDR,DGuideDetail,DGuideOrder")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, dguidedr As %String, detail As %String) As %Status
{
 	s repid=$I(^CacheTemp)
	s ind=1
	
	s:detail'="" detail=$ZCONVERT(detail,"U") //转换成大写
	//s:source'="" source=$ZCONVERT(source,"U") //转换成大写
	
	if (rowid'="") //根据rowid返回该条记录
	{

		
		s ID=rowid
		s DGuideDR=$LISTGET($G(^CT.WDT.CDSS.DGuideDetailD(ID)),2)
		s:DGuideDR'="" DGuideName=$LISTGET($G(^CT.WDT.CDSS.DischargeGuideD(DGuideDR)),3)
		s DGuideDetail= $lg($g(^CT.WDT.CDSS.DGuideDetailD(ID)),3)       //出院指导详情
		s DGuideOrder= $lg($g(^CT.WDT.CDSS.DGuideDetailD(ID)),4)       //出院指导顺序

        
        d OutputRow
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.DGuideDetailD(ID))
			q:ID=""
			s DGuideDR= $lg($g(^CT.WDT.CDSS.DGuideDetailD(ID)),2)       //指针
			continue:((dguidedr'="")&&(dguidedr'=DGuideDR))
		    s DGuideName=""
	        s:DGuideDR'="" DGuideName=$LISTGET($G(^CT.WDT.CDSS.DischargeGuideD(DGuideDR)),2)
		    s DGuideDetail= $lg($g(^CT.WDT.CDSS.DGuideDetailD(ID)),3)       //详情
		    continue:((detail'="")&&(DGuideDetail'[detail))
	   	 	s DGuideOrder= $lg($g(^CT.WDT.CDSS.DGuideDetailD(ID)),4)        //顺序
			d OutputRow
		}
						
	}
			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    
    set Data=$lb(ID,DGuideDR,DGuideDetail,DGuideOrder)
    set ^CacheTemp(repid,ind)=Data
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

/// Creator:胡宜良
/// CreatDate:2021-12-6
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.DGuideDetail
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.DGuideDetail).FormValidate("","继续服用免疫抑制药物（常见免疫抑制剂有以下几种）：环孢素（不良反应有肾毒性、肝脏损害、高血压、动脉病变及血凝集性增加；震颤、牙龈出血、多毛。早、晚空腹服用，每12小时服用1次，可同时吃少量牛奶、饼干等，以减少胃肠道不适），硫唑嘌呤（不良反应有抑制骨髓功能、肝功能损害、转氨酶升高。要注意检查肝功能、肾功能和血常规），泼尼松（长期大剂量应用可引起肥胖、多毛、痤疮、高血压、水肿、血钾降低、胃及十二指肠溃疡，甚至出血穿孔、骨质疏松、伤口愈合不良等），他克莫司（肾毒性较环孢素轻，但也可有高血糖、高血钾、高血压及对心脏的毒性作用。早、晚空腹服用，每12小时服用1次。平时要注意进低盐饮食，监测血糖水平，血药浓度高时可出现腹泻、癫痫发作等异常）","224")
ClassMethod FormValidate(id As %String, DGuideDetail As %String, DGuideDR As %String) As %String
{
	q:(DGuideDR="") ""
	s flag="",flagc=""
	s:(DGuideDetail'="")&&(DGuideDR'="") flagc=$d(^CT.WDT.CDSS.DGuideDetailI("DetailDRIndex",DGuideDetail,DGuideDR))
	b ;1
	
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:(DGuideDetail'="")&&(DGuideDR'="") idc=$o(^CT.WDT.CDSS.DGuideDetailI("DetailDRIndex",DGuideDetail,DGuideDR,0))
  		
  		if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
	}
	
	q flag
}

/// 测试保存
/// d ##class(web.CDSS.CMKB.DGuideDetail).testsave()
ClassMethod testsave()
{
	s eobj=##class(web.CDSSEntity.CMKB.DGuideDetail).%New()
	w eobj,!
	s eobj.DGuideOrder=""
	s eobj.DGuideDR="1"
	s eobj.DGuideDetail="测试"
	w ..SaveData(eobj)
}

ClassMethod SaveData(ID, DGuideDetail, DGuideDR) As %String
{
	s flag=..FormValidate(ID,DGuideDetail,DGuideDR)  //调用重复验证
	if (flag=1)	//校验重复
	{
		q "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	if (ID="")  //如果ID未赋值则增加
	{	
		s obj=##class(CT.WDT.CDSS.DGuideDetail).%New()	
	}
	else  //如果ID已赋值则修改
	{
		s obj=##class(CT.WDT.CDSS.DGuideDetail).%OpenId(ID)
	}
	d obj.DGuideDRSetObjectId(DGuideDR)	
	s obj.DGuideDetail = DGuideDetail
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回ID
	}
	else
	{
		Tro
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息	
	}
	
	q result
}

/// Creator:胡宜良
/// CreatDate:2021-12-6
/// Description:保存疾病关联诊断因子组合表
/// Table：CT.WDT.CDSS.DGuideDetail
/// Input: eobj 疾病关联诊断因子组合表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.CMKB.DGuideDetail).SaveData(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.DGuideDetail)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.ID,eobj.DGuideDR)
		w flag,! 
		
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		if (eobj.ID="")  //如果ID未赋值则增加
		{
			
			s obj=##class(CT.WDT.CDSS.DGuideDetail).%New()	
		}
		else  //如果ID已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.DGuideDetail).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.DGuideDetail).%New()
			s:obj.DGuideDR'="" bobj.DGuideDR = obj.DGuideDR.%Id()	//医院
			s bobj.DGuideDetail = obj.DGuideDetail
			s bobj.DGuideOrder = obj.DGuideOrder
			
		}
		d:eobj.DGuideDR'="" obj.DGuideDRSetObjectId(eobj.DGuideDR)		//所属医院
		d:eobj.DGuideDR="" obj.DGuideDRSetObjectId("")	
		s obj.DGuideDetail = eobj.DGuideDetail
		s obj.DGuideOrder = eobj.DGuideOrder

		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回ID
			//保存责任人、操作时间
			//d ##class(web.CDSS.CMKB.DiseJProperty).AddResponUser(eobj.DGuideDR,eobj.OperationUser)
			//保存日志
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DGuideDetail","CT.WDT.CDSS.DGuideDetail","出院指导详情",id,eobj.DGuideDetail,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DGuideDetail","CT.WDT.CDSS.DGuideDetail","出院指导详情",eobj.ID,eobj.DGuideDetail,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("出院指导详情","web.CDSS.CMKB.DGuideDetail","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("出院指导详情","web.CDSS.CMKB.DGuideDetail","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:胡宜良
/// CreatDate:2021-12-6
/// Description:删除疾病关联诊断因子组合表
/// Table：CT.WDT.CDSS.DGuideDetail
/// Input: id 疾病关联辅助检查检验id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.DGuideDetail).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Ts
	s obj=##class(CT.WDT.CDSS.DGuideDetail).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.DGuideDetail).%New()
	if $IsObject(obj.DGuideDR)
	{
	 	s bobj.DGuideDR = obj.DGuideDR.%Id()
	}
	s bobj.DGuideDetail = obj.DGuideDetail
	s bobj.DGuideOrder = obj.DGuideOrder

			
	s sc=##class(CT.WDT.CDSS.DGuideDetail).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DGuideDetail","CT.WDT.CDSS.DGuideDetail","出院指导详情",id,bobj.DGuideDetail,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("出院指导详情","web.CDSS.CMKB.DGuideDetail","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:胡宜良
/// CreatDate:2021-12-6
/// Description:通过id获取
/// Table：CT_WDT_CDSS.DGuideDetail
/// Input: id 
/// Return: 内容
/// others:w ##class(web.CDSS.CMKB.DGuideDetail).OpenData("25")
ClassMethod OpenData1(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.DGuideDetail).%New()
	s eobj.ID= id
	s eobj.DGuideDR = $LISTGET($G(^CT.WDT.CDSS.DGuideDetailD(id)),2)
	s eobj.DGuideDetail= $lg($g(^CT.WDT.CDSS.DGuideDetailD(id)),3)
	s eobj.DGuideOrder = $lg($g(^CT.WDT.CDSS.DGuideDetailD(id)),4)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// others: w ##class(web.CDSS.CMKB.DGuideDetail).OpenData("25")
ClassMethod OpenData(id As %String)
{
    q:id="" ""
    s obj =##class(CT.WDT.CDSS.DGuideDetail).%OpenId(id)
    if (obj)
    {
	    s DGuideDR=obj.DGuideDRGetObjectId() 
	    s DGuideDetail=obj.DGuideDetail
	    s DGuideOrder=obj.DGuideOrder
	    
	    b ;
	    }	
	
	else
	{
		s result="数据不存在"
		
	}
	q result
}

/// Creator:胡宜良
/// CreatDate:2021-12-16
/// Description:通过id获取详情内容
/// Table：CT_WDT_CDSS.DGuideDetail
/// Input: id 疾病关联诊断因子组合id
/// Return: 疾病关联诊断因子组合内容
/// others:w ##class(web.CDSS.CMKB.DGuideDetail).GetDetail("5")
ClassMethod GetDetail(id As %String)
{
	s str=""
	s ID=0
	for
	{
		s ID=$o(^CT.WDT.CDSS.DGuideDetailI("DGuideDRIndex",id,ID))	
		q:ID=""
		s DGuideDetail= $lg($g(^CT.WDT.CDSS.DGuideDetailD(ID)),3)
		if str=""
		{
			s str=DGuideDetail
		}
		else
		{
			s str=str_"<br/>"_DGuideDetail
		}
		
	}
	q str
}

}
