//===========================================================================================
// Author��      Sunhuiyong
// Date:		 2020-07-28
// Description:	 �°��ٴ�֪ʶ��-�ⲿ�����
//===========================================================================================
var Type=""  //ѡ���ֵ�����	
var editRow = 0,editsubRow=0;
var parref = "";   //�ֵ�id  sufan add 2020-12-01
var drugType ="";
/// ҳ���ʼ������
function initPageDefault(){
	
	InitParams();
	InitButton();		// ��ť��Ӧ�¼���ʼ��
	InitCombobox();		// ��ʼ��combobox
	InitDataList();		// ҳ��DataGrid��ʼ������
	InitSubDataList()	// �ֵ��
	MsgTips();
	if(HISUIStyleCode==="lite"){
  		$('.no-data').css("background","url(../images/no_data_lite.png) center center no-repeat");
	}
}

/// ҩƷ����
function InitParams(){
	
	drugType = getParam("DrugType");	

}

/// ҳ��DataGrid��ʼ����ͨ����
function InitDataList(){
						
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ����columns
	var columns=[[   
			{field:'dicID',title:'dicID',width:80,align:'left',hidden:true},	 
			{field:'EDCode',title:'����',width:200,align:'left',editor:texteditor},
			{field:'EDDesc',title:'����',width:300,align:'left',editor:texteditor},
			{field:'EDType',title:'����',width:300,align:'left',hidden:true},
			{field:'EDHospID',title:'ҽԺ',width:300,align:'left',hidden:true},
			{field:'DataType',title:"��������",width:200,align:'left',hidden:true}
		 ]]
	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){ 
		    Type = rowData.EDType;
		    parref = rowData.dicID;
		    switchMainSrc(parref)
		    var hops=$HUI.combobox("#HospId").getValue();
		   	 	
		   	if(rowData.DataType=="tree"){
			   $(".no-data").hide();
			   $("#treediv").show();
			   $("#griddiv").hide();
			  
			   var uniturl = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+parref;
			   $('#dictree').tree('options').url = uniturl;
			   $('#dictree').tree('reload');
		   }else{
			   $("#treediv").hide();
			   $("#griddiv").show();
			   $("#subdiclist").datagrid("load",{"HospID":hops,"Type":Type,"params":""});
			   MsgTips();
		   }		   
		  
		}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
          
        },
        onLoadSuccess:function(data){
          $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
          $('.mytooltip').tooltip({
            trackMouse:true,
            onShow:function(e){
              $(this).tooltip('tip').css({
              });
            }
          });          
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetExtDicList&HospID="+LgHospID+""+"&params="+"&drugType="+drugType;
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}


/// ��ť��Ӧ�¼���ʼ��
function InitButton(){
	
	$("#insert").bind("click",InsertRow);	        // ��������
	
	$("#savedata").bind("click",SaveRow);		    // ����
	
	$("#insertsub").bind("click",InsertsubRow);	    // ��������-sub
	
	$("#savesubdata").bind("click",SavesubRow);		// ����-sub
	
	$("#updTreeDic").bind("click",updTreeDic); //�޸Ĺ����ֵ�
	
	$("#detsub").bind("click",DeletesubRow);	    // ɾ������ ld 2022-8-17
	
	$('#queryCode').searchbox({
		    searcher:function(value,name){
		   		QueryDicList();
		    }	   
		});	
		
	$('#subQueryCode').searchbox({
	    searcher:function(value,name){
	   		SubQueryDicList();
	    }	   
	});	
	
	/// tabs ѡ�
	$("#tabs").tabs({
		onSelect:function(title){
			
		   	LoadattrList(title);
		}
	});
	
	///��ѯ����
    $('#FindTreeText').searchbox({
	    searcher:function(value,name){
		   reloadTree();
	    }	   
	});	
}

