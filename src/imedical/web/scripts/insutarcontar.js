/**
 * ҽ�������շ���Ŀ����JS
 * Zhan 201409
 * �汾��V1.0
 * easyui�汾:1.3.2
 * 2019-10-24 tangzf �Ż�����
 */
var grid;
var ConGrid;
var EditIndex=undefined;

var GV={
	fieldobj: '',
	field: '',
	qclass: '',
	ArgSpl: '@'
}

$(function(){
	// ��ѯ���س��¼�
	init_Keyup();
	
	//��ʼ��ҽ��json ����HISUI��ʽ��������
	//GetjsonQueryUrl();
	
	//��ʼ��ҽ������combogrid
	init_InsuType();
	
	//��ʼ����Ŀ����
	init_Type();
	
	//��ʼ�����չ�ϵ
	init_ConType();
	
	//��ʼ��ѯ����
	init_QClase();
	
	//west �շ�grid
	init_dg();
	
	//east �����շ���grid
	init_wdg();
	
	//south ������ϸ��ʷ
	init_Coninfo();
	
	//����Ӧ
	init_layout();
	
	// ���հ�ť
	$HUI.linkbutton("#btnCon", {
		onClick: function () {
			SaveCon();
		}
	});
	$HUI.linkbutton("#btnAdd", {
		onClick: function () {
			AddVirItem();
		}
	});
	$HUI.linkbutton("#btnDelete", {
		onClick: function () {
			DelVirItem();
		}
	});
	$HUI.linkbutton("#rightBtnFind", {
		onClick: function () {
			QueryINSUTarInfoNew();
		}
	});
	$HUI.linkbutton("#btnFind", {
		onClick: function () {
			Query();
		}
	});
	
	// Ĭ����Ч����
	GetConDateByConfig();
	//disinput(true);
	
	//$('#btnAdd').attr("disabled",BDPAutDisableFlag('btnAdd'));
	//$('#btnUpdate').attr("disabled",BDPAutDisableFlag('btnUpdate'));
	//$('#btnDelete').attr("disabled",BDPAutDisableFlag('btnDelete'));
	//$('#btnAdd').attr("disabled",true);	
});
 
/*
 *��ѯHIS�շ���Ŀ���� west grid
 */
function Query(){
	// tangzf 2020-6-17 ʹ��HISUI�ӿ� ��������
	var QClase = getValueById('QClase');
	var KeyWords = getValueById('KeyWords');
	var Type = $('#Type').combobox('getValue'); //��Ŀ���
	var ConType = getValueById('ConType'); 
	var InsuType = $('#insuType').combobox('getValue'); 
	var VirmTarFlag = 'N' // �����շ���Ŀ��־
	var tmpARGUS = KeyWords + GV.ArgSpl + QClase+GV.ArgSpl + Type + GV.ArgSpl + ConType + GV.ArgSpl + VirmTarFlag + GV.ArgSpl + InsuType + GV.ArgSpl + PUBLIC_CONSTANT.SESSION.HOSPID;
	var QueryParam={
		ClassName:'web.DHCINSUTarConTar' ,
		QueryName: 'QueryTarInfo',
		InArgs : tmpARGUS,
	}
	loadDataGridStore('dg',QueryParam);	
}

