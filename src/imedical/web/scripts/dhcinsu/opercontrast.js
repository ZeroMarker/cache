/**
 * 医保手术对照JS
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
	//回车事件
	init_Keyup();
	//医保目录对照(HIS)下拉列表
	init_INSUTarcSearchPanel();
	//初始化对照的grid west
	init_dg();
	//医保目录(医保中心) east
	init_wdg();
	//对照明细历史 south
	init_ContraHistory();
	//
	init_layout();
	$('#south-panel').panel('collapse');
	
	//日期初始化
	init_Date();
	//院内版本
	init_HisVer();
	//医保版本
	init_Ver();
});

function init_Date(){
	InsuDateDefault('dd');
}

//查询医保手术对照目录数据
function QueryINSUInfoNew(){
	if(getValueById('right-KeyWords')==''){
		$.messager.alert('提示','关键字不能为空','error');
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
 
//查询对照历史记录
function ConGridQuery(rowIndex,rowData){
	// tangzf 2020-6-19 改为HISUI接口加载数据
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
//更新保存记录
function SaveCon(rowIndex){
	if( typeof rowIndex == 'number' ||typeof rowIndex == 'string'   ){
		$('#wdg').datagrid('selectRow', rowIndex); // 点击图标即可对照
	}
	var selInsuData = $('#wdg').datagrid('getSelected');
	var selHisData = $('#dg').datagrid('getSelected');
	
	if(!selHisData || !selInsuData){
		$.messager.alert('提示','请选择一条记录才能对照!','info');	
		return;		
	}
	var sconActDate = getValueById('dd');
	var userID = session['LOGON.USERID'];
	var valNote = $HUI.validatebox("#HisNotecon")
	if (!valNote.isValid()){
		$.messager.alert('提示','备注字段不在合法范围内','info',function(){	focusById('HisNotecon',100);});	
		return;
		}
	var hisNote = getValueById('HisNotecon');
	
	$.messager.confirm('提示','你确认要把 '+selHisData.HisOperDesc+' 对照成 '+selInsuData.ssmc+' 吗?',function(r){
		if(r){
			//如果有乱码就用JS的cspEscape()函数加密
			//var UpdateStr="^"+selHisData.Rowid+"^"+selHisData.HisOperCode+"^"+selHisData.HisOperDesc+"^"+selInsuData.INDISRowid+"^"+selInsuData.ssbm+"^"+selInsuData.ssmc+"^"+$('#Source').combobox('getValue')+"^"+$('#insuType').combobox('getValue')+"^"+sconActDate+"^^"+userID+"^^^^^"+hisNote+"^"+selHisData.SourceVer+"^^^^"+PUBLIC_CONSTANT.SESSION.HOSPID;
			var UpdateStr="^"+selHisData.Rowid+"^"+selHisData.HisOperCode+"^"+selHisData.HisOperDesc+"^"+selInsuData.INDISRowid+"^"+selInsuData.ssbm+"^"+selInsuData.ssmc+"^"+$('#Source').combobox('getValue')+"^"+$('#insuType').combobox('getValue')+"^"+sconActDate+"^^"+userID+"^^^^^"+hisNote+"^"+selHisData.VerCode+"^^^^"+PUBLIC_CONSTANT.SESSION.HOSPID+"^"+selHisData.VerCode+"^"+selInsuData.Ver;	 //upt 20230203 HanZH 新增版本字段
			
			var savecode=tkMakeServerCall("web.INSUOPERContrastCtl","SaveCont",UpdateStr);
			if(savecode==null || savecode==undefined) savecode=-1;
			//alert(savecode.split("!")[0])
			// if(eval(savecode.split("!")[0])>=0){
			// 	//$.messager.alert('提示','保存成功!');
			// 	MSNShow('提示','对照成功！',2000)
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
			// 	$.messager.alert('提示','保存失败!'+savecode,'info');   
			// }
			if(eval(savecode.split("!")[0])>=0){
				//$.messager.alert('提示','保存成功!');
				//MSNShow('提示','对照成功！',2000)
				//upt HanZH 20230215
				if (savecode.split("!").length>1){
					MSNShow('提示',savecode.split("!")[1],2000)
				}else{MSNShow('提示','对照成功！',2000)}
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
				$.messager.alert('提示','保存失败!'+savecode,'info');   
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
//删除记录
function DelCon(rowIndex){
	if(typeof rowIndex == 'number' ||typeof rowIndex == 'string'){
		$('#coninfo').datagrid('selectRow', rowIndex);
	}
	//if(BDPAutDisableFlag('btnDelete')!=true){$.messager.alert('提示','您无权限,请联系管理员授权!');return;}
	var tmpdelid=""
	var selected = $('#coninfo').datagrid('getSelected');
	if (selected){
		if((selected.ConId!="")&&(undefined!=selected.ConId)){  //DingSH20170222
			tmpdelid=selected.ConId;
		}
	}	
	if(tmpdelid==""){$.messager.alert('提示','请选择要删除的记录!','info');return;}
	
	$.messager.confirm('请确认','你确认要删除这条记录吗?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.INSUOPERContrastCtl","DelCont",tmpdelid)
			//if(eval(savecode)>=0){
			if(eval(savecode.split("!")[0])>=0){
				//$.messager.alert('提示','删除成功!'); 
				//MSNShow('提示','删除成功！',2000);
				//upt HanZH 20230215
				if (savecode.split("!").length>1){
					MSNShow('提示',savecode.split("!")[1],2000)
				}else{MSNShow('提示','删除成功！',2000)}
				//movenext(grid)  

				var ICDSelected = $('#dg').datagrid('getSelected');
                if (ICDSelected){ConGridQuery(-1,ICDSelected)}
                var dgindex = $('#dg').datagrid('getRowIndex', ICDSelected);
				//$('#dg').datagrid('updateRow',{index: dgindex,row: {ConId:'',INSUdigDr:'',INSUDigCode:'',INSUDigDesc:'',ConUser:'',AutoConFlag:'',ConActDate:'',ConExpDate:''}});
				$('#dg').datagrid('updateRow',{index: dgindex,row: {ConId: "",INSUdigDr: "",INSUDigCode: "",INSUDigDesc: "",ConUser: "",AutoConFlag: "",ConActDate: "",ConExpDate: ""}}); //upt 20230302 HanZH
			}else{
				//$.messager.alert('提示','删除失败!','info');   
				$.messager.alert('提示','保存失败!'+savecode,'info'); 
			}
		}else{
			return;	
		}
	});
	
}
function AutoCon(){
	var tmpinsutype=$('#insuType').combobox('getValue')
	var userID=session['LOGON.USERID'];
	if(""==tmpinsutype){$.messager.alert('消息',"选择医保类别!",'info');return;}
	var tmpmsg='你确认批量自动对照吗?\n\r此操作会把当前医保类别的所有未对照手术和医保手术对照进行对照!\n\r建议在初次对照时操作。'
	$.messager.confirm('请确认',tmpmsg,function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.INSUDiagnosis","AutoCon",tmpinsutype+"^"+userID+'^'+PUBLIC_CONSTANT.SESSION.HOSPID)
			if(eval(savecode)>=0){
				MSNShow('提示','对照完毕!共成功'+savecode+'条!',2000)  
			}else{
				$.messager.alert('提示','对照时发生错误!','info');   
			}
		}else{
			return;	
		}
	});
	
}


//add xubaobao 2018 02 01
//确认并更新复审情况
function UpdateCon(ICDConID){
	if(ICDConID==undefined){
		$.messager.alert('提示','请选择有效的对照信息进行复审','info'); 
		return	
	}
	var userID=session['LOGON.USERID'];
	var AutoConFlag=tkMakeServerCall("web.INSUDiagnosis","GetDiagAutoConFlagByDr",ICDConID)
	
	if (AutoConFlag=="1"){
		// tangzf 2019-6-16 弹框方式修改
		$.messager.confirm('提示','本记录为系统自动对照，是否对该记录进行复审？',function(r){
			if(r){
				$.messager.confirm('提示','你确定要将该条记录置为审核通过状态？,取消将审核拒绝',function(r2){
					if(r2){
		      	  		var savecode=tkMakeServerCall("web.INSUDiagnosis","UpDateCheckUser",ICDConID,userID,"1")
			  	 	 	if(eval(savecode)>=0){
				    	 	Query();
				    		MSNShow('提示','审核成功！',2000)
			    		}else{
				    	 	$.messager.alert('提示','审核时发生错误!','info');   
			    		}
					}else{
						var savecode=tkMakeServerCall("web.INSUDiagnosis","UpDateCheckUser",ICDConID,userID,"2")
						if(eval(savecode)>=0){
							Query();
				     		MSNShow('提示','审核成功！',2000)
			    		}else{
				     		$.messager.alert('提示','审核时发生错误!','info');   
			    		}
					}	
				})
			}else{
				return;
			}	
		})
	}
}
//south 布局
function init_layout(){/*
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
	}*/
	if(window.screen.availWidth<1440){
		//解决低分辨率按钮变形
		$('#searchTablePanel').find('.hisui-panel').css('width',window.document.body.offsetWidth); 
		$('#searchTablePanel').find('.panel-header').css('width',window.document.body.offsetWidth);
		$('#searchTablePanel').find('.panel').css('width',window.document.body.offsetWidth);
		$('#searchTablePanel').find('.panel').css('height','107px');
		$('#searchTablePanel').css('overflow','scroll');
		
	}
	// 切换页签时（各个界面）IE兼容性问题，
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
 * 对照明细自适应
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
 * Description: 查询面板回车事件
 */
function init_Keyup() {
	//医保目录对照
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
			{field:'HisdigCode',title:'医院手术码',width:80,hidden:true},
			{field:'HisOperCode',title:'手术编码',width:120},
			{field:'HisOperDesc',title:'手术名称',width:200},
			{field:'Source',title:'数据来源',width:90},
			{field:'ConId',title:'ConID',width:80,hidden:true},
			{field:'INSUdigDr',title:'医保手术对照Dr',width:65,hidden:true},
			{field:'INSUDigCode',title:'医保手术对照代码',width:120},
			{field:'INSUDigDesc',title:'医保手术对照名称',width:200},
			{field:'ConActDate',title:'生效日期',width:90},
			{field:'ConExpDate',title:'失效日期',width:90},
			{field:'VerCode',title:'院内版本',width:120,hidden:true},
			{field:'VerDesc',title:'院内版本',width:150},
			{field:'InsuVer',title:'医保版本',width:120,hidden:true},
			{field:'InsuVerDesc',title:'医保版本',width:150},
			{field:'ConUser',title:'对照人',width:100},
			{field:'AutoConFlag',title:'系统对照标识',width:100,hidden:true},
			{field:'ReCheckFlag',title:'审核状态',width:80,hidden:true},
			{field:'ReCheckUser',title:'审核人',width:80,hidden:true},
			{field:'ReCheckDate',title:'审核日期',width:80,hidden:true},
			{field:'SourceVer',title:'数据源版本',width:100},
			{field:'HisNote',title:'备注',width:100}
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
 * 医保类型combogrid
 */
function init_InsuType(){	
	//下拉列表
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
 *数据来源combogrid
 */
function init_Source(){	
	//下拉列表
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
	        {field:'cCode',title:'代码',width:60},  
	        {field:'cDesc',title:'描述',width:100}  
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
			Desc: '查询所有',
			selected: true
		},{
			Code: 'Y',
			Desc: '查询已对照项'
		},{
			Code: 'N',
			Desc: '查询未对照项'
		}]

	}); 
	$('#QClase').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '1',
			Desc: '按手术编码',
			selected: true
		},{
			Code: '2',
			Desc: '按手术名称'
		}]
	}); 
	$('#right-QClase').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '1',
			Desc: '按代码',
			selected:true
		},{
			Code: '2',
			Desc: '按名称'
		}]
	});  
}
function init_wdg() { 
	var querycol= [[   
			{field:'INDISRowid',title:'INDISRowid',width:60,hidden:true},
			{field:'ssbm',title:'手术编码',width:55},
			{field:'ssmc',title:'手术名称',width:55},
			{field:'Ver',title:'版本',width:55,hidden:true},
			{field:'VerDesc',title:'版本',width:55}
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
				field: 'Option', title: '对照', width: 50
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
	//对照明细历史
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
				field: 'undo', title: '撤销', width: 50
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
			{field:'HisdigCode',title:'医院ICD',width:100,hidden:true},
			{field:'HisOperCode',title:'手术代码',width:100},
			{field:'HisOperDesc',title:'手术名称',width:180},
			{field:'INSUDigCode',title:'医保手术对照代码',width:120},
			{field:'INSUDigDesc',title:'医保手术对照名称'},
			{field:'ConActDate',title:'生效日期',width:100},
			{field:'ConExpDate',title:'失效日期',width:100},
			{field:'ConUser',title:'对照人',width:80},
			{field:'HisNote',title:'备注',width:150},
			{field:'ConId',title:'对照Rowid',width:100},
			{field:'INSUdigDr',title:'医保手术对照Dr',width:100},
			{field:'HisVer',title:'院内版本',width:120,hidden:true},
			{field:'HisVerDesc',title:'院内版本',width:150},
			{field:'Ver',title:'医保版本',width:120,hidden:true},
			{field:'VerDesc',title:'医保版本',width:150}
		]],
		onLoadSuccess:function(){
		},
		onDblClickRow : function(index,rowdata) {
			UpdateCon(rowdata.ConId);       //add xubaobao 2018 02 02
    	}
	});
	// 面板展开
	$('#south-panel').panel({
    	onCollapse:function(){
			//resizeLayout('Collapse');
    	},
    	onExpand:function(){
	    	//resizeLayout('Expand');
			
	    }
	});
}
///获取配置的默认生效时间
///注意：如果为空默认当前时间
function GetConDateByConfig()
{
    var rtnDate=""
	//var rtnDate=GetDicStr("SYS","INSUCONACTDATE",6);
	if(rtnDate==""){ 
	rtnDate=curDate();}
	return rtnDate; 
 }
 ///获取当前时间,支持时间格式
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


