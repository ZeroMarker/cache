Class web.DHCAntCombinedUseReason Extends %RegisteredObject
{

/// w ##class(web.DHCAntCombinedUseReason).Update("^03^抗感染^Y^")
/// output:flag>0:成功  flag<=0:失败
ClassMethod Update(para)
{
    s flag=0   
    s Id=$p(para,"^",1)
    s CURCode=$p(para,"^",2)
    s CURDesc=$p(para,"^",3)
    s CURActiveFlag=$p(para,"^",4)
    i CURActiveFlag="true" s CURActiveFlag="Y"
    e  s CURActiveFlag="N"
    s CURText=$p(para,"^",5)
    if (Id=""){
        s obj=##class(User.DHCAntCombinedUseReason).%New()  
        
        &sql(SELECT count(*) INTO :mycount   
	 	FROM  SQLUSER.DHC_AntCombinedUseReason
	 		WHERE (CUR_Code=:CURCode)and(CUR_Desc=:CURDesc))
	 	if (mycount'=0)
	 	{	  
			 Quit -99
		}else{
    
	    	q:'$IsObject(obj) flag
	    	s obj.CURCode=CURCode
	    	s obj.CURDesc=CURDesc
	    	s obj.CURActiveFlag=CURActiveFlag
	    	s obj.CURText=CURText
	    	s sc=obj.%Save()
	    	if $System.Status.IsError(sc){
	        	d $System.Status.DisplayError(sc)
	        	s flag=-1    
	    	}else{
	        	s flag=obj.%Id()
	    	}
	    	d obj.%Close()
	    	q flag
	 	}
        
    }else{
        s obj=##class(User.DHCAntCombinedUseReason).%OpenId(Id) 
        q:'$IsObject(obj) flag
	    s obj.CURCode=CURCode
	    s obj.CURDesc=CURDesc
	    s obj.CURActiveFlag=CURActiveFlag
	    s obj.CURText=CURText
	    s sc=obj.%Save()
	    if $System.Status.IsError(sc){
	       d $System.Status.DisplayError(sc)
	       s flag=-1    
	    }else{
	        s flag=obj.%Id()
	    }
	    d obj.%Close()
	    q flag   
    }
}

/// w ##class(web.DHCAntCombinedUseReason).DeleteById(1)
/// output: flag=1成功    flag<=0失败
ClassMethod DeleteById(ID)
{
    
    s flag=0
    q:ID="" flag
    s sc = ##class(User.DHCAntCombinedUseReason).%DeleteId(ID)
    if $System.Status.IsError(sc) {            //检查删除是否成功
        d $system.OBJ.DisplayError(sc) 
        s flag=-1
    }else{
        s flag=1
    }
    q flag
}

Query QryCombinedUseReason(Code As %String, Desc As %String) As %Query(ROWSPEC = "TCurId:%String,TCURCode:%String,TCURDesc:%String,TCURActiveFlag:%String,TCURText:%String")
{
}

ClassMethod QryCombinedUseReasonExecute(ByRef qHandle As %Binary, Code As %String, Desc As %String) As %Status
{
    //d ##class(%ResultSet).RunQuery("web.DHCAntCombinedUseReason","QryCombinedUseReason","","")
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    s CurId=""
    f  s CurId=$o(^User.DHCAntCombinedUseReasonD(CurId)) q:CurId=""  d
    .s CURCode=$li(^User.DHCAntCombinedUseReasonD(CurId),2)
    .s CURDesc=$li(^User.DHCAntCombinedUseReasonD(CurId),3)
    .q:(Code'="")&&(Code'=CURCode)
    .q:(Desc'="")&&(Desc'=CURDesc)
    .s CURActiveFlag=$li(^User.DHCAntCombinedUseReasonD(CurId),4)
    .i CURActiveFlag="Y" s CURActiveFlag="是"
    .e  s CURActiveFlag="否"
    .s CURText=$li(^User.DHCAntCombinedUseReasonD(CurId),5)
    .d OutputRow
    ;Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(CurId,CURCode,CURDesc,CURActiveFlag,CURText)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod QryCombinedUseReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCombinedUseReasonExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod QryCombinedUseReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCombinedUseReasonExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