//���±����¼
function SaveCon(rowIndex){
	
	if( typeof rowIndex == 'number' ||typeof rowIndex == 'string'   ){
		$('#wdg').datagrid('selectRow', rowIndex); // ���ͼ�꼴�ɶ���
	}
	var selInsuData = $('#wdg').datagrid('getSelected');
	var selHisData = $('#dg').datagrid('getSelected');
	if(!selInsuData || !selHisData){
		$.messager.alert('��ʾ','��ѡ��Ҫ���յļ�¼!','info'); 
		return; 
	}
	var editrow=ConGrid.datagrid('getRows')[EditIndex];
	//alert(editrow['conActDate'])
	var sconActDate=$('#dd').datebox('getValue'); //editrow['conActDate']
	var userID=session['LOGON.USERID'];
	var tmptype=$('#Type').combobox('getValue');
	$.messager.confirm('��ʾ','��ȷ��Ҫ�� '+selHisData.desc+' ���ճ� '+selInsuData.desc+' ��?',function(r){
		if(r){
			//������������JS��cspEscape()��������
			//var UpdateStr=""+"^"+selHisData.rowid+"^"+selHisData.code+"^"+eval(selInsuData.rowid)+"^"+selInsuData.code+"^"+tmptype+"^"+GetToday()+"^"+$('#insuType').combobox('getValue')+"^"+"^"
			var UpdateStr=""+"^"+selHisData.rowid+"^"+selHisData.code+"^"+selInsuData.rowid+"^"+selInsuData.code+"^"+tmptype+"^"+sconActDate+"^"+$('#insuType').combobox('getValue')+"^"+"^" + PUBLIC_CONSTANT.SESSION.HOSPID;
			var savecode=tkMakeServerCall("web.DHCINSUTarConTar","Update","","",UpdateStr);
			if(eval(savecode)>=0){
				MSNShow('��ʾ','���ճɹ���',2000);
				movenext(grid)
			}else{
				$.messager.alert('��ʾ','���������շ���ɹ�,������ʧ�ܣ���Ҫ�ֹ�����!','info');  
			}
			ConGridQuery();
		}else{
			ConGrid.datagrid('deleteRow',EditIndex);
			ConAct("insertRow");
		};	
	})	
}
// ���ճɹ��� dg �Զ��л�����һ��
function movenext(objgrid){
	var myselected = objgrid.datagrid('getSelected');
	if (myselected) {
		var index = objgrid.datagrid('getRowIndex', myselected);
		var tmprcnt=objgrid.datagrid('getRows').length-1
		if(index>=tmprcnt){return;}
		objgrid.datagrid('selectRow', index + 1);
	} else {
		objgrid.datagrid('selectRow', 0);
	}	
}
//ɾ����¼
function DelCon(rowIndex){
	if(typeof rowIndex == 'number' ||typeof rowIndex == 'string'){
		$('#coninfo').datagrid('selectRow', rowIndex);
	}
	//if(BDPAutDisableFlag('btnDeleteCon')!=true){$.messager.alert('��ʾ','����Ȩ��,����ϵ����Ա��Ȩ!');return;}
	var tmpdelid=""
	var selected =ConGrid.datagrid('getSelected');
	if (selected){
		if(selected.vsId!=""){
			tmpdelid=selected.vsId
		}
	}	
	if(tmpdelid==""){$.messager.alert('��ʾ','��ѡ��Ҫɾ���ļ�¼!','info');return;}
	
	$.messager.confirm('��ȷ��','��ȷ��Ҫɾ���������ռ�¼��?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.DHCINSUTarConTar","Delete","","",tmpdelid)
			if(eval(savecode)>=0){   
				MSNShow('��ʾ','ɾ���ɹ�!',2000)
			}else{
				$.messager.alert('��ʾ','ɾ��ʧ��!','info');   
			}
			ConGridQuery()
		}else{
			return;	
		}
	});
	
} 
//��ѯ������ʷ��¼
function ConGridQuery(){
	var SelectRow = $('#dg').datagrid('getSelected');
	if(SelectRow){
		var RowId = SelectRow.rowid;	
	}else{
		var RowId = '';
	}
	// tangzf 2020-6-17 ʹ��HISUI�ӿ� ��������
	var QClase = $('#QClase').combobox('getValue');
	var Type = $('#Type').combobox('getValue'); //��Ŀ���
	var ConType = $('#ConType').combobox('getValue'); 
	var InsuType = $('#insuType').combobox('getValue');
	
	var conurl = RowId + GV.ArgSpl + QClase + GV.ArgSpl + Type + GV.ArgSpl + ConType+ GV.ArgSpl + InsuType + GV.ArgSpl + PUBLIC_CONSTANT.SESSION.HOSPID;
	var QueryParam={
		ClassName:'web.DHCINSUTarConTar' ,
		QueryName: 'QueryTarConInfo',
		InArgs : conurl
	}
	loadDataGridStore('coninfo',QueryParam);
}
//ȡ��������
function GetToday(){
	return getDefStDate(0);
}


