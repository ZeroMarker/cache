///获取控件元素必填控制信息,控件id必须跟维护的信息一模一样,区分大小写
///在 基础字典必填项维护 菜单里面维护
///20170324
///lihui
function getElementInfo(elements,cspname,chargeflag) 
{
  if ((elements=="")||(elements==null)||(cspname=="")||(cspname==null)){
      return;
  }
  var elemarr=elements.split("^");
  if (elemarr.length > 0)
	  {
		    var incicode=elemarr[0];
		    if (incicode!="")
			{var incicode=Ext.getCmp(incicode).getValue();} //物资代码
		    var incidesc=elemarr[1];
		    if (incidesc!="")
			{var incidesc=Ext.getCmp(incidesc).getValue();} //物资名称
		    var incictuom=elemarr[2];
		    if (incictuom!="")
			{var INCICTUom=Ext.getCmp(incictuom).getValue();} //基本单位
		    var puctuompurch=elemarr[3];
		    if (stkcat!="")
			{var PUCTUomPurch=Ext.getCmp(puctuompurch).getValue();} //入库单位id
		    var stkcat=elemarr[4];
			if (stkcat!="")
			{var StkCat=Ext.getCmp(stkcat).getValue();} //库存分类id
			var stkgrptype=elemarr[5];
			if (stkgrptype!="")
			{var StkGrpType=Ext.getCmp(stkgrptype).getValue();} //类组
			var istrfflag=elemarr[6];
			if (istrfflag!="")
			{var INCIIsTrfFlag=Ext.getCmp(istrfflag).getValue();} //转移方式
			var batchreq=elemarr[7];
			if (batchreq!="")
			{var INCIBatchReq=Ext.getCmp(batchreq).getValue();} //是否要求批次
			var expreqnew=elemarr[8];
			if (expreqnew!="")
			{var INCIExpReqnew=Ext.getCmp(expreqnew).getValue();} //是否要求效期
			var alias=elemarr[9];
			if (alias!="")
			{var INCAlias=Ext.getCmp(alias).getValue();} //别名
			var notuseflag=elemarr[10];
			if (notuseflag!="")
			{var INCINotUseFlag=Ext.getCmp(notuseflag).getValue();} //不可用标志
			var reportingdays=elemarr[11];
			if (reportingdays!="")
			{var INCIReportingDays=Ext.getCmp(reportingdays).getValue();} //协和码
			var incibarcode=elemarr[12];
			if (incibarcode!="")
			{var INCIBarCode=Ext.getCmp(incibarcode).getValue();} //条码
			var bsppuruom=elemarr[13];
			if (bsppuruom!="")
			{var INCIBSpPuruom=Ext.getCmp(bsppuruom).getValue();} //售价
			var brppuruom=elemarr[14];
			if (brppuruom!="")
			{var INCIBRpPuruom=Ext.getCmp(brppuruom).getValue();} //进价
			var supplyloc=elemarr[15];
			if (supplyloc!="")
			{var supplyLocField=Ext.getCmp(supplyloc).getValue();} //供应仓库
			var reqtype=elemarr[16];
			if (reqtype!="")
			{var reqType=Ext.getCmp(reqtype).getValue();} //物资请求类型
			var remark=elemarr[17];
			if (remark!="")
			{var remark=Ext.getCmp(remark).getValue();} //备注
			var preexpdate=elemarr[18];
			if (preexpdate!="")
			{var PreExeDate=Ext.getCmp(preexpdate).getValue();} //价格生效日期
			var infospec=elemarr[19];
			if (infospec!="")
			{var INFOSpec=Ext.getCmp(infospec).getValue();} //规格
			var infoimportfalg=elemarr[20];
			if (infoimportfalg!="")
			{var INFOImportFlag=Ext.getCmp(infoimportfalg).getValue();} //进口标志
			var qualitylevel=elemarr[21];
			if (qualitylevel!="")
			{var INFOQualityLevel=Ext.getCmp(qualitylevel).getValue();} //质量层次
			var qualityno=elemarr[22];
			if (qualityno!="")
			{var INFOQualityNo=Ext.getCmp(qualityno).getValue();} //质量编号
			var comfrom=elemarr[23];
			if (comfrom!="")
			{var INFOComFrom=Ext.getCmp(comfrom).getValue();} //国/省别
			var cergeno=elemarr[24];
			if (cergeno!="")
			{var INFORemark2=Ext.getCmp(cergeno).getValue();} //注册证号
			var highprice=elemarr[25];
			if (highprice!="")
			{var INFOHighPrice=Ext.getCmp(highprice).getValue();} //高值类标志
			var infomt=elemarr[26];
			if (infomt!="")
			{var INFOMT=Ext.getCmp(infomt).getValue();} //定价类型id
			var maxsp=elemarr[27];
			if (maxsp!="")
			{var INFOMaxSp=Ext.getCmp(maxsp).getValue();} //最高售价
			var inhosflag=elemarr[28];
			if (inhosflag!="")
			{var INFOInHosFlag=Ext.getCmp(inhosflag).getValue();} //本院物资目录
			var pbflag=elemarr[29];
			if (pbflag!="")
			{var INFOPbFlag=Ext.getCmp(pbflag).getValue();} //招标标志
			var pbrp=elemarr[30];
			if (pbrp!="")
			{var INFOPbRp=Ext.getCmp(pbrp).getValue();} //招标进价
			var pblevel=elemarr[31];
			if (pblevel!="")
			{var INFOPBLevel=Ext.getCmp(pblevel).getValue();} //招标级别
			var pbvendor=elemarr[32];
			if (pbvendor!="")
			{var INFOPbVendor=Ext.getCmp(pbvendor).getValue();} //招标供应商id
			var pbmanf=elemarr[33];
			if (pbmanf!="")
			{var INFOPbManf=Ext.getCmp(pbmanf).getValue();} //招标生产商id
			var pbcarrier=elemarr[34];
			if (pbcarrier!="")
			{var INFOPbCarrier=Ext.getCmp(pbcarrier).getValue();} //招标配送商id
			var pbldr=elemarr[35];
			if (pbldr!="")
			{var INFOPBLDR=Ext.getCmp(pbldr).getValue();} //招标名称
			var baflag=elemarr[36];
			if (baflag!="")
			{var INFOBAflag=Ext.getCmp(baflag).getValue();} //一次性标志
			var expirelen=elemarr[37];
			if (expirelen!="")
			{var INFOExpireLen=Ext.getCmp(expirelen).getValue();} //效期长度
			var prcfile=elemarr[38];
			if (prcfile!="")
			{var INFOPrcFile=Ext.getCmp(prcfile).getValue();} //物价文件号
			var pricebakday=elemarr[39];
			if (pricebakday!="")
			{var INFOPriceBakD=Ext.getCmp(pricebakday).getValue();} //物价文件备案时间
			var certexpdate=elemarr[40];
			if (certexpdate!="")
			{var IRRegCertExpDate=Ext.getCmp(certexpdate).getValue();} //注册证日期
			var bcdr=elemarr[41];
			if (bcdr!="")
			{var INFOBCDr=Ext.getCmp(bcdr).getValue();} //帐簿分类id
			var drugbasecode=elemarr[42];
			if (drugbasecode!="")
			{var INFODrugBaseCode=Ext.getCmp(drugbasecode).getValue();} //物资本位码
			var packuom=elemarr[43];
			if (packuom!="")
			{var PackUom=Ext.getCmp(packuom).getValue();} //大包装单位
			var packuomfac=elemarr[44];
			if (packuomfac!="")
			{var PackUomFac=Ext.getCmp(packuomfac).getValue();} //大包装单位系数
			var highriskflag=elemarr[45];
			if (highriskflag!="")
			{var HighRiskFlag=Ext.getCmp(highriskflag).getValue();} //高危标志
			var notusereason=elemarr[46];
			if (notusereason!="")
			{var ItmNotUseReason=Ext.getCmp(notusereason).getValue();} //不可用原因
			var phcdofficialtype=elemarr[47];
			if (phcdofficialtype!="")
			{var PHCDOfficialType=Ext.getCmp(phcdofficialtype).getValue();} //医保类别
			var brand=elemarr[48];
			if (brand!="")
			{var INFOBrand=Ext.getCmp(brand).getValue();} //品牌
			var model=elemarr[49];
			if (model!="")
			{var INFOModel=Ext.getCmp(model).getValue();} //型号
			var chargeflag=elemarr[50];
			if (chargeflag!="")
			{var INFOChargeFlag=Ext.getCmp(chargeflag).getValue();} //收费标志
			var abbrev=elemarr[51];
			if (abbrev!="")
			{var INFOAbbrev=Ext.getCmp(abbrev).getValue();} //简称
			var supervision=elemarr[52];
			if (supervision!="")
			{var INFOSupervision=Ext.getCmp(supervision).getValue();} //监管级别
			var implantationmat=elemarr[53];
			if (implantationmat!="")
			{var INFOImplantationMat=Ext.getCmp(implantationmat).getValue();} //植入标志
			var nolocreq=elemarr[54];
			if (nolocreq!="")
			{var INFONoLocReq=Ext.getCmp(nolocreq).getValue();} //禁止请领标志
			var steriledatelen=elemarr[55];
			if (steriledatelen!="")
			{var INFOSterileDateLen=Ext.getCmp(steriledatelen).getValue();} //灭菌时间
			var zerostk=elemarr[56];
			if (zerostk!="")
			{var INFOZeroStk=Ext.getCmp(zerostk).getValue();} //零库存标志
			var chargetype=elemarr[57];
			if (chargetype!="")
			{var INFOChargeType=Ext.getCmp(chargetype).getValue();} //收费类型
			var medeqptcat=elemarr[58];
			if (medeqptcat!="")
			{var INFOMedEqptCat=Ext.getCmp(medeqptcat).getValue();} //器械分类
			var packcharge=elemarr[59];
			if (packcharge!="")
			{var INFOPackCharge=Ext.getCmp(packcharge).getValue();} //打包标志
			var irregcertdateofissue=elemarr[60];
			if (irregcertdateofissue!="")
			{var IRRegCertDateOfIssue=Ext.getCmp(irregcertdateofissue).getValue();} //注册证发证日期
			var irregcertitmdesc=elemarr[61];
			if (irregcertitmdesc!="")
			{var IRRegCertItmDesc=Ext.getCmp(irregcertitmdesc).getValue();} //注册证名称
			var irregcertexpdateextended=elemarr[62];
			if (irregcertexpdateextended!="")
			{var IRRegCertExpDateExtended=Ext.getCmp(irregcertexpdateextended).getValue();}//注册证延长效期
			var biddate=elemarr[63];
			if (biddate!="")
			{var BidDate=Ext.getCmp(biddate).getValue();} //招标日期
			var origin=elemarr[64];
			if (origin!="")
			{var Origin=Ext.getCmp(origin).getValue();} //产地
			var firstreqdept=elemarr[65];
			if (firstreqdept!="")
			{var FirstReqDept=Ext.getCmp(firstreqdept).getValue();} //首请部门
			var scategory=elemarr[66];
			if (scategory!="")
			{var SCategory=Ext.getCmp(scategory).getValue();} //灭菌分类
			var matquality=elemarr[67];
			if (matquality!="")
			{var MatQuality=Ext.getCmp(matquality).getValue();} //质地
			var hospzerostk=elemarr[68];
			if (hospzerostk!="")
			{var HospZeroStk=Ext.getCmp(hospzerostk).getValue();} //院区零库存
			var arcimcode=elemarr[69];
			if (arcimcode!="")
			{var ARCIMCode=Ext.getCmp(arcimcode).getValue();} //医嘱代码
			var arcimdesc=elemarr[70];
			if (arcimdesc!="")
			{var ARCIMDesc=Ext.getCmp(arcimdesc).getValue();} //医嘱名称
			var arcimuomdr=elemarr[71];
			if (arcimuomdr!="")
			{var ARCIMUomDR=Ext.getCmp(arcimuomdr).getValue();} //计价单位
			var ordercategory=elemarr[72];
			if (ordercategory!="")
			{var OrderCategory=Ext.getCmp(ordercategory).getValue();} //医嘱大类
			var arcitemcat=elemarr[73];
			if (arcitemcat!="")
			{var ARCItemCat=Ext.getCmp(arcitemcat).getValue();} //医嘱子类
			var arcbillgrp=elemarr[74];
			if (arcbillgrp!="")
			{var ARCBillGrp=Ext.getCmp(arcbillgrp).getValue();} //费用大类
			var arcbillsub=elemarr[75];
			if (arcbillsub!="")
			{var ARCBillSub=Ext.getCmp(arcbillsub).getValue();} //费用子类
			var arcimorderonitsown=elemarr[76];
			if (arcimorderonitsown!="")
			{var ARCIMOrderOnItsOwn=Ext.getCmp(arcimorderonitsown).getValue();} //独立医嘱
			var oecpriority=elemarr[77];
			if (oecpriority!="")
			{var OECPriority=Ext.getCmp(oecpriority).getValue();} //医嘱优先级
			var wostockflag=elemarr[78];
			if (wostockflag!="")
			{var WoStockFlag=Ext.getCmp(wostockflag).getValue();} //无库存医嘱
			var arcimtext1=elemarr[79];
			if (arcimtext1!="")
			{var ARCIMText1=Ext.getCmp(arcimtext1).getValue();} //医保名称
			var arcalias=elemarr[80];
			if (arcalias!="")
			{var ARCAlias=Ext.getCmp(arcalias).getValue();} //别名
			var arcimabbrev=elemarr[81];
			if (arcimabbrev!="")
			{var ARCIMAbbrev=Ext.getCmp(arcimabbrev).getValue();} //缩写
			var phcdofficialtype=elemarr[82];
			if (phcdofficialtype!="")
			{var PHCDOfficialType=Ext.getCmp(phcdofficialtype).getValue();} //医保类别
			var arcimnoofcumdays=elemarr[83];
			if (arcimnoofcumdays!="")
			{var ARCIMNoOfCumDays=Ext.getCmp(arcimnoofcumdays).getValue();} //限制使用天数
			var arcimoemessage=elemarr[84];
			if (arcimoemessage!="")
			{var ARCIMOEMessage=Ext.getCmp(arcimoemessage).getValue();} //医嘱提示
			var billnotactive=elemarr[85];
			if (billnotactive!="")
			{var BillNotActive=Ext.getCmp(billnotactive).getValue();} //不维护收费项
			var billcode=elemarr[86];
			if (billcode!="")
			{var BillCode=Ext.getCmp(billcode).getValue();} //收费项代码
			var billname=elemarr[87];
			if (billname!="")
			{var BillName=Ext.getCmp(billname).getValue();} //收费项名称
			var subtypefee=elemarr[88];
			if (subtypefee!="")
			{var SubTypeFee=Ext.getCmp(subtypefee).getValue();} //子分类
			var insubtypefee=elemarr[89];
			if (insubtypefee!="")
			{var InSubTypeFee=Ext.getCmp(insubtypefee).getValue();} //住院子分类
			var outsubtypefee=elemarr[90];
			if (outsubtypefee!="")
			{var OutSubTypeFee=Ext.getCmp(outsubtypefee).getValue();} //门诊子分类
			var accsubtypefee=elemarr[91];
			if (accsubtypefee!="")
			{var AccSubTypeFee=Ext.getCmp(accsubtypefee).getValue();} //核算子分类
			var medsubtypefee=elemarr[92];
			if (medsubtypefee!="")
			{var MedSubTypeFee=Ext.getCmp(medsubtypefee).getValue();} //病历首页子分类
			var newmedsubtypefee=elemarr[93];
			if (newmedsubtypefee!="")
			{var NewMedSubTypeFee=Ext.getCmp(newmedsubtypefee).getValue();} //新病历首页子分类
			var accountsubtypefee=elemarr[94];
			if (accountsubtypefee!="")
			{var AccountSubTypeFee=Ext.getCmp(accountsubtypefee).getValue();} //会计子分类
			var medpromaintain=elemarr[95];
			if (medpromaintain!="")
			{var MedProMaintain=Ext.getCmp(medpromaintain).getValue();} //维护医保项
			var arcimeffdate=elemarr[96];
			if (arcimeffdate!="")
			{var ARCIMEffDate=Ext.getCmp(arcimeffdate).getValue();} //生效日期
			var arcimeffdateto=elemarr[97];
			if (arcimeffdateto!="")
			{var ARCIMEffDateTo=Ext.getCmp(arcimeffdateto).getValue();} //截止日期
            var arcsppuruom=elemarr[98];
            if (arcsppuruom!="")
			{var ArcSpPuruom=Ext.getCmp(arcsppuruom).getValue();} //售价(医嘱)
            var arcpreexedate=elemarr[99];
			if (arcpreexedate!="")
			{var ArcPreExeDate=Ext.getCmp(arcpreexedate).getValue();} //价格生效日期(医嘱)
			var arciminfomt=elemarr[100];
			if (arciminfomt!="")
			{var ArcimINFOMT=Ext.getCmp(arciminfomt).getValue();} //定价类型(医嘱)
			var arcimrppuruom=elemarr[101];
			if (arcimrppuruom!="")
			{var ArcimRpPuruom=Ext.getCmp(arcimrppuruom).getValue();} //进价(医嘱)
			
			
			
            

		  var elemflags=tkMakeServerCall("web.DHCSTM.InciInfoMustInput","getElemetstrflag",elements,cspname);
		  var elemflagarr=elemflags.split("^");
		  if (elemflagarr.length>0)
		  {
			  //库存项信息
			  var incicodeflag=elemflagarr[0];
			  if ((incicodeflag=="Y")&&((incicode==null)||(incicode==""))){
				  Msg.info("warning","物资代码不可以为空!");
				  return false;
			     }
			  var incidescflag=elemflagarr[1];
			  if ((incidescflag=="Y")&&((incidesc==null)||(incidesc==""))){
				  Msg.info("warning","物资名称不可以为空!");
				  return false;
			     }
			  var incictuomflag=elemflagarr[2];
			  if ((incictuomflag=="Y")&&((INCICTUom==null)||(INCICTUom==""))){
				  Msg.info("warning","基本单位不可以为空!");
				  return false;
			     }
			  var puctuompurchflag=elemflagarr[3];
			  if ((puctuompurchflag=="Y")&&((PUCTUomPurch==null)||(PUCTUomPurch==""))){
				  Msg.info("warning","入库单位不可以为空!");
				  return false;
			     }
			  var stkcatflag=elemflagarr[4];
			  if ((stkcatflag=="Y")&&((StkCat==null)||(StkCat==""))){
				  Msg.info("warning","库存分类不可以为空!");
				  return false;
			     }
			  var stkgrptypeflag=elemflagarr[5];
			  if ((stkgrptypeflag=="Y")&&((StkGrpType==null)||(StkGrpType==""))){
				  Msg.info("warning","类组不可以为空!");
				  return false;
			     }
			  var istrfflagflag=elemflagarr[6];
			  var batchreqflag=elemflagarr[7];
			  var expreqnewflag=elemflagarr[8];
			  var aliasflag=elemflagarr[9];
			  var notuseflagflag=elemflagarr[10];
			  var reportingdaysflag=elemflagarr[11];
			  if ((reportingdaysflag=="Y")&&((INCIReportingDays==null)||(INCIReportingDays==""))){
				  Msg.info("warning","协和码不可以为空!");
				  return false;
			     }
			  var incibarcodeflag=elemflagarr[12];
			  if ((incibarcodeflag=="Y")&&((INCIBarCode==null)||(INCIBarCode==""))){
				  Msg.info("warning","条码不可以为空!");
				  return false;
			     }
			  var bsppuruomflag=elemflagarr[13];
			  if ((bsppuruomflag=="Y")&&((INCIBSpPuruom===null)||(INCIBSpPuruom===""))){
				  Msg.info("warning","售价不可以为空!");
				  return false;
			     }
			  var brppuruomflag=elemflagarr[14];
			  if ((brppuruomflag=="Y")&&((INCIBRpPuruom===null)||(INCIBRpPuruom===""))){
					  Msg.info("warning","进价不可以为空!");
					  return false;
				  }
			  var supplylocflag=elemflagarr[15];
			  if ((supplylocflag=="Y")&&((supplyLocField==null)||(supplyLocField==""))){
				  Msg.info("warning","供应仓库不可以为空!");
				  return false;
			     }
			  var reqtypeflag=elemflagarr[16];
			  if ((reqtypeflag=="Y")&&((reqType==null)||(reqType==""))){
				  Msg.info("warning","物资请求类型不可以为空!");
				  return false;
			     }
			  var remarkflag=elemflagarr[17];
			  var preexpdateflag=elemflagarr[18];
			  var infospecflag=elemflagarr[19];
			  if ((infospecflag=="Y")&&((INFOSpec==null)||(INFOSpec==""))){
				  Msg.info("warning","规格不可以为空!");
				  return false;
			     }
			  var infoimportfalgflag=elemflagarr[20];
			  if ((infoimportfalgflag=="Y")&&((INFOImportFlag==null)||(INFOImportFlag==""))){
				  Msg.info("warning","进口标志不可以为空!");
				  return false;
			     }
			  var qualitylevelflag=elemflagarr[21];
			  if ((qualitylevelflag=="Y")&&((INFOQualityLevel==null)||(INFOQualityLevel==""))){
				  Msg.info("warning","质量层次不可以为空!");
				  return false;
			     }
			  var qualitynoflag=elemflagarr[22];
			  if ((qualitynoflag=="Y")&&((INFOQualityNo==null)||(INFOQualityNo==""))){
				  Msg.info("warning","质量编号不可以为空!");
				  return false;
			     }
			  var comfromflag=elemflagarr[23];
			  if ((comfromflag=="Y")&&((INFOComFrom==null)||(INFOComFrom==""))){
				  Msg.info("warning","国/省别不可以为空!");
				  return false;
			     }
			  var cergenoflag=elemflagarr[24];
			  if ((cergenoflag=="Y")&&((INFORemark2==null)||(INFORemark2==""))){
				  Msg.info("warning","注册证号不可以为空!");
				  return false;
			     }
			  var highpriceflag=elemflagarr[25];
			  var infomtflag=elemflagarr[26];
			  if ((infomtflag=="Y")&&((INFOMT==null)||(INFOMT==""))){
				  Msg.info("warning","定价类型不可以为空!");
				  return false;
			     }
			  var maxspflag=elemflagarr[27];
			  if ((maxspflag=="Y")&&((INFOMaxSp===null)||(INFOMaxSp===""))){
				  Msg.info("warning","最高售价不可以为空!");
				  return false;
			     }
			  var inhosflagflag=elemflagarr[28];
			  var pbflagflag=elemflagarr[29];
			  var pbrpflag=elemflagarr[30];
			  if ((pbrpflag=="Y")&&((INFOPbRp===null)||(INFOPbRp===""))){
				  Msg.info("warning","招标进价不可以为空!");
				  return false;
			     }
			  var pblevelflag=elemflagarr[31];
			  if ((pblevelflag=="Y")&&((INFOPBLevel==null)||(INFOPBLevel==""))){
				  Msg.info("warning","招标级别不可以为空!");
				  return false;
			     }
			  var pbvendorflag=elemflagarr[32];
			  if ((pbvendorflag=="Y")&&((INFOPbVendor==null)||(INFOPbVendor==""))){
				  Msg.info("warning","招标供应商不可以为空!");
				  return false;
			     }
			  var pbmanfflag=elemflagarr[33];
			  if ((pbmanfflag=="Y")&&((INFOPbManf==null)||(INFOPbManf==""))){
				  Msg.info("warning","招标生产商不可以为空!");
				  return false;
			     }
			  var pbcarrierflag=elemflagarr[34];
			  if ((pbcarrierflag=="Y")&&((INFOPbCarrier==null)||(INFOPbCarrier==""))){
				  Msg.info("warning","招标配送商不可以为空!");
				  return false;
			     }
			  var pbldrflag=elemflagarr[35];
			  if ((pbldrflag=="Y")&&((INFOPBLDR==null)||(INFOPBLDR==""))){
				  Msg.info("warning","招标名称不可以为空!");
				  return false;
			     }
			  var baflagflag=elemflagarr[36];
			  var expirelenflag=elemflagarr[37];
			  if ((expirelenflag=="Y")&&((INFOExpireLen===null)||(INFOExpireLen===""))){
				  Msg.info("warning","效期长度不可以为空!");
				  return false;
			     }
			  var prcfileflag=elemflagarr[38];
			  if ((prcfileflag=="Y")&&((INFOPrcFile==null)||(INFOPrcFile==""))){
				  Msg.info("warning","物价文件号不可以为空!");
				  return false;
			     }
			  var pricebakdayflag=elemflagarr[39];
			  if ((pricebakdayflag=="Y")&&((INFOPriceBakD==null)||(INFOPriceBakD==""))){
				  Msg.info("warning","物价文件备案时间不可以为空!");
				  return false;
			     }
			  var certexpdateflag=elemflagarr[40];
			  if ((certexpdateflag=="Y")&&((IRRegCertExpDate==null)||(IRRegCertExpDate==""))){
				  Msg.info("warning","注册证日期不可以为空!");
				  return false;
			     }
			  var bcdrflag=elemflagarr[41];
			  if ((bcdrflag=="Y")&&((INFOBCDr==null)||(INFOBCDr==""))){
				  Msg.info("warning","帐簿分类不可以为空!");
				  return false;
			     }
			  var drugbasecodeflag=elemflagarr[42];
			  if ((drugbasecodeflag=="Y")&&((INFODrugBaseCode==null)||(INFODrugBaseCode==""))){
				  Msg.info("warning","物资本位码不可以为空!");
				  return false;
			     }
			  var packuomflag=elemflagarr[43];
			  if ((packuomflag=="Y")&&((PackUom==null)||(PackUom==""))){
				  Msg.info("warning","大包装单位不可以为空!");
				  return false;
			     }
			  var packuomfacflag=elemflagarr[44];
			  if ((packuomfacflag=="Y")&&((PackUomFac==null)||(PackUomFac==""))){
				  Msg.info("warning","大包装单位系数不可以为空!");
				  return false;
			     }
			  var highriskflagflag=elemflagarr[45];
			  var notusereasonflag=elemflagarr[46];
			  var phcdofficialtypeflag=elemflagarr[47];
			  if ((phcdofficialtypeflag=="Y")&&((PHCDOfficialType==null)||(PHCDOfficialType==""))){
				  Msg.info("warning","医保类别不可以为空!");
				  return false;
			     }
			  var brandflag=elemflagarr[48];
			  if ((brandflag=="Y")&&((INFOBrand==null)||(INFOBrand==""))){
				  Msg.info("warning","品牌不可以为空!");
				  return false;
			     }
			  var modelflag=elemflagarr[49];
			  if ((modelflag=="Y")&&((INFOModel==null)||(INFOModel==""))){
				  Msg.info("warning","型号不可以为空!");
				  return false;
			     }
			  var chargeflagflag=elemflagarr[50];
			  var abbrevflag=elemflagarr[51];
			  if ((abbrevflag=="Y")&&((INFOAbbrev==null)||(INFOAbbrev==""))){
				  Msg.info("warning","简称不可以为空!");
				  return false;
			     }
			  var supervisionflag=elemflagarr[52];
			  if ((supervisionflag=="Y")&&((INFOSupervision==null)||(INFOSupervision==""))){
				  Msg.info("warning","监管级别不可以为空!");
				  return false;
			     }
			  var implantationmatflag=elemflagarr[53];
			  var nolocreqflag=elemflagarr[54];
			  var steriledatelenflag=elemflagarr[55];
			  var zerostkflag=elemflagarr[56];
			  var chargetypeflag=elemflagarr[57];
			  if ((chargetypeflag=="Y")&&((INFOChargeType==null)||(INFOChargeType==""))){
				  Msg.info("warning","收费类型不可以为空!");
				  return false;
			     }
			  var medeqptcatflag=elemflagarr[58];
			  if ((medeqptcatflag=="Y")&&((INFOMedEqptCat==null)||(INFOMedEqptCat==""))){
				  Msg.info("warning","器械分类不可以为空!");
				  return false;
			     }
			  var packchargeflag=elemflagarr[59];
			  var irregcertdateofissueflag=elemflagarr[60];
			  if ((irregcertdateofissueflag=="Y")&&((IRRegCertDateOfIssue==null)||(IRRegCertDateOfIssue==""))){
				  Msg.info("warning","注册证发证日期不可以为空!");
				  return false;
			     }
				var irregcertitmdescflag=elemflagarr[61];
				if ((irregcertitmdescflag=="Y")&&((IRRegCertItmDesc==null)||(IRRegCertItmDesc==""))){
				  Msg.info("warning","注册证名称不可以为空!");
				  return false;
			     }
				var irregcertexpdateextendedflag=elemflagarr[62];
				var biddateflag=elemflagarr[63];
				if ((biddateflag=="Y")&&((biddate==null)||(biddate==""))){
				  Msg.info("warning","招标日期不可以为空!");
				  return false;
			     }
				var originflag=elemflagarr[64];
				if ((originflag=="Y")&&((Origin==null)||(Origin==""))){
				  Msg.info("warning","产地不可以为空!");
				  return false;
			     }
				var firstreqdeptflag=elemflagarr[65];
				if ((firstreqdeptflag=="Y")&&((firstreqdept==null)||(firstreqdept==""))){
				  Msg.info("warning","首请部门不可以为空!");
				  return false;
			     }
				var scategoryflag=elemflagarr[66];
				if ((scategoryflag=="Y")&&((SCategory==null)||(SCategory==""))){
				  Msg.info("warning","灭菌分类不可以为空!");
				  return false;
			     }
				var matqualityflag=elemflagarr[67];
				if ((matqualityflag=="Y")&&((MatQuality==null)||(MatQuality==""))){
				  Msg.info("warning","质地不可以为空!");
				  return false;
			     }
				var hospzerostkflag=elemflagarr[68];
				if ((hospzerostkflag=="Y")&&((HospZeroStk==null)||(HospZeroStk==""))){
				  Msg.info("warning","院区零库存不可以为空!");
				  return false;
			     }
			     ///判断是否勾选收费标志
			    if (chargeflag=="Y"){
				var arcimcodeflag=elemflagarr[69]; //医嘱代码前台不控制
				var arcimdescflag=elemflagarr[70];
				if ((arcimdescflag=="Y")&&((ARCIMDesc==null)||(ARCIMDesc==""))){
				  Msg.info("warning","医嘱名称不可以为空!");
				  return false;
			     }
				var arcimuomdrflag=elemflagarr[71];
				if ((arcimuomdrflag=="Y")&&((ARCIMUomDR==null)||(ARCIMUomDR==""))){
				  Msg.info("warning","计价单位不可以为空!");
				  return false;
			     }
				var ordercategoryflag=elemflagarr[72];
				if ((ordercategoryflag=="Y")&&((OrderCategory==null)||(OrderCategory==""))){
				  Msg.info("warning","医嘱大类不可以为空!");
				  return false;
			     }
				var arcitemcatflag=elemflagarr[73];
				if ((arcitemcatflag=="Y")&&((ARCItemCat==null)||(ARCItemCat==""))){
				  Msg.info("warning","医嘱子类不可以为空!");
				  return false;
			     }
				var arcbillgrpflag=elemflagarr[74];
				if ((arcbillgrpflag=="Y")&&((ARCBillGrp==null)||(ARCBillGrp==""))){
				  Msg.info("warning","费用大类不可以为空!");
				  return false;
			     }
				var arcbillsubflag=elemflagarr[75];
				if ((arcbillsubflag=="Y")&&((ARCBillSub==null)||(ARCBillSub==""))){
				  Msg.info("warning","费用子类不可以为空!");
				  return false;
			     }
				var arcimorderonitsownflag=elemflagarr[76];
				var oecpriorityflag=elemflagarr[77];
				if ((oecpriorityflag=="Y")&&((OECPriority==null)||(OECPriority==""))){
				  Msg.info("warning","医嘱优先级不可以为空!");
				  return false;
			     }
				var wostockflagflag=elemflagarr[78];
				var arcimtext1flag=elemflagarr[79];
				if ((arcimtext1flag=="Y")&&((ARCIMText1==null)||(ARCIMText1==""))){
				  Msg.info("warning","医保名称不可以为空!");
				  return false;
			     }
				var arcaliasflag=elemflagarr[80];
				var arcimabbrevflag=elemflagarr[81];
				var phcdofficialtypeflag=elemflagarr[82];
				if ((phcdofficialtypeflag=="Y")&&((PHCDOfficialType==null)||(PHCDOfficialType==""))){
				  Msg.info("warning","医保类别不可以为空!");
				  return false;
			     }
				var arcimnoofcumdaysflag=elemflagarr[83];
				if ((arcimnoofcumdaysflag=="Y")&&((ARCIMNoOfCumDays==null)||(ARCIMNoOfCumDays==""))){
				  Msg.info("warning","限制使用天数不可以为空!");
				  return false;
			     }
				var arcimoemessageflag=elemflagarr[84];
				if ((arcimoemessageflag=="Y")&&((ARCIMOEMessage==null)||(ARCIMOEMessage==""))){
				  Msg.info("warning","医嘱提示不可以为空!");
				  return false;
			     }
				var billnotactiveflag=elemflagarr[85];
				var billcodeflag=elemflagarr[86];
				if ((billcodeflag=="Y")&&((BillCode==null)||(BillCode==""))){
				  Msg.info("warning","收费项代码不可以为空!");
				  return false;
			     }
				var billnameflag=elemflagarr[87];
				if ((billnameflag=="Y")&&((BillName==null)||(BillName==""))){
				  Msg.info("warning","收费项名称不可以为空!");
				  return false;
			     }
				var subtypefeeflag=elemflagarr[88];
				if ((subtypefeeflag=="Y")&&((SubTypeFee==null)||(SubTypeFee==""))){
				  Msg.info("warning","子分类不可以为空!");
				  return false;
			     }
				var insubtypefeeflag=elemflagarr[89];
				if ((insubtypefeeflag=="Y")&&((InSubTypeFee==null)||(InSubTypeFee==""))){
				  Msg.info("warning","住院子分类不可以为空!");
				  return false;
			     }
				var outsubtypefeeflag=elemflagarr[90];
				if ((outsubtypefeeflag=="Y")&&((OutSubTypeFee==null)||(OutSubTypeFee==""))){
				  Msg.info("warning","门诊子分类不可以为空!");
				  return false;
			     }
				var accsubtypefeeflag=elemflagarr[91];
				if ((accsubtypefeeflag=="Y")&&((AccSubTypeFee==null)||(AccSubTypeFee==""))){
				  Msg.info("warning","核算子分类不可以为空!");
				  return false;
			     }
				var medsubtypefeeflag=elemflagarr[92];
				if ((medsubtypefeeflag=="Y")&&((MedSubTypeFee==null)||(MedSubTypeFee==""))){
				  Msg.info("warning","病历首页子分类不可以为空!");
				  return false;
			     }
				var newmedsubtypefeeflag=elemflagarr[93];
				if ((newmedsubtypefeeflag=="Y")&&((NewMedSubTypeFee==null)||(NewMedSubTypeFee==""))){
				  Msg.info("warning","新病历首页子分类不可以为空!");
				  return false;
			     }
				var accountsubtypefeeflag=elemflagarr[94];
				if ((accountsubtypefeeflag=="Y")&&((AccountSubTypeFee==null)||(AccountSubTypeFee==""))){
				  Msg.info("warning","会计子分类不可以为空!");
				  return false;
			     }
				var medpromaintainflag=elemflagarr[95];
				if ((medpromaintainflag=="Y")&&((MedProMaintain==null)||(MedProMaintain==""))){
				  Msg.info("warning","维护医保项不可以为空!");
				  return false;
			     }
				var arcimeffdateflag=elemflagarr[96];
				if ((arcimeffdateflag=="Y")&&((ARCIMEffDate==null)||(ARCIMEffDate==""))){
				  Msg.info("warning","生效日期不可以为空!");
				  return false;
			     }
				var arcimeffdatetoflag=elemflagarr[97];
				var arcsppuruomflag=elemflagarr[98];
				if ((arcsppuruomflag=="Y")&&((ArcSpPuruom==null)||(ArcSpPuruom==""))){
				  Msg.info("warning","售价(医嘱)不可以为空!");
				  return false;
			     }
				var arcpreexedateflag=elemflagarr[99];
				var arciminfomtflag=elemflagarr[100];
				if ((arciminfomtflag=="Y")&&((ArcimINFOMT==null)||(ArcimINFOMT==""))){
				  Msg.info("warning","定价类型(医嘱)不可以为空!");
				  return false;
			     }
				var arcimrppuruomflag=elemflagarr[101];
			    }
			  
		  }
	  }
  
  
}


