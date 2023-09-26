/// 名称:组织部门表-HCP同步数据
/// 描述:包含增删改查功能
/// 编写者:基础数据平台-likefan
/// 编写日期:2020-07-25
Class web.DHCBL.CT.CTDepartment Extends %RegisteredObject
{

/// Creator：基础数据平台-likefan
/// CreatDate: 2020-07-25
/// Description:查询
/// Table:User.CTDepartment
/// Input:rowid,code,desc
/// Return:ID,DEPRowId,DEPCode,DEPDesc,DEPAlias,DEPOfficePhone,DEPCategory,DEPParentDR,DEPRefClinDR,DEPAtrribute,DEPUpdateUserID,DEPUpdateUserName,DEPCharacter,DEPPayAtrribute,DEPPurchaseFlag,DEPShareCharacter,DEPDateFrom,DEPDateTo,DEPNationalCode,DEPOfficeAddress
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTDepartment","GetList","","","","")
Query GetList(rowid As %String, hrid As %String, code As %String, desc As %String, refclin As %String) As %Query(ROWSPEC = "ID,DEPRowId,DEPCode,DEPDesc,DEPAlias,DEPOfficePhone,DEPCategory,DEPParentDR,DEPRefClinDR,DEPAtrribute,DEPUpdateUserID,DEPUpdateUserName,DEPCharacter,DEPPayAtrribute,DEPPurchaseFlag,DEPShareCharacter,DEPDateFrom,DEPDateTo,DEPNationalCode,DEPOfficeAddress")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, hrid As %String, code As %String, desc As %String, refclin As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s ID=rowid
		s DEPRowId=$lg($g(^User.CTDepartmentD(ID)),2)		// HR里（MDM平台）的组织部门代码
		s DEPCode=$lg($g(^User.CTDepartmentD(ID)),3)		// 编码
		s DEPDesc=$lg($g(^User.CTDepartmentD(ID)),4)		// 描述
		s DEPAlias=$lg($g(^User.CTDepartmentD(ID)),5)		// 简称
		s DEPOfficePhone=$lg($g(^User.CTDepartmentD(ID)),6)		// 联系电话
		s DEPCategory=$lg($g(^User.CTDepartmentD(ID)),7)		// HR科室分类
		s DEPParentDR=$lg($g(^User.CTDepartmentD(ID)),8)		// 上级组织部门ID
		s:DEPParentDR'="" DEPParentDR=$lg($g(^User.CTDepartmentD(DEPParentDR)),4)	// 上级组织部门描述
		s DEPRefClinDR=$lg($g(^User.CTDepartmentD(ID)),9)		// HIS医疗机构DR
		s:DEPRefClinDR'="" DEPRefClinDR=$p($g(^CT("RFC",DEPRefClinDR)),"^",2)	// HIS医疗机构描述
		s DEPAtrribute=$lg($g(^User.CTDepartmentD(ID)),10)		// 组织属性
		s DEPUpdateUserID=$lg($g(^User.CTDepartmentD(ID)),11)		// 修改人ID
		s DEPUpdateUserName=$lg($g(^User.CTDepartmentD(ID)),12)		// 修改人名称
		s:DEPUpdateUserID'="" DEPUpdateUserName=$p($g(^SSU("SSUSR",DEPUpdateUserID)),"^",2)       //修改人名称
		s DEPCharacter=$lg($g(^User.CTDepartmentD(ID)),13)		// 部门性质
		s DEPPayAtrribute=$lg($g(^User.CTDepartmentD(ID)),14)		// 支出属性
		s DEPPurchaseFlag=$lg($g(^User.CTDepartmentD(ID)),15)		// 是否采购部门
		s:(DEPPurchaseFlag="是")||(DEPPurchaseFlag="1") DEPPurchaseFlag="Y"
		s DEPShareCharacter=$lg($g(^User.CTDepartmentD(ID)),16)		// 分摊性质
		s DEPDateFrom=$lg($g(^User.CTDepartmentD(ID)),17)		// 开始日期
		s DEPDateTo=$lg($g(^User.CTDepartmentD(ID)),18)		// 结束日期
		s DEPNationalCode=$lg($g(^User.CTDepartmentD(ID)),19)		// 国家编码
		s DEPOfficeAddress=$lg($g(^User.CTDepartmentD(ID)),20)		// 地址
		//HR代码翻译
		s DEPCategory=$case(DEPCategory,"01":"临床科室","02":"医技科室","03":"医辅科室","04":"职能科室","05":"党群科室","06":"后勤科室","99":"其他",:DEPCategory)
		s DEPAtrribute=$case(DEPAtrribute,"01":"行政序列","01.01":"职能科室序列","01.02":"临床科室序列","01.03":"医技科室序列","01.04":"医辅科室序列","01.05":"后勤科室序列","02":"党群序列","02.01":"党建序列","02.02":"团委序列","02.03":"工会序列","03":"委员会序列","09":"其他序列",:DEPAtrribute)
		s DEPCharacter=$case(DEPCharacter,"1":"临床","2":"医技","3":"医辅","4":"管理",:DEPCharacter)
		s DEPPayAtrribute=$case(DEPPayAtrribute,"1":"医疗","2":"管理","3":"物资加工",:DEPPayAtrribute)
		s DEPShareCharacter=$case(DEPShareCharacter,"1":"管理","2":"门诊医辅","3":"内部定价",:DEPShareCharacter)
		
		s:DEPDateFrom'="" DEPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPDateFrom)
		s:DEPDateTo'="" DEPDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPDateTo)
		d OutputRow
	}
	else
	{
		s:hrid'="" hrid=$ZCONVERT(hrid,"U")
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s:refclin'="" refclin=$ZCONVERT(refclin,"U")
		s ID=0
		for
		{
			s ID=$o(^User.CTDepartmentD(ID)) q:ID=""
			s DEPRowId=$lg($g(^User.CTDepartmentD(ID)),2)		// HR里（MDM平台）的组织部门代码
			s DEPCode=$lg($g(^User.CTDepartmentD(ID)),3)		// 编码
			s DEPDesc=$lg($g(^User.CTDepartmentD(ID)),4)		// 描述
			s DEPAlias=$lg($g(^User.CTDepartmentD(ID)),5)		// 简称
			s DEPOfficePhone=$lg($g(^User.CTDepartmentD(ID)),6)		// 联系电话
			s DEPCategory=$lg($g(^User.CTDepartmentD(ID)),7)		// HR科室分类
			s DEPParentDR=$lg($g(^User.CTDepartmentD(ID)),8)		// 上级组织部门ID
			s:DEPParentDR'="" DEPParentDR=$lg($g(^User.CTDepartmentD(DEPParentDR)),4)	// 上级组织部门描述
			s DEPRefClinDR=$lg($g(^User.CTDepartmentD(ID)),9)		// HIS医疗机构
			s RefClinDR=DEPRefClinDR	//用于医疗机构的检索
			s:DEPRefClinDR'="" DEPRefClinDR=$p($g(^CT("RFC",DEPRefClinDR)),"^",2)	// HIS医疗机构描述
			s DEPAtrribute=$lg($g(^User.CTDepartmentD(ID)),10)		// 组织属性
			s DEPUpdateUserID=$lg($g(^User.CTDepartmentD(ID)),11)		// 修改人ID
			s DEPUpdateUserName=$lg($g(^User.CTDepartmentD(ID)),12)		// 修改人名称
			s:DEPUpdateUserID'="" DEPUpdateUserName=$p($g(^SSU("SSUSR",DEPUpdateUserID)),"^",2)       //修改人名称
			s DEPCharacter=$lg($g(^User.CTDepartmentD(ID)),13)		// 部门性质
			s DEPPayAtrribute=$lg($g(^User.CTDepartmentD(ID)),14)		// 支出属性
			s DEPPurchaseFlag=$lg($g(^User.CTDepartmentD(ID)),15)		// 是否采购部门
			s:(DEPPurchaseFlag="是")||(DEPPurchaseFlag="1") DEPPurchaseFlag="Y"
			s DEPShareCharacter=$lg($g(^User.CTDepartmentD(ID)),16)		// 分摊性质
			s DEPDateFrom=$lg($g(^User.CTDepartmentD(ID)),17)		// 开始日期
			s DEPDateTo=$lg($g(^User.CTDepartmentD(ID)),18)		// 结束日期
			s DEPNationalCode=$lg($g(^User.CTDepartmentD(ID)),19)		// 国家编码
			s DEPOfficeAddress=$lg($g(^User.CTDepartmentD(ID)),20)		// 地址
			//HR代码翻译
			s DEPCategory=$case(DEPCategory,"01":"临床科室","02":"医技科室","03":"医辅科室","04":"职能科室","05":"党群科室","06":"后勤科室","99":"其他",:DEPCategory)
			s DEPAtrribute=$case(DEPAtrribute,"01":"行政序列","01.01":"职能科室序列","01.02":"临床科室序列","01.03":"医技科室序列","01.04":"医辅科室序列","01.05":"后勤科室序列","02":"党群序列","02.01":"党建序列","02.02":"团委序列","02.03":"工会序列","03":"委员会序列","09":"其他序列",:DEPAtrribute)
			s DEPCharacter=$case(DEPCharacter,"1":"临床","2":"医技","3":"医辅","4":"管理",:DEPCharacter)
			s DEPPayAtrribute=$case(DEPPayAtrribute,"1":"医疗","2":"管理","3":"物资加工",:DEPPayAtrribute)
			s DEPShareCharacter=$case(DEPShareCharacter,"1":"管理","2":"门诊医辅","3":"内部定价",:DEPShareCharacter)
			
			s:DEPDateFrom'="" DEPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPDateFrom)
			s:DEPDateTo'="" DEPDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPDateTo)
			if ($ZCONVERT(DEPRowId,"U")[hrid)&&($ZCONVERT(DEPCode,"U")[code)&&(($ZCONVERT(DEPDesc,"U")[desc)||(DEPAlias[desc))&&((RefClinDR=refclin)||(refclin=""))
			{
				d OutputRow
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,DEPRowId,DEPCode,DEPDesc,DEPAlias,DEPOfficePhone,DEPCategory,DEPParentDR,DEPRefClinDR,DEPAtrribute,DEPUpdateUserID,DEPUpdateUserName,DEPCharacter,DEPPayAtrribute,DEPPurchaseFlag,DEPShareCharacter,DEPDateFrom,DEPDateTo,DEPNationalCode,DEPOfficeAddress)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：李可凡 		
/// CreatDate: 2020-07-26
/// Description：查询接口,提供给下拉框
/// Table:User.CTDepartment
/// Input:id, code, desc
/// Output:RowId,Code,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTDepartmentLocation","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,DEPCode,DEPDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="")
	{
		s ID=rowid
		s DEPRowId=$lg($g(^User.CTDepartmentD(ID)),2)		// 代码
		s DEPCode=$lg($g(^User.CTDepartmentD(ID)),3)		// 编码
		s DEPDesc=$lg($g(^User.CTDepartmentD(ID)),4)		// 描述
		s DEPDesc=DEPRowId_"-"_DEPDesc
		d OutputDeptCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s ID=0
		for
		{
			s ID=$o(^User.CTDepartmentD(ID)) q:ID=""
			s DEPRowId=$lg($g(^User.CTDepartmentD(ID)),2)		// 代码
			s DEPCode=$lg($g(^User.CTDepartmentD(ID)),3)		// 编码
			s DEPDesc=$lg($g(^User.CTDepartmentD(ID)),4)		// 描述
			s DEPDesc=DEPRowId_"-"_DEPDesc
			s DEPDateFrom=$lg($g(^User.CTDepartmentD(ID)),17)	// 开始日期
			s DEPDateTo=$lg($g(^User.CTDepartmentD(ID)),18)		// 结束日期
			continue:(DEPDateFrom'="")&&(DEPDateFrom>+$h)
			continue:(DEPDateTo'="")&&(DEPDateTo<+$h)
			s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DEPDesc)
			if ($ZCONVERT(DEPCode,"U")[code)||($ZCONVERT(DEPDesc,"U")[desc)||(PINYINDesc[desc)
			{
				d OutputDeptCmb
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDeptCmb
    set Data=$lb(ID,DEPCode,DEPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator：基础数据平台-likefan
/// CreatDate: 2020-07-25
/// Description:数据重复验证方法,js调用
/// Table:User.CTDepartment
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.CTDepartment).FormValidate("","","","")
ClassMethod FormValidate(id As %String, HRid As %String) As %String
{
	s flag=0
	if HRid'=""
	{
		s ID=$o(^User.CTDepartmentI("DEPRowIdRef",HRid,0))
		if (ID'="")&&(id'=ID) s flag=1
	}
	q flag
}

/// Creator：基础数据平台-likefan
/// CreatDate: 2020-07-25
/// Description:双击修改时,从后台取数据
/// Table:User.CTDepartment
/// Input:id
/// Other:d ##class(web.DHCBL.CT.CTDepartment).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.CTDepartment).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTDepartment).%New()
	s eobj.ID = id
	s eobj.DEPRowId = pobj.DEPRowId
	s eobj.DEPCode = pobj.DEPCode
	s eobj.DEPDesc = pobj.DEPDesc
	s eobj.DEPAlias = pobj.DEPAlias
	s eobj.DEPOfficePhone = pobj.DEPOfficePhone
	s eobj.DEPCategory = pobj.DEPCategory
	s:pobj.DEPParentDR'="" eobj.DEPParentDR = pobj.DEPParentDR.%Id()
	s:pobj.DEPRefClinDR'="" eobj.DEPRefClinDR = pobj.DEPRefClinDR.%Id()
	s eobj.DEPAtrribute = pobj.DEPAtrribute
	s:pobj.DEPUpdateUserID'="" eobj.DEPUpdateUserID = pobj.DEPUpdateUserID.%Id()
	s eobj.DEPUpdateUserName = pobj.DEPUpdateUserName
	s eobj.DEPCharacter = pobj.DEPCharacter
	s eobj.DEPPayAtrribute = pobj.DEPPayAtrribute
	s eobj.DEPPurchaseFlag = pobj.DEPPurchaseFlag
	s eobj.DEPShareCharacter = pobj.DEPShareCharacter
	s eobj.DEPDateFrom = pobj.DEPDateFrom
	s eobj.DEPDateTo = pobj.DEPDateTo
	s eobj.DEPNationalCode = pobj.DEPNationalCode
	s eobj.DEPOfficeAddress = pobj.DEPOfficeAddress
	s:pobj.DEPDateFrom'="" eobj.DEPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.DEPDateFrom)
	s:pobj.DEPDateTo'="" eobj.DEPDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.DEPDateTo)
	s:((eobj.DEPPurchaseFlag="是")||(eobj.DEPPurchaseFlag="1")) eobj.DEPPurchaseFlag = "Y"
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator：基础数据平台-likefan
/// CreatDate: 2020-07-25
/// function:新增修改保存
/// Table：User.CTDepartment
ClassMethod SaveEntity(eobj As web.Entity.CT.CTDepartment) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.DEPPurchaseFlag="" eobj.DEPPurchaseFlag ="N"
		s:eobj.DEPAlias="" eobj.DEPAlias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.DEPDesc)
		s:eobj.DEPDateFrom'="" eobj.DEPDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DEPDateFrom)
		s:eobj.DEPDateTo'="" eobj.DEPDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DEPDateTo)
		s:eobj.DEPDateFrom="" eobj.DEPDateFrom=+$h
		s flag=..FormValidate(eobj.ID,eobj.DEPRowId)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")
		{
			s obj=##class(User.CTDepartment).%New()
		}
		else
		{
			s obj=##class(User.CTDepartment).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.CTDepartment).%New()
		    s bobj.ID=eobj.ID
		    s bobj.DEPRowId=obj.DEPRowId
			s bobj.DEPCode=obj.DEPCode
			s bobj.DEPDesc=obj.DEPDesc
			s bobj.DEPAlias=obj.DEPAlias
			s bobj.DEPOfficePhone=obj.DEPOfficePhone
			s bobj.DEPCategory=obj.DEPCategory
			s:obj.DEPParentDR'="" bobj.DEPParentDR=obj.DEPParentDR.%Id()
			s:obj.DEPRefClinDR'="" bobj.DEPRefClinDR=obj.DEPRefClinDR.%Id()
			s bobj.DEPAtrribute=obj.DEPAtrribute
			s:obj.DEPUpdateUserID'="" bobj.DEPUpdateUserID=obj.DEPUpdateUserID.%Id()
			s bobj.DEPUpdateUserName=obj.DEPUpdateUserName
			s bobj.DEPCharacter=obj.DEPCharacter
			s bobj.DEPPayAtrribute=obj.DEPPayAtrribute
			s bobj.DEPPurchaseFlag=obj.DEPPurchaseFlag
			s bobj.DEPShareCharacter=obj.DEPShareCharacter
			s bobj.DEPDateFrom=obj.DEPDateFrom
			s bobj.DEPDateTo=obj.DEPDateTo
			s bobj.DEPNationalCode=obj.DEPNationalCode
			s bobj.DEPOfficeAddress=obj.DEPOfficeAddress
		}
		s obj.DEPRowId=eobj.DEPRowId			//HR组织部门表id
		s obj.DEPCode=eobj.DEPCode				//编码
		s obj.DEPDesc=eobj.DEPDesc				//描述
		s obj.DEPAlias=eobj.DEPAlias			//简称
		s obj.DEPOfficePhone=eobj.DEPOfficePhone				//联系电话
		s obj.DEPCategory=eobj.DEPCategory						//HR科室分类
		d obj.DEPParentDRSetObjectId(eobj.DEPParentDR)			//上级组织部门ID
		d obj.DEPRefClinDRSetObjectId(eobj.DEPRefClinDR)		//HIS医疗机构ID
		s obj.DEPAtrribute=eobj.DEPAtrribute					//组织属性
		if ($d(%session))
		{
			s eobj.DEPUpdateUserID=$Get(%session.Data("LOGON.USERID"))
		}
		d obj.DEPUpdateUserIDSetObjectId(eobj.DEPUpdateUserID)	//修改人ID
		s obj.DEPUpdateUserName=eobj.DEPUpdateUserName			//修改人名称
		s obj.DEPCharacter=eobj.DEPCharacter					//部门性质
		s obj.DEPPayAtrribute=eobj.DEPPayAtrribute				//支出属性
		s obj.DEPPurchaseFlag=eobj.DEPPurchaseFlag				//是否采购部门
		s obj.DEPShareCharacter=eobj.DEPShareCharacter			//分摊性质
		s obj.DEPDateFrom=eobj.DEPDateFrom					//开始日期
		s obj.DEPDateTo=eobj.DEPDateTo						//结束日期
		s obj.DEPNationalCode=eobj.DEPNationalCode			//国家编码
		s obj.DEPOfficeAddress=eobj.DEPOfficeAddress		//地址
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Department","User.CTDepartment","组织部门",eobj.ID,eobj.DEPDesc,"U",eobj,bobj)
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Department","User.CTDepartment","组织部门",id,eobj.DEPDesc,"A",eobj)
		}
		else
		{
			TRO
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
	}
	else
	{
		s result= "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：基础数据平台-likefan
/// CreatDate: 2020-07-25
/// Description:根据id删除 组织部门
/// Table:User.CTDepartment
/// Input:id
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.CTDepartment).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s re=..GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	s reason=$p(re,"^",2)
	if (RefFlag=0)
	{
		s pobj = ##class(User.CTDepartment).%OpenId(id)
		s eobj = ##class(web.Entity.CT.CTDepartment).%New()
		s eobj.ID = id
		s eobj.DEPRowId = pobj.DEPRowId
		s eobj.DEPCode = pobj.DEPCode
		s eobj.DEPDesc = pobj.DEPDesc
		s eobj.DEPAlias = pobj.DEPAlias
		s eobj.DEPOfficePhone = pobj.DEPOfficePhone
		s eobj.DEPCategory = pobj.DEPCategory
		s:pobj.DEPParentDR'="" eobj.DEPParentDR = pobj.DEPParentDR.%Id()
		s:pobj.DEPRefClinDR'="" eobj.DEPRefClinDR = pobj.DEPRefClinDR.%Id()
		s eobj.DEPAtrribute = pobj.DEPAtrribute
		s:pobj.DEPUpdateUserID'="" eobj.DEPUpdateUserID = pobj.DEPUpdateUserID.%Id()
		s eobj.DEPUpdateUserName = pobj.DEPUpdateUserName
		s eobj.DEPCharacter = pobj.DEPCharacter
		s eobj.DEPPayAtrribute = pobj.DEPPayAtrribute
		s eobj.DEPPurchaseFlag = pobj.DEPPurchaseFlag
		s eobj.DEPShareCharacter = pobj.DEPShareCharacter
		s eobj.DEPDateFrom = pobj.DEPDateFrom
		s eobj.DEPDateTo = pobj.DEPDateTo
		s eobj.DEPNationalCode = pobj.DEPNationalCode
		s eobj.DEPOfficeAddress = pobj.DEPOfficeAddress
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.CTDepartment).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Department","User.CTDepartment","组织部门",id,eobj.DEPDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
	}
	else
	{
		s result= "{success:'false',info:'"_reason_"'}"	
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-07-28
/// function：删除时验证数据是否被引用
/// Debug：w ##class(web.DHCBL.CT.CTDepartment).GetRefFlag(1)
ClassMethod GetRefFlag(id As %String) As %String
{
	s result=""
	//校验本表
	s ID=0
	for 
	{
		s ID=$o(^User.CTDepartmentD(ID)) q:ID=""
		s DEPParentDR=$lg($g(^User.CTDepartmentD(ID)),8)	// 上级组织部门ID
		if (DEPParentDR=id)
		{
			s DEPDesc=$lg($g(^User.CTDepartmentD(ID)),4)
			s result="1^该数据被 "_DEPDesc_" 引用为上级部门,不能删除！"
			q
		}
	}
	//校验Location与组织关联表
	if ($d(^User.CTDepartmentLocationI("DEPLDeptDR",id)))
	{
		s result="1^该数据被“Location与组织关联表”引用,不能删除！"
	}
	s:result="" result="0^未被引用可删除！"
	q result
}

}
