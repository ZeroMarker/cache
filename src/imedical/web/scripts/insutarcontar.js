/**
 * 医保特殊收费项目对照JS
 * Zhan 201409
 * 版本：V1.0
 * easyui版本:1.3.2
 * 2019-10-24 tangzf 优化代码
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
	// 查询面板回车事件
	init_Keyup();
	
	//初始化医保json 采用HISUI方式加载数据
	//GetjsonQueryUrl();
	
	//初始化医保类型combogrid
	init_InsuType();
	
	//初始化项目类型
	init_Type();
	
	//初始化对照关系
	init_ConType();
	
	//初始查询条件
	init_QClase();
	
	//west 收费grid
	init_dg();
	
	//east 虚拟收费项grid
	init_wdg();
	
	//south 对照明细历史
	init_Coninfo();
	
	//自适应
	init_layout();
	
	// 对照按钮
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
	
	// 默认生效日期
	GetConDateByConfig();
	//disinput(true);
	
	//$('#btnAdd').attr("disabled",BDPAutDisableFlag('btnAdd'));
	//$('#btnUpdate').attr("disabled",BDPAutDisableFlag('btnUpdate'));
	//$('#btnDelete').attr("disabled",BDPAutDisableFlag('btnDelete'));
	//$('#btnAdd').attr("disabled",true);	
});
 
/*
 *查询HIS收费项目数据 west grid
 */
function Query(){
	// tangzf 2020-6-17 使用HISUI接口 加载数据
	var QClase = getValueById('QClase');
	var KeyWords = getValueById('KeyWords');
	var Type = $('#Type').combobox('getValue'); //项目类别
	var ConType = getValueById('ConType'); 
	var InsuType = $('#insuType').combobox('getValue'); 
	var VirmTarFlag = 'N' // 虚拟收费项目标志
	var tmpARGUS = KeyWords + GV.ArgSpl + QClase+GV.ArgSpl + Type + GV.ArgSpl + ConType + GV.ArgSpl + VirmTarFlag + GV.ArgSpl + InsuType + GV.ArgSpl + PUBLIC_CONSTANT.SESSION.HOSPID;
	var QueryParam={
		ClassName:'web.DHCINSUTarConTar' ,
		QueryName: 'QueryTarInfo',
		InArgs : tmpARGUS,
	}
	loadDataGridStore('dg',QueryParam);	
}

