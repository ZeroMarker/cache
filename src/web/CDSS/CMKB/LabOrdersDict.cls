/// 名称:检验医嘱字典表 
/// 描述:基础维护
/// 编写者:基础平台组 - Xuwenhu
/// 编写日期:2021-07-20
Class web.CDSS.CMKB.LabOrdersDict Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：ZWW		
/// CreatDate: 2022-09-15
/// Description：查询数据 
/// Table:CT.WDT.CDSS.LabOrdersDict 
/// Input:rowid,code(代码),desc(描述),alias(别名),state(状态),starttime(开始时间),endtime(结束时间),updateuser(操作人),sortmethod(排序方式)
/// Output:LabOrdersID,LabOrdersCode,LabOrdersDesc,Alias,UseFlag,UpdateUser,UpdateDate,Remarks
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.LabOrdersDict","GetList","","","","","1","","","","Short")
Query GetList(rowid As %String, code As %String, desc As %String, alias As %String, state As %String, starttime As %String, endtime As %String, updateuser As %String, sortmethod As %String) As %Query(ROWSPEC = "LabOrdersID,LabOrdersCode,LabOrdersDesc,Alias,UseFlag,UpdateUser,UpdateDate,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, alias As %String, state As %String, starttime As %String, endtime As %String, updateuser As %String, sortmethod As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    if (rowid'="") //根据rowid返回该条记录
    {
        s ID=rowid
        s LabOrdersCode=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),2) 				//检验医嘱代码
        s LabOrdersDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),3) 				//检验医嘱描述
        s Alias=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),4)						//别名
        s UseFlag=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),5) 					//状态（0编辑中,1已弃用,2已审核）
        s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"")
        s UpdateUser=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),6) 					//编辑人员
        s UpdateDate=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),7) 					//编辑时间
        s Remarks=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),8) 					//备注

        d OutputRow
    }
    else
    {
	    //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U")
		s:updateuser'="" updateuser=$ZCONVERT(updateuser,"U")
		s:alias'="" alias=$ZCONVERT(alias,"U")													
		//默认时间倒序输出
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
		if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.LabOrdersDictD(ID))
				q:ID=""
				s LabOrdDesc= $lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),3)		//名称
				s length=$l(LabOrdDesc)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
		}
		else
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.LabOrdersDictD(ID))
				q:ID=""
				s UpdateDate= $lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),7)				//编辑时间
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",UpdateDate,ID)=ID
			}
		}
		s le=""
		for
		{
			if (sortmethod="Short"){
				s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le)) 
			} else{
				s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le),-1) 
			}
			q:le=""
			s LabOrdersID=0
			for
			{
		        s LabOrdersID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,LabOrdersID)) q:LabOrdersID=""
				s LabOrdersCode=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),2) 		//检验医嘱代码
				continue:((code'="")&&(LabOrdersCode'[code))
				s LabOrdersDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),3) 		//检验医嘱描述
		        continue:((desc'="")&&($ZCONVERT(LabOrdersDesc,"U")'[desc))
		        s Alias=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),4)				//别名
		        continue:((alias'="")&&($ZCONVERT(Alias,"U")'[alias))
		        s UseFlag=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),5) 				//状态（0编辑中,1已弃用,2已审核）
		        if (state=""){
					continue:(UseFlag=1)
				}
				else{
					continue:((state'="")&&(UseFlag'=state))
				}
				s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"")
		        s UpdateUser=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),6) 		//编辑人员
		        continue:((updateuser'="")&&($ZCONVERT(UpdateUser,"U")'[updateuser))
		        s UpdateDate=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),7) 		//编辑时间
		        continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
	        	continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
		        s Remarks=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),8) 			//备注
		        d OutputRow
	        }
		}
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(LabOrdersID,LabOrdersCode,LabOrdersDesc,Alias,UseFlag,UpdateUser,UpdateDate,Remarks)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
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

/// Creator：Xuwenhu
/// CreatDate: 2021-07-20
/// Description：查询 检验医嘱
/// Table:CT.WDT.CDSS.LabOrdersDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.LabOrdersDict","GetDataForCmb1","","血常规","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "LabOrdsID,LabOrdsCode,LabOrdsDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s LabOrdsID=rowid
		s LabOrdCode=$LISTGET($G(^CT.WDT.CDSS.LabOrdersDictD(LabOrdsID)),2)
		s LabOrdDesc=$LISTGET($G(^CT.WDT.CDSS.LabOrdersDictD(LabOrdsID)),3)
		d OutputRowCmb
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s:q'="" q=$ZCONVERT(q,"U") //转换成大写
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.LabOrdersDictD(ID))
			q:ID=""
			s LabOrdDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),3)		//名称
			s length=$l(LabOrdDesc)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s LabOrdsID=0
			for
			{
				s LabOrdsID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,LabOrdsID))
				q:LabOrdsID=""
				s LabOrdsCode=$LISTGET($G(^CT.WDT.CDSS.LabOrdersDictD(LabOrdsID)),2)
				s LabOrdsDesc=$LISTGET($G(^CT.WDT.CDSS.LabOrdersDictD(LabOrdsID)),3)
				s UseFlag=$LISTGET($G(^CT.WDT.CDSS.LabOrdersDictD(LabOrdsID)),5)
				//s UseFlag=$case(UseFlag,"0":"编辑中","1":"已删除","2":"已审核","":"编辑中")
		  		if (($ZCONVERT(LabOrdsDesc,"U")[desc))&(($ZCONVERT(LabOrdsDesc,"U")[q)&(UseFlag="2"))
		  		{
		  			d OutputRowCmb
		  		}
		  		continue:((desc'="")||(q'=""))
				s num=num+1
				q:num=1000
			}
			q:num=1000
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(LabOrdsID,LabOrdsCode,LabOrdsDesc)
	set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：Xuwenhu
/// CreatDate:2021-07-20
/// Description：数据重复验证方法
/// Table：CT.WDT.CDSS.LabOrdersDict
/// Input：id,desc(描述)
/// Return："1"(数据重复),"0"(数据不重复)
/// other:w ##class(web.CDSS.CMKB.LabOrdersDict).FormValidate("","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.LabOrdersDictI("CodeIndex",code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.LabOrdersDictI("DescIndex",desc))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.LabOrdersDictI("CodeIndex",code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex",desc,0))
		
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
#;	s:desc'="" desc=$ZCONVERT(desc,"U")
#;	s flag="",flagc=""
#;	s:desc'="" flagc=$d(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_desc))
#;	if (id="") //如果为空，增加时的重复判断
#;	{
#;		if (flagc>0) s flag=1  //返回重复标志
#;		else  s flag=0 //返回不重复标志
#;	}
#;	else //如果不为空，修改时的重复判断
#;	{
#;		s idc=""
#;		s:desc'="" idc=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_desc,0))
#;		if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
#;		else  s flag=0 //返回不重复标志
#;	}
#;	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.LabOrdersDict).ValidateAlias("","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod ValidateAlias(id As %String, name As %String, aliasStr As %String) As %String
{
	s flag=0
	s len = $l(aliasStr,",")
	for i=1:1:len
	{
		s Alias=$p(aliasStr,",",i)
		if (Alias="") continue  //别名为空，则跳过
		if (Alias=name)
		{
			s flag=1  //如果别名=名称，则数据重复
			q
		}
		
		s Alias=" "_$ZCONVERT(Alias,"U") //别名转换成大写
	    s flagA="",flagN=""
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.LabOrdersDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.LabOrdersDictI("DescIndex",Alias))
	    if (id="")	//如果为空，增加时的重复判断
	    {
	        if ((flagA>0)||(flagN>0)) 
	        {
		        s flag=1  //返回重复标志
		        q
	        }
	    }
	    else 	//如果不为空，修改时的重复判断
	    {
	        s idA="",idN=""
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.LabOrdersDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex",Alias,0))  						//字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator:Xuwenhu
/// CreatDate:2021-07-20
/// Description：保存检验医嘱字典表的内容
/// Table：CT.WDT.CDSS.LabOrdersDict
/// Input：web.CDSSEntity.CMKB.LabOrdersDict 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.LabOrdersDict).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.LabOrdersDict) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
    	
        s flag=..FormValidate(eobj.ID,eobj.LabOrdersCode,eobj.LabOrdersDesc)  //调用重复验证
        if (flag=1)
        {
            q "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        s flagAlias=..ValidateAlias(eobj.ID,eobj.LabOrdersDesc,eobj.Alias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
        else
        {
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.LabOrdersDict).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.LabOrdersDict).%OpenId(eobj.ID) 			
                
                s bobj = ##class(web.CDSSEntity.CMKB.LabOrdersDict).%New()
                s bobj.ID=eobj.ID
				s bobj.LabOrdersCode=obj.LabOrdersCode				//代码
				s bobj.LabOrdersDesc =obj.LabOrdersDesc				//描述
				s bobj.Alias=obj.Alias								//别名
				s bobj.UseFlag=obj.UseFlag							//状态（0已审核，1编辑中,2已弃用）
				s bobj.UpdateUser=obj.UpdateUser					//编辑人员
				s bobj.UpdateDate=obj.UpdateDate					//编辑时间
				s bobj.Remarks=obj.Remarks							//备注
                
            }
            TS
            s obj.LabOrdersCode=eobj.LabOrdersCode					//代码
			s obj.LabOrdersDesc=eobj.LabOrdersDesc					//描述
			s obj.Alias=eobj.Alias									//别名
			s obj.UseFlag=eobj.UseFlag								//状态（0已审核，1编辑中,2已弃用）
			//s obj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))	//编辑人员
			s obj.UpdateUser=eobj.UpdateUser
			s eobj.UpdateDate=$ZDATETIME($H,3)						//编辑时间
			s obj.UpdateDate=eobj.UpdateDate
			s obj.Remarks=eobj.Remarks								//备注
			
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                TC
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //保存日志
				d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabOrdersDict","CT.WDT.CDSS.LabOrdersDict","检验医嘱字典",id,eobj.LabOrdersCode,"A",eobj)
				d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabOrdersDict","CT.WDT.CDSS.LabOrdersDict","检验医嘱字典",eobj.ID,eobj.LabOrdersCode,"U",eobj,bobj)
				
            	//[新]检验百科增加一条同名数据
				d:eobj.ID="" ##class(web.CDSS.CMKB.Term).SaveTerm("检验",eobj.LabOrdersDesc,"")
				d:eobj.ID'="" ##class(web.CDSS.CMKB.Term).SaveTerm("检验",eobj.LabOrdersDesc,bobj.LabOrdersDesc)
            	//同步修改识别词项目数据    2021-11-25
				d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("检验医嘱名称",eobj.LabOrdersDesc,bobj.LabOrdersDesc)
            	
            	//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            	if ((eobj.ID="")&&(eobj.Alias'=""))||((eobj.ID'="")&&(eobj.Alias'=bobj.Alias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.LabOrdersDict",id,eobj.Alias)
            	}
            	//同步修改对照数据
				d:eobj.ID'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("检验医嘱",bobj.LabOrdersCode_"[A]"_bobj.LabOrdersDesc,eobj.LabOrdersCode_"[A]"_eobj.LabOrdersDesc) 
				
				
            }
            else
            {
                TRO
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检验医嘱字典","web.CDSS.CMKB.LabOrdersDict","SaveData",eobj)
       	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }
        }               
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检验医嘱字典","web.CDSS.CMKB.LabOrdersDict","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:赵文伟
/// CreatDate:2020-11-25
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.CMKB.LabOrdersDict).GetRefFlag("97")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0
	s LabOrdersDesc=$LISTGET($G(^CT.WDT.CDSS.LabOrdersDictD(id)),3)	//检验医嘱名称
    //诊疗规则引用接口 2023-02-28
    s Exist =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.RuleTrigger","GetQuoteFlag")
	s ExistChild =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.ChildRuleTrigger","GetQuoteFlag")
	if (Exist="1"&&ExistChild="1"){
		s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("检验医嘱",LabOrdersDesc) //被诊疗规则引用判断
		s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("检验医嘱",LabOrdersDesc) //被诊疗子规则引用判断
		if ((RuleTriggerFlag=1)||(ChildRuleTriggerFlag=1))
		{
			s myInfo=myInfo_"<诊疗规则关联触发条件表>"
		}
	}
    //识别词项目引用接口    2021-11-25
	s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("检验医嘱名称",LabOrdersDesc)
	if IWordsStr'="" s myInfo=myInfo_IWordsStr
    
    //字典对照引用接口
	s Mappinginfo=##class(web.CDSS.IMP.DictMappingInfo).GetRefFlag("检验医嘱",LabOrdersDesc)
	if Mappinginfo'="" s myInfo=myInfo_Mappinginfo
    
    //规则引用接口
	s RuleDescStr=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("检验医嘱",id)
	if RuleDescStr'="" s myInfo=myInfo_"<规则管理："_RuleDescStr_">"
	
    i myInfo="" s return="0^未被引用可删除!"
 	//else  s return="1^在"_myInfo_"表里被引用,不能删除!"
 	else  s return="1^在"_myInfo_"表里被引用"
 	q return
}

/// Creator:Xuwenhu
/// CreatDate:2021-07-20
/// Description：根据ID删除检验医嘱字典表的内容
/// Table：CT.WDT.CDSS.LabOrdersDict
/// Input：id-检验医嘱字典表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.CMKB.LabOrdersDict).DeleteData("646")
ClassMethod DeleteData(id As %String) As %String
{
	
    s result="" 
    
    s obj=##class(CT.WDT.CDSS.LabOrdersDict).%OpenId(id)      
    s bobj = ##class(web.CDSSEntity.CMKB.LabOrdersDict).%New()
    s bobj.ID=id
	s bobj.LabOrdersCode=obj.LabOrdersCode				//代码
	s bobj.LabOrdersDesc=obj.LabOrdersDesc				//描述
	s bobj.Alias=obj.Alias								//别名
	s bobj.UseFlag=obj.UseFlag							//状态（0已审核，1编辑中,2已删除）
	s bobj.UpdateUser=obj.UpdateUser					//编辑人员
	s bobj.UpdateDate=obj.UpdateDate					//编辑时间
	s bobj.Remarks=obj.Remarks							//备注
	
    Tstart
    //同步删除对照数据 2022-01-21
    s re = ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("检验医嘱",obj.LabOrdersCode_"[A]"_obj.LabOrdersDesc)
	if (re="true[A]true"){
	    s sc=##class(CT.WDT.CDSS.LabOrdersDict).%DeleteId(id)
	    if $$$ISOK(sc)
	    {
	        Tcommit
	        s result = "{success:'true',info:'删除成功！'}"  
	        d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabOrdersDict","CT.WDT.CDSS.LabOrdersDict","检验医嘱字典",id,bobj.ID,"D",bobj)
	        
			//[新]检验百科删除同名数据    2022-03-15
			//d ##class(web.CDSS.CMKB.Term).DeleteTerm("检验",bobj.LabOrdersDesc)
			//同步删除别名通用表中数据 
	        d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.LabOrdersDict",id)
	        
	        d bobj.%Close()
	    }
	    else 
	    {
	        Trollback
	        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	        s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("检验医嘱字典","web.CDSS.CMKB.LabOrdersDict","DeleteData",bobj)
	        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	     }
     } else{
	    s result = "{success:'false',info:'字典对照同步删除失败！'}"
	    }
     q result
}

