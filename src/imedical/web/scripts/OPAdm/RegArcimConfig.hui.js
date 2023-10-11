var PageLogicObj={
	tabRegChoseTypeListDataGrid:"",
	tabRegArcimListDataGrid:"",
	InitRegArcimListDataGridEditRow:"",
	RowID:""
};
$(function(){
	//��ʼ��ҽԺ
	var hospComp = GenHospComp("Doc_OPAdm_BaseConfig");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		CleargChoseTypeList();
		LoadLoc();
		LoadSex();
		LoadRegChoseTypeListDataGrid();
		InitRegArcimListDataGrid();
		PageLogicObj.tabRegArcimListDataGrid.datagrid('unselectAll').datagrid('loadData',{"total":0,"rows":[]});
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//ҳ��Ԫ�س�ʼ��
		InitEvent();
		Init();
		LoadRegChoseTypeListDataGrid();
	}
});
function Init(){
	LoadLoc();
	LoadSex();
	PageLogicObj.tabRegChoseTypeListDataGrid=InitRegChoseTypeListDataGrid();
	PageLogicObj.tabRegArcimListDataGrid=InitRegArcimListDataGrid();
}
function InitEvent(){
	$("#SaveCongfid").click(SaveCongfidClickHandle);
}
function SaveCongfidClickHandle(){
	var LocID=$('#LocList').combobox('getValue');
	if (!LocID) LocID="";
	var MarkID=$('#MarkList').combobox('getValue');
	if ((MarkID)&&($.hisui.indexOfArray($('#MarkList').combobox('getData'),"Hidden1",MarkID) <0)) MarkID="";	
	var SexID=$('#Sex').combobox('getValue');
	if (!SexID) SexID="";
	var AgeSamll=$("#AgeSamll").numberbox('getValue');
	var AgeBig=$("#AgeBig").numberbox('getValue');
	if ((AgeSamll !="")&&(AgeBig !="")&&(+AgeBig < +AgeSamll)) {
		$.messager.alert("��ʾ","��ʼ���䲻�ܴ��ڽ�������!","info",function(){
			$("#AgeSamll").focus();
		});
		return;
	}
	if ((isNaN(AgeSamll))||(AgeSamll <0)) {
		$.messager.alert("��ʾ","��ʼ����ֻ���Ǵ��ڵ���0������!","info",function(){
			$("#AgeSamll").focus();
		});
		return;
	}
	if ((isNaN(AgeBig))||(AgeBig <0)) {
		$.messager.alert("��ʾ","��������ֻ���Ǵ��ڵ���0������!","info",function(){
			$("#AgeBig").focus();
		});
		return;
	}
	var AgeRange=AgeSamll+"-"+AgeBig;
	var Prior=$("#FristRange").val();
	if ((isNaN(Prior))||(Prior <0)) {
		$.messager.alert("��ʾ","���ȼ�ֻ����д���ڵ���0������!","info",function(){
			$("#FristRange").focus();
		});
		return;
	}
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((LocID =="")&&(MarkID =="")&&(SexID =="")&&(AgeRange =="-")){
		$.messager.alert("��ʾ","��ѡ�����������!");
		return;
	}
	$.cm({
		ClassName:"DHCDoc.OPAdm.DHCOPRegArcimConfig",
		MethodName:"Insert",
		RowID:PageLogicObj.RowID,
		LocID:LocID,
		MarkID:MarkID,
		SexID:SexID,
		AgeRange:AgeRange,
		Prior:Prior,
		HospID:HospID,
		dataType:"text",
	},function(data){
		if (data==0){
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			$("#Aliteadd-dialog").dialog("close");
			PageLogicObj.tabRegArcimListDataGrid.datagrid('unselectAll').datagrid('loadData',{"total":0,"rows":[]});
			LoadRegChoseTypeListDataGrid();
		}
	})
}
function CleargChoseTypeList(){
	PageLogicObj.RowID=""
	$("#LocList,#MarkList,#Sex").combobox('select','');
	$("#FristRange").val("");
	$("#AgeSamll,#AgeBig").numberbox('setValue',"");
}
function LoadRegChoseTypeListDataGrid(){
	$.cm({
		ClassName:"DHCDoc.OPAdm.DHCOPRegArcimConfig",
		QueryName:"FindRegArcimConfig",
		HospID:$HUI.combogrid('#_HospList').getValue(),
		Pagerows:PageLogicObj.tabRegChoseTypeListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.tabRegChoseTypeListDataGrid.datagrid('unselectAll').datagrid('loadData',GridData);
	})
}
function InitRegChoseTypeListDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {
	        $("#Aliteadd-dialog").dialog("open");
	        CleargChoseTypeList();
	    }
    },{
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function() { 
        	var row=PageLogicObj.tabRegChoseTypeListDataGrid.datagrid('getSelected');
			if ((!row)||(row.length==0)){
				$.messager.alert("��ʾ","��ѡ����Ҫɾ���ļ�¼!","info");
				return false;
			}
			$.messager.confirm('ȷ��','��ȷ��Ҫɾ����?',function(r){    
			    if (r){    
			        RowID=row.RowID;
			        $.cm({
						ClassName:"DHCDoc.OPAdm.DHCOPRegArcimConfig",
						MethodName:"Delect",
						RowID:RowID,
						dataType:"text",
					},function(data){
						if (data==0){
							$.messager.popover({msg: 'ɾ���ɹ�!',type:'success',timeout: 1000});
							PageLogicObj.tabRegArcimListDataGrid.datagrid('unselectAll').datagrid('loadData',{"total":0,"rows":[]});
							LoadRegChoseTypeListDataGrid();
						}
					})
			    }    
			});  
				
        }
    },{
        text: '�޸�',
        iconCls: 'icon-save',
        handler: function() { 
        	var row=PageLogicObj.tabRegChoseTypeListDataGrid.datagrid('getSelected');
			if ((!row)||(row.length==0)){
				$.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵļ�¼!","info");
				return false;
			}
			PageLogicObj.RowID=row.RowID;
			$("#LocList").combobox('select',row["LocID"]);
			setTimeout(function() { 
	        	$("#MarkList").combobox('setValue',row["MarkID"]);
	        },500);
			$("#Sex").combobox('setValue',row["SexID"]);
			$("#AgeSamll").numberbox('setValue',row["AgeRange"].split("-")[0])
			$("#AgeBig").numberbox('setValue',row["AgeRange"].split("-")[1])
			$("#FristRange").val(row["PriorLeven"])
        	$("#Aliteadd-dialog").dialog("open");
        }
    }];
	var Columns=[[ 
		{field:'RowID',hidden:true,title:''},
		{field:'LocDesc',title:'����',width:200},
		{field:'LocID',title:'',hidden:true},
		{field:'MarkDesc',title:'�ű�',width:200},
		{field:'MarkID',title:'',hidden:true},
		{field:'SexDesc',title:'�Ա�',width:60},
		{field:'SexID',title:'',hidden:true},
		{field:'AgeRange',title:'�����',width:60},
		{field:'PriorLeven',title:'���ȼ�',width:60},
    ]]
	var tabRegChoseTypeLisDataGrid=$("#tabRegChoseTypeList").datagrid({
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
		idField:'RowID',
		columns :Columns,
		toolbar:toobar,
		onSelect: function (index, row){
			RowID=row.RowID
			loadInitRegArcimListData(RowID)
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}); 
	return tabRegChoseTypeLisDataGrid;
}
function loadInitRegArcimListData(RowID){
	$.cm({
		ClassName:"DHCDoc.OPAdm.DHCOPRegArcimConfig",
		QueryName:"FindRegArcimDesc",
		RowID:RowID,
		Pagerows:PageLogicObj.tabRegArcimListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.InitRegArcimListDataGridEditRow = undefined;
		PageLogicObj.tabRegArcimListDataGrid.datagrid('unselectAll').datagrid('loadData',GridData);
	})
}
function InitRegArcimListDataGrid(){
	 var CNMedCookArcModeToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() { 
            	var row=PageLogicObj.tabRegChoseTypeListDataGrid.datagrid('getSelected');
				if ((!row)||(row.length==0)){
					$.messager.alert("��ʾ","��ѡ��һ�м�¼��������!","info");
					return false;
				}
            	PageLogicObj.InitRegArcimListDataGridEditRow = undefined;
                PageLogicObj.tabRegArcimListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                
                PageLogicObj.tabRegArcimListDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                PageLogicObj.tabRegArcimListDataGrid.datagrid("beginEdit", 0);
                PageLogicObj.InitRegArcimListDataGridEditRow = 0;
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
	            var row=PageLogicObj.tabRegArcimListDataGrid.datagrid('getSelected');
				if ((!row)||(row.length==0)){
					$.messager.alert("��ʾ","��ѡ��һ�м�¼����ɾ��!","info");
					return false;
				}
	            var row=PageLogicObj.tabRegChoseTypeListDataGrid.datagrid('getSelected');
				MastRowID=row.RowID;
                var rows = PageLogicObj.tabRegArcimListDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
	                        Rowid=rows[0].RowID
	                        if (Rowid){
		                        var value=$.m({
									ClassName:"DHCDoc.OPAdm.DHCOPRegArcimConfig",
									MethodName:"ArcDelect",
								   	RowID:MastRowID,indnumber:Rowid,
								},false);
								if(value=="0"){
									$.messager.popover({msg: 'ɾ���ɹ�',type:'success'});
							        loadInitRegArcimListData(MastRowID)	
								}
	                        }else{
								PageLogicObj.InitRegArcimListDataGridEditRow = undefined;
                				PageLogicObj.tabRegArcimListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
	                        }
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
            }
        },{
            text: 'ȡ���༭',
            iconCls: 'icon-undo',
            handler: function() {
                //ȡ����ǰ�༭�аѵ�ǰ�༭�а�undefined�ع��ı������,ȡ��ѡ�����
                PageLogicObj.InitRegArcimListDataGridEditRow = undefined;
                PageLogicObj.tabRegArcimListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        },{
			text: '����',
			iconCls: 'icon-save',
			handler: function() {
				 var row=PageLogicObj.tabRegChoseTypeListDataGrid.datagrid('getSelected');
				if ((!row)||(row.length==0)){
					$.messager.alert("��ʾ","��ѡ��һ�м�¼���б���!","info");
					return false;
				}
				MastRowID=row.RowID;
				if (PageLogicObj.InitRegArcimListDataGridEditRow != undefined){
		            var ArcimSelRow=PageLogicObj.tabRegArcimListDataGrid.datagrid("selectRow",PageLogicObj.InitRegArcimListDataGridEditRow).datagrid("getSelected"); 
		           	var ArcimRowID=ArcimSelRow.ARCIMRowid
		           	if (!ArcimRowID){
						$.messager.alert("��ʾ","��ѡ��ҽ��!");
                        return false;
			        } 
			        //var editors = PageLogicObj.tabRegArcimListDataGrid.datagrid('getEditors', PageLogicObj.InitRegArcimListDataGridEditRow);
			        var Number=""
			        var subrowid=ArcimSelRow.RowID
			       	ARCIMStr=ArcimRowID+"!"+Number
			        var value=$.m({
						ClassName:"DHCDoc.OPAdm.DHCOPRegArcimConfig",
						MethodName:"ARCInsert",
					   	RowID:MastRowID, ARCIMStr:ARCIMStr, indnumber:subrowid
					},false);
					if(value=="0"){
						$.messager.popover({msg: '����ɹ�',type:'success'});
						PageLogicObj.InitRegArcimListDataGridEditRow = undefined;
				        loadInitRegArcimListData(MastRowID)		
					}else if (value =="repeat") {
						$.messager.alert("��ʾ","��¼�ظ�!");
					}
		        }
			}
	}];
	var RegServiceGroup= $m({
	    ClassName : "web.DHCOPRegConfig",
	    MethodName : "GetSpecConfigNode",
	    NodeName : "RegServiceGroup",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	},false);
	var SeviceQueryData = $cm({
	    ClassName : "web.DHCBL.BaseReg.BaseDataQuery",
	    QueryName : "SeviceQuery",
	    RegServiceGroupRowId : RegServiceGroup,
	    HospID:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:99999,rows:99999
	},false);
    var CNMedCookArcModeColumns=[[   
    				{ field: 'RowID', title: 'Rowid', width: 10,hidden:true },
    				{ field: 'ARCIMRowid', title: 'ARCIMRowid', width: 10,hidden:true },
					{ field: 'ARCIMDesc', title: 'ҽ������', width: 20,
						editor:{
				    	type:'combogrid',
				    	options:{
				    		required: true,
				        	panelWidth:450,
							panelHeight:350,
		                    idField:'ID',
		                    textField:'Desc',
		                    value:'',//ȱʡֵ 
		                    mode:'remote',
							pagination : false,//�Ƿ��ҳ   
							rownumbers:true,//���   
							collapsible:false,//�Ƿ���۵���   
							fit: true,//�Զ���С   
							pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
							pageList: [10],//��������ÿҳ��¼�������б�  
							data:SeviceQueryData,
		                    columns:[[
		                        {field:'Desc',title:'����',width:300,sortable:true},
			                    {field:'ID',title:'ID',width:120,sortable:true}
		                     ]],
							 keyHandler:{
								up: function () {
					                //ȡ��ѡ����
					                var selected = $(this).combogrid('grid').datagrid('getSelected');
					                if (selected) {
					                    //ȡ��ѡ���е�rowIndex
					                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
					                    //�����ƶ�����һ��Ϊֹ
					                    if (index > 0) {
					                        $(this).combogrid('grid').datagrid('selectRow', index - 1);
					                    }
					                } else {
					                    var rows = $(this).combogrid('grid').datagrid('getRows');
					                    $(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
					                }
					             },
					             down: function () {
					               //ȡ��ѡ����
					                var selected = $(this).combogrid('grid').datagrid('getSelected');
					                if (selected) {
					                    //ȡ��ѡ���е�rowIndex
					                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
					                    //�����ƶ�����ҳ���һ��Ϊֹ
					                    if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
					                        $(this).combogrid('grid').datagrid('selectRow', index + 1);
					                    }
					                } else {
					                    $(this).combogrid('grid').datagrid('selectRow', 0);
					                }
					            },
								left: function () {
									return false;
					            },
								right: function () {
									return false;
					            },            
								enter: function () { 
					                //ѡ�к������������ʧ
					                $(this).combogrid('hidePanel');
									$(this).focus();
					            }
		        			},
							onSelect : function(rowIndex, rowData) {
								var ArcimSelRow=PageLogicObj.tabRegArcimListDataGrid.datagrid("selectRow",PageLogicObj.InitRegArcimListDataGridEditRow).datagrid("getSelected"); 
								var oldInstrArcimId=ArcimSelRow.ARCIMRowid;
								ArcimSelRow.ARCIMRowid=rowData.ID;
							}
		        		}
		        	}
                    	/*editor:{
		              		type:'combogrid',
		                    options:{
			                    enterNullValueClear:false,
								required: true,
								panelWidth:450,
								panelHeight:350,
								delay:500,
								idField:'ArcimRowID',
								textField:'ArcimDesc',
								value:'',//ȱʡֵ 
								mode:'remote',
								pagination : true,//�Ƿ��ҳ   
								rownumbers:true,//���   
								collapsible:false,//�Ƿ���۵���   
								fit: true,//�Զ���С   
								pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
								pageList: [10],//��������ÿҳ��¼�������б�  
								url:$URL+"?ClassName=DHCDoc.OPAdm.DHCOPRegArcimConfig&QueryName=FindAllItem",
	                            columns:[[
	                                {field:'ArcimDesc',title:'����',width:310,sortable:true},
					                {field:'ArcimRowID',title:'ID',width:100,sortable:true},
					                {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
	                             ]],
								onSelect: function (rowIndex, rowData){
									var rows=PageLogicObj.tabRegArcimListDataGrid.datagrid("selectRow",PageLogicObj.InitRegArcimListDataGridEditRow).datagrid("getSelected");
									rows.ARCIMRowid=rowData.ArcimRowID
								},
								onClickRow: function (rowIndex, rowData){
									var rows=PageLogicObj.tabRegArcimListDataGrid.datagrid("selectRow",PageLogicObj.InitRegArcimListDataGridEditRow).datagrid("getSelected");
									rows.ARCIMRowid=rowData.ArcimRowID
								},
								onLoadSuccess:function(data){
									$(this).next('span').find('input').focus();
								},
								onBeforeLoad:function(param){
									if (param['q']) {
										var desc=param['q'];
									}
									param = $.extend(param,{Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
								}
                    		}
	        			  }*/
					},
        			{ field: 'Number', title: '����', width: 20,hidden:true ,editor : {type : 'text',options : {}}
					}
    			 ]];
	// ��ҩ��ʽ�б�Grid
	tabRegArcimListDataGrid=$('#tabRegArcimList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : false,  //�Ƿ��ҳ
		rownumbers : true,  //
		idField:"RowID",
		//pageList : [15,50,100,200],
		columns :CNMedCookArcModeColumns,
		toolbar :CNMedCookArcModeToolBar,
		onClickRow:function(rowIndex, rowData){
			PageLogicObj.tabRegArcimListDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=PageLogicObj.tabRegArcimListDataGrid.datagrid('getRows'); 
		},
		onDblClickRow:function(rowIndex, rowData){
			if (CookArcItemDataGridEditRow != undefined) {
				$.messager.alert("��ʾ", "�����ڱ༭���У����ȵ������");
		        return false;
			}
			PageLogicObj.tabRegArcimListDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.InitRegArcimListDataGridEditRow=rowIndex;
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
	return tabRegArcimListDataGrid;
	
}
function LoadLoc(){
	$.q({
		ClassName:"web.DHCRBResSession",
		QueryName:"FindLoc",
		Loc:"",
		UserID:session['LOGON.USERID'],
		HospitalDr:$HUI.combogrid('#_HospList').getValue(),rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#LocList", {
				valueField: 'Hidden',
				textField: 'Desc', 
				editable:true,
				data: Data['rows'],
				filter: function(q, row){
					if (q=="") return true; 
					q=q.toUpperCase();
					if ((row["Code"].toUpperCase().indexOf(q)>=0)||(row["Alias"].toUpperCase().indexOf(q)>=0)||(row["Desc"].toUpperCase().indexOf(q)>=0)) return true;
				},
				onSelect:function(rec){
					if (rec){
						LoadDoc(rec['Hidden']);
					}
				},
				onChange:function(newValue,oldValue){
					if (newValue==""){
						$("#MarkList").combobox('select','');
						$("#MarkList").combobox('loadData',[]);
					}
				}
		 });
	});
}

