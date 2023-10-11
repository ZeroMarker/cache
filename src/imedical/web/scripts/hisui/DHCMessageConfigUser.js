//DHCMessageConfigUser
function fixTGrid(){
	if ($('#configUserGrid').length==0) return ;
	var h = $(window).height();
	var offset = $('#configUserGrid').closest('.datagrid').offset();
	if (!offset) return ;
	$('#configUserGrid').datagrid('resize',{height:parseInt(h-offset.top-13)});
	$('#configUserGrid').datagrid('options').view.onAfterRender = function(){}
}
$(function (){
	$("#configUserGrid").mgrid({
		className:"websys.dto.UserSearchIntervalDto",
		editGrid:true,//id:"",
		key:"po",
		title:"�û�ˢ����Ϣʱ�������б�",
		getReq:{QueryName:"LookUp",UserCode:""},
		codeField:"UserCode",
		idField:'UserCode',
		fit:false,
		columns:[[
			{field:'UserCode',title:'�û�����',width:120,editor:{type:'combogrid',options:{
				panelWidth:450,
				delay: 500,
				mode: 'remote',
				url:$URL+"?ClassName=websys.DHCMessageReceiveCfgMgr&QueryName=FindReceiveObj",
				onBeforeLoad:function(param){
					param.desc=param.q;
					param.rectype='U';
					return true;
				},
				idField:"Code",textField:"Code",
				columns:[[{field:'Desc',title:'����',width:200},{field:'Code',title:'����',width:200}]],
				pagination:true
				,onSelect:function(ind,row){
					
					var dgRow=$("#configUserGrid").datagrid('getSelected');
					dgRow.UserName=row.Desc;
					var dgInd=$("#configUserGrid").datagrid('options').currEditIndex;
					$('#datagrid-row-r1-2-'+dgInd).find('.datagrid-cell-c1-UserName').text(row.Desc);
					
					
//					var dgInd=$("#configUserGrid").datagrid('options').currEditIndex;
//					var editor=$("#configUserGrid").datagrid('getEditor',{index:dgInd,field:'UserName'})
//					if(editor){
//						$(editor.target).val(row.Desc);
//					}
					
					
				}
			}}},
			{field:'UserName',title:'�û�����',width:120},
			{field:'UserSearchInterval',title:'ʱ����(����)',width:120,editor:{type:'text'}}
		]],
		insOrUpdHandler:function(row,onAfterSave){
			var param ;
			if (!row.UserCode){
				$.messager.popover({msg:"�û����벻��Ϊ�գ�",type:'info'});
				return false;
			}
			param = $.extend(this.insReq,{
				"dto.po.id":$("#rowid").val(),
				"dto.userCode":row.UserCode,
				"dto.userSearchInterval":row.UserSearchInterval,
				"dto.gridId":"configUserGrid"
			});
			$cm(param,function(rtn){
				onAfterSave(rtn.success==1,rtn.msg)
			});
		},
		getNewRecord:function(){
			return {"UserCode":"","UserName":"","UserSearchInterval":3};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("ɾ��", "ȷ��ɾ����"+row.UserName+"������?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.po.id":$("#rowid").val(),"dto.userCode":row.UserCode,"dto.gridId":"configUserGrid"}); //timeLineArr[selectedTimeLineInd].Code+"||"
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
	$('#configUserGrid').datagrid('options').view.onAfterRender = fixTGrid;
	$(window).on('resize',fixTGrid);
});