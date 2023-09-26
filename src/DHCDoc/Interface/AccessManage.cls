/// Creator:	jm
/// CreatDate:	2023.01.14
/// Description:用于维护第三方厂家及对应使用模块
Class DHCDoc.Interface.AccessManage Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator:	jm
/// CreatDate:	2023.01.14
/// Description:接口厂家-保存
/// Input:		CompanyJson:Json串(rowid+代码+描述)
/// Return:		保存结果(0:成功,其它:失败)
/// Others:		w ##class(DHCDoc.Interface.AccessManage).SaveAccessCompany(^jm("SaveAccessCompany"))
ClassMethod SaveAccessCompany(CompanyJson As %String) As %String
{
	s ^jm("SaveAccessCompany")=CompanyJson
	s $zt="SaveAccessCompanyErr"
	s rtn=0
	TStart
	s CompanyList=[].%FromJSON(CompanyJson)
	for i=1:1:CompanyList.%Size() {
		s CompanyObj=CompanyList.%Get(i-1)
		continue:'$ISObject(CompanyObj)
		s CompanyRowid=CompanyObj.CompanyRowid
		s CompanyDesc=CompanyObj.CompanyDesc
		if (CompanyRowid="") {
		s CompanyCode=..GetCNCODE(CompanyDesc,"10")
		if (CompanyCode="") s CompanyCode=CompanyDesc
		}else{
			s CompanyCode=$lg(^CT.DOC.Interface.AccessCompanyD(CompanyRowid),2)
		}
		if ($ZCVT(CompanyCode,"U")="IMEDICAL") s CompanyCode="iMedical"
		s rtn=..SaveAccessBase(CompanyRowid,CompanyCode,CompanyDesc,"Company")
		Q:rtn'=0
	}
	if (rtn'=0) {
		TRollback
	}else{
		TCommit
	}
	Q rtn
SaveAccessCompanyErr
	s $zt=""
	if ($TLevel>0) TRollback
	Q "保存接入厂家异常:"_$ze
}

/// Creator:	jm
/// CreatDate:	2023.01.14
/// Description:返回汉字的编码信息(方法来源医保组:##class(web.DHCINSUPort).GetCNCODE)
/// Input:		HANZI:汉字
/// 			FLAG:编码类型(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码,6:五笔码,7:区位码,8:笔划数,9:郑码,10:拼音,仅首拼大写)
/// 			SPLIT:分割符(可以为空)
/// Return:		非0:返回对应编码信息,0:未找到编码信息
/// Others:		w ##class(DHCDoc.Interface.AccessManage).GetCNCODE("啊","3","")
ClassMethod GetCNCODE(HANZIS As %String, FLAG As %String, SPLIT As %String = "") As %String
{
	Q:HANZIS="" "0"
	s RtnStr=""
	for i=1:1:$l(HANZIS) {
		s tmpstr=""
		s HANZI=$EXTRACT(HANZIS,i)
		s ASCIICODE=$ASCII(HANZI)
		if ($d(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0) {
			s rowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,0))
			if (FLAG="") {
				s tmpstr=$g(^DHCCharacterEncoding(rowid))
			}elseif (FLAG="10"){
				s tmpstr=$p(^DHCCharacterEncoding(rowid),"^",3)
				if (tmpstr="") s tmpstr=$p(^DHCCharacterEncoding(rowid),"^",4)
				s tmpstr=$e(tmpstr,1,1)_$ZCVT($e(tmpstr,2,$l(tmpstr)),"L")
			}else{
				s tmpstr=$p(^DHCCharacterEncoding(rowid),"^",FLAG)
			}
		}else{
			s tmpstr="?"
		}
		if (RtnStr="") s RtnStr=tmpstr
		else  s RtnStr=RtnStr_SPLIT_tmpstr
	}
	Q RtnStr
}

/// Creator:	jm
/// CreatDate:	2023.01.14
/// Description:接口模块-保存
/// Input:		ModuleJson:Json串(rowid+代码+描述)
/// Return:		保存结果(0:成功,其它:失败)
/// Others:		w ##class(DHCDoc.Interface.AccessManage).SaveAccessModule(^jm("SaveAccessCompany"))
ClassMethod SaveAccessModule(ModuleJson As %String) As %String
{
	s ^jm("SaveAccessModule")=ModuleJson
	s $zt="SaveAccessModuleErr"
	s rtn=0
	TStart
	s ModuleList=[].%FromJSON(ModuleJson)
	for i=1:1:ModuleList.%Size() {
		s ModuleObj=ModuleList.%Get(i-1)
		continue:'$ISObject(ModuleObj)
		s ModuleRowid=ModuleObj.ModuleRowid
		s ModuleCode=ModuleObj.ModuleCode
		s ModuleDesc=ModuleObj.ModuleDesc
		s rtn=..SaveAccessBase(ModuleRowid,ModuleCode,ModuleDesc,"Module")
		Q:rtn'=0
	}
	if (rtn'=0) {
		TRollback
	}else{
		TCommit
	}
	Q rtn
SaveAccessModuleErr
	s $zt=""
	if ($TLevel>0) TRollback
	Q "保存接入模块异常:"_$ze
}

/// Creator:	jm
/// CreatDate:	2023.02.09
/// Description:接口业务域-保存
/// Input:		ProductJson:Json串(rowid+代码+描述+引用JS)
/// Return:		保存结果(0:成功,其它:失败)
/// Others:		w ##class(DHCDoc.Interface.AccessManage).SaveAccessProduct(^jm("SaveAccessProduct"))
ClassMethod SaveAccessProduct(ProductJson As %String) As %String
{
	s ^jm("SaveAccessProduct")=ProductJson
	s $zt="SaveAccessProductErr"
	s rtn=0
	TStart
	s ProductList=[].%FromJSON(ProductJson)
	for i=1:1:ProductList.%Size() {
		s ProductObj=ProductList.%Get(i-1)
		continue:'$ISObject(ProductObj)
		s ProductRowid=ProductObj.ProductRowid
		s ProductCode=ProductObj.ProductCode
		s ProductDesc=ProductObj.ProductDesc
		s ReferenceJS=ProductObj.ReferenceJS
		s rtn=..SaveAccessBase(ProductRowid,ProductCode,ProductDesc,"Product",ReferenceJS)
		Q:rtn'=0
	}
	if (rtn'=0) {
		TRollback
	}else{
		TCommit
	}
	Q rtn
SaveAccessProductErr
	s $zt=""
	if ($TLevel>0) TRollback
	Q "保存接入业务域异常:"_$ze
}

