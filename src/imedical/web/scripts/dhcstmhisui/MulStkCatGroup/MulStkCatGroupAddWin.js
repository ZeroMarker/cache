/**
 * 为类组新建节点(子类组或库存分类)
 * @param {} Node
 */
function MulScgAdd(Node){
	var ScgType = $("input[name='ScgType']:checked").val();
	var AddNodeType = Node.id.split('-')[0];
	var AddNodeRowId = Node.id.split('-')[1];
	if(typeof(AddNodeRowId) == 'undefined'){
		AddNodeRowId = '';
	}
	//有库存分类Child时,只能新增库存分类; 有类组Child或顶级类组(AllSCG),只能新增类组
	var SCGDisabled = false, INCSCDisabled = false;
	var Children;
	var IsLeaf = $('#ScgTree').tree('isLeaf', Node.target);
	if(!IsLeaf){
		Children = $('#ScgTree').tree('getChildren', Node.target);
	}
	
	if(!isEmpty(Children) && Children[0].id.indexOf('INCSC') >= 0){
		SCGDisabled = true;
	}
	if(AddNodeType == 'AllSCG' || (!isEmpty(Children) && Children[0].id.indexOf('SCG') >= 0)){
		INCSCDisabled = true;
	}
	
	if(!SCGDisabled){
		$HUI.radio("#NodeAddTypeScg").setValue(true);
	}else{
		$HUI.radio("#NodeAddTypeIncsc").setValue(true);
	}
	$HUI.radio("#NodeAddTypeScg").setDisable(SCGDisabled);
	$HUI.radio("#NodeAddTypeIncsc").setDisable(INCSCDisabled);
	
	$UI.linkbutton('#AddConfirmBT',{
		onClick: function(){
			var AddType = $('input[name="NodeAddType"]:checked').val();
			var AddCode = $('#AddCode').val();
			var AddDesc = $('#AddDesc').val();
			var SelCats = NoRelationCatGrid.getSelections();
			//关联库存分类
			if(AddType == 'INCSC' && !isEmpty(SelCats)){
				var IncscStr = '';
				for(var i = 0, len = SelCats.length; i < len; i++){
					var Incsc = SelCats[i]['RowId'];
					if(IncscStr == ''){
						IncscStr = Incsc;
					}else{
						IncscStr = IncscStr + '^' + Incsc;
					}
				}
				var ret = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'ScgRelaIncsc', AddNodeRowId, IncscStr);
				if(ret == ''){
					$UI.msg('alert', '关联成功!');
				}else{
					$UI.msg('alert', '关联失败!');
					return false;
				}
			}
			
			//库存分类, 且有关联的时候, 若代码或名称为空, 则不处理
			if(AddType == 'INCSC' && !isEmpty(SelCats) && (AddCode == '' || AddDesc == '')){
				$HUI.dialog('#MulScgAddWin').close();
				GetScgTree();
			}else{
				if(AddCode == ''){
					$UI.msg('alert', '代码不可为空!');
					return false;
				}
				if(AddDesc == ''){
					$UI.msg('alert', '名称不可为空!');
					return false;
				}
				var StrParam = AddType + '^' + AddCode + '^' + AddDesc + '^' + AddNodeRowId + '^' + ScgType;
				var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
				var ret = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'Add', StrParam, Params);
				if(ret === ''){
					$('#AddCode').val("");
					$('#AddDesc').val("");
					$UI.msg('success', '保存成功!');
					$HUI.dialog('#MulScgAddWin').close();
					GetScgTree();
				}else{
					$UI.msg('error', ret);
				}
			}
		}
	});
	
	var NoRelationCatGrid = $UI.datagrid('#NoRelationCatGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.MulStkCatGroup',
			MethodName: 'NoRelationCat'
		},
		fitColumns: true,
		columns: [[
			{checkbox: true},
			{title: 'RowId', field: 'RowId',width : 50, hidden: true},
			{title: '名称', field: 'Description', width: 200}
		]],
		pagination: false,
		singleSelect: false,
		onCheck: function(index, row){
			var AddType = $('input[name="NodeAddType"]:checked').val();
			if(AddType == 'SCG'){
				$UI.msg('alert', '新增类组时,不允许勾选库存分类');
				NoRelationCatGrid.uncheckRow(index);
			}
		}
	});
	
	$HUI.dialog('#MulScgAddWin',{
		onOpen: function(){
			$UI.clear(NoRelationCatGrid);
			NoRelationCatGrid.load({
				ClassName: 'web.DHCSTMHUI.MulStkCatGroup',
				MethodName: 'NoRelationCat',
				Type: ScgType,
				Params: JSON.stringify(addSessionParams({BDPHospital:HospId}))
			});
		}
	}).open();
}


/**
 * 修改信息(子类组)
 * @param {} Node
 */
function MulScgUpdate(Node){
	var UpdateNodeType = Node.id.split('-')[0];
	var UpdateNodeRowId = Node.id.split('-')[1];
	
	$('#UpdateScgSet').combobox({
		data : [
			{RowId:'MM', Description:'医用材料'},
			{RowId:'MO', Description:'后勤材料'},
			{RowId:'MR', Description:'试剂'},
			{RowId:'MF', Description:'固定资产'}
		],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$UI.linkbutton('#UpdateScgBT', {
		onClick: function(){
			var UpdateCode = $('#UpdateScgCode').val();
			var UpdateDesc = $('#UpdateScgDesc').val();
			//库存分类, 且有关联的时候, 若代码或名称为空, 则不处理
			if(UpdateCode == ''){
				$UI.msg('alert', '代码不可为空!');
				return false;
			}
			if(UpdateDesc == ''){
				$UI.msg('alert', '名称不可为空!');
				return false;
			}
			var UpdateScgSet = $('#UpdateScgSet').combobox('getValue');
			var StrParam = UpdateNodeRowId + '^' + UpdateCode + '^' + UpdateDesc + '^' + UpdateScgSet;
			var Params = JSON.stringify(addSessionParams({BDPHospital:HospId}));
			if(UpdateNodeType == 'SCG'){
				var ret = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'UpdateStkGrp', StrParam, Params);
			}
			if(ret === ''){
				$('#UpdateScgCode').val("");
				$('#UpdateScgDesc').val("");
				$UI.msg('success', '保存成功!');
				$HUI.dialog('#UpdateScgWin').close();
				GetScgTree();
			}else{
				$UI.msg('error', ret);
			}
		}
	});
	
	$HUI.dialog('#UpdateScgWin', {
		title: '修改类组信息',
		width: 350,
		height: 200,
		onOpen: function(){
			if(UpdateNodeType == 'SCG'){
				var Info = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'GetStkGrpInfo', UpdateNodeRowId);
			}
			var InfoArr = Info.split('^');
			var Code = InfoArr[0], Desc = InfoArr[1], ScgSet = InfoArr[3], SpReq = InfoArr[4];
			$('#UpdateScgCode').val(Code);
			$('#UpdateScgDesc').val(Desc);
			$('#UpdateScgSet').combobox('setValue', ScgSet);
		}
	}).open();
}

/**
 * 修改信息(库存分类)
 * @param {} Node
 */
function StkCatUpdate(Node){
	var UpdateNodeType = Node.id.split('-')[0];
	var UpdateNodeRowId = Node.id.split('-')[1];
	
	$UI.linkbutton('#UpdateCatBT', {
		onClick: function(){
			var UpdateCode = $('#UpdateCatCode').val();
			var UpdateDesc = $('#UpdateCatDesc').val();
			//库存分类, 且有关联的时候, 若代码或名称为空, 则不处理
			if(UpdateCode == ''){
				$UI.msg('alert', '代码不可为空!');
				return false;
			}
			if(UpdateDesc == ''){
				$UI.msg('alert', '名称不可为空!');
				return false;
			}
			var StrParam = UpdateNodeRowId + '^' + UpdateCode + '^' + UpdateDesc;
			if(UpdateNodeType == 'INCSC'){
				var ret = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'UpdateStkCat', StrParam);
			}
			if(ret === ''){
				$('#UpdateScgCode').val("");
				$('#UpdateScgDesc').val("");
				$UI.msg('success', '保存成功!');
				$HUI.dialog('#UpdateCatWin').close();
				GetScgTree();
			}else{
				$UI.msg('error', ret);
			}
		}
	});

	$HUI.dialog('#UpdateCatWin', {
		title: '修改库存分类信息',
		width: 300,
		height: 200,
		onOpen: function(){
			if(UpdateNodeType == 'INCSC'){
				var Info = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'GetStkCatInfo', UpdateNodeRowId);
			}
			var Code = Info.split('^')[0], Desc = Info.split('^')[1];
			$('#UpdateCatCode').val(Code);
			$('#UpdateCatDesc').val(Desc);
		}
	}).open();
}
