//ҳ��Gui
function InitCalcCostWin(){
	var obj = new Object();
	obj.BudgetCostID="";
	obj.RecRowID="";
	obj.Arcim="";
	obj.SelectEpDays="";
	obj.isCNMedItem="";
	
	//�Ȼ�ȡ�����¼��ID
	obj.BudgetCostID= $.cm({
		ClassName:"DHCMA.CPW.BTS.BudgetCostSrv",
		MethodName:"GetBCIDByFormID",
		aFormID:PathFormID,
		aUserID:session['DHCMA.USERID']
	},false);
	
	//ҽ����ϸ�б�
	obj.gridFeeDetail = $HUI.datagrid("#gridFeeDetail",{
		fit: true,
		border:false,
		headerCls:'panel-header-gray',
		showGroup: true,
		groupField:'FormEpDesc',
		view: groupview,
		groupFormatter:function(value, rows){
			if(rows==undefined) return false;
			return "�׶Σ�"+value + ' , ��( ' + rows.length + ' )��';
		},  
		scrollbarSize: 0,
		checkOnSelect: false,
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ڼ�����...',
		pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		//pageSize: 50,
		//pageList : [50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCMA.CPW.BTS.BudgetOrdRecSrv",
			QueryName:"QryBORecCost",
			aFormID:PathFormID,
			aHospID:CurrHosp,
			page:1,
			rows:99999
		},
		columns:[[
			//{field:'CheckRec',checkbox:'true',align:'center',width:'',auto:false},
			{field:'BORecID',title:'ID',width:'80',hidden:'true'},
			{field:'OrdPriorityDesc',title:'ҽ������',width:'80'},
			{field:'OrdTypeDesc',title:'������',width:'100'},
			{field:'OrdMastDesc',title:'ҽ������',width:'350'},
			//{field:'OrdLnkOrdDr',title:'������',width:'50'},
			{field:'OrdDoseQty',title:'���μ���',width:'80'},
			{field:'OrdUOMDesc',title:'������λ',width:'80'},
			{field:'BaseUomPrice',title:'����',width:'150'},
			{field:'OrdFreqDesc',title:'Ƶ��',width:'80'},
			//{field:'OrdInstrucDesc',title:'�÷�',width:'70'},
			//{field:'OrdDuratDesc',title:'�Ƴ�',width:'70'},
			{field:'OrdUseDays',title:'����',width:'80'},
			{field:'OrdQty',title:'����',width:'80'},
			{field:'OrdQtyUomDesc',title:'������λ',width:'80'},
			{field:'BORecCost',title:'����',width:'100'},
			{field:'Resume',title:'��ע',width:'150'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridFeeDetail_onSelect();
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnAllDel").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	})
		
	//�׶�1
	obj.cboFormEp = $HUI.combobox('#cboFormEp', {
		url:$URL,
		editable: true,
		required:true,
		valueField: 'ID',
		textField: 'EpDesc',
		defaultFilter:4,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.CPW.BTS.PathFormEpSrv",
			param.QueryName="QryPathFormEp",
			param.aPathFormDr=PathFormID,
			param.ResultSetType='array'	
		} ,
		onSelect:function(rec){
			obj.SelectEpDays=rec.EpDays;
			$('#cboOrdItem').combobox('clear').combobox('reload');
		} 
	});
	
	//��Ŀ1
	obj.cboOrdItem = $HUI.combobox('#cboOrdItem', {
		url:$URL,
		editable: true,
		required:true,
		valueField: 'ID',
		textField: 'ItemDesc',
		defaultFilter:4,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.CPW.BTS.PathFormEpSrv",
			param.QueryName="QryPathFormEpItem",
			param.aPathFormEpDr=$("#cboFormEp").combobox("getValue"),
			param.aDicCode="B",
			param.ResultSetType='array'	
		}
	});
	
	//��������
	obj.cboCategory = $HUI.combobox("#cboCategory",{
		url:$URL+"?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&aTypeCode=CPWFormOrdType&aHospID=" +CurrHosp+ "&ResultSetType=array",
		valueField:'BTID',
		textField:'BTDesc',
		disabled:true,
		required:true,
		onLoadSuccess:function()
		{
			obj.cboSelectByText("cboCategory","01");
		}
	});
	
	//ҽ������	
	obj.cboPriority = $HUI.combobox("#cboPriority",{
		url:$URL+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryOECPriority&ResultSetType=array",
		valueField:'OECPRID',
		textField:'OECPRDesc',
		required:true,
		onSelect:function(row){
			//����ҽ�����ͣ�������ҽ�����Ա�ҩ���ڡ��������У��������ɱ༭�������ɱ༭�����������ɱ༭���������ɱ༭
			if (row.OECPRCode!="S" && row.OECPRCode!="OMST" && row.OECPRCode!="OMCQZT"){		//��ʱҽ������Ժҽ��
				$("#txtOrdQty").validatebox("setDisabled",false);
				$("#txtOrdUseDays").validatebox("setDisabled",true);
				$("#txtOrdUseDays").val("");
				obj.isLongOrdType=0
			}else{																				//����ҽ��
				$("#txtOrdQty").validatebox("setDisabled",true);
				$("#txtOrdUseDays").validatebox("setDisabled",false);
				var selGridRow = $('#gridFeeDetail').datagrid('getSelected');
				if(selGridRow == null || selGridRow == undefined){
					if (obj.Arcim!="" && obj.Arcim.ArcimID.indexOf("||")!=-1){					//ҽ����
						$("#txtOrdUseDays").val(obj.SelectEpDays);								//Ϊ�������ó�ʼֵȡ��ǰ�׶�����
					}else{																					//ҽ����
						$("#txtOrdUseDays").val("")	
					}	
				}				
				obj.isLongOrdType=1; 
			}
		}
	});
	
	//ҽ����
	$("#txtOrdMast").lookup({
		panelWidth:500,
		url:$URL,	
		mode:'remote',
		method:"Get",
		idField:'ArcimID',
		textField:'ArcimDesc',
		columns:[[  
			{field:'ArcimCode',title:'����',width:100},  
			{field:'ArcimDesc',title:'����',width:300},  
			{field:'ArcimID',title:'ID',width:70}  
		]],
		pagination:true,
		isCombo:true,
		minQueryLen:2,
		delay:'500',
		required:true,
		missingMessage:"��������Ϊ������",
		deltaX:-10,
		queryOnSameQueryString:true,
		queryParams:{ClassName:'DHCMA.CPW.BTS.LinkArcimSrv',QueryName:'QryArcimByAlias',aHospID:CurrHosp,aIsShowOrdSet:"0"},
		onSelect:function(index,rowData){
			obj.Arcim = rowData
			//console.log("index="+index+",rowData=",rowData);
			//����Ƿ��ǲ�ҩ��ҽ��
			obj.isCNMedItem=$cm({
				ClassName:"DHCMA.CPW.IO.FromDoc", 
				MethodName:"IsCPWCNMedItem",
				aArcimRowid:rowData.ArcimID,
				aHospID:CurrHosp
			},false);
			
			//����ҽ������ҽ��������������ʼֵȡ��ǰ�׶�����
			var selGridRow = $('#gridFeeDetail').datagrid('getSelected');
			if (obj.isLongOrdType==1 && (selGridRow == null || selGridRow == undefined)){
				if (obj.Arcim!="" && obj.Arcim.ArcimID.indexOf("||")!=-1){		//ҽ����
					$("#txtOrdUseDays").val(obj.SelectEpDays);
				}else{
					$("#txtOrdUseDays").val("");	
				}	
			}
			
			//���ҽ���Ƿ��м�鲿λѡ��  dsp
			var OrdBodyStr = $cm({
				ClassName:"web.DHCAPPExaReportQuery",
				MethodName:"jsonGetPartTreeByArc",
				itmmastid:rowData.ArcimID,
				PyCode:"",
				TraID:"",
				HospID:CurrHosp.split("!!")[0],
				dataType:"text"
			},false);
			
			if(OrdBodyStr.indexOf("id")>0){	
					var path="dhcapp.appreppartwin.csp?itmmastid="+rowData.ArcimID+"&selOrdBodyPartStr=*";
					websys_showModal({
						url:path,
						title:'��Ӽ�鲿λ',
						iconCls:'icon-w-import',  
						closable:false,
						originWindow:window,
						width:1200,
						height:500,
						CallBackFunc:function(ret){
							if((ret!="")&&(ret!=undefined)){
								var arrPos=ret.split("^")
								var strPos=arrPos[0]+"||"+arrPos[1]+"||"+arrPos[2];
								$("#txtOrdPos").val(strPos);
								$("#txtOrdPosShow").val(arrPos[0]);
							}
						}
					});
			}
			obj.OrdMast_onSelect(rowData);
		}
	});
	
	//������λ����ʾ����������λ����Ч��λ��	
	obj.cboOrdUOM = $HUI.combobox("#cboOrdUOM",{
		url:$URL,  //+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryDoseUomByArcim&aArcimID="+rowData.ArcimID+"&ResultSetType=array",
		valueField:'DoseUomID',
		textField:'DoseUomDesc',
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.CPW.BTS.LinkArcimSrv",
			param.QueryName="QryDoseUomByArcim",
			param.aArcimID=$("#txtOrdMast").lookup("getValue"),
			param.aHospID=CurrHosp,
			param.ResultSetType='array'
		}
	});
	
	//Ƶ��
	$("#cboOrdFreq").lookup({
		panelWidth:140,
		url:$URL,//+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryPHCFreq&ResultSetType=array",
		mode:'remote',
		method:"Get",
		isCombo:true,
		//minQueryLen:2,
		selectOnNavigation: true,
		pagination:false,
		delay:'500',
		queryOnSameQueryString:true,
		idField:'FreqID',
		textField:'FreqDesc',
		queryParams:{ClassName:'DHCMA.CPW.BTS.LinkArcimSrv',QueryName:'QryPHCFreq'},
		columns:[[  
			{field:'FreqID',title:'ID',width:50,sortable:true,hidden:true},  
			{field:'FreqDesc',title:'����',width:120,sortable:true}, 
		]]
	});
	
	//�÷�
	$("#cboOrdInstruc").lookup({
		panelWidth: 140,
		url: $URL,	//+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryPHCInstruc&ResultSetType=array",
		mode: 'remote',
		method:"Get",
		isCombo: true,
		//minQueryLen: 2,
		selectOnNavigation: true,
		pagination: false,
		delay:'500',
		queryOnSameQueryString:true,
		idField: 'InstrucID',
		textField: 'InstrucDesc',
		queryParams:{ClassName:'DHCMA.CPW.BTS.LinkArcimSrv',QueryName:'QryPHCInstruc'},
		columns: [[  
			{field:'InstrucID',title:'ID',width:50,hidden:true},  
			{field:'InstrucDesc',title:'����',width:120}, 
		]],
		onBeforeLoad : function(param){
			if ($("#txtOrdMast").val() == '') {
				$.messager.popover({msg: '����ѡ��ҽ����',type:'info',timeout: 2000,showType: 'show'});
				$("#cboOrdInstruc").lookup('hidePanel');
				return false;
			}
			param.OrdID = obj.Arcim.ArcimID;
			param.Instruc = param.q;
			
			//param = $.extend(param,{OrdID:obj.Arcim.ArcimID,Instruc:param.q});
		}
	});
	
	//�Ƴ�
	$("#cboOrdDurat").lookup({
		panelWidth:140,
		url:$URL,	//+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryPHCDuration&ResultSetType=array",
		mode:'remote',
		method:"Get",
		isCombo:true,
		//minQueryLen:2,
		selectOnNavigation: true,
		pagination: false,
		delay:'500',
		queryOnSameQueryString:true,
		idField:'DuratID',
		textField:'DuratDesc',
		queryParams:{ClassName:'DHCMA.CPW.BTS.LinkArcimSrv',QueryName:'QryPHCDuration'},
		columns:[[  
			{field:'DuratID',title:'ID',width:50,hidden:true},  
			{field:'DuratDesc',title:'����',width:120}, 
		]]
	});
	
	//����ҽ����ϸ�б�
	obj.gridFormOrd = $HUI.datagrid("#gridFormOrd",{
		fit: true,
		border:false,
		headerCls:'panel-header-gray',
 		/* showGroup: true,
		groupField:'ItemDesc',
		view: groupview,
		groupFormatter:function(value, rows){
			if(rows==undefined) return false;
			return "��Ŀ��"+value + ' , ��( ' + rows.length + ' )��';
		},  */  
		scrollbarSize: 0,
		checkOnSelect: true,
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: false,
		autoRowHeight: true, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ڼ�����...',
		pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		columns:[[
			{field:'CheckRec',checkbox:'true',align:'center',width:'',auto:false},
			{field:'OrdPriorityIDDesc',title:'ҽ������',width:'80'},
			{field:'OrdMastIDDesc',title:'ҽ����',width:'300',
				formatter: function(value,row,index){
					var id=row['xID'].split("||").join("-")
					var chkPosDesc=row['OrdChkPosID'].split("||")[0]
					return "<span id='"+id+"'>"+value+chkPosDesc+"</span>"
					
				}
			},
			{field:'OrdLnkOrdDr',title:'������',width:'50'},
			{field:'OrdTypeDrDesc',title:'������',width:'70'},
			{field:'OrdDoseQty',title:'���μ���',width:'70'},
			{field:'OrdUOMIDDesc',title:'��λ',width:'70'},
			{field:'OrdFreqIDDesc',title:'Ƶ��',width:'70'},
			{field:'OrdInstrucIDDesc',title:'�÷�',width:'70'},
			{field:'OrdDuratIDDesc',title:'�Ƴ�',width:'70'},
			{field:'OrdQty',title:'����',width:'60'},
			{field:'OrdQtyUomDesc',title:'������λ',width:'70'},
			{field:'OrdIsDefault',title:'��ѡҽ��',width:'70'},
			{field:'OrdIsFluInfu',title:'��ҽ��',width:'70'},
			{field:'OrdNote',title:'��ע',width:'70'}
		]],
		onCheck:function(index,row){
			var arrDtlRows=$("#gridFeeDetail").datagrid('getData');
			var retFlg=null;
			$.each(arrDtlRows.rows, function(ind, item){
				if (row.xID==item.FormOrderID){
					$.messager.confirm("��ʾ", "������ϸ���Ѵ��ڸü�¼���Ƿ��Թ�ѡ?", function (r) {
						if (!r) $("#gridFormOrd").datagrid("uncheckRow", index);
						return false;
					})
					return false;
				}
			});
			
		},
		onLoadSuccess:function(data){
			if (data.rows.length>0){
				for (var i= 0;i<data.rows.length;i++){
					//console.log(data.rows[i]);
					if(data.rows[i].xID.indexOf("FJ")>-1 || data.rows[i].OrdMastID.indexOf("||")<0){
						//$("input[type='checkbox']")[i+1].disabled = true;	
						//$("input:checkbox[name='CheckRec']")[i+1].disabled = true;
						
						//���ؽ��ɾ��������ҽ���ף�ֻ��ʾҽ����
						$("#gridFormOrd").datagrid("deleteRow", i);
						i=i-1;	
					}	
				}	
			}	
		}
	})
	
	//�׶�2
	obj.cboFormEp2 = $HUI.combobox('#cboFormEp2', {
		url:$URL,
		editable: true,
		required:true,
		valueField: 'ID',
		textField: 'EpDesc',
		defaultFilter:4,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.CPW.BTS.PathFormEpSrv",
			param.QueryName="QryPathFormEp",
			param.aPathFormDr=PathFormID,
			param.ResultSetType='array'	
		} ,
		onSelect:function(rec){
			obj.SelectEpDays=rec.EpDays;
			$('#cboOrdItem2').combobox('clear').combobox('reload');
		} 
	});
	
	//��Ŀ2
	obj.cboOrdItem2 = $HUI.combobox('#cboOrdItem2', {
		url:$URL,
		editable: true,
		required:false,
		valueField: 'ID',
		textField: 'ItemDesc',
		defaultFilter:4,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.CPW.BTS.PathFormEpSrv",
			param.QueryName="QryPathFormEpItem",
			param.aPathFormEpDr=$("#cboFormEp2").combobox("getValue"),
			param.aDicCode="B",
			param.ResultSetType='array'	
		}
	});
	
	//ͨ��������ֵ
	obj.cboSelectByText = function(idName,selTxt){
		var rstData = $('#'+idName).combobox('getData');
		for(var i=0;i<rstData.length;i++){			
			var objTmp = rstData[i];
			if(objTmp.BTCode == selTxt){
				$('#'+idName).combobox('select',objTmp.BTID);
				break;
			}
		}
	}
	
	

	InitCalcCostEvent(obj);
	obj.LoadEvents(arguments);
	$.parser.parse();  
	return obj;
}
