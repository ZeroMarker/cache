var PageLogicObj={
	editRow1:undefined,
	CureLocDataGrid:""
}
var CureLinkLocDataGrid
$(document).ready(function(){ 
	 //Init();
	 //InitCureLinkLoc();
	 InitHospList();
	 //CureLocDataGridLoad();
});
function InitHospList()
{
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_Cure_LinkLoc",hospStr);
	hospComp.jdata.options.onSelect = function(e,t){
		InitCureLinkLoc();
		CureLocDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		PageLogicObj.CureLocDataGrid=Init();
		InitCureLinkLoc();
		CureLocDataGridLoad();
	}
}
function Init()
{
	var CureLocToolBar = [{
            text: '��������',
            iconCls: 'icon-edit',
            handler: function() {
				LinkLocClickHandle();
            }
        }];
	CureLocColumns=[[    
                    { field: 'LocDesc', title: '����', width: 850, sortable: true
					},
        			{ field: 'LocRowID', title: '����ID', width: 250, sortable: true,hidden:true
					}
    			 ]];
	var CureLocDataGrid=$('#tabCureLoc').datagrid({  
		fit : true,
		//width : 1000,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '������..',  
		pagination : true,  //�Ƿ��ҳ
		rownumbers : true,  //
		idField:"LocRowID",
		pageSize : 15,
		pageList : [15,50,100],
		columns :CureLocColumns,
		toolbar :CureLocToolBar,
		onDblClickRow:function(rowIndex, rowData){ 
			LinkLocClickHandle();
       }
	});
	
	return CureLocDataGrid;
};