/// Creator:zww
/// CreatDate:2021-11-30
/// Description：状态操作
/// Table：CT.WDT.CDSS.LabOrdersDict
/// Input：id-检验医嘱字典表的rowid
/// Return：成功返回"true"；失败返回"false"}
/// Other:w ##class(web.CDSS.CMKB.LabOrdersDict).ChangeState("7")
ClassMethod ChangeState(RowId As %String, Operation As %String) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.LabOrdersDict).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.LabOrdersDict).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.LabOrdersDict).%New()
	s bobj.UseFlag=obj.UseFlag
	s bobj.UpdateDate=obj.UpdateDate
	s bobj.UpdateUser=obj.UpdateUser
	
	s obj.UseFlag=eobj.UseFlag
 	s obj.UpdateDate=eobj.UpdateDate
 	s obj.UpdateUser=eobj.UpdateUser
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		//同步删除对照数据【当状态变为已弃用或驳回时】  2021-12-21
		if (obj.UseFlag="1")||(obj.UseFlag="0"){
			
			d ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("检验医嘱",obj.LabOrdersCode_"[A]"_obj.LabOrdersDesc)
		}
		//状态改为已审核时识别词新增已拆分数据  Add By ZWW 2023-05-05 
		if (obj.UseFlag= "2"){
			s lineI=obj.LabOrdersDesc_",识别条件,主要条件-识别词,1,检验医嘱名称,"_obj.LabOrdersDesc_",0"
			d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabOrdersDict","CT.WDT.CDSS.LabOrdersDict","检验医嘱字典",RowId,obj.LabOrdersDesc_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:Xuwenhu
/// CreatDate:2021-07-20
/// Description：打开时的数据
/// Table：CT.WDT.CDSS.LabOrdersDict
/// Input：id-检验医嘱字典表的rowid
/// Return：json
/// Other:w ##class(web.CDSS.CMKB.LabOrdersDict).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.LabOrdersDict).%New()
	s eobj.ID = id
    s eobj.LabOrdersCode=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(id)),2) 	//从单位
    s eobj.LabOrdersDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(id)),3) 		//到单位
    s eobj.Alias=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(id)),4)		//转换系数 
    s eobj.UseFlag=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(id)),5) 				//状态（0已审核,1编辑中,2已弃用）
    s eobj.UpdateUser=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(id)),6) 		//编辑人员
    s eobj.UpdateDate=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(id)),7) 		//编辑时间
    s eobj.Remarks=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(id)),8) 			//备注

	s str = eobj.JsonS()
	d eobj.%Close()
	
	q str
}

