var DiagnosListDataGrid;
var editRow = undefined;
var DiagnosValue;
var DiagnosListSelectedRow="";
var value="";
var dialog;
var tabPreAdmDiagnosListDataGrid;
var LoadPreAdmDianosListVoerFlag=0;
var SelMRCICDRowid="";
var PrivateListStrArr = new Array();
var LocListStrArr = new Array();
var TemplateTableColumns=[[
		{ field: 'RowNum', title: '行号',hidden:true},
		{ field: 'ICDDesc1', title: '名称', width: 90, align: 'left', sortable: true, resizable: true},
		{ field: 'ICDDr1',hidden:true},
		{ field: 'ICDDesc2', title: '名称', width: 90, align: 'left', sortable: true, resizable: true},
		{ field: 'ICDDr2',hidden:true},
		{ field: 'ICDDesc3', title: '名称', width: 90, align: 'left', sortable: true, resizable: true},
		{ field: 'ICDDr3',hidden:true},
		{ field: 'ICDDesc4', title: '名称', width: 90, align: 'left', sortable: true, resizable: true},
		{ field: 'ICDDr4',hidden:true},
		{ field: 'ICDDesc5', title: '名称', width: 90, align: 'left', sortable: true, resizable: true},
		{ field: 'ICDDr5',hidden:true},
  ]];
$(window).load(function(){
	//初始化本次诊断
	InitDiagnosList();
	//初始化诊断类型
	InitMRDiagType();
	//初始化诊断combogrid
	InitDiagnosComboGrid();
	
	InitSyndromeComboGrid();
	///初始化模板
	InitTemplate();
	ChangeDiagnosCatContrl()
	//引用上次门诊就诊诊断
	//AddPreAdmDiagnos();
	
	//历史诊断,点击页签才加载显示,以提高初始化时候的速度
	$('#dataTabs').tabs({
		onSelect: function(title,index){
			var CurrentTabPanel=$('#dataTabs').tabs("getSelected");
			var Length=CurrentTabPanel.length
			if (title=="历史诊断"){
				if (document.getElementById("tabDiagnosHistory")) return
				var TemplateTable=$('<table id="tabDiagnosHistory"></table>');
				CurrentTabPanel.html(TemplateTable);
				InitDiagnosHistoryList();
			}
		}
	})
	$('#TempdataTabs').tabs({
		onSelect: function(title,index){
			if (title=="科室模板"){
				var CTLOCID = session['LOGON.CTLOCID'];
			  	var LocList= cspRunServerMethod(GetLocTemplateListMethod, CTLOCID);
				var LocListIndexNum = LocList.split(String.fromCharCode(2))[1];
				if ((LocList=="")||(LocListIndexNum==0)){return;}
				var CurrentTabPanel=$('#LocTemplate').tabs("getTab",0);
				if (typeof CurrentTabPanel =="undefined"){
					return;
				}
				if (typeof CurrentTabPanel[0] !="undefined" && typeof CurrentTabPanel[0].innerHTML !="undefined" 
					&& CurrentTabPanel[0].innerHTML!=""){
					return;
				}
				var LocRowID=LocListStrArr[0].split("^")[0]
				_content = '<iframe id="TemplateTable_' + LocRowID + '" name="TemplateTable_' + LocRowID +'" src="dianostemplate.show.csp?TemplateRowID=' + LocRowID + '" style="width:100%;height:100%;" frameborder="0" scrolling="Yes"></iframe>'
				CurrentTabPanel.html(_content);
			}
		}
	});
});
$(document).ready(function(){
	$("#BSaveDiagnos").click(function(){
		if((!isNaN(SelMRCICDRowid))&&(SelMRCICDRowid!="")){
		    if(!CheckDiagIsEnabled(SelMRCICDRowid)) return false;
		    InsertMRDiagnos(SelMRCICDRowid)
		}else{
	        InsertMRDiagnos("");
	    }
	});
	var obj=document.getElementById("DiagnosCat")
	if (obj){
		obj.onchange=ChangeDiagnosCatContrl;
		//obj.onkeydown=ChangeDiagnosCatContrl;
	}
	//诊断类型默认
	$("input[name='DiagnosCat'][value="+ChinaMedFlag+"]").attr("checked",true);
});	
/*$(function(){
	//初始化本次诊断
	InitDiagnosList();
	InitDiagnosHistoryList();
	//初始化诊断类型
	InitMRDiagType();
	//初始化诊断combogrid
	InitDiagnosComboGrid();
	
	InitSyndromeComboGrid();
	///初始化模板
	InitTemplate();
	
	$("#BSaveDiagnos").click(function(){
	InsertMRDiagnos();
	});
	var obj=document.getElementById("DiagnosCat")
	if (obj){
		obj.onchange=ChangeDiagnosCatContrl;
		obj.onkeydown=ChangeDiagnosCatContrl;
	}
	ChangeDiagnosCatContrl()
	//引用上次门诊就诊诊断
	AddPreAdmDiagnos();
});*/

function ReSetFocus(){
	var CurrentPagNum=$(".pagination-num").val()
	//if (+CurrentPagNum>1){
		window.setTimeout(function (){
			var CurrentOrdName=$('#DiagnosSearch').combogrid('getValue');
			if(CurrentOrdName!=""){
				var CheckValue=/^\d+$/;
				if (CheckValue.test(CurrentOrdName)){
					SelMRCICDRowid="";
					$('#DiagnosSearch').combogrid("setValue","");
					$('#DiagnosSearch').combo("setText", "")
				}
			}
			//setTimeout($('#DiagnosSearch').next('span').find('input').focus(),50)
			setTimeout(function() {
				$('#DiagnosSearch').next('span').find('input').focus();
				window.returnValue=false;
			},50)
		},100)
	//}
	
}
function InitDiagnosComboGrid()
{
	var fileview = $.extend({}, $.fn.datagrid.defaults.view, { 
	       onAfterRender: function (target) { ReSetFocus(); }
	       //,onBeforeRender:function (target, rows){ReSetSelect();} 
	});
	$('#DiagnosSearch').combogrid({
		panelWidth:500,
		panelHeight:260,
		view: fileview,  
		delay: 0,
		mode: 'remote',   
		//url: "./dhcdoc.cure.query.combo.easyui.csp", 
		url:PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 8,//每页显示的记录条数，默认为10   
		pageList: [8,20,30],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'HIDDEN',    
		textField: 'desc',    
		columns: [[    
			{field:'desc',title:'诊断名称',width:400,sortable:true},
			{field:'code',title:'code',width:120,sortable:true},
			{field:'HIDDEN',title:'HIDDEN',width:120,sortable:true,hidden:true},
		]],
		keyHandler:{
			up: function () {
                //取得选中行
                var selected = $('#DiagnosSearch').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#DiagnosSearch').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                        $('#DiagnosSearch').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#DiagnosSearch').combogrid('grid').datagrid('getRows');
                    $('#DiagnosSearch').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }

             },
             down: function () {
              //取得选中行
                var selected = $('#DiagnosSearch').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#DiagnosSearch').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#DiagnosSearch').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#DiagnosSearch').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#DiagnosSearch').combogrid('grid').datagrid('selectRow', 0);
                }

            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
          var selected = $('#DiagnosSearch').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      $('#DiagnosSearch').combogrid("options").value=selected.HIDDEN;
			      
			      $('#DiagnosSearch').combo("setText", selected.desc)
			    }
          $('#DiagnosSearch').combogrid('hidePanel');
          DiagNextFocus()
					return
      },

			query:function(q){
				///如果输入的最后一位是数字，那么就自动定位到该行
				/*var SelNum=q.charAt(q.length-1)
				if (($.isNumeric(SelNum)==true)&&(SelNum>0)){
					$('#DiagnosSearch').combogrid('grid').datagrid('selectRow', SelNum-1);
					var selected = $('#DiagnosSearch').combogrid('grid').datagrid('getSelected'); 
					if (selected) {
						$('#DiagnosSearch').combogrid('hidePanel');
						$('#DiagnosSearch').combogrid("options").value=selected.HIDDEN;
						$('#DiagnosSearch').combo("setText", selected.desc)
					}
					$('#DiagnosSearch').combogrid('hidePanel');
					DiagNextFocus()
					return
				}*/
				//$('#DiagnosSearch').combogrid("grid").datagrid("reload",{'keyword':q});
				//LoadDiagnosData(q);
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					this.AutoSearchTimeOut=window.setTimeout("LoadDiagnosData('"+q+"')",400)
				}else{
					this.AutoSearchTimeOut=window.setTimeout("LoadDiagnosData('"+q+"')",400)
				}
				$('#DiagnosSearch').combogrid("setValue",q);
      }
		},
		onSelect: function (){
			
			var selected = $('#DiagnosSearch').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#DiagnosSearch').combogrid("options").value=selected.HIDDEN;
			  SelMRCICDRowid=selected.HIDDEN
			}
			/*
			$('#DiagnosSearch').combogrid('hidePanel');
			DiagNextFocus()
			return
			*/
		},
		onClickRow: function (row){
			//alert(row)
			var selected = $('#DiagnosSearch').combogrid('grid').datagrid('getSelected'); 
			if (selected) {
				 $('#DiagnosSearch').combogrid("options").value=selected.HIDDEN;
			   $('#DiagnosSearch').combo("setText", selected.desc)
			}
		}
		
	});
  ///LoadDiagnosData("");
}

function LoadNCDDescData(desc){
	var editors = DiagnosListDataGrid.datagrid('getEditors', editRow);
	var param = new Object();
	param.ClassName = 'web.DHCMRDiagnosNew';
	param.QueryName = 'GetNCDList';
	param.Arg1 =desc;
	param.ArgCnt =1;
	var opts = $(editors[1].target).combogrid("grid").datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	$(editors[1].target).combogrid("grid").datagrid('load', param);
	
}

function LoadDiagnosData(desc)
{
	//var desc = $('#DiagnosSearch').combogrid('getValue'); 
	if(desc=="") return false;
	
	//var ICDType=$("#DiagnosCat").val(); 
	var ICDType=$('input:radio[name="DiagnosCat"]:checked').val()
    var queryParams = new Object();
	queryParams.ClassName ='web.DHCMRDiagnos';
	queryParams.QueryName ='LookUpWithAlias';   
	queryParams.Arg1 =desc;
	queryParams.Arg2 ="";
	queryParams.Arg3 ="";
	queryParams.Arg4 ="";
	queryParams.Arg5 =ICDType;
	queryParams.ArgCnt =5;
	
	var opts = $('#DiagnosSearch').combogrid("grid").datagrid("options");
	//queryParams.Arg5 =qor.u;
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	$('#DiagnosSearch').combogrid("grid").datagrid('load', queryParams);
}

function InitSyndromeComboGrid()
{
	$('#SyndromeSearch').combogrid({
		panelWidth:500,
		panelHeight:260,
		delay: 0,    
		mode: 'remote', 
		missingMessage: "test1",    
		//url: "./dhcdoc.cure.query.combo.easyui.csp", 
		url:PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 8,//每页显示的记录条数，默认为10   
		pageList: [8,20,30],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'HIDDEN',    
		textField: 'desc',    
		columns: [[    
			{field:'desc',title:'证型名称',width:400,sortable:true},
			{field:'code',title:'code',width:120,sortable:true},
			{field:'HIDDEN',title:'HIDDEN',width:120,sortable:true,hidden:true},
		]],
		keyHandler:{
			up: function () {
                //取得选中行
                var selected = $('#SyndromeSearch').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#SyndromeSearch').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                        $('#SyndromeSearch').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#SyndromeSearch').combogrid('grid').datagrid('getRows');
                    $('#SyndromeSearch').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }

             },
             down: function () {
              //取得选中行
                var selected = $('#SyndromeSearch').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#SyndromeSearch').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#SyndromeSearch').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#SyndromeSearch').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#SyndromeSearch').combogrid('grid').datagrid('selectRow', 0);
                }

            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
          var selected = $('#SyndromeSearch').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      $('#SyndromeSearch').combogrid("options").value=selected.HIDDEN;
			      $('#SyndromeSearch').combo("setText", selected.desc)
			    }
                //选中后让下拉表格消失
                $('#SyndromeSearch').combogrid('hidePanel');
                ButtonFoces()
            },

			query:function(q){
				///如果输入的最后一位是数字，那么就自动定位到该行
				var SelNum=q.charAt(q.length-1)
				if (($.isNumeric(SelNum)==true)&&(SelNum>0)){
					 $('#SyndromeSearch').combogrid('grid').datagrid('selectRow', SelNum-1);
					 var selected = $('#SyndromeSearch').combogrid('grid').datagrid('getSelected'); 
					 if (selected) {
					 	$('#SyndromeSearch').combogrid('hidePanel');
						$('#SyndromeSearch').combogrid("options").value=selected.HIDDEN;
						$('#SyndromeSearch').combo("setText", selected.desc)
						
					}
					$('#SyndromeSearch').combogrid('hidePanel');
					ButtonFoces()
					return
				}
				
				
				//$('#SyndromeSearch').combogrid("grid").datagrid("reload",{'keyword':q});
				//LoadSyndromeData(q);
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					this.AutoSearchTimeOut=window.setTimeout("LoadSyndromeData('"+q+"')",400)
				}else{
					this.AutoSearchTimeOut=window.setTimeout("LoadSyndromeData('"+q+"')",400)
				}
				$('#SyndromeSearch').combogrid("setValue",q);
      }
		},
		onSelect: function (){
			
			var selected = $('#SyndromeSearch').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#SyndromeSearch').combogrid("options").value=selected.HIDDEN;
			}
			/*
			ButtonFoces()
			*/
		},
		onClickRow: function (row){
			//alert(row)
			var selected = $('#SyndromeSearch').combogrid('grid').datagrid('getSelected'); 
			if (selected) {
				 $('#SyndromeSearch').combogrid("options").value=selected.HIDDEN;
			   $('#SyndromeSearch').combo("setText", selected.desc)
			}
		}
	});
	LoadSyndromeData("");
}

function LoadSyndromeData(desc)
{
	//var desc = $('#SyndromeSearch').combogrid('getValue'); 
	if(desc=="") return false;
	
	//var ICDType=$("#DiagnosCat").val(); 
	var ICDType=$('input:radio[name="DiagnosCat"]:checked').val()
  	var queryParams = new Object();
	queryParams.ClassName ='web.DHCMRDiagnos';
	queryParams.QueryName ='LookUpWithAlias';   
	queryParams.Arg1 =desc;
	queryParams.Arg2 ="";
	queryParams.Arg3 ="";
	queryParams.Arg4 ="";
	queryParams.Arg5 =2;
	queryParams.ArgCnt =5;
	var opts = $('#SyndromeSearch').combogrid("grid").datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	$('#SyndromeSearch').combogrid("grid").datagrid('load', queryParams);
}
function InitMRDiagType()
{
	$("#MRDiagType").combobox({
  	valueField:'DTYPRowid',   
  	textField:'DTYPDesc',
  	url:"./dhcdoc.cure.query.combo.easyui.csp",
  	onBeforeLoad:function(param){
			param.ClassName = 'web.DHCMRDiagnosNew';
			param.QueryName = 'GetDiagnosTypeList';
			param.Arg1 =EpisodeType;
			param.ArgCnt =1;
		}  
	});
}
///查询本次诊断列表诊断
function InitDiagnosList()
{
	var DiagnosListBar = [{
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() { //getSelected  getSelections
				var rows = DiagnosListDataGrid.datagrid('getSelected');
			   if (rows) {
                       var index = DiagnosListDataGrid.datagrid('getRowIndex', rows);
	                   //DiagnosListDataGrid.datagrid("selectRow",DiagnosListSelectedRow)
					   DiagnosListDataGrid.datagrid("selectRow",index)
	                   var MRDiagnosRowid=rows.DiagnosValue
	                   var ret=DeleteMRDiagnos(MRDiagnosRowid);
					   if(editRow = index){
		                   editRow=undefined
		               }
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
	           
            }
        },
        '-', {
            text: '←',
            handler: function() {
	            var rows = DiagnosListDataGrid.datagrid('getSelected');
	            if (rows) {
		            AdjustMRDiagnosLevel(DiagnosListSelectedRow,-1);
		        }else{
			        $.messager.alert("提示", "请选择行", "error");
			    }
                
            }
        },
        '-', {
            text: '→',
            handler: function() {
              var rows = DiagnosListDataGrid.datagrid('getSelected');
	            if (rows) {
		            AdjustMRDiagnosLevel(DiagnosListSelectedRow,1);
		        }else{
			        $.messager.alert("提示", "请选择行", "error");
			    }
            }
        },
        '-', {
            text: '↑',
            handler: function() {
                 var rows = DiagnosListDataGrid.datagrid('getSelected');
	            if (rows) {
		            BMoveUpclickhandler();
		        }else{
			        $.messager.alert("提示", "请选择行", "error");
			    }
            }
        },
        '-', {
            text: '↓',
            handler: function() {
                var rows = DiagnosListDataGrid.datagrid('getSelected');
	            if (rows) {
		            BMoveDownclickhandler();
		        }else{
			        $.messager.alert("提示", "请选择行", "error");
			    }
            }
        },
        '-', {
            text: '更新',
            iconCls: 'icon-save',
            handler: function() {
	            if (editRow != undefined) {
		            var editors = DiagnosListDataGrid.datagrid('getEditors', editRow); 
		            var DiagnosNotechangevalue =  editors[0].target.val();
		            //var rows = DiagnosListDataGrid.datagrid('getSelected');
		            //var MRDiagnosNoteId=rows.DiagnosValue
					var rows = DiagnosListDataGrid.datagrid('getRows');
		            var MRDiagnosNoteId=rows[editRow].DiagnosValue
		            UpdateMrdiagNote(MRDiagnosNoteId, DiagnosNotechangevalue);
		            
		            //var NCDCode=  editors[1].target.combogrid("options").value;
		            //UpdateMrdiagNCDInfo(MRDiagnosNoteId, NCDCode);
		            
		            DiagnosListDataGrid.datagrid("endEdit", editRow);
		            editRow = undefined;
		            DiagnosListDataGrid.datagrid('load');
		            DiagnosListDataGrid.datagrid('unselectAll');
		            LoadDiagnosHistoryDataGrid();
		        }
            }
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
	            if(editRow==undefined) return false;
                editRow = undefined;
                DiagnosListDataGrid.datagrid("rejectChanges");
                DiagnosListDataGrid.datagrid("unselectAll");
				DiagnosListDataGrid.datagrid('load');
            }
        },'-',{
	        text: '常用模板维护',
	         iconCls: 'icon-edit',
            handler: function() {
                MydiagnosEditshow();
            }
	    }
	    /*
        '-', {
            text: '<a style="color:red;">慢特病患者请关联慢特病</a>',
            iconCls: '',
            handler: function() {}
        }*/
        
        ];
	DiagnosListColumns=[[
          { field: 'DiagnosValue', title: '', width: 1,align: 'center', sortable: true,hidden:true}, 
					{ field: 'DiagnosCodeRowid', title:'', width: 1,align: 'center', sortable: true,hidden:true},
        	{ field: 'DiagnosType', title: '类型', width: 60, align: 'center', sortable: true,hidden:true},
					{ field: 'DiagnosCat', title: '分类', width:30, align: 'left', sortable: true, resizable: true},
					{ field: 'DiagnosDesc', title: 'ICD描述', width: 200, align: 'left', sortable: true, resizable: true},
					{ field: 'DiagnosMRDesc', title: '诊断注释', width: 80, align: 'left', sortable: true, resizable: true,
					  editor : {
						  type : 'text',
						  options : {
						  }
					  }
					},
					{ field: 'NCDCode', width: 1, align: 'left', sortable: true,hidden:true},
					{ field: 'NCDInfo', title: '门慢/特病', width: 120, align: 'left', sortable: true, resizable: true,hidden:true/*,
						editor : {
							type : 'combogrid',
							options : {
								panelWidth:120,
								panelHeight:170,
								delay: 0,
								mode: 'remote',
								url:PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
								fitColumns: true,   
								striped: true,   
								editable:true,   
								pagination : false,//是否分页
								rownumbers:false,//序号
								collapsible:false,//是否可折叠的   
								fit: true,//自动大小    
								method:'post', 
								idField: 'NCDCode',    
								textField: 'NCDDesc',    
								columns: [[
									{field:'NCDDesc',title:'慢病名称',width:120,sortable:true},
									{field:'NCDCode',title:'code',width:120,sortable:true,hidden:true},
									{field:'NCDRowid',title:'ID',width:120,sortable:true,hidden:true},
								]],
								keyHandler:{
									up: function () {
										var editors = DiagnosListDataGrid.datagrid('getEditors', editRow);
					          var selected = $(editors[1].target).combogrid('grid').datagrid('getSelected');
					          if (selected) {
					              var index = $(editors[1].target).combogrid('grid').datagrid('getRowIndex', selected);
					              if (index > 0) {
					                  $(editors[1].target).combogrid('grid').datagrid('selectRow', index - 1);
					              }
					          } else {
					              var rows = $(editors[1].target).combogrid('grid').datagrid('getRows');
					              $(editors[1].target).combogrid('grid').datagrid('selectRow', rows.length - 1);
					          }
					      	},
					      	down: function () {
					      		var editors = DiagnosListDataGrid.datagrid('getEditors', editRow);
					          var selected = $(editors[1].target).combogrid('grid').datagrid('getSelected');
					          if (selected) {
					              var index = $(editors[1].target).combogrid('grid').datagrid('getRowIndex', selected);
					              if (index < $(editors[1].target).combogrid('grid').datagrid('getData').rows.length - 1) {
					                  $(editors[1].target).combogrid('grid').datagrid('selectRow', index + 1);
					              }
					          } else {
					              $(editors[1].target).combogrid('grid').datagrid('selectRow', 0);
					          }
					      	},
					      	left:function(){
					      		return false
					      	},
					      	right:function(){
					      		return false
					      	}, 
									
									
									enter: function () { 
										var editors = DiagnosListDataGrid.datagrid('getEditors', editRow);
								    //文本框的内容为选中行的的字段内容
					          var selected = $(editors[1].target).combogrid('grid').datagrid('getSelected');  
								    if (selected) { 
								      $(editors[1].target).combogrid("options").value=selected.NCDCode;
								      $(editors[1].target).combo("setText", selected.NCDDesc)
								    }
					          $(editors[1].target).combogrid('hidePanel');
										return
						      },
						
									query:function(q){
										var editors = DiagnosListDataGrid.datagrid('getEditors', editRow);
										///如果输入的最后一位是数字，那么就自动定位到该行
										/*
										var SelNum=q.charAt(q.length-1)
										if (($.isNumeric(SelNum)==true)&&(SelNum>0)){
											$(editors[1].target).combogrid('grid').datagrid('selectRow', SelNum-1);
											var selected = $(editors[1].target).combogrid('grid').datagrid('getSelected'); 
											if (selected) {
												$(editors[1].target).combogrid('hidePanel');
												$(editors[1].target).combogrid("options").value=selected.NCDCode;
											}
											$(editors[1].target).combogrid('hidePanel');
											return
										}
										*/
										/*$(editors[1].target).combogrid("grid").datagrid("reload",{'keyword':q});
										if (this.AutoSearchTimeOut) {
											window.clearTimeout(this.AutoSearchTimeOut)
											this.AutoSearchTimeOut=window.setTimeout("LoadNCDDescData('"+q+"')",400)
										}else{
											this.AutoSearchTimeOut=window.setTimeout("LoadNCDDescData('"+q+"')",400)
										}
										$(editors[1].target).combogrid("setValue",q);
						      }
								},
								onSelect: function (){
									var editors = DiagnosListDataGrid.datagrid('getEditors', editRow);
									var selected = $(editors[1].target).combogrid('grid').datagrid('getSelected');  
									if (selected) { 
									  $(editors[1].target).combogrid("options").value=selected.NCDCode;
									}
								},
								onClickRow: function (row){
									var editors = DiagnosListDataGrid.datagrid('getEditors', editRow);
									var selected = $(editors[1].target).combogrid('grid').datagrid('getSelected'); 
									if (selected) {
										 $(editors[1].target).combogrid("options").value=selected.NCDCode;
									   $(editors[1].target).combo("setText", selected.NCDDesc)
									}
								}
							}
					  }*/
					},
					
					{ field: 'DiagnosICDCode', title: 'ICD代码', width: 70, align: 'center', sortable: true, resizable:true,hidden:true},
					{ field: 'DiagStat', title: '状态', width: 30, align: 'center', sortable: true, resizable: true},
					{ field: 'DiagnosDate', title: '诊断日期', width: 80, align: 'center', sortable: true, hidden:true},
					{ field: 'DiagnosOnsetDate', title: '发病日期', width: 80, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'DiagnosLeavel', title: '级别', width: 55, align: 'center', sortable: true, resizable: true}
	]];

	DiagnosListDataGrid=$('#tabDiagnosList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"DiagnosValue",
		pageList : [15,50,100,200],
		columns :DiagnosListColumns,
		toolbar :DiagnosListBar,
		onClickRow:function(rowIndex, rowData){
			DiagnosListSelectedRow=rowIndex
		},
		onDblClickRow:function(rowIndex, rowData){
			if ((editRow != undefined)&&(editRow!=rowIndex)) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存或取消编辑", "error");
		        return false;
			}
			editRow = rowIndex;
			//debugger
			///NCDCode
			var NCDCode=rowData.NCDCode
			var NCDInfo=rowData.NCDInfo
			
			
			DiagnosListDataGrid.datagrid("beginEdit", rowIndex);
			//var editors = DiagnosListDataGrid.datagrid('getEditors', editRow);
			//$(editors[1].target).combogrid("options").value=NCDCode;
			//$(editors[1].target).combo("setText", NCDInfo)
			//LoadNCDDescData(NCDInfo);
			
			//LoadNCDDescData("");
		},
		onBeforeLoad:function(param){
						param.ClassName ='web.DHCMRDiagnosNew';
						param.QueryName ='DiagnosList';
						param.Arg1 =mradm;
						param.ArgCnt =1;
		}
	});
	//LoadDiagnosListDataGrid();
}
function LoadDiagnosListDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCMRDiagnosNew';
	queryParams.QueryName ='DiagnosList';
	queryParams.Arg1 =mradm;
	queryParams.Arg2 ="";
	queryParams.Arg3 ="";
	queryParams.Arg4 =session['LOGON.CTLOCID'];
	queryParams.ArgCnt =4;
	var opts = DiagnosListDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	DiagnosListDataGrid.datagrid('load', queryParams);
}
///查询历史诊断列表诊断
function InitDiagnosHistoryList()
{
	DiagnosHistoryColumns=[[    
          { field: 'MRDIADr', title: '', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'Desc', title:'ICD描述', width: 100, align: 'center', sortable: true
					},
					{ field: 'MRDesc', title:'备注', width: 80, align: 'center', sortable: true
					},
        	{ field: 'DoctDesc', title: '医生', width: 80, align: 'center', sortable: true
					},
					{ field: 'MRDate', title: '诊断日期', width: 100, align: 'center', sortable: true, resizable: true
					},
					{ field: 'MRtime', title: '诊断时间', width: 100, align: 'center', sortable: true, resizable: true,hidden:true
					},
					{ field: 'MainMRDIADr', title: '主诊断索引', width: 50, align: 'center', sortable: true, resizable: true,hidden:true
					},
					{ field: 'Rowid', title: 'ICDCode', width: 50, align: 'center', sortable: true, resizable: true,hidden:true
					},
					{ field: 'AllowItemCatIDStr', title: '添加', width: 80, align: 'center', sortable: true, resizable: true,  
          	formatter:function(value,rec){
            		//var btn = '<a class="'+rec.MRDIADr+'_editcls" onclick="HisdiagnosObjDbclick(\'' + rec.MRDIADr + '\')">添加</a>';
            		var btn = '<a class="editcls" onclick="HisdiagnosObjDbclick(\'' + rec.Rowid + '\',\''+rec.MRDesc+'\')">添加</a>';
            		return btn;
            }
					}
    			 ]];
	DiagnosHistoryDataGrid=$('#tabDiagnosHistory').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"MRDIADr",
		pageList : [15,50,100,200],
		columns :DiagnosHistoryColumns,
		onClickRow:function(rowIndex, rowData){
		},
		onLoadSuccess:function(data){
			//alert(data)
			//debugger;
			/*
			var len=data.rows.length
			for (var i=0;i<len;i++) {
				var MRDIADr=data.rows[i].MRDIADr
				var MainMRDIADr=data.rows[i].MainMRDIADr
				if (MainMRDIADr!=""){
					continue;
				}
				$('#'+MRDIADr+'_editcls').linkbutton({text:'',iconCls: 'icon-add',plain:true});  
			}
			*/
			$('.editcls').linkbutton({text:'',iconCls: 'icon-add',plain:true});  
    	
        },onDblClickRow:function(rowIndex, rowData){
			//HisdiagnosObjDbclick(rowIndex);
		},onBeforeLoad:function(param){
			param.ClassName ='web.DHCDocDiagnosNew';
	        param.QueryName ='GetHistoryMRDiagnose';
	        param.Arg1 =PatientID;
	        param.Arg2 ="All";
	        param.Arg3 =session['LOGON.CTLOCID'];
	        param.ArgCnt =3;
		}

	});
	//LoadDiagnosHistoryDataGrid();
}
function LoadDiagnosHistoryDataGrid()
{
	if (typeof DiagnosHistoryDataGrid !="object") return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocDiagnosNew';
	queryParams.QueryName ='GetHistoryMRDiagnose';
	queryParams.Arg1 =PatientID;
	queryParams.Arg2 ="All";
	queryParams.Arg3 =session['LOGON.CTLOCID'];
	queryParams.ArgCnt =3;
	var opts = DiagnosHistoryDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	DiagnosHistoryDataGrid.datagrid('load', queryParams);
}
function HisdiagnosObjDbclick(DiagnosValue,DiagnosDesc) {
	//var row = DiagnosHistoryDataGrid.datagrid('getSelected');
	//var DiagnosValue=row.Rowid
	//如果历史诊断包含诊断注释或是非ICD诊断,赋值给诊断注释
	//var DiagnosDesc=row.MRDesc
	$('#DiagnosSearch').combogrid('setValue',DiagnosDesc);
	if(DiagnosValue==""){
		//插入非ICD诊断
		InsertMRDiagnos("")
	}else{
		//插入ICD诊断
		if(!CheckDiagIsEnabled(DiagnosValue)) return false;
		InsertMRDiagnos(DiagnosValue,"",DiagnosDesc)
	}
	return ;
	//alert(MRDIADr + "!!" + MRCICDRowid) //var
	//rtn = tkMakeServerCall("web.DHCDocDiagnosNew", "CopyFromHistMRDiagnos"
	var LogDepRowid = session['LOGON.CTLOCID'];
	var LogUserRowid = session['LOGON.USERID'];
	//var DiagnosType = $("#MRDiagType").combobox("getValue");
	var DiagnosType = OPMRDiagType
	var DiagnosStatus = $("#DiagnosStatus").val();
	if (DiagnosStatus == "QZ") {
	    DiagnosStatus = DiaD
	} else if (DiagnosStatus == "DZ") {
	    DiagnosStatus = DiaW
	} else {
	    DiagnosStatus = DiaH
	}
	var MRDiagnosRowid = cspRunServerMethod(CopyFromHistMRDiagMethod, LogDepRowid, LogUserRowid, DiagnosType, DiagnosStatus, MRDIADr,mradm);
	//alert(: "MRDiagnosRowid) if (MRDiagnosRowid != '') { LoadDiagnosListDataGrid();
	if (MRDiagnosRowid != '') {
		LoadDiagnosListDataGrid();
		//置患者达到状态
		UpdateArriveStatus();
		//页面数据初始化
		ReSetWindowData();
	}else{
		alert(MRDiagnosRowid+":失败")
	}
	var mainMRDiagnosRowid=MRDiagnosRowid.split("^")[0]
	CheckDiseaseNew(mainMRDiagnosRowid,EpisodeID,PatientID) //临床路径准入提示校验,提示是否入径
	ShowCPWNew(MRCICDRowid,mainMRDiagnosRowid,EpisodeID);
	$.messager.show({
		title:'消息',
		msg:'诊断插入成功',
		timeout:5000,
		showType:'slide'
	});
}


function DeleteMRDiagnos(MRDiagnosRowid) {
  var row = DiagnosListDataGrid.datagrid('getSelected');
  if (row!=null){
	  var MRDiagnosDesc=row.DiagnosDesc
	  var MRDiagnosNote=row.DiagnosMRDesc
	  if((MRDiagnosDesc=="")&&(MRDiagnosNote!="")){
		  MRDiagnosDesc=MRDiagnosNote
	  }
	  if((MRDiagnosDesc!="")&&(MRDiagnosNote!="")){
		  MRDiagnosDesc=MRDiagnosDesc+"("+MRDiagnosNote+")"
	  }else{
		  MRDiagnosDesc=MRDiagnosDesc
	  }
	   MRDiagnosDesc=MRDiagnosDesc.replace(/\&nbsp/g,"")
	  var DelMRDiagnosMessage = window.confirm('是否删除 ' + MRDiagnosDesc);
	  if (DelMRDiagnosMessage == false) {
	      return false;
	  };
  }
  var LogUserRowid = session['LOGON.USERID'];
  var LogDepRowid = session['LOGON.CTLOCID'];
  var ret = cspRunServerMethod(DeleteMRDiagnosMethod, MRDiagnosRowid,LogUserRowid,LogDepRowid);
  if (ret != '0') {
    if(ret=='Discharged'){
	  $.messager.alert("提示","由于病人已出院,诊断不能删除");
	  return false;
  	}else if(ret=='Timeout'){
	  $.messager.alert("提示","您不能删病人以前诊断");
	  return false;
  	}else if(ret=='NotSameLoc'){
	  $.messager.alert("提示","只能删除本科室医生开的诊断");
	  return false;
  	}else{
	  $.messager.alert("提示","删除失败");	
	  return false;
	}
  }else {
	  var row = DiagnosListDataGrid.datagrid('getSelected');
      var index = DiagnosListDataGrid.datagrid('getRowIndex', row);
	  if (index!="") {
		 DiagnosListDataGrid.datagrid('deleteRow',index);
	 }
	 //DiagnosListDataGrid.datagrid('deleteRow',DiagnosListSelectedRow);
	 LoadDiagnosListDataGrid();
	 LoadDiagnosHistoryDataGrid();
	 //SaveMRDiagnosToEMR()
  }

}
function InsertMRDiagnos(MRCICDRowid,SyndromeCICDRowid,Desc) {
	DiagnosListDataGrid.datagrid("unselectAll");
	if(parent.name=="TRAK_main"){
		parent.autoSaveEmrDoc()
	}
	if(!CheckIsAdmissions(EpisodeID)) return false;
	if (!CheckBeforeInsertMRDiag()) return false;
	var MRDIADesc=""
	if ((MRCICDRowid==null)||(MRCICDRowid=="")) {
		if(window.confirm("是否确定录入非标准ICD诊断?")){
			MRDIADesc = $('#DiagnosSearch').combogrid('getValue');
			MRDIADesc=MRDIADesc.replace(/[\\\@\#\$\%\^\&\*\(\)\{\}\:\"\<\>\?\[\]]/g,"");
			if ((MRDIADesc=="")) {
				$.messager.alert("提示","录入的非标准icd诊断注释不允许为空,请在诊断处输入诊断注释!","error");
				return false;
			}
	    }else{
			return false;
		}
	}
	
	if (typeof SyndromeCICDRowid =="undefined"){
		var SyndromeCICDRowid = $('#SyndromeSearch').combogrid('getValue');
	}
	if (typeof Desc !="undefined"){
		MRDIADesc = Desc;
	}
	
	var SyndromeDesc=""
	if (isNaN(SyndromeCICDRowid)){
		var SyndromeDesc=SyndromeCICDRowid
		SyndromeCICDRowid=""
	}
	if((!isNaN(MRCICDRowid))&&(MRCICDRowid!="")){
		 if (((MRCICDRowid!="")&&(MRCICDRowid!=null))&&(GetSeriousDiseaseByICDMethod!="")){
	       var SeriousDisease=cspRunServerMethod(GetSeriousDiseaseByICDMethod,MRCICDRowid);
	       //alert("SeriousDisease:"+SeriousDisease+","+MRCICDRowid)
	       if (SeriousDisease=="Y") $.messager.alert("提示","此诊断为传染病诊断,请注意及时上报.","info");
	     }
	     if (((SyndromeCICDRowid!="")&&(SyndromeCICDRowid!=null))&&(GetSeriousDiseaseByICDMethod!="")){
	       var SeriousDisease=cspRunServerMethod(GetSeriousDiseaseByICDMethod,SyndromeCICDRowid);
	       if (SeriousDisease=="Y") $.messager.alert("提示","此诊断为传染病诊断,请注意及时上报.","info");
	     }
	     //ICD诊断重复性判断
	     //var DiagnosTypeDr=$("#MRDiagType").combobox("getValue");
	     var DiagnosTypeDr=OPMRDiagType
	     var Str=MarchDiagnosis(MRCICDRowid,DiagnosTypeDr);
	     if (Str==1){
			var vaild = window.confirm("所加诊断在本次诊断中已经存在，请确认是否重复增加");
			if(!vaild) {return false;}
		 }
	     var Str=MarchDiagnosis(SyndromeCICDRowid,DiagnosTypeDr);
	     if (Str==1){
			var vaild = window.confirm("所加诊断在本次诊断中已经存在，请确认是否重复增加");
			if(!vaild) {return false;}
		 }
	}else{
		var FlagDiagnosNote=0;
	    var icd=""
		//MRDIADesc=MRCICDRowid
		MRCICDRowid=""
		if((MRDIADesc=="")){
			var vaild=$.messager.alert("提示","录入了为空的非标准icd诊断,!","error");
		    return false;
		}
		//加入对非标准icd诊断录入时候是否重复的判断
	    var ret = cspRunServerMethod(GetMRDiagnoseList, mradm, '');
	    if (ret != '') {
		  var retarry = ret.split(String.fromCharCode(1));
		  for (i = 0; i < retarry.length; i++) {
			var retItemArry = retarry[i].split('^');
			var id=retItemArry[1];
            var DiagnosICDCode = retItemArry[4];
            var DiagnosNote = retItemArry[6];
            if ((DiagnosICDCode=="")&&(DiagnosNote!="")&&(MRDIADesc!="")&&(mradm!=id)){
	             var Str1=trim(DiagnosNote);
				 var Str2=trim(MRDIADesc);
				 if((Str1==Str2)&&(Str1!="")&&(Str2!=""))  FlagDiagnosNote=1
				 if (icd!=""){
					 var FlagDiagnosNote=0
			     }
			     
	        }
		  }
	   }
		if(FlagDiagnosNote==1){
			if(!window.confirm('非标准icd诊断注释重复,是否确定添加?')){
				return ;
			}
		}
		
	}  
	var LogDepRowid = session['LOGON.CTLOCID'];
    var LogUserRowid = session['LOGON.USERID'];
    var MRADMID = mradm;
    //var DiagnosType=$("#MRDiagType").combobox("getText");
    var DiagnosType=OPMRDiagTypeDesc
    var DiagnosLevel=1;
    var DiagnosStatus=$("#DiagnosStatus").val();
    if(DiagnosStatus=="QZ"){
	    DiagnosStatus=DiaD
	}else if(DiagnosStatus=="DZ"){
		DiagnosStatus=DiaW
	}else{
		DiagnosStatus=DiaH
	}
	//var DiagnosCat=$("#DiagnosCat").val();
	var DiagnosCat=$('input:radio[name="DiagnosCat"]:checked').val()
	if (DiagnosCat==1){
		if (MRDIADesc!=""){
			MRDIADesc=MRDIADesc+"#2"
		}
		if ((SyndromeDesc=="")&&(SyndromeCICDRowid=="")) {
			//$.messager.alert("提示","症候不得为空","error");
			//return false
		}
		if (SyndromeDesc!=""){
			SyndromeDesc=SyndromeDesc+"#3"
		}	
	}else{
		if (MRDIADesc!=""){
			MRDIADesc=MRDIADesc+"#1"
		}
	}
	
	var ret = cspRunServerMethod(InsertMRDiagnosMethod, LogDepRowid, MRADMID, MRCICDRowid, LogUserRowid, MRDIADesc, DiagnosType,"","","","","",DiagnosStatus,DiagnosLevel,"","",SyndromeCICDRowid,SyndromeDesc);
	var SuccessFlag=ret.split('^')[0];
	if (SuccessFlag=='0') {
	//if (MRDiagnosRowid != '') {
		var MRDiagnosRowid=ret.split('^')[1];
		if (MRDiagnosRowid != '') {
			SelMRCICDRowid=""
			LoadDiagnosListDataGrid();
			LoadDiagnosHistoryDataGrid();
			//置患者达到状态
			UpdateArriveStatus();
		    //页面数据初始化
		    ReSetWindowData();
			//SaveMRDiagnosToEMR()
	}
	}else{
		var ErrorMsg=ret.split('^')[1];
		$.messager.alert("提示","插入诊断失败,"+ErrorMsg,"error");
		return false;
	}
	//插入诊断界面其他录入信息
	//InsertOtherInfo();
	 var mainMRDiagnosRowid=MRDiagnosRowid.split("^")[0]
	//CheckDisease(mainMRDiagnosRowid);
	CheckDiseaseNew(mainMRDiagnosRowid,EpisodeID,PatientID)
	//临床路径准入提示校验,提示是否入径
	ShowCPWNew(MRCICDRowid,mainMRDiagnosRowid,EpisodeID); 
	/*
	if (MRCICDRowid=="") return;
	var ClinicPathWayRowId = cspRunServerMethod(encmeth,MRCICDRowid);
	if (ClinicPathWayRowId!="") {
		var posn="height="+(screen.availHeight-400)+",width="+(screen.availWidth-200)+",top=200,left=100,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
		var path="websys.default.csp?WEBSYS.TCOMPONENT=UDHCOEOrder.CPW.Edit&CPWRowId="+ClinicPathWayRowId+"&EpisodeID="+EpisodeID;
		websys_createWindow(path,false,posn);
	}*/
	if(SuccessFlag=='0'){
		$.messager.show({
			title:'消息',
			msg:'诊断插入成功',
			timeout:5000,
			showType:'slide'
		});
   }

	
}
function UpdateArriveStatus() {
    var LogonUserID = session['LOGON.USERID']
    if (cspRunServerMethod(SetArrivedStatus, EpisodeID, DocID, session['LOGON.CTLOCID'], session['LOGON.USERID']) != '1') {}
}
function UpdateMrdiagNote(MRDiagnosNoteId, DiagnosNotechangevalue) {
	
	var FlagDiagnosNote=0;
	var icd=""
	//对产生变动的诊断查看是否是标准icd
	if(MRDiagnosNoteId!="") icd = cspRunServerMethod(FindMRDIAICDCodeDR,MRDiagnosNoteId);
	if ((icd=="")&&(DiagnosNotechangevalue=="")){
		var vaild=$.messager.alert("提示","录入了为空的非标准icd诊断,!","error");
		return ;
	}
	//加入对非标准icd诊断录入时候是否重复的判断
	var ret = cspRunServerMethod(GetMRDiagnoseList, mradm, '');
	if (ret != '') {
		var retarry = ret.split(String.fromCharCode(1));
		for (i = 0; i < retarry.length; i++) {
			var retItemArry = retarry[i].split('^');
			var id=retItemArry[1];
            var DiagnosICDCode = retItemArry[4];
            var DiagnosNote = retItemArry[6];
            if ((DiagnosICDCode=="")&&(DiagnosNote!="")&&(DiagnosNotechangevalue!="")&&(MRDiagnosNoteId!=id)){
	             var Str1=trim(DiagnosNote);
				 var Str2=trim(DiagnosNotechangevalue);
				 if((Str1==Str2)&&(Str1!="")&&(Str2!=""))  FlagDiagnosNote=1
				 if (icd!=""){
					 var FlagDiagnosNote=0
			     }
			     
	        }
		}
	}
	var Note = DiagnosNotechangevalue;
	if(FlagDiagnosNote==1){
		if(!window.confirm('非标准icd诊断注释重复,是否确定添加?')){
			return ;
		}
	}
	var ret = cspRunServerMethod(UpdateMRDiagnosNote, MRDiagnosNoteId, Note);
	if(ret==""){
	   //重新加载本次诊断数据
	   LoadDiagnosListDataGrid();
	   //SaveMRDiagnosToEMR()
	} 
}
function CheckBeforeInsertMRDiag()
{

	//var DiagnosType=$("#MRDiagType").combobox("getValue");
	var DiagnosType=OPMRDiagType
	if(DiagnosType==""){
		$.messager.alert("提示", "请选择诊断类型！", "error");
		return false;
	}
	var ret = cspRunServerMethod(InsuPatTypeCheck, EpisodeID);
	if (ret==1){
		var bln = window.confirm("请先核对是否是医保病人,谢谢!");
		if (bln==false){return;}   
	}
	var CheckAddret=cspRunServerMethod(CheckAdd,EpisodeID);
	if (CheckAddret!=""){
	   if(CheckAddret=='Discharged'){
		   $.messager.alert("提示","由于病人已出院,不能增加新诊断", "error");
	       return false;
	   }else if(CheckAddret=='Cancel'){
		   $.messager.alert("提示","由于病人已经退院，不能增加新诊断", "error");
	       return false;
  	   }
	}
	return true;
}

function trim(str)
{
	return str.replace(/[\t\n\r ]/g, "");
}

function ReSetWindowData()
{
	//诊断保存成功 诊断注释赋值为空
	$('#DiagnosSearch').combogrid('setValue','');
	$('#DiagnosSearch').combo("setText", '');
	$('#SyndromeSearch').combogrid("setValue",'')
	$('#SyndromeSearch').combo("setText", '');
	InitMRDiagType();
}



function ChangeDiagnosCatContrl()
{
	try{
		//var ICDType=$("#DiagnosCat").val();
		var ICDType=$('input:radio[name="DiagnosCat"]:checked').val()
		var tables = document.getElementsByName("SyndromeSearchtable")[0];
		if (ICDType=="0"){
			$('#SyndromeSearch').combogrid("setValue",'')
			$('#SyndromeSearch').combo("setText", '');
			tables.style.display = 'none'
			$('#SyndromeSearch').next(".combo").hide();
		}else{
			tables.style.display = ''
			$('#SyndromeSearch').next(".combo").show();
			$('#SyndromeSearch').combogrid("setValue",'')
			$('#SyndromeSearch').combo("setText", '');
		}
		$('#DiagnosSearch').combogrid("setValue",'')
		$('#DiagnosSearch').combo("setText", '');
	}catch(e){alert(e.message)}
	setTimeout(function() {
		$('#DiagnosSearch').next('span').find('input').focus();
		window.returnValue=false;
	},50)

	/*
	//alert(1)
	var obj=$('#DiagnosSearch')
	try{
		obj.parent().parents().parent().parent().focus();
		obj.parent().parents().parent().parent().select()
		//obj.focus();
		//obj.select()
	}catch(e){alert(e.message)}
	*/
	//
	//InitSyndromeComboGrid()
	//$('#SyndromeSearch').combogrid("unSelectOption");
	//$('#DiagnosSearch').combogrid("unSelectOption");
	/*
	var obj=document.getElementsByName("SyndromeSearch")
	var obj1=obj[0]
	var obj2=obj[1]
	var tables = document.getElementsByName("Butttable")[0];
	var tablesArr=tables.all
	var a=tables.toString()
	/*
	for (var i=0;i<tablesArr.length-1;i++) {
		var tablesAr1=tablesArr[i]
		//
		//alert(i)
		if (tablesAr1.outerHTML.indexOf("SyndromeSearch")!=-1){
			if (ICDType=="0"){
				//tablesAr1.style.display = 'none'
			}else{
				//tablesAr1.style.display = ''
			}
		}
	}
	
	var tablesAr1=tablesArr[29]
	tablesAr1.style.display = 'none'
	var trSyndromeSearch = tables.parentElement.parentElement;
	//alert(ICDType)
	if (ICDType=="0"){
		//obj1.isDisabled=true
		obj[0].style.display = 'none';
		obj[1].style.display = 'none';
		//obj.BackColor=Me.CackColor
		//$('#SyndromeSearch').combogrid({editable:true});
		$('#SyndromeSearch').combogrid("editable")=false
		//$("#SyndromeSearch").hide();
		//obj.style.imeMode = "disabled";
		//trSyndromeSearch.style.display = 'none';
	}else{
		//obj.style.display="";
		//$('#SyndromeSearch').combogrid("editable")=false
		//$('#SyndromeSearch').combogrid({editable:false});
		trSyndromeSearch.style.display = '';
	}

	*/

}

//返会诊断是否重复标识
function MarchDiagnosis(DiagnosValue,MRDiagnosTypeDr)
{
	
	if (typeof MRDiagnosTypeDr =="undefined"){
		MRDiagnosTypeDr=""
	}
	//alert("MRDiagnosTypeDr:"+MRDiagnosTypeDr)
	var Str=cspRunServerMethod(FlagMarchDiagnose,mradm,DiagnosValue,MRDiagnosTypeDr);
	return Str;
}
function AdjustMRDiagnosLevel(Row,Direction){
   //得到rows对象
    var rows = DiagnosListDataGrid.datagrid("getRows");
	var row = DiagnosListDataGrid.datagrid('getSelected');
    var index = DiagnosListDataGrid.datagrid('getRowIndex', row);
	var DiagnosDesc=rows[index].DiagnosDesc
    var Level=rows[index].DiagnosLeavel
    var Level=parseInt(+Level)+parseInt(Direction);
    var SpaceHTML="&nbsp"
    if(Direction==1){
	    rows[index].DiagnosDesc=SpaceHTML+DiagnosDesc
	}else{
		rows[index].DiagnosDesc=DiagnosDesc.replace('&nbsp', '');
	}
	if(Level<=1) Level=1
    // 对某个单元格赋值
    rows[index].DiagnosLeavel=Level   
    //  刷新该行, 只有刷新了才有效果
    DiagnosListDataGrid.datagrid('refreshRow', index);
	BSaveclickhandler();
    /*var DiagnosDesc=rows[DiagnosListSelectedRow].DiagnosDesc
    var Level=rows[DiagnosListSelectedRow].DiagnosLeavel
    var Level=parseInt(Level)+parseInt(Direction);
    var SpaceHTML="&nbsp"
    if(Direction==1){
	    rows[DiagnosListSelectedRow].DiagnosDesc=SpaceHTML+DiagnosDesc
	}else{
		rows[DiagnosListSelectedRow].DiagnosDesc=DiagnosDesc.replace('&nbsp', '');
	}
	if(Level<=1) Level=1
    // 对某个单元格赋值
    rows[DiagnosListSelectedRow].DiagnosLeavel=Level   
    //  刷新该行, 只有刷新了才有效果
    DiagnosListDataGrid.datagrid('refreshRow', DiagnosListSelectedRow);
	BSaveclickhandler();*/
}
function BSaveclickhandler()  {
	//得到rows对象
    var rows = DiagnosListDataGrid.datagrid("getRows"); 
    for (var i=0;i<rows.length;i++) {
	    var MRDiagnosRowId=rows[i].DiagnosValue
        var MRDiagnosLevel=rows[i].DiagnosLeavel
	    var MRDiagnosSequence=parseInt(i)+1;
	    var info=MRDiagnosLevel+"^"+MRDiagnosSequence
	    ret = cspRunServerMethod(UpdateMRDiagnosMethod, MRDiagnosRowId, info)
    }
    /*var MRDiagnosRowId=rows[DiagnosListSelectedRow].DiagnosValue
    var MRDiagnosLevel=rows[DiagnosListSelectedRow].DiagnosLeavel
	var MRDiagnosSequence=parseInt(DiagnosListSelectedRow)+1;
	var info=MRDiagnosLevel+"^"+MRDiagnosSequence
	ret = cspRunServerMethod(UpdateMRDiagnosMethod, MRDiagnosRowId, info)*/
}
function BMoveUpclickhandler()
{
	var row = DiagnosListDataGrid.datagrid('getSelected'); 
    var index = DiagnosListDataGrid.datagrid('getRowIndex', row);
    var MainMRDIADr=row.MRDIAMRDIADR
    if (MainMRDIADr!=""){
	    alert("请调整主诊断")
		return false   
	}
    
    
    mysort(index, 'up');
    BSaveclickhandler();
}
function BMoveDownclickhandler()
{
	var row = DiagnosListDataGrid.datagrid('getSelected');
    var index = DiagnosListDataGrid.datagrid('getRowIndex', row);
    var MainMRDIADr=row.MRDIAMRDIADR
    if (MainMRDIADr!=""){
	    alert("请调整主诊断")
		return false   
	}
    mysort(index, 'down');
    BSaveclickhandler();
}
function mysort(index, type) {

    if ("up" == type) {
        if (index != 0) {
			///存在关联医嘱的问题，上下移动时判断关联诊断
			var toupLinkDiaList=GetLinkDiaNum(index)
			var todownLinkDiaList=GetLinkDiaNum(index - 1)
			var toupLinkDiaNum=toupLinkDiaList.split("^").length
			var todownLinkDiaNum=todownLinkDiaList.split("^").length
			var StartIndex=index-todownLinkDiaNum
			var CopyRows=new Array(toupLinkDiaNum+todownLinkDiaNum)
			for (var i=0;i<CopyRows.length;i++) {
				if (i<toupLinkDiaNum){
					CopyRows[i]=DiagnosListDataGrid.datagrid('getData').rows[index+i]
				}else{
					CopyRows[i]=DiagnosListDataGrid.datagrid('getData').rows[StartIndex+i-toupLinkDiaNum]
				}
				
			}
			for (var i=0;i<CopyRows.length;i++) {
				DiagnosListDataGrid.datagrid('getData').rows[StartIndex+i]=CopyRows[i]
				DiagnosListDataGrid.datagrid('refreshRow', StartIndex+i)
				
			}
			DiagnosListDataGrid.datagrid('selectRow', StartIndex);
			/*
            var toup = DiagnosListDataGrid.datagrid('getData').rows[index];
            var todown = DiagnosListDataGrid.datagrid('getData').rows[index - 1];
            DiagnosListDataGrid.datagrid('getData').rows[index] = todown;
            DiagnosListDataGrid.datagrid('getData').rows[index - 1] = toup;
            DiagnosListDataGrid.datagrid('refreshRow', index);
            DiagnosListDataGrid.datagrid('refreshRow', index - 1);
            DiagnosListDataGrid.datagrid('selectRow', index - 1);
            */
        }
    } else if ("down" == type) {
        var rows = DiagnosListDataGrid.datagrid('getRows').length;
        if (index != rows - 1) {
	        ///存在关联医嘱的问题，上下移动时判断关联诊断
	        //debugger
			var todownLinkDiaList=GetLinkDiaNum(index)
			var todownLinkDiaNum=todownLinkDiaList.split("^").length
			var toupLinkDiaList=GetLinkDiaNum(index + todownLinkDiaNum)
			
			var toupLinkDiaNum=toupLinkDiaList.split("^").length
			var StartIndex=index
			var CopyRows=new Array(toupLinkDiaNum+todownLinkDiaNum)
			for (var i=0;i<CopyRows.length;i++) {
				if (i<toupLinkDiaNum){
					CopyRows[i]=DiagnosListDataGrid.datagrid('getData').rows[StartIndex+todownLinkDiaNum+i]
				}else{
					CopyRows[i]=DiagnosListDataGrid.datagrid('getData').rows[StartIndex+i-toupLinkDiaNum]
				}
				
			}
			for (var i=0;i<CopyRows.length;i++) {
				DiagnosListDataGrid.datagrid('getData').rows[StartIndex+i]=CopyRows[i]
				DiagnosListDataGrid.datagrid('refreshRow', StartIndex+i)
				
			}
			DiagnosListDataGrid.datagrid('selectRow', StartIndex+toupLinkDiaNum);
	        
	        
	        /*
            var todown = DiagnosListDataGrid.datagrid('getData').rows[index];
            var toup = DiagnosListDataGrid.datagrid('getData').rows[index + 1];
            DiagnosListDataGrid.datagrid('getData').rows[index + 1] = todown;
            DiagnosListDataGrid.datagrid('getData').rows[index] = toup;
            DiagnosListDataGrid.datagrid('refreshRow', index);
            DiagnosListDataGrid.datagrid('refreshRow', index + 1);
            DiagnosListDataGrid.datagrid('selectRow', index + 1);
            */
        }
    }
}

function DiagNextFocus(){
	var tables = document.getElementsByName("SyndromeSearchtable")[0];
	if (tables.style.display == 'none'){
		//alert(1)
		//websys_setfocus("BSaveDiagnos");
		$('#BSaveDiagnos').focus()
		//debugger;
		//$('#BSaveDiagnos').find('span').find('span').focus()
	}else{
		//setTimeout($('#SyndromeSearch').next('span').find('input').focus(),50)
		setTimeout(function() {
			$('#SyndromeSearch').next('span').find('input').focus();
			window.returnValue=false;
		},50)
	}
}

function ButtonFoces(){
	//websys_setfocus("BSaveDiagnos");
	$('#BSaveDiagnos').focus()
}
function AddPreAdmDiagnos()
{
	//判断本次就诊是否存在诊断
	var AdmIsExistDiagFlag = cspRunServerMethod(GetAdmIsExistDiag,mradm)
	if(+AdmIsExistDiagFlag!="0") return false;
	if(PreMRAdm!=""){
		var PreAdmIsExistDiagFlag = cspRunServerMethod(GetAdmIsExistDiag,PreMRAdm)
		if(+PreAdmIsExistDiagFlag!="0"){
			if (confirm("是否引用上次门诊就诊诊断?")){
				$("#dialog-MRDiagnosSelect").css("display", ""); 
	             dialog = $( "#dialog-MRDiagnosSelect" ).dialog({
                   autoOpen: false,
                   height: 300,
                   width: 400,
                   modal: true
                  });    
	             dialog.dialog("open");	
			     LoadPreAdmDianosList(PreMRAdm);
			}
		    
		}
	}
}


function LoadPreAdmDianosList(PreMRAdm)
{
	
	var PreAdmDiagnosListBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { 
               var rows = tabPreAdmDiagnosListDataGrid.datagrid('getSelections');
               var ids = [];
               for (var i = 0; i < rows.length; i++) {
	               ids.push(rows[i].DiagnosValue);
	           }
	           var ID=ids.join(',')
	           if(ID==""){
		           $.messager.alert("提示","请选择需要添加的诊断","error");
		           return false;
		       }
		       var LogDepRowid = session['LOGON.CTLOCID'];
               var LogUserRowid = session['LOGON.USERID'];
               var MRADMID = mradm;
		       var rtn=cspRunServerMethod(InsertPreMRDiagnosMethod,ID,MRADMID,LogDepRowid,LogUserRowid)
		       if(rtn!=""){
                   dialog.dialog( "close" );
                   LoadDiagnosListDataGrid();
		           LoadDiagnosHistoryDataGrid();
		           //置患者达到状态
		           UpdateArriveStatus();
		           for(var i=0;i<rtn.split("^").length;i++){
			           var mainMRDiagnosRowid=rtn.split("^")[i]
					   if(+mainMRDiagnosRowid=="0") continue;
	                   CheckDiseaseNew(mainMRDiagnosRowid,EpisodeID,PatientID) //临床路径准入提示校验,提示是否入径
	                   //ShowCPWNew(MRCICDRowid,mainMRDiagnosRowid,EpisodeID);
	                   //$.messager.show({title:"提示",msg:"诊断添加成功"});
			       }
			   }
	           //alert(ID.split(",").length)
            }
        }];
	var PreAdmDiagnosListColumns=[[
	                { field: 'ck' ,checkbox: true }, 
	                { field: 'DiagnosValue', title: '', width: 1,align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'DiagnosCodeRowid', title:'', width: 1,align: 'center', sortable: true,hidden:true
					},
        			{ field: 'DiagnosType', title: '类型', width: 60, align: 'center', sortable: true,hidden:true
					},
					{ field: 'DiagnosCat', title: '分类', width:30, align: 'left', sortable: true, resizable: true
					},
					{ field: 'DiagnosDesc', title: 'ICD描述', width: 250, align: 'left', sortable: true, resizable: true
					},
					{ field: 'DiagnosMRDesc', title: '诊断注释', width: 100, align: 'left', sortable: true, resizable: true
					},
					{ field: 'DiagnosICDCode', title: 'ICD代码', width: 70, align: 'center', sortable: true, resizable: true
					},
					{ field: 'DiagStat', title: '状态', width: 30, align: 'center', sortable: true, resizable: true
					},
					{ field: 'DiagnosDate', title: '诊断日期', width: 80, align: 'center', sortable: true, resizable: true,hidden:true
					},
					{ field: 'DiagnosOnsetDate', title: '发病日期', width: 80, align: 'center', sortable: true, resizable: true,hidden:true
					},
					{ field: 'DiagnosLeavel', title: '级别', width: 55, align: 'center', sortable: true, resizable: true
					},
					{ field: 'MRDIAMRDIADR', title: '症候对应的诊断', width: 55, align: 'center', sortable: true, resizable: true,hidden:true
					}
					
    			 ]];
	tabPreAdmDiagnosListDataGrid=$("#tabPreAdmDiagnosList").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		//selectOnCheck:  true , 
		checkOnSelect:  true ,		
		fitColumns : false,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : false,  //
		rownumbers : true,  //
		idField:"DiagnosValue",
		//pageList : [15,50,100,200],
		columns :PreAdmDiagnosListColumns,
		toolbar:PreAdmDiagnosListBar,
		onCheck : function(rowIndex, rowData) {
			if (LoadPreAdmDianosListVoerFlag==0){
				return
			}
			if((rowData.DiagnosCat!="西医")){
				var OrdList=$('#tabPreAdmDiagnosList').datagrid('getData')
				for (var i=0;i<OrdList.rows.length;i++) {
					var myMRDIAMRDIADR=OrdList.rows[i].MRDIAMRDIADR
					var myDiagnosValue=OrdList.rows[i].DiagnosValue
					if (rowIndex==i) {continue}
					
					if (((myMRDIAMRDIADR==rowData.DiagnosValue)||(myDiagnosValue==rowData.MRDIAMRDIADR))){
						///先判断是否已经选中
						debugger
						var FindCheckAlready=0
						var Checked=$('#tabPreAdmDiagnosList').datagrid('getChecked')
						for (var k=0;k<Checked.length;k++) {
							var TmpDiagnosValue=Checked[k].DiagnosValue
							if (TmpDiagnosValue==myDiagnosValue){
								FindCheckAlready=1
							}
						}
						if (FindCheckAlready==1){continue}
					
						$('#tabPreAdmDiagnosList').datagrid('checkRow',i)
					}
				}
				
			}
		},
		onUncheck:function(rowIndex, rowData){
			if (LoadPreAdmDianosListVoerFlag==0){
				return
			}
			if((rowData.DiagnosCat!="西医")){
				var OrdList=$('#tabPreAdmDiagnosList').datagrid('getData')
				for (var i=0;i<OrdList.rows.length;i++) {
					var myMRDIAMRDIADR=OrdList.rows[i].MRDIAMRDIADR
					var myDiagnosValue=OrdList.rows[i].DiagnosValue
					if (rowIndex==i) {continue}
					
					if (((myMRDIAMRDIADR==rowData.DiagnosValue)||(myDiagnosValue==rowData.MRDIAMRDIADR))){
						///先判断是否已经选中
						debugger
						var FindCheckAlready=1
						var Checked=$('#tabPreAdmDiagnosList').datagrid('getChecked')
						for (var k=0;k<Checked.length;k++) {
							var TmpDiagnosValue=Checked[k].DiagnosValue
							if (TmpDiagnosValue==myDiagnosValue){
								FindCheckAlready=0
							}
						}
						if (FindCheckAlready==1){continue}
					
						$('#tabPreAdmDiagnosList').datagrid('uncheckRow',i)
					}
				}
				
			}
		},
		onLoadSuccess:function(data){  
		  var Length=data.rows.length
		  for (var i=0;i<Length;i++) {
			 $('#tabPreAdmDiagnosList').datagrid('checkRow',i)
		  }
		  LoadPreAdmDianosListVoerFlag=1
		},onBeforeLoad:function(param){
	       param.ClassName ='web.DHCMRDiagnosNew';
	       param.QueryName ='DiagnosList';
	       param.Arg1 =PreMRAdm;
	       param.Arg2 ="All";
	       param.Arg3 ="";
	       param.Arg4 =session['LOGON.CTLOCID'];
	       param.ArgCnt =4;
	   }
	});
}
function isChecked(row){    
   //参数为你要判断的行
    var allRows=tabPreAdmDiagnosListDataGrid.datagrid('getChecked');
    //获取所有被选中的行
    $.each(allRows,function(k,n){
	    //alert(row.DiagnosValue+","+n.DiagnosValue)
       if(row.DiagnosValue==n.DiagnosValue){    //id为一个列的属性，任意列都可以
         //alert(row.DiagnosValue+","+n.DiagnosValue)
          return true;
       }
     })
    return false;
 }
 
function UpdateMrdiagNCDInfo(MRDiagnosId, NCDCode){
	var ret=cspRunServerMethod(UpdateNCDCodeMethod,MRDiagnosId, NCDCode)
	return
}
 
function InitTemplate(){
	InitPrivateTemplate()
	InitLocTemplate()
	
	
}

function InitLocTemplate(){
	////科室模板
	var CTLOCID = session['LOGON.CTLOCID'];
  	var LocList= cspRunServerMethod(GetLocTemplateListMethod, CTLOCID)
	var LocListIndexNum = LocList.split(String.fromCharCode(2))[1];
	LocListStrArr = LocList.split(String.fromCharCode(2))[0].split(String.fromCharCode(1));
	for (var i=0;i<LocListIndexNum;i++) {
		$('#LocTemplate').tabs('add',{
			title:LocListStrArr[i].split("^")[1],
			closable:false,
			selected: true,
			width : 550,
			onSelect: function(title,index){
				var CurrentTabPanel=$('#LocTemplate').getTab(index);
				CurrentTabPanel.panel('open')
			}
		});
	}
	$('#LocTemplate').tabs({
		onSelect: function(title,index){
			var LocRowID=LocListStrArr[index].split("^")[0]
			var CurrentTabPanel=$('#LocTemplate').tabs("getSelected");
			var Length=CurrentTabPanel.length
			if (Length>0){
				if (typeof CurrentTabPanel[Length-1].innerHTML!="undefined" && CurrentTabPanel[Length-1].innerHTML!=""){
					return
				}
			}
			_content = '<iframe id="TemplateTable_' + LocRowID + '" name="TemplateTable_' + LocRowID +'" src="dianostemplate.show.csp?TemplateRowID=' + LocRowID + '" style="width:100%;height:100%;" frameborder="0" scrolling="Yes"></iframe>'
			CurrentTabPanel.html(_content);
			
		}
	});
	
}

function InitPrivateTemplate(){
	
  ////个人模板
  var USERID = session['LOGON.USERID'];
  var PrivateList= cspRunServerMethod(GetUserTemplateListMethod, USERID)
  var PrivateIndexNum = PrivateList.split(String.fromCharCode(2))[1];
  PrivateListStrArr = PrivateList.split(String.fromCharCode(2))[0].split(String.fromCharCode(1));
  for (var i=0;i<PrivateIndexNum;i++) {
		//var TabsTableHTML=GetTabsHTML(ListStrArr[i].split("^")[0])
		$('#PrivateTemplate').tabs('add',{
			title:PrivateListStrArr[i].split("^")[1],
			closable:false,
			selected: false,
			width : 550,
			onSelect: function(title,index){
				//alert("Select:"+title+"|"+index)
				var CurrentTabPanel=$('#PrivateTemplate').getTab(index);
				CurrentTabPanel.panel('open')
			}
		});
	}
	
	$('#PrivateTemplate').tabs({
		onSelect: function(title,index){
			var PrivateRowID=PrivateListStrArr[index].split("^")[0]
			var CurrentTabPanel=$('#PrivateTemplate').tabs("getSelected");
			var Length=CurrentTabPanel.length
			if (Length>0){
				if (typeof CurrentTabPanel[Length-1].innerHTML!="undefined" && CurrentTabPanel[Length-1].innerHTML!=""){
					return
				}
			}
			_content = '<iframe id="TemplateTable_' + PrivateRowID + '" name="TemplateTable_' + PrivateRowID +'" src="dianostemplate.show.csp?TemplateRowID=' + PrivateRowID + '" style="width:100%;height:100%;" frameborder="0" scrolling="Yes"></iframe>'
			CurrentTabPanel.html(_content);
		}
	}); 

}


function TemplateTableDBClick(ICDStr,value){
	var ICDStr=ICDStr+""
	var ICDStrArr=ICDStr.split("*")
	var MRCICDRowid=ICDStrArr[0];
	var SyndromeCICDRowid=""
	if(value!="") {
		$('#DiagnosSearch').combogrid('setValue',value);
	}
	if (ICDStrArr.length>1){
		var SyndromeCICDRowid=ICDStrArr[1];
	}
	
	if (typeof SyndromeCICDRowid=="undefined"){
		SyndromeCICDRowid=""
	}
	if(!CheckDiagIsEnabled(MRCICDRowid)) return false;
	InsertMRDiagnos(MRCICDRowid,SyndromeCICDRowid);
}
function MydiagnosEditshow() {
	var url = "websys.default.csp?WEBSYS.TCOMPONENT=DHCMRDiagnosEdit";
	//websys_createWindow(url, true, "status=1,scrollbars=1,top=0,left=0,width=1200,height=700");
	window.open(url, "", "status=1,scrollbars=1,top=0,left=0,width=1200,height=700");
}
//判断是否可以接诊
function CheckIsAdmissions(EpisodeID) {
	if (EpisodeID=="") return false;
	var UserID=session['LOGON.USERID'];
	//var ret=tkMakeServerCall("web.DHCDocOutPatientList","CheckIsAdmissions",EpisodeID,UserID);
	var ret=cspRunServerMethod(CheckIsAdmissionsMethod,EpisodeID,UserID)
	if (ret!="") {
		$.messager.alert("提示","接诊失败,"+ret,"error");
		return false;
	}
	return true;
}
function GetLinkDiaNum(index){
	var RowList=""
	var rows = DiagnosListDataGrid.datagrid("getRows"); 
	var MainMRDIADr=DiagnosListDataGrid.datagrid('getData').rows[index].MRDIAMRDIADR;
	var DiagnosValue=DiagnosListDataGrid.datagrid('getData').rows[index].DiagnosValue;
		
    for (var i=0;i<rows.length;i++) {
	    var TmpRowID=rows[i].DiagnosValue
        var TmpMain=rows[i].MRDIAMRDIADR
        if (index==i){
        	//continue
        }
        if ((MainMRDIADr=="")&&(DiagnosValue==TmpMain)||
        	((MainMRDIADr!="")&&((TmpMain!="")&&(TmpMain=MainMRDIADr)||(MainMRDIADr==TmpRowID))||
        	(DiagnosValue==TmpRowID))
        ){
	    	if (RowList==""){
		    	RowList=i+""
		    }else{
				RowList=RowList+"^"+i
			}   
	    }
    }
    RowList=RowList
	return RowList
}


function xhrRefresh(obj){
	//alert(123)
	try{
		var xhrPatientID=obj.papmi;
		var xhradm=obj.adm;
		var xhrmradm=obj.mradm;
		///alert(xhrPatientID+"^"+xhradm+"^"+xhrmradm)
		EpisodeID=xhradm;
		
		var RefData=cspRunServerMethod(RefreshMRDataMethod,EpisodeID);
		var RefDataArr=RefData.split(String.fromCharCode(1));
		
		EpisodeType=RefDataArr[0];
		mradm=RefDataArr[1];
		PatientID=RefDataArr[2];
		FirstAdm=RefDataArr[3];
		ReAdmis=RefDataArr[4];
		
		OutReAdm=RefDataArr[5];
		TransAdm=RefDataArr[6];
		ILIFlag=RefDataArr[7];
		BPSystolic=RefDataArr[8];
		BPDiastolic=RefDataArr[9];
		
		INDiag=RefDataArr[10];
		PreMRAdm=RefDataArr[11];
		
		LoadDiagnosListDataGrid();
		if (dialog && typeof dialog.dialog !="undefined"){
			dialog.dialog( "close" );
		}
		//引用上次门诊就诊诊断
		AddPreAdmDiagnos();
	
		var DiagnosHistoryPanel=$('#dataTabs').tabs("getTab","历史诊断");
		if (document.getElementById("tabDiagnosHistory")){
			InitDiagnosHistoryList();
		}
		
	}catch(e){
		alert("切换诊断异常，请重新切换病人！！！")
	}
	return
}
///保存诊断到电子病历
function SaveMRDiagnosToEMR(){
	var ret=tkMakeServerCall("web.DHCDocDiagnosNew","GetMRDiagnosToEMR",EpisodeID) 
	//parent.updateEMRInstanceData("diag",ret)
	if (typeof(parent.invokeChartFun) === 'function') {
	    parent.invokeChartFun('门诊病历', 'updateEMRInstanceData', "diag", ret);
    }

}
//判断所录入诊断是否有效
function CheckDiagIsEnabled(MRCICDRowid){
	if(MRCICDRowid=="") return true;
	var ret=tkMakeServerCall("web.DHCMRDiagnos","CheckICDIsEnabled",MRCICDRowid,EpisodeID) 
	if(ret!=""){
		$.messager.alert("提示",ret,"error");
		SelMRCICDRowid="";
		$('#DiagnosSearch').combogrid('setValue','');
		$('#DiagnosSearch').combo("setText", '');
		$('#SyndromeSearch').combogrid("setValue",'')
		$('#SyndromeSearch').combo("setText", '');
		return false;
	}
	return true;
}