Class web.DHCAntChangeReason Extends %RegisteredObject
{

/// w ##class(web.DHCAntChangeReason).Update("1^01^产生耐药^Y^")
/// output:flag>0:成功  flag<=0:失败
ClassMethod Update(para)
{
    s flag=0   
    s Id=$p(para,"^",1)
    s CHRCode=$p(para,"^",2)
    s CHRDesc=$p(para,"^",3)
    s CHRActiveFlag=$p(para,"^",4)
    i CHRActiveFlag="true" s CHRActiveFlag="Y"
    e  s CHRActiveFlag="N"
    s CHRText=$p(para,"^",5)
    if (Id=""){
        s obj=##class(User.DHCAntChangeReason).%New()
        &sql(SELECT count(*) INTO :mycount   
	 	FROM  SQLUSER.DHC_AntChangeReason
	 		WHERE (CHR_Code=:CHRCode)and(CHR_Desc=:CHRDesc))
	 	if (mycount'=0)
	 	{	  
			 Quit -99
		}else{
			q:'$IsObject(obj) flag
		    s obj.CHRCode=CHRCode
		    s obj.CHRDesc=CHRDesc
		    s obj.CHRActiveFlag=CHRActiveFlag
		    s obj.CHRText=CHRText
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
        s obj=##class(User.DHCAntChangeReason).%OpenId(Id)    
        q:'$IsObject(obj) flag
	    s obj.CHRCode=CHRCode
	    s obj.CHRDesc=CHRDesc
	    s obj.CHRActiveFlag=CHRActiveFlag
	    s obj.CHRText=CHRText
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

/// w ##class(web.DHCAntChangeReason).DeleteById(1)
/// output: flag=1成功    flag<=0失败
ClassMethod DeleteById(ID)
{
    
    s flag=0
    q:ID="" flag
    s sc = ##class(User.DHCAntChangeReason).%DeleteId(ID)
    if $System.Status.IsError(sc) {            //检查删除是否成功
        d $system.OBJ.DisplayError(sc) 
        s flag=-1
    }else{
        s flag=1
    }
    q flag
}

Query QryChangeReason(Code As %String, Desc As %String) As %Query(ROWSPEC = "TChrId:%String,TCHRCode:%String,TCHRDesc:%String,TCHRActiveFlag:%String,TCHRText:%String")
{
}

ClassMethod QryChangeReasonExecute(ByRef qHandle As %Binary, Code As %String, Desc As %String) As %Status
{
    //d ##class(%ResultSet).RunQuery("web.DHCAntChangeReason","QryChangeReason","","")
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    s ChrId=""
    f  s ChrId=$o(^User.DHCAntChangeReasonD(ChrId)) q:ChrId=""  d
    .s CHRCode=$li(^User.DHCAntChangeReasonD(ChrId),2)
    .s CHRDesc=$li(^User.DHCAntChangeReasonD(ChrId),3)
    .q:(Code'="")&&(Code'=CHRCode)
    .q:(Desc'="")&&(Desc'=CHRDesc)
    .s CHRActiveFlag=$li(^User.DHCAntChangeReasonD(ChrId),4)
    .i CHRActiveFlag="Y" s CHRActiveFlag="是"
    .e  s CHRActiveFlag="否"
    .s CHRText=$li(^User.DHCAntChangeReasonD(ChrId),5)
    .d OutputRow
    ;Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ChrId,CHRCode,CHRDesc,CHRActiveFlag,CHRText)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod QryChangeReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryChangeReasonExecute ]
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

ClassMethod QryChangeReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryChangeReasonExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