/*
/// Creator: Xuwenhu 
/// CreatDate: 2021-07-20
/// Description：导出当前的查询内容
/// Table:CT.WDT.CDSS.LabOrdersDict
/// Input：code(代码),desc(描述),alias(别名),state(状态),starttime(开始时间),endtime(结束时间),updateuser(操作人)
/// Return：文件名称
/// Other: w ##class(web.CDSS.CMKB.LabOrdersDict).ExportData("","","","","","","")
ClassMethod ExportData(code As %String, desc As %String, alias As %String, state As %String, starttime As %String, endtime As %String, updateuser As %String) As %String
{
		
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"检验医嘱字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport/"_fileName
	o file:"NWS"
	u file
	
	w "检验医嘱代码	检验医嘱描述	别名	操作人员	操作时间	备注	状态"
	
	s:updateuser'="" updateuser=$ZCONVERT(updateuser,"U") //转换成大写
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.LabOrdersDictD(ID))
		q:ID=""
		s LabOrdersCode=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),2) 		//检验医嘱代码
		continue:((code'="")&&(LabOrdersCode'[code))
		
        s LabOrdersDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),3) 		//检验医嘱描述
        continue:((desc'="")&&($ZCONVERT(LabOrdersDesc,"U")'[desc))
        s Alias=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),4)				//别名
        continue:((alias'="")&&($ZCONVERT(Alias,"U")'[alias))
        s UseFlag=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),5) 				//状态（2已审核,0编辑中,1已弃用）
        if (state=""){
			continue:(UseFlag=1)
		}
		else{
			continue:((state'="")&&(UseFlag'=state))
		}
		s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"")
        s UpdateUser=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),6) 		//编辑人员
        continue:((updateuser'="")&&($ZCONVERT(UpdateUser,"U")'[updateuser))
        s UpdateDate=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),7) 		//编辑时间
        continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
    	continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
        s Remarks=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),8) 			//备注
	        
		w !,LabOrdersCode_"	"_LabOrdersDesc_"	"_Alias_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks_"	"_UseFlag			
	}
	c file
	q fileName
}
*/
/// Creator: Xuwenhu 
/// CreatDate: 2021-07-20
/// Description：导出当前的查询内容
/// Table:CT.WDT.CDSS.LabOrdersDict
/// Input：
/// Return：文件名称
/// Other: w ##class(web.CDSS.CMKB.LabOrdersDict).ExportData()
ClassMethod ExportData(code As %String, desc As %String, alias As %String, state As %String, starttime As %String, endtime As %String, updateuser As %String) As %String
{
		
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"检验医嘱字典数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file = Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file = Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){	//文件保存路径不存在，新建文件夹
		d ##class(%File).CreateDirectoryChain(DirName)
	}
	o file:"NWS"
	u file
	
	w "检验医嘱代码	检验医嘱描述	别名	操作人员	操作时间	备注	状态"
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s:updateuser'="" updateuser=$ZCONVERT(updateuser,"U")
	s:alias'="" alias=$ZCONVERT(alias,"U")	
	s LabOrdersID=""
	for
	{
		s LabOrdersID=$o(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID),-1) q:LabOrdersID="" 
		s LabOrdersCode=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),2) 		//检验医嘱代码
		continue:((code'="")&&(LabOrdersCode'[code))
		s LabOrdersDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),3) 		//检验医嘱描述
		continue:((desc'="")&&($ZCONVERT(LabOrdersDesc,"U")'[desc))
		s Alias=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),4)				//别名
		continue:((alias'="")&&($ZCONVERT(Alias,"U")'[alias))
		s UseFlag=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),5) 				//状态（0编辑中,1已弃用,2已审核）
		continue:((state'="")&&(UseFlag'=state))
		s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"编辑中")
		s UpdateUser=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),6) 		//编辑人员
		continue:((updateuser'="")&&($ZCONVERT(UpdateUser,"U")'[updateuser))
		s UpdateDate=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),7) 		//编辑时间
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
	    continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
		s Remarks=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),8) 			//备注
		w !,LabOrdersCode_"	"_LabOrdersDesc_"	"_Alias_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks_"	"_UseFlag
	}
	
	c file
	q fileName
}

