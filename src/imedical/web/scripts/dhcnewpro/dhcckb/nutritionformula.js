///Author:    qiaoqingao
$(function(){ 

	initPage();
	
	initTable();
	
	initCombobox();
	
	initMethod();
	
	addMenuList("");
});

function initPage(){
	
	///获取数据
	$cm({
		ClassName:"web.DHCCKBNutritionFormula",
		MethodName:"listMenuData"
	},function(jsonData){
		addMenuList(jsonData);
	});
}

function initCombobox(){
	$HUI.combobox('#patType',{
		url:LINK_CSP+'?ClassName=web.DHCCKBNutritionFormula&MethodName=listPatType',
		valueField:'value',
		textField:'text',
		mode:'local',
		editable:false,
		onSelect:function(option){
	       loadTable();
	    }
	})
	$HUI.combobox('#patType').setValue('A');
	loadTable();
	
	
	$HUI.combobox('#nutType',{
		url:LINK_CSP+'?ClassName=web.DHCCKBNutritionFormula&MethodName=listNutType',
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    }
	})
	
	$HUI.combobox('#nutCat',{
		url:'',
		valueField:'value',
		textField:'text',
		data:[
			{value:'患者信息',text:'患者信息'},
			{value:'脂肪乳稳定性',text:'脂肪乳稳定性'},
			{value:'营养供给分析',text:'营养供给分析'},
			{value:'其他',text:'其他'}
		],
		onSelect:function(option){
	       
	    }
	})
	
}

function initTable(){
	
	var flagEdit={
		type:'combobox',
		options:{
			valueField:'value',
			textField:'text',
			data:[
				{'value':'Y','text':'是'},
				{'value':'N','text':'否'}
			],
			required:true,
			editable:false
		}
	}
	
	var columns=[[
		{field:'id',title:'id',width:120,editor:{type:'validatebox',options:{}},hidden:true},
		{field:'cat',title:'类别',width:200,editor:{type:'validatebox',options:{required:true}}},
		{field:'patType',title:'患者类型',width:120,formatter:formatCombobox,hidden:true,
			editor:editCombObj({
				options:{mode:'local',url:LINK_CSP+'?ClassName=web.DHCCKBNutritionFormula&MethodName=listPatType'}
			})
		},
		{field:'nutType',title:'相关营养成分',width:120,formatter:formatCombobox},
		{field:'desc',title:'描述',width:200,editor:{type:'validatebox',options:{required:true}}},
		{field:'press',title:'计算公式',width:520,editor:{type:'validatebox',options:{required:true}}},
		{field:'scope',title:'范围',width:80},
		{field:'note',title:'备注',width:250},
		{field:'flag',title:'是否可用',align:'center',width:70,formatter:flagFormat,editor:flagEdit},
		//{field:'order',title:'排序',align:'center',width:70,formatter:flagFormat},
		{field:'patTypeDesc',title:'患者类型描述',width:120,hidden:true},
		{field:'nutTypeDesc',title:'营养成分描述',width:120,hidden:true}
	]]
	
	
	$HUI.datagrid('#datagrid',{
		title:'所需营养表达式维护',
		headerCls:'panel-header-gray',
		columns:columns,
		border:true,
		toolbar:'#toolbar',
	    rownumbers:true,
	    method:'get',
	    fitColumns:false,
	    singleSelect:true,
	    pagination:true,
	    nowrap: false,
	    onDblClickRow:onClickRow, 
		url:LINK_CSP+'?ClassName=web.DHCCKBNutritionFormula&MethodName=list',
		onClickRow:clickRow
	})
}

///绑定方法
function initMethod(){
	$('#code').bind('keypress',function(event){
		event.keyCode == '13'?loadTable():'';
    });
    $('#desc').bind('keypress',function(event){
		event.keyCode == '13'?loadTable():'';
    });	
    
    $('#selectParams').on('click',showParamsMenu);
	
	$(document).on('click',function(){
		$('#paramAttr').hide();
	})
	
	$('#press').on('keydown',function(){
		console.log('keydown:'+$('#press').val());	
	})
	$('#press').on('keyup',function(){
		updatePressDesc();	
	})
	
	$('#press').on('click',pressClick);
	
	$('#press').on('keydown', function() {
		if(event.keyCode===8){pressDelete();}
	})
	
}

///展示下拉menu菜单
function showParamsMenu(){
	var elPos=elPosition('selectParams');
	$('#paramAttr').css({top:elPos.y,left:elPos.x});
	$('#paramAttr').show();
	return;
}

function formatCombobox(value,row,index){
	return row[this.field+'Desc'];
}

function editCombObj(setObj){
	var defaultData={
		type:'combobox',
		options:{
			valueField:'value',
			textField:'text',
			url:'',
			required:true,
			blurValidValue:true
		}
	}
	return $.extend({},defaultData,setObj)
}

///是否下拉
function flagFormat(value,row,index){
	if (value=='Y') return '是';
	return '否';
}


function addRow(){
	
	//commonAddRow({'datagrid':'#datagrid',value:{'id':'','code':'','desc':'','flag':'Y'}})
}
//双击编辑
function onClickRow(index,row){
	//editIndex == undefined?'':editComboFun(editIndex,row,'#datagrid');
	//CommonRowClick(index,row,'#datagrid');
}

function editComboFun(index,row,idPress){
	//列表中下拉框实现，修改后把回写feetypename，因为formatter显示的是feetypename字段
	var ed = $(idPress).datagrid('getEditor', {index:index,field:'unit'});
	var unitDesc = $(ed.target).combobox('getText');
	$(idPress).datagrid('getRows')[index]['unitDesc'] = unitDesc;
	return;	
}

function save(){
	saveByDataGrid('web.DHCCKBNutritionFormula','save','#datagrid',function(data){
		if(data==0){
			loadTable();
		}else if(data==1){
			$.messager.alert('提示','代码已存在,不能重复保存!'); 
			loadTable();
		}else{	
			$.messager.alert('提示','保存失败:'+data)
			
		}
	});	
}

function delet(){
	if ($('#datagrid').datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
	    if (r){
		    var row =$('#datagrid').datagrid('getSelected');     
			runClassMethod('web.DHCCKBNutritionFormula','delete',{'id':row.id},function(data){ 
				loadTable();
			})
	    }    
	}); 
}

///刷新table
function loadTable(){
	var patType = $HUI.combobox('#patType').getValue();
	var nutType = $HUI.combobox('#nutType').getValue();
	var nutCat = $HUI.combobox('#nutCat').getText();
	var params=patType+'^'+nutType+'^'+nutCat;
	$HUI.datagrid('#datagrid').load({
		params:params
	})	
}

///按钮事件
function big(type){
	var str=$('#press').val();
	$('#press').val(str+type);
}

///添加哦
function addMenuList(menuData){
	
	$('#paramAttr').html('');	
	var appendHtml="";
	for (var i in menuData){
		var oneData = menuData[i];
		var itemsData = oneData.items;
		appendHtml=appendHtml+
			'<li style="cursor:default" class="dropdown-submenu">'+
				'<a href="javascript:void(0)" onclick="" data="'+oneData.id+'">'+oneData.desc+'</a>'+
				'<ul class="dropdown-menu dropdown-context dropdown-context-sub">'+
					'<div style="margin-left: 2px;margin-right: 2px"><i class="glyphicon glyphicon-filter"'+
						'style="color:#006600;margin-left: 2px;margin-right: 2px"></i>'+
						'<input type="text" onkeydown="if(event.keyCode==13) enterVarFind(this)" datadesc="'+oneData.desc+'"'+
						'class="textbox" placeholder="输入值后回车查询"'+
						'style="width: 85%;display: inline-block;height: 26px;padding: 1px;font-size: 12px;">'+
					'</div>'
	
		for (var j in itemsData){
			appendHtml=appendHtml+
				'<li style="cursor:default;float:left;width:180px;">'+
					'<a href="javascript:void(0)" onclick="selItems(this)" par_data="'+oneData.id+'" data_id="'+itemsData[j].id+'"'+
					' name="'+oneData.desc+'">'+itemsData[j].desc+'</a>'+
				'</li>'
		}
		
		appendHtml=appendHtml+
				'</ul>'+
			'</li>'
	}
	$('#paramAttr').html(appendHtml);
	
	$('#paramAttr>li').bind('mousemove',function(){
		$(this).find('.dropdown-menu').css({visibility: 'visible'});
	})
	
	$('#paramAttr>li').bind('mouseout',function(){
		$(this).find('.dropdown-menu').css({visibility: 'hidden'});
	})
	return;
}


