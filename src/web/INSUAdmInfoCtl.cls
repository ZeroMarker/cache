Import SQLUser

Class web.INSUAdmInfoCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 55;

/// 保存
ClassMethod Save(InString As %String)
{
	
	n (InString)
	q:InString="" 100
	S ^AAA=InString
	s obj=##class(User.INSUAdmInfo).%New()
	s obj.ActiveFlag=$p(InString,"^",1)    /// 有效标志（Active、Invalid、Logout、Else）
	s obj.AdmCancelNo=$p(InString,"^",2)   /// 冲销流水号
	s obj.AdmDate=$p(InString,"^",3)       /// 入院日期
	s obj.AdmDr=$p(InString,"^",4)         /// 指向PAADM的指针
	s obj.AdmSeriNo=$p(InString,"^",5)   /// 住院流水号
	s obj.AdmTime=$p(InString,"^",6)   /// 入院时间
	s obj.AdmType=$p(InString,"^",7)   /// 入院类别（普通住院、家庭病床等）
	s obj.CardNo=$p(InString,"^",8)   /// 医保卡号
	s obj.DeptDesc=$p(InString,"^",9)   /// 就诊科室名称
	s obj.InsuId=$p(InString,"^",10)   /// 医疗保险号
	s obj.InsuUser=$p(InString,"^",11)   /// 入院登记人
	s obj.IpTimes=+$p(InString,"^",12) /// 住院次数
	s obj.InsuType=$p(InString,"^",13)   /// 医保类别
	
 s obj.CardStatus=$p(InString,"^",14)  /// IC卡状态
 s obj.PatType=$p(InString,"^",15)  /// 工作状态//人员类别
 s obj.States=$p(InString,"^",16)  /// 地区
 s obj.Center=$p(InString,"^",17)  /// 分中心
 s obj.Company=$p(InString,"^",18)  /// 单位
 s obj.Account=+$p(InString,"^",19)  /// 个人帐户余额
	
	d obj.%Save()
 s id=obj.%Id()
 d obj.%Close()
 s AdmRowid=$p(InString,"^",4)
 s AdmReson=""
 &sql(select Rea_Rowid into :AdmReson from PAC_AdmReason where Rea_Code['医保')
 &sql(update PA_ADM set PAADM_AdmReason_DR=:AdmReson where paadm_rowid=:AdmRowid)
 q id
}

/// 按照paadm_Rowid查询、ActiveFlag
ClassMethod QueryByAdm(AdmRowid As %String, ActiveFlag As %String)
{
	n (AdmRowid,ActiveFlag)
	s IndexOfAdm=" "_AdmRowid
	q:AdmRowid="" -1
	q:$d(^DHCINSUAdmInfoI("IndexOfAdm",IndexOfAdm))=0 100
	s InfoId="",flag=""
	f  s InfoId=$o(^DHCINSUAdmInfoI("IndexOfAdm",IndexOfAdm,InfoId),-1) q:(InfoId="")!(flag="A")  d
	.s obj=##class(User.INSUAdmInfo).%OpenId(InfoId)
	.s flag=obj.ActiveFlag
	.d:flag'=ActiveFlag obj.%Close()
	i flag=ActiveFlag {
	  s sActiveFlag=obj.ActiveFlag          /// 有效标志（Active、Invalid、Logout、Else）
	  s sAdmCancelNo=obj.AdmCancelNo       /// 冲销流水号
	  s sAdmDate=obj.AdmDate              /// 入院日期
	  s sAdmDr=obj.AdmDr                /// 指向PAADM的指针
	  s sAdmSeriNo=obj.AdmSeriNo          /// 住院流水号
	  s sAdmTime=obj.AdmTime          /// 入院时间
	  s sAdmType=obj.AdmType          /// 入院类别（普通住院、家庭病床等）
	  s sCardNo=obj.CardNo          /// 医保卡号
	  s sDeptDesc=obj.DeptDesc          /// 就诊科室名称
	  s sInsuId=obj.InsuId           /// 医疗保险号
	  s sInsuUser=obj.InsuUser           /// 入院登记人
	  s sIpTimes=obj.IpTimes         /// 住院次数
	  s sInsuType=obj.InsuType           /// 医保类别
	  s sOutDate=$zd(obj.OutDate,3)
	  s sOutTime=$zt(obj.OutTime)
	  s sOutUser=obj.OutUser
	  s sCardStatus=obj.CardStatus    //IC卡状态
	  s sPatType=obj.PatType         /// 工作状态//人员类别
	  s States=obj.States             /// 地区
	  s Center=obj.Center  /// 分中心
   s Company=obj.Company  /// 单位
   s Account=obj.Account  /// 个人帐户余额
	  d obj.%Close()
	  s OutStr=InfoId_"^"_sActiveFlag_"^"_sAdmCancelNo_"^"_sAdmDate_"^"_sAdmDr_"^"_sAdmSeriNo_"^"_sAdmTime_"^"_sAdmType_"^"_sCardNo_"^"_sDeptDesc_"^"_sInsuId_"^"_sInsuUser_"^"_sIpTimes_"^"_sInsuType_"^"_sOutDate_"^"_sOutTime_"^"_sOutUser_"^"_sCardStatus_"^"_sPatType_"^"_States_"^"_Center_"^"_Company_"^"_Account
	}
	else  {
	  s OutStr=100
		}
	q OutStr
}

/// 按照InfoId查询
ClassMethod Query(InfoId As %String)
{
	n (InfoId)
	q:InfoId="" -1
	s obj=##class(User.INSUAdmInfo).%OpenId(InfoId)	
	s sActiveFlag=obj.ActiveFlag          /// 有效标志（Active、Invalid、Logout、Else）
	s sAdmCancelNo=obj.AdmCancelNo       /// 冲销流水号
	s sAdmDate=obj.AdmDate              /// 入院日期
	s sAdmDr=obj.AdmDr                /// 指向PAADM的指针
	s sAdmSeriNo=obj.AdmSeriNo          /// 住院流水号
	s sAdmTime=obj.AdmTime          /// 入院时间
	s sAdmType=obj.AdmType          /// 入院类别（普通住院、家庭病床等）
	s sCardNo=obj.CardNo          /// 医保卡号
	s sDeptDesc=obj.DeptDesc          /// 就诊科室名称
	s sInsuId=obj.InsuId           /// 医疗保险号
	s sInsuUser=obj.InsuUser           /// 入院登记人
	s sIpTimes=obj.IpTimes         /// 住院次数
	s sInsuType=obj.InsuType           /// 医保类别
	s sOutDate=$zd(obj.OutDate,3)
	s sOutTime=$zt(obj.OutTime)
	s sOutUser=obj.OutUser
	s sCardStatus=obj.CardStatus    //IC卡状态
	s sPatType=obj.PatType         /// 工作状态//人员类别
	s States=obj.States             /// 地区
	s Center=obj.Center  /// 分中心
 s Company=obj.Company  /// 单位
 s Account=obj.Account  /// 个人帐户余额
	d obj.%Close()
	s OutStr=InfoId_"^"_sActiveFlag_"^"_sAdmCancelNo_"^"_sAdmDate_"^"_sAdmDr_"^"_sAdmSeriNo_"^"_sAdmTime_"^"_sAdmType_"^"_sCardNo_"^"_sDeptDesc_"^"_sInsuId_"^"_sInsuUser_"^"_sIpTimes_"^"_sInsuType_"^"_sOutDate_"^"_sOutTime_"^"_sOutUser_"^"_sCardStatus_"^"_sPatType_"^"_States_"^"_Center_"^"_Company_"^"_Account
	q OutStr
}

/// 改写医保入院登记信息
ClassMethod UpdateAdmInfo(AdmInfoRowid As %String, ActiveFlag As %String, UpDateUser As %String)
{
	n (AdmInfoRowid,ActiveFlag,UpDateUser)
	q:(AdmInfoRowid="")!(ActiveFlag="")!(UpDateUser="") -1
	q:$d(^DHCINSUAdmInfoD(AdmInfoRowid))=0 100
	s obj=##class(User.INSUAdmInfo).%OpenId(AdmInfoRowid)
	s obj.OutDate=$p($h,",",1)
	s obj.OutTime=$p($h,",",2)
	s obj.ActiveFlag=ActiveFlag
	s obj.OutUser=UpDateUser
	d obj.%Save()
 d obj.%Close()
	q 0
}

/// 按照PaadmID查询
ClassMethod QueryAdmInfo(PaadmID As %String)
{
	 //n (PaadmID)
	 //s PaadmID=21
	 s PaadmID=" "_PaadmID
	 s outstr=""
	 s RowID = 0
	 q:$d(^DHCINSUAdmInfoI("IndexOfAdm",PaadmID))=0 outstr
	 f  s RowID=$o(^DHCINSUAdmInfoI("IndexOfAdm",PaadmID,RowID)) q:RowID=""  d
  .s flag=$list($g(^DHCINSUAdmInfoD(RowID)),2)
  .i (flag="A")!(flag="O") d
  ..s outstr=..Query(RowID)
	 ;;..;s outstr=$list($g(^DHCINSUAdmInfoD(RowID)),2)_"^"_$list($g(^DHCINSUAdmInfoD(RowID)),4)_"^"_$list($g(^DHCINSUAdmInfoD(RowID)),7)_"^"_$list($g(^DHCINSUAdmInfoD(RowID)),10)_"^"_$list($g(^DHCINSUAdmInfoD(RowID)),6)_"^"_$list($g(^DHCINSUAdmInfoD(RowID)),9)_"^"_$list($g(^DHCINSUAdmInfoD(3)),13)
	 ..s outstr=outstr_"!"_RowID
	 s ^AAA=outstr
	 q outstr
}

ClassMethod UpdateAdmInfoz(AdmInfoRowid As %String, ActiveFlag As %String, UpDateUser As %String, UpInsuUser As %String)
{
	n (AdmInfoRowid,ActiveFlag,UpDateUser,UpInsuUser)
	q:(AdmInfoRowid="")!(ActiveFlag="")!(UpDateUser="")!(UpInsuUser="") -1
	q:$d(^DHCINSUAdmInfoD(AdmInfoRowid))=0 100
	s obj=##class(User.INSUAdmInfo).%OpenId(AdmInfoRowid)
	s obj.OutDate=$p($h,",",1)
	s obj.OutTime=$p($h,",",2)
	s obj.ActiveFlag=ActiveFlag
	s obj.OutUser=UpDateUser
	s obj.InsuUser=UpInsuUser
	s AdmRowid=obj.AdmDr 
	d obj.%Save()
    d obj.%Close()
    i ActiveFlag="I" {	    
	    s AdmReson=""
        &sql(select Rea_Rowid into :AdmReson from PAC_AdmReason where Rea_Code['自费')
        &sql(update PA_ADM set PAADM_AdmReason_DR=:AdmReson where paadm_rowid=:AdmRowid)
    
	    }
	q 0
}

}
