/** qunianpeng
  * 2019-06-14
  * �������
 */ 
var extraAttr = "KnowType";			// ��������-֪ʶ����
var extraAttrValue = "AttrFlag" 	// knowledge-ʵ��
var editRow = 0;
var REPEATCODE=-98					// �ظ����롢�ظ����� ����Ϊ���� (�����о�����Ҫ����ħ������)
var REPEATDESC=-99
var dicID=""
var IP=window.parent.ClientIPAddress;
function InitPageDefault(){
	
	
	//InitDefaultInfo();	/// ��ʼ������Ĭ����Ϣ
	InitAttrTree();		/// ��ʼ������tree
	InitAttrList();		/// ��ʼ������datagrid
	InitButton();  		/// ��ʼ����ť��Ӧ�¼�
	//InitCombobox();		/// ��ʼ��ҳ��combobox
	//ExportMatchDataNew()
	
}

/// ��ʼ����ť��Ӧ�¼�
function InitButton(){
	
	$('#icw_bt a:contains("ȡ��")').bind("click",CloseWin);
	
	///  ƴ����
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		var params = $HUI.searchbox("#queryCode").getValue();
			//var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
			//$("#attrtree").tree('options').url =encodeURI(url);
			//$("#attrtree").tree('reload');	// ʹ�ô˷�������ʱ����Ҫdatagrid�������ͱ��ֶ�������ͬ���޸�ʱIDĬ�Ϲ̶�
			$("#attrtree").tree("search", params)		
			//$('#attrtree').tree('unselectAll');
	    }	   
	});
	///�������� 2021-05-18  wangxuejian
	$('#linkCode').searchbox({
		searcher : function (value, name) {
			var searcode=$.trim(value);
			//alert(searcode)
			findLinkTree(searcode);
		}
	});
}


/// ��ʼ������tree
function InitAttrTree(){
	// 2020-03-20 ���ͣ�ù��� Sunhuiyong
	var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	var option = {
		multiple: true,
		lines:true,
		animate:true,
        onClick:function(node, checked){
	       dicID=node.id;
	        var isLeaf = $("#attrtree").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        $('#attrlist').datagrid('load',{id:node.id,parrefFlag:1,loginInfo:LoginInfo}); 							   
	        }else{
		    	//$("#attrtree").tree('toggle',node.target);   /// �����Ŀʱ,ֱ��չ��/�ر�
		    	$('#attrlist').datagrid('load',{id:node.id,parrefFlag:1,loginInfo:LoginInfo}); 
		    }
	    },
	    onContextMenu: function(e, node){
			
			e.preventDefault();
			/*var node = $("#attrtree").tree('getSelected');
			if (node == null){
				$.messager.alert("��ʾ","��ѡ�нڵ������!"); 
				return;
			}*/
			$(this).tree('select', node.target);			
			//$('#attrlist').datagrid('load',{id:node.id,parrefFlag:1}); 
			// ��ʾ��ݲ˵�
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
	    onExpand:function(node, checked){
			var childNode = $("#attrtree").tree('getChildren',node.target)[0];  /// ��ǰ�ڵ���ӽڵ�
	        var isLeaf = $("#attrtree").tree('isLeaf',childNode.target);        /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
	        }
		}
	};
	new CusTreeUX("attrtree", url, option).Init();
	//$('#CheckPart').tree('options').url = uniturl;
	//$('#CheckPart').tree('reload');		

}


/// ��ʼ��datagrid
function InitAttrList(){
	
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}	
		
	// ����columns
	var columns=[[ 
			{field:'ID',title:'RowId',hidden:true},
			{field:'CDCode',title:'����',width:400,align:'left',editor:texteditor},
			{field:'CDDesc',title:'����',width:400,align:'left',editor:texteditor},
			{field:'CDParref',title:'��id',width:100,align:'left',editor:texteditor,hidden:true},
			{field:'CDParrefDesc',title:'�ϲ�ڵ�',width:300,align:'left',editor:texteditor},
			//{field:'Operator',title:'����',width:300,align:'center',editor:typeeditor},
			{field:'CDLinkDr',title:'����ID',width:100,align:'left',editor:texteditor,hidden:true},
			/*{field:'CDLinkDesc',title:'����',width:300,align:'left',editor:texteditor,hidden:false},*/
			{field:'CDLinkDesc',title:'����',width:300,align:'left',editor:texteditor,hidden:false},
			{field:'Operating',title:'����',width:100,align:'center',formatter:SetCellOperation}		
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
 		  if (editRow != ""||editRow == 0) {    //wangxuejian 2021-05-21  �رձ༭�� 
                $("#attrlist").datagrid('endEdit', editRow); 
            } 
 		}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow == 0) { 
                $("#attrlist").datagrid('endEdit', editRow); 
            } 
            $("#attrlist").datagrid('beginEdit', rowIndex); 
            var editors = $('#attrlist').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 ʧȥ����رձ༭��                
            for (var i = 0; i < editors.length; i++)   
            {  
                var e = editors[i]; 
              	$(e.target).bind("blur",function()
              	  {  
                   //$("#attrlist").datagrid('endEdit', rowIndex); 
                  });   
            } 
            
            editRow = rowIndex;
            //CommonRowClick(rowIndex,rowData,"#attrlist");
            dataGridBindEnterEvent(rowIndex);
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

	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id=&parrefFlag="+"&loginInfo="+LoginInfo;
	new ListComponent('attrlist', columns, uniturl, option).Init();
	
}


/// ����һ��
function AddRow(){
	
	//commonAddRow({'datagrid':'#attrlist',value:{}});
	if(editRow>="0"){
		$("#attrlist").datagrid('endEdit', editRow);		//�����༭������֮ǰ�༭����
	}
	$("#attrlist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', CDCode:'', CDDesc:'',CDParref:"",CDLinkDr:""}
	});
	$("#attrlist").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
	
	editRow=0;
	dataGridBindEnterEvent(0);
}

/// ����datagrid����
function SaveRow(){

	var node = $("#attrtree").tree('getSelected');
	/*if (node == null){
		$.messager.alert("��ʾ","��ѡ��һ���ϼ����ԣ�","warning");
		return;
	}*/
	var parref = ""
	if (node != null){
		parref = $g(node.id);	
	}
	
	if(editRow>="0"){
		$("#attrlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#attrlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].CDCode=="")||(rowsData[i].CDDesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
		
		if ((parref=="")&(rowsData[i].ID=="")&(rowsData[i].CDParref=="")){	// ���Ҳ����ֱ������ʱ����Ҫ�ϼ�����
			$.messager.alert("��ʾ","��ѡ��һ���ϼ����ԣ�","warning");
			return false;
		}
		
		if ((parref == "")&(parref != rowsData[i].CDParref)){		// �޸ı���
			parref = rowsData[i].CDParref;
		}
		
		if ((parref != "")&(parref == rowsData[i].ID)){				// �޸ı���
			parref = rowsData[i].CDParref;
		}
		
		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc)+"^"+$g(parref)+"^"+$g(rowsData[i].CDLinkDr);
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = "";

	//��������   Sunhuiyong-�޸�������־ 2020-11-23
	//runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
	runClassMethod("web.DHCCKBDiction","SaveUpdateNew",{"params":params,"attrData":attrData,"LoginInfo":LoginInfo,"ClientIPAddress":IP},function(jsonString){
		if (jsonString>=0 ){
			$.messager.alert('��ʾ','����ɹ���','info');
			
		}
		if (jsonString == REPEATCODE){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');

		}else if (jsonString == REPEATDESC){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
		}		
		RefreshData();
	});
	
	/*
	comSaveByDataGrid("User.DHCCKBCommonDiction","#attrlist",function(){
			$('#attrlist').datagrid('load',{id:""}); 
			var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryAttrTreeList&params=';
			$("#attrtree").tree('options').url =encodeURI(url);
			$("#attrtree").tree('reload');	// ʹ�ô˷�������ʱ����Ҫdatagrid�������ͱ��ֶ�������ͬ���޸�ʱIDĬ�Ϲ̶�
	})*/
}

/// ɾ��
function DeleteRow(){
	var params=dicID;
	if (params != 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫͣ����Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDiction","IsDicUsed",{"DicIdList":params},function(jsonString){
					if (jsonString == 0){
						SetFlag="stop"        //ͣ�����ݱ��
						DicName="DHC_CKBCommonDiction"
						dataid=params;
						Operator=LgUserID
						var StopDate=formatDate(0);
						var d = new Date();
						var n = d.getHours();	// ʱ
						var m = d.getMinutes();	// ��
						m = m<10?"0"+m:m;
						var s = d.getSeconds(); // ��
						s = s<10?"0"+s:s;
						var StopTime=n+":"+m+":"+s;
						//$HUI.dialog("#diclog").open();
						//var link = "dhcckb.diclog.csp?DicName="+ DicName +"&Operator="+ LgUserID +"&SetFlag="+ SetFlag +"&dataid="+dataid+"&ClientIP="+IP+"&type="+"log";
						//window.open(link,"_blank","height=400, width=650, top=200, left=400,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
						runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":LgUserID,"OperateDate":StopDate,"OperateTime":StopTime,"Scope":"","ScopeValue":"","ClientIPAddress":IP,"Type":'log'},function(getString){
							if (getString == 0){
								Result = "�����ɹ���";
							}else if(getString == -1){
								Result = "��ǰ���ݴ�������ֵ,������ɾ��";
							}else{
								Result = "����ʧ�ܣ�";	
							}
						},'text',false);
						$.messager.popover({msg: Result,type:'success',timeout: 1000});					
						RefreshData();
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



	/*removeCom("User.DHCCKBCommonDiction","#attrlist",function(jsonstr){
		var obj = jQuery.parseJSON(jsonstr)
		if (obj.code == 0){
			var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryAttrTreeList&params=';
			$("#attrtree").tree('options').url =encodeURI(url);
			$("#attrtree").tree('reload');
			$('#attrlist').datagrid('load',{params:""}); 
		}
	});
	*/
}
function reloadDatagrid()
{
	$("#attrtree").tree('reload');	
}
/// ����dialog����
function dataGridBindEnterEvent(index){
	
	editRow=index;
	var editors = $('#attrlist').datagrid('getEditors', index);

	for(var i=0;i<editors.length;i++){
		var workRateEditor = editors[i];
		
		//����  CDType
		if(workRateEditor.field=="CDParrefDesc"){
			workRateEditor.target.mousedown(function(e){
				var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDParrefDesc'});		
				var input = $(ed.target).val();
			    /*divComponent({tarobj:$(ed.target),htmlType:"tree",width: 400,height: 260},function(obj){
					var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDParref'});		
					$(ed.target).val(obj.id);				
				})*/
				var Clicktype="ParrefDesc"
				ShowAllData(index,Clicktype);	 //wangxuejian 2021-05-18 �����ǹ������ͻ�����һ�㼶����			
			});
			
		//����id CDLinkDesc
		}else if(workRateEditor.field=="CDLinkDesc"){
			workRateEditor.target.mousedown(function(e){				
				var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDLinkDesc'});		
				var input = $(ed.target).val();
				var Clicktype="LinkDesc"      //wangxuejian 2021-05-18 �����ǹ������ͻ�����һ�㼶����
				ShowAllData(index,Clicktype);								
			});
		}			
		else{
			workRateEditor.target.mousedown(function(e){
					$("#win").remove();;
			});
			workRateEditor.target.focus(function(e){
					$("#win").remove();;
			});
		}
	}
}

///���ò�����ϸ����
function SetCellOperation(value, rowData, rowIndex){

	///<a href='#' onclick=\"showAuditListWin('"+a+"','"+a+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>����</a>";
	/*var btnGroup="<a style='margin-right:10px;display:none' href='#' onclick=\"OpenEditWin('"+rowData.ID+"','list','"+rowData.DataType+"')\">����</a>";
	btnGroup = btnGroup + "<a style='margin-right:10px;display:none' href='#' onclick=\"OpenEditWin('"+rowData.ID+"','prop','"+rowData.DataType+"')\">����</a>";
	btnGroup = btnGroup + "<a style='margin-right:10px;' href='#' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\">��������</a>";
	
	return btnGroup;
	*/
	
	//var btn = "<img class='mytooltip' title='��������' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    var btn = "<a class='icon icon-compare' style='color:#000;display:inline-block;width:16px;height:16px' title='��������' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\"></a>" 
    return btn;  
	
}

/// ����ֵ�༭��
function OpenEditWin(ID,model,dataType){

	var linkUrl="",title=""
	if (model == "list"){
		
		linkUrl = "dhcckb.addlist.csp"
		title = "�ֵ�ά��"
		
	}else if (model =="prop"){
		
		linkUrl = "dhcckb.addattr.csp";
		title = "�����б�";
		
	}else if (model == "linkprop"){
		
		linkUrl = "dhcckb.addlinkattr.csp";
		title ="��������ά��";
		
	}else {
		linkUrl = "dhcckb.addlist.csp"
		title = "�ֵ�ά��"
	}	
	linkUrl += '?parref='+ID;
	if ("undefined"!==typeof websys_getMWToken){
		linkUrl += "&MWToken="+websys_getMWToken(); 
	}
	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'"></iframe>';	
	if($('#winmodel').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		iconCls:'icon-w-save',
		title:title,
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		//maximized:true,
		maximizable:true,
		minimizable:false,		
		width:$(window).width()-50, //800,
		height:$(window).height()-50//500
	});	

	$('#winmodel').html(openUrl);
	$('#winmodel').window('open');

}

