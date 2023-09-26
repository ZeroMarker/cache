var PageLogicObj = {
	version:"V8.0",
	ClassName:"DHCDoc.Interface.Outside.Config",
    GroupRowId:""
}
var arrayObj1=new Array(
      new Array("Check_UsePAPMINoToCard","UsePAPMINoToCard"),
      new Array("Check_HisCreateCardNo","HisCreateCardNo"),
	  new Array("Check_NotUseLockReg","NotUseLockReg"),
	  new Array("Check_LockNotAllowAdd","LockNotAllowAdd"),
	  new Array("Check_InsuPatSelfPayReg","InsuPatSelfPayReg"),
	  new Array("Check_AppReg","AppReg"),
	  new Array("OutRegStartTime","OutRegStartTime"),
	  new Array("OutRegEndTime","OutRegEndTime"),
	  new Array("Check_AllowRelateCard","AllowRelateCard"),
	  new Array("Check_LockUseTimeRange","LockUseTimeRange"),
	  new Array("Check_InsuReg","InsuReg"),
	  new Array("Check_UseDataCompare","UseDataCompare")
)

var arrayObj2=new Array(
  new Array("List_SelfAdmReason","SelfAdmReason"),
  new Array("List_AppRegMethod","AppRegMethod"),
  new Array("List_GetPatientIDRule","GetPatientIDRule"),
  new Array("List_BarCardType","BarCardType")
);

var arrayObj3=new Array(
  new Array("Text_LockActiveTime","LockActiveTime")
);

var arrayObj4=new Array(
  new Array("List_CardType","CardType"),
  new Array("List_IDCardType","IDCardType"),
  new Array("List_ExtUserID","ExtUserID"),
  new Array("List_AdmReason","AdmReason")
);

function Init(){
	InitGroupList();	
	InitDefaultData();
	for( var i=0;i<arrayObj2.length;i++) {
		var param1=arrayObj2[i][0];
		var param2=arrayObj2[i][1];
		InitList(param1,param2);	    
	}
	
	InitEvent();
	document.onkeydown = Doc_OnKeyDown;
}

function InitEvent(){
	//�����¼�
	$("#BSave").click(function(){
		SaveClick();
	});

	//�����¼�
	$("#BSaveDefault").click(function(){
		SaveDefaultClick();
	});

	$("#BReadMe").click(function(){
		var url="dhcdoc.interface.outside.configexp.hui.csp";
		var OpenWindow=window.open(url,"��������","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width="+800+",height="+600+",top="+100+"");         
		OpenWindow.focus(); 
	});	
}

function InitGroupList(){
	$HUI.combobox('#List_SSGroup',{      
    	valueField:'RowId',   
    	textField:'Code',
    	//editable:false,
    	page:1,  
		rows:999,
    	url:$URL+"?ClassName=DHCDoc.Interface.Outside.Config&QueryName=FindList&value=SSGroup"+"&ResultSetType=array",
    	onLoadSuccess:function(){
			var sbox = $HUI.combobox("#List_SSGroup");
			sbox.clear();
		},onSelect:function(){
			PageLogicObj.GroupRowId="";
			var boxvalue=$('#List_SSGroup').combobox('getValue');
			if((boxvalue!="undefined")&&(boxvalue!="")){
				PageLogicObj.GroupRowId = $('#List_SSGroup').combobox('getValue'); 
			}else{
				$.messager.alert("����","��ȫ��ID������ȡ����");
				return false;	
			} 
			InitData();
		}
	});	
}

function InitDefaultData(){
	for( var i=0;i<arrayObj4.length;i++) {
		var param1=arrayObj4[i][0];
		var param2=arrayObj4[i][1];
		InitList1(param1,param2);	    
	}
}

