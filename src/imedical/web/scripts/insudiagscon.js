/**
 * ҽ����϶���JS
 * scripts/insudiagscon.js
 * Zhan 201409
 * �汾��V1.0
 * easyui�汾:1.3.2
 */
var grid;
var ConGrid;
var ArgSpl="@"
var Global = {
	Operator:''	 
}
$(function(){

	//GetjsonQueryUrl();
	//�س��¼�
	init_Keyup();
	//ҽ����϶���(HIS)�����б�
	init_INSUTarcSearchPanel();
	//��ʼ�����յ�grid west
	init_dg();
	//ҽ�����(ҽ������) east
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
	var tmpARGUS=$('#insuType').combobox('getValue') + ArgSpl + ($('#KeyWords').val())+ArgSpl+$('#QClase').combobox('getValue')+ArgSpl+$('#ConType').combobox('getValue')+ArgSpl + PUBLIC_CONSTANT.SESSION.HOSPID+ArgSpl + $('#Valid').combobox('getValue')+ArgSpl+ $('#DateAct').datebox('getValue')+ArgSpl+$('#HisVer').combobox('getValue');
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
		HospDr : PUBLIC_CONSTANT.SESSION.HOSPID,
		QHisVer : $('#InsuVer').combobox('getValue')
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
		HospDr : PUBLIC_CONSTANT.SESSION.HOSPID,
		HisVer : $('#HisVer').combobox('getValue')	
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
	var valNote = $HUI.validatebox("#HisNotecon")
	if (!valNote.isValid()){
		$.messager.alert('��ʾ','��ע�ֶβ��ںϷ���Χ��','info',function(){	focusById('HisNotecon',100);});	
		return;
		}
	var hisNote = getValueById('HisNotecon');
	$.messager.confirm('��ʾ','��ȷ��Ҫ�� '+selHisData.HisICDDesc+' ���ճ� '+selInsuData.bzmc+' ��?',function(r){
		if(r){
			//������������JS��cspEscape()��������
			//var UpdateStr="^"+selHisData.Rowid+"^"+selHisData.HisICDCode+"^"+selHisData.HisICDDesc+"^"+selInsuData.INDISRowid+"^"+selInsuData.bzbm+"^"+selInsuData.bzmc+"^"+$('#insuType').combobox('getValue')+"^"+sconActDate+"^"+userID+"^^^^^"+hisNote+"^^^^^";
			var UpdateStr="^"+selHisData.Rowid+"^"+selHisData.HisICDCode+"^"+selHisData.HisICDDesc+"^"+selInsuData.INDISRowid+"^"+selInsuData.bzbm+"^"+selInsuData.bzmc+"^"+$('#insuType').combobox('getValue')+"^"+sconActDate+"^"+userID+"^^^^^"+hisNote+"^^^^^^"+selHisData.HisVer+"^"+selInsuData.HisVer;	//+����Ժ�ڰ汾�������ж�ͬ�������� 20230210
			var savecode=tkMakeServerCall("web.INSUDiagnosis","SaveCont",UpdateStr)
			if(savecode==null || savecode==undefined) savecode=-1
			//if(eval(savecode)>=0){
			if(eval(savecode.split("!")[0])>=0){
				//$.messager.alert('��ʾ','����ɹ�!');
				//MSNShow('��ʾ','���ճɹ���',2000)
				//upt HanZH 20230215
				if (savecode.split("!").length>1){
					MSNShow('��ʾ',savecode.split("!")[1],2000)
				}else{MSNShow('��ʾ','���ճɹ���',2000)}
				//grid.datagrid('selectRow', EditIndex + 1);  
				var dgselected=""
				var dgselectedobj = grid.datagrid('getSelected');	//->dgselected
				if (dgselectedobj) {
					dgselected = grid.datagrid('getRowIndex', dgselectedobj);
				}
				if (dgselected>=0) {
					//var dgindex = grid.datagrid('getRowIndex', dgselected);
					//grid.datagrid('updateRow',{index: dgselected,row: {ConId:eval(savecode),INSUDigCode:selInsuData.bzbm,INSUDigDesc:selInsuData.bzmc,ConActDate:sconActDate,ConUser:session['LOGON.USERNAME']}});
					if (savecode.split("!").length>1){
						if(eval(savecode.split(":")[1])>=0){
							grid.datagrid('updateRow',{index: dgselected,row: {ConId:eval(savecode),INSUDigCode:selInsuData.bzbm,INSUDigDesc:selInsuData.bzmc,ConActDate:sconActDate,ConUser:session['LOGON.USERNAME']}});
						}else{
							setTimeout("grid.datagrid('updateRow',{index: dgselected,row: {ConID:eval(savecode),INSUDigCode:selInsuData.bzbm,INSUDigDesc:selInsuData.bzmc,ConActDate:sconActDate,ConUser:session['LOGON.USERNAME']}})","1000")
						}
					}else{
						grid.datagrid('updateRow',{index: dgselected,row: {ConId:eval(savecode),INSUDigCode:selInsuData.bzbm,INSUDigDesc:selInsuData.bzmc,ConActDate:sconActDate,ConUser:session['LOGON.USERNAME']}});
					}
				}
				movenext(grid)
			}else{
				$.messager.alert('��ʾ','����ʧ��!'+savecode,'info');   
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
			//if(eval(savecode)>=0){
			if(eval(savecode.split("!")[0])>=0){
				//$.messager.alert('��ʾ','ɾ���ɹ�!'); 
				//MSNShow('��ʾ','ɾ���ɹ���',2000);
				//upt HanZH 20230216
				if (savecode.split("!").length>1){
					MSNShow('��ʾ',savecode.split("!")[1],2000)
				}else{MSNShow('��ʾ','ɾ���ɹ���',2000)}
				//movenext(grid)  
				var ICDSelected = $('#dg').datagrid('getSelected');
                if (ICDSelected){ConGridQuery(-1,ICDSelected)}
                var dgindex = $('#dg').datagrid('getRowIndex', ICDSelected);
				//$('#dg').datagrid('updateRow',{index: dgindex,row: {ConId:'',INSUdigDr:'',INSUDigCode:'',INSUDigDesc:'',ConUser:'',AutoConFlag:'',ConActDate:'',ConExpDate:''}});
				$('#dg').datagrid('updateRow',{index: dgindex,row: {ConId:"",INSUdigDr:"",INSUDigCode:"",INSUDigDesc:"",ConUser:"",AutoConFlag:"",ConActDate:"",ConExpDate:""}});	//upt 20230302 HanZH
			}else{
				//$.messager.alert('��ʾ','ɾ��ʧ��!','info');   
				$.messager.alert('��ʾ',savecode,'info');  
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
	// �л�ҳǩʱ���������棩IE���������⣬
	var MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
	var SouthObj = $('.layout-panel-south')[0]; //document.getElementById("box1");;  
    var observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type == "attributes") {
	            if(Global.Operator){
                	resizeLayout(Global.Operator);
	            }
                
            }
        });
    });
    observer.observe(SouthObj, {
        attributes: true, //configure it to listen to attribute changes,
        attributeFilter: ['style']
    });	
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
		Global.Operator = 'Collapse';
	}else  if(type == 'Expand'){
		height = window.document.body.offsetHeight - 164  - 205 - 35 + 'px'; // page - north - south(Expand) - tabs = dg height
		top =   window.document.body.offsetHeight   - 205 - 35  + 10 +'px'; // dg height + padding10px + north
		$('.center-panel').css('height',height);
		$('.layout-panel-south').css('top',top);
		$('#dg').datagrid('resize');
		$('#wdg').datagrid('resize');
		Global.Operator = 'Expand';
	}		
}
/**
 * Creator: tangzf
 * CreatDate: 2019-6-12
 * Description: ��ѯ���س��¼�
 */
function init_Keyup() {
	//ҽ����϶���
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
		grid=$('#dg').datagrid({
		border:false,
		//idField:'dgid',
		iconCls: 'icon-save',
		//rownumbers:true,
		//data:[],
		//width: '100%',
		//height: 350,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		fit:true,
		//striped:true,
		//fitColumns: true,
		singleSelect: true,
		toolbar:'#dgTB',
		pagination:true,
		frozenColumns:[[

		]],
		columns:[[
			{field:'Rowid',title:'Rowid',width:60,hidden:true},
			{field:'HisdigCode',title:'ҽԺ�����',width:80,hidden:true},
			{field:'HisICDCode',title:'ҽԺICD��',width:120},
			{field:'HisICDDesc',title:'ҽԺICD����',width:200},
			{field:'ConId',title:'ConID',width:80,hidden:true},
			{field:'INSUdigDr',title:'ҽ�����Dr',width:65,hidden:true},
			{field:'INSUDigCode',title:'ҽ����ϴ���',width:100},
			{field:'INSUDigDesc',title:'ҽ���������',width:250},
			{field:'ConActDate',title:'��Ч����',width:100},
			{field:'HisVer',title:'Ժ�ڰ汾',width:120,hidden:true},
			{field:'InsuVer',title:'ҽ���汾',width:120,hidden:true},
			{field:'tHisVerDesc',title:'Ժ�ڰ汾',width:130},
			{field:'tInsuVerDesc',title:'ҽ���汾',width:130},
			{field:'ConExpDate',title:'ʧЧ����',width:100},
			{field:'ConUser',title:'������',width:120},
			{field:'AutoConFlag',title:'ϵͳ���ձ�ʶ',width:100},
			{field:'ReCheckFlag',title:'���״̬',width:80},
			{field:'ReCheckUser',title:'�����',width:80},
			{field:'ReCheckDate',title:'�������',width:100},
			{field:'HisNote',title:'��ע',width:120}
		]],
        onSelect : function(rowIndex, rowData) {
            ConGridQuery(rowIndex,rowData);
            var QCase = getValueById('right-QClase');
            if(QCase=="1"){ 
            	var PY = tkMakeServerCall("web.DHCINSUPort","GetCNCODE",rowData.HisICDDesc,4,'');
	        	setValueById('right-KeyWords', PY);	
	        }else if (QCase=="2") { // ����
		        setValueById('right-KeyWords',rowData.HisICDCode);	
		    }else if (QCase=="3") // ����
		   {		   
				setValueById('right-KeyWords',rowData.HisICDDesc);	
			}
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
	$('#Valid').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '',
			Desc: 'ȫ��',
		   selected:true
		},{
			Code: 'Y',
			Desc: '��Ч',
		
		},{
			Code: 'N',
			Desc: '��Ч'
		}],
	}); 

	//Ժ�ڰ汾  20230209  HanZH
	$('#HisVer').combobox({
		valueField: 'VersionCode',
		textField: 'VersionName',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			console.log(param)
	      	param.ClassName = 'web.DHCINSUPortUse';
	      	param.QueryName = 'GetBDVersionDic';
	      	param.rowid = '';
	      	param.code = '';
	      	param.desc = '';
	      	param.type='User.MRCICDDx';
	      	param.IsInsuFlag='N';
	      	param.ResultSetType = 'array';
	      	return true;
		}
	});	
	//ҽ���汾  20230209  HanZH
	$('#InsuVer').combobox({
		valueField: 'VersionCode',
		textField: 'VersionName',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			console.log(param)
	      	param.ClassName = 'web.DHCINSUPortUse';
	      	param.QueryName = 'GetBDVersionDic';
	      	param.rowid = '';
	      	param.code = '';
	      	param.desc = '';
	      	param.type='User.MRCICDDx';
	      	param.IsInsuFlag='Y';
	      	param.ResultSetType = 'array';
	      	return true;
		}	
	});	
}
function init_wdg() { 
	var querycol= [[   
			{field:'INDISRowid',title:'INDISRowid',width:60,hidden:true},
			{field:'bzbm',title:'��ϱ���',width:55},
			{field:'bzmc',title:'�������',width:55},
			{field:'HisVer',title:'�汾',width:55}
		]]

	var divgrid=$('#wdg').datagrid({  
		//idField:'dgid',
		border:false,
		rownumbers:true,
		striped:false,
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
			{field:'tHisVer',title:'Ժ�ڰ汾',width:120,hidden:true},
			{field:'tInsuVer',title:'ҽ���汾',width:120,hidden:true},
			{field:'tHisVerDesc',title:'Ժ�ڰ汾',width:130},
			{field:'tInsuVerDesc',title:'ҽ���汾',width:130},
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

//ҽ����϶��յ���
function Export()
{
   try
   {
		var tmpARGUS=$('#insuType').combobox('getValue') + ArgSpl + ($('#KeyWords').val())+ArgSpl+$('#QClase').combobox('getValue')+ArgSpl+$('#ConType').combobox('getValue')+ArgSpl + PUBLIC_CONSTANT.SESSION.HOSPID+ArgSpl + $('#Valid').combobox('getValue')+ArgSpl+ $('#DateAct').datebox('getValue');
		
		window.open("websys.query.customisecolumn.csp?CONTEXT=Kweb.INSUDiagnosis:QueryDiagnosInfo&PAGENAME=QueryDiagnosInfo&ExpStr="+tmpARGUS);
		$.messager.progress({
	         title: "��ʾ",
			 msg: '���ڵ���ҽ����϶�������',
			 text: '������....'
			   });
		$cm({
			ResultSetType:"ExcelPlugin",  
			ExcelName:"ҽ����϶���",		  
			PageName:"QueryDiagnosInfo",      
			ClassName:"web.INSUDiagnosis",
			QueryName:"QueryDiagnosInfo",
			ExpStr:tmpARGUS
		},function(){
			  setTimeout('$.messager.progress("close");', 3 * 1000);	
		});
		
   } catch(e) {
	   $.messager.alert("����",e.message);
	   $.messager.progress('close');
   }; 
}
//ҽ����϶��յ���
function Import()
{
	var filePath=""
	var exec= '(function tst(){ var xlApp  = new ActiveXObject("Excel.Application");'
	           +'var fName=xlApp.GetOpenFilename("Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls");'
	           +'if (!fName){fName="";}'
	           +'xlApp.Quit();'
               +'xlSheet=null;'
               +'xlApp=null;'
	           +'return fName;}());'
	  CmdShell.notReturn = 0;
      var rs=CmdShell.EvalJs(exec);
      if(rs.msg == 'success'){
        filePath = rs.rtn;
        importItm(filePath);
      }else{
         $.messager.alert('��ʾ', '���ļ�����'+rs.msg,'error');
      }				   
}

function importItm(filePath)
{
    if (filePath == "") {
        $.messager.alert('��ʾ', '��ѡ���ļ���','info')
        return ;
    }
   $.messager.progress({
         title: "��ʾ",
         msg: 'ҽ����϶��յ�����',
         text: '���ݶ�ȡ��...'
        }); 
   $.ajax({
	async : true,
	complete : function () {
    ReadItmExcel(filePath);
	}
	});
  
}
//��ȡExcel����
function ReadItmExcel(filePath)
{
	
   //��ȡexcel
   var arr;
   try 
   {
	 arr= websys_ReadExcel(filePath);
	 $.messager.progress("close");
	}
   catch(ex)
   {
	  $.messager.progress("close");
	  $.messager.alert('��ʾ', '����websys_ReadExcel�쳣��'+ex.message,'error')
	  return ;
	}
	 var rowCnt=arr.length
	 $.messager.progress({
            title: "��ʾ",
            msg: 'ҽ����϶��յ���',
            text: '�����У�����'+(rowCnt-1)+'��'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
       ItmArrSave(arr);
	}
	});
}
//ҽ����϶������ݱ���
function ItmArrSave(arr)
{
	
	//��ȡ��������
	var ErrMsg = "";     //��������
    var errRowNums = 0;  //��������
    var sucRowNums = 0;  //����ɹ�������
	var rowCnt=arr.length
	 try{
		 for (i = 1; i < rowCnt; i++) 
		 {
			 var rowArr=arr[i]
			 var UpdateStr="^"+rowArr.join("^")
			 var savecode = tkMakeServerCall("web.INSUDiagnosis", "SaveInContNew", UpdateStr)
                    if (savecode == null || savecode == undefined) savecode = -1
                    
                    if (savecode >= 0) {
                        sucRowNums = sucRowNums + 1;
                    } else {
                        errRowNums = errRowNums + 1;
                        if (ErrMsg == "") {
                            ErrMsg = i+":"+savecode;
                        } else {
                            ErrMsg = ErrMsg + "<br>" + i+":"+savecode;
                        }
                    }
		 }
		 
		 if (ErrMsg == "") {
                    $.messager.progress("close");
                    $.messager.alert('��ʾ', '������ȷ�������');
                } else {
                   $.messager.progress("close");
                     var tmpErrMsg = "����ɹ���"+sucRowNums +"����ʧ�ܣ�"+errRowNums+"����";
                     tmpErrMsg = tmpErrMsg + "<br>ʧ�������кţ�<br>"+ ErrMsg;
                    $.messager.alert('��ʾ', tmpErrMsg,'info');
                }
		      return ;
		 }
		 catch(ex)
		 {
			  $.messager.progress("close");
			  $.messager.alert('��ʾ', '����ҽ����϶��������쳣��'+ex.message,'error')
	          return ;
	      }
  return ;
	
}

