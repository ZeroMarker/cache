/// ҳ���ʼ������
function initPageDefault(){
	InitParams();      /// ��ʼ������
}

/// ��ʼ��ҳ�����
function InitParams(){
	//EpisodeID = getParam("EpisodeID");   /// ����ID
}

/// ����
function sure(){
	
	if(window.parent.frames["TRAK_main"]){
		if(window.parent.frames["dhcmessageexec"]){
			window.parent.frames["dhcmessageexec"].$("#reasonInput").val("");
		}else{
			if(window.parent.frames["TRAK_main"].frames["idhcem_consultquery"]){
				window.parent.frames["TRAK_main"].frames["idhcem_consultquery"].frames[0].$("#reasonInput").val("");
			}else{
				window.parent.frames["TRAK_main"].frames[0].$("#reasonInput").val("");
			}
		}
	}else{
		window.parent.frames[0].$("#reasonInput").val("");
	}
	
	var reason = $("#reason").val();       /// ԭ��
	if(reason==""){
		window.parent.$.messager.alert("��ʾ:","ԭ����Ϊ�գ�","warning");
		return;
	}
	if(window.parent.frames["TRAK_main"]){
		if(window.parent.frames["dhcmessageexec"]){
			window.parent.frames["dhcmessageexec"].$("#reasonInput").val(reason);
		}else{
			if(window.parent.frames["TRAK_main"].frames["idhcem_consultquery"]){
				window.parent.frames["TRAK_main"].frames["idhcem_consultquery"].frames[0].$("#reasonInput").val(reason);
			}else{
				window.parent.frames["TRAK_main"].frames[0].$("#reasonInput").val(reason);
			}
		}
	}else{
		window.parent.frames[0].$("#reasonInput").val(reason);
	}
	//window.parent.frames["dhcmessageexec"].$("#reasonInput").val(reason)
   	closewin();	/// �ر�
}

/// �ر�
function closewin(){
	websys_showModal('close');
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
