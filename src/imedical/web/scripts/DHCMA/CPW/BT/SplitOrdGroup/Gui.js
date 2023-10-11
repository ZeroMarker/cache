//ҳ��Gui
var obj = new Object();
function InitHISUIWin(){
	$.parser.parse(); // ��������ҳ��
	obj.curOrdGrpID="";
	obj.ViewMode="View";
	obj.IsUnChecking=false;
	obj.IsChecking=false;	//��ֹ��ѭ��
	
	//��ť��ʼ��
	$('#winOrdGroupEdit').dialog({
		title: '������Ϣά��',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true
	});
	
	obj.cboOrdGroup = $HUI.combogrid('#cboOrdGroup', {
		url: $URL,
		editable: false,
		placeholder:'ȫ��ҽ��',
		idField: 'ID',
		textField: 'OrdGroupDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathOrdGroupSrv';
			param.QueryName = 'QryPathOrdGroup';
			param.aFormEpID = curFormEpID;
			param.ResultSetType = 'array';
		},
		columns:[[
			{field:'OrdGroupDesc',title:'����',width:80,sortable:true},    
        	{field:'OrdGroupNote',title:'��ע',width:150,sortable:true} 
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
	
	//����ҽ���б�
	obj.gridOrders = $HUI.datagrid("#gridOrders",{
		fit: true,
		showGroup: true,
		groupField:'ItemDesc',
		checkOnSelect:false,
		view: groupview,
		groupFormatter:function(value, rows){
			if(value==undefined) return;
				return value + ' , ��( ' + rows.length + ' )��';
			},
		scrollbarSize: 0,
		checkOnSelect: true,
		pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: false,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
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
			{field:'OrdMastIDDesc',title:'ҽ����',width:'300'
				,formatter: function(value,row,index){
					var FormOrdID=row['xID']
					if (FormOrdID.indexOf("FJ")>-1) {
						var FJid=FormOrdID.split(':')[1];
						FormOrdID=FormOrdID.split(':')[2]+"||"+FormOrdID.split(':')[1];
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return value+chkPosDesc+"<label id= 'pop"+FJid+"' style='color:red;' onmouseover=obj.ShowFJDetail("+FJid+") onmouseout=obj.DestoryFJDetail("+FJid+")>[��ϸ]</label>"
					}else{
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"' onclick=obj.ClickOrdDesc("+index+");>"+value+chkPosDesc+"</span>"
					}
				}
			},
			{field:'OrdLnkOrdDr',title:'������',width:'50'},
			{field:'OrdDoseQty',title:'���μ���',width:'70'},
			{field:'OrdUOMIDDesc',title:'��λ',width:'70'},
			{field:'OrdFreqIDDesc',title:'Ƶ��',width:'70'},
			{field:'OrdInstrucIDDesc',title:'�÷�',width:'70'},
			{field:'OrdDuratIDDesc',title:'�Ƴ�',width:'70'},
			{field:'OrdQty',title:'����',width:'60'},
			{field:'OrdIsDefault',title:'��ѡҽ��',width:'70'},
			{field:'OrdIsFluInfu',title:'��ҽ��',width:'70'},
			{field:'OrdTypeDrDesc',title:'������',width:'70'},
			{field:'OrdPriorityIDDesc',title:'ҽ������',width:'70'},
			{field:'OrdNote',title:'��ע',width:'70'}
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
			//�������ҽ��ͬʱ��ѡ			
			if(obj.IsChecking) return;			
			var ordLinkNum=row['OrdLnkOrdDr'];
			var ItemDesc = row['ItemDesc'];
			if(ordLinkNum == "") return;
			obj.IsChecking=true;
			var Rows=$('#gridOrders').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				if((selData['OrdLnkOrdDr'] == ordLinkNum)&&(selData['ItemDesc']==ItemDesc)){	//��ͬ�����ŵ�ҽ��ͬʱ����
					$("#gridOrders").datagrid("selectRow", ind);
					$("#gridOrders").datagrid("checkRow", ind);
				}
			}
			obj.IsChecking=false;
		},
		onUncheck: function(index, row){
			//�������ҽ��ͬʱȡ����ѡ
			if(obj.IsUnChecking) return;			
			var ordLinkNum=row['OrdLnkOrdDr'];
			var ItemDesc = row['ItemDesc'];
			if(ordLinkNum == "") return;
			obj.IsUnChecking=true;
			var Rows=$('#gridOrders').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				if((selData['OrdLnkOrdDr'] == ordLinkNum)&&(selData['ItemDesc']==ItemDesc)){	//��ͬ�����ŵ�ҽ��ͬʱ����
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