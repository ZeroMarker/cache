/// Creator: qqa
/// CreateDate: 2019-04-28
//  Descript: MDT�����޸�ʵ�ʻ���ҽ��

var CstID = "";     /// ����ID
var DisGrpID = "";  /// ���Ѳ���ID
var editIndex=-1;
var editGrpRow = -1;
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
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //���������߶��Զ�����
			blurValidValue:true,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				if ($(ed.target).val() == ""){
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', "");
					$.messager.alert("��ʾ","����ȷ��ר�ҿ��ң�","warning");
					return;
				}
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);

				///���ü���ָ��
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val();
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
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
			url: $URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID'],
			blurValidValue:true,
			onSelect:function(option) {
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val(option.value);
				
				///���ҽ��
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// ���ְ��
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
				
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc&DisGrpID="+DisGrpID;
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
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);

				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
			    
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ DisGrpID;
				$(ed.target).combobox('reload',unitUrl);
			
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
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
		{field:'IsConssignIn',title:'�Ѿ�ǩ��',width:120,align:'center',hidden:true,formatter:function(value){
			if(value==1) return "��";
			if(value!=1) return "";
		}},
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		title:'���ڿ���',
		fit:true,
		fitColumns:false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',
	    onDblClickRow: function (rowIndex, rowData) {
			
			if ((editIndex != -1)||(editIndex == 0)) { 
                $("#mainList").datagrid('endEdit', editIndex); 
            }
            
            if ((editGrpRow != -1)||(editGrpRow == 0)) { 
                $("#LocGrpList").datagrid('endEdit', editGrpRow); 
            }
            $("#LocGrpList").datagrid('beginEdit', rowIndex); 
			
            editGrpRow = rowIndex;          
        }
	};
	/// ��������
	
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID+"&Type=I";
	new ListComponent('LocGrpList', columns, uniturl, option).Init();
}

// ��ӿ���
function AddLocWin(){
    
    if (TakGrpLocModel == 1){
	   	/// �������
    	var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', UserID:'', UserName:'', TelPhone:''};
		$("#LocGrpList").datagrid('appendRow',rowObj);
   }else{
	   var Link = "dhcmdt.makresloc.csp?DisGrpID="+DisGrpID;
	   mdtPopWin1(2, Link); /// ����MDT���ﴦ����
   }
}

/// ����MDT���ﴦ����
function mdtPopWin1(WidthFlag, Link){
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		iconCls:'icon-paper',
		closed:"true"
	};
	$("#mdtFrames").attr("src",Link);
	if(WidthFlag == 2){
		new WindowUX('����ר����', 'mdtWin', 880, 480, option).Init();
	}
}

/// ���
function Clear(FlagCode){
	
	if (FlagCode == "G"){
		/// ���ڿ���
		$("#LocGrpList").datagrid("reload",{"QueFlg":'','ID':''});
	}else{
		/// Ժ�ڿ���
		$("#mainList").datagrid("reload",{"QueFlg":'','ID':''});
		
	}
}

function initDatagrid(){
	/// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	var HosTypeArr = [{"value":"I","text":'����'}, {"value":"O","text":'Ժ��'}];
	//������Ϊ�ɱ༭
	var HosEditor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			data: HosTypeArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'HosID'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'HosType'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
				
				/// ���ְ��
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTpID'});
				$(ed.target).val("");
				
				///���ҽ��
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				///��տ���
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'LocID'});
				$(ed.target).val("");
			}
		}
	}
	
	// ְ�Ʊ༭��
	var PrvTpEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //���������߶��Զ�����
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
				
				///���ü���ָ��
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTpID'});
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
			url: '',
			blurValidValue:true,
			onSelect:function(option) {
				
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'LocID'});
				$(ed.target).val(option.value);

				///���ü���ָ��
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				/// ���ְ��
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTpID'});
				$(ed.target).val("");
				
			},
			onShowPanel:function(){
				/// ����
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'HosID'});
				var HosID = $(ed.target).val();
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'LocDesc'});
				var unitUrl = "";
				if (HosID == "I"){
					var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc&DisGrpID="+DisGrpID;
				}else{
					var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID="+LgHospID;
				}
				//var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+LgHospID;
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
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				
				/// ����
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'HosID'});
				var HosID = $(ed.target).val();
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserName'});
				var GrpID = HosID=="I"?DisGrpID:"";
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ GrpID;
				$(ed.target).combobox('reload',unitUrl);
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#mainList").datagrid('getEditor',{index:editIndex,field:'UserID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'itmID',title:'ID',width:100,editor:texteditor,hidden:true},
		{field:'HosID',title:'HosID',width:100,editor:texteditor,hidden:true},
		{field:'HosType',title:'Ժ��Ժ��',width:110,editor:HosEditor,hidden:true},
		{field:'LocID',title:'����ID',width:100,editor:texteditor,hidden:true},
		{field:'LocDesc',title:'����',width:230,editor:LocEditor},
		{field:'UserID',title:'ҽ��ID',width:110,editor:texteditor,hidden:true},
		{field:'UserName',title:'ҽ��',width:120,editor:DocEditor},
		{field:'PrvTpID',title:'ְ��ID',width:100,editor:texteditor,hidden:true},
		{field:'PrvTp',title:'ְ��',width:160,editor:PrvTpEditor,hidden:false},
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
		{field:'IsConssignIn',title:'�Ѿ�ǩ��',width:120,align:'center',hidden:true,formatter:function(value){
			if(value==1) return "��";
			if(value!=1) return "";
		}},
		
	]];
	
		///  ����datagrid
	var option = {
		//showHeader:false,
		fit:true,
		title:'Ժ�ڿ���',
		fitColumns:false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',
		onDblClickRow: function (rowIndex, rowData) {
		
            if ((editIndex != -1)||(editIndex == 0)) { 
                $("#mainList").datagrid('endEdit', editIndex); 
            }
            $("#mainList").datagrid('beginEdit', rowIndex); 
			
            editIndex = rowIndex;
        },
	    onLoadSuccess: function (data) { //���ݼ�������¼�
            $("a[name='AddRow']").not("#"+(data.rows.length - 1)).hide();
        }
	};
	
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID+"&Type=O";
	new ListComponent('mainList', columns, uniturl, option).Init();
}

function addRow(){
	commonAddRow({'datagrid':'#mainList'})
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#mainList");
}

function save(){
	
	/// �����༭
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#mainList").datagrid('endEdit', editIndex); 
    }
	var LocArr = [];
	var ConsDetArr=[];
	var TmpCarePrv = ""; /// ר��
	var CarePrvArr = [];
	var rowData = $('#LocGrpList').datagrid('getRows');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^";
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
	var rowData = $('#mainList').datagrid('getRows');
	for (var n = 0; n < rowData.length; n++){
		var item = rowData[n];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^";
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

	/// ����
	runClassMethod("web.DHCMDTConsult","InsMakResss",{"CstID":CstID, "makLocParams":makLocParams},function(jsonString){
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

function saves(){
	var LocArr = [];
	var ConsDetArr=[];
	var rowsData = $("#mainList").datagrid('getRows');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	for(var i=0;i<rowsData.length;i++){
		if ($.inArray(rowsData[i].LocID,LocArr) == -1){
			LocArr.push(item.LocID);
		}
	} 
	saveByDataGrid("web.DHCMDTConsult","SaveItms","#mainList",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#mainList").datagrid('reload')
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#mainList").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		},"",{CstID:CstID});				
}

/// �ر�
function TakClsWin(){
	
	commonParentCloseWin();
}

function cancelLocGrp(){
	
	if ($("#LocGrpList").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	var row =$("#LocGrpList").datagrid('getSelected'); 
	var isConssignIn = row.IsConssignIn;
	if(isConssignIn==1){
		$.messager.alert('��ʾ','�Ѿ�ǩ��������ɾ����');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	        
		 runClassMethod("web.DHCMDTConsult","RemoveCstItm",{'CstItmID':row.itmID},function(data){ $('#LocGrpList').datagrid('load'); })
    }    
}); 
}

function cancel(){
	
	if ($("#mainList").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	var row =$("#mainList").datagrid('getSelected'); 
	var isConssignIn = row.IsConssignIn;
	if(isConssignIn==1){
		$.messager.alert('��ʾ','�Ѿ�ǩ��������ɾ����');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	        
		 runClassMethod("web.DHCMDTConsult","RemoveCstItm",{'CstItmID':row.itmID},function(data){ $('#mainList').datagrid('load'); })
    }    
}); 
}

/// ɾ������
function delRow(){
	
	/// �����༭
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#mainList").datagrid('endEdit', editIndex); 
    }
    
	var rowData = $('#mainList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ','����ѡ���ɾ���У�','warning');
		return;
	}
	// ��ȡѡ���е�Index��ֵ
	var rowIndex=$('#mainList').datagrid('getRowIndex',rowData);
    $('#mainList').datagrid('deleteRow',rowIndex);
    var rows = $('#mainList').datagrid("getRows");  //���»�ȡ���������к�
    $('#mainList').datagrid("loadData", rows);
}

/// ɾ������
function delLocRow(){
	
	var rowData = $('#LocGrpList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ','����ѡ���ɾ���У�','warning');
		return;
	}
	// ��ȡѡ���е�Index��ֵ
	var rowIndex=$('#LocGrpList').datagrid('getRowIndex',rowData);
    $('#LocGrpList').datagrid('deleteRow',rowIndex);
}

function TakPreTime(){
	
	/// ȫԺ�����б� �����༭
    if ((editIndex != -1)||(editIndex == 0)) { 
        $("#mainList").datagrid('endEdit', editIndex); 
    }
    
    /// ���ڿ����б� �����༭
    if ((editGrpRow != -1)||(editGrpRow == 0)) { 
        $("#LocGrpList").datagrid('endEdit', editGrpRow); 
    }
    
	save(); 
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