///改变控件元素字体样式
///20170324
///lihui
function changeElementInfo(elementstr,csp) 
{
	if ((elementstr=="")||(elementstr==null)||(csp=="")||(csp==null)){
      return;
  } 
  var elemarr=elementstr.split("^");
  if (elemarr.length > 0) 
	  {
		  //库存项
		  var incicode=elemarr[0];
		  var incidesc=elemarr[1];
		  var incictuom=elemarr[2];
		  var puctuompurch=elemarr[3];
		  var stkcat=elemarr[4];
		  var stkgrptype=elemarr[5];
		  var istrfflag=elemarr[6];
		  var batchreq=elemarr[7];
		  var expreqnew=elemarr[8];
		  var alias=elemarr[9];
		  var notuseflag=elemarr[10];
		  var reportingdays=elemarr[11];
		  var incibarcode=elemarr[12];
		  var bsppuruom=elemarr[13];
		  var brppuruom=elemarr[14];
		  var supplyloc=elemarr[15];
		  var reqtype=elemarr[16];
		  var remark=elemarr[17];
		  var preexpdate=elemarr[18];
		  var infospec=elemarr[19];
		  var infoimportfalg=elemarr[20];
		  var qualitylevel=elemarr[21];
		  var qualityno=elemarr[22];
		  var comfrom=elemarr[23];
		  var cergeno=elemarr[24];
		  var highprice=elemarr[25];
		  var infomt=elemarr[26];
		  var maxsp=elemarr[27];
		  var inhosflag=elemarr[28];
		  var pbflag=elemarr[29];
		  var pbrp=elemarr[30];
		  var pblevel=elemarr[31];
		  var pbvendor=elemarr[32];
		  var pbmanf=elemarr[33];
		  var pbcarrier=elemarr[34];
		  var pbldr=elemarr[35];
		  var baflag=elemarr[36];
		  var expirelen=elemarr[37];
		  var prcfile=elemarr[38];
		  var pricebakday=elemarr[39];
		  var certexpdate=elemarr[40];
		  var bcdr=elemarr[41];
		  var drugbasecode=elemarr[42];
		  var packuom=elemarr[43];
		  var packuomfac=elemarr[44];
		  var highriskflag=elemarr[45];
		  var notusereason=elemarr[46];
		  var phcdofficialtype=elemarr[47];
		  var brand=elemarr[48];
		  var model=elemarr[49];
		  var chargeflag=elemarr[50];
		  var abbrev=elemarr[51];
		  var supervision=elemarr[52];
		  var implantationmat=elemarr[53];
		  var nolocreq=elemarr[54];
		  var steriledatelen=elemarr[55];
		  var zerostk=elemarr[56];
		  var chargetype=elemarr[57];
		  var medeqptcat=elemarr[58];
		  var packcharge=elemarr[59];
		  var irregcertdateofissue=elemarr[60];
			var irregcertitmdesc=elemarr[61];
			var irregcertexpdateextended=elemarr[62];
			var biddate=elemarr[63];
			var origin=elemarr[64];
			var firstreqdept=elemarr[65];
			var scategory=elemarr[66];
			var matquality=elemarr[67];
			var hospzerostk=elemarr[68];
			var arcimcode=elemarr[69];
			var arcimdesc=elemarr[70];
			var arcimuomdr=elemarr[71];
			var ordercategory=elemarr[72];
			var arcitemcat=elemarr[73];
			var arcbillgrp=elemarr[74];
			var arcbillsub=elemarr[75];
			var arcimorderonitsown=elemarr[76];
			var oecpriority=elemarr[77];
			var wostockflag=elemarr[78];
			var arcimtext1=elemarr[79];
			var arcalias=elemarr[80];
			var arcimabbrev=elemarr[81];
			var phcdofficialtype=elemarr[82];
			var arcimnoofcumdays=elemarr[83];
			var arcimoemessage=elemarr[84];
			var billnotactive=elemarr[85];
			var billcode=elemarr[86];
			var billname=elemarr[87];
			var subtypefee=elemarr[88];
			var insubtypefee=elemarr[89];
			var outsubtypefee=elemarr[90];
			var accsubtypefee=elemarr[91];
			var medsubtypefee=elemarr[92];
			var newmedsubtypefee=elemarr[93];
			var accountsubtypefee=elemarr[94];
			var medpromaintain=elemarr[95];
			var arcimeffdate=elemarr[96];
			var arcimeffdateto=elemarr[97];
			var arcsppuruom=elemarr[98];
			var arcpreexedate=elemarr[99];
			var arciminfomt=elemarr[100];
			var arcimrppuruom=elemarr[101];
		  
		  var elemflags=tkMakeServerCall("web.DHCSTM.InciInfoMustInput","getElemetstrflag",elementstr,csp);
		  var elemflagarr=elemflags.split("^");
		  if (elemflagarr.length>0)
		  {
			 //库存项信息
			 //alert(document.getElementById(incicode))
			 //alert(document.getElementById(arcimcode))
			 if(document.getElementById(incicode)==null){  //加载的时候库存项控件信息为null
		         var incicodeflag=elemflagarr[0];
			  if(incicodeflag=="Y"){
		      var incicodelabel="代码";
			  Ext.getCmp(incicode).fieldLabel="<font color=red>"+incicodelabel+"</font>";  //物资代码
			  }
			  var incidescflag=elemflagarr[1];
			  if(incidescflag=="Y"){
		      var incidesclabel="名称";
			  Ext.getCmp(incidesc).fieldLabel="<font color=red>"+incidesclabel+"</font>";  //物资名称
			  }
			  var incictuomflag=elemflagarr[2];
			  if(incictuomflag=="Y"){
		      var incictuomlabel="基本单位";
			  Ext.getCmp(incictuom).fieldLabel="<font color=red>"+incictuomlabel+"</font>"; 
			  }
			  var puctuompurchflag=elemflagarr[3];
			  if(puctuompurchflag=="Y"){
		      var puctuompurchlabel="入库单位";
			  Ext.getCmp(puctuompurch).fieldLabel="<font color=red>"+puctuompurchlabel+"</font>"; 
			  }
			  var stkcatflag=elemflagarr[4];
			  if(stkcatflag=="Y"){
		      var stkcatlabel="库存分类";
			  Ext.getCmp(stkcat).fieldLabel="<font color=red>"+stkcatlabel+"</font>"; 
			  }
			  var stkgrptypeflag=elemflagarr[5];
			  if(stkgrptypeflag=="Y"){
		      var stkgrptypelabel="类组";
			  Ext.getCmp(stkgrptype).fieldLabel="<font color=red>"+stkgrptypelabel+"</font>"; 
			  }
			  var istrfflagflag=elemflagarr[6];//转移方式
			  var batchreqflag=elemflagarr[7];//是否要求批次
			  var expreqnewflag=elemflagarr[8];//是否要求效期
			  var aliasflag=elemflagarr[9];//别名
			  var notuseflagflag=elemflagarr[10];//不可用标志
			  var reportingdaysflag=elemflagarr[11];//协和码
			  if(reportingdaysflag=="Y"){
		      var reportingdayslabel="协和码";
			  Ext.getCmp(reportingdays).fieldLabel="<font color=red>"+reportingdayslabel+"</font>"; 
			  }
			  var incibarcodeflag=elemflagarr[12];//条码
			  if(incibarcodeflag=="Y"){
		      var incibarcodelabel="条码";
			  Ext.getCmp(incibarcode).fieldLabel="<font color=red>"+incibarcodelabel+"</font>"; 
			  }
			  var bsppuruomflag=elemflagarr[13];//售价
			  if(bsppuruomflag=="Y"){
		      var bsppuruomlabel="售价";
			  Ext.getCmp(bsppuruom).fieldLabel="<font color=red>"+bsppuruomlabel+"</font>"; 
			  }
			  var brppuruomflag=elemflagarr[14];//进价
			  if(brppuruomflag=="Y"){
		      var brppuruomlabel="进价";
			  Ext.getCmp(brppuruom).fieldLabel="<font color=red>"+brppuruomlabel+"</font>"; 
			  }
			  var supplylocflag=elemflagarr[15];//供应仓库
			  if(supplylocflag=="Y"){
		      var supplyloclabel="供应仓库";
			  Ext.getCmp(supplyloc).fieldLabel="<font color=red>"+supplyloclabel+"</font>"; 
			  }
			  var reqtypeflag=elemflagarr[16];//物资请求类型
			  if(reqtypeflag=="Y"){
		      var reqtypelabel="物资请求类型";
			  Ext.getCmp(reqtype).fieldLabel="<font color=red>"+reqtypelabel+"</font>"; 
			  }
			  var remarkflag=elemflagarr[17];//备注
			  var preexpdateflag=elemflagarr[18];//价格生效日期
			  var infospecflag=elemflagarr[19];//规格
			  if(infospecflag=="Y"){
		      var infospeclabel="规格";
			  Ext.getCmp(infospec).fieldLabel="<font color=red>"+infospeclabel+"</font>"; 
			  }
			  var infoimportfalgflag=elemflagarr[20];//进口标志
			  if(infoimportfalgflag=="Y"){
		      var infoimportfalglabel="进口标志";
			  Ext.getCmp(infoimportfalg).fieldLabel="<font color=red>"+infoimportfalglabel+"</font>"; 
			  }
			  var qualitylevelflag=elemflagarr[21];//质量层次
			  if(qualitylevelflag=="Y"){
		      var qualitylevellabel="质量层次";
			  Ext.getCmp(qualitylevel).fieldLabel="<font color=red>"+qualitylevellabel+"</font>"; 
			  }
			  var qualitynoflag=elemflagarr[22];//质量编号
			  if(qualitynoflag=="Y"){
		      var qualitynolabel="质量编号";
			  Ext.getCmp(qualityno).fieldLabel="<font color=red>"+qualitynolabel+"</font>"; 
			  }
			  var comfromflag=elemflagarr[23];//国/省别
			  if(comfromflag=="Y"){
		      var comfromlabel="国/省别";
			  Ext.getCmp(comfrom).fieldLabel="<font color=red>"+comfromlabel+"</font>"; 
			  }
			  var cergenoflag=elemflagarr[24];//注册证号
			  if(cergenoflag=="Y"){
		      var cergenolabel="注册证号";
			  Ext.getCmp(cergeno).fieldLabel="<font color=red>"+cergenolabel+"</font>"; 
			  }
			  var highpriceflag=elemflagarr[25];//高值类标志
			  var infomtflag=elemflagarr[26];//定价类型id
			  if(infomtflag=="Y"){
		      var infomtlabel="定价类型";
			  Ext.getCmp(infomt).fieldLabel="<font color=red>"+infomtlabel+"</font>"; 
			  }
			  var maxspflag=elemflagarr[27];//最高售价
			  if(maxspflag=="Y"){
		      var maxsplabel="最高售价";
			  Ext.getCmp(maxsp).fieldLabel="<font color=red>"+maxsplabel+"</font>"; 
			  }
			  var inhosflagflag=elemflagarr[28];//本院物资目录
			  var pbflagflag=elemflagarr[29];//招标标志
			  var pbrpflag=elemflagarr[30];//招标进价
			  if(pbrpflag=="Y"){
		      var pbrplabel="招标进价";
			  Ext.getCmp(pbrp).fieldLabel="<font color=red>"+pbrplabel+"</font>"; 
			  }
			  var pblevelflag=elemflagarr[31];//招标级别
			  if(pblevelflag=="Y"){
		      var pblevellabel="招标级别";
			  Ext.getCmp(pblevel).fieldLabel="<font color=red>"+pblevellabel+"</font>"; 
			  }
			  var pbvendorflag=elemflagarr[32];//招标供应商id
			  if(pbvendorflag=="Y"){
		      var pbvendorlabel="招标供应商";
			  Ext.getCmp(pbvendor).fieldLabel="<font color=red>"+pbvendorlabel+"</font>"; 
			  }
			  var pbmanfflag=elemflagarr[33];//招标生产商id
			  if(pbmanfflag=="Y"){
		      var pbmanflabel="厂商";
			  Ext.getCmp(pbmanf).fieldLabel="<font color=red>"+pbmanflabel+"</font>"; 
			  }
			  var pbcarrierflag=elemflagarr[34];//招标配送商id
			  if(pbcarrierflag=="Y"){
		      var pbcarrierlabel="招标配送商";
			  Ext.getCmp(pbcarrier).fieldLabel="<font color=red>"+pbcarrierlabel+"</font>"; 
			  }
			  var pbldrflag=elemflagarr[35];//招标名称
			  if(pbldrflag=="Y"){
		      var pbldrlabel="招标名称";
			  Ext.getCmp(pbldr).fieldLabel="<font color=red>"+pbldrlabel+"</font>"; 
			  }
			  var baflagflag=elemflagarr[36];//一次性标志
			  var expirelenflag=elemflagarr[37];//效期长度(月)
			  if(expirelenflag=="Y"){
		      var expirelenlabel="效期长度(月)";
			  Ext.getCmp(expirelen).fieldLabel="<font color=red>"+expirelenlabel+"</font>"; 
			  }
			  var prcfileflag=elemflagarr[38];//物价文件号
			  if(prcfileflag=="Y"){
		      var prcfilelabel="物价文件号";
			  Ext.getCmp(prcfile).fieldLabel="<font color=red>"+prcfilelabel+"</font>"; 
			  }
			  var pricebakdayflag=elemflagarr[39];//物价文件备案时间
			  if(pricebakdayflag=="Y"){
		      var pricebakdaylabel="物价文件备案时间";
			  Ext.getCmp(pricebakday).fieldLabel="<font color=red>"+pricebakdaylabel+"</font>"; 
			  }
			  var certexpdateflag=elemflagarr[40];//注册证日期
			  if(certexpdateflag=="Y"){
		      var certexpdatelabel="注册证日期";
			  Ext.getCmp(certexpdate).fieldLabel="<font color=red>"+certexpdatelabel+"</font>"; 
			  }
			  var bcdrflag=elemflagarr[41];//帐簿分类id
			  if(bcdrflag=="Y"){
		      var bcdrlabel="帐簿分类";
			  Ext.getCmp(bcdr).fieldLabel="<font color=red>"+bcdrlabel+"</font>"; 
			  }
			  var drugbasecodeflag=elemflagarr[42];//物资本位码
			  if(drugbasecodeflag=="Y"){
		      var drugbasecodelabel="物资本位码";
			  Ext.getCmp(drugbasecode).fieldLabel="<font color=red>"+drugbasecodelabel+"</font>"; 
			  }
			  var packuomflag=elemflagarr[43];//大包装单位
			  if(packuomflag=="Y"){
		      var packuomlabel="大包装单位";
			  Ext.getCmp(packuom).fieldLabel="<font color=red>"+packuomlabel+"</font>"; 
			  }
			  var packuomfacflag=elemflagarr[44];//大包装单位系数
			  if(packuomfacflag=="Y"){
		      var packuomfaclabel="大包装单位系数";
			  Ext.getCmp(packuomfac).fieldLabel="<font color=red>"+packuomfaclabel+"</font>"; 
			  }
			  var highriskflagflag=elemflagarr[45];//高危标志
			  var notusereasonflag=elemflagarr[46];//不可用原因
			  var phcdofficialtypeflag=elemflagarr[47];//医保类别
			  if(phcdofficialtypeflag=="Y"){
		      var phcdofficialtypelabel="医保类别";
			  Ext.getCmp(phcdofficialtype).fieldLabel="<font color=red>"+phcdofficialtypelabel+"</font>"; 
			  }
			  var brandflag=elemflagarr[48];//品牌
			  if(brandflag=="Y"){
		      var brandlabel="品牌";
			  Ext.getCmp(brand).fieldLabel="<font color=red>"+brandlabel+"</font>"; 
			  }
			  var modelflag=elemflagarr[49];//型号
			  if(modelflag=="Y"){
		      var modellabel="型号";
			  Ext.getCmp(model).fieldLabel="<font color=red>"+modellabel+"</font>"; 
			  }
			  var chargeflagflag=elemflagarr[50];//收费标志
			  var abbrevflag=elemflagarr[51];//简称
			  if(abbrevflag=="Y"){
		      var abbrevlabel="简称";
			  Ext.getCmp(abbrev).fieldLabel="<font color=red>"+abbrevlabel+"</font>"; 
			  }
			  var supervisionflag=elemflagarr[52];//监管级别
			  if(supervisionflag=="Y"){
		      var supervisionlabel="监管级别";
			  Ext.getCmp(supervision).fieldLabel="<font color=red>"+supervisionlabel+"</font>"; 
			  }
			  var implantationmatflag=elemflagarr[53];//植入标志
			  var nolocreqflag=elemflagarr[54];//禁止请领标志
			  var steriledatelenflag=elemflagarr[55];//灭菌时间
			  if(steriledatelenflag=="Y"){
		      var steriledatelenlabel="灭菌时间长度";
			  Ext.getCmp(steriledatelen).fieldLabel="<font color=red>"+steriledatelenlabel+"</font>"; 
			  }
			  var zerostkflag=elemflagarr[56];//零库存标志
			  var chargetypeflag=elemflagarr[57];//收费类型
			  if(chargetypeflag=="Y"){
		      var chargetypelabel="收费类型";
			  Ext.getCmp(chargetype).fieldLabel="<font color=red>"+chargetypelabel+"</font>"; 
			  }
			  var medeqptcatflag=elemflagarr[58];//器械分类
			  if(medeqptcatflag=="Y"){
		      var medeqptcatlabel="器械分类";
			  Ext.getCmp(medeqptcat).fieldLabel="<font color=red>"+medeqptcatlabel+"</font>"; 
			  }
			  var packchargeflag=elemflagarr[59];//打包标志
			  var irregcertdateofissueflag=elemflagarr[60];//注册证发证日期
			  if(irregcertdateofissueflag=="Y"){
		      var irregcertdateofissuelabel="注册证发证日期";
			  Ext.getCmp(irregcertdateofissue).fieldLabel="<font color=red>"+irregcertdateofissuelabel+"</font>"; 
			  }
			var irregcertitmdescflag=elemflagarr[61];//注册证名称
			if(irregcertitmdescflag=="Y"){
		      var irregcertitmdesclabel="注册证名称";
			  Ext.getCmp(irregcertitmdesc).fieldLabel="<font color=red>"+irregcertitmdesclabel+"</font>"; 
			  }
			var irregcertexpdateextendedflag=elemflagarr[62];//注册证延长效期
			var biddateflag=elemflagarr[63];//招标日期
			if(biddateflag=="Y"){
		      var biddatelabel="招标日期";
			  Ext.getCmp(biddate).fieldLabel="<font color=red>"+biddatelabel+"</font>"; 
			  }
			var originflag=elemflagarr[64];//产地
			if(originflag=="Y"){
		      var originlabel="产地";
			  Ext.getCmp(origin).fieldLabel="<font color=red>"+originlabel+"</font>"; 
			  }
			var firstreqdeptflag=elemflagarr[65];//首请部门
			if(firstreqdeptflag=="Y"){
		      var firstreqdeptlabel="首请部门";
			  Ext.getCmp(firstreqdept).fieldLabel="<font color=red>"+firstreqdeptlabel+"</font>"; 
			  }
			var scategoryflag=elemflagarr[66];//灭菌分类
			if(scategoryflag=="Y"){
		      var scategorylabel="灭菌分类";
			  Ext.getCmp(scategory).fieldLabel="<font color=red>"+scategorylabel+"</font>"; 
			  }
			var matqualityflag=elemflagarr[67];//质地
			if(matqualityflag=="Y"){
		      var matqualitylabel="质地";
			  Ext.getCmp(matquality).fieldLabel="<font color=red>"+matqualitylabel+"</font>"; 
			  }
			var hospzerostkflag=elemflagarr[68];//院区零库存
			if(hospzerostkflag=="Y"){
		      var hospzerostklabel="院区零库存";
			  Ext.getCmp(hospzerostk).fieldLabel="<font color=red>"+hospzerostklabel+"</font>"; 
			  }
		}else{
			  var incicodeflag=elemflagarr[0];
			  if(incicodeflag=="Y"){
		      var incicodelabel="代码";
			  Ext.DomQuery.selectNode("label[for="+incicode+"]").innerHTML = '<font color=red>代码</font>:';
			  }
			  var incidescflag=elemflagarr[1];
			  if(incidescflag=="Y"){
		      var incidesclabel="名称";
		      Ext.DomQuery.selectNode("label[for="+incidesc+"]").innerHTML = '<font color=red>名称</font>:';
			  }
			  var incictuomflag=elemflagarr[2];
			  if(incictuomflag=="Y"){
		      var incictuomlabel="基本单位";
		      Ext.DomQuery.selectNode("label[for="+incictuom+"]").innerHTML = '<font color=red>基本单位</font>:';
			  }
			  var puctuompurchflag=elemflagarr[3];
			  if(puctuompurchflag=="Y"){
		      var puctuompurchlabel="入库单位";
			  Ext.DomQuery.selectNode("label[for="+puctuompurch+"]").innerHTML = '<font color=red>入库单位</font>:';
			  }
			  var stkcatflag=elemflagarr[4];
			  if(stkcatflag=="Y"){
		      var stkcatlabel="库存分类";
			  Ext.DomQuery.selectNode("label[for="+stkcat+"]").innerHTML = '<font color=red>库存分类</font>:';
			  }
			  var stkgrptypeflag=elemflagarr[5];
			  if(stkgrptypeflag=="Y"){
		      var stkgrptypelabel="类组";
		      Ext.DomQuery.selectNode("label[for="+stkgrptype+"]").innerHTML = '<font color=red>类组</font>:';
			  }
			  var istrfflagflag=elemflagarr[6];//转移方式
			  var batchreqflag=elemflagarr[7];//是否要求批次
			  var expreqnewflag=elemflagarr[8];//是否要求效期
			  var aliasflag=elemflagarr[9];//别名
			  var notuseflagflag=elemflagarr[10];//不可用标志
			  var reportingdaysflag=elemflagarr[11];//协和码
			  if(reportingdaysflag=="Y"){
		      var reportingdayslabel="协和码";
			  Ext.DomQuery.selectNode("label[for="+reportingdays+"]").innerHTML = '<font color=red>协和码</font>:';
			  }
			  var incibarcodeflag=elemflagarr[12];//条码
			  if(incibarcodeflag=="Y"){
		      var incibarcodelabel="条码";
			  Ext.DomQuery.selectNode("label[for="+incibarcode+"]").innerHTML = '<font color=red>条码</font>:';
			  }
			  var bsppuruomflag=elemflagarr[13];//售价
			  if(bsppuruomflag=="Y"){
		      var bsppuruomlabel="售价";
		      Ext.DomQuery.selectNode("label[for="+bsppuruom+"]").innerHTML = '<font color=red>售价</font>:';
			  }
			  var brppuruomflag=elemflagarr[14];//进价
			  if(brppuruomflag=="Y"){
		      var brppuruomlabel="进价";
			  Ext.DomQuery.selectNode("label[for="+brppuruom+"]").innerHTML = '<font color=red>进价</font>:';
			  }
			  var supplylocflag=elemflagarr[15];//供应仓库
			  if(supplylocflag=="Y"){
		      var supplyloclabel="供应仓库";
		      Ext.DomQuery.selectNode("label[for="+supplyloc+"]").innerHTML = '<font color=red>供应仓库</font>:';
			  }
			  var reqtypeflag=elemflagarr[16];//物资请求类型
			  if(reqtypeflag=="Y"){
		      var reqtypelabel="物资请求类型";
			  Ext.DomQuery.selectNode("label[for="+reqtype+"]").innerHTML = '<font color=red>物资请求类型</font>:';
			  }
			  var remarkflag=elemflagarr[17];//备注
			  var preexpdateflag=elemflagarr[18];//价格生效日期
			  var infospecflag=elemflagarr[19];//规格previousSibling
			  if(infospecflag=="Y"){
		      var infospeclabel="规格";
			  document.getElementById(infospec).parentNode.parentNode.parentNode.previousSibling.innerHTML ="<font color=red>规格</font>:"; 
			  }
			  var infoimportfalgflag=elemflagarr[20];//进口标志
			  if(infoimportfalgflag=="Y"){
		      var infoimportfalglabel="进口标志";
		      Ext.DomQuery.selectNode("label[for="+infoimportfalg+"]").innerHTML = '<font color=red>进口标志</font>:';
			  }
			  var qualitylevelflag=elemflagarr[21];//质量层次
			  if(qualitylevelflag=="Y"){
		      var qualitylevellabel="质量层次";
		      Ext.DomQuery.selectNode("label[for="+qualitylevel+"]").innerHTML = '<font color=red>质量层次</font>:';
			  }
			  var qualitynoflag=elemflagarr[22];//质量编号
			  if(qualitynoflag=="Y"){
		      var qualitynolabel="质量编号";
			  Ext.DomQuery.selectNode("label[for="+qualityno+"]").innerHTML = '<font color=red>质量编号</font>:';
			  }
			  var comfromflag=elemflagarr[23];//国/省别
			  if(comfromflag=="Y"){
		      var comfromlabel="国/省别";
			  Ext.DomQuery.selectNode("label[for="+comfrom+"]").innerHTML = '<font color=red>国/省别</font>:';
			  }
			  var cergenoflag=elemflagarr[24];//注册证号
			  if(cergenoflag=="Y"){
		      var cergenolabel="注册证号";
		      if(document.getElementById(cergeno).parentNode.parentNode.parentNode.previousSibling==null){
		      Ext.DomQuery.selectNode("label[for="+cergeno+"]").innerHTML = '<font color=red>注册证号</font>:';
		      }else{
			  document.getElementById(cergeno).parentNode.parentNode.parentNode.previousSibling.innerHTML ="<font color=red>注册证号</font>:"; 
			  }
			  }
			  var highpriceflag=elemflagarr[25];//高值类标志
			  var infomtflag=elemflagarr[26];//定价类型id
			  if(infomtflag=="Y"){
		      var infomtlabel="定价类型";
			  Ext.DomQuery.selectNode("label[for="+infomt+"]").innerHTML = '<font color=red>定价类型</font>:';
			  }
			  var maxspflag=elemflagarr[27];//最高售价
			  if(maxspflag=="Y"){
		      var maxsplabel="最高售价";
			  Ext.DomQuery.selectNode("label[for="+maxsp+"]").innerHTML = '<font color=red>最高售价</font>:';
			  }
			  var inhosflagflag=elemflagarr[28];//本院物资目录
			  var pbflagflag=elemflagarr[29];//招标标志
			  var pbrpflag=elemflagarr[30];//招标进价
			  if(pbrpflag=="Y"){
		      var pbrplabel="招标进价";
			  Ext.DomQuery.selectNode("label[for="+pbrp+"]").innerHTML = '<font color=red>招标进价</font>:';
			  }
			  var pblevelflag=elemflagarr[31];//招标级别
			  if(pblevelflag=="Y"){
		      var pblevellabel="招标级别";
			  Ext.DomQuery.selectNode("label[for="+pblevel+"]").innerHTML = '<font color=red>招标级别</font>:';
			  }
			  var pbvendorflag=elemflagarr[32];//招标供应商id
			  if(pbvendorflag=="Y"){
		      var pbvendorlabel="招标供应商";
			  document.getElementById(pbvendor).parentNode.parentNode.parentNode.parentNode.previousSibling.innerHTML ="<font color=red>招标供应商</font>:"; 
			  }
			  var pbmanfflag=elemflagarr[33];//招标生产商id
			  if(pbmanfflag=="Y"){
		      var pbmanflabel="厂商";
		      Ext.DomQuery.selectNode("label[for="+pbmanf+"]").innerHTML = '<font color=red>厂商</font>:';
			  }
			  var pbcarrierflag=elemflagarr[34];//招标配送商id
			  if(pbcarrierflag=="Y"){
		      var pbcarrierlabel="招标配送商";
		      Ext.DomQuery.selectNode("label[for="+pbcarrier+"]").innerHTML = '<font color=red>招标配送商</font>:';
			  }
			  var pbldrflag=elemflagarr[35];//招标名称
			  if(pbldrflag=="Y"){
		      var pbldrlabel="招标名称";
		      Ext.DomQuery.selectNode("label[for="+pbldr+"]").innerHTML = '<font color=red>招标名称</font>:';
			  }
			  var baflagflag=elemflagarr[36];//一次性标志
			  var expirelenflag=elemflagarr[37];//效期长度(月)
			  if(expirelenflag=="Y"){
		      var expirelenlabel="效期长度(月)";
		      Ext.DomQuery.selectNode("label[for="+expirelen+"]").innerHTML = '<font color=red>效期长度(月)</font>:';
			  }
			  var prcfileflag=elemflagarr[38];//物价文件号
			  if(prcfileflag=="Y"){
		      var prcfilelabel="物价文件号";
		      Ext.DomQuery.selectNode("label[for="+prcfile+"]").innerHTML = '<font color=red>物价文件号</font>:';
			  }
			  var pricebakdayflag=elemflagarr[39];//物价文件备案时间
			  if(pricebakdayflag=="Y"){
		      var pricebakdaylabel="物价文件备案时间";
		      Ext.DomQuery.selectNode("label[for="+pricebakday+"]").innerHTML = '<font color=red>物价文件备案时间</font>:';
			  }
			  var certexpdateflag=elemflagarr[40];//注册证日期
			  if(certexpdateflag=="Y"){
		      var certexpdatelabel="注册证日期";
		      Ext.DomQuery.selectNode("label[for="+certexpdate+"]").innerHTML = '<font color=red>注册证日期</font>:';
			  }
			  var bcdrflag=elemflagarr[41];//帐簿分类id
			  if(bcdrflag=="Y"){
		      var bcdrlabel="帐簿分类";
		      Ext.DomQuery.selectNode("label[for="+bcdr+"]").innerHTML = '<font color=red>帐簿分类</font>:';
			  }
			  var drugbasecodeflag=elemflagarr[42];//物资本位码
			  if(drugbasecodeflag=="Y"){
		      var drugbasecodelabel="物资本位码";
		      Ext.DomQuery.selectNode("label[for="+drugbasecode+"]").innerHTML = '<font color=red>物资本位码</font>:';
			  }
			  var packuomflag=elemflagarr[43];//大包装单位
			  if(packuomflag=="Y"){
		      var packuomlabel="大包装单位";
			  document.getElementById(packuom).parentNode.parentNode.parentNode.parentNode.previousSibling.innerHTML ="<font color=red>大包装单位</font>:";
			  }
			  var packuomfacflag=elemflagarr[44];//大包装单位系数
			  if(packuomfacflag=="Y"){
		      var packuomfaclabel="大包装单位系数";
			  document.getElementById(packuomfac).previousSibling.innerHTML ="<font color=red>-大包装单位系数</font>:";
			  }
			  var highriskflagflag=elemflagarr[45];//高危标志
			  var notusereasonflag=elemflagarr[46];//不可用原因
			  var phcdofficialtypeflag=elemflagarr[47];//医保类别
			  if(phcdofficialtypeflag=="Y"){
		      var phcdofficialtypelabel="医保类别";
		      Ext.DomQuery.selectNode("label[for="+phcdofficialtype+"]").innerHTML = '<font color=red>医保类别</font>:';
			  }
			  var brandflag=elemflagarr[48];//品牌
			  if(brandflag=="Y"){
		      var brandlabel="品牌";
		      Ext.DomQuery.selectNode("label[for="+brand+"]").innerHTML = '<font color=red>品牌</font>:';
			  }
			  var modelflag=elemflagarr[49];//型号
			  if(modelflag=="Y"){
		      var modellabel="型号";
		      Ext.DomQuery.selectNode("label[for="+model+"]").innerHTML = '<font color=red>型号</font>:';
			  }
			  var chargeflagflag=elemflagarr[50];//收费标志
			  var abbrevflag=elemflagarr[51];//简称
			  if(abbrevflag=="Y"){
		      var abbrevlabel="简称";
		      Ext.DomQuery.selectNode("label[for="+abbrev+"]").innerHTML = '<font color=red>简称</font>:';
			  }
			  var supervisionflag=elemflagarr[52];//监管级别
			  if(supervisionflag=="Y"){
		      var supervisionlabel="监管级别";
		      Ext.DomQuery.selectNode("label[for="+supervision+"]").innerHTML = '<font color=red>监管级别</font>:';
			  }
			  var implantationmatflag=elemflagarr[53];//植入标志
			  var nolocreqflag=elemflagarr[54];//禁止请领标志
			  var steriledatelenflag=elemflagarr[55];//灭菌时间长度
			  if(steriledatelenflag=="Y"){
		      var steriledatelenlabel="灭菌时间长度";
		      Ext.DomQuery.selectNode("label[for="+steriledatelen+"]").innerHTML = '<font color=red>灭菌时间长度</font>:';
			  }
			  var zerostkflag=elemflagarr[56];//零库存标志
			  var chargetypeflag=elemflagarr[57];//收费类型
			  if(chargetypeflag=="Y"){
		      var chargetypelabel="收费类型";
		      if(Ext.DomQuery.selectNode("label[for="+chargetype+"]")==null){
			  document.getElementById(chargetype).parentNode.parentNode.parentNode.parentNode.previousSibling.innerHTML ="<font color=red>收费类型</font>:"; 
			  }else{
		      Ext.DomQuery.selectNode("label[for="+chargetype+"]").innerHTML = '<font color=red>收费类型</font>:';
		      }
			  }
			  var medeqptcatflag=elemflagarr[58];//器械分类
			  if(medeqptcatflag=="Y"){
		      var medeqptcatlabel="器械分类";
		      if(Ext.DomQuery.selectNode("label[for="+medeqptcat+"]")==null){
			  document.getElementById(medeqptcat).parentNode.parentNode.parentNode.parentNode.previousSibling.innerHTML ="<font color=red>器械分类</font>:"; 
			  }else{
		      Ext.DomQuery.selectNode("label[for="+medeqptcat+"]").innerHTML = '<font color=red>器械分类</font>:';
			  }
			  }
			  var packchargeflag=elemflagarr[59];//打包标志
			  var irregcertdateofissueflag=elemflagarr[60];//注册证发证日期
			  if(irregcertdateofissueflag=="Y"){
		      var irregcertdateofissuelabel="注册证发证日期";
		      Ext.DomQuery.selectNode("label[for="+irregcertdateofissue+"]").innerHTML = '<font color=red>注册证发证日期</font>:';
			  }
			var irregcertitmdescflag=elemflagarr[61];//注册证名称
			if(irregcertitmdescflag=="Y"){
		      var irregcertitmdesclabel="注册证名称";
		      Ext.DomQuery.selectNode("label[for="+irregcertitmdesc+"]").innerHTML = '<font color=red>注册证名称</font>:';
			  }
			var irregcertexpdateextendedflag=elemflagarr[62];//注册证延长效期
			var biddateflag=elemflagarr[63];//招标日期
			if(biddateflag=="Y"){
		      var biddatelabel="招标日期";
		      Ext.DomQuery.selectNode("label[for="+biddate+"]").innerHTML = '<font color=red>招标日期</font>:';
			  }
			var originflag=elemflagarr[64];//产地
			if(originflag=="Y"){
		      var originlabel="产地";
		      Ext.DomQuery.selectNode("label[for="+origin+"]").innerHTML = '<font color=red>产地</font>:';
			  }
			var firstreqdeptflag=elemflagarr[65];//首请部门
			if(firstreqdeptflag=="Y"){
		      var firstreqdeptlabel="首请部门";
			  document.getElementById(firstreqdept).parentNode.parentNode.parentNode.parentNode.previousSibling.innerHTML ="<font color=red>首请部门</font>:"; 
			  }
			var scategoryflag=elemflagarr[66];//灭菌分类
			if(scategoryflag=="Y"){
		      var scategorylabel="灭菌分类";
		      Ext.DomQuery.selectNode("label[for="+scategory+"]").innerHTML = '<font color=red>灭菌分类</font>:';
			  }
			var matqualityflag=elemflagarr[67];//质地
			if(matqualityflag=="Y"){
		      var matqualitylabel="质地";
			  Ext.DomQuery.selectNode("label[for="+matquality+"]").innerHTML = '<font color=red>质地</font>:';
			  }
			var hospzerostkflag=elemflagarr[68];//院区零库存
			if(hospzerostkflag=="Y"){
		      var hospzerostklabel="院区零库存";
			  }
			}
			/////*****医嘱项label
			var arcimcodeflag=elemflagarr[69];//医嘱代码
			if(arcimcodeflag=="Y"){
		      var arcimcodelabel="医嘱代码";
		      Ext.DomQuery.selectNode("label[for="+arcimcode+"]").innerHTML = '<font color=red>医嘱代码</font>:';
			  }
			var arcimdescflag=elemflagarr[70];//医嘱名称
			if(arcimdescflag=="Y"){
		      var arcimdesclabel="医嘱名称";
		      Ext.DomQuery.selectNode("label[for="+arcimdesc+"]").innerHTML = '<font color=red>医嘱名称</font>:';
			  }
			var arcimuomdrflag=elemflagarr[71];//计价单位
			if(arcimuomdrflag=="Y"){
		      var arcimuomdrlabel="计价单位";
		      Ext.DomQuery.selectNode("label[for="+arcimuomdr+"]").innerHTML = '<font color=red>计价单位</font>:';
			  }
			var ordercategoryflag=elemflagarr[72];//医嘱大类
			if(ordercategoryflag=="Y"){
		      var ordercategorylabel="医嘱大类";
		      Ext.DomQuery.selectNode("label[for="+ordercategory+"]").innerHTML = '<font color=red>医嘱大类</font>:';
			  }
			var arcitemcatflag=elemflagarr[73];//医嘱子类
			if(arcitemcatflag=="Y"){
		      var arcitemcatlabel="医嘱子类";
		      Ext.DomQuery.selectNode("label[for="+arcitemcat+"]").innerHTML = '<font color=red>医嘱子类</font>:';
			  }
			var arcbillgrpflag=elemflagarr[74];//费用大类
			if(arcbillgrpflag=="Y"){
		      var arcbillgrplabel="费用大类";
		      Ext.DomQuery.selectNode("label[for="+arcbillgrp+"]").innerHTML = '<font color=red>费用大类</font>:';
			  }
			var arcbillsubflag=elemflagarr[75];//费用子类
			if(arcbillsubflag=="Y"){
		      var arcbillsublabel="费用子类";
		      Ext.DomQuery.selectNode("label[for="+arcbillsub+"]").innerHTML = '<font color=red>费用子类</font>:';
			  }
			var arcimorderonitsownflag=elemflagarr[76];//独立医嘱
			var oecpriorityflag=elemflagarr[77];//医嘱优先级
			if(oecpriorityflag=="Y"){
		      var oecprioritylabel="医嘱优先级";
		      Ext.DomQuery.selectNode("label[for="+oecpriority+"]").innerHTML = '<font color=red>医嘱优先级</font>:';
			  }
			var wostockflagflag=elemflagarr[78];//无库存医嘱
			var arcimtext1flag=elemflagarr[79];//医保名称
			if(arcimtext1flag=="Y"){
		      var arcimtext1label="医保名称";
		      Ext.DomQuery.selectNode("label[for="+arcimtext1+"]").innerHTML = '<font color=red>医保名称</font>:';
			  }
			var arcaliasflag=elemflagarr[80];//别名
			var arcimabbrevflag=elemflagarr[81];//缩写
			var phcdofficialtypeflag=elemflagarr[82];//医保类别
			if(phcdofficialtypeflag=="Y"){
		      var phcdofficialtypelabel="医保类别";
		      Ext.DomQuery.selectNode("label[for="+phcdofficialtype+"]").innerHTML = '<font color=red>医保类别</font>:';
			  }
			var arcimnoofcumdaysflag=elemflagarr[83];//限制使用天数
			if(arcimnoofcumdaysflag=="Y"){
		      var arcimnoofcumdayslabel="限制使用天数";
		      Ext.DomQuery.selectNode("label[for="+arcimnoofcumdays+"]").innerHTML = '<font color=red>限制使用天数</font>:';
			  }
			var arcimoemessageflag=elemflagarr[84];//医嘱提示
			if(arcimoemessageflag=="Y"){
		      var arcimoemessagelabel="医嘱提示";
		      Ext.DomQuery.selectNode("label[for="+arcimoemessage+"]").innerHTML = '<font color=red>医嘱提示</font>:';
			  }
			var billnotactiveflag=elemflagarr[85];//不维护收费项
			var billcodeflag=elemflagarr[86];//收费项代码
			if(billcodeflag=="Y"){
		      var billcodelabel="收费项代码";
		      Ext.DomQuery.selectNode("label[for="+billcode+"]").innerHTML = '<font color=red>收费项代码</font>:';
			  }
			var billnameflag=elemflagarr[87];//收费项名称
			if(billnameflag=="Y"){
		      var billnamelabel="收费项名称";
		      Ext.DomQuery.selectNode("label[for="+billname+"]").innerHTML = '<font color=red>收费项名称</font>:';
			  //document.getElementById(billname).parentNode.previousSibling.innerHTML ="<font color=red>收费项名称</font>:"; 
			  }
			var subtypefeeflag=elemflagarr[88];//子分类
			if((subtypefeeflag=="Y")&&(Ext.getCmp(billnotactive).getValue()==false)){
			  document.getElementById(subtypefee).parentNode.parentNode.previousSibling.innerHTML ="<font color=red>子分类</font>:"; 
			  }
			var insubtypefeeflag=elemflagarr[89];//住院子分类
			if((insubtypefeeflag=="Y")&&(Ext.getCmp(billnotactive).getValue()==false)){
               document.getElementById(insubtypefee).parentNode.parentNode.previousSibling.innerHTML ="<font color=red>住院子分类</font>:";
             }
			var outsubtypefeeflag=elemflagarr[90];//门诊子分类
			if((outsubtypefeeflag=="Y")&&(Ext.getCmp(billnotactive).getValue()==false)){
			   document.getElementById(outsubtypefee).parentNode.parentNode.previousSibling.innerHTML ="<font color=red>门诊子分类</font>:";
			  }
			var accsubtypefeeflag=elemflagarr[91];//核算子分类
			if((accsubtypefeeflag=="Y")&&(Ext.getCmp(billnotactive).getValue()==false)){
			    document.getElementById(accsubtypefee).parentNode.parentNode.previousSibling.innerHTML ="<font color=red>核算子分类</font>:";
			  }
			var medsubtypefeeflag=elemflagarr[92];//病历首页子分类
			if((medsubtypefeeflag=="Y")&&(Ext.getCmp(billnotactive).getValue()==false)){
		      document.getElementById(medsubtypefee).parentNode.parentNode.previousSibling.innerHTML ="<font color=red>病历首页分类</font>:";
			  }
			var newmedsubtypefeeflag=elemflagarr[93];//新病历首页子分类
			if((newmedsubtypefeeflag=="Y")&&(Ext.getCmp(billnotactive).getValue()==false)){
		      document.getElementById(newmedsubtypefee).parentNode.parentNode.previousSibling.innerHTML ="<font color=red>新病历首页分类</font>:"
			  }
			var accountsubtypefeeflag=elemflagarr[94];//会计子分类
			if((accountsubtypefeeflag=="Y")&&(Ext.getCmp(billnotactive).getValue()==false)){
		      document.getElementById(accountsubtypefee).parentNode.parentNode.previousSibling.innerHTML ="<font color=red>会计子分类</font>:";
			  }
			var medpromaintainflag=elemflagarr[95];//维护医保项
			if(medpromaintainflag=="Y"){
		      var medpromaintainlabel="维护医保项";
		      Ext.DomQuery.selectNode("label[for="+medpromaintain+"]").innerHTML = '<font color=red>维护医保项</font>:';
			  }
			var arcimeffdateflag=elemflagarr[96];//生效日期
			var arcimeffdatetoflag=elemflagarr[97];//截止日期
			var arcsppuruomflag=elemflagarr[98];//售价(医嘱)
			if(arcsppuruomflag=="Y"){
		      var arcsppuruomlabel="售价(医嘱)";
		      Ext.DomQuery.selectNode("label[for="+arcsppuruom+"]").innerHTML = '<font color=red>售价(医嘱)</font>:';
			  }
			var arcpreexedateflag=elemflagarr[99];//价格生效日期(医嘱)
			 var arciminfomtflag=elemflagarr[100];//定价类型(医嘱)
			if(arciminfomtflag=="Y"){
		      var arciminfomtlabel="定价类型(医嘱)";
		      Ext.DomQuery.selectNode("label[for="+arciminfomt+"]").innerHTML = '<font color=red>定价类型(医嘱)</font>:';
			  }
			var arcimrppuruomflag=elemflagarr[101];//进价(医嘱)
		  }
	  }
}