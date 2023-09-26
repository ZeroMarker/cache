Import sqluser

/// Descript:	高值打包收费
/// Creator:    徐超
/// CreateDate: 2015-08-1
Class web.DHCSTMHUI.OeoriBindInci Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	插入DHC_ItmTrack,插入高值中间表
/// Creator:	徐超
/// CreateDate:	2015-08-1
/// Input:		
/// Output:     
/// Return：w ##class(web.DHCSTMHUI.OeoriBindInci).Save("3||236","[{""orirowid"":""22"",""invno"":"""",""invdate"":"""",""invamt"":""0"",""code"":""DZ01189"",""desc"":""自断螺母"",""orddate"":""2020    -03-23"",""ordtime"":""14:15:34"",""qty"":""1"",""uomdr"":""97"",""uomdesc"":"" 个"",""oeori"":""3||236"",""vendordr"":"""",""manfdr"":""1178"",""vendor"":"""", ""manf"":""美国美敦力"",""rp"":""0"",""batno"":""TT223"",""expdate"":""2021-09-1     1"",""sp"":""1470"",""feestatus"":"""",""datecanceled"":"""",""date"":""2020-03-23"",""time"":""14:45:19"",""user"":""dthealth"",""ingno"":"""",""dateofmanu"":"""",""canceled"":"""",""usercanceled"":"""",""timecanceled"":"""",""barcode"":""GZ20200323008"",""inci"":""2943"",""IngrFlag"":"""",""dhcit"":""355"",""specdesc"":"""",""originalcode"":""8"",""IngriModify"":"""",""IngriModifyNo"":""""}]","{""StartDate"":""2019-09-04"",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2"",""LocId"":"""",""EndDate"":""2020-09-21"",""oeorcat"":"""",""oeoriName"":"""",""BarCode"":"""",""PapmiNo"":""""}")
ClassMethod Save(Oeori, ListDetail, Params) As %Library.String
{
	n (Oeori, ListDetail, Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()	
	s ParamObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
    s Sc=ParamObj.%FromJSON(Params)
    i Sc'=0 d
    .s Sc=RtnObj.Err(-1,"","参数解析失败!")
	s DetailObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
    s Sc=DetailObj.%FromJSON(ListDetail)
    i Sc'=0 d
    .s Sc=RtnObj.Err(-1,"","参数解析失败!")
    s HospId=ParamObj.%Get("gHospId") 	s CreateUser=ParamObj.%Get("gUserId") 
	s Date=+$h,Time=$p($h,",",2)
	ts
	While (RtnObj.success=0) {
		s ItmObj=DetailObj.%Pop()
		q:ItmObj=""
		s orirowid=ItmObj.%Get("orirowid")
		s IncId=ItmObj.%Get("inci")
		s Qty=ItmObj.%Get("qty")
		s BatchNo=ItmObj.%Get("batno")
		s Expdate=ItmObj.%Get("expdate")
		s SpecDesc=ItmObj.%Get("specdesc")
		s OriginalCode=ItmObj.%Get("originalcode")
		s OeoriTableFlag=ItmObj.%Get("OeoriTableFlag")
		s OriginalStatus=""
		s:OeoriTableFlag="Y" OriginalStatus="Table"
		s:Expdate'="" Expdate=..DH2L(Expdate)
		s BUomId=$p(^INCI(IncId,1),"^",10)
		i (OriginalCode'="")&&$d(^DHCIT(0,"ORIGINALCODE",OriginalCode)) d
	    .s Sc=RtnObj.Err(-1,"",OriginalCode_"自带码重复!","",0) q
	    s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(IncId)
	    s Manf=$p(ManfInfo,"^",1)
	    s VendorInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(IncId)
	    s Vendor=$p(VendorInfo,"^",1)
	    s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRpOld(IncId,+$h,BUomId,HospId)  ;20170804
	    s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncId,..sssCode())
	    s ScgId=$p(ScgInfo,"^",5)
	    s LocId=$p(^OEORD(+Oeori,"I",$P(Oeori,"||",2),3),"^",6)
	    s BarCodeParam=ScgId_"^"_LocId
	    i orirowid="" d 
	    .f j=1:1:Qty q:RtnObj.success'=0  d
 	    ..s BarCode=##class(web.DHCSTMHUI.DHCItmTrack).CreateBarCode(BarCodeParam)
		..i BarCode=""  d RtnObj.Err(-2,"","注册条码失败!") q
 	    ..&sql(select %id from DHC_ItmTrack where DHCIT_Label=:BarCode or DHCIT_OriginalCode=:BarCode)
 	    ..i (SQLCODE=0) s BarCode=""
 	    ..i BarCode=""  d RtnObj.Err(-2,"","注册条码失败!") q
 	    ..s obj=##class(User.DHCItmTrack).%New()
 	    ..s obj.DHCITINCIDR=##class(User.INCItm).%OpenId(IncId,0)
 	    ..s obj.DHCITLabel=BarCode
 	    ..s obj.DHCITDate=Date
 	    ..s obj.DHCITTime=Time
 	    ..s obj.DHCITSSUSRDR = ##class(User.SSUser).%OpenId(CreateUser)
 	    ..s obj.DHCITBatchNo=BatchNo
 	    ..s obj.DHCITExpDate=Expdate
 	    ..s obj.DHCITSpecList=SpecDesc
 	    ..s obj.DHCITPHMNFDR=##class(User.PHManufacturer).%OpenId(Manf)
 	    ..s obj.DHCITAPCVMDR=##class(User.APCVendor).%OpenId(Vendor)
 	    ..s obj.DHCITRealPrice=Rp
 	    ..s obj.DHCITOriginalCode=OriginalCode
 	    ..i OriginalStatus'="" s obj.DHCITOriginalStatus=OriginalStatus
 	    ..s sc=obj.%Save()
 	    ..i $$$ISERR(sc) d
 	    ...s Sc=RtnObj.Err(-2,"","更新失败!") q
 	    ..s dhcit=obj.%Id()
 	    ..s ret=..InsertHV(Oeori,dhcit,HospId)
 	    ..i ret<0 d
 	    ...s Sc=RtnObj.Err(-1,"","保存失败!") q
 	    ..s ret=..InsertTrack(Oeori,dhcit,CreateUser,BarCode)
 	    ..i ret<0 d
 	    ...s Sc=RtnObj.Err(-1,"","保存失败!") q
	    e  d
	    .&sql(select ORI_BarCode,ORI_IngrFlag  into :Barcode,:IngrFlag from DHC_HVMat_OrdItm where ORI_RowId=:orirowid)
	    .i IngrFlag="Y" d
	    ..s Sc=RtnObj.Err(-1,"","条码已经生成入库单!","",0) q
	    .&sql(update DHC_ItmTrack set DHCIT_BatchNo=:BatchNo,DHCIT_ExpDate=:Expdate,DHCIT_SpecList=:SpecDesc,DHCIT_OriginalCode=:OriginalCode where DHCIT_Label=:Barcode)
	    .&sql(update DHC_HVMat_OrdItm set ORI_BatNo=:BatchNo,ORI_ExpDate=:Expdate where ORI_RowId=:orirowid)
 	    q:RtnObj.success'=0
		
	}	
	i RtnObj.success'=0 tro  q RtnObj.Json()
    tc
    q RtnObj.Json()
}

/// 插入一条提取表DHC_HVMat_OrdItm记录
ClassMethod InsertHV(oeori As %String, dhcit As %String, HospId As %String = "") As %String
{
	n (oeori,dhcit,HospId)
	// 插入到中间表(物资发放)
  s batno="", expdate="",manf="",vendor="",inci="",barcode="",userid="",rp="",specdesc=""
  &sql(select DHCIT_INCI_DR,DHCIT_Label,DHCIT_SSUSR_DR,DHCIT_APCVM_DR,
  DHCIT_PHMNF_DR,DHCIT_RealPrice,DHCIT_BatchNo,DHCIT_ExpDate,DHCIT_SpecList
  into :inci,:barcode,:userid,:vendor,:manf,:rp,:batno,:expdate,:specdesc
  from dhc_itmtrack where DHCIT_Rowid=:dhcit)
  
  s:expdate'="" expdate=$zd(expdate,3)
  s ord=$p(oeori,"||",1)
  s itm=$p(oeori,"||",2)
  s buomDr=$p(^INCI(inci,1),"^",10)
  s confqty=1
  s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)					
  s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,sttdate,buomDr,HospId)
  s $p(data,"^",1)=""
  s $p(data,"^",2)=oeori
  s $p(data,"^",3)=""
  s $p(data,"^",4)=""
  s $p(data,"^",5)=""
  s $p(data,"^",6)=""  //收费状态
  s $p(data,"^",7)=""   //收费金额
  s admLoc=""
  &sql(select oeori_admloc_dr into :admLoc from oe_orditem where %id=:oeori)
  s $p(data,"^",8)=admLoc
  s $p(data,"^",9)=userid
  s $p(data,"^",10)=""
  s $p(data,"^",11)=batno
  s $p(data,"^",12)=manf
  s $p(data,"^",13)=vendor
  s $p(data,"^",14)=buomDr
  s $p(data,"^",15)=confqty
  s $p(data,"^",16)=rp
  s $p(data,"^",17)=sp
  s $p(data,"^",18)=barcode
  s canceled="",invno="",invdate="",invamt="",ingri=""
  s remark="高值材料打包收费"
  s $p(data,"^",19)=expdate
  s $p(data,"^",20)=canceled  //取消标志
  s $p(data,"^",21)=invno
  s $p(data,"^",22)=invdate
  s $p(data,"^",23)=invamt
  s $p(data,"^",24)=inci
  s $p(data,"^",25)=remark
  s $p(data,"^",26)=ingri
  s ret=##class(web.DHCSTMHUI.HVMatOrdItm).Update(data)
  q ret
}

