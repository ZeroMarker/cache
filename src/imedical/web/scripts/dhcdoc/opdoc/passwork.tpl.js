/**
 * tpl.js ҽ�����౾ģ��
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 */
var PageLogicObj = {
	
}

$(function(){
	//��ʼ��
	Init();
	
	//�¼���ʼ��
	InitEvent();
	
	//ҳ��Ԫ�س�ʼ��
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
		title:'�������',
		width:1300,
		height:900
	})
}

/**
 * ���潻������
 */
function savePassWork() {
	var content = $.trim($("#Content").val());
	if (content == "") {
		$.messager.alert('��ʾ','�����뽻������!',"info");
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
			$.messager.alert('��ʾ','����ɹ�',"info",function() {
				parent.PageLogicObj.m_DurDataGrid.selectRow(rowIndexOld);
				SetCurrentBCInfo(ServerObj.BCItemId);
			});
			
		} else if (responseText == "-103") {
			$.messager.alert('��ʾ','���ǽ����˲������޸ģ�' , "info");
			return false;
		} else {
			$.messager.alert('��ʾ','����ʧ��,�������: '+ responseText , "info");
			return false;
		}	
	})
	
	
}

//��ȡ��������һ�����Ϣ
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
										'<td class="r-label"><label for="L-BCName">���</label></td>' +
										'<td colspan="7" class="tip"><label id="L-BCName">'+record.BCName+'</label></td>' +
									'</tr>' +
									'<tr>' +
										'<td class="r-label"><label for="L-BCUser">������</label></td>' +
										'<td class="tip"><label id="L-BCUser">'+record.BCUser+'</label></td>' +
										'<td class="r-label"><label for="L-BCDate">����ʱ��</label></td>' +
										'<td class="tip"><label id="L-BCDate">'+record.BCDT+'</label></td>' +
									'</tr>' +
									'<tr>' +
										'<td class="r-label"><label for="PatWorkType">��������</label></td>' +
										'<td colspan="7">' +
											'<textarea id="dg-content" class="textbox" style="height:100px;width:95%;padding:4px;color:#E50027;">'+record.BContent+'</textarea>' +
										'</td>' +
									'</tr>' +
								'</table>';
				var $addDom = $(addContent);
				$("#PrevInfo").append($addDom);
				
			}
			
		} else {
			var addContent = '<p class="no">��ܰ��ʾ���޽�����Ϣ��</p>'; 
			var $addDom = $(addContent);
			$("#PrevInfo").append($addDom);
		}
	})
}
//��ȡ�����ñ������Ϣ
function SetCurrentBCInfo (BCItemId) {
	
	var PatInfo = $.m({
			ClassName:"web.DHCDocPassWork",
			MethodName:"GetPatInfoByItemID",
			ItemID: BCItemId
		},false);
		
	var PatArr = PatInfo.split(String.fromCharCode(1));
	
	//var baseMsg = "<span class='tip'>" + PatArr[0] + "��>" + PatArr[1] + "��>" + PatArr[2] + "��>" + PatArr[3] + "��>" + PatArr[6] + "</span>";
	//baseMsg = baseMsg + "<br/><a class='findLab' onclick='seeLabDetail("+ PatArr[5] + ")'>����鿴��������Ϣ</a>";
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
	//�������Backspace������  
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



