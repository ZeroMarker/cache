var objOrder = new Object();	
function ShowMakeOrderDialog(){
	$.parser.parse(); // ��������ҳ��
	objOrder.replaceIndex=-1;	//�滻���
	objOrder.IsHaveDown=[];
	objOrder.IsChecking=false;	//��ֹ��ѭ��
	objOrder.IsUnChecking=false;
	objOrder.OrdContent=[];
	InitOCPWInfo();
	$('#OStepMore').on('click', function(){
		var Emvalue = $('#OStepMore').attr("value");
		ShowOSetpMore(Emvalue);
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
			return value + ' , ��( ' + rows.length + ' )��';
			},
		scrollbarSize: 0,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: false,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
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
						return "<span id='"+id+"'>"+value+chkPosDesc+"</span><label id= 'pop"+FJid+"' style='color:red;' onmouseover=ShowFJDetail("+FJid+") onmouseout=DestoryFJDetail("+FJid+")>[��ϸ]</label>"
					}else{
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"'>"+value+chkPosDesc+"</span>"
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
			{field:'OrdIsDefault',title:'��ѡҽ��',width:'70'},
			{field:'OrdIsFluInfu',title:'��ҽ��',width:'70'},
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
					if(data.rows[i].OrdCatCode != OrderType){
						// ���Ͳ�һ����Ϊ������
						$("input[type='checkbox']")[i+1].disabled = true;
						
						//ֱ�ӹ��˸������ݲ���ʾ
						//$("#CPWItemOrder").datagrid("deleteRow", i);
						//i=i-1;
					} else {
						if (data.rows[i].OrdIsDefault=="��") {	//��ѡҽ��
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
				$.messager.popover({msg: '��ǰ�����ֹ������ҽ����',type:'alert'});	
				return false;
			}
			if(row['xID'].indexOf("FJ")>-1){
				$.messager.popover({msg: '�Զ��巽����֧�ִ˲�����',type:'alert'});	
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
				$('#gridGeneOrder').datagrid({'title':'��ǰҽ����'+OrdMastIDDesc});
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
			if(field=="OrdGeneIDDesc"){
				/* objOrder.replaceIndex=index;
				var selData = $('#CPWItemOrder').datagrid('getRows')[index];
				var ArcimID=selData['OrdMastID']
				var OrdMastIDDesc=selData['OrdMastIDDesc']
				$('#gridGeneOrder').datagrid({'title':'��ǰҽ����'+OrdMastIDDesc});
				objOrder.gridGeneOrder.load({
					ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
					QueryName:"QryOrderListByGene",
					aEpisodeID:EpisodeID.split("!!")[0],
					aArcimID:ArcimID
				});
				$HUI.dialog('#GeneCPWDialog').open(); */
			}else if(field=="OrdMastIDDesc"){
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
		onUnselect: function(index, row){
			var selData = $('#CPWItemOrder').datagrid('getRows')[index];
			var FormOrdID=selData['xID']
			var id=FormOrdID.split("||").join("-")
			//$("#"+id).popover('hide');
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
			var ItemDesc = row['ItemDesc'];
			if(ordLinkNum == "") return;
			objOrder.IsChecking=true;
			var Rows=$('#CPWItemOrder').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				if((selData['OrdLnkOrdDr'] == ordLinkNum)&&(selData['ItemDesc']==ItemDesc)){	//��ͬ�����ŵ�ҽ��ͬʱ����
					$("#CPWItemOrder").datagrid("selectRow", ind);
					$("#CPWItemOrder").datagrid("checkRow", ind);
				}
			}
			objOrder.IsChecking=false;
		},
		onUncheck: function(index, row){
			if(objOrder.IsUnChecking) return;			
			var ordLinkNum=row['OrdLnkOrdDr'];
			var ItemDesc = row['ItemDesc'];
			if(ordLinkNum == "") return;
			objOrder.IsUnChecking=true;
			var Rows=$('#CPWItemOrder').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				if((selData['OrdLnkOrdDr'] == ordLinkNum)&&(selData['ItemDesc']==ItemDesc)){	//��ͬ�����ŵ�ҽ��ͬʱ����
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
	$('#Addorder').on('click', function(){
		AddOrderToEntry();
	})
	$('#GetHelp').on('click', function(){
		$HUI.dialog('#HelpCPWDialog').open();
	})
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
	//ͬͨ����ҽ���б�
  	objOrder.gridGeneOrder = $HUI.datagrid("#gridGeneOrder",{
		fit: true,
		pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
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

}

AddOrderToEntry = function(){
	var rows = $('#CPWItemOrder').datagrid("getChecked");
	if(rows.length==0) {
		$.messager.popover({msg: 'δ��ѡ�κ�ҽ��!��',type:'alert'});	 
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

	$.messager.confirm("���", "����n����ҽ�����m����ҽ����<br>ȷ��Ҫ�����".replace("n",cntAcrItm).replace("m",cntArcCos), function (r) {
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
							strOrder += '^' + "."+i;
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
						}
						var posStr=groups[ind][i].OrdChkPosID
						if(posStr!=""){
							strOrder += '^' + posStr.split("||")[1];
						}
						strOrderList +=  CHR_1 + strOrder;
					}
				}
			}

			if(strOrderList!=""){
				console.log(strOrderList)
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
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-D">��</span>'
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-B">��</span>'
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-T">T</span>'
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-Y">��</span>'
		$('#OCPWIcon').html(htmlIcon)
		$(".OIcon-D").popover({
			content: '��������Ϣ��' + JsonObj.SDDesc
		});
		$(".OIcon-B").popover({
			content: JsonObj.VarDesc
		});
		$(".OIcon-T").popover({
			content: '�뾶������' + JsonObj.CPWDays + '��<br />�ƻ�������' + JsonObj.FormDays + '��'
		});
		$(".OIcon-Y").popover({
			content: 'סԺ�ܷ��ã�' + JsonObj.PatCost + '<br />�ƻ����ã�' + JsonObj.FormCost + 'Ԫ'
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
		objOrder.TimeList=StepsArr[2].split("^");			//��·�����в�����ֹʱ�����飬EpDays:SttDate:EndDate
		objOrder.ConfList=StepsArr[3].split("^");			//��·�����в����Ƿ�ȷ�����飬1��0
		objOrder.SignList=StepsArr[4].split("^");			//��·�����в���ǩ����Ϣ���飬SignDoc:SignNur:SignDocDate:SignNurDate
		objOrder.StepSelecedID=objOrder.StepCurrID;				//���ѡ�еĲ���ID
		objOrder.CurrIndex=objOrder.StepList.indexOf(StepCurr);	//�Ѿ�ִ�е���ǰ������±�
		
		//չ�ֲ���
		ShowCPWSteps(objOrder.CurrIndex);
		//�󶨵���¼�
		$('#OStepMoreList .OselectStepMore').on('click', function(){
			SelectStep(this.id);
		});
		$('#OStepShow .Ostep').on('click', function(){
			var SelectedStepID=this.id.split("-")[1];
			objOrder.StepSelecedID=SelectedStepID;
			SelectStep(this.id);
			ShowStepDetail(this.id);
		});
		//չ�ֲ�������
		SelectStep("OStep-"+objOrder.StepCurrID);
	});	
	
}

//չ�ֲ���
ShowCPWSteps = function(selectIndex){
	var StepSelect=objOrder.TimeList[selectIndex].split(":");
	$('#OStepTime').text(StepSelect[0]);
	$('#ODateFrom').datebox('setValue',StepSelect[1]);
	$('#ODateTo').datebox('setValue',StepSelect[2]);
	
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
	if(objOrder.StepSelecedID != objOrder.StepCurrID) {	//�ǵ�ǰ���費�������ҽ��
		$("#Addorder").linkbutton("disable");
	}else{
		$("#Addorder").linkbutton("enable");
	}
	//������չ�ֲ���
	ShowCPWSteps(SelectedIndex);
	//չ�ֲ�������
	ShowStepDetail(IDStr);
	//�󶨵���¼�
	$('#OStepMoreList .OselectStepMore').on('click', function(){
		SelectStep(this.id);
	});
	$('#OStepShow .Ostep').on('click', function(){
		var SelectedStepID=this.id.split("-")[1];
		objOrder.StepSelecedID=SelectedStepID;
		SelectStep(this.id);
		ShowStepDetail(this.id);
	});
	ShowOSetpMore(0)	//�رո��ಽ��
}

ShowStepDetail = function(IDStr){
	$("#OStepShow .Ostep").removeClass('selected');
	$("#"+IDStr).addClass('selected');
	$m({
		ClassName:"DHCMA.CPW.CPS.ImplementSrv",
		MethodName:"GetOrdItmTree",
		aPathwayID: objOrder.PathwayID, 
		aEpisID: objOrder.PathwayID+"||"+objOrder.StepSelecedID
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
				
				$cm ({
					ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
					QueryName:"QryPathFormEpItemOrdAll",
					ResultSetType:"array",
					aPathFormEpDr:PathFormEpID,
					aPathFormEpItemDr:PathFormEpItemID,
					page:1,
					rows:999
				},function(rs){
					$('#CPWItemOrder').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
				});
			},
			onLoadSuccess: function(node, data){
				if(data.length>0){
					var rootID=data[0].id;
					var node = $('#OItemTree').tree('find', rootID);
					$('#OItemTree').tree('select', node.target);
					$('#OItemTree').tree('check', node.target);
					PathFormEpID=rootID.split("-")[2];
					
					$cm ({
						ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
						QueryName:"QryPathFormEpItemOrdAll",
						ResultSetType:"array",
						aPathFormEpDr:PathFormEpID,
						aPathFormEpItemDr:"",
						page:1,
						rows:999
					},function(rs){
						$('#CPWItemOrder').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
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
		$('#OStepMore').text("�����");
	}else{
		$('#OStepMore').text("���਋");
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
DestoryFJDetail = function(FJid){
	$('#pop'+FJid).popover('destroy');
}
