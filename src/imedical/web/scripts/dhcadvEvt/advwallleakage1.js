/// Description: ҽ�ƻ������շ���(��©/����)�¼����浥
/// Creator: congyue
/// CreateDate: 2017-12-15
var eventtype=""
$(document).ready(function(){
	
	$('#AFLoc').combobox({ 
		//url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo',
		mode:'remote',  //,  //���������������
		onShowPanel:function(){ 
			$('#AFLoc').combobox('reload','dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo&hospId='+LgHospID+'')
		}
	});
	$('#WallLoc').combobox({ 
		//url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo',
		mode:'remote',  //,  //���������������
		onShowPanel:function(){ 
			$('#WallLoc').combobox('reload','dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo&hospId='+LgHospID+'')
		}
	});
	$("#SaveBut").on("click",function(){
		SaveWallReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveWallReport(1);
	})
	//�������ڿ���
	$('#FindDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	CheckTimeornum();  //ʱ��У��
	InitWallReport(recordId);//����ҳ����Ϣ
	
});
//���ر�����Ϣ
function InitWallReport(recordId)
{
	if((recordId=="")||(recordId==undefined)){	
		$('#AFLoc').combobox('setValue',LgCtLocDesc);  //��������
		//$('#AFLoc').combobox('setText',LgCtLocDesc);  //��������
		$('#WallDiscover').val(LgUserName); //Ĭ�Ϸ�����Ϊ��¼��
		$('#WallDiscover').attr("readonly","readonly"); //Ĭ�Ϸ�����Ϊ��¼��
	}else{
		$('#WallDiscover').attr("readonly","readonly"); //Ĭ�Ϸ�����Ϊ��¼��
	}
}
//���汣��
function SaveWallReport(flag)
{
	///����ǰ,��ҳ���������м��
	if(!checkRequired()){
		return;
	}
	//�жϹ�ѡ����ʱ��input�Ƿ���д -93871
	var RelatedAreasoth=0
	$("input[type=checkbox][id^='RelatedAreas']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[class='lable-input']").val()=="")){
				RelatedAreasoth=-1;				
			}
		}
	})
	if (RelatedAreasoth==-1){
		$.messager.alert("��ʾ:","��������򡿹�ѡ'����'������д���ݣ�");	
		return ;
	}
	SaveReport(flag);
}

//ʱ�� ����У��
function CheckTimeornum(){
	//��������У��  WallWorkYears
	//��������(��)
	$('#WallWorkYears').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//��������(��)
	$('#WLManWorkLife').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})

}
