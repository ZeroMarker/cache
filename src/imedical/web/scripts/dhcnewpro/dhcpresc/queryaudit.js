
//ҳ���ʼ������
function initPageDefault(){
	
	initDateBox();				//��ʼ����ѯ����
	initPresctList();			//��ʼ�������б�
	initProblemType();			//��ʼ������������
	initDrugList();				//��ʼ��ҩƷ�б�������
	initButton();				//��ʼ����ť
	
	
}

//��ʼ�������б�
function initPresctList(){
	
	var columns=[[
		
		{title:'����ID',field:"auditID",width:160,align:"left",hidden:'true'},
		{title:'����ID',field:"patientID",width:160,align:"left",hidden:'true'},
		{title:'����ID',field:"admID",width:160,align:"left",hidden:'true'},
		{title:'�����',field:"admNo",width:160,align:"left",formatter:linkPrescDetail},
		{title:'��������',field:"patName",width:160,align:"left"},
		{title:'�Ա�',field:"patSex",width:80,align:"left"},
		{title:'����',field:"patAge",width:160,align:"left"},
		{title:'���',field:"diagnos",width:160,align:"left"},
		{title:'��ʶ',field:"manLevel",width:80,align:"left",
			styler:function(value,row,index){
				return switchWarn(value,row,index)
				}
			},
		{title:'������',field:"prescNo",width:160,align:"left"},
		{title:'��������',field:"locDesc",width:160,align:"left"},
		{title:'����ҽ��',field:"docDesc",width:160,align:"left"},
		{title:'���ҩʦ',field:"pharDesc",width:160,align:"left"},
		{title:'���״̬',field:"status",width:160,align:"left"},
		{title:'���ԭ��',field:"reason",width:160,align:"left"},
		{title:'ҩʦ��ע',field:"remark",width:160,align:"left"},
		{title:'ҽ������',field:"appealtext",width:160,align:"left"}
	]];
	
	var option={
		rownumbers : false,
		singleSelect : true,
		onDblClickRow:function(rowIndex,rowData){
			var auditID = rowData.auditID;
			var patientID = rowData.patientID
			var admID = rowData.admID;
			
		}
	}
	var stDate = $HUI.datebox("#stDate").getValue();
	var endDate = $HUI.datebox("#endDate").getValue();	
	var params = stDate +"^"+ endDate;
	var uniturl = $URL+"?ClassName=web.DHCPRESCList&MethodName=GetPrescList&params="+params;
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
			var css = "color:#000000;"
			css = css + "background-color:#ECECEC"
			break;
		case "��ʾ":
			var css = "color:white;"
			css = css + "background-color:red"
			break;
		case "����":
			var css = "color:white;"
			css = css + "background-color:orange"
			break;	
		case "��ʾ":
			var css = "color:white;"
			css = css + "background-color:green"
			break;
		default:
			var css = "color:black;"
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
	
	var uniturl = $URL+"?ClassName=web.DHCPRESCCommonUtil&MethodName="  

	$HUI.combobox("#druglist",{
		url:uniturl+"QueryDrugList&hospId="+LgHospID,
		valueField:'value',
		textField:'text',
		panelHeight:"200",
		mode: 'remote',
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
	});*/
	
	//�������������
	$('#patno').keydown(function(e){
		if(e.keyCode==13){
			var inPatNo = $('#patno').val();
			var patNo = GetWholePatNo(inPatNo);
			$('#patno').val(patNo);
		}
	})
	//��ѯ��ť
	$("#query").bind("click",queryPresc);
	
}

//��ѯ����
function queryPresc(){
	
	var stDate = $HUI.datebox("#stDate").getValue();
	var endDate = $HUI.datebox("#endDate").getValue();	
	
	
	
	var inPatNo = $('#patno').val();
	var patNo = GetWholePatNo(inPatNo);
	$('#patno').val(patNo);
	var patno =  $('#patno').val();
			
	var admno = $("#admno").val();
	var problemtype = $HUI.combobox("#problemtype").getText();
	var drug = $HUI.combobox("#druglist").getText();
	var manlevel = $("input[name='manlevel']:checked").val();
	
	manlevel =  (manlevel == undefined) ? "" : manlevel
	
	var params = stDate + "^" + endDate + "^" +patno + "^" + admno + "^" + manlevel + "^" + problemtype + "^" + drug+"^"+LgUserID;
	console.log(params)
	
	$("#prescList").datagrid("load",{"params":params})
}
//����
function commonExport(){
	runClassMethod("web.DHCPRESCList","GetPrescPrtList",{"UserID":LgUserID},function(retData){
		exportExecl(retData);
	})		
}

function exportExecl(data){
	debugger;
	var stDate = $HUI.datebox("#stDate").getValue(); 				/// ��ʼ����
	var endDate = $HUI.datebox("#endDate").getValue();     			/// ��������
	if(!data.length){
		$.messager.alert("��ʾ","�޵������ݣ�","warning");
		return;	
	}
	var Str = "(function test(x){"+
	"var xlApp = new ActiveXObject('Excel.Application');"+
	"var xlBook = xlApp.Workbooks.Add();"+
	"var objSheet = xlBook.ActiveSheet;"+
	"xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,32)).MergeCells = true;"+ //�ϲ���Ԫ��
	"objSheet.cells(1,1).Font.Bold = true;"+
	"objSheet.cells(1,1).Font.Size =24;"+
	"objSheet.cells(1,1).HorizontalAlignment = -4108;"+
	"objSheet.Cells(1,1).value='ͳ��ʱ��:"+stDate+"��"+endDate+"';";
	var beginRow=2;
	Str=Str+"objSheet.Cells(2,1).value='����';"+ 
	"objSheet.Cells(2,2).value='�Ա�';"+
	"objSheet.Cells(2,3).value='����';"+
	"objSheet.Cells(2,4).value='���';"+
	"objSheet.Cells(2,5).value='��������';"+
	"objSheet.Cells(2,6).value='������Ϣ';"+	 
	"objSheet.Cells(2,7).value='������ҩ��ʾ����';"
	for (var i=0;i<data.length;i++){
		Str=Str+"objSheet.Cells("+(i+beginRow+1)+","+1+").value='"+data[i].PatName+"';"+       
		"objSheet.Cells("+(i+beginRow+1)+","+2+").value='"+data[i].PatSex+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+3+").value='"+data[i].PatAge+"';"+      
		"objSheet.Cells("+(i+beginRow+1)+","+4+").value='"+data[i].Diadata+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+5+").value='"+data[i].Loc+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+6+").value='"+data[i].PrescData+"';"+  
		"objSheet.Cells("+(i+beginRow+1)+","+7+").value='"+data[i].CkbData+"';"
	}
	var row1=beginRow,row2=data.length+beginRow,c1=1,c2=7;
	Str=Str+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;"+
	"xlApp.Range(xlApp.Cells(1,13),xlApp.Cells("+data.length+beginRow+",13)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,14),xlApp.Cells("+data.length+beginRow+",14)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,15),xlApp.Cells("+data.length+beginRow+",15)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,16),xlApp.Cells("+data.length+beginRow+",16)).WrapText = true;"+
	"xlApp.Visible=true;"+
	"objSheet.Columns.AutoFit;"+
	"xlApp=null;"+
	"xlBook=null;"+
	"objSheet=null;"+
	"return 1;}());";
	 //����Ϊƴ��Excel��ӡ����Ϊ�ַ���
	 debugger;
    CmdShell.notReturn = 1;   //�����޽�����ã�����������
	var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
	return;	
}

//��ʼ�����ڿ�
function initDateBox(){
	$HUI.datebox("#stDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}

function linkPrescDetail(value, rowData, rowIndex)
{
	var html = "<a href='#' onclick=\"OpenEditWin('"+rowData.auditID+"','"+rowData.patientID+"','"+rowData.admID+"','"+rowData.mradm+"')\">"+rowData.admNo+"</a>";

 	return html; 
}
function OpenEditWin(auditId,patientId,admId,mradm)
{  
		var width = (document.documentElement.clientWidth-100);
		var height = (document.documentElement.clientHeight-100);
		var url="dhcpresc.auditdetail.csp?&auditID="+auditId+"&patientID="+patientId+"&admID="+admId+"&mradm="+mradm;
		websys_showModal({
			url: url,
			width:width,
			height:height,
			top:(document.documentElement.clientWidth-width)/2,
			left:(document.documentElement.clientHeight-height)/2,
			iconCls:"icon-w-paper",
			title: '�������',
			closed: true,
			onClose:function(){
				
			}
		});
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

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