function InitList1(param1,param2)
{
	$HUI.combobox("#"+param1+"",{      
    	valueField:'RowId',   
    	textField:'Code',
    	//editable:false,
    	rows:999,
    	url:$URL+"?ClassName=DHCDoc.Interface.Outside.Config&QueryName=FindList&value="+param2+"&GroupRowId="+""+"&ResultSetType=array",
    	onLoadSuccess:function(){
			var sbox = $HUI.combobox("#"+param1+"");
			sbox.clear();
			var Data=sbox.getData();
			for (var i=0;i<Data.length;i++){
				if(Data[i].selected==1){
					sbox.select(Data[i].RowId);
					break;	
				}
			}
		}
	});
}


function InitData(){
	if(PageLogicObj.GroupRowId==""){
		$.messager.alert("����","��ȫ��ID������ȡ����");
		return false;
	}
	for( var i=0;i<arrayObj2.length;i++) {
		var param1=arrayObj2[i][0];
		var param2=arrayObj2[i][1];
		InitList(param1,param2);	    
	}
	//���е�checkbox radioԪ�س�ʼ�� 
	for( var i=0;i<arrayObj1.length;i++) {
		var param1=arrayObj1[i][0];
		var param2=arrayObj1[i][1];
		LoadCheckData(param1,param2);	    
	}
	//����textԪ�س�ʼ��
	for( var i=0;i<arrayObj3.length;i++) {
		var param1=arrayObj3[i][0];
		var param2=arrayObj3[i][1];
		LoadTextData(param1,param2);	    
	}	
}

function LoadTextData(param1,param2)
{
	if(PageLogicObj.GroupRowId!=""){
		var ObjRet=$.cm({
			ClassName:PageLogicObj.ClassName,
			MethodName:"getDefaultData",
			value:PageLogicObj.GroupRowId,
			value2:param2
		},false)
		if(ObjRet!=""){
			$("#"+param1+"").val(ObjRet.result);	
		}
	}
}

function InitList(param1,param2)
{
	if(PageLogicObj.GroupRowId!=""){
		$HUI.combobox("#"+param1+"",{      
	    	valueField:'RowId',   
	    	textField:'Code',
	    	editable:false,
	    	rows:999,
	    	url:$URL+"?ClassName=DHCDoc.Interface.Outside.Config&QueryName=FindList&value="+param2+"&GroupRowId="+PageLogicObj.GroupRowId+"&ResultSetType=array",
	    	onLoadSuccess:function(){
				var sbox = $HUI.combobox("#"+param1+"");
				sbox.clear();
				var Data=sbox.getData();
				for (var i=0;i<Data.length;i++){
					if(Data[i].selected==1){
						sbox.select(Data[i].RowId);
						break;	
					}
				}
			}
		});
	}else{
		$HUI.combobox("#"+param1+"",{})	
	}
}

function LoadCheckData(param1,param2)
{
	if(PageLogicObj.GroupRowId!=""){
		var objScope=$.cm({
			ClassName:PageLogicObj.ClassName,
			MethodName:"getDefaultData",
			value:PageLogicObj.GroupRowId,
			value2:param2
		},false)
		if(objScope!=""){
			$("#"+param1+"").val(objScope.result);
			if((param1=="OutRegStartTime")||(param1=="OutRegEndTime")){
				$("#"+param1+"").val(objScope.result);	
			}else{
				if(objScope.result==1){
					$HUI.checkbox("#"+param1).setValue(true);
				}else{
					$HUI.checkbox("#"+param1).setValue(false);
				}
			}	
		}
	}
}

function SaveClick()
{
	if(PageLogicObj.GroupRowId==""){
		$.messager.alert("����","��ѡ��ȫ��");
		return false;
	}
	var DataList="";
	//���е�check radio�ı���
	for( var i=0;i<arrayObj1.length;i++) {
		   var param1=arrayObj1[i][0];
		   var param2=arrayObj1[i][1];
	       var CheckedValue=0;
	       
		   if((param1=="OutRegStartTime")||(param1=="OutRegEndTime")){
			    var CheckedValue= $("#"+param1+"").val();
			    var time=/^([0-1][0-9]|[2][0-3]):([0-5][0-9])$/ 
			    if ((CheckedValue!="")&&(time.test(CheckedValue) != true)) {
		          $.messager.alert("��ʾ", "ʱ���ʽ����ȷ", "error");
				  return false;
				}
		   }else{
			    var cbox=$HUI.checkbox("#"+param1+"");
				if ((cbox)&&(cbox.getValue())) {
	         		CheckedValue=1;
           		}   
		  }
          if(DataList=="") DataList=param2+String.fromCharCode(1)+CheckedValue;
		  else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+CheckedValue;		  
   	}
	
	for( var i=0;i<arrayObj2.length;i++) {
		   var param1=arrayObj2[i][0];
		   var param2=arrayObj2[i][1];
	       var value=$("#"+param1+"").combobox("getValue") 
	       if (!CheckComboValue(param1,"RowId")) return false;
		   if(DataList=="") DataList=param2+String.fromCharCode(1)+value
		   else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+value
		   
   	}
   	for( var i=0;i<arrayObj3.length;i++) {
		   var param1=arrayObj3[i][0];
		   var param2=arrayObj3[i][1];
	       var value=$("#"+param1+"").val();
		   if(DataList=="") DataList=param2+String.fromCharCode(1)+value
		   else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+value
		   
   	}
   	var rtn=$.cm({
		ClassName:PageLogicObj.ClassName,
		MethodName:"SaveConfig",
		Coninfo:DataList,
		Node1:PageLogicObj.GroupRowId,
		dataType:"text"
	},false)
	if(rtn=="0"){
		 $.messager.show({title:"��ʾ",msg:"����ɹ�"});	
		 return false;
	}
}


function SaveDefaultClick(){
	var DataList="";
	for( var i=0;i<arrayObj4.length;i++) {
		   var param1=arrayObj4[i][0];
		   var param2=arrayObj4[i][1];
	       var value=$("#"+param1+"").combobox("getValue");
	       if (!CheckComboValue(param1,"RowId")) return false;
		   if(DataList=="") DataList=param2+String.fromCharCode(1)+value
		   else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+value
		   
   	}
   	//alert(DataList)
   	var rtn=$.cm({
		ClassName:"DHCExternalService.RegInterface.GetRelate",
		MethodName:"SetDefaultData",
		Coninfo:DataList,
		dataType:"text"
	},false)
	if(rtn=="0"){
		 $.messager.show({title:"��ʾ",msg:"����ɹ�"});	
		 return false;
	}
}

function Doc_OnKeyDown(e){
	//��ֹ�ڿհ״����˸���������Զ����˵���һ������
	if (!websys_cancelBackspace(e)) return false;
	//�������Backspace������  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;   
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }  
    if (e){
        var ctrlKeyFlag=e.ctrlKey;
    }else{
        var ctrlKeyFlag=window.event.ctrlKey;
    }
    if (ctrlKeyFlag){
        if (event.keyCode == 83){ //����ҽ��
            UpdateClickHandler();
        }
        return false;
	}
}

function CheckComboValue(id,CombValue)
{
	var NodeName=$("#"+id).prev().text();
	var Text=$("#"+id).combobox('getText');
	if(Text==""){return true}
	var Value=$("#"+id).combobox('getValue');
	if(Value=="") {
		$.messager.alert('��ʾ',NodeName+' ����Ϊ��,������ѡ��');
		return false;
	}
	var DataArr=$("#"+id).combobox('getData');
	var i=0;
	for(i=0;i<DataArr.length;i++){
		var cmd="var val=DataArr[i]."+CombValue;
		eval(cmd);
		if(val==Value) break;
	}
	if(i<DataArr.length) return true;
	$.messager.alert('��ʾ',NodeName+' ֵ��Ч,������ѡ��!',"info",function(){
		$('#'+id).next('span').find('input').focus();
	});
	return false;
}