/// Creator: Xuwenhu
/// CreatDate: 2021-07-20
/// Description：导入数据
/// Table:CT.WDT.CDSS.LabOrdersDict
/// Input： path(路径)
/// Return：
/// Other: w ##class(web.CDSS.CMKB.LabOrdersDict).ImportData("")
ClassMethod ImportData(path)
{
	s readcount=0   	//读取总数
	s savecount=0		//导入成功总数
	s nosavecount=0 	//导入失败总数
	s incount=0			//已存在总数
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		s LabOrdsCode=$p(str,",",1)			//代码
		s LabOrdsDesc=$p(str,",",2)				//描述
		s Alias=$p(str,",",3)	//转换系数
		
		//去除两端空白
		s LabOrdsCode=$zstrip(LabOrdsCode,"<>W")
		s LabOrdsDesc=$zstrip(LabOrdsDesc,"<>W")
		s Alias=$zstrip(Alias,"<>W")
		s readcount=readcount+1
		
		s RowID=$o(^CT.WDT.CDSS.LabOrdersDictI("CodeIndex",LabOrdsCode,0))
		if (RowID="")
		{
			s bobj = ##class(web.CDSSEntity.CMKB.LabOrdersDict).%New()
			s bobj.ID = ""
			s bobj.LabOrdersCode=LabOrdsCode			//代码
			s bobj.LabOrdersDesc=LabOrdsDesc			//描述
			s bobj.Alias=Alias							//别名
			s bobj.UseFlag="0"							//状态
			s bobj.UpdateUser="dhcc"					//编辑用户
			s bobj.UpdateDate=$ZDATETIME($H,3)			//编辑时间
			s bobj.Remarks=""					//备注
			
			s resule=..SaveData(bobj)
			if resule["true"
			{
				s savecount=savecount+1	
			}
			else
			{
				s nosavecount=nosavecount+1	
			}
				
		}
		else
		{
			s incount=incount+1
			continue	
		}
		
	}
	q "{success:'true',readcount:'"_readcount_"',savecount:'"_savecount_"',nosavecount:'"_nosavecount_"',incount:'"_incount_"'}"
}

/// Creator:Xuwenhu
/// CreatDate:2021-07-22
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.LabOrdersDict
/// Input: id-检验医嘱表id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.LabOrdersDict","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s Alias = $lg($g(^CT.WDT.CDSS.LabOrdersDictD(id)),4)
		s Len=$Length(Alias,",")
		for i=1:1:Len{
			s Desc=$p(Alias,",",i)
			continue:(Desc="")
			d OutputRowKeyWords
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowKeyWords
	set Data=$lb(Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAliasListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAliasListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAliasListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAliasListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Xuwenhu
/// CreatDate:2021-7-23
/// Description:代码自动生成  
/// Input：
/// Return： code
/// Other:w ##class(web.CDSS.CMKB.LabOrdersDict).GetCode()
ClassMethod GetCode() As %String
{
  	s Code=""
	
	s Code=$o(^CT.WDT.CDSS.LabOrdersDictD(""),-1)
	if (Code="")
	{
		s:Code="" Code="001"
	}
	else
	{
		//s Code=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(Code+1,5)	//补0
		s Code=Code+1
	}
	q Code
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-19
/// Description: 批量通过
/// Table: CT.WDT.CDSS.LabOrdersDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.LabOrdersDict).ChangeStatusPass("")
ClassMethod ChangeStatusPass(RowIdStr As %String)
{
	s result=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)
			s flag=..ChangeState(id,"通过")

			if (flag'["true"){
				s errorflag = errorflag+1
			}
		}
	}
	if (errorflag'=0)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result="true"	
	}
		q result
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-19
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.LabOrdersDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.LabOrdersDict).ChangeStatusBack("")
ClassMethod ChangeStatusBack(RowIdStr As %String)
{
	s result=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)
			s flag=..ChangeState(id,"驳回")

			if (flag'["true"){
				s errorflag = errorflag+1
			}
		}
	}
	if (errorflag'=0)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result="true"	
		
	}
		q result
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-19
/// Description：别名数据转存到别名通用表中
/// Table: CT.WDT.CDSS.LabOrdersDict
/// Other: w ##class(web.CDSS.CMKB.LabOrdersDict).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.LabOrdersDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.LabOrdersDictD(RowId)),4)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.LabOrdersDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.LabOrdersDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.LabOrdersDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.LabOrdersDictD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.LabOrdersDictD(RowId)),5)       
		if (UseFlag'="")
		{
			if (UseFlag=0){
				s editcount=editcount+1
			} elseif (UseFlag=2){
				s auditcount=auditcount+1
			}
		}
		s totalcount=editcount+auditcount	 	
	}
	q totalcount_"^"_editcount_"^"_auditcount_"^"_unauditcount
}

