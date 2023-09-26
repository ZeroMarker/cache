Import SQLUser

/// Function:     图标管理 
/// CreateDate:   2016-09-18
/// Creator:      基础数据平台公共产品组   孙凤超 
Class web.DHCBL.BDP.BDPIconManage Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function: 查询程序  
/// CreateDate:   2016-09-18
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPIconManage","GetList","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,BDPICONCode:%String,BDPICONDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s:code'="" code=$tr($zcvt(code,"U"),$c(13,10))
    s:desc'="" desc=$tr($zcvt(desc,"U"),$c(13,10))
 
    if (rowid'="")
    {
      s ID=rowid
      s BDPICONCode=$LISTGET($g(^User.BDPIconManageD(ID)),2) 
      s BDPICONDesc =$LISTGET($g(^User.BDPIconManageD(ID)),3)  
      d OutputRow
    }
    else
    {
        s ID=0
        for
        {  
          s ID=$o(^User.BDPIconManageD(ID))
          q:ID="" 
          
          s BDPICONCode=$LISTGET($g(^User.BDPIconManageD(ID)),2) 
          s BDPICONDesc =$LISTGET($g(^User.BDPIconManageD(ID)),3)  
          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BDPICONDesc)
          if (((code="")||($zcvt(BDPICONCode,"U")[code))&&((desc="")||($zcvt(BDPICONDesc,"U")[desc)||(PINYINCODE[desc)))
          {
            d OutputRow
          }
     }
  }
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRow
    set Data=$lb(ID,BDPICONCode,BDPICONDesc)
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

/// Function:  删除的类方法
/// CreateDate:2016-09-13
/// Creator: sunfengchao
/// Input: id
/// Output: "{success:'true',info:'删除成功！'}"
/// Debug: d ##class(web.DHCBL.BDP.BDPIconManage).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    Tstart
    s pobj = ##class(User.BDPIconManage).%OpenId(id)
    s eobj = ##class(web.Entity.CT.BDPIconManage).%New()     
    s eobj.ID =id
    s eobj.BDPICONCode = pobj.BDPICONCode
    s eobj.BDPICONDesc=pobj.BDPICONDesc
    s sc=##class(User.BDPIconManage).%DeleteId(id)
    IF $$$ISOK(sc)
    {
      Tc
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_IconManage","User.BDPIconManage","图标库",id,eobj.BDPICONDesc,"D",eobj)
      s result="{success:'true',info:'删除成功！'}"
    }
    else
    {
      Trollback
      s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("图标库","web.DHCBL.BDP.BDPIconManage","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")   
    }
    q result
}

/// Function: 保存 用于添加时的操作
/// CreateDate: 2014-04-09
/// Creator:   组 sunfenghao
/// Debug:   添加数据时  d ##class(web.DHCBL.BDP.BDPAlias).SaveEntity("^PAC_BabyPositon^A1^48#^PAC_BabyPositon^A2^48#^PAC_BabyPositon^A3^48")
///          修改数据时  d ##class(web.DHCBL.BDP.BDPAlias).SaveEntity("144^PAC_BabyPositon^AB1^48#145^PAC_BabyPositon^AB2^48#146^PAC_BabyPositon^AB3^48")                                          
ClassMethod SaveEntity(eobj As web.Entity.CT.BDPIconManage) As %String
{
   if (eobj.ID="")
   {
        s obj=##class(User.BDPIconManage).%New()
    }
    else{
        s obj=##class(User.BDPIconManage).%OpenId(eobj.ID)
        s pobj=##class(web.Entity.CT.BDPIconManage).%New()
        s pobj.ID=eobj.ID
        s pobj.BDPICONCode=obj.BDPICONCode
        s pobj.BDPICONDesc=obj.BDPICONDesc
        
    }
    s obj.BDPICONCode = eobj.BDPICONCode
    s obj.BDPICONDesc = eobj.BDPICONDesc  
    s sc=obj.%Save()
    d obj.%Close()
    If $$$ISOK(sc)
    {
       s id = obj.%Id()
       s result = "{success:'true',id:'"_id_"'}"
       d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_IconManage","User.BDPIconManage","图标库",id,eobj.BDPICONDesc,"A",eobj) 
       d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_IconManage","User.BDPIconManage","图标库",id,eobj.BDPICONDesc,"U",eobj,pobj)
    }
    else
    {
       s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"  
    }     
    q result
}

/// CreatDate:2012-9-11
/// Description:双击修改时,从后台取数据
/// Creator:sunfengchao
/// Table: BDP_IconManage
/// Other:d ##class(web.DHCBL.BDP.BDPIconManage).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""
    s pobj = ##class(User.BDPIconManage).%OpenId(id)
    s eobj = ##class(web.Entity.CT.BDPIconManage).%New()
    s eobj.ID = id
    s eobj.BDPICONCode = pobj.BDPICONCode
    s eobj.BDPICONDesc = pobj.BDPICONDesc
    d pobj.%Close()
    k pobj
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Function:进行数据校验
/// CreateDate: 2016-09-13
/// Creator:  sunfengchao
/// debug: w ##class(web.DHCBL.BDP.BDPIconManage).FormValidate("","PAC_BabyPositon","48","顶顶顶顶")
ClassMethod FormValidate(id As %String, code As %String) As %String
{
    s flag=0,flagc="",flagd=""
    s:code'="" flagc=$d(^User.BDPIconManageI("Code",code))
    if (id="") //如果为空，增加时的重复判断
    {
      if (flagc>0) s flag=1  //返回重复标志
    }
    else //如果不为空，修改时的重复判断
    {
      s:code'="" idc=$o(^User.BDPIconManageI("Code",code,0))
      if ((idc'=id)&(flagc>0)) s flag=1  //返回重复标志 
    }
    q flag
}

/// d ##class(web.DHCBL.BDP.BDPIconManage).ImportIcon()
ClassMethod ImportIcon()
{
    s ID=0
    for
    {
      s ID=$o(^User.BDPExecutablesD(ID)) 
      q:ID=""  
      s eobj=##class(web.Entity.CT.BDPIconManage).%New()
      S eobj.BDPICONCode=$LISTGET($G(^User.BDPExecutablesD(ID)),4)_".png"
      S eobj.BDPICONDesc=$LISTGET($G(^User.BDPExecutablesD(ID)),3)
      d ..SaveEntity(eobj)
    }
}

/// Function: 遍历图标库
/// Creator:  sunfengchao
/// CreateDate: 2016-9-14
/// w ##class(web.DHCBL.BDP.BDPIconManage).GetPicURL()
ClassMethod GetPicURL() As %String
{
  s ID=0,ImageI="",ImageStr=""
  for
  {
    s ID=$o(^User.BDPIconManageD(ID)) 
    q:ID=""  
    s BDPICONCode=$LISTGET($G(^User.BDPIconManageD(ID)),2)
    s:BDPICONCode'="" BDPICONCode=$p(BDPICONCode,"/",$l(BDPICONCode,"/"))
    if (BDPICONCode'="")
    {
       if (ImageStr="")
       {
          s ImageStr=BDPICONCode
       }
       else
       {
          s ImageStr=ImageStr_"^"_BDPICONCode
       }
    }
  }
  q ImageStr
}

}
