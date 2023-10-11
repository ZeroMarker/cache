//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2020-08-18
// ����:	   MDTר�ҹ���JS
//===========================================================================================

var editRow = -1;
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
		
/// ҳ���ʼ������
function initPageDefault(){
	init(); //ylp ��ʼ��ҽԺ //20230222
	InitParams();      /// ��ʼ������
	InitComponents();  /// ��ʼ���������
	InitMainList();    /// ��ʼ�������б�
	InitMethod();
}
function init(){
	
	hospComp = GenHospComp("DHC_EmConsDicType");  //hxy 2020-05-27 st //2020-05-31 add
	hospComp.options().onSelect = function(){///ѡ���¼�
		$("#main").datagrid('reload',{GropHospID:hospComp.getValue()});
	}

	$('#queryBTN').on('click',function(){
		$("#main").datagrid('reload',{GropHospID:hospComp.getValue()});
	 })
		
}
function InitMethod(){
	window.onresize = function(){
	   $HUI.datagrid("#main").resize();
	}
}

/// ��ʼ��ҳ�����
function InitParams(){
	
}

/// ��ʼ���������
function InitComponents(){
	

}

/// ��ʼ�����ؽ����б�
function InitMainList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
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
			blurValidValue:true,
			required:true,
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'prvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'prvTp'});
				$(ed.target).combobox('setValue', option.text);
				
			}
		}
	}
	
	/// �Ա�
	var SexEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			url:$URL+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTSex"+"&MWToken="+websys_getMWToken(),
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'userSex'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'sexID'});
				$(ed.target).val(option.value); 
			} 
	
		}
	}
	
	var ActFlagArr = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
	//������Ϊ�ɱ༭
	var activeEditor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			data: ActFlagArr,
			valueField: "value",
			textField: "text",
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'actCode'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'actDesc'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
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
			url:"",
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onShowPanel:function(){
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'hospID'});
				var hospID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'locDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTDicItem&MethodName=jsonParDicItem&mCode=OutLoc&HospID="+ hospID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			},
			onSelect:function(option){
				///��������ֵ
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'locDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'locID'});
				$(ed.target).val(option.value); 
			} 
	
		}
	}
		
	/// ҽԺ
	var HospEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCMDTCom&MethodName=GetHospDs"+"&MWToken="+websys_getMWToken(),
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'hospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'hospID'});
				$(ed.target).val(option.value); 
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'locDesc'});
				$(ed.target).combobox('setValue', "");
			} 
	
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'userCode',title:'����',width:100,align:'center',editor:textEditor},
		{field:'userName',title:'����',width:200,align:'left',editor:textEditor},
		{field:'sexID',title:'�Ա�ID',width:160,align:'left',editor:textEditor,hidden:true},
		{field:'userSex',title:'�Ա�',width:100,align:'center',editor:SexEditor},
		{field:'prvTpID',title:'ְ��ID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'prvTp',title:'ְ��',width:160,editor:PrvTpEditor,align:'center'},
		{field:'idCard',title:'���֤��',width:160,align:'left',editor:textEditor},
		{field:'locID',title:'��Ժ����ID',width:160,align:'left',editor:textEditor,hidden:true},
		{field:'locDesc',title:'��Ժ����',width:260,align:'left',editor:LocEditor},
		{field:'OutHosp',title:'��Ժ����',width:160,align:'left'},
		{field:'phone',title:'��ϵ�绰',width:120,align:'left',editor:textEditor},
		{field:'actCode',title:'actCode',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'actDesc',title:'����',width:90,editor:activeEditor,align:'center'},
		{field:'hospID',title:'hospID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'hospDesc',title:'ҽԺ',width:200,editor:HospEditor,hidden:true,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		headerCls:'panel-header-gray',
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onClickRow:function(rowIndex, rowData){

		},
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	
            if ((editRow != -1)||(editRow == "0")) {
	            if (!$("#main").datagrid('validateRow', editRow)) return false;
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
		onLoadSuccess:function(data){

		}
	};
	/// ��������
	var param = "";
	var uniturl = $URL+"?ClassName=web.DHCMDTExpertMan&MethodName=JsQryExpMan&GropHospID="+hospComp.getValue()+"&MWToken="+websys_getMWToken();
	new ListComponent('main', columns, uniturl, option).Init(); 
}

/// ����༭��
function saveRow(){
	
	if (!$("#main").datagrid('validateRow', editRow)){
		$.messager.alert("��ʾ","��༭��������!");
		return;
	}
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}
		
	var rowsData = $("#main").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
		
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].userCode=="")||(rowsData[i].userName=="")){
			$.messager.alert("��ʾ","���Ż���������Ϊ��!"); 
			return false;
		}
		if(rowsData[i].hospID==""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!"); 
			return false;
		}
		var tmp = rowsData[i].ID +"^"+ rowsData[i].userCode +"^"+ rowsData[i].userName +"^"+ rowsData[i].sexID +"^"+ rowsData[i].prvTpID;
		    tmp = tmp +"^"+ rowsData[i].idCard +"^"+ rowsData[i].locID +"^"+ rowsData[i].phone +"^"+ rowsData[i].actCode +"^"+ rowsData[i].hospID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTExpertMan","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#main').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertRow(){
	
	if ((editRow != -1)||(editRow == "0")) {
		if (!$("#main").datagrid('validateRow', editRow)){
			$("#main").datagrid('selectRow', editRow).datagrid('beginEdit', editRow);
			return false;
		}
	}
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#main").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#main").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', userCode:'', userName:'', sexID:'', userSex:'', prvTpID:'', prvTp:'', special:'', idCard:'', locID:'', locDesc:'', phone:'', actCode:'Y', actDesc:'��', hospID:LgHospID, hospDesc:LgHospID}
	});
	$("#main").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCMDTExpertMan","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#main').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// �Զ�����ҳ�沼��
function onresize_handler(){
	
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {

	
	/// �Զ�����ҳ�沼��
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })