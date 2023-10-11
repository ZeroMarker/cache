var PageLogicObj={
	m_WardJson:""
}
editRow = undefined;
$(function(){
	InitHospList();
	InitEvent();
});
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_StatsDataSourceConfig","",{width:205});
	hospComp.jdata.options.onSelect = function(e,t){
		RefreshData();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	InitWardJson();
	InitReportListTabTab();
	InitReportItemListTab();
}
function InitEvent(){
	$("#BReportCopy").click(ReportCopyHandle);
	$("#BCancel").click(function(){
	 	$("#CopyWin").window('close');
	});
}
function RefreshData(){
	$("#ReportListTab").datagrid("reload");
	$('#ReportItemListTab').datagrid("loadData", {"rows":[],"total":0});
}
function InitWardJson(){
	PageLogicObj.m_WardJson=$.cm({
		ClassName:"Nur.NIS.Service.ReportV2.LocUtils",
		QueryName:"NurseCtloc",
		desc:"",
		hosId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},false)
}
function InitReportListTabTab(){
	var ToolBar = [{
			text: '����',
			iconCls: '	icon-add',
			handler: function() {
				if (editRow == undefined) {
					var maxRow=$("#ReportListTab").datagrid("getRows");
					$("#ReportListTab").datagrid("appendRow", {
	                    ReportRowId: ''
	                })
	                editRow=maxRow.length-1;
	                $("#ReportListTab").datagrid("beginEdit", editRow);
	                var editors = $("#ReportListTab").datagrid('getEditors', editRow);
					$(editors[0].target).focus();
					$('#ReportItemListTab').datagrid("loadData", {"rows":[],"total":0});
				}else{
					$.messager.popover({msg: '�����ڱ༭���У����ȵ������!',type: 'error'});
				}
			}
		},{
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: function() {
				var rows = $("#ReportListTab").datagrid("getSelections");
				if (rows.length > 0) {
					$.messager.confirm("��ʾ", "ȷ��ɾ����?",
	                function(r) {
	                    if (r) {
							var ids = [];
	                        for (var i = 0; i < rows.length; i++) {
	                            ids.push(rows[i].ReportRowId);
	                        }
	                        var ID=ids.join(',');
	                        if (ID==""){
	                            editRow = undefined;
				                $("#ReportListTab").datagrid("rejectChanges").datagrid("unselectAll");
				                return;
	                        }
	                        var value=$.m({ 
								ClassName:"Nur.NIS.Service.ReportV2.ReportConfig", 
								MethodName:"HandleReport",
								rowID:ID, event:"DELETE"
							},false);
					        if(value=="0"){
						       $('#ReportListTab').datagrid('deleteRow',$('#ReportListTab').datagrid('getRowIndex',ID));
						       $('#ReportItemListTab').datagrid("loadData", {"rows":[],"total":0});
	   					       $.messager.popover({msg: 'ɾ���ɹ�!',type: 'success'});
					        }else{
						       $.messager.popover({msg: 'ɾ��ʧ��:'+value,type: 'error'});
					        }
					        editRow = undefined;
	                    }
	                });
				}else{
					$.messager.popover({msg: '��ѡ��Ҫɾ������!',type: 'error'});
				}
			}
	    },{
			text: '����',
			iconCls: 'icon-save',
			handler: function() {
				 if (editRow != undefined) {
					var rows=$("#ReportListTab").datagrid("selectRow",editRow).datagrid("getSelected");
					var editors = $("#ReportListTab").datagrid('getEditors', editRow);
					var name = editors[0].target.val();
					if(name==""){
						$.messager.popover({msg: '�����Ʋ���Ϊ��!',type: 'error'});
						$(editors[0].target).focus();
						return false;
					};
					var validLocs=editors[1].target.combobox("getValues").join("^");
					var inValidLocs=editors[2].target.combobox("getValues").join("^");
					var ReportRowId = rows.ReportRowId;
					if (!ReportRowId) ReportRowId="";
	                $.m({ 
						ClassName:"Nur.NIS.Service.ReportV2.ReportConfig", 
						MethodName:"HandleReport",
						rowID:ReportRowId,
						name:name,
						validLocs:validLocs,
						inValidLocs:inValidLocs,
						hospId:$HUI.combogrid('#_HospList').getValue(),
						event:"SAVE"
					},function(rtn){
						if(rtn==0){
						   editRow = undefined;
						   $("#ReportListTab").datagrid('unselectAll').datagrid('load');
						   $('#ReportItemListTab').datagrid("loadData", {"rows":[],"total":0});
						   $.messager.popover({msg: '����ɹ�!',type: 'success'});
						}else{
							$.messager.popover({msg: '����ʧ��:'+rtn,type: 'error'});
						    return false;
						}
					}); 
				 }
			}
	    },'-',{
			text: '����',
			iconCls: 'icon-copy',
			handler: function() {
				var selected = $("#ReportListTab").datagrid("getSelected");
				if (!selected) {
					$.messager.popover({msg: '��ѡ����Ҫ���Ƶı���',type: 'error'});
					return false;
				}else if(!selected.ReportRowId){
					$.messager.popover({msg: '��ѡ���ѱ���ı���',type: 'error'});
					return false;
				}
				$("#CopyWin" ).window({
				   modal: true,
				   collapsible:false,
				   minimizable:false,
				   maximizable:false,
				   closed:true
				}).window('open');
				$("#CopyReportName").val("").focus();
				$("#CopyReportName").val(selected.ReportName+"-����");
			}
	    }];
	var Columns=[[
		{ field: 'ReportRowId', title: 'ID',width:50},
		{ field: 'ReportName', title: '������',width:160, editor : 
			{type : 'text',options : {required:true}}
		},
		{ field: 'ReportValidLocs', title: '���÷�Χ',width:180, editor : 
			{
				type:'combobox',  
				options:{
					mode: "local",
					valueField:'locID',
					textField:'locDesc',
					mode: "local",
					multiple:true,
					rowStyle:"checkbox",
					data:PageLogicObj.m_WardJson.rows
				}
			},
			formatter: function(value,row,index){
				return row["ReportValidLocsDesc"];
			}
		},
		{ field: 'ReportInValidLocs', title: '�����÷�Χ',width:180, editor : 
			{
				type:'combobox',  
				options:{
					mode: "local",
					valueField:'locID',
					textField:'locDesc',
					mode: "local",
					multiple:true,
					rowStyle:"checkbox",
					data:PageLogicObj.m_WardJson.rows
				}
			},
			formatter: function(value,row,index){
				return row["ReportInValidLocDescs"];
			}
		}
	]];
	$('#ReportListTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : false,
		pagination:true,
		pageSize:20,
		pageList:[20,50,100],
		idField:"ReportRowId",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.ReportV2.ReportConfig&QueryName=GetReportList",
		onBeforeLoad:function(param){
			$('#ReportListTab').datagrid("unselectAll");
			param = $.extend(param,{
				HospId:$HUI.combogrid('#_HospList').getValue(),
				SearchName:$("#SearchName").searchbox("getValue")
			});
		},
		onDblClickRow:function(rowIndex, rowData){ 
            if (editRow != undefined) {
	            $.messager.popover({msg: '�����ڱ༭���У����ȵ������!',type: 'error'});
		        return false;
			}
			$('#ReportListTab').datagrid("beginEdit", rowIndex);
			editRow=rowIndex;
       },
       onClickRow:function(rowIndex, rowData){
	       $("#ReportItemListTab").datagrid("reload")
	   }
	})
}
function GetSelReportId(){
	var rows = $("#ReportListTab").datagrid("getSelected");
	if (rows){
		return rows["ReportRowId"] || "";
	}
	return "";
}
function InitReportItemListTab(){
	var ToolBar = [{
			text: '����',
			iconCls: '	icon-add',
			handler: function() {
					var ReportRowId=GetSelReportId();
					if (!ReportRowId){
						$.messager.popover({msg: '����ѡ����Ч�ı���',type: 'error'});
		        		return false;
					}
					var maxRow=$("#ReportItemListTab").datagrid("getRows");
					$("#ReportItemListTab").datagrid("appendRow", {
	                    ReportItemRowId: ''
	                })
	                $("#ReportItemListTab").datagrid("beginEdit", maxRow.length-1);
	                var editors = $("#ReportItemListTab").datagrid('getEditors', maxRow.length-1);
					$(editors[0].target).focus();
					var target=$('#ReportItemListTab').datagrid('getEditor',{'index':maxRow.length-1,'field':'ReportItemAlternativeVal'}).target;
	        		$(target).attr("placeHolder","���ѡ����^�ָ�");
			}
		},{
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: function() {
				var selRows = $("#ReportItemListTab").datagrid("getSelections");
				if (selRows.length > 0) {
					$.messager.confirm("��ʾ", "ȷ��ɾ����?",
	                function(r) {
	                    if (r) {
		                    var ErrMsg=[];
							var ids = [];delSeqNoObj={};
							var rows = $("#ReportItemListTab").datagrid("getSelections");
	                        for (var i = 0; i < selRows.length; i++) {
	                            var ReportItemRowId=selRows[i].ReportItemRowId;
	                            var ReportItemSeqNo=selRows[i].ReportItemSeqNo;
	                            ids.push(ReportItemRowId);
	                            if ((ReportItemSeqNo!="")&&(ReportItemRowId)){
		                            var index=$("#ReportItemListTab").datagrid("getRowIndex",ReportItemRowId);
		                            delSeqNoObj[ReportItemSeqNo]=index+1;
		                        }
	                        }
	                        var ID=ids.join(',');
	                        if (ID==""){
				                $("#ReportItemListTab").datagrid("rejectChanges").datagrid("unselectAll");
				                return;
	                        }
	                        var rows=$("#ReportItemListTab").datagrid("getRows");
	                        for (var i=0;i<rows.length;i++){
		                        var ReportItemSeqNo=rows[i]["ReportItemSeqNo"];
		                        if (ReportItemSeqNo){
			                        var ItemSeqNoArr=ReportItemSeqNo.split(".");
			                        if (ItemSeqNoArr.length ==2){
				                        if (delSeqNoObj[ItemSeqNoArr[0]]){
					                        ErrMsg.push("��"+delSeqNoObj[ItemSeqNoArr[0]]+"�д�������ţ����ʵ!");
					                    }
				                    }else if(ItemSeqNoArr.length ==3){
					                    if (delSeqNoObj[ItemSeqNoArr[0]+"."+ItemSeqNoArr[1]]){
						                    ErrMsg.push("��"+delSeqNoObj[ItemSeqNoArr[0]+"."+ItemSeqNoArr[1]]+"�д�������ţ����ʵ!");
					                    }
					                }
			                    }
		                    }
		                    if (ErrMsg.length>0){
								$.messager.popover({msg: ErrMsg.join("</br>"),type: 'error'});
								return false;
							}
	                        var value=$.m({ 
								ClassName:"Nur.NIS.Service.ReportV2.ReportConfig", 
								MethodName:"HandleReportItem",
								SaveDataArr:JSON.stringify(ids), event:"DELETE"
							},false);
					        if(value=="0"){
						       for (var i = 0; i < ids.length; i++) {
	                              var index=$('#ReportItemListTab').datagrid("getRowIndex",ids[i]);
	                              $('#ReportItemListTab').datagrid('deleteRow',index);
	                           }
	   					       $.messager.popover({msg: 'ɾ���ɹ�!',type: 'success'});
					        }else{
						       $.messager.popover({msg: 'ɾ��ʧ��:'+value,type: 'error'});
					        }
	                    }
	                });
				}else{
					$.messager.popover({msg: '��ѡ��Ҫɾ������!',type: 'error'});
				}
			}
	    },{
			text: '����',
			iconCls: 'icon-save',
			handler: function() {
				var ReportRowId=GetSelReportId();
				if (!ReportRowId){
					$.messager.popover({msg: '����ѡ����Ч�ı���',type: 'error'});
	        		return false;
				}
				var MsgArr=[]; //������Ϣ��ʾ����
				var SeqNoVerify={}; //������֤��ŵĸ�����Ƿ����
				var SaveDataArr=[],ReportItemNameObj={},ReportItemSeqObj={};
				var rows=$("#ReportItemListTab").datagrid("getRows");
				for (var i=0;i<rows.length;i++){
					var editors = $("#ReportItemListTab").datagrid('getEditors', i);
					if (editors.length==0) {
						ReportItemNameObj[rows[i]["ReportItemName"]]=1;
						if (rows[i]["ReportItemSeqNo"]!=""){
							ReportItemSeqObj[rows[i]["ReportItemSeqNo"]]=1;
						}
						continue;
					}
					var SSReportItemName = $.trim(editors[0].target.val());
					if(SSReportItemName==""){
						$.messager.popover({msg: '��'+(i+1)+'�� ��������Ϊ��!',type: 'error'});
						$(editors[0].target).focus();
						return false;
					};
					var SSReportItemDataType = editors[1].target.combobox("getValue");
					if(SSReportItemDataType==""){
						$.messager.popover({msg: '��'+(i+1)+'���������Ͳ���Ϊ��!',type: 'error'});
						$(editors[1].target).next('span').find('input').focus();
						return false;
					};
					if (SSReportItemDataType=="ManualEntry" || SSReportItemDataType=="EmptyHeader"){
						var SSReportItemLinkSource=editors[2].target.combobox("getText");
					}else{
						var SSReportItemLinkSource=editors[2].target.combobox("getValue");
						if ($.hisui.indexOfArray(editors[2].target.combobox("getData"),"SourceRowId",SSReportItemLinkSource)<0){
							$.messager.popover({msg: '��'+(i+1)+'��������������ѡ��������ݣ�',type: 'error'});
							$(editors[2].target).next('span').find('input').focus();
							return false;
						}
					}
					if((SSReportItemLinkSource=="")&&(SSReportItemDataType!="ManualEntry")&&(SSReportItemDataType!="EmptyHeader")){
						$.messager.popover({msg: '��'+(i+1)+'�й������ݲ���Ϊ��!',type: 'error'});
						$(editors[2].target).next('span').find('input').focus();
						return false;
					};
					var SSReportItemComponentType = editors[3].target.combobox("getValue");
					if (SSReportItemComponentType){
						if ($.hisui.indexOfArray(editors[3].target.combobox("getData"),"value",SSReportItemComponentType)<0){
							$.messager.popover({msg: '��'+(i+1)+'��������������ѡ��������ͣ�',type: 'error'});
							$(editors[3].target).next('span').find('input').focus();
							return false;
						}
					}
					if ((SSReportItemComponentType=="")&&(SSReportItemDataType=="ManualEntry")){
						$.messager.popover({msg: '��'+(i+1)+'�������������ֹ�¼��ʱ������Ͳ���Ϊ��!',type: 'error'});
						$(editors[3].target).next('span').find('input').focus();
						return false;
					};
					var SSReportItemAlternativeVal=editors[4].target.val();
					if ((SSReportItemComponentType!="")&&(SSReportItemComponentType!="text")&&(!SSReportItemAlternativeVal)){
						$.messager.popover({msg: '��'+(i+1)+'�����������ǵ�ѡ���ѡʱ��ѡֵ����Ϊ�գ�',type: 'error'});
						$(editors[4].target).focus();
						return false;
					}
					var SSReportItemRequired=editors[5].target.checkbox("getValue")?"Y":"N";
					var SSReportItemRowMerge=editors[6].target.checkbox("getValue")?"Y":"N";
					var SSReportItemSeqNo=$.trim(editors[7].target.val());
					var SSReportItemWidth = $.trim(editors[8].target.val());
				
					if (ReportItemNameObj[SSReportItemName]){
						//MsgArr.push('��'+(i+1)+'�������ظ���');  --�������ܻ��ظ� ����У��
					}else{
						ReportItemNameObj[SSReportItemName]=1;
					}
					if (ReportItemSeqObj[SSReportItemSeqNo]){
						MsgArr.push('��'+(i+1)+'���������ظ���');
					}else if (SSReportItemSeqNo!=""){
						ReportItemSeqObj[SSReportItemSeqNo]=1;
						delete SeqNoVerify[SSReportItemSeqNo];
						var SeqNoArr=SSReportItemSeqNo.split(".");
						if (SeqNoArr.length ==2){
							if (!ReportItemSeqObj[SeqNoArr[0]]){
								SeqNoVerify[SeqNoArr[0]]='��'+(i+1)+'����� '+SSReportItemSeqNo+" �ĸ���� "+SeqNoArr[0]+" �����ڣ�";
							}else{
								delete SeqNoVerify[SeqNoArr[0]];
							}
						}else if(SeqNoArr.length ==3){
							if (!ReportItemSeqObj[SeqNoArr[0]+"."+SeqNoArr[1]]){
								SeqNoVerify[SeqNoArr[0]+"."+SeqNoArr[1]]='��'+(i+1)+'����� '+SSReportItemSeqNo+" �ĸ���� "+SeqNoArr[0]+"."+SeqNoArr[1]+" �����ڣ�";
							}else{
								delete SeqNoVerify[SeqNoArr[0]+"."+SeqNoArr[1]];
							}
						}
					}
					var ReportItemRowId = rows[i].ReportItemRowId;
					if (!ReportRowId) ReportItemRowId="";
					SaveDataArr.push({
						ReportRowId:ReportRowId,
						ReportItemRowId:ReportItemRowId,
						SSReportItemName:SSReportItemName,
						SSReportItemDataType:SSReportItemDataType,
						SSReportItemLinkSource:SSReportItemLinkSource,
						SSReportItemComponentType:SSReportItemComponentType,
						SSReportItemAlternativeVal:SSReportItemAlternativeVal,
						SSReportItemDelFlag:"N",
						SSReportItemRequired:SSReportItemRequired,
						SSReportItemRowMerge:SSReportItemRowMerge,
						SSReportItemSeqNo:SSReportItemSeqNo,
						SSReportItemWidth:SSReportItemWidth
					});
				}
				if (SaveDataArr.length==0){
					$.messager.popover({msg: "û����Ҫ��������ݣ�",type: 'error'});
					return false;
				}
				for (item in SeqNoVerify){
					MsgArr.push(SeqNoVerify[item]);
				}
				if (MsgArr.length>0){
					$.messager.popover({msg: MsgArr.join("</br>"),type: 'error'});
					return false;
				}
				$.m({ 
					ClassName:"Nur.NIS.Service.ReportV2.ReportConfig", 
					MethodName:"HandleReportItem",
					SaveDataArr:JSON.stringify(SaveDataArr),
					event:"SAVE"
				},function(rtn){
					if(rtn==0){
					   $("#ReportItemListTab").datagrid('unselectAll').datagrid('load');
					   $.messager.popover({msg: '����ɹ�!',type: 'success'});
					}else{
						$.messager.popover({msg: '����ʧ��:'+rtn,type: 'error'});
					    return false;
					}
				}); 
			}
	    }];
	var Columns=[[ 
		{ field: 'ReportItemRowId', checkbox:"true"},
		{ field: 'ReportItemName', title: '����',width:130, editor : 
			{type : 'text',options : {required:true}}
		},
		{ field: 'ReportItemDataType', title: '��������',width:110, editor : 
			{
				type:'combobox',  
				options:{
					editable:false,
					mode: "local",
					data:ServerObj.ReportItemDataTypeJson,
					onSelect: function (rowIndex, rowData){
						var tr = $(this).closest('tr.datagrid-row');
      					var index= parseInt(tr.attr('datagrid-row-index'));
						var sourceObj=$('#ReportItemListTab').datagrid('getEditor', {index:index,field:'ReportItemLinkSource'});
						sourceObj.target.combobox('setValue',"").combobox('reload');
					}
				}
			},
			formatter: function(value,row,index){
				return row["ReportItemDataTypeDesc"];
			}
		},
		{ field: 'ReportItemLinkSource', title: '��������',width:100, editor : 
			{
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=Nur.NIS.Service.ReportV2.SourceConfig&QueryName=GetSourceConfigList&rows=999999",
					valueField:'SourceRowId',
					textField:'SourceDesc',
					loadFilter:function(data){
					    return data['rows'];
					},
					onBeforeLoad:function(param){
						var tr = $(this).closest('tr.datagrid-row');
      					var index= parseInt(tr.attr('datagrid-row-index'));
						var ReportItemDataType=""
						var editors = $('#ReportItemListTab').datagrid('getEditors', index); 
						if (editors[1]){
							var ReportItemDataType=editors[1].target.combobox('getValue');
						}
						if (ReportItemDataType=="") {
							var ReportItemDataType=$('#ReportItemListTab').datagrid("getData").rows[index].ReportItemDataType || "";
						}									
						param = $.extend(param,{
							SearchDesc:"",
							SearchType:ReportItemDataType,
							HospId:$HUI.combogrid('#_HospList').getValue(),
							SearchByType:"Y"
						});
					}
				 }
			},
			formatter: function(value,row,index){
				return row["ReportItemLinkSourceDesc"];
			}
		},
		{ field: 'ReportItemComponentType', title: '�������',width:80, editor : 
			{
				type:'combobox',  
				options:{
					//editable:false,
					mode: "local",
					data:ServerObj.ReportItemComponentTypeJson
				}
			},
			formatter: function(value,row,index){
				return row["ReportItemComponentTypeDesc"];
			}
		},
		{ field: 'ReportItemAlternativeVal', title: '��ѡֵ',width:180, editor : 
			{
				type:'text'
			}
		},
		{ field: 'ReportItemRequired', title: '������',width:70, align:"center",editor : 
			{
				type:'icheckbox',
				options : {
                    on : 'Y',
                    off : ''
                }
			}
		},

		{ field: 'ReportItemRowMerge', title: '�����кϲ�',width:100, align:"center",editor : 
			{
				type:'icheckbox',
				options : {
                    on : 'Y',
                    off : ''
                }
			}
		},
		{ field: 'ReportItemSeqNo', title: '������',width:70, editor : 
			{
				type:'text'
			}
		},
		{ field: 'ReportItemWidth', title: '�п�',width:70, editor : 
			{
				type:'text'
			}
		}
	]];
	$('#ReportItemListTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : true,
		idField:"ReportItemRowId",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.ReportV2.ReportConfig&QueryName=GetReportListItem&rows=999999",
		onBeforeLoad:function(param){
			$('#ReportItemListTab').datagrid("unselectAll");
			param = $.extend(param,{
				ReportRowId:GetSelReportId()
			});
		},
		onDblClickRow:function(rowIndex, rowData){ 
			$('#ReportItemListTab').datagrid("beginEdit", rowIndex);
			var target=$('#ReportItemListTab').datagrid('getEditor',{'index':rowIndex,'field':'ReportItemAlternativeVal'}).target;
	        $(target).attr("placeHolder","���ѡ����^�ָ�");
       }
	})
}
function ReportCopyHandle(){
	var CopyReportName = $.trim($("#CopyReportName").val());
	if(CopyReportName==""){
		$.messager.popover({msg: '�����Ʋ���Ϊ��!',type: 'error'});
		$("#CopyReportName").focus();
		return false;
	};
	var selected = $("#ReportListTab").datagrid("getSelected");
	var CopyFromReportRowId=selected.ReportRowId;
	$.cm({
		ClassName:"Nur.NIS.Service.ReportV2.ReportConfig",
		MethodName:"CopyReport",
		CopyFromReportRowId:CopyFromReportRowId,
		CopyReportName:CopyReportName
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '���Ƴɹ���',type: 'success'});
			$("#CopyWin").window('close');
			RefreshData();
		}else{
			$.messager.popover({msg: '����ʧ�ܣ�'+rtn,type: 'error'});
		}
	})
}