function LinkLocClickHandle(){
	var rows = PageLogicObj.CureLocDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
		var ids = [];
		for (var i = 0; i < rows.length; i++) {
			ids.push(rows[i].LocRowID);
		}
		var LocRowID=ids.join(',')
	}else{
		$.messager.alert('��ʾ',"��ѡ��һ����¼!");
		return false;
	}
    $("#dialog-CureLinkLoc").css("display", ""); 
	var dialog1 = $HUI.dialog("#dialog-CureLinkLoc",{ //$("#dialog-CureLinkLoc").dialog({
		autoOpen: false,
		height: 500,
		width: 400,
		modal: true
	});
	dialog1.dialog( "open" );
	InitCureLinkLoc(LocRowID);	
}
function CureLocDataGridLoad()
{ 
	var HospDr=GetSelHospID();
	var LocDesc=$("#SLocDesc").searchbox("getValue");
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"FindLoc",
		Loc:LocDesc,
		CureFlag:"1",
		Hospital:HospDr,
		Pagerows:PageLogicObj.CureLocDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.CureLocDataGrid.datagrid("unselectAll").datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
	
};
function InitCureLinkLoc(Rowid)
{
	var CureLinkToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() { //����б�Ĳ�����ť���,�޸�,ɾ����
			    PageLogicObj.editRow1 = undefined;
                //CureLinkLocDataGrid.datagrid("rejectChanges");
                CureLinkLocDataGrid.datagrid("unselectAll");
                if (PageLogicObj.editRow1 != undefined) {
	                $.messager.alert("��ʾ", "�����ڱ༭���У����ȵ������", "error");
                    CureLinkLocDataGrid.datagrid("endEdit", PageLogicObj.editRow1);
                    return;
                }else{
	                 //���ʱ���û�����ڱ༭���У�����datagrid�ĵ�һ�в���һ��
                    CureLinkLocDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {
							RowID:"",
							LinkLocRowID:"",
							LocDesc:"",						
						}
                    });
                    //���²������һ�п����༭״̬
                    CureLinkLocDataGrid.datagrid("beginEdit", 0);
                    //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                    //����ǰ�༭���и�ֵ
                    PageLogicObj.editRow1 = 0;
                }
              
            }
        },{
            text: '����',
            iconCls: 'icon-save',
            handler: function() {
	            if(PageLogicObj.editRow1==undefined){
					return false;
			  	}
                var rows = CureLinkLocDataGrid.datagrid("getRows");
				if (rows.length > 0){
				   for (var i = 0; i < rows.length; i++) {
					   if(PageLogicObj.editRow1==i){
						   var rows=CureLinkLocDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");  
						   var editors = CureLinkLocDataGrid.datagrid('getEditors', PageLogicObj.editRow1); 
						   var LinkLocRowID=editors[0].target.combobox('getValue');
						   if ((!LinkLocRowID)||(rows.LinkLocRowID=="")){
								$.messager.alert('��ʾ',"��ѡ���������");
								return false;
				            }
							$.m({
								ClassName:"DHCDoc.DHCDocCure.Config",
								MethodName:"insertLinkLoc",
								'MainLocID':Rowid,
								'LinkLocID':LinkLocRowID
							},function testget(value){
								if(value=="0"){
									CureLinkLocDataGrid.datagrid("endEdit", PageLogicObj.editRow1);
									PageLogicObj.editRow1 = undefined;
									//CureLinkLocDataGrid.datagrid('load');
									CureLinkLocDataGridLoad(Rowid);
									CureLinkLocDataGrid.datagrid('unselectAll');
									$.messager.show({title:"��ʾ",msg:"����ɹ�"});
								}else if(value=="-1"){
									$.messager.alert('��ʾ',"����ʧ��,�ü�¼�Ѵ���");
									return false;
								}else if(value=="-2"){
									$.messager.alert('��ʾ',"����ʧ��,����ȷѡ���������");
									return false;
								}else if(value=="-101"){
									$.messager.alert('��ʾ',"����ʧ��,�����Ҳ��ܹ�������");
									return false;
								}else{
									$.messager.alert('��ʾ',"����ʧ��:"+value);
									return false;
								}
								PageLogicObj.editRow1 = undefined;
								
							});
					   }
				   }
				}

            }
        }, {
            text: 'ȡ���༭',
            iconCls: 'icon-redo',
            handler: function() {
                PageLogicObj.editRow1 = undefined;
                CureLinkLocDataGrid.datagrid("rejectChanges");
                CureLinkLocDataGrid.datagrid("unselectAll");
            }
        },
        {
            text: 'ɾ��',
            iconCls: 'icon-remove',
            handler: function() {
                //ɾ��ʱ�Ȼ�ȡѡ����
                var rows = CureLinkLocDataGrid.datagrid("getSelections");
                //ѡ��Ҫɾ������
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].RowID);
                            }
                            var RowID=ids.join(',');
                            if (RowID==""){
	                            PageLogicObj.editRow1 = undefined;
				                CureLinkLocDataGrid.datagrid("rejectChanges");
				                CureLinkLocDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            $.m({
	                            ClassName:"DHCDoc.DHCDocCure.Config",
	                            MethodName:"deleteLink",
	                            'RowID':RowID
                            },function testget(value){
								if(value=="0"){
									//CureLinkLocDataGrid.datagrid('load');
									CureLinkLocDataGridLoad(Rowid);
		           					CureLinkLocDataGrid.datagrid('unselectAll');
		           					$.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
								}else{
									$.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
								}
								PageLogicObj.editRow1 = undefined;
							});
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
	         
            }
        }];
	CureLinkColumns=[[    
					{ field: 'RowID', title: '', width: 1, align: 'center', sortable: true,hidden:true
					},
					{ field: 'LinkLocRowID', title: '', width: 1, align: 'center', sortable: true,hidden:true
					},
					{ field: 'LocDesc', title: '������������', width: 300, align: 'center', sortable: true,
					  editor:{
							type:'combogrid',
							options:{
								required: true,
								panelWidth:300,
								panelHeight:350,
								idField:'LocRowID',
								textField:'LocDesc',
								value:'',
								mode:'remote',
								pagination : true,
								rownumbers:true,
								collapsible:false,
								fit: true,
								pageSize: 10,
								pageList: [10],
								//url:PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
								columns:[[
	                                {field:'LocDesc',title:'����',width:250,sortable:true},
				                    {field:'LocRowID',title:'LocRowID',width:120,sortable:true,hidden:true},
				                    {field:'selected',title:'LocRowID',width:120,sortable:true,hidden:true}
	                             ]],
	                             onShowPanel:function(){
		                            var trObj = $HUI.combogrid(this);
									var object1 = trObj.grid();
		                         	LoadItemData("",object1)
		                         },
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
									  //�ı��������Ϊѡ���еĵ��ֶ�����
						                var selected = $(this).combogrid('grid').datagrid('getSelected');  
									    if (selected) { 
									      $(this).combogrid("options").value=selected.ArcimDesc;
									      var rows=CureLinkLocDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");
                                          rows.LinkLocRowID=selected.LocRowID
									    }
									    //
						                //ѡ�к������������ʧ
						                $(this).combogrid('hidePanel');
										$(this).focus();
						            },
									 query:function(q){
										var object1=new Object();
										object1=$(this)
										var trObj = $HUI.combogrid(this);
										var object1 = trObj.grid();

										if (this.AutoSearchTimeOut) {
											window.clearTimeout(this.AutoSearchTimeOut)
											this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1);},400); 
										}else{
											this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1);},400); 
										}
										$(this).combogrid("setValue",q);
									}
                    			},
                    			onSelect:function(rowIndex, rowData){
							      var rows=CureLinkLocDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");
                                  rows.LinkLocRowID=rowData.LocRowID
	                    		}
                    		}
	        			 }
					  
					}
    			 ]];
	CureLinkLocDataGrid=$('#tabCureLinkLoc').datagrid({  
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '������..',  
		pagination : true,  //�Ƿ��ҳ
		rownumbers : true,  //
		idField:"RowID",
		pageSize:10,
		pageList : [10,20,50],
		columns :CureLinkColumns,
		toolbar :CureLinkToolBar,
	});
	CureLinkLocDataGridLoad(Rowid);
	return CureLinkLocDataGrid;
}

function CureLinkLocDataGridLoad(Rowid)
{
	if(Rowid=="")return;
	/*
	CureLinkLocDataGrid.datagrid({
		url:$URL,
		queryParams:{
			ClassName:"DHCDoc.DHCDocCure.Config",
			QueryName:"FindCureLinkLoc",
			'RowIDLocRowID':Rowid,
		},onLoadSuccess:function(){
			var opts = CureLinkLocDataGrid.datagrid('options');
			var pageNum1=opts.pageNumber;
			var pageSize1=opts.pageSize;
			CureLinkLocDataGrid.datagrid('getPager').pagination('refresh',{
				pageNumber:pageNum1,
				pageSize:pageSize1})
		}
	})*/
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"FindCureLinkLoc",
		'RowIDLocRowID':Rowid,
		Pagerows:CureLinkLocDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureLinkLocDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
};

function LoadItemData(q,obj1){
	var val = q //$('#Combo_CTLoc').combogrid('getValue'); 
	var HospDr=GetSelHospID();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"FindLoc",
		Loc:val,
		CureFlag:"1",
		Hospital:HospDr,
		Pagerows:obj1.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		obj1.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
	
};

function GetSelHospID(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	return HospID;
}