//ҳ��Event
function InitHISUIWinEvent(obj){
	//�¼���
	obj.LoadEvents = function(arguments){

		$('#btnAdd').on('click', function(){
	     	obj.btn_AddGroup(this.id);
     	})
     	$('#btnEdit').on('click', function(){
	     	obj.btn_EditGroup(this.id);
     	})
     	$('#btnCancelEdit').on('click', function(){
	     	obj.btn_CancelEdit(this.id);
     	})
     	$('#btnDelete').on('click', function(){
	     	obj.btn_DelGroup(this.id);	
     	})
     	$('#btnSave').on('click', function(){
	     	obj.btn_SaveGroup();
	    })
	    $('#btnConfirm').on('click', function(){
		    obj.btn_Confirm();
		})
		$('#btnClose').on('click', function(){
		    obj.btn_Close();
		})
		
		$("#reSetGroup").on('click', function(){
			obj.btn_ReSetGroup();
		})
	}
	
	// ��������
	obj.btn_AddGroup = function(id) {
		obj.ViewMode="Edit";
		obj.SetBtnAvaliable(id);
		
		$.messager.popover({msg: '���ȹ�ѡָ��ҽ�����ٵ���·���������顿��ť��',type:'alert'});
		obj.gridOrders.load({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrdAll",		
			aPathFormEpDr:curFormEpID,
			aPathFormEpItemDr:"",
			aHospID:HospID,
			aOrdDesc:"",
			aOrdGroupID:"",
			page:1,
			rows:99999
		});
			
	}
	
	// �༭����
	obj.btn_EditGroup = function(id) {
		if (obj.curOrdGrpID==""){
			$.messager.popover({msg: '����ѡ����鷽����',type:'alert'});
			return;
		}
		obj.ViewMode="Edit";
		obj.gridOrders.load({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrdAll",		
			aPathFormEpDr:curFormEpID,
			aPathFormEpItemDr:"",
			aHospID:HospID,
			aOrdDesc:"",
			aOrdGroupID:"",
			page:1,
			rows:99999
		});

		obj.SetBtnAvaliable(id);
	}
	
	// ȡ���༭
	obj.btn_CancelEdit = function(id) {
		obj.ViewMode="View";
		obj.SetBtnAvaliable(id);
		
		obj.gridOrders.load({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrdAll",		
			aPathFormEpDr:curFormEpID,
			aPathFormEpItemDr:"",
			aHospID:HospID,
			aOrdDesc:"",
			aOrdGroupID:obj.curOrdGrpID,
			page:1,
			rows:99999
		});
		if (obj.curOrdGrpID==""){
			$("#txtName").val("");
			$("#txtNote").val("");	
		}
		
		$('#cboOrdGroup').combogrid('grid').datagrid("selectRecord",obj.curOrdGrpID);
	}
	
	
	// ɾ������
	obj.btn_DelGroup = function(id) {
		if (obj.curOrdGrpID==""){
			$.messager.popover({msg: '����ѡ����鷽����',type:'alert'});
			return;
		}else {
			$.messager.confirm("ȷ��","ȷ��ɾ��?",function(r){	
				if(r){
					var ordsInfo=obj.GetCurGroupOrds();		//��ȡ��������ҽ����Ϣ
					var ret = $cm({ClassName:"DHCMA.CPW.BTS.PathOrdGroupSrv",MethodName:"DeleteOrdGroupSrv",aGroupID:obj.curOrdGrpID,aOrdsInfo:ordsInfo},false);
					if(parseInt(ret)==1){
						$.messager.alert("��ʾ","ɾ���ɹ���");
						obj.cboOrdGroup.clear();
						obj.curOrdGrpID="";	
						$("#txtName").val("");
						$("#txtNote").val("");
						
						obj.btn_ReSetGroup();
						//���¼������� 
						$cm ({
							ClassName:"DHCMA.CPW.BTS.PathOrdGroupSrv",
							QueryName:"QryPathOrdGroup",
							ResultSetType:"array",
							aFormEpID:curFormEpID
						},function(rs){
							$('#cboOrdGroup').combogrid('grid').datagrid("loadData",rs);
						});	
					}else{			
						$.messager.alert("��ʾ","ɾ��ʧ�ܣ�");
					}   
				}
			})
		}
	}
	
	// �������
	obj.btn_SaveGroup = function() {
		var rows = $('#gridOrders').datagrid("getChecked");
		if (rows.length==0){
			$.messager.popover({msg: 'δ��ѡ�κ�ҽ����',type:'alert'});	 
			return	
		}
		
		var girdData = $('#cboOrdGroup').combogrid('grid');	// ��ȡ���ݱ�����
		var selRow = girdData.datagrid('getSelected');	// ��ȡѡ�����
		if (selRow!=null){
			$("#txtName").val(selRow.OrdGroupDesc);
			$("#txtNote").val(selRow.OrdGroupNote);
		}
		$HUI.dialog('#winOrdGroupEdit').open();
	}
	
	// �������-ȷ���¼�
	obj.btn_Confirm = function(){	
		var rows = $('#gridOrders').datagrid("getRows");
		if(rows.length==0) {
			$.messager.popover({msg: 'δ��ѡ�κ�ҽ����',type:'alert'});	 
			return;
		}
		if($("#txtName").val()==""){
			$.messager.popover({msg: '����д�������ƣ�',type:'alert'});	 
			return;	
		}
		var chkGroupName=$m({
			ClassName:"DHCMA.CPW.BTS.PathOrdGroupSrv",
			MethodName:"CheckNameIsExist",
			aFormEpDr:curFormEpID,
			aGroupName:$("#txtName").val(),
			aGroupID:obj.curOrdGrpID
		},false);
		if (parseInt(chkGroupName)==1) {
			$.messager.alert("������ʾ","���׶����Ѵ���ͬ�����飬���޸ķ������������ύ��", 'info');
			return;
		}

		var ordsInfo=""
		$.each(rows, function(i, item){
   			{
	   			var isChecked=$("#gridOrders").parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(i).checkbox('getValue');		//��ȡcheckboxѡ��״̬
				var isChecked=isChecked?"1":"0";
				ordsInfo=ordsInfo+CHR_1+isChecked+"^"+item.xID;
	   		}
		})
		ordsInfo=ordsInfo.substr(1,ordsInfo.length)
				
		$cm({
			ClassName:"DHCMA.CPW.BTS.PathOrdGroupSrv",
			MethodName:"SplitOrdGroupSrv",
			aOrdsOrTCMInfo:ordsInfo,
			aGroupID:obj.curOrdGrpID,
			aGroupName:$("#txtName").val(),
			aGroupNote:$("#txtNote").val(),
			aFormEpID:curFormEpID,
			dataType:"text"
		},function(ret){
			if (parseInt(ret.split("^")[0])<0) {
				$.messager.alert("������ʾ","�������ݴ���!Error=" + flg, 'info');
				return;
			} else {
				$.messager.alert("��ʾ","����ɹ�");
			}
		})
		$HUI.dialog('#winOrdGroupEdit').close();
		$cm ({
			ClassName:"DHCMA.CPW.BTS.PathOrdGroupSrv",
			QueryName:"QryPathOrdGroup",
			ResultSetType:"array",
			aFormEpID:curFormEpID
		},function(rs){
			$('#cboOrdGroup').combogrid('grid').datagrid("loadData",rs);		
		});
		
		obj.btn_CancelEdit();
		
	}
	
	// �������-�ر��¼�
	obj.btn_Close = function(){
		$HUI.dialog('#winOrdGroupEdit').close();	
	}
	
	//��ʾ������Ϣ��ϸ
	obj.ShowFJDetail = function(FJid){
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
			$HUI.popover('#pop'+FJid,{content:PopHtml,trigger:'hover',placement:'auto-right'});
			$('#pop'+FJid).popover('show');
		})
	}
	//���ٷ�����ϸ��ʾ
	obj.DestoryFJDetail = function(FJid){
		$('#pop'+FJid).popover('destroy');
	}
	
	//��ȡ��ǰ������ҽ����Ϣ����ɾ������ʹ��
	obj.GetCurGroupOrds = function(){
		var rows = $('#gridOrders').datagrid("getRows");
		if(rows.length==0) {
			return "";
		}
		
		var ordsInfo=""
		$.each(rows, function(i, item){
   			{
				var isChecked="0";
				ordsInfo=ordsInfo+CHR_1+isChecked+"^"+item.xID;
	   		}
		})
		ordsInfo=ordsInfo.substr(1,ordsInfo.length)
		return ordsInfo;
	}
	
	// �ָ���ʾȫ��ҽ��
	obj.btn_ReSetGroup = function(){
		obj.ViewMode="View";
		obj.cboOrdGroup.clear();
		obj.curOrdGrpID="";	
		$("#txtName").val("");
		$("#txtNote").val("");
		obj.SetBtnAvaliable();
				
		$cm ({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrdAll",
			ResultSetType:"array",
			aPathFormEpDr:curFormEpID,
			aPathFormEpItemDr:"",
			aHospID:HospID,
			aOrdDesc:"",
			aOrdGroupID:obj.curOrdGrpID,
			page:1,
			rows:99999
		},function(rs){
			$('#gridOrders').datagrid('loadData', rs);				
		});		
	}
	
	// ͳһ���ð�ť������
	obj.SetBtnAvaliable = function(id){
		if (obj.ViewMode=="View"){
			$('#gridOrders').datagrid('hideColumn','checkOrd');
			$("#div-south").css("display","none");
		
			//�����м䲼�ָ߶�
			var win_height = $("#cc").height();
			var c=$('#cc').layout('panel',"center");
			c.panel('resize',{height:win_height});
		}else{
			$('#gridOrders').datagrid('showColumn','checkOrd'); 		//��ʾ��
			$("#div-south").css("display","block");
			$.parser.parse();
		}
		switch (id){
			case "btnAdd":
				$('#btnAdd').linkbutton("disable");
				$('#btnEdit').linkbutton("disable");
				$('#btnDelete').linkbutton("disable");
				$('#btnCancelEdit').linkbutton("enable");
				$("#cboOrdGroup").combogrid("enable");
				break;
			case "btnEdit":
				$('#btnAdd').linkbutton("disable");
				$('#btnEdit').linkbutton("disable");
				$('#btnDelete').linkbutton("disable");
				$('#btnCancelEdit').linkbutton("enable");
				$("#cboOrdGroup").combogrid("disable");
				break;
			case "btnDelete":
				$('#btnAdd').linkbutton("enable");
				$('#btnEdit').linkbutton("disable");
				$('#btnDelete').linkbutton("disable");
				$('#btnCancelEdit').linkbutton("enable");
				$("#cboOrdGroup").combogrid("enable");
				break;
			default:
				if (obj.curOrdGrpID==""){
					$('#btnAdd').linkbutton("enable");
					$('#btnEdit').linkbutton("disable");
					$('#btnDelete').linkbutton("disable");
					$('#btnCancelEdit').linkbutton("disable");
				}else{
					$('#btnAdd').linkbutton("disable");
					$('#btnEdit').linkbutton("enable");
					$('#btnDelete').linkbutton("enable");
					$('#btnCancelEdit').linkbutton("disable");
				}
				$("#cboOrdGroup").combogrid("enable");
		}			
	}

}