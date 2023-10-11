/// ����: ��ҽ�������ֵ�ά��

$(function(){
	Init();
});
function Init(){
	InitTreeGrid();
	InitEvent();
	InitKICDescCombo();
}
// ���ڴ���hisui-treegrid�����ˢ�º󱣳�ԭ�۵�״̬����취
var recordNodes = new Array();//����һ������������¼�ѱ�չ���Ľڵ�ID
function InitTreeGrid(){
	var columns =[[  
	   {field:'id',title:'id',width:80,sortable:true,hidden:true},
	   {field:'text',title:'����',width:360,sortable:true}
	]];
	var mygrid = $HUI.treegrid("#mygrid",{
		//url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=Nur.TCM.Service.Config&pClassMethod=GetTreeJson&LastLevel=",
		columns: columns,  
		height:$(window).height()-105,  
		idField: 'id',
		ClassName: "Nur.TCM.Service.Config", //��ק����DragNode���ڵ���
		DragMethodName:"DragNode",
		treeField:'text',  	
		autoSizeColumn:false,
		animate:false,    
		lines:true,
		showHeader:false,
		fitColumns:false, 
		remoteSort:false, 
		striped:false,
		autoRowHeight:false,
		onContextMenu: function(e, row){ 
			var $clicked=$(e.target);
			e.preventDefault();
        	$(this).treegrid('select', row.id);
			var mygridmm = $('<div style="width:120px;"></div>').appendTo('body')
			
			$(
			'<div onclick="AddSameDataTree()" iconCls="icon-add" data-options="">��ӱ���</div>' +
       		'<div onclick="AddDataTree()" iconCls="icon-add" data-options="">����¼�</div>' +
       		'<div onclick="UpdateDataTree()" iconCls="icon-write-order" data-options="">�޸�</div>' +
       		'<div onclick="DelDataTree()" iconCls="icon-cancel" data-options="">ɾ��</div>'+
       		'<div onclick="ClearFunLib()" iconCls="icon-reload" data-options="">����</div>'
       		).appendTo(mygridmm)
		       		
			mygridmm.menu()
			mygridmm.menu('show',{
				left:e.pageX,  
				top:e.pageY
			});	
		},
        onDblClickRow: function (rowIndex,rowData) {
        	UpdateDataTree()
        },
		onLoadSuccess:function(data) {
			$(this).treegrid('enableDnd', data?data.id:null);
			/*$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
			$(this).treegrid('enableDnd', data?data.id:null);
			// �洢�۵����� start
			//����¼��չ���ڵ�ID����������ת�浽��һ������������
            var list = [];
            for (var j = 0; j < recordNodes.length; j++) {
                list.push(recordNodes[j])
            }
            //������뽫�Ѽ�¼�Ľڵ�ת�浽��һ��������,
            //��Ϊִ��collapseAll������,�ᴥ��onBeforeCollapse�¼�
            //������Ѽ�¼�Ľڵ�����
            $("#mygrid").treegrid("collapseAll");
            for (var i = 0; i < list.length; i++) {
                $('#mygrid').treegrid('expand', list[i]);
            }
            // �洢�۵����� end*/
        },
        // �洢�۵����� start
        onBeforeExpand: function (node) {
	        if (!node._parentId){
		        if (!node.children) {
					UpdateNodeChildData(node.id);
				}
		    }
	        //ÿ��ִ��չ��һ���ڵ�Ĳ���ʱ
	        //��¼��չ���Ľڵ�ID
	        recordNodes.push(node.id.toString());
       },
       onBeforeCollapse: function (node) {
            //ÿ��ִ���۵�һ���ڵ�Ĳ���ʱ
            //��������ȥ�����۵��Ľڵ�ID
            var i = recordNodes.indexOf(node.id.toString());
            if (i >= 0) {
                recordNodes.splice(i, 1);
            }
        },
        onDrop: function(targetRow, sourceRow, point){
        	$(this).treegrid('enableDnd') //������ק
        }
	});
	LoadTreeGridData();
}
function LoadTreeGridData(){
	var TCMDieaseData=$.cm({ 
	    ClassName:"Nur.TCM.Service.Config",
	    MethodName:"GetTCMDiease"
	},false)
	$('#mygrid').treegrid("loadData",{"rows":TCMDieaseData,"total":TCMDieaseData.length});
}
function InitEvent(){
	//������
	$('#FindTreeText').keyup(function(event){
		if(event.keyCode == 13) {
			SearchFunLib();
		}
		if(event.keyCode == 27) {
		    ClearFunLib();
		}
	});
	//������
	$("#myChecktreeDesc").keyup(function(){ 
		var str = $("#myChecktreeDesc").val(); 
		findByRadioCheck("myChecktree",str,$("input[name='FilterCK']:checked").val())
	})
	$('#btn_search').click(SearchFunLib);
}
//��ѯ����
function SearchFunLib(){
	var desc=$.trim($("#FindTreeText").val());
	$("#mygrid").treegrid('unselectAll').treegrid("search", desc)
}
//���÷���
function ClearFunLib(){
	$("#FindTreeText").val("");
	$('#mygrid').datagrid('unselectAll').treegrid('reload');
}
//������ͬ���ڵ㰴ť
function AddSameDataTree(){
	ClearWinData();
	$.cm({ 
	    ClassName:"Nur.TCM.Service.Config",
	    MethodName:"GetTreeJson",
	    LastLevel:""
	},function(GridData){
		$('#KICParentID').combotree('loadData',GridData);
	})	
	$("#myWin").show();
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-addlittle',
		resizable:true,
		title:'���',
		modal:true,
		buttonAlign : 'center',
		buttons:[{
			text:'����',
			id:'save_btn',
			handler:function(){
				SaveFunLibTree("")
			}
		},{
			text:'�������',
			id:'save_btn',
			handler:function(){
				TAddFunLibTree("")
			}
		},{
			text:'�ر�',
			handler:function(){
				myWin.close();
			}
		}]
	});	
	var record = $("#mygrid").treegrid("getSelected"); 
	if (record){
		var ParentNode=$("#mygrid").treegrid("getParent",record.id)
		if (ParentNode){
			$('#KICParentID').combotree('setValue', ParentNode.id);
			var node = $('#KICParentID').combotree("tree").tree('find', ParentNode.id);
		    $('#KICParentID').combotree("tree").tree("expandTo",node.target);
		}
	}
}
//������ͬ���ӽڵ㰴ť
function AddDataTree(){
	ClearWinData();
	var GridData=$.cm({ 
	    ClassName:"Nur.TCM.Service.Config",
	    MethodName:"GetTreeJson",
	    LastLevel:""
	},false)
	$('#KICParentID').combotree('loadData',GridData);
	$("#myWin").show();
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-w-add',
		resizable:true,
		title:'����',
		modal:true,
		buttonAlign : 'center',
		buttons:[{
			text:'����',
			id:'save_btn',
			handler:function(){
				SaveFunLibTree("")
			}
		},{
			text:'�������',
			id:'save_btn',
			handler:function(){
				TAddFunLibTree("")
			}
		},{
			text:'�ر�',
			handler:function(){
				myWin.close();
			}
		}]
	});	
	ClearWinData();
	var record = $("#mygrid").treegrid("getSelected"); 
	if (record){
		$('#KICParentID').combotree('setValue', record.id);
		var node = $('#KICParentID').combotree("tree").tree('find', record.id);
		$('#KICParentID').combotree("tree").tree("expandTo",node.target);
	}
}
function UpdateDataTree(){
	ClearWinData();
	var GridData=$.cm({ 
	    ClassName:"Nur.TCM.Service.Config",
	    MethodName:"GetTreeJson",
	    LastLevel:""
	},false)
	$('#KICParentID').combotree('loadData',GridData);
	var record = $("#mygrid").treegrid("getSelected"); 
	if (!(record)){	
		$.messager.popover({msg: '����ѡ��һ����¼!',type: 'error'});
		return false;
	}
	var id=record.id;
	$.cm({
		ClassName:"Nur.TCM.Service.Config",
		MethodName:"GetDataObjById",
		id:id
	},function(jsonData){
		for (item in jsonData){
			var _$id=$("#"+item);
			if (_$id.hasClass('combobox-f')){
				_$id.combobox("setValue",jsonData[item]);
				if (item =="KICDesc"){
					_$id.combobox("setText",jsonData[item]);
				}
			}else if(_$id.hasClass('combotree-f')){
				_$id.combotree("setValue",jsonData[item]);
			}else{
				_$id.val(jsonData[item]);
			}
		}
		$("#myWin").show(); 
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'�޸�',
			modal:true,
			buttons:[{
				text:'����',
				id:'save_btn',
				handler:function(){
					SaveFunLibTree(id)
				}
			},{
				text:'�ر�',
				handler:function(){
					myWin.close();
				}
			}]
		});
	})
}
///����������
function SaveFunLibTree(selNodeId){
	var SaveDataArr=[];
	SaveDataArr.push({"field":"KICRowId","fieldValue":selNodeId});
	var NullValColumnArr=[];
	var _$input=$("#config-table tr td:not(.r-label) > input");
	for (var i=0;i<_$input.length;i++){
		var id=_$input[i].id;
		if (!id) continue;
		var _$id=$("#"+id);
		if (_$id.hasClass('combobox-f')){
			var value=_$id.combobox("getValue");
			if (id =="KICDesc"){
				value=$.trim(_$id.combobox("getText"));
			}
		}else if(_$id.hasClass('combotree-f')){
			var value=_$id.combotree("getValue");
			if (!$.trim(_$id.combotree("getText"))) value="";
		}else{
			var value=$.trim(_$id.val());
			if ((id =="KICCode")&&(value=="")){
				value=$.trim($("#KICDesc").combobox("getText"));
			}
		}
		var _$label=$('label[for="' + id + '"]');
		if ((_$label.hasClass("clsRequired"))&&(!value)) {
			NullValColumnArr.push(_$label[0].innerHTML);
		}
		SaveDataArr.push({"field":id,"fieldValue":value});
	}
	if (NullValColumnArr.length>0){
		$.messager.popover({msg: NullValColumnArr.join("��")+"����Ϊ��!",type: 'error'});
		return false;
	}
	$.cm({
		ClassName:"Nur.TCM.Service.Config",
		MethodName:"SaveData",
		SaveDataArr:JSON.stringify(SaveDataArr)
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '����ɹ���',type: 'success'});
			LoadTreeGridData();
		    $('#myWin').dialog('close'); 
		}else{
			$.messager.popover({msg: '����ʧ�ܣ�',type: 'error'});
		}
	})
}
///�������
function TAddFunLibTree(id){
	var LastLevel="";
	var SaveDataArr=[];
	SaveDataArr.push({"field":"KICRowId","fieldValue":id});
	var NullValColumnArr=[];
	var _$input=$("#config-table tr td:not(.r-label) > input");
	for (var i=0;i<_$input.length;i++){
		var id=_$input[i].id;
		if (!id) continue;
		var _$id=$("#"+id);
		if (_$id.hasClass('combobox-f')){
			var value=$.trim(_$id.combobox("getValue"));
			if (id =="KICDesc"){
				value=$.trim(_$id.combobox("getText"));
			}
		}else if(_$id.hasClass('combotree-f')){
			var value=_$id.combotree("getValue");
			if (!$.trim(_$id.combotree("getText"))) value="";
		}else{
			var value=$.trim(_$id.val());
			if ((id =="KICCode")&&(value=="")){
				value=$.trim($("#KICDesc").combobox("getText"));
			}
		}
		var _$label=$('label[for="' + id + '"]');
		if ((_$label.hasClass("clsRequired"))&&(!value)) {
			NullValColumnArr.push(_$label[0].innerHTML);
		}
		if (id =="KICParentID"){
			var LastLevel=value;
		}
		SaveDataArr.push({"field":id,"fieldValue":value});
	}
	if (NullValColumnArr.length>0){
		$.messager.popover({msg: NullValColumnArr.join("��")+"����Ϊ��!",type: 'error'});
		return false;
	}
	$.cm({
		ClassName:"Nur.TCM.Service.Config",
		MethodName:"SaveData",
		SaveDataArr:JSON.stringify(SaveDataArr)
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '����ɹ���',type: 'success'});
			ClearWinData();
			$('#KICParentID').combotree('setValue', LastLevel);
			var node = $('#KICParentID').combotree("tree").tree('find', LastLevel);
		    $('#KICParentID').combotree("tree").tree("expandTo",node.target);
			LoadTreeGridData(); 
		}else{
			$.messager.popover({msg: '����ʧ�ܣ�',type: 'error'});
		}
	})
}
///ɾ��
function DelDataTree(){
	var record = $("#mygrid").treegrid("getSelected"); 
	if (!(record)){	
		$.messager.alert('������ʾ','����ѡ��һ����¼!',"error");
		return;
	}
	$.messager.confirm('��ʾ', 'ȷ��Ҫɾ����ѡ��������?', function(r){
		if (r){
			$.cm({
				ClassName:"Nur.TCM.Service.Config",
				MethodName:"DeleteData",
				id:record.id
			},function(rtn){
				if (rtn ==0) {
					$.messager.popover({msg: 'ɾ���ɹ���',type: 'success'});
					$('#mygrid').treegrid('remove',record.id);
				}else{
					$.messager.popover({msg: 'ɾ��ʧ�ܣ�'+rtn,type: 'error'});
				}
			})
		}
	});		
}
function ClearWinData(){
	var _$input=$("#config-table tr td:not(.r-label) > input");
	for (var i=0;i<_$input.length;i++){
		var id=_$input[i].id;
		if (!id) continue;
		var _$id=$("#"+id);
		if (_$id.hasClass('combobox-f')){
			_$id.combobox("setValue","").combobox("setText","");
		}else if(_$id.hasClass('combotree-f')){
			_$id.combotree("setValue","");
		}else{
			_$id.val("");
		}
	}
}
function InitKICDescCombo(){
	$("#KICDesc").combobox({
		required:true,
		textField:"text",
		valueField:"id",
		data:[{    
		    "id":"��Ҫ֢״",    
		    "text":"��Ҫ֢״"   
		},{    
		    "id":"֤�����",    
		    "text":"֤�����"   
		},{    
		    "id":"��Ҫ��֤ʩ������",    
		    "text":"��Ҫ��֤ʩ������"  
		},{    
		    "id":"��ҽ������",    
		    "text":"��ҽ������"   
		},{    
		    "id":"֢״��������",    
		    "text":"֢״��������"   
		}]
	})
}
function UpdateNodeChildData(parentID){
	var Childrens=$('#mygrid').treegrid("getChildren",parentID);
	for (var i=Childrens.length-1;i>=0;i--){
		$('#mygrid').treegrid('remove',Childrens[i].id);
	}
	var GridData=$.cm({ 
	    ClassName:"Nur.TCM.Service.Config",
	    MethodName:"GetTCMDieaseChild",
	    LastLevel:parentID
	},false)
	$('#mygrid').treegrid('append',{
		parent: parentID,
		data: GridData
	});
}