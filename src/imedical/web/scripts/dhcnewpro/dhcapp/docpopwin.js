//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-03-20
// ����:	   �������ҽ���������洰�����js
//===========================================================================================

//var PanelWidth = (typeof dialogWidth == "undefined")?($(window).width() - 40) :dialogWidth;
var PanelWidth = 1180;
var refresh = 0;

/// ҳ���ʼ������
function initPageDefault(){
	
	$('#tabs').tabs({
		onSelect:function(title,index){
		   /*
		   if (((title.indexOf("ʬ�����뵥") != "-1")||(title.indexOf("��Ժ����") != "-1"))&(refresh == 0)){
			  var curTab = $('#tabs').tabs('getSelected');
			  if (curTab && curTab.find('iframe').length > 0) {
			  	  curTab.find('iframe')[0].contentWindow.location.reload();
			  	  refresh = 1;
			  }
		   }
		   */
		   if ((title.indexOf("ʬ��") != "-1")||(title.indexOf("����") != "-1")||(title.indexOf("��Ժ����") != "-1")){
		   	  frames[index].resize();
		   }
		}
	});
}

/// �ύ����
function TakPisNo(){
	
	var WriteFlag = 0;
	/// ѭ������������뵥
	for (var i=0; i<frames.length; i++){
		if (!frames[i].InsertDoc()) break;
		WriteFlag = WriteFlag + 1;
	}

	/// ��д�����������ύ������һ��ʱ����
    if (frames.length != WriteFlag) return;
    
	/// �ύ����
	runClassMethod("web.DHCAppPisMaster","InsertDoc",{"Pid":pid},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�ύ����ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			window.returnValue = jsonString;
			window.close();
		}
	},'',false)
	
}

/// �رյ�������
function TakClsWin(){
	
	window.close();        /// �رյ�������
}

/// ����߶�
function GetPanelWidth(){
	return PanelWidth;
}

/// ��ʾ��Ϣ
function InvErrMsg(message){
	$.messager.alert("��ʾ:", message);
	return;
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })