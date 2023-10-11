///Creator:hxy
///Date:2019-10-19
var PatientID=""
var DateFormat=""
$(function(){
	
	initParams();
	
	clearForm();
		
	initMethod();
	
	QueryGroupHurt();   // Ĭ�ϲ�ѯһ��

    $("#GroupPatGrid").datagrid('loadData',{ "total":"0",rows:[]});

})

function initMethod(){
	//�ش��¼����¼����� 
	$('#QueryGroupHurt').bind("click",QueryGroupHurt);  
	
	$("#GroupHurtStDate,#GroupHurtEndDate").datebox("setValue",formatDate(new Date())); //hxy 2020-03-05
	//���ڿ��� //hxy 2020-03-04 st
	$('#GroupHurtDate').datetimebox().datetimebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	$('#GroupReportTime').datetimebox().datetimebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	var now = new Date();
    var MaxTime= now.getHours()+':'+(now.getMinutes()+1);
    $('#GroupHurtDate').datetimebox('spinner').timespinner({
	    max: MaxTime
	});
	$('#GroupReportTime').datetimebox('spinner').timespinner({
	    max: MaxTime
	}); //ed
}

/// Ⱥ�˲��˲�ѯ lp 18-1-22
function QueryGroupHurt(){
	var GroupHurtStDate=$('#GroupHurtStDate').combobox('getValue');
	var GroupHurtEndDate=$('#GroupHurtEndDate').combobox('getValue');
	var params=GroupHurtStDate+"^"+GroupHurtEndDate+"^"+LgHospID;
	$('#GroupGrid').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMGroupPatMajor&MethodName=ListGroupHurt',	
		queryParams:{
			params:params}
	});	
	clearForm();
   
}

/// �¼����߹���
function LinkPat(){
	var row = $('#GroupGrid').datagrid('getSelected');
	if(!row){
		$.messager.alert('��ʾ��','��ѡ��������¼���');	
		return;
	}
	if(PatientID==""){
		$.messager.alert('��ʾ��','δ���뻼�ߣ����ڻ����б�ѡ��');	
		return;
	}
	var GroupID=row.ID;
	var params=PatientID+"^"+GroupID;
	
	runClassMethod("web.DHCEMGroupPatMajor","LinkPat",{"params":params},function(data){
		if(data<0){
			$.messager.alert('��ʾ��','����ʧ�ܣ�');
			return;		
		}else if(data==1){ //hxy 2020-03-06
			$.messager.alert('��ʾ��','�ѹ�����');
			return;
		}else{	
			$.messager.alert('��ʾ��','�����ɹ���');
			$("#GroupPatGrid").datagrid('reload') //hxy 2020-02-25
		}
	})
}

///��ʼ������
function initParams(){
	DateFormat = "";
	runClassMethod("web.DHCEMRegister","GetParams",{Params:""},
		function (rtn){
			DateFormat = rtn;
	},"text",false)
	PatientID = getParam("PatientID");   /// ����ID
	runClassMethod("web.DHCEMGroupPatMajor","GetInfo",{"PatientID":PatientID},function(data){
		$("#MajorName").text(data.split("^")[0]);
		$("#MajorNo").text(data.split("^")[1]);		
	},"text",false)	
}

/// ��ʽ������  bianshuai 2014-09-18
function formatDate(t){
	var curr_Date = new Date();  
	curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	//return Year+"-"+Month+"-"+Day;
	
	if(typeof(DateFormat)=="undefined"){ //2017-03-15 cy
		return Year+"-"+Month+"-"+Day;
	}else{
		if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY 2017-03-07 cy
			return Day+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
			return Year+"-"+Month+"-"+Day;
		}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
			return Month+"/"+Day+"/"+Year;
		}else{ //2017-03-15 cy
			return Year+"-"+Month+"-"+Day;
		}
	}
}