/// 插入追踪录
ClassMethod InsertTrack(oeori As %String, dhcit As %String, user As %String, barcode As %String) As %String
{
	// 插入到中间表(物资发放)
	n (dhcit,oeori,user,barcode)
	s err=1
	s ord=$p(oeori,"||",1)
	s itm=$p(oeori,"||",2)
	q:(ord="")!(itm="") -1
	q:'$d(^OEORD(ord,"I",itm)) -1

	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s intrType=$p(IntrTypeInfo,"^",1)
	;记录高值跟踪信息
	s operData="^"_user_"^"_""_"^^^^"
	s ret=##class(web.DHCSTMHUI.DHCItmTrack).Update(intrType,oeori,barcode,operData)
	i +ret<0 s err=-9 
	q:err<0 err
	s BarCodeStr=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(intrType,oeori)
	s BarCodeStr=$tr(BarCodeStr,"^","#")	;补充处理一下
	s $p(^OEORD($P(oeori,"||"),"I",$P(oeori,"||",2),"DHC"),"^",14)=BarCodeStr
	q err
}

/// Descript:	删除记录
/// Creator:	徐超
/// CreateDate:	2015-08-01
/// Input:		
/// Output:     
/// Return：	
ClassMethod Delete(hvm As %String) As %Library.String
{
	n (hvm)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	i hvm="" s Sc=RtnObj.Err(-1,"","入参不能为空!","",0)
 	q:RtnObj.success'=0 RtnObj.Json()
	s HVBarCode=""
	
	&sql(select ORI_BarCode into :HVBarCode from DHC_HVMat_OrdItm where ORI_RowId=:hvm)
	q:HVBarCode="" -2
	ts
	&sql(delete from DHC_HVMat_OrdItm where ORI_RowId=:hvm)
	i SQLCODE'=0 d RtnObj.Err(-3,"","删除失败") q
	i RtnObj.success<0 tro  q RtnObj.Json()
	&sql(delete from DHC_ItmTrack where DHCIT_Label=:HVBarCode)
	i SQLCODE'=0 d RtnObj.Err(-4,"","删除失败") q
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.OeoriBindInci","QueryItem","{""Oeori"":""3||236""}")
Query QueryItem(Params As %String) As Query(ROWSPEC = "orirowid,invno,invdate,invamt:%Float,code,desc,orddate,ordtime,qty:%Float,uomdr,uomdesc,oeori,vendordr,manfdr,vendor,manf,rp:%Float,batno,expdate,sp,feestatus,datecanceled,date,time,user,ingno,dateofmanu,canceled,usercanceled,datecanceled,timecanceled,barcode,inci,IngrFlag,dhcit,vendordr,specdesc,originalcode,IngriModify,IngriModifyNo") [ SqlProc ]
{
}

ClassMethod QueryItemExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle, Params)
	s ^TMPHOUS("faf")=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
    s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s Oeori=PJobj.%Get("Oeori")
	i Oeori=""  q $$$OK
	
	s Ord=$p(Oeori,"||",1),Itm=$p(Oeori,"||",2)
	i (Ord="")||(Itm="")||('$d(^OEORD(Ord,"I",Itm))) w NullResult q
	s OeoriArcim=$p(^OEORD(Ord,"I",Itm,1),"^",2)
	
	s sqlStr = "select * from DHC_HVMat_OrdItm where ORI_OEORI_DR='"_Oeori_"'"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s orirowid = result.Data("ORI_RowId")
		s oeori = result.Data("ORI_OEORI_DR")
		s orddate = result.Data("ORI_OEORI_Date")
		s:orddate'="" orddate=..DL2H(orddate)
		s ordtime = result.Data("ORI_OEORI_Time")
		s:ordtime'="" ordtime=..TL2H(ordtime)
		s feestatus = result.Data("ORI_FeeStatus")
		s feeamt = result.Data("ORI_FeeAmt")
		continue:'$d(^OEORD(+oeori,"I",$p(oeori,"||",2)))

		s date = result.Data("ORI_Date")
		s time = result.Data("ORI_Time")
		s:date'="" date=..DL2H(date)
		s:time'="" time=..TL2H(time)
		s userdr = result.Data("ORI_SSUSR_DR")
		s scg = result.Data("ORI_SCG_DR")
		
		s ingri = result.Data("ORI_INGRI_DR")
		s ingr=$p(ingri,"||",1)
		continue:(ingr'="")&&('$d(^DHCINGR(+ingr)))
		s ingno=""
		i ingr'="" s ingno=$p(^DHCINGR(ingr),"^",1)
		
		s batno = result.Data("ORI_BatNo")
		s expdate = result.Data("ORI_ExpDate")
		s:expdate'="" expdate=..DL2H(expdate)
		s dateofmanu = result.Data("ORI_DateOfManu")
		s:dateofmanu'="" dateofmanu=..DL2H(dateofmanu)
		s manfdr = result.Data("ORI_MANF_DR")
		s vendordr = result.Data("ORI_APCVM_DR")
		s uomdr = result.Data("ORI_Unit_DR")
		s qty = result.Data("ORI_Qty")
		s rp = result.Data("ORI_Rp")
		s sp = result.Data("ORI_Sp")
		s rpamt = result.Data("ORI_RpAmt")
		s spamt = result.Data("ORI_SpAmt")
		s barcode = result.Data("ORI_BarCode")
		s canceled = result.Data("ORI_Canceled")
		s usercanceled = result.Data("ORI_UserCanceled_DR")
		s datecanceled = result.Data("ORI_DateCanceled")
		s timecanceled = result.Data("ORI_TimeCanceled")
		s:datecanceled'="" datecanceled=..DL2H(datecanceled)
		s:timecanceled'="" timecanceled=..TL2H(timecanceled)
		s invno = result.Data("ORI_InvNo")
		s invdate = result.Data("ORI_InvDate")
		s:invdate'="" invdate=..DL2H(invdate)
		s invamt = result.Data("ORI_InvAmt")
		s:invamt="" invamt=rpamt			;缺省
		s inci = result.Data("ORI_INCI_DR")
		continue:inci=""
		continue:##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPackChargeFlag(inci)="Y"   ////过滤包
		s Arcim=$p(^INCI(inci,1),"^",3)
		continue:(Arcim=OeoriArcim)				;与医嘱相同的arcim,过滤
		s IngrFlag = result.Data("ORI_IngrFlag")
		s IngriModify=result.Data("ORI_Ingri_Modify_DR")						;补录入库子表dr
		s IngriModifyNo=""
		s:+IngriModify'=0 IngriModifyNo=$p($g(^DHCINGR(+IngriModify)),"^",1)	;补录入库单单号

		s code=$p(^INCI(inci,1),"^",1) ;物资名称
		s desc=$p(^INCI(inci,1),"^",2) ;物资名称
		
		s (manf,vendor,user,usercanceled,uomdesc)=""
		s:manfdr'="" manf=$p(^PHMNF(manfdr),"^",2)
		s:vendordr'="" vendor=$p(^APC("APCVM",vendordr),"^",3)
		i userdr'="" s user=$p($g(^SSU("SSUSR",userdr)),"^",2 )
		i usercanceled'="" s usercanceled=$p($g(^SSU("SSUSR",userdr)),"^",2)
		i uomdr'="" s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2)
		
		s dhcit="",specdesc="",originalcode=""
		s:barcode'="" dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
		s:dhcit'="" specdesc=$P(^DHCIT(dhcit),"^",19)
		s:dhcit'="" originalcode=$P(^DHCIT(dhcit),"^",13)	
		d OutPutRow
	}
	d result.Close()
	Quit $$$OK

OutPutRow
	s Data=$lb(orirowid,invno,invdate,invamt,code,desc,orddate,ordtime,qty,uomdr,uomdesc,oeori,vendordr,manfdr,vendor,manf,rp,batno,expdate,sp,feestatus,datecanceled,date,time,user,ingno,dateofmanu,canceled,usercanceled,datecanceled,timecanceled,barcode,inci,IngrFlag,dhcit,vendordr,specdesc,originalcode,IngriModify,IngriModifyNo)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
