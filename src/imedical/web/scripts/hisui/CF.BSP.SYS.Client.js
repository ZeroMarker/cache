// CF.BSP.SYS.Client.js
var GRIDID = "#tCF_BSP_SYS_Client";
var DefaultTypeDesc = '����';
var DefaultTypeCode = 'ACTIVE';
$(function (){
	$('#Find').click(function(){
		if (!$(this).linkbutton('options').disabled){
			$(GRIDID).datagrid('load');
		}
	});
	$('#Val').keypress(function(event){
		if (event.keyCode == "13"){
			$(GRIDID).datagrid('load');
		}
	});
	$("#Type").val(DefaultTypeDesc);
	$(GRIDID).mgrid({
		className:"CF.BSP.SYS.DTO.Client",
		editGrid:true,
		key:"entity",
		title:"",
		fit:false,
		columns:[[
			{field:'CLRowId',title:'ID',hidden:true}
			,{field:'Code',title:'������',width:100}
			,{field:'Note',title:'�ͻ���λ��',width:100,editor:{type:'text'}}
			,{field:'IPAddr',title:'IP',width:100}
			,{field:'MacAddr',title:'MAC',width:100}
			,{field:'WebAppPath',title:'���ӵ�Web��ַ',width:100}
			,{field:'StDate',title:'��ʼ����',width:100}
			,{field:'EndDate',title:'��������',width:100,editor:{type:'dateboxq'}}
			/*{field:'OEScreenIndex',title:'��ʾ���ĸ���',width:80,editor:{
					blurValidValue:true,
					type:'lookup',
					options:{
						valueField:'val',
						textField:'txt',
						data:SCREENINDEXS
					}
				},formatter:function(v){
					for (var i=0; i<SCREENINDEXS.length;i++){
						if (SCREENINDEXS[i].val==v) return SCREENINDEXS[i].txt;
					}
					return 0;
				}
			}*/
		]],
		insReq:{hidden:true},
		insOrUpdHandler:function(row){
			var param ={
				"dto.entity.id":row.CLRowId,"dto.entity.Code":row.Code,"dto.entity.EndDate":row.EndDate,"dto.entity.IPAddr":row.IPAddr,"dto.entity.MacAddr":row.MacAddr,"dto.entity.Note":row.Note,"dto.entity.StDate":row.StDate,"dto.entity.WebAppPath":row.WebAppPath
			};
			if (!row.Note){
				$.messager.popover({msg:"�ͻ���λ�ò���Ϊ��!",type:'info'});
				return false;
			}
			if (row.CLRowId==""){
				if (!row.Code){
					$.messager.popover({msg:"���벻��Ϊ�գ�",type:'info'});
					return false;
				}
				$.extend(param,this.insReq,{
					"dto.entity.id":""
				});
			}else{
				$.extend(param,this.updReq,{
					"dto.entity.id":row.CLRowId
				});
			}
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			return {"CLRowId":"","Code":"","IPAddr":"","MacAddr":"","WebAppPath":"","StDate":"","EndDate":"","Note":""};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("ɾ��", "ȷ��ɾ����"+row.Code+"����¼?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.entity.id":row.CLRowId});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		},
		onBeforeLoad:function(p){
			p.Val=getValueById("Val");
			p.Type = $("#Type").lookup('getValue')||DefaultTypeCode;
		}
	});
	$(GRIDID).datagrid('options').view.onAfterRender = fixTGrid;
	$(window).on('resize',fixTGrid);
});
