/*
 * FileName:	dhcinsu.declaration.js
 * User:		tangzf
 * Date:		2020-02-27
 * Description: ҽ���걨
 */ 
 var GV = {
	UPDATEDATAID : '',
	HospDr:session['LOGON.HOSPID'] ,
	ADMID:'',
	PAPMI:'',
	INSUADMID : ''
}
 $(function () { 
 	window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} 
	// ҽ������
	init_INSUType();
	
	// ��ѯ���ҽ������
	init_SearchINSUType();
	
	// ��ѯ���ҽ�����
	init_SearchAdmType();
		
	// HIS������
	initCardType();
	
	//���Żس���ѯ�¼�
	$("#HISCardNo").keydown(function (e) {
		cardNoKeydown(e);
	});
	
	//�ǼǺŻس���ѯ�¼�
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	//������Żس���ѯ�¼�
	$("#SearchRPTNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
	//��Ա��Żس���ѯ�¼�
	$("#SearchPatNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
	// �����¼
	initAdmList();
	
	// �걨��Ϣ������
	init_AddInfoPanel();
	
	// ҽԺ��Ŀ����
	init_HISTarItem();
		
	init_dg(); 
	
	init_layout();
	
	//תԺ�������� WangXQ 20220627
	$('#btnexport').bind('click', function () {
		Referexport_Click();
	});
	
	$('#HISCardType').combobox('disable',true);
	clear();
});
function initAdmList() {
	$HUI.combogrid("#AdmList", {
		panelWidth: 560,
		panelHeight: 200,
		striped: true,
		fitColumns: false,
		editable: false,
		pagination: true,
		pageSize: 100,
		pageList: [100],
		method: 'GET',
		idField: 'admId',
		textField: 'admNo',
		columns: [[{field: 'admNo', title: "�����", width: 100},
					{field: 'admStatus', title: '��������', width: 80},
					{field: 'admDate', title: '��������', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.admTime;
							}
					}
					},
					{field: 'admDept', title: '�������', width: 100},
					{field: 'admWard', title: '���ﲡ��', width: 120},
					{field: 'admBed', title: '����', width: 60},

					{field: 'admId', title: '����ID', width: 80},
					{field: 'patName', title: '����', width: 80,hidden:true},
					{field: 'PaSex', title: '�Ա�', width: 80,hidden:true},
					{field: 'PAPMIHealthFundNo', title: 'ҽ���ֲ��', width: 80,hidden:true}
			]],
		onLoadSuccess: function (data) {

		},
		onLoadError:function(e){
		},
		onSelect: function (index, row) {
			GV.ADMID = row.admId;
			refreshBar('',row.admId);
			var admReaStr = getAdmReasonInfo(row.admId);
			var admReaAry = admReaStr.split("^");
			var admReaId = admReaAry[0];
			var INSUType = GetInsuTypeCode(admReaId);
			$("#QInsuType").combobox('select', INSUType);
			GetInsuAdmInfo();
		 	setValueById('name',row.patName); //����
		 	setValueById('Sex',row.PaSex); //�Ա�		
		}
	});
}


