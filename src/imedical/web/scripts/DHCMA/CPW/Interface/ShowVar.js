//window.onbeforeunload = BeforeClose;
function BeforeClose(e){
	e = e || window.event;

	if($('#CPWVarOrder').datagrid("getRows").length != 0){
		//ɾ���Ѿ���ӵı���ԭ��
		var ret=$m({ClassName:"DHCMA.CPW.CPS.InterfaceSrv",MethodName:"DeleteTmpVarOrd",aFlg:"Y"},false)
		if (websys_showModal("options").CallBackFunc) {
			websys_showModal("options").CallBackFunc(false);
		}else{
			window.returnValue = false;	//���ظ�ҽ��վ
		}
	}else{
		//�����ʱ����
		var ret=$m({ClassName:"DHCMA.CPW.CPS.InterfaceSrv",MethodName:"DeleteTmpVarOrd",aFlg:"N"},false)
		if (websys_showModal("options").CallBackFunc) {
			websys_showModal("options").CallBackFunc(true);
		}else{
			window.returnValue = true;	//���ظ�ҽ��վ
		}
	}
}

var objVar = new Object();	
function ShowMakeOrderDialog(){
	$.parser.parse(); // ��������ҳ�� 
	InitVCPWInfo();
	
	$m({
		ClassName:"DHCMA.CPW.CPS.ImplementSrv",
		MethodName:"GetVariatTree",
		aTypeCode: "01", 
		aCatCode: ""
	},function(treeJson){
		var dataArr=$.parseJSON(treeJson)
		$('#VarTree').tree({
			data: dataArr,
			formatter:function(node){
				//formatter  ��ʱisLeaf�������޷��ж��ǲ���Ҷ�ӽڵ� ��ͨ��children
				if (node.children){
					return node.text;
				}else{
					len=node.text.length;
					if (len<15) {
						return node.text;
					}else{
						return node.text.substring(0,15)+"<br />"+node.text.substring(15)
					}
					/* return "<div >"
						+"<span data-id='"+node.id+"' class='icon-write-order' style='display:block;width:16px;height:16px;position:absolute;right:5px;top:5px;'></span>"
						+"<div style='height:20px;line-height:20px;color:gray'>"+(new Date()).toLocaleString()+"</div>"
						+"<div style='height:20px;line-height:20px;'>"+node.text+"</div>"
						+"</div>";
					//ͬʱ�������µ�tree-node ����position: relative;   ��ʵ��Сͼ�꿿�� */
				}
				
			},
			onClick: function(node){
				//alert(node.text);  // alert node text property when clicked
			},
			lines:true,autoNodeHeight:true
		})
	});	
	
	//����ҽ��
	objVar.CPWVarOrder = $HUI.datagrid("#CPWVarOrder",{
		fit: true,
		pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���
		singleSelect: false,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
			QueryName:"QryCPWVarOrder",		
			aEpisodeID:EpisodeID, 
			aOEItmMastList:OEItmMastList,
			alocID:session['LOGON.CTLOCID'],
			aWardID:session['LOGON.WARDID']
	    },
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'ind',title:'���',align:'center',width:''},
			{field:'ARCIMDesc',title:'ҽ������',width:'300'},
			//{field:'VariatCat',title:'�������',width:'200'},
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
			if (rindex>-1) {
				$('#CPWVarOrder').datagrid("beginEdit", rindex);
				var ed = $(this).datagrid('getEditor', {index:rindex,field:'VariatTxt'});
				$(ed.target).focus();
			}
			
		},
		onClickRow: function(rowIndex,rowData){			
			$('#CPWVarOrder').datagrid('selectRow', rowIndex)
				.datagrid('beginEdit', rowIndex);	
			var ed = $(this).datagrid('getEditor', {index:rowIndex,field:'VariatTxt'});
			$(ed.target).focus();
		}
	});
	
	//·����ҽ�����������Ϣ
	$('#Var-Order-Save').on('click', function(){
		SaveOrderVar();
	})
	//·����ҽ������������Ϣ
	$('#Var-Order-Cancel').on('click', function(){
		CancelOrderVar();
	})
		
}
//·����Ϣ
InitVCPWInfo = function(){
	$m({
		ClassName:"DHCMA.CPW.CPS.ImplementSrv",
		MethodName:"GetCPWInfo",
		aEpisodeID:EpisodeID
	},function(JsonStr){
		var JsonObj=$.parseJSON( JsonStr ); 
		$('#VCPWDesc').text(JsonObj.CPWDesc)
		$('#VCPWEpisDesc').text(JsonObj.CPWEpisDesc)
		objVar.PathwayID=JsonObj.PathwayID;
		objVar.EpisID=JsonObj.CPWEpisID;
		
		objVar.CPWVarOrder.load({
			ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
			QueryName:"QryCPWVarOrder",		
			aEpisodeID:EpisodeID, 
			aOEItmMastList:OEItmMastList,
			alocID:session['LOGON.CTLOCID'],
			aWardID:session['LOGON.WARDID']
		});	
	});
}
SaveOrderVar = function(){
	var Node=$('#VarTree').tree('getSelected');
	if(Node){
		var IsLeaf=$('#VarTree').tree('isLeaf',Node.target)
		if(IsLeaf){
			var rows = $('#CPWVarOrder').datagrid("getSelections");
			for (var ind=0,len=rows.length;ind<len;ind++){
				var RowIndex=$('#CPWVarOrder').datagrid("getRowIndex",rows[ind]);
				var ed = $('#CPWVarOrder').datagrid('getEditor', { index: RowIndex, field: 'VariatTxt' });
				var VariatTxt = ""
				if (ed) VariatTxt = $(ed.target).val();
				var rowData = rows[ind]
				var Node=$('#VarTree').tree('getSelected');
				var EpisID=objVar.PathwayID+"||"+objVar.EpisID;
				var ImplID="";	//·����ҽ��û�й�����Ŀ
				var OrdDID=rowData['ARCIMID'];
				var VarID=""
				
				var InputStr=objVar.PathwayID+"^"+VarID+"^"+Node.id.split("-")[1]+"^"+VariatTxt+"^"+EpisID+"^"+ImplID+"^"+OrdDID+"^"+session['DHCMA.USERID'];
				var ret=$m({
					ClassName:"DHCMA.CPW.CP.PathwayVar",
					MethodName:"Update",
					aInputStr:InputStr,
					aSeparete:"^"
				},false)
				if (parseInt(ret) > 0) {
					$('#CPWVarOrder').datagrid("deleteRow", RowIndex);
				}
			}
			$('#VarTree').find('.tree-node-selected').removeClass('tree-node-selected');
		}else{
			$.messager.popover({
					msg: '����ѡ��ԭ�����',
					type:'error',
					style:{
						top:150,
						left:450
					}
				});
			return;
		}
	}else{
		$.messager.popover({
			msg: '��ѡ�����ԭ��',
			type:'error',
			style:{
				top:150,
				left:450
			}
		});
		return;
	}
	var OrdItemList = $('#CPWVarOrder').datagrid("getRows").length;
	websys_showModal("options").onBeforeClose(OrdItemList);
}
CancelOrderVar = function(){
	var rows = $('#CPWVarOrder').datagrid("getSelections");
	for (var ind=0,len=rows.length;ind<len;ind++){
		var VarID=rows[ind]['VarID'];
		if(VarID=="") continue;
		$m({
			ClassName:"DHCMA.CPW.CP.PathwayVar",
			MethodName:"Invalid",
			aID:objVar.PathwayID+"||"+VarID,
			aUserID:session['DHCMA.USERID']
		},function(ret){
			if(parseInt(ret)>0){
			}
		})
	}
	$('#CPWVarOrder').datagrid('reload');
}