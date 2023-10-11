function InitReportWin(){
	var obj = new Object();
	obj.ReportID = ReportID;
	/* ����ҽ��վ���ݵĲ�����ȡ���˵Ļ�����Ϣ�����뵱ǰ�����Ӧ�ı��� */
	obj.LoadPatInfo = function() {
		var HCVPatInfo = ServerObj.HCVPatInfo.split('^');
		var PatientName = HCVPatInfo[2];
		var Sex = HCVPatInfo[3];
		var Age = HCVPatInfo[4];
	    var Birthday = HCVPatInfo[5];
	    $('#txtPatName').val(PatientName);
	    $('#txtPatSex').val(Sex);	            					// �Ա�
		$('#txtAge').val(Age);	            					// ����
		$('#dtBirthday').datebox('setValue',Birthday);
	}
	//������������ֵ���Ϣ
	obj.LoadDicInfo = function() {
		//�Ļ��̶�
		obj.cboEducation =Common_ComboToDic("cboEducation","HCVEducation");		
		//����״��
		obj.cboMarrige =Common_ComboToDic("cboMarrige","HCVSexWed");		
		//����������
	    obj.cboPerMonIncome = Common_ComboToDic("cboPerMonIncome","HCVPerMonIncome");   		
	    //ҽ������    
	    obj.cboMedInsType = Common_ComboToDic("cboMedInsType","HCVMedInsType"); 
	    //�״ο�������ʵ���Ҽ����Ҫԭ��
	    obj.RadTestReason = RadioToDic("RadTestReason","HCVTestReason",4,"txtTestReason"); 
	    //�״ο��������Է���
	    obj.cboTestMethod = Common_ComboToDic("cboTestMethod","HCVTestPosMethod"); 
	    //���帴�췽��
	    obj.cboRechMethod = Common_ComboToDic("cboRechMethod","HCVTestPosMethod"); 
	    //���帴����
	    obj.cboResults = Common_ComboToDic("cboResults","HCVLabResult"); 
	    //ת����
	    obj.cboReferResult = Common_ComboToDic("cboReferResult","HCVReferResult"); 
	    //δ����ԭ��
	    obj.RadUntreated = RadioToDic("RadUntreated","HCVUntreated",4,"txtUntreated"); 

	    //�����¼�
	    obj.ListenEvent();
	}

    //���ؼ����¼�
    obj.ListenEvent = function() {
	    //�������¼�    ҽ������
	    $HUI.combobox('#cboMedInsType', {
			onChange:function(newValue,oldValue){
				setTimeout(function(){	
					var Desc=$('#cboMedInsType').combobox('getText');
					if (Desc==$g("����")){	
						$('#txtMedInsType').removeAttr("disabled");
		            }else{
			            $('#txtMedInsType').val('');
		                $('#txtMedInsType').attr('disabled','disabled');
		            }
	            },100);
			}
		});
		//ת����
		$HUI.combobox('#cboReferResult', {
			onChange:function(newValue,oldValue){
				setTimeout(function(){	
				var Desc=$('#cboReferResult').combobox('getText');
					if (Desc==$g("��ҽԺ��������������")){	
						//�������ڿɱ༭
						$('#dtTreatmentDate').datebox('enable');
						//δ����ԭ�򲻿ɱ༭
						$("[name='RadUntreated']").radio('setValue',false);					
						$("[name='RadUntreated']").radio('disable');					
		            } else if  (Desc==$g("��ҽԺδ��������������")) {
						$("[name='RadUntreated']").radio('enable');					
						//�������ڲ��ɱ༭
						$('#dtTreatmentDate').datebox('clear');
						$('#dtTreatmentDate').datebox('disable');
		            } else{
			            $('#dtTreatmentDate').datebox('clear');
		                $('#dtTreatmentDate').datebox('disable');
						$("[name='RadUntreated']").radio('setValue',false);					
						$("[name='RadUntreated']").radio('disable');					
		            }
	            },100);
			}
		});
		
		// ****************************** ������ ��ѡ���¼� 
	    $HUI.radio("[name='RadTestReason']",{  	//�״ο�������ʵ���Ҽ����Ҫԭ��
	        onChecked:function(e,value){	      
	            var RadTestReason = $(e.target).attr("label"); //��ǰѡ�е�ֵ
	            if (RadTestReason==$g('����')) {   
					$('#txtTestReason').removeAttr("disabled");
	            }else{
		            $('#txtTestReason').val('');
	                $('#txtTestReason').attr('disabled','disabled');
	            }
	        }
	    });
	    
	    $HUI.radio("[name='IsRecheck']",{  //δ�����帴��
	        onChecked:function(e,value){
	            var IsRecheck = $(e.target).val(); //��ǰѡ�е�ֵ
	            if (IsRecheck==0) {
		            //����������ղ����ò��ɱ༭
		            $('#dtRecheckDate').datebox('setValue','');	  
	                $('#dtRecheckDate').datebox('disable');
	                //���췽����ղ����ò���ѡ��
	                $('#cboRechMethod').combobox('clear'); 
					$('#cboRechMethod').combobox('disable');
	                //��������ղ����ò���ѡ��
	                $('#cboResults').combobox('clear'); 
					$('#cboResults').combobox('disable');
	            } else {
		            //�����������ÿɱ༭
	                $('#dtRecheckDate').datebox('enable');	
	                $('#cboRechMethod').combobox('enable');	     
	                $('#cboResults').combobox('enable');       
	            }
	        }
	    });

	    $HUI.radio("[name='IsCheck']",{  //δ����Ѫ
	        onChecked:function(e,value){
	            var IsCheck = $(e.target).val(); //��ǰѡ�е�ֵ
	            if (IsCheck==0) {
		            $('#dtBloodDate').datebox('setValue','');
	                $('#dtBloodDate').datebox('disable');
	            } else {
	                $('#dtBloodDate').datebox('enable');		            
	            }
	        }
	    });
	    
	    $HUI.radio("[name='IsRefer']",{  //δת��
	        onChecked:function(e,value){
	            var IsRefer = $(e.target).val(); //��ǰѡ�е�ֵ
	            if (IsRefer==0) {
		            //ת��������ղ����ɱ༭
		            $('#dtReferDate').datebox('setValue','');
	                $('#dtReferDate').datebox('disable');
	                //ת������ղ����ò���ѡ��
	                $('#cboReferResult').combobox('clear'); 
					$('#cboReferResult').combobox('disable');
					//�������ڲ��ɱ༭
					$('#dtTreatmentDate').datebox('clear');
					$('#dtTreatmentDate').datebox('disable');
					//δ����ԭ�򲻿ɱ༭
            		$('#RadUntreated').radio('disable');          
	            } else {
		            $('#dtReferDate').datebox('enable');
					$('#cboReferResult').combobox('enable');
	            }
	        }
	    });
	    
	    $HUI.radio("[name='RadNucleinRet']",{  //���κ�������������������д����������
	        onChecked:function(e,value){
	            var RadNucleinRet = $(e.target).attr("label"); //��ǰѡ�е�ֵ
	            if (RadNucleinRet==$g('����')) {
					$('#txtNucleinRet').removeAttr("disabled");
	            }else{
		            $('#txtNucleinRet').val('');
	                $('#txtNucleinRet').attr('disabled','disabled');
	            }
	        }
	    });
	    	    
	    $HUI.radio("[name='RadUntreated']",{  //δ����ԭ��
	        onChecked:function(e,value){
	            var RadUntreated = $(e.target).attr("label"); //��ǰѡ�е�ֵ
	            if (RadUntreated==$g('����')) {   
					$('#txtUntreated').removeAttr("disabled");
	            }else{
		            $('#txtUntreated').val('');
	                $('#txtUntreated').attr('disabled','disabled');
	            }
	        }
	    });
	    // ****************************** ������ ��ѡ���¼�
    }
function RadioToDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	var otxtResume = arguments[3];
	var strDicList =$m({
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicsByType",
		aType:DicType,
		aActive:1
	},false);
	
	var dicList = strDicList.split(String.fromCharCode(1));
    var len = dicList.length;
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';   //ÿ�����ڰٷֱ�
	var listHtml=""
	for (var index =0; index< count; index++) {
		var radlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < radlen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			var TempHTML = ""
			if (dicSubList[1]==$g("����")){
				TempHTML +=  '<input id='+otxtResume+' style="margin:0px 0px 0px 10px;" class="textbox" disabled >'
			}
			listHtml += "<div style='float:left;width:"+per+";padding-top:10px;'><input id="+ItemCode+dicSubList[0]+" type='radio' class='hisui-radio' "+(dicSubList[0]==1? "checked='checked'":"")+" label="+dicSubList[1]+" name="+ItemCode+" value="+dicSubList[0]+">"+TempHTML+"</div>";
			
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
    $.parser.parse('#'+ItemCode);  //����radio
}

    InitReportWinEvent(obj);
	obj.LoadEvent();
	return obj;

}