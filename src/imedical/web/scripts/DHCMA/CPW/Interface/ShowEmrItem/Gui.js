//页面Gui
function InitShowNurItemWin(){
	var obj = new Object();
	obj.PathwayID="";
    $.parser.parse(); // 解析整个页面
    
    // 获取路径信息
	var CPWInfo = $m({
		ClassName:"DHCMA.CPW.IO.ToEmrNur",
		MethodName:"GetPathInfoByAdm",
		aEpisodeID:EpisodeID
	},false);
	if (CPWInfo!=""){
		$("#layout1").show();
		$("#layout2").hide();
		obj.PathwayID = CPWInfo.split("^")[0];
		obj.PathName = CPWInfo.split("^")[1];
		obj.CurEpisID = CPWInfo.split("^")[2];
		obj.CurEpisDesc = CPWInfo.split("^")[3];
		obj.PathStatus = CPWInfo.split("^")[5];
		
		$("#pathName").text(obj.PathName);
		$("#pathStatus").text(obj.PathStatus);
		$("input[name='EpType'][value='C']").removeAttr("label");
		$("input[name='EpType'][value='C']").attr("label",$g("当前阶段")+"<span style='color:#F00'>["+obj.CurEpisDesc+"]</span>");
	}else{
		$("#layout1").hide();
		$("#layout2").show();
	}
    
    // 选择阶段
    obj.cboCPWEp = $HUI.combobox('#cboCPWEp', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'EpisID',
		textField: 'EpisDesc',
		hidden:"true",
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.CPS.EpisSrv';
			param.QueryName = 'QryEpis';
			param.aPathwayID = obj.PathwayID;
			param.ResultSetType = 'array'
		},
		defaultFilter:4,
		onSelect: function(data){
			obj.LoadGridEmrItem();	
		}
	});
	
	// 诊疗项目
	obj.gridEmrItem = $HUI.datagrid("#gridEmrItem",{
		fit: true,
		title: "主要诊疗工作",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		checkOnSelect:false,
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.CPS.ImplementSrv",
			QueryName:"QryCPWStepInfo",
			aPathwayID:obj.PathwayID,
			aEpisID:obj.CurEpisID,
			aType:"T"
	    },
		columns:[[
			{field:'Check',checkbox:'true',align:'center',width:'',auto:false},
			{field:'ID',title:'ID',width:'100',hidden:true},
			{field:'ItemInfo',title:'诊疗项目',width:'350'},
			{field:'IsRequired',title:'是否必选',width:'80',formatter:function(v,r,i){
				if (v=="1") return $g("是");
				else return $g("否");
			}},
			{field:'OperInfo',title:'执行信息',width:'350'}
		]],
		view:detailview,
	    detailFormatter:function(rowIndex,rowData){
			return rowData.Node;    
		},
		rowStyler: function(index,row){
			if (parseInt(row["IsImp"])>0){
				return 'color:#509DE1;'; 
			}else{
				return 'color:#000000;'; 
			}
		},
		onLoadSuccess: function(data){
			$("#gridEmrItem").datagrid("uncheckAll");
		}
	});
	
	InitPathTypeListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


