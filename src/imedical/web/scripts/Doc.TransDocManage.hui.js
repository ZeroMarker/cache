var PageLogicObj={
	m_TransDocListDataGrid:"",
	m_TransLocDocList:"",
	editIndex:""
}
$(function(){
	//��ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
});

function Init(){
	PageLogicObj.m_TransDocListDataGrid=InitTransDocListDataGrid();
	PageLogicObj.m_TransLocDocList=InitTransLocDocListDataGrid();
}
function InitTransDocListDataGrid(){
	//��תҽ���б��ʼ��
	var Columns=[[ 
		{field:'Tctpcp',title:'',hidden:'true'},
		{field:'Tdoccode',title:'����',width:200,align:'left'},
		{field:'Tdocname',title:'����',width:200,align:'left'}
    ]];
    var TransDocListDataGrid=$("#TransDocList").datagrid({
	    fit : true,
		height:'100',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'Tctpcp',
		columns :Columns,
		onDblClickRow:function(index, row){
			AddDocToTransLocList(row);
		},onLoadSuccess:function(data){
		}
	    
	});
	TransDocListDataGrid.datagrid('loadData',{ 'total':'0',rows:[] });
	
	return TransDocListDataGrid;
}

function InitTransLocDocListDataGrid(){
	var Columns=[[
		{field:'Trowid',title:'',hidden:'true'},
		{field:'Tssgroupdr',title:'',hidden:'true'},
		{field:'Tdocgroupdr',title:'',hidden:'true'},
		{field:'Tdoccode',title:'����',width:80,align:'left'},
		{field:'Trow',title:'�к�',width:100,align:'left',hidden:'true'},
		{field:'Tdocname',title:'����',width:80,align:'left'},
		{field:'Tlocdesc',title:'��¼����',width:100,align:'left'},
		{field:'Tssgroup',title:'��ȫ��',width:120,align:'left'},
		{field:'TdocgroupSel',hidden:'true'},	//������¼ҽ�����ѡ��ֵ�����ڱ���
		{field:'Tdocgroup',title:'ҽ����',width:150,align:'left'
			,editor:{
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=web.DHCSSDOCGROUPCONFIG&QueryName=QueryLocMedUnit", //PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
					valueField:'UnitDr',
					textField:'CTMUDesc',
					//required:true,
					onBeforeLoad:function(param){
						param = $.extend(param,{loc:ServerObj.QueryLocRowId});
					},
					loadFilter:function(data){
					    return data['rows'];
					},
					onSelect:function(rec){
						var editIndex=PageLogicObj.editIndex;
						var rows=PageLogicObj.m_TransLocDocList.datagrid("selectRow",editIndex).datagrid("getSelected");
						rows.TdocgroupSel=rec.UnitDr;
						//ReloadCombox();
					},
					onChange:function(newValue, oldValue){
						var editIndex=PageLogicObj.editIndex;
						if (newValue==""){
							var rows=PageLogicObj.m_TransLocDocList.datagrid("selectRow",editIndex).datagrid("getSelected");
	                        rows.TdocgroupSel="";
	                        //ReloadCombox();
						}
					}
				}
			},
			formatter:function(value, record){
				return record.Tdocgroup;
			}
		},
		{field:'Tdefault',title:'Ĭ�Ͽ���',width:100,align:'left'},
		{field:'DateActiveFrom',title:'��ʼ����',width:100,align:'left'},
		{field:'DateActiveTo',title:'��������',width:100,align:'left'},
		{field:'SSDocGoupID',title:'��¼��id',width:100,align:'left',hidden:'true'},
		//{field:'DateOutLoc',title:'�ƻ���������',width:100,align:'left'},
	]];
	var LocDocListToolBar=[
		{
			text:'����',
			iconCls: 'icon-edit',
			handler: function(){
				if (ServerObj.DocRotaryFlag!=0){
					$.messager.alert("����","��û�д�Ȩ��,���ʵ������!");
					return;
				}
				var UIConfigImgURL = "dhc.bdp.ct.dhcctlocmedunit.csp?extfilename=App/Care/DHC_CTLoc_MedUnit"
				if(typeof websys_writeMWToken=='function') UIConfigImgURL=websys_writeMWToken(UIConfigImgURL);
    			window.open(UIConfigImgURL, "", "status=1,scrollbars=1,top=100,left=100,width=1200,height=600");
			}
		},{
			text:'�鿴������תȨ��',
			iconCls: 'icon-eye',
			handler: function(){
				var SelectedRow=PageLogicObj.m_TransLocDocList.datagrid("getSelected");
				if (SelectedRow==null){
					$.messager.alert("����","��ѡ����");
					return;
				}
				var Trowid=SelectedRow.Trowid;
				if (typeof Trowid=="undefined" || Trowid==""){
					$.messager.alert("����","��ѡ����");
					return;
				}
				var defaultfalg="0";
				if (SelectedRow.Tdefault=="��") var defaultfalg=1;
				var UserID=Trowid.split("||")[0];
				if (HISUIStyleCode=="lite"){
					var $code='<div style="border:1px solid #E2E2E2;margin:10px;border-radius:4px;"><table id="UserLogonPermission"></table></div>'	
				}else{
				var $code='<div style="border:1px solid #ccc;margin:10px;border-radius:4px;"><table id="UserLogonPermission"></table></div>'
				}
				createModalDialog("Grid",$g("������תȨ��"), 900, 520,"icon-w-paper","",$code,"LoadUserLogonPermissionGrid('"+defaultfalg+"','"+Trowid+"')");
				//var UIConfigImgURL = "Otherlogonpermission.csp?UserID="+UserID;
			    //window.open(UIConfigImgURL, "", "status=1,scrollbars=1,top=100,left=100,width=1200,height=600");
			}
		},'-',
		{
			text: '����',
			iconCls: 'icon-cancel',
			handler: function(){
				//web.DHCSSDOCGROUPCONFIG.DelTDItm
				var SelectedRow=PageLogicObj.m_TransLocDocList.datagrid("getSelected");
				if (SelectedRow==null){
					$.messager.alert("����","��ѡ����");
					return;
				}
				var Trowid=SelectedRow.Trowid;
				if (typeof Trowid=="undefined" || Trowid==""){
					$.messager.alert("����","��ѡ����");
					return;
				}
				if (ServerObj.DocRotaryFlag!=0){
					$.messager.alert("����","��û�д�Ȩ��,���ʵ������!");
					return;
				}
				$("#OutLocDoc-dialog").dialog("open");
				/*var defaultfalg="";
				if (SelectedRow.Tdefault=="��") var defaultfalg=1;
				var rtn=$.cm({
				    ClassName : "web.DHCSSDOCGROUPCONFIG",
				    MethodName : "CheckUnSaveOrd",
				    defaultfalg:defaultfalg,
				    str:Trowid,
				    dataType:"text"
				},false);			
				if (rtn==1){
					if (!dhcsys_confirm("���û��ڳ��ƵĿ����ڴ���δ��ʵ��ҽ��"+",�Ƿ��������?")) return false;
				}
				var rtn=$.cm({
				    ClassName : "web.DHCSSDOCGROUPCONFIG",
				    MethodName : "DelTDItm",
				    defaultfalg:defaultfalg,
				    str:Trowid,
				    dataType:"text"
				},false)
				if (rtn=="0"){
					$.messager.alert("����","ɾ���ɹ�");
				}else{
					$.messager.alert("����","ɾ��ʧ��");
				}
				var SelectedIndex=PageLogicObj.m_TransLocDocList.datagrid("getRowIndex",SelectedRow);
				LoadTransLocDocListDataGrid();*/
			}
		},{
			text: '����',
			iconCls: 'icon-save',
			handler: function(){
				if (ServerObj.DocRotaryFlag!=0){
					$.messager.alert("����","��û�д�Ȩ��,���ʵ������!");
					return;
				}
				endEditing();
			}
		}];
	var TransLocDocListDataGrid=$("#TransLocDocList").datagrid({
	    fit : true,
		height:'100',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'Trowid',
		columns :Columns,
		toolbar :LocDocListToolBar,
		onLoadSuccess:function(data){
		},
		onDblClickRow:function(index){
			if (ServerObj.DocRotaryFlag!=0){
				$.messager.alert("����","��û�д�Ȩ��,���ʵ������!");
				return;
			}
			if ((PageLogicObj.editIndex!=="")&&(PageLogicObj.editIndex!==index)){
				$.messager.alert("����","���ڲ��������У��޷��༭��");
				return;
			}
			PageLogicObj.m_TransLocDocList
				.datagrid('selectRow', index)
				.datagrid('beginEdit', index);
			PageLogicObj.editIndex = index;
		}
	});
	TransLocDocListDataGrid.datagrid('loadData',{ 'total':'0',rows:[] });
	
	return TransLocDocListDataGrid;
}
function endEditing(){
	
	var editIndex=PageLogicObj.editIndex;
	if (editIndex === ""){
		$.messager.alert("����","û����Ҫ�����������");
		return true;
	}
	if (PageLogicObj.m_TransLocDocList.datagrid('validateRow', editIndex)){
		var EditRow=PageLogicObj.m_TransLocDocList.datagrid('getRows')[editIndex];
		var Tdocgroupdr=EditRow['Tdocgroupdr'];
		var TdocgroupSel=EditRow['TdocgroupSel'];
		
		var Trowid=EditRow['Trowid'];
		//��Ҫ�޸Ļ��߲���
		if (typeof TdocgroupSel!="undefined" && TdocgroupSel!=""){
			var result=$.cm({
				ClassName:"web.DHCSSDOCGROUPCONFIG",
				MethodName:"SaveNewTDDocGrp",
				str:Trowid,
				MedUnit:TdocgroupSel
			},false);
			if (result=="0"){
				PageLogicObj.m_TransLocDocList.datagrid('endEdit', editIndex);
				PageLogicObj.editIndex = "";
				LoadTransLocDocListDataGrid();
			}else{
				$.messager.alert("����","����ʧ��");
			}
		}else if ((typeof TdocgroupSel!="undefined")&&(Tdocgroupdr!="")&&(TdocgroupSel=="")){
			//��Ҫɾ��
			var result=$.cm({
				ClassName:"web.DHCCTLocMedUnitCareProv",
				MethodName:"Delete",
				MUCPRowid:Tdocgroupdr
			},false);
			if (result=="0"){
				PageLogicObj.m_TransLocDocList.datagrid('endEdit', editIndex);
				PageLogicObj.editIndex = "";
				LoadTransLocDocListDataGrid();
			}else{
				$.messager.alert("����","���ʧ��");
			}
		}else{
			//ʲô��û��
			PageLogicObj.m_TransLocDocList.datagrid('endEdit', editIndex);
			PageLogicObj.editIndex = "";
			LoadTransLocDocListDataGrid();
		}		
	} else {
		return false;
	}
}
function InitEvent(){
	$('#BFind').click(LoadTransDocListDataGrid);
	$('#DocCode,#DocName').keydown(FindTransDocList);
	$('#BOutLocDoc').click(CancleDocLoc);
	LoadTransDocListDataGrid();
	LoadTransLocDocListDataGrid();
}
function FindTransDocList(e){
	var key=websys_getKey(e);
	if (key==13) {
		LoadTransDocListDataGrid()
	}
	return;
}
function LoadTransLocDocListDataGrid(){
	$.cm({
	    ClassName : "web.DHCSSDOCGROUPCONFIG",
	    QueryName : "QuerySSTDocConfig",
	    loc:ServerObj.QueryLocRowId,
	    Pagerows:PageLogicObj.m_TransLocDocList.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.editIndex="";
		PageLogicObj.m_TransLocDocList.datagrid("unselectAll");
		PageLogicObj.m_TransLocDocList.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
}
function LoadTransDocListDataGrid(){
	$.cm({
	    ClassName : "web.DHCSSDOCGROUPCONFIG",
	    QueryName : "QuerySSTDocList",
	    doccode:$("#DocCode").val(),
	    docname:$("#DocName").val(),
	    Pagerows:PageLogicObj.m_TransDocListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_TransDocListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
}

function AddDocToTransLocList(row){
	if ($.isEmptyObject(row)) {
		$.messager.alert("����","����ѡ����תҽ��");
		return;
	}
	if (ServerObj.DocRotaryFlag!=0){
		$.messager.alert("����","��û�д�Ȩ��,���ʵ������!");
		return;
	}
	$.messager.confirm('��ȷ��!','ȷ�ϼ��뱾����תҽ���б���?',
	    function(r){
		    if (r==false){
				return;
			}
			
			var ctpcp=row.Tctpcp;
			var result=$.cm({
				ClassName:"web.DHCSSDOCGROUPCONFIG",
				MethodName:"SaveTDocItm",
				dataType:"text",
				ctpcp:ctpcp,
				currlocdr:session['LOGON.CTLOCID'],
				currgrpdr:session['LOGON.GROUPID'],
				adduser:session['LOGON.USERID']
				},false);
			if (result!=0){
				$.messager.alert("����","����ʧ��:"+result);
				return;
			}else{
				LoadTransLocDocListDataGrid();
			}
	    }
	);
	
}
function CancleDocLoc(){
	var SelectedRow=PageLogicObj.m_TransLocDocList.datagrid("getSelected");
	var Trowid=SelectedRow.Trowid;
	var defaultfalg="";
	if (SelectedRow.Tdefault==$g("��")) var defaultfalg=1;
	var rtn=$.cm({
	    ClassName : "web.DHCSSDOCGROUPCONFIG",
	    MethodName : "CheckUnSaveOrd",
	    defaultfalg:defaultfalg,
	    str:Trowid,
	    dataType:"text"
	},false);			
	if (rtn==1){
		$.messager.confirm('��ʾ', $g("���û��ڳ��ƵĿ����ڴ���δ��ʵ��ҽ��")+$g(",�Ƿ��������?"), function(r){
			if (r){
				Save()
			}
		});
	}else{
		Save()
		}
	function Save(){
		var SelectedRow=PageLogicObj.m_TransLocDocList.datagrid("getSelected");	
		var SSDocGoupID=SelectedRow.SSDocGoupID;
		var EndDate=$HUI.datebox("#GroupEndDate").getValue();
		if (EndDate==""){
			$.messager.alert("����","�������ڲ���Ϊ��!");
					return;
			}
		var rtn=$.cm({
		    ClassName : "web.DHCSSDOCGROUPCONFIG",
		    MethodName : "DelTDItmPlan",
		    defaultfalg:defaultfalg,
		    str:Trowid,
		    EndDate:EndDate, 
		    SSGroupID:SSDocGoupID ,
		    UserID:session['LOGON.USERID'],
		    dataType:"text"
		},false)
		/*var rtn=$.cm({
		    ClassName : "web.DHCSSDOCGROUPCONFIG",
		    MethodName : "DelTDItm",
		    defaultfalg:defaultfalg,
		    str:Trowid,
		    dataType:"text"
		},false)*/
		if (rtn=="0"){
			$("#OutLocDoc-dialog").dialog("close");
			$.messager.alert("����","���Ƴɹ�");
			$HUI.datebox("#GroupEndDate").setValue("");
		}else{
			$.messager.alert("����","ɾ��ʧ��");
		}
		var SelectedIndex=PageLogicObj.m_TransLocDocList.datagrid("getRowIndex",SelectedRow);
		LoadTransLocDocListDataGrid();
	}
	
	}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    },
	    onBeforeOpen:function(){
		    if (_event!="") eval(_event);
		    return true;
		}
    });
}
function LoadUserLogonPermissionGrid(defaultfalg,Trowid){
	var Columns=[[    
		{field:'RowId',hidden:'true'}, 
		{field:'CTLOCDesc',title:'��¼����',width:200}, 
		{field:'SSGRPDesc',title:'��ȫ��',width:200},
		{field:'HOSPDesc',title:'ҽԺ',width:230},
		{field:'StartDate',title:'��ʼ����',width:100},
		{field:'EndDate',title:'��������',width:100}
    ]];
	$.q({
	    ClassName:"web.DHCSSDOCGROUPCONFIG",
	    QueryName:"GetUserOtherLogonDep",
	    defaultfalg:defaultfalg,
	    str:Trowid,
	    rows:99999
	},function(GridData){
		$HUI.datagrid('#UserLogonPermission',{
		    data:GridData,
		    idField:'RowId',
		    fit : false,
		    width:870,
		    height:460,
		    border: false,
		    columns:Columns
		});
	});

}
