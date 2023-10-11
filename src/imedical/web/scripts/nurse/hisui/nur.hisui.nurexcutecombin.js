var hospID=session['LOGON.HOSPID'],groupID=session['LOGON.GROUPID'],wardID=session['LOGON.WARDID'],locID=session['LOGON.CTLOCID'],userID=session['LOGON.USERID'];
var typeList=[
	{
		value:"0",
		label:$g("ҽ���ӷ���")	
	},{
		value:"1",
		label:$g("ҽ���÷�")
	},{
		value:"2",
		label:$g("ҽ����")	
	},{
		value:"3",
		label:$g("��ӡ���")	
	},{
		value:"4",
		label:$g("����״̬")
	},{
		value:"5",
		label:$g("��ҩ״̬")	
	},{
		value:"6",
		label:$g("���տ���")	
	},{
		value:"7",
		label:$g("ִ���豸")	
	},{
		value:"8",
		label:$g("�걾����")	
	}
];
$(function(){
	// ����
	getSheets("");
	// ����
	$("#type").combobox({
		valueField:"value",
		textField:"label",
		data:typeList,
		onSelect:function(record){
			$("#itemset").form("load",{Item:[],Order:[]})
			if(record.value=="2"){
				$(".item").hide();
				$(".order").show();
				getLinkOrderData("order","","");	
			}else{
				$(".item").show();
				$(".order").hide();
				getLinkList("item",record.value,"");
			}	
		}	
	});
	$("#type").combobox("setValue","0");
	$("#operType").combobox({
		valueField:"value",
		textField:"label",
		editable:false,
		data:[{value:"F",label:$g("ɸѡ")},{value:"E",label:$g("�ų�")}]
	});
	$("#operType").combobox("setValue","F");
	getLinkList("item","0","");
	// ��ʼ��table
	initCondition();
	reloadConditionGrid()
	
	initItem();
})
// ��ȡ��ǰ��������
function getSheets(sheetId)
{
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		MethodName:"GetCurrentSheets",
		groupID:groupID,
		locId:locID,
		rows:99999
	},function(data){
		$("#sheet").combobox({
			valueField:"rowId",
			textField:"desc",
			data:data,
			onLoadSuccess:function(){
				if(sheetId){
					$(this).combobox("setValue",sheetId);
					sheetId="";	
				}	
			}
		});
	})	
}
// �������ͻ�ȡ��Ӧ����Ŀ�б�
function getLinkList(obj,type,idStr){
	if(type=="0"){ // ҽ���ӷ���
		getLinkOrdCat(obj,idStr);
	}else if(type=="1"){ // �÷�
		getLinkOrdPhcin(obj,idStr);
	}else if(type=="3"){ // ��ӡ���
		getLinkPrintFlag(obj,idStr);
	}else if(type=="4"){ // ����״̬
		getLinkDispStatus(obj,idStr);
	}else if(type=="5"){ // ��ҩ״̬
		getLinkDrugInfo(obj,idStr);
	}else if(type=="6"){ // ���տ���
		getLinkLoc(obj,idStr);
	}else if(type=="7"){
		//renderCombobox(obj,idStr,[{ID:"emergency",Desc:"�Ӽ�"}]);
		renderCombobox(obj,idStr,[{ID:"PC",Desc:"PC"},{ID:"PDA",Desc:"PDA"}]);
	}else if(type=="8"){ //�걾����
		getLinkSpecimenName(obj,idStr);
	}	
}
// �����ı걾����
function getLinkSpecimenName(obj,idStr){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetSpecimenName",
		HospId:session['LOGON.HOSPID'],
		rows:99999
	},function(data){
		renderCombobox(obj,idStr,data);
	})		
}
// �����ķ�ҩ״̬
function getLinkDrugInfo(obj,idStr){
	$HUI.combobox("#"+obj,
	{
		valueField:"value",
		textField:"label",
		multiple:true,
		data:[{value:"TC",label:$g("δ��ҩ")},{value:"C",label:$g("�ѷ�ҩ")},{value:"PC",label:$g("���ַ�")}]
	});
	if(idStr){
		$("#"+obj).combobox("setValues",idStr.split("^"));	
	}	
}
// ��ȡ����������
function getLinkOrdCat(obj,idStr){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetOrdCat",
		hospId:hospID,
		rows:99999
	},function(data){
		renderCombobox(obj,idStr,data);
	})	
}
// ��ȡ�������÷�
function getLinkOrdPhcin(obj,idStr){	
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetOrdPhcin",
		rows:99999
	},function(data){
		renderCombobox(obj,idStr,data);
	})	
}
// ��ȡ����ҽ���б�
function getLinkOrderData(obj,arcItmDR,arcItmName) { 	
	//ҽ������
	$("#"+obj).combogrid({
		headerCls:'panel-header-gray',
		panelWidth: 500,
		panelHeight: 350,
		delay:500,
		mode:'remote',
		idField: 'ArcimDR',
		textField: 'ArcimDesc',
		columns: [[
			{field:'ArcimDesc',title:'��Ŀ����',width:100},
			{field:'ArcimDR',title:'��ĿID',width:30}
		]],
		pagination : true,
		//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindMasterItem&arcimdesc=",
		url:$URL+"?ClassName=Nur.NIS.Service.NursingGrade.DataConfig&QueryName=FindMasterItem&arcimdesc=",
		fitColumns: true,
		enterNullValueClear:true,
		multiple:true,
		onBeforeLoad:function(param){   
			if(arcItmName){
				param['q']=arcItmName;
				arcItmName=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{arcimdesc:desc,HospId:hospID});
		},
		onLoadSuccess:function(){			 
			if(arcItmDR){
	            $(this).combogrid('setValues', arcItmDR.split("^"));
	            arcItmDR="";     
	        }
		}
	})
}
// ����״̬
function getLinkDispStatus(obj,idStr){
	$.cm({
		ClassName:"Nur.NIS.Service.Base.DataRelationConfig",
		QueryName:"GetDataRelationList",
		hospDR:hospID,
		category:"3", // ����״̬
		transFlag:"Y",
		rows:99999
	},function(data){
		$("#"+obj).combobox({
			valueField:"rowid",
			textField:"desc",
			data:data.rows,
			multiple:true,
			onLoadSuccess:function(){
				if(idStr){
					$(this).combobox("setValues",idStr.split("^"));
					idStr="";	
				}	
			}
		});
	})		
}
// �������տ���
function getLinkLoc(obj,idStr){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetLoc",
		rows:99999
	},function(data){
		renderCombobox(obj,idStr,data);
	})		
}
function renderCombobox(obj,idStr,data){
	$("#"+obj).combobox({
		valueField:"ID",
		textField:"Desc",
		data:data.rows ? data.rows : data,
		multiple:true,
		onLoadSuccess:function(){
			if(idStr){
				$(this).combobox("setValues",idStr.split("^"));
				idStr="";	
			}	
		}
	});
}
// ��ӡ���
function getLinkPrintFlag(obj,idStr){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetPrintConfig",
		QueryName:"QuerySheetPrtSignConfig",
		transFlag:"Y",
		rows:99999
	},function(data){
		$("#"+obj).combobox({
			valueField:"SPSSCode",
			textField:"SPSSDesc",
			data:data.rows,
			multiple:true,
			onLoadSuccess:function(){
				if(idStr){
					$(this).combobox("setValues",idStr.split("^"));
					idStr="";	
				}	
			}
		});
	})
	/*$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetAllExecuteButton",
		hospId:hospID,
		rows:99999
	},function(data){
		var newData=[];
		var record=data.rows;
		if(record.length>0){
			record.forEach(function(val,index){
				if(val.PrintFlag!=""){
					newData.push(val);	
				}	
			})
		}
		console.log(newData);
		$("#"+obj).combobox({
			valueField:"PrintFlag",
			textField:"PrintFlagDesc",
			data:newData,
			multiple:true,
			onLoadSuccess:function(){
				if(idStr){
					$(this).combobox("setValues",idStr.split("^"));
					idStr="";	
				}	
			}
		});
	})*/
}
// ��ʼ����������
function initCondition(){
	$('#dg').datagrid({
		headerCls:'panel-header-gray',
		fit : true,
		rownumbers:true,
		itColumns:true,
		columns :[[ 
	    	{field:'SheetDesc',title:'����',width:150},
	    	{field:'Desc',title:'����'}	    	 
	    ]],
	    ///toolbar:"#conditionset",
		singleSelect : true,
		loadMsg : '������..',
		onClickRow:function(rowIndex,rowData){
			$("#conditionset").form("clear");
			$("#conditionset").form("load",{Sheet:rowData.sheetId,Condition:rowData.Desc});	
			$("#itemset").form("clear");
			$("#itemset").form("load",{Type:"0",Item:[],Order:[]});	
			$("#operType").combobox("setValue","F");
			getLinkList("item","0","");		
			reloadItemGrid(rowData.ID);
		}
	});	
}
function reloadConditionGrid(){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetCombinedQuery",
		wardId:wardID,
		groupId:groupID,
		rows:99999
	},function(data){
		$("#dg").datagrid("loadData",data);
	})	
}
// ��ʼ����Ŀ����
function initItem(){
	$('#dg2').datagrid({
		headerCls:'panel-header-gray',
		fit : true,
		rownumbers:true,
		itColumns:true,
		columns :[[ 
	    	{field:'type',title:'����',width:150,formatter:function(value,row,index){
		    	var desc=""
		    	var newData=typeList.filter(function(item){
					return value==item.value;	
				})
				if(newData.length>0) desc=newData[0].label;
				return desc;
		    }},
	    	{field:'itemDesc',title:'��Ŀ',formatter:function(value,row,index){
		    	return value ? value.replace(/\^/g,"��") : value;	
		    }},
		    {field:'operTypeDesc',title:'����',formatter:function(value,row,index){
			    return $g(value);
			 }}   	 
	    ]],
	    ///toolbar:"#itemset",
		singleSelect : true,
		loadMsg : '������..',
		onClickRow:function(rowIndex,rowData){
			$("#itemset").form("clear");
			$("#itemset").form("load",{Type:rowData.type});
			if(rowData.type=="2"){
				$(".item").hide();
				$(".order").show();
				var itemDesc=rowData.itemDesc.replace("^",",")
				getLinkOrderData("order",rowData.item,itemDesc);	
			}else{
				$(".item").show();
				$(".order").hide();
				getLinkList("item",rowData.type,rowData.item);	
			}
			$("#operType").combobox("setValue",rowData["operType"])
		}
	});	
}
function reloadItemGrid(conditionId){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetCombinedQuerySub",
		CQRowID:conditionId,
		rows:99999
	},function(data){
		$("#dg2").datagrid("loadData",data);
	})	
}
// ��������ά��
function handleCondition(event,flag){
	var rowID="";
	if(event=="DELETE" || !flag){ // ɾ��/�޸�
		var rows=$("#dg").datagrid("getSelections");
		if(rows.length>0){
			rowID=rows[0].ID;	
		}else{
			var msg=event=="DELETE" ? "ɾ��" : "�޸�";
			return $.messager.popover({ msg: "��ѡ��Ҫ"+msg+"�����ݣ�", type:'info' });		
		}
	}
	if(event=="DELETE"){
		$.messager.confirm("����ʾ", "ȷ��Ҫɾ��������������", function (r) {
			if (r) {
				setCondition(event,flag,rowID);
			}
		});	
	}else{
		setCondition(event,flag,rowID);	
	}			
}
function setCondition(event,flag,rowID){
	var sheetId=$("#sheet").combobox("getValue");
	var desc=$.trim($("#condition").val());	
	desc=flag==2 ? desc+"-����" : desc;
	$.m({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		MethodName:"HandleCondition",
		"rowID":rowID,
		"sheetId":sheetId,
		"desc":desc,
		"wardId":wardID,
		"groupId":groupID,
		"userId":userID,
		"event":event
	},function testget(result){
		var msg=event=="SAVE" ? "����" : "ɾ��";
		if(result>=0){
			$.messager.popover({ msg: msg+"�ɹ���", type:'success' });
			$('#conditionset').form("clear");
			if(flag==2){ // ����
				var itemRows=$("#dg2").datagrid("getRows");
				if(itemRows.length>0){
					for(var i=0;i<itemRows.length;i++){
						handleItem(result,"",itemRows[i].type,itemRows[i].item,itemRows[i].operType,"SAVE");
					}			
				}		
			}
			reloadConditionGrid();	
			if(event=="DELETE") $("#dg2").datagrid("loadData",[]);					
		}else{
			$.messager.popover({ msg: result, type:'error' });	
		}
	});		
}
// ��Ŀ����ά��
function handleCombinedQuerySub(event,flag){
	var selRows=$("#dg").datagrid("getSelections");
	if(selRows.length>0){
		var CQRowID=selRows[0].ID;
		var rowID="";
		if(event=="DELETE" || !flag){ // ɾ��/�޸�
			var rows=$("#dg2").datagrid("getSelections");
			if(rows.length>0){
				rowID=rows[0].ID;	
			}else{
				var msg=event=="DELETE" ? "ɾ��" : "�޸�";
				return $.messager.popover({ msg: "��ѡ��Ҫ"+msg+"�����ݣ�", type:'info' });		
			}
		}
		var type=$("#type").combobox("getValue");
		// �ж��Ƿ�����ظ�����
		var repeatFlag=false;
		var itemRows=$("#dg2").datagrid("getRows");
		if(itemRows.length>0){
			itemRows.forEach(function(val,index){
				if(val.ID!=rowID){
					if(val.type==type) repeatFlag=true;	
				}	
			});	
		}
		if(repeatFlag) return $.messager.popover({ msg: "�������Ѵ��ڣ������ظ���ӣ�", type:'alert' });		
		var item="";
		var itemArr=type=="2" ? $("#order").combobox("getValues") : $("#item").combobox("getValues");
		if(itemArr.length>0) item=itemArr.join("^");
		var operType=$("#operType").combobox('getValue');
		handleItem(CQRowID,rowID,type,item,operType,event);	
	}else{
		$.messager.popover({ msg: "��ѡ�������������ݣ�", type:'info' });	
	}		
}
function handleItem(CQRowID,rowID,type,item,operType,event){
	$.m({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		MethodName:"HandleCombinedQuerySub",
		"CQRowID":CQRowID,
		"rowID":rowID,
		"type":type,
		"item":item,
		"userId":userID,
		"operType":operType,
		"event":event
	},function testget(result){
		var msg=event=="SAVE" ? "����" : "ɾ��";
		if(result==0){
			$.messager.popover({ msg: msg+"�ɹ���", type:'success' });
			$("#itemset").form("clear");
			$("#itemset").form("load",{Type:"0",Item:[],Order:[]});
			$("#type").combobox("setValue","0");	
			getLinkList("item","0","");	
			$("#operType").combobox("setValue","F");	
			reloadItemGrid(CQRowID);								
		}else{
			$.messager.popover({ msg: msg+"ʧ�ܣ�", type:'error' });	
		}
	});	
}
// ����
function copy(){
	var selRows=$("#dg").datagrid("getSelections");
	if(selRows.length>0){
		handleCondition("SAVE",2);		
	}else{
		$.messager.popover({ msg: "��ѡ��Ҫ���Ƶ��������ã�", type:'info' });
	}
}
	