function AddVirItem(){
	//if(BDPAutDisableFlag('btnAdd')!=true){$.messager.alert('��ʾ','����Ȩ��,����ϵ����Ա��Ȩ!');return;}
	//var UpdateStr=rowid+"^"+ssTarId+"^"+ssHisCode+"^"+flag+"^"+ssvsHisCode+"^"+Type+"^"+ssiActDate+"^"+"^"+"^"
	//w ##class(web.DHCINSUTarConTar).TarChange("","","XY00233^03")
	var selHisData = $('#dg').datagrid('getSelected');
	if(!selHisData){
		$.messager.alert('��ʾ','��������ߵ��б���ѡһ����¼!','info');
		return;	
	}
	var tmphiscode=selHisData.code;
	var tmphisdesc=selHisData.desc;
	var tmptype=$('#right-Type').combobox('getValue');
	var tmptypedesc=$('#right-Type').combobox('getText');
	var tmpsaveinfo=tmphiscode+"^"+tmphisdesc+"^"+tmptype;
	var txtVirCode=getValueById('txtVirCode');
	
	if(txtVirCode == '' || txtVirCode == undefined ){
		$.messager.alert('��ʾ','����������Ŀʱ,�Զ�����벻��Ϊ��','info');
		return;	
	}
	//�����ַ�^�Ĵ���
	txtVirCode = txtVirCode.replace(/\^/g,"");
	$.messager.confirm('��ȷ��','��ȷ��Ҫ��:'+tmphisdesc+"����һ�����Ϊ "+tmptypedesc+" �������շ���Ŀ��?",function(fb){
		if(fb){
			
			var savecode=tkMakeServerCall("web.DHCINSUTarConTar","TarChange","","",tmphiscode+"^"+tmptype+"^"+txtVirCode,PUBLIC_CONSTANT.SESSION.HOSPID);
			if(eval(savecode)>=0){ 
				var UpdateStr=""+"^"+selHisData.rowid+"^"+tmphiscode+"^"+eval(savecode)+"^"+""+"^"+tmptype+"^"+GetToday()+"^"+$('#insuType').combobox('getValue')+"^"+"^" + PUBLIC_CONSTANT.SESSION.HOSPID;
				var savecode=tkMakeServerCall("web.DHCINSUTarConTar","Update","","",UpdateStr)
				if(eval(savecode)>=0){
					MSNShow('��ʾ','�����ɹ���',2000);
				}else{
					$.messager.alert('��ʾ','���������շ���ɹ�,������ʧ�ܣ���Ҫ�ֹ�����!','info');  
				}
			}else{
				if((savecode=="-120")||(savecode=="-130")){savecode="�Ѿ���ͬ�������շ���Ŀ!������������!  ��ֱ��������س���ѯ���ռ��ɣ�"}
				if(savecode=="-110"){savecode="�Ƿ����շ���,�������շ���ά�������⣡"}
				$.messager.alert('��ʾ','ע�⣺'+savecode,'info');   
			}
			ConGridQuery()
		}else{
			return;	
		}
		QueryINSUTarInfoNew();
		setValueById('txtVirCode','');
	});
	
}

function DelVirItem(){
	//var UpdateStr=rowid+"^"+ssTarId+"^"+ssHisCode+"^"+flag+"^"+ssvsHisCode+"^"+Type+"^"+ssiActDate+"^"+"^"+"^"
	//w ##class(web.DHCINSUTarConTar).TarChange("","","XY00233^03")
	//if(BDPAutDisableFlag('btnDeleteTar')!=true){$.messager.alert('��ʾ','����Ȩ��,����ϵ����Ա��Ȩ!');return;}
	var tmpConId=""	//���յ�������Ŀrowid
	var tmpvsHisDesc=""
	var selected =ConGrid.datagrid('getSelected');
	if(!selected){
		$.messager.alert('��ʾ','����ѡ��һ�����ռ�¼��','info');
		return;
	}
	if (selected){
		if(selected.ConId!=""){
			tmpConId=selected.ConId
			tmpvsHisDesc=selected.vsHisDesc
		}
	}	
	if(tmpConId==undefined || tmpConId==""){$.messager.alert('��ʾ','����ѡ��һ�����ռ�¼��','info');return;}
	$.messager.confirm('��ȷ��','��ȷ��Ҫɾ��:'+tmpvsHisDesc+"���������շ���Ŀ��?",function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.DHCINSUTarConTar","DeleteAllCon",tmpConId);
			if(eval(savecode)>=0){ 
				var savecode=tkMakeServerCall("web.DHCINSUTarConTar","TarDelete","","",tmpConId,PUBLIC_CONSTANT.SESSION.HOSPID);
				if(eval(savecode)>=0){
					MSNShow('��ʾ','ɾ���ɹ���',2000);
				}else{
					$.messager.alert('��ʾ','ɾ�����ճɹ�����ɾ�������շ���ʧ��!�������:'+savecode,'info');  
				}
			}else{
				if(savecode=="-101"){savecode="����ɾ��ʵ�ʵ��շ���Ŀ!"}
				$.messager.alert('��ʾ','ɾ��ʧ��!'+savecode,'info');   
			}
			ConGridQuery()
		}else{
			return;	
		}
		QueryINSUTarInfoNew();
		ConGrid.datagrid('unselectAll');
	});
}


//���Ӽ�¼
function ConAct(act){
	//if(BDPAutDisableFlag('btnCon')!=true){$.messager.alert('��ʾ','����Ȩ��,����ϵ����Ա��Ȩ!');return;}
	var lastIndex=0
	
	/*
	var selected = grid.datagrid('getSelected');
	if(!selected){
		$.messager.alert('��Ϣ',"��ѡ��һ���շ��������!");
		return;
	}
	*/
	//alert(ConGrid.datagrid('getRows').length-1)
	if(selHisData==""){
		$.messager.alert('��Ϣ',"��ѡ��һ���շ��������!",'info');
		return;
	}
	if(act.toString()=='insertRow')
	{
		lastIndex = 0; 
		//ConGrid.datagrid('getRows').length>1
		//GetToday()
		ConGrid.datagrid('insertRow',{  
			index: lastIndex,
			row:{
				TarId:'',
				ConId:'',
				vsId:'',
				vsHisCode:selHisData.code,
				vsHisDesc:GetDescByssHisDesc(selHisData.desc),
				typedesc:'',
				conActDate:'',
				coninsutype:$('#insuType').combobox('getText')
			}
		});

	}else{
		lastIndex=ConGrid.datagrid('getRows').length-1;  
	}
	EditIndex=lastIndex
	//getEditRow(EditIndex,'conActDate').val(GetToday())
	ConGrid.datagrid('selectRow', EditIndex);
	ConGrid.datagrid('beginEdit',EditIndex);
	//GetToday()
	var tmpInsuCodeobj=getEditRow(EditIndex,'vsHisCode')
	tmpInsuCodeobj.bind("keyup",function(k){
		if(k.keyCode==13){
			QueryINSUTarInfoNew()
		}
		if(k.keyCode==38 || k.keyCode==40){
			//$('#windiv').focus();			
			$('#wdg').datagrid('getPanel').focus();
		}
		if(k.keyCode==27){
			grid.datagrid('getPanel').focus();
		}
	})
	var tmpInsuDescobj=getEditRow(EditIndex,'vsHisDesc')
	tmpInsuDescobj.bind("keyup",function(k){
		if(k.keyCode==13){
			QueryINSUTarInfoNew()
		}
		if(k.keyCode==38 || k.keyCode==40){
			//$('#windiv').focus();			
			$('#wdg').datagrid('getPanel').focus();
		}
		if(k.keyCode==27){
			grid.datagrid('getPanel').focus();
		}
	})
	tmpInsuDescobj.focus();
	EditIndex = lastIndex;   
}

