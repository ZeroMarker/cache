// CF.BSP.SYS.OpenEvent
var GRIDID = "#tCF_BSP_SYS_OpenEvent";
var SCREENTYPES = [{val:"SS",txt:"Ŀ���������ڣ��򿪵�����"},{val:"OSS",txt:"Ŀ���������ڣ�����"}];
var SCREENINDEXS = [{val:0,txt:"����"},{val:1,txt:"��һ����"},{val:2,txt:"�ڶ�����"}];
var initMenuGrid =function (id){
	var menuGridWinJObj = $("#menuGridWin");
	if (menuGridWinJObj.length==0){
		menuGridWinJObj = $("<div id='menuGridWin'></div>").append("body");
	}
	menuGridWinJObj.dialog({
		title:'ά�����ڵĲ˵��б�',
		content:'<table id="menuGrid"></table>',
		width:560,
		height:392,
		modal:true,
		onBeforeClose:function(){
			$(GRIDID).datagrid('load');
		}
	});
	
	$("#menuGrid").mgrid({
		className:"CF.BSP.SYS.DTO.OpenEventMenu",
		queryName:"Find",
		editGrid:true,//id:"",
		key:"menu",
		title:"",
		getReq:{QueryName:"Find",OEID:id,val:""},
		//codeField:"OECode",
		//activeColName:'OEActive',
		fit:true,
		defaultsColumns:[
			{field:'OEMId',hidden:true},
			{field:'OEMMenuId',hidden:true},
			{field:'OEMMenuCaption'},
			{field:'OEMMenuCode',width:120,editor:{
				type:'lookup',
				options:{
					url:$URL+"?ClassName=websys.Menu&QueryName=FindMenu&desc=",					
					mode:"remote",
					idField:"HIDDEN",
					textField:"Code",
					pagination:true,
					isCombo:true,
					minQueryLen:2,
					columns:[[  
						{field:'HIDDEN',hidden:true},  
						{field:'Description',title:'�˵���',width:150} ,
						{field:'Code',title:'�˵�����',width:150} 
					]],
					onSelect:function(index,rowData){
						console.log("index="+index+",rowData=",rowData);
					},
					onBeforeLoad:function(p){
						if (p.q=="") return false;
						p.desc = p.q;
					}
				}
			}}
		],
		insOrUpdHandler:function(row){
			var param ;
			if (row.OEMId==""){
				if (!row.OEMMenuCode){
					$.messager.popover({msg:"�˵�����Ϊ�գ�",type:'info'});
					return false;
				}
				param = this.insReq;
			}else{
				param = $.extend(this.updReq,{
					"dto.po.id":row.OEMId
				});
			}
			$.extend(param,{
				"dto.OEMMenuCode":row.OEMMenuCode,
				"dto.po.OpenEventID":id
			});
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			return {OEMId:"",OEMMenuId:"",OEMMenuCode:"",OEMMenuCaption:""};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("ɾ��", "ȷ��ɾ����"+row.OEMMenuCaption+"���¼�?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.po.id":row["OEMId"]});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		},
		onBeforeLoad:function(p){
			//p.val = $(GRIDID).datagrid('getSelect');
		}
	});
}
$(function (){
	$('#Find').click(function(){
		if (!$(this).linkbutton('options').disabled){
			$(GRIDID).datagrid('load');
		}
	});
	$('#val').keypress(function(event){
		if (event.keyCode == "13"){
			$(GRIDID).datagrid('load');
		}
	});
	$(GRIDID).mgrid({
		className:"CF.BSP.SYS.DTO.OpenEvent",
		editGrid:true,//id:"",
		key:"po",
		title:"",
		getReq:{QueryName:"Find",val:""},
		//codeField:"OECode",
		activeColName:'OEActive',
		fit:false,
		columns:[[
			{field:'OEMenuCaption',title:'�¼��˵�',width:100,formatter:function(val,row){
				return "<a onclick='initMenuGrid("+row["OEID"]+");return false;' href='#'>"+val+"</a>"
			}},
			{field:'OEActive',title:'����',width:20,formatter:function(v){if (v==0){ return "����"}return "����"; },editor:{type:'icheckbox',options:{on:'1',off:'0'}}},
			{field:'OECode',title:'�¼���',width:120,editor:{type:'text'}},
			{field:'OEDesc',title:'����',width:120,editor:{type:'text'}},
			{field:'OEPageUrl',title:'�򿪵Ľ���(csp)',width:120,editor:{type:'text'}},
			
			{field:'OEScreenIndex',title:'��ʾ���ĸ���',width:80,editor:{
					blurValidValue:true,
					type:'combobox',
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
			},
			{field:'OEPageShowType',title:'Ŀ����������ʱ',width:120,editor:{
					blurValidValue:true,
					type:'combobox',
					options:{
						valueField:'val',
						textField:'txt',
						data:SCREENTYPES
					}
				},formatter:function(v){
					for (var i=0; i<SCREENTYPES.length;i++){
						if (SCREENTYPES[i].val==v) return SCREENTYPES[i].txt;
					}
					return 0;
				}
			}
		]],
		insOrUpdHandler:function(row){
			var param ;
			if (row.OEID==""){
				if (!row.OECode){
					$.messager.popover({msg:"���벻��Ϊ�գ�",type:'info'});
					return false;
				}
				param = this.insReq;
			}else{
				param = $.extend(this.updReq,{
					"dto.po.id":row.OEID
				});
			}
			$.extend(param,{
				"dto.po.OECode":row.OECode,
				"dto.po.OEDesc":row.OEDesc,
				"dto.po.OEPageUrl":row.OEPageUrl,
				"dto.po.OEPageShowType":row.OEPageShowType,
				"dto.po.OEScreenIndex":row.OEScreenIndex,
				"dto.po.OEActive":row.OEActive
			});
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			return {OEID:"",OECode:"",OEDesc:"",OEPageUrl:"",OEPageShowType:"OSS",OEScreenIndex:1,OEActive:1};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("ɾ��", "ȷ��ɾ����"+row.OECode+"���¼�?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.po.id":row.OEID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		},
		onBeforeLoad:function(p){
			p.val=getValueById("val");
		}
	});
	$(GRIDID).datagrid('options').view.onAfterRender = fixTGrid;
	$(window).on('resize',fixTGrid);
});