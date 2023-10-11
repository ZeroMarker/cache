/// Descript: ����걾�ֵ�ά��
/// Creator : yuliping
/// Date    : 2017-07-08
var editRow="";
/// ҳ���ʼ������
function initPageDefault(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("DHC_AppTestSpec",hospStr);
	hospComp.jdata.options.onSelect  = function(){
		initTestItem();
		} 
	initTestItem();       	/// ��ʼҳ��DataGrid��������Ŀ
	
	//ͬʱ������������󶨻س��¼�
    $('#ATSCode,#ATSDesc').bind('keypress',function(event){
	    
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}) //���ò�ѯ
        }
    });
	
}
///��������Ŀ
function initTestItem(){
	
	var Hospeditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto" , //���������߶��Զ�����,
			required: true
		}
	}
	
	var atsflag={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"��"},{"value":"N","text":"��"}],
			
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'ActiveFlag'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'ActiveFlagCode'});
				$(ed.target).val(option.value); 
			} 
			
		}
	}
	var catinsflag={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"��"},{"value":"N","text":"��"}],
			
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'CatInsFlag'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'CatInsFlagCode'});
				$(ed.target).val(option.value); 
			} 
			
		}
	}
	var mulflag={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"��"},{"value":"N","text":"��"}],
			
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'MulFlag'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'MulFlagCode'});
				$(ed.target).val(option.value); 
			} 
			
		}
	}
	var catEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPTestItem&MethodName=QueryArcCatList",
			//required:true,
			panelHeight:"auto"  //���������߶��Զ�����
			
		}
	}
	/// �ı��༭��
	var textEditor={
		type: 'validatebox',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	// ����columns
	
	var columns=[[
		{field:"ATSCode",title:'��Ŀ����',width:150,editor:textEditor},
		{field:"ATSDesc",title:'��Ŀ����',width:150,editor:textEditor},
		{field:"CatDesc",title:'�걾��������',width:140,editor:catEditor,hidden:'true'},
		{field:"HospDesc",title:'ҽԺ��ʶ',width:200}, //editor:Hospeditor
		{field:"ActiveFlag",title:'�Ƿ����',width:80,align:'center',editor:atsflag},
		{field:"ActiveFlagCode",title:'ActiveFlagCode',width:80,align:'center',editor:textEditor,hidden:'true'},
		{field:"CatDr",title:'CatDr',width:20,hidden:'true',align:'center'},
		{field:"HospDr",title:'HospDr',width:20,hidden:'true',align:'center'},
		{field:"ATSid",title:'ATSid',width:20,hidden:'true',align:'center'},
		{field:"MulFlag",title:'��ѡ',width:80,align:'center',editor:mulflag},
		{field:"MulFlagCode",title:'MulFlagCode',width:80,align:'center',editor:textEditor,hidden:'true'},
		{field:"CatInsFlag",title:'�Ƿ�Ϊ����',width:80,align:'center',editor:catinsflag},
		{field:"CatInsFlagCode",title:'CatInsFlagCode',width:80,align:'center',editor:textEditor,hidden:'true'}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            onClickRow(rowIndex,rowData) 
            editRow=rowIndex;
        }
	};
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPTestSpec&MethodName=ListAPPTestSpec&HospID="+HospID;
	new ListComponent('datagrid', columns, uniturl, option).Init(); 
}
function addRow(){
	var HospDesc=$HUI.combogrid('#_HospList').getText();
	commonAddRow({'datagrid':'#datagrid',value:{'HospDesc':HospDesc,'ActiveFlag':'Y','ActiveFlagCode':'Y','MulFlag':'Y','MulFlagCode':'Y','CatInsFlag':'Y','CatInsFlagCode':'Y'}})
	editRow=0;
}
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}
function save(){
	saveByDataGridNew("web.DHCAPPTestSpec","SaveUpdTestSpec","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==2){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});	
}
function saveByDataGridNew(className,methodName,gridid,handle,datatype){
	if(!endEditing(gridid)){
		$.messager.alert("��ʾ","��༭��������!");
		return;
	}
	var rowsData = $(gridid).datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var rowData=[];
		var fileds=$(gridid).datagrid('getColumnFields')
		for(var j=0;j<fileds.length;j++){
			rowData.push(typeof(rowsData[i][fileds[j]]) == "undefined"?0:rowsData[i][fileds[j]])
		}
		dataList.push(rowData.join("^"));
	} 
	var params=dataList.join("$$");
	//alert(params)
	var HospID=$HUI.combogrid('#_HospList').getValue();
	runClassMethod(className,methodName,{'params':params,'HospID':HospID},handle,datatype)
}