function selItems(_this){
	var oldValue=$('#press').val();
	//var oldValueDesc=$('#pressDesc').val();
	var itemPressDesc ='['+$(_this).attr('name')+':'+$(_this).text()+']';
	var itemPress ='['+$(_this).attr('par_data')+':'+$(_this).attr('data_id')+']';
	$('#press').val(oldValue+itemPress);
	//$('#pressDesc').val(oldValueDesc+itemPressDesc);
	$('#paramAttr').hide();
	
	updatePressDesc(); ///显示表达式描述
}

function clearPress(){
	$('#press').val('');
	$('#pressDesc').text('');
}

function clearAll(){
	$('#id').val('');
	//$HUI.combobox('#patType').setValue('');
	$HUI.combobox('#nutType').setValue('');
	$('#press').val('');
	$('#pressDesc').text('');
	$HUI.combobox('#nutCat').setValue('');
	$('#nutDesc').val('');
	$('#nutNote').val('');
	$('#minValue').val('');
	$('#maxValue').val('');
	$('#numValue').val('');
	setSymbol('min','');
	setSymbol('max','');
	return;
}

function cleaAndLoad(){
	clearAll();
	loadTable();
}

function saveExpress(model){
	var id = (model==='add'?'':$('#id').val());
	var patType = $HUI.combobox('#patType').getValue();
	var nutType = $HUI.combobox('#nutType').getValue();
	var nutCat = $HUI.combobox('#nutCat').getValue();
	var desc = $('#nutDesc').val();
	var press = $('#press').val();
	var flag = $HUI.checkbox('#flag').getValue()?'Y':'N';
	var nutNote = $('#nutNote').val();
	var checkedVal=$("input[name='pressType']:checked").val();
	var scope='';
	if(checkedVal==='num'){
		scope=$('#numValue').val();
	}else{
		var minValue=$('#minValue').val();
		//minValue==parseInt(minValue)?'':minValue='';
		var minSymbol=$('#minSymbol').attr('data-val');
		var maxValue=$('#maxValue').val();
		//maxValue==parseInt(maxValue)?'':maxValue='';
		var maxSymbol=$('#maxSymbol').attr('data-val');
		scope=minValue+(minSymbol==='>='?'*':'')+'-'+maxValue+(maxSymbol==='<='?'*':'');
	}	
	
	var params=id+'^'+patType+'^'+nutType+'^'+nutCat+'^'+desc+'^'+press+'^'+flag+'^'+scope+'^'+nutNote;
	
	$cm({
		ClassName:"web.DHCCKBNutritionFormula",
		MethodName:"save",
		params:params,
		dataType:'text'
	},function(ret){
		if(ret==='0'){
			$.messager.alert('提示','成功!');
			cleaAndLoad();
		}else{
			$.messager.alert('提示','失败!'+ret);
		}
	});
}

function clickRow(rowIndex, rowData){
	$('#id').val(rowData.id);
	$HUI.combobox('#patType').setValue(rowData.patType);
	$HUI.combobox('#nutType').setValue(rowData.nutType);
	$('#press').val(rowData.press);
	$('#pressDesc').text(rowData.pressDesc);
	var isCheck=(rowData.flag==='Y'?true:false);
	$HUI.checkbox('#flag').setValue(isCheck);
	$HUI.combobox('#nutCat').setValue(rowData.cat);
	$('#nutDesc').val(rowData.desc);
	$('#nutNote').val(rowData.note);
	setScope(rowData.scope);
	return;
}

function pressTypeChange(){
	var checkedVal=$("input[name='pressType']:checked").val();
	if(checkedVal==='num'){
		$('.pressScope').hide();
		$('.pressNum').show();
		setSymbol('min','');
		setSymbol('max','');
		$('.pressScope').val('');
	}else{
		$('.pressScope').show();	
		$('.pressNum').hide();
		$('.pressNum').val('');
	}
	return;
}

function minSymbolClick(){
	var minSymbolText=$('#minSymbol').text();
	if(minSymbolText=='大于'){
		setSymbol('min','1');
	}else{
		setSymbol('min','');
	}
	return;
}

function setSymbol(cat,type){
	if(cat==='max'){
		if(type==='1'){
			$('#maxSymbol').attr('data-val','<=');
			$('#maxSymbol').text('小于等于');	
		}else{
			$('#maxSymbol').attr('data-val','<');
			$('#maxSymbol').text('小于');
		}
	}else{
		if(type==='1'){
			$('#minSymbol').attr('data-val','>=');
			$('#minSymbol').text('大于等于');	
		}else{
			$('#minSymbol').attr('data-val','>');
			$('#minSymbol').text('大于');
		}
	}
}