function QueryINSUTarInfoNew(){
	// tangzf 2020-6-17 ʹ��HISUI�ӿ� ��������
	var QClase = getValueById('right-QClase');
	var KeyWords = getValueById('right-KeyWords');
	var Type = $('#right-Type').combobox('getValue'); //��Ŀ���
	var ConType = "N"; 
	var InsuType = ''; //$('#insuType').combobox('getValue'); 
	var VirmTarFlag = 'Y' // �����շ���Ŀ��־
	
	var tmpurl = KeyWords + GV.ArgSpl + QClase + GV.ArgSpl+ Type + GV.ArgSpl + ConType + GV.ArgSpl + VirmTarFlag + GV.ArgSpl + InsuType + GV.ArgSpl + PUBLIC_CONSTANT.SESSION.HOSPID;	
	var QueryParam = {
		ClassName:'web.DHCINSUTarConTar' ,
		QueryName: 'QueryTarInfo',
		InArgs : tmpurl,
	}
	loadDataGridStore('wdg',QueryParam);
}
function init_layout(){
		////$('#north-panel').css('height',"300px");
		//	$('.center-panel').css('height',"100px");
	var collectButtonLeft=parent.$('.fa-angle-double-left');
	//alert(collectButtonLeft.length)
	if(collectButtonLeft.length>0){
		$("#TDTarDate").hide(); 
		$("#LabelTarDate").hide(); 
		//collectButtonLeft.click(); // �Զ��۵���˵�
		parent.$('.fa-angle-double-left').on('click', function (e) {	
			window.location.reload(true); 	
    	});	
	}
	var collectButtonRight=parent.$('.fa-angle-double-right');
	if(collectButtonRight.length>0){
		$("#TDTarDate").show(); 
		$("#LabelTarDate").show(); 
		parent.$('.fa-angle-double-right').on('click', function (e) {
			//window.location.reload(true);
    	});
	}
	if(window.screen.availWidth<1440){
		//����ͷֱ��ʰ�ť����
		$('#searchTablePanel').find('.hisui-panel').css('width',window.screen.availWidth); 
		$('#searchTablePanel').find('.panel-header').css('width',window.screen.availWidth);
		$('#searchTablePanel').find('.panel').css('width',window.screen.availWidth);
		$('#searchTablePanel').css('overflow','scroll');
	
	}
}
/*
 * Creator: tangzf
 * CreatDate: 2019-6-12
 * Description: ��ѯ���س��¼�
 */
function init_Keyup() {
	//ҽ��Ŀ¼����
	$('#KeyWords').keyup(function(){
		if(event.keyCode==13){
			Query();
		}
	});
	//ҽ��Ŀ¼(ҽ������)
	$('#right-KeyWords').keyup(function(){
		if(event.keyCode==13){
			QueryINSUTarInfoNew();
		}
	});
}
///��ȡ���õ�Ĭ����Чʱ��
///ע�⣺���Ϊ��Ĭ�ϵ�ǰʱ��
function GetConDateByConfig()
{
    var rtnDate="";
	var rtnDate=tkMakeServerCall("web.DHCINSUTarConTar","getConfigDate",PUBLIC_CONSTANT.SESSION.HOSPID);
	if(rtnDate==""){ 
		rtnDate=getDefStDate(0);;
	}
	setValueById('dd',rtnDate);
 }
function GetDicStr(dicCode,CodeVal,index){
	return tkMakeServerCall("web.INSUDicDataCom","GetDicByCodeAndInd",dicCode,CodeVal,index,PUBLIC_CONSTANT.SESSION.HOSPID);
}
function MSNShow(title,msg,time){
	$.messager.popover({
		msg:msg,
		type:'success',
		timeout:time
	})	
}
/*
 * ҽ������combogrid
 */
