/// Creator: qqa
/// CreateDate: 2019-04-28
//  Descript: MDT�����޸�ʵ�ʻ���ҽ��

var CstID = "";     /// ����ID
var DisGrpID = "";  /// ���Ѳ���ID
var editIndex=-1;
var editGrpRow = -1;
var editExpRow = -1;
var isEditFlag = 0;     /// ҳ���Ƿ�ɱ༭
var LType = "CONSULT";  /// ������Ҵ���
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
$(function(){
	initParams();
	
	initDatagrid();
	
	InitLocGrpGrid();
	
	/// ��ʼ��ҳ��datagrid
	InitOuterExpGrid();
})

function initParams(){
	
	CstID = getParam("ID");     /// ����ID
	DisGrpID = getParam("DisGrpID");  /// ���Ѳ���ID
}

/// ��ʼ���������б�
function InitLocGrpGrid(){
	
	/// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ְ�Ʊ༭��
	var PrvTpEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp"+"&MWToken="+websys_getMWToken(),
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //���������߶��Զ�����
			blurValidValue:true,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				if ($(ed.target).val() == ""){
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', "");
					$.messager.alert("��ʾ","����ȷ��ר�ҿ��ң�","warning");
					return;
				}
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);

				///���ü���ָ��
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val();
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	// ���ұ༭��
	var LocEditor={
		type: 'combobox',//���ñ༭��ʽ
		options:{
			valueField: "value", 
			textField: "text",
			mode:'remote',
			enterNullValueClear:false,
			url: $URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID="+session['LOGON.HOSPID']+"&MWToken="+websys_getMWToken(),
			blurValidValue:true,
			onSelect:function(option) {
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val(option.value);
				
				///���ҽ��
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// ���ְ��
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
				
			},
			onShowPanel:function(){
				return true;
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc&DisGrpID="+DisGrpID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}		   
		}
	}
		
	// ҽʦ�༭��
	var DocEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			mode:'remote',
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);

				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
			    
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				//var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ DisGrpID;
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
					$(ed.target).val();
				}
			}
		}
	}
	
	///  ����columns
     var columns=[[
		{field:'itmID',title:'ID',width:100,align:'center',hidden:true},
		{field:'LocID',title:'����ID',width:100,hidden:true,editor:texteditor},
		{field:'LocDesc',title:'����',width:230,editor:LocEditor},
		{field:'UserID',title:'ҽ��ID',width:110,hidden:true,editor:texteditor},
		{field:'UserName',title:'ҽ��',width:120,editor:DocEditor},
		{field:'PrvTpID',title:'ְ��ID',width:100,hidden:true,editor:texteditor},
		{field:'PrvTp',title:'ְ��',width:160,hidden:false,editor:PrvTpEditor},
		{field:'AcceptFlag',title:'����',width:100,align:'center',formatter:
			function (value, row, index){
				if (value == 1){
					return '<font style="color:green;font-weight:bold;">��</font>';
				}else {
					return '<font style="color:red;font-weight:bold;">��</font>';
				}
			}
		},
		{field:'RefReason',title:'�ظ����',width:530},
		{field:'IsConssignIn',title:'�Ѿ�ǩ��',width:120,align:'center',hidden:false,formatter:function(value){
			if(value==1) return "��";
			if(value!=1) return "";
		}},
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		title:'Ժ��ר��',
		fit:true,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		iconCls:'icon-paper',
		border:true,
		bodyCls:'panel-header-gray',
		headerCls:'panel-header-gray',
	    onDblClickRow: function (rowIndex, rowData) {
			
			if ((editIndex != -1)||(editIndex == 0)) { 
                $("#bmDocList").datagrid('endEdit', editIndex); 
            }
            
            if ((editExpRow != -1)||(editExpRow == 0)) { 
                $("#OuterExpList").datagrid('endEdit', editExpRow); 
            }
            
            var isConssignIn = rowData.IsConssignIn;
			if(isConssignIn==1){
				$.messager.alert('��ʾ','�Ѿ�ǩ���������޸ģ�');
				return;
			}
            
            $("#bmDocList").datagrid('beginEdit', rowIndex); 
			
            editIndex = rowIndex;          
        }
	};
	/// ��������
	
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=ListDocList&ID="+CstID+"&MWToken="+websys_getMWToken();
	new ListComponent('bmDocList', columns, uniturl, option).Init();
}

/// ���
function Clear(FlagCode){
	
}

function initDatagrid(){
	
	
}

function addRow(){
	commonAddRow({'datagrid':'#bmDocList'})
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#bmDocList");
}

function save(){
	
	/// �����༭
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }
	var LocArr = [];
	var ConsDetArr=[];
	var TmpCarePrv = ""; /// ר��
	var CarePrvArr = [];
	var rowData = $('#bmDocList').datagrid('getRows');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^^"+ item.itmID;
		    ConsDetArr.push(TmpData);
		    if ($.inArray(item.LocID +"^"+ item.UserID,LocArr) == -1){
				LocArr.push(item.LocID +"^"+ item.UserID);
			}
			/// ��Ա�ظ����
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	}
	var rowData = $('#bmDocList').datagrid('getRows');
	for (var n = 0; n < rowData.length; n++){
		var item = rowData[n];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^^"+ item.itmID;
		    ConsDetArr.push(TmpData);
		    if ($.inArray(item.LocID +"^"+ item.UserID,LocArr) == -1){
				LocArr.push(item.LocID +"^"+ item.UserID);
			}
			/// ��Ա�ظ����
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	}	
			
	if ((memControlFlag == 1)&(LocArr.length < 3)){
		$.messager.alert("��ʾ:","����ר�����Ա����������3�ˣ�","warning");
		return;	
	}
	
	if (TmpCarePrv != ""){
		$.messager.alert("��ʾ:","����ר�ң�"+ TmpCarePrv +"���ظ���ӣ�","warning");
		return;	
	}
	
	/// ����
	var makLocParams = ConsDetArr.join("@");
	if (makLocParams == ""){
		$.messager.alert("��ʾ:","������Ҳ���Ϊ�գ�","warning");
		return;	
	}
	
	/// ��Ժר��
	var repExpArr = [];
	var LocExpArr = [];
	var OuterExpList = "";
	var rowData = $('#OuterExpList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
			var TmpData = item.UserID +"^"+ item.UserName +"^"+ item.LocID +"^"+ item.PrvTpID +"^"+ item.TelPhone;
			LocExpArr.push(TmpData);
		    if ($.inArray(item.UserID, repExpArr) == -1){
				repExpArr.push(item.UserID);
			}else{
				TmpCarePrv = item.UserName;
			}
		}
	})
	if (TmpCarePrv != ""){
		$.messager.alert("��ʾ","����ר�ң�"+ TmpCarePrv +"���ظ���ӣ�","warning");
		return;	
	}
	var makOuterExp = LocExpArr.join("@");	

	/// ����
	runClassMethod("web.DHCMDTConsult","InsMakResss",{"CstID":CstID, "makLocParams":makLocParams, "makOuterExp":makOuterExp},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ǵ�����״̬����������а��Ų�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","����ɹ���","success",function(){
				TakClsWin(); /// �ر�
			});
		}
	},'',false)			
}

/// �ر�
function TakClsWin(){
	
	commonParentCloseWin();
}

function cancelLocGrp(){
	
	if ($("#bmDocList").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	var row =$("#bmDocList").datagrid('getSelected'); 
	var isConssignIn = row.IsConssignIn;
	if(isConssignIn==1){
		$.messager.alert('��ʾ','�Ѿ�ǩ��������ɾ����');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	        
		 runClassMethod("web.DHCMDTConsult","RemoveCstItm",{'CstItmID':row.itmID},function(data){ $('#bmDocList').datagrid('load'); })
    }    
}); 
}

function cancel(){
	
	if ($("#bmDocList").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	var row =$("#bmDocList").datagrid('getSelected'); 
	var isConssignIn = row.IsConssignIn;
	if(isConssignIn==1){
		$.messager.alert('��ʾ','�Ѿ�ǩ��������ɾ����');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	        
		 runClassMethod("web.DHCMDTConsult","RemoveCstItm",{'CstItmID':row.itmID},function(data){ $('#bmDocList').datagrid('load'); })
    }    
}); 
}

/// ɾ������
function delGrpRow(){
	
	/// �����༭
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }
    
	var rowData = $('#bmDocList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ','����ѡ���ɾ���У�','warning');
		return;
	}
	// ��ȡѡ���е�Index��ֵ
	var rowIndex=$('#bmDocList').datagrid('getRowIndex',rowData);
    $('#bmDocList').datagrid('deleteRow',rowIndex);
    var rows = $('#bmDocList').datagrid("getRows");  //���»�ȡ���������к�
    $('#bmDocList').datagrid("loadData", rows);
}

/// ɾ������
function delLocRow(){
	
	var rowData = $('#bmDocList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ','����ѡ���ɾ���У�','warning');
		return;
	}
	
	var itmID = rowData.itmID;
	
	$cm({
		"ClassName":"web.DHCMDTConsult",
		"MethodName":"DeletConsItm",
		"CstItmID":itmID,
		"dataType":"text"
	},function(ret){
		if(ret!=0){
			$.messager.alert('��ʾ',ret,'warning');
			return;	
		}else{
			$("#bmDocList").datagrid("reload");	
		}
	})
	
}

function TakPreTime(){
	
	/// ȫԺ�����б� �����༭
    if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }
    
    /// ��Ժר���б� �����༭
    if ((editExpRow != -1)||(editExpRow == 0)) { 
        $("#OuterExpList").datagrid('endEdit', editExpRow); 
    }
    
	save(); 
}

/// ��ʼ����Ժר���б�
function InitOuterExpGrid(){
	
	/// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	/// �༭��
	var numbereditor={
		type: 'numberbox',//���ñ༭��ʽ
		options: {
			//required: true //���ñ༭��������
		}
	}
	
	// ְ�Ʊ༭��
	var PrvTpEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp"+"&MWToken="+websys_getMWToken(),
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //���������߶��Զ�����
			blurValidValue:true,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	/// ����
	var LocEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCMDTDicItem&MethodName=jsonParDicItem&mCode=OutLoc&HospID="+ LgHospID+"&MWToken="+websys_getMWToken(),
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///��������ֵ
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val(option.value); 
			}
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'LocID',title:'����ID',width:100,align:'left',hidden:true,editor:texteditor},
		{field:'LocDesc',title:'����',width:200,align:'left',editor:LocEditor},
		{field:'UserID',title:'ҽ��ID',width:110,align:'left',hidden:true,editor:texteditor},
		{field:'UserName',title:'ҽ��',width:120,align:'left',editor:texteditor},
		{field:'TelPhone',title:'��ϵ��ʽ',width:100,align:'left',editor:numbereditor},
		{field:'PrvTpID',title:'ְ��ID',width:100,align:'left',hidden:true,editor:texteditor},
		{field:'PrvTp',title:'ְ��',width:160,align:'left',hidden:false,editor:PrvTpEditor}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		title:'��Ժר��',
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : true,
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',
		border:true,
		bodyCls:'panel-header-gray',
	    onClickRow: function (rowIndex, rowData) {
			
			if (rowData.ID) return;
		
            if ((editExpRow != -1)||(editExpRow == 0)) { 
                $("#OuterExpList").datagrid('endEdit', editExpRow); 
            }
            
            $("#OuterExpList").datagrid('beginEdit', rowIndex); 
			
            editExpRow = rowIndex;
            return;
		  
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetBatModExpOutDet&mdtIDs="+CstID+"&MWToken="+websys_getMWToken();
	new ListComponent('OuterExpList', columns, uniturl, option).Init();
}

/// �������
function insExpRow(){
	
	if (isEditFlag == 1) return;
			
    var rowObj={ID:'', UserID:'', UserName:''};
	$("#OuterExpList").datagrid('appendRow',rowObj);
}

 /// ɾ����
function delOutExpRow(rowIndex, id){
	
	/// �����༭
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#OuterExpList").datagrid('endEdit', editIndex); 
    }
    
	var rowData = $('#OuterExpList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ','����ѡ���ɾ���У�','warning');
		return;
	}
	
	/// ����
	runClassMethod("web.DHCMDTConsult","DeleteOuterExpert",{"ID":rowData.ID},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ","ɾ��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$('#OuterExpList').datagrid("reload");
		}
	},'',false)
	
	return;
	
	// ��ȡѡ���е�Index��ֵ
	var rowIndex=$('#OuterExpList').datagrid('getRowIndex',rowData);
    $('#OuterExpList').datagrid('deleteRow',rowIndex);
    var rows = $('#OuterExpList').datagrid("getRows");  //���»�ȡ���������к�
    $('#OuterExpList').datagrid("loadData", rows);
}

/**
 * ����datagrid����
 * @creater qqa:��д
 * @param className ������
 * @param methodName ������
 * @param gridid datagrid��id
 * @param handle �ص�����
 * @param ����ֵ����
 * saveByDataGrid("web.DHCAPPPart","find","#datagrid",function(data){ alert() },"json")	 
 */
function saveByDataGrid(className,methodName,gridid,handle,datatype,parObj){

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
	var paramsObj={}
	paramsObj.Params = dataList.join("$$");
	paramsObj=$.extend(paramsObj,parObj);
	runClassMethod(className,methodName,paramsObj,handle,datatype);
}


/// ��Ժר�ҿ�ݷ�ʽ
function shortcut_selOuterExp(){
	
	if (DisGrpID == "") {
		$.messager.alert("��ʾ","���Ѳ��ֲ���Ϊ�գ�","warning");
		return;
	}
	
	var Link = "dhcmdt.makresloc.csp?DisGrpID="+ DisGrpID +"&Type=E"+"&MWToken="+websys_getMWToken();
	mdtPopWin1(3, Link); /// ����MDT���ﴦ����

}

/// �������
function insRow(){
    var rowObj={itmID:'', LocID:'', LocDesc:'', UserID:'', UserName:'', PrvTpID:'', PrvTp:'', AcceptFlag:'', RefReason:'', IsConssignIn:''};
	$("#bmDocList").datagrid('appendRow',rowObj);
}


/// ɾ������
function delRow(){
	
	/// �����༭
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }
    
	var rowData = $('#bmDocList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ','����ѡ���ɾ����','warning');
		return;
	}
	
	var rowIndex=$('#bmDocList').datagrid('getRowIndex',rowData);
	if(!rowData.itmID){
		$('#bmDocList').datagrid('deleteRow',rowIndex);
		return;
	}
	
	$cm({
		"ClassName":"web.DHCMDTConsult",
		"MethodName":"DeletConsItm",
		"CstItmID":rowData.itmID,
		"dataType":"text"
	},function(ret){
		if(ret!=0){
			$.messager.alert('��ʾ',ret,'warning');
			return;	
		}else{
			$("#bmDocList").datagrid("reload");	
		}
	})
}

/// ������
function saveRow(){
	
	/// �����༭
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }
    
    if ((editExpRow != -1)||(editExpRow == 0)) { 
        $("#OuterExpList").datagrid('endEdit', editExpRow); 
    }

	/// ��Ա�ظ����
	var TmpCarePrv = ""; /// ר��
	var CarePrvArr = [];
	var rowData = $('#bmDocList').datagrid('getRows');
	for (var i = 0; i < rowData.length; i++){
		var item = rowData[i];
		if(trim(item.LocDesc) != ""){
			/// ��Ա�ظ����
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	}
	if (TmpCarePrv != ""){
		$.messager.alert("��ʾ:","����ר�ң�"+ TmpCarePrv +"���ظ���ӣ�","warning");
		return;	
	}
	
	var LocArr=[]; isEmptyFlag=0;
	var rowData = $('#bmDocList').datagrid('getChanges');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+"^"+item.itmID;
		    LocArr.push(TmpData);
		}
		if (item.UserID == "") isEmptyFlag = 1;
	}
	
	if (isEmptyFlag == 1){
		$.messager.alert("��ʾ","ר�Ҳ���Ϊ�գ�","warning");
		return;	
	}
	
	/// ��Ժ��Ա�ظ����
	var TmpExpCarePrv = ""; /// ר��
	var CareExpPrvArr = [];
	var rowData = $('#OuterExpList').datagrid('getRows');
	for (var i = 0; i < rowData.length; i++){
		var item = rowData[i];
		if(trim(item.LocDesc) != ""){
			/// ��Ա�ظ����
			var masIndex=item.LocID+","+item.PrvTpID+","+item.UserName;
			if ($.inArray(masIndex, CareExpPrvArr) != -1){
				TmpExpCarePrv = item.UserName;
			}
			CareExpPrvArr.push(masIndex);
		}
	}
	if (TmpExpCarePrv != ""){
		$.messager.alert("��ʾ:","����ר�ң�"+ TmpExpCarePrv +"���ظ���ӣ�","warning");
		return;	
	}
	
	var LocExpArr=[]; isExpEmptyFlag=0;
	var rowData = $('#OuterExpList').datagrid('getChanges');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.UserID +"^"+ item.UserName +"^"+ item.LocID +"^"+ item.PrvTpID +"^"+ item.TelPhone +"^"+ item.ID;
		    LocExpArr.push(TmpData);
		}
		if (item.UserName == "") isExpEmptyFlag = 1;
	}
	
	if (isExpEmptyFlag == 1){
		$.messager.alert("��ʾ","��Ժר����������Ϊ�գ�","warning");
		return;	
	}
	
	
	/// ����
	var mLocParams = LocArr.join("@");
	/// ��Ժ����
	var makOuterExp = LocExpArr.join("@");	
	
	if ((mLocParams == "")&&(makOuterExp=="")){
		$.messager.alert("��ʾ","δ��鵽�����Ӽ�¼��","warning");
		return;	
	}
	
	/// ����
	runClassMethod("web.DHCMDTConsult","InsLocParams",{"mdtIds":CstID, "mLocParams":mLocParams,"makOuterExp":makOuterExp},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ","����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ","����ɹ���","success",function(){
				$("#bmDocList").datagrid('reload');
				$("#OuterExpList").datagrid("reload");
			});
		}
	},'',false)
}

///����ר��
function saveLoc(){
	
	/// �����༭
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }
   
	/// ��Ա�ظ����
	var TmpCarePrv = ""; /// ר��
	var CarePrvArr = [];
	var rowData = $('#bmDocList').datagrid('getRows');
	for (var i = 0; i < rowData.length; i++){
		var item = rowData[i];
		if(trim(item.LocDesc) != ""){
			/// ��Ա�ظ����
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	}
	if (TmpCarePrv != ""){
		$.messager.alert("��ʾ:","����ר�ң�"+ TmpCarePrv +"���ظ���ӣ�","warning");
		return;	
	}
	
	var LocArr=[]; isEmptyFlag=0;
	var rowData = $('#bmDocList').datagrid('getChanges');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+"^"+item.itmID;
		    LocArr.push(TmpData);
		}
		if (item.UserID == "") isEmptyFlag = 1;
	}
	
	if (isEmptyFlag == 1){
		$.messager.alert("��ʾ","ר�Ҳ���Ϊ�գ�","warning");
		return;	
	}
	
	/// ����
	var mLocParams = LocArr.join("@");

	if (mLocParams == ""){
		$.messager.alert("��ʾ","δ��鵽�����Ӽ�¼��","warning");
		return;	
	}
	
	/// ����
	runClassMethod("web.DHCMDTConsult","InsLocParams",{"mdtIds":CstID, "mLocParams":mLocParams,"makOuterExp":""},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ","����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ","����ɹ���","success",function(){
				$("#bmDocList").datagrid('reload');
			});
		}
	},'',false)
}

///������Ժר��
function saveOuterLoc(){
	
	if ((editExpRow != -1)||(editExpRow == 0)) { 
        $("#OuterExpList").datagrid('endEdit', editExpRow); 
    }
	
	/// ��Ժ��Ա�ظ����
	var TmpExpCarePrv = ""; /// ר��
	var CareExpPrvArr = [];
	var rowData = $('#OuterExpList').datagrid('getRows');
	for (var i = 0; i < rowData.length; i++){
		var item = rowData[i];
		if(trim(item.LocDesc) != ""){
			/// ��Ա�ظ����
			var masIndex=item.LocID+","+item.PrvTpID+","+item.UserName;
			if ($.inArray(masIndex, CareExpPrvArr) != -1){
				TmpExpCarePrv = item.UserName;
			}
			CareExpPrvArr.push(masIndex);
		}
	}
	if (TmpExpCarePrv != ""){
		$.messager.alert("��ʾ:","����ר�ң�"+ TmpExpCarePrv +"���ظ���ӣ�","warning");
		return;	
	}
	
	var LocExpArr=[]; isExpEmptyFlag=0;
	var rowData = $('#OuterExpList').datagrid('getChanges');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.UserID +"^"+ item.UserName +"^"+ item.LocID +"^"+ item.PrvTpID +"^"+ item.TelPhone +"^"+ item.ID;
		    LocExpArr.push(TmpData);
		}
		if (item.UserName == "") isExpEmptyFlag = 1;
	}
	
	if (isExpEmptyFlag == 1){
		$.messager.alert("��ʾ","��Ժר����������Ϊ�գ�","warning");
		return;	
	}
	
	/// ��Ժ����
	var makOuterExp = LocExpArr.join("@");	
	
	if (makOuterExp == ""){
		$.messager.alert("��ʾ","δ��鵽�����Ӽ�¼��","warning");
		return;	
	}
	
	/// ����
	runClassMethod("web.DHCMDTConsult","InsLocParams",{"mdtIds":CstID, "mLocParams":"","makOuterExp":makOuterExp},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ","����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ","����ɹ���","success",function(){
				$("#OuterExpList").datagrid("reload");
			});
		}
	},'',false)
}