/// Creator:	jm
/// CreatDate:	2023.01.14
/// Description:接口厂家、接口模块、接口业务域-保存
/// Input:		BaseRowid:id  BaseCode:代码  BaseDesc:描述  BaseType:类型(Company:厂家,Module:模块)
/// Return:		保存结果(0:成功,其它:失败)
/// Others:		w ##class(DHCDoc.Interface.AccessManage).SaveAccessBase("1","1","1","Company")
ClassMethod SaveAccessBase(BaseRowid As %String, BaseCode As %String, BaseDesc As %String, BaseType As %String, ReferenceJS As %String = "") As %String
{
	s ^jm("SaveAccessBase")=$lb(BaseRowid,BaseCode,BaseDesc,BaseType,ReferenceJS)
	k PLIST
	s PLIST(2)=BaseCode
	s PLIST(3)=BaseDesc
	s PLIST(4)=..%SysDate()
	if (BaseType="Company") {
		s rowid=$o(^CT.DOC.Interface.AccessCompanyI("IdxCode",BaseCode,0))
	}elseif (BaseType="Module") {
		s rowid=$o(^CT.DOC.Interface.AccessModuleI("IdxCode",BaseCode,0))
	}elseif (BaseType="Product") {
		s rowid=$o(^CT.DOC.Interface.AccessProductI("IdxCode",BaseCode,0))
	}
	if ($g(rowid)'="") {
		Q:BaseRowid="" "数据重复"
		Q:(BaseRowid'="")&&(BaseRowid'=rowid) "数据重复"
	}
	if (BaseType="Company") {
		if (BaseRowid="") {
			&SQL(INSERT INTO CT_DOC_Interface.AccessCompany VALUES :PLIST())
		}else{
			&SQL(UPDATE CT_DOC_Interface.AccessCompany VALUES :PLIST() WHERE %Id=:BaseRowid)
		}
	}elseif (BaseType="Module") {
		if (BaseRowid="") {
			&SQL(INSERT INTO CT_DOC_Interface.AccessModule VALUES :PLIST())
		}else{
			&SQL(UPDATE CT_DOC_Interface.AccessModule VALUES :PLIST() WHERE %Id=:BaseRowid)
		}
	}elseif (BaseType="Product") {
		s PLIST(6)=ReferenceJS
		if (BaseRowid="") {
			&SQL(INSERT INTO CT_DOC_Interface.AccessProduct VALUES :PLIST())
		}else{
			&SQL(UPDATE CT_DOC_Interface.AccessProduct VALUES :PLIST() WHERE %Id=:BaseRowid)
		}
	}
	Q SQLCODE
}

/// Creator:	jm
/// CreatDate:	2023.01.17
/// Description:接口厂家、接口模块-删除
/// Input:		BaseRowid:rowid  BaseType:类型(Company:厂家,Module:模块)
/// Return:		删除结果(0:成功,其它:失败)
/// Others:		w ##class(DHCDoc.Interface.AccessManage).DeleteAccessBase("1","Company")
ClassMethod DeleteAccessBase(BaseRowid As %String, BaseType As %String) As %String
{
	s ^jm("DeleteAccessBase")=$lb(BaseRowid,BaseType)
	TStart
	s rtn=0
	if (BaseType="Company") {
		&SQL(DELETE FROM CF_DOC_Interface.AccessManage WHERE AM_Company_DR=:BaseRowid)
		s rtn=SQLCODE
	}elseif (BaseType="Module") {
		&SQL(DELETE FROM CF_DOC_Interface.AccessManage WHERE AM_Module_DR=:BaseRowid)
		s rtn=SQLCODE
	}elseif (BaseType="Product") {
		s LinkRowid=0 for {
			s LinkRowid=$o(^CF.DOC.Interface.AccessManageD(LinkRowid))
			Q:LinkRowid=""
			continue:+LinkRowid=0
			s ProductDomain=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),5)
			continue:ProductDomain=""
			s ProductDomainNew=""
	    	for i=1:1:$l(ProductDomain,"!") {
		    	s ProductDomainDr=$p(ProductDomain,"!",i)
		    	continue:ProductDomainDr=BaseRowid
		    	if (ProductDomainNew="") s ProductDomainNew=ProductDomainDr
		    	else  s ProductDomainNew=ProductDomainNew_"!"_ProductDomainDr
	    	}
			&SQL(UPDATE CF_DOC_Interface.AccessManage Set AM_ProductDomain=:ProductDomainNew WHERE %Id=:LinkRowid)
			s rtn=rtn+SQLCODE
		}
	}
	if (rtn=100) s rtn=0
	if (rtn) {
		TRollback
		Q "删除关联数据失败:"_$g(%msg)
	}
	if (BaseType="Company") {
		&SQL(DELETE FROM CT_DOC_Interface.AccessCompany WHERE %Id=:BaseRowid)
	}elseif (BaseType="Module") {
		&SQL(DELETE FROM CT_DOC_Interface.AccessModule WHERE %Id=:BaseRowid)
	}elseif (BaseType="Product") {
		&SQL(DELETE FROM CT_DOC_Interface.AccessProduct WHERE %Id=:BaseRowid)
	}
	if (SQLCODE) {
		TRollback
		Q "删除数据失败:"_$g(%msg)
	}
	TCommit
	Q 0
}

/// Creator:	jm
/// CreatDate:	2023.01.14
/// Description:获取接口厂家、接口模块数据
/// Input:		BaseType:类型(Company:厂家,Module:模块)
/// Return:		id+代码+描述
/// Others:		d ##class(%ResultSet).RunQuery("DHCDoc.Interface.AccessManage","QryAccessBase","Company")
Query QryAccessBase(BaseType As %String) As websys.Query(ROWSPEC = "BaseRowid:%String,BaseCode:%String,BaseDesc:%String,ReferenceJS:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.AccessManage","QryAccessBase","Product")
ClassMethod QryAccessBaseExecute(ByRef qHandle As %Binary, BaseType As %String) As %Status
{
	s ^jm("QryData")=$lb(BaseType)
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    ;
    if (BaseType="Company") {
	    s BaseRowid="" for {
			s BaseRowid=$o(^CT.DOC.Interface.AccessCompanyD(BaseRowid),-1)
			Q:BaseRowid=""
			s StDate=$lg(^CT.DOC.Interface.AccessCompanyD(BaseRowid),4)
			continue:(StDate'="")&&(StDate>+$h)
			s EndDate=$lg(^CT.DOC.Interface.AccessCompanyD(BaseRowid),5)
			continue:(EndDate'="")&&(EndDate<+$h)
			s BaseCode=$lg(^CT.DOC.Interface.AccessCompanyD(BaseRowid),2)
			s BaseDesc=$lg(^CT.DOC.Interface.AccessCompanyD(BaseRowid),3)
			d OutputQryAccessBase
	    }
    }elseif (BaseType="Module") {
	    s BaseRowid="" for {
			s BaseRowid=$o(^CT.DOC.Interface.AccessModuleD(BaseRowid),-1)
			Q:BaseRowid=""
			s StDate=$lg(^CT.DOC.Interface.AccessModuleD(BaseRowid),4)
			continue:(StDate'="")&&(StDate>+$h)
			s EndDate=$lg(^CT.DOC.Interface.AccessModuleD(BaseRowid),5)
			continue:(EndDate'="")&&(EndDate<+$h)
			s BaseCode=$lg(^CT.DOC.Interface.AccessModuleD(BaseRowid),2)
			s BaseDesc=$lg(^CT.DOC.Interface.AccessModuleD(BaseRowid),3)
			d OutputQryAccessBase
	    }
    }elseif (BaseType="Product") {
	    s BaseRowid="" for {
			s BaseRowid=$o(^CT.DOC.Interface.AccessProductD(BaseRowid),-1)
			Q:BaseRowid=""
			s StDate=$lg(^CT.DOC.Interface.AccessProductD(BaseRowid),4)
			continue:(StDate'="")&&(StDate>+$h)
			s EndDate=$lg(^CT.DOC.Interface.AccessProductD(BaseRowid),5)
			continue:(EndDate'="")&&(EndDate<+$h)
			s BaseCode=$lg(^CT.DOC.Interface.AccessProductD(BaseRowid),2)
			s BaseDesc=$lg(^CT.DOC.Interface.AccessProductD(BaseRowid),3)
			s ReferenceJS=$lg(^CT.DOC.Interface.AccessProductD(BaseRowid),6)
			d OutputQryAccessBase
	    }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputQryAccessBase
    s Data=$lb(BaseRowid,BaseCode,BaseDesc,$g(ReferenceJS))
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creator:	jm
/// CreatDate:	2023.01.17
/// Description:保存厂家模块关联数据
/// Input:		InputJson:Json串(厂家id+模块id+后台类文件+是否启用+院区id+用户id)
/// Return:		保存结果(0:成功,其它:失败)
/// Others:		w ##class(DHCDoc.Interface.AccessManage).SaveAccessLink(^jm("SaveAccessLink"))
ClassMethod SaveAccessLink(InputJson As %String) As %String
{
	s ^jm("SaveAccessLink")=InputJson
	s $zt="SaveAccessLinkErr"
	s rtn=0,OtherInfo=""
	TStart
	s InputList=[].%FromJSON(InputJson)
	for i=1:1:InputList.%Size() {
		s InputObj=InputList.%Get(i-1)
		continue:'$ISObject(InputObj)
		s CompanyDR=InputObj.CompanyRowid
		s ModuleDR=InputObj.ModuleRowid
		s HospitalDR=InputObj.HospitalId
		s ActiveFlag=InputObj.ActiveFlag
		k PLIST
		s PLIST(2)=CompanyDR
		s PLIST(3)=ModuleDR
		//s PLIST(4)=InputObj.LinkClass
		s PLIST(5)=InputObj.ProductDomain
		s PLIST(7)=ActiveFlag
		s PLIST(8)=HospitalDR
		s PLIST(9)=..%SysDate()
		s PLIST(10)=..%SysTime()
		s PLIST(11)=InputObj.UserID
		s PLIST(12)=InputObj.ReferenceJS
		;
		s CompanyDesc=$lg(^CT.DOC.Interface.AccessCompanyD(CompanyDR),3)
		s ModuleDesc=$lg(^CT.DOC.Interface.AccessModuleD(ModuleDR),3)
		s LinkRowid=$o(^CF.DOC.Interface.AccessManageI("IdxLink",CompanyDR,ModuleDR,HospitalDR,0))
		b ;LinkRowid
		if (LinkRowid="") {
			;当前模块如果存在扩展数据,启用标志置为否,并自动生成扩展数据
			s ModuleExtStr=$lg(^CT.DOC.Interface.AccessModuleD(ModuleDR),6)
			if (ModuleExtStr'="") {
				s PLIST(7)="N"
				;保存关联数据表
				&SQL(INSERT INTO CF_DOC_Interface.AccessManage VALUES :PLIST())
				s rtn=rtn+SQLCODE
				if (rtn=0) {
					;保存关联扩展表
					s LinkRowid=$p(%ROWID,$c(1))
					s saveExtFlag=..SaveAccessLinkExt(LinkRowid,ModuleExtStr)
					if ((saveExtFlag=0)&&(ActiveFlag="Y")) {
						;组织提示信息
						if (OtherInfo="") s OtherInfo=CompanyDesc_ModuleDesc_"存在模块级扩展数据,请在扩展设定界面维护完对应数据(没有可填入空格)后再启用"
						else  s OtherInfo=OtherInfo_"<br>"_CompanyDesc_ModuleDesc_"存在模块级扩展数据,请在扩展设定界面维护完对应数据(没有可填入空格)后再启用"
					}
					s rtn=rtn+saveExtFlag
				}
			}else{
				&SQL(INSERT INTO CF_DOC_Interface.AccessManage VALUES :PLIST())
				s rtn=rtn+SQLCODE
			}
		}else{
			;启用时,判断扩展设定的模块级数据是否为空
			if (ActiveFlag="Y") {
				s ChildSub=0 for {
					s ChildSub=$o(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub))
					Q:ChildSub=""
					s ExtModuleFlag=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub),5)
					continue:ExtModuleFlag'="Y"
					s ExtValue=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub),4)
					if (ExtValue="") {
						s rtn=CompanyDesc_ModuleDesc_"存在未填写的模块级扩展数据,请在扩展设定界面维护完对应数据(没有可填入空格)后再启用"
					}
					Q:rtn'=0
			    }
				Q:rtn'=0
				&SQL(UPDATE CF_DOC_Interface.AccessManage VALUES :PLIST() WHERE %Id=:LinkRowid)
				s rtn=rtn+SQLCODE
			}else{
				&SQL(UPDATE CF_DOC_Interface.AccessManage VALUES :PLIST() WHERE %Id=:LinkRowid)
				s rtn=rtn+SQLCODE
			}
		}
		Q:rtn'=0
	}
	b ;rtn
	if (rtn'=0) {
		TRollback
		Q "-1"_"^"_"保存关联数据失败:"_rtn
	}
	TCommit
	Q "0"_"^"_OtherInfo
SaveAccessLinkErr
	s $zt=""
	if ($TLevel>0) TRollback
	Q "保存关联数据异常:"_$ze
}

/// Creator:	jm
/// CreatDate:	2023.01.17
/// Description:获取厂家模块关联数据(循环基础表)
/// Input:		SearchType:类型(Module:查询厂家关联的模块数据;Company:查询模块关联的厂家数据)
/// 			SearchValue:类型为Module的时候,传入厂家id;类型为Company的时候,传入模块id
/// 			HospitalId:院区id
/// Return:		厂家id+厂家代码+厂家描述+模块id+模块代码+模块描述+关联id+后台类文件+产品域+产品域描述+授权科室+是否启用
/// Others:		d ##class(%ResultSet).RunQuery("DHCDoc.Interface.AccessManage","QryAccessLink","Company","58||3","2")
Query QryAccessLink(SearchType As %String, SearchValue As %String, HospitalId As %String) As websys.Query(ROWSPEC = "CompanyRowid:%String,CompanyCode:%String,CompanyDesc:%String,ModuleRowid:%String,ModuleCode:%String,ModuleDesc:%String,LinkRowid:%String,LinkClass:%String,ProductDomain:%String,ProductDomainStr:%String,AuthLocStr:%String,ActiveFlag:%String,ReferenceJS:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.AccessManage","QryAccessLink","Module","36","2")
ClassMethod QryAccessLinkExecute(ByRef qHandle As %Binary, SearchType As %String, SearchValue As %String, HospitalId As %String) As %Status
{
	s ^jm("QryAccessLink")=$lb(SearchType,SearchValue,HospitalId)
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
    ;
    s rset=##class(%ResultSet).%New("DHCDoc.Interface.AccessManage:QryAccessBase")
	d rset.Execute(SearchType)
    while (rset.Next()) {
	    s (CompanyRowid,CompanyCode,CompanyDesc,ModuleRowid,ModuleCode,ModuleDesc,LinkRowid)=""
	    if (SearchType="Module") {
		    s ModuleRowid=rset.Data("BaseRowid")
		    s ModuleCode=rset.Data("BaseCode")
		    s ModuleDesc=rset.Data("BaseDesc")
		    s CompanyRowid=SearchValue
		    if (CompanyRowid'="") {
			    s CompanyCode=$lg(^CT.DOC.Interface.AccessCompanyD(CompanyRowid),2)
				s CompanyDesc=$lg(^CT.DOC.Interface.AccessCompanyD(CompanyRowid),3)
				s LinkRowid=$o(^CF.DOC.Interface.AccessManageI("IdxLink",CompanyRowid,ModuleRowid,HospitalId,0))
		    }
	    }elseif (SearchType="Company") {
		    s CompanyRowid=rset.Data("BaseRowid")
		    s CompanyCode=rset.Data("BaseCode")
		    s CompanyDesc=rset.Data("BaseDesc")
			s ModuleRowid=SearchValue
		    if (ModuleRowid'="") {
			    s ModuleCode=$lg(^CT.DOC.Interface.AccessModuleD(ModuleRowid),2)
				s ModuleDesc=$lg(^CT.DOC.Interface.AccessModuleD(ModuleRowid),3)
				s LinkRowid=$o(^CF.DOC.Interface.AccessManageI("IdxLink",CompanyRowid,ModuleRowid,HospitalId,0))
		    }
		}
    	s (LinkClass,ProductDomain,ProductDomainStr,AuthLocStr,ActiveFlag,ReferenceJS)=""
    	if (LinkRowid'="") {
	    	s LinkClass=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),4)
	    	s ProductDomain=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),5)
	    	if (ProductDomain'="") {
		    	for j=1:1:$l(ProductDomain,"!") {
			    	s ProductDomainDr=$p(ProductDomain,"!",j)
			    	s ProductDomainDesc=$lg(^CT.DOC.Interface.AccessProductD(ProductDomainDr),3)
			    	if (ProductDomainStr="") s ProductDomainStr=ProductDomainDesc
			    	else  s ProductDomainStr=ProductDomainStr_","_ProductDomainDesc
		    	}
	    	}
	    	s obj=##class(CF.DOC.Interface.AccessManage).%OpenId(LinkRowid)
			if ($ISObject(obj)){
				s AMAuthLocStr=obj.AMAuthLocStr
				s key=""
				while ((AMAuthLocStr'="")&&(AMAuthLocStr.GetNext(.key))) {
					s AuthLocDr=AMAuthLocStr.GetAt(key)
					continue:AuthLocDr=""
					if (AuthLocStr="") s AuthLocStr=AuthLocDr
					else  s AuthLocStr=AuthLocStr_"!"_AuthLocDr
				}
			}
			s ActiveFlag=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),7)
			s ReferenceJS=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),12)
    	}
    	d OutputQryAccessLink
	}
    Quit $$$OK
OutputQryAccessLink
    s Data=$lb(CompanyRowid,CompanyCode,CompanyDesc,ModuleRowid,ModuleCode,ModuleDesc,LinkRowid,LinkClass,ProductDomain,ProductDomainStr,AuthLocStr,ActiveFlag,ReferenceJS)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creator:	jm
/// CreatDate:	2023.01.18
/// Description:获取厂家模块关联数据(仅有效)
/// Input:		SearchType:类型(Module:查询厂家关联的模块数据;Company:查询模块关联的厂家数据)
/// 			SearchCode:类型为Module的时候,传入厂家代码;类型为Company的时候,传入模块代码;ALL:查询全部
/// 			HospitalId:院区id  ProductDomain:产品域  LocId:科室id
/// Return:		id+代码+描述+后台类文件
/// Others:		w ##class(DHCDoc.Interface.AccessManage).GetAccessLinkInfo("Company","ALL","2","Diag")
ClassMethod GetAccessLinkInfo(SearchType As %String, SearchCode As %String, HospitalId As %String, ProductDomain As %String, LocId As %String = "", TypeValue As %String = "") As %String
{
	s LinkList=[]
    s rset=##class(%ResultSet).%New("DHCDoc.Interface.AccessManage:QryAccessBase")
	d rset.Execute(SearchType)
    while (rset.Next()) {
		s BaseRowid=rset.Data("BaseRowid")
		s BaseCode=rset.Data("BaseCode")
		if (SearchType="Module") {
			s LinkRowid=0 for {
				s LinkRowid=$o(^CF.DOC.Interface.AccessManageI("IdxModule",BaseRowid,LinkRowid))
				Q:LinkRowid=""
				continue:(TypeValue'="")&&(TypeValue'=BaseCode)
				s CompanyDR=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),2)
				s CompanyCode=$lg(^CT.DOC.Interface.AccessCompanyD(CompanyDR),2)
				continue:(SearchCode'="")&&(SearchCode'="ALL")&&(SearchCode'=CompanyCode)
				;此处进行排序
				s checkNum="999"
				if (ProductDomain'="") {
					s ProductDr=$o(^CT.DOC.Interface.AccessProductI("IdxCode",ProductDomain,0))
					if (ProductDr'="") {
						s ProductDesc=$lg(^CT.DOC.Interface.AccessProductD(ProductDr),3)
						s checkNum=##class(web.DHCBL.BDP.BDPSort).GetSortNum("CF.DOC.Interface.AccessManage",ProductDesc,LinkRowid)
						if (checkNum="") s checkNum="999"
					}
				}
				s checkNum=$e("000",1,3-$l(checkNum))_checkNum
				s LinkInfoArr(checkNum_"!"_LinkRowid)=LinkRowid
			}
		}elseif (SearchType="Company") {
			s LinkRowid=0 for {
				s LinkRowid=$o(^CF.DOC.Interface.AccessManageI("IdxCompany",BaseRowid,LinkRowid))
				Q:LinkRowid=""
				continue:(TypeValue'="")&&(TypeValue'=BaseCode)
				s ModuleDR=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),3)
				s ModuleCode=$lg(^CT.DOC.Interface.AccessModuleD(ModuleDR),2)
				continue:(SearchCode'="")&&(SearchCode'="ALL")&&(SearchCode'=ModuleCode)
				;此处进行排序
				s checkNum="999"
				if (ProductDomain'="") {
					s ProductDr=$o(^CT.DOC.Interface.AccessProductI("IdxCode",ProductDomain,0))
					if (ProductDr'="") {
						s ProductDesc=$lg(^CT.DOC.Interface.AccessProductD(ProductDr),3)
						s checkNum=##class(web.DHCBL.BDP.BDPSort).GetSortNum("CF.DOC.Interface.AccessManage",ProductDesc,LinkRowid)
						if (checkNum="") s checkNum="999"
					}
				}
				s checkNum=$e("000",1,3-$l(checkNum))_checkNum
				s LinkInfoArr(checkNum_"!"_LinkRowid)=LinkRowid
			}
		}
	}
	s checkSort=0 for {
	    s checkSort=$o(LinkInfoArr(checkSort))
	    Q:checkSort=""
	    s LinkRowid=$g(LinkInfoArr(checkSort))
    	d GetData
    }
	Q LinkList.%ToJSON()
GetData
	s ActiveFlag=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),7)
	Q:ActiveFlag'="Y"
	s LinkProductDomainStr=""
	s LinkProductDomain=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),5)
	for m=1:1:$l(LinkProductDomain,"!") {
		s LinkProductDr=$p(LinkProductDomain,"!",m)
		continue:LinkProductDr=""
		s LinkProductCode=$lg(^CT.DOC.Interface.AccessProductD(LinkProductDr),2)
		if (LinkProductDomainStr="") s LinkProductDomainStr=LinkProductCode
		else  s LinkProductDomainStr=LinkProductDomainStr_","_LinkProductCode
	}
	Q:(ProductDomain'="")&&((","_LinkProductDomainStr_",")'[(","_ProductDomain_","))
	s LinkHospitalId=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),8)
	Q:HospitalId'=LinkHospitalId
	s LocOpenFlag="N",key=""
	s LinkObj=##class(CF.DOC.Interface.AccessManage).%OpenId(LinkRowid)
	while ((LinkObj.AMAuthLocStr)&&(LinkObj.AMAuthLocStr.GetNext(.key))&&(LocOpenFlag'="Y")) {
		s AuthLocId=LinkObj.AMAuthLocStr.GetAt(key)
		if (LocId'="")&&(LocId=AuthLocId) s LocOpenFlag="Y"
	}
	if (LocId="")||(LinkObj.AMAuthLocStr.Count()=0) s LocOpenFlag="Y"
	Q:LocOpenFlag'="Y"
	s CompanyDR=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),2)
	s ModuleDR=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),3)
	;关联数据
	s LinkObj={}
	s LinkObj.CompanyRowid=CompanyDR
	s LinkObj.CompanyCode=$lg(^CT.DOC.Interface.AccessCompanyD(CompanyDR),2)
	s LinkObj.CompanyDesc=$lg(^CT.DOC.Interface.AccessCompanyD(CompanyDR),3)
	s LinkObj.ModuleRowid=ModuleDR
	s LinkObj.ModuleCode=$lg(^CT.DOC.Interface.AccessModuleD(ModuleDR),2)
	s LinkObj.ModuleDesc=$lg(^CT.DOC.Interface.AccessModuleD(ModuleDR),3)
	s LinkObj.ReferenceJS=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),12)
	;扩展数据
	s ExtList=[]
	s ChildSub=0 for {
		s ChildSub=$o(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub))
		Q:ChildSub=""
		s ExtObj={}
		s ExtObj.ExtRowid=LinkRowid_"||"_ChildSub
		s ExtObj.ExtCode=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub),2)
		s ExtObj.ExtDesc=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub),3)
		s ExtObj.ExtValue=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub),4)
		d ExtList.%Push(ExtObj)
    }
    s LinkObj.ExtList=ExtList
	d LinkList.%Push(LinkObj)
}