/// Creator：赵文伟
/// CreatDate: 2022-04-08
/// Description：修正数据保存方法
/// Table：CT.WDT.CDSS.LabOrdersDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.LabOrdersDict).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.LabOrdersDict) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flag=..FormValidate(eobj.ID,eobj.LabOrdersCode,eobj.LabOrdersDesc) //校验重复
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ID,eobj.LabOrdersDesc,eobj.Alias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.ID="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.LabOrdersDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.LabOrdersDict).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.LabOrdersDict).%New()
			s bobj.LabOrdersCode = obj.LabOrdersCode  
			s bobj.LabOrdersDesc = obj.LabOrdersDesc 
			s bobj.Alias = obj.Alias 
			s bobj.UpdateDate=obj.UpdateDate		//创建时间
			s bobj.UpdateUser=obj.UpdateUser	//创建人员
			
		}
		s obj.LabOrdersCode = eobj.LabOrdersCode  
		s obj.LabOrdersDesc = eobj.LabOrdersDesc
		s obj.Alias = eobj.Alias 
		s obj.UpdateDate=$ZDATETIME($H,3)	
		s obj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))	
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
            {
                TC
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //保存日志
				d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabOrdersDict","CT.WDT.CDSS.LabOrdersDict","检验医嘱字典",id,eobj.LabOrdersCode,"A",eobj)
				d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.LabOrdersDict","CT.WDT.CDSS.LabOrdersDict","检验医嘱字典",eobj.ID,eobj.LabOrdersCode,"U",eobj,bobj)
				
            	//[新]检验百科增加一条同名数据
				d:eobj.ID="" ##class(web.CDSS.CMKB.Term).SaveTerm("检验",eobj.LabOrdersDesc,"")
				d:eobj.ID'="" ##class(web.CDSS.CMKB.Term).SaveTerm("检验",eobj.LabOrdersDesc,bobj.LabOrdersDesc)
            	//同步修改识别词项目数据    2021-11-25
				d:eobj.ID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("检验医嘱名称",eobj.LabOrdersDesc,bobj.LabOrdersDesc)
            	//同步修改对照数据
				d:eobj.ID'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("检验医嘱",bobj.LabOrdersCode_"[A]"_bobj.LabOrdersDesc,eobj.LabOrdersCode_"[A]"_eobj.LabOrdersDesc) 
				//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            	if ((eobj.ID="")&&(eobj.Alias'=""))||((eobj.ID'="")&&(eobj.Alias'=bobj.Alias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.LabOrdersDict",id,eobj.Alias)
            	}
            }
            else
            {
                TRO
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检验医嘱字典","web.CDSS.CMKB.LabOrdersDict","SaveAmendData",eobj)
       	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }
                       
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("检验医嘱字典","web.CDSS.CMKB.LabOrdersDict","SaveAmendData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:赵文伟
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.LabOrdersDict","GetLogList","20")
Query GetLogList(RowId As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Operation")
{
}

ClassMethod GetLogListExecute(ByRef qHandle As %Binary, RowId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str=""
 	if (RowId'="")
 	{
		s LogID=""
	    for
	    {
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.LabOrdersDict",RowId,LogID),-1) q:LogID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),8)
	    	s UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),9)
          	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime)
          	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),13)   //新增对象描述
          	if (ObjectDesc["&&")
          	{
	          	s Operation=$p(ObjectDesc,"&&",2)
          	}
         	else
         	{
          		s Operation="编辑"
         	}
         	d OutputRowLog
	    }
	    
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLog
	set Data=$lb(LogID,UpdateDate,UpdateTime,UpdateUserName,Operation)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLogListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：赵文伟
/// CreatDate: 2023-01-10
/// Description：转存检验医嘱字典数据到检验百科【百科中不存在的数据】
/// Table：CT.WDT.CDSS.LabOrdersDict	检验医嘱字典
/// Input：
/// Return:
/// Other: d ##class(web.CDSS.CMKB.LabOrdersDict).TransferSaveData()
ClassMethod TransferSaveData() As %String
{
	
	s LabOrdersID=""
	s count=0
	for
	{ 	
		s LabOrdersID=$o(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID),-1) q:LabOrdersID="" 
		s LabOrdersDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),3) 		//检验医嘱描述
		s UseFlag=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),5) 				//状态（0编辑中,1已弃用,2已审核）
		continue:(UseFlag=1)	//过滤已弃用数据
		s BaseDR=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_"检验",0))
		if (BaseDR'="")
		{
			//如果百科中不存在，调用接口保存
			if ('$d(^CT.WDT.CDSS.TermI("DescIndex",BaseDR," "_($ZCONVERT(LabOrdersDesc,"U")))))	
			{
				//w LabName
				d ##class(web.CDSS.CMKB.Term).SaveTerm("检验",LabOrdersDesc,"")
				s count=count+1
			}	
		}
	}
	//w "共检测到"_count_"条数据。"
	w "处理完成,共处理"_count_"条数据。"
}

