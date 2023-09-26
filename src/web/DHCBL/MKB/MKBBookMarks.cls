///    @Title：收藏夹
///    @Creator:chenghegui
///    @Description:收藏 删除 查看
///    @CreateDate：2018-03-28
Class web.DHCBL.MKB.MKBBookMarks Extends %RegisteredObject
{

/// 查询数据
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBBookMarks","GetList")
Query GetList() As %Query(ROWSPEC = "MKBBKRowId,MKBBKCode,MKBBKDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
    Set UpdateUserDR=%session.Get("LOGON.USERID")   //登陆人
    Set UpdateLocDR=%session.Get("LOGON.CTLOCID")   //登陆科室
    s MKBBKRowId=0
    for{  
        s MKBBKRowId=$o(^User.MKBBookMarksD(MKBBKRowId)) q:MKBBKRowId=""   
        s MKBBKCode=$LISTGET($G(^User.MKBBookMarksD(MKBBKRowId)),2)
        s MKBBKDesc=$LISTGET($G(^User.MKBBookMarksD(MKBBKRowId)),3)
        //s:MKBBKDesc="-100000000000000" MKBBKDesc=""
        s MKBBKUser=$LISTGET($G(^User.MKBBookMarksD(MKBBKRowId)),4)
       /* s:MKBBKUser'="" SSUSRName=$p($g(^SSU("SSUSR",MKBBKUser)),"^",2)
        s:MKBBKUser="" SSUSRName=""*/
        s MKBBKLoc = $LISTGET($G(^User.MKBBookMarksD(MKBBKRowId)),5)
        /*s:MKBBKLoc'="" MKBBKUpdateLoc=$p($g(^CTLOC(MKBBKLoc)),"^",2)
        s:MKBBKLoc="" MKBBKLoc=""*/
        s MKBBKDate=$LISTGET($G(^User.MKBBookMarksD(MKBBKRowId)),6)
        s:MKBBKDate'="" MKBBKUpdateDate=$zd(MKBBKDate,1)
        i (UpdateUserDR=MKBBKUser)&(UpdateLocDR=MKBBKLoc)
        {
            d OutputRow
        }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(MKBBKRowId,MKBBKCode,MKBBKDesc)
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

/// Description：保存内容
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other
ClassMethod SaveDataStr(IdStr, SearchStr) As %String
{
    
    s result = ""
    Set UpdateDate=$p($h,",",1)      
    Set UpdateUserDR=%session.Get("LOGON.USERID")   
    Set UpdateLocDR=%session.Get("LOGON.CTLOCID")   
    s termDr=$p(IdStr,"-",1)
    if (termDr'="")
    {
        s code=IdStr,desc=SearchStr,user=UpdateUserDR,loc=UpdateLocDR
        s:desc="" desc= -100000000000000
        s:code="" code= -100000000000000
        s:user="" user= -100000000000000
        s:loc="" loc=-100000000000000
        s flagc=$d(^User.MKBBookMarksI("CodeUserLocIndex",code,desc,user,loc))
        if (flagc>0)
        {
              s result = "{""success"":""false"",""errorinfo"":""该条记录您已经收藏过了！""}"
        }
        else
        {   
            s obj=##class(User.MKBBookMarks).%New()
            s obj.MKBBMDate = UpdateDate
            d:UpdateLocDR'="" obj.MKBBMLocSetObjectId(UpdateLocDR)
            d:UpdateUserDR'="" obj.MKBBMUserSetObjectId(UpdateUserDR)
            s obj.MKBBMCode=IdStr
            s obj.MKBBMDesc=SearchStr
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                //s result = "{""success"":""true"",""id"":"""_id_"""}" //返回RowId
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
            }else{
                Trollback
                s result = "{""success"":""false"",""errorinfo"":"""_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"""}"   //返回错误信息
            }
        }   
    }   
    else
    {
        s result = "{""success"":""false"",""errorinfo"":""对象不存在""}"
    }
    
    q result
}

/// 删除
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
/// w ##class(web.DHCBL.MKB.MKBBookMarks).DeleteData(13)
ClassMethod DeleteData(id) As %String
{
  s result=""

  Tstart
  s sc=##class(User.MKBBookMarks).%DeleteId(id)
  IF $$$ISOK(sc) {
   Tc
   s result="{success:'true',info:'删除成功'}"
  }
  else 
  {
     Trollback
     s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
  }
 q result
}

/// 解析描述
/// Input：id 串
/// Return：诊断术语-属性-内容
/// w ##class(web.DHCBL.MKB.MKBBookMarks).GetDesc()
ClassMethod GetDesc(IdStr, flag) As %String
{
    q:IdStr="" ""
    s DescStr="",ProDesc="",TermDec="",BaseDesc=""
    s BaseDR = $p(IdStr,"-",1)
    s BaseDesc = ##class(web.DHCBL.MKB.MKBTermBase).GetDesc(BaseDR)
    S:($L(BaseDesc)>=1)&(flag="Y") BaseDesc=$e(BaseDesc,1,2)
    s TermProDR = $p(IdStr,"-",2)
    s:TermProDR'="" TermDR = $p(TermProDR,"*",1)
    s:TermProDR'="" ProDR= $p(TermProDR,"*",2)
    s:TermDR'="" TermDec = ##class(web.DHCBL.MKB.MKBTerm).GetDesc(TermDR)
    S:($L(TermDec)>=3)&(flag="Y") TermDec=$e(TermDec,1,3)
    s:ProDR'="" ProDesc = ##class(web.DHCBL.MKB.MKBTermProperty).GetDesc(ProDR)
    S:($L(ProDesc)>=3)&(flag="Y") ProDesc=$e(ProDesc,1,3)
    s:BaseDesc'="" DescStr = BaseDesc
    s:TermDec'="" DescStr=DescStr_">"_TermDec
    s:ProDesc'="" DescStr=DescStr_">"_ProDesc
    q DescStr
}

}
