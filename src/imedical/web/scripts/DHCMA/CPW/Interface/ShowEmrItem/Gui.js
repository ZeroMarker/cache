//ҳ��Gui
function InitShowNurItemWin(){
	var obj = new Object();
	obj.PathwayID="";
    $.parser.parse(); // ��������ҳ��
    
    // ��ȡ·����Ϣ
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
		$("input[name='EpType'][value='C']").attr("label",$g("��ǰ�׶�")+"<span style='color:#F00'>["+obj.CurEpisDesc+"]</span>");
	}else{
		$("#layout1").hide();
		$("#layout2").show();
	}
    
    // ѡ��׶�
    obj.cboCPWEp = $HUI.combobox('#cboCPWEp', {              
		url: $URL,
		editable: true,
		//multiple:true,  //��ѡ
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
	
	// ������Ŀ
	obj.gridEmrItem = $HUI.datagrid("#gridEmrItem",{
		fit: true,
		title: "��Ҫ���ƹ���",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: false,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
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
			{field:'ItemInfo',title:'������Ŀ',width:'350'},
			{field:'IsRequired',title:'�Ƿ��ѡ',width:'80',formatter:function(v,r,i){
				if (v=="1") return $g("��");
				else return $g("��");
			}},
			{field:'OperInfo',title:'ִ����Ϣ',width:'350'}
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


