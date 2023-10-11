///****************************************
//*	Author: 		Sunhuiyong
//*	Create: 		2020/01/18
//*	Description:	�ٴ�֪ʶ�⣨��־ʵ�֣�
///****************************************
var DicName=""         //�ֵ�����
var dataName=""        //��¼��
var Operator=""        //������
var OperateDate=""     //��������
var OperateTime=""     //����ʱ��
var Scope=""           //������
var ScopeValue=""      //������ֵ
var SetFlag=""         //��� ����ͣ��/���
var HideFlag = ""	   //  ���ذ�ť��־
var ClientIPAddress = ""
var type = ""
var CloseFlag="";	   //�رմ��ڱ�ʶ sufna 2020-03-27 �������������ʱ����Ҫ���رպ͸����淽��
var TableName="";      //Sunhuiyong 20201110   ����   ����
/// ҳ���ʼ������
$(function(){
	InitCombobox(); //��ʼ��Combobox
	InitTime();     //��ʼ��ʱ���
	InitGetData();  //��ʼ�������Ϣ  �ֵ�����/��¼��/������
	InitTable();
	//alert(ClientIPAddress);

})

/// ��ʼ�����������Ϣ /�ֵ�����/��¼��/������
function InitGetData(){
	DicName = getParam("DicName");				//
	dataid = getParam("dataid");				//��¼id
	SetFlag = getParam("SetFlag");				//
	Operator = getParam("Operator");			//������
	HideFlag = getParam("HideFlag");			//���ذ�ť1�����أ�0��������
	ClientIPAddress = getParam("ClientIP");		//ip
	CloseFlag = getParam("CloseFlag");			//���ڹرձ�ʶ sufan 2020-03-27
	TableName = getParam("TableName");          //����
	type=getParam("type");          
	if (HideFlag==1){
		HideButton();
	}
	$("#dicid").val(DicName);
	$("#dataid").val(dataid);
	$("#operator").val(Operator);
	$('#dicname').attr('disabled',true);  //���������Ϊ����
	$('#dataname').attr('disabled',true); //���������Ϊ����
	$('#operator').attr('disabled',true); //���������Ϊ����
	//$HUI.validatebox("#dicname").isValid()
	//$HUI.validatebox("#dataname").isValid()
	//$HUI.validatebox("#operator").isValid()
	OperateDate=$("#operatedate").datebox('getValue');
	OperateTime=$("#operatetime").timespinner('getValue');
}

/// ���ݸ����ڵ��õı�־�����ذ�ť
function HideButton(){
	$("#SaveParrefData").hide();	
	$("#CloseWindow").hide();

}
//��ʼ��Combobox
function InitCombobox()
{      
	var scopeurl = 'dhcapp.broker.csp?ClassName=web.DHCCKBWriteLog&MethodName=GetScopeData'
	if ("undefined"!==typeof websys_getMWToken){
		scopeurl += "&MWToken="+websys_getMWToken(); 
	}
	//��ʼ��������
	$('#scope').combobox({
		url:scopeurl,
	    valueField: 'id',//���ֶ�ID
	    textField: 'text',//���ֶ�Name
	    onLoadSuccess:function(){
		    $('#scope').combobox('setValue',"G");		//Ĭ�ϰ�ȫ������sufan 20200314
		    Scope = "G";
		    var valueurl = 'dhcapp.broker.csp?ClassName=web.DHCCKBWriteLog&MethodName=GetScopeValueDate&type=G'
		    if ("undefined"!==typeof websys_getMWToken){
				valueurl += "&MWToken="+websys_getMWToken(); 
			}
		    $("#scopevalue").combobox( { 
				 url:valueurl,
				 valueField: 'id',//���ֶ�ID
	    		 textField: 'text',//���ֶ�Name
	    		 onLoadSuccess:function(){
		    		 if($("#scope").combobox('getValue')=="G"){
			    		 $('#scopevalue').combobox('setValue',LgGroupID);	
			    		  ScopeValue = LgGroupID;
			    	 }
		    	 }
			})
	   },onSelect: function (option) {
		   	Scope = option.id;
			var varSelect = Scope;
			//��ȡѡ�е�ֵ
			//var varSelect = $(this).combobox('getValue');								
			SAtypeID=varSelect;
			//$("#scopevalue").combobox('clear');//�������ֵ
			$("#scopevalue").combobox( { 
				url:'dhcapp.broker.csp?ClassName=web.DHCCKBWriteLog&MethodName=GetScopeValueDate&type='+SAtypeID+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"")
		})
		//Scope=$("#scope").combobox('getValue');
	}
})

