/// Descript: ���ҽ��ά��
/// Creator : sufan
/// Date    : 2017-02-22
var editRow = ""; editTRow = "";
var tabsObjArr = [
	{"tabTitle":"ҽ������","tabCsp":"dhcapp.arccatnew.csp"},
	{"tabTitle":"ҽ����","tabCsp":"dhcapp.arcitmmast.csp"},
	{"tabTitle":"������Ŀ","tabCsp":"dhcapp.catotheropt.csp"},
	{"tabTitle":"��ӡģ��","tabCsp":"dhcapp.prttemp.csp"}
];
var ArcDr=""

/// ҳ���ʼ������
function initPageDefault(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_APP_Arccat",hospStr);
	hospComp.jdata.options.onSelect = function(){
		initItmlist();
		} 
	InitDefault();
	initItmlist();       	/// ��ʼҳ��DataGrid�������
	//initItmcatlist();	 	///	��ʼҳ��DataGridҽ�������	qunianpeng 2018/3/19 ������ҽ��������ȡ�ɵ�����js
	initButton();          ///  ҳ��Button���¼�	
}


/// ��ʼ������Ĭ����Ϣ
function InitDefault(){	
	
	for(var i=0;i<tabsObjArr.length;i++){
		addTab(tabsObjArr[i].tabTitle, tabsObjArr[i].tabCsp);
	}
}

///������ 
function initItmlist(){
	
	var Hospeditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			editable:false,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#arccatlist").datagrid('getEditor',{index:editRow,field:'hospdesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#arccatlist").datagrid('getEditor',{index:editRow,field:'hospdr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	// ����columns
	var columns=[[
		{field:"catcode",title:'�������',width:150,editor:textEditor},
		{field:"catdesc",title:'��������',width:170,editor:textEditor},
		{field:"hospdesc",title:'ҽԺ',width:200}, //,editor:Hospeditor},
		{field:"hospdr",title:'ҽԺID',width:40,align:'center',hidden:'true'},//editor:textEditor},
		{field:"acrowid",title:'ID',width:20,hidden:'true',align:'center'}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != "") { 
                $("#arccatlist").datagrid('endEdit', editRow); 
            } 
            $("#arccatlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	        ArcDr=rowData.acrowid;
			//$('#itemlist').datagrid('reload',{ItmId: rowData.acrowid});
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,rowData.acrowid)}});
	    }
	};
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPArcCat&MethodName=QueryArcCat&HospID="+HospID;
	new ListComponent('arccatlist', columns, uniturl, option).Init(); 
}

/// ҳ�� Button ���¼�
function initButton(){
	
	///  ���Ӽ�����
	$('#insert').bind("click",insertItemRow);
	
	///  ���������
	$('#save').bind("click",saveItemRow);
	
	///  ɾ��������
	$('#delete').bind("click",deleteItmRow);
	
	///  ����ҽ������
	///$('#insertcat').bind("click",insertcatRow);	qunianpeng 2018/3/19 ������ҽ��������ȡ�ɵ�����js
	
	///  ����ҽ������
	///$('#savecat').bind("click",savecatRow);
	
	///  ɾ��ҽ������
	///$('#deletecat').bind("click",deletecatRow);
	
	//ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findItmlist(); //���ò�ѯ
        }
    });
    
     // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findItmlist(); //���ò�ѯ
    });
    
        $("#tabs").tabs({
	    onSelect:function(title,index){
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,ArcDr)}});
		 }
	});
}

/// ��������Ŀ��λ��
function insertItemRow(){

	if(editRow>="0"){
		$("#arccatlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#arccatlist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {acrowid: '',catcode:'',catdesc: '',hospdesc:'',hospdr:''}
	});
    
	$("#arccatlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
///��������Ŀ��λ
function saveItemRow(){
	
	if(editRow>="0"){
		$("#arccatlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#arccatlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if (rowsData[i].acrowid!=""){
			var index=$("#arccatlist").datagrid('getRowIndex',rowsData[i]);
			index=index+1;
		}else{
			var index=rowsData.length-i;
		}
		if(rowsData[i].catcode==""){
			$.messager.alert("��ʾ","��"+index+"�д���Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].catdesc==""){
			$.messager.alert("��ʾ","��"+index+"������Ϊ�գ�"); 
			return false;
		}
		/*if(rowsData[i].hospdesc==""){
			$.messager.alert("��ʾ","��"+index+"��ҽԺΪ�գ�"); 
			return false;
		}*/
		var HospID=$HUI.combogrid('#_HospList').getValue();
		var tmp=rowsData[i].acrowid +"^"+ rowsData[i].catcode +"^"+ rowsData[i].catdesc +"^"+ HospID;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCAPPArcCat","SaveArcCat",{"params":params},function(jsonString){
		
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#arccatlist').datagrid('reload'); //���¼���
		var currTab =$('#tabs').tabs('getSelected'); 
		var iframe = $(currTab.panel('options').content);
		var src = iframe.attr('src');
		$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,"")}});
	});
}

