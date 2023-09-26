/// Functgion: 多院区业务配置分类明细分类明细
/// CreateDate:2021-07-02
/// Creator:   sunfengchao
Class web.DHCBL.CT.BDPHospSerConfigCategory Extends %RegisteredObject
{

/// Description：根据type去查询不同的程序 实现级联功能
/// CreatDate:2021-07-19
/// Creator:sunfengchao
/// Table： BDP_HospitalServiceConfig
/// Input： rowid,code,desc 
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPHospSerConfigCategory","GetList","","","")
Query GetComboList(rowid As %String, desc As %String, Type As %String, hospid As %String) As %Query(ROWSPEC = "RowId:%String,ItemDesc:%String")
{
}

ClassMethod GetComboListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, Type As %String, hospid As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1 
   if +hospid=0 s hospid=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hospid),0))  // 转为DR
   s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag() //医院级授权
   S desc=$ZCVT(desc,"U")
   
   if (Type="科室")
   {  
        s rs=##class(%ResultSet).%New("web.DHCBL.CT.CTLoc:GetDataForCmb1") 
        if (rs)
        {
            d rs.Execute("","",desc,"","","",hospid)
            while (rs.Next())
            {
                s RowId= rs.Data("CTLOCRowID") 
                s ItemDesc=rs.Data("CTLOCDesc") 
                d OutputRowCombo
            }
          
        } 
        d rs.%Close()       
   }
   elseif (Type="医嘱项")  //医嘱项
   { 
        s rs=##class(%ResultSet).%New("web.DHCBL.CT.ARCItmMast:GetDataForCmb1") 
        if (rs)
        {   
            d rs.Execute("","",desc,"","","","",hospid)
            while (rs.Next())
            {
                s RowId= rs.Data("ARCIMRowId") 
                s ItemDesc=rs.Data("ARCIMDesc") 
                s ^TMPARCIMDesc=ItemDesc 
                d OutputRowCombo
            } 
        } 
        d rs.%Close()   
         
   }
   elseif (Type="医嘱子类") 
   {    
        s rs=##class(%ResultSet).%New("web.DHCBL.CT.ARCItemCat:GetDataForCmb1") 
        if (rs)
        {   
            d rs.Execute("","","",desc,hospid)
            while (rs.Next())
            {
                s RowId= rs.Data("ARCICRowId") 
                s ItemDesc=rs.Data("ARCICDesc")  
                d OutputRowCombo
            } 
        } 
        d rs.%Close()  
       } 
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRowCombo
    set Data=$lb(RowId,ItemDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetComboListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComboListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetComboListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComboListExecute ]
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

