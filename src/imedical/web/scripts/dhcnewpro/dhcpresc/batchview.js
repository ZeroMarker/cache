var patType = "";
//ҳ���ʼ������
function initPageDefault(){
	
	initParams();
	initPresctList();			//��ʼ�������б�
	initProblemType();			//��ʼ������������
	initDrugList();				//��ʼ��ҩƷ�б�������
	initButton();				//��ʼ����ť
	initDateBox();				//��ʼ����ѯ����
	
}

function initParams(){
	
	patType = getParam("MenuModule");   /// ����
}

//��ʼ�������б�
function initPresctList(){
	
	var columns=[[
		{field:'check',title:'sel',checkbox:true},
		{title:'����ID',field:"auditID",width:120,align:"left",hidden:'true'},
		{title:'����ID',field:"patientID",width:120,align:"left",hidden:'true'},
		{title:'����ID',field:"admID",width:120,align:"left",hidden:'true'},
		{title:'�����',field:"admNo",width:120,align:"left"},
		{title:'��������',field:"patName",width:120,align:"left"},
		{title:'�Ա�',field:"patSex",width:80,align:"left"},
		{title:'����',field:"patAge",width:80,align:"left"},
		{title:'���',field:"diagnos",width:160,align:"left"},
		{title:'��ʶ',field:"manLevel",width:100,align:"left",
			styler:function(value,row,index){
				return switchWarn(value,row,index)
				}
			},
		{title:'����ʱ��',field:"creteDatetime",width:180,align:"left"},
		{title:'��������',field:"locDesc",width:100,align:"left"},
		{title:'����ҽ��',field:"docDesc",width:100,align:"left"},
		{title:'�����',field:"pharDesc",width:100,align:"left"},
		{title:'���״̬',field:"status",width:120,align:"left"},
		{title:'�������',field:"reason",width:160,align:"center"},
		{title:'ҩʦ��ע',field:"remark",width:160,align:"center"},
	]];
	
	var option={
		rownumbers : false,
		singleSelect : false,
		onDblClickRow:function(rowIndex,rowData){
			var auditID = rowData.auditID;
			var patientID = rowData.patientID
			var admID = rowData.admID
			var url="dhcpresc.auditdetail.csp?";
			if ('undefined'!==typeof websys_getMWToken){
				url += "&MWToken="+websys_getMWToken();
			}
			url += "&auditID="+auditID+"&patientID="+patientID+"&admID="+admID
			var detail = window.open(url,"_blank",'dialogTop:50;dialogWidth:1250px;DialogHeight=600px;center=1');	
		}
	}
	var handStaus = $("input[name='handle']:checked").val();
	handStaus = (handStaus == undefined) ? "" : handStaus;
	var params = "^^^^^"+ handStaus +"^"+patType;
	var uniturl = $URL+"?ClassName=web.DHCPRESCList&MethodName=GetBatchPrescList&params="+encodeURI(params);
	new ListComponent('prescList', columns, uniturl, option).Init();
}

//�жϴ�������״̬
function switchStatus(value,row,index){
	
	switch(value){
		
		case "0":
			value = "������";
			break;
		case "1":
			value = "��ȷ��";
			break;
		case "2":
			value = "�����޸�";
			break;	
	}
	
	return value;
		
}

//�жϱ�ʶ
function switchWarn(value,row,index){

	switch(value){
		
		case "��ֹ":;
			css = "color:white;bold;background-color:#2F4F4F"
			break;
		case "��ʾ":
			css = "color:white;bold;background-color:#FA8072"
			break;
		case "����":
			css = "color:white;bold;background-color:orange"
			break;	
		case "��ʾ":
			css = "color:white;bold;background-color:green"
			break;
		default:
			css = ""
			break;
	}

	return css;
		
}

//��ʼ������������
function initProblemType(){
	
	var uniturl = $URL+"?ClassName=web.DHCPRESCCommonUtil&MethodName="  

	$HUI.combobox("#problemtype",{
		url:uniturl+"QueryDicItem&code=RIT&hospId="+LgHospID,
		valueField:'value',
		textField:'text',
		panelHeight:"200",
		mode: 'local',
		filter: function(q, row){
	 		var opts = $(this).combobox('options');
	 		return row[opts.textField].indexOf(q)>-1;
		},
		onSelect:function(ret){
			
		 }
	})	
}

