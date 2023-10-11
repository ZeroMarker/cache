//页面Gui
var obj = new Object();
function InitHISUIWin(){
	$.parser.parse(); // 解析整个页面
	obj.curOrdGrpID="";
	obj.ViewMode="View";
	obj.IsUnChecking=false;
	obj.IsChecking=false;	//防止死循环
	
	//按钮初始化
	$('#winOrdGroupEdit').dialog({
		title: '分组信息维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true
	});
	
	obj.cboOrdGroup = $HUI.combogrid('#cboOrdGroup', {
		url: $URL,
		editable: false,
		placeholder:'全部医嘱',
		idField: 'ID',
		textField: 'OrdGroupDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathOrdGroupSrv';
			param.QueryName = 'QryPathOrdGroup';
			param.aFormEpID = curFormEpID;
			param.ResultSetType = 'array';
		},
		columns:[[
			{field:'OrdGroupDesc',title:'名称',width:80,sortable:true},    
        	{field:'OrdGroupNote',title:'备注',width:150,sortable:true} 
		]],
		onSelect:function(index,row){
			obj.curOrdGrpID=row.ID;
			obj.ViewMode="View";
			obj.SetBtnAvaliable();
			
			obj.gridOrders.load({
				ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
				QueryName:"QryPathFormEpItemOrdAll",		
				aPathFormEpDr:curFormEpID,
				aPathFormEpItemDr:"",
				aHospID:HospID,
				aOrdDesc:"",
				aOrdGroupID:obj.curOrdGrpID
			});	
		}
	});
	
	//关联医嘱列表
	obj.gridOrders = $HUI.datagrid("#gridOrders",{
		fit: true,
		showGroup: true,
		groupField:'ItemDesc',
		checkOnSelect:false,
		view: groupview,
		groupFormatter:function(value, rows){
			if(value==undefined) return;
				return value + ' , 共( ' + rows.length + ' )项';
			},
		scrollbarSize: 0,
		checkOnSelect: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrdAll",
			aPathFormEpDr:curFormEpID,
			aPathFormEpItemDr:"",
			aHospID:HospID,
			aOrdDesc:"",
			aOrdGroupID:"",
			page:1,
			rows:99999
	    },
		columns:[[
			{field:'checkOrd',checkbox:true,hidden:true,align:'center',width:'',auto:false},
			{field:'OrdMastIDDesc',title:'医嘱名',width:'300'
				,formatter: function(value,row,index){
					var FormOrdID=row['xID']
					if (FormOrdID.indexOf("FJ")>-1) {
						var FJid=FormOrdID.split(':')[1];
						FormOrdID=FormOrdID.split(':')[2]+"||"+FormOrdID.split(':')[1];
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return value+chkPosDesc+"<label id= 'pop"+FJid+"' style='color:red;' onmouseover=obj.ShowFJDetail("+FJid+") onmouseout=obj.DestoryFJDetail("+FJid+")>[详细]</label>"
					}else{
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"' onclick=obj.ClickOrdDesc("+index+");>"+value+chkPosDesc+"</span>"
					}
				}
			},
			{field:'OrdLnkOrdDr',title:'关联号',width:'50'},
			{field:'OrdDoseQty',title:'单次剂量',width:'70'},
			{field:'OrdUOMIDDesc',title:'单位',width:'70'},
			{field:'OrdFreqIDDesc',title:'频次',width:'70'},
			{field:'OrdInstrucIDDesc',title:'用法',width:'70'},
			{field:'OrdDuratIDDesc',title:'疗程',width:'70'},
			{field:'OrdQty',title:'数量',width:'60'},
			{field:'OrdIsDefault',title:'首选医嘱',width:'70'},
			{field:'OrdIsFluInfu',title:'主医嘱',width:'70'},
			{field:'OrdTypeDrDesc',title:'分类标记',width:'70'},
			{field:'OrdPriorityIDDesc',title:'医嘱类型',width:'70'},
			{field:'OrdNote',title:'备注',width:'70'}
		]],
		onLoadSuccess:function(data){
			if(obj.ViewMode=="Edit"){
				if ((data.rows.length>0)&&(obj.curOrdGrpID!="")) {
	                $.each(data.rows, function (index, item) {
	                   if (item.OrdGroupID.split(",").indexOf(obj.curOrdGrpID)>-1) {
	                        $('#gridOrders').datagrid('checkRow', index);
	                    }
	                });
	            }
			}
		},
		onCheck: function(index, row){
			//处理关联医嘱同时勾选			
			if(obj.IsChecking) return;			
			var ordLinkNum=row['OrdLnkOrdDr'];
			var ItemDesc = row['ItemDesc'];
			if(ordLinkNum == "") return;
			obj.IsChecking=true;
			var Rows=$('#gridOrders').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				if((selData['OrdLnkOrdDr'] == ordLinkNum)&&(selData['ItemDesc']==ItemDesc)){	//相同关联号的医嘱同时操作
					$("#gridOrders").datagrid("selectRow", ind);
					$("#gridOrders").datagrid("checkRow", ind);
				}
			}
			obj.IsChecking=false;
		},
		onUncheck: function(index, row){
			//处理关联医嘱同时取消勾选
			if(obj.IsUnChecking) return;			
			var ordLinkNum=row['OrdLnkOrdDr'];
			var ItemDesc = row['ItemDesc'];
			if(ordLinkNum == "") return;
			obj.IsUnChecking=true;
			var Rows=$('#gridOrders').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				if((selData['OrdLnkOrdDr'] == ordLinkNum)&&(selData['ItemDesc']==ItemDesc)){	//相同关联号的医嘱同时操作
					$("#gridOrders").datagrid("unselectRow", ind);
					$("#gridOrders").datagrid("uncheckRow", ind);
				}
			}
			obj.IsUnChecking=false;
		}
	})
	
	
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}