function maxSymbolClick(){
	var minSymbolText=$('#maxSymbol').text();
	if(minSymbolText=='小于'){
		setSymbol('max','1');
	}else{
		setSymbol('max','');
	}
	return;
}

function setScope(scopeValue){
	var minValue=scopeValue.split('-')[0];
	var maxValue=scopeValue.split('-')[1];
	
	if(scopeValue.indexOf('-')!=-1){
		setSymbol('min',minValue.indexOf('*')!=-1?'1':'');
		setSymbol('max',maxValue.indexOf('*')!=-1?'1':'');
		$('#minValue').val(parseInt(minValue)||'');
		$('#maxValue').val(parseInt(maxValue)||'');
		$('[name="pressType"][value="scope"]').radio('setValue',true);
	}else{
		$('#numValue').val(minValue);
		$('[name="pressType"][value="num"]').radio('setValue',true);
	}
	return;
}

function pressClick() {
	var input = $('#press')[0];
	opParItems({
		id:'press',
		selectionStart: input.selectionStart,
		selectionEnd: input.selectionEnd
	})
}

function opParItems(parObj) {
	var defParObj = {
		selectSuccess:function(itmData){}
	}
	var parObj=$.extend({},defParObj,parObj);
	var idSelect = '#'+parObj.id;
	var selectionStart = parObj.selectionStart;
	var selectionEnd = parObj.selectionEnd;
	var matchObj = $(idSelect).val().searchMatchAll('/\[[\u4e00-\u9fa5_0-9A-D\|\:]+\]/g');
	//光标位置
	//console.log(matchObj);
	//console.log(selectionStart, selectionEnd);

	var retObj = {};
	for (var i in matchObj) {
		var thisObj = matchObj[i];
		var stPos = thisObj.stPos;
		var endPos = thisObj.endPos;
		if ((selectionStart === stPos) && (selectionEnd === endPos)) {
			break;
		}
		if (selectionStart === selectionEnd) {
			if ((selectionStart - stPos > 0) && (selectionStart - endPos < 0)) {
				retObj = $.extend({}, thisObj, {
					index: i
				});
				break;
			}
		}
	}
	if (JSON.stringify(retObj) !== '{}') {
		$(idSelect)[0].setSelectionRange(retObj.stPos, retObj.endPos);
		$(idSelect).attr('data-index', retObj.index);
		parObj.selectSuccess(retObj);
	} else {
		$(idSelect).attr('data-index', '');
	}
}

//表达式描述
function updatePressDesc(){
	$cm({
		ClassName:"web.DHCCKBNutritionFormula",
		MethodName:"pressDesc",
		press:$('#press').val(),
		dataType:'text'
	},function(ret){
		$('#pressDesc').html(ret);
	});	
}

function pressDelete(){
	var input = $('#press')[0];
	if(input.selectionStart===input.selectionEnd){
		var selectionPos = input.selectionStart?input.selectionStart-1:input.selectionStart;
		opParItems({
			id:'press',
			selectionStart:selectionPos,
			selectionEnd: selectionPos
		})
	}
}


String.prototype.searchMatchAll = function(regStr) {
	//debugger;
	var ret = [];
	var reg = new RegExp(eval(regStr));
	var _s = this;
	var textArray = _s.match(reg);
	var nowStPos = 0,
		matchStr = '';
	// 考虑到会有重复的情况
	for (var i in textArray) {
		matchStr = _s.substring(nowStPos, _s.length);
		var thisText = textArray[i];
		var thisStPos = matchStr.indexOf(thisText);
		var stPos = nowStPos + thisStPos;
		var endPos = stPos + thisText.length;
		ret.push({
			stPos: stPos,
			endPos: endPos,
			text: thisText
		});
		nowStPos = endPos;
	}
	return ret;
}

function elPosition(id){
	var elContent=document.getElementById(id).getBoundingClientRect();
	var scrollX = document.documentElement.scrollLeft || document.body.scrollLeft;
	var scrollY = document.documentElement.scrollTop || document.body.scrollTop;
	var x = elContent.x + scrollX ;
	var y = elContent.y + scrollY + elContent.height;	
	return {x:x,y:y};
}