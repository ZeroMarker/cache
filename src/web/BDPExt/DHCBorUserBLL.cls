/// Creator:陈莹
/// CreatDate:2017-03-16
/// Description:保存操作员诊区对照
Class web.BDPExt.DHCBorUserBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2017-03-16
/// Description:保存操作员诊区对照`
/// Table:User.DHCBorUser
/// Other:w ##class(web.BDPExt.DHCBorUserBLL).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.BDPExt.DHCBorUserEntity) As %String
{
	n (eobj,%session)
	s ImportResult=""
	s flag=##class(web.BDPExt.DHCBorUserBLL).FormValidate(eobj.ID,eobj.BoruBorDr,eobj.BoruUseDr)
	if flag=1  q "{success:'false',errorinfo:'该对照已存在'}"
	
	ts
	s obj=##class(User.DHCBorUser).%New()
	d obj.BoruBorDrSetObjectId(eobj.BoruBorDr)	
	s obj.BoruUseDr = eobj.BoruUseDr 
	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s DHCBorUserid = obj.%Id()
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHCBorUser","User.DHCBorUser","操作员诊区对照",DHCBorUserid,eobj.BoruUseDrName,"A",eobj)
	}
	else
	{
		s ImportResult = ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	
	if (ImportResult="")
	{
		tc
		s ImportResult="{success:'true',id:'"_DHCBorUserid_"'}" 
	}
	else
	{
		tro
	}
	q ImportResult
}

/// Creator：陈莹
/// CreatDate: 2017-03-16
/// Description：数据重复验证方法
/// Table：User.DHCExaBorough
/// Input：id, code, desc
/// Return："1"(重复),"0"(不重复)
/// w ##class(web.BDPExt.DHCBorUserBLL).FormValidate("","","")
ClassMethod FormValidate(id As %String, bordr As %String, userdr As %String) As %String
{
	n (id,bordr,userdr)
	q:(bordr="")||(userdr="") 0
	s flag=0,flagb=0,flagd=0
	s flagb=$d(^User.DHCBorUserI("BoruBorDrIndex",bordr))
	s flagd=$d(^User.DHCBorUserI("BoruUseDrIndex"," "_$ZCVT(userdr,"U")))
	if (flagd'=0)&(flagb'=0)
	{
		if ((flagb>0)) 
		{
			s idb=0
			for 
			{
				s idb=$o(^User.DHCBorUserI("BoruBorDrIndex",bordr,idb)) q:(idb="")||(flag=1)
				s BoruUseDr=$lg($g(^User.DHCBorUserD(idb)),3)
				continue:(BoruUseDr="")
				if ((id="")&(userdr=BoruUseDr))||((userdr=BoruUseDr)&(id'="")&(id'=idb)) s flag=1
			
			}
		}
	}
	q flag
}

}