//更新保存记录
function SaveCon(rowIndex){
	
	if( typeof rowIndex == 'number' ||typeof rowIndex == 'string'   ){
		$('#wdg').datagrid('selectRow', rowIndex); // 点击图标即可对照
	}
	var selInsuData = $('#wdg').datagrid('getSelected');
	var selHisData = $('#dg').datagrid('getSelected');
	if(!selInsuData || !selHisData){
		$.messager.alert('提示','请选择要对照的记录!','info'); 
		return; 
	}
	var editrow=ConGrid.datagrid('getRows')[EditIndex];
	//alert(editrow['conActDate'])
	var sconActDate=$('#dd').datebox('getValue'); //editrow['conActDate']
	var userID=session['LOGON.USERID'];
	var tmptype=$('#Type').combobox('getValue');
	$.messager.confirm('提示','你确认要把 '+selHisData.desc+' 对照成 '+selInsuData.desc+' 吗?',function(r){
		if(r){
			//如果有乱码就用JS的cspEscape()函数加密
			//var UpdateStr=""+"^"+selHisData.rowid+"^"+selHisData.code+"^"+eval(selInsuData.rowid)+"^"+selInsuData.code+"^"+tmptype+"^"+GetToday()+"^"+$('#insuType').combobox('getValue')+"^"+"^"
			var UpdateStr=""+"^"+selHisData.rowid+"^"+selHisData.code+"^"+selInsuData.rowid+"^"+selInsuData.code+"^"+tmptype+"^"+sconActDate+"^"+$('#insuType').combobox('getValue')+"^"+"^" + PUBLIC_CONSTANT.SESSION.HOSPID;
			var savecode=tkMakeServerCall("web.DHCINSUTarConTar","Update","","",UpdateStr);
			if(eval(savecode)>=0){
				MSNShow('提示','对照成功！',2000);
				movenext(grid)
			}else{
				$.messager.alert('提示','增加虚拟收费项成功,但对照失败，需要手工对照!','info');  
			}
			ConGridQuery();
		}else{
			ConGrid.datagrid('deleteRow',EditIndex);
			ConAct("insertRow");
		};	
	})	
}
// 对照成功后 dg 自动切换到下一条
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
//删除记录
function DelCon(rowIndex){
	if(typeof rowIndex == 'number' ||typeof rowIndex == 'string'){
		$('#coninfo').datagrid('selectRow', rowIndex);
	}
	//if(BDPAutDisableFlag('btnDeleteCon')!=true){$.messager.alert('提示','您无权限,请联系管理员授权!');return;}
	var tmpdelid=""
	var selected =ConGrid.datagrid('getSelected');
	if (selected){
		if(selected.vsId!=""){
			tmpdelid=selected.vsId
		}
	}	
	if(tmpdelid==""){$.messager.alert('提示','请选择要删除的记录!','info');return;}
	
	$.messager.confirm('请确认','你确认要删除这条对照记录吗?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.DHCINSUTarConTar","Delete","","",tmpdelid)
			if(eval(savecode)>=0){   
				MSNShow('提示','删除成功!',2000)
			}else{
				$.messager.alert('提示','删除失败!','info');   
			}
			ConGridQuery()
		}else{
			return;	
		}
	});
	
} 
//查询对照历史记录
function ConGridQuery(){
	var SelectRow = $('#dg').datagrid('getSelected');
	if(SelectRow){
		var RowId = SelectRow.rowid;	
	}else{
		var RowId = '';
	}
	// tangzf 2020-6-17 使用HISUI接口 加载数据
	var QClase = $('#QClase').combobox('getValue');
	var Type = $('#Type').combobox('getValue'); //项目类别
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
//取当天日期
function GetToday(){
	return getDefStDate(0);
}


function AddVirItem(){
	//if(BDPAutDisableFlag('btnAdd')!=true){$.messager.alert('提示','您无权限,请联系管理员授权!');return;}
	//var UpdateStr=rowid+"^"+ssTarId+"^"+ssHisCode+"^"+flag+"^"+ssvsHisCode+"^"+Type+"^"+ssiActDate+"^"+"^"+"^"
	//w ##class(web.DHCINSUTarConTar).TarChange("","","XY00233^03")
	var selHisData = $('#dg').datagrid('getSelected');
	if(!selHisData){
		$.messager.alert('提示','请先在左边的列表中选一条记录!','info');
		return;	
	}
	var tmphiscode=selHisData.code;
	var tmphisdesc=selHisData.desc;
	var tmptype=$('#right-Type').combobox('getValue');
	var tmptypedesc=$('#right-Type').combobox('getText');
	var tmpsaveinfo=tmphiscode+"^"+tmphisdesc+"^"+tmptype;
	var txtVirCode=getValueById('txtVirCode');
	
	if(txtVirCode == '' || txtVirCode == undefined ){
		$.messager.alert('提示','新增虚拟项目时,自定义代码不能为空','info');
		return;	
	}
	//特殊字符^的处理
	txtVirCode = txtVirCode.replace(/\^/g,"");
	$.messager.confirm('请确认','你确认要给:'+tmphisdesc+"增加一条类别为 "+tmptypedesc+" 的虚拟收费项目吗?",function(fb){
		if(fb){
			
			var savecode=tkMakeServerCall("web.DHCINSUTarConTar","TarChange","","",tmphiscode+"^"+tmptype+"^"+txtVirCode,PUBLIC_CONSTANT.SESSION.HOSPID);
			if(eval(savecode)>=0){ 
				var UpdateStr=""+"^"+selHisData.rowid+"^"+tmphiscode+"^"+eval(savecode)+"^"+""+"^"+tmptype+"^"+GetToday()+"^"+$('#insuType').combobox('getValue')+"^"+"^" + PUBLIC_CONSTANT.SESSION.HOSPID;
				var savecode=tkMakeServerCall("web.DHCINSUTarConTar","Update","","",UpdateStr)
				if(eval(savecode)>=0){
					MSNShow('提示','操作成功！',2000);
				}else{
					$.messager.alert('提示','增加虚拟收费项成功,但对照失败，需要手工对照!','info');  
				}
			}else{
				if((savecode=="-120")||(savecode=="-130")){savecode="已经有同类虚拟收费项目!不用再增加了!  请直接在下面回车查询对照即可！"}
				if(savecode=="-110"){savecode="非法的收费项,可能是收费项维护的问题！"}
				$.messager.alert('提示','注意：'+savecode,'info');   
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
	//if(BDPAutDisableFlag('btnDeleteTar')!=true){$.messager.alert('提示','您无权限,请联系管理员授权!');return;}
	var tmpConId=""	//对照的虚拟项目rowid
	var tmpvsHisDesc=""
	var selected =ConGrid.datagrid('getSelected');
	if(!selected){
		$.messager.alert('提示','请先选择一条对照记录！','info');
		return;
	}
	if (selected){
		if(selected.ConId!=""){
			tmpConId=selected.ConId
			tmpvsHisDesc=selected.vsHisDesc
		}
	}	
	if(tmpConId==undefined || tmpConId==""){$.messager.alert('提示','请先选择一条对照记录！','info');return;}
	$.messager.confirm('请确认','你确认要删除:'+tmpvsHisDesc+"这条虚拟收费项目吗?",function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.DHCINSUTarConTar","DeleteAllCon",tmpConId);
			if(eval(savecode)>=0){ 
				var savecode=tkMakeServerCall("web.DHCINSUTarConTar","TarDelete","","",tmpConId,PUBLIC_CONSTANT.SESSION.HOSPID);
				if(eval(savecode)>=0){
					MSNShow('提示','删除成功！',2000);
				}else{
					$.messager.alert('提示','删除对照成功，但删除虚拟收费项失败!错误代码:'+savecode,'info');  
				}
			}else{
				if(savecode=="-101"){savecode="不能删除实际的收费项目!"}
				$.messager.alert('提示','删除失败!'+savecode,'info');   
			}
			ConGridQuery()
		}else{
			return;	
		}
		QueryINSUTarInfoNew();
		ConGrid.datagrid('unselectAll');
	});
}


//增加记录
function ConAct(act){
	//if(BDPAutDisableFlag('btnCon')!=true){$.messager.alert('提示','您无权限,请联系管理员授权!');return;}
	var lastIndex=0
	
	/*
	var selected = grid.datagrid('getSelected');
	if(!selected){
		$.messager.alert('消息',"请选择一条收费项再添加!");
		return;
	}
	*/
	//alert(ConGrid.datagrid('getRows').length-1)
	if(selHisData==""){
		$.messager.alert('消息',"请选择一条收费项再添加!",'info');
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
	// tangzf 2020-6-17 使用HISUI接口 加载数据
	var QClase = getValueById('right-QClase');
	var KeyWords = getValueById('right-KeyWords');
	var Type = $('#right-Type').combobox('getValue'); //项目类别
	var ConType = "N"; 
	var InsuType = ''; //$('#insuType').combobox('getValue'); 
	var VirmTarFlag = 'Y' // 虚拟收费项目标志
	
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
		//collectButtonLeft.click(); // 自动折叠测菜单
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
		//解决低分辨率按钮变形
		$('#searchTablePanel').find('.hisui-panel').css('width',window.screen.availWidth); 
		$('#searchTablePanel').find('.panel-header').css('width',window.screen.availWidth);
		$('#searchTablePanel').find('.panel').css('width',window.screen.availWidth);
		$('#searchTablePanel').css('overflow','scroll');
	
	}
}
/*
 * Creator: tangzf
 * CreatDate: 2019-6-12
 * Description: 查询面板回车事件
 */
function init_Keyup() {
	//医保目录对照
	$('#KeyWords').keyup(function(){
		if(event.keyCode==13){
			Query();
		}
	});
	//医保目录(医保中心)
	$('#right-KeyWords').keyup(function(){
		if(event.keyCode==13){
			QueryINSUTarInfoNew();
		}
	});
}
///获取配置的默认生效时间
///注意：如果为空默认当前时间
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
 * 医保类型combogrid
 */
function init_InsuType(){	
	//下拉列表
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
	        {field:'cCode',title:'代码',width:60},  
	        {field:'cDesc',title:'描述',width:100}  
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
 * 项目类型
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
	        {field:'cCode',title:'代码',width:60},  
	        {field:'cDesc',title:'描述',width:100}
	        
	    ]],
	    onLoadSuccess:function(data){
		    setValueById('Type',data.rows[0].cCode);
		    setValueById('right-Type',data.rows[0].cCode);
		}
	});	
}
/*
 * 对照关系
 */
