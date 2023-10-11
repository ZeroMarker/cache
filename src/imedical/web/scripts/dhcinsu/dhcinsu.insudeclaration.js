/*
 * FileName:	dhcinsu.insudeclaration.js
 * User:		tangzf
 * Date:		2020-02-27
 * Description: ҽ���걨
 */
 var GV = {
	UPDATEDATAID : '',
	HospDr:session['LOGON.HOSPID'] 
}
 $(function () { 
 	$(document).keydown(function(e){
	 	banBackSpace(e);
	 	});
	setValueById('StartDate',getDefStDate(0));
	setValueById('EndDate',getDefStDate(1));
	
	
	// �������
	init_ReportType();
	// ҽ������
	init_INSUType();	
	
	
	// �س��¼�
	$('#search .textbox').keydown(function (e) {
		if (e.keyCode == 13) {
			initLoadGrid();
		}
	});
	
	$HUI.radio("[name='RptSt']",{
        onChecked:function(e,value){
           initLoadGrid();
        }
    });
	$('#PatName').keydown(function (e) {
		if (e.keyCode == 13) {
			initLoadGrid();
		}
	});
	init_dg(); 
});
/*
 * ҽ������
 */
function init_INSUType(){
	var Options = {
		defaultFlag:'N'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('INSUType','DLLType',Options); 	
	$('#INSUType').combobox({
		onSelect:function(){
			init_ReportType();
			// ���ؾ���ƾ֤����
			init_CertType();
		}	
	})
}

/*
 * ����ƾ֤����
 */
function init_CertType(){
	var Options = {
		defaultFlag:'N',
		editable:'Y',
		hospDr:GV.HospDr	
	}
	INSULoadDicData('certtype','mdtrt_cert_type' + getValueById('INSUType'),Options); 	
}



/*
 * �������
 */
function init_ReportType(){
	var Options = {
		defaultFlag:'N',
		editable:'Y',
		hospDr:GV.HospDr	
	}
	INSULoadDicData('Rptlb','RTPType' + getValueById('INSUType'),Options); 	
}
/*
 * datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'TabPatNo',title:'���˱��',width:180 },
			{field:'TabPatName',title:'��������',width:100 },
			{field:'TabRptDate',title:'�걨����',width:120},
			{field:'TabSDate',title:'��Ч��ʼ����',width:120},
			{field:'TabEDate',title:'��Ч��������',width:120},
			{field:'TabFlag',title:'����״̬',width:120,styler:function(val, index, rowData){
				switch (val){
					case "����δͨ��":
						return "background:red"
						break;
					case "����ͨ��":
						return "background:green"
						break
					case "δ����":
						return "background:yellow"
						break
						
				}
			
			}},	
			{field:'TabDiagCode',title:'��������',width:130 },
			{field:'TabDiagDesc',title:'��������',width:180},
			{field:'TabRptType',title:'�걨����	',width:150},
			{field:'TabAdmType',title:'��������',width:120,},
			{field:'TabRPTNo',title:'�������',width:220},
			{field:'Tabxmbm',title:'��Ŀ����',width:150},
			{field:'Tabxmmc',title:'��Ŀ����',width:150 },
			{field:'TabHisCode',title:'ҽԺ��Ŀ����',width:150},
			{field:'TabHisDesc',title:'ҽԺ��Ŀ����',width:150 },
			{field:'Tabxmlb',title:'��Ŀ���',width:150 },
			{field:'TabOutHosName',title:'ת��ҽԺ',width:150 },
			{field:'Tabmoney',title:'���',width:150,align:'right' },
			{field:'Tabsl',title:'����',width:150 },
			{field:'TabUserName',title:'������',width:150 },
			{field:'TabDoctor',title:'����ҽ��',width:150 },
			{field:'TabNumberID',title:'�������κ�',width:150 },
			{field:'TabStates',title:'�α���',width:150 },
			{field:'TabHosYJ',title:'ҽԺ���',width:150 },
			{field:'TabJSYJ',title:'�������',width:150 },
			{field:'TabAdmSeriNo',title:'סԺ��ˮ��',width:220},
			{field:'TabMD',title:'	Ŀ��',width:150 },
			{field:'TabZZ',title:'֢״',width:150 },	
			{field:'TabBZ',title:'��ע',width:150 },
			{field:'TabRptType',hidden:true },	
			{field:'rowid',hidden:true}
		]];

	// ��ʼ��DataGrid
	$('#dg').datagrid({
		data:[],
		fit: true,
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
	if(getValueById('INSUType')==''){
		$.messager.alert('��ʾ','ҽ�����Ͳ���Ϊ��','info');
		return;	
	}
    var queryParams = {
	    ClassName : 'web.INSUReport',
	    QueryName : 'QueryAll',
	    Rptlb : getValueById('Rptlb'),
	    StartDate : getValueById('StartDate'),
	    EndDate : getValueById('EndDate'),
	    HospId: GV.HospDr,
	    PatName:getValueById('PatName'),
	    PatId:getValueById('PatId'),
	    RptSt:$("input[name='RptSt']:checked").val(),
	    ParamINSUType:getValueById('INSUType')
	    
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
 * ����
 */
$('#btnAdd').bind('click', function () {
	var INSUType = getValueById('INSUType');
	if(INSUType == ''){
		$.messager.alert('��ʾ','����ѡ��ҽ������','info');
		return;	
	}
	openEditWindow();
});

/*
 * readcard
 */
$('#btnReadCard').bind('click', function () {
	var CardType="1",InsuNo="";
	var ExpString = getValueById('INSUType') + '^' + GV.HospDr;
	var UserId = session['LOGON.USERID'];
	CardType=getValueById('certtype');	
	//alert(CardType)
	//return ;
	var str = InsuReadCard('0',UserId,InsuNo,CardType,ExpString);
	//alert("str="+str)
	var TmpData = str.split("|");
	if (TmpData[0]!="0"){
		$.messager.alert('��ʾ', "����ʧ��" + str, 'error');	
		return;
	}else{
		//0|44020000000000612456^440202196908200014^^����^1^01^1969-08-20^^��������ҽԺ^^^11^^0^^^^^^^^440299^^^^01^440202196908200014^||310||�ǹ���Ա|440299|��������ҽԺ|||||@||||||||||@|||||||@.
		//alert("TmpData[1]="+TmpData[1])
	 	var TmpData1 = TmpData[1].split("^")
	 	 
	 	setValueById('PatNo',TmpData1[0]); //���˱��
	 	setValueById('INSUCardNo',TmpData1[1]);  //����
	 	setValueById('name',TmpData1[3]); //����
	 	setValueById('Sex',TmpData1[4]); //�Ա�
	 	setValueById('States',TmpData1[21]); //�α���������
	 	setValueById('rylb',TmpData1[11]);  //��Ա���	 
	 	
	 	setValueById('xzlx',TmpData[3]);  //��������
	 	 
	 }
    
});
/**
* ����У��
*/
function checkData() {
	var inValiddatebox = $('.validatebox-invalid');
	if(inValiddatebox.length > 0){ //validdatebox
		$.each(inValiddatebox, function (index, rowData) {
			var labelDesc = $('#Label' + rowData.id).text() || 'ֵ: ' + rowData.value;
			$.messager.alert('��ʾ', '[' + labelDesc +']' + '��֤��ͨ��' , 'error');
			throw rowData.id;
		});		
	}
}
/*
 * ����
 */
$('#btnReport').bind('click', function () {
	try{
		
		//checkData();
		var PatNo = getValueById('PatNo');
		var Name=getValueById('name');
		var RptType = getValueById('RptType');
		var AdmSeriNo = '';
		var OutHosName = '';
		var HosLevel = '';
		var DiagCode = getValueById('DiagCode');
		var DiagDesc = $('#DiagCode').combobox('getText');
		var HosYJ = getValueById('HosYJ');
		//var xmbm = getValueById('xmbm');
		//var xmmc = $('#xmbm').combobox('getText');	
		//var sl = getValueById('sl');
		var RptDate =GetInsuDateFormat(getValueById('RptDate'));	
		var SDate = GetInsuDateFormat(getValueById('SDate'));	
		var EDate = GetInsuDateFormat(getValueById('EDate'));	
		var Guser = session['LOGON.USERID'];
		var OutHosName = '';
		var GuserName = session['LOGON.USERNAME'];
		var OutType = '';
		var Demo = '';
		//var money = getValueById('money');
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
		var AdmType = '';
		var NumberID = '';
		var States =  $('#States').combobox('getText'); 
		var HospId = GV.HospDr;
		var insutype=getValueById('xzlx');
		var MXBDiagCode=$('#DiagCodeMXB').combobox('getValue'); 
		var MXBDiagDesc=$('#DiagCodeMXB').combobox('getText'); 
		if (RptType=="01"){
			if(MXBDiagCode=="" || MXBDiagDesc==""){$.messager.alert('����', "�������ز�����ʧ��,ʧ��ԭ��:��ѡ�������ز�����!", 'error');return;}
			
			}
		var YLLB=getValueById('InAdmType')
		
		var HiType=getValueById('INSUType');
		
		//alert("Doctor="+Doctor+"DoctorCode="+DoctorCode)
		//return ;
		
        //              0      1      2       3            4         5          6       7         8      9      10     11      12         13
		var ExpString =HiType+"^"+""+"^"+""+"^"+ PatNo +"^"+ Name +"^"+RptType+"^"+""+"^"+RptDate+"^"+""+"^"+YLLB+"^"+MXBDiagCode+"^"+MXBDiagDesc+"^"+SDate+"^"+EDate
		var ExpString=ExpString+"^^^^^^^^^^^^^^^^^^^"+States+"^^^^^^^"
		var ExpString=ExpString+"^"+""+"^^^"+""+"^"+Doctor+"^"+DoctorCode+"^^^"+insutype+"^"+""+"^"
		
		/*
		var str=str+"^"+OutHosName+"|"+HosLevel+"|"+DiagCode+"|"+DiagDesc+"|"+HosYJ+"|"+xmbm+"|"+xmmc+"|"+sl+"|"+RptDate+"|"+SDate+"|"+EDate+"|"+GuserName+"|";	
		str = str + OutType+"|"+Demo+"|"+money+"|"+xmlb+"|"+RPTNo+"|"+ZYZZ+"|"+MD+"|"+Doctor+"|"+KZR+"|"+JSYJ+"|"+KZRYJ+"|"+LRuser+"|"+LRDate+"|"+RPTUser+"|";
		str = str + HisCode+"|"+HisDesc+"|"+AdmType+"|"+NumberID + "|" + States;
		ExpString = getValueById('INSUType') + '^^' +getValueById('name'); // insutype^ExpStrForNet^Name
		*/
		
		//^^^��Ա���^��Ա����^��������^^��������^^ҽ����𣨿�Ϊ�գ�^�����ز����ֱ���^
		//�����ز���������^��ʼ����^�������ڣ���Ϊ�գ�^^^^^^^^^^^^^^^^^^^�α�����^^^^^^^
		//��ϵ�绰^^^������������(��Ϊ��)^�����������ƣ���Ϊ�գ�^���ҽʦ����^���ҽʦ����^^^��������^��ϵ��ַ^
		
		
		var rtn=InsuReport(0, Guser,ExpString,"");
		if (rtn == 0){
			$.messager.alert('��ʾ', "�����ɹ�!��" + rtn, 'info',function(){
				$HUI.dialog("#LocalListInfoProWin",'close');
				initLoadGrid();	
			});	
		} else{
			$.messager.alert('����', "����ʧ��!��" + rtn, 'error');
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
		if (selected.rowid != "") {
			$.messager.confirm('ȷ��', 'ȷ�ϳ���������¼��', function (r) {
				if (r) {
					var str=selected.TabRptType + "|"  + selected.TabPatNo + "|" + selected.TabAdmSeriNo + "|" + selected.TabDiagCode + "|" + selected.TabDiagDesc + "|" + selected.TabSDate
					//ExpString = selected.rowid + "|";
						
						/*
						var Reason
						
						$HUI.dialog("#Reason",{
						title:"���볷������ԭ��",
						height:400,
						width:500,
						collapsible:true,
						content:"<textarea id='ta' style='height:400;width:500'></textarea>",
						pagination:true,toolbar:[{
								iconCls: 'icon-edit',
								text:'�༭',
								handler: function(){
									Reason=$('#ta').val()	
								}
								
													
							}] 
						})
						*/
						var Reason="��Ҫ���±���"
					if(Reason==""){$.messager.alert('����', "��������ʧ��!�����뱸������ԭ��", 'info');return; }
					//var ExpString = getValueById('INSUType') + '^' + GV.HospDr;
					var HiType=getValueById('INSUType'); // DingSH 20210714
					//var rtn=tkMakeServerCall("web.INSUReport", "DeleteReport", selected.rowid); //DHCINSUBLL.InsuReportDestroy(1,str,Guser,ExpString);
					var rtn=InsuReportDestory(1,session['LOGON.USERID'],selected.rowid,"",Reason+"^"+HiType)	
				    if (rtn!="0"){
					    $.messager.alert('����', "��������ʧ��!" + rtn, 'info');
					}else {
						$.messager.alert('����', "���������ɹ�!" + rtn, 'info',function(){
							initLoadGrid();	
						});
				    }
				}
			});
		}
	} else {
		$.messager.alert('��ʾ', "��ѡ��Ҫɾ���ļ�¼", 'info');
	}
});


/*
 * ��ѯ
 */
$('#btnSearch').bind('click', function () {
	var selected = $('#dg').datagrid('getSelected');    
	if (selected) { 
		if (selected.rowid != "") {                                      //�鵥��
		 	var RptType = getValueById('RptType');
			$.messager.confirm('ȷ��', 'ȷ�ϲ�ѯ����������¼��', function (r) {
				if (r) {
					var str=selected.TabRptType + "|"  + selected.TabPatNo + "|" + selected.TabAdmSeriNo + "|" + selected.TabDiagCode + "|" + selected.TabDiagDesc + "|" + selected.TabSDate
					 
					var rtn=InsuReportQuery(1,"","",session['LOGON.USERID'],selected.rowid,RptType,"")	
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
		 var RptType = getValueById('RptType');
	     var rtn=InsuReportQuery(1,SDate,EDate,session['LOGON.USERID'],"",RptType,"")	                                                
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
/* ����/�޸ĵ���
 */
function openEditWindow(){
	$('#LocalListInfoProWin').show(); 
	$HUI.dialog("#LocalListInfoProWin",{
			title:"�걨��Ϣ",
			height:527,
			width:570,
			collapsible:false,
			modal:true,
		    iconCls: 'icon-w-edit'
	})
	$("#addInfo").form("clear");
	
	init_AddInfoPanel();	
	
}
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
 * ��������
 */
function init_AddInfoPanel(){
	setValueById('SDate',getDefStDate(0));
	setValueById('EDate',getDefStDate(1));
	setValueById('RptDate',getDefStDate(0));
	Options = {
		hospDr: GV.HospDr	
	}
	// �������
	INSULoadDicData('RptType','RTPType' + getValueById('INSUType'),Options); 	
	// ��Ա���
	INSULoadDicData('rylb','AKC021' + getValueById('INSUType'),Options); 
	// states
	INSULoadDicData('States','YAB003' + getValueById('INSUType'),Options); 
	Options = {
		hospDr: GV.HospDr,
		//DicOPIPFlag:"OP"	
	}
	// ҽ�����
	INSULoadDicData('InAdmType','AKA130' + getValueById('INSUType'),Options); 
	// ���������
	setValueById('money','0');
	setValueById('sl','1');
	
	// HIS��Ŀ����
	$HUI.combobox(('#xmbm'),{
		defaultFilter:'4',
		valueField: 'HisCode',
		textField: 'HisDesc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			if(param.q==''){
				return true;	
			}
			param.ClassName = 'web.INSUTarContrastCom';
			param.QueryName= 'DhcTarQuery';
			param.sKeyWord = param.q;
			param.Class = '1';
			param.Type = getValueById('INSUType');
			param.ConType = 'A';
			param.ExpStr = 'N||' + GV.HospDr;
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	})
	Options = {
		defaultFlag:'N',
		hospDr: GV.HospDr	
	}
	// ���Բ����
	INSULoadDicData('DiagCodeMXB','opsp_dise_cod' + getValueById('INSUType'),Options); 
	
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
	})
	
	
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
			 
			setValueById('DoctorCode',rowData.name)
			
			}	
	})
	
	
	
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
	})
	// sex
	$('#Sex').combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{
    			"id" : '��',
    			"text":"��",
    			selected:true
    		},{
    			"id" : 'Ů',
    			"text":"Ů"	
    		},{
    			"id" : 'δ֪',
    			"text":"δ֪"	
    		}]		
	})
}

