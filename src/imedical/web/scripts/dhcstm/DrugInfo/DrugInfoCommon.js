///��ȡ�ؼ�Ԫ�ر��������Ϣ,�ؼ�id�����ά������Ϣһģһ��,���ִ�Сд
///�� �����ֵ������ά�� �˵�����ά��
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
			{var incicode=Ext.getCmp(incicode).getValue();} //���ʴ���
		    var incidesc=elemarr[1];
		    if (incidesc!="")
			{var incidesc=Ext.getCmp(incidesc).getValue();} //��������
		    var incictuom=elemarr[2];
		    if (incictuom!="")
			{var INCICTUom=Ext.getCmp(incictuom).getValue();} //������λ
		    var puctuompurch=elemarr[3];
		    if (stkcat!="")
			{var PUCTUomPurch=Ext.getCmp(puctuompurch).getValue();} //��ⵥλid
		    var stkcat=elemarr[4];
			if (stkcat!="")
			{var StkCat=Ext.getCmp(stkcat).getValue();} //������id
			var stkgrptype=elemarr[5];
			if (stkgrptype!="")
			{var StkGrpType=Ext.getCmp(stkgrptype).getValue();} //����
			var istrfflag=elemarr[6];
			if (istrfflag!="")
			{var INCIIsTrfFlag=Ext.getCmp(istrfflag).getValue();} //ת�Ʒ�ʽ
			var batchreq=elemarr[7];
			if (batchreq!="")
			{var INCIBatchReq=Ext.getCmp(batchreq).getValue();} //�Ƿ�Ҫ������
			var expreqnew=elemarr[8];
			if (expreqnew!="")
			{var INCIExpReqnew=Ext.getCmp(expreqnew).getValue();} //�Ƿ�Ҫ��Ч��
			var alias=elemarr[9];
			if (alias!="")
			{var INCAlias=Ext.getCmp(alias).getValue();} //����
			var notuseflag=elemarr[10];
			if (notuseflag!="")
			{var INCINotUseFlag=Ext.getCmp(notuseflag).getValue();} //�����ñ�־
			var reportingdays=elemarr[11];
			if (reportingdays!="")
			{var INCIReportingDays=Ext.getCmp(reportingdays).getValue();} //Э����
			var incibarcode=elemarr[12];
			if (incibarcode!="")
			{var INCIBarCode=Ext.getCmp(incibarcode).getValue();} //����
			var bsppuruom=elemarr[13];
			if (bsppuruom!="")
			{var INCIBSpPuruom=Ext.getCmp(bsppuruom).getValue();} //�ۼ�
			var brppuruom=elemarr[14];
			if (brppuruom!="")
			{var INCIBRpPuruom=Ext.getCmp(brppuruom).getValue();} //����
			var supplyloc=elemarr[15];
			if (supplyloc!="")
			{var supplyLocField=Ext.getCmp(supplyloc).getValue();} //��Ӧ�ֿ�
			var reqtype=elemarr[16];
			if (reqtype!="")
			{var reqType=Ext.getCmp(reqtype).getValue();} //������������
			var remark=elemarr[17];
			if (remark!="")
			{var remark=Ext.getCmp(remark).getValue();} //��ע
			var preexpdate=elemarr[18];
			if (preexpdate!="")
			{var PreExeDate=Ext.getCmp(preexpdate).getValue();} //�۸���Ч����
			var infospec=elemarr[19];
			if (infospec!="")
			{var INFOSpec=Ext.getCmp(infospec).getValue();} //���
			var infoimportfalg=elemarr[20];
			if (infoimportfalg!="")
			{var INFOImportFlag=Ext.getCmp(infoimportfalg).getValue();} //���ڱ�־
			var qualitylevel=elemarr[21];
			if (qualitylevel!="")
			{var INFOQualityLevel=Ext.getCmp(qualitylevel).getValue();} //�������
			var qualityno=elemarr[22];
			if (qualityno!="")
			{var INFOQualityNo=Ext.getCmp(qualityno).getValue();} //�������
			var comfrom=elemarr[23];
			if (comfrom!="")
			{var INFOComFrom=Ext.getCmp(comfrom).getValue();} //��/ʡ��
			var cergeno=elemarr[24];
			if (cergeno!="")
			{var INFORemark2=Ext.getCmp(cergeno).getValue();} //ע��֤��
			var highprice=elemarr[25];
			if (highprice!="")
			{var INFOHighPrice=Ext.getCmp(highprice).getValue();} //��ֵ���־
			var infomt=elemarr[26];
			if (infomt!="")
			{var INFOMT=Ext.getCmp(infomt).getValue();} //��������id
			var maxsp=elemarr[27];
			if (maxsp!="")
			{var INFOMaxSp=Ext.getCmp(maxsp).getValue();} //����ۼ�
			var inhosflag=elemarr[28];
			if (inhosflag!="")
			{var INFOInHosFlag=Ext.getCmp(inhosflag).getValue();} //��Ժ����Ŀ¼
			var pbflag=elemarr[29];
			if (pbflag!="")
			{var INFOPbFlag=Ext.getCmp(pbflag).getValue();} //�б��־
			var pbrp=elemarr[30];
			if (pbrp!="")
			{var INFOPbRp=Ext.getCmp(pbrp).getValue();} //�б����
			var pblevel=elemarr[31];
			if (pblevel!="")
			{var INFOPBLevel=Ext.getCmp(pblevel).getValue();} //�б꼶��
			var pbvendor=elemarr[32];
			if (pbvendor!="")
			{var INFOPbVendor=Ext.getCmp(pbvendor).getValue();} //�б깩Ӧ��id
			var pbmanf=elemarr[33];
			if (pbmanf!="")
			{var INFOPbManf=Ext.getCmp(pbmanf).getValue();} //�б�������id
			var pbcarrier=elemarr[34];
			if (pbcarrier!="")
			{var INFOPbCarrier=Ext.getCmp(pbcarrier).getValue();} //�б�������id
			var pbldr=elemarr[35];
			if (pbldr!="")
			{var INFOPBLDR=Ext.getCmp(pbldr).getValue();} //�б�����
			var baflag=elemarr[36];
			if (baflag!="")
			{var INFOBAflag=Ext.getCmp(baflag).getValue();} //һ���Ա�־
			var expirelen=elemarr[37];
			if (expirelen!="")
			{var INFOExpireLen=Ext.getCmp(expirelen).getValue();} //Ч�ڳ���
			var prcfile=elemarr[38];
			if (prcfile!="")
			{var INFOPrcFile=Ext.getCmp(prcfile).getValue();} //����ļ���
			var pricebakday=elemarr[39];
			if (pricebakday!="")
			{var INFOPriceBakD=Ext.getCmp(pricebakday).getValue();} //����ļ�����ʱ��
			var certexpdate=elemarr[40];
			if (certexpdate!="")
			{var IRRegCertExpDate=Ext.getCmp(certexpdate).getValue();} //ע��֤����
			var bcdr=elemarr[41];
			if (bcdr!="")
			{var INFOBCDr=Ext.getCmp(bcdr).getValue();} //�ʲ�����id
			var drugbasecode=elemarr[42];
			if (drugbasecode!="")
			{var INFODrugBaseCode=Ext.getCmp(drugbasecode).getValue();} //���ʱ�λ��
			var packuom=elemarr[43];
			if (packuom!="")
			{var PackUom=Ext.getCmp(packuom).getValue();} //���װ��λ
			var packuomfac=elemarr[44];
			if (packuomfac!="")
			{var PackUomFac=Ext.getCmp(packuomfac).getValue();} //���װ��λϵ��
			var highriskflag=elemarr[45];
			if (highriskflag!="")
			{var HighRiskFlag=Ext.getCmp(highriskflag).getValue();} //��Σ��־
			var notusereason=elemarr[46];
			if (notusereason!="")
			{var ItmNotUseReason=Ext.getCmp(notusereason).getValue();} //������ԭ��
			var phcdofficialtype=elemarr[47];
			if (phcdofficialtype!="")
			{var PHCDOfficialType=Ext.getCmp(phcdofficialtype).getValue();} //ҽ�����
			var brand=elemarr[48];
			if (brand!="")
			{var INFOBrand=Ext.getCmp(brand).getValue();} //Ʒ��
			var model=elemarr[49];
			if (model!="")
			{var INFOModel=Ext.getCmp(model).getValue();} //�ͺ�
			var chargeflag=elemarr[50];
			if (chargeflag!="")
			{var INFOChargeFlag=Ext.getCmp(chargeflag).getValue();} //�շѱ�־
			var abbrev=elemarr[51];
			if (abbrev!="")
			{var INFOAbbrev=Ext.getCmp(abbrev).getValue();} //���
			var supervision=elemarr[52];
			if (supervision!="")
			{var INFOSupervision=Ext.getCmp(supervision).getValue();} //��ܼ���
			var implantationmat=elemarr[53];
			if (implantationmat!="")
			{var INFOImplantationMat=Ext.getCmp(implantationmat).getValue();} //ֲ���־
			var nolocreq=elemarr[54];
			if (nolocreq!="")
			{var INFONoLocReq=Ext.getCmp(nolocreq).getValue();} //��ֹ�����־
			var steriledatelen=elemarr[55];
			if (steriledatelen!="")
			{var INFOSterileDateLen=Ext.getCmp(steriledatelen).getValue();} //���ʱ��
			var zerostk=elemarr[56];
			if (zerostk!="")
			{var INFOZeroStk=Ext.getCmp(zerostk).getValue();} //�����־
			var chargetype=elemarr[57];
			if (chargetype!="")
			{var INFOChargeType=Ext.getCmp(chargetype).getValue();} //�շ�����
			var medeqptcat=elemarr[58];
			if (medeqptcat!="")
			{var INFOMedEqptCat=Ext.getCmp(medeqptcat).getValue();} //��е����
			var packcharge=elemarr[59];
			if (packcharge!="")
			{var INFOPackCharge=Ext.getCmp(packcharge).getValue();} //�����־
			var irregcertdateofissue=elemarr[60];
			if (irregcertdateofissue!="")
			{var IRRegCertDateOfIssue=Ext.getCmp(irregcertdateofissue).getValue();} //ע��֤��֤����
			var irregcertitmdesc=elemarr[61];
			if (irregcertitmdesc!="")
			{var IRRegCertItmDesc=Ext.getCmp(irregcertitmdesc).getValue();} //ע��֤����
			var irregcertexpdateextended=elemarr[62];
			if (irregcertexpdateextended!="")
			{var IRRegCertExpDateExtended=Ext.getCmp(irregcertexpdateextended).getValue();}//ע��֤�ӳ�Ч��
			var biddate=elemarr[63];
			if (biddate!="")
			{var BidDate=Ext.getCmp(biddate).getValue();} //�б�����
			var origin=elemarr[64];
			if (origin!="")
			{var Origin=Ext.getCmp(origin).getValue();} //����
			var firstreqdept=elemarr[65];
			if (firstreqdept!="")
			{var FirstReqDept=Ext.getCmp(firstreqdept).getValue();} //���벿��
			var scategory=elemarr[66];
			if (scategory!="")
			{var SCategory=Ext.getCmp(scategory).getValue();} //�������
			var matquality=elemarr[67];
			if (matquality!="")
			{var MatQuality=Ext.getCmp(matquality).getValue();} //�ʵ�
			var hospzerostk=elemarr[68];
			if (hospzerostk!="")
			{var HospZeroStk=Ext.getCmp(hospzerostk).getValue();} //Ժ������
			var arcimcode=elemarr[69];
			if (arcimcode!="")
			{var ARCIMCode=Ext.getCmp(arcimcode).getValue();} //ҽ������
			var arcimdesc=elemarr[70];
			if (arcimdesc!="")
			{var ARCIMDesc=Ext.getCmp(arcimdesc).getValue();} //ҽ������
			var arcimuomdr=elemarr[71];
			if (arcimuomdr!="")
			{var ARCIMUomDR=Ext.getCmp(arcimuomdr).getValue();} //�Ƽ۵�λ
			var ordercategory=elemarr[72];
			if (ordercategory!="")
			{var OrderCategory=Ext.getCmp(ordercategory).getValue();} //ҽ������
			var arcitemcat=elemarr[73];
			if (arcitemcat!="")
			{var ARCItemCat=Ext.getCmp(arcitemcat).getValue();} //ҽ������
			var arcbillgrp=elemarr[74];
			if (arcbillgrp!="")
			{var ARCBillGrp=Ext.getCmp(arcbillgrp).getValue();} //���ô���
			var arcbillsub=elemarr[75];
			if (arcbillsub!="")
			{var ARCBillSub=Ext.getCmp(arcbillsub).getValue();} //��������
			var arcimorderonitsown=elemarr[76];
			if (arcimorderonitsown!="")
			{var ARCIMOrderOnItsOwn=Ext.getCmp(arcimorderonitsown).getValue();} //����ҽ��
			var oecpriority=elemarr[77];
			if (oecpriority!="")
			{var OECPriority=Ext.getCmp(oecpriority).getValue();} //ҽ�����ȼ�
			var wostockflag=elemarr[78];
			if (wostockflag!="")
			{var WoStockFlag=Ext.getCmp(wostockflag).getValue();} //�޿��ҽ��
			var arcimtext1=elemarr[79];
			if (arcimtext1!="")
			{var ARCIMText1=Ext.getCmp(arcimtext1).getValue();} //ҽ������
			var arcalias=elemarr[80];
			if (arcalias!="")
			{var ARCAlias=Ext.getCmp(arcalias).getValue();} //����
			var arcimabbrev=elemarr[81];
			if (arcimabbrev!="")
			{var ARCIMAbbrev=Ext.getCmp(arcimabbrev).getValue();} //��д
			var phcdofficialtype=elemarr[82];
			if (phcdofficialtype!="")
			{var PHCDOfficialType=Ext.getCmp(phcdofficialtype).getValue();} //ҽ�����
			var arcimnoofcumdays=elemarr[83];
			if (arcimnoofcumdays!="")
			{var ARCIMNoOfCumDays=Ext.getCmp(arcimnoofcumdays).getValue();} //����ʹ������
			var arcimoemessage=elemarr[84];
			if (arcimoemessage!="")
			{var ARCIMOEMessage=Ext.getCmp(arcimoemessage).getValue();} //ҽ����ʾ
			var billnotactive=elemarr[85];
			if (billnotactive!="")
			{var BillNotActive=Ext.getCmp(billnotactive).getValue();} //��ά���շ���
			var billcode=elemarr[86];
			if (billcode!="")
			{var BillCode=Ext.getCmp(billcode).getValue();} //�շ������
			var billname=elemarr[87];
			if (billname!="")
			{var BillName=Ext.getCmp(billname).getValue();} //�շ�������
			var subtypefee=elemarr[88];
			if (subtypefee!="")
			{var SubTypeFee=Ext.getCmp(subtypefee).getValue();} //�ӷ���
			var insubtypefee=elemarr[89];
			if (insubtypefee!="")
			{var InSubTypeFee=Ext.getCmp(insubtypefee).getValue();} //סԺ�ӷ���
			var outsubtypefee=elemarr[90];
			if (outsubtypefee!="")
			{var OutSubTypeFee=Ext.getCmp(outsubtypefee).getValue();} //�����ӷ���
			var accsubtypefee=elemarr[91];
			if (accsubtypefee!="")
			{var AccSubTypeFee=Ext.getCmp(accsubtypefee).getValue();} //�����ӷ���
			var medsubtypefee=elemarr[92];
			if (medsubtypefee!="")
			{var MedSubTypeFee=Ext.getCmp(medsubtypefee).getValue();} //������ҳ�ӷ���
			var newmedsubtypefee=elemarr[93];
			if (newmedsubtypefee!="")
			{var NewMedSubTypeFee=Ext.getCmp(newmedsubtypefee).getValue();} //�²�����ҳ�ӷ���
			var accountsubtypefee=elemarr[94];
			if (accountsubtypefee!="")
			{var AccountSubTypeFee=Ext.getCmp(accountsubtypefee).getValue();} //����ӷ���
			var medpromaintain=elemarr[95];
			if (medpromaintain!="")
			{var MedProMaintain=Ext.getCmp(medpromaintain).getValue();} //ά��ҽ����
			var arcimeffdate=elemarr[96];
			if (arcimeffdate!="")
			{var ARCIMEffDate=Ext.getCmp(arcimeffdate).getValue();} //��Ч����
			var arcimeffdateto=elemarr[97];
			if (arcimeffdateto!="")
			{var ARCIMEffDateTo=Ext.getCmp(arcimeffdateto).getValue();} //��ֹ����
            var arcsppuruom=elemarr[98];
            if (arcsppuruom!="")
			{var ArcSpPuruom=Ext.getCmp(arcsppuruom).getValue();} //�ۼ�(ҽ��)
            var arcpreexedate=elemarr[99];
			if (arcpreexedate!="")
			{var ArcPreExeDate=Ext.getCmp(arcpreexedate).getValue();} //�۸���Ч����(ҽ��)
			var arciminfomt=elemarr[100];
			if (arciminfomt!="")
			{var ArcimINFOMT=Ext.getCmp(arciminfomt).getValue();} //��������(ҽ��)
			var arcimrppuruom=elemarr[101];
			if (arcimrppuruom!="")
			{var ArcimRpPuruom=Ext.getCmp(arcimrppuruom).getValue();} //����(ҽ��)
			
			
			
            

		  var elemflags=tkMakeServerCall("web.DHCSTM.InciInfoMustInput","getElemetstrflag",elements,cspname);
		  var elemflagarr=elemflags.split("^");
		  if (elemflagarr.length>0)
		  {
			  //�������Ϣ
			  var incicodeflag=elemflagarr[0];
			  if ((incicodeflag=="Y")&&((incicode==null)||(incicode==""))){
				  Msg.info("warning","���ʴ��벻����Ϊ��!");
				  return false;
			     }
			  var incidescflag=elemflagarr[1];
			  if ((incidescflag=="Y")&&((incidesc==null)||(incidesc==""))){
				  Msg.info("warning","�������Ʋ�����Ϊ��!");
				  return false;
			     }
			  var incictuomflag=elemflagarr[2];
			  if ((incictuomflag=="Y")&&((INCICTUom==null)||(INCICTUom==""))){
				  Msg.info("warning","������λ������Ϊ��!");
				  return false;
			     }
			  var puctuompurchflag=elemflagarr[3];
			  if ((puctuompurchflag=="Y")&&((PUCTUomPurch==null)||(PUCTUomPurch==""))){
				  Msg.info("warning","��ⵥλ������Ϊ��!");
				  return false;
			     }
			  var stkcatflag=elemflagarr[4];
			  if ((stkcatflag=="Y")&&((StkCat==null)||(StkCat==""))){
				  Msg.info("warning","�����಻����Ϊ��!");
				  return false;
			     }
			  var stkgrptypeflag=elemflagarr[5];
			  if ((stkgrptypeflag=="Y")&&((StkGrpType==null)||(StkGrpType==""))){
				  Msg.info("warning","���鲻����Ϊ��!");
				  return false;
			     }
			  var istrfflagflag=elemflagarr[6];
			  var batchreqflag=elemflagarr[7];
			  var expreqnewflag=elemflagarr[8];
			  var aliasflag=elemflagarr[9];
			  var notuseflagflag=elemflagarr[10];
			  var reportingdaysflag=elemflagarr[11];
			  if ((reportingdaysflag=="Y")&&((INCIReportingDays==null)||(INCIReportingDays==""))){
				  Msg.info("warning","Э���벻����Ϊ��!");
				  return false;
			     }
			  var incibarcodeflag=elemflagarr[12];
			  if ((incibarcodeflag=="Y")&&((INCIBarCode==null)||(INCIBarCode==""))){
				  Msg.info("warning","���벻����Ϊ��!");
				  return false;
			     }
			  var bsppuruomflag=elemflagarr[13];
			  if ((bsppuruomflag=="Y")&&((INCIBSpPuruom===null)||(INCIBSpPuruom===""))){
				  Msg.info("warning","�ۼ۲�����Ϊ��!");
				  return false;
			     }
			  var brppuruomflag=elemflagarr[14];
			  if ((brppuruomflag=="Y")&&((INCIBRpPuruom===null)||(INCIBRpPuruom===""))){
					  Msg.info("warning","���۲�����Ϊ��!");
					  return false;
				  }
			  var supplylocflag=elemflagarr[15];
			  if ((supplylocflag=="Y")&&((supplyLocField==null)||(supplyLocField==""))){
				  Msg.info("warning","��Ӧ�ֿⲻ����Ϊ��!");
				  return false;
			     }
			  var reqtypeflag=elemflagarr[16];
			  if ((reqtypeflag=="Y")&&((reqType==null)||(reqType==""))){
				  Msg.info("warning","�����������Ͳ�����Ϊ��!");
				  return false;
			     }
			  var remarkflag=elemflagarr[17];
			  var preexpdateflag=elemflagarr[18];
			  var infospecflag=elemflagarr[19];
			  if ((infospecflag=="Y")&&((INFOSpec==null)||(INFOSpec==""))){
				  Msg.info("warning","��񲻿���Ϊ��!");
				  return false;
			     }
			  var infoimportfalgflag=elemflagarr[20];
			  if ((infoimportfalgflag=="Y")&&((INFOImportFlag==null)||(INFOImportFlag==""))){
				  Msg.info("warning","���ڱ�־������Ϊ��!");
				  return false;
			     }
			  var qualitylevelflag=elemflagarr[21];
			  if ((qualitylevelflag=="Y")&&((INFOQualityLevel==null)||(INFOQualityLevel==""))){
				  Msg.info("warning","������β�����Ϊ��!");
				  return false;
			     }
			  var qualitynoflag=elemflagarr[22];
			  if ((qualitynoflag=="Y")&&((INFOQualityNo==null)||(INFOQualityNo==""))){
				  Msg.info("warning","������Ų�����Ϊ��!");
				  return false;
			     }
			  var comfromflag=elemflagarr[23];
			  if ((comfromflag=="Y")&&((INFOComFrom==null)||(INFOComFrom==""))){
				  Msg.info("warning","��/ʡ�𲻿���Ϊ��!");
				  return false;
			     }
			  var cergenoflag=elemflagarr[24];
			  if ((cergenoflag=="Y")&&((INFORemark2==null)||(INFORemark2==""))){
				  Msg.info("warning","ע��֤�Ų�����Ϊ��!");
				  return false;
			     }
			  var highpriceflag=elemflagarr[25];
			  var infomtflag=elemflagarr[26];
			  if ((infomtflag=="Y")&&((INFOMT==null)||(INFOMT==""))){
				  Msg.info("warning","�������Ͳ�����Ϊ��!");
				  return false;
			     }
			  var maxspflag=elemflagarr[27];
			  if ((maxspflag=="Y")&&((INFOMaxSp===null)||(INFOMaxSp===""))){
				  Msg.info("warning","����ۼ۲�����Ϊ��!");
				  return false;
			     }
			  var inhosflagflag=elemflagarr[28];
			  var pbflagflag=elemflagarr[29];
			  var pbrpflag=elemflagarr[30];
			  if ((pbrpflag=="Y")&&((INFOPbRp===null)||(INFOPbRp===""))){
				  Msg.info("warning","�б���۲�����Ϊ��!");
				  return false;
			     }
			  var pblevelflag=elemflagarr[31];
			  if ((pblevelflag=="Y")&&((INFOPBLevel==null)||(INFOPBLevel==""))){
				  Msg.info("warning","�б꼶�𲻿���Ϊ��!");
				  return false;
			     }
			  var pbvendorflag=elemflagarr[32];
			  if ((pbvendorflag=="Y")&&((INFOPbVendor==null)||(INFOPbVendor==""))){
				  Msg.info("warning","�б깩Ӧ�̲�����Ϊ��!");
				  return false;
			     }
			  var pbmanfflag=elemflagarr[33];
			  if ((pbmanfflag=="Y")&&((INFOPbManf==null)||(INFOPbManf==""))){
				  Msg.info("warning","�б������̲�����Ϊ��!");
				  return false;
			     }
			  var pbcarrierflag=elemflagarr[34];
			  if ((pbcarrierflag=="Y")&&((INFOPbCarrier==null)||(INFOPbCarrier==""))){
				  Msg.info("warning","�б������̲�����Ϊ��!");
				  return false;
			     }
			  var pbldrflag=elemflagarr[35];
			  if ((pbldrflag=="Y")&&((INFOPBLDR==null)||(INFOPBLDR==""))){
				  Msg.info("warning","�б����Ʋ�����Ϊ��!");
				  return false;
			     }
			  var baflagflag=elemflagarr[36];
			  var expirelenflag=elemflagarr[37];
			  if ((expirelenflag=="Y")&&((INFOExpireLen===null)||(INFOExpireLen===""))){
				  Msg.info("warning","Ч�ڳ��Ȳ�����Ϊ��!");
				  return false;
			     }
			  var prcfileflag=elemflagarr[38];
			  if ((prcfileflag=="Y")&&((INFOPrcFile==null)||(INFOPrcFile==""))){
				  Msg.info("warning","����ļ��Ų�����Ϊ��!");
				  return false;
			     }
			  var pricebakdayflag=elemflagarr[39];
			  if ((pricebakdayflag=="Y")&&((INFOPriceBakD==null)||(INFOPriceBakD==""))){
				  Msg.info("warning","����ļ�����ʱ�䲻����Ϊ��!");
				  return false;
			     }
			  var certexpdateflag=elemflagarr[40];
			  if ((certexpdateflag=="Y")&&((IRRegCertExpDate==null)||(IRRegCertExpDate==""))){
				  Msg.info("warning","ע��֤���ڲ�����Ϊ��!");
				  return false;
			     }
			  var bcdrflag=elemflagarr[41];
			  if ((bcdrflag=="Y")&&((INFOBCDr==null)||(INFOBCDr==""))){
				  Msg.info("warning","�ʲ����಻����Ϊ��!");
				  return false;
			     }
			  var drugbasecodeflag=elemflagarr[42];
			  if ((drugbasecodeflag=="Y")&&((INFODrugBaseCode==null)||(INFODrugBaseCode==""))){
				  Msg.info("warning","���ʱ�λ�벻����Ϊ��!");
				  return false;
			     }
			  var packuomflag=elemflagarr[43];
			  if ((packuomflag=="Y")&&((PackUom==null)||(PackUom==""))){
				  Msg.info("warning","���װ��λ������Ϊ��!");
				  return false;
			     }
			  var packuomfacflag=elemflagarr[44];
			  if ((packuomfacflag=="Y")&&((PackUomFac==null)||(PackUomFac==""))){
				  Msg.info("warning","���װ��λϵ��������Ϊ��!");
				  return false;
			     }
			  var highriskflagflag=elemflagarr[45];
			  var notusereasonflag=elemflagarr[46];
			  var phcdofficialtypeflag=elemflagarr[47];
			  if ((phcdofficialtypeflag=="Y")&&((PHCDOfficialType==null)||(PHCDOfficialType==""))){
				  Msg.info("warning","ҽ����𲻿���Ϊ��!");
				  return false;
			     }
			  var brandflag=elemflagarr[48];
			  if ((brandflag=="Y")&&((INFOBrand==null)||(INFOBrand==""))){
				  Msg.info("warning","Ʒ�Ʋ�����Ϊ��!");
				  return false;
			     }
			  var modelflag=elemflagarr[49];
			  if ((modelflag=="Y")&&((INFOModel==null)||(INFOModel==""))){
				  Msg.info("warning","�ͺŲ�����Ϊ��!");
				  return false;
			     }
			  var chargeflagflag=elemflagarr[50];
			  var abbrevflag=elemflagarr[51];
			  if ((abbrevflag=="Y")&&((INFOAbbrev==null)||(INFOAbbrev==""))){
				  Msg.info("warning","��Ʋ�����Ϊ��!");
				  return false;
			     }
			  var supervisionflag=elemflagarr[52];
			  if ((supervisionflag=="Y")&&((INFOSupervision==null)||(INFOSupervision==""))){
				  Msg.info("warning","��ܼ��𲻿���Ϊ��!");
				  return false;
			     }
			  var implantationmatflag=elemflagarr[53];
			  var nolocreqflag=elemflagarr[54];
			  var steriledatelenflag=elemflagarr[55];
			  var zerostkflag=elemflagarr[56];
			  var chargetypeflag=elemflagarr[57];
			  if ((chargetypeflag=="Y")&&((INFOChargeType==null)||(INFOChargeType==""))){
				  Msg.info("warning","�շ����Ͳ�����Ϊ��!");
				  return false;
			     }
			  var medeqptcatflag=elemflagarr[58];
			  if ((medeqptcatflag=="Y")&&((INFOMedEqptCat==null)||(INFOMedEqptCat==""))){
				  Msg.info("warning","��е���಻����Ϊ��!");
				  return false;
			     }
			  var packchargeflag=elemflagarr[59];
			  var irregcertdateofissueflag=elemflagarr[60];
			  if ((irregcertdateofissueflag=="Y")&&((IRRegCertDateOfIssue==null)||(IRRegCertDateOfIssue==""))){
				  Msg.info("warning","ע��֤��֤���ڲ�����Ϊ��!");
				  return false;
			     }
				var irregcertitmdescflag=elemflagarr[61];
				if ((irregcertitmdescflag=="Y")&&((IRRegCertItmDesc==null)||(IRRegCertItmDesc==""))){
				  Msg.info("warning","ע��֤���Ʋ�����Ϊ��!");
				  return false;
			     }
				var irregcertexpdateextendedflag=elemflagarr[62];
				var biddateflag=elemflagarr[63];
				if ((biddateflag=="Y")&&((biddate==null)||(biddate==""))){
				  Msg.info("warning","�б����ڲ�����Ϊ��!");
				  return false;
			     }
				var originflag=elemflagarr[64];
				if ((originflag=="Y")&&((Origin==null)||(Origin==""))){
				  Msg.info("warning","���ز�����Ϊ��!");
				  return false;
			     }
				var firstreqdeptflag=elemflagarr[65];
				if ((firstreqdeptflag=="Y")&&((firstreqdept==null)||(firstreqdept==""))){
				  Msg.info("warning","���벿�Ų�����Ϊ��!");
				  return false;
			     }
				var scategoryflag=elemflagarr[66];
				if ((scategoryflag=="Y")&&((SCategory==null)||(SCategory==""))){
				  Msg.info("warning","������಻����Ϊ��!");
				  return false;
			     }
				var matqualityflag=elemflagarr[67];
				if ((matqualityflag=="Y")&&((MatQuality==null)||(MatQuality==""))){
				  Msg.info("warning","�ʵز�����Ϊ��!");
				  return false;
			     }
				var hospzerostkflag=elemflagarr[68];
				if ((hospzerostkflag=="Y")&&((HospZeroStk==null)||(HospZeroStk==""))){
				  Msg.info("warning","Ժ�����治����Ϊ��!");
				  return false;
			     }
			     ///�ж��Ƿ�ѡ�շѱ�־
			    if (chargeflag=="Y"){
				var arcimcodeflag=elemflagarr[69]; //ҽ������ǰ̨������
				var arcimdescflag=elemflagarr[70];
				if ((arcimdescflag=="Y")&&((ARCIMDesc==null)||(ARCIMDesc==""))){
				  Msg.info("warning","ҽ�����Ʋ�����Ϊ��!");
				  return false;
			     }
				var arcimuomdrflag=elemflagarr[71];
				if ((arcimuomdrflag=="Y")&&((ARCIMUomDR==null)||(ARCIMUomDR==""))){
				  Msg.info("warning","�Ƽ۵�λ������Ϊ��!");
				  return false;
			     }
				var ordercategoryflag=elemflagarr[72];
				if ((ordercategoryflag=="Y")&&((OrderCategory==null)||(OrderCategory==""))){
				  Msg.info("warning","ҽ�����಻����Ϊ��!");
				  return false;
			     }
				var arcitemcatflag=elemflagarr[73];
				if ((arcitemcatflag=="Y")&&((ARCItemCat==null)||(ARCItemCat==""))){
				  Msg.info("warning","ҽ�����಻����Ϊ��!");
				  return false;
			     }
				var arcbillgrpflag=elemflagarr[74];
				if ((arcbillgrpflag=="Y")&&((ARCBillGrp==null)||(ARCBillGrp==""))){
				  Msg.info("warning","���ô��಻����Ϊ��!");
				  return false;
			     }
				var arcbillsubflag=elemflagarr[75];
				if ((arcbillsubflag=="Y")&&((ARCBillSub==null)||(ARCBillSub==""))){
				  Msg.info("warning","�������಻����Ϊ��!");
				  return false;
			     }
				var arcimorderonitsownflag=elemflagarr[76];
				var oecpriorityflag=elemflagarr[77];
				if ((oecpriorityflag=="Y")&&((OECPriority==null)||(OECPriority==""))){
				  Msg.info("warning","ҽ�����ȼ�������Ϊ��!");
				  return false;
			     }
				var wostockflagflag=elemflagarr[78];
				var arcimtext1flag=elemflagarr[79];
				if ((arcimtext1flag=="Y")&&((ARCIMText1==null)||(ARCIMText1==""))){
				  Msg.info("warning","ҽ�����Ʋ�����Ϊ��!");
				  return false;
			     }
				var arcaliasflag=elemflagarr[80];
				var arcimabbrevflag=elemflagarr[81];
				var phcdofficialtypeflag=elemflagarr[82];
				if ((phcdofficialtypeflag=="Y")&&((PHCDOfficialType==null)||(PHCDOfficialType==""))){
				  Msg.info("warning","ҽ����𲻿���Ϊ��!");
				  return false;
			     }
				var arcimnoofcumdaysflag=elemflagarr[83];
				if ((arcimnoofcumdaysflag=="Y")&&((ARCIMNoOfCumDays==null)||(ARCIMNoOfCumDays==""))){
				  Msg.info("warning","����ʹ������������Ϊ��!");
				  return false;
			     }
				var arcimoemessageflag=elemflagarr[84];
				if ((arcimoemessageflag=="Y")&&((ARCIMOEMessage==null)||(ARCIMOEMessage==""))){
				  Msg.info("warning","ҽ����ʾ������Ϊ��!");
				  return false;
			     }
				var billnotactiveflag=elemflagarr[85];
				var billcodeflag=elemflagarr[86];
				if ((billcodeflag=="Y")&&((BillCode==null)||(BillCode==""))){
				  Msg.info("warning","�շ�����벻����Ϊ��!");
				  return false;
			     }
				var billnameflag=elemflagarr[87];
				if ((billnameflag=="Y")&&((BillName==null)||(BillName==""))){
				  Msg.info("warning","�շ������Ʋ�����Ϊ��!");
				  return false;
			     }
				var subtypefeeflag=elemflagarr[88];
				if ((subtypefeeflag=="Y")&&((SubTypeFee==null)||(SubTypeFee==""))){
				  Msg.info("warning","�ӷ��಻����Ϊ��!");
				  return false;
			     }
				var insubtypefeeflag=elemflagarr[89];
				if ((insubtypefeeflag=="Y")&&((InSubTypeFee==null)||(InSubTypeFee==""))){
				  Msg.info("warning","סԺ�ӷ��಻����Ϊ��!");
				  return false;
			     }
				var outsubtypefeeflag=elemflagarr[90];
				if ((outsubtypefeeflag=="Y")&&((OutSubTypeFee==null)||(OutSubTypeFee==""))){
				  Msg.info("warning","�����ӷ��಻����Ϊ��!");
				  return false;
			     }
				var accsubtypefeeflag=elemflagarr[91];
				if ((accsubtypefeeflag=="Y")&&((AccSubTypeFee==null)||(AccSubTypeFee==""))){
				  Msg.info("warning","�����ӷ��಻����Ϊ��!");
				  return false;
			     }
				var medsubtypefeeflag=elemflagarr[92];
				if ((medsubtypefeeflag=="Y")&&((MedSubTypeFee==null)||(MedSubTypeFee==""))){
				  Msg.info("warning","������ҳ�ӷ��಻����Ϊ��!");
				  return false;
			     }
				var newmedsubtypefeeflag=elemflagarr[93];
				if ((newmedsubtypefeeflag=="Y")&&((NewMedSubTypeFee==null)||(NewMedSubTypeFee==""))){
				  Msg.info("warning","�²�����ҳ�ӷ��಻����Ϊ��!");
				  return false;
			     }
				var accountsubtypefeeflag=elemflagarr[94];
				if ((accountsubtypefeeflag=="Y")&&((AccountSubTypeFee==null)||(AccountSubTypeFee==""))){
				  Msg.info("warning","����ӷ��಻����Ϊ��!");
				  return false;
			     }
				var medpromaintainflag=elemflagarr[95];
				if ((medpromaintainflag=="Y")&&((MedProMaintain==null)||(MedProMaintain==""))){
				  Msg.info("warning","ά��ҽ�������Ϊ��!");
				  return false;
			     }
				var arcimeffdateflag=elemflagarr[96];
				if ((arcimeffdateflag=="Y")&&((ARCIMEffDate==null)||(ARCIMEffDate==""))){
				  Msg.info("warning","��Ч���ڲ�����Ϊ��!");
				  return false;
			     }
				var arcimeffdatetoflag=elemflagarr[97];
				var arcsppuruomflag=elemflagarr[98];
				if ((arcsppuruomflag=="Y")&&((ArcSpPuruom==null)||(ArcSpPuruom==""))){
				  Msg.info("warning","�ۼ�(ҽ��)������Ϊ��!");
				  return false;
			     }
				var arcpreexedateflag=elemflagarr[99];
				var arciminfomtflag=elemflagarr[100];
				if ((arciminfomtflag=="Y")&&((ArcimINFOMT==null)||(ArcimINFOMT==""))){
				  Msg.info("warning","��������(ҽ��)������Ϊ��!");
				  return false;
			     }
				var arcimrppuruomflag=elemflagarr[101];
			    }
			  
		  }
	  }
  
  
}


///�ı�ؼ�Ԫ��������ʽ
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
		  //�����
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
			 //�������Ϣ
			 //alert(document.getElementById(incicode))
			 //alert(document.getElementById(arcimcode))
			 if(document.getElementById(incicode)==null){  //���ص�ʱ������ؼ���ϢΪnull
		         var incicodeflag=elemflagarr[0];
			  if(incicodeflag=="Y"){
		      var incicodelabel="����";
			  Ext.getCmp(incicode).fieldLabel="<font color=red>"+incicodelabel+"</font>";  //���ʴ���
			  }
			  var incidescflag=elemflagarr[1];
			  if(incidescflag=="Y"){
		      var incidesclabel="����";
			  Ext.getCmp(incidesc).fieldLabel="<font color=red>"+incidesclabel+"</font>";  //��������
			  }
			  var incictuomflag=elemflagarr[2];
			  if(incictuomflag=="Y"){
		      var incictuomlabel="������λ";
			  Ext.getCmp(incictuom).fieldLabel="<font color=red>"+incictuomlabel+"</font>"; 
			  }
			  var puctuompurchflag=elemflagarr[3];
			  if(puctuompurchflag=="Y"){
		      var puctuompurchlabel="��ⵥλ";
			  Ext.getCmp(puctuompurch).fieldLabel="<font color=red>"+puctuompurchlabel+"</font>"; 
			  }
			  var stkcatflag=elemflagarr[4];
			  if(stkcatflag=="Y"){
		      var stkcatlabel="������";
			  Ext.getCmp(stkcat).fieldLabel="<font color=red>"+stkcatlabel+"</font>"; 
			  }
			  var stkgrptypeflag=elemflagarr[5];
			  if(stkgrptypeflag=="Y"){
		      var stkgrptypelabel="����";
			  Ext.getCmp(stkgrptype).fieldLabel="<font color=red>"+stkgrptypelabel+"</font>"; 
			  }
			  var istrfflagflag=elemflagarr[6];//ת�Ʒ�ʽ
			  var batchreqflag=elemflagarr[7];//�Ƿ�Ҫ������
			  var expreqnewflag=elemflagarr[8];//�Ƿ�Ҫ��Ч��
			  var aliasflag=elemflagarr[9];//����
			  var notuseflagflag=elemflagarr[10];//�����ñ�־
			  var reportingdaysflag=elemflagarr[11];//Э����
			  if(reportingdaysflag=="Y"){
		      var reportingdayslabel="Э����";
			  Ext.getCmp(reportingdays).fieldLabel="<font color=red>"+reportingdayslabel+"</font>"; 
			  }
			  var incibarcodeflag=elemflagarr[12];//����
			  if(incibarcodeflag=="Y"){
		      var incibarcodelabel="����";
			  Ext.getCmp(incibarcode).fieldLabel="<font color=red>"+incibarcodelabel+"</font>"; 
			  }
			  var bsppuruomflag=elemflagarr[13];//�ۼ�
			  if(bsppuruomflag=="Y"){
		      var bsppuruomlabel="�ۼ�";
			  Ext.getCmp(bsppuruom).fieldLabel="<font color=red>"+bsppuruomlabel+"</font>"; 
			  }
			  var brppuruomflag=elemflagarr[14];//����
			  if(brppuruomflag=="Y"){
		      var brppuruomlabel="����";
			  Ext.getCmp(brppuruom).fieldLabel="<font color=red>"+brppuruomlabel+"</font>"; 
			  }
			  var supplylocflag=elemflagarr[15];//��Ӧ�ֿ�
			  if(supplylocflag=="Y"){
		      var supplyloclabel="��Ӧ�ֿ�";
			  Ext.getCmp(supplyloc).fieldLabel="<font color=red>"+supplyloclabel+"</font>"; 
			  }
			  var reqtypeflag=elemflagarr[16];//������������
			  if(reqtypeflag=="Y"){
		      var reqtypelabel="������������";
			  Ext.getCmp(reqtype).fieldLabel="<font color=red>"+reqtypelabel+"</font>"; 
			  }
			  var remarkflag=elemflagarr[17];//��ע
			  var preexpdateflag=elemflagarr[18];//�۸���Ч����
			  var infospecflag=elemflagarr[19];//���
			  if(infospecflag=="Y"){
		      var infospeclabel="���";
			  Ext.getCmp(infospec).fieldLabel="<font color=red>"+infospeclabel+"</font>"; 
			  }
			  var infoimportfalgflag=elemflagarr[20];//���ڱ�־
			  if(infoimportfalgflag=="Y"){
		      var infoimportfalglabel="���ڱ�־";
			  Ext.getCmp(infoimportfalg).fieldLabel="<font color=red>"+infoimportfalglabel+"</font>"; 
			  }
			  var qualitylevelflag=elemflagarr[21];//�������
			  if(qualitylevelflag=="Y"){
		      var qualitylevellabel="�������";
			  Ext.getCmp(qualitylevel).fieldLabel="<font color=red>"+qualitylevellabel+"</font>"; 
			  }
			  var qualitynoflag=elemflagarr[22];//�������
			  if(qualitynoflag=="Y"){
		      var qualitynolabel="�������";
			  Ext.getCmp(qualityno).fieldLabel="<font color=red>"+qualitynolabel+"</font>"; 
			  }
			  var comfromflag=elemflagarr[23];//��/ʡ��
			  if(comfromflag=="Y"){
		      var comfromlabel="��/ʡ��";
			  Ext.getCmp(comfrom).fieldLabel="<font color=red>"+comfromlabel+"</font>"; 
			  }
			  var cergenoflag=elemflagarr[24];//ע��֤��
			  if(cergenoflag=="Y"){
		      var cergenolabel="ע��֤��";
			  Ext.getCmp(cergeno).fieldLabel="<font color=red>"+cergenolabel+"</font>"; 
			  }
			  var highpriceflag=elemflagarr[25];//��ֵ���־
			  var infomtflag=elemflagarr[26];//��������id
			  if(infomtflag=="Y"){
		      var infomtlabel="��������";
			  Ext.getCmp(infomt).fieldLabel="<font color=red>"+infomtlabel+"</font>"; 
			  }
			  var maxspflag=elemflagarr[27];//����ۼ�
			  if(maxspflag=="Y"){
		      var maxsplabel="����ۼ�";
			  Ext.getCmp(maxsp).fieldLabel="<font color=red>"+maxsplabel+"</font>"; 
			  }
			  var inhosflagflag=elemflagarr[28];//��Ժ����Ŀ¼
			  var pbflagflag=elemflagarr[29];//�б��־
			  var pbrpflag=elemflagarr[30];//�б����
			  if(pbrpflag=="Y"){
		      var pbrplabel="�б����";
			  Ext.getCmp(pbrp).fieldLabel="<font color=red>"+pbrplabel+"</font>"; 
			  }
			  var pblevelflag=elemflagarr[31];//�б꼶��
			  if(pblevelflag=="Y"){
		      var pblevellabel="�б꼶��";
			  Ext.getCmp(pblevel).fieldLabel="<font color=red>"+pblevellabel+"</font>"; 
			  }
			  var pbvendorflag=elemflagarr[32];//�б깩Ӧ��id
			  if(pbvendorflag=="Y"){
		      var pbvendorlabel="�б깩Ӧ��";
			  Ext.getCmp(pbvendor).fieldLabel="<font color=red>"+pbvendorlabel+"</font>"; 
			  }
			  var pbmanfflag=elemflagarr[33];//�б�������id
			  if(pbmanfflag=="Y"){
		      var pbmanflabel="����";
			  Ext.getCmp(pbmanf).fieldLabel="<font color=red>"+pbmanflabel+"</font>"; 
			  }
			  var pbcarrierflag=elemflagarr[34];//�б�������id
			  if(pbcarrierflag=="Y"){
		      var pbcarrierlabel="�б�������";
			  Ext.getCmp(pbcarrier).fieldLabel="<font color=red>"+pbcarrierlabel+"</font>"; 
			  }
			  var pbldrflag=elemflagarr[35];//�б�����
			  if(pbldrflag=="Y"){
		      var pbldrlabel="�б�����";
			  Ext.getCmp(pbldr).fieldLabel="<font color=red>"+pbldrlabel+"</font>"; 
			  }
			  var baflagflag=elemflagarr[36];//һ���Ա�־
			  var expirelenflag=elemflagarr[37];//Ч�ڳ���(��)
			  if(expirelenflag=="Y"){
		      var expirelenlabel="Ч�ڳ���(��)";
			  Ext.getCmp(expirelen).fieldLabel="<font color=red>"+expirelenlabel+"</font>"; 
			  }
			  var prcfileflag=elemflagarr[38];//����ļ���
			  if(prcfileflag=="Y"){
		      var prcfilelabel="����ļ���";
			  Ext.getCmp(prcfile).fieldLabel="<font color=red>"+prcfilelabel+"</font>"; 
			  }
			  var pricebakdayflag=elemflagarr[39];//����ļ�����ʱ��
			  if(pricebakdayflag=="Y"){
		      var pricebakdaylabel="����ļ�����ʱ��";
			  Ext.getCmp(pricebakday).fieldLabel="<font color=red>"+pricebakdaylabel+"</font>"; 
			  }
			  var certexpdateflag=elemflagarr[40];//ע��֤����
			  if(certexpdateflag=="Y"){
		      var certexpdatelabel="ע��֤����";
			  Ext.getCmp(certexpdate).fieldLabel="<font color=red>"+certexpdatelabel+"</font>"; 
			  }
			  var bcdrflag=elemflagarr[41];//�ʲ�����id
			  if(bcdrflag=="Y"){
		      var bcdrlabel="�ʲ�����";
			  Ext.getCmp(bcdr).fieldLabel="<font color=red>"+bcdrlabel+"</font>"; 
			  }
			  var drugbasecodeflag=elemflagarr[42];//���ʱ�λ��
			  if(drugbasecodeflag=="Y"){
		      var drugbasecodelabel="���ʱ�λ��";
			  Ext.getCmp(drugbasecode).fieldLabel="<font color=red>"+drugbasecodelabel+"</font>"; 
			  }
			  var packuomflag=elemflagarr[43];//���װ��λ
			  if(packuomflag=="Y"){
		      var packuomlabel="���װ��λ";
			  Ext.getCmp(packuom).fieldLabel="<font color=red>"+packuomlabel+"</font>"; 
			  }
			  var packuomfacflag=elemflagarr[44];//���װ��λϵ��
			  if(packuomfacflag=="Y"){
		      var packuomfaclabel="���װ��λϵ��";
			  Ext.getCmp(packuomfac).fieldLabel="<font color=red>"+packuomfaclabel+"</font>"; 
			  }
			  var highriskflagflag=elemflagarr[45];//��Σ��־
			  var notusereasonflag=elemflagarr[46];//������ԭ��
			  var phcdofficialtypeflag=elemflagarr[47];//ҽ�����
			  if(phcdofficialtypeflag=="Y"){
		      var phcdofficialtypelabel="ҽ�����";
			  Ext.getCmp(phcdofficialtype).fieldLabel="<font color=red>"+phcdofficialtypelabel+"</font>"; 
			  }
			  var brandflag=elemflagarr[48];//Ʒ��
			  if(brandflag=="Y"){
		      var brandlabel="Ʒ��";
			  Ext.getCmp(brand).fieldLabel="<font color=red>"+brandlabel+"</font>"; 
			  }
			  var modelflag=elemflagarr[49];//�ͺ�
			  if(modelflag=="Y"){
		      var modellabel="�ͺ�";
			  Ext.getCmp(model).fieldLabel="<font color=red>"+modellabel+"</font>"; 
			  }
			  var chargeflagflag=elemflagarr[50];//�շѱ�־
			  var abbrevflag=elemflagarr[51];//���
			  if(abbrevflag=="Y"){
		      var abbrevlabel="���";
			  Ext.getCmp(abbrev).fieldLabel="<font color=red>"+abbrevlabel+"</font>"; 
			  }
			  var supervisionflag=elemflagarr[52];//��ܼ���
			  if(supervisionflag=="Y"){
		      var supervisionlabel="��ܼ���";
			  Ext.getCmp(supervision).fieldLabel="<font color=red>"+supervisionlabel+"</font>"; 
			  }
			  var implantationmatflag=elemflagarr[53];//ֲ���־
			  var nolocreqflag=elemflagarr[54];//��ֹ�����־
			  var steriledatelenflag=elemflagarr[55];//���ʱ��
			  if(steriledatelenflag=="Y"){
		      var steriledatelenlabel="���ʱ�䳤��";
			  Ext.getCmp(steriledatelen).fieldLabel="<font color=red>"+steriledatelenlabel+"</font>"; 
			  }
			  var zerostkflag=elemflagarr[56];//�����־
			  var chargetypeflag=elemflagarr[57];//�շ�����
			  if(chargetypeflag=="Y"){
		      var chargetypelabel="�շ�����";
			  Ext.getCmp(chargetype).fieldLabel="<font color=red>"+chargetypelabel+"</font>"; 
			  }
			  var medeqptcatflag=elemflagarr[58];//��е����
			  if(medeqptcatflag=="Y"){
		      var medeqptcatlabel="��е����";
			  Ext.getCmp(medeqptcat).fieldLabel="<font color=red>"+medeqptcatlabel+"</font>"; 
			  }
			  var packchargeflag=elemflagarr[59];//�����־
			  var irregcertdateofissueflag=elemflagarr[60];//ע��֤��֤����
			  if(irregcertdateofissueflag=="Y"){
		      var irregcertdateofissuelabel="ע��֤��֤����";
			  Ext.getCmp(irregcertdateofissue).fieldLabel="<font color=red>"+irregcertdateofissuelabel+"</font>"; 
			  }
			var irregcertitmdescflag=elemflagarr[61];//ע��֤����
			if(irregcertitmdescflag=="Y"){
		      var irregcertitmdesclabel="ע��֤����";
			  Ext.getCmp(irregcertitmdesc).fieldLabel="<font color=red>"+irregcertitmdesclabel+"</font>"; 
			  }
			var irregcertexpdateextendedflag=elemflagarr[62];//ע��֤�ӳ�Ч��
			var biddateflag=elemflagarr[63];//�б�����
			if(biddateflag=="Y"){
		      var biddatelabel="�б�����";
			  Ext.getCmp(biddate).fieldLabel="<font color=red>"+biddatelabel+"</font>"; 
			  }
			var originflag=elemflagarr[64];//����
			if(originflag=="Y"){
		      var originlabel="����";
			  Ext.getCmp(origin).fieldLabel="<font color=red>"+originlabel+"</font>"; 
			  }
			var firstreqdeptflag=elemflagarr[65];//���벿��
			if(firstreqdeptflag=="Y"){
		      var firstreqdeptlabel="���벿��";
			  Ext.getCmp(firstreqdept).fieldLabel="<font color=red>"+firstreqdeptlabel+"</font>"; 
			  }
			var scategoryflag=elemflagarr[66];//�������
			if(scategoryflag=="Y"){
		      var scategorylabel="�������";
			  Ext.getCmp(scategory).fieldLabel="<font color=red>"+scategorylabel+"</font>"; 
			  }
			var matqualityflag=elemflagarr[67];//�ʵ�
			if(matqualityflag=="Y"){
		      var matqualitylabel="�ʵ�";
			  Ext.getCmp(matquality).fieldLabel="<font color=red>"+matqualitylabel+"</font>"; 
			  }
			var hospzerostkflag=elemflagarr[68];//Ժ������
			if(hospzerostkflag=="Y"){
		      var hospzerostklabel="Ժ������";
			  Ext.getCmp(hospzerostk).fieldLabel="<font color=red>"+hospzerostklabel+"</font>"; 
			  }
		}else{
			  var incicodeflag=elemflagarr[0];
			  if(incicodeflag=="Y"){
		      var incicodelabel="����";
			  Ext.DomQuery.selectNode("label[for="+incicode+"]").innerHTML = '<font color=red>����</font>:';
			  }
			  var incidescflag=elemflagarr[1];
			  if(incidescflag=="Y"){
		      var incidesclabel="����";
		      Ext.DomQuery.selectNode("label[for="+incidesc+"]").innerHTML = '<font color=red>����</font>:';
			  }
			  var incictuomflag=elemflagarr[2];
			  if(incictuomflag=="Y"){
		      var incictuomlabel="������λ";
		      Ext.DomQuery.selectNode("label[for="+incictuom+"]").innerHTML = '<font color=red>������λ</font>:';
			  }
			  var puctuompurchflag=elemflagarr[3];
			  if(puctuompurchflag=="Y"){
		      var puctuompurchlabel="��ⵥλ";
			  Ext.DomQuery.selectNode("label[for="+puctuompurch+"]").innerHTML = '<font color=red>��ⵥλ</font>:';
			  }
			  var stkcatflag=elemflagarr[4];
			  if(stkcatflag=="Y"){
		      var stkcatlabel="������";
			  Ext.DomQuery.selectNode("label[for="+stkcat+"]").innerHTML = '<font color=red>������</font>:';
			  }
			  var stkgrptypeflag=elemflagarr[5];
			  if(stkgrptypeflag=="Y"){
		      var stkgrptypelabel="����";
		      Ext.DomQuery.selectNode("label[for="+stkgrptype+"]").innerHTML = '<font color=red>����</font>:';
			  }
			  var istrfflagflag=elemflagarr[6];//ת�Ʒ�ʽ
			  var batchreqflag=elemflagarr[7];//�Ƿ�Ҫ������
			  var expreqnewflag=elemflagarr[8];//�Ƿ�Ҫ��Ч��
			  var aliasflag=elemflagarr[9];//����
			  var notuseflagflag=elemflagarr[10];//�����ñ�־
			  var reportingdaysflag=elemflagarr[11];//Э����
			  if(reportingdaysflag=="Y"){
		      var reportingdayslabel="Э����";
			  Ext.DomQuery.selectNode("label[for="+reportingdays+"]").innerHTML = '<font color=red>Э����</font>:';
			  }
			  var incibarcodeflag=elemflagarr[12];//����
			  if(incibarcodeflag=="Y"){
		      var incibarcodelabel="����";
			  Ext.DomQuery.selectNode("label[for="+incibarcode+"]").innerHTML = '<font color=red>����</font>:';
			  }
			  var bsppuruomflag=elemflagarr[13];//�ۼ�
			  if(bsppuruomflag=="Y"){
		      var bsppuruomlabel="�ۼ�";
		      Ext.DomQuery.selectNode("label[for="+bsppuruom+"]").innerHTML = '<font color=red>�ۼ�</font>:';
			  }
			  var brppuruomflag=elemflagarr[14];//����
			  if(brppuruomflag=="Y"){
		      var brppuruomlabel="����";
			  Ext.DomQuery.selectNode("label[for="+brppuruom+"]").innerHTML = '<font color=red>����</font>:';
			  }
			  var supplylocflag=elemflagarr[15];//��Ӧ�ֿ�
			  if(supplylocflag=="Y"){
		      var supplyloclabel="��Ӧ�ֿ�";
		      Ext.DomQuery.selectNode("label[for="+supplyloc+"]").innerHTML = '<font color=red>��Ӧ�ֿ�</font>:';
			  }
			  var reqtypeflag=elemflagarr[16];//������������
			  if(reqtypeflag=="Y"){
		      var reqtypelabel="������������";
			  Ext.DomQuery.selectNode("label[for="+reqtype+"]").innerHTML = '<font color=red>������������</font>:';
			  }
			  var remarkflag=elemflagarr[17];//��ע
			  var preexpdateflag=elemflagarr[18];//�۸���Ч����
			  var infospecflag=elemflagarr[19];//���previousSibling
			  if(infospecflag=="Y"){
		      var infospeclabel="���";
			  document.getElementById(infospec).parentNode.parentNode.parentNode.previousSibling.innerHTML ="<font color=red>���</font>:"; 
			  }
			  var infoimportfalgflag=elemflagarr[20];//���ڱ�־
			  if(infoimportfalgflag=="Y"){
		      var infoimportfalglabel="���ڱ�־";
		      Ext.DomQuery.selectNode("label[for="+infoimportfalg+"]").innerHTML = '<font color=red>���ڱ�־</font>:';
			  }
			  var qualitylevelflag=elemflagarr[21];//�������
			  if(qualitylevelflag=="Y"){
		      var qualitylevellabel="�������";
		      Ext.DomQuery.selectNode("label[for="+qualitylevel+"]").innerHTML = '<font color=red>�������</font>:';
			  }
			  var qualitynoflag=elemflagarr[22];//�������
			  if(qualitynoflag=="Y"){
		      var qualitynolabel="�������";
			  Ext.DomQuery.selectNode("label[for="+qualityno+"]").innerHTML = '<font color=red>�������</font>:';
			  }
			  var comfromflag=elemflagarr[23];//��/ʡ��
			  if(comfromflag=="Y"){
		      var comfromlabel="��/ʡ��";
			  Ext.DomQuery.selectNode("label[for="+comfrom+"]").innerHTML = '<font color=red>��/ʡ��</font>:';
			  }
			  var cergenoflag=elemflagarr[24];//ע��֤��
			  if(cergenoflag=="Y"){
		      var cergenolabel="ע��֤��";
		      if(document.getElementById(cergeno).parentNode.parentNode.parentNode.previousSibling==null){
		      Ext.DomQuery.selectNode("label[for="+cergeno+"]").innerHTML = '<font color=red>ע��֤��</font>:';
		      }else{
			  document.getElementById(cergeno).parentNode.parentNode.parentNode.previousSibling.innerHTML ="<font color=red>ע��֤��</font>:"; 
			  }
			  }
			  var highpriceflag=elemflagarr[25];//��ֵ���־
			  var infomtflag=elemflagarr[26];//��������id
			  if(infomtflag=="Y"){
		      var infomtlabel="��������";
			  Ext.DomQuery.selectNode("label[for="+infomt+"]").innerHTML = '<font color=red>��������</font>:';
			  }
			  var maxspflag=elemflagarr[27];//����ۼ�
			  if(maxspflag=="Y"){
		      var maxsplabel="����ۼ�";
			  Ext.DomQuery.selectNode("label[for="+maxsp+"]").innerHTML = '<font color=red>����ۼ�</font>:';
			  }
			  var inhosflagflag=elemflagarr[28];//��Ժ����Ŀ¼
			  var pbflagflag=elemflagarr[29];//�б��־
			  var pbrpflag=elemflagarr[30];//�б����
			  if(pbrpflag=="Y"){
		      var pbrplabel="�б����";
			  Ext.DomQuery.selectNode("label[for="+pbrp+"]").innerHTML = '<font color=red>�б����</font>:';
			  }
			  var pblevelflag=elemflagarr[31];//�б꼶��
			  if(pblevelflag=="Y"){
		      var pblevellabel="�б꼶��";
			  Ext.DomQuery.selectNode("label[for="+pblevel+"]").innerHTML = '<font color=red>�б꼶��</font>:';
			  }
			  var pbvendorflag=elemflagarr[32];//�б깩Ӧ��id
			  if(pbvendorflag=="Y"){
		      var pbvendorlabel="�б깩Ӧ��";
			  document.getElementById(pbvendor).parentNode.parentNode.parentNode.parentNode.previousSibling.innerHTML ="<font color=red>�б깩Ӧ��</font>:"; 
			  }
			  var pbmanfflag=elemflagarr[33];//�б�������id
			  if(pbmanfflag=="Y"){
		      var pbmanflabel="����";
		      Ext.DomQuery.selectNode("label[for="+pbmanf+"]").innerHTML = '<font color=red>����</font>:';
			  }
			  var pbcarrierflag=elemflagarr[34];//�б�������id
			  if(pbcarrierflag=="Y"){
		      var pbcarrierlabel="�б�������";
		      Ext.DomQuery.selectNode("label[for="+pbcarrier+"]").innerHTML = '<font color=red>�б�������</font>:';
			  }
			  var pbldrflag=elemflagarr[35];//�б�����
			  if(pbldrflag=="Y"){
		      var pbldrlabel="�б�����";
		      Ext.DomQuery.selectNode("label[for="+pbldr+"]").innerHTML = '<font color=red>�б�����</font>:';
			  }
			  var baflagflag=elemflagarr[36];//һ���Ա�־
			  var expirelenflag=elemflagarr[37];//Ч�ڳ���(��)
			  if(expirelenflag=="Y"){
		      var expirelenlabel="Ч�ڳ���(��)";
		      Ext.DomQuery.selectNode("label[for="+expirelen+"]").innerHTML = '<font color=red>Ч�ڳ���(��)</font>:';
			  }
			  var prcfileflag=elemflagarr[38];//����ļ���
			  if(prcfileflag=="Y"){
		      var prcfilelabel="����ļ���";
		      Ext.DomQuery.selectNode("label[for="+prcfile+"]").innerHTML = '<font color=red>����ļ���</font>:';
			  }
			  var pricebakdayflag=elemflagarr[39];//����ļ�����ʱ��
			  if(pricebakdayflag=="Y"){
		      var pricebakdaylabel="����ļ�����ʱ��";
		      Ext.DomQuery.selectNode("label[for="+pricebakday+"]").innerHTML = '<font color=red>����ļ�����ʱ��</font>:';
			  }
			  var certexpdateflag=elemflagarr[40];//ע��֤����
			  if(certexpdateflag=="Y"){
		      var certexpdatelabel="ע��֤����";
		      Ext.DomQuery.selectNode("label[for="+certexpdate+"]").innerHTML = '<font color=red>ע��֤����</font>:';
			  }
			  var bcdrflag=elemflagarr[41];//�ʲ�����id
			  if(bcdrflag=="Y"){
		      var bcdrlabel="�ʲ�����";
		      Ext.DomQuery.selectNode("label[for="+bcdr+"]").innerHTML = '<font color=red>�ʲ�����</font>:';
			  }
			  var drugbasecodeflag=elemflagarr[42];//���ʱ�λ��
			  if(drugbasecodeflag=="Y"){
		      var drugbasecodelabel="���ʱ�λ��";
		      Ext.DomQuery.selectNode("label[for="+drugbasecode+"]").innerHTML = '<font color=red>���ʱ�λ��</font>:';
			  }
			  var packuomflag=elemflagarr[43];//���װ��λ
			  if(packuomflag=="Y"){
		      var packuomlabel="���װ��λ";
			  document.getElementById(packuom).parentNode.parentNode.parentNode.parentNode.previousSibling.innerHTML ="<font color=red>���װ��λ</font>:";
			  }
			  var packuomfacflag=elemflagarr[44];//���װ��λϵ��
			  if(packuomfacflag=="Y"){
		      var packuomfaclabel="���װ��λϵ��";
			  document.getElementById(packuomfac).previousSibling.innerHTML ="<font color=red>-���װ��λϵ��</font>:";
			  }
			  var highriskflagflag=elemflagarr[45];//��Σ��־
			  var notusereasonflag=elemflagarr[46];//������ԭ��
			  var phcdofficialtypeflag=elemflagarr[47];//ҽ�����
			  if(phcdofficialtypeflag=="Y"){
		      var phcdofficialtypelabel="ҽ�����";
		      Ext.DomQuery.selectNode("label[for="+phcdofficialtype+"]").innerHTML = '<font color=red>ҽ�����</font>:';
			  }
			  var brandflag=elemflagarr[48];//Ʒ��
			  if(brandflag=="Y"){
		      var brandlabel="Ʒ��";
		      Ext.DomQuery.selectNode("label[for="+brand+"]").innerHTML = '<font color=red>Ʒ��</font>:';
			  }
			  var modelflag=elemflagarr[49];//�ͺ�
			  if(modelflag=="Y"){
		      var modellabel="�ͺ�";
		      Ext.DomQuery.selectNode("label[for="+model+"]").innerHTML = '<font color=red>�ͺ�</font>:';
			  }
			  var chargeflagflag=elemflagarr[50];//�շѱ�־
			  var abbrevflag=elemflagarr[51];//���
			  if(abbrevflag=="Y"){
		      var abbrevlabel="���";
		      Ext.DomQuery.selectNode("label[for="+abbrev+"]").innerHTML = '<font color=red>���</font>:';
			  }
			  var supervisionflag=elemflagarr[52];//��ܼ���
			  if(supervisionflag=="Y"){
		      var supervisionlabel="��ܼ���";
		      Ext.DomQuery.selectNode("label[for="+supervision+"]").innerHTML = '<font color=red>��ܼ���</font>:';
			  }
			  var implantationmatflag=elemflagarr[53];//ֲ���־
			  var nolocreqflag=elemflagarr[54];//��ֹ�����־
			  var steriledatelenflag=elemflagarr[55];//���ʱ�䳤��
			  if(steriledatelenflag=="Y"){
		      var steriledatelenlabel="���ʱ�䳤��";
		      Ext.DomQuery.selectNode("label[for="+steriledatelen+"]").innerHTML = '<font color=red>���ʱ�䳤��</font>:';
			  }
			  var zerostkflag=elemflagarr[56];//�����־
			  var chargetypeflag=elemflagarr[57];//�շ�����
			  if(chargetypeflag=="Y"){
		      var chargetypelabel="�շ�����";
		      if(Ext.DomQuery.selectNode("label[for="+chargetype+"]")==null){
			  document.getElementById(chargetype).parentNode.parentNode.parentNode.parentNode.previousSibling.innerHTML ="<font color=red>�շ�����</font>:"; 
			  }else{
		      Ext.DomQuery.selectNode("label[for="+chargetype+"]").innerHTML = '<font color=red>�շ�����</font>:';
		      }
			  }
			  var medeqptcatflag=elemflagarr[58];//��е����
			  if(medeqptcatflag=="Y"){
		      var medeqptcatlabel="��е����";
		      if(Ext.DomQuery.selectNode("label[for="+medeqptcat+"]")==null){
			  document.getElementById(medeqptcat).parentNode.parentNode.parentNode.parentNode.previousSibling.innerHTML ="<font color=red>��е����</font>:"; 
			  }else{
		      Ext.DomQuery.selectNode("label[for="+medeqptcat+"]").innerHTML = '<font color=red>��е����</font>:';
			  }
			  }
			  var packchargeflag=elemflagarr[59];//�����־
			  var irregcertdateofissueflag=elemflagarr[60];//ע��֤��֤����
			  if(irregcertdateofissueflag=="Y"){
		      var irregcertdateofissuelabel="ע��֤��֤����";
		      Ext.DomQuery.selectNode("label[for="+irregcertdateofissue+"]").innerHTML = '<font color=red>ע��֤��֤����</font>:';
			  }
			var irregcertitmdescflag=elemflagarr[61];//ע��֤����
			if(irregcertitmdescflag=="Y"){
		      var irregcertitmdesclabel="ע��֤����";
		      Ext.DomQuery.selectNode("label[for="+irregcertitmdesc+"]").innerHTML = '<font color=red>ע��֤����</font>:';
			  }
			var irregcertexpdateextendedflag=elemflagarr[62];//ע��֤�ӳ�Ч��
			var biddateflag=elemflagarr[63];//�б�����
			if(biddateflag=="Y"){
		      var biddatelabel="�б�����";
		      Ext.DomQuery.selectNode("label[for="+biddate+"]").innerHTML = '<font color=red>�б�����</font>:';
			  }
			var originflag=elemflagarr[64];//����
			if(originflag=="Y"){
		      var originlabel="����";
		      Ext.DomQuery.selectNode("label[for="+origin+"]").innerHTML = '<font color=red>����</font>:';
			  }
			var firstreqdeptflag=elemflagarr[65];//���벿��
			if(firstreqdeptflag=="Y"){
		      var firstreqdeptlabel="���벿��";
			  document.getElementById(firstreqdept).parentNode.parentNode.parentNode.parentNode.previousSibling.innerHTML ="<font color=red>���벿��</font>:"; 
			  }
			var scategoryflag=elemflagarr[66];//�������
			if(scategoryflag=="Y"){
		      var scategorylabel="�������";
		      Ext.DomQuery.selectNode("label[for="+scategory+"]").innerHTML = '<font color=red>�������</font>:';
			  }
			var matqualityflag=elemflagarr[67];//�ʵ�
			if(matqualityflag=="Y"){
		      var matqualitylabel="�ʵ�";
			  Ext.DomQuery.selectNode("label[for="+matquality+"]").innerHTML = '<font color=red>�ʵ�</font>:';
			  }
			var hospzerostkflag=elemflagarr[68];//Ժ������
			if(hospzerostkflag=="Y"){
		      var hospzerostklabel="Ժ������";
			  }
			}
			/////*****ҽ����label
			var arcimcodeflag=elemflagarr[69];//ҽ������
			if(arcimcodeflag=="Y"){
		      var arcimcodelabel="ҽ������";
		      Ext.DomQuery.selectNode("label[for="+arcimcode+"]").innerHTML = '<font color=red>ҽ������</font>:';
			  }
			var arcimdescflag=elemflagarr[70];//ҽ������
			if(arcimdescflag=="Y"){
		      var arcimdesclabel="ҽ������";
		      Ext.DomQuery.selectNode("label[for="+arcimdesc+"]").innerHTML = '<font color=red>ҽ������</font>:';
			  }
			var arcimuomdrflag=elemflagarr[71];//�Ƽ۵�λ
			if(arcimuomdrflag=="Y"){
		      var arcimuomdrlabel="�Ƽ۵�λ";
		      Ext.DomQuery.selectNode("label[for="+arcimuomdr+"]").innerHTML = '<font color=red>�Ƽ۵�λ</font>:';
			  }
			var ordercategoryflag=elemflagarr[72];//ҽ������
			if(ordercategoryflag=="Y"){
		      var ordercategorylabel="ҽ������";
		      Ext.DomQuery.selectNode("label[for="+ordercategory+"]").innerHTML = '<font color=red>ҽ������</font>:';
			  }
			var arcitemcatflag=elemflagarr[73];//ҽ������
			if(arcitemcatflag=="Y"){
		      var arcitemcatlabel="ҽ������";
		      Ext.DomQuery.selectNode("label[for="+arcitemcat+"]").innerHTML = '<font color=red>ҽ������</font>:';
			  }
			var arcbillgrpflag=elemflagarr[74];//���ô���
			if(arcbillgrpflag=="Y"){
		      var arcbillgrplabel="���ô���";
		      Ext.DomQuery.selectNode("label[for="+arcbillgrp+"]").innerHTML = '<font color=red>���ô���</font>:';
			  }
			var arcbillsubflag=elemflagarr[75];//��������
			if(arcbillsubflag=="Y"){
		      var arcbillsublabel="��������";
		      Ext.DomQuery.selectNode("label[for="+arcbillsub+"]").innerHTML = '<font color=red>��������</font>:';
			  }
			var arcimorderonitsownflag=elemflagarr[76];//����ҽ��
			var oecpriorityflag=elemflagarr[77];//ҽ�����ȼ�
			if(oecpriorityflag=="Y"){
		      var oecprioritylabel="ҽ�����ȼ�";
		      Ext.DomQuery.selectNode("label[for="+oecpriority+"]").innerHTML = '<font color=red>ҽ�����ȼ�</font>:';
			  }
			var wostockflagflag=elemflagarr[78];//�޿��ҽ��
			var arcimtext1flag=elemflagarr[79];//ҽ������
			if(arcimtext1flag=="Y"){
		      var arcimtext1label="ҽ������";
		      Ext.DomQuery.selectNode("label[for="+arcimtext1+"]").innerHTML = '<font color=red>ҽ������</font>:';
			  }
			var arcaliasflag=elemflagarr[80];//����
			var arcimabbrevflag=elemflagarr[81];//��д
			var phcdofficialtypeflag=elemflagarr[82];//ҽ�����
			if(phcdofficialtypeflag=="Y"){
		      var phcdofficialtypelabel="ҽ�����";
		      Ext.DomQuery.selectNode("label[for="+phcdofficialtype+"]").innerHTML = '<font color=red>ҽ�����</font>:';
			  }
			var arcimnoofcumdaysflag=elemflagarr[83];//����ʹ������
			if(arcimnoofcumdaysflag=="Y"){
		      var arcimnoofcumdayslabel="����ʹ������";
		      Ext.DomQuery.selectNode("label[for="+arcimnoofcumdays+"]").innerHTML = '<font color=red>����ʹ������</font>:';
			  }
			var arcimoemessageflag=elemflagarr[84];//ҽ����ʾ
			if(arcimoemessageflag=="Y"){
		      var arcimoemessagelabel="ҽ����ʾ";
		      Ext.DomQuery.selectNode("label[for="+arcimoemessage+"]").innerHTML = '<font color=red>ҽ����ʾ</font>:';
			  }
			var billnotactiveflag=elemflagarr[85];//��ά���շ���
			var billcodeflag=elemflagarr[86];//�շ������
			if(billcodeflag=="Y"){
		      var billcodelabel="�շ������";
		      Ext.DomQuery.selectNode("label[for="+billcode+"]").innerHTML = '<font color=red>�շ������</font>:';
			  }
			var billnameflag=elemflagarr[87];//�շ�������
			if(billnameflag=="Y"){
		      var billnamelabel="�շ�������";
		      Ext.DomQuery.selectNode("label[for="+billname+"]").innerHTML = '<font color=red>�շ�������</font>:';
			  //document.getElementById(billname).parentNode.previousSibling.innerHTML ="<font color=red>�շ�������</font>:"; 
			  }
			var subtypefeeflag=elemflagarr[88];//�ӷ���
			if((subtypefeeflag=="Y")&&(Ext.getCmp(billnotactive).getValue()==false)){
			  document.getElementById(subtypefee).parentNode.parentNode.previousSibling.innerHTML ="<font color=red>�ӷ���</font>:"; 
			  }
			var insubtypefeeflag=elemflagarr[89];//סԺ�ӷ���
			if((insubtypefeeflag=="Y")&&(Ext.getCmp(billnotactive).getValue()==false)){
               document.getElementById(insubtypefee).parentNode.parentNode.previousSibling.innerHTML ="<font color=red>סԺ�ӷ���</font>:";
             }
			var outsubtypefeeflag=elemflagarr[90];//�����ӷ���
			if((outsubtypefeeflag=="Y")&&(Ext.getCmp(billnotactive).getValue()==false)){
			   document.getElementById(outsubtypefee).parentNode.parentNode.previousSibling.innerHTML ="<font color=red>�����ӷ���</font>:";
			  }
			var accsubtypefeeflag=elemflagarr[91];//�����ӷ���
			if((accsubtypefeeflag=="Y")&&(Ext.getCmp(billnotactive).getValue()==false)){
			    document.getElementById(accsubtypefee).parentNode.parentNode.previousSibling.innerHTML ="<font color=red>�����ӷ���</font>:";
			  }
			var medsubtypefeeflag=elemflagarr[92];//������ҳ�ӷ���
			if((medsubtypefeeflag=="Y")&&(Ext.getCmp(billnotactive).getValue()==false)){
		      document.getElementById(medsubtypefee).parentNode.parentNode.previousSibling.innerHTML ="<font color=red>������ҳ����</font>:";
			  }
			var newmedsubtypefeeflag=elemflagarr[93];//�²�����ҳ�ӷ���
			if((newmedsubtypefeeflag=="Y")&&(Ext.getCmp(billnotactive).getValue()==false)){
		      document.getElementById(newmedsubtypefee).parentNode.parentNode.previousSibling.innerHTML ="<font color=red>�²�����ҳ����</font>:"
			  }
			var accountsubtypefeeflag=elemflagarr[94];//����ӷ���
			if((accountsubtypefeeflag=="Y")&&(Ext.getCmp(billnotactive).getValue()==false)){
		      document.getElementById(accountsubtypefee).parentNode.parentNode.previousSibling.innerHTML ="<font color=red>����ӷ���</font>:";
			  }
			var medpromaintainflag=elemflagarr[95];//ά��ҽ����
			if(medpromaintainflag=="Y"){
		      var medpromaintainlabel="ά��ҽ����";
		      Ext.DomQuery.selectNode("label[for="+medpromaintain+"]").innerHTML = '<font color=red>ά��ҽ����</font>:';
			  }
			var arcimeffdateflag=elemflagarr[96];//��Ч����
			var arcimeffdatetoflag=elemflagarr[97];//��ֹ����
			var arcsppuruomflag=elemflagarr[98];//�ۼ�(ҽ��)
			if(arcsppuruomflag=="Y"){
		      var arcsppuruomlabel="�ۼ�(ҽ��)";
		      Ext.DomQuery.selectNode("label[for="+arcsppuruom+"]").innerHTML = '<font color=red>�ۼ�(ҽ��)</font>:';
			  }
			var arcpreexedateflag=elemflagarr[99];//�۸���Ч����(ҽ��)
			 var arciminfomtflag=elemflagarr[100];//��������(ҽ��)
			if(arciminfomtflag=="Y"){
		      var arciminfomtlabel="��������(ҽ��)";
		      Ext.DomQuery.selectNode("label[for="+arciminfomt+"]").innerHTML = '<font color=red>��������(ҽ��)</font>:';
			  }
			var arcimrppuruomflag=elemflagarr[101];//����(ҽ��)
		  }
	  }
}