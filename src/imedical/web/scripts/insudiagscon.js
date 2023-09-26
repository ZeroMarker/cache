/**
 * ҽ����϶���JS
 * Zhan 201409
 * �汾��V1.0
 * easyui�汾:1.3.2
 */
var grid;
var ConGrid;
var ArgSpl="@"
$(function(){

	//GetjsonQueryUrl();
	//�س��¼�
	init_Keyup();
	//ҽ��Ŀ¼����(HIS)�����б�
	init_INSUTarcSearchPanel();
	//��ʼ�����յ�grid west
	init_dg();
	//ҽ��Ŀ¼(ҽ������) east
	init_wdg();
	//������ϸ��ʷ south
	init_ContraHistory();
	//
	init_layout();
	$('#south-panel').panel('collapse');
	
	$('#dd').datebox('setValue', GetConDateByConfig());

	
});


//��ѯ��϶�������
function Query(){
	// tangzf 2020-6-19 ��ΪHISUI�ӿڼ�������
	var tmpARGUS=$('#insuType').combobox('getValue') + ArgSpl + ($('#KeyWords').val())+ArgSpl+$('#QClase').combobox('getValue')+ArgSpl+$('#ConType').combobox('getValue')+ArgSpl + PUBLIC_CONSTANT.SESSION.HOSPID;
	var queryParams = {
		ClassName : 'web.INSUDiagnosis',
		QueryName : 'QueryDiagnosInfo',
		ExpStr : tmpARGUS,	
	}
	loadDataGridStore('dg',queryParams);
	var tmpObj={
		Rowid:''	
	}
	ConGridQuery('',tmpObj);
}

//��ѯҽ�����Ŀ¼����
function QueryINSUInfoNew(){
	// tangzf 2020-6-19 ��ΪHISUI�ӿڼ�������
	if(getValueById('right-QClase')==''){
		$.messager.alert('��ʾ','�ؼ��ֲ���Ϊ��','error');
		return;	
	}
	var queryParams = {
		ClassName : 'web.INSUDiagnosis',
		QueryName : 'QueryDiagnosis',
		QType : $('#insuType').combobox('getValue'),
		QKWords : getValueById('right-QClase') + "@" + getValueById('right-KeyWords'),
		HospDr : PUBLIC_CONSTANT.SESSION.HOSPID	
	}
	loadDataGridStore('wdg',queryParams);	
}
 
