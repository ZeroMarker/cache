///Creator :QQA 
///CreateDate: 2017-03-09

$(function (){
	
	validAdm();
	
	showCheckLev();
	
	///��ʼ��easyui�ؼ�
	initWidget();
	
	///��ʼ����ť����
	initMethod();

})

function validAdm(){
	//��ȡ������Ϣ
	runClassMethod("web.DHCEMECheck","GetAdmStatus",{
		EpisodeID:EpisodeID
		},function (ret){
			if(ret!="A"){
				$.messager.alert("��ʾ:","��ǰ����״̬����������״̬����������ķּ���","info",function(){
					window.close()
				});	
			}
		},"text"
	)
}

//��ʾ�ּ�����Ϣ
function showCheckLev(){
	//��ȡ������Ϣ
	runClassMethod("web.DHCEMECheck","GetEmPatCheckLevGrade",{
		EpisodeID:EpisodeID
		},function (data){
			var nursCheckLev = data.split("^")[0];
			var docCheckLev = data.split("^")[1]?data.split("^")[1]:"��";
			var styleCss = StyleCheckLevColor(nursCheckLev); 
			$("#nursCheck").val(setCellLabel(nursCheckLev)); //hxy 2020-02-20
			$("#nursCheck").css(styleCss);
			var styleCss = StyleCheckLevColor(docCheckLev); 
			$("#docCheck").val(setCellLabel(docCheckLev)); //hxy 2020-02-20
			$("#docCheck").css(styleCss);
		},"text"
	)
}

function initWidget(){
	$("#CheckLevCause").combobox({
		multiple:false,
		blurValidValue:true,
		url:LINK_CSP+'?ClassName=web.DHCEMDocUpReason&MethodName=JsonComboDocUpdReason&hopDr='+LgHospID+"&Type=Doc"
	});
	
	$("#NurCheckAssess").combobox({
		blurValidValue:true,
		url:LINK_CSP+'?ClassName=web.DHCEMDocAssessType&MethodName=JsonComboDocAssessType&hopDr='+LgHospID
	});
	
	$("#DocLevel").combobox({
		blurValidValue:true,
		valueField:'id',
		textField:'text',
		data:[{ "id": "1", "text": "��"},{ "id": "2", "text": "��"},{ "id": "3", "text": "��"},{ "id": "4", "text": "��a��"},{ "id": "5", "text": "��b��"}] //hxy 2020-02-20
		//data:[{ "id": "1", "text": "1��"},{ "id": "2", "text": "2��"},{ "id": "3", "text": "3��"},{ "id": "4", "text": "4��"}]
	});

	
}

function initMethod(){
	$('a:contains("����")').bind("click",UptPatCheckLev);
	$('a:contains("ȡ��")').bind("click",CloseWindow);	
}

///�޸Ĳ��˷ּ�
function UptPatCheckLev(){
	var Params  = getParams();
	
	if(Params==""){
		return;	
	}
	
	runClassMethod("web.DHCEMECheck","InsDHCEmDocUpdPatLev",
    {Adm:EpisodeID,
   	 Params:Params
    },
	   function (data){
			if(data==0){
				$.messager.alert("��ʾ:","����ɹ���","info",function(){
					if(window.opener!=null){			///����ˢ��
						if(window.opener.parentFlash){
							window.opener.parentFlash();
						}
					}
					window.close()
				});	
			}else{
				$.messager.alert("��ʾ:","����ʧ�ܣ�");		
			}
		},
		"text",false
	);
}

function getParams(){
	var Params = ""
	//����^����ԭ��id^ҽ��id^��ʿ�ּ�����^����˵��^����(����)^ʱ��(����)
	var DocCheckLev = $('#DocLevel').combobox("getValue");
	
	if(DocCheckLev===""){
		$.messager.alert("��ʾ:","��ѡ��ּ���");	
		return "";
	}
	
	var DocCheck=$("#docCheck").val(); //hxy 2020-03-10 st
	var DocCheckLevText = $('#DocLevel').combobox("getText");
	if(DocCheckLevText==DocCheck){
		$.messager.alert("��ʾ:","�޸ķּ��뵱ǰ�ּ���ͬ�������޸ģ�");	
		return "";
	}//ed

	var CheckLevCause=""
	CheckLevCause = $('#CheckLevCause').combobox("getValue");
	
	if(CheckLevCause===""){
		$.messager.alert("��ʾ:","��ѡ�����ԭ��");	
		return "";
	}
	
	var NurCheckAssess = ""
	NurCheckAssess = $('#NurCheckAssess').combobox("getValue");
	
	var NurCheckComments=""
	NurCheckComments = $('#NurCheckComments').val();
	
	Params=DocCheckLev+"^"+CheckLevCause+"^"+LgUserID+"^"+NurCheckAssess+"^"+NurCheckComments

	return Params;	
}

function StyleCheckLevColor(param){
	var css={};
	if(param.indexOf("1��")>-1){ //hxy 2020-02-20 ԭ�� =="1��"
		css = {"color":"red","font-weight":"bold"};
	}
	if(param.indexOf("2��")>-1){ //=="2��"
		css = {"color":"orange","font-weight":"bold"}; //hxy 2020-02-20 ԭ�� red
	}
	if(param.indexOf("3��")>-1){ //=="3��"
		css = {"color":"#f9bf3b","font-weight":"bold"};	
	}
	if((param.indexOf("4��")>-1)||(param.indexOf("5��")>-1)){ //hxy 2020-02-20 add ||(param=="5��")
		css = {"color":"green","font-weight":"bold"};	
	}
	return css;
}

///�رս���
function CloseWindow(){
	window.close();
}

//hxy 2020-02-20
function setCellLabel(value){
	if(value.indexOf("1��")>-1){value="��";}
	if(value.indexOf("2��")>-1){value="��";}
	if(value.indexOf("3��")>-1){value="��";}
	if(value.indexOf("4��")>-1){value="��a��";}
	if(value.indexOf("5��")>-1){value="��b��";}
	return value;
}