/// �½����Դ���
function newCreateAttr(type){	
		
	if (type == "C"){
		var node = $("#attrtree").tree('getSelected');
		if ((node)&&(node.text.indexOf("���Ը��ڵ�")!=-1)){
			 $.messager.alert('��ʾ','���Ը��ڵ�ֻ�����ͬ���ڵ�','info');
			 return;
		}
	}
	newCreateAttrWin(type);   // �½����Դ���
	InitAttrWinDefault(type); // ��ʼ������Ĭ����Ϣ
}

/// Window ����
function newCreateAttrWin(type){
	
	/// ���ര��
	var option = {
		modal:true,
		collapsible:true,
		border:true,
		minimizable : false,
		iconCls:'icon-w-save',
		closed:"true"
	};
	
	var title = "�����¼�����";
	if (type == "S"){
		title = "����ͬ������";
		$("#saveSub").hide();
		$("#saveParref").show();
	}
	if (type == "C"){
		$("#saveParref").hide();
		$("#saveSub").show();
	}
	
	new WindowUX(title, 'AttrWin', '400', '220', option).Init();
}

/// �������Ҽ�����
function SaveAttr(type){

	var attrID = $("#attrID").val();
	var attrCode = $("#attrCode").val();    /// ���Դ���
	if ($g(attrCode) == ""){
		 $.messager.alert('��ʾ','���벻��Ϊ��','warning');
		 return;
	}
	var attrDesc = $("#attrDesc").val();    /// ��������
	if ($g(attrDesc) == ""){
		 $.messager.alert('��ʾ','��������Ϊ��','warning');
		 return;
	}
	var parref=$("#parref").val();
	
	var params=$g(attrID) +"^"+ $g(attrCode) +"^"+ $g(attrDesc) +"^"+ $g(parref)

	var attrData = extraAttr +"^"+ extraAttrValue;
	if (type == "C"){	// �����ӽڵ�ʱ���ӽڵ㲻��Ҫά��֪ʶ���
		attrData = "";
	}
	var node = $("#attrtree").tree('getSelected');
	if (node){
		var parentNode=$("#attrtree").tree("getParent",node.target)	// ѡ��ڵ�ĸ��ڵ�
		if (parentNode){											
			attrData = "";
		}
	}

	//��������
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
		if (jsonString >= 0){
			
			RefreshData();
			CloseWin();
			$('#attrlist').datagrid('reload'); //���¼���
			return;	
		}else if (jsonString == REPEATCODE){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			RefreshData();
			CloseWin();
			return;
		}else if (jsonString == REPEATDESC){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			RefreshData();
			CloseWin();
			return;
		}
		else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');			
		}		
	});

}

