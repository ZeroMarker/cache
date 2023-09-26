/// 名称:保存获取反馈意见
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 谷雪萍
/// 编写日期:2021-3-4
Class web.CDSS.CMKB.Feedback Extends %RegisteredObject
{

/// Creator:谷雪萍
/// CreatDate:2021-3-4
/// Description：保存反馈意见
/// Table:CT.WDT.CDSS.Feedback反馈意见表
/// Input：eobj-反馈意见实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.CDSS.CMKB.Feedback).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.Feedback) As %String
{
    //s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    { 
        if (eobj.Feedback="")
        {
            q "{success:'false',errorinfo:'意见不能为空！'}"
        }
        
        if (eobj.ID="")  //如果RowId未赋值则增加
        {
            s obj=##class(CT.WDT.CDSS.Feedback).%New()
            /*if (eobj.CreateLoc="")
            {
	            s LocId = $g(%session.Data("LOGON.CTLOCID"))
	            s LocDesc=$p($g(^CTLOC(LocId)),"^",2) 
		        s obj.CreateLoc=LocDesc
            }
            else
            {
	            s obj.CreateLoc=eobj.CreateLoc
            }
            if (eobj.CreateUser="")
            {
	       		s obj.CreateUser=$g(%session.Data("LOGON.USERNAME"))
            }
            else
            {
	            s obj.CreateUser=eobj.CreateUser
            }*/
            s obj.CreateLoc=eobj.CreateLoc
            s obj.CreateUser=eobj.CreateUser
            s obj.CreateTime=$ZDATETIME($HOROLOG,3)
        }
        else    //如果RowId已赋值则修改
        {
            s obj=##class(CT.WDT.CDSS.Feedback).%OpenId(eobj.ID)
            s bobj=##class(web.CDSSEntity.CMKB.Feedback).%New()
            s bobj.ID=eobj.ID
            s bobj.OpinionPortal=obj.OpinionPortal          //修改描述
            s bobj.Feedback=obj.Feedback
            s bobj.CreateLoc=obj.CreateLoc
            s bobj.CreateUser=obj.CreateUser 
            s bobj.CreateTime=obj.CreateTime
            s bobj.OpinionPortalType=obj.OpinionPortalType
        }
        Ts
        s obj.OpinionPortal = eobj.OpinionPortal          //修改描述
        s obj.Feedback =eobj.Feedback
        s obj.OpinionPortalType=eobj.OpinionPortalType
     
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            Tc
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId
            //新增时，日志
            d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.Feedback","CT.WDT.CDSS.Feedback","反馈意见表",id,eobj.Feedback,"A",eobj)
            //修改时，日志
            d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.Feedback","CT.WDT.CDSS.Feedback","反馈意见表",eobj.ID,eobj.Feedback,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("反馈意见表","web.CDSS.CMKB.DHCDSSFeedback","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)

        }
    }                 
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
    s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("反馈意见表","web.CDSS.CMKB.DHCDSSFeedback","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:谷雪萍
/// CreatDate:2021-3-4
/// Description：保存反馈意见
/// Table:CT.WDT.CDSS.Feedback反馈意见表
/// Input：FeedbackStr-反馈意见信息串：用户名&%科室名&%入口类型&%入口&%反馈信息
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.CDSS.CMKB.Feedback).SaveData("DM000226^DM000226^1^住院^^xwh^^产科^1","测试")
ClassMethod SaveData(PatientInfo As %String, Feedback As %String) As %String
{
	s eobj=##class(web.CDSSEntity.CMKB.Feedback).%New()
	//s eobj.CreateUser=$p($g(FeedbackStr),"&%",1)
	//s PatientInfo = $p($g(FeedbackStr),"&%",1)
	s eobj.CreateUser = $p($g(PatientInfo),"^",6)
	s eobj.CreateLoc = $p($g(PatientInfo),"^",8)
	//s eobj.CreateLoc=$p($g(FeedbackStr),"&%",2)
	//s eobj.OpinionPortalType=$p($g(FeedbackStr),"&%",3)
	//s eobj.OpinionPortal=$p($g(FeedbackStr),"&%",4)
	s eobj.Feedback=Feedback
	s res=##class(web.CDSS.CMKB.Feedback).SaveEntity(eobj)
	q res
}

/// Creator:Xuwenhu
/// CreatDate:2021-08-03
/// Description：查询
/// Table:CT.WDT.CDSS.Feedback反馈意见表
/// Input：createloc-创建科室, createuser-创建人员, createtime-创建时间, opinionportaltype-意见入口分类（评估表，文献）
/// Return：ID,OpinionPortal,Feedback,CreateLoc,CreateUser,CreateTime,OpinionPortalType
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.Feedback","GetList","","","","","","")
Query GetList(rowid As %String, createloc As %String, createuser As %String, starttime As %String, endtime As %String, opinionportaltype As %String) As %Query(ROWSPEC = "ID,OpinionPortal,Feedback,CreateLoc,CreateUser,CreateTime,OpinionPortalType")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, createloc As %String, createuser As %String, starttime As %String, endtime As %String, opinionportaltype As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryAssessel).DHCGetDataByDefaultSession()
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s ID=rowid
        s OpinionPortal=$lg($g(^CT.WDT.CDSS.FeedbackD(ID)),2) 		//意见入口
        s Feedback=$lg($g(^CT.WDT.CDSS.FeedbackD(ID)),3) 			//反馈意见
        s CreateLoc=$lg($g(^CT.WDT.CDSS.FeedbackD(ID)),4) 			//创建科室
        s CreateUser=$lg($g(^CT.WDT.CDSS.FeedbackD(ID)),5) 			//创建人员
        s CreateTime=$lg($g(^CT.WDT.CDSS.FeedbackD(ID)),6) 			//创建时间
        s OpinionPortalType=$lg($g(^CT.WDT.CDSS.FeedbackD(ID)),7) 	//意见入口分类：评估表、文献

        d OutputRow
    }
    else
    {
		s:createloc'="" createloc=$ZCONVERT(createloc,"U") //转换成大写
		s:createuser'="" createuser=$ZCONVERT(createuser,"U") //转换成大写
        s ID=0
        for
        {
            s ID=$o(^CT.WDT.CDSS.FeedbackD(ID))
            q:ID=""
		    s OpinionPortal=$lg($g(^CT.WDT.CDSS.FeedbackD(ID)),2) 		//意见入口
	        s Feedback=$lg($g(^CT.WDT.CDSS.FeedbackD(ID)),3) 			//反馈意见
	        s CreateLoc=$lg($g(^CT.WDT.CDSS.FeedbackD(ID)),4) 			//创建科室
	        continue:((createloc'="")&&($ZCONVERT(CreateLoc,"U")'[createloc))
	        s CreateUser=$lg($g(^CT.WDT.CDSS.FeedbackD(ID)),5) 			//创建人员
	        continue:((createuser'="")&&($ZCONVERT(CreateUser,"U")'[createuser))
	        s CreateTime=$lg($g(^CT.WDT.CDSS.FeedbackD(ID)),6) 			//创建时间
	        continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateTime,3)))
	        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateTime,3)))
	        s OpinionPortalType=$lg($g(^CT.WDT.CDSS.FeedbackD(ID)),7) 	//意见入口分类：评估表、文献
	        continue:((opinionportaltype'="")&&(OpinionPortalType'=opinionportaltype))
			d OutputRow
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ID,OpinionPortal,Feedback,CreateLoc,CreateUser,CreateTime,OpinionPortalType)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
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

}
