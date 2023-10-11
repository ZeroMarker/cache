/*
 * FileName:	operlist.js
 * User:		Hanzh 
 * Date:		2021-12-03	
 * Description: 医保手术维护
 */
 
var GUser=session['LOGON.USERID'];
var HospDr=session['LOGON.HOSPID'];
var PUBLIC_CONSTANT = {
	SESSION: {
		HOSPID: session['LOGON.HOSPID'],
	}
}

$(function(){
	initKeyTypes();
	InitInOperListDg();
	//关键字回车事件
	$("#OprnOprtCode").keydown(function(e) { 
	  if (e.keyCode==13)
	  {
		QryInOperList();
	  }
	});  
	//关键字回车事件
	$("#OprnOprtName").keydown(function(e) { 
	  if (e.keyCode==13)
	  {
		QryInOperList();
	  }
	});
	//关键字回车事件  WangXQ 20221102
	$("#Pinyin").keydown(function(e) { 
	  if (e.keyCode==13)
	  {
		QryInOperList();
	  }
	});
	//日期初始化
	init_Date();
	//院内版本号初始化 20230115
	init_HisVer()
});
function init_Date(){
	//InsuDateDefault('StartDate',"");
	//InsuDateDefault('EndDate',"");
	}
//加载查询条件
function initKeyTypes() {
	/*$('#QryType').combobox({  
		width: 120, 
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '0',
			Desc: '全部',
			selected: true
		},{
			Code: '1',
			Desc: '按条件查找'
		}]

	});*/
	//医保类型
//	var diccombox = $('#tInsuType').combobox({
//		valueField: 'cCode',
//		textField: 'cDesc',
//		url: $URL,
//		onBeforeLoad: function (param) {
//			param.ClassName = 'web.INSUDicDataCom';
//			param.QueryName = 'QueryDic';
//			param.ResultSetType = 'array';
//			param.Type = 'TariType';
//			param.Code = '';
//			param.Hospital = PUBLIC_CONSTANT.SESSION.HOSPID;
//		},
//		loadFilter: function (data) {
//			for (var i in data) {
//				if (data[i].cDesc == '全部') {
//					data.splice(i, 1);
//				}
//			}
//			return data;
//		},
//		onSelect: function (rec) {
//			if(getValueById('tKeyWords')!=""){
//			  QryInOperList();
//			}
//		},
//		onChange: function (newValue, oldValue) {
//			if ((newValue != '') &&(getValueById('tKeyWords')!="")){
//				QryInOperList();
//			}
//		}
//	});
	var tinsutypecombox=$('#tInsuType').combogrid({  
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
		    tinsutypecombox.combogrid('setValue',data.rows[0].cCode);
		},
		onSelect:function(index,data){
		}
		
	}); 
}

//查询医保手术
function QryInOperList()
{
   var InRowid=""
   //var QryType=$('#QryType').datebox('getValue');
   var stdate=getValueById('StartDate');
   var endate=getValueById('EndDate');
   var key=getValueById('Pinyin'); //WangXQ 20221102
   var InsuType=$('#tInsuType').combobox("getValue");
   if(InsuType==""){
		$.messager.alert('提示','医保类型不能为空','info');
		return;	
	}
   var OprnOprtCode=getValueById('OprnOprtCode');
   var OprnOprtName=getValueById('OprnOprtName');
   var HisVer=getValueById('HisVer');
   /*$('#tInOperList').datagrid('options').url=$URL;
   $('#tInOperList').datagrid('reload',{
	   ClassName:'INSU.MI.DTO.OPRNOPRTLIST',
	   QueryName:'QueryOPRNOPRTLISTNEW',
	   QryType:"",
	   StDate:stdate,
	   EndDate:endate,
	   HospId:PUBLIC_CONSTANT.SESSION.HOSPID,
	   HiType:InsuType,
	   Code:OprnOprtCode,
	   Desc:OprnOprtName,
	   HisBatch:"",
	   Ver:""
	   });*/
	  var queryParams = {
	   ClassName:'INSU.MI.DTO.OPRNOPRTLIST',
	   QueryName:'QueryOPRNOPRTLISTNEW',
	   QryType:"",
	   StDate:stdate,
	   EndDate:endate,
	   HospId:PUBLIC_CONSTANT.SESSION.HOSPID,
	   HiType:InsuType,
	   Code:OprnOprtCode,
	   Desc:OprnOprtName,
	   HisBatch:"",
	   Ver:"",
	   Key:key,
	   HisVer:HisVer
	}
	
	loadDataGridStore('tInOperList',queryParams);	
	   
	   
}
//初始化医保手术dg
function InitInOperListDg()
{
	//初始化datagrid
   $HUI.datagrid("#tInOperList",{
	   //url:$URL,
	   fit: true,
	   width: '100%',
	   height:800,
	   border:false,
	   singleSelect: true,
	   rownumbers:true,
	   toolbar:'#dgTB',
	   data: [],
//	   frozenColumns:[[
//		 { 
//		   field:'TOpt',
//		   width:40,
//		   title:'操作',
//		   align:'center',
//		   formatter: function (value, row, index) {
//					   
//			        return "<img class='myTooltip' style='width:60' title='修改' onclick=\"InOperListEditClick('" + index+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_pen.png' style='border:0px;cursor:pointer'>";
//					   
//				   }
//		 }
//	   
//	   ]],
	   columns:[[
		   {field:'Rowid',title:'Rowid',width:10,hidden:true},
		   {field:'HiType',title:'医保类型',width:80,hidden:true},
		   {field:'HiTypeDesc',title:'医保类型',width:80},
		   {field:'OprnOprtCode',title:'手术操作代码',width:120},
		   {field:'OprnOprtName',title:'手术操作名称',width:230},
		   {field:'Rid',title:'数据唯一记录号',width:120,hidden:true},
		   {field:'UsedStd',title:'使用标记',width:80,
			formatter: function(value,row,index){
			   if (value=="1"){
				   return "是";
			   } else {
				   return "否";
			   }}
			   },
		   {field:'ValiFlag',title:'有效标志',width:80,
			formatter: function(value,row,index){
			   if (value=="1"){
				   return "是";
			   } else {
				   return "否";
			   }}
			   },
		   {field:'HisCrterId',title:'创建人',width:80,hidden:true},
		   {field:'HisCrterName',title:'创建人',width:80},
		   {field:'HisCrteDate',title:'创建日期',width:100},
		   {field:'HisCrteTIme',title:'创建时间',width:50,hidden:true},
		   {field:'HisVer',title:'版本',width:180},
		   {field:'HisBatch',title:'下载批次',width:180},
		   {field:'HisUpdtId',title:'更新人',width:100,hidden:true},
		   {field:'HisUpdtName',title:'更新人',width:100},
		   {field:'HisUpdtDate',title:'更新日期',width:100},
		   {field:'HisupdtTime',title:'更新时间',width:100},
		   {field:'OprnStdListId',title:'手术标准目录ID',width:290,hidden:true},
		   {field:'Cpr',title:'章',width:30},
		   {field:'CprCodeScp',title:'章代码范围',width:80},
		   {field:'Cprname',title:'章名称',width:190},
		   {field:'CGyCode',title:'类目代码 ',width:80},
		   {field:'CgyName',title:'类目名称',width:130},
		   {field:'SorCode',title:'亚目代码',width:80},
		   {field:'SorName',title:'亚目名称',width:120},
		   {field:'DtlsCode',title:'细目代码',width:80},
		   {field:'DtlsName',title:'细目名称',width:210},
		   {field:'RtlOprnOprtCode',title:'团标版手术操作代码',width:150},
		   {field:'RtlOprnOprtName',title:'团标版手术操作名称',width:150},
		   {field:'ClncOprnOprtCode',title:'临床版手术操作代码',width:150},
		   {field:'ClncOprnName',title:'临床版手术操作名称',width:150},
		   {field:'Memo',title:'备注',width:120},
		   {field:'CrteTime',title:'数据创建时间',width:200},
		   {field:'UpdtTime',title:'数据更新时间',width:200},
		   {field:'Ver',title:'医保版本号',width:80},
		   {field:'VerName',title:'医保版本名称',width:200}

	   ]],
	   pageSize: 20,
	   pagination:true,
	   onClickRow : function(rowIndex, rowData) {
		   
		   //alert("rowData="+rowData.TRowid)   
		   //InLocRowid=rowData.TRowid;
		   //QryInLocRec();
		   
	   },
	   onDblClickRow:function(rowIndex, rowData){
		   InOperListEditClick(rowIndex);
		   },
	   onUnselect: function(rowIndex, rowData) {
		   //alert(rowIndex+"-"+rowData.itemid)
	   },
	   onLoadSuccess:function(data)
	   {
		   var index=0;
	   }
   }); 
}
					
function  InOperListEditClick(rowIndex){
	//LocRowIndex=rowIndex;
   	var selected = $('#tInOperList').datagrid('getSelected');
	var rowData = $('#tInOperList').datagrid("getRows")[rowIndex]; //$('#dg').datagrid('fixColumnSize');  
	if (!selected&&!rowData) {
	   $.messager.alert("温馨提示","请选择一条医保手术!", 'info');
	}
   	//initInItmFrm(rowIndex,rowData)
	var url = "dhcinsu.opereditcom.csp?&Rowid=" + rowData.Rowid+"&HiType="+rowData.HiType+"&HospId="+rowData.HospId; 
	websys_showModal({
		url: url,
		title: "修改-医保手术维护",
		iconCls: "icon-w-edit",
		width: "855",
		height: "530",
		onClose: function()
		{
		QryInOperList();
		}
	});
   
}
function  InOperListEditClick(){
	var selected = $('#tInOperList').datagrid('getSelected');
	if (!selected) {
		$.messager.alert("温馨提示","请选择一条医保手术!", 'info');
	 }
	var url = "dhcinsu.opereditcom.csp?&Rowid=" + selected.Rowid+"&HiType="+selected.HiType+"&HospId="+selected.HospId; 
	websys_showModal({
		url: url,
		title: "修改-医保手术维护",
		iconCls: "icon-w-edit",
		width: "855",
		height: "530",
		onClose: function()
		{
			QryInOperList();
		}
	});
}

//医保手术导出
function InItmEpot()
{
   try
   {
		var QryType="";
		var stdate=getValueById('StartDate');
		var endate=getValueById('EndDate');
		var InsuType=$('#tInsuType').combobox("getValue");
		if(InsuType==""){
			$.messager.alert('提示','医保类型不能为空','info');
			return;	
		}
		var OprnOprtCode=getValueById('OprnOprtCode');
		var OprnOprtName=getValueById('OprnOprtName');
		var HisBatch="";
		var Ver="";
		window.open("websys.query.customisecolumn.csp?CONTEXT=KINSU.MI.DTO.OPRNOPRTLIST:QueryOPRNOPRTLISTNEW&PAGENAME=QueryOPRNOPRTLISTNEW"+"&QryType="+QryType+"&StDate="+stdate+"&EndDate="+stdate+"&HospId="+PUBLIC_CONSTANT.SESSION.HOSPID+"&HiType="+InsuType+"&Code="+OprnOprtCode+"&Desc="+OprnOprtName+"&HisBatch="+HisBatch+"&Ver="+Ver);
		$.messager.progress({
	         title: "提示",
			 msg: '正在导出医保手术数据',
			 text: '导出中....'
			   });
		$cm({
			ResultSetType:"ExcelPlugin",  
			ExcelName:"医保手术",		  
			PageName:"QueryOPRNOPRTLISTNEW",      
			ClassName:"INSU.MI.DTO.OPRNOPRTLIST",
			QueryName:"QueryOPRNOPRTLISTNEW",
			QryType:QryType,
			StDate:stdate,
			EndDate:endate,
			HospId:PUBLIC_CONSTANT.SESSION.HOSPID,
			HiType:InsuType,
			Code:OprnOprtCode,
			Desc:OprnOprtName,
			HisBatch:HisBatch,
			Ver:Ver
		},function(){
			  setTimeout('$.messager.progress("close");', 3 * 1000);	
		});
	   
	   /*var InRowid=""
	   var KeyWords=$('#tKeyWords').val();
	   var KeyType=$('#tKeyType').combobox("getValue");
	   var InsuType=$('#tInsuType').combobox("getValue");	
	   var rtn = $cm({
	   dataType:'text',
	   ResultSetType:"Excel",
	   ExcelName:"医保手术导出", //默认DHCCExcel
	   ClassName:"web.INSUTarItemsCom",
	   QueryName:"QueryAll",
	   txt:KeyWords,
	   Class:KeyType,
	   Type:InsuType,
	   zfblTmp:""
		},false);
		location.href = rtn;
	   $.messager.progress({
				   title: "提示",
				   msg: '正在导出医保手术数据',
				   text: '导出中....'
			   });
	   setTimeout('$.messager.progress("close");', 3 * 1000);	
		   
		   return;*/
   } catch(e) {
	   $.messager.alert("警告",e.message);
	   $.messager.progress('close');
   }; 
}

//医保手术导入
function InItmImpt()
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
         msg: '医保手术导入中',
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
            msg: '医保手术导入',
            text: '导入中，共：'+(rowCnt-1)+'条'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
       ItmArrSave(arr);
	}
	});
}
//医保手术数据保存
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
			 var savecode = tkMakeServerCall("INSU.MI.DTO.OPRNOPRTLIST", "SaveInsuOper",   UpdateStr)
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
                    $.messager.alert('提示', '导入完成,共：'+(rowCnt-1-errRowNums)+"条");
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
			  $.messager.alert('提示', '保存医保手术数据异常：'+ex.message,'error')
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
 * 加载医院院区combogrid
 * tangzf 2019-7-18
 */
function selectHospCombHandle(){
	//$('#tInsuType').combobox('clear');
	$('#tInsuType').combobox('reload');
	//QryInOperList();	
}
/*
 * 单条增加医保手术
 * tangzf 2019-7-18
 */
function addINSUTarItems() {
	//var InsuType = getValueById('tInsuType');
	var InsuType = $('#tInsuType').combogrid("getValue");	//WangXQ 20221102
	if(InsuType==""){
		$.messager.alert('提示','医保类型不能为空','info');
		return;	
	}
	var url = "dhcinsu.opereditcom.csp?&Rowid="+"&HiType="+InsuType+"&HospId="+PUBLIC_CONSTANT.SESSION.HOSPID; 
	websys_showModal({
		url: url,
		title: "新增-医保手术维护",
		iconCls: "icon-w-edit",
		width: "855",
		height: "530",
		onClose: function () {
			QryInOperList();
		}   
	})
}

/*
 *版本
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
	      	param.IsInsuFlag='Y';
	      	param.ResultSetType = 'array';
	      	return true;

		},
		onSelect: function (data) {
		}
	});	
}


