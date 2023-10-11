///页面Gui
function InitPatViewWin(){
	if(window.dialogArguments=="closeBtnInvisible"){           //住院医生站里的摘要信息去掉layer的关闭按钮
		$("div.close").css("display","none");
	}
	if (PageType == 'WinOpen') {
		$("div.close").css("display","none");
        $('#modal-body').removeAttr("style");        //移除样式
	}
	var obj = new Object();
	obj.PatViewInfo = $.Tool.RunServerMethod('DHCHAI.IRS.CCInfViewSrv','GetPatViewInfo',PaadmID)
	if (obj.PatViewInfo=='') {
		layer.msg('病人信息获取失败！');
	}
	var PatViewInfoArray = obj.PatViewInfo.split('^');
	var Sex,PatName,PapmiNo,MrNo,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DiagDesc='';	
	var EpisodeID,PatientID='';	
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
		EpisodeID   = PatViewInfoArray[0].split('||')[1];
		PatientID   = PatViewInfoArray[1];
	}
	switch (Sex){
		case 'F':
			var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-girl.png"></img>';
			Sex = '女';
			break;
		case 'M':
			var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-boy.png"></img>'
			Sex = '男';
			break;
		default:
			var imgHtml = '<img style="witdht:25px;height:25px;border-radius:50%" src="../scripts/dhchai/img/icon-boy.png"></img>'
			Sex = '';
			break;
	}
	var html =''
	html += '<li style="margin-left: 6px;display: inline-block;list-style: none;overflow: hidden;">'+imgHtml+'</li>';
	html += '<li style="margin-left: 12px;font-size:15px;display: inline-block;list-style: none;overflow: hidden;"><strong>'+PatName+'</strong></li>';
	html += '<li style="margin-left: 24px;display: inline-block;list-style: none;max-width:25%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><a href="#" style="color: #353535;" title='+DiagDesc+'>诊断：'+DiagDesc+'</a></li>';
	html += '<li style="margin-left: 24px;display: inline-block;list-style: none;overflow: hidden;">登记号：'+PapmiNo+ ' | 病案号：'+MrNo+' | '+Sex+' | ' + Age + ' | ' + AdmLocDesc + '/' + AdmWardDesc + '（' + AdmBed + '）| ' + AdmDate + ' ' +  AdmTime+'</li>';
	$(".title ul>li").remove();
	$(".title ul").append(html);
	//获得病历浏览csp配置
	var cspUrl = $.Tool.RunServerMethod("DHCHAI.BT.Config","GetValByCode","SYSEmrCSP","");

    // 获取体温单csp界面
    var TemperatureCSP = $.Tool.RunServerMethod("DHCHAI.BT.Config","GetValByCode","SYSTemperatureCSP","");
    if (TemperatureCSP==""){
        TemperatureCSP="dhchai.ir.view.temperature.csp";
    }
    
    // 初始化展现的tab
    obj.tabJosn = {
        'data':[
            {
                'id':'Summary',
                'url':'../csp/dhchai.ir.view.summary.csp',
                'title':'摘要'
            },{
                'id':'ScreenResult',
                //'url':'../csp/dhchai.ir.view.screenresult.csp',
                //'title':'触发条件'
                'url':'../csp/dhcma.hai.ir.patscreening.csp?EpisodeDr='+ PaadmID +'&Paadm='+ EpisodeID+'&LocFlag='+LocFlag+'&2=2',
                'title':'疑似筛查'
            },{
                'id':'LisRepoprt',
                'url':'../csp/dhcma.hai.ir.view.lisreport.csp',
                'title':'检验报告'
            },{
                'id':'OEANTList',
                'url':'../csp/dhchai.ir.view.oeantlist.csp',
                'title':'抗菌用药'
            },{
                'id':'OEDRTList',
                'url':'../csp/dhchai.ir.view.oedrtlist.csp',
                'title':'器械相关治疗'
            },{
                'id':'OEOperat',
                'url':'../csp/dhchai.ir.view.oeoperat.csp',
                'title':'手术'
            },{
                'id':'Temperature',
                'url':'../csp/'+TemperatureCSP+"?EpisodeID="+EpisodeID+"&PaadmID=" + PaadmID+"&1=1", //
                'title':'体温单'
            },{
                'id':'EmrCourse',
                'url':'../csp/dhcma.hai.ir.view.emrinfoh.csp',  //dhchai.ir.view.emrinfoh.csp
                'title':'病程'
            },{
                'id':'RisReport',
                'url':'../csp/dhchai.ir.view.risreport.csp',
                'title':'影像报告'
            },{
            //  'id':'RMEWords',
            //  'url':'../csp/dhchai.ir.view.rmewords.csp',
            //  'title':'语义词标注'
            //},{
                'id':'AdmHistory',
                'url':'../csp/dhcma.hai.ir.view.admhistory.csp',
                'title':'就诊信息'
            },{
                'id':'EmrView',
                'url':cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2',
                //'url':'../csp/emr.browse.manage.csp?EpisodeID=' + EpisodeID + '&PatientID=' + PatientID + '&2=2',    //新版电子病历
                //'url':'../csp/emr.interface.browse.category.csp?EpisodeID=' + EpisodeID + '&PatientID=' + PatientID + '&2=2',
                //'url':'../csp/emr.record.browse.episode.csp?EpisodeID=' + EpisodeID + '&PatientID=' + PatientID + '&2=2',
                'title':'病历浏览'
            }
        ]
    };
    
    //加载抗生素评估页签
    if (IndexTab == 'ASPOrdItem') {
        var tabOBJ = {
                'id':'ASPOrdItem',
                'url':'../csp/dhchai.ir.view.asporditem.csp',
                'title':'抗生素评估'
            }
        obj.tabJosn.data.push(tabOBJ);
    }
    
    // 加载tab列表
    for (var i=0;i<obj.tabJosn.data.length;i++){
        var id = obj.tabJosn.data[i].id;
        var text = obj.tabJosn.data[i].title;
        var htm = '';
        htm += '<li id="li_' + id + '">';
        htm += '<a data-toggle="tab"  aria-controls="nav"+' + id + '+ role="tab" data-toggle="tab" style="height:28px;" href="#nav' + id + '">';
        htm += text;
        htm += '</a>';
        htm += '</li>';
        $("#PatViewTab").append(htm);
    }
    InitPatViewWinEvent(obj);
    obj.LoadEvent(arguments);
    return obj;
}
