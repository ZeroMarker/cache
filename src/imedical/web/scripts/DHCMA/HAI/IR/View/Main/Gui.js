//页面Gui
function InitPatViewWin(){
	
	if(window.dialogArguments=="closeBtnInvisible"){           //住院医生站里的摘要信息去掉layer的关闭按钮
		$("div.close").css("display","none");
	}
	if (PageType == 'WinOpen') {
		$("div.close").css("display","none");
        $('#modal-body').removeAttr("style");        //移除样式
	}
	//初始tab页签
	var tab = $('#divTabs').tabs('getSelected');
	var indexNow = $('#divTabs').tabs('getTabIndex',tab);
	
	if (indexNow==0) {
		var LinkUrl = "dhcma.ir.view.summary.csp?EpisodeID="+EpisodeID+"&PaadmID="+PaadmID+"&1=2";
		$("#Tab0").attr("src", LinkUrl);
	}
	
	/*
	var ICUType = $m({
		ClassName: "DHCHAI.BTS.LocationSrv",
		MethodName: "GetLocICUType",
		aHospIDs:$.LOGON.HOSPID,
        aLocID:$.LOGON.LOCID,
	}, false);
    */
	if (obj.PatViewInfo=='') {
		$.messager.alert("错误提示",$g('病人信息获取失败！'), 'info');  //layer.msg('病人信息获取失败！');
	}
	var PatViewInfoArray = obj.PatViewInfo.split('^');
	var Sex,PatName,PapmiNo,MrNo,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DiagDesc='';	
	//var EpisodeID,PatientID='';	//放 csp 里
	if (obj.PatViewInfo!=''){
		Sex 		= PatViewInfoArray[5];
		PatName 	= PatViewInfoArray[4];
		PapmiNo 	= PatViewInfoArray[2];
		MrNo 		= PatViewInfoArray[3];
		Age 		= PatViewInfoArray[8];
		AdmLocDesc 	= PatViewInfoArray[21];
		AdmWardDesc = PatViewInfoArray[22];
		AdmBed 		= PatViewInfoArray[24];
		AdmDate 	= PatViewInfoArray[19];
		AdmTime 	= PatViewInfoArray[20];
		DiagDesc 	= PatViewInfoArray[32];
		//csp 里赋值
		//EpisodeID   = PatViewInfoArray[0].split('||')[1];
		//PatientID   = PatViewInfoArray[1];
	}
	if(Sex=="Male"||Sex=="男")
	{
		var imgHtml = '<img style="max-width: 100%;vertical-align: middle;witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-boy.png"></img>'
	}
	else if(Sex=="Female"||Sex=="女"){
		var imgHtml = '<img style="max-width: 100%;vertical-align: middle;witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-girl.png"></img>';
	}
	else{
		var imgHtml = '<img style="max-width: 100%;vertical-align: middle;witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-boy.png"></img>'
		}
	var html =''
	html += '<li style="margin-left: 6px;display: inline-block;list-style: none;overflow: hidden;">'+imgHtml+'</li>';
	html += '<li style="margin-left: 12px;font-size:15px;display: inline-block;list-style: none;overflow: hidden;"><strong>'+PatName+'</strong></li>';
	html += '<li style="margin-left: 24px;display: inline-block;list-style: none;max-width:25%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><a href="#" style="color: #353535;" title='+DiagDesc+'>'+$g('诊断')+'：'+DiagDesc+'</a></li>';
	html += '<li style="margin-left: 24px;display: inline-block;list-style: none;overflow: hidden;">'+$g('登记号')+'：'+PapmiNo+ ' | '+$g('病案号')+'：'+MrNo+' | '+Sex+' | ' + Age + ' | ' + AdmLocDesc + '/' + AdmWardDesc + '（' + AdmBed + '）| ' + AdmDate + ' ' +  AdmTime+'</li>';
	$(".title ul>li").remove();
	$(".title ul").append(html);
	
	InitPatViewWinEvent(obj);	
	obj.LoadEvent(arguments);
	
	return obj;
}


