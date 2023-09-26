function InitReceipt()
{
	var obj=document.getElementById("btnReceipt");
	if (obj){obj.onclick=btnReceipt_onclick;}
	var obj=document.getElementById("btnUnReceipt");
	if (obj){obj.onclick=btnUnReceipt_onclick;}
}

function btnReceipt_onclick()
{
	var EpisodeID = admidobj.value;
	var MrNo=document.getElementById("Medicare").value;
	if(MrNo == 0) MrNo='';
	var ret = IGroupReceipt(EpisodeID,MrNo,session['LOGON.CTLOCID'],session['LOGON.USERID']);
	var err = ret.split('^')[0];
	if ((err*1)<0){
		if ((err*1)==-999){
			return;    //直接关闭接诊窗口时不弹出提示
		}
		alert('提示：' + ret);
		return;
	}else{
		var MrNo = ret.split('^')[3];
		document.getElementById("Medicare").value = MrNo;
	}
}

function btnUnReceipt_onclick()
{
	var EpisodeID = admidobj.value;
	var ret = IGroupUnReceipt(EpisodeID,session['LOGON.CTLOCID'],session['LOGON.USERID']);
	var err = ret.split('^')[0];
	if ((err*1)<0){
		alert('提示：' + ret);
		return;
	}else{
		var MrNo = IGetMrNoByEpisodeID(EpisodeID);
		document.getElementById("Medicare").value = MrNo;
	}
}

//预住院转住院接诊调用
function btnPreIPReceipt_onclick()
{
	var EpisodeID = admidobj.value;
	var ret = IGroupReceipt(EpisodeID,'',session['LOGON.CTLOCID'],session['LOGON.USERID']);
	var err = ret.split('^')[0];
	if ((err*1)<0){
		if ((err*1)==-999){
			return;    //直接关闭接诊窗口时不弹出提示
		}
		alert('提示：' + ret);
		return;
	}else{
	}
}