/*
 * FileName:	priceruleconarc.js
 * User:		tanfb
 * Date:		2023-01-05
 * Function:	
 * Description: 规则关联医嘱项目
 */

var GV = {
	SELECTEDINDEX : -1,
	EDITINDEX : -1,
	RuleId : -1,
}

$(function () {
	 
	init_hospital() //初始化医院下拉框 
	init_dg();  //初始化规则表格
	initLoadGrid();  //规则表格加载数据
	init_dg1();  //初始化收费项目表格
	initLoadGrid1(); //收费项目表格加载数据
	setValueById('ActiveEndDate',"9999-12-31");	
});
	
//回车查询事件
$("#search").keydown(function (e) {
	var key = websys_getKey(e);
	if (key == 13) {
		initLoadGrid();
	}
});	

//回车查询事件
$("#searchi").keydown(function (e) {
	var keycode = getValueById('searchi')
	var key = websys_getKey(e);
	if (key == 13) {
		initLoadGrid1(keycode,"");
	}
});	

//初始化规则表格
function init_dg() {
	var dgColumns = [[
	        {field:'ROWID',title:'ROWID',width:70,hidden:true},
			{field:'RuleCode',title:'规则代码',width:70, editor: {
					type: 'text'}},
			{field:'RuleDesc',title:'规则名称',width:100, editor: {
					type: 'text'}},
			{field:'Priority',title:'规则优先级',width:90, editor: {
					type: 'text'}},
			{field:'AllowAddDesc',title:'是否允许叠加',width:100, editor: {
					type: 'combobox',
					options: {
						valueField: 'DicCode',
						textField: 'DicDesc',
						editable:false,
						url: $URL,
						onBeforeLoad:function(param){
							param.ClassName = "BILL.CFG.COM.DictionaryCtl";
		                    param.QueryName = "QueryDicDataInfo";
		                    param.Type = "YesOrNo";
		                    param.KeyCode="";
		                    param.ResultSetType = 'array';
						},
					}
					}},
			{field:'ActiveStartDate',title:'生效日期',width:120, editor: {
					type: 'datebox'}},
			{field:'ActiveEndDate',title:'失效日期',width:120, editor: {
					type: 'datebox'}},
			{field:'RuleTypeDesc',title:'规则类型',width:100, editor: {
					type: 'combobox',
					options: {
						valueField: 'DicCode',
						textField: 'DicDesc',
						editable:false,
						url: $URL,
						onBeforeLoad:function(param){
							param.ClassName = "BILL.CFG.COM.DictionaryCtl";
		                    param.QueryName = "QueryDicDataInfo";
		                    param.Type = "PriceManageRuleType";
		                    param.KeyCode="";
		                    param.ResultSetType = 'array';
						},
					}
					}},
			{field:'Rate',title:'建议比例',width:70,align:'right',editor: {
					type: 'text'}},
			{field:'Amt',title:'建议金额',width:70,align:'right',editor: {
					type: 'text'}},
			{field:'Memo',title:'备注',width:90, editor: {
					type: 'text'}},					
			{field:'AllowAddCode',title:'AllowAddCode',width:150,hidden:true, editor: {
					type: 'text'}},
			{field:'RuleTypeCode',title:'RuleTypeCode',width:150,hidden:true, editor: {
					type: 'text'}},
		]];

	$('#ruletable').datagrid({
		fit: true,
		fitColumns:false,
		border: false,
		striped: false,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		columns: dgColumns,
		toolbar: '#rToolBar',
		onLoadSuccess:function(data){
		},
		onSelect:function(index,rowData){
			GV.RuleId = rowData.ROWID,
			initLoadGrid1("",GV.RuleId)
		},
		onUnselect:function(index,rowData){
		}
	});
}


//初始化医嘱项目表格
function init_dg1() {
	var dgColumns = [[
	        {title: '选择', field: 'CheckOrd',checkbox:true, width: 50,showTip:true},
	        {field:'RuleId',title:'规则指针',width:70,hidden:true,editor: {
					type: 'text'}},
			{field:'TarItemId',title:'医嘱项指针',width:90,hidden:true,editor: {
					type: 'text'}},
			{field:'TarItemCode',title:'医嘱项代码',width:90, editor: {
					type: 'text'}},
			{field:'TarItemDesc',title:'医嘱项名称',width:100,editor: {
					type: 'combobox',
					options: {
						panelHeight: 200,
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLFIND&QueryName=FindArcItm&ResultSetType=array',
						mode: 'remote',
						method: 'get',
						delay: 500,
						blurValidValue: true,
						valueField: 'TArcRowid',
						textField: 'TArcDesc',
						onBeforeLoad: function (param) {
							if (!param.q) {
								return false;
							}
							$.extend(param, {
								ArcAlias: param.q,                           
								ArcCode: "",                          
								OrderCat: "",                    
								ArcDesc: "", 
								ArcItemcat: "",              
								HospID: getValueById('hospital')  
							});
							return true;
					 	},
					 	onLoadSuccess: function(data) {
		                },
						onSelect: function (data) {
							var ed = $('#ConarcTable').datagrid('getEditor', {index:GV.EDITINDEX,field:'TarItemCode'});
							ed.target[0].value = data.TArcCode;
							var ed = $('#ConarcTable').datagrid('getEditor', {index:GV.EDITINDEX,field:'TarItemId'});
							ed.target[0].value = data.TArcRowid;
						}	
					}
				}},
			{field:'ActiveStartDate',title:'生效日期',width:100, editor: {
					type: 'datebox'}},
			{field:'ActiveEndDate',title:'失效日期',width:100, editor: {
					type: 'datebox'}},
			{field:'Rate',title:'调整比例',width:120,align:'right',editor: {
					type: 'text'}},
			{field:'Amt',title:'调整金额',width:120,align:'right',editor: {
					type: 'text'}},
			{field:'HospId',title:'院区指针',width:120,hidden:true,editor: {
					type: 'text'}},
			{field:'AuditStatus',title:'审核标志',width:120,},
			{field:'AuditUser',title:'审核人',width:120,},
			{field:'AuditDate',title:'审核日期',width:120,},
			{field:'AuditTime',title:'审核时间',width:120,},
			{field:'Memo',title:'审核备注',width:120,},
			{field:'ItemType',title:'项目类型',width:120,},		
			{field:'ROWID',title:'ROWID',width:150,hidden:true}
		]];

	$('#ConarcTable').datagrid({
		fit: true,
		fitColumns:false,
		border: false,
		striped: false,
		singleSelect: false, //设置为 true，则只允许选中一行。
		checkOnSelect:true,// true，当用户点击某一行时，则会选中/取消选中复选框。 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框。
		selectOnCheck:false,// true，点击复选框将会选中该行。 false，选中该行将不会选中复选框。
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		columns: dgColumns,
		toolbar: '#aToolBar',
		onLoadSuccess:function(data){
			GV.SELECTEDINDEX = -1;
			GV.EDITINDEX = -1;
		},
		onSelect:function(index,rowData){
			GV.SELECTEDINDEX = index;
		},
		onUnselect:function(index,rowData){
			GV.SELECTEDINDEX = -1;
		},
		onDblClickRow:function(index,rowData){
			GV.SELECTEDINDEX = index;
			UpdateItm();
		},
		onEndEdit:function(index,rowData,changes){
			$('#ConarcTable').datagrid('checkRow', index);
		}
	});
}



//规则表格加载数据
function initLoadGrid(){
    var queryParams = {
	    ClassName : 'BILL.CFG.COM.BL.PriceRuleCtl',
	    QueryName : 'QueryInfo',
	    HospID : getValueById('hospital'),
	    KeyCode : getValueById('search'),   
	}	
    loadDataGridStore('ruletable',queryParams);
	
}


//收费项目表格加载数据
function initLoadGrid1(KeyCode,rule){
	var queryParams = {
	    ClassName : 'BILL.CFG.COM.BL.PriceRuleConItmCtl',
	    QueryName : 'QueryInfo',
	    KeyCode : KeyCode,
	    rule : GV.RuleId,
	    type : '医嘱项',
	}	
    loadDataGridStore('ConarcTable',queryParams);
	
}


//规则查询
function FindRule(){
	initLoadGrid();
}

//医嘱项目查询
function FindItm(KeyCode,rule){
	var KeyCode = getValueById('searchi');
	initLoadGrid1(KeyCode,GV.RuleId);
}

//医嘱项目新增
function AddItm(){
	if(GV.SELECTEDINDEX > -1 && GV.EDITINDEX !=-1){
		$.messager.alert('提示','只能操作一条数据','info');
		return;		
	}
	if(GV.RuleId == -1 ){
		$.messager.alert('提示','未选择规则,无法新增','info');
		return;		
	}	
	$('#ConarcTable').datagrid('insertRow',{
		index: 0,	// index start with 0
		row: {
			ROWID:'',
			RuleId: GV.RuleId,
			TarItemCode: '',
			TarItemDesc: '',
			ActiveStartDate: getValueById('ActiveStartDate'),
			ActiveEndDate: getValueById('ActiveEndDate'),
			Rate: '',
			Amt: '',
			HospId: getValueById('hospital'),
			AuditStatus: '',
			AuditUser: '',
			AuditDate: '',
			AuditTime: '',
			Memo: '',
			ItemType: '医嘱项',			
		}
	});
	$('#ConarcTable').datagrid('beginEdit', 0);
	$('#ConarcTable').datagrid('checkRow', 0);
	GV.SELECTEDINDEX = 0;
	GV.EDITINDEX = 0;
}

//医嘱项目修改
function UpdateItm(){
	$('#ConarcTable').datagrid('endEdit', GV.EDITINDEX);
	if(GV.SELECTEDINDEX < 0){
		$.messager.alert('提示','请选择一条数据','info');
		return;		
	}
	$('#ConarcTable').datagrid('beginEdit', GV.SELECTEDINDEX);
	GV.EDITINDEX = GV.SELECTEDINDEX;

}

//医嘱项目保存
function SaveItm(){
	try{
		$('#ConarcTable').datagrid('acceptChanges');
		var row = $('#ConarcTable').datagrid('getChecked')
			if (row.length==0)
			{
				$.messager.alert('提示','请勾选需要保存的记录。','info');
				return;
			}
		for (var i=0;i<row.length;i++){
				var selRow = row[i];
				if(selRow.TarItemDesc == ''){
					$.messager.alert('错误','收费项名称不能为空','error');
			        $('#ConarcTable').datagrid('beginEdit', GV.EDITINDEX);
			        return;
			    }
			    if(selRow.ActiveStartDate == ''){
			        $.messager.alert('错误','生效日期不能为空','error');
			        $('#ConarcTable').datagrid('beginEdit', GV.EDITINDEX);
			        return;
			    }
			    if(selRow.ActiveEndDate == ''){
			        $.messager.alert('错误','失效日期不能为空','error');
			        $('#ConarcTable').datagrid('beginEdit', GV.EDITINDEX);
			        return;
			    }
		        //var tmpStDate = tkMakeServerCall("websys.Conversions", "DateHtmlToLogical", selRow.ActiveStartDate);
		        //var tmpEndDate = tkMakeServerCall("websys.Conversions", "DateHtmlToLogical", selRow.ActiveEndDate);
		        if(selRow.ActiveStartDate > selRow.ActiveEndDate){
			        $.messager.alert('错误','生效日期不能大于失效日期','error');
			        $('#ConarcTable').datagrid('beginEdit', GV.EDITINDEX);
			        return;
		        }
		        if(selRow.Rate == '' && selRow.Amt == ''){
			        $.messager.alert('错误','调整比例和调整金额不能同时为空','error');
		            return;		
     			}
		        var inputStr = selRow.ROWID + "^" + selRow.TarItemId + "^" + selRow.RuleId + "^" + selRow.ActiveStartDate + "^" + selRow.ActiveEndDate + "^" + selRow.Rate + "^" + selRow.Amt
		        var inputStr = inputStr + "^" + selRow.HospId + "^" + selRow.AuditStatus + "^" + selRow.AuditUser + "^" + selRow.AuditDate + "^" + selRow.AuditTime + "^" + selRow.Memo + "^" + selRow.ItemType   
		        var rtn=tkMakeServerCall("BILL.CFG.COM.BL.PriceRuleConItmCtl", "Save", inputStr);
		        if(rtn < "0"){
			        $.messager.alert('提示', "医嘱项名称为：" + selRow.TarItemDesc + "的数据保存失败:" + rtn.split('^')[1], 'error');
			        initLoadGrid1();
			    }else{
				    $.messager.alert('提示', "保存成功", 'info');	
			    }
		}	
		initLoadGrid1();
	}catch(e){
	}
}

//停用医嘱项目
function StopItm(){
	if(GV.SELECTEDINDEX < 0){
		$.messager.alert('提示','请选择要停用的记录','info');
		return;		
	}
	try{
		$.messager.confirm("提示", "是否停用？", function (r) { // prompt 此处需要考虑为非阻塞的
	if (r) {
		//停用医嘱项
		$('#ConarcTable').datagrid('updateRow',{
               index:GV.SELECTEDINDEX,
               row: {
	               ActiveEndDate: getDefStDate(0),
               }
        });
        var selRow = $('#ConarcTable').datagrid('getSelected')	
		var inputStr = selRow.ROWID + "^" + selRow.TarItemId + "^" + selRow.RuleId + "^" + selRow.ActiveStartDate + "^" + selRow.ActiveEndDate + "^" + selRow.Rate + "^" + selRow.Amt
		        var inputStr = inputStr + "^" + selRow.HospId + "^" + selRow.AuditStatus + "^" + selRow.AuditUser + "^" + selRow.AuditDate + "^" + selRow.AuditTime + "^" + selRow.Memo + "^" + selRow.ItemType   
		        var rtn=tkMakeServerCall("BILL.CFG.COM.BL.PriceRuleConItmCtl", "Save", inputStr);
		        if(rtn < "0"){
			        $.messager.alert('提示', "停用失败:" + rtn.split('^')[1], 'error');
			        initLoadGrid1();
			    }else{
				    $.messager.alert('提示', "停用成功", 'info');
				    initLoadGrid1();	
			    }
			} else {
		return false;
	}
	})
	}catch(e){
	}
	
}

//规则关联医嘱项导出
function Export()
{
   try
   {
		$.messager.progress({
	         title: "提示",
			 msg: '正在导出规则关联医嘱项',
			 text: '导出中....'
			   });
		$cm({
			ResultSetType:"ExcelPlugin",  
			ExcelName:"规则关联医嘱项目表",		  
			PageName:"QueryInfo",      
			ClassName:"BILL.CFG.COM.BL.PriceRuleConItmCtl",
			QueryName: 'QueryInfo',
			rule: GV.RuleId,
			type : "医嘱项" ,
	        KeyCode : getValueById('searchi'),
		},function(date){
			  setTimeout('$.messager.progress("close");', 3 * 1000);	
		});
		
   } catch(e) {
	   $.messager.alert("警告",e.message);
	   $.messager.progress('close');
   }; 
}

//规则关联医嘱项目导入
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
         msg: '规则关联医嘱项目表导入',
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
            msg: '规则关联医嘱项目表导入',
            text: '导入中，共：'+(rowCnt-1)+'条'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
       ItmArrSave(arr);
	}
	});
}

//规则数据保存
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
			 var ROWID=rowArr[0]
			 var TarItemId=rowArr[1]
			 var TarItemCode=rowArr[2]
			 var TarItemDesc=rowArr[3]
			 var RuleId=rowArr[4]
			 var RuleDesc=rowArr[5]
			 var ActiveStartDate=rowArr[6]
			 var ActiveEndDate=rowArr[7]
			 var Rate=rowArr[8]
			 var Amt=rowArr[9]
			 var HospId=rowArr[10]
			 var AuditStatus=rowArr[11]
			 var AuditUser=rowArr[12]
			 var AuditDate=rowArr[13]
			 var AuditTime=rowArr[14]
			 var Memo=rowArr[15]
			 var ItemType=rowArr[16]
			 var inputStr = ROWID + "^" + TarItemId + "^" + RuleId + "^" + ActiveStartDate + "^" + ActiveEndDate + "^" + Rate + "^" + Amt
		     var inputStr = inputStr + "^" + HospId + "^" + AuditStatus + "^" + AuditUser + "^" + AuditDate + "^" + AuditTime + "^" + Memo + "^" + ItemType   
		     var rtn=tkMakeServerCall("BILL.CFG.COM.BL.PriceRuleConItmCtl", "Save", inputStr);
                    if (rtn == null || rtn == undefined) rtn = -1                    
                    if (rtn >= 0) {
                        sucRowNums = sucRowNums + 1;
                    } else {
                        errRowNums = errRowNums + 1;
                        if (ErrMsg == "") {
                            ErrMsg = i+":"+rtn;
                        } else {
                            ErrMsg = ErrMsg + "<br>" + i+":"+rtn;
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
              initLoadGrid1();
		      return ;
		 }
		 catch(ex)
		 {
			  $.messager.progress("close");
			  $.messager.alert('提示', '保存规则关联医嘱项目表数据异常：'+ex.message,'error')
	          return ;
	      }
  return ;
	
}

//初始化医院下拉框
function init_hospital() {
	var tableName = "CF_BILL_COM.PriceRuleConItm";
	var defHospId = session['LOGON.HOSPID'];
	var SessionStr = session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.LOCID'] + "^" + defHospId; // 用户ID^安全组ID^科室ID^当前登录医院ID
	$("#hospital").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName + '&SessionStr=' + SessionStr,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			initLoadGrid()
		}
	});
}


//判断哪个按钮按下
$('.hisui-linkbutton').bind('click',function(){
	 switch (this.id){ 
	    case "btnFind" : // 查询规则
	            FindRule();	         
	    	break;
	    case "aBtnAdd" : // 收费项目新增
	            AddItm();	         
	    	break;
	    case "aBtnUpdate" : // 收费项目修改
	            UpdateItm();	         
	    	break;
	    case "aBtnSave" : // 收费项目保存
	           SaveItm();	         
	    	break;
	    case "aBtnStop" : // 收费项目保存
	           StopItm();	         
	    	break;
	    case "btnFindItm" : // 查询收费项目
	           FindItm();	         
	    	break;	    	
	    default :
	    	break;
	    }
		
}) 
