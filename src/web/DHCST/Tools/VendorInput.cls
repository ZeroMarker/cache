Import sqluser

/// 供应商信息导入程序
///   Author:zhangxiao
///   Date:2013-12-26
/// w ##class(web.DHCST.Tools.VendorInput).StartInput("文件名","")
/// w ##class(web.DHCST.Tools.VendorInput).StartInput("D:\vendor.txt","")
Class web.DHCST.Tools.VendorInput Extends (%RegisteredObject, %XML.Adaptor, web.DHCST.StkTypeG) [ Not ProcedureBlock ]
{

/// 执行导入的总入口
/// fileName: .Txt文件(Tab分隔符
ClassMethod StartInput(fileName As %String, sub As %String) As %String
{
  n (fileName,sub)
  //s AdjSpNo=##class(web.DHCST.Common.AppCommon).GetAppNo("DHCSTADJSPM","","")
  
  i sub="" s sub="Vendor"
  s p=$zn
  s ret=##class(web.DHCST.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  ;
  s i=1
  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
  .;b
  .s rowStr=$G(^zTSA(p,sub,i))
  .w rowStr,!
  .;q
  .s cnt=cnt+1
  .;w cnt,!
  .tstart
  .s msg=""
  .s ret1=..InputIncItm(rowStr,.msg)
  .w !,ret1
  .w !
  .i ret1=0 d
  ..tcommit
  ..s successCnt=successCnt+1
  .e  d
  .. tro
  .. d ..SetErr(i,msg)
  ..
  k ^zTSA(p,sub)  //删除临时global
  q cnt_"^"_successCnt
}

/// 处理一行数据
ClassMethod InputIncItm(rowStr As %String, msg As %String) As %String
{
	n (rowStr,msg)
  
  
  s colNoStr=""
  s rowStr=$tr(rowStr,$c(13,10))
  s rowStr=$tr(rowStr," ","")
  
  s ret=0
  s del="^"
  s Code=$p(rowStr,del,..Col("Code"))   ;代码
  s Desc=$p(rowStr,del,..Col("Desc") ) ;描述
  s Type=..sssCode()
  s Tel=$p(rowStr,del,..Col("Tel") ) ;电话
  s ConPerson=$p(rowStr,del,..Col("ConPerson") ) ;联系人
  s CtrlAcct=$p(rowStr,del,..Col("CtrlAcct") ) ;账号
  s CrLimit=$p(rowStr,del,..Col("CrLimit") ) ;采购限额
  s CategoryId=$p(rowStr,del,..Col("CategoryId") ) ;分类
  s CrAvail=""
  s LstPoDate=$p(rowStr,del,..Col("LstPoDate") ) ;合同截止日期
  i LstPoDate'="" s LstPoDate=..vDate(LstPoDate)
  s Fax=$p(rowStr,del,..Col("Fax") ) ;传真
  s President=$p(rowStr,del,..Col("President") ) ;法人代表
  s RCFlag=""
  s Status="A"
  s Codetmp=..GetCNCODE(Desc,4,"") 
  i Code="" s Code=..GetCNCODE(Desc,4,"")  ;别名一:描述的拼音首字符
  i Desc'["-" s Desc=Codetmp_"-"_Desc
  s vendoridtmp=$o(^APC("APCVM",0,"APCVM_Name",$$ALPHAUP^SSUTIL4(Desc),""))
  i +vendoridtmp>0 s ret=-10 ;供应商名称重复
    ;&sql(Insert into APC_Vendor(APCVM_Code,APCVM_Name,APCVM_Type) values(:code,:desc,:type))
  &sql(Insert into APC_Vendor(APCVM_Code,APCVM_Name,APCVM_Tel,APCVM_ContPerson,
    APCVM_Type,APCVM_CtrlAcct_DR,APCVM_CrLimit,APCVM_Category_DR,APCVM_CrAvail,
    APCVM_LstPoDate,APCVM_Fax,APCVM_President,APCVM_RcFlag,APCVM_ShName,APCVM_Status)
    values(:Code,:Desc,:Tel,:ConPerson,:Type,:CtrlAcct,:CrLimit,:CategoryId,:CrAvail,
    :LstPoDate,:Fax,:President,:RCFlag,:Desc,:Status))
  i SQLCODE'=0 d 
  .s msg="插入主表错误:"
  .s ret=-1
  e  d
  .s VendorId=$g(%ROWID)
  q:ret<0 ret
  
  //保存供应商附加资质表信息
  s Address=$p(rowStr,del,..Col("Address"))   ;地址
  s ComLic=$p(rowStr,del,..Col("ComLic"))   ;工商执照
  s ComLicDate=$p(rowStr,del,..Col("ComLicDate"))   ;工商执照效期
  s RevReg=$p(rowStr,del,..Col("RevReg"))   ;税务登记号
  s RevRegDate=$p(rowStr,del,..Col("RevRegDate"))   ;税务登记号效期
  i ComLicDate'="" s ComLicDate=..vDate(ComLicDate) ;工商执照效期
  i RevRegDate'="" s RevRegDate=..vDate(RevRegDate) ;税务登记号效期
  
  s DrugManLic=""
  s DrugManLicDate=""
  s MatManLic=$p(rowStr,del,..Col("MatManLic"))   ;医疗器械经营许可证
  s MatManLicDate=$p(rowStr,del,..Col("MatManLicDate"))   ;医疗器械经营许可证有效期
  s MatEnrol=$p(rowStr,del,..Col("MatEnrol"))   ;医疗器械注册证
  s MatEnrolDate=$p(rowStr,del,..Col("MatEnrolDate"))   ;医疗器械注册证有效期
  s Sanitation=$p(rowStr,del,..Col("Sanitation"))   ;卫生许可证
  s SanitationDate=$p(rowStr,del,..Col("SanitationDate"))   ;卫生许可证有效期
  i MatManLicDate'="" s MatManLicDate=..vDate(MatManLicDate) ;医疗器械经营许可证有效期
  i MatEnrolDate'="" s MatEnrolDate=..vDate(MatEnrolDate) ;医疗器械注册证有效期
  i SanitationDate'="" s SanitationDate=..vDate(SanitationDate) ;卫生许可证有效期
  
  
  s OrgCode=$p(rowStr,del,..Col("OrgCode"))   ;组织机构代码
  s OrgCodeDate=$p(rowStr,del,..Col("OrgCodeDate"))   ;组织机构代码有效期
  s Gsp=$p(rowStr,del,..Col("Gsp"))   ;GSP认证
  s GspDate=$p(rowStr,del,..Col("GspDate"))   ;GSP认证有效期
  s MatPro=$p(rowStr,del,..Col("MatPro"))   ;医疗器械生产许可证
  s MatProDate=$p(rowStr,del,..Col("MatProDate"))   ;医疗器械生产许可证有效期
  i OrgCodeDate'="" s OrgCodeDate=..vDate(OrgCodeDate) ;组织机构代码有效期
  i GspDate'="" s GspDate=..vDate(GspDate)             ;GSP认证有效期
  i MatProDate'="" s MatProDate=..vDate(MatProDate)  ;医疗器械生产许可证有效期
  
  s ProPermit=$p(rowStr,del,..Col("ProPermit"))   ;生产制造认可表
  s ProPermitDate=$p(rowStr,del,..Col("ProPermitDate"))   ;生产制造认可表有效期
  s ImportEnrol=$p(rowStr,del,..Col("ImportEnrol"))   ;进口医疗器械注册证
  s ImportEnrolDate=$p(rowStr,del,..Col("ImportEnrolDate"))   ;进口医疗器械注册证有效期
  s ImportLic=$p(rowStr,del,..Col("ImportLic"))   ;进口注册登记表
  s ImportLicDate=$p(rowStr,del,..Col("ImportLicDate"))   ;进口注册登记表有效期
  i ProPermitDate'="" s ProPermitDate=..vDate(ProPermitDate) ;生产制造认可表有效期
  i ImportEnrolDate'="" s ImportEnrolDate=..vDate(ImportEnrolDate) ;进口医疗器械注册证有效期
  i ImportLicDate'="" s ImportLicDate=..vDate(ImportLicDate) ;进口注册登记表有效期
  
  s AgentLic=$p(rowStr,del,..Col("AgentLic"))   ;代理销售授权书
  s AgentLicDate=$p(rowStr,del,..Col("AgentLicDate"))   ;代理销售授权书有效期
  i AgentLicDate'="" s AgentLicDate=..vDate(AgentLicDate) 
  s Promises=$p(rowStr,del,..Col("Promises"))   ;售后服务承诺书
  s TrustDeed=$p(rowStr,del,..Col("TrustDeed"))   ;法人委托书
  s Quality=$p(rowStr,del,..Col("Quality"))   ;质量承诺书
  s QualityDate=$p(rowStr,del,..Col("QualityDate"))   ;质量承诺书有效期
  i QualityDate'="" s QualityDate=..vDate(QualityDate) 
  s SalesName=$p(rowStr,del,..Col("SalesName"))   ;业务员姓名
  s SalesNameDate=$p(rowStr,del,..Col("SalesNameDate"))   ;业务员授权书有效期
  i SalesNameDate'="" s SalesNameDate=..vDate(SalesNameDate) 
  s SalesTel=$p(rowStr,del,..Col("SalesTel"))   ;业务员电话
  s SType=..sssCode()
  d ..SaveAddress(Address,VendorId)
  &sql(Insert into DHC_STVendor(STV_Vendor_DR,STV_ComLic,STV_ComLicDate,STV_RevReg,
    STV_RevRegDate,STV_DrugManLic,STV_DrugManLicDate,STV_MatManLic,STV_MatManLicDate,
    STV_MatEnrol,STV_MatEnrolDate,STV_Sanitation,STV_SanitationDate,STV_OrgCode,STV_OrgCodeDate,
    STV_Gsp,STV_GspDate,STV_MatPro,STV_MatProDate,STV_ProPermit,STV_ProPermitDate,
    STV_ImportEnrol,STV_ImportEnrolDate,STV_ImportLic,STV_ImportLicDate,STV_AgentLic,
    STV_Promises,STV_TrustDeed,STV_Quality,STV_AgentLicDate,STV_QualityDate,STV_SalesName,
    STV_SalesDate,STV_SalesTel,STV_Type)
    values(:VendorId,:ComLic,:ComLicDate,:RevReg,:RevRegDate,:DrugManLic,:DrugManLicDate,
    :MatManLic,:MatManLicDate,:MatEnrol,:MatEnrolDate,:Sanitation,:SanitationDate,:OrgCode,:OrgCodeDate,
    :Gsp,:GspDate,:MatPro,:MatProDate,:ProPermit,:ProPermitDate,:ImportEnrol,:ImportEnrolDate,
    :ImportLic,:ImportLicDate,:AgentLic,:Promises,:TrustDeed,:Quality,:AgentLicDate,:QualityDate,
    :SalesName,:SalesNameDate,:SalesTel,:SType))
    i SQLCODE'=0  d
    .s msg="插入供应商附加表错误:"
    .s ret=-2
    q:ret<0 ret
    
  q ret
}

/// 取出列在串中的位置
ClassMethod Col(colname As %String) As %String
{
	n (colname)
   //此处为导入数据的排列顺序
   //"代码^名称^电话^联系人^账号^采购限额^供应商分类^合同截止日期^传真^法人代表 ^地址^工商执照^工商执照有效期^税务登记^税务登记效期^医疗器械经营许可证^医疗器械经营许可证效期^医疗器械注册证^医疗器械注册证有效期^卫生许可证^卫生许可证有效期^组织机构代码^组织机构代码有效期^Gsp^Gsp效期^医疗器械生产许可证^医疗器械生产许可证有效期^生产制造认可表^生产制造认可表有效期^进口医疗器械注册证^效期^进口注册登记表^效期^代理销售授权书^效期^售后服务承诺书^法人委托书^质量承诺书^质量承诺书有效期^业务员姓名^业务员授权书有效期^业务员电话"
   s cols="Code^Desc^Tel^ConPerson^CtrlAcct^CrLimit^CategoryId^LstPoDate^Fax^President^Address^ComLic^ComLicDate^RevReg^RevRegDate^MatManLic^MatManLicDate^MatEnrol^MatEnrolDate^Sanitation^SanitationDate^OrgCode^OrgCodeDate^Gsp^GspDate^MatPro^MatProDate^ProPermit^ProPermitDate^ImportEnrol^ImportEnrolDate^ImportLic^ImportLicDate^AgentLic^AgentLicDate^Promises^TrustDeed^Quality^QualityDate^SalesName^SalesNameDate^SalesTel"
	s cnt=$l(cols,"^")
	s ret=0
	f i=1:1:cnt q:ret>0  d
	.i $p(cols,"^",i)=colname s ret=i q
	q ret
}

/// Creator:ZhanMingChao
/// Description:返回汉字的编码信息
/// Input：	HANZI:汉字
/// 			FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码6:五笔码7:区位码8:笔划数9:郑码)
/// 			SPLIT:分割符(可以为空)
/// Output：
/// 	非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
/// 	0：未找到编码信息
/// CreatDate:2011-06-08
/// w ##class(web.DHCINSUPort).GetCNCODE("东华",4,"^")
/// w ##class(web.DHCINSUPort).GetCNCODE("东华",4,"")
ClassMethod GetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
	s Rtnstr="0"
	q:$g(HANZIS)="" Rtnstr
	s Rtnstr=""
	f i=1:1:$l(HANZIS) d
	.s HANZI=$EXTRACT(HANZIS,i)
	.s ASCIICODE=$ASCII(HANZI)
	.i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
	..s rowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
	..s tmpstr=""
	..s:FLAG="" tmpstr=$g(^DHCCharacterEncoding(rowid))
	..s:FLAG'="" tmpstr=$p(^DHCCharacterEncoding(rowid),"^",FLAG)
	..i Rtnstr=""  d
	...s Rtnstr=tmpstr
	..e  d
	...s Rtnstr=Rtnstr_SPLIT_tmpstr
	.e  d
	..s:Rtnstr="" Rtnstr="?"
	..s Rtnstr=Rtnstr_SPLIT_"?"
	q Rtnstr
}

/// 日期处理函数
ClassMethod vDate(d As %String) As %String
{
 n (d)
 q:d="" ""
 i d["-" s d=$zdh(d,3) q d
 i d["/" s d=$zdh(d,4) q d
 i $l(d)=8 s d=$zdh(d,8) q d
 q ""
}

ClassMethod ErrId() As %String
{
	
 s i=$o(^TMP("input_incitm",$j,""),-1)+1	
 q i
}

ClassMethod SetErr(row As %String, errinfo As %String)
{
	n (row,errinfo)
  s ^TMP("input_incitm",$j,..ErrId())="第"_row_"行错误:"_errinfo
}

/// Descript:   保存供应商地址信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
/// Table:APC_Vendor
/// Input:地址,供应商id
/// Output:     
/// Return：
ClassMethod SaveAddress(add As %String, rowid As %String) As %Library.String
{

 n (add,rowid)
 s linenum=$l(add,$c(13,10))
 k ^APC("APCVM",rowid,"ADDR")
 s ^APC("APCVM",rowid,"ADDR",0)=linenum 
 f i=1:1:linenum d
 .s ^APC("APCVM",rowid,"ADDR",i)=$p(add,$c(13,10),i) 
 .
 q
}

}
