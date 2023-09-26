/// Creator：李欣
/// CreatDate: 20180412
/// Desc：医用知识库接口类
Class web.DHCBL.MKB.MKBInterface Extends %RegisteredObject
{

/// Creator:chenying
/// Description:判断菜单及其父菜单是否会显示在医用知识库
/// Input：菜单rowid
/// Output：1（属于），0（不属于）
/// CreatDate:2018-06-25
/// w ##class(web.DHCBL.MKB.MKBInterface).IsMKBMenu(1027)
ClassMethod IsMKBMenu(rowid)
{
	s flag=0
	s obj=##class(User.BDPMenu).%OpenId(rowid) 
	if $d(^User.BDPMenuD(rowid))&&$IsObject(obj)
	{
        s IsMKBMenu =obj.IsMKBMenu
 		if (IsMKBMenu="Y")
 		{
	 		s flag=1
 		} 
 		else
 		{
	 		q 0
 		}		
 		if (obj.ParentMenuDr'="")
 		{
	 		s ParentMenuDr=obj.ParentMenuDr.%Id()
	 		s flag=##class(web.DHCBL.MKB.MKBInterface).IsMKBMenu(ParentMenuDr)
 		}
	}
	q flag
}

/// Creator:chenying
/// Description:模糊查询菜单
/// Input：模糊检索的菜单描述
/// Output：返回检索菜单
/// CreatDate:2018-04-10
/// w ##class(web.DHCBL.MKB.MKBInterface).GetMKBMenu("诊断")
ClassMethod GetMKBMenu(desc As %String)
{
	s result=""
	s combolimit=10,count=0	
	if desc'=""
	{
		s MENURowId=0
		for
		{
			s MENURowId=$o(^User.BDPMenuD(MENURowId)) q:MENURowId=""
			s obj=##class(User.BDPMenu).%OpenId(MENURowId) 
			if $IsObject(obj)
			{
				s flag= ##class(web.DHCBL.MKB.MKBInterface).IsMKBMenu(MENURowId)
		        continue:flag=0
		        s Caption=obj.Caption
		        s SPCode=$LISTGET($g(^User.BDPMenuD(MENURowId)),19)
		        if (Caption[desc)||($zcvt(SPCode,"u")[$zcvt(desc,"u"))  //20180905支持首拼检索
		        {
			        s LinkUrl = obj.LinkUrl   //csp
			        if (LinkUrl'=""){
						s LinkUrl="dhc.bdp.ext.sys.csp?BDPMENU="_MENURowId
					}
					continue:LinkUrl=""
					s count=count+1
					q:count>combolimit
					if count>1
					{
						s result=result_"&%"_MENURowId_"^"_Caption_"^"_LinkUrl
					}
					else
					{
						s result=MENURowId_"^"_Caption_"^"_LinkUrl
					}	
		        }
			}
		}
	}
	else  //2018-09-05查询最近点击的十条菜单记录
	{
		s tablename="BDPMKBMENUCLICK"
		s tablename=" "_$ZCONVERT(tablename,"U")
		s BDPDAHUserID ="1"
		if $d(%session) s BDPDAHUserID =$Get(%session.Data("LOGON.USERID"))
		s BDPDAHDate=""
		for
		{
			s BDPDAHDate=$o(^User.BDPDataHistoryI("TableUserDateIdx",tablename,BDPDAHUserID,BDPDAHDate),-1) q:BDPDAHDate="" 
			s RowId=""
			for
			{
				s RowId=$o(^User.BDPDataHistoryI("TableUserDateIdx",tablename,BDPDAHUserID,BDPDAHDate,RowId),-1) q:RowId="" 	
				s MENURowId=$listget($g(^User.BDPDataHistoryD(RowId)),3)          /// 对应表数据ID 节点 3  BDPDAFDataReference 
				s Caption=$listget($g(^User.BDPMenuD(MENURowId)),3)
				s LinkUrl=$listget($g(^User.BDPMenuD(MENURowId)),5)
				if (LinkUrl'=""){
					s LinkUrl="dhc.bdp.ext.sys.csp?BDPMENU="_MENURowId
				}
				continue:LinkUrl=""
				s count=count+1
				q:count>combolimit
				if count>1
				{
					s result=result_"&%"_MENURowId_"^"_Caption_"^"_LinkUrl
				}
				else
				{
					s result=MENURowId_"^"_Caption_"^"_LinkUrl
				}
			}
					
		}
		
		
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 20180417
/// Description：获取医用知识库全文检索菜单
/// Debug：w ##class(web.DHCBL.MKB.MKBInterface).GetSearchContextMenu()
ClassMethod GetSearchContextMenu()
{
	s result=""
	
	S menuid=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$zcvt("dhc.bdp.mkb.mkbcontextsearch","U"),0))
	if menuid'=""
	{
		s obj=##class(User.BDPMenu).%OpenId(menuid) 
		if $IsObject(obj)
		{
			s Caption=obj.Caption
	        s LinkUrl = obj.LinkUrl  //csp
	        if (LinkUrl'=""){
				s LinkUrl="dhc.bdp.ext.sys.csp?BDPMENU="_menuid
			}
			s result=menuid_"^"_Caption_"^"_LinkUrl
		}	
	}
	else
	{
		s menuid=0
		for
		{
			s menuid=$o(^User.BDPMenuD(menuid)) q:(menuid="")||(result'="")
			s obj=##class(User.BDPMenu).%OpenId(menuid) 
			if $IsObject(obj)
			{
				s IsMKBMenu = obj.IsMKBMenu
				continue:IsMKBMenu'="Y"
				s ActiveFlag = obj.ActiveFlag
				continue:($p(ActiveFlag,"^",1)'="1")
				s Caption=obj.Caption
				if Caption["全文检索"
				{
					s LinkUrl = obj.LinkUrl  //csp
		        	if (LinkUrl'=""){
						s LinkUrl="dhc.bdp.ext.sys.csp?BDPMENU="_menuid
					}
					s result=menuid_"^"_Caption_"^"_LinkUrl
					q 
				}
			}		
		}
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 20180412
/// Description：获取常用菜单，频率最高的五个
/// Debug：w ##class(web.DHCBL.MKB.MKBInterface).GetFreqMenu()
ClassMethod GetFreqMenu()
{
	s result=""
	S freq=""
	s i=0
	S UpdateUser=""
	if $d(%session) S UpdateUser=$Get(%session.Data("LOGON.USERID"))
	for
	{
		s freq=$o(^User.BDPDataFrequencyI("TableFreqIdx"," BDPMKBMENUCLICK",freq),-1) q:(freq=0)||(freq="")||(i>5)
		s ID=0
		for
		{
			s ID=$o(^User.BDPDataFrequencyI("TableFreqIdx"," BDPMKBMENUCLICK",freq,ID)) q:(ID=0)||(ID="")||(i>5)
			s BDPDAFUserID = $LISTGET($g(^User.BDPDataFrequencyD(ID)),6)
			continue:UpdateUser'=BDPDAFUserID
			s menuid=$LISTGET($g(^User.BDPDataFrequencyD(ID)),3)	
			s obj=##class(User.BDPMenu).%OpenId(menuid) 
			if $IsObject(obj)
			{
				s IsMKBMenu = obj.IsMKBMenu
				continue:IsMKBMenu'="Y"
				s ActiveFlag = obj.ActiveFlag
				continue:($p(ActiveFlag,"^",1)'="1")
				s Caption=obj.Caption
				if $L(Caption)>10 s Caption=$e(Caption,1,10)_".."
		        s LinkUrl =obj.LinkUrl //csp
		        if (LinkUrl'=""){
					s LinkUrl="dhc.bdp.ext.sys.csp?BDPMENU="_menuid
				}
				continue:LinkUrl=""
				s i=i+1
				if i>5 q
				if (result'="")
				{
					s result=result_"&%"_menuid_"^"_Caption_"^"_LinkUrl
				}
				else
				{
					s result=menuid_"^"_Caption_"^"_LinkUrl
				}	
			}
				
		}
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 20180412
/// Description：获取常用菜单，频率最高的五个
/// Debug：w ##class(web.DHCBL.MKB.MKBInterface).GetHistoryMenu()
ClassMethod GetHistoryMenu()
{
	s result=""
	S DATE=""
	s i=0
	S UpdateUser=""
	if $d(%session) S UpdateUser=$Get(%session.Data("LOGON.USERID"))
	for
	{
		s DATE=$o(^User.BDPDataHistoryI("TableDateIdx"," BDPMKBMENUCLICK",DATE),-1) q:(DATE=0)||(DATE="")||(i>5)
		s ID=0
		for
		{
			s ID=$o(^User.BDPDataHistoryI("TableDateIdx"," BDPMKBMENUCLICK",DATE,ID)) q:(ID=0)||(ID="")||(i>5)
			s BDPDAHUserID = $LISTGET($g(^User.BDPDataHistoryD(ID)),6)
			continue:UpdateUser'=BDPDAHUserID
			s menuid=$LISTGET($g(^User.BDPDataHistoryD(ID)),3)
			s obj=##class(User.BDPMenu).%OpenId(menuid) 
			if $IsObject(obj)
			{
				s IsMKBMenu = obj.IsMKBMenu
				continue:IsMKBMenu'="Y"
		        s Caption=obj.Caption
		        if $L(Caption)>10 s Caption=$e(Caption,1,10)_".."
		        s LinkUrl =obj.LinkUrl  //csp
		        if (LinkUrl'=""){
					s LinkUrl="dhc.bdp.ext.sys.csp?BDPMENU="_menuid
				}	
				continue:LinkUrl=""
				s i=i+1
				if i>5 q
				if (result'="")
				{
					s result=result_"&%"_menuid_"^"_Caption_"^"_LinkUrl
				}
				else
				{
					s result=menuid_"^"_Caption_"^"_LinkUrl
				}
			}	
	        
				
		}
	}
	q result
}

/// Creator：李欣
/// CreatDate: 20180412
/// Description：返回各种标识的数据量
/// return: json格式结果  tag : 标识;num : 数量;icon : 图标
/// Debug：w ##class(web.DHCBL.MKB.MKBInterface).TagAndNum()
ClassMethod TagAndNum()
{
                                      
	s str=""
	//1 总数据量（知识量）
	s TotalNum = 0
	s TotalNum = TotalNum + $O(^User.MKBTermBaseD(""),-1) 
	+ $O(^User.MKBTermBasePropertyD(""),-1)
	+ $O(^User.MKBTermBaseExtendCatD(""),-1) 
	+ $O(^User.MKBTermD(""),-1)
    + $O(^User.MKBTermBasePropertyD(""),-1)
	+ $O(^User.MKBTermBaseExtendCatD(""),-1)
	+ $O(^User.MKBTermD(""),-1)
	+ $O(^User.MKBTermPropertyD(""),-1)
	+ $O(^User.MKBTermExtendProD(""),-1)
	+ $O(^User.MKBTermProDetailD(""),-1)
	+ $O(^User.MKBTremExtendProValD(""),-1)
	+ $O(^User.MKBDataUseLogD(""),-1)
	+ $O(^User.MKBDocManageD(""),-1)
	+ $O(^User.MKBKnoManageD(""),-1)
	+ $O(^User.MKBInterfaceManageD(""),-1)
	+ $O(^User.MKBBusExecuteD(""),-1)
	+ $O(^User.MKBICDRelationD(""),-1)
	
	s str= "<table style='width:90%;margin-left:130px;'><tr style='height:100px;'>"
	s str= str_"<td style='width:300px;'>"_"<div class='dddd'><img  src='../scripts/bdp/Framework/icons/mkb/large-knowledge.png' /> </div><div class='licdiv'><span class='flagdiv'>"_"知识量"_"</span><span class='countdiv'>"_TotalNum_"</span></div>"_"</td>"
	
	//2 术语库数量（医学知识库）
	s BaseNum = 0
	s BaseID = 0
	for
	{
		s BaseID = $O(^User.MKBTermBaseD(BaseID))
		q:BaseID=""
		s BaseNum = BaseNum + 1	
	}
	s str= str_"<td style='width:300px;'>"_"<div class='dddd'><img  src='../scripts/bdp/Framework/icons/mkb/large-terms.png' /> </div><div class='licdiv'><span class='flagdiv'>"_"医学知识库"_"</span><span class='countdiv'>"_BaseNum_"</span></div>"_"</td>"
	
	//术语数量（医学术语）
	s TermNum = $O(^User.MKBTermD(""),-1)
	s:TermNum="" TermNum=0
	s str= str_"<td style='width:300px;'>"_"<div class='dddd'><img  src='../scripts/bdp/Framework/icons/mkb/large-term.png' /> </div><div class='licdiv'><span class='flagdiv'>"_"医学术语条目"_"</span><span class='countdiv'>"_TermNum_"</span></div>"_"</td>"
	
	
	//文献数量
	s DocId = 0
	s DocNum = 0
	for
	{
		s DocId = $O(^User.MKBDocManageD(DocId))
		q:DocId=""
		
		s DocNum = DocNum + 1	
	}
	s str= str_"<td style='width:300px;'>"_"<div class='dddd'><img  src='../scripts/bdp/Framework/icons/mkb/large-literature.png' /> </div><div class='licdiv'><span class='flagdiv'>"_"文献"_"</span><span class='countdiv'>"_DocNum_"</span></div>"_"</td>"
	                                       			
    s str=str_"</tr><tr style='height:100px;'>"                                        
	
	//部位数量
	s BaseID = $O(^User.MKBTermBaseI("FlagIndex"," PART",0))
	s PartNum = 0
	if BaseID'=""
	{
		s TermId = 0
		for
		{
			s TermId = $O(^User.MKBTermI("BaseIndex",BaseID,TermId))
			q:TermId=""
		
			s PartNum = PartNum + 1	
		}
	}
	s str= str_"<td style='width:300px;'>"_"<div class='dddd'><img  src='../scripts/bdp/Framework/icons/mkb/large-position.png' /> </div><div class='licdiv'><span class='flagdiv'>"_"部位"_"</span><span class='countdiv'>"_PartNum_"</span></div>"_"</td>"
	
	
	//病因数量
	s BaseID = $O(^User.MKBTermBaseI("FlagIndex"," PATHOGENY",0))
	s ReasonNum = 0
	if BaseID'=""
	{
		s TermId = 0
		for
		{
			s TermId = $O(^User.MKBTermI("BaseIndex",BaseID,TermId))
			q:TermId=""
		
			s ReasonNum = ReasonNum + 1	
		}
	}
	s str= str_"<td style='width:300px;'>"_"<div class='dddd'><img  src='../scripts/bdp/Framework/icons/mkb/large-pathogeny.png' /> </div><div class='licdiv'><span class='flagdiv'>"_"病因"_"</span><span class='countdiv'>"_ReasonNum_"</span></div>"_"</td>"
	
	//症状数量
	s SympNum = 0
	s BaseID = 0
	for
	{
		s BaseID = $O(^User.MKBTermBaseI("DescIndex"," 症状",BaseID))
		q:BaseID=""
		s TermId = 0
		for
		{
			s TermId = $O(^User.MKBTermI("BaseIndex",BaseID,TermId))
			q:TermId=""
			
			s SympNum = SympNum + 1	
		}
	}
	s str= str_"<td style='width:300px;'>"_"<div class='dddd'><img  src='../scripts/bdp/Framework/icons/mkb/large-symptom.png' /> </div><div class='licdiv'><span class='flagdiv'>"_"症状"_"</span><span class='countdiv'>"_SympNum_"</span></div>"_"</td>"	
	
	//药品数量
	s DrugNum = 0
	/*s BaseID = 0
	for
	{
		s BaseID = $O(^User.MKBTermBaseI("FlagIndex"," DRUG",BaseID))
		q:BaseID=""
		s TermId = 0
		for
		{
			s TermId = $O(^User.MKBTermI("BaseIndex",BaseID,TermId))
			q:TermId=""
			
			s DrugNum = DrugNum + 1	
		}
	}*/
	s DrugId = 0
	for
	{
		s DrugId = $O(^User.DHCDSSDrugDictD(DrugId))
		q:DrugId=""
		
		s DrugNum = DrugNum + 1	
	}
	s str= str_"<td style='width:300px;'>"_"<div class='dddd'><img  src='../scripts/bdp/Framework/icons/mkb/large-drug.png' /> </div><div class='licdiv'><span class='flagdiv'>"_"药品"_"</span><span class='countdiv'>"_DrugNum_"</span></div>"_"</td>"
	s str= str_"</tr></table>"
	
	q str
}

/// Creator：李欣
/// CreatDate: 2018-05-02
/// Description：查询某个或其他术语库的公有属性接口(获取展示列数据来源)
/// Input:base : 所属术语库ID	desc:用户输入的检索条件
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBAssInterface","GetPublicCat","5","")
Query GetPublicCat(base As %String, desc As %String) As %Query(ROWSPEC = "ID,Desc")
{
}

ClassMethod GetPublicCatExecute(ByRef qHandle As %Binary, base As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (base'="")
	{
		s:desc'="" desc=$zconvert(desc,"U")
		s ID = ""
		for
		{
			s ID = $o(^User.MKBTermBasePropertyI("TermBaseIdx",base,ID))
			q:ID=""
			s Desc = $lg($g(^User.MKBTermBasePropertyD(ID)),3)
			s DescPY = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
			s DescPY = $TR(DescPY,"_","")
			if (Desc[desc)||(DescPY[desc)
			{
				d OutputRow1		
			}
		}	
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    set Data=$lb(ID,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPublicCattClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPublicCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPublicCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPublicCatExecute ]
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

/// Creator:李欣
/// CreateDate:20180329
/// Desc:自定义查询区所有术语库信息
/// Input:
/// Optput:术语库列表的json格式
/// Other:w ##class(web.DHCBL.MKB.MKBAssInterface).GetTermBaseSet("诊断")
ClassMethod GetTermBaseSet(desc)
{
	s ID = ""
	s result=""
	s total = 0
	s desc = $ZCONVERT(desc,"U")
	for
	{
		s ID = $o(^User.MKBTermBaseD(ID))
		q:ID=""
		s Desc = $LG($G(^User.MKBTermBaseD(ID)),3)
		s DescPY = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
		if (Desc[desc)||(DescPY[desc)
		{
			s temp = "{""ID"":"""_ID_""",""Desc"":"""_Desc_"""}"	
			s:result'="" result=result_","_temp
			s:result="" result=temp	
		}
	}	
	s result="{""rows"":["_result_"],""total"":"_total_"}"
	q result
}

}