/// �رմ���
function CloseWin(){
	$('#AttrWin').window('close');
}

/// ��ʼ������Ĭ����Ϣ
function InitAttrWinDefault(type){
	
	var node = $("#attrtree").tree('getSelected');
	$("#attrCode").val("");
	$("#attrDesc").val("");
	if (type == "S"){		// ͬ��
		if (node){
			var parentNode=$("#attrtree").tree("getParent",node.target)	// ѡ��ڵ�ĸ��ڵ�
			if (parentNode){											// ѡ��ڵ�ĸ��ڵ㣬����Ϊ�ϼ��ڵ�Ϊ���ڵ�
				$("#parref").val(parentNode.id);
				$("#parrefDesc").val(parentNode.text);
			}else{
				$("#parref").val("");
				$("#parrefDesc").val("");
			}
		}
	}		
	if (type == "C"){	// �¼�
		$("#parref").val(node.id);
		$("#parrefDesc").val(node.text);
	}	
}

/// ��������ѯ
function QueryAttrTreeList(){
	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		var params = $HUI.searchbox("#queryCode").getValue();
			//var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
			//$("#attrtree").tree('options').url =encodeURI(url);
			//$("#attrtree").tree('reload');	// ʹ�ô˷�������ʱ����Ҫdatagrid�������ͱ��ֶ�������ͬ���޸�ʱIDĬ�Ϲ̶�
			$("#attrtree").tree("search", params)
			//$('#attrtree').tree('unselectAll');
	    }	   
	});
}

