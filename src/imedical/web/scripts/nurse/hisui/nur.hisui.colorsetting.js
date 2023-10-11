var hospComp="",hospID = session['LOGON.HOSPID'],editRowIndex,colorData
var typeList=[
	{
		value:1,
		label:"������"	
	},
	{
		value:2,
		label:"���鼶��"	
	},
	{
		value:3,
		label:"����״̬"	
	},
	{
		value:4,
		label:"ҽ������"	
	},
	{
		value:5,
		label:"�Ա�"	
	},
	{
		value:6,
		label:"����"	
	}
];
$(function() {
	hospComp = GenHospComp("Nur_IP_ColorSetting",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //��ȡ�������ֵ
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "������׼�����ֻ�ҽԺ[��Ժ]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId; 
		//var type=$("#type").combobox("getValue");    
		editRowIndex=undefined;	
    	reloadDataGrid("");
	}  ///ѡ���¼�	
	
	initTable();    
    reloadDataGrid("");
    //getLinkItem("","");
    
    // ���
    $HUI.combobox("#type",
	{
		valueField:"value",
		textField:"label",
		data:typeList,
		onSelect:function(record){
			reloadDataGrid(record.value);	
		}
	});
})

// ��ʼ��table
function initTable(){
	setDataGrid = $('#dg').datagrid({
		fit : true,
		columns :[[
			{field:'rowid',title:'ID',hidden:true,editor:{type:'text'}},
	    	{field:'type',title:'���',width:150,formatter:function(value,row,index){
			    var desc="";
		    	typeList.forEach(function(val,key){
			    	if(val.value==value){
				    	desc=val.label;	
				    }	
			    })
	    		return desc;  
			},editor:{type:'combobox',options:{
		    	required:true,
		    	valueField:'value',
				textField:'label',
				data:typeList,
				onSelect:function(record){
					if(record.value==4){
						getLinkFaber("");
					}else if(record.value==5){
						getLinkSex("");
					}else if(record.value==6){
						getOther();
					}else{
						getLinkItem(record.value,"");
					}	
				},
		    }}},  
	    	{field:'itemDesc',title:'��Ŀ',width:200,formatter:function(value,row,index){
	    		return (row.type==6)&&(row.itemDR==0) ? "��λͼ��ɫ" : value;  
			},editor:{type:'combobox',options:{
		    	required:true,
		    	valueField:'rowid',
				textField:'desc',
				width:200
		    }}}, 
	    	{field:'code',title:'����',width:200,editor:{type:'validatebox',options:{required:true}}}, 
	    	{field:'color',title:'��ɫ',width:110,editor:{type:'text'},styler: function(value,row,index){				
				return 'background-color:'+value;				
			}}    
		]],
		rownumbers:true,
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
	                addCSRow();		
	            }
			},
			{
	            iconCls: 'icon-save',
	            text: '����',
	            handler: function () {
	                saveCSRow();
	            }
	        },{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
                	delCSRow();
            	}
         	}
        ],
		//pagination : true,  //�Ƿ��ҳ
		//pageSize: 15,
		//pageList : [15,30,50],
		singleSelect : true,
		loadMsg : '������..',
		onClickRow:function(rowIndex,rowData){
			if((editRowIndex!=undefined)&&(editRowIndex!=rowIndex)&&!saveCSRow()) return;
			$('#dg').datagrid("endEdit",editRowIndex);
		},
		onDblClickRow:function(rowIndex, rowData){
			if(!ifEditFlag) return;
			editRowIndex=rowIndex;
			$('#dg').datagrid("beginEdit", editRowIndex);
			var ed = $('#dg').datagrid('getEditor', {index:editRowIndex,field:'color'});
			$(ed.target).color({
				editable:true,
				required:true,
				width:110,
				height:30
			});
			if(rowData.type==4){
				getLinkFaber(rowData.itemDR);
			}else if(rowData.type==5){
				getLinkSex(rowData.itemDR);
			}else if(rowData.type==6){
				getOther();
			}else{
				getLinkItem(rowData.type,rowData.itemDR);
			}			
		}
	});  
}

// �б����ݼ���
function reloadDataGrid(category)
{
	editRowIndex=undefined;
	$.cm({
		ClassName:"Nur.NIS.Service.Base.ColorSetting",
		QueryName:"GetColorList",
		hospDR:hospID,
		category:category,
		rows:99999
	},function(data){
		colorData=data;
		setDataGrid.datagrid('loadData',data); 
	})
}

// ������
function addCSRow(){
	if((editRowIndex!=undefined)&&!saveCSRow()) return;
	editRowIndex=$('#dg').datagrid('getRows').length;
	var row={
		rowid:"",
		type:"",
		typeDesc:"",
		itemDR:"",
		itemDesc:"",
		code:"",
		color:""
	};
	$('#dg').datagrid("insertRow", {row: row}).datagrid("beginEdit", editRowIndex).datagrid("selectRow",editRowIndex);
	var ed = $('#dg').datagrid('getEditor', {index:editRowIndex,field:'color'});
	$(ed.target).color({
		editable:true,
		required:true,
		width:110,
		height:30
	});
}

// ����������
var ifEditFlag=true;
function saveCSRow() {
	if (editRowIndex==undefined) {
		return $.messager.popover({msg: '����Ҫ��������ݣ�',type:'alert'});
	}
	var rowEditors=$('#dg').datagrid('getEditors',editRowIndex);
	console.log(rowEditors);
	var rowid=$(rowEditors[0].target).val();
	var type=$(rowEditors[1].target).combobox("getValue");
	var typeDesc=$(rowEditors[1].target).combobox("getText");
	var itemDR=$(rowEditors[2].target).combobox("getValue");
	var itemDesc=$(rowEditors[2].target).combobox("getText");
	var code=$(rowEditors[3].target).val();
	var color=$(rowEditors[4].target).color("getValue");
	if(type == "")
	{
		ifEditFlag=false;
		$.messager.popover({ msg: '�����Ϊ�գ�', type:'error' });
    	return false;
	}
	if(itemDR == "")
	{
		ifEditFlag=false;
		$.messager.popover({ msg: '��Ŀ����Ϊ�գ�', type:'error' });
    	return false;
	}
	if(code == "")
	{
		ifEditFlag=false;
		$.messager.popover({ msg: '���벻��Ϊ�գ�', type:'error' });
    	return false;
	}
	if(color == "")
	{
		ifEditFlag=false;
		$.messager.popover({ msg: '��ɫ����Ϊ�գ�', type:'error' });
    	return false;
	}
	ifEditFlag=true;
	$.m({
		ClassName:"Nur.NIS.Service.Base.ColorSetting",
		MethodName:"SaveData",
		"rowid":rowid,
		"type":type,
		"itemDR":itemDR,
		"code":code,
		"color":color,
		"hospDR":hospID
	},function testget(result){				
		if(result>0){
			$('#dg').datagrid("endEdit", editRowIndex);
//			$('#dg').datagrid('updateRow',{
//				index: editRowIndex,
//				row: {
//					rowid:result,
//					type:type,
//					typeDesc:typeDesc,
//					itemDR:itemDR,
//					itemDesc:itemDesc,
//					code:code,
//					color:color
//				}
//			});
			editRowIndex=undefined;	
			reloadDataGrid("");
			return true;	
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
			return false;
		}
	});
}

// ��ȡ����������Ŀ�б�
function getLinkItem(category,itemDR){
	$cm({
        ClassName: "Nur.NIS.Service.Base.DataRelationConfig",
        QueryName: "GetDataRelationList",
        hospDR: hospID,
        category: category
    },function (obj) {
        console.log(obj);
        // ��ȡ��Ŀ�༭������������ֵ
		var ed = $('#dg').datagrid('getEditor', {index:editRowIndex,field:'itemDesc'});
		$(ed.target).combobox({
			valueField:"rowid",
			textField:"desc",
			disabled:false,
			data:obj.rows,
			onLoadSuccess:function(){
				if(itemDR!=""){
					$(this).combobox("setValue",itemDR);
					itemDR="";	
				}
			}
		});
    });		
}

// ��ȡ�����ķѱ��б�
function getLinkFaber(faberDR){
	$cm({
        ClassName: "Nur.NIS.Service.Base.ColorSetting",
        QueryName: "QueryFaberList",
        hospDR: hospID
    },function (obj) {
        console.log(obj);
        // ��ȡ��Ŀ�༭������������ֵ
		var ed = $('#dg').datagrid('getEditor', {index:editRowIndex,field:'itemDesc'});
		$(ed.target).combobox({
			valueField:"rowid",
			textField:"desc",
			disabled:false,
			data:obj.rows,
			onLoadSuccess:function(){
				if(faberDR!=""){
					$(this).combobox("setValue",faberDR);
					faberDR="";	
				}
			}
		});
    });		
}

// ��ȡ�������Ա��б�
function getLinkSex(sexDR){
	$cm({
        ClassName: "Nur.NIS.Service.Base.ColorSetting",
        QueryName: "QuerySexList"
    },function (obj) {
        console.log(obj);
        // ��ȡ��Ŀ�༭������������ֵ
		var ed = $('#dg').datagrid('getEditor', {index:editRowIndex,field:'itemDesc'});
		$(ed.target).combobox({
			valueField:"rowid",
			textField:"desc",
			disabled:false,
			data:obj.rows,
			onLoadSuccess:function(){
				if(sexDR!=""){
					$(this).combobox("setValue",sexDR);
					sexDR="";	
				}
			}
		});
    });		
}

function getOther(){
	var ed = $('#dg').datagrid('getEditor', {index:editRowIndex,field:'itemDesc'});
	$(ed.target).combobox({
		valueField:"rowid",
		textField:"desc",
		data:[{"rowid":0,"desc":"��λͼ��ɫ"}],
		disabled:true,
		onLoadSuccess:function(){
			$(this).combobox("setValue",0);
		}
	});	
}

// ɾ��ѡ�е���ɫ��������
function delCSRow(){	
	var rows=$('#dg').datagrid("getSelections");
	if (rows.length == 1) {
		$.messager.confirm("����ʾ", "ȷ��Ҫɾ������ɫ������", function (r) {
			if (r) {
				if(rows[0].rowid){
					$.m({
						ClassName:"Nur.NIS.Service.Base.ColorSetting",
						MethodName:"DeleteConfig",
						"rowid":rows[0].rowid
					},function testget(result){
						if(result == "0"){
							$.messager.popover({msg:"ɾ���ɹ���", type:'success'});			
							reloadDataGrid();						
						}else{	
							$.messager.popover({ msg: "ɾ��ʧ�ܣ�", type:'error' });	
						}
					}); 	
				}else{					
					$("#dg").datagrid("deleteRow",editRowIndex);					
					$.messager.popover({msg:"ɾ���ɹ���", type:'success'});	
				}
				editRowIndex=undefined;				
			}
		});				
 	}else{
    	$.messager.alert("����ʾ", "��ѡ��Ҫɾ������������", "info");
 	}
}