/// ��ʼ��combobox
function InitCombobox(){
	//ҽԺ
    var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
    $HUI.combobox("#HospId",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		panelHeight:"150",
		mode:'remote',
		onSelect:function(ret){
			var params = $HUI.searchbox("#subQueryCode").getValue();
			$('#subdiclist').datagrid('load',{
				HospID:ret.value,
				Type:Type
			}); 
		}
	  })	
	   
    var arr = new Array();
    var params = $HUI.searchbox("#subQueryCode").getValue();
	   runClassMethod("web.DHCCKBExtDictionary","GetExtDicList",{"HospID":"", "params":params},function(jsonString){
		var arr=new Array();
		for (i = 0; i< jsonString.rows.length; i++) {
		   var obj=new Object();
		   obj.id=jsonString.rows[i].EDType;
		   obj.text=jsonString.rows[i].EDDesc;
		   arr.push(obj);
		}
	    $('#dicDesc').combobox({
			data:arr,
			valueField: 'id',
			textField: 'text',
			blurValidValue:true,
			editable:false
		})
	  	},'json');
	  
}


// ��ѯ
function QueryDicList()
{
	var params = $HUI.searchbox("#queryCode").getValue();
	$('#diclist').datagrid('load',{
		HospID:LgHospID,
		params:params
	}); 
	Type = "";
	parref = "";
	var hops=$HUI.combobox("#HospId").getValue();
	var uniturl = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+parref;
	$('#dictree').tree('options').url = uniturl;
	$('#dictree').tree('reload');
	$("#subdiclist").datagrid("load",{"HospID":hops,"Type":Type,"params":""});
	
	if ($("#tabscont")[0].contentWindow){
		$("#tabscont")[0].contentWindow.CatId = "";
		$("#tabscont")[0].contentWindow.ReloadData();
	}

}

// ���� 
function InitPageInfo(){
	
	

}
// ��������
function InsertRow(){
	debugger;
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);		//�����༭������֮ǰ�༭����
	}
	$("#diclist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#diclist").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
	editRow=0;
}
/// ����༭��
function SaveRow(){
	
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#diclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","info");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].EDCode=="")||(rowsData[i].EDDesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!","info"); 
			return false;
		}

		var tmp=$g(rowsData[i].EDCode) +"^"+ $g(rowsData[i].EDDesc);
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");

	//��������	 
	runClassMethod("web.DHCCKBExtDictionary","InsertExtDics",{"params":params,"Type":Type,"HospID":LgHospID},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('��ʾ','����ɹ���','info');
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		
		$('#diclist').datagrid('reload'); //���¼���
	});
}
// ��������-sub
function InsertsubRow(){
	
	if(editsubRow>="0"){
		$("#subdiclist").datagrid('endEdit', editsubRow);		//�����༭������֮ǰ�༭����
	}
	$("#subdiclist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#subdiclist").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
	editsubRow=0;
}
/// ����༭��-sub
function SavesubRow(){
	
	if(editsubRow>="0"){
		$("#subdiclist").datagrid('endEdit', editsubRow);
	}

	var rowsData = $("#subdiclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","info");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].EDCode=="")||(rowsData[i].EDDesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!","info"); 
			return false;
		}

		var tmp=$g(rowsData[i].EDRowID)+"^"+ $g(rowsData[i].EDCode) +"^"+ $g(rowsData[i].EDDesc);	// qnp 2021/4/23 ����id
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
 	var hospID=$HUI.combobox("#HospId").getValue();
 	hospID = (hospID=="")?LgHospID:hospID;
	//��������	 
	///runClassMethod("web.DHCCKBExtDictionary","InsertExtsubDics",{"params":params,"Type":Type,"HospID":hospID},function(jsonString){
	runClassMethod("web.DHCCKBExtDictionary","SaveUpdateExtDics",{"params":params,"Type":Type,"HospID":hospID,"Parref":parref},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('��ʾ','����ɹ���','info');
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		
		$('#subdiclist').datagrid('reload'); //���¼���
	});
}

//�޸Ĺ����ֵ�
function updTreeDic(){
	var rowsData = $("#subdiclist").datagrid('getSelected');
	if(rowsData==null){
		$.messager.alert("��ʾ","û��Ҫ�޸ĵ�����!");
		return;
	}
	$("#UpdDicWin").show();
	$HUI.combobox("#dicDesc").setValue("");	
	var option = {
		modal:true,
		iconCls:'icon-w-save',
		collapsible : false,
		minimizable : false,
		maximizable : false,
		border:true,
		closed:"true"
	};
	var title = "�ֵ�����޸�";		
	new WindowUX(title, 'UpdDicWin', '360', '125', option).Init();
}
/// ɾ������  ld  2022-8-17
function DeletesubRow(){
	var rowsData = $("#subdiclist").datagrid('getSelected'); //ѡ��Ҫɾ������
	var dicType = Type;
	if (rowsData != null) {
		var param=$g(rowsData.EDRowID)+"^"+ $g(rowsData.EDCode) +"^"+ $g(rowsData.EDDesc) +"^"+ dicType;
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
			if (res){
				runClassMethod("web.DHCCKBExtDictionary","DeleteDic",{"ListData":param},function(jsonString){
						if (jsonString >= 0){
							$.messager.alert('��ʾ','ɾ���ɹ���','info');
						}else{
							$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
							}
					$('#subdiclist').datagrid('reload'); //���¼���		
							  })
					}
						});		
			}else{
				$.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 		return;
				 }		

}
function saveDiction()
{
	var rowsData = $("#subdiclist").datagrid('getSelected');
	var dictionId=$HUI.combobox("#dicDesc").getValue();
	if(dictionId==""){
		$.messager.alert("��ʾ","��ѡ���ֵ䣡","info");
		return;
	}
 var rowid= rowsData.EDRowID;                              
	runClassMethod("web.DHCCKBExtDictionary","UdpDiction",{"RowId":rowid,"DictionId":dictionId},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});
	            	closeDicWin();
	            	InitSubDataList();
	            	return false;
	           	}else{
				           $.messager.popover({msg: '�޸�ʧ�ܣ�',type:'success',timeout: 1000});
	            		return false;
				        }
				        
	 })
}

function closeDicWin()
{
	$("#UpdDicWin").window('close');
}


//==================================================�ⲿ���������ά������============================================================//
/// ҳ��DataGrid��ʼ����ͨ����
function InitSubDataList(){
						
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ����columns   
	var columns=[[   	 
			{field:'EDRowID',title:'ID',hidden:true},
			{field:'EDCode',title:'����',width:100,editor:texteditor},
			{field:'EDDesc',title:'����',width:100,align:'left',editor:texteditor},
			{field:'EDType',title:'����',width:250,align:'left',hidden:true},
			{field:'EDHospID',title:'ҽԺ',width:200,align:'left'}
			
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){
	 		
	 	}, 
		onDblClickRow: function (rowIndex, rowData) {
             if (editsubRow != ""||editsubRow == 0) { 
                $("#subdiclist").datagrid('endEdit', editsubRow); 
            } 
            $("#subdiclist").datagrid('beginEdit', rowIndex); 
            
            editsubRow = rowIndex; 
        },
        onLoadSuccess:function(data){
            $('.mytooltip').tooltip({
            trackMouse:true,
            onShow:function(e){
              $(this).tooltip('tip').css({});
            }
          });          
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetExtDicListData&HospID="+LgHospID+"&Type=&params="+"";
	new ListComponent('subdiclist', columns, uniturl, option).Init();
	
}
/// sub��������
function SubInsertRow(){
	
	if(editsubRow>="0"){
		$("#subdiclist").datagrid('endEdit', editsubRow);		//�����༭������֮ǰ�༭����
	}
	$("#subdiclist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#subdiclist").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
	editsubRow=0;
}

/// sub����
function SubSaveRow(){
	
	if(editsubRow>="0"){
		$("#subdiclist").datagrid('endEdit', editsubRow);
	}

	var rowsData = $("#subdiclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","info");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].CDCode=="")||(rowsData[i].CDDesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!","info"); 
			return false;
		}

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc) +"^"+ parref;
		
		dataList.push(tmp);
	} 
	var params = $HUI.searchbox("#subQueryCode").getValue();
	var attrData = "";

	//��������
	runClassMethod("web.DHCCKBDiction","SaveUpdateNew",{"params":params,"attrData":attrData,"LgUserID":LgUserID,"LgHospID":LgHospID},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('��ʾ','����ɹ���','info');
		}else if(jsonString == -98){
			$.messager.alert('��ʾ','����ʧ��,�����ظ���','warning');
			
		}else if(jsonString == -99){
			$.messager.alert('��ʾ','����ʧ��,�����ظ���','warning');

		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		SubQueryDicList(parref);		
		//$('#diclist').datagrid('reload'); //���¼���
	});
}

