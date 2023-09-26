/**
 * 医保诊断维护JS
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
	var dicurl=jsonQueryUrl+'web.INSUDicDataCom'+SplCode+"GetDicJSONInfo"+SplCode+"TariType^^"	//ArgSpl
	var diccombox=$('#insuType').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'INDIDDicCode',   
	    textField:'INDIDDicDesc', 
        rownumbers:true,
        fit: true,
        pagination: false,
        url:dicurl,
	    columns:[[   
	        {field:'INDIDDicCode',title:'代码',width:60},  
	        {field:'INDIDDicDesc',title:'描述',width:100}
	        
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
			diccombox.combogrid('setValue',data.rows[0].INDIDDicCode)
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
			Desc: '按医院ICD码'
		},{
			Code: '3',
			Desc: '按医院ICD名称'
		}]

	}); 

	//初始化对照的grid
	grid=$('#dg').datagrid({
		idField:'dgid',
		iconCls: 'icon-save',
		rownumbers:true,
		border:false,
		//width: 1000,
		//height: 580,
		fit:true,
		striped:true,
		fitColumns: true,
		singleSelect: true,
		frozenColumns:[[

		]],
		columns:[[
			{field:'INDISRowid',title:'Rowid',width:60,hidden:true},
			{field:'bztype',title:'医保类型',width:60},
			{field:'bzbm',title:'诊断代码',width:80},
			{field:'bzmc',title:'诊断名称',width:260},
			{field:'srrj',title:'检索码',width:70},
			{field:'ActiveDate',title:'生效日期',width:70,editor:'datebox'},
			{field:'Unique',title:'中心唯一码',width:90,editor:'text'},
			{field:'jcbzbz',title:'治疗方式',width:60,editor:'text'},
			{field:'Cate',title:'病种类型',width:60,editor:'text'},
			{field:'SubCate',title:'病种子类型',width:60,editor:'text'},
			{field:'srrjwb',title:'检索码2',width:65,hidden:true},
			{field:'Date',title:'更新日期',width:70},
			{field:'Time',title:'更新时间',width:60},
			{field:'UserDr',title:'操作员',width:65},
			{field:'ADDIP',title:'操作IP',width:80},

			{field:'XString01',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString02',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString03',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString04',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString05',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString06',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString07',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString08',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString09',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString10',title:'扩展字段',width:60,hidden:true,editor:'text'}
		]],
		onClickRow:function(rowIndex, rowData) {
			return;
			//$('#windiv').hide();
			//ConAct("insertRow")
			//QueryINSUTarInfoNew(getEditRow(EditIndex,'INSUDigDesccon'),'INSUDigDesccon','3')
            //bgEditRow(rowIndex,rowData)
        },
		pageSize: 30,
		pagination:true,
        onSelect : function(rowIndex, rowData) {
	        if(dgselected==rowIndex){return}
	        dgselected=rowIndex
            //beginEdit(rowIndex,rowData)
        },
        onUnselect: function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
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
		HospDr : PUBLIC_CONSTANT.SESSION.HOSPID
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
function Edit(){
	rowIndex=dgselected
	if(rowIndex>=0)
	{
		if((undefined!=EditIndex)&(rowIndex!=EditIndex)){grid.datagrid('endEdit', EditIndex);}
		var editrow=grid.datagrid('getRows')[rowIndex];
		if((undefined==editrow["bztype"])||(""==editrow["bztype"])||(undefined==editrow['bzbm'])||(""==editrow['bzbm'])||(""==editrow['bzmc'])||(undefined==editrow['bzmc'])){
			$.messager.alert('提示','空数据不能编辑!');
			return;
		}
		grid.datagrid('beginEdit',rowIndex);
		EditIndex = rowIndex;
		return true
	}else{
		$.messager.alert('提示','要先选择一行才能编辑!');
	}
}
function SaveBak(){
	var Changes=$('#GrpInfoGV').datagrid("getChanges") ;
	if(Changes.length>0){
		var ret=SaveFun(Changes[Changes.length-1]);
		if(ret){
			$('#GrpInfoGV').datagrid("refreshRow",rowIndex)
			$('#GrpInfoGV').datagrid("acceptChanges") ;
			rowIndex=-1 ;
			return true ;
		}
		else{
			$('#GrpInfoGV').datagrid("rejectChanges") ;
			$('#GrpInfoGV').datagrid("deleteRow",rowIndex)
			rowIndex=-1 ;
			return false ;
		} 
	}
	rowIndex=-1 ;
}



//更新保存记录
function Save(){
	//if(BDPAutDisableFlag('btnAdd')!=true){$.messager.alert('提示','您无权限,请联系管理员授权!');return;}
	/*
	if(undefined==selInsuData.INDISRowid){
		$.messager.alert('提示','请选择一条记录才能对照!');
		return;
	}
	
			{field:'INDISRowid',title:'Rowid',width:60,hidden:true},
			{field:'bztype',title:'医保类型',width:60},
			{field:'bzbm',title:'诊断代码',width:80},
			{field:'bzmc',title:'诊断名称',width:200},
			{field:'srrj',title:'检索码',width:650},
			{field:'srrj2',title:'检索码2',width:65,hidden:true},
			{field:'jcbzbz',title:'治疗方式',width:60,editor:'text'},
			{field:'Cate',title:'病种类型',width:60,editor:'text'},
			{field:'SubCate',title:'病种子类型',width:60,editor:'text'},
			{field:'Date',title:'更新日期',width:70},
			{field:'Time',title:'更新时间',width:60},
			{field:'UserDr',title:'操作员',width:140},
			{field:'ADDIP',title:'操作IP',width:140},
			{field:'ActiveDate',title:'生效日期',width:140,editor:'datebox'},
			{field:'Unique',title:'中心唯一码',width:140,editor:'text'},
			{field:'XString01',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString02',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString03',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString04',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString05',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString06',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString07',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString08',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString09',title:'扩展字段',width:60,hidden:true,editor:'text'},
			{field:'XString10',title:'扩展字段',width:60,hidden:true,editor:'text'}
	
	*/
	if((undefined==EditIndex))
	{
		$.messager.alert('提示','未编辑无需保存!');
		return;
	}
	// tangzf 2019-6-2 改为HISUI弹窗
	var  rtn=$.messager.confirm('提示',"你确认要修改吗?",function(r){	
		if(r){
			grid.datagrid('acceptChanges');
			grid.datagrid('endEdit', EditIndex);
			grid.datagrid('updateRow',{index: EditIndex,row: {Date: GetToday(),Time: GetTimeNow(),ADDIP: IPAddress}});
			grid.datagrid('refreshRow',EditIndex)
			var editrow=grid.datagrid('getRows')[EditIndex];
			var userID=session['LOGON.USERID'];
			if((undefined==editrow['bztype'])||(""==editrow['bztype'])||(undefined==editrow['bzbm'])||(""==editrow['bzbm'])||(""==editrow['bzmc'])||(undefined==editrow['bzmc'])){
				$.messager.alert('提示','无效数据不能保存!');
				return;
			}
		
			//特殊字符^的处理
			//editrow['INDISRowid']=editrow['INDISRowid'].replace(/\^/g,"");
			editrow['bztype']=editrow['bztype'].replace(/\^/g,"");
			editrow['bzmc']=editrow['bzmc'].replace(/\^/g,"");
			editrow['bzbm']=editrow['bzbm'].replace(/\^/g,"");
			editrow['srrj']=editrow['srrj'].replace(/\^/g,"");
			editrow['srrjwb']=editrow['srrjwb'].replace(/\^/g,"");
			editrow['jcbzbz']=editrow['jcbzbz'].replace(/\^/g,"");
			editrow['ActiveDate']=editrow['ActiveDate'].replace(/\^/g,"");
			editrow['Unique']=editrow['Unique'].replace(/\^/g,"");
			editrow['Cate']=editrow['Cate'].replace(/\^/g,"");
			editrow['SubCate']=editrow['SubCate'].replace(/\^/g,"");
		
			//如果有乱码就用JS的cspEscape()函数加密
			//var UpdateStr=editrow['INDISRowid']+"^"+editrow['bztype']+"^"+editrow['bzbm']+"^"+editrow['bzmc']+"^"+editrow['srrj']+"^"+editrow['srrjwb']+"^"+editrow['jcbzbz']+"^"+editrow['Cate']+"^"+editrow['SubCate']+"^^^"+userID+"^"+IPAddress+"^"+editrow['ActiveDate']+"^"+editrow['Unique']+"^^^^^^^^^^^";
			var UpdateStr=editrow['INDISRowid']+"^"+$('#insuType').combobox('getValue')+"^"+editrow['bzbm']+"^"+editrow['bzmc']+"^"+editrow['srrj']+"^"+editrow['srrjwb']+"^"+editrow['jcbzbz']+"^"+editrow['Cate']+"^"+editrow['SubCate']+"^^^"+userID+"^"+IPAddress+"^"+editrow['ActiveDate']+"^"+editrow['Unique']+"^^^^^^^^^^^";
			var savecode=tkMakeServerCall("web.INSUDiagnosis","SaveDiag",UpdateStr)
		
			if(savecode==null || savecode==undefined) savecode=-1
			if(eval(savecode)>=0){
				//$.messager.alert('提示','保存成功');  
				//$.messager.alert('提示','保存成功!');
				EditIndex=undefined;
				MSNShow('提示','保存成功！',2000)
			}else{
				EditIndex=-2;
				Edit();
				$.messager.alert('提示','保存失败!');   
			}
		}else{
			grid.datagrid("rejectChanges") ;
		};
	})
}

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
            text: '导入中，共：'+(rowCnt-1)+'条'
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
	 try{
		 for (i = 1; i < rowCnt; i++) 
		 {
			 var rowArr=arr[i]
			 var UpdateStr="^"+rowArr.join("^")
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
		 
		 if (ErrMsg == "") {
                    $.messager.progress("close");
                    $.messager.alert('提示', '导入完成,共：'+(rowCnt-1)+"条");
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