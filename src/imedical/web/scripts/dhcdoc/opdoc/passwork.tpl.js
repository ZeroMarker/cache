/**
 * tpl.js 医生交班本模板
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 */
var PageLogicObj = {
	
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	//PageHandle();
})


function Init(){	
	SetPrevBCInfo();
	SetCurrentBCInfo(ServerObj.BCItemId);
	
	
}

function InitEvent() {
	$("#DBSave").click(savePassWork);
	$("#Next").click(nextPassWork);
	$("#Prev").click(prevPassWork);
	$("#emr").click(seeLabDetail)
}

function prevPassWork () {
	var nextOBJ = parent.NextOrPrev('prev');
	if (nextOBJ) {
		var nextId = nextOBJ.BCItemId;
		var nextURL = nextOBJ.TplURL;
		var nextEpisodeID = nextOBJ.EpisodeID;
		var nextWorkType = nextOBJ.PatWorkType;
		parent.ReLoadTPLURL(nextId,nextURL,nextEpisodeID,nextWorkType);
	}
	return false;
	
}

function nextPassWork () {
	var nextOBJ = parent.NextOrPrev('next');
	if (nextOBJ) {
		var nextId = nextOBJ.BCItemId;
		var nextURL = nextOBJ.TplURL;
		var nextEpisodeID = nextOBJ.EpisodeID;
		var nextWorkType = nextOBJ.PatWorkType;
		parent.ReLoadTPLURL(nextId,nextURL,nextEpisodeID,nextWorkType);
	}
	return false;
}

function seeLabDetail() {
	//epr.newfw.episodelistbrowser.csp
	//websys.chartbook.hisui.csp
	//var lnk= "emr.record.browse.csp?"+"&EpisodeID="+ServerObj.EpisodeID;
	
	var lnk= "websys.chartbook.hisui.csp?"+"EpisodeID="+ServerObj.EpisodeID;	//DHC.Doctor.DHCEMRbrowse
	lnk = lnk +"&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookName=DHC.Doctor.DHCEMRbrowse"
   	//window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=1300,height=1000');
	websys_showModal({
		url:lnk,
		title:'病历浏览',
		width:1300,
		height:900
	})
}

/**
 * 保存交班内容
 */
function savePassWork() {
	var content = $.trim($("#Content").val());
	if (content == "") {
		$.messager.alert('提示','请输入交班内容!',"info");
		return false;
	}
	$.m({
		ClassName:"web.DHCDocPassWork",
		MethodName:"EditPWDetail",
		UserId: session['LOGON.USERID'],
		ItemId: ServerObj.BCItemId,
		BCNote: content
	},function (responseText){
		if(responseText == 0) {
			var selectedOld = parent.PageLogicObj.m_DurDataGrid.getSelected();
			var rowIndexOld = parent.PageLogicObj.m_DurDataGrid.getRowIndex(selectedOld);
			//PageLogicObj.m_Win.close();
			parent.PageLogicObj.m_DurDataGrid.reload();
			$.messager.alert('提示','保存成功',"info",function() {
				parent.PageLogicObj.m_DurDataGrid.selectRow(rowIndexOld);
				SetCurrentBCInfo(ServerObj.BCItemId);
			});
			
		} else if (responseText == "-103") {
			$.messager.alert('提示','不是交班人不允许修改！' , "info");
			return false;
		} else {
			$.messager.alert('提示','保存失败,错误代码: '+ responseText , "info");
			return false;
		}	
	})
	
	
}

//获取并设置上一班次信息
function SetPrevBCInfo () {
	$.m({
		ClassName:"web.DHCDocPassWorkE2",
		MethodName:"GetPrevBCInfo",
		LocId: session['LOGON.CTLOCID'],
		Admid:ServerObj.EpisodeID,
		inItemid:ServerObj.BCItemId
	},function (responseText){
		if(responseText != "") {
			var jsonData = $.parseJSON(responseText);
			for (var i=0; i< jsonData.length; i++) {
				var record = jsonData[i];
				var addContent = '<table class="search-table">' + 
									'<tr>' +
										'<td class="r-label"><label for="L-BCName">班次</label></td>' +
										'<td colspan="7" class="tip"><label id="L-BCName">'+record.BCName+'</label></td>' +
									'</tr>' +
									'<tr>' +
										'<td class="r-label"><label for="L-BCUser">交班人</label></td>' +
										'<td class="tip"><label id="L-BCUser">'+record.BCUser+'</label></td>' +
										'<td class="r-label"><label for="L-BCDate">交班时间</label></td>' +
										'<td class="tip"><label id="L-BCDate">'+record.BCDT+'</label></td>' +
									'</tr>' +
									'<tr>' +
										'<td class="r-label"><label for="PatWorkType">交班内容</label></td>' +
										'<td colspan="7">' +
											'<textarea id="dg-content" class="textbox" style="height:100px;width:95%;padding:4px;color:#E50027;">'+record.BContent+'</textarea>' +
										'</td>' +
									'</tr>' +
								'</table>';
				var $addDom = $(addContent);
				$("#PrevInfo").append($addDom);
				
			}
			
		} else {
			var addContent = '<p class="no">温馨提示：无交班信息！</p>'; 
			var $addDom = $(addContent);
			$("#PrevInfo").append($addDom);
		}
	})
}
//获取并设置本班次信息
function SetCurrentBCInfo (BCItemId) {
	
	var PatInfo = $.m({
			ClassName:"web.DHCDocPassWork",
			MethodName:"GetPatInfoByItemID",
			ItemID: BCItemId
		},false);
		
	var PatArr = PatInfo.split(String.fromCharCode(1));
	
	//var baseMsg = "<span class='tip'>" + PatArr[0] + "—>" + PatArr[1] + "—>" + PatArr[2] + "—>" + PatArr[3] + "—>" + PatArr[6] + "</span>";
	//baseMsg = baseMsg + "<br/><a class='findLab' onclick='seeLabDetail("+ PatArr[5] + ")'>点击查看检验检查信息</a>";
	//$("#dg-msg").html(baseMsg);
	var Content = 	PatArr[4];
	var BCName = 	PatArr[0];
	var PatName = 	PatArr[3];
	var PatType = 	PatArr[1];
	var PatNo = 	PatArr[2];
	var Diagnosis = PatArr[6];
	var BCTime = 	PatArr[8];
	var BCUser = 	PatArr[9];
	
	$("#Content").val(Content);
	$("#BCName").text(BCName);
	$("#PatName").text(PatName);
	$("#PatType").text(PatType);
	$("#PatNo").text(PatNo);
	$("#Diagnosis").text(Diagnosis);
	$("#BCTime").text(BCTime);
	$("#BCUser").text(BCUser);
	
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}