/// subɾ��    sunhuiyong 2020-02-03 ɾ��������в�����ɾ�� 
function SubDelRow(){
	var rowsData = $("#subdiclist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫͣ����Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDiction","UsedDic",{"dicID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						SetFlag="STDATA"        //ͣ�����ݱ��
						DicName="DHC_CKBCommonDiction"
						dataid=rowsData.ID
						Operator=LgUserID
						//$HUI.dialog("#diclog").open();
						var link = "dhcckb.diclog.csp?DicName="+ DicName +"&Operator="+ LgUserID +"&SetFlag="+ SetFlag +"&dataid="+dataid+"&ClientIP="+IP;
						link += ("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"";
						window.open(link,"_blank","height=400, width=650, top=200, left=400,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
					}else if (jsonString == "-1"){
						 $.messager.alert('��ʾ','�������ѱ�����,����ֱ��ͣ�ã�','warning');
					}		
				})
			}
		});		
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫͣ�õ���','warning');
		 return;
	}		

}
function reloadDatagrid(){
	$("#diclist").datagrid("reload");
	$("#subdiclist").datagrid("reload");
}

/// sub ��ѯ
function SubQueryDicList(id){
	
	var params = $HUI.searchbox("#subQueryCode").getValue();
	var Hos = $HUI.combobox("#HospId").getValue();
	$('#subdiclist').datagrid('load',{
		HospID:Hos,
		Type:Type,
		params:params
	}); 
}

function SetDateTime(flag)
{
	var result=""
	runClassMethod("web.DHCCKBWriteLog","GetDateTime",{"flag":flag},function(val){	
	  result = val
	},"text",false)
	return result;
}

///ˢ��datagrid
function reloadPagedg()
{
	$("#diclist").datagrid("reload");    
}

function LoadattrList(title)
{  
	if (title == "��������"){ 
		 switchMainSrc(parref)
	}else{
		 InitSubDataList(); 
	}
}
/// �б�������л�
function switchMainSrc(parref){
	
	var linkUrl=""
	linkUrl = "dhcckb.addlinkattrext.csp?parref="+parref+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():""); // ��������

	$("#tabscont").attr("src", linkUrl);	

}


//�������ӽڵ㰴ť
function AddDataTree() {
	RefreshData();
	var options={};	
	options.url=$URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+parref+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"");
	$('#parref').combotree(options);
	$('#parref').combotree('reload')
	
	$("#myWin").show();
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-addlittle',
		resizable:true,
		title:'���',
		modal:true,
		buttonAlign : 'center',
		buttons:[{
			text:'����',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				SaveDicTree(1)
			}
		},{
			text:'�������',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				TAddDicTree(2)
			}
		},{
			text:'�ر�',
			handler:function(){
				myWin.close();
			}
		}]
	});	
	
	var record =$("#dictree").tree('getSelected');
	
	if (record){
		$('#parref').combotree('setValue', $g(record.id));
	}
}

//����޸İ�ť
function UpdateDataTree() {
	
	RefreshData();
	$('#parref').combotree('reload',$URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+parref)
	var record = $("#dictree").tree("getSelected"); 
	if (!(record))
	{	
		$.messager.alert('������ʾ','����ѡ��һ����¼!',"error");
		return;
	}
	var id=record.id;
	if (record){
		$("#treeID").val(record.id);
		var parentNode=$("#dictree").tree("getParent",record.target)	
		if (parentNode){		
			$('#parref').combotree('setValue', $g(parentNode.id));
		}
		$("#treeCode").val(record.code);
		$("#treeDesc").val(record.text);
	}
	$("#myWin").show(); 
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-updatelittle',
		resizable:true,
		title:'�޸�',
		modal:true,
		//height:$(window).height()-70,
		buttons:[{
			text:'����',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				SaveDicTree(1)
			}
		},{
			text:'�ر�',
			//iconCls:'icon-cancel',
			handler:function(){
				RefreshData();
				myWin.close();
			}
		}]
	});
}	

function DelDataTree(){
	
	var dataList=[];
	var nodeArr=$('#dictree').tree('getChecked');			//����ͣ�� sufan20200313
	for (var i=0;i<nodeArr.length;i++){
		var nodeId=nodeArr[i].id;
		dataList.push(nodeId);
	}
	var params=dataList.join("^");
	if (nodeArr.length != 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ������Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
			if (res) {			
				runClassMethod("web.DHCCKBExtDictionary","DeleteData",{"idStr":DeleteData},function(getString){
					if (getString == 0){
						Result = "�����ɹ���";
					}else if (getString == -1){
						Result = "�����Ѷ���,����ɾ����";	
					}else{
						Result = "����ʧ�ܣ�";	
					}
				},'text',false);
				$.messager.popover({msg: Result,type:'success',timeout: 1000});
				reloadTree();
			}	
		})

	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ��������','warning');
		 return;
	}	    
}

/// �������
function RefreshData(){
	$("#treeID").hide();
	$("#treeID").val("");
	$("#treeCode").val("");
	$("#treeDesc").val("");
	$('#parref').combotree('setValue','');
};

///�������
function TAddDicTree(flag){	
	SaveDicTree(flag);
}
///����������
function SaveDicTree(flag){
			
	var treeID=$("#treeID").val();	
	var treeCode=$.trim($("#treeCode").val());
	if (treeCode==""){
		$.messager.alert('������ʾ','���벻��Ϊ��!',"error");
		return;
	}
	var treeDesc=$.trim($("#treeDesc").val())
	if (treeDesc==""){
		$.messager.alert('������ʾ','��������Ϊ��!',"error");
		return;
	}
	///�ϼ�����
	if ($('#parref').combotree('getText')==''){
		$('#parref').combotree('setValue','')
	}
	
	var setParref = $('#parref').combotree('getValue')=="" ? parref : $('#parref').combotree('getValue') // ����Ϊ��,��Ĭ�Ϲ��ڷ����ֵ�����
	var params=$g(treeID) +"^"+ $g(treeCode) +"^"+ $g(treeDesc) +"^"+ $g(setParref)

	var hops=$HUI.combobox("#HospId").getValue();		   
	
	runClassMethod("web.DHCCKBExtDictionary","SaveUpdateExtDics",{"params":params,"Type":Type,"HospID":hops,"Parref":$g(setParref)},function(jsonString){
		if (jsonString >= 0){
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			if(flag==1)
			{
				CloseWin();
			}
		}else if(jsonString == -98){
			$.messager.alert('��ʾ','����ʧ��,�����ظ���','warning');
		}else if(jsonString == -99){
			$.messager.alert('��ʾ','����ʧ��,�����ظ���','warning');
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		
		var uniturl = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+parref
		$('#dictree').tree('options').url = uniturl;
		$('#dictree').tree('reload');
		
	});	

}

function reloadTree(){
	var Input=$.trim($HUI.searchbox("#FindTreeText").getValue());
	if(Input==""){ // 
		var url = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+parref+"&Input=";
	}else{
		var url = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+parref+"&Input="+Input;
	}
	$('#dictree').tree('options').url = encodeURI(url);	
	$('#dictree').tree('reload');
}

function CloseWin(){

	$HUI.dialog("#myWin").close();
};


/// ���÷���
function ClearData(){
	
	$HUI.searchbox("#FindTreeText").setValue("");
	reloadTree();
}

function MsgTips(){
	
	if (parref == ""){
		$("#griddiv").hide();
		//$("#treediv").hide();
		$(".no-data").show();		
	}else{
		
		$("#griddiv").show();
		//$("#treediv").show();
		$(".no-data").hide();	
	}

}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
