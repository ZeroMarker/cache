
function IGroupReceipt(EpisodeID,MrNo,LogonLocID,LogonUserID)
{
	var result='',reterr='';
	if (!EpisodeID){
		reterr = '-1^�����Ϊ��';
		return reterr;
	}
	
	var ReceiptType = tkMakeServerCall("DHCWMR.SSService.ReceiptSrv","GetReceiptType",EpisodeID);
	if ((ReceiptType == 'A')||((ReceiptType == 'HN')&&(MrNo != ''))){  //�Զ�����,���ֹ����ﵫ�Ǵ����ѷ���Ĳ�����
		//�������ȡ��������
		var NoTypeID = tkMakeServerCall('DHCWMR.SSService.ReceiptSrv','GetNoTypeByAdm',EpisodeID);
		if (NoTypeID == ''){
			reterr = '-2^�����ź������ʹ���';
			return reterr;
		}
		var MrTypeID = NoTypeID.split('||')[0];
		//��鲡���Ÿ�ʽ
		if (MrNo != ''){
			var result = tkMakeServerCall("DHCWMR.SSService.ReceiptSrv","CheckMrNoInput",NoTypeID,MrNo);
			var err = result.split('^')[0];
			if ((err*1)<1){
				reterr = '-3^�����Ÿ�ʽ����,Error=' + err;
				return reterr;
			}
			MrNo = result.split('^')[1];
		}
		
		//��������
		var result = tkMakeServerCall('DHCWMR.SSService.ReceiptSrv','GroupReceipt',EpisodeID,MrNo,LogonLocID,LogonUserID,NoTypeID);
		var err = result.split('^')[0];
		if ((err*1)<1){
			reterr = '-4^����ʧ��,Error=' + err;
			return reterr;
		} else {
			var VolumeID = result.split('^')[2];
			var MrNo = result.split('^')[3];
			result = '1^����ɹ�^' + VolumeID + '^' + MrNo;
			return result;
		}
	} else {
		//�ֹ�����
		var url = "./dhcwmr.wf.receiptpage.csp?EpisodeID=" + EpisodeID + "&ReceiptType=" + ReceiptType + "&2=2";
		var result = window.showModalDialog(url, window, "dialogWidth:240px;dialogHeight:160px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");
		if (typeof(result) == 'undefined'){
			result = window.ReturnValue;
			return 0;		//add by liyi 2016-04-19 �޸��ر��ֹ�����IE���ڵ���������ʾ
		}
		if (result=='') return 0;	//add by liyi 2016-04-19 �޸��ر��ֹ�����IE���ڵ���������ʾ
		if (result){
			var VolumeID = result.split('^')[2];
			var MrNo = result.split('^')[3];
			result = '1^����ɹ�^' + VolumeID + '^' + MrNo;
			return result;
		}
	}
	reterr = '-999^����ʧ��';
	return reterr;
}

function IGroupUnReceipt(EpisodeID,LogonLocID,LogonUserID)
{
	var result='',reterr='';
	if (!EpisodeID){
		reterr = '-1^�����Ϊ��';
		return reterr;
	}
	
	//ȡ������
	var result = tkMakeServerCall('DHCWMR.SSService.ReceiptSrv','GroupUnReceipt',EpisodeID,LogonLocID,LogonUserID);
	var err = result.split('^')[0];
	if ((err*1)<1){
		reterr = '-2^ȡ������ʧ��,Error=' + err;
		return reterr;
	} else {
		result = '1^ȡ������ɹ�^';
		return result;
	}
	
	reterr = '-999^ȡ������ʧ��';
	return reterr;
}

function IGetMrNoByEpisodeID(EpisodeID)
{
	var result='',reterr='';
	if (!EpisodeID){
		reterr = '-1^�����Ϊ��';
		return reterr;
	}
	var result = tkMakeServerCall('DHCWMR.SSService.MrNoSrv','GetMrNoByEpisodeIDX',EpisodeID);
	return result;
}



//**********************************************************************************
//��������Ϊ�����˽����ֺų��� add by zf 20150513
//**********************************************************************************
function IGroupReceiptByPat(PatientID,MrClass,MrNo,LogonLocID,LogonUserID,FirstInfo,FeeInfo,PatInfo)
{
	var result='',reterr='';
	if (!PatientID){
		reterr = '-1^����IDΪ��';
		return reterr;
	}
	
	if (!FirstInfo) FirstInfo = '';
	if (!FeeInfo) FeeInfo = '';
	
	var arrFirstInfo = FirstInfo.split('^');
	if (arrFirstInfo.length>=4){
		var FirstHospID = arrFirstInfo[0];
		var FirstLocID = arrFirstInfo[1];
	} else {
		var FirstHospID = '';
		var FirstLocID = LogonLocID;
	}
	
	var ReceiptType = tkMakeServerCall("DHCWMR.SSService.ReceiptSrv","GetReceiptTypeByLoc",MrClass,FirstLocID,FirstHospID);
	if ((ReceiptType == 'A')||((ReceiptType == 'HN')&&(MrNo != ''))){  //�Զ�����,���ֹ����ﵫ�Ǵ����ѷ���Ĳ�����
		//�������ȡ��������
		var NoTypeID = tkMakeServerCall('DHCWMR.SSService.ReceiptSrv','GetNoTypeByLoc',MrClass,FirstLocID,FirstHospID);
		if (NoTypeID == ''){
			reterr = '-2^�����ź������ʹ���';
			return reterr;
		}
		var MrTypeID = NoTypeID.split('||')[0];
		//��鲡���Ÿ�ʽ
		if (MrNo != ''){
			var result = tkMakeServerCall("DHCWMR.SSService.ReceiptSrv","CheckMrNoInput",NoTypeID,MrNo);
			var err = result.split('^')[0];
			if ((err*1)<1){
				reterr = '-3^�����Ÿ�ʽ����,Error=' + err;
				return reterr;
			}
			MrNo = result.split('^')[1];
		}
		
		//��������
		var result = tkMakeServerCall('DHCWMR.SSService.ReceiptSrv','GroupReceiptByPat',PatientID,MrNo,LogonLocID,LogonUserID,NoTypeID,FirstInfo,FeeInfo,PatInfo);
		var err = result.split('^')[0];
		if ((err*1)<1){
			reterr = '-4^��������ʧ��,Error=' + err;
			return reterr;
		} else {
			var VolumeID = result.split('^')[2];
			var MrNo = result.split('^')[3];
			result = '1^���������ɹ�^' + VolumeID + '^' + MrNo;
			return result;
		}
	} else {
		//�ֹ����� 
		var url = "./dhcwmr.wf.receiptbypatpage.csp?PatientID=" + PatientID + "&ReceiptType=" + ReceiptType +"&AdmLoc=" + FirstLocID +"&AdmType=" + MrClass +"&FirstInfo=" + FirstInfo +"&FeeInfo=" + FeeInfo +"&PatInfo=" + PatInfo + "&2=2";
		var result = window.showModalDialog(url, window, "dialogWidth:240px;dialogHeight:160px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");
		
		if (typeof(result) == 'undefined'){
			result = window.ReturnValue;
			return 0;		//add by liyi 2016-04-19 �޸��ر��ֹ�����IE���ڵ���������ʾ
		}
		if (result=='') return 0; //add by liyi 2016-04-19 �޸��ر��ֹ�����IE���ڵ���������ʾ
		if (result){
			var VolumeID = result.split('^')[2];
			var MrNo = result.split('^')[3];
			result = '1^���������ɹ�^' + VolumeID + '^' + MrNo;
			return result;
		}
	}
	
	reterr = '-999^��������ʧ��';
	return reterr;
}

function IGroupUnReceiptByPat(PatientID,MrClass,LogonLocID,LogonUserID)
{
	var result='',reterr='';
	if (!PatientID){
		reterr = '-1^����IDΪ��';
		return reterr;
	}
	
	//�������ȡ��������
	var NoTypeID = tkMakeServerCall('DHCWMR.SSService.ReceiptSrv','GetNoTypeByLoc',MrClass,LogonLocID);
	if (NoTypeID == ''){
		reterr = '-2^�����ź������ʹ���';
		return reterr;
	}
	var MrTypeID = NoTypeID.split('||')[0];
	
	//ȡ������
	var result = tkMakeServerCall('DHCWMR.SSService.ReceiptSrv','GroupUnReceiptByPat',PatientID,MrTypeID,LogonLocID,LogonUserID);
	var err = result.split('^')[0];
	if ((err*1)<1){
		reterr = '-2^ȡ����������ʧ��,Error=' + err;
		return reterr;
	} else {
		result = '1^ȡ�����������ɹ�^';
		return result;
	}
	
	reterr = '-999^ȡ����������ʧ��';
	return reterr;
}

function IGetMrNoByPatientID(PatientID)
{
	var result='',reterr='';
	if (!PatientID){
		reterr = '-1^����IDΪ��';
		return reterr;
	}
	var result = tkMakeServerCall('DHCWMR.SSService.MrNoSrv','GetMrNoByPatientID',PatientID);
	return result;
}
