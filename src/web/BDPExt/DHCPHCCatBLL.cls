/// 名称: 药理学分类维护
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹 update2020-02-11
/// 编写日期: 2016-11-28
Class web.BDPExt.DHCPHCCatBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function:实现对数据校验  所有级别的代码都不能相同，同级别下描述不能相同
/// Creator:基础数据平台组
/// CreateDate:chenying @20200611
/// debug:  w ##class(web.BDPExt.DHCPHCCatBLL).FormValidate("","a","a","2","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, level As %String, parcatdr As %String) As %String
{
	n (id,code,desc,level,parcatdr)
	s flag=0
	if code'=""
	{
		s idc=$o(^DHCPHCC(0,"PHCCCode",code,0))
		if (idc'=id)
		{
			s flag=1
		}
	}
	
	if desc'=""
	{
		s idc=0
		for
		{
			s idc=$o(^DHCPHCC(0,"PHCCDesc",desc,idc)) q:idc=""
			if (idc'=id)
			{
				s PHCCLevel=$p($g(^DHCPHCC(idc)),"^",4)
				s PHCCParCatDr=$p($g(^DHCPHCC(idc)),"^",3)
				if ((+PHCCParCatDr=+parcatdr)&&(level=PHCCLevel)) s flag=1
			}
		}
	}
	q flag
}

/// Function:   实现数据的修改和保存操作
/// Creator:    基础数据平台组 sunfengchao 
/// CreateDate: 2016-11-21
/// Function:   通过rowid来修改或保存信息
/// Output:     success:'true',info:'添加成功！' 修改成功时输出修改成功！
///             success:'false',info:'添加失败' 修改失败时输出修改失败！
/// Tables:     DHC_PHCCat
ClassMethod SaveEntity(eobj As web.BDPExt.DHCPHCCatEntity) As %String
{
	new (eobj,%session)
	s result="",flag=0
	; 设置默认值
	s PHCCLevel=0,PHCCDesc=""
	if (eobj.PHCCCat1="")&&(eobj.PHCCCat2="")&&(eobj.PHCCCat3="")&&(eobj.PHCCCat4="")&&(eobj.PHCCCat5="")&&(eobj.PHCCCat6="")&&(eobj.PHCCCat7="")
	{
		q "保存失败，药理学分类不能为空"
	}
	if (eobj.PHCCCat1'="")  
	{	
		s PHCCLevel=1
		s PHCCDesc=eobj.PHCCCat1
	}
	if (eobj.PHCCCat2'="") 
	{
		if PHCCDesc'="" q "保存失败，同一行不能有两条药理学分类数据"
		s PHCCLevel=2
		s PHCCDesc=eobj.PHCCCat2
	}
	if (eobj.PHCCCat3'="") 
	{
		if PHCCDesc'="" q "保存失败，同一行不能有两条药理学分类数据"
		s PHCCLevel=3
		s PHCCDesc=eobj.PHCCCat3
	}
	if (eobj.PHCCCat4'="") 
	{
		if PHCCDesc'="" q "保存失败，同一行不能有两条药理学分类数据"
		s PHCCLevel=4
		s PHCCDesc=eobj.PHCCCat4
	}
	if (eobj.PHCCCat5'="")  
	{
		if PHCCDesc'="" q "保存失败，同一行不能有两条药理学分类数据"
		s PHCCLevel=5
		s PHCCDesc=eobj.PHCCCat5
	}
	if (eobj.PHCCCat6'="") 
	{
		if PHCCDesc'="" q "保存失败，同一行不能有两条药理学分类数据"
		s PHCCLevel=6
		s PHCCDesc=eobj.PHCCCat6
	}
	if (eobj.PHCCCat7'="")  
	{
		if PHCCDesc'="" q "保存失败，同一行不能有两条药理学分类数据"
		s PHCCLevel=7
		s PHCCDesc=eobj.PHCCCat7
	}
	if (eobj.PHCCDesc="") s eobj.PHCCDesc=PHCCDesc
	if (eobj.PHCCCode="") s eobj.PHCCCode=eobj.PHCCDesc
	
	if (eobj.PHCCParCatDrCode'="")
	{
		s eobj.PHCCParCatDr=$o(^DHCPHCC(0,"PHCCCode",eobj.PHCCParCatDrCode,0)) 
		if eobj.PHCCParCatDr=""
		{
			q "上一级 "_eobj.PHCCParCatDrCode_" 导入失败，请查看具体数据" 
		}
	}
	else
	{
		s eobj.PHCCParCatDr=0
	}
	s eobj.PHCCLevel=PHCCLevel
	if ((eobj.PHCCParCatDr=0)||(eobj.PHCCParCatDr=""))&&(PHCCLevel'=1) 
	{
		q "保存失败，药理学分类数据层级关系有误"
		
	}
	else
	{
		s flag=..FormValidate(eobj.PHCCRowId,eobj.PHCCCode,eobj.PHCCDesc,eobj.PHCCLevel,eobj.PHCCParCatDr)
		if (flag=1)
		{
			s result = "保存失败，代码或者描述已经存在"
		}
		else
		{ 
			if (eobj.PHCCRowId="")       
			{ 
				s obj=##class(User.DHCPHCCat).%New()
			}
			else  
			{
				s obj=##class(User.DHCPHCCat).%OpenId(eobj.PHCCRowId)
				s bobj=##class(web.BDPExt.DHCPHCCatEntity).%New()
				s bobj.PHCCRowId=eobj.PHCCRowId               
				s bobj.PHCCCode=obj.PHCCCode      
				s bobj.PHCCDesc=obj.PHCCDesc
				s:obj.PHCCParCatDr'="" bobj.PHCCParCatDr=obj.PHCCParCatDr.%Id() 
				s bobj.PHCCLevel=obj.PHCCLevel 
				//s:obj.PHCCHospDr'="" bobj.PHCCHospDr=obj.PHCCHospDr.%Id()                            
			}
			
			s obj.PHCCCode=eobj.PHCCCode
			s obj.PHCCDesc=eobj.PHCCDesc
			d obj.PHCCParCatDrSetObjectId(eobj.PHCCParCatDr)
			//d obj.PHCCHospDrSetObjectId(eobj.PHCCHospDr)
			s obj.PHCCLevel=eobj.PHCCLevel  
			Tstart      
			s sc=obj.%Save()
			if (sc=1)
			{
				Tcommit
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"    
				d:eobj.PHCCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHCCat","User.DHCPHCCat","药理学分类",eobj.PHCCRowId,eobj.PHCCDesc,"U",eobj,bobj)
				d:eobj.PHCCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHCCat","User.DHCPHCCat","药理学分类",id,eobj.PHCCDesc,"A",eobj)
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药理学分类","web.BDPExt.DHCPHCCatBLL","SaveEntity",eobj)
				if +logid>0 s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
			}
		}	
	}
	q result
}

}