//��ѯ������ʷ��¼
function ConGridQuery(rowIndex,rowData){
	// tangzf 2020-6-19 ��ΪHISUI�ӿڼ�������
	var queryParams = {
		ClassName : 'web.INSUDiagnosis',
		QueryName : 'QueryDiagnosCon',
		ExpStr : $('#insuType').combobox('getValue') + '@' + rowData.Rowid,
		HospDr : PUBLIC_CONSTANT.SESSION.HOSPID	
	}
	loadDataGridStore('coninfo',queryParams);	
}
//���±����¼
function SaveCon(rowIndex){
	if( typeof rowIndex == 'number' ||typeof rowIndex == 'string'   ){
		$('#wdg').datagrid('selectRow', rowIndex); // ���ͼ�꼴�ɶ���
	}
	var selInsuData = $('#wdg').datagrid('getSelected');
	var selHisData = $('#dg').datagrid('getSelected');
	
	if(!selHisData || !selInsuData){
		$.messager.alert('��ʾ','��ѡ��һ����¼���ܶ���!','info');	
		return;		
	}
	var sconActDate = getValueById('dd');
	var userID = session['LOGON.USERID'];
	var hisNote = getValueById('HisNotecon');

	$.messager.confirm('��ʾ','��ȷ��Ҫ�� '+selHisData.HisICDDesc+' ���ճ� '+selInsuData.bzmc+' ��?',function(r){
		if(r){
			//������������JS��cspEscape()��������
			var UpdateStr="^"+selHisData.Rowid+"^"+selHisData.HisICDCode+"^"+selHisData.HisICDDesc+"^"+selInsuData.INDISRowid+"^"+selInsuData.bzbm+"^"+selInsuData.bzmc+"^"+$('#insuType').combobox('getValue')+"^"+sconActDate+"^"+userID+"^^^^^"+hisNote+"^^^^^";
			var savecode=tkMakeServerCall("web.INSUDiagnosis","SaveCont",UpdateStr)
			if(savecode==null || savecode==undefined) savecode=-1
			if(eval(savecode)>=0){
				//$.messager.alert('��ʾ','����ɹ�!');
				MSNShow('��ʾ','���ճɹ���',2000)
				//grid.datagrid('selectRow', EditIndex + 1);  
				var dgselected=""
				var dgselectedobj = grid.datagrid('getSelected');	//->dgselected
				if (dgselectedobj) {
					dgselected = grid.datagrid('getRowIndex', dgselectedobj);
				}
				if (dgselected>=0) {
					//var dgindex = grid.datagrid('getRowIndex', dgselected);
					grid.datagrid('updateRow',{index: dgselected,row: {ConID:eval(savecode),INSUDigCode:selInsuData.bzbm,INSUDigDesc:selInsuData.bzmc,ConActDate:sconActDate,ConUser:session['LOGON.USERNAME']}});
				}
				movenext(grid)
			}else{
				$.messager.alert('��ʾ','����ʧ��!','info');   
			}
		}
	})
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
//ɾ����¼
function DelCon(rowIndex){
	if(typeof rowIndex == 'number' ||typeof rowIndex == 'string'){
		$('#coninfo').datagrid('selectRow', rowIndex);
	}
	//if(BDPAutDisableFlag('btnDelete')!=true){$.messager.alert('��ʾ','����Ȩ��,����ϵ����Ա��Ȩ!');return;}
	var tmpdelid=""
	var selected = $('#coninfo').datagrid('getSelected');
	if (selected){
		if((selected.ConId!="")&&(undefined!=selected.ConId)){  //DingSH20170222
			tmpdelid=selected.ConId;
		}
	}	
	if(tmpdelid==""){$.messager.alert('��ʾ','��ѡ��Ҫɾ���ļ�¼!','info');return;}
	
	$.messager.confirm('��ȷ��','��ȷ��Ҫɾ��������¼��?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.INSUDiagnosis","DelCont",tmpdelid)
			if(eval(savecode)>=0){
				//$.messager.alert('��ʾ','ɾ���ɹ�!'); 
				MSNShow('��ʾ','ɾ���ɹ���',2000);
				movenext(grid)  
			}else{
				$.messager.alert('��ʾ','ɾ��ʧ��!','info');   
			}
		}else{
			return;	
		}
	});
	
}
function AutoCon(){
	var tmpinsutype=$('#insuType').combobox('getValue')
	var userID=session['LOGON.USERID'];
	if(""==tmpinsutype){$.messager.alert('��Ϣ',"ѡ��ҽ�����!",'info');return;}
	var tmpmsg='��ȷ�������Զ�������?\n\r�˲�����ѵ�ǰҽ����������δ������Ϻ�ҽ����Ͻ��ж���!\n\r�����ڳ��ζ���ʱ������'
	$.messager.confirm('��ȷ��',tmpmsg,function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.INSUDiagnosis","AutoCon",tmpinsutype+"^"+userID+'^'+PUBLIC_CONSTANT.SESSION.HOSPID)
			if(eval(savecode)>=0){
				MSNShow('��ʾ','�������!���ɹ�'+savecode+'��!',2000)  
			}else{
				$.messager.alert('��ʾ','����ʱ��������!','info');   
			}
		}else{
			return;	
		}
	});
	
}


//add xubaobao 2018 02 01
//ȷ�ϲ����¸������
function UpdateCon(ICDConID){
	if(ICDConID==undefined){
		$.messager.alert('��ʾ','��ѡ����Ч�Ķ�����Ϣ���и���','info'); 
		return	
	}
	var userID=session['LOGON.USERID'];
	var AutoConFlag=tkMakeServerCall("web.INSUDiagnosis","GetDiagAutoConFlagByDr",ICDConID)
	
	if (AutoConFlag=="1"){
		// tangzf 2019-6-16 ����ʽ�޸�
		$.messager.confirm('��ʾ','����¼Ϊϵͳ�Զ����գ��Ƿ�Ըü�¼���и���',function(r){
			if(r){
				$.messager.confirm('��ʾ','��ȷ��Ҫ��������¼��Ϊ���ͨ��״̬��,ȡ������˾ܾ�',function(r2){
					if(r2){
		      	  		var savecode=tkMakeServerCall("web.INSUDiagnosis","UpDateCheckUser",ICDConID,userID,"1")
			  	 	 	if(eval(savecode)>=0){
				    	 	Query();
				    		MSNShow('��ʾ','��˳ɹ���',2000)
			    		}else{
				    	 	$.messager.alert('��ʾ','���ʱ��������!','info');   
			    		}
					}else{
						var savecode=tkMakeServerCall("web.INSUDiagnosis","UpDateCheckUser",ICDConID,userID,"2")
						if(eval(savecode)>=0){
							Query();
				     		MSNShow('��ʾ','��˳ɹ���',2000)
			    		}else{
				     		$.messager.alert('��ʾ','���ʱ��������!','info');   
			    		}
					}	
				})
			}else{
				return;
			}	
		})
	}
}
//south ����
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
		$('#searchTablePanel').find('.hisui-panel').css('width',window.document.body.offsetWidth); 
		$('#searchTablePanel').find('.panel-header').css('width',window.document.body.offsetWidth);
		$('#searchTablePanel').find('.panel').css('width',window.document.body.offsetWidth);
		$('#searchTablePanel').find('.panel').css('height','107px');
		$('#searchTablePanel').css('overflow','scroll');
		
	}
}
/*
 * ������ϸ����Ӧ
 */
function resizeLayout(type){
	var height;
	var top ;
	if(type == 'Collapse'){
		height = window.document.body.offsetHeight - 164  - 50 - 35 + 'px'; // page - north - south(collapse) - tabs = dg height
		top =   window.document.body.offsetHeight   - 50 - 35  + 10 +'px'; // dg height + padding10px + north
		$('.center-panel').css('height',height);
		$('.layout-panel-south').css('top',top);
		$('#dg').datagrid('resize');
		$('#wdg').datagrid('resize');
	}else  if(type == 'Expand'){
		height = window.document.body.offsetHeight - 164  - 205 - 35 + 'px'; // page - north - south(Expand) - tabs = dg height
		top =   window.document.body.offsetHeight   - 205 - 35  + 10 +'px'; // dg height + padding10px + north
		$('.center-panel').css('height',height);
		$('.layout-panel-south').css('top',top);
		$('#dg').datagrid('resize');
		$('#wdg').datagrid('resize');
	}		
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
	$('#right-KeyWords').keyup(function(){
		if(event.keyCode==13){
			QueryINSUInfoNew();
		}
	});
}
function init_dg(){
		border:false,
		grid=$('#dg').datagrid({
		//idField:'dgid',
		iconCls: 'icon-save',
		rownumbers:true,
		data:[],
		//width: '100%',
		//height: 350,
		fit:true,
		striped:true,
		//fitColumns: true,
		singleSelect: true,
		frozenColumns:[[

		]],
		columns:[[
			{field:'Rowid',title:'Rowid',width:60,hidden:true},
			{field:'HisdigCode',title:'ҽԺ�����',width:80,hidden:true},
			{field:'HisICDCode',title:'ҽԺICD��',width:80},
			{field:'HisICDDesc',title:'ҽԺICD����',width:200},
			{field:'ConId',title:'ConID',width:80,hidden:true},
			{field:'INSUdigDr',title:'ҽ�����Dr',width:65,hidden:true},
			{field:'INSUDigCode',title:'ҽ����ϴ���',width:100},
			{field:'INSUDigDesc',title:'ҽ���������',width:250},
			{field:'ConActDate',title:'��Ч����',width:70},
			{field:'ConExpDate',title:'ʧЧ����',width:70},
			{field:'ConUser',title:'������',width:60},
			{field:'AutoConFlag',title:'ϵͳ���ձ�ʶ',width:100},
			{field:'ReCheckFlag',title:'���״̬',width:80},
			{field:'ReCheckUser',title:'�����',width:80},
			{field:'ReCheckDate',title:'�������',width:80},
			{field:'HisNote',title:'��ע',width:100}
		]],

		pageSize: 10,
		pagination:true,
        onSelect : function(rowIndex, rowData) {
            ConGridQuery(rowIndex,rowData);
            setValueById('right-KeyWords',rowData.HisICDCode);	
            if(!getValueById('csconflg')){
				return;	
			}
            QueryINSUInfoNew();
           
        },
        onUnselect: function(rowIndex, rowData) {
        	
        },
	    onLoadSuccess:function(data){
			
		}
	});	
}
/*
 * ҽ������combogrid
 */
