/// 名称:用户使用CDSS数据统计
/// 描述:用户使用CDSS数据统计
/// 编写者:基础数据平台组 - Xuwenhu
/// 编写日期:2022-01-20
Class web.CDSS.Statistics.UserClickStatic Extends %RegisteredObject
{

/// Creator:Xuwenhu
/// CreatDate:2022-01-22
/// Description:保存数据
/// Table:WDT.CDSS.UserClickStatic
/// Input:eobj
/// Return:success-成功，false-失败
/// Others:w ##class(web.CDSS.Statistics.UserClickStatic).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Statistics.UserClickStatic) As %String
{
	s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        if (eobj.RowId="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.UserClickStatic).%New()             
        }
        else                     //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.UserClickStatic).%OpenId(eobj.RowId)  
            s bobj = ##class(web.CDSSEntity.Statistics.UserClickStatic).%New()
			s bobj.UserID=obj.UserID									// 用户ID
			s bobj.UserName=obj.UserName								// 用户名
			s bobj.CTLocID=obj.CTLocID									// 科室ID
			s bobj.CTLocDesc=obj.CTLocDesc								// 科室名称
			s bobj.VisitType=obj.VisitType								// 就诊类型（急诊、门诊、住院）
			s bobj.ClickTime=obj.ClickTime								// 用户点击时间
			s bobj.OperType=obj.OperType								// 操作目的（开立、写回、查看、下载）
			s bobj.ClickModule=obj.ClickModule							// 点击项目模块（诊断决策、治疗决策、预警信息、患者画像）
			s bobj.ClickProType=obj.ClickProType						// 点击项目类型（确诊诊断、检索框、推荐治疗方案、推荐出院指导等）
			s bobj.ClickProName=obj.ClickProName						// 点击项目名称、检索类型（脑梗死/检索类型）
			s bobj.ClickText=obj.ClickText								// 点击内容（检索内容，治疗方案细项等）
			s bobj.ClickType=obj.ClickType								// 点击类型,方便百科等统计（诊断、检验、检查、手术、护理、出院指导）
	        s bobj.Remark=obj.Remark									// 备注
        }
        Ts
       	s obj.UserID=eobj.UserID									// 用户ID
		s obj.UserName=eobj.UserName								// 用户名
		s obj.CTLocID=eobj.CTLocID									// 科室ID
		s obj.CTLocDesc=eobj.CTLocDesc								// 科室名称
		s obj.VisitType=eobj.VisitType								// 就诊类型（急诊、门诊、住院）
		s obj.ClickTime=eobj.ClickTime								// 用户点击时间
		s obj.OperType=eobj.OperType								// 操作目的（开立、写回、查看、下载）
		s obj.ClickModule=eobj.ClickModule							// 点击项目模块（诊断决策、治疗决策、预警信息、患者画像）
		s obj.ClickProType=eobj.ClickProType						// 点击项目类型（确诊诊断、检索框、推荐治疗方案、推荐出院指导等）
		s obj.ClickProName=eobj.ClickProName						// 点击项目名称、检索类型（脑梗死/检索类型）
		s obj.ClickText=eobj.ClickText								// 点击内容（检索内容，治疗方案细项等）
		s obj.ClickType=eobj.ClickType								// 点击类型,方便百科等统计（诊断、检验、检查、手术、护理、出院指导）
        s obj.Remark=eobj.Remark									// 备注
        s sc=obj.%Save()		
        d obj.%Close()
        If $$$ISOK(sc)
        {
            Tc
            s id = obj.%Id()
            s result = "{""success"":""true"",""id"":"""_id_"""}"  //返回RowId
            //保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("UserClickStatic","WDT.CDSS.UserClickStatic","用户使用CDSS数据统计表",id,eobj.RowId,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("UserClickStatic","WDT.CDSS.UserClickStatic","用户使用CDSS数据统计表",eobj.RowId,eobj.RowId,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("用户使用CDSS数据统计表","web.CDSS.Statistics.UserClickStatic","SaveData",eobj)
   	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
                 
    }
    else
    {
        s result = "{""success"":""false"",""errorinfo"":""对象不存在！""}"
    }
    q result
ERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("用户使用CDSS数据统计表","web.CDSS.Statistics.UserClickStatic","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-22
/// Description:保存数据
/// Table:WDT.CDSS.UserClickStatic
/// Input:eobj
/// Return:success-成功，false-失败
/// Others:w ##class(web.CDSS.Statistics.UserClickStatic).SaveUserClickStaticData(json)
ClassMethod SaveUserClickStaticData(json) As %String
{
	;s ^TMP("FWK0721")=json
	s json=$REPLACE(json,":""}",":""""}")
	s json=$REPLACE(json,":"",",":"""",")
	s StaJson=[].%FromJSON(json)
	for i=0:1:StaJson.%Size()-1
	{
		s StaChildren=StaJson.%Get(i)
		s UserID=StaChildren.%Get("UserID")
		s UserName=StaChildren.%Get("UserName")
		s CTLocID=StaChildren.%Get("CTLocID")
		s CTLocDesc=StaChildren.%Get("CTLocDesc")
		s VisitType=StaChildren.%Get("VisitType")
		s ClickTime=StaChildren.%Get("ClickTime")
		s OperType=StaChildren.%Get("OperType")
		s ClickModule=StaChildren.%Get("ClickModule")
		s ClickProType=StaChildren.%Get("ClickProType")
		s ClickProName=StaChildren.%Get("ClickProName")
		s ClickText=StaChildren.%Get("ClickText")
		s ClickType=StaChildren.%Get("ClickType")
		s Remark=StaChildren.%Get("Remark")
		
		s obj=##class(web.CDSSEntity.Statistics.UserClickStatic).%New()
		s obj.RowId=""
		s obj.UserID=UserID									// 用户ID
		s obj.UserName=UserName								// 用户名
		s obj.CTLocID=CTLocID								// 科室ID
		s obj.CTLocDesc=CTLocDesc							// 科室名称
		s obj.VisitType=VisitType							// 就诊类型（急诊、门诊、住院）
		s obj.ClickTime=ClickTime							// 用户点击时间
		s obj.OperType=OperType								// 操作目的（开立、写回、查看、下载）
		s obj.ClickModule=ClickModule						// 点击项目模块（诊断决策、治疗决策、预警信息、患者画像）
		s obj.ClickProType=ClickProType						// 点击项目类型（确诊诊断、检索框、推荐治疗方案、推荐出院指导等）
		s obj.ClickProName=ClickProName						// 点击项目名称、检索类型（脑梗死/检索类型）
		s obj.ClickText=ClickText							// 点击内容（检索内容，治疗方案细项等）
		s obj.ClickType=ClickType							// 点击类型,方便百科等统计（诊断、检验、检查、手术、护理、出院指导）
        s obj.Remark=Remark									// 备注
		
		s result=..SaveData(obj)
		
	}
	
	q result
}

}
