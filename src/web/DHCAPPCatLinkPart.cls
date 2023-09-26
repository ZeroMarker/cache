Import sqluser

Class web.DHCAPPCatLinkPart Extends %RegisteredObject [ ClassType = "", ProcedureBlock, SqlCategory = NUMERIC ]
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-04-15
/// Description:： 保存医嘱子类与部位(子部位)关联
/// Table：        DHC_AppCatLinkPart DHC_AppCatLinkSubPart
/// Input：	       ACCheck:ID：User.DHCAppArcCat的rowid
///                ACPart:ID：User.DHCAppPart的rowid
/// save：           DHC_AppCatLinkPart   
///                DHC_AppCatLinkSubPart                
/// Return：       保存成功 0，其他 失败
/// other：          w ##class(web.DHCAPPCatLinkPart).Save(16,18)
ClassMethod Save(ACCheck, ACPart)
{
 s return=0
 s obj=##class(User.DHCAppCatLinkPart).%New()
 d obj.%Reload()
 s last=$p(^DHCAPPART(ACPart),"^",3)
	 
	 if +last=+0{
		;if '$d(^DHCAPARCCA(0,"Part",ACCheck,ACPart)){
	 	;s obj.ACLPCatParRef=##class(User.DHCAppArcCat).%OpenId(ACCheck)
	 	;s ch=$o(^DHCAPARCCA(ACCheck,"P",""),-1)+1
	  	;s obj.ACLPChildSub=ch
	  	;s obj.ACLPPartDr=##class(User.DHCAppPart).%OpenId(ACPart) ;这种指针字段就是这样插入咯，知道就行了
	    ;s sc=obj.%Save()
	    ;}
	 }else{
	 	if '$d(^DHCAPARCCA(0,"Part",ACCheck,last)){
	 	s obj.ACLPCatParRef=##class(User.DHCAppArcCat).%OpenId(ACCheck)
	 	s ch=$o(^DHCAPARCCA(ACCheck,"P",""),-1)+1
	  	s obj.ACLPChildSub=ch
	  	s obj.ACLPPartDr=##class(User.DHCAppPart).%OpenId(last) 
	  	s sc=obj.%Save()
	  	
	  	s subobj=##class(User.DHCAppCatLinkSubPart).%New()
	    d subobj.%Reload()
	    s id=ACCheck_"||"_ch
	  	s subobj.ACLPCatParRef=##class(User.DHCAppCatLinkPart).%OpenId(id)
		s subch=$o(^DHCAPARCCA(ACCheck,"P",ch,"S",""),-1)+1
	  	s subobj.ACLPChildSub=subch
	  	s subobj.ACLPSubPartDr=##class(User.DHCAppPart).%OpenId(ACPart)  
	    s sub=subobj.%Save()
	 	}else{
		 	s subobj=##class(User.DHCAppCatLinkSubPart).%New()
	        d subobj.%Reload()
	        s childsub=$o(^DHCAPARCCA(0,"Part",ACCheck,last,""))
	    	s id=ACCheck_"||"_childsub
	  		s subobj.ACLPCatParRef=##class(User.DHCAppCatLinkPart).%OpenId(id)
			s subch=$o(^DHCAPARCCA(ACCheck,"P",childsub,"S",""),-1)+1
	  		s subobj.ACLPChildSub=subch
	  		s subobj.ACLPSubPartDr=##class(User.DHCAppPart).%OpenId(ACPart)
	  		
	  		s isInTable=0
	  		s subsub=""
	  		f  s subsub=$o(^DHCAPARCCA(ACCheck,"P",childsub,"S",subsub)) q:subsub=""  d
	  		.s subpart=$p(^DHCAPARCCA(ACCheck,"P",childsub,"S",subsub),"^",1)
	  		.q:subpart'=ACPart 
	  		.s isInTable=1
	  		s:isInTable=0 sub=subobj.%Save()
	  		s:isInTable=1 return=1
		 	}
		 	;i $$$ISERR(sub) q -2
	 }
 ;i $$$ISERR(sub) q 1
 q return
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-04-14
/// Description:： 检查分类 下拉选择（显示desc）
/// Table：        DHC_AppArcCat
/// other:         w ##class(web.DHCAPPCatLinkPart).getCheckCat()
ClassMethod getCheckCat()
{
  w "["
  set RowID=0,count=0 
  f  s RowID=$o(^DHCAPARCCA(RowID)) q:RowID=""  d
  .i count>0 d
  ..w ","
  .w "{"
  .w """id"":"_RowID_","
  .w """text"":"""_$p(^DHCAPARCCA(RowID),"^",2)_""""
  .w "}"
  .s count=count+1
  w "]"
  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-04-18
/// Description:： 列出
/// Table：        DHC_AppCatLinkPart、DHC_AppCatLinkSubPart
/// other:         w ##class(web.DHCAPPCatLinkPart).list()
ClassMethod list(CatRowId = "")
{
  w "{""rows"":["
  s partid=0,count=0
 
  ;f  s partid=$o(^DHCAPARCCA(partid)) q:partid=""  d
  s sub=""
  f  s sub=$o(^DHCAPARCCA(CatRowId,"P",sub)) q:sub=""  d
  .s chidID=""
  .f  s chidID=$o(^DHCAPARCCA(CatRowId,"P",sub,"S",chidID)) quit:chidID=""  d //父到子的唯一方法
  
  ..s subb=+$p(^DHCAPARCCA(CatRowId,"P",sub,"S",chidID),"^",1) ;子部位id
  ..q:'$d(^DHCAPPART(subb))
  ..s subbdesc=$p(^DHCAPPART(subb),"^",2) ;子部位desc
  ..s RowID=CatRowId_"||"_sub
  ..s catdesc=$p(^DHCAPARCCA(CatRowId),"^",2)
  ..s a=$p(^DHCAPARCCA(CatRowId,"P",sub),"^",1) ;部位id
  ..s b=$p(^DHCAPPART(a),"^",2) ;部位desc
  
  ..i count>0 d
  ...w ","
  ..s obj=##class(web.DHCAPPJsonObject).%New()
  ..d obj.Put("ID",RowID)
  ..d obj.Put("ACCat",catdesc)
  ..d obj.Put("ACPart",b)
  ..d obj.Put("ACSubPart",subbdesc)
  ..w obj.Json()	
  ..s count=count+1
  w "],""total"":"_count_"}"
  q ""
}

/// d ##class(web.DHCAPPCatLinkPart).find(1)
ClassMethod find(Id)
{
  
  q:+Id=0 ""
   
  s obj=##class(ext.util.JsonObject).%New()
  w obj.FromObject(##class(User.DHCAppCatLinkPart).%OpenId(Id)).Json()
  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-04-15
/// Description:： 删除大部位、子部位
/// Table：        DHC_AppCatLinkPart 、DHC_AppCatLinkSubPart
/// Input：	       Id：rowid 
///                ACSubPart:子部位描述
/// Return：       操作成功 0，其他 失败
/// other:         d ##class(web.DHCAPPCatLinkPart).remove()
ClassMethod remove(ID As %String, ACSubPart) As %String
{
  
	
	set return=0
	set ID1=$p(ID,"||",1)
	set ID2=$p(ID,"||",2)
	set child=""
	for
	{
		set child=$o(^DHCAPARCCA(ID1,"P",ID2,"S",child))
		quit:child=""
		
		set subPart=$p(^DHCAPARCCA(ID1,"P",ID2,"S",child),"^",1)
		set subPartDesc=$p(^DHCAPPART(subPart),"^",2)
		continue:subPartDesc'=ACSubPart
		set RowID=ID_"||"_child
		&SQL(Delete From DHC_AppCatLinkSubPart Where ACLSP_RowID=:RowID)
		set return=SQLCODE
		set child=$o(^DHCAPARCCA(ID1,"P",ID2,"S",""))
		if child=""
		{
			&SQL(Delete From DHC_AppCatLinkPart Where ACLP_RowID=:ID)
			set return=SQLCODE
		}
	}
	Q return
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-16
/// Description:： 未维护部位
/// Table：        DHC_AppOtherOpt
/// Input：	       CatRowId：检查分类RowId
///                type：0为未维护，1为全部
/// Other：d ##class(web.DHCAPPCatLinkPart).GetTreeCombo2()
ClassMethod GetTreeCombo2(type, CatRowId)
{
 s type=0
 w "["
 s Dpartid="",count=0
 for
 {
	 set Dpartid=$o(^DHCAPPART(0,"Parref",0,Dpartid)) 
	 q:Dpartid="" 
	 
	 s ret=""
	 i count>0 d
	 .s ret=ret_","
	 s ret= ret_"{"
	 s ret= ret_"""id"":"_Dpartid_","
	 s ret= ret_"""text"":"""_$p(^DHCAPPART(Dpartid),"^",2)_""""
	 s ret= ret_",""children"":["
	 
	 s isWite=0
	 
	 set i=0
	 set partid=""
	 for
	 {
		 set partid=$o(^DHCAPPART(0,"Parref",Dpartid,partid))
		 quit:partid=""
		  
		 set isIn=0
		 set subID=""
		 for
		 {
			 set subID=$o(^DHCAPARCCA(CatRowId,"P",subID))
			 quit:subID=""
			 
			 set subSubID=""
			 for
			 {
				set subSubID=$o(^DHCAPARCCA(CatRowId,"P",subID,"S",subSubID))
				quit:subSubID=""
				
				set WpartID=$p(^DHCAPARCCA(CatRowId,"P",subID,"S",subSubID),"^",1)
				
				continue:partid'=WpartID
				set isIn=1
			 }
			 
		 }
		
		 if (isIn=0)&&(type=0)
		 {    
			i i>0 d
			.w ","
			e  d
			.w ret
			w "{"
			w """id"":"_partid_","
			w """text"":"""_$p(^DHCAPPART(partid),"^",2)_""""
			w "}"
			s i=i+1
			s isWite=1	
		 }
		 if type=1
		 {
			i i>0 d
			.w ","
			e  d
			.w ret
			w "{"
			w """id"":"_partid_","
			w """text"":"""_$p(^DHCAPPART(partid),"^",2)_""""
			w "}"
			s i=i+1
			s isWite=1
		 }
	 }
	 if isWite=1
	 {
		w "]"
		w "}"
		s count=count+1
	 }
	 	 
 }
   w "]"
  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-18
/// Description:： 复制部位
/// Table：        DHC_AppCatLinkPart 、DHC_AppCatLinkSubPart、DHC_AppArcCat
/// Input：	       CatRowid：rowid 
///                CatRowidTwo:将复制rowid
/// other:         d ##class(web.DHCAPPCatLinkPart).SaveCopy(17,16)
ClassMethod SaveCopy(CatRowId, CatRowIdTwo)
{
    set subID=""
		for
		{
			set subID=$o(^DHCAPARCCA(CatRowIdTwo,"P",subID))
			quit:subID=""
			 
			set subSubID=""
			for
			{
			   set subSubID=$o(^DHCAPARCCA(CatRowIdTwo,"P",subID,"S",subSubID))
			   quit:subSubID=""
				
			   set WpartID=$p(^DHCAPARCCA(CatRowIdTwo,"P",subID,"S",subSubID),"^",1)
			   d ..Save(CatRowId,WpartID)
			 }
			 
		 }
}

}
