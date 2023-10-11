var PageLogicObj={
	m_ExaBoroughTabDataGrid:"",
	ExaBoroughID:"",
	m_ExaBoroughRoomTabDataGrid:"",
	ExaBoroughRoomTabEdieRow:undefined,
	m_ExaBoroughMarkTabDataGrid:"",
	ExaBoroughMarkTabEdieRow:undefined,
	m_ExaBoroughMarkExaListTabDataGrid:"",
	m_ExaBoroughMarkLocListTabDataGrid:"",
	m_ExaBoroughMarkResListTabDataGrid:"",
	m_ExaMarkRowId:"",
	m_ExaBoroughDepTabDataGrid:"",
	ExaBoroughDepTabEdieRow:undefined,
	m_ExaBoroughDepExaListTabDataGrid:"",
	m_ExaBoroughDepLocListTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//加载分诊区表格数据
	ExaBoroughTabDataGridLoad();
});
$(window).load(function() {
	InitPopover();
	InitCache();
	InitEvent();
})
function Init(){
	var hospComp = GenHospComp("DHCExaBorough");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		PageLogicObj.ExaBoroughID="";
		ExaBoroughTabDataGridLoad();
		PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid("unselectAll").datagrid('loadData', {"total":0,"rows":[]});
		PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("unselectAll").datagrid('loadData', {"total":0,"rows":[]});
		PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid("unselectAll").datagrid('loadData', {"total":0,"rows":[]});
		ClearData();
		$("#ExaBoroughRoomSearchDesc,#ExaBoroughMarkSearchDescloc,#ExaBoroughMarkSearchDescMark,#ExaBoroughDepSearchDesc").searchbox('setValue',"");
	}
	PageLogicObj.m_ExaBoroughTabDataGrid=InitExaBoroughTabDataGrid();
	PageLogicObj.m_ExaBoroughRoomTabDataGrid=InitExaBoroughRoomTabDataGrid();
	PageLogicObj.m_ExaBoroughMarkTabDataGrid=InitExaBoroughMarkTabDataGrid();
	PageLogicObj.m_ExaBoroughDepTabDataGrid=InitExaBoroughDepTabDataGrid();
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitEvent(){
	$('#BSave').click(UpdateClickHandle);
	$("#MarkBSave").click(MulExaBorMarkSave);
	$("#LocBSave").click(MulExaBorDepSave);
	$("#MulExaBorDepWin").window({
		onClose:function(){
			if (PageLogicObj.ExaBoroughID !=""){
				ExaBoroughDepTabDataGridLoad();
		    }
		}
	})
	$("#MulExaBorMarkWin").window({
		onClose:function(){
			ExaBoroughMarkTabDataGridLoad();
			//ExaBoroughDepTabDataGridLoad();
			if (PageLogicObj.m_ExaBoroughMarkExaListTabDataGrid){
				PageLogicObj.m_ExaBoroughMarkExaListTabDataGrid.datagrid("unselectAll");
				setTimeout(function(){
					PageLogicObj.m_ExaBoroughMarkExaListTabDataGrid.datagrid('options').url=$URL+"?ClassName=web.DHCExaBorough&QueryName=FindExaBorough&borname=&HospId="+$HUI.combogrid('#_HospList').getValue();
					PageLogicObj.m_ExaBoroughMarkExaListTabDataGrid.datagrid("reload");
				},500)
			}
		}
	})
	$('#ExaBoroughRoomSearch').parent().html("<div id='ExaBoroughRoomSearch'><span class='l-btn-left' ><span class='l-btn-text l-btn-empty'>&nbsp;</span></span></div>")
	$('#ExaBoroughRoomSearch_toolbar').appendTo('#ExaBoroughRoomSearch');

    $('#ExaBoroughRoomSearch').find("span").eq(0).css("display","none");
  
   	$('#ExaBoroughMarkSearch').parent().html("<div id='ExaBoroughMarkSearch'><span class='l-btn-left' ><span class='l-btn-text l-btn-empty'>&nbsp;</span></span></div>")	
    $('#ExaBoroughMarkSearch_toolbar').appendTo('#ExaBoroughMarkSearch');
    $('#ExaBoroughMarkSearch').find("span").eq(0).css("display","none");
	$('#ExaBoroughDepSearch').parent().html("<div id='ExaBoroughDepSearch'><span class='l-btn-left' ><span class='l-btn-text l-btn-empty'>&nbsp;</span></span></div>")
    $('#ExaBoroughDepSearch_toolbar').appendTo('#ExaBoroughDepSearch');
    $('#ExaBoroughDepSearch').find("span").eq(0).css("display","none");
}
function InitExaBoroughTabDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {
	        ClearData();
	        PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('unselectAll');
	        $('#Add-dialog').window('open');
	        //AddClickHandle();
	    }
    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle();}
    }, {
        text: '修改',
        iconCls: 'icon-save',
        handler: function() { 
        	var row=PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('getSelected');
			if ((!row)||(row.length==0)){
				$.messager.alert("提示","请选择需要修改的行!");
				return false;
			}
        	$('#Add-dialog').window('open');
       		 //UpdateClickHandle();
       	}
    }, {
        text: '门诊队列设置',
        iconCls: 'icon-paper-submit',
        handler: function() { 
        	var HospId=$HUI.combogrid('#_HospList').getValue()
			websys_showModal({
				url:"opdoc.outpatientlistconfig.csp?HospId="+HospId+"&ExaBoroughID="+PageLogicObj.ExaBoroughID,
				title:'门诊队列设置',
				width:'95%',height:'95%',
			});
       	}
    }/*,{
        text: '翻译',
        iconCls: 'icon-translate-word',
        handler: function() {
         	var SelectedRow = PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('getSelected');
			if (!SelectedRow){
			$.messager.alert("提示","请选择需要翻译的行!","info");
			return false;
			}
			CreatTranLate("User.DHCExaBorough","ExabName",SelectedRow["Tname"])
			        }
     }*/
	 ];
	var Columns=[[ 
		{field:'Tid',hidden:true,title:''},
		{field:'Tcode',title:'代码',width:200},
		{field:'Tname',title:'名称',width:200},
		{field:'Tmemo',title:'诊区地址',width:200},
		{field:'TCheckin',title:'是否报到',width:90},
		{field:'TAutoCheckin',title:'是否查询后自动报到',width:150},
		{field:'TFristReson',title:'是否需要填写优先原因',width:150},
		{field:'TNoCheckinDocCanRecAdm',title:'未报到可就诊',width:100},
		{field:'TCreatQueueNo',title:'报到产生队列号',width:100},
		{field:'TDelayQueueNo',title:'报到迟到惩罚',width:100},
		{field:'TCallDelayQueueNo',title:'过号惩罚',width:100},
		{field:'TCallFilePath',title:'呼叫目录',width:200},
		{field:'TWaitFilePath',title:'等候目录',width:200},
		{field:'THospital',title:'医院',width:300}
    ]]
	var ExaBoroughTabDataGrid=$("#ExaBoroughTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'Tid',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row)
			PageLogicObj.ExaBoroughID=row.Tid;
			ExaBoroughRoomTabDataGridLoad();
			//PageLogicObj.m_ExaBoroughMarkTabDataGrid=InitExaBoroughMarkTabDataGrid();
			ExaBoroughMarkTabDataGridLoad();
			ExaBoroughDepTabDataGridLoad();
		},
		onUnselect:function(index, row){
			PageLogicObj.ExaBoroughID="";
			PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid("unselectAll").datagrid('loadData', {"total":0,"rows":[]});
			PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("unselectAll").datagrid('loadData', {"total":0,"rows":[]});
			PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid("unselectAll").datagrid('loadData', {"total":0,"rows":[]});
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}); 
	return ExaBoroughTabDataGrid;
}
function SetSelRowData(row){
	$("#code").val(row["Tcode"]);
	$("#name").val(row["Tname"]);
	$("#memo").val(row["Tmemo"]);
	$("#CallFilePath").val(row["TCallFilePath"]);
	$("#WaitFilePath").val(row["TWaitFilePath"]);
	$("#FristReson").checkbox('setValue',row["TFristReson"]=="Y"?true:false);
	$("#Checkin").checkbox('setValue',row["TCheckin"]=="Y"?true:false);
	$("#AutoReportCheckin").checkbox('setValue',row["TAutoCheckin"]=="Y"?true:false);
	$("#NoCheckinDocCanRecAdm").checkbox('setValue',row["TNoCheckinDocCanRecAdm"]=="Y"?true:false);
	$("#CreatQueueNo").checkbox('setValue',row["TCreatQueueNo"]=="Y"?true:false);
	$("#DelayQueueNo").checkbox('setValue',row["TDelayQueueNo"]=="Y"?true:false);
	$("#CallDelayQueueNo").checkbox('setValue',row["TCallDelayQueueNo"]=="Y"?true:false);
}
function AddClickHandle(){
	if (!CheckDataValid()) return false;
	var code=$("#code").val();
	var name=$("#name").val();
	var memo=$("#memo").val();
	var CallFilePath=$("#CallFilePath").val();
	var WaitFilePath=$("#WaitFilePath").val();
	var Checkin=$("#Checkin").checkbox('getValue')?"Y":"N";
	var ExabAutoReport=$("#AutoReportCheckin").checkbox('getValue')?"Y":"N";
	var FristReson=$("#FristReson").checkbox('getValue')?"Y":"N";
	var NoCheckinDocCanRecAdm=$("#NoCheckinDocCanRecAdm").checkbox('getValue')?"Y":"N";
	var CreatQueueNo=$("#CreatQueueNo").checkbox('getValue')?"Y":"N";
	var DelayQueueNo=$("#DelayQueueNo").checkbox('getValue')?"Y":"N";
	var CallDelayQueueNo=$("#CallDelayQueueNo").checkbox('getValue')?"Y":"N";
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var OtherStr=CreatQueueNo+"^"+DelayQueueNo+"^"+CallDelayQueueNo+"^"+HospID
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"insertExaB",
		itmjs:"",
		itmjsex:"",
		code:code,
		name:name,
		memo:memo,
		Checkin:Checkin,
		ExabSubCallFilePath:CallFilePath,
		ExabSubWaitFilePath:WaitFilePath,
		ExabAutoReport:ExabAutoReport,
		FristReson:FristReson,
		NoCheckinDocCanRecAdm:NoCheckinDocCanRecAdm,
		OtherStr:OtherStr
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("提示","增加成功!");
			PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('uncheckAll');
			ExaBoroughTabDataGridLoad();
			ClearData();
		}else{
			$.messager.alert("提示","增加失败!代码重复!");
			return false;
		}
	});
}
function UpdateClickHandle(){
	var RowID=""
	var row=PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		//$.messager.alert("提示","请选择需要更新的行!");
		//return false;
	}else{
		RowID=row["Tid"]
	}
	if (!CheckDataValid()) return false;
	var code=$("#code").val();
	var name=$("#name").val();
	var memo=$("#memo").val();
	var CallFilePath=$("#CallFilePath").val();
	var WaitFilePath=$("#WaitFilePath").val();
	var Checkin=$("#Checkin").checkbox('getValue')?"Y":"N";
	var ExabAutoReport=$("#AutoReportCheckin").checkbox('getValue')?"Y":"N";
	var FristReson=$("#FristReson").checkbox('getValue')?"Y":"N";
	var NoCheckinDocCanRecAdm=$("#NoCheckinDocCanRecAdm").checkbox('getValue')?"Y":"N";
	var CreatQueueNo=$("#CreatQueueNo").checkbox('getValue')?"Y":"N";
	var DelayQueueNo=$("#DelayQueueNo").checkbox('getValue')?"Y":"N";
	var CallDelayQueueNo=$("#CallDelayQueueNo").checkbox('getValue')?"Y":"N";
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var OtherStr=CreatQueueNo+"^"+DelayQueueNo+"^"+CallDelayQueueNo+"^"+HospID
	if (RowID!=""){
		$.cm({
			ClassName:"web.DHCExaBorough",
			MethodName:"updateExaB",
			itmjs:"",
			itmjsex:"",
			code:code,
			name:name,
			memo:memo,
			rowid:row["Tid"],
			Checkin:Checkin,
			ExabSubCallFilePath:CallFilePath,
			ExabSubWaitFilePath:WaitFilePath,
			ExabAutoReport:ExabAutoReport,
			ExabFristReson:FristReson,
			NoCheckinDocCanRecAdm:NoCheckinDocCanRecAdm,
			OtherStr:OtherStr,
			dataType:"text"
		},function(rtn){
			if (rtn=="0"){
				$.messager.popover({msg: '更新成功!',type:'success'});
				PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('updateRow',{
					index: PageLogicObj.m_ExaBoroughTabDataGrid.datagrid("getRowIndex",row),
					row: {
						Tcode: code,
						Tname: name,
						Tmemo:memo,
						TCheckin: Checkin,
						TCallFilePath: CallFilePath,
						TWaitFilePath:WaitFilePath,
						TAutoCheckin:ExabAutoReport,
						TNoCheckinDocCanRecAdm:NoCheckinDocCanRecAdm,
						TFristReson:FristReson,
						TCreatQueueNo:CreatQueueNo,
						TDelayQueueNo:DelayQueueNo,
						TCallDelayQueueNo:CallDelayQueueNo
					}
				});
				$('#Add-dialog').window('close');
			}else{
				$.messager.alert("提示","更新失败!代码重复!");
				return false;
			}
		});
	}else{
		$.cm({
			ClassName:"web.DHCExaBorough",
			MethodName:"insertExaB",
			itmjs:"",
			itmjsex:"",
			code:code,
			name:name,
			memo:memo,
			Checkin:Checkin,
			ExabSubCallFilePath:CallFilePath,
			ExabSubWaitFilePath:WaitFilePath,
			ExabAutoReport:ExabAutoReport,
			FristReson:FristReson,
			NoCheckinDocCanRecAdm:NoCheckinDocCanRecAdm,
			OtherStr:OtherStr
		},function(rtn){
			if (rtn=="0"){
				$.messager.popover({msg: '增加成功!',type:'success'});
				PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('uncheckAll');
				ExaBoroughTabDataGridLoad();
				ClearData();
				$('#Add-dialog').window('close');
			}else{
				$.messager.alert("提示","增加失败!代码重复!");
				return false;
			}
		});	
	}
}
function DelClickHandle(){
	var row=PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要删除的行!");
		return false;
	}
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"delExaB",
		itmjs:"",
		itmjsex:"",
		rid:row["Tid"],
		dataType:"text"
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({msg: '删除成功!',type:'success'});
			ClearData();
			PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('uncheckAll');
			ExaBoroughTabDataGridLoad();
		}else{
			$.messager.alert("提示","删除失败!"+rtn);
			return false;
		}
	});
}
function ClearData(){
	$("#code,#name,#memo,#CallFilePath,#WaitFilePath").val("");
	$("#Checkin,#FristReson,#NoCheckinDocCanRecAdm,#DelayQueueNo,#CallDelayQueueNo,#AutoReportCheckin,#CreatQueueNo").checkbox('uncheck');
}
function CheckDataValid(){
	var code=$("#code").val();
	if (code==""){
		$.messager.alert("提示","请填写代码!","info",function(){$("#code").focus();});
		return false;
	}
	var name=$("#name").val();
	if (name==""){
		$.messager.alert("提示","请填写名称!","info",function(){$("#name").focus();});
		return false;
	}
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if (HospID==""){
		$.messager.alert("提示","请选择医院!","info");
		return false;
	}
	return true;
}
function ExaBoroughTabDataGridLoad(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.q({
	    ClassName : "web.DHCExaBorough",
	    QueryName : "UFindExaBorough",
	    depid : "",
	    HospId :HospID,
	    Pagerows:PageLogicObj.m_ExaBoroughTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('unselectAll').datagrid('loadData',GridData);
	}); 
}
function InitPopover(){
	$("#DelayQueueNo").next().popover({
		title:'规则',
		style:'inverse',
		content:"在分时段的情况下,过了就诊时段报到患者为迟到患者，排在当前时段的最后一个。",
		placement:'bottom',
		trigger:'hover'
	});
	$("#CallDelayQueueNo").next().popover({
		title:'规则',
		width:'400px',
		height:'320px;',
		style:'inverse',
		content:"在分时段的情况下,第一次过号重新报到,排到当前时段的最后一个;第二次过号重新报到,排到当前时段的下一个时段的最后一个;第三次及以上过号重新报到,排到最后时段的最后一个。",
		placement:'auto-bottom',
		trigger:'hover'
	});
}
function InitExaBoroughRoomTabDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {
	        if (PageLogicObj.ExaBoroughID==""){
		        $.messager.alert("提示","请选择分诊区!");
				return false;
		     }
	        PageLogicObj.ExaBoroughRoomTabEdieRow = undefined;
            PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {}
            });
            PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid("beginEdit", 0);
            PageLogicObj.ExaBoroughRoomTabEdieRow = 0;
	   }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {
	        var row=PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid('getSelected');
			if ((!row)||(row.length==0)){
				$.messager.alert("提示","请选择需要删除的行!");
				return false;
			}
			$.cm({
				ClassName:"web.DHCOPBorExaRoom",
				MethodName:"DeleteDHCBorExaRoom",
				itmjs:"",
				itmjsex:"",
				ID:row["ID"]
			},function(rtn){
				if (rtn=="0"){
					$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
					PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid('uncheckAll');
					ExaBoroughRoomTabDataGridLoad();
				}else{
					$.messager.alert("提示","删除失败!"+rtn);
					return false;
				}
			});
	    }
    },{
            text: '取消编辑',
            iconCls: 'icon-undo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                PageLogicObj.ExaBoroughRoomTabEdieRow = undefined;
                PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
     },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { 
        	if (PageLogicObj.ExaBoroughID==""){
		        $.messager.alert("提示","请选择分诊区!");
				return false;
		    }
		    if (PageLogicObj.ExaBoroughRoomTabEdieRow != undefined){
		            var ArcimSelRow=PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid("selectRow",PageLogicObj.ExaBoroughRoomTabEdieRow).datagrid("getSelected"); 
		           	var BorExaRoomDr=ArcimSelRow.BorExaRoomDr
		           	if ((BorExaRoomDr==undefined)||(BorExaRoomDr=="")){
							$.messager.alert("提示", "请选择诊室", "error");
	                        return false;
			        } 
			        var editors = PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid('getEditors', PageLogicObj.ExaBoroughRoomTabEdieRow);
			        var Memo=editors[1].target.val()
			        var BorExaRoomForOne=editors[2].target.is(':checked');
					if(BorExaRoomForOne) {BorExaRoomForOne="Y";} else{BorExaRoomForOne="N";}
			       	var ID=ArcimSelRow.ID;
			       	if (ID!=""){
				       	$.cm({
							ClassName:"web.DHCOPBorExaRoom",
							MethodName:"UpdateDHCBorExaRoom",
							itmjs:"",
							itmjsex:"",
							ID:ID,
							BorDr:PageLogicObj.ExaBoroughID,
							BorExaRoomDr:BorExaRoomDr,
							Memo:Memo,
							BorExaRoomForOne:BorExaRoomForOne
						},function(rtn){
							if (rtn=="0"){
								$.messager.popover({msg: '更新成功!',type:'success',timeout: 1000});
								PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid('uncheckAll');
								ExaBoroughRoomTabDataGridLoad();
							}else{
								$.messager.alert("提示","更新失败!该诊室已经对照!");
								return false;
							}
						});
				     }else{
					    $.cm({
							ClassName:"web.DHCOPBorExaRoom",
							MethodName:"insertDHCBorExaRoom",
							itmjs:"",
							itmjsex:"",
							BorDr:PageLogicObj.ExaBoroughID,
							ExaRoomDr:BorExaRoomDr,
							comm:Memo,
							BorExaRoomForOne:BorExaRoomForOne
						},function(rtn){
							if (rtn=="0"){
								$.messager.popover({msg: '增加成功!',type:'success',timeout: 1000});
								PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid('uncheckAll');
								ExaBoroughRoomTabDataGridLoad();
							}else{
								$.messager.alert("提示","增加失败!该诊室已经对照!");
								return false;
							}
						});
					}   	
				}
        }
    },'-',{
	    id:"ExaBoroughRoomSearch"
	    }];
	var Columns=[[ 
		{field:'ID',hidden:true,title:''},
		{field:'BorDesc',title:'分诊区',width:300,hidden:true},
		{field:'BorExaRoomDesc',title:'诊室',width:300,
		 editor :{  
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=web.DHCOPBorExaRoom&QueryName=FindDHCExaRoom&Type=&rows=99999&room=",
					valueField:'rid',
					textField:'name',
					required:false,
					onSelect:function(record){
						var ArcimSelRow=PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid("selectRow",PageLogicObj.ExaBoroughRoomTabEdieRow).datagrid("getSelected"); 
						ArcimSelRow.BorExaRoomDr=record.rid;
					},onChange:function(newValue,oldValue){
						if (PageLogicObj.ExaBoroughRoomTabEdieRow!=undefined){
							var ArcimSelRow=PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid("selectRow",PageLogicObj.ExaBoroughRoomTabEdieRow).datagrid("getSelected"); 
							if (newValue=="") ArcimSelRow.BorExaRoomDr="";
					    }
					},
					loadFilter:function(data){
						return data['rows'];
					},
				    filter: function(q, row){
						var opts = $(this).combobox('options');
						return (row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["code"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
					},
					onBeforeLoad:function(param){
						param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
					}
				  }
			  }
     	},
		{field:'Memo',title:'备注',width:300 ,editor : {type : 'text',options : {}}},
		{field:'BorExaRoomForOne',title:'一个诊室同时段只能安排一个资源',width:300, editor : {
                type : 'icheckbox',
                options : {
                    on : "Y",
                    off : ''
                }
           },
           styler: function(value,row,index){
 				if (value=="Y"){
	 				return 'color:#21ba45;';
	 			}else{
		 			return 'color:#f16e57;';
		 		}
			},
			formatter:function(value,record){
	 			if (value=="Y") return "是";
	 			else  return "否";
	 		}
		},
		{field:'BorDr',title:'',hidden:true},
		{field:'BorExaRoomDr',title:'',hidden:true}
    ]]
	var ExaBoroughRoomTabDataGrid=$("#ExaBoroughRoomTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'ID',
		columns :Columns,
		toolbar:toobar,
		onClickRow:function(rowIndex, rowData){
			PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid('getRows'); 
		},
		onDblClickRow:function(rowIndex, rowData){
			if (PageLogicObj.ExaBoroughRoomTabEdieRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.ExaBoroughRoomTabEdieRow=rowIndex;
		},
		onLoadSuccess:function(data){
			PageLogicObj.ExaBoroughRoomTabEdieRow=undefined;
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}); 
	return ExaBoroughRoomTabDataGrid;
}
function ExaBoroughRoomTabDataGridLoad(){
	if (PageLogicObj.ExaBoroughID=="") {
		return;
	}
	var ExaBoroughRoomSearchDesc=$.trim($($(".searchbox-text")[0]).val());
	$.q({
	    ClassName : "web.DHCOPBorExaRoom",
	    QueryName : "Find",
	    BordBorDr:PageLogicObj.ExaBoroughID, 
	    ExaRoomDr:"",
	    HospID:$HUI.combogrid('#_HospList').getValue(),
	    Desc:ExaBoroughRoomSearchDesc.toUpperCase(),
	    Pagerows:PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid("uncheckAll").datagrid('loadData',GridData);
		PageLogicObj.ExaBoroughRoomTabEdieRow = undefined;
	}); 
}
function InitExaBoroughMarkTabDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {
	        if (PageLogicObj.ExaBoroughID==""){
		        $.messager.alert("提示","请选择分诊区!");
				return false;
		    }
	        PageLogicObj.ExaBoroughMarkTabEdieRow = undefined;
            PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {}
            });
            PageLogicObj.ExaBoroughMarkTabEdieRow = 0;
            PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("beginEdit", 0);
	   }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {
	        var row=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('getSelected');
			if ((!row)||(row.length==0)){
				$.messager.alert("提示","请选择需要删除的行!");
				return false;
			}
			$.cm({
				ClassName:"web.DHCExaBorough",
				MethodName:"delDepMark",
				itmjs:"",
				itmjsex:"",
				rid:row["Tid"]
			},function(rtn){
				if (rtn=="0"){
					$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
					PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('uncheckAll');
					ExaBoroughMarkTabDataGridLoad();
				}else{
					$.messager.alert("提示","删除失败!"+rtn);
					return false;
				}
			});
	        }
    },{
            text: '取消编辑',
            iconCls: 'icon-undo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                PageLogicObj.ExaBoroughMarkTabEdieRow = undefined;
                PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
     },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { 
        	if (PageLogicObj.ExaBoroughID==""){
		        $.messager.alert("提示","请选择分诊区!");
				return false;
		    }
		    if (PageLogicObj.ExaBoroughMarkTabEdieRow != undefined){
		            var ArcimSelRow=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("selectRow",PageLogicObj.ExaBoroughMarkTabEdieRow).datagrid("getSelected"); 
		           	var Tdepid=ArcimSelRow.Tdepid
		           	if ((Tdepid==undefined)||(Tdepid=="")){
							$.messager.alert("提示", "请选择科室", "error");
	                        return false;
			        } 
			        var Tmarkid=ArcimSelRow.Tmarkid
		           	if ((Tmarkid==undefined)||(Tmarkid=="")){
							$.messager.alert("提示", "请选择号别", "error");
	                        return false;
			        }
			        var editors = PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('getEditors', PageLogicObj.ExaBoroughMarkTabEdieRow);
			        var TCheckin=editors[2].target.is(':checked');
					if(TCheckin) {TCheckin="Y";} else{TCheckin="N";}
					 var Tsi=editors[3].target.is(':checked');
					if(Tsi) {Tsi="Y";} else{Tsi="N";}
					if ((ArcimSelRow.Tid!="")&&(ArcimSelRow.Tid!=undefined)){
						$.cm({
							ClassName:"web.DHCExaBorough",
							MethodName:"updateDepMark",
							itmjs:"",
							itmjsex:"",
							RoomDr:PageLogicObj.ExaBoroughID,
							CompDr:Tdepid,
							MarkDr:Tmarkid,
							st:1,
							si:Tsi,
							rowid:ArcimSelRow.Tid,
							Checkin:TCheckin,
							dataType:"text"
						},function(rtn){
							if (rtn=="0"){
								$.messager.popover({msg: '更新成功!',type:'success',timeout: 1000});
								PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('uncheckAll');
								ExaBoroughMarkTabDataGridLoad();
							}else{
								$.messager.alert("提示","更新失败!"+rtn);
								return false;
							}
						});
					}else{
						$.cm({
							ClassName:"web.DHCExaBorough",
							MethodName:"insertDepMark",
							itmjs:"",
							itmjsex:"",
							RoomDr:PageLogicObj.ExaBoroughID,
							CompDr:Tdepid,
							MarkDr:Tmarkid,
							st:1,
							si:Tsi,
							Checkin:TCheckin,
							dataType:"text"
						},function(rtn){
							if (rtn=="0"){
								$.messager.popover({msg: '增加成功!',type:'success',timeout: 1000});
								PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('uncheckAll');
								ExaBoroughMarkTabDataGridLoad();
							}else{
								$.messager.alert("提示","增加失败!"+rtn);
								return false;
							}
						});
				    }
		    }
        }
    },{
		text:'号别批量对照',
		id:'i-Alladd',
		iconCls: 'icon-add',
		handler: function() { 
			$("#FindExaBoroughMarkExa,#FindExaBoroughMarkLoc,#FindExaBoroughMarkRes").searchbox('setValue',"");
			$('#MulExaBorMarkWin').window('open');
			if (PageLogicObj.m_ExaBoroughMarkExaListTabDataGrid==""){
				PageLogicObj.m_ExaBoroughMarkExaListTabDataGrid=InitExaListTabDataGrid();
			}else{
				PageLogicObj.m_ExaBoroughMarkExaListTabDataGrid.datagrid("unselectAll");
				setTimeout(function(){
					PageLogicObj.m_ExaBoroughMarkExaListTabDataGrid.datagrid('options').url=$URL+"?ClassName=web.DHCExaBorough&QueryName=FindExaBorough&borname=&HospId="+$HUI.combogrid('#_HospList').getValue();
					PageLogicObj.m_ExaBoroughMarkExaListTabDataGrid.datagrid("reload");
				},500)
			}
			
		}
	},'-',{
	    id:"ExaBoroughMarkSearch"
	    }];
	var Columns=[[ 
		{field:'Tid',hidden:true,title:''},
		{field:'Tborname',title:'分诊区',width:200,hidden:true},
		{field:'Tdepname',title:'科室',width:200,
		 editor :{  
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=web.DHCExaBorough&QueryName=Findyndep&Type=&rows=99999&id="+PageLogicObj.ExaBoroughID+"&depname=",
					valueField:'rid',
					textField:'name',
					required:false,
					onSelect:function(record){
						var ArcimSelRow=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("selectRow",PageLogicObj.ExaBoroughMarkTabEdieRow).datagrid("getSelected"); 
						ArcimSelRow.Tdepid=record.rid;
						ArcimSelRow.Tmarkid="";
						var EditMarkObj=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('getEditor', {index:PageLogicObj.ExaBoroughMarkTabEdieRow,field:'Tmarkname'});
							EditMarkObj.target.combogrid('setValue',"").combogrid("grid").datagrid('reload');
					},onChange:function(newValue,oldValue){
						if (PageLogicObj.ExaBoroughMarkTabEdieRow!=undefined){
							var ArcimSelRow=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("selectRow",PageLogicObj.ExaBoroughMarkTabEdieRow).datagrid("getSelected"); 
							if (newValue=="") {
								ArcimSelRow.Tdepid="";
								ArcimSelRow.Tmarkid="";
								var EditMarkObj=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('getEditor', {index:PageLogicObj.ExaBoroughMarkTabEdieRow,field:'Tmarkname'});
									EditMarkObj.target.combogrid('setValue',"").combogrid("grid").datagrid('reload');
							}
					    }
					},
					loadFilter:function(data){
						return data['rows'];
					},
				    filter: function(q, row){
						return (row["name"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["code"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
					},
					onBeforeLoad:function(param){
						var HospId=$HUI.combogrid('#_HospList').getValue()
						param = $.extend(param,{id:PageLogicObj.ExaBoroughID,HospID:HospId});
					}
				  }
			  }
		},
		{field:'Tmarkname',title:'号别',width:150,
			editor:{
	      		type:'combogrid',
	            options:{
	                enterNullValueClear:false,
					required: false,
					panelWidth:450,
					panelHeight:350,
					delay:500,
					idField:'RowID',
					textField:'Desc',
					value:'',//缺省值 
					mode:'remote',
					pagination : true,//是否分页   
					rownumbers:true,//序号   
					collapsible:false,//是否可折叠的   
					fit: true,//自动大小   
					pageSize: 10,//每页显示的记录条数，默认为10   
					pageList: [10],//可以设置每页记录条数的列表  
					url:$URL+"?ClassName=web.DHCDepMark&QueryName=Findloc",
	                columns:[[
	                    {field:'Desc',title:'号别',width:250},
						//{field:'code',title:'代码'},
						{field:'RowID',title:'号别RowID'},
	                 ]],
					onSelect: function (rowIndex, rowData){
						var rows=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("selectRow",PageLogicObj.ExaBoroughMarkTabEdieRow).datagrid("getSelected");
						rows.Tmarkid=rowData.RowID
					},
					onClickRow: function (rowIndex, rowData){
						var rows=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("selectRow",PageLogicObj.ExaBoroughMarkTabEdieRow).datagrid("getSelected");
						rows.Tmarkid=rowData.RowID
					},
					onLoadSuccess:function(data){
						$(this).next('span').find('input').focus();
					},
					onBeforeLoad:function(param){
						var ArcimSelRow=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("selectRow",PageLogicObj.ExaBoroughMarkTabEdieRow).datagrid("getSelected"); 
						var desc=param['q'];
	        			param = $.extend(param,{depid:ArcimSelRow.Tdepid,markname:desc,HospitalID:$HUI.combogrid('#_HospList').getValue()});
					}
	    		}
			  }
		
		},
		{field:'TCheckin',title:'是否报到',width:70, editor : {
                type : 'icheckbox',
                options : {
                    on : 'Y',
                    off : 'N'
                }
           },
           styler: function(value,row,index){
 				if (value=="Y"){
	 				return 'color:#21ba45;';
	 			}else{
		 			return 'color:#f16e57;';
		 		}
			},
			formatter:function(value,record){
	 			if (value=="Y") return "是";
	 			else  return "否";
	 		}
		},
		//{field:'Tst',title:'状态',width:50},
		{field:'Tsi',title:'对照是否有效',width:100, editor : {
                type : 'icheckbox',
                options : {
                    on : "是",
                    off : '否'
                }
           },
           styler: function(value,row,index){
 				if (value=="是"){
	 				return 'color:#21ba45;';
	 			}else{
		 			return 'color:#f16e57;';
		 		}
			},
			formatter:function(value,record){
	 			if (value=="是") return "是";
	 			else  return "否";
	 		}
		},
		{field:'Tborid',title:'',hidden:true},
		{field:'Tdepid',title:'',hidden:true},
		{field:'Tmarkid',title:'',hidden:true}
    ]]
	var ExaBoroughMarkTabDataGrid=$("#ExaBoroughMarkTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'Tid',
		columns :Columns,
		toolbar:toobar,
		ClickRow:function(rowIndex, rowData){
			PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('getRows'); 
		},
		onDblClickRow:function(rowIndex, rowData){
			if (PageLogicObj.ExaBoroughMarkTabEdieRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			PageLogicObj.ExaBoroughMarkTabEdieRow=rowIndex
			PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("beginEdit", rowIndex);
		},
		onLoadSuccess:function(data){
			PageLogicObj.ExaBoroughMarkTabEdieRow=undefined;
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
	return ExaBoroughMarkTabDataGrid;
}
function ExaBoroughMarkTabDataGridLoad(){
	if (PageLogicObj.ExaBoroughID =="") return;
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var ExaBoroughMarkSearchDescloc=$.trim($($(".searchbox-text")[1]).val());
	var ExaBoroughMarkSearchDescMark=$.trim($($(".searchbox-text")[2]).val());
	$.q({
	    ClassName : "web.DHCDepMark",
	    QueryName : "QueryDepMark",
	    roomid:PageLogicObj.ExaBoroughID,
	    HospId:HospID,LocID:"",MarkID:"",
	    SI:"",ST:"",Check:"",locdesc:ExaBoroughMarkSearchDescloc,markdesc:ExaBoroughMarkSearchDescMark,
	    Pagerows:PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("uncheckAll").datagrid('loadData',GridData);
		PageLogicObj.ExaBoroughMarkTabEdieRow = undefined;
	}); 
}
function FindExaBoroughMarkExaChange(){
	PageLogicObj.m_ExaBoroughMarkExaListTabDataGrid.datagrid("reload");
}
function FindExaBoroughMarkLocChange(){
	PageLogicObj.m_ExaBoroughMarkLocListTabDataGrid.datagrid("reload");
}
function FindExaBoroughMarkResChange(){
	PageLogicObj.m_ExaBoroughMarkResListTabDataGrid.datagrid("reload");
}
function InitExaListTabDataGrid(){
	var Columns=[[ 
		{field:'name',title:'分诊区',width:180},
		{field:'rid',title:'ID',width:80}
    ]]
	var ExaListTabDataGrid=$("#ExaExaBoroughMarkListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		rownumbers : false,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'rid',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=FindExaBorough&borname=&HospId="+$HUI.combogrid('#_HospList').getValue(),
		onBeforeLoad:function(param){
			$("#ExaExaBoroughMarkListTab").datagrid("unselectAll");
			var desc=$("#FindExaBoroughMarkExa").searchbox('getValue'); 
			param = $.extend(param,{borname:desc});
		},
		onSelect:function(){
			if (PageLogicObj.m_ExaBoroughMarkLocListTabDataGrid=="") {
				PageLogicObj.m_ExaBoroughMarkLocListTabDataGrid=InitLocListTabDataGrid();
			}else{
				PageLogicObj.m_ExaBoroughMarkLocListTabDataGrid.datagrid("reload");
			}
		},
		onUncheckAll:function(rows){
			if (PageLogicObj.m_ExaBoroughMarkLocListTabDataGrid!="") {
				PageLogicObj.m_ExaBoroughMarkLocListTabDataGrid.datagrid("unselectAll").datagrid('loadData', {"total":0,"rows":[]});
			}
			if (PageLogicObj.m_ExaBoroughMarkResListTabDataGrid!=""){
				PageLogicObj.m_ExaBoroughMarkResListTabDataGrid.datagrid("unselectAll").datagrid('loadData', {"total":0,"rows":[]});
			}
		}
	});
	return ExaListTabDataGrid;
}
var UnCheckAllFlag=0;
function InitLocListTabDataGrid(){
	var Columns=[[ 
		{field:'rid',title:'',checkbox:true},
		{field:'name',title:'科室',width:180}
    ]]
	var LocListTabDataGrid=$("#LocExaBoroughMarkListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		rownumbers : false,  
		idField:'rid',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=Findyndep&rows=99999",
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_ExaBoroughMarkLocListTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_ExaBoroughMarkLocListTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_ExaBoroughMarkLocListTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		},
		onBeforeLoad:function(param){
			$("#LocExaBoroughMarkListTab").datagrid("uncheckAll");
			var desc=$("#FindExaBoroughMarkLoc").searchbox('getValue'); 
			var selrow=PageLogicObj.m_ExaBoroughMarkExaListTabDataGrid.datagrid("getSelected")
			if (selrow) exaId=selrow.rid;
			else  exaId="";
			param = $.extend(param,{id:exaId,depname:desc,HospID:$HUI.combogrid('#_HospList').getValue()});
		},
		onSelect:function(){
			if (PageLogicObj.m_ExaBoroughMarkResListTabDataGrid=="") {
				PageLogicObj.m_ExaBoroughMarkResListTabDataGrid=InitResListTabDataGrid();
			}else{
				PageLogicObj.m_ExaBoroughMarkResListTabDataGrid.datagrid("reload");
			}
		},
		onUnselect:function(){
			if ((PageLogicObj.m_ExaBoroughMarkResListTabDataGrid)&&(UnCheckAllFlag==0)) PageLogicObj.m_ExaBoroughMarkResListTabDataGrid.datagrid("reload");
		},onUncheckAll:function(rows){
			setTimeout(function() { 
	        	if (PageLogicObj.m_ExaBoroughMarkResListTabDataGrid!=""){
					PageLogicObj.m_ExaBoroughMarkResListTabDataGrid.datagrid("unselectAll").datagrid('loadData', {"total":0,"rows":[]});
				}
	        },500);
		},
		onCheckAll:function(){
			if (PageLogicObj.m_ExaBoroughMarkResListTabDataGrid=="") {
				PageLogicObj.m_ExaBoroughMarkResListTabDataGrid=InitResListTabDataGrid();
			}else{
				PageLogicObj.m_ExaBoroughMarkResListTabDataGrid.datagrid("reload");
			}
		},
		onLoadSuccess:function(){
			$("#LocExaBoroughMarkListTab").datagrid("uncheckAll");
		}
	});
	return LocListTabDataGrid;
}
function InitResListTabDataGrid(){
	var Columns=[[ 
		{field:'RowID',title:'',checkbox:true},
		{field:'Desc',title:'医生号别',width:180}		
    ]]
	var ResListTabDataGrid=$("#ResExaBoroughMarkListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		rownumbers : false,  
		idField:'ResRowId',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=FindExaDoc&rows=99999",
		onBeforeLoad:function(param){
			$("#ResExaBoroughMarkListTab").datagrid("uncheckAll");
			var desc=$("#FindExaBoroughMarkRes").searchbox('getValue'); 
			param = $.extend(param,{ExaId:GetSelExaId(),depstr:GetSelDeptStr(),docname:desc});
		},
		onLoadSuccess:function(data){
			for (var i=0;i<data.rows.length;i++){
				var PoweredFlag=data.rows[i].PoweredFlag;
				if (PoweredFlag=="Y") {
					PageLogicObj.m_ExaBoroughMarkResListTabDataGrid.datagrid('selectRow',i);
				}
			}
		}
	});
	return ResListTabDataGrid;
}
function GetSelDeptStr(){
	var depstr=""; 
	if (PageLogicObj.m_ExaBoroughMarkLocListTabDataGrid=="") return "";
	var locRows=PageLogicObj.m_ExaBoroughMarkLocListTabDataGrid.datagrid('getSelections');
	for (var i=0;i<locRows.length;i++){
		if (depstr=="") depstr=locRows[i].rid;
		else  depstr=depstr+"^"+locRows[i].rid;
	}
	return depstr;
}
function GetSelExaId(){
	var SelRow=PageLogicObj.m_ExaBoroughMarkExaListTabDataGrid.datagrid('getSelections');
	if (SelRow.length==0) return "";
	var ExaId=SelRow[0].rid;
	return ExaId;
}
function MulExaBorMarkSave(){
	var ExaId=GetSelExaId();
	if (ExaId=="") {
		$.messager.alert("提示","请选择诊区");
		return false;
	}
	if (PageLogicObj.m_ExaBoroughMarkResListTabDataGrid=="") {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var rows=PageLogicObj.m_ExaBoroughMarkResListTabDataGrid.datagrid('getRows');
	if (rows.length==0) {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var GridSelectArr=PageLogicObj.m_ExaBoroughMarkResListTabDataGrid.datagrid('getSelections');
	var inPara="",subPara="";
	for (var i=0;i<rows.length;i++){
		var ResRowId=rows[i].ResRowId;
		if ($.hisui.indexOfArray(GridSelectArr,"ResRowId",ResRowId)>=0) {
			if (inPara == "") inPara = ResRowId;
			else  inPara = inPara + "!" + ResRowId;
		}else{
			if (subPara == "") subPara = ResRowId;
			else  subPara = subPara + "!" + ResRowId;
		}
	}
	$.m({
	    ClassName:"web.DHCExaBorough",
	    MethodName:"SaveExaBorMark",
	    ExaId:ExaId,
	    inPara:inPara,
	    subPara:subPara
	},function(rtn){
		if(rtn==0){
			$.messager.popover({msg:'保存成功',type:'success',timeout:1000});
			PageLogicObj.m_ExaBoroughMarkLocListTabDataGrid.datagrid("uncheckAll");
		}
	})
}
function InitExaBoroughDepTabDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {
	         if (PageLogicObj.ExaBoroughID==""){
		        $.messager.alert("提示","请选择分诊区!");
				return false;
		     }
	        PageLogicObj.ExaBoroughDepTabEdieRow = undefined;
            PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {}
            });
            PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid("beginEdit", 0);
            PageLogicObj.ExaBoroughDepTabEdieRow = 0;
	  }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {
	        var row=PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('getSelected');
			if ((!row)||(row.length==0)){
				$.messager.alert("提示","请选择需要删除的行!");
				return false;
			}
			var rtn=$.cm({
				ClassName:"web.DHCExaBorDep",
				MethodName:"CheckDepMark",
				Bordr:row["TBordBorDr"], Deptdr:row["TBordDepDr"]
			},false);
			if (rtn=="1"){
				$.messager.confirm('确认对话框', row["TBordBordesc"]+"和"+row["TBordDepdesc"]+'的对照关系在分诊区号别对照界面已有维护数据,若继续则会删除分诊区号别对照数据,是否继续?', function(r){
					if (r){
					   Del();
					}
				});
			}else{
				Del();
			}
			function Del(){
				$.cm({
					ClassName:"web.DHCExaBorDep",
					MethodName:"DeleteBorDep",
					itmjs:"",
					itmjsex:"",
					id:row["TID"]
				},function(rtn){
					if (rtn=="0"){
						$.messager.alert("提示","删除成功!");
						PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('uncheckAll');
						ExaBoroughDepTabDataGridLoad();
					}else{
						$.messager.alert("提示","删除失败!"+rtn);
						return false;
					}
				});
			}
	        
	        }
    },{
            text: '取消编辑',
            iconCls: 'icon-undo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                PageLogicObj.ExaBoroughDepTabEdieRow = undefined;
                PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
     },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { 
        	if (PageLogicObj.ExaBoroughID==""){
		        $.messager.alert("提示","请选择分诊区!");
				return false;
		    }
		    if (PageLogicObj.ExaBoroughDepTabEdieRow != undefined){
		            var ArcimSelRow=PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid("selectRow",PageLogicObj.ExaBoroughDepTabEdieRow).datagrid("getSelected"); 
		           	var TBordDepDr=ArcimSelRow.TBordDepDr
		           	if ((TBordDepDr==undefined)||(TBordDepDr=="")){
							$.messager.alert("提示", "请选择科室", "error");
	                        return false;
			        } 
			        var editors = PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('getEditors', PageLogicObj.ExaBoroughDepTabEdieRow);
			        var Memo=editors[1].target.val()
			       	if ((ArcimSelRow.TID!="")&&(ArcimSelRow.TID!=undefined)){
				       	if (TBordDepDr==ArcimSelRow["TBordDepDr"]){
							update();
						}else{
							var rtn=$.cm({
								ClassName:"web.DHCExaBorDep",
								MethodName:"CheckDepMark",
								Bordr:ArcimSelRow["TBordBorDr"], Deptdr:ArcimSelRow["TBordDepDr"]
							},false);
							if (rtn=="1"){
								$.messager.confirm('确认对话框', ArcimSelRow["TBordBordesc"]+"和"+ArcimSelRow["TBordDepdesc"]+'的对照关系在分诊区号别对照界面已有维护数据,若继续则会删除分诊区号别对照数据,是否继续?', function(r){
									if (r){
									   update();
									}
								});
							}else{
								update();
							}
						}
			       	
					}else{
					     $.cm({
							ClassName:"web.DHCExaBorDep",
							MethodName:"insertBorDep",
							itmjs:"",
							itmjsex:"",
							BordBorDr:PageLogicObj.ExaBoroughID,
							BordDepDr:TBordDepDr,
							BordMemo:Memo
						},function(rtn){
							if (rtn=="0"){
								$.messager.popover({msg: '增加成功!',type:'success'});
								PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('uncheckAll');
								ExaBoroughDepTabDataGridLoad();
							}else{
								$.messager.alert("提示","增加失败!记录重复!");
								return false;
							}
						});  		     
		    	   }
		    }
		    function update(){
				$.cm({
					ClassName:"web.DHCExaBorDep",
					MethodName:"updateBorDep",
					itmjs:"",
					itmjsex:"",
					BordBorDr:PageLogicObj.ExaBoroughID,
					BordDepDr:TBordDepDr,
					BordMemo:Memo,
					id:ArcimSelRow.TID
				},function(rtn){
					if (rtn=="0"){
						$.messager.popover({msg: '更新成功!',type:'success'});
						//ClearData();
						PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('uncheckAll');
						ExaBoroughDepTabDataGridLoad();
					}else{
						$.messager.alert("提示","更新失败!记录重复!");
						return false;
					}
				});		
			}
        }
    },{
		text:'科室批量对照',
		id:'i-Alladd',
		iconCls: 'icon-add',
		handler: function() {
			$("#FindExaBoroughDepExa,#FindExaBoroughDepLoc").searchbox('setValue',""); 
			$('#MulExaBorDepWin').window('open');
			if (PageLogicObj.m_ExaBoroughDepExaListTabDataGrid==""){
				PageLogicObj.m_ExaBoroughDepExaListTabDataGrid=InitExaBoroughDepExaListTabDataGrid();
			}else{
				PageLogicObj.m_ExaBoroughDepExaListTabDataGrid.datagrid('options').url=$URL+"?ClassName=web.DHCExaBorough&QueryName=FindExaBorough&borname=&HospId="+$HUI.combogrid('#_HospList').getValue();
				PageLogicObj.m_ExaBoroughDepExaListTabDataGrid.datagrid("reload");
			}
		}
	},'-',{
	    id:"ExaBoroughDepSearch"
	    }
	];
	var Columns=[[ 
		{field:'TID',hidden:true,title:''},
		{field:'TBordBordesc',title:'分诊区',width:300,hidden:true},
		{field:'TBordDepdesc',title:'科室',width:300,
		 editor :{  
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=QueryLoc&Type=&rows=99999&depname=&UserID=&LogHospId="+$HUI.combogrid('#_HospList').getValue(),
					valueField:'id',
					textField:'name',
					required:false,
					onSelect:function(record){
						var ArcimSelRow=PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid("selectRow",PageLogicObj.ExaBoroughDepTabEdieRow).datagrid("getSelected"); 
						ArcimSelRow.TBordDepDr=record.id;
					},onChange:function(newValue,oldValue){
						if (PageLogicObj.ExaBoroughDepTabEdieRow!=undefined){
							var ArcimSelRow=PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid("selectRow",PageLogicObj.ExaBoroughDepTabEdieRow).datagrid("getSelected"); 
							if (newValue=="") ArcimSelRow.TBordDepDr="";
					    }
					},
					loadFilter:function(data){
						return data['rows'];
					},
				    filter: function(q, row){
						return ((row["name"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["ContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0));
					},
					onBeforeLoad:function(param){
						param = $.extend(param,{LogHospId:$HUI.combogrid('#_HospList').getValue()});
					}
				  }
			  }},
		{field:'TBordMemo',title:'备注',width:300,editor : {type : 'text',options : {}}},
		{field:'TBordDepDr',title:'',hidden:true},
		{field:'TBordBorDr',title:'',hidden:true}
    ]]
	var ExaBoroughDepTabDataGrid=$("#ExaBoroughDepTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'TID',
		columns :Columns,
		toolbar:toobar,
		ClickRow:function(rowIndex, rowData){
			PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('getRows'); 
		},
		onDblClickRow:function(rowIndex, rowData){
			if (PageLogicObj.ExaBoroughDepTabEdieRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			PageLogicObj.ExaBoroughDepTabEdieRow=rowIndex
			PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid("beginEdit", rowIndex);
		},
		onLoadSuccess:function(data){
			PageLogicObj.ExaBoroughDepTabEdieRow=undefined;
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}); 
	return ExaBoroughDepTabDataGrid;
}
function ExaBoroughDepTabDataGridLoad(){
	if (PageLogicObj.ExaBoroughID== "") return;
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var ExaBoroughDepSearchDescMark=$.trim($($(".searchbox-text")[3]).val());
	$.q({
	    ClassName : "web.DHCExaBorough",
	    QueryName : "UFindExaBorDep",
	    BordBorDr:PageLogicObj.ExaBoroughID,
	    BordDepDr:"",
	    HospId:HospID,
	    Desc:ExaBoroughDepSearchDescMark,
	    Pagerows:PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid("uncheckAll").datagrid('loadData',GridData);
		PageLogicObj.ExaBoroughDepTabEdieRow = undefined;
	}); 
}
function FindExaBoroughDepExaChange(){
	PageLogicObj.m_ExaBoroughDepExaListTabDataGrid.datagrid("reload");
}
function FindExaBoroughDepLocChange(){
	PageLogicObj.m_ExaBoroughDepLocListTabDataGrid.datagrid("reload");
}
function InitExaBoroughDepExaListTabDataGrid(){
	var Columns=[[ 
		{field:'name',title:'分诊区',width:180},
		{field:'rid',title:'ID',width:80}
    ]]
	var ExaListTabDataGrid=$("#ExaExaBoroughDepListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		rownumbers : false,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'rid',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=FindExaBorough&borname=&HospId="+$HUI.combogrid('#_HospList').getValue(),
		onBeforeLoad:function(param){
			$("#ExaExaBoroughDepListTab").datagrid("uncheckAll");
			var desc=$("#FindExaBoroughDepExa").searchbox('getValue'); 
			param = $.extend(param,{borname:desc});
		},
		onSelect:function(){
			if (PageLogicObj.m_ExaBoroughDepLocListTabDataGrid=="") {
				PageLogicObj.m_ExaBoroughDepLocListTabDataGrid=InitExaBoroughDepLocListTabDataGrid();
			}else{
				PageLogicObj.m_ExaBoroughDepLocListTabDataGrid.datagrid("reload");
			}
		},
		onUncheckAll:function(rows){
			if (PageLogicObj.m_ExaBoroughDepLocListTabDataGrid!="") {
				PageLogicObj.m_ExaBoroughDepLocListTabDataGrid.datagrid("uncheckAll").datagrid('loadData', {"total":0,"rows":[]});
			}
		}
	});
	return ExaListTabDataGrid;
}
function InitExaBoroughDepLocListTabDataGrid(){
	var Columns=[[ 
		{field:'LocId',title:'',checkbox:true},
		{field:'CTDesc',title:'科室',width:180}
    ]]
	var LocListTabDataGrid=$("#LocExaBoroughDepListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		rownumbers : false,  
		idField:'LocId',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCExaBorDep&QueryName=FindExaLoc&rows=99999",
		onBeforeLoad:function(param){
			$("#LocExaBoroughDepListTab").datagrid("uncheckAll");
			var desc=$("#FindExaBoroughDepLoc").searchbox('getValue'); 
			var selrow=PageLogicObj.m_ExaBoroughDepExaListTabDataGrid.datagrid("getSelected")
			if (selrow) exaId=selrow.rid;
			else  exaId="";
			param = $.extend(param,{ExaId:exaId,desc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		},
		onLoadSuccess:function(data){
			for (var i=0;i<data.rows.length;i++){
				var PoweredFlag=data.rows[i].PoweredFlag;
				if (PoweredFlag=="Y") {
					PageLogicObj.m_ExaBoroughDepLocListTabDataGrid.datagrid('selectRow',i);
				}
			}
		}
	});
	return LocListTabDataGrid;
}
function GetExaBoroughDepSelExaId(){
	var SelRow=PageLogicObj.m_ExaBoroughDepExaListTabDataGrid.datagrid('getSelections');
	if (SelRow.length==0) return "";
	var ExaId=SelRow[0].rid;
	return ExaId;
}
function MulExaBorDepSave(){
	var ExaId=GetExaBoroughDepSelExaId();
	if (ExaId=="") {
		$.messager.alert("提示","请选择诊区");
		return false;
	}
	if (PageLogicObj.m_ExaBoroughDepLocListTabDataGrid=="") {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var rows=PageLogicObj.m_ExaBoroughDepLocListTabDataGrid.datagrid('getRows');
	if (rows.length==0) {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var GridSelectArr=PageLogicObj.m_ExaBoroughDepLocListTabDataGrid.datagrid('getSelections');
	var inPara="",subPara="";
	for (var i=0;i<rows.length;i++){
		var LocId=rows[i].LocId;
		if ($.hisui.indexOfArray(GridSelectArr,"LocId",LocId)>=0) {
			if (inPara == "") inPara = LocId;
			else  inPara = inPara + "!" + LocId;
		}else{
			if (subPara == "") subPara = LocId;
			else  subPara = subPara + "!" + LocId;
		}
	}
	$.m({
	    ClassName:"web.DHCExaBorDep",
	    MethodName:"SaveExaBorDep",
	    ExaId:ExaId,
	    inPara:inPara,
	    subPara:subPara
	},function(rtn){
		if(rtn==0){
			$.messager.popover({msg:'保存成功',type:'success',timeout:1000});
			//PageLogicObj.m_LocListTabDataGrid.datagrid("uncheckAll");
		}
	})
}
