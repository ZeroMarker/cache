//ҳ��Event
function InitMROBSItemMapWinEvent(obj){
	//������
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridMROBSItemMap"),value);
		}	
	});	
	$('#searchbox_two').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridMROBSItem"),value);
		}	
	});
	//�༭����
	obj.SetDiaglog=function(){
		$('#winEdit').dialog({
			title: '������Ŀ���ձ༭',
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
					$HUI.dialog('#winEdit').close();
				}
			}]
		});
	}
	//��ť��ʼ��
    obj.LoadEvent = function(args){ 
   		obj.gridMROBSItemMapLoad();
		//ȫ��
		$('#btnAll').on('click', function(){
			$("#gridMROBSItemMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.MROBSItemMapSrv",
				QueryName:"QryMROBSItemMap",
				aFlg:"",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridMROBSItemMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//δ����
		$('#btnPend').on('click', function(){
			$("#gridMROBSItemMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.MROBSItemMapSrv",
				QueryName:"QryMROBSItemMap",
				aFlg:"0",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridMROBSItemMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//�Ѷ���
		$('#btnFin').on('click', function(){
			$("#gridMROBSItemMap").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.DPS.MROBSItemMapSrv",
				QueryName:"QryMROBSItemMap",
				aFlg:"1",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridMROBSItemMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
		});
		//�Զ�ƥ��
		$('#btnSyn').on('click', function(){
			var flg = $m({
				ClassName:'DHCHAI.DPS.MROBSItemMapSrv',
				MethodName:'SynMapRule',
				aCatDesc:"������Ŀ",
				},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("������ʾ", "û�п�ƥ�����ƥ��ʧ��" , 'info');		
			}else {
				$.messager.popover({msg: '�ɹ�ƥ��'+flg+'��!',type:'success',timeout: 1000});
				//obj.gridMROBSItemMap.reload() ;//ˢ�µ�ǰҳ
				 obj.gridMROBSItemMapLoad();
			}
		});
		//�༭
		$('#btnEdit').on('click', function(){
			var rd=obj.gridMROBSItemMap.getSelected();
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
				obj.gridMROBSItemMap.load({
					ClassName:'DHCHAI.DPS.MROBSItemMapSrv',
					QueryName:'QryMROBSItemMap'
				});
			}	
		});
		$('#btnsearch_two').searchbox({
		    	searcher:function(value,name){
		    	obj.gridMROBSItem.load({
					ClassName:"DHCHAI.DPS.MROBSItemSrv",
					QueryName:"QryMROBSItem"
				});
		    },
		});**/
  }
  
  //˫���༭�¼�
	obj.gridMROBSItemMap_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//ѡ��
	obj.gridMROBSItemMap_onSelect = function (){
		var rowData = obj.gridMROBSItemMap.getSelected();
		
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridMROBSItemMap.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//����
	obj.btnSave_click = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		var BTItemDesc  = rd["BTItemDesc"];
        var MapItemDr = rd["MapItemDr"];
		var BTMapNote   = $('#txtMapNote').val();
		var BTSCode = rd["BTSCode"];
		var IsActive  =$("#chkIsActive").checkbox('getValue')? '1':'0';
	    var ActUser   = session['LOGON.GROUPDESC'];
	    
		var InputStr = ID;
		InputStr += "^" + BTItemDesc;
		InputStr += "^" + MapItemDr;
		InputStr += "^" + BTMapNote;
		InputStr += "^" + BTSCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
		var flg = $m({
				ClassName:"DHCHAI.DP.MROBSItemMap",
				MethodName:"Update",
				InStr:InputStr,
				aSeparete:"^"
			},false);
		if (parseInt(flg) <= 0) {
				$.messager.alert("������ʾ", "����ʧ��" , 'info');	
				return;	
			}else {
				$HUI.dialog('#winEdit').close();
				$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
				obj.RecRowID=flg;
				//obj.gridMROBSItemMap.reload() ;//ˢ�µ�ǰҳ
				obj.gridMROBSItemMapLoad();
			}
	}
	//����
	obj.btnAdd_click = function(){
		if($("#btnAdd").hasClass("l-btn-disabled")) return;
		var Maprd = obj.gridMROBSItemMap.getSelected();
		var Itemrd = obj.gridMROBSItem.getSelected();
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var ItemID = (Itemrd ? Itemrd["ID"] : '');
		if ((MapID == "")||(ItemID == "")) {
			$.messager.alert("������ʾ",'���ö��չ�ϵ��ͬʱѡ������Ŀ�ֵ估������Ŀ!','info');
			return;	
		}else{
			var flg = $m({
				ClassName:"DHCHAI.DPS.MROBSItemMapSrv",
				MethodName:"UpdateMap",
				ID:MapID,
				ItemID:ItemID,
				UserName:Maprd["ActUser"]
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("������ʾ", "����ʧ��" , 'info');	
				return;		
			}else {
				$.messager.popover({msg: '���ճɹ�',type:'success',timeout: 1000});
				//obj.gridMROBSItemMap.reload() ;//ˢ�µ�ǰҳ
				 obj.gridMROBSItemMapLoad();
			}
		}
	}
	//����
	obj.btnDelete_click = function(){
		if($("#btnDelete").hasClass("l-btn-disabled")) return;
		var rd = obj.gridMROBSItemMap.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["MapItemID"]=="") {
			$.messager.alert("������ʾ",'û�ж��չ�ϵ�����ɳ���!','info');
			return;	
		}else{
			$.messager.confirm("����", "ȷ���Ƿ������չ�ϵ��", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.DP.MROBSItemMap",
					MethodName:"DeleteMapById",
					Id:ID
				},false);
				if (parseInt(flg) < 0) {
						$.messager.alert('����ʧ��','info');	
						return;				
				} else {
					$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});
					//obj.gridMROBSItemMap.reload() ;//ˢ�µ�ǰҳ
					 obj.gridMROBSItemMapLoad();
				}
			} 
		});
		}
	}
	obj.InitDialog= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			obj.layer_rd=rd
			var MapNote = rd["MapNote"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=="1"? true: false)
			$('#txtMapNote').val(MapNote);
			$('#chkIsActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID="";
			obj.layer_rd=""
			$('#txtMapNote').val('');
			$('#chkIsActive').checkbox('setValue',false);
		}
			$('#winEdit').show();
			obj.SetDiaglog();
	}
	obj.gridMROBSItemMapLoad = function(){
		$("#gridMROBSItemMap").datagrid("loading");	
		$cm ({
		    ClassName:"DHCHAI.DPS.MROBSItemMapSrv",
			QueryName:"QryMROBSItemMap",		
	    	page:1,
			rows:200
		},function(rs){
			$('#gridMROBSItemMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
    }
}