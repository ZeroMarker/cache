/**
 * ҽ��Ŀ¼����JS
 * Zhan 201409
 * �汾��V1.0
 * easyui�汾:1.3.2
 */
$(function(){
	GetjsonQueryUrl();
	//�س��¼�
	init_Keyup();
	//ҽԺĿ¼�����б�
	init_INSUTarcSearchPanel();
	//��ʼ�����յ�grid west
	init_dg();
	//ҽ��Ŀ¼(ҽ������) east
	init_wdg();
	//������ϸ��ʷ south
	init_ContraHistory();
	// ����Ӧ
	init_layout();
	//��Ȩ����
	if(BDPAutDisableFlag('btnAdd')==true){$('#btnAdd').linkbutton('disable');}
	if(BDPAutDisableFlag('btnDelete')==true){$('#btnDelete').linkbutton('disable');}
	if(BDPAutDisableFlag('btnDld')==true){$('#btnDld').linkbutton('disable');}
	if(BDPAutDisableFlag('btnUpload')==true){$('#btnUpload').linkbutton('disable');}
	$('#south-panel').panel('collapse');

}); 
//��ѯHIS��������
function Query(){
	var queryParam={
		TarId : '',
		HisDesc : ''	
	}
	ConGridQuery(0,queryParam); //ÿ�β�ѯ����ն�����ʷ
	
	var TarCate=$('#TarCate').combobox('getValue')
	if("0"==TarCate){
		TarCate=""; //ȫ��
	}
	
	var TarDate = getValueById('TarDate'); // 2019-12-19 �շ������� add by tangzf 
	var PrtFlag = 'N'; // �ϰ汾ʹ�ã��°汾����
	var ExpStr = PrtFlag + '|' + TarDate + '|' + PUBLIC_CONSTANT.SESSION.HOSPID;

	var queryParams = {
		ClassName : 'web.INSUTarContrastCom',
		QueryName : 'DhcTarQuery',
		sKeyWord : $('#KeyWords').val(),
		Class : $('#QClase').combobox('getValue'),
		Type : $('#insuType').combobox('getValue'),
		ConType : $('#ConType').combobox('getValue'),
		TarCate : TarCate,
		ActDate : TarDate,
		ExpStr : ExpStr	
	}
	loadDataGridStore('dg',queryParams);
}
//��ѯҽ��Ŀ¼����
function QueryINSUTarInfoNew(field,qclass){
	var fieldVal = getValueById(field);
	var tmpurl=jsonQueryUrl+'web.INSUTarItemsCom'+SplCode+"QueryAll"+SplCode+cspEscape(fieldVal)+ArgSpl+qclass+ArgSpl+cspEscape($('#insuType').combobox('getValue'))+ArgSpl+ArgSpl+cspEscape($('#TarCate').combobox('getValue'))+'|'+cspEscape($('#TarCate').combobox('getText'));
	$('#wdg').datagrid({ url:tmpurl, queryParams: { qid:1}});	
}
function ShowInsuDetlsbyID(inVal,sindex,qclass){
	var url = "dhcinsutareditcom.csp?&InItmRowid=" + inVal+'&AllowUpdateFlag='+'N&Hospital=' + PUBLIC_CONSTANT.SESSION.HOSPID + '&INSUType=' + $('#insuType').combobox('getValue'); //?&ItmRowid=" + rowData.Rowid;
	websys_showModal({
		url: url,
		title: "ҽ��Ŀ¼ά��",
		iconCls: "icon-w-edit",
		width: "855",
		height: "710",
		onClose: function()
		{
			rowData=$('#dg').datagrid('getSelected');
			ConGridQuery(0,rowData);
		}
	});
}
//ȷ�ϲ���������
function SaveCon(rowIndex,selInsuData){
	var selTarData = $('#dg').datagrid('getSelected');
	var sconActDate = $('#dd').datebox('getValue');
	var userID = session['LOGON.USERID'];
	var userName = session['LOGON.USERNAME'];
	if (("" != sconActDate) && (undefined != sconActDate) && ("" != selInsuData.INTIMExpiryDate) && (undefined != selInsuData.INTIMExpiryDate) && compareDate(sconActDate, selInsuData.INTIMExpiryDate)) {
		$.messager.alert("����", "����Ŀ������!��ѡ��������Ŀ!",'info');
		return;
	}
	if( (!selTarData) || (""==selInsuData)||(undefined==selInsuData.rowid)){
    	$.messager.alert('��ʾ', '��ѡ��Ҫ���յļ�¼!','info');
		return;
	}
  	$.messager.confirm('��ʾ', '��ȷ��Ҫ�� ' + selTarData.HisDesc + ' ���ճ� ' + selInsuData.INTIMxmmc + ' ��?', function (r) {
	    if (r) {
	      //������������JS��cspEscape()��������
	      var UpdateStr = "^" + selTarData.TarId + "^" + selTarData.HisCode + "^" + (selTarData.HisDesc) + "^" + selInsuData.rowid + "^" + selInsuData.INTIMxmbm + "^" + (selInsuData.INTIMxmmc) + "^" + "^" + "^" + "^" + 1 + "^" + "^" + sconActDate + "^" + "^" + $('#insuType').combobox('getValue') + "^" + userID + "^" + "^";
	      var savecode = tkMakeServerCall("web.INSUTarContrastCom", "Insert", "", "", UpdateStr);
	      if (eval(savecode) > 0) {
	        MSNShow('��ʾ', '���ճɹ���', 2000);
	        if (selTarData) {
	          var dgindex = $('#dg').datagrid('getRowIndex', selTarData);
	          $('#dg').datagrid('updateRow', { index: dgindex, row: { ConId: eval(savecode), InsuCode: selInsuData.INTIMxmbm, InsuDesc: selInsuData.INTIMxmmc, conActDate: sconActDate, UserDr: userName, ConDate: GetToday(), ConTime: GetTime() } });
	        }
	        movenext($('#dg'));
	      } else {
	      	$.messager.alert('��ʾ', '����ʧ��!','info');
	      }
	      ConGridQuery(0, selTarData);
	    } else {
	    	return false;
	    }
		$('#wdg').datagrid('unselectAll');
  });
}
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

