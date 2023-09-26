//ҳ��Gui
var objScreen = new Object();
function InitAntMoniWin(){
	var obj = objScreen;
	var LogonHospID = $.LOGON.HOSPID;
	
	obj.dtDateTo	= $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	obj.dtDateFrom	= $('#dtDateFrom').datebox('setValue', Common_GetDate(new Date()));
	
	//ҽԺ ����
	obj.cboHospital=Common_ComboToSSHosp("cboHospital",LogonHospID);
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["ID"];
			obj.cboRepLoc=Common_ComboToLoc("cboLoc",HospID,"","I","E");//E|W
	    }
    });
	
	obj.gridAntMonitor = $HUI.datagrid("#AntMonitor",{
		fit: true,
		title:'������ҩ�����б�',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,	
		fitColumns: true,	
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,50,100,200],
		nowrap:false,	   
		url:$URL,
	    queryParams:{
			ClassName:'DHCHAI.ANTS.OrdAntiPatSrv',
			QueryName:'QryIntMonitor',
			aHospIDs:$('#cboHospital').combobox('getValue'),
			aDateFrom:$('#dtDateFrom').datebox('getValue'),
			aDateTo:$('#dtDateTo').datebox('getValue'),
			alocDr:$('#cboLoc').combobox('getValue'),
			aAntiMastDr:$('#cboAntiMast').combobox('getValue'),
			aQryStatus:$('#cboQryStatus').combobox('getValue'),
			aPatNo:$('#txtRegNo').val()			
	    },
		columns:[[
			{field:'PatNo',title:'�ǼǺ�',width:120,align:'center'},
			{field:'PatName',title:'����',width:80,align:'center',sortable:'true'},
			{field:'PatSex',title:'�Ա�',width:50,align:'center'},
			{field:'PatAge',title:'����',width:80,align:'center',sortable:'true'},
			{field:'AdmLocDesc',title:'�������',width:150,align:'center',sortable:'true'},
			{field:'AdmWardDesc',title:'���ﲡ��',width:180,align:'center',sortable:'true'},
			{field:'AdmBed',title:'��λ',width:50,align:'center'},
			{field:'AdmDate',title:'��Ժ����',width:100,align:'center',sortable:'true'},
			{field:'DischDate',title:'��Ժ����',width:100,align:'center',sortable:'true'},
			{field:'IsReport',title:'�Ƿ��ϱ�',width:80,align:'center',sortable:'true'},
			{field:'VisitStatus',title:'����״̬',width:80,align:'center',sortable:'true'},
			{field:'DrugNameList',title:'��ҩ���',width:150,align:'center',
				formatter: function(value,row,index){
					var strList = value.split(",");
					var len = strList.length;	   
					var strRet ="";
					for (var indx=0;indx<len;indx++){
						var DrugName =strList[indx].split(",");
						strRet +="<div style='padding:5px;'><span style='background-color:#00CDCD;border-radius:5px;color:#fff;text-align:left;padding:3px;' >"+DrugName+"</span></div>";
					}
					return strRet;
				}
			}
		]]
		,view: detailview
		,detailFormatter:function(index, rowData){	
			return '<div style="padding:5px 5px 5px 0px;"><table id=gridAntiDrugList'+index+'></table></div>';
		}, 
		onExpandRow: function(pindex, rowData){
			var rows = $('#AntMonitor').datagrid('getRows');
			$.each(rows,function(i,k){
				//��ȡ��ǰ����չ����������
				var expander = $('#AntMonitor').datagrid('getExpander',i);
				if(expander.length && expander.hasClass('datagrid-row-collapse')){
					if(k.EpisodeID != rowData.EpisodeID){
						//�۵���һ��չ����������
						$('#AntMonitor').datagrid('collapseRow',i);
					}
				}
			});
		
			obj.gridAntiDrugList = $HUI.datagrid('#gridAntiDrugList'+pindex,{   //������ҩ��ϸ
				fitColumns: true,		
				pageSize: 5,
				pageList : [5,10],
				pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������			
				singleSelect: true,
				autoRowHeight: true,
				rownumbers: true,
				loadMsg:'���ݼ�����...',
				url:$URL,
				queryParams:{
					ClassName:"DHCHAI.ANTS.OrdAntiPatSrv",
					QueryName:"QryPatSta",		
					aEpisodeID:rowData.EpisodeID
				},
				columns:[[
					{field:'OEOrdDesc',title:'ҽ����',width:220},
					{field:'AntiMastDesc',title:'��׼����',width:150,
						formatter: function(value,row,index){					
							return "<div style='padding:5px;'><span style='background-color:#00CDCD;border-radius:5px;color:#fff;text-align:left;padding:3px;' >"+value+"</span></div>";					 
						}
					},
					{field:'OESttDate',title:'ҽ����ʼ����',width:100},
					{field:'OEXDate',title:'ͣҽ������',width:100},
					{field:'OEOrdLoc',title:'��ҽ������',width:100},
					{field:'OEDoseQty',title:'����',width:50},
					{field:'OEDoseQtyUom',title:'��λ',width:60},
					{field:'OEFreqDesc',title:'Ƶ��',width:50},
					{field:'OEInstruc',title:'�÷�',width:100},
					{field:'OEDoctor',title:'����ҽʦ',width:100},
					{field:'RepStatus',title:'����״̬',width:80},
					{field:'ReportStr',title:'�ϱ���¼',width:300,
						formatter: function(value,row,index){
							var strRet = "";
							if (value != ''){
								var strList = value.split("$$");
								var len = strList.length;
								for (var indx=0;indx<len;indx++){
									var arrInfo = strList[indx].split(",");
									var RepID = arrInfo[0];
									var RepAnti = arrInfo[1];
									var RepDate = arrInfo[2];
									var RepTime = arrInfo[3];
									var Status = arrInfo[4];
									strRet +="<div style='padding:5px;'><span style='background-color:#00CDCD;border-radius:5px;color:#fff;text-align:left;padding:3px;' >"
									+ "<a href='#' style='white-space:normal; color:#FFFFFF' onclick='objScreen.btnReport_Click(\"" + rowData.EpisodeID + "\",\"" + RepID + "\",\"" + row.OrdItemID + "\",\"" + pindex + "\");'>"+ RepAnti + ' ' + RepDate + ' ' + RepTime + ' ' + Status + "</a>"
									+"</span></div>";
								}
							} else {
								strRet=" <a href='#' style='white-space:normal; color:blue' onclick='objScreen.btnReport_Click(\"" + rowData.EpisodeID + "\",\"" + "" + "\",\"" + row.OrdItemID + "\",\"" + pindex + "\");'><u>�ϱ�</u></a>";
							}
						
							return strRet;
						}
					}
				]],
				onResize: function () {
					$('#AntMonitor').datagrid('fixDetailRowHeight', pindex);
				},
				onLoadSuccess: function (data) {
					setTimeout(function () {
						$('#AntMonitor').datagrid('fixDetailRowHeight', pindex);
					}, 0);
				}				
			});
		},
		onClickCell: function(rindex,field,value){  //ˢ������ѡ�к�ִ�����飬����onClickCell
			if(field!="_expander"){
				var expander = $('#AntMonitor').datagrid('getExpander',rindex);  //��ȡչ����
				if(expander.length && expander.hasClass('datagrid-row-collapse')){
					$('#AntMonitor').datagrid('collapseRow',rindex); //�۵�
				} else {
					$('#AntMonitor').datagrid('expandRow',rindex);   //չ��		
				}	
			}
		},rowStyler: function(index,row){
			var ReportStr = row.ReportStr;
			if(ReportStr!=""){
				var strList = ReportStr.split("$$");
				var len = strList.length;
				var Flag=0;			
				for (var indx=0;indx<len;indx++){
					var arrInfo = strList[indx].split(",");
					var Status = arrInfo[4];
					if (Status=="�˻�"){
						Flag=Flag+1;
					}
				}
				if(Flag>0){
					return 'color:#FF34B3;'; 
				}
			}
		}
	});
	//״̬
	$HUI.combobox("#cboQryStatus", {
		editable:true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'DicDesc',
		onShowPanel:function(){
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode=ANTStatus&aActive=1";
			$("#cboQryStatus").combobox('reload',url);	
		}
	});
	
	//������ҩ
	$HUI.combobox("#cboAntiMast", {
		editable:true,
		defaultFilter:4,
		valueField: 'AntiMastID',
		textField: 'AntiMastDesc',
		onShowPanel:function(){
			var url=$URL+"?ClassName=DHCHAI.IRS.CRuleAntiSrv&QueryName=QryCRuleAnti&ResultSetType=array";
			$("#cboAntiMast").combobox('reload',url);	
		}
	});
	
	InitAntMoniWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}