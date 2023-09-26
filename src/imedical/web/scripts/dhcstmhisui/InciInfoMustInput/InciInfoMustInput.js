///基础字典控件必填项维护
///20180727 zx
///需要随时同步物资维护界面的控件id值;控件id以及所在菜单csp名称一起作为唯一记录判断
var init = function () {
	var Query=function(){
	    InciInfoMIGrid.load({
			ClassName: 'web.DHCSTMHUI.InciInfoMustInput',
			MethodName: 'Query'
		});
		
	}
	var SynchroElems=function(){
	 	var synchroRet = tkMakeServerCall("web.DHCSTMHUI.Tools.InciInfoMustInpinfo","synchroElems");	
	 	var synchroRetArr = synchroRet.split("^");
		$UI.msg("success","遍历"+synchroRetArr[1]+"个, 新增"+synchroRetArr[0]+"个!");
	 	Query()
		
	}
	var Save=function(){
	    var MainObj=$UI.loopBlock('#Conditions')
		var Main=JSON.stringify(MainObj)
		var Detail=InciInfoMIGrid.getChangesData('INCMIEleId');
		if (Detail === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Detail)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.InciInfoMustInput',
			MethodName: 'Save',
			Params: JSON.stringify(Detail)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				Query()
			}else{
				$UI.msg('error',jsonData.msg);
				 }
		});	
		
	}
	var InciInfoMIGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
        	title: "控件id",
       		field:'INCMIEleId',
        	width:200,
        	editor:{type:'validatebox',options:{required:true}}
    	}, {
	        title:"控件名称",
	        field:'INCMIEleName',
	        width:200,
	        align:'left',
	        editor:{type:'validatebox',options:{}}
	    },{
	        title:"CSP名称",
	        field:'INCMICspName',
	        width:200,
	        align:'left',
	        editor:{type:'validatebox',options:{required:true}}
	    },{
	        title:"菜单名称",
	        field:'cspCHNname',
	        width:200,
	        align:'left'
	    }, {
			title: '是否必填',
			field: 'INCMIMustFlag',
			width:100,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}
	]];
	var InciInfoMIGrid = $UI.datagrid('#InciInfoMIGrid', {
		lazy:false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.InciInfoMustInput',
			MethodName: 'Query'
		},
		deleteRowParams:{
			ClassName:'web.DHCSTMHUI.InciInfoMustInput',
			MethodName:'jsDelete'
		},
		columns: InciInfoMIGridCm,
		//sortName: 'RowId',  
		//sortOrder: 'Desc', 
		pagination:false,
		showAddDelItems:true,
		toolbar:[{
				text: '保存',
				iconCls: 'icon-save',
				handler: function () {
					Save();
				}},{
				text: '同步控件信息',
				iconCls: 'icon-reload',
				handler: function () {
					SynchroElems();
				}}],
		onClickCell: function(index, filed ,value){	
			InciInfoMIGrid.commonClickCell(index,filed,value);
		}
	})
	
}
$(init);
