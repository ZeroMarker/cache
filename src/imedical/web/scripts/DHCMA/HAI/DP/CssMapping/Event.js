//ҳ��Event
function InitBaseMappingWinEvent(obj){
	//������
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridBaseMapping"),value);
		}	
	});
	$('#searchbox2').searchbox({ 
		searcher:function(value,name){
			//searchText($("#gridBaseRange"),value);
			var rowData = obj.gridBaseMapping.getSelected();
			var aType="";
			if (rowData) aType=rowData["Type"];
			obj.gridBaseRange.reload({
				ClassName:"DHCHAI.MAPS.CssMappingSrv",
				QueryName:"QryBaseRange",
				aType:aType,	
				aAlis:value
			});
		}	
	});
	$("#cboCat").combobox({
		onSelect:function(record){
			$cm ({
			    ClassName:"DHCHAI.MAPS.CssMappingSrv",
				QueryName:"QryBaseMapping",
				aType:record.xType,		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridBaseMapping').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
			obj.gridBaseRange.reload({
				ClassName:"DHCHAI.MAPS.CssMappingSrv",
				QueryName:"QryBaseRange",	
				aType:record.xType
			});					 	 
		}	 	
	})
	//�༭����
	obj.SetDiaglog2=function(){
		$('#winEdit2').dialog({
			title: 'ֵ���ֵ���ձ༭',
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
	//��ť��ʼ��
    obj.LoadEvent = function(args){ 
    	obj.gridBaseMappingLoad();
    	//����
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		//�༭
		$('#btnEdit').on('click', function(){
			var rd=obj.gridBaseMapping.getSelected();
			obj.InitDialog(rd);
		});
		//ɾ��
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		//δ����
		$('#btnNoMap').on('click', function(){
			obj.btnNoMap_click();
		});
		//δ����
		$('#btnAllMap').on('click', function(){
			obj.btnAllMap_click();
		});
		
		//����
		$('#btnAddMap').on('click', function(){
			obj.btnAdd_click();
		});
		//����
		$('#btnDelMap').on('click', function(){
			obj.btnDeleteMap_click();
		});
		/*$('#btnsearch_two').searchbox({
		    	searcher:function(value,name){
		    	obj.gridRBItmMast.load({
					ClassName:"DHCHAI.DPS.MROBSItemSrv",
					QueryName:"QryMROBSItem"
				});
		    },
		});*/
		
		$('#btnAdd_one').on('click', function(){
			obj.InitDialog2();
		});
		$('#btnEdit_one').on('click', function(){
			var rd=obj.gridBaseRange.getSelected();
			obj.InitDialog2(rd);
		});
		$('#btnDelete_one').on('click', function(){
			obj.btnDelete_oneclick();
		});
  }
	//�༭����2
	obj.SetDiaglog=function(){
		$('#winEdit').dialog({
			title: '��׼ֵ���ֵ�༭',
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
	//˫���༭�¼�
	obj.gridBaseMapping_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//ѡ��
	obj.gridBaseMapping_onSelect = function (){
		var rowData = obj.gridBaseMapping.getSelected();
		
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnAddMap").linkbutton("disable");
			$("#btnNoMap").linkbutton("enable");
			$("#btnDelMap").linkbutton("disable");
			obj.gridBaseMapping.clearSelections();
		} else {  //ѡ��
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			$("#btnAddMap").linkbutton("enable");
			$("#btnNoMap").linkbutton("enable");
			$("#btnDelMap").linkbutton("enable");
			obj.gridBaseRange.reload({
				ClassName:"DHCHAI.MAPS.CssMappingSrv",
				QueryName:"QryBaseRange",	
				aType:rowData["Type"]
			});
		}
	}
	//˫�������Ŀ�ֵ�
	obj.gridBaseRange_onDbselect = function(rd){
		obj.InitDialog2(rd);
	}
	
	//�����¼�
	obj.gridBaseRange_onSelect = function (rd,yindex){
		var yindex=yindex-1;
		if (rd["ID"] == obj.RecRowID2) {
			obj.RecRowID2="";
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			obj.gridBaseRange.clearSelections();
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
		var RangeDr      = rd["RangeDr"];
		var txtBMType    = $('#txtBMType').val();
		var txtBMKeyVal  = $('#txtBMKeyVal').val();
		var txtBMKeyText = $('#txtBMKeyText').val();
		var IsActive     = $("#chkMapActive").checkbox('getValue')? '1':'0';
		var ActUserDr    = $.LOGON.USERID;
		
		var errinfo ="";
		if (!txtBMType) {
			errinfo = errinfo + "������벻����Ϊ��!<br>";
		}	
		if (!txtBMKeyVal) {
			errinfo = errinfo + "Ψһ��ֵ������Ϊ��!<br>";
		}
		if (!txtBMKeyText) {
			errinfo = errinfo + "��ֵ����������Ϊ��!<br>";
		}	
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
	
		var InputStr = ID;
		InputStr += "^" + txtBMType;
		InputStr += "^" + txtBMKeyVal;  
		InputStr += "^" + txtBMKeyText;  
		InputStr += "^" + RangeDr;
		InputStr += "^" + IsActive;
		InputStr += "^";
		InputStr += "^";
		InputStr += "^" + ActUserDr;
		var flg = $m({
				ClassName:"DHCHAI.MAP.CssMapping",
				MethodName:"Update",
				InStr:InputStr,
				aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg)=='-100'){
				$.messager.alert("������ʾ", "ͬ�����Ψһ��ֵ�������ظ�!" , 'info');
			}
			else
			{
				$.messager.alert("������ʾ", "����ʧ��" , 'info');	
			}				
			return;	
		}else {
				$HUI.dialog('#winEdit2').close();
				$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
				obj.RecRowID=flg;
				obj.gridBaseMappingLoad();
		}
	}
	//δ����
	obj.btnNoMap_click = function(){
		$cm ({
		    ClassName:"DHCHAI.MAPS.CssMappingSrv",
			QueryName:"QryBaseMapping",
			aType:"",
			aNoMapFlg:"1",		
	    	page:1,
			rows:200
		},function(rs){
			$('#gridBaseMapping').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
	}
	//ȫ��
	obj.btnAllMap_click = function(){
		$cm ({
		    ClassName:"DHCHAI.MAPS.CssMappingSrv",
			QueryName:"QryBaseMapping",
			aType:"",
			aNoMapFlg:"",		
	    	page:1,
			rows:200
		},function(rs){
			$('#gridBaseMapping').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
		});
	}
	//����
	obj.btnAdd_click = function(){
		var Maprd = obj.gridBaseMapping.getSelected();
		var Rangerd = obj.gridBaseRange.getSelected();
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var ItemID = (Rangerd ? Rangerd["ID"] : '');
		if ((MapID == "")||(ItemID == "")) {
			$.messager.alert("������ʾ",'���ö��չ�ϵ��ͬʱѡ������ֵ估��׼�����ֵ�!','info');
			return;	
		}else{
			var flg = $m({
				ClassName:"DHCHAI.MAPS.CssMappingSrv",
				MethodName:"UpdateMap",
				ID:MapID,
				RangeID:ItemID,
				UserDr:$.LOGON.USERID
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("������ʾ", "����ʧ��" , 'info');	
				return;		
			}else {
				$.messager.popover({msg: '���ճɹ�',type:'success',timeout: 1000});
				$("#gridBaseMapping").datagrid("loading");	
				$cm ({
				    ClassName:"DHCHAI.MAPS.CssMappingSrv",
					QueryName:"QryBaseMapping",
					aType:Maprd["Type"],		
			    	page:1,
					rows:200
				},function(rs){
					$('#gridBaseMapping').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
				});
			}
		}
	}
	//����
	obj.btnDeleteMap_click = function(){
		var rd = obj.gridBaseMapping.getSelected();
		var ID  = (rd ? rd["ID"] : '');
		if (rd["RangeDr"]=="") {
			$.messager.alert("������ʾ",'û�ж��չ�ϵ�����ɳ���!','info');
			return;	
		}else{
			$.messager.confirm("����", "ȷ���Ƿ������չ�ϵ��", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.MAPS.CssMappingSrv",
					MethodName:"DeleteMapById",
					Id:ID
				},false);
				if (parseInt(flg) < 0) {
						$.messager.alert('����ʧ��','info');	
						return;				
				} else {
					$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});
					obj.gridBaseMappingLoad();
				}
			} 
		});
		}
	}
	//����������Ŀ�ֵ�
	obj.btnSave2_click = function(){
		var errinfo='';
		var rd = obj.layer2_rd;
		var ID = (rd ? rd["ID"] : '');
		var txtBRType = $('#txtBRType').val();
		var txtBRCode = $('#txtBRCode').val();
		var txtBRDesc = $('#txtBRDesc').val(); 
		var IsActive  = $("#chkActive").checkbox('getValue')? '1':'0'; 
	
		if (!txtBRType) {
			errinfo = errinfo + "������벻����Ϊ��!<br>";
		}	
		if (!txtBRCode) {
			errinfo = errinfo + "ֵ����벻����Ϊ��!<br>";
		}
		if (!txtBRDesc) {
			errinfo = errinfo + "ֵ�����Ʋ�����Ϊ��!<br>";
		}	
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		var InputStr = ID;
		InputStr += "^" + txtBRType;
		InputStr += "^" + txtBRCode;
		InputStr += "^" + txtBRDesc;
		InputStr += "^" + IsActive;
		
		var flg = $m({
				ClassName:"DHCHAI.MAP.CssRange",
				MethodName:"Update",
				InStr:InputStr,
				aSeparete:"^"
			},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg)=='-100'){
				$.messager.alert("������ʾ", "ͬ����Ĵ��벻�����ظ�!" , 'info');
			}else{
				$.messager.alert("������ʾ", "����ʧ��" , 'info');	
				return;	}
			}else {
				$HUI.dialog('#winEdit').close();
				$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
				obj.RecRowID=flg;
				obj.gridBaseRange.reload() ;//ˢ�µ�ǰҳ
			}
	}
	//ɾ������
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.MAP.CssMapping",
					MethodName:"DeleteById",
					Id:obj.RecRowID
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("������ʾ","-777����ǰ��ɾ��Ȩ�ޣ�������ɾ��Ȩ�޺���ɾ����¼!",'info');
					}else {
						$.messager.alert("������ʾ","ɾ��ʧ��" + flg, 'info');
					}
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ�!',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridBaseMappingLoad();
				}
			}
		});
	}
	//ɾ������
	obj.btnDelete_oneclick = function(){
		if (obj.RecRowID2==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.MAP.CssRange",
					MethodName:"DeleteById",
					Id:obj.RecRowID2
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("������ʾ","-777����ǰ��ɾ��Ȩ�ޣ�������ɾ��Ȩ�޺���ɾ����¼!",'info');
					}else {
						$.messager.alert("������ʾ","ɾ��ʧ��" + flg, 'info');
					}
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ�!',type:'success',timeout: 1000});
					obj.RecRowID2 = "";
					obj.gridBaseRange.reload();//ˢ�µ�ǰҳ
				}
			}
		});
	}
	obj.InitDialog= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			obj.layer_rd=rd;
			var Type = rd["Type"];
			var KeyVal = rd["KeyVal"];
			var KeyText = rd["KeyText"];
			var IsActive = rd["IsActive"];
			IsActive = (IsActive=="1"? true: false)
			$('#txtBMType').val(Type).validatebox("validate");
			$('#txtBMKeyVal').val(KeyVal).validatebox("validate");
			$('#txtBMKeyText').val(KeyText).validatebox("validate");
			$('#chkMapActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID="";
			obj.layer_rd=""
			$('#txtBMType').val("");
			$('#txtBMKeyVal').val("");
			$('#txtBMKeyText').val("");
			$('#chkMapActive').checkbox('setValue',true);
		}
			$('#winEdit2').show();
			obj.SetDiaglog2();
	}
	obj.InitDialog2= function(rd){
		if(rd){
			obj.RecRowID2=rd["ID"];
			obj.layer2_rd=rd
			var Type   = rd["Type"];
			var BRCode = rd["BRCode"];
			var BRDesc = rd["BRDesc"];
			var IsActive = rd["IsActive"];
			IsActive = (IsActive=="1"? true: false);
			$('#txtBRType').val(Type).validatebox("validate");
			$('#txtBRCode').val(BRCode).validatebox("validate");
			$('#txtBRDesc').val(BRDesc).validatebox("validate");
			$('#chkActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID2="";
			obj.layer2_rd=""
			$('#txtBRType').val("");
			$('#txtBRCode').val("");
			$('#txtBRDesc').val("");
			$('#chkActive').checkbox('setValue',true);
		}
			$('#winEdit').show();
			obj.SetDiaglog();
	}
	obj.gridBaseMappingLoad = function(){
			$("#gridBaseMapping").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.MAPS.CssMappingSrv",
				QueryName:"QryBaseMapping",
				aType:"",		
		    	page:1,
				rows:200
			},function(rs){
				$('#gridBaseMapping').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
	    }
}