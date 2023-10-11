var hospComp="",hospID = session['LOGON.HOSPID']
var typeList=[
	{
		value:1,
		label:"护理级别"	
	},
	{
		value:2,
		label:"病情级别"	
	},
	{
		value:3,
		label:"处置状态"	
	}
];
var sourceList=[
	{
		value:1,
		label:"医嘱"	
	}
];
$(function() {
	hospComp = GenHospComp("Nur_IP_DataRelationConfig",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //获取下拉框的值
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "东华标准版数字化医院[总院]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;     	
    	reloadDataGrid();
	}  ///选中事件	
	
	initTable();    
    reloadDataGrid();
    
    // 类别
    $HUI.combobox("#type",
	{
		valueField:"value",
		textField:"label",
		data:typeList
	});
	    
    // 数据来源
    $HUI.combobox("#source",
	{
		valueField:"value",
		textField:"label",
		data:sourceList,
		onSelect:function(record){
			if(record.value==1){ // 医嘱
				$('#add-dialog').dialog({height: 288}).dialog("open"); 
				$("#form tr.linkord").show();
				getLinkOrderData("");	
			}else{				
				$('#add-dialog').dialog({height: 246}).dialog("open");	
				$("#form tr.linkord").hide();
				$HUI.combogrid("#linkOrd")			
			}
		},
		onChange:function(record){
			if(!record){
				$('#add-dialog').dialog({height: 246}).dialog("open");	
				$("#form tr.linkord").hide();
				$HUI.combogrid("#linkOrd")	
			}				
		}
	});
})

// 初始化table
function initTable(){
	setDataGrid = $('#dg').datagrid({
		fit : true,
		columns :[[
	    	{field:'desc',title:'描述',width:150},  
	    	{field:'code',title:'编码',width:150}, 
	    	{field:'arcimcodeS',title:'医嘱Code串',width:300}, 
	    	{field:'drcType',title:'类别',width:150,formatter:function(value,row,index){
		    	var desc="";
		    	typeList.forEach(function(val,key){
			    	if(val.value==value){
				    	desc=val.label;	
				    }	
			    })
	    		return desc;
	    	}},    
	    	{field:'source',title:'数据来源',width:150,formatter:function(value,row,index){
		    	var desc="";
		    	sourceList.forEach(function(val,key){
			    	if(val.value==value){
				    	desc=val.label;	
				    }	
			    })
	    		return desc;
	    	}},    
		]],
		rownumbers:true,
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '新增',
	            handler: function () {
	                $('#add-dialog').dialog({height: 246,title:"新增数据关系配置"}).dialog("open");	
	                $('#form').form("clear");
					$("#form tr.linkord").hide();
					$HUI.combogrid("#linkOrd")		
	            }
			},
			{
	            iconCls: 'icon-write-order',
	            text: '修改',
	            handler: function () {
	                updateData();
	            }
	        },{
            	iconCls: 'icon-cancel',
            	text: '删除',
            	handler: function () {
                	delData();
            	}
         	},{
	            text: '翻译',
	            iconCls: 'icon-translate-word',
	            handler: function() {
		            Translate("dg","CT.NUR.NIS.DataRelationConfig","DRCDesc","desc")	
	            }
	        }
        ],
		pagination : true,  //是否分页
		pageSize: 15,
		pageList : [15,30,50],
		singleSelect : true,
		loadMsg : '加载中..' 
	});  
}

// 列表数据加载
function reloadDataGrid()
{
	$.cm({
		ClassName:"Nur.NIS.Service.Base.DataRelationConfig",
		QueryName:"GetDataRelationList",
		hospDR:hospID,
		category:"",
		rows:99999
	},function(data){
		setDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',data); 
	})
}

// 获取关联医嘱列表
function getLinkOrderData(arcimCodeS,arcimDescS) {	
	//医嘱类型
	$HUI.combogrid("#linkOrd", {
		panelWidth: 520,
		panelHeight: 350,
		delay:500,
		mode:'remote',
		idField: 'ArcimCode',
		textField: 'ArcimDesc',
		columns: [[
			{field:'ArcimDesc',title:'项目名称',width:100},
			{field:'ArcimCode',title:'项目Code',width:50}
		]],
		pagination : true,
		//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindMasterItem&arcimdesc=",
		url:$URL+"?ClassName=Nur.NIS.Service.NursingGrade.DataConfig&QueryName=FindMasterItem&arcimdesc=",
		fitColumns: true,
		enterNullValueClear:true,
		multiple:true,
		onBeforeLoad:function(param){
			if(arcimDescS){
				param['q']=arcimDescS;
				arcimDescS=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{arcimdesc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		},
		onLoadSuccess:function(){
			if(arcimCodeS){
	            $(this).combogrid('setValues', arcimCodeS.split("^"));
	            arcimCodeS="";     
	        }
		}
	});
}

// 修改选中的配置数据时，数据回显
function updateData(){	
	var rows=$('#dg').datagrid("getSelections");
	if (rows.length == 1) {
   		$("#add-dialog").dialog("open");
   		if(rows[0].source==1){
	   		$('#add-dialog').dialog({height: 288,title:"修改数据关系配置"}).dialog("open"); 
			$("#form tr.linkord").show();
	   		getLinkOrderData(rows[0].arcimcodeS,rows[0].arcimDescS)
	   	} 		
	   	$('#form').form("clear");
	 	$('#form').form("load",{
	 		Rowid: rows[0].rowid,
	 		Desc: rows[0].desc,
	 		Code: rows[0].code,
	 		Type: rows[0].drcType,
	 		Source: rows[0].source
 		}); 			
 	}else{
    	$.messager.alert("简单提示", "请选择要修改的配置数据", "info");
 	}
}

function saveData(){
	var rowid=$.trim($("#rowid").val());
	var desc=$.trim($("#desc").val());
	var code=$.trim($("#code").val());
	var type=$("#type").combobox('getValue');
	var source=$("#source").combobox('getValue');
	var arcimCode=[];
	if(source==1){
		arcimCode=$HUI.combogrid('#linkOrd').getValues();	
	}		
	if(code == "")
	{
		$.messager.popover({ msg: '编码不能为空！', type:'error' });
    	return false;
	}
	if(type == "")
	{
		$.messager.popover({ msg: '类别不能为空！', type:'error' });
    	return false;
	}
	if(source==1 && arcimCode.length==0)
	{
		$.messager.popover({ msg: '关联医嘱不能为空！', type:'error' });
    	return false;
	}
	$.m({
		ClassName:"Nur.NIS.Service.Base.DataRelationConfig",
		MethodName:"SaveData",
		"rowid":rowid,
		"desc":desc,
		"code":code,
		"type":type,
		"source":source,
		"arcimCodeS":arcimCode.length==0 ? "" : arcimCode.join("^"),
		"hospDR":hospID
	},function testget(result){		
		if(result == "0"){	
			$('#add-dialog').dialog("close");			
			$.messager.popover({msg:"保存成功！", type:'success'});			
			reloadDataGrid();						
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
		}
	});	
}

// 删除选中的配置数据
function delData(){	
	var rows=$('#dg').datagrid("getSelections");
	if (rows.length == 1) {
		$.messager.confirm("简单提示", "确定要删除该配置数据吗？", function (r) {
			if (r) {
				$.m({
					ClassName:"Nur.NIS.Service.Base.DataRelationConfig",
					MethodName:"DeleteConfig",
					"rowid":rows[0].rowid
				},function testget(result){
					if(result == "0"){
						$.messager.popover({msg:"删除成功！", type:'success'});			
						reloadDataGrid();						
					}else{	
						$.messager.popover({ msg: "删除失败！", type:'error' });	
					}
				}); 
			}
		});				
 	}else{
    	$.messager.alert("简单提示", "请选择要删除的配置数据", "info");
 	}
}

// 翻译
function Translate(tableId,className,fieldName,key){
	var selectedRow=$("#"+tableId).datagrid("getSelections");
	if(selectedRow.length>0){
		CreatTranLate(className,fieldName,selectedRow[0][key]);
	}else{
		$.messager.popover({msg:'请选择要翻译的数据！',type:'alert'});
	}		
}