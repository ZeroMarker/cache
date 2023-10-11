	/**
 * 数据核查错误代码维护
 * FileName: dhcbill\dc\dicdata.js
 * tangzf 2022-05-11
 */
 var GV = {
	CLASSNAME:"BILL.DC.BL.DicDataCtl"	 
}
//全局变量
var selRowid="";
var seldictype = ""; 
var tmpselRow = -1;
$(function(){
	initGY();
	var tableName = "User.INSUTarContrast";
	var defHospId = session['LOGON.HOSPID'];//2;//
	$("#hospital").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			Querydiccbx();
			Querydic();
		}
	});
	init_combogrid();
	init_ActiveFlagCB();
	//初始化datagrid
	$HUI.datagrid("#dg",{
		data:[],
		fit: true,
		border:false,
		//idField:'dgid',
		rownumbers:true,
		width: '100%',
		striped:true,
		toolbar: '#toolbar',
		fitColumns:true,
		singleSelect: true,
		autoRowHeight:false,
		columns:[[
			{field:'DicType',title:'字典类型',width:80},
			{field:'DicCode',title:'代码',width:80},
			{field:'DicDesc',title:'描述'},
			{field:'DicDemo',title:'备注',width:200,showTip: true },
			{field:'ConCode',title:'对照代码',width:50},
			{field:'ConDesc',title:'对照描述',width:80},
			{field:'ConDemo',title:'对照备注',width:150},
			{field:'ActiveFlag',title:'是否启用',width:50,
			formatter: function (value, row, index) {
				return (value == "Y") ? "<font color='#21ba45'>是</font>" : "<font color='#f16e57'>否</font>";}},
			{field:'HospDr',title:'院区',width:50,hidden:true},
			{field:'CRTER',title:'创建人',width:50,hidden:true},
			{field:'CRTEDATE',title:'创建日期',width:50,hidden:true},
			{field:'CRTETIME',title:'创建时间',width:50,hidden:true},
			{field:'UPDTID',title:'更新人',width:50,hidden:true},
			{field:'UPDTDATE',title:'更新日期',width:50,hidden:true},
			{field:'UPDTTIME',title:'更新时间',width:50,hidden:true},
			{field:'Rowid',title:'Rowid',width:10,hidden:true}
		]],
		pageSize: 30,
		pagination:true,
        onClickRow : function(rowIndex, rowData) {
	        if(tmpselRow==rowIndex){
		        clearform("")
		        tmpselRow=-1
		        $(this).datagrid('unselectRow',rowIndex)
		    }else{
			    $('#ErrCode').attr("disabled",true);
			    fillform(rowIndex,rowData);
			    tmpselRow=rowIndex
			}
            
        },
        onUnselect: function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        }
	});
	
	//登记号回车查询事件
	$("#dicKey").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			Querydic();
		}
	});
	
	Querydic();
});
function initGY(){
	$('#GYFlag').combobox({
		valueField: 'id',
		textField: 'desc',
		editable:false,
		data:[
			{
				"id":"G",
				"desc":"公有",
				selected:true	
			},
			{
				"id":"S",
				"desc":"非公有"
			}	
		],
		onSelect:function(){
			Querydiccbx();
			Querydic();
		}
	})
}
function init_combogrid(){
	var DicDesc="系统";
	//初始化combogrid
	$HUI.combogrid("#diccbx",{  
		
		//idField: 'diccbxid', 
	    panelWidth:520,   
	    panelHeight:300,  
	    idField:'DicCode',  
	    valueField: 'DicCode',  
	    textField:'DicDesc', 
        //rownumbers:true,
        pagination: false,
        delay:800,
	    columns:[[   
	        {field:'DicCode',title:'代码',width:160},  
	        {field:'DicDesc',title:'名称',width:210},
	        {field:'DicDemo',title:'备注',width:110}    
	    ]],
	    //fitColumns: true,
        keyHandler:{  
			up: function(){},  
			down: function(){},  
			enter: function(){},  
			query:function(q){ 
				//$(this).combogrid('grid').datagrid('unselectAll');
				//异步加载
				$.cm({
					
					ClassName:GV.CLASSNAME,
					QueryName:"QueryInfo",
					KeyCode:q,
					PDicType:"SYS",
					ExpStr:"|" + getValueById('GYFlag'),
					HospID:getValueById("GYFlag")=="G"?getValueById("GYFlag"):getValueById("hospital"),
					rows:1000
				},function(jsonData){	
					$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
					$('#diccbx').combogrid('setText',q);
					
				}); 
			}  
		},
		
		onSelect: function (record,selobj) {              //选中处理
			dicSelid=record
			clearform();
			//Querydic();
		},
		onLoadSuccess: function (data) {
			for(var i=0; i<data.rows.length;i++)
			{
				if(data.rows[i].DicCode=='SYS')
				{
					$(this).combogrid('grid').datagrid("selectRow", i);
				}
			}
		}
	}); 	
}
//查询字典数据
function Querydic(){
	//$("#dg").datagrid('unselectAll')
	//$('#dg').datagrid('loadData',{total:0,rows:[]});
	clearform();
	//zjb add 2022/08/10 如果是核查明细界面列控制，则数据按代码列排序
	if ($('#diccbx').combobox('getValue')=="CKDETCol") 
	{
		setValueById('ConDemo','USER'); //默认成USER
		setValueById('ConDescStr','列排序');
		var DGOptions=$('#dg').datagrid('options');
		DGOptions.sortName='ConDesc';
		DGOptions.remoteSort=false;
		$.each(DGOptions.columns[0],function(index,val){
		if (val.field=='ConDesc')
		{
			val.title="列排序";
			val.sortable=true;
			val.sortOrder='asc'
			val.sorter=function(a,b){
				var num1=parseFloat(a);
				var num2=parseFloat(b);
				return (num1>num2?1:-1);
			}
		}
		});
		$('#dg').datagrid(DGOptions);
	}
	else
	{
		if(getValueById('ConDescStr')=='列排序')
		{
			setValueById('ConDemo','');
			setValueById('ConDescStr','对照描述');
			 var DGOptions=$('#dg').datagrid('options');
			 DGOptions.sortName='';
			 DGOptions.remoteSort=false;
			 $.each(DGOptions.columns[0],function(index,val){
				 if (val.field=='ConDesc')
				 {
					 //val.width=90;
					 val.title="对照描述";
					 val.sortable=false;
					 val.sortOrder='';
					 val.sorter="";
				 }
			 });
			 $('#dg').datagrid(DGOptions);
		}
	}
	
	var QueryParam={
		ClassName: GV.CLASSNAME,
		QueryName: 'QueryInfo',
		ExpStr:"|" + getValueById('GYFlag'),
		HospID : getValueById("hospital"),
		KeyCode:getValueById('dicKey'),
		PDicType:$('#diccbx').combobox('getValue')==""?"SYS":$('#diccbx').combobox('getValue')
	}
	loadDataGridStore('dg',QueryParam);
	
}
//特殊字符处理
function SplVCFormat(FStr)
{
	return  FStr.replace(/\^/g,"");
}

//停用保存记录
function StopDic(){
	if(selRowid=="" || selRowid<0 || !selRowid){
		$.messager.alert('提示','请选择要停用的指标!','info'); 
		return;  
	}
	if(getValueById('ActiveFlag')=="N")
	{
		$.messager.alert('提示','指标已停用!','info'); 
		return;
	}
	$.messager.confirm("提示", "是否停用？", function (r) { // prompt 此处需要考虑为非阻塞的
	if (r) {
		var DicType = $('#diccbx').combobox('getValue');
		var DicCode = getValueById('DicCode');
		var DicDesc = getValueById('DicDesc');
		var DicDemo = getValueById('DicDemo');
		var ConDesc = getValueById('ConDesc');
		var ConDemo = getValueById('ConDemo');
		var ActiveFlag = "N";
		var Rowid = getValueById('Rowid');
		var ConCode = getValueById('ConCode');
		selRowid = selRowid<=0?"":selRowid;
		var HospDr = selRowid==""?getValueById('hospital'):$('#dg').datagrid('getSelected').HospDr;
		var GYFlag=getValueById('GYFlag');
		HospDr = (GYFlag=="G")||(HospDr=="G")?"G":HospDr;
		var saveinfo=selRowid+"^"+DicCode+"^"+DicDesc+"^"+DicDemo+"^"+ConDesc+"^"+ConDemo+"^"+ActiveFlag+"^"+HospDr;
		saveinfo = saveinfo + "^^^^^^^" + ConCode + "^" + DicType;
		saveinfo=saveinfo.replace(/请输入信息/g,"")
		///alert(saveinfo)
		var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
		if(savecode.split('^')[0]>0){
			if(DicType=="SYS"){
				$.cm({
					ClassName:GV.CLASSNAME,
					QueryName:"QueryInfo",
					KeyCode:'',
					PDicType:"SYS",
					HospID:getValueById("hospital"),
					rows:1000
				},function(jsonData){		
					$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
				});	
			}
			//$.messager.alert('提示','保存成功!');  
			Querydic();
			clearform("")
			$.messager.alert('提示','停用成功!','info');   
		}else{
			$.messager.alert('提示','停用失败!rtn=' + savecode,'info');   
		}
	} else {
		return false;
	}
	})

}
//更新保存记录
function UpdateDic(){
	var DicType = $('#diccbx').combobox('getValue');
	if(DicType==""){
		$.messager.alert('提示','字典类型不能为空','error');
		return;	
	}
	var DicCode = getValueById('DicCode');
	if(DicCode==""){
		$.messager.alert('提示','字典代码不能为空','error');
		return;	
	}
	var DicDesc = getValueById('DicDesc');
	var DicDemo = getValueById('DicDemo');
	var ConDesc = getValueById('ConDesc');
	var ConDemo = getValueById('ConDemo');
	var ActiveFlag = getValueById('ActiveFlag');
	
	var Rowid = getValueById('Rowid');
	var ConCode = getValueById('ConCode');
	selRowid = selRowid<=0?"":selRowid;
	var HospDr = selRowid==""?getValueById('hospital'):$('#dg').datagrid('getSelected').HospDr;
	var GYFlag=getValueById('GYFlag');
	HospDr = (GYFlag=="G")||(HospDr=="G")?"G":HospDr;
	var saveinfo=selRowid+"^"+DicCode+"^"+DicDesc+"^"+DicDemo+"^"+ConDesc+"^"+ConDemo+"^"+ActiveFlag+"^"+HospDr;
	saveinfo = saveinfo + "^^^^^^^" + ConCode + "^" + DicType;
	saveinfo=saveinfo.replace(/请输入信息/g,"")
	///alert(saveinfo)
	var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
	if(savecode.split('^')[0]>0){
		if(DicType=="SYS"){
			$.cm({
				ClassName:GV.CLASSNAME,
				QueryName:"QueryInfo",
				KeyCode:'',
				PDicType:"SYS",
				HospID:getValueById("hospital"),
				rows:1000
			},function(jsonData){		
				$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
			});	
		}
		//$.messager.alert('提示','保存成功!');  
		Querydic();
		//Querydiccbx();
		clearform("")
		$.messager.alert('提示','保存成功!','info');   
	}else{
		$.messager.alert('提示','保存失败!rtn=' + savecode,'info');   
	}
}
//删除记录
function DelDic(){
	if(selRowid=="" || selRowid<0 || !selRowid){$.messager.alert('提示','请选择要删除的记录!','info');return;}
	$.messager.confirm('请确认','你确认要删除这条记录吗?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall(GV.CLASSNAME,"Delete",selRowid)
			if(eval(savecode)==0){
				var DicType=$('#diccbx').combobox('getValue');
				if(DicType=="SYS"){
					$.cm({
						ClassName:GV.CLASSNAME,
						QueryName:"QueryInfo",
						KeyCode:'',
						PDicType:"SYS",
						HospID:getValueById("hospital"),
						rows:1000
					},function(jsonData){		
						$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
					});	
				}
				$.messager.alert('提示','删除成功!','info');   
				$("#dg").datagrid('reload')
				selRowid="";
				$("#dg").datagrid("getPager").pagination('refresh');
				$("#dg").datagrid('unselectAll')
			}else{
				$.messager.alert('提示','删除失败!','info');   
			}
		}else{
			return;	
		}
	});
}
//填充下边的form
function fillform(rowIndex,rowData){
	selRowid=rowData.Rowid
	setValueById('DicCode',rowData.DicCode);
	setValueById('DicDesc',rowData.DicDesc);
	setValueById('DicDemo',rowData.DicDemo);
	setValueById('ConDesc',rowData.ConDesc);
	setValueById('ConDemo',rowData.ConDemo);
	setValueById('ActiveFlag',rowData.ActiveFlag);
	setValueById('ConCode',rowData.ConCode);	

}
//清除下边的form
function clearform(inArgs){
	$('#ErrCode').attr("disabled",false);
	$('.editinfo input').each(function(){        
		$(this).val(inArgs)
	})
	if ($('#diccbx').combobox('getValue')=="CKDETCol") 
	{
		setValueById('ConDemo','USER'); //默认成USER
	}
	else
	{
		setValueById('ConDemo',''); 
	}
	selRowid="";
}
//改变下边显示框的编辑状态
function disinput(tf){
	return;
	$('#code').attr("disabled",tf);


}
//数据核查字典导出
function Export()
{
   try
   {
	   var KeyCodeValue=getValueById('dicKey')
		//window.open("websys.query.customisecolumn.csp?CONTEXT=KBILL.DC.BL.DicDataCtl:QueryInfo&PAGENAME=QueryInfo&HospID="+PUBLIC_CONSTANT.SESSION.HOSPID+"&KeyCode="+KeyCodeValue+"&PDicType="+$('#diccbx').combobox('getValue')==""?"SYS":$('#diccbx').combobox('getValue'));
		$.messager.progress({
	         title: "提示",
			 msg: '正在导出数据核查字典',
			 text: '导出中....'
			   });
		$cm({
			ResultSetType:"ExcelPlugin",  
			ExcelName:"数据核查字典",		  
			PageName:"QueryInfo",      
			ClassName: GV.CLASSNAME,
			QueryName: 'QueryInfo',
			HospID : getValueById("hospital"),
			KeyCode:KeyCodeValue,
			ExpStr:'Y|'
			//PDicType:$('#diccbx').combobox('getValue')==""?"SYS":$('#diccbx').combobox('getValue')
		},function(date){
			  setTimeout('$.messager.progress("close");', 3 * 1000);	
		});
		
   } catch(e) {
	   $.messager.alert("警告",e.message);
	   $.messager.progress('close');
   }; 
}

//zjb 2023/11/11 原来的导入选择文件筐不是置顶状态，新增
function Import()
{
	ImportObj.ImportFile(
		{
			FileSuffixname: /^(.xls)|(.xlsx)$/,///^(.txt)$/,
			harset: 'utf-8'
		}, function(arr){
			SaveArr(arr);
		}
	);
}
//循环调保存方法
function SaveArr(arr)
{
	var ErrMsg = "";     //错误数据
    var errRowNums = 0;  //错误行数
    var sucRowNums = 0;  //导入成功的行数
	var rowCnt=arr.length
	try{
		$.messager.progress({
            title: "提示",
            msg: '免费收费/医嘱项目配置字典导入',
            text: '导入中，共：'+(rowCnt-1)+'条'
        }); 
		for (i = 0; i < rowCnt; i++) 
		{
			var rowArr=arr[i];
			var DicType = rowArr.DicType?rowArr.DicType:"";
			var DicCode = rowArr.DicCode?rowArr.DicCode:"";
			var DicDesc = rowArr.DicDesc?rowArr.DicDesc:"";
			var DicDemo = rowArr.DicDemo?rowArr.DicDemo:"";
			var ConDesc = rowArr.ConDesc?rowArr.ConDesc:"";
			var ConDemo = rowArr.ConDemo?rowArr.ConDemo:"";
			var ActiveFlag = rowArr.ActiveFlag?rowArr.ActiveFlag:"";
			var HospDr = rowArr.HospDr?rowArr.HospDr:""; 
			var CRTER = rowArr.CRTER?rowArr.CRTER:"";
			var CRTEDATE = rowArr.CRTEDATE?rowArr.CRTEDATE:"";
			var CRTETIME = rowArr.CRTETIME?rowArr.CRTETIME:"";
			var UPDTID = rowArr.UPDTID?rowArr.UPDTID:"";
			var UPDTDATE = rowArr.UPDTDATE?rowArr.UPDTDATE:"";
			var UPDTTIME = rowArr.UPDTTIME?rowArr.UPDTTIME:"";
			var Rowid = rowArr.Rowid?rowArr.Rowid:"";
			var ConCode = rowArr.ConCode?rowArr.ConCode:"";
			var DicNum = rowArr.DicNum?rowArr.DicNum:"";
			var saveinfo=Rowid+"^"+DicCode+"^"+DicDesc+"^"+DicDemo+"^"+ConDesc+"^"+ConDemo+"^"+ActiveFlag+"^"+HospDr;
			 saveinfo = saveinfo + "^^^^^^^" + ConCode + "^" + DicType;
			 var savecode =tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
            if (savecode == null || savecode == undefined) savecode = -1;
            if (savecode >= 0) {
	        	sucRowNums = sucRowNums + 1;
	        } 
	        else {
		        errRowNums = errRowNums + 1;
		        if (ErrMsg == "") {
			        ErrMsg = i+":"+savecode;
			    }
			    else {
                    ErrMsg = ErrMsg + "<br>" + i+":"+savecode+"已存在！";
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
	}
	catch(ex)
	{
		$.messager.progress("close");
		$.messager.alert('提示', '保存数据核查字典数据异常：'+ex.message,'error');
	}
}


//数据核查字典导入
function Import2()
{
	/* var grid = $('#dg');  
    grid.datagrid('getPager').data("pagination").options.pageNumber=2;  

	return; */
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
         msg: '数据核查字典导入',
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
            msg: '数据核查字典导入',
            text: '导入中，共：'+(rowCnt-1)+'条'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
       ItmArrSave(arr);
	}
	});
}

//数据核查字典数据保存
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
			 var DicType=rowArr[0]
			 var DicCode=rowArr[1]
			 var DicDesc=rowArr[2]
			 var DicDemo=rowArr[3]
			 var ConDesc=rowArr[4]
			 var ConDemo=rowArr[5]
			 var ActiveFlag=rowArr[6]
			 var HospDr=rowArr[7]
			 var SelectRow=rowArr[14]
			 var ConCode=rowArr[15]
			 var saveinfo=SelectRow+"^"+DicCode+"^"+DicDesc+"^"+DicDemo+"^"+ConDesc+"^"+ConDemo+"^"+ActiveFlag+"^"+HospDr;
			 saveinfo = saveinfo + "^^^^^^^" + ConCode + "^" + DicType;
			 var savecode =tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
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
			  $.messager.alert('提示', '保存数据核查字典数据异常：'+ex.message,'error')
	          return ;
	      }
  return ;
	
}
function addClear4Combogrid(theId,onChangeFun)
{
 var theObj = $(theId);
  
 //根据当前值，确定是否显示清除图标
 var showIcon = function(){  
  var icon = theObj.combogrid('getIcon',0);
  if (theObj.combogrid('getValue')){
   icon.css('visibility','visible');
  } else {
   icon.css('visibility','hidden');
  }
 };
  
 theObj.combogrid({
  //添加清除图标
  icons:[{
   iconCls:'icon-clear',
   handler: function(e){
    theObj.combogrid('clear');
   }
  }],
   
  //值改变时，根据值，确定是否显示清除图标
  onChange:function(){
   if(onChangeFun)
   {
    onChangeFun();
   }
   showIcon();
  }
   
 }); 
  
 //初始化确认图标显示
 showIcon();
}

function onChangeFun(){
	
}
function Querydiccbx(){

	//$('#editinfo').form('clear');
	$('#diccbx').combogrid('grid').datagrid('unselectAll');
	setValueById('diccbx','');
	seldictype='';
	selRowid = -1;
	
	//异步加载

	$.cm({
		ClassName:GV.CLASSNAME,
		QueryName:"QueryInfo",
		KeyCode:"",
		PDicType:"SYS",
		HospID:getValueById("hospital"),
		ExpStr:"|" + getValueById("GYFlag"),
		rows:1000
	},function(jsonData){	
		$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
	}); 
	//加载grid

	//Querydic();
}
$('.hisui-linkbutton').bind('click',function(){
	 switch (this.id){ 
	    case "btnUpdate" : // 保存
	    	$.messager.confirm("提示", "是否继续保存？", function (r) { // prompt 此处需要考虑为非阻塞的
				if (r) {
					UpdateDic();
				} else {
					return false;
				}
			})
	    	break;
	    case "btnDelete" : //删除
				DelDic(); 	
	    	break;
	    case "btnClear" :
	    	clearform();
	    	break;	
	    case "btnStop" : // 停用
	    	StopDic();
	    	break;
	    default :
	    	break;
	    }
		
}) 

//清除上方查询
function ClearQ(){
	setValueById('diccbx','SYS'); 	
	setValueById('dicKey',''); 
	var defHospId = session['LOGON.HOSPID'];
	setValueById('hospital',defHospId);
	setValueById('GYFlag','G');
	Querydic();
}

//有效标志
function init_ActiveFlagCB(){
	$HUI.combobox("#ActiveFlag", {
			panelHeight: 150,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		data:[{DicCode:"Y",DicDesc:"是"},{DicCode:"N",DicDesc:"否"}],
		onSelect: function (data) {
		}
	});
}