//��ȡҽ��������Ϣ����
function GetInsuAdmInfo()
{
	$.m({
		ClassName: "web.DHCINSUIPReg",
		MethodName: "GetInfoByAdm",
		type: "GET",
		itmjs: "",
		itmjsex: "",
		Paadm: GV.ADMID
	}, function (rtn) {
          if (typeof rtn != "string")
         {
	       $.messager.alert('��ʾ','û����His�ҵ�ҽ���Ǽ�(�Һ�)��Ϣ','info');
	     }
		if (rtn.split("!")[0] != "1") {
			$.messager.alert('��ʾ','û����His�ҵ�ҽ���Ǽ�(�Һ�)��Ϣ','info');
		} else {
			var myAry = rtn.split("!")[1].split("^");
			GV.INSUADMID =  myAry[0]
			//setValueById("InsuActiveFlag", actDesc);           //ҽ���Ǽ�״̬
			setValueById("PatNo", myAry[2]);               //ҽ����
			setValueById("INSUCardNo", myAry[3]);               //ҽ������
			//setValueById("NewCardNo", myAry[3]);            //��ҽ������
			//setValueById("OldCardNo", myAry[39]);           //��ҽ������
			//InsuType=myAry[18];			
			//setValueById("InsuType",myAry[18])
			//InitYLLBCmb(myAry[14]);                          //ҽ�����
		    //InitBCFSCmb();                                  //���Ʒ�ʽ
		    //InitZLFSCmb();                                   //������ʽ
			setValueById("rylb", myAry[4]);          //��Ա���
			//$("#InsuInDiagDesc").combogrid("grid").datagrid("loadData", {
			//	total: 1,
			//	rows: [{"Code": myAry[26], "Desc": myAry[27]}]
			//});
			//$("#InsuInDiagDesc").combogrid("setValue", myAry[26]); 
			//setValueById("rylb", myAry[4]);          //��Ա���  //ҽ�����
			
			//setValueById("insuTreatType", myAry[36]);        //�������
			//setValueById("insuAdmSeriNo", myAry[10]);        //ҽ�������
			//setValueById("xzlx",myAry[37])                   //��������
	        //setValueById("dylb",myAry[36])                   //�������
	        //setValueById("AdmDate",myAry[12])                //��Ժ����
	        //setValueById("AdmTime",myAry[13])                //��Ժʱ��
            //setValueById("InsuAdmSeriNo",myAry[10])          //ҽ�������
            setValueById("States",myAry[8])              //ҽ��ͳ����
			//setValueById("ZLFS", myAry[38]);               //���Ʒ�ʽ
			//setValueById("BCFS", myAry[39]);               //������ʽ
		}
	});
	
}
// ���ؾ����б�
function loadAdmList(myPapmiId) {
	$('#AdmList').combobox('clear');
	
	var queryParams = {
		ClassName: "web.INSUReport",
		QueryName: "FindAdmList",
		type: "GET",
		papmi: myPapmiId,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadComboGridStore("AdmList", queryParams);
}
/**
* �ǼǺŻس��¼�
*/
function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
	}
}
function init_layout(){	
	// east-panel
	var bodyWidth = +$('body div:first').css('width').split('px')[0];
	var westWidth = '800';
	var eastWidth = bodyWidth - westWidth;  	
	$('.west-panel').panel({ 
		width:westWidth 
	});  
	$('.west-panel').panel('resize');
	// east
	$('.east-panel').panel({
		width:eastWidth,
	});
	$('.east-panel').panel('resize');
	$('.layout-panel-east').css('left' ,westWidth + 'px'); 
	
	$('.EastSearch').panel({
		width:100	
	});
	$('.EastSearch').panel('resize');

	var dgHeight = window.document.body.offsetHeight - 36 - 20 - 12 - 122; // // window - patbanner - padding(banner)10 - padding(panel)10*2 - ��ѯ���
	var height = dgHeight + 124 -126
	//$('#dg').datagrid('options').height = dgHeight;
	//$('#dg').datagrid('resize');
	$('#ReportPanel').panel('options').height = height;
	$('#ReportPanel').panel('resize');
	
}
/*
 * ҽ������ ��ҽ�������йص� ��������Ҫ�������¼���
 */
function init_INSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('QInsuType','DLLType',Options); 	
	$('#QInsuType').combobox({
		onSelect:function(){
			$('#rylb').combobox('clear');
			$('#States').combobox('clear');
			$('#DiagCodeMXB').combobox('clear');
			$('#AdmType').combobox('clear');
			//reload
			$('#rylb').combobox('reload');
			$('#States').combobox('reload');
			$('#DiagCodeMXB').combobox('reload');
			$('#AdmType').combobox('reload');
			$('#Insutype').combobox('reload');
		}	
	})	
}
function init_SearchINSUType(){
var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('SearchInsuType','DLLType',Options); 
	$('#SearchInsuType').combobox({
		onSelect:function(){
			$('#SearchAdmType').combobox('clear');
			$('#SearchAdmType').combobox('reload');
		}	
	})	
}
/*
 * �������
 */
