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
			{field:'Name',title:'名称',width:'100',editor:{type:'text'}},
			{field:'LanIP',title:'内网IP',width:'150',editor:{type:'text'}},
			{field:'WanIP',title:'外网IP',width:'150',editor:{type:'text'}},
			{field:'Type',title:'类型服务',width:'150',editor:{
				type:'combobox',
				options:{
					valueField:'id',
					textField:'text',
					data:[
						{id:'LB',text:'负载均衡'},
						{id:'ECP',text:'ECP'},
						{id:'MWEB',text:'主WEB'},
						{id:'MDB',text:'主DB'}
					]
				}
			},
			formatter: function(value,row,index){
				return row.TypeDesc;
			}},
			{field:'Active',title:'激活',width:'70',editor:{
				type:'combobox',
				options:{
					valueField:'id',
					textField:'text',
					data:[
						{id:'1',text:'是'},
						{id:'0',text:'否'}
					]
				}
			},
			formatter:function(value,row,index){
				if(value==1){
					return '是';	
				}else{
					return '否';	
				}
			}}
		]],
		delHandler:function(row){
			var _t=this;
			$.messager.confirm("删除","该操作会删除记录，确定删除【"+row.Name+"】记录吗?", function(r){
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
					$.messager.popover({msg:"名称不能为空!",type:"info"});
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
			{id:'LB',text:'负载均衡'},
			{id:'ECP',text:'ECP'},
			{id:'MWEB',text:'主WEB'},
			{id:'MDB',text:'主DB'}
		],
		editable:true,
		panelHeight:"200"
	});
	bType.setValue("");
	var bActive = $HUI.combobox("#boxActive",{
		valueField:'id',
		textField:'text',
		data:[
			{id:'1',text:'是'},
			{id:'0',text:'否'}
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