function init_InsuType(){	
	//�����б�
	//var dicurl=jsonQueryUrl+'web.INSUDicDataCom'+SplCode+"GetDicJSONInfo"+SplCode+"TariType^^"	//GV.ArgSpl
	var insutypecombox=$('#insuType').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'cCode',   
	    textField:'cDesc', 
        rownumbers:true,
        url:$URL,
        onBeforeLoad:function(param){
	        param.ClassName = 'web.INSUDicDataCom';
	        param.QueryName = 'QueryDic1';
	        param.Type = 'TariType';
	        param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;    
	    },
        fit: true,
        pagination: false,
	    columns:[[   
	        {field:'cCode',title:'����',width:60},  
	        {field:'cDesc',title:'����',width:100}  
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
			insutypecombox.combogrid('setValue',data.rows[0].cCode);
		},
		onSelect:function(index,data){
		}
	}); 	
}
/*
 * ��Ŀ����
 */
function init_Type(){
	//var dicurl=jsonQueryUrl+'web.INSUDicDataCom'+SplCode+"GetDicJSONInfo"+SplCode+"SpeItmType^^";	//GV.ArgSpl
	$('.Type').combogrid({  
	    idField:'cCode',   
	    textField:'cDesc', 
        panelWidth:200,   
	    panelHeight:238,
	    editable:false,
        url:$URL,
        onBeforeLoad:function(param){
	        param.ClassName = 'web.INSUDicDataCom';
	        param.QueryName = 'QueryDic1';
	        param.Type = 'SpeItmType';
	        param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;
	    	    
	    },
        columns:[[   
	        {field:'cCode',title:'����',width:60},  
	        {field:'cDesc',title:'����',width:100}
	        
	    ]],
	    onLoadSuccess:function(data){
		    setValueById('Type',data.rows[0].cCode);
		    setValueById('right-Type',data.rows[0].cCode);
		}
	});	
}
/*
 * ���չ�ϵ
 */
function init_ConType(){
	$('#ConType').combobox({   
	    panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: 'A',
			Desc: '��ѯ����',
			selected:true
		},{
			Code: 'Y',
			Desc: '��ѯ�Ѷ�����'
		},{
			Code: 'N',
			Desc: '��ѯδ������'
		}]

	}); 
}
/*
 * ��ѯ����
 */
function init_QClase(){
	$('.QClase').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '1',
			Desc: '��ƴ��',
			selected:true
		},{
			Code: '2',
			Desc: '������'
		},{
			Code: '3',
			Desc: '������'
		}]
	});	
}
/*
 * ��ʼ��west �շ���Ŀ dg
 */
function init_dg(){
	grid=$('#dg').datagrid({
		iconCls: 'icon-save',
		rownumbers:true,
		data:[],
		fit:true,
		striped:true,
		singleSelect: true,
		toolbar:'#dgTB',
		frozenColumns:[[
		]],
		columns:[[
			{ field: 'rowid', title: 'rowid', width: 10, align: 'center',hidden:true},
			{ field: 'code', title: '��Ŀ����', width: 100, align: 'center'},
			{ field: 'desc', title: '��Ŀ����', width: 250, align: 'center'},
			{ field: 'TarUomDesc', title: '��λ', width: 60, align: 'center'},
			{ field: 'TarPrice', title: '����', width: 80, align: 'center'},
			{ field: 'TarActiveFlag', title: '��Ч��־', width: 55, align: 'center'},
			{ field: 'TarSubCateDesc', title: '�շ���Ŀ����', width: 120, align: 'center'},
			{ field: 'TarInpatCateDesc', title: 'סԺ��������', width: 120, align: 'center'},
			{ field: 'TarOutpatCateDesc', title: '�����������', width: 120, align: 'center'},
			{ field: 'TarNewMRCateDesc', title: '�²�����ҳ����', width: 120, align: 'center'},
			{ field: 'TarSpecialFlag', title: '������', width: 55, align: 'center'},
			{ field: 'TarExternalCode', title: '�ⲿ����', width: 100, align: 'center'},
			{ field: 'TarChargeBasis', title: '�շ�����', width: 100, align: 'center'},
			{ field: 'TarEngName', title: '�շ�˵��', width: 100, align: 'center'}/*,
			{ field: 'SubCate', title: 'SubCate', width: 50, align: 'center'},
			{ field: 'AccCate', title: 'AccCate', width: 50, align: 'center'},
			{ field: 'IcCate', title: 'IcCate', width: 50, align: 'center'},
			{ field: 'OcCate', title: 'OcCate', width: 50, align: 'center'},
			{ field: 'EcCate', title: 'EcCate', width: 50, align: 'center'},
			{ field: 'MrCate', title: 'MrCate', width: 50, align: 'center'},
			{ field: 'NewMrCate', title: 'NewMrCate', width: 50, align: 'center'}*/
		]],
		pageSize: 10,
		pagination:true,
        onSelect : function(rowIndex, rowData) {
            ConGridQuery();
        },
        onUnselect: function(rowIndex, rowData) {
        },
	    onLoadSuccess:function(data){
		    selHisData="";
			selInsuData="" 
			EditIndex=undefined;
		}
	});	
}
/*
 * ��ʼ��east �����շ���
 */