function init_InsuType(){	
	//�����б�
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
function init_INSUTarcSearchPanel() { 

	init_InsuType();
	
	$('#ConType').combobox({   
	 		panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: 'A',
			Desc: '��ѯ����',
			selected: true
		},{
			Code: 'Y',
			Desc: '��ѯ�Ѷ�����'
		},{
			Code: 'N',
			Desc: '��ѯδ������'
		}]

	}); 
	$('#QClase').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '1',
			Desc: '��ƴ��',
			selected:true
		},{
			Code: '2',
			Desc: '��ҽԺICD��'
		},{
			Code: '3',
			Desc: '��ҽԺICD����'
		}]
	}); 
	$('#right-QClase').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '1',
			Desc: '��ƴ��'
		},{
			Code: '2',
			Desc: '������',
			selected:true
		},{
			Code: '3',
			Desc: '������'
		}]
	}); 
}
function init_wdg() { 
	var querycol= [[   
			{field:'INDISRowid',title:'INDISRowid',width:60,hidden:true},
			{field:'bzbm',title:'���ֱ���',width:55},
			{field:'bzmc',title:'��������',width:55}
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
			SaveCon(rowIndex);
		},
		onLoadSuccess:function(){
		}
	}); 	
}
function init_ContraHistory() { 
	//������ϸ��ʷ
	ConGrid=$('#coninfo').datagrid({
		idField:'ConId',
		border:false,
		rownumbers:true,
		data:[],
		//width: '100%',
		height: 150,
		//striped:true,
		fitColumns: false,
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
		// Rowid,HisdigCode,HisICDCode,HisICDDesc,HisNote,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser
		columns:[[
			{field:'Rowid',title:'HisDr',width:10,hidden:true},
			{field:'HisdigCode',title:'ҽԺ�����',width:100},
			{field:'HisICDCode',title:'ҽԺICD��',width:100},
			{field:'HisICDDesc',title:'ҽԺICD����',width:180},
			{field:'INSUDigCode',title:'ҽ����ϴ���',width:120},
			{field:'INSUDigDesc',title:'ҽ���������'},
			{field:'ConActDate',title:'��Ч����',width:100},
			{field:'ConExpDate',title:'ʧЧ����',width:100},
			{field:'ConUser',title:'������',width:80},
			{field:'HisNote',title:'��ע',width:150},
			{field:'ConId',title:'����Rowid',width:100},
			{field:'INSUdigDr',title:'ҽ�����Dr',width:900}
		]],
		onLoadSuccess:function(){
		},
		onDblClickRow : function(index,rowdata) {
			UpdateCon(rowdata.ConId);       //add xubaobao 2018 02 02
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
///��ȡ���õ�Ĭ����Чʱ��
///ע�⣺���Ϊ��Ĭ�ϵ�ǰʱ��
function GetConDateByConfig()
{
    var rtnDate=""
	var rtnDate=GetDicStr("SYS","INSUCONACTDATE",6);
	if(rtnDate==""){ 
	rtnDate=curDate();}
	return rtnDate; 
 }
 ///��ȡ��ǰʱ��,֧��ʱ���ʽ
 function curDate() {
       return getDefStDate(0);
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
function selectHospCombHandle(){
	$('#insuType').combogrid('grid').datagrid('reload');
}