var objOrder = new Object();	
function ShowMakeOrderDialog(){
	var DivWidth=$("#CPW-main").width();
	//$.parser.parse(); // ��������ҳ��
	objOrder.replaceIndex=-1;	//�滻���
	objOrder.IsHaveDown=[];
	objOrder.IsChecking=false;	//��ֹ��ѭ��
	objOrder.IsUnChecking=false;
	objOrder.OrdContent=[];
	objOrder.PathwayID=""
	//�Ƿ��Զ��׶�ȷ�����ü��
	objOrder.IsAutoCfmStep = $cm({
		ClassName:"DHCMA.Util.BT.Config",
		MethodName:"GetValueByCode",
		aCode:"CPWOPEvrInNewEp",
		dataType:"text"
	},false);
		
	//��Ҫ���ƹ���
	objOrder.gridTreatment = $HUI.datagrid("#tb-Treatment",{
		fit: true,
		pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:$g('���ݼ�����...'),
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.OPCPS.ImplementSrv",
			QueryName:"QryCPWStepInfo",		
			aPathwayID: '', 
			aEpisID: '',
			aType:"T" 
	    },
		columns:[[
			{field:'Operation',title:'<img class="Operimg img-TOper" id="img-Execute" onclick=objOrder.ExecuteAllItem() title="ȫ��ִ��" style="cursor:pointer;margin:0;border-radius:50%" src="../scripts/DHCMA/img/add.png"></img><img class="Operimg img-TOper" id="img-Cancle" onclick=objOrder.CancelAllItem() title="ȫ������" style="cursor:pointer;margin:0 10px;border-radius:50%" src="../scripts/DHCMA/img/no.png"></img>',align:'center',width:DivWidth*0.05,
				formatter: function(value,row,index){
					var retStr = "";
					var RowID=row["ID"];
					if (value.split("^")[0]==1) {
						retStr = retStr + '<img class="Operimg img-TOper" onclick="objOrder.ExecuteItem('+RowID+')" title="ִ��" style="cursor:pointer;margin:0 10px;border-radius:50%" src="../scripts/DHCMA/img/add.png"></img>';
					}
					if (value.split("^")[1]==1) {
						retStr = retStr + '<img class="Operimg img-TOper" onclick="objOrder.CancelItem('+RowID+')" title="����" style="cursor:pointer;margin:0 10px;border-radius:50%" src="../scripts/DHCMA/img/no.png"></img>';
					}
					return retStr;
				}
			},
			{field:'IndexNo',title:'���',align:'center',width:DivWidth*0.05},
			{field:'ItemInfo',title:'��Ŀ����',width:DivWidth*0.5},
			{field:'IsRequired',title:'�Ƿ��ѡ',align:'center',width:DivWidth*0.06,
				formatter: function(value,row,index){
					var retStr = "";
					if (value==1) {
						retStr = retStr + '<img title="����ִ��" style="margin:0 25px;border-radius:50%" src="../scripts/DHCMA/img/ok.png"></img>';
					}
					return retStr;
				}
			}, 
			{field:'OperInfo',title:'ִ����Ϣ',width:DivWidth*0.3}	
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
		onLoadSuccess: function(data) {
			objOrder.OperationControl();
		},
		rowStyler: function(index,row){
			if (parseInt(row["IsImp"])>0){
				return 'color:#509DE1;'; 
			}else{
				return 'color:#000000;'; 
			}
		}
	});
	//����ҽ���б�
	objOrder.CPWItemOrder = $HUI.datagrid("#CPWItemOrder",{
		fit: true,
		showGroup: true,
		groupField:'ItemDesc',
		checkOnSelect:false,
		view: groupview,
		groupFormatter:function(value, rows){
			if(value==undefined) return;
			return value + $g(' , ��( ') + rows.length + $g(' )��');
		},
		scrollbarSize: 0,
		pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: false,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:$g('���ݼ�����...'),
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrdAll",
			aPathFormEpDr:"",
			aPathFormEpItemDr:""
	    },
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
						return "<span id='"+id+"' onclick=objOrder.ClickOrdDesc("+index+");>"+value+chkPosDesc+"</span><label id= 'pop"+FJid+"' style='color:red;' onmouseover=objOrder.ShowFJDetail("+FJid+") onmouseout=objOrder.DestoryFJDetail("+FJid+")>["+$g("��ϸ")+"]</label>"
					}else{
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"' onclick=objOrder.ClickOrdDesc("+index+");>"+value+" "+chkPosDesc+"</span>"
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
			{field:'OrdIsDefault',title:'��ѡҽ��',width:'70',formatter:function(v,r,i){
				if (v == 1) return $g('��')
				else return $g('��')	
			}},
			{field:'OrdIsFluInfu',title:'��ҽ��',width:'70',formatter:function(v,r,i){
				if (v == 1) return $g('��')
				else return $g('��')	
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
					if(data.rows[i].OrdCatCode != OrderType){	//����ҩ����
						//��Ϊ������
						$("input[type='checkbox']")[i+1].disabled = true;
						
						//ֱ�ӹ��˸������ݲ���ʾ
						//$("#CPWItemOrder").datagrid("deleteRow", i);
						//i=i-1;
					} else {
						if (data.rows[i].OrdIsDefault==$g("��")) {	//��ѡҽ��
							if(objOrder.IsHaveDown[data.rows[i].xID]==5){	//δִ��
								$("#CPWItemOrder").datagrid("selectRow", i);
								$("#CPWItemOrder").datagrid("checkRow", i);
							}
						}
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
				aArcimID:ArcimID
			},function(rs){
				$('#gridGeneOrder').datagrid({'title':$g('��ǰҽ����')+OrdMastIDDesc});
				$('#gridGeneOrder').datagrid('loadData',rs);
				$HUI.dialog('#GeneCPWDialog').open();	
			})
		},
		onClickCell: function(index,field,value){
			var selData = $('#CPWItemOrder').datagrid('getRows')[index];
			var FormOrdID=selData['xID']
			var id=FormOrdID.split("||").join("-")
		},
		onUnselect: function(index, row){
			var selData = $('#CPWItemOrder').datagrid('getRows')[index];
			var FormOrdID=selData['xID']
			var id=FormOrdID.split("||").join("-")
		},
		onCheckAll: function(rows){
			for (var i=0;i<rows.length;i++){
				if(rows[i].OrdCatCode != OrderType){
					$("#CPWItemOrder").datagrid("uncheckRow", i);
				}
			}
			var checkboxHeader = $('div.datagrid-header-check input[type=checkbox]');//ȡ��ȫѡȫ��ѡ���Ԫ��
			checkboxHeader.prop("checked","checked");//��������Ϊchecked����
		},
		onCheck: function(index, row){
			if(objOrder.IsChecking) return;			
			var ordLinkNum=row['OrdLnkOrdDr'];
			if(ordLinkNum == "") return;
			objOrder.IsChecking=true;
			var Rows=$('#CPWItemOrder').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				if(selData['OrdLnkOrdDr'] == ordLinkNum){	//��ͬ�����ŵ�ҽ��ͬʱ����
					$("#CPWItemOrder").datagrid("selectRow", ind);
					$("#CPWItemOrder").datagrid("checkRow", ind);
				}
			}
			objOrder.IsChecking=false;
		},
		onUncheck: function(index, row){
			if(objOrder.IsUnChecking) return;			
			var ordLinkNum=row['OrdLnkOrdDr'];
			if(ordLinkNum == "") return;
			objOrder.IsUnChecking=true;
			var Rows=$('#CPWItemOrder').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				if(selData['OrdLnkOrdDr'] == ordLinkNum){	//��ͬ�����ŵ�ҽ��ͬʱ����
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
			var FormOrdID=row['xID'];
			var ret=$m({
				ClassName:"DHCMA.CPW.OPCPS.ImplementSrv",
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
	//·����ҽ������
	objOrder.gridVarOrder = $HUI.datagrid("#tb-Variation-Order",{
		fit: true,
		pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���
		singleSelect: false,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:$g('���ݼ�����...'),
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.OPCPS.PathwayVarSrv",
			QueryName:"QryCPWVarOrder",		
			aPathwayID:"", 
			aEpisID:"" 
	    },
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'ind',title:'���',align:'center',width:''},
			{field:'ARCIMDesc',title:'ҽ������',width:'300'},
			{field:'VariatCat',title:'����ԭ��',width:'200'},
			{field:'VariatTxt',title:'����ԭ��',width:'200',editor:'text'}
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
		,onCheck:function(rindex,rowData){			
			if (rindex>-1 && ServerObj.IsAutoCfmStep!='Y') {
				$('#tb-Variation-Order').datagrid("beginEdit", rindex);
				var ed = $(this).datagrid('getEditor', {index:rindex,field:'VariatTxt'});
				$(ed.target).focus();
			}
		},
		onClickRow: function(rowIndex,rowData){
			if (ServerObj.IsAutoCfmStep!='Y'){
				$('#tb-Variation-Order').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);	
				var ed = $(this).datagrid('getEditor', {index:rowIndex,field:'VariatTxt'});
				$(ed.target).focus();	
			}	
			
		}
	});
	
	//δִ����Ŀ����
	objOrder.gridVarItem = $HUI.datagrid("#tb-Variation-Item",{
		fit: true,
		pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���
		singleSelect: false,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:$g('���ݼ�����...'),
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.OPCPS.PathwayVarSrv",
			QueryName:"QryCPWVarItem",		
			aPathwayID: "", 	
			aEpisID: ""
	    },
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'ind',title:'���',align:'center',width:''},
			{field:'TypeDesc',title:'����',width:''},
			{field:'ItemDesc',title:'����',width:'400'},
			{field:'VariatCat',title:'����ԭ��',width:'200'},
			{field:'VariatTxt',title:'����ԭ��',width:'200',editor:'text'}
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
		,onCheck:function(rindex,rowData){
			if (rindex>-1 && ServerObj.IsAutoCfmStep!='Y') {
				$('#tb-Variation-Item').datagrid("beginEdit", rindex);
				var ed = $(this).datagrid('getEditor', {index:rindex,field:'VariatTxt'});
				$(ed.target).focus();
			}
			
		},
		onClickRow: function(rowIndex,rowData){
			if(ServerObj.IsAutoCfmStep!='Y')	{
				$('#tb-Variation-Item').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);	
				var ed = $(this).datagrid('getEditor', {index:rowIndex,field:'VariatTxt'});
				$(ed.target).focus();
			}		
		}
	})
	
	//��ҩ���������б����
	objOrder.gridVarTCM = $HUI.datagrid("#tb-Variation-TCMVar",{
		fit: true,
		pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���
		singleSelect: false,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:$g('���ݼ�����...'),
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.OPCPS.PathwayVarSrv",
			QueryName:"QryCPWTCMVar",		
			aPathwayID:"", 
			aEpisID:"" 
	    },
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'ind',title:'���',align:'center',width:''},
			{field:'ARCIMDesc',title:'ҽ������',width:'200'},
			{field:'ImplDesc',title:'������Ŀ',width:'300'},
			{field:'VariatCat',title:'����ԭ��',width:'200'},
			{field:'VariatTxt',title:'����ԭ��',width:'200',editor:'text'}
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
		,onCheck:function(rindex,rowData){			
			if (rindex>-1 && ServerObj.IsAutoCfmStep!='Y') {
				$('#tb-Variation-TCMVar').datagrid("beginEdit", rindex);
				var ed = $(this).datagrid('getEditor', {index:rindex,field:'VariatTxt'});
				$(ed.target).focus();
			}
		},
		onClickRow: function(rowIndex,rowData){
			if (ServerObj.IsAutoCfmStep!='Y'){
				$('#tb-Variation-TCMVar').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);	
				var ed = $(this).datagrid('getEditor', {index:rowIndex,field:'VariatTxt'});
				$(ed.target).focus();
			}	
		}
		,onLoadSuccess:function(data){

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
	var OutReason= $HUI.combobox('#OutReason', {
		url: $URL,
		editable: false,
		placeholder:'��ѡ��',
		valueField: 'VarID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathVariatSrv';
			param.QueryName = 'QryVerByTypeCat';
			param.aTypeCode = '02';
			param.aCatCode = '';
			param.aAdmType = 'O';
			param.ResultSetType = 'array';
		}
	});
	InitOPOrderWinEvent(objOrder);
	objOrder.LoadEvent(arguments);	

	return objOrder;
	
}