/// ˢ��
function RefreshData(){
	
	$HUI.searchbox('#queryCode').setValue("");
	searchData();
	//QueryAttrTreeList();
	//var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	//$("#attrtree").tree('options').url =encodeURI(url);
	//$("#attrtree").tree('reload');
	$('#attrlist').datagrid('reload'); //���¼���
}
///����datagrid
function reloadPagedg()
{
}
/// ��������̨�������ز��ԣ�
function ExportMatchDataNew(){
	
	/* var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:"��������", //Ĭ��DHCCExcel
		ClassName:"web.DHCCKBGetDicSourceUtil",
		QueryName:"QueryDicByDeleteMsg"	
	},false);
 */
 var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:"��������", //Ĭ��DHCCExcel
		ClassName:"web.DHCCKBCommon",
		QueryName:"ExportReplatRuleDic"	
	},false);

	location.href = rtn;

}

function ShowAllData(index,Clicktype)
{
	var title = (Clicktype == "ParrefDesc")?"�޸��ϲ�ڵ�":(Clicktype == "LinkDesc")?"�޸�����":"���";
    $("#myWin").show();
    var myWin = $HUI.dialog("#myWin",{
        iconCls:'icon-w-save',
        resizable:true,
        title:title,
        modal:true,     
        buttonAlign : 'center',
        buttons:[{
            text:'����',
            id:'save_btn',
            handler:function(){
                GetLink(index,Clicktype);
                  myWin.close();                    
            }
        },{
            text:'�ر�',
            handler:function(){                              
                myWin.close(); 
            }
        }],
        onClose:function(){

        }
    });
    SetTabsInit(index,Clicktype)
    var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	$("#linktree").tree('options').url =(uniturl);
	$("#linktree").tree('reload');
}


/// ��ʼ����������
function SetTabsInit(index,Clicktype){
	// ����
	var myAttrTree = $HUI.tree("#linktree",{
		url:"", //$URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue,
   		lines:true,  //���ڵ�֮����ʾ����
		autoSizeColumn:false,
		cascadeCheck:false,  //�Ƿ�����顣Ĭ��true  �˵����⣬����������
		animate:false,     	//�Ƿ���չ���۵��Ķ���Ч��
		onClick:function(node) 
        {
	       GetLink(index,Clicktype)  //������ȡ�������� 
        }
	});
		
}

function searchData(){
	
   	var params = $HUI.searchbox("#queryCode").getValue();
	$("#attrtree").tree("search", params)		
	//$('#attrtree').tree('unselectAll');

}

/// ��ȡ--��������һ��ε�����
function GetLink(index,Clicktype)
{
		var linkrow= $('#linktree').tree('getSelected');	// ��ȡѡ�е��� 
		//alert(linkrow)
	    if((linkrow==null)&&(Clicktype=="LinkDesc"))
	    {
		 var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDLinkDr'});		
	     $(ed.target).val("")
	     var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDLinkDesc'});		
	     $(ed.target).val("")
	     return ; 
	    }
	    if((linkrow==null)&&(Clicktype=="ParrefDesc"))
	    {
		 var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDParref'});		
	     $(ed.target).val("")
	     var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDParrefDesc'});		
	     $(ed.target).val("")
	      return ; 
	    }
		var selectID=linkrow.id; 
		var selectDesc=linkrow.text;
		var selectCode=linkrow.code;
		if(Clicktype=="LinkDesc")
		{
		var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDLinkDr'});		
	    $(ed.target).val(selectID)
	    var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDLinkDesc'});		
	    $(ed.target).val(selectDesc)
		}
		if(Clicktype=="ParrefDesc")
		{
		var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDParref'});		
	    $(ed.target).val(selectID)
	    var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDParrefDesc'});		
	    $(ed.target).val(selectDesc)
		}

}

///������
function findLinkTree(searcode)
{
	var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	$("#linktree").tree('options').url =encodeURI(url);
	$("#linktree").tree('reload');
}

///����
function LinkRefresh()
{
    $HUI.searchbox("#linkCode").setValue("");
	var searcode=$HUI.searchbox("#linkCode").getValue();
	findLinkTree(searcode)
}

function serchlink(){
   	var searcode = $HUI.searchbox("#linkCode").getValue();
	findLinkTree(searcode)
	}
/// JQuery ��ʼ��ҳ��
$(function(){ InitPageDefault(); })
