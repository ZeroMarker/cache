/// author:    yangzongyi
/// date:      2020-04-11
/// descript:  ����Ϣ�ֵ�ά��

var editRow = ""; editDRow = "";
/// ҳ���ʼ������
function initPageDefault(){
	
	//��ʼ����ѯ��Ϣ�б�
	InitMainList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
	
	setTimeout(function(){  //hxy 2020-05-06 st
	    var DescH=$("#NoteP").height()-40;
		$("#itemTempDesc").css("height",DescH+"px"); 
	}, 500); //ed
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){
	/**
	 * ע������ģ���ֵ�
	 */
	$("div#tb a:contains('����')").bind("click",insertRow);
	$("div#tb a:contains('ɾ��')").bind("click",deleteRow);
	$("div#tb a:contains('����')").bind("click",saveRow);
	
	/**
	 * ע��������ϸ
	 */
	$("div#dtb a:contains('����')").bind("click",saveItmTmpNotes);
	$("div#dtb a:contains('���')").bind("click",clearItmTmpNotes);
	$("div#dtb a:contains('ɾ��')").bind("click",delItmTmpNotes);
	
	$($(".keyLi")).on('click',function(){ //hxy 2020-05-06 st
		if($(this).hasClass('selected')){
			$(this).removeClass('selected')	
		}else{
			$($(".keyLi")).not(this).removeClass('selected')
			$(this).addClass('selected');
		}
	}) //ed
	
}

///��ʼ�������б�
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
	
	var ActFlagArr = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
	//������Ϊ�ɱ༭
	var activeEditor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			data: ActFlagArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ActCode'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ActDesc'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
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
			url:$URL+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'HospID'});
				$(ed.target).val(option.value); 
			} 
	
		}
	}
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'left'}, //hxy 2020-05-06 �����
		{field:'Code',title:'����',width:100,editor:textEditor,align:'left'},
		{field:'Desc',title:'����',width:150,editor:textEditor,align:'left'},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'ActDesc',title:'�Ƿ����',width:80,editor:activeEditor,align:'left'},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'HospDesc',title:'ҽԺ',width:200,editor:HospEditor,align:'left'}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'MDT����Ϣ����',
		headerCls:'panel-header-gray', //hxy 2020-05-06 st
		border:true,
		iconCls:'icon-paper',//ed
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
			$('#itemTempDesc').val("");
			GetItemTempNotes(rowData.ID);
			
			//$("#item").datagrid('reload',{mID:rowData.ID});
	    },
		onLoadSuccess:function(data){
			var rows = $("#dgMainList").datagrid('getRows');
			if (rows.length != "0"){
				$('#dgMainList').datagrid('selectRow',0);
				var rowData = $('#dgMainList').datagrid('getSelected');
				GetItemTempNotes(rowData.ID);
			}
		}
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTSMSTemp&MethodName=QryConsultGroup";
	new ListComponent('dgMainList', columns, uniturl, option).Init();

}

/// ����༭��
function saveRow(){
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#dgMainList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
		if(rowsData[i].HospID==""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTSMSTemp","Save",{"mListData":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#dgMainList').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertRow(){
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#dgMainList").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#dgMainList').datagrid('selectRow',0);
			$("#dgMainList").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#dgMainList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'��', HospID:'', HospDesc:''}
	});
	$("#dgMainList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#dgMainList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCMDTSMSTemp","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('��ʾ','�����Ѻ�ҽ�����,����ɾ����','warning');
					}
					$('#dgMainList').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ����༭��
function saveItmTmpNotes(){
	
	var rowsMData = $("#dgMainList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsMData == null){
		$.messager.alert("��ʾ", "����ѡ��ģ���ֵ䣬Ȼ������ӣ�");
		return;
	}
    var dataList = [];
	var itemTempId = $("#itemTempId").val();   		///�ӱ�ID
	var itemTempDesc = $("#itemTempDesc").val(); 	///ע��������������
	if(itemTempDesc==""){
		$.messager.alert("��ʾ", "��ά��������ϸ");
		return;
		}
	var tmp=itemTempId +"^"+ rowsMData.ID +"^"+ itemTempDesc;
	 dataList.push(tmp);
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTSMSTemp","SaveItem",{"mListData":mListData},function(jsonString){
       if (jsonString == 0){
			$.messager.alert("��ʾ", "����ɹ���");
			GetItemTempNotes(rowsMData.ID);
		}else{
			$.messager.alert("��ʾ", "����ʧ�ܣ�");
		}
	})
}

function delItmTmpNotes(){
	
	var rowsMData = $("#dgMainList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsMData == null){
		$.messager.alert("��ʾ", "����ѡ��ģ���ֵ䣬Ȼ������ӣ�");
		return;
	}
	
	var itemTempId = $("#itemTempId").val();   		///�ӱ�ID
	if (itemTempId == ""){
		$.messager.alert("��ʾ", "ɾ��ʧ��,ʧ��ԭ��:����Ϊ�գ�");
		return;
	}
	$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			runClassMethod("web.DHCMDTSMSTemp","deleteItem",{"ID":itemTempId},function(jsonString){
				if (jsonString == 0){
					$.messager.alert("��ʾ", "ɾ���ɹ���");
					GetItemTempNotes(rowsMData.ID);
				}else{
					$.messager.alert("��ʾ", "ɾ��ʧ�ܣ�");
				}
			})
		}
	});
}



/// ȡģ���ֵ�����
function GetItemTempNotes(ID){
	
	$("#itemTempId").val("");     ///�ӱ�ID
	$('#itemTempDesc').val("");  ///���

	/// ��ѯ����
	runClassMethod("web.DHCMDTSMSTemp","GetItemTempNotes",{"ID":ID},function(jsonString){

		if (jsonString != null){
			var jsonObj = jsonString;
			$('#itemTempId').val(jsonObj.itemTempId);  ///ע������ID
			$('#itemTempDesc').val(jsonObj.itemTempDesc.replace(new RegExp("<br>","g"),"\r\n"));  ///ע������    ///sufan  2017-02-16  �޸�IE8�س���������
		}
	})
}

/// ���
function clearItmTmpNotes(){

	$("#itemTempDesc").val('');
}

 /* $(".btn-danger").on("click", function() {
	        alert("ggm")
	        var pos=getFieldPos();
            //$("#itemTempDesc").insertAtCaret($(this).attr("data-param"));
            insertPos(pos,"�̼�")
        }); */

function win1(){
	        //var value=$("#btn1").val(); //hxy 2020-05-06 st
	        var value=$("#btn1").attr("data"); //ed
	        var pos=$("#itemTempDesc").getFieldPos();
            $("#itemTempDesc").insertPos(pos,value)
	}
  
  function win2(){
	        //var value=$("#btn2").val();
	        var value=$("#btn2").attr("data");
	        var pos=$("#itemTempDesc").getFieldPos();
            $("#itemTempDesc").insertPos(pos,value)
	}      
       
function win3(){
	        //var value=$("#btn3").val();
	        var value=$("#btn3").attr("data");
	        var pos=$("#itemTempDesc").getFieldPos();
            $("#itemTempDesc").insertPos(pos,value)
	}

function win4(){
	        //var value=$("#btn4").val();
	        var value=$("#btn4").attr("data");
	        var pos=$("#itemTempDesc").getFieldPos();
            $("#itemTempDesc").insertPos(pos,value)
	}

function win5(){
	        //var value=$("#btn5").val();
	        var value=$("#btn5").attr("data");
	        var pos=$("#itemTempDesc").getFieldPos();
            $("#itemTempDesc").insertPos(pos,value)
	}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })