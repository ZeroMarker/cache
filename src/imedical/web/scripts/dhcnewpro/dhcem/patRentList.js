///qqa

$(function(){
	initParam();
	
	initDateBox();
	
	initCombobox();
	
	initDatagrid();
	
	initMethod();
		
})
///��ȡ����
function initParam(){
	DateFormat="";   //��̨ʱ������
	UserDesc="";
	var params = UserId
	runClassMethod("web.DHCEmPatChkRList","GetParams",{Params:params},function (data){
		DateFormat = data.split("^")[0];
		UserDesc = data.split("^")[1];
		
	},'text',false)	
}

///��ʼ���¼��ؼ�
function initDateBox(){
	$HUI.datebox("#startDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}

///��ʼ��������
function initCombobox(){
	$HUI.combobox("#renterFlag",{
		data:[
			{"value":"1","text":$g("��")},
			{"value":"2","text":$g("��")}
		],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    	if(option.value==="1"){
		    	clearReturnInfo();
		    }
			if(option.value==="2"){
		    	$("#giveNurse").val(UserDesc);
		    }
		    setInputReq();
	    }	
	})
	
	$HUI.combobox("#status",{
		data:[
			{"value":"1","text":$g("��")},
			{"value":"2","text":$g("��")}
		],
		valueField:'value',
		textField:'text'	
	})
	

	$HUI.combobox("#rentTool",{
		url:LINK_CSP+"?ClassName=web.DHCEmPatChkRList&MethodName=GetRentList&HospID="+HospID,
		valueField:'id',
		textField:'text',
		required:true,
		onSelect:function(option){
	       
	    },
	    onLoadSuccess:function(){
			//selectFirstItm("#rentTool","id");    
		}	
	})
	
	$HUI.combobox("#cardType",{
		data:[{'id':$g('���֤'),'text':$g('���֤')},
	 	  {'id':$g('����֤'),'text':$g('����֤')},
	 	  {'id':$g('����֤'),'text':$g('����֤')},
	  	  {'id':$g('��ʻ֤'),'text':$g('��ʻ֤')},
	  	  {'id':$g('����'),'text':$g('����')}],
		valueField:'id',
		textField:'text',
	    onLoadSuccess:function(){
			selectFirstItm("#cardType","id");    
		}
	})
}

///��ʼ��table
function initDatagrid(){
	var columns=[[{
               field: 'PCRDate',
               title: '��������',
               width:100  
        	}, {
               field: 'PCRTime',
               title: '����ʱ��',
               width:100  
        	}, {
               field: 'PCROperator',
               title: '���ò�����',
               width:100  
        	}, 
        	{
               field: 'PCRRenter',
               title: '����������',
               width:100  
        	}, {
               field: 'PCRRenterTel',
               title: '��ϵ��ʽ',
               width:100  
        	}, {
               field: 'PCRCardType',
               title: '֤��',
               width:100    
        	}, {
               field: 'PCRCash',
               align: 'center',
               title: '�ֽ�',
               width:100  
           }, {
               field: 'PCRCashNo',
               title: '���',
               width:100   
        	}, {
               field: 'PCRRentDesc',  
               title: '���ù���',
               width:100  
        	}, {
               field: 'PCRGiveUser',
               title: '�黹������',
               width:100  
           }, {
                field: 'PCRGiveRelation',
                title: '��ϵ',
				width:100          
        	}, {
                field: 'PCRFlag',
                align: 'center',
                title: '״̬',
                formatter:SetCell,
				width:100  
        	},{
                field: 'PCRGiveDate',
                title: '�黹����',
				width:100        
        	},{
                field: 'PCRGiveTime',
                title: '�黹ʱ��',
				width:100     
        	},{
				field: 'PCRGiveOpUser',
				title: '�黹������',
				width:100     
        	},{
				field:'rentRowId',
				align:'center',
				hidden:true,
				title:'ID'
	        },{
				field:'PCRRentDr',
				align:'center',
				hidden:true,
				title:'RentId'
		    }]]
		    
	$HUI.datagrid('#rentTable',{
		url:LINK_CSP+'?ClassName=web.DHCEmPatChkRList&MethodName=JsonListSearchRent',  //JsonListSearchRent
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:60,  
		pageList:[60], 
		loadMsg: $g('���ڼ�����Ϣ...'),
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		bodyCls:'panel-header-gray',//hxy 2018-10-25
		//border:false,//hxy 2018-10-22
		queryParams:{
			 StartDate:$HUI.datebox("#startDate").getValue()+"^"+$HUI.timespinner('#startTime').getValue(), //��ʼʱ��
             EndDate:$HUI.datebox("#endDate").getValue()+"^"+$HUI.timespinner('#endTime').getValue(),  //��ֹʱ��
             Renter:$("#patName").val(),    //����������
             RentStatus:($HUI.combobox("#status").getValue()==undefined?"":$HUI.combobox("#status").getValue()),
             Hosp:HospID
		}
	});
		    
	
}

///�󶨷���
function initMethod(){
	$("#searchBtn").on("click",search);
	
	$("#insert").on("click",function(){op("A")});
	
	$("#update").on("click",function(){op("U")});
	
	$("#returnTool").on("click",function(){op("R")});
	
	$("#save").on("click",save);
}


function search(){
	$HUI.datagrid('#rentTable').load({
		StartDate:$HUI.datebox("#startDate").getValue()+"^"+$HUI.timespinner('#startTime').getValue(), //��ʼʱ��
		EndDate:$HUI.datebox("#endDate").getValue()+"^"+$HUI.timespinner('#endTime').getValue(),  //��ֹʱ��
		Renter:$("#patName").val(),    //����������
		RentStatus:($HUI.combobox("#status").getValue()==undefined?"":$HUI.combobox("#status").getValue()),
		Hosp:HospID
	})
}

function insert(){
	$("#nurse").val(UserDesc);
	$HUI.datebox("#rentDate").setValue(formatDate(0));
	$HUI.timespinner('#rentTime').setValue(curTime());
}

///Model:UΪ�޸�  R:�黹 A:���
function op(model){
	var rowData ="";
	
	if(model!=="A"){	
		var datas = $HUI.datagrid("#rentTable").getSelections();
		if(!datas.length){
			$.messager.alert("��ʾ","δѡ�����ݣ�");	
			return;
		}
		rowData=datas[0];
	}
	
	clearForm();   //�����岻�ɱ༭״̬
	clearFormData();   //����������
	$HUI.window("#widow").open();  //�����
	///�������title
	if(model=="R"){
		$("#windowTitle").html($g("�黹"));
	}else if (model=="A"){
		$("#windowTitle").html($g("���"));
	}else if(model=="U"){
		$("#windowTitle").html($g("�޸�"));
	}
	
	///���������Ԫ�ر༭״̬
	if(model=="R"){
		setFormDisable("R");
	}else if (model=="A"){
		setFormDisable("A");
	}else if (model=="U"){
		setFormDisable("U");	
	}
	
	//����������
	if(rowData!="") load(rowData);
	
	//�����������
	if(model=="R"){
		setFormData("R");
	}else if (model=="A"){
		setFormData("A");
	}
	
	setInputReq();
}

function setFormDisable(model){
	
	if(model==="A"){
		$HUI.datebox("#rentDate",{disabled:true});
		$HUI.timespinner('#rentTime',{disabled:true});
		$("#giveRelation").attr("disabled","disabled");
		$("#giveUser").attr("disabled","disabled");
		$HUI.datebox("#giveDate",{disabled:true});
		$HUI.timespinner('#giveTime',{disabled:true});
		$HUI.combobox("#renterFlag",{disabled:true});
	}
	
	if(model==="R"){
		$HUI.datebox("#rentDate",{disabled:true});
		$HUI.timespinner('#rentTime',{disabled:true});
		$("#renterTel").attr("disabled","disabled");
		$("#cardType").attr("disabled","disabled");
		$("#cash").attr("disabled","disabled");
		$("#cashNo").attr("disabled","disabled");
		$HUI.combobox("#cardType",{disabled:true});
		$HUI.combobox("#rentTool",{disabled:true});
		$HUI.combobox("#renterFlag",{disabled:true});
		$("#renter").attr("disabled","disabled");
		
	}
	
	if(model==="U"){
		$HUI.datebox("#rentDate",{disabled:true});
		$HUI.timespinner('#rentTime',{disabled:true});
		//$HUI.combobox("#renterFlag",{disabled:true});
	}
}

function setFormData(model){
	if(model==="R"){
		$("#giveNurse").val(UserDesc);
		$HUI.datebox("#giveDate").setValue(formatDate(0));
		$HUI.timespinner('#giveTime').setValue(curTime());
		$HUI.combobox("#renterFlag").setValue("2");
	}
	
	if(model==="A"){
		$("#nurse").val(UserDesc);
		$HUI.datebox("#rentDate").setValue(formatDate(0));
		$HUI.timespinner('#rentTime').setValue(curTime());
		$HUI.combobox("#renterFlag").setValue("1");
		selectFirstItm("#cardType","id");
	}
}

function setInputReq(){
	var renterText=$HUI.combobox("#renterFlag").getText();
	var inputReq=renterText==$g("��")?true:false;
	$("#giveUser").validatebox("options").required=inputReq;
	$("#giveUser").validatebox('isValid');
	return;	
}

function save(){
	
	var rentid=$("#rentRowId").val();
	var Date=$HUI.datebox("#rentDate").getValue();          //��������
	var Time=$HUI.timespinner('#rentTime').getValue();      //����ʱ��  
	var renter=$("#renter").val();  	    			    //���������� 
	var GiveDate=$HUI.datebox("#giveDate").getValue();      //�黹����
	var GiveTime=$HUI.timespinner('#giveTime').getValue();  //�黹ʱ��   	
	var GiveopUser=$("#giveNurse").val(); 				    //�黹������ 
    if(renter==""){
   		$.messager.alert("��ʾ","��������������Ϊ��");
   		return;
	}
    var renterTel=$("#renterTel").val();                    //��ϵ��ʽ 
    var cardType=($HUI.combobox("#cardType").getValue()==undefined?"":$HUI.combobox("#cardType").getValue());
    var cash=$("#cash").val();                              //�ֽ� 
    var cashNo=$("#cashNo").val();                          //�ֽ��� 
    var rentTool=($HUI.combobox("#rentTool").getValue()==undefined?"":$HUI.combobox("#rentTool").getValue());
	if((rentTool==null)||(rentTool=="")){
	   $.messager.alert("��ʾ","���ù��߲���Ϊ��");
	   return;
	}
    var nurse=$("#nurse").val();          				//���ò�����
    var giverUser=$("#giveUser").val();   				//�黹������
    var giveRelation=$("#giveRelation").val();  		//��ϵ
    
    if(!$("#giveUser").validatebox('isValid')){
	    $.messager.alert("��ʾ","�黹����������Ϊ��");
        return;
	}
    
    if((renter!=giverUser)&&(giveRelation=="")&&(giverUser!="")){
         //$.messager.alert("��ʾ","��ϵ����Ϊ��");
         //return;
    }
  
    var renterFlag=($HUI.combobox("#renterFlag").getValue()==undefined?"":$HUI.combobox("#renterFlag").getValue());  //״̬
  
    var RentList=rentTool+"^"+renterFlag+"^"+Date+"^"+Time+"^"+nurse+"^"+renter+"^"+renterTel+"^"+cardType+"^"+cash;
    RentList = RentList+"^"+cashNo+"^"+giverUser+"^"+giveRelation+"^"+rentid+"^"+GiveDate+"^"+GiveTime+"^"+GiveopUser;
    RentList = RentList+"^"+HospID;
    //���������Ʒ��Ϣ
    runClassMethod("web.DHCEmPatChkRList","saveRentList",{"RentList":RentList},function(jsonString){ 
		var ret = jsonString;
		if(ret==0){	    
			$.messager.alert("��ʾ","����ɹ�");
			$HUI.window("#widow").close();
	     	search(); 
		}else{
			if(ret==-100){
				$.messager.alert("��ʾ","�黹ʱ�䲻���������ʱ�䣡");
			}else{
				$.messager.alert("��ʾ","����ʧ��");
			}
		}
	});   
	    
}


function selectFirstItm(name,field){
	var Datas = $HUI.combobox(name).getData();
	$HUI.combobox(name).select(Datas[0][field])
	return;
}


function clearForm(){
	$("#giveRelation").removeAttr("disabled");
	$("#giveUser").removeAttr("disabled");
	$HUI.datebox("#giveDate",{disabled:false});
	$HUI.timespinner('#giveTime',{disabled:false});
	$HUI.datebox("#rentDate",{disabled:false});
	$HUI.timespinner('#rentTime',{disabled:false});
	$("#renterTel").removeAttr("disabled");
	$("#cardType").removeAttr("disabled");
	$("#cash").removeAttr("disabled");
	$("#cashNo").removeAttr("disabled");
	$HUI.combobox("#cardType",{disabled:false});
	$HUI.combobox("#rentTool",{disabled:false});
	$("#renter").removeAttr("disabled");
	$HUI.combobox("#renterFlag",{disabled:false});

}

//�����������
function clearFormData(){
	$("#renter").val("");
	$("#renterTel").val("");
	$HUI.combobox("#cardType").setValue("");
	$("#cash").val("");
	$("#cashNo").val("");
	$HUI.combobox("#rentTool").setValue("");
	$("#nurse").val("");
	$("#giveUser").val("");
	$("#giveRelation").val("");
	$HUI.combobox("#renterFlag").setValue("");
	$("#rentRowId").val("");
	$HUI.datebox("#rentDate").setValue("");
	$HUI.timespinner('#rentTime').setValue("");
	$HUI.datebox("#giveDate").setValue("");
	$HUI.timespinner('#giveTime').setValue("");
	$("#giveNurse").val("");	
	
	$(".hisui-validatebox").each(function(){
		$(this).validatebox("isValid");
	})
	return;
}

//��չ黹����Ϣ
function clearReturnInfo(){
	$HUI.datebox("#giveDate").setValue("");
	$HUI.timespinner('#giveTime').setValue("");
	$("#giveNurse").val("");
	$("#giveUser").val("");
	$("#giveRelation").val("");
}

//��������
function load(row){      	
	$("#renter").val(row.PCRRenter);
	$("#renterTel").val(row.PCRRenterTel);
	$HUI.combobox("#cardType").setValue(row.PCRCardType);
	$("#cash").val(row.PCRCash);
	$("#cashNo").val(row.PCRCashNo);
	$HUI.combobox("#rentTool").setValue(row.PCRRentDr);
	$("#nurse").val(row.PCROperator);
	$("#giveUser").val(row.PCRGiveUser);
	$("#giveRelation").val(row.PCRGiveRelation);
//	if(row.PCRFlag==$g("��")) row.PCRFlag=1;
//	if(row.PCRFlag==$g("��")) row.PCRFlag=2;
	$HUI.combobox("#renterFlag").setValue(row.PCRFlag);
	$("#rentRowId").val(row.rentRowId);
	$HUI.datebox("#rentDate").setValue(row.PCRDate);
	$HUI.timespinner('#rentTime').setValue(row.PCRTime);
	$HUI.datebox("#giveDate").setValue(row.PCRGiveDate);
	$HUI.timespinner('#giveTime').setValue(row.PCRGiveTime);
	$("#giveNurse").val(row.PCRGiveOpUser);
	
	$("#renter").validatebox('isValid')
	return;
}

//hxy 2022-12-08
function SetCell(value, rowData, rowIndex){
	var PCRFlag="";
	if(value==1){
		PCRFlag=$g("��");
	}else if(value==2){
		PCRFlag=$g("��");
	}
	var html = '<span/>'+PCRFlag+'</span>';
	return html;
}