function init_wdg(){
	var querycol= [[   
			{field:'rowid',title:'rowid',width:60,hidden:true},
			{field:'code',title:'�����շ������',width:120},
			{field:'desc',title:'�����շ�������',width:130},
			{field: 'TarUomDesc', title: '��λ', width: 60, align: 'center'},
			{field: 'TarPrice', title: '����', width: 60, align: 'center'},
			{field: 'TarSubCateDesc', title: '�շ���Ŀ����', width: 90, align: 'center'}
	        
	]]
	var divgrid=$('#wdg').datagrid({  
		//idField:'dgid',
		data:[],
		rownumbers:true,
		striped:true,
		fixRowNumber:true,
		fit:true,
		fitColumns: true,
		singleSelect: true,
		columns:querycol,
		pagination:true,
		toolbar:'#wdgTB',
		frozenColumns:[[
			{
				field: 'Option', title: '����', width: 50
				,formatter:function(value,data,row){
					return "<a href='#' onclick='SaveCon(\""+row+"\")'>\
					<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png ' border=0/>\
					</a>";
				}
			}
		]],
    	onSelect : function(rowIndex, rowData) {
			
		},
		onDblClickRow : function(rowIndex, rowData) {
			SaveCon();
		},
    	onLoadSuccess:function(){
			
		}
	}); 	
		
}
/*
 * ��ʼ��south ������ʷ
 */
function init_Coninfo(){
	ConGrid=$('#coninfo').datagrid({
		rownumbers:true,
		data:[],
		fit:true,
		fitColumns: true,
		singleSelect: true,
		pageSize:5,
		pageList:[5,10],
		pagination:true,
		frozenColumns:[[
			{
				field: 'undo', title: '����', width: 50
				,formatter:function(value,data,row){
					return "<a href='#' onclick='DelCon(\""+row+"\")'>\
					<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png ' border=0/>\
					</a>";
				}
			}
		]],
		columns:[[
			{field:'TarId',title:'TarId',width:40,hidden:true},
			{field:'ConId',title:'������ĿID',width:80},
			{field:'vsId',title:'����ID',width:70},
			{field:'vsHisCode',title:'�����շ���Ŀ����',width:100,editor:{
				type:'text'	
			}},
			{field:'vsHisDesc',title:'�����շ���Ŀ����',width:200,editor:{
				type:'text'	
			}},
			
			{field:'typedesc',title:'�������',width:90},
			{field:'conActDate',title:'��Ч����',width:75,editor:{
				type:'datebox'	
			}},
			{field:'coninsutype',title:'ҽ�����',width:90},
		]],
		onLoadSuccess:function(){
		},
		onDblClickRow:function(){
			DelCon();
		}
	});	
}
function selectHospCombHandle(){
	//$('#insuType').combobox('clear');
	$('#insuType').combogrid('grid').datagrid('reload');
	//$('#BSYType').combobox('clear');
	$('#Type').combogrid('grid').datagrid('reload');
	$('#right-Type').combogrid('grid').datagrid('reload');	
	GetConDateByConfig();
	Query();
}