//���ϼ�¼
function DelCon(rowIndex){
	if(typeof rowIndex == 'number' ||typeof rowIndex == 'string'){
		$('#coninfo').datagrid('selectRow', rowIndex);
	}
	var tmpdelid=""
	var selected = $('#coninfo').datagrid('getSelected');
	var selTarData = $('#dg').datagrid('getSelected');
	if (selected){
		if((selected.ConId!="")&&(undefined!=selected.ConId)){    // ����undefined ��֤ DingSH 20170221
			tmpdelid=selected.ConId
		}
	}	
	if(tmpdelid==""){$.messager.alert('��ʾ','��ѡ��Ҫ���ϵļ�¼!','info');return;} 
	
	$.messager.confirm('��ȷ��','��ȷ��Ҫ����������¼��?',function(fb){
		if(fb){
			
			//DingSH 20161204  ����Ѿ��ϴ�
			//��ע��DrAddFlag  Ϊ���Ǳ�ʾĿ¼���ض���û���ϴ�ҽ������
            //      DrAddFlag  Ϊ1�Ǳ�ʾĿ¼�ϴ�ҽ����
           //       DrAddFlag  Ϊ2�Ǳ�ʾĿ¼�����Ѿ����
           //       DrAddFlag  Ϊ3�Ǳ�ʾĿ¼������˲�ͨ
            var InDelFlag=""
			if((selected.DrAddFlag!="")&&(null!=selected.DrAddFlag))
			{
				//InDelFlag=InsuTarConDel(dHandle,UserId,conId,ExpStr) //DHCINSUPort.js  ����ֵ��0:�ɹ���-1:ʧ�� ҽ��Ŀ¼���� ExpStr:"ҽ������^��˱�ʶ^^^"
				 InDelFlag="-1" ;//������
				
			}
			if (InDelFlag=="-1"){$.messager.alert('��ʾ','����ҽ�����ĵĶ�������ʧ�ܣ����������ϱ��ض��չ�ϵ!','info'); return ;}
			
			
			var savecode=tkMakeServerCall("web.INSUTarContrastCom","Abort",tmpdelid,"")
			if(eval(savecode)>=0){
				//$.messager.alert('��ʾ','ɾ���ɹ�!');  
				MSNShow('��ʾ','���ϳɹ���',2000) 
				if (selTarData) {
					var dgindex = $('#dg').datagrid('getRowIndex', selTarData);
					$('#dg').datagrid('updateRow',{index: dgindex,row: {ConId:'',InsuCode:'',InsuDesc:''}});
				}
			}else{
				$.messager.alert('��ʾ','����ʧ��!','info');   
			}
			ConGridQuery(0,selTarData)
		}else{
			return;	
		}
	});
	
}
//��ѯ������ʷ��¼
function ConGridQuery(rowIndex,rowData){
	var selTarData=rowData;
	var conurl=jsonQueryUrl+'web.INSUTarContrastListCom'+SplCode+"QueryConList"+SplCode+selTarData.TarId+ArgSpl+$('#insuType').combobox('getValue')+ArgSpl;
	$('#coninfo').datagrid({ url: conurl, queryParams: {qid:1}});
}

