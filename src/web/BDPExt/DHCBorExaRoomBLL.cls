/// Function:    2 分诊区诊室对照
/// Creator:     sunfengchao
/// CreateDate:  2017-3-1
Class web.BDPExt.DHCBorExaRoomBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function: 分诊区诊室对照 实现增加操作
/// chenying 修改  2017-03-17
/// Creator:  基础数据平台组sunfengchao
/// CreateDate:2017-03-01
/// Tables: DHCBorExaRoom
ClassMethod SaveEntity(eobj As web.BDPExt.DHCBorExaRoomEntity) As %String
{
	n (eobj,%session)
	s $zt="ERROR"
	s result="",flag=0
	s flag=..FormValidate(eobj.ID,eobj.BorDr,eobj.BorExaRoomDr)
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
		s obj=##class(User.DHCBorExaRoom).%New()
		d obj.BorDrSetObjectId(eobj.BorDr)
		s obj.BorExaRoomDr=eobj.BorExaRoomDr
		s obj.Memo = eobj.Memo     
		
		s Desc=$lg($g(^User.DHCExaBoroughD(eobj.BorDr)),5)_"-"_$p($g(^CTLOC(eobj.BorExaRoomDr)),"^",2)
		               
		Tstart
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"         
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHCBorExaRoom","User.DHCBorExaRoom","分诊区诊室对照",id,Desc,"A",eobj)
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分诊区诊室对照","web.BDPExt.DHCBorExaRoomBLL","SaveEntity",eobj)
			s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		} 
	}

	q result
ERROR
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Function:数据重复校验
/// Table：DHCBorExaRoom
/// chenying 修改  2017-03-17
/// Input： id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.BDPExt.DHCBorExaRoomBLL).FormValidate("",55,"33")
ClassMethod FormValidate(id As %String, BorDr As %String, BorExaRoomDr As %String) As %String
{
	n (id,BorDr,BorExaRoomDr)
	q:((BorDr="")||(BorExaRoomDr="")) 0
	s flag=0,flagc=0,flagd=0
	s flagd=$d(^User.DHCBorExaRoomI("BordExaRoomDrIndex"," "_$zcvt(BorExaRoomDr,"U")))
	if flagd>0
	{
		s flagc=$d(^User.DHCBorExaRoomI("BordBorDrIndex",BorDr))
		if ((flagc>0)) 
		{
			s idc=0
			for 
			{
				s idc=$o(^User.DHCBorExaRoomI("BordBorDrIndex",BorDr,idc)) q:(idc="")||(flag=1)
				s RoomDr=$lg($g(^User.DHCBorExaRoomD(idc)),6)
				continue:RoomDr=""
				if ((id="")&(RoomDr=BorExaRoomDr))||((RoomDr=BorExaRoomDr)&(id'="")&(id'=idc)) s flag=1
			
			}
		}
	}
	q flag
}

/// Debug: d ##class(web.BDPExt.DHCBorExaRoomBLL).SaveTest()
ClassMethod SaveTest()
{
    s eobj=##class(web.BDPExt.DHCBorExaRoomEntity).%New()
    s eobj.BorDr=55 ;指向
    s eobj.BorExaRoomDr="31" ; string
    s eobj.Memo="测试"
    w ..SaveEntity(eobj)
}

}
