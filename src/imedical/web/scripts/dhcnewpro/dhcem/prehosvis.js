//===========================================================================================
// ���ߣ�      yangyongtao
// ��д����:   2019-12-07
// ����:	   ����Ժǰ�����¼
//===========================================================================================
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var VisID=""

/// ҳ���ʼ������
function initPageDefault(){
   InitSystemTime() //��ʼ��ϵͳʱ��
   
   InitCombobox();
   
   
   if(PhvID!=""){
	 VisID=	PhvID
	 GetPreHosVisInfo(VisID)
   }
}


function InitCombobox(){
	$("#RecUser").combobox({
		url:$URL+"?ClassName=web.DHCEMPreHosVis&MethodName=GetAllUser&LgHospID="+LgHospID,
		valueField:'id',
		textField:'text',
		mode:"remote",
		onSelect:function(option){
	       
	    }	
	})
}

/// ���漱���Ժǰ�����¼����
function SaveHosVis(){
	var PatName = $('#PatName').val();  						/// ��������
	if(PatName==""){
		$.messager.alert("��ʾ:","������������Ϊ�գ�","warning");
		return;
	}
	var PatSex = $('#PatSex').val();  							/// �Ա�
	if(PatSex==""){
		$.messager.alert("��ʾ:","�Ա���Ϊ�գ�","warning");
		return;
	}
	var PatAge = $('#PatAge').val(); 							/// ����
	if(PatAge==""){
		$.messager.alert("��ʾ:","���䲻��Ϊ�գ�","warning");
		return;
	}
	var VisPlace = $('#VisPlace').val();  						/// ����ص�
	if(VisPlace==""){
		$.messager.alert("��ʾ:","����ص㲻��Ϊ�գ�","warning");
		return;
	}
	var VisRea = $('#VisRea').val();  							/// ��������
	if(VisRea==""){
		$.messager.alert("��ʾ:","�������ɲ���Ϊ�գ�","warning");
		return;
	}
	var VisDate = $HUI.datebox("#VisDate").getValue();			/// ��������
	var VisTime = $("#VisTime").val(); 							/// ����ʱ��	
	var RecUser = $.trim($('#RecUser').combobox("getValue"));  				/// ��֪ͨ��	
	var CallerName = $('#CallerName').val();  					/// ����������
	var CallerPhone = $('#CallerPhone').val();  				/// ��ϵ�绰
	var VisSource = $("input[name='VisSource']:checked").val(); /// ��Ϣ��Դ 
	var CrateUser = LgUserID  // $('#CrateUser').val();    		/// �Ǽ���
	var CrateDate = $HUI.datebox("#CrateDate").getValue();    	/// �Ǽ�����
	var CrateTime = $("#CrateTime").val();  	/// �Ǽ�ʱ��
	///             ����Ϣ
	var mListData = PatName +"^"+ PatSex +"^"+ PatAge +"^"+ VisPlace +"^"+ VisRea;
    mListData = mListData +"^"+ VisDate +"^"+ VisTime +"^"+ RecUser +"^"+ CallerName +"^"+ CallerPhone;
    mListData = mListData + "^" +VisSource+"^"+ CrateUser +"^"+ CrateDate +"^"+ CrateTime +"^"+LgHospID //hxy 2020-06-04
  
	/// ����
	runClassMethod("web.DHCEMPreHosVis","Insert",{"VisID":VisID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			if(jsonString=="-1001"){
				$.messager.alert("��ʾ:","����ʧ�ܣ�ʧ��ԭ��:��֪ͨ���ڴ��ڵ�ǰ����","warning");
				return;
			}else if(jsonString=="-1002"){
				$.messager.alert("��ʾ:","����ʧ�ܣ�ʧ��ԭ��:��֪ͨʱ����ڵ�ǰʱ��","warning");
				return;
			}else if(jsonString=="-1003"){
				$.messager.alert("��ʾ:","����ʧ�ܣ�ʧ��ԭ��:��֪ͨ���ڴ��ڴ�������","warning");
				return;
			}else if(jsonString=="-1004"){
				$.messager.alert("��ʾ:","����ʧ�ܣ�ʧ��ԭ��:��֪ͨʱ����ڴ���ʱ��","warning");
				return;
			}else{
				$.messager.alert("��ʾ:","����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
			}
		}else{
			VisID=jsonString
			$.messager.alert("��ʾ:","����ɹ���","info",function(){
				window.location.reload();
				if (window.opener){
					window.opener.QryDisAmbMan()
					CancelHosVis() //�ر�
				}	
			});
		}
	},'',false)
}


/// ����Ժǰ�����¼
function GetPreHosVisInfo(VisID){
	runClassMethod("web.DHCEMPreHosVis","GetPreHosVisInfo",{"VisID":VisID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != null){
			$('#PatName').val(jsonObject.PatName);  						/// ��������
			$('#PatSex').val(jsonObject.PatSex);  							/// �Ա�
			$('#PatAge').val(jsonObject.PatAge); 							/// ����
			$('#VisPlace').val(jsonObject.VisPlace);  						/// ����ص�
			$('#VisRea').val(jsonObject.VisRea);  							/// ��������
			$HUI.datebox("#VisDate").setValue(jsonObject.VisDate);			/// ��������
			$("#VisTime").val(jsonObject.VisTime); 							/// ����ʱ��	
			$('#RecUser').combobox("setValue",jsonObject.RecUserID);  		/// ��֪ͨ��	
			$('#CallerName').val(jsonObject.CallerName);  					/// ����������
			$('#CallerPhone').val(jsonObject.CallerPhone);  				/// ��ϵ�绰
			$HUI.radio("input[name='VisSource']").setValue(false);
			if (jsonObject.VisSource != ""){
				$HUI.radio("input[name='VisSource'][value='"+ jsonObject.VisSource +"']").setValue(true);
			}
			$("input[name='VisSource']:checked").val(); 					/// ��Ϣ��Դ 
			$('#CrateUser').val(jsonObject.CrateUser);    					/// �Ǽ���
			$HUI.datebox("#CrateDate").setValue(jsonObject.CrateDate);    	/// �Ǽ�����
			$("#CrateTime").val(jsonObject.CrateTime);  					/// �Ǽ�ʱ��
		}
	},'json',false)
}


///  Ч��ʱ����¼�����ݺϷ���
function CheckEmPcsTime(id){

	var InTime = $('#'+ id).val();
	InTime=InTime.replace(/\D/g,'')
	if (InTime == ""){return "";}
	
	if (InTime.length < 4){InTime = "0" + InTime;}
	if (InTime.length != 4){
		$.messager.alert("��ʾ:","��¼����ȷ��ʱ���ʽ��<span style='color:red;'>����:18:23,��¼��1823</span>");
		$('#'+ id).val("");
		return "";
	}
	
	var hour = InTime.substring(0,2);
	if (hour > 23){
		$.messager.alert("��ʾ:","Сʱ�����ܴ���23��");
		$('#'+ id).val("");
		return "";
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		$.messager.alert("��ʾ:","���������ܴ���59��");
		$('#'+ id).val("");
		return "";
	}
	
	return hour +":"+ itme;
}

/// ��ʼ��ϵͳʱ��
function InitSystemTime(){
	
	runClassMethod("web.DHCEMPreHosVis","GetSystemTime",{},function(jsonObject){
		if (jsonObject != null){
			$HUI.datebox("#VisDate").setValue(jsonObject["SystemDate"]); /// ��������
			$("#VisTime").val(jsonObject["SystemTime"]); /// ����ʱ��
		}
	},'json',false)
}

/// ��ȡ�����ʱ��������
function SetEmPcsTime(id){
	
//	var InTime = $('#'+ id).val();
//	if (InTime == ""){return "";}
//	InTime = InTime.replace(":","");
	return "";
}

//ȡ��
function CancelHosVis(){
	window.close();
}
/// ����Ϊ undefined ��ʾ��
function txtUtil(txt){
	
	return (typeof txt == "undefined")?"":txt;
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