/// Creator:	jm
/// CreatDate:	2023.01.18
/// Description:厂家模块关联-科室授权
/// Input:		LinkRowid:关联id LocList:科室id串
/// Return:		保存结果(0:成功,其它:失败)
/// Others:		w ##class(DHCDoc.Interface.AccessManage).SaveAccessCompany(^jm("SaveAccessCompany"))
ClassMethod UpdateAuthLocStr(LinkRowid As %String, LocList As %String) As %String
{
	s LinkObj=##class(CF.DOC.Interface.AccessManage).%OpenId(LinkRowid)
	if ('$ISObject(LinkObj)){
		Q "未找到关联数据"
	}
	d LinkObj.AMAuthLocStr.Clear()
	for i=1:1:$l(LocList,"!") {
		s LocId=$p(LocList,"!",i)
		continue:LocId=""
		d LinkObj.AMAuthLocStr.Insert(LocId)
	}
	s sc=LinkObj.%Save()
	if ($$$ISERR(sc)){
		Q "保存授权数据失败:"_$g(%msg)
	}
	Q 0
}

/// Creator:	jm
/// CreatDate:	2023.01.31
/// Description:业务界面(诊断录入,医嘱录入,中草药录入)初始化的时候引入JS
/// Input:		SessionStr:用户id^安全组id^科室id^院区id(参照:##class(DHCDoc.Util.RegisteredObject).%SessionStr())
/// 			ProductDomain:业务域(多个以 ! 分割)
/// 			medStepCode:诊疗环境代码(Reg:挂号,Diag:诊断,Order:开方,Disp:取药,Exam:检查,Opera:手术,Bill:收费,Other:其他)
/// Return:		
/// Others:		d ##class(DHCDoc.Interface.AccessManage).LoadJS("18881^28^60^2","Diag","")
ClassMethod LoadJS(SessionStr As %String, ProductDomain As %String, medStepCode As %String = "") As %String
{
	s ^jm("LoadJS")=$lb(SessionStr,ProductDomain,medStepCode)
	s LocId=$p(SessionStr,"^",3)
	s HospitalId=$p(SessionStr,"^",4)
	for k=1:1:$l(ProductDomain,"!") {
		s OneProduct=$p(ProductDomain,"!",k)
		continue:OneProduct=""
		;引入中间层,不一定里面都是第三方的内容
		s AccessProductDr=$o(^CT.DOC.Interface.AccessProductI("IdxCode",OneProduct,0))
		if (AccessProductDr'="") {
			s ReferenceJS=$lg(^CT.DOC.Interface.AccessProductD(AccessProductDr),6)
			s ReferenceJS=$replace(ReferenceJS,"""medStepCode""",medStepCode)
			d OutputJS(ReferenceJS)
		}
		;引入接口层
		s LinkInfo=##class(DHCDoc.Interface.AccessManage).GetAccessLinkInfo("Company","ALL",HospitalId,OneProduct,LocId)
		continue:LinkInfo=""
		s LinkList=[].%FromJSON(LinkInfo)
		for i=1:1:LinkList.%Size() {
			s LinkObj=LinkList.%Get(i-1)
			continue:'$ISObject(LinkObj)
			w "<script type='text/javascript' src='../scripts/dhcdoc/interface/"_LinkObj.CompanyCode_"/"_LinkObj.ModuleCode_".js'></script>",!
			;需引入JS
			s ReferenceJS=LinkObj.ReferenceJS
			for j=1:1:$l(ReferenceJS,",") {
				s OneJS=$p(ReferenceJS,",",j)
				d OutputJS(OneJS)
			}
		}
	}
	Q 0
OutputJS(FileName)
	Q:FileName=""
	s FileNameC=$ZCVT(FileName,"L")
	if ((FileNameC'["imedical/web")&&(FileNameC'["http")&&(FileName'["../")) {
		s FileName="../"_FileName
	}
	if ((FileNameC[".js")||(FileNameC["text/javascript")) {
		if (FileNameC["src=") w "<script "_FileName_"></script>",!
		else  w "<script type='text/javascript' src='"_FileName_"'></script>",!
	}elseif ((FileNameC[".css")||(FileNameC["stylesheet")) {
		if (FileNameC["href=") w "<link"_FileName_"></link>",!
		else  w "<link rel='stylesheet' href='"_FileName_"'></link>",!
	}
	Q
}

/// Creator:	jm
/// CreatDate:	2023.01.19
/// Description:关联扩展-保存
/// Input:		LinkRowid:关联id  ExtJson:Json串(rowid+代码+描述+值)
/// Return:		保存结果(0:成功,其它:失败)
/// Others:		w ##class(DHCDoc.Interface.AccessManage).SaveAccessLinkExt(^jm("SaveAccessLinkExt"))
ClassMethod SaveAccessLinkExt(LinkRowid As %String, ExtJson As %String) As %String
{
	s ^jm("SaveAccessLinkExt")=ExtJson
	s $zt="SaveAccessLinkExtErr"
	s rtn=0
	TStart
	s ExtList=[].%FromJSON(ExtJson)
	for ExtNo=1:1:ExtList.%Size() {
		s ExtObj=ExtList.%Get(ExtNo-1)
		continue:'$ISObject(ExtObj)
		s ExtRowid=ExtObj.ExtRowid
		s ExtCode=ExtObj.ExtCode
		;判断重复
		s sub=$o(^CF.DOC.Interface.AccessManageI("Ext","IdxCode",ExtCode,LinkRowid,0))
		if (sub'="") {
			s rowid=LinkRowid_"||"_sub
			if (ExtRowid="") s rtn="数据重复"
			if ((ExtRowid'="")&&(ExtRowid'=rowid)) s rtn="数据重复"
		}
		Q:rtn'=0
		;插入数据
		k PLIST
		s PLIST(0)=LinkRowid
		s PLIST(2)=ExtCode
		s PLIST(3)=ExtObj.ExtDesc
		s PLIST(4)=ExtObj.ExtValue
		s PLIST(5)=ExtObj.ExtModuleFlag
		if (ExtRowid="") {
			&SQL(INSERT INTO CF_DOC_Interface.AccessManageExt VALUES :PLIST())
			s ExtRowid=$p(%ROWID,$c(1))
		}else{
			&SQL(UPDATE CF_DOC_Interface.AccessManageExt VALUES :PLIST() WHERE %Id=:ExtRowid)
		}
		s rtn=rtn+SQLCODE
		if (rtn'=0) {
			s rtn="保存扩展数据失败:"_rtn
			Quit
		}
		;模块级扩展数据需要保存到模块表中
		s rtn=##class(DHCDoc.Interface.AccessManage).UpdateModuleExtStr(ExtRowid)
		if (rtn'=0) {
			s rtn="保存模块级扩展数据失败:"_rtn
			Quit
		}
	}
	if (rtn'=0) {
		TRollback
	}else{
		TCommit
	}
	Q rtn
SaveAccessLinkExtErr
	s $zt=""
	if ($TLevel>0) TRollback
	Q "保存接入模块异常:"_$ze
}

/// Creator:	jm
/// CreatDate:	2023.01.19
/// Description:关联扩展-删除
/// Input:		ExtRowid:rowid
/// Return:		删除结果(0:成功,其它:失败)
/// Others:		w ##class(DHCDoc.Interface.AccessManage).DeleteAccessBase("1")
ClassMethod DeleteAccessLinkExt(ExtRowid As %String) As %String
{
	s ^jm("DeleteAccessLinkExt")=ExtRowid
	&SQL(DELETE FROM CF_DOC_Interface.AccessManageExt WHERE %Id=:ExtRowid)
	Q SQLCODE
}

/// Creator:	jm
/// CreatDate:	2023.01.14
/// Description:获取关联扩展设定数据
/// Input:		LinkRowid:关联id
/// Return:		id+代码+描述+值
/// Others:		d ##class(%ResultSet).RunQuery("DHCDoc.Interface.AccessManage","QryAccessLinkExt","1")
Query QryAccessLinkExt(LinkRowid As %String) As websys.Query(ROWSPEC = "ExtRowid:%String,ExtCode:%String,ExtDesc:%String,ExtValue:%String,ExtModuleFlag:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.AccessManage","QryAccessLinkExt","2")
ClassMethod QryAccessLinkExtExecute(ByRef qHandle As %Binary, LinkRowid As %String) As %Status
{
	s ^jm("QryAccessLinkExt")=LinkRowid
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    ;
    s ChildSub="" for {
		s ChildSub=$o(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub),-1)
		Q:ChildSub=""
		s ExtRowid=LinkRowid_"||"_ChildSub
		s ExtCode=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub),2)
		s ExtDesc=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub),3)
		s ExtValue=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub),4)
		s ExtModuleFlag=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid,"Ext",ChildSub),5)
		d OutputQryAccessLinkExt
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputQryAccessLinkExt
    s Data=$lb(ExtRowid,ExtCode,ExtDesc,ExtValue,ExtModuleFlag)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creator:	jm
/// CreatDate:	2023.02.15
/// Description:模块表-模块级扩展数据更新
/// Input:		LinkRowid:关联id LocList:科室id串
/// Return:		保存结果(0:成功,其它:失败)
/// Others:		w ##class(DHCDoc.Interface.AccessManage).UpdateModuleExtStr("")
ClassMethod UpdateModuleExtStr(ExtRowid As %String) As %String
{
	s ^jm("UpdateModuleExtStr")=ExtRowid
	s ExtModuleFlag=$lg(^CF.DOC.Interface.AccessManageD(+ExtRowid,"Ext",$p(ExtRowid,"||",2)),5)
	Q:ExtModuleFlag'="Y" 0
	;验证是否已经存在,存在不处理
	s ExtCode=$lg(^CF.DOC.Interface.AccessManageD(+ExtRowid,"Ext",$p(ExtRowid,"||",2)),2)
	s AMModuleDr=$lg(^CF.DOC.Interface.AccessManageD(+ExtRowid),3)
	s ModuleExtStr=$lg(^CT.DOC.Interface.AccessModuleD(AMModuleDr),6)
	Q:(ModuleExtStr)[(""""_ExtCode_"""") 0
	;不存在加进去
	s ExtDesc=$lg(^CF.DOC.Interface.AccessManageD(+ExtRowid,"Ext",$p(ExtRowid,"||",2)),3)
	s ModuleExtList=[]
	if (ModuleExtStr'="") s ModuleExtList=[].%FromJSON(ModuleExtStr)
	s OneExtObj={}
	s OneExtObj.ExtRowid=""
	s OneExtObj.ExtCode=ExtCode
	s OneExtObj.ExtDesc=ExtDesc
	s OneExtObj.ExtValue=""
	s OneExtObj.ExtModuleFlag="Y"
	d ModuleExtList.%Push(OneExtObj)
	;保存为JSON格式
	s ModuleExtJson=ModuleExtList.%ToJSON()
	&SQL(Update CT_DOC_Interface.AccessModule Set Module_ExtStr=:ModuleExtJson WHERE %Id=:AMModuleDr)
	Q SQLCODE
}

/// Creator:	jm
/// CreatDate:	2023.02.15
/// Description:获取厂家模块关联数据(循环关联表)
/// Input:		SearchProduct:业务域id  HospitalId:院区id
/// Return:		关联id+厂家id+厂家描述+模块id+模块描述+是否启用
/// Others:		d ##class(%ResultSet).RunQuery("DHCDoc.Interface.AccessManage","QryLinkInfo","2")
Query QryLinkInfo(SearchProduct As %String, HospitalId As %String) As websys.Query(ROWSPEC = "LinkRowid:%String,CompanyDr:%String,CompanyDesc:%String,ModuleDr:%String,ModuleDesc:%String,ActiveFlag:%String,SortId:%String,SortNum:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.AccessManage","QryLinkInfo","2","2")
ClassMethod QryLinkInfoExecute(ByRef qHandle As %Binary, SearchProduct As %String, HospitalId As %String) As %Status
{
	s ^jm("QryLinkInfo")=$lb(SearchProduct,HospitalId)
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
    ;
    s ProductDesc=$lg(^CT.DOC.Interface.AccessProductD(SearchProduct),3)
    s LinkRowid=0 for {
		s LinkRowid=$o(^CF.DOC.Interface.AccessManageD(LinkRowid))
		Q:LinkRowid=""
		continue:+LinkRowid=0
		s ProductDomain=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),5)
		continue:("!"_ProductDomain_"!")'[("!"_SearchProduct_"!")
		s HospitalDr=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),8)
		continue:HospitalDr'=HospitalId
		s CompanyDr=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),2)
		s CompanyDesc=$lg(^CT.DOC.Interface.AccessCompanyD(CompanyDr),3)
		s ModuleDr=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),3)
		s ModuleDesc=$lg(^CT.DOC.Interface.AccessModuleD(ModuleDr),3)
		s ActiveFlag=$lg(^CF.DOC.Interface.AccessManageD(LinkRowid),7)
		s ActiveFlag=$case(ActiveFlag,"Y":"是",:"否")
		s SortNum=""
		s SortId=$o(^User.BDPSortI("ReferenceIdx","CF.DOC.Interface.AccessManage",ProductDesc,LinkRowid,0))
		if (SortId'="") s SortNum=$lg(^User.BDPSortD(SortId),5)
		;此处进行排序
		s checkNum=SortNum
		if (checkNum="") s checkNum="999"
		s checkNum=$e("000",1,3-$l(checkNum))_checkNum
		s checkActive=$case(ActiveFlag,"Y":"1",:"2")
		s LinkInfoArr(checkNum_"!"_checkActive_"!"_LinkRowid)=$lb(LinkRowid,CompanyDr,CompanyDesc,ModuleDr,ModuleDesc,ActiveFlag,SortId,$g(SortNum))
    }
    s checkSort=0 for {
	    s checkSort=$o(LinkInfoArr(checkSort))
	    Q:checkSort=""
	    s Data=LinkInfoArr(checkSort)
    	d OutputQryLinkInfo
    }
    Quit $$$OK
