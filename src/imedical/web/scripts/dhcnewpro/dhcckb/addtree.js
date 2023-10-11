/**
  *qunianpeng 
  *2019-06-28
  *������ά��
  *
 **/
var editRow = 0; 
var parref = getParam("parref");    //ʵ��ID
var extraAttr = "KnowType";			// ��������-֪ʶ����
var extraAttrValue = "AttrFlag" 	// knowledge-ʵ��

/// ҳ���ʼ������
function initPageDefault(){
	if(parref==	""){parref = $("#drugCatID").val()}
	InitTree();     	/// ��ʼ������
	InitBlButton(); 	/// ҳ�� Button ���¼�
	InitCombobox();
}

/// �ֵ������
function InitTree(){
	
	var url = "" //$URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref 
	var option = {
		height:$(window).height()-105,   ///��Ҫ���ø߶ȣ���Ȼ����չ��̫��ʱ����ͷ�͹�����ȥ�ˡ�
		multiple: true,
		lines:true,
		fitColumns:true,
		animate:true,
        onClick:function(node, checked){
	       
	        var isLeaf = $("#dictree").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        							   
	        }else{
		    	//$("#attrtree").tree('toggle',node.target);   /// �����Ŀʱ,ֱ��չ��/�ر�
		    }
	    },
	    onContextMenu: function(e, node){
			
			e.preventDefault();
			$(this).tree('select', node.target);
			var node = $("#dictree").tree('getSelected');
			if (node == null){
				$.messager.alert("��ʾ","��ѡ�нڵ������!"); 
				return;
			}
				
			// ��ʾ��ݲ˵�
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
	    onExpand:function(node, checked){
			var childNode = $("#dictree").tree('getChildren',node.target)[0];  /// ��ǰ�ڵ���ӽڵ�
	        var isLeaf = $("#dictree").tree('isLeaf',childNode.target);        /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
	        }
		}
	};
	new CusTreeUX("dictree", url, option).Init();
	//$('#CheckPart').tree('options').url = uniturl;
	//$('#CheckPart').tree('reload');		
}


/// ҳ�� Button ���¼�
function InitBlButton(){
	
	///  ����
	//$('#insert').bind("click",AddDataTree);	
	
}

///
function InitCombobox(){
	//�ϼ�����
	$HUI.combotree('#parref',{
		 url:$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref
	});
}


//������ͬ���ڵ㰴ť
function AddSameDataTree() {
	
	RefreshData();
	var options={};
	options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref
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
				SaveDicTree("");
			}
		},{
			text:'�������',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				TSaveDicTree();
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
		var parentNode=$("#dictree").tree("getParent",record.target)			
		$('#parref').combotree('setValue', $g(parentNode.id));
	}
}

 //�������ӽڵ㰴ť
function AddDataTree() {
	RefreshData();
	var options={};
	options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref
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
				SaveDicTree()
			}
		},{
			text:'�������',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				TAddDicTree("")
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
		//$("#treeID").val(record.id);
		//var parentNode=$("#dictree").tree("getParent",record.target)	
		//if (parentNode){	
		//alert(record.id)	
			$('#parref').combotree('setValue', $g(record.id));
		//}
	}
}
	
	///�������
function TAddDicTree(){	

	SaveDicTree();
}
//����޸İ�ť
function UpdateDataTree() {
	
	RefreshData();
	
	$('#parref').combotree('reload',$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref)
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
				SaveDicTree()
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

///����������
function SaveDicTree(){
			
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

	var attrData = "";

	//��������
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
			$('#dictree').tree('reload'); //���¼���
			return;	
		}else{
			//$.messager.alert('��ʾ','����ɹ���','info');
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			CloseWin();
			$('#dictree').tree('reload'); //���¼���
			return;
		}	
		
	});	
	
	//$('#mygrid').treegrid('reload');  // �������뵱ǰҳ������ 
	//$('#myWin').dialog('close'); // close a dialog

	//$.messager.alert('������ʾ',errorMsg,"error");

}

///ɾ��
function DelDataTree(){    
              
	var record = $("#dictree").tree("getSelected"); 
	if (!(record))
	{	$.messager.alert('������ʾ','����ѡ��һ����¼!',"error");
		return;
	}
	//var childrenNodes = $("#dictree").tree('getChildren',record.target);
	var isLeaf = $("#dictree").tree('isLeaf',record.target);   /// �Ƿ���Ҷ�ӽڵ�
	if (isLeaf){
			$.messager.confirm('��ʾ', 'ȷ��Ҫɾ����ѡ��������?', function(r){
				if (r){			
					//��������
					runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":record.id},function(jsonString){
						if (jsonString != 0){
							$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
							$('#dictree').tree('reload'); //���¼���
							return;	
						}else{
							//$.messager.alert('��ʾ','����ɹ���','info');
							$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
							$('#dictree').tree('reload'); //���¼���
							return;
						}	
						
					});
				}
			});	
	}else{
		$.messager.confirm('��ʾ', '��<font color=red>��ǰ���������ӷ��࣬ɾ������ʱ��ͬʱɾ�����е��ӷ���</font>��<br/>ȷ��Ҫɾ����ѡ��������?', function(r){
				if (r){			
					//��������
					runClassMethod("web.DHCCKBDiction","DeleteAllDic",{"dicID":record.id},function(jsonString){
						if (jsonString != 0){
							$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
							$('#dictree').tree('reload'); //���¼���
							return;	
						}else{
							//$.messager.alert('��ʾ','����ɹ���','info');
							$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
							$('#dictree').tree('reload'); //���¼���
							return;
						}	
						
					});
				}
			});
		
	}

	
}

/// ���÷���
function ClearData(){
	
	$("#FindTreeText").val("");
	$('#dictree').tree('reload')
	//$('#dictree').tree('uncheckAll');
	$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //ȡ�����Ľڵ�ѡ��
}

/// ��ѯ����
function SearchData(){
	var desc=$.trim($("#FindTreeText").val());
	$("#dictree").tree("search", desc)
	$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //ȡ�����Ľڵ�ѡ��

	
}

/// �������
function RefreshData(){
	
	$("#treeID").val("");
	$("#treeCode").val("");
	$("#treeDesc").val("");
	$('#parref').combotree('setValue','');
};


function CloseWin(){

	$HUI.dialog("#myWin").close();
};

	
/// ���Ҽ����Ŀ��
function findRangeTree(PyCode){
	
	var params = PyCode +"^"+ CatId;
	var url = LINK_CSP+'?ClassName=web.DHCCKBRangeCat&MethodName=QueryRangeCatTree&params='+params;
	$("#RangeCat").tree('options').url =encodeURI(url);
	$("#RangeCat").tree('reload');
}

///���ò�����ϸ����
function SetCellOperation(value, rowData, rowIndex){

	var btnGroup = "<a style='margin-right:10px;' href='#' onclick=\"OpenWin('"+rowData.ID+"','prop')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>����</a>";
	btnGroup = btnGroup + "<a style='margin-right:10px;' href='#' onclick=\"OpenWin('"+rowData.ID+"','linkprop')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>��������</a>";
	
	return btnGroup;
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })