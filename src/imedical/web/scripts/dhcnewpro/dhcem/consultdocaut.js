/// author:    bianshuai
/// date:      2018-06-20
/// descript:  �����ҽ��Ȩ��ά��

var userID = "";   /// �û�ID
/// ҳ���ʼ������
function initPageDefault(){
	
	init(); //hxy 2020-05-27 ��ʼ��ҽԺ
	
	//��ʼ����ѯ��Ϣ�б�
	InitMain();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
	
}

function init(){
	hospComp = GenHospComp("DHC_EmConsDocAut");  //hxy 2020-05-27 st
	hospComp.options().onSelect = function(){///ѡ���¼�
		clearPanel();
		runClassMethod("web.DHCEMConsDicItem","GetConsItem",{mCode:"CYT",HospID:hospComp.getValue()},
		function(jsonString){
			$("#ConType").html("");
			var html="";
			var Str=jsonString.split("||");
			for (i=0; i<Str.length; i++) {
				if(Str[i]==""){continue;}
				var TID=Str[i].split("^")[0];
				var TCode=Str[i].split("^")[1];
				var TDesc=Str[i].split("^")[2];
				html=html+"<input id='"+TID+"' class='hisui-checkbox' name='CstType' type='checkbox' data-index='"+TCode+"' label='"+TDesc+"'>";
			}
			$("#ConType").html(html);
			$HUI.checkbox("#ConType input.hisui-checkbox",{});
		},'text',false)

		query();
		InitMain();
	}//ed
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){
	
	$('#userCode').bind('keypress',function(event){
        if(event.keyCode == "13"){
	        findUserInfo();
	    }
    });
    
    // ����¼�  ��Ȩ�޿���
    $('#ConType').on('click','[name="CstType"]',function(){
		 if ($(this).attr("data-index") == "DOCNUR01"){
	     	$HUI.checkbox('input:not([data-index^="DOCNUR01"])').setValue(false);
	     }else{
		 	$HUI.checkbox('input[data-index="DOCNUR01"]').setValue(false);
		 	 //$HUI.checkbox("#"+this.id).disable();
		 }
	})
}

///��ʼ�������б�
function InitMainList(columns){
	
	/**
	 * ����columns
	 */

	var fcolumns=[[
		{field:'userID',title:'userID',width:100,hidden:true,align:'center'},
		{field:'userCode',title:'����',width:100,align:'center'},
		{field:'userName',title:'����',width:150,align:'center'}
	]];

	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		frozenColumns:fcolumns,
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
	    onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
			userID = rowData.userID;
			$("#userCode").val(rowData.userCode);    //����
			$("#userName").val(rowData.userName);    //����
			
			$('input[name="CstType"]').each(function(){
				$HUI.checkbox("#"+this.id).setValue(rowData["T"+this.id]=="��"?true:false);
				if ($("#"+this.id).attr("data-index").indexOf(rowData["ProvType"]) == "-1"){
					$HUI.checkbox("#"+this.id).disable();
				}else{
					$HUI.checkbox("#"+this.id).enable();
				}
			})
        },
		onLoadSuccess:function(data){
			if (data.rows.length == 1){
				$('input[name="CstType"]').each(function(){
					$HUI.checkbox("#"+this.id).setValue(data.rows[0]["T"+this.id]=="��"?true:false);
					if ($("#"+this.id).attr("data-index").indexOf(data.rows[0]["ProvType"]) == "-1"){
						$HUI.checkbox("#"+this.id).disable();
					}else{
						$HUI.checkbox("#"+this.id).enable();
					}
				})
			}
		}
	};
	
	var uniturl = $URL+"?ClassName=web.DHCEMConsDocAut&MethodName=QryConsDocAut&HospID="+hospComp.getValue(); //hxy 2020-05-28 ԭ��session['LOGON.HOSPID']
	new ListComponent('main', columns, uniturl, option).Init();

}

/// ����
function saveRow(){
	
	var usercode = $('#userCode').val();
	if (usercode == ""){
		$.messager.alert('��ʾ','�û����Ų���Ϊ�գ�','warning');
		return;
	}
	
	/// ��������
	var CstTypeArr = [];
	$('input[name="CstType"]').each(function(){
		var TypeFlag = $("#"+this.id).is(':checked')?"Y":"N";
		CstTypeArr.push(this.id +":"+ TypeFlag);
	})
	var mParam = CstTypeArr.join("^");

	//��������
	runClassMethod("web.DHCEMConsDocAut","save",{"userID":userID, "mParam":mParam,"HospID":hospComp.getValue()},function(jsonString){ //hxy 2020-05-28

		if (jsonString < 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
			return;	
		}else{
			clearPanel(); /// ������
		}
		$('#main').datagrid('reload'); //���¼���
	})
}

/// ������
function clearPanel(){
	
	userID = "";
	$("#userCode").val("");    //����
	$("#userName").val("");    //����
	$('input[name="CstType"]').each(function(){
		$HUI.checkbox("#"+this.id).setValue(false);
	})
}

/// ��������
function insertRow(){
	
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
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'��', HospID:'', HospDesc:''}
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
				runClassMethod("web.DHCEMConsDocAut","delete",{"ID":rowsData.ID},function(jsonString){
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

/// ��ȡ����������
function InitMain(){
	
	// ��ȡ��ʾ����
	runClassMethod("web.DHCEMConsDocAut","jsonConsItem",{"mCode":"CYT", "HospID":hospComp.getValue()},function(jsonString){ //hxy 2020-05-28 session['LOGON.HOSPID']

		if (jsonString != null){
			InitMainList(jsonString)
		}
	},'json',false)
}

/// �����û����Ų�ѯ�û���Ϣ
function findUserInfo(){
	
	var usercode = $('#userCode').val();
	if (usercode == ""){
		$.messager.alert('��ʾ','�����빤�ź�,�س���ѯ��','warning');
		return;
	}
	
	// ��ȡ��ʾ����
	runClassMethod("web.DHCEMConsDocAut","JsonUserInfo",{"userCode":usercode,"HospID":hospComp.getValue()},function(jsonObject){ //hxy 2020-05-28 add HospID

		if (jsonObject != null){
			userID = jsonObject.UserID;
			$("#userCode").val(jsonObject.UserCode);    //����
			$("#userName").val(jsonObject.UserName);    //����
			
			$('input[name="CstType"]').each(function(){
				$HUI.checkbox("#"+this.id).setValue(false);
				if ($("#"+this.id).attr("data-index").indexOf(jsonObject["ProvType"]) == "-1"){
					$HUI.checkbox("#"+this.id).disable();
				}else{
					$HUI.checkbox("#"+this.id).enable();
				}
			})
			$("#main").datagrid("load",{"mUserID":userID,"HospID":hospComp.getValue()}); //hxy 2020-05-28 ԭ��session['LOGON.HOSPID']
		}
	},'json',false)
}

/// ��ѯ
function query(){
	$("#main").datagrid('loadData',{total:0,rows:[]}); //hxy 2020-05-28
	$("#main").datagrid("load",{"mUserID":"","HospID":hospComp.getValue()}); //hxy 2020-05-28 ԭ��session['LOGON.HOSPID']
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })