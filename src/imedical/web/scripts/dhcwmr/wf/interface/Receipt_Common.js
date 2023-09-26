
function IGroupReceipt(EpisodeID,MrNo,LogonLocID,LogonUserID)
{
	var result='',reterr='';
	if (!EpisodeID){
		reterr = '-1^就诊号为空';
		return reterr;
	}
	
	var ReceiptType = tkMakeServerCall("DHCWMR.SSService.ReceiptSrv","GetReceiptType",EpisodeID);
	if ((ReceiptType == 'A')||((ReceiptType == 'HN')&&(MrNo != ''))){  //自动接诊,或手工接诊但是存在已分配的病案号
		//按就诊号取号码类型
		var NoTypeID = tkMakeServerCall('DHCWMR.SSService.ReceiptSrv','GetNoTypeByAdm',EpisodeID);
		if (NoTypeID == ''){
			reterr = '-2^病案号号码类型错误';
			return reterr;
		}
		var MrTypeID = NoTypeID.split('||')[0];
		//检查病案号格式
		if (MrNo != ''){
			var result = tkMakeServerCall("DHCWMR.SSService.ReceiptSrv","CheckMrNoInput",NoTypeID,MrNo);
			var err = result.split('^')[0];
			if ((err*1)<1){
				reterr = '-3^病案号格式错误,Error=' + err;
				return reterr;
			}
			MrNo = result.split('^')[1];
		}
		
		//病案接诊
		var result = tkMakeServerCall('DHCWMR.SSService.ReceiptSrv','GroupReceipt',EpisodeID,MrNo,LogonLocID,LogonUserID,NoTypeID);
		var err = result.split('^')[0];
		if ((err*1)<1){
			reterr = '-4^接诊失败,Error=' + err;
			return reterr;
		} else {
			var VolumeID = result.split('^')[2];
			var MrNo = result.split('^')[3];
			result = '1^接诊成功^' + VolumeID + '^' + MrNo;
			return result;
		}
	} else {
		//手工接诊
		var url = "./dhcwmr.wf.receiptpage.csp?EpisodeID=" + EpisodeID + "&ReceiptType=" + ReceiptType + "&2=2";
		var result = window.showModalDialog(url, window, "dialogWidth:240px;dialogHeight:160px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");
		if (typeof(result) == 'undefined'){
			result = window.ReturnValue;
			return 0;		//add by liyi 2016-04-19 修复关闭手工接诊IE窗口弹出错误提示
		}
		if (result=='') return 0;	//add by liyi 2016-04-19 修复关闭手工接诊IE窗口弹出错误提示
		if (result){
			var VolumeID = result.split('^')[2];
			var MrNo = result.split('^')[3];
			result = '1^接诊成功^' + VolumeID + '^' + MrNo;
			return result;
		}
	}
	reterr = '-999^接诊失败';
	return reterr;
}

function IGroupUnReceipt(EpisodeID,LogonLocID,LogonUserID)
{
	var result='',reterr='';
	if (!EpisodeID){
		reterr = '-1^就诊号为空';
		return reterr;
	}
	
	//取消接诊
	var result = tkMakeServerCall('DHCWMR.SSService.ReceiptSrv','GroupUnReceipt',EpisodeID,LogonLocID,LogonUserID);
	var err = result.split('^')[0];
	if ((err*1)<1){
		reterr = '-2^取消接诊失败,Error=' + err;
		return reterr;
	} else {
		result = '1^取消接诊成功^';
		return result;
	}
	
	reterr = '-999^取消接诊失败';
	return reterr;
}

function IGetMrNoByEpisodeID(EpisodeID)
{
	var result='',reterr='';
	if (!EpisodeID){
		reterr = '-1^就诊号为空';
		return reterr;
	}
	var result = tkMakeServerCall('DHCWMR.SSService.MrNoSrv','GetMrNoByEpisodeIDX',EpisodeID);
	return result;
}



//**********************************************************************************
//以下内容为按病人建档分号程序 add by zf 20150513
//**********************************************************************************
function IGroupReceiptByPat(PatientID,MrClass,MrNo,LogonLocID,LogonUserID,FirstInfo,FeeInfo,PatInfo)
{
	var result='',reterr='';
	if (!PatientID){
		reterr = '-1^病人ID为空';
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
	if ((ReceiptType == 'A')||((ReceiptType == 'HN')&&(MrNo != ''))){  //自动接诊,或手工接诊但是存在已分配的病案号
		//按就诊号取号码类型
		var NoTypeID = tkMakeServerCall('DHCWMR.SSService.ReceiptSrv','GetNoTypeByLoc',MrClass,FirstLocID,FirstHospID);
		if (NoTypeID == ''){
			reterr = '-2^病案号号码类型错误';
			return reterr;
		}
		var MrTypeID = NoTypeID.split('||')[0];
		//检查病案号格式
		if (MrNo != ''){
			var result = tkMakeServerCall("DHCWMR.SSService.ReceiptSrv","CheckMrNoInput",NoTypeID,MrNo);
			var err = result.split('^')[0];
			if ((err*1)<1){
				reterr = '-3^病案号格式错误,Error=' + err;
				return reterr;
			}
			MrNo = result.split('^')[1];
		}
		
		//病案接诊
		var result = tkMakeServerCall('DHCWMR.SSService.ReceiptSrv','GroupReceiptByPat',PatientID,MrNo,LogonLocID,LogonUserID,NoTypeID,FirstInfo,FeeInfo,PatInfo);
		var err = result.split('^')[0];
		if ((err*1)<1){
			reterr = '-4^病案建档失败,Error=' + err;
			return reterr;
		} else {
			var VolumeID = result.split('^')[2];
			var MrNo = result.split('^')[3];
			result = '1^病案建档成功^' + VolumeID + '^' + MrNo;
			return result;
		}
	} else {
		//手工接诊 
		var url = "./dhcwmr.wf.receiptbypatpage.csp?PatientID=" + PatientID + "&ReceiptType=" + ReceiptType +"&AdmLoc=" + FirstLocID +"&AdmType=" + MrClass +"&FirstInfo=" + FirstInfo +"&FeeInfo=" + FeeInfo +"&PatInfo=" + PatInfo + "&2=2";
		var result = window.showModalDialog(url, window, "dialogWidth:240px;dialogHeight:160px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");
		
		if (typeof(result) == 'undefined'){
			result = window.ReturnValue;
			return 0;		//add by liyi 2016-04-19 修复关闭手工接诊IE窗口弹出错误提示
		}
		if (result=='') return 0; //add by liyi 2016-04-19 修复关闭手工接诊IE窗口弹出错误提示
		if (result){
			var VolumeID = result.split('^')[2];
			var MrNo = result.split('^')[3];
			result = '1^病案建档成功^' + VolumeID + '^' + MrNo;
			return result;
		}
	}
	
	reterr = '-999^病案建档失败';
	return reterr;
}

function IGroupUnReceiptByPat(PatientID,MrClass,LogonLocID,LogonUserID)
{
	var result='',reterr='';
	if (!PatientID){
		reterr = '-1^病人ID为空';
		return reterr;
	}
	
	//按就诊号取号码类型
	var NoTypeID = tkMakeServerCall('DHCWMR.SSService.ReceiptSrv','GetNoTypeByLoc',MrClass,LogonLocID);
	if (NoTypeID == ''){
		reterr = '-2^病案号号码类型错误';
		return reterr;
	}
	var MrTypeID = NoTypeID.split('||')[0];
	
	//取消接诊
	var result = tkMakeServerCall('DHCWMR.SSService.ReceiptSrv','GroupUnReceiptByPat',PatientID,MrTypeID,LogonLocID,LogonUserID);
	var err = result.split('^')[0];
	if ((err*1)<1){
		reterr = '-2^取消病案建档失败,Error=' + err;
		return reterr;
	} else {
		result = '1^取消病案建档成功^';
		return result;
	}
	
	reterr = '-999^取消病案建档失败';
	return reterr;
}

function IGetMrNoByPatientID(PatientID)
{
	var result='',reterr='';
	if (!PatientID){
		reterr = '-1^病人ID为空';
		return reterr;
	}
	var result = tkMakeServerCall('DHCWMR.SSService.MrNoSrv','GetMrNoByPatientID',PatientID);
	return result;
}
