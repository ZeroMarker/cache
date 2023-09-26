/// Creator:陈莹
/// CreatDate:2017-03-16
/// Description:分诊区号别对照 5
Class web.BDPExt.DHCDepMarkBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2017-03-16
/// Description:保存分诊区号别对照  
/// Table:User.DHCDepMark
/// Other:w ##class(web.BDPExt.DHCDepMarkBLL).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.BDPExt.DHCDepMarkEntity) As %String
{
	n (eobj,%session)
	s ImportResult=""
	
	if (eobj.DepmSign="Y")||(eobj.DepmSign="y")||(eobj.DepmSign="是") s eobj.DepmSign="Y"
	else  s eobj.DepmSign="N"
	
	if (eobj.DepmCheckin="Y")||(eobj.DepmCheckin="y")||(eobj.DepmCheckin="是") s eobj.DepmCheckin="Y"
	else  s eobj.DepmCheckin="N"
	
	s flag=##class(web.BDPExt.DHCDepMarkBLL).FormValidate(eobj.ID,eobj.DepmBorDr,eobj.DepmDepDr,eobj.DepmMarkDr)
	if flag=1  q "{success:'false',errorinfo:'该数据已存在'}"
	
	ts
	s obj=##class(User.DHCDepMark).%New()
	d obj.DepmBorDrSetObjectId(eobj.DepmBorDr)	
	s obj.DepmDepDr = eobj.DepmDepDr
	d obj.DepmMarkDrSetObjectId(eobj.DepmMarkDr)	  //s obj.DepmMarkDr = eobj.DepmMarkDr  2019-01-29
	s obj.DepmState = eobj.DepmState
	s obj.DepmSign = eobj.DepmSign
	s obj.DepmCheckin = eobj.DepmCheckin
	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s DHCDepMarkid = obj.%Id()
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHCDepMark","User.DHCDepMark","分诊区号别对照",DHCDepMarkid,$LISTGET($g(^User.DHCExaBoroughD(eobj.DepmBorDr)),5)_"-"_eobj.DepmMarkDrName,"A",eobj)
	}
	else
	{
		s ImportResult = ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	
	if (ImportResult="")
	{
		tc
		s ImportResult="{success:'true',id:'"_DHCDepMarkid_"'}" 
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
/// Return："1"重复  0 不重复
/// w ##class(web.BDPExt.DHCDepMarkBLL).FormValidate("","","","")
ClassMethod FormValidate(id As %String, bordr As %String, depdr As %String, markdr As %String) As %String
{
	n (id,bordr,depdr,markdr)
	q:(bordr="")||(depdr="")||(markdr="") 0
	s flag=0,flagb=0,flagm=0,flagd=0
	s flagm=$d(^User.DHCDepMarkI("DepmMarkDrIndex"," "_$zcvt(markdr,"U")))
	s flagd=$d(^User.DHCDepMarkI("DepmDepDrIndex"," "_$ZCVT(depdr,"U")))
	s flagb=$d(^User.DHCDepMarkI("DepmBorDrIndex",bordr))
	if (flagm'=0)||(flagd'=0)||(flagb'=0)
	{
		if ((flagb>0)) 
		{
			s idb=0
			for 
			{
				s idb=$o(^User.DHCDepMarkI("DepmBorDrIndex",bordr,idb)) q:(idb="")||(flag=1)
				s DepmDepDr=$lg($g(^User.DHCDepMarkD(idb)),8)
				s DepmMarkDr=$lg($g(^User.DHCDepMarkD(idb)),3)
				continue:(DepmDepDr="")||(DepmMarkDr="")
				if ((id="")&(depdr=DepmDepDr)&(markdr=DepmMarkDr))||((depdr=DepmDepDr)&(markdr=DepmMarkDr)&(id'="")&(id'=idb)) s flag=1
			
			}
		}
	}
	q flag
}

}
