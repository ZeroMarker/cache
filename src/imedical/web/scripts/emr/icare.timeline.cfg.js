// icare.timeline.cfg.js
var restArr = {
	timeLineReq:{ClassName: "icare.TimeLineConfig",QueryName: "GetTimeLineList"},/*��ѯ��ͼ*/
	getTimeLineItemReq:{ClassName:"icare.TimeLineConfig",QueryName:"GetTimeLineItems"},/*��ѯ��ͼ�д���*/
	updTimeLineReq:{ClassName:"icare.TimeLineConfig",MethodName:"UpdateTimeLine"}, /*������ͼ*/
	insTimeLineReq:{ClassName:"icare.TimeLineConfig",MethodName:"AddTimeLine"}, /*������ͼ*/
	delTimeLineReq:{ClassName: "icare.TimeLineConfig",MethodName: "DeleteTimeLine"}, /*ɾ����ͼ*/
	getDiagTypeReq:{QueryName:"GetDiagnoseType",ClassName: "icare.DiagnoseSetting"}/*����������*/
};

var selectedTimeLineInd = 0;
var timeLineArr = [{Code:"AdmView",Description:"סԺ������ͼ"}];
var genWinHtml = function(itemsCfg){
	var html = '<div class="winform">';
	var items = itemsCfg.items;
	for(var i=0; i<items.length; i++){
		html += '<div>'
		if (items[i].label){
			html+='<label class="r-label">'+items[i].label+'</label>';
		}
		if (items[i].id){
			if (items[i].type=='textarea'){
				html+='<textarea id="'+items[i].id+'" type="textarea" class="textbox" rows="3">'+items[i].value+'</textarea>'
			}else if (items[i].type=='hidden'){
				html+='<input id="'+items[i].id+'" type="hidden" value="'+items[i].value+'"/>'
			}else if (items[i].type=='lookup'){
				html+='<input id="'+items[i].id+'" value="'+items[i].value+'" class="textbox hisui-lookup" />'
			} else{
				html+='<input id="'+items[i].id+'" value="'+items[i].value+'" class="textbox"/>'
			}
		}
		html+='</div>';
	}	
	html +='</div>';
	html += '<div style="bottom: 10px;position: absolute;left: 40%;">'+
		'<a class="hisui-linkbutton" onclick="'+itemsCfg.hander+'();">ȷ��</a>'+
		'</div>'
	return html;
}
var saveTimeLineView = function(){
	var i = $('#tlid').val();
	var c = $('#tlcode').val();
	var d = $('#tldesc').val();
	var n = $('#tlnote').val();
	if (i==""&&c==""){
		$.messager.alert("��ʾ","����д����","info");
		return;
	}
	var param = {};
	if (i==""){
		$.extend(param, restArr.insTimeLineReq, {code:c,desc:d,note:n});
	}else{
		$.extend(param, restArr.updTimeLineReq, {oldcode:i,newcode:c,desc:d,note:n});
	}
	$m(param,function(rtn){
		if (rtn==1){
			// websys_showModal('close'); 
			$("#tmpwin").window('close');
			if (i==""){
				selectedTimeLineInd = $('.tl-panel').length;
			}
			renderTimeLineView();
			$.messager.popover({msg:'����ɹ�',type:'success'});
		}else{
			$.messager.popover({msg:'����ʧ��',type:'error'});
		}
	});
}
var delTimeLineView = function(code){
	$m($.extend(restArr.delTimeLineReq,{code:code}),function(rtn){
		if (rtn==1){
			if (selectedTimeLineInd>0) selectedTimeLineInd = selectedTimeLineInd-1;
			renderTimeLineView();
			$.messager.popover({msg:'ɾ���ɹ�',type:'success'});
		}else{
			$.messager.popover({msg:'ɾ��ʧ��',type:'error'});
		}
	});
}
var showTimeLineWin = function(tlItemObj){
	var itemsCfg = {
		items:[{id:'tlcode',label:'����',value:tlItemObj.Code},{id:'tldesc',label:'����',value:tlItemObj.Description},
		{id:'tlnote',label:'˵��',type:'textarea',value:tlItemObj.Notes},{id:'tlid',type:'hidden',value:tlItemObj.ID}],
		hander:'saveTimeLineView'
	};
	var winJObj = $('#tmpwin');
	if (winJObj.length==0){
		$('<div id="tmpwin"></div>').appendTo('body');
	}
	var title = "������ͼ";
	if (tlItemObj.Code!=""){
		title = "�޸���ͼ";
	}
	winJObj.window({
		iconCls:'icon-w-edit',
		title:title,
		content:genWinHtml(itemsCfg),
		modal:true,width:260,height:260,
		resizable:false,collapsible:false,minimizable:false,maximizable:false
	});
};

/**
* render �����ͼ�б�
*/
var renderTimeLineView = function(){
	$cm(restArr.timeLineReq,function(rtn){
		timeLineArr = rtn.rows;
		$("#timelinewest").html("");
		if (rtn.rows.length>0){
			for (var i=0;i<rtn.rows.length;i++){
				var item = rtn.rows[i];
				var selected = "";
				if (i==selectedTimeLineInd){selected=" selected";}
				$('<div class="tl-panel'+selected+'" data-ind="'+i+'"><div id="panel11"></div></div>').appendTo("#timelinewest")
				.click(function(){
					var _t = $(this);
					if (!_t.hasClass('selected')){
						$(".tl-panel").removeClass('selected');
						_t.addClass('selected');
						selectedTimeLineInd = _t.data("ind");
						$("#itemsGrid").datagrid("load");
						//_t.find('.panel .panel-header').addClass("panel-header-blue");
					}else{
						//_t.find('.panel .panel-header').addClass("panel-header-gray");
					}
				}).children("div").panel({  
					width:230,  
					height:100,
					title: item.Description,
					tlItem :item,
					headerCls:'panel-header-gray',
					content:"<div style=\"margin:10px;\">"+item.Notes+"</div>",
					tools: [{  
						iconCls:'icon-write-order',  
						handler:function(){
							$(this).closest('.tl-panel').trigger('click');
							var tlItemObj = $(this).closest('.panel').children('.panel-body').panel("options").tlItem;
							tlItemObj.ID = tlItemObj.Code;
							showTimeLineWin(tlItemObj);
						}
					},{  
						iconCls:'icon-cancel',  
						handler:function(){
							$(this).closest('.tl-panel').trigger('click');
							var tlItemObj = $(this).closest('.panel').children('.panel-body').panel("options").tlItem;
							$.messager.confirm("ɾ��", "ȷ��ɾ����"+tlItemObj.Description+"����ͼ����?", function (r) {
								if (r) {
									delTimeLineView(tlItemObj.Code);
								}
							});
						}  
					}]  
				});   
			}
			//$('<div class="timeLineAddBtn"><a class="icon icon-add iconadd" href="#" onclick=\'showTimeLineWin({ID:"",Code:"",Description:"",Notes:""});\'>����</a></div>').appendTo("#timelinewest");
			$("#itemsGrid").datagrid("load");
		}
	});
}
$(function(){	
	renderTimeLineView();
});
var viewTypeData = [{val:'T',txt:'���'}, {val:'A',txt:'����'}, {val:'I',txt:'ͼ��'}, {val:'L',txt:'�ı�'}, {val:'C',txt:'����ͼ'},{val:'N',txt:'��'}];

var createtab2 = function(){
	/*��ʾ��ά��*/
	$('#cateGrid').mgrid({
		className:'icare.dto.CateDto',
		key:'cate',pagination:false,editGrid:true,
		title:'��ʾ���б�',addBtnText:"&nbsp;",editBtnText:"&nbsp;",saveBtnText:"&nbsp;",delBtnText:"&nbsp;",cancelBtnText:"&nbsp;",
		columns:[[
			{field:'Code',title:'��Ŀ����',editor:{type:'text'}},
			{field:'Description',title:'��Ŀ����',width:100,editor:{type:'text'}}
		]],
		onLoadSuccess:function(data){
			if (data && data.rows && data.rows.length>0){
				$(this).datagrid("selectRow",0);
				var c = $("#itemsGrid").datagrid('getColumnOption', 'Code');    
				c.editor = {
					type:'combogrid',
						options:{
							blurValidValue:true,
							panelWidth: 300,
							idField:'Code',
							textField:'Code',
							columns:[[
								{field:'Description',title:'����'},
								{field:'Code',title:'����'}
							]],
							data:data.rows
						}
					};
			}
		},
		onSelect:function(rowIndex,rowData){
			$("#typeGrid").datagrid('load');
		},
		insOrUpdHandler:function(row){
			var param ;
			if (row.ID==""){
				if (!row.Code){
					$.messager.popover({msg:"������벻��Ϊ�գ�",type:'info'});
					return ;
				}
				param = $.extend(this.insReq,{"dto.cate.Code":row.Code});
			}else{
				param = $.extend(this.updReq,{"dto.cate.id":row.Code});
			}
			$.extend(param,{"dto.cate.Description":row.Description});
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			return {ID:"",Code:"",Description:""};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("ɾ��", "�ò����ἶ��ɾ��,ȷ��ɾ����"+row.Description+"����ʾ��?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.cate.Code":row.ID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
	/*����ά��*/
	$('#typeGrid').mgrid({
		className:'icare.dto.DataTypeDto',
		key:'type',editGrid:true,
		title:'�����б�',pagination:false,
		columns:[[
			{field:'Code',title:'��Ŀ����',editor:{type:'text'}},
			{field:'Description',title:'��Ŀ����',width:100,editor:{type:'text'}},
			{field:'ShowType',title:'��ʾ��ϵ',formatter:function(v){if (v=="N"){ return "����ʾ״̬"}return "��ʾ����"; },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}}
		]],
		onBeforeLoad:function(param){
			if ($('#cateGrid').datagrid('getSelected')){
				param.categroyCode = $('#cateGrid').datagrid('getSelected').Code;
			}else{
				param.categroyCode = "";
				return false;
			}
		},
		onLoadSuccess:function(data){
			if (data && data.rows && data.rows.length>0){
				$(this).datagrid("selectRow",0);
			}
		},
		onSelect:function(rowIndex,rowData){
			$("#actGrid").datagrid('load');
			$("#typeBtnGrid").datagrid('load');
			$("#typeChartGrid").datagrid('load');
		},
		insOrUpdHandler:function(row){
			var param ;
			if (row.ID==""){
				if (!row.Code){
					$.messager.popover({msg:"������벻��Ϊ�գ�",type:'info'});
					return ;
				}
				param = $.extend(this.insReq,{"dto.type.Code":row.Code});
			}else{
				param = $.extend(this.updReq,{"dto.type.id":row.Code});
			}
			var cateCode = $('#cateGrid').datagrid('getSelected').Code;
			$.extend(param,{"dto.cateCode":cateCode,"dto.type.Description":row.Description,"dto.type.ShowType":row.ShowType});
			//$('#actGrid').datagrid('acceptChanges'); //ǰ���ύgetChanges����
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			return {ID:"",Code:"",Description:"",ShowType:""};
		},
		delHandler:function(row){
			var _t = this;
			var cateCode = $('#cateGrid').datagrid('getSelected').Code;
			$.messager.confirm("ɾ��", "�ò����ἶ��ɾ����Ϊ��,ȷ��ɾ����"+row.Description+"������?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.cateCode":cateCode,"dto.type.Code":row.ID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
	/*����--��ťά��*/
	$('#typeBtnGrid').mgrid({
		className:'websys.dto.TypeMenuTool',
		key:'typeBtn',editGrid:true,addBtnText:"&nbsp;",editBtnText:"&nbsp;",saveBtnText:"&nbsp;",delBtnText:"&nbsp;",cancelBtnText:"&nbsp;",
		title:'����-��ť�б�',pagination:false,updReq:{hidden:true},
		columns:[[
			{field:'Code',title:'�˵�����',width:150,
				editor:{
					type:'lookup',
					options:{
						url:$URL+"?ClassName=websys.Menu&QueryName=FindMenu",
						mode:'remote',
						panelWidth:500,
						panelHeight:300,
						idField:'HIDDEN',
						textField:'Code',
						isCombo:true,
						onBeforeLoad : function(param){
							param.desc = param.q;
						},
						pagination:true,
						columns:[[  
							{field:'Code',title:'�˵���',width:200},  
							{field:'Description',title:'�˵�����',width:200} 
						]]
					}
				}
			},
			{field:'Description',title:'�˵�����',width:150}
		]],
		onBeforeLoad:function(param){
				if ($('#typeGrid').datagrid('getSelected')){
					param.Tool = "ClinicalDataTypeBtn";
					param.Type = $('#typeGrid').datagrid('getSelected').Code;
				}else{
					param.Type = "";
					param.Tool = "ClinicalDataTypeBtn";
					return false;
				}
		},
		insOrUpdHandler:function(row){
			var param ;
			if (row.ID==""){
				if (!row.Code){
					$.messager.popover({msg:"���벻��Ϊ�գ�",type:'info'});
					return ;
				}
				param = $.extend(this.insReq,{"dto.tool.MenuCode":row.Code});
			}else{
				param = $.extend(this.updReq,{"dto.tool.id":row.ID});
			}
			var dataTypeRow = $('#typeGrid').datagrid("getSelected");
			$.extend(param,{
				"dto.tool.MenuCode":row.Code,
				"dto.tool.TypeCode":dataTypeRow.Code,
				"dto.tool.ToolType":"ClinicalDataTypeBtn"
			});
			//$('#actGrid').datagrid('acceptChanges'); //ǰ���ύgetChanges����
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			var dataTypeRow = $('#typeGrid').datagrid("getSelected");
			if (dataTypeRow){
				return {ToolType:"ClinicalDataTypeBtn",TypeCode:dataTypeRow.Code,MenuCode:"",ID:""};
			}else{
				$.messager.popover({msg:"ѡ��������������ӣ�",type:'info'});
				return false;
			}
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("ɾ��", "ȷ��ɾ����"+row.Description+"������-��ť?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.tool.id":row.ID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
	/*����--ͼ��ά��*/
	$('#typeChartGrid').mgrid({
		className:'websys.dto.TypeMenuTool',
		key:'typeChart',editGrid:true,addBtnText:"&nbsp;",editBtnText:"&nbsp;",saveBtnText:"&nbsp;",delBtnText:"&nbsp;",cancelBtnText:"&nbsp;",
		title:'����-ͼ���б�',pagination:false,updReq:{hidden:true},
		columns:[[
			{field:'Code',title:'�˵�����',width:150,
				editor:{
					type:'lookup',
					options:{
						url:$URL+"?ClassName=websys.Menu&QueryName=FindMenu",
						mode:'remote',
						panelWidth:500,
						panelHeight:300,
						idField:'HIDDEN',
						textField:'Code',
						isCombo:true,
						onBeforeLoad : function(param){
							param.desc = param.q;
						},
						pagination:true,
						columns:[[  
							{field:'Code',title:'�˵���',width:200},  
							{field:'Description',title:'�˵�����',width:200} 
						]]
					}
				}
			},
			{field:'Description',title:'�˵�����',width:150}
		]],
		onBeforeLoad:function(param){
				if ($('#typeGrid').datagrid('getSelected')){
					param.Tool = "ClinicalDataTypeChartBook";
					param.Type = $('#typeGrid').datagrid('getSelected').Code;
				}else{
					param.Type = "";
					param.Tool = "ClinicalDataTypeChartBook";
					return false;
				}
		},
		insOrUpdHandler:function(row){
			var param ;
			if (row.ID==""){
				if (!row.Code){
					$.messager.popover({msg:"���벻��Ϊ�գ�",type:'info'});
					return ;
				}
				param = $.extend(this.insReq,{"dto.tool.MenuCode":row.Code});
			}else{
				param = $.extend(this.updReq,{"dto.tool.id":row.ID});
			}
			var dataTypeRow = $('#typeGrid').datagrid("getSelected");
			$.extend(param,{
				"dto.tool.MenuCode":row.Code,
				"dto.tool.TypeCode":dataTypeRow.Code,
				"dto.tool.ToolType":"ClinicalDataTypeChartBook"
			});
			//$('#actGrid').datagrid('acceptChanges'); //ǰ���ύgetChanges����
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			var dataTypeRow = $('#typeGrid').datagrid("getSelected");
			if (dataTypeRow){
				return {ToolType:"ClinicalDataTypeChartBook",TypeCode:dataTypeRow.Code,MenuCode:"",ID:""};
			}else{
				$.messager.popover({msg:"ѡ��������������ӣ�",type:'info'});
				return false;
			}
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("ɾ��", "ȷ��ɾ����"+row.Description+"������-��ť?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.tool.id":row.ID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
	/*��Ϊ��ά��*/
	$('#actGrid').mgrid({
		className:'icare.dto.DataActDto',
		key:'act',editGrid:true,
		title:'��Ϊ�б�',
		columns:[[
			{field:'Code',title:'��Ŀ����',editor:{type:'text'}},
			{field:'Description',title:'��Ŀ����',width:100,editor:{type:'text'}},
			{field:'HisCode',title:'HIS��',width:100,editor:{type:'text'}},
			{field:'ActSort',title:'˳��',width:50,editor:{type:'text'}},
			{field:'GroupName',title:'������',width:60,editor:{type:'text'}},
			{field:'Mth',title:'������',width:100,editor:{type:'text'}},
			{field:'ParentCode',title:"����Ϊ",width:120,editor:{type:'text'}},
			{field:'Active',title:"����״̬",width:100,formatter:function(v){if (v=="N"){ return "����"}return "����"; },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}}
		]],
		rowStyler: function(index,row){
			if (row.ActSort<0){
				return 'color:#FF9797;'; //background-color:#6293BB;
			}
		},
		onBeforeLoad:function(param){
				if ($('#typeGrid').datagrid('getSelected')){
					param.dataTypeCode = $('#typeGrid').datagrid('getSelected').Code;
				}else{
					param.dataTypeCode = "";
					return false;
				}
		},
		insOrUpdHandler:function(row){
			var param ;
			if (row.ID==""){
				if (!row.Code){
					$.messager.popover({msg:"�������벻��Ϊ�գ�",type:'info'});
					return ;
				}
				param = $.extend(this.insReq,{"dto.act.Code":row.Code});
			}else{
				param = $.extend(this.updReq,{"dto.act.id":row.Code});
			}
			$.extend(param,{
				"dto.act.Description":row.Description,
				"dto.act.ActSort":row.ActSort,
				"dto.act.HisCode":row.HisCode,
				"dto.act.Active":row.Active,
				"dto.act.Mth":row.Mth,
				"dto.act.GroupName":row.GroupName,
				"dto.act.ParentCode":row.ParentCode,
				"dto.act.DataTypeCode":row.DataType
			});
			//$('#actGrid').datagrid('acceptChanges'); //ǰ���ύgetChanges����
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			var dataTypeRow = $('#typeGrid').datagrid("getSelected");
			return {DataType:dataTypeRow.Code,ID:"",Code:"",Description:"",HisCode:"",ActSort:"",Active:"Y",Mth:"",GroupName:"",ParentCode:""};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("ɾ��", "ȷ��ɾ����"+row.Description+"����Ϊ��?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.act.Code":row.ID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
}
var createtab3 = function(){
		$('#linkcfgGrid').mgrid({
			className:'icare.dto.ViewTypeConfig',
			editGrid:true,
			key:'linkcfg',border:false,
			title:'',
			columns:[[
				{field:'ID',hidden:true},
				{field:'Description',title:'����',width:100,editor:{type:'text'}},
				{field:'Parameters',title:'����',width:100,editor:{type:'text'}}
			]],
			onLoadSuccess:function(data){
				var c = $("#itemsGrid").datagrid('getColumnOption', 'ViewConfigId');    
				c.editor = {
					type:'combogrid',
						options:{
							panelWidth: 350,
							idField:'ID',
							textField:'Parameters',
							columns:[[
								{field:'Description',title:'����'},
								{field:'Parameters',title:'·��'}
							]],
							data:data.rows
						}
					};
				c.formatter = function(v){
					for (var i=0; i<data.rows.length;i++){
						if (data.rows[i].ID==v) return data.rows[i].Parameters;
					}
				}
			},
			insOrUpdHandler:function(row){
				var param ;
				if (row.ID==""){
					if (!row.Description){
						$.messager.popover({msg:'��������Ϊ�գ�',type:'info'});
						return ;
					}
					param = this.insReq;
				}else{
					param = $.extend(this.updReq,{
						"dto.linkcfg.id":row.ID
					});
				}
				$.extend(param,{
					"dto.linkcfg.Description":row.Description,
					"dto.linkcfg.Parameters":row.Parameters
				});
				$cm(param,defaultCallBack);
			},
			getNewRecord:function(){
				return {ID:"",Description:"",Parameters:""};
			},
			delHandler:function(row){
				var _t = this;
				$.messager.confirm("ɾ��", "�ò�����ͬ�ָ�,ȷ��ɾ����"+row.Description+"������?", function (r) {
					if (r) {
						$.extend(_t.delReq,{"dto.linkcfg.id":row.ID});
						$cm(_t.delReq,defaultCallBack);
					}
				});
			}
		});
}
function tabSelect(title){
	if (title=='���������'){
		createtab3();
	}
	if (title=='��ʾ�����'){
		createtab2();
	}
}
$(function(){
	//createtab2();
	/*��ͼ��������õ�����������*/
	createtab3(); 
	/*ʱ���߶�Ӧ����ʾ��ά��*/
	createDatagridEdit({
		className:'icare.dto.TimeLineItems',
		key:'items',
		title:'��ʾ��Ŀ',
		columns:[[
			{field:'ID',hidden:true},
			{field:'Code',title:'��Ŀ����',width:100}, /*Ϊ�˱༭ʱ����--��Ӧ��̨��CategoryCode*/
			{field:'CategoryDesc',title:'��Ŀ����',width:100},
			{field:'ViewType',title:'չʾ����',width:200,
				editor:{
					blurValidValue:true,
					type:'combobox',
					options:{
						valueField:'val',
						textField:'txt',
						data:viewTypeData
					}
				},formatter:function(v){
					for (var i=0; i<viewTypeData.length;i++){
						if (viewTypeData[i].val==v) return viewTypeData[i].txt;
					}
				}
			},
			{field:'ViewConfigId',title:'����',width:200
			},
			{field:'Sequence',title:'��ʾ˳��',width:200,editor:{type:"text"}}
		]],
		onBeforeLoad:function(param){
			if ($('div.tl-panel[data-ind='+selectedTimeLineInd+']').hasClass('selected')){
				param.timeLineId = timeLineArr[selectedTimeLineInd].Code;
			}else{
				return false;
			}
		},
		onLoadSuccess:function(data){
			$(this).datagrid("getPanel").panel("setTitle",timeLineArr[selectedTimeLineInd].Description+"����ʾ��Ŀ");
		},
		insOrUpdHandler:function(row){
			var param ;
			if (row.ID==""){
				if (!row.Code){
					$.messager.popover({msg:"��ʾ����벻��Ϊ�գ�",type:'info'});
					return false;
				}
				param = $.extend(this.insReq,{
					"dto.items.TimeLine":timeLineArr[selectedTimeLineInd].Code,
					"dto.items.CategoryCode":row.Code
				});
			}else{
				param = $.extend(this.updReq,{
					"dto.items.id":row.ID
				});
			}
			if (""==row.ViewType || undefined==row.ViewType){
				$.messager.popover({msg:"չʾ���Ͳ���Ϊ�գ�",type:'info'});
				return false;
			}

			$.extend(param,{
				"dto.items.Sequence":row.Sequence,
				"dto.items.ViewType":row.ViewType,
				"dto.items.ViewConfig":row.ViewConfigId||"",
				"dto.items.DisplayExpression":row.DisplayExpression
			});
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			return {ID:"",CategoryCode:"",CategoryDesc:"",ViewTypeDesc:"",ViewConfigParam:"",Sequence:""};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("ɾ��", "�ò����ἶ��ɾ��,ȷ��ɾ����"+row.CategoryDesc+"����ʾ��?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.items.id":row.ID}); //timeLineArr[selectedTimeLineInd].Code+"||"
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
	
	//��ͼ�������ʾ��Ŀ�Ĵ����б༭��
	$.q({ClassName:'icare.dto.CateDto',QueryName:'Find'},function(data){ 
		if (data && data.rows && data.rows.length>0){
			var c = $("#itemsGrid").datagrid('getColumnOption', 'Code');    
			c.editor = {
				type:'combogrid',
					options:{
						blurValidValue:true,
						panelWidth: 300,
						idField:'Code',
						textField:'Code',
						columns:[[
							{field:'Description',title:'����'},
							{field:'Code',title:'����'}
						]],
						data:data.rows
					}
				};
		}	
	})
	
	
	
});
/*
	editor:{type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'Y',offText:'N',onSwitchChange:function(){
						var _t = $(this);
						var flag = _t.switchbox('getValue');
						var rowIndex = _t.closest('.datagrid-row.datagrid-row-over').attr('datagrid-row-index');
						var row = $('#actGrid').datagrid("getRows")[rowIndex];
						var active = "N";
						if (flag) active = "Y";
						$cm($.extend(restArr.saveActReq,{"dto.act.id":row.Code,"dto.act.Active":active}),function(rtn){
							if (rtn.success==1){
								$.messager.popover({msg:rtn.msg,type:'success'});
							}else{
								$.messager.popover({msg:rtn.msg,type:'error'});
							}
						});
					}}}*/