function init_SearchAdmType(){
	$HUI.combobox(('#SearchAdmType'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'med_type' + getValueById('SearchInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			
		}		
	});
	$HUI.combobox(('#AdmType'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'med_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
}
/*
 * datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'TabRptTypeDesc',title:'�������',width:75},
			{field:'TabFlag',title:'������־',width:80,styler:function(val, index, rowData){
				switch (val){
					case "����δͨ��":
						return "background:red";
						break;
					case "����ͨ��":
						return "background:green";
						break;
					case "δ����":
						return "background:yellow";
						break;			
				}
			}},	
			{field:'TabINSUType',title:'ҽ������',width:75},
			{field:'TabRptDate',title:'�걨����',width:100},
			{field:'TabSDate',title:'��Ч��ʼ����',width:100},
			{field:'TabEDate',title:'��Ч��������',width:100},
			{field:'TabAdmSeriNo',title:'סԺ��ˮ��',width:150},
			{field:'TabPatNo',title:'���˱��',width:150 },
			{field:'TabPatName',title:'��������',width:150 },
			{field:'TabAdmType',title:'��������',width:120},
			{field:'TabDiagCode',title:'��������',width:150 },
			{field:'TabDiagDesc',title:'��������',width:150},
			{field:'TabRPTNo',title:'�������',width:150},
			{field:'Tabxmbm',title:'��Ŀ����',width:150},
			{field:'Tabxmmc',title:'��Ŀ����',width:150 },
			{field:'TabHisCode',title:'ҽԺ��Ŀ����',width:150,hidden:true},
			{field:'TabHisDesc',title:'ҽԺ��Ŀ����',width:150,hidden:true },
			{field:'Tabxmlb',title:'��Ŀ���',width:150 },
			{field:'TabOutHosName',title:'ת��ҽԺ',width:150 },
			{field:'Tabmoney',title:'���',width:150,align:'right' },
			{field:'Tabsl',title:'����',width:150 },
			{field:'TabUserName',title:'�걨��',width:150 },
			{field:'TabDoctor',title:'����ҽ��',width:150 },
			{field:'TabNumberID',title:'�������κ�',width:150 },
			{field:'TabStates',title:'�α���',width:150 },
			{field:'TabHosYJ',title:'ҽԺ���',width:150 },
			{field:'TabJSYJ',title:'�������',width:150 },
			{field:'TabMD',title:'	Ŀ��',width:150 },
			{field:'TabZZ',title:'֢״',width:150 },	
			{field:'TabBZ',title:'��ע',width:150 },
			{field:'TabRptType',hidden:true },	
			{field:'rowid',hidden:true}
		]];

	// ��ʼ��DataGrid
	$('#dg').datagrid({
		fit:true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		toolbar: '#tToolBar',
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		}
	});
}
/*
 * ��������
 */
function initLoadGrid(){
	if(getValueById('SearchInsuType')==''){
		//$.messager.alert('��ʾ','ҽ�����Ͳ���Ϊ��','info');
		//return;	
	}
	var ExpStr = getValueById('SearchRPTNo') + '|' + getValueById('SearchPatNo');
    var queryParams = {
	    ClassName : 'web.INSUReport',
	    QueryName : 'QueryAll',
	    SearchAdmType : getValueById('SearchAdmType'),
	    StartDate : getValueById('StartDate'),
	    EndDate : getValueById('EndDate'),
	    HospId: GV.HospDr,
	    ParamINSUType: getValueById('SearchInsuType'),
	    ExpStr:ExpStr
	}	
    loadDataGridStore('dg',queryParams);
}
/*
 * ��ѯҽ�������Ϣ
 */
$('#btnFindReport').bind('click', function () {
	FindReportInfo();
})
/*
 * readcard
 */
$('#btn-readINSUCard').bind('click', function () {
	if(getValueById('QInsuType')==''){
		$.messager.alert('��ʾ', "ҽ�����Ͳ���Ϊ��" + str, 'error');	
		return;	
	}
	var CardType="1",InsuNo="";
	var ExpString = getValueById('QInsuType') + '^' + GV.HospDr;
	var UserId = session['LOGON.USERID'];
	var str = InsuReadCard('0',UserId,InsuNo,1,ExpString);
	var TmpData = str.split("|");
	if (TmpData[0]!="0"){
		$.messager.alert('��ʾ', "����ʧ��" + str, 'error');	
		return;
	}else{
	 	var TmpData1 = TmpData[1].split("^")
	 	var TmpData2 = TmpData[2].split("^")
	 	setValueById('PatNo',TmpData1[0]); //���˱��
	 	setValueById('INSUCardNo',TmpData1[1]);  //����
	 	setValueById('name',TmpData1[3]); //����
	 	setValueById('Sex',TmpData1[4]); //�Ա�
	 	//setValueById('States',TmpData2[8]); //�α���������
	 	setValueById('States',TmpData[6]); //�α���������
	 	setValueById('rylb',TmpData1[11]);  //��Ա���
	 	
	 	setValueById('Insutype',TmpData[3]);  //��������	 	
	 }
});
/**
* ����У��
*/
function checkData() {
	var inValiddatebox = $('.validatebox-invalid');
	if(inValiddatebox.length > 0){ //validdatebox
		$.each(inValiddatebox, function (index, rowData) {
			var labelDesc = $('#' + rowData.id).parent().prev().find('label').text();
			var clsStr = $('#' + rowData.id).attr('class');
			if(clsStr.indexOf('combobox') > 0){
				var vaildCheck = getValueById(rowData.id);
				if(vaildCheck ==''>0){
					$.messager.alert('��ʾ', '[' + labelDesc +']' + '��֤��ͨ��' , 'error');
					throw rowData.id;
				}
			}else{
				$.messager.alert('��ʾ', '[' + labelDesc +']' + '��֤��ͨ��' , 'error');
				throw rowData.id;
			}
		});		
	}
}
/*
 * ����
 */
$('#btnReport').bind('click', function () {
	try{

		checkData();
		var PatNo = getValueById('PatNo');
		var Name=getValueById('name');
		var AdmType = getValueById('AdmType');
		var AdmSeriNo = '';
		var OutHosName = '';
		var HosLevel = '';
		var DiagCode = getValueById('DiagCode');
		var DiagDesc = $('#DiagCode').combobox('getText');
		var HosYJ = getValueById('HosYJ');
		var xmbm = getValueById('xmbm');
		var xmmc = $('#xmbm').combobox('getText');	
		var sl = getValueById('sl');
		var RptDate = getValueById('RptDate');	
		var SDate = getValueById('SDate');	
		var EDate = getValueById('EDate');	
		var Guser = session['LOGON.USERID'];
		var OutHosName = '';
		var GuserName = session['LOGON.USERNAME'];
		var OutType = '';
		var Demo = '';
		var money = getValueById('money');
		var xmlb = '';
		var RPTNo = '';
		var ZYZZ = getValueById('ZYZZ');
		var MD = getValueById('MD');
		var Doctor = getValueById('Doctor');
		var DoctorCode=getValueById('DoctorCode');
		var KZR = getValueById('KZR');
		var JSYJ = getValueById('JSYJ');
		var KZRYJ = getValueById('KZRYJ');
		var LRuser = '';
		var LRDate = '';
		var RPTUser = '';
		var HisCode = '';
		var HisDesc = '';
		var NumberID = '';
		var States =  $('#States').combobox('getText'); 
		var HospId = GV.HospDr;
		
		var insutype=getValueById('Insutype');
		var HiType=getValueById('QInsuType');
        /*
                    //0                       											5															11									14
		var str = PatNo + "|"+RptType+"|"+AdmSeriNo+"|"+OutHosName+"|"+HosLevel+"|"+DiagCode+"|"+DiagDesc+"|"+HosYJ+"|"+xmbm+"|"+xmmc+"|"+sl+"|"+RptDate+"|"+SDate+"|"+EDate+"|"+GuserName+"|";
		//				15												20																			28			
		str = str + OutType+"|"+Demo+"|"+money+"|"+xmlb+"|"+RPTNo+"|"+ZYZZ+"|"+MD+"|"+Doctor+"|"+KZR+"|"+JSYJ+"|"+KZRYJ+"|"+LRuser+"|"+LRDate+"|"+RPTUser+"|";
								// 30								      33			34����ID
		str = str + HisCode+"|"+HisDesc+"|"+AdmType+"|"+NumberID + "|" + States + "|" + GV.ADMID + "|" + GV.INSUADMID;
		ExpString = getValueById('QInsuType') + '^^' +getValueById('name'); // insutype^ExpStrForNet^Name
		var rtn=InsuReport(0,Guser,str,ExpString);
		*/
		
		//^^^��Ա���^��Ա����^��������(�������,���ֲ�ͬҵ����������)^^��������^^ҽ����𣨿�Ϊ�գ�^�����ز����ֱ���^
		//�����ز���������^��ʼ����^�������ڣ���Ϊ�գ�^^^^^^^^^^^^^^^^^^^�α�����^^^^^^^
		//��ϵ�绰^^^������������(��Ϊ��)^�����������ƣ���Ϊ�գ�^���ҽʦ����^���ҽʦ����^^^��������^��ϵ��ַ^
		var str =HiType+"^"+""+"^"+""+"^"+ PatNo +"^"+ Name +"^"+"01"+"^"+""+"^"+RptDate+"^"+""+"^"+AdmType+"^"+DiagCode+"^"+DiagDesc+"^"+SDate+"^"+EDate
		var str=str+"^^^^^^^^^^^^^^^^^^^"+States+"^^^^^^^"
		var str=str+"^"+""+"^^^"+""+"^"+DoctorCode+"^"+Doctor+"^^^"+insutype+"^"+""+"^"
		var ExpString = getValueById('QInsuType') + '^^' +getValueById('name'); // insutype^ExpStrForNet^Name
		var rtn=InsuReport(0,Guser,str,ExpString);
		if (rtn == 0){
			$.messager.alert('��ʾ', "�����ϱ��ɹ�!", 'info',function(){
				$HUI.dialog("#LocalListInfoProWin",'close');
				clear();
				initLoadGrid();	
			});	
		} else{
			$.messager.alert('����', "�����ϱ�ʧ��!��" + rtn, 'error');
		}
	}catch(e){
	}
});
/*
 * ɾ��
 */
$('#btnDel').bind('click', function () {
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if(selected.TabFlag == '�ѳ���'){
			$.messager.alert('��ʾ','�ü�¼�ѳ���','info');	
			return;
		}
		if (selected.rowid != "") {
			$.messager.confirm('ȷ��', 'ȷ�ϳ����ϱ���¼��', function (r) {
				if (r) {
					var str=selected.TabRptType + "|"  + selected.TabPatNo + "|" + selected.TabAdmSeriNo + "|" + selected.TabDiagCode + "|" + selected.TabDiagDesc + "|" + selected.TabSDate
					var ExpString = getValueById('SearchInsuType') + '^^^'; // insutype^ExpStrForNet
					//var rtn=tkMakeServerCall("web.INSUReport", "DeleteReport", selected.rowid); //DHCINSUBLL.InsuReportDestroy(1,str,Guser,ExpString);	
					var rtn=InsuReportDestory(1,session['LOGON.USERID'],selected.rowid,str,ExpString);	
				    if (rtn!="0"){
					    $.messager.alert('����', "�����ϱ�����ʧ��!" + rtn, 'info');
					}else {
						$.messager.alert('����', "�����ϱ������ɹ�!", 'info',function(){
							initLoadGrid();	
						});
				    }
				}
			});
		}
	} else {
		$.messager.alert('��ʾ', "��ѡ��Ҫ�����ļ�¼", 'info');
	}
});
/*
 * ������ѯ
 */
$('#btnSearch').bind('click', function () {
	var selected = $('#dg').datagrid('getSelected');    
	if (selected) { 
		if (selected.rowid != "") {                                      //�鵥��
		 	var RptType = "01";
			$.messager.confirm('ȷ��', 'ȷ�ϲ�ѯ����������¼��', function (r) {
				if (r) {
					var str=selected.TabRptType + "|"  + selected.TabPatNo + "|" + selected.TabAdmSeriNo + "|" + selected.TabDiagCode + "|" + selected.TabDiagDesc + "|" + selected.TabSDate
					 
					var rtn=InsuReportQuery(1,"","",session['LOGON.USERID'],selected.rowid,RptType,getValueById('INSUType'))	
				    if (rtn!="0"){
					    $.messager.alert('����', "������ѯʧ��!" + rtn, 'info');
					}else {
						$.messager.alert('����', "������ѯ�ɹ�!" + rtn, 'info',function(){
							initLoadGrid();	
						});
				    }
				}
			});
		}
	} else {                                                           //������
		 var SDate = GetInsuDateFormat(getValueById('StartDate'));	
		 var EDate = GetInsuDateFormat(getValueById('EndDate'));	
		 var RptType = "01";
	     var rtn=InsuReportQuery(1,SDate,EDate,session['LOGON.USERID'],"",RptType,getValueById('INSUType'))	                                                
		 if (rtn!="0"){
			 $.messager.alert('����', "������ѯʧ��!" + rtn, 'info');
					}else {
						$.messager.alert('����', "������ѯ�ɹ�!" + rtn, 'info',function(){
							initLoadGrid();	
						});
				    }
				    
	}
});
/*
 * ��ѯ
 */
$('#btnFind').bind('click', function () {
	initLoadGrid();
});


/* 
 * ��ѯҽ�������Ϣ
 */
function FindReportInfo(){
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if(selected.TabFlag =='�ѳ���'){
			$.messager.alert('��ʾ', "����Ѿ�����", 'info');
			return;
		}
		$.messager.alert('��ʾ', "��Ҫ����ҽ������", 'info');	
	} else {
		$.messager.alert('��ʾ', "��ѡ��Ҫ��ѯ�ļ�¼", 'info');
	}
}
/* 
 * ��ʼ���걨���
 */
function init_AddInfoPanel(){
	

	/*
	// �������
	$HUI.combobox(('#RptType'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'med_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	*/
	// ��Ա���
	$HUI.combobox(('#rylb'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'AKC021' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	})
	
	// states
	$HUI.combobox(('#States'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'YAB003' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	


	// ���Բ����
	$HUI.combobox(('#DiagCodeMXB'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'Skc516' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	})
	
	// HIS���
	$HUI.combobox(('#DiagCode'),{
		defaultFilter:'3',
		valueField: 'code',
		textField: 'desc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			if(param.q==''){
				return true;	
			}
			param.ClassName = 'web.DHCMRDiagnos';
			param.QueryName= 'LookUpWithAlias';
			param.desc = param.q;
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	
	// ���
	$('.advise').combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{
    			"id" : '01',
    			"text":"ͬ��",
    			selected:true
    		},{
    			"id" : '02',
    			"text":"��ͬ��"	
    		}]	
	});
	// sex
	$('#Sex').combobox({
		valueField: 'Id',
		textField: 'Desc',
		url:$URL,
		editable: false,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUReport';
			param.QueryName= 'FindCTSex';
			param.ResultSetType = 'array';
		},onLoadSuccess:function(data){
		},onLoadError:function(){
		}	
	});
	
	// ������
	$('#KZR').combobox({
		valueField: 'Desc',
		textField: 'Desc',
		url:$URL,
		defaultFilter:'4',
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUReport';
			param.QueryName= 'FindSSUser';
			param.ResultSetType = 'array';
			param.HospId = GV.HospDr;
		},onLoadSuccess:function(data){
		},onLoadError:function(){
		}	
	});
	
/*
 * ��������
 */
	$('#Insutype').combobox({
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'insutype' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			
		}		
	});
	
//	$('#Doctor').combobox({
//		valueField: 'Desc',
//		textField: 'Desc',
//		url:$URL,
//		defaultFilter:'4',
//		onBeforeLoad:function(param){
//			param.ClassName = 'web.INSUReport';
//			param.QueryName= 'FindSSUser';
//			param.ResultSetType = 'array';
//			param.HospId = GV.HospDr;
//		},onLoadSuccess:function(data){
//		},onLoadError:function(){
//		}	
//	});
// ҽʦ
	$("#Doctor").combogrid({
		panelWidth: 320,
		panelHeight: 450,
		//delay:300,
		mode:'remote',
		method: 'GET',
		striped: true,
		fitColumns: true,
		pagination:true,
		editable: true,
		valueField: 'name',
		textField: 'code',
		url:$URL,
		
		data:[],
		columns:[
		[{
			field:'rowid',title:'rowid',hidden:true},
			{field:'code',title:'����',width:100} ,
			{field:'name',title:'����',width:100}
			
		]],
		onBeforeLoad:function(param){
		
			param.ClassName = "INSU.COM.BaseData";
			param.QueryName= "CTCareQuery";
			param.Name = param.q;
			param.HospId = GV.HospDr; //20210907 DingSH 
		},
		onLoadSuccess:function(data){
		 
		},
		onSelect:function(index,rowData){
			 
			//setValueById('DoctorCode',rowData.name)
			setValueById('DoctorCode',rowData.name)
			
			}	
	});
}
function getPatInfo() {
	var patientNo = getValueById("patientNo");
	if (patientNo) {
		var expStr = "";
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: patientNo,
			ExpStr: expStr
		}, function(papmi) {
			if (!papmi) {
				$.messager.popover({msg: "�ǼǺŴ�������������", type: "info"});
				return;
				//focusById("patientNo");
			}
			var admStr = "";
			setPatientInfo(papmi);
			loadAdmList(papmi);
			refreshBar(papmi,'');
		});
	}
}

function setPatientInfo(papmi) {
	var expStr = PUBLIC_CONSTANT.SESSION.HOSPID;
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetPatientByRowId",
		PAPMI: papmi,
		ExpStr: expStr
	}, function(rtn) {
		var myAry = rtn.split("^");
		setValueById("patientNo", myAry[1]);
	});
}

/*

function getPatInfo() {
	var patientNo = "";
	var medicareNo = "";
	var episodeId = "";
	patientNo = getValueById("patientNo");
	if (patientNo || medicareNo || episodeId) {
		$.m({
			ClassName: "web.DHCIPBillCashier",
			MethodName: "GetAdmInfo",
			PatientNo: patientNo,
			MedicareNo: '',
			EpisodeID: episodeId,
			SessionStr: getSessionStr()
		}, function (rtn) {
			if (rtn) {
				setPatInfo(rtn);
			}else {
				$.messager.popover({msg: "���߲�����", type: "info"});
			}
		});
	}
}*/

/**
 * ˢ�»�����Ϣ��
 */
function refreshBar(papmi, adm) {
	//loadAdmList(papmi);
	$.m({
		ClassName: "web.DHCDoc.OP.AjaxInterface",
		MethodName: "GetOPInfoBar",
		CONTEXT: "",
		EpisodeID: adm,
		PatientID: papmi
	}, function (html) {
		if (html != "") {
			$(".PatInfoItem").html(reservedToHtml(html));
		} else {
			$(".PatInfoItem").html("��ȡ������Ϣʧ�ܣ����顾������Ϣչʾ�����á�");
		}
	});
}

