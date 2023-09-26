//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-11-01
// ����:	   �޸Ĳ��˹Һ�ʱ�� JS
//===========================================================================================

var EpisodeID = "1";     /// ����ID

/// ҳ���ʼ������
function initPageDefault(){
	
	InitParams();      /// ��ʼ������
	initMethod();      /// hxy 2020-03-26 ����ʱ�����
	GetPatRegTime();   /// ȡ���˾���ʱ��
}

/// ��ʼ��ҳ�����
function InitParams(){
	
	EpisodeID = getParam("EpisodeID");   /// ����ID
}

/// ȡ���˾���ʱ��
function GetPatRegTime(){

	runClassMethod("web.DHCEMPatCheckLev","GetPatRegTime",{"EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != null){
			$HUI.datebox("#admDate").setValue(jsonObject.admDate);       /// ��������
			$HUI.timespinner("#admTime").setValue(jsonObject.admTime);   /// ����ʱ��
		}else{
			$.messager.alert('������ʾ',"ȡ���˾���ʱ�����,�����ԣ�");
			return;	
		}
	},'json',false)
}

function initMethod(){
	//���ڿ���
	$('#admDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	var now = new Date();
    var MaxTime= now.getHours()+':'+(now.getMinutes()+1);
    $('#admTime').timespinner({
	    max: MaxTime
	});
}

/// ����
function sure(){
	
	var admDate = $HUI.datebox("#admDate").getValue();       /// ��������
	var admTime = $HUI.timespinner("#admTime").getValue();   /// ����ʱ��
	if(admDate==""){
		window.parent.$.messager.alert("��ʾ:","�������ڲ���Ϊ�գ�","warning");
		return;
	}
	
	if(admTime==""){
		window.parent.$.messager.alert("��ʾ:","����ʱ�䲻��Ϊ�գ�","warning");
		return;
	}
	
	var mParams = admDate +"^"+ admTime;
	runClassMethod("web.DHCEMPatCheckLev","modPatRegTime",{ "EpisodeID":EpisodeID , "mParams":mParams},function(jsonString){
		
		if (jsonString < 0){
			window.parent.$.messager.alert("��ʾ:","�޸�ʧ�ܣ�","warning");
		}else{
			window.parent.$.messager.alert("��ʾ:","�޸ĳɹ���","warning",function(){
				closewin();	/// �ر�
			});
		}
	},'',false)
}

/// �ر�
function closewin(){
	websys_showModal('close'); //hxy 2020-03-27 st
	//commonParentCloseWin(); //ע��ed
}

/// �Զ�����ҳ�沼��
function onresize_handler(){
	
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {

	
	/// �Զ�����ҳ�沼��
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
