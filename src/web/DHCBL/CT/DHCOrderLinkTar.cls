Import SQLUSER

/// Function: 医嘱项与收费项关联维护 
/// CreateDate:2014-8-23
/// Creator:    sunfengchao
Class web.DHCBL.CT.DHCOrderLinkTar Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function: 获取 医嘱项与收费项目关联 grid数据
/// CreateDate: 2014-11-14
/// Creator: sunfengchao
/// table:   DHC_OrderLinkTar
/// Input:   arcimrowid,validflag(过滤有结束日期的数据)
/// Others:   d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCOrderLinkTar", "GetList","","")
Query GetList(arcimrowid As %String, validflag As %String, hospid As %String) As %Query(ROWSPEC = "arcimdr,olttariffdr,tarcode,tardesc,tarnum,taruom,tarDate,tarDateTo,OLTBascPriceFlag,OLTBillOnceFlag,tarprice,associaterowid")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, arcimrowid As %String, validflag As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
   
	if (arcimrowid'="")
	{
		k oltarray
		s olttariffdr=0
		for
		{
			s olttariffdr=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr)) q:olttariffdr=""   
			s startdate=0
			for
			{
				s startdate=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate)) q:startdate=""
				s associaterowid=0
				for
				{
					s associaterowid=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate,associaterowid)) q:associaterowid=""
					s tarDateTo=$p($g(^DHCOLT(associaterowid)),"^",5)
					s:tarDateTo="" tarDateTo=0
					s oltarray(tarDateTo,associaterowid)=""
				}
			}
		}
		s dateto=""
		for
		{
			s dateto=$o(oltarray(dateto)) q:dateto=""   
			s associaterowid=0
			for
			{
				s associaterowid=$o(oltarray(dateto,associaterowid)) q:associaterowid=""
				s arcimdr=$p($g(^DHCOLT(associaterowid)),"^",1)
				s olttariffdr=$p($g(^DHCOLT(associaterowid)),"^",2)
				s tarcode="",tardesc=""
				s tarcode=$P($G(^DHCTARI(olttariffdr)),"^",1) 
				s tardesc=$P($G(^DHCTARI(olttariffdr)),"^",2) 
				s tarnum=$p($g(^DHCOLT(associaterowid)),"^",3)
				if $e(tarnum,1)="." s tarnum="0"_tarnum
				s taruom=$p($g(^DHCTARI(olttariffdr)),"^",3)
				s:taruom'="" taruom=$p($g(^CT("UOM",taruom)),"^",2)
				s tarDate=$p($g(^DHCOLT(associaterowid)),"^",4)
				s:tarDate'="" tarDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(tarDate)
				s tarDateTo=$p($g(^DHCOLT(associaterowid)),"^",5)
				if (validflag="Y")&&((tarDateTo'="")&&(tarDateTo<+$h)) continue  //2019-12-19过滤有结束日期的数据
				s:tarDateTo'="" tarDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(tarDateTo)			
				s OLTBascPriceFlag=$p($g(^DHCOLT(associaterowid)),"^",8) //基价模式
				s OLTBillOnceFlag=$p($g(^DHCOLT(associaterowid)),"^",9)  //多部位计价一次
				s:OLTBascPriceFlag="" OLTBascPriceFlag="N"
				s:OLTBillOnceFlag="" OLTBillOnceFlag="N"				
				; 收费项价格
				s tarprice=##class(web.DHCBL.CT.ARCItmMast).GetTariPrice(olttariffdr,hospid)
				//s TARIChargeBasis= $p($g(^DHCTARI(olttariffdr)),"^",20)  //收费依据		
				d OutputRow  
			}
			
		}
			 
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(arcimdr,olttariffdr,tarcode,tardesc,tarnum,taruom,tarDate,tarDateTo,OLTBascPriceFlag,OLTBillOnceFlag,tarprice,associaterowid)
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

/// Function: 删除医嘱项与收费项目关联
/// 实体类： web.Entity.CT.DHCOrderLinkTar
/// CreateDate: 2014-8-23
/// Creator:   sunfengchao
/// Debug:     w ##class(web.DHCBL.CT.DHCOrderLinkTar).DelOrderLinkTar("")
ClassMethod DelOrderLinkTar(id As %String) As %String
{
	n (id,%session)
	s result = ""
	//new Entity对象，用于保存日志
	s eobj = ##class(web.Entity.CT.DHCOrderLinkTar).%New()
	s eobj.OLTRowId = id
	s eobj.OLTARCIMDR=$p($g(^DHCOLT(id)),"^",1)
	s eobj.OLTTariffDR=$p($g(^DHCOLT(id)),"^",2)
	s eobj.OLTQty=$p($g(^DHCOLT(id)),"^",3)
	s eobj.OLTStartDate=$p($g(^DHCOLT(id)),"^",4)
	s eobj.OLTEndDate=$p($g(^DHCOLT(id)),"^",5)
	s ARCIMDesc=$p($g(^ARCIM($p(eobj.OLTARCIMDR,"||",1),$p(eobj.OLTARCIMDR,"||",2),1)),"^",2)
	s TARIDesc =$p($g(^DHCTARI(eobj.OLTTariffDR)),"^",2)
	S Desc=ARCIMDesc_"--"_TARIDesc
	Ts	
	s sc=##class(User.DHCOrderLinkTar).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除收费项目关联成功！'}" 
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_OrderLinkTar","User.DHCOrderLinkTar","医嘱项与收费项关联",id,Desc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Function:增加医嘱项与收费项目关联
/// CreateDate:2014-8-23
/// Creator: sunfengchao
/// Debug:  d ##class(web.DHCBL.CT.DHCOrderLinkTar).AddOrdLinkTar("")
/// 1医嘱项rowid^2收费项目dr^3数量^4开始日期^5结束日期^6基价模式^7多部位基价一次
ClassMethod AddOrdLinkTar(addlinktar As %String) As %String
{
	n (addlinktar,%session)
	s result=""
	If addlinktar="" Quit "{success:'false',info:'未选择关联的收费项目, 增加失败!'}"
	
	Set OLTEndDate=$p(addlinktar,"^",5)
	if (OLTEndDate["NaN")||(OLTEndDate="undefined") s OLTEndDate=""
	s OLTBascPriceFlag=$p(addlinktar,"^",6)
	s OLTBillOnceFlag=$p(addlinktar,"^",7)
	s OLTBascPriceFlag=$CASE(OLTBascPriceFlag,"true":"Y","Y":"Y",:"N")  //基价模式
	s OLTBillOnceFlag=$CASE(OLTBillOnceFlag,"true":"Y","Y":"Y",:"N")  //多部位计价一次
	
	s eobj=##class(web.Entity.CT.DHCOrderLinkTar).%New()
	s eobj.OLTARCIMDR=$p(addlinktar,"^",1)
	s eobj.OLTTariffDR=$p(addlinktar,"^",2)
	s eobj.OLTQty= $p(addlinktar,"^",3)
	s eobj.OLTStartDate=$p(addlinktar,"^",4)
	s eobj.OLTEndDate=OLTEndDate
	s eobj.OLTBascPriceFlag=OLTBascPriceFlag
	s eobj.OLTBillOnceFlag=OLTBillOnceFlag
	s Result= ##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(eobj)
	s Ret=""
	if Result["success:'true'" s Ret= "{success:'true',info:'保存成功!'}"
	else  s Ret="{success:'false',info:"_$p(Result,"errorinfo:",2)
	Quit Ret
}

/// Function: 修改医嘱项与收费项目关联
/// CreateDate:2014-8-23
/// Creator: sunfengchao
///  1关联rowid ^2 医嘱项OLTARCIMDR arcimrowid ^ 3数量 ^ 4结束日期 ^  5OLTBascPriceFlag ^6 OLTBillOnceFlag
ClassMethod UpdateOrdLinkTar(UpdateOrdLinkTarStr) As %String
{
	
	n (UpdateOrdLinkTarStr,%session)
	
	Set OLTEndDate=$p(UpdateOrdLinkTarStr,"^",4)
	if (OLTEndDate["NaN")||(OLTEndDate="undefined") s OLTEndDate=""
	
	s OLTBascPriceFlag=$p(UpdateOrdLinkTarStr,"^",5)
	s OLTBillOnceFlag=$p(UpdateOrdLinkTarStr,"^",6)
	
	s OLTBascPriceFlag=$CASE(OLTBascPriceFlag,"true":"Y","Y":"Y",:"N")  //基价模式
	s OLTBillOnceFlag=$CASE(OLTBillOnceFlag,"true":"Y","Y":"Y",:"N")  //多部位计价一次
	s Result="" 
	s eobj=##class(web.Entity.CT.DHCOrderLinkTar).%New()
	s eobj.OLTRowId=$p(UpdateOrdLinkTarStr,"^",1)
	s eobj.OLTARCIMDR=$p($g(^DHCOLT($p(UpdateOrdLinkTarStr,"^",1))),"^",1)  //$p(UpdateOrdLinkTarStr,"^",2)
	s eobj.OLTTariffDR=$p($g(^DHCOLT($p(UpdateOrdLinkTarStr,"^",1))),"^",2)
	s eobj.OLTQty= $p(UpdateOrdLinkTarStr,"^",3)
	s eobj.OLTStartDate=$p($g(^DHCOLT($p(UpdateOrdLinkTarStr,"^",1))),"^",4)
	s eobj.OLTEndDate=OLTEndDate
	s eobj.OLTBascPriceFlag=OLTBascPriceFlag
	s eobj.OLTBillOnceFlag=OLTBillOnceFlag
	s Ret=""
	s Result= ##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(eobj)
	if Result["success:'true'" s Ret= "{success:'true',info:'保存成功!'}"
	else  s Ret="{success:'false',info:"_$p(Result,"errorinfo:",2)
	q Ret
}

/// Creator:陈莹
/// CreatDate:2015-5-11
/// Description:数据重复验证方法,js调用
/// Table:User.DHCOrderLinkTar
/// Input:arcimid , tariid, OLTRowId ,stdate
/// Return:""(数据重复),不为空(数据不重复)
/// Other:W ##class(web.DHCBL.CT.DHCOrderLinkTar).FormValidate("","","","")
ClassMethod FormValidate(arcimid As %String, tariid As %String, OLTRowId As %String, stdate As %String) As %String
{
	new (arcimid,tariid,OLTRowId,stdate)
	s result=""
	if (arcimid="")||(tariid="")
	{
		s result="没有获取到对应的医嘱项或收费项目，请重新查看！"
	}
	else
	{
		s StartDate=0
 		for 
 		{
	 		s StartDate=$o(^DHCOLT(0,"ARTTA",arcimid,tariid,StartDate)) q:StartDate="" 
	 		s linkid=0
	 		for
	 		{
		 		s linkid=$o(^DHCOLT(0,"ARTTA",arcimid,tariid,StartDate,linkid)) q:linkid="" 
		 		s EndDate=$p($g(^DHCOLT(linkid)),"^",5)
		 		///if ((EndDate>+$h)||(EndDate=""))&((OLTRowId="")||((OLTRowId'="")&(linkid'=OLTRowId))) s result="医嘱项与该收费项目已经关联！"
		 		///if ((EndDate>=stdate)||(EndDate=""))&((OLTRowId="")||((OLTRowId'="")&(linkid'=OLTRowId))) s result="医嘱项与该收费项目已经关联！"
		 		if ((EndDate>=stdate)||(EndDate=""))&&(OLTRowId="") s result="医嘱项与该收费项目已经关联！"
	 		}
 		}
 		
		
 	}
 		
	q result
}

/// Creator:陈莹
/// CreatDate:2016-11-25
/// Description:保存医嘱项与收费项目关联的信息
/// Table:User.DHCOrderLinkTar
/// Input:ImportFlag(导入时为Y，界面上保存时为空）
/// Return:
/// Other:w ##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCOrderLinkTar, ImportFlag As %String = "") As %String
{
	n (eobj,ImportFlag,%session)
 	s qresult=""
	if $IsObject(eobj)
	{
		S:eobj.OLTBascPriceFlag="" eobj.OLTBascPriceFlag="N"
		S:eobj.OLTBillOnceFlag="" eobj.OLTBillOnceFlag="N"
		
		s:eobj.OLTStartDate'="" eobj.OLTStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OLTStartDate)
		s:eobj.OLTEndDate'="" eobj.OLTEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OLTEndDate)
		if (eobj.OLTStartDate'="")&&(eobj.OLTEndDate'="")
		{
			if (eobj.OLTEndDate<eobj.OLTStartDate) Quit "{success:'false',errorinfo:'结束日期不能早于开始日期!'}"
		}
		s:eobj.OLTStartDate="" eobj.OLTStartDate=+$h   ///导入时 默认为当天
		
		If (eobj.OLTQty="") Quit "{success:'false',errorinfo:'关联收费项的数量不能为空!'}"
  		S valideresult=##class(web.DHCBL.CT.DHCOrderLinkTar).FormValidate(eobj.OLTARCIMDR,eobj.OLTTariffDR,eobj.OLTRowId,eobj.OLTStartDate)
		if (valideresult="")
		{
			//增加
			if (eobj.OLTRowId="")       
			{
				if ImportFlag=""  //新增一条数据，ImportFlag为1时为导入，不限制
				{
					If (eobj.OLTStartDate'="")&&(eobj.OLTStartDate<+$h) Quit "{success:'false',errorinfo:'医嘱项与收费项关联表的开始日期生效时间为当天的00:00，不能早于今天!'}"
					If (eobj.OLTEndDate'="")&&(eobj.OLTEndDate<+$h) Quit "{success:'false',errorinfo:'医嘱项与收费项关联表的结束日期生效时间为当天的24:00，不能早于今天!'}"	
					If (eobj.OLTStartDate=+$h)
					{
						///2020-05-26 医嘱项如果今天没开过，允许关联开始日期为今天。
						s userflag=##class(web.DHCBL.CT.DHCOrderLinkTar).GetOrderedFlag(eobj.OLTARCIMDR,+$h)
						if (userflag=1) Quit "{success:'false',errorinfo:'今日已经开过此医嘱，医嘱项与收费项关联的开始日期不能早于等于今天!'}"
						
					}
				}
				///2017-10-13限制医嘱子分类为Price类型的医嘱不能关联多条收费项
				if eobj.OLTARCIMDR["||"
				{
					s ARCIMItemCatDR=$p($g(^ARCIM($p(eobj.OLTARCIMDR,"||",1),$p(eobj.OLTARCIMDR,"||",2),1)),"^",10)
					S PriceFlag=##class(web.DHCBL.CT.DHCOrderLinkTar).GetPriceFlag(ARCIMItemCatDR,eobj.OLTARCIMDR,eobj.OLTStartDate_"^"_eobj.OLTEndDate)
					if PriceFlag=1 Quit "{success:'false',errorinfo:'医嘱子分类为Price类型的医嘱不能关联多条收费项，请核对数据!'}"
				}
				
				s obj=##class(User.DHCOrderLinkTar).%New()
			}
			else                           
			{	
			
				s obj=##class(User.DHCOrderLinkTar).%OpenId(eobj.OLTRowId)
				s bobj=##class(web.Entity.CT.DHCOrderLinkTar).%New()
				s bobj.OLTRowId = eobj.OLTRowId
				if $IsObject(obj.OLTARCIMDR){
					s bobj.OLTARCIMDR = obj.OLTARCIMDR.%Id() 
				}
				if $IsObject(obj.OLTTariffDR){
					s bobj.OLTTariffDR = obj.OLTTariffDR.%Id() 
				}
				s bobj.OLTQty = obj.OLTQty
				s bobj.OLTStartDate = obj.OLTStartDate                     
				s bobj.OLTEndDate= obj.OLTEndDate
				if $IsObject(obj.OLTTariffDR){
					s bobj.OLTTariffDR = obj.OLTTariffDR.%Id() 
				}	
				S bobj.OLTBascPriceFlag=obj.OLTBascPriceFlag
				S bobj.OLTBillOnceFlag=obj.OLTBillOnceFlag
				//If (obj.OLTEndDate=eobj.OLTEndDate)&(+obj.OLTQty=+eobj.OLTQty)&(obj.OLTBascPriceFlag=eobj.OLTBascPriceFlag)&&(obj.OLTBillOnceFlag=eobj.OLTBillOnceFlag) Quit "{success:'false',errorinfo:'数据没有变化!'}"
				if bobj.OLTStartDate<=+$h
				{
					if $IsObject(obj.OLTARCIMDR){
						s OLTARCIMDR = obj.OLTARCIMDR.%Id() 
						s OrderFlag="Y"
						i $d(^DHCPBi(0,"ARCIM",OLTARCIMDR)) d 
						.s OrderFlag="Y"
						e  d
						.s OrderFlag="N"
						if ((OrderFlag="Y")&(+obj.OLTQty'=+eobj.OLTQty)) quit "{success:'false',errorinfo:'医嘱项已使用,数量不能修改!'}"  //20190514考虑小于1的数据再数据库里存的是.5
					}
				}
				If (obj.OLTEndDate'="")&&(obj.OLTEndDate'=eobj.OLTEndDate)
				{
					Quit "{success:'false',errorinfo:'已经截止的关联收费项目,日期不能做任何修改!'}"	
				}		
				
				If (eobj.OLTEndDate'="")&&(eobj.OLTEndDate<+$h)&&(eobj.OLTEndDate'=(+$h-1))
				{
					Quit "{success:'false',errorinfo:'医嘱项与收费项关联表的结束日期生效时间为当天的24:00，不能早于今天!'}"	
				}
				
				///2020-05-26 医嘱项如果今天没开过，允许关联结束日期为昨天。
				If (eobj.OLTEndDate=(+$h-1))
				{
					s userflag=##class(web.DHCBL.CT.DHCOrderLinkTar).GetOrderedFlag(eobj.OLTARCIMDR,+$h)
					if (userflag=1) Quit "{success:'false',errorinfo:'医嘱项今天有开过，医嘱项与收费项关联表的结束日期不允许早于今天!'}"
				}
				
			}	
			d obj.OLTARCIMDRSetObjectId(eobj.OLTARCIMDR)
			d obj.OLTTariffDRSetObjectId(eobj.OLTTariffDR)		
			s obj.OLTQty= eobj.OLTQty 
			s obj.OLTStartDate= eobj.OLTStartDate
			s obj.OLTEndDate= eobj.OLTEndDate 
			S obj.OLTBascPriceFlag=eobj.OLTBascPriceFlag
			S obj.OLTBillOnceFlag=eobj.OLTBillOnceFlag
			
			s ARCIMDesc=$p($g(^ARCIM($p(eobj.OLTARCIMDR,"||",1),$p(eobj.OLTARCIMDR,"||",2),1)),"^",2)
			s TARIDesc =$p($g(^DHCTARI(eobj.OLTTariffDR)),"^",2)
			S Desc=ARCIMDesc_"--"_TARIDesc
			
			Tstart
			s sc=obj.%Save()
			if $$$ISOK(sc){
				Tcommit
				s id = obj.%Id()
				d:eobj.OLTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_OrderLinkTar","User.DHCOrderLinkTar","医嘱项与收费项关联",id,Desc,"A",eobj)
				d:eobj.OLTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_OrderLinkTar","User.DHCOrderLinkTar","医嘱项与收费项关联",id,Desc,"U",eobj,bobj)
				s qresult = "{success:'true',id:'"_id_"'}"        //保存数据后,通过RowId返回到这条数据
				
			}else{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项与收费项关联","web.DHCBL.CT.DHCOrderLinkTar","SaveEntity",eobj)
 				s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s qresult = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}		
		}
		else
		{
			s qresult="{success:'false',errorinfo:'"_valideresult_"'}"
		}
	}
	else
	{
		s qresult = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q qresult
}

/// Function: 用于关联收费项处的"收费项"放大镜
/// CreateDate: 2014-8-23
/// Creator:  chenying
/// ,hospid(医院id)
/// Debug:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCOrderLinkTar","TaritemList","","","")
Query TaritemList(tarcode As %String, tarname As %String, hospid As %String = "") As %Query(ROWSPEC = "tarirowid:%String:收费项目ID, taricode:%String:收费项目代码, taridesc:%String:收费项目名称, ItmPrice:%String:价格(元), tariuom:%String:单位")
{
}

ClassMethod TaritemListExecute(ByRef qHandle As %Binary, tarcode As %String, tarname As %String, hospid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s AuStr=##class(web.DHCBL.Authorize.DHCTarItem).DHCGetDataByDefaultSession()
	s AuFlag=0
	;未授权情况下，默认显示全部数据
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	
	s DHCTarSubCateAuStr=##class(web.DHCBL.Authorize.DHCTarSubCate).DHCGetDataByDefaultSession()  //收费项目子类
	s DHCTarSubCateAuFlag=0
	;未授权情况下，默认显示全部数据
	if (DHCTarSubCateAuStr="")||(DHCTarSubCateAuStr["limited:0") s DHCTarSubCateAuFlag=1
	
	s DHCTarOutpatCateAuStr=##class(web.DHCBL.Authorize.DHCTarOutpatCate).DHCGetDataByDefaultSession() //门诊费用子类 
	s DHCTarOutpatCateAuFlag=0
	;未授权情况下，默认显示全部数据
	if (DHCTarOutpatCateAuStr="")||(DHCTarOutpatCateAuStr["limited:0") s DHCTarOutpatCateAuFlag=1
	
	s DHCTarAcctCateAuStr=##class(web.DHCBL.Authorize.DHCTarAcctCate).DHCGetDataByDefaultSession()  //会计费用子类
	s DHCTarAcctCateAuFlag=0
	;未授权情况下，默认显示全部数据
	if (DHCTarAcctCateAuStr="")||(DHCTarAcctCateAuStr["limited:0") s DHCTarAcctCateAuFlag=1
	
	s DHCTarEMCCateAuStr=##class(web.DHCBL.Authorize.DHCTarEMCCate).DHCGetDataByDefaultSession()  //经济核算子类
	s DHCTarEMCCateAuFlag=0
	;未授权情况下，默认显示全部数据
	if (DHCTarEMCCateAuStr="")||(DHCTarEMCCateAuStr["limited:0") s DHCTarEMCCateAuFlag=1
	
	s DHCTarMRCateAuStr=##class(web.DHCBL.Authorize.DHCTarMRCate).DHCGetDataByDefaultSession()  //病案首页子类
	s DHCTarMRCateAuFlag=0
	;未授权情况下，默认显示全部数据
	if (DHCTarMRCateAuStr="")||(DHCTarMRCateAuStr["limited:0") s DHCTarMRCateAuFlag=1
	
	s DHCTarInpatCateAuStr=##class(web.DHCBL.Authorize.DHCTarInpatCate).DHCGetDataByDefaultSession()  //住院费用子类
	s DHCTarInpatCateAuFlag=0
	;未授权情况下，默认显示全部数据
	if (DHCTarInpatCateAuStr="")||(DHCTarInpatCateAuStr["limited:0") s DHCTarInpatCateAuFlag=1
	
	s DHCNewTarMRCateAuStr=##class(web.DHCBL.Authorize.DHCNewTarMRCate).DHCGetDataByDefaultSession() //新病案首页子类
	s DHCNewTarMRCateAuFlag=0
	;未授权情况下，默认显示全部数据
	if (DHCNewTarMRCateAuStr="")||(DHCNewTarMRCateAuStr["limited:0") s DHCNewTarMRCateAuFlag=1
	s tarcode=$ZCONVERT(tarcode,"U")
	S tarname=$ZCONVERT(tarname,"U")
	Set trowid=0
	For
	{
		Set trowid=$o(^DHCTARI(trowid)) Quit:trowid=""
		if $g(^DHCTARI(trowid))="" continue  ///过滤空数据
		s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarItem",trowid,hospid)
		continue:showflag="N"
		s strRowId="{ID:"_trowid_"}"
		continue:'((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
		s TarSubCate =$p($g(^DHCTARI(trowid)),"^",4) ///收费项目子类
		s TarAcctCate = $p($g(^DHCTARI(trowid)),"^",5)   ///收费会计子类
		s TarOutpatCate =  $p($g(^DHCTARI(trowid)),"^",15)  ///门诊费用子类
		s TarInpatCate =$p($g(^DHCTARI(trowid)),"^",14)  ///住院费用子类
		s TarEMCCate = $p($g(^DHCTARI(trowid)),"^",16)  ///经济核算子类
		s TarMRCate =$p($g(^DHCTARI(trowid)),"^",6)  ///旧病案首页子类
		s NewTarMRCate=$p($g(^DHCTARI(trowid)),"^",30) ///新病案首页子类	
		continue:'(((DHCTarSubCateAuStr[("{ID:"_TarSubCate_"}"))||(DHCTarSubCateAuFlag=1))&((DHCTarAcctCateAuStr[("{ID:"_TarAcctCate_"}"))||(DHCTarAcctCateAuFlag=1))&((DHCTarOutpatCateAuStr[("{ID:"_TarOutpatCate_"}"))||(DHCTarOutpatCateAuFlag=1))&((DHCTarInpatCateAuStr[("{ID:"_TarInpatCate_"}"))||(DHCTarInpatCateAuFlag=1))&((DHCTarEMCCateAuStr[("{ID:"_TarEMCCate_"}"))||(DHCTarEMCCateAuFlag=1))&((DHCTarMRCateAuStr[("{ID:"_TarMRCate_"}"))||(DHCTarMRCateAuFlag=1))&((DHCNewTarMRCateAuStr[("{ID:"_NewTarMRCate_"}"))||(DHCNewTarMRCateAuFlag=1)))	
		Set tcode=$P($g(^DHCTARI(trowid)),"^",1) 
		Set tdesc=$P($g(^DHCTARI(trowid)),"^",2)
		Set tariuom=$P($g(^DHCTARI(trowid)),"^",3) 
		Set:tariuom'="" tariuom=$P($g(^CT("UOM",tariuom)),"^",2)   
		Set TARIActiveFlag=$P($g(^DHCTARI(trowid)),"^",7)
		Set TARIEndDate=$P($g(^DHCTARI(trowid)),"^",12)
		s aliaid=0
		s AFlag=0
		
		if tarname'=""
		{
			for 
			{
				Set aliaid=$o(^DHCTARAL("A",trowid,aliaid)) q:aliaid=""
				Set talias=$P($g(^DHCTARAL(aliaid)),"^",3)
				if ($ZCONVERT(talias,"U")[tarname)
				{
					s AFlag=1
					q
				}
			}
		}
		s PINYIN=""
		s:tarname'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(tdesc)
		continue:((TARIEndDate'="")&(TARIEndDate<+$h))
		continue:(TARIActiveFlag="N")
		s TARIChargeBasis= $p($g(^DHCTARI(trowid)),"^",20)  //收费依据
		
		If ($ZCONVERT(tcode,"U")[tarcode)&(($ZCONVERT(tdesc,"U")[tarname)||((PINYIN[tarname))||(AFlag=1)||($ZCONVERT(TARIChargeBasis,"U")[tarname))
		{
			s ItmPrice=##class(web.DHCBL.CT.ARCItmMast).GetTariPrice(trowid,hospid)
			Do OutputRowTARI
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 
OutputRowTARI
 set Data=$lb(trowid,tcode,tdesc,ItmPrice,tariuom)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod TaritemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TaritemListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 //
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" { 
     // if there are no more rows, finish fetching
  Set AtEnd=1
  Set Row=""
 }
 Else      {
  // fetch row
  Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod TaritemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TaritemListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2017-10-19  河北唐山人民
/// Description:保存医嘱项与收费项目关联的信息
/// Table:User.DHCOrderLinkTar
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.CT.DHCOrderLinkTar).NewLinkTar("8^8^2017-05-17^2017-10-19^^1^false^false")
/// oltrowid^tarirowid^oldenddate^newstartdate^newenddate^qty^basepriceflag^billonceflag
ClassMethod NewLinkTar(infostr) As %String
{
	n (infostr,%session)
	
	s oltrowid=$p(infostr,"^",1)
	s arcimrowid=$p($g(^DHCOLT(oltrowid)),"^",1)
	s tarirowid=$p(infostr,"^",2)
	q:(tarirowid="")||(oltrowid="")||(arcimrowid="") "{success:'false',errorinfo:'收费项不能为空'}"
	///结束原有的对照关系
	if $p($g(^DHCOLT(oltrowid)),"^",5)=""
	{
		s eobj = ##class(web.Entity.CT.DHCOrderLinkTar).%New()
		s eobj.OLTRowId = oltrowid
		s eobj.OLTARCIMDR=$p($g(^DHCOLT(oltrowid)),"^",1)
		s eobj.OLTTariffDR=$p($g(^DHCOLT(oltrowid)),"^",2)
		s eobj.OLTQty=$p($g(^DHCOLT(oltrowid)),"^",3)
		s eobj.OLTBascPriceFlag=$p($g(^DHCOLT(oltrowid)),"^",3)
		s eobj.OLTBillOnceFlag=$p($g(^DHCOLT(oltrowid)),"^",8)
		s OLTStartDate=$p($g(^DHCOLT(oltrowid)),"^",9)
		s:OLTStartDate'="" OLTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OLTStartDate)
		s eobj.OLTStartDate=OLTStartDate
		s eobj.OLTEndDate=$p(infostr,"^",3)
		d ##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(eobj)
	}
	k Neobj
	s Neobj=##class(web.Entity.CT.DHCOrderLinkTar).%New()
	s Neobj.OLTARCIMDR=arcimrowid
	s Neobj.OLTTariffDR=tarirowid
	s Neobj.OLTQty=$p(infostr,"^",6)
	s Neobj.OLTStartDate=$p(infostr,"^",4)
	s Neobj.OLTEndDate=$p(infostr,"^",5)
	s OLTBascPriceFlag=$p(infostr,"^",7)
	if OLTBascPriceFlag="true" s OLTBascPriceFlag="Y"
	if OLTBascPriceFlag="false" s OLTBascPriceFlag="N"
	s Neobj.OLTBascPriceFlag=OLTBascPriceFlag
	s OLTBillOnceFlag=$p(infostr,"^",8)
	if OLTBillOnceFlag="true" s OLTBillOnceFlag="Y"
	if OLTBillOnceFlag="false" s OLTBillOnceFlag="N"
	s Neobj.OLTBillOnceFlag=OLTBillOnceFlag
	s Result= ##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(Neobj)
	Quit Result
}

/// Creator:陈莹
/// CreatDate:2017-10-13
/// Description:通过医嘱项 医嘱子分类为price类型时不能关联多条收费项，返回1为不能保存，返回0可以保存
/// w ##class(web.DHCBL.CT.DHCOrderLinkTar).GetPriceFlag(140,"29||1","新对照开始日期^结束日期&新对照开始日期2^结束日期2)
/// w ##class(web.DHCBL.CT.DHCOrderLinkTar).GetPriceFlag(140,"1902||1","64688^64688")
ClassMethod GetPriceFlag(ARCIMItemCatDR, ARCIMRowId, NewLinkStr) As %String
{
	n (ARCIMItemCatDR,ARCIMRowId,NewLinkStr)
	s flag=0
	if (ARCIMItemCatDR'="")
	{
		s ARCICOrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
		if ARCICOrderType="P"
		{
			k myArray
			s Count=0
			///修改医嘱时，或者对照时，判断医嘱已经关联的收费项个数
			if (ARCIMRowId'="")
			{
				s OLTTariffDR=0
				for
				{
					s OLTTariffDR=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,OLTTariffDR)) q:OLTTariffDR=""   
					s OLTStartDate=0
					for
					{
						s OLTStartDate=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,OLTTariffDR,OLTStartDate)) q:OLTStartDate=""
						s OLTRowId=0
						for
						{
							s OLTRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,OLTTariffDR,OLTStartDate,OLTRowId)) q:OLTRowId=""
							s OLTEndDate=$p($g(^DHCOLT(OLTRowId)),"^",5)
							if ((OLTEndDate'="")&&(OLTEndDate<+$h)) continue   //已经结束的对照过滤掉
							if (OLTStartDate>+$H)
							{
								s repid=$I(myArray)
								S myArray(repid)=OLTStartDate_"^"_OLTEndDate
							}
							else
							{
								s Count=Count+1  //今天还在生效的收费项个数
								s repid=$I(myArray)
								S myArray(repid)=OLTStartDate_"^"_OLTEndDate
							}
							
						}
					}
				}
			}
			
			if (Count>1)
			{
				 s flag=1
			}
			else
			{
				if (NewLinkStr'="")  //增加医嘱项、复制收费项、增加对照
				{
					s length=$l(NewLinkStr,"&")
					for m=1:1:length
					{
						s NewLinkStrm=$p(NewLinkStr,"&",m)
						s OLTStartDate=$P(NewLinkStrm,"^",1)
						s OLTEndDate=$P(NewLinkStrm,"^",2)
						if (OLTStartDate'="")&&(OLTStartDate["-") s OLTStartDate=$zd(OLTStartDate,3)
						if (OLTEndDate'="")&&(OLTEndDate["-") s OLTEndDate=$zd(OLTEndDate,3)
						s repid=$I(myArray)
						S myArray(repid)=OLTStartDate_"^"_OLTEndDate
					}
				}
				
				s i=0
				for
				{
					s i=$o(myArray(i)) q:(i="")||(flag=1)
					s iOLTStartDate=$P(myArray(i),"^",1)
					s iOLTEndDate=$P(myArray(i),"^",2)
					s j=0
					for
					{
						s j=$o(myArray(j)) q:(j="")||(flag=1)
						continue:i=j
						s OLTStartDate=$P(myArray(j),"^",1)
						s OLTEndDate=$P(myArray(j),"^",2)
						if ((OLTStartDate<iOLTStartDate)&&(OLTEndDate'="")&&(OLTEndDate<iOLTStartDate))||((iOLTStartDate<OLTStartDate)&&(iOLTEndDate'="")&&(iOLTEndDate<OLTStartDate)) S flag=0
						else  s flag=1
					}
				}
			}
			
		} 
	}
	q flag
}

/*
b ;1
    q:arcimrowid="" $$$OK
	s ItemCatDR=$p($g(^ARCIM(+arcimrowid,$p(arcimrowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		i (OrderType="R") {
		s CNMedItemFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(arcimrowid) //草药标志
		s INCIrow=0
		f {
			s INCIrow=$o(^INCI(0,"ARCIM_DR",+arcimrowid,INCIrow))
			Q:INCIrow=""
			if (CNMedItemFlag=1){
				s INCIDesc="库存项--"_$p($g(^INCI(INCIrow,1)),"^",2)
				s INCICode=$p($g(^INCI(INCIrow,1)),"^",1)
				s ^CacheTemp(repid,ind)=$lb(INCIrow,INCICode,INCIDesc,"","","","","","","")
				s ind=ind+1
			}
			Set rset=##Class(%ResultSet).%New("web.DHCST.INCLINKTAR:QueryIncLinkTar")
			If rset.QueryIsValid() {
				Set Status=rset.Execute(INCIrow)
				If 'Status Quit
				Set columns = rset.GetColumnCount()
				While (rset.Next()) {
				    //lnkId,tarItmId,tarItmCode,tarItmDesc,uomDesc,qty,sp,lnkStDate,lnkEdDate
				    s arcimdr=arcimrowid
					s olttariffdr=rset.Data("tarItmId")
					s tarcode=rset.Data("tarItmCode")
					s tardesc=rset.Data("tarItmDesc")
					s tarnum=rset.Data("qty")
					s taruom=rset.Data("uomDesc")
					s tarDate=rset.Data("lnkStDate")
					s tarDateTo=rset.Data("lnkEdDate")
					s OLTBascPriceFlag="N"
					s OLTBillOnceFlag="N"
					s tarprice=rset.Data("sp")
					s ^CacheTemp(repid,ind)=$lb(arcimdr,olttariffdr,tarcode,tardesc,tarnum,taruom,tarDate,tarDateTo,OLTBascPriceFlag,OLTBillOnceFlag,tarprice)
					s ind=ind+1
				}
			}
		}
	}else{
		s olttariffdr=0
		for
		{
			b ;2
			s olttariffdr=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr)) q:olttariffdr="" 
			b ; olttariffdr
			s startdate=0
			for
			{
				s startdate=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate)) q:startdate=""
				b ;startdate
				s associaterowid=0
				for
				{
					s associaterowid=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate,associaterowid)) q:associaterowid=""
					b ;associaterowid
					s arcimdr=arcimrowid
					s tarcode="",tardesc=""
					s tarcode=$P($G(^DHCTARI(olttariffdr)),"^",1) 
					s tardesc=$P($G(^DHCTARI(olttariffdr)),"^",2) 
					
					s tarDate=startdate
					s tarnum=$p($g(^DHCOLT(associaterowid)),"^",3)
					s taruom=$p($g(^DHCTARI(olttariffdr)),"^",3)
					s:taruom'="" taruom=$p($g(^CT("UOM",taruom)),"^",2)
					s:tarDate'="" tarDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(tarDate)
					s tarDateTo=$p($g(^DHCOLT(associaterowid)),"^",5)
					s:tarDateTo'="" tarDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(tarDateTo)
					
					
					s OLTBascPriceFlag=$p($g(^DHCOLT(associaterowid)),"^",8)
					s OLTBillOnceFlag=$p($g(^DHCOLT(associaterowid)),"^",9)
					
					
					s:OLTBascPriceFlag="" OLTBascPriceFlag="N"
					s:OLTBillOnceFlag="" OLTBillOnceFlag="N"
					
					// s OLTInstDR=$p($g(^DHCOLT(associaterowid)),"^",6)
					//取收费项目价格（收费项目单价）0823
					; 收费项价格
					s tarprice=##class(web.DHCBL.CT.ARCItmMast).GetTariPrice(olttariffdr)
					d OutputRow   
				}
			}
		}
	}
	*/
/// Creator:陈莹
/// CreatDate:2020-07-08
/// Description:判断医嘱项某个日期是否有开过出这个医嘱项
/// 返回值>0 开过；空 没开过
/// w ##class(web.DHCBL.CT.DHCOrderLinkTar).GetOrderedFlag("1902||1",+$h)
ClassMethod GetOrderedFlag(ARCIMRowId, OrderDate) As %String
{
	n (ARCIMRowId, OrderDate)
	q:ARCIMRowId="" ""
	s userflag=""
	s Date=OrderDate
	s:Date="" Date=+$h  //默认当天
	//^OEORDi(0,"DateARCIM",{OEORE_ExStDate},OEORIItmMastDR,{OE_Order.OEORD_RowId},{OE_OrdItem.OEORI_Childsub},{OEORE_Childsub})
	S OEORDRowId=$o(^OEORDi(0,"DateARCIM",Date,ARCIMRowId,0))  //医嘱执行记录 User.OEOrdExec
	if (OEORDRowId>0)
	{
		s userflag=1
	}
	else
	{
		s OEORDRowId=0
		for
		{
			s OEORDRowId=$o(^OEORDi(0,"ItemDate",Date,OEORDRowId)) q:(OEORDRowId="")||(userflag=1)  //User.OEOrder
			s OEORIChildsub=0
			for
			{
				s OEORIChildsub=$o(^OEORDi(0,"ItemDate",Date,OEORDRowId,OEORIChildsub)) q:(OEORIChildsub="")   ///User.OEOrdItem  医嘱表
				S OEORIItmMastDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)  //医嘱项id
				if (OEORIItmMastDR=ARCIMRowId)
				{
					s userflag=1	  //说明当天开过改医嘱，所以不允许当天生效
					q
				}
			}
		}
	}
	q userflag
}

/// Creator:陈莹
/// CreatDate:2021-06-16
/// Description:判断一个医嘱项 所关联的收费项（没截止关联关系的）有没有收费项是无效状态的
/// 1有（不允许开此医嘱）  ;0没有（允许开此医嘱）
/// w ##class(web.DHCBL.CT.DHCOrderLinkTar).GetLinkedInValidTARIFlag("1902||1")
ClassMethod GetLinkedInValidTARIFlag(arcimrowid) As %String
{
	n (arcimrowid)
	q:arcimrowid="" ""
	s flag=0
	s olttariffdr=0
	for
	{
		s olttariffdr=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr)) q:((olttariffdr="")||(flag=1))  
		s startdate=0
		for
		{
			s startdate=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate)) q:((startdate="")||(flag=1))  
			s associaterowid=0
			for
			{
				s associaterowid=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate,associaterowid)) q:((associaterowid="")||(flag=1))  
				s tarDateTo=$p($g(^DHCOLT(associaterowid)),"^",5)
				if ((tarDateTo="")||((tarDateTo'="")&&(tarDateTo>+$H)))
				{
					s TARIActiveFlag=$p($g(^DHCTARI(olttariffdr)),"^",7)
					if (TARIActiveFlag="N") s flag=1
				}
			}
		}
	}
	q flag
}

}
