/// Description：规则来源表接口类
/// Table：CT.WDT.CDSS.RuleBasis
Class web.CDSS.CMKB.RuleBasis Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2022-05-09
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.RuleBasis
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.CDSS.CMKB.RuleBasis).SaveData("30","<p><img src=../scripts/bdp/CDSS/CMKB/dhcFlow/sourceImage/qq.jpg alt=qq.jpg data-href=../scripts/bdp/CDSS/CMKB/dhcFlow/sourceImage/qq.jpg style=/></p>")
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.RuleBasis) As %String
{
	//s $zt="ERROR"
	s result=""
	//保存日志
	#;	s eobj = ##class(web.CDSSEntity.CMKB.RuleBasis).%New() 
	#;	s eobj.BaseRowId = BaseRowId
	#;	s eobj.Content = ##class(web.DHCBL.BDP.FunLib).Util(Content)
	if $IsObject(eobj)
	{ 
		if (eobj.Content="3@%CSP.CharacterStream")
		{
			q "{success:'false',errorinfo:'录入字符（包含标点）太多,已经达到上限，没法保存，请调整文字！'}"
		}

		//q flag
		if (eobj.BaseRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.RuleBasis).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			if ($d(^CT.WDT.CDSS.RuleBasisD(eobj.BaseRowId))){
				s obj=##class(CT.WDT.CDSS.RuleBasis).%OpenId(eobj.BaseRowId)
				s bobj = ##class(web.CDSSEntity.CMKB.RuleBasis).%New() 
				s bobj.BaseRowId = eobj.BaseRowId  
				s bobj.Content = obj.Content 
				s bobj.UpdateDate = obj.UpdateDate 
				s bobj.UpdateUser = obj.UpdateUser 
				
			}else{
				s obj=##class(CT.WDT.CDSS.RuleBasis).%New() 
			}

		}
		s obj.Content = eobj.Content  
		s UpdateUserName=$g(%session.Data("LOGON.USERNAME"))
	 	s obj.UpdateUser=UpdateUserName
		s obj.UpdateDate=$zdt($h,3)

		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
#;			d:eobj.BaseRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("DHCDSSRuleBasis","CT.WDT.CDSS.RuleBasis","规则来源表",id,Content,"A",eobj)
#;			d:eobj.BaseRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("DHCDSSRuleBasis","CT.WDT.CDSS.RuleBasis","规则来源表",eobj.BaseRowId,Content,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
#;			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("规则来源表","web.CDSS.CMKB.RuleBasis","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("规则来源表","web.CDSS.CMKB.RuleBasis","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：删除
/// CreatDate: 2022-05-09
/// Description：获取图片内容
/// Table：CT.WDT.CDSS.RuleRationality
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.RuleBasis).getRuleSource("7468")
ClassMethod getRuleSource(id As %String) As %String
{
	s sourceContent= ""
	s obj=##class(CT.WDT.CDSS.RuleBasis).%OpenId(id)
	s sourceContent = obj.Content
	d obj.%Close()	
	k obj	
	
	q sourceContent
}

/// Creator:石萧伟
/// CreatDate:2022-05-10
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.RuleBasis
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.RuleBasis).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	s obj=##class(CT.WDT.CDSS.RuleBasis).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleBasis).%New() 
	s bobj.Content = obj.Content  
	s bobj.UpdateUser = obj.UpdateUser 
	s bobj.UpdateDate = obj.UpdateDate 
	s bobj.Remarks = obj.Remarks

	s sc=##class(CT.WDT.CDSS.RuleBasis).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleBasis","CT.WDT.CDSS.RuleBasis","规则截图",id,"删除了规则截图"_id,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("规则截图","web.CDSS.CMKB.RuleBasi","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator:dingyanan
/// CreatDate:2023-04-10
/// Description:复制规则截图
/// Table: CT.WDT.CDSS.RuleBasis
/// Input: id--复制节点的id
/// Return:成功新节点的id，失败返回空
/// Other: w ##class(web.CDSS.CMKB.RuleBasis).CopyNode(343362)
ClassMethod CopyNode(copyid As %String) As %String
{
	s result=""
	if (copyid="")||('$d(^CT.WDT.CDSS.RuleBasisD(copyid)))
	{
		q result
	}
	//复制节点
	s eobjBasis=##class(web.CDSSEntity.CMKB.RuleBasis).%New()
	s eobjBasis.Content = $lg($g(^CT.WDT.CDSS.RuleBasisD(copyid)),2)
	s eobjBasis.UpdateUser  = $lg($g(^CT.WDT.CDSS.RuleBasisD(copyid)),3)
	s eobjBasis.UpdateDate  = $lg($g(^CT.WDT.CDSS.RuleBasisD(copyid)),4)
	s eobjBasis.Remarks  = $lg($g(^CT.WDT.CDSS.RuleBasisD(copyid)),5)
	s Basisresult=##class(web.CDSS.CMKB.RuleBasis).SaveData(eobjBasis)
	d eobjBasis.%Close()
	if (Basisresult["true")
	{
		s result=$p(Basisresult,"'",4)
	}
	q result
}

}