/// Description：查询内容 
/// CreatDate:2021-07-12
/// Creator:sunfengchao
/// Table： BDP_HospSerConfigCategory
/// Input： rowid,code,desc
/// Return: 
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPHospSerConfigCategory","GetList","")
Query GetList(ParRef As %String, rowid As %String) As %Query(ROWSPEC = "ID:%String,BDPMHOSPCateReference:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String, rowid As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
      
    if (rowid'="")  
    {
        s ID=rowid
        s ParRef=$p(rowid,"||",1)
        s Version=$p(rowid,"||",2)
        s ChildSub=$p(rowid,"||",3)
        s BDPMHOSPCateReference=$listget($g(^User.BDPHospSerConfigCategoryD(ParRef,Version,ChildSub)),2)
        s BDPSerConfigCategory=$listget($g(^User.BDPHospitalServiceConfigD(ParRef,Version)),5)  /// 项目类型  
        if (BDPMHOSPCateReference'="")
        {
           if BDPSerConfigCategory="LOC" s BDPMHOSPCateReference=$p($g(^CTLOC(BDPMHOSPCateReference)),"^",2)       //科室名 // "科室"
           if BDPSerConfigCategory="ORD" s BDPMHOSPCateReference=$p($g(^ARCIM($p(BDPMHOSPCateReference,"||",1),$p(BDPMHOSPCateReference,"||",2),1)),"^",2) // "医嘱项"  
           if BDPSerConfigCategory="ORDCAT" s BDPMHOSPCateReference=$p($g(^ARC("IC",BDPMHOSPCateReference)),"^",2)  // "医嘱子类"   
        } 
        d OutputRow
    }
    else
    {
        if (ParRef="")
        {
           Set qHandle=$lb(0,repid,0)
           Quit $$$OK 
        }
        else
        { 
            s DetailParRef=$p(ParRef,"||",1)
            s Version=$p(ParRef,"||",2)
            s DetailChildSub=0
            for 
            {
                s DetailChildSub=$o(^User.BDPHospSerConfigCategoryD(DetailParRef,Version,DetailChildSub))
                q:DetailChildSub="" 
                s ID=DetailParRef_"||"_Version_"||"_DetailChildSub
                s BDPMHOSPCateReference=$listget($g(^User.BDPHospSerConfigCategoryD(DetailParRef,Version,DetailChildSub)),2)
                s BDPSerConfigCategory=$listget($g(^User.BDPHospitalServiceConfigD(DetailParRef,Version)),5)  /// 项目类型  
                if (BDPMHOSPCateReference'="")
                {
                   if BDPSerConfigCategory="LOC" s BDPMHOSPCateReference=$p($g(^CTLOC(BDPMHOSPCateReference)),"^",2)       //科室名 // "科室"
                   if BDPSerConfigCategory="ORD" s BDPMHOSPCateReference=$p($g(^ARCIM($p(BDPMHOSPCateReference,"||",1),$p(BDPMHOSPCateReference,"||",2),1)),"^",2) // "医嘱项"  
                   if BDPSerConfigCategory="ORDCAT" s BDPMHOSPCateReference=$p($g(^ARC("IC",BDPMHOSPCateReference)),"^",2)  // "医嘱子类"   
                } 
                d OutputRow 
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ID,BDPMHOSPCateReference)
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

/// Description 修改时打开的数据 
/// Creator:    sunfengchao
/// CreatDate:  2021-07-12
/// Input：     id  
/// Other:      w ##class(web.DHCBL.CT.BDPHospSerConfigCategory).OpenData("9")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.BDPHospSerConfigCategory).%New()
    s obj = ##class(User.BDPHospSerConfigCategory).%OpenId(id)
    s eobj.ID=id
    s eobj.BDPMHOSPCateReference= obj.BDPMHOSPCateReference  
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Description 数据重复验证方法，由js调用
/// Creator:    sunfengchao
/// CreatDate:  2021-07-12
/// Table：     User.BDPHospSerConfigCategory
/// Input：     id-rowid, code-代码,desc-描述
/// Return：    "1"(数据重复),"0"(数据不重复)
/// Other:      w ##class(web.DHCBL.CT.BDPHospSerConfigCategory).Validate("","","")
ClassMethod FormValidate(id As %String, ConfigRowId As %String, code As %String) As %String
{
    q:(code="") 1   
    s flag="",flagc=""
    if (id'="")
    {
        s ParRef =$p(id,"||",1)
        s ChildSub =$p(id,"||",2) 
    }
    if (ConfigRowId'="")
    {
       s ParRef =$p(ConfigRowId,"||",1)
       s ChildSub =$p(ConfigRowId,"||",2)  
    }
    s flagc=$d(^User.BDPHospSerConfigCategoryI("ReferIdx",ParRef,ChildSub,code)) 
    if (id="") //如果为空，增加时的重复判断
    {
        if (flagc>0)  s flag=1  
        else  s flag=0  
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^User.BDPHospSerConfigCategoryI("ReferIdx",ParRef,ChildSub,code,0)) 
        s CategoryChildSub =$p(id,"||",3)   
        if ((idc'="")&(idc'=CategoryChildSub)&(flagc>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Description 保存内容
/// Creator:    sunfengchao
/// CreatDate:  2021-01-12 
/// Table：     User.BDPHospSerConfigCategory
/// Input：     web.Entity.CT.BDPHospSerConfigCategory 实体类
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.BDPHospSerConfigCategory).SaveData(eobj)
ClassMethod SaveData(eobj As web.Entity.CT.BDPHospSerConfigCategory) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag= ..FormValidate(eobj.ID,eobj.ServiceConfigParRef,eobj.BDPMHOSPCateReference)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.ID="")  
            {
                s obj=##class(User.BDPHospSerConfigCategory).%New(eobj.ServiceConfigParRef)
                d obj.ServiceConfigParRefSetObjectId(eobj.ServiceConfigParRef)   
            }
            else                
            {
                s obj=##class(User.BDPHospSerConfigCategory).%OpenId(eobj.ID)
                s bobj=##class(web.Entity.CT.BDPHospSerConfigCategory).%New()
                s bobj.ID=eobj.ID 
                s bobj.BDPMHOSPCateReference = obj.BDPMHOSPCateReference
            }
            Tstart  
            s obj.BDPMHOSPCateReference=eobj.BDPMHOSPCateReference  
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tcommit
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  
                d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_HospSerConfigCategory","User.BDPHospSerConfigCategory","多院区业务配置分类明细",id,eobj.BDPMHOSPCateReference,"A",eobj)
                d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_HospSerConfigCategory","User.BDPHospSerConfigCategory","多院区业务配置分类明细",eobj.ID,eobj.BDPMHOSPCateReference,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("多院区业务配置分类明细","web.DHCBL.CT.BDPHospSerConfigCategory","SaveData",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
            }
        }               
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("多院区业务配置分类明细","web.DHCBL.CT.BDPHospSerConfigCategory","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：根据ID删除多院区业务配置分类明细的内容
/// CreatDate:2021-07-20
/// Creator:sunfengchao 
/// Table：User.BDPHospSerConfigCategory
/// Input：id 
/// Return：成功返回"{success:'true',info:'删除成功！'}"；
///         失败返回"{success:'false'和失败原因}
/// Other:  w ##class(web.DHCBL.CT.BDPHospSerConfigCategory).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""  
    s pobj = ##class(User.BDPHospSerConfigCategory).%OpenId(id)
    s eobj = ##class(web.Entity.CT.BDPHospSerConfigCategory).%New()
    s eobj.ID = id
    s eobj.BDPMHOSPCateReference=pobj.BDPMHOSPCateReference 
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(User.BDPHospSerConfigCategory).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_HospitalServiceConfig","User.BDPHospSerConfigCategory","多院区业务配置分类明细",id,eobj.BDPMHOSPCateReference,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("多院区业务配置分类明细","web.DHCBL.CT.BDPHospSerConfigCategory","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

}
