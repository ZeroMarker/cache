var objOrder = new Object();	
function ShowMakeOrderDialog(){
	$.parser.parse(); // ��������ҳ��
	objOrder.replaceIndex=-1;	//�滻���
	objOrder.IsHaveDown=[];
	objOrder.IsChecking=false;	//��ֹ��ѭ��
	objOrder.IsUnChecking=false;
	objOrder.OrdContent=[];
	objOrder.SelectedOrds={rows:[],total:999}
	objOrder.tempCplFormID=""
	objOrder.tempFormEpID="";
	objOrder.tempFormEpItemID="";
	objOrder.OrdGroupID="";
	objOrder.curTabTitle=$g("��·��");
	objOrder.ARCOSCheckFlg=false;
	objOrder.JsonARCOSDetail = {};
	objOrder.StatusCurrDesc = "";
	
	InitOCPWInfo();
	$('#OStepMore').on('click', function(){
		var Emvalue = $('#OStepMore').attr("value");
		ShowOSetpMore(Emvalue);
	});
	$('#Addorder').on('click', function(){
		AddOrderToEntry();
	});
	$('#GetHelp').on('click', function(){
		$HUI.dialog('#HelpCPWDialog').open();
	});
	$('#OrdDesc').searchbox({ 
		prompt:$g('������ؼ���'),
		searcher:function(value){
			if (objOrder.curTabTitle==$g("��·��")){ 
				$cm ({
					ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
					QueryName:"QryPathFormEpItemOrdAll",
					ResultSetType:"array",
					aPathFormEpDr:objOrder.tempFormEpID,
					aPathFormEpItemDr:objOrder.tempFormEpItemID,
					aOrdDesc:value,
					aOrdGroupID:objOrder.OrdGroupID,
					aUserType:UserType,
					aEpisodeID:EpisodeID,
					aLgnLocID:session['DHCMA.CTLOCID'],
					page:1,
					rows:99999
				},function(rs){
					$('#CPWItemOrder').datagrid({groupField:'ItemDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);				
				});
			}else{
				$cm ({
					ClassName:"DHCMA.CPW.CPS.PathwayComplSrv",
					QueryName:"QryComplFormOrdAll",
					ResultSetType:"array",
					aFormID:objOrder.tempCplFormID,
					aFormEpID:objOrder.tempFormEpID,
					aFormItemID:objOrder.tempFormEpItemID,
					aOrdDesc:value,
					aOrdGroupID:objOrder.OrdGroupID,
					aUserType:UserType,
					aEpisodeID:EpisodeID,
					aLgnLocID:session['DHCMA.CTLOCID'],
					page:1,
					rows:99999
				},function(rs){
					$('#CPWItemOrder').datagrid({groupField:'OrdBuzTypeDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);				
				});	
			}
		}
	}); 
	
	$('#GeneReplace').on('click', function(){
		var selData = $('#gridGeneOrder').datagrid('getSelected')
		$('#CPWItemOrder').datagrid('updateRow',{
			index: objOrder.replaceIndex,
			row: {
				OrdMastIDDesc: selData['ArcimDesc'],
				OrdDoseQty: selData['DoseQty'],
				OrdUOMIDDesc: selData['DoseUomDesc'],
				OrdFreqIDDesc: selData['FreqDesc'],
				OrdInstrucIDDesc: selData['InstrucDesc'],
				OrdDuratIDDesc: selData['DuratDesc'],
				OrdMastID:selData['ArcimID'],
				OrdUOMID:selData['DoseUomDR'],
				OrdFreqID:selData['FreqDR'],
				OrdDuratID:selData['DuratDR'],
				OrdInstrucID:selData['InstrucDR']
			}
		});
		$HUI.dialog('#GeneCPWDialog').close();
	})
	
	//ҽ��������������
	objOrder.cboOrdGroup = $HUI.combogrid('#cboOrdGroup', {
		url:$URL+"?ClassName=DHCMA.CPW.BTS.PathOrdGroupSrv&QueryName=QryPathOrdGroup&ResultSetType=array&aFormEpID="+objOrder.tempFormEpID,
		panelWidth:310,
		editable: false,
		placeholder:$g('ȫ��ҽ��'),
		idField: 'ID',
		textField: 'OrdGroupDesc',
		columns:[[
			{field:'OrdGroupDesc',title:'����',width:100,sortable:true},    
        	{field:'OrdGroupNote',title:'��ע',width:200,sortable:true} 
		]],
		onShowPanel: function () {
		   	$(this).combogrid('grid').datagrid("load",{
			   	ClassName:"DHCMA.CPW.BTS.PathOrdGroupSrv",
			   	QueryName:"QryPathOrdGroup",
			   	aFormEpID:objOrder.tempFormEpID
			});
		},
		onSelect:function(index,row){
			objOrder.OrdGroupID=row.ID;
			if (objOrder.curTabTitle==$g("��·��")){ 
				$cm ({
					ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
					QueryName:"QryPathFormEpItemOrdAll",
					ResultSetType:"array",
					aPathFormEpDr:objOrder.tempFormEpID,
					aPathFormEpItemDr:objOrder.tempFormEpItemID,
					aHospID:HospID,
					aOrdDesc:$('#OrdDesc').searchbox('getValue'),
					aOrdGroupID:objOrder.OrdGroupID,
					aUserType:UserType,
					aEpisodeID:EpisodeID,
					aLgnLocID:session['DHCMA.CTLOCID'],
					page:1,
					rows:99999
				},function(rs){
					$('#CPWItemOrder').datagrid({groupField:'ItemDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);				
				});
			}else{
				$cm ({
					ClassName:"DHCMA.CPW.CPS.PathwayComplSrv",
					QueryName:"QryComplFormOrdAll",
					ResultSetType:"array",
					aFormID:objOrder.tempCplFormID,
					aFormEpID:objOrder.tempFormEpID,
					aFormItemID:objOrder.tempFormEpItemID,
					aHospID:HospID,
					aOrdDesc:$('#OrdDesc').searchbox('getValue'),
					aOrdGroupID:objOrder.OrdGroupID,
					aUserType:UserType,
					aEpisodeID:EpisodeID,
					aLgnLocID:session['DHCMA.CTLOCID'],
					page:1,
					rows:99999
				},function(rs){
					$('#CPWItemOrder').datagrid({groupField:'OrdBuzTypeDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);				
				});	
			}
		}
	});
	
	//����ҽ���б�
	objOrder.CPWItemOrder = $HUI.datagrid("#CPWItemOrder",{
		fit: true,
		showGroup: true,
		checkOnSelect:false,
		view: groupview,
		groupFormatter:function(value, rows){
			if(value==undefined) return;
			return value + $g(' , ��( ') + rows.length + $g(' )��');
			},
		scrollbarSize: 0,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: false,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:$g('���ݼ�����...'),
		pageSize: 50,
		pageList : [50,100,200],
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:'',auto:false},
			//{field:'OrdGeneIDDesc',title:'ͨ����',width:'150'},
			{field:'OrdMastIDDesc',title:'ҽ����',width:'300',
				formatter: function(value,row,index){
					var FormOrdID=row['xID']
					if (FormOrdID.indexOf("FJ")>-1) {
						var FJid=FormOrdID.split(':')[1];
						FormOrdID=FormOrdID.split(':')[2]+"||"+FormOrdID.split(':')[1];
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"'>"+value+chkPosDesc+"</span><label id= 'pop"+FJid+"' style='color:red;' onmouseover=ShowFJDetail("+FJid+") onmouseout=DestoryFJDetail("+FJid+")>["+$g("��ϸ")+"]</label>"
					}else if(row['OrdMastID'].indexOf("||")==-1){
						var ARCOSRowid=row['OrdMastID'];
						var ARCOSDesc=row['OrdMastIDDesc'];
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"'>"+value+chkPosDesc+"</span><label style='color:red;cursor:pointer' onclick=ShowARCOSDetail("+ARCOSRowid+",'"+ARCOSDesc+"',"+index+")>["+$g("��ϸ")+"]</label>"
					}else{
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"'>"+value+" "+chkPosDesc+"</span>"
					}
					/*
					var id=row['xID'].split("||").join("-")
					var chkPosDesc=row['OrdChkPosID'].split("||")[0]
					return "<span id='"+id+"'>"+value+chkPosDesc+"</span>"
					*/
				}
			},
			{field:'OrdLnkOrdDr',title:'������',width:'50'},
			{field:'OrdDoseQty',title:'���μ���',width:'70'},
			{field:'OrdUOMIDDesc',title:'��λ',width:'70'},
			{field:'OrdFreqIDDesc',title:'Ƶ��',width:'70'},
			{field:'OrdInstrucIDDesc',title:'�÷�',width:'70'},
			{field:'OrdDuratIDDesc',title:'�Ƴ�',width:'70'},
			{field:'OrdQty',title:'����',width:'60'},
			{field:'OrdQtyUomDesc',title:'������λ',width:'70'},
			{field:'OrdIncilQty',title:'���',width:'100'},
			{field:'OrdIsDefault',title:'��ѡҽ��',width:'70',formatter:function(v,r,i){
				if (v == "1") return $g('��');
				else return $g('��');
			}},
			{field:'OrdIsFluInfu',title:'��ҽ��',width:'70',formatter:function(v,r,i){
				if (v == "1") return $g('��');
				else return $g('��');
			}},
			{field:'OrdTypeDrDesc',title:'������',width:'70'},
			{field:'OrdPriorityIDDesc',title:'ҽ������',width:'70'},
			{field:'OrdNote',title:'��ע',width:'70'}
		]],
		onBeforeLoad: function (param) {
			objOrder.IsHaveDown=[];
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
			
            return true;
		},
		onLoadSuccess: function (data) {
			if (data.rows.length > 0) {
				for (var i = 0; i < data.rows.length; i++) {
					data.rows[i].tabType=objOrder.curTabTitle;					//Ϊ��ѡ�ж������tab�������֣������������
					if(data.rows[i].OrdCatCode != OrderType){
						// ���Ͳ�һ����Ϊ������
						$("input[type='checkbox']")[i+1].disabled = true;
						
						//ֱ�ӹ��˸������ݲ���ʾ
						//$("#CPWItemOrder").datagrid("deleteRow", i);
						//i=i-1;
					} else {
						if (data.rows[i].OrdIsDefault=="1") {	//��ѡҽ��
							if(objOrder.IsHaveDown[data.rows[i].xID]==5){	//δִ��
								$("#CPWItemOrder").datagrid("selectRow", i);
								$("#CPWItemOrder").datagrid("checkRow", i);
							}
						}
					}
					if (objOrder.SelectedOrds.rows.length>0){
						//���ҽ���Ƿ�����ѱ���ѡ�б����ڹ�ѡѡ��� add by yankai20201208
						$.each(objOrder.SelectedOrds.rows, function(index, item){
   							if (data.rows[i].xID==item.xID){
								$("#CPWItemOrder").datagrid("checkRow", i);	
	   						}
						});
					}
				}
			}
        },
		onDblClickRow: function(index, row){
			if(row.OrdCatCode != OrderType){
				$.messager.popover({msg: $g('��ǰ�����ֹ������ҽ����'),type:'alert'});	
				return false;
			}
			if(row['xID'].indexOf("FJ")>-1){
				$.messager.popover({msg: $g('�Զ��巽����֧�ִ˲�����'),type:'alert'});	
				return false;	
			}
			objOrder.replaceIndex=index;
			var selData = $('#CPWItemOrder').datagrid('getRows')[index];
			var ArcimID=selData['OrdMastID']
			var OrdMastIDDesc=selData['OrdMastIDDesc']
			$('#gridGeneOrder').datagrid('loadData',{rows:[],total:0});
			$cm({
				ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
				QueryName:"QryOrderListByGene",
				aEpisodeID:EpisodeID.split("!!")[0],
				aArcimID:ArcimID,
				aHospID:session['DHCMA.HOSPID']
			},function(rs){
				$('#gridGeneOrder').datagrid({'title':$g('��ǰҽ����')+OrdMastIDDesc});
				$('#gridGeneOrder').datagrid('loadData',rs);
				$HUI.dialog('#GeneCPWDialog').open();	
			})
			/*
			$('#gridGeneOrder').datagrid({'title':'��ǰҽ����'+OrdMastIDDesc});	
			objOrder.gridGeneOrder.load({
				ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
				QueryName:"QryOrderListByGene",
				aEpisodeID:EpisodeID.split("!!")[0],
				aArcimID:ArcimID
			});
			//$HUI.dialog('#GeneCPWDialog').open();
			*/
		},
		onClickCell: function(index,field,value){
			if(field=="OrdMastIDDesc"){
				var selData = $('#CPWItemOrder').datagrid('getRows')[index];
				var FormOrdID=selData['xID'];
				if (FormOrdID.indexOf("FJ")>-1) FormOrdID=FormOrdID.split(':')[2]+"||"+FormOrdID.split(':')[1];
				var id=FormOrdID.split("||").join("-");
				if(objOrder.OrdContent[id]==undefined) return;
				$('#'+id).parent().popover({
					content:objOrder.OrdContent[id]
				});
				
				$("#"+id).parent().popover('show');
				$("#"+id).parent().mouseout(function(){
					$("#"+id).parent().popover('hide');
				 })
			}else{
				var selData = $('#CPWItemOrder').datagrid('getRows')[index];
				var FormOrdID=selData['xID']
				var id=FormOrdID.split("||").join("-")
				//$("#"+id).popover('hide');
			}
		},
		onCheckAll: function(rows){
			//ȫѡǰ�������ѡҽ���б��е�ǰѡ���µ�ҽ��
			for (var i = 0; i < objOrder.SelectedOrds.rows.length; i++) {			
   				if(objOrder.SelectedOrds.rows[i].tabType==objOrder.curTabTitle){
	   				objOrder.SelectedOrds.rows.splice(i,1);
	   				i=i-1;
	   			}	
			}
			
			//����Ƿ�չ������
			var e_width=$("#cc").layout("panel", "east")[0].clientWidth;
			if (e_width==0) $('#cc').layout('expand','east');
			
			for (var i=0;i<rows.length;i++){
				//����ҽ���Ͳ�ƥ���ȡ����ѡ
				if(rows[i].OrdCatCode != OrderType){
					$("#CPWItemOrder").datagrid("uncheckRow", i);
				}
				
				if (objOrder.SelectedOrds.rows.length>0){
					//��ѡҽ���б����Ѵ��ڵ�ҽ��ȡ����ѡ
					$.each(objOrder.SelectedOrds.rows, function(j, jtem){ 
   						if(jtem.OrdMastID==rows[i].OrdMastID) {
	   						$("#CPWItemOrder").datagrid("uncheckRow", i);
	   					}
					});	
				}		
			}
			
			var checkboxHeader = $('div.datagrid-header-check input[type=checkbox]');//ȡ��ȫѡȫ��ѡ���Ԫ��
			checkboxHeader.prop("checked","checked");//��������Ϊchecked����
			
			//��ѡҽ��������ѡҽ��������
			var index=objOrder.SelectedOrds.rows.length;
			$.each(rows,function(i,item){
				if(item.OrdCatCode == OrderType){
					var chkExist=0;
					$.each(objOrder.SelectedOrds.rows, function(j, jtem){
						if(item.OrdMastID==jtem.OrdMastID) {chkExist=1;}
					})
					if (!chkExist) {
						objOrder.SelectedOrds.rows[index]=item;
						index++;
					}
						
				}
			})
						
			objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);
		},
		onUncheckAll:function(rows){
			//�����ѡҽ���б��е�ǰѡ���µ�ҽ��
			for (var i = 0; i < objOrder.SelectedOrds.rows.length; i++) {			
   				if(objOrder.SelectedOrds.rows[i].tabType==objOrder.curTabTitle){
	   				objOrder.SelectedOrds.rows.splice(i,1);
	   				i=i-1;
	   			}	
			}
			
			//�����ѡҽ���б�
			objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);
		},
		onCheck: function(index, row){
			
			if (row.tabType==undefined) row.tabType=objOrder.curTabTitle;
			
			/*	//��ѡ�ظ������ҽ��վ���ڸü�飬����ʱע�͵�
			var isExist=-1;	
			$.each(objOrder.SelectedOrds.rows, function(i, item){       				
   				if(item.OrdMastID==row['OrdMastID']){
	   				if (item.xID!=row.xID) isExist=1; 		//�ж��Ƿ���ڸ�ֵ
	   				else isExist=0;
	   			}
			});
			if (isExist==-1){
				objOrder.SelectedOrds.rows[rowsLen]=row;
				var e_width=$("#cc").layout("panel", "east")[0].clientWidth;
				if (e_width==0) $('#cc').layout('expand','east');
				objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);
			}else if(isExist==1){
				$.messager.confirm("��ʾ", "��ѡ�б��Ѵ��ڸ�ҽ�����Ƿ���Ȼ��ѡ��", function (r) {
					if (r){
						objOrder.SelectedOrds.rows[rowsLen]=row;
						var e_width=$("#cc").layout("panel", "east")[0].clientWidth;
						if (e_width==0) $('#cc').layout('expand','east');
						objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);
					}else{
						$("#CPWItemOrder").datagrid("uncheckRow", index);
						return;	
					}
				})			
			}else{
				//���账��		
			}
			*/
			
			
			var isExist=-1;	
			$.each(objOrder.SelectedOrds.rows, function(i, item){       				
   				if(item.OrdMastID==row['OrdMastID']){
	   				if (item.xID!=row.xID) isExist=0; 		//�ж��Ƿ���ڸ�ֵ
	   				else isExist=1;
	   			}
			});
			if (isExist<1){
				//��ѡҽ����ӵ���ѡҽ���б�
				var rowsLen=objOrder.SelectedOrds.rows.length;
				objOrder.SelectedOrds.rows[rowsLen]=row;
				var e_width=$("#cc").layout("panel", "east")[0].clientWidth;
				if (e_width==0) $('#cc').layout('expand','east');
				objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);	
			}

			//�������ҽ��ͬʱ��ѡ			
			if(objOrder.IsChecking) return;			
			var ordLinkNum=row['OrdLnkOrdDr'];
			var ItemDesc = row['ItemDesc'];
			if(ordLinkNum == "") return;
			objOrder.IsChecking=true;
			var Rows=$('#CPWItemOrder').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				
				if((Math.floor(selData['OrdLnkOrdDr']) == Math.floor(ordLinkNum))&&(selData['ItemDesc']==ItemDesc)){	//����λ��ͬ��Ϊ����ҽ��������ͬʱ����
					$("#CPWItemOrder").datagrid("selectRow", ind);
					$("#CPWItemOrder").datagrid("checkRow", ind);
				}
			}
			objOrder.IsChecking=false;
		},
		onUncheck: function(index, row){
			//��ȡ����ѡҽ������ѡҽ���б��Ƴ�								
			$.each(objOrder.SelectedOrds.rows, function(idx, item){
   				if (item.xID==row['xID']){
	   				objOrder.SelectedOrds.rows.splice(idx,1);
	   				return false;
	   			}
			});
			objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);
			
			//�������ҽ��ͬʱȡ����ѡ
			if(objOrder.IsUnChecking) return;			
			var ordLinkNum=row['OrdLnkOrdDr'];
			var ItemDesc = row['ItemDesc'];
			if(ordLinkNum == "") return;
			objOrder.IsUnChecking=true;
			var Rows=$('#CPWItemOrder').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				if((Math.floor(selData['OrdLnkOrdDr']) == Math.floor(ordLinkNum))&&(selData['ItemDesc']==ItemDesc)){	//����λ��ͬ��Ϊ����ҽ��������ͬʱ����
					$("#CPWItemOrder").datagrid("unselectRow", ind);
					$("#CPWItemOrder").datagrid("uncheckRow", ind);
				}
			}
			objOrder.IsUnChecking=false;
		},
		rowStyler: function(index,row){			
			//δ֪ԭ���Զ���������
			//�ô˷�������ֻ����һ��
			if(objOrder.IsHaveDown[row['xID']]>1) return
			objOrder.IsHaveDown[row['xID']]=2;
				
			var FormOrdID=row['xID']
			var ret=$m({ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
				MethodName:"GetImpOrdInfo",
				aCPWID:objOrder.PathwayID,
				aEpisID:objOrder.StepSelecedID,
				aFormOrdID:FormOrdID
			},false);
			if(ret!=""){
				if (FormOrdID.indexOf("FJ")>-1) FormOrdID=FormOrdID.split(':')[2]+"||"+FormOrdID.split(':')[1]	
				var id=FormOrdID.split("||").join("-")
				var content=ret.split("^")[1]
				objOrder.OrdContent[id]=content;
				if (ret.split("^")[0]==1){
					objOrder.IsHaveDown[row['xID']]=3;
					return 'color:#509DE1;'; 	//ԭҽ��
				}else{
					objOrder.IsHaveDown[row['xID']]=4;
					return 'color:#FD994A;'; 	//�滻ҽ��
				}
			}else{
				objOrder.IsHaveDown[row['xID']]=5;
				return 'color:#000000;'; 		//δִ��
			}
		}
	});
	
	// ��ѡҽ���б�
	objOrder.gridSelectedOrds = $HUI.datagrid("#gridSelectedOrds",{
		fit: true,
		iconCls:"icon-paper",
		//title:$g('��ѡҽ��')+"<span title=\'�۵�\' style=\'float:right;cursor:pointer\' onclick=\"$('#cc').layout('collapse','east');\" class=\'icon-triangle-green-right\'>&nbsp;</span>",
		headerCls:'panel-header-gray',
		//pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:$g('���ݼ�����...'),
		//pageSize: 10,
		//pageList : [10,20,50,100,200],
	    //url:$URL,
	    queryParams:{
		    //ClassName:"DHCMA.CPW.BTS.PathTCMSrv",
			//QueryName:"QryPathTCM"
	    },
		columns:[[
			{field:'OrdMastIDDesc',title:'����',width:'200'},
			{field:'tabType',title:'��Դ',width:'60'}
		]],
		data:objOrder.SelectedOrds,
		onDblClickRow: function(index, row){
			var ordLinkNum=row['OrdLnkOrdDr'];						//��ȡ������
			var ordsRows=$('#CPWItemOrder').datagrid('getRows');
			
			if (ordLinkNum!=""){
				// ɾ����ǰ��ѡҽ���б�
				$.each(objOrder.SelectedOrds.rows, function(idx, item){
					if (idx==objOrder.SelectedOrds.rows.length) return false;
	   				if (item.OrdLnkOrdDr==ordLinkNum){
		   				objOrder.SelectedOrds.rows.splice(idx,1);
		   			}
				});
				objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);		//���¼���
				
				// ɾ���׶�ҽ���б�
				$.each(ordsRows, function(index, item){ 
   					if (item.OrdLnkOrdDr==ordLinkNum){
						$("#CPWItemOrder").datagrid("uncheckRow", index);	
	   				}
				});					
			}else{
				$(this).datagrid("deleteRow",index);
				// ɾ���׶�ҽ���б�
				$.each(ordsRows, function(index, item){ 
   					if (ordsRows[index].xID==row.xID){
						$("#CPWItemOrder").datagrid("uncheckRow", index);	
	   				}
				});				
			}
			
				
		}
	})
	
	//ͬͨ����ҽ���б�
  	objOrder.gridGeneOrder = $HUI.datagrid("#gridGeneOrder",{
		fit: true,
		pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:$g('���ݼ�����...'),
		/*
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryOrderListByGene",
			aEpisodeID:"",
			aArcimID:""
	    },
	    */    
		columns:[[
			{field:'ArcimDesc',title:'ҽ������',width:'300'},
			{field:'DoseQty',title:'���μ���',width:'80'},
			{field:'FreqDesc',title:'Ƶ��',width:'80'},
			{field:'DuratDesc',title:'�Ƴ�',width:'80'},
			{field:'InstrucDesc',title:'�÷�',width:'80'},
			{field:'DoseUomDesc',title:'��λ',width:'80'}
		]],
		onBeforeLoad: function (param) {
	        var firstLoad = $(this).attr("firstLoad");
	        if (firstLoad == "false" || typeof (firstLoad) == "undefined")
	        {
	            $(this).attr("firstLoad","true");
	            return false;
	        }
			
	        return true;
		}
	});
	//ҽ����ҽ���б�
  	objOrder.gridARCOSOrder = $HUI.datagrid("#gridARCOSOrder",{
		fit: true,
		pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���
		selectOnCheck:false,
		singleSelect: false,
		remoteSort:false,
		sortName:"SeqNo",
		sortOrder:"asc",
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:$g('���ݼ�����...'),   
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:'',auto:false},
			{field:'ARCIMDesc',title:'ҽ������',width:'300'},
			{field:'DoseQty',title:'���μ���',width:'80'},
			{field:'DoseUOMDesc',title:'������λ',width:'80'},
			{field:'FreqDesc',title:'Ƶ��',width:'80'},
			{field:'InstrDesc',title:'�÷�',width:'80'},
			{field:'DurDesc',title:'�Ƴ�',width:'80'},
			{field:'SeqNo',title:'���',width:'80'}			
		]],
		onBeforeLoad: function (param) {
	        var firstLoad = $(this).attr("firstLoad");
	        if (firstLoad == "false" || typeof (firstLoad) == "undefined")
	        {
	            $(this).attr("firstLoad","true");
	            return false;
	        }
			
	        return true;
		},
		onCheck: function(index, row){
			if(objOrder.ARCOSCheckFlg) return;
			
			if(row['SeqNo']=="") return;
			var MastSeqNo=Math.floor(row['SeqNo']);
			var rowsArr=$(this).datagrid('getData').rows;		//����������
			objOrder.ARCOSCheckFlg=true;
			for (var ind=0;ind<rowsArr.length;ind++){
				if(ind == index) continue;
				if(rowsArr[ind].SeqNo=="") continue;
				var curRowSeqNo=rowsArr[ind].SeqNo;
				if(MastSeqNo==Math.floor(curRowSeqNo)){			//�����������λ��ͬͬʱ����
					//$(this).datagrid("selectRow", ind);
					$(this).datagrid("checkRow", ind);
					
				}
			}
			objOrder.ARCOSCheckFlg=false;
		},
		onUncheck: function(index, row){
			if(objOrder.ARCOSCheckFlg) return;
			
			if(row['SeqNo']=="") return;
			var MastSeqNo=Math.floor(row['SeqNo']);
			var rowsArr=$(this).datagrid('getData').rows;		//����������
			objOrder.ARCOSCheckFlg=true;
			for (var ind=0;ind<rowsArr.length;ind++){
				if(ind == index) continue;
				if(rowsArr[ind].SeqNo=="") continue;
				var curRowSeqNo=rowsArr[ind].SeqNo;
				if(MastSeqNo==Math.floor(curRowSeqNo)){			//�����������λ��ͬͬʱ����
					$(this).datagrid("uncheckRow", ind);
				}
			}
			objOrder.ARCOSCheckFlg=false;		
		},
		rowStyler: function(index,row){
			var SeqNo=row.SeqNo;
			if (SeqNo=="") return;
			if (SeqNo.indexOf(".")>-1) return 'background-color:#cdf1cd;';
			else return 'background-color:#94e494;';						
		}
	});
	
	//����ҽ��ѡ��ȷ���¼�
	$('#CheckOrder').on('click', function(){
		var ARCOSID = $("#ARCOSCPWDialog").dialog('options').inParam;	//��ǰҽ����ID
		
		var rows = $('#gridARCOSOrder').datagrid('getChecked');
		var ARCIMIDArr=[];
		for (var i=0,len=rows.length;i<len;i++){
			var ARCIMRowid=rows[i]['ARCIMRowid'];
			var SeqNo=rows[i]['SeqNo'];
			var RowIndex = $("#gridARCOSOrder").datagrid('getRowIndex',rows[i]);
			ARCIMIDArr.push(ARCIMRowid+"*"+SeqNo+"*"+RowIndex);
		}
		objOrder.JsonARCOSDetail[ARCOSID] = ARCIMIDArr			// ��ϸ���ݴ��ҳ�������
		
		ARCIMIDStr=ARCIMIDArr.join("^");
		var ret=$m({
			ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
			MethodName:"SaveARCOSItems",
			aEpisodeID:EpisodeID.split("!!")[0],
			aARCIMRowids:ARCIMIDStr,
			aARCOSID:ARCOSID
		},false);
		$HUI.dialog('#ARCOSCPWDialog').close();
	})
	
	//ҽ����������ð�ť�¼�
	$("#reSetGroup").on('click', function(){
		objOrder.cboOrdGroup.clear();
		objOrder.OrdGroupID="";
		if (objOrder.curTabTitle==$g("��·��")){ 
			$cm ({
				ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
				QueryName:"QryPathFormEpItemOrdAll",
				ResultSetType:"array",
				aPathFormEpDr:objOrder.tempFormEpID,
				aPathFormEpItemDr:objOrder.tempFormEpItemID,
				aHospID:HospID,
				aOrdDesc:$('#OrdDesc').searchbox('getValue'),
				aOrdGroupID:objOrder.OrdGroupID,
				aUserType:UserType,
				aEpisodeID:EpisodeID,
				aLgnLocID:session['DHCMA.CTLOCID'],
				page:1,
				rows:99999
			},function(rs){
				$('#CPWItemOrder').datagrid({groupField:'ItemDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);			
			});	
		}else{
			$cm ({
				ClassName:"DHCMA.CPW.CPS.PathwayComplSrv",
				QueryName:"QryComplFormOrdAll",
				ResultSetType:"array",
				aFormID:objOrder.tempCplFormID,
				aFormEpID:objOrder.tempFormEpID,
				aFormItemID:objOrder.tempFormEpItemID,
				aHospID:HospID,
				aOrdDesc:$('#OrdDesc').searchbox('getValue'),
				aOrdGroupID:objOrder.OrdGroupID,
				aUserType:UserType,
				aEpisodeID:EpisodeID,
				aLgnLocID:session['DHCMA.CTLOCID'],
				page:1,
				rows:99999
			},function(rs){
				$('#CPWItemOrder').datagrid({groupField:'OrdBuzTypeDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);			
			});		
		}
		
	})
	
	// ��·��/�ϲ�֢ҳǩ�л�
	objOrder.tabItemTree =$HUI.tabs("#tabItemTree",{
		onSelect:function(title){
			objOrder.curTabTitle=title;
			switch (title) {
				case $g("��·��"):					
					objOrder.cboOrdGroup.clear();
					objOrder.OrdGroupID="";
					//objOrder.tempCplFormID="";
					objOrder.tempFormEpID="";
					objOrder.tempFormEpItemID="";
					$("#OrdDesc").searchbox("clear");
					$("#panelOrdDtl").panel("setTitle",$g("��·��ҽ��"));
					ShowStepDetail("OStep-"+objOrder.StepSelecedID);
					break;
				case $g("�ϲ�֢"):
					objOrder.cboOrdGroup.clear();
					objOrder.OrdGroupID="";
					//objOrder.tempCplFormID="";
					objOrder.tempFormEpID="";
					objOrder.tempFormEpItemID="";
					$("#OrdDesc").searchbox("clear");
					$("#panelOrdDtl").panel("setTitle",$g("�ϲ�֢ҽ��"));
					$('#CPWItemOrder').datagrid({loadFilter:pagerFilter}).datagrid('loadData',{total:0,rows:[]});
					SeletctComplTab();
					break;
			}					
		}
	});
}

AddOrderToEntry = function(){
	var rows = $('#gridSelectedOrds').datagrid("getRows");
	if(rows.length==0) {
		$.messager.popover({msg: $g('δ��ѡ�κ�ҽ����'),type:'alert'});	 
		return;
	}
	// ��ȡѡ���ҽ�����ҽ������
	var cntAcrItm = 0, cntArcCos = 0;
	rows.forEach(function (row) {
		if (row.OrdMastID.indexOf('||') == -1) {
			cntArcCos ++;
		} else {
			cntAcrItm ++;
		}
	})
	$.messager.confirm($g("���"), $g("��")+cntAcrItm+$g("��ҽ���")+cntArcCos+$g("��ҽ����<br>ȷ��Ҫ�����"), function (r) {
		if (r) {
			var groups = [];
			var group =""
			rows.forEach(function (row) {
				if(row['OrdLnkOrdDr']!=""){
					//���Ӱ���Ŀ���ֹ����ţ�����ͬ��Ŀά����ͬ�Ĺ����Ż�ȫ��������һ��
					var ItemID=row['ItemID']
					var ItemChild=ItemID.split('||')[2]
					var LnkNum=row['OrdLnkOrdDr']
					var LnkGroup=ItemChild+LnkNum
					group = JSON.stringify(parseInt(LnkGroup))+1
					groups[group] = groups[group] || []
					groups[group].push(row)
				}else{
					group=0
					groups[group] = groups[group] || []
					groups[group].push(row)
				}
			})
			
			var strOrderList = '';
			for (var ind=0,len=groups.length ;ind<len ;ind++){
				if(groups[ind]){
					var strOrder=""
					for(var i=0,l=groups[ind].length ;i<l ;i++){
						if (groups[ind][i].OrdMastID.indexOf('||') == -1) {
							// ��ǰΪҽ���ף�ֻ��Ҫ��OrdMastID����
							strOrder  = "^ordid^^^^^^^^".replace("ordid", groups[ind][i].OrdMastID);
							strOrder += '^' + "."+i + '^^';
						}
						else {
							// ��ǰΪҽ���ֱ��ƴ��
							strOrder  = groups[ind][i].OrdGeneID;				//ͨ����ID
							strOrder += '^' + groups[ind][i].OrdMastID;
							strOrder += '^' + groups[ind][i].OrdPriorityID;
							strOrder += '^' + groups[ind][i].OrdQty;
							strOrder += '^' + groups[ind][i].OrdDoseQty;
							strOrder += '^' + groups[ind][i].OrdUOMID;
							strOrder += '^' + groups[ind][i].OrdFreqID;
							strOrder += '^' + groups[ind][i].OrdDuratID;
							strOrder += '^' + groups[ind][i].OrdInstrucID;
							strOrder += '^' + groups[ind][i].OrdNote;
							strOrder += '^' + ind+"."+i;
							var posStr=groups[ind][i].OrdChkPosID
							if(posStr!=""){
								strOrder += '^' + posStr.split("||")[1];			// ��鲿λ
							}else{ strOrder += '^'}
							strOrder += '^' + groups[ind][i].IsDefSensitive; 		// Ĭ�ϼӼ�
						}
						strOrderList +=  CHR_1 + strOrder;
					}
				}
			}

			if(strOrderList!=""){
				//��ҽ����ӵ��б�
				websys_showModal('options').addOEORIByCPW(strOrderList)
				websys_showModal('close');
			}
		} else {
			return;
		}
	});
}

//·����Ϣ
InitOCPWInfo = function(){
	$m({
		ClassName:"DHCMA.CPW.CPS.ImplementSrv",
		MethodName:"GetCPWInfo",
		aEpisodeID:EpisodeID
	},function(JsonStr){
		var JsonObj=$.parseJSON( JsonStr ); 
		
		objOrder.CPWCurrDesc=JsonObj.CPWDesc;		//��ǰ��������
		objOrder.StatusCurrDesc=JsonObj.CPWStatus;	//��ǰ·��״̬
		objOrder.PathFormID=JsonObj.PathFormID		//��ǰ·���ı�ID
		objOrder.PathwayID=JsonObj.PathwayID			//���뾶��¼ID
		
		$('#OCPWDesc').text(JsonObj.CPWDesc)
		$('#OCPWStatus').text(JsonObj.CPWStatus)
		$('#OCPWUser').text(JsonObj.CPWUser)
		$('#OCPWTime').text(JsonObj.CPWTime)
		//$('#CPWIcon').text(JsonObj.CPWIcon)
		var htmlIcon=""
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-D">'+$g('��')+'</span>'
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-B">'+$g('��')+'</span>'
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-T">T</span>'
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-Y">��</span>'
		$('#OCPWIcon').html(htmlIcon)
		$(".OIcon-D").popover({
			content: $g('��������Ϣ��') + JsonObj.SDDesc
		});
		$(".OIcon-B").popover({
			content: JsonObj.VarDesc
		});
		$(".OIcon-T").popover({
			content: $g('�뾶������') + JsonObj.CPWDays + $g('��<br />�ƻ�������') + JsonObj.FormDays + $g('��')
		});
		$(".OIcon-Y").popover({
			content: $g('סԺ�ܷ��ã�') + JsonObj.PatCost + $g('<br />�ƻ����ã�') + JsonObj.FormCost + $g('Ԫ')
		});
		
		InitOCPWSteps();
	});
}

//·������
InitOCPWSteps = function(){
	$m({
		ClassName:"DHCMA.CPW.CPS.ImplementSrv",
		MethodName:"GetCPWSteps",
		aPathwayID:objOrder.PathwayID
	},function(StepsStr){
		var StepsArr=StepsStr.split("#");
		var StepCurr=StepsArr[0];
		if (StepCurr=="") return;
		
		objOrder.StepCurrID=StepCurr.split(":")[0];			//�Ѿ�ִ�е���ǰ�����ID
		objOrder.StepList=StepsArr[1].split("^");			//��·�����в�������
		objOrder.TimeList=StepsArr[2].split("^");			//��·�����в�����ֹʱ�����飬EpDays*SttDateTime*EndDateTime
		objOrder.ConfList=StepsArr[3].split("^");			//��·�����в����Ƿ�ȷ�����飬1��0
		objOrder.SignList=StepsArr[4].split("^");			//��·�����в���ǩ����Ϣ���飬SignDoc:SignNur:SignDocDate:SignNurDate
		objOrder.StepSelecedID=objOrder.StepCurrID;				//���ѡ�еĲ���ID
		objOrder.CurrIndex=objOrder.StepList.indexOf(StepCurr);	//�Ѿ�ִ�е���ǰ������±�
		
		//չ�ֲ���
		ShowCPWSteps(objOrder.CurrIndex);
		//չ�ֲ�������
		SelectStep("OStep-"+objOrder.StepCurrID);
	});	
	
}

//չ�ֲ���
ShowCPWSteps = function(selectIndex){
	var StepSelect=objOrder.TimeList[selectIndex].split("*");
	$('#OStepTime').text(StepSelect[0]);
	$('#ODateFrom').datetimebox('setValue',StepSelect[1]);
	$('#ODateTo').datetimebox('setValue',StepSelect[2]);
	
	var StepShow=new Array();	//��ʾ�����Ĳ���
	var StepMore=new Array();	//����Ĳ���
	
	for(var ind = 0,len=objOrder.StepList.length;ind < len; ind++){
		if(selectIndex<3){
			if(ind<5){
				StepShow.push(objOrder.StepList[ind]);
			}else{
				StepMore.push(objOrder.StepList[ind]);
			}
		}else if(selectIndex>(len-3)){
			if(ind>len-6){
				StepShow.push(objOrder.StepList[ind]);
			}else{
				StepMore.push(objOrder.StepList[ind]);
			}
		} else {
			if((ind<(selectIndex-2)) || (ind>(selectIndex+2))) {
				StepMore.push(objOrder.StepList[ind]);
			} else {
				StepShow.push(objOrder.StepList[ind]);
			}
		}
	}
	
	var StepClass="";
	var StepShowHtml="";
	for(var ind = 0,len = StepShow.length; ind < len; ind++){
		var StepIndex=objOrder.StepList.indexOf(StepShow[ind]);
		if(StepIndex<objOrder.CurrIndex){
			StepClass="Ostep Osteppre";	//��ִ��
		}else if(StepIndex>objOrder.CurrIndex){
			StepClass="Ostep Ostepaft";	//δִ��
		}else{
			StepClass="Ostep Ostepcurr";	//��ǰ����
		}
		var tmpStep=StepShow[ind].split(":");
		if(GetLength(tmpStep[1])<=13) StepClass=StepClass+" Ostepshort";
		StepShowHtml=StepShowHtml+"<div id='OStep-"+tmpStep[0]+"' class='"+StepClass+"'>"+tmpStep[1]+"</div>"
		if(ind != len-1) {
			StepShowHtml=StepShowHtml+"<div class='Ostepline'></div>"
		}
	}
	$('#OStepShow').html(StepShowHtml);
	
	var StepClass="";
	var StepMoreHtml="";
	for(var ind = 0,len =StepMore.length; ind < len; ind++){
		var StepIndex=objOrder.StepList.indexOf(StepMore[ind]);
		if(StepIndex<objOrder.CurrIndex){
			StepClass="Osteppre";	//��ִ��
		}else if(StepIndex>objOrder.CurrIndex){
			StepClass="Ostepaft";	//δִ��
		}else{
			StepClass="Ostepcurr";	//��ǰ����
		}
		var tmpStep=StepMore[ind].split(":");
		StepMoreHtml=StepMoreHtml+"<div id='OStep-"+tmpStep[0]+"' class='OselectStepMore "+StepClass+"'>"+tmpStep[1]+"</div>"
	}
	$('#OStepMoreList').html(StepMoreHtml);
}

SelectStep = function(IDStr){
	var SelectedStepID=IDStr.split("-")[1];
	var SelectedStepText=$("#"+IDStr).text();
	var SelectedStep=SelectedStepID+":"+SelectedStepText;
	var SelectedIndex=objOrder.StepList.indexOf(SelectedStep);
	objOrder.StepSelecedID=SelectedStepID;
	
	if (objOrder.StatusCurrDesc == "�뾶"){
		if(objOrder.StepSelecedID != objOrder.StepCurrID) {	//�ǵ�ǰ���費�������ҽ��
			$("#Addorder").linkbutton("disable");
		}else{
			$("#Addorder").linkbutton("enable");
		}	
	}else{ $("#Addorder").linkbutton("disable"); }
	
	//������չ�ֲ���
	ShowCPWSteps(SelectedIndex);
	//չ�ֲ�������
	if (objOrder.curTabTitle==$g("��·��")) ShowStepDetail(IDStr);
	else {
		$("#OStepShow .Ostep").removeClass('selected');
		$("#"+IDStr).addClass('selected');	
	}
	//�󶨵���¼�
	$('#OStepMoreList .OselectStepMore').on('click', function(){
		SelectStep(this.id);
	});
	$('#OStepShow .Ostep').on('click', function(){
		var SelectedStepID=this.id.split("-")[1];
		objOrder.StepSelecedID=SelectedStepID;
		SelectStep(this.id);
		//ShowStepDetail(this.id);
	});
	ShowOSetpMore(0);	//�رո��ಽ��
	objOrder.SelectedOrds={rows:[],total:999};
	objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);
}

ShowStepDetail = function(IDStr){
	$("#OStepShow .Ostep").removeClass('selected');
	$("#"+IDStr).addClass('selected');
	$m({
		ClassName:"DHCMA.CPW.CPS.ImplementSrv",
		MethodName:"GetOrdItmTree",
		aPathwayID: objOrder.PathwayID, 
		aEpisID: objOrder.PathwayID+"||"+objOrder.StepSelecedID,
		aUserType: UserType
	},function(treeJson){
		var dataArr=$.parseJSON(treeJson)
		$('#OItemTree').tree({
			data: dataArr,
			formatter:function(node){
				var Displaytxt="";
				if (node.children){
					Displaytxt = node.text;
				}else{
					len=node.text.length;
					if (len<15) {
						Displaytxt = node.text;
					}else{
						Displaytxt = node.text.substring(0,15)+"<br />"+node.text.substring(15)
					}
				}
				//�Ѿ�ִ��				
				if((!node.children)&&(node.attributes.IsImp)){
					Displaytxt = "<span style='color:#509DE1;'>"+Displaytxt+"</span>";
				}
				if((!node.children)&&(node.attributes.IsRequired)){
					Displaytxt = "<span style='color:red;'>*</span>"+Displaytxt;
				}
				return Displaytxt
			},
			onClick: function(node){
				var PathFormEpID="";
				var PathFormEpItemID="";
				if(node.id.split("-")[0]=="OrdTree"){
					PathFormEpID=node.id.split("-")[2];
					PathFormEpItemID="";
				}else{
					var root=$('#OItemTree').tree('getParent', node.target);
					PathFormEpID=root.id.split("-")[2];
					PathFormEpItemID=node.id.split("-")[1];
				}
				objOrder.tempFormEpID=PathFormEpID;
				objOrder.tempFormEpItemID=PathFormEpItemID;
				
				$cm ({
					ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
					QueryName:"QryPathFormEpItemOrdAll",
					ResultSetType:"array",
					aPathFormEpDr:PathFormEpID,
					aPathFormEpItemDr:PathFormEpItemID,
					aHospID:HospID,
					aOrdDesc:$('#OrdDesc').searchbox('getValue'),
					aOrdGroupID:objOrder.OrdGroupID,
					aUserType:UserType,
					aEpisodeID:EpisodeID,
					aLgnLocID:session['DHCMA.CTLOCID'],
					page:1,
					rows:99999
				},function(rs){
					$('#CPWItemOrder').datagrid({groupField:'ItemDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);				
				});
			},
			onLoadSuccess: function(node, data){
				if(data.length>0){
					var rootID=data[0].id;
					var node = $('#OItemTree').tree('find', rootID);
					$('#OItemTree').tree('select', node.target);
					$('#OItemTree').tree('check', node.target);
					PathFormEpID=rootID.split("-")[2];
					objOrder.tempFormEpID=PathFormEpID;
					objOrder.tempFormEpItemID="";
					
					$cm ({
						ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
						QueryName:"QryPathFormEpItemOrdAll",
						ResultSetType:"array",
						aPathFormEpDr:PathFormEpID,
						aPathFormEpItemDr:"",
						aHospID:HospID,
						aOrdDesc:$('#OrdDesc').searchbox('getValue'),
						aOrdGroupID:"",
						aUserType:UserType,
						aEpisodeID:EpisodeID,
						aLgnLocID:session['DHCMA.CTLOCID'],
						page:1,
						rows:99999
					},function(rs){
						$('#CPWItemOrder').datagrid({groupField:'ItemDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);				
					});
					
				}
			},
			lines:true,autoNodeHeight:true
		})
	});	
}

ShowOSetpMore = function(Emvalue){
	if(Emvalue==1){
		$('#OStepMoreList').css('display','block');
		$('#OStepMore').attr("value",0);
		$('#OStepMore').text($g("�����"));
	}else{
		$('#OStepMore').text($g("���਋"));
		$('#OStepMore').attr("value",1);
		$('#OStepMoreList').css('display','none');
	}
}

GetLength = function(str) {
	///����ַ���ʵ�ʳ��ȣ�����2��Ӣ��1������1
	var realLength = 0, len = str.length, charCode = -1;
	for (var i = 0; i < len; i++) {
		charCode = str.charCodeAt(i);
		if (charCode >= 0 && charCode <= 128)
			realLength += 1;
		else
			realLength += 2;
	}
	return realLength;
}

//��ʾ������Ϣ��ϸ
ShowFJDetail = function(FJid){
	$cm({
		ClassName:"DHCMA.CPW.BTS.PathTCMExtSrv",
		QueryName:"QryPathTCMExt",
		aParRef:FJid,
		ResultSetType:"array"
	},function(rs){
		var PopHtml=""
		if (rs.length>0){
			for(var i=0;i<rs.length;i++){
				PopHtml=PopHtml+rs[i].BTTypeDesc+"&nbsp&nbsp&nbsp"+rs[i].BTOrdMastID+"&nbsp&nbsp&nbsp"+rs[i].ArcResumeDesc+"<br/>"
			}
		}
		$HUI.popover('#pop'+FJid,{content:PopHtml,trigger:'hover'});
		$('#pop'+FJid).popover('show');
	});
}

//����ģ̬��
DestoryFJDetail = function(FJid){
	$('#pop'+FJid).popover('destroy');
}

//չʾҽ������ϸ
ShowARCOSDetail = function(ARCOSID,ARCOSDesc,OutIndex){
	$('#gridARCOSOrder').datagrid('loadData',{rows:[],total:0});
	$cm({
		ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
		QueryName:"QryOrderByARCOS",
		ARCOSRowid:ARCOSID,
		aHospID:session['DHCMA.HOSPID'],
		page:1,
		rows:99999
	},function(rs){
		$('#gridARCOSOrder').datagrid({'title':$g('��ǰҽ����')+'��'+ARCOSDesc,'onLoadSuccess': function(data){
			if (objOrder.JsonARCOSDetail[ARCOSID]!="" && objOrder.JsonARCOSDetail[ARCOSID]!=undefined){
				var chkARCIMRowArr = objOrder.JsonARCOSDetail[ARCOSID]
				for (var i=0;i<chkARCIMRowArr.length;i++){
					var chkRowIndex = chkARCIMRowArr[i].split("*")[2]
					$(this).datagrid('checkRow', chkRowIndex)	
				}
			}	
		}});
		$('#gridARCOSOrder').datagrid('loadData',rs);
		$HUI.dialog('#ARCOSCPWDialog',{
			inParam:ARCOSID,
			OutIndex:OutIndex,
			onClose:function(){
				if (objOrder.JsonARCOSDetail[ARCOSID]!=undefined && objOrder.JsonARCOSDetail[ARCOSID].length!=0){
					$("#CPWItemOrder").datagrid('checkRow',OutIndex)	
				}else{
					$("#CPWItemOrder").datagrid('uncheckRow',OutIndex)	
				}	
			}
		}).open();
	})	
}

//�ϲ�֢��Ϣչʾ����
SeletctComplTab = function(){
	$m({
		ClassName:"DHCMA.CPW.CPS.PathwayComplSrv",
		MethodName:"GetComplItemTree",
		aPathwayID: objOrder.PathwayID, 
		aEpisID: objOrder.PathwayID+"||"+objOrder.StepSelecedID,
		aUserType: UserType
	},function(treeJson){
		var dataArr=JSON.parse(treeJson);
		if(dataArr.length==0){
			$("#tabItemTree").tabs('getSelected').context.innerHTML="<span style='color:#1474AF;margin-left:10px;'>"+$g("��ʾ���޹����ϲ�֢��")+"</span>";
			return;
		} 
		$('#ComplTree').tree({
			data: dataArr,
			lines:true,
			autoNodeHeight:true,
			formatter:function(node){
				var Displaytxt=node.text;
				if((!node.children)&&(node.attributes.IsImp)){
					Displaytxt = "<span style='color:#509DE1;'>"+node.text+"</span>";
				}
				if((!node.children)&&(node.attributes.IsRequired)){
					Displaytxt = "<span style='color:red;'>*</span>"+Displaytxt;
				}
				return Displaytxt;
			},
			onClick: function(node){
				var CFormID="";
				var CFormEpID="";
				var CFormItemID="";
				if(node.id.split("-")[0]=="ComplForm"){
					CFormID=node.id.split("-")[2];
					CFormEpID=""
					CFormItemID="";
				}else if(node.id.split("-")[0]=="ComplEp"){
					CFormID=node.id.split("-")[1].split("||")[0];
					CFormEpID=node.id.split("-")[1];
					CFormItemID="";
				}else{
					CFormID=node.id.split("-")[1].split("||")[0];
					CFormEpID=CFormID + "||" + node.id.split("-")[1].split("||")[1];
					CFormItemID=node.id.split("-")[1];
				}
				objOrder.tempCplFormID=CFormID;
				objOrder.tempFormEpID=CFormEpID;
				objOrder.tempFormEpItemID=CFormItemID;
				
				objOrder.cboOrdGroup.clear();
				objOrder.OrdGroupID="";
				if(node.id.split("-")[0]=="ComplForm"){
					$("#OrdDesc").searchbox("clear");	
				}
				
				$cm ({
					ClassName:"DHCMA.CPW.CPS.PathwayComplSrv",
					QueryName:"QryComplFormOrdAll",
					ResultSetType:"array",
					aFormID:CFormID,
					aFormEpID:CFormEpID,
					aFormItemID:CFormItemID,
					aHospID:HospID,
					aOrdDesc:$('#OrdDesc').searchbox('getValue'),
					aOrdGroupID:objOrder.OrdGroupID,
					aUserType:UserType,
					aEpisodeID:EpisodeID,
					aLgnLocID:session['DHCMA.CTLOCID'],
					page:1,
					rows:99999
				},function(rs){
					$('#CPWItemOrder').datagrid({groupField:'OrdBuzTypeDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);
				});
			},
			onLoadSuccess: function(node, data){
				if(data.length>0){
					var firstCFormID=data[0].id;
					var node = $('#ComplTree').tree('find', firstCFormID);
					$('#ComplTree').tree('select', node.target);
					
					CFormID=node.id.split("-")[2];
					objOrder.tempCplFormID=CFormID;
					objOrder.tempFormEpID="";
					objOrder.tempFormEpItemID="";
					
					$cm ({
						ClassName:"DHCMA.CPW.CPS.PathwayComplSrv",
						QueryName:"QryComplFormOrdAll",
						ResultSetType:"array",
						aFormID:CFormID,
						aFormEpID:"",
						aFormItemID:"",
						aHospID:HospID,
						aOrdDesc:$('#OrdDesc').searchbox('getValue'),
						aOrdGroupID:"",
						aUserType:UserType,
						aEpisodeID:EpisodeID,
						aLgnLocID:session['DHCMA.CTLOCID'],
						page:1,
						rows:99999
					},function(rs){
						$('#CPWItemOrder').datagrid({groupField:'OrdBuzTypeDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);			
					});
					
				}
			}
		})
	});		
}
