//===========================================================================================
// ���ߣ�      yangyongtao
// ��д����:   2019-12-07
// ����:	   ����Ժǰ�ǼǼ�¼
//===========================================================================================
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgUserName= session['LOGON.USERNAME']/// �û�����
var del = String.fromCharCode(2);
var RegID=""
/// ҳ���ʼ������
function initPageDefault(){
   InitSystemTime() //��ʼ��ϵͳʱ��
   if(MaID!=""){
	 GetPreHosRegInfo(MaID)
   }
   if(PhvID!=""){
	  GetPreHosVisInfo(PhvID) 
	}
    /// �ǼǺ�
	$("#PatNo").bind('keypress',PatNo_KeyPress);
}
/// �ǼǺ�
function PatNo_KeyPress(e){
	
	var PatNo = $("#PatNo").val();
	if(e.keyCode == 13){
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  �ǼǺŲ�0
			var PatNo = GetWholePatNo(PatNo);
			$("#PatNo").val(PatNo);
			GetPatBaseInfo(PatNo);  /// ��ѯ
		}
	}
}

/// ���˾�����Ϣ
function GetPatBaseInfo(PatNo){
	runClassMethod("web.DHCEMDisAmbMan","GetPatBaseInfo",{"PatientNo":PatNo,"LgHospID":LgHospID},function(jsonString){
		var jsonObject = jsonString;
	        if(jsonObject.ErrCode<0){
			$.messager.alert('��ʾ',""+jsonObject.ErrMsg);
			return;		
		}
		if (JSON.stringify(jsonObject) != '{}'){
			$('.td-span-m').each(function(){
				$(this).val(jsonObject[this.id]);
			})
			$("#EpisodeID").text(jsonObject["EpisodeID"])
		}else{
			$.messager.alert('������ʾ',"������Ϣ�����ڻ��˷����۲��ˣ����ʵ�����ԣ�");
			return;	
		}
	},'json',false)
}
///��0���˵ǼǺ�
function GetWholePatNo(EmPatNo){

	///  �жϵǼǺ��Ƿ�Ϊ��
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  �ǼǺų���ֵ
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('������ʾ',"�ǼǺ��������");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}


/// ���漱���Ժǰ�Ǽ�����
function SaveHosReg(){
	
	
	var RegID=$("#RegID").text(); /// �Ǽ�ID
	var EpisodeID=$('#EpisodeID').text(); /// ����ID
	var ArrDate = $HUI.datebox("#ArrDate").getValue();			/// ��������
	var ArrTime = $("#ArrTime").val(); 							/// ����ʱ��
	var BackDate = $HUI.datebox("#BackDate").getValue();		/// ��Ժ����
	var BackTime = $("#BackTime").val(); 						/// ��Ժʱ��
	var DepartDate = $HUI.datebox("#DepartDate").getValue();	/// ��������
	var DepartTime = $("#DepartTime").val(); 					/// ����ʱ��
		
	var CrateUser = LgUserID  // $('#CrateUser').val();    		/// �Ǽ���
	var CrateDate = $HUI.datebox("#CrateDate").getValue();    	/// �Ǽ�����
	var CrateTime = $("#CrateTime").val();  	/// �Ǽ�ʱ��
	///             ����Ϣ
	var mListData = EpisodeID +"^"+ CrateUser +"^"+ MaID+"^"+ PhvID
    
    if(ArrDate!=""){ /// ��������
	   ArrDate="ArrDate"+"^"+ArrDate  
	}
	if(ArrTime!=""){ /// ����ʱ��
	   ArrTime="ArrTime"+"^"+ArrTime  
	}
	
	if(DepartDate!=""){ /// ��������
	   DepartDate="DepartDate"+"^"+DepartDate  
	}
	if(DepartTime!=""){ /// ����ʱ��
	   DepartTime="DepartTime"+"^"+DepartTime  
	}
	if(BackDate!=""){ /// ��Ժʱ��
	   BackDate="BackDate"+"^"+BackDate  
	}
	if(BackTime!=""){ /// ��Ժ����
	   BackTime="BackTime"+"^"+BackTime  
	}
	
    
    var ItemData= ArrDate +"@"+ ArrTime +"@"+ DepartDate +"@"+ DepartTime +"@"+ BackDate +"@"+ BackTime
    var mListData=mListData +del+ ItemData
	/// ����
	runClassMethod("web.DHCEMPreHosReg","Insert",{"RegID":RegID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			if(jsonString=="-1001"){
				$.messager.alert("��ʾ:","����ʧ�ܣ�����ʱ�䲻�ܴ��ڵ�ǰʱ�䣡");	
			}else if(jsonString=="-1002"){
				$.messager.alert("��ʾ:","����ʧ�ܣ�����ʱ�䲻�ܴ��ڵ�ǰʱ�䣡");	
			}else if(jsonString=="-1003"){
				$.messager.alert("��ʾ:","����ʧ�ܣ�����ʱ�䲻�����ڵ���ʱ�䣡");	
			}else{
				$.messager.alert("��ʾ:","����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
			}
		}else{
			RegID=jsonString
			$.messager.alert("��ʾ:","����ɹ���","info",function(){
				window.location.reload();
				if (window.opener){
					window.opener.QryDisAmbMan()
					CancelHosReg() //�ر�
				}	
			});
		}
	},'',false)
}


/// ����Ժǰ�Ǽ�
function GetPreHosRegInfo(MaID){
	runClassMethod("web.DHCEMPreHosReg","GetPreHosRegInfo",{"MaID":MaID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != null){
			
			$HUI.datebox("#DepartDate").setValue(jsonObject.DepartDate);	/// ��������
			$("#DepartTime").val(jsonObject.DepartTime); 					/// ����ʱ��
			
			$HUI.datebox("#ArrDate").setValue(jsonObject.ArrDate);			/// ��������
			$("#ArrTime").val(jsonObject.ArrTime); 							/// ����ʱ��
			
			$HUI.datebox("#BackDate").setValue(jsonObject.BackDate);		/// ��Ժ����
			$("#BackTime").val(jsonObject.BackTime); 						/// ��Ժʱ��	
				
			$('#CrateUser').val(jsonObject.CreateUser);    					/// �Ǽ���
			$HUI.datebox("#CrateDate").setValue(jsonObject.CreateDate);    	/// �Ǽ�����
			$("#CrateTime").val(jsonObject.CreateTime);  					/// �Ǽ�ʱ��
			$("#RegID").text(jsonObject.RegID)
		}
	},'json',false)
}

/// ����Ժǰ�����¼
function GetPreHosVisInfo(VisID){
	runClassMethod("web.DHCEMPreHosVis","GetPreHosVisInfo",{"VisID":VisID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != null){
			$('#PatNo').val(jsonObject.PatNo);
			$('#PatName').val(jsonObject.PatName);  						/// ��������
			$('#PatSex').val(jsonObject.PatSex);  							/// �Ա�
			$('#PatAge').val(jsonObject.PatAge); 							/// ����
			if(jsonObject.PatNo!=""){
				$('#PatNo').attr("disabled", true);
			}else{
				$('#PatNo').attr("disabled", false);	
			}	
		}
	},'json',false)
}

//ȡ������
function CancelRelReg(){
	
	runClassMethod("web.DHCEMPreHosReg","CancelRelAdm",{"RegID":RegID},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","ȡ������ʧ�ܣ�ʧ��ԭ��"+jsonString,"warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ:","ȡ�������ɹ���","info",function(){
				window.location.reload();
				if (window.opener){
					window.opener.QryDisAmbMan()
					CancelHosReg() //�ر�
				}	
			});
		}
		
	},'',false)	
	
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
			$HUI.datebox("#ArrDate").setValue(jsonObject["SystemDate"]); /// ��������
			$("#ArrTime").val(jsonObject["SystemTime"]); /// ����ʱ��
			$HUI.datebox("#DepartDate").setValue(jsonObject["SystemDate"]); /// ��������
			$("#DepartTime").val(jsonObject["SystemTime"]); /// ����ʱ��
			$HUI.datebox("#BackDate").setValue(jsonObject["SystemDate"]); /// ��������
			$("#BackTime").val(jsonObject["SystemTime"]); /// ����ʱ��
			
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
function CancelHosReg(){
	window.close();
}

/// ����Ϊ undefined ��ʾ��
function txtUtil(txt){
	
	return (typeof txt == "undefined")?"":txt;
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