function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCAPPTestSpec","RemoveTestSpec",{'Id':row.ATSid},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}
var m_ReBLMapDataGrid
function ConItemRow(){
	var rowsData = $("#datagrid").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ", "��ѡ��һ����Ŀ!", 'info');
		return 
	}
	$("#ReBLMap-dialog").dialog("open");
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.cm({
			ClassName:"web.DHCAPPTestSpec",
			QueryName:"FindArcItem",
			HospID:HospID,
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#BLMap", {
				editable:false,
				valueField: 'arcimid',
				textField: 'arcitmdesc', 
				data: GridData["rows"],
				onLoadSuccess:function(){
					$("#BLMap").combobox('select','');
				}
			 });
	});
	m_ReBLMapDataGrid=InitReBLMapDataGrid();
	LoadReBLMapDataGrid();
	}
function InitReBLMapDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {ConItemaddClickHandle();}
    }, {
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function() {ConItemdelectClickHandle();}
    }];
	var Columns=[[ 
		{field:'RowID',hidden:true,title:'RowID'},
		{field:'arcimid',hidden:true,title:'BLMapID'},
		{field:'arcitmdesc',title:'ҽ��������',width:100},
		{field:'arcitmcode',title:'ҽ������',width:100}
    ]]
	var ReHospitalDataGrid=$("#ReBLMapTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'RowID',
		columns :Columns,
		toolbar:toobar
	}); 
	return ReHospitalDataGrid;
}
function LoadReBLMapDataGrid(){
	var rowsData = $("#datagrid").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ", "��ѡ��һ����Ŀ!", 'info');
		return 
	}
	var PisDicItem=rowsData["ATSid"]
	$.q({
	    ClassName : "web.DHCAPPTestSpec",
	    QueryName : "FindAppTestSpecRelArc",
	    PisDicItem:PisDicItem,
	    Pagerows:m_ReBLMapDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		m_ReBLMapDataGrid.datagrid("unselectAll");
		m_ReBLMapDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function ConItemaddClickHandle(){
	var rowsData = $("#datagrid").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ", "��ѡ��һ����Ŀ!", 'info');
		return 
	}
	var TestSpec=rowsData["ATSid"]
	var TestSpecArc=$("#BLMap").combobox("getValue");
	if (TestSpecArc=="") {
		$.messager.alert("��ʾ", "��ѡ��ҽ����!", 'info');
		return 
	}
	$.cm({
		ClassName:"web.DHCAPPTestSpec",
		MethodName:"InsertAppTestSpecRelArc",
		TestSpec:TestSpec,
		TestSpecArc:TestSpecArc,
		dataType:"text",
	},function(data){
		if(data==-1) {
			$.messager.alert("��ʾ","����ʧ��!��¼�ظ�!");
		}else{
			$.messager.popover({msg: '���ӳɹ�!',type:'success',timeout: 1000});
			LoadReBLMapDataGrid();
		}
	})
}
function ConItemdelectClickHandle(){
	var rowsData = m_ReBLMapDataGrid.datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null) {
		$.messager.alert("��ʾ", "��ѡ��һ����Ŀ!", 'info');
		return 
	}
	var RowID=rowsData.RowID
	$.cm({
		ClassName:"web.DHCAPPTestSpec",
		MethodName:"DelectAppTestSpecRelArc",
		RowID:RowID,
		dataType:"text",
	},function(data){
		$.messager.popover({msg: 'ɾ���ɹ�!',type:'success',timeout: 1000});
		LoadReBLMapDataGrid();
	})
}
function translateword(){
	var SelectedRow = $("#datagrid").datagrid('getSelected');
	if (!SelectedRow){
		$.messager.alert("��ʾ","��ѡ����Ҫ�������!","info");
		return false;
	}
	CreatTranLate("User.DHCAppTestSpec","ATSDesc",SelectedRow["ATSDesc"])	
	}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
