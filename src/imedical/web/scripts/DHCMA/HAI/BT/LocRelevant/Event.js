//ҳ��Event
function InitLocRelevWinEvent(obj){
	/*$HUI.combobox('#cboCat',{
		onChange:function(){
    			obj.gridLocRelevLoad();
		}
	});*/
	//������
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridLoc"),value);
		}	
	});
	
	//�༭����
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '��������Ա༭',
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
					$HUI.dialog('#layer').close();
				}
			}]
		});
	}
		//��ť��ʼ��
    obj.LoadEvent = function(args){ 
    	obj.gridLocRelevLoad();
    	obj.gridLocLoad('');
		//����
		$('#btnAdd').on('click', function(){
			$.messager.alert("��ʾ" , '��ѡ������б�ʱ����Ҳ��б�Ĺ�����ť�������!');
		});
    	//�޸�
		$('#btnEdit').on('click', function(){
			var rd=obj.gridLocRelev.getSelected();
			obj.InitDialog(rd);
		});
		//ɾ��
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
    }
    
		//������ȡ��������ť(���)
		obj.Relev_Click = function(aLocID,aRelevID){
			var errinfo="";
			var selectedRows = obj.gridLocRelev.getSelected();
			if ( selectedRows == null ) {
				//�������������
				obj.ClickLocID = aLocID;
				obj.InitDialog();
				return;
			} else {
				//�ж� ȡ��������
				if((aRelevID==1)&&(obj.relevCount==1)){
					errinfo = errinfo + "����ɾ����ť!";
				}
				if (errinfo != '') {
					$.messager.alert('info', errinfo);
					return;
				}
				//������ȡ������
				obj.ClickLocID = "";
				var rd = obj.gridLocRelev.getSelected();
				
				var flg = $m({
					ClassName:"DHCHAI.BTS.LocRelevantSrv",
					MethodName:"relateRelevLoc",
					aRelevID:obj.RecRowID,
					aLocID:aLocID,
					aUserID:$.LOGON.USERID
				},false);
				if (parseInt(flg) <= 0) {
					$.messager.alert("����ʧ��!Error=" + flg, 'info');
				}else{
					$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
					obj.gridLocRelevLoad();
					obj.gridLocLoad(obj.RecRowID);//ˢ�µ�ǰҳ
				}
			}
	    }
    //˫���༭�¼�
	obj.gridLocRelev_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//����
	obj.btnSave_click = function(){
		var rd = obj.layer_rd;
		var errinfo = "";
		var LocIDList = (rd ? rd["LocIDList"].split(",").join("|") : '');
		var Name = $('#txtName').val();
		var IsActive = $("#chkActive").checkbox('getValue')? '1':'0';
		var CatValue = $('#cboCat').combobox('getValue');
		
		if (!CatValue) {
			errinfo = errinfo + "���಻��Ϊ��!<br>";
		}	
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
		var InputStr = obj.RecRowID;
		InputStr += "^" + Name;
		InputStr += "^" + CatValue;
		InputStr += "^" + (LocIDList==""?obj.ClickLocID:LocIDList);
		InputStr += "^" + IsActive;
		InputStr += "^^^" + $.LOGON.USERID;
		var flg = $m({
			ClassName:"DHCHAI.BT.LocRelevant",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if(parseInt(flg) == -2){
				$.messager.alert("�����ظ�!" , 'info');
			}else{
				$.messager.alert("����ʧ��!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.RecRowID = flg
			obj.gridLocRelevLoad();//ˢ�µ�ǰҳ
		}
	}
	//ɾ��
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("��ʾ", "ѡ�����ݼ�¼,�ٵ��ɾ��!", 'info');
			return;
		}
		$.messager.confirm("ɾ��", "�Ƿ�ɾ��ѡ�����ݼ�¼?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.BT.LocRelevant",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("ɾ��ʧ��!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridLocRelevLoad();//ˢ�µ�ǰҳ
				}
			} 
		});
	}
	
	//ѡ��
	obj.gridLocRelev_onSelect = function (){
		var rowData = obj.gridLocRelev.getSelected();
		var Parref  = (rowData ? rowData["ID"] : '');
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridLocRelev.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
		obj.gridLocLoad(Parref);
	}
	obj.gridLoc_onSelect=function(){
		var rowData = obj.gridLoc.getSelected();
	}
    
    obj.InitDialog= function(rd){
		if(rd){
			obj.RecRowID=rd["ID"];
			obj.layer_rd=rd
			var Name = rd["Name"];
			var IsActive = rd["IsActive"];
			IsActive = (IsActive=="1"? true: false)
			$('#txtName').val(Name);
			$('#chkActive').checkbox('setValue',IsActive);
		}else{
			obj.RecRowID="";
			obj.layer_rd=""
			$('#txtName').val('');
			$('#chkActive').checkbox('setValue',false);
		}
			$('#layer').show();
			obj.SetDiaglog();
	}
    
    obj.gridLocRelevLoad = function(){
			$("#gridLocRelev").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.BTS.LocRelevantSrv",
				QueryName:"QryLocRelev",	
				aTypeID:$("#cboCat").combobox('getValue'),	
				aIsActive:"1",
		    	page:1,
				rows:200
			},function(rs){
				$('#gridLocRelev').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
	}
    obj.gridLocLoad = function(aRelevID){
			$("#gridLoc").datagrid("loading");	
			$cm ({
			    ClassName:"DHCHAI.BTS.LocRelevantSrv",
				QueryName:"QryLoc",	
				aHospIDs:"",
				aAlias:"",
				aLocCate:"",
				aLocType:"",
				aIsActive:"1",
				aRelev:aRelevID,
		    	page:1,
				rows:200
			},function(rs){
				$('#gridLoc').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);					
			});
	}
}