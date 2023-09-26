/// Descript: ���������ҽ����ά��
/// Creator : qunianpeng
/// Date    : 2017-03-19

var catID = "", editRow = "",  ArcColumns="";
var ArcUrl = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=QueryArcItmDetail';
var FrostArray = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];


/// ҳ���ʼ������
function initPageDefault(){
	
	InitDefault();			/// ��ʼ������Ĭ����Ϣ
	initArcItemList();	 	///	��ʼҳ��DataGridҽ���������
	initButton();           ///  ҳ��Button���¼�	
	initColumns();			/// ��ʼ��datagrid��
}

///��ʼ������Ĭ����Ϣ
function InitDefault(){
	catID=getParam("itmmastid");  ///ҽ����ID
}

/// ��ʼ��datagrid��
function initColumns(){
	ArcColumns = [[
	    {field:'itmDesc',title:'ҽ��������',width:220},
	    {field:'itmCode',title:'ҽ�������',width:100},
	    {field:'itmPrice',title:'����',width:100},
		{field:'itmID',title:'itmID',width:80}
	]];
}


/// ҳ�� Button ���¼�
function initButton(){	

	///  ����ҽ����
	$('#insertarcitm').bind("click",insertArcItmRow);
	
	///  ����ҽ����
	$('#savearcitm').bind("click",saveArcItmRow);
	
	///  ɾ��ҽ����
	$('#deletearcitm').bind("click",deleteArcItmRow);	

}

//�����Ŀ,��λ�б� 
function initArcItemList(){	
	
	/// ������־
	var FrostFlageditor={			/// ������Ϊ�ɱ༭
		type: 'combobox',			/// ���ñ༭��ʽ
		options: {
			data:FrostArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",		/// ���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'FrostFlag'});
				$(ed.target).combobox('setValue', option.value);  //�����Ƿ����
				$(ed.target).combobox('setText', option.text);
				//var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'ReqCode'});
				//$(ed.target).val(option.value); 
			} 
		}
	}
	/// �ı��༭��
	var textEditor={
		type: 'text',			/// ���ñ༭��ʽ
		options: {
			required: true  	/// ���ñ༭��������
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'ArcDr',title:'ҽ����ID',width:100,align:'center',hidden:true,editor:textEditor},
		{field:'ArcCode',title:'ҽ�������',width:150,align:'center',editor:textEditor},
		{field:'ArcDesc',title:'ҽ����',width:240,align:'center',editor:textEditor},
		{field:'FrostFlag',title:'������־',width:100,align:'center',editor:FrostFlageditor},		
		{field:"AcRowId",title:'ID',hidden:true,editor:textEditor}
	]];
	
	///  ����datagrid  
	var option = {
		rownumbers : true,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {	/// ˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#arcItemList").datagrid('endEdit', editRow); 
            } 
            $("#arcItemList").datagrid('beginEdit', rowIndex); 
            dataGridBindEnterEvent(rowIndex);  			/// ���ûس��¼�
            editRow = rowIndex;
        },
         onClickRow:function(rowIndex, rowData){	        
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,CatID)}});
			
	    },
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPArcCat&MethodName=QueryCatLinkArcItm&ItmId="+catID;	
	new ListComponent('arcItemList', columns, uniturl, option).Init(); 
}

/// ����ҽ����
function insertArcItmRow()
{
	if (catID == ""){
		$.messager.alert("��ʾ","��ѡ��һ��ѡ��!"); 
		return;	
	}	
	if(editRow>="0"){
		$("#arcItemList").datagrid('endEdit', editRow);	/// �����༭������֮ǰ�༭����
	}
	 
	$("#arcItemList").datagrid('insertRow', {			/// ��ָ����������ݣ�appendRow�������һ���������
		index: 0, 										/// ������0��ʼ����
		row: { ArcDr:'', ArcDesc:'',FrostFlag:'Y'}
	});
	$("#arcItemList").datagrid('beginEdit', 0);			/// �����༭������Ҫ�༭����
	editRow=0;	
	
	var rows = $("#arcItemList").datagrid('getRows');
	if (rows.length != "0"){
		dataGridBindEnterEvent(0);  					/// ���ûس��¼�
	}
}

///����ҽ����
function saveArcItmRow(){
	
	if(editRow>="0"){
		$("#arcItemList").datagrid('endEdit', editRow);
	}
	var rowsData = $("#arcItemList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if ((rowsData.ArcDr=="")||(rowsData[i].ArcDr==""))
		{
			$.messager.alert("��ʾ","��ѡ��ҽ����!");
			return false;
		} 
		var tmp=rowsData[i].AcRowId  +"^"+ rowsData[i].ArcDr +"^"+ catID +"^"+ rowsData[i].FrostFlag;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCAPPArcCat","SaveLinkArc",{"params":params},function(jsonString){
		if (jsonString == "0"){
			$.messager.alert('��ʾ','����ɹ���');
		}
		if (jsonString=="-11")
		{
			$.messager.alert('��ʾ','��ҽ�����ѹ�����ͬ���࣬������ѡ��');
			}
		$('#arcItemList').datagrid('reload'); 	/// ���¼���
	});
}
/// ɾ��
function deleteArcItmRow(){
	
	var rowsData = $("#arcItemList").datagrid('getSelected');					/// ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {	/// ��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPArcCat","DelCatLinkArcItm",{"AcRowId":rowsData.AcRowId},function(jsonString){
					$('#arcItemList').datagrid('reload'); 						/// ���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ��ҽ����󶨻س��¼�
function dataGridBindEnterEvent(index){
	
	var editors = $('#arcItemList').datagrid('getEditors', index);
	/// �����Ŀ����
	var workRateEditor = editors[2];
	workRateEditor.target.focus();  		/// ���ý���
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#arcItemList").datagrid('getEditor',{index:index, field:'ArcDesc'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var HospID=LgHospID;
			if (parent.GetSelHospId) HospID=parent.GetSelHospId();
			var unitUrl = ArcUrl + "&Input="+$(ed.target).val()+"&HospID="+HospID;
			/// ����ҽ�����б���
			new ListComponentWin($(ed.target), input, "500px", "" , unitUrl, ArcColumns, setCurrEditRowCellVal).init();
		}
	});
}
/// ����ǰ�༭�и�ֵ(ҽ����Ŀ)
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#arcItemList').datagrid('getEditors', editRow);
		///�����Ŀ
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  /// ���ý��� ��ѡ������
		return;
	}
	/// ��Ŀ����
	var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ArcDesc'});
	$(ed.target).val(rowObj.itmDesc);
	/// ��Ŀ����ID
	var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ArcDr'});		
	$(ed.target).val(rowObj.itmID);
	/// ��Ŀ����
	var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ArcCode'});		
	$(ed.target).val(rowObj.itmCode);
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })