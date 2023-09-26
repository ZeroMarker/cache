Class web.DHCEMLevExpress Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-02
/// Description：  同时先后保存表达式表和主题子表
/// Table：        DHC_EmLevExpress
///                DHC_EmLevTheItm
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCEMLevExpress).SaveLevExpress("3^表达式3^表达式3^备注3^#分类0.函数3[主题1]>=75^1^Y")
ClassMethod SaveLevExpress(str)
{
	
    s str=$tr(str,"!","#")
    s LTITheParRef=$p(str,"^",1)
	s LEXCode=$p(str,"^",2)
	s LEXDesc=$p(str,"^",3)
	s LEXRemark=$p(str,"^",4)
    s LEXText=$p(str,"^",5)
	s LTILev=$p(str,"^",6)
    s LEXActiveFlag=$p(str,"^",7)
    s ID=$p(str,"^",8)
	
	s add=1
	TSTART	
	i +ID=0
 	{
		s obj=##class(User.DHCEmLevExpress).%New()
		i $d(^DHCEMLEX(0,"Code",LEXCode)) TRO
	    Q:$d(^DHCEMLEX(0,"Code",LEXCode)) 1
			 
    }else{
		s obj=##class(User.DHCEmLevExpress).%OpenId(ID)
		s add=0
		
		s isIN=0
		i $d(^DHCEMLEX(0,"Code",LEXCode)) d
		.s PHIDUP=$O(^DHCEMLEX(0,"Code",LEXCode,""))
		.q:PHIDUP=ID
		.s isIN=1
		q:isIN=1 1
    }
    
    s obj.LEXCode=LEXCode
    s obj.LEXDesc=LEXDesc
    s obj.LEXText=LEXText
	s obj.LEXActiveFlag=LEXActiveFlag
	s obj.LEXRemark=LEXRemark
	s obj.LEXHospDr=##class(User.CTHospital).%OpenId(%session.Get("LOGON.HOSPID"))
	
	 	 
	s sc=obj.%Save() 
	
	If sc'=1 TROLLBACK
	
	s LEXid=$o(^DHCEMLEX(0,"Code",LEXCode,""))
	
	;i $$$ISERR(sc) q -2
	if add'=0
	{
		s obj=##class(User.DHCEmLevTheItm).%New()
	
		s obj.LTITheParRef=##class(User.DHCEmLevTheme).%OpenId(LTITheParRef)
		s LTIChildSub=$o(^DHCEMLTH(LTITheParRef,"L",""),-1)+1
		s obj.LTIChildSub=LTIChildSub
		s obj.LTILev=LTILev
		s obj.LTIDesc=##class(User.DHCEmLevExpress).%OpenId(LEXid)
		s obj.LTIActiveFlag=LEXActiveFlag
		s sc=obj.%Save()
	}else
	{
		s ThemeID="" f  s ThemeID=$o(^DHCEMLTH(0,"LTIDesc",ID,ThemeID)) q:ThemeID=""  d
	    .s Itemchild="" f  s Itemchild=$o(^DHCEMLTH(0,"LTIDesc",ID,ThemeID,Itemchild)) q:Itemchild=""  d
	    ..s ItemID=ThemeID_"||"_Itemchild
	    ..s obj=##class(User.DHCEmLevTheItm).%OpenId(ItemID)
		..s obj.LTILev=LTILev
		..s obj.LTIActiveFlag=LEXActiveFlag
		..s sc=obj.%Save()
		}
	If sc'=1 TROLLBACK
	TCOMMIT
	
	q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-01
/// Description：  查找一条分级指标表达式,以json形式返回
/// Table：        DHC_EmLevExpress
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCEMLevExpress).FindLevExpress(1)
ClassMethod FindLevExpress(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCEmLevExpress).%OpenId(Id)).Json()
	  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-02
/// Description：  删除分级指标表达式库表
/// Table：        DHC_EmLevTheme
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
/// w ##class(web.DHCEMLevExpress).RemoveLevExpress(19)
ClassMethod RemoveLevExpress(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCEmLevExpress).%DeleteId(Id)

	  s theId=""
	  for{  
	  	s theId=$o(^DHCEMLTH(theId)) 
	  	q:theId=""
	  	 
	  	s chidID=""
	  	for{
		  	set chidID=$o(^DHCEMLTH(theId,"L",chidID)) 
			quit:chidID=""
			  
			s ExpressDr=$p(^DHCEMLTH(theId,"L",chidID),"^",2)
			
			if ExpressDr=Id
			{   
				s ID=theId_"||"_ExpressDr
				s obj=##class(User.DHCEmLevTheItm).%DeleteId(ID)			
			}
			
	  	   }
	  	 
	   }
	   q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-01
/// Description：  分级指标表达式显示
/// Table：        DHC_EmLevExpress
/// Input：	      
/// Others：d ##class(web.DHCEMLevExpress).ListLevExpress(,,,,2,,)
ClassMethod ListLevExpress(page = 1, rows = 10, LEXCode = "", LEXDesc = "", themeHidden = "", LTILev = "", q = "")
{
	    
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    
	    w "{""rows"":["
	    if themeHidden=""
		{
			s phId=""
			f  s phId=$o(^DHCEMLEX(phId)) q:phId=""  d
			.q:phId=0
			.s code=$p(^DHCEMLEX(phId),"^",1)
			.s desc=$p(^DHCEMLEX(phId),"^",2)
			.s text=$p(^DHCEMLEX(phId),"^",3)
			.s ActiveFlag=$p(^DHCEMLEX(phId),"^",4)
			.s Remark=$p(^DHCEMLEX(phId),"^",5)
			.s hop=$p(^DHCEMLEX(phId),"^",6)
			.q:(LEXCode'="")&(code'[LEXCode)
			.q:(LEXDesc'="")&(desc'[LEXDesc)
			.q:(q'="")&(desc'[q)		
			.s LVDesc=""
			.s Themeid="" f  s Themeid=$o(^DHCEMLTH(Themeid)) q:Themeid=""  d
			..s chidID="" f  s chidID=$o(^DHCEMLTH(Themeid,"L",chidID)) q:chidID=""  d
			...s LILID=$p(^DHCEMLTH(Themeid,"L",chidID),"^",2)
			...q:LILID'=phId
			...s Lev=$p(^DHCEMLTH(Themeid,"L",chidID),"^",1)
			.q:(LTILev'="")&(LTILev'=Lev)
			.s count=count+1
			.q:count<start
			.q:count>end
			.w $case(count,start:"",:",") 
			.s tmp=phId_"^"_code_"^"_desc_"^"_text_"^"_ActiveFlag_"^"_Remark_"^"_Lev
		    .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^LEXCode^LEXDesc^LEXText^LEXActiveFlag^LEXRemark^LTILev",tmp)

		
		}else
		{
			s themsub="" f  s themsub=$o(^DHCEMLTH(themeHidden,"L",themsub)) q:themsub=""  d
			.s phId=$p(^DHCEMLTH(themeHidden,"L",themsub),"^",2)
			.q:phId=""
			.q:'$d(^DHCEMLEX(phId))
			.s code=$p(^DHCEMLEX(phId),"^",1)
			.s desc=$p(^DHCEMLEX(phId),"^",2)
			.s text=$p(^DHCEMLEX(phId),"^",3)
			.s ActiveFlag=$p(^DHCEMLEX(phId),"^",4)
			.s Remark=$p(^DHCEMLEX(phId),"^",5)
			.s hop=$p(^DHCEMLEX(phId),"^",6)
			.q:(LEXCode'="")&(LEXCode'=code)
			.q:(LEXDesc'="")&(LEXDesc'=desc)
			.q:(q'="")&(desc'[q)				    
			.s LVDesc=""
			.s Themeid="" f  s Themeid=$o(^DHCEMLTH(Themeid)) q:Themeid=""  d
			..s chidID="" f  s chidID=$o(^DHCEMLTH(Themeid,"L",chidID)) q:chidID=""  d
			...s LILID=$p(^DHCEMLTH(Themeid,"L",chidID),"^",2)
			...q:LILID'=phId
			...s Lev=$p(^DHCEMLTH(Themeid,"L",chidID),"^",1)
			.q:(LTILev'="")&(LTILev'=Lev)
			.s count=count+1
			.q:count<start
			.q:count>end
			.w $case(count,start:"",:",") 
			.s tmp=phId_"^"_code_"^"_desc_"^"_text_"^"_ActiveFlag_"^"_Remark_"^"_Lev
		    .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^LEXCode^LEXDesc^LEXText^LEXActiveFlag^LEXRemark^LTILev",tmp)
				

		}
	    w "],""total"":"_count_"}"
		q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-01
/// Description：  分级指标主题树显示
/// Table：        DHC_EmLevExpress
/// 				   DHC_EmLevTheme
/// Input：	      
/// d ##class(web.DHCEMLevExpress).ListLevTree()
ClassMethod ListLevTree()
{
	s Del=""""
	 w "["
	 s Themeid=0,count=0
     for{
	      set Themeid=$o(^DHCEMLTH(Themeid)) 
	      q:Themeid="" 
	      s ret=""
	      i count>0 d
	      .s ret=ret_","
		  s ret= ret_"{"
		  s ret= ret_"""id"":"_Themeid_","
		  s ret= ret_"""text"":"""_($tr($p(^DHCEMLTH(Themeid),"^",2),Del,""))_""""_","
		  s ret= ret_"""attributes"":"""_1_""""
		  s ret= ret_",""children"":["
		  w ret
		  
		  s chidID="",i=0
		  for{
		  		set chidID=$o(^DHCEMLTH(Themeid,"L",chidID)) 
			  	quit:chidID=""
			  
			  	s ExpressDr=$p(^DHCEMLTH(Themeid,"L",chidID),"^",2)
			  
		  		set Expressid=0
	      		for{
		     		set Expressid=$o(^DHCEMLEX(Expressid)) 
	         		q:Expressid="" 
	          
		      		continue:ExpressDr'=Expressid
		      		i i>0 d
			  		.w ","
		     		w "{"
			  		w """id"":"_Expressid_","
			  		w """text"":"""_($tr($p(^DHCEMLEX(Expressid),"^",2),Del,""))_""""_","
			  		w """attributes"":"""_2_""""
			  		w "}"
			 		s i=i+1
		     		}
	    		 }
	    		 w "]"
		  		 w "}"
		  		 s count=count+1
	    		 }
	     
    w "]"
    q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-29
/// Description：  函数树初始化显示
/// Table：        DHC_EmLevFunCat
/// 				   DHC_EmLevFunLib
/// Input：	      Id：rowid
/// Return：      
/// d ##class(web.DHCEMLevExpress).ListCatLibTree()
ClassMethod ListCatLibTreeFirst()
{
	w "["
	 s FunCatid=0,count=0
     for{
	      set FunCatid=$o(^DHCEMLFC(FunCatid)) 
	      q:FunCatid="" 
	      
	      s CatFlag=$p(^DHCEMLFC(FunCatid),"^",3)
	      continue:CatFlag="N"
	      
	      s ret=""
	      i count>0 d
	      .s ret=ret_","
		  s ret= ret_"{"
		  s ret= ret_"""id"":"_1_","
		  s ret= ret_"""text"":"""_$p(^DHCEMLFC(FunCatid),"^",2)_""""
		  s ret= ret_",""children"":["
		  w ret
		  set FunLibid=0, i=0
	      for{
		      set FunLibid=$o(^DHCEMLFL(FunLibid)) 
	          q:FunLibid="" 
	          
	          s LibFlag=$p(^DHCEMLFL(FunLibid),"^",5)
	          continue:LibFlag="N"
	          
		      s CatDr=$p(^DHCEMLFL(FunLibid),"^",8)
		      continue:CatDr'=FunCatid
		      i i>0 d
			  .w ","
		      w "{"
			  w """id"":"_2_","
			  w """text"":"""_$p(^DHCEMLFL(FunLibid),"^",2)_""""_","
			  w """attributes"":"""_$p(^DHCEMLFL(FunLibid),"^",1)_""""
			  w "}"
			  s i=i+1
		     }
		  w "]"
		  w "}"
		  s count=count+1  
	     }
	     
    w "]"
    q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-31
/// Description：  函数树显示
/// Table：        DHC_EmLevFunCat
/// 				   DHC_EmLevFunLib
/// Input：	      Id：rowid
/// Return：      
/// d ##class(web.DHCEMLevExpress).ListCatLibTree()
ClassMethod ListCatLibTree(themeID)
{
    
     
     s LTHHospDr=$p(^DHCEMLTH(themeID),"^",5)
	 w "["
	 s FunCatid=0,count=0
     for{
	      set FunCatid=$o(^DHCEMLFC(FunCatid)) 
	      q:FunCatid="" 
	      
	      s CatHospDr=$p(^DHCEMLFC(FunCatid),"^",5)
	      continue:CatHospDr'=LTHHospDr
	     
	      s CatFlag=$p(^DHCEMLFC(FunCatid),"^",3)
	      continue:CatFlag="N"
	      
	      s ret=""
	      i count>0 d
	      .s ret=ret_","
		  s ret= ret_"{"
		  s ret= ret_"""id"":"_1_","
		  s ret= ret_"""text"":"""_$p(^DHCEMLFC(FunCatid),"^",2)_""""
		  s ret= ret_",""children"":["
		  w ret
		  set FunLibid=0, i=0
	      for{
		      set FunLibid=$o(^DHCEMLFL(FunLibid)) 
	          q:FunLibid="" 
	          
	          s LibFlag=$p(^DHCEMLFL(FunLibid),"^",5)
	          continue:LibFlag="N"
	          
		      s CatDr=$p(^DHCEMLFL(FunLibid),"^",8)
		      continue:CatDr'=FunCatid
		      i i>0 d
			  .w ","
		      w "{"
			  w """id"":"_2_","
			  w """text"":"""_$p(^DHCEMLFL(FunLibid),"^",2)_""""_","
			  w """attributes"":"""_$p(^DHCEMLFL(FunLibid),"^",1)_""""
			  w "}"
			  s i=i+1
		     }
		  w "]"
		  w "}"
		  s count=count+1  
	     }
	     
    w "]"
    q ""
}

}
