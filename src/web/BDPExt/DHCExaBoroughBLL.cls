/// Creator:陈莹
/// CreatDate:2017-03-16 update2020-02-11
/// Description:保存分诊区和分诊区等候目录、呼叫目录等信息
Class web.BDPExt.DHCExaBoroughBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2017-03-16
/// Description:保存分诊区和分诊区等候目录、呼叫目录等信息
/// Table:User.DHCExaBorough,User.DHCExaBoroughFilePath (两个表通过字段ExabDr关联)
/// Other:w ##class(web.BDPExt.DHCExaBoroughBLL).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.BDPExt.DHCExaBoroughEntity) As %String
{
	n (eobj,%session)
	s ImportResult=""
	
	if (eobj.ExabTem="Y")||(eobj.ExabTem="y")||(eobj.ExabTem="是") s eobj.ExabTem="Y"
	else  s eobj.ExabTem="N"
	
	ts
	
	s obj=##class(User.DHCExaBorough).%New()		
	s obj.ExabCode = eobj.ExabCode 
	s obj.ExabName = eobj.ExabName 
	s obj.ExabTem = eobj.ExabTem
	s obj.ExabMemo = eobj.ExabMemo
	d obj.ExabHospitalDrSetObjectId(eobj.ExabHospitalDr) 
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s DHCExaBoroughid = obj.%Id()
		
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHCExaBorough","User.DHCExaBorough","分诊区",DHCExaBoroughid,eobj.ExabName,"A",eobj)
	
		s FilePathobj=##class(User.DHCExaBoroughFilePath).%New()
		d FilePathobj.ExabDrSetObjectId(DHCExaBoroughid)	        		        	
		s FilePathobj.ExabSubCallFilePath = eobj.ExabSubCallFilePath 
		s FilePathobj.ExabSubWaitFilePath = eobj.ExabSubWaitFilePath 
		s sc1=FilePathobj.%Save()
		d FilePathobj.%Close()
		If $$$ISERR(sc1)
		{
			s ImportResult = "分诊区目录:"_$zconvert(sc1,"O","JS")_"'}"    //返回错误信息
		}
	}
	else
	{
		s ImportResult = "分诊区:"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
	}
	
	if (ImportResult="")
	{
		tc
		s ImportResult="{success:'true',id:'"_DHCExaBoroughid_"'}" 
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
/// Return："1"(分诊区代码重复),"0"(数据不重复),2 (分诊区名称重复)
/// w ##class(web.BDPExt.DHCExaBoroughBLL).FormValidate("","FZNEQ","")
ClassMethod FormValidate(code As %String, desc As %String, hospid As %String) As %String
{
	n (code,desc,hospid)
	q:(code="")&&(desc="") 0
	s EXABID=0
	s flag=0,flagc=0,flagd=0
	for
	{
		s EXABID=$o(^User.DHCExaBoroughD(EXABID)) q:EXABID=""
		s ExabHospitalDr=$LISTGET($g(^User.DHCExaBoroughD(EXABID)),13)
		if (ExabHospitalDr=hospid)   //2020-04-07 判断分诊区的医院
		{
			s ExabCode=$lg($g(^User.DHCExaBoroughD(EXABID)),2)
			s ExabName=$lg($g(^User.DHCExaBoroughD(EXABID)),5)
			if (ExabCode=code) s flag=1
			if (ExabName=desc) s flag=1
		}
		
	}
	q flag
}

}