/// ɾ��
function deleteItmRow(){
	
	var rowsData = $("#arccatlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPArcCat","DelArcCat",{"params":rowsData.acrowid},function(jsonString){
					if (jsonString=="-5")
					{
						$.messager.alert('��ʾ','�÷�����ڹ�����ҽ�����࣬����ɾ����','warning');
						}
					if ((jsonString=="-1")||(jsonString=="-2")||(jsonString=="-3")||(jsonString=="-4"))
					{
						$.messager.alert('��ʾ','�÷�������ʹ�ã�����ɾ����','warning');
						}
					$('#arccatlist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
// ��ѯ
function findItmlist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$('#arccatlist').datagrid('load',{params:params,HospID:HospID}); 
}	 
////==========================================ҽ���������ά��=========================
/// ��ʼ��ҽ�������б� qunianpeng 2018/3/19 ������ҽ��������ȡ�ɵ�����js
/*
function initItmcatlist()
{
	var Cateditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=jsonArcItemCat",
			required:true,
			panelHeight:"280",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#itemlist").datagrid('getEditor',{index:editRow,field:'CatDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#itemlist").datagrid('getEditor',{index:editRow,field:'CatDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	// ����columns
	var columns=[[
		{field:"CatDesc",title:'ҽ������',width:300,align:'center',editor:Cateditor},
		{field:"CatDr",title:'����ID',width:150,align:'center',hidden:'true',editor:textEditor},
		{field:"CatLinkID",title:'ItmID',width:150,align:'center',hidden:'true',editor:textEditor}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != "") { 
                $("#itemlist").datagrid('endEdit', editRow); 
            } 
            $("#itemlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPArcCat&MethodName=QueryCatLink";
	new ListComponent('itemlist', columns, uniturl, option).Init();
}
/// ����ҽ������
function insertcatRow()
{
	var rowsData = $("#arccatlist").datagrid('getSelected');
	if (rowsData==null)
	{
		$.messager.alert("��ʾ","����ѡ������࣡"); 
		return false;
	}
	if(editRow>="0"){
		$("#itemlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#itemlist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {CatDesc: '',CatDr:'',CatLinkID: ''}
	});
    
	$("#itemlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

///��������Ŀ��λ
function savecatRow(){
	
	var rowsData = $("#arccatlist").datagrid('getSelected');
	var ItmId=rowsData.acrowid;
	var HospDr=rowsData.hospdr;
	if(editRow>="0"){
		$("#itemlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#itemlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if ((rowsData.CatDr=="")||(rowsData[i].CatDesc==""))
		{
			$.messager.alert("��ʾ","��ѡ��ҽ������!");
			return false;
		}
		var tmp=rowsData[i].CatLinkID +"^"+ ItmId +"^"+ rowsData[i].CatDesc +"^"+ rowsData[i].CatDr +"^"+ HospDr;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCAPPArcCat","Save",{"params":params},function(jsonString){
		
		if (jsonString == "0"){
			$.messager.alert('��ʾ','����ɹ���');
		}
		if (jsonString=="-11")
		{
			$.messager.alert('��ʾ','��ҽ�������ѹ����������࣬������ѡ��');
			}
		$('#itemlist').datagrid('reload'); //���¼���
	});
}
/// ɾ��
function deletecatRow(){
	
	var rowsData = $("#itemlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPArcCat","DelCatLink",{"CatLinkId":rowsData.CatLinkID},function(jsonString){
					$('#itemlist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
*/
/// ���ѡ�
function addTab(tabTitle, tabUrl){

    $('#tabs').tabs('add',{
        title : tabTitle,
        content : createFrame(tabUrl,"")
    });
}

/// �������
function createFrame(tabUrl, itmmastid){
	tabUrl = tabUrl.split("?")[0];
	if ((tabUrl=="dhcapp.catotheropt.csp")||(tabUrl=="dhcapp.prttemp.csp")){
		var content = '<iframe scrolling="auto" frameborder="0" src="' +tabUrl+ '?cat='+ itmmastid +'" style="width:100%;height:100%;"></iframe>';
	}else{
		var content = '<iframe scrolling="auto" frameborder="0" src="' +tabUrl+ '?itmmastid='+ itmmastid +'" style="width:100%;height:100%;"></iframe>';
		}
	return content;
}
function GetSelHospId(){
	return $HUI.combogrid('#_HospList').getValue();
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
