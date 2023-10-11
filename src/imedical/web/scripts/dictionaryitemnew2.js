<!--js dictionaryitemnew2.js-->
/*
 * ͨ���ֵ���Ŀά��
 * FileName: dictionaryitemnew2.js
 * zjb 2022-08-16
 */
<!--��ں���-->
var ChoDicCode="";
var TreeSehKey="";
var ChooTreeID=0; //ѡ��tree��id��Ϊ��ˢ��tree���ٴ�Ĭ��ѡ��֮ǰѡ��
var searchDicListKey=""
$(function() {
	setPageLayout();
});
function setPageLayout() {
	
	
	var tableName = "User.INSUTarContrast";
	var defHospId = 2;//
	$("#hospital").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			loadDicTree(TreeSehKey);
		}
	});
	//initdicconfigCombo();
	iniTreeGrid();
	
	
	//SetDicInfoItem("SYS","");
	DeleteDic();
	UpdateData();
	ClearData();
	
	$("#searchTree").searchbox({
		searcher: function(value) {
			TreeSehKey=value;
			loadDicTree(value);
		}
	});
	$("#searchDicList").searchbox({
		searcher: function(value) {
			searchDicListKey=value;
			SetDicInfoItem(ChoDicCode, value);
		}
	});
	//��Ч���
	$HUI.combobox("#ActFlag", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.CFG.COM.DictionaryCtl";
			param.QueryName = "QueryDicDataInfo";
			param.Type = "ActFlag";
			param.KeyCode="";
			param.ResultSetType = 'array';
			return true;
		},
		onLoadSuccess: function (data) {
			/* if (data.length > 1) {
				$(this).combobox("select", data[0].DicCode);
			} */
		},
		onChange:function(val){
			
		}
	});
	//$(".tree-expanded-hover").disabled(false);
	///����˵���������ֵ���Ϣ
	$('#ImportBtn').click(function() {
		var UserDr = "1";
		var GlobalDataFlg = "0"; //�Ƿ񱣴浽��ʱglobal�ı�־ 1 ���浽��ʱglobal 0 ���浽����(�����������ͷ�����)
		var ClassName = "BILL.CFG.COM.DictionaryCtl"; //���봦������
		var MethodName = "ImportDicdataByExcel"; //���봦������
		var ExtStrPam = ""; //���ò���()
		//Insuqc_ExcelTool.ExcelImport(ClassName,MethodName,"0",ExtStrPam,UserDr,2,SetDicInfoItem());
		ExcelImport(GlobalDataFlg, ClassName, MethodName, ExtStrPam,SetDicInfoItem);		
	});
}

function iniTreeGrid(){
	$HUI.tree("#SYSTree", {
		/* idField:'Rowid',
		rownumbers:true,
    	treeField:'DicCode',
		onDblClickRow:function(index,row){
			if(row.TreeStatus=="0"){
				if(row.state == "closed"){
					$(this).treegrid('expand',index);
				}else{
					$(this).treegrid('collapse',index);
				}
			}
		},
		fit: true,
		border: false,
		singleSelect: true,
		//fitColumns: true,
		pagination: true,
		pageList:[50,100],
		pageSize: 50,
		columns: [[
			{title: '�ֵ�����', field: 'DicCode',
			formatter:function(val,row,index){
				var rtn = row.TreeStatus=="0"?row.DicCode:row.DicCodeD;
				
				return rtn;	
			}
			},
			{title: '�ֵ�����', field: 'DicDescD', width: 150,
			 formatter:function(val,row,index){
				var rtn = row.TreeStatus=="0"?row.DicDesc:row.DicDescD;
				
				return rtn;	
			}
			},
		]], */
		lines:true,
		animate: true,
		onBeforeCollapse:function(node){//�ڵ��۵�ǰ���������� false ��ȡ���۵�������
            //if(node.type==0){
               return false;//�����۵�
            //}
        },
		onLoadSuccess: function(data) {
				$("#SYSTree li:eq("+ChooTreeID+")").find("div").addClass("tree-node-selected");   //����һ���ڵ����  
           		var n = $("#SYSTree").tree("getSelected");  
           		if(n!=null){  
                $("#SYSTree").tree("select",n.target);    //�൱��Ĭ�ϵ����һ�½ڵ㣬ִ��onSelect����  
           } 
		},
		onClick: function (data) {
			//$(this).tree("toggle", data.target);
		},
		onSelect: function(data) {
			ChooTreeID=data.id-1;
			ChoDicCode=data.attributes.DicCode;
			SetDicInfoItem(data.attributes.DicCode);
			
		},
		onLoadError:function(a){
			//alert(2)
		}
	});
}
function loadDicTree(TreeKey){
	
	$.cm({
		ClassName:"BILL.CFG.COM.DictionaryCtl",
		QueryName:"QueryDetComboxInfo",
		KeyCode:TreeKey,
		hospDr:  getValueById("hospital"),
		rows:999999
	},function(jsonData){	
	/* 	var rows = 0;
		for (i=0;i<jsonData.rows.length;i++){
			if(jsonData.rows[i].TreeStatus == "0"){
				jsonData.rows[i]['state']='closed';
				rows++;
			}
		};
		jsonData.total = rows;
		$('#SYSTree').treegrid('loadData',jsonData); */
		//ת�����ݳ�tree�ṹ
		var CharData=[];
		var ChildNum=0;
		for (i=0;i<jsonData.rows.length;i++) 
		{
			var objData={};
			if(jsonData.rows[i].DicCode == "SYS"){
				objData.id=i+1;
				objData.text=jsonData.rows[i].DicDesc+"("+jsonData.rows[i].DicNum+")";
				objData.state='open';//closed
				objData.TreeFlo='0';//����
				objData.children=[];
				objData.attributes=jsonData.rows[i];
				CharData.push(objData);
				ChildNum=ChildNum+1;
				
			}
			else
			{
				objData.id=i+1;
				objData.TreeFlo='1';//�Ӽ�
				objData.text=jsonData.rows[i].DicDesc+"("+jsonData.rows[i].DicNum+")";
				objData.attributes=jsonData.rows[i];
				//objData.state='closed';
				CharData[ChildNum-1]['children'].push(objData);
			}
		}
		//tree��ֵ
		$('#SYSTree').tree({ data: CharData });
	});
	
	//var treesel=$("#SYSTree").parents();
	//$("#SYSTree").tree('select',treesel);
}

function DeleteDic() {
	$('#DeleteBtn').click(function() {
		removeDic();
	});
}
function UpdateData() {
	$('#UpdateBtn').click(function() {
		updateData();
	});
}
function ClearData() {
	$('#clearBtn').click(function() {
		$('#DicCode').val("");
		$('#DicDesc').val("");
		$('#DefaultValue').val("");
		$("#StartDate").datebox("setValue", "");
		$("#EndDate").datebox("setValue", "");
		$('#EndDate').val("");
		//$('#Creator').val("");
		$('#DicMemo').val("");
		$('#DataSrcFilterMode').val("");	//����Դ����ģʽ
		$('#DataSrcTableProperty').val("");	//����Դ�������ֶ���
		$('#DicList').datagrid('unselectAll');	//���ѡ��
	});
}
//ҵ������������
//ҵ������������
function initdicconfigCombo() {
	$HUI.combobox("#DicType", {
		valueField: 'DicCode',
		textField: 'DicDesc',
		url: $URL,
		onBeforeLoad: function(param) {
			param.ClassName = "BILL.CFG.COM.DictionaryCtl";
			param.QueryName = 'QueryDetComboxInfo';

			param.ResultSetType = 'Array';
			$("#DicType").combobox('setValue', "SYS");
		},
		onChange: function() {
			SetDicInfoItem();
			$('#DicCode').val("");
			$('#DicDesc').val("");
			$('#DefaultValue').val("");
			$("#StartDate").datebox("setValue", "");
			$('#EndDate').datebox("setValue", "");
			//$('#Creator').val("");
			$('#DicMemo').val("");
			$('#DataSrcFilterMode').val("");	//����Դ����ģʽ
			$('#DataSrcTableProperty').val("");	//����Դ�������ֶ���
		}

	})

};
//�ֵ���ϸ��Ϣ�б�
function SetDicInfoItem(DicCode,KeyCode) {
	//var DicType = $('#DicType').combobox('getValue');
	$('#DicList').datagrid({
		pagination: true,
		// ��ҳ������
		pageSize: 10,
		pageList: [10,20,50,100],
		singleSelect: true,
		striped: false,	// ��ʾ������Ч��
		fitColumns:false,
		border:false,
		//height: 300,
		rownumbers: true,
		fit: true,
		url: $URL,
		queryParams: {
			ClassName: "BILL.CFG.COM.DictionaryCtl",
			QueryName: "QueryDicDataInfo",
			KeyCode:KeyCode,
			Type: DicCode
		},
		columns: [[{
			field: 'ID',
			title: 'ID',
			hidden: true
		},
		{
			field: 'DicType',
			title: '�ֵ�����',
			width: 150
		},
		{
			field: 'DicCode',
			title: '�ֵ����',
			width: 150
		},
		{
			field: 'DicDesc',
			title: '�ֵ�����',
			width: 150
		},
		{
			field: 'DefaultValue',
			title: 'Ĭ��ֵ',
			width: 150,
			showTip:true
		},
		{
			field: 'ActFlag',
			title: '��Ч��־',
			width: 100,
			formatter: function (value, row, index) {
					var rtn = tkMakeServerCall("BILL.CFG.COM.DictionaryCtl","GetDicInfoByTypeCode","ActFlag", value, getValueById("hospital"),"4");
					return (value == "Y") ? rtn : "<font color='#f16e57'>" + rtn +"</font>";
			}
		},
		{
			field: 'StartDate',
			title: '��ʼ����',
			width: 100
		},
		{
			field: 'DateTo',
			title: '��������',
			width: 100
		},
		{
			field: 'Creator',
			title: '������',
			width: 100
		},
		{
			field: 'DicMemo',
			title: 'ʹ�ó���',
			width: 100,
			showTip:true
		},
		{
			field: 'DataSrcFilterMode',
			title: '����Դ����ģʽ',
			width: 150,
			showTip:true
		},
		{
			field: 'DataSrcTableProperty',
			title: '����Դ�������ֶ���',
			width: 150,
			showTip:true
		}
		]],
		onClickRow: function(rowIndex, rowData) {

			var selected = $('#DicList').datagrid('getSelected');
			if (selected) {
				SetEditAreaVaule(selected);
			} else {
				ClearEditeForm();
			}

		}
	});
}
//��ѡ�е�������Ϣ��ӵ��ֿ����		
function SetEditAreaVaule(data) {
	//$("#DicType").combobox('setValue', data.DicType);
	$('#DicCode').val(data.DicCode);
	$('#DicDesc').val(data.DicDesc);
	$('#DefaultValue').val(data.DefaultValue);
	$("#StartDate").datebox("setValue", data.StartDate);
	$("#EndDate").datebox("setValue", data.DateTo);
	//$('#Creator').val(data.Creator);
	$('#DicMemo').val(data.DicMemo);
	$('#DataSrcFilterMode').val(data.DataSrcFilterMode);	//����Դ����ģʽ
	$('#DataSrcTableProperty').val(data.DataSrcTableProperty);	//����Դ�������ֶ���
	setValueById('ActFlag',data.ActFlag);
}
function ClearEditeForm(data) {
	//$("#DicType").combobox('setValue', data.DicType);
	$('#DicCode').val("");
	$('#DicDesc').val("");
	$('#DefaultValue').val("");
	$("#StartDate").datebox("setValue", "");
	$("#EndDate").datebox("setValue", "");
	//$('#Creator').val("");
	$('#DicMemo').val("");
	$('#DataSrcFilterMode').val("");	//����Դ����ģʽ
	$('#DataSrcTableProperty').val("");	//����Դ�������ֶ���
	setValueById('ActFlag',"");
}

//ɾ��
function removeDic() {
	var selectedRow = $('#DicList').datagrid('getSelected');
	if (!selectedRow) {
		$.messager.alert('��Ϣ', '��ѡ����Ҫɾ������');
		return;
	}
	$.messager.confirm('��Ϣ', '��ȷ��Ҫɾ��������¼��?',
	function(r) {
		if (!r) {
			return;
		}
		var ID = selectedRow.ID;
		$.m({
			ClassName: "BILL.CFG.COM.DictionaryCtl",
			MethodName: "DeleteDicDataInfo",
			ID: ID
		}, function(value) {
			if (value.length != 0) {
				$.messager.alert('��Ϣ', value);
				ClearEditeForm(selectedRow);
				SetDicInfoItem(ChoDicCode,searchDicListKey);
				if ($("#SYSTree").tree("getSelected").attributes.DicCode == "SYS"){
					//$("#SYSTree").tree('reload');
					loadDicTree(TreeSehKey);
				}
				return;
			}
		});
	});
	
}

//����
function updateData() {
	var DicCode = $('#DicCode').val(); //�ֵ����
	if ($.trim(DicCode) == "") {
		$.messager.alert('��ʾ��Ϣ', "�ֵ���벻��Ϊ�գ�");
		return;
	}
	var DicMemo = $('#DicMemo').val(); 
	if ($.trim(DicMemo) == "" ) {
		$.messager.alert('��ʾ��Ϣ', "ʹ�ó�������Ϊ�գ�");
		return;
	}
	var selectedRow = $('#DicList').datagrid('getSelected');
	if ((!selectedRow) || (selectedRow.ID == undefined)) {
		var TreeData=$("#SYSTree").tree("getSelected");
		var DataStr = TreeData.attributes.DicCode + "^" + $('#DicCode').val() + "^" + $("#DicDesc").val() + "^" + $("#DefaultValue").val() + "^" + $("#StartDate").datebox("getValue") + "^" + $("#EndDate").datebox("getValue") + "^" + session['LOGON.USERCODE'] + "^" + $("#DicMemo").val()+ "^" + $("#DataSrcFilterMode").val()+ "^" + $("#DataSrcTableProperty").val()+"^"+getValueById('ActFlag');
		$.m({
			ClassName: "BILL.CFG.COM.DictionaryCtl",
			MethodName: "SaveDicdataInfo",
			DataStr: DataStr
		}, function(value) {
			if (value.length != 0) {
				$.messager.alert('��Ϣ', value);
				var data="";//{DicType:$('#DicList').combobox('getValue')}
				ClearEditeForm(data);
				//SetDicInfoItem(ChoDicCode,searchDicListKey);
				//if ($("#SYSTree").tree("getSelected").attributes.DicCode == "SYS"){	
				loadDicTree(TreeSehKey);
				//}
			}
		});

	} else {
		var ID = selectedRow.ID;
		var TreeData=$("#SYSTree").tree("getSelected");
		var DicData=$("#DicList").datagrid("getSelected");
		var DataStr = ID + "^" + TreeData.attributes.DicCode + "^" + $('#DicCode').val() + "^" + $("#DicDesc").val() + "^" + $("#DefaultValue").val() + "^" + $("#StartDate").datebox("getValue") + "^" + $("#EndDate").datebox("getValue") + "^" + DicData.Creator + "^" + $("#DicMemo").val()+ "^" + $("#DataSrcFilterMode").val()+ "^" + $("#DataSrcTableProperty").val()+"^"+getValueById('ActFlag');
		$.m({
			ClassName: "BILL.CFG.COM.DictionaryCtl",
			MethodName: "UpdateDicDataInfo",
			DataStr: DataStr
		}, function(value) {
			if (value.length != 0) {
				$.messager.alert('��Ϣ', value);
				ClearEditeForm(selectedRow);
				SetDicInfoItem(ChoDicCode,searchDicListKey);
				//if ($("#SYSTree").tree("getSelected").attributes.DicCode == "SYS"){
					//$("#SYSTree").tree('reload');
					//loadDicTree(TreeSehKey);
				//}
				return;
			}
		});
	}
}