//��ʼ��ҩƷ�б�������
function initDrugList(){
	
	var uniturl = $URL+"?ClassName=web.DHCPRESCList&MethodName="  

	$HUI.combobox("#druglist",{
		url:uniturl+"GetDrugList",
		valueField:'value',
		textField:'text',
		panelHeight:"200",
		mode: 'local',
		filter: function(q, row){
	 		var opts = $(this).combobox('options');
	 		return row[opts.textField].indexOf(q)>-1;
		},
		onSelect:function(ret){	
		 }
	})
	
}

//��ʼ����������������
function initProblemType(){
	
	var uniturl = $URL+"?ClassName=web.DHCPRESCList&MethodName="  

	$HUI.combobox("#problemtype",{
		url:uniturl+"GetProblemType",
		valueField:'value',
		textField:'text',
		panelHeight:"200",
		mode: 'local',
		filter: function(q, row){
	 		var opts = $(this).combobox('options');
	 		return row[opts.textField].indexOf(q)>-1;
		},
		onSelect:function(ret){	
		 }
	})
	
}


//��ʼ����ť
function initButton(){
	
	/*/��ղ��������
	$("#resetPatno").bind("click",function(){
		$("#patno").val("");	
	});
	
	//�������������
	$("#resetAdmno").bind("click",function(){
		$("#admno").val("");	
	});*/
	
	//��ѯ��ť
	$("#query").bind("click",queryPresc);
	
	//ͨ����ť
	$("#batchpass").bind("click",function(){batchPass("����ͨ��","STA04")});
	
	//˫ǩ��ť
	$("#dbbatchpass").bind("click",function(){batchPass("����˫ǩͨ��","STA03")});
	
	//�ܾ���ť
	$("#batchnopass").bind("click",function(){batchPass("���������޸�","STA01")});
	
}
//����ͨ��Action
function batchPass(mark,code)
{
	
	var selItems = $("#prescList").datagrid('getSelections');
	if(selItems.length==0)
	{
		$.messager.alert('��ʾ',"��ѡ��Ҫ����Ĵ�����","warning");
		return false;
	}
	var listDataStr=""
	var itemId = ""   //$HUI.combobox("#inselitm").getValue();		//���¼����Ŀ
	var remark = mark						//��ע
	var readCode = 0;
	var stateCode = code   					//ͨ��
	for(var i=0;i<selItems.length;i++)
	{
		var listData = selItems[i].auditID +"^"+ itemId +"^"+ LgUserID +"^"+ stateCode +"^"+ readCode +"^"+ remark;
		if(listDataStr=="")
		{
			listDataStr=listData	
		}else
		{
			listDataStr=listDataStr+"$$"+listData	
		}
	}
	runClassMethod(
		"web.DHCPRESCAudit",
		"saveAuditsInfo",
		{
			"listDataStr":listDataStr
		},
		function(ret){
			if(ret.split("^")[0]==0){
				if(ret.split("^")[1]!=0){
					if(selItems.length == ret.split("^")[1]){
						$.messager.alert('��ʾ',"��ѡ�������������ɣ���ѡ��δ������ݴ���","info");
					}else{
						$.messager.alert('��ʾ',"����ɹ�"+selItems.length-ret.split("^")[1]+"������˼�¼������"+ret.split("^")[1]+"����¼���������ˣ�","info");
					}
					
					queryPresc();
				}else{
					$.messager.alert('��ʾ',"����ɹ���","info");
					queryPresc();
				}
			
				return;
			}else{
				$.messager.alert('��ʾ',"����ʧ�ܣ�"+ret,"error");
				return;
			}
		}
	,'text');	
}


//��ѯ����
function queryPresc(){
	
	var patno = ""
	var admno = ""
	var problemtype = $HUI.combobox("#problemtype").getText();
	var drug = ""
	var manlevel = $("input[name='manlevel']:checked").val();
	manlevel =  (manlevel == undefined) ? "" : manlevel;
	var handStaus = $("input[name='handle']:checked").val();
	handStaus = (handStaus == undefined) ? "" : handStaus;
	var params = patno + "^" + admno + "^" + manlevel + "^" + problemtype + "^" + drug  + "^" + handStaus;
	var params = params +"^" + patType;
	$("#prescList").datagrid("load",{"params":params})
}

//��ʼ�����ڿ�
function initDateBox(){
	$HUI.datebox("#stDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })