/**
 * ҽ����������JS
 * opercontrast.js
 * 2021.08.30
 * Hanzh
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
	
	//���ڳ�ʼ��
	init_Date();
	//Ժ�ڰ汾
	init_HisVer();
	//ҽ���汾
	init_Ver();
});

function init_Date(){
	InsuDateDefault('dd');
}

//��ѯҽ����������Ŀ¼����
function QueryINSUInfoNew(){
	if(getValueById('right-KeyWords')==''){
		$.messager.alert('��ʾ','�ؼ��ֲ���Ϊ��','error');
		return;	
	}
	var queryParams = {
		ClassName : 'web.INSUOPERContrastCtl',
		QueryName : 'QueryInsuOperList',
		QryType : getValueById('right-QClase'),
		KWords : getValueById('right-KeyWords'),
		HospDr : PUBLIC_CONSTANT.SESSION.HOSPID,
		HiType : $('#insuType').combobox('getValue'),
		Ver : $('#Ver').combobox('getValue')
	}
	
	loadDataGridStore('wdg',queryParams);	
}
 
//��ѯ������ʷ��¼
function ConGridQuery(rowIndex,rowData){
	// tangzf 2020-6-19 ��ΪHISUI�ӿڼ�������
	var queryParams = {
		ClassName : 'web.INSUOPERContrastCtl',
		QueryName : 'QueryOperCon',
		OperSource : $('#Source').combobox('getValue'),
		ExpStr : $('#insuType').combobox('getValue') + '@' + rowData.Rowid,
		HospDr : PUBLIC_CONSTANT.SESSION.HOSPID,
		SourceVer : rowData.VerCode
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
	
	$.messager.confirm('��ʾ','��ȷ��Ҫ�� '+selHisData.HisOperDesc+' ���ճ� '+selInsuData.ssmc+' ��?',function(r){
		if(r){
			//������������JS��cspEscape()��������
			//var UpdateStr="^"+selHisData.Rowid+"^"+selHisData.HisOperCode+"^"+selHisData.HisOperDesc+"^"+selInsuData.INDISRowid+"^"+selInsuData.ssbm+"^"+selInsuData.ssmc+"^"+$('#Source').combobox('getValue')+"^"+$('#insuType').combobox('getValue')+"^"+sconActDate+"^^"+userID+"^^^^^"+hisNote+"^"+selHisData.SourceVer+"^^^^"+PUBLIC_CONSTANT.SESSION.HOSPID;
			var UpdateStr="^"+selHisData.Rowid+"^"+selHisData.HisOperCode+"^"+selHisData.HisOperDesc+"^"+selInsuData.INDISRowid+"^"+selInsuData.ssbm+"^"+selInsuData.ssmc+"^"+$('#Source').combobox('getValue')+"^"+$('#insuType').combobox('getValue')+"^"+sconActDate+"^^"+userID+"^^^^^"+hisNote+"^"+selHisData.VerCode+"^^^^"+PUBLIC_CONSTANT.SESSION.HOSPID+"^"+selHisData.VerCode+"^"+selInsuData.Ver;	 //upt 20230203 HanZH �����汾�ֶ�
			
			var savecode=tkMakeServerCall("web.INSUOPERContrastCtl","SaveCont",UpdateStr);
			if(savecode==null || savecode==undefined) savecode=-1;
			//alert(savecode.split("!")[0])
			// if(eval(savecode.split("!")[0])>=0){
			// 	//$.messager.alert('��ʾ','����ɹ�!');
			// 	MSNShow('��ʾ','���ճɹ���',2000)
			// 	//grid.datagrid('selectRow', EditIndex + 1);  
			// 	var dgselected=""
			// 	var dgselectedobj = grid.datagrid('getSelected');	//->dgselected
			// 	if (dgselectedobj) {
			// 		dgselected = grid.datagrid('getRowIndex', dgselectedobj);
			// 	}
			// 	if (dgselected>=0) {
			// 		//var dgindex = grid.datagrid('getRowIndex', dgselected);
			// 		grid.datagrid('updateRow',{index: dgselected,row: {ConID:eval(savecode.split("!")[0]),INSUDigCode:selInsuData.ssbm,INSUDigDesc:selInsuData.ssmc,ConActDate:sconActDate,ConUser:session['LOGON.USERNAME']}});
			// 	}
			// 	movenext(grid)
			// }else{
			// 	$.messager.alert('��ʾ','����ʧ��!'+savecode,'info');   
			// }
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
					//grid.datagrid('updateRow',{index: dgselected,row: {ConID:eval(savecode.split("!")[0]),INSUDigCode:selInsuData.ssbm,INSUDigDesc:selInsuData.ssmc,ConActDate:sconActDate,ConUser:session['LOGON.USERNAME']}});
					if (savecode.split("!").length>1){
						if(eval(savecode.split(":")[1])>=0){
							grid.datagrid('updateRow',{index: dgselected,row: {ConId:eval(savecode.split("!")[0]),INSUDigCode:selInsuData.ssbm,INSUDigDesc:selInsuData.ssmc,ConActDate:sconActDate,ConUser:session['LOGON.USERNAME']}});
						}else{
							setTimeout("grid.datagrid('updateRow',{index: dgselected,row: {ConID:eval(savecode.split('!')'[0]),INSUDigCode:selInsuData.ssbm,INSUDigDesc:selInsuData.ssmc,ConActDate:sconActDate,ConUser:session['LOGON.USERNAME']}})","1000")
						}
					}else{
						grid.datagrid('updateRow',{index: dgselected,row: {ConId:eval(savecode.split("!")[0]),INSUDigCode:selInsuData.ssbm,INSUDigDesc:selInsuData.ssmc,ConActDate:sconActDate,ConUser:session['LOGON.USERNAME']}});
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
			var savecode=tkMakeServerCall("web.INSUOPERContrastCtl","DelCont",tmpdelid)
			//if(eval(savecode)>=0){
			if(eval(savecode.split("!")[0])>=0){
				//$.messager.alert('��ʾ','ɾ���ɹ�!'); 
				//MSNShow('��ʾ','ɾ���ɹ���',2000);
				//upt HanZH 20230215
				if (savecode.split("!").length>1){
					MSNShow('��ʾ',savecode.split("!")[1],2000)
				}else{MSNShow('��ʾ','ɾ���ɹ���',2000)}
				//movenext(grid)  

				var ICDSelected = $('#dg').datagrid('getSelected');
                if (ICDSelected){ConGridQuery(-1,ICDSelected)}
                var dgindex = $('#dg').datagrid('getRowIndex', ICDSelected);
				//$('#dg').datagrid('updateRow',{index: dgindex,row: {ConId:'',INSUdigDr:'',INSUDigCode:'',INSUDigDesc:'',ConUser:'',AutoConFlag:'',ConActDate:'',ConExpDate:''}});
				$('#dg').datagrid('updateRow',{index: dgindex,row: {ConId: "",INSUdigDr: "",INSUDigCode: "",INSUDigDesc: "",ConUser: "",AutoConFlag: "",ConActDate: "",ConExpDate: ""}}); //upt 20230302 HanZH
			}else{
				//$.messager.alert('��ʾ','ɾ��ʧ��!','info');   
				$.messager.alert('��ʾ','����ʧ��!'+savecode,'info'); 
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
	var tmpmsg='��ȷ�������Զ�������?\n\r�˲�����ѵ�ǰҽ����������δ����������ҽ���������ս��ж���!\n\r�����ڳ��ζ���ʱ������'
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
function init_layout(){/*
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
	}*/
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
                	//resizeLayout(Global.Operator);
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
		grid=$('#dg').datagrid({
		border:false,
		//autoSizeColumn:false,
		fit:true,
		singleSelect: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		//cache:true,
		toolbar:'#dgTB',
		pagination:true,
		columns:[[
			{field:'Rowid',title:'Rowid',width:50},
			{field:'HisdigCode',title:'ҽԺ������',width:80,hidden:true},
			{field:'HisOperCode',title:'��������',width:120},
			{field:'HisOperDesc',title:'��������',width:200},
			{field:'Source',title:'������Դ',width:90},
			{field:'ConId',title:'ConID',width:80,hidden:true},
			{field:'INSUdigDr',title:'ҽ����������Dr',width:65,hidden:true},
			{field:'INSUDigCode',title:'ҽ���������մ���',width:120},
			{field:'INSUDigDesc',title:'ҽ��������������',width:200},
			{field:'ConActDate',title:'��Ч����',width:90},
			{field:'ConExpDate',title:'ʧЧ����',width:90},
			{field:'VerCode',title:'Ժ�ڰ汾',width:120,hidden:true},
			{field:'VerDesc',title:'Ժ�ڰ汾',width:150},
			{field:'InsuVer',title:'ҽ���汾',width:120,hidden:true},
			{field:'InsuVerDesc',title:'ҽ���汾',width:150},
			{field:'ConUser',title:'������',width:100},
			{field:'AutoConFlag',title:'ϵͳ���ձ�ʶ',width:100,hidden:true},
			{field:'ReCheckFlag',title:'���״̬',width:80,hidden:true},
			{field:'ReCheckUser',title:'�����',width:80,hidden:true},
			{field:'ReCheckDate',title:'�������',width:80,hidden:true},
			{field:'SourceVer',title:'����Դ�汾',width:100},
			{field:'HisNote',title:'��ע',width:100}
		]],
        onSelect : function(rowIndex, rowData) {
            ConGridQuery(rowIndex,rowData);
            setValueById('right-KeyWords',rowData.HisOperCode);	
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
/*
 *������Դcombogrid
 */
function init_Source(){	
	//�����б�
	var Sourcecombox=$('#Source').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'cCode',   
	    textField:'cDesc', 
        rownumbers:true,
        url:$URL,
        onBeforeLoad:function(param){
	        param.ClassName = 'web.INSUDicDataCom';
	        param.QueryName = 'QueryDic1';
	        param.Type = 'OPERSource';
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
			Sourcecombox.combogrid('setValue',data.rows[0].cCode);
		},
		onSelect:function(index,data){
		}
	}); 	
}
function init_INSUTarcSearchPanel() { 

	init_InsuType();
	init_Source();
	
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
			Desc: '����������',
			selected: true
		},{
			Code: '2',
			Desc: '����������'
		}]
	}); 
	$('#right-QClase').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '1',
			Desc: '������',
			selected:true
		},{
			Code: '2',
			Desc: '������'
		}]
	});  
}
function init_wdg() { 
	var querycol= [[   
			{field:'INDISRowid',title:'INDISRowid',width:60,hidden:true},
			{field:'ssbm',title:'��������',width:55},
			{field:'ssmc',title:'��������',width:55},
			{field:'Ver',title:'�汾',width:55,hidden:true},
			{field:'VerDesc',title:'�汾',width:55}
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
		pageSize: 20,
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
		toolbar:[],
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
		// Rowid,HisdigCode,HisOperCode,HisOperDesc,HisNote,ConId,INSUdigDr,INSUDigCode,INSUDigDesc,ConActDate,ConExpDate,ConUser
		columns:[[
			{field:'Rowid',title:'HisDr',width:10,hidden:true},
			{field:'HisdigCode',title:'ҽԺICD',width:100,hidden:true},
			{field:'HisOperCode',title:'��������',width:100},
			{field:'HisOperDesc',title:'��������',width:180},
			{field:'INSUDigCode',title:'ҽ���������մ���',width:120},
			{field:'INSUDigDesc',title:'ҽ��������������'},
			{field:'ConActDate',title:'��Ч����',width:100},
			{field:'ConExpDate',title:'ʧЧ����',width:100},
			{field:'ConUser',title:'������',width:80},
			{field:'HisNote',title:'��ע',width:150},
			{field:'ConId',title:'����Rowid',width:100},
			{field:'INSUdigDr',title:'ҽ����������Dr',width:100},
			{field:'HisVer',title:'Ժ�ڰ汾',width:120,hidden:true},
			{field:'HisVerDesc',title:'Ժ�ڰ汾',width:150},
			{field:'Ver',title:'ҽ���汾',width:120,hidden:true},
			{field:'VerDesc',title:'ҽ���汾',width:150}
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
			//resizeLayout('Collapse');
    	},
    	onExpand:function(){
	    	//resizeLayout('Expand');
			
	    }
	});
}
///��ȡ���õ�Ĭ����Чʱ��
///ע�⣺���Ϊ��Ĭ�ϵ�ǰʱ��
function GetConDateByConfig()
{
    var rtnDate=""
	//var rtnDate=GetDicStr("SYS","INSUCONACTDATE",6);
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


//��ѯ������������
function Query(){
	var source=$('#Source').combobox('getValue');
	if(source==''){
		$.messager.alert('��ʾ','������Դ����Ϊ��','error');
		return;	
	}
	var code="";
	var desc="";
	var KeyWords=$('#QClase').combobox('getValue');
	if(KeyWords=="1"){
		code=$('#KeyWords').val();
	}else if(KeyWords=="2"){
		desc=$('#KeyWords').val();	
	}
	$.m({
		ClassName: "web.INSUOPERContrastCtl",
		MethodName: "GetQueryNameBySource",
		Source: source
	}, function (rtn) {
		var rtnAry = rtn.split("^");
		if  (rtnAry[0]==-1){
			return;
		}	
		var queryParams = {
			ClassName : rtnAry[0],
			QueryName : rtnAry[1],
			OperSource : source,
			rowid : "",
			ConType : $('#ConType').combobox('getValue'),
			code : code,
			desc : desc,
			insutype : $('#insuType').combobox('getValue'),
			HospDr : PUBLIC_CONSTANT.SESSION.HOSPID	,
			SouceVer : $('#HisVer').combobox('getValue')	
		}
		loadDataGridStore('dg',queryParams);
		var tmpObj={
			Rowid:''	
		}
		ConGridQuery('',tmpObj); 
	});
	
}
//ҽ���������յ���
function Export()
{
   try
   {
		var source=$('#Source').combobox('getValue');
		if(source==''){
			$.messager.alert('��ʾ','������Դ����Ϊ��','error');
			return;	
		}
		var code="";
		var desc="";
		var KeyWords=$('#QClase').combobox('getValue');
		if(KeyWords=="1"){
			code=$('#KeyWords').val();
		}else if(KeyWords=="2"){
			desc=$('#KeyWords').val();	
		}
		if(source=="1"){
			window.open("websys.query.customisecolumn.csp?CONTEXT=Kweb.INSUOPERContrastCtl:HisOperInfo&PAGENAME=HisOperInfo&OperSource="+source+"&rowid="+"&ConType="+$('#ConType').combobox('getValue')+"&code="+code+"&desc="+desc+"&insutype="+$('#insuType').combobox('getValue')+"&HospDr="+PUBLIC_CONSTANT.SESSION.HOSPID);
			$.messager.progress({
		         title: "��ʾ",
				 msg: '���ڵ���ҽ��������������',
				 text: '������....'
				   });
			$cm({
				ResultSetType:"ExcelPlugin",  
				ExcelName:"ҽ����������",		  
				PageName:"HisOperInfo",      
				ClassName:"web.INSUOPERContrastCtl",
				QueryName:"HisOperInfo",
				rowid:"",
				OperSource:source,
				ConType:$('#ConType').combobox('getValue'),
				code:code,
				desc:desc,
				insutype:$('#insuType').combobox('getValue'),
				HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
			},function(){
				  setTimeout('$.messager.progress("close");', 3 * 1000);	
			});
		}
		
   } catch(e) {
	   $.messager.alert("����",e.message);
	   $.messager.progress('close');
   }; 
   
}

//ҽ���������յ���
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
         msg: 'ҽ���������յ�����',
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
            msg: 'ҽ���������յ���',
            text: '�����У�����'+(rowCnt-1)+'��'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
       ItmArrSave(arr);
	}
	});
}
//ҽ�������������ݱ���
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
			 var savecode = tkMakeServerCall("web.INSUOPERContrastCtl", "SaveInOperCon",   UpdateStr)
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
			  $.messager.alert('��ʾ', '����ҽ���������������쳣��'+ex.message,'error')
	          return ;
	      }
  return ;
	
}

function SetValue(value)
{
   if(value == undefined)
   {
	   value="" ;
   }
   value=value.toString().replace(/\"/g, "");
   value=value.toString().replace(/\?/g,"");
   return value;
}
/*
 *Ժ�ڰ汾
 */
 function init_HisVer(){	
	//�����б�
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
	      	param.type='User.ORCOperation';
	      	param.IsInsuFlag='N';
	      	param.ResultSetType = 'array';
	      	return true;

		}
	});		
}

/*
 *ҽ���汾
 */
 function init_Ver(){	
	//�����б�
	$('#Ver').combobox({
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
	      	param.type='User.ORCOperation';
	      	param.IsInsuFlag='Y';
	      	param.ResultSetType = 'array';
	      	return true;

		}
	});		
}

