<!-- nur.hisui.nurseCustomReportDirectoryConfig.js ��Ŀ¼����-->
var PageLogicObj={
	m_WardJson:""
}
editRow = undefined;
$(function(){
	InitHospList();                
                       
});
//��ʼ��ҽԺ�б�
function InitHospList(){
	/*
	var hospComp = GenHospComp("Nur_IP_StatsDataSourceConfig","",{width:205});    //websys.com.js
	hospComp.jdata.options.onSelect = function(e,t){
		RefreshData();
		$("#SearchName").searchbox('setValue', '');

	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
	*/
	
	try
	{
		// ��Ժ��
		var sessionInfo = session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"];
		var hospComp = GenHospComp("Nur_IP_Question",sessionInfo);
		hospComp.jdata.options.onSelect = function(e,t){
			RefreshData();
			$("#SearchName").searchbox('setValue', '');
		}
		hospComp.jdata.options.onLoadSuccess= function(data){
			Init();
		}
	}catch(ex)
	{
	  // ��������Ŀ���Ƕ�Ժ���ĳ���
	  $("#_HospList").combobox({
	    url:
	      $URL +
	      "?1=1&ClassName=Nur.NIS.Service.ReportV2.LocUtils" +
	      "&QueryName=GetHospitalList&ResultSetType=array",
	    valueField: "HospitalId",
	    textField: "HospitalDesc",
	    defaultFilter: 4,
	    width:250,
	    value:session['LOGON.HOSPID'],
	    onSelect:function(e,t){
		   RefreshData();
			$("#SearchName").searchbox('setValue', '');
		},
		onLoadSuccess:function(data){
			Init();
		}
	  });
	}
}
//ҳ���ʼ��
function Init(){
	InitWardJson();
	InitReportDirectory();
	editRow = undefined;
	$("#SearchName").searchbox('setValue', '');
}

//ˢ������
function RefreshData(){
	$("#ReportListTab").datagrid("reload");

}
//��������
function InitWardJson(){
	PageLogicObj.m_WardJson=$.cm({
		ClassName:"Nur.NIS.Service.ReportV2.LocUtils",
		QueryName:"NurseCtloc",
		desc:"",
		hosId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},false)
}
//��ʼ�������б����
function InitReportDirectory(){
	var ToolBar = [{
			text: '����',
			iconCls: '	icon-add',
			handler: function() {
				if (editRow == undefined) {
					var maxRow=$("#ReportListTab").datagrid("getRows");
					$("#ReportListTab").datagrid("appendRow", {
	                    RowId: ''
	                })
	                editRow=maxRow.length-1;
	                $("#ReportListTab").datagrid("beginEdit", editRow);
	                var editors = $("#ReportListTab").datagrid('getEditors', editRow);
					$(editors[0].target).focus();
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
	                            ids.push(rows[i].rowid);
	                        }
	                        var ID=ids.join(',');
	                        if (ID==""){
	                            editRow = undefined;
				                $("#ReportListTab").datagrid("rejectChanges").datagrid("unselectAll");
				                return;
	                        }
	                        var value=$.m({ 
								ClassName:"Nur.NIS.Service.ReportV2.DataManager", 
								MethodName:"UpdateReportDirectory",
								RowIDs:ID, 
								event:"DELETE",
							},false);
					        if(value=="0"){
						       RefreshData();
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
//					var Code = editors[0].target.val();
//					if(Code==""){
//						$.messager.popover({msg: 'Code����Ϊ��!',type: 'error'});
//						$(editors[0].target).focus();
//						return false;
//					};
					var Name=editors[0].target.val();
					//var LocID=editors[2].target.combobox("getValues");  //����ʱע��༭�����
					var SortNo=editors[1].target.val();
					var RowId = rows.rowid;

	                $.m({ 
						ClassName:"Nur.NIS.Service.ReportV2.DataManager", 
						MethodName:"UpdateReportDirectory",
						event:"SAVE",
						RowIDs:RowId,
						//DirectoryCode:Code,
						DirectoryName:Name,
						DirectoryHospitalID:$HUI.combogrid('#_HospList').getValue(),
						//DirectoryLocID:LocID,
						DirectorySortNo:SortNo,
						DirectoryUpdateUser:session['LOGON.USERID'] || '',
						
					},function(rtn){
						if(rtn==0){
						   editRow = undefined;
						    RefreshData();
						   $.messager.popover({msg: '����ɹ�!',type: 'success'});
						}
						else if(rtn.indexOf("��Ψһ")!=-1){
							$.messager.popover({msg: '����ʧ��: ���Ʋ����ظ�',type: 'error'});
						    return false;
						}else{
							$.messager.popover({msg: '����ʧ��:'+rtn,type: 'error'});
						    return false;
						}
					}); 
				 }
			}
	    },
	    /**
	    '-',{
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
	    }
	    **/    
	    ];
	var Columns=[[
		{ field: 'rowid', title: 'ID',width:50},
		{ field: 'DirectoryCode', title: '����',width:160
		},
		{ field: 'DirectoryName', title: '����',width:160, editor : 
			{type : 'text',options : {required:true}}
		},
		/**
		{ field: 'DirectoryLocID', title: '����',width:180, editor : 
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
		**/
		{ field: 'DirectorySortNo', title: 'Ŀ¼���',width:160, editor : 
			{type : 'text',options : {required:true}}
		},
		{ field: 'DirectoryUpdateUser', title: '������',width:160
		},
		{ field: 'DirectoryUpdateDate', title: '��������',width:160
		},
		{ field: 'DirectoryUpdateTime', title: '����ʱ��',width:160
		},
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
		idField:"rowid",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*�˴�Ϊfalse*/
		url: $URL,
		queryParams: {
				ClassName: "Nur.NIS.Service.ReportV2.DataManager",
				QueryName: "FindReportDirectory",
				//RowID : "" ,
				HospitalID:$HUI.combogrid('#_HospList').getValue(),
				SearchName:$("#SearchName").searchbox("getValue"),
			},
		onBeforeLoad:function(param){
			$('#ReportListTab').datagrid("unselectAll");
			param = $.extend(param,{
				HospitalID:$HUI.combogrid('#_HospList').getValue(),
				SearchName:$("#SearchName").searchbox("getValue")
			});
		},
		onLoadSuccess:function(v){
			editRow =undefined;
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
	       $("#ReportItemListTab").datagrid("reload");
	       $('#ReportSearchTab').datagrid("reload")
	       //InitSearchCondition();
		   //editRow = undefined;
	   }
	})
}
/**
//��ȡ�б�ѡ�����RowID
function GetSelReportId(){
	var rows = $("#ReportListTab").datagrid("getSelected");
	if (rows){
		return rows["rowid"] || "";
	}
	return "";
}
//�����б��ƹ���
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
**/
