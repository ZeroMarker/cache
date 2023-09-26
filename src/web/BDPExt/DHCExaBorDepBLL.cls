/// Description:3 分诊区科室对照
/// Creator: sunfengchao
/// CreateDate:2017-3-2
Class web.BDPExt.DHCExaBorDepBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function: 分诊区科室对照 实现增加操作
/// Creator:  基础数据平台组sunfengchao
/// chenying 修改  2017-03-17
/// CreateDate:2017-03-01
/// Tables: DHCExaBorDep
ClassMethod SaveEntity(eobj As web.BDPExt.DHCExaBorDepEntity) As %String
{
	n (eobj,%session)
	s $zt="ERROR"
	s result="",flag=0
	
	//获取分诊区rowid
	
	s flag=..FormValidate(eobj.ID,eobj.BordBorDr,eobj.BordDepDr)
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
		s obj=##class(User.DHCExaBorDep).%New()
		
		d obj.BordBorDrSetObjectId(eobj.BordBorDr)
		d obj.BordDepDrSetObjectId(eobj.BordDepDr)   //2019-01-29  原来是string s obj.BordDepDr=eobj.BordDepDr
		s obj.BordMemo = eobj.BordMemo   
		s Desc=$lg($g(^User.DHCExaBoroughD(eobj.BordBorDr)),5)_"-"_$p($g(^CTLOC(eobj.BordDepDr)),"^",2)
		  
		Tstart
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"         
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHCExaBorDep","User.DHCExaBorDep","分诊区科室对照",id,Desc,"A",eobj)
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分诊区科室对照","web.BDPExt.DHCExaBorDep","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		} 
	}
	q result
ERROR
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// 陈莹 修改  2017-03-16
/// Function:数据重复校验  
/// Table： DHCExaBorDep
/// Input： id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.BDPExt.DHCExaBorDepBLL).FormValidate("",58,"45")
ClassMethod FormValidate(id As %String, BordBordBorDr As %String, BordDepDr As %String) As %String
{
	n (id,BordBordBorDr,BordDepDr)
	q:((BordBordBorDr="")||(BordDepDr="")) 0
	s flag=0,flagc=0,flagd=0
	s flagd=$d(^User.DHCExaBorDepI("BordDepDrIndex"," "_$ZCVT(BordDepDr,"U")))
	if flagd>0
	{
		s flagc=$d(^User.DHCExaBorDepI("BordBorDrIndex",BordBordBorDr))
		if ((flagc>0)) 
		{
			s idc=0
			for 
			{
				s idc=$o(^User.DHCExaBorDepI("BordBorDrIndex",BordBordBorDr,idc)) q:(idc="")||(flag=1)
				s DepDr=$lg($g(^User.DHCExaBorDepD(idc)),7)
				continue:DepDr=""
				if ((id="")&(DepDr=BordDepDr))||((DepDr=BordDepDr)&(id'="")&(id'=idc)) s flag=1
			
			}
		}
	}
	q flag
}

/// Debug: d ##class(web.BDPExt.DHCExaBorDepBLL).SaveTest()
ClassMethod SaveTest()
{
    s eobj=##class(web.BDPExt.DHCExaBorDepEntity).%New()
    s eobj.BordBorDr=55 ;指向
    s eobj.BordDepDr="44" ; string
    s eobj.BordMemo="测试"
    w ..SaveEntity(eobj)
}

}