function fillConGridEdit(rowIndex,rowData){
	var dateVal = $('#dd').datebox('getValue');
	if (("" != dateVal) && (undefined != dateVal) && ("" != rowData.INTIMExpiryDate) && (undefined != rowData.INTIMExpiryDate) && compareDate(dateVal, rowData.INTIMExpiryDate)) {
		//$.messager.alert("����", "����Ŀ������!��ѡ��������Ŀ!",'info');
		$('#wdg').datagrid('unselectRow',rowIndex);
		return false;
	}
}  
//����EXCEL
function Export(){
	try
	{
		var TarCate=$('#TarCate').combobox('getValue');
		if("0"==TarCate){TarCate=""}
		var title="";
		//ExportMed=1;
		//var tmpurl=jsonQueryUrl+'web.INSUTarContrastCom'+SplCode+"DhcTarQuery"+SplCode+cspEscape($('#KeyWords').val())+ArgSpl+$('#QClase').combobox('getValue')+ArgSpl+$('#insuType').combobox('getValue')+ArgSpl+$('#ConType').combobox('getValue')+ArgSpl+TarCate+ArgSpl+ArgSpl
		//ExportTitle="^^ҽԺ�շ������^ҽԺ�շ�������^��λ^�շ����^�շ�����^����^����ID^^ҽ������^ҽ������^^ҽ�����^ҽ����λ^�Ը�����^ҽ���������^��Ŀ�ȼ�^��Ч����^^���Ʊ�־^����^HIS¼������^��ע^����Ա^��������^����ʱ��^ʧЧ����^��׼�ĺ�"
		//ExportPrompt(tmpurl)
		
		ExportMed=2;
		var selHosDr=""
		if($("#_HospList").length>0){selHosDr=PUBLIC_CONSTANT.SESSION.HOSPID}
		var tmprqurl=jsonQueryUrl+'web.INSUTarContrastCom'+SplCode+"DhcTarQuery"+SplCode+"InsuTarcontrast.rpx&sKeyWord="+cspEscape($('#KeyWords').val())+"&Class="+$('#QClase').combobox('getValue')+"&Type="+$('#insuType').combobox('getValue')+"&ConType="+$('#ConType').combobox('getValue')+"&TarCate="+TarCate+"&ActDate="+$("#ActDate").datebox('getValue')+"&ExpStr=||" + selHosDr;
		ExportPrompt(tmprqurl)
		
		//var rtn = tkMakeServerCall("websys.Query","ToExcel","excelname","web.INSUTarContrastCom","DhcTarQuery",cspEscape($('#KeyWords').val()),$('#QClase').combobox('getValue'),$('#insuType').combobox('getValue'),$('#ConType').combobox('getValue'),$('#TarCate').combobox('getValue'),"","");
		//var rtn = tkMakeServerCall("web.INSUJSONBuilder","ToExcel","excelname","web.INSUTarContrastCom","DhcTarQuery",cspEscape($('#KeyWords').val())+ArgSpl+$('#QClase').combobox('getValue')+ArgSpl+$('#insuType').combobox('getValue')+ArgSpl+$('#ConType').combobox('getValue')+ArgSpl+$('#TarCate').combobox('getValue')+ArgSpl+ArgSpl);
		//location.href = rtn;
		return;
	} catch(e) {
		$.messager.alert("����",e.message,'info');
		$.messager.progress('close');
	};
}
function isEditing(objgrid){
	if (EditIndex == undefined){return true}
	if (objgrid.datagrid('validateRow', EditIndex)){
		//var ed = grid.datagrid('getEditor', {index:EditIndex,field:'INSUDigCode'});
		//var productname = $(ed.target).combobox('getText');
		//grid.datagrid('getRows')[EditIndex]['INSUDigCode'] = productname;
		objgrid.datagrid('endEdit', EditIndex);
		
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

//�ϴ�ҽ��Ŀ¼����
function Upload(){
	//var rtnflag=INSUUpLoadConAudit($('#insuType').combobox('getValue')); tangzf 2019-11-12 '-'
	var UserId = session['LOGON.USERID'];
	var ConDr = '';
	var InsuType = $('#insuType').combogrid('getValue');
	var ActDate = getValueById('ActDate');
	//alert(InsuType)
	if(InsuType == '' ){
		$.messager.alert('��ʾ','ҽ�����Ͳ���Ϊ��','info');	
		return;	
	}
	if( ActDate == '' ){
		$.messager.alert('��ʾ','��Ч���ڲ���Ϊ��','info');	
		return;	
	}
	var ExpString = InsuType + '^^' + ActDate; //ҽ������^^��Ч����^
	var rtnflag = InsuTarConUL('0',UserId,ConDr,ExpString);
	if(rtnflag == "0"){
		$.messager.alert('��ʾ','�����ϴ��ɹ�!','info');
	}else{
		$.messager.alert('��ʾ','�����ϴ�ʧ��!','info');
	}

}
//����ҽ��Ŀ¼
function Download(){
	var rtnflag=InsuBasDL($('#insuType').combobox('getValue'),"")
	if(rtnflag=="0"){
		$.messager.alert('��ʾ','ҽ��Ŀ¼����ʧ��!','info')
	}else{
		$.messager.alert('��ʾ','ҽ��Ŀ¼���سɹ�!','info')
	}

}
// ͨ����������(�շ���Ŀά��) ���ӹ��� ���Ҵ����շ������ �Զ���ֵ����ѯ
function AutQuery(){
	if(TarCode!=""){
		$('#QClase').combobox('setValue','2')
		$('#KeyWords').val(TarCode)
		Query()
	}	
}
function GetDicStr(dicCode,CodeVal,index){
	return tkMakeServerCall("web.INSUDicDataCom","GetDicByCodeAndInd",dicCode,CodeVal,index,PUBLIC_CONSTANT.SESSION.HOSPID)
}


///��ȡ���õ�Ĭ����Чʱ��
///ע�⣺���Ϊ��Ĭ�ϵ�ǰʱ��
function GetConDateByConfig()
{
    var rtnDate=""
	var rtnDate=GetDicStr("SYS","INSUCONACTDATE",6);
	if(rtnDate==""){ 
		rtnDate=curDate();
	}
	return rtnDate; 
 }
 ///��ȡ��ǰʱ��,֧��ʱ���ʽ
 function curDate() {
	return getDefStDate(0);
 }
 
//add by Huang SF
//�Ƚ����ڴ�С��֧��ʱ���ʽ:
///    1 MM/DD/YYYY
///    3 YYYY-MM-DD
///    4 DD/MM/YYYY
///����ֵ��true:One��,false:else
function compareDate(DateOne, DateTwo,Flag) {
  var Flag=tkMakeServerCall("websys.Conversions","DateFormat")
  if ("1"==Flag){
	  if(Date.parse(DateOne) > Date.parse(DateTwo)) {
		  return true;
  	  } else {
	  	  return false;
	  }
  }
  if("3"==Flag){
	  var DateOneTemp=new Date(DateOne.replace("-","/"));
	  var DateTwoTemp=new Date(DateTwo.replace("-","/"));
	  if(Date.parse(DateOneTemp) > Date.parse(DateTwoTemp)) {
		  return true;
  	  } else {
	  	  return false;
	  }
  }
  if("4"==Flag){
	var OneMonth = DateOne.substring(3, DateOne.lastIndexOf("/"));
  	var OneDay = DateOne.substring(0, DateOne.indexOf("/"));
  	var OneYear = DateOne.substring(DateOne.lastIndexOf("/")+1,DateOne.length);
  	var TwoMonth = DateTwo.substring(3, DateTwo.lastIndexOf("/"));
  	var TwoDay = DateTwo.substring(0, DateTwo.indexOf("/"));
  	var TwoYear = DateTwo.substring(DateTwo.lastIndexOf("/")+1,DateTwo.length);
  	if (Date.parse(OneMonth + "/" + OneDay + "/" + OneYear) > Date.parse(TwoMonth + "/" + TwoDay + "/" + TwoYear)) {
    	return true;
  	} else {
   	 return false;
  	}  
  }
  return false;
}
/**
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
	$('.textbox').keydown(function (e) {
		if (e.keyCode == 13) {
			btnFindInsu_Click(e.target.id)	
		}
	});
}
function btnFindInsu_Click(code){
	switch (code) {
		case 'InsuCode':
			QueryINSUTarInfoNew('InsuCode','2');
			break;
		case 'InsuDesc':
			QueryINSUTarInfoNew('InsuDesc','3');
			break;
		case 'Insurj':
			QueryINSUTarInfoNew('Insurj','1');
			break;
		case 'PZWH':
			QueryINSUTarInfoNew('PZWH','5');
			break;
		default:
			break;
	}
}
//south ����
function init_layout(){
	var collectButtonLeft=parent.$('.fa-angle-double-left');

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
		$('#searchTablePanel').find('.hisui-panel').css('width',window.document.body.offsetWidth); 
		$('#searchTablePanel').find('.panel-header').css('width',window.document.body.offsetWidth);
		$('#searchTablePanel').find('.panel').css('width',window.document.body.offsetWidth);
		$('#searchTablePanel').find('.panel').css('height','107px');
		$('#searchTablePanel').css('overflow','scroll');
		
	}
}
//ҽ��Ŀ¼����(HIS) ��ѯ������ʼ��
function init_INSUTarcSearchPanel() { 
	var dicurl = jsonQueryUrl + 'web.INSUDicDataCom' + SplCode + "GetDicJSONInfo" + SplCode + "TariType^^";	//ArgSpl
	// ҽ������
	var diccombox = $('#insuType').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'INDIDDicCode',   
	    textField:'INDIDDicDesc', 
      	rownumbers:true,
      	fit: true,
      	pagination: false,
      	editable:false,
      	url:dicurl,
	    columns:[[   
	        {field:'INDIDDicCode',title:'����',width:60},  
	        {field:'INDIDDicDesc',title:'����',width:100}
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
			$('#insuType').combogrid('grid').datagrid('selectRow',0);
			AutQuery();
		}
	}); 
	//���չ�ϵ
	$('#ConType').combobox({  
	    panelHeight:200, 
	    valueField:'Code',   
	    textField:'Desc',
	    editable:false,
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
		},{
			Code: '0',
			Desc: '��ѯδ�ϴ���'
		},{
			Code: '1',
			Desc: '��ѯ���ϴ���'
		},{
			Code: '2',
			Desc: '��ѯ�������'
		},{
			Code: '3',
			Desc: '��ѯδ�����'
		}]
	}); 
	// ��Ŀ����
	var TarCateurl=jsonQueryUrl+'web.INSUTarContrastCom'+SplCode+"GetTarCate"+SplCode+session['LOGON.GROUPID']+ArgSpl ; //���� ��ȫ�鵽�շ����������
	$('#TarCate').combogrid({  
	    panelWidth:350,   
	    panelHeight:260,  
	    idField:'Rowid',   
	    textField:'Desc',
	    editable:false, 
      	rownumbers:true,
      	fit: true,
      	pagination: false,
      	url:TarCateurl,
	    columns:[[   
	        {field:'Rowid',title:'Rowid',width:60},  
	        {field:'Desc',title:'����',width:100}
	    ]],
		fitColumns: true,
		onLoadSuccess:function(data){
			if(data.rows.length > 0){
				$('#TarCate').combogrid('grid').datagrid('selectRow',0);
			}	
		}
	});
	// ��ѯ����
	$('#QClase').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    editable:false,
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
//ҽ��Ŀ¼����grid
function init_dg() { 
	grid=$('#dg').datagrid({
		fit:true,
		striped:true,
		singleSelect: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		cache:true,
		toolbar:'#dgTB',
		pagination:true,
		columns:[[
			{field:'HisCode',title:'�շ������',width:110},
			{field:'HisDesc',title:'�շ�������',width:120},
			{field:'HISSpecification',title:'HIS���',width:65},
			{field:'HISDosage',title:'HIS����',width:65},
			{field:'Price',title:'����',width:60,align:'right',formatter:function(val,data,index){
				val = val || 0; // undefined
				return parseFloat(val).toFixed(2);
			}},
			{field:'Cate',title:'����',width:60},
			{field:'InsuCode',title:'ҽ������',width:110},
			{field:'InsuDesc',title:'ҽ������',width:120},
			{field:'PZWH',title:'HIS��׼�ĺ�',width:95},
			{field:'factory',title:'HIS����',width:95},
			{field:'InsuGG',title:'ҽ�����',width:80},
			{field:'InsuDW',title:'ҽ����λ',width:80},
			{field:'InsuSeltPer',title:'�Ը�����',width:80},
			{field:'DW',title:'��λ',width:65,hidden:true},
			{field:'InsuCate',title:'ҽ������',width:55,hidden:true},
			{field:'InsuClass',title:'��Ŀ�ȼ�',width:55,hidden:true},
			{field:'conActDate',title:'��Ч����',width:55,hidden:true},
			{field:'index',title:'���',width:55,hidden:true},
			{field:'LimitFlag',title:'�ⲿ����',width:55,hidden:true},
			{field:'HISPutInTime',title:'HIS¼��ʱ��',width:75,hidden:true},
			{field:'SubCate',title:'����',width:50,hidden:true},
			{field:'Demo',title:'�շ��ע',width:100,hidden:true},
			{field:'UserDr',title:'������',width:55,hidden:true},
			{field:'ConDate',title:'��������',width:65,hidden:true},
			{field:'ConTime',title:'����ʱ��',width:65,hidden:true},
			{field:'EndDate',title:'��������',width:65,hidden:true},
			{field:'ConQty',title:'��������',width:55,hidden:true},
			{field:'TarId',title:'TarId',width:60,hidden:true},
			{field:'ConId',title:'ConId',width:10,hidden:true},
			{field:'InsuId',title:'InsuId',width:10,hidden:true},

		]],
        onSelect : function(rowIndex, rowData) {
	        setValueById('InsuCode','')
	        setValueById('InsuDesc','')
	        setValueById('Insurj','')
	        setValueById('PZWH','')
		    ConGridQuery(rowIndex, rowData);
			//-----------tangzf 2019-6-14 �Զ�����������Ƶ�ҽ��Ŀ¼-------------->
			if(getValueById('csconflg'))  //�����Ƿ����ҽ��Ŀ¼�ж� + DingSH 20200410
			{
				var insuDescObj=document.getElementById('InsuDesc');
				rowData.HisDesc ? insuDescObj.value = rowData.HisDesc.toString().substring(0,5):'';
				QueryINSUTarInfoNew('InsuDesc','3');
			}
			//<--------------------------------------------------------------------
        },
        onUnselect: function(rowIndex, rowData) {
        },
        onBeforeLoad:function(param){
	    	//alert(new Date().getSeconds())
	    },
	    onLoadSuccess:function(data){
		   // alert(new Date().getSeconds())
		}
	});	
}
//ҽ��Ŀ¼(ҽ������)grid
function init_wdg() { 
	var querycol= [[   
		{field:'rowid',title:'rowid',width:60,hidden:true},
		{field:'INTIMxmbm',title:'ҽ������',width:110},
		{field:'INTIMxmmc',title:'ҽ������',width:120},
		{field:'INTIMxmlb',title:'��Ŀ���',width:55,hidden:true},
		{field:'INTIMjx',title:'����',width:65},
		{field:'INTIMgg',title:'���',width:65},
		{field:'INTIMdw',title:'��λ',width:65},
		{field:'INTIMzfbl1',title:'�Ը�����',width:65},
		{field:'INTIMpzwh',title:'��׼�ĺ�',width:90},
		{field:'INTIMyf',title:'�÷�',width:60,hidden:true},
		{field:'INTIMyl',title:'����',width:60,hidden:true},
		{field:'INTIMspmc',title:'��Ʒ����',width:80,hidden:true},
		{field:'INTIMbzjg',title:'��׼�۸�',width:60,hidden:true},
		{field:'INTIMsjjg',title:'ʵ�ʼ۸�',width:60,hidden:true},
		{field:'INTIMzgxj',title:'����޼�',width:65},
		{field:'INTIMzfbl2',title:'�����Ը�����',width:60,hidden:true},
		{field:'INTIMzfbl3',title:'�Ը�����3',width:65},
		{field:'INTIMbpxe',title:'�����޶�',width:60,hidden:true},
		{field:'INTIMbz',title:'��ע',width:100,hidden:true},
		{field:'INTIMsl',title:'����',width:60,hidden:true},
		{field:'INTIMsfdlbm',title:'�������',width:65},
		{field:'INTIMsfdlbmDesc',title:'��������',width:65},
		{field:'INTIMsfxmbm',title:'ҽ�����',width:60,hidden:true},
		{field:'INTIMxmrj',title:'ƴ����',width:55,hidden:true},
		{field:'INTIMtxbz',title:'������Ŀ��־',width:60,hidden:true},
		{field:'INTIMtjdm',title:'ͳ�ƴ���',width:65},
		{field:'INTIMflzb1',title:'�Ƿ�ҽ����Ŀ',width:60,hidden:true},
		{field:'INTIMflzb2',title:'�Ƿ���Ч',width:60,hidden:true},
		{field:'INTIMflzb3',title:'����ָ��3',width:70},
		{field:'INTIMflzb4',title:'����ָ��4',width:60,hidden:true},
		{field:'INTIMflzb5',title:'����ָ��5',width:60,hidden:true},
		{field:'INTIMflzb6',title:'����ָ��6',width:60,hidden:true},
		{field:'INTIMflzb7',title:'����ָ��7',width:60,hidden:true},
		{field:'INTIMspmcrj',title:'��Ʒ���Ʊ���',width:60,hidden:true},
		{field:'INTIMljzfbz',title:'�ۼ�������־',width:60,hidden:true},
		{field:'INTIMyyjzjbz',title:'ҽԺ���ӱ�־',width:60,hidden:true},
		{field:'INTIMyysmbm',title:'ҽԺ��Ŀ����',width:60,hidden:true},
		{field:'INTIMfplb',title:'��Ʊ���',width:60,hidden:true},
		{field:'INTIMDicType',title:'Ŀ¼���',width:60,hidden:true},
		{field:'Index',title:'���',width:60,hidden:true},
		{field:'LimitFlag',title:'������ҩ��־',width:60,hidden:true},
		//{field:'INTIMUserDr',title:'��Ŀ�����',width:60},
		{field:'INTIMDate',title:'��Ŀ��������',width:75,hidden:true},
		{field:'INTIMTime',title:'��Ŀ����ʱ��',width:75,hidden:true},
		//{field:'INTIMADDIP',title:'�����IP',width:70},
		{field:'INTIMActiveDate',title:'��Ŀ��Ч����',width:75,hidden:true},
		{field:'INTIMUnique',title:'����Ψһ��ʶ��',width:75,hidden:true},
		{field:'INTIMExpiryDate',title:'��Ŀ��������',width:75,hidden:true}
	]]
	var divgrid=$('#wdg').datagrid({  
		//rownumbers:true,
		data: {"total":0,"rows":''},
		fixRowNumber:true,
		iconCls: 'icon-save',
		striped:true,
		singleSelect: true,
		fit:true,
		columns:querycol,
		toolbar:'#wdgTB',
		frozenColumns:[[
			{
				field: 'Option', title: '����', width: 50
				,formatter:function(value,rowData,index){
					return "<a href='#' onclick='SaveCon("+index+','+JSON.stringify(rowData)+")'>\
					<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png ' border=0/>\
					</a>";
				}
			}
		]],
		rowStyler: function(index,row){
		},
		pagination:true,
		onSelect : function(rowIndex, rowData) {
			fillConGridEdit(rowIndex,rowData);
		},
		onLoadSuccess:function(data){
		},
		onDblClickRow:function(index,row){
			SaveCon(index,row);
		}	
	
	}); 
	//20180611 DingSH  Ĭ����Ч����combobox
	$('#dd').datebox({
			onSelect: function(date){
				var ed = $('#coninfo').datagrid('getEditor', {index:0,field:'conActDate'});
				$(ed.target).datebox('setValue',$('#dd').datebox('getValue'));
			}
		});
	$('#dd').datebox('setValue', GetConDateByConfig());
}
function init_ContraHistory() { 
	$HUI.datagrid('#coninfo',{
		height: 150,
		border:false,
		fitColumns: false,
		singleSelect: true,
		data: [],
		frozenColumns:[[
			{field:'undo',title:'����',width:50
				,formatter:function(value,data,row){
					if(data.InsuCode&&data.InsuCode!=""){
						return "<a href='#' onclick='DelCon(\""+row+"\")'>\
						<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png ' border=0/>\
						</a>";
					}
				}
			}
		]],
		columns:[[
			{field:'ConId',title:'ConId',width:5,hidden:true},
			{field:'InsuId',title:'Ŀ¼��ϸ��Ϣ',width:93,formatter:function(value,row,index){
				if(undefined==value){value=""}
				return value == '' ? '' : ('<a href="#" onClick="ShowInsuDetlsbyID(' + value + ',' + index + ',' + 10 + ')">' + value + '</a>');
			}},
			{field:'Insurj',title:'ƴ����',width:60},
			{field:'InsuCode',title:'ҽ������',width:80},
			{field:'InsuDesc',title:'ҽ������',width:150},
			{field:'PZWH',title:'��׼�ĺ�'},
			{field:'InsuGG',title:'ҽ�����',width:100},
			{field:'InsuDW',title:'ҽ����λ',width:100},
			{field:'InsuSeltPer',title:'�Ը�����',width:100},
			{field:'InsuClass',title:'��Ŀ�ȼ�',width:65},
			{field:'conActDate',title:'������Ч����',width:100,editor:{type:'datebox'}},
			{field:'TblConUser',title:'������',width:65},
			{field:'ExDate',title:'Ŀ¼ʧЧ����',width:100},
			{field:'InsuCate',title:'��Ʊ���',width:65},
			{field:'DrAddFlag',title:'״̬',width:60,hidden:true},
			{field:'DrAddFlagDesc',title:'״̬',width:65},
			{field:'ConQty',title:'��������',width:65},
			{field:'PatTypeDr',title:'��Ա���',width:65},
			{field:'Amount',title:'����',width:40},
			{field:'DicType',title:'ҽ��������',width:80},
			{field:'ZText',title:'���ձ�ע',width:80},
			{field:'Date',title:'��������',width:70},
			{field:'Time',title:'����ʱ��',width:65},
			{field:'ADDIP',title:'�޸Ļ���',width:80},
			{field:'Unique',title:'����Ψһ��',width:80},
			{field:'ExpiryDate',title:'����ʧЧ����',width:100},
			{field:'UpLoadDate',title:'�ϴ�����',width:80},
			{field:'UpLoadTime',title:'�ϴ�ʱ��',width:70},
			{field:'DownLoadDate',title:'��������',width:80},
			{field:'DownLoadTime',title:'����ʱ��',width:80},
			{field:'LastModDate',title:'����޸�����',width:100},
			{field:'LastModTime',title:'����޸�ʱ��',width:100}
		]],
		pageSize:5,
		pageList:[5,10],
		pagination:true,
		onLoadSuccess:function(data){
			/*ConGrid.datagrid('selectRecord', selTarData.ConId);
			$('#windiv').hide();
			ConAct("insertRow");*/ //tangzf2019-6-13
		},
		onDblClickRow:function(){
			DelCon();
		}
	});
	// ���չ��
	$('#south-panel').panel({
    	onCollapse:function(){
			resizeLayout('Collapse');
    	},
    	onExpand:function(){
	    	resizeLayout('Expand');
			
	    }
	});

}