function init_ConType(){
	$('#ConType').combobox({   
	    panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: 'A',
			Desc: '查询所有',
			selected:true
		},{
			Code: 'Y',
			Desc: '查询已对照项'
		},{
			Code: 'N',
			Desc: '查询未对照项'
		}]

	}); 
}
/*
 * 查询条件
 */
function init_QClase(){
	$('.QClase').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '1',
			Desc: '按拼音',
			selected:true
		},{
			Code: '2',
			Desc: '按代码'
		},{
			Code: '3',
			Desc: '按名称'
		}]
	});	
}
/*
 * 初始化west 收费项目 dg
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
			{ field: 'code', title: '项目代码', width: 100, align: 'center'},
			{ field: 'desc', title: '项目名称', width: 250, align: 'center'},
			{ field: 'TarUomDesc', title: '单位', width: 60, align: 'center'},
			{ field: 'TarPrice', title: '单价', width: 80, align: 'center'},
			{ field: 'TarActiveFlag', title: '有效标志', width: 55, align: 'center'},
			{ field: 'TarSubCateDesc', title: '收费项目子类', width: 120, align: 'center'},
			{ field: 'TarInpatCateDesc', title: '住院费用子类', width: 120, align: 'center'},
			{ field: 'TarOutpatCateDesc', title: '门诊费用子类', width: 120, align: 'center'},
			{ field: 'TarNewMRCateDesc', title: '新病案首页子类', width: 120, align: 'center'},
			{ field: 'TarSpecialFlag', title: '特殊标记', width: 55, align: 'center'},
			{ field: 'TarExternalCode', title: '外部代码', width: 100, align: 'center'},
			{ field: 'TarChargeBasis', title: '收费依据', width: 100, align: 'center'},
			{ field: 'TarEngName', title: '收费说明', width: 100, align: 'center'}/*,
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
 * 初始化east 虚拟收费项
 */