OutputQryLinkInfo
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

/// Creator:	jm
/// CreatDate:	2023.02.16
/// Description:保存院区,业务域对应的接口调用顺序
/// Input:		SortStr:排序串(关联id^排序id^顺序号)
/// Return:		保存结果(0:成功,其它:失败)
/// Others:		w ##class(DHCDoc.Interface.AccessManage).SaveAccessSort("2",$lg(^jm("SaveAccessSort"),2))
ClassMethod SaveAccessSort(ProductDr As %String, SortJson As %String) As %String
{
	s ^jm("SaveAccessSort")=$lb(ProductDr,SortJson)
	s $zt="SaveAccessSortErr"
	s SortStr=""
	s TableName="CF.DOC.Interface.AccessManage"
	s ProductDesc=$lg(^CT.DOC.Interface.AccessProductD(ProductDr),3)
	TStart
	s SortList=[].%FromJSON(SortJson)
	for i=1:1:SortList.%Size() {
		s SortObj=SortList.%Get(i-1)
		continue:'$ISObject(SortObj)
		s LinkRowid=SortObj.LinkRowid
		s SortId=SortObj.SortId
		s SortNum=SortObj.SortNum
		s OneSort=TableName_"^"_LinkRowid_"^"_ProductDesc_"^"_SortNum_"^"_SortId
		if (SortStr="") s SortStr=OneSort
		else  s SortStr=SortStr_"*"_OneSort
	}
	s rtn=##class(web.DHCBL.BDP.BDPSort).SaveData(SortStr)
	if (rtn'["true") {
		TRollback
		Q rtn
	}
	TCommit
	Q 0
SaveAccessSortErr
	s $zt=""
	if ($TLevel>0) TRollback
	Q "程序异常:"_$ze
}

