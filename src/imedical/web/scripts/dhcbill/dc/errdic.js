/**
 * 数据核查错误代码维护
 * FileName: dhcbill\dc\errdic.js
 * tangzf 2022-05-11
 */
 var GV = {
	CLASSNAME:"BILL.COM.BL.ErrDicCtl"	 
}
//全局变量
var selRowid="";
var seldictype = ""; 
var tmpselRow = -1;
$(function(){
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
			Querydic();
		}
	});
	//初始化datagrid
	$HUI.datagrid("#dg",{
		data:[],
		fit: true,
		//idField:'dgid',
		rownumbers:true,
		width: '100%',
		striped:true,
		fitColumns:false,
		singleSelect: true,
		autoRowHeight:false,
		toolbar:'#toolbar',
		columns:[[
		// ErrCode,ErrDefaultDesc,ErrConfig,Demo,RuleInfo,ActiveFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid
			{field:'ErrCode',title:'提示代码',width:120},
			{field:'ErrDefaultDesc',title:'默认提示描述',width:300},
			{field:'ProductLine',title:'产品线',width:120,
			formatter: function (value, row, index) {
				var rtn = tkMakeServerCall("BILL.CFG.COM.DictionaryCtl","GetDicInfoByTypeCode","ProductLine", value, getValueById('hospital'),"4");
				return rtn;
			}},
			{field:'ProductModule',title:'产品模块',width:120,
			formatter: function (value, row, index) {
				var rtn = tkMakeServerCall("BILL.CFG.COM.DictionaryCtl","GetDicInfoByTypeCode","ProductModule", value, getValueById('hospital'),"4");
				return rtn;
			}},
			{field:'ErrConfig',title:'提示公式',width:200},
			{field:'ErrType',title:'提示类型',width:200,
			formatter: function (value, row, index) {
				return (value == "SYS") ? "<font color='#21ba45'>系统</font>" : "<font color='#f16e57'>自定义</font>";;
			}},
			{field:'Demo',title:'备注',width:180},
			{field:'RuleInfo',title:'详细描述',width:120},
			{field:'ActiveFlag',title:'是否启用',width:90,
			formatter: function (value, row, index) {
				return (value == "Y") ? "<font color='#21ba45'>是</font>" : "<font color='#f16e57'>否</font>";
			}},
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
			    fillform(rowIndex,rowData)
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
	//Querydic();
	
	init_ActiveFlagCB();
	init_TableNameCB();
	init_PropertyCB();
	init_ProductLine();
	init_BusinessType();
	init_ErrType();

});
function init_ErrType(){
	$HUI.combobox("#ErrType", {
		panelHeight: 150,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		data:[{DicCode:"SYS",DicDesc:"系统"},{DicCode:"User",DicDesc:"自定义"}],
		onSelect: function (data) {
		}
	});
}
function init_ProductLine(){
	$HUI.combobox("#ProductLine", {
		panelHeight: 150,
		url: $URL,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.CFG.COM.DictionaryCtl";
			param.QueryName = "QueryDicDataInfo";
			param.Type="ProductLine";
			param.ResultSetType = 'array';
			return true;
		},
		onSelect: function (data) {
		}
	});
	$HUI.combobox("#QProductLine", {
		panelHeight: 150,
		url: $URL,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.CFG.COM.DictionaryCtl";
			param.QueryName = "QueryDicDataInfo";
			param.Type="ProductLine";
			param.ResultSetType = 'array';
			return true;
		},
		onSelect: function (data) {
		},
		onChange:function(newValue, oldValue){
			Querydic();	
		}
	});		
}
function init_BusinessType(){
	$HUI.combobox("#ProductModule", {
		panelHeight: 150,
		url: $URL,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.CFG.COM.DictionaryCtl";
			param.QueryName = "QueryDicDataInfo";
			param.Type="ProductModule";
			param.ResultSetType = 'array';
			return true;
		},
		onSelect: function (data) {
			var rtn = getValueById('ProductLine') + data.DicCode;
			setValueById('ErrCode',rtn);
		}
	});
	$HUI.combobox("#QModule", {
		panelHeight: 150,
		url: $URL,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.CFG.COM.DictionaryCtl";
			param.QueryName = "QueryDicDataInfo";
			param.Type="ProductModule";
			param.ResultSetType = 'array';
			return true;
		},
		onSelect: function (data) {
		},
		onChange:function(newValue, oldValue){
			Querydic();	
		}
	});	
}
//类名
function init_TableNameCB(){
	$HUI.combobox("#TableName", {
		panelHeight: 150,
		url: $URL,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.Common";
			param.QueryName = "QueryClass";
			param.KeyCode="";
			param.ResultSetType = 'array';
			return true;
		},
		onSelect: function (data) {
			$('#Property').combobox('reload');
		}
	});
}
//字段
function init_PropertyCB(){
	$HUI.combobox("#Property", {
		panelHeight: 150,
		url: $URL,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.Common";
			param.QueryName = "QueryProperty";
			param.ClsInfo = getValueById('TableName');
			param.keyCode="";
			param.ResultSetType = 'array';
			return true;
		},
		onSelect: function (data) {
			var tmpStr= "{" + getValueById('TableName') + "||" + data.DicCode + "}";
			setValueById('ClassProperty',tmpStr)
		}
	});
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
//查询字典数据
function Querydic(){
	$("#dg").datagrid('unselectAll')
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	var QueryParam={
		ClassName: GV.CLASSNAME,
		QueryName: 'QueryInfo',
		HospID : getValueById("hospital"),
		KeyCode:getValueById('dicKey'),
		QProductLine:getValueById("QProductLine"),
		QProductModule:getValueById("QModule")
	}
	loadDataGridStore('dg',QueryParam);
	
}
//特殊字符处理
function SplVCFormat(FStr)
{
	return  FStr.replace(/\^/g,"");
}

//更新保存记录
function UpdateDic(){
	var ErrCode = getValueById('ErrCode');
	if(ErrCode==""){
		$.messager.alert('提示','异常代码不能为空','error');
		return;	
	}
	var ErrDefaultDesc = getValueById('ErrDefaultDesc');
	var ErrConfig = getValueById('ErrConfig');
	var Demo = getValueById('Demo');
	var RuleInfo = getValueById('RuleInfo');
	var ActiveFlag = getValueById('ActiveFlag');
	var HospDr =getValueById("hospital");
	var Rowid = getValueById('Rowid');
	var ProductLine = getValueById('ProductLine');
	var ProductModule = getValueById('ProductModule');
	var ErrType = getValueById('ErrType');
	selRowid = selRowid<0?"":selRowid;
	var saveinfo=selRowid+"^"+ErrCode+"^"+ErrDefaultDesc+"^"+ErrConfig+"^"+Demo+"^"+RuleInfo+"^"+ActiveFlag+"^"+HospDr;
	saveinfo = saveinfo + "^^^^^^^" + ProductLine + "^" + ProductModule + "^" + ErrType;
	saveinfo=saveinfo.replace(/请输入信息/g,"")
	///alert(saveinfo)
	var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
	if(savecode.split('^')[0]>0){
		//$.messager.alert('提示','保存成功!');  
		Querydic();
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
	setValueById('ErrCode',rowData.ErrCode);
	setValueById('ErrDefaultDesc',rowData.ErrDefaultDesc);
	setValueById('ErrConfig',rowData.ErrConfig);
	setValueById('Demo',rowData.Demo);
	setValueById('RuleInfo',rowData.RuleInfo);
	setValueById('ActiveFlag',rowData.ActiveFlag);
	setValueById('HospDr',rowData.HospDr);
	setValueById('ProductModule',rowData.ProductModule);
	setValueById('ProductLine',rowData.ProductLine);
	setValueById('ErrType',rowData.ErrType);
	
}
//清除下边的form
function clearform(inArgs){
	$('#ErrCode').attr("disabled",false);
	$('.editinfo input').each(function(){        
		$(this).val(inArgs)
	})
	selRowid="";
}
//清除上面的form
function ClearQ(inArgs){
	setValueById('QProductLine','');
	setValueById('dicKey','');
	setValueById('QModule','');
}
//异常代码字典导出
function Export()
{
   try
   {
	   var KeyCodeValue=getValueById('dicKey')
		//window.open("websys.query.customisecolumn.csp?CONTEXT=KBILL.DC.BL.DicDataCtl:QueryInfo&PAGENAME=QueryInfo&HospID="+PUBLIC_CONSTANT.SESSION.HOSPID+"&KeyCode="+KeyCodeValue+"&PDicType="+$('#diccbx').combobox('getValue')==""?"SYS":$('#diccbx').combobox('getValue'));
		$.messager.progress({
	         title: "提示",
			 msg: '正在导出异常代码字典',
			 text: '导出中....'
			   });
		$cm({
			ResultSetType:"ExcelPlugin",  
			ExcelName:"异常代码字典",		  
			PageName:"QueryInfo",      
			ClassName: GV.CLASSNAME,
			QueryName: 'QueryInfo',
			HospID : getValueById("hospital"),
			KeyCode:KeyCodeValue
		},function(){
			  setTimeout('$.messager.progress("close");', 3 * 1000);	
		});
		
   } catch(e) {
	   $.messager.alert("警告",e.message);
	   $.messager.progress('close');
   }; 
}

//异常代码字典导入
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
         msg: '异常代码字典导入',
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
            msg: '错误代码字典导入',
            text: '导入中，共：'+(rowCnt-1)+'条'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
       ItmArrSave(arr);
	}
	});
}

//异常代码字典数据保存
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
			 var ErrCode=rowArr[0]
			 if(ErrCode==""){
				$.messager.alert('提示','异常代码不能为空','error');
				return;	
			}
			var ErrDefaultDesc = rowArr[1];
			var ErrConfig = rowArr[2];
			var Demo = rowArr[3];
			var RuleInfo = rowArr[4];
			var ActiveFlag = rowArr[5];
			var HospDr =rowArr[6];
			var Rowid = rowArr[13];
			var ProductLine = rowArr[14];
			var ProductModule = rowArr[15];
			var ErrType = rowArr[16];
			var saveinfo=Rowid+"^"+ErrCode+"^"+ErrDefaultDesc+"^"+ErrConfig+"^"+Demo+"^"+RuleInfo+"^"+ActiveFlag+"^"+HospDr;
            saveinfo = saveinfo + "^^^^^^^" + ProductLine + "^" + ProductModule + "^" + ErrType;
			saveinfo=saveinfo.replace(/请输入信息/g,"")
			///alert(saveinfo)
			var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
             if (savecode == null || savecode == undefined) savecode = -1
             if (savecode >= 0) {
	             sucRowNums = sucRowNums + 1;
	             } 
	        else {
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
			  $.messager.alert('提示', '保存数据异常代码数据异常：'+ex.message,'error')
	          return ;
	      }
  return ;
	
}

function selectHospCombHandle(){

	setValueById('diccbx','');
	seldictype='';
	selRowid = -1;
	
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
	    case "btnSeach" : //查询
	    	Querydic();
	    	break;
	   	case "btnClearQ" : //清除上面搜索栏
	    	ClearQ();
	    	break;
	    default :
	    	break;
	    }
		
}) 