//��ʼ��������ֵ
$('#scopevalue').combobox( {
    valueField: 'id',//���ֶ�ID
    textField: 'text',//���ֶ�Name
    onSelect: function (option) {
    	//ScopeValue=$("#scopevalue").combobox('getValue');
    	ScopeValue = option.id;
    }
   
})
}
function InitTable(){
	
	// ����columns   
	var columns=[[   	 
			{field:'ID',title:'ID',width:200,align:'left',hidden:'true'},
			{field:'DataID',title:'����',width:200,align:'left',hidden:'true'},
			{field:'Function',title:'����',width:400,align:'left',formatter: function(value,row,index){
				if (value=="stop")
				{
					return "ͣ��";
					
				} else if(value=="confirm")
				{
					return "��ʵ";	
				}else if(value=="grantAuth")
				{
					return "ҽԺ��Ȩ";
						
				}else if(value=="businessAuth")
				{
					return "ҵ����Ȩ";
						
				}else if(value=="enable")
				{
					return "����";	
				}else 
				{
					return value;	
				}
			}},
			{field:'DateTime',title:'����',width:300,align:'left'},
			{field:'TimeTime',title:'ʱ��',width:300,align:'left'},
			{field:'Scope',title:'������',width:300,align:'left',formatter: function(value,row,index){
				if (value=="U"){
					return "��Ա";
				} else if(value=="G")
				{
					return "��ȫ��";
					
				}else if(value=="L")
				{
					return "����"	
				}else if(value=="P")
				{
					return "ְ��"	
				}else
				{
					return "ȫԺ"	
				}
			}
		},
			{field:'ScopeValue',title:'������ֵ',width:300,align:'left'},
			{field:'UserID',title:"������",width:200,align:'left',hidden:true},
			{field:'UserName',title:"������",width:200,align:'left'},
			{field:'Operating',title:'����',width:200,align:'center',formatter:SetCellOperation} 	
		 ]]

	var option={
		bodyCls:'panel-header-gray',
		border:true,	
		height:"315",
		fit:false,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:10,
		pageList:[10,20,30],		
 		onClickRow:function(rowIndex,rowData){}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            
        },
        onLoadSuccess:function(data){
           
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBWriteLog&MethodName=GetStopDataList&DataID="+dataid+"&table="+DicName+"&FunctionInfo="+SetFlag;
	new ListComponent('stopdatainfo', columns, uniturl, option).Init();

}
//��ʼ��ʱ���
function InitTime()
{	
	$("#operatedate").datebox("setValue",SetDateTime("date"));
	$("#operatetime").timespinner("setValue",SetDateTime("time"));
}
function SetDateTime(flag)
{
	var result=""
	runClassMethod("web.DHCCKBWriteLog","GetDateTime",{"flag":flag},function(val){	
	  result = val
	},"text",false)
	return result;
}

/// ��ȡ����
function getParam(paramName){
	
    var paramValue = "";
    var isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=")>1){
        arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");
        var i = 0;
        while (i < arrSource.length && !isFound){
            if (arrSource[i].indexOf("=") > 0){
                 if (arrSource[i].split("=")[0].toLowerCase()==paramName.toLowerCase()){
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                 }
            }
            i++;
        } 
    }
   return paramValue;
}
function SaveDatas(){
	if(!Stable()){
		return;
	}   //����������
	if(console.log(dataid.search("^") == -1)){
			SaveData(); 
		}else{
			SaveManyDatas();
		}
	
}
//�����������
function SaveManyDatas()
{
	if(!Stable()){
		return false;
	}   
	var Result=""
	runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":Operator,"OperateDate":OperateDate,"OperateTime":OperateTime,"Scope":Scope,"ScopeValue":ScopeValue,"ClientIPAddress":ClientIPAddress,"Type":"acc"},function(getString){
	    if (getString == 0){
			Result = "�����ɹ���";
		}else
		{
			Result = "����ʧ�ܣ�";	
		}
	},'text',false);
	
	window.parent.$.messager.popover({msg: Result,type:'success',timeout: 1000});	
	
	if(CloseFlag==""){
		window.close();	
		window.opener.reloadDatagrid();

	}
	return Result;
		
}
function SaveData(){
	if(!Stable()){
		return;
	}               //����������
	var Result=""
	var Type="acc";
	runClassMethod("web.DHCCKBWriteLog","InsertLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":Operator,"OperateDate":OperateDate,"OperateTime":OperateTime,"Scope":Scope,"ScopeValue":ScopeValue,"ClientIPAddress":ClientIPAddress,"Type":Type},function(getString){
		if (getString == 0){
			Result = "�����ɹ���";
		}else
		{
			Result = "����ʧ�ܣ�";	
		}
	},'text',false);
	$.messager.popover({msg: Result,type:'success',timeout: 1000});
	window.close();
	window.opener.reloadDatagrid();
}

function Stable()
{
	var ScopeValueOther=$("#scopevalue").combobox('getValue');
	if((ScopeValueOther=="")||(ScopeValueOther==undefined))
	{
		$.messager.alert('��ʾ','��ѡ��������ֵ�������',"info");	
		return false;
	}
	var ScopeOther=$("#scope").combobox('getValue');
	if((ScopeOther=="")||(ScopeOther==undefined))
	{
		$.messager.alert('��ʾ','��ѡ��������������',"info")	;
		return false;
	}
	return true;
}
function CloseWindow()
{
	window.close();
}

///���ò�����ϸ����
function SetCellOperation(value, rowData, rowIndex){	
	var btn = "";
	if ((rowData.Function == "businessAuth")||(rowData.Function == "grantAuth")){
			var btn = "<a  class='icon icon-compare' style='color:#000;display:inline-block;width:16px;height:16px' title='ȡ����Ȩ' onclick=\"DeleteGrantAuth('"+rowData.ID+"')\" style='border:0px;cursor:pointer'></a>" 
	}
	return btn;  
}


// ȡ����Ȩ
function DeleteGrantAuth(logID)
{
	$.messager.confirm("��ʾ", "��ȷ��Ҫȡ����Ȩ��", function (res) {	// ��ʾ�Ƿ�ɾ��
		
		if (res){
			runClassMethod("web.DHCCKBWriteLog","DeleteGrantAuth",{"logID":logID},function(getString){
				if (getString == 0){
					Result = "�����ɹ���";
					$('#stopdatainfo').datagrid('reload'); //���¼���
				}else
				{
					Result = "����ʧ�ܣ�";	
				}
			},'text',false);
			$.messager.popover({msg: Result,type:'success',timeout: 1000});		
		}else{
			return;	
		}
		
	});

}
	