/// Creator:	lixu
/// CreatDate:	2023.04.19
/// Description: 通过产家代码,模块代码,扩展代码获取扩展设定中的数据值
/// Input:	CompanyCode:产家Code, ModeCode:模块Code, ExtCode:扩展代码, HospID:医院ID
/// Return:	维护的扩展对象	
/// Others:	w ##class(DHCDoc.Interface.AccessManage).GetAccessLinkExt("iMedical","Drgs","webservice",2)
ClassMethod GetAccessLinkExt(CompanyCode, ModeCode, ExtCode, HospID) As %DynamicObject
{
    s ExtObj={}
    s $zt="GetAccessLinkExtErr"
	
    s CompanyID=$o(^CT.DOC.Interface.AccessCompanyI("IdxCode",CompanyCode,0))
	Q:CompanyID="" ExtObj
	
	s ModeID=$o(^CT.DOC.Interface.AccessModuleI("IdxCode",ModeCode,0))
	Q:ModeID="" ExtObj
	
	s LinkID=$o(^CF.DOC.Interface.AccessManageI("IdxLink",CompanyID,ModeID,HospID,0))
	Q:LinkID="" ExtObj
	
    s ExtID=$o(^CF.DOC.Interface.AccessManageI("Ext","IdxCode",ExtCode,LinkID,0))
    Q:ExtID="" ExtObj

    s ExtInfo=$g(^CF.DOC.Interface.AccessManageD(LinkID,"Ext",ExtID))
    s ExtObj.ExtRowID=LinkID_"||"_ExtID
    s ExtObj.ExtCode=$lg(ExtInfo,2)
    s ExtObj.ExtDesc=$lg(ExtInfo,3)
    s ExtObj.ExtValue=$lg(ExtInfo,4)  
	Q ExtObj

GetAccessLinkExtErr
    s $zt=""
    Q ExtObj
}

/// Creator:	jm
/// CreatDate:	2023.02.09
/// Description:清除所有配置数据
/// Input:		
/// Return:		
/// Others:		d ##class(DHCDoc.Interface.AccessManage).ClearData()
ClassMethod ClearData() As %String
{
	k ^CF.DOC.Interface.AccessManageD
	k ^CF.DOC.Interface.AccessManageI
	k ^CF.DOC.Interface.AccessManageS
}

/// Creator:	jm
/// CreatDate:	2023.04.21
/// Description:清除相关配置数据(授权科室置为空,启用为否),用于上线前清配置数据使用
/// Input:		
/// Return:		
/// Others:		d ##class(DHCDoc.Interface.AccessManage).ClearConfig()
ClassMethod ClearConfig() As %String
{
	s rowid=0 for {
		s rowid=$o(^CF.DOC.Interface.AccessManageD(rowid))
		Q:rowid=""
		continue:+rowid=0
		s AMAuthLocStr=$lb(""),AMActiveFlag="N"
		&SQL(Update CF_DOC_Interface.AccessManage Set AM_AuthLocStr=:AMAuthLocStr,AM_ActiveFlag=:AMActiveFlag WHERE %Id=:rowid)
	}
	Q 0
}

}
