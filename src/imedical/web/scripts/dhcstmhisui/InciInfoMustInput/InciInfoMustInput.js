///�����ֵ�ؼ�������ά��
///20180727 zx
///��Ҫ��ʱͬ������ά������Ŀؼ�idֵ;�ؼ�id�Լ����ڲ˵�csp����һ����ΪΨһ��¼�ж�
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
		$UI.msg("success","����"+synchroRetArr[1]+"��, ����"+synchroRetArr[0]+"��!");
	 	Query()
		
	}
	var Save=function(){
	    var MainObj=$UI.loopBlock('#Conditions')
		var Main=JSON.stringify(MainObj)
		var Detail=InciInfoMIGrid.getChangesData('INCMIEleId');
		if (Detail === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Detail)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
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
        	title: "�ؼ�id",
       		field:'INCMIEleId',
        	width:200,
        	editor:{type:'validatebox',options:{required:true}}
    	}, {
	        title:"�ؼ�����",
	        field:'INCMIEleName',
	        width:200,
	        align:'left',
	        editor:{type:'validatebox',options:{}}
	    },{
	        title:"CSP����",
	        field:'INCMICspName',
	        width:200,
	        align:'left',
	        editor:{type:'validatebox',options:{required:true}}
	    },{
	        title:"�˵�����",
	        field:'cspCHNname',
	        width:200,
	        align:'left'
	    }, {
			title: '�Ƿ����',
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
				text: '����',
				iconCls: 'icon-save',
				handler: function () {
					Save();
				}},{
				text: 'ͬ���ؼ���Ϣ',
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
