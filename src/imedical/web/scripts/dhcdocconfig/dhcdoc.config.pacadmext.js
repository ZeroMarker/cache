var editRow=undefined;
var LocExtDataGrid;
var LocRowID="";
$(function(){ 
	InitHospList();
    $("#BFind").click(function(){
	    $('#tabAdmReasonExtConfig').datagrid('reload');
	});
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_PACAdmExt");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#Combo_AdmReason").combobox("setValue","");
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}

function Init(){
	InitComboAdmReason();
    InitAdmReasonExtGrid();
    //InitCache();
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitAdmReasonExtGrid()
{
	var ToolBar = [{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            Save();
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-undo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow = undefined;
                $('#tabAdmReasonExtConfig').datagrid("rejectChanges").datagrid("unselectAll");
            }
        }];
	var Columns=[[    
		{ field: 'BillTypeDesc', title: '费别', width: 150},
		{ field: 'BillTypeDurationDr', title:'药品疗程限制',
		  editor :{  
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindDurList&rows=99999",
					valueField:'DurRowId',
					textField:'DurCode',
					required:false,
					onBeforeLoad:function(param){
			            if (param['q']) {
							var desc=param['q'];
						}else{
							var desc="";
						}
						param = $.extend(param,{value:desc,Type:"XY",HospId:$HUI.combogrid('#_HospList').getValue()});
					},
					loadFilter: function(data){
						return data['rows'];
					}
				  }
			  },
			  formatter:function(SSRowId,record){
				  return record.BillTypeDuration;
			 }
		},
		{ field: 'BillTypeDuration', title: '', resizable: true,hidden:true
		},
		{ field: 'DiagnosCatArcimAllow', title: '允许非特病项目',align:'center',
		  editor : {
                    type : 'icheckbox',
                    options : {
                        on : 'Y',
                        off : ''
                    }
                }
		},
		{ field: 'NotAllowItemInDuration', title: '不允许疗程内重复开药',align:'center',
		  editor : {
                    type : 'icheckbox',
                    options : {
                        on : 'Y',
                        off : ''
                    }
                }
		},
		{ field: 'AllowItemCatIDStr', title: '允许的子类(项目用)',width:'200',
			editor :{  
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindCatList&rows=99999",
					valueField:'ARCICRowId',
					textField:'ARCICDesc',
					required:false,
					multiple:true,
				    rowStyle:'checkbox',
				    editable:false,
				    separator:"^",
					onBeforeLoad:function(param){
						param = $.extend(param,{value:"",HospId:$HUI.combogrid('#_HospList').getValue()});
					},
					loadFilter: function(data){
						return data['rows'];
					}
				  }
			  },
			  formatter:function(SSRowId,record){
				  return record.AllowItemCatStr;
			 }
		},
		{ field: 'NeedCheckBillType', title: '需要审批(项目用)',align:'center',
		  editor : {
                    type : 'icheckbox',
                    options : {
                        on : 'Y',
                        off : ''
                    }
                }
		}
	 ]];
	$('#tabAdmReasonExtConfig').datagrid({  
		fit : true,
		width : 'auto', //
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"BillTypeRowid",
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindBillTypeConfig&value=&HospId="+$HUI.combogrid('#_HospList').getValue(),
		pageSize: 20,
		pageList : [20,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		onClickRow:function(rowIndex, rowData){
			$('#tabAdmReasonExtConfig').datagrid("rejectChanges").datagrid("unselectAll").datagrid("beginEdit", rowIndex);
			editRow=rowIndex
		},
		onBeforeLoad:function(param){
			editRow = undefined;
			$('#tabAdmReasonExtConfig').datagrid('unselectAll')
			param = $.extend(param,{value:"",paraBillTypeRowid:$("#Combo_AdmReason").combobox("getValue"),HospId:$HUI.combogrid('#_HospList').getValue()});
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
};
function InitComboAdmReason()
{
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.CNMedCode",
	    QueryName : "FindBillTypeConfig",
	    value:"",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    rows:99999
	},function(GridData){
		$("#Combo_AdmReason").combobox({   
			valueField:'BillTypeRowid',   
    		textField:'BillTypeDesc',
    		data:GridData['rows'],
    		filter: function(q, row){
				if (q=="") return true;
				if (row["BillTypeDesc"].indexOf(q.toUpperCase())>=0) return true;
			},
			onSelect:function(){
				$('#tabAdmReasonExtConfig').datagrid('reload');
			}
		})
	});
};
function Save(){
	if(editRow == undefined){
		  return false;
	}
	var rows=$('#tabAdmReasonExtConfig').datagrid("selectRow",editRow).datagrid("getSelected");
	var BillTypeRowid=rows.BillTypeRowid;
	var editors = $('#tabAdmReasonExtConfig').datagrid('getEditors', editRow); 
	var BillTypeDurationArr=editors[0].target.combobox('getValues');
	var BillTypeDurationDr=BillTypeDurationArr.join("^");
	var DiagnosCatArcimAllow=editors[1].target.is(':checked')?1:0;
	var NotAllowItemInDuration=editors[2].target.is(':checked')?1:0;
	var AllowItemCatIDStrArr=editors[3].target.combobox('getValues');
	var AllowItemCatIDStr=AllowItemCatIDStrArr.join("^");
	var NeedCheckBillType=editors[4].target.is(':checked')?1:0;
	
	var SaveData="BillTypeDuration"+String.fromCharCode(1)+BillTypeDurationDr;
	SaveData=SaveData+String.fromCharCode(2)+"DiagnosCatArcimAllow"+String.fromCharCode(1)+DiagnosCatArcimAllow;
	SaveData=SaveData+String.fromCharCode(2)+"NotAllowItemInDuration"+String.fromCharCode(1)+NotAllowItemInDuration;
	SaveData=SaveData+String.fromCharCode(2)+"AllowItemCatIDStr"+String.fromCharCode(1)+AllowItemCatIDStr;
	//SaveData=SaveData+String.fromCharCode(2)+"NeedCheckBillType"+String.fromCharCode(1)+NeedCheckBillType;
    $.m({
		 ClassName:"DHCDoc.DHCDocConfig.CNMedCode",
		 MethodName:"SavePACAdmExtConfig",
		 BillTypeRowid:BillTypeRowid,
		 SaveData:SaveData,
		 NeedCheckBillType:NeedCheckBillType,
		 HospId:$HUI.combogrid('#_HospList').getValue()
    },function(value){
		if(value=="0"){
			$('#tabAdmReasonExtConfig').datagrid("reload");
			$.messager.popover({msg: '保存成功!',type:'success'});
		}else{
			$.messager.alert('提示',"保存失败:"+value);
			return false;
		}
    });
}