//查询手术对照数据
function Query(){
	var source=$('#Source').combobox('getValue');
	if(source==''){
		$.messager.alert('提示','数据来源不能为空','error');
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
//医保手术对照导出
function Export()
{
   try
   {
		var source=$('#Source').combobox('getValue');
		if(source==''){
			$.messager.alert('提示','数据来源不能为空','error');
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
		         title: "提示",
				 msg: '正在导出医保手术对照数据',
				 text: '导出中....'
				   });
			$cm({
				ResultSetType:"ExcelPlugin",  
				ExcelName:"医保手术对照",		  
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
	   $.messager.alert("警告",e.message);
	   $.messager.progress('close');
   }; 
   
}

//医保手术对照导入
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
         $.messager.alert('提示', '打开文件错误！'+rs.msg,'error');
      }				   
}

function importItm(filePath)
{
    if (filePath == "") {
        $.messager.alert('提示', '请选择文件！','info')
        return ;
    }
   $.messager.progress({
         title: "提示",
         msg: '医保手术对照导入中',
         text: '数据读取中...'
        }); 
   $.ajax({
	async : true,
	complete : function () {
    ReadItmExcel(filePath);
	}
	});
  
}
//读取Excel数据
function ReadItmExcel(filePath)
{
	
   //读取excel
   var arr;
   try 
   {
	 arr= websys_ReadExcel(filePath);
	 $.messager.progress("close");
	}
   catch(ex)
   {
	  $.messager.progress("close");
	  $.messager.alert('提示', '调用websys_ReadExcel异常：'+ex.message,'error')
	  return ;
	}
	 var rowCnt=arr.length
	 $.messager.progress({
            title: "提示",
            msg: '医保手术对照导入',
            text: '导入中，共：'+(rowCnt-1)+'条'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
       ItmArrSave(arr);
	}
	});
}
//医保手术对照数据保存
function ItmArrSave(arr)
{
	
	//读取保存数据
	var ErrMsg = "";     //错误数据
    var errRowNums = 0;  //错误行数
    var sucRowNums = 0;  //导入成功的行数
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
                    $.messager.alert('提示', '数据正确导入完成');
                } else {
                   $.messager.progress("close");
                     var tmpErrMsg = "导入成功："+sucRowNums +"条，失败："+errRowNums+"条。";
                     tmpErrMsg = tmpErrMsg + "<br>失败数据行号：<br>"+ ErrMsg;
                    $.messager.alert('提示', tmpErrMsg,'info');
                }
		      return ;
		 }
		 catch(ex)
		 {
			  $.messager.progress("close");
			  $.messager.alert('提示', '保存医保手术对照数据异常：'+ex.message,'error')
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
 *院内版本
 */
 function init_HisVer(){	
	//下拉列表
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
 *医保版本
 */
 function init_Ver(){	
	//下拉列表
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

