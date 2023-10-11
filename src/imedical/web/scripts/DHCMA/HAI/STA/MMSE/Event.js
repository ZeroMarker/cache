//ҳ��Event
function InitOROperCatWinEvent(obj){
	//��ť��ʼ��
    obj.LoadEvent = function(args){
		var flag ="";		
		//obj.LoadgridOROper();
		
		//����
		$('#btnAdd').on('click', function(){
			obj.OperCat('');
		});
		//�༭
		$('#btnEdit').on('click', function(){
			var rd=obj.gridOperCat.getSelected();
			obj.OperCat(rd);
		});
		
		//ɾ��
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
	 	});
		$('#btnClose').on('click', function(){
		    $HUI.dialog('#OperCatEdit').close();
	    });				
	}

    obj.btnStatDesc_Click = function(param,code,desc)
	{	
		//alert(param);
		obj.reportName=param;
	    if(obj.reportName=='') return ;

		var url ="";
		if(obj.reportName.indexOf(".csp")>=0)
		{
			url = obj.reportName;
		}else{
			url = 'dhccpmrunqianreport.csp?report='+obj.reportName+'&reportName='+obj.reportName;
		}
	    //var url = IPAddress + 'dhccpmrunqianreport.jsp?report='+obj.reportName+'&reportName='+obj.reportName;		
		OpenMenu(code,desc,url);
	};
	
	// �˵���ת
	function OpenMenu(menuCode,menuDesc,menuUrl) {
		var strUrl = '../csp/'+menuUrl+'?+&1=1';
		if ("undefined" !==typeof websys_getMWToken) {
			strUrl  += "&MWToken="+websys_getMWToken();
		}
		//���˵�
		var data = [{
			"menuId": "",
			"menuCode": menuCode,
			"menuDesc": menuDesc,
			"menuResource": strUrl,
			"menuOrder": "1",
			"menuIcon": "icon"
		}];
		if( typeof window.parent.showNavTab === 'function' ){   //bootstrap �汾
			window.parent.showNavTab(data[0]['menuCode'], data[0]['menuDesc'], data[0]['menuResource'], data[0]['menuCode'], data[0]['menuIcon'], false);
		}else{ //HISUI �汾
			window.parent.addTab({
				url:strUrl,
				title:menuDesc
			});
		}
	}
	
	//����
	$('#searchcat').searchbox({ 
		searcher:function(value,name){
			obj.gridOperCat.load({
				ClassName:"DHCHAI.IRS.CRuleOperCatSrv",
				QueryName:"QryOperCat",
				aAlias:value
			});
		}	
	});
		
	
	//�����ʼ��
	obj.OperCatEdit =function() {
		$('#OperCatEdit').dialog({
			title: 'ָ�꼯����ά��',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:true
		});
	}
	
	//�༭����-��ʼ��
	obj.OperCat = function(rd){
		if (rd){
			obj.RecRowID=rd["ID"];
			//obj.RecKeyID=rd["KeyID"];
			//var OperCat = rd["OperCat"];
			$('#txtCode').val(rd["Code"]);
			$('#txtDesc').val(rd["Desc"]);
			$('#txtStatCode').val(rd["StatCode"]);
			$('#txtStatDesc').val(rd["StatDesc"]);
			$('#txtIndNo').val(rd["IndNo"]);
			$('#txtMethod').val(rd["Method"]);
		}else {
			$('#txtCode').val("");
			$('#txtDesc').val("");
			$('#txtStatCode').val("");
			$('#txtStatDesc').val("");
			$('#txtIndNo').val("");
			$('#txtMethod').val("");
		}
		$('#OperCatEdit').show();
		obj.OperCatEdit();
	}
	//˫���༭�¼�
	obj.gridOperCat_onDbselect = function(rd){
		obj.OperCat(rd);
	}
	
	//ѡ��
	obj.gridOperCat_onSelect = function (){
		var rowData = obj.gridOperCat.getSelected();
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridOperCat.clearSelections();
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	
	//����
	obj.btnSave_click = function(){
		var ID          = obj.RecRowID;		
				
		var Code     = $('#txtCode').val();
		var Desc     = $('#txtDesc').val();
		var StatCode = $('#txtStatCode').val();
		var StatDesc = $('#txtStatDesc').val();
		var IndNo    = $('#txtIndNo').val();	
		var Method   = $('#txtMethod').val();
		
		if (Code == '') {
			$.messager.alert("������ʾ", "ͳ��ָ����벻����Ϊ��" , 'info');	
			return;
		}
		if (Desc == '') {
			$.messager.alert("������ʾ", "ͳ��ָ�����Ʋ�����Ϊ��" , 'info');
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + StatCode;
		InputStr += "^" + StatDesc;
		InputStr += "^" + IndNo;
		InputStr += "^" + Method;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID;
				
		var flg = $m({
			ClassName:"DHCHAI.STA.Navigation",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)=='-2') {
				$.messager.alert("������ʾ", "ͳ��ָ������ظ�!" , 'info');	
				return;	
			}else {
				$.messager.alert("������ʾ", "����ʧ�ܣ�" , 'info');	
				return;	
			}
		}else {
			$HUI.dialog('#OperCatEdit').close();
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			obj.RecRowID="";
			obj.gridOperCat.reload();
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
					ClassName:"DHCHAI.STA.Navigation",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert('ɾ��ʧ��!','info');					
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridOperCat.reload();
				}
			} 
		});
	}

	
}