Class web.DHCBL.MKB.MKBCopyTree Extends %RegisteredObject
{

/// Creator:李得原
/// CreatDate:2018-12-14
/// Description：复制术语树形节点或属性内容树形节点及其子节点到术语节点下
/// Table：User.MKBTerm
/// Input：ToId 要复制到的节点
/// Return：成功返回success:'true' ,失败返回success:'false'
/// w ##class(web.DHCBL.MKB.MKBCopyTree).CopyNode("",12478,3)
ClassMethod CopyNode(FromId = "", ToId As %String, flags) As %String
{
	;^TMP("mkbTermCopyToPaste",1,"D",1224405)=""
    s UserId=%session.Data("LOGON.USERID")
    ;s UserId=1
    if ('$d(^TMP("mkbTermCopyToPaste",UserId))) q "{success:'false',info:'请先复制节点！'}"
    s flag=$o(^TMP("mkbTermCopyToPaste",UserId,""))
    s CopyId=$o(^TMP("mkbTermCopyToPaste",UserId,flag,0))
    s BaseDR = $listGet($g(^User.MKBTermD(CopyId)),4)    //获取复制术语指向
    s Basedr=$listGet($g(^User.MKBTermD(ToId)),4)  //获取粘贴术语指向
    s str=""
    if flag="T"        //Term术语表
    {
	    
	    s FromId=CopyId
	    if flags=1          //FromId当前节点的复制
	    { 
	    	if CopyId=ToId
   			{
			   s result= "{success:'false',info:'不能复制节点到本节点子节点'}"
			   q result
			}
		    s AllToidChild=##class(web.DHCBL.MKB.MKBTerm).GetTreeChildOrderedIDStr(BaseDR,FromId)
		    if AllToidChild[ToId
		    {
			    s result= "{success:'false',info:'不能复制节点到本节点子节点'}"
			    q result
			}
		    
		    if (FromId="") set FromId="-100000000000000"
			if (ToId="") set ToId="-100000000000000"
			s obj=##class(User.MKBTerm).%OpenId(FromId)
			s BaseDR=obj.MKBTBaseDR.%Id()
			s Code=""                   //在SaveData方法中判断如果为空会自动生成
			s Desc=obj.MKBTDesc
			s LastLevel=ToId            
			s Note=obj.MKBTNote
			s PYCode=obj.MKBTPYCode
			s Sequence=""
		    d obj.%Close()
			s eobj =##class(web.Entity.MKB.MKBTerm).%New()
			s eobj.MKBTCode=Code
			s eobj.MKBTDesc=Desc
			s eobj.MKBTLastLevel=LastLevel
			s eobj.MKBTNote=Note
			s eobj.MKBTPYCode=PYCode
			s eobj.MKBTRowId=""
			s eobj.MKBTSequence=""
			s eobj.MKBTBaseDR=Basedr
			s ^TMP("MKBCTresult")=##class(web.DHCBL.MKB.MKBTerm).SaveData(eobj)
			d eobj.%Close()
			;{success:'true',id:'56'}
			;b:^TMP("MKBCTresult")["false"
	    }  
	    if flags=3
		{
			s ids=ToId
		}
		else
		{       
			s ids=$p(^TMP("MKBCTresult"),"'",4)
		}
		s rowid=0
		for
		{
			//获取FromId的子节点rowid
		    s rowid=$o(^User.MKBTermI("ParentIndex",BaseDR,FromId,rowid))   
		    quit:rowid=""
			s obj=##class(User.MKBTerm).%OpenId(rowid)
			s BaseDR=obj.MKBTBaseDR.%Id()
			s Code=""
			s Desc=obj.MKBTDesc
			s LastLevel=ids
			s Note=obj.MKBTNote
			s PYCode=obj.MKBTPYCode
			s Sequence=""
			d obj.%Close()
			s eobj =##class(web.Entity.MKB.MKBTerm).%New()
			s eobj.MKBTCode=Code
			s eobj.MKBTDesc=Desc
			s eobj.MKBTLastLevel=LastLevel
			s eobj.MKBTNote=Note
			s eobj.MKBTPYCode=PYCode
			s eobj.MKBTRowId=""
			s eobj.MKBTSequence=""
			s eobj.MKBTBaseDR=Basedr
			
			s ^TMP("MKBCTresult")=##class(web.DHCBL.MKB.MKBTerm).SaveData(eobj)
			d eobj.%Close()
			;{success:'true',id:'56'}
			s id=$p(^TMP("MKBCTresult"),"'",4)                  //新增数据的rowid
			if ^TMP("MKBCTresult")["false"
			{
				s str=str_Desc_":"_id
			}
			if $d(^User.MKBTermI("ParentIndex",BaseDR,rowid))      //如果存在子节点则递归
			{
				d ..CopyNode(rowid,ids,flags=2)
			}

		}
	}
	elseif flag="D"
	{
		;s UserId=%session.Data("LOGON.USERID")
	    ;s flag=$o(^TMP("mkbTermCopyToPaste",""))
	    ;s CopyId=$o(^TMP("mkbTermCopyToPaste","D",UserId,0))
	    ;s BaseDR = $listGet($g(^User.MKBTermD(CopyId)),4)    //获取术语指向
	    ;s str=""
	    
	    if flags=1
	    {
		    s FromId=CopyId
		    if (FromId="") set FromId="-100000000000000"
			if (ToId="") set ToId="-100000000000000"
			s prodr=$lg(^User.MKBTermProDetailD(FromId),6)
			s eobj =##class(web.Entity.MKB.MKBTerm).%New()     ;术语eobj
			s eobj.MKBTRowId=""
			s eobj.MKBTCode=""
			s eobj.MKBTDesc=$lg(^User.MKBTermProDetailD(FromId),3)
			s eobj.MKBTLastLevel=ToId
			s eobj.MKBTNote=$lg(^User.MKBTermProDetailD(FromId),7)
			s eobj.MKBTSequence=""
			s eobj.MKBTPYCode=$lg(^User.MKBTermProDetailD(FromId),10)
			s eobj.MKBTBaseDR=$lg(^User.MKBTermD(ToId),4)
			s ^TMP("MKBDTResult")=##class(web.DHCBL.MKB.MKBTerm).SaveData(eobj)
			d eobj.%Close()
			if ^TMP("MKBDTResult")["false"
			{
				q ^TMP("MKBDTResult")
			}
			s id=$p(^TMP("MKBDTResult"),"'",4)
			s DetailRowid=$o(^User.MKBTermPropertyI("TermIndex",id,0))    ;获取新生成的术语属性Rowid
			
			s DisplayRowid=$o(^User.MKBTermExtendProI("NameIndex",prodr," 展示名",0))   ;如果存在展示名则取值
			if DisplayRowid'=""
			{
				s PCRowid = prodr_"||"_DisplayRowid
				s rowid=$o(^User.MKBTermExtendProValI("ValIndex",FromId,PCRowid,0))
				s ValStr=$lg(^User.MKBTermExtendProValD(rowid),4)
				s DetailEobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
				s DetailEobj.MKBTPDCode=""
				s DetailEobj.MKBTPDProDR=DetailRowid
				s DetailEobj.MKBTPDRowId=""
				s DetailEobj.MKBTPDDesc=ValStr
				s DetailEobj.MKBTPDExtend=""
				s DetailEobj.MKBTPDLastLevel=""
				s DetailEobj.MKBTPDLevel=""
				s DetailEobj.MKBTPDRemark=""
				s DetailEobj.MKBTPDSequence=""
				s DetailEobj.MKBTPDActiveFlag=""
				s DetailEobj.MKBTPDPYCode=""
				s ^TMP("MKBTPDDisplayResult")=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(DetailEobj)
				d DetailEobj.%Close()
				if ^TMP("MKBTPDDisplayResult")[ "false"
				{
					q ^TMP("MKBTPDDisplayResult")
				}
			}

			
			s AliasRowid=$o(^User.MKBTermExtendProI("NameIndex",prodr," 别名",0))     ;如果存在别名则取值
			if AliasRowid'=""
			{
				s PCRowid = prodr_"||"_AliasRowid 
				s rowid=$o(^User.MKBTermExtendProValI("ValIndex",FromId,PCRowid,0))
				if rowid'=""
				{
					s ValStr=$lg(^User.MKBTermExtendProValD(rowid),4)

					s DetailEobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
					s DetailEobj.MKBTPDCode=""
					s DetailEobj.MKBTPDProDR=DetailRowid
					s DetailEobj.MKBTPDRowId=""
					s DetailEobj.MKBTPDDesc=ValStr
					s DetailEobj.MKBTPDExtend=""
					s DetailEobj.MKBTPDLastLevel=""
					s DetailEobj.MKBTPDLevel=""
					s DetailEobj.MKBTPDRemark=""
					s DetailEobj.MKBTPDSequence=""
					s DetailEobj.MKBTPDActiveFlag=""
					s DetailEobj.MKBTPDPYCode=""
					s ^TMP("MKBTPDAliasResult")=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(DetailEobj)
					d DetailEobj.%Close()
					if ^TMP("MKBTPDAliasResult")[ "false"
					{
						q ^TMP("MKBTPDAliasResult")
					}
				}
			}   
		}
		if flags=3
		{
			s id=ToId
		}
		else
		{
			s id=$p(^TMP("MKBDTResult"),"'",4)
		}

		s MKBTPDRowid=0     //复制子节点
	    for
	    {
		    s MKBTPDRowid=$o(^User.MKBTermProDetailI("ParIndex",FromId,MKBTPDRowid))  //复制子节点
		    q:MKBTPDRowid=""
		   
			s prodr=$lg(^User.MKBTermProDetailD(MKBTPDRowid),6)
			s eobj =##class(web.Entity.MKB.MKBTerm).%New()     ;术语eobj
			s eobj.MKBTRowId=""
			s eobj.MKBTCode=""
			s eobj.MKBTDesc=$lg(^User.MKBTermProDetailD(MKBTPDRowid),3)
			s eobj.MKBTLastLevel=id
			s eobj.MKBTNote=$lg(^User.MKBTermProDetailD(MKBTPDRowid),7)
			s eobj.MKBTSequence=""
			s eobj.MKBTPYCode=$lg(^User.MKBTermProDetailD(MKBTPDRowid),10)
			s eobj.MKBTBaseDR=$lg(^User.MKBTermD(ToId),4)
			s ^TMP("MKBDTResult")=##class(web.DHCBL.MKB.MKBTerm).SaveData(eobj)
			d eobj.%Close()
			s ChileId=$p(^TMP("MKBDTResult"),"'",4)     //获取新生成子节点的id
			if ^TMP("MKBDTResult")["false"
			{
				s str=str_"#"_$lg(^User.MKBTermProDetailD(MKBTPDRowid),3)_":"_id
			}
			s DetailRowid=$o(^User.MKBTermPropertyI("TermIndex",ChileId,0))    ;获取新生成的术语属性Rowid
			s DisplayRowid=$o(^User.MKBTermExtendProI("NameIndex",prodr," 展示名",0))   ;如果存在展示名则取值
			if DisplayRowid'=""
			{
				s PCRowid = prodr_"||"_DisplayRowid
				s rowid=$o(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowid,PCRowid,0))
				if rowid'=""
				{
					s ValStr=$lg(^User.MKBTermExtendProValD(rowid),4)
					s DetailEobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
					s DetailEobj.MKBTPDCode=""
					s DetailEobj.MKBTPDProDR=DetailRowid
					s DetailEobj.MKBTPDRowId=""
					s DetailEobj.MKBTPDDesc=ValStr
					s DetailEobj.MKBTPDExtend=""
					s DetailEobj.MKBTPDLastLevel=""
					s DetailEobj.MKBTPDLevel=""
					s DetailEobj.MKBTPDRemark=""
					s DetailEobj.MKBTPDSequence=""
					s DetailEobj.MKBTPDActiveFlag=""
					s DetailEobj.MKBTPDPYCode=""
					s ^TMP("MKBTPDDisplayResult")=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(DetailEobj)
					d DetailEobj.%Close()
					s ids=$p(^TMP("MKBTPDDisplayResult"),"'",4)
					if ^TMP("MKBTPDDisplayResult")[ "false"
					{
						s str=str_"#展示名:"_ids
					}
				}
			}
			s AliasRowid=$o(^User.MKBTermExtendProI("NameIndex",prodr," 别名",0))     ;如果存在别名则取值
			if AliasRowid'=""
			{
				s PCRowid = prodr_"||"_AliasRowid 
				s rowid=$o(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowid,PCRowid,0))
				if rowid'=""
				{
					s ValStr=$lg(^User.MKBTermExtendProValD(rowid),4)
					s DetailEobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
					s DetailEobj.MKBTPDCode=""
					s DetailEobj.MKBTPDProDR=DetailRowid
					s DetailEobj.MKBTPDRowId=""
					s DetailEobj.MKBTPDDesc=ValStr
					s DetailEobj.MKBTPDExtend=""
					s DetailEobj.MKBTPDLastLevel=""
					s DetailEobj.MKBTPDLevel=""
					s DetailEobj.MKBTPDRemark=""
					s DetailEobj.MKBTPDSequence=""
					s DetailEobj.MKBTPDActiveFlag=""
					s DetailEobj.MKBTPDPYCode=""
					s ^TMP("MKBTPDAliasResult")=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(DetailEobj)
					d DetailEobj.%Close()
					s ids=$p(^TMP("MKBTPDAliasResult"),"'",4)
					if ^TMP("MKBTPDAliasResult")[ "false"
					{
						s str=str_"#别名:"_ids
					}
				}
			}
			if $d(^User.MKBTermProDetailI("ParIndex",MKBTPDRowid))     //如果存在子节点则递归
			{
				d ..CopyNode(MKBTPDRowid,id,flags=2)
			}
		}
		
	}
	else
	{
		s result= "{success:'false',info:'复制失败'}" 
	}
	k ^TMP("mkbTermCopyToPaste")
	if str=""
	{
		s result= "{success:'true',info:'复制成功'}"
	}
	else
	{
		s result= "{success:'false',info:'"_str_"'}" 
	}
	q result
}

/// Creator:李得原
/// CreatDate:2018-12-18
/// Description：复制属性内容树型节点及其子节点到属性内容或术语节点下
/// Table：User.MKBTerm
/// Input：ToId 要复制到的节点
/// Return：成功返回success:'true' ,失败返回success:'false'
/// w ##class(web.DHCBL.MKB.MKBCopyTree).CopyPropertyDetailNode("",16388,3)
ClassMethod CopyPropertyDetailNode(FromId = "", ToId As %String, flags) As %String
{
    s UserId=%session.Data("LOGON.USERID")
    ;s UserId=1
    s flag=$o(^TMP("mkbTermCopyToPaste",UserId,""))
    q:flag="" "{success:'false',info:'您没有在辅助功能区处复制树形节点！'}"
    s CopyId=$o(^TMP("mkbTermCopyToPaste",UserId,flag,0))
    q:CopyId="" "{success:'false',info:'您没有在辅助功能区处复制树形节点！'}"
    s BaseDR = $listGet($g(^User.MKBTermD(CopyId)),4)    //获取术语指向
    s strs=""
    if flag="D"
    {
	    
    	if flags=1
    	{
	    	s FromId=CopyId 
	    	if CopyId=ToId
   			{
			   s result= "{success:'false',info:'不能复制节点到本节点子节点'}"
			   q result
			}
			s prodr=$lg(^User.MKBTermProDetailD(ToId),6)
		    s AllToidChild=##class(web.DHCBL.MKB.MKBTermProDetail).GetChildOrderedIDStr(FromId,prodr)
		    if AllToidChild[ToId
		    {
			    s result= "{success:'false',info:'不能复制节点到本节点子节点'}"
			    q result
			}
		                                          
		    if (FromId="") set FromId="-100000000000000"
			if (ToId="") set ToId="-100000000000000"
			s ^TMP("MKBCTcolumns")=""     
			s column="" 
			for
			{
				s column = $o(^User.MKBTermExtendProI("NameIndex",prodr,column))
				q:column=""
				s ^TMP("MKBCTcolumns")=^TMP("MKBCTcolumns")_"%%"_column
			}
			
			s str=""
			s ProDr=$lg(^User.MKBTermProDetailD(FromId),6)
			s ColumnRowid=0 
			s Column=0
			for                      //获取要复制节点的属性内容的扩展列名
			{
				s Column = $o(^User.MKBTermExtendProI("NameIndex",ProDr,Column))
				q:Column=""
				s ValStr=""
				if ^TMP("MKBCTcolumns")[Column
				{
					s ColumnRowid=$o(^User.MKBTermExtendProI("NameIndex",ProDr,Column,0))
					s PCRowid = ProDr_"||"_ColumnRowid
					s rowid=0 
					
					//获取要复制节点的属性内容的扩展属性值
					;^User.MKBTermExtendProValI("ValIndex",4296,"1759||4412",503)=""
					s rowid=$o(^User.MKBTermExtendProValI("ValIndex",FromId,PCRowid,0))
					if rowid=""
					{
						s ValStr=""
					}
					else
					{
						s ValStr=$lg(^User.MKBTermExtendProValD(rowid),4)
					}
					s:str'="" str=str_"[N]"_ColumnRowid_"[A]"_ValStr      //把扩展列名和值拼串
					s:str="" str=ColumnRowid_"[A]"_ValStr
				
				}
			}
			
			s eobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
			s eobj.MKBTPDActiveFlag=$lg(^User.MKBTermProDetailD(FromId),8)
			s eobj.MKBTPDCode=""
			s eobj.MKBTPDDesc=$lg(^User.MKBTermProDetailD(FromId),3)
			s eobj.MKBTPDExtend=str
			s eobj.MKBTPDLastLevel=ToId
			s eobj.MKBTPDLevel=$lg(^User.MKBTermProDetailD(FromId),5)
			s eobj.MKBTPDProDR=$lg(^User.MKBTermProDetailD(ToId),6)
			s eobj.MKBTPDPYCode=$lg(^User.MKBTermProDetailD(FromId),10)
			s eobj.MKBTPDRemark=$lg(^User.MKBTermProDetailD(FromId),7)
			s eobj.MKBTPDRowId=""
			s eobj.MKBTPDSequence=""
			s ^TMP("MKBCTresults")=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobj)
			if ^TMP("MKBCTresults")["false"
			{
				q ^TMP("MKBCTresults")
			}
			d eobj.%Close()
	    }
	    if flags=3
	    {
		    s ids=ToId
		}
		else
		{
	    	s ids=$p(^TMP("MKBCTresults"),"'",4)
		    if ^TMP("MKBCTresults")["false"
		    {
			    q ^TMP("MKBCTresults")
			}
		}

	    s Rowid=0     //复制子节点
	    for
	    {
		    s Rowid=$o(^User.MKBTermProDetailI("ParIndex",FromId,Rowid))
		    q:Rowid=""
			s ProDr=$lg(^User.MKBTermProDetailD(FromId),6)
			s str=""
			s Column="" 
			for                      //获取要复制节点的属性内容的扩展列名
			{
				s Column=$o(^User.MKBTermExtendProI("Namendex",ProDr,Column))
				q:Column=""
				;^User.MKBTermPropertyD(1759,"ChildExtPro",4410)=$lb("","映射主要病因","S","7")
				;s Column=$lg(^User.MKBTermPropertyD(ProDr,"ChildExtPro",ColumnRowid),2)
				s ValStr=""
				if ^TMP("MKBCTcolumns")[Column
				{
					s ColumnRowid=$o(^User.MKBTermExtendProI("NameIndex",ProDr,Column,0))
					s PCRowid = ProDr_"||"_ColumnRowid
					s rowid=0 
					
					//获取要复制节点的属性内容的扩展属性值
					;^User.MKBTermExtendProValI("ValIndex",4296,"1759||4412",503)=""
					s rowid=$o(^User.MKBTermExtendProValI("ValIndex",Rowid,PCRowid,0))

					s ValStr=$lg(^User.MKBTermExtendProValD(rowid),4)
					s:str'="" str=str_"[N]"_ColumnRowid_"[A]"_ValStr      //把扩展列名和值拼串
					s:str="" str=ColumnRowid_"[A]"_ValStr
				}
			}
			s eobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
			s eobj.MKBTPDActiveFlag=$lg(^User.MKBTermProDetailD(Rowid),8)
			s eobj.MKBTPDCode=""
			s eobj.MKBTPDDesc=$lg(^User.MKBTermProDetailD(Rowid),3)
			s eobj.MKBTPDExtend=str
			s eobj.MKBTPDLastLevel=ids
			s eobj.MKBTPDLevel=$lg(^User.MKBTermProDetailD(Rowid),5)
			s eobj.MKBTPDProDR=$lg(^User.MKBTermProDetailD(ToId),6)
			s eobj.MKBTPDPYCode=$lg(^User.MKBTermProDetailD(Rowid),10)
			s eobj.MKBTPDRemark=$lg(^User.MKBTermProDetailD(Rowid),7)
			s eobj.MKBTPDRowId=""
			s eobj.MKBTPDSequence=""
			s ^TMP("MKBCTresults")=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobj)
			d eobj.%Close()
			s id=$p(^TMP("MKBCTresults"),"'",4)                  //新增数据的rowid
			if ^TMP("MKBCTresults")["false"
			{
				s strs=strs_"#"_$lg(^User.MKBTermProDetailD(Rowid),3)_":"_id
				
			}
			if $d(^User.MKBTermProDetailI("ParIndex",Rowid))     //如果存在子节点则递归
			{
				d ..CopyPropertyDetailNode(Rowid,id,flags=2)
			}	
		}
	}
	elseif flag="T"
	{
		
		s str=""
		if flags=1
		{
			s FromId=CopyId
		    if (FromId="") set FromId="-100000000000000"
			if (ToId="") set ToId="-100000000000000"

			s ProDr=$lg(^User.MKBTermProDetailD(ToId),6)
			s DColumnRowid=$o(^User.MKBTermExtendProI("NameIndex",ProDr," 展示名",0))
			s AColumnRowid=$o(^User.MKBTermExtendProI("NameIndex",ProDr," 别名",0))
			s DisplayName=""
			s AliasFlag=1
			s AliasRowid=0
			for
			{
				s AliasRowid=$o(^User.MKBTermPropertyI("DescIndex",FromId," 别名",AliasRowid))
				q:AliasRowid=""
				s ADRowid=$o(^User.MKBTermProDetailI("ProIdx",AliasRowid,""))
				if AliasFlag=1
				{
					if ADRowid=""
					{
						s Alias=$lg($g(^User.MKBTermD(FromId)),3)
					}
					else
					{
						s Alias=$lg(^User.MKBTermProDetailD(ADRowid),3)                       ;获取别名
					}
					s:Alias'="" str=DColumnRowid_"[A]"_Alias                         ;别名拼串
					s AliasFlag=AliasFlag+1
				}
				else
				{
					s Display=$lg(^User.MKBTermProDetailD(ADRowid),3)                     ;如果有多于一个别名则赋值给展示名
					s DisplayName=Display_"#"_DisplayName
				}
			
			}
			if DisplayName'="" 
			{
				s str=str_"[N]"_AColumnRowid_"[A]"_DisplayName
			}
			s eobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
			s eobj.MKBTPDCode=""
			s eobj.MKBTPDDesc=$lg($g(^User.MKBTermD(FromId)),3)
			s eobj.MKBTPDLastLevel=ToId
			if str'=""
			{
				s eobj.MKBTPDExtend=str
			}
			s eobj.MKBTPDProDR=$lg($g(^User.MKBTermProDetailD(ToId)),6)
			;s eobj.MKBTPDPYCode=$lg($g(^User.MKBTermD(FromId)),6)
			s eobj.MKBTPDRemark=$lg($g(^User.MKBTermD(FromId)),7)
			s eobj.MKBTPDRowId=""
			s eobj.MKBTPDSequence=""
			s ^TMP("MKBTDResults")=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobj)
			if ^TMP("MKBTDResults")[ "false"
			{
				q ^TMP("MKBTDResults")
			}
			d eobj.%Close()	
		}
		
		if flags=3
		{
			s id=ToId
		}
		else
		{
			s id=$p(^TMP("MKBTDResults"),"'",4)
		}
		s BaseDR=$lg(^User.MKBTermD(FromId),4)
		s TermRowid=0
		for
		{
			s TermRowid=$o(^User.MKBTermI("ParentIndex",BaseDR,FromId,TermRowid))
			q:TermRowid=""
			s ProDr=$lg(^User.MKBTermProDetailD(ToId),6)
			s DColumnRowid=$o(^User.MKBTermExtendProI("NameIndex",ProDr," 展示名",0))
			s AColumnRowid=$o(^User.MKBTermExtendProI("NameIndex",ProDr," 别名",0))
			s DisplayName=""
			s AliasFlag=1
			s AliasRowid=0
			for
			{
				s AliasRowid=$o(^User.MKBTermPropertyI("DescIndex",TermRowid," 别名",AliasRowid))
				q:AliasRowid=""
				s ADRowid=$o(^User.MKBTermProDetailI("ProIdx",AliasRowid,""))
				if AliasFlag=1
				{
					if ADRowid=""
					{
						s Alias=$lg($g(^User.MKBTermD(TermRowid)),3)
					}
					else
					{
						s Alias=$lg(^User.MKBTermProDetailD(ADRowid),3)                       ;获取别名
					}
					s:Alias'="" str=DColumnRowid_"[A]"_Alias                         ;别名拼串
					s AliasFlag=AliasFlag+1
				}
				else
				{
					s Display=$lg(^User.MKBTermProDetailD(ADRowid),3)                     ;如果有多于一个别名则赋值给展示名
					s DisplayName=Display_"#"_DisplayName
				}
			
			}
			if DisplayName'="" 
			{
				s str=str_"[N]"_AColumnRowid_"[A]"_DisplayName
			}
			s eobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
			s eobj.MKBTPDCode=""
			s eobj.MKBTPDDesc=$lg($g(^User.MKBTermD(TermRowid)),3)
			s eobj.MKBTPDLastLevel=id
			s eobj.MKBTPDProDR=$lg(^User.MKBTermProDetailD(ToId),6)
			;s eobj.MKBTPDPYCode=$lg($g(^User.MKBTermD(TermRowid)),6)
			s eobj.MKBTPDRemark=$lg($g(^User.MKBTermD(TermRowid)),7)
			s eobj.MKBTPDRowId=""
			if str'=""
			{
				s eobj.MKBTPDExtend=str
			}
			s eobj.MKBTPDSequence=""
			s ^TMP("MKBTDResults")=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobj)
			s ids=$p(^TMP("MKBTDResults"),"'",4)
			if ^TMP("MKBTDResults")[ "false"
			{
				s strs=strs_"#"_$lg($g(^User.MKBTermD(TermRowid)),3)_":"_ids
			}
			d eobj.%Close()
			if $d(^User.MKBTermI("ParentIndex",BaseDR,TermRowid))      //如果存在子节点则递归
			{
				d ..CopyPropertyDetailNode(TermRowid,ids,flags=2)
			}
		}
		

	}
	else
	{
		s result= "{success:'false',info:'复制失败'}" 
	}
	;k ^TMP("mkbTermCopyToPaste")
	if strs=""
	{
		s result= "{success:'true',info:'复制成功'}" 
	}
	else
	{
		s result= "{success:'false',info:'"_strs_"'}" 
	}
	q result
}

}
