
$(function(){
	/// ��ʼ�����ز��˾���ID
	initParams();
	
	initDateBox();
	
	initCombobox();
	
	initTable();
	
})

function initParams(){
	///�Ƿ�HOSOPEN
	HOSOPEN = getParam("hosOpen");	
	
	SEEORDTYPE = getParam("seeOrdType");
}

function initDateBox(){
	$HUI.datebox("#StartDate").setValue(formatDate(-2));
	$HUI.datebox("#EndDate").setValue(formatDate(0));	
}

function initCombobox(){
	$HUI.combobox("#KeptLoc",{
		url:LINK_CSP+"?ClassName=web.DHCEMDocMainOutPat&MethodName=jsonListWard&HospID="+session['LOGON.HOSPID'],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			$("#QytType").combobox("setValue","Obs");
			$HUI.checkbox("#PatEpiYes").setValue(true);
	        qryEmPatList();
	    }	
	})
	
	///�������
	$HUI.combobox("#AdmLoc",{
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatLoc&HospID="+session['LOGON.HOSPID'],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			$("#QytType").combobox("setValue","Obs");
			$HUI.checkbox("#PatEpiYes").setValue(true);
	        qryEmPatList();
	    }	
	})	
	
	
	$HUI.combobox("#OrdType",{
		data:[
			{"value":"jyd","text":"���鵥"},//hxy 2020-02-21 ԭ��1 2 3 4
			{"value":"psd","text":"Ƥ�Ե�"},
			{"value":"syd","text":"��Һ��"},
			{"value":"zld","text":"���Ƶ�"},
			{"value":"kfd","text":"�ڷ���"},
			{"value":"jcd","text":"��鵥"},
			{"value":"zsd","text":"ע�䵥"},
			{"value":"sxd","text":"��Ѫ��"}
		],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       qryEmPatList();
	    }	
	})
	SEEORDTYPE?$HUI.combobox("#OrdType").setValue(SEEORDTYPE):"";
	
	$HUI.combobox("#CheckLev",{
		data:[
			{"value":"1","text":"��"},//hxy 2020-02-21 ԭ��1 2 3 4
			{"value":"2","text":"��"},
			{"value":"3","text":"��"},
			{"value":"4","text":"��a��"},
			{"value":"5","text":"��b��"} //ed
		],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       qryEmPatList();
	    }	
	})	
	
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=";
	/// ������  �����͵�combobox��onSelect�¼���
	var option = {
		panelHeight:"auto",
		onSelect:function(option){
	        var CardTypeDefArr = option.value.split("^");
	        m_CardNoLength = CardTypeDefArr[17];
	        m_CCMRowID = CardTypeDefArr[14];
	        
	        if (CardTypeDefArr[16] == "Handle"){
		    	$('#EmCardNo').attr("readOnly",false);
		    }else{
				$('#EmCardNo').attr("readOnly",true);
			}
			$('#EmCardNo').val("");  /// �������
	    }
	};
	var url = uniturl+"CardTypeDefineListBroker";
	new ListCombobox("EmCardType",url,'',option).init();
	
	/// �ǼǺ�/����/���� �س��¼�
	$("#TmpCondition").bind('keypress',TmpCon_KeyPress);
	
	/// ���� �س��¼�
	$("#EmCardNo").bind('keypress',EmCardNo_KeyPress);
	
}

function initTable(){
	
	var columns=[[
		{field:'admPriority',title:'��ǰ�ּ�',width:70,align:'center',formatter:setCellPAAdmPriority},
		{field:'emNurLev',title:'��ʼ�ּ�',width:70,align:'center',formatter:setCellLevLabel},
		{field:'patNo',title:'�ǼǺ�',width:120},
		{field:'patName',title:'����',width:100},
		{field:'patSex',title:'�Ա�',width:60,align:'center'},
		{field:'patAge',title:'����',width:70,align:'center'},
		{field:'arciName',title:'ҽ������',width:120},
		{field:'sttDate',title:'��ҽ������',width:120},
		{field:'sttTime',title:'��ҽ��ʱ��',width:120},
		{field:'ctcpDesc',title:'��ҽ����',width:120},
		{field:'emPCLvArea',title:'����',width:60,align:'center',styler:setCellAreaLabel},
		{field:'admLoc',title:'�������',width:120},
		{field:'admDoc',title:'����ҽ��',width:120},
		{field:'admWard',title:'����',width:120,align:'center'},					 //+
		{field:'admBed',title:'����',width:80,align:'center'},                     //+
		{field:'diagnosis',title:'���',width:190,align:'center'},
		{field:'admDate',title:'��������',width:120,align:'center'},
		{field:'admTime',title:'����ʱ��',width:120,align:'center'},				 //+
		{field:'title',title:'״̬',width:80,align:'center'},				     //+
		{field:'regDoctor',title:'�ű�',width:120,align:'center'},
		{field:'billType',title:'��������',width:80,align:'center'},
		{field:'emPatGreFlag',title:'��ɫͨ��',width:70,align:'center',formatter:setCellGreenLabel},
		{field:'emPCLvNurse',title:'���ﻤʿ',width:100},
		{field:'admId',title:'EpisodeID',width:100,align:'center'},
		
	]];
	
	///  ����datagrid
	var option = {
		fit:true,
		toolbar:'#container',
		headerCls:'panel-header-gray',
		rownumbers : false,
		singleSelect : true,
		pagination: true,
		onClickRow:function(rowIndex, rowData){
		
	    },
		onLoadSuccess:function(data){
			
			
		},
	    onDblClickRow: function (rowIndex, rowData) {
		  
		  	hosSetPatient({
			  	hosOpen:HOSOPEN,
				EpisodeID:rowData.admId,
				PatientID:rowData.patientId
			})
		  
        }
	};
	/// ��������
	var params = getParams();;
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMNurMessageInterface&MethodName=ordTypeNumber&model=1&params="+params;
	new ListComponent('patList', columns, uniturl, option).Init(); 
}

/// �ǼǺ�/����/���� �س��¼�
function TmpCon_KeyPress(e){

	if(e.keyCode == 13){
		var TmpCondition = $("#TmpCondition").val();
		if (!TmpCondition.replace(/[\d]/gi,"")&(TmpCondition != "")){
			///  �ǼǺŲ�0
			TmpCondition = GetWholePatNo(TmpCondition);
			$("#TmpCondition").val(TmpCondition);
		}
		qryEmPatList();
	}
}


///  ���Żس�
function EmCardNo_KeyPress(e){

	if(e.keyCode == 13){
		var CardNo = $("#EmCardNo").val();
		if (CardNo == "") return;
		var CardNoLen = CardNo.length;
		if((m_CardNoLength!="")&&(m_CardNoLength!=0)){
			if (m_CardNoLength < CardNoLen){
				$.messager.alert("��ʾ:","�����������,������¼�룡");
				return;
			}

			/// ���Ų���λ��ʱ��0
			for (var k=1;k<=m_CardNoLength-CardNoLen;k++){
				CardNo="0"+CardNo;  
			}
		}
		
		$("#EmCardNo").val(CardNo);
		qryEmPatList();
	}
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


function setCellPAAdmPriority(value, rowData, rowIndex){
	var fontColor = "";
	if (value == "1��"){ fontColor = "#F16E57";}
	if (value == "2��"){ fontColor = "orange";}
	if (value == "3��"){ fontColor = "#FFB746";}
	if ((value == "4��")||(value == "5��")){ fontColor = "#2AB66A";} //ed
	return "<font color='" + fontColor + "'>"+setCell(value)+"</font>";	//hxy 2020-02-21
}

function setCell(value){
	if(value=="1��"){value="��";}
	if(value=="2��"){value="��";}
	if(value=="3��"){value="��";}
	if(value=="4��"){value="��a��";}
	if(value=="5��"){value="��b��";}
	return value;
}

/// �ּ�
function setCellLevLabel(value, rowData, rowIndex){
	var fontColor = "";
	if (value == "1��"){ fontColor = "#F16E57";}
	if (value == "2��"){ fontColor = "orange";}
	if (value == "3��"){ fontColor = "#FFB746";}
	if ((value == "4��")||(value == "5��")){ fontColor = "#2AB66A";} //ed
	return "<font color='" + fontColor + "'>"+setCell(value)+"</font>"; //hxy 2020-02-21
}

/// ȥ��
function setCellAreaLabel(value, row, index){
	if (value == "����"){
		return 'background-color:#F16E57;color:white';
	}else if (value == "����"){ //hxy 2020-02-21 st
		return 'background-color:orange;color:white'; //ed
	}else if (value == "����"){
		return 'background-color:#FFB746;color:white';
	}else if (value == "����"){
		return 'background-color:#2AB66A;color:white';
	}else{
		return '';
	}
}

/// ��ɫͨ��
/// zhouxin
/// 2018-07-18
function setCellGreenLabel(value, rowData, rowIndex){
	var fontColor = "";
	var html = '<a href="javascript:void(0);" onclick="showGreenRec('+rowData.admId+')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"/></a>';
	if (value == "��"){ html = '<a href="javascript:void(0);" onclick="showGreenRec('+rowData.admId+')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png"/></a>'; }
	return html;
	
}

function showGreenRec(adm){
	var option = {
		minimizable:false,
		iconCls:'icon-save',
		onClose:function(){qryEmPatList()}
	}
	new WindowUX("��ɫͨ��","PatLabWin", 700, 420 , option).Init();
	
	var LinkUrl ='dhcem.green.rec.csp?EpisodeID='+adm
	var content = '<iframe class="page-iframe" src="'+ LinkUrl +'" frameborder="no" border="no" height="98%" width="100%" scrolling="no"></iframe>';
	$("#PatLabWin").html(content);
	return;		
}

/// ��ȡ����
function getParams(){
	
	/// ��ʼ����
	var StartDate = $HUI.datebox("#StartDate").getValue();
	/// ��������
	var EndDate = $HUI.datebox("#EndDate").getValue();
	///����
	var CheckLev = $HUI.combobox("#CheckLev").getValue();
	///�ǼǺ�
	var TmpCondition = $("#TmpCondition").val();
	/// ����
	var CardNo = $("#EmCardNo").val();
	/// �������
	var AdmLoc = $HUI.combobox("#AdmLoc").getValue();
	///���۲���
	var EmWardID = $HUI.combobox("#KeptLoc").getValue()
	
	var OrdType = $HUI.combobox("#OrdType").getValue()
	

	
	
	
	return StartDate+'^'+EndDate+'^'+CheckLev+'^'+TmpCondition+'^'+CardNo+'^'+AdmLoc+'^'+EmWardID+'^'+OrdType;
}

/// ��ѯ
function qryEmPatList(){
	
	$("#patList").datagrid("load",{model:1,"params":getParams()}); 
}