function LoadDoc(DepRowId){
	$.q({
		ClassName:"web.DHCRBResSession",
		QueryName:"FindResDoc",
		DepID:DepRowId,
		HospID:$HUI.combogrid('#_HospList').getValue()
	},function(Data){
		var cbox = $HUI.combobox("#MarkList", {
				valueField: 'Hidden1',
				textField: 'Desc', 
				editable:true,
				data: Data['rows'],
				filter: function(q, row){
					if (q=="") return true; 
					q=q.toUpperCase();
					if ((row["Code"].toUpperCase().indexOf(q)>=0)||(row["Hidden2"].toUpperCase().indexOf(q)>=0)||(row["Desc"].toUpperCase().indexOf(q)>=0)) return true;
				},
				onSelect:function(){
				}
		 });
	});
}


function LoadSex(){
	$HUI.combobox("#Sex", {
		valueField: 'id',
		textField: 'text', 
		blurValidValue:true,
		data: JSON.parse(ServerObj.DefaultSexPara),
		filter: function(q, row){
			if (q=="") return true;
			var find=0;
			if (row["text"].indexOf(q.toUpperCase())>=0) return true;
			for (var i=0;i<row["AliasStr"].split("^").length;i++){
				if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
					find=1;
					break;
				}
			}
			if (find==1) return true;
			return false;
		},
		onSelect:function(rec){
		}
	})
	
}