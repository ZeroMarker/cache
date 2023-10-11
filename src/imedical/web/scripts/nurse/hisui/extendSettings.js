var editIndex=undefined;
var editItemIndex=undefined;
var GV={
	_CALSSNAME:"Nur.NIS.Service.Base.ExtendSettings"
}
$(window).load(function() {
	$("#Loading").hide();
});
$(function(){ 
	InitHospList();
});
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_ExtendSet");
	hospComp.jdata.options.onSelect = function(e,t){
		$('#extendTab,#extendItemTab').datagrid("reload");
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	InitExtendTab();
	InitExtendItemTab();
}
function InitExtendTab(){
	var ToolBar = [{
        text: '����',
        iconCls: '	icon-add',
        handler: function() {
	        endExtendTabEditing();
	        $('#extendTab').datagrid('insertRow',{
				index: 0,
				row: {
					rowid: '',
					ESCode: '',
					ESDesc: '',
					ESType:''
				}
			});
			editIndex = 0;
			$('#extendTab').datagrid('selectRow', 0).datagrid('beginEdit', 0);
			$('#extendItemTab').datagrid("reload");
        }
    },{
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function() {
	       delExtendSetData();
        }
    },{
        text: '����',
        iconCls: 'icon-save',
        handler: function() {
	       saveExtendSetData();
        }
    }];
	$('#extendTab').datagrid({
		toolbar :ToolBar,
		border:false,
        url: $URL,
        singleSelect: true,
        bodyCls:'panel-body-gray',
        queryParams: {
            ClassName: GV._CALSSNAME,
            QueryName: "getExtentList"
        },
        idField:'rowid',
        columns: [[
	        {
	           field: "ESCode",title: "����",width: 140,
	            editor: {type: 'text'}
	        },
			{ field: 'ESDesc',title: '����',  width: 143, 
			  editor: {type: 'text'}
		    },
		    { field: 'ESType',title: '����',  width: 143, 
			  editor: {
                    type: 'combobox',
                    options: {
	                    required: true,
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'ARCIM', desc: 'ҽ����' },
                            { value: 'Loc', desc: '����' }
                        ]
                    }
                },
                formatter: function (value, row) {
	                return row["ESTypeDesc"];
	            }
		    }
	    ]],
	    onDblClickRow:function(rowIndex, rowData){
		    if (editIndex != rowIndex) {
		        if (endExtendTabEditing()) {
		            $('#menuTab').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
		            editIndex = rowIndex;
		        } else {
		            $('#menuTab').datagrid('selectRow', editIndex);
		        }
		    }
		},
        onClickRow: function (index) {
		    $('#extendItemTab').datagrid("reload");
        },
        onBeforeLoad:function(param){
	        $('#extendTab').datagrid('unselectAll');
	        editIndex = undefined;
	        param.hospId=$HUI.combogrid('#_HospList').getValue();
	    }
    });
}
function saveExtendSetData(){
	if (editIndex == undefined){
	   $.messager.popover({msg:'û����Ҫ����ļ�¼!',type:'error'});
       return false;
	}
	var rows=$('#extendTab').datagrid('getRows');
	var rowid=rows[editIndex]["rowid"];
	var editors=$('#extendTab').datagrid('getEditors',editIndex);
	var ESCode=editors[0].target.val();
	if (ESCode ==""){
	   $.messager.popover({msg:'���벻��Ϊ�գ�',type:'error'});
       return false;
	}
	var ESDesc=editors[1].target.val();
	if (ESDesc ==""){
	   $.messager.popover({msg:'��������Ϊ�գ�',type:'error'});
       return false;
    }
    var ESType=editors[2].target.combobox("getValue");
	if (ESType ==""){
	   $.messager.popover({msg:'���Ͳ���Ϊ�գ�',type:'error'});
       return false;
    }
    $.m({
		ClassName:GV._CALSSNAME,
		MethodName:"handleExtent",
		rowid:rowid,
		code:ESCode,
		desc:ESDesc,
		type:ESType,
		hospId:$HUI.combogrid('#_HospList').getValue(),
		EVENT:"SAVE"
	},function(rtn){
		if (rtn!=0){
			$.messager.popover({msg: '����ʧ�ܣ�'+rtn,type: 'error'});
			return false;
		}else{
			//clearPatListConfigData();
			$('#extendTab').datagrid('reload');
		}
	})
}
function delExtendSetData(){
	var sel=$('#extendTab').datagrid("getSelected");
    if (!sel){
       $.messager.popover({msg:'��ѡ����Ҫɾ���ļ�¼��',type:'error'});
       return false;
    }
    $.messager.confirm('ȷ��','�Ƿ�ȷ��ɾ��?',function(r){    
	    if (r){    
	        var rowid=sel["rowid"];
		    $.cm({
				ClassName:GV._CALSSNAME,
				MethodName:"handleExtent",
				rowid:sel["rowid"],
				EVENT:"DELETE"
			},function(rtn){
				if (rtn<0){
					$.messager.popover({msg: 'ɾ��ʧ�ܣ�'+rtn,type: 'error'});
					return false;
				}else{
					var index=$('#extendTab').datagrid("getRowIndex",sel["rowid"]);
					$('#extendTab').datagrid("deleteRow",index);
					$('#extendItemTab').datagrid("reload");
					//clearPatListConfigData();
				}
			})   
	    }    
	});
    
}
function endExtendTabEditing(){
	if (editIndex == undefined) { return true; }
	var rows=$('#extendTab').datagrid('getRows');
	if (rows[editIndex]["rowid"]==""){
		$('#extendTab').datagrid('rejectChanges', editIndex);
	}
    $('#extendTab').datagrid('endEdit', editIndex);
    editIndex = undefined;
    return true;
}
function InitExtendItemTab(){
	var ToolBar = [{
        text: '����',
        iconCls: '	icon-add',
        handler: function() {
	        var sel=$('#extendTab').datagrid("getSelected");
		    if (!sel){
		       $.messager.popover({msg:'����ѡ����չ��Ŀ��',type:'error'});
		       return false;
		    }else if(!sel.rowid){
			    $.messager.popover({msg:'��ѡ���ѱ������չ��Ŀ��',type:'error'});
		       return false;
			}
	        endExtendItemTabEditing();
	        $('#extendItemTab').datagrid('insertRow',{
				index: 0,
				row: {
					rowid: '',
					PLSCode: '',
					PLSDesc: ''
				}
			});
			editItemIndex = 0;
			$('#extendItemTab').datagrid('selectRow', 0).datagrid('beginEdit', 0);
        }
    },{
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function() {
	       delExtendItemSetData();
        }
    },{
        text: '����',
        iconCls: 'icon-save',
        handler: function() {
	       saveExtendItemSetData();
        }
    }];
	$('#extendItemTab').datagrid({
		toolbar :ToolBar,
		border:false,
        url: $URL,
        singleSelect: true,
        bodyCls:'panel-body-gray',
        queryParams: {
            ClassName: GV._CALSSNAME,
            QueryName: "getExtentItemSet"
        },
        idField:'rowid',
        columns: [[
			{ field: 'EISItemDr',title: '��Ŀ����',  width: 300, 
			  editor:{
          		type:'combogrid',
                options:{
                    enterNullValueClear:false,
					required: true,
					panelWidth:450,
					panelHeight:350,
					delay:500,
					idField:'id',
					textField:'name',
					value:'',//ȱʡֵ 
					mode:'remote',
					pagination : true,//�Ƿ��ҳ   
					rownumbers:true,//���   
					collapsible:false,//�Ƿ���۵���   
					fit: true,//�Զ���С   
					pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
					pageList: [10],//��������ÿҳ��¼�������б�  
					url:$URL+"?ClassName=Nur.NIS.Service.Base.ExtendSettings&QueryName=GetItemCodeList",
                    columns:[[
                        {field:'name',title:'����',width:310,sortable:true}
                     ]],
					onSelect: function (rowIndex, rowData){
						var rows=$('#extendItemTab').datagrid("selectRow",editItemIndex).datagrid("getSelected");
						rows.EISItemDr=rowData.ArcimRowID;
					},
					onBeforeLoad:function(param){
						if (param['q']) {
							var desc=param['q'];
						}
						var sel=$('#extendTab').datagrid("getSelected");
					    if (!sel){
					       var type="";
					    }else if(sel.rowid){
						   var type=sel.ESType;
						}
						param = $.extend(param,{
							Alias:desc,
							TYPE:type,
							HospId:$HUI.combogrid('#_HospList').getValue()
						});
					}
        		}
			  },
			  formatter: function (value, row) {
	                return row["EISItemDesc"];
	          }
		    }
	    ]],
	    onDblClickRow:function(rowIndex, rowData){
		    if (editIndex != rowIndex) {
		        if (endExtendItemTabEditing()) {
		            $('#extendItemTab').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
		            editItemIndex = rowIndex;
		        } else {
		            $('#extendItemTab').datagrid('selectRow', editItemIndex);
		        }
		    }
		},
        onBeforeLoad:function(param){
	        $('#extendItemTab').datagrid('unselectAll');
	        editItemIndex = undefined;
	        var sel=$('#extendTab').datagrid("getSelected");
	        if (!sel){
		        var extentId="";
		    }else{
			    var extentId=sel.rowid;
			}
	        param.extentId=extentId;
	    }
    });
}
function saveExtendItemSetData(){
	if (editItemIndex == undefined){
	   $.messager.popover({msg:'û����Ҫ����ļ�¼!',type:'error'});
       return false;
	}
	var sel=$('#extendTab').datagrid("getSelected");
	var extentId=sel.rowid;
	var rows=$('#extendItemTab').datagrid('getRows');
	var rowid=rows[editItemIndex]["rowid"];
	var editors=$('#extendItemTab').datagrid('getEditors',editItemIndex);
    var itemDr=editors[0].target.combogrid("getValue");
	if (itemDr ==""){
	   $.messager.popover({msg:'��Ŀ����Ϊ�գ�',type:'error'});
       return false;
    }
    $.m({
		ClassName:GV._CALSSNAME,
		MethodName:"handleExtentItem",
		extentId:extentId,
		rowid:rowid,
		itemDr:itemDr,
		EVENT:"SAVE"
	},function(rtn){
		if (rtn!=0){
			$.messager.popover({msg: '����ʧ�ܣ�'+rtn,type: 'error'});
			return false;
		}else{
			//clearPatListConfigData();
			$('#extendItemTab').datagrid('reload');
		}
	})
}
function delExtendItemSetData(){
	var sel=$('#extendItemTab').datagrid("getSelected");
    if (!sel){
       $.messager.popover({msg:'��ѡ����Ҫɾ���ļ�¼��',type:'error'});
       return false;
    }
    $.messager.confirm('ȷ��','�Ƿ�ȷ��ɾ��?',function(r){    
	    if (r){    
	        var rowid=sel["rowid"];
		    $.cm({
				ClassName:GV._CALSSNAME,
				MethodName:"handleExtentItem",
				rowid:sel["rowid"],
				EVENT:"DELETE"
			},function(rtn){
				if (rtn<0){
					$.messager.popover({msg: 'ɾ��ʧ�ܣ�'+rtn,type: 'error'});
					return false;
				}else{
					var index=$('#extendItemTab').datagrid("getRowIndex",sel["rowid"]);
					$('#extendItemTab').datagrid("deleteRow",index);
					//clearPatListConfigData();
				}
			})   
	    }    
	});
    
}
function endExtendItemTabEditing(){
	if (editItemIndex == undefined) { return true; }
	var rows=$('#extendItemTab').datagrid('getRows');
	if (rows[editItemIndex]["rowid"]==""){
		$('#extendItemTab').datagrid('rejectChanges', editItemIndex);
	}
    $('#extendItemTab').datagrid('endEdit', editItemIndex);
    editItemIndex = undefined;
    return true;
}
