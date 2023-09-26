	//定义全局变量
	var FreqDataGrid; //定义全局变量datagrid
    var editRow = undefined; //定义全局变量：当前编辑的行
    var OPDispensingTimeDataGrid;
    var editRow2 =undefined;
    //按/不按星期为单位标志
	var WeekFlag="";
	//不按分发时间推后执行
	var NotDeferFlag="";
	var SelectedRow=""
$(function(){
	///频次列表columns
    FreqColumns=[[    
                    { field: 'FreqRowId', title: '用法ID', width: 1, align: 'center', sortable: true, resizable: true,hidden:true},
        			{ field: 'FreqCode', title: '代码', width: 50, align: 'center', sortable: true, resizable: true},
					{ field: 'FreqFactor', title: '要素', width: 30, align: 'center', sortable: true, resizable: true},
					{ field: 'FreqDays', title: '间隔天数', width: 40, align: 'center', sortable: true, resizable: true},
					{ field: 'FreqDesc1', title: '本地语言描述', width: 100, align: 'center', sortable: true, resizable: true},
					{ field: 'FreqDesc2', title: '外语描述', width: 80, align: 'center', sortable: true, resizable: true},
					{ field: 'WeekFlag', title: '星期', width: 20, align: 'center', sortable: true, resizable: true,
					   editor : {
                                type : 'text',
                                options : {}
                     }},
					{ field: 'EveryDayFlag',title: '不推后执行', width: 80, align: 'center', sortable: true, resizable: true,
					   editor : {
                                type : 'text',
                                options : {}
                       }
					}
    			 ]];
     // 频次列表Grid
	FreqDataGrid=$('#tabFreqList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"FreqRowId",
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :FreqColumns,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){ 
		},
		onClickRow:function(rowIndex, rowData){
			FreqDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=FreqDataGrid.datagrid('getRows'); 
			var FreqRowId=selected[rowIndex].FreqRowId;
			loadOPDispensingTimeDataGrid(FreqRowId)
		}
	});
    loadFreqDataGrid(); 
	var FreqOPDispensingTimeToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
                if (editRow2 != undefined) {
	                editRow2 = undefined;
	                OPDispensingTimeDataGrid.datagrid("rejectChanges");
	                OPDispensingTimeDataGrid.datagrid("unselectAll");
                }
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    OPDispensingTimeDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //将新插入的那一行开户编辑状态
                    OPDispensingTimeDataGrid.datagrid("beginEdit", 0);
                    //给当前编辑的行赋值
                    editRow2 = 0;
              
            }
        },
        '-', {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
                //删除时先获取选择行
                var rows = OPDispensingTimeDataGrid.datagrid("getSelections");
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].rowid);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            var ID=ids.join(',')
                            $.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.FreqOPDispensingTime","DeleteTime","false",function testget(value){
						        if(value=="0"){
							       OPDispensingTimeDataGrid.datagrid('load');
           					       OPDispensingTimeDataGrid.datagrid('unselectAll');
           					       $.messager.show({title:"提示",msg:"删除成功"});
						        }else{
							       $.messager.alert('提示',"删除失败:"+value);
						        }
						        editRow2 = undefined;
						   },"","",ID);
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
	         
            }
        },
        '-', {
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
                //保存时结束当前编辑的行，自动触发onAfterEdit事件如果要与后台交互可将数据通过Ajax提交后台
              var rows = FreqDataGrid.datagrid("getSelections"); 
               if (rows.length > 0)
               { 
               				var ids = [];
							var Factors=[];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].FreqRowId);
								Factors.push(rows[i].FreqFactor);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            var FreqRowId=ids.join(',')
							var Factor=Factors.join(',')
                if (editRow2 != undefined)
                {
                	var editors = OPDispensingTimeDataGrid.datagrid('getEditors', editRow2);
                    var IsCanSave = CheckData(FreqRowId,Factor);	
                    if (IsCanSave == false)	{
						return false;
					}		
					var weekId =  editors[1].target.combobox('getValue');
					var Time =  editors[0].target.val();
					var rowid=""
					if (OPDispensingTimeDataGrid.datagrid('getSelected')) rowid=OPDispensingTimeDataGrid.datagrid('getSelected').rowid
                	$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.FreqOPDispensingTime","insertTime","false",function testget(value){
						if(value=="0"){
							OPDispensingTimeDataGrid.datagrid("endEdit", editRow2);
                			editRow2 = undefined;
							OPDispensingTimeDataGrid.datagrid('load');
           					OPDispensingTimeDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"提示",msg:"保存成功"});	           					
						}else{
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
						editRow2 = undefined;
						},"","",rowid,FreqRowId,Time,weekId);
            	}
            
             }else{
	            $.messager.alert("提示", "请选择一个要维护的频次", "error"); 
	         }
            }
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow2 = undefined;
                OPDispensingTimeDataGrid.datagrid("rejectChanges");
                OPDispensingTimeDataGrid.datagrid("unselectAll");
            }
        },'-',{
			text: '按/不按星期为单位',
			iconCls: 'icon-update-custom',
			handler: function() {
				/*if(WeekFlag==""){
					WeekFlag=1
				}else{
					WeekFlag=""
				}*/
				var rows = FreqDataGrid.datagrid("getSelections"); 
                if (rows.length > 0)
                { 
			        var ids = [];
                    for (var i = 0; i < rows.length; i++) {
                        ids.push(rows[i].FreqRowId);
                        var selWeekFlag=rows[i].WeekFlag;
                    }
                    //将选择到的行存入数组并用,分隔转换成字符串，
                    var FreqRowId=ids.join(',');
                    if (selWeekFlag=="Y"){
	                    WeekFlag="";
	                }else{
		                WeekFlag=1;
		            }
                    //alert(FreqRowId)
				    $.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.FreqOPDispensingTime","updateweekflag","false",function testget(value){
						if(value=="1"){
							FreqDataGrid.datagrid("selectRow",SelectedRow)
							var Flag=""
							if (WeekFlag==1) Flag="Y"
							FreqDataGrid.datagrid("beginEdit", SelectedRow);
							FreqDataGrid.datagrid('getEditor', { index: SelectedRow, field: 'WeekFlag' }).target.val(Flag);
							FreqDataGrid.datagrid("endEdit", SelectedRow);
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}else{
							if(value=="2"){
								$.messager.alert('提示',"存在维护了星期的记录,不能设置成不按星期为单位!");
							     return false;
							}
							if(value=="3"){
								$.messager.alert('提示',"存在维护了不按星期的记录,不能设置成按星期为单位!");
							     return false;
							}else{
							  $.messager.alert('提示',"保存失败:"+value);
							}
							return false;
						}
					},"","",FreqRowId,WeekFlag);
			    }
			}
		},'-',{
			text: '不按分发时间推后执行',
			iconCls: 'icon-update-custom',
			handler: function() {
				if(NotDeferFlag==""){
					NotDeferFlag=1
				}else{
					NotDeferFlag=""
				}
				var rows = FreqDataGrid.datagrid("getSelections"); 
                if (rows.length > 0)
                { 
			        var ids = [];
                    for (var i = 0; i < rows.length; i++) {
                        ids.push(rows[i].FreqRowId);
                    }
                    //将选择到的行存入数组并用,分隔转换成字符串，
                    var FreqRowId=ids.join(',');
                    //alert(FreqRowId)
				    $.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.FreqOPDispensingTime","updateNotDeferFlag","false",function testget(value){
						if(value=="1"){
							FreqDataGrid.datagrid("selectRow",SelectedRow)
							var Flag=""
							if (NotDeferFlag==1) Flag="Y"
							FreqDataGrid.datagrid("beginEdit", SelectedRow);
							FreqDataGrid.datagrid('getEditor', { index: SelectedRow, field: 'EveryDayFlag' }).target.val(Flag);
							FreqDataGrid.datagrid("endEdit", SelectedRow);
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}
					},"","",FreqRowId,NotDeferFlag);
			    }
			}
		}];
    ///分发时间列表columns
    OPDispensingTimeColumns=[[    
                    { field: 'rowid', title: 'ID', width: 1, align: 'center', sortable: true, resizable: true,hidden:true},
        			{ field: 'time', title: '分发时间', width: 50, align: 'center', sortable: true, resizable: true,
					   editor: {
						   type: 'text',
						   options:{}  
					   }
					},
					{ field: 'weekrowid', title: '星期', width: 20, align: 'center', sortable: true, resizable: true,
						editor: {
						   type: 'combobox',
						   options:{
							   url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
							   valueField:'weekId',
							   textField:'weekDesc',
							   //required:true,
							   onBeforeLoad:function(param){
								   param.ClassName = "DHCDoc.DHCDocConfig.FreqOPDispensingTime";
								   param.QueryName = "FindWeekList";
								   param.ArgCnt = 0;
							   },
								onSelect:function(rec){
							   }
						   }
					   },
					   formatter: function(value,row,index){
						   return row.week
					   }
					},
					{ field: 'week', title: '星期', width: 50, align: 'center', sortable: true, resizable: true,hidden:true
					   
					}
    			 ]];
     // 分发时间列表Grid
	OPDispensingTimeDataGrid=$('#tabOPDispensingTimeList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"rowid",
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :OPDispensingTimeColumns,
		toolbar :FreqOPDispensingTimeToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){ 
		},
		onClickRow:function(rowIndex, rowData){
			/*OPDispensingTimeDataGrid.datagrid('selectRow',rowIndex);
			var selected=OPDispensingTimeDataGrid.datagrid('getRows'); 
			var FreqRowId=selected[rowIndex].FreqRowId;*/
		},onDblClickRow : function (rowIndex, rowData) {
			if (editRow2 != undefined){
				OPDispensingTimeDataGrid.datagrid("rejectChanges");
	            OPDispensingTimeDataGrid.datagrid("unselectAll");
			}
			OPDispensingTimeDataGrid.datagrid('selectRow',rowIndex);
			//var rowid_ed=OPDispensingTimeDataGrid.datagrid('getSelected').rowid
			//if(rowid_ed != ""){
				OPDispensingTimeDataGrid.datagrid('beginEdit', rowIndex); //endEdit
				editRow2=rowIndex;	
			//}
		}
	});	
})
function loadFreqDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.FreqOPDispensingTime';
	queryParams.QueryName ='FindFreq';
	queryParams.ArgCnt =0;
	var opts = FreqDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	FreqDataGrid.datagrid('load', queryParams);
}
function loadOPDispensingTimeDataGrid(value)
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.FreqOPDispensingTime';
	queryParams.QueryName ='FindOPDispensingTime';
	queryParams.Arg1 =value;
	queryParams.ArgCnt =1;
	var opts = OPDispensingTimeDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	OPDispensingTimeDataGrid.datagrid('load', queryParams);
}
function CheckData(FreqRowId,Factor) {
  var editors = OPDispensingTimeDataGrid.datagrid('getEditors', editRow2);
  var data = OPDispensingTimeDataGrid.datagrid('getData'); //data.total data.rows.length
  if(data.total>Factor){
	  $.messager.alert('提示',"不能超过设定的分发时间纪录数量限制");
	  return false;
  }
  var weekId =  editors[1].target.combobox('getValue');
  var SelWeekFlag=FreqDataGrid.datagrid('getSelected').WeekFlag
  if ((weekId!="")&&(SelWeekFlag!="Y")){
		$.messager.alert('提示',"不按星期为单位,不能选择星期");
		return false;
  }else if((weekId=="")&&(SelWeekFlag=="Y")){
		$.messager.alert('提示',"按星期为单位,星期不能为空");
		return false;
  }
	var Time =  editors[0].target.val();
	var timeCount=Time.split(":").length
	if ((timeCount<=1)||(timeCount>3)){
		$.messager.alert('提示',"请输入正确的时间 例如:13:00");	
		return false;
	}else if(timeCount==2){
		var re = /^(?:[01]\d|2[0-3])(?::[0-5]\d)$/;
	}else{
		var re = /^(?:[01]\d|2[0-3])(?::[0-5]\d){2}$/;
	}
	var result = re.test(Time);
	if(result==false){
		$.messager.alert('提示',"请输入正确的时间 例如:13:00");
		return false;
	}
	$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.FreqOPDispensingTime","find","false",function testget(value){
			if(value=="0"){
				$.messager.alert('提示',"不能增加，该记录已存在!");
				return false;  					
			}
	},"","",FreqRowId,Time,weekId);
	return true;
}