function MSNShow(title,msg,time){
	$.messager.popover({
		msg:msg,
		type:'success',
		timeout:time
	})	
}
/*
 * ������ϸ����Ӧ
 */
function resizeLayout(type){
	var height;
	var top ;
	if(type == 'Collapse'){
		height = window.document.body.offsetHeight - 164  - 50 - 35 + 'px'; // page - north - south(collapse) - tabs = dg height
		top =   window.document.body.offsetHeight   - 50 - 35  + 11 +'px'; // dg height + padding10px + north
		$('.center-panel').css('height',height);
		$('.layout-panel-south').css('top',top);
		$('#dg').datagrid('resize');
		$('#wdg').datagrid('resize');
	}else  if(type == 'Expand'){
		height = window.document.body.offsetHeight - 164  - 205 - 35 + 'px'; // page - north - south(Expand) - tabs = dg height
		top =   window.document.body.offsetHeight   - 205 - 35  + 12 +'px'; // dg height + padding10px + north
		$('.center-panel').css('height',height);
		$('.layout-panel-south').css('top',top);
		$('#dg').datagrid('resize');
		$('#wdg').datagrid('resize');
	}		
}
/*
 * �Զ�ƥ��
 */
function autoMatch(type){
	var selectDGRow = $('#dg').datagrid('getSelected');
	if(!selectDGRow || selectDGRow.TarId == ''){
		$.messager.alert('��ʾ','��ѡ��һ������','info');
		return;	
	}
	switch (type) {
		case 'ApprovalNumber': // ��׼�ĺ�
			if(selectDGRow.PZWH == '' || selectDGRow.PZWH == '-'){
				$.messager.alert('��ʾ','��ѡ���ݵ���׼�ĺ�Ϊ��','info');
				return;	
			}
			setValueById('PZWH',selectDGRow.PZWH);
			QueryINSUTarInfoNew('PZWH','2');
			break;
		case 'Desc': // ����
			setValueById('InsuDesc',selectDGRow.HisDesc);
			QueryINSUTarInfoNew('InsuDesc','3');
			break;
		default:
			break;
	}
}
function selectHospCombHandle(){
	$('#insuType').combogrid('grid').datagrid('reload');
	$('#TarCate').combogrid('grid').datagrid('reload');
	$('#dd').datebox('setValue', GetConDateByConfig());
	Query();
	
}