function init_wdg(){
	var querycol= [[   
			{field:'rowid',title:'rowid',width:60,hidden:true},
			{field:'code',title:'虚拟收费项代码',width:120},
			{field:'desc',title:'虚拟收费项名称',width:130},
			{field: 'TarUomDesc', title: '单位', width: 60, align: 'center'},
			{field: 'TarPrice', title: '单价', width: 60, align: 'center'},
			{field: 'TarSubCateDesc', title: '收费项目子类', width: 90, align: 'center'}
	        
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
				field: 'Option', title: '对照', width: 50
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
 * 初始化south 对照历史
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
				field: 'undo', title: '撤销', width: 50
				,formatter:function(value,data,row){
					return "<a href='#' onclick='DelCon(\""+row+"\")'>\
					<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png ' border=0/>\
					</a>";
				}
			}
		]],
		columns:[[
			{field:'TarId',title:'TarId',width:40,hidden:true},
			{field:'ConId',title:'特殊项目ID',width:80},
			{field:'vsId',title:'对照ID',width:70},
			{field:'vsHisCode',title:'虚拟收费项目代码',width:100,editor:{
				type:'text'	
			}},
			{field:'vsHisDesc',title:'虚拟收费项目名称',width:200,editor:{
				type:'text'	
			}},
			
			{field:'typedesc',title:'对照类别',width:90},
			{field:'conActDate',title:'生效日期',width:75,editor:{
				type:'datebox'	
			}},
			{field:'coninsutype',title:'医保类别',width:90},
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