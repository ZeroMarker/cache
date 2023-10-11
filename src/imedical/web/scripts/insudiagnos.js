/**
 * 医保诊断维护JS
 * insudiagnos.js
 * Zhan 201601
 * 版本：V1.0
 * easyui版本:1.3.2
 */
var cmenu;
var grid;
var ConGrid;
var selHisData="";
var selInsuData=""
var IPAddress=""
//var ROOTID='TEST2';	//测试用
var searchParam = {}; 
var seldictype=""; 
var QParam="";
var EditIndex=undefined;

var dgselected=-2;
$(function(){
	// 2019-6-5 tangzf 编辑框回车自动保存
	$(document).keydown(function (e) {
		if(e.target.className=='datagrid-editable-input'){
			Enter_KeyDown(e);
		}
		
	});
	// 2019-6-5 tangzf 
	IPAddress=GetLocalIPAddress() 
	
	GetjsonQueryUrl();
	//下拉列表
	// var dicurl=jsonQueryUrl+'web.INSUDicDataCom'+SplCode+"GetDicJSONInfo"+SplCode+"TariType^^"	//ArgSpl
	// var diccombox=$('#insuType').combogrid({  
	//     panelWidth:350,   
	//     panelHeight:238,  
	//     idField:'INDIDDicCode',   
	//     textField:'INDIDDicDesc', 
    //     rownumbers:true,
    //     fit: true,
    //     pagination: false,
    //     url:dicurl,
	//     columns:[[   
	//         {field:'INDIDDicCode',title:'代码',width:60},  
	//         {field:'INDIDDicDesc',title:'描述',width:100}
	        
	//     ]],
	//     fitColumns: true,
	//     onLoadSuccess:function(data){
	// 		diccombox.combogrid('setValue',data.rows[2].INDIDDicCode)
	// 	}
	// }); 
	var diccombox=$('#insuType').combogrid({  
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
		    diccombox.combogrid('setValue',data.rows[0].cCode);
		},
		onSelect:function(index,data){
		}
		
	}); 
	$('#QClase').combobox({   
	 	panelHeight:80, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '1',
			Desc: '按拼音'
		},{
			Code: '2',
			Desc: '诊断代码'
		},{
			Code: '3',
			Desc: '诊断名称'
		}]

	}); 

	//版本
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
	      	param.IsInsuFlag='Y';
	      	param.ResultSetType = 'array';
	      	return true;

		},
		onSelect: function (data) {
			Query();
		}
	});	

	//初始化对照的grid
	grid=$('#dg').datagrid({
		idField:'dgid',
		iconCls: 'icon-save',
		toolbar:'#tToolBar',
		fit: true,
		rownumbers: true,
		border: false,
		//width: 1000,
		//height: 580,
		//fit:true,
		singleSelect: true,
		fitColumns: false,
		pagination: true,
		autoRowHeight: false,
		pageSize: 20,
		striped: true,
		// frozenColumns: [[
		// 	{
		// 		field: 'TOpt',
		// 		width: 40,
		// 		title: '操作',
		// 		align: 'center',
		// 		formatter: function (value, row, index) {
		// 			return "<img class='myTooltip' style='width:60' title='修改' onclick=\"Edit('" + index + "')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_pen.png' style='border:0px;cursor:pointer'>";
		// 		}
		// 	}
		// ]],
		columns:[[
			{field:'INDISRowid',title:'Rowid',width:60,hidden:true},
			{field:'bztype',title:'医保类型',width:80},
			{field:'bzbm',title:'诊断代码',width:100},
			{field:'bzmc',title:'诊断名称',width:260},
			{field:'srrj',title:'检索码',width:120},
			{field:'ActiveDate',title:'生效日期',width:100,editor:{type:'datebox',options:{minDate:'1971-01-01',maxDate:'9999-01-01'}}},
			{field:'HisVer',title:'版本',width:100,hidden:true},
			{field:'HisVerDesc',title:'版本',width:140},
			{field:'Cate',title:'病种类型',width:80,editor:'text'},
			{field:'SubCate',title:'病种子类型',width:80,editor:'text'},
			{field:'srrjwb',title:'检索码2',width:80,hidden:true},
			{field:'Date',title:'更新日期',width:100},
			{field:'Time',title:'更新时间',width:100},
			{field:'UserDr',title:'操作员',width:80},
			{field:'ADDIP',title:'操作IP',width:150},
			{field:'Unique',title:'中心唯一码',width:90,editor:'text'},
			{field:'jcbzbz',title:'治疗方式',width:80,editor:'text'},
			{field:'XString01',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString02',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString03',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString04',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString05',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString06',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString07',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString08',title:'扩展字段',width:60,hidden:true,editor:'text'},
			//{field:'XString10',title:'扩展字段',width:60,hidden:true,editor:'text'}
			{field:'ExpiryDate',title:'失效日期',width:100,editor:{type:'datebox',options:{minDate:'1971-01-01',maxDate:'9999-01-01'}}},
			{field:'HospDr',title:'院区',width:60,hidden:true,editor:'text'},
			{field:'HiType',title:'医保类型代码',width:60,hidden:true}
		]],
		
        onSelect : function(rowIndex, rowData) {
	        if(dgselected==rowIndex){return}
	        dgselected=rowIndex;
        },
        onUnselect: function(rowIndex, rowData) {
        }, 
       	onLoadSuccess:function(data){
			$('#dg').datagrid("unselectAll"); //
	   	},
	   	onDblClickRow:function(rowIndex, rowData){
			editINSUDiagnosis(rowIndex);
		},  
	});
	
	$('#KeyWords').keyup(function(){
		if(event.keyCode==13){
			Query();
		}
	});
	if($('#QClase').combobox('getValue')==""){$('#QClase').combobox('select','1')}
	//$('#wind').window('open')
	grid.datagrid({}).datagrid("keyCtr");
	//$('#wdg').datagrid({}).datagrid("keyCtr");
});
function getSearchParam(){  
	return searchParam;  
}

//查询医保诊断数据
function Query(){
	var QueryParam={
		ClassName :'web.INSUDiagnosis' ,
		QueryName : 'QueryDiagnosis',
		QType : $('#insuType').combobox('getValue'), 
		QKWords : getValueById('QClase') + '@' + getValueById('KeyWords'), 
		HospDr : PUBLIC_CONSTANT.SESSION.HOSPID,
		QHisVer:$('#HisVer').combobox('getValue')
	}
	loadDataGridStore('dg',QueryParam);
}

//取当天日期
function GetToday(){
	var myDate=new Date();
	var y = myDate.getFullYear();
	var m = myDate.getMonth()+1;
	var d = myDate.getDate();
	var DateStr=y+"-"+(m<10?('0'+m):m)+"-"+(d<10?('0'+d):d);
	var DateType=tkMakeServerCall("websys.Conversions","DateFormat")
	//alert(DateType)
	if (DateType=="4"){DateStr=(d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y}
	else if (DateType=="1"){DateStr=(m<10?('0'+m):m)+"/"+(d<10?('0'+d):d)+"/"+y}
	return DateStr
}

function GetTimeNow(){
	var myDate = new Date();
	var h=myDate.getHours();       //获取当前小时数(0-23)
	var m=myDate.getMinutes();     //获取当前分钟数(0-59)
	var s=myDate.getSeconds();     //获取当前秒数(0-59)
	return h+":"+(m<10?('0'+m):m)+":"+(s<10?('0'+s):s)
}

function getEditRow(lastIndex,field){  
	var tmptar=ConGrid.datagrid('getEditor', {    
        index : lastIndex,    
        field : field  
	}).target;  
	return tmptar
}  
function getEditRownew(lastIndex){  
	var tmptar=ConGrid.datagrid('getEditors',lastIndex);  
	return tmptar
}  

function isEditing(){
	if (EditIndex == undefined){return true}
	if (grid.datagrid('validateRow', EditIndex)){
		//var ed = grid.datagrid('getEditor', {index:EditIndex,field:'INSUDigCode'});
		//var productname = $(ed.target).combobox('getText');
		//grid.datagrid('getRows')[EditIndex]['INSUDigCode'] = productname;
		grid.datagrid('endEdit', EditIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
// //医保诊断修改
// function Edit(rowIndex){
// 	var selected = $('#dg').datagrid('getSelected');
// 	var rowData = $('#dg').datagrid("getRows")[rowIndex];
// 	if (!selected&&!rowData) {
// 	   $.messager.alert("温馨提示","请选择一条医保诊断!", 'info');
// 	}
// 	else{
// 		if(!selected)
// 		{
// 			INDISRowid=rowData.INDISRowid
// 		}
// 		else{
// 			INDISRowid=selected.INDISRowid
// 		}
// 		//诊断修改弹窗	+20230208 HanZH
// 		var url = "dhcinsu.diageditcom.csp?&INDISRowid="+INDISRowid
// 		websys_showModal({
// 			url: url,
// 			title: "医保诊断维护修改",
// 			iconCls: "icon-w-edit",
// 			width: "780",
// 			height: "415",
// 			onClose: function () {
				
// 			}
// 		});
// 	}

// 	/*
// 	if(rowIndex>=0)
// 	{
// 		if((undefined!=EditIndex)&(rowIndex!=EditIndex)){grid.datagrid('endEdit', EditIndex);}
// 		var editrow=grid.datagrid('getRows')[rowIndex];
// 		if((undefined==editrow["bztype"])||(""==editrow["bztype"])||(undefined==editrow['bzbm'])||(""==editrow['bzbm'])||(""==editrow['bzmc'])||(undefined==editrow['bzmc'])){
// 			$.messager.alert('提示','空数据不能编辑!');
// 			return;
// 		}
// 		grid.datagrid('beginEdit',rowIndex);
// 		EditIndex = rowIndex;
// 		return true
// 	}else{
// 		$.messager.alert('提示','要先选择一行才能编辑!');
// 	}
// }
// function SaveBak(){
// 	var Changes=$('#GrpInfoGV').datagrid("getChanges") ;
// 	if(Changes.length>0){
// 		var ret=SaveFun(Changes[Changes.length-1]);
// 		if(ret){
// 			$('#GrpInfoGV').datagrid("refreshRow",rowIndex)
// 			$('#GrpInfoGV').datagrid("acceptChanges") ;
// 			rowIndex=-1 ;
// 			return true ;
// 		}
// 		else{
// 			$('#GrpInfoGV').datagrid("rejectChanges") ;
// 			$('#GrpInfoGV').datagrid("deleteRow",rowIndex)
// 			rowIndex=-1 ;
// 			return false ;
// 		} 
// 	}
// 	rowIndex=-1 ;
// 	*/
// }

//更新保存记录

///******************************************************************
///功能说明：
///          数据导入
///******************************************************************
function importDiag(){
	//打开文件选择窗	
	var filePath=OpenFileDialog(); //dhcinsu.common.js	
	if (filePath == "") {
		$.messager.alert('提示', '请选择文件！','info')
		return ;
	}
	//取读excel   
	$.messager.progress({
		title: "提示",
		msg: '医保诊断导入',
		text: '数据读取中...'
	}); 
	$.ajax({
	   async : true,
	   complete : function () {
           ReadDiagnosExcel(filePath);
	    }
	});
}

//读取DiagnosExcel数据
function ReadDiagnosExcel(filePath)
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
            msg: '医保诊断导入',
            text: '导入中，请稍后'
        }); 
	$.ajax({
	    async : true,
	    complete : function () {
		    DiagnosArrSave(arr);
	        }
	});
}

//医保诊断数据保存
function DiagnosArrSave(arr)
{
	//读取保存数据
	var ErrMsg = "";     //错误数据
    var errRowNums = 0;  //错误行数
    var sucRowNums = 0;  //导入成功的行数
	var rowCnt=arr.length
	var EmpDataNum = 0; //空数据
	 try{
		 for (i = 1; i < rowCnt; i++) 
		 {
			 var rowArr=arr[i];
			 var UpdateStr="^"+rowArr.join("^");
			 if(UpdateStr.split("^")[2]==""){
				EmpDataNum = EmpDataNum + 1;	 
			}else{
			 	var savecode=tkMakeServerCall("web.INSUDiagnosis","SaveDiag",UpdateStr)
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
		 }
		 
		 if (ErrMsg == "") {
                    $.messager.progress("close");
                    $.messager.alert('提示', '导入完成,共：'+(rowCnt-1-EmpDataNum)+"条");
                } else {
                   $.messager.progress("close");
                     var tmpErrMsg = "导入成功："+sucRowNums-EmpDataNum +"条，失败："+errRowNums-EmpDataNum+"条。";
                     tmpErrMsg = tmpErrMsg + "<br>失败数据行号：<br>"+ ErrMsg;
                    $.messager.alert('提示', tmpErrMsg,'info');
                }
		      return ;
		 }
		 catch(ex)
		 {
			  $.messager.progress("close");
			  $.messager.alert('提示', '导入医保诊断数据异常：'+ex.message,'error')
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

//获取IP地址方法1
//获取所有网卡的IP地址，以;分割。
//最真实的客户端
function GetLocalIPAddress()  
{  
    var obj = null;  
    var rslt = "";  
    try  
    {  
		//-------Zhan 20190521-------->
		if("undefined" != typeof ClientIPAddress){
			rslt=ClientIPAddress		
		}
		if(rslt!=""){return rslt};
		//<---------------------------//
        obj = new ActiveXObject("rcbdyctl.Setting");  
        rslt = obj.GetIPAddress;  
      	rslt=rslt.split(";")[0]
        obj = null;  
    }  
    catch(e)  
    {  
        //alert("异常，rcbdyctl.dll动态库未注册，请先注册!")
        rslt="";
    } 
    return rslt
}
/// 回车
function Enter_KeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		Save();
	}
}
function selectHospCombHandle(){
	//$('#insuType').combobox('clear');
	$('#insuType').combogrid('grid').datagrid('reload');
	//$('#BSYType').combobox('clear');
	//Query();
}

/*
 * 单条增加医保诊断 
 * +20230308 HanZH
 */
function addINSUDiagnosis() {
	//var InsuType = getValueById('tInsuType');
	var InsuType = $('#insuType').combogrid("getValue");	//WangXQ 20221102
	if(InsuType==""){
		$.messager.alert('提示','医保类型不能为空','info');
		return;	
	}
	var url = "dhcinsu.diageditcom.csp?&Rowid="+"&HiType="+InsuType+"&HospId="+PUBLIC_CONSTANT.SESSION.HOSPID; 
	websys_showModal({
		url: url,
		title: "新增-医保诊断维护",
		iconCls: "icon-w-edit",
		width: "740",
		height: "425",
		onClose: function () {
			Query();
		}   
	})
}

/*
 * 修改医保诊断 
 * +20230308 HanZH
 */
function  editINSUDiagnosis(rowIndex){
	//LocRowIndex=rowIndex;
   	var selected = $('#dg').datagrid('getSelected');
	var rowData = $('#dg').datagrid("getRows")[rowIndex]; //$('#dg').datagrid('fixColumnSize');  
	if (!selected&&!rowData) {
	   $.messager.alert("温馨提示","请选择一条医保诊断!", 'info');
	}
   	//initInItmFrm(rowIndex,rowData)
	var url = "dhcinsu.diageditcom.csp?&Rowid=" + rowData.INDISRowid+"&HiType="+rowData.HiType+"&HospId="+rowData.HospDr; 
	websys_showModal({
		url: url,
		title: "修改-医保诊断维护",
		iconCls: "icon-w-edit",
		width: "740",
		height: "425",
		onClose: function()
		{
			Query();
		}
	});
   
}
function  editINSUDiagnosis(){
	var selected = $('#dg').datagrid('getSelected');
	if (!selected) {
		$.messager.alert("温馨提示","请选择一条医保手术!", 'info');
	}
	var url = "dhcinsu.diageditcom.csp?&Rowid=" + selected.INDISRowid+"&HiType="+selected.HiType+"&HospId="+selected.HospDr; 
	websys_showModal({
		url: url,
		title: "修改-医保诊断维护",
		iconCls: "icon-w-edit",
		width: "740",
		height: "425",
		onClose: function()
		{
			Query();
		}
	});
}