function reservedToHtml(str) {
	var replacements = {
		"&lt;": "<",
		"&#60;": "<",
		"&gt;": ">",
		"&#62;": ">",
		"&quot;": "\"",
		"&#34;": "\"",
		"&apos;": "'",
		"&#39;": "'",
		"&amp;": "&",
		"&#38;": "&"
	};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g, function (v) {
		return replacements[v];
	});
}

/**
* banner��ʾ��Ϣ
*/
function showBannerTip() {
	$(".PatInfoItem").html("<div class='unman'></div><div class='tip-txt'>���Ȳ�ѯ����</div>");
}
/**
* ��ʼ��������
*/
function initCardType() {
	$HUI.combobox("#HISCardType", {
		url: $URL + "?ClassName=web.INSUReport&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		valueField: "myTypeID",
		textField: "caption",
		onChange: function (newValue, oldValue) {
		},
		onLoadSuccess:function(){
			setValueById('HISCardType','');	
		}
	});
}


function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		//clear();
		var cardNo = getValueById("HISCardNo");
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}

function magCardCallback(rtnValue) {
	loadAdmList('');
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("HISCardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("HISCardType", myAry[8]);
		getPatInfo();
		break;
	case "-200":
		$.messager.alert("��ʾ", "����Ч", "info", function () {
			//focusById("HISCardNo");
		});
		break;
	case "-201":
		setValueById("HISCardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("HISCardType", myAry[8]);
		getPatInfo();
		break;
	default:
	}
	if (patientId != "") {
		var admStr = "";
		loadAdmList(patientId);
		refreshBar(patientId, '');
	}
}

/**
* ��ȡ����ѱ���Ϣ
*/
function getAdmReasonInfo(episodeId) {
	return $.m({ClassName: "web.UDHCJFPAY", MethodName: "GetAdmReaNationCode", EpisodeID: episodeId}, false);
}
// HIS�շ���Ŀ
function init_HISTarItem(){		
	$('#xmbm').combobox({
		valueField: 'code',
		textField: 'desc',
		url: $URL + '?ClassName=DHCBILLConfig.DHCBILLFIND&QueryName=FindTarItem&ResultSetType=array',
		mode: 'remote',
		method: 'get',
		onBeforeLoad: function (param) {
			if (!param.q) {
				return false;
			}
			$.extend(param, {
				code: "",                           //��Ŀ����
				desc: "",                           //��Ŀ���� �����������ݲ�ѯ
				alias: param.q,                     //����
				str: '',                //��δ�
				HospID: GV.HospDr    //ҽԺID
			});
			return true;
	 	}
	});
}
$('#btnClean').bind('click',function(){
	clear();		
})
$('#btn-readCard').bind('click',function(){
	readHFMagCardClick();		
})

/**
 * ����
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#btn-readCard").hasClass("l-btn-disabled")) {
		return;
	}
	DHCACC_GetAccInfo7(magCardCallback);
}
function clear(){
	//��ѯ����
	$(".searchPanel").form("clear");
	$('#SearchInsuType').combobox('reload');
	//initLoadGrid();
	//
	$(".addInfo").form("clear");
	$('#QInsuType').combobox('reload');		
	$('.advise').combobox('select','01');
	// ���������
	setValueById('money','0');
	setValueById('sl','0');
	$(".PatInfoItem").html('');
//	setValueById('SDate',getDefStDate(0));
//	setValueById('EDate',getDefStDate(1));
//	setValueById('RptDate',getDefStDate(0));
//	setValueById('StartDate',getDefStDate(0));
//	setValueById('EndDate',getDefStDate(1));
	
	InsuDateDefault('SDate');
	InsuDateDefault('EDate',1);
	InsuDateDefault('RptDate');
	InsuDateDefault('StartDate');
	InsuDateDefault('EndDate',1);
	ClearGrid('dg');
	//���combogrid��������������� addby LuJH 20230412
	$(".combogrid-f").combogrid("clear").combogrid("grid").datagrid("loadData", { 
		total: 0,
		rows: []
	});
			
}

//���ز��걨��¼����  WangXQ  20220627
function Referexport_Click()
{
	try
   {
	var ExpStr = getValueById('SearchRPTNo') + '|' + getValueById('SearchPatNo');
$.messager.progress({
         title: "��ʾ",
		 msg: '���ڵ�����¼',
		 text: '������....'
		   });

$cm({
	ResultSetType:"ExcelPlugin",  
	ExcelName:"��Ա���ز��걨��¼",		  
	PageName:"QueryAll",     
	ClassName:"web.INSUReport",
	QueryName:"QueryAll",
    SearchAdmType : getValueById('SearchAdmType'),
	StartDate : getValueById('StartDate'),
	EndDate : getValueById('EndDate'),
	HospId: GV.HospDr,
	ParamINSUType: getValueById('SearchInsuType'),
	ExpStr:ExpStr
},
function(){

	  setTimeout('$.messager.progress("close");', 3 * 1000);	
});
   
   } catch(e) {
	   $.messager.alert("����",e.message);
	   $.messager.progress('close');
   };	
}

/*
*���dg��Ϣ
*HanZH 20230328
*/	
function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
}

