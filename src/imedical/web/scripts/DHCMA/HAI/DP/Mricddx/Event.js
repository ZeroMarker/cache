//ҳ��Event
function InitDictionaryWinEvent(obj){
	//������
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			obj.gridMRICDDxMap.reload();
			searchText($("#gridMRICDDxMap"),value);
		}	
	});	
	/**
	$('#searchbox_two').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridMRICDDx"),value);
		}	
	});	**/
	//�༭����
	obj.SetDiaglog2=function(){
		$('#winEdit2').dialog({
			title: '����ֵ������Ŀ�༭',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'����',
				handler:function(){
					obj.btnSave_click();
				}
			},{
				text:'�ر�',
				handler:function(){
					$HUI.dialog('#winEdit2').close();
				}
			}]
		});
	}
	
	//�༭����2
	obj.SetDiaglog=function(){
		$('#winEdit').dialog({
			title: '�����Ŀ�༭',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'����',
				handler:function(){
					obj.btnSave2_click();
				}
			},{
				text:'�ر�',
				handler:function(){
					$HUI.dialog('#winEdit').close();
				}
			}]
		});
	}
	//��ť��ʼ��
    obj.LoadEvent = function(args){ 
    	obj.gridMRICDDxMapLoad();
		//ȫ��
		$('#btnAll').on('click', function(){
			$("#gridMRICDDxMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.MRICDDxMapSrv",
				QueryName:"QryMRICDDxMap",
				aFlg:"",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridMRICDDxMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//δ����
		$('#btnPend').on('click', function(){
			$("#gridMRICDDxMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.MRICDDxMapSrv",
				QueryName:"QryMRICDDxMap",
				aFlg:"0",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridMRICDDxMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//�Ѷ���
		$('#btnFin').on('click', function(){
			$("#gridMRICDDxMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.MRICDDxMapSrv",
				QueryName:"QryMRICDDxMap",
				aFlg:"1",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridMRICDDxMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//�Զ�ƥ��
		$('#btnSyn').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.DPS.MRICDDxMapSrv',
				MethodName:'SynMapRule',
				aCatDesc:"�����Ŀ",
				},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("������ʾ", "û�п�ƥ�����ƥ��ʧ��" , 'info');		
			}else {
				$.messager.popover({msg: '�ɹ�ƥ��'+flg+'��!',type:'success',timeout: 1000});
				//obj.gridMRICDDxMap.reload() ;//ˢ�µ�ǰҳ
				obj.gridMRICDDxMapLoad();
			}
		});
		//�༭
		$('#btnEdit').on('click', function(){
			var rd=obj.gridMRICDDxMap.getSelected();
			obj.InitDialog(rd);
		});
		//����
		$('#btnAdd').on('click', function(){
			obj.btnAdd_click();
		});
		//����
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		/**$('#search').searchbox({ 
			searcher:function(value,name){ 
				obj.gridMRICDDxMap.load({
					ClassName:'DHCHAI.DPS.MRICDDxMapSrv',
					QueryName:'QryMRICDDxMap'
				});
			}	
		});
		$('#btnsearch_two').searchbox({
		    	searcher:function(value,name){
		    	obj.gridMRICDDx.load({
					ClassName:"DHCHAI.DPS.MROBSItemSrv",
					QueryName:"QryMROBSItem"
				});
		    },
		});**/
		
		$('#btnAdd_one').on('click', function(){
			obj.InitDialog2();
		});
		$('#btnEdit_one').on('click', function(){
			var rd=obj.gridMRICDDx.getSelected();
			obj.InitDialog2(rd);
		});
		$('#btnDelete_one').on('click', function(){
			obj.btnDelete_oneclick();
		});
  }
  //˫���༭�¼�
	obj.gridMRICDDxMap_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//ѡ��
	obj.gridMRICDDxMap_onSelect = function (){
		var rowData = obj.gridMRICDDxMap.getSelected();
		
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridMRICDDxMap.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//˫�������Ŀ�ֵ�
	obj.gridMRICDDx_onDbselect = function(rd){
		obj.InitDialog2(rd);
	}
	
	//�����¼�
	obj.gridMRICDDx_onSelect = function (rd,yindex){
		var yindex=yindex-1;
		if (rd["ID"] == obj.RecRowID2) {
			obj.RecRowID2="";
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridMRICDDx.clearSelections();
		} else {
			obj.RecRowID2 = rd["ID"];
			$("#btnAdd_one").linkbutton("disable");
			$("#btnEdit_one").linkbutton("enable");
			$("#btnDelete_one").linkbutton("enable");
		}
	}
	//����
	obj.btnSave_click = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		var DiagDesc  = rd["BTDiagDesc"];
        var MapItemDr = rd["MapItemDr"];
		var MapNote   = $('#txtMapNote').val();
		var MapSCode = rd["BTSCode"];
		var IsActive  =$("#chkMapActive").checkbox('getValue')? '1':'0';
	    var ActUser   = session['LOGON.GROUPDESC'];
	    
		var InputStr = ID;
		InputStr += "^" + DiagDesc;
		InputStr += "^" + MapItemDr;  
		InputStr += "^" + MapNote;  
		InputStr += "^" + MapSCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
		var flg = $m({
				ClassName:"DHCHAI.DP.MRICDDxMap",
				MethodName:"Update",
				InStr:InputStr,
				aSeparete:"^"
			},false);
		if (parseInt(flg) <= 0) {
				$.messager.alert("������ʾ", "����ʧ��" , 'info');	
				return;	
			}else {
				$HUI.dialog('#winEdit2').close();
				$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
				obj.RecRowID=flg;
				//obj.gridMRICDDxMap.reload() ;//ˢ�µ�ǰҳ
				obj.gridMRICDDxMapLoad();
			}
	}
	//����
	obj.btnAdd_click = function(){
		if($("#btnAdd").hasClass("l-btn-disabled")) return;
		var Maprd = obj.gridMRICDDxMap.getSelected();
		var Itemrd = obj.gridMRICDDx.getSelected();
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var ItemID = (Itemrd ? Itemrd["ID"] : '');
		if ((MapID == "")||(ItemID == "")) {
			$.messager.alert("������ʾ",'���ö��չ�ϵ��ͬʱѡ�������Ŀ�ֵ估������Ŀ!','info');
			return;	
		}else{
			var flg = $m({
				ClassName:"DHCHAI.DPS.MRICDDxMapSrv",
				MethodName:"UpdateMap",
				ID:MapID,
				ICDDxID:ItemID,
				UsersName:Maprd["ActUser"]
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("������ʾ", "����ʧ��" , 'info');	
				return;		
			}else {
				$.messager.popover({msg: '���ճɹ�',type:'success',timeout: 1000});
				//obj.gridMRICDDxMap.reload() ;//ˢ�µ�ǰҳ
				obj.gridMRICDDxMapLoad();
			}
		}
	}
	//����
	obj.btnDelete_click = function(){
		if($("#btnDelete").hasClass("l-btn-disabled")) return;
		var rd = obj.gridMRICDDxMap.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["MapItemID"]=="") {
			$.messager.alert("������ʾ",'û�ж��չ�ϵ�����ɳ���!','info');
			return;	
		}else{
			$.messager.confirm("����", "ȷ���Ƿ������չ�ϵ��", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.MRICDDxMap",
					MethodName:"DeleteMapById",
					Id:ID
				},false);
				if (parseInt(flg) < 0) {
						$.messager.alert('����ʧ��','info');	
						return;				
				} else {
					$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});
					//obj.gridMRICDDxMap.reload() ;//ˢ�µ�ǰҳ
					obj.gridMRICDDxMapLoad();
				}
			} 
		});
		}
	}
	//���������Ŀ�ֵ�
	obj.btnSave2_click = function(){
		var errinfo = "";
		var rd = obj.layer2_rd;
		var ID = (rd ? rd["ID"] : '');
		var BTCode = $('#txtBTCode').val();
		var BTDesc = $('#txtBTDesc').val();
		var IsActive  =$("#chkActive").checkbox('getValue')? '1':'0';

		var InputStr = ID;
		InputStr += "^" + BTCode;
		InputStr += "^" + BTDesc;
		InputStr += "^" + IsActive;
		
		if (!BTCode) {
			errinfo = errinfo + "���벻����Ϊ��!<br>";
		}
		if (!BTDesc) {
			errinfo = errinfo + "���Ʋ�����Ϊ��!<br>";
		}
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		var flg = $m({
				ClassName:"DHCHAI.DP.MRICDDx",
				MethodName:"Update",
				InStr:InputStr,
				aSeparete:"^"
			},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg)=='-100'){
				$.messager.alert("������ʾ", "���롢�����ظ�!" , 'info');
			}else{
				$.messager.alert("������ʾ", "����ʧ��" , 'info');	
				return;	}
			}else {
				$HUI.dialog('#winEdit').close();
				$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
				obj.RecRowID=flg;
				obj.gridMRICDDx.reload() ;//ˢ�µ�ǰҳ
			}
	}
	//ɾ������
	obj.btnDelete_oneclick = function(){
		var rd = obj.gridMRICDDx.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (ID==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.MRICDDx",
					MethodName:"DeleteById",
					Id:ID
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("������ʾ","����ֵ�-777����ǰ��ɾ��Ȩ�ޣ�������ɾ��Ȩ�޺���ɾ����¼!",'info');
					}else {
						$.messager.alert("������ʾ","ɾ��ʧ��" + flg, 'info');
					}
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ�!',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					obj.gridMRICDDx.reload() ;//ˢ�µ�ǰҳ
				}
			}
		});
	}
	obj.InitDialog= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			obj.layer_rd=rd
			var MapNote = rd["BTMapNote"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=="1"? true: false)
			$('#txtMapNote').val(MapNote);
			$('#chkMapActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID="";
			obj.layer_rd=""
			$('#txtMapNote').val('');
			$('#chkMapActive').checkbox('setValue',false);
		}
			$('#winEdit2').show();
			obj.SetDiaglog2();
	}
	obj.InitDialog2= function(rd){
		if(rd){
			obj.RecRowID2=rd["ID"];
			obj.layer2_rd=rd
			var BTCode = rd["BTCode"];
			var BTDesc = rd["BTDesc"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=="1"? true: false)
			$('#txtBTCode').val(BTCode);
			$('#txtBTDesc').val(BTDesc);
			$('#chkActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID2="";
			obj.layer2_rd=""
			$('#txtBTCode').val('');
			$('#txtBTDesc').val('');
			$('#chkActive').checkbox('setValue',false);
		}
			$('#winEdit').show();
			obj.SetDiaglog();
	}
	obj.gridMRICDDxMapLoad = function(){
		$("#gridMRICDDxMap").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.MRICDDxMapSrv",
			QueryName:"QryMRICDDxMap",		
	    	page:1,
			rows:99999
		},function(rs){
			$('#gridMRICDDxMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}