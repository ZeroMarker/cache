/// 名称: DHCMed.INFService.InterfaceControl
/// 描述: 院感及监控中心
/// 编写者：ChenJB
/// 编写日期: 2010-10-18
/// ---------------------------------------
/// replace "CacheTemp($j" to "CacheTemp($zn,$j"
/// by wuqk 2011-04-22 
/// 
Class DHCMed.INFService.InterfaceControl Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ChenJB
/// CreatDate：   2010-10-18
/// Description:  查询所有监控主题
/// Table：       DHCMed.CC.ItemCat
/// Input：       
/// Return：      tree需要的ResultSet
/// do ##class(%ResultSet).RunQuery("DHCMed.INFService.InterfaceControl","QueryAllForTree")
Query QueryAllForTree(IC As %String = "") As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String,checked:%String")
{
}

ClassMethod QueryAllForTreeExecute(ByRef qHandle As %Binary, IC As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set rowid=""
	Set:IC="" rowid=$o(^DHCMed.CC.ItemCatD(rowid))
	Set:IC'="" rowid=IC
	while (rowid'="") {
		set obj=##class(DHCMed.CC.ItemCat).%OpenId(+rowid)
		set data=$lb("'"_rowid_"'","'"_obj.ICDesc_"'","true","null")
		set ^CacheTemp(repid,ind)=data
		do obj.%Close()
		set ind=ind+1
		Set rowid=$o(^DHCMed.CC.ItemCatD(rowid))
		Set:IC'="" rowid=""  //查询指定的项目
	}
	kill obj
	Quit $$$OK
}

ClassMethod QueryAllForTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllForTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAllForTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllForTreeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     ChenJB
/// CreatDate：   2010-10-18
/// Description:  根据监控主题构造监控字典的树形结构json串
/// Table：       DHCMed_CC.Subject DHCMed_CC.SubjectItm DHCMed_CC.ItemDic DHCMed_CC.ItemSubCat DHCMed_CC.ItemCat  
/// Input：       subject：  主题Id
/// Return：      返回树形结构json串
/// Others:       构建监控字典树
/// w ##class(DHCMed.INFService.InterfaceControl).BuildSubjectJson(1)
ClassMethod BuildSubjectJson(SB As %String = "") As %String
{
	new (SB)
	set json=""
	
	Set rowid=""
	Set:SB="" rowid=$o(^DHCMed.CC.SubjectD(rowid))
	Set:SB'="" rowid=SB
	k ^CacheTemp($zn,$j,"SBCtl")
	while rowid'=""{
		//s ^CacheTemp($zn,$j,"SBCtl",rowid)
		s arryDt=##class(DHCMed.CC.SubjectItm).GetItmListBySubjectID(rowid) //监控项目列表
		s intCount=arryDt.Count()
		f intCount=1:1:intCount  d
	    .s objItm=arryDt.GetAt(intCount) //DHCMed.CC.SubjectItm
	    .q:'$IsObject(objItm)
	    .s objItDic=##class(DHCMed.CC.ItemDic).GetObjById(objItm.ItemDic)
	    .s ^CacheTemp($zn,$j,"SBCtl",rowid,"type",objItDic.IDSubCatDr,objItm.ItemDic)=objItm.%Id()
	    Set rowid=$o(^DHCMed.CC.SubjectD(rowid))
		Set:SB'="" rowid=""  //查询指定的项目
	}
	set ShowIndex=""
	set ShowIndex=$o(^CacheTemp($zn,$j,"SBCtl",ShowIndex))
	while ShowIndex'=""{	
		set:json'="" json=json_","
		set objPro=##class(DHCMed.CC.Subject).%OpenId(+ShowIndex)
		set proJson="{"_"""id"":"""_ShowIndex_"S"",""text"":"""_objPro.Title_""","
		//,""cls"":""P""
		set proJson=proJson_"""iconCls"":""icon-pro"","
		set proJson=proJson_"""expanded"":true,"
		set secFlag=0,childJson="[]"
		set:$d(^CacheTemp($zn,$j,"SBCtl",+ShowIndex,"type")) secFlag=1  
		//..BuildMSecurityJson(groupId,proId,0,.childJson)				
		if +secFlag>0 {
		   set proJson=proJson_"""checked"":true,"
		}
		else{
			set proJson=proJson_"""checked"":false,"
		}
		//主题列表
		set typeDr=$o(^CacheTemp($zn,$j,"SBCtl",+ShowIndex,"type",""))
		set ItemCatJosn=""	
		while typeDr'=""{
		   set objISC=##class(DHCMed.CC.ItemSubCat).GetObjById(typeDr)
		   set:ItemCatJosn'="" ItemCatJosn=ItemCatJosn_","
		   set ItemCatJosn=ItemCatJosn_"{"
		   set ItemCatJosn=ItemCatJosn_"""id"":"""_typeDr_"I"",""text"":"""_objISC.ISCDesc_""","
		   //""cls"":""M"",
		   set ItemCatJosn=ItemCatJosn_"""expanded"":true,"
		   set flag=0
		   set:$o(^CacheTemp($zn,$j,"SBCtl",+ShowIndex,"type",typeDr,""))'="" flag=1
		   if +flag>0 {
		     set ItemCatJosn=ItemCatJosn_"""checked"":true,"
		   }
		   else{
			  set ItemCatJosn=ItemCatJosn_"""checked"":false,"
		   }
		   //默认的菜单图标
		   set ItemCatJosn=ItemCatJosn_"""iconCls"":""icon-menu"","	
		   set DicCsJosn=""
		   set DicDr="" 
		   set DicDr=$o(^CacheTemp($zn,$j,"SBCtl",+ShowIndex,"type",typeDr,DicDr))
		   set ItemDr=$g(^CacheTemp($zn,$j,"SBCtl",+ShowIndex,"type",typeDr,DicDr))
		   while DicDr'=""{
			   set objICD=##class(DHCMed.CC.ItemDic).GetObjById(DicDr)
			   set ItemDr=$g(^CacheTemp($zn,$j,"SBCtl",+ShowIndex,"type",typeDr,DicDr))
		       set:DicCsJosn'="" DicCsJosn=DicCsJosn_","
		       set DicCsJosn=DicCsJosn_"{"
		       set DicCsJosn=DicCsJosn_"""id"":"""_ItemDr_"D"",""text"":"""_objICD.IDDesc_""","
		       //""cls"":""M"",
		       set DicCsJosn=DicCsJosn_"""expanded"":true,"
		       set DicCsJosn=DicCsJosn_"""checked"":true,"
		       set DicCsJosn=DicCsJosn_"""iconCls"":""icon-menu"","
		       set finalCld="[]"      //结束层 
		       set DicCsJosn=DicCsJosn_"""children"":"_finalCld_"}"
		       set DicDr=$o(^CacheTemp($zn,$j,"SBCtl",+ShowIndex,"type",typeDr,DicDr))
		   }
		   set DicCsJosn="["_DicCsJosn_"]"
		   set ItemCatJosn=ItemCatJosn_"""children"":"_DicCsJosn_"}"
		   //set json=json_proJson
		   set typeDr=$o(^CacheTemp($zn,$j,"SBCtl",+ShowIndex,"type",typeDr))
		}
		set childJson="["_ItemCatJosn_"]"	
		set proJson=proJson_"""children"":"_childJson_"}"
		set json=json_proJson
		set ShowIndex=$o(^CacheTemp($zn,$j,"SBCtl",ShowIndex))
	}
	quit "["_json_"]"
}

}
