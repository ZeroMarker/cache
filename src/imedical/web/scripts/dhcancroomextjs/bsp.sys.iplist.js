var init = function(){
	$("#grid").mgrid({
		width:500,
		fitColumns:false,
		fit:true,
		editGrid:true,
		codeField:"Name",
		className:"CF.BSP.SYS.BL.IPList",
		columns:[[
			{field:'ID',title:'ID',width:'30',hidden:true},
			{field:'Name',title:'����',width:'100',editor:{type:'text'}},
			{field:'LanIP',title:'����IP',width:'150',editor:{type:'text'}},
			{field:'WanIP',title:'����IP',width:'150',editor:{type:'text'}},
			{field:'Type',title:'���ͷ���',width:'150',editor:{
				type:'combobox',
				options:{
					valueField:'id',
					textField:'text',
					data:[
						{id:'LB',text:'���ؾ���'},
						{id:'ECP',text:'ECP'},
						{id:'MWEB',text:'��WEB'},
						{id:'MDB',text:'��DB'}
					]
				}
			},
			formatter: function(value,row,index){
				return row.TypeDesc;
			}},
			{field:'Active',title:'����',width:'70',editor:{
				type:'combobox',
				options:{
					valueField:'id',
					textField:'text',
					data:[
						{id:'1',text:'��'},
						{id:'0',text:'��'}
					]
				}
			},
			formatter:function(value,row,index){
				if(value==1){
					return '��';	
				}else{
					return '��';	
				}
			}}
		]],
		delHandler:function(row){
			var _t=this;
			$.messager.confirm("ɾ��","�ò�����ɾ����¼��ȷ��ɾ����"+row.Name+"����¼��?", function(r){
				if(r){
					$.extend(_t.delReq,{"dto.iplist.id":row.ID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		},
		insOrUpdHandler:function(row){
			var param;
			var _t = this;
			if(row.ID==""){
				if(row.Name==""){
					$.messager.popover({msg:"���Ʋ���Ϊ��!",type:"info"});
					return;
				}
				param = _t.insReq;
			}else{
				param = $.extend(_t.updReq,{"dto.iplist.id":row.ID});
			}
			$.extend(param,{"dto.iplist.Name":row.Name,"dto.iplist.LanIP":row.LanIP,"dto.iplist.WanIP":row.WanIP,"dto.iplist.Type":row.Type,"dto.iplist.Active":row.Active});
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			return {ID:"",Name:"",LanIP:"",WanIP:"",Type:"",Active:1};	
		}
	});
	var bType = $HUI.combobox("#boxType",{
		valueField:'id',
		textField:'text',
		data:[
			{id:'LB',text:'���ؾ���'},
			{id:'ECP',text:'ECP'},
			{id:'MWEB',text:'��WEB'},
			{id:'MDB',text:'��DB'}
		],
		editable:true,
		panelHeight:"200"
	});
	bType.setValue("");
	var bActive = $HUI.combobox("#boxActive",{
		valueField:'id',
		textField:'text',
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'}
		],
		editable:true,
		panelHeight:"200"
	});
	bActive.setValue("");
	$("#search").click(function(){
		var Name = $("#ssName").val();
		var LanIP = $("#ssLanIP").val();
		var WanIP = $("#ssWanIP").val();
		var Type = bType.getValue();
		var Active = bActive.getValue();
		$("#grid").datagrid("load",{
			ClassName:"CF.BSP.SYS.BL.IPList",
			QueryName:"Find",
			PName:Name,
			PLanIP:LanIP,
			PWanIP:WanIP,
			PType:Type,
			PActive:Active
		});
	});
}
$(init);