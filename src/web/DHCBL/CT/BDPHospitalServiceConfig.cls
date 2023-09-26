/// Functgion: 多院区业务配置配置 
/// CreateDate:2021-07-02
/// Creator:   sunfengchao 
Class web.DHCBL.CT.BDPHospitalServiceConfig Extends %RegisteredObject
{

/// Description：查询内容 
/// CreatDate:2021-07-12
/// Creator:sunfengchao
/// Table： BDP_HospitalServiceConfig
/// Input： rowid,code,desc
/// Return: 
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPHospitalServiceConfig","GetList","1","","")
Query GetList(ParRef As %String, rowid As %String, hospital As %String) As %Query(ROWSPEC = "ID:%String,BDPSerConfigType:%String,BDPSerConfigCurrenHospDR:%String,BDPSerConfigOperateHospDR:%String,BDPSerConfigCategory:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String, rowid As %String, hospital As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
      
    if (rowid'="")  
    {
        s ID=rowid
        s ServinceParRef=$p(rowid,"||",1)
        s ChildSub=$p(rowid,"||",2)
        s BDPSerConfigType=$listget($g(^User.BDPHospitalServiceConfigD(ServinceParRef,ChildSub)),2) 
        s:BDPSerConfigType="DL" BDPSerConfigType="按登录"
        s:BDPSerConfigType="KD" BDPSerConfigType="按开单"
        s:BDPSerConfigType="JZ" BDPSerConfigType="按就诊"  
        s:BDPSerConfigType="JS" BDPSerConfigType="按接收"  
        s BDPSerConfigCurrenHospDR=$listget($g(^User.BDPHospitalServiceConfigD(ServinceParRef,ChildSub)),3) /// 当前医院 
        s:BDPSerConfigCurrenHospDR'="" BDPSerConfigCurrenHospDR=$P($g(^CT("HOSP",BDPSerConfigCurrenHospDR)),"^",2)
        s BDPSerConfigOperateHospDR=$listget($g(^User.BDPHospitalServiceConfigD(ServinceParRef,ChildSub)),4) /// 可操作医院
        s:BDPSerConfigOperateHospDR'="" BDPSerConfigOperateHospDR=$P($g(^CT("HOSP",BDPSerConfigOperateHospDR)),"^",2)
        s BDPSerConfigCategory=$listget($g(^User.BDPHospitalServiceConfigD(ServinceParRef,ChildSub)),5)  /// 项目 
        s:BDPSerConfigCategory="LOC" BDPSerConfigCategory="科室"
        s:BDPSerConfigCategory="ORD" BDPSerConfigCategory="医嘱项"  
        s:BDPSerConfigCategory="ORDCAT" BDPSerConfigCategory="医嘱子类"  
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
            if ('$d(^User.BDPHospitalServiceConfigD(ParRef)))
            {
                Set qHandle=$lb(0,repid,0)
                Quit $$$OK 
            }
            else
            {
                s ChildSub=0
                for 
                {
                    s ChildSub=$o(^User.BDPHospitalServiceConfigD(ParRef,ChildSub)) 
                    q:ChildSub="" 
                    s ID=ParRef_"||"_ChildSub 
                    s BDPSerConfigType=$listget($g(^User.BDPHospitalServiceConfigD(ParRef,ChildSub)),2)
                    s:BDPSerConfigType="DL" BDPSerConfigType="按登录"
                    s:BDPSerConfigType="KD" BDPSerConfigType="按开单"
                    s:BDPSerConfigType="JZ" BDPSerConfigType="按就诊"  
                    s:BDPSerConfigType="JS" BDPSerConfigType="按接收"  
                    s BDPSerConfigCurrenHospDR=$listget($g(^User.BDPHospitalServiceConfigD(ParRef,ChildSub)),3) /// 当前医院 
                    if (hospital="")||(BDPSerConfigCurrenHospDR=hospital)
                    {
                        s:BDPSerConfigCurrenHospDR'="" BDPSerConfigCurrenHospDR=$P($g(^CT("HOSP",BDPSerConfigCurrenHospDR)),"^",2)
                        s BDPSerConfigOperateHospDR=$listget($g(^User.BDPHospitalServiceConfigD(ParRef,ChildSub)),4) /// 可操作医院
                        s:BDPSerConfigOperateHospDR'="" BDPSerConfigOperateHospDR=$P($g(^CT("HOSP",BDPSerConfigOperateHospDR)),"^",2)
                        s BDPSerConfigCategory=$listget($g(^User.BDPHospitalServiceConfigD(ParRef,ChildSub)),5)  /// 项目  
                        s:BDPSerConfigCategory="LOC" BDPSerConfigCategory="科室"
                        s:BDPSerConfigCategory="ORD" BDPSerConfigCategory="医嘱项"  
                        s:BDPSerConfigCategory="ORDCAT" BDPSerConfigCategory="医嘱子类"  
                        d OutputRow 
                    }
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ID,BDPSerConfigType,BDPSerConfigCurrenHospDR,BDPSerConfigOperateHospDR,BDPSerConfigCategory)
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
/// Other:      w ##class(web.DHCBL.CT.BDPHospitalServiceConfig).OpenData("1||1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.BDPHospitalServiceConfig).%New()
    s obj = ##class(User.BDPHospitalServiceConfig).%OpenId(id)
    s eobj.ID=id
    s eobj.BDPSerConfigType= obj.BDPSerConfigType
    s eobj.BDPSerConfigCurrenHospDR= obj.BDPSerConfigCurrenHospDRGetObjectId()
    s eobj.BDPSerConfigOperateHospDR= obj.BDPSerConfigOperateHospDRGetObjectId()
    s eobj.BDPSerConfigCategory=obj.BDPSerConfigCategory   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Description 数据重复验证方法，由js调用
/// Creator:    sunfengchao
/// CreatDate:  2021-07-12
/// Table：     User.BDPHospitalServiceConfig
/// Input：     id-rowid, code-代码,desc-描述
/// Return：    "1"(数据重复),"0"(数据不重复)
/// Other:      w ##class(web.DHCBL.CT.BDPHospitalServiceConfig).FormValidate("","","")
ClassMethod FormValidate(id As %String, BDPSerConfigCurrenHospDR As %String, HospitalServiceParRef As %String, BDPSerConfigType As %String, BDPSerConfigOperateHospDR As %String, BDPSerConfigCategory As %String) As %String
{
    s flag=0
    s rowid=""
    //s ^TMProwid3=$lb(id,BDPSerConfigCurrenHospDR,HospitalServiceParRef," "_BDPSerConfigType,BDPSerConfigOperateHospDR," "_BDPSerConfigCategory)
    q:(BDPSerConfigCurrenHospDR="")||(BDPSerConfigCurrenHospDR="")||(HospitalServiceParRef="")||(BDPSerConfigType="")||(BDPSerConfigOperateHospDR="")||(BDPSerConfigCategory="") flag
    s flag=$d(^User.BDPHospitalServiceConfigI("ServiceConfigIdx",BDPSerConfigCurrenHospDR,HospitalServiceParRef," "_BDPSerConfigType,BDPSerConfigOperateHospDR," "_BDPSerConfigCategory))
    if (id="") //如果为空，增加时的重复判断
    {
        if (flag>0) s flag=1  //返回重复标志 
    }
    else //如果不为空，修改时的重复判断
    {
        s idc= $o(^User.BDPHospitalServiceConfigI("ServiceConfigIdx",BDPSerConfigCurrenHospDR,HospitalServiceParRef," "_BDPSerConfigType,BDPSerConfigOperateHospDR," "_BDPSerConfigCategory,0))
        if (idc'="") s rowid=HospitalServiceParRef_"||"_idc
        if ((idc'="")&(rowid'=id)&(flag>0))  s flag=1  //返回重复标志    
    }
    q flag
}

/// Description 保存内容
/// Creator:    sunfengchao
/// CreatDate:  2021-01-12 
/// Table：     User.BDPHospitalServiceConfig
/// Input：     web.Entity.CT.BDPHospitalServiceConfig 实体类
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.BDPHospitalServiceConfig).SaveData(eobj)
ClassMethod SaveData(eobj As web.Entity.CT.BDPHospitalServiceConfig) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        if eobj.BDPSerConfigCategory="" s BDPSerConfigCategory= "-100000000000000"
        else  s BDPSerConfigCategory=eobj.BDPSerConfigCategory 
        if (eobj.ID'="") s eobj.HospitalServiceParRef=$P(eobj.ID,"||",1)
        s flag=..FormValidate(eobj.ID,eobj.BDPSerConfigCurrenHospDR,eobj.HospitalServiceParRef,eobj.BDPSerConfigType,eobj.BDPSerConfigOperateHospDR,BDPSerConfigCategory)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.ID="")  
            {
                s obj=##class(User.BDPHospitalServiceConfig).%New(eobj.HospitalServiceParRef)
                d obj.HospitalServiceParRefSetObjectId(eobj.HospitalServiceParRef)
            }
            else                
            {
                s obj=##class(User.BDPHospitalServiceConfig).%OpenId(eobj.ID)
                s bobj=##class(web.Entity.CT.BDPHospitalServiceConfig).%New()
                s bobj.ID=eobj.ID
                s bobj.BDPSerConfigType=obj.BDPSerConfigType
                s bobj.BDPSerConfigCurrenHospDR = obj.BDPSerConfigCurrenHospDRGetObjectId() 
                s bobj.BDPSerConfigOperateHospDR = obj.BDPSerConfigOperateHospDRGetObjectId() 
                s bobj.BDPSerConfigCategory=obj.BDPSerConfigCategory
            }
            Ts
            s obj.BDPSerConfigType = eobj.BDPSerConfigType
            d obj.BDPSerConfigCurrenHospDRSetObjectId(eobj.BDPSerConfigCurrenHospDR)   
            d obj.BDPSerConfigOperateHospDRSetObjectId(eobj.BDPSerConfigOperateHospDR)  
            s obj.BDPSerConfigCategory=eobj.BDPSerConfigCategory
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" 
                //新增时，日志
                d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_HospitalServiceConfig","User.BDPHospitalServiceConfig","多院区业务配置",id,eobj.BDPSerConfigCurrenHospDR,"A",eobj)
                //修改时，日志
                d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_HospitalServiceConfig","User.BDPHospitalServiceConfig","多院区业务配置",eobj.ID,eobj.BDPSerConfigCurrenHospDR,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("多院区业务配置","web.DHCBL.CT.BDPHospitalServiceConfig","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("多院区业务配置","web.DHCBL.CT.BDPHospitalServiceConfig","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:sunfengchao
/// CreatDate:2014-10-30
/// Description：根据ID删除多院区业务配置的内容
/// Table：User.BDPHospitalServiceConfig
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.BDPHospitalServiceConfig).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""  
    s pobj = ##class(User.BDPHospitalServiceConfig).%OpenId(id)
    s eobj = ##class(web.Entity.CT.BDPHospitalServiceConfig).%New()
    s eobj.ID = id
    s eobj.BDPSerConfigType=pobj.BDPSerConfigType
    s eobj.BDPSerConfigCurrenHospDR=pobj.BDPSerConfigCurrenHospDRGetObjectId()
    s eobj.BDPSerConfigOperateHospDR=pobj.BDPSerConfigOperateHospDRGetObjectId()
    s eobj.BDPSerConfigCategory=pobj.BDPSerConfigCategory
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(User.BDPHospitalServiceConfig).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_HospitalServiceConfig","User.BDPHospitalServiceConfig","多院区业务配置",id,eobj.BDPSerConfigCurrenHospDR,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("多院区业务配置","web.DHCBL.CT.BDPHospitalServiceConfig","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

/// Function:根据配置明细数据 
/// Creator:sunfengchao
/// CreatDate:2021-07-20
/// Other:  w ##class(web.DHCBL.CT.BDPHospitalServiceConfig).GetConfigDetail("1","2")
ClassMethod GetConfigDetail(DetailParRef As %String, Version As %String) As %String
{
    q:(DetailParRef="")||(Version="") ""
    s DetailIDStr="" 
    s DetailChildSub=0
    for 
    {
        s DetailChildSub=$o(^User.BDPHospSerConfigCategoryD(DetailParRef,Version,DetailChildSub))
        q:DetailChildSub="" 
        s ID=DetailParRef_"||"_Version_"||"_DetailChildSub
        s BDPMHOSPCateReference=$listget($g(^User.BDPHospSerConfigCategoryD(DetailParRef,Version,DetailChildSub)),2)
        if (DetailIDStr="") s DetailIDStr=BDPMHOSPCateReference 
        else  s DetailIDStr=DetailIDStr_"!"_BDPMHOSPCateReference  
    }
     q DetailIDStr
}

/// Description:判断能否修改项目 
/// CreatDate:2021-07-30
/// Creator:  sunfengchao 
/// Table：  User.BDPHospitalServiceConfig
/// Return:   1- 配置明细表里已有关联数据 ,不能再修改 配置里的项目字段
///           0- 可修改 配置里的项目字段
/// Other:  w ##class(web.DHCBL.CT.BDPHospitalServiceConfig).GetRefFlag("2")
ClassMethod GetRefFlag(id As %String) As %String
{
  s result=0
  q:id="" result
  s ParRef=$p(id,"||",1)
  s Version=$p(id,"||",2)  
  if $d(^User.BDPHospSerConfigCategoryD(ParRef,Version))  s result=1 
  q result
}

/// Function:根据配置判断当前医院能跨院区处理的数据 
/// Creator:sunfengchao
/// CreatDate:2021-07-20
/// Input：HospitalID:医院ID、ServinceCode:业务代码
/// Output:是否限制（Y/N）、限制类型（按登录DL、按开单KD、按就诊JZ、按接收JS）、可操作医院ID、孙子表类型（科室LOC、医嘱ORD、医嘱子类ORDCAT）、孙子表ID 
///       拼接示例：Y#DL(按登录）^3(可操作医院ID)^LOC（孙子表类型）:1（科室ID）!2（科室ID）!3（科室ID）&.....
/// Other:  w ##class(web.DHCBL.CT.BDPHospitalServiceConfig).GetMultiHospConfig("2","InPatReg")
ClassMethod GetMultiHospConfig(HospitalID As %String, ServinceCode As %String) As %String
{
    q:(HospitalID="")||(ServinceCode="") "N#" 
    s ServinceId=$O(^User.BDPMultiHospitalServiceI("CodeIdx",ServinceCode,0)) 
    q:ServinceId="" "N#"  
    s resultstr=""
    s AutFlag=""  // 是否受限 
    if ('$d(^User.BDPHospitalServiceConfigI("CurrenHospDRIdx",HospitalID,ServinceId)))
    {
         s AutFlag="N"
    }
    else
    {
       s BDPMHOSPServiceType=$listget($g(^User.BDPMultiHospitalServiceD(ServinceId)),4)
       if (BDPMHOSPServiceType="UL") // 服务的类型为 不受限  返回的是 N
       {
          s AutFlag="N"    
       }
       else
       { 
           s AutFlag="Y" 
           s ServinceConfigSub=0
           for
           {
               s ServinceConfigSub=$O(^User.BDPHospitalServiceConfigI("CurrenHospDRIdx",HospitalID,ServinceId,ServinceConfigSub))
               q:ServinceConfigSub=""
               
               s BDPSerConfigType=$listget($g(^User.BDPHospitalServiceConfigD(ServinceId,ServinceConfigSub)),2)  // 限制类型 
               s BDPSerConfigOperateHospDR=$listget($g(^User.BDPHospitalServiceConfigD(ServinceId,ServinceConfigSub)),4) /// 可操作医院
               s BDPSerConfigCategory=$listget($g(^User.BDPHospitalServiceConfigD(ServinceId,ServinceConfigSub)),5)  // 孙子表类型（科室LOC、医嘱ORD、医嘱子类ORDCAT）
               
               s DetailStr=..GetConfigDetail(ServinceId,ServinceConfigSub)
               if (resultstr="")
               {
                   s resultstr=BDPSerConfigType_"^"_BDPSerConfigOperateHospDR_"^"_BDPSerConfigCategory_":"_DetailStr
               }
               else
               {
                   s resultstr= resultstr_"&"_BDPSerConfigType_"^"_BDPSerConfigOperateHospDR_"^"_BDPSerConfigCategory_":"_DetailStr
               }
           }
       }
    }
    q AutFlag_"#"_resultstr
}

}