/// Creator：赵文伟 
/// CreatDate: 2023-03-06
/// Description：字典导入新增的别名数据【遍历判断如果表中已存在当前别名不新增，不存在追加在后面】,导入文本格式为txt，TXT要求格式为ANSI编码
/// Table: 检验医嘱字典
/// Input： path
/// Return：
/// Other: w ##class(web.CDSS.CMKB.LabOrdersDict).ImportAliasData("D:\ZWW\检验医嘱新增别名.txt")
ClassMethod ImportAliasData(path) As %String
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	
	if '##class(%File).Exists(path) 
	{
   		q "文件不存在"
    }
	s file=##class(%File).%New(path)
	d file.Open("R")
	k myFileAry
	
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s readcount=readcount+1
		s myFileAry(i)=data
		
		s LabOrdersDesc=$p(data,$c(9),1)	//名称
		s Alias=$p(data,$c(9),2)		//别名
		s flag=0
		s RowId=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_$ZCONVERT(LabOrdersDesc,"U"),0))
		TS
		if (RowId'=""){
		
			s obj=##class(CT.WDT.CDSS.LabOrdersDict).%OpenId(RowId)
			s OldAlias=obj.Alias //表中原有别名
			s lenN=$l(Alias,",")
			for n=1:1:lenN		//遍历导入的别名
			{
				s AliasN=$p(Alias,",",n)
				s len=$l(OldAlias,",")
				for j=1:1:len		//遍历表中已有的别名
				{
					s AliasT=$p(OldAlias,",",j)
					if (AliasN=AliasT){		//判断是否有已存在的数据
						s flag=1
					}
				}
			}
			if (flag=0){
				if (obj.Alias=""){
					s obj.Alias=Alias
				}else{
					s obj.Alias=obj.Alias_","_Alias
				}
				s sc= obj.%Save()
				
				if $$$ISOK(sc)
				{
					s id = obj.%Id()
					s result = "{success:'true'}"
					//同步保存别名到别名通用表
		            if (RowId'="")
		            {
		            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.LabOrdersDict",id,obj.Alias)
		            }
		            d obj.%Close()
		            TC
				}
				else
				{
					s result = "{success:'false'}"
					TRO
				}
				
				if (result["true")
				{
					s savecount=savecount+1
				}
				else
				{
					s nosavecount=nosavecount+1
					w !,LabOrdersDesc_"^"_Alias_" 保存失败"
				}
			}else{
				w !,LabOrdersDesc_"^"_Alias_" 存在重复别名"
				//TRO
			}
		}else{
			w !,LabOrdersDesc_"不存在"
			//TRO
		}
	}
	close file
    k file
	w !,"readcount："_(readcount-1),!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	
	q "{success:'true'}"
}

/// Creator:赵文伟
/// CreatDate:2023-03-30
/// Description：导出检验医嘱字典表重复的别名数据
/// Other:w ##class(web.CDSS.CMKB.LabOrdersDict).ExportRepeatAlisaData()
ClassMethod ExportRepeatAlisaData()
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"检验医嘱重复别名数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file = Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file = Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){	//文件保存路径不存在，新建文件夹
		d ##class(%File).CreateDirectoryChain(DirName)
	}
	o file:"NWS"
	u file
	w "存在重复的别名	对应的检验医嘱名称	对应重复数据名称"
	
	
	s LabOrdersID=""
	for
	{
		s LabOrdersID=$o(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID),-1) q:LabOrdersID="" 	
		s LabOrdersCode=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),2) 				//检验医嘱代码
        s LabOrdersDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),3) 				//检验医嘱描述
        s Alias=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(LabOrdersID)),4)						//别名
        
		s flag=0
		s len = $l(Alias,",")
		for i=1:1:len
		{
			s OneAlias=$p(Alias,",",i)
			if (OneAlias'=""){
				s AliasId=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.LabOrdersDict",OneAlias,LabOrdersID,0))
			
				
				s flagN=""
				for {
					
					s flagN=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_$ZCONVERT(OneAlias,"U"),flagN))
					q:flagN=""
					//b ;3
					if ((flagN'="")&&(flagN'=LabOrdersID)){	//当前别名与名称重复
						//s Name=LabOrdersDesc
						s Name=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(flagN)),3)
						w !,OneAlias_"	"_LabOrdersDesc_"	"_Name
					}
				}
				s flagA=""
				for {
					s flagA=$o(^CT.WDT.CDSS.AliasI("TableAliasIndex","CT.WDT.CDSS.LabOrdersDict",OneAlias,flagA))	
					q:flagA=""
					//b ;2
					if ((flagA'="")&&(flagA'=AliasId)){	//当前别名与其他别名重复
						s DataReference=$lg($g(^CT.WDT.CDSS.AliasD(flagA)),4)
						s Name=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(DataReference)),3)
						//b ;4
						w !,OneAlias_"	"_LabOrdersDesc_"	"_Name
					}
				}
			}
		}
	}
	c file
	q fileName
}

}
