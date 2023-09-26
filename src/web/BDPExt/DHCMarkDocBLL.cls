/// Creator:陈莹
/// CreatDate:2017-03-20
/// Description:医生号别对照 4
Class web.BDPExt.DHCMarkDocBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2017-03-20
/// Description:保存医生号别对照
/// Table:User.DHCMarkDoc
/// Other:w ##class(web.BDPExt.DHCMarkDocBLL).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.BDPExt.DHCMarkDocEntity) As %String
{
	n (eobj,%session)
	s ImportResult=""
	
	s flag=##class(web.BDPExt.DHCMarkDocBLL).FormValidate(eobj.ID,eobj.MarkddepDr,eobj.MarkdDocDr,eobj.MarkdMarkDr)
	if flag=1  q "{success:'false',errorinfo:'该对照已存在'}"
	
	ts
	s obj=##class(User.DHCMarkDoc).%New()
	d obj.MarkddepDrSetObjectId(eobj.MarkddepDr)
	d obj.MarkdDocDrSetObjectId(eobj.MarkdDocDr)
	d obj.MarkdMarkDrSetObjectId(eobj.MarkdMarkDr)
	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s DHCMarkDocid = obj.%Id()
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHCMarkDoc","User.DHCMarkDoc","医生号别对照",DHCMarkDocid,eobj.MarkddepDr,"A",eobj)
	}
	else
	{
		s ImportResult = ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	
	if (ImportResult="")
	{
		tc
		s ImportResult="{success:'true',id:'"_DHCMarkDocid_"'}" 
	}
	else
	{
		tro
	}
	q ImportResult
}

/// Creator：陈莹
/// CreatDate: 2017-03-20
/// Description：校验医护人员/号别是否在rbresource表里与科室对照
/// Table：User.RBResource
/// Input：ctcareprov,ctlocdr
/// Return："1"(符合),"0"(不符合)
/// w ##class(web.BDPExt.DHCMarkDocBLL).CheckCTCareProvData("2","22")
ClassMethod CheckCTCareProvData(ctcareprovdr, ctlocdr) As %String
{
	n (ctcareprovdr,ctlocdr)
	Q:(ctcareprovdr="")||(ctlocdr="") 0
	s flagc=$o(^RB("RES",0,"CTPCP",ctcareprovdr,ctlocdr,0))
	if flagc'=""  s flag=1
	else  s flag=0
	q flag
}

/// Creator：陈莹
/// CreatDate: 2017-03-20
/// Description：校验科室在访问类型位置表里的是不是O/E类型
/// Table：User.PACAdmTypeLocation
/// Input：ctlocdr
/// Return："1"(符合),"0"(不符合)
/// w ##class(web.BDPExt.DHCMarkDocBLL).CheckCTLocData("22")
ClassMethod CheckCTLocData(ctlocdr) As %String
{
	n (ctlocdr)
	Q:(ctlocdr="") 0
	s flagc=$o(^PAC("ADMLOC",0,"AdmType","E",ctlocdr,0))
	s flagd=$o(^PAC("ADMLOC",0,"AdmType","O",ctlocdr,0))
	if (flagc'="")||(flagd'="")  s flag=1
	else  s flag=0
	q flag
}

/// Creator：陈莹
/// CreatDate: 2017-03-20
/// Description：数据重复验证方法
/// Table：User.DHCExaBorough
/// Input：id, code, desc
/// Return："1"(重复),"0"(不重复)
/// w ##class(web.BDPExt.DHCMarkDocBLL).FormValidate("","","","")
ClassMethod FormValidate(id, depDr, DocDr, MarkDr) As %String
{
	n (id,depDr,DocDr,MarkDr)
	q:(depDr="")||(DocDr="")||(MarkDr="") 0
	s flag=0,flagd=0
	s flagd=$d(^User.DHCMarkDocI("MarkddepDrIndex",depDr))
	if (flagd>0)
	{
		s idd=0
		for 
		{
			s idd=$o(^User.DHCMarkDocI("MarkddepDrIndex",depDr,idd)) q:(idd="")||(flag=1)
			s MarkdDocDr=$lg($g(^User.DHCMarkDocD(idd)),2)
			s MarkdMarkDr=$lg($g(^User.DHCMarkDocD(idd)),3)
			continue:(MarkdDocDr="")
			continue:(MarkdMarkDr="")
			if ((id="")&(DocDr=MarkdDocDr)&(MarkDr=MarkdMarkDr))||((DocDr=MarkdDocDr)&(MarkDr=MarkdMarkDr)&(id'="")&(id'=idd)) s flag=1
		
		}
		
	}
	q flag
}

}
