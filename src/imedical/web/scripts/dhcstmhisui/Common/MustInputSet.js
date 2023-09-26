var MustInputSet=function(Block){
	var StrParam=gGroupId+"^"+gLocId+"^"+gUserId+"^"+gHospId
	var MustInputSetPer = tkMakeServerCall('web.DHCSTMHUI.Common.AppCommon','GetCommPropValue','MustInputSetPer',StrParam);
	//if(MustInputSetPer!="Y")
	//{$UI.msg("error", "您没有权限使用此功能！"); return;}

	function MustInputSave(){
		var Detail=MustInputSetGrid.getRowsData();
		if(Detail===false){return}; //验证未通过  不能保存
		$.cm({
			ClassName: 'web.DHCSTMHUI.InciInfoMustInput',
			MethodName: 'Save',
			Params: JSON.stringify(Detail)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				MustInputSetFind();
				ReSetMustInput(Block);
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	function InitMustInput(){
		var ArrData=[];
		$(Block+" :input").each(function(){
			if($(this).attr('type')!='hidden'){
				var obj={};
				var Id=$(this).attr('id');
				var Name=$(this).attr('name')||$(this).attr('comboname');
				var Label=$(this).parent().prev().text()||$(this).text();
				var Csp=App_MenuCspName;
				obj.INCMIEleId=Id;    
				obj.INCMIEleLabel=Label;
				obj.INCMIEleName=Name;
				obj.INCMICspName=Csp;
				obj.INCMIBlock=Block;
				if(!(isEmpty(Id)||isEmpty(Name)||isEmpty(Label))){
					ArrData.unshift(obj)
				}
				//$(this).parent().prev().addClass('required');
				//$(this).parent().addClass('required');
			}
		})

		$.cm({
			ClassName: 'web.DHCSTMHUI.InciInfoMustInput',
			MethodName: 'InitSave',
			Params:JSON.stringify(ArrData)
		},function(jsonData){
			if(jsonData.success==0){
				MustInputSetFind();
				//ResSetMustInput(Block);
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});	
	}
	var MustInputSetGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
        	title: "控件ID",
       		field:'INCMIEleId',
        	width:200
    	}, {
	        title:"控件Name",
	        field:'INCMIEleName',
	        width:200,
	        align:'left'
	    }, {
	        title:"控件名称",
	        field:'INCMIEleLabel',
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
	var MustInputSetGrid = $UI.datagrid('#MustInputSetGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.InciInfoMustInput',
			MethodName: 'Query'
		},
		columns: MustInputSetGridCm,
		pagination:false,
		toolbar:[{
		text: '保存',
		iconCls: 'icon-save',
		handler: function () {
			MustInputSave();
		}}
//		,{
//		text: '删除',
//		iconCls: 'icon-cancel',
//		handler: function () {
//			MustInputDelete();
//		}}
		],
		onClickCell: function(index, filed ,value){	
			MustInputSetGrid.commonClickCell(index,filed,value);
		},
		onOpen:function(){
			InitMustInput();
		}
	});
	$('#MustInputSetWin').window({
		width: 1000,
		height: 500,
		modal: true
	});
	$HUI.window('#MustInputSetWin').open();
	function MustInputSetFind(){
		MustInputSetGrid.load({
			ClassName: 'web.DHCSTMHUI.InciInfoMustInput',
			MethodName: 'Query',
			Block:Block
		});	
	}
}


function ReSetMustInput(Block){
	$.cm({
		ClassName: 'web.DHCSTMHUI.InciInfoMustInput',
		MethodName: 'Query',
		Block:Block
	},function(jsonData){
		ChangeMust(Block,jsonData)
	});	
}
function ChangeMust(Block,jsonData){
	if(jsonData.rows.lenght=0){
		return;
	}
	FormMustInput[Block]=[];
	for (var i=0;i<jsonData.rows.length;i++){
		var obj=jsonData.rows[i];
		if(obj.INCMIMustFlag=='Y'){
			FormMustInput[Block].push(obj.INCMIEleName);
	   		var Original=$('#'+obj.INCMIEleId).parent().prev().text()
	   		if(Original.indexOf("*") == -1){
	   			$('#'+obj.INCMIEleId).parent().prev().html('<span class="required">*</span>'+Original);	
				//$('#'+obj.INCMIEleId).parent().addClass('required');
	   		}
		}else{
			var Original=$('#'+obj.INCMIEleId).parent().prev().text()
	   		if(Original.indexOf("*")>-1){
	   			Original=Original.slice(1)
	   			$('#'+obj.INCMIEleId).parent().prev().html(Original);	
				//$('#'+obj.INCMIEleId).parent().addClass('required');
	   		}
		}
	}	
}