/// form���
function clearForm(){
	$("input[type='checkbox'][name$='GroupReportFor']").radio('setValue',false);
	$('#formMes').form("clear");
	runClassMethod("web.DHCEMGroupPatMajor","GetTrsUser",{"LgUserName":LgUserName},function(data){
		$("#GroupReportUser").val(data);
	},"text",false)	
	//$("#GroupReportUser").val(LgUserName);
	//$("input[type='checkbox'][name$='GroupReportFor']").radio('setValue',false);
	//$('.hisui-radio').not("input[type='radio'][name$='Flag']").radio('setValue',false)
}
// ����
function submitForm(){
	var params="";
	var	GroupHurtDate=$('#GroupHurtDate').datetimebox('getValue');
	if(GroupHurtDate==""){
		$.messager.alert('��ʾ��','��¼���¼�ʱ�䣡');
		return;	
	}
	var	GroupHurtSite=$('#GroupHurtSite').val();
	var	GroupHurtDesc=$('#GroupHurtDesc').val();
	if(GroupHurtDesc==""){
		$.messager.alert('��ʾ��','��¼���¼�������');
		return;	
	}
	var GroupReportFor="";
	/// �㱨����
	var ReportForArr = [];
	$('input[name="GroupReportFor"]:checked').each(function(){
		ReportForArr.push(this.value);
	})

	var GroupReportFor = ReportForArr.join("@");
	var GroupReportUserID=LgUserID;
	var GroupReportTime=$('#GroupReportTime').datetimebox('getValue');
	var RowId=$('#RowId').val();
	params=GroupHurtDate+"^"+GroupHurtSite+"^"+GroupHurtDesc+"^"+GroupReportFor+"^"+GroupReportUserID+"^"+GroupReportTime+"^"+LgHospID+"^Major^"+RowId;
	//return GroupHurtDate+"^"+encodeURIComponent(GroupHurtSite)+"^"+encodeURIComponent(GroupHurtDesc)+"^"+encodeURIComponent(GroupReportFor)+"^"+GroupReportUserID+"^"+GroupReportTime+"^"+LgHospID+"^Major^"+RowId;

	 //alert(params)
	 runClassMethod("web.DHCEMGroupPatMajor","SavePatGroupHurt",{"params":params},function(data){
	  	if (data == 0) { 
           	$.messager.alert("��ʾ","����ɹ�!");
            $('#GroupGrid').datagrid('reload');  // �������뵱ǰҳ������ 
            clearForm(); 
          }else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#GroupGrid").datagrid('reload')
		  }else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				//clearForm();
		  }
	},'text')

}

//������ʾ���
function onClickRow(index,row){
	clearForm();
	var row = $('#GroupGrid').datagrid('getSelected');
	if(!row){
		return;	
	}
	$('#RowId').val(row.ID);
	$('#GroupHurtDate').datetimebox('setValue',row.GHUDateAndTime);
	$('#GroupHurtSite').val(row.GHUSite);
	$('#GroupHurtDesc').val(row.GHUDetailSpec);
	//alert(row.GHUReportFor)
	var ForArr = row.GHUReportFor.split("@");
	for(var i=0;i<ForArr.length;i++){
		$HUI.radio('input[name="GroupReportFor"][value="'+ ForArr[i] +'"]').setValue(true);
	}
	$('#GroupReportUserID').val(row.GHUReportUserDr);
	$('#GroupReportUser').val(row.GHUReportUser);
	$('#GroupReportTime').datetimebox('setValue',row.GHUReportTime);
	
	var params=row.ID;
	$('#GroupPatGrid').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMGroupPatMajor&MethodName=QueryGroupHurt',	
		queryParams:{
			params:params}
	});	
}

/// �¼�����ȡ������
function CanLinkPat(){
	var row = $('#GroupPatGrid').datagrid('getSelected');
	if(!row){
		$.messager.alert('��ʾ��','��ѡ��ȡ�������Ļ��ߣ�');	
		return;
	}
	var ID=row.ID;
	$.messager.confirm('��ʾ', 'ȷ���û���ȡ��������?', function(result){  
    	if(result) {
        	runClassMethod("web.DHCEMGroupPatMajor","CanLinkPat",{"ID":ID},function(data){
				if(data<0){
					$.messager.alert('��ʾ��','ȡ������ʧ�ܣ�');
					return;
				}else{	
					$.messager.alert('��ʾ��','ȡ�������ɹ���');
					$("#GroupPatGrid").datagrid('reload');
				}
			})
        }else{
	    }
	})
}



