// 接诊
function IGroupReceipt(EpisodeID,MrNo,LogonLocID,LogonUserID){
	var result='',reterr='';
	if (!EpisodeID){
		reterr = '-1^就诊号为空';
		return reterr;
	}
	
	var ReceiptType = $m({
		ClassName:"MA.IPMR.SSService.ReceiptSrv",
		MethodName:"GetReceiptType",
		aEpisodeID:EpisodeID
	},false);
	if ((ReceiptType == 'A')||((ReceiptType == 'HN')&&(MrNo != ''))){  //自动接诊,或手工接诊但是存在已分配的病案号
		//按就诊号取号码类型
		var NoTypeID = $m({
			ClassName:"MA.IPMR.SSService.ReceiptSrv",
			MethodName:"GetNoTypeByAdm",
			aEpisodeID:EpisodeID
		},false);
		if (NoTypeID == ''){
			reterr = '-2^病案号号码类型错误';
			return reterr;
		}
		var MrTypeID = NoTypeID.split('||')[0];
		//检查病案号格式
		if (MrNo != ''){
			var result = $m({
				ClassName:"MA.IPMR.SSService.ReceiptSrv",
				MethodName:"CheckMrNoInput",
				aNoTypeID:NoTypeID,
				aMrNo:MrNo
			},false);
			var err = result.split('^')[0];
			if ((err*1)<1){
				reterr = '-3^病案号格式错误,Error=' + err;
				return reterr;
			}
			MrNo = result.split('^')[1];
		}
		
		//病案接诊
		var result = $m({
			ClassName:"MA.IPMR.SSService.ReceiptSrv",
			MethodName:"GroupReceipt",
			aEpisodeID:EpisodeID,
			aMrNo:MrNo,
			aLocID:LogonLocID,
			aUserID:LogonUserID,
			aNoTypeID:NoTypeID
		},false);
		var err = result.split('^')[0];
		if ((err*1)<1){
			reterr = '-4^接诊失败,Error=' + result.split('^')[1];
			return reterr;
		} else {
			var VolumeID = result.split('^')[2];
			var MrNo = result.split('^')[3];
			result = '1^接诊成功^' + VolumeID + '^' + MrNo;
			return result;
		}
	} else {
		//手工接诊
	}
}

// 取消接诊
function IGroupUnReceipt(EpisodeID,LogonLocID,LogonUserID)
{
	var result='',reterr='';
	if (!EpisodeID){
		reterr = '-1^就诊号为空';
		return reterr;
	}
	
	//取消接诊
	var result = $m({
		ClassName:"MA.IPMR.SSService.ReceiptSrv",
		MethodName:"GroupUnReceipt",
		aEpisodeID:EpisodeID,
		aLocID:LogonLocID,
		aUserID:LogonUserID
	},false);
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
	var result = $m({
		ClassName:"MA.IPMR.SSService.MrNoSrv",
		MethodName:"GetMrNoByEpisodeIDX",
		aEpisodeID:EpisodeID